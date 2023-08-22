unit uPSI_IdIrcServer;
{
   after all an irc
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
  TPSImport_IdIrcServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdIRCServer(CL: TPSPascalCompiler);
procedure SIRegister_IdIrcServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdIRCServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdIrcServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPServer
  ,IdIrcServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdIrcServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIRCServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdIRCServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdIRCServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('OnCommandPass', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandNick', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandUser', 'TIdIrcUserEvent', iptrw);
    RegisterProperty('OnCommandServer', 'TIdIrcServerEvent', iptrw);
    RegisterProperty('OnCommandOper', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandQuit', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandSQuit', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandJoin', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandPart', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandMode', 'TIdIrcFiveParmEvent', iptrw);
    RegisterProperty('OnCommandTopic', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandNames', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandList', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandInvite', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandKick', 'TIdIrcThreeParmEvent', iptrw);
    RegisterProperty('OnCommandVersion', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandStats', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandLinks', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandTime', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandConnect', 'TIdIrcThreeParmEvent', iptrw);
    RegisterProperty('OnCommandTrace', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandAdmin', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandInfo', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandPrivMsg', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandNotice', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandWho', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandWhoIs', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandWhoWas', 'TIdIrcThreeParmEvent', iptrw);
    RegisterProperty('OnCommandKill', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandPing', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandPong', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandError', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandAway', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandRehash', 'TIdIrcGetEvent', iptrw);
    RegisterProperty('OnCommandRestart', 'TIdIrcGetEvent', iptrw);
    RegisterProperty('OnCommandSummon', 'TIdIrcTwoParmEvent', iptrw);
    RegisterProperty('OnCommandUsers', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandWallops', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandUserHost', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandIsOn', 'TIdIrcOneParmEvent', iptrw);
    RegisterProperty('OnCommandOther', 'TIdIrcOtherEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdIrcServer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdIrcGetEvent', 'Procedure ( Thread : TIdPeerThread)');
  CL.AddTypeS('TIdIrcOtherEvent', 'Procedure ( Thread : TIdPeerThread; Command, Parm : String)');
  CL.AddTypeS('TIdIrcOneParmEvent', 'Procedure ( Thread : TIdPeerThread; Parm: String)');
  CL.AddTypeS('TIdIrcTwoParmEvent', 'Procedure ( Thread : TIdPeerThread; Parm1, Parm2: String)');
  CL.AddTypeS('TIdIrcThreeParmEvent', 'Procedure ( Thread : TIdPeerThread; Parm1, Parm2, Parm3 : String)');
  CL.AddTypeS('TIdIrcFiveParmEvent', 'Procedure ( Thread : TIdPeerThread; Parm1'
   +', Parm2, Parm3, Parm4, Parm5 : String)');
  CL.AddTypeS('TIdIrcUserEvent', 'Procedure ( Thread : TIdPeerThread; UserName,'
   +' HostName, ServerName, RealName : String)');
  CL.AddTypeS('TIdIrcServerEvent', 'Procedure ( Thread : TIdPeerThread; ServerN'
   +'ame, Hopcount, Info : String)');
  SIRegister_TIdIRCServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandOther_W(Self: TIdIRCServer; const T: TIdIrcOtherEvent);
begin Self.OnCommandOther := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandOther_R(Self: TIdIRCServer; var T: TIdIrcOtherEvent);
begin T := Self.OnCommandOther; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandIsOn_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandIsOn := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandIsOn_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandIsOn; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandUserHost_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandUserHost := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandUserHost_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandUserHost; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandWallops_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandWallops := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandWallops_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandWallops; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandUsers_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandUsers := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandUsers_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandUsers; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandSummon_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandSummon := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandSummon_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandSummon; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandRestart_W(Self: TIdIRCServer; const T: TIdIrcGetEvent);
begin Self.OnCommandRestart := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandRestart_R(Self: TIdIRCServer; var T: TIdIrcGetEvent);
begin T := Self.OnCommandRestart; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandRehash_W(Self: TIdIRCServer; const T: TIdIrcGetEvent);
begin Self.OnCommandRehash := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandRehash_R(Self: TIdIRCServer; var T: TIdIrcGetEvent);
begin T := Self.OnCommandRehash; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandAway_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandAway := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandAway_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandAway; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandError_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandError := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandError_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandError; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandPong_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandPong := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandPong_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandPong; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandPing_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandPing := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandPing_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandPing; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandKill_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandKill := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandKill_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandKill; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandWhoWas_W(Self: TIdIRCServer; const T: TIdIrcThreeParmEvent);
begin Self.OnCommandWhoWas := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandWhoWas_R(Self: TIdIRCServer; var T: TIdIrcThreeParmEvent);
begin T := Self.OnCommandWhoWas; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandWhoIs_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandWhoIs := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandWhoIs_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandWhoIs; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandWho_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandWho := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandWho_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandWho; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandNotice_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandNotice := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandNotice_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandNotice; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandPrivMsg_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandPrivMsg := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandPrivMsg_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandPrivMsg; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandInfo_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandInfo_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandInfo; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandAdmin_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandAdmin := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandAdmin_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandAdmin; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandTrace_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandTrace := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandTrace_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandTrace; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandConnect_W(Self: TIdIRCServer; const T: TIdIrcThreeParmEvent);
begin Self.OnCommandConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandConnect_R(Self: TIdIRCServer; var T: TIdIrcThreeParmEvent);
begin T := Self.OnCommandConnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandTime_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandTime_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandTime; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandLinks_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandLinks := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandLinks_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandLinks; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandStats_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandStats := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandStats_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandStats; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandVersion_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandVersion_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandVersion; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandKick_W(Self: TIdIRCServer; const T: TIdIrcThreeParmEvent);
begin Self.OnCommandKick := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandKick_R(Self: TIdIRCServer; var T: TIdIrcThreeParmEvent);
begin T := Self.OnCommandKick; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandInvite_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandInvite := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandInvite_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandInvite; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandList_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandList := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandList_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandList; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandNames_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandNames := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandNames_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandNames; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandTopic_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandTopic := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandTopic_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandTopic; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandMode_W(Self: TIdIRCServer; const T: TIdIrcFiveParmEvent);
begin Self.OnCommandMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandMode_R(Self: TIdIRCServer; var T: TIdIrcFiveParmEvent);
begin T := Self.OnCommandMode; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandPart_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandPart := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandPart_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandPart; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandJoin_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandJoin := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandJoin_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandJoin; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandSQuit_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandSQuit := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandSQuit_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandSQuit; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandQuit_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandQuit := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandQuit_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandQuit; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandOper_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandOper := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandOper_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandOper; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandServer_W(Self: TIdIRCServer; const T: TIdIrcServerEvent);
begin Self.OnCommandServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandServer_R(Self: TIdIRCServer; var T: TIdIrcServerEvent);
begin T := Self.OnCommandServer; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandUser_W(Self: TIdIRCServer; const T: TIdIrcUserEvent);
begin Self.OnCommandUser := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandUser_R(Self: TIdIRCServer; var T: TIdIrcUserEvent);
begin T := Self.OnCommandUser; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandNick_W(Self: TIdIRCServer; const T: TIdIrcTwoParmEvent);
begin Self.OnCommandNick := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandNick_R(Self: TIdIRCServer; var T: TIdIrcTwoParmEvent);
begin T := Self.OnCommandNick; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandPass_W(Self: TIdIRCServer; const T: TIdIrcOneParmEvent);
begin Self.OnCommandPass := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIRCServerOnCommandPass_R(Self: TIdIRCServer; var T: TIdIrcOneParmEvent);
begin T := Self.OnCommandPass; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIRCServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIRCServer) do begin
    RegisterConstructor(@TIdIRCServer.Create, 'Create');
    RegisterPropertyHelper(@TIdIRCServerOnCommandPass_R,@TIdIRCServerOnCommandPass_W,'OnCommandPass');
    RegisterPropertyHelper(@TIdIRCServerOnCommandNick_R,@TIdIRCServerOnCommandNick_W,'OnCommandNick');
    RegisterPropertyHelper(@TIdIRCServerOnCommandUser_R,@TIdIRCServerOnCommandUser_W,'OnCommandUser');
    RegisterPropertyHelper(@TIdIRCServerOnCommandServer_R,@TIdIRCServerOnCommandServer_W,'OnCommandServer');
    RegisterPropertyHelper(@TIdIRCServerOnCommandOper_R,@TIdIRCServerOnCommandOper_W,'OnCommandOper');
    RegisterPropertyHelper(@TIdIRCServerOnCommandQuit_R,@TIdIRCServerOnCommandQuit_W,'OnCommandQuit');
    RegisterPropertyHelper(@TIdIRCServerOnCommandSQuit_R,@TIdIRCServerOnCommandSQuit_W,'OnCommandSQuit');
    RegisterPropertyHelper(@TIdIRCServerOnCommandJoin_R,@TIdIRCServerOnCommandJoin_W,'OnCommandJoin');
    RegisterPropertyHelper(@TIdIRCServerOnCommandPart_R,@TIdIRCServerOnCommandPart_W,'OnCommandPart');
    RegisterPropertyHelper(@TIdIRCServerOnCommandMode_R,@TIdIRCServerOnCommandMode_W,'OnCommandMode');
    RegisterPropertyHelper(@TIdIRCServerOnCommandTopic_R,@TIdIRCServerOnCommandTopic_W,'OnCommandTopic');
    RegisterPropertyHelper(@TIdIRCServerOnCommandNames_R,@TIdIRCServerOnCommandNames_W,'OnCommandNames');
    RegisterPropertyHelper(@TIdIRCServerOnCommandList_R,@TIdIRCServerOnCommandList_W,'OnCommandList');
    RegisterPropertyHelper(@TIdIRCServerOnCommandInvite_R,@TIdIRCServerOnCommandInvite_W,'OnCommandInvite');
    RegisterPropertyHelper(@TIdIRCServerOnCommandKick_R,@TIdIRCServerOnCommandKick_W,'OnCommandKick');
    RegisterPropertyHelper(@TIdIRCServerOnCommandVersion_R,@TIdIRCServerOnCommandVersion_W,'OnCommandVersion');
    RegisterPropertyHelper(@TIdIRCServerOnCommandStats_R,@TIdIRCServerOnCommandStats_W,'OnCommandStats');
    RegisterPropertyHelper(@TIdIRCServerOnCommandLinks_R,@TIdIRCServerOnCommandLinks_W,'OnCommandLinks');
    RegisterPropertyHelper(@TIdIRCServerOnCommandTime_R,@TIdIRCServerOnCommandTime_W,'OnCommandTime');
    RegisterPropertyHelper(@TIdIRCServerOnCommandConnect_R,@TIdIRCServerOnCommandConnect_W,'OnCommandConnect');
    RegisterPropertyHelper(@TIdIRCServerOnCommandTrace_R,@TIdIRCServerOnCommandTrace_W,'OnCommandTrace');
    RegisterPropertyHelper(@TIdIRCServerOnCommandAdmin_R,@TIdIRCServerOnCommandAdmin_W,'OnCommandAdmin');
    RegisterPropertyHelper(@TIdIRCServerOnCommandInfo_R,@TIdIRCServerOnCommandInfo_W,'OnCommandInfo');
    RegisterPropertyHelper(@TIdIRCServerOnCommandPrivMsg_R,@TIdIRCServerOnCommandPrivMsg_W,'OnCommandPrivMsg');
    RegisterPropertyHelper(@TIdIRCServerOnCommandNotice_R,@TIdIRCServerOnCommandNotice_W,'OnCommandNotice');
    RegisterPropertyHelper(@TIdIRCServerOnCommandWho_R,@TIdIRCServerOnCommandWho_W,'OnCommandWho');
    RegisterPropertyHelper(@TIdIRCServerOnCommandWhoIs_R,@TIdIRCServerOnCommandWhoIs_W,'OnCommandWhoIs');
    RegisterPropertyHelper(@TIdIRCServerOnCommandWhoWas_R,@TIdIRCServerOnCommandWhoWas_W,'OnCommandWhoWas');
    RegisterPropertyHelper(@TIdIRCServerOnCommandKill_R,@TIdIRCServerOnCommandKill_W,'OnCommandKill');
    RegisterPropertyHelper(@TIdIRCServerOnCommandPing_R,@TIdIRCServerOnCommandPing_W,'OnCommandPing');
    RegisterPropertyHelper(@TIdIRCServerOnCommandPong_R,@TIdIRCServerOnCommandPong_W,'OnCommandPong');
    RegisterPropertyHelper(@TIdIRCServerOnCommandError_R,@TIdIRCServerOnCommandError_W,'OnCommandError');
    RegisterPropertyHelper(@TIdIRCServerOnCommandAway_R,@TIdIRCServerOnCommandAway_W,'OnCommandAway');
    RegisterPropertyHelper(@TIdIRCServerOnCommandRehash_R,@TIdIRCServerOnCommandRehash_W,'OnCommandRehash');
    RegisterPropertyHelper(@TIdIRCServerOnCommandRestart_R,@TIdIRCServerOnCommandRestart_W,'OnCommandRestart');
    RegisterPropertyHelper(@TIdIRCServerOnCommandSummon_R,@TIdIRCServerOnCommandSummon_W,'OnCommandSummon');
    RegisterPropertyHelper(@TIdIRCServerOnCommandUsers_R,@TIdIRCServerOnCommandUsers_W,'OnCommandUsers');
    RegisterPropertyHelper(@TIdIRCServerOnCommandWallops_R,@TIdIRCServerOnCommandWallops_W,'OnCommandWallops');
    RegisterPropertyHelper(@TIdIRCServerOnCommandUserHost_R,@TIdIRCServerOnCommandUserHost_W,'OnCommandUserHost');
    RegisterPropertyHelper(@TIdIRCServerOnCommandIsOn_R,@TIdIRCServerOnCommandIsOn_W,'OnCommandIsOn');
    RegisterPropertyHelper(@TIdIRCServerOnCommandOther_R,@TIdIRCServerOnCommandOther_W,'OnCommandOther');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdIrcServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdIRCServer(CL);
end;

 
 
{ TPSImport_IdIrcServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIrcServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdIrcServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIrcServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdIrcServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
