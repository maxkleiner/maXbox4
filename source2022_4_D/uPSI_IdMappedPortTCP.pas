unit uPSI_IdMappedPortTCP;
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
  TPSImport_IdMappedPortTCP = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdMappedPop3(CL: TPSPascalCompiler);
procedure SIRegister_TIdMappedPop3Thread(CL: TPSPascalCompiler);
procedure SIRegister_TIdMappedTelnet(CL: TPSPascalCompiler);
procedure SIRegister_TIdCustomMappedTelnet(CL: TPSPascalCompiler);
procedure SIRegister_TIdMappedTelnetThread(CL: TPSPascalCompiler);
procedure SIRegister_TIdMappedPortTCP(CL: TPSPascalCompiler);
procedure SIRegister_TIdMappedPortThread(CL: TPSPascalCompiler);
procedure SIRegister_IdMappedPortTCP(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdMappedPop3(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMappedPop3Thread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMappedTelnet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdCustomMappedTelnet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMappedTelnetThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMappedPortTCP(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMappedPortThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdMappedPortTCP(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdGlobal
  ,IdTCPConnection
  ,IdTCPServer
  ,IdAssignedNumbers
  ,IdMappedPortTCP
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdMappedPortTCP]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMappedPop3(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdMappedTelnet', 'TIdMappedPop3') do
  with CL.AddClassN(CL.FindClass('TIdMappedTelnet'),'TIdMappedPop3') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('UserHostDelimiter', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMappedPop3Thread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdMappedTelnetThread', 'TIdMappedPop3Thread') do
  with CL.AddClassN(CL.FindClass('TIdMappedTelnetThread'),'TIdMappedPop3Thread') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMappedTelnet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdCustomMappedTelnet', 'TIdMappedTelnet') do
  with CL.AddClassN(CL.FindClass('TIdCustomMappedTelnet'),'TIdMappedTelnet') do
  begin
    RegisterProperty('AllowedConnectAttempts', 'Integer', iptrw);
    RegisterProperty('OnCheckHostPort', 'TIdMappedTelnetCheckHostPort', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdCustomMappedTelnet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdMappedPortTCP', 'TIdCustomMappedTelnet') do
  with CL.AddClassN(CL.FindClass('TIdMappedPortTCP'),'TIdCustomMappedTelnet') do
  begin
    RegisterProperty('AllowedConnectAttempts', 'Integer', iptrw);
    RegisterProperty('OnCheckHostPort', 'TIdMappedTelnetCheckHostPort', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMappedTelnetThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdMappedPortThread', 'TIdMappedTelnetThread') do
  with CL.AddClassN(CL.FindClass('TIdMappedPortThread'),'TIdMappedTelnetThread') do
  begin
    RegisterProperty('AllowedConnectAttempts', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMappedPortTCP(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdMappedPortTCP') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdMappedPortTCP') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('MappedHost', 'String', iptrw);
    RegisterProperty('MappedPort', 'Integer', iptrw);
    RegisterProperty('OnConnect', 'TIdMappedPortThreadEvent', iptrw);
    RegisterProperty('OnOutboundConnect', 'TIdMappedPortOutboundConnectEvent', iptrw);
    RegisterProperty('OnExecute', 'TIdMappedPortThreadEvent', iptrw);
    RegisterProperty('OnOutboundData', 'TIdMappedPortThreadEvent', iptrw);
    RegisterProperty('OnDisconnect', 'TIdMappedPortThreadEvent', iptrw);
    RegisterProperty('OnOutboundDisconnect', 'TIdMappedPortThreadEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMappedPortThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdPeerThread', 'TIdMappedPortThread') do
  with CL.AddClassN(CL.FindClass('TIdPeerThread'),'TIdMappedPortThread') do
  begin
    RegisterMethod('Constructor Create( ACreateSuspended : Boolean)');
    RegisterProperty('ConnectTimeOut', 'Integer', iptrw);
    RegisterProperty('NetData', 'String', iptrw);
    RegisterProperty('OutboundClient', 'TIdTCPConnection', iptrw);
    RegisterProperty('ReadList', 'TList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdMappedPortTCP(CL: TPSPascalCompiler);
begin
  SIRegister_TIdMappedPortThread(CL);
  CL.AddTypeS('TIdMappedPortThreadEvent', 'Procedure ( AThread : TIdMappedPortThread)');
  CL.AddTypeS('TIdMappedPortOutboundConnectEvent', 'Procedure ( AThread : TIdMa'
   +'ppedPortThread; AException : Exception)');
  SIRegister_TIdMappedPortTCP(CL);
  SIRegister_TIdMappedTelnetThread(CL);
  CL.AddTypeS('TIdMappedTelnetCheckHostPort', 'Procedure ( AThread : TIdMappedP'
   +'ortThread; const AHostPort : String; var VHost, VPort : String)');
  SIRegister_TIdCustomMappedTelnet(CL);
  SIRegister_TIdMappedTelnet(CL);
  SIRegister_TIdMappedPop3Thread(CL);
  SIRegister_TIdMappedPop3(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdMappedPop3UserHostDelimiter_W(Self: TIdMappedPop3; const T: String);
begin Self.UserHostDelimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPop3UserHostDelimiter_R(Self: TIdMappedPop3; var T: String);
begin T := Self.UserHostDelimiter; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedTelnetOnCheckHostPort_W(Self: TIdMappedTelnet; const T: TIdMappedTelnetCheckHostPort);
begin Self.OnCheckHostPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedTelnetOnCheckHostPort_R(Self: TIdMappedTelnet; var T: TIdMappedTelnetCheckHostPort);
begin T := Self.OnCheckHostPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedTelnetAllowedConnectAttempts_W(Self: TIdMappedTelnet; const T: Integer);
begin Self.AllowedConnectAttempts := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedTelnetAllowedConnectAttempts_R(Self: TIdMappedTelnet; var T: Integer);
begin T := Self.AllowedConnectAttempts; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomMappedTelnetOnCheckHostPort_W(Self: TIdCustomMappedTelnet; const T: TIdMappedTelnetCheckHostPort);
begin Self.OnCheckHostPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomMappedTelnetOnCheckHostPort_R(Self: TIdCustomMappedTelnet; var T: TIdMappedTelnetCheckHostPort);
begin T := Self.OnCheckHostPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomMappedTelnetAllowedConnectAttempts_W(Self: TIdCustomMappedTelnet; const T: Integer);
begin Self.AllowedConnectAttempts := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomMappedTelnetAllowedConnectAttempts_R(Self: TIdCustomMappedTelnet; var T: Integer);
begin T := Self.AllowedConnectAttempts; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedTelnetThreadAllowedConnectAttempts_R(Self: TIdMappedTelnetThread; var T: Integer);
begin T := Self.AllowedConnectAttempts; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnOutboundDisconnect_W(Self: TIdMappedPortTCP; const T: TIdMappedPortThreadEvent);
begin Self.OnOutboundDisconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnOutboundDisconnect_R(Self: TIdMappedPortTCP; var T: TIdMappedPortThreadEvent);
begin T := Self.OnOutboundDisconnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnDisconnect_W(Self: TIdMappedPortTCP; const T: TIdMappedPortThreadEvent);
begin Self.OnDisconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnDisconnect_R(Self: TIdMappedPortTCP; var T: TIdMappedPortThreadEvent);
begin T := Self.OnDisconnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnOutboundData_W(Self: TIdMappedPortTCP; const T: TIdMappedPortThreadEvent);
begin Self.OnOutboundData := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnOutboundData_R(Self: TIdMappedPortTCP; var T: TIdMappedPortThreadEvent);
begin T := Self.OnOutboundData; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnExecute_W(Self: TIdMappedPortTCP; const T: TIdMappedPortThreadEvent);
begin Self.OnExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnExecute_R(Self: TIdMappedPortTCP; var T: TIdMappedPortThreadEvent);
begin T := Self.OnExecute; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnOutboundConnect_W(Self: TIdMappedPortTCP; const T: TIdMappedPortOutboundConnectEvent);
begin Self.OnOutboundConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnOutboundConnect_R(Self: TIdMappedPortTCP; var T: TIdMappedPortOutboundConnectEvent);
begin T := Self.OnOutboundConnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnConnect_W(Self: TIdMappedPortTCP; const T: TIdMappedPortThreadEvent);
begin Self.OnConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPOnConnect_R(Self: TIdMappedPortTCP; var T: TIdMappedPortThreadEvent);
begin T := Self.OnConnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPMappedPort_W(Self: TIdMappedPortTCP; const T: Integer);
begin Self.MappedPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPMappedPort_R(Self: TIdMappedPortTCP; var T: Integer);
begin T := Self.MappedPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPMappedHost_W(Self: TIdMappedPortTCP; const T: String);
begin Self.MappedHost := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortTCPMappedHost_R(Self: TIdMappedPortTCP; var T: String);
begin T := Self.MappedHost; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortThreadReadList_R(Self: TIdMappedPortThread; var T: TList);
begin T := Self.ReadList; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortThreadOutboundClient_W(Self: TIdMappedPortThread; const T: TIdTCPConnection);
begin Self.OutboundClient := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortThreadOutboundClient_R(Self: TIdMappedPortThread; var T: TIdTCPConnection);
begin T := Self.OutboundClient; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortThreadNetData_W(Self: TIdMappedPortThread; const T: String);
begin Self.NetData := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortThreadNetData_R(Self: TIdMappedPortThread; var T: String);
begin T := Self.NetData; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortThreadConnectTimeOut_W(Self: TIdMappedPortThread; const T: Integer);
begin Self.ConnectTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedPortThreadConnectTimeOut_R(Self: TIdMappedPortThread; var T: Integer);
begin T := Self.ConnectTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMappedPop3(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMappedPop3) do
  begin
    RegisterConstructor(@TIdMappedPop3.Create, 'Create');
    RegisterPropertyHelper(@TIdMappedPop3UserHostDelimiter_R,@TIdMappedPop3UserHostDelimiter_W,'UserHostDelimiter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMappedPop3Thread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMappedPop3Thread) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMappedTelnet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMappedTelnet) do
  begin
    RegisterPropertyHelper(@TIdMappedTelnetAllowedConnectAttempts_R,@TIdMappedTelnetAllowedConnectAttempts_W,'AllowedConnectAttempts');
    RegisterPropertyHelper(@TIdMappedTelnetOnCheckHostPort_R,@TIdMappedTelnetOnCheckHostPort_W,'OnCheckHostPort');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdCustomMappedTelnet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdCustomMappedTelnet) do
  begin
    RegisterPropertyHelper(@TIdCustomMappedTelnetAllowedConnectAttempts_R,@TIdCustomMappedTelnetAllowedConnectAttempts_W,'AllowedConnectAttempts');
    RegisterPropertyHelper(@TIdCustomMappedTelnetOnCheckHostPort_R,@TIdCustomMappedTelnetOnCheckHostPort_W,'OnCheckHostPort');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMappedTelnetThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMappedTelnetThread) do
  begin
    RegisterPropertyHelper(@TIdMappedTelnetThreadAllowedConnectAttempts_R,nil,'AllowedConnectAttempts');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMappedPortTCP(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMappedPortTCP) do begin
    RegisterConstructor(@TIdMappedPortTCP.Create, 'Create');
        RegisterMethod(@TIdMappedPortTCP.Destroy, 'Free');
    RegisterPropertyHelper(@TIdMappedPortTCPMappedHost_R,@TIdMappedPortTCPMappedHost_W,'MappedHost');
    RegisterPropertyHelper(@TIdMappedPortTCPMappedPort_R,@TIdMappedPortTCPMappedPort_W,'MappedPort');
    RegisterPropertyHelper(@TIdMappedPortTCPOnConnect_R,@TIdMappedPortTCPOnConnect_W,'OnConnect');
    RegisterPropertyHelper(@TIdMappedPortTCPOnOutboundConnect_R,@TIdMappedPortTCPOnOutboundConnect_W,'OnOutboundConnect');
    RegisterPropertyHelper(@TIdMappedPortTCPOnExecute_R,@TIdMappedPortTCPOnExecute_W,'OnExecute');
    RegisterPropertyHelper(@TIdMappedPortTCPOnOutboundData_R,@TIdMappedPortTCPOnOutboundData_W,'OnOutboundData');
    RegisterPropertyHelper(@TIdMappedPortTCPOnDisconnect_R,@TIdMappedPortTCPOnDisconnect_W,'OnDisconnect');
    RegisterPropertyHelper(@TIdMappedPortTCPOnOutboundDisconnect_R,@TIdMappedPortTCPOnOutboundDisconnect_W,'OnOutboundDisconnect');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMappedPortThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMappedPortThread) do
  begin
    RegisterConstructor(@TIdMappedPortThread.Create, 'Create');
    RegisterPropertyHelper(@TIdMappedPortThreadConnectTimeOut_R,@TIdMappedPortThreadConnectTimeOut_W,'ConnectTimeOut');
    RegisterPropertyHelper(@TIdMappedPortThreadNetData_R,@TIdMappedPortThreadNetData_W,'NetData');
    RegisterPropertyHelper(@TIdMappedPortThreadOutboundClient_R,@TIdMappedPortThreadOutboundClient_W,'OutboundClient');
    RegisterPropertyHelper(@TIdMappedPortThreadReadList_R,nil,'ReadList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdMappedPortTCP(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdMappedPortThread(CL);
  RIRegister_TIdMappedPortTCP(CL);
  RIRegister_TIdMappedTelnetThread(CL);
  RIRegister_TIdCustomMappedTelnet(CL);
  RIRegister_TIdMappedTelnet(CL);
  RIRegister_TIdMappedPop3Thread(CL);
  RIRegister_TIdMappedPop3(CL);
end;

 
 
{ TPSImport_IdMappedPortTCP }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMappedPortTCP.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdMappedPortTCP(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMappedPortTCP.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdMappedPortTCP(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
