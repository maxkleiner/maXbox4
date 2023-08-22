unit uPSI_IdNNTPServer;
{
   the last unit for bigshame.ch server
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
  TPSImport_IdNNTPServer = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdNNTPServer(CL: TPSPascalCompiler);
procedure SIRegister_TIdNNTPThread(CL: TPSPascalCompiler);
procedure SIRegister_IdNNTPServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdNNTPServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdNNTPThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdNNTPServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdGlobal
  ,IdTCPServer
  ,IdNNTPServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdNNTPServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdNNTPServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdNNTPServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdNNTPServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');

    RegisterMethod('Function NNTPTimeToTime( const ATimeStamp : String) : TDateTime');
    RegisterMethod('Function NNTPDateTimeToDateTime( const ATimeStamp : string) : TDateTime');
    RegisterProperty('DistributionPatterns', 'TStrings', iptrw);
    RegisterProperty('Help', 'TStrings', iptrw);
    RegisterProperty('SupportedAuthTypes', 'TIdNNTPAuthTypes', iptrw);
    RegisterProperty('OnArticleByNo', 'TIdNNTPOnArticleByNo', iptrw);
    RegisterProperty('OnAuth', 'TIdNNTPOnAuth', iptrw);
    RegisterProperty('OnAuthRequired', 'TIdNNTPOnAuthRequired', iptrw);
    RegisterProperty('OnBodyByNo', 'TIdNNTPOnArticleByNo', iptrw);
    RegisterProperty('OnHeadByNo', 'TIdNNTPOnArticleByNo', iptrw);
    RegisterProperty('OnCheckMsgNo', 'TIdNNTPOnCheckMsgNo', iptrw);
    RegisterProperty('OnCheckMsgID', 'TidNNTPOnCheckMsgId', iptrw);
    RegisterProperty('OnStatMsgNo', 'TIdNNTPOnMovePointer', iptrw);
    RegisterProperty('OnNextArticle', 'TIdNNTPOnMovePointer', iptrw);
    RegisterProperty('OnPrevArticle', 'TIdNNTPOnMovePointer', iptrw);
    RegisterProperty('OnCheckListGroup', 'TIdNNTPOnCheckListGroup', iptrw);
    RegisterProperty('OnListActiveGroups', 'TIdNNTPOnListPattern', iptrw);
    RegisterProperty('OnListActiveGroupTimes', 'TIdNNTPOnListPattern', iptrw);
    RegisterProperty('OnListDescriptions', 'TIdNNTPOnListPattern', iptrw);
    RegisterProperty('OnListDistributions', 'TIdServerThreadEvent', iptrw);
    RegisterProperty('OnListExtensions', 'TIdServerThreadEvent', iptrw);
    RegisterProperty('OnListHeaders', 'TIdServerThreadEvent', iptrw);
    RegisterProperty('OnListSubscriptions', 'TIdServerThreadEvent', iptrw);
    RegisterProperty('OnListGroups', 'TIdServerThreadEvent', iptrw);
    RegisterProperty('OnListGroup', 'TIdServerThreadEvent', iptrw);
    RegisterProperty('OnListNewGroups', 'TIdNNTPOnNewGroupsList', iptrw);
    RegisterProperty('OnSelectGroup', 'TIdNNTPOnSelectGroup', iptrw);
    RegisterProperty('OnPost', 'TIdNNTPOnPost', iptrw);
    RegisterProperty('OverviewFormat', 'TStrings', iptrw);
    RegisterProperty('OnXHdr', 'TIdNNTPOnXHdr', iptrw);
    RegisterProperty('OnXOver', 'TIdNNTPOnXOver', iptrw);
    RegisterProperty('OnXROver', 'TIdNNTPOnXOver', iptrw);
    RegisterProperty('OnXPat', 'TIdNNTPOnXPat', iptrw);
    RegisterProperty('OnNewNews', 'TIdNNTPOnNewNews', iptrw);
    RegisterProperty('OnIHaveCheck', 'TIdNNTPOnIHaveCheck', iptrw);
    RegisterProperty('OnIHavePost', 'TIdNNTPOnPost', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdNNTPThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdPeerThread', 'TIdNNTPThread') do
  with CL.AddClassN(CL.FindClass('TIdPeerThread'),'TIdNNTPThread') do
  begin
    RegisterMethod('Constructor Create( ACreateSuspended : Boolean)');
    RegisterProperty('CurrentArticle', 'Integer', iptr);
    RegisterProperty('CurrentGroup', 'string', iptr);
    RegisterProperty('ModeReader', 'Boolean', iptr);
    RegisterProperty('UserName', 'string', iptr);
    RegisterProperty('Password', 'string', iptr);
    RegisterProperty('Authenticator', 'string', iptr);
    RegisterProperty('AuthParams', 'string', iptr);
    RegisterProperty('Authenticated', 'Boolean', iptr);
    RegisterProperty('AuthType', 'TIdNNTPAuthType', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdNNTPServer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdNNTPAuthType', '( atUserPass, atSimple, atGeneric )');
  CL.AddTypeS('TIdNNTPAuthTypes', 'set of TIdNNTPAuthType');
  SIRegister_TIdNNTPThread(CL);
  CL.AddTypeS('TIdNNTPOnAuth', 'Procedure ( AThread : TIdNNTPThread; var VAccept : Boolean)');
  CL.AddTypeS('TIdNNTPOnNewGroupsList', 'Procedure ( AThread : TIdNNTPThread; c'
   +'onst ADateStamp : TDateTime; const ADistributions : String)');
  CL.AddTypeS('TIdNNTPOnNewNews', 'Procedure ( AThread : TIdNNTPThread; const N'
   +'ewsgroups : String; const ADateStamp : TDateTime; const ADistributions : String)');
  CL.AddTypeS('TIdNNTPOnIHaveCheck', 'Procedure ( AThread : TIdNNTPThread; cons'
   +'t AMsgID : String; VAccept : Boolean)');
  CL.AddTypeS('TIdNNTPOnArticleByNo', 'Procedure ( AThread : TIdNNTPThread; const AMsgNo : Integer)');
  CL.AddTypeS('TIdNNTPOnArticleByID', 'Procedure ( AThread : TIdNNTPThread; const AMsgID : string)');
  CL.AddTypeS('TIdNNTPOnCheckMsgNo', 'Procedure ( AThread : TIdNNTPThread; cons'
   +'t AMsgNo : Integer; var VMsgID : string)');
  CL.AddTypeS('TIdNNTPOnCheckMsgID', 'Procedure ( AThread : TIdNNTPThread; cons'
   +'t AMsgId : string; var VMsgNo : Integer)');
  CL.AddTypeS('TIdNNTPOnMovePointer', 'Procedure ( AThread : TIdNNTPThread; var'
   +' AMsgNo : Integer; var VMsgID : string)');
  CL.AddTypeS('TIdNNTPOnPost', 'Procedure ( AThread : TIdNNTPThread; var VPostO'
   +'k : Boolean; var VErrorText : string)');
  CL.AddTypeS('TIdNNTPOnSelectGroup', 'Procedure ( AThread : TIdNNTPThread; con'
   +'st AGroup : string; var VMsgCount : Integer; var VMsgFirst : Integer; var '
   +'VMsgLast : Integer; var VGroupExists : Boolean)');
  CL.AddTypeS('TIdNNTPOnCheckListGroup', 'Procedure ( AThread : TIdNNTPThread; '
   +'const AGroup : string; var VCanJoin : Boolean; var VFirstArticle : Integer)');
  CL.AddTypeS('TIdNNTPOnXHdr', 'Procedure ( AThread : TIdNNTPThread; const AHea'
   +'derName : String; const AMsgFirst : Integer; const AMsgLast : Integer; const AMsgID : String)');
  CL.AddTypeS('TIdNNTPOnXOver', 'Procedure ( AThread : TIdNNTPThread; const AMs'
   +'gFirst : Integer; const AMsgLast : Integer)');
  CL.AddTypeS('TIdNNTPOnXPat', 'Procedure ( AThread : TIdNNTPThread; const AHea'
   +'derName : String; const AMsgFirst : Integer; const AMsgLast : Integer; con'
   +'st AMsgID : String; const AHeaderPattern : String)');
  CL.AddTypeS('TIdNNTPOnAuthRequired', 'Procedure ( AThread : TIdNNTPThread; co'
   +'nst ACommand, AParams : string; var VRequired : Boolean)');
  CL.AddTypeS('TIdNNTPOnListPattern', 'Procedure ( AThread : TIdNNTPThread; con'
   +'st AGroupPattern : String)');
  SIRegister_TIdNNTPServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnIHavePost_W(Self: TIdNNTPServer; const T: TIdNNTPOnPost);
begin Self.OnIHavePost := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnIHavePost_R(Self: TIdNNTPServer; var T: TIdNNTPOnPost);
begin T := Self.OnIHavePost; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnIHaveCheck_W(Self: TIdNNTPServer; const T: TIdNNTPOnIHaveCheck);
begin Self.OnIHaveCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnIHaveCheck_R(Self: TIdNNTPServer; var T: TIdNNTPOnIHaveCheck);
begin T := Self.OnIHaveCheck; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnNewNews_W(Self: TIdNNTPServer; const T: TIdNNTPOnNewNews);
begin Self.OnNewNews := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnNewNews_R(Self: TIdNNTPServer; var T: TIdNNTPOnNewNews);
begin T := Self.OnNewNews; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnXPat_W(Self: TIdNNTPServer; const T: TIdNNTPOnXPat);
begin Self.OnXPat := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnXPat_R(Self: TIdNNTPServer; var T: TIdNNTPOnXPat);
begin T := Self.OnXPat; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnXROver_W(Self: TIdNNTPServer; const T: TIdNNTPOnXOver);
begin Self.OnXROver := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnXROver_R(Self: TIdNNTPServer; var T: TIdNNTPOnXOver);
begin T := Self.OnXROver; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnXOver_W(Self: TIdNNTPServer; const T: TIdNNTPOnXOver);
begin Self.OnXOver := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnXOver_R(Self: TIdNNTPServer; var T: TIdNNTPOnXOver);
begin T := Self.OnXOver; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnXHdr_W(Self: TIdNNTPServer; const T: TIdNNTPOnXHdr);
begin Self.OnXHdr := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnXHdr_R(Self: TIdNNTPServer; var T: TIdNNTPOnXHdr);
begin T := Self.OnXHdr; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOverviewFormat_W(Self: TIdNNTPServer; const T: TStrings);
begin Self.OverviewFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOverviewFormat_R(Self: TIdNNTPServer; var T: TStrings);
begin T := Self.OverviewFormat; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnPost_W(Self: TIdNNTPServer; const T: TIdNNTPOnPost);
begin Self.OnPost := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnPost_R(Self: TIdNNTPServer; var T: TIdNNTPOnPost);
begin T := Self.OnPost; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnSelectGroup_W(Self: TIdNNTPServer; const T: TIdNNTPOnSelectGroup);
begin Self.OnSelectGroup := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnSelectGroup_R(Self: TIdNNTPServer; var T: TIdNNTPOnSelectGroup);
begin T := Self.OnSelectGroup; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListNewGroups_W(Self: TIdNNTPServer; const T: TIdNNTPOnNewGroupsList);
begin Self.OnListNewGroups := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListNewGroups_R(Self: TIdNNTPServer; var T: TIdNNTPOnNewGroupsList);
begin T := Self.OnListNewGroups; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListGroup_W(Self: TIdNNTPServer; const T: TIdServerThreadEvent);
begin Self.OnListGroup := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListGroup_R(Self: TIdNNTPServer; var T: TIdServerThreadEvent);
begin T := Self.OnListGroup; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListGroups_W(Self: TIdNNTPServer; const T: TIdServerThreadEvent);
begin Self.OnListGroups := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListGroups_R(Self: TIdNNTPServer; var T: TIdServerThreadEvent);
begin T := Self.OnListGroups; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListSubscriptions_W(Self: TIdNNTPServer; const T: TIdServerThreadEvent);
begin Self.OnListSubscriptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListSubscriptions_R(Self: TIdNNTPServer; var T: TIdServerThreadEvent);
begin T := Self.OnListSubscriptions; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListHeaders_W(Self: TIdNNTPServer; const T: TIdServerThreadEvent);
begin Self.OnListHeaders := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListHeaders_R(Self: TIdNNTPServer; var T: TIdServerThreadEvent);
begin T := Self.OnListHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListExtensions_W(Self: TIdNNTPServer; const T: TIdServerThreadEvent);
begin Self.OnListExtensions := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListExtensions_R(Self: TIdNNTPServer; var T: TIdServerThreadEvent);
begin T := Self.OnListExtensions; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListDistributions_W(Self: TIdNNTPServer; const T: TIdServerThreadEvent);
begin Self.OnListDistributions := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListDistributions_R(Self: TIdNNTPServer; var T: TIdServerThreadEvent);
begin T := Self.OnListDistributions; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListDescriptions_W(Self: TIdNNTPServer; const T: TIdNNTPOnListPattern);
begin Self.OnListDescriptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListDescriptions_R(Self: TIdNNTPServer; var T: TIdNNTPOnListPattern);
begin T := Self.OnListDescriptions; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListActiveGroupTimes_W(Self: TIdNNTPServer; const T: TIdNNTPOnListPattern);
begin Self.OnListActiveGroupTimes := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListActiveGroupTimes_R(Self: TIdNNTPServer; var T: TIdNNTPOnListPattern);
begin T := Self.OnListActiveGroupTimes; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListActiveGroups_W(Self: TIdNNTPServer; const T: TIdNNTPOnListPattern);
begin Self.OnListActiveGroups := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnListActiveGroups_R(Self: TIdNNTPServer; var T: TIdNNTPOnListPattern);
begin T := Self.OnListActiveGroups; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnCheckListGroup_W(Self: TIdNNTPServer; const T: TIdNNTPOnCheckListGroup);
begin Self.OnCheckListGroup := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnCheckListGroup_R(Self: TIdNNTPServer; var T: TIdNNTPOnCheckListGroup);
begin T := Self.OnCheckListGroup; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnPrevArticle_W(Self: TIdNNTPServer; const T: TIdNNTPOnMovePointer);
begin Self.OnPrevArticle := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnPrevArticle_R(Self: TIdNNTPServer; var T: TIdNNTPOnMovePointer);
begin T := Self.OnPrevArticle; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnNextArticle_W(Self: TIdNNTPServer; const T: TIdNNTPOnMovePointer);
begin Self.OnNextArticle := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnNextArticle_R(Self: TIdNNTPServer; var T: TIdNNTPOnMovePointer);
begin T := Self.OnNextArticle; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnStatMsgNo_W(Self: TIdNNTPServer; const T: TIdNNTPOnMovePointer);
begin Self.OnStatMsgNo := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnStatMsgNo_R(Self: TIdNNTPServer; var T: TIdNNTPOnMovePointer);
begin T := Self.OnStatMsgNo; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnCheckMsgID_W(Self: TIdNNTPServer; const T: TidNNTPOnCheckMsgId);
begin Self.OnCheckMsgID := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnCheckMsgID_R(Self: TIdNNTPServer; var T: TidNNTPOnCheckMsgId);
begin T := Self.OnCheckMsgID; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnCheckMsgNo_W(Self: TIdNNTPServer; const T: TIdNNTPOnCheckMsgNo);
begin Self.OnCheckMsgNo := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnCheckMsgNo_R(Self: TIdNNTPServer; var T: TIdNNTPOnCheckMsgNo);
begin T := Self.OnCheckMsgNo; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnHeadByNo_W(Self: TIdNNTPServer; const T: TIdNNTPOnArticleByNo);
begin Self.OnHeadByNo := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnHeadByNo_R(Self: TIdNNTPServer; var T: TIdNNTPOnArticleByNo);
begin T := Self.OnHeadByNo; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnBodyByNo_W(Self: TIdNNTPServer; const T: TIdNNTPOnArticleByNo);
begin Self.OnBodyByNo := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnBodyByNo_R(Self: TIdNNTPServer; var T: TIdNNTPOnArticleByNo);
begin T := Self.OnBodyByNo; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnAuthRequired_W(Self: TIdNNTPServer; const T: TIdNNTPOnAuthRequired);
begin Self.OnAuthRequired := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnAuthRequired_R(Self: TIdNNTPServer; var T: TIdNNTPOnAuthRequired);
begin T := Self.OnAuthRequired; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnAuth_W(Self: TIdNNTPServer; const T: TIdNNTPOnAuth);
begin Self.OnAuth := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnAuth_R(Self: TIdNNTPServer; var T: TIdNNTPOnAuth);
begin T := Self.OnAuth; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnArticleByNo_W(Self: TIdNNTPServer; const T: TIdNNTPOnArticleByNo);
begin Self.OnArticleByNo := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerOnArticleByNo_R(Self: TIdNNTPServer; var T: TIdNNTPOnArticleByNo);
begin T := Self.OnArticleByNo; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerSupportedAuthTypes_W(Self: TIdNNTPServer; const T: TIdNNTPAuthTypes);
begin Self.SupportedAuthTypes := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerSupportedAuthTypes_R(Self: TIdNNTPServer; var T: TIdNNTPAuthTypes);
begin T := Self.SupportedAuthTypes; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerHelp_W(Self: TIdNNTPServer; const T: TStrings);
begin Self.Help := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerHelp_R(Self: TIdNNTPServer; var T: TStrings);
begin T := Self.Help; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerDistributionPatterns_W(Self: TIdNNTPServer; const T: TStrings);
begin Self.DistributionPatterns := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPServerDistributionPatterns_R(Self: TIdNNTPServer; var T: TStrings);
begin T := Self.DistributionPatterns; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPThreadAuthType_R(Self: TIdNNTPThread; var T: TIdNNTPAuthType);
begin T := Self.AuthType; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPThreadAuthenticated_R(Self: TIdNNTPThread; var T: Boolean);
begin T := Self.Authenticated; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPThreadAuthParams_R(Self: TIdNNTPThread; var T: string);
begin T := Self.AuthParams; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPThreadAuthenticator_R(Self: TIdNNTPThread; var T: string);
begin T := Self.Authenticator; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPThreadPassword_R(Self: TIdNNTPThread; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPThreadUserName_R(Self: TIdNNTPThread; var T: string);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPThreadModeReader_R(Self: TIdNNTPThread; var T: Boolean);
begin T := Self.ModeReader; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPThreadCurrentGroup_R(Self: TIdNNTPThread; var T: string);
begin T := Self.CurrentGroup; end;

(*----------------------------------------------------------------------------*)
procedure TIdNNTPThreadCurrentArticle_R(Self: TIdNNTPThread; var T: Integer);
begin T := Self.CurrentArticle; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdNNTPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdNNTPServer) do
  begin
    RegisterConstructor(@TIdNNTPServer.Create, 'Create');
    RegisterMethod(@TIdNNTPServer.Destroy, 'Free');

    RegisterMethod(@TIdNNTPServer.NNTPTimeToTime, 'NNTPTimeToTime');
    RegisterMethod(@TIdNNTPServer.NNTPDateTimeToDateTime, 'NNTPDateTimeToDateTime');
    RegisterPropertyHelper(@TIdNNTPServerDistributionPatterns_R,@TIdNNTPServerDistributionPatterns_W,'DistributionPatterns');
    RegisterPropertyHelper(@TIdNNTPServerHelp_R,@TIdNNTPServerHelp_W,'Help');
    RegisterPropertyHelper(@TIdNNTPServerSupportedAuthTypes_R,@TIdNNTPServerSupportedAuthTypes_W,'SupportedAuthTypes');
    RegisterPropertyHelper(@TIdNNTPServerOnArticleByNo_R,@TIdNNTPServerOnArticleByNo_W,'OnArticleByNo');
    RegisterPropertyHelper(@TIdNNTPServerOnAuth_R,@TIdNNTPServerOnAuth_W,'OnAuth');
    RegisterPropertyHelper(@TIdNNTPServerOnAuthRequired_R,@TIdNNTPServerOnAuthRequired_W,'OnAuthRequired');
    RegisterPropertyHelper(@TIdNNTPServerOnBodyByNo_R,@TIdNNTPServerOnBodyByNo_W,'OnBodyByNo');
    RegisterPropertyHelper(@TIdNNTPServerOnHeadByNo_R,@TIdNNTPServerOnHeadByNo_W,'OnHeadByNo');
    RegisterPropertyHelper(@TIdNNTPServerOnCheckMsgNo_R,@TIdNNTPServerOnCheckMsgNo_W,'OnCheckMsgNo');
    RegisterPropertyHelper(@TIdNNTPServerOnCheckMsgID_R,@TIdNNTPServerOnCheckMsgID_W,'OnCheckMsgID');
    RegisterPropertyHelper(@TIdNNTPServerOnStatMsgNo_R,@TIdNNTPServerOnStatMsgNo_W,'OnStatMsgNo');
    RegisterPropertyHelper(@TIdNNTPServerOnNextArticle_R,@TIdNNTPServerOnNextArticle_W,'OnNextArticle');
    RegisterPropertyHelper(@TIdNNTPServerOnPrevArticle_R,@TIdNNTPServerOnPrevArticle_W,'OnPrevArticle');
    RegisterPropertyHelper(@TIdNNTPServerOnCheckListGroup_R,@TIdNNTPServerOnCheckListGroup_W,'OnCheckListGroup');
    RegisterPropertyHelper(@TIdNNTPServerOnListActiveGroups_R,@TIdNNTPServerOnListActiveGroups_W,'OnListActiveGroups');
    RegisterPropertyHelper(@TIdNNTPServerOnListActiveGroupTimes_R,@TIdNNTPServerOnListActiveGroupTimes_W,'OnListActiveGroupTimes');
    RegisterPropertyHelper(@TIdNNTPServerOnListDescriptions_R,@TIdNNTPServerOnListDescriptions_W,'OnListDescriptions');
    RegisterPropertyHelper(@TIdNNTPServerOnListDistributions_R,@TIdNNTPServerOnListDistributions_W,'OnListDistributions');
    RegisterPropertyHelper(@TIdNNTPServerOnListExtensions_R,@TIdNNTPServerOnListExtensions_W,'OnListExtensions');
    RegisterPropertyHelper(@TIdNNTPServerOnListHeaders_R,@TIdNNTPServerOnListHeaders_W,'OnListHeaders');
    RegisterPropertyHelper(@TIdNNTPServerOnListSubscriptions_R,@TIdNNTPServerOnListSubscriptions_W,'OnListSubscriptions');
    RegisterPropertyHelper(@TIdNNTPServerOnListGroups_R,@TIdNNTPServerOnListGroups_W,'OnListGroups');
    RegisterPropertyHelper(@TIdNNTPServerOnListGroup_R,@TIdNNTPServerOnListGroup_W,'OnListGroup');
    RegisterPropertyHelper(@TIdNNTPServerOnListNewGroups_R,@TIdNNTPServerOnListNewGroups_W,'OnListNewGroups');
    RegisterPropertyHelper(@TIdNNTPServerOnSelectGroup_R,@TIdNNTPServerOnSelectGroup_W,'OnSelectGroup');
    RegisterPropertyHelper(@TIdNNTPServerOnPost_R,@TIdNNTPServerOnPost_W,'OnPost');
    RegisterPropertyHelper(@TIdNNTPServerOverviewFormat_R,@TIdNNTPServerOverviewFormat_W,'OverviewFormat');
    RegisterPropertyHelper(@TIdNNTPServerOnXHdr_R,@TIdNNTPServerOnXHdr_W,'OnXHdr');
    RegisterPropertyHelper(@TIdNNTPServerOnXOver_R,@TIdNNTPServerOnXOver_W,'OnXOver');
    RegisterPropertyHelper(@TIdNNTPServerOnXROver_R,@TIdNNTPServerOnXROver_W,'OnXROver');
    RegisterPropertyHelper(@TIdNNTPServerOnXPat_R,@TIdNNTPServerOnXPat_W,'OnXPat');
    RegisterPropertyHelper(@TIdNNTPServerOnNewNews_R,@TIdNNTPServerOnNewNews_W,'OnNewNews');
    RegisterPropertyHelper(@TIdNNTPServerOnIHaveCheck_R,@TIdNNTPServerOnIHaveCheck_W,'OnIHaveCheck');
    RegisterPropertyHelper(@TIdNNTPServerOnIHavePost_R,@TIdNNTPServerOnIHavePost_W,'OnIHavePost');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdNNTPThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdNNTPThread) do
  begin
    RegisterConstructor(@TIdNNTPThread.Create, 'Create');
    RegisterPropertyHelper(@TIdNNTPThreadCurrentArticle_R,nil,'CurrentArticle');
    RegisterPropertyHelper(@TIdNNTPThreadCurrentGroup_R,nil,'CurrentGroup');
    RegisterPropertyHelper(@TIdNNTPThreadModeReader_R,nil,'ModeReader');
    RegisterPropertyHelper(@TIdNNTPThreadUserName_R,nil,'UserName');
    RegisterPropertyHelper(@TIdNNTPThreadPassword_R,nil,'Password');
    RegisterPropertyHelper(@TIdNNTPThreadAuthenticator_R,nil,'Authenticator');
    RegisterPropertyHelper(@TIdNNTPThreadAuthParams_R,nil,'AuthParams');
    RegisterPropertyHelper(@TIdNNTPThreadAuthenticated_R,nil,'Authenticated');
    RegisterPropertyHelper(@TIdNNTPThreadAuthType_R,nil,'AuthType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdNNTPServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdNNTPThread(CL);
  RIRegister_TIdNNTPServer(CL);
end;

 
 
{ TPSImport_IdNNTPServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdNNTPServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdNNTPServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdNNTPServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdNNTPServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
