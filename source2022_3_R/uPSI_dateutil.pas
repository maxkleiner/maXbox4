unit uPSI_dateutil;
{
optima  codere
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
  TPSImport_dateutil = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_dateutil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_dateutil_Routines(S: TPSExec);

procedure Register;

implementation


uses
   {use32
  ,tpautils
  ,dpautils
  ,fpautils    }
  dateutils
  ,dateutilreal
  ;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_dateutil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_dateutil(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TDatetimeReal', 'real');
  CL.AddTypeS('TDateInfo', 'record DateTime : TDateTime; UTC : boolean; end');
  //CL.AddTypeS('float', 'real');
   CL.AddTypeS('big_integer_t', 'int64');

 CL.AddConstantN('DayMondayR','LongInt').SetInt( 1);
 CL.AddConstantN('DayTuesdayR','LongInt').SetInt( 2);
 CL.AddConstantN('DayWednesdayR','LongInt').SetInt( 3);
 CL.AddConstantN('DayThursdayR','LongInt').SetInt( 4);
 CL.AddConstantN('DayFridayR','LongInt').SetInt( 5);
 CL.AddConstantN('DaySaturdayR','LongInt').SetInt( 6);
 CL.AddConstantN('DaySundayR','LongInt').SetInt( 7);
 CL.AddDelphiFunction('Function CurrentYearreal : word');
 CL.AddDelphiFunction('Function Datereal : TDatetimeReal');
 CL.AddDelphiFunction('Function DateOfreal( const AValue : TDatetimeReal) : TDatetimeReal');
 CL.AddDelphiFunction('Function DateTimeToStrreal( DateTime : TDatetimeReal) : string');
 CL.AddDelphiFunction('Function DateToStrreal( date : TDatetimeReal) : string');
 CL.AddDelphiFunction('Function DayOfreal( const AValue : TDatetimeReal) : Word');
 CL.AddDelphiFunction('Function DaysBetweenreal( const ANow, AThen : TDatetimeReal) : integer');
 CL.AddDelphiFunction('Procedure DecodeDatereal( Date : TDatetimeReal; var Year, Month, Day : Word)');
 CL.AddDelphiFunction('Procedure DecodeDateTimereal( const AValue : TDatetimeReal; var Year, Month, Day, Hour, Minute, Second, MilliSecond : Word)');
 CL.AddDelphiFunction('Procedure DecodeTimereal( Time : TDatetimeReal; var Hour, Min, Sec, MSec : Word)');
 CL.AddDelphiFunction('Function HourOfreal( const AValue : TDatetimeReal) : Word');
 CL.AddDelphiFunction('Function IncDayreal( const AValue : TDatetimeReal; const ANumberOfDays : Integer) : TDatetimeReal');
 CL.AddDelphiFunction('Function IncHourreal( const AValue : TDatetimeReal; const ANumberOfHours : longint) : TDatetimeReal');
 CL.AddDelphiFunction('Function IncMilliSecondreal( const AValue : TDatetimeReal; const ANumberOfMilliSeconds : big_integer_t) : TDatetimeReal');
 CL.AddDelphiFunction('Function IncMinutereal( const AValue : TDatetimeReal; const ANumberOfMinutes : big_integer_t) : TDatetimeReal');
 CL.AddDelphiFunction('Function IncSecondreal( const AValue : TDatetimeReal; const ANumberOfSeconds : big_integer_t) : TDatetimeReal');
 CL.AddDelphiFunction('Function IncWeekreal( const AValue : TDatetimeReal; const ANumberOfWeeks : Integer) : TDatetimeReal');
 CL.AddDelphiFunction('Function IsPMreal( const AValue : TDatetimeReal) : Boolean');
 CL.AddDelphiFunction('Function IsValidDatereal( const AYear, AMonth, ADay : Word) : Boolean');
 CL.AddDelphiFunction('Function IsValidDateTimereal( const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word) : Boolean');
 CL.AddDelphiFunction('Function IsValidTimereal( const AHour, AMinute, ASecond, AMilliSecond : Word) : Boolean');
 CL.AddDelphiFunction('Function MinuteOfreal( const AValue : TDatetimeReal) : Word');
 CL.AddDelphiFunction('Function MonthOfreal( const AValue : TDatetimeReal) : Word');
 CL.AddDelphiFunction('Function Nowreal : TDatetimeReal');
 CL.AddDelphiFunction('Function SameDatereal( const A, B : TDatetimeReal) : Boolean');
 CL.AddDelphiFunction('Function SameDateTimereal( const A, B : TDatetimeReal) : Boolean');
 CL.AddDelphiFunction('Function SameTimereal( const A, B : TDatetimeReal) : Boolean');
 CL.AddDelphiFunction('Function SecondOfreal( const AValue : TDatetimeReal) : Word');
 CL.AddDelphiFunction('Function Timereal : TDatetimeReal');
 CL.AddDelphiFunction('Function GetTimereal : TDatetimeReal');
 CL.AddDelphiFunction('Function TimeOfreal( const AValue : TDatetimeReal) : TDatetimeReal');
 CL.AddDelphiFunction('Function TimeToStrreal( Time : TDatetimeReal) : string');
 CL.AddDelphiFunction('Function Todayreal : TDatetimeReal');
 CL.AddDelphiFunction('Function TryEncodeDatereal( Year, Month, Day : Word; var Date : TDatetimeReal) : Boolean');
 CL.AddDelphiFunction('Function TryEncodeTimereal( Hour, Min, Sec, MSec : Word; var Time : TDatetimeReal) : Boolean');
 CL.AddDelphiFunction('Function TryEncodeDateTimereal( const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word; var AValue : TDatetimeReal) : Boolean');
 CL.AddDelphiFunction('Function TryStrToDatereal( const S : string; var Value : TDatetimeReal) : Boolean');
 CL.AddDelphiFunction('Function TryStrToDateTimereal( const S : string; var Value : TDatetimeReal) : Boolean');
 CL.AddDelphiFunction('Function TryStrToTimereal( const S : string; var Value : TDatetimeReal) : Boolean');
 CL.AddDelphiFunction('Function YearOfreal( const AValue : TDatetimeReal) : Word');
 CL.AddDelphiFunction('Function parsetimeISO( timestr : string; var hourval, minval, secval : word; var offsethourval, offsetminval : integer; var UTC : boolean) : boolean');
 CL.AddDelphiFunction('Function parsedateISO( datestr : string; var yearval, monthval, dayval : word) : boolean');
 CL.AddDelphiFunction('Function datetojd( year, month, day, hour, minute, second, millisecond : word) : float');
 CL.AddDelphiFunction('Procedure jdtodate( jday : float; var year, month, day, hour, minute, second, msec : word)');
 CL.AddDelphiFunction('Function converttoisotime( timestr : string) : string');
 CL.AddDelphiFunction('Function AdobeDateToISODate( s : string) : string');
 CL.AddDelphiFunction('Function RFC822ToISODateTime( s : string) : string');
 CL.AddDelphiFunction('Procedure getdatedos( var year, month, mday, wday : word)');
 CL.AddDelphiFunction('Procedure gettimedos( var hour, minute, second, sec100 : word)');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_dateutil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CurrentYear, 'CurrentYearreal', cdRegister);
 S.RegisterDelphiFunction(@Date, 'Datereal', cdRegister);
 S.RegisterDelphiFunction(@DateOf, 'DateOfreal', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToStr, 'DateTimeToStrreal', cdRegister);
 S.RegisterDelphiFunction(@DateToStr, 'DateToStrreal', cdRegister);
 S.RegisterDelphiFunction(@DayOf, 'DayOfreal', cdRegister);
 S.RegisterDelphiFunction(@DaysBetween, 'DaysBetweenreal', cdRegister);
 S.RegisterDelphiFunction(@DecodeDate, 'DecodeDatereal', cdRegister);
 S.RegisterDelphiFunction(@DecodeDateTime, 'DecodeDateTimereal', cdRegister);
 S.RegisterDelphiFunction(@DecodeTime, 'DecodeTimereal', cdRegister);
 S.RegisterDelphiFunction(@HourOf, 'HourOfreal', cdRegister);
 S.RegisterDelphiFunction(@IncDay, 'IncDayreal', cdRegister);
 S.RegisterDelphiFunction(@IncHour, 'IncHourreal', cdRegister);
 S.RegisterDelphiFunction(@IncMilliSecond, 'IncMilliSecondreal', cdRegister);
 S.RegisterDelphiFunction(@IncMinute, 'IncMinutereal', cdRegister);
 S.RegisterDelphiFunction(@IncSecond, 'IncSecondreal', cdRegister);
 S.RegisterDelphiFunction(@IncWeek, 'IncWeekreal', cdRegister);
 S.RegisterDelphiFunction(@IsPM, 'IsPMreal', cdRegister);
 S.RegisterDelphiFunction(@IsValidDate, 'IsValidDatereal', cdRegister);
 S.RegisterDelphiFunction(@IsValidDateTime, 'IsValidDateTimereal', cdRegister);
 S.RegisterDelphiFunction(@IsValidTime, 'IsValidTimereal', cdRegister);
 S.RegisterDelphiFunction(@MinuteOf, 'MinuteOfreal', cdRegister);
 S.RegisterDelphiFunction(@MonthOf, 'MonthOfreal', cdRegister);
 S.RegisterDelphiFunction(@Now, 'Nowreal', cdRegister);
 S.RegisterDelphiFunction(@SameDate, 'SameDatereal', cdRegister);
 S.RegisterDelphiFunction(@SameDateTime, 'SameDateTimereal', cdRegister);
 S.RegisterDelphiFunction(@SameTime, 'SameTimereal', cdRegister);
 S.RegisterDelphiFunction(@SecondOf, 'SecondOfreal', cdRegister);
 S.RegisterDelphiFunction(@Time, 'Timereal', cdRegister);
 S.RegisterDelphiFunction(@GetTime, 'GetTimereal', cdRegister);
 S.RegisterDelphiFunction(@TimeOf, 'TimeOfreal', cdRegister);
 S.RegisterDelphiFunction(@TimeToStr, 'TimeToStrreal', cdRegister);
 S.RegisterDelphiFunction(@Today, 'Todayreal', cdRegister);
 S.RegisterDelphiFunction(@TryEncodeDate, 'TryEncodeDatereal', cdRegister);
 S.RegisterDelphiFunction(@TryEncodeTime, 'TryEncodeTimereal', cdRegister);
 S.RegisterDelphiFunction(@TryEncodeDateTime, 'TryEncodeDateTimereal', cdRegister);
 S.RegisterDelphiFunction(@TryStrToDate, 'TryStrToDatereal', cdRegister);
 S.RegisterDelphiFunction(@TryStrToDateTime, 'TryStrToDateTimereal', cdRegister);
 S.RegisterDelphiFunction(@TryStrToTime, 'TryStrToTimereal', cdRegister);
 S.RegisterDelphiFunction(@YearOf, 'YearOfreal', cdRegister);
  S.RegisterDelphiFunction(@parsetimeISO, 'parsetimeISO', cdRegister);
 S.RegisterDelphiFunction(@parsedateISO, 'parsedateISO', cdRegister);
 S.RegisterDelphiFunction(@datetojd, 'datetojd', cdRegister);
 S.RegisterDelphiFunction(@jdtodate, 'jdtodate', cdRegister);
 S.RegisterDelphiFunction(@converttoisotime, 'converttoisotime', cdRegister);
 S.RegisterDelphiFunction(@AdobeDateToISODate, 'AdobeDateToISODate', cdRegister);
 S.RegisterDelphiFunction(@RFC822ToISODateTime, 'RFC822ToISODateTime', cdRegister);
 S.RegisterDelphiFunction(@getdatedos, 'getdatedos', cdRegister);
 S.RegisterDelphiFunction(@gettimedos, 'gettimedos', cdRegister);

end;

 
 
{ TPSImport_dateutil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_dateutil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_dateutil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_dateutil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_dateutil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
