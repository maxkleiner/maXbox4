unit uPSI_IdTCPServer;
{
  for http server , add loaded
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
  TPSImport_IdTCPServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdTCPServer(CL: TPSPascalCompiler);
procedure SIRegister_TIdPeerThread(CL: TPSPascalCompiler);
procedure SIRegister_TIdTCPServerConnection(CL: TPSPascalCompiler);
procedure SIRegister_TIdListenerThread(CL: TPSPascalCompiler);
procedure SIRegister_TIdCommand(CL: TPSPascalCompiler);
procedure SIRegister_TIdCommandHandlers(CL: TPSPascalCompiler);
procedure SIRegister_TIdCommandHandler(CL: TPSPascalCompiler);
procedure SIRegister_IdTCPServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdTCPServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdPeerThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdTCPServerConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdListenerThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdCommand(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdCommandHandlers(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdCommandHandler(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdTCPServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdComponent
  ,IdException
  ,IdSocketHandle
  ,IdTCPConnection
  ,IdThread
  ,IdThreadMgr
  ,IdIOHandlerSocket
  ,IdIOHandler
  ,IdThreadMgrDefault
  ,IdIntercept
  ,IdStackConsts
  ,IdGlobal
  ,IdRFCReply
  ,IdServerIOHandler
  ,IdServerIOHandlerSocket
  ,IdTCPServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdTCPServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdTCPServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdComponent', 'TIdTCPServer') do
  with CL.AddClassN(CL.FindClass('TIdComponent'),'TIdTCPServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
   RegisterMethod('Procedure Loaded');
   // procedure Loaded; override;

   RegisterProperty('ImplicitIOHandler', 'Boolean', iptr);
    RegisterProperty('ImplicitThreadMgr', 'Boolean', iptr);
    RegisterProperty('ThreadClass', 'TIdThreadClass', iptrw);
    RegisterProperty('Threads', 'TThreadList', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Bindings', 'TIdSocketHandles', iptrw);
    RegisterProperty('CommandHandlers', 'TIdCommandHandlers', iptrw);
    RegisterProperty('CommandHandlersEnabled', 'boolean', iptrw);
    RegisterProperty('DefaultPort', 'integer', iptrw);
    RegisterProperty('Greeting', 'TIdRFCReply', iptrw);
    RegisterProperty('Intercept', 'TIdServerIntercept', iptrw);
    RegisterProperty('IOHandler', 'TIdServerIOHandler', iptrw);
    RegisterProperty('ListenQueue', 'integer', iptrw);
    RegisterProperty('MaxConnectionReply', 'TIdRFCReply', iptrw);
    RegisterProperty('MaxConnections', 'Integer', iptrw);
    RegisterProperty('OnAfterCommandHandler', 'TIdAfterCommandHandlerEvent', iptrw);
    RegisterProperty('OnBeforeCommandHandler', 'TIdBeforeCommandHandlerEvent', iptrw);
    RegisterProperty('OnConnect', 'TIdServerThreadEvent', iptrw);
    RegisterProperty('OnExecute', 'TIdServerThreadEvent', iptrw);
    RegisterProperty('OnDisconnect', 'TIdServerThreadEvent', iptrw);
    RegisterProperty('OnException', 'TIdServerThreadExceptionEvent', iptrw);
    RegisterProperty('OnListenException', 'TIdListenExceptionEvent', iptrw);
    RegisterProperty('OnNoCommandHandler', 'TIdNoCommandHandlerEvent', iptrw);
    RegisterProperty('ReplyExceptionCode', 'Integer', iptrw);
    RegisterProperty('ReplyTexts', 'TIdRFCReplies', iptrw);
    RegisterProperty('ReplyUnknownCommand', 'TIdRFCReply', iptrw);
    RegisterProperty('ReuseSocket', 'TIdReuseSocket', iptrw);
    RegisterProperty('TerminateWaitTime', 'Integer', iptrw);
    RegisterProperty('ThreadMgr', 'TIdThreadMgr', iptrw);

    //from id socket handle
    RegisterProperty('Binding', 'TIdSocketHandles', iptrw);
    //RegisterProperty('Binding', 'TIdListenerThread', iptrw);

    RegisterProperty('HandleAllocated', 'Boolean', iptr);
    RegisterProperty('Handle', 'TIdStackSocketHandle', iptr);
    RegisterProperty('PeerIP', 'string', iptr);
    RegisterProperty('PeerPort', 'integer', iptr);
    RegisterProperty('ClientPortMin', 'Integer', iptrw);
    RegisterProperty('ClientPortMax', 'Integer', iptrw);
    RegisterProperty('IP', 'string', iptrw);
    RegisterProperty('Port', 'integer', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdPeerThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdThread', 'TIdPeerThread') do
  with CL.AddClassN(CL.FindClass('TIdThread'),'TIdPeerThread') do begin

    RegisterProperty('Connection', 'TIdTCPServerConnection', iptr);
    RegisterProperty('ClosedGracefully', 'Boolean', iptr);
    RegisterProperty('InputBuffer', 'TIdManagedBuffer', iptr);
    RegisterProperty('LastCmdResult', 'TIdRFCReply', iptr);
    RegisterProperty('ReadLnSplit', 'Boolean', iptr);
    RegisterProperty('ReadLnTimedOut', 'Boolean', iptr);
    //RegisterProperty('Socket', 'TIdIOHandlerSocket', iptr);
    RegisterProperty('ASCIIFilter', 'boolean', iptrw);
    RegisterProperty('Intercept', 'TIdConnectionIntercept', iptrw);
    RegisterProperty('IOHandler', 'TIdIOHandler', iptrw);
    RegisterProperty('MaxLineLength', 'Integer', iptrw);
    RegisterProperty('MaxLineAction', 'TIdMaxLineAction', iptrw);
    RegisterProperty('ReadTimeout', 'Integer', iptrw);
    RegisterProperty('RecvBufferSize', 'Integer', iptrw);
    RegisterProperty('SendBufferSize', 'Integer', iptrw);
    RegisterProperty('OnDisconnected', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdTCPServerConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPConnection', 'TIdTCPServerConnection') do
  with CL.AddClassN(CL.FindClass('TIdTCPConnection'),'TIdTCPServerConnection') do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AServer : TIdTCPServer)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Server', 'TIdTCPServer', iptr);
    RegisterProperty('ClosedGracefully', 'Boolean', iptr);
    RegisterProperty('InputBuffer', 'TIdManagedBuffer', iptr);
    RegisterProperty('LastCmdResult', 'TIdRFCReply', iptr);
    RegisterProperty('ReadLnSplit', 'Boolean', iptr);
    RegisterProperty('ReadLnTimedOut', 'Boolean', iptr);
    RegisterProperty('Socket', 'TIdIOHandlerSocket', iptr);
    RegisterProperty('ASCIIFilter', 'boolean', iptrw);
    RegisterProperty('Intercept', 'TIdConnectionIntercept', iptrw);
    RegisterProperty('IOHandler', 'TIdIOHandler', iptrw);
    RegisterProperty('MaxLineLength', 'Integer', iptrw);
    RegisterProperty('MaxLineAction', 'TIdMaxLineAction', iptrw);
    RegisterProperty('ReadTimeout', 'Integer', iptrw);
    RegisterProperty('RecvBufferSize', 'Integer', iptrw);
    RegisterProperty('SendBufferSize', 'Integer', iptrw);
    RegisterProperty('OnDisconnected', 'TNotifyEvent', iptrw);
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdListenerThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdThread', 'TIdListenerThread') do
  with CL.AddClassN(CL.FindClass('TIdThread'),'TIdListenerThread') do begin
    RegisterMethod('Constructor Create( AServer : TIdTCPServer; ABinding : TIdSocketHandle)');
    RegisterProperty('Binding', 'TIdSocketHandle', iptrw);
    RegisterProperty('Server', 'TIdTCPServer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdCommand(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdCommand') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdCommand') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
      RegisterMethod('Procedure SendReply');
    RegisterMethod('Procedure SetResponse( AValue : TStrings)');
    RegisterProperty('CommandHandler', 'TIdCommandHandler', iptr);
    RegisterProperty('PerformReply', 'Boolean', iptrw);
    RegisterProperty('Params', 'TStrings', iptr);
    RegisterProperty('RawLine', 'string', iptr);
    RegisterProperty('Reply', 'TIdRFCReply', iptrw);
    RegisterProperty('Response', 'TStrings', iptrw);
    RegisterProperty('Thread', 'TIdPeerThread', iptr);
    RegisterProperty('UnparsedParams', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdCommandHandlers(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TIdCommandHandlers') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TIdCommandHandlers') do begin
    RegisterMethod('Function Add : TIdCommandHandler');
    RegisterMethod('Constructor Create( AServer : TIdTCPServer)');
    RegisterProperty('Items', 'TIdCommandHandler Integer', iptrw);
    RegisterProperty('OwnedBy', 'TPersistent', iptr);
    RegisterProperty('Server', 'TIdTCPServer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdCommandHandler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TIdCommandHandler') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TIdCommandHandler') do begin
    RegisterMethod('Function Check( const AData : string; AThread : TIdPeerThread) : boolean');
    RegisterMethod('Constructor Create( ACollection : TCollection)');
    RegisterMethod('Function NameIs( ACommand : string) : Boolean');
    RegisterProperty('Data', 'TObject', iptrw);
    RegisterProperty('CmdDelimiter', 'Char', iptrw);
    RegisterProperty('Command', 'string', iptrw);
    RegisterProperty('Disconnect', 'boolean', iptrw);
    RegisterProperty('Enabled', 'boolean', iptrw);
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('OnCommand', 'TIdCommandEvent', iptrw);
    RegisterProperty('ParamDelimiter', 'Char', iptrw);
    RegisterProperty('ParseParams', 'Boolean', iptrw);
    RegisterProperty('ReplyExceptionCode', 'Integer', iptrw);
    RegisterProperty('ReplyNormal', 'TIdRFCReply', iptrw);
    RegisterProperty('Response', 'TStrings', iptrw);
    RegisterProperty('Tag', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdTCPServer(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IdEnabledDefault','Boolean').SetInt(1);
 CL.AddConstantN('IdParseParamsDefault','Boolean').SetInt(1);
 CL.AddConstantN('IdCommandHandlersEnabledDefault','Boolean').SetInt(1);
 CL.AddConstantN('IdListenQueueDefault','LongInt').SetInt( 15);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdCommandHandler');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdCommand');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdPeerThread');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdTCPServer');
  CL.AddTypeS('TIdAfterCommandHandlerEvent', 'Procedure ( ASender : TIdTCPServe'
   +'r; AThread : TIdPeerThread)');
  CL.AddTypeS('TIdBeforeCommandHandlerEvent', 'Procedure ( ASender : TIdTCPServ'
   +'er; const AData : string; AThread : TIdPeerThread)');
  CL.AddTypeS('TIdCommandEvent', 'Procedure ( ASender : TIdCommand)');
  CL.AddTypeS('TIdNoCommandHandlerEvent', 'Procedure ( ASender : TIdTCPServer; '
   +'const AData : string; AThread : TIdPeerThread)');
  SIRegister_TIdCommandHandler(CL);
  SIRegister_TIdCommandHandlers(CL);
  SIRegister_TIdCommand(CL);
  SIRegister_TIdListenerThread(CL);
  SIRegister_TIdTCPServerConnection(CL);
  SIRegister_TIdPeerThread(CL);
  CL.AddTypeS('TIdListenExceptionEvent', 'Procedure ( AThread : TIdListenerThre'
   +'ad; AException : Exception)');
  CL.AddTypeS('TIdServerThreadExceptionEvent', 'Procedure ( AThread : TIdPeerTh'
   +'read; AException : Exception)');
  CL.AddTypeS('TIdServerThreadEvent', 'Procedure ( AThread : TIdPeerThread)');
  SIRegister_TIdTCPServer(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdTCPServerError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdNoExecuteSpecified');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdTerminateThreadTimeout');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdTCPServerThreadMgr_W(Self: TIdTCPServer; const T: TIdThreadMgr);
begin Self.ThreadMgr := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerThreadMgr_R(Self: TIdTCPServer; var T: TIdThreadMgr);
begin T := Self.ThreadMgr; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerTerminateWaitTime_W(Self: TIdTCPServer; const T: Integer);
begin Self.TerminateWaitTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerTerminateWaitTime_R(Self: TIdTCPServer; var T: Integer);
begin T := Self.TerminateWaitTime; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerReuseSocket_W(Self: TIdTCPServer; const T: TIdReuseSocket);
begin Self.ReuseSocket := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerReuseSocket_R(Self: TIdTCPServer; var T: TIdReuseSocket);
begin T := Self.ReuseSocket; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerReplyUnknownCommand_W(Self: TIdTCPServer; const T: TIdRFCReply);
begin Self.ReplyUnknownCommand := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerReplyUnknownCommand_R(Self: TIdTCPServer; var T: TIdRFCReply);
begin T := Self.ReplyUnknownCommand; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerReplyTexts_W(Self: TIdTCPServer; const T: TIdRFCReplies);
begin Self.ReplyTexts := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerReplyTexts_R(Self: TIdTCPServer; var T: TIdRFCReplies);
begin T := Self.ReplyTexts; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerReplyExceptionCode_W(Self: TIdTCPServer; const T: Integer);
begin Self.ReplyExceptionCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerReplyExceptionCode_R(Self: TIdTCPServer; var T: Integer);
begin T := Self.ReplyExceptionCode; end;


(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnNoCommandHandler_W(Self: TIdTCPServer; const T: TIdNoCommandHandlerEvent);
begin Self.OnNoCommandHandler := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnNoCommandHandler_R(Self: TIdTCPServer; var T: TIdNoCommandHandlerEvent);
begin T := Self.OnNoCommandHandler; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnListenException_W(Self: TIdTCPServer; const T: TIdListenExceptionEvent);
begin Self.OnListenException := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnListenException_R(Self: TIdTCPServer; var T: TIdListenExceptionEvent);
begin T := Self.OnListenException; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnException_W(Self: TIdTCPServer; const T: TIdServerThreadExceptionEvent);
begin Self.OnException := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnException_R(Self: TIdTCPServer; var T: TIdServerThreadExceptionEvent);
begin T := Self.OnException; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnDisconnect_W(Self: TIdTCPServer; const T: TIdServerThreadEvent);
begin Self.OnDisconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnDisconnect_R(Self: TIdTCPServer; var T: TIdServerThreadEvent);
begin T := Self.OnDisconnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnExecute_W(Self: TIdTCPServer; const T: TIdServerThreadEvent);
begin Self.OnExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnExecute_R(Self: TIdTCPServer; var T: TIdServerThreadEvent);
begin T := Self.OnExecute; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnConnect_W(Self: TIdTCPServer; const T: TIdServerThreadEvent);
begin Self.OnConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnConnect_R(Self: TIdTCPServer; var T: TIdServerThreadEvent);
begin T := Self.OnConnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnBeforeCommandHandler_W(Self: TIdTCPServer; const T: TIdBeforeCommandHandlerEvent);
begin Self.OnBeforeCommandHandler := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnBeforeCommandHandler_R(Self: TIdTCPServer; var T: TIdBeforeCommandHandlerEvent);
begin T := Self.OnBeforeCommandHandler; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnAfterCommandHandler_W(Self: TIdTCPServer; const T: TIdAfterCommandHandlerEvent);
begin Self.OnAfterCommandHandler := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerOnAfterCommandHandler_R(Self: TIdTCPServer; var T: TIdAfterCommandHandlerEvent);
begin T := Self.OnAfterCommandHandler; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerMaxConnections_W(Self: TIdTCPServer; const T: Integer);
begin Self.MaxConnections := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerMaxConnections_R(Self: TIdTCPServer; var T: Integer);
begin T := Self.MaxConnections; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerMaxConnectionReply_W(Self: TIdTCPServer; const T: TIdRFCReply);
begin Self.MaxConnectionReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerMaxConnectionReply_R(Self: TIdTCPServer; var T: TIdRFCReply);
begin T := Self.MaxConnectionReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerListenQueue_W(Self: TIdTCPServer; const T: integer);
begin Self.ListenQueue := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerListenQueue_R(Self: TIdTCPServer; var T: integer);
begin T := Self.ListenQueue; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerIOHandler_W(Self: TIdTCPServer; const T: TIdServerIOHandler);
begin Self.IOHandler := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerIOHandler_R(Self: TIdTCPServer; var T: TIdServerIOHandler);
begin T := Self.IOHandler; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerIntercept_W(Self: TIdTCPServer; const T: TIdServerIntercept);
begin Self.Intercept := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerIntercept_R(Self: TIdTCPServer; var T: TIdServerIntercept);
begin T := Self.Intercept; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerGreeting_W(Self: TIdTCPServer; const T: TIdRFCReply);
begin Self.Greeting := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerGreeting_R(Self: TIdTCPServer; var T: TIdRFCReply);
begin T := Self.Greeting; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerDefaultPort_W(Self: TIdTCPServer; const T: integer);
begin Self.DefaultPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerDefaultPort_R(Self: TIdTCPServer; var T: integer);
begin T := Self.DefaultPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerCommandHandlersEnabled_W(Self: TIdTCPServer; const T: boolean);
begin Self.CommandHandlersEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerCommandHandlersEnabled_R(Self: TIdTCPServer; var T: boolean);
begin T := Self.CommandHandlersEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerCommandHandlers_W(Self: TIdTCPServer; const T: TIdCommandHandlers);
begin Self.CommandHandlers := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerCommandHandlers_R(Self: TIdTCPServer; var T: TIdCommandHandlers);
begin T := Self.CommandHandlers; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerBindings_W(Self: TIdTCPServer; const T: TIdSocketHandles);
begin Self.Bindings := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerBindings_R(Self: TIdTCPServer; var T: TIdSocketHandles);
begin T := Self.Bindings; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerActive_W(Self: TIdTCPServer; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerActive_R(Self: TIdTCPServer; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerThreads_R(Self: TIdTCPServer; var T: TThreadList);
begin T := Self.Threads; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerThreadClass_W(Self: TIdTCPServer; const T: TIdThreadClass);
begin Self.ThreadClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerThreadClass_R(Self: TIdTCPServer; var T: TIdThreadClass);
begin T := Self.ThreadClass; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerImplicitThreadMgr_R(Self: TIdTCPServer; var T: Boolean);
begin T := Self.ImplicitThreadMgr; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerImplicitIOHandler_R(Self: TIdTCPServer; var T: Boolean);
begin T := Self.ImplicitIOHandler; end;

(*----------------------------------------------------------------------------*)
procedure TIdPeerThreadConnection_R(Self: TIdPeerThread; var T: TIdTCPServerConnection);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerConnectionServer_R(Self: TIdTCPServerConnection; var T: TIdTCPServer);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPServerConnectionSocket_R(Self: TIdTCPServerConnection; var T: TIdIOHandlerSocket);
begin T := Self.Socket; end;

(*----------------------------------------------------------------------------*)
procedure TIdListenerThreadServer_R(Self: TIdListenerThread; var T: TIdTCPServer);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TIdListenerThreadBinding_W(Self: TIdListenerThread; const T: TIdSocketHandle);
begin Self.Binding := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdListenerThreadBinding_R(Self: TIdListenerThread; var T: TIdSocketHandle);
begin T := Self.Binding; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandUnparsedParams_R(Self: TIdCommand; var T: string);
begin T := Self.UnparsedParams; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandThread_R(Self: TIdCommand; var T: TIdPeerThread);
begin T := Self.Thread; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandResponse_W(Self: TIdCommand; const T: TStrings);
begin Self.Response := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandResponse_R(Self: TIdCommand; var T: TStrings);
begin T := Self.Response; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandReply_W(Self: TIdCommand; const T: TIdRFCReply);
begin Self.Reply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandReply_R(Self: TIdCommand; var T: TIdRFCReply);
begin T := Self.Reply; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandRawLine_R(Self: TIdCommand; var T: string);
begin T := Self.RawLine; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandParams_R(Self: TIdCommand; var T: TStrings);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandPerformReply_W(Self: TIdCommand; const T: Boolean);
begin Self.PerformReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandPerformReply_R(Self: TIdCommand; var T: Boolean);
begin T := Self.PerformReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandCommandHandler_R(Self: TIdCommand; var T: TIdCommandHandler);
begin T := Self.CommandHandler; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlersServer_R(Self: TIdCommandHandlers; var T: TIdTCPServer);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlersOwnedBy_R(Self: TIdCommandHandlers; var T: TPersistent);
begin T := Self.OwnedBy; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlersItems_W(Self: TIdCommandHandlers; const T: TIdCommandHandler; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlersItems_R(Self: TIdCommandHandlers; var T: TIdCommandHandler; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerTag_W(Self: TIdCommandHandler; const T: integer);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerTag_R(Self: TIdCommandHandler; var T: integer);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerResponse_W(Self: TIdCommandHandler; const T: TStrings);
begin Self.Response := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerResponse_R(Self: TIdCommandHandler; var T: TStrings);
begin T := Self.Response; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerReplyNormal_W(Self: TIdCommandHandler; const T: TIdRFCReply);
begin Self.ReplyNormal := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerReplyNormal_R(Self: TIdCommandHandler; var T: TIdRFCReply);
begin T := Self.ReplyNormal; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerReplyExceptionCode_W(Self: TIdCommandHandler; const T: Integer);
begin Self.ReplyExceptionCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerReplyExceptionCode_R(Self: TIdCommandHandler; var T: Integer);
begin T := Self.ReplyExceptionCode; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerParseParams_W(Self: TIdCommandHandler; const T: Boolean);
begin Self.ParseParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerParseParams_R(Self: TIdCommandHandler; var T: Boolean);
begin T := Self.ParseParams; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerParamDelimiter_W(Self: TIdCommandHandler; const T: Char);
begin Self.ParamDelimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerParamDelimiter_R(Self: TIdCommandHandler; var T: Char);
begin T := Self.ParamDelimiter; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerOnCommand_W(Self: TIdCommandHandler; const T: TIdCommandEvent);
begin Self.OnCommand := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerOnCommand_R(Self: TIdCommandHandler; var T: TIdCommandEvent);
begin T := Self.OnCommand; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerName_W(Self: TIdCommandHandler; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerName_R(Self: TIdCommandHandler; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerEnabled_W(Self: TIdCommandHandler; const T: boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerEnabled_R(Self: TIdCommandHandler; var T: boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerDisconnect_W(Self: TIdCommandHandler; const T: boolean);
begin Self.Disconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerDisconnect_R(Self: TIdCommandHandler; var T: boolean);
begin T := Self.Disconnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerCommand_W(Self: TIdCommandHandler; const T: string);
begin Self.Command := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerCommand_R(Self: TIdCommandHandler; var T: string);
begin T := Self.Command; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerCmdDelimiter_W(Self: TIdCommandHandler; const T: Char);
begin Self.CmdDelimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerCmdDelimiter_R(Self: TIdCommandHandler; var T: Char);
begin T := Self.CmdDelimiter; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerData_W(Self: TIdCommandHandler; const T: TObject);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCommandHandlerData_R(Self: TIdCommandHandler; var T: TObject);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdTCPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdTCPServer) do begin
    RegisterConstructor(@TIdTCPServer.Create, 'Create');
     RegisterMethod(@TIDTCPServer.Destroy, 'Free');
     RegisterMethod(@TIDTCPServer.loaded, 'Loaded');
    RegisterPropertyHelper(@TIdTCPServerImplicitIOHandler_R,nil,'ImplicitIOHandler');
    RegisterPropertyHelper(@TIdTCPServerImplicitThreadMgr_R,nil,'ImplicitThreadMgr');
    RegisterPropertyHelper(@TIdTCPServerThreadClass_R,@TIdTCPServerThreadClass_W,'ThreadClass');
    RegisterPropertyHelper(@TIdTCPServerThreads_R,nil,'Threads');
    RegisterPropertyHelper(@TIdTCPServerActive_R,@TIdTCPServerActive_W,'Active');
    RegisterPropertyHelper(@TIdTCPServerBindings_R,@TIdTCPServerBindings_W,'Bindings');
    RegisterPropertyHelper(@TIdTCPServerCommandHandlers_R,@TIdTCPServerCommandHandlers_W,'CommandHandlers');
    RegisterPropertyHelper(@TIdTCPServerCommandHandlersEnabled_R,@TIdTCPServerCommandHandlersEnabled_W,'CommandHandlersEnabled');
    RegisterPropertyHelper(@TIdTCPServerDefaultPort_R,@TIdTCPServerDefaultPort_W,'DefaultPort');
    RegisterPropertyHelper(@TIdTCPServerGreeting_R,@TIdTCPServerGreeting_W,'Greeting');
    RegisterPropertyHelper(@TIdTCPServerIntercept_R,@TIdTCPServerIntercept_W,'Intercept');
    RegisterPropertyHelper(@TIdTCPServerIOHandler_R,@TIdTCPServerIOHandler_W,'IOHandler');
    RegisterPropertyHelper(@TIdTCPServerListenQueue_R,@TIdTCPServerListenQueue_W,'ListenQueue');
    RegisterPropertyHelper(@TIdTCPServerMaxConnectionReply_R,@TIdTCPServerMaxConnectionReply_W,'MaxConnectionReply');
    RegisterPropertyHelper(@TIdTCPServerMaxConnections_R,@TIdTCPServerMaxConnections_W,'MaxConnections');
    RegisterPropertyHelper(@TIdTCPServerOnAfterCommandHandler_R,@TIdTCPServerOnAfterCommandHandler_W,'OnAfterCommandHandler');
    RegisterPropertyHelper(@TIdTCPServerOnBeforeCommandHandler_R,@TIdTCPServerOnBeforeCommandHandler_W,'OnBeforeCommandHandler');
    RegisterPropertyHelper(@TIdTCPServerOnConnect_R,@TIdTCPServerOnConnect_W,'OnConnect');
    RegisterPropertyHelper(@TIdTCPServerOnExecute_R,@TIdTCPServerOnExecute_W,'OnExecute');
    RegisterPropertyHelper(@TIdTCPServerOnDisconnect_R,@TIdTCPServerOnDisconnect_W,'OnDisconnect');
    RegisterPropertyHelper(@TIdTCPServerOnException_R,@TIdTCPServerOnException_W,'OnException');
    RegisterPropertyHelper(@TIdTCPServerOnListenException_R,@TIdTCPServerOnListenException_W,'OnListenException');
    RegisterPropertyHelper(@TIdTCPServerOnNoCommandHandler_R,@TIdTCPServerOnNoCommandHandler_W,'OnNoCommandHandler');
    RegisterPropertyHelper(@TIdTCPServerReplyExceptionCode_R,@TIdTCPServerReplyExceptionCode_W,'ReplyExceptionCode');
    RegisterPropertyHelper(@TIdTCPServerReplyTexts_R,@TIdTCPServerReplyTexts_W,'ReplyTexts');
    RegisterPropertyHelper(@TIdTCPServerReplyUnknownCommand_R,@TIdTCPServerReplyUnknownCommand_W,'ReplyUnknownCommand');
    RegisterPropertyHelper(@TIdTCPServerReuseSocket_R,@TIdTCPServerReuseSocket_W,'ReuseSocket');
    RegisterPropertyHelper(@TIdTCPServerTerminateWaitTime_R,@TIdTCPServerTerminateWaitTime_W,'TerminateWaitTime');
    RegisterPropertyHelper(@TIdTCPServerThreadMgr_R,@TIdTCPServerThreadMgr_W,'ThreadMgr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdPeerThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdPeerThread) do begin
    RegisterPropertyHelper(@TIdPeerThreadConnection_R,nil,'Connection');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdTCPServerConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdTCPServerConnection) do begin
    RegisterConstructor(@TIdTCPServerConnection.Create, 'Create');
     RegisterMethod(@TIdTCPServerConnection.Destroy, 'Free');

    RegisterPropertyHelper(@TIdTCPServerConnectionServer_R,nil,'Server');
    RegisterPropertyHelper(@TIdTCPServerConnectionSocket_R,nil,'Socket');

    //   RegisterProperty('Socket', 'TIdIOHandlerSocket', iptr);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdListenerThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdListenerThread) do
  begin
    RegisterConstructor(@TIdListenerThread.Create, 'Create');
    RegisterPropertyHelper(@TIdListenerThreadBinding_R,@TIdListenerThreadBinding_W,'Binding');
    RegisterPropertyHelper(@TIdListenerThreadServer_R,nil,'Server');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdCommand(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdCommand) do begin
    RegisterVirtualConstructor(@TIdCommand.Create, 'Create');
     RegisterMethod(@TIdCommand.Destroy, 'Free');
    RegisterMethod(@TIdCommand.SendReply, 'SendReply');
    RegisterMethod(@TIdCommand.SetResponse, 'SetResponse');
    RegisterPropertyHelper(@TIdCommandCommandHandler_R,nil,'CommandHandler');
    RegisterPropertyHelper(@TIdCommandPerformReply_R,@TIdCommandPerformReply_W,'PerformReply');
    RegisterPropertyHelper(@TIdCommandParams_R,nil,'Params');
    RegisterPropertyHelper(@TIdCommandRawLine_R,nil,'RawLine');
    RegisterPropertyHelper(@TIdCommandReply_R,@TIdCommandReply_W,'Reply');
    RegisterPropertyHelper(@TIdCommandResponse_R,@TIdCommandResponse_W,'Response');
    RegisterPropertyHelper(@TIdCommandThread_R,nil,'Thread');
    RegisterPropertyHelper(@TIdCommandUnparsedParams_R,nil,'UnparsedParams');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdCommandHandlers(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdCommandHandlers) do begin
    RegisterMethod(@TIdCommandHandlers.Add, 'Add');
    RegisterConstructor(@TIdCommandHandlers.Create, 'Create');
    RegisterPropertyHelper(@TIdCommandHandlersItems_R,@TIdCommandHandlersItems_W,'Items');
    RegisterPropertyHelper(@TIdCommandHandlersOwnedBy_R,nil,'OwnedBy');
    RegisterPropertyHelper(@TIdCommandHandlersServer_R,nil,'Server');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdCommandHandler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdCommandHandler) do begin
    RegisterVirtualMethod(@TIdCommandHandler.Check, 'Check');
    RegisterConstructor(@TIdCommandHandler.Create, 'Create');
    RegisterMethod(@TIdCommandHandler.NameIs, 'NameIs');
    RegisterPropertyHelper(@TIdCommandHandlerData_R,@TIdCommandHandlerData_W,'Data');
    RegisterPropertyHelper(@TIdCommandHandlerCmdDelimiter_R,@TIdCommandHandlerCmdDelimiter_W,'CmdDelimiter');
    RegisterPropertyHelper(@TIdCommandHandlerCommand_R,@TIdCommandHandlerCommand_W,'Command');
    RegisterPropertyHelper(@TIdCommandHandlerDisconnect_R,@TIdCommandHandlerDisconnect_W,'Disconnect');
    RegisterPropertyHelper(@TIdCommandHandlerEnabled_R,@TIdCommandHandlerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TIdCommandHandlerName_R,@TIdCommandHandlerName_W,'Name');
    RegisterPropertyHelper(@TIdCommandHandlerOnCommand_R,@TIdCommandHandlerOnCommand_W,'OnCommand');
    RegisterPropertyHelper(@TIdCommandHandlerParamDelimiter_R,@TIdCommandHandlerParamDelimiter_W,'ParamDelimiter');
    RegisterPropertyHelper(@TIdCommandHandlerParseParams_R,@TIdCommandHandlerParseParams_W,'ParseParams');
    RegisterPropertyHelper(@TIdCommandHandlerReplyExceptionCode_R,@TIdCommandHandlerReplyExceptionCode_W,'ReplyExceptionCode');
    RegisterPropertyHelper(@TIdCommandHandlerReplyNormal_R,@TIdCommandHandlerReplyNormal_W,'ReplyNormal');
    RegisterPropertyHelper(@TIdCommandHandlerResponse_R,@TIdCommandHandlerResponse_W,'Response');
    RegisterPropertyHelper(@TIdCommandHandlerTag_R,@TIdCommandHandlerTag_W,'Tag');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdTCPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdCommandHandler) do
  with CL.Add(TIdCommand) do
  with CL.Add(TIdPeerThread) do
  with CL.Add(TIdTCPServer) do
  RIRegister_TIdCommandHandler(CL);
  RIRegister_TIdCommandHandlers(CL);
  RIRegister_TIdCommand(CL);
  RIRegister_TIdListenerThread(CL);
  RIRegister_TIdTCPServerConnection(CL);
  RIRegister_TIdPeerThread(CL);
  RIRegister_TIdTCPServer(CL);
  with CL.Add(EIdTCPServerError) do
  with CL.Add(EIdNoExecuteSpecified) do
  with CL.Add(EIdTerminateThreadTimeout) do
end;

 
 
{ TPSImport_IdTCPServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdTCPServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdTCPServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdTCPServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdTCPServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
