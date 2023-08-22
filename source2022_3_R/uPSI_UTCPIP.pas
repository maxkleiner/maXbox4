unit uPSI_UTCPIP;
{
   of pascalcoin    blocksock codeblocksock

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
  TPSImport_UTCPIP = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNetTcpIpServer(CL: TPSPascalCompiler);
procedure SIRegister_TTcpIpServerListenerThread(CL: TPSPascalCompiler);
procedure SIRegister_TTcpIpSocketThread(CL: TPSPascalCompiler);
procedure SIRegister_TBufferedNetTcpIpClient(CL: TPSPascalCompiler);
procedure SIRegister_TBufferedNetTcpIpClientThread(CL: TPSPascalCompiler);
procedure SIRegister_TNetTcpIpClient(CL: TPSPascalCompiler);
procedure SIRegister_UTCPIP(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TNetTcpIpServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTcpIpServerListenerThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTcpIpSocketThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBufferedNetTcpIpClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBufferedNetTcpIpClientThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNetTcpIpClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_UTCPIP(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synsock
  ,Sockets
  ,UThread
  ,SyncObjs
  ,UTCPIP
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UTCPIP]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNetTcpIpServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TNetTcpIpServer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TNetTcpIpServer') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
       RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Port', 'Word', iptrw);
    RegisterProperty('MaxConnections', 'Integer', iptrw);
    RegisterProperty('NetTcpIpClientClass', 'TNetTcpIpClientClass', iptrw);
    RegisterMethod('Function NetTcpIpClientsLock : TList');
    RegisterMethod('Procedure NetTcpIpClientsUnlock');
    RegisterMethod('Procedure WaitUntilNetTcpIpClientsFinalized');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTcpIpServerListenerThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPCThread', 'TTcpIpServerListenerThread') do
  with CL.AddClassN(CL.FindClass('TPCThread'),'TTcpIpServerListenerThread') do
  begin
    RegisterMethod('Constructor Create( ANetTcpIpServer : TNetTcpIpServer)');
        RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTcpIpSocketThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPCThread', 'TTcpIpSocketThread') do
  with CL.AddClassN(CL.FindClass('TPCThread'),'TTcpIpSocketThread') do
  begin
    RegisterMethod('Constructor Create( AListenerThread : TTcpIpServerListenerThread; ASocket : TSocket)');
      RegisterMethod('Procedure Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBufferedNetTcpIpClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNetTcpIpClient', 'TBufferedNetTcpIpClient') do
  with CL.AddClassN(CL.FindClass('TNetTcpIpClient'),'TBufferedNetTcpIpClient') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');

    RegisterMethod('Procedure WriteBufferToSend( SendData : TStream)');
    RegisterMethod('Function ReadBufferLock : TMemoryStream');
    RegisterMethod('Procedure ReadBufferUnlock');
    RegisterProperty('LastReadTC', 'Cardinal', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBufferedNetTcpIpClientThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPCThread', 'TBufferedNetTcpIpClientThread') do
  with CL.AddClassN(CL.FindClass('TPCThread'),'TBufferedNetTcpIpClientThread') do
  begin
    RegisterProperty('FBufferedNetTcpIpClient', 'TBufferedNetTcpIpClient', iptrw);
    RegisterMethod('Constructor Create( ABufferedNetTcpIpClient : TBufferedNetTcpIpClient)');
      RegisterMethod('Procedure Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNetTcpIpClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TNetTcpIpClient') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TNetTcpIpClient') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function ClientRemoteAddr : AnsiString');
    RegisterProperty('RemoteHost', 'AnsiString', iptrw);
    RegisterProperty('RemotePort', 'Word', iptrw);
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Function Connect : Boolean');
    RegisterMethod('Function WaitForData( WaitMilliseconds : Integer) : Boolean');
    RegisterProperty('OnConnect', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDisconnect', 'TNotifyEvent', iptrw);
    RegisterMethod('Function BytesReceived : Int64');
    RegisterMethod('Function BytesSent : Int64');
    RegisterProperty('SocketError', 'Integer', iptrw);
    RegisterProperty('LastCommunicationTime', 'TDateTime', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UTCPIP(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TTCPBlockSocket2', 'TCustomIpClient');
  SIRegister_TNetTcpIpClient(CL);
  //CL.AddTypeS('TNetTcpIpClientClass', 'class of TNetTcpIpClient');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBufferedNetTcpIpClient');
  SIRegister_TBufferedNetTcpIpClientThread(CL);
  SIRegister_TBufferedNetTcpIpClient(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNetTcpIpServer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTcpIpServerListenerThread');
  SIRegister_TTcpIpSocketThread(CL);
  SIRegister_TTcpIpServerListenerThread(CL);
  SIRegister_TNetTcpIpServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TNetTcpIpServerNetTcpIpClientClass_W(Self: TNetTcpIpServer; const T: TNetTcpIpClientClass);
begin Self.NetTcpIpClientClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpServerNetTcpIpClientClass_R(Self: TNetTcpIpServer; var T: TNetTcpIpClientClass);
begin T := Self.NetTcpIpClientClass; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpServerMaxConnections_W(Self: TNetTcpIpServer; const T: Integer);
begin Self.MaxConnections := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpServerMaxConnections_R(Self: TNetTcpIpServer; var T: Integer);
begin T := Self.MaxConnections; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpServerPort_W(Self: TNetTcpIpServer; const T: Word);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpServerPort_R(Self: TNetTcpIpServer; var T: Word);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpServerActive_W(Self: TNetTcpIpServer; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpServerActive_R(Self: TNetTcpIpServer; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TBufferedNetTcpIpClientLastReadTC_R(Self: TBufferedNetTcpIpClient; var T: Cardinal);
begin T := Self.LastReadTC; end;

(*----------------------------------------------------------------------------*)
procedure TBufferedNetTcpIpClientThreadFBufferedNetTcpIpClient_W(Self: TBufferedNetTcpIpClientThread; const T: TBufferedNetTcpIpClient);
Begin Self.FBufferedNetTcpIpClient := T; end;

(*----------------------------------------------------------------------------*)
procedure TBufferedNetTcpIpClientThreadFBufferedNetTcpIpClient_R(Self: TBufferedNetTcpIpClientThread; var T: TBufferedNetTcpIpClient);
Begin T := Self.FBufferedNetTcpIpClient; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientLastCommunicationTime_R(Self: TNetTcpIpClient; var T: TDateTime);
begin T := Self.LastCommunicationTime; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientSocketError_W(Self: TNetTcpIpClient; const T: Integer);
begin Self.SocketError := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientSocketError_R(Self: TNetTcpIpClient; var T: Integer);
begin T := Self.SocketError; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientOnDisconnect_W(Self: TNetTcpIpClient; const T: TNotifyEvent);
begin Self.OnDisconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientOnDisconnect_R(Self: TNetTcpIpClient; var T: TNotifyEvent);
begin T := Self.OnDisconnect; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientOnConnect_W(Self: TNetTcpIpClient; const T: TNotifyEvent);
begin Self.OnConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientOnConnect_R(Self: TNetTcpIpClient; var T: TNotifyEvent);
begin T := Self.OnConnect; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientConnected_R(Self: TNetTcpIpClient; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientRemotePort_W(Self: TNetTcpIpClient; const T: Word);
begin Self.RemotePort := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientRemotePort_R(Self: TNetTcpIpClient; var T: Word);
begin T := Self.RemotePort; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientRemoteHost_W(Self: TNetTcpIpClient; const T: AnsiString);
begin Self.RemoteHost := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetTcpIpClientRemoteHost_R(Self: TNetTcpIpClient; var T: AnsiString);
begin T := Self.RemoteHost; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNetTcpIpServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNetTcpIpServer) do begin
    RegisterConstructor(@TNetTcpIpServer.Create, 'Create');
      RegisterMethod(@TNetTcpIpServer.Destroy, 'Free');
      RegisterPropertyHelper(@TNetTcpIpServerActive_R,@TNetTcpIpServerActive_W,'Active');
    RegisterPropertyHelper(@TNetTcpIpServerPort_R,@TNetTcpIpServerPort_W,'Port');
    RegisterPropertyHelper(@TNetTcpIpServerMaxConnections_R,@TNetTcpIpServerMaxConnections_W,'MaxConnections');
    RegisterPropertyHelper(@TNetTcpIpServerNetTcpIpClientClass_R,@TNetTcpIpServerNetTcpIpClientClass_W,'NetTcpIpClientClass');
    RegisterMethod(@TNetTcpIpServer.NetTcpIpClientsLock, 'NetTcpIpClientsLock');
    RegisterMethod(@TNetTcpIpServer.NetTcpIpClientsUnlock, 'NetTcpIpClientsUnlock');
    RegisterMethod(@TNetTcpIpServer.WaitUntilNetTcpIpClientsFinalized, 'WaitUntilNetTcpIpClientsFinalized');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTcpIpServerListenerThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTcpIpServerListenerThread) do
  begin
    RegisterConstructor(@TTcpIpServerListenerThread.Create, 'Create');
      RegisterMethod(@TTcpIpServerListenerThread.Destroy, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTcpIpSocketThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTcpIpSocketThread) do begin
    RegisterConstructor(@TTcpIpSocketThread.Create, 'Create');
      RegisterMethod(@TTcpIpSocketThread.Destroy, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBufferedNetTcpIpClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBufferedNetTcpIpClient) do begin
    RegisterConstructor(@TBufferedNetTcpIpClient.Create, 'Create');
      RegisterMethod(@TBufferedNetTcpIpClient.Destroy, 'Free');
      RegisterMethod(@TBufferedNetTcpIpClient.WriteBufferToSend, 'WriteBufferToSend');
    RegisterMethod(@TBufferedNetTcpIpClient.ReadBufferLock, 'ReadBufferLock');
    RegisterMethod(@TBufferedNetTcpIpClient.ReadBufferUnlock, 'ReadBufferUnlock');
    RegisterPropertyHelper(@TBufferedNetTcpIpClientLastReadTC_R,nil,'LastReadTC');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBufferedNetTcpIpClientThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBufferedNetTcpIpClientThread) do
  begin
    RegisterPropertyHelper(@TBufferedNetTcpIpClientThreadFBufferedNetTcpIpClient_R,@TBufferedNetTcpIpClientThreadFBufferedNetTcpIpClient_W,'FBufferedNetTcpIpClient');
    RegisterConstructor(@TBufferedNetTcpIpClientThread.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNetTcpIpClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNetTcpIpClient) do begin
    RegisterConstructor(@TNetTcpIpClient.Create, 'Create');
      RegisterMethod(@TNetTcpIpClient.Destroy, 'Free');
      RegisterMethod(@TNetTcpIpClient.ClientRemoteAddr, 'ClientRemoteAddr');
    RegisterPropertyHelper(@TNetTcpIpClientRemoteHost_R,@TNetTcpIpClientRemoteHost_W,'RemoteHost');
    RegisterPropertyHelper(@TNetTcpIpClientRemotePort_R,@TNetTcpIpClientRemotePort_W,'RemotePort');
    RegisterPropertyHelper(@TNetTcpIpClientConnected_R,nil,'Connected');
    RegisterMethod(@TNetTcpIpClient.Disconnect, 'Disconnect');
    RegisterMethod(@TNetTcpIpClient.Connect, 'Connect');
    RegisterMethod(@TNetTcpIpClient.WaitForData, 'WaitForData');
    RegisterPropertyHelper(@TNetTcpIpClientOnConnect_R,@TNetTcpIpClientOnConnect_W,'OnConnect');
    RegisterPropertyHelper(@TNetTcpIpClientOnDisconnect_R,@TNetTcpIpClientOnDisconnect_W,'OnDisconnect');
    RegisterMethod(@TNetTcpIpClient.BytesReceived, 'BytesReceived');
    RegisterMethod(@TNetTcpIpClient.BytesSent, 'BytesSent');
    RegisterPropertyHelper(@TNetTcpIpClientSocketError_R,@TNetTcpIpClientSocketError_W,'SocketError');
    RegisterPropertyHelper(@TNetTcpIpClientLastCommunicationTime_R,nil,'LastCommunicationTime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UTCPIP(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNetTcpIpClient(CL);
  with CL.Add(TBufferedNetTcpIpClient) do
  RIRegister_TBufferedNetTcpIpClientThread(CL);
  RIRegister_TBufferedNetTcpIpClient(CL);
  with CL.Add(TNetTcpIpServer) do
  with CL.Add(TTcpIpServerListenerThread) do
  RIRegister_TTcpIpSocketThread(CL);
  RIRegister_TTcpIpServerListenerThread(CL);
  RIRegister_TNetTcpIpServer(CL);
end;

 
 
{ TPSImport_UTCPIP }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UTCPIP.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UTCPIP(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UTCPIP.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UTCPIP(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
