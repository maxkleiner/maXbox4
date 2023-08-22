unit uPSI_AsyncCalls;
{
 Extract the AsyncCalls.zip to a directory of your choice.
 Add the AnyncCalls.pas unit to your project and uses statements.
 solved a bug in iinterface no more types!
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
  TPSImport_AsyncCalls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TSyncCall(CL: TPSPascalCompiler);
procedure SIRegister_TAsyncCall(CL: TPSPascalCompiler);
procedure SIRegister_TInternalAsyncCall(CL: TPSPascalCompiler);
procedure SIRegister_IAsyncRunnable(CL: TPSPascalCompiler);
procedure SIRegister_IAsyncCallEx(CL: TPSPascalCompiler);
procedure SIRegister_IAsyncCall(CL: TPSPascalCompiler);

procedure SIRegister_AsyncCalls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSyncCall(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAsyncCall(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInternalAsyncCall(CL: TPSRuntimeClassImporter);
procedure RIRegister_AsyncCalls_Routines(S: TPSExec);
procedure RIRegister_AsyncCalls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Contnrs
  ,ActiveX
  ,SyncObjs
  ,AsyncCalls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AsyncCalls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSyncCall(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TSyncCall') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TSyncCall') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAsyncCall(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TAsyncCall') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TAsyncCall') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInternalAsyncCall(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TInternalAsyncCall') do
  with CL.AddClassN(CL.FindClass('TObject'),'TInternalAsyncCall') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IAsyncRunnable(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IAsyncRunnable') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IAsyncRunnable, 'IAsyncRunnable') do
  begin
    RegisterMethod('Procedure AsyncRun', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IAsyncCallEx(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IAsyncCallEx') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IAsyncCallEx, 'IAsyncCallEx') do begin
    RegisterMethod('Function GetEvent : THandle', cdRegister);
    RegisterMethod('Function SyncInThisThreadIfPossible : Boolean', cdRegister);
  end;
end;

procedure SIRegister_IAsyncCall(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IAsyncCallEx') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IAsyncCall, 'IAsyncCall') do begin
    RegisterMethod('Function Sync : Integer', cdRegister);
    //RegisterMethod('Function SyncInThisThreadIfPossible : Boolean', cdRegister);
    RegisterMethod('Function Finished: boolean', cdRegister);
    RegisterMethod('Function ReturnValue: Integer', cdRegister);
    RegisterMethod('Function Canceled: boolean', cdRegister);
    RegisterMethod('Function ForceDifferentThread', cdRegister);
    RegisterMethod('Function CancelInvocation', cdRegister);
    RegisterMethod('Function Forget', cdRegister);
  end;
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_AsyncCalls(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('INT_PTR', 'Integer');
  //CL.AddTypeS('IInterface', 'IUnknown');     bug fix in 3.9.7.1
  CL.AddTypeS('INT_PTR', 'Integer');
  CL.AddTypeS('TAsyncIdleMsgMethod', 'Procedure');
  CL.AddTypeS('TCdeclFunc', '___Pointer');
  //CL.AddTypeS('TCdeclMethod','TMethod');
  CL.AddTypeS('TLocalAsyncProc','function: Integer');
  CL.AddTypeS('TLocalVclProc','function(Param: INT_PTR): INT_PTR');

  //CL.AddTypeS('TCdeclMethod', 'TMethod');
  //CL.AddTypeS('TAsyncCallArgFunction', 'Function: Integer');
  CL.AddTypeS('TAsyncCallArgFunction', 'Integer');  //tester

  CL.AddTypeS('TAsyncCallArgObjectMethod', 'Function ( Arg : TObject) : Integer');
  CL.AddTypeS('TAsyncCallArgIntegerMethod', 'Function ( Arg : Integer) : Integer');
  CL.AddTypeS('TAsyncCallArgStringMethod', 'Function ( const Arg : string) : Integer');
  CL.AddTypeS('TAsyncCallArgWideStringMethod', 'Function ( const Arg : WideString) : Integer');
  CL.AddTypeS('TAsyncCallArgInterfaceMethod', 'Function ( const Arg : IInterface) : Integer');
  CL.AddTypeS('TAsyncCallArgExtendedMethod', 'Function (const Arg: Extended): Integer');
  CL.AddTypeS('TAsyncCallArgVariantMethod', 'Function ( const Arg : Variant): Integer');
  CL.AddTypeS('TAsyncCallArgObjectEvent', 'Procedure ( Arg : TObject)');
  CL.AddTypeS('TAsyncCallArgIntegerEvent', 'Procedure ( Arg : Integer)');
  CL.AddTypeS('TAsyncCallArgStringEvent', 'Procedure ( const Arg : string)');
  CL.AddTypeS('TAsyncCallArgWideStringEvent', 'Procedure ( const Arg : WideString)');
  CL.AddTypeS('TAsyncCallArgInterfaceEvent', 'Procedure ( const Arg : IInterface)');
  CL.AddTypeS('TAsyncCallArgExtendedEvent', 'Procedure ( const Arg : Extended)');
  CL.AddTypeS('TAsyncCallArgVariantEvent', 'Procedure ( const Arg : Variant)');
  CL.AddTypeS('TAsyncCallArgObjectMethod','function(Arg: TObject): Integer of object)');
  CL.AddTypeS('TAsyncCallArgObjectProc','function(Arg: TObject): Integer)');

  CL.AddTypeS('TAsyncCallArgIntegerProc','function(Arg: Integer): Integer)');
  CL.AddTypeS('TAsyncCallArgStringProc','function(const Arg: string): Integer)');
  CL.AddTypeS('TAsyncCallArgWideStringProc','function(const Arg: WideString): Integer)');
  CL.AddTypeS('TAsyncCallArgInterfaceProc','function(const Arg: IInterface): Integer)');
  CL.AddTypeS('TAsyncCallArgExtendedProc','function(const Arg: Extended): Integer)');
  CL.AddTypeS('TAsyncCallArgVariantProc','function(const Arg: Variant): Integer)');

   //CL.AddTypeS('TAsyncCallArgRecordMethod', 'Function ( var Arg) : Integer');
  //CL.AddTypeS('TAsyncCallArgRecordEvent', 'Procedure ( var Arg)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAsyncCallError');
  //CL.AddClassN(CL.FindClass('TOBJECT'),'IAsyncCall');

  SIRegister_IAsyncCallEx(CL);
  SIRegister_IAsyncRunnable(CL);
  SIRegister_IAsyncCall(CL);

 CL.AddDelphiFunction('Procedure SetMaxAsyncCallThreads( MaxThreads : Integer)');
 CL.AddDelphiFunction('Function GetMaxAsyncCallThreads : Integer');
 CL.AddDelphiFunction('Function AsyncCall( Proc : TAsyncCallArgObjectProc; Arg : TObject) : IAsyncCall;');

 CL.AddDelphiFunction('Function AsyncCall1X(Proc : TAsyncCallArgFunction; Arg : Integer) : IAsyncCall;');

 CL.AddDelphiFunction('Function AsyncCall1(aProc: TAsyncCallArgIntegerProc; Arg : Integer): IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall2( Proc : TAsyncCallArgStringProc; const Arg : string) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall3( Proc : TAsyncCallArgWideStringProc; const Arg : WideString) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall4( Proc : TAsyncCallArgInterfaceProc; const Arg : IInterface) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall5( Proc : TAsyncCallArgExtendedProc; const Arg : Extended) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCallVar( Proc : TAsyncCallArgVariantProc; const Arg : Variant) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall6( Method : TAsyncCallArgObjectMethod; Arg : TObject) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall7( Method : TAsyncCallArgIntegerMethod; Arg : Integer) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall8( Method : TAsyncCallArgStringMethod; const Arg : string) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall9( Method : TAsyncCallArgWideStringMethod; const Arg : WideString) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall10( Method : TAsyncCallArgInterfaceMethod; const Arg : IInterface) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall11( Method : TAsyncCallArgExtendedMethod; const Arg : Extended) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCallVar2( Method : TAsyncCallArgVariantMethod; const Arg : Variant) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall12( Method : TAsyncCallArgObjectEvent; Arg : TObject) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall14( Method : TAsyncCallArgIntegerEvent; Arg : Integer) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall15( Method : TAsyncCallArgStringEvent; const Arg : string) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall16( Method : TAsyncCallArgWideStringEvent; const Arg : WideString) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall17( Method : TAsyncCallArgInterfaceEvent; const Arg : IInterface) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall18( Method : TAsyncCallArgExtendedEvent; const Arg : Extended) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCallVar4( Method : TAsyncCallArgVariantEvent; const Arg : Variant) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall19( Runnable : IAsyncRunnable) : IAsyncCall;');
 CL.AddDelphiFunction('Procedure AsyncExec( Method : TNotifyEvent; Arg : TObject; IdleMsgMethod : TAsyncIdleMsgMethod)');
 CL.AddDelphiFunction('Function LocalAsyncCall( LocalProc : TLocalAsyncProc) : IAsyncCall');
 //CL.AddDelphiFunction('Function LocalAsyncCallEx( LocalProc : TLocalAsyncProcEx; Param : INT_PTR) : IAsyncCall');
 CL.AddDelphiFunction('Procedure LocalAsyncExec( Proc : TLocalAsyncProc; IdleMsgMethod : TAsyncIdleMsgMethod)');
 CL.AddDelphiFunction('Procedure LocalVclCall( LocalProc : TLocalVclProc; Param : INT_PTR)');
 CL.AddDelphiFunction('Function LocalAsyncVclCall( LocalProc : TLocalVclProc; Param : INT_PTR) : IAsyncCall');
 //CL.AddDelphiFunction('Function AsyncCallEx( Proc : TAsyncCallArgRecordProc; var Arg) : IAsyncCall;');
 //CL.AddDelphiFunction('Function AsyncCallEx1( Method : TAsyncCallArgRecordMethod; var Arg) : IAsyncCall;');
 //CL.AddDelphiFunction('Function AsyncCallEx2( Method : TAsyncCallArgRecordEvent; var Arg) : IAsyncCall;');
 CL.AddDelphiFunction('Function AsyncCall20( Proc : TCdeclFunc; const Args : array of const) : IAsyncCall;');
 //CL.AddDelphiFunction('Function AsyncCall21( Proc : TCdeclMethod; const Args : array of const) : IAsyncCall;');
 CL.AddConstantN('MAXIMUM_ASYNC_WAIT_OBJECTS','LongInt').SetInt( MAXIMUM_WAIT_OBJECTS - 3);

 CL.AddClassN(CL.FindClass('IUnknown'),'IAsyncCall');

 CL.AddDelphiFunction('Function AsyncMultiSync( const List : array of IAsyncCall; WaitAll : Boolean; Milliseconds : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function AsyncMultiSyncEx( const List : array of IAsyncCall; const Handles : array of THandle; WaitAll : Boolean; Milliseconds : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function MsgAsyncMultiSync( const List : array of IAsyncCall; WaitAll : Boolean; Milliseconds : Cardinal; dwWakeMask : DWORD) : Cardinal');
 CL.AddDelphiFunction('Function MsgAsyncMultiSyncEx( const List : array of IAsyncCall; const Handles : array of THandle; WaitAll : Boolean; Milliseconds : Cardinal; dwWakeMask : DWORD) : Cardinal');
 CL.AddDelphiFunction('Procedure EnterMainThread');
 CL.AddDelphiFunction('Procedure LeaveMainThread');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAsyncCall');
  SIRegister_TInternalAsyncCall(CL);
  SIRegister_TAsyncCall(CL);
  SIRegister_TSyncCall(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function AsyncCall21_P( Proc : TCdeclMethod; const Args : array of const) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Proc, Args); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall20_P( Proc : TCdeclFunc; const Args : array of const) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Proc, Args); END;

(*----------------------------------------------------------------------------*)
Function AsyncCallEx2_P( Method : TAsyncCallArgRecordEvent; var Arg) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCallEx(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCallEx1_P( Method : TAsyncCallArgRecordMethod; var Arg) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCallEx(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCallEx_P( Proc : TAsyncCallArgRecordProc; var Arg) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCallEx(Proc, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall19_P( Runnable : IAsyncRunnable) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Runnable); END;

(*----------------------------------------------------------------------------*)
Function AsyncCallVar4_P( Method : TAsyncCallArgVariantEvent; const Arg : Variant) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCallVar(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall18_P( Method : TAsyncCallArgExtendedEvent; const Arg : Extended) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall17_P( Method : TAsyncCallArgInterfaceEvent; const Arg : IInterface) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall16_P( Method : TAsyncCallArgWideStringEvent; const Arg : WideString) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall15_P( Method : TAsyncCallArgStringEvent; const Arg : string) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall14_P( Method : TAsyncCallArgIntegerEvent; Arg : Integer) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall12_P( Method : TAsyncCallArgObjectEvent; Arg : TObject) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCallVar2_P( Method : TAsyncCallArgVariantMethod; const Arg : Variant) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCallVar(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall11_P( Method : TAsyncCallArgExtendedMethod; const Arg : Extended) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall10_P( Method : TAsyncCallArgInterfaceMethod; const Arg : IInterface) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall9_P( Method : TAsyncCallArgWideStringMethod; const Arg : WideString) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall8_P( Method : TAsyncCallArgStringMethod; const Arg : string) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall7_P( Method : TAsyncCallArgIntegerMethod; Arg : Integer) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall6_P( Method : TAsyncCallArgObjectMethod; Arg : TObject) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Method, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCallVar_P( Proc : TAsyncCallArgVariantProc; const Arg : Variant) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCallVar(Proc, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall5_P( Proc : TAsyncCallArgExtendedProc; const Arg : Extended) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Proc, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall4_P( Proc : TAsyncCallArgInterfaceProc; const Arg : IInterface) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Proc, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall3_P( Proc : TAsyncCallArgWideStringProc; const Arg : WideString) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Proc, Arg); END;

(*----------------------------------------------------------------------------*)
Function AsyncCall2_P( Proc : TAsyncCallArgStringProc; const Arg : string) : IAsyncCall;
Begin
  //Result := AsyncCalls.AsyncCall(Proc, Arg);
  result:= AsyncCalls.AsyncCall(Proc, Arg);

 END;

(*----------------------------------------------------------------------------*)
//Function AsyncCall1_P( Proc : TAsyncCallArgIntegerProc; Arg : Integer) : Integer;
Function AsyncCall1_P(aProc: TAsyncCallArgIntegerProc; Arg : Integer): IAsyncCall;
Begin
      //AsyncCallX(NIL, 220);
     result:= AsyncCalls.AsyncCall(aProc, arg);
      //  result:= 20;
 END;

Function AsyncCallX_P(aProc: TAsyncCallArgFunction; Arg : Integer): IAsyncCall;
Begin
      //AsyncCallX(NIL, 220);
     result:= AsyncCallX(aProc, arg);
      //  result:= 20;
 END;

(*----------------------------------------------------------------------------*)
Function AsyncCall_P( Proc : TAsyncCallArgObjectProc; Arg : TObject) : IAsyncCall;
Begin Result := AsyncCalls.AsyncCall(Proc, Arg); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSyncCall(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSyncCall) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAsyncCall(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAsyncCall) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInternalAsyncCall(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInternalAsyncCall) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AsyncCalls_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetMaxAsyncCallThreads, 'SetMaxAsyncCallThreads', cdRegister);
 S.RegisterDelphiFunction(@GetMaxAsyncCallThreads, 'GetMaxAsyncCallThreads', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall, 'AsyncCall', cdRegister);

 S.RegisterDelphiFunction(@AsyncCall1_P, 'AsyncCall1', cdRegister);
 S.RegisterDelphiFunction(@AsyncCallX_P, 'AsyncCall1X', cdRegister);

 S.RegisterDelphiFunction(@AsyncCall2_P, 'AsyncCall2', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall3_P, 'AsyncCall3', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall4_P, 'AsyncCall4', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall5_P, 'AsyncCall5', cdRegister);
 S.RegisterDelphiFunction(@AsyncCallVar, 'AsyncCallVar', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall6_P, 'AsyncCall6', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall7_P, 'AsyncCall7', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall8_P, 'AsyncCall8', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall9_P, 'AsyncCall9', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall10_P, 'AsyncCall10', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall11_P, 'AsyncCall11', cdRegister);
 S.RegisterDelphiFunction(@AsyncCallVar2_P, 'AsyncCallVar2', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall12_P, 'AsyncCall12', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall14_P, 'AsyncCall14', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall15_P, 'AsyncCall15', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall16_P, 'AsyncCall16', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall17_P, 'AsyncCall17', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall18_P, 'AsyncCall18', cdRegister);
 S.RegisterDelphiFunction(@AsyncCallVar4_P, 'AsyncCallVar4', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall19_P, 'AsyncCall19', cdRegister);
 S.RegisterDelphiFunction(@AsyncExec, 'AsyncExec', cdRegister);
 S.RegisterDelphiFunction(@LocalAsyncCall, 'LocalAsyncCall', cdRegister);
 S.RegisterDelphiFunction(@LocalAsyncCallEx, 'LocalAsyncCallEx', cdRegister);
 S.RegisterDelphiFunction(@LocalAsyncExec, 'LocalAsyncExec', cdRegister);
 S.RegisterDelphiFunction(@LocalVclCall, 'LocalVclCall', cdRegister);
 S.RegisterDelphiFunction(@LocalAsyncVclCall, 'LocalAsyncVclCall', cdRegister);
 S.RegisterDelphiFunction(@AsyncCallEx, 'AsyncCallEx', cdRegister);
 S.RegisterDelphiFunction(@AsyncCallEx1_P, 'AsyncCallEx1', cdRegister);
 S.RegisterDelphiFunction(@AsyncCallEx2_P, 'AsyncCallEx2', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall20_P, 'AsyncCall20', cdRegister);
 S.RegisterDelphiFunction(@AsyncCall21_P, 'AsyncCall21', cdRegister);
 S.RegisterDelphiFunction(@AsyncMultiSync, 'AsyncMultiSync', cdRegister);
 S.RegisterDelphiFunction(@AsyncMultiSyncEx, 'AsyncMultiSyncEx', cdRegister);
 S.RegisterDelphiFunction(@MsgAsyncMultiSync, 'MsgAsyncMultiSync', cdRegister);
 S.RegisterDelphiFunction(@MsgAsyncMultiSyncEx, 'MsgAsyncMultiSyncEx', cdRegister);
 S.RegisterDelphiFunction(@EnterMainThread, 'EnterMainThread', cdRegister);
 S.RegisterDelphiFunction(@LeaveMainThread, 'LeaveMainThread', cdRegister);
  {with CL.Add(TAsyncCall) do
  RIRegister_TInternalAsyncCall(CL);
  RIRegister_TAsyncCall(CL);
  RIRegister_TSyncCall(CL);}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AsyncCalls(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EAsyncCallError) do
    with CL.Add(TAsyncCall) do
  RIRegister_TInternalAsyncCall(CL);
  RIRegister_TAsyncCall(CL);
  RIRegister_TSyncCall(CL);

end;

 
 
{ TPSImport_AsyncCalls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AsyncCalls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AsyncCalls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AsyncCalls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AsyncCalls_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
