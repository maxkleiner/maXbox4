unit uPSI_xrtl_net_URIUtils;
{
  JUST TO COMPARE
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
  TPSImport_xrtl_net_URIUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_xrtl_net_URIUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_net_URIUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   xrtl_net_URIUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_net_URIUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_net_URIUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function XRTLURLDecode( const ASrc : WideString) : WideString');
 CL.AddDelphiFunction('Function XRTLURLEncode( const ASrc : WideString) : WideString');
 CL.AddDelphiFunction('Function XRTLURINormalize( const AURI : WideString) : WideString');
 CL.AddDelphiFunction('Procedure XRTLURIParse( const AURI : WideString; var VProtocol, VHost, VPath, VDocument, VPort, VBookmark, VUserName, VPassword : WideString)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_net_URIUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLURLDecode, 'XRTLURLDecode', cdRegister);
 S.RegisterDelphiFunction(@XRTLURLEncode, 'XRTLURLEncode', cdRegister);
 S.RegisterDelphiFunction(@XRTLURINormalize, 'XRTLURINormalize', cdRegister);
 S.RegisterDelphiFunction(@XRTLURIParse, 'XRTLURIParse', cdRegister);
end;

 
 
{ TPSImport_xrtl_net_URIUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_net_URIUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_net_URIUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_net_URIUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_xrtl_net_URIUtils(ri);
  RIRegister_xrtl_net_URIUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
