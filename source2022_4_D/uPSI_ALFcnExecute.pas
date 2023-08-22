unit uPSI_ALFcnExecute;
{
   exec ex   uPSI_ALExecute2
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
  TPSImport_ALFcnExecute = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ALFcnExecute(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALFcnExecute_Routines(S: TPSExec);

procedure Register;

implementation


uses
   windows
  ,ALFcnExecute
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFcnExecute]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFcnExecute(CL: TPSPascalCompiler);
begin
 // CL.AddTypeS('TStartupInfoA', 'TStartupInfo');
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
 CL.AddDelphiFunction('Function AlGetEnvironmentString : AnsiString');
 CL.AddDelphiFunction('Function ALWinExec32( const FileName, CurrentDirectory, Environment : AnsiString; InputStream : Tstream; OutputStream : TStream) : Dword;');
 CL.AddDelphiFunction('Function ALWinExec321( const FileName : AnsiString; InputStream : Tstream; OutputStream : TStream) : Dword;');
 CL.AddDelphiFunction('Function ALWinExecAndWait32( FileName : AnsiString; Visibility : integer) : DWORD');
 CL.AddDelphiFunction('Function ALWinExecAndWait32V2( FileName : AnsiString; Visibility : integer) : DWORD');
 CL.AddDelphiFunction('Function ALNTSetPrivilege( sPrivilege : AnsiString; bEnabled : Boolean) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ALWinExec321_P( const FileName : AnsiString; InputStream : Tstream; OutputStream : TStream) : Dword;
Begin Result := ALFcnExecute.ALWinExec32(FileName, InputStream, OutputStream); END;

(*----------------------------------------------------------------------------*)
Function ALWinExec32_P( const FileName, CurrentDirectory, Environment : AnsiString; InputStream : Tstream; OutputStream : TStream) : Dword;
Begin Result := ALFcnExecute.ALWinExec32(FileName, CurrentDirectory, Environment, InputStream, OutputStream); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFcnExecute_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AlGetEnvironmentString, 'AlGetEnvironmentString', cdRegister);
 S.RegisterDelphiFunction(@ALWinExec32_P, 'ALWinExec32', cdRegister);
 S.RegisterDelphiFunction(@ALWinExec321_P, 'ALWinExec321', cdRegister);
 S.RegisterDelphiFunction(@ALWinExecAndWait32, 'ALWinExecAndWait32', cdRegister);
 S.RegisterDelphiFunction(@ALWinExecAndWait32V2, 'ALWinExecAndWait32V2', cdRegister);
 S.RegisterDelphiFunction(@ALNTSetPrivilege, 'ALNTSetPrivilege', cdRegister);
end;

 
 
{ TPSImport_ALFcnExecute }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnExecute.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFcnExecute(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnExecute.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ALFcnExecute(ri);
  RIRegister_ALFcnExecute_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
