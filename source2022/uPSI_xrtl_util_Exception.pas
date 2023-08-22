unit uPSI_xrtl_util_Exception;
{
  report export except
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
  TPSImport_xrtl_util_Exception = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_xrtl_util_Exception(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_Exception_Routines(S: TPSExec);
procedure RIRegister_xrtl_util_Exception(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   xrtl_util_Exception;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_Exception]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_Exception(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXRTLException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXRTLNotImplemented');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXRTLInvalidOperation');
 CL.AddDelphiFunction('Procedure XRTLNotImplemented');
 CL.AddDelphiFunction('Procedure XRTLRaiseError( E : Exception)');
 CL.AddDelphiFunction('Procedure XRTLRaise( E : Exception)');
 CL.AddDelphiFunction('Procedure XRaise( E : Exception)');
 CL.AddDelphiFunction('Procedure RaiseExcept( E : Exception)');
 CL.AddDelphiFunction('Procedure XRTLInvalidOperation( ClassName : string; OperationName : string; Description : string)');
 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_Exception_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLNotImplemented, 'XRTLNotImplemented', cdRegister);
 S.RegisterDelphiFunction(@XRTLRaiseError, 'XRTLRaiseError', cdRegister);
 S.RegisterDelphiFunction(@XRTLInvalidOperation, 'XRTLInvalidOperation', cdRegister);
 S.RegisterDelphiFunction(@XRTLRaiseError, 'XRTLRaise', cdRegister);
 S.RegisterDelphiFunction(@XRTLRaiseError, 'XRaise', cdRegister);
  S.RegisterDelphiFunction(@XRTLRaiseError, 'RaiseExcept', cdRegister);
 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_Exception(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EXRTLException) do
  with CL.Add(EXRTLNotImplemented) do
  with CL.Add(EXRTLInvalidOperation) do
end;

 
 
{ TPSImport_xrtl_util_Exception }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Exception.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_Exception(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Exception.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_util_Exception(ri);
  RIRegister_xrtl_util_Exception_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
