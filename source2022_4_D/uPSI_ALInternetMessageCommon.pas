unit uPSI_ALInternetMessageCommon;
{
   int base net
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
  TPSImport_ALInternetMessageCommon = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALNewsArticleHeader(CL: TPSPascalCompiler);
procedure SIRegister_TALEMailHeader(CL: TPSPascalCompiler);
procedure SIRegister_ALInternetMessageCommon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALInternetMessageCommon_Routines(S: TPSExec);
procedure RIRegister_TALNewsArticleHeader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALEMailHeader(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALInternetMessageCommon(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   AlStringList
  ,ALInternetMessageCommon
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALInternetMessageCommon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALNewsArticleHeader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tpersistent', 'TALNewsArticleHeader') do
  with CL.AddClassN(CL.FindClass('Tpersistent'),'TALNewsArticleHeader') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
    RegisterProperty('RelayVersion', 'AnsiString', iptrw);
    RegisterProperty('PostingVersion', 'AnsiString', iptrw);
    RegisterProperty('From', 'AnsiString', iptrw);
    RegisterProperty('Date', 'AnsiString', iptrw);
    RegisterProperty('Newsgroups', 'AnsiString', iptrw);
    RegisterProperty('Subject', 'AnsiString', iptrw);
    RegisterProperty('MessageID', 'AnsiString', iptrw);
    RegisterProperty('Path', 'AnsiString', iptrw);
    RegisterProperty('ReplyTo', 'AnsiString', iptrw);
    RegisterProperty('Sender', 'AnsiString', iptrw);
    RegisterProperty('FollowupTo', 'AnsiString', iptrw);
    RegisterProperty('DateReceived', 'AnsiString', iptrw);
    RegisterProperty('Expires', 'AnsiString', iptrw);
    RegisterProperty('References', 'AnsiString', iptrw);
    RegisterProperty('Control', 'AnsiString', iptrw);
    RegisterProperty('Distribution', 'AnsiString', iptrw);
    RegisterProperty('Organization', 'AnsiString', iptrw);
    RegisterProperty('Comments', 'AnsiString', iptrw);
    RegisterProperty('ContentType', 'AnsiString', iptrw);
    RegisterProperty('ContentTransferEncoding', 'AnsiString', iptrw);
    RegisterProperty('MIMEVersion', 'AnsiString', iptrw);
    RegisterProperty('NNTPPostingHost', 'AnsiString', iptrw);
    RegisterProperty('NNTPPostingDate', 'AnsiString', iptrw);
    RegisterProperty('CustomHeaders', 'TALStrings', iptr);
    RegisterProperty('RawHeaderText', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALEMailHeader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tpersistent', 'TALEMailHeader') do
  with CL.AddClassN(CL.FindClass('Tpersistent'),'TALEMailHeader') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
    RegisterProperty('From', 'AnsiString', iptrw);
    RegisterProperty('Sender', 'AnsiString', iptrw);
    RegisterProperty('SendTo', 'AnsiString', iptrw);
    RegisterProperty('cc', 'AnsiString', iptrw);
    RegisterProperty('bcc', 'AnsiString', iptrw);
    RegisterProperty('ReplyTo', 'AnsiString', iptrw);
    RegisterProperty('Subject', 'AnsiString', iptrw);
    RegisterProperty('MessageID', 'AnsiString', iptrw);
    RegisterProperty('References', 'AnsiString', iptrw);
    RegisterProperty('Comments', 'AnsiString', iptrw);
    RegisterProperty('Date', 'AnsiString', iptrw);
    RegisterProperty('ContentType', 'AnsiString', iptrw);
    RegisterProperty('ContentTransferEncoding', 'AnsiString', iptrw);
    RegisterProperty('MIMEVersion', 'AnsiString', iptrw);
    RegisterProperty('Priority', 'AnsiString', iptrw);
    RegisterProperty('DispositionNotificationTo', 'AnsiString', iptrw);
    RegisterProperty('CustomHeaders', 'TALStrings', iptr);
    RegisterProperty('RawHeaderText', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALInternetMessageCommon(CL: TPSPascalCompiler);
begin
  SIRegister_TALEMailHeader(CL);
  SIRegister_TALNewsArticleHeader(CL);
 CL.AddDelphiFunction('Function AlParseEmailAddress( FriendlyEmail : AnsiString; var RealName : AnsiString; const decodeRealName : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function AlExtractEmailAddress( FriendlyEmail : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALMakeFriendlyEmailAddress( aRealName, aEmail : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALEncodeRealName4FriendlyEmailAddress( aRealName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AlGenerateInternetMessageID : AnsiString;');
 CL.AddDelphiFunction('Function AlGenerateInternetMessageID1( ahostname : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function ALDecodeQuotedPrintableString( src : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AlDecodeInternetMessageHeaderInUTF8( aHeaderStr : AnsiString; aDefaultCodePage : Integer) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function AlGenerateInternetMessageID1_P( ahostname : AnsiString) : AnsiString;
Begin Result := ALInternetMessageCommon.AlGenerateInternetMessageID(ahostname); END;

(*----------------------------------------------------------------------------*)
Function AlGenerateInternetMessageID_P : AnsiString;
Begin Result := ALInternetMessageCommon.AlGenerateInternetMessageID; END;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderRawHeaderText_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.RawHeaderText := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderRawHeaderText_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.RawHeaderText; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderCustomHeaders_R(Self: TALNewsArticleHeader; var T: TALStrings);
begin T := Self.CustomHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderNNTPPostingDate_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.NNTPPostingDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderNNTPPostingDate_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.NNTPPostingDate; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderNNTPPostingHost_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.NNTPPostingHost := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderNNTPPostingHost_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.NNTPPostingHost; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderMIMEVersion_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.MIMEVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderMIMEVersion_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.MIMEVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderContentTransferEncoding_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.ContentTransferEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderContentTransferEncoding_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.ContentTransferEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderContentType_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.ContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderContentType_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderComments_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.Comments := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderComments_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.Comments; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderOrganization_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.Organization := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderOrganization_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.Organization; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderDistribution_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.Distribution := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderDistribution_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.Distribution; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderControl_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderControl_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderReferences_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.References := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderReferences_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.References; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderExpires_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.Expires := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderExpires_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.Expires; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderDateReceived_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.DateReceived := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderDateReceived_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.DateReceived; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderFollowupTo_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.FollowupTo := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderFollowupTo_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.FollowupTo; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderSender_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.Sender := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderSender_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.Sender; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderReplyTo_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.ReplyTo := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderReplyTo_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.ReplyTo; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderPath_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderPath_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderMessageID_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.MessageID := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderMessageID_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.MessageID; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderSubject_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderSubject_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderNewsgroups_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.Newsgroups := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderNewsgroups_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.Newsgroups; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderDate_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.Date := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderDate_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.Date; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderFrom_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.From := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderFrom_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.From; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderPostingVersion_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.PostingVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderPostingVersion_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.PostingVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderRelayVersion_W(Self: TALNewsArticleHeader; const T: AnsiString);
begin Self.RelayVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TALNewsArticleHeaderRelayVersion_R(Self: TALNewsArticleHeader; var T: AnsiString);
begin T := Self.RelayVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderRawHeaderText_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.RawHeaderText := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderRawHeaderText_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.RawHeaderText; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderCustomHeaders_R(Self: TALEMailHeader; var T: TALStrings);
begin T := Self.CustomHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderDispositionNotificationTo_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.DispositionNotificationTo := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderDispositionNotificationTo_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.DispositionNotificationTo; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderPriority_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderPriority_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderMIMEVersion_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.MIMEVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderMIMEVersion_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.MIMEVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderContentTransferEncoding_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.ContentTransferEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderContentTransferEncoding_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.ContentTransferEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderContentType_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.ContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderContentType_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderDate_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.Date := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderDate_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.Date; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderComments_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.Comments := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderComments_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.Comments; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderReferences_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.References := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderReferences_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.References; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderMessageID_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.MessageID := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderMessageID_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.MessageID; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderSubject_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderSubject_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderReplyTo_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.ReplyTo := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderReplyTo_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.ReplyTo; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderbcc_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.bcc := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderbcc_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.bcc; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeadercc_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.cc := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeadercc_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.cc; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderSendTo_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.SendTo := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderSendTo_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.SendTo; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderSender_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.Sender := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderSender_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.Sender; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderFrom_W(Self: TALEMailHeader; const T: AnsiString);
begin Self.From := T; end;

(*----------------------------------------------------------------------------*)
procedure TALEMailHeaderFrom_R(Self: TALEMailHeader; var T: AnsiString);
begin T := Self.From; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALInternetMessageCommon_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AlParseEmailAddress, 'AlParseEmailAddress', cdRegister);
 S.RegisterDelphiFunction(@AlExtractEmailAddress, 'AlExtractEmailAddress', cdRegister);
 S.RegisterDelphiFunction(@ALMakeFriendlyEmailAddress, 'ALMakeFriendlyEmailAddress', cdRegister);
 S.RegisterDelphiFunction(@ALEncodeRealName4FriendlyEmailAddress, 'ALEncodeRealName4FriendlyEmailAddress', cdRegister);
 S.RegisterDelphiFunction(@AlGenerateInternetMessageID, 'AlGenerateInternetMessageID', cdRegister);
 S.RegisterDelphiFunction(@AlGenerateInternetMessageID1_P, 'AlGenerateInternetMessageID1', cdRegister);
 S.RegisterDelphiFunction(@ALDecodeQuotedPrintableString, 'ALDecodeQuotedPrintableString', cdRegister);
 S.RegisterDelphiFunction(@AlDecodeInternetMessageHeaderInUTF8, 'AlDecodeInternetMessageHeaderInUTF8', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALNewsArticleHeader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALNewsArticleHeader) do
  begin
    RegisterVirtualConstructor(@TALNewsArticleHeader.Create, 'Create');
    RegisterMethod(@TALNewsArticleHeader.Clear, 'Clear');
    RegisterPropertyHelper(@TALNewsArticleHeaderRelayVersion_R,@TALNewsArticleHeaderRelayVersion_W,'RelayVersion');
    RegisterPropertyHelper(@TALNewsArticleHeaderPostingVersion_R,@TALNewsArticleHeaderPostingVersion_W,'PostingVersion');
    RegisterPropertyHelper(@TALNewsArticleHeaderFrom_R,@TALNewsArticleHeaderFrom_W,'From');
    RegisterPropertyHelper(@TALNewsArticleHeaderDate_R,@TALNewsArticleHeaderDate_W,'Date');
    RegisterPropertyHelper(@TALNewsArticleHeaderNewsgroups_R,@TALNewsArticleHeaderNewsgroups_W,'Newsgroups');
    RegisterPropertyHelper(@TALNewsArticleHeaderSubject_R,@TALNewsArticleHeaderSubject_W,'Subject');
    RegisterPropertyHelper(@TALNewsArticleHeaderMessageID_R,@TALNewsArticleHeaderMessageID_W,'MessageID');
    RegisterPropertyHelper(@TALNewsArticleHeaderPath_R,@TALNewsArticleHeaderPath_W,'Path');
    RegisterPropertyHelper(@TALNewsArticleHeaderReplyTo_R,@TALNewsArticleHeaderReplyTo_W,'ReplyTo');
    RegisterPropertyHelper(@TALNewsArticleHeaderSender_R,@TALNewsArticleHeaderSender_W,'Sender');
    RegisterPropertyHelper(@TALNewsArticleHeaderFollowupTo_R,@TALNewsArticleHeaderFollowupTo_W,'FollowupTo');
    RegisterPropertyHelper(@TALNewsArticleHeaderDateReceived_R,@TALNewsArticleHeaderDateReceived_W,'DateReceived');
    RegisterPropertyHelper(@TALNewsArticleHeaderExpires_R,@TALNewsArticleHeaderExpires_W,'Expires');
    RegisterPropertyHelper(@TALNewsArticleHeaderReferences_R,@TALNewsArticleHeaderReferences_W,'References');
    RegisterPropertyHelper(@TALNewsArticleHeaderControl_R,@TALNewsArticleHeaderControl_W,'Control');
    RegisterPropertyHelper(@TALNewsArticleHeaderDistribution_R,@TALNewsArticleHeaderDistribution_W,'Distribution');
    RegisterPropertyHelper(@TALNewsArticleHeaderOrganization_R,@TALNewsArticleHeaderOrganization_W,'Organization');
    RegisterPropertyHelper(@TALNewsArticleHeaderComments_R,@TALNewsArticleHeaderComments_W,'Comments');
    RegisterPropertyHelper(@TALNewsArticleHeaderContentType_R,@TALNewsArticleHeaderContentType_W,'ContentType');
    RegisterPropertyHelper(@TALNewsArticleHeaderContentTransferEncoding_R,@TALNewsArticleHeaderContentTransferEncoding_W,'ContentTransferEncoding');
    RegisterPropertyHelper(@TALNewsArticleHeaderMIMEVersion_R,@TALNewsArticleHeaderMIMEVersion_W,'MIMEVersion');
    RegisterPropertyHelper(@TALNewsArticleHeaderNNTPPostingHost_R,@TALNewsArticleHeaderNNTPPostingHost_W,'NNTPPostingHost');
    RegisterPropertyHelper(@TALNewsArticleHeaderNNTPPostingDate_R,@TALNewsArticleHeaderNNTPPostingDate_W,'NNTPPostingDate');
    RegisterPropertyHelper(@TALNewsArticleHeaderCustomHeaders_R,nil,'CustomHeaders');
    RegisterPropertyHelper(@TALNewsArticleHeaderRawHeaderText_R,@TALNewsArticleHeaderRawHeaderText_W,'RawHeaderText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALEMailHeader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALEMailHeader) do
  begin
    RegisterVirtualConstructor(@TALEMailHeader.Create, 'Create');
    RegisterMethod(@TALEMailHeader.Clear, 'Clear');
    RegisterPropertyHelper(@TALEMailHeaderFrom_R,@TALEMailHeaderFrom_W,'From');
    RegisterPropertyHelper(@TALEMailHeaderSender_R,@TALEMailHeaderSender_W,'Sender');
    RegisterPropertyHelper(@TALEMailHeaderSendTo_R,@TALEMailHeaderSendTo_W,'SendTo');
    RegisterPropertyHelper(@TALEMailHeadercc_R,@TALEMailHeadercc_W,'cc');
    RegisterPropertyHelper(@TALEMailHeaderbcc_R,@TALEMailHeaderbcc_W,'bcc');
    RegisterPropertyHelper(@TALEMailHeaderReplyTo_R,@TALEMailHeaderReplyTo_W,'ReplyTo');
    RegisterPropertyHelper(@TALEMailHeaderSubject_R,@TALEMailHeaderSubject_W,'Subject');
    RegisterPropertyHelper(@TALEMailHeaderMessageID_R,@TALEMailHeaderMessageID_W,'MessageID');
    RegisterPropertyHelper(@TALEMailHeaderReferences_R,@TALEMailHeaderReferences_W,'References');
    RegisterPropertyHelper(@TALEMailHeaderComments_R,@TALEMailHeaderComments_W,'Comments');
    RegisterPropertyHelper(@TALEMailHeaderDate_R,@TALEMailHeaderDate_W,'Date');
    RegisterPropertyHelper(@TALEMailHeaderContentType_R,@TALEMailHeaderContentType_W,'ContentType');
    RegisterPropertyHelper(@TALEMailHeaderContentTransferEncoding_R,@TALEMailHeaderContentTransferEncoding_W,'ContentTransferEncoding');
    RegisterPropertyHelper(@TALEMailHeaderMIMEVersion_R,@TALEMailHeaderMIMEVersion_W,'MIMEVersion');
    RegisterPropertyHelper(@TALEMailHeaderPriority_R,@TALEMailHeaderPriority_W,'Priority');
    RegisterPropertyHelper(@TALEMailHeaderDispositionNotificationTo_R,@TALEMailHeaderDispositionNotificationTo_W,'DispositionNotificationTo');
    RegisterPropertyHelper(@TALEMailHeaderCustomHeaders_R,nil,'CustomHeaders');
    RegisterPropertyHelper(@TALEMailHeaderRawHeaderText_R,@TALEMailHeaderRawHeaderText_W,'RawHeaderText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALInternetMessageCommon(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALEMailHeader(CL);
  RIRegister_TALNewsArticleHeader(CL);
end;

 
 
{ TPSImport_ALInternetMessageCommon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALInternetMessageCommon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALInternetMessageCommon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALInternetMessageCommon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALInternetMessageCommon(ri);
  RIRegister_ALInternetMessageCommon_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
