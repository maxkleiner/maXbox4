unit uPSI_JclSecurity;
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
  TPSImport_JclSecurity = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclSecurity(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclSecurity_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,JclBase
  ,JclSecurity
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclSecurity]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclSecurity(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function AllowRegKeyForEveryone( Key : HKEY; Path : string) : Boolean');
 //CL.AddDelphiFunction('Function CreateNullDacl( var Sa : TSecurityAttributes; const Inheritable : Boolean) : PSecurityAttributes');
 //CL.AddDelphiFunction('Function CreateInheritable( var Sa : TSecurityAttributes) : PSecurityAttributes');
 CL.AddDelphiFunction('Function IsAdministrator : Boolean');
 CL.AddDelphiFunction('Function IsAdmin: Boolean');
 CL.AddDelphiFunction('Function EnableProcessPrivilege( const Enable : Boolean; const Privilege : string) : Boolean');
 CL.AddDelphiFunction('Function EnableThreadPrivilege( const Enable : Boolean; const Privilege : string) : Boolean');
 CL.AddDelphiFunction('Function IsPrivilegeEnabled( const Privilege : string) : Boolean');
 CL.AddDelphiFunction('Function GetPrivilegeDisplayName( const PrivilegeName : string) : string');
 CL.AddDelphiFunction('Function SetUserObjectFullAccess( hUserObject : THandle) : Boolean');
 CL.AddDelphiFunction('Function GetUserObjectName( hUserObject : THandle) : string');
 //CL.AddDelphiFunction('Procedure LookupAccountBySid( Sid : PSID; var Name, Domain : string)');
 //CL.AddDelphiFunction('Procedure QueryTokenInformation( Token : THandle; InformationClass : TTokenInformationClass; var Buffer : Pointer)');
 CL.AddDelphiFunction('Function GetInteractiveUserName : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JclSecurity_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AllowRegKeyForEveryone, 'AllowRegKeyForEveryone', cdRegister);
 S.RegisterDelphiFunction(@CreateNullDacl, 'CreateNullDacl', cdRegister);
 S.RegisterDelphiFunction(@CreateInheritable, 'CreateInheritable', cdRegister);
 S.RegisterDelphiFunction(@IsAdministrator, 'IsAdministrator', cdRegister);
 S.RegisterDelphiFunction(@IsAdministrator, 'IsAdmin', cdRegister);
 S.RegisterDelphiFunction(@EnableProcessPrivilege, 'EnableProcessPrivilege', cdRegister);
 S.RegisterDelphiFunction(@EnableThreadPrivilege, 'EnableThreadPrivilege', cdRegister);
 S.RegisterDelphiFunction(@IsPrivilegeEnabled, 'IsPrivilegeEnabled', cdRegister);
 S.RegisterDelphiFunction(@GetPrivilegeDisplayName, 'GetPrivilegeDisplayName', cdRegister);
 S.RegisterDelphiFunction(@SetUserObjectFullAccess, 'SetUserObjectFullAccess', cdRegister);
 S.RegisterDelphiFunction(@GetUserObjectName, 'GetUserObjectName', cdRegister);
 S.RegisterDelphiFunction(@LookupAccountBySid, 'LookupAccountBySid', cdRegister);
 S.RegisterDelphiFunction(@QueryTokenInformation, 'QueryTokenInformation', cdRegister);
 S.RegisterDelphiFunction(@GetInteractiveUserName, 'GetInteractiveUserName', cdRegister);
end;

 
 
{ TPSImport_JclSecurity }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSecurity.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclSecurity(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSecurity.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclSecurity(ri);
  RIRegister_JclSecurity_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
