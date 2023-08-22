unit uPSI_JvThreadTimer;
{
   jv of a thread time slices when the river runs dry
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
  TPSImport_JvThreadTimer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvThreadTimer(CL: TPSPascalCompiler);
procedure SIRegister_JvThreadTimer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvThreadTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvThreadTimer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  //,QWindows
  ,JvTypes
  ,JvComponent
  ,JvThreadTimer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvThreadTimer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvThreadTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvThreadTimer') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvThreadTimer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
        RegisterMethod('Procedure Free');
    RegisterProperty('Thread', 'TThread', iptr);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Interval', 'Cardinal', iptrw);
    RegisterProperty('KeepAlive', 'Boolean', iptrw);
    RegisterProperty('OnTimer', 'TNotifyEvent', iptrw);
    RegisterProperty('Priority', 'TThreadPriority', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvThreadTimer(CL: TPSPascalCompiler);
begin
  SIRegister_TJvThreadTimer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvThreadTimerPriority_W(Self: TJvThreadTimer; const T: TThreadPriority);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvThreadTimerPriority_R(Self: TJvThreadTimer; var T: TThreadPriority);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
procedure TJvThreadTimerOnTimer_W(Self: TJvThreadTimer; const T: TNotifyEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvThreadTimerOnTimer_R(Self: TJvThreadTimer; var T: TNotifyEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TJvThreadTimerKeepAlive_W(Self: TJvThreadTimer; const T: Boolean);
begin Self.KeepAlive := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvThreadTimerKeepAlive_R(Self: TJvThreadTimer; var T: Boolean);
begin T := Self.KeepAlive; end;

(*----------------------------------------------------------------------------*)
procedure TJvThreadTimerInterval_W(Self: TJvThreadTimer; const T: Cardinal);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvThreadTimerInterval_R(Self: TJvThreadTimer; var T: Cardinal);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TJvThreadTimerEnabled_W(Self: TJvThreadTimer; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvThreadTimerEnabled_R(Self: TJvThreadTimer; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TJvThreadTimerThread_R(Self: TJvThreadTimer; var T: TThread);
begin T := Self.Thread; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvThreadTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvThreadTimer) do
  begin
    RegisterConstructor(@TJvThreadTimer.Create, 'Create');
    RegisterPropertyHelper(@TJvThreadTimerThread_R,nil,'Thread');
       RegisterMethod(@TJvThreadTimer.Destroy, 'Free');
      RegisterPropertyHelper(@TJvThreadTimerEnabled_R,@TJvThreadTimerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TJvThreadTimerInterval_R,@TJvThreadTimerInterval_W,'Interval');
    RegisterPropertyHelper(@TJvThreadTimerKeepAlive_R,@TJvThreadTimerKeepAlive_W,'KeepAlive');
    RegisterPropertyHelper(@TJvThreadTimerOnTimer_R,@TJvThreadTimerOnTimer_W,'OnTimer');
    RegisterPropertyHelper(@TJvThreadTimerPriority_R,@TJvThreadTimerPriority_W,'Priority');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvThreadTimer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvThreadTimer(CL);
end;

 
 
{ TPSImport_JvThreadTimer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvThreadTimer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvThreadTimer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvThreadTimer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvThreadTimer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
