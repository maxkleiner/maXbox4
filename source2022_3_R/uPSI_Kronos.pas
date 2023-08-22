unit uPSI_Kronos;
{
to Korg Kronos deducated sectec
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
  TPSImport_Kronos = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TKronos(CL: TPSPascalCompiler);
procedure SIRegister_TDaytype(CL: TPSPascalCompiler);
procedure SIRegister_Kronos(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Kronos_Routines(S: TPSExec);
procedure RIRegister_TKronos(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDaytype(CL: TPSRuntimeClassImporter);
procedure RIRegister_Kronos(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,Kronos
  ;
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_Kronos]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TKronos(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TKronos') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TKronos') do begin
    //RegisterProperty('Daynames', '', iptrw);
    //RegisterProperty('Monthnames', '', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function AddDaytype( DayType : TDaytype) : Word');
    RegisterMethod('Procedure ClearUserDaytypes');
    RegisterMethod('Function DeleteUserDayType( AnId : word; AName : string) : boolean');
    RegisterMethod('Procedure UpdateDaytype( AnId : word; AName : string; DaytypeDef : TDaytypeDef)');
    RegisterMethod('Function GetDaytypeDef( AnId : word; AName : string) : TDaytypeDef');
    RegisterMethod('Function GetNextDaytype( var NextIndex : word) : TDaytype');
    RegisterMethod('Function GetNextDaytypeName( AName : string; var Count : word) : TDaytype');
    RegisterMethod('Function GetNextDaytypeDate( ADate : word; var Count : word) : TDaytype');
    RegisterMethod('Procedure SpecifyStandardDay( AnId : word; AName : string; IsHoliday, IsFlagday : boolean)');
    RegisterMethod('Procedure LoadFromFile( AFilename : string; LoadAll : boolean)');
    RegisterMethod('Procedure SaveToFile( AFilename : string)');
    RegisterProperty('YearExt', 'TYearExt', iptr);
    RegisterProperty('MonthExt', 'TMonthExt', iptr);
    RegisterProperty('WeekExt', 'TWeekExt', iptr);
    RegisterProperty('DateExt', 'TDateExt', iptr);
    RegisterProperty('DayTypeCount', 'word', iptr);
    RegisterProperty('DayTypes', 'TDaytype word', iptr);
    RegisterProperty('FirstUserId', 'Word', iptr);
    RegisterMethod('Function FetchYearExt( AYear : word) : TYearExt');
    RegisterMethod('Function FetchMonthExt( AYear, AMonth : word) : TMonthExt');
    RegisterMethod('Function FetchWeekExt( AYear, AWeek : word) : TWeekExt');
    RegisterMethod('Function FetchDateExt( AYear, AMonth, AMonthDay : word) : TDateExt');
    RegisterMethod('Function FetchDateExtDt( ADate : TDateTime) : TDateExt');
    RegisterMethod('Function FetchDateExtDn( AYear, ADayNumber : word) : TDateExt');
    RegisterMethod('Function FetchDaytype( ADateExt : TDateExt; AnIndex : word) : TDaytype');
    RegisterMethod('Function FetchYeartype( AYearExt : TYearExt; AnIndex : word) : TDaytype');
    RegisterMethod('Function IsLeapYear( AYear : word) : boolean');
    RegisterMethod('Function GetNumWeeks( AYear : word) : word');
    RegisterMethod('Function IsLastDayOfMonth( AYear, AMonth, AMonthDay : word) : boolean');
    RegisterMethod('Function IsLastWeekOfYear( AYear, AWeek : word) : boolean');
    RegisterMethod('Function MonthsInInterval( Year1, Month1, Year2, Month2 : word) : integer');
    RegisterMethod('Function WeeksInInterval( Year1, Week1, Year2, Week2 : word) : integer');
    RegisterMethod('Function DaysInInterval( Year1, Month1, MonthDay1, Year2, Month2, MonthDay2 : word; WorkdaysOnly : boolean) : integer');
    RegisterMethod('Function DaysInIntervalDn( Year1, Daynumber1, Year2, Daynumber2 : word; WorkdaysOnly : boolean) : integer');
    RegisterMethod('Function DaysInIntervalDt( Date1, Date2 : TDateTime; WorkdaysOnly : boolean) : integer');
    RegisterMethod('Function DaynumberByTypeName( AYear : word; DayTypeName : string) : word');
    RegisterMethod('Function DaynumberByTypeId( AYear : word; ADayTypeId : word) : word');
    RegisterMethod('Procedure DateByDayOffset( var TheYear, TheDayNumber : word; OffsetValue : integer; WorkdaysOnly : Boolean)');
    RegisterMethod('Procedure DateByWeekOffset( var TheYear, TheDayNumber : word; OffsetValue : integer)');
    RegisterMethod('Procedure DateByMonthOffset( var TheYear, TheDayNumber : word; OffsetValue : integer)');
    RegisterMethod('Function IsToday( var AYear, ADayNumber : word) : boolean');
    RegisterMethod('Function IsTomorrow( var AYear, ADayNumber : word) : boolean');
    RegisterMethod('Function IsYesterday( var AYear, ADayNumber : word) : boolean');
    RegisterMethod('Function IsThisWeek( var AYear, AWeekNumber : word) : boolean');
    RegisterMethod('Function IsNextWeek( var AYear, AWeekNumber : word) : boolean');
    RegisterMethod('Function IsLastWeek( var AYear, AWeekNumber : word) : boolean');
    RegisterMethod('Function IsThisMonth( var AYear, AMonthNumber : word) : boolean');
    RegisterMethod('Function IsNextMonth( var AYear, AMonthNumber : word) : boolean');
    RegisterMethod('Function IsLastMonth( var AYear, AMonthNumber : word) : boolean');
    RegisterMethod('Function IsThisYear( var AYear : word) : boolean');
    RegisterMethod('Function IsNextYear( var AYear : word) : boolean');
    RegisterMethod('Function IsLastYear( var AYear : word) : boolean');
    RegisterMethod('Procedure GotoDate( AYear, AMonth, AMonthDay : word)');
    RegisterMethod('Procedure GotoDateDt( ADate : TDateTime)');
    RegisterMethod('Procedure GotoDateDn( AYear, ADayNumber : word)');
    RegisterMethod('Procedure GotoToday');
    RegisterMethod('Procedure GotoTomorrow');
    RegisterMethod('Procedure GotoYesterday');
    RegisterMethod('Procedure GotoThisWeek');
    RegisterMethod('Procedure GotoNextWeek');
    RegisterMethod('Procedure GotoLastWeek');
    RegisterMethod('Procedure GotoThisMonth');
    RegisterMethod('Procedure GotoNextMonth');
    RegisterMethod('Procedure GotoLastMonth');
    RegisterMethod('Procedure GotoDayType( AYear : word; AnId : word; DayTypeName : string)');
    RegisterMethod('Procedure GoToOffsetDay( OffsetValue : integer; WorkdaysOnly : boolean)');
    RegisterMethod('Procedure GoToOffsetWeek( OffsetValue : integer)');
    RegisterMethod('Procedure GoToOffsetMonth( OffsetValue : integer)');
    RegisterMethod('Function DOWtoWeekday( ADayOfWeekNumber : word) : TWeekDay');
    RegisterMethod('Function DOWtoDayNameIndex( ADayOfWeekNumber : word) : word');
    RegisterMethod('Function CDtoDateTime : TDateTime');
    RegisterMethod('Procedure GetMIDayCell( ADayNumber : word; var ARow, ACol : Longint)');
    RegisterMethod('Function GetMIWeekRow( AWeekNumber : word) : word');
    RegisterMethod('Procedure GetFirstMIDayCell( var ARow, ACol : Longint)');
    RegisterMethod('Procedure GetLastMIDayCell( var ARow, ACol : Longint)');
    RegisterMethod('Procedure DisableEvents( Disable : boolean)');
    RegisterMethod('Procedure SaveCD');
    RegisterMethod('Procedure RestoreCD');
    RegisterMethod('Procedure UpdateInfo');
    RegisterMethod('Procedure BeginChange');
    RegisterMethod('Procedure EndChange');
    RegisterMethod('Function ExistsDaytype( DaytypeName : string) : Word');
    RegisterMethod('Procedure Rechange');
    RegisterMethod('Function GetDescKey( var Index : Integer; Keys : string; var KeyName, Value : string) : Boolean');
    RegisterProperty('Year', 'word', iptrw);
    RegisterProperty('Month', 'word', iptrw);
    RegisterProperty('MonthDay', 'word', iptrw);
    RegisterProperty('FirstWeekDay', 'TWeekDay', iptrw);
    RegisterProperty('WeekDay', 'TWeekDay', iptrw);
    RegisterProperty('Week', 'word', iptrw);
    RegisterProperty('DayNumber', 'word', iptrw);
    RegisterProperty('WeekHolidays', 'TWeekHolidays', iptrw);
    RegisterProperty('DefaultToPresentDay', 'boolean', iptrw);
    RegisterProperty('MinYear', 'word', iptrw);
    RegisterProperty('MaxYear', 'word', iptrw);
    RegisterProperty('AllowUserCalc', 'boolean', iptrw);
    RegisterProperty('HidePredefineds', 'boolean', iptrw);
    RegisterProperty('OnChangeYear', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChangeMonth', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChangeMonthNumber', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChangeWeek', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChangeWeekNumber', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChangeMonthDay', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChangeWeekDay', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChangeDate', 'TNotifyEvent', iptrw);
    RegisterProperty('OnToday', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCalcDaytype', 'TCalcDaytypeEvent', iptrw);
    RegisterProperty('OnLoadDaytype', 'TLoadDaytypeEvent', iptrw);
    RegisterProperty('OnSaveDaytype', 'TSaveDaytypeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDaytype(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TDaytype') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TDaytype') do
  begin
    RegisterProperty('TheDate', 'word', iptr);
    RegisterProperty('TheName', 'TNameStr', iptr);
    RegisterProperty('Id', 'word', iptr);
    RegisterProperty('FirstShowUp', 'word', iptr);
    RegisterProperty('LastShowUp', 'word', iptr);
    RegisterProperty('ShowUpFrequency', 'word', iptr);
    RegisterProperty('RelDaytype', 'word', iptr);
    RegisterProperty('Offset', 'integer', iptr);
    RegisterProperty('ChurchDay', 'boolean', iptr);
    RegisterProperty('Holiday', 'boolean', iptr);
    RegisterProperty('Flagday', 'boolean', iptr);
    RegisterProperty('UserCalc', 'boolean', iptr);
    RegisterProperty('Tag', 'integer', iptr);
    RegisterMethod('Constructor Create( DaytypeDef : TDaytypeDef)');
    RegisterMethod('Procedure Update( DaytypeDef : TDaytypeDef; StartUserId : word)');
    RegisterMethod('Procedure SetId( AnId : word)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Kronos(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ChurchDayCount','LongInt').SetInt( 21);
 CL.AddConstantN('CommonDayCount','LongInt').SetInt( 4);
 CL.AddConstantN('chAdvent1','LongInt').SetInt( 1);
 CL.AddConstantN('chAdvent2','LongInt').SetInt( 2);
 CL.AddConstantN('chAdvent3','LongInt').SetInt( 3);
 CL.AddConstantN('chAdvent4','LongInt').SetInt( 4);
 CL.AddConstantN('chChristmasEve','LongInt').SetInt( 5);
 CL.AddConstantN('chChristmasDay','LongInt').SetInt( 6);
 CL.AddConstantN('chBoxingDay','LongInt').SetInt( 7);
 CL.AddConstantN('chNewYearEve','LongInt').SetInt( 8);
 CL.AddConstantN('chNewYearDay','LongInt').SetInt( 9);
 CL.AddConstantN('chShroveTuesday','LongInt').SetInt( 10);
 CL.AddConstantN('chAshWednesday','LongInt').SetInt( 11);
 CL.AddConstantN('chPalmSunday','LongInt').SetInt( 12);
 CL.AddConstantN('chMaundyThursday','LongInt').SetInt( 13);
 CL.AddConstantN('chGoodFriday','LongInt').SetInt( 14);
 CL.AddConstantN('chEasterEve','LongInt').SetInt( 15);
 CL.AddConstantN('chEasterSunday','LongInt').SetInt( 16);
 CL.AddConstantN('chEasterMonday','LongInt').SetInt( 17);
 CL.AddConstantN('chWhitEve','LongInt').SetInt( 18);
 CL.AddConstantN('chWhitSunday','LongInt').SetInt( 19);
 CL.AddConstantN('chWhitMonday','LongInt').SetInt( 20);
 CL.AddConstantN('chAscensionDay','LongInt').SetInt( 21);
 CL.AddConstantN('coUNDay','LongInt').SetInt( 22);
 CL.AddConstantN('coWomensDay','LongInt').SetInt( 23);
 CL.AddConstantN('coMayDay','LongInt').SetInt( 24);
 CL.AddConstantN('coLiteracyDay','LongInt').SetInt( 25);
 CL.AddConstantN('UserDayType','LongInt').SetInt( 26);

 //UserDayType = ChurchDayCount + CommonDayCount + 1;

   CL.AddTypeS('TFirstLastNumber', 'array[1..2] of word;');
   CL.AddTypeS('TDaytypeID', 'array[1..255] of word;');

   CL.AddTypeS('TMonthImage2', 'array[0..7] of smallint;');
   CL.AddTypeS('TMonthImage', 'array[1..6] of tmonthimage2;');

    //TMonthImage = array[1..6, 0..7] of smallint;

  // TFirstLastNumber = array[1..2] of word;
   // TDaytypeID = array[1..255] of word;


  CL.AddTypeS('TDay', 'record Daynum : Word; MonthDate : word; DOWNum : word; M'
   +'onth : word; Week : word; DayCode : Word; end');
  CL.AddTypeS('TWeek', 'record WeekNum : word; WhichDays : TFirstLastNumber; end');
  CL.AddTypeS('TMonth', 'record Month : word; Daycount : Word; WeekCount : Word'
   +'; WhichWeeks : TFirstLastNumber; WhichDays : TFirstLastNumber; end');
  CL.AddTypeS('TYear', 'record WeekCount : word; DayCount : Word; end');
  CL.AddTypeS('TKron', 'record ActiveYear : Word; IsInitialized : boolean; end');
  CL.AddTypeS('TYearExt', 'record Year : word; NumDays : word; NumWeeks : word;'
   +' LeapYear : boolean; YeartypeCount : word; end');
  CL.AddTypeS('TDateExt', 'record Year : word; DayOfWeekNumber : word; DayName '
   +': string; MonthDay : Word; DayNumber : word; DaytypeCount : word; DaytypeI'
   +'D : TDaytypeID; MonthNumber : word; WeekNumber : word; Holiday : boolean; '
   +'ChurchDay : Boolean; Flagday : Boolean; end');
  CL.AddTypeS('TMonthExt', 'record Year : word; MonthNumber : word; MonthName :'
   +' string; FirstDay : word; LastDay : word; NumDays : word; NumWeeks : word;'
   +' FirstWeek : word; LastWeek : word; MonthImage : TMonthImage; end');
  CL.AddTypeS('TWeekExt', 'record Year : word; WeekNumber : word; FirstDay : word; LastDay : word; end');
  CL.AddTypeS('TForeignKey', 'record KeyName : string; KeyValue : Variant; end');
  CL.AddTypeS('TDaytypeDef', 'record AName : string; ADate : word; ARelDayTyp'
   +'e : word; AnOffset : integer; AFirstShowUp : word; ALastShowUp : word; ASh'
   +'owUpFrequency : word; AChurchDay : boolean; AHoliday : boolean; AFlagday :'
   +' boolean; AUserCalc : boolean; ATag : integer; end');
  SIRegister_TDaytype(CL);
  CL.AddTypeS('TWeekDay', '( Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday )');
  CL.AddTypeS('TWeekHolidays', 'set of TWeekDay');
  CL.AddTypeS('TOcEVent', '( ocYear, ocMonth, ocMonthnumber, ocWeek, ocWeeknumb'
   +'er, ocMonthDay, ocWeekday, ocDate, ocToday, ocCalcDaytype )');
  CL.AddTypeS('TCalcDaytypeEvent', 'Procedure ( Sender : TObject; Daytype : TDa'
   +'ytype; ADateExt : TDateExt; IsCurrentDate : boolean; var Accept : boolean)');
  CL.AddTypeS('TLoadDaytypeEvent', 'Procedure ( Sender : TObject; const Daytype'
   +'Def : TDaytypeDef; const DescKeys : String; ClassId : Integer; var LoadIt: boolean)');
  CL.AddTypeS('TSaveDaytypeEvent', 'Procedure ( Sender : TObject; Daytype : TDa'
   +'ytype; var DescKeys : String; var ClassID : Integer; var SaveIt : boolean)');
  SIRegister_TKronos(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EKronosError');
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TKronosOnSaveDaytype_W(Self: TKronos; const T: TSaveDaytypeEvent);
begin Self.OnSaveDaytype := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnSaveDaytype_R(Self: TKronos; var T: TSaveDaytypeEvent);
begin T := Self.OnSaveDaytype; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnLoadDaytype_W(Self: TKronos; const T: TLoadDaytypeEvent);
begin Self.OnLoadDaytype := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnLoadDaytype_R(Self: TKronos; var T: TLoadDaytypeEvent);
begin T := Self.OnLoadDaytype; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnCalcDaytype_W(Self: TKronos; const T: TCalcDaytypeEvent);
begin Self.OnCalcDaytype := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnCalcDaytype_R(Self: TKronos; var T: TCalcDaytypeEvent);
begin T := Self.OnCalcDaytype; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnToday_W(Self: TKronos; const T: TNotifyEvent);
begin Self.OnToday := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnToday_R(Self: TKronos; var T: TNotifyEvent);
begin T := Self.OnToday; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeDate_W(Self: TKronos; const T: TNotifyEvent);
begin Self.OnChangeDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeDate_R(Self: TKronos; var T: TNotifyEvent);
begin T := Self.OnChangeDate; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeWeekDay_W(Self: TKronos; const T: TNotifyEvent);
begin Self.OnChangeWeekDay := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeWeekDay_R(Self: TKronos; var T: TNotifyEvent);
begin T := Self.OnChangeWeekDay; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeMonthDay_W(Self: TKronos; const T: TNotifyEvent);
begin Self.OnChangeMonthDay := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeMonthDay_R(Self: TKronos; var T: TNotifyEvent);
begin T := Self.OnChangeMonthDay; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeWeekNumber_W(Self: TKronos; const T: TNotifyEvent);
begin Self.OnChangeWeekNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeWeekNumber_R(Self: TKronos; var T: TNotifyEvent);
begin T := Self.OnChangeWeekNumber; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeWeek_W(Self: TKronos; const T: TNotifyEvent);
begin Self.OnChangeWeek := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeWeek_R(Self: TKronos; var T: TNotifyEvent);
begin T := Self.OnChangeWeek; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeMonthNumber_W(Self: TKronos; const T: TNotifyEvent);
begin Self.OnChangeMonthNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeMonthNumber_R(Self: TKronos; var T: TNotifyEvent);
begin T := Self.OnChangeMonthNumber; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeMonth_W(Self: TKronos; const T: TNotifyEvent);
begin Self.OnChangeMonth := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeMonth_R(Self: TKronos; var T: TNotifyEvent);
begin T := Self.OnChangeMonth; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeYear_W(Self: TKronos; const T: TNotifyEvent);
begin Self.OnChangeYear := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosOnChangeYear_R(Self: TKronos; var T: TNotifyEvent);
begin T := Self.OnChangeYear; end;

(*----------------------------------------------------------------------------*)
procedure TKronosHidePredefineds_W(Self: TKronos; const T: boolean);
begin Self.HidePredefineds := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosHidePredefineds_R(Self: TKronos; var T: boolean);
begin T := Self.HidePredefineds; end;

(*----------------------------------------------------------------------------*)
procedure TKronosAllowUserCalc_W(Self: TKronos; const T: boolean);
begin Self.AllowUserCalc := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosAllowUserCalc_R(Self: TKronos; var T: boolean);
begin T := Self.AllowUserCalc; end;

(*----------------------------------------------------------------------------*)
procedure TKronosMaxYear_W(Self: TKronos; const T: word);
begin Self.MaxYear := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosMaxYear_R(Self: TKronos; var T: word);
begin T := Self.MaxYear; end;

(*----------------------------------------------------------------------------*)
procedure TKronosMinYear_W(Self: TKronos; const T: word);
begin Self.MinYear := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosMinYear_R(Self: TKronos; var T: word);
begin T := Self.MinYear; end;

(*----------------------------------------------------------------------------*)
procedure TKronosDefaultToPresentDay_W(Self: TKronos; const T: boolean);
begin Self.DefaultToPresentDay := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosDefaultToPresentDay_R(Self: TKronos; var T: boolean);
begin T := Self.DefaultToPresentDay; end;

(*----------------------------------------------------------------------------*)
procedure TKronosWeekHolidays_W(Self: TKronos; const T: TWeekHolidays);
begin Self.WeekHolidays := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosWeekHolidays_R(Self: TKronos; var T: TWeekHolidays);
begin T := Self.WeekHolidays; end;

(*----------------------------------------------------------------------------*)
procedure TKronosDayNumber_W(Self: TKronos; const T: word);
begin Self.DayNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosDayNumber_R(Self: TKronos; var T: word);
begin T := Self.DayNumber; end;

(*----------------------------------------------------------------------------*)
procedure TKronosWeek_W(Self: TKronos; const T: word);
begin Self.Week := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosWeek_R(Self: TKronos; var T: word);
begin T := Self.Week; end;

(*----------------------------------------------------------------------------*)
procedure TKronosWeekDay_W(Self: TKronos; const T: TWeekDay);
begin Self.WeekDay := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosWeekDay_R(Self: TKronos; var T: TWeekDay);
begin T := Self.WeekDay; end;

(*----------------------------------------------------------------------------*)
procedure TKronosFirstWeekDay_W(Self: TKronos; const T: TWeekDay);
begin Self.FirstWeekDay := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosFirstWeekDay_R(Self: TKronos; var T: TWeekDay);
begin T := Self.FirstWeekDay; end;

(*----------------------------------------------------------------------------*)
procedure TKronosMonthDay_W(Self: TKronos; const T: word);
begin Self.MonthDay := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosMonthDay_R(Self: TKronos; var T: word);
begin T := Self.MonthDay; end;

(*----------------------------------------------------------------------------*)
procedure TKronosMonth_W(Self: TKronos; const T: word);
begin Self.Month := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosMonth_R(Self: TKronos; var T: word);
begin T := Self.Month; end;

(*----------------------------------------------------------------------------*)
procedure TKronosYear_W(Self: TKronos; const T: word);
begin Self.Year := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosYear_R(Self: TKronos; var T: word);
begin T := Self.Year; end;

(*----------------------------------------------------------------------------*)
procedure TKronosFirstUserId_R(Self: TKronos; var T: Word);
begin T := Self.FirstUserId; end;

(*----------------------------------------------------------------------------*)
procedure TKronosDayTypes_R(Self: TKronos; var T: TDaytype; const t1: word);
begin T := Self.DayTypes[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKronosDayTypeCount_R(Self: TKronos; var T: word);
begin T := Self.DayTypeCount; end;

(*----------------------------------------------------------------------------*)
procedure TKronosDateExt_R(Self: TKronos; var T: TDateExt);
begin T := Self.DateExt; end;

(*----------------------------------------------------------------------------*)
procedure TKronosWeekExt_R(Self: TKronos; var T: TWeekExt);
begin T := Self.WeekExt; end;

(*----------------------------------------------------------------------------*)
procedure TKronosMonthExt_R(Self: TKronos; var T: TMonthExt);
begin T := Self.MonthExt; end;

(*----------------------------------------------------------------------------*)
procedure TKronosYearExt_R(Self: TKronos; var T: TYearExt);
begin T := Self.YearExt; end;

(*----------------------------------------------------------------------------*)
{procedure TKronosMonthnames_W(Self: TKronos; const T: array of string);
Begin Self.Monthnames := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosMonthnames_R(Self: TKronos; var T: );
Begin T := Self.Monthnames; end;

(*----------------------------------------------------------------------------*)
procedure TKronosDaynames_W(Self: TKronos; const T: );
Begin Self.Daynames := T; end;

(*----------------------------------------------------------------------------*)
procedure TKronosDaynames_R(Self: TKronos; var T: );
Begin T := Self.Daynames; end;     }

(*----------------------------------------------------------------------------*)
procedure TDaytypeTag_R(Self: TDaytype; var T: integer);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeUserCalc_R(Self: TDaytype; var T: boolean);
begin T := Self.UserCalc; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeFlagday_R(Self: TDaytype; var T: boolean);
begin T := Self.Flagday; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeHoliday_R(Self: TDaytype; var T: boolean);
begin T := Self.Holiday; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeChurchDay_R(Self: TDaytype; var T: boolean);
begin T := Self.ChurchDay; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeOffset_R(Self: TDaytype; var T: integer);
begin T := Self.Offset; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeRelDaytype_R(Self: TDaytype; var T: word);
begin T := Self.RelDaytype; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeShowUpFrequency_R(Self: TDaytype; var T: word);
begin T := Self.ShowUpFrequency; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeLastShowUp_R(Self: TDaytype; var T: word);
begin T := Self.LastShowUp; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeFirstShowUp_R(Self: TDaytype; var T: word);
begin T := Self.FirstShowUp; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeId_R(Self: TDaytype; var T: word);
begin T := Self.Id; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeTheName_R(Self: TDaytype; var T: TNameStr);
begin T := Self.TheName; end;

(*----------------------------------------------------------------------------*)
procedure TDaytypeTheDate_R(Self: TDaytype; var T: word);
begin T := Self.TheDate; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Kronos_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKronos(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKronos) do begin
    //RegisterPropertyHelper(@TKronosDaynames_R,@TKronosDaynames_W,'Daynames');
    //RegisterPropertyHelper(@TKronosMonthnames_R,@TKronosMonthnames_W,'Monthnames');
    RegisterConstructor(@TKronos.Create, 'Create');
        RegisterMethod(@TKronos.Destroy, 'Free');

    RegisterMethod(@TKronos.AddDaytype, 'AddDaytype');
    RegisterMethod(@TKronos.ClearUserDaytypes, 'ClearUserDaytypes');
    RegisterMethod(@TKronos.DeleteUserDayType, 'DeleteUserDayType');
    RegisterMethod(@TKronos.UpdateDaytype, 'UpdateDaytype');
    RegisterMethod(@TKronos.GetDaytypeDef, 'GetDaytypeDef');
    RegisterMethod(@TKronos.GetNextDaytype, 'GetNextDaytype');
    RegisterMethod(@TKronos.GetNextDaytypeName, 'GetNextDaytypeName');
    RegisterMethod(@TKronos.GetNextDaytypeDate, 'GetNextDaytypeDate');
    RegisterMethod(@TKronos.SpecifyStandardDay, 'SpecifyStandardDay');
    RegisterMethod(@TKronos.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TKronos.SaveToFile, 'SaveToFile');
    RegisterPropertyHelper(@TKronosYearExt_R,nil,'YearExt');
    RegisterPropertyHelper(@TKronosMonthExt_R,nil,'MonthExt');
    RegisterPropertyHelper(@TKronosWeekExt_R,nil,'WeekExt');
    RegisterPropertyHelper(@TKronosDateExt_R,nil,'DateExt');
    RegisterPropertyHelper(@TKronosDayTypeCount_R,nil,'DayTypeCount');
    RegisterPropertyHelper(@TKronosDayTypes_R,nil,'DayTypes');
    RegisterPropertyHelper(@TKronosFirstUserId_R,nil,'FirstUserId');
    RegisterMethod(@TKronos.FetchYearExt, 'FetchYearExt');
    RegisterMethod(@TKronos.FetchMonthExt, 'FetchMonthExt');
    RegisterMethod(@TKronos.FetchWeekExt, 'FetchWeekExt');
    RegisterMethod(@TKronos.FetchDateExt, 'FetchDateExt');
    RegisterMethod(@TKronos.FetchDateExtDt, 'FetchDateExtDt');
    RegisterMethod(@TKronos.FetchDateExtDn, 'FetchDateExtDn');
    RegisterMethod(@TKronos.FetchDaytype, 'FetchDaytype');
    RegisterMethod(@TKronos.FetchYeartype, 'FetchYeartype');
    RegisterMethod(@TKronos.IsLeapYear, 'IsLeapYear');
    RegisterMethod(@TKronos.GetNumWeeks, 'GetNumWeeks');
    RegisterMethod(@TKronos.IsLastDayOfMonth, 'IsLastDayOfMonth');
    RegisterMethod(@TKronos.IsLastWeekOfYear, 'IsLastWeekOfYear');
    RegisterMethod(@TKronos.MonthsInInterval, 'MonthsInInterval');
    RegisterMethod(@TKronos.WeeksInInterval, 'WeeksInInterval');
    RegisterMethod(@TKronos.DaysInInterval, 'DaysInInterval');
    RegisterMethod(@TKronos.DaysInIntervalDn, 'DaysInIntervalDn');
    RegisterMethod(@TKronos.DaysInIntervalDt, 'DaysInIntervalDt');
    RegisterMethod(@TKronos.DaynumberByTypeName, 'DaynumberByTypeName');
    RegisterMethod(@TKronos.DaynumberByTypeId, 'DaynumberByTypeId');
    RegisterMethod(@TKronos.DateByDayOffset, 'DateByDayOffset');
    RegisterMethod(@TKronos.DateByWeekOffset, 'DateByWeekOffset');
    RegisterMethod(@TKronos.DateByMonthOffset, 'DateByMonthOffset');
    RegisterMethod(@TKronos.IsToday, 'IsToday');
    RegisterMethod(@TKronos.IsTomorrow, 'IsTomorrow');
    RegisterMethod(@TKronos.IsYesterday, 'IsYesterday');
    RegisterMethod(@TKronos.IsThisWeek, 'IsThisWeek');
    RegisterMethod(@TKronos.IsNextWeek, 'IsNextWeek');
    RegisterMethod(@TKronos.IsLastWeek, 'IsLastWeek');
    RegisterMethod(@TKronos.IsThisMonth, 'IsThisMonth');
    RegisterMethod(@TKronos.IsNextMonth, 'IsNextMonth');
    RegisterMethod(@TKronos.IsLastMonth, 'IsLastMonth');
    RegisterMethod(@TKronos.IsThisYear, 'IsThisYear');
    RegisterMethod(@TKronos.IsNextYear, 'IsNextYear');
    RegisterMethod(@TKronos.IsLastYear, 'IsLastYear');
    RegisterMethod(@TKronos.GotoDate, 'GotoDate');
    RegisterMethod(@TKronos.GotoDateDt, 'GotoDateDt');
    RegisterMethod(@TKronos.GotoDateDn, 'GotoDateDn');
    RegisterMethod(@TKronos.GotoToday, 'GotoToday');
    RegisterMethod(@TKronos.GotoTomorrow, 'GotoTomorrow');
    RegisterMethod(@TKronos.GotoYesterday, 'GotoYesterday');
    RegisterMethod(@TKronos.GotoThisWeek, 'GotoThisWeek');
    RegisterMethod(@TKronos.GotoNextWeek, 'GotoNextWeek');
    RegisterMethod(@TKronos.GotoLastWeek, 'GotoLastWeek');
    RegisterMethod(@TKronos.GotoThisMonth, 'GotoThisMonth');
    RegisterMethod(@TKronos.GotoNextMonth, 'GotoNextMonth');
    RegisterMethod(@TKronos.GotoLastMonth, 'GotoLastMonth');
    RegisterMethod(@TKronos.GotoDayType, 'GotoDayType');
    RegisterMethod(@TKronos.GoToOffsetDay, 'GoToOffsetDay');
    RegisterMethod(@TKronos.GoToOffsetWeek, 'GoToOffsetWeek');
    RegisterMethod(@TKronos.GoToOffsetMonth, 'GoToOffsetMonth');
    RegisterMethod(@TKronos.DOWtoWeekday, 'DOWtoWeekday');
    RegisterMethod(@TKronos.DOWtoDayNameIndex, 'DOWtoDayNameIndex');
    RegisterMethod(@TKronos.CDtoDateTime, 'CDtoDateTime');
    RegisterMethod(@TKronos.GetMIDayCell, 'GetMIDayCell');
    RegisterMethod(@TKronos.GetMIWeekRow, 'GetMIWeekRow');
    RegisterMethod(@TKronos.GetFirstMIDayCell, 'GetFirstMIDayCell');
    RegisterMethod(@TKronos.GetLastMIDayCell, 'GetLastMIDayCell');
    RegisterMethod(@TKronos.DisableEvents, 'DisableEvents');
    RegisterMethod(@TKronos.SaveCD, 'SaveCD');
    RegisterMethod(@TKronos.RestoreCD, 'RestoreCD');
    RegisterMethod(@TKronos.UpdateInfo, 'UpdateInfo');
    RegisterMethod(@TKronos.BeginChange, 'BeginChange');
    RegisterMethod(@TKronos.EndChange, 'EndChange');
    RegisterMethod(@TKronos.ExistsDaytype, 'ExistsDaytype');
    RegisterMethod(@TKronos.Rechange, 'Rechange');
    RegisterMethod(@TKronos.GetDescKey, 'GetDescKey');
    RegisterPropertyHelper(@TKronosYear_R,@TKronosYear_W,'Year');
    RegisterPropertyHelper(@TKronosMonth_R,@TKronosMonth_W,'Month');
    RegisterPropertyHelper(@TKronosMonthDay_R,@TKronosMonthDay_W,'MonthDay');
    RegisterPropertyHelper(@TKronosFirstWeekDay_R,@TKronosFirstWeekDay_W,'FirstWeekDay');
    RegisterPropertyHelper(@TKronosWeekDay_R,@TKronosWeekDay_W,'WeekDay');
    RegisterPropertyHelper(@TKronosWeek_R,@TKronosWeek_W,'Week');
    RegisterPropertyHelper(@TKronosDayNumber_R,@TKronosDayNumber_W,'DayNumber');
    RegisterPropertyHelper(@TKronosWeekHolidays_R,@TKronosWeekHolidays_W,'WeekHolidays');
    RegisterPropertyHelper(@TKronosDefaultToPresentDay_R,@TKronosDefaultToPresentDay_W,'DefaultToPresentDay');
    RegisterPropertyHelper(@TKronosMinYear_R,@TKronosMinYear_W,'MinYear');
    RegisterPropertyHelper(@TKronosMaxYear_R,@TKronosMaxYear_W,'MaxYear');
    RegisterPropertyHelper(@TKronosAllowUserCalc_R,@TKronosAllowUserCalc_W,'AllowUserCalc');
    RegisterPropertyHelper(@TKronosHidePredefineds_R,@TKronosHidePredefineds_W,'HidePredefineds');
    RegisterPropertyHelper(@TKronosOnChangeYear_R,@TKronosOnChangeYear_W,'OnChangeYear');
    RegisterPropertyHelper(@TKronosOnChangeMonth_R,@TKronosOnChangeMonth_W,'OnChangeMonth');
    RegisterPropertyHelper(@TKronosOnChangeMonthNumber_R,@TKronosOnChangeMonthNumber_W,'OnChangeMonthNumber');
    RegisterPropertyHelper(@TKronosOnChangeWeek_R,@TKronosOnChangeWeek_W,'OnChangeWeek');
    RegisterPropertyHelper(@TKronosOnChangeWeekNumber_R,@TKronosOnChangeWeekNumber_W,'OnChangeWeekNumber');
    RegisterPropertyHelper(@TKronosOnChangeMonthDay_R,@TKronosOnChangeMonthDay_W,'OnChangeMonthDay');
    RegisterPropertyHelper(@TKronosOnChangeWeekDay_R,@TKronosOnChangeWeekDay_W,'OnChangeWeekDay');
    RegisterPropertyHelper(@TKronosOnChangeDate_R,@TKronosOnChangeDate_W,'OnChangeDate');
    RegisterPropertyHelper(@TKronosOnToday_R,@TKronosOnToday_W,'OnToday');
    RegisterPropertyHelper(@TKronosOnCalcDaytype_R,@TKronosOnCalcDaytype_W,'OnCalcDaytype');
    RegisterPropertyHelper(@TKronosOnLoadDaytype_R,@TKronosOnLoadDaytype_W,'OnLoadDaytype');
    RegisterPropertyHelper(@TKronosOnSaveDaytype_R,@TKronosOnSaveDaytype_W,'OnSaveDaytype');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDaytype(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDaytype) do
  begin
    RegisterPropertyHelper(@TDaytypeTheDate_R,nil,'TheDate');
    RegisterPropertyHelper(@TDaytypeTheName_R,nil,'TheName');
    RegisterPropertyHelper(@TDaytypeId_R,nil,'Id');
    RegisterPropertyHelper(@TDaytypeFirstShowUp_R,nil,'FirstShowUp');
    RegisterPropertyHelper(@TDaytypeLastShowUp_R,nil,'LastShowUp');
    RegisterPropertyHelper(@TDaytypeShowUpFrequency_R,nil,'ShowUpFrequency');
    RegisterPropertyHelper(@TDaytypeRelDaytype_R,nil,'RelDaytype');
    RegisterPropertyHelper(@TDaytypeOffset_R,nil,'Offset');
    RegisterPropertyHelper(@TDaytypeChurchDay_R,nil,'ChurchDay');
    RegisterPropertyHelper(@TDaytypeHoliday_R,nil,'Holiday');
    RegisterPropertyHelper(@TDaytypeFlagday_R,nil,'Flagday');
    RegisterPropertyHelper(@TDaytypeUserCalc_R,nil,'UserCalc');
    RegisterPropertyHelper(@TDaytypeTag_R,nil,'Tag');
    RegisterConstructor(@TDaytype.Create, 'Create');
    RegisterMethod(@TDaytype.Update, 'Update');
    RegisterMethod(@TDaytype.SetId, 'SetId');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Kronos(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDaytype(CL);
  RIRegister_TKronos(CL);
  with CL.Add(EKronosError) do
end;

 
 
{ TPSImport_Kronos }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Kronos.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Kronos(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Kronos.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Kronos(ri);
  RIRegister_Kronos_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
