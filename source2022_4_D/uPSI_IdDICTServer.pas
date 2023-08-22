unit uPSI_IdDICTServer;
{
   with constructor
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
  TPSImport_IdDICTServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdDICTServer(CL: TPSPascalCompiler);
procedure SIRegister_IdDICTServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdDICTServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdDICTServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPServer
  ,IdDICTServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdDICTServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdDICTServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdDICTServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdDICTServer') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent)');

    RegisterProperty('OnCommandHelp', 'TIdDICTGetEvent', iptrw);
    RegisterProperty('OnCommandDefine', 'TIdDICTDefineEvent', iptrw);
    RegisterProperty('OnCommandMatch', 'TIdDICTMatchEvent', iptrw);
    RegisterProperty('OnCommandQuit', 'TIdDICTGetEvent', iptrw);
    RegisterProperty('OnCommandShow', 'TIdDICTShowEvent', iptrw);
    RegisterProperty('OnCommandAuth', 'TIdDICTAuthEvent', iptrw);
    RegisterProperty('OnCommandSASLAuth', 'TIdDICTAuthEvent', iptrw);
    RegisterProperty('OnCommandOption', 'TIdDICTOtherEvent', iptrw);
    RegisterProperty('OnCommandStatus', 'TIdDICTGetEvent', iptrw);
    RegisterProperty('OnCommandClient', 'TIdDICTShowEvent', iptrw);
    RegisterProperty('OnCommandOther', 'TIdDICTOtherEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdDICTServer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdDICTGetEvent', 'Procedure ( Thread : TIdPeerThread)');
  CL.AddTypeS('TIdDICTOtherEvent', 'Procedure ( Thread : TIdPeerThread; Command'
   +', Parm : String)');
  CL.AddTypeS('TIdDICTDefineEvent', 'Procedure ( Thread : TIdPeerThread; Databa'
   +'se, WordToFind : String)');
  CL.AddTypeS('TIdDICTMatchEvent', 'Procedure ( Thread : TIdPeerThread; Databas'
   +'e, Strategy, WordToFind : String)');
  CL.AddTypeS('TIdDICTShowEvent', 'Procedure ( Thread : TIdPeerThread; Command: String)');
  CL.AddTypeS('TIdDICTAuthEvent', 'Procedure ( Thread : TIdPeerThread; Username'
   +', authstring : String)');
  SIRegister_TIdDICTServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandOther_W(Self: TIdDICTServer; const T: TIdDICTOtherEvent);
begin Self.OnCommandOther := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandOther_R(Self: TIdDICTServer; var T: TIdDICTOtherEvent);
begin T := Self.OnCommandOther; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandClient_W(Self: TIdDICTServer; const T: TIdDICTShowEvent);
begin Self.OnCommandClient := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandClient_R(Self: TIdDICTServer; var T: TIdDICTShowEvent);
begin T := Self.OnCommandClient; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandStatus_W(Self: TIdDICTServer; const T: TIdDICTGetEvent);
begin Self.OnCommandStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandStatus_R(Self: TIdDICTServer; var T: TIdDICTGetEvent);
begin T := Self.OnCommandStatus; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandOption_W(Self: TIdDICTServer; const T: TIdDICTOtherEvent);
begin Self.OnCommandOption := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandOption_R(Self: TIdDICTServer; var T: TIdDICTOtherEvent);
begin T := Self.OnCommandOption; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandSASLAuth_W(Self: TIdDICTServer; const T: TIdDICTAuthEvent);
begin Self.OnCommandSASLAuth := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandSASLAuth_R(Self: TIdDICTServer; var T: TIdDICTAuthEvent);
begin T := Self.OnCommandSASLAuth; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandAuth_W(Self: TIdDICTServer; const T: TIdDICTAuthEvent);
begin Self.OnCommandAuth := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandAuth_R(Self: TIdDICTServer; var T: TIdDICTAuthEvent);
begin T := Self.OnCommandAuth; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandShow_W(Self: TIdDICTServer; const T: TIdDICTShowEvent);
begin Self.OnCommandShow := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandShow_R(Self: TIdDICTServer; var T: TIdDICTShowEvent);
begin T := Self.OnCommandShow; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandQuit_W(Self: TIdDICTServer; const T: TIdDICTGetEvent);
begin Self.OnCommandQuit := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandQuit_R(Self: TIdDICTServer; var T: TIdDICTGetEvent);
begin T := Self.OnCommandQuit; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandMatch_W(Self: TIdDICTServer; const T: TIdDICTMatchEvent);
begin Self.OnCommandMatch := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandMatch_R(Self: TIdDICTServer; var T: TIdDICTMatchEvent);
begin T := Self.OnCommandMatch; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandDefine_W(Self: TIdDICTServer; const T: TIdDICTDefineEvent);
begin Self.OnCommandDefine := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandDefine_R(Self: TIdDICTServer; var T: TIdDICTDefineEvent);
begin T := Self.OnCommandDefine; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandHelp_W(Self: TIdDICTServer; const T: TIdDICTGetEvent);
begin Self.OnCommandHelp := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDICTServerOnCommandHelp_R(Self: TIdDICTServer; var T: TIdDICTGetEvent);
begin T := Self.OnCommandHelp; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdDICTServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdDICTServer) do begin
    RegisterConstructor(@TIdDICTServer.Create, 'Create');
    RegisterPropertyHelper(@TIdDICTServerOnCommandHelp_R,@TIdDICTServerOnCommandHelp_W,'OnCommandHelp');
    RegisterPropertyHelper(@TIdDICTServerOnCommandDefine_R,@TIdDICTServerOnCommandDefine_W,'OnCommandDefine');
    RegisterPropertyHelper(@TIdDICTServerOnCommandMatch_R,@TIdDICTServerOnCommandMatch_W,'OnCommandMatch');
    RegisterPropertyHelper(@TIdDICTServerOnCommandQuit_R,@TIdDICTServerOnCommandQuit_W,'OnCommandQuit');
    RegisterPropertyHelper(@TIdDICTServerOnCommandShow_R,@TIdDICTServerOnCommandShow_W,'OnCommandShow');
    RegisterPropertyHelper(@TIdDICTServerOnCommandAuth_R,@TIdDICTServerOnCommandAuth_W,'OnCommandAuth');
    RegisterPropertyHelper(@TIdDICTServerOnCommandSASLAuth_R,@TIdDICTServerOnCommandSASLAuth_W,'OnCommandSASLAuth');
    RegisterPropertyHelper(@TIdDICTServerOnCommandOption_R,@TIdDICTServerOnCommandOption_W,'OnCommandOption');
    RegisterPropertyHelper(@TIdDICTServerOnCommandStatus_R,@TIdDICTServerOnCommandStatus_W,'OnCommandStatus');
    RegisterPropertyHelper(@TIdDICTServerOnCommandClient_R,@TIdDICTServerOnCommandClient_W,'OnCommandClient');
    RegisterPropertyHelper(@TIdDICTServerOnCommandOther_R,@TIdDICTServerOnCommandOther_W,'OnCommandOther');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdDICTServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdDICTServer(CL);
end;

 
 
{ TPSImport_IdDICTServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdDICTServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdDICTServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdDICTServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdDICTServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
