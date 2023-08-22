unit uPSI_ScktComp;
{
   redesign of comp  with refactor
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
  TPSImport_ScktComp = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TServerSocket(CL: TPSPascalCompiler);
procedure SIRegister_TCustomServerSocket(CL: TPSPascalCompiler);
procedure SIRegister_TClientSocket(CL: TPSPascalCompiler);
procedure SIRegister_TWinSocketStream(CL: TPSPascalCompiler);
procedure SIRegister_TCustomSocket(CL: TPSPascalCompiler);
procedure SIRegister_TAbstractSocket(CL: TPSPascalCompiler);
procedure SIRegister_TServerClientThread(CL: TPSPascalCompiler);
procedure SIRegister_TServerAcceptThread(CL: TPSPascalCompiler);
procedure SIRegister_TServerWinSocket(CL: TPSPascalCompiler);
procedure SIRegister_TServerClientWinSocket(CL: TPSPascalCompiler);
procedure SIRegister_TClientWinSocket(CL: TPSPascalCompiler);
procedure SIRegister_TCustomWinSocket(CL: TPSPascalCompiler);
procedure SIRegister_ScktComp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ScktComp_Routines(S: TPSExec);
procedure RIRegister_TServerSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomServerSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TClientSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWinSocketStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAbstractSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TServerClientThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TServerAcceptThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TServerWinSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TServerClientWinSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TClientWinSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomWinSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_ScktComp(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,WinSock
  ,SyncObjs
  ,ScktComp
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ScktComp]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TServerSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomServerSocket', 'TServerSocket') do
  with CL.AddClassN(CL.FindClass('TCustomServerSocket'),'TServerSocket') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterProperty('Socket', 'TServerWinSocket', iptr);
    RegisterPublishedProperties;
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('ServerType', 'TServerType', iptrw);
    RegisterProperty('ThreadCacheSize', 'integer', iptrw);
    RegisterProperty('Service', 'string', iptrw);
    RegisterProperty('Address', 'String', iptrw);
    RegisterProperty('Host', 'string', iptrw);
    RegisterProperty('OnConnected', 'TNotifyEvent', iptrw);
    RegisterProperty('Port', 'integer', iptrw);
    RegisterProperty('OnListen', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnAccept', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnGetThread', 'TGetThreadEvent', iptrw);
    RegisterProperty('OnGetSocket', 'TGetSocketEvent', iptrw);
    RegisterProperty('OnThreadStart', 'TThreadNotifyEvent', iptrw);
    RegisterProperty('OnThreadEnd', 'TThreadNotifyEvent', iptrw);
    RegisterProperty('OnClientConnect', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnClientDisConnect', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnClientRead', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnClientWrite', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnClientError', 'TSocketErrorEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomServerSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSocket', 'TCustomServerSocket') do
  with CL.AddClassN(CL.FindClass('TCustomSocket'),'TCustomServerSocket') do begin
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TClientSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSocket', 'TClientSocket') do
  with CL.AddClassN(CL.FindClass('TCustomSocket'),'TClientSocket') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
    RegisterProperty('Socket', 'TClientWinSocket', iptr);
    RegisterProperty('ClientType', 'TClientType', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Address', 'String', iptrw);
    RegisterProperty('Host', 'string', iptrw);
    RegisterProperty('OnConnected', 'TNotifyEvent', iptrw);
    RegisterProperty('Port', 'integer', iptrw);
    RegisterProperty('Service', 'string', iptrw);
    RegisterProperty('OnLookup', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnConnecting', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnConnect', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnDisConnect', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnRead', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnWrite', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnError', 'TSocketErrorEvent', iptrw);

    //property OnLookup: TSocketNotifyEvent read FOnLookup write FOnLookup;
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWinSocketStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TWinSocketStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TWinSocketStream') do begin
    RegisterMethod('Constructor Create( ASocket : TCustomWinSocket; TimeOut : Longint)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Function WaitForData( Timeout : Longint) : Boolean');
    //RegisterMethod('Constructor Create( ASocket : TCustomWinSocket; TimeOut : Longint)');
    RegisterMethod('Function Read( var Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Write( const Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Seek( Offset : Longint; Origin : Word) : Longint');
    //RegisterProperty('TimeOut', 'Longint', iptrw);
     RegisterProperty('TimeOut', 'Longint', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAbstractSocket', 'TCustomSocket') do
  with CL.AddClassN(CL.FindClass('TAbstractSocket'),'TCustomSocket') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAbstractSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TAbstractSocket') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TAbstractSocket') do begin
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure Close');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TServerClientThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TServerClientThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TServerClientThread') do  begin
    RegisterMethod('Constructor Create( CreateSuspended : Boolean; ASocket : TServerClientWinSocket)');
      RegisterMethod('Procedure Free');
      RegisterProperty('ClientSocket', 'TServerClientWinSocket', iptr);
    RegisterProperty('ServerSocket', 'TServerWinSocket', iptr);
    RegisterProperty('KeepInCache', 'Boolean', iptrw);
    RegisterProperty('Data', 'Pointer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TServerAcceptThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TServerAcceptThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TServerAcceptThread') do
  begin
    RegisterMethod('Constructor Create( CreateSuspended : Boolean; ASocket : TServerWinSocket)');
    RegisterMethod('Procedure Execute');
    RegisterProperty('ServerSocket', 'TServerWinSocket', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TServerWinSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomWinSocket', 'TServerWinSocket') do
  with CL.AddClassN(CL.FindClass('TCustomWinSocket'),'TServerWinSocket') do begin
    RegisterMethod('Constructor Create( ASocket : TSocket)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GetClientThread( ClientSocket : TServerClientWinSocket) : TServerClientThread');
    RegisterMethod('Procedure Accept( Socket : TSocket)');
    RegisterMethod('Procedure Disconnect( Socket : TSocket)');
    //RegisterMethod('Function GetClientThread( ClientSocket : TServerClientWinSocket) : TServerClientThread');
    RegisterProperty('ActiveConnections', 'Integer', iptr);
    RegisterProperty('ActiveThreads', 'Integer', iptr);
    RegisterProperty('Connections', 'TCustomWinSocket Integer', iptr);
    RegisterProperty('IdleThreads', 'Integer', iptr);
    RegisterProperty('ServerType', 'TServerType', iptrw);
    RegisterProperty('ThreadCacheSize', 'Integer', iptrw);
    //RegisterProperty('OnGetSocket', 'TGetSocketEvent', iptrw);
    //RegisterProperty('OnGetThread', 'TGetThreadEvent', iptrw);
    RegisterProperty('OnThreadStart', 'TThreadNotifyEvent', iptrw);
    RegisterProperty('OnThreadEnd', 'TThreadNotifyEvent', iptrw);
    RegisterProperty('OnClientConnect', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnClientDisconnect', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnClientRead', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnClientWrite', 'TSocketNotifyEvent', iptrw);
    RegisterProperty('OnClientError', 'TSocketErrorEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TServerClientWinSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomWinSocket', 'TServerClientWinSocket') do
  with CL.AddClassN(CL.FindClass('TCustomWinSocket'),'TServerClientWinSocket') do begin
    RegisterMethod('Constructor Create( Socket : TSocket; ServerWinSocket : TServerWinSocket)');
      RegisterMethod('Procedure Free');
     RegisterProperty('ServerWinSocket', 'TServerWinSocket', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TClientWinSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomWinSocket', 'TClientWinSocket') do
  with CL.AddClassN(CL.FindClass('TCustomWinSocket'),'TClientWinSocket') do
  begin
    RegisterMethod('Procedure Connect( Socket : TSocket)');
    RegisterProperty('ClientType', 'TClientType', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomWinSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCustomWinSocket') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomWinSocket') do begin
    RegisterMethod('Constructor Create( ASocket : TSocket)');
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure Lock');
    RegisterMethod('Procedure Unlock');
    RegisterMethod('Procedure Listen( const Name, Address, Service : string; Port : Word; QueueSize : Integer; Block : Boolean)');
    RegisterMethod('Procedure Open( const Name, Address, Service : string; Port : Word; Block : Boolean)');
    RegisterMethod('Procedure Accept( Socket : TSocket)');
    RegisterMethod('Procedure Connect( Socket : TSocket)');
    RegisterMethod('Procedure Disconnect( Socket : TSocket)');
    RegisterMethod('Procedure Read( Socket : TSocket)');
    RegisterMethod('Procedure Write( Socket : TSocket)');
    RegisterMethod('Function LookupName( const name : string) : TInAddr');
    RegisterMethod('Function LookupService( const service : string) : Integer');
    RegisterMethod('Function ReceiveLength : Integer');
    RegisterMethod('Function ReceiveBuf( var Buf, Count : Integer) : Integer');
    RegisterMethod('Function ReceiveText : string');
    RegisterMethod('Function SendBuf( var Buf, Count : Integer) : Integer');
    RegisterMethod('Function SendStream( AStream : TStream) : Boolean');
    RegisterMethod('Function SendStreamThenDrop( AStream : TStream) : Boolean');
    RegisterMethod('Function SendText( const S : string) : Integer');
    RegisterProperty('LocalHost', 'string', iptr);
    RegisterProperty('LocalAddress', 'string', iptr);
    RegisterProperty('LocalPort', 'Integer', iptr);
    RegisterProperty('RemoteHost', 'string', iptr);
    RegisterProperty('RemoteAddress', 'string', iptr);
    RegisterProperty('RemotePort', 'Integer', iptr);
    RegisterProperty('RemoteAddr', 'TSockAddrIn', iptr);
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterProperty('Addr', 'TSockAddrIn', iptr);
    RegisterProperty('ASyncStyles', 'TAsyncStyles', iptrw);
    RegisterProperty('Handle', 'HWnd', iptr);
    RegisterProperty('SocketHandle', 'TSocket', iptr);
    RegisterProperty('LookupState', 'TLookupState', iptr);
    RegisterProperty('OnSocketEvent', 'TSocketEventEvent', iptrw);
    RegisterProperty('OnErrorEvent', 'TSocketErrorEvent', iptrw);
    RegisterProperty('Data', 'Pointer', iptrw);
    RegisterProperty('UserName', 'String', iptrw);
    RegisterProperty('mx', 'Integer', iptrw);
    RegisterProperty('my', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ScktComp(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('CM_SOCKETMESSAGE','LongWord').SetUInt( WM_USER + $0001);
 CL.AddConstantN('CM_DEFERFREE','LongWord').SetUInt( WM_USER + $0002);
 CL.AddConstantN('CM_LOOKUPCOMPLETE','LongWord').SetUInt( WM_USER + $0003);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ESocketError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSocket');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSocketErrorProc');

  CL.AddTypeS('TCMSocketMessage', 'record Msg : Cardinal; Socket : TSocket; Sel'
  +'ectEvent : Word; SelectError : Word; Result : Longint; end');
  CL.AddTypeS('TCMLookupComplete', 'record Msg : Cardinal; LookupHandle : THand'
   +'le; AsyncBufLen : Word; AsyncError : Word; Result : Longint; end');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomWinSocket');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomSocket');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TServerAcceptThread');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TServerClientThread');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TServerWinSocket');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TServerClientWinSocket');

  CL.AddTypeS('TServerType', '( stNonBlocking, stThreadBlocking )');
  CL.AddTypeS('TClientType', '( ctNonBlocking, ctBlocking )');
  CL.AddTypeS('TAsyncStyle', '( asRead, asWrite, asOOB, asAccept, asConnect, asClose )');
  CL.AddTypeS('TAsyncStyles', 'set of TAsyncStyle');
  CL.AddTypeS('TSocketEvent', '( seLookup, seConnecting, seConnect, seDisconnec'
   +'t, seListen, seAccept, seWrite, seRead )');
  CL.AddTypeS('TLookupState', '( lsIdle, lsLookupAddress, lsLookupService )');
  CL.AddTypeS('TErrorEvent', '( eeGeneral, eeSend, eeReceive, eeConnect, eeDisc'
   +'onnect, eeAccept, eeLookup )');
  CL.AddTypeS('TSocketEventEvent', 'Procedure ( Sender : TObject; Socket : TCus'
   +'tomWinSocket; SocketEvent : TSocketEvent)');
  CL.AddTypeS('TSocketErrorEvent', 'Procedure ( Sender : TObject; Socket : TCus'
   +'tomWinSocket; ErrorEvent : TErrorEvent; var ErrorCode : Integer)');
  CL.AddTypeS('TGetSocketEvent', 'Procedure ( Sender : TObject; Socket : TSocke'
   +'t; var ClientSocket : TServerClientWinSocket)');
  CL.AddTypeS('TGetThreadEvent', 'Procedure ( Sender : TObject; ClientSocket : '
   +'TServerClientWinSocket; var SocketThread : TServerClientThread)');
  CL.AddTypeS('TSocketNotifyEvent', 'Procedure ( Sender : TObject; Socket : TCustomWinSocket)');
  SIRegister_TCustomWinSocket(CL);
  SIRegister_TClientWinSocket(CL);
  SIRegister_TServerClientWinSocket(CL);
  CL.AddTypeS('TThreadNotifyEvent', 'Procedure ( Sender : TObject; Thread : TServerClientThread)');
  SIRegister_TServerWinSocket(CL);
  SIRegister_TServerAcceptThread(CL);
  SIRegister_TServerClientThread(CL);
  SIRegister_TAbstractSocket(CL);
  SIRegister_TCustomSocket(CL);
  SIRegister_TWinSocketStream(CL);
  SIRegister_TClientSocket(CL);
  SIRegister_TCustomServerSocket(CL);
  SIRegister_TServerSocket(CL);
  CL.AddDelphiFunction('Function SetErrorProc( ErrorProc : TSocketErrorProc) : TSocketErrorProc');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TServerSocketSocket_R(Self: TServerSocket; var T: TServerWinSocket);
begin T := Self.Socket; end;

(*----------------------------------------------------------------------------*)
procedure TClientSocketClientType_W(Self: TClientSocket; const T: TClientType);
begin Self.ClientType := T; end;

(*----------------------------------------------------------------------------*)
procedure TClientSocketClientType_R(Self: TClientSocket; var T: TClientType);
begin T := Self.ClientType; end;

(*----------------------------------------------------------------------------*)
procedure TClientSocketSocket_R(Self: TClientSocket; var T: TClientWinSocket);
begin T := Self.Socket; end;

(*----------------------------------------------------------------------------*)
procedure TWinSocketStreamTimeOut_W(Self: TWinSocketStream; const T: Longint);
begin Self.TimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinSocketStreamTimeOut_R(Self: TWinSocketStream; var T: Longint);
begin T := Self.TimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TServerClientThreadData_W(Self: TServerClientThread; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerClientThreadData_R(Self: TServerClientThread; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TServerClientThreadKeepInCache_W(Self: TServerClientThread; const T: Boolean);
begin Self.KeepInCache := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerClientThreadKeepInCache_R(Self: TServerClientThread; var T: Boolean);
begin T := Self.KeepInCache; end;

(*----------------------------------------------------------------------------*)
procedure TServerClientThreadServerSocket_R(Self: TServerClientThread; var T: TServerWinSocket);
begin T := Self.ServerSocket; end;

(*----------------------------------------------------------------------------*)
procedure TServerClientThreadClientSocket_R(Self: TServerClientThread; var T: TServerClientWinSocket);
begin T := Self.ClientSocket; end;

(*----------------------------------------------------------------------------*)
procedure TServerAcceptThreadServerSocket_R(Self: TServerAcceptThread; var T: TServerWinSocket);
begin T := Self.ServerSocket; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnClientError_W(Self: TServerWinSocket; const T: TSocketErrorEvent);
begin Self.OnClientError := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnClientError_R(Self: TServerWinSocket; var T: TSocketErrorEvent);
begin T := Self.OnClientError; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnClientWrite_W(Self: TServerWinSocket; const T: TSocketNotifyEvent);
begin Self.OnClientWrite := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnClientWrite_R(Self: TServerWinSocket; var T: TSocketNotifyEvent);
begin T := Self.OnClientWrite; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnClientRead_W(Self: TServerWinSocket; const T: TSocketNotifyEvent);
begin Self.OnClientRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnClientRead_R(Self: TServerWinSocket; var T: TSocketNotifyEvent);
begin T := Self.OnClientRead; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnClientDisconnect_W(Self: TServerWinSocket; const T: TSocketNotifyEvent);
begin Self.OnClientDisconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnClientDisconnect_R(Self: TServerWinSocket; var T: TSocketNotifyEvent);
begin T := Self.OnClientDisconnect; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnClientConnect_W(Self: TServerWinSocket; const T: TSocketNotifyEvent);
begin Self.OnClientConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnClientConnect_R(Self: TServerWinSocket; var T: TSocketNotifyEvent);
begin T := Self.OnClientConnect; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnThreadEnd_W(Self: TServerWinSocket; const T: TThreadNotifyEvent);
begin Self.OnThreadEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnThreadEnd_R(Self: TServerWinSocket; var T: TThreadNotifyEvent);
begin T := Self.OnThreadEnd; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnThreadStart_W(Self: TServerWinSocket; const T: TThreadNotifyEvent);
begin Self.OnThreadStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnThreadStart_R(Self: TServerWinSocket; var T: TThreadNotifyEvent);
begin T := Self.OnThreadStart; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnGetThread_W(Self: TServerWinSocket; const T: TGetThreadEvent);
begin Self.OnGetThread := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnGetThread_R(Self: TServerWinSocket; var T: TGetThreadEvent);
begin T := Self.OnGetThread; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnGetSocket_W(Self: TServerWinSocket; const T: TGetSocketEvent);
begin Self.OnGetSocket := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketOnGetSocket_R(Self: TServerWinSocket; var T: TGetSocketEvent);
begin T := Self.OnGetSocket; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketThreadCacheSize_W(Self: TServerWinSocket; const T: Integer);
begin Self.ThreadCacheSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketThreadCacheSize_R(Self: TServerWinSocket; var T: Integer);
begin T := Self.ThreadCacheSize; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketServerType_W(Self: TServerWinSocket; const T: TServerType);
begin Self.ServerType := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketServerType_R(Self: TServerWinSocket; var T: TServerType);
begin T := Self.ServerType; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketIdleThreads_R(Self: TServerWinSocket; var T: Integer);
begin T := Self.IdleThreads; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketConnections_R(Self: TServerWinSocket; var T: TCustomWinSocket; const t1: Integer);
begin T := Self.Connections[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketActiveThreads_R(Self: TServerWinSocket; var T: Integer);
begin T := Self.ActiveThreads; end;

(*----------------------------------------------------------------------------*)
procedure TServerWinSocketActiveConnections_R(Self: TServerWinSocket; var T: Integer);
begin T := Self.ActiveConnections; end;

(*----------------------------------------------------------------------------*)
procedure TServerClientWinSocketServerWinSocket_R(Self: TServerClientWinSocket; var T: TServerWinSocket);
begin T := Self.ServerWinSocket; end;

(*----------------------------------------------------------------------------*)
procedure TClientWinSocketClientType_W(Self: TClientWinSocket; const T: TClientType);
begin Self.ClientType := T; end;

(*----------------------------------------------------------------------------*)
procedure TClientWinSocketClientType_R(Self: TClientWinSocket; var T: TClientType);
begin T := Self.ClientType; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketData_W(Self: TCustomWinSocket; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketData_R(Self: TCustomWinSocket; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketOnErrorEvent_W(Self: TCustomWinSocket; const T: TSocketErrorEvent);
begin Self.OnErrorEvent := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketOnErrorEvent_R(Self: TCustomWinSocket; var T: TSocketErrorEvent);
begin T := Self.OnErrorEvent; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketOnSocketEvent_W(Self: TCustomWinSocket; const T: TSocketEventEvent);
begin Self.OnSocketEvent := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketOnSocketEvent_R(Self: TCustomWinSocket; var T: TSocketEventEvent);
begin T := Self.OnSocketEvent; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketLookupState_R(Self: TCustomWinSocket; var T: TLookupState);
begin T := Self.LookupState; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketSocketHandle_R(Self: TCustomWinSocket; var T: TSocket);
begin T := Self.SocketHandle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketHandle_R(Self: TCustomWinSocket; var T: HWnd);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketASyncStyles_W(Self: TCustomWinSocket; const T: TAsyncStyles);
begin Self.ASyncStyles := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketASyncStyles_R(Self: TCustomWinSocket; var T: TAsyncStyles);
begin T := Self.ASyncStyles; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketAddr_R(Self: TCustomWinSocket; var T: TSockAddrIn);
begin T := Self.Addr; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketConnected_R(Self: TCustomWinSocket; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketRemoteAddr_R(Self: TCustomWinSocket; var T: TSockAddrIn);
begin T := Self.RemoteAddr; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketRemotePort_R(Self: TCustomWinSocket; var T: Integer);
begin T := Self.RemotePort; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketRemoteAddress_R(Self: TCustomWinSocket; var T: string);
begin T := Self.RemoteAddress; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketRemoteHost_R(Self: TCustomWinSocket; var T: string);
begin T := Self.RemoteHost; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketLocalPort_R(Self: TCustomWinSocket; var T: Integer);
begin T := Self.LocalPort; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketLocalAddress_R(Self: TCustomWinSocket; var T: string);
begin T := Self.LocalAddress; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketLocalHost_R(Self: TCustomWinSocket; var T: string);
begin T := Self.LocalHost; end;


(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketmy_W(Self: TCustomWinSocket; const T: Integer);
begin //Self.my := T;
end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketmy_R(Self: TCustomWinSocket; var T: Integer);
begin //T := Self.my;
end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketmx_W(Self: TCustomWinSocket; const T: Integer);
begin //Self.mx := T;
end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketmx_R(Self: TCustomWinSocket; var T: Integer);
begin //T := Self.mx;
end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketUserName_W(Self: TCustomWinSocket; const T: String);
begin //Self.UserName := T;
end;

(*----------------------------------------------------------------------------*)
procedure TCustomWinSocketUserName_R(Self: TCustomWinSocket; var T: String);
begin //T := Self.UserName;
end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_ScktComp_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetErrorProc, 'SetErrorProc', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServerSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServerSocket) do begin
    RegisterConstructor(@TServerSocket.Create, 'Create');
    RegisterPropertyHelper(@TServerSocketSocket_R,nil,'Socket');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomServerSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomServerSocket) do  begin
     RegisterMethod(@TCustomServerSocket.Destroy, 'Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TClientSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TClientSocket) do begin
   RegisterConstructor(@TClientSocket.Create, 'Create');
   RegisterMethod(@TClientSocket.Destroy, 'Free');
    RegisterPropertyHelper(@TClientSocketSocket_R,nil,'Socket');
    RegisterPropertyHelper(@TClientSocketClientType_R,@TClientSocketClientType_W,'ClientType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWinSocketStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWinSocketStream) do begin
    RegisterConstructor(@TWinSocketStream.Create, 'Create');
    RegisterMethod(@TWinSocketStream.Destroy, 'Free');
    RegisterMethod(@TWinSocketStream.WaitForData, 'WaitForData');
    RegisterMethod(@TWinSocketStream.Read, 'Read');
    RegisterMethod(@TWinSocketStream.Write, 'Write');
    RegisterMethod(@TWinSocketStream.Seek, 'Seek');
    RegisterPropertyHelper(@TWinSocketStreamTimeOut_R,@TWinSocketStreamTimeOut_W,'TimeOut');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomSocket) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAbstractSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAbstractSocket) do
  begin
    RegisterMethod(@TAbstractSocket.Open, 'Open');
    RegisterMethod(@TAbstractSocket.Close, 'Close');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServerClientThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServerClientThread) do begin
    RegisterConstructor(@TServerClientThread.Create, 'Create');
    RegisterMethod(@TServerClientThread.Destroy, 'Free');
     RegisterPropertyHelper(@TServerClientThreadClientSocket_R,nil,'ClientSocket');
    RegisterPropertyHelper(@TServerClientThreadServerSocket_R,nil,'ServerSocket');
    RegisterPropertyHelper(@TServerClientThreadKeepInCache_R,@TServerClientThreadKeepInCache_W,'KeepInCache');
    RegisterPropertyHelper(@TServerClientThreadData_R,@TServerClientThreadData_W,'Data');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServerAcceptThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServerAcceptThread) do
  begin
    RegisterConstructor(@TServerAcceptThread.Create, 'Create');
    RegisterMethod(@TServerAcceptThread.Execute, 'Execute');
    RegisterPropertyHelper(@TServerAcceptThreadServerSocket_R,nil,'ServerSocket');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServerWinSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServerWinSocket) do begin
    RegisterConstructor(@TServerWinSocket.Create, 'Create');
        RegisterMethod(@TServerWinSocket.Destroy, 'Free');
      RegisterMethod(@TServerWinSocket.Accept, 'Accept');
    RegisterMethod(@TServerWinSocket.Disconnect, 'Disconnect');
     RegisterMethod(@TServerWinSocket.GetClientThread, 'GetClientThread');
    RegisterPropertyHelper(@TServerWinSocketActiveConnections_R,nil,'ActiveConnections');
    RegisterPropertyHelper(@TServerWinSocketActiveThreads_R,nil,'ActiveThreads');
    RegisterPropertyHelper(@TServerWinSocketConnections_R,nil,'Connections');
    RegisterPropertyHelper(@TServerWinSocketIdleThreads_R,nil,'IdleThreads');
    RegisterPropertyHelper(@TServerWinSocketServerType_R,@TServerWinSocketServerType_W,'ServerType');
    RegisterPropertyHelper(@TServerWinSocketThreadCacheSize_R,@TServerWinSocketThreadCacheSize_W,'ThreadCacheSize');
    RegisterPropertyHelper(@TServerWinSocketOnGetSocket_R,@TServerWinSocketOnGetSocket_W,'OnGetSocket');
    RegisterPropertyHelper(@TServerWinSocketOnGetThread_R,@TServerWinSocketOnGetThread_W,'OnGetThread');
    RegisterPropertyHelper(@TServerWinSocketOnThreadStart_R,@TServerWinSocketOnThreadStart_W,'OnThreadStart');
    RegisterPropertyHelper(@TServerWinSocketOnThreadEnd_R,@TServerWinSocketOnThreadEnd_W,'OnThreadEnd');
    RegisterPropertyHelper(@TServerWinSocketOnClientConnect_R,@TServerWinSocketOnClientConnect_W,'OnClientConnect');
    RegisterPropertyHelper(@TServerWinSocketOnClientDisconnect_R,@TServerWinSocketOnClientDisconnect_W,'OnClientDisconnect');
    RegisterPropertyHelper(@TServerWinSocketOnClientRead_R,@TServerWinSocketOnClientRead_W,'OnClientRead');
    RegisterPropertyHelper(@TServerWinSocketOnClientWrite_R,@TServerWinSocketOnClientWrite_W,'OnClientWrite');
    RegisterPropertyHelper(@TServerWinSocketOnClientError_R,@TServerWinSocketOnClientError_W,'OnClientError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServerClientWinSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServerClientWinSocket) do begin
    RegisterConstructor(@TServerClientWinSocket.Create, 'Create');
     RegisterMethod(@TServerClientWinSocket.Destroy, 'Free');
    RegisterPropertyHelper(@TServerClientWinSocketServerWinSocket_R,nil,'ServerWinSocket');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TClientWinSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TClientWinSocket) do
  begin
    RegisterMethod(@TClientWinSocket.Connect, 'Connect');
    RegisterPropertyHelper(@TClientWinSocketClientType_R,@TClientWinSocketClientType_W,'ClientType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomWinSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomWinSocket) do begin
    RegisterConstructor(@TCustomWinSocket.Create, 'Create');
    RegisterMethod(@TCustomWinSocket.Close, 'Close');
    RegisterMethod(@TCustomWinSocket.Lock, 'Lock');
    RegisterMethod(@TCustomWinSocket.Unlock, 'Unlock');
    RegisterMethod(@TCustomWinSocket.Listen, 'Listen');
    RegisterMethod(@TCustomWinSocket.Open, 'Open');
    RegisterVirtualMethod(@TCustomWinSocket.Accept, 'Accept');
    RegisterVirtualMethod(@TCustomWinSocket.Connect, 'Connect');
    RegisterVirtualMethod(@TCustomWinSocket.Disconnect, 'Disconnect');
    RegisterVirtualMethod(@TCustomWinSocket.Read, 'Read');
    RegisterVirtualMethod(@TCustomWinSocket.Write, 'Write');
    RegisterMethod(@TCustomWinSocket.LookupName, 'LookupName');
    RegisterMethod(@TCustomWinSocket.LookupService, 'LookupService');
    RegisterMethod(@TCustomWinSocket.ReceiveLength, 'ReceiveLength');
    RegisterMethod(@TCustomWinSocket.ReceiveBuf, 'ReceiveBuf');
    RegisterMethod(@TCustomWinSocket.ReceiveText, 'ReceiveText');
    RegisterMethod(@TCustomWinSocket.SendBuf, 'SendBuf');
    RegisterMethod(@TCustomWinSocket.SendStream, 'SendStream');
    RegisterMethod(@TCustomWinSocket.SendStreamThenDrop, 'SendStreamThenDrop');
    RegisterMethod(@TCustomWinSocket.SendText, 'SendText');
    RegisterPropertyHelper(@TCustomWinSocketLocalHost_R,nil,'LocalHost');
    RegisterPropertyHelper(@TCustomWinSocketLocalAddress_R,nil,'LocalAddress');
    RegisterPropertyHelper(@TCustomWinSocketLocalPort_R,nil,'LocalPort');
    RegisterPropertyHelper(@TCustomWinSocketRemoteHost_R,nil,'RemoteHost');
    RegisterPropertyHelper(@TCustomWinSocketRemoteAddress_R,nil,'RemoteAddress');
    RegisterPropertyHelper(@TCustomWinSocketRemotePort_R,nil,'RemotePort');
    RegisterPropertyHelper(@TCustomWinSocketRemoteAddr_R,nil,'RemoteAddr');
    RegisterPropertyHelper(@TCustomWinSocketConnected_R,nil,'Connected');
    RegisterPropertyHelper(@TCustomWinSocketAddr_R,nil,'Addr');
    RegisterPropertyHelper(@TCustomWinSocketASyncStyles_R,@TCustomWinSocketASyncStyles_W,'ASyncStyles');
    RegisterPropertyHelper(@TCustomWinSocketHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TCustomWinSocketSocketHandle_R,nil,'SocketHandle');
    RegisterPropertyHelper(@TCustomWinSocketLookupState_R,nil,'LookupState');
    RegisterPropertyHelper(@TCustomWinSocketOnSocketEvent_R,@TCustomWinSocketOnSocketEvent_W,'OnSocketEvent');
    RegisterPropertyHelper(@TCustomWinSocketOnErrorEvent_R,@TCustomWinSocketOnErrorEvent_W,'OnErrorEvent');
    RegisterPropertyHelper(@TCustomWinSocketData_R,@TCustomWinSocketData_W,'Data');
    RegisterPropertyHelper(@TCustomWinSocketUserName_R,@TCustomWinSocketUserName_W,'UserName');
    RegisterPropertyHelper(@TCustomWinSocketmx_R,@TCustomWinSocketmx_W,'mx');
    RegisterPropertyHelper(@TCustomWinSocketmy_R,@TCustomWinSocketmy_W,'my');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ScktComp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ESocketError) do
  with CL.Add(TCustomWinSocket) do
  with CL.Add(TCustomSocket) do
  with CL.Add(TServerAcceptThread) do
  with CL.Add(TServerClientThread) do
  with CL.Add(TServerWinSocket) do
  with CL.Add(TServerClientWinSocket) do
  RIRegister_TCustomWinSocket(CL);
  RIRegister_TClientWinSocket(CL);
  RIRegister_TServerClientWinSocket(CL);
  RIRegister_TServerWinSocket(CL);
  RIRegister_TServerAcceptThread(CL);
  RIRegister_TServerClientThread(CL);
  RIRegister_TAbstractSocket(CL);
  RIRegister_TCustomSocket(CL);
  RIRegister_TWinSocketStream(CL);
  RIRegister_TClientSocket(CL);
  RIRegister_TCustomServerSocket(CL);
  RIRegister_TServerSocket(CL);
end;

 
 
{ TPSImport_ScktComp }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ScktComp.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ScktComp(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ScktComp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ScktComp(ri);
  RIRegister_ScktComp_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
