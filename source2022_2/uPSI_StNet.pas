unit uPSI_StNet;
{
  with netcon and netmsg
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
  TPSImport_StNet = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStNetwork(CL: TPSPascalCompiler);
procedure SIRegister_TStNetServerItem(CL: TPSPascalCompiler);
procedure SIRegister_TStNetShareItem(CL: TPSPascalCompiler);
procedure SIRegister_TStNetGroupItem(CL: TPSPascalCompiler);
procedure SIRegister_TStNetUserItem(CL: TPSPascalCompiler);
procedure SIRegister_TStNetItem(CL: TPSPascalCompiler);
procedure SIRegister_StNet(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStNetwork(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStNetServerItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStNetShareItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStNetGroupItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStNetUserItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStNetItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_StNet(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StBase
  ,StDate
  ,StNetApi
  ,StConst
  ,StNet
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StNet]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNetwork(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStNetwork') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStNetwork') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('Server', 'TStNetServerItem string', iptr);
    RegisterProperty('User', 'TStNetUserItem string string', iptr);
    RegisterProperty('Group', 'TStNetGroupItem string string', iptr);
    RegisterProperty('PrimaryDC', 'TStNetServerItem string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNetServerItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStNetItem', 'TStNetServerItem') do
  with CL.AddClassN(CL.FindClass('TStNetItem'),'TStNetServerItem') do begin
    RegisterMethod('Function AddGroup( AName, ADescription : string; AGlobal : Boolean) : TStNetGroupItem');
    RegisterMethod('Function AddUser( AName, APassword : string; AGlobal : Boolean) : TStNetUserItem');
    RegisterMethod('Procedure Refresh');
    RegisterProperty('AnnounceRate', 'DWord', iptrw);
    RegisterProperty('AnnounceRateDelta', 'DWord', iptrw);
    RegisterProperty('Comment', 'string', iptrw);
    RegisterProperty('DisconnectTime', 'DWord', iptrw);
    RegisterProperty('MaxUsers', 'DWord', iptrw);
    RegisterProperty('Platform', 'TStNetServerPlatformType', iptr);
    RegisterProperty('ServerType', 'TStNetServerSet', iptr);
    RegisterProperty('UserPath', 'string', iptr);
    RegisterProperty('Version', 'DWord', iptr);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('MinPasswordLen', 'DWord', iptrw);
    RegisterProperty('MaxPasswordAge', 'DWord', iptrw);
    RegisterProperty('MinPasswordAge', 'DWord', iptrw);
    RegisterProperty('ForceLogoff', 'TStTime', iptrw);
    RegisterProperty('PasswordHistoryLength', 'DWord', iptrw);
    RegisterProperty('Role', 'TStNetServerRoleType', iptr);
    RegisterProperty('PrimaryDC', 'string', iptr);
    RegisterProperty('DomainName', 'string', iptr);
    RegisterProperty('DomainSid', 'TStSidRecord', iptr);
    RegisterProperty('LockOutDuration', 'DWord', iptrw);
    RegisterProperty('LockoutObservationWindow', 'DWord', iptrw);
    RegisterProperty('LockoutThreshold', 'DWord', iptrw);
    RegisterProperty('User', 'TStNetUserItem string', iptr);
    RegisterProperty('Group', 'TStNetGroupItem string', iptr);
    RegisterProperty('Drives', 'TStringList', iptr);
    RegisterProperty('Users', 'TStringList', iptr);
    RegisterProperty('Groups', 'TStringList', iptr);
    RegisterProperty('Shares', 'TStringList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNetShareItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStNetItem', 'TStNetShareItem') do
  with CL.AddClassN(CL.FindClass('TStNetItem'),'TStNetShareItem') do
  begin
    RegisterProperty('ShareType', 'TStNetShareType', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNetGroupItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStNetItem', 'TStNetGroupItem') do
  with CL.AddClassN(CL.FindClass('TStNetItem'),'TStNetGroupItem') do begin
    RegisterMethod('Procedure AddToGroup( AItem : TStNetItem)');
    RegisterMethod('Procedure RemoveFromGroup( AItem : TStNetItem)');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Procedure Refresh');
    RegisterProperty('Comment', 'string', iptrw);
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('ID', 'Cardinal', iptr);
    RegisterProperty('Items', 'TStringList', iptr);
    RegisterProperty('Sid', 'TStSidRecord', iptr);
    RegisterProperty('Domain', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNetUserItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStNetItem', 'TStNetUserItem') do
  with CL.AddClassN(CL.FindClass('TStNetItem'),'TStNetUserItem') do begin
    RegisterMethod('Procedure Delete');
    RegisterMethod('Procedure Refresh');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure AddToGroup( AGroup : TStNetItem)');
    RegisterMethod('Procedure RemoveFromGroup( AGroup : TStNetItem)');
    RegisterMethod('Procedure GetLogonHours( var LogonHours : TStNetUserLogonTimes)');
    RegisterMethod('Procedure SetLogonHours( LogonHours : TStNetUserLogonTimes)');
    RegisterMethod('Procedure SetPassword( OldPassword, NewPassword : string)');
    RegisterProperty('AccountDisabled', 'Boolean', iptrw);
    RegisterProperty('AccountExpires', 'TStDateTimeRec', iptrw);
    RegisterProperty('BadPasswordCount', 'Cardinal', iptr);
    RegisterProperty('Comment', 'string', iptrw);
    RegisterProperty('Domain', 'string', iptr);
    RegisterProperty('FullName', 'string', iptrw);
    RegisterProperty('Groups', 'TStringList', iptr);
    RegisterProperty('HomeDirectory', 'string', iptrw);
    RegisterProperty('HomeDrive', 'string', iptrw);
    RegisterProperty('ID', 'Cardinal', iptr);
    RegisterProperty('LastLogon', 'TStDateTimeRec', iptr);
    RegisterProperty('LastLogoff', 'TStDateTimeRec', iptr);
    RegisterProperty('LockedOut', 'Boolean', iptrw);
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('NoUserPasswordChange', 'Boolean', iptrw);
    RegisterProperty('NumberOfLogons', 'Cardinal', iptr);
    RegisterProperty('OperatorPrivilege', 'TStNetUserAuthPrivSet', iptr);
    RegisterProperty('Password', 'string', iptw);
    RegisterProperty('PasswordNeverExpires', 'Boolean', iptrw);
    RegisterProperty('PasswordExpired', 'Boolean', iptrw);
    RegisterProperty('PasswordLastChanged', 'TStDateTimeRec', iptr);
    RegisterProperty('PasswordNotRequired', 'Boolean', iptrw);
    RegisterProperty('PrimaryGroup', 'TStNetItem', iptrw);
    RegisterProperty('ProfilePath', 'string', iptrw);
    RegisterProperty('ScriptPath', 'string', iptrw);
    RegisterProperty('Sid', 'TStSidRecord', iptr);
    RegisterProperty('UserComment', 'string', iptrw);
    RegisterProperty('UserPrivilege', 'TStNetUserPrivType', iptr);
    RegisterProperty('Workstations', 'TStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNetItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStNetItem') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStNetItem') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('Comment', 'string', iptr);
    RegisterProperty('ItemType', 'TStNetItemType', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('Server', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StNet(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStNetItemType', '( nitUnknown, nitLocalUser, nitGlobalUser, nit'
   +'LocalGroup, nitGlobalGroup, nitComputer, nitInterdomainTrust, nitWorkstati'
   +'onTrust, nitServerTrust, nitShare )');
  CL.AddTypeS('TStNetSidType', '( nstNone, nstUser, nstGroup, nstDomain, nstAli'
   +'as, nstWellKnownGroup, nstDeletedAccount, nstInvalid, nstUnknown, nstComputer )');
  CL.AddTypeS('TStNetUserPrivType', '( uptUnknown, uptGuest, uptUser, uptAdmin )');
  CL.AddTypeS('TStNetUserAuthPrivType', '( uaptPrint, uaptCommunications, uaptS'
   +'erver, uaptAccounts )');
  CL.AddTypeS('TStNetUserAuthPrivSet', 'set of TStNetUserAuthPrivType');
  CL.AddTypeS('TStNetShareType', '( stUnknown, stDisk, stPrint, stDevice, stIPC, stSpecial )');
  CL.AddTypeS('TStNetServerPlatformType', '( sptUnknown, sptDOS, sptOS2, sptNT, sptOSF, sptVMS )');
  CL.AddTypeS('TStNetServerType', '( nsvtWorkstation, nsvtServer, nsvtSQLServer'
   +', nsvtDomainCtrl, nsvtDomainBackupCtrl, nsvtTimeSource, nsvtAFP, nsvtNovel'
   +'l, nsvtDomainMember, nsvtPrintQServer, nsvtDialinServer, nsvtUNIXServer, n'
   +'svtNT, nsvtWFW, nsvtMFPN, nsvtServerNT, nsvtPotentialBrowser, nsvtBackupBr'
   +'owser, nsvtMasterBrowser, nsvtDomainMaster, nsvtOSF, nsvtVMS, nsvtWindows,'
   +' nsvtDFS, nsvtClusterNT, nsvtTerminalServer, nsvtDCE, nsvtAlternateXPORT, '
   +'nsvtLocalListOnly, nsvtDomainEnum )');
  CL.AddTypeS('TStNetServerSet', 'set of TStNetServerType');
  CL.AddTypeS('TStNetServerRoleType', '( srtUnknown, srtStandAlone, srtMember, '
   +'srtBackup, strPrimary )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStNetwork');
  CL.AddTypeS('TStSidRecord', 'record Value : ___Pointer; ValueS : string; Length '
   +': DWord; Usage : TStNetSidType; end');
  SIRegister_TStNetItem(CL);
  SIRegister_TStNetUserItem(CL);
  SIRegister_TStNetGroupItem(CL);
  SIRegister_TStNetShareItem(CL);
  SIRegister_TStNetServerItem(CL);
  SIRegister_TStNetwork(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStNetworkPrimaryDC_R(Self: TStNetwork; var T: TStNetServerItem; const t1: string);
begin T := Self.PrimaryDC[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStNetworkGroup_R(Self: TStNetwork; var T: TStNetGroupItem; const t1: string; const t2: string);
begin T := Self.Group[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TStNetworkUser_R(Self: TStNetwork; var T: TStNetUserItem; const t1: string; const t2: string);
begin T := Self.User[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TStNetworkServer_R(Self: TStNetwork; var T: TStNetServerItem; const t1: string);
begin T := Self.Server[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemShares_R(Self: TStNetServerItem; var T: TStringList);
begin T := Self.Shares; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemGroups_R(Self: TStNetServerItem; var T: TStringList);
begin T := Self.Groups; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemUsers_R(Self: TStNetServerItem; var T: TStringList);
begin T := Self.Users; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemDrives_R(Self: TStNetServerItem; var T: TStringList);
begin T := Self.Drives; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemGroup_R(Self: TStNetServerItem; var T: TStNetGroupItem; const t1: string);
begin T := Self.Group[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemUser_R(Self: TStNetServerItem; var T: TStNetUserItem; const t1: string);
begin T := Self.User[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemLockoutThreshold_W(Self: TStNetServerItem; const T: DWord);
begin Self.LockoutThreshold := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemLockoutThreshold_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.LockoutThreshold; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemLockoutObservationWindow_W(Self: TStNetServerItem; const T: DWord);
begin Self.LockoutObservationWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemLockoutObservationWindow_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.LockoutObservationWindow; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemLockOutDuration_W(Self: TStNetServerItem; const T: DWord);
begin Self.LockOutDuration := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemLockOutDuration_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.LockOutDuration; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemDomainSid_R(Self: TStNetServerItem; var T: TStSidRecord);
begin T := Self.DomainSid; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemDomainName_R(Self: TStNetServerItem; var T: string);
begin T := Self.DomainName; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemPrimaryDC_R(Self: TStNetServerItem; var T: string);
begin T := Self.PrimaryDC; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemRole_R(Self: TStNetServerItem; var T: TStNetServerRoleType);
begin T := Self.Role; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemPasswordHistoryLength_W(Self: TStNetServerItem; const T: DWord);
begin Self.PasswordHistoryLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemPasswordHistoryLength_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.PasswordHistoryLength; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemForceLogoff_W(Self: TStNetServerItem; const T: TStTime);
begin Self.ForceLogoff := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemForceLogoff_R(Self: TStNetServerItem; var T: TStTime);
begin T := Self.ForceLogoff; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemMinPasswordAge_W(Self: TStNetServerItem; const T: DWord);
begin Self.MinPasswordAge := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemMinPasswordAge_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.MinPasswordAge; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemMaxPasswordAge_W(Self: TStNetServerItem; const T: DWord);
begin Self.MaxPasswordAge := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemMaxPasswordAge_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.MaxPasswordAge; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemMinPasswordLen_W(Self: TStNetServerItem; const T: DWord);
begin Self.MinPasswordLen := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemMinPasswordLen_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.MinPasswordLen; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemVisible_W(Self: TStNetServerItem; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemVisible_R(Self: TStNetServerItem; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemVersion_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemUserPath_R(Self: TStNetServerItem; var T: string);
begin T := Self.UserPath; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemServerType_R(Self: TStNetServerItem; var T: TStNetServerSet);
begin T := Self.ServerType; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemPlatform_R(Self: TStNetServerItem; var T: TStNetServerPlatformType);
begin T := Self.Platform; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemMaxUsers_W(Self: TStNetServerItem; const T: DWord);
begin Self.MaxUsers := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemMaxUsers_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.MaxUsers; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemDisconnectTime_W(Self: TStNetServerItem; const T: DWord);
begin Self.DisconnectTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemDisconnectTime_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.DisconnectTime; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemComment_W(Self: TStNetServerItem; const T: string);
begin Self.Comment := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemComment_R(Self: TStNetServerItem; var T: string);
begin T := Self.Comment; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemAnnounceRateDelta_W(Self: TStNetServerItem; const T: DWord);
begin Self.AnnounceRateDelta := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemAnnounceRateDelta_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.AnnounceRateDelta; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemAnnounceRate_W(Self: TStNetServerItem; const T: DWord);
begin Self.AnnounceRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetServerItemAnnounceRate_R(Self: TStNetServerItem; var T: DWord);
begin T := Self.AnnounceRate; end;

(*----------------------------------------------------------------------------*)
procedure TStNetShareItemShareType_R(Self: TStNetShareItem; var T: TStNetShareType);
begin T := Self.ShareType; end;

(*----------------------------------------------------------------------------*)
procedure TStNetGroupItemDomain_R(Self: TStNetGroupItem; var T: string);
begin T := Self.Domain; end;

(*----------------------------------------------------------------------------*)
procedure TStNetGroupItemSid_R(Self: TStNetGroupItem; var T: TStSidRecord);
begin T := Self.Sid; end;

(*----------------------------------------------------------------------------*)
procedure TStNetGroupItemItems_R(Self: TStNetGroupItem; var T: TStringList);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TStNetGroupItemID_R(Self: TStNetGroupItem; var T: Cardinal);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TStNetGroupItemName_W(Self: TStNetGroupItem; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetGroupItemName_R(Self: TStNetGroupItem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TStNetGroupItemComment_W(Self: TStNetGroupItem; const T: string);
begin Self.Comment := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetGroupItemComment_R(Self: TStNetGroupItem; var T: string);
begin T := Self.Comment; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemWorkstations_W(Self: TStNetUserItem; const T: TStrings);
begin Self.Workstations := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemWorkstations_R(Self: TStNetUserItem; var T: TStrings);
begin T := Self.Workstations; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemUserPrivilege_R(Self: TStNetUserItem; var T: TStNetUserPrivType);
begin T := Self.UserPrivilege; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemUserComment_W(Self: TStNetUserItem; const T: string);
begin Self.UserComment := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemUserComment_R(Self: TStNetUserItem; var T: string);
begin T := Self.UserComment; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemSid_R(Self: TStNetUserItem; var T: TStSidRecord);
begin T := Self.Sid; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemScriptPath_W(Self: TStNetUserItem; const T: string);
begin Self.ScriptPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemScriptPath_R(Self: TStNetUserItem; var T: string);
begin T := Self.ScriptPath; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemProfilePath_W(Self: TStNetUserItem; const T: string);
begin Self.ProfilePath := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemProfilePath_R(Self: TStNetUserItem; var T: string);
begin T := Self.ProfilePath; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemPrimaryGroup_W(Self: TStNetUserItem; const T: TStNetItem);
begin Self.PrimaryGroup := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemPrimaryGroup_R(Self: TStNetUserItem; var T: TStNetItem);
begin T := Self.PrimaryGroup; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemPasswordNotRequired_W(Self: TStNetUserItem; const T: Boolean);
begin Self.PasswordNotRequired := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemPasswordNotRequired_R(Self: TStNetUserItem; var T: Boolean);
begin T := Self.PasswordNotRequired; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemPasswordLastChanged_R(Self: TStNetUserItem; var T: TStDateTimeRec);
begin T := Self.PasswordLastChanged; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemPasswordExpired_W(Self: TStNetUserItem; const T: Boolean);
begin Self.PasswordExpired := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemPasswordExpired_R(Self: TStNetUserItem; var T: Boolean);
begin T := Self.PasswordExpired; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemPasswordNeverExpires_W(Self: TStNetUserItem; const T: Boolean);
begin Self.PasswordNeverExpires := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemPasswordNeverExpires_R(Self: TStNetUserItem; var T: Boolean);
begin T := Self.PasswordNeverExpires; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemPassword_W(Self: TStNetUserItem; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemOperatorPrivilege_R(Self: TStNetUserItem; var T: TStNetUserAuthPrivSet);
begin T := Self.OperatorPrivilege; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemNumberOfLogons_R(Self: TStNetUserItem; var T: Cardinal);
begin T := Self.NumberOfLogons; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemNoUserPasswordChange_W(Self: TStNetUserItem; const T: Boolean);
begin Self.NoUserPasswordChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemNoUserPasswordChange_R(Self: TStNetUserItem; var T: Boolean);
begin T := Self.NoUserPasswordChange; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemName_W(Self: TStNetUserItem; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemName_R(Self: TStNetUserItem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemLockedOut_W(Self: TStNetUserItem; const T: Boolean);
begin Self.LockedOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemLockedOut_R(Self: TStNetUserItem; var T: Boolean);
begin T := Self.LockedOut; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemLastLogoff_R(Self: TStNetUserItem; var T: TStDateTimeRec);
begin T := Self.LastLogoff; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemLastLogon_R(Self: TStNetUserItem; var T: TStDateTimeRec);
begin T := Self.LastLogon; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemID_R(Self: TStNetUserItem; var T: Cardinal);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemHomeDrive_W(Self: TStNetUserItem; const T: string);
begin Self.HomeDrive := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemHomeDrive_R(Self: TStNetUserItem; var T: string);
begin T := Self.HomeDrive; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemHomeDirectory_W(Self: TStNetUserItem; const T: string);
begin Self.HomeDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemHomeDirectory_R(Self: TStNetUserItem; var T: string);
begin T := Self.HomeDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemGroups_R(Self: TStNetUserItem; var T: TStringList);
begin T := Self.Groups; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemFullName_W(Self: TStNetUserItem; const T: string);
begin Self.FullName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemFullName_R(Self: TStNetUserItem; var T: string);
begin T := Self.FullName; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemDomain_R(Self: TStNetUserItem; var T: string);
begin T := Self.Domain; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemComment_W(Self: TStNetUserItem; const T: string);
begin Self.Comment := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemComment_R(Self: TStNetUserItem; var T: string);
begin T := Self.Comment; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemBadPasswordCount_R(Self: TStNetUserItem; var T: Cardinal);
begin T := Self.BadPasswordCount; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemAccountExpires_W(Self: TStNetUserItem; const T: TStDateTimeRec);
begin Self.AccountExpires := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemAccountExpires_R(Self: TStNetUserItem; var T: TStDateTimeRec);
begin T := Self.AccountExpires; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemAccountDisabled_W(Self: TStNetUserItem; const T: Boolean);
begin Self.AccountDisabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetUserItemAccountDisabled_R(Self: TStNetUserItem; var T: Boolean);
begin T := Self.AccountDisabled; end;

(*----------------------------------------------------------------------------*)
procedure TStNetItemServer_R(Self: TStNetItem; var T: string);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TStNetItemName_R(Self: TStNetItem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TStNetItemItemType_R(Self: TStNetItem; var T: TStNetItemType);
begin T := Self.ItemType; end;

(*----------------------------------------------------------------------------*)
procedure TStNetItemComment_R(Self: TStNetItem; var T: string);
begin T := Self.Comment; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNetwork(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNetwork) do begin
    RegisterConstructor(@TStNetwork.Create, 'Create');
    RegisterMethod(@TStNetwork.Destroy, 'Free');
    RegisterPropertyHelper(@TStNetworkServer_R,nil,'Server');
    RegisterPropertyHelper(@TStNetworkUser_R,nil,'User');
    RegisterPropertyHelper(@TStNetworkGroup_R,nil,'Group');
    RegisterPropertyHelper(@TStNetworkPrimaryDC_R,nil,'PrimaryDC');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNetServerItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNetServerItem) do begin
    RegisterMethod(@TStNetServerItem.AddGroup, 'AddGroup');
    RegisterMethod(@TStNetServerItem.AddUser, 'AddUser');
    RegisterMethod(@TStNetServerItem.Refresh, 'Refresh');
    RegisterPropertyHelper(@TStNetServerItemAnnounceRate_R,@TStNetServerItemAnnounceRate_W,'AnnounceRate');
    RegisterPropertyHelper(@TStNetServerItemAnnounceRateDelta_R,@TStNetServerItemAnnounceRateDelta_W,'AnnounceRateDelta');
    RegisterPropertyHelper(@TStNetServerItemComment_R,@TStNetServerItemComment_W,'Comment');
    RegisterPropertyHelper(@TStNetServerItemDisconnectTime_R,@TStNetServerItemDisconnectTime_W,'DisconnectTime');
    RegisterPropertyHelper(@TStNetServerItemMaxUsers_R,@TStNetServerItemMaxUsers_W,'MaxUsers');
    RegisterPropertyHelper(@TStNetServerItemPlatform_R,nil,'Platform');
    RegisterPropertyHelper(@TStNetServerItemServerType_R,nil,'ServerType');
    RegisterPropertyHelper(@TStNetServerItemUserPath_R,nil,'UserPath');
    RegisterPropertyHelper(@TStNetServerItemVersion_R,nil,'Version');
    RegisterPropertyHelper(@TStNetServerItemVisible_R,@TStNetServerItemVisible_W,'Visible');
    RegisterPropertyHelper(@TStNetServerItemMinPasswordLen_R,@TStNetServerItemMinPasswordLen_W,'MinPasswordLen');
    RegisterPropertyHelper(@TStNetServerItemMaxPasswordAge_R,@TStNetServerItemMaxPasswordAge_W,'MaxPasswordAge');
    RegisterPropertyHelper(@TStNetServerItemMinPasswordAge_R,@TStNetServerItemMinPasswordAge_W,'MinPasswordAge');
    RegisterPropertyHelper(@TStNetServerItemForceLogoff_R,@TStNetServerItemForceLogoff_W,'ForceLogoff');
    RegisterPropertyHelper(@TStNetServerItemPasswordHistoryLength_R,@TStNetServerItemPasswordHistoryLength_W,'PasswordHistoryLength');
    RegisterPropertyHelper(@TStNetServerItemRole_R,nil,'Role');
    RegisterPropertyHelper(@TStNetServerItemPrimaryDC_R,nil,'PrimaryDC');
    RegisterPropertyHelper(@TStNetServerItemDomainName_R,nil,'DomainName');
    RegisterPropertyHelper(@TStNetServerItemDomainSid_R,nil,'DomainSid');
    RegisterPropertyHelper(@TStNetServerItemLockOutDuration_R,@TStNetServerItemLockOutDuration_W,'LockOutDuration');
    RegisterPropertyHelper(@TStNetServerItemLockoutObservationWindow_R,@TStNetServerItemLockoutObservationWindow_W,'LockoutObservationWindow');
    RegisterPropertyHelper(@TStNetServerItemLockoutThreshold_R,@TStNetServerItemLockoutThreshold_W,'LockoutThreshold');
    RegisterPropertyHelper(@TStNetServerItemUser_R,nil,'User');
    RegisterPropertyHelper(@TStNetServerItemGroup_R,nil,'Group');
    RegisterPropertyHelper(@TStNetServerItemDrives_R,nil,'Drives');
    RegisterPropertyHelper(@TStNetServerItemUsers_R,nil,'Users');
    RegisterPropertyHelper(@TStNetServerItemGroups_R,nil,'Groups');
    RegisterPropertyHelper(@TStNetServerItemShares_R,nil,'Shares');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNetShareItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNetShareItem) do
  begin
    RegisterPropertyHelper(@TStNetShareItemShareType_R,nil,'ShareType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNetGroupItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNetGroupItem) do begin
    RegisterMethod(@TStNetGroupItem.AddToGroup, 'AddToGroup');
    RegisterMethod(@TStNetGroupItem.RemoveFromGroup, 'RemoveFromGroup');
    RegisterMethod(@TStNetGroupItem.Delete, 'Delete');
    RegisterMethod(@TStNetGroupItem.Refresh, 'Refresh');
    RegisterPropertyHelper(@TStNetGroupItemComment_R,@TStNetGroupItemComment_W,'Comment');
    RegisterPropertyHelper(@TStNetGroupItemName_R,@TStNetGroupItemName_W,'Name');
    RegisterPropertyHelper(@TStNetGroupItemID_R,nil,'ID');
    RegisterPropertyHelper(@TStNetGroupItemItems_R,nil,'Items');
    RegisterPropertyHelper(@TStNetGroupItemSid_R,nil,'Sid');
    RegisterPropertyHelper(@TStNetGroupItemDomain_R,nil,'Domain');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNetUserItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNetUserItem) do begin
    RegisterMethod(@TStNetUserItem.Delete, 'Delete');
    RegisterMethod(@TStNetUserItem.Destroy, 'Free');
    RegisterMethod(@TStNetUserItem.Refresh, 'Refresh');
    RegisterMethod(@TStNetUserItem.AddToGroup, 'AddToGroup');
    RegisterMethod(@TStNetUserItem.RemoveFromGroup, 'RemoveFromGroup');
    RegisterMethod(@TStNetUserItem.GetLogonHours, 'GetLogonHours');
    RegisterMethod(@TStNetUserItem.SetLogonHours, 'SetLogonHours');
    RegisterMethod(@TStNetUserItem.SetPassword, 'SetPassword');
    RegisterPropertyHelper(@TStNetUserItemAccountDisabled_R,@TStNetUserItemAccountDisabled_W,'AccountDisabled');
    RegisterPropertyHelper(@TStNetUserItemAccountExpires_R,@TStNetUserItemAccountExpires_W,'AccountExpires');
    RegisterPropertyHelper(@TStNetUserItemBadPasswordCount_R,nil,'BadPasswordCount');
    RegisterPropertyHelper(@TStNetUserItemComment_R,@TStNetUserItemComment_W,'Comment');
    RegisterPropertyHelper(@TStNetUserItemDomain_R,nil,'Domain');
    RegisterPropertyHelper(@TStNetUserItemFullName_R,@TStNetUserItemFullName_W,'FullName');
    RegisterPropertyHelper(@TStNetUserItemGroups_R,nil,'Groups');
    RegisterPropertyHelper(@TStNetUserItemHomeDirectory_R,@TStNetUserItemHomeDirectory_W,'HomeDirectory');
    RegisterPropertyHelper(@TStNetUserItemHomeDrive_R,@TStNetUserItemHomeDrive_W,'HomeDrive');
    RegisterPropertyHelper(@TStNetUserItemID_R,nil,'ID');
    RegisterPropertyHelper(@TStNetUserItemLastLogon_R,nil,'LastLogon');
    RegisterPropertyHelper(@TStNetUserItemLastLogoff_R,nil,'LastLogoff');
    RegisterPropertyHelper(@TStNetUserItemLockedOut_R,@TStNetUserItemLockedOut_W,'LockedOut');
    RegisterPropertyHelper(@TStNetUserItemName_R,@TStNetUserItemName_W,'Name');
    RegisterPropertyHelper(@TStNetUserItemNoUserPasswordChange_R,@TStNetUserItemNoUserPasswordChange_W,'NoUserPasswordChange');
    RegisterPropertyHelper(@TStNetUserItemNumberOfLogons_R,nil,'NumberOfLogons');
    RegisterPropertyHelper(@TStNetUserItemOperatorPrivilege_R,nil,'OperatorPrivilege');
    RegisterPropertyHelper(nil,@TStNetUserItemPassword_W,'Password');
    RegisterPropertyHelper(@TStNetUserItemPasswordNeverExpires_R,@TStNetUserItemPasswordNeverExpires_W,'PasswordNeverExpires');
    RegisterPropertyHelper(@TStNetUserItemPasswordExpired_R,@TStNetUserItemPasswordExpired_W,'PasswordExpired');
    RegisterPropertyHelper(@TStNetUserItemPasswordLastChanged_R,nil,'PasswordLastChanged');
    RegisterPropertyHelper(@TStNetUserItemPasswordNotRequired_R,@TStNetUserItemPasswordNotRequired_W,'PasswordNotRequired');
    RegisterPropertyHelper(@TStNetUserItemPrimaryGroup_R,@TStNetUserItemPrimaryGroup_W,'PrimaryGroup');
    RegisterPropertyHelper(@TStNetUserItemProfilePath_R,@TStNetUserItemProfilePath_W,'ProfilePath');
    RegisterPropertyHelper(@TStNetUserItemScriptPath_R,@TStNetUserItemScriptPath_W,'ScriptPath');
    RegisterPropertyHelper(@TStNetUserItemSid_R,nil,'Sid');
    RegisterPropertyHelper(@TStNetUserItemUserComment_R,@TStNetUserItemUserComment_W,'UserComment');
    RegisterPropertyHelper(@TStNetUserItemUserPrivilege_R,nil,'UserPrivilege');
    RegisterPropertyHelper(@TStNetUserItemWorkstations_R,@TStNetUserItemWorkstations_W,'Workstations');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNetItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNetItem) do begin
    RegisterConstructor(@TStNetItem.Create, 'Create');
    RegisterMethod(@TStNetItem.Destroy, 'Free');
    RegisterPropertyHelper(@TStNetItemComment_R,nil,'Comment');
    RegisterPropertyHelper(@TStNetItemItemType_R,nil,'ItemType');
    RegisterPropertyHelper(@TStNetItemName_R,nil,'Name');
    RegisterPropertyHelper(@TStNetItemServer_R,nil,'Server');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StNet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNetwork) do
  RIRegister_TStNetItem(CL);
  RIRegister_TStNetUserItem(CL);
  RIRegister_TStNetGroupItem(CL);
  RIRegister_TStNetShareItem(CL);
  RIRegister_TStNetServerItem(CL);
  RIRegister_TStNetwork(CL);
end;

 
 
{ TPSImport_StNet }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StNet.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StNet(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StNet.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StNet(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
