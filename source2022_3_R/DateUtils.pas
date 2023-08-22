{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

{*******************************************************}
{       Date/time Utilities Unit                        }
{*******************************************************}

{ The following unit is ISO 8601 compliant.  What that means is this unit
  considers Monday the first day of the week (5.2.3).  Additionally ISO 8601
  dictates the following "the first calendar week of the year is the one
  that includes the first Thursday of that year" (3.17).  In other words the
  first week of the week is the first one that has four or more days.  For
  more information about ISO 8601 see: http://www.iso.ch/markete/8601.pdf

  The functions most impacted by ISO 8601 are marked as such in the interface
  section.

  The functions marked with "ISO 8601x" are not directly covered by ISO 8601
  but their functionality is a logical extension to the standard.

  Some of the functions, concepts or constants in this unit were provided by
  Jeroen W. Pluimers (http://www.all-im.com), Glenn Crouch, Rune Moberg and
  Ray Lischner (http://www.tempest-sw.com).

  The Julian Date and Modified Julian Date functions are based on code
  from NASA's SOHO site (http://sohowww.nascom.nasa.gov/solarsoft/gen/idl/time)
  in which they credit the underlying algorithms as by Fliegel and Van
  Flandern (1968) which was reprinted in the Explanatory Supplement to the
  Astronomical Almanac, 1992.

  Julian Date and Modified Julian Date is discussed in some detail on the
  US Naval Observatory Time Service site (http://tycho.usno.navy.mil/mjd.html).
  Additional information can be found at (http://www.treasure-troves.com/astro).
}

unit DateUtils;

interface

uses
  SysUtils, Math, Types;

{ Simple trimming functions }

function DateOf(const AValue: TDateTime): TDateTime;
function TimeOf(const AValue: TDateTime): TDateTime;

{ Misc functions }

function IsInLeapYear(const AValue: TDateTime): Boolean;
function IsPM(const AValue: TDateTime): Boolean;
function IsValidDate(const AYear, AMonth, ADay: Word): Boolean;
function IsValidTime(const AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;
function IsValidDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond,
  AMilliSecond: Word): Boolean;
function IsValidDateDay(const AYear, ADayOfYear: Word): Boolean;
function IsValidDateWeek(const AYear, AWeekOfYear,                    {ISO 8601}
  ADayOfWeek: Word): Boolean;
function IsValidDateMonthWeek(const AYear, AMonth, AWeekOfMonth,     {ISO 8601x}
  ADayOfWeek: Word): Boolean;
function WeeksInYear(const AValue: TDateTime): Word;                  {ISO 8601}
function WeeksInAYear(const AYear: Word): Word;                       {ISO 8601}
function DaysInYear(const AValue: TDateTime): Word;
function DaysInAYear(const AYear: Word): Word;
function DaysInMonth(const AValue: TDateTime): Word;
function DaysInAMonth(const AYear, AMonth: Word): Word;
function Today: TDateTime;
function Yesterday: TDateTime;
function Tomorrow: TDateTime;
function IsToday(const AValue: TDateTime): Boolean;
function IsSameDay(const AValue, ABasis: TDateTime): Boolean;

{ Pick-a-field functions }

function YearOf(const AValue: TDateTime): Word;
function MonthOf(const AValue: TDateTime): Word;
function WeekOf(const AValue: TDateTime): Word;                       {ISO 8601}
function DayOf(const AValue: TDateTime): Word;
function HourOf(const AValue: TDateTime): Word;
function MinuteOf(const AValue: TDateTime): Word;
function SecondOf(const AValue: TDateTime): Word;
function MilliSecondOf(const AValue: TDateTime): Word;

{ Start/End functions }

function StartOfTheYear(const AValue: TDateTime): TDateTime;
function EndOfTheYear(const AValue: TDateTime): TDateTime;
function StartOfAYear(const AYear: Word): TDateTime;
function EndOfAYear(const AYear: Word): TDateTime;

function StartOfTheMonth(const AValue: TDateTime): TDateTime;
function EndOfTheMonth(const AValue: TDateTime): TDateTime;
function StartOfAMonth(const AYear, AMonth: Word): TDateTime;
function EndOfAMonth(const AYear, AMonth: Word): TDateTime;

function StartOfTheWeek(const AValue: TDateTime): TDateTime;          {ISO 8601}
function EndOfTheWeek(const AValue: TDateTime): TDateTime;            {ISO 8601}
function StartOfAWeek(const AYear, AWeekOfYear: Word;                 {ISO 8601}
  const ADayOfWeek: Word = 1): TDateTime;
function EndOfAWeek(const AYear, AWeekOfYear: Word;                   {ISO 8601}
  const ADayOfWeek: Word = 7): TDateTime;

function StartOfTheDay(const AValue: TDateTime): TDateTime;
function EndOfTheDay(const AValue: TDateTime): TDateTime;
function StartOfADay(const AYear, AMonth, ADay: Word): TDateTime; overload;
function EndOfADay(const AYear, AMonth, ADay: Word): TDateTime; overload;
function StartOfADay(const AYear, ADayOfYear: Word): TDateTime; overload;
function EndOfADay(const AYear, ADayOfYear: Word): TDateTime; overload;

{ This of that functions }

function MonthOfTheYear(const AValue: TDateTime): Word;
function WeekOfTheYear(const AValue: TDateTime): Word; overload;      {ISO 8601}
function WeekOfTheYear(const AValue: TDateTime;                       {ISO 8601}
  var AYear: Word): Word; overload;
function DayOfTheYear(const AValue: TDateTime): Word;
function HourOfTheYear(const AValue: TDateTime): Word;
function MinuteOfTheYear(const AValue: TDateTime): LongWord;
function SecondOfTheYear(const AValue: TDateTime): LongWord;
function MilliSecondOfTheYear(const AValue: TDateTime): Int64;

function WeekOfTheMonth(const AValue: TDateTime): Word; overload;    {ISO 8601x}
function WeekOfTheMonth(const AValue: TDateTime; var AYear,          {ISO 8601x}
  AMonth: Word): Word; overload;
function DayOfTheMonth(const AValue: TDateTime): Word;
function HourOfTheMonth(const AValue: TDateTime): Word;
function MinuteOfTheMonth(const AValue: TDateTime): Word;
function SecondOfTheMonth(const AValue: TDateTime): LongWord;
function MilliSecondOfTheMonth(const AValue: TDateTime): LongWord;

function DayOfTheWeek(const AValue: TDateTime): Word;                 {ISO 8601}
function HourOfTheWeek(const AValue: TDateTime): Word;                {ISO 8601}
function MinuteOfTheWeek(const AValue: TDateTime): Word;              {ISO 8601}
function SecondOfTheWeek(const AValue: TDateTime): LongWord;          {ISO 8601}
function MilliSecondOfTheWeek(const AValue: TDateTime): LongWord;     {ISO 8601}

function HourOfTheDay(const AValue: TDateTime): Word;
function MinuteOfTheDay(const AValue: TDateTime): Word;
function SecondOfTheDay(const AValue: TDateTime): LongWord;
function MilliSecondOfTheDay(const AValue: TDateTime): LongWord;

function MinuteOfTheHour(const AValue: TDateTime): Word;
function SecondOfTheHour(const AValue: TDateTime): Word;
function MilliSecondOfTheHour(const AValue: TDateTime): LongWord;

function SecondOfTheMinute(const AValue: TDateTime): Word;
function MilliSecondOfTheMinute(const AValue: TDateTime): LongWord;

function MilliSecondOfTheSecond(const AValue: TDateTime): Word;

{ Range checking functions }

function WithinPastYears(const ANow, AThen: TDateTime;
  const AYears: Integer): Boolean;
function WithinPastMonths(const ANow, AThen: TDateTime;
  const AMonths: Integer): Boolean;
function WithinPastWeeks(const ANow, AThen: TDateTime;
  const AWeeks: Integer): Boolean;
function WithinPastDays(const ANow, AThen: TDateTime;
  const ADays: Integer): Boolean;
function WithinPastHours(const ANow, AThen: TDateTime;
  const AHours: Int64): Boolean;
function WithinPastMinutes(const ANow, AThen: TDateTime;
  const AMinutes: Int64): Boolean;
function WithinPastSeconds(const ANow, AThen: TDateTime;
  const ASeconds: Int64): Boolean;
function WithinPastMilliSeconds(const ANow, AThen: TDateTime;
  const AMilliSeconds: Int64): Boolean;

{ Range query functions }

function YearsBetween(const ANow, AThen: TDateTime): Integer;
function MonthsBetween(const ANow, AThen: TDateTime): Integer;
function WeeksBetween(const ANow, AThen: TDateTime): Integer;
function DaysBetween(const ANow, AThen: TDateTime): Integer;
function HoursBetween(const ANow, AThen: TDateTime): Int64;
function MinutesBetween(const ANow, AThen: TDateTime): Int64;
function SecondsBetween(const ANow, AThen: TDateTime): Int64;
function MilliSecondsBetween(const ANow, AThen: TDateTime): Int64;

{ Range spanning functions }
{ YearSpan and MonthSpan are approximates, not exact but pretty darn close }
function YearSpan(const ANow, AThen: TDateTime): Double;
function MonthSpan(const ANow, AThen: TDateTime): Double;
function WeekSpan(const ANow, AThen: TDateTime): Double;
function DaySpan(const ANow, AThen: TDateTime): Double;
function HourSpan(const ANow, AThen: TDateTime): Double;
function MinuteSpan(const ANow, AThen: TDateTime): Double;
function SecondSpan(const ANow, AThen: TDateTime): Double;
function MilliSecondSpan(const ANow, AThen: TDateTime): Double;

{ Increment/decrement datetime fields }

function IncYear(const AValue: TDateTime;
  const ANumberOfYears: Integer = 1): TDateTime;
// function IncMonth is in SysUtils
function IncWeek(const AValue: TDateTime;
  const ANumberOfWeeks: Integer = 1): TDateTime;
function IncDay(const AValue: TDateTime;
  const ANumberOfDays: Integer = 1): TDateTime;
function IncHour(const AValue: TDateTime;
  const ANumberOfHours: Int64 = 1): TDateTime;
function IncMinute(const AValue: TDateTime;
  const ANumberOfMinutes: Int64 = 1): TDateTime;
function IncSecond(const AValue: TDateTime;
  const ANumberOfSeconds: Int64 = 1): TDateTime;
function IncMilliSecond(const AValue: TDateTime;
  const ANumberOfMilliSeconds: Int64 = 1): TDateTime;

{ Unified encode/decode functions that deal with all datetime fields at once }

function EncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond,
  AMilliSecond: Word): TDateTime;
procedure DecodeDateTime(const AValue: TDateTime; out AYear, AMonth, ADay,
  AHour, AMinute, ASecond, AMilliSecond: Word);

{ Encode/decode functions that work with week of year and day of week }

function EncodeDateWeek(const AYear, AWeekOfYear: Word;               {ISO 8601}
  const ADayOfWeek: Word = 1): TDateTime;
procedure DecodeDateWeek(const AValue: TDateTime; out AYear,          {ISO 8601}
  AWeekOfYear, ADayOfWeek: Word);

{ Encode/decode functions that work with day of year }

function EncodeDateDay(const AYear, ADayOfYear: Word): TDateTime;
procedure DecodeDateDay(const AValue: TDateTime; out AYear, ADayOfYear: Word);

{ Encode/decode functions that work with week of month }

function EncodeDateMonthWeek(const AYear, AMonth, AWeekOfMonth,      {ISO 8601x}
  ADayOfWeek: Word): TDateTime;
procedure DecodeDateMonthWeek(const AValue: TDateTime;               {ISO 8601x}
  out AYear, AMonth, AWeekOfMonth, ADayOfWeek: Word);

{ The following functions are similar to the above ones except these don't
  generated exceptions on failure, they return false instead }

function TryEncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond,
  AMilliSecond: Word; out AValue: TDateTime): Boolean;
function TryEncodeDateWeek(const AYear, AWeekOfYear: Word;            {ISO 8601}
  out AValue: TDateTime; const ADayOfWeek: Word = 1): Boolean;
function TryEncodeDateDay(const AYear, ADayOfYear: Word;
  out AValue: TDateTime): Boolean;
function TryEncodeDateMonthWeek(const AYear, AMonth, AWeekOfMonth,   {ISO 8601x}
  ADayOfWeek: Word; var AValue: TDateTime): Boolean;

{ Recode functions for datetime fields }

function RecodeYear(const AValue: TDateTime; const AYear: Word): TDateTime;
function RecodeMonth(const AValue: TDateTime; const AMonth: Word): TDateTime;
function RecodeDay(const AValue: TDateTime; const ADay: Word): TDateTime;
function RecodeHour(const AValue: TDateTime; const AHour: Word): TDateTime;
function RecodeMinute(const AValue: TDateTime; const AMinute: Word): TDateTime;
function RecodeSecond(const AValue: TDateTime; const ASecond: Word): TDateTime;
function RecodeMilliSecond(const AValue: TDateTime;
  const AMilliSecond: Word): TDateTime;

function RecodeDate(const AValue: TDateTime; const AYear, AMonth,
  ADay: Word): TDateTime;
function RecodeTime(const AValue: TDateTime; const AHour, AMinute, ASecond,
  AMilliSecond: Word): TDateTime;
function RecodeDateTime(const AValue: TDateTime; const AYear, AMonth, ADay,
  AHour, AMinute, ASecond, AMilliSecond: Word): TDateTime;

{ The following function is similar to the above one except it doesn't
  generated an exception on failure, it return false instead }

function TryRecodeDateTime(const AValue: TDateTime; const AYear, AMonth, ADay,
  AHour, AMinute, ASecond, AMilliSecond: Word; out AResult: TDateTime): Boolean;

{ Fuzzy comparison }

function CompareDateTime(const A, B: TDateTime): TValueRelationship;
function SameDateTime(const A, B: TDateTime): Boolean;
function CompareDate(const A, B: TDateTime): TValueRelationship;
function SameDate(const A, B: TDateTime): Boolean;
function CompareTime(const A, B: TDateTime): TValueRelationship;
function SameTime(const A, B: TDateTime): Boolean;

{ For a given date these functions tell you the which day of the week of the
  month (or year).  If its a Thursday, they will tell you if its the first,
  second, etc Thursday of the month (or year).  Remember, even though its
  the first Thursday of the year it doesn't mean its the first week of the
  year.  See ISO 8601 above for more information. }

function NthDayOfWeek(const AValue: TDateTime): Word;

procedure DecodeDayOfWeekInMonth(const AValue: TDateTime; out AYear, AMonth,
  ANthDayOfWeek, ADayOfWeek: Word);

function EncodeDayOfWeekInMonth(const AYear, AMonth, ANthDayOfWeek,
  ADayOfWeek: Word): TDateTime;
function TryEncodeDayOfWeekInMonth(const AYear, AMonth, ANthDayOfWeek,
  ADayOfWeek: Word; out AValue: TDateTime): Boolean;

{ Error reporting }

procedure InvalidDateTimeError(const AYear, AMonth, ADay, AHour, AMinute,
  ASecond, AMilliSecond: Word; const ABaseDate: TDateTime = 0);
procedure InvalidDateWeekError(const AYear, AWeekOfYear, ADayOfWeek: Word);
procedure InvalidDateDayError(const AYear, ADayOfYear: Word);
procedure InvalidDateMonthWeekError(const AYear, AMonth, AWeekOfMonth,
  ADayOfWeek: Word);
procedure InvalidDayOfWeekInMonthError(const AYear, AMonth, ANthDayOfWeek,
  ADayOfWeek: Word);

{ Julian and Modified Julian Date conversion support }
{ Be aware that not all Julian Dates (or MJD) are encodable as a TDateTime }

function DateTimeToJulianDate(const AValue: TDateTime): Double;
function JulianDateToDateTime(const AValue: Double): TDateTime;
function TryJulianDateToDateTime(const AValue: Double;
  out ADateTime: TDateTime): Boolean;

function DateTimeToModifiedJulianDate(const AValue: TDateTime): Double;
function ModifiedJulianDateToDateTime(const AValue: Double): TDateTime;
function TryModifiedJulianDateToDateTime(const AValue: Double;
  out ADateTime: TDateTime): Boolean;

{ Unix date conversion support }

function DateTimeToUnix(const AValue: TDateTime): Int64;
function UnixToDateTime(const AValue: Int64): TDateTime;

{ Constants used in this unit }

const
  DaysPerWeek = 7;
  WeeksPerFortnight = 2;
  MonthsPerYear = 12;
  YearsPerDecade = 10;
  YearsPerCentury = 100;
  YearsPerMillennium = 1000;

  DayMonday = 1;
  DayTuesday = 2;
  DayWednesday = 3;
  DayThursday = 4;
  DayFriday = 5;
  DaySaturday = 6;
  DaySunday = 7;

  OneHour = 1 / HoursPerDay;
  OneMinute = 1 / MinsPerDay;
  OneSecond = 1 / SecsPerDay;
  OneMillisecond = 1 / MSecsPerDay;

  { This is actual days per year but you need to know if it's a leap year}
  DaysPerYear: array [Boolean] of Word = (365, 366);

  { Used in RecodeDate, RecodeTime and RecodeDateTime for those datetime }
  {  fields you want to leave alone }
  RecodeLeaveFieldAsIs = High(Word);

{ Global variable used in this unit }

var

  { average over a 4 year span }
  ApproxDaysPerMonth: Double = 30.4375;
  ApproxDaysPerYear: Double  = 365.25;

  { The above are the average days per month/year over a normal 4 year period. }
  { We use these approximations because they are more accurate for the next }
  {  century or so.  After that you may want to switch over to these 400 year }
  {  approximations... }
  {    ApproxDaysPerMonth = 30.436875 }
  {    ApproxDaysPerYear  = 365.2425 }

implementation

uses
  RTLConsts;

function DateOf(const AValue: TDateTime): TDateTime;
begin
  Result := Trunc(AValue);
end;

function TimeOf(const AValue: TDateTime): TDateTime;
begin
  Result := Frac(AValue);
end;


function IsInLeapYear(const AValue: TDateTime): Boolean;
begin
  Result := IsLeapYear(YearOf(AValue));
end;

function IsPM(const AValue: TDateTime): Boolean;
begin
  Result := HourOf(AValue) >= 12;
end;

function IsValidDate(const AYear, AMonth, ADay: Word): Boolean;
begin
  Result := (AYear >= 1) and (AYear <= 9999) and
            (AMonth >= 1) and (AMonth <= 12) and
            (ADay >= 1) and (ADay <= DaysInAMonth(AYear, AMonth));
end;

function IsValidTime(const AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;
begin
  Result := ((AHour < HoursPerDay) and (AMinute < MinsPerHour) and
             (ASecond < SecsPerMin) and (AMilliSecond < MSecsPerSec)) or
            ((AHour = 24) and (AMinute = 0) and // midnight early next day
             (ASecond = 0) and (AMilliSecond = 0));
end;

function IsValidDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond,
  AMilliSecond: Word): Boolean;
begin
  Result := IsValidDate(AYear, AMonth, ADay) and
            IsValidTime(AHour, AMinute, ASecond, AMilliSecond);
end;

function IsValidDateMonthWeek(const AYear, AMonth, AWeekOfMonth,
  ADayOfWeek: Word): Boolean;
begin
  Result := (AYear >= 1) and (AYear <= 9999) and
            (AMonth >= 1) and (AMonth <= 12) and
            (AWeekOfMonth >= 1) and (AWeekOfMonth <= 5) and
            (ADayOfWeek >= DayMonday) and (ADayOfWeek <= DaySunday);
end;

function IsValidDateDay(const AYear, ADayOfYear: Word): Boolean;
begin
  Result := (AYear >= 1) and (AYear <= 9999) and
            (ADayOfYear >= 1) and (ADayOfYear <= DaysInAYear(AYear));
end;

function IsValidDateWeek(const AYear, AWeekOfYear, ADayOfWeek: Word): Boolean;
begin
  Result := (AYear >= 1) and (AYear <= 9999) and
            (AWeekOfYear >= 1) and (AWeekOfYear <= WeeksInAYear(AYear)) and
            (ADayOfWeek >= DayMonday) and (ADayOfWeek <= DaySunday);
end;

function DaysInYear(const AValue: TDateTime): Word;
begin
  Result := DaysInAYear(YearOf(AValue));
end;

function DaysInAYear(const AYear: Word): Word;
begin
  Result := DaysPerYear[IsLeapYear(AYear)];
end;

function DaysInMonth(const AValue: TDateTime): Word;
var
  LYear, LMonth, LDay: Word;
begin
  DecodeDate(AValue, LYear, LMonth, LDay);
  Result := DaysInAMonth(LYear, LMonth);
end;

function DaysInAMonth(const AYear, AMonth: Word): Word;
begin
  Result := MonthDays[(AMonth = 2) and IsLeapYear(AYear), AMonth];
end;

function WeeksInYear(const AValue: TDateTime): Word;
begin
  Result := WeeksInAYear(YearOf(AValue));
end;

function WeeksInAYear(const AYear: Word): Word;
var
  LDayOfWeek: Word;
begin
  Result := 52;
  LDayOfWeek := DayOfTheWeek(EncodeDate(AYear, 1, 1));
  if (LDayOfWeek = DayThursday) or
     ((LDayOfWeek = DayWednesday) and IsLeapYear(AYear)) then
    Inc(Result);
end;

function Today: TDateTime;
begin
  Result := Date;
end;

function Yesterday: TDateTime;
begin
  Result := Date - 1;
end;

function Tomorrow: TDateTime;
begin
  Result := Date + 1;
end;

function IsToday(const AValue: TDateTime): Boolean;
begin
  Result := IsSameDay(AValue, Date);
end;

function IsSameDay(const AValue, ABasis: TDateTime): Boolean;
begin
  Result := (AValue >= Trunc(ABasis)) and
            (AValue < Trunc(ABasis) + 1);
end;

function YearOf(const AValue: TDateTime): Word;
var
  LMonth, LDay: Word;
begin
  DecodeDate(AValue, Result, LMonth, LDay);
end;

function MonthOf(const AValue: TDateTime): Word;
var
  LYear, LDay: Word;
begin
  DecodeDate(AValue, LYear, Result, LDay);
end;

function WeekOf(const AValue: TDateTime): Word;
begin
  Result := WeekOfTheYear(AValue);
end;

function DayOf(const AValue: TDateTime): Word;
var
  LYear, LMonth: Word;
begin
  DecodeDate(AValue, LYear, LMonth, Result);
end;

function HourOf(const AValue: TDateTime): Word;
var
  LMinute, LSecond, LMilliSecond: Word;
begin
  DecodeTime(AValue, Result, LMinute, LSecond, LMilliSecond);
end;

function MinuteOf(const AValue: TDateTime): Word;
var
  LHour, LSecond, LMilliSecond: Word;
begin
  DecodeTime(AValue, LHour, Result, LSecond, LMilliSecond);
end;

function SecondOf(const AValue: TDateTime): Word;
var
  LHour, LMinute, LMilliSecond: Word;
begin
  DecodeTime(AValue, LHour, LMinute, Result, LMilliSecond);
end;

function MilliSecondOf(const AValue: TDateTime): Word;
var
  LHour, LMinute, LSecond: Word;
begin
  DecodeTime(AValue, LHour, LMinute, LSecond, Result);
end;

function StartOfTheYear(const AValue: TDateTime): TDateTime;
begin
  Result := EncodeDate(YearOf(AValue), 1, 1);
end;

function EndOfTheYear(const AValue: TDateTime): TDateTime;
begin
  Result := EndOfTheDay(EncodeDate(YearOf(AValue), 12, 31));
end;

function StartOfTheMonth(const AValue: TDateTime): TDateTime;
var
  LYear, LMonth, LDay: Word;
begin
  DecodeDate(AValue, LYear, LMonth, LDay);
  Result := EncodeDate(LYear, LMonth, 1);
end;

function EndOfTheMonth(const AValue: TDateTime): TDateTime;
var
  LYear, LMonth, LDay: Word;
begin
  DecodeDate(AValue, LYear, LMonth, LDay);
  Result := EndOfTheDay(EncodeDate(LYear, LMonth, DaysInAMonth(LYear, LMonth)));
end;

function StartOfTheWeek(const AValue: TDateTime): TDateTime;
begin
  Result := Trunc(AValue) - (DayOfTheWeek(AValue) - 1);
end;

function EndOfTheWeek(const AValue: TDateTime): TDateTime;
begin
  Result := EndOfTheDay(StartOfTheWeek(AValue) + 6);
end;

function StartOfTheDay(const AValue: TDateTime): TDateTime;
begin
  Result := Trunc(AValue);
end;

function EndOfTheDay(const AValue: TDateTime): TDateTime;
begin
  Result := RecodeTime(AValue, 23, 59, 59, 999);
end;

function StartOfAYear(const AYear: Word): TDateTime;
begin
  Result := EncodeDate(AYear, 1, 1);
end;

function EndOfAYear(const AYear: Word): TDateTime;
begin
  Result := EndOfTheDay(EncodeDate(AYear, 12, 31));
end;

function StartOfAMonth(const AYear, AMonth: Word): TDateTime;
begin
  Result := EncodeDate(AYear, AMonth, 1);
end;

function EndOfAMonth(const AYear, AMonth: Word): TDateTime;
begin
  Result := EndOfTheDay(EncodeDate(AYear, AMonth, DaysInAMonth(AYear, AMonth)));
end;

function StartOfAWeek(const AYear, AWeekOfYear, ADayOfWeek: Word): TDateTime;
begin
  Result := EncodeDateWeek(AYear, AWeekOfYear, ADayOfWeek);
end;

function EndOfAWeek(const AYear, AWeekOfYear, ADayOfWeek: Word): TDateTime;
begin
  Result := EndOfTheDay(EncodeDateWeek(AYear, AWeekOfYear, ADayOfWeek));
end;

function StartOfADay(const AYear, ADayOfYear: Word): TDateTime;
begin
  Result := EncodeDateDay(AYear, ADayOfYear);
end;

function EndOfADay(const AYear, ADayOfYear: Word): TDateTime;
begin
  Result := EndOfTheDay(EncodeDateDay(AYear, ADayOfYear));
end;

function StartOfADay(const AYear, AMonth, ADay: Word): TDateTime;
begin
  Result := StartOfAMonth(AYear, AMonth) + ADay - 1;
end;

function EndOfADay(const AYear, AMonth, ADay: Word): TDateTime;
begin
  Result := EndOfTheDay(EncodeDate(AYear, AMonth, ADay));
end;


function MonthOfTheYear(const AValue: TDateTime): Word;
begin
  Result := MonthOf(AValue);
end;

function WeekOfTheYear(const AValue: TDateTime): Word;
var
  LYear, LDOW: Word;
begin
  DecodeDateWeek(AValue, LYear, Result, LDOW);
end;

function WeekOfTheYear(const AValue: TDateTime; var AYear: Word): Word;
var
  LDOW: Word;
begin
  DecodeDateWeek(AValue, AYear, Result, LDOW);
end;

function DayOfTheYear(const AValue: TDateTime): Word;
begin
  Result := Trunc(AValue - StartOfTheYear(AValue)) + 1;
end;

function HourOfTheYear(const AValue: TDateTime): Word;
begin
  Result := HourOf(AValue) + (DayOfTheYear(AValue) - 1) * HoursPerDay;
end;

function MinuteOfTheYear(const AValue: TDateTime): LongWord;
begin
  Result := MinuteOf(AValue) + HourOfTheYear(AValue) * MinsPerHour;
end;

function SecondOfTheYear(const AValue: TDateTime): LongWord;
begin
  Result := SecondOf(AValue) + MinuteOfTheYear(AValue) * SecsPerMin;
end;

function MilliSecondOfTheYear(const AValue: TDateTime): Int64;
begin
  Result := MilliSecondOf(AValue) + Int64(SecondOfTheYear(AValue)) * MSecsPerSec;
end;


function WeekOfTheMonth(const AValue: TDateTime): Word;
var
  LYear, LMonth, LDayOfWeek: Word;
begin
  DecodeDateMonthWeek(AValue, LYear, LMonth, Result, LDayOfWeek);
end;

function WeekOfTheMonth(const AValue: TDateTime; var AYear, AMonth: Word): Word;
var
  LDayOfWeek: Word;
begin
  DecodeDateMonthWeek(AValue, AYear, AMonth, Result, LDayOfWeek);
end;

function DayOfTheMonth(const AValue: TDateTime): Word;
begin
  Result := DayOf(AValue);
end;

function HourOfTheMonth(const AValue: TDateTime): Word;
begin
  Result := HourOf(AValue) + (DayOfTheMonth(AValue) - 1) * HoursPerDay;
end;

function MinuteOfTheMonth(const AValue: TDateTime): Word;
begin
  Result := MinuteOf(AValue) + HourOfTheMonth(AValue) * MinsPerHour;
end;

function SecondOfTheMonth(const AValue: TDateTime): LongWord;
begin
  Result := SecondOf(AValue) + MinuteOfTheMonth(AValue) * SecsPerMin;
end;

function MilliSecondOfTheMonth(const AValue: TDateTime): LongWord;
begin
  Result := MilliSecondOf(AValue) + SecondOfTheMonth(AValue) * MSecsPerSec;
end;


function DayOfTheWeek(const AValue: TDateTime): Word;
begin
  Result := (DateTimeToTimeStamp(AValue).Date - 1) mod 7 + 1;
end;

function HourOfTheWeek(const AValue: TDateTime): Word;
begin
  Result := HourOf(AValue) + (DayOfTheWeek(AValue) - 1) * HoursPerDay;
end;

function MinuteOfTheWeek(const AValue: TDateTime): Word;
begin
  Result := MinuteOf(AValue) + HourOfTheWeek(AValue) * MinsPerHour;
end;

function SecondOfTheWeek(const AValue: TDateTime): LongWord;
begin
  Result := SecondOf(AValue) + MinuteOfTheWeek(AValue) * SecsPerMin;
end;

function MilliSecondOfTheWeek(const AValue: TDateTime): LongWord;
begin
  Result := MilliSecondOf(AValue) + SecondOfTheWeek(AValue) * MSecsPerSec;
end;


function HourOfTheDay(const AValue: TDateTime): Word;
begin
  Result := HourOf(AValue);
end;

function MinuteOfTheDay(const AValue: TDateTime): Word;
var
  LHours, LMinutes, LSeconds, LMilliSeconds: Word;
begin
  DecodeTime(AValue, LHours, LMinutes, LSeconds, LMilliSeconds);
  Result := LMinutes + LHours * MinsPerHour;
end;

function SecondOfTheDay(const AValue: TDateTime): LongWord;
var
  LHours, LMinutes, LSeconds, LMilliSeconds: Word;
begin
  DecodeTime(AValue, LHours, LMinutes, LSeconds, LMilliSeconds);
  Result := LSeconds + (LMinutes + LHours * MinsPerHour) * SecsPerMin;
end;

function MilliSecondOfTheDay(const AValue: TDateTime): LongWord;
var
  LHours, LMinutes, LSeconds, LMilliSeconds: Word;
begin
  DecodeTime(AValue, LHours, LMinutes, LSeconds, LMilliSeconds);
  Result := LMilliSeconds + (LSeconds + (LMinutes + LHours * MinsPerHour) * SecsPerMin) * MSecsPerSec;
end;


function MinuteOfTheHour(const AValue: TDateTime): Word;
begin
  Result := MinuteOf(AValue);
end;

function SecondOfTheHour(const AValue: TDateTime): Word;
var
  LHours, LMinutes, LSeconds, LMilliSeconds: Word;
begin
  DecodeTime(AValue, LHours, LMinutes, LSeconds, LMilliSeconds);
  Result := LSeconds + (LMinutes * SecsPerMin);
end;

function MilliSecondOfTheHour(const AValue: TDateTime): LongWord;
var
  LHours, LMinutes, LSeconds, LMilliSeconds: Word;
begin
  DecodeTime(AValue, LHours, LMinutes, LSeconds, LMilliSeconds);
  Result := LMilliSeconds + (LSeconds + LMinutes * SecsPerMin) * MSecsPerSec;
end;


function SecondOfTheMinute(const AValue: TDateTime): Word;
begin
  Result := SecondOf(AValue);
end;

function MilliSecondOfTheMinute(const AValue: TDateTime): LongWord;
var
  LHours, LMinutes, LSeconds, LMilliSeconds: Word;
begin
  DecodeTime(AValue, LHours, LMinutes, LSeconds, LMilliSeconds);
  Result := LMilliSeconds + LSeconds * MSecsPerSec;
end;


function MilliSecondOfTheSecond(const AValue: TDateTime): Word;
begin
  Result := MilliSecondOf(AValue);
end;


function WithinPastYears(const ANow, AThen: TDateTime;
  const AYears: Integer): Boolean;
begin
  Result := YearsBetween(ANow, AThen) <= AYears;
end;

function WithinPastMonths(const ANow, AThen: TDateTime;
  const AMonths: Integer): Boolean;
begin
  Result := MonthsBetween(ANow, AThen) <= AMonths;
end;

function WithinPastWeeks(const ANow, AThen: TDateTime;
  const AWeeks: Integer): Boolean;
begin
  Result := WeeksBetween(ANow, AThen) <= AWeeks;
end;

function WithinPastDays(const ANow, AThen: TDateTime;
  const ADays: Integer): Boolean;
begin
  Result := DaysBetween(ANow, AThen) <= ADays;
end;

function WithinPastHours(const ANow, AThen: TDateTime;
  const AHours: Int64): Boolean;
begin
  Result := HoursBetween(ANow, AThen) <= AHours;
end;

function WithinPastMinutes(const ANow, AThen: TDateTime;
  const AMinutes: Int64): Boolean;
begin
  Result := MinutesBetween(ANow, AThen) <= AMinutes;
end;

function WithinPastSeconds(const ANow, AThen: TDateTime;
  const ASeconds: Int64): Boolean;
begin
  Result := SecondsBetween(ANow, AThen) <= ASeconds;
end;

function WithinPastMilliSeconds(const ANow, AThen: TDateTime;
  const AMilliSeconds: Int64): Boolean;
begin
  Result := MilliSecondsBetween(ANow, AThen) <= AMilliSeconds;
end;


function YearsBetween(const ANow, AThen: TDateTime): Integer;
begin
  Result := Trunc(YearSpan(ANow, AThen));
end;

function MonthsBetween(const ANow, AThen: TDateTime): Integer;
begin
  Result := Trunc(MonthSpan(ANow, AThen));
end;

function WeeksBetween(const ANow, AThen: TDateTime): Integer;
begin
  Result := Trunc(WeekSpan(ANow, AThen));
end;

function DaysBetween(const ANow, AThen: TDateTime): Integer;
begin
  Result := Trunc(DaySpan(ANow, AThen));
end;

function HoursBetween(const ANow, AThen: TDateTime): Int64;
begin
  Result := Trunc(HourSpan(ANow, AThen));
end;

function MinutesBetween(const ANow, AThen: TDateTime): Int64;
begin
  Result := Trunc(MinuteSpan(ANow, AThen));
end;

function SecondsBetween(const ANow, AThen: TDateTime): Int64;
begin
  Result := Trunc(SecondSpan(ANow, AThen));
end;

function MilliSecondsBetween(const ANow, AThen: TDateTime): Int64;
begin
  Result := Trunc(MilliSecondSpan(ANow, AThen));
end;


function SpanOfNowAndThen(const ANow, AThen: TDateTime): TDateTime;
begin
  if ANow < AThen then
    Result := AThen - ANow
  else
    Result := ANow - AThen;
end;

function YearSpan(const ANow, AThen: TDateTime): Double;
begin
  Result := DaySpan(ANow, AThen) / ApproxDaysPerYear;
end;

function MonthSpan(const ANow, AThen: TDateTime): Double;
begin
  Result := DaySpan(ANow, AThen) / ApproxDaysPerMonth;
end;

function WeekSpan(const ANow, AThen: TDateTime): Double;
begin
  Result := DaySpan(ANow, AThen) / DaysPerWeek;
end;

function DaySpan(const ANow, AThen: TDateTime): Double;
begin
  Result := SpanOfNowAndThen(ANow, AThen);
end;

function HourSpan(const ANow, AThen: TDateTime): Double;
begin
  Result := HoursPerDay * SpanOfNowAndThen(ANow, AThen);
end;

function MinuteSpan(const ANow, AThen: TDateTime): Double;
begin
  Result := MinsPerDay * SpanOfNowAndThen(ANow, AThen);
end;

function SecondSpan(const ANow, AThen: TDateTime): Double;
begin
  Result := SecsPerDay * SpanOfNowAndThen(ANow, AThen);
end;

function MilliSecondSpan(const ANow, AThen: TDateTime): Double;
begin
  Result := MSecsPerDay * SpanOfNowAndThen(ANow, AThen);
end;


function IncYear(const AValue: TDateTime;
  const ANumberOfYears: Integer): TDateTime;
begin
  Result := IncMonth(AValue, ANumberOfYears * MonthsPerYear);
end;

function IncWeek(const AValue: TDateTime;
  const ANumberOfWeeks: Integer): TDateTime;
begin
  Result := AValue + ANumberOfWeeks * DaysPerWeek;
end;

function IncDay(const AValue: TDateTime;
  const ANumberOfDays: Integer): TDateTime;
begin
  Result := AValue + ANumberOfDays;
end;

function IncHour(const AValue: TDateTime;
  const ANumberOfHours: Int64): TDateTime;
begin
  if AValue > 0 then
    Result := ((AValue * HoursPerDay) + ANumberOfHours) / HoursPerDay
  else
    Result := ((AValue * HoursPerDay) - ANumberOfHours) / HoursPerDay;
end;

function IncMinute(const AValue: TDateTime;
  const ANumberOfMinutes: Int64): TDateTime;
begin
  if AValue > 0 then
    Result := ((AValue * MinsPerDay) + ANumberOfMinutes) / MinsPerDay
  else
    Result := ((AValue * MinsPerDay) - ANumberOfMinutes) / MinsPerDay;
end;

function IncSecond(const AValue: TDateTime;
  const ANumberOfSeconds: Int64): TDateTime;
begin
  if AValue > 0 then
    Result := ((AValue * SecsPerDay) + ANumberOfSeconds) / SecsPerDay
  else
    Result := ((AValue * SecsPerDay) - ANumberOfSeconds) / SecsPerDay;
end;

function IncMilliSecond(const AValue: TDateTime;
  const ANumberOfMilliSeconds: Int64): TDateTime;
begin
  if AValue > 0 then
    Result := ((AValue * MSecsPerDay) + ANumberOfMilliSeconds) / MSecsPerDay
  else
    Result := ((AValue * MSecsPerDay) - ANumberOfMilliSeconds) / MSecsPerDay;
end;


function EncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond,
  AMilliSecond: Word): TDateTime;
begin
  if not TryEncodeDateTime(AYear, AMonth, ADay,
                           AHour, AMinute, ASecond, AMilliSecond, Result) then
    InvalidDateTimeError(AYear, AMonth, ADay,
                         AHour, AMinute, ASecond, AMilliSecond);
end;

procedure DecodeDateTime(const AValue: TDateTime; out AYear, AMonth, ADay,
  AHour, AMinute, ASecond, AMilliSecond: Word);
begin
  DecodeDate(AValue, AYear, AMonth, ADay);
  DecodeTime(AValue, AHour, AMinute, ASecond, AMilliSecond);
end;

function EncodeDateWeek(const AYear, AWeekOfYear, ADayOfWeek: Word): TDateTime;
begin
  if not TryEncodeDateWeek(AYear, AWeekOfYear, Result, ADayOfWeek) then
    InvalidDateWeekError(AYear, AWeekOfYear, ADayOfWeek);
end;

const
  CDayMap: array [1..7] of Word = (7, 1, 2, 3, 4, 5, 6);

procedure DecodeDateWeek(const AValue: TDateTime; out AYear, AWeekOfYear,
  ADayOfWeek: Word);
var
  LDayOfYear: Integer;
  LMonth, LDay: Word;
  LStart: TDateTime;
  LStartDayOfWeek, LEndDayOfWeek: Word;
  LLeap: Boolean;
begin
  LLeap := DecodeDateFully(AValue, AYear, LMonth, LDay, ADayOfWeek);
  ADayOfWeek := CDayMap[ADayOfWeek];
  LStart := EncodeDate(AYear, 1, 1);
  LDayOfYear := Trunc(AValue - LStart + 1);
  LStartDayOfWeek := DayOfTheWeek(LStart);
  if LStartDayOfWeek in [DayFriday, DaySaturday, DaySunday] then
    Dec(LDayOfYear, 8 - LStartDayOfWeek)
  else
    Inc(LDayOfYear, LStartDayOfWeek - 1);
  if LDayOfYear <= 0 then
    DecodeDateWeek(LStart - 1, AYear, AWeekOfYear, LDay)
  else
  begin
    AWeekOfYear := LDayOfYear div 7;
    if LDayOfYear mod 7 <> 0 then
      Inc(AWeekOfYear);
    if AWeekOfYear > 52 then
    begin
      LEndDayOfWeek := LStartDayOfWeek;
      if LLeap then
      begin
        if LEndDayOfWeek = DaySunday then
          LEndDayOfWeek := DayMonday
        else
          Inc(LEndDayOfWeek);
      end;
      if LEndDayOfWeek in [DayMonday, DayTuesday, DayWednesday] then
      begin
        Inc(AYear);
        AWeekOfYear := 1;
      end;
    end;
  end;
end;

function EncodeDateDay(const AYear, ADayOfYear: Word): TDateTime;
begin
  if not TryEncodeDateDay(AYear, ADayOfYear, Result) then
    InvalidDateDayError(AYear, ADayOfYear);
end;

procedure DecodeDateDay(const AValue: TDateTime; out AYear, ADayOfYear: Word);
begin
  AYear := YearOf(AValue);
  ADayOfYear := DayOfTheYear(AValue);
end;

function EncodeDateMonthWeek(const AYear, AMonth, AWeekOfMonth,
  ADayOfWeek: Word): TDateTime;
begin
  if not TryEncodeDateMonthWeek(AYear, AMonth, AWeekOfMonth, ADayOfWeek,
                                Result) then
    InvalidDateMonthWeekError(AYear, AMonth, AWeekOfMonth, ADayOfWeek);
end;

procedure DecodeDateMonthWeek(const AValue: TDateTime;
  out AYear, AMonth, AWeekOfMonth, ADayOfWeek: Word);
var
  LDay, LDaysInMonth: Word;
  LDayOfMonth: Integer;
  LStart: TDateTime;
  LStartDayOfWeek, LEndOfMonthDayOfWeek: Word;
begin
  DecodeDateFully(AValue, AYear, AMonth, LDay, ADayOfWeek);
  ADayOfWeek := CDayMap[ADayOfWeek];
  LStart := EncodeDate(AYear, AMonth, 1);
  LStartDayOfWeek := DayOfTheWeek(LStart);
  LDayOfMonth := LDay;
  if LStartDayOfWeek in [DayFriday, DaySaturday, DaySunday] then
    Dec(LDayOfMonth, 8 - LStartDayOfWeek)
  else
    Inc(LDayOfMonth, LStartDayOfWeek - 1);
  if LDayOfMonth <= 0 then
    DecodeDateMonthWeek(LStart - 1, AYear, AMonth, AWeekOfMonth, LDay)
  else
  begin
    AWeekOfMonth := LDayOfMonth div 7;
    if LDayOfMonth mod 7 <> 0 then
      Inc(AWeekOfMonth);
    LDaysInMonth := DaysInAMonth(AYear, AMonth);
    LEndOfMonthDayOfWeek := DayOfTheWeek(EncodeDate(AYear, AMonth, LDaysInMonth));
    if (LEndOfMonthDayOfWeek in [DayMonday, DayTuesday, DayWednesday]) and
       (LDaysInMonth - LDay < LEndOfMonthDayOfWeek) then
    begin
      Inc(AMonth);
      if AMonth = 13 then
      begin
        AMonth := 1;
        Inc(AYear);
      end;
      AWeekOfMonth := 1;
    end;
  end;
end;


function TryEncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond,
  AMilliSecond: Word; out AValue: TDateTime): Boolean;
var
  LTime: TDateTime;
begin
  Result := TryEncodeDate(AYear, AMonth, ADay, AValue);
  if Result then
  begin
    Result := TryEncodeTime(AHour, AMinute, ASecond, AMilliSecond, LTime);
    if Result then
      if AValue >= 0 then
        AValue := AValue + LTime
      else
        AValue := AValue - LTime
  end;
end;

function TryEncodeDateWeek(const AYear, AWeekOfYear: Word;
  out AValue: TDateTime; const ADayOfWeek: Word): Boolean;
var
  LDayOfYear: Integer;
  LStartDayOfWeek: Word;
begin
  Result := IsValidDateWeek(AYear, AWeekOfYear, ADayOfWeek);
  if Result then
  begin
    AValue := EncodeDate(AYear, 1, 1);
    LStartDayOfWeek := DayOfTheWeek(AValue);
    LDayOfYear := (AWeekOfYear - 1) * 7 + ADayOfWeek - 1;
    if LStartDayOfWeek in [DayFriday, DaySaturday, DaySunday] then
      Inc(LDayOfYear, 8 - LStartDayOfWeek)
    else
      Dec(LDayOfYear, LStartDayOfWeek - 1);
    AValue := AValue + LDayOfYear;
  end;
end;

function TryEncodeDateDay(const AYear, ADayOfYear: Word;
  out AValue: TDateTime): Boolean;
begin
  Result := IsValidDateDay(AYear, ADayOfYear);
  if Result then
    AValue := StartOfAYear(AYear) + ADayOfYear - 1;
end;

function TryEncodeDateMonthWeek(const AYear, AMonth, AWeekOfMonth,
  ADayOfWeek: Word; var AValue: TDateTime): Boolean;
var
  LStartDayOfWeek: Word;
  LDayOfMonth: Integer;
begin
  Result := IsValidDateMonthWeek(AYear, AMonth, AWeekOfMonth, ADayOfWeek);
  if Result then
  begin
    AValue := EncodeDate(AYear, AMonth, 1);
    LStartDayOfWeek := DayOfTheWeek(AValue);
    LDayOfMonth := (AWeekOfMonth - 1) * 7 + ADayOfWeek - 1;
    if LStartDayOfWeek in [DayFriday, DaySaturday, DaySunday] then
      Inc(LDayOfMonth, 8 - LStartDayOfWeek)
    else
      Dec(LDayOfMonth, LStartDayOfWeek - 1);
    AValue := AValue + LDayOfMonth;
  end;
end;


function RecodeYear(const AValue: TDateTime; const AYear: Word): TDateTime;
begin
  Result := RecodeDateTime(AValue, AYear, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs);
end;

function RecodeMonth(const AValue: TDateTime; const AMonth: Word): TDateTime;
begin
  Result := RecodeDateTime(AValue, RecodeLeaveFieldAsIs, AMonth,
    RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs);
end;

function RecodeDay(const AValue: TDateTime; const ADay: Word): TDateTime;
begin
  Result := RecodeDateTime(AValue, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs,
    ADay, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs);
end;

function RecodeHour(const AValue: TDateTime; const AHour: Word): TDateTime;
begin
  Result := RecodeDateTime(AValue, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs, AHour, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs);
end;

function RecodeMinute(const AValue: TDateTime; const AMinute: Word): TDateTime;
begin
  Result := RecodeDateTime(AValue, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs, AMinute, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs);
end;

function RecodeSecond(const AValue: TDateTime; const ASecond: Word): TDateTime;
begin
  Result := RecodeDateTime(AValue, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs, ASecond,
    RecodeLeaveFieldAsIs);
end;

function RecodeMilliSecond(const AValue: TDateTime;
  const AMilliSecond: Word): TDateTime;
begin
  Result := RecodeDateTime(AValue, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs, AMilliSecond);
end;

function RecodeDate(const AValue: TDateTime; const AYear, AMonth,
  ADay: Word): TDateTime;
begin
  Result := RecodeDateTime(AValue, AYear, AMonth, ADay, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs);
end;

function RecodeTime(const AValue: TDateTime; const AHour, AMinute, ASecond,
  AMilliSecond: Word): TDateTime;
begin
  Result := RecodeDateTime(AValue, RecodeLeaveFieldAsIs, RecodeLeaveFieldAsIs,
    RecodeLeaveFieldAsIs, AHour, AMinute, ASecond, AMilliSecond);
end;

function RecodeDateTime(const AValue: TDateTime; const AYear, AMonth, ADay,
  AHour, AMinute, ASecond, AMilliSecond: Word): TDateTime;
begin
  if not TryRecodeDateTime(AValue, AYear, AMonth, ADay,
                           AHour, AMinute, ASecond, AMilliSecond, Result) then
    InvalidDateTimeError(AYear, AMonth, ADay,
                         AHour, AMinute, ASecond, AMilliSecond,
                         AValue);
end;

function TryRecodeDateTime(const AValue: TDateTime; const AYear, AMonth, ADay,
  AHour, AMinute, ASecond, AMilliSecond: Word; out AResult: TDateTime): Boolean;
var
  LYear, LMonth, LDay, LHour, LMinute, LSecond, LMilliSecond: Word;
begin
  DecodeDateTime(AValue, LYear, LMonth, LDay,
                         LHour, LMinute, LSecond, LMilliSecond);
  if AYear <> RecodeLeaveFieldAsIs then LYear := AYear;
  if AMonth <> RecodeLeaveFieldAsIs then LMonth := AMonth;
  if ADay <> RecodeLeaveFieldAsIs then LDay := ADay;
  if AHour <> RecodeLeaveFieldAsIs then LHour := AHour;
  if AMinute <> RecodeLeaveFieldAsIs then LMinute := AMinute;
  if ASecond <> RecodeLeaveFieldAsIs then LSecond := ASecond;
  if AMilliSecond <> RecodeLeaveFieldAsIs then LMilliSecond := AMilliSecond;
  Result := TryEncodeDateTime(LYear, LMonth, LDay,
                              LHour, LMinute, LSecond, LMilliSecond, AResult);
end;

{ Fuzzy comparison }

function CompareDateTime(const A, B: TDateTime): TValueRelationship;
begin
  if Abs(A - B) < OneMillisecond then
    Result := EqualsValue
  else if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function SameDateTime(const A, B: TDateTime): Boolean;
begin
  Result := Abs(A - B) < OneMillisecond;
end;

function CompareDate(const A, B: TDateTime): TValueRelationship;
begin
  if Trunc(A) = Trunc(B) then
    Result := EqualsValue
  else if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function SameDate(const A, B: TDateTime): Boolean;
begin
  Result := Trunc(A) = Trunc(B);
end;

function CompareTime(const A, B: TDateTime): TValueRelationship;
begin
  if Abs(Frac(A) - Frac(B)) < OneMillisecond then
    Result := EqualsValue
  else if Frac(A) < Frac(B) then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function SameTime(const A, B: TDateTime): Boolean;
begin
  Result := Abs(Frac(A) - Frac(B)) < OneMillisecond;
end;


{ NthDayOfWeek conversion }

function NthDayOfWeek(const AValue: TDateTime): Word;
begin
  Result := (DayOfTheMonth(AValue) - 1) div 7 + 1;
end;

procedure DecodeDayOfWeekInMonth(const AValue: TDateTime; out AYear, AMonth,
  ANthDayOfWeek, ADayOfWeek: Word);
var
  ADay: Word;
begin
  DecodeDate(AValue, AYear, AMonth, ADay);
  ANthDayOfWeek := (ADay - 1) div 7 + 1;
  ADayOfWeek := DayOfTheWeek(AValue);
end;

function EncodeDayOfWeekInMonth(const AYear, AMonth, ANthDayOfWeek,
  ADayOfWeek: Word): TDateTime;
begin
  if not TryEncodeDayOfWeekInMonth(AYear, AMonth, ANthDayOfWeek, ADayOfWeek, Result) then
    InvalidDayOfWeekInMonthError(AYear, AMonth, ANthDayOfWeek, ADayOfWeek);
end;

function TryEncodeDayOfWeekInMonth(const AYear, AMonth,
  ANthDayOfWeek, ADayOfWeek: Word; out AValue: TDateTime): Boolean;
var
  LStartOfMonth, LDay: Word;
begin
  LStartOfMonth := DayOfTheWeek(StartOfAMonth(AYear, AMonth));
  if LStartOfMonth <= ADayOfWeek then
    LDay := (ADayOfWeek - LStartOfMonth + 1) + 7 * (ANthDayOfWeek - 1)
  else
    LDay := (7 - LStartOfMonth + 1) + ADayOfWeek + 7 * (ANthDayOfWeek - 1);
  Result := TryEncodeDate(AYear, AMonth, LDay, AValue);
end;


{ Julian and Modified Julian Date conversion support }

function DateTimeToJulianDate(const AValue: TDateTime): Double;
var
  LYear, LMonth, LDay: Word;
begin
  DecodeDate(AValue, LYear, LMonth, LDay);
  Result := (1461 * (LYear + 4800 + (LMonth - 14) div 12)) div 4 +
            (367 * (LMonth - 2 - 12 * ((LMonth - 14) div 12))) div 12 -
            (3 * ((LYear + 4900 + (LMonth - 14) div 12) div 100)) div 4 +
            LDay - 32075.5 + Frac(AValue);
end;

function JulianDateToDateTime(const AValue: Double): TDateTime;
begin
  if not TryJulianDateToDateTime(AValue, Result) then
    raise EConvertError.CreateFmt(SInvalidJulianDate, [AValue]);
end;

function TryJulianDateToDateTime(const AValue: Double;
  out ADateTime: TDateTime): Boolean;
var
  L, N, LYear, LMonth, LDay: Integer;
begin
  L := Trunc(AValue) + 68570;
  N := 4 * L div 146097;
  L := L - (146097 * N + 3) div 4;
  LYear := 4000 * (L + 1) div 1461001;
  L := L - 1461 * LYear div 4 + 31;
  LMonth := 80 * L div 2447;
  LDay := L - 2447 * LMonth div 80;
  L := LMonth div 11;
  LMonth := LMonth + 2 - 12 * L;
  LYear := 100 * (N - 49) + LYear + L;
  Result := TryEncodeDate(Word(LYear), Word(LMonth), Word(LDay), ADateTime);
  if Result then
    ADateTime := ADateTime + Frac(AValue) - 0.5;
end;

const
  CJDToMJDOffset: TDateTime = 2400000.5;

function DateTimeToModifiedJulianDate(const AValue: TDateTime): Double;
begin
  Result := DateTimeToJulianDate(AValue) - CJDToMJDOffset;
end;

function ModifiedJulianDateToDateTime(const AValue: Double): TDateTime;
begin
  Result := JulianDateToDateTime(AValue + CJDToMJDOffset);
end;

function TryModifiedJulianDateToDateTime(const AValue: Double;
  out ADateTime: TDateTime): Boolean;
begin
  Result := TryJulianDateToDateTime(AValue + CJDToMJDOffset, ADateTime);
end;


{ Unix date conversion support }

function DateTimeToUnix(const AValue: TDateTime): Int64;
begin
  Result := Round((AValue - UnixDateDelta) * SecsPerDay);
end;

function UnixToDateTime(const AValue: Int64): TDateTime;
begin
  Result := AValue / SecsPerDay + UnixDateDelta;
end;


{ Error reporting }

procedure InvalidDateTimeError(const AYear, AMonth, ADay, AHour, AMinute,
  ASecond, AMilliSecond: Word; const ABaseDate: TDateTime);
  function Translate(AOrig, AValue: Word): string;
  begin
    if AValue = RecodeLeaveFieldAsIs then
      if ABaseDate = 0 then
        Result := SMissingDateTimeField
      else
        Result := IntToStr(AOrig)
    else
      Result := IntToStr(AValue);
  end;
var
  LYear, LMonth, LDay, LHour, LMinute, LSecond, LMilliSecond: Word;
begin
  DecodeDate(ABaseDate, LYear, LMonth, LDay);
  DecodeTime(ABaseDate, LHour, LMinute, LSecond, LMilliSecond);
  raise EConvertError.CreateFmt(SInvalidDateTime,
                                [Translate(LYear, AYear) + DateSeparator +
                                 Translate(LMonth, AMonth) + DateSeparator +
                                 Translate(LDay, ADay) + ' ' +
                                 Translate(LHour, AHour) + TimeSeparator +
                                 Translate(LMinute, AMinute) + TimeSeparator +
                                 Translate(LSecond, ASecond) + DecimalSeparator +
                                 Translate(LMilliSecond, AMilliSecond)]);
end;

procedure InvalidDateWeekError(const AYear, AWeekOfYear, ADayOfWeek: Word);
begin
  raise EConvertError.CreateFmt(SInvalidDateWeek, [AYear, AWeekOfYear, ADayOfWeek]);
end;

procedure InvalidDateDayError(const AYear, ADayOfYear: Word);
begin
  raise EConvertError.CreateFmt(SInvalidDateDay, [AYear, ADayOfYear]);
end;

procedure InvalidDateMonthWeekError(const AYear, AMonth, AWeekOfMonth,
  ADayOfWeek: Word);
begin
  raise EConvertError.CreateFmt(SInvalidDateMonthWeek, [AYear, AMonth,
    AWeekOfMonth, ADayOfWeek]);
end;

procedure InvalidDayOfWeekInMonthError(const AYear, AMonth, ANthDayOfWeek,
  ADayOfWeek: Word);
begin
  raise EConvertError.CreateFmt(SInvalidDayOfWeekInMonth, [AYear, AMonth,
    ANthDayOfWeek, ADayOfWeek]);
end;

end.
