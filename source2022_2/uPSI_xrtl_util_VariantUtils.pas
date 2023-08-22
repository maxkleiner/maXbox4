unit uPSI_xrtl_util_VariantUtils;
{
   just one function
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
  TPSImport_xrtl_util_VariantUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_xrtl_util_VariantUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_VariantUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Variants
  ,xrtl_util_VariantUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_VariantUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_VariantUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function XRTLGetVariantAsString( const Value : Variant) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_VariantUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLGetVariantAsString, 'XRTLGetVariantAsString', cdRegister);
end;

 
 
{ TPSImport_xrtl_util_VariantUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_VariantUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_VariantUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_VariantUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_xrtl_util_VariantUtils(ri);
  RIRegister_xrtl_util_VariantUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
