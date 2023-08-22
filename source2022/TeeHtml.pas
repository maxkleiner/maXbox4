{**********************************************}
{   Html Text mini-parser.                     }
{   Copyright (c) 2004-2007 by David Berneda   }
{   All Rights Reserved                        }
{**********************************************}
unit TeeHtml;
{$I TeeDefs.inc}

interface

uses
  {$IFNDEF LINUX}
  Windows,
  {$ENDIF}
  Classes, SysUtils,
  {$IFDEF CLX}
  QGraphics,
  {$ELSE}
  Graphics,
  {$ENDIF}
  {$IFDEF CLR}
  System.IO,
  {$ENDIF}
  TeCanvas;

type
  TSize=packed record
    Width  : Integer;
    Height : Integer;
  end;

// Used by TTeeCanvas class at TeCanvas.pas unit.
procedure HtmlTextOut(ACanvas:TTeeCanvas; x,y:Integer; Text:String);
function HtmlTextExtent(ACanvas:TTeeCanvas; const Text:String):TSize;

// Pseudo-Internal hooks
var
  GraphicFileExtension : function(const FileExtension:String):TGraphic;
  GraphicDownload : function(const URL:String; Stream:TStream):Integer;

implementation

const
  CRLF=#$D#$A;

var State,
    StateFont : TStringList;

type
  HtmlParserException=class(Exception);

{ returns number of sections in St string separated by ";" }
Function HtmlNumFields(St:String):Integer;
var i : Integer;
begin
  result:=0;

  repeat
    i:=Pos('=',St);
    if i>0 then
    begin
      Delete(St,1,i);
      Inc(result);
    end;
  until i=0;
end;

procedure HtmlField(s:String; Index:Integer; var left,right:String);
var i,i2,num : Integer;
begin
  left:='';
  right:='';
  num:=0;

  repeat
    i:=Pos('=',s);
    if i>0 then
    begin
      left:=Trim(Copy(s,1,i-1));
      Delete(S,1,i);
      Inc(num);

      if num=Index then
      begin
        i:=Pos('=',s);
        if i=0 then right:=Trim(s)
        else
        begin
          Dec(i);
          while Copy(s,i,1)<>' ' do Dec(i);
          right:=Trim(Copy(s,1,i-1));
          i:=0;
        end;
      end
      else
      begin
        i2:=Pos('=',s);

        if i2=0 then s:=''
        else
        begin
          Dec(i2);
          while Copy(s,i2,1)<>' ' do Dec(i2);
          Delete(s,1,i2);
        end;
      end;
    end;
  until i=0;
end;

procedure PushState(const s:String);
begin
  State.Add(s);
end;

procedure PushFont(const s:String);
begin
  StateFont.Add(s);
end;

function PopState:String;
begin
  if State.Count=0 then result:=''
  else
  begin
    result:=State.Strings[State.Count-1];
    State.Delete(State.Count-1);
  end;
end;

function PopFont:String;
begin
  if StateFont.Count=0 then result:=''
  else
  begin
    result:=StateFont.Strings[StateFont.Count-1];
    StateFont.Delete(StateFont.Count-1);
  end;
end;

function InternalHtmlText(ACanvas:TTeeCanvas; x,y:Integer; Text:String; Display:Boolean):TSize;

 function GetToken(var st:String):String;
 var i : Integer;
 begin
   i:=Pos('<',st);
   if i=0 then
   begin
     result:=st;
     st:='';
   end
   else
   if i>1 then
   begin
     result:=Copy(st,1,i-1);
     Delete(st,1,i-1);
   end
   else
   begin
     Delete(st,1,1);
     i:=Pos('>',st);

     if i=0 then
        Raise HtmlParserException.Create('Missing > at '+st)
     else
     begin
       result:='<'+Copy(st,1,i);
       Delete(st,1,i);
     end;
   end;
 end;

var
  PushedFont:Boolean;

  procedure PushCurrentFont;

    Function FontWeight:String;
    begin
      if fsBold in ACanvas.Font.Style then result:='BOLD' else result:='';

      if fsItalic in ACanvas.Font.Style then
         if result='' then result:='ITALIC' else result:=result+', ITALIC';

      if fsUnderline in ACanvas.Font.Style then
         if result='' then result:='UNDERLINE' else result:=result+', UNDERLINE';

      if fsStrikeout in ACanvas.Font.Style then
         if result='' then result:='STRIKE' else result:=result+', STRIKE';

      if result='' then result:='NORMAL';
    end;

  begin
    PushFont('<FONT size='+IntToStr(ACanvas.Font.Size)+' name='+ACanvas.Font.Name+
      ' color='+IntToStr(ACanvas.Font.Color)+' weight='+FontWeight+'>');

    PushedFont:=True;
  end;

  Function HexToColor(S:String):TColor;
  begin
    S:=Trim(S);

    if Copy(s,1,1)='#' then
       result:=RGB(StrToInt('$'+Copy(s,2,2)),
                   StrToInt('$'+Copy(s,4,2)),
                   StrToInt('$'+Copy(s,6,2)))
    else
      // clTeeColor, can't use TeEngine unit here to avoid circular
      {$IFDEF D6}
      result:=TColor(clDefault);
      {$ELSE}
      result:=TColor($20000000);
      {$ENDIF}
  end;

  function HtmlToColor(s:String):TColor;
  begin
    s:=Trim(UpperCase(s));

    if s='BLACK' then result:=clBlack else
    if s='RED' then result:=clRed else
    if s='BLUE' then result:=clBlue else
    if s='YELLOW' then result:=clYellow else
    if s='WHITE' then result:=clWhite else
    if s='GREEN' then result:=clGreen else
    if s='LIME' then result:=clLime else

    if Copy(s,1,1)='#' then
       result:=HexToColor(s)
    else
       result:=StringToColor(s);
  end;

  // <font name="Arial" family="Arial" size=+4 weight=bold color=#12285c  >
  procedure ProcessFont(s:String);
  var t,i:Integer;
      tmpSize, Left, Right:String;
  begin
    Delete(s,1,6);
    Delete(s,Length(s),1);

    i:=HtmlNumFields(s);
    for t:=1 to i do
    begin
      HtmlField(s,t,left,right);

      left:=UpperCase(left);

      if (left='NAME') or (left='FAMILY') then ACanvas.Font.Name:=right
      else
      if left='SIZE' then
      begin
        tmpSize:=Copy(right,1,1);

        if (tmpSize='+') or (tmpSize='-') then
           ACanvas.Font.Size:=ACanvas.Font.Size+StrToInt(right)
        else
           ACanvas.Font.Size:=StrToInt(right)
      end
      else
      if left='COLOR' then ACanvas.Font.Color:=HtmlToColor(right)
      else
      if left='WEIGHT' then
      begin
        right:=UpperCase(Right);

        if right='BOLD' then ACanvas.Font.Style:=[fsBold] else
        if right='ITALIC' then ACanvas.Font.Style:=[fsItalic] else
        if right='NORMAL' then ACanvas.Font.Style:=[] else
        if right='STRIKE' then ACanvas.Font.Style:=[fsStrikeOut] else
        if right='UNDERLINE' then ACanvas.Font.Style:=[fsUnderline]
        else
          raise Exception.Create('Unknown field in FONT WEIGHT='+right);
      end
      else
          raise Exception.Create('Unknown field in FONT: '+left);
    end;
  end;

var
  OldX : Integer;
  IsCenter : Boolean;
  MaxSizeY : Integer;

  function DoStringReplace(const S, OldPattern, NewPattern: string): string;
  var
    SearchStr, Patt, NewStr: string;
    Offset: Integer;
  begin
    SearchStr := S;
    Patt := OldPattern;
    NewStr := S;
    Result := '';

    while SearchStr <> '' do
    begin
      Offset := Pos(Patt, SearchStr);
      if Offset = 0 then
      begin
        Result := Result + NewStr;
        Break;
      end;

      Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
      NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
      SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
    end;
  end;

  procedure OutputText(tmp:String);
  var HasReturn : Boolean;
      SizeY,
      SizeX     : Integer;
  begin
    // Pending: more special characters
    tmp:=DoStringReplace(tmp,'&lt;','<');
    tmp:=DoStringReplace(tmp,'&gt;','>');
    tmp:=DoStringReplace(tmp,'&amp;','&');
    tmp:=DoStringReplace(tmp,'&quot;','"');

    HasReturn:=Copy(tmp,Length(tmp)-1,2)=CRLF;
    if HasReturn then
       Delete(tmp,Length(tmp)-1,2);

    if tmp<>'' then
    begin
      SizeX:=ACanvas.TextWidth(tmp);

      if IsCenter then
      begin
        x:=(ACanvas.Bounds.Left+ACanvas.Bounds.Right) div 2;
        x:=x-(SizeX div 2);
      end;

      SizeY:=ACanvas.TextHeight(tmp);

      if MaxSizeY=0 then
      begin
        MaxSizeY:=ACanvas.FontHeight;
        Inc(y,MaxSizeY);
      end
      else
      if SizeY<MaxSizeY then
         Inc(y,MaxSizeY-SizeY-1);

      if Display then
         ACanvas.TextOut(x,y,tmp);

      Inc(x,SizeX);

      if x>result.Width then
         result.Width:=x;

      if SizeY>MaxSizeY then
         MaxSizeY:=SizeY;

      if MaxSizeY>result.Height then
         result.Height:=MaxSizeY;
    end;

    if HasReturn then
    begin
      MaxSizeY:=0;
      x:=OldX;
    end;
  end;

  procedure SetBackFont;
  begin
    ProcessFont(PopFont)
  end;

  procedure ImageNotFound(x,y,Width,Height:Integer);
  begin
    if Width=0 then Width:=40;
    if Height=0 then Height:=40;

    with ACanvas do
    begin
      Pen.Style:=psSolid;
      Pen.Color:=clRed;
      Pen.Width:=1;
      Brush.Style:=bsSolid;
      Brush.Color:=clWhite;
      Rectangle(x,y,x+Width,y+Height);

      MoveTo(x,y);
      LineTo(x+Width-1,y+Height-1);
      MoveTo(x,y+Height-1);
      LineTo(x+Width-1,y);
    end;
  end;

  procedure DoImage(tmpU:String);

    function RemoveQuotes(const S:String):String;
    var l : Integer;
    begin
      result:=S;
      if Copy(result,1,1)='"' then
         Delete(result,1,1);
      l:=Length(result);
      if Copy(result,l,1)='"' then
         Delete(result,l,1);
    end;

  var i,t,
      tmpW,
      tmpH  : Integer;
      tmpURL,
      Left,
      Right : String;
      {$IFDEF URLDEBUG}
      tmpSt : TStringList;
      {$ENDIF}
      tmpS  : TMemoryStream;
      g     : TGraphic;
      tmpOk : Integer;
  begin
    tmpW:=0;
    tmpH:=0;
    tmpURL:='';

    Delete(tmpU,1,5);

    if Copy(tmpU,1,2)=CRLF then
       Delete(tmpU,1,2);

    if Copy(tmpU,Length(tmpU),1)='>' then
       Delete(tmpU,Length(tmpU),1);

    i:=HtmlNumFields(tmpU);
    for t:=1 to i do
    begin
      HtmlField(tmpU,t,left,right);
      left:=UpperCase(left);
      if left='WIDTH' then tmpW:=StrToInt(Right) else
      if left='HEIGHT' then tmpH:=StrToInt(Right) else
      if left='SRC' then tmpURL:=Right; // more img attribs ?
    end;

    if tmpURL<>'' then
    begin
      tmpURL:=RemoveQuotes(Trim(tmpURL));

      tmpS:=TMemoryStream.Create;
      try
        left:=UpperCase(ExtractFileExt(tmpURL));

        g:=GraphicFileExtension(Left);

        if not Assigned(g) then
        begin
          ImageNotFound(x,y,tmpW,tmpH);
          exit;
        end;

        try
          tmpOk:=GraphicDownload(tmpURL,tmpS);

          if (tmpOk=0) and (tmpS.Size>0) then
          begin
            tmpS.Position:=0;

            try
              {$IFDEF URLDEBUG}
              tmpSt:=TStringList.Create;
              tmpSt.LoadFromStream(tmpS);
              {$ENDIF}

              g.LoadFromStream(tmpS);

              {$IFDEF URLDEBUG}
              tmpSt.Free;
              {$ENDIF}

              if tmpW=0 then tmpW:=g.Width;
              if tmpH=0 then tmpH:=g.Height;

              if (tmpW<>g.Width) or (tmpH<>g.Height) then
                 ACanvas.StretchDraw(TeeRect(x,y,x+tmpW,y+tmpH),g)
              else
                 ACanvas.Draw(x,y,g);

              Inc(x,tmpW);
              Inc(y,tmpH);
            except
              on Exception do ImageNotFound(x,y,tmpW,tmpH);
            end;
          end
          else ImageNotFound(x,y,tmpW,tmpH);
        finally
          g.Free;
        end;
      finally
        tmpS.Free;
      end;
    end;
  end;

var
  IsLastFont : Boolean;

  procedure DoToken(tmp:String);

    procedure NewSize(ASize:Integer);
    begin
      PushCurrentFont;
      ACanvas.Font.Size:=ASize;
    end;

  var tmpU,tmpS : String;
  begin
    PushedFont:=False;

    if Copy(tmp,1,2)=CRLF then
    begin
      Inc(y,ACanvas.FontHeight);
      x:=OldX;
      MaxSizeY:=0;

      Delete(tmp,1,2);
    end;

    if tmp='' then exit;

    tmpU:=UpperCase(tmp);


    if (tmpU='<BR>') or (tmpU='<P>') then  // Paragraphs here !!
    begin
      x:=OldX;
      MaxSizeY:=0;  // "y" will be incremented later.
    end
    else
    if tmpU='<BIG>' then
       NewSize(ACanvas.Font.Size+2)
    else
    if tmpU='<SMALL>' then
       NewSize(ACanvas.Font.Size-2)
    else
    if tmpU='</SUB>' then
    begin
      SetBackFont;
      Dec(y,ACanvas.FontHeight);
    end
    else
    if tmpU='<SUB>' then
    begin
      NewSize(ACanvas.Font.Size div 2);
      Inc(y,ACanvas.FontHeight);
    end
    else
    if tmpU='</SUPER>' then
    begin
      SetBackFont;
      Inc(y,ACanvas.FontHeight div 2);
    end
    else
    if tmpU='<SUPER>' then
    begin
      NewSize(ACanvas.Font.Size div 2);
      Dec(y,ACanvas.FontHeight div 2);
    end
    else
    if tmpU='<H1>' then NewSize(48) else
    if tmpU='<H2>' then NewSize(36) else
    if tmpU='<H3>' then NewSize(24) else
    if tmpU='<H4>' then NewSize(18) else
    if tmpU='<H5>' then NewSize(12) else
    if tmpU='<H6>' then NewSize(8) else

//      if tmpU='<BLINK>' then ...
//      else
    if tmpU='<PRE>' then
    begin
      PushCurrentFont;
      ProcessFont('<FONT NAME="COURIER NEW">');
    end
    else
    if tmpU='<CENTER>' then
       IsCenter:=True
    else
    if (tmpU='<B>') or (tmpU='<BOLD>') or (tmpU='<STRONG>') then
    begin
      ACanvas.Font.Style:=ACanvas.Font.Style+[fsBold];
      PushState(tmpU);
    end
    else
    if tmpU='<I>' then
    begin
      ACanvas.Font.Style:=ACanvas.Font.Style+[fsItalic];
      PushState(tmpU);
    end
    else
    if tmpU='<U>' then
    begin
      ACanvas.Font.Style:=ACanvas.Font.Style+[fsUnderline];
      PushState(tmpU);
    end
    else
    if tmpU='<STRIKE>' then
    begin
      ACanvas.Font.Style:=ACanvas.Font.Style+[fsStrikeOut];
      PushState(tmpU);
    end
    else
    if Copy(tmpU,1,5)='<IMG ' then DoImage(tmp)
    else
    if (tmpU='</B>') or (tmpU='</BOLD>') or (tmpU='</STRONG>') then
       ACanvas.Font.Style:=ACanvas.Font.Style-[fsBold]
    else
    if tmpU='</I>' then ACanvas.Font.Style:=ACanvas.Font.Style-[fsItalic]
    else
    if tmpU='</U>' then ACanvas.Font.Style:=ACanvas.Font.Style-[fsUnderline]
    else
    if tmpU='</STRIKE>' then ACanvas.Font.Style:=ACanvas.Font.Style-[fsStrikeOut]
    else
    if Copy(tmpU,1,6)='</FONT' then
       SetBackFont // ProcessFont(tmpU)
    else
    if tmpU='</PRE>' then SetBackFont
    else
    if tmpU='</CENTER>' then IsCenter:=False
    else
    if Copy(tmpU,1,6)='<FONT ' then
    begin
      PushCurrentFont;
      ProcessFont(tmpU);
    end
    else
    if tmpU='</>' then
    begin
      if IsLastFont then SetBackFont
      else
      begin
        tmpS:=PopState;
        Delete(tmpS,1,1);
        DoToken('</'+tmpS);
      end;
    end
    else
    if tmpU='<HR>' then
    begin
      x:=OldX;

      with ACanvas.Pen do
      begin
        Style:=psSolid;
        Width:=1;
        Color:=clDkGray;
      end;

      ACanvas.DoHorizLine(x,x+100,y);  // 100 ?
      Inc(y,ACanvas.FontHeight);
    end
    else
    begin
      OutputText(tmp);
      Exit;
    end;

    IsLastFont:=PushedFont;
  end;

var tmp : String;
begin
  result.Width:=0;
  result.Height:=0;

  OldX:=X;
  IsCenter:=False;
  MaxSizeY:=ACanvas.FontHeight;

  repeat
    tmp:=GetToken(Text);
    if tmp<>'' then
       DoToken(tmp);
  until tmp='';
end;

function HtmlTextExtent(ACanvas:TTeeCanvas; const Text:String):TSize;
begin
  result:=InternalHtmlText(ACanvas,0,0,Text,False);
end;

procedure HtmlTextOut(ACanvas:TTeeCanvas; x,y:Integer; Text:String);
begin
  InternalHtmlText(ACanvas,x,y,Text,True);
end;

initialization
  State:=TStringList.Create;
  StateFont:=TStringList.Create;
finalization
  StateFont.Free;
  State.Free;
end.
