unit uPSI_BoldThread;
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
  TPSImport_BoldThread = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBoldNotifiableThread(CL: TPSPascalCompiler);
procedure SIRegister_BoldThread(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BoldThread_Routines(S: TPSExec);
procedure RIRegister_TBoldNotifiableThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_BoldThread(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Syncobjs
  ,BoldThread
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BoldThread]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldNotifiableThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TBoldNotifiableThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TBoldNotifiableThread') do begin
    RegisterMethod('Constructor Create( CreateSuspended : Boolean)');
    RegisterMethod('Procedure Execute');
    RegisterMethod('Function WaitUntilReady( dwMilliseconds : Cardinal) : Boolean');
    RegisterMethod('Function WaitUntilSignaled( dwMilliseconds : Cardinal) : LongWord');
    RegisterMethod('Procedure Notify( const Msg : Cardinal)');
    RegisterMethod('Function Quit( Wait : Boolean) : Boolean');
    RegisterMethod('Function WaitForQuit : Boolean');
    RegisterProperty('QuitWaitTimeOut', 'integer', iptrw);
    RegisterProperty('QueueWindow', 'HWnd', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BoldThread(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldNotifiableThread');
  SIRegister_TBoldNotifiableThread(CL);
 CL.AddDelphiFunction('Function WaitForObject( iHandle : THandle; iTimeOut : dWord) : TWaitResult');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBoldNotifiableThreadQueueWindow_R(Self: TBoldNotifiableThread; var T: HWnd);
begin T := Self.QueueWindow; end;

(*----------------------------------------------------------------------------*)
procedure TBoldNotifiableThreadQuitWaitTimeOut_W(Self: TBoldNotifiableThread; const T: integer);
begin Self.QuitWaitTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoldNotifiableThreadQuitWaitTimeOut_R(Self: TBoldNotifiableThread; var T: integer);
begin T := Self.QuitWaitTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldThread_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@WaitForObject, 'WaitForObject', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldNotifiableThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldNotifiableThread) do begin
    RegisterConstructor(@TBoldNotifiableThread.Create, 'Create');
    RegisterMethod(@TBoldNotifiableThread.Execute, 'Execute');
    RegisterMethod(@TBoldNotifiableThread.WaitUntilReady, 'WaitUntilReady');
    RegisterMethod(@TBoldNotifiableThread.WaitUntilSignaled, 'WaitUntilSignaled');
    RegisterMethod(@TBoldNotifiableThread.Notify, 'Notify');
    RegisterVirtualMethod(@TBoldNotifiableThread.Quit, 'Quit');
    RegisterMethod(@TBoldNotifiableThread.WaitForQuit, 'WaitForQuit');
    RegisterPropertyHelper(@TBoldNotifiableThreadQuitWaitTimeOut_R,@TBoldNotifiableThreadQuitWaitTimeOut_W,'QuitWaitTimeOut');
    RegisterPropertyHelper(@TBoldNotifiableThreadQueueWindow_R,nil,'QueueWindow');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldNotifiableThread) do
  RIRegister_TBoldNotifiableThread(CL);
end;

 
 
{ TPSImport_BoldThread }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldThread.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BoldThread(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldThread.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BoldThread(ri);
  RIRegister_BoldThread_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
