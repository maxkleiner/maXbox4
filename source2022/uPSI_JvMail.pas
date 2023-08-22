unit uPSI_JvMail;
{
   mmail
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
  TPSImport_JvMail = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvMail(CL: TPSPascalCompiler);
procedure SIRegister_TJvMailRecipients(CL: TPSPascalCompiler);
procedure SIRegister_TJvMailRecipient(CL: TPSPascalCompiler);
procedure SIRegister_JvMail(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvMail(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvMailRecipients(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvMailRecipient(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvMail(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Forms
  ,Mapi
  ,JclBase
  ,JclMapi
  ,JvComponent
  ,JvMail
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvMail]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMail(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvMail') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvMail') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Address( const Caption : string; EditFields : Integer) : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function ErrorCheck( Res : DWORD) : DWORD');
    RegisterMethod('Function FindFirstMail : Boolean');
    RegisterMethod('Function FindNextMail : Boolean');
    RegisterMethod('Procedure FreeSimpleMapi');
    RegisterMethod('Procedure LogOff');
    RegisterMethod('Procedure LogOn');
    RegisterMethod('Procedure ReadMail');
    RegisterMethod('Function ResolveName( const Name : string) : string');
    RegisterMethod('Function SaveMail( const MessageID : string) : string');
    RegisterMethod('Procedure SendMail( ShowDialog : Boolean)');
    RegisterProperty('ReadedMail', 'TJvMailReadedData', iptr);
    RegisterProperty('SeedMessageID', 'string', iptrw);
    RegisterProperty('SessionHandle', 'THandle', iptr);
    RegisterProperty('SimpleMAPI', 'TJclSimpleMapi', iptr);
    RegisterProperty('UserLogged', 'Boolean', iptr);
    RegisterProperty('Attachment', 'TStrings', iptrw);
    RegisterProperty('BlindCopy', 'TJvMailRecipients', iptrw);
    RegisterProperty('Body', 'TStrings', iptrw);
    RegisterProperty('CarbonCopy', 'TJvMailRecipients', iptrw);
    RegisterProperty('LogonOptions', 'TJvMailLogonOptions', iptrw);
    RegisterProperty('LongMsgId', 'Boolean', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('ProfileName', 'string', iptrw);
    RegisterProperty('ReadOptions', 'TJvMailReadOptions', iptrw);
    RegisterProperty('Recipient', 'TJvMailRecipients', iptrw);
    RegisterProperty('Subject', 'string', iptrw);
    RegisterProperty('OnError', 'TJvMailErrorEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMailRecipients(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TJvMailRecipients') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TJvMailRecipients') do begin
    RegisterMethod('Constructor Create( AOwner : TJvMail; ARecipientClass : DWORD)');
    RegisterMethod('Function Add : TJvMailRecipient');
    RegisterMethod('Function AddRecipient( const Address : string; const Name : string) : Integer');
    RegisterProperty('Items', 'TJvMailRecipient Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('RecipientClass', 'DWORD', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMailRecipient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TJvMailRecipient') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TJvMailRecipient') do begin
    RegisterProperty('AddressAndName', 'string', iptr);
    RegisterProperty('Address', 'string', iptrw);
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Valid', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvMail(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvMail');
  SIRegister_TJvMailRecipient(CL);
  SIRegister_TJvMailRecipients(CL);
  CL.AddTypeS('TJvMailLogonOptions', '( loLogonUI, loNewSession )');
  CL.AddTypeS('TJvMailReadOptions', '( roUnreadOnly, roFifo, roPeek, roHeaderOnly, roAttachments )');
  CL.AddTypeS('TJvMailReadedData', 'record RecipientAddress : string; Recipient'
   +'Name : string; ConversationID : string; DateReceived : TDateTime; end');
  CL.AddTypeS('TJvMailErrorEvent', 'Procedure ( Sender : TJvMail; ErrorCode : ULONG)');
  SIRegister_TJvMail(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvMailOnError_W(Self: TJvMail; const T: TJvMailErrorEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailOnError_R(Self: TJvMail; var T: TJvMailErrorEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSubject_W(Self: TJvMail; const T: string);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSubject_R(Self: TJvMail; var T: string);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailRecipient_W(Self: TJvMail; const T: TJvMailRecipients);
begin Self.Recipient := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailRecipient_R(Self: TJvMail; var T: TJvMailRecipients);
begin T := Self.Recipient; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailReadOptions_W(Self: TJvMail; const T: TJvMailReadOptions);
begin Self.ReadOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailReadOptions_R(Self: TJvMail; var T: TJvMailReadOptions);
begin T := Self.ReadOptions; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailProfileName_W(Self: TJvMail; const T: string);
begin Self.ProfileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailProfileName_R(Self: TJvMail; var T: string);
begin T := Self.ProfileName; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailPassword_W(Self: TJvMail; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailPassword_R(Self: TJvMail; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailLongMsgId_W(Self: TJvMail; const T: Boolean);
begin Self.LongMsgId := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailLongMsgId_R(Self: TJvMail; var T: Boolean);
begin T := Self.LongMsgId; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailLogonOptions_W(Self: TJvMail; const T: TJvMailLogonOptions);
begin Self.LogonOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailLogonOptions_R(Self: TJvMail; var T: TJvMailLogonOptions);
begin T := Self.LogonOptions; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailCarbonCopy_W(Self: TJvMail; const T: TJvMailRecipients);
begin Self.CarbonCopy := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailCarbonCopy_R(Self: TJvMail; var T: TJvMailRecipients);
begin T := Self.CarbonCopy; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailBody_W(Self: TJvMail; const T: TStrings);
begin Self.Body := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailBody_R(Self: TJvMail; var T: TStrings);
begin T := Self.Body; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailBlindCopy_W(Self: TJvMail; const T: TJvMailRecipients);
begin Self.BlindCopy := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailBlindCopy_R(Self: TJvMail; var T: TJvMailRecipients);
begin T := Self.BlindCopy; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailAttachment_W(Self: TJvMail; const T: TStrings);
begin Self.Attachment := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailAttachment_R(Self: TJvMail; var T: TStrings);
begin T := Self.Attachment; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailUserLogged_R(Self: TJvMail; var T: Boolean);
begin T := Self.UserLogged; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSimpleMAPI_R(Self: TJvMail; var T: TJclSimpleMapi);
begin T := Self.SimpleMAPI; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSessionHandle_R(Self: TJvMail; var T: THandle);
begin T := Self.SessionHandle; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSeedMessageID_W(Self: TJvMail; const T: string);
begin Self.SeedMessageID := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailSeedMessageID_R(Self: TJvMail; var T: string);
begin T := Self.SeedMessageID; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailReadedMail_R(Self: TJvMail; var T: TJvMailReadedData);
begin T := Self.ReadedMail; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailRecipientsRecipientClass_R(Self: TJvMailRecipients; var T: DWORD);
begin T := Self.RecipientClass; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailRecipientsItems_W(Self: TJvMailRecipients; const T: TJvMailRecipient; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailRecipientsItems_R(Self: TJvMailRecipients; var T: TJvMailRecipient; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailRecipientValid_R(Self: TJvMailRecipient; var T: Boolean);
begin T := Self.Valid; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailRecipientName_W(Self: TJvMailRecipient; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailRecipientName_R(Self: TJvMailRecipient; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailRecipientAddress_W(Self: TJvMailRecipient; const T: string);
begin Self.Address := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailRecipientAddress_R(Self: TJvMailRecipient; var T: string);
begin T := Self.Address; end;

(*----------------------------------------------------------------------------*)
procedure TJvMailRecipientAddressAndName_R(Self: TJvMailRecipient; var T: string);
begin T := Self.AddressAndName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMail(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMail) do begin
    RegisterConstructor(@TJvMail.Create, 'Create');
   RegisterMethod(@TJvMail.Destroy, 'Free');
     RegisterMethod(@TJvMail.Address, 'Address');
    RegisterMethod(@TJvMail.Clear, 'Clear');
    RegisterMethod(@TJvMail.ErrorCheck, 'ErrorCheck');
    RegisterMethod(@TJvMail.FindFirstMail, 'FindFirstMail');
    RegisterMethod(@TJvMail.FindNextMail, 'FindNextMail');
    RegisterMethod(@TJvMail.FreeSimpleMapi, 'FreeSimpleMapi');
    RegisterMethod(@TJvMail.LogOff, 'LogOff');
    RegisterMethod(@TJvMail.LogOn, 'LogOn');
    RegisterMethod(@TJvMail.ReadMail, 'ReadMail');
    RegisterMethod(@TJvMail.ResolveName, 'ResolveName');
    RegisterMethod(@TJvMail.SaveMail, 'SaveMail');
    RegisterMethod(@TJvMail.SendMail, 'SendMail');
    RegisterPropertyHelper(@TJvMailReadedMail_R,nil,'ReadedMail');
    RegisterPropertyHelper(@TJvMailSeedMessageID_R,@TJvMailSeedMessageID_W,'SeedMessageID');
    RegisterPropertyHelper(@TJvMailSessionHandle_R,nil,'SessionHandle');
    RegisterPropertyHelper(@TJvMailSimpleMAPI_R,nil,'SimpleMAPI');
    RegisterPropertyHelper(@TJvMailUserLogged_R,nil,'UserLogged');
    RegisterPropertyHelper(@TJvMailAttachment_R,@TJvMailAttachment_W,'Attachment');
    RegisterPropertyHelper(@TJvMailBlindCopy_R,@TJvMailBlindCopy_W,'BlindCopy');
    RegisterPropertyHelper(@TJvMailBody_R,@TJvMailBody_W,'Body');
    RegisterPropertyHelper(@TJvMailCarbonCopy_R,@TJvMailCarbonCopy_W,'CarbonCopy');
    RegisterPropertyHelper(@TJvMailLogonOptions_R,@TJvMailLogonOptions_W,'LogonOptions');
    RegisterPropertyHelper(@TJvMailLongMsgId_R,@TJvMailLongMsgId_W,'LongMsgId');
    RegisterPropertyHelper(@TJvMailPassword_R,@TJvMailPassword_W,'Password');
    RegisterPropertyHelper(@TJvMailProfileName_R,@TJvMailProfileName_W,'ProfileName');
    RegisterPropertyHelper(@TJvMailReadOptions_R,@TJvMailReadOptions_W,'ReadOptions');
    RegisterPropertyHelper(@TJvMailRecipient_R,@TJvMailRecipient_W,'Recipient');
    RegisterPropertyHelper(@TJvMailSubject_R,@TJvMailSubject_W,'Subject');
    RegisterPropertyHelper(@TJvMailOnError_R,@TJvMailOnError_W,'OnError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMailRecipients(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMailRecipients) do begin
    RegisterConstructor(@TJvMailRecipients.Create, 'Create');
    RegisterMethod(@TJvMailRecipients.Add, 'Add');
    RegisterMethod(@TJvMailRecipients.AddRecipient, 'AddRecipient');
    RegisterPropertyHelper(@TJvMailRecipientsItems_R,@TJvMailRecipientsItems_W,'Items');
    RegisterPropertyHelper(@TJvMailRecipientsRecipientClass_R,nil,'RecipientClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMailRecipient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMailRecipient) do begin
    RegisterPropertyHelper(@TJvMailRecipientAddressAndName_R,nil,'AddressAndName');
    RegisterPropertyHelper(@TJvMailRecipientAddress_R,@TJvMailRecipientAddress_W,'Address');
    RegisterPropertyHelper(@TJvMailRecipientName_R,@TJvMailRecipientName_W,'Name');
    RegisterPropertyHelper(@TJvMailRecipientValid_R,nil,'Valid');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvMail(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMail) do
  RIRegister_TJvMailRecipient(CL);
  RIRegister_TJvMailRecipients(CL);
  RIRegister_TJvMail(CL);
end;

 
 
{ TPSImport_JvMail }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvMail.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvMail(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvMail.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvMail(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
