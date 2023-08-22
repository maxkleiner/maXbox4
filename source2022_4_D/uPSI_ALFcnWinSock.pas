unit uPSI_ALFcnWinSock;
{
   socks and streams and sql
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
  TPSImport_ALFcnWinSock = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ALFcnWinSock(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALFcnWinSock_Routines(S: TPSExec);

procedure Register;

implementation


uses
   AlStringList
  ,ALFcnWinSock
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFcnWinSock]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFcnWinSock(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function ALHostToIP( HostName : AnsiString; var Ip : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function ALIPAddrToName( IPAddr : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALgetLocalIPs : TALStrings');
 CL.AddDelphiFunction('Function ALgetLocalHostName : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFcnWinSock_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ALHostToIP, 'ALHostToIP', cdRegister);
 S.RegisterDelphiFunction(@ALIPAddrToName, 'ALIPAddrToName', cdRegister);
 S.RegisterDelphiFunction(@ALgetLocalIPs, 'ALgetLocalIPs', cdRegister);
 S.RegisterDelphiFunction(@ALgetLocalHostName, 'ALgetLocalHostName', cdRegister);
end;

 
 
{ TPSImport_ALFcnWinSock }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnWinSock.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFcnWinSock(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnWinSock.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ALFcnWinSock(ri);
  RIRegister_ALFcnWinSock_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
