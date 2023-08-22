{
//
// Components : System routines
//
// Copyright (c) 1998-2001 by Woll2Woll Software
//
// 12/16/98 - Add epoch property for Delphi 4 support of TwwDBEdit.
// 8/15/2001 - Keep scanning for other digits in wwStrToFloat2.
// 5/7/03 - In case of null string in wwStrtoFloat2
}
unit wwSystem;

{$N+,P+,S-,G+,R-}

interface

//{$i wwIfDef.pas}

uses sysutils, stdctrls;

type
  TwwDateOrder = (doMDY, doDMY, doYMD);
  TwwDateTimeSelection = (wwdsDay, wwdsMonth, wwdsYear, wwdsHour, wwdsMinute, wwdsSecond, wwdsAMPM);

function wwStrToDate(const S: string): boolean;
function wwStrToTime(const S: string): boolean;
function wwStrToDateTime(const S: string): boolean;
function wwStrToTimeVal(const S: string): TDateTime;
function wwStrToDateVal(const S: string): TDateTime;
function wwStrToDateTimeVal(const S: string): TDateTime;
function wwStrToInt(const S: string): boolean;
function wwStrToFloat(const S: string): boolean;
function wwGetDateOrder(const DateFormat: string): TwwDateOrder;
function wwNextDay(Year, Month, Day: Word): integer;
function wwPriorDay(Year, Month, Day: Word): integer;
function wwDoEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;
function wwDoEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDateTime): Boolean;
Function wwGetDateTimeCursorPosition(SelStart: integer; Text: string;
    TimeOnly: Boolean): TwwDateTimeSelection;
Function wwGetTimeCursorPosition(SelStart: integer; Text: string): TwwDateTimeSelection;
function wwScanDate(const S: string; var Date: TDateTime): Boolean;
//{$ifdef wwdelphi4up}
function wwScanDateEpoch(const S: string; var Date: TDateTime; Epoch: integer): Boolean;
//{$endif}
Procedure wwSetDateTimeCursorSelection(dateCursor: TwwDateTimeSelection;
    edit: TCustomEdit; TimeOnly: Boolean);
function wwStrToFloat2(const S: string; var FloatValue: Extended; DisplayFormat: string): boolean;

implementation

uses
{$IFDEF WIN32}
   Windows,
{$ENDIF}
   wwstr;

type
  PDayTable = ^TDayTable;
  TDayTable = array[1..12] of Word;

{$IFDEF WIN32}
function CurrentYear: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wYear;
end;
{$ELSE}
function CurrentYear: Word; assembler;
asm
        MOV     AH,2AH
        INT     21H
        MOV     AX,CX
end;
{$ENDIF}

{$IFDEF WIN32}
function LongMul(I, J: Word): Integer;
begin
  Result := I * J;
end;
{$ELSE}
function LongMul(I, J: Word): Longint; assembler;
asm
        MOV     AX,I
        MUL     J
end;
{$ENDIF}

procedure ScanBlanks(const S: string; var Pos: Integer);
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(S)) and (S[I] = ' ') do Inc(I);
  Pos := I;
end;

function ScanNumber(const S: string; var Pos: Integer;
  var Number: Word): Boolean;
var
  I: Integer;
  N: Word;

  Function MonthStrToInt(s: string; var num: word): boolean;
  var i: integer;
  begin
     result:= False;
     for i:= 1 to 12 do begin
        if uppercase(s)=uppercase(ShortMonthNames[i]) then
        begin
           num:= i;
           result:= True;
           break;
        end
     end
  end;

begin
  Result := False;
  ScanBlanks(S, Pos);
  I := Pos;
  N := 0;
  while (I <= Length(S)) and (S[I] in ['0'..'9']) and (N < 1000) do
  begin
    N := N * 10 + (Ord(S[I]) - Ord('0'));
    Inc(I);
  end;
  if I > Pos then
  begin
    Pos := I;
    Number := N;
    Result := True;
  end;

  if (not Result) and MonthStrToInt(copy(s, i, 3), N) then
  begin
     Pos:= i+3;
     Number:= N;
     Result:= True;
  end
end;

function ScanString(const S: string; var Pos: Integer;
  const Symbol: string): Boolean;
begin
  Result := False;
  if Symbol <> '' then
  begin
    ScanBlanks(S, Pos);
    if AnsiCompareText(Symbol, Copy(S, Pos, Length(Symbol))) = 0 then
    begin
      Inc(Pos, Length(Symbol));
      Result := True;
    end;
  end;
end;

function ScanChar(const S: string; var Pos: Integer; Ch: Char): Boolean;
begin
  Result := False;
  ScanBlanks(S, Pos);
  if (Pos <= Length(S)) and (S[Pos] = Ch) then
  begin
    Inc(Pos);
    Result := True;
  end;
end;


function wwGetDateOrder(const DateFormat: string): TwwDateOrder;
var
  I: Integer;
begin
  I := 1;
  Result := doMDY;
  while I <= Length(DateFormat) do
  begin
    case Chr(Ord(DateFormat[I]) and $DF) of
      'Y': Result := doYMD;
      'M': Result := doMDY;
      'D': Result := doDMY;
    else
      Inc(I);
      Continue;
    end;
    Exit;
  end;
  Result := doMDY;
end;

function IsLeapYear(Year: Word): Boolean;
begin
  Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
end;

function GetDayTable(Year: Word): PDayTable;
const
  DayTable1: TDayTable = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  DayTable2: TDayTable = (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  DayTables: array[Boolean] of PDayTable = (@DayTable1, @DayTable2);
begin
  Result := DayTables[IsLeapYear(Year)];
end;

function wwNextDay(Year, Month, Day: Word): integer;
var DayTable: PDayTable;
begin
   DayTable := GetDayTable(Year);
   if Day>=DayTable^[Month] then Result:= 1 else Result:= Day + 1;
end;

function wwPriorDay(Year, Month, Day: Word): integer;
var DayTable: PDayTable;
begin
   DayTable := GetDayTable(Year);
   if Day=1 then Result:= DayTable^[Month] else Result:= Day-1;
end;

function wwDoEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;
var
  I: Word;
  DayTable: PDayTable;
begin
  Result := False;
  DayTable := GetDayTable(Year);
  if (Year >= 1) and (Year <= 9999) and (Month >= 1) and (Month <= 12) and
    (Day >= 1) and (Day <= DayTable^[Month]) then
  begin
    for I := 1 to Month - 1 do Inc(Day, DayTable^[I]);
    I := Year - 1;
    Date := LongMul(I, 365) + (Day + I div 4 - I div 100 + I div 400);
    {$ifdef win32}
    Date:= Date - DateDelta;
    {$endif}
    Result := True;
  end;
end;

function ScanDateEpoch(const S: string; var Pos: Integer;
  var Date: TDateTime; Epoch: integer): Boolean;
var
  DateOrder: TwwDateOrder;
  N1, N2, N3, Y, M, D: Word;
begin
  Result := False;
  DateOrder := wwGetDateOrder(ShortDateFormat);
  if not (ScanNumber(S, Pos, N1) and ScanChar(S, Pos, DateSeparator) and
    ScanNumber(S, Pos, N2)) then Exit;
  if ScanChar(S, Pos, DateSeparator) then
  begin
    if not ScanNumber(S, Pos, N3) then Exit;
    case DateOrder of
      doMDY: begin Y := N3; M := N1; D := N2; end;
      doDMY: begin Y := N3; M := N2; D := N1; end;
      doYMD: begin Y := N1; M := N2; D := N3; end;
      else begin Y := N1; M := N2; D := N3; end;{ Unnecessary but avoids compiler warning }
    end;

    if (Y<=99) then begin
       y:= (Epoch div 100) * 100 + y;
       if (Y < Epoch) then Inc(Y, 100);

//       if (Y <= 50) then Inc(Y, 2000)
//       else Inc(Y, 1900);
    end;

  end else
  begin
    Y := CurrentYear;
    if DateOrder = doDMY then
    begin
      D := N1; M := N2;
    end else
    begin
      M := N1; D := N2;
    end;
  end;
  ScanBlanks(S, Pos);
  Result := wwDoEncodeDate(Y, M, D, Date);
end;

function ScanDate(const S: string; var Pos: Integer;
  var Date: TDateTime): Boolean;
begin
   result:= ScanDateEpoch(S, Pos, Date, 1950);
end;


function wwScanDate(const S: string; var Date: TDateTime): Boolean;
var
  Pos: Integer;
begin
  Pos := 1;
  result:= ScanDate(S, Pos, Date);
end;

// 12/16/98 - Add epoch property for Delphi 4 support of TwwDBEdit.
//{$ifdef wwdelphi4up}
function wwScanDateEpoch(const S: string; var Date: TDateTime; Epoch: integer): Boolean;
var
  Pos: Integer;
begin
  Pos := 1;
  result:= ScanDateEpoch(S, Pos, Date, Epoch);
end;
//{$endif}

function wwDoEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDateTime): Boolean;
begin
  Result := False;
  if (Hour < 24) and (Min < 60) and (Sec < 60) and (MSec < 1000) then
  begin
    Time := (LongMul(Hour * 60 + Min, 60000) + Sec * 1000 + MSec) / MSecsPerDay;
    Result := True;
  end;
end;


function ScanTime(const S: string; var Pos: Integer;
  var Time: TDateTime): Boolean;
var
  BaseHour: Integer;
  Hour, Min, Sec: Word;
begin
  Result := False;
  if not (ScanNumber(S, Pos, Hour) and ScanChar(S, Pos, TimeSeparator) and
    ScanNumber(S, Pos, Min)) then Exit;
  Sec := 0;
  if ScanChar(S, Pos, TimeSeparator) then
    if not ScanNumber(S, Pos, Sec) then Exit;
  BaseHour := -1;
  if ScanString(S, Pos, TimeAMString) or ScanString(S, Pos, 'AM') then
    BaseHour := 0
  else
    if ScanString(S, Pos, TimePMString) or ScanString(S, Pos, 'PM') then
      BaseHour := 12;
  if BaseHour >= 0 then
  begin
    if (Hour = 0) or (Hour > 12) then Exit;
    if Hour = 12 then Hour := 0;
    Inc(Hour, BaseHour);
  end;
  ScanBlanks(S, Pos);
  Result := wwDoEncodeTime(Hour, Min, Sec, 0, Time);
end;


function wwStrToDate(const S: string): boolean;
var
  Pos: Integer;
  Date: TDateTime;
begin
  Pos := 1;
  result:= ScanDate(S, Pos, Date) and (Pos > Length(S))
end;

function wwStrToTime(const S: string): boolean;
var
  Pos: Integer;
  Time: TDateTime;
begin
  Pos := 1;
  result:=  ScanTime(S, Pos, Time) and (Pos > Length(S));
end;

function wwStrToDateTime(const S: string): boolean;
var
  Pos: Integer;
  Date, Time: TDateTime;
begin
  Pos := 1;
  Time := 0;
  result:=  ScanDate(S, Pos, Date) and
            ScanTime(S, Pos, Time) and (Pos > Length(S))
end;

function wwStrToDateTimeVal(const S: string): TDateTime;
var
  Pos: Integer;
  Date, Time: TDateTime;
begin
  Pos := 1;
  Time := 0;
  if ScanDate(S, Pos, Date) and
     ScanTime(S, Pos, Time) and (Pos > Length(S)) then
  begin
     Result := (Date + Time);
  end
  else result:= 0;
end;

function wwStrToDateVal(const S: string): TDateTime;
var
  Pos: Integer;
  Date: TDateTime;
begin
  Pos := 1;
  if ScanDate(S, Pos, Date) then
  begin
     Result := Date;
  end
  else result:= 0;
end;

function wwStrToTimeVal(const S: string): TDateTime;
var
  Pos: Integer;
  Time: TDateTime;
begin
  Pos := 1;
  if ScanTime(S, Pos, Time) and (Pos > Length(S)) then
     Result:= Time
  else Result:= 0;
end;

function wwStrToInt(const S: string): boolean;
var i: integer;
begin
   result:= True;
   for i:= 1 to length(s) do begin
      if not (s[i] in ['0'..'9']) then begin
         if (i=1) and (s[i]='-') and (length(s)>1) then continue;
         result:= False;
         exit;
      end
   end
end;

function wwStrToFloat(const S: string): boolean;
var Buffer: array[0..63] of char;
    Temp: Extended;
begin
   result:= True;
   if length(s)=0 then exit;
{$ifdef win32}
   result:= TextToFloat(StrPLCopy(Buffer, S, Sizeof(Buffer)-1), Temp, fvExtended);
{$else}
   result:= TextToFloat(StrPLCopy(Buffer, S, Sizeof(Buffer)-1), Temp);
{$endif}
end;

Function wwGetDateTimeCursorPosition(SelStart: integer; Text: string;
    TimeOnly: Boolean): TwwDateTimeSelection;
var curPos, curitem: integer;
    dateOrder: TwwDateOrder;
    Date: TDateTime;
    SecondPos: integer;
begin
   curPos:= 1;
   result:= wwdsDay; { makes compiler happy }
   if (TimeOnly or (ScanDate(Text, CurPos, Date) and
      ((CurPos <= SelStart) or  { SelStart is past date }
      ((curPos=selStart+1) and (Text[selStart]=' '))))) then
   begin
      curItem:= 0;
      SecondPos:= 100;
      repeat
          if (strGetToken(Text, TimeSeparator, curpos)='') then break;
          if (curpos=-1) or (curPos-1>selStart) then break;
          if (curItem=1) then SecondPos:= curPos-1;
          curPos:= curPos + 1;
          inc(curItem);
      until False;

      case curItem of
         0: result:= wwdsHour;
         1: result:= wwdsMinute;
         else result:= wwdsSecond;
      end;

      if (curItem=2) then
         if (selStart>SecondPos+2) then
            result:= wwdsAMPM;
      exit;
   end;

   curPos:= 1;
   curItem:= 0;
   repeat
       if (strGetToken(Text, DateSeparator, curpos)='') then break;
       if (curpos=-1) or (curPos-1>selStart) then break;
       inc(curItem);
   until False;

   DateOrder:= wwGetDateOrder(ShortDateFormat);
   case curItem of
      0: case DateOrder of
             dodmy: result:= wwdsDay;
             doymd: result:= wwdsYear;
             domdy: result:= wwdsMonth;
         end;
     1: case DateOrder of
             dodmy, doymd: result:= wwdsMonth;
             domdy: result:= wwdsDay;
        end;
     2: case DateOrder of
             dodmy, domdy: result:= wwdsYear;
             doymd: result:= wwdsDay;
        end;
   end;
end;

Function wwGetTimeCursorPosition(SelStart: integer;
    Text: string): TwwDateTimeSelection;
var curPos, curitem: integer;
    SecondPos: integer;
begin
   curPos:= 1;
   result:= wwdsHour; { makes compiler happy }
   if (CurPos <= SelStart) then
   begin
      curItem:= 0;
      SecondPos:= 100;
      repeat
          if (strGetToken(Text, TimeSeparator, curpos)='') then break;
          if (curpos=-1) or (curPos-1>selStart) then break;
          if (curItem=1) then SecondPos:= curPos-1;
          curPos:= curPos + 1;
          inc(curItem);
      until False;

      case curItem of
         0: result:= wwdsHour;
         1: result:= wwdsMinute;
         else result:= wwdsSecond;
      end;

      if (curItem=2) then
         if (selStart>SecondPos+2) then
            result:= wwdsAMPM;
      exit;
   end;
end;

Procedure wwSetDateTimeCursorSelection(
   dateCursor: TwwDateTimeSelection; edit: TCustomEdit;
     TimeOnly: Boolean);
var dateOrder: TwwDateOrder;
    i, curpos, prevpos, matchNo: integer;
    matchText: string;
    Date: TDateTime;
    spacePos: integer;
begin
   if DateCursor in [wwdsDay, wwdsYear, wwdsMonth] then
   begin
      matchNo:= 0;  {4/23/97 - Added to remove compiler warning}
      DateOrder:= wwGetDateOrder(ShortDateFormat);
      case DateCursor of
        wwdsDay:
          case DateOrder of
            dodmy: matchNo:= 0;
            doymd: matchNo:= 2;
            domdy: matchNo:= 1;
          end;
        wwdsYear:
          case DateOrder of
            dodmy: matchNo:= 2;
            doymd: matchNo:= 0;
            domdy: matchNo:= 2;
          end;
        wwdsMonth:
          case DateOrder of
            dodmy: matchNo:= 1;
            doymd: matchNo:= 1;
            domdy: matchNo:= 0;
          end;
        else matchNo:= 0;
      end;

      curPos:= 1;
      prevPos := 1;
      for i:= 0 to MatchNo do
      begin
         prevPos:= curPos;
         matchText:= strGetToken(Edit.Text, DateSeparator, curpos);

         spacePos:= pos(' ', matchText);
         if spacePos>0 then
            matchText:= copy(matchText, 1, spacePos-1);
      end;

      Edit.selStart:= prevPos-1;
      Edit.selLength:= length(MatchText);

   end
   else begin
      CurPos:= 1;
      prevpos:= 1;
      if (timeonly or ScanDate(Edit.Text, CurPos, Date)) then
      begin
         case DateCursor of
           wwdsHour: matchNo:= 0;
           wwdsMinute : matchNo:= 1;
           wwdsSecond : matchNo:= 2;
           wwdsAMPM: matchNo:= 2;
           else matchNo := 0;
         end;

         for i:= 0 to MatchNo do
         begin
            prevPos:= curPos;
            matchText:= strGetToken(Edit.Text, TimeSeparator, curpos);

            { Don't include AM/PM }
            if DateCursor=wwdsSecond then begin
               spacePos:= pos(' ', matchText);
               if spacePos>0 then
                  matchText:= copy(matchText, 1, spacePos-1);
            end
            else if DateCursor=wwdsAMPM then begin
               spacePos:= pos(' ', matchText);
               if spacePos>0 then
                  matchText:= copy(matchText, spacePos+1, 255);
               prevPos:= prevPos + spacePos;
            end

         end
      end;

      Edit.selStart:= prevPos-1;
      Edit.selLength:= length(MatchText);
   end

end;

function wwStrToFloat2(const S: string; var FloatValue: Extended; DisplayFormat: string): boolean;
//var Buffer: array[0..63] of char;
//    Temp: Extended;
var  i, startpos: integer;
    FloatString, TempText: string;
    Negative: boolean;
    ValidSet: StrCharSet;
begin
   result:= True;
   FloatString:= '';
   FloatValue:= 0; // 5/7/03 - In case of null string
   if length(s)=0 then exit;

   //StripLeading non digits
   for i:= 1 to length(s) do
      if s[i] in ['-', '0'..'9', DecimalSeparator, '('] then break;

   startpos:= i;
   Negative:= (s[i]='-');

   //StripLeading non digits again if found negative.
   if Negative then
   begin
     for i:= startpos to length(s) do
        if s[i] in ['0'..'9', DecimalSeparator, '('] then break;
      startpos:= i;
   end;

   //Remove commas and decimal point
   for i:= startpos to length(s) do begin
      if (i>startpos) then
      begin
         ValidSet:= ['0'..'9', '(', ')', DecimalSeparator, ThousandSeparator];
         if length(CurrencyString)>0 then ValidSet:= ValidSet + [CurrencyString[1]];
//         if not (s[i] in ValidSet) then break;
         if not (s[i] in ValidSet) then continue;  // 8/15/2001 - Keep scanning for other digits.
      end;

      if s[i]='(' then FloatString:= FloatString + '-';
      if (s[i] in ['0'..'9', DecimalSeparator]) then
         FloatString:= FloatString + s[i];
   end;
  if Negative then FloatString:= '-' + FloatString;
  result:= TextToFloat(pchar(FloatString), FloatValue, fvExtended);
  if result and (FloatValue>0) and (DisplayFormat<>'') then begin
     TempText:=  FormatFloat(DisplayFormat, FloatValue);
     if (TempText<>s) then
     begin
        TempText:=  FormatFloat(DisplayFormat, -FloatValue);
        if TempText=s then FloatValue:=-FloatValue;
     end
  end;

end;

end.
