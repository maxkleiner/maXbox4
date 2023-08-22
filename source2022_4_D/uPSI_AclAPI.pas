unit uPSI_AclAPI;
{
   just to minimal
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
  TPSImport_AclAPI = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_AclAPI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AclAPI_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,AccCtrl
  ,AclAPI
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AclAPI]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_AclAPI(CL: TPSPascalCompiler);
begin
 // CL.AddTypeS('PPSID', '^PSID // will not work');
 // CL.AddTypeS('PPSECURITY_DESCRIPTOR', '^PSECURITY_DESCRIPTOR // will not work');
 CL.AddDelphiFunction('Function SetEntriesInAcl( cCountOfExplicitEntries : ULONG; pListOfExplicitEntries : PEXPLICIT_ACCESS_; OldAcl : PACL; var NewAcl : PACL) : DWORD');
 CL.AddDelphiFunction('Function SetEntriesInAclA( cCountOfExplicitEntries : ULONG; pListOfExplicitEntries : PEXPLICIT_ACCESS_A; OldAcl : PACL; var NewAcl : PACL) : DWORD');
 CL.AddDelphiFunction('Function SetEntriesInAclW( cCountOfExplicitEntries : ULONG; pListOfExplicitEntries : PEXPLICIT_ACCESS_W; OldAcl : PACL; var NewAcl : PACL) : DWORD');
 CL.AddDelphiFunction('Function GetExplicitEntriesFromAcl( var pacl : ACL; var pcCountOfExplicitEntries : ULONG; pListOfExplicitEntries : PEXPLICIT_ACCESS_) : DWORD');
 CL.AddDelphiFunction('Function GetExplicitEntriesFromAclA( var pacl : ACL; var pcCountOfExplicitEntries : ULONG; pListOfExplicitEntries : PEXPLICIT_ACCESS_A) : DWORD');
 CL.AddDelphiFunction('Function GetExplicitEntriesFromAclW( var pacl : ACL; var pcCountOfExplicitEntries : ULONG; pListOfExplicitEntries : PEXPLICIT_ACCESS_W) : DWORD');
 CL.AddDelphiFunction('Function GetEffectiveRightsFromAcl( var pacl : ACL; var pTrustee : TRUSTEE_; var pAccessRights : ACCESS_MASK) : DWORD');
 CL.AddDelphiFunction('Function GetEffectiveRightsFromAclA( var pacl : ACL; var pTrustee : TRUSTEE_A; var pAccessRights : ACCESS_MASK) : DWORD');
 CL.AddDelphiFunction('Function GetEffectiveRightsFromAclW( var pacl : ACL; var pTrustee : TRUSTEE_W; var pAccessRights : ACCESS_MASK) : DWORD');
 CL.AddDelphiFunction('Function GetAuditedPermissionsFromAcl( var pacl : ACL; var pTrustee : TRUSTEE_; var pSuccessfulAuditedRights : ACCESS_MASK; var pFailedAuditRights : ACCESS_MASK) : DWORD');
 CL.AddDelphiFunction('Function GetAuditedPermissionsFromAclA( var pacl : ACL; var pTrustee : TRUSTEE_A; var pSuccessfulAuditedRights : ACCESS_MASK; var pFailedAuditRights : ACCESS_MASK) : DWORD');
 CL.AddDelphiFunction('Function GetAuditedPermissionsFromAclW( var pacl : ACL; var pTrustee : TRUSTEE_W; var pSuccessfulAuditedRights : ACCESS_MASK; var pFailedAuditRights : ACCESS_MASK) : DWORD');
 CL.AddDelphiFunction('Function GetNamedSecurityInfo( pObjectName : PAnsiChar; ObjectType : SE_OBJECT_TYPE; SecurityInfo : SECURITY_INFORMATION; ppsidOwner, ppsidGroup : PPSID; ppDacl, ppSacl : PACL; var ppSecurityDescriptor : PSECURITY_DESCRIPTOR) : DWORD');
 CL.AddDelphiFunction('Function GetNamedSecurityInfoA( pObjectName : PAnsiChar; ObjectType : SE_OBJECT_TYPE; SecurityInfo : SECURITY_INFORMATION; ppsidOwner, ppsidGroup : PPSID; ppDacl, ppSacl : PACL; var ppSecurityDescriptor : PSECURITY_DESCRIPTOR) : DWORD');
 CL.AddDelphiFunction('Function GetNamedSecurityInfoW( pObjectName : PAnsiChar; ObjectType : SE_OBJECT_TYPE; SecurityInfo : SECURITY_INFORMATION; ppsidOwner, ppsidGroup : PPSID; ppDacl, ppSacl : PACL; var ppSecurityDescriptor : PSECURITY_DESCRIPTOR) : DWORD');
 CL.AddDelphiFunction('Function GetSecurityInfo( handle : THandle; ObjectType : SE_OBJECT_TYPE; SecurityInfo : SECURITY_INFORMATION; ppsidOwner, ppsidGroup : PPSID; ppDacl, ppSacl : PACL; var ppSecurityDescriptor : PPSECURITY_DESCRIPTOR) : DWORD');
 CL.AddDelphiFunction('Function SetNamedSecurityInfo( pObjectName : PAnsiChar; ObjectType : SE_OBJECT_TYPE; SecurityInfo : SECURITY_INFORMATION; ppsidOwner, ppsidGroup : PPSID; ppDacl, ppSacl : PACL) : DWORD');
 CL.AddDelphiFunction('Function SetNamedSecurityInfoA( pObjectName : PAnsiChar; ObjectType : SE_OBJECT_TYPE; SecurityInfo : SECURITY_INFORMATION; ppsidOwner, ppsidGroup : PPSID; ppDacl, ppSacl : PACL) : DWORD');
 CL.AddDelphiFunction('Function SetNamedSecurityInfoW( pObjectName : PAnsiChar; ObjectType : SE_OBJECT_TYPE; SecurityInfo : SECURITY_INFORMATION; ppsidOwner, ppsidGroup : PPSID; ppDacl, ppSacl : PACL) : DWORD');
 CL.AddDelphiFunction('Function SetSecurityInfo( handle : THandle; ObjectType : SE_OBJECT_TYPE; SecurityInfo : SECURITY_INFORMATION; ppsidOwner, ppsidGroup : PPSID; ppDacl, ppSacl : PACL) : DWORD');
 //CL.AddDelphiFunction('Function BuildSecurityDescriptor( pOwner, pGroup : PTRUSTEE_; cCountOfAccessEntries : ULONG; pListOfAccessEntries : PEXPLICIT_ACCESS_; cCountOfAuditEntries : ULONG; pListOfAuditEntries : PEXPLICIT_ACCESS_; pOldSD : PSECURITY_DESCRIPTOR; var pSizeNewSD : ULONG; var pNewSD : SECURITY_DESCRIPTOR) : DWORD');
 //CL.AddDelphiFunction('Function BuildSecurityDescriptorA( pOwner, pGroup : PTRUSTEE_A; cCountOfAccessEntries : ULONG; pListOfAccessEntries : PEXPLICIT_ACCESS_A; cCountOfAuditEntries : ULONG; pListOfAuditEntries : PEXPLICIT_ACCESS_A; pOldSD : PSECURITY_DESCRIPTOR; var pSizeNewSD : ULONG; var pNewSD : SECURITY_DESCRIPTOR) : DWORD');
 //CL.AddDelphiFunction('Function BuildSecurityDescriptorW( pOwner, pGroup : PTRUSTEE_W; cCountOfAccessEntries : ULONG; pListOfAccessEntries : PEXPLICIT_ACCESS_W; cCountOfAuditEntries : ULONG; pListOfAuditEntries : PEXPLICIT_ACCESS_W; pOldSD : PSECURITY_DESCRIPTOR; var pSizeNewSD : ULONG; var pNewSD : SECURITY_DESCRIPTOR) : DWORD');
 CL.AddDelphiFunction('Function LookupSecurityDescriptorParts( pOwner, pGroup : PTRUSTEE_; cCountOfAccessEntries : PULONG; pListOfAccessEntries : PEXPLICIT_ACCESS_; cCountOfAuditEntries : PULONG; pListOfAuditEntries : PEXPLICIT_ACCESS_; var pSD : SECURITY_DESCRIPTOR) : DWORD');
 //CL.AddDelphiFunction('Function LookupSecurityDescriptorPartsA( pOwner, pGroup : PTRUSTEE_A; cCountOfAccessEntries : PULONG; pListOfAccessEntries : PEXPLICIT_ACCESS_A; cCountOfAuditEntries : PULONG; pListOfAuditEntries : PEXPLICIT_ACCESS_A; var pSD : SECURITY_DESCRIPTOR) : DWORD');
 //CL.AddDelphiFunction('Function LookupSecurityDescriptorPartsW( pOwner, pGroup : PTRUSTEE_W; cCountOfAccessEntries : PULONG; pListOfAccessEntries : PEXPLICIT_ACCESS_W; cCountOfAuditEntries : PULONG; pListOfAuditEntries : PEXPLICIT_ACCESS_W; var pSD : SECURITY_DESCRIPTOR) : DWORD');
 CL.AddDelphiFunction('Procedure BuildExplicitAccessWithName( pExplicitAccess : PEXPLICIT_ACCESS_; pTrusteeName : PAnsiChar; AccessPermissions : DWORD; AccessMode : ACCESS_MODE; Ineritance : DWORD)');
 CL.AddDelphiFunction('Procedure BuildExplicitAccessWithNameA( pExplicitAccess : PEXPLICIT_ACCESS_A; pTrusteeName : PAnsiChar; AccessPermissions : DWORD; AccessMode : ACCESS_MODE; Ineritance : DWORD)');
 CL.AddDelphiFunction('Procedure BuildExplicitAccessWithNameW( pExplicitAccess : PEXPLICIT_ACCESS_W; pTrusteeName : PAnsiChar; AccessPermissions : DWORD; AccessMode : ACCESS_MODE; Ineritance : DWORD)');
 CL.AddDelphiFunction('Procedure BuildImpersonateExplicitAccessWithName( pExplicitAccess : PEXPLICIT_ACCESS_; pTrusteeName : PAnsiChar; pTrustee : PTRUSTEE_; AccessPermissions : DWORD; AccessMode : ACCESS_MODE; Inheritance : DWORD)');
 CL.AddDelphiFunction('Procedure BuildImpersonateExplicitAccessWithNameA( pExplicitAccess : PEXPLICIT_ACCESS_A; pTrusteeName : PAnsiChar; pTrustee : PTRUSTEE_A; AccessPermissions : DWORD; AccessMode : ACCESS_MODE; Inheritance : DWORD)');
 CL.AddDelphiFunction('Procedure BuildImpersonateExplicitAccessWithNameW( pExplicitAccess : PEXPLICIT_ACCESS_W; pTrusteeName : PAnsiChar; pTrustee : PTRUSTEE_W; AccessPermissions : DWORD; AccessMode : ACCESS_MODE; Inheritance : DWORD)');
 CL.AddDelphiFunction('Procedure BuildTrusteeWithName( pTrustee : PTRUSTEE_; pName : PAnsiChar)');
 CL.AddDelphiFunction('Procedure BuildTrusteeWithNameA( pTrustee : PTRUSTEE_A; pName : PAnsiChar)');
 CL.AddDelphiFunction('Procedure BuildTrusteeWithNameW( pTrustee : PTRUSTEE_W; pName : PAnsiChar)');
 CL.AddDelphiFunction('Procedure BuildImpersonateTrustee( pTrustee : PTRUSTEE_; pImpersonateTrustee : PTRUSTEE_)');
 CL.AddDelphiFunction('Procedure BuildImpersonateTrusteeA( pTrustee : PTRUSTEE_A; pImpersonateTrustee : PTRUSTEE_A)');
 CL.AddDelphiFunction('Procedure BuildImpersonateTrusteeW( pTrustee : PTRUSTEE_W; pImpersonateTrustee : PTRUSTEE_W)');
 CL.AddDelphiFunction('Procedure BuildTrusteeWithSid( pTrustee : PTRUSTEE_; pSidIn : PSID)');
 CL.AddDelphiFunction('Procedure BuildTrusteeWithSidA( pTrustee : PTRUSTEE_A; pSidIn : PSID)');
 CL.AddDelphiFunction('Procedure BuildTrusteeWithSidW( pTrustee : PTRUSTEE_W; pSidIn : PSID)');
 CL.AddDelphiFunction('Function GetTrusteeName( var pTrustee : TRUSTEE_) : PAnsiChar');
 CL.AddDelphiFunction('Function GetTrusteeNameA( var pTrustee : TRUSTEE_A) : PAnsiChar');
 CL.AddDelphiFunction('Function GetTrusteeNameW( var pTrustee : TRUSTEE_W) : PAnsiChar');
 CL.AddDelphiFunction('Function GetTrusteeType( var pTrustee : TRUSTEE_) : TRUSTEE_TYPE');
 CL.AddDelphiFunction('Function GetTrusteeTypeA( var pTrustee : TRUSTEE_A) : TRUSTEE_TYPE');
 CL.AddDelphiFunction('Function GetTrusteeTypeW( var pTrustee : TRUSTEE_W) : TRUSTEE_TYPE');
 CL.AddDelphiFunction('Function GetTrusteeForm( var pTrustee : TRUSTEE_) : TRUSTEE_FORM');
 CL.AddDelphiFunction('Function GetTrusteeFormA( var pTrustee : TRUSTEE_A) : TRUSTEE_FORM');
 CL.AddDelphiFunction('Function GetTrusteeFormW( var pTrustee : TRUSTEE_W) : TRUSTEE_FORM');
 CL.AddDelphiFunction('Function GetMultipleTrusteeOperation( pTrustee : PTRUSTEE_) : MULTIPLE_TRUSTEE_OPERATION');
 CL.AddDelphiFunction('Function GetMultipleTrusteeOperationA( pTrustee : PTRUSTEE_A) : MULTIPLE_TRUSTEE_OPERATION');
 CL.AddDelphiFunction('Function GetMultipleTrusteeOperationW( pTrustee : PTRUSTEE_W) : MULTIPLE_TRUSTEE_OPERATION');
 CL.AddDelphiFunction('Function GetMultipleTrustee( pTrustee : PTrustee_) : PTRUSTEE_');
 CL.AddDelphiFunction('Function GetMultipleTrusteeA( pTrustee : PTrustee_A) : PTRUSTEE_A');
 CL.AddDelphiFunction('Function GetMultipleTrusteeW( pTrustee : PTrustee_W) : PTRUSTEE_W');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_AclAPI_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetEntriesInAcl, 'SetEntriesInAcl', CdStdCall);
 S.RegisterDelphiFunction(@SetEntriesInAclA, 'SetEntriesInAclA', CdStdCall);
 S.RegisterDelphiFunction(@SetEntriesInAclW, 'SetEntriesInAclW', CdStdCall);
 S.RegisterDelphiFunction(@GetExplicitEntriesFromAcl, 'GetExplicitEntriesFromAcl', CdStdCall);
 S.RegisterDelphiFunction(@GetExplicitEntriesFromAclA, 'GetExplicitEntriesFromAclA', CdStdCall);
 S.RegisterDelphiFunction(@GetExplicitEntriesFromAclW, 'GetExplicitEntriesFromAclW', CdStdCall);
 S.RegisterDelphiFunction(@GetEffectiveRightsFromAcl, 'GetEffectiveRightsFromAcl', CdStdCall);
 S.RegisterDelphiFunction(@GetEffectiveRightsFromAclA, 'GetEffectiveRightsFromAclA', CdStdCall);
 S.RegisterDelphiFunction(@GetEffectiveRightsFromAclW, 'GetEffectiveRightsFromAclW', CdStdCall);
 S.RegisterDelphiFunction(@GetAuditedPermissionsFromAcl, 'GetAuditedPermissionsFromAcl', CdStdCall);
 S.RegisterDelphiFunction(@GetAuditedPermissionsFromAclA, 'GetAuditedPermissionsFromAclA', CdStdCall);
 S.RegisterDelphiFunction(@GetAuditedPermissionsFromAclW, 'GetAuditedPermissionsFromAclW', CdStdCall);
 S.RegisterDelphiFunction(@GetNamedSecurityInfo, 'GetNamedSecurityInfo', CdStdCall);
 S.RegisterDelphiFunction(@GetNamedSecurityInfoA, 'GetNamedSecurityInfoA', CdStdCall);
 S.RegisterDelphiFunction(@GetNamedSecurityInfoW, 'GetNamedSecurityInfoW', CdStdCall);
 S.RegisterDelphiFunction(@GetSecurityInfo, 'GetSecurityInfo', CdStdCall);
 S.RegisterDelphiFunction(@SetNamedSecurityInfo, 'SetNamedSecurityInfo', CdStdCall);
 S.RegisterDelphiFunction(@SetNamedSecurityInfoA, 'SetNamedSecurityInfoA', CdStdCall);
 S.RegisterDelphiFunction(@SetNamedSecurityInfoW, 'SetNamedSecurityInfoW', CdStdCall);
 S.RegisterDelphiFunction(@SetSecurityInfo, 'SetSecurityInfo', CdStdCall);
 S.RegisterDelphiFunction(@BuildSecurityDescriptor, 'BuildSecurityDescriptor', CdStdCall);
 S.RegisterDelphiFunction(@BuildSecurityDescriptorA, 'BuildSecurityDescriptorA', CdStdCall);
 S.RegisterDelphiFunction(@BuildSecurityDescriptorW, 'BuildSecurityDescriptorW', CdStdCall);
 S.RegisterDelphiFunction(@LookupSecurityDescriptorParts, 'LookupSecurityDescriptorParts', CdStdCall);
 S.RegisterDelphiFunction(@LookupSecurityDescriptorPartsA, 'LookupSecurityDescriptorPartsA', CdStdCall);
 S.RegisterDelphiFunction(@LookupSecurityDescriptorPartsW, 'LookupSecurityDescriptorPartsW', CdStdCall);
 S.RegisterDelphiFunction(@BuildExplicitAccessWithName, 'BuildExplicitAccessWithName', CdStdCall);
 S.RegisterDelphiFunction(@BuildExplicitAccessWithNameA, 'BuildExplicitAccessWithNameA', CdStdCall);
 S.RegisterDelphiFunction(@BuildExplicitAccessWithNameW, 'BuildExplicitAccessWithNameW', CdStdCall);
 S.RegisterDelphiFunction(@BuildImpersonateExplicitAccessWithName, 'BuildImpersonateExplicitAccessWithName', CdStdCall);
 S.RegisterDelphiFunction(@BuildImpersonateExplicitAccessWithNameA, 'BuildImpersonateExplicitAccessWithNameA', CdStdCall);
 S.RegisterDelphiFunction(@BuildImpersonateExplicitAccessWithNameW, 'BuildImpersonateExplicitAccessWithNameW', CdStdCall);
 S.RegisterDelphiFunction(@BuildTrusteeWithName, 'BuildTrusteeWithName', CdStdCall);
 S.RegisterDelphiFunction(@BuildTrusteeWithNameA, 'BuildTrusteeWithNameA', CdStdCall);
 S.RegisterDelphiFunction(@BuildTrusteeWithNameW, 'BuildTrusteeWithNameW', CdStdCall);
 S.RegisterDelphiFunction(@BuildImpersonateTrustee, 'BuildImpersonateTrustee', CdStdCall);
 S.RegisterDelphiFunction(@BuildImpersonateTrusteeA, 'BuildImpersonateTrusteeA', CdStdCall);
 S.RegisterDelphiFunction(@BuildImpersonateTrusteeW, 'BuildImpersonateTrusteeW', CdStdCall);
 S.RegisterDelphiFunction(@BuildTrusteeWithSid, 'BuildTrusteeWithSid', CdStdCall);
 S.RegisterDelphiFunction(@BuildTrusteeWithSidA, 'BuildTrusteeWithSidA', CdStdCall);
 S.RegisterDelphiFunction(@BuildTrusteeWithSidW, 'BuildTrusteeWithSidW', CdStdCall);
 S.RegisterDelphiFunction(@GetTrusteeName, 'GetTrusteeName', CdStdCall);
 S.RegisterDelphiFunction(@GetTrusteeNameA, 'GetTrusteeNameA', CdStdCall);
 S.RegisterDelphiFunction(@GetTrusteeNameW, 'GetTrusteeNameW', CdStdCall);
 S.RegisterDelphiFunction(@GetTrusteeType, 'GetTrusteeType', CdStdCall);
 S.RegisterDelphiFunction(@GetTrusteeTypeA, 'GetTrusteeTypeA', CdStdCall);
 S.RegisterDelphiFunction(@GetTrusteeTypeW, 'GetTrusteeTypeW', CdStdCall);
 S.RegisterDelphiFunction(@GetTrusteeForm, 'GetTrusteeForm', CdStdCall);
 S.RegisterDelphiFunction(@GetTrusteeFormA, 'GetTrusteeFormA', CdStdCall);
 S.RegisterDelphiFunction(@GetTrusteeFormW, 'GetTrusteeFormW', CdStdCall);
 S.RegisterDelphiFunction(@GetMultipleTrusteeOperation, 'GetMultipleTrusteeOperation', CdStdCall);
 S.RegisterDelphiFunction(@GetMultipleTrusteeOperationA, 'GetMultipleTrusteeOperationA', CdStdCall);
 S.RegisterDelphiFunction(@GetMultipleTrusteeOperationW, 'GetMultipleTrusteeOperationW', CdStdCall);
 S.RegisterDelphiFunction(@GetMultipleTrustee, 'GetMultipleTrustee', CdStdCall);
 S.RegisterDelphiFunction(@GetMultipleTrusteeA, 'GetMultipleTrusteeA', CdStdCall);
 S.RegisterDelphiFunction(@GetMultipleTrusteeW, 'GetMultipleTrusteeW', CdStdCall);
end;

 
 
{ TPSImport_AclAPI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AclAPI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AclAPI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AclAPI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_AclAPI(ri);
  RIRegister_AclAPI_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
