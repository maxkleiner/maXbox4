unit uPSI_IdThreadMgr;
{
man age 2016   add free freeze

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
  TPSImport_IdThreadMgr = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdThreadMgr(CL: TPSPascalCompiler);
procedure SIRegister_IdThreadMgr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdThreadMgr(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdThreadMgr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdException
  ,IdBaseComponent
  ,IdGlobal
  ,IdThread
  ,SyncObjs
  ,IdThreadMgr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdThreadMgr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdThreadMgr(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdThreadMgr') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdThreadMgr') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
      RegisterMethod('Function CreateNewThread : TIdThread');
    RegisterMethod('Function GetThread : TIdThread');
    RegisterMethod('Procedure ReleaseThread( AThread : TIdThread)');
    RegisterMethod('Procedure TerminateThreads');
    RegisterProperty('ActiveThreads', 'TThreadList', iptr);
    RegisterProperty('ThreadClass', 'TIdThreadClass', iptrw);
    RegisterProperty('ThreadPriority', 'TIdThreadPriority', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdThreadMgr(CL: TPSPascalCompiler);
begin
  SIRegister_TIdThreadMgr(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdThreadMgrError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdThreadClassNotSpecified');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdThreadMgrThreadPriority_W(Self: TIdThreadMgr; const T: TIdThreadPriority);
begin Self.ThreadPriority := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadMgrThreadPriority_R(Self: TIdThreadMgr; var T: TIdThreadPriority);
begin T := Self.ThreadPriority; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadMgrThreadClass_W(Self: TIdThreadMgr; const T: TIdThreadClass);
begin Self.ThreadClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadMgrThreadClass_R(Self: TIdThreadMgr; var T: TIdThreadClass);
begin T := Self.ThreadClass; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadMgrActiveThreads_R(Self: TIdThreadMgr; var T: TThreadList);
begin T := Self.ActiveThreads; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdThreadMgr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdThreadMgr) do begin
    RegisterConstructor(@TIdThreadMgr.Create, 'Create');
             RegisterMethod(@TIdThreadMgr.Destroy, 'Free');
     RegisterVirtualMethod(@TIdThreadMgr.CreateNewThread, 'CreateNewThread');
    //RegisterVirtualAbstractMethod(@TIdThreadMgr, @!.GetThread, 'GetThread');
    //RegisterVirtualAbstractMethod(@TIdThreadMgr, @!.ReleaseThread, 'ReleaseThread');
    RegisterVirtualMethod(@TIdThreadMgr.TerminateThreads, 'TerminateThreads');
    RegisterPropertyHelper(@TIdThreadMgrActiveThreads_R,nil,'ActiveThreads');
    RegisterPropertyHelper(@TIdThreadMgrThreadClass_R,@TIdThreadMgrThreadClass_W,'ThreadClass');
    RegisterPropertyHelper(@TIdThreadMgrThreadPriority_R,@TIdThreadMgrThreadPriority_W,'ThreadPriority');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdThreadMgr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdThreadMgr(CL);
  with CL.Add(EIdThreadMgrError) do
  with CL.Add(EIdThreadClassNotSpecified) do
end;

 
 
{ TPSImport_IdThreadMgr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdThreadMgr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdThreadMgr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdThreadMgr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdThreadMgr(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
