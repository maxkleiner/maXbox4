unit uPSI_JclDateTime;
{
    the grand design or the shorter one
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
  TPSImport_JclDateTime = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclDateTime(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclDateTime_Routines(S: TPSExec);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,Types
  //,Libc
  //,Unix
  ,JclBase
  ,JclResources
  ,JclDateTime
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclDateTime]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclDateTime(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('UnixTimeStart','LongInt').SetInt( 25569);
 CL.AddDelphiFunction('Function JEncodeDate( const Year : Integer; Month, Day : Word) : TDateTime');
 CL.AddDelphiFunction('Procedure JDecodeDate( Date : TDateTime; var Year, Month, Day : Word);');
 CL.AddDelphiFunction('Procedure DecodeDate1( Date : TDateTime; var Year : Integer; var Month, Day : Word);');
 CL.AddDelphiFunction('Procedure DecodeDate2( Date : TDateTime; var Year, Month, Day : Integer);');
 CL.AddDelphiFunction('Function CenturyOfDate( const DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function CenturyBaseYear( const DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DayOfDate( const DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function MonthOfDate( const DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function YearOfDate( const DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function JDayOfTheYear( const DateTime : TDateTime; var Year : Integer) : Integer;');
 CL.AddDelphiFunction('Function DayOfTheYear1( const DateTime : TDateTime) : Integer;');
 CL.AddDelphiFunction('Function DayOfTheYearToDateTime( const Year, Day : Integer) : TDateTime');
 CL.AddDelphiFunction('Function HourOfTime( const DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function MinuteOfTime( const DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function SecondOfTime( const DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function GetISOYearNumberOfDays( const Year : Word) : Word');
 CL.AddDelphiFunction('Function IsISOLongYear( const Year : Word) : Boolean;');
 CL.AddDelphiFunction('Function IsISOLongYear1( const DateTime : TDateTime) : Boolean;');
 CL.AddDelphiFunction('Function ISODayOfWeek( const DateTime : TDateTime) : Word');
 CL.AddDelphiFunction('Function JISOWeekNumber( DateTime : TDateTime; var YearOfWeekNumber, WeekDay : Integer) : Integer;');
 CL.AddDelphiFunction('Function ISOWeekNumber1( DateTime : TDateTime; var YearOfWeekNumber : Integer) : Integer;');
 CL.AddDelphiFunction('Function ISOWeekNumber2( DateTime : TDateTime) : Integer;');
 CL.AddDelphiFunction('Function ISOWeekToDateTime( const Year, Week, Day : Integer) : TDateTime');
 CL.AddDelphiFunction('Function JIsLeapYear( const Year : Integer) : Boolean;');
 CL.AddDelphiFunction('Function IsLeapYear1( const DateTime : TDateTime) : Boolean;');
 CL.AddDelphiFunction('Function JDaysInMonth( const DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function Make4DigitYear( Year, Pivot : Integer) : Integer');
 CL.AddDelphiFunction('Function JMakeYear4Digit( Year, WindowsillYear : Integer) : Integer');
 CL.AddDelphiFunction('Function JEasterSunday( const Year : Integer) : TDateTime');
 CL.AddDelphiFunction('Function JFormatDateTime( Form : string; DateTime : TDateTime) : string');
 CL.AddDelphiFunction('Function FATDatesEqual( const FileTime1, FileTime2 : Int64) : Boolean;');
 CL.AddDelphiFunction('Function FATDatesEqual1( const FileTime1, FileTime2 : TFileTime) : Boolean;');
  CL.AddTypeS('TDosDateTime', 'Integer');
 CL.AddDelphiFunction('Function HoursToMSecs( Hours : Integer) : Integer');
 CL.AddDelphiFunction('Function MinutesToMSecs( Minutes : Integer) : Integer');
 CL.AddDelphiFunction('Function SecondsToMSecs( Seconds : Integer) : Integer');
 CL.AddDelphiFunction('Function TimeOfDateTimeToSeconds( DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function TimeOfDateTimeToMSecs( DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DateTimeToLocalDateTime( DateTime : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function LocalDateTimeToDateTime( DateTime : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToDosDateTime( const DateTime : TDateTime) : TDosDateTime');
 CL.AddDelphiFunction('Function JDateTimeToFileTime( DateTime : TDateTime) : TFileTime');
 CL.AddDelphiFunction('Function JDateTimeToSystemTime( DateTime : TDateTime) : TSystemTime;');
 CL.AddDelphiFunction('Procedure DateTimeToSystemTime1( DateTime : TDateTime; var SysTime : TSystemTime);');
 CL.AddDelphiFunction('Function LocalDateTimeToFileTime( DateTime : TDateTime) : FileTime');
 CL.AddDelphiFunction('Function DosDateTimeToDateTime( const DosTime : TDosDateTime) : TDateTime');
 CL.AddDelphiFunction('Function JDosDateTimeToFileTime( DosTime : TDosDateTime) : TFileTime;');
 CL.AddDelphiFunction('Procedure DosDateTimeToFileTime1( DTH, DTL : Word; FT : TFileTime);');
 CL.AddDelphiFunction('Function DosDateTimeToSystemTime( const DosTime : TDosDateTime) : TSystemTime');
 CL.AddDelphiFunction('Function DosDateTimeToStr( DateTime : Integer) : string');
 CL.AddDelphiFunction('Function JFileTimeToDateTime( const FileTime : TFileTime) : TDateTime');
 CL.AddDelphiFunction('Function FileTimeToLocalDateTime( const FileTime : TFileTime) : TDateTime');
 CL.AddDelphiFunction('Function JFileTimeToDosDateTime( const FileTime : TFileTime) : TDosDateTime;');
 CL.AddDelphiFunction('Procedure FileTimeToDosDateTime1( const FileTime : TFileTime; var Date, Time : Word);');
 CL.AddDelphiFunction('Function JFileTimeToSystemTime( const FileTime : TFileTime) : TSystemTime;');
 CL.AddDelphiFunction('Procedure FileTimeToSystemTime1( const FileTime : TFileTime; var ST : TSystemTime);');
 CL.AddDelphiFunction('Function FileTimeToStr( const FileTime : TFileTime) : string');
 CL.AddDelphiFunction('Function SystemTimeToDosDateTime( const SystemTime : TSystemTime) : TDosDateTime');
 CL.AddDelphiFunction('Function JSystemTimeToFileTime( const SystemTime : TSystemTime) : TFileTime;');
 CL.AddDelphiFunction('Procedure SystemTimeToFileTime1( const SystemTime : TSystemTime; FTime : TFileTime);');
 CL.AddDelphiFunction('Function SystemTimeToStr( const SystemTime : TSystemTime) : string');
 CL.AddDelphiFunction('Function CreationDateTimeOfFile( const Sr : TSearchRec) : TDateTime');
 CL.AddDelphiFunction('Function LastAccessDateTimeOfFile( const Sr : TSearchRec) : TDateTime');
 CL.AddDelphiFunction('Function LastWriteDateTimeOfFile( const Sr : TSearchRec) : TDateTime');
  CL.AddTypeS('TJclUnixTime32', 'Longword');
 CL.AddDelphiFunction('Function JDateTimeToUnixTime( DateTime : TDateTime) : TJclUnixTime32');
 CL.AddDelphiFunction('Function JUnixTimeToDateTime( const UnixTime : TJclUnixTime32) : TDateTime');
 CL.AddDelphiFunction('Function FileTimeToUnixTime( const AValue : TFileTime) : TJclUnixTime32');
 CL.AddDelphiFunction('Function UnixTimeToFileTime( const AValue : TJclUnixTime32) : TFileTime');
 CL.AddDelphiFunction('Function JNullStamp : TTimeStamp');
 CL.AddDelphiFunction('Function JCompareTimeStamps( const Stamp1, Stamp2 : TTimeStamp) : Int64');
 CL.AddDelphiFunction('Function JEqualTimeStamps( const Stamp1, Stamp2 : TTimeStamp) : Boolean');
 CL.AddDelphiFunction('Function JIsNullTimeStamp( const Stamp : TTimeStamp) : Boolean');
 CL.AddDelphiFunction('Function TimeStampDOW( const Stamp : TTimeStamp) : Integer');
 CL.AddDelphiFunction('Function FirstWeekDay( const Year, Month : Integer; var DOW : Integer) : Integer;');
 CL.AddDelphiFunction('Function FirstWeekDay1( const Year, Month : Integer) : Integer;');
 CL.AddDelphiFunction('Function LastWeekDay( const Year, Month : Integer; var DOW : Integer) : Integer;');
 CL.AddDelphiFunction('Function LastWeekDay1( const Year, Month : Integer) : Integer;');
 CL.AddDelphiFunction('Function IndexedWeekDay( const Year, Month : Integer; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function FirstWeekendDay( const Year, Month : Integer; var DOW : Integer) : Integer;');
 CL.AddDelphiFunction('Function FirstWeekendDay1( const Year, Month : Integer) : Integer;');
 CL.AddDelphiFunction('Function LastWeekendDay( const Year, Month : Integer; var DOW : Integer) : Integer;');
 CL.AddDelphiFunction('Function LastWeekendDay1( const Year, Month : Integer) : Integer;');
 CL.AddDelphiFunction('Function IndexedWeekendDay( const Year, Month : Integer; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function FirstDayOfWeek( const Year, Month, DayOfWeek : Integer) : Integer');
 CL.AddDelphiFunction('Function LastDayOfWeek( const Year, Month, DayOfWeek : Integer) : Integer');
 CL.AddDelphiFunction('Function IndexedDayOfWeek( const Year, Month, DayOfWeek, Index : Integer) : Integer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclDateTimeError');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function LastWeekendDay1_P( const Year, Month : Integer) : Integer;
Begin Result := JclDateTime.LastWeekendDay(Year, Month); END;

(*----------------------------------------------------------------------------*)
Function LastWeekendDay_P( const Year, Month : Integer; var DOW : Integer) : Integer;
Begin Result := JclDateTime.LastWeekendDay(Year, Month, DOW); END;

(*----------------------------------------------------------------------------*)
Function FirstWeekendDay1_P( const Year, Month : Integer) : Integer;
Begin Result := JclDateTime.FirstWeekendDay(Year, Month); END;

(*----------------------------------------------------------------------------*)
Function FirstWeekendDay_P( const Year, Month : Integer; var DOW : Integer) : Integer;
Begin Result := JclDateTime.FirstWeekendDay(Year, Month, DOW); END;

(*----------------------------------------------------------------------------*)
Function LastWeekDay1_P( const Year, Month : Integer) : Integer;
Begin Result := JclDateTime.LastWeekDay(Year, Month); END;

(*----------------------------------------------------------------------------*)
Function LastWeekDay_P( const Year, Month : Integer; var DOW : Integer) : Integer;
Begin Result := JclDateTime.LastWeekDay(Year, Month, DOW); END;

(*----------------------------------------------------------------------------*)
Function FirstWeekDay1_P( const Year, Month : Integer) : Integer;
Begin Result := JclDateTime.FirstWeekDay(Year, Month); END;

(*----------------------------------------------------------------------------*)
Function FirstWeekDay_P( const Year, Month : Integer; var DOW : Integer) : Integer;
Begin Result := JclDateTime.FirstWeekDay(Year, Month, DOW); END;

(*----------------------------------------------------------------------------*)
Procedure SystemTimeToFileTime1_P( const SystemTime : TSystemTime; FTime : TFileTime);
Begin JclDateTime.SystemTimeToFileTime(SystemTime, FTime); END;

(*----------------------------------------------------------------------------*)
Function SystemTimeToFileTime_P( const SystemTime : TSystemTime) : TFileTime;
Begin Result := JclDateTime.SystemTimeToFileTime(SystemTime); END;

(*----------------------------------------------------------------------------*)
Procedure FileTimeToSystemTime1_P( const FileTime : TFileTime; var ST : TSystemTime);
Begin JclDateTime.FileTimeToSystemTime(FileTime, ST); END;

(*----------------------------------------------------------------------------*)
Function FileTimeToSystemTime_P( const FileTime : TFileTime) : TSystemTime;
Begin Result := JclDateTime.FileTimeToSystemTime(FileTime); END;

(*----------------------------------------------------------------------------*)
Procedure FileTimeToDosDateTime1_P( const FileTime : TFileTime; var Date, Time : Word);
Begin JclDateTime.FileTimeToDosDateTime(FileTime, Date, Time); END;

(*----------------------------------------------------------------------------*)
Function FileTimeToDosDateTime_P( const FileTime : TFileTime) : TDosDateTime;
Begin Result := JclDateTime.FileTimeToDosDateTime(FileTime); END;

(*----------------------------------------------------------------------------*)
Procedure DosDateTimeToFileTime1_P( DTH, DTL : Word; FT : TFileTime);
Begin JclDateTime.DosDateTimeToFileTime(DTH, DTL, FT); END;

(*----------------------------------------------------------------------------*)
Function DosDateTimeToFileTime_P( DosTime : TDosDateTime) : TFileTime;
Begin Result := JclDateTime.DosDateTimeToFileTime(DosTime); END;

(*----------------------------------------------------------------------------*)
Procedure DateTimeToSystemTime1_P( DateTime : TDateTime; var SysTime : TSystemTime);
Begin JclDateTime.DateTimeToSystemTime(DateTime, SysTime); END;

(*----------------------------------------------------------------------------*)
Function DateTimeToSystemTime_P( DateTime : TDateTime) : TSystemTime;
Begin Result := JclDateTime.DateTimeToSystemTime(DateTime); END;

(*----------------------------------------------------------------------------*)
Function FATDatesEqual1_P( const FileTime1, FileTime2 : TFileTime) : Boolean;
Begin Result := JclDateTime.FATDatesEqual(FileTime1, FileTime2); END;

(*----------------------------------------------------------------------------*)
Function FATDatesEqual_P( const FileTime1, FileTime2 : Int64) : Boolean;
Begin Result := JclDateTime.FATDatesEqual(FileTime1, FileTime2); END;

(*----------------------------------------------------------------------------*)
Function IsLeapYear1_P( const DateTime : TDateTime) : Boolean;
Begin Result := JclDateTime.IsLeapYear(DateTime); END;

(*----------------------------------------------------------------------------*)
Function IsLeapYear_P( const Year : Integer) : Boolean;
Begin Result := JclDateTime.IsLeapYear(Year); END;

(*----------------------------------------------------------------------------*)
Function ISOWeekNumber2_P( DateTime : TDateTime) : Integer;
Begin Result := JclDateTime.ISOWeekNumber(DateTime); END;

(*----------------------------------------------------------------------------*)
Function ISOWeekNumber1_P( DateTime : TDateTime; var YearOfWeekNumber : Integer) : Integer;
Begin Result := JclDateTime.ISOWeekNumber(DateTime, YearOfWeekNumber); END;

(*----------------------------------------------------------------------------*)
Function ISOWeekNumber_P( DateTime : TDateTime; var YearOfWeekNumber, WeekDay : Integer) : Integer;
Begin Result := JclDateTime.ISOWeekNumber(DateTime, YearOfWeekNumber, WeekDay); END;

(*----------------------------------------------------------------------------*)
Function IsISOLongYear1_P( const DateTime : TDateTime) : Boolean;
Begin Result := JclDateTime.IsISOLongYear(DateTime); END;

(*----------------------------------------------------------------------------*)
Function IsISOLongYear_P( const Year : Word) : Boolean;
Begin Result := JclDateTime.IsISOLongYear(Year); END;

(*----------------------------------------------------------------------------*)
Function DayOfTheYear1_P( const DateTime : TDateTime) : Integer;
Begin Result := JclDateTime.DayOfTheYear(DateTime); END;

(*----------------------------------------------------------------------------*)
Function DayOfTheYear_P( const DateTime : TDateTime; var Year : Integer) : Integer;
Begin Result := JclDateTime.DayOfTheYear(DateTime, Year); END;

(*----------------------------------------------------------------------------*)
Procedure DecodeDate2_P( Date : TDateTime; var Year, Month, Day : Integer);
Begin JclDateTime.DecodeDate(Date, Year, Month, Day); END;

(*----------------------------------------------------------------------------*)
Procedure DecodeDate1_P( Date : TDateTime; var Year : Integer; var Month, Day : Word);
Begin JclDateTime.DecodeDate(Date, Year, Month, Day); END;

(*----------------------------------------------------------------------------*)
Procedure DecodeDate_P( Date : TDateTime; var Year, Month, Day : Word);
Begin JclDateTime.DecodeDate(Date, Year, Month, Day); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclDateTime_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EncodeDate, 'JEncodeDate', cdRegister);
 S.RegisterDelphiFunction(@DecodeDate, 'JDecodeDate', cdRegister);
 S.RegisterDelphiFunction(@DecodeDate1_P, 'DecodeDate1', cdRegister);
 S.RegisterDelphiFunction(@DecodeDate2_P, 'DecodeDate2', cdRegister);
 S.RegisterDelphiFunction(@CenturyOfDate, 'CenturyOfDate', cdRegister);
 S.RegisterDelphiFunction(@CenturyBaseYear, 'CenturyBaseYear', cdRegister);
 S.RegisterDelphiFunction(@DayOfDate, 'DayOfDate', cdRegister);
 S.RegisterDelphiFunction(@MonthOfDate, 'MonthOfDate', cdRegister);
 S.RegisterDelphiFunction(@YearOfDate, 'YearOfDate', cdRegister);
 S.RegisterDelphiFunction(@DayOfTheYear, 'JDayOfTheYear', cdRegister);
 S.RegisterDelphiFunction(@DayOfTheYear1_P, 'DayOfTheYear1', cdRegister);
 S.RegisterDelphiFunction(@DayOfTheYearToDateTime, 'DayOfTheYearToDateTime', cdRegister);
 S.RegisterDelphiFunction(@HourOfTime, 'HourOfTime', cdRegister);
 S.RegisterDelphiFunction(@MinuteOfTime, 'MinuteOfTime', cdRegister);
 S.RegisterDelphiFunction(@SecondOfTime, 'SecondOfTime', cdRegister);
 S.RegisterDelphiFunction(@GetISOYearNumberOfDays, 'GetISOYearNumberOfDays', cdRegister);
 S.RegisterDelphiFunction(@IsISOLongYear, 'IsISOLongYear', cdRegister);
 S.RegisterDelphiFunction(@IsISOLongYear1_P, 'IsISOLongYear1', cdRegister);
 S.RegisterDelphiFunction(@ISODayOfWeek, 'JISODayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@ISOWeekNumber, 'JISOWeekNumber', cdRegister);
 S.RegisterDelphiFunction(@ISOWeekNumber1_P, 'ISOWeekNumber1', cdRegister);
 S.RegisterDelphiFunction(@ISOWeekNumber2_P, 'ISOWeekNumber2', cdRegister);
 S.RegisterDelphiFunction(@ISOWeekToDateTime, 'ISOWeekToDateTime', cdRegister);
 S.RegisterDelphiFunction(@IsLeapYear, 'JIsLeapYear', cdRegister);
 S.RegisterDelphiFunction(@IsLeapYear1_P, 'IsLeapYear1', cdRegister);
 S.RegisterDelphiFunction(@DaysInMonth, 'JDaysInMonth', cdRegister);
 S.RegisterDelphiFunction(@Make4DigitYear, 'Make4DigitYear', cdRegister);
 S.RegisterDelphiFunction(@MakeYear4Digit, 'MakeYear4Digit', cdRegister);
 S.RegisterDelphiFunction(@EasterSunday, 'JEasterSunday', cdRegister);
 S.RegisterDelphiFunction(@FormatDateTime, 'JFormatDateTime', cdRegister);
 S.RegisterDelphiFunction(@FATDatesEqual, 'FATDatesEqual', cdRegister);
 S.RegisterDelphiFunction(@FATDatesEqual1_P, 'FATDatesEqual1', cdRegister);
 S.RegisterDelphiFunction(@HoursToMSecs, 'HoursToMSecs', cdRegister);
 S.RegisterDelphiFunction(@MinutesToMSecs, 'MinutesToMSecs', cdRegister);
 S.RegisterDelphiFunction(@SecondsToMSecs, 'SecondsToMSecs', cdRegister);
 S.RegisterDelphiFunction(@TimeOfDateTimeToSeconds, 'TimeOfDateTimeToSeconds', cdRegister);
 S.RegisterDelphiFunction(@TimeOfDateTimeToMSecs, 'TimeOfDateTimeToMSecs', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToLocalDateTime, 'DateTimeToLocalDateTime', cdRegister);
 S.RegisterDelphiFunction(@LocalDateTimeToDateTime, 'LocalDateTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToDosDateTime, 'DateTimeToDosDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToFileTime, 'JDateTimeToFileTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToSystemTime, 'JDateTimeToSystemTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToSystemTime1_P, 'DateTimeToSystemTime1', cdRegister);
 S.RegisterDelphiFunction(@LocalDateTimeToFileTime, 'LocalDateTimeToFileTime', cdRegister);
 S.RegisterDelphiFunction(@DosDateTimeToDateTime, 'DosDateTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DosDateTimeToFileTime, 'JDosDateTimeToFileTime', cdRegister);
 S.RegisterDelphiFunction(@DosDateTimeToFileTime1_P, 'DosDateTimeToFileTime1', cdRegister);
 S.RegisterDelphiFunction(@DosDateTimeToSystemTime, 'DosDateTimeToSystemTime', cdRegister);
 S.RegisterDelphiFunction(@DosDateTimeToStr, 'DosDateTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToDateTime, 'JFileTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToLocalDateTime, 'FileTimeToLocalDateTime', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToDosDateTime, 'JFileTimeToDosDateTime', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToDosDateTime1_P, 'FileTimeToDosDateTime1', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToSystemTime, 'JFileTimeToSystemTime', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToSystemTime1_P, 'FileTimeToSystemTime1', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToStr, 'FileTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@SystemTimeToDosDateTime, 'SystemTimeToDosDateTime', cdRegister);
 S.RegisterDelphiFunction(@SystemTimeToFileTime, 'JSystemTimeToFileTime', cdRegister);
 S.RegisterDelphiFunction(@SystemTimeToFileTime1_P, 'SystemTimeToFileTime1', cdRegister);
 S.RegisterDelphiFunction(@SystemTimeToStr, 'SystemTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@CreationDateTimeOfFile, 'CreationDateTimeOfFile', cdRegister);
 S.RegisterDelphiFunction(@LastAccessDateTimeOfFile, 'LastAccessDateTimeOfFile', cdRegister);
 S.RegisterDelphiFunction(@LastWriteDateTimeOfFile, 'LastWriteDateTimeOfFile', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToUnixTime, 'JDateTimeToUnixTime', cdRegister);
 S.RegisterDelphiFunction(@UnixTimeToDateTime, 'JUnixTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToUnixTime, 'FileTimeToUnixTime', cdRegister);
 S.RegisterDelphiFunction(@UnixTimeToFileTime, 'UnixTimeToFileTime', cdRegister);
 S.RegisterDelphiFunction(@NullStamp, 'JNullStamp', cdRegister);
 S.RegisterDelphiFunction(@CompareTimeStamps, 'JCompareTimeStamps', cdRegister);
 S.RegisterDelphiFunction(@EqualTimeStamps, 'JEqualTimeStamps', cdRegister);
 S.RegisterDelphiFunction(@IsNullTimeStamp, 'JIsNullTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@TimeStampDOW, 'TimeStampDOW', cdRegister);
 S.RegisterDelphiFunction(@FirstWeekDay, 'FirstWeekDay', cdRegister);
 S.RegisterDelphiFunction(@FirstWeekDay1_P, 'FirstWeekDay1', cdRegister);
 S.RegisterDelphiFunction(@LastWeekDay, 'LastWeekDay', cdRegister);
 S.RegisterDelphiFunction(@LastWeekDay1_P, 'LastWeekDay1', cdRegister);
 S.RegisterDelphiFunction(@IndexedWeekDay, 'IndexedWeekDay', cdRegister);
 S.RegisterDelphiFunction(@FirstWeekendDay, 'FirstWeekendDay', cdRegister);
 S.RegisterDelphiFunction(@FirstWeekendDay1_P, 'FirstWeekendDay1', cdRegister);
 S.RegisterDelphiFunction(@LastWeekendDay, 'LastWeekendDay', cdRegister);
 S.RegisterDelphiFunction(@LastWeekendDay1_P, 'LastWeekendDay1', cdRegister);
 S.RegisterDelphiFunction(@IndexedWeekendDay, 'IndexedWeekendDay', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfWeek, 'FirstDayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@LastDayOfWeek, 'LastDayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@IndexedDayOfWeek, 'IndexedDayOfWeek', cdRegister);
  //with CL.Add(EJclDateTimeError) do
end;



{ TPSImport_JclDateTime }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclDateTime.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclDateTime(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclDateTime.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclDateTime(ri);
  RIRegister_JclDateTime_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
