unit uPSI_JsSendMail;
{
   from js in heaven
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
  TPSImport_JsSendMail = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJsMapiMail(CL: TPSPascalCompiler);
procedure SIRegister_JsSendMail(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJsMapiMail(CL: TPSRuntimeClassImporter);
procedure RIRegister_JsSendMail(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Mapi
  ,Variants
  ,ComObj
  ,Dialogs
  ,JsSendMail
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JsSendMail]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsMapiMail(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJsMapiMail') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJsMapiMail') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function Connected : Boolean');
    RegisterMethod('Function Connect : Boolean');
    RegisterMethod('Function Disconnect : Boolean');
    RegisterMethod('Function IsSimpleMapiInstalled : Boolean');
    RegisterMethod('Function IsExtendedMapiInstalled : Boolean');
    RegisterMethod('Function GetStandardEMailClient : string');
    RegisterMethod('Function GetMapiParentWnd : Cardinal');
    RegisterMethod('Function GetErrorCode : Cardinal');
    RegisterMethod('Function GetErrorMessage( iErrorCode : Cardinal) : string');
    RegisterMethod('Procedure SetRecipientsStr( aRecipients : TStrings; Value : String)');
    RegisterMethod('Function SendMail : Boolean');
    RegisterMethod('Function SendMailWithOle : Boolean');
    RegisterProperty('SenderName', 'string', iptrw);
    RegisterProperty('SenderAddress', 'string', iptrw);
    RegisterProperty('Subject', 'string', iptrw);
    RegisterProperty('Body', 'string', iptrw);
    RegisterProperty('Recipients', 'TStrings', iptrw);
    RegisterProperty('CCRecipients', 'TStrings', iptrw);
    RegisterProperty('BCCRecipients', 'TStrings', iptrw);
    RegisterProperty('Attachments', 'TStrings', iptrw);
    RegisterProperty('EditDialog', 'Boolean', iptrw);
    RegisterProperty('ResolveNames', 'Boolean', iptrw);
    RegisterProperty('RequestReceipt', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JsSendMail(CL: TPSPascalCompiler);
begin
  SIRegister_TJsMapiMail(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJsMapiMailRequestReceipt_W(Self: TJsMapiMail; const T: Boolean);
begin Self.RequestReceipt := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailRequestReceipt_R(Self: TJsMapiMail; var T: Boolean);
begin T := Self.RequestReceipt; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailResolveNames_W(Self: TJsMapiMail; const T: Boolean);
begin Self.ResolveNames := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailResolveNames_R(Self: TJsMapiMail; var T: Boolean);
begin T := Self.ResolveNames; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailEditDialog_W(Self: TJsMapiMail; const T: Boolean);
begin Self.EditDialog := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailEditDialog_R(Self: TJsMapiMail; var T: Boolean);
begin T := Self.EditDialog; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailAttachments_W(Self: TJsMapiMail; const T: TStrings);
begin Self.Attachments := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailAttachments_R(Self: TJsMapiMail; var T: TStrings);
begin T := Self.Attachments; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailBCCRecipients_W(Self: TJsMapiMail; const T: TStrings);
begin Self.BCCRecipients := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailBCCRecipients_R(Self: TJsMapiMail; var T: TStrings);
begin T := Self.BCCRecipients; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailCCRecipients_W(Self: TJsMapiMail; const T: TStrings);
begin Self.CCRecipients := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailCCRecipients_R(Self: TJsMapiMail; var T: TStrings);
begin T := Self.CCRecipients; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailRecipients_W(Self: TJsMapiMail; const T: TStrings);
begin Self.Recipients := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailRecipients_R(Self: TJsMapiMail; var T: TStrings);
begin T := Self.Recipients; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailBody_W(Self: TJsMapiMail; const T: string);
begin Self.Body := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailBody_R(Self: TJsMapiMail; var T: string);
begin T := Self.Body; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailSubject_W(Self: TJsMapiMail; const T: string);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailSubject_R(Self: TJsMapiMail; var T: string);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailSenderAddress_W(Self: TJsMapiMail; const T: string);
begin Self.SenderAddress := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailSenderAddress_R(Self: TJsMapiMail; var T: string);
begin T := Self.SenderAddress; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailSenderName_W(Self: TJsMapiMail; const T: string);
begin Self.SenderName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsMapiMailSenderName_R(Self: TJsMapiMail; var T: string);
begin T := Self.SenderName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsMapiMail(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsMapiMail) do begin
    RegisterConstructor(@TJsMapiMail.Create, 'Create');
             RegisterMethod(@TJsMapiMail.Destroy, 'Free');
    RegisterMethod(@TJsMapiMail.Connected, 'Connected');
    RegisterMethod(@TJsMapiMail.Connect, 'Connect');
    RegisterMethod(@TJsMapiMail.Disconnect, 'Disconnect');
    RegisterMethod(@TJsMapiMail.IsSimpleMapiInstalled, 'IsSimpleMapiInstalled');
    RegisterMethod(@TJsMapiMail.IsExtendedMapiInstalled, 'IsExtendedMapiInstalled');
    RegisterMethod(@TJsMapiMail.GetStandardEMailClient, 'GetStandardEMailClient');
    RegisterMethod(@TJsMapiMail.GetMapiParentWnd, 'GetMapiParentWnd');
    RegisterMethod(@TJsMapiMail.GetErrorCode, 'GetErrorCode');
    RegisterMethod(@TJsMapiMail.GetErrorMessage, 'GetErrorMessage');
    RegisterMethod(@TJsMapiMail.SetRecipientsStr, 'SetRecipientsStr');
    RegisterMethod(@TJsMapiMail.SendMail, 'SendMail');
    RegisterMethod(@TJsMapiMail.SendMailWithOle, 'SendMailWithOle');
    RegisterPropertyHelper(@TJsMapiMailSenderName_R,@TJsMapiMailSenderName_W,'SenderName');
    RegisterPropertyHelper(@TJsMapiMailSenderAddress_R,@TJsMapiMailSenderAddress_W,'SenderAddress');
    RegisterPropertyHelper(@TJsMapiMailSubject_R,@TJsMapiMailSubject_W,'Subject');
    RegisterPropertyHelper(@TJsMapiMailBody_R,@TJsMapiMailBody_W,'Body');
    RegisterPropertyHelper(@TJsMapiMailRecipients_R,@TJsMapiMailRecipients_W,'Recipients');
    RegisterPropertyHelper(@TJsMapiMailCCRecipients_R,@TJsMapiMailCCRecipients_W,'CCRecipients');
    RegisterPropertyHelper(@TJsMapiMailBCCRecipients_R,@TJsMapiMailBCCRecipients_W,'BCCRecipients');
    RegisterPropertyHelper(@TJsMapiMailAttachments_R,@TJsMapiMailAttachments_W,'Attachments');
    RegisterPropertyHelper(@TJsMapiMailEditDialog_R,@TJsMapiMailEditDialog_W,'EditDialog');
    RegisterPropertyHelper(@TJsMapiMailResolveNames_R,@TJsMapiMailResolveNames_W,'ResolveNames');
    RegisterPropertyHelper(@TJsMapiMailRequestReceipt_R,@TJsMapiMailRequestReceipt_W,'RequestReceipt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JsSendMail(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJsMapiMail(CL);
end;

 
 
{ TPSImport_JsSendMail }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JsSendMail.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JsSendMail(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JsSendMail.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JsSendMail(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
