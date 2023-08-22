unit uPSI_uWebSocket;
{
https://code.google.com/archive/p/delphiws/source/default/source

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
  TPSImport_uWebSocket = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TWebSocketServer(CL: TPSPascalCompiler);
procedure SIRegister_TWebSocketConnection(CL: TPSPascalCompiler);
procedure SIRegister_TWebSocketRequest(CL: TPSPascalCompiler);
procedure SIRegister_uWebSocket(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TWebSocketServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWebSocketConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWebSocketRequest(CL: TPSRuntimeClassImporter);
procedure RIRegister_uWebSocket(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,IdTCPServer
  ,IdThreadMgr
  ,IdThreadMgrDefault
  ,uWebSocket
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uWebSocket]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TWebSocketServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TWebSocketServer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TWebSocketServer') do begin
    RegisterMethod('Constructor Create( ADefaultPort : Integer)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Broadcast( AMessage : string)');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('OnConnect', 'TWebSocketConnectEvent', iptrw);
    RegisterProperty('OnMessageReceived', 'TWebSocketMessageEvent', iptrw);
    RegisterProperty('OnDisconnect', 'TWebSocketDisconnectEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWebSocketConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TWebSocketConnection') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TWebSocketConnection') do begin
    RegisterMethod('Constructor Create( APeerThread : TIdPeerThread)');
    RegisterMethod('Procedure Receive');
    RegisterMethod('Procedure Send( const AMessage : string)');
    RegisterProperty('OnMessageReceived', 'TWebSocketMessageEvent', iptrw);
    RegisterProperty('PeerIP', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWebSocketRequest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TWebSocketRequest') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TWebSocketRequest') do begin
    RegisterMethod('Constructor Create( AConnection : TIdTCPServerConnection)');
    RegisterProperty('Resource', 'string', iptr);
    RegisterProperty('Host', 'string', iptr);
    RegisterProperty('Origin', 'string', iptr);
    RegisterProperty('Protocol', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uWebSocket(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TWebSocketConnection');
  CL.AddTypeS('TWebSocketMessageEvent', 'Procedure ( AConnection : TWebSocketConnection; const AMessage : string)');
  CL.AddTypeS('TWebSocketConnectEvent', 'Procedure ( AConnection : TWebSocketConnection)');
  CL.AddTypeS('TWebSocketDisconnectEvent', 'Procedure ( AConnection : TWebSocketConnection)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TWebSocketException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TWebSocketHandshakeException');
  SIRegister_TWebSocketRequest(CL);
  SIRegister_TWebSocketConnection(CL);
  SIRegister_TWebSocketServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TWebSocketServerOnDisconnect_W(Self: TWebSocketServer; const T: TWebSocketDisconnectEvent);
begin Self.OnDisconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketServerOnDisconnect_R(Self: TWebSocketServer; var T: TWebSocketDisconnectEvent);
begin T := Self.OnDisconnect; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketServerOnMessageReceived_W(Self: TWebSocketServer; const T: TWebSocketMessageEvent);
begin Self.OnMessageReceived := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketServerOnMessageReceived_R(Self: TWebSocketServer; var T: TWebSocketMessageEvent);
begin T := Self.OnMessageReceived; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketServerOnConnect_W(Self: TWebSocketServer; const T: TWebSocketConnectEvent);
begin Self.OnConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketServerOnConnect_R(Self: TWebSocketServer; var T: TWebSocketConnectEvent);
begin T := Self.OnConnect; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketServerActive_W(Self: TWebSocketServer; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketServerActive_R(Self: TWebSocketServer; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketConnectionPeerIP_R(Self: TWebSocketConnection; var T: string);
begin T := Self.PeerIP; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketConnectionOnMessageReceived_W(Self: TWebSocketConnection; const T: TWebSocketMessageEvent);
begin Self.OnMessageReceived := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketConnectionOnMessageReceived_R(Self: TWebSocketConnection; var T: TWebSocketMessageEvent);
begin T := Self.OnMessageReceived; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketRequestProtocol_R(Self: TWebSocketRequest; var T: string);
begin T := Self.Protocol; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketRequestOrigin_R(Self: TWebSocketRequest; var T: string);
begin T := Self.Origin; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketRequestHost_R(Self: TWebSocketRequest; var T: string);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
procedure TWebSocketRequestResource_R(Self: TWebSocketRequest; var T: string);
begin T := Self.Resource; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWebSocketServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWebSocketServer) do begin
    RegisterConstructor(@TWebSocketServer.Create, 'Create');
    RegisterMethod(@TWebSocketServer.Destroy, 'Free');
    RegisterMethod(@TWebSocketServer.Broadcast, 'Broadcast');
    RegisterPropertyHelper(@TWebSocketServerActive_R,@TWebSocketServerActive_W,'Active');
    RegisterPropertyHelper(@TWebSocketServerOnConnect_R,@TWebSocketServerOnConnect_W,'OnConnect');
    RegisterPropertyHelper(@TWebSocketServerOnMessageReceived_R,@TWebSocketServerOnMessageReceived_W,'OnMessageReceived');
    RegisterPropertyHelper(@TWebSocketServerOnDisconnect_R,@TWebSocketServerOnDisconnect_W,'OnDisconnect');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWebSocketConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWebSocketConnection) do
  begin
    RegisterConstructor(@TWebSocketConnection.Create, 'Create');
    RegisterMethod(@TWebSocketConnection.Receive, 'Receive');
    RegisterMethod(@TWebSocketConnection.Send, 'Send');
    RegisterPropertyHelper(@TWebSocketConnectionOnMessageReceived_R,@TWebSocketConnectionOnMessageReceived_W,'OnMessageReceived');
    RegisterPropertyHelper(@TWebSocketConnectionPeerIP_R,nil,'PeerIP');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWebSocketRequest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWebSocketRequest) do
  begin
    RegisterConstructor(@TWebSocketRequest.Create, 'Create');
    RegisterPropertyHelper(@TWebSocketRequestResource_R,nil,'Resource');
    RegisterPropertyHelper(@TWebSocketRequestHost_R,nil,'Host');
    RegisterPropertyHelper(@TWebSocketRequestOrigin_R,nil,'Origin');
    RegisterPropertyHelper(@TWebSocketRequestProtocol_R,nil,'Protocol');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uWebSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWebSocketConnection) do
  with CL.Add(TWebSocketException) do
  with CL.Add(TWebSocketHandshakeException) do
  RIRegister_TWebSocketRequest(CL);
  RIRegister_TWebSocketConnection(CL);
  RIRegister_TWebSocketServer(CL);
end;

 
 
{ TPSImport_uWebSocket }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uWebSocket.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uWebSocket(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uWebSocket.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uWebSocket(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
