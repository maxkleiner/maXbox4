unit uPSI_IdSMTPServer;
{
   in the end
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
  TPSImport_IdSMTPServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdSMTPServerThread(CL: TPSPascalCompiler);
procedure SIRegister_TIdSMTPServer(CL: TPSPascalCompiler);
procedure SIRegister_TIdSMTPMessages(CL: TPSPascalCompiler);
procedure SIRegister_TIdSMTPDataReplies(CL: TPSPascalCompiler);
procedure SIRegister_TIdSMTPRcpReplies(CL: TPSPascalCompiler);
procedure SIRegister_TIdSMTPGreeting(CL: TPSPascalCompiler);
procedure SIRegister_IdSMTPServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdSMTPServerThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSMTPServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSMTPMessages(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSMTPDataReplies(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSMTPRcpReplies(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSMTPGreeting(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdSMTPServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdTCPClient
  ,IdTCPServer
  ,IdMessage
  ,IdEMailAddress
  ,IdCoderMIME
  ,IdMessageClient
  ,IdIOHandlerSocket
  ,IdStack
  ,IdSMTPServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdSMTPServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSMTPServerThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdPeerThread', 'TIdSMTPServerThread') do
  with CL.AddClassN(CL.FindClass('TIdPeerThread'),'TIdSMTPServerThread') do
  begin
    RegisterProperty('SMTPState', 'TIdSMTPState', iptrw);
    RegisterProperty('From', 'string', iptrw);
    RegisterProperty('RCPTList', 'TIdEMailAddressList', iptrw);
    RegisterProperty('HELO', 'Boolean', iptrw);
    RegisterProperty('EHLO', 'Boolean', iptrw);
    RegisterProperty('Username', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('LoggedIn', 'Boolean', iptrw);
    RegisterMethod('Constructor Create( ACreateSuspended : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSMTPServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdSMTPServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdSMTPServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure SetMessages( AValue : TIdSMTPMessages)');
    RegisterProperty('AuthMode', 'Boolean', iptrw);
    RegisterProperty('Messages', 'TIdSMTPMessages', iptrw);
    RegisterProperty('OnReceiveRaw', 'TOnReceiveRaw', iptrw);
    RegisterProperty('OnReceiveMessage', 'TOnReceiveMessage', iptrw);
    RegisterProperty('OnReceiveMessageParsed', 'TOnReceiveMessage', iptrw);
    RegisterProperty('ReceiveMode', 'TIdSMTPReceiveMode', iptrw);
    RegisterProperty('AllowEHLO', 'boolean', iptrw);
    RegisterProperty('NoDecode', 'Boolean', iptrw);
    RegisterProperty('NoEncode', 'Boolean', iptrw);
    RegisterProperty('OnCommandRCPT', 'THasAddress', iptrw);
    RegisterProperty('OnCommandMAIL', 'THasAddress2', iptrw);
    RegisterProperty('OnCommandAUTH', 'TBasicHandler', iptrw);
    RegisterProperty('CheckUser', 'TUserHandler', iptrw);
    RegisterProperty('RawStreamType', 'TIdStreamType', iptrw);
    RegisterProperty('OnCommandHELP', 'TBasicHandler', iptrw);
    RegisterProperty('OnCommandSOML', 'TBasicHandler', iptrw);
    RegisterProperty('OnCommandSEND', 'TBasicHandler', iptrw);
    RegisterProperty('OnCommandSAML', 'TBasicHandler', iptrw);
    RegisterProperty('OnCommandVRFY', 'TBasicHandler', iptrw);
    RegisterProperty('OnCommandEXPN', 'TBasicHandler', iptrw);
    RegisterProperty('OnCommandTURN', 'TBasicHandler', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSMTPMessages(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIdSMTPMessages') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIdSMTPMessages') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('NoopReply', 'string', iptrw);
    RegisterProperty('RSetReply', 'string', iptrw);
    RegisterProperty('QuitReply', 'string', iptrw);
    RegisterProperty('ErrorReply', 'string', iptrw);
    RegisterProperty('SequenceError', 'string', iptrw);
    RegisterProperty('NotLoggedIn', 'String', iptrw);
    RegisterProperty('XServer', 'string', iptrw);
    RegisterProperty('ReceivedHeader', 'string', iptrw);
    RegisterProperty('SyntaxErrorReply', 'string', iptrw);
    RegisterProperty('Greeting', 'TIdSMTPGreeting', iptrw);
    RegisterProperty('RcpReplies', 'TIdSMTPRcpReplies', iptrw);
    RegisterProperty('DataReplies', 'TIdSMTPDataReplies', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSMTPDataReplies(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIdSMTPDataReplies') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIdSMTPDataReplies') do begin
    RegisterProperty('fStartDataReply', 'string', iptrw);
    RegisterProperty('fEndDataReply', 'string', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('StartDataReply', 'string', iptrw);
    RegisterProperty('EndDataReply', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSMTPRcpReplies(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIdSMTPRcpReplies') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIdSMTPRcpReplies') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('AddressOkReply', 'string', iptrw);
    RegisterProperty('AddressErrorReply', 'string', iptrw);
    RegisterProperty('AddressWillForwardReply', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSMTPGreeting(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIdSMTPGreeting') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIdSMTPGreeting') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('EHLONotSupported', 'string', iptrw);
    RegisterProperty('HelloReply', 'string', iptrw);
    RegisterProperty('NoHello', 'string', iptrw);
    RegisterProperty('AuthFailed', 'string', iptrw);
    RegisterProperty('EHLOReply', 'TStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdSMTPServer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOnReceiveRaw', 'Procedure ( ASender : TIdCommand; var VStream :'
   +' TStream; RCPT : TIdEMailAddressList; var CustomError : string)');
  CL.AddTypeS('TOnReceiveMessage', 'Procedure ( ASender : TIdCommand; var AMsg '
   +': TIdMessage; RCPT : TIdEMailAddressList; var CustomError : string)');
  CL.AddTypeS('TBasicHandler', 'Procedure ( ASender : TIdCommand)');
  CL.AddTypeS('TUserHandler', 'Procedure ( ASender : TIdCommand; var Accept : B'
   +'oolean; Username, Password : string)');
  CL.AddTypeS('THasAddress', 'Procedure ( const ASender : TIdCommand; var Accep'
   +'t, ToForward : Boolean; EMailAddress : string; var CustomError : string)');
  CL.AddTypeS('THasAddress2', 'Procedure ( const ASender : TIdCommand; var Acce'
   +'pt : Boolean; EMailAddress : string)');
  CL.AddTypeS('TIdSMTPReceiveMode', '( rmRaw, rmMessage, rmMessageParsed )');
  CL.AddTypeS('TIdStreamType', '( stFileStream, stMemoryStream )');
  SIRegister_TIdSMTPGreeting(CL);
  SIRegister_TIdSMTPRcpReplies(CL);
  SIRegister_TIdSMTPDataReplies(CL);
  SIRegister_TIdSMTPMessages(CL);
  SIRegister_TIdSMTPServer(CL);
  CL.AddTypeS('TIdSMTPState', '( idSMTPNone, idSMTPHelo, idSMTPMail, idSMTPRcpt'
   +', idSMTPData )');
  SIRegister_TIdSMTPServerThread(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadLoggedIn_W(Self: TIdSMTPServerThread; const T: Boolean);
Begin Self.LoggedIn := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadLoggedIn_R(Self: TIdSMTPServerThread; var T: Boolean);
Begin T := Self.LoggedIn; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadPassword_W(Self: TIdSMTPServerThread; const T: string);
Begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadPassword_R(Self: TIdSMTPServerThread; var T: string);
Begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadUsername_W(Self: TIdSMTPServerThread; const T: string);
Begin Self.Username := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadUsername_R(Self: TIdSMTPServerThread; var T: string);
Begin T := Self.Username; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadEHLO_W(Self: TIdSMTPServerThread; const T: Boolean);
Begin Self.EHLO := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadEHLO_R(Self: TIdSMTPServerThread; var T: Boolean);
Begin T := Self.EHLO; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadHELO_W(Self: TIdSMTPServerThread; const T: Boolean);
Begin Self.HELO := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadHELO_R(Self: TIdSMTPServerThread; var T: Boolean);
Begin T := Self.HELO; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadRCPTList_W(Self: TIdSMTPServerThread; const T: TIdEMailAddressList);
Begin Self.RCPTList := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadRCPTList_R(Self: TIdSMTPServerThread; var T: TIdEMailAddressList);
Begin T := Self.RCPTList; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadFrom_W(Self: TIdSMTPServerThread; const T: string);
Begin Self.From := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadFrom_R(Self: TIdSMTPServerThread; var T: string);
Begin T := Self.From; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadSMTPState_W(Self: TIdSMTPServerThread; const T: TIdSMTPState);
Begin Self.SMTPState := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerThreadSMTPState_R(Self: TIdSMTPServerThread; var T: TIdSMTPState);
Begin T := Self.SMTPState; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandTURN_W(Self: TIdSMTPServer; const T: TBasicHandler);
begin Self.OnCommandTURN := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandTURN_R(Self: TIdSMTPServer; var T: TBasicHandler);
begin T := Self.OnCommandTURN; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandEXPN_W(Self: TIdSMTPServer; const T: TBasicHandler);
begin Self.OnCommandEXPN := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandEXPN_R(Self: TIdSMTPServer; var T: TBasicHandler);
begin T := Self.OnCommandEXPN; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandVRFY_W(Self: TIdSMTPServer; const T: TBasicHandler);
begin Self.OnCommandVRFY := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandVRFY_R(Self: TIdSMTPServer; var T: TBasicHandler);
begin T := Self.OnCommandVRFY; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandSAML_W(Self: TIdSMTPServer; const T: TBasicHandler);
begin Self.OnCommandSAML := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandSAML_R(Self: TIdSMTPServer; var T: TBasicHandler);
begin T := Self.OnCommandSAML; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandSEND_W(Self: TIdSMTPServer; const T: TBasicHandler);
begin Self.OnCommandSEND := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandSEND_R(Self: TIdSMTPServer; var T: TBasicHandler);
begin T := Self.OnCommandSEND; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandSOML_W(Self: TIdSMTPServer; const T: TBasicHandler);
begin Self.OnCommandSOML := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandSOML_R(Self: TIdSMTPServer; var T: TBasicHandler);
begin T := Self.OnCommandSOML; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandHELP_W(Self: TIdSMTPServer; const T: TBasicHandler);
begin Self.OnCommandHELP := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandHELP_R(Self: TIdSMTPServer; var T: TBasicHandler);
begin T := Self.OnCommandHELP; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerRawStreamType_W(Self: TIdSMTPServer; const T: TIdStreamType);
begin Self.RawStreamType := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerRawStreamType_R(Self: TIdSMTPServer; var T: TIdStreamType);
begin T := Self.RawStreamType; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerCheckUser_W(Self: TIdSMTPServer; const T: TUserHandler);
begin Self.CheckUser := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerCheckUser_R(Self: TIdSMTPServer; var T: TUserHandler);
begin T := Self.CheckUser; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandAUTH_W(Self: TIdSMTPServer; const T: TBasicHandler);
begin Self.OnCommandAUTH := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandAUTH_R(Self: TIdSMTPServer; var T: TBasicHandler);
begin T := Self.OnCommandAUTH; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandMAIL_W(Self: TIdSMTPServer; const T: THasAddress2);
begin Self.OnCommandMAIL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandMAIL_R(Self: TIdSMTPServer; var T: THasAddress2);
begin T := Self.OnCommandMAIL; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandRCPT_W(Self: TIdSMTPServer; const T: THasAddress);
begin Self.OnCommandRCPT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnCommandRCPT_R(Self: TIdSMTPServer; var T: THasAddress);
begin T := Self.OnCommandRCPT; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerNoEncode_W(Self: TIdSMTPServer; const T: Boolean);
begin Self.NoEncode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerNoEncode_R(Self: TIdSMTPServer; var T: Boolean);
begin T := Self.NoEncode; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerNoDecode_W(Self: TIdSMTPServer; const T: Boolean);
begin Self.NoDecode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerNoDecode_R(Self: TIdSMTPServer; var T: Boolean);
begin T := Self.NoDecode; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerAllowEHLO_W(Self: TIdSMTPServer; const T: boolean);
begin Self.AllowEHLO := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerAllowEHLO_R(Self: TIdSMTPServer; var T: boolean);
begin T := Self.AllowEHLO; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerReceiveMode_W(Self: TIdSMTPServer; const T: TIdSMTPReceiveMode);
begin Self.ReceiveMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerReceiveMode_R(Self: TIdSMTPServer; var T: TIdSMTPReceiveMode);
begin T := Self.ReceiveMode; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnReceiveMessageParsed_W(Self: TIdSMTPServer; const T: TOnReceiveMessage);
begin Self.OnReceiveMessageParsed := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnReceiveMessageParsed_R(Self: TIdSMTPServer; var T: TOnReceiveMessage);
begin T := Self.OnReceiveMessageParsed; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnReceiveMessage_W(Self: TIdSMTPServer; const T: TOnReceiveMessage);
begin Self.OnReceiveMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnReceiveMessage_R(Self: TIdSMTPServer; var T: TOnReceiveMessage);
begin T := Self.OnReceiveMessage; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnReceiveRaw_W(Self: TIdSMTPServer; const T: TOnReceiveRaw);
begin Self.OnReceiveRaw := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerOnReceiveRaw_R(Self: TIdSMTPServer; var T: TOnReceiveRaw);
begin T := Self.OnReceiveRaw; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerMessages_W(Self: TIdSMTPServer; const T: TIdSMTPMessages);
begin Self.Messages := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerMessages_R(Self: TIdSMTPServer; var T: TIdSMTPMessages);
begin T := Self.Messages; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerAuthMode_W(Self: TIdSMTPServer; const T: Boolean);
begin Self.AuthMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPServerAuthMode_R(Self: TIdSMTPServer; var T: Boolean);
begin T := Self.AuthMode; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesDataReplies_W(Self: TIdSMTPMessages; const T: TIdSMTPDataReplies);
begin Self.DataReplies := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesDataReplies_R(Self: TIdSMTPMessages; var T: TIdSMTPDataReplies);
begin T := Self.DataReplies; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesRcpReplies_W(Self: TIdSMTPMessages; const T: TIdSMTPRcpReplies);
begin Self.RcpReplies := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesRcpReplies_R(Self: TIdSMTPMessages; var T: TIdSMTPRcpReplies);
begin T := Self.RcpReplies; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesGreeting_W(Self: TIdSMTPMessages; const T: TIdSMTPGreeting);
begin Self.Greeting := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesGreeting_R(Self: TIdSMTPMessages; var T: TIdSMTPGreeting);
begin T := Self.Greeting; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesSyntaxErrorReply_W(Self: TIdSMTPMessages; const T: string);
begin Self.SyntaxErrorReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesSyntaxErrorReply_R(Self: TIdSMTPMessages; var T: string);
begin T := Self.SyntaxErrorReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesReceivedHeader_W(Self: TIdSMTPMessages; const T: string);
begin Self.ReceivedHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesReceivedHeader_R(Self: TIdSMTPMessages; var T: string);
begin T := Self.ReceivedHeader; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesXServer_W(Self: TIdSMTPMessages; const T: string);
begin Self.XServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesXServer_R(Self: TIdSMTPMessages; var T: string);
begin T := Self.XServer; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesNotLoggedIn_W(Self: TIdSMTPMessages; const T: String);
begin Self.NotLoggedIn := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesNotLoggedIn_R(Self: TIdSMTPMessages; var T: String);
begin T := Self.NotLoggedIn; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesSequenceError_W(Self: TIdSMTPMessages; const T: string);
begin Self.SequenceError := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesSequenceError_R(Self: TIdSMTPMessages; var T: string);
begin T := Self.SequenceError; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesErrorReply_W(Self: TIdSMTPMessages; const T: string);
begin Self.ErrorReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesErrorReply_R(Self: TIdSMTPMessages; var T: string);
begin T := Self.ErrorReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesQuitReply_W(Self: TIdSMTPMessages; const T: string);
begin Self.QuitReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesQuitReply_R(Self: TIdSMTPMessages; var T: string);
begin T := Self.QuitReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesRSetReply_W(Self: TIdSMTPMessages; const T: string);
begin Self.RSetReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesRSetReply_R(Self: TIdSMTPMessages; var T: string);
begin T := Self.RSetReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesNoopReply_W(Self: TIdSMTPMessages; const T: string);
begin Self.NoopReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPMessagesNoopReply_R(Self: TIdSMTPMessages; var T: string);
begin T := Self.NoopReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPDataRepliesEndDataReply_W(Self: TIdSMTPDataReplies; const T: string);
begin Self.EndDataReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPDataRepliesEndDataReply_R(Self: TIdSMTPDataReplies; var T: string);
begin T := Self.EndDataReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPDataRepliesStartDataReply_W(Self: TIdSMTPDataReplies; const T: string);
begin Self.StartDataReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPDataRepliesStartDataReply_R(Self: TIdSMTPDataReplies; var T: string);
begin T := Self.StartDataReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPDataRepliesfEndDataReply_W(Self: TIdSMTPDataReplies; const T: string);
Begin Self.fEndDataReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPDataRepliesfEndDataReply_R(Self: TIdSMTPDataReplies; var T: string);
Begin T := Self.fEndDataReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPDataRepliesfStartDataReply_W(Self: TIdSMTPDataReplies; const T: string);
Begin Self.fStartDataReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPDataRepliesfStartDataReply_R(Self: TIdSMTPDataReplies; var T: string);
Begin T := Self.fStartDataReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPRcpRepliesAddressWillForwardReply_W(Self: TIdSMTPRcpReplies; const T: string);
begin Self.AddressWillForwardReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPRcpRepliesAddressWillForwardReply_R(Self: TIdSMTPRcpReplies; var T: string);
begin T := Self.AddressWillForwardReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPRcpRepliesAddressErrorReply_W(Self: TIdSMTPRcpReplies; const T: string);
begin Self.AddressErrorReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPRcpRepliesAddressErrorReply_R(Self: TIdSMTPRcpReplies; var T: string);
begin T := Self.AddressErrorReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPRcpRepliesAddressOkReply_W(Self: TIdSMTPRcpReplies; const T: string);
begin Self.AddressOkReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPRcpRepliesAddressOkReply_R(Self: TIdSMTPRcpReplies; var T: string);
begin T := Self.AddressOkReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPGreetingEHLOReply_W(Self: TIdSMTPGreeting; const T: TStrings);
begin Self.EHLOReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPGreetingEHLOReply_R(Self: TIdSMTPGreeting; var T: TStrings);
begin T := Self.EHLOReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPGreetingAuthFailed_W(Self: TIdSMTPGreeting; const T: string);
begin Self.AuthFailed := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPGreetingAuthFailed_R(Self: TIdSMTPGreeting; var T: string);
begin T := Self.AuthFailed; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPGreetingNoHello_W(Self: TIdSMTPGreeting; const T: string);
begin Self.NoHello := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPGreetingNoHello_R(Self: TIdSMTPGreeting; var T: string);
begin T := Self.NoHello; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPGreetingHelloReply_W(Self: TIdSMTPGreeting; const T: string);
begin Self.HelloReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPGreetingHelloReply_R(Self: TIdSMTPGreeting; var T: string);
begin T := Self.HelloReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPGreetingEHLONotSupported_W(Self: TIdSMTPGreeting; const T: string);
begin Self.EHLONotSupported := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSMTPGreetingEHLONotSupported_R(Self: TIdSMTPGreeting; var T: string);
begin T := Self.EHLONotSupported; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSMTPServerThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSMTPServerThread) do
  begin
    RegisterPropertyHelper(@TIdSMTPServerThreadSMTPState_R,@TIdSMTPServerThreadSMTPState_W,'SMTPState');
    RegisterPropertyHelper(@TIdSMTPServerThreadFrom_R,@TIdSMTPServerThreadFrom_W,'From');
    RegisterPropertyHelper(@TIdSMTPServerThreadRCPTList_R,@TIdSMTPServerThreadRCPTList_W,'RCPTList');
    RegisterPropertyHelper(@TIdSMTPServerThreadHELO_R,@TIdSMTPServerThreadHELO_W,'HELO');
    RegisterPropertyHelper(@TIdSMTPServerThreadEHLO_R,@TIdSMTPServerThreadEHLO_W,'EHLO');
    RegisterPropertyHelper(@TIdSMTPServerThreadUsername_R,@TIdSMTPServerThreadUsername_W,'Username');
    RegisterPropertyHelper(@TIdSMTPServerThreadPassword_R,@TIdSMTPServerThreadPassword_W,'Password');
    RegisterPropertyHelper(@TIdSMTPServerThreadLoggedIn_R,@TIdSMTPServerThreadLoggedIn_W,'LoggedIn');
    RegisterConstructor(@TIdSMTPServerThread.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSMTPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSMTPServer) do
  begin
    RegisterConstructor(@TIdSMTPServer.Create, 'Create');
    RegisterMethod(@TIdSMTPServer.SetMessages, 'SetMessages');
    RegisterPropertyHelper(@TIdSMTPServerAuthMode_R,@TIdSMTPServerAuthMode_W,'AuthMode');
    RegisterPropertyHelper(@TIdSMTPServerMessages_R,@TIdSMTPServerMessages_W,'Messages');
    RegisterPropertyHelper(@TIdSMTPServerOnReceiveRaw_R,@TIdSMTPServerOnReceiveRaw_W,'OnReceiveRaw');
    RegisterPropertyHelper(@TIdSMTPServerOnReceiveMessage_R,@TIdSMTPServerOnReceiveMessage_W,'OnReceiveMessage');
    RegisterPropertyHelper(@TIdSMTPServerOnReceiveMessageParsed_R,@TIdSMTPServerOnReceiveMessageParsed_W,'OnReceiveMessageParsed');
    RegisterPropertyHelper(@TIdSMTPServerReceiveMode_R,@TIdSMTPServerReceiveMode_W,'ReceiveMode');
    RegisterPropertyHelper(@TIdSMTPServerAllowEHLO_R,@TIdSMTPServerAllowEHLO_W,'AllowEHLO');
    RegisterPropertyHelper(@TIdSMTPServerNoDecode_R,@TIdSMTPServerNoDecode_W,'NoDecode');
    RegisterPropertyHelper(@TIdSMTPServerNoEncode_R,@TIdSMTPServerNoEncode_W,'NoEncode');
    RegisterPropertyHelper(@TIdSMTPServerOnCommandRCPT_R,@TIdSMTPServerOnCommandRCPT_W,'OnCommandRCPT');
    RegisterPropertyHelper(@TIdSMTPServerOnCommandMAIL_R,@TIdSMTPServerOnCommandMAIL_W,'OnCommandMAIL');
    RegisterPropertyHelper(@TIdSMTPServerOnCommandAUTH_R,@TIdSMTPServerOnCommandAUTH_W,'OnCommandAUTH');
    RegisterPropertyHelper(@TIdSMTPServerCheckUser_R,@TIdSMTPServerCheckUser_W,'CheckUser');
    RegisterPropertyHelper(@TIdSMTPServerRawStreamType_R,@TIdSMTPServerRawStreamType_W,'RawStreamType');
    RegisterPropertyHelper(@TIdSMTPServerOnCommandHELP_R,@TIdSMTPServerOnCommandHELP_W,'OnCommandHELP');
    RegisterPropertyHelper(@TIdSMTPServerOnCommandSOML_R,@TIdSMTPServerOnCommandSOML_W,'OnCommandSOML');
    RegisterPropertyHelper(@TIdSMTPServerOnCommandSEND_R,@TIdSMTPServerOnCommandSEND_W,'OnCommandSEND');
    RegisterPropertyHelper(@TIdSMTPServerOnCommandSAML_R,@TIdSMTPServerOnCommandSAML_W,'OnCommandSAML');
    RegisterPropertyHelper(@TIdSMTPServerOnCommandVRFY_R,@TIdSMTPServerOnCommandVRFY_W,'OnCommandVRFY');
    RegisterPropertyHelper(@TIdSMTPServerOnCommandEXPN_R,@TIdSMTPServerOnCommandEXPN_W,'OnCommandEXPN');
    RegisterPropertyHelper(@TIdSMTPServerOnCommandTURN_R,@TIdSMTPServerOnCommandTURN_W,'OnCommandTURN');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSMTPMessages(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSMTPMessages) do begin
    RegisterConstructor(@TIdSMTPMessages.Create, 'Create');
    RegisterMethod(@TIdSMTPMessages.Assign, 'Assign');
    RegisterPropertyHelper(@TIdSMTPMessagesNoopReply_R,@TIdSMTPMessagesNoopReply_W,'NoopReply');
    RegisterPropertyHelper(@TIdSMTPMessagesRSetReply_R,@TIdSMTPMessagesRSetReply_W,'RSetReply');
    RegisterPropertyHelper(@TIdSMTPMessagesQuitReply_R,@TIdSMTPMessagesQuitReply_W,'QuitReply');
    RegisterPropertyHelper(@TIdSMTPMessagesErrorReply_R,@TIdSMTPMessagesErrorReply_W,'ErrorReply');
    RegisterPropertyHelper(@TIdSMTPMessagesSequenceError_R,@TIdSMTPMessagesSequenceError_W,'SequenceError');
    RegisterPropertyHelper(@TIdSMTPMessagesNotLoggedIn_R,@TIdSMTPMessagesNotLoggedIn_W,'NotLoggedIn');
    RegisterPropertyHelper(@TIdSMTPMessagesXServer_R,@TIdSMTPMessagesXServer_W,'XServer');
    RegisterPropertyHelper(@TIdSMTPMessagesReceivedHeader_R,@TIdSMTPMessagesReceivedHeader_W,'ReceivedHeader');
    RegisterPropertyHelper(@TIdSMTPMessagesSyntaxErrorReply_R,@TIdSMTPMessagesSyntaxErrorReply_W,'SyntaxErrorReply');
    RegisterPropertyHelper(@TIdSMTPMessagesGreeting_R,@TIdSMTPMessagesGreeting_W,'Greeting');
    RegisterPropertyHelper(@TIdSMTPMessagesRcpReplies_R,@TIdSMTPMessagesRcpReplies_W,'RcpReplies');
    RegisterPropertyHelper(@TIdSMTPMessagesDataReplies_R,@TIdSMTPMessagesDataReplies_W,'DataReplies');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSMTPDataReplies(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSMTPDataReplies) do begin
    RegisterPropertyHelper(@TIdSMTPDataRepliesfStartDataReply_R,@TIdSMTPDataRepliesfStartDataReply_W,'fStartDataReply');
    RegisterPropertyHelper(@TIdSMTPDataRepliesfEndDataReply_R,@TIdSMTPDataRepliesfEndDataReply_W,'fEndDataReply');
    RegisterConstructor(@TIdSMTPDataReplies.Create, 'Create');
    RegisterMethod(@TIdSMTPDataReplies.Destroy, 'Free');
    RegisterMethod(@TIdSMTPDataReplies.Assign, 'Assign');
    RegisterPropertyHelper(@TIdSMTPDataRepliesStartDataReply_R,@TIdSMTPDataRepliesStartDataReply_W,'StartDataReply');
    RegisterPropertyHelper(@TIdSMTPDataRepliesEndDataReply_R,@TIdSMTPDataRepliesEndDataReply_W,'EndDataReply');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSMTPRcpReplies(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSMTPRcpReplies) do begin
    RegisterConstructor(@TIdSMTPRcpReplies.Create, 'Create');
    RegisterMethod(@TIdSMTPRcpReplies.Assign, 'Assign');
    RegisterMethod(@TIdSMTPRcpReplies.Destroy, 'Free');
    RegisterPropertyHelper(@TIdSMTPRcpRepliesAddressOkReply_R,@TIdSMTPRcpRepliesAddressOkReply_W,'AddressOkReply');
    RegisterPropertyHelper(@TIdSMTPRcpRepliesAddressErrorReply_R,@TIdSMTPRcpRepliesAddressErrorReply_W,'AddressErrorReply');
    RegisterPropertyHelper(@TIdSMTPRcpRepliesAddressWillForwardReply_R,@TIdSMTPRcpRepliesAddressWillForwardReply_W,'AddressWillForwardReply');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSMTPGreeting(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSMTPGreeting) do begin
    RegisterConstructor(@TIdSMTPGreeting.Create, 'Create');
    RegisterMethod(@TIdSMTPGreeting.Assign, 'Assign');
    RegisterMethod(@TIdSMTPGreeting.Destroy, 'Free');
    RegisterPropertyHelper(@TIdSMTPGreetingEHLONotSupported_R,@TIdSMTPGreetingEHLONotSupported_W,'EHLONotSupported');
    RegisterPropertyHelper(@TIdSMTPGreetingHelloReply_R,@TIdSMTPGreetingHelloReply_W,'HelloReply');
    RegisterPropertyHelper(@TIdSMTPGreetingNoHello_R,@TIdSMTPGreetingNoHello_W,'NoHello');
    RegisterPropertyHelper(@TIdSMTPGreetingAuthFailed_R,@TIdSMTPGreetingAuthFailed_W,'AuthFailed');
    RegisterPropertyHelper(@TIdSMTPGreetingEHLOReply_R,@TIdSMTPGreetingEHLOReply_W,'EHLOReply');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdSMTPServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdSMTPGreeting(CL);
  RIRegister_TIdSMTPRcpReplies(CL);
  RIRegister_TIdSMTPDataReplies(CL);
  RIRegister_TIdSMTPMessages(CL);
  RIRegister_TIdSMTPServer(CL);
  RIRegister_TIdSMTPServerThread(CL);
end;

 
 
{ TPSImport_IdSMTPServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSMTPServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdSMTPServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSMTPServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdSMTPServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
