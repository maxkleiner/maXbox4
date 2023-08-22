unit uPSI_IdRexec;
{
  Rexec Client and Server in one unit
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
  TPSImport_IdRexec = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdRexec(CL: TPSPascalCompiler);
procedure SIRegister_TIdRexecServer(CL: TPSPascalCompiler);
procedure SIRegister_IdRexec(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdRexec(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdRexecServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdRexec(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdRemoteCMDClient
  ,IdRemoteCMDServer
  ,IdTCPServer
  ,IdTCPClient
  ,IdRexec
  ,IdRexecServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdRexec]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdRexec(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdRemoteCMDClient', 'TIdRexec') do
  with CL.AddClassN(CL.FindClass('TIdRemoteCMDClient'),'TIdRexec') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute( ACommand : String) : String');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdRexecServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdRemoteCMDServer', 'TIdRexecServer') do
  with CL.AddClassN(CL.FindClass('TIdRemoteCMDServer'),'TIdRexecServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('OnCommand', 'TIdRexecCommandEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdRexec(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdRexecCommandEvent', 'Procedure ( AThread : TIdPeerThread; ASt'
   +'dError : TIdTCPClient; AUserName, APassword, ACommand : String)');
  SIRegister_TIdRexecServer(CL);
  SIRegister_TIdRexec(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdRexecServerOnCommand_W(Self: TIdRexecServer; const T: TIdRexecCommandEvent);
begin Self.OnCommand := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdRexecServerOnCommand_R(Self: TIdRexecServer; var T: TIdRexecCommandEvent);
begin T := Self.OnCommand; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdRexec(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdRexec) do begin
    RegisterConstructor(@TIdRexec.Create, 'Create');
    RegisterMethod(@TIdRexec.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdRexecServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdRexecServer) do begin
    RegisterConstructor(@TIdRexecServer.Create, 'Create');
    RegisterPropertyHelper(@TIdRexecServerOnCommand_R,@TIdRexecServerOnCommand_W,'OnCommand');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdRexec(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdRexecServer(CL);
  RIRegister_TIdRexec(CL);
end;



{ TPSImport_IdRexec }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRexec.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdRexec(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRexec.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdRexec(ri);
end;
(*----------------------------------------------------------------------------*)


end.
