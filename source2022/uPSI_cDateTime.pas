unit uPSI_cDateTime;
{
  the time machine lib to mktime!, selftest selftestCdateTime
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_cDateTime = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cDateTime(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cDateTime_Routines(S: TPSExec);
procedure RIRegister_cDateTime(CL: TPSRuntimeClassImporter);



procedure Register;

implementation


uses
   cUtils
  ,dateutils
  ,cDateTime
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cDateTime]);
end;

function DayOfYear2(const Ye, Mo, Da: Word): Integer; //overload;
begin
  result:= DayOfYear(Ye, Mo, Da);
end;

function DayOfYear1(const D: TDateTime): Integer; //overload;

begin
  result:= DayOfYear(D);
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cDateTime(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EDateTime');
 CL.AddDelphiFunction('Procedure CDecodeDateTime( const DateTime : TDateTime; out Year, Month, Day, Hour, Minute, Second, Millisecond : Word)');
 CL.AddDelphiFunction('Function DatePart( const D : TDateTime) : Integer');
 CL.AddDelphiFunction('Function TimePart( const D : TDateTime) : Double');
 CL.AddDelphiFunction('Function Century( const D : TDateTime) : Word');
 CL.AddDelphiFunction('Function Year( const D : TDateTime) : Word');
 CL.AddDelphiFunction('Function Month( const D : TDateTime) : Word');
 CL.AddDelphiFunction('Function Day( const D : TDateTime) : Word');
 CL.AddDelphiFunction('Function Hour( const D : TDateTime) : Word');
 CL.AddDelphiFunction('Function Minute( const D : TDateTime) : Word');
 CL.AddDelphiFunction('Function Second( const D : TDateTime) : Word');
 CL.AddDelphiFunction('Function Millisecond( const D : TDateTime) : Word');
 CL.AddConstantN('OneDay','Extended').setExtended( 1.0);
 CL.AddConstantN('OneHour','Extended').SetExtended( OneDay / 24);
 CL.AddConstantN('OneMinute','Extended').SetExtended( OneHour / 60);
 CL.AddConstantN('OneSecond','Extended').SetExtended( OneMinute / 60);
 CL.AddConstantN('OneMillisecond','Extended').SetExtended( OneSecond / 1000);
 CL.AddConstantN('OneWeek','Extended').SetExtended( OneDay * 7);
 CL.AddConstantN('HoursPerDay','Extended').SetExtended( 24);
 CL.AddConstantN('MinutesPerHour','Extended').SetExtended( 60);
 CL.AddConstantN('SecondsPerMinute','Extended').SetExtended( 60);
 CL.AddDelphiFunction('Function CEncodeDateTime( const Year, Month, Day, Hour, Minute, Second, Millisecond : Word) : TDateTime');
 CL.AddDelphiFunction('Function mktime( const Year, Month, Day, Hour, Minute, Second, Millisecond : Word) : TDateTime');

 CL.AddDelphiFunction('Procedure SetYear( var D : TDateTime; const Year : Word)');
 CL.AddDelphiFunction('Procedure SetMonth( var D : TDateTime; const Month : Word)');
 CL.AddDelphiFunction('Procedure SetDay( var D : TDateTime; const Day : Word)');
 CL.AddDelphiFunction('Procedure SetHour( var D : TDateTime; const Hour : Word)');
 CL.AddDelphiFunction('Procedure SetMinute( var D : TDateTime; const Minute : Word)');
 CL.AddDelphiFunction('Procedure SetSecond( var D : TDateTime; const Second : Word)');
 CL.AddDelphiFunction('Procedure SetMillisecond( var D : TDateTime; const Milliseconds : Word)');
 CL.AddDelphiFunction('Function IsEqual( const D1, D2 : TDateTime) : Boolean;');
 CL.AddDelphiFunction('Function IsEqual1( const D1 : TDateTime; const Ye, Mo, Da : Word) : Boolean;');
 CL.AddDelphiFunction('Function IsEqual2( const D1 : TDateTime; const Ho, Mi, Se, ms : Word) : Boolean;');
 CL.AddDelphiFunction('Function IsAM( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsPM( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsMidnight( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsNoon( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsSunday( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsMonday( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsTuesday( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsWedneday( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsThursday( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsFriday( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsSaturday( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsWeekend( const D : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function Noon( const D : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function Midnight( const D : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function FirstDayOfMonth( const D : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function LastDayOfMonth( const D : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function NextWorkday( const D : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function PreviousWorkday( const D : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function FirstDayOfYear( const D : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function LastDayOfYear( const D : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function EasterSunday( const Year : Word) : TDateTime');
 CL.AddDelphiFunction('Function GoodFriday( const Year : Word) : TDateTime');
 CL.AddDelphiFunction('Function AddMilliseconds( const D : TDateTime; const N : Int64) : TDateTime');
 CL.AddDelphiFunction('Function AddSeconds( const D : TDateTime; const N : Int64) : TDateTime');
 CL.AddDelphiFunction('Function AddMinutes( const D : TDateTime; const N : Integer) : TDateTime');
 CL.AddDelphiFunction('Function AddHours( const D : TDateTime; const N : Integer) : TDateTime');
 CL.AddDelphiFunction('Function AddDays( const D : TDateTime; const N : Integer) : TDateTime');
 CL.AddDelphiFunction('Function AddWeeks( const D : TDateTime; const N : Integer) : TDateTime');
 CL.AddDelphiFunction('Function AddMonths( const D : TDateTime; const N : Integer) : TDateTime');
 CL.AddDelphiFunction('Function AddYears( const D : TDateTime; const N : Integer) : TDateTime');
 CL.AddDelphiFunction('Function DayOfYear2( const Ye, Mo, Da : Word) : Integer');
 CL.AddDelphiFunction('Function DayOfYear( const D : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DaysInMonth2( const Ye, Mo : Word) : Integer');
 CL.AddDelphiFunction('Function DaysInMonth( const D : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DaysInYear( const Ye : Word) : Integer');
 CL.AddDelphiFunction('Function DaysInYearDate( const D : TDateTime) : Integer');
 CL.AddDelphiFunction('Function WeekNumber( const D : TDateTime) : Integer');
 CL.AddDelphiFunction('Function ISOFirstWeekOfYear( const Ye : Word) : TDateTime');
 CL.AddDelphiFunction('Procedure ISOWeekNumber( const D : TDateTime; var WeekNumber, WeekYear : Word)');
 CL.AddDelphiFunction('Function DiffMilliseconds( const D1, D2 : TDateTime) : Int64');
 CL.AddDelphiFunction('Function DiffSeconds( const D1, D2 : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DiffMinutes( const D1, D2 : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DiffHours( const D1, D2 : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DiffDays( const D1, D2 : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DiffWeeks( const D1, D2 : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DiffMonths( const D1, D2 : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DiffYears( const D1, D2 : TDateTime) : Integer');
 CL.AddDelphiFunction('Function GMTBias : Integer');
 CL.AddDelphiFunction('Function GMTTimeToLocalTime( const D : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function LocalTimeToGMTTime( const D : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function NowAsGMTTime : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToISO8601String( const D : TDateTime) : AnsiString');
 CL.AddDelphiFunction('Function ISO8601StringToTime( const D : AnsiString) : TDateTime');
 CL.AddDelphiFunction('Function ISO8601StringAsDateTime( const D : AnsiString) : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToANSI( const D : TDateTime) : Integer');
 CL.AddDelphiFunction('Function ANSIToDateTime( const Julian : Integer) : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToISOInteger( const D : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DateTimeToISOString( const D : TDateTime) : AnsiString');
 CL.AddDelphiFunction('Function ISOIntegerToDateTime( const ISOInteger : Integer) : TDateTime');
 CL.AddDelphiFunction('Function TwoDigitRadix2000YearToYear( const Y : Integer) : Integer');
 CL.AddDelphiFunction('Function DateTimeAsElapsedTime( const D : TDateTime; const IncludeMilliseconds : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function UnixTimeToDateTime( const UnixTime : LongWord) : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToUnixTime( const D : TDateTime) : LongWord');
 CL.AddDelphiFunction('Function EnglishShortDayOfWeekStrA( const DayOfWeek : Integer) : AnsiString');
 CL.AddDelphiFunction('Function EnglishShortDayOfWeekStrU( const DayOfWeek : Integer) : UnicodeString');
 CL.AddDelphiFunction('Function EnglishLongDayOfWeekStrA( const DayOfWeek : Integer) : AnsiString');
 CL.AddDelphiFunction('Function EnglishLongDayOfWeekStrU( const DayOfWeek : Integer) : UnicodeString');
 CL.AddDelphiFunction('Function EnglishShortMonthStrA( const Month : Integer) : AnsiString');
 CL.AddDelphiFunction('Function EnglishShortMonthStrU( const Month : Integer) : UnicodeString');
 CL.AddDelphiFunction('Function EnglishLongMonthStrA( const Month : Integer) : AnsiString');
 CL.AddDelphiFunction('Function EnglishLongMonthStrU( const Month : Integer) : UnicodeString');
 CL.AddDelphiFunction('Function EnglishShortDayOfWeekA( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function EnglishShortDayOfWeekU( const S : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function EnglishLongDayOfWeekA( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function EnglishLongDayOfWeekU( const S : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function EnglishShortMonthA( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function EnglishShortMonthU( const S : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function EnglishLongMonthA( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function EnglishLongMonthU( const S : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function RFC850DayOfWeekA( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function RFC850DayOfWeekU( const S : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function RFC1123DayOfWeekA( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function RFC1123DayOfWeekU( const S : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function RFCMonthA( const S : AnsiString) : Word');
 CL.AddDelphiFunction('Function RFCMonthU( const S : UnicodeString) : Word');
 CL.AddDelphiFunction('Function GMTTimeToRFC1123TimeA( const D : TDateTime; const IncludeSeconds : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function GMTTimeToRFC1123TimeU( const D : TDateTime; const IncludeSeconds : Boolean) : UnicodeString');
 CL.AddDelphiFunction('Function GMTDateTimeToRFC1123DateTimeA( const D : TDateTime; const IncludeDayOfWeek : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function GMTDateTimeToRFC1123DateTimeU( const D : TDateTime; const IncludeDayOfWeek : Boolean) : UnicodeString');
 CL.AddDelphiFunction('Function DateTimeToRFCDateTimeA( const D : TDateTime) : AnsiString');
 CL.AddDelphiFunction('Function DateTimeToRFCDateTimeU( const D : TDateTime) : UnicodeString');
 CL.AddDelphiFunction('Function NowAsRFCDateTimeA : AnsiString');
 CL.AddDelphiFunction('Function NowAsRFCDateTimeU : UnicodeString');
 CL.AddDelphiFunction('Function RFCDateTimeToGMTDateTime( const S : AnsiString) : TDateTime');
 CL.AddDelphiFunction('Function RFCDateTimeToDateTime( const S : AnsiString) : TDateTime');
 CL.AddDelphiFunction('Function RFCTimeZoneToGMTBias( const Zone : AnsiString) : Integer');
 CL.AddDelphiFunction('Function TimePeriodStr( const D : TDateTime) : AnsiString');
 CL.AddDelphiFunction('Procedure SelfTestCDateTime');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function IsEqual2_P( const D1 : TDateTime; const Ho, Mi, Se, ms : Word) : Boolean;
Begin Result := cDateTime.IsEqual(D1, Ho, Mi, Se, ms); END;

(*----------------------------------------------------------------------------*)
Function IsEqual1_P( const D1 : TDateTime; const Ye, Mo, Da : Word) : Boolean;
Begin Result := cDateTime.IsEqual(D1, Ye, Mo, Da); END;

(*----------------------------------------------------------------------------*)
Function IsEqual_P( const D1, D2 : TDateTime) : Boolean;
Begin Result := cDateTime.IsEqual(D1, D2); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cDateTime_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DecodeDateTime, 'CDecodeDateTime', cdRegister);
 S.RegisterDelphiFunction(@DatePart, 'DatePart', cdRegister);
 S.RegisterDelphiFunction(@TimePart, 'TimePart', cdRegister);
 S.RegisterDelphiFunction(@Century, 'Century', cdRegister);
 S.RegisterDelphiFunction(@Year, 'Year', cdRegister);
 S.RegisterDelphiFunction(@Month, 'Month', cdRegister);
 S.RegisterDelphiFunction(@Day, 'Day', cdRegister);
 S.RegisterDelphiFunction(@Hour, 'Hour', cdRegister);
 S.RegisterDelphiFunction(@Minute, 'Minute', cdRegister);
 S.RegisterDelphiFunction(@Second, 'Second', cdRegister);
 S.RegisterDelphiFunction(@Millisecond, 'Millisecond', cdRegister);
 S.RegisterDelphiFunction(@EncodeDateTime, 'CEncodeDateTime', cdRegister);
 S.RegisterDelphiFunction(@EncodeDateTime, 'mktime', cdRegister);   //alias

 S.RegisterDelphiFunction(@SetYear, 'SetYear', cdRegister);
 S.RegisterDelphiFunction(@SetMonth, 'SetMonth', cdRegister);
 S.RegisterDelphiFunction(@SetDay, 'SetDay', cdRegister);
 S.RegisterDelphiFunction(@SetHour, 'SetHour', cdRegister);
 S.RegisterDelphiFunction(@SetMinute, 'SetMinute', cdRegister);
 S.RegisterDelphiFunction(@SetSecond, 'SetSecond', cdRegister);
 S.RegisterDelphiFunction(@SetMillisecond, 'SetMillisecond', cdRegister);
 S.RegisterDelphiFunction(@IsEqual_P, 'IsEqual', cdRegister);
 S.RegisterDelphiFunction(@IsEqual1_P, 'IsEqual1', cdRegister);
 S.RegisterDelphiFunction(@IsEqual2_P, 'IsEqual2', cdRegister);
 S.RegisterDelphiFunction(@IsAM, 'IsAM', cdRegister);
 S.RegisterDelphiFunction(@IsPM, 'IsPM', cdRegister);
 S.RegisterDelphiFunction(@IsMidnight, 'IsMidnight', cdRegister);
 S.RegisterDelphiFunction(@IsNoon, 'IsNoon', cdRegister);
 S.RegisterDelphiFunction(@IsSunday, 'IsSunday', cdRegister);
 S.RegisterDelphiFunction(@IsMonday, 'IsMonday', cdRegister);
 S.RegisterDelphiFunction(@IsTuesday, 'IsTuesday', cdRegister);
 S.RegisterDelphiFunction(@IsWedneday, 'IsWedneday', cdRegister);
 S.RegisterDelphiFunction(@IsThursday, 'IsThursday', cdRegister);
 S.RegisterDelphiFunction(@IsFriday, 'IsFriday', cdRegister);
 S.RegisterDelphiFunction(@IsSaturday, 'IsSaturday', cdRegister);
 S.RegisterDelphiFunction(@IsWeekend, 'IsWeekend', cdRegister);
 S.RegisterDelphiFunction(@Noon, 'Noon', cdRegister);
 S.RegisterDelphiFunction(@Midnight, 'Midnight', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfMonth, 'FirstDayOfMonth', cdRegister);
 S.RegisterDelphiFunction(@LastDayOfMonth, 'LastDayOfMonth', cdRegister);
 S.RegisterDelphiFunction(@NextWorkday, 'NextWorkday', cdRegister);
 S.RegisterDelphiFunction(@PreviousWorkday, 'PreviousWorkday', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfYear, 'FirstDayOfYear', cdRegister);
 S.RegisterDelphiFunction(@LastDayOfYear, 'LastDayOfYear', cdRegister);
 S.RegisterDelphiFunction(@EasterSunday, 'EasterSunday', cdRegister);
 S.RegisterDelphiFunction(@GoodFriday, 'GoodFriday', cdRegister);
 S.RegisterDelphiFunction(@AddMilliseconds, 'AddMilliseconds', cdRegister);
 S.RegisterDelphiFunction(@AddSeconds, 'AddSeconds', cdRegister);
 S.RegisterDelphiFunction(@AddMinutes, 'AddMinutes', cdRegister);
 S.RegisterDelphiFunction(@AddHours, 'AddHours', cdRegister);
 S.RegisterDelphiFunction(@AddDays, 'AddDays', cdRegister);
 S.RegisterDelphiFunction(@AddWeeks, 'AddWeeks', cdRegister);
 S.RegisterDelphiFunction(@AddMonths, 'AddMonths', cdRegister);
 S.RegisterDelphiFunction(@AddYears, 'AddYears', cdRegister);
 S.RegisterDelphiFunction(@DayOfYear1, 'DayOfYear', cdRegister);
 S.RegisterDelphiFunction(@DayOfYear2, 'DayOfYear2', cdRegister);
 S.RegisterDelphiFunction(@DaysInMonth, 'DaysInMonth', cdRegister);
 S.RegisterDelphiFunction(@DaysInMonth, 'DaysInMonth2', cdRegister);
 S.RegisterDelphiFunction(@DaysInYear, 'DaysInYear', cdRegister);
 S.RegisterDelphiFunction(@DaysInYearDate, 'DaysInYearDate', cdRegister);
 S.RegisterDelphiFunction(@WeekNumber, 'WeekNumber', cdRegister);
 S.RegisterDelphiFunction(@ISOFirstWeekOfYear, 'ISOFirstWeekOfYear', cdRegister);
 S.RegisterDelphiFunction(@ISOWeekNumber, 'ISOWeekNumber', cdRegister);
 S.RegisterDelphiFunction(@DiffMilliseconds, 'DiffMilliseconds', cdRegister);
 S.RegisterDelphiFunction(@DiffSeconds, 'DiffSeconds', cdRegister);
 S.RegisterDelphiFunction(@DiffMinutes, 'DiffMinutes', cdRegister);
 S.RegisterDelphiFunction(@DiffHours, 'DiffHours', cdRegister);
 S.RegisterDelphiFunction(@DiffDays, 'DiffDays', cdRegister);
 S.RegisterDelphiFunction(@DiffWeeks, 'DiffWeeks', cdRegister);
 S.RegisterDelphiFunction(@DiffMonths, 'DiffMonths', cdRegister);
 S.RegisterDelphiFunction(@DiffYears, 'DiffYears', cdRegister);
 S.RegisterDelphiFunction(@GMTBias, 'GMTBias', cdRegister);
 S.RegisterDelphiFunction(@GMTTimeToLocalTime, 'GMTTimeToLocalTime', cdRegister);
 S.RegisterDelphiFunction(@LocalTimeToGMTTime, 'LocalTimeToGMTTime', cdRegister);
 S.RegisterDelphiFunction(@NowAsGMTTime, 'NowAsGMTTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToISO8601String, 'DateTimeToISO8601String', cdRegister);
 S.RegisterDelphiFunction(@ISO8601StringToTime, 'ISO8601StringToTime', cdRegister);
 S.RegisterDelphiFunction(@ISO8601StringAsDateTime, 'ISO8601StringAsDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToANSI, 'DateTimeToANSI', cdRegister);
 S.RegisterDelphiFunction(@ANSIToDateTime, 'ANSIToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToISOInteger, 'DateTimeToISOInteger', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToISOString, 'DateTimeToISOString', cdRegister);
 S.RegisterDelphiFunction(@ISOIntegerToDateTime, 'ISOIntegerToDateTime', cdRegister);
 S.RegisterDelphiFunction(@TwoDigitRadix2000YearToYear, 'TwoDigitRadix2000YearToYear', cdRegister);
 S.RegisterDelphiFunction(@DateTimeAsElapsedTime, 'DateTimeAsElapsedTime', cdRegister);
 S.RegisterDelphiFunction(@UnixTimeToDateTime, 'UnixTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToUnixTime, 'DateTimeToUnixTime', cdRegister);
 S.RegisterDelphiFunction(@EnglishShortDayOfWeekStrA, 'EnglishShortDayOfWeekStrA', cdRegister);
 S.RegisterDelphiFunction(@EnglishShortDayOfWeekStrU, 'EnglishShortDayOfWeekStrU', cdRegister);
 S.RegisterDelphiFunction(@EnglishLongDayOfWeekStrA, 'EnglishLongDayOfWeekStrA', cdRegister);
 S.RegisterDelphiFunction(@EnglishLongDayOfWeekStrU, 'EnglishLongDayOfWeekStrU', cdRegister);
 S.RegisterDelphiFunction(@EnglishShortMonthStrA, 'EnglishShortMonthStrA', cdRegister);
 S.RegisterDelphiFunction(@EnglishShortMonthStrU, 'EnglishShortMonthStrU', cdRegister);
 S.RegisterDelphiFunction(@EnglishLongMonthStrA, 'EnglishLongMonthStrA', cdRegister);
 S.RegisterDelphiFunction(@EnglishLongMonthStrU, 'EnglishLongMonthStrU', cdRegister);
 S.RegisterDelphiFunction(@EnglishShortDayOfWeekA, 'EnglishShortDayOfWeekA', cdRegister);
 S.RegisterDelphiFunction(@EnglishShortDayOfWeekU, 'EnglishShortDayOfWeekU', cdRegister);
 S.RegisterDelphiFunction(@EnglishLongDayOfWeekA, 'EnglishLongDayOfWeekA', cdRegister);
 S.RegisterDelphiFunction(@EnglishLongDayOfWeekU, 'EnglishLongDayOfWeekU', cdRegister);
 S.RegisterDelphiFunction(@EnglishShortMonthA, 'EnglishShortMonthA', cdRegister);
 S.RegisterDelphiFunction(@EnglishShortMonthU, 'EnglishShortMonthU', cdRegister);
 S.RegisterDelphiFunction(@EnglishLongMonthA, 'EnglishLongMonthA', cdRegister);
 S.RegisterDelphiFunction(@EnglishLongMonthU, 'EnglishLongMonthU', cdRegister);
 S.RegisterDelphiFunction(@RFC850DayOfWeekA, 'RFC850DayOfWeekA', cdRegister);
 S.RegisterDelphiFunction(@RFC850DayOfWeekU, 'RFC850DayOfWeekU', cdRegister);
 S.RegisterDelphiFunction(@RFC1123DayOfWeekA, 'RFC1123DayOfWeekA', cdRegister);
 S.RegisterDelphiFunction(@RFC1123DayOfWeekU, 'RFC1123DayOfWeekU', cdRegister);
 S.RegisterDelphiFunction(@RFCMonthA, 'RFCMonthA', cdRegister);
 S.RegisterDelphiFunction(@RFCMonthU, 'RFCMonthU', cdRegister);
 S.RegisterDelphiFunction(@GMTTimeToRFC1123TimeA, 'GMTTimeToRFC1123TimeA', cdRegister);
 S.RegisterDelphiFunction(@GMTTimeToRFC1123TimeU, 'GMTTimeToRFC1123TimeU', cdRegister);
 S.RegisterDelphiFunction(@GMTDateTimeToRFC1123DateTimeA, 'GMTDateTimeToRFC1123DateTimeA', cdRegister);
 S.RegisterDelphiFunction(@GMTDateTimeToRFC1123DateTimeU, 'GMTDateTimeToRFC1123DateTimeU', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToRFCDateTimeA, 'DateTimeToRFCDateTimeA', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToRFCDateTimeU, 'DateTimeToRFCDateTimeU', cdRegister);
 S.RegisterDelphiFunction(@NowAsRFCDateTimeA, 'NowAsRFCDateTimeA', cdRegister);
 S.RegisterDelphiFunction(@NowAsRFCDateTimeU, 'NowAsRFCDateTimeU', cdRegister);
 S.RegisterDelphiFunction(@RFCDateTimeToGMTDateTime, 'RFCDateTimeToGMTDateTime', cdRegister);
 S.RegisterDelphiFunction(@RFCDateTimeToDateTime, 'RFCDateTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@RFCTimeZoneToGMTBias, 'RFCTimeZoneToGMTBias', cdRegister);
 S.RegisterDelphiFunction(@TimePeriodStr, 'TimePeriodStr', cdRegister);
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestCDateTime', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cDateTime(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDateTime) do
end;

 
 
{ TPSImport_cDateTime }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cDateTime.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cDateTime(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cDateTime.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cDateTime(ri);
  RIRegister_cDateTime_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
