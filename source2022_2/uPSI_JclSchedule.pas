unit uPSI_JclSchedule;
{

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
  TPSImport_JclSchedule = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IJclYearlySchedule(CL: TPSPascalCompiler);
procedure SIRegister_IJclMonthlySchedule(CL: TPSPascalCompiler);
procedure SIRegister_IJclWeeklySchedule(CL: TPSPascalCompiler);
procedure SIRegister_IJclDailySchedule(CL: TPSPascalCompiler);
procedure SIRegister_IJclScheduleDayFrequency(CL: TPSPascalCompiler);
procedure SIRegister_IJclSchedule(CL: TPSPascalCompiler);
procedure SIRegister_JclSchedule(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclSchedule_Routines(S: TPSExec);
procedure RIRegister_JclSchedule(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   JclBase
  ,JclSchedule
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclSchedule]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclYearlySchedule(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'IJclYearlySchedule') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IJclYearlySchedule, 'IJclYearlySchedule') do
  begin
    RegisterMethod('Function GetIndexKind : TScheduleIndexKind', cdRegister);
    RegisterMethod('Function GetIndexValue : Integer', cdRegister);
    RegisterMethod('Function GetDay : Cardinal', cdRegister);
    RegisterMethod('Function GetMonth : Cardinal', cdRegister);
    RegisterMethod('Function GetInterval : Cardinal', cdRegister);
    RegisterMethod('Procedure SetIndexKind( Value : TScheduleIndexKind)', cdRegister);
    RegisterMethod('Procedure SetIndexValue( Value : Integer)', cdRegister);
    RegisterMethod('Procedure SetDay( Value : Cardinal)', cdRegister);
    RegisterMethod('Procedure SetMonth( Value : Cardinal)', cdRegister);
    RegisterMethod('Procedure SetInterval( Value : Cardinal)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclMonthlySchedule(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'IJclMonthlySchedule') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IJclMonthlySchedule, 'IJclMonthlySchedule') do
  begin
    RegisterMethod('Function GetIndexKind : TScheduleIndexKind', cdRegister);
    RegisterMethod('Function GetIndexValue : Integer', cdRegister);
    RegisterMethod('Function GetDay : Cardinal', cdRegister);
    RegisterMethod('Function GetInterval : Cardinal', cdRegister);
    RegisterMethod('Procedure SetIndexKind( Value : TScheduleIndexKind)', cdRegister);
    RegisterMethod('Procedure SetIndexValue( Value : Integer)', cdRegister);
    RegisterMethod('Procedure SetDay( Value : Cardinal)', cdRegister);
    RegisterMethod('Procedure SetInterval( Value : Cardinal)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclWeeklySchedule(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'IJclWeeklySchedule') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IJclWeeklySchedule, 'IJclWeeklySchedule') do
  begin
    RegisterMethod('Function GetDaysOfWeek : TScheduleWeekDays', cdRegister);
    RegisterMethod('Function GetInterval : Cardinal', cdRegister);
    RegisterMethod('Procedure SetDaysOfWeek( Value : TScheduleWeekDays)', cdRegister);
    RegisterMethod('Procedure SetInterval( Value : Cardinal)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclDailySchedule(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'IJclDailySchedule') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IJclDailySchedule, 'IJclDailySchedule') do
  begin
    RegisterMethod('Function GetEveryWeekDay : Boolean', cdRegister);
    RegisterMethod('Function GetInterval : Cardinal', cdRegister);
    RegisterMethod('Procedure SetEveryWeekDay( Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SetInterval( Value : Cardinal)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclScheduleDayFrequency(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'IJclScheduleDayFrequency') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IJclScheduleDayFrequency, 'IJclScheduleDayFrequency') do
  begin
    RegisterMethod('Function GetStartTime : Cardinal', cdRegister);
    RegisterMethod('Function GetEndTime : Cardinal', cdRegister);
    RegisterMethod('Function GetInterval : Cardinal', cdRegister);
    RegisterMethod('Procedure SetStartTime( Value : Cardinal)', cdRegister);
    RegisterMethod('Procedure SetEndTime( Value : Cardinal)', cdRegister);
    RegisterMethod('Procedure SetInterval( Value : Cardinal)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclSchedule(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'IJclSchedule') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IJclSchedule, 'IJclSchedule') do begin
    RegisterMethod('Function GetStartDate : TTimeStamp', cdRegister);
    RegisterMethod('Function GetRecurringType : TScheduleRecurringKind', cdRegister);
    RegisterMethod('Function GetEndType : TScheduleEndKind', cdRegister);
    RegisterMethod('Function GetEndDate : TTimeStamp', cdRegister);
    RegisterMethod('Function GetEndCount : Cardinal', cdRegister);
    RegisterMethod('Procedure SetStartDate( const Value : TTimeStamp)', cdRegister);
    RegisterMethod('Procedure SetRecurringType( Value : TScheduleRecurringKind)', cdRegister);
    RegisterMethod('Procedure SetEndType( Value : TScheduleEndKind)', cdRegister);
    RegisterMethod('Procedure SetEndDate( const Value : TTimeStamp)', cdRegister);
    RegisterMethod('Procedure SetEndCount( Value : Cardinal)', cdRegister);
    RegisterMethod('Function TriggerCount : Cardinal', cdRegister);
    RegisterMethod('Function DayCount : Cardinal', cdRegister);
    RegisterMethod('Function LastTriggered : TTimeStamp', cdRegister);
    RegisterMethod('Procedure InitToSavedState( const LastTriggerStamp : TTimeStamp; const LastTriggerCount, LastDayCount : Cardinal)', cdRegister);
    RegisterMethod('Procedure Reset', cdRegister);
    RegisterMethod('Function NextEvent( CountMissedEvents : Boolean) : TTimeStamp', cdRegister);
    RegisterMethod('Function NextEventFrom( const FromEvent : TTimeStamp; CountMissedEvent : Boolean) : TTimeStamp', cdRegister);
    RegisterMethod('Function NextEventFromNow( CountMissedEvents : Boolean) : TTimeStamp', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclSchedule(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TScheduleRecurringKind', '( srkOneShot, srkDaily, srkWeekly, srk'
   +'Monthly, srkYearly )');
  CL.AddTypeS('TScheduleEndKind', '( sekNone, sekDate, sekTriggerCount, sekDayCount )');
  CL.AddTypeS('TScheduleWeekDay', '( swdMonday, swdTuesday, swdWednesday, swdTh'
   +'ursday, swdFriday, swdSaturday, swdSunday )');
  CL.AddTypeS('TScheduleWeekDays', 'set of TScheduleWeekDay');
  CL.AddTypeS('TScheduleIndexKind', '( sikNone, sikDay, sikWeekDay, sikWeekendD'
   +'ay, sikMonday, sikTuesday, sikWednesday, sikThursday, sikFriday, sikSaturday, sikSunday )');
 CL.AddConstantN('sivFirst','LongInt').SetInt( 1);
 CL.AddConstantN('sivSecond','LongInt').SetInt( 2);
 CL.AddConstantN('sivThird','LongInt').SetInt( 3);
 CL.AddConstantN('sivFourth','LongInt').SetInt( 4);
 CL.AddConstantN('sivLast','LongInt').SetInt( - 1);
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclSchedule, 'IJclSchedule');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclDailySchedule, 'IJclDailySchedule');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclWeeklySchedule, 'IJclWeeklySchedule');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclMonthlySchedule, 'IJclMonthlySchedule');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclYearlySchedule, 'IJclYearlySchedule');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ESchedule');
  SIRegister_IJclSchedule(CL);
  SIRegister_IJclScheduleDayFrequency(CL);
  SIRegister_IJclDailySchedule(CL);
  SIRegister_IJclWeeklySchedule(CL);
  SIRegister_IJclMonthlySchedule(CL);
  SIRegister_IJclYearlySchedule(CL);
 CL.AddDelphiFunction('Function CreateSchedule : IJclSchedule');
 CL.AddDelphiFunction('Function NullStamp : TTimeStamp');
 CL.AddDelphiFunction('Function CompareTimeStamps( const Stamp1, Stamp2 : TTimeStamp) : Int64');
 CL.AddDelphiFunction('Function EqualTimeStamps( const Stamp1, Stamp2 : TTimeStamp) : Boolean');
 CL.AddDelphiFunction('Function IsNullTimeStamp( const Stamp : TTimeStamp) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JclSchedule_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateSchedule, 'CreateSchedule', cdRegister);
 S.RegisterDelphiFunction(@NullStamp, 'NullStamp', cdRegister);
 S.RegisterDelphiFunction(@CompareTimeStamps, 'CompareTimeStamps', cdRegister);
 S.RegisterDelphiFunction(@EqualTimeStamps, 'EqualTimeStamps', cdRegister);
 S.RegisterDelphiFunction(@IsNullTimeStamp, 'IsNullTimeStamp', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclSchedule(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ESchedule) do
end;

 
 
{ TPSImport_JclSchedule }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSchedule.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclSchedule(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSchedule.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclSchedule_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
