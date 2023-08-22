unit uPSI_cySysUtils;
{
   of cindy
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
  TPSImport_cySysUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cySysUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cySysUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   cySysUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cySysUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cySysUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function IsFolder( SRec : TSearchrec) : Boolean');
 CL.AddDelphiFunction('Function isFolderReadOnly( Directory : String) : Boolean');
 CL.AddDelphiFunction('Function DirectoryIsEmpty( Directory : String) : Boolean');
 CL.AddDelphiFunction('Function DirectoryWithSubDir( Directory : String) : Boolean');
 CL.AddDelphiFunction('Procedure GetSubDirs( FromDirectory : String; aList : TStrings)');
 CL.AddDelphiFunction('Function DiskFreeBytes( Drv : Char) : Int64');
 CL.AddDelphiFunction('Function DiskBytes( Drv : Char) : Int64');
 CL.AddDelphiFunction('Function GetFileBytes( Filename : String) : Int64');
 CL.AddDelphiFunction('Function GetFilesBytes( Directory, Filter : String) : Int64');
 CL.AddConstantN('SE_CREATE_TOKEN_NAME','String').SetString( 'SeCreateTokenPrivilege');
 CL.AddConstantN('SE_ASSIGNPRIMARYTOKEN_NAME','String').SetString( 'SeAssignPrimaryTokenPrivilege');
 CL.AddConstantN('SE_LOCK_MEMORY_NAME','String').SetString( 'SeLockMemoryPrivilege');
 CL.AddConstantN('SE_INCREASE_QUOTA_NAME','String').SetString( 'SeIncreaseQuotaPrivilege');
 CL.AddConstantN('SE_UNSOLICITED_INPUT_NAME','String').SetString( 'SeUnsolicitedInputPrivilege');
 CL.AddConstantN('SE_MACHINE_ACCOUNT_NAME','String').SetString( 'SeMachineAccountPrivilege');
 CL.AddConstantN('SE_TCB_NAME','String').SetString( 'SeTcbPrivilege');
 CL.AddConstantN('SE_SECURITY_NAME','String').SetString( 'SeSecurityPrivilege');
 CL.AddConstantN('SE_TAKE_OWNERSHIP_NAME','String').SetString( 'SeTakeOwnershipPrivilege');
 CL.AddConstantN('SE_LOAD_DRIVER_NAME','String').SetString( 'SeLoadDriverPrivilege');
 CL.AddConstantN('SE_SYSTEM_PROFILE_NAME','String').SetString( 'SeSystemProfilePrivilege');
 CL.AddConstantN('SE_SYSTEMTIME_NAME','String').SetString( 'SeSystemtimePrivilege');
 CL.AddConstantN('SE_PROF_SINGLE_PROCESS_NAME','String').SetString( 'SeProfileSingleProcessPrivilege');
 CL.AddConstantN('SE_INC_BASE_PRIORITY_NAME','String').SetString( 'SeIncreaseBasePriorityPrivilege');
 CL.AddConstantN('SE_CREATE_PAGEFILE_NAME','String').SetString( 'SeCreatePagefilePrivilege');
 CL.AddConstantN('SE_CREATE_PERMANENT_NAME','String').SetString( 'SeCreatePermanentPrivilege');
 CL.AddConstantN('SE_BACKUP_NAME','String').SetString( 'SeBackupPrivilege');
 CL.AddConstantN('SE_RESTORE_NAME','String').SetString( 'SeRestorePrivilege');
 CL.AddConstantN('SE_SHUTDOWN_NAME','String').SetString( 'SeShutdownPrivilege');
 CL.AddConstantN('SE_DEBUG_NAME','String').SetString( 'SeDebugPrivilege');
 CL.AddConstantN('SE_AUDIT_NAME','String').SetString( 'SeAuditPrivilege');
 CL.AddConstantN('SE_SYSTEM_ENVIRONMENT_NAME','String').SetString( 'SeSystemEnvironmentPrivilege');
 CL.AddConstantN('SE_CHANGE_NOTIFY_NAME','String').SetString( 'SeChangeNotifyPrivilege');
 CL.AddConstantN('SE_REMOTE_SHUTDOWN_NAME','String').SetString( 'SeRemoteShutdownPrivilege');
 CL.AddConstantN('SE_UNDOCK_NAME','String').SetString( 'SeUndockPrivilege');
 CL.AddConstantN('SE_SYNC_AGENT_NAME','String').SetString( 'SeSyncAgentPrivilege');
 CL.AddConstantN('SE_ENABLE_DELEGATION_NAME','String').SetString( 'SeEnableDelegationPrivilege');
 CL.AddConstantN('SE_MANAGE_VOLUME_NAME','String').SetString( 'SeManageVolumePrivilege');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_cySysUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsFolder, 'IsFolder', cdRegister);
 S.RegisterDelphiFunction(@isFolderReadOnly, 'isFolderReadOnly', cdRegister);
 S.RegisterDelphiFunction(@DirectoryIsEmpty, 'DirectoryIsEmpty', cdRegister);
 S.RegisterDelphiFunction(@DirectoryWithSubDir, 'DirectoryWithSubDir', cdRegister);
 S.RegisterDelphiFunction(@GetSubDirs, 'GetSubDirs', cdRegister);
 S.RegisterDelphiFunction(@DiskFreeBytes, 'DiskFreeBytes', cdRegister);
 S.RegisterDelphiFunction(@DiskBytes, 'DiskBytes', cdRegister);
 S.RegisterDelphiFunction(@GetFileBytes, 'GetFileBytes', cdRegister);
 S.RegisterDelphiFunction(@GetFilesBytes, 'GetFilesBytes', cdRegister);
end;

 
 
{ TPSImport_cySysUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cySysUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cySysUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cySysUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cySysUtils(ri);
  RIRegister_cySysUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
