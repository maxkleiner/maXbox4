unit uPSI_IdRemoteCMDServer;
{
  also client and server
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
  TPSImport_IdRemoteCMDServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TIdRemoteCMDServer(CL: TPSPascalCompiler);
procedure SIRegister_IdRemoteCMDServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdRemoteCMDServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdRemoteCMDServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPClient
  ,IdTCPServer
  ,IdRemoteCMDServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdRemoteCMDServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdRemoteCMDServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdRemoteCMDServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdRemoteCMDServer') do begin
    RegisterMethod('Procedure SendError( AThread : TIdPeerThread; AStdErr : TIdTCPClient; AMsg : String)');
    RegisterMethod('Procedure SendResults( AThread : TIdPeerThread; AStdErr : TIdTCPClient; AMsg : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdRemoteCMDServer(CL: TPSPascalCompiler);
begin
  SIRegister_TIdRemoteCMDServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdRemoteCMDServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdRemoteCMDServer) do begin
    RegisterMethod(@TIdRemoteCMDServer.SendError, 'SendError');
    RegisterMethod(@TIdRemoteCMDServer.SendResults, 'SendResults');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdRemoteCMDServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdRemoteCMDServer(CL);
end;

 
 
{ TPSImport_IdRemoteCMDServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRemoteCMDServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdRemoteCMDServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRemoteCMDServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdRemoteCMDServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
