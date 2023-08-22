unit uWebSocket;

interface

uses
  Contnrs,
  IdTCPServer,
  IdThreadMgr,
  IdThreadMgrDefault, SysUtils;

type
  TWebSocketConnection = class;

  TWebSocketMessageEvent = procedure(AConnection: TWebSocketConnection; const AMessage: string) of object;
  TWebSocketConnectEvent = procedure(AConnection: TWebSocketConnection) of object;
  TWebSocketDisconnectEvent = procedure(AConnection: TWebSocketConnection) of object;
  TWebSocketException = class(Exception);
  TWebSocketHandshakeException = class(TWebSocketException);

  // The request is the first part of the handshake
  // sequence between the client and the server. If
  // the request is correct the server will send a
  // handshake response. If the request is not correct
  // a TWebSocketHandshakeException will be raised and
  // the connection must be closed.
  TWebSocketRequest = class
  private
    FResource: string;
    FHost: string;
    FOrigin: string;
    FProtocol: string;
  public
    constructor Create(AConnection: TIdTCPServerConnection);

    property Resource: string read FResource;
    property Host: string read FHost;
    property Origin: string read FOrigin;
    property Protocol: string read FProtocol;
  end;

  // The TWebSocketConnection represents the communication
  // chanel with a single connected client. When the connection
  // is innitiated, the handshake procedure is executed. If the
  // handshake succedes the channel can be used for sending and
  // receiving. If not, the connection must be closed.
  TWebSocketConnection = class
  private
    FPeerThread: TIdPeerThread;
    FHandshakeRequest: TWebSocketRequest;
    FHandshakeResponseSent: Boolean;
    FOnMessageReceived: TWebSocketMessageEvent;
    function GetHandshakeCompleted: Boolean;
    function GetServerConnection: TIdTCPServerConnection;
    function GetPeerIP: string;
  protected
    const
      FRAME_START = #$00;
      FRAME_SIZE_START = #$80;
      FRAME_END = #$FF;

    procedure Handshake;
    procedure SendFrame(const AData: string);

    property PeerThread: TIdPeerThread read FPeerThread write FPeerThread;
    property ServerConnection: TIdTCPServerConnection read GetServerConnection;
    property HandshakeRequest: TWebSocketRequest read FHandshakeRequest write FHandshakeRequest;
    property HandshakeCompleted: Boolean read GetHandshakeCompleted;
    property HandshakeResponseSent: Boolean read FHandshakeResponseSent write FHandshakeResponseSent;
  public
    constructor Create(APeerThread: TIdPeerThread);

    procedure Receive;
    procedure Send(const AMessage: string);

    property OnMessageReceived: TWebSocketMessageEvent read FOnMessageReceived write FOnMessageReceived;
    property PeerIP: string read GetPeerIP;
  end;

  // The TWebSocketServer is a TCP server "decorated" with
  // some websocket specific functionalities.
  TWebSocketServer = class
  private
    FDefaultPort: Integer;
    FTCPServer: TIdTCPServer;
    FThreadManager: TIdThreadMgr;
    FConnections: TObjectList;
    FOnConnect: TWebSocketConnectEvent;
    FOnMessageReceived: TWebSocketMessageEvent;
    FOnDisconnect: TWebSocketDisconnectEvent;
    function GetTCPServer: TIdTCPServer;
    function GetThreadManager: TIdThreadMgr;
    function GetConnections: TObjectList;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
  protected
    procedure TCPServerConnect(AThread: TIdPeerThread);
    procedure TCPServerDisconnect(AThread: TIdPeerThread);
    procedure TCPServerExecute(AThread: TIdPeerThread);
    procedure MessageReceived(AConnection: TWebSocketConnection; const AMessage: string);

    property DefaultPort: Integer read FDefaultPort write FDefaultPort;
    property TCPServer: TIdTCPServer read GetTCPServer;
    property ThreadManager: TIdThreadMgr read GetThreadManager;
    property Connections: TObjectList read GetConnections;
  public
    constructor Create(ADefaultPort: Integer);
    destructor Destroy; override;

    procedure Broadcast(AMessage: string);

    property Active: Boolean read GetActive write SetActive;
    property OnConnect: TWebSocketConnectEvent read FOnConnect write FOnConnect;
    property OnMessageReceived: TWebSocketMessageEvent read FOnMessageReceived write FOnMessageReceived;
    property OnDisconnect: TWebSocketDisconnectEvent read FOnDisconnect write FOnDisconnect;
  end;

implementation

uses
  Masks;

{ TWebSocketServer }

procedure TWebSocketServer.MessageReceived(AConnection: TWebSocketConnection; const AMessage: string);
begin
  if Assigned(OnMessageReceived) and (AConnection.HandshakeCompleted) then
  begin
    OnMessageReceived(AConnection, AMessage);
  end;  
end;

procedure TWebSocketServer.Broadcast(AMessage: string);
var
  ConnectionPtr: Pointer;
  Connection: TWebSocketConnection;
begin
  for ConnectionPtr in Connections do
  begin
    Connection := ConnectionPtr;
    if Connection.HandshakeCompleted then
    begin
      Connection.Send(AMessage);
    end;
  end;
end;

constructor TWebSocketServer.Create(ADefaultPort: Integer);
begin
  DefaultPort := ADefaultPort;
end;

destructor TWebSocketServer.Destroy;
begin
  // Cleanup
  TCPServer.Active := False;
  TCPServer.Free;
  ThreadManager.Free;

  inherited;
end;

function TWebSocketServer.GetActive: Boolean;
begin
  Result := TCPServer.Active;
end;

function TWebSocketServer.GetConnections: TObjectList;
begin
  if not Assigned(FConnections) then
  begin
    FConnections := TObjectList.Create(False);
  end;

  Result := FConnections;
end;

function TWebSocketServer.GetTCPServer: TIdTCPServer;
begin
  if not Assigned(FTCPServer) then
  begin
    FTCPServer := TIdTCPServer.Create(nil);
    FTCPServer.ThreadMgr := ThreadManager;
    FTCPServer.DefaultPort := DefaultPort;

    // Events
    FTCPServer.OnConnect := TCPServerConnect;
    FTCPServer.OnDisconnect := TCPServerDisconnect;
    FTCPServer.OnExecute := TCPServerExecute;
  end;

  Result := FTCPServer;  
end;

function TWebSocketServer.GetThreadManager: TIdThreadMgr;
begin
  if not Assigned(FThreadManager) then
  begin
    FThreadManager := TIdThreadMgrDefault.Create(nil);
  end;

  Result := FThreadManager;
end;

procedure TWebSocketServer.SetActive(const Value: Boolean);
begin
  TCPServer.Active := Value;
end;

procedure TWebSocketServer.TCPServerConnect(AThread: TIdPeerThread);
var
  Connection: TWebSocketConnection;
begin
  Connection := TWebSocketConnection.Create(AThread);
  Connection.OnMessageReceived := MessageReceived;
  Connections.Add(Connection);
  AThread.Data := Connection;

  if Assigned(OnConnect) then
  begin
    OnConnect(Connection);
  end;
end;

procedure TWebSocketServer.TCPServerDisconnect(AThread: TIdPeerThread);
var
  Connection: TWebSocketConnection;
begin
  Connection := AThread.Data as TWebSocketConnection;

  if Assigned(OnDisconnect) then
  begin
    OnDisconnect(Connection);
  end;  

  AThread.Data := nil;
  Connections.Remove(Connection);
  Connection.Free;
end;

procedure TWebSocketServer.TCPServerExecute(AThread: TIdPeerThread);
var
  Client: TWebSocketConnection;
begin
  Client := AThread.Data as TWebSocketConnection;
  Client.Receive;
end;

{ TWebSocketConnection }

constructor TWebSocketConnection.Create(APeerThread: TIdPeerThread);
begin
  HandshakeResponseSent := False;
  PeerThread := APeerThread;
end;

procedure TWebSocketConnection.Receive;
var
  FirstChar: Char;
  Msg: string;
begin
  Msg := '';

  if not HandshakeCompleted then
  begin
    Handshake;
  end else
  begin
    // Read new frame
    FirstChar := ServerConnection.ReadChar;
    case FirstChar of
      FRAME_START: begin
        Msg := PeerThread.Connection.ReadLn(FRAME_END);
      end;
      FRAME_SIZE_START: begin
        raise Exception.Create('Not implemented!');
      end;
    else
      raise Exception.Create('Invalid frame start!');
    end;
  end;

  if (Msg <> '') and (Assigned(OnMessageReceived)) then
  begin
    OnMessageReceived(Self, Msg);
  end;
end;

function TWebSocketConnection.GetServerConnection: TIdTCPServerConnection;
begin
  Result := PeerThread.Connection;
end;

function TWebSocketConnection.GetHandshakeCompleted: Boolean;
begin
  Result := HandshakeResponseSent;
end;

function TWebSocketConnection.GetPeerIP: string;
begin
  Result := ServerConnection.Socket.Binding.PeerIP;
end;

procedure TWebSocketConnection.Handshake;
begin
  // Preconditions
  Assert(not HandshakeResponseSent);

  try
    // Read request headers
    HandshakeRequest := TWebSocketRequest.Create(ServerConnection);

    // Send response headers
    ServerConnection.WriteLn('HTTP/1.1 101 Web Socket Protocol Handshake');
    ServerConnection.WriteLn('Upgrade: WebSocket');
    ServerConnection.WriteLn('Connection: Upgrade');
    ServerConnection.WriteLn('WebSocket-Origin: ' + HandshakeRequest.Origin);
    ServerConnection.WriteLn('WebSocket-Location: ws://' + HandshakeRequest.Host + '/');

    // End handshake
    ServerConnection.WriteLn;
    ServerConnection.WriteLn;

    HandshakeResponseSent := True;
  except
    on E: TWebSocketHandshakeException do
    begin
      // Close the connection if the handshake failed
      ServerConnection.Disconnect;
    end;
  end;
end;

procedure TWebSocketConnection.Send(const AMessage: string);
begin
  Assert(HandshakeCompleted, 'Handshake not completed!');

  SendFrame(AMessage);
end;

procedure TWebSocketConnection.SendFrame(const AData: string);
begin
  if AData <> '' then
  begin
    PeerThread.Connection.Write(FRAME_START + AData + FRAME_END);
  end;
end;

{ TWebSocketRequest }

constructor TWebSocketRequest.Create(AConnection: TIdTCPServerConnection);
var
  Msg: string;
begin
  //    GET /demo HTTP/1.1
  Msg := AConnection.ReadLn;
  Assert(MatchesMask(Msg, 'GET /* HTTP/1.1'));
  FResource := Copy(Msg, 6, Length(Msg) - 14);

  //    Upgrade: WebSocket
  Msg := AConnection.ReadLn;
  if Msg <> 'Upgrade: WebSocket' then
  begin
    raise TWebSocketHandshakeException.Create('');
  end;

  //    Connection: Upgrade
  Msg := AConnection.ReadLn;
  if Msg <> 'Connection: Upgrade' then
  begin
    raise TWebSocketHandshakeException.Create('');
  end;

  //    Host: example.com
  Msg := AConnection.ReadLn;
  if not MatchesMask(Msg, 'Host: *') then
  begin
    raise TWebSocketHandshakeException.Create('');
  end;
  FHost := Copy(Msg, 7, Length(Msg) - 6);

  //    Origin: http://example.com
  Msg := AConnection.ReadLn;
  if not MatchesMask(Msg, 'Origin: *') then
  begin
    raise TWebSocketHandshakeException.Create('');
  end;
  FOrigin := Copy(Msg, 9, Length(Msg) - 8);

  //    WebSocket-Protocol: sample
  Msg := AConnection.ReadLn;
  if Msg <> '' then
  begin
    if not MatchesMask(Msg, 'WebSocket-Protocol: *') then
    begin
      raise TWebSocketHandshakeException.Create('');
    end;
    FProtocol := Copy(Msg, 21, Length(Msg) - 20);
  end;
end;

end.
