unit uPSI_PXLTiming;
{
multimedia2 and some time last     TMultimediaTimer2

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
  TPSImport_PXLTiming = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMultimediaTimer2(CL: TPSPascalCompiler);
procedure SIRegister_PXLTiming(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PXLTiming_Routines(S: TPSExec);
procedure RIRegister_TMultimediaTimer2(CL: TPSRuntimeClassImporter);
procedure RIRegister_PXLTiming(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   PXLTiming
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PXLTiming]);
end;

type  TTimerEvent = procedure(const Sender: TObject) of object;
type  TMultimediaTimer2 = PXLTiming.TMultimediaTimer;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMultimediaTimer2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMultimediaTimer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMultimediaTimer2') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Process');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Procedure NotifyTick( AllowSleep : Boolean)');
    RegisterProperty('Delta', 'Double', iptr);
    RegisterProperty('Latency', 'Double', iptr);
    RegisterProperty('FrameRate', 'Integer', iptr);
    RegisterProperty('Speed', 'Double', iptrw);
    RegisterProperty('MaxFPS', 'Integer', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('SingleCallOnly', 'Boolean', iptrw);
    RegisterProperty('OnTimer', 'TTimerEvent', iptrw);
    RegisterProperty('OnProcess', 'TTimerEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PXLTiming(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('OverrunDeltaLimit','Extended').setExtended( 8.0);
  CL.AddTypeS('TTimerEvent', 'Procedure ( const Sender : TObject)');
  SIRegister_TMultimediaTimer2(CL);
  CL.AddTypeS('TSystemTimerValue', 'UInt64');
 CL.AddDelphiFunction('Function TimerValueInBetween( const Value1, Value2 : TSystemTimerValue) : TSystemTimerValue');
 CL.AddDelphiFunction('Function TickCountInBetween( const Value1, Value2 : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function GetSystemTimerValue : TSystemTimerValue');
 CL.AddDelphiFunction('Function GetSystemTickCount : Cardinal');
 CL.AddDelphiFunction('Function GetSystemTimeValue : Double');
 CL.AddDelphiFunction('Procedure MicroSleep( const Microseconds : UInt64)');
 CL.AddDelphiFunction('Function TCPGetTick : LongWord');
 CL.AddDelphiFunction('Function TCPTickDelta( const D1, D2 : LongWord) : Integer');
 CL.AddDelphiFunction('Function TCPTickDeltaW( const D1, D2 : LongWord) : LongWord');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerOnProcess_W(Self: TMultimediaTimer2; const T: TTimerEvent);
begin Self.OnProcess := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerOnProcess_R(Self: TMultimediaTimer2; var T: TTimerEvent);
begin T := Self.OnProcess; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerOnTimer_W(Self: TMultimediaTimer2; const T: TTimerEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerOnTimer_R(Self: TMultimediaTimer2; var T: TTimerEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerSingleCallOnly_W(Self: TMultimediaTimer2; const T: Boolean);
begin Self.SingleCallOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerSingleCallOnly_R(Self: TMultimediaTimer2; var T: Boolean);
begin T := Self.SingleCallOnly; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerEnabled_W(Self: TMultimediaTimer2; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerEnabled_R(Self: TMultimediaTimer2; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerMaxFPS_W(Self: TMultimediaTimer2; const T: Integer);
begin Self.MaxFPS := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerMaxFPS_R(Self: TMultimediaTimer2; var T: Integer);
begin T := Self.MaxFPS; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerSpeed_W(Self: TMultimediaTimer2; const T: Double);
begin Self.Speed := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerSpeed_R(Self: TMultimediaTimer2; var T: Double);
begin T := Self.Speed; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerFrameRate_R(Self: TMultimediaTimer2; var T: Integer);
begin T := Self.FrameRate; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerLatency_R(Self: TMultimediaTimer2; var T: Double);
begin T := Self.Latency; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerDelta_R(Self: TMultimediaTimer2; var T: Double);
begin T := Self.Delta; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PXLTiming_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TimerValueInBetween, 'TimerValueInBetween', cdRegister);
 S.RegisterDelphiFunction(@TickCountInBetween, 'TickCountInBetween', cdRegister);
 S.RegisterDelphiFunction(@GetSystemTimerValue, 'GetSystemTimerValue', cdRegister);
 S.RegisterDelphiFunction(@GetSystemTickCount, 'GetSystemTickCount', cdRegister);
 S.RegisterDelphiFunction(@GetSystemTimeValue, 'GetSystemTimeValue', cdRegister);
 S.RegisterDelphiFunction(@MicroSleep, 'MicroSleep', cdRegister);
  S.RegisterDelphiFunction(@TCPGetTick, 'TCPGetTick', cdRegister);
 S.RegisterDelphiFunction(@TCPTickDelta, 'TCPTickDelta', cdRegister);
 S.RegisterDelphiFunction(@TCPTickDeltaW, 'TCPTickDeltaW', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMultimediaTimer2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMultimediaTimer2) do
  begin
    RegisterConstructor(@TMultimediaTimer.Create, 'Create');
    RegisterMethod(@TMultimediaTimer.Process, 'Process');
    RegisterMethod(@TMultimediaTimer.Reset, 'Reset');
    RegisterMethod(@TMultimediaTimer.NotifyTick, 'NotifyTick');
    RegisterPropertyHelper(@TMultimediaTimerDelta_R,nil,'Delta');
    RegisterPropertyHelper(@TMultimediaTimerLatency_R,nil,'Latency');
    RegisterPropertyHelper(@TMultimediaTimerFrameRate_R,nil,'FrameRate');
    RegisterPropertyHelper(@TMultimediaTimerSpeed_R,@TMultimediaTimerSpeed_W,'Speed');
    RegisterPropertyHelper(@TMultimediaTimerMaxFPS_R,@TMultimediaTimerMaxFPS_W,'MaxFPS');
    RegisterPropertyHelper(@TMultimediaTimerEnabled_R,@TMultimediaTimerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TMultimediaTimerSingleCallOnly_R,@TMultimediaTimerSingleCallOnly_W,'SingleCallOnly');
    RegisterPropertyHelper(@TMultimediaTimerOnTimer_R,@TMultimediaTimerOnTimer_W,'OnTimer');
    RegisterPropertyHelper(@TMultimediaTimerOnProcess_R,@TMultimediaTimerOnProcess_W,'OnProcess');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PXLTiming(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMultimediaTimer2(CL);
end;



{ TPSImport_PXLTiming }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PXLTiming.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PXLTiming(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PXLTiming.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PXLTiming(ri);
  RIRegister_PXLTiming_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
