(*
 * StdFuncs -
 *   A file chock full of functions that should exist in Delphi, but
 *   don't, like "Max", "GetTempFile", "Soundex", etc...
 *)
unit StdFuncs;

interface

uses
  Windows, Classes, SysUtils, variants;

type
  EParserError = class(Exception);
  TCharSet = set of Char;

function ConvertFromBase(sNum: String; iBase: Integer; cDigits: String): Integer;
function ConvertToBase(iNum, iBase: Integer; cDigits: String): String;
function EnsureSentenceTerminates(Sentence: String; Terminator: Char): String;
function FindTokenStartingAt(st: String; var i: Integer;
  TokenChars: TCharSet; TokenCharsInToken: Boolean): String;
function GetDirectoryOfFile(FileName: String): String;
function GetTempFile(FilePrefix: String): String;
function Icon2Bitmap(Icon: HICON): HBITMAP;
function Max(n1, n2: Integer): Integer;
function MaxD(n1, n2: Double): Double;
function Min(n1, n2: Integer): Integer;
function MinD(n1, n2: Double): Double;
function RandomString(iLength: Integer): String;
function RandomInteger(iLow, iHigh: Integer): Integer;
function Soundex(st: String): String;
function StripString(st: String; CharsToStrip: String): String;
function ClosestWeekday(const d: TDateTime): TDateTime;
function Year(d: TDateTime): Integer;
function Month(d: TDateTime): Integer;
function DayOfYear(d: TDateTime): Integer;
function DayOfMonth(d: TDateTime): Integer;
function VarCoalesce(V1, V2: Variant): Variant;
function VarEqual(V1, V2: Variant): Boolean;
procedure WeekOfYear(d: TDateTime; var Year, Week: Integer);
function Degree10(Degree:integer):double;
// Comp type stuff
function CompToStr(Value: comp): string;
function StrToComp(const Value: string): comp;
function CompDiv(A, B: comp): comp;
function CompMod(A, B: comp): comp;

type PComp=^Comp;
//end Comp type stuff

var
  TempPath: PChar;
  TempPathLength: Integer;

implementation

uses
  StdConsts;

function Degree10(Degree:integer):double;
var i:integer;
begin
 Result:=1;
 if Degree>0 then
  for i:=0 to Pred(Degree) do  Result:=Result*10
 else
  for i:=0 downto Succ(Degree) do  Result:=Result/10
end;

// Comp type stuff

function StrToComp(const Value: string): comp;
var e:integer;
begin
 Val(Value, Result, E);
 if e<>0  Then raise EConvertError.CreateFmt('Invalid comp value', [Value]);
end;

function CompToStr(Value: comp): string;
var
  A: Extended;
  I: Integer;
  NonZero: boolean;
const
  divs: array[1..19] of comp = (1, 10, 100, 1E3, 1E4, 1E5, 1E6, 1E7, 1E8,
1E9, 1E10, 1E11, 1E12, 1E13, 1E14, 1E15, 1E16, 1E17, 1E18);
begin
//  InitFPU;
  if (Value<1E18) and (Value>-1E18) then begin
   FmtStr(Result,'%.f', [Value]);
   Exit
  end;

  if Value = 0 then
  begin
    Result := '0';
    exit;
  end;
  Result := '';
  if Value < 0 then
  begin
    Result := Result + '-';
    Value := -Value;
  end;
  NonZero := false;
  for I := 19 downto 1 do
  begin
    A := Value/divs[I];
    if NonZero or (Trunc(A) > 0) then
    begin
      Result := Result + Chr(48 + Trunc(A));
      NonZero := true;
    end;
    Value := Value - Trunc(A) * divs[I];
  end;
end;

function CompDiv(A, B: comp): comp;
var
    C: comp;
begin
//    InitFPU;
    if A < 0 then A := -A;
    Result := A/B;
    C := Result * B -A;
    if C > 0 then
      Result := Result - 1;
end;

function CompMod(A, B: comp): comp;
var
    C: comp;
begin
//    InitFPU;
    if A < 0 then A := -A;
    Result := A/B;
    C := Result * B - A ;
    if C > 0 then
      Result := Result - 1;
    C := Result * B;
    Result := A - C;
end;
//
function ConvertFromBase(sNum: String; iBase: Integer; cDigits: String): Integer;
var
  i: Integer;

  function GetValue(c: Char): Integer;
  var
    i: Integer;
  begin
    result := 0;
    for i := 1 to Length(cDigits) do
      if (cDigits[i] = c) then begin
        result := i - 1;
        exit;
      end;
  end;

begin
  result := 0;
  for i := 1 to Length(sNum) do
    result := (result * iBase) + GetValue(sNum[i]);
end;

function ConvertToBase(iNum, iBase: Integer; cDigits: String): String;
var
  i, r: Integer;
  s: String;
const
  iLength = 16;
begin
  result := '';
  SetString(s, nil, iLength);
  i := 0;
  repeat
    r := iNum mod iBase;
    Inc(i);
    if (i > iLength) then
      SetString(s, PChar(s), Length(s) + iLength);
    s[i] := cDigits[r + 1];
    iNum := iNum div iBase;
  until iNum = 0;
  SetString(result, nil, i);
  for r := 1 to i do
    result[r] := s[i - r + 1];
end;

function EnsureSentenceTerminates(Sentence: String; Terminator: Char): String;
begin
  if (Length(Sentence) > 0) and (Sentence[Length(Sentence)] <> Terminator) then
    result := Sentence + Terminator
  else
    result := Sentence;
end;

function FindTokenStartingAt(st: String; var i: Integer;
  TokenChars: TCharSet; TokenCharsInToken: Boolean): String;
var
  Len, j: Integer;
begin
  if (i < 1) then i := 1;
  j := i; Len := Length(st);
  while (j <= Len) and
        ((TokenCharsInToken and (not (st[j] in TokenChars))) or
         ((not TokenCharsInToken) and (st[j] in TokenChars))) do Inc(j);
  i := j;
  while (j <= Len) and
        (((not TokenCharsInToken) and (not (st[j] in TokenChars))) or
         (TokenCharsInToken and (st[j] in TokenChars))) do Inc(j);
  if (i > Len) then
    result := ''
  else
    result := Copy(st, i, j - i);
  i := j;
end;

function GetDirectoryOfFile(FileName: String): String;
var
  szPath, szFile: PChar;
  iLength: Integer;
begin
  szPath := nil;
  iLength := GetFullPathName(PChar(FileName), 0, nil, szFile) + 1;
  try
    GetMem(szPath, iLength);
    GetFullPathName(PChar(FileName), iLength, szPath, szFile);
    result := Copy(String(szPath), 1, szFile - szPath);
  finally
    FreeMem(szPath);
  end;
end;

function GetTempFile(FilePrefix: String): String;
var
  sz: PChar;
begin
  GetMem(sz, TempPathLength + EIGHT_PLUS_THREE + 3);
  try
    GetTempFileName(TempPath, PChar(FilePrefix), 0, sz);
    result := String(sz);
  finally
    FreeMem(sz);
  end;
end;

function Icon2Bitmap(Icon: HICON): HBITMAP;
var
  IconInfo: TIconInfo;
begin
  if not GetIconInfo(Icon, IconInfo) then
    result := 0
  else
    result := IconInfo.hbmColor;
end;

function Max(n1, n2: Integer): Integer;
begin
  if (n1 > n2) then
    result := n1
  else
    result := n2;
end;

function MaxD(n1, n2: Double): Double;
begin
  if (n1 > n2) then
    result := n1
  else
    result := n2;
end;

function Min(n1, n2: Integer): Integer;
begin
  if (n1 < n2) then
    result := n1
  else
    result := n2;
end;

function MinD(n1, n2: Double): Double;
begin
  if (n1 < n2) then
    result := n1
  else
    result := n2;
end;

function RandomString(iLength: Integer): String;
begin
  result := '';
  while Length(result) < iLength do
    result := result + IntToStr(RandomInteger(0, High(Integer)));
  if Length(result) > iLength then
    result := Copy(result, 1, iLength);
end;

function RandomInteger(iLow, iHigh: Integer): Integer;
begin
  result := Trunc(Random(iHigh - iLow)) + iLow;
end;

function Soundex(st: String): String;
var
  code: Char;
  i, j, len: Integer;
begin
  result := ' 0000';
  if (st = '') then exit;
  result[1] := UpCase(st[1]);
  j := 2;                   
  i := 2;
  len := Length(st);
  while (i <= len) and (j < 6) do begin
    case st[i] of
      'B', 'F', 'P', 'V', 'b', 'f', 'p', 'v' : code := '1';
      'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z',
      'c', 'g', 'j', 'k', 'q', 's', 'x', 'z' : code := '2';
      'D', 'T', 'd', 't' :                     code := '3';
      'L', 'l' :                               code := '4';
      'M', 'N', 'm', 'n' :                     code := '5';
      'R', 'r' :                               code := '6';
    else
      code := '0';
    end; {case}

    if (code <> '0') and (code <> result[j - 1]) then begin
      result[j] := code;
      inc(j);
    end;
    inc(i);
  end;
end;

function StripString(st: String; CharsToStrip: String): String;
var
  i: Integer;
begin
  result := '';
  for i := 1 to Length(st) do begin
    if Pos(st[i], CharsToStrip) = 0 then
      result := result + st[i];
  end;
end;

function ClosestWeekday(const d: TDateTime): TDateTime;
begin
  if (DayOfWeek(d) = 1) then
    result := d + 1
  else if (DayOfWeek(d) = 7) then
    result := d + 2
  else
    result := d;
end;

function Year(d: TDateTime): Integer;
var
  y, m, day: Word;
begin
  DecodeDate(d, y, m, day);
  result := y;
end;

function Month(d: TDateTime): Integer;
var
  yr, mn, dy: Word;
begin
  DecodeDate(d, yr, mn, dy);
  result := mn;
end;

function DayOfYear(d: TDateTime): Integer;
var
  yr, mn, dy: Word;
  b: TDateTime;
begin
  DecodeDate(d, yr, mn, dy);
  b := EncodeDate(yr, 1, 1);
  result := Trunc(d - b);
end;

function DayOfMonth(d: TDateTime): Integer;
var
  yr, mn, dy: Word;
begin
  DecodeDate(d, yr, mn, dy);
  result := dy;
end;

function VarCoalesce(V1, V2: Variant): Variant;
begin
  if (VarIsNull(V1) or VarIsEmpty(V1)) then
    result := V2
  else
    result := V1;
end;

function VarEqual(V1, V2: Variant): Boolean;
begin
  try
    result := V1 = V2;
  except
    result := (VarIsNull(V1) and VarIsNull(V2)) or
              (VarIsEmpty(V1) and VarIsEmpty(V2));
  end;
end;

procedure WeekOfYear(d: TDateTime; var Year, Week: Integer);
var
  yr, mn, dy: Word;
  dow_ybeg: Integer;
  ThisLeapYear, LastLeapYear: Boolean;
begin
  DecodeDate(d, yr, mn, dy);
  // When did the year begin?
  Year := yr;
  dow_ybeg := SysUtils.DayOfWeek(EncodeDate(yr, 1, 1));
  ThisLeapYear := IsLeapYear(yr);
  LastLeapYear := IsLeapYear(yr - 1);
  // Get the Sunday beginning this week.
  Week := (DayOfYear(d) - DayOfWeek(d) + 1);
  (*
   * If the Sunday beginning this week was last year, then
   *   if this year begins on a Wednesday or previous, then
   *     this is most certainly the first week of the year.
   *   if this year begins on a thursday or
   *     last year was a leap year and this year begins on a friday, then
   *     this week is 53 of last year.
   *   Otherwise this week is 52 of last year.
   *)
  if Week <= 0 then begin
    if (dow_ybeg <= 4) then
      Week := 1
    else if (dow_ybeg = 5) or (LastLeapYear and (dow_ybeg = 6)) then begin
      Week := 53;
      Dec(Year);
    end else begin
      Week := 52;
      Dec(Year);
    end;
  (* If the Sunday beginning this week falls in this year!!! Yeah
   *   if the year begins on a Sun, Mon, Tue or Wed then
   *     This week # is (Week + 7) div 7
   *   otherwise this week is
   *     Week div 7 + 1.
   *   if the week is > 52 then
   *     if this year began on a wed or this year is leap year and it
   *       began on a tuesday, then set the week to 53.
   *     otherwise set the week to 1 of *next* year.
   *)
  end else begin
    if (dow_ybeg <= 4) then
      Week := (Week + 6 + dow_ybeg) div 7
    else
      Week := (Week div 7) + 1;
    if Week > 52 then begin
      if (dow_ybeg = 4) or (ThisLeapYear and (dow_ybeg = 3)) then
        Week := 53
      else begin
        Week := 1;
        Inc(Year);
      end;
    end;
  end;
end;

initialization

  Randomize;
  TempPathLength := GetTempPath(0, nil) + 1;
  GetMem(TempPath, TempPathLength);
  GetTempPath(TempPathLength, TempPath);

finalization

  FreeMem(TempPath, TempPathLength);

end.
