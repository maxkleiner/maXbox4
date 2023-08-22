unit uPSI_xrtl_util_StrUtils;
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
  TPSImport_xrtl_util_StrUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_xrtl_util_StrUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_StrUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   xrtl_util_StrUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_StrUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_StrUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function XRTLFetch( var AInput : WideString; const ADelim : WideString; const ADelete : Boolean) : WideString');
 CL.AddDelphiFunction('Function XRTLRPos( const ASub, AIn : WideString; AStart : Integer) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_StrUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLFetch, 'XRTLFetch', cdRegister);
 S.RegisterDelphiFunction(@XRTLRPos, 'XRTLRPos', cdRegister);
end;

 
 
{ TPSImport_xrtl_util_StrUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_StrUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_StrUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_StrUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_xrtl_util_StrUtils(ri);
  RIRegister_xrtl_util_StrUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
