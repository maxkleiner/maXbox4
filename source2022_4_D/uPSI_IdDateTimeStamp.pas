unit uPSI_IdDateTimeStamp;
{
   just a base class
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
  TPSImport_IdDateTimeStamp = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdDateTimeStamp(CL: TPSPascalCompiler);
procedure SIRegister_IdDateTimeStamp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdDateTimeStamp(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdDateTimeStamp(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdBaseComponent
  ,SysConst
  ,IdDateTimeStamp
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdDateTimeStamp]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdDateTimeStamp(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdDateTimeStamp') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdDateTimeStamp') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure AddDays( ANumber : Cardinal)');
    RegisterMethod('Procedure AddHours( ANumber : Cardinal)');
    RegisterMethod('Procedure AddMilliseconds( ANumber : Cardinal)');
    RegisterMethod('Procedure AddMinutes( ANumber : Cardinal)');
    RegisterMethod('Procedure AddMonths( ANumber : Cardinal)');
    RegisterMethod('Procedure AddSeconds( ANumber : Cardinal)');
    RegisterMethod('Procedure AddTDateTime( ADateTime : TDateTime)');
    RegisterMethod('Procedure AddTIdDateTimeStamp( AIdDateTime : TIdDateTimeStamp)');
    RegisterMethod('Procedure AddTTimeStamp( ATimeStamp : TTimeStamp)');
    RegisterMethod('Procedure AddWeeks( ANumber : Cardinal)');
    RegisterMethod('Procedure AddYears( ANumber : Cardinal)');
    RegisterMethod('Function GetAsISO8601Calendar : String');
    RegisterMethod('Function GetAsISO8601Ordinal : String');
    RegisterMethod('Function GetAsISO8601Week : String');
    RegisterMethod('Function GetAsRFC822 : String');
    RegisterMethod('Function GetAsTDateTime : TDateTime');
    RegisterMethod('Function GetAsTTimeStamp : TTimeStamp');
    RegisterMethod('Function GetAsTimeOfDay : String');
    RegisterMethod('Function GetBeatOfDay : Integer');
    RegisterMethod('Function GetDaysInYear : Integer');
    RegisterMethod('Function GetDayOfMonth : Integer');
    RegisterMethod('Function GetDayOfWeek : Integer');
    RegisterMethod('Function GetDayOfWeekName : String');
    RegisterMethod('Function GetDayOfWeekShortName : String');
    RegisterMethod('Function GetHourOf12Day : Integer');
    RegisterMethod('Function GetHourOf24Day : Integer');
    RegisterMethod('Function GetIsMorning : Boolean');
    RegisterMethod('Function GetMinuteOfDay : Integer');
    RegisterMethod('Function GetMinuteOfHour : Integer');
    RegisterMethod('Function GetMonthOfYear : Integer');
    RegisterMethod('Function GetMonthName : String');
    RegisterMethod('Function GetMonthShortName : String');
    RegisterMethod('Function GetSecondsInYear : Integer');
    RegisterMethod('Function GetSecondOfMinute : Integer');
    RegisterMethod('Function GetTimeZoneAsString : String');
    RegisterMethod('Function GetTimeZoneHour : Integer');
    RegisterMethod('Function GetTimeZoneMinutes : Integer');
    RegisterMethod('Function GetWeekOfYear : Integer');
    RegisterMethod('Procedure SetFromDOSDateTime( ADate, ATime : Word)');
    RegisterMethod('Procedure SetFromISO8601( AString : String)');
    RegisterMethod('Procedure SetFromRFC822( AString : String)');
    RegisterMethod('Procedure SetFromTDateTime( ADateTime : TDateTime)');
    RegisterMethod('Procedure SetFromTTimeStamp( ATimeStamp : TTimeStamp)');
    RegisterMethod('Procedure SetDay( ANumber : Integer)');
    RegisterMethod('Procedure SetMillisecond( ANumber : Integer)');
    RegisterMethod('Procedure SetSecond( ANumber : Integer)');
    RegisterMethod('Procedure SetTimeZone( const Value : Integer)');
    RegisterMethod('Procedure SetYear( ANumber : Integer)');
    RegisterMethod('Procedure SubtractDays( ANumber : Cardinal)');
    RegisterMethod('Procedure SubtractHours( ANumber : Cardinal)');
    RegisterMethod('Procedure SubtractMilliseconds( ANumber : Cardinal)');
    RegisterMethod('Procedure SubtractMinutes( ANumber : Cardinal)');
    RegisterMethod('Procedure SubtractMonths( ANumber : Cardinal)');
    RegisterMethod('Procedure SubtractSeconds( ANumber : Cardinal)');
    RegisterMethod('Procedure SubtractTDateTime( ADateTime : TDateTime)');
    RegisterMethod('Procedure SubtractTIdDateTimeStamp( AIdDateTime : TIdDateTimeStamp)');
    RegisterMethod('Procedure SubtractTTimeStamp( ATimeStamp : TTimeStamp)');
    RegisterMethod('Procedure SubtractWeeks( ANumber : Cardinal)');
    RegisterMethod('Procedure SubtractYears( ANumber : Cardinal)');
    RegisterMethod('Procedure Zero');
    RegisterMethod('Procedure ZeroDate');
    RegisterMethod('Procedure ZeroTime');
    RegisterProperty('AsISO8601Calendar', 'String', iptr);
    RegisterProperty('AsISO8601Ordinal', 'String', iptr);
    RegisterProperty('AsISO8601Week', 'String', iptr);
    RegisterProperty('AsRFC822', 'String', iptr);
    RegisterProperty('AsTDateTime', 'TDateTime', iptr);
    RegisterProperty('AsTTimeStamp', 'TTimeStamp', iptr);
    RegisterProperty('AsTimeOfDay', 'String', iptr);
    RegisterProperty('BeatOfDay', 'Integer', iptr);
    RegisterProperty('Day', 'Integer', iptrw);
    RegisterProperty('DaysInYear', 'Integer', iptr);
    RegisterProperty('DayOfMonth', 'Integer', iptr);
    RegisterProperty('DayOfWeek', 'Integer', iptr);
    RegisterProperty('DayOfWeekName', 'String', iptr);
    RegisterProperty('DayOfWeekShortName', 'String', iptr);
    RegisterProperty('HourOf12Day', 'Integer', iptr);
    RegisterProperty('HourOf24Day', 'Integer', iptr);
    RegisterProperty('IsLeapYear', 'Boolean', iptr);
    RegisterProperty('IsMorning', 'Boolean', iptr);
    RegisterProperty('Millisecond', 'Integer', iptrw);
    RegisterProperty('MinuteOfDay', 'Integer', iptr);
    RegisterProperty('MinuteOfHour', 'Integer', iptr);
    RegisterProperty('MonthOfYear', 'Integer', iptr);
    RegisterProperty('MonthName', 'String', iptr);
    RegisterProperty('MonthShortName', 'String', iptr);
    RegisterProperty('Second', 'Integer', iptrw);
    RegisterProperty('SecondsInYear', 'Integer', iptr);
    RegisterProperty('SecondOfMinute', 'Integer', iptr);
    RegisterProperty('TimeZone', 'Integer', iptrw);
    RegisterProperty('TimeZoneHour', 'Integer', iptr);
    RegisterProperty('TimeZoneMinutes', 'Integer', iptr);
    RegisterProperty('TimeZoneAsString', 'String', iptr);
    RegisterProperty('Year', 'Integer', iptrw);
    RegisterProperty('WeekOfYear', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdDateTimeStamp(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IdMilliSecondsInSecond','LongInt').SetInt( 1000);
 CL.AddConstantN('IdSecondsInMinute','LongInt').SetInt( 60);
 CL.AddConstantN('IdMinutesInHour','LongInt').SetInt( 60);
 CL.AddConstantN('IdHoursInDay','LongInt').SetInt( 24);
 CL.AddConstantN('IdDaysInWeek','LongInt').SetInt( 7);
 CL.AddConstantN('IdDaysInYear','LongInt').SetInt( 365);
 CL.AddConstantN('IdDaysInLeapYear','LongInt').SetInt( 366);
 CL.AddConstantN('IdYearsInShortLeapYearCycle','LongInt').SetInt( 4);
 //CL.AddConstantN('IdDaysInFourYears','').SetString( IdDaysInShortLeapYearCycle);
 CL.AddConstantN('IdYearsInCentury','LongInt').SetInt( 100);
 CL.AddConstantN('IdDaysInLeapCentury','LongInt').SetInt( IdDaysInCentury + 1);
 CL.AddConstantN('IdYearsInLeapYearCycle','LongInt').SetInt( 400);
 CL.AddConstantN('IdDaysInLeapYearCycle','LongInt').SetInt( IdDaysInCentury * 4 + 1);
 CL.AddConstantN('IdMonthsInYear','LongInt').SetInt( 12);
 CL.AddConstantN('IdBeatsInDay','LongInt').SetInt( 1000);
 CL.AddConstantN('IdHoursInHalfDay','LongInt').SetInt( IdHoursInDay div 2);
 CL.AddConstantN('TZ_NZDT','LongInt').SetInt( 13);
 CL.AddConstantN('TZ_IDLE','LongInt').SetInt( 12);
 CL.AddConstantN('TZ_NZST','longint').Setint(12);
 CL.AddConstantN('TZ_NZT','longint').Setint(12);
 CL.AddConstantN('TZ_EADT','LongInt').SetInt( 11);
 CL.AddConstantN('TZ_GST','LongInt').SetInt( 10);
 CL.AddConstantN('TZ_JST','LongInt').SetInt( 9);
 CL.AddConstantN('TZ_CCT','LongInt').SetInt( 8);
 CL.AddConstantN('TZ_WADT','longint').Setint(8);
 CL.AddConstantN('TZ_WAST','LongInt').SetInt( 7);
 CL.AddConstantN('TZ_ZP6','LongInt').SetInt( 6);
 CL.AddConstantN('TZ_ZP5','LongInt').SetInt( 5);
 CL.AddConstantN('TZ_ZP4','LongInt').SetInt( 4);
 CL.AddConstantN('TZ_BT','LongInt').SetInt( 3);
 CL.AddConstantN('TZ_EET','LongInt').SetInt( 2);
 CL.AddConstantN('TZ_MEST','longint').Setint(2);
 CL.AddConstantN('TZ_MESZ','longint').Setint(2);
 CL.AddConstantN('TZ_SST','longint').Setint(2);
 CL.AddConstantN('TZ_FST','longint').Setint(2);
 CL.AddConstantN('TZ_CET','LongInt').SetInt(1);
 CL.AddConstantN('TZ_FWT','longint').Setint(1);
 CL.AddConstantN('TZ_MET','longint').Setint(1);
 CL.AddConstantN('TZ_MEWT','longint').Setint(1);
 CL.AddConstantN('TZ_SWT','longint').Setint(1);
 CL.AddConstantN('TZ_GMT','LongInt').SetInt( 0);
 CL.AddConstantN('TZ_UT','LongInt').SetInt(0);
 CL.AddConstantN('TZ_UTC','LongInt').setInt(0);
 CL.AddConstantN('TZ_WET','LongInt').setInt(0);
 CL.AddConstantN('TZ_WAT','LongInt').SetInt( - 1);
 CL.AddConstantN('TZ_BST','LongInt').setInt(-1);
 CL.AddConstantN('TZ_AT','LongInt').SetInt( - 2);
 CL.AddConstantN('TZ_ADT','LongInt').SetInt( - 3);
 CL.AddConstantN('TZ_AST','LongInt').SetInt( - 4);
 CL.AddConstantN('TZ_EDT','LongInt').setInt(-4);
 CL.AddConstantN('TZ_EST','LongInt').SetInt( - 5);
 CL.AddConstantN('TZ_CDT','LongInt').setInt(-5);
 CL.AddConstantN('TZ_CST','LongInt').SetInt( - 6);
 CL.AddConstantN('TZ_MDT','LongInt').setInt(-6);
 CL.AddConstantN('TZ_MST','LongInt').SetInt( - 7);
 CL.AddConstantN('TZ_PDT','LongInt').setInt(-7);
 CL.AddConstantN('TZ_PST','LongInt').SetInt( - 8);
 CL.AddConstantN('TZ_YDT','LongInt').setInt(-8);
 CL.AddConstantN('TZ_YST','LongInt').SetInt( - 9);
 CL.AddConstantN('TZ_HDT','LongInt').setInt(-9);
 CL.AddConstantN('TZ_AHST','LongInt').SetInt( - 10);
 CL.AddConstantN('TZ_CAT','LongInt').setInt(-10);
 CL.AddConstantN('TZ_HST','LongInt').setInt(-10);
 CL.AddConstantN('TZ_EAST','LongInt').setInt(-10);
 CL.AddConstantN('TZ_NT','LongInt').SetInt( - 11);
 CL.AddConstantN('TZ_IDLW','LongInt').SetInt( - 12);
 CL.AddConstantN('TZM_A','LongInt').setInt( TZ_WAT);
 CL.AddConstantN('TZM_Alpha','LongInt').setInt( TZM_A);
 CL.AddConstantN('TZM_B','LongInt').setInt( TZ_AT);
 CL.AddConstantN('TZM_Bravo','LongInt').setInt( TZM_B);
 CL.AddConstantN('TZM_C','LongInt').setInt( TZ_ADT);
 CL.AddConstantN('TZM_Charlie','LongInt').setInt( TZM_C);
 CL.AddConstantN('TZM_D','LongInt').setInt( TZ_AST);
 CL.AddConstantN('TZM_Delta','LongInt').setInt( TZM_D);
 CL.AddConstantN('TZM_E','LongInt').setInt( TZ_EST);
 CL.AddConstantN('TZM_Echo','LongInt').setInt( TZM_E);
 CL.AddConstantN('TZM_F','LongInt').setInt( TZ_CST);
 CL.AddConstantN('TZM_Foxtrot','LongInt').setInt( TZM_F);
 CL.AddConstantN('TZM_G','LongInt').setInt( TZ_MST);
 CL.AddConstantN('TZM_Golf','LongInt').setInt( TZM_G);
 CL.AddConstantN('TZM_H','LongInt').setInt( TZ_PST);
 CL.AddConstantN('TZM_Hotel','LongInt').setInt( TZM_H);
 CL.AddConstantN('TZM_J','LongInt').setInt( TZ_YST);
 CL.AddConstantN('TZM_Juliet','LongInt').setInt( TZM_J);
 CL.AddConstantN('TZM_K','LongInt').setInt( TZ_AHST);
 CL.AddConstantN('TZM_Kilo','LongInt').setInt( TZM_K);
 CL.AddConstantN('TZM_L','LongInt').setInt( TZ_NT);
 CL.AddConstantN('TZM_Lima','LongInt').setInt( TZM_L);
 CL.AddConstantN('TZM_M','LongInt').setInt( TZ_IDLW);
 CL.AddConstantN('TZM_Mike','LongInt').setInt( TZM_M);
 CL.AddConstantN('TZM_N','LongInt').setInt( TZ_CET);
 CL.AddConstantN('TZM_November','LongInt').setInt( TZM_N);
 CL.AddConstantN('TZM_O','LongInt').setInt( TZ_EET);
 CL.AddConstantN('TZM_Oscar','LongInt').setInt( TZM_O);
 CL.AddConstantN('TZM_P','LongInt').setInt( TZ_BT);
 CL.AddConstantN('TZM_Papa','LongInt').setInt( TZM_P);
 CL.AddConstantN('TZM_Q','LongInt').setInt( TZ_ZP4);
 CL.AddConstantN('TZM_Quebec','LongInt').setInt( TZM_Q);
 CL.AddConstantN('TZM_R','LongInt').setInt( TZ_ZP5);
 CL.AddConstantN('TZM_Romeo','LongInt').setInt( TZM_R);
 CL.AddConstantN('TZM_S','LongInt').setInt( TZ_ZP6);
 CL.AddConstantN('TZM_Sierra','LongInt').setInt( TZM_S);
 CL.AddConstantN('TZM_T','LongInt').setInt( TZ_WAST);
 CL.AddConstantN('TZM_Tango','LongInt').setInt( TZM_T);
 CL.AddConstantN('TZM_U','LongInt').setInt( TZ_CCT);
 CL.AddConstantN('TZM_Uniform','LongInt').setInt( TZM_U);
 CL.AddConstantN('TZM_V','LongInt').setInt( TZ_JST);
 CL.AddConstantN('TZM_Victor','LongInt').setInt( TZM_V);
 CL.AddConstantN('TZM_W','LongInt').setInt( TZ_GST);
 CL.AddConstantN('TZM_Whiskey','LongInt').setInt( TZM_W);
 CL.AddConstantN('TZM_X','LongInt').setInt( TZ_NT);
 CL.AddConstantN('TZM_XRay','LongInt').setInt( TZM_X);
 CL.AddConstantN('TZM_Y','LongInt').setInt( TZ_IDLE);
 CL.AddConstantN('TZM_Yankee','LongInt').setInt( TZM_Y);
 CL.AddConstantN('TZM_Z','LongInt').setInt( TZ_GMT);
 CL.AddConstantN('TZM_Zulu','LongInt').setInt( TZM_Z);
  CL.AddTypeS('TDays', '( TDaySun, TDayMon, TDayTue, TDayWed, TDayThu, TDayFri, TDaySat )');
  CL.AddTypeS('TMonths', '( TMthJan, TMthFeb, TMthMar, TMthApr, TMthMay, TMthJu'
   +'n, TMthJul, TMthAug, TMthSep, TMthOct, TMthNov, TMthDec )');
  SIRegister_TIdDateTimeStamp(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampWeekOfYear_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.WeekOfYear; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampYear_W(Self: TIdDateTimeStamp; const T: Integer);
begin Self.Year := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampYear_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.Year; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampTimeZoneAsString_R(Self: TIdDateTimeStamp; var T: String);
begin T := Self.TimeZoneAsString; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampTimeZoneMinutes_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.TimeZoneMinutes; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampTimeZoneHour_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.TimeZoneHour; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampTimeZone_W(Self: TIdDateTimeStamp; const T: Integer);
begin Self.TimeZone := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampTimeZone_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.TimeZone; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampSecondOfMinute_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.SecondOfMinute; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampSecondsInYear_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.SecondsInYear; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampSecond_W(Self: TIdDateTimeStamp; const T: Integer);
begin Self.Second := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampSecond_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.Second; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampMonthShortName_R(Self: TIdDateTimeStamp; var T: String);
begin T := Self.MonthShortName; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampMonthName_R(Self: TIdDateTimeStamp; var T: String);
begin T := Self.MonthName; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampMonthOfYear_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.MonthOfYear; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampMinuteOfHour_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.MinuteOfHour; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampMinuteOfDay_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.MinuteOfDay; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampMillisecond_W(Self: TIdDateTimeStamp; const T: Integer);
begin Self.Millisecond := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampMillisecond_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.Millisecond; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampIsMorning_R(Self: TIdDateTimeStamp; var T: Boolean);
begin T := Self.IsMorning; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampIsLeapYear_R(Self: TIdDateTimeStamp; var T: Boolean);
begin T := Self.IsLeapYear; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampHourOf24Day_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.HourOf24Day; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampHourOf12Day_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.HourOf12Day; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampDayOfWeekShortName_R(Self: TIdDateTimeStamp; var T: String);
begin T := Self.DayOfWeekShortName; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampDayOfWeekName_R(Self: TIdDateTimeStamp; var T: String);
begin T := Self.DayOfWeekName; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampDayOfWeek_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.DayOfWeek; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampDayOfMonth_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.DayOfMonth; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampDaysInYear_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.DaysInYear; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampDay_W(Self: TIdDateTimeStamp; const T: Integer);
begin Self.Day := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampDay_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.Day; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampBeatOfDay_R(Self: TIdDateTimeStamp; var T: Integer);
begin T := Self.BeatOfDay; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampAsTimeOfDay_R(Self: TIdDateTimeStamp; var T: String);
begin T := Self.AsTimeOfDay; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampAsTTimeStamp_R(Self: TIdDateTimeStamp; var T: TTimeStamp);
begin T := Self.AsTTimeStamp; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampAsTDateTime_R(Self: TIdDateTimeStamp; var T: TDateTime);
begin T := Self.AsTDateTime; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampAsRFC822_R(Self: TIdDateTimeStamp; var T: String);
begin T := Self.AsRFC822; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampAsISO8601Week_R(Self: TIdDateTimeStamp; var T: String);
begin T := Self.AsISO8601Week; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampAsISO8601Ordinal_R(Self: TIdDateTimeStamp; var T: String);
begin T := Self.AsISO8601Ordinal; end;

(*----------------------------------------------------------------------------*)
procedure TIdDateTimeStampAsISO8601Calendar_R(Self: TIdDateTimeStamp; var T: String);
begin T := Self.AsISO8601Calendar; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdDateTimeStamp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdDateTimeStamp) do
  begin
    RegisterConstructor(@TIdDateTimeStamp.Create, 'Create');
    RegisterMethod(@TIdDateTimeStamp.AddDays, 'AddDays');
    RegisterMethod(@TIdDateTimeStamp.AddHours, 'AddHours');
    RegisterMethod(@TIdDateTimeStamp.AddMilliseconds, 'AddMilliseconds');
    RegisterMethod(@TIdDateTimeStamp.AddMinutes, 'AddMinutes');
    RegisterMethod(@TIdDateTimeStamp.AddMonths, 'AddMonths');
    RegisterMethod(@TIdDateTimeStamp.AddSeconds, 'AddSeconds');
    RegisterMethod(@TIdDateTimeStamp.AddTDateTime, 'AddTDateTime');
    RegisterMethod(@TIdDateTimeStamp.AddTIdDateTimeStamp, 'AddTIdDateTimeStamp');
    RegisterMethod(@TIdDateTimeStamp.AddTTimeStamp, 'AddTTimeStamp');
    RegisterMethod(@TIdDateTimeStamp.AddWeeks, 'AddWeeks');
    RegisterMethod(@TIdDateTimeStamp.AddYears, 'AddYears');
    RegisterMethod(@TIdDateTimeStamp.GetAsISO8601Calendar, 'GetAsISO8601Calendar');
    RegisterMethod(@TIdDateTimeStamp.GetAsISO8601Ordinal, 'GetAsISO8601Ordinal');
    RegisterMethod(@TIdDateTimeStamp.GetAsISO8601Week, 'GetAsISO8601Week');
    RegisterMethod(@TIdDateTimeStamp.GetAsRFC822, 'GetAsRFC822');
    RegisterMethod(@TIdDateTimeStamp.GetAsTDateTime, 'GetAsTDateTime');
    RegisterMethod(@TIdDateTimeStamp.GetAsTTimeStamp, 'GetAsTTimeStamp');
    RegisterMethod(@TIdDateTimeStamp.GetAsTimeOfDay, 'GetAsTimeOfDay');
    RegisterMethod(@TIdDateTimeStamp.GetBeatOfDay, 'GetBeatOfDay');
    RegisterMethod(@TIdDateTimeStamp.GetDaysInYear, 'GetDaysInYear');
    RegisterMethod(@TIdDateTimeStamp.GetDayOfMonth, 'GetDayOfMonth');
    RegisterMethod(@TIdDateTimeStamp.GetDayOfWeek, 'GetDayOfWeek');
    RegisterMethod(@TIdDateTimeStamp.GetDayOfWeekName, 'GetDayOfWeekName');
    RegisterMethod(@TIdDateTimeStamp.GetDayOfWeekShortName, 'GetDayOfWeekShortName');
    RegisterMethod(@TIdDateTimeStamp.GetHourOf12Day, 'GetHourOf12Day');
    RegisterMethod(@TIdDateTimeStamp.GetHourOf24Day, 'GetHourOf24Day');
    RegisterMethod(@TIdDateTimeStamp.GetIsMorning, 'GetIsMorning');
    RegisterMethod(@TIdDateTimeStamp.GetMinuteOfDay, 'GetMinuteOfDay');
    RegisterMethod(@TIdDateTimeStamp.GetMinuteOfHour, 'GetMinuteOfHour');
    RegisterMethod(@TIdDateTimeStamp.GetMonthOfYear, 'GetMonthOfYear');
    RegisterMethod(@TIdDateTimeStamp.GetMonthName, 'GetMonthName');
    RegisterMethod(@TIdDateTimeStamp.GetMonthShortName, 'GetMonthShortName');
    RegisterMethod(@TIdDateTimeStamp.GetSecondsInYear, 'GetSecondsInYear');
    RegisterMethod(@TIdDateTimeStamp.GetSecondOfMinute, 'GetSecondOfMinute');
    RegisterMethod(@TIdDateTimeStamp.GetTimeZoneAsString, 'GetTimeZoneAsString');
    RegisterMethod(@TIdDateTimeStamp.GetTimeZoneHour, 'GetTimeZoneHour');
    RegisterMethod(@TIdDateTimeStamp.GetTimeZoneMinutes, 'GetTimeZoneMinutes');
    RegisterMethod(@TIdDateTimeStamp.GetWeekOfYear, 'GetWeekOfYear');
    RegisterMethod(@TIdDateTimeStamp.SetFromDOSDateTime, 'SetFromDOSDateTime');
    RegisterMethod(@TIdDateTimeStamp.SetFromISO8601, 'SetFromISO8601');
    RegisterMethod(@TIdDateTimeStamp.SetFromRFC822, 'SetFromRFC822');
    RegisterMethod(@TIdDateTimeStamp.SetFromTDateTime, 'SetFromTDateTime');
    RegisterMethod(@TIdDateTimeStamp.SetFromTTimeStamp, 'SetFromTTimeStamp');
    RegisterMethod(@TIdDateTimeStamp.SetDay, 'SetDay');
    RegisterMethod(@TIdDateTimeStamp.SetMillisecond, 'SetMillisecond');
    RegisterMethod(@TIdDateTimeStamp.SetSecond, 'SetSecond');
    RegisterMethod(@TIdDateTimeStamp.SetTimeZone, 'SetTimeZone');
    RegisterMethod(@TIdDateTimeStamp.SetYear, 'SetYear');
    RegisterMethod(@TIdDateTimeStamp.SubtractDays, 'SubtractDays');
    RegisterMethod(@TIdDateTimeStamp.SubtractHours, 'SubtractHours');
    RegisterMethod(@TIdDateTimeStamp.SubtractMilliseconds, 'SubtractMilliseconds');
    RegisterMethod(@TIdDateTimeStamp.SubtractMinutes, 'SubtractMinutes');
    RegisterMethod(@TIdDateTimeStamp.SubtractMonths, 'SubtractMonths');
    RegisterMethod(@TIdDateTimeStamp.SubtractSeconds, 'SubtractSeconds');
    RegisterMethod(@TIdDateTimeStamp.SubtractTDateTime, 'SubtractTDateTime');
    RegisterMethod(@TIdDateTimeStamp.SubtractTIdDateTimeStamp, 'SubtractTIdDateTimeStamp');
    RegisterMethod(@TIdDateTimeStamp.SubtractTTimeStamp, 'SubtractTTimeStamp');
    RegisterMethod(@TIdDateTimeStamp.SubtractWeeks, 'SubtractWeeks');
    RegisterMethod(@TIdDateTimeStamp.SubtractYears, 'SubtractYears');
    RegisterMethod(@TIdDateTimeStamp.Zero, 'Zero');
    RegisterMethod(@TIdDateTimeStamp.ZeroDate, 'ZeroDate');
    RegisterMethod(@TIdDateTimeStamp.ZeroTime, 'ZeroTime');
    RegisterPropertyHelper(@TIdDateTimeStampAsISO8601Calendar_R,nil,'AsISO8601Calendar');
    RegisterPropertyHelper(@TIdDateTimeStampAsISO8601Ordinal_R,nil,'AsISO8601Ordinal');
    RegisterPropertyHelper(@TIdDateTimeStampAsISO8601Week_R,nil,'AsISO8601Week');
    RegisterPropertyHelper(@TIdDateTimeStampAsRFC822_R,nil,'AsRFC822');
    RegisterPropertyHelper(@TIdDateTimeStampAsTDateTime_R,nil,'AsTDateTime');
    RegisterPropertyHelper(@TIdDateTimeStampAsTTimeStamp_R,nil,'AsTTimeStamp');
    RegisterPropertyHelper(@TIdDateTimeStampAsTimeOfDay_R,nil,'AsTimeOfDay');
    RegisterPropertyHelper(@TIdDateTimeStampBeatOfDay_R,nil,'BeatOfDay');
    RegisterPropertyHelper(@TIdDateTimeStampDay_R,@TIdDateTimeStampDay_W,'Day');
    RegisterPropertyHelper(@TIdDateTimeStampDaysInYear_R,nil,'DaysInYear');
    RegisterPropertyHelper(@TIdDateTimeStampDayOfMonth_R,nil,'DayOfMonth');
    RegisterPropertyHelper(@TIdDateTimeStampDayOfWeek_R,nil,'DayOfWeek');
    RegisterPropertyHelper(@TIdDateTimeStampDayOfWeekName_R,nil,'DayOfWeekName');
    RegisterPropertyHelper(@TIdDateTimeStampDayOfWeekShortName_R,nil,'DayOfWeekShortName');
    RegisterPropertyHelper(@TIdDateTimeStampHourOf12Day_R,nil,'HourOf12Day');
    RegisterPropertyHelper(@TIdDateTimeStampHourOf24Day_R,nil,'HourOf24Day');
    RegisterPropertyHelper(@TIdDateTimeStampIsLeapYear_R,nil,'IsLeapYear');
    RegisterPropertyHelper(@TIdDateTimeStampIsMorning_R,nil,'IsMorning');
    RegisterPropertyHelper(@TIdDateTimeStampMillisecond_R,@TIdDateTimeStampMillisecond_W,'Millisecond');
    RegisterPropertyHelper(@TIdDateTimeStampMinuteOfDay_R,nil,'MinuteOfDay');
    RegisterPropertyHelper(@TIdDateTimeStampMinuteOfHour_R,nil,'MinuteOfHour');
    RegisterPropertyHelper(@TIdDateTimeStampMonthOfYear_R,nil,'MonthOfYear');
    RegisterPropertyHelper(@TIdDateTimeStampMonthName_R,nil,'MonthName');
    RegisterPropertyHelper(@TIdDateTimeStampMonthShortName_R,nil,'MonthShortName');
    RegisterPropertyHelper(@TIdDateTimeStampSecond_R,@TIdDateTimeStampSecond_W,'Second');
    RegisterPropertyHelper(@TIdDateTimeStampSecondsInYear_R,nil,'SecondsInYear');
    RegisterPropertyHelper(@TIdDateTimeStampSecondOfMinute_R,nil,'SecondOfMinute');
    RegisterPropertyHelper(@TIdDateTimeStampTimeZone_R,@TIdDateTimeStampTimeZone_W,'TimeZone');
    RegisterPropertyHelper(@TIdDateTimeStampTimeZoneHour_R,nil,'TimeZoneHour');
    RegisterPropertyHelper(@TIdDateTimeStampTimeZoneMinutes_R,nil,'TimeZoneMinutes');
    RegisterPropertyHelper(@TIdDateTimeStampTimeZoneAsString_R,nil,'TimeZoneAsString');
    RegisterPropertyHelper(@TIdDateTimeStampYear_R,@TIdDateTimeStampYear_W,'Year');
    RegisterPropertyHelper(@TIdDateTimeStampWeekOfYear_R,nil,'WeekOfYear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdDateTimeStamp(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdDateTimeStamp(CL);
end;

 
 
{ TPSImport_IdDateTimeStamp }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdDateTimeStamp.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdDateTimeStamp(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdDateTimeStamp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdDateTimeStamp(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
