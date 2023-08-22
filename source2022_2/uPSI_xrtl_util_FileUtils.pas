unit uPSI_xrtl_util_FileUtils;
{
  file hole
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
  TPSImport_xrtl_util_FileUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_xrtl_util_FileUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_FileUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   xrtl_util_FileUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_FileUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_FileUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function XRTLExtractLongPathName( APath : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_FileUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLExtractLongPathName, 'XRTLExtractLongPathName', cdRegister);
end;

 
 
{ TPSImport_xrtl_util_FileUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_FileUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_FileUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_FileUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_xrtl_util_FileUtils(ri);
  RIRegister_xrtl_util_FileUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
