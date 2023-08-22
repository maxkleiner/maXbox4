unit uPSI_JclMapi;
{
   for mail and simple mail
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
  TPSImport_JclMapi = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclEmail(CL: TPSPascalCompiler);
procedure SIRegister_TJclEmailRecips(CL: TPSPascalCompiler);
procedure SIRegister_TJclEmailRecip(CL: TPSPascalCompiler);
procedure SIRegister_TJclSimpleMapi(CL: TPSPascalCompiler);
procedure SIRegister_EJclMapiError(CL: TPSPascalCompiler);
procedure SIRegister_JclMapi(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclMapi_Routines(S: TPSExec);
procedure RIRegister_TJclEmail(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclEmailRecips(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclEmailRecip(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSimpleMapi(CL: TPSRuntimeClassImporter);
procedure RIRegister_EJclMapiError(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclMapi(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Mapi
  ,Contnrs
  ,JclBase
  ,JclMapi
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclMapi]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclEmail(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSimpleMapi', 'TJclEmail') do
  with CL.AddClassN(CL.FindClass('TJclSimpleMapi'),'TJclEmail') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function Address( const Caption : string; EditFields : Integer) : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Delete( const MessageID : string) : Boolean');
    RegisterMethod('Function FindFirstMessage : Boolean');
    RegisterMethod('Function FindNextMessage : Boolean');
    RegisterMethod('Procedure LogOff');
    RegisterMethod('Procedure LogOn( const ProfileName : string; const Password : string)');
    RegisterMethod('Function MessageReport( Strings : TStrings; MaxWidth : Integer; IncludeAddresses : Boolean) : Integer');
    RegisterMethod('Function Read( const Options : TJclEmailReadOptions) : Boolean');
    RegisterMethod('Function ResolveName( var Name, Address : string; ShowDialog : Boolean) : Boolean');
    RegisterMethod('Procedure RestoreTaskWindows');
    RegisterMethod('Function Save : Boolean');
    RegisterMethod('Procedure SaveTaskWindows');
    RegisterMethod('Function Send( ShowDialog : Boolean) : Boolean');
    RegisterMethod('Procedure SortAttachments');
    RegisterProperty('Attachments', 'TStrings', iptr);
    RegisterProperty('Body', 'string', iptrw);
    RegisterProperty('FindOptions', 'TJclEmailFindOptions', iptrw);
    RegisterProperty('HtmlBody', 'Boolean', iptrw);
    RegisterProperty('LogonOptions', 'TJclEmailLogonOptions', iptrw);
    RegisterProperty('ParentWnd', 'HWND', iptrw);
    RegisterProperty('ReadMsg', 'TJclEmailReadMsg', iptr);
    RegisterProperty('Recipients', 'TJclEmailRecips', iptr);
    RegisterProperty('SeedMessageID', 'string', iptrw);
    RegisterProperty('SessionHandle', 'THandle', iptr);
    RegisterProperty('Subject', 'string', iptrw);
    RegisterProperty('UserLogged', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclEmailRecips(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TJclEmailRecips') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TJclEmailRecips') do begin
    RegisterMethod('Function Add( const Address : string; const Name : string; const Kind : TJclEmailRecipKind; const AddressType : string) : Integer');
    RegisterMethod('Procedure SortRecips');
    RegisterProperty('AddressesType', 'string', iptrw);
    RegisterProperty('Items', 'TJclEmailRecip Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('Originator', 'TJclEmailRecip', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclEmailRecip(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclEmailRecip') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclEmailRecip') do begin
    RegisterMethod('Function AddressAndName : string');
    RegisterMethod('Function RecipKindToString( const AKind : TJclEmailRecipKind) : string');
    RegisterProperty('AddressType', 'string', iptrw);
    RegisterProperty('Address', 'string', iptrw);
    RegisterProperty('Kind', 'TJclEmailRecipKind', iptrw);
    RegisterProperty('Name', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleMapi(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSimpleMapi') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSimpleMapi') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function ClientLibLoaded : Boolean');
    RegisterMethod('Procedure LoadClientLib');
    RegisterMethod('Procedure UnloadClientLib');
    RegisterProperty('AnyClientInstalled', 'Boolean', iptr);
    RegisterProperty('ClientConnectKind', 'TJclMapiClientConnect', iptrw);
    RegisterProperty('ClientCount', 'Integer', iptr);
    RegisterProperty('Clients', 'TJclMapiClient Integer', iptr);
    SetDefaultPropery('Clients');
    RegisterProperty('CurrentClientName', 'string', iptr);
    RegisterProperty('DefaultClientIndex', 'Integer', iptr);
    RegisterProperty('DefaultProfileName', 'string', iptr);
    RegisterProperty('MapiInstalled', 'Boolean', iptr);
    RegisterProperty('MapiVersion', 'string', iptr);
    RegisterProperty('ProfileCount', 'Integer', iptr);
    RegisterProperty('Profiles', 'string Integer', iptr);
    RegisterProperty('SelectedClientIndex', 'Integer', iptrw);
    RegisterProperty('SimpleMapiInstalled', 'Boolean', iptr);
    RegisterProperty('BeforeUnloadClient', 'TNotifyEvent', iptrw);
    RegisterProperty('MapiAddress', 'TFNMapiAddress', iptr);
    RegisterProperty('MapiDeleteMail', 'TFNMapiDeleteMail', iptr);
    RegisterProperty('MapiDetails', 'TFNMapiDetails', iptr);
    RegisterProperty('MapiFindNext', 'TFNMapiFindNext', iptr);
    RegisterProperty('MapiFreeBuffer', 'TFNMapiFreeBuffer', iptr);
    RegisterProperty('MapiLogOff', 'TFNMapiLogOff', iptr);
    RegisterProperty('MapiLogOn', 'TFNMapiLogOn', iptr);
    RegisterProperty('MapiReadMail', 'TFNMapiReadMail', iptr);
    RegisterProperty('MapiResolveName', 'TFNMapiResolveName', iptr);
    RegisterProperty('MapiSaveMail', 'TFNMapiSaveMail', iptr);
    RegisterProperty('MapiSendDocuments', 'TFNMapiSendDocuments', iptr);
    RegisterProperty('MapiSendMail', 'TFNMapiSendMail', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EJclMapiError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EJclError', 'EJclMapiError') do
  with CL.AddClassN(CL.FindClass('EJclError'),'EJclMapiError') do begin
    RegisterProperty('ErrorCode', 'DWORD', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclMapi(CL: TPSPascalCompiler);
begin
  SIRegister_EJclMapiError(CL);
  CL.AddTypeS('TJclMapiClient', 'record ClientName : string; ClientPath : strin'
   +'g; RegKeyName : string; Valid : Boolean; end');
  CL.AddTypeS('TJclMapiClientConnect', '( ctAutomatic, ctMapi, ctDirect )');
  SIRegister_TJclSimpleMapi(CL);
 CL.AddConstantN('MapiAddressTypeSMTP','String').SetString( 'SMTP');
 CL.AddConstantN('MapiAddressTypeFAX','String').SetString( 'FAX');
  CL.AddTypeS('TJclEmailRecipKind', '( rkOriginator, rkTO, rkCC, rkBCC )');
  SIRegister_TJclEmailRecip(CL);
  SIRegister_TJclEmailRecips(CL);
  CL.AddTypeS('FLAGS', 'Cardinal');

  //type {$EXTERNALSYM FLAGS} FLAGS = Cardinal;

  CL.AddTypeS('TJclEmailFindOption', '( foFifo, foUnreadOnly )');
  CL.AddTypeS('TJclEmailLogonOption', '( loLogonUI, loNewSession, loForceDownload )');
  CL.AddTypeS('TJclEmailReadOption', '( roAttachments, roHeaderOnly, roMarkAsRead )');
  CL.AddTypeS('TJclEmailFindOptions', 'set of TJclEmailFindOption');
  CL.AddTypeS('TJclEmailLogonOptions', 'set of TJclEmailLogonOption');
  CL.AddTypeS('TJclEmailReadOptions', 'set of TJclEmailReadOption');
  CL.AddTypeS('TJclEmailReadMsg', 'record ConversationID : string; DateReceived'
   +' : TDateTime; MessageType : string; Flags : FLAGS; end');
  CL.AddTypeS('TJclTaskWindowsList', 'array of HWND');
  SIRegister_TJclEmail(CL);
 CL.AddDelphiFunction('Function JclSimpleSendMail( const ARecipient, AName, ASubject, ABody : string; const AAttachment : TFileName; ShowDialog : Boolean; AParentWND : HWND) : Boolean');
 CL.AddDelphiFunction('Function JclSimpleSendFax( const ARecipient, AName, ASubject, ABody : string; const AAttachment : TFileName; ShowDialog : Boolean; AParentWND : HWND) : Boolean');
 CL.AddDelphiFunction('Function JclSimpleBringUpSendMailDialog( const ASubject, ABody : string; const AAttachment : TFileName; AParentWND : HWND) : Boolean');
 CL.AddDelphiFunction('Function MapiCheck( const Res : DWORD; IgnoreUserAbort : Boolean) : DWORD');
 CL.AddDelphiFunction('Function MapiErrorMessage( const ErrorCode : DWORD) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclEmailUserLogged_R(Self: TJclEmail; var T: Boolean);
begin T := Self.UserLogged; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailSubject_W(Self: TJclEmail; const T: string);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailSubject_R(Self: TJclEmail; var T: string);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailSessionHandle_R(Self: TJclEmail; var T: THandle);
begin T := Self.SessionHandle; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailSeedMessageID_W(Self: TJclEmail; const T: string);
begin Self.SeedMessageID := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailSeedMessageID_R(Self: TJclEmail; var T: string);
begin T := Self.SeedMessageID; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipients_R(Self: TJclEmail; var T: TJclEmailRecips);
begin T := Self.Recipients; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailReadMsg_R(Self: TJclEmail; var T: TJclEmailReadMsg);
begin T := Self.ReadMsg; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailParentWnd_W(Self: TJclEmail; const T: HWND);
begin Self.ParentWnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailParentWnd_R(Self: TJclEmail; var T: HWND);
begin T := Self.ParentWnd; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailLogonOptions_W(Self: TJclEmail; const T: TJclEmailLogonOptions);
begin Self.LogonOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailLogonOptions_R(Self: TJclEmail; var T: TJclEmailLogonOptions);
begin T := Self.LogonOptions; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailHtmlBody_W(Self: TJclEmail; const T: Boolean);
begin Self.HtmlBody := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailHtmlBody_R(Self: TJclEmail; var T: Boolean);
begin T := Self.HtmlBody; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailFindOptions_W(Self: TJclEmail; const T: TJclEmailFindOptions);
begin Self.FindOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailFindOptions_R(Self: TJclEmail; var T: TJclEmailFindOptions);
begin T := Self.FindOptions; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailBody_W(Self: TJclEmail; const T: string);
begin Self.Body := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailBody_R(Self: TJclEmail; var T: string);
begin T := Self.Body; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailAttachments_R(Self: TJclEmail; var T: TStrings);
begin T := Self.Attachments; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipsOriginator_R(Self: TJclEmailRecips; var T: TJclEmailRecip);
begin T := Self.Originator; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipsItems_R(Self: TJclEmailRecips; var T: TJclEmailRecip; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipsAddressesType_W(Self: TJclEmailRecips; const T: string);
begin Self.AddressesType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipsAddressesType_R(Self: TJclEmailRecips; var T: string);
begin T := Self.AddressesType; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipName_W(Self: TJclEmailRecip; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipName_R(Self: TJclEmailRecip; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipKind_W(Self: TJclEmailRecip; const T: TJclEmailRecipKind);
begin Self.Kind := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipKind_R(Self: TJclEmailRecip; var T: TJclEmailRecipKind);
begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipAddress_W(Self: TJclEmailRecip; const T: string);
begin Self.Address := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipAddress_R(Self: TJclEmailRecip; var T: string);
begin T := Self.Address; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipAddressType_W(Self: TJclEmailRecip; const T: string);
begin Self.AddressType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEmailRecipAddressType_R(Self: TJclEmailRecip; var T: string);
begin T := Self.AddressType; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiSendMail_R(Self: TJclSimpleMapi; var T: TFNMapiSendMail);
begin T := Self.MapiSendMail; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiSendDocuments_R(Self: TJclSimpleMapi; var T: TFNMapiSendDocuments);
begin T := Self.MapiSendDocuments; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiSaveMail_R(Self: TJclSimpleMapi; var T: TFNMapiSaveMail);
begin T := Self.MapiSaveMail; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiResolveName_R(Self: TJclSimpleMapi; var T: TFNMapiResolveName);
begin T := Self.MapiResolveName; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiReadMail_R(Self: TJclSimpleMapi; var T: TFNMapiReadMail);
begin T := Self.MapiReadMail; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiLogOn_R(Self: TJclSimpleMapi; var T: TFNMapiLogOn);
begin T := Self.MapiLogOn; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiLogOff_R(Self: TJclSimpleMapi; var T: TFNMapiLogOff);
begin T := Self.MapiLogOff; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiFreeBuffer_R(Self: TJclSimpleMapi; var T: TFNMapiFreeBuffer);
begin T := Self.MapiFreeBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiFindNext_R(Self: TJclSimpleMapi; var T: TFNMapiFindNext);
begin T := Self.MapiFindNext; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiDetails_R(Self: TJclSimpleMapi; var T: TFNMapiDetails);
begin T := Self.MapiDetails; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiDeleteMail_R(Self: TJclSimpleMapi; var T: TFNMapiDeleteMail);
begin T := Self.MapiDeleteMail; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiAddress_R(Self: TJclSimpleMapi; var T: TFNMapiAddress);
begin T := Self.MapiAddress; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiBeforeUnloadClient_W(Self: TJclSimpleMapi; const T: TNotifyEvent);
begin Self.BeforeUnloadClient := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiBeforeUnloadClient_R(Self: TJclSimpleMapi; var T: TNotifyEvent);
begin T := Self.BeforeUnloadClient; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiSimpleMapiInstalled_R(Self: TJclSimpleMapi; var T: Boolean);
begin T := Self.SimpleMapiInstalled; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiSelectedClientIndex_W(Self: TJclSimpleMapi; const T: Integer);
begin Self.SelectedClientIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiSelectedClientIndex_R(Self: TJclSimpleMapi; var T: Integer);
begin T := Self.SelectedClientIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiProfiles_R(Self: TJclSimpleMapi; var T: string; const t1: Integer);
begin T := Self.Profiles[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiProfileCount_R(Self: TJclSimpleMapi; var T: Integer);
begin T := Self.ProfileCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiVersion_R(Self: TJclSimpleMapi; var T: string);
begin T := Self.MapiVersion; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiMapiInstalled_R(Self: TJclSimpleMapi; var T: Boolean);
begin T := Self.MapiInstalled; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiDefaultProfileName_R(Self: TJclSimpleMapi; var T: string);
begin T := Self.DefaultProfileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiDefaultClientIndex_R(Self: TJclSimpleMapi; var T: Integer);
begin T := Self.DefaultClientIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiCurrentClientName_R(Self: TJclSimpleMapi; var T: string);
begin T := Self.CurrentClientName; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiClients_R(Self: TJclSimpleMapi; var T: TJclMapiClient; const t1: Integer);
begin T := Self.Clients[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiClientCount_R(Self: TJclSimpleMapi; var T: Integer);
begin T := Self.ClientCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiClientConnectKind_W(Self: TJclSimpleMapi; const T: TJclMapiClientConnect);
begin Self.ClientConnectKind := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiClientConnectKind_R(Self: TJclSimpleMapi; var T: TJclMapiClientConnect);
begin T := Self.ClientConnectKind; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleMapiAnyClientInstalled_R(Self: TJclSimpleMapi; var T: Boolean);
begin T := Self.AnyClientInstalled; end;

(*----------------------------------------------------------------------------*)
procedure EJclMapiErrorErrorCode_R(Self: EJclMapiError; var T: DWORD);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclMapi_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@JclSimpleSendMail, 'JclSimpleSendMail', cdRegister);
 S.RegisterDelphiFunction(@JclSimpleSendFax, 'JclSimpleSendFax', cdRegister);
 S.RegisterDelphiFunction(@JclSimpleBringUpSendMailDialog, 'JclSimpleBringUpSendMailDialog', cdRegister);
 S.RegisterDelphiFunction(@MapiCheck, 'MapiCheck', cdRegister);
 S.RegisterDelphiFunction(@MapiErrorMessage, 'MapiErrorMessage', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclEmail(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclEmail) do begin
    RegisterConstructor(@TJclEmail.Create, 'Create');
    RegisterMethod(@TJclEmail.Destroy, 'Free');
    RegisterMethod(@TJclEmail.Address, 'Address');
    RegisterMethod(@TJclEmail.Clear, 'Clear');
    RegisterMethod(@TJclEmail.Delete, 'Delete');
    RegisterMethod(@TJclEmail.FindFirstMessage, 'FindFirstMessage');
    RegisterMethod(@TJclEmail.FindNextMessage, 'FindNextMessage');
    RegisterMethod(@TJclEmail.LogOff, 'LogOff');
    RegisterMethod(@TJclEmail.LogOn, 'LogOn');
    RegisterMethod(@TJclEmail.MessageReport, 'MessageReport');
    RegisterMethod(@TJclEmail.Read, 'Read');
    RegisterMethod(@TJclEmail.ResolveName, 'ResolveName');
    RegisterMethod(@TJclEmail.RestoreTaskWindows, 'RestoreTaskWindows');
    RegisterMethod(@TJclEmail.Save, 'Save');
    RegisterMethod(@TJclEmail.SaveTaskWindows, 'SaveTaskWindows');
    RegisterMethod(@TJclEmail.Send, 'Send');
    RegisterMethod(@TJclEmail.SortAttachments, 'SortAttachments');
    RegisterPropertyHelper(@TJclEmailAttachments_R,nil,'Attachments');
    RegisterPropertyHelper(@TJclEmailBody_R,@TJclEmailBody_W,'Body');
    RegisterPropertyHelper(@TJclEmailFindOptions_R,@TJclEmailFindOptions_W,'FindOptions');
    RegisterPropertyHelper(@TJclEmailHtmlBody_R,@TJclEmailHtmlBody_W,'HtmlBody');
    RegisterPropertyHelper(@TJclEmailLogonOptions_R,@TJclEmailLogonOptions_W,'LogonOptions');
    RegisterPropertyHelper(@TJclEmailParentWnd_R,@TJclEmailParentWnd_W,'ParentWnd');
    RegisterPropertyHelper(@TJclEmailReadMsg_R,nil,'ReadMsg');
    RegisterPropertyHelper(@TJclEmailRecipients_R,nil,'Recipients');
    RegisterPropertyHelper(@TJclEmailSeedMessageID_R,@TJclEmailSeedMessageID_W,'SeedMessageID');
    RegisterPropertyHelper(@TJclEmailSessionHandle_R,nil,'SessionHandle');
    RegisterPropertyHelper(@TJclEmailSubject_R,@TJclEmailSubject_W,'Subject');
    RegisterPropertyHelper(@TJclEmailUserLogged_R,nil,'UserLogged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclEmailRecips(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclEmailRecips) do begin
    RegisterMethod(@TJclEmailRecips.Add, 'Add');
    RegisterMethod(@TJclEmailRecips.SortRecips, 'SortRecips');
    RegisterPropertyHelper(@TJclEmailRecipsAddressesType_R,@TJclEmailRecipsAddressesType_W,'AddressesType');
    RegisterPropertyHelper(@TJclEmailRecipsItems_R,nil,'Items');
    RegisterPropertyHelper(@TJclEmailRecipsOriginator_R,nil,'Originator');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclEmailRecip(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclEmailRecip) do begin
    RegisterMethod(@TJclEmailRecip.AddressAndName, 'AddressAndName');
    RegisterMethod(@TJclEmailRecip.RecipKindToString, 'RecipKindToString');
    RegisterPropertyHelper(@TJclEmailRecipAddressType_R,@TJclEmailRecipAddressType_W,'AddressType');
    RegisterPropertyHelper(@TJclEmailRecipAddress_R,@TJclEmailRecipAddress_W,'Address');
    RegisterPropertyHelper(@TJclEmailRecipKind_R,@TJclEmailRecipKind_W,'Kind');
    RegisterPropertyHelper(@TJclEmailRecipName_R,@TJclEmailRecipName_W,'Name');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleMapi(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleMapi) do begin
    RegisterConstructor(@TJclSimpleMapi.Create, 'Create');
    RegisterMethod(@TJclSimpleMapi.Destroy, 'Free');
    RegisterMethod(@TJclSimpleMapi.ClientLibLoaded, 'ClientLibLoaded');
    RegisterMethod(@TJclSimpleMapi.LoadClientLib, 'LoadClientLib');
    RegisterMethod(@TJclSimpleMapi.UnloadClientLib, 'UnloadClientLib');
    RegisterPropertyHelper(@TJclSimpleMapiAnyClientInstalled_R,nil,'AnyClientInstalled');
    RegisterPropertyHelper(@TJclSimpleMapiClientConnectKind_R,@TJclSimpleMapiClientConnectKind_W,'ClientConnectKind');
    RegisterPropertyHelper(@TJclSimpleMapiClientCount_R,nil,'ClientCount');
    RegisterPropertyHelper(@TJclSimpleMapiClients_R,nil,'Clients');
    RegisterPropertyHelper(@TJclSimpleMapiCurrentClientName_R,nil,'CurrentClientName');
    RegisterPropertyHelper(@TJclSimpleMapiDefaultClientIndex_R,nil,'DefaultClientIndex');
    RegisterPropertyHelper(@TJclSimpleMapiDefaultProfileName_R,nil,'DefaultProfileName');
    RegisterPropertyHelper(@TJclSimpleMapiMapiInstalled_R,nil,'MapiInstalled');
    RegisterPropertyHelper(@TJclSimpleMapiMapiVersion_R,nil,'MapiVersion');
    RegisterPropertyHelper(@TJclSimpleMapiProfileCount_R,nil,'ProfileCount');
    RegisterPropertyHelper(@TJclSimpleMapiProfiles_R,nil,'Profiles');
    RegisterPropertyHelper(@TJclSimpleMapiSelectedClientIndex_R,@TJclSimpleMapiSelectedClientIndex_W,'SelectedClientIndex');
    RegisterPropertyHelper(@TJclSimpleMapiSimpleMapiInstalled_R,nil,'SimpleMapiInstalled');
    RegisterPropertyHelper(@TJclSimpleMapiBeforeUnloadClient_R,@TJclSimpleMapiBeforeUnloadClient_W,'BeforeUnloadClient');
    RegisterPropertyHelper(@TJclSimpleMapiMapiAddress_R,nil,'MapiAddress');
    RegisterPropertyHelper(@TJclSimpleMapiMapiDeleteMail_R,nil,'MapiDeleteMail');
    RegisterPropertyHelper(@TJclSimpleMapiMapiDetails_R,nil,'MapiDetails');
    RegisterPropertyHelper(@TJclSimpleMapiMapiFindNext_R,nil,'MapiFindNext');
    RegisterPropertyHelper(@TJclSimpleMapiMapiFreeBuffer_R,nil,'MapiFreeBuffer');
    RegisterPropertyHelper(@TJclSimpleMapiMapiLogOff_R,nil,'MapiLogOff');
    RegisterPropertyHelper(@TJclSimpleMapiMapiLogOn_R,nil,'MapiLogOn');
    RegisterPropertyHelper(@TJclSimpleMapiMapiReadMail_R,nil,'MapiReadMail');
    RegisterPropertyHelper(@TJclSimpleMapiMapiResolveName_R,nil,'MapiResolveName');
    RegisterPropertyHelper(@TJclSimpleMapiMapiSaveMail_R,nil,'MapiSaveMail');
    RegisterPropertyHelper(@TJclSimpleMapiMapiSendDocuments_R,nil,'MapiSendDocuments');
    RegisterPropertyHelper(@TJclSimpleMapiMapiSendMail_R,nil,'MapiSendMail');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EJclMapiError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclMapiError) do
  begin
    RegisterPropertyHelper(@EJclMapiErrorErrorCode_R,nil,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclMapi(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EJclMapiError(CL);
  RIRegister_TJclSimpleMapi(CL);
  RIRegister_TJclEmailRecip(CL);
  RIRegister_TJclEmailRecips(CL);
  RIRegister_TJclEmail(CL);
end;

 
 
{ TPSImport_JclMapi }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMapi.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclMapi(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMapi.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclMapi(ri);
  RIRegister_JclMapi_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
