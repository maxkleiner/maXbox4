unit uPSI_UThread;
{
Tthread for coin  or background worker

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
  TPSImport_UThread = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPCThreadList(CL: TPSPascalCompiler);
procedure SIRegister_TPCThread(CL: TPSPascalCompiler);
procedure SIRegister_TPCCriticalSection(CL: TPSPascalCompiler);
procedure SIRegister_UThread(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPCThreadList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPCThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPCCriticalSection(CL: TPSRuntimeClassImporter);
procedure RIRegister_UThread(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  //,cthreads
  ,SyncObjs
  ,UThread
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UThread]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPCThreadList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPCThreadList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPCThreadList') do begin
    RegisterMethod('Constructor Create( const AName : String)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function Add( Item : Pointer) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Remove( Item : Pointer)');
    RegisterMethod('Function LockList : TList');
    RegisterMethod('Function TryLockList( MaxWaitMilliseconds : Cardinal; var lockedList : TList) : Boolean');
    RegisterMethod('Procedure UnlockList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPCThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TPCThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TPCThread') do
  begin
    RegisterMethod('Function ThreadClassFound( tclass : TPCThreadClass; Exclude : TObject) : Integer');
    RegisterMethod('Function ThreadCount : Integer');
    RegisterMethod('Function GetThread( index : Integer) : TPCThread');
    RegisterMethod('Function GetThreadByClass( tclass : TPCThreadClass; Exclude : TObject) : TPCThread');
    RegisterMethod('Procedure ProtectEnterCriticalSection( const Sender : TObject; var Lock : TPCCriticalSection)');
    RegisterMethod('Function TryProtectEnterCriticalSection( const Sender : TObject; MaxWaitMilliseconds : Cardinal; var Lock : TPCCriticalSection) : Boolean');
    RegisterMethod('Procedure ThreadsListInfo( list : TStrings)');
    RegisterMethod('Constructor Create( CreateSuspended : Boolean)');
      RegisterMethod('Procedure Free');
      RegisterProperty('DebugStep', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPCCriticalSection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCriticalSection', 'TPCCriticalSection') do
  with CL.AddClassN(CL.FindClass('TCriticalSection'),'TPCCriticalSection') do
  begin
    RegisterMethod('Constructor Create( const AName : String)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Acquire');
    RegisterMethod('Procedure Release');
    RegisterMethod('Function TryEnter : Boolean');
    RegisterProperty('CurrentThread', 'Cardinal', iptr);
    RegisterProperty('WaitingForCounter', 'Integer', iptr);
    RegisterProperty('StartedTimestamp', 'Cardinal', iptr);
    RegisterProperty('Name', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UThread(CL: TPSPascalCompiler);
begin
  SIRegister_TPCCriticalSection(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPCThread');
  //CL.AddTypeS('TPCThreadClass', 'class of TPCThread');
  SIRegister_TPCThread(CL);
  SIRegister_TPCThreadList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPCThreadDebugStep_W(Self: TPCThread; const T: String);
begin Self.DebugStep := T; end;

(*----------------------------------------------------------------------------*)
procedure TPCThreadDebugStep_R(Self: TPCThread; var T: String);
begin T := Self.DebugStep; end;


(*----------------------------------------------------------------------------*)
procedure TPCThreadTerminated_W(Self: TPCThread; const T: boolean);
begin //Self.Terminated := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPCThreadTerminated_R(Self: TPCThread; var T: boolean);
begin T := Self.Terminated; end;


(*----------------------------------------------------------------------------*)
procedure TPCCriticalSectionName_R(Self: TPCCriticalSection; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TPCCriticalSectionStartedTimestamp_R(Self: TPCCriticalSection; var T: Cardinal);
begin T := Self.StartedTimestamp; end;

(*----------------------------------------------------------------------------*)
procedure TPCCriticalSectionWaitingForCounter_R(Self: TPCCriticalSection; var T: Integer);
begin T := Self.WaitingForCounter; end;

(*----------------------------------------------------------------------------*)
procedure TPCCriticalSectionCurrentThread_R(Self: TPCCriticalSection; var T: Cardinal);
begin T := Self.CurrentThread; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPCThreadList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPCThreadList) do begin
    RegisterConstructor(@TPCThreadList.Create, 'Create');
      RegisterMethod(@TPCThreadList.Destroy, 'Free');

    RegisterMethod(@TPCThreadList.Add, 'Add');
    RegisterMethod(@TPCThreadList.Clear, 'Clear');
    RegisterMethod(@TPCThreadList.Remove, 'Remove');
    RegisterMethod(@TPCThreadList.LockList, 'LockList');
    RegisterMethod(@TPCThreadList.TryLockList, 'TryLockList');
    RegisterMethod(@TPCThreadList.UnlockList, 'UnlockList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPCThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPCThread) do begin
    RegisterMethod(@TPCThread.ThreadClassFound, 'ThreadClassFound');
    RegisterMethod(@TPCThread.ThreadCount, 'ThreadCount');
    RegisterMethod(@TPCThread.GetThread, 'GetThread');
    RegisterMethod(@TPCThread.GetThreadByClass, 'GetThreadByClass');
    RegisterMethod(@TPCThread.ProtectEnterCriticalSection, 'ProtectEnterCriticalSection');
    RegisterMethod(@TPCThread.TryProtectEnterCriticalSection, 'TryProtectEnterCriticalSection');
    RegisterMethod(@TPCThread.ThreadsListInfo, 'ThreadsListInfo');
    RegisterConstructor(@TPCThread.Create, 'Create');
      RegisterMethod(@TPCThread.Destroy, 'Free');
    RegisterPropertyHelper(@TPCThreadTerminated_R,@TPCThreadTerminated_W,'Terminated');

    RegisterPropertyHelper(@TPCThreadDebugStep_R,@TPCThreadDebugStep_W,'DebugStep');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPCCriticalSection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPCCriticalSection) do begin
    RegisterConstructor(@TPCCriticalSection.Create, 'Create');
      RegisterMethod(@TPCCriticalSection.Destroy, 'Free');

    RegisterMethod(@TPCCriticalSection.Acquire, 'Acquire');
    RegisterMethod(@TPCCriticalSection.Release, 'Release');
    RegisterMethod(@TPCCriticalSection.TryEnter, 'TryEnter');
    RegisterPropertyHelper(@TPCCriticalSectionCurrentThread_R,nil,'CurrentThread');
    RegisterPropertyHelper(@TPCCriticalSectionWaitingForCounter_R,nil,'WaitingForCounter');
    RegisterPropertyHelper(@TPCCriticalSectionStartedTimestamp_R,nil,'StartedTimestamp');
    RegisterPropertyHelper(@TPCCriticalSectionName_R,nil,'Name');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UThread(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPCCriticalSection(CL);
  with CL.Add(TPCThread) do
  RIRegister_TPCThread(CL);
  RIRegister_TPCThreadList(CL);
end;

 
 
{ TPSImport_UThread }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UThread.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UThread(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UThread.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UThread(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
