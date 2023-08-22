unit MaxXMLUtils;

{
just a few helper
}

interface

uses
  MaxDOM;


function ValidXmlName(AName: PChar; ASize: Integer): Boolean; overload;
function ValidXmlName(const AName: String): Boolean; overload;

function EncodeXmlAttrValue(const AStr: AnsiString): AnsiString; overload;
procedure EncodeXmlAttrValue(ABuff: PChar; ABuffSize: Integer;
  var AStr: AnsiString; var ALen, AOffset: Integer); overload;
procedure EncodeXmlAttrValue(const ASource: String; var ADest: String;
  var ALen, AOffset: Integer); overload;

function EncodeXmlString(const AStr: String): String; overload;
procedure EncodeXmlString(ABuff: PChar; ABuffSize: Integer; var AStr: AnsiString;
  var ALen, AOffset: Integer); overload;

procedure EncodeXmlComment(const ASource: AnsiString; var ADest: AnsiString;
  var ALen, AOffset: Integer); overload;

function HasEncoding(const AStr: AnsiString): Boolean;

function DecodeXmlAttrValue(const AStr: String): String;

procedure ReallocateString(var AString: AnsiString; var ALen: Integer; AReqLen: Integer);

procedure AttrFillXMLString(AnAttr: IAttribute; var aString: AnsiString;
  var aOffset, aLen: Integer);
procedure FillXMLString(ANode: INode; var AString: String; var AOffset,
  ALen: Integer; ASibling: INode; ALevel: Integer);


function NodeToXML(ANode: INode): String;
procedure XMLSaveToFile(ANode: INode; const AFileName: String);
function XMLLoadFromFile(const AFileName: String): INode;



function Hash(const ASource: AnsiString): Cardinal;


const
  GXMLIndentSpaces: Integer = 2;
  GXMLMultiLineAttributes: Boolean = True;
  GXMLMultiLineAttributeThreshold: Integer = 7;


implementation

uses
  Classes,
  SysUtils,
  Windows;


type
  PCardinalArray = ^TCardinalArray;
  TCardinalArray = Array[0..$0fffffff] of Cardinal;

{$R-,Q-}
function Hash(const ASource: AnsiString): Cardinal;
var
  a: Cardinal;
  b: Cardinal;
  c: Cardinal;
  k: PCardinalArray;
  LLength: Cardinal;
begin
  LLength := Length(ASource);
  a := $deadbeef + LLength;
  b := a;
  c := a;
  k := PCardinalArray(ASource);

  while LLength > 12 do begin
    a := a + k[0];
    b := b + k[1];
    c := c + k[2];

    //mix(a, b, c)
    Dec(a, c); a := a xor ((c shl  4) or (c shr (32 -  4))); Inc(c, b);
    Dec(b, a); b := b xor ((a shl  6) or (a shr (32 -  6))); Inc(a, c);
    Dec(c, b); c := c xor ((b shl  8) or (b shr (32 -  8))); Inc(b, a);
    Dec(a, c); a := a xor ((c shl 16) or (c shr (32 - 16))); Inc(c, b);
    Dec(b, a); b := b xor ((a shl 19) or (a shr (32 - 19))); Inc(a, c);
    Dec(c, b); c := c xor ((b shl  4) or (b shr (32 -  4))); Inc(b, a);

    Dec(LLength, 12);
    Inc(PCardinal(k), 3);
  end;

  case LLength of
    12 : begin c := c + k[2];             b := b + k[1]; a := a + k[0]; end;
    11 : begin c := c + k[2] and $ffffff; b := b + k[1]; a := a + k[0]; end;
    10 : begin c := c + k[2] and $ffff;   b := b + k[1]; a := a + k[0]; end;
     9 : begin c := c + k[2] and $ff;     b := b + k[1]; a := a + k[0]; end;
     8 : begin b := b + k[1];                            a := a + k[0]; end;
     7 : begin b := b + k[1] and $ffffff;                a := a + k[0]; end;
     6 : begin b := b + k[1] and $ffff;                  a := a + k[0]; end;
     5 : begin b := b + k[1] and $ff;                    a := a + k[0]; end;
     4 : begin a := a + k[0];             end;
     3 : begin a := a + k[0] and $ffffff; end;
     2 : begin a := a + k[0] and $ffff;   end;
     1 : begin a := a + k[0] and $ff;     end;
     0 : begin Result := c; Exit;         end;
  end;

  //final(a, b, c)
  c := c xor b; Dec(c, ((b shl 14) or (b shr (32 - 14))));
  a := a xor c; Dec(a, ((c shl 11) or (c shr (32 - 11))));
  b := b xor a; Dec(b, ((a shl 25) or (a shr (32 - 25))));
  c := c xor b; Dec(c, ((b shl 16) or (b shr (32 - 16))));
  a := a xor c; Dec(a, ((c shl  4) or (c shr (32 -  4))));
  b := b xor a; Dec(b, ((a shl 14) or (a shr (32 - 14))));
  c := c xor b; Dec(c, ((b shl 24) or (b shr (32 - 24))));

  Result := c;
end;
{$R+,Q+}



procedure ReallocateString(var AString: AnsiString; var ALen: Integer; AReqLen: Integer);
begin
  while ALen < AReqLen do
    ALen := ALen * 2;
  SetLength(AString, ALen);
end;


function ValidXmlName(AName: PChar; ASize: Integer): Boolean; overload;
var
  LColonSeen: Boolean;
begin
  Result := False;
  LColonSeen := False;
  if AName^ = #0 then
    Exit;
  if not (AName^ in ['A'..'Z','a'..'z','_']) then
    Exit;
  Inc(AName);
  while AName^ <> #0 do begin
    if not (AName^ in ['A'..'Z','a'..'z','0'..'9','_','.',':','-']) then
      Exit;
    if AName^ = ':' then begin
      if LColonSeen then
        Exit
      else
        LColonSeen := True;
    end;
    Inc(AName);
  end;
  Result := True;
end;


function ValidXmlName(const AName: String): Boolean; overload;
begin
  Result := ValidXmlName(PChar(AName), Length(AName));
end;


function EncodeXmlAttrValue(const AStr: AnsiString): AnsiString; overload;
var
  i:        Integer;
  lInitPos: Integer;
  lCurLen:  Integer;
begin
  lInitPos := 1;
  lCurLen := 0;
  Result := '';
  for i:=1 to Length(AStr) do begin
    case AStr[i] of
      '&': begin
        Result := Result + Copy(AStr, lInitPos, lCurLen) + '&amp;';
        Inc(lInitPos, lCurLen + 1);
        lCurLen := 0;
      end;
      '<': begin
        Result := Result + Copy(AStr, lInitPos, lCurLen) + '&lt;';
        Inc(lInitPos, lCurLen + 1);
        lCurLen := 0;
      end;
      '>': begin
        Result := Result + Copy(AStr, lInitPos, lCurLen) + '&gt;';
        Inc(lInitPos, lCurLen + 1);
        lCurLen := 0;
      end;
      '"': begin
        Result := Result + Copy(AStr, lInitPos, lCurLen) + '&quot;';
        Inc(lInitPos, lCurLen + 1);
        lCurLen := 0;
      end;
    else
      Inc(lCurLen);
    end; { end of CASE }
  end;

  Result := Result + Copy(AStr, lInitPos, lCurLen);
end;

procedure EncodeXmlAttrValue(ABuff: PChar; ABuffSize: Integer;
  var AStr: AnsiString; var ALen, AOffset: Integer); overload;
const
  cAmp        = '&amp;';
  cAmpLen     = Length(cAmp);
  cLt         = '&lt;';
  cLtLen      = Length(cLt);
  cGt         = '&gt;';
  cGtLen      = Length(cGt);
  cQuot      = '&quot;';
  cQuotLen   = Length(cQuot);
var
  i:        Integer;
  lInitPos: Integer;
  lCurLen:  Integer;
  lReqLen:  Integer;
  lInitOffset: Integer;
begin
  lInitPos := 0;
  lCurLen := 0;
  lInitOffset := AOffset;

  lReqLen := ABuffSize;
  ReallocateString(AStr,ALen,LReqLen+LInitOffset);

  for i:=0 to ABuffSize - 1 do begin
    case (ABuff + i)^ of
      '&': begin
        Inc(lReqLen, cAmpLen - 1);
        ReallocateString(AStr,ALen,LReqLen+LInitOffset);
        Move((ABuff + lInitPos)^, AStr[AOffset], lCurLen);
        Inc(AOffset, lCurLen);
        Inc(lInitPos, lCurLen);
        Move(cAmp[1], AStr[AOffset], cAmpLen);
        Inc(AOffset, cAmpLen);
        Inc(lInitPos);
        lCurLen := 0;
      end;
      '<': begin
        Inc(lReqLen, cLtLen - 1);
        ReallocateString(AStr,ALen,LReqLen+LInitOffset);
        Move((ABuff + lInitPos)^, AStr[AOffset], lCurLen);
        Inc(AOffset, lCurLen);
        Inc(lInitPos, lCurLen);
        Move(cLt[1], AStr[AOffset], cLtLen);
        Inc(AOffset, cLtLen);
        Inc(lInitPos);
        lCurLen := 0;
      end;
      '>': begin
        Inc(lReqLen, cGtLen - 1);
        ReallocateString(AStr,ALen,LReqLen+LInitOffset);
        Move((ABuff + lInitPos)^, AStr[AOffset], lCurLen);
        Inc(AOffset, lCurLen);
        Inc(lInitPos, lCurLen);
        Move(cGt[1], AStr[AOffset], cGtLen);
        Inc(AOffset, cGtLen);
        Inc(lInitPos);
        lCurLen := 0;
      end;
      '"': begin
        Inc(lReqLen, cQuotLen - 1);
        ReallocateString(AStr,ALen,LReqLen+LInitOffset);
        Move((ABuff + lInitPos)^, AStr[AOffset], lCurLen);
        Inc(AOffset, lCurLen);
        Inc(lInitPos, lCurLen);
        Move(cQuot[1], AStr[AOffset], cQuotLen);
        Inc(AOffset, cQuotLen);
        Inc(lInitPos);
        lCurLen := 0;
      end;
    else
      Inc(lCurLen);
    end; { end of CASE }
  end;

  Move((ABuff + lInitPos)^, AStr[AOffset], lCurLen);
  Inc(AOffset, lCurLen);
end;


function HasEncoding(const AStr: AnsiString): Boolean;
begin
  Result := Pos('&',Astr) > 0;
end;


procedure EncodeXmlAttrValue(const ASource: String; var ADest: String;
  var ALen, AOffset: Integer); overload;
begin
  EncodeXmlAttrValue(PChar(ASource), Length(ASource), ADest, ALen, AOffset);
end;


function EncodeXmlString(const AStr: String): String; overload;
var
  i:        Integer;
  lInitPos: Integer;
  lCurLen:  Integer;
begin
  lInitPos := 1;
  lCurLen := 0;
  Result := '';
  for i:=1 to Length(AStr) do begin
    case AStr[i] of
      '&': begin
        Result := Result + Copy(AStr, lInitPos, lCurLen) + '&amp;';
        Inc(lInitPos, lCurLen + 1);
        lCurLen := 0;
      end;
      '<': begin
        Result := Result + Copy(AStr, lInitPos, lCurLen) + '&lt;';
        Inc(lInitPos, lCurLen + 1);
        lCurLen := 0;
      end;
      '>': begin
        Result := Result + Copy(AStr, lInitPos, lCurLen) + '&gt;';
        Inc(lInitPos, lCurLen + 1);
        lCurLen := 0;
      end;
    else
      Inc(lCurLen);
    end; { end of CASE }
  end;

  Result := Result + Copy(AStr, lInitPos, lCurLen);
end;




procedure EncodeXmlString(ABuff: PChar; ABuffSize: Integer; var AStr: AnsiString; var ALen, AOffset: Integer); overload;
const
  cAmp        = '&amp;';
  cAmpLen     = Length(cAmp);
  cLt         = '&lt;';
  cLtLen      = Length(cLt);
  cGt         = '&gt;';
  cGtLen      = Length(cGt);
var
  i:        Integer;
  lInitPos: Integer;
  lCurLen:  Integer;
  lReqLen:  Integer;
  lInitOffset: Integer;
begin
  lInitPos := 0;
  lCurLen := 0;
  lInitOffset := AOffset;

  lReqLen := ABuffSize;
  ReallocateString(AStr,ALen,LReqLen+LInitOffset);

  for i:=0 to ABuffSize - 1 do begin
    case (ABuff + i)^ of
      '&': begin
        Inc(lReqLen, cAmpLen - 1);
        ReallocateString(AStr,ALen,LReqLen+LInitOffset);
        Move((ABuff + lInitPos)^, AStr[AOffset], lCurLen);
        Inc(AOffset, lCurLen);
        Inc(lInitPos, lCurLen);
        Move(cAmp[1], AStr[AOffset], cAmpLen);
        Inc(AOffset, cAmpLen);
        Inc(lInitPos);
        lCurLen := 0;
      end;
      '<': begin
        Inc(lReqLen, cAmpLen - 1);
        ReallocateString(AStr,ALen,LReqLen+LInitOffset);
        Move((ABuff + lInitPos)^, AStr[AOffset], lCurLen);
        Inc(AOffset, lCurLen);
        Inc(lInitPos, lCurLen);
        Move(cLt[1], AStr[AOffset], cLtLen);
        Inc(AOffset, cLtLen);
        Inc(lInitPos);
        lCurLen := 0;
      end;
      '>': begin
        Inc(lReqLen, cAmpLen - 1);
        ReallocateString(AStr,ALen,LReqLen+LInitOffset);
        Move((ABuff + lInitPos)^, AStr[AOffset], lCurLen);
        Inc(AOffset, lCurLen);
        Inc(lInitPos, lCurLen);
        Move(cGt[1], AStr[AOffset], cGtLen);
        Inc(AOffset, cGtLen);
        Inc(lInitPos);
        lCurLen := 0;
      end;
    else
      Inc(lCurLen);
    end; { end of CASE }
  end;

  Move((ABuff + lInitPos)^, AStr[AOffset], lCurLen);
  Inc(AOffset, lCurLen);
end;


procedure EncodeXmlString(const ASource: AnsiString; var ADest: AnsiString; var ALen, AOffset: Integer); overload;
begin
  EncodeXmlString(PChar(ASource), Length(ASource), ADest, ALen, AOffset);
end;




procedure EncodeXmlComment(const ASource: AnsiString; var ADest: AnsiString; var ALen, AOffset: Integer); overload;
var
  lInitPos: Integer;
  lCurLen:  Integer;
  lReqLen:  Integer;
  lInitOffset: Integer;
begin
  lInitPos := 0;
  lInitOffset := AOffset;

  lReqLen := Length(ASource) + 7;
  ReallocateString(ADest,ALen,LReqLen+LInitOffset);

  ADest[aOffset] := '<';
  Inc(aOffset);
  ADest[aOffset] := '!';
  Inc(aOffset);
  ADest[aOffset] := '-';
  Inc(aOffset);
  ADest[aOffset] := '-';
  Inc(aOffset);

  lCurLen := Length(ASource);
  Move((PChar(ASource) + lInitPos)^, ADest[AOffset], lCurLen);
  Inc(AOffset, lCurLen);

  ADest[aOffset] := '-';
  Inc(aOffset);
  ADest[aOffset] := '-';
  Inc(aOffset);
  ADest[aOffset] := '>';
  Inc(aOffset);
end;




procedure AttrFillXMLString(AnAttr: IAttribute; var aString: AnsiString;
  var aOffset, aLen: Integer);
var
  lNameLen: Integer;
  lValueLen: Integer;
  lReqLen: Integer;
begin
  lNameLen := Length(AnAttr.Name);
  lValueLen := Length(AnAttr.Value);

  lReqLen := lNameLen + 3 + lValueLen;
  ReallocateString(AString,ALen,LReqLen+AOffset);

  Move(AnAttr.Name[1], aString[aOffset], lNameLen);
  Inc(aOffset, lNameLen);
  aString[aOffset] := '=';
  Inc(aOffset);
  aString[aOffset] := '"';
  Inc(aOffset);

  EncodeXmlAttrValue(AnAttr.Value, aString, ALen, aOffset);

  aString[aOffset] := '"';
  Inc(aOffset);
end;




procedure FillXMLString(ANode: INode; var AString: String; var AOffset,
  ALen: Integer; ASibling: INode; ALevel: Integer);
var
  LNameLen: Integer;
  LReqLen: Integer;
  I: Integer;
  LIndent: Integer;
  LChildCount: Integer;
begin
  if ALen = 0 then
    ALen := Length(AString);

  lNameLen := Length(ANode.NodeName);

  lIndent := (GXMLIndentSpaces * aLevel);
  LChildCount := ANode.Children.Count;

  if ANode.NodeType = ntElement then begin

    lReqLen := lNameLen + lIndent + 1;

    ReallocateString(AString,ALen,LReqLen + AOffset);

    if not Assigned(ASibling) or (ASibling.NodeType <> ntText) then begin
      FillChar(aString[aOffset], lIndent, 32);
      Inc(aOffset, lIndent);
    end;

    aString[aOffset] := '<';
    Inc(aOffset);
    Move(ANode.NodeName[1], aString[aOffset], lNameLen);
    Inc(aOffset, lNameLen);

    if not GXMLMultiLineAttributes or (ANode.Attributes.Count <= GXMLMultiLineAttributeThreshold) then begin
      for i:=0 to ANode.Attributes.Count - 1 do begin
        lReqLen := 1;
        ReallocateString(aString, aLen, lReqLen + aOffset);
        aString[aOffset] := ' ';
        Inc(aOffset);
        AttrFillXMLString(ANode.Attributes[i],aString, aOffset, aLen);
      end;
    end
    else begin
      lReqLen := 2;
      ReallocateString(aString, aLen, lReqLen + aOffset);
      aString[aOffset] := #13;
      Inc(aOffset);
      aString[aOffset] := #10;
      Inc(aOffset);

      for i:=0 to ANode.Attributes.Count - 1 do begin
        lReqLen := lIndent + GXMLIndentSpaces;
        ReallocateString(aString, aLen, lReqLen + aOffset);

        FillChar(aString[aOffset], lIndent + GXMLIndentSpaces, 32);
        Inc(aOffset, lIndent + GXMLIndentSpaces);
        AttrFillXMLString(ANode.Attributes[i],aString, aOffset, aLen);
        lReqLen := 2;
        ReallocateString(aString, aLen, lReqLen + aOffset);
        aString[aOffset] := #13;
        Inc(aOffset);
        aString[aOffset] := #10;
        Inc(aOffset);
      end;
      ReallocateString(aString, aLen, lIndent + aOffset);
      FillChar(aString[aOffset], lIndent, 32);
      Inc(aOffset, lIndent);
    end;

    lReqLen := 1;
    if LChildCount = 0 then
      Inc(lReqLen);

    ReallocateString(AString,ALen,LReqLen + AOffset);

    if LChildCount > 0 then begin
      aString[aOffset] := '>';
      Inc(aOffset);

      for i:=0 to LChildCount - 1 do begin

        if (ANode.Children[i].NodeType <> ntText) and ((i = 0) or (ANode.Children[i-1].NodeType <> ntText)) then begin
          lReqLen := 2;
          ReallocateString(AString,ALen,LReqLen + AOffset);
          aString[aOffset] := #13;
          Inc(aOffset);
          aString[aOffset] := #10;
          Inc(aOffset);
        end;
        if i = 0 then
          FillXMLString(ANode.Children[i],aString, aOffset, aLen, nil, aLevel + 1)
        else
          FillXMLString(ANode.Children[i],aString, aOffset, aLen, ANode.Children[i - 1], aLevel + 1);

      end;

      lReqLen := lNameLen + 3;

      if ANode.Children[LChildCount - 1].NodeType <> ntText then
        Inc(lReqLen, 2 + lIndent);

      Inc(lReqLen, 2 + lIndent);

      ReallocateString(AString,ALen,LReqLen + AOffset);


      if ANode.Children[LChildCount - 1].NodeType <> ntText then begin
        aString[aOffset] := #13;
        Inc(aOffset);
        aString[aOffset] := #10;
        Inc(aOffset);
        FillChar(aString[aOffset], lIndent, 32);
        Inc(aOffset, lIndent);
      end;

      aString[aOffset] := '<';
      Inc(aOffset);
      aString[aOffset] := '/';
      Inc(aOffset);

      Move(ANode.NodeName[1], aString[aOffset], lNameLen);
      Inc(aOffset, lNameLen);

      aString[aOffset] := '>';
      Inc(aOffset);
    end
    else begin
      aString[aOffset] := '/';
      Inc(aOffset);
      aString[aOffset] := '>';
      Inc(aOffset);
    end;

  end else if ANode.NodeType = ntText then
    EncodeXmlString(ANode.Text, aString, aLen, aOffset)
  else if ANode.NodeType = ntComment then
    EncodeXMLComment(ANode.Text, aString, aLen, aOffset);
end;



procedure XMLSaveToFile(ANode: INode; const AFileName: String);
const
  FILE_READ_DATA            = $0001;
  FILE_WRITE_DATA           = $0002;
var
  lFile: Cardinal;
  lXmlDoc: AnsiString;
  lSize: Cardinal;
begin
  lXmlDoc := NodeToXML(ANode);
  lFile := CreateFile(PChar(AFileName),FILE_WRITE_DATA,0,nil,CREATE_ALWAYS,0,0);
  if lFile = INVALID_HANDLE_VALUE then begin
    raise Exception.CreateFmt('Unable to create/overwrite file: %s', [AFileName]);
  end else try
    WriteFile(lFile,lXmlDoc[1],Length(lXmlDoc),lSize,nil);
  finally
    CloseHandle(lFile);
  end;
end;



function DoParseNodeBuffer(AnAddress: PChar; ASize: Integer): INode;
begin
  Result := nil;
  if not Assigned(AnAddress) or (ASize = 0) then
    Exit;


end;



function XMLLoadFromFile(const AFileName: String): INode;
const
  FILE_READ_DATA  = $0001;
var
  LFile: cardinal;
  LFileSize: cardinal;
  LBuffer: PChar;
begin
  Result := nil;
  if not FileExists(AFileName) then
    raise Exception.CreateFmt('XML file not found: %s', [AFileName]);
  LFile := CreateFile(PChar(AFileName), FILE_READ_DATA, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if LFile > 0 then try
    LFileSize := Windows.GetFileSize(LFile, nil);
    GetMem(LBuffer,LFileSize);
    try
      ReadFile(LFile,LBuffer^,LFileSize,LFileSize, nil);
      Result := DoParseNodeBuffer(lBuffer, LFileSize);
    finally
      FreeMem(LBuffer);
    end;
  finally
    CloseHandle(LFile);
  end;
end;



function NodeToXML(ANode: INode): String;
const
  CDefaultBufferSize  = $100;
var
  LOffset: Integer;
  LLen: Integer;
begin
  SetLength(Result, CDefaultBufferSize);
  LOffset := 1;
  LLen := 0;
  FillXMLString(ANode, Result, LOffset, LLen, nil, 0);
  SetLength(Result, LOffset - 1);
end;




function DecodeXmlAttrValue(const AStr: String): String;
begin
  //TODO: DecodeXmlAttrValue
  Result :=
    StringReplace(
      StringReplace(
        StringReplace(AStr,
          '&quot;','"',[rfReplaceAll]
        ),
        '&lt;','<',[rfReplaceAll]
      ),
      '&gt;','>',[rfReplaceAll]
    );
end;


end.
