unit uPSI_ProxyUtils;
{
Tfor the REST API connectors

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
  TPSImport_ProxyUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ProxyUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ProxyUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ProxyUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ProxyUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ProxyUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function ProxyActive : Boolean');
 CL.AddDelphiFunction('Function GetProxyServer : string');
 CL.AddDelphiFunction('Function GetProxyOverride : string');
 CL.AddDelphiFunction('Function GetProxyServerIP : string');
 CL.AddDelphiFunction('Function GetProxyServerPort : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ProxyUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ProxyActive, 'ProxyActive', cdRegister);
 S.RegisterDelphiFunction(@GetProxyServer, 'GetProxyServer', cdRegister);
 S.RegisterDelphiFunction(@GetProxyOverride, 'GetProxyOverride', cdRegister);
 S.RegisterDelphiFunction(@GetProxyServerIP, 'GetProxyServerIP', cdRegister);
 S.RegisterDelphiFunction(@GetProxyServerPort, 'GetProxyServerPort', cdRegister);
end;

 
 
{ TPSImport_ProxyUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ProxyUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ProxyUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ProxyUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ProxyUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
