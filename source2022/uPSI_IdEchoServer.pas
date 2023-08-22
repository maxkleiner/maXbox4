unit uPSI_IdEchoServer;
{
  echoes
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
  TPSImport_IdEchoServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdECHOServer(CL: TPSPascalCompiler);
procedure SIRegister_IdEchoServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdECHOServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdEchoServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPServer
  ,IdEchoServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdEchoServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdECHOServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdECHOServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdECHOServer') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdEchoServer(CL: TPSPascalCompiler);
begin
  SIRegister_TIdECHOServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdECHOServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdECHOServer) do
  begin
    RegisterConstructor(@TIdECHOServer.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdEchoServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdECHOServer(CL);
end;

 
 
{ TPSImport_IdEchoServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdEchoServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdEchoServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdEchoServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdEchoServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
