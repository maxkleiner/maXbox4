unit uPSI_JclLANMan;
{

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
  TPSImport_JclLANMan = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclLANMan(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclLANMan_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows ,JclLANMan;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclLANMan]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclLANMan(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TNetUserFlag', '( ufAccountDisable, ufHomedirRequired, ufLockout'
   +', ufPasswordNotRequired, ufPasswordCantChange, ufDontExpirePassword, ufMNSLogonAccount )');
  CL.AddTypeS('TNetUserFlags', 'set of TNetUserFlag');
  CL.AddTypeS('TNetUserInfoFlag', '( uifScript, uifTempDuplicateAccount, uifNor'
   +'malAccount, uifInterdomainTrustAccount, uifWorkstationTrustAccount, uifServerTrustAccount )');
  CL.AddTypeS('TNetUserInfoFlags', 'set of TNetUserInfoFlag');
  CL.AddTypeS('TNetUserPriv', '( upUnknown, upGuest, upUser, upAdmin )');
  CL.AddTypeS('TNetUserAuthFlag', '( afOpPrint, afOpComm, afOpServer, afOpAccounts )');
  CL.AddTypeS('TNetUserAuthFlags', 'set of TNetUserAuthFlag');
  CL.AddTypeS('TNetWellKnownRID', '( wkrAdmins, wkrUsers, wkrGuests, wkrPowerUs'
   +'ers, wkrBackupOPs, wkrReplicator, wkrEveryone )');
 CL.AddDelphiFunction('Function CreateAccount( const Server, Username, Fullname, Password, Description, Homedir, Script : string; const PasswordNeverExpires : Boolean) : Boolean');
 CL.AddDelphiFunction('Function CreateLocalAccount( const Username, Fullname, Password, Description, Homedir, Script : string; const PasswordNeverExpires : Boolean) : Boolean');
 CL.AddDelphiFunction('Function DeleteAccount( const Servername, Username : string) : Boolean');
 CL.AddDelphiFunction('Function DeleteLocalAccount( Username : string) : Boolean');
 CL.AddDelphiFunction('Function CreateLocalGroup( const Server, Groupname, Description : string) : Boolean');
 CL.AddDelphiFunction('Function CreateGlobalGroup( const Server, Groupname, Description : string) : Boolean');
 CL.AddDelphiFunction('Function DeleteLocalGroup( const Server, Groupname : string) : Boolean');
 CL.AddDelphiFunction('Function GetLocalGroups( const Server : string; const Groups : TStrings) : Boolean');
 CL.AddDelphiFunction('Function GetGlobalGroups( const Server : string; const Groups : TStrings) : Boolean');
 CL.AddDelphiFunction('Function LocalGroupExists( const Group : string) : Boolean');
 CL.AddDelphiFunction('Function GlobalGroupExists( const Server, Group : string) : Boolean');
 CL.AddDelphiFunction('Function AddAccountToLocalGroup( const Accountname, Groupname : string) : Boolean');
 CL.AddDelphiFunction('Function LookupGroupName( const Server : string; const RID : TNetWellKnownRID) : string');
 CL.AddDelphiFunction('Procedure ParseAccountName( const QualifiedName : string; var Domain, UserName : string)');
 CL.AddDelphiFunction('Function IsLocalAccount( const AccountName : string) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JclLANMan_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateAccount, 'CreateAccount', cdRegister);
 S.RegisterDelphiFunction(@CreateLocalAccount, 'CreateLocalAccount', cdRegister);
 S.RegisterDelphiFunction(@DeleteAccount, 'DeleteAccount', cdRegister);
 S.RegisterDelphiFunction(@DeleteLocalAccount, 'DeleteLocalAccount', cdRegister);
 S.RegisterDelphiFunction(@CreateLocalGroup, 'CreateLocalGroup', cdRegister);
 S.RegisterDelphiFunction(@CreateGlobalGroup, 'CreateGlobalGroup', cdRegister);
 S.RegisterDelphiFunction(@DeleteLocalGroup, 'DeleteLocalGroup', cdRegister);
 S.RegisterDelphiFunction(@GetLocalGroups, 'GetLocalGroups', cdRegister);
 S.RegisterDelphiFunction(@GetGlobalGroups, 'GetGlobalGroups', cdRegister);
 S.RegisterDelphiFunction(@LocalGroupExists, 'LocalGroupExists', cdRegister);
 S.RegisterDelphiFunction(@GlobalGroupExists, 'GlobalGroupExists', cdRegister);
 S.RegisterDelphiFunction(@AddAccountToLocalGroup, 'AddAccountToLocalGroup', cdRegister);
 S.RegisterDelphiFunction(@LookupGroupName, 'LookupGroupName', cdRegister);
 S.RegisterDelphiFunction(@ParseAccountName, 'ParseAccountName', cdRegister);
 S.RegisterDelphiFunction(@IsLocalAccount, 'IsLocalAccount', cdRegister);
end;

 
 
{ TPSImport_JclLANMan }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclLANMan.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclLANMan(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclLANMan.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclLANMan(ri);
  RIRegister_JclLANMan_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
