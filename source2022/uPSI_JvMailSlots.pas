unit uPSI_JvMailSlots;
{
   also server
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
  TPSImport_JvMailSlots = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TJvMailSlotClient(CL: TPSPascalCompiler);
procedure SIRegister_TJvMailSlotServer(CL: TPSPascalCompiler);
procedure SIRegister_JvMailSlots(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvMailSlotClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvMailSlotServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvMailSlots(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  //,Messages
  //,Graphics
  Controls
  //,Forms
  //,Dialogs
  //U/,ExtCtrls
  ,JvComponentBase
  ,JvMailSlots
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvMailSlots]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMailSlotClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvMailSlotClient') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvMailSlotClient') do begin
    RegisterMethod('Function Send( const Msg : string) : Boolean;');
    RegisterMethod('Function Send1( const MessageData, MessageLength : LongWord) : Boolean;');
    RegisterProperty('ServerName', 'string', iptrw);
    RegisterProperty('MailSlotName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMailSlotServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvMailSlotServer') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvMailSlotServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure Close');
    RegisterProperty('MessageData', 'Pointer', iptr);
    RegisterProperty('MessageLength', 'LongWord', iptr);
    RegisterProperty('MailSlotName', 'string', iptrw);
    RegisterProperty('DeliveryCheckInterval', 'Integer', iptrw);
    RegisterProperty('OnNewMessage', 'TOnNewMessage', iptrw);
    RegisterProperty('OnError', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvMailSlots(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOnNewMessage', 'Procedure ( Sender : TObject; MessageText : string)');
  SIRegister_TJvMailSlotServer(CL);
  SIRegister_TJvMailSlotClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvMailSlotClientMailSlotName_W(Self: TJvMailSlotClient; const T: string);
begin Self.MailSlotName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotClientMailSlotName_R(Self: TJvMailSlotClient; var T: string);
begin T := Self.MailSlotName; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotClientServerName_W(Self: TJvMailSlotClient; const T: string);
begin Self.ServerName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotClientServerName_R(Self: TJvMailSlotClient; var T: string);
begin T := Self.ServerName; end;

(*----------------------------------------------------------------------------*)
Function TJvMailSlotClientSend1_P(Self: TJvMailSlotClient;  const MessageData, MessageLength : LongWord) : Boolean;
Begin Result := Self.Send(MessageData, MessageLength); END;

(*----------------------------------------------------------------------------*)
Function TJvMailSlotClientSend_P(Self: TJvMailSlotClient;  const Msg : string) : Boolean;
Begin Result := Self.Send(Msg); END;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotServerOnError_W(Self: TJvMailSlotServer; const T: TNotifyEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotServerOnError_R(Self: TJvMailSlotServer; var T: TNotifyEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotServerOnNewMessage_W(Self: TJvMailSlotServer; const T: TOnNewMessage);
begin Self.OnNewMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotServerOnNewMessage_R(Self: TJvMailSlotServer; var T: TOnNewMessage);
begin T := Self.OnNewMessage; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotServerDeliveryCheckInterval_W(Self: TJvMailSlotServer; const T: Integer);
begin Self.DeliveryCheckInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotServerDeliveryCheckInterval_R(Self: TJvMailSlotServer; var T: Integer);
begin T := Self.DeliveryCheckInterval; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotServerMailSlotName_W(Self: TJvMailSlotServer; const T: string);
begin Self.MailSlotName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotServerMailSlotName_R(Self: TJvMailSlotServer; var T: string);
begin T := Self.MailSlotName; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotServerMessageLength_R(Self: TJvMailSlotServer; var T: LongWord);
begin T := Self.MessageLength; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSlotServerMessageData_R(Self: TJvMailSlotServer; var T: Pointer);
begin T := Self.MessageData; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMailSlotClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMailSlotClient) do begin
    RegisterMethod(@TJvMailSlotClientSend_P, 'Send');
    RegisterMethod(@TJvMailSlotClientSend1_P, 'Send1');
    RegisterPropertyHelper(@TJvMailSlotClientServerName_R,@TJvMailSlotClientServerName_W,'ServerName');
    RegisterPropertyHelper(@TJvMailSlotClientMailSlotName_R,@TJvMailSlotClientMailSlotName_W,'MailSlotName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMailSlotServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMailSlotServer) do begin
    RegisterConstructor(@TJvMailSlotServer.Create, 'Create');
    RegisterMethod(@TJvMailSlotServer.Open, 'Open');
    RegisterMethod(@TJvMailSlotServer.Close, 'Close');
   RegisterVirtualMethod(@TJvMailSlotServer.Free, 'Free');
    RegisterPropertyHelper(@TJvMailSlotServerMessageData_R,nil,'MessageData');
    RegisterPropertyHelper(@TJvMailSlotServerMessageLength_R,nil,'MessageLength');
    RegisterPropertyHelper(@TJvMailSlotServerMailSlotName_R,@TJvMailSlotServerMailSlotName_W,'MailSlotName');
    RegisterPropertyHelper(@TJvMailSlotServerDeliveryCheckInterval_R,@TJvMailSlotServerDeliveryCheckInterval_W,'DeliveryCheckInterval');
    RegisterPropertyHelper(@TJvMailSlotServerOnNewMessage_R,@TJvMailSlotServerOnNewMessage_W,'OnNewMessage');
    RegisterPropertyHelper(@TJvMailSlotServerOnError_R,@TJvMailSlotServerOnError_W,'OnError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvMailSlots(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvMailSlotServer(CL);
  RIRegister_TJvMailSlotClient(CL);
end;

 
 
{ TPSImport_JvMailSlots }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvMailSlots.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvMailSlots(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvMailSlots.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvMailSlots(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
