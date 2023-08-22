{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit MaskUtils;

{$R-,T-,H+,X+}

interface

const
  mDirReverse = '!';         { removes leading blanks if true, else trailing blanks}
  mDirUpperCase = '>';       { all chars that follow to upper case }
  mDirLowerCase = '<';       { all chars that follow to lower case }
                             { '<>' means remove casing directive }
  mDirLiteral = '\';         { char that immediately follows is a literal }

  mMskAlpha = 'L';           { in US = A-Z,a-z }
  mMskAlphaOpt = 'l';
  mMskAlphaNum = 'A';        { in US = A-Z,a-z,0-9 }
  mMskAlphaNumOpt  = 'a';
  mMskAscii = 'C';           { any character}
  mMskAsciiOpt = 'c';
  mMskNumeric = '0';         { 0-9, no plus or minus }
  mMskNumericOpt = '9';
  mMskNumSymOpt = '#';       { 0-9, plus and minus }

   { intl literals }
  mMskTimeSeparator = ':';
  mMskDateSeparator = '/';

type
  TMaskCharType = (mcNone, mcLiteral, mcIntlLiteral, mcDirective, mcMask,
    mcMaskOpt, mcFieldSeparator, mcField);
  TMaskDirectives = set of (mdReverseDir, mdUpperCase, mdLowerCase,
    mdLiteralChar);
  TMaskedText = type string;
  TEditMask = type string;

function FormatMaskText(const EditMask: string; const Value: string): string;
function MaskGetMaskSave(const EditMask: string): Boolean;
function MaskGetMaskBlank(const EditMask: string): Char;
function MaskGetFldSeparator(const EditMask: string): Integer;
function PadInputLiterals(const EditMask: String; const Value: string; Blank: Char): string;
function MaskOffsetToOffset(const EditMask: String; MaskOffset: Integer): Integer;
function MaskOffsetToWideOffset(const EditMask: String; MaskOffset: Integer): Integer;
function IsLiteralChar(const EditMask: string; Offset: Integer): Boolean;
function MaskGetCharType(const EditMask: string; MaskOffset: Integer): TMaskCharType;
function MaskGetCurrentDirectives(const EditMask: string; MaskOffset: Integer): TMaskDirectives;
function MaskIntlLiteralToChar(IChar: Char): Char;
function OffsetToMaskOffset(const EditMask: string; Offset: Integer): Integer;
function MaskDoFormatText(const EditMask: string; const Value: string; Blank: Char): string;

var
  DefaultBlank: Char = '_';
  MaskFieldSeparator: Char = ';';
  MaskNoSave: Char = '0';

implementation

uses SysUtils;

{ Mask utility routines }

function MaskGetCharType(const EditMask: string; MaskOffset: Integer): TMaskCharType;
var
  MaskChar: Char;
begin
  Result := mcLiteral;
  MaskChar := #0;
  if MaskOffset <= Length(EditMask) then
    MaskChar := EditMask[MaskOffset];
  if MaskOffset > Length(EditMask) then
    Result := mcNone

  else if ByteType(EditMask, MaskOffset) <> mbSingleByte then
    Result := mcLiteral

  else if (MaskOffset > 1) and (EditMask[MaskOffset - 1] = mDirLiteral) and
      (ByteType(EditMask, MaskOffset - 1) = mbSingleByte) and
      not ((MaskOffset > 2) and (EditMask[MaskOffset - 2] = mDirLiteral) and
      (ByteType(EditMask, MaskOffset - 2) = mbSingleByte)) then
    Result := mcLiteral

  else if (MaskChar = MaskFieldSeparator) and
         (Length(EditMask) >= 4) and
         (MaskOffset > Length(EditMask) - 4) then
    Result := mcFieldSeparator

  else if (Length(EditMask) >= 4) and
         (MaskOffset > (Length(EditMask) - 4)) and
         (EditMask[MaskOffset - 1] = MaskFieldSeparator) and
         not ((MaskOffset > 2) and (EditMask[MaskOffset - 2] = mDirLiteral) and
         (ByteType(EditMask, MaskOffset - 2) <> mbTrailByte)) then
    Result := mcField

  else if MaskChar in [mMskTimeSeparator, mMskDateSeparator] then
    Result := mcIntlLiteral

  else if MaskChar in [mDirReverse, mDirUpperCase, mDirLowerCase,
      mDirLiteral] then
    Result := mcDirective

  else if MaskChar in [mMskAlphaOpt, mMskAlphaNumOpt, mMskAsciiOpt,
      mMskNumSymOpt, mMskNumericOpt] then
    Result := mcMaskOpt

  else if MaskChar in [mMskAlpha, mMskAlphaNum, mMskAscii, mMskNumeric] then
    Result := mcMask;
end;

function MaskGetCurrentDirectives(const EditMask: string;
  MaskOffset: Integer): TMaskDirectives;
var
  I: Integer;
  MaskChar: Char;
begin
  Result := [];
  for I := 1 to Length(EditMask) do
  begin
    MaskChar := EditMask[I];
    if (MaskChar = mDirReverse) then
      Include(Result, mdReverseDir)
    else if (MaskChar = mDirUpperCase) and (I < MaskOffset) then
    begin
      Exclude(Result, mdLowerCase);
      if not ((I > 1) and (EditMask[I-1] = mDirLowerCase)) then
        Include(Result, mdUpperCase);
    end
    else if (MaskChar = mDirLowerCase) and (I < MaskOffset) then
    begin
      Exclude(Result, mdUpperCase);
      Include(Result, mdLowerCase);
    end;
  end;
  if MaskGetCharType(EditMask, MaskOffset) = mcLiteral then
    Include(Result, mdLiteralChar);
end;

function MaskIntlLiteralToChar(IChar: Char): Char;
begin
  Result := IChar;
  case IChar of
    mMskTimeSeparator: Result := Char(TimeSeparator);
    mMskDateSeparator: Result := Char(DateSeparator);
  end;
end;

function MaskDoFormatText(const EditMask: string; const Value: string;
  Blank: Char): string;
var
  I: Integer;
  Offset, MaskOffset: Integer;
  CType: TMaskCharType;
  Dir: TMaskDirectives;
begin
  Result := Value;
  Dir := MaskGetCurrentDirectives(EditMask, 1);

  if not (mdReverseDir in Dir) then
  begin
      { starting at the beginning, insert literal chars in the string
        and add spaces on the end }
    Offset := 1;
    for MaskOffset := 1 to Length(EditMask) do
    begin
      CType := MaskGetCharType(EditMask, MaskOffset);

      if CType in [mcLiteral, mcIntlLiteral] then
      begin
        Result := Copy(Result, 1, Offset - 1) +
          MaskIntlLiteralToChar(EditMask[MaskOffset]) +
          Copy(Result, Offset, Length(Result) - Offset + 1);
        Inc(Offset);
      end
      else if CType in [mcMask, mcMaskOpt] then
      begin
        if Offset > Length(Result) then
          Result := Result + Blank;
        Inc(Offset);
      end;
    end;
  end
  else
  begin
      { starting at the end, insert literal chars in the string
        and add spaces at the beginning }
    Offset := Length(Result);
    for I := 0 to(Length(EditMask) - 1) do
    begin
      MaskOffset := Length(EditMask) - I;
      CType := MaskGetCharType(EditMask, MaskOffset);
      if CType in [mcLiteral, mcIntlLiteral] then
      begin
        Result := Copy(Result, 1, Offset) +
               MaskIntlLiteralToChar(EditMask[MaskOffset]) +
               Copy(Result, Offset + 1, Length(Result) - Offset);
      end
      else if CType in [mcMask, mcMaskOpt] then
      begin
        if Offset < 1 then
          Result := Blank + Result
        else
          Dec(Offset);
      end;
    end;
  end;
end;

function MaskGetMaskSave(const EditMask: string): Boolean;
var
  I: Integer;
  Sep1, Sep2: Integer;
begin
  Result := True;
  if Length(EditMask) >= 4 then
  begin
    Sep1 := -1;
    Sep2 := -1;
    I := Length(EditMask);
    while Sep2 < 0 do
    begin
      if (MaskGetCharType(EditMask, I) =  mcFieldSeparator) then
      begin
        if Sep1 < 0 then
          Sep1 := I
        else
          Sep2 := I;
      end;
      Dec(I);
      if (I <= 0) or(I < Length(EditMask) - 4) then
        Break;
    end;
    if Sep2 < 0 then
      Sep2 := Sep1;
    if (Sep2 > 0) and (Sep2 <> Length(EditMask)) then
      Result := not (EditMask [Sep2 + 1] = MaskNoSave);
  end;
end;

function MaskGetMaskBlank(const EditMask: string): Char;
begin
  Result := DefaultBlank;
  if Length(EditMask) >= 4 then
  begin
    if (MaskGetCharType(EditMask, Length(EditMask) - 1) =
                                                  mcFieldSeparator) then
    begin
        {in order for blank specifier to be valid, there
         must also be a save specifier }
      if (MaskGetCharType(EditMask, Length(EditMask) - 2) =
                                                  mcFieldSeparator) or
        (MaskGetCharType(EditMask, Length(EditMask) - 3) =
                                                  mcFieldSeparator) then
      begin
        Result := EditMask [Length(EditMask)];
      end;
    end;
  end;
end;

function MaskGetFldSeparator(const EditMask: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  if Length(EditMask) >= 4 then
  begin
    for I := (Length(EditMask) - 4) to Length(EditMask) do
    begin
      if (MaskGetCharType(EditMask, I) = mcFieldSeparator) then
      begin
        Result := I;
        Exit;
      end;
    end;
  end;
end;

function MaskOffsetToString(const EditMask: String; MaskOffset: Integer): string;
var
  I: Integer;
  CType: TMaskCharType;
begin
  Result := '';
  for I := 1 to MaskOffset do
  begin
    CType := MaskGetCharType(EditMask, I);
    if not (CType in [mcDirective, mcField, mcFieldSeparator]) then
      Result := Result + EditMask[I];
  end;
end;

function MaskOffsetToOffset(const EditMask: String; MaskOffset: Integer): Integer;
begin
  Result := length(MaskOffsetToString(Editmask, MaskOffset));
end;

function MaskOffsetToWideOffset(const EditMask: String; MaskOffset: Integer): Integer;
begin
  Result := length( WideString(MaskOffsetToString(Editmask, MaskOffset)));
end;

function OffsetToMaskOffset(const EditMask: string; Offset: Integer): Integer;
var
  I: Integer;
  Count: Integer;
  MaxChars: Integer;
begin
  MaxChars  := MaskOffsetToOffset(EditMask, Length(EditMask));
  if Offset > MaxChars then
  begin
    Result := -1;
    Exit;
  end;

  Result := 0;
  Count := Offset;
  for I := 1 to Length(EditMask) do
  begin
    Inc(Result);
    if not (mcDirective = MaskGetCharType(EditMask, I)) then
    begin
      Dec(Count);
      if Count < 0 then
        Exit;
    end;
  end;
end;

function IsLiteralChar(const EditMask: string; Offset: Integer): Boolean;
var
  MaskOffset: Integer;
  CType: TMaskCharType;
begin
  Result := False;
  MaskOffset := OffsetToMaskOffset(EditMask, Offset);
  if MaskOffset >= 0 then
  begin
    CType := MaskGetCharType(EditMask, MaskOffset);
    Result := CType in [mcLiteral, mcIntlLiteral];
  end;
end;

function PadSubField(const EditMask: String; const Value: string;
  StartFld, StopFld, Len: Integer; Blank: Char): string;
var
  Dir: TMaskDirectives;
  StartPad: Integer;
  K: Integer;
begin
  if (StopFld - StartFld) < Len then
  begin
     { found literal at position J, now pad it }
    Dir := MaskGetCurrentDirectives(EditMask, 1);
    StartPad := StopFld - 1;
    if mdReverseDir in Dir then
      StartPad := StartFld - 1;
    Result := Copy(Value, 1, StartPad);
    for K := 1 to (Len - (StopFld - StartFld)) do
      Result := Result + Blank;
    Result := Result + Copy(Value, StartPad + 1, Length(Value));
  end
  else if (StopFld - StartFld) > Len then
  begin
    Dir := MaskGetCurrentDirectives(EditMask, 1);
    if mdReverseDir in Dir then
      Result := Copy(Value, 1, StartFld - 1) +
        Copy(Value, StopFld - Len, Length(Value))
    else
      Result := Copy(Value, 1, StartFld + Len - 1) +
        Copy(Value, StopFld, Length(Value));
  end
  else
    Result := Value;
end;

function PadInputLiterals(const EditMask: String; const Value: string;
  Blank: Char): string;
var
  J: Integer;
  LastLiteral, EndSubFld: Integer;
  Offset, MaskOffset: Integer;
  CType: TMaskCharType;
  MaxChars: Integer;
begin
  LastLiteral := 0;

  Result := Value;
  for MaskOffset := 1 to Length(EditMask) do
  begin
    CType := MaskGetCharType(EditMask, MaskOffset);
    if CType in [mcLiteral, mcIntlLiteral] then
    begin
      Offset := MaskOffsetToOffset(EditMask, MaskOffset);
      EndSubFld := Length(Result) + 1;
      for J := LastLiteral + 1 to Length(Result) do
      begin
        if Result[J] = MaskIntlLiteralToChar(EditMask[MaskOffset]) then
        begin
          EndSubFld := J;
          Break;
        end;
      end;
       { we have found a subfield, ensure that it complies }
      if EndSubFld > Length(Result) then
        Result := Result + MaskIntlLiteralToChar(EditMask[MaskOffset]);
      Result := PadSubField(EditMask, Result, LastLiteral + 1, EndSubFld,
        Offset - (LastLiteral + 1), Blank);
      LastLiteral := Offset;
    end;
  end;

    {ensure that the remainder complies, too }
  MaxChars  := MaskOffsetToOffset(EditMask, Length(EditMask));
  if Length (Result) <> MaxChars then
    Result := PadSubField(EditMask, Result, LastLiteral + 1, Length (Result) + 1,
      MaxChars - LastLiteral, Blank);

    { replace non-literal blanks with blank char }
  for Offset := 1 to Length (Result) do
  begin
    if Result[Offset] = ' ' then
    begin
      if not IsLiteralChar(EditMask, Offset - 1) then
        Result[Offset] := Blank;
    end;
  end;
end;

function FormatMaskText(const EditMask: string; const Value: string ): string;
begin
  if MaskGetMaskSave(EditMask) then
    Result := PadInputLiterals(EditMask, Value, ' ')
  else
    Result := MaskDoFormatText(EditMask, Value, ' ');
end;

end.


