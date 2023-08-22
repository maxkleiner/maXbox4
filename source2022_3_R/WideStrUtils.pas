{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit WideStrUtils;

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF}

interface

uses Windows, SysUtils, Classes;

{ Wide string manipulation functions }

function WStrAlloc(Size: Cardinal): PWideChar;
function WStrBufSize(const Str: PWideChar): Cardinal;
function WStrMove(Dest: PWideChar; const Source: PWideChar; Count: Cardinal): PWideChar;
function WStrNew(const Str: PWideChar): PWideChar;
procedure WStrDispose(Str: PWideChar);


{ PWideChar version StrLen. Return: Length of Str in Character count. }

function WStrLen(const Str: PWideChar): Cardinal;

function WStrEnd(const Str: PWideChar): PWideChar;
function WStrCat(Dest: PWideChar; const Source: PWideChar): PWideChar;
function WStrCopy(Dest: PWideChar; const Source: PWideChar): PWideChar;
function WStrLCopy(Dest: PWideChar; const Source: PWideChar; MaxLen: Cardinal): PWideChar;

function WStrPCopy(Dest: PWideChar; const Source: WideString): PWideChar;

function WStrPLCopy(Dest: PWideChar; const Source: WideString; MaxLen: Cardinal): PWideChar;
function WStrScan(Str: PWideChar; Chr: WideChar): PWideChar;

function WStrComp(const Str1, Str2: PWideChar): Integer;
function WStrPos(const Str1, Str2: PWideChar): PWideChar;

{ UTF8 string manipulation functions }

function UTF8LowerCase(const S: UTF8string): UTF8string;
function UTF8UpperCase(const S: UTF8string): UTF8string;

{ Ansi <-> UTF8 conversion with codepage option. }

function AnsiToUtf8Ex(const S: AnsiString; const cp : integer): UTF8String;
function Utf8ToAnsiEx(const S: UTF8String; const cp : integer): AnsiString;

{ Encoding handling }

{ Detect valid UTF8 sequence. }

type
  TEncodeType = (etUSASCII, etUTF8, etANSI);

function DetectUTF8Encoding(const s: RawByteString): TEncodeType;

{ if string contain real UTF8 character, return true. }

function IsUTF8String(const s: RawByteString): Boolean;

{ if string contain extended character (non-ascii char), return true;
  if this function return true, It is better to add BOM head of file stream. }

function HasExtendCharacter(const s: RawByteString): Boolean;

{ If Stream/String has UTF8 BOM at the begin of stream, return TRUE.
  Stream's position doesn't change. }

function HasUTF8BOM(S : TStream) : boolean; overload;
function HasUTF8BOM(const S: RawByteString) : boolean; overload;

{ Convert from ANSI encding to UTF8 encoding in Stream.
  Stream's position set to the begin of the stream. }

procedure ConvertStreamFromAnsiToUTF8(Src, Dst : TStream; cp : integer = CP_ACP);
procedure ConvertStreamFromUTF8ToAnsi(Src, Dst : TStream; cp : integer = CP_ACP);

{ SysUtils.pas }

{ WideLastChar returns a pointer to the last full character in the string.
  This function is Wide version of AnsiLastChar }

function WideLastChar(const S: WideString): PWideChar;

function WideQuotedStr(const S: WideString; Quote: WideChar): WideString;
function WideExtractQuotedStr(var Src: PWideChar; Quote: WideChar): WideString;
function WideDequotedStr(const S: WideString; AQuote: WideChar): WideString;
function WideAdjustLineBreaks(const S: WideString; Style: TTextLineBreakStyle = tlbsCRLF ): WideString;

function WideStringReplace(const S, OldPattern, NewPattern: Widestring;
  Flags: TReplaceFlags): Widestring;

{ StrUtils.pas }

function WideReplaceStr(const AText, AFromText, AToText: WideString): WideString;
function WideReplaceText(const AText, AFromText, AToText: WideString): WideString;

{ LoadWideStr loads the widestring resource given by Ident from the application's
  executable file or associated resource module. If the string resource
  does not exist, LoadWideStr returns an empty string. }

function LoadWideStr(Ident: Integer): WideString;

{ System.pas }

{ Wide version of resourcestring loader. }

function LoadResWideString(ResStringRec: PResStringRec): WideString;

{ in operator support for WideChar }
type
  CharSet = set of ansichar;

function inOpSet( W : WideChar; sets : CharSet ) : boolean;
function inOpArray( W : WideChar; sets : array of WideChar ) : boolean;

{ UTF8 Byte Order Mark. }
const
  sUTF8BOMString : array[1..3] of AnsiChar = (AnsiChar(#$EF), AnsiChar(#$BB), AnsiChar(#$BF));


{ If Lead is legal UTF8 lead byte, return True. 
  Legal lead byte is #$00..#$7F, #$C2..#$FD }

function IsUTF8LeadByte(Lead: AnsiChar): Boolean;

{ If Lead is legal UTF8 trail byte, return True. 
  Legal lead byte is #$80..#$BF }

function IsUTF8TrailByte(Lead: AnsiChar): Boolean;

{ UTF8CharSize returns the number of bytes required by the first character
  in Str. UTF-8 characters can be up to six bytes in length. 
  Note: If first character is NOT legal lead byte of UTF8, this function
  returns 0. }

function UTF8CharSize(Lead: AnsiChar): Integer;

{ UTF8CharLength is a variation of UTF8CharSize. This function returns 
  the number of bytes required by the first character.
  If first character is NOT legal lead byte of UTF8, this function 
  returns 1, NOT 0. }

function UTF8CharLength(Lead: AnsiChar): Integer; inline;

implementation

//----------------------------------------------------------
function WStrAlloc(Size: Cardinal): PWideChar;
begin
  Size := Size * Sizeof(WideChar);
  Inc(Size, SizeOf(Cardinal));
  GetMem(Result, Size);
  Cardinal(Pointer(Result)^) := Size;
  Inc(PByte(Result), SizeOf(Cardinal));
end;

function WStrBufSize(const Str: PWideChar): Cardinal;
var
  P: PWideChar;
begin
  P := Str;
  Dec(PByte(P), SizeOf(Cardinal));
  Result := (Cardinal(Pointer(P)^) - SizeOf(Cardinal)) div sizeof(WideChar);
end;

function WStrMove(Dest: PWideChar; const Source: PWideChar; Count: Cardinal): PWideChar;
begin
  Result := Dest;
  Move(Source^, Dest^, Count * Sizeof(WideChar));
end;


function WStrNew(const Str: PWideChar): PWideChar;
var
  Size: Cardinal;
begin
  if Str = nil then Result := nil else
  begin
    Size := WStrLen(Str) + 1;
    Result := WStrMove(WStrAlloc(Size), Str, Size);
  end;
end;

procedure WStrDispose(Str: PWideChar);
begin
  if Str <> nil then
  begin
    Dec(PByte(Str), SizeOf(Cardinal));
    FreeMem(Str, Cardinal(Pointer(Str)^));
  end;
end;


//----------------------------------------------------------
function WStrLen(const Str: PWideChar): Cardinal;
var
  P : PWideChar;
begin
  P := Str;
  while (P^ <> #0) do Inc(P);
  Result := (P - Str);
end;

//----------------------------------------------------------
function WStrEnd(const Str: PWideChar): PWideChar;
begin
  Result := Str;
  while (Result^ <> #0) do Inc(Result);
end;

function WStrCat(Dest: PWideChar; const Source: PWideChar): PWideChar;
begin
  WStrCopy(WStrEnd(Dest), Source);
  Result := Dest;
end;

function WStrCopy(Dest: PWideChar; const Source: PWideChar): PWideChar;
var
  Src : PWideChar;
begin
  Result := Dest;
  Src := Source;
  while (Src^ <> #$00) do
  begin
    Dest^ := Src^;
    Inc(Src);
    Inc(Dest);
  end;
  Dest^ := #$00;
end;

function WStrLCopy(Dest: PWideChar; const Source: PWideChar; MaxLen: Cardinal): PWideChar;
var
  Src : PWideChar;
begin
  Result := Dest;
  Src := Source;
  while (Src^ <> #$00) and (MaxLen > 0) do
  begin
    Dest^ := Src^;
    Inc(Src);
    Inc(Dest);
    Dec(MaxLen);
  end;
  Dest^ := #$00;
end;

function WStrPCopy(Dest: PWideChar; const Source: WideString): PWideChar;
begin
  Result := WStrLCopy(Dest, PWideChar(Source), Length(Source));
end;

function WStrPLCopy(Dest: PWideChar; const Source: WideString; MaxLen: Cardinal): PWideChar;
begin
  Result := WStrLCopy(Dest, PWideChar(Source), MaxLen);
end;

function WStrScan(Str: PWideChar; Chr: WideChar): PWideChar;
begin
  Result := Str;
  while Result^ <> Chr do
  begin
    if Result^ = #0 then
    begin
      Result := nil;
      Exit;
    end;
    Inc(Result);
  end;
end;

function WStrComp(const Str1, Str2: PWideChar): Integer;
var
  L, R : PWideChar;
begin
  L := Str1;
  R := Str2;
  Result := 0;
  repeat
    if L^ = R^ then
    begin
      if L^ = #0 then exit;
      Inc(L);
      Inc(R);
    end
    else
    begin
      Result := (Word(L^) - Word(R^));
      exit;
    end;
  until (False);
end;

function WStrPos(const Str1, Str2: PWideChar): PWideChar;
var
  Str, SubStr: PWideChar;
  Ch: WideChar;
begin
  Result := nil;
  if (Str1 = nil) or (Str1^ = #0) or (Str2 = nil) or (Str2^ = #0) then Exit;
  Result := Str1;
  Ch := Str2^;
  repeat
    if Result^ = Ch then
    begin
      Str := Result;
      SubStr := Str2;
      repeat
        Inc(Str);
        Inc(SubStr);
        if SubStr^ = #0 then exit;
        if Str^ = #0 then
        begin
          Result := nil;
          exit;
        end;
        if Str^ <> SubStr^ then break;
      until (FALSE);
    end;
    Inc(Result);
  until (Result^ = #0);
  Result := nil;
end;

//----------------------------------------------------------
{ UTF8 string manipulation functions }

function UTF8LowerCase(const S: UTF8string): UTF8string;
begin
  Result := UTF8Encode(WideLowerCase(UTF8Decode(S)));
end;

function UTF8UpperCase(const S: UTF8string): UTF8string;
begin
  Result := UTF8Encode(WideUpperCase(UTF8Decode(S)));
end;


//----------------------------------------------------------
// Ansi <-> UTF8 conversion with codepage option. 

function AnsiToUtf8Ex(const S: AnsiString; const cp : integer): UTF8String;
var
  wlen, ulen : integer;
  wbuf : PWideChar;
begin
  if cp = CP_UTF8 then 
  begin
    Result := S;
    exit;
  end;
  
  Result := '';
  wlen := MultiByteToWideChar(cp, 0, PAnsiChar(S), length(S), NIL, 0); // wlen is the number of UCS2 without NULL terminater.
  if wlen = 0 then exit;
  wbuf := GetMemory(wlen * sizeof(wchar));
  try
    MultiByteToWideChar(cp, 0, PAnsiChar(S), length(S), wbuf, wlen);

    ulen := WideCharToMultiByte(CP_UTF8, 0, wbuf, wlen, NIL, 0, NIL, NIL);
    setlength(Result, ulen);
    WideCharToMultiByte(CP_UTF8, 0, wbuf, wlen, PAnsiChar(Result), ulen, NIL, NIL);
  finally
    FreeMemory(WBuf);
  end;
end;

function Utf8ToAnsiEx(const S: UTF8String; const cp : integer): AnsiString;
var
  wlen, ulen : integer;
  wbuf : PWideChar;
begin
  if cp = CP_UTF8 then 
  begin
    Result := S;
    exit;
  end;
  
  Result := '';
  wlen := MultiByteToWideChar(CP_UTF8, 0, PAnsiChar(S), length(S), NIL, 0); // wlen is the number of UCS2 without NULL terminater.
  if wlen = 0 then exit;
  wbuf := GetMemory(wlen * sizeof(wchar));
  try
    MultiByteToWideChar(CP_UTF8, 0, PAnsiChar(S), length(S), wbuf, wlen);

    ulen := WideCharToMultiByte(cp, 0, wbuf, wlen, NIL, 0, NIL, NIL);
    setlength(Result, ulen);
    WideCharToMultiByte(cp, 0, wbuf, wlen, PAnsiChar(Result), ulen, NIL, NIL);
  finally
    FreeMemory(WBuf);
  end;
end;

//----------------------------------------------------------
// Detect valid UTF8 sequence.
function DetectUTF8Encoding(const s: RawByteString): TEncodeType;
var
  c : Byte;
  P, EndPtr: PByte;
begin
  Result := etUSASCII;
  P := PByte(PAnsiChar(s));
  EndPtr := P + Length(s);

  // skip leading US-ASCII part.
  while P < EndPtr do
  begin
    if P^ >= $80 then break;
    inc(P);
  end;

  // If all character is US-ASCII, done.
  if P = EndPtr then exit;

  while P < EndPtr do
  begin
    c := p^;
    case c of
      $00..$7F:
        inc(P);

      $C2..$DF:
        if (P+1 < EndPtr)
            and ((P+1)^ in [$80..$BF]) then
          Inc(P, 2)
        else
          break;

      $E0:
        if (P+2 < EndPtr)
            and ((P+1)^ in [$A0..$BF])
            and ((P+2)^ in [$80..$BF]) then
          Inc(P, 3)
        else
          break;

      $E1..$EF:
        if (P+2 < EndPtr)
            and ((P+1)^ in [$80..$BF])
            and ((P+2)^ in [$80..$BF]) then
          Inc(P, 3)
        else
          break;

      $F0:
        if (P+3 < EndPtr)
            and ((P+1)^ in [$90..$BF])
            and ((P+2)^ in [$80..$BF])
            and ((P+3)^ in [$80..$BF]) then
          Inc(P, 4)
        else
          break;

      $F1..$F3:
        if (P+3 < EndPtr)
            and ((P+1)^ in [$80..$BF])
            and ((P+2)^ in [$80..$BF])
            and ((P+3)^ in [$80..$BF]) then
          Inc(P, 4)
        else
          break;

      $F4:
        if (P+3 < EndPtr)
            and ((P+1)^ in [$80..$8F])
            and ((P+2)^ in [$80..$BF])
            and ((P+3)^ in [$80..$BF]) then
          Inc(P, 4)
        else
          break;
    else
      break;
    end;
  end;

  if P = EndPtr then Result := etUTF8
  else Result := etANSI;
end;


// if string contain real UTF8 character, return true.
function IsUTF8String(const s: RawByteString): Boolean;
begin
  result := DetectUTF8Encoding(s) = etUTF8;
end;


//----------------------------------------------------------
// if string contain extended character (non-ascii char), return true;
// if this function return true, It is better to add BOM head of file stream. 
function HasExtendCharacter(const s: RawByteString): Boolean;
var
  sp, endp : PByte; { PUTF8String }
begin
  sp := PByte(PAnsiChar(s));
  endp := sp + length(s); // point to NULL-terminater.

  Result := True;
  while sp < endp do
  begin
    if sp^ >= $80 then exit;
    inc(sp);
  end;
  Result := False;
end;

//----------------------------------------------------------
// If Stream has UTF8 BOM at the begin of stream, return TRUE.
// Stream's position doesn't change.
function HasUTF8BOM(S : TStream) : boolean; overload;
var
  SavePos : Int64;
  Buf : array[1..3] of AnsiChar;
begin
  SavePos := S.Position;
  Result := False;
  try
    S.Seek(0, soBeginning);
    if S.Read(Buf, 3) = 3 then
      Result := (Buf[1] = sUTF8BOMString[1])
        and (Buf[2] = sUTF8BOMString[2])
        and (Buf[3] = sUTF8BOMString[3]);
  finally
    S.Position := SavePos;
  end;
end;

function HasUTF8BOM(const S: RawByteString) : boolean; overload;
begin
  Result := False;
  if Length(S) < 3 then exit ;
  if S[1] <> sUTF8BOMString[1] then exit;
  if S[2] <> sUTF8BOMString[2] then exit;
  if S[3] <> sUTF8BOMString[3] then exit;
  Result := True;
end;

//----------------------------------------------------------
// Convert from ANSI encding to UTF8 encoding in Stream.
// Stream's position set to the begin of the stream.
procedure ConvertStreamFromAnsiToUTF8(Src, Dst : TStream; cp : integer);
var
  s : UTF8String;
  SAnsi, SUTF8 : TStringStream;
begin
  if src is TStringStream then
    s := AnsiToUTF8Ex(TStringStream(Src).DataString, cp)
  else
  begin
    SAnsi := TStringStream.Create('');
    try
      Src.Position := 0;
      SAnsi.CopyFrom(Src, 0);
      s := AnsiToUTF8Ex(SAnsi.DataString, cp);
    finally
      SAnsi.Free;
    end;
  end;

  if Dst is TStringStream then
    TStringStream(Dst).WriteString(s)
  else
  begin
    SUTF8 := TStringStream.Create(s);
    try
      Dst.CopyFrom(SUTF8, 0);
    finally
      SUTF8.Free;
    end;
  end;

  Src.Position := 0;
  Dst.Position := 0;
end;

//----------------------------------------------------------
// Convert from UTF8 encding to Ansi encoding in Stream.
// Stream's position set to the begin of the stream.
procedure ConvertStreamFromUTF8ToAnsi(Src, Dst : TStream; cp : integer);
var
  a : AnsiString;
  SAnsi, SUTF8 : TStringStream;
begin
  if src is TStringStream then
    a := UTF8ToAnsiEx(TStringStream(Src).DataString, cp)
  else
  begin
    SUTF8 := TStringStream.Create('');
    try
      Src.Position := 0;
      SUTF8.CopyFrom(Src, 0);
      a := UTF8ToAnsiEx(SUTF8.DataString, cp);
    finally
      SUTF8.Free;
    end;
  end;

  if Dst is TStringStream then
    TStringStream(Dst).WriteString(a)
  else
  begin
    SANSI := TStringStream.Create(a);
    try
      Dst.CopyFrom(SANSI, 0);
    finally
      SANSI.Free;
    end;
  end;

  Src.Position := 0;
  Dst.Position := 0;
end;


{ SysUtils.pas }

function WideLastChar(const S: WideString): PWideChar;
begin
  if S = '' then
    Result := nil
  else
    Result := @S[Length(S)];
end;

//----------------------------------------------------------
// Wide version of SysUtils.AnsiQuotedStr
function WideQuotedStr(const S: WideString; Quote: WideChar): WideString;
var
  P, Src, Dest: PWideChar;
  AddCount: Integer;
begin
  AddCount := 0;
  P := WStrScan(PWideChar(S), Quote);
  while P <> nil do
  begin
    Inc(P);
    Inc(AddCount);
    P := WStrScan(P, Quote);
  end;
  if AddCount = 0 then
  begin
    Result := Quote + S + Quote;
    Exit;
  end;
  SetLength(Result, Length(S) + AddCount + 2);
  Dest := Pointer(Result);
  Dest^ := Quote;
  Inc(Dest);
  Src := Pointer(S);
  P := WStrScan(Src, Quote);
  repeat
    Inc(P);
    Move(Src^, Dest^, (P - Src) * SizeOf(WideChar));
    Inc(Dest, P - Src);
    Dest^ := Quote;
    Inc(Dest);
    Src := P;
    P := WStrScan(Src, Quote);
  until P = nil;
  P := WStrEnd(Src);
  Move(Src^, Dest^, (P - Src) * SizeOf(WideChar));
  Inc(Dest, P - Src);
  Dest^ := Quote;
end;

//----------------------------------------------------------
// Wide version of SysUtils.AnsiExtractQuotedStr
function WideExtractQuotedStr(var Src: PWideChar; Quote: WideChar): Widestring;
var
  P, Dest: PWideChar;
  DropCount: Integer;
begin
  Result := '';
  if (Src = nil) or (Src^ <> Quote) then Exit;
  Inc(Src);
  DropCount := 1;
  P := Src;
  Src := WStrScan(Src, Quote);
  while Src <> nil do   // count adjacent pairs of quote chars
  begin
    Inc(Src);
    if Src^ <> Quote then Break;
    Inc(Src);
    Inc(DropCount);
    Src := WStrScan(Src, Quote);
  end;
  if Src = nil then Src := WStrEnd(P);
  if ((Src - P) <= 1) or ((Src - P - DropCount) = 0) then Exit;
  if DropCount = 1 then
    SetString(Result, P, Src - P - 1)
  else
  begin
    SetLength(Result, Src - P - DropCount);
    Dest := PWideChar(Result);
    Src := WStrScan(P, Quote);
    while Src <> nil do
    begin
      Inc(Src);
      if Src^ <> Quote then Break;
      Move(P^, Dest^, (Src - P) * SizeOf(WideChar));
      Inc(Dest, Src - P);
      Inc(Src);
      P := Src;
      Src := WStrScan(Src, Quote);
    end;
    if Src = nil then Src := WStrEnd(P);
    Move(P^, Dest^, (Src - P - 1) * SizeOf(WideChar));
  end;
end;

//----------------------------------------------------------
// Wide version of SysUtils.AnsiDequotedStr
function WideDequotedStr(const S: WideString; AQuote: WideChar): WideString;
var
  LText: PWideChar;
begin
  LText := PWideChar(S);
  Result := WideExtractQuotedStr(LText, AQuote);
  if Result = '' then
    Result := S;
end;

//----------------------------------------------------------
// Wide version of SysUtils.AdjustLineBreaks
function WideAdjustLineBreaks(const S: WideString; Style: TTextLineBreakStyle = tlbsCRLF ): WideString;
var
  Source, SourceEnd, Dest: PWideChar;
  DestLen: Integer;
begin
  Source := Pointer(S);
  SourceEnd := Source + Length(S);
  DestLen := Length(S);
  while Source < SourceEnd do
  begin
    case Source^ of
      #10:
        if Style = tlbsCRLF then
          Inc(DestLen);
      #13:
        if Style = tlbsCRLF then
          if Source[1] = #10 then
            Inc(Source)
          else
            Inc(DestLen)
        else
          if Source[1] = #10 then
            Dec(DestLen);
    end;
    Inc(Source);
  end;
  if DestLen = Length(Source) then
    Result := S
  else
  begin
    Source := Pointer(S);
    SetString(Result, nil, DestLen);
    Dest := Pointer(Result);
    while Source < SourceEnd do
      case Source^ of
        #10:
          begin
            if Style = tlbsCRLF then
            begin
              Dest^ := #13;
              Inc(Dest);
            end;
            Dest^ := #10;
            Inc(Dest);
            Inc(Source);
          end;
        #13:
          begin
            if Style = tlbsCRLF then
            begin
              Dest^ := #13;
              Inc(Dest);
            end;
            Dest^ := #10;
            Inc(Dest);
            Inc(Source);
            if Source^ = #10 then Inc(Source);
          end;
      else
        Dest^ := Source^;
        Inc(Dest);
        Inc(Source);
      end;
  end;
end;

//----------------------------------------------------------
// Wide version of SysUtils.StringReplace
function WideStringReplace(const S, OldPattern, NewPattern: Widestring;
  Flags: TReplaceFlags): Widestring;
var
  SearchStr, Patt, NewStr: Widestring;
  Offset: Integer;
begin
  if rfIgnoreCase in Flags then
  begin
    SearchStr := WideUpperCase(S);
    Patt := WideUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
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
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

//----------------------------------------------------------
// Wide version of StrUtils.AnsiReplaceStr
function WideReplaceStr(const AText, AFromText, AToText: WideString): WideString;
begin
  Result := WideStringReplace(AText, AFromText, AToText, [rfReplaceAll]);
end;

//----------------------------------------------------------
// Wide version of StrUtils.AnsiReplaceStr
function WideReplaceText(const AText, AFromText, AToText: WideString): WideString;
begin
  Result := WideStringReplace(AText, AFromText, AToText, [rfReplaceAll, rfIgnoreCase]);  
end;

//----------------------------------------------------------
type
  PWideStrData = ^TWideStrData;
  TWideStrData = record
    Ident: Integer;
    Str: WideString;
  end;

function EnumWideStringModules(Instance: Longint; Data: Pointer): Boolean;
var
  Buffer: array [0..1023] of widechar;
begin
  with PWideStrData(Data)^ do
  begin
    SetString(Str, Buffer,
      LoadStringW(Instance, Ident, Buffer, Length(Buffer)));
    Result := Str = '';
  end;
end;

function FindWideStringResource(Ident: Integer): WideString;
var
  StrData: TWideStrData;
begin
  StrData.Ident := Ident;
  StrData.Str := '';
  EnumResourceModules(EnumWideStringModules, @StrData);
  Result := StrData.Str;
end;


function LoadWideStr(Ident: Integer): WideString;
begin
  if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
    Result := LoadStr(Ident)
  else
    Result := FindWideStringResource(Ident);
end;

//----------------------------------------------------------
// Wide version of resourcestring loader.
function LoadResWideString(ResStringRec: PResStringRec): WideString;
begin
  Result := '';
  if ResStringRec = nil then Exit;
  if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
    Result := LoadResString(ResStringRec)
  else
  begin
    if ResStringRec.Identifier < 64*1024 then
    begin
      SetLength(Result, 1024);
      SetLength(Result,
        LoadStringW(FindResourceHInstance(ResStringRec.Module^),
          ResStringRec.Identifier, PWideChar(Result), Length(Result)));
    end
    else
      Result := PChar(ResStringRec.Identifier);
  end;
end;

//----------------------------------------------------------
function inOpSet( W : WideChar; sets : CharSet ) : boolean;
begin
  if W <= #$FF then
    Result := AnsiChar(W) in sets
  else
    Result := False;
end;

{ Support (<WideChar> in [ <WideChar>,.... ]) block }
function inOpArray( W : WideChar; sets : array of WideChar ) : Boolean;
var
  ind : integer;
begin
  Result := true;
  for ind := 0 to High(sets) do
  begin
    if W = sets[ind] then exit;
  end;
  Result := False;
end;

//----------------------------------------------------------


function IsUTF8LeadByte(Lead: AnsiChar): boolean;
begin
  result := (Byte(Lead) <= $7F) or (($C2 <= Byte(Lead)) and (Byte(Lead) <= $FD));
end;

function IsUTF8TrailByte(Lead: AnsiChar): Boolean;
begin
  result := ($80 <= Byte(Lead)) and (Byte(Lead) <= $BF);
end;

function UTF8CharSize(Lead: AnsiChar): Integer;
begin
  case Lead of
    #$00..#$7F: Result := 1; //
    #$C2..#$DF: Result := 2; // 110x xxxx C0 - DF
    #$E0..#$EF: Result := 3; // 1110 xxxx E0 - EF
    #$F0..#$F7: Result := 4; // 1111 0xxx F0 - F7 // outside traditional UNICODE
    #$F8..#$FB: Result := 5; // 1111 10xx F8 - FB // outside UTF-16
    #$FC..#$FD: Result := 6; // 1111 110x FC - FD // outside UTF-16
  else
    Result := 0; // Illegal leading character.
  end;
end;

function UTF8CharLength(Lead: AnsiChar): Integer; inline;
begin
  Result := 1;
  if (Lead >= #$C2) and (Lead <= #$FD) then
    Result:= UTF8CharSize(Lead);
end;

end.
