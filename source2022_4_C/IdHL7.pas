{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10187: IdHL7.pas 
{
{   Rev 1.3    30/6/2003 15:07:54  GGrieve
{ Remove kdeVersionMark (legacy internal code it Kestral)
}
{
{   Rev 1.2    20/6/2003 11:16:36  GGrieve
{ fix compile problem
}
{
{   Rev 1.1    20/6/2003 08:59:28  GGrieve
{ connection in events, and fix problem with singleThread mode
}
{
  Indy HL7 Minimal Lower Layer Protocol TIdHL7

    Original author Grahame Grieve

    This code was donated by HL7Connect.com
    For more HL7 open source code see
    http://www.hl7connect.com/tools

  This unit implements support for the Standard HL7 minimal Lower Layer
  protocol. For further details, consult the HL7 standard (www.hl7.org).

  Before you can use this component, you must set the following properties:
    CommunicationMode
    Address (if you want to be a client)
    Port
    isListener
  and hook the appropriate events (see below)

  This component will operate as either a server or a client depending on
  the configuration
}

{
 Version History:
   20/06/2003   Grahame Grieve      Add Connection to events. (break existing code, sorry)
   05/09/2002   Grahame Grieve      Fixed SingleThread Timeout Issues + WaitForConnection
   23/01/2002   Grahame Grieve      Fixed for network changes to TIdTCPxxx
                                    wrote DUnit testing,
                                    increased assertions
                                    change OnMessageReceive - added VHandled parameter
   07/12/2001   Grahame Grieve      Various fixes for cmSingleThread mode
   05/11/2001   Grahame Grieve      Merge into Indy
   03/09/2001   Grahame Grieve      Prepare for Indy
}

(* note: Events are structurally important for this component. However there is
  a bug in SyncObjs for Linux under Kylix 1 and 2 where TEvent.WaitFor cannot be
  used with timeouts. If you compile your own RTL, then you can fix the routine
  like this:

    function TEvent.WaitFor(Timeout: LongWord): TWaitResult;
    {$IFDEF LINUX}
    var ts : TTimeSpec;
    begin
      ts.tv_sec  := timeout div 1000;
      ts.tv_nsec := (timeout mod 1000) * 1000000;
      if sem_timedwait(FSem, ts) = 0 then
        result := wrSignaled
      else
        result := wrTimeOut;
    {$ENDIF}

  and then disable this define: *)

  { this is a serious issue - unless you fix the RTL, this component does not
    function properly on Linux at the present time. This may be fixed in a
    future version }

unit IdHL7;

interface

uses
  Classes,
  IdBaseComponent,
  IdException,
  IdGlobal,
  IdTCPClient,
  IdTCPConnection,
  IdTCPServer,
  SyncObjs,
  SysUtils;

const
  MSG_START = #$0B;       {do not localize}
  MSG_END = #$1C#$0D;   {do not localize}

  BUFFER_SIZE_LIMIT = 1024 * 1024;  // buffer is allowed to grow to this size without any
  // valid messages. Will be truncated with no notice (DoS protection)

  WAIT_STOP = 5000; // nhow long we wait for things to shut down cleanly

type
  EHL7CommunicationError = class(EIdException)
  Protected
    FInterfaceName: String;
  Public
    constructor Create(AnInterfaceName, AMessage: String);
    property InterfaceName: String Read FInterfaceName;
  end;


  THL7CommunicationMode = (cmUnknown,        // not valid - default setting must be changed by application
    cmAsynchronous,   // see comments below for meanings of the other parameters
    cmSynchronous,
    cmSingleThread);

  TSendResponse = (srNone,          // internal use only - never returned
    srError,         // internal use only - never returned
    srNoConnection,  // you tried to send but there was no connection
    srSent,          // you asked to send without waiting, and it has been done
    srOK,            // sent ok, and response returned
    srTimeout);      // we sent but there was no response (connection will be dropped internally

  TIdHL7Status = (isStopped,       // not doing anything
    isNotConnected,  // not Connected (Server state)
    isConnecting,    // Client is attempting to connect
    isWaitReconnect, // Client is in delay loop prior to attempting to connect
    isConnected,     // connected OK
    isUnusable       // Not Usable - stop failed
    );

const
  { default property values }
  DEFAULT_ADDRESS = '';         {do not localize}
  DEFAULT_PORT = 0;
  DEFAULT_TIMEOUT = 30000;
  DEFAULT_RECEIVE_TIMEOUT = 30000;
  NULL_IP = '0.0.0.0';  {do not localize}
  DEFAULT_CONN_LIMIT = 1;
  DEFAULT_RECONNECT_DELAY = 15000;
  DEFAULT_COMM_MODE = cmUnknown;
  DEFAULT_IS_LISTENER = True;
  MILLISECOND_LENGTH = (1 / (24 * 60 * 60 * 1000));

type
  // the connection is provided in these events so that applications can obtain information about the
  // the peer. It's never OK to write to these connections
  TMessageArriveEvent = procedure(ASender: TObject; AConnection: TIdTCPConnection; AMsg: String) of object;
  TMessageReceiveEvent = procedure(ASender: TObject; AConnection: TIdTCPConnection; AMsg: String; var VHandled: Boolean; var VReply: String) of object;
  TReceiveErrorEvent = procedure(ASender: TObject; AConnection: TIdTCPConnection; AMsg: String; AException: Exception; var VReply: String; var VDropConnection: Boolean) of object;

  TIdHL7 = class;
  TIdHL7ConnCountEvent = procedure(ASender: TIdHL7; AConnCount: Integer) of object;

  TIdHL7PeerThread = class(TIdPeerThread)
  Protected
    FBuffer: String;
  Public
    constructor Create(ACreateSuspended: Boolean = True); Override;
    destructor Destroy; Override;
  end;

  TIdHL7ClientThread = class(TThread)
  Protected
    FClient: TIdTCPClient;
    FCloseEvent: TIdLocalEvent;
    FOwner: TIdHL7;
    procedure Execute; Override;
    procedure PollStack;
  Public
    constructor Create(aOwner: TIdHL7);
    destructor Destroy; Override;
  end;

  TIdHL7 = class(TIdBaseComponent)
  Protected
    FLock: TCriticalSection;
    FStatus: TIdHL7Status;
    FStatusDesc: String;

    // these queues hold messages when running in singlethread mode
    FMsgQueue: TList;
    FHndMsgQueue: TList;

    FAddress: String;
    FCommunicationMode: THL7CommunicationMode;
    FConnectionLimit: Word;
    FIPMask: String;
    FIPRestriction: String;
    FIsListener: Boolean;
    FObject: TObject;
    FPreStopped: Boolean;
    FPort: Word;
    FReconnectDelay: Cardinal;
    FTimeOut: Cardinal;
    FReceiveTimeout: Cardinal;


    FOnConnect: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    FOnConnCountChange: TIdHL7ConnCountEvent;
    FOnMessageArrive: TMessageArriveEvent;
    FOnReceiveMessage: TMessageReceiveEvent;
    FOnReceiveError: TReceiveErrorEvent;

    FIsServer: Boolean;
    // current connection count (server only) (can only exceed 1 when mode is not
    // asynchronous and we are listening)
    FConnCount: Integer;
    FServer: TIdTCPServer;
    // if we are a server, and the mode is not asynchronous, and we are not listening, then
    // we will track the current server connection with this, so we can initiate sending on it
    FServerConn: TIdTCPServerConnection;

    // A thread exists to connect and receive incoming tcp traffic
    FClientThread: TIdHL7ClientThread;
    FClient: TIdTCPClient;

    // these fields are used for handling message response in synchronous mode
    FWaitingForAnswer: Boolean;
    FWaitStop: TDatetime;
    FMsgReply: String;
    FReplyResponse: TSendResponse;
    FWaitEvent: TIdLocalEvent;

    procedure SetAddress(const AValue: String);
    procedure SetConnectionLimit(const AValue: Word);
    procedure SetIPMask(const AValue: String);
    procedure SetIPRestriction(const AValue: String);
    procedure SetPort(const AValue: Word);
    procedure SetReconnectDelay(const AValue: Cardinal);
    procedure SetTimeOut(const AValue: Cardinal);
    procedure SetCommunicationMode(const AValue: THL7CommunicationMode);
    procedure SetIsListener(const AValue: Boolean);
    function GetStatus: TIdHL7Status;
    function GetStatusDesc: String;

    procedure InternalSetStatus(const AStatus: TIdHL7Status; ADesc: String);

    procedure CheckServerParameters;
    procedure StartServer;
    procedure StopServer;
    procedure DropServerConnection;
    procedure ServerConnect(AThread: TIdPeerThread);
    procedure ServerExecute(AThread: TIdPeerThread);
    procedure ServerDisconnect(AThread: TIdPeerThread);

    procedure CheckClientParameters;
    procedure StartClient;
    procedure StopClient;
    procedure DropClientConnection;

    procedure HandleIncoming(var VBuffer: String; AConnection: TIdTCPConnection);
    function HandleMessage(const AMsg: String; AConn: TIdTCPConnection; var VReply: String): Boolean;
  Public
    constructor Create(Component: TComponent); Override;
    destructor Destroy; Override;

    procedure EnforceWaitReplyTimeout;

    function Going: Boolean;

    // for the app to use to hold any related object
    property ObjTag: TObject Read FObject Write FObject;

    // status
    property Status: TIdHL7Status Read GetStatus;
    property StatusDesc: String Read GetStatusDesc;
    function Connected: Boolean;

    property IsServer: Boolean Read FIsServer;
    procedure Start;
    procedure PreStop; // call this in advance to start the shut down process. You do not need to call this
    procedure Stop;

    procedure WaitForConnection(AMaxLength: Integer); // milliseconds

    // asynchronous.
    function AsynchronousSend(AMsg: String): TSendResponse;
    property OnMessageArrive: TMessageArriveEvent Read FOnMessageArrive Write FOnMessageArrive;

    // synchronous
    function SynchronousSend(AMsg: String; var VReply: String): TSendResponse;
    property OnReceiveMessage: TMessageReceiveEvent Read FOnReceiveMessage Write FOnReceiveMessage;
    procedure CheckSynchronousSendResult(AResult: TSendResponse; AMsg: String);

    // single thread
    procedure SendMessage(AMsg: String);
    // you can't call SendMessage again without calling GetReply first
    function GetReply(var VReply: String): TSendResponse;
    function GetMessage(var VMsg: String): pointer;  // return nil if no messages
    // if you don't call SendReply then no reply will be sent.
    procedure SendReply(AMsgHnd: pointer; AReply: String);

  Published
    // basic properties
    property Address: String Read FAddress Write SetAddress;  // leave blank and we will be server
    property Port: Word Read FPort Write SetPort Default DEFAULT_PORT;

    // milliseconds - message timeout - how long we wait for other system to reply
    property TimeOut: Cardinal Read FTimeOut Write SetTimeOut Default DEFAULT_TIMEOUT;

    // milliseconds - message timeout. When running cmSingleThread, how long we wait for the application to process an incoming message before giving up
    property ReceiveTimeout: Cardinal Read FReceiveTimeout Write FReceiveTimeout Default DEFAULT_RECEIVE_TIMEOUT;

    // server properties
    property ConnectionLimit: Word Read FConnectionLimit Write SetConnectionLimit Default DEFAULT_CONN_LIMIT; // ignored if isListener is false
    property IPRestriction: String Read FIPRestriction Write SetIPRestriction;
    property IPMask: String Read FIPMask Write SetIPMask;

    // client properties

    // milliseconds - how long we wait after losing connection to retry
    property ReconnectDelay: Cardinal Read FReconnectDelay Write SetReconnectDelay Default DEFAULT_RECONNECT_DELAY;

    // message flow

    // Set this to one of 4 possibilities:
    //
    //    cmUnknown
    //       Default at start up. You must set a value before starting
    //
    //    cmAsynchronous
    //        Send Messages with AsynchronousSend. does not wait for
    //                   remote side to respond before returning
    //        Receive Messages with OnMessageArrive. Message may
    //                   be response or new message
    //       The application is responsible for responding to the remote
    //       application and dropping the link as required
    //       You must hook the OnMessageArrive Event before setting this mode
    //       The property IsListener has no meaning in this mode
    //
    //   cmSynchronous
    //       Send Messages with SynchronousSend. Remote applications response
    //                   will be returned (or timeout). Only use if IsListener is false
    //       Receive Messages with OnReceiveMessage. Only if IsListener is
    //                   true
    //       In this mode, the object will wait for a response when sending,
    //       and expects the application to reply when a message arrives.
    //       In this mode, the interface can either be the listener or the
    //       initiator but not both. IsListener controls which one.
    //       note that OnReceiveMessage must be thread safe if you allow
    //       more than one connection to a server
    //
    //   cmSingleThread
    //       Send Messages with SendMessage. Poll for answer using GetReply.
    //                   Only if isListener is false
    //       Receive Messages using GetMessage. Return a response using
    //                   SendReply. Only if IsListener is true
    //       This mode is the same as cmSynchronous, but the application is
    //       assumed to be single threaded. The application must poll to
    //       find out what is happening rather than being informed using
    //       an event in a different thread

    property CommunicationMode: THL7CommunicationMode Read FCommunicationMode Write SetCommunicationMode Default DEFAULT_COMM_MODE;

    // note that IsListener is not related to which end is client. Either end
    // may make the connection, and thereafter only one end will be the initiator
    // and one end will be the listener. Generally it is recommended that the
    // listener be the server. If the client is listening, network conditions
    // may lead to a state where the client has a phantom connection and it will
    // never find out since it doesn't initiate traffic. In this case, restart
    // the interface if there isn't traffic for a period
    property IsListener: Boolean Read FIsListener Write SetIsListener Default DEFAULT_IS_LISTENER;

    // useful for application
    property OnConnect: TNotifyEvent Read FOnConnect Write FOnConnect;
    property OnDisconnect: TNotifyEvent Read FOnDisconnect Write FOnDisconnect;
    // this is called whenever OnConnect and OnDisconnect are called, and at other times, but only when server
    // it will be called after OnConnect and before OnDisconnect
    property OnConnCountChange: TIdHL7ConnCountEvent Read FOnConnCountChange Write FOnConnCountChange;

    // this is called when an unhandled exception is generated by the
    // hl7 object or the application. It allows the application to
    // construct a useful return error, log the exception, and drop the
    // connection if it wants
    property OnReceiveError: TReceiveErrorEvent Read FOnReceiveError Write FOnReceiveError;
  end;

implementation

uses
  IdResourceStrings;

type
  TQueuedMessage = class(TInterfacedObject)
  Private
    FEvent: TIdLocalEvent;
    FMsg: String;
    FTimeOut: Cardinal;
    FReply: String;
    procedure Wait;
  Public
    constructor Create(aMsg: String; ATimeOut: Cardinal);
    destructor Destroy; Override;
    function _AddRef: Integer; Stdcall;
    function _Release: Integer; Stdcall;
  end;

  { TQueuedMessage }

constructor TQueuedMessage.Create(aMsg: String; ATimeOut: Cardinal);
begin
  assert(aMsg <> '', 'Attempt to queue an empty message');
  assert(ATimeout <> 0, 'Attempt to queue a message with a 0 timeout');
  inherited Create;
  FEvent := TIdLocalEvent.Create(False, False);
  FMsg := aMsg;
  FTimeOut := ATimeOut;
end;

destructor TQueuedMessage.Destroy;
begin
  assert(self <> NIL);
  FreeAndNil(FEvent);
  inherited;
end;

procedure TQueuedMessage.Wait;
begin
  assert(self <> NIL);
  assert(assigned(FEvent));
  FEvent.WaitFor(FTimeOut);
end;

function TQueuedMessage._AddRef: Integer;
begin
  Result := inherited _AddRef;
end;

function TQueuedMessage._Release: Integer;
begin
  Result := inherited _Release;
end;

{ EHL7CommunicationError }

constructor EHL7CommunicationError.Create(AnInterfaceName, AMessage: String);
begin
  //  assert(AInterfaceName <> '', 'Attempt to create an exception for an unnamed interface')
  //  assert(AMessage <> '', 'Attempt to create an exception with an empty message')
  //  actually, we do not enforce either of these conditions, though they should both be true,
  //  since we are already raising an exception
  FInterfaceName := AnInterfaceName;
  if FInterfaceName <> '' then         {do not localize}
    begin
    inherited Create('[' + AnInterfaceName + '] ' + AMessage)
    end
  else
    begin
    inherited Create(AMessage);
    end
end;

{ TIdHL7 }

constructor TIdHL7.Create;
begin
  inherited Create(Component);

  // partly redundant initialization of properties

  FIsListener := DEFAULT_IS_LISTENER;
  FCommunicationMode := DEFAULT_COMM_MODE;
  FTimeOut := DEFAULT_TIMEOUT;
  FReconnectDelay := DEFAULT_RECONNECT_DELAY;
  FReceiveTimeout := DEFAULT_RECEIVE_TIMEOUT;
  FConnectionLimit := DEFAULT_CONN_LIMIT;
  FIPMask := NULL_IP;
  FIPRestriction := NULL_IP;
  FAddress := DEFAULT_ADDRESS;
  FPort := DEFAULT_PORT;
  FOnReceiveMessage := NIL;
  FOnConnect := NIL;
  FOnDisconnect := NIL;
  FObject := NIL;

  // initialise status
  FStatus := IsStopped;
  FStatusDesc := RSHL7StatusStopped;

  // build internal infrastructure
  Flock := TCriticalSection.Create;
  FConnCount := 0;
  FServer := NIL;
  FServerConn := NIL;
  FClientThread := NIL;
  FClient := NIL;
  FMsgQueue := TList.Create;
  FHndMsgQueue := TList.Create;
  FWaitingForAnswer := False;
  FMsgReply := '';   {do not localize}
  FReplyResponse := srNone;
  FWaitEvent := TIdLocalEvent.Create(False, False);
end;

destructor TIdHL7.Destroy;
begin
  assert(assigned(self));
  try
    if Going then
      begin
      Stop;
      end;
  finally
    FreeAndNil(FMsgQueue);
    FreeAndNil(FHndMsgQueue);
    FreeAndNil(FWaitEvent);
    FreeAndNil(FLock);
    inherited;
    end;
end;

{==========================================================
  Property Servers
 ==========================================================}

procedure TIdHL7.SetAddress(const AValue: String);
begin
  assert(assigned(self));
  // we don't make any assertions about AValue - will be '' if we are a server
  if Going then
    begin
    raise EHL7CommunicationError.Create(Name, Format(RSHL7NotWhileWorking, ['Address']));   {do not localize??}
    end;
  FAddress := AValue;
end;

procedure TIdHL7.SetConnectionLimit(const AValue: Word);
begin
  assert(assigned(self));
  // no restrictions on AValue
  if Going then
    begin
    raise EHL7CommunicationError.Create(Name, Format(RSHL7NotWhileWorking, ['ConnectionLimit'])); {do not localize??}
    end;
  FConnectionLimit := AValue;
end;

procedure TIdHL7.SetIPMask(const AValue: String);
begin
  assert(assigned(self));
  // to do: enforce that AValue is a valid Subnet mask
  if Going then
    begin
    raise EHL7CommunicationError.Create(Name, Format(RSHL7NotWhileWorking, ['IP Mask']));  {do not localize??}
    end;
  FIPMask := AValue;
end;

procedure TIdHL7.SetIPRestriction(const AValue: String);
begin
  assert(assigned(self));
  // to do: enforce that AValue is a valid IP address range
  if Going then
    begin
    raise EHL7CommunicationError.Create(Name, Format(RSHL7NotWhileWorking, ['IP Restriction']));    {do not localize??}
    end;
  FIPRestriction := AValue;
end;

procedure TIdHL7.SetPort(const AValue: Word);
begin
  assert(assigned(self));
  assert(AValue <> 0, 'Attempt to use Port 0 for HL7 Communications');
  if Going then
    begin
    raise EHL7CommunicationError.Create(Name, Format(RSHL7NotWhileWorking, ['Port']));          {do not localize??}
    end;
  FPort := AValue;
end;

procedure TIdHL7.SetReconnectDelay(const AValue: Cardinal);
begin
  assert(assigned(self));
  // any value for AValue is accepted, although this may not make sense
  if Going then
    begin
    raise EHL7CommunicationError.Create(Name, Format(RSHL7NotWhileWorking, ['Reconnect Delay']));   {do not localize??}
    end;
  FReconnectDelay := AValue;
end;

procedure TIdHL7.SetTimeOut(const AValue: Cardinal);
begin
  assert(assigned(self));
  assert(FTimeout > 0, 'Attempt to configure TIdHL7 with a Timeout of 0');
  // we don't fucntion at all if timeout is 0, though there is circumstances where it's not relevent
  if Going then
    begin
    raise EHL7CommunicationError.Create(Name, Format(RSHL7NotWhileWorking, ['Time Out']));          {do not localize??}
    end;
  FTimeOut := AValue;
end;

procedure TIdHL7.SetCommunicationMode(const AValue: THL7CommunicationMode);
begin
  assert(assigned(self));
  Assert((AValue >= Low(THL7CommunicationMode)) and (AValue <= High(THL7CommunicationMode)), 'Value for TIdHL7.CommunicationMode not in range');
  // only could arise if someone is typecasting?
  if Going then
    begin
    raise EHL7CommunicationError.Create(Name, Format(RSHL7NotWhileWorking, ['Communication Mode'])); {do not localize??}
    end;
  FCommunicationMode := AValue;
end;

procedure TIdHL7.SetIsListener(const AValue: Boolean);
begin
  assert(assigned(self));
  // AValue isn't checked
  if Going then
    begin
    raise EHL7CommunicationError.Create(Name, Format(RSHL7NotWhileWorking, ['IsListener']));         {do not localize??}
    end;
  FIsListener := AValue;
end;

function TIdHL7.GetStatus: TIdHL7Status;
begin
  assert(assigned(self));
  assert(Assigned(FLock));
  FLock.Enter;
  try
    Result := FStatus;
  finally
    FLock.Leave;
    end;
end;

function TIdHL7.Connected: Boolean;
begin
  assert(assigned(self));
  assert(Assigned(FLock));
  FLock.Enter;
  try
    Result := FStatus = IsConnected;
  finally
    FLock.Leave;
    end;
end;

function TIdHL7.GetStatusDesc: String;
begin
  assert(assigned(self));
  assert(Assigned(FLock));
  FLock.Enter;
  try
    Result := FStatusDesc;
  finally
    FLock.Leave;
    end;
end;

procedure TIdHL7.InternalSetStatus(const AStatus: TIdHL7Status; ADesc: String);
begin
  assert(assigned(self));
  Assert((AStatus >= Low(TIdHL7Status)) and (AStatus <= High(TIdHL7Status)), 'Value for TIdHL7.CommunicationMode not in range');
  // ADesc is allowed to be anything at all
  assert(Assigned(FLock));
  FLock.Enter;
  try
    FStatus := AStatus;
    FStatusDesc := ADesc;
  finally
    FLock.Leave;
    end;
end;

{==========================================================
  Application Control
 ==========================================================}

procedure TIdHL7.Start;
var 
  LStatus: TIdHL7Status;
begin
  assert(assigned(self));
  LStatus := GetStatus;
  if LStatus = IsUnusable then
    begin
    raise EHL7CommunicationError.Create(Name, RSHL7NotFailedToStop);
    end;
  if LStatus <> IsStopped then
    begin
    raise EHL7CommunicationError.Create(Name, RSHL7AlreadyStarted);
    end;
  if FCommunicationMode = cmUnknown then
    begin
    raise EHL7CommunicationError.Create(Name, RSHL7ModeNotSet);
    end;
  if FCommunicationMode = cmAsynchronous then
    begin
    if not assigned(FOnMessageArrive) then
      begin
      raise EHL7CommunicationError.Create(Name, RSHL7NoAsynEvent);
      end;
    end;
  if (FCommunicationMode = cmSynchronous) and IsListener then
    begin
    if not assigned(FOnReceiveMessage) then
      begin
      raise EHL7CommunicationError.Create(Name, RSHL7NoSynEvent);
      end;
    end;
  FIsServer := (FAddress = '');
  if FIsServer then
    begin
    StartServer
    end
  else
    begin
    StartClient;
    end;
  FPreStopped := False;
  FWaitingForAnswer := False;
end;

procedure TIdHL7.PreStop;
  procedure JoltList(l: TList);
  var 
    i: Integer;
    begin
    for i := 0 to l.Count - 1 do
      begin
      TQueuedMessage(l[i]).FEvent.SetEvent;
      end;
    end;
begin
  assert(assigned(self));
  if FCommunicationMode = cmSingleThread then
    begin
    assert(Assigned(FLock));
    assert(Assigned(FMsgQueue));
    assert(Assigned(FHndMsgQueue));
    FLock.Enter;
    try
      JoltList(FMsgQueue);
      JoltList(FHndMsgQueue);
    finally
      FLock.Leave;
      end;
    end;
  FPreStopped := True;
end;

procedure TIdHL7.Stop;
begin
  assert(assigned(self));
  if not Going then
    begin
    raise EHL7CommunicationError.Create(Name, RSHL7AlreadyStopped);
    end;

  if not FPreStopped then
    begin
    PreStop;
    sleep(10); // give other threads a chance to clean up
    end;

  if FIsServer then
    begin
    StopServer
    end
  else
    begin
    StopClient;
    end;
end;


{==========================================================
  Server Connection Maintainance
 ==========================================================}

procedure TIdHL7.EnforceWaitReplyTimeout;
begin
  Stop;
  Start;
end;

function TIdHL7.Going: Boolean;
var
  LStatus: TIdHL7Status;
begin
  assert(assigned(self));
  LStatus := GetStatus;
  Result := (LStatus <> IsStopped) and (LStatus <> IsUnusable);
end;

procedure TIdHL7.WaitForConnection(AMaxLength: Integer);
var
  LStopWaiting: TDateTime;
begin
  LStopWaiting := Now + (AMaxLength * ((1 / (24 * 60)) / (60 * 1000)));
  while not Connected and (LStopWaiting > now) do
    sleep(50);  
end;

procedure TIdHL7.CheckSynchronousSendResult(AResult: TSendResponse; AMsg: String);
begin
  case AResult of
    srNone: 
      raise EHL7CommunicationError.Create(Name, 'Internal error in IdHL7.pas: SynchronousSend returned srNone');
    srError: 
      raise EHL7CommunicationError.Create(Name, AMsg);
    srNoConnection: 
      raise EHL7CommunicationError.Create(Name, 'Not connected');
    srSent: 
      raise EHL7CommunicationError.Create(Name, 'Internal error in IdHL7.pas: SynchronousSend returned srSent');  // cause this should only be returned asynchronously
    srOK:; // all ok
    srTimeout: 
      raise EHL7CommunicationError.Create(Name, 'No response from remote system');
    else
      raise EHL7CommunicationError.Create(Name, 'Internal error in IdHL7.pas: SynchronousSend returned an unknown value ' + IntToStr(Ord(AResult)));
    end;
end;

{ TIdHL7PeerThread }

constructor TIdHL7PeerThread.Create(ACreateSuspended: Boolean);
begin
  inherited;
  FBuffer := '';
end;

// well, this doesn't do anything. but declared for consistency
destructor TIdHL7PeerThread.Destroy;
begin
  assert(assigned(self));
  inherited;
end;

procedure TIdHL7.CheckServerParameters;
begin
  assert(assigned(self));
  if (FCommunicationMode = cmAsynchronous) or not FIsListener then
    begin
    FConnectionLimit := 1;
    end;

  if (FPort < 1) then // though we have already ensured that this cannot happen
    begin
    raise EHL7CommunicationError.Create(Name, Format(RSHL7InvalidPort, [FPort]));
    end;
end;

procedure TIdHL7.StartServer;
begin
  assert(assigned(self));
  CheckServerParameters;
  FServer := TIdTCPServer.Create(NIL);
  try
    FServer.DefaultPort := FPort;
    FServer.ThreadClass := TIdHL7PeerThread;
    Fserver.OnConnect := ServerConnect;
    FServer.OnExecute := ServerExecute;
    FServer.OnDisconnect := ServerDisconnect;
    FServer.Active := True;
    InternalSetStatus(IsNotConnected, RSHL7StatusNotConnected);
  except
    on e:
    Exception do
      begin
      InternalSetStatus(IsStopped, Format(RSHL7StatusFailedToStart, [e.message]));
      FreeAndNil(FServer);
      raise;
      end;
    end;
end;

procedure TIdHL7.StopServer;
begin
  assert(assigned(self));
  try
    FServer.Active := False;
    FreeAndNil(FServer);
    InternalSetStatus(IsStopped, RSHL7StatusStopped);
  except
    on e: 
    Exception do
      begin
      // somewhat arbitrary decision: if for some reason we fail to shutdown,
      // we will stubbornly refuse to work again.
      InternalSetStatus(IsUnusable, Format(RSHL7StatusFailedToStop, [e.message]));
      FServer := NIL;
      raise
      end;
    end;
end;

procedure TIdHL7.ServerConnect(AThread: TIdPeerThread);
var
  LNotify: Boolean;
  LConnCount: Integer;
  LValid: Boolean;
begin
  assert(assigned(self));
  assert(assigned(AThread));
  assert(assigned(FLock));
  FLock.Enter;
  try
    LNotify := FConnCount = 0;
    inc(FConnCount);
    LConnCount := FConnCount;
    // it would be better to stop getting here in the case of an invalid connection
    // cause here we drop it - nasty for the client. To be investigated later
    LValid := FConnCount <= FConnectionLimit;
    if (FConnCount = 1) and (FCommunicationMode <> cmAsynchronous) and not IsListener then
      begin
      FServerConn := AThread.Connection;
      end;
    if LNotify then
      begin
      InternalSetStatus(IsConnected, RSHL7StatusConnected);
      end;
  finally
    FLock.Leave;
    end;
  if LValid then
    begin
    if LNotify and assigned(FOnConnect) then
      begin
      FOnConnect(self);
      end;
    if assigned(FOnConnCountChange) and (FConnectionLimit <> 1) then
      begin
      FOnConnCountChange(Self, LConnCount);
      end;
    end
  else
    begin
    // Thread exceeds connection limit
    AThread.Connection.Disconnect;
    end;
end;

procedure TIdHL7.ServerDisconnect(AThread: TIdPeerThread);
var
  LNotify: Boolean;
  LConnCount: Integer;
begin
  assert(assigned(self));
  assert(assigned(AThread));
  assert(assigned(FLock));
  FLock.Enter;
  try
    dec(FConnCount);
    LNotify := FConnCount = 0;
    LConnCount := FConnCount;
    if AThread.Connection = FServerConn then
      begin
      FServerConn := NIL;
      end;
    if LNotify then
      begin
      InternalSetStatus(IsNotConnected, RSHL7StatusNotConnected);
      end;
  finally
    FLock.Leave;
    end;
  if assigned(FOnConnCountChange) and (FConnectionLimit <> 1) then
    begin
    FOnConnCountChange(Self, LConnCount);
    end;
  if LNotify and assigned(FOnDisconnect) then
    begin
    FOnDisconnect(self);
    end;
end;

procedure TIdHL7.ServerExecute(AThread: TIdPeerThread);
var
  LThread: TIdHL7PeerThread;
  FSize: Integer;
  FStream: TStringStream;
begin
  assert(assigned(self));
  assert(assigned(AThread));
  LThread := AThread as TIdHL7PeerThread;
  FStream := TStringStream.Create('');
  try
    try
      // 1. prompt the network for content.
      LThread.Connection.ReadFromStack(False, -1, False);
    except
      try
        // well, there was some network error. We aren't sure what it
        // was, and it doesn't matter for this layer. we're just going
        // to make sure that we start again.
        // to review: what happens to the error messages?
        LThread.Connection.DisconnectSocket;
      except
        end;
      exit;
      end;
    FSize := LThread.Connection.InputBuffer.Size;
    if FSize > 0 then
      begin
      FStream.Size := 0;
      LThread.Connection.ReadStream(FStream, FSize);
      LThread.FBuffer := LThread.FBuffer + FStream.DataString;
      HandleIncoming(LThread.FBuffer, LThread.Connection);
      end;
  finally
    FreeAndNil(FStream)
    end;
end;

procedure TIdHL7.DropServerConnection;
begin
  assert(assigned(self));
  assert(assigned(FLock));
  FLock.Enter;
  try
    if assigned(FServerConn) then
      FServerConn.Disconnect;
  finally
    FLock.Leave;
    end;
end;


{==========================================================
  Client Connection Maintainance
 ==========================================================}

procedure TIdHL7.CheckClientParameters;
begin
  assert(assigned(self));
  if (FPort < 1) then
    begin
    raise EHL7CommunicationError.Create(Name, Format(RSHL7InvalidPort, [FPort]));
    end;
end;

procedure TIdHL7.StartClient;
begin
  assert(assigned(self));
  CheckClientParameters;
  FClientThread := TIdHL7ClientThread.Create(self);
  InternalSetStatus(isConnecting, RSHL7StatusConnecting);
end;

procedure TIdHL7.StopClient;
var
  LFinished: Boolean;
  LStartTime : Cardinal;
begin
  assert(assigned(self));
  assert(assigned(FLock));
  FLock.Enter;
  try
    FClientThread.Terminate;
    FClientThread.FClient.DisconnectSocket;
    FClientThread.FCloseEvent.SetEvent;
  finally
    FLock.Leave;
    end;
  LStartTime := GetTickCount;
  repeat
    LFinished := (GetStatus = IsStopped);
    if not LFinished then
      begin
      sleep(10);
      end;
  until LFinished or (GetTickDiff(LStartTime,GetTickCount) > WAIT_STOP);
  if GetStatus <> IsStopped then
    begin
    // for some reason the client failed to shutdown. We will stubbornly refuse to work again
    InternalSetStatus(IsUnusable, Format(RSHL7StatusFailedToStop, [RSHL7ClientThreadNotStopped]));
    end;
end;

procedure TIdHL7.DropClientConnection;
begin
  assert(assigned(self));
  assert(assigned(FLock));
  FLock.Enter;
  try
    if assigned(FClientThread) and assigned(FClientThread.FClient) then
      begin
      FClientThread.FClient.DisconnectSocket
      end
    else
      begin
      // This may happen validly because both ends are trying to drop the connection simultaineously
      end;
  finally
    FLock.Leave;
    end;
end;

{ TIdHL7ClientThread }

constructor TIdHL7ClientThread.Create(aOwner: TIdHL7);
begin
  assert(assigned(AOwner));
  FOwner := aOwner;
  FCloseEvent := TIdLocalEvent.Create(True, False);
  FreeOnTerminate := True;
  inherited Create(False);
end;

destructor TIdHL7ClientThread.Destroy;
begin
  assert(assigned(self));
  assert(assigned(FOwner));
  assert(assigned(FOwner.FLock));
  FreeAndNil(FCloseEvent);
  try
    FOwner.FLock.Enter;
    try
      FOwner.FClientThread := NIL;
      FOwner.InternalSetStatus(isStopped, RSHL7StatusStopped);
    finally
      FOwner.FLock.Leave;
      end;
  except
    // it's really vaguely possible that the owner
    // may be dead before we are. If that is the case, we blow up here.
    // who cares.
    end;
  inherited;
end;

procedure TIdHL7ClientThread.PollStack;
var
  LBuffer: String;
  FSize: Integer;
  FStream: TStringStream;
begin
  assert(assigned(self));
  FStream := TStringStream.Create('');
  try
    LBuffer := '';
    repeat
      // we don't send here - we just poll the stack for content
      // if the application wants to terminate us at this point,
      // then it will disconnect the socket and we will get thrown
      // out
      // we really don't care at all whether the disconnect was clean or ugly

      // but we do need to suppress exceptions that come from
      // indy otherwise the client thread will terminate

      try
        // 1. prompt the network for content.
        FClient.ReadFromStack(False, -1, False);
      except
        try
          // well, there was some network error. We aren't sure what it
          // was, and it doesn't matter for this layer. we're just going
          // to make sure that we start again.
          // to review: what happens to the error messages?
          FClient.DisconnectSocket;
        except
          end;
        exit;
        end;
      FSize := FClient.InputBuffer.Size;
      if FSize > 0 then
        begin
        FStream.Size := 0;
        FClient.ReadStream(FStream, FSize);
        LBuffer := LBuffer + FStream.DataString;
        FOwner.HandleIncoming(LBuffer, FClient);
        end;
    until Terminated or not FClient.Connected;
  finally
    FStream.Free;
    end;
end;

procedure TIdHL7ClientThread.Execute;
var 
  LRecTime: TDateTime;
begin
  assert(assigned(self));
  try
    FClient := TIdTCPClient.Create(NIL);
    try
      FClient.Host := FOwner.FAddress;
      FClient.Port := FOwner.FPort;
      repeat
        // try to connect. Try indefinitely but wait Owner.FReconnectDelay
        // between attempts. Problems: how long does Connect take?
        repeat
          FOwner.InternalSetStatus(IsConnecting, rsHL7StatusConnecting);
          try
            FClient.Connect;
          except
            on e: 
            Exception do
              begin
              LRecTime := Now + ((FOwner.FReconnectDelay / 1000) * {second length} (1 / (24 * 60 * 60)));
              FOwner.InternalSetStatus(IsWaitReconnect, Format(rsHL7StatusReConnect, [FormatDateTime('hh:nn:ss', LRecTime), e.message])); {do not localize??}
              end;
            end;
          if not Terminated and not FClient.Connected then
            begin
            FCloseEvent.WaitFor(FOwner.FReconnectDelay);
            end;
        until Terminated or FClient.Connected;
        if Terminated then
          begin
          exit;
          end;

        FOwner.FLock.Enter;
        try
          FOwner.FClient := FClient;
          FOwner.InternalSetStatus(IsConnected, rsHL7StatusConnected);
        finally
          FOwner.FLock.Leave;
          end;
        if assigned(FOwner.FOnConnect) then
          begin
          FOwner.FOnConnect(FOwner);
          end;
        try
          PollStack;
        finally
          FOwner.FLock.Enter;
          try
            FOwner.FClient := NIL;
            FOwner.InternalSetStatus(IsNotConnected, RSHL7StatusNotConnected);
          finally
            FOwner.FLock.Leave;
            end;
          if assigned(FOwner.FOnDisconnect) then
            begin
            FOwner.FOnDisconnect(FOwner);
            end;
          end;
        if not Terminated then
          begin
          // we got disconnected. ReconnectDelay applies.
          FCloseEvent.WaitFor(FOwner.FReconnectDelay);
          end;
      until terminated;
    finally
      FreeAndNil(FClient);
      end;
  except
    on e: 
    Exception do
      // presumably some comms or indy related exception
      // there's not really anyplace good to put this????
    end;
end;

{==========================================================
  Internal process management
 ==========================================================}

procedure TIdHL7.HandleIncoming(var VBuffer: String; AConnection: TIdTCPConnection);
var 
  LStart, LEnd: Integer;
  LMsg, LReply: String;
begin
  assert(assigned(self));
  assert(VBuffer <> '', 'Attempt to handle an empty buffer');
  assert(assigned(AConnection));
  try
    // process any messages in the buffer (may get more than one per packet)
    repeat
      { use of Pos instead of Indypos is deliberate }
      LStart := pos(MSG_START, VBuffer);
      LEnd := pos(MSG_END, VBuffer);
      if (LStart > 0) and (LEnd > 0) then
        begin
        LMsg := copy(VBuffer, LStart + length(MSG_START), LEnd - (LStart + length(MSG_START)));
        Delete(VBuffer, 1, (LEnd - 1) + length(MSG_END));
        if HandleMessage(LMsg, AConnection, LReply) then
          begin
          if LReply <> '' then
            begin
            AConnection.Write(MSG_START + LReply + MSG_END);
            end;
          end
        else
          begin
          AConnection.DisconnectSocket;
          end;
        end;
    until (LEnd = 0);
    if length(VBuffer) > BUFFER_SIZE_LIMIT then
      begin
      AConnection.DisconnectSocket;
      end;
  except
    // well, we need to suppress the exception, and force a reconnection
    // we don't know why an exception has been allowed to propagate back
    // to us, it shouldn't be allowed. so what we're going to do, is drop
    // the connection so that we force all the network layers on both
    // ends to reconnect.
    // this is a waste of time of the error came from the application but
    // this is not supposed to happen
    try
      AConnection.DisconnectSocket;
    except
      // nothing - suppress
      end;
    end;
end;

function TIdHL7.HandleMessage(const AMsg: String; AConn: TIdTCPConnection; var VReply: String): Boolean;
var
  LQueMsg: TQueuedMessage;
  LIndex: Integer;
begin
  assert(assigned(self));
  assert(AMsg <> '', 'Attempt to handle an empty Message');
  assert(assigned(FLock));
  VReply := '';
  Result := True;
  try
    case FCommunicationMode of
      cmUnknown:
        begin
        raise EHL7CommunicationError.Create(Name, RSHL7ImpossibleMessage);
        end;
      cmAsynchronous:
        begin
        FOnMessageArrive(self, AConn, Amsg);
        end;
      cmSynchronous, cmSingleThread:
        begin
        if IsListener then
          begin
          if FCommunicationMode = cmSynchronous then
            begin
            Result := False;
            FOnReceiveMessage(self, AConn, AMsg, Result, VReply)
            end
          else
            begin
            LQueMsg := TQueuedMessage.Create(AMsg, FReceiveTimeout);
            LQueMsg._AddRef;
            try
              FLock.Enter;
              try
                FMsgQueue.Add(LQueMsg);
              finally
                FLock.Leave;
                end;
              LQueMsg.wait;
              // no locking. There is potential problems here. To be reviewed
              VReply := LQueMsg.FReply;
            finally
              FLock.Enter;
              try
                LIndex := FMsgQueue.IndexOf(LQueMsg);
                if LIndex > -1 then
                  FMsgQueue.Delete(LIndex);
              finally
                FLock.Leave;
                end;
              LQueMsg._Release;
              end;
            end
          end
        else
          begin
          FLock.Enter;
          try
            if FWaitingForAnswer then
              begin
              FWaitingForAnswer := False;
              FMsgReply := AMsg;
              FReplyResponse := srOK;
              if FCommunicationMode = cmSynchronous then
                begin
                assert(Assigned(FWaitEvent));
                FWaitEvent.SetEvent;
                end;
              end
            else
              begin
              // we could have got here by timing out, but this is quite unlikely,
              // since the connection will be dropped in that case. We will report
              // this as a spurious message
              raise EHL7CommunicationError.Create(Name, RSHL7UnexpectedMessage);
              end;
          finally
            FLock.Leave;
            end;
          end
        end;
      else
        begin
        raise EHL7CommunicationError.Create(Name, RSHL7UnknownMode);
        end;
      end;
  except
    on e: 
    Exception do
      if Assigned(FOnReceiveError) then
        begin
        FOnReceiveError(self, AConn, AMsg, e, VReply, Result)
        end
    else
      begin
      Result := False;
      end;
    end;
end;

{==========================================================
  Sending
 ==========================================================}

// this procedure is not technically thread safe.
// if the connection is disappearing when we are attempting
// to write, we can get transient access violations. Several
// strategies are available to prevent this but they significantly
// increase the scope of the locks, which costs more than it gains

function TIdHL7.AsynchronousSend(AMsg: String): TSendResponse;
begin
  assert(Assigned(self));
  assert(AMsg <> '', 'Attempt to send an empty message');
  assert(assigned(FLock));
  Result := srNone; // just to suppress the compiler warning
  FLock.Enter;
  try
    if not Going then
      begin
      raise EHL7CommunicationError.Create(Name, Format(RSHL7NotWorking, [RSHL7SendMessage]))
      end
    else if GetStatus <> isConnected then
      begin
      Result := srNoConnection
      end
    else
      begin
      if FIsServer then
        begin
        if Assigned(FServerConn) then
          begin
          FServerConn.Write(MSG_START + AMsg + MSG_END);
          Result := srSent
          end
        else
          begin
          raise EHL7CommunicationError.Create(Name, RSHL7NoConnectionFound);
          end
        end
      else
        begin
        FClient.Write(MSG_START + AMsg + MSG_END);
        Result := srSent
        end;
      end;
  finally
    FLock.Leave;
    end
end;

function TIdHL7.SynchronousSend(AMsg: String; var VReply: String): TSendResponse;
begin
  assert(Assigned(self));
  assert(AMsg <> '', 'Attempt to send an empty message');
  assert(assigned(FLock));
  Result := srError;
  FLock.Enter;
  try
    FWaitingForAnswer := True;
    FWaitStop := now + (FTimeOut * MILLISECOND_LENGTH);
    FReplyResponse := srTimeout;
    FMsgReply := '';
  finally
    FLock.Leave;
    end;
  try
    Result := AsynchronousSend(AMsg);
    if Result = srSent then
      begin
      assert(Assigned(FWaitEvent));
      FWaitEvent.WaitFor(FTimeOut);
      end;
  finally
    FLock.Enter;
    try
      FWaitingForAnswer := False;
      if Result = srSent then
        begin
        Result := FReplyResponse;
        end;
      if Result = srTimeout then
        begin
        if FIsServer then
          DropServerConnection
        else
          DropClientConnection;
        end;
      VReply := FMsgReply;
    finally
      FLock.Leave;
      end;
    end;
end;

procedure TIdHL7.SendMessage(AMsg: String);
begin
  assert(Assigned(self));
  assert(AMsg <> '', 'Attempt to send an empty message');
  assert(assigned(FLock));
  if FWaitingForAnswer then
    raise EHL7CommunicationError.Create(Name, RSHL7WaitForAnswer);

  FLock.Enter;
  try
    FWaitingForAnswer := True;
    FWaitStop := now + (FTimeOut * MILLISECOND_LENGTH);
    FMsgReply := '';
    FReplyResponse := AsynchronousSend(AMsg);
  finally
    FLock.Leave;
    end;
end;

function TIdHL7.GetReply(var VReply: String): TSendResponse;
begin
  assert(Assigned(self));
  assert(assigned(FLock));
  FLock.Enter;
  try
    if FWaitingForAnswer then
      begin
      if FWaitStop < now then
        begin
        Result := srTimeout;
        VReply := '';
        FWaitingForAnswer := False;
        FReplyResponse := srError;
        end
      else
        begin
        Result := srNone;
        end;
      end
    else
      begin
      Result := FReplyResponse;
      if Result = srSent then
        begin
        Result := srTimeOut;
        end;
      VReply := FMsgReply;
      FWaitingForAnswer := False;
      FReplyResponse := srError;
      end;
  finally
    FLock.Leave;
    end;
end;

function TIdHL7.GetMessage(var VMsg: String): pointer;
begin
  assert(Assigned(self));
  assert(assigned(FLock));
  assert(assigned(FMsgQueue));
  FLock.Enter;
  try
    if FMsgQueue.Count = 0 then
      begin
      Result := NIL
      end
    else
      begin
      Result := FMsgQueue[0];
      TQueuedMessage(Result)._AddRef;
      VMsg := TQueuedMessage(Result).FMsg;
      FMsgQueue.Delete(0);
      FHndMsgQueue.Add(Result);
      end;
  finally
    FLock.Leave;
    end;
end;

procedure TIdHL7.SendReply(AMsgHnd: pointer; AReply: String);
var
  qm: TQueuedMessage;
begin
  assert(Assigned(self));
  assert(Assigned(AMsgHnd));
  assert(AReply <> '', 'Attempt to send an empty reply');
  assert(assigned(FLock));
  FLock.Enter;
  try
    qm := TObject(AMsgHnd) as TQueuedMessage;
    qm.FReply := AReply;
    qm._Release;
    FHndMsgQueue.Delete(FHndMsgQueue.IndexOf(AMsgHnd));
  finally
    FLock.Leave;
    end;
  qm.FEvent.SetEvent;
end;

end.
