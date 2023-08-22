{ TPrintGrid Component VERSION 1.0 4-1995 }
{ Allows to print a DBGrid with some configuration }
{ Sorry for my english. Some parts of this code are in catalan-spanish }

{ some corrections max kleiner 10.7.96
{ Send me your comments and remember: ITS BETA, ITS FREE AND YOU HAVE THE SOURCES }
{ Good luck !!!}

unit Printgri;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,DBGrids;

Const MaxPages=1000;
      MaxCols=100;

      TopMargin     =1;
      BottomMargin  =2;
      LeftMargin    =3;
      RightMargin   =4;

type
  TPageNumberPos=(pnNone, pnTopLeft,pnTopCenter,pnTopRight,
                          pnBotLeft,pnBotCenter,pnBotRight);

  TPrintGrid = class(TComponent)
  private
    { Private declarations }
    tmpFile         :Text;
    FDBGrid         :TDBGrid;
    FHeaderInTitle  :Boolean;
    FHeaderAlign    :TAlignment;
    FLinesFont,
    FHeaderFont,
    FTitleFont      :TFont;
    FPageNLabel     :String;
    FPageNPos       :TPageNumberPos;
    FScreenViewer,
    FHeader,
    FPrintADMTitle  :String;
    FirstRecordY,
    LinesWidth,
    LinesHeight,
    RecCounter      :Longint;
    FToScreen,
    FTitulosAlign   :Boolean;
    tmpPageNo,
    FFromPage,
    FToPage         :Longint;
    NPositions     :Integer;
    FMargins        :Array[1..4] of Integer; { top,bottom,left,right }
    Positions       :Array[1..MaxCols] of Longint;
    FColLines,
    FRowLines,
    FBorder         :Boolean;
    HorizGap,
    VertGap         :Integer;
    Procedure WriteLineScreen(Const S:String);
    Function GetMargins(Index:Integer):Integer;
    Procedure SetMargins(Index:Integer; Value:Integer);
  protected
    { Protected declarations }
  public
    { Public declarations }
    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;
    Procedure Print;
    Procedure PrintDialog;
    property Margins[Index:Integer]:Integer read GetMargins write SetMargins;
    property TitleFont:TFont read FTitleFont write FTitleFont;
    property HeaderFont:TFont read FHeaderFont write FHeaderFont;
    property LinesFont:TFont read FLinesFont write FLinesFont;
  published
    { Published declarations }
    property DBGrid:TDBGrid read FDBGrid write FDBGrid;
    property PrintAdmTitle:String read FPrintADMTitle write FPrintADMTitle;
    property HeaderInTitle:Boolean read FHeaderInTitle write FHeaderinTitle;
    property Header:String read FHeader write FHeader;
    property HeaderAlignment:TAlignment read FHeaderAlign write FHeaderAlign;
    property ToScreen:Boolean read FToScreen write FToScreen;
    property ScreenViewer:String read FScreenViewer write FScreenViewer;
    property FromPage:Longint read FFromPage write FFromPage;
    property ToPage:Longint read FToPage write FToPage;
    property Border:Boolean read FBorder write FBorder;
    property ColLines:Boolean read FColLines write FColLines;
    property RowLines:Boolean read FRowLines write FRowLines;
    property AlignedTitles:Boolean read FTitulosAlign write FTitulosAlign;
    property HorizontalGap:Integer read HorizGap write HorizGap;
    property VerticalGap:Integer read VertGap write VertGap;
    property PageNumberPos:TPageNumberPos read FPageNPos write FPageNPos;
    property PageNumberLabel:String read FPageNLabel write FPageNLabel;
  end;

procedure Register;

implementation

Uses Printers,DB;

Function TPrintGrid.GetMargins(Index:Integer):Integer;
Begin
  result:=FMargins[Index];
End;

Procedure TPrintGrid.SetMargins(Index:Integer; Value:Integer);
Begin
  FMargins[Index]:=Value;
End;

Procedure TPrintGrid.WriteLineScreen(Const S:String);
Begin
  if (tmpPageNo>=FFromPage) and
     (tmpPageNo<=FToPage) then Writeln(tmpFile,s);
End;

Destructor TPrintGrid.Destroy;
Begin
  FTitleFont.Free;
  FHeaderFont.Free;
  FLinesFont.Free;
  inherited Destroy;
End;

Constructor TPrintGrid.Create(AOwner:TComponent);
Begin
  inherited Create(AOwner);
  FTitleFont:=TFont.Create;
  FHeaderFont:=TFont.Create;
  FLinesFont:=TFont.Create;
  { DEFAULT VALUES FOR ALL PROPERTIES }
  FDBGrid:=nil;
  FHeader:='';
  FPrintADMTitle:='';
  RecCounter:=0;
  HorizGap:=2;
  FMargins[TopMargin]:=0;
  FMargins[BottomMargin]:=0;
  FMargins[LeftMargin]:=0;
  FMargins[RightMargin]:=0;
  FToScreen:=False;
  FScreenViewer:='';
  FFromPage:=1;
  FToPage:=MaxPages;
  FTitulosAlign:=True;
  FBorder:=True;
  FColLines:=True;
  FRowLines:=False;
  FHeaderAlign:=taCenter;
  FHeaderIntitle:=False;
  FPageNPos:=pnTopRight;
  FPageNLabel:='Page: ';
End;

Procedure TPrintGrid.Print;

  Function Max(a,b:Longint):Longint; { typical function... }
  Begin
    if a>b then result:=a else result:=b;
  End;

  Function ConstStr(C:Char; N:Integer):String; { returns a filled string }
  Var S:String;
  Begin
    if n>0 then
    Begin
      S[1] := Chr(N);
      FillChar(s[1],N,Ord(C));
      result:=S;
    end
    else result:='';
  end;

  Function OpenTextForWrite(var f:text; Const ss:String):Boolean;
  Begin
    if ss<>'' Then
    Begin
     {$I-}
     AssignFile(f,ss);
     rewrite(f);
     {$I+}
     result:=(ioresult=0);
   End Else result:=False;
  End;

  Function LongiScreen(tmp:TField):Longint;
  begin
    result:=Max(tmp.DisplayWidth,Length(tmp.DisplayLabel));
  end;

  Function RestoBlancos(tmp:TField; Const Prefijo:String):String;
  begin
    result:=ConstStr(' ',LongiScreen(tmp)-Length(Prefijo));
  end;

  Function TitleWidth(Const S:String):Longint;
  Var tmpFont:TFont;
  Begin
    With Printer.Canvas do
    Begin
      tmpFont:=TFont.Create;
      tmpFont.Assign(Font);
      Font.Assign(FTitleFont);
      result:=TextWidth(s);
      Font.Assign(tmpFont);
      tmpFont.Free;
    End;
  End;

  Function TitleHeight:Longint;
  Var tmpFont:TFont;
  Begin
    With Printer.Canvas do
    Begin
      tmpFont:=TFont.Create;
      tmpFont.Assign(Font);
      Font.Assign(FTitleFont);
      result:=TextHeight('M');
      Font.Assign(tmpFont);
      tmpFont.Free;
    End;
  End;

  Procedure CalculatePositions;
  Var longitud,t:Longint;
  Begin
    NPositions:=0;
    if FBorder then Positions[1]:=1 else Positions[1]:=0;
    With FDBGrid.DataSource.DataSet do
    for t:=0 to FieldCount-1 do
    With Fields[t] do
    if Visible then
    Begin
      inc(NPositions);
      longitud:=Max(TitleWidth(Fields[t].DisplayLabel),
                    (LinesWidth*Fields[t].DisplayWidth));
      Positions[NPositions+1]:=Positions[NPositions]+Longitud+HorizGap;
    End;
  End;

  Function SetAlign(align:TAlignment; Left,Right:Longint):Longint;
  Var PosX:Longint;
  Begin
    with Printer.Canvas do
    Begin
      case Align of
        taLeftJustify : SetTextAlign(Handle,TA_LEFT);
        taRightJustify: SetTextAlign(Handle,TA_RIGHT);
        taCenter      : SetTextAlign(Handle,TA_CENTER);
      End;
      case Align of
        taLeftJustify:  PosX:=Left+HorizGap;
        taRightJustify: PosX:=Right-HorizGap;
        taCenter      : PosX:=Left+Round((Right-Left)/2);
      end;
    End;
    result:=PosX;
  End;

  Function SetPagePos(PagePos:TPageNumberPos; Left,Right:Longint):Longint;
  Var PosX:Longint;
  Begin
    with Printer.Canvas do
    Begin
      case PagePos of
        pnTopLeft,
        pnBotLeft:   Begin SetTextAlign(Handle,TA_LEFT); PosX:=Left+HorizGap; End;
        pnTopRight,
        pnBotRight:  Begin SetTextAlign(Handle,TA_RIGHT); PosX:=Right-HorizGap; End;
        pnTopCenter,
        pnBotCenter: Begin SetTextAlign(Handle,TA_CENTER); PosX:=Left+Round((Right-Left)/2); End;
      End;
    End;
    result:=PosX;
  End;

  Function PrepareAlign(Field:TField; Col:Integer):Longint;
  Begin
    result:=SetAlign(Field.Alignment,Positions[col],Positions[col+1]);
  End;

  Procedure WriteHeaderToPrinter;
  Var col,PosX,t,tmpTitleHeight:Longint;
      s:String;
      TmpFont:TFont;
  Begin
    if (tmpPageNo>=FFromPage) and
       (tmpPageNo<=FToPage) then
    Begin
      tmpTitleHeight:=TitleHeight;
      if (FHeader<>'') Or (FPageNPos in [pnTopLeft,pnTopCenter,pnTopRight]) then
      With Printer.Canvas do
      Begin
        tmpFont:=TFont.Create;
        tmpFont.Assign(Font);
        Font.Assign(FHeaderFont);
        PosX:=SetAlign(FHeaderAlign,FMargins[LeftMargin],
                              FMargins[LeftMargin]+Positions[NPositions+1]);
        TextOut(PosX,FMargins[TopMargin],FHeader);
        FirstRecordY:=FMargins[TopMargin]+TextHeight('M')+tmpTitleHeight;
        PosX:=SetPagePos(FPageNPos,FMargins[LeftMargin],
                              FMargins[LeftMargin]+Positions[NPositions+1]);
        TextOut(PosX,FMargins[TopMargin],FPageNLabel+IntToStr(tmpPageNo));
        Font.Assign(tmpFont);
        tmpFont.Free;
      End
      Else FirstRecordY:=FMargins[TopMargin]+tmpTitleHeight;

      if FBorder Then
      Begin
        if FHeaderinTitle then
         Printer.Canvas.Rectangle(FMargins[LeftMargin],FMargins[TopMargin],
                          FMargins[LeftMargin]+Positions[NPositions+1],
                          Printer.PageHeight-FMargins[BottomMargin])
        else
         Printer.Canvas.Rectangle(FMargins[LeftMargin],FirstRecordY-tmpTitleHeight,
                          FMargins[LeftMargin]+Positions[NPositions+1],
                          Printer.PageHeight-FMargins[BottomMargin])
      end;
      if FColLines then
      With Printer.Canvas do
      for t:=2 to NPositions do
      Begin
        MoveTo(FMargins[LeftMargin]+Positions[t],FirstRecordY);
        LineTo(FMargins[LeftMargin]+Positions[t],Printer.PageHeight-FMargins[BottomMargin]);
      End;
      col:=0;
      With FDBGrid.DataSource.DataSet do
      With Printer.Canvas do
      Begin
        tmpFont:=TFont.Create;
        tmpFont.Assign(Font);
        Font.Assign(FTitleFont);
        for t:=0 to FieldCount-1 do
        With Fields[t] do
        if Visible then
        Begin
          inc(Col);
          PosX:=PrepareAlign(Fields[t],Col);
          TextOut(FMargins[LeftMargin]+PosX,FirstRecordY-tmpTitleHeight,DisplayLabel);
        End;
        moveto(FMargins[LeftMargin],FirstRecordY);
        Lineto(FMargins[LeftMargin]+Positions[NPositions+1],FirstRecordY);
        Font.Assign(tmpFont);
        tmpFont.Free;
      End;
    End;
  End;

  Procedure WriteHeader;
  Var t:Longint;
      s,slin:String;
  Begin
    if FToScreen then
    With FDBGrid.DataSource.DataSet do
    Begin
      WriteLineScreen(FHeader);
      WriteLineScreen('');
      s:='';
      slin:='';
      for t:=0 to FieldCount-1 do
      With Fields[t] do
      if Visible then
      Begin
        if (Not AlignedTitles) or (Alignment=taLeftJustify) then
        Begin
          s:=s+DisplayLabel;
          s:=s+RestoBlancos(Fields[t],DisplayLabel)+' ';
        End
        Else
        Begin
          s:=s+RestoBlancos(Fields[t],DisplayLabel);
          s:=s+DisplayLabel+' ';
        End;
        slin:=slin+ConstStr('-',LongiScreen(Fields[t]))+' ';
      End;
      WriteLineScreen(s);
      WriteLineScreen(slin);
    End
    Else WriteHeaderToPrinter;
  End;

  Procedure WriteRecordToPrinter;
  var Col,t,PosX,PosY:Longint;
      tmpFont:TFont;
  Begin
    if (tmpPageNo>=FFromPage) and
       (tmpPageNo<=FToPage) then
    Begin
      With FDBGrid.DataSource.DataSet do
      Begin
        Col:=0;
        PosY:=FirstRecordY+RecCounter*LinesHeight;
        for t:=0 to FieldCount-1 do
        With Fields[t] do
        if Visible then
        With Printer.Canvas do
        Begin
          tmpFont:=TFont.Create;
          tmpFont.Assign(Font);
          Font.Assign(FLinesFont);
          inc(Col);
          PosX:=PrepareAlign(Fields[t],Col);
          TextOut(FMargins[LeftMargin]+PosX,PosY,DisplayText);
          Font.Assign(tmpFont);
          tmpFont.Free;
        end;
        if FRowLines then
        With Printer.Canvas do
        Begin
          MoveTo(FMargins[LeftMargin],PosY);
          LineTo(FMargins[LeftMargin]+Positions[NPositions+1],PosY);
        End;
      End;
    End;
  End;

  Procedure WriteRecord;
  var t:Word;
      s,st:String;
  Begin
    if not FToScreen then WriteRecordToPrinter
    else
    Begin
      With FDBGrid.DataSource.DataSet do
      Begin
        s:='';
        for t:=0 to FieldCount-1 do
        With Fields[t] do
        if Visible then
        Begin
          st:=DisplayText;
          if Alignment=taLeftJustify then
             s:=s+Copy(st,1,LongiScreen(Fields[t]))+RestoBlancos(Fields[t],st)
          else
             s:=s+RestoBlancos(Fields[t],st)+Copy(st,1,LongiScreen(Fields[t]));
          s:=s+' ';
        end;
      End;
      WriteLineScreen(s);
    End;
  End;

  Procedure PageJump;
  Begin
    RecCounter:=0;
    if not FToScreen then
      if (tmpPageNo>=FFromPage) and
         (tmpPageNo<FToPage) then Printer.NewPage;
    inc(tmpPageNo);
  End;

  Function GuessViewer:String; { stupid tricky }
  Var ff:File;
      n:Longint;
  Begin
    AssignFile(ff,'tmp.txt');
    n:=0;
    try
      Reset(ff);
      n:=FileSize(ff);
      closefile(ff);
    finally
     if n>32000 then result:='write'
                else result:='notepad';
    end;
  End;

  Function RealWidth:Longint;
  Begin
    Result:=Printer.PageWidth-FMargins[LeftMargin]-FMargins[RightMargin];
  end;

  Function AllPageFilled:Boolean;
  Begin
    result:=(FToScreen and (RecCounter=66)) or
               (not FToScreen and
              ((FirstRecordY+(RecCounter-1)*LinesHeight)>=
                          (Printer.PageHeight-FMargins[BottomMargin])));
  End;

var res:Boolean;
    St:Array[0..255] of Char;
    Programa:String;
    BookMark:TBookMark;
    t:Integer;
    tmpFont:TFont;
Begin
  if Not Assigned(FDBGrid) then Raise Exception.Create('PrintGrid. No DBGrid specified!');
  if FToScreen then res:=OpenTextForWrite(tmpFile,'tmp.txt')
  else
  Begin
    With Printer do
    Begin
      Title:=FPrintAdmTitle;
      BeginDoc;
      With Canvas do
      Begin
        tmpFont:=TFont.Create;
        tmpFont.Assign(Font);
        Font.Assign(FLinesFont);
        LinesHeight:=TextHeight('M');
        LinesWidth:=TextWidth('0');
        Font.Assign(tmpFont);
        tmpFont.Free;
      End;
    End;
  End;
  if res then
  begin
    With FDBGrid.DataSource.DataSet do
    try
      Screen.Cursor:=crHourGlass;
      Bookmark:= string(GetBookMark);
      DisableControls;
      First;
      RecCounter:=0;
      tmpPageNo:=1;
      CalculatePositions; { where to place each field in horizontal plane? }
      if not FToScreen and (Positions[NPositions+1]>RealWidth) then
         ShowMessage('Report width is greater than paper'); { useful in design }
      While not eof do
      Begin
        if RecCounter=0 then WriteHeader;
        WriteRecord;
        Inc(RecCounter);
        next;
        if AllPageFilled then
        Begin
          PageJump;
          if tmpPageNo>FToPage then break;
        end;
      end;
    finally
      Screen.Cursor:=crDefault;
      GotoBookMark(pointer(BookMark));
      EnableControls;
      FreeBookMark(pointer(BookMark));
      if FToScreen then
      Begin
        System.closefile(tmpFile);
        if FScreenViewer='' then Programa:=GuessViewer
                            else Programa:=FScreenViewer;
        WinExec(StrPCopy(St,Programa+' tmp.txt'),SW_SHOWMAXIMIZED);
      End
      Else Printer.EndDoc;
    end;
  end
  else raise Exception.Create('Error al obrir la impresora');
End;

Procedure TPrintGrid.PrintDialog;
Begin
  With TPrintDialog.Create(Self) do
  try
    Options:=[poPageNums];
    MinPage:=1;
    MaxPage:=MaxPages;
    FFromPage:=1;
    FToPage:=MaxPages;
    if Execute then
    Begin
      if PrintRange=prPageNums then
      Begin
        FFromPage:=FromPage;
        FToPage:=ToPage;
      End;
      Print;
    End;
  finally
    Free;
  end;
End;

procedure Register;
begin
  //RegisterComponents('CalWin', [TPrintGrid]);
end;

end.
