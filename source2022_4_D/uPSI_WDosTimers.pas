unit uPSI_WDosTimers;
{
   hp timers  of dos free 
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
  TPSImport_WDosTimers = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRtcIntTimer(CL: TPSPascalCompiler);
procedure SIRegister_TIntTimer(CL: TPSPascalCompiler);
procedure SIRegister_TCustomIntTimer(CL: TPSPascalCompiler);
procedure SIRegister_TwdxRtcTimer(CL: TPSPascalCompiler);
procedure SIRegister_TwdxTimer(CL: TPSPascalCompiler);
procedure SIRegister_TwdxCustomTimer(CL: TPSPascalCompiler);
procedure SIRegister_WDosTimers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_WDosTimers_Routines(S: TPSExec);
procedure RIRegister_TRtcIntTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIntTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomIntTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TwdxRtcTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TwdxTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TwdxCustomTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_WDosTimers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Messages
  ,WDosResStrings
  ,WDosTimers
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WDosTimers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRtcIntTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomIntTimer', 'TRtcIntTimer') do
  with CL.AddClassN(CL.FindClass('TCustomIntTimer'),'TRtcIntTimer') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
      RegisterMethod('Function Instance : TRtcIntTimer');
    RegisterMethod('Procedure ReleaseInstance');
    RegisterProperty('IntFreq', 'TIntFreq', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIntTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomIntTimer', 'TIntTimer') do
  with CL.AddClassN(CL.FindClass('TCustomIntTimer'),'TIntTimer') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
      RegisterMethod('Function Instance : TIntTimer');
    RegisterMethod('Procedure ReleaseInstance');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomIntTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCustomIntTimer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCustomIntTimer') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Disable');
    RegisterMethod('Procedure Enable');
    RegisterMethod('Function Enabled : Boolean');
    RegisterProperty('Interval', 'LongInt', iptrw);
    RegisterProperty('Overrun', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TwdxRtcTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TwdxCustomTimer', 'TwdxRtcTimer') do
  with CL.AddClassN(CL.FindClass('TwdxCustomTimer'),'TwdxRtcTimer') do begin
    RegisterMethod('Constructor Create( aOwner : TComponent)');
  RegisterMethod('Procedure Free');
    RegisterProperty('IntFreq', 'TIntFreq', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TwdxTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TwdxCustomTimer', 'TwdxTimer') do
  with CL.AddClassN(CL.FindClass('TwdxCustomTimer'),'TwdxTimer') do begin
    RegisterMethod('Constructor Create( aOwner : TComponent)');
     RegisterMethod('Procedure Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TwdxCustomTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TwdxCustomTimer') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TwdxCustomTimer') do begin
    RegisterMethod('Constructor Create( aOwner : TComponent)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Process( aInterval : LongInt)');
    RegisterProperty('BaseInterval', 'LongInt', iptr);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Interval', 'Cardinal', iptrw);
    RegisterProperty('Messages', 'Boolean', iptrw);
    RegisterProperty('OnTimer', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTimerInterrupt', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_WDosTimers(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIntFreq', '( ifNone, if32768, if16384, if8192, if4096, if2048, '
   +'if1024, if512, if256, if128, if64, if32, if16, if8, if4, if2 )');
  CL.AddTypeS('DpmiPmVector', 'Int64');
 CL.AddConstantN('DInterval','LongInt').SetInt( 1000);
 //CL.AddConstantN('DEnabled','Boolean')BoolToStr( True);
 CL.AddConstantN('DIntFreq','string').SetString(' if64');
 //CL.AddConstantN('DMessages','Boolean').SetString( if64);
  SIRegister_TwdxCustomTimer(CL);
  SIRegister_TwdxTimer(CL);
  SIRegister_TwdxRtcTimer(CL);
  SIRegister_TCustomIntTimer(CL);
  SIRegister_TIntTimer(CL);
  SIRegister_TRtcIntTimer(CL);
 CL.AddDelphiFunction('Function RealNow : TDateTime');
 CL.AddDelphiFunction('Function MsToDateTime( MilliSecond : LongInt) : TDateTime');
 CL.AddDelphiFunction('Function milliToDateTime( MilliSecond : LongInt) : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToMs( Time : TDateTime) : LongInt');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRtcIntTimerIntFreq_W(Self: TRtcIntTimer; const T: TIntFreq);
begin Self.IntFreq := T; end;

(*----------------------------------------------------------------------------*)
procedure TRtcIntTimerIntFreq_R(Self: TRtcIntTimer; var T: TIntFreq);
begin T := Self.IntFreq; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIntTimerOverrun_W(Self: TCustomIntTimer; const T: Boolean);
begin Self.Overrun := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIntTimerOverrun_R(Self: TCustomIntTimer; var T: Boolean);
begin T := Self.Overrun; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIntTimerInterval_W(Self: TCustomIntTimer; const T: LongInt);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIntTimerInterval_R(Self: TCustomIntTimer; var T: LongInt);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TwdxRtcTimerIntFreq_W(Self: TwdxRtcTimer; const T: TIntFreq);
begin Self.IntFreq := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxRtcTimerIntFreq_R(Self: TwdxRtcTimer; var T: TIntFreq);
begin T := Self.IntFreq; end;

(*----------------------------------------------------------------------------*)
procedure TwdxCustomTimerOnTimerInterrupt_W(Self: TwdxCustomTimer; const T: TNotifyEvent);
begin Self.OnTimerInterrupt := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxCustomTimerOnTimerInterrupt_R(Self: TwdxCustomTimer; var T: TNotifyEvent);
begin T := Self.OnTimerInterrupt; end;

(*----------------------------------------------------------------------------*)
procedure TwdxCustomTimerOnTimer_W(Self: TwdxCustomTimer; const T: TNotifyEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxCustomTimerOnTimer_R(Self: TwdxCustomTimer; var T: TNotifyEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TwdxCustomTimerMessages_W(Self: TwdxCustomTimer; const T: Boolean);
begin Self.Messages := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxCustomTimerMessages_R(Self: TwdxCustomTimer; var T: Boolean);
begin T := Self.Messages; end;

(*----------------------------------------------------------------------------*)
procedure TwdxCustomTimerInterval_W(Self: TwdxCustomTimer; const T: Cardinal);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxCustomTimerInterval_R(Self: TwdxCustomTimer; var T: Cardinal);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TwdxCustomTimerEnabled_W(Self: TwdxCustomTimer; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxCustomTimerEnabled_R(Self: TwdxCustomTimer; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TwdxCustomTimerBaseInterval_R(Self: TwdxCustomTimer; var T: LongInt);
begin T := Self.BaseInterval; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WDosTimers_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@RealNow, 'RealNow', cdRegister);
 S.RegisterDelphiFunction(@MsToDateTime, 'MsToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToMs, 'DateTimeToMs', cdRegister);
 S.RegisterDelphiFunction(@MsToDateTime, 'millitoDateTime', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRtcIntTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRtcIntTimer) do begin
    RegisterConstructor(@TRtcIntTimer.Create, 'Create');
     RegisterMethod(@TRtcIntTimer.Destroy, 'Free');
    RegisterMethod(@TRtcIntTimer.Instance, 'Instance');
    RegisterMethod(@TRtcIntTimer.ReleaseInstance, 'ReleaseInstance');
    RegisterPropertyHelper(@TRtcIntTimerIntFreq_R,@TRtcIntTimerIntFreq_W,'IntFreq');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIntTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIntTimer) do begin
    RegisterConstructor(@TIntTimer.Create, 'Create');
     RegisterMethod(@TIntTimer.Destroy, 'Free');
      RegisterMethod(@TIntTimer.Instance, 'Instance');
    RegisterMethod(@TIntTimer.ReleaseInstance, 'ReleaseInstance');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomIntTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomIntTimer) do begin
    RegisterConstructor(@TCustomIntTimer.Create, 'Create');
    RegisterMethod(@TCustomIntTimer.Destroy, 'Free');
    RegisterMethod(@TCustomIntTimer.Disable, 'Disable');
    RegisterMethod(@TCustomIntTimer.Enable, 'Enable');
    RegisterMethod(@TCustomIntTimer.Enabled, 'Enabled');
    RegisterPropertyHelper(@TCustomIntTimerInterval_R,@TCustomIntTimerInterval_W,'Interval');
    RegisterPropertyHelper(@TCustomIntTimerOverrun_R,@TCustomIntTimerOverrun_W,'Overrun');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TwdxRtcTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TwdxRtcTimer) do begin
    RegisterConstructor(@TwdxRtcTimer.Create, 'Create');
     RegisterMethod(@TwdxRtcTimer.Destroy, 'Free');
      RegisterPropertyHelper(@TwdxRtcTimerIntFreq_R,@TwdxRtcTimerIntFreq_W,'IntFreq');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TwdxTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TwdxTimer) do begin
    RegisterConstructor(@TwdxTimer.Create, 'Create');
    RegisterMethod(@Twdxtimer.Destroy, 'Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TwdxCustomTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TwdxCustomTimer) do
  begin
    RegisterConstructor(@TwdxCustomTimer.Create, 'Create');
    RegisterMethod(@TwdxCustomTimer.Process, 'Process');
    RegisterPropertyHelper(@TwdxCustomTimerBaseInterval_R,nil,'BaseInterval');
    RegisterPropertyHelper(@TwdxCustomTimerEnabled_R,@TwdxCustomTimerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TwdxCustomTimerInterval_R,@TwdxCustomTimerInterval_W,'Interval');
    RegisterPropertyHelper(@TwdxCustomTimerMessages_R,@TwdxCustomTimerMessages_W,'Messages');
    RegisterPropertyHelper(@TwdxCustomTimerOnTimer_R,@TwdxCustomTimerOnTimer_W,'OnTimer');
    RegisterPropertyHelper(@TwdxCustomTimerOnTimerInterrupt_R,@TwdxCustomTimerOnTimerInterrupt_W,'OnTimerInterrupt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WDosTimers(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TwdxCustomTimer(CL);
  RIRegister_TwdxTimer(CL);
  RIRegister_TwdxRtcTimer(CL);
  RIRegister_TCustomIntTimer(CL);
  RIRegister_TIntTimer(CL);
  RIRegister_TRtcIntTimer(CL);
end;

 
 
{ TPSImport_WDosTimers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosTimers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WDosTimers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosTimers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WDosTimers(ri);
  RIRegister_WDosTimers_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
