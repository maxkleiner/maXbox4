unit uPSI_IdHostnameServer;
{
  hname
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
  TPSImport_IdHostnameServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdHostNameServer(CL: TPSPascalCompiler);
procedure SIRegister_IdHostnameServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdHostNameServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdHostnameServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPServer
  ,IdHostnameServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdHostnameServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHostNameServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdHostNameServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdHostNameServer') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('OnCommandHNAME', 'THostNameOneParmEvent', iptrw);
    RegisterProperty('OnCommandHADDR', 'THostNameOneParmEvent', iptrw);
    RegisterProperty('OnCommandALL', 'THostNameGetEvent', iptrw);
    RegisterProperty('OnCommandHELP', 'THostNameGetEvent', iptrw);
    RegisterProperty('OnCommandVERSION', 'THostNameGetEvent', iptrw);
    RegisterProperty('OnCommandALLOLD', 'THostNameGetEvent', iptrw);
    RegisterProperty('OnCommandDOMAINS', 'THostNameGetEvent', iptrw);
    RegisterProperty('OnCommandALLDOM', 'THostNameGetEvent', iptrw);
    RegisterProperty('OnCommandALLINGWAY', 'THostNameGetEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdHostnameServer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('THostNameGetEvent', 'Procedure ( Thread : TIdPeerThread)');
  CL.AddTypeS('THostNameOneParmEvent', 'Procedure ( Thread : TIdPeerThread; Par'
   +'m : String)');
  SIRegister_TIdHostNameServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandALLINGWAY_W(Self: TIdHostNameServer; const T: THostNameGetEvent);
begin Self.OnCommandALLINGWAY := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandALLINGWAY_R(Self: TIdHostNameServer; var T: THostNameGetEvent);
begin T := Self.OnCommandALLINGWAY; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandALLDOM_W(Self: TIdHostNameServer; const T: THostNameGetEvent);
begin Self.OnCommandALLDOM := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandALLDOM_R(Self: TIdHostNameServer; var T: THostNameGetEvent);
begin T := Self.OnCommandALLDOM; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandDOMAINS_W(Self: TIdHostNameServer; const T: THostNameGetEvent);
begin Self.OnCommandDOMAINS := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandDOMAINS_R(Self: TIdHostNameServer; var T: THostNameGetEvent);
begin T := Self.OnCommandDOMAINS; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandALLOLD_W(Self: TIdHostNameServer; const T: THostNameGetEvent);
begin Self.OnCommandALLOLD := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandALLOLD_R(Self: TIdHostNameServer; var T: THostNameGetEvent);
begin T := Self.OnCommandALLOLD; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandVERSION_W(Self: TIdHostNameServer; const T: THostNameGetEvent);
begin Self.OnCommandVERSION := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandVERSION_R(Self: TIdHostNameServer; var T: THostNameGetEvent);
begin T := Self.OnCommandVERSION; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandHELP_W(Self: TIdHostNameServer; const T: THostNameGetEvent);
begin Self.OnCommandHELP := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandHELP_R(Self: TIdHostNameServer; var T: THostNameGetEvent);
begin T := Self.OnCommandHELP; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandALL_W(Self: TIdHostNameServer; const T: THostNameGetEvent);
begin Self.OnCommandALL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandALL_R(Self: TIdHostNameServer; var T: THostNameGetEvent);
begin T := Self.OnCommandALL; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandHADDR_W(Self: TIdHostNameServer; const T: THostNameOneParmEvent);
begin Self.OnCommandHADDR := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandHADDR_R(Self: TIdHostNameServer; var T: THostNameOneParmEvent);
begin T := Self.OnCommandHADDR; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandHNAME_W(Self: TIdHostNameServer; const T: THostNameOneParmEvent);
begin Self.OnCommandHNAME := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHostNameServerOnCommandHNAME_R(Self: TIdHostNameServer; var T: THostNameOneParmEvent);
begin T := Self.OnCommandHNAME; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHostNameServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHostNameServer) do
  begin
    RegisterConstructor(@TIdHostNameServer.Create, 'Create');
    RegisterPropertyHelper(@TIdHostNameServerOnCommandHNAME_R,@TIdHostNameServerOnCommandHNAME_W,'OnCommandHNAME');
    RegisterPropertyHelper(@TIdHostNameServerOnCommandHADDR_R,@TIdHostNameServerOnCommandHADDR_W,'OnCommandHADDR');
    RegisterPropertyHelper(@TIdHostNameServerOnCommandALL_R,@TIdHostNameServerOnCommandALL_W,'OnCommandALL');
    RegisterPropertyHelper(@TIdHostNameServerOnCommandHELP_R,@TIdHostNameServerOnCommandHELP_W,'OnCommandHELP');
    RegisterPropertyHelper(@TIdHostNameServerOnCommandVERSION_R,@TIdHostNameServerOnCommandVERSION_W,'OnCommandVERSION');
    RegisterPropertyHelper(@TIdHostNameServerOnCommandALLOLD_R,@TIdHostNameServerOnCommandALLOLD_W,'OnCommandALLOLD');
    RegisterPropertyHelper(@TIdHostNameServerOnCommandDOMAINS_R,@TIdHostNameServerOnCommandDOMAINS_W,'OnCommandDOMAINS');
    RegisterPropertyHelper(@TIdHostNameServerOnCommandALLDOM_R,@TIdHostNameServerOnCommandALLDOM_W,'OnCommandALLDOM');
    RegisterPropertyHelper(@TIdHostNameServerOnCommandALLINGWAY_R,@TIdHostNameServerOnCommandALLINGWAY_W,'OnCommandALLINGWAY');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdHostnameServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdHostNameServer(CL);
end;

 
 
{ TPSImport_IdHostnameServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdHostnameServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdHostnameServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdHostnameServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdHostnameServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
