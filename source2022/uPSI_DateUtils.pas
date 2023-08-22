unit uPSI_DateUtils;
{
UnitParser. Components of ROPS are used in the construction of UnitParser,
Third unit uPSI_DateUtils of two dateutils - uPSR_dateutils and uPSC_dateutils

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
  TPSImport_DateUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_DateUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DateUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Math
  ,Types
  ,DateUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DateUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_DateUtils(CL: TPSPascalCompiler);
begin
//type
  //TValueRelationship = -1..1;
 // CL.AddTypeS('TValueRelationship', '(-1,0,1');

 CL.AddDelphiFunction('Function DateOf( const AValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function TimeOf( const AValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function IsInLeapYear( const AValue : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsPM( const AValue : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsValidDate( const AYear, AMonth, ADay : Word) : Boolean');
 CL.AddDelphiFunction('Function IsValidTime( const AHour, AMinute, ASecond, AMilliSecond : Word) : Boolean');
 CL.AddDelphiFunction('Function IsValidDateTime( const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word) : Boolean');
 CL.AddDelphiFunction('Function IsValidDateDay( const AYear, ADayOfYear : Word) : Boolean');
 CL.AddDelphiFunction('Function IsValidDateWeek( const AYear, AWeekOfYear, ADayOfWeek : Word) : Boolean');
 CL.AddDelphiFunction('Function IsValidDateMonthWeek( const AYear, AMonth, AWeekOfMonth, ADayOfWeek : Word) : Boolean');
 CL.AddDelphiFunction('Function WeeksInYear( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function WeeksInAYear( const AYear : Word) : Word');
 CL.AddDelphiFunction('Function DaysInYear( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function DaysInAYear( const AYear : Word) : Word');
 CL.AddDelphiFunction('Function DaysInMonth( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function DaysInAMonth( const AYear, AMonth : Word) : Word');
 CL.AddDelphiFunction('Function Today : TDateTime');
 CL.AddDelphiFunction('Function Yesterday : TDateTime');
 CL.AddDelphiFunction('Function Tomorrow : TDateTime');
 CL.AddDelphiFunction('Function IsToday( const AValue : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsSameDay( const AValue, ABasis : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function YearOf( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function MonthOf( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function WeekOf( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function DayOf( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function HourOf( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function MinuteOf( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function SecondOf( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function MilliSecondOf( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function StartOfTheYear( const AValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function EndOfTheYear( const AValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function StartOfAYear( const AYear : Word) : TDateTime');
 CL.AddDelphiFunction('Function EndOfAYear( const AYear : Word) : TDateTime');
 CL.AddDelphiFunction('Function StartOfTheMonth( const AValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function EndOfTheMonth( const AValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function StartOfAMonth( const AYear, AMonth : Word) : TDateTime');
 CL.AddDelphiFunction('Function EndOfAMonth( const AYear, AMonth : Word) : TDateTime');
 CL.AddDelphiFunction('Function StartOfTheWeek( const AValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function EndOfTheWeek( const AValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function StartOfAWeek( const AYear, AWeekOfYear : Word; const ADayOfWeek : Word) : TDateTime');
 CL.AddDelphiFunction('Function EndOfAWeek( const AYear, AWeekOfYear : Word; const ADayOfWeek : Word) : TDateTime');
 CL.AddDelphiFunction('Function StartOfTheDay( const AValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function EndOfTheDay( const AValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function StartOfADay( const AYear, AMonth, ADay : Word) : TDateTime;');
 CL.AddDelphiFunction('Function EndOfADay( const AYear, AMonth, ADay : Word) : TDateTime;');
 CL.AddDelphiFunction('Function StartOfADay1( const AYear, ADayOfYear : Word) : TDateTime;');
 CL.AddDelphiFunction('Function EndOfADay1( const AYear, ADayOfYear : Word) : TDateTime;');
 CL.AddDelphiFunction('Function MonthOfTheYear( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function WeekOfTheYear( const AValue : TDateTime) : Word;');
 CL.AddDelphiFunction('Function WeekOfTheYear1( const AValue : TDateTime; var AYear : Word) : Word;');
 CL.AddDelphiFunction('Function DayOfTheYear( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function HourOfTheYear( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function MinuteOfTheYear( const AValue : TDateTime) : LongWord');
 CL.AddDelphiFunction('Function SecondOfTheYear( const AValue : TDateTime) : LongWord');
 CL.AddDelphiFunction('Function MilliSecondOfTheYear( const AValue : TDateTime) : Int64');
 CL.AddDelphiFunction('Function WeekOfTheMonth( const AValue : TDateTime) : Word;');
 CL.AddDelphiFunction('Function WeekOfTheMonth1( const AValue : TDateTime; var AYear, AMonth : Word) : Word;');
 CL.AddDelphiFunction('Function DayOfTheMonth( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function HourOfTheMonth( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function MinuteOfTheMonth( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function SecondOfTheMonth( const AValue : TDateTime) : LongWord');
 CL.AddDelphiFunction('Function MilliSecondOfTheMonth( const AValue : TDateTime) : LongWord');
 CL.AddDelphiFunction('Function DayOfTheWeek( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function HourOfTheWeek( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function MinuteOfTheWeek( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function SecondOfTheWeek( const AValue : TDateTime) : LongWord');
 CL.AddDelphiFunction('Function MilliSecondOfTheWeek( const AValue : TDateTime) : LongWord');
 CL.AddDelphiFunction('Function HourOfTheDay( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function MinuteOfTheDay( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function SecondOfTheDay( const AValue : TDateTime) : LongWord');
 CL.AddDelphiFunction('Function MilliSecondOfTheDay( const AValue : TDateTime) : LongWord');
 CL.AddDelphiFunction('Function MinuteOfTheHour( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function SecondOfTheHour( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function MilliSecondOfTheHour( const AValue : TDateTime) : LongWord');
 CL.AddDelphiFunction('Function SecondOfTheMinute( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function MilliSecondOfTheMinute( const AValue : TDateTime) : LongWord');
 CL.AddDelphiFunction('Function MilliSecondOfTheSecond( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Function WithinPastYears( const ANow, AThen : TDateTime; const AYears : Integer) : Boolean');
 CL.AddDelphiFunction('Function WithinPastMonths( const ANow, AThen : TDateTime; const AMonths : Integer) : Boolean');
 CL.AddDelphiFunction('Function WithinPastWeeks( const ANow, AThen : TDateTime; const AWeeks : Integer) : Boolean');
 CL.AddDelphiFunction('Function WithinPastDays( const ANow, AThen : TDateTime; const ADays : Integer) : Boolean');
 CL.AddDelphiFunction('Function WithinPastHours( const ANow, AThen : TDateTime; const AHours : Int64) : Boolean');
 CL.AddDelphiFunction('Function WithinPastMinutes( const ANow, AThen : TDateTime; const AMinutes : Int64) : Boolean');
 CL.AddDelphiFunction('Function WithinPastSeconds( const ANow, AThen : TDateTime; const ASeconds : Int64) : Boolean');
 CL.AddDelphiFunction('Function WithinPastMilliSeconds( const ANow, AThen : TDateTime; const AMilliSeconds : Int64) : Boolean');
 CL.AddDelphiFunction('Function YearsBetween( const ANow, AThen : TDateTime) : Integer');
 CL.AddDelphiFunction('Function MonthsBetween( const ANow, AThen : TDateTime) : Integer');
 CL.AddDelphiFunction('Function WeeksBetween( const ANow, AThen : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DaysBetween( const ANow, AThen : TDateTime) : Integer');
 CL.AddDelphiFunction('Function HoursBetween( const ANow, AThen : TDateTime) : Int64');
 CL.AddDelphiFunction('Function MinutesBetween( const ANow, AThen : TDateTime) : Int64');
 CL.AddDelphiFunction('Function SecondsBetween( const ANow, AThen : TDateTime) : Int64');
 CL.AddDelphiFunction('Function MilliSecondsBetween( const ANow, AThen : TDateTime) : Int64');
 CL.AddDelphiFunction('Function YearSpan( const ANow, AThen : TDateTime) : Double');
 CL.AddDelphiFunction('Function MonthSpan( const ANow, AThen : TDateTime) : Double');
 CL.AddDelphiFunction('Function WeekSpan( const ANow, AThen : TDateTime) : Double');
 CL.AddDelphiFunction('Function DaySpan( const ANow, AThen : TDateTime) : Double');
 CL.AddDelphiFunction('Function HourSpan( const ANow, AThen : TDateTime) : Double');
 CL.AddDelphiFunction('Function MinuteSpan( const ANow, AThen : TDateTime) : Double');
 CL.AddDelphiFunction('Function SecondSpan( const ANow, AThen : TDateTime) : Double');
 CL.AddDelphiFunction('Function MilliSecondSpan( const ANow, AThen : TDateTime) : Double');
 CL.AddDelphiFunction('Function IncYear( const AValue : TDateTime; const ANumberOfYears : Integer) : TDateTime');
 CL.AddDelphiFunction('Function IncWeek( const AValue : TDateTime; const ANumberOfWeeks : Integer) : TDateTime');
 CL.AddDelphiFunction('Function IncDay( const AValue : TDateTime; const ANumberOfDays : Integer) : TDateTime');
 CL.AddDelphiFunction('Function IncHour( const AValue : TDateTime; const ANumberOfHours : Int64) : TDateTime');
 CL.AddDelphiFunction('Function IncMinute( const AValue : TDateTime; const ANumberOfMinutes : Int64) : TDateTime');
 CL.AddDelphiFunction('Function IncSecond( const AValue : TDateTime; const ANumberOfSeconds : Int64) : TDateTime');
 CL.AddDelphiFunction('Function IncMilliSecond( const AValue : TDateTime; const ANumberOfMilliSeconds : Int64) : TDateTime');
 CL.AddDelphiFunction('Function EncodeDateTime( const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word) : TDateTime');
 CL.AddDelphiFunction('Procedure DecodeDateTime( const AValue : TDateTime; out AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word)');
 CL.AddDelphiFunction('Function EncodeDateWeek( const AYear, AWeekOfYear : Word; const ADayOfWeek : Word) : TDateTime');
 CL.AddDelphiFunction('Procedure DecodeDateWeek( const AValue : TDateTime; out AYear, AWeekOfYear, ADayOfWeek : Word)');
 CL.AddDelphiFunction('Function EncodeDateDay( const AYear, ADayOfYear : Word) : TDateTime');
 CL.AddDelphiFunction('Procedure DecodeDateDay( const AValue : TDateTime; out AYear, ADayOfYear : Word)');
 CL.AddDelphiFunction('Function EncodeDateMonthWeek( const AYear, AMonth, AWeekOfMonth, ADayOfWeek : Word) : TDateTime');
 CL.AddDelphiFunction('Procedure DecodeDateMonthWeek( const AValue : TDateTime; out AYear, AMonth, AWeekOfMonth, ADayOfWeek : Word)');
 CL.AddDelphiFunction('Function TryEncodeDateTime( const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word; out AValue : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function TryEncodeDateWeek( const AYear, AWeekOfYear : Word; out AValue : TDateTime; const ADayOfWeek : Word) : Boolean');
 CL.AddDelphiFunction('Function TryEncodeDateDay( const AYear, ADayOfYear : Word; out AValue : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function TryEncodeDateMonthWeek( const AYear, AMonth, AWeekOfMonth, ADayOfWeek : Word; var AValue : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function RecodeYear( const AValue : TDateTime; const AYear : Word) : TDateTime');
 CL.AddDelphiFunction('Function RecodeMonth( const AValue : TDateTime; const AMonth : Word) : TDateTime');
 CL.AddDelphiFunction('Function RecodeDay( const AValue : TDateTime; const ADay : Word) : TDateTime');
 CL.AddDelphiFunction('Function RecodeHour( const AValue : TDateTime; const AHour : Word) : TDateTime');
 CL.AddDelphiFunction('Function RecodeMinute( const AValue : TDateTime; const AMinute : Word) : TDateTime');
 CL.AddDelphiFunction('Function RecodeSecond( const AValue : TDateTime; const ASecond : Word) : TDateTime');
 CL.AddDelphiFunction('Function RecodeMilliSecond( const AValue : TDateTime; const AMilliSecond : Word) : TDateTime');
 CL.AddDelphiFunction('Function RecodeDate( const AValue : TDateTime; const AYear, AMonth, ADay : Word) : TDateTime');
 CL.AddDelphiFunction('Function RecodeTime( const AValue : TDateTime; const AHour, AMinute, ASecond, AMilliSecond : Word) : TDateTime');
 CL.AddDelphiFunction('Function RecodeDateTime( const AValue : TDateTime; const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word) : TDateTime');
 CL.AddDelphiFunction('Function TryRecodeDateTime( const AValue : TDateTime; const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word; out AResult : TDateTime) : Boolean');
 //CL.AddDelphiFunction('Function CompareDateTime( const A, B : TDateTime) : TValueRelationship');
 CL.AddDelphiFunction('Function SameDateTime( const A, B : TDateTime) : Boolean');
 //CL.AddDelphiFunction('Function CompareDate( const A, B : TDateTime) : TValueRelationship');
 CL.AddDelphiFunction('Function SameDate( const A, B : TDateTime) : Boolean');
// CL.AddDelphiFunction('Function CompareTime( const A, B : TDateTime) : TValueRelationship');
 CL.AddDelphiFunction('Function SameTime( const A, B : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function NthDayOfWeek( const AValue : TDateTime) : Word');
 CL.AddDelphiFunction('Procedure DecodeDayOfWeekInMonth( const AValue : TDateTime; out AYear, AMonth, ANthDayOfWeek, ADayOfWeek : Word)');
 CL.AddDelphiFunction('Function EncodeDayOfWeekInMonth( const AYear, AMonth, ANthDayOfWeek, ADayOfWeek : Word) : TDateTime');
 CL.AddDelphiFunction('Function TryEncodeDayOfWeekInMonth( const AYear, AMonth, ANthDayOfWeek, ADayOfWeek : Word; out AValue : TDateTime) : Boolean');
 CL.AddDelphiFunction('Procedure InvalidDateTimeError( const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word; const ABaseDate : TDateTime)');
 CL.AddDelphiFunction('Procedure InvalidDateWeekError( const AYear, AWeekOfYear, ADayOfWeek : Word)');
 CL.AddDelphiFunction('Procedure InvalidDateDayError( const AYear, ADayOfYear : Word)');
 CL.AddDelphiFunction('Procedure InvalidDateMonthWeekError( const AYear, AMonth, AWeekOfMonth, ADayOfWeek : Word)');
 CL.AddDelphiFunction('Procedure InvalidDayOfWeekInMonthError( const AYear, AMonth, ANthDayOfWeek, ADayOfWeek : Word)');
 CL.AddDelphiFunction('Function DateTimeToJulianDate( const AValue : TDateTime) : Double');
 CL.AddDelphiFunction('Function JulianDateToDateTime( const AValue : Double) : TDateTime');
 CL.AddDelphiFunction('Function TryJulianDateToDateTime( const AValue : Double; out ADateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function DateTimeToModifiedJulianDate( const AValue : TDateTime) : Double');
 CL.AddDelphiFunction('Function ModifiedJulianDateToDateTime( const AValue : Double) : TDateTime');
 CL.AddDelphiFunction('Function TryModifiedJulianDateToDateTime( const AValue : Double; out ADateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function DateTimeToUnix( const AValue : TDateTime) : Int64');
 CL.AddDelphiFunction('Function UnixToDateTime( const AValue : Int64) : TDateTime');
 CL.AddConstantN('DaysPerWeek','LongInt').SetInt( 7);
 CL.AddConstantN('WeeksPerFortnight','LongInt').SetInt( 2);
 CL.AddConstantN('MonthsPerYear','LongInt').SetInt( 12);
 CL.AddConstantN('YearsPerDecade','LongInt').SetInt( 10);
 CL.AddConstantN('YearsPerCentury','LongInt').SetInt( 100);
 CL.AddConstantN('YearsPerMillennium','LongInt').SetInt( 1000);
 CL.AddConstantN('DayMonday','LongInt').SetInt( 1);
 CL.AddConstantN('DayTuesday','LongInt').SetInt( 2);
 CL.AddConstantN('DayWednesday','LongInt').SetInt( 3);
 CL.AddConstantN('DayThursday','LongInt').SetInt( 4);
 CL.AddConstantN('DayFriday','LongInt').SetInt( 5);
 CL.AddConstantN('DaySaturday','LongInt').SetInt( 6);
 CL.AddConstantN('DaySunday','LongInt').SetInt( 7);
 //CL.AddTypeS('THexArray', 'array[0..15] of char;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function WeekOfTheMonth1_P( const AValue : TDateTime; var AYear, AMonth : Word) : Word;
Begin Result := DateUtils.WeekOfTheMonth(AValue, AYear, AMonth); END;

(*----------------------------------------------------------------------------*)
Function WeekOfTheMonth_P( const AValue : TDateTime) : Word;
Begin Result := DateUtils.WeekOfTheMonth(AValue); END;

(*----------------------------------------------------------------------------*)
Function WeekOfTheYear1_P( const AValue : TDateTime; var AYear : Word) : Word;
Begin Result := DateUtils.WeekOfTheYear(AValue, AYear); END;

(*----------------------------------------------------------------------------*)
Function WeekOfTheYear_P( const AValue : TDateTime) : Word;
Begin Result := DateUtils.WeekOfTheYear(AValue); END;

(*----------------------------------------------------------------------------*)
Function EndOfADay1_P( const AYear, ADayOfYear : Word) : TDateTime;
Begin Result := DateUtils.EndOfADay(AYear, ADayOfYear); END;

(*----------------------------------------------------------------------------*)
Function StartOfADay1_P( const AYear, ADayOfYear : Word) : TDateTime;
Begin Result := DateUtils.StartOfADay(AYear, ADayOfYear); END;

(*----------------------------------------------------------------------------*)
Function EndOfADay_P( const AYear, AMonth, ADay : Word) : TDateTime;
Begin Result := DateUtils.EndOfADay(AYear, AMonth, ADay); END;

(*----------------------------------------------------------------------------*)
Function StartOfADay_P( const AYear, AMonth, ADay : Word) : TDateTime;
Begin Result := DateUtils.StartOfADay(AYear, AMonth, ADay); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DateUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DateOf, 'DateOf', cdRegister);
 S.RegisterDelphiFunction(@TimeOf, 'TimeOf', cdRegister);
 S.RegisterDelphiFunction(@IsInLeapYear, 'IsInLeapYear', cdRegister);
 S.RegisterDelphiFunction(@IsPM, 'IsPM', cdRegister);
 S.RegisterDelphiFunction(@IsValidDate, 'IsValidDate', cdRegister);
 S.RegisterDelphiFunction(@IsValidTime, 'IsValidTime', cdRegister);
 S.RegisterDelphiFunction(@IsValidDateTime, 'IsValidDateTime', cdRegister);
 S.RegisterDelphiFunction(@IsValidDateDay, 'IsValidDateDay', cdRegister);
 S.RegisterDelphiFunction(@IsValidDateWeek, 'IsValidDateWeek', cdRegister);
 S.RegisterDelphiFunction(@IsValidDateMonthWeek, 'IsValidDateMonthWeek', cdRegister);
 S.RegisterDelphiFunction(@WeeksInYear, 'WeeksInYear', cdRegister);
 S.RegisterDelphiFunction(@WeeksInAYear, 'WeeksInAYear', cdRegister);
 S.RegisterDelphiFunction(@DaysInYear, 'DaysInYear', cdRegister);
 S.RegisterDelphiFunction(@DaysInAYear, 'DaysInAYear', cdRegister);
 S.RegisterDelphiFunction(@DaysInMonth, 'DaysInMonth', cdRegister);
 S.RegisterDelphiFunction(@DaysInAMonth, 'DaysInAMonth', cdRegister);
 S.RegisterDelphiFunction(@Today, 'Today', cdRegister);
 S.RegisterDelphiFunction(@Yesterday, 'Yesterday', cdRegister);
 S.RegisterDelphiFunction(@Tomorrow, 'Tomorrow', cdRegister);
 S.RegisterDelphiFunction(@IsToday, 'IsToday', cdRegister);
 S.RegisterDelphiFunction(@IsSameDay, 'IsSameDay', cdRegister);
 S.RegisterDelphiFunction(@YearOf, 'YearOf', cdRegister);
 S.RegisterDelphiFunction(@MonthOf, 'MonthOf', cdRegister);
 S.RegisterDelphiFunction(@WeekOf, 'WeekOf', cdRegister);
 S.RegisterDelphiFunction(@DayOf, 'DayOf', cdRegister);
 S.RegisterDelphiFunction(@HourOf, 'HourOf', cdRegister);
 S.RegisterDelphiFunction(@MinuteOf, 'MinuteOf', cdRegister);
 S.RegisterDelphiFunction(@SecondOf, 'SecondOf', cdRegister);
 S.RegisterDelphiFunction(@MilliSecondOf, 'MilliSecondOf', cdRegister);
 S.RegisterDelphiFunction(@StartOfTheYear, 'StartOfTheYear', cdRegister);
 S.RegisterDelphiFunction(@EndOfTheYear, 'EndOfTheYear', cdRegister);
 S.RegisterDelphiFunction(@StartOfAYear, 'StartOfAYear', cdRegister);
 S.RegisterDelphiFunction(@EndOfAYear, 'EndOfAYear', cdRegister);
 S.RegisterDelphiFunction(@StartOfTheMonth, 'StartOfTheMonth', cdRegister);
 S.RegisterDelphiFunction(@EndOfTheMonth, 'EndOfTheMonth', cdRegister);
 S.RegisterDelphiFunction(@StartOfAMonth, 'StartOfAMonth', cdRegister);
 S.RegisterDelphiFunction(@EndOfAMonth, 'EndOfAMonth', cdRegister);
 S.RegisterDelphiFunction(@StartOfTheWeek, 'StartOfTheWeek', cdRegister);
 S.RegisterDelphiFunction(@EndOfTheWeek, 'EndOfTheWeek', cdRegister);
 S.RegisterDelphiFunction(@StartOfAWeek, 'StartOfAWeek', cdRegister);
 S.RegisterDelphiFunction(@EndOfAWeek, 'EndOfAWeek', cdRegister);
 S.RegisterDelphiFunction(@StartOfTheDay, 'StartOfTheDay', cdRegister);
 S.RegisterDelphiFunction(@EndOfTheDay, 'EndOfTheDay', cdRegister);
 S.RegisterDelphiFunction(@StartOfADay_P, 'StartOfADay', cdRegister);
 S.RegisterDelphiFunction(@EndOfADay_P, 'EndOfADay', cdRegister);
 S.RegisterDelphiFunction(@StartOfADay1_P, 'StartOfADay1', cdRegister);
 S.RegisterDelphiFunction(@EndOfADay1_P, 'EndOfADay1', cdRegister);
 S.RegisterDelphiFunction(@MonthOfTheYear, 'MonthOfTheYear', cdRegister);
 S.RegisterDelphiFunction(@WeekOfTheYear_P, 'WeekOfTheYear', cdRegister);
 S.RegisterDelphiFunction(@WeekOfTheYear1_P, 'WeekOfTheYear1', cdRegister);
 S.RegisterDelphiFunction(@DayOfTheYear, 'DayOfTheYear', cdRegister);
 S.RegisterDelphiFunction(@HourOfTheYear, 'HourOfTheYear', cdRegister);
 S.RegisterDelphiFunction(@MinuteOfTheYear, 'MinuteOfTheYear', cdRegister);
 S.RegisterDelphiFunction(@SecondOfTheYear, 'SecondOfTheYear', cdRegister);
 S.RegisterDelphiFunction(@MilliSecondOfTheYear, 'MilliSecondOfTheYear', cdRegister);
 S.RegisterDelphiFunction(@WeekOfTheMonth_P, 'WeekOfTheMonth', cdRegister);
 S.RegisterDelphiFunction(@WeekOfTheMonth1_P, 'WeekOfTheMonth1', cdRegister);
 S.RegisterDelphiFunction(@DayOfTheMonth, 'DayOfTheMonth', cdRegister);
 S.RegisterDelphiFunction(@HourOfTheMonth, 'HourOfTheMonth', cdRegister);
 S.RegisterDelphiFunction(@MinuteOfTheMonth, 'MinuteOfTheMonth', cdRegister);
 S.RegisterDelphiFunction(@SecondOfTheMonth, 'SecondOfTheMonth', cdRegister);
 S.RegisterDelphiFunction(@MilliSecondOfTheMonth, 'MilliSecondOfTheMonth', cdRegister);
 S.RegisterDelphiFunction(@DayOfTheWeek, 'DayOfTheWeek', cdRegister);
 S.RegisterDelphiFunction(@HourOfTheWeek, 'HourOfTheWeek', cdRegister);
 S.RegisterDelphiFunction(@MinuteOfTheWeek, 'MinuteOfTheWeek', cdRegister);
 S.RegisterDelphiFunction(@SecondOfTheWeek, 'SecondOfTheWeek', cdRegister);
 S.RegisterDelphiFunction(@MilliSecondOfTheWeek, 'MilliSecondOfTheWeek', cdRegister);
 S.RegisterDelphiFunction(@HourOfTheDay, 'HourOfTheDay', cdRegister);
 S.RegisterDelphiFunction(@MinuteOfTheDay, 'MinuteOfTheDay', cdRegister);
 S.RegisterDelphiFunction(@SecondOfTheDay, 'SecondOfTheDay', cdRegister);
 S.RegisterDelphiFunction(@MilliSecondOfTheDay, 'MilliSecondOfTheDay', cdRegister);
 S.RegisterDelphiFunction(@MinuteOfTheHour, 'MinuteOfTheHour', cdRegister);
 S.RegisterDelphiFunction(@SecondOfTheHour, 'SecondOfTheHour', cdRegister);
 S.RegisterDelphiFunction(@MilliSecondOfTheHour, 'MilliSecondOfTheHour', cdRegister);
 S.RegisterDelphiFunction(@SecondOfTheMinute, 'SecondOfTheMinute', cdRegister);
 S.RegisterDelphiFunction(@MilliSecondOfTheMinute, 'MilliSecondOfTheMinute', cdRegister);
 S.RegisterDelphiFunction(@MilliSecondOfTheSecond, 'MilliSecondOfTheSecond', cdRegister);
 S.RegisterDelphiFunction(@WithinPastYears, 'WithinPastYears', cdRegister);
 S.RegisterDelphiFunction(@WithinPastMonths, 'WithinPastMonths', cdRegister);
 S.RegisterDelphiFunction(@WithinPastWeeks, 'WithinPastWeeks', cdRegister);
 S.RegisterDelphiFunction(@WithinPastDays, 'WithinPastDays', cdRegister);
 S.RegisterDelphiFunction(@WithinPastHours, 'WithinPastHours', cdRegister);
 S.RegisterDelphiFunction(@WithinPastMinutes, 'WithinPastMinutes', cdRegister);
 S.RegisterDelphiFunction(@WithinPastSeconds, 'WithinPastSeconds', cdRegister);
 S.RegisterDelphiFunction(@WithinPastMilliSeconds, 'WithinPastMilliSeconds', cdRegister);
 S.RegisterDelphiFunction(@YearsBetween, 'YearsBetween', cdRegister);
 S.RegisterDelphiFunction(@MonthsBetween, 'MonthsBetween', cdRegister);
 S.RegisterDelphiFunction(@WeeksBetween, 'WeeksBetween', cdRegister);
 S.RegisterDelphiFunction(@DaysBetween, 'DaysBetween', cdRegister);
 S.RegisterDelphiFunction(@HoursBetween, 'HoursBetween', cdRegister);
 S.RegisterDelphiFunction(@MinutesBetween, 'MinutesBetween', cdRegister);
 S.RegisterDelphiFunction(@SecondsBetween, 'SecondsBetween', cdRegister);
 S.RegisterDelphiFunction(@MilliSecondsBetween, 'MilliSecondsBetween', cdRegister);
 S.RegisterDelphiFunction(@YearSpan, 'YearSpan', cdRegister);
 S.RegisterDelphiFunction(@MonthSpan, 'MonthSpan', cdRegister);
 S.RegisterDelphiFunction(@WeekSpan, 'WeekSpan', cdRegister);
 S.RegisterDelphiFunction(@DaySpan, 'DaySpan', cdRegister);
 S.RegisterDelphiFunction(@HourSpan, 'HourSpan', cdRegister);
 S.RegisterDelphiFunction(@MinuteSpan, 'MinuteSpan', cdRegister);
 S.RegisterDelphiFunction(@SecondSpan, 'SecondSpan', cdRegister);
 S.RegisterDelphiFunction(@MilliSecondSpan, 'MilliSecondSpan', cdRegister);
 S.RegisterDelphiFunction(@IncYear, 'IncYear', cdRegister);
 S.RegisterDelphiFunction(@IncWeek, 'IncWeek', cdRegister);
 S.RegisterDelphiFunction(@IncDay, 'IncDay', cdRegister);
 S.RegisterDelphiFunction(@IncHour, 'IncHour', cdRegister);
 S.RegisterDelphiFunction(@IncMinute, 'IncMinute', cdRegister);
 S.RegisterDelphiFunction(@IncSecond, 'IncSecond', cdRegister);
 S.RegisterDelphiFunction(@IncMilliSecond, 'IncMilliSecond', cdRegister);
 S.RegisterDelphiFunction(@EncodeDateTime, 'EncodeDateTime', cdRegister);
 S.RegisterDelphiFunction(@DecodeDateTime, 'DecodeDateTime', cdRegister);
 S.RegisterDelphiFunction(@EncodeDateWeek, 'EncodeDateWeek', cdRegister);
 S.RegisterDelphiFunction(@DecodeDateWeek, 'DecodeDateWeek', cdRegister);
 S.RegisterDelphiFunction(@EncodeDateDay, 'EncodeDateDay', cdRegister);
 S.RegisterDelphiFunction(@DecodeDateDay, 'DecodeDateDay', cdRegister);
 S.RegisterDelphiFunction(@EncodeDateMonthWeek, 'EncodeDateMonthWeek', cdRegister);
 S.RegisterDelphiFunction(@DecodeDateMonthWeek, 'DecodeDateMonthWeek', cdRegister);
 S.RegisterDelphiFunction(@TryEncodeDateTime, 'TryEncodeDateTime', cdRegister);
 S.RegisterDelphiFunction(@TryEncodeDateWeek, 'TryEncodeDateWeek', cdRegister);
 S.RegisterDelphiFunction(@TryEncodeDateDay, 'TryEncodeDateDay', cdRegister);
 S.RegisterDelphiFunction(@TryEncodeDateMonthWeek, 'TryEncodeDateMonthWeek', cdRegister);
 S.RegisterDelphiFunction(@RecodeYear, 'RecodeYear', cdRegister);
 S.RegisterDelphiFunction(@RecodeMonth, 'RecodeMonth', cdRegister);
 S.RegisterDelphiFunction(@RecodeDay, 'RecodeDay', cdRegister);
 S.RegisterDelphiFunction(@RecodeHour, 'RecodeHour', cdRegister);
 S.RegisterDelphiFunction(@RecodeMinute, 'RecodeMinute', cdRegister);
 S.RegisterDelphiFunction(@RecodeSecond, 'RecodeSecond', cdRegister);
 S.RegisterDelphiFunction(@RecodeMilliSecond, 'RecodeMilliSecond', cdRegister);
 S.RegisterDelphiFunction(@RecodeDate, 'RecodeDate', cdRegister);
 S.RegisterDelphiFunction(@RecodeTime, 'RecodeTime', cdRegister);
 S.RegisterDelphiFunction(@RecodeDateTime, 'RecodeDateTime', cdRegister);
 S.RegisterDelphiFunction(@TryRecodeDateTime, 'TryRecodeDateTime', cdRegister);
 S.RegisterDelphiFunction(@CompareDateTime, 'CompareDateTime', cdRegister);
 S.RegisterDelphiFunction(@SameDateTime, 'SameDateTime', cdRegister);
 S.RegisterDelphiFunction(@CompareDate, 'CompareDate', cdRegister);
 S.RegisterDelphiFunction(@SameDate, 'SameDate', cdRegister);
 S.RegisterDelphiFunction(@CompareTime, 'CompareTime', cdRegister);
 S.RegisterDelphiFunction(@SameTime, 'SameTime', cdRegister);
 S.RegisterDelphiFunction(@NthDayOfWeek, 'NthDayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@DecodeDayOfWeekInMonth, 'DecodeDayOfWeekInMonth', cdRegister);
 S.RegisterDelphiFunction(@EncodeDayOfWeekInMonth, 'EncodeDayOfWeekInMonth', cdRegister);
 S.RegisterDelphiFunction(@TryEncodeDayOfWeekInMonth, 'TryEncodeDayOfWeekInMonth', cdRegister);
 S.RegisterDelphiFunction(@InvalidDateTimeError, 'InvalidDateTimeError', cdRegister);
 S.RegisterDelphiFunction(@InvalidDateWeekError, 'InvalidDateWeekError', cdRegister);
 S.RegisterDelphiFunction(@InvalidDateDayError, 'InvalidDateDayError', cdRegister);
 S.RegisterDelphiFunction(@InvalidDateMonthWeekError, 'InvalidDateMonthWeekError', cdRegister);
 S.RegisterDelphiFunction(@InvalidDayOfWeekInMonthError, 'InvalidDayOfWeekInMonthError', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToJulianDate, 'DateTimeToJulianDate', cdRegister);
 S.RegisterDelphiFunction(@JulianDateToDateTime, 'JulianDateToDateTime', cdRegister);
 S.RegisterDelphiFunction(@TryJulianDateToDateTime, 'TryJulianDateToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToModifiedJulianDate, 'DateTimeToModifiedJulianDate', cdRegister);
 S.RegisterDelphiFunction(@ModifiedJulianDateToDateTime, 'ModifiedJulianDateToDateTime', cdRegister);
 S.RegisterDelphiFunction(@TryModifiedJulianDateToDateTime, 'TryModifiedJulianDateToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToUnix, 'DateTimeToUnix', cdRegister);
 S.RegisterDelphiFunction(@UnixToDateTime, 'UnixToDateTime', cdRegister);
end;

 
 
{ TPSImport_DateUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DateUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DateUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DateUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_DateUtils(ri);
  RIRegister_DateUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
