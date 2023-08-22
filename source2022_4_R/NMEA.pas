////////////////////////////////////////////////////////////////////////////////
//     National Marine Electronics Association (NMEA)                         //
//     Contains code to process NMEA formatted sentences and data fields      //
//     C SEITZ  August 2006                                                   //
////////////////////////////////////////////////////////////////////////////////

                              UNIT NMEA;

                              INTERFACE


type NMEADataArray = array of string;

procedure TrimNMEA(var S: string);
procedure ExpandNMEA(var S: string);
function ParseNMEA(S: string): NMEADataArray;
function ChkValidNMEA(S: string): Boolean;
function IdNMEA(S: string): string;
function ChkSumNMEA(const S: string): string;
function PosInDeg(const PosStr: string): Double;
function DateTimeNMEA(const StrD, StrT: string): TDateTime;
function SysClockSet(const StrD, StrT: string): Boolean;



                             IMPLEMENTATION

uses  SysUtils, Windows;

{Removes $ and *HH from a NMEA sentence}

procedure TrimNMEA(var S: string);
var
  i: Integer;
begin
  i := Pos('$', s);
  if (i = 0) then
    i := Pos('!', s);                 // AIS encapsulated begin with Char(!)
  Delete(s, 1, i);
  i := Pos('*', s);
  if (i = 0) then Exit;               // Probably is no check sum
  s := Copy(s, 1, i-1);
end;


{Adds $ and *HH to a NMEA sentence}

procedure ExpandNMEA(var S: string);
begin
  S := '$' + S + '*' + ChkSumNMEA(S);
end;


{Separates comma delimited NEMA sentence into elements of a dynamic array }
{Empty fields are represented by ''}

function ParseNMEA(S: string): NMEADataArray;
var
  n, i: Integer;
begin
  TrimNMEA(S);
  i := 0;
  repeat
    SetLength(Result, i+1);
    n := Pos( ',', S);
    if (n = 0) then
      Result[i] := S
    else
      Result[i] := Copy(S, 1, n-1);
    Delete(S, 1, n);
    Inc(i);
  until (n = 0);
end;


{Tests a sentence to determine if NMEA check sum is valid}

function ChkValidNMEA(S: string): Boolean;
var
  i : Integer;
  Cs: string;
begin
  i := Pos('*', S);
  Cs := Copy(S, i+1, 2);              // The checksum
  TrimNMEA(S);
  Result := (Cs = ChkSumNMEA(S));
end;


{Computes NMEA check sum from user prepared sentence}

function ChkSumNMEA(const S: string): string;
var
  i, n: Byte;
begin
  n := Ord(S[1]);
  for i := 2 to Length(S) do
    n := n xor Ord(S[i]);
  Result := IntToHex(n, 2);
end;


{Returns the sentence ID - i.e. GPRMC}

function IdNMEA(S: string): string;
var
  i: integer;
begin
  TrimNMEA(S);
  i := Pos(',', S);
  Result := Copy(S, 1, i-1);
end;


{Converts NMEA position 'DDDMM.mmm' 'DDMM.mmm' to position in deg}

function PosInDeg(const PosStr: string): Double;
var
  DegStr, MinStr: string;
  i: Integer;
  Deg, Min: Double;
begin
  i := Pos('.', PosStr);
  DegStr := Copy(PosStr, 1, i-3);
  MinStr := Copy(PosStr, i-2, 10);    // Accomodates 3 or more decimal places
  Deg := StrToFloat(DegStr);
  Min := StrToFloat(MinStr);
  Result := Deg + Min/60;
end;


{Delphi TDateTime from NMEA Date & Time fields}

function DateTimeNMEA(const StrD, StrT: string): TDateTime;
var
  WinTimeRec: TSystemTime;
  hh, mm, ss, dd, mn, yy: string;
begin

//   UTC  hhmmss                   UTC date ddmmyy

  hh := Copy(StrT, 1, 2);       dd := Copy(StrD, 1, 2);
  mm := Copy(StrT, 3, 2);       mn := Copy(StrD, 3, 2);
  ss := Copy(StrT, 5, 2);       yy := Copy(StrD, 5, 2);

  with WinTimeRec do
    try
      wYear:= 2000 + StrToInt(yy);    // yyyy
      wMonth := StrToInt(mn);         // Jan = 1
      wDayOfWeek := 0;                // Ignored
      wDay := StrToInt(dd);
      wHour:= StrToInt(hh);
      wMinute := StrToInt(mm);
      wSecond := StrToInt(ss);
      wMilliseconds := 000;
      Result := SystemTimeToDateTime(WinTimeRec);
    except
      Result := -1;
    end;
end;


{Sets the computer system (UTC) clock, returns true if successful}

function SysClockSet(const StrD, StrT: string): Boolean;
var
  WinTimeRec: TSystemTime;
  DateTime: TDateTime;
begin
  DateTime := DateTimeNMEA(StrD, StrT);
  DateTimeToSystemTime(DateTime, WinTimeRec);
  Result := SetSystemTime(WinTimeRec);
end;

end.  // NMEA
