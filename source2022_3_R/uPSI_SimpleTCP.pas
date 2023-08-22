unit uPSI_SimpleTCP;
{
 to go for socket streams 4
 add tobjectlist

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
  TPSImport_SimpleTCP = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSimpleTCPClient(CL: TPSPascalCompiler);
procedure SIRegister_TSimpleTCPServer(CL: TPSPascalCompiler);
procedure SIRegister_TCustomSimpleSocket(CL: TPSPascalCompiler);
procedure SIRegister_SimpleTCP(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SimpleTCP_Routines(S: TPSExec);
procedure RIRegister_TSimpleTCPClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpleTCPServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomSimpleSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_SimpleTCP(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,WinSock
  ,Contnrs
  ,SimpleTCP
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimpleTCP]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpleTCPClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSimpleSocket', 'TSimpleTCPClient') do
  with CL.AddClassN(CL.FindClass('TCustomSimpleSocket'),'TSimpleTCPClient') do begin
  RegisterMethod('Procedure Free;');
    RegisterMethod('Function Send( Buffer : PChar; BufLength : Integer) : Integer');
    RegisterMethod('Function SendStream( Stream : TStream) : Integer');
    RegisterMethod('Function Receive( Buffer : PChar; BufLength : Integer; ReceiveCompletely : Boolean) : Integer');
    RegisterMethod('Function ReceiveStream( Stream : TStream; DataSize : Integer; ReceiveCompletely : Boolean) : Integer');
    RegisterProperty('IP', 'LongInt', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('AutoTryReconnect', 'Boolean', iptrw);
    RegisterProperty('Connected', 'Boolean', iptrw);
    RegisterProperty('OnConnected', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDisconnected', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDataAvailable', 'TSimpleTCPClientDataAvailEvent', iptrw);
    RegisterProperty('OnRead', 'TSimpleTCPClientIOEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpleTCPServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSimpleSocket', 'TSimpleTCPServer') do
  with CL.AddClassN(CL.FindClass('TCustomSimpleSocket'),'TSimpleTCPServer') do begin
    RegisterMethod('Constructor Create( aOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function Send( Client : TSimpleTCPClient; Buffer : PChar; BufLength : Integer) : Integer');
    RegisterMethod('Function SendStream( Client : TSimpleTCPClient; Stream : TStream) : Integer');
    RegisterMethod('Procedure Broadcast( Buffer : PChar; BufLength : Integer)');
    RegisterMethod('Procedure BroadcastStream( Stream : TStream)');
    RegisterMethod('Function Receive( Client : TSimpleTCPClient; Buffer : PChar; BufLength : Integer; ReceiveCompletely : Boolean) : Integer');
    RegisterMethod('Function ReceiveStream( Client : TSimpleTCPClient; Stream : TStream; DataSize : Integer; ReceiveCompletely : Boolean) : Integer');
    RegisterProperty('Connections', 'TList', iptr);
    RegisterProperty('Connections2', 'TObjectlist', iptr);

    RegisterProperty('Listen', 'Boolean', iptrw);
    RegisterProperty('LocalHostName', 'String', iptrw);
    RegisterProperty('LocalIP', 'String', iptrw);
    RegisterProperty('OnAccept', 'TSimpleTCPAcceptEvent', iptrw);
    RegisterProperty('OnClientConnected', 'TSimpleTCPServerEvent', iptrw);
    RegisterProperty('OnClientDisconnected', 'TSimpleTCPServerEvent', iptrw);
    RegisterProperty('OnClientDataAvailable', 'TSimpleTCPServerDataAvailEvent', iptrw);
    RegisterProperty('OnClientRead', 'TSimpleTCPServerIOEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomSimpleSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomSimpleSocket') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomSimpleSocket') do begin
    RegisterMethod('Constructor Create( aOwner : TComponent)');
     RegisterMethod('Procedure Free;');
       RegisterProperty('AllowChangeHostAndPortOnConnection', 'Boolean', iptrw);
    RegisterProperty('Host', 'String', iptrw);
    RegisterProperty('Port', 'Word', iptrw);
    RegisterProperty('Socket', 'TSocket', iptrw);
    RegisterProperty('OnError', 'TSimpleTCPErrorEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SimpleTCP(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('UM_TCPASYNCSELECT','LongWord').SetUInt( WM_USER + $0001);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSimpleTCPClient');
  CL.AddTypeS('TSimpleTCPAcceptEvent', 'Procedure ( Sender : TObject; Client : '
   +'TSimpleTCPClient; var Accept : Boolean)');
  CL.AddTypeS('TSimpleTCPServerEvent', 'Procedure ( Sender : TObject; Client : TSimpleTCPClient)');
  CL.AddTypeS('TSimpleTCPServerDataAvailEvent', 'Procedure ( Sender : TObject; '
   +'Client : TSimpleTCPClient; DataSize : Integer)');
  CL.AddTypeS('TSimpleTCPClientDataAvailEvent', 'Procedure ( Sender : TObject; DataSize : Integer)');
  CL.AddTypeS('TSimpleTCPServerIOEvent', 'Procedure ( Sender : TObject; Client '
   +': TSimpleTCPClient; Stream : TStream)');
  CL.AddTypeS('TSimpleTCPClientIOEvent', 'Procedure ( Sender : TObject; Stream : TStream)');
  CL.AddTypeS('TSimpleTCPErrorEvent', 'Procedure ( Sender : TObject; Socket : T'
   +'Socket; ErrorCode : Integer; ErrorMsg : String)');
  SIRegister_TCustomSimpleSocket(CL);
  SIRegister_TSimpleTCPServer(CL);
  SIRegister_TSimpleTCPClient(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientOnRead_W(Self: TSimpleTCPClient; const T: TSimpleTCPClientIOEvent);
begin Self.OnRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientOnRead_R(Self: TSimpleTCPClient; var T: TSimpleTCPClientIOEvent);
begin T := Self.OnRead; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientOnDataAvailable_W(Self: TSimpleTCPClient; const T: TSimpleTCPClientDataAvailEvent);
begin Self.OnDataAvailable := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientOnDataAvailable_R(Self: TSimpleTCPClient; var T: TSimpleTCPClientDataAvailEvent);
begin T := Self.OnDataAvailable; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientOnDisconnected_W(Self: TSimpleTCPClient; const T: TNotifyEvent);
begin Self.OnDisconnected := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientOnDisconnected_R(Self: TSimpleTCPClient; var T: TNotifyEvent);
begin T := Self.OnDisconnected; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientOnConnected_W(Self: TSimpleTCPClient; const T: TNotifyEvent);
begin Self.OnConnected := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientOnConnected_R(Self: TSimpleTCPClient; var T: TNotifyEvent);
begin T := Self.OnConnected; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientConnected_W(Self: TSimpleTCPClient; const T: Boolean);
begin Self.Connected := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientConnected_R(Self: TSimpleTCPClient; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientAutoTryReconnect_W(Self: TSimpleTCPClient; const T: Boolean);
begin Self.AutoTryReconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientAutoTryReconnect_R(Self: TSimpleTCPClient; var T: Boolean);
begin T := Self.AutoTryReconnect; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientIP_W(Self: TSimpleTCPClient; const T: LongInt);
begin Self.IP := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPClientIP_R(Self: TSimpleTCPClient; var T: LongInt);
begin T := Self.IP; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerOnClientRead_W(Self: TSimpleTCPServer; const T: TSimpleTCPServerIOEvent);
begin Self.OnClientRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerOnClientRead_R(Self: TSimpleTCPServer; var T: TSimpleTCPServerIOEvent);
begin T := Self.OnClientRead; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerOnClientDataAvailable_W(Self: TSimpleTCPServer; const T: TSimpleTCPServerDataAvailEvent);
begin Self.OnClientDataAvailable := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerOnClientDataAvailable_R(Self: TSimpleTCPServer; var T: TSimpleTCPServerDataAvailEvent);
begin T := Self.OnClientDataAvailable; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerOnClientDisconnected_W(Self: TSimpleTCPServer; const T: TSimpleTCPServerEvent);
begin Self.OnClientDisconnected := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerOnClientDisconnected_R(Self: TSimpleTCPServer; var T: TSimpleTCPServerEvent);
begin T := Self.OnClientDisconnected; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerOnClientConnected_W(Self: TSimpleTCPServer; const T: TSimpleTCPServerEvent);
begin Self.OnClientConnected := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerOnClientConnected_R(Self: TSimpleTCPServer; var T: TSimpleTCPServerEvent);
begin T := Self.OnClientConnected; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerOnAccept_W(Self: TSimpleTCPServer; const T: TSimpleTCPAcceptEvent);
begin Self.OnAccept := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerOnAccept_R(Self: TSimpleTCPServer; var T: TSimpleTCPAcceptEvent);
begin T := Self.OnAccept; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerLocalIP_W(Self: TSimpleTCPServer; const T: String);
begin Self.LocalIP := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerLocalIP_R(Self: TSimpleTCPServer; var T: String);
begin T := Self.LocalIP; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerLocalHostName_W(Self: TSimpleTCPServer; const T: String);
begin Self.LocalHostName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerLocalHostName_R(Self: TSimpleTCPServer; var T: String);
begin T := Self.LocalHostName; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerListen_W(Self: TSimpleTCPServer; const T: Boolean);
begin Self.Listen := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerListen_R(Self: TSimpleTCPServer; var T: Boolean);
begin T := Self.Listen; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleTCPServerConnections_R(Self: TSimpleTCPServer; var T: TList);
begin T := Self.Connections; end;

procedure TSimpleTCPServerConnections_R2(Self: TSimpleTCPServer; var T: TObjectlist);
begin T := TObjectlist(Self.Connections); end;

(*----------------------------------------------------------------------------*)
procedure TCustomSimpleSocketOnError_W(Self: TCustomSimpleSocket; const T: TSimpleTCPErrorEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSimpleSocketOnError_R(Self: TCustomSimpleSocket; var T: TSimpleTCPErrorEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSimpleSocketSocket_W(Self: TCustomSimpleSocket; const T: TSocket);
begin Self.Socket := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSimpleSocketSocket_R(Self: TCustomSimpleSocket; var T: TSocket);
begin T := Self.Socket; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSimpleSocketPort_W(Self: TCustomSimpleSocket; const T: Word);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSimpleSocketPort_R(Self: TCustomSimpleSocket; var T: Word);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSimpleSocketHost_W(Self: TCustomSimpleSocket; const T: String);
begin Self.Host := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSimpleSocketHost_R(Self: TCustomSimpleSocket; var T: String);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSimpleSocketAllowChangeHostAndPortOnConnection_W(Self: TCustomSimpleSocket; const T: Boolean);
begin Self.AllowChangeHostAndPortOnConnection := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSimpleSocketAllowChangeHostAndPortOnConnection_R(Self: TCustomSimpleSocket; var T: Boolean);
begin T := Self.AllowChangeHostAndPortOnConnection; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleTCP_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpleTCPClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleTCPClient) do begin
    RegisterMethod(@TSimpleTCPClient.Send, 'Send');
    RegisterMethod(@TSimpleTCPClient.Destroy, 'Free');
    RegisterMethod(@TSimpleTCPClient.SendStream, 'SendStream');
    RegisterMethod(@TSimpleTCPClient.Receive, 'Receive');
    RegisterMethod(@TSimpleTCPClient.ReceiveStream, 'ReceiveStream');
    RegisterPropertyHelper(@TSimpleTCPClientIP_R,@TSimpleTCPClientIP_W,'IP');
    RegisterPropertyHelper(@TSimpleTCPClientAutoTryReconnect_R,@TSimpleTCPClientAutoTryReconnect_W,'AutoTryReconnect');
    RegisterPropertyHelper(@TSimpleTCPClientConnected_R,@TSimpleTCPClientConnected_W,'Connected');
    RegisterPropertyHelper(@TSimpleTCPClientOnConnected_R,@TSimpleTCPClientOnConnected_W,'OnConnected');
    RegisterPropertyHelper(@TSimpleTCPClientOnDisconnected_R,@TSimpleTCPClientOnDisconnected_W,'OnDisconnected');
    RegisterPropertyHelper(@TSimpleTCPClientOnDataAvailable_R,@TSimpleTCPClientOnDataAvailable_W,'OnDataAvailable');
    RegisterPropertyHelper(@TSimpleTCPClientOnRead_R,@TSimpleTCPClientOnRead_W,'OnRead');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpleTCPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleTCPServer) do begin
    RegisterConstructor(@TSimpleTCPServer.Create, 'Create');
      RegisterMethod(@TSimpleTCPServer.Destroy, 'Free');
       RegisterMethod(@TSimpleTCPServer.Send, 'Send');
    RegisterMethod(@TSimpleTCPServer.SendStream, 'SendStream');
    RegisterMethod(@TSimpleTCPServer.Broadcast, 'Broadcast');
    RegisterMethod(@TSimpleTCPServer.BroadcastStream, 'BroadcastStream');
    RegisterMethod(@TSimpleTCPServer.Receive, 'Receive');
    RegisterMethod(@TSimpleTCPServer.ReceiveStream, 'ReceiveStream');
    RegisterPropertyHelper(@TSimpleTCPServerConnections_R,nil,'Connections');
    RegisterPropertyHelper(@TSimpleTCPServerConnections_R2,nil,'Connections2');

    RegisterPropertyHelper(@TSimpleTCPServerListen_R,@TSimpleTCPServerListen_W,'Listen');
    RegisterPropertyHelper(@TSimpleTCPServerLocalHostName_R,@TSimpleTCPServerLocalHostName_W,'LocalHostName');
    RegisterPropertyHelper(@TSimpleTCPServerLocalIP_R,@TSimpleTCPServerLocalIP_W,'LocalIP');
    RegisterPropertyHelper(@TSimpleTCPServerOnAccept_R,@TSimpleTCPServerOnAccept_W,'OnAccept');
    RegisterPropertyHelper(@TSimpleTCPServerOnClientConnected_R,@TSimpleTCPServerOnClientConnected_W,'OnClientConnected');
    RegisterPropertyHelper(@TSimpleTCPServerOnClientDisconnected_R,@TSimpleTCPServerOnClientDisconnected_W,'OnClientDisconnected');
    RegisterPropertyHelper(@TSimpleTCPServerOnClientDataAvailable_R,@TSimpleTCPServerOnClientDataAvailable_W,'OnClientDataAvailable');
    RegisterPropertyHelper(@TSimpleTCPServerOnClientRead_R,@TSimpleTCPServerOnClientRead_W,'OnClientRead');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomSimpleSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomSimpleSocket) do begin
    RegisterConstructor(@TCustomSimpleSocket.Create, 'Create');
      RegisterMethod(@TCustomSimpleSocket.Destroy, 'Free');
       RegisterPropertyHelper(@TCustomSimpleSocketAllowChangeHostAndPortOnConnection_R,@TCustomSimpleSocketAllowChangeHostAndPortOnConnection_W,'AllowChangeHostAndPortOnConnection');
    RegisterPropertyHelper(@TCustomSimpleSocketHost_R,@TCustomSimpleSocketHost_W,'Host');
    RegisterPropertyHelper(@TCustomSimpleSocketPort_R,@TCustomSimpleSocketPort_W,'Port');
    RegisterPropertyHelper(@TCustomSimpleSocketSocket_R,@TCustomSimpleSocketSocket_W,'Socket');
    RegisterPropertyHelper(@TCustomSimpleSocketOnError_R,@TCustomSimpleSocketOnError_W,'OnError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleTCP(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleTCPClient) do
  RIRegister_TCustomSimpleSocket(CL);
  RIRegister_TSimpleTCPServer(CL);
  RIRegister_TSimpleTCPClient(CL);
end;

 
 
{ TPSImport_SimpleTCP }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleTCP.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SimpleTCP(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleTCP.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SimpleTCP(ri);
  RIRegister_SimpleTCP_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
