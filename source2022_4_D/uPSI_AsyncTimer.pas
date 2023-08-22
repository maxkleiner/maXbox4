unit uPSI_AsyncTimer;
{
   PLATFORMX
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
  TPSImport_AsyncTimer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAsyncTimer(CL: TPSPascalCompiler);
procedure SIRegister_AsyncTimer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAsyncTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_AsyncTimer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   AsyncTimer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AsyncTimer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAsyncTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TAsyncTimer') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TAsyncTimer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Interval', 'Word', iptrw);
    RegisterProperty('OnTimer', 'TNotifyEvent', iptrw);
    RegisterProperty('ThreadPriority', 'TThreadPriority', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AsyncTimer(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cDEFAULT_TIMER_INTERVAL','LongInt').SetInt( 1000);
  CL.AddTypeS('TThreadPriorityx', 'integer');
  SIRegister_TAsyncTimer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAsyncTimerThreadPriority_W(Self: TAsyncTimer; const T: TThreadPriority);
begin Self.ThreadPriority := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsyncTimerThreadPriority_R(Self: TAsyncTimer; var T: TThreadPriority);
begin T := Self.ThreadPriority; end;

(*----------------------------------------------------------------------------*)
procedure TAsyncTimerOnTimer_W(Self: TAsyncTimer; const T: TNotifyEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsyncTimerOnTimer_R(Self: TAsyncTimer; var T: TNotifyEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TAsyncTimerInterval_W(Self: TAsyncTimer; const T: Word);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsyncTimerInterval_R(Self: TAsyncTimer; var T: Word);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TAsyncTimerEnabled_W(Self: TAsyncTimer; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsyncTimerEnabled_R(Self: TAsyncTimer; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAsyncTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAsyncTimer) do
  begin
    RegisterConstructor(@TAsyncTimer.Create, 'Create');
    RegisterPropertyHelper(@TAsyncTimerEnabled_R,@TAsyncTimerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TAsyncTimerInterval_R,@TAsyncTimerInterval_W,'Interval');
    RegisterPropertyHelper(@TAsyncTimerOnTimer_R,@TAsyncTimerOnTimer_W,'OnTimer');
    RegisterPropertyHelper(@TAsyncTimerThreadPriority_R,@TAsyncTimerThreadPriority_W,'ThreadPriority');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AsyncTimer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAsyncTimer(CL);
end;

 
 
{ TPSImport_AsyncTimer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AsyncTimer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AsyncTimer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AsyncTimer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AsyncTimer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
