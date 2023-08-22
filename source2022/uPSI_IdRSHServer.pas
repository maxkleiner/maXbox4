unit uPSI_IdRSHServer;
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
  TPSImport_IdRSHServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdRSHServer(CL: TPSPascalCompiler);
procedure SIRegister_IdRSHServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdRSHServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdRSHServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdRemoteCMDServer
  ,IdTCPClient
  ,IdTCPServer
  ,IdRSHServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdRSHServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdRSHServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdRemoteCMDServer', 'TIdRSHServer') do
  with CL.AddClassN(CL.FindClass('TIdRemoteCMDServer'),'TIdRSHServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('OnCommand', 'TIdRSHCommandEvent', iptrw);
    RegisterProperty('ForcePortsInRange', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdRSHServer(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('RSH_FORCEPORTSINRANGE','Boolean').Setint(1);
  CL.AddTypeS('TIdRSHCommandEvent', 'Procedure ( AThread : TIdPeerThread; AStdE'
   +'rror : TIdTCPClient; AClientUserName, AHostUserName, ACommand : String)');
  SIRegister_TIdRSHServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdRSHServerForcePortsInRange_W(Self: TIdRSHServer; const T: Boolean);
begin Self.ForcePortsInRange := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdRSHServerForcePortsInRange_R(Self: TIdRSHServer; var T: Boolean);
begin T := Self.ForcePortsInRange; end;

(*----------------------------------------------------------------------------*)
procedure TIdRSHServerOnCommand_W(Self: TIdRSHServer; const T: TIdRSHCommandEvent);
begin Self.OnCommand := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdRSHServerOnCommand_R(Self: TIdRSHServer; var T: TIdRSHCommandEvent);
begin T := Self.OnCommand; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdRSHServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdRSHServer) do begin
    RegisterConstructor(@TIdRSHServer.Create, 'Create');
    RegisterPropertyHelper(@TIdRSHServerOnCommand_R,@TIdRSHServerOnCommand_W,'OnCommand');
    RegisterPropertyHelper(@TIdRSHServerForcePortsInRange_R,@TIdRSHServerForcePortsInRange_W,'ForcePortsInRange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdRSHServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdRSHServer(CL);
end;

 
 
{ TPSImport_IdRSHServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRSHServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdRSHServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRSHServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdRSHServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
