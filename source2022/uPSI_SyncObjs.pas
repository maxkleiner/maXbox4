unit uPSI_SyncObjs;
{
  to get async and parallel
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
  TPSImport_SyncObjs = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCriticalSection(CL: TPSPascalCompiler);
procedure SIRegister_TMutex(CL: TPSPascalCompiler);
procedure SIRegister_TEvent(CL: TPSPascalCompiler);
procedure SIRegister_THandleObject(CL: TPSPascalCompiler);
procedure SIRegister_TSynchroObject(CL: TPSPascalCompiler);
procedure SIRegister_SyncObjs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCriticalSection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMutex(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_THandleObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynchroObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_SyncObjs(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  //,Libc
  ,SyncObjs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SyncObjs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCriticalSection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynchroObject', 'TCriticalSection') do
  with CL.AddClassN(CL.FindClass('TSynchroObject'),'TCriticalSection') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function TryEnter : Boolean');
    RegisterMethod('Procedure Enter');
    RegisterMethod('Procedure Leave');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMutex(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THandleObject', 'TMutex') do
  with CL.AddClassN(CL.FindClass('THandleObject'),'TMutex') do begin
    RegisterMethod('Constructor Create( UseCOMWait : Boolean);');
    RegisterMethod('Constructor Create1( MutexAttributes : PSecurityAttributes; InitialOwner : Boolean; const Name : string; UseCOMWait : Boolean);');
    RegisterMethod('Constructor Create2( DesiredAccess : LongWord; InheritHandle : Boolean; const Name : string; UseCOMWait : Boolean);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THandleObject', 'TEvent') do
  with CL.AddClassN(CL.FindClass('THandleObject'),'TEvent') do begin
    RegisterMethod('Constructor Create( EventAttributes : PSecurityAttributes; ManualReset, InitialState : Boolean; const Name : string; UseCOMWait : Boolean);');
    RegisterMethod('Constructor Create1( UseCOMWait : Boolean);');
    RegisterMethod('Function WaitFor( Timeout : LongWord) : TWaitResult;');
    RegisterMethod('Procedure SetEvent');
    RegisterMethod('Procedure ResetEvent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THandleObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynchroObject', 'THandleObject') do
  with CL.AddClassN(CL.FindClass('TSynchroObject'),'THandleObject') do begin
    RegisterMethod('Constructor Create( UseCOMWait : Boolean)');
    RegisterMethod('Function WaitFor( Timeout : LongWord) : TWaitResult');
    RegisterProperty('LastError', 'Integer', iptr);
    RegisterProperty('Handle', 'THandle', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynchroObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSynchroObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSynchroObject') do begin
    RegisterMethod('Procedure Acquire');
    RegisterMethod('Procedure Release');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SyncObjs(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('PSecurityAttributes', '___pointer');
  SIRegister_TSynchroObject(CL);
  CL.AddTypeS('TWaitResult', '( wrSignaled, wrTimeout, wrAbandoned, wrError )');
  SIRegister_THandleObject(CL);
  SIRegister_TEvent(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSimpleEvent');
  SIRegister_TMutex(CL);
  SIRegister_TCriticalSection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TMutexCreate2_P(Self: TClass; CreateNewInstance: Boolean;  DesiredAccess : LongWord; InheritHandle : Boolean; const Name : string; UseCOMWait : Boolean):TObject;
Begin Result := TMutex.Create(DesiredAccess, InheritHandle, Name, UseCOMWait); END;

(*----------------------------------------------------------------------------*)
Function TMutexCreate1_P(Self: TClass; CreateNewInstance: Boolean;  MutexAttributes : PSecurityAttributes; InitialOwner : Boolean; const Name : string; UseCOMWait : Boolean):TObject;
Begin Result := TMutex.Create(MutexAttributes, InitialOwner, Name, UseCOMWait); END;

(*----------------------------------------------------------------------------*)
Function TMutexCreate_P(Self: TClass; CreateNewInstance: Boolean;  UseCOMWait : Boolean):TObject;
Begin Result := TMutex.Create(UseCOMWait); END;

(*----------------------------------------------------------------------------*)
Function TEventWaitFor_P(Self: TEvent;  Timeout : LongWord) : TWaitResult;
Begin Result := Self.WaitFor(Timeout); END;

(*----------------------------------------------------------------------------*)
Function TEventCreate1_P(Self: TClass; CreateNewInstance: Boolean;  UseCOMWait : Boolean):TObject;
Begin Result := TEvent.Create(UseCOMWait); END;

(*----------------------------------------------------------------------------*)
Function TEventCreate_P(Self: TClass; CreateNewInstance: Boolean;  EventAttributes : PSecurityAttributes; ManualReset, InitialState : Boolean; const Name : string; UseCOMWait : Boolean):TObject;
Begin Result := TEvent.Create(EventAttributes, ManualReset, InitialState, Name, UseCOMWait); END;

(*----------------------------------------------------------------------------*)
procedure THandleObjectHandle_R(Self: THandleObject; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure THandleObjectLastError_R(Self: THandleObject; var T: Integer);
begin T := Self.LastError; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCriticalSection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCriticalSection) do begin
    RegisterConstructor(@TCriticalSection.Create, 'Create');
    RegisterMethod(@TCriticalSection.TryEnter, 'TryEnter');
    RegisterMethod(@TCriticalSection.Enter, 'Enter');
    RegisterMethod(@TCriticalSection.Leave, 'Leave');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMutex(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMutex) do begin
    RegisterConstructor(@TMutexCreate_P, 'Create');
    RegisterConstructor(@TMutexCreate1_P, 'Create1');
    RegisterConstructor(@TMutexCreate2_P, 'Create2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEvent) do begin
    RegisterConstructor(@TEventCreate_P, 'Create');
    RegisterConstructor(@TEventCreate1_P, 'Create1');
    RegisterMethod(@TEventWaitFor_P, 'WaitFor');
    RegisterMethod(@TEvent.SetEvent, 'SetEvent');
    RegisterMethod(@TEvent.ResetEvent, 'ResetEvent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THandleObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THandleObject) do begin
    RegisterConstructor(@THandleObject.Create, 'Create');
    RegisterVirtualMethod(@THandleObject.WaitFor, 'WaitFor');
    RegisterPropertyHelper(@THandleObjectLastError_R,nil,'LastError');
    RegisterPropertyHelper(@THandleObjectHandle_R,nil,'Handle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynchroObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynchroObject) do begin
    RegisterVirtualMethod(@TSynchroObject.Acquire, 'Acquire');
    RegisterVirtualMethod(@TSynchroObject.Release, 'Release');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SyncObjs(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynchroObject(CL);
  RIRegister_THandleObject(CL);
  RIRegister_TEvent(CL);
  with CL.Add(TSimpleEvent) do
  RIRegister_TMutex(CL);
  RIRegister_TCriticalSection(CL);
end;



{ TPSImport_SyncObjs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SyncObjs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SyncObjs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SyncObjs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SyncObjs(ri);
end;
(*----------------------------------------------------------------------------*)


end.
