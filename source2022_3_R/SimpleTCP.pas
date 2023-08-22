{*************************************************************}
{            SimpleTCP components for Delphi and C++ Builder  }
{ Version:   2.0                                              }
{ E-Mail:    info@utilmind.com                                }
{ WWW:       http://www.utilmind.com                          }
{ Created:   July 8, 2000                                     }
{ Modified:  January 17, 2002                                 }
{ Legal:     Copyright (c) 2000-2002, UtilMind Solutions      }
{*************************************************************}
{ SimpleTCP is pack of two components (TSimpleTCPServer and   }
{ TSimpleTCPClient) for working with Asynchronous TCP sockets.}
{*************************************************************}
{ Please see demo program for more information.               }
{*************************************************************}
{                     IMPORTANT NOTE:                         }
{ This software is provided 'as-is', without any express or   }
{ implied warranty. In no event will the author be held       }
{ liable for any damages arising from the use of this         }
{ software.                                                   }
{ Permission is granted to anyone to use this software for    }
{ any purpose, including commercial applications, and to      }
{ alter it and redistribute it freely, subject to the         }
{ following restrictions:                                     }
{ 1. The origin of this software must not be misrepresented,  }
{    you must not claim that you wrote the original software. }
{    If you use this software in a product, an acknowledgment }
{    in the product documentation would be appreciated but is }
{    not required.                                            }
{ 2. Altered source versions must be plainly marked as such,  }
{    and must not be misrepresented as being the original     }
{    software.                                                }
{ 3. This notice may not be removed or altered from any       }
{    source distribution.                                     }
{*************************************************************}
{$IFNDEF VER80}          {Delphi 1}
 {$IFNDEF VER90}         {Delphi 2}
  {$IFNDEF VER93}        {BCB 1}
   {$DEFINE D3}          {* Delphi 3 or higher}
   {$IFNDEF VER100}      {Delphi 3}
    {$IFNDEF VER110}     {BCB 3}
     {$DEFINE D4}        {* Delphi 4 or higher}
    {$ENDIF}
   {$ENDIF}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

unit SimpleTCP;

interface

uses
  Windows, Messages, Classes, WinSock;

const
  UM_TCPASYNCSELECT = WM_USER + $0001;

type
  TSimpleTCPClient = class;

  TSimpleTCPAcceptEvent = procedure(Sender: TObject; Client: TSimpleTCPClient; var Accept: Boolean) of object;
  TSimpleTCPServerEvent = procedure(Sender: TObject; Client: TSimpleTCPClient) of object;
  TSimpleTCPServerDataAvailEvent = procedure(Sender: TObject; Client: TSimpleTCPClient; DataSize: Integer) of object;
  TSimpleTCPClientDataAvailEvent = procedure(Sender: TObject; DataSize: Integer) of object;
  TSimpleTCPServerIOEvent = procedure(Sender: TObject; Client: TSimpleTCPClient; Stream: TStream) of object;
  TSimpleTCPClientIOEvent = procedure(Sender: TObject; Stream: TStream) of object;
  TSimpleTCPErrorEvent = procedure(Sender: TObject; Socket: TSocket; ErrorCode: Integer; ErrorMsg: String) of object;

  TCustomSimpleSocket = class(TComponent)
  private
    FAllowChangeHostAndPortOnConnection: Boolean;
    FHost: String;
    FPort: Word;
    FSocket: TSocket;

    FOnError: TSimpleTCPErrorEvent;

    // For internal use
    FConnections: TList;

    SockAddrIn: TSockAddrIn;
    HostEnt: PHostEnt;
    WSAData: TWSAData;
    WindowHandle: hWnd;

    procedure WndProc(var Message: TMessage); virtual;
    procedure UMTCPSelect(var Msg: TMessage); message UM_TCPASYNCSELECT;

    function  SendBufferTo(Socket: TSocket; Buffer: PChar; BufLength: Integer): Integer; // returns N of bytes sent
    function  SendStreamTo(Socket: TSocket; Stream: TStream): Integer; // returns N of bytes sent
    function  ReceiveFrom(Socket: TSocket; Buffer: PChar; BufLength: Integer; ReceiveCompletely: Boolean): Integer; // returns N of bytes read
    function  ReceiveStreamFrom(Socket: TSocket; Stream: TStream; DataSize: Integer; ReceiveCompletely: Boolean): Integer; // returns N of bytes read
  protected
    procedure SocketError(Socket: TSocket; ErrorCode: Integer); virtual;

    procedure SetHost(Value: String); virtual; abstract;
    procedure SetPort(Value: Word); virtual; abstract;

    procedure DoAccept; virtual; abstract;
    procedure DoConnect; virtual; abstract;
    procedure DoClose(Socket: TSocket); virtual; abstract;
    procedure DoDataAvailable(Client: TSimpleTCPClient; DataSize: Integer; var Handled: Boolean); virtual; abstract;
    procedure DoRead(Client: TSimpleTCPClient; Stream: TStream); virtual; abstract;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    property AllowChangeHostAndPortOnConnection: Boolean read FAllowChangeHostAndPortOnConnection write FAllowChangeHostAndPortOnConnection default False;
    property Host: String read FHost write SetHost;
    property Port: Word read FPort write SetPort default 0;
    property Socket: TSocket read FSocket write FSocket;

    property OnError: TSimpleTCPErrorEvent read FOnError write FOnError;
  end;

  { TSimpleTCPServer }
  TSimpleTCPServer = class(TCustomSimpleSocket)
  private
    FListen: Boolean;

    FOnAccept: TSimpleTCPAcceptEvent;
    FOnClientConnected: TSimpleTCPServerEvent;
    FOnClientDisconnected: TSimpleTCPServerEvent;
    FOnClientDataAvailable: TSimpleTCPServerDataAvailEvent;
    FOnClientRead: TSimpleTCPServerIOEvent;

    function GetLocalHostName: String;
    function GetLocalIP: String;
    procedure SetNoneStr(Value: String);
  protected
    procedure SocketError(Socket: TSocket; ErrorCode: Integer); override;

    procedure SetListen(Value: Boolean); virtual;
    procedure SetPort(Value: Word); override;

    procedure DoAccept; override;
    procedure DoClose(Socket: TSocket); override;
    procedure DoDataAvailable(Client: TSimpleTCPClient; DataSize: Integer; var Handled: Boolean); override;    
    procedure DoRead(Client: TSimpleTCPClient; Stream: TStream); override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    function  Send(Client: TSimpleTCPClient; Buffer: PChar; BufLength: Integer): Integer; // returns N of bytes sent
    function  SendStream(Client: TSimpleTCPClient; Stream: TStream): Integer; // returns N of bytes sent
    procedure Broadcast(Buffer: PChar; BufLength: Integer);
    procedure BroadcastStream(Stream: TStream);
    function  Receive(Client: TSimpleTCPClient; Buffer: PChar; BufLength: Integer; ReceiveCompletely: Boolean): Integer;
    function  ReceiveStream(Client: TSimpleTCPClient; Stream: TStream; DataSize: Integer; ReceiveCompletely: Boolean): Integer;

    property Connections: TList read FConnections;
  published
    property Listen: Boolean read FListen write SetListen stored False;
    property LocalHostName: String read GetLocalHostName write SetNoneStr stored False;
    property LocalIP: String read GetLocalIP write SetNoneStr stored False;    

    property OnAccept: TSimpleTCPAcceptEvent read FOnAccept write FOnAccept;
    property OnClientConnected: TSimpleTCPServerEvent read FOnClientConnected write FOnClientConnected;
    property OnClientDisconnected: TSimpleTCPServerEvent read FOnClientDisconnected write FOnClientDisconnected;
    property OnClientDataAvailable: TSimpleTCPServerDataAvailEvent read FOnClientDataAvailable write FOnClientDataAvailable;
    property OnClientRead: TSimpleTCPServerIOEvent read FOnClientRead write FOnClientRead;

    property AllowChangeHostAndPortOnConnection;
    property Port;
    property OnError;
  end;

  TSimpleTCPClient = class(TCustomSimpleSocket)
  private
    FAutoTryReconnect: Boolean;
    FConditionallyConnected, FConnected: Boolean;

    FOnConnected: TNotifyEvent;
    FOnDisconnected: TNotifyEvent;
    FOnDataAvailable: TSimpleTCPClientDataAvailEvent;
    FOnRead: TSimpleTCPClientIOEvent;

    function  GetIP: LongInt;
    procedure SetIP(Value: LongInt);
  protected
//    procedure WndProc(var Message: TMessage); override;
    procedure SocketError(Socket: TSocket; ErrorCode: Integer); override;

    procedure SetConnected(Value: Boolean); virtual;    
    procedure SetHost(Value: String); override;
    procedure SetPort(Value: Word); override;

    procedure DoConnect; override;
    procedure DoClose(Socket: TSocket); override;
    procedure DoDataAvailable(Client: TSimpleTCPClient; DataSize: Integer; var Handled: Boolean); override;    
    procedure DoRead(Client: TSimpleTCPClient; Stream: TStream); override;
  public
    destructor Destroy; override;

    function Send(Buffer: PChar; BufLength: Integer): Integer; // returns N of bytes sent
    function SendStream(Stream: TStream): Integer; // returns N of bytes sent
    function Receive(Buffer: PChar; BufLength: Integer; ReceiveCompletely: Boolean): Integer;
    function ReceiveStream(Stream: TStream; DataSize: Integer; ReceiveCompletely: Boolean): Integer;

    property IP: LongInt read GetIP write SetIP;
  published
    property AutoTryReconnect: Boolean read FAutoTryReconnect write FAutoTryReconnect default False;
    property Connected: Boolean read FConnected write SetConnected stored False;

    property OnConnected: TNotifyEvent read FOnConnected write FOnConnected;
    property OnDisconnected: TNotifyEvent read FOnDisconnected write FOnDisconnected;
    property OnDataAvailable: TSimpleTCPClientDataAvailEvent read FOnDataAvailable write FOnDataAvailable;
    property OnRead: TSimpleTCPClientIOEvent read FOnRead write FOnRead;

    property AllowChangeHostAndPortOnConnection;
    property Host;
    property Port;
    property OnError;
  end;

procedure Register;

implementation

uses SysUtils, Forms;

const
  PROTO_TCP = 'tcp';

{$IFNDEF D4}
type
  SunB = packed record
    s_b1, s_b2, s_b3, s_b4: Char;
  end;

  SunW = packed record
    s_w1, s_w2: Word;
  end;

  in_addr = record
    case Integer of
      0: (S_un_b: SunB);
      1: (S_un_w: SunW);
      2: (S_addr: LongInt);
  end;
{$ENDIF}

{ Internal utilities }
function IPToStr(IP: Integer): String;
var
  Addr: in_addr;
begin
  Addr.S_addr := IP;
  Result := IntToStr(Byte(Addr.S_un_b.s_b1)) + '.' +
            IntToStr(Byte(Addr.S_un_b.s_b2)) + '.' +
            IntToStr(Byte(Addr.S_un_b.s_b3)) + '.' +
            IntToStr(Byte(Addr.S_un_b.s_b4));
end;

function StrToIP(Host: String): LongInt;
begin
  Result := inet_addr(PChar(Host))  
end;


{ TCustomSimpleSocket }
constructor TCustomSimpleSocket.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  FSocket := INVALID_SOCKET;
  WindowHandle := AllocateHWnd(WndProc);

  if WSAStartup($0101, WSAData) <> 0 then
    raise Exception.Create('Can not start socket session');
end;

destructor TCustomSimpleSocket.Destroy;
begin
  if WSACleanup <> 0 then
    raise Exception.Create('Can not clean socket session');

  DeallocateHWnd(WindowHandle);

  inherited Destroy;
end;

procedure TCustomSimpleSocket.WndProc(var Message: TMessage);
begin
  with Message do
   try
     if Msg = WM_QUERYENDSESSION then
       Result := 1 // Correct shutdown
     else
       Dispatch(Msg);
   except
     Application.HandleException(Self);
   end;
end;

procedure TCustomSimpleSocket.UMTCPSelect(var Msg: TMessage);
var
  tmpSocket: TSocket;
  tmpTCPClient: TSimpleTCPClient;
  SelectEvent, I: Integer;
  MS: TMemoryStream;

  Handled: Boolean;
  DataAvail: LongInt;
begin
  I := WSAGetSelectError(Msg.LParam);
  if I > WSABASEERR then
    SocketError(Msg.wParam, I)
  else
   begin
    SelectEvent := WSAGetSelectEvent(Msg.lParam);
    case SelectEvent of
      FD_READ: begin
                tmpSocket := Msg.wParam;

                { if this is the server }
                tmpTCPClient := nil;
                if Assigned(FConnections) then
                 begin
                  I := FConnections.Count;
                  if I <> 0 then
                   for I := 0 to I - 1 do
                    begin
                     tmpTCPClient := FConnections[I];
                     if tmpTCPClient.FSocket = tmpSocket then Break;
                    end;
                 end;

                MS := TMemoryStream.Create;
                with MS do
                 try
                   while True do
                    begin
                     { check whether data available }
                     if IoctlSocket(tmpSocket, FIONREAD, DataAvail) = SOCKET_ERROR then
                      begin
                       SocketError(tmpSocket, WSAGetLastError);
                       Exit;
                      end;
                     if DataAvail = 0 then Break;

                     Handled := False;
                     DoDataAvailable(tmpTCPClient, DataAvail, Handled);

                     if not Handled then
                       ReceiveStreamFrom(tmpSocket, MS, DataAvail, False);
                    end;

                   if not Handled and (MS.Size <> 0) then
                    begin
                     Seek(0, soFromBeginning); { to beginning of stream }
                     DoRead(tmpTCPClient, MS);
                    end; 
                 finally
                   Free;
                 end;
               end;
      FD_CLOSE: DoClose(Msg.wParam);
      FD_ACCEPT: DoAccept;
      FD_CONNECT: DoConnect;            
     end;
   end;
end;

procedure TCustomSimpleSocket.SocketError(Socket: TSocket; ErrorCode: Integer);
var
  ErrorMsg: String;
begin
  case ErrorCode of
    WSAEINTR: ErrorMsg := 'Interrupted system call';
    WSAEBADF: ErrorMsg := 'Bad file number';
    WSAEACCES: ErrorMsg := 'Permission denied';
    WSAEFAULT: ErrorMsg := 'Bad address';
    WSAEINVAL: ErrorMsg := 'Invalid argument';
    WSAEMFILE: ErrorMsg := 'Too many open files';
    WSAEWOULDBLOCK: ErrorMsg := 'Operation would block';
    WSAEINPROGRESS: ErrorMsg := 'Operation now in progress';
    WSAEALREADY: ErrorMsg := 'Operation already in progress';
    WSAENOTSOCK: ErrorMsg := 'Socket operation on non-socket';
    WSAEDESTADDRREQ: ErrorMsg := 'Destination address required';
    WSAEMSGSIZE: ErrorMsg := 'Message too long';
    WSAEPROTOTYPE: ErrorMsg := 'Protocol wrong type for socket';
    WSAENOPROTOOPT: ErrorMsg := 'Protocol not available';
    WSAEPROTONOSUPPORT: ErrorMsg := 'Protocol not supported';
    WSAESOCKTNOSUPPORT: ErrorMsg := 'Socket type not supported';
    WSAEOPNOTSUPP: ErrorMsg := 'Operation not supported on socket';
    WSAEPFNOSUPPORT: ErrorMsg := 'Protocol family not supported';
    WSAEAFNOSUPPORT: ErrorMsg := 'Address family not supported by protocol family';
    WSAEADDRINUSE: ErrorMsg := 'Address already in use';
    WSAEADDRNOTAVAIL: ErrorMsg := 'Can''t assign requested address';
    WSAENETDOWN: ErrorMsg := 'Network is down';
    WSAENETUNREACH: ErrorMsg := 'Network is unreachable';
    WSAENETRESET: ErrorMsg := 'Network dropped connection on reset';
    WSAECONNABORTED: ErrorMsg := 'Software caused connection abort';
    WSAECONNRESET: ErrorMsg := 'Connection reset by peer';
    WSAENOBUFS: ErrorMsg := 'No buffer space available';
    WSAEISCONN: ErrorMsg := 'Socket is already connected';
    WSAENOTCONN: ErrorMsg := 'Socket is not connected';
    WSAESHUTDOWN: ErrorMsg := 'Can''t send after socket shutdown';
    WSAETOOMANYREFS: ErrorMsg := 'Too many references: can''t splice';
    WSAETIMEDOUT: ErrorMsg := 'Connection timed out';
    WSAECONNREFUSED: ErrorMsg := 'Connection refused';
    WSAELOOP: ErrorMsg := 'Too many levels of symbolic links';
    WSAENAMETOOLONG: ErrorMsg := 'File name too long';
    WSAEHOSTDOWN: ErrorMsg := 'Host is down';
    WSAEHOSTUNREACH: ErrorMsg := 'No route to host';
    WSAENOTEMPTY: ErrorMsg := 'Directory not empty';
    WSAEPROCLIM: ErrorMsg := 'Too many processes';
    WSAEUSERS: ErrorMsg := 'Too many users';
    WSAEDQUOT: ErrorMsg := 'Disk quota exceeded';
    WSAESTALE: ErrorMsg := 'Stale NFS file handle';
    WSAEREMOTE: ErrorMsg := 'Too many levels of remote in path';
    WSASYSNOTREADY: ErrorMsg := 'Network sub-system is unusable';
    WSAVERNOTSUPPORTED: ErrorMsg := 'WinSock DLL cannot support this application';
    WSANOTINITIALISED: ErrorMsg := 'WinSock not initialized';
    WSAHOST_NOT_FOUND: ErrorMsg := 'Host not found';
    WSATRY_AGAIN: ErrorMsg := 'Non-authoritative host not found';
    WSANO_RECOVERY: ErrorMsg := 'Non-recoverable error';
    WSANO_DATA: ErrorMsg := 'No Data';
    else ErrorMsg := 'Not a WinSock error ?';
  end;
  
  if Assigned(FOnError) then
    FOnError(Self, Socket, ErrorCode, ErrorMsg)
  else
    raise Exception.Create(ErrorMsg);
end;

function TCustomSimpleSocket.SendBufferTo(Socket: TSocket; Buffer: PChar; BufLength: Integer): Integer; // bytes sent
begin
  Result := 0;
  if (Socket <> INVALID_SOCKET) and (BufLength <> 0) then
   begin
    Result := WinSock.Send(Socket, Buffer^, BufLength, 0);
    if Result = SOCKET_ERROR then
      SocketError(Socket, WSAGetLastError);
   end;
end;

function  TCustomSimpleSocket.SendStreamTo(Socket: TSocket; Stream: TStream): Integer; // returns N of bytes sent
var
  Buffer: Pointer;
  SavePosition: LongInt;
begin
  Result := 0;
  if (Socket <> INVALID_SOCKET) and (Stream <> nil) then
   begin
    { save position in stream and go to beginning }
    SavePosition := Stream.Position;
    Stream.Seek(0, soFromBeginning);
    try
      { allocate memory for swap buffer }
      GetMem(Buffer, Stream.Size);
      try
        { filling the buffer from stream }
        Stream.Read(Buffer^, Stream.Size);

        { SENDING! }
        Result := WinSock.Send(Socket, Buffer^, Stream.Size, 0);
        if Result = SOCKET_ERROR then { process the error if occurs }
          SocketError(Socket, WSAGetLastError);
      finally
        { release memory taken for buffer }
        FreeMem(Buffer);
      end;  
    finally
      { restore position in stream }
      Stream.Seek(SavePosition, soFromBeginning);
    end;  
   end;
end;

function TCustomSimpleSocket.ReceiveFrom(Socket: TSocket; Buffer: PChar; BufLength: Integer; ReceiveCompletely: Boolean): Integer;
var
  p: Pointer;
  DataAvail: LongInt;
begin
  Result := recv(Socket, Buffer^, BufLength, 0);
  if Result = SOCKET_ERROR then
   begin
    SocketError(Socket, WSAGetLastError);
    Exit;
   end;

  if ReceiveCompletely then
   while Result < BufLength do
    begin
     if IoctlSocket(Socket, FIONREAD, DataAvail) = SOCKET_ERROR then
      begin
       SocketError(Socket, WSAGetLastError);
       Exit;
      end;
     if DataAvail = 0 then Continue;

     p := Pointer(Integer(Buffer) + Result);
     DataAvail := recv(Socket, p^, BufLength - Result, 0);
     if DataAvail = SOCKET_ERROR then
      begin
       SocketError(Socket, WSAGetLastError);
       Exit;
      end;
     inc(Result, DataAvail);
    end;
end;

function  TCustomSimpleSocket.ReceiveStreamFrom(Socket: TSocket; Stream: TStream; DataSize: Integer; ReceiveCompletely: Boolean): Integer;
var
  Buf: Pointer;
begin
  Result := 0;
  if DataSize <= 0 then Exit;
  
  GetMem(Buf, DataSize);
  try
    Result := ReceiveFrom(Socket, Buf, DataSize, ReceiveCompletely);
    if Result <> 0 then
      Stream.Write(Buf^, Result);
  finally
    FreeMem(Buf);
  end;
end;
{------------------------------------------------------------}

{ TSimpleTCPServer }
constructor TSimpleTCPServer.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FConnections := TList.Create;
end;

destructor TSimpleTCPServer.Destroy;
begin
  Listen := False;  // cancel listening
  FConnections.Free;
  inherited Destroy;
end;

procedure TSimpleTCPServer.SocketError(Socket: TSocket; ErrorCode: Integer);
begin
  Listen := False;  // cancel listening
  inherited;
end;

procedure TSimpleTCPServer.DoAccept;
var
  Tmp: Integer;
  tmpSocket: TSocket;
  tmpTCPClient: TSimpleTCPClient;
  IsAccept: Boolean;
begin
  Tmp := SizeOf(SockAddrIn);
  {$IFNDEF D3}
  tmpSocket := WinSock.Accept(FSocket, SockAddrIn, Tmp);
  {$ELSE}
  tmpSocket := WinSock.Accept(FSocket, @SockAddrIn, @Tmp);
  {$ENDIF}
  if tmpSocket = SOCKET_ERROR then
    SocketError(tmpSocket, WSAGetLastError);

{$WARNINGS OFF}
  tmpTCPClient := TSimpleTCPClient.Create(nil);
{$WARNINGS ON}
  tmpTCPClient.FSocket := tmpSocket;
  tmpTCPClient.FHost := inet_ntoa(SockAddrIn.SIn_Addr);
  tmpTCPClient.FPort := FPort;
  tmpTCPClient.FConnected := True;

  if Assigned(FOnAccept) then
   begin
    IsAccept := True;
    FOnAccept(Self, tmpTCPClient, IsAccept);
    if IsAccept then
      Connections.Add(tmpTCPClient)
    else
      tmpTCPClient.Free;
   end
  else
   Connections.Add(tmpTCPClient);

  if Assigned(FOnClientConnected) then
    FOnClientConnected(Self, tmpTCPClient);
end;

procedure TSimpleTCPServer.DoClose(Socket: TSocket);
var
  I: Integer;
  tmpTCPClient: TSimpleTCPClient;
begin
  tmpTCPClient := nil;
  I := FConnections.Count;
  if I <> 0 then
   for I := 0 to I - 1 do
    begin
     tmpTCPClient := FConnections[I];
     if tmpTCPClient.FSocket = Socket then
      begin
       FConnections.Delete(I);
       Break;
      end;
    end;

  if Assigned(tmpTCPClient) then
   begin
    if Assigned(FOnClientDisconnected) and not (csDestroying in ComponentState) then
      FOnClientDisconnected(Self, tmpTCPClient);
      
    tmpTCPClient.Free;
   end;
end;

procedure TSimpleTCPServer.DoDataAvailable(Client: TSimpleTCPClient; DataSize: Integer; var Handled: Boolean);
begin
  Handled := Assigned(FOnClientDataAvailable);
  if Handled then
    FOnClientDataAvailable(Self, Client, DataSize);
end;

procedure TSimpleTCPServer.DoRead(Client: TSimpleTCPClient; Stream: TStream);
begin
  if Assigned(FOnClientRead) then
    FOnClientRead(Self, Client, Stream);
end;

function TSimpleTCPServer.Send(Client: TSimpleTCPClient; Buffer: PChar; BufLength: Integer): Integer; // bytes sent
begin
  Result := SendBufferTo(Client.FSocket, Buffer, BufLength);
end;

function  TSimpleTCPServer.SendStream(Client: TSimpleTCPClient; Stream: TStream): Integer; // returns N of bytes sent
begin
  Result := SendStreamTo(Client.FSocket, Stream);
end;

procedure TSimpleTCPServer.Broadcast(Buffer: PChar; BufLength: Integer);
var
  I: Integer;
begin
  I := FConnections.Count;
  if I <> 0 then
   for I := 0 to I - 1 do
    with TSimpleTCPClient(FConnections[I]) do
     SendBufferTo(FSocket, Buffer, BufLength);
end;

procedure TSimpleTCPServer.BroadcastStream(Stream: TStream);
var
  I: Integer;
begin
  I := FConnections.Count;
  if I <> 0 then
   for I := 0 to I - 1 do
    with TSimpleTCPClient(FConnections[I]) do
     SendStreamTo(FSocket, Stream);
end;

function TSimpleTCPServer.Receive(Client: TSimpleTCPClient; Buffer: PChar; BufLength: Integer; ReceiveCompletely: Boolean): Integer;
begin
  Result := ReceiveFrom(Client.FSocket, Buffer, BufLength, ReceiveCompletely);
end;

function TSimpleTCPServer.ReceiveStream(Client: TSimpleTCPClient; Stream: TStream; DataSize: Integer; ReceiveCompletely: Boolean): Integer;
begin
  Result := ReceiveStreamFrom(Client.FSocket, Stream, DataSize, ReceiveCompletely);
end;

procedure TSimpleTCPServer.SetPort(Value: Word);
begin
  if not (csDesigning in ComponentState) then
   if FPort <> Value then
    if FListen then
     if FAllowChangeHostAndPortOnConnection then
      begin
       Listen := False;
       FPort := Value;
       Listen := True;
      end
     else
      raise Exception.Create('Can not change Port while listening')
    else FPort := Value
   else
  else FPort := Value;
end;

procedure TSimpleTCPServer.SetListen(Value: Boolean);
var
  I: Integer;
  tmpTCPClient: TSimpleTCPClient;
begin
  if not (csDesigning in ComponentState) then
   if FListen <> Value then
    begin
     if Value then
      begin
       FSocket := WinSock.Socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
       if FSocket = SOCKET_ERROR then
        begin
         SocketError(INVALID_SOCKET, WSAGetLastError);
         Exit;
        end;

       SockAddrIn.sin_family := AF_INET;
       SockAddrIn.sin_addr.s_addr := INADDR_ANY;
       SockAddrIn.sin_port := htons(FPort);
       if Bind(FSocket, SockAddrIn, SizeOf(SockAddrIn)) <> 0 then
        begin
         SocketError(FSocket, WSAGetLastError);
         Exit;
        end;

       if WinSock.Listen(FSocket, SOMAXCONN) <> 0 then
        begin
         SocketError(FSocket, WSAGetLastError);
         Exit;
        end;

       if WSAAsyncSelect(FSocket, WindowHandle, UM_TCPASYNCSELECT,
                         FD_READ or FD_ACCEPT or FD_CLOSE) <> 0 then
        begin
         SocketError(FSocket, WSAGetLastError);
         Exit;
        end;
      end
     else
      begin
       // Closing all connections first
       I := FConnections.Count;
       if I <> 0 then
        for I := I - 1 downto 0 do
         begin
          tmpTCPClient := FConnections[I];
          tmpTCPClient.Connected := False;
          FConnections.Delete(I);
         end;

       // Cancel listening
       WSAASyncSelect(FSocket, WindowHandle, UM_TCPASYNCSELECT, 0);
       Shutdown(FSocket, 2);

       if CloseSocket(FSocket) <> 0 then
        begin
         SocketError(FSocket, WSAGetLastError);
         Exit;
        end;

       FSocket := INVALID_SOCKET;
      end;
      FListen := Value;
    end
   else
  else
   FListen := Value;
end;

function TSimpleTCPServer.GetLocalHostName: String;
var
  HostName: Array[0..MAX_PATH] of Char;
begin
  if GetHostName(HostName, MAX_PATH) = 0 then
    Result := HostName
  else
    SocketError(FSocket, WSAGetLastError);
end;

function TSimpleTCPServer.GetLocalIP: String;
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  HostName: Array[0..MAX_PATH] of Char;
begin
  if GetHostName(HostName, MAX_PATH) = 0 then
   begin
    HostEnt:= GetHostByName(HostName);
    if HostEnt = nil then
      Result := ''
    else
     begin
      SockAddrIn.sin_addr.S_addr := LongInt(PLongInt(HostEnt^.h_addr_list^)^);
      Result := inet_ntoa(SockAddrIn.sin_addr);
     end;
   end
  else
   SocketError(FSocket, WSAGetLastError);
end;

procedure TSimpleTCPServer.SetNoneStr(Value: String); begin end;
{------------------------------------------------------------}


{ TSimpleTCPClient }
destructor TSimpleTCPClient.Destroy;
begin
  Connected := False;
  inherited Destroy;
end;

{procedure TSimpleTCPClient.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
end;}

procedure TSimpleTCPClient.SocketError(Socket: TSocket; ErrorCode: Integer);
begin
  Connected := False; // broke connection
  inherited;
end;

procedure TSimpleTCPClient.DoConnect;
begin
  FConnected := True; { definitely connected! }
  if Assigned(FOnConnected) then
    FOnConnected(Self);
end;

procedure TSimpleTCPClient.DoClose(Socket: TSocket);
begin
  Connected := False;
  if not (csDestroying in ComponentState) then
   begin
    if Assigned(FOnDisconnected) then
      FOnDisconnected(Self);

    if FAutoTryReconnect then
      Connected := True;
   end;   
end;

procedure TSimpleTCPClient.DoDataAvailable(Client: TSimpleTCPClient; DataSize: Integer; var Handled: Boolean);
begin
  Handled := Assigned(FOnDataAvailable);
  if Handled then
    FOnDataAvailable(Self, DataSize);
end;

procedure TSimpleTCPClient.DoRead(Client: TSimpleTCPClient; Stream: TStream);
begin
  if Assigned(FOnRead) then
    FOnRead(Self, Stream);
end;

function TSimpleTCPClient.Send(Buffer: PChar; BufLength: Integer): Integer; // bytes sent
begin
  Result := SendBufferTo(FSocket, Buffer, BufLength);
end;

function TSimpleTCPClient.SendStream(Stream: TStream): Integer; // returns N of bytes sent
begin
  Result := SendStreamTo(FSocket, Stream);
end;

function TSimpleTCPClient.Receive(Buffer: PChar; BufLength: Integer; ReceiveCompletely: Boolean): Integer;
begin
  Result := ReceiveFrom(FSocket, Buffer, BufLength, ReceiveCompletely);
end;

function TSimpleTCPClient.ReceiveStream(Stream: TStream; DataSize: Integer; ReceiveCompletely: Boolean): Integer;
begin
  Result := ReceiveStreamFrom(FSocket, Stream, DataSize, ReceiveCompletely);
end;

procedure TSimpleTCPClient.SetConnected(Value: Boolean);
var
  lin: TLinger;
  linx: Array[0..3] of Char absolute lin;
  ErrorCode: Integer;
begin
  if not (csDesigning in ComponentState) then
   if FConditionallyConnected <> Value then
    begin
     FConditionallyConnected := Value;
     if Value then
      begin
       SockAddrIn.sin_family := AF_INET;
       SockAddrIn.sin_port := htons(FPort);
       SockAddrIn.sin_addr.s_addr := inet_addr(PChar(Host));
       if SockAddrIn.sin_addr.s_addr = -1 then
        begin
         HostEnt := GetHostByName(PChar(Host));
         if HostEnt = nil then
          begin
           SocketError(INVALID_SOCKET, WSAEFAULT);
           Exit;
          end;
         SockAddrIn.sin_addr.S_addr := LongInt(PLongInt(HostEnt^.h_addr_list^)^);
        end;
       FSocket := WinSock.Socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
       if FSocket = SOCKET_ERROR then
        begin
         SocketError(INVALID_SOCKET, WSAGetLastError);
         Exit;
        end;

       ErrorCode := WSAASyncSelect(FSocket, WindowHandle, UM_TCPASYNCSELECT,
                                   FD_READ or FD_CONNECT or FD_CLOSE);
       if ErrorCode <> 0 then
        begin
         SocketError(FSocket, WSAGetLastError);
         Exit;
        end;

       ErrorCode := WinSock.Connect(FSocket, SockAddrIn, SizeOf(SockAddrIn));
       if ErrorCode <> 0 then
        begin
         ErrorCode := WSAGetLastError;
         if ErrorCode <> WSAEWOULDBLOCK then
          begin
           SocketError(FSocket, WSAGetLastError);
           Exit;
          end;
        end;
      end
     else
      begin
       WSAASyncSelect(FSocket, WindowHandle, UM_TCPASYNCSELECT, 0);
       Shutdown(FSocket, 2);
       lin.l_onoff := 1;
       lin.l_linger := 0;
       SetSockOpt(FSocket, SOL_SOCKET, SO_LINGER, linx, SizeOf(Lin));

       ErrorCode := CloseSocket(FSocket);
       if ErrorCode <> 0 then
        begin
         SocketError(FSocket, WSAGetLastError);
         Exit;
        end;

       FSocket := INVALID_SOCKET;
       FConnected := False;
       if Assigned(FOnDisconnected) and not (csDestroying in ComponentState) then
         FOnDisconnected(Self);
      end;
    end
   else
  else
   if Value then
    raise Exception.Create('Can not connect at design-time');
end;

procedure TSimpleTCPClient.SetHost(Value: String);
begin
  if not (csDesigning in ComponentState) then
   if FHost <> Value then
    if FConnected then
     if FAllowChangeHostAndPortOnConnection then
      begin
       Connected := False;
       FHost := Value;
       Connected := True;
      end
     else
      raise Exception.Create('Can not change Host while connected')
    else
     FHost := Value
   else
  else FHost := Value;   
end;

procedure TSimpleTCPClient.SetPort(Value: Word);
begin
  if not (csDesigning in ComponentState) then
   if FPort <> Value then
    if FConnected then
     if FAllowChangeHostAndPortOnConnection then
      begin
       Connected := False;
       FPort := Value;
       Connected := True;
      end
     else
      raise Exception.Create('Can not change Port while connected')
    else
     FPort := Value
   else
  else
   FPort := Value;
end;

function  TSimpleTCPClient.GetIP: LongInt;
begin
  Result := StrToIP(Host);
end;

procedure TSimpleTCPClient.SetIP(Value: LongInt);
begin
  Host := IPToStr(Value);
end;

procedure Register;
begin
  RegisterComponents('UtilMind', [TSimpleTCPServer, TSimpleTCPClient]);
end;

end.
