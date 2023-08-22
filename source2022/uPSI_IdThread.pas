unit uPSI_IdThread;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_IdThread = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdThread(CL: TPSPascalCompiler);
procedure SIRegister_TIdBaseThread(CL: TPSPascalCompiler);
procedure SIRegister_IdThread(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdBaseThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdThread(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdException
  ,IdGlobal
  ,SyncObjs
  ,IdThread
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdThread]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseThread', 'TIdThread') do
  with CL.AddClassN(CL.FindClass('TIdBaseThread'),'TIdThread') do begin
    RegisterMethod('Constructor Create( ACreateSuspended : Boolean)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Execute');
    RegisterMethod('Procedure Start');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure Terminate');
    RegisterMethod('Procedure TerminateAndWaitFor');
    RegisterProperty('Data', 'TObject', iptrw);
    RegisterProperty('StopMode', 'TIdThreadStopMode', iptrw);
    RegisterProperty('Stopped', 'Boolean', iptr);
    RegisterProperty('TerminatingException', 'string', iptr);
    RegisterProperty('TerminatingExceptionClass', 'TClass', iptr);
    RegisterProperty('OnException', 'TIdExceptionThreadEvent', iptrw);
    RegisterProperty('OnStopped', 'TIdNotifyThreadEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdBaseThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TIdBaseThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TIdBaseThread') do begin
    RegisterMethod('Procedure Synchronize( Method : TThreadMethod);');
    RegisterMethod('Procedure Synchronize1( Method : TMethod);');
    RegisterProperty('Terminated', 'Boolean', iptr);
    RegisterProperty('returnvalue', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdThread(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdThreadException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdThreadTerminateAndWaitFor');
  CL.AddTypeS('TIdThreadStopMode', '( smTerminate, smSuspend )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdThread');
  //CL.AddTypeS('TIdExceptionThreadEvent', 'Procedure ( AThread : TIdThread; AExc'
  // +'eption : Exception)');
  CL.AddTypeS('TIdNotifyThreadEvent', 'Procedure ( AThread : TIdThread)');
  //CL.AddTypeS('TIdSynchronizeThreadEvent', 'Procedure ( AThread : TIdThread; AD'
   //+'ata : Pointer)');
  SIRegister_TIdBaseThread(CL);
  SIRegister_TIdThread(CL);
  //CL.AddTypeS('TIdThreadClass', 'class of TIdThread');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdThreadOnStopped_W(Self: TIdThread; const T: TIdNotifyThreadEvent);
begin Self.OnStopped := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadOnStopped_R(Self: TIdThread; var T: TIdNotifyThreadEvent);
begin T := Self.OnStopped; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadOnException_W(Self: TIdThread; const T: TIdExceptionThreadEvent);
begin Self.OnException := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadOnException_R(Self: TIdThread; var T: TIdExceptionThreadEvent);
begin T := Self.OnException; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadTerminatingExceptionClass_R(Self: TIdThread; var T: TClass);
begin T := Self.TerminatingExceptionClass; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadTerminatingException_R(Self: TIdThread; var T: string);
begin T := Self.TerminatingException; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadStopped_R(Self: TIdThread; var T: Boolean);
begin T := Self.Stopped; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadStopMode_W(Self: TIdThread; const T: TIdThreadStopMode);
begin Self.StopMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadStopMode_R(Self: TIdThread; var T: TIdThreadStopMode);
begin T := Self.StopMode; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadData_W(Self: TIdThread; const T: TObject);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadData_R(Self: TIdThread; var T: TObject);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
Procedure TIdBaseThreadSynchronize1_P(Self: TIdBaseThread;  Method : TMethod);
Begin Self.Synchronize(Method); END;

(*----------------------------------------------------------------------------*)
Procedure TIdBaseThreadSynchronize_P(Self: TIdBaseThread;  Method : TThreadMethod);
Begin Self.Synchronize(Method); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdThread) do begin
    RegisterVirtualConstructor(@TIdThread.Create, 'Create');
    RegisterMethod(@TIdThread.Destroy, 'Free');
    //RegisterMethod(@TIdThread.Execute, 'Execute');

    RegisterVirtualMethod(@TIdThread.Start, 'Start');
    RegisterVirtualMethod(@TIdThread.Stop, 'Stop');
    RegisterVirtualMethod(@TIdThread.Terminate, 'Terminate');
    RegisterVirtualMethod(@TIdThread.TerminateAndWaitFor, 'TerminateAndWaitFor');
    RegisterPropertyHelper(@TIdThreadData_R,@TIdThreadData_W,'Data');
    RegisterPropertyHelper(@TIdThreadStopMode_R,@TIdThreadStopMode_W,'StopMode');
    RegisterPropertyHelper(@TIdThreadStopped_R,nil,'Stopped');
    RegisterPropertyHelper(@TIdThreadTerminatingException_R,nil,'TerminatingException');
    RegisterPropertyHelper(@TIdThreadTerminatingExceptionClass_R,nil,'TerminatingExceptionClass');
    RegisterPropertyHelper(@TIdThreadOnException_R,@TIdThreadOnException_W,'OnException');
    RegisterPropertyHelper(@TIdThreadOnStopped_R,@TIdThreadOnStopped_W,'OnStopped');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TIdBaseThreadTerminated_R(Self: TIdBaseThread; var T: Boolean);
begin T := Self.Terminated; end;

(*----------------------------------------------------------------------------*)
procedure TIdBaseThreadReturnValue_R(Self: TIdBaseThread; var T: Integer);
begin T := Self.Returnvalue; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdBaseThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdBaseThread) do begin
    RegisterMethod(@TIdBaseThreadSynchronize_P, 'Synchronize');
    RegisterMethod(@TIdBaseThreadSynchronize1_P, 'Synchronize1');
    RegisterPropertyHelper(@TIdBaseThreadTerminated_R,nil,'Terminated');
    RegisterPropertyHelper(@TIdBaseThreadreturnvalue_R,nil,'ReturnValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EIdThreadException) do
  with CL.Add(EIdThreadTerminateAndWaitFor) do
  with CL.Add(TIdThread) do
  RIRegister_TIdBaseThread(CL);
  RIRegister_TIdThread(CL);
end;

 
 
{ TPSImport_IdThread }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdThread.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdThread(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdThread.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdThread(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.