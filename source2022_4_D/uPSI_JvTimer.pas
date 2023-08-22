unit uPSI_JvTimer;
{
  to threaded interrupt
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
  TPSImport_JvTimer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvTimer(CL: TPSPascalCompiler);
procedure SIRegister_JvTimer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvTimer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Messages
  ,ExtCtrls
  ,JvTimer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvTimer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvTimer') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvTimer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Synchronize( Method : TThreadMethod)');
    RegisterProperty('EventTime', 'TJvTimerEventTime', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Interval', 'Cardinal', iptrw);
    RegisterProperty('SyncEvent', 'Boolean', iptrw);
    RegisterProperty('Threaded', 'Boolean', iptrw);
    RegisterProperty('ThreadPriority', 'TThreadPriority', iptrw);
    RegisterProperty('OnTimer', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvTimer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvTimerEventTime', '( tetPre, tetPost )');
  SIRegister_TJvTimer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvTimerOnTimer_W(Self: TJvTimer; const T: TNotifyEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerOnTimer_R(Self: TJvTimer; var T: TNotifyEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerThreadPriority_W(Self: TJvTimer; const T: TThreadPriority);
begin Self.ThreadPriority := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerThreadPriority_R(Self: TJvTimer; var T: TThreadPriority);
begin T := Self.ThreadPriority; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerThreaded_W(Self: TJvTimer; const T: Boolean);
begin Self.Threaded := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerThreaded_R(Self: TJvTimer; var T: Boolean);
begin T := Self.Threaded; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerSyncEvent_W(Self: TJvTimer; const T: Boolean);
begin Self.SyncEvent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerSyncEvent_R(Self: TJvTimer; var T: Boolean);
begin T := Self.SyncEvent; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerInterval_W(Self: TJvTimer; const T: Cardinal);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerInterval_R(Self: TJvTimer; var T: Cardinal);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEnabled_W(Self: TJvTimer; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEnabled_R(Self: TJvTimer; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
{procedure TJvTimerEventTime_W(Self: TJvTimer; const T: TJvTimerEventTime);
begin Self.EventTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventTime_R(Self: TJvTimer; var T: TJvTimerEventTime);
begin T := Self.EventTime; end;}

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTimer) do begin
    RegisterConstructor(@TJvTimer.Create, 'Create');
    RegisterMethod(@TJvTimer.Destroy, 'Free');
    RegisterMethod(@TJvTimer.Synchronize, 'Synchronize');
    //RegisterPropertyHelper(@TJvTimerEventTime_R,@TJvTimerEventTime_W,'EventTime');
    RegisterPropertyHelper(@TJvTimerEnabled_R,@TJvTimerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TJvTimerInterval_R,@TJvTimerInterval_W,'Interval');
    RegisterPropertyHelper(@TJvTimerSyncEvent_R,@TJvTimerSyncEvent_W,'SyncEvent');
    RegisterPropertyHelper(@TJvTimerThreaded_R,@TJvTimerThreaded_W,'Threaded');
    RegisterPropertyHelper(@TJvTimerThreadPriority_R,@TJvTimerThreadPriority_W,'ThreadPriority');
    RegisterPropertyHelper(@TJvTimerOnTimer_R,@TJvTimerOnTimer_W,'OnTimer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvTimer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvTimer(CL);
end;

 
 
{ TPSImport_JvTimer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTimer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvTimer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTimer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvTimer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
