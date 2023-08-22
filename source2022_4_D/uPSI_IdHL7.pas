unit uPSI_IdHL7;
{
  proto protocol
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
  TPSImport_IdHL7 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdHL7(CL: TPSPascalCompiler);
procedure SIRegister_TIdHL7ClientThread(CL: TPSPascalCompiler);
procedure SIRegister_TIdHL7PeerThread(CL: TPSPascalCompiler);
procedure SIRegister_EHL7CommunicationError(CL: TPSPascalCompiler);
procedure SIRegister_IdHL7(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdHL7(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdHL7ClientThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdHL7PeerThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_EHL7CommunicationError(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdHL7(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdBaseComponent
  ,IdException
  ,IdGlobal
  ,IdTCPClient
  ,IdTCPConnection
  ,IdTCPServer
  ,SyncObjs
  ,IdHL7
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdHL7]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHL7(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdHL7') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdHL7') do begin
    RegisterMethod('Constructor Create( Component : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure EnforceWaitReplyTimeout');
    RegisterMethod('Function Going : Boolean');
    RegisterProperty('ObjTag', 'TObject', iptrw);
    RegisterProperty('Status', 'TIdHL7Status', iptr);
    RegisterProperty('StatusDesc', 'String', iptr);
    RegisterMethod('Function Connected : Boolean');
    RegisterProperty('IsServer', 'Boolean', iptr);
    RegisterMethod('Procedure Start');
    RegisterMethod('Procedure PreStop');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure WaitForConnection( AMaxLength : Integer)');
    RegisterMethod('Function AsynchronousSend( AMsg : String) : TSendResponse');
    RegisterProperty('OnMessageArrive', 'TMessageArriveEvent', iptrw);
    RegisterMethod('Function SynchronousSend( AMsg : String; var VReply : String) : TSendResponse');
    RegisterProperty('OnReceiveMessage', 'TMessageReceiveEvent', iptrw);
    RegisterMethod('Procedure CheckSynchronousSendResult( AResult : TSendResponse; AMsg : String)');
    RegisterMethod('Procedure SendMessage( AMsg : String)');
    RegisterMethod('Function GetReply( var VReply : String) : TSendResponse');
    RegisterMethod('Function GetMessage( var VMsg : String) : pointer');
    RegisterMethod('Procedure SendReply( AMsgHnd : pointer; AReply : String)');
    RegisterProperty('Address', 'String', iptrw);
    RegisterProperty('Port', 'Word', iptrw);
    RegisterProperty('TimeOut', 'Cardinal', iptrw);
    RegisterProperty('ReceiveTimeout', 'Cardinal', iptrw);
    RegisterProperty('ConnectionLimit', 'Word', iptrw);
    RegisterProperty('IPRestriction', 'String', iptrw);
    RegisterProperty('IPMask', 'String', iptrw);
    RegisterProperty('ReconnectDelay', 'Cardinal', iptrw);
    RegisterProperty('CommunicationMode', 'THL7CommunicationMode', iptrw);
    RegisterProperty('IsListener', 'Boolean', iptrw);
    RegisterProperty('OnConnect', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDisconnect', 'TNotifyEvent', iptrw);
    RegisterProperty('OnConnCountChange', 'TIdHL7ConnCountEvent', iptrw);
    RegisterProperty('OnReceiveError', 'TReceiveErrorEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHL7ClientThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TIdHL7ClientThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TIdHL7ClientThread') do
  begin
    RegisterMethod('Constructor Create( aOwner : TIdHL7)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHL7PeerThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdPeerThread', 'TIdHL7PeerThread') do
  with CL.AddClassN(CL.FindClass('TIdPeerThread'),'TIdHL7PeerThread') do
  begin
    RegisterMethod('Constructor Create( ACreateSuspended : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EHL7CommunicationError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EIdException', 'EHL7CommunicationError') do
  with CL.AddClassN(CL.FindClass('EIdException'),'EHL7CommunicationError') do
  begin
    RegisterMethod('Constructor Create( AnInterfaceName, AMessage : String)');
    RegisterProperty('InterfaceName', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdHL7(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MSG_START','Char').SetString( #$0B);
 CL.AddConstantN('MSG_END','String').SetString( #$1C#$0D);
 CL.AddConstantN('BUFFER_SIZE_LIMIT','LongInt').SetInt( 1024 * 1024);
 CL.AddConstantN('WAIT_STOP','LongInt').SetInt( 5000);
  SIRegister_EHL7CommunicationError(CL);
  CL.AddTypeS('THL7CommunicationMode', '( cmUnknown, cmAsynchronous, cmSynchronous, cmSingleThread )');
  CL.AddTypeS('TSendResponse', '( srNone, srError, srNoConnection, srSent, srOK, srTimeout )');
  CL.AddTypeS('TIdHL7Status', '( isStopped, isNotConnected, isConnecting, isWai'
   +'tReconnect, isConnected, isUnusable )');
 CL.AddConstantN('DEFAULT_ADDRESS','String').SetString( '');
 CL.AddConstantN('DEFAULT_PORT','LongInt').SetInt( 0);
 CL.AddConstantN('DEFAULT_TIMEOUT','LongInt').SetInt( 30000);
 CL.AddConstantN('DEFAULT_RECEIVE_TIMEOUT','LongInt').SetInt( 30000);
 CL.AddConstantN('NULL_IP','String').SetString( '0.0.0.0');
 CL.AddConstantN('DEFAULT_CONN_LIMIT','LongInt').SetInt( 1);
 CL.AddConstantN('DEFAULT_RECONNECT_DELAY','LongInt').SetInt( 15000);
 //CL.AddConstantN('DEFAULT_COMM_MODE','').SetString( cmUnknown);
 //CL.AddConstantN('DEFAULT_IS_LISTENER','Boolean')BoolToStr( True);
 CL.AddConstantN('MILLISECOND_LENGTH','Extended').SetExtended(( 1 / ( 24 * 60 * 60 * 1000 ) ));
  CL.AddTypeS('TMessageArriveEvent', 'Procedure ( ASender : TObject; AConnectio'
   +'n : TIdTCPConnection; AMsg : String)');
  CL.AddTypeS('TMessageReceiveEvent', 'Procedure ( ASender : TObject; AConnecti'
   +'on : TIdTCPConnection; AMsg : String; var VHandled : Boolean; var VReply : String)');
  CL.AddTypeS('TReceiveErrorEvent', 'Procedure ( ASender : TObject; AConnection'
   +' : TIdTCPConnection; AMsg : String; AException : Exception; var VReply : S'
   +'tring; var VDropConnection : Boolean)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdHL7');
  CL.AddTypeS('TIdHL7ConnCountEvent', 'Procedure ( ASender : TIdHL7; AConnCount: Integer)');
  SIRegister_TIdHL7PeerThread(CL);
  SIRegister_TIdHL7ClientThread(CL);
  SIRegister_TIdHL7(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdHL7OnReceiveError_W(Self: TIdHL7; const T: TReceiveErrorEvent);
begin Self.OnReceiveError := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7OnReceiveError_R(Self: TIdHL7; var T: TReceiveErrorEvent);
begin T := Self.OnReceiveError; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7OnConnCountChange_W(Self: TIdHL7; const T: TIdHL7ConnCountEvent);
begin Self.OnConnCountChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7OnConnCountChange_R(Self: TIdHL7; var T: TIdHL7ConnCountEvent);
begin T := Self.OnConnCountChange; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7OnDisconnect_W(Self: TIdHL7; const T: TNotifyEvent);
begin Self.OnDisconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7OnDisconnect_R(Self: TIdHL7; var T: TNotifyEvent);
begin T := Self.OnDisconnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7OnConnect_W(Self: TIdHL7; const T: TNotifyEvent);
begin Self.OnConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7OnConnect_R(Self: TIdHL7; var T: TNotifyEvent);
begin T := Self.OnConnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7IsListener_W(Self: TIdHL7; const T: Boolean);
begin Self.IsListener := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7IsListener_R(Self: TIdHL7; var T: Boolean);
begin T := Self.IsListener; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7CommunicationMode_W(Self: TIdHL7; const T: THL7CommunicationMode);
begin Self.CommunicationMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7CommunicationMode_R(Self: TIdHL7; var T: THL7CommunicationMode);
begin T := Self.CommunicationMode; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7ReconnectDelay_W(Self: TIdHL7; const T: Cardinal);
begin Self.ReconnectDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7ReconnectDelay_R(Self: TIdHL7; var T: Cardinal);
begin T := Self.ReconnectDelay; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7IPMask_W(Self: TIdHL7; const T: String);
begin Self.IPMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7IPMask_R(Self: TIdHL7; var T: String);
begin T := Self.IPMask; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7IPRestriction_W(Self: TIdHL7; const T: String);
begin Self.IPRestriction := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7IPRestriction_R(Self: TIdHL7; var T: String);
begin T := Self.IPRestriction; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7ConnectionLimit_W(Self: TIdHL7; const T: Word);
begin Self.ConnectionLimit := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7ConnectionLimit_R(Self: TIdHL7; var T: Word);
begin T := Self.ConnectionLimit; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7ReceiveTimeout_W(Self: TIdHL7; const T: Cardinal);
begin Self.ReceiveTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7ReceiveTimeout_R(Self: TIdHL7; var T: Cardinal);
begin T := Self.ReceiveTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7TimeOut_W(Self: TIdHL7; const T: Cardinal);
begin Self.TimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7TimeOut_R(Self: TIdHL7; var T: Cardinal);
begin T := Self.TimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7Port_W(Self: TIdHL7; const T: Word);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7Port_R(Self: TIdHL7; var T: Word);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7Address_W(Self: TIdHL7; const T: String);
begin Self.Address := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7Address_R(Self: TIdHL7; var T: String);
begin T := Self.Address; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7OnReceiveMessage_W(Self: TIdHL7; const T: TMessageReceiveEvent);
begin Self.OnReceiveMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7OnReceiveMessage_R(Self: TIdHL7; var T: TMessageReceiveEvent);
begin T := Self.OnReceiveMessage; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7OnMessageArrive_W(Self: TIdHL7; const T: TMessageArriveEvent);
begin Self.OnMessageArrive := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7OnMessageArrive_R(Self: TIdHL7; var T: TMessageArriveEvent);
begin T := Self.OnMessageArrive; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7IsServer_R(Self: TIdHL7; var T: Boolean);
begin T := Self.IsServer; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7StatusDesc_R(Self: TIdHL7; var T: String);
begin T := Self.StatusDesc; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7Status_R(Self: TIdHL7; var T: TIdHL7Status);
begin T := Self.Status; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7ObjTag_W(Self: TIdHL7; const T: TObject);
begin Self.ObjTag := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHL7ObjTag_R(Self: TIdHL7; var T: TObject);
begin T := Self.ObjTag; end;

(*----------------------------------------------------------------------------*)
procedure EHL7CommunicationErrorInterfaceName_R(Self: EHL7CommunicationError; var T: String);
begin T := Self.InterfaceName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHL7(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHL7) do begin
    RegisterConstructor(@TIdHL7.Create, 'Create');
     RegisterMethod(@TIdHL7.Destroy, 'Free');
    RegisterMethod(@TIdHL7.EnforceWaitReplyTimeout, 'EnforceWaitReplyTimeout');
    RegisterMethod(@TIdHL7.Going, 'Going');
    RegisterPropertyHelper(@TIdHL7ObjTag_R,@TIdHL7ObjTag_W,'ObjTag');
    RegisterPropertyHelper(@TIdHL7Status_R,nil,'Status');
    RegisterPropertyHelper(@TIdHL7StatusDesc_R,nil,'StatusDesc');
    RegisterMethod(@TIdHL7.Connected, 'Connected');
    RegisterPropertyHelper(@TIdHL7IsServer_R,nil,'IsServer');
    RegisterMethod(@TIdHL7.Start, 'Start');
    RegisterMethod(@TIdHL7.PreStop, 'PreStop');
    RegisterMethod(@TIdHL7.Stop, 'Stop');
    RegisterMethod(@TIdHL7.WaitForConnection, 'WaitForConnection');
    RegisterMethod(@TIdHL7.AsynchronousSend, 'AsynchronousSend');
    RegisterPropertyHelper(@TIdHL7OnMessageArrive_R,@TIdHL7OnMessageArrive_W,'OnMessageArrive');
    RegisterMethod(@TIdHL7.SynchronousSend, 'SynchronousSend');
    RegisterPropertyHelper(@TIdHL7OnReceiveMessage_R,@TIdHL7OnReceiveMessage_W,'OnReceiveMessage');
    RegisterMethod(@TIdHL7.CheckSynchronousSendResult, 'CheckSynchronousSendResult');
    RegisterMethod(@TIdHL7.SendMessage, 'SendMessage');
    RegisterMethod(@TIdHL7.GetReply, 'GetReply');
    RegisterMethod(@TIdHL7.GetMessage, 'GetMessage');
    RegisterMethod(@TIdHL7.SendReply, 'SendReply');
    RegisterPropertyHelper(@TIdHL7Address_R,@TIdHL7Address_W,'Address');
    RegisterPropertyHelper(@TIdHL7Port_R,@TIdHL7Port_W,'Port');
    RegisterPropertyHelper(@TIdHL7TimeOut_R,@TIdHL7TimeOut_W,'TimeOut');
    RegisterPropertyHelper(@TIdHL7ReceiveTimeout_R,@TIdHL7ReceiveTimeout_W,'ReceiveTimeout');
    RegisterPropertyHelper(@TIdHL7ConnectionLimit_R,@TIdHL7ConnectionLimit_W,'ConnectionLimit');
    RegisterPropertyHelper(@TIdHL7IPRestriction_R,@TIdHL7IPRestriction_W,'IPRestriction');
    RegisterPropertyHelper(@TIdHL7IPMask_R,@TIdHL7IPMask_W,'IPMask');
    RegisterPropertyHelper(@TIdHL7ReconnectDelay_R,@TIdHL7ReconnectDelay_W,'ReconnectDelay');
    RegisterPropertyHelper(@TIdHL7CommunicationMode_R,@TIdHL7CommunicationMode_W,'CommunicationMode');
    RegisterPropertyHelper(@TIdHL7IsListener_R,@TIdHL7IsListener_W,'IsListener');
    RegisterPropertyHelper(@TIdHL7OnConnect_R,@TIdHL7OnConnect_W,'OnConnect');
    RegisterPropertyHelper(@TIdHL7OnDisconnect_R,@TIdHL7OnDisconnect_W,'OnDisconnect');
    RegisterPropertyHelper(@TIdHL7OnConnCountChange_R,@TIdHL7OnConnCountChange_W,'OnConnCountChange');
    RegisterPropertyHelper(@TIdHL7OnReceiveError_R,@TIdHL7OnReceiveError_W,'OnReceiveError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHL7ClientThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHL7ClientThread) do
  begin
    RegisterConstructor(@TIdHL7ClientThread.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHL7PeerThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHL7PeerThread) do
  begin
    RegisterConstructor(@TIdHL7PeerThread.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EHL7CommunicationError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EHL7CommunicationError) do
  begin
    RegisterConstructor(@EHL7CommunicationError.Create, 'Create');
    RegisterPropertyHelper(@EHL7CommunicationErrorInterfaceName_R,nil,'InterfaceName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdHL7(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EHL7CommunicationError(CL);
  with CL.Add(TIdHL7) do
  RIRegister_TIdHL7PeerThread(CL);
  RIRegister_TIdHL7ClientThread(CL);
  RIRegister_TIdHL7(CL);
end;

 
 
{ TPSImport_IdHL7 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdHL7.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdHL7(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdHL7.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdHL7(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
