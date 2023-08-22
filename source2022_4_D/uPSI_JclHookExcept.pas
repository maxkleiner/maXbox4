unit uPSI_JclHookExcept;
{
   dr. hook and the maxcine show
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
  TPSImport_JclHookExcept = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclHookExcept(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclHookExcept_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,JclHookExcept
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclHookExcept]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclHookExcept(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TJclExceptNotifyMethod', 'Procedure ( ExceptObj : TObject; Excep'
   //+'tAddr : Pointer; OSException : Boolean)');
  CL.AddTypeS('TJclExceptNotifyPriority', '( npNormal, npFirstChain )');
 //CL.AddDelphiFunction('Function JclAddExceptNotifier( const NotifyProc : TJclExceptNotifyProc; Priority : TJclExceptNotifyPriority) : Boolean;');
 //CL.AddDelphiFunction('Function JclAddExceptNotifier1( const NotifyMethod : TJclExceptNotifyMethod; Priority : TJclExceptNotifyPriority) : Boolean;');
 //CL.AddDelphiFunction('Function JclRemoveExceptNotifier( const NotifyProc : TJclExceptNotifyProc) : Boolean;');
 //CL.AddDelphiFunction('Function JclRemoveExceptNotifier1( const NotifyMethod : TJclExceptNotifyMethod) : Boolean;');
 CL.AddDelphiFunction('Procedure JclReplaceExceptObj( NewExceptObj : Exception)');
 CL.AddDelphiFunction('Function JclHookExceptions : Boolean');
 CL.AddDelphiFunction('Function JclUnhookExceptions : Boolean');
 CL.AddDelphiFunction('Function JclExceptionsHooked : Boolean');
 CL.AddDelphiFunction('Function JclHookExceptionsInModule( Module : HMODULE) : Boolean');
 CL.AddDelphiFunction('Function JclUnkookExceptionsInModule( Module : HMODULE) : Boolean');
  CL.AddTypeS('TJclModuleArray', 'array of HMODULE');
 CL.AddDelphiFunction('Function JclInitializeLibrariesHookExcept : Boolean');
 CL.AddDelphiFunction('Function JclHookedExceptModulesList( var ModulesList : TJclModuleArray) : Boolean');
 CL.AddDelphiFunction('Function JclBelongsHookedCode( Addr : TObject) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function JclRemoveExceptNotifier1_P( const NotifyMethod : TJclExceptNotifyMethod) : Boolean;
Begin Result := JclHookExcept.JclRemoveExceptNotifier(NotifyMethod); END;

(*----------------------------------------------------------------------------*)
Function JclRemoveExceptNotifier_P( const NotifyProc : TJclExceptNotifyProc) : Boolean;
Begin Result := JclHookExcept.JclRemoveExceptNotifier(NotifyProc); END;

(*----------------------------------------------------------------------------*)
Function JclAddExceptNotifier1_P( const NotifyMethod : TJclExceptNotifyMethod; Priority : TJclExceptNotifyPriority) : Boolean;
Begin Result := JclHookExcept.JclAddExceptNotifier(NotifyMethod, Priority); END;

(*----------------------------------------------------------------------------*)
Function JclAddExceptNotifier_P( const NotifyProc : TJclExceptNotifyProc; Priority : TJclExceptNotifyPriority) : Boolean;
Begin Result := JclHookExcept.JclAddExceptNotifier(NotifyProc, Priority); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclHookExcept_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@JclAddExceptNotifier, 'JclAddExceptNotifier', cdRegister);
 S.RegisterDelphiFunction(@JclAddExceptNotifier1_P, 'JclAddExceptNotifier1', cdRegister);
 S.RegisterDelphiFunction(@JclRemoveExceptNotifier, 'JclRemoveExceptNotifier', cdRegister);
 S.RegisterDelphiFunction(@JclRemoveExceptNotifier1_P, 'JclRemoveExceptNotifier1', cdRegister);
 S.RegisterDelphiFunction(@JclReplaceExceptObj, 'JclReplaceExceptObj', cdRegister);
 S.RegisterDelphiFunction(@JclHookExceptions, 'JclHookExceptions', cdRegister);
 S.RegisterDelphiFunction(@JclUnhookExceptions, 'JclUnhookExceptions', cdRegister);
 S.RegisterDelphiFunction(@JclExceptionsHooked, 'JclExceptionsHooked', cdRegister);
 S.RegisterDelphiFunction(@JclHookExceptionsInModule, 'JclHookExceptionsInModule', cdRegister);
 S.RegisterDelphiFunction(@JclUnkookExceptionsInModule, 'JclUnkookExceptionsInModule', cdRegister);
 S.RegisterDelphiFunction(@JclInitializeLibrariesHookExcept, 'JclInitializeLibrariesHookExcept', cdRegister);
 S.RegisterDelphiFunction(@JclHookedExceptModulesList, 'JclHookedExceptModulesList', cdRegister);
 S.RegisterDelphiFunction(@JclBelongsHookedCode, 'JclBelongsHookedCode', cdRegister);
end;

 
 
{ TPSImport_JclHookExcept }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclHookExcept.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclHookExcept(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclHookExcept.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclHookExcept(ri);
  RIRegister_JclHookExcept_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
