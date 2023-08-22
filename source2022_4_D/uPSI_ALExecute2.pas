unit uPSI_ALExecute2;
{
Texecute a second one    ALEXEC  uPSI_ALFcnExecute;  for runner
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
  TPSImport_ALExecute = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ALExecute2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALExecute_Routines2(S: TPSExec);

procedure Register;

implementation


uses
   ALExecute2, Windows
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALExecute]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ALExecute2(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TStartupInfoA', 'TStartupInfo');
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
 CL.AddDelphiFunction('Function AlGetEnvironmentStringX : AnsiString');
 CL.AddDelphiFunction('Function ALWinExec0X( const aCommandLine : AnsiString; const aCurrentDirectory : AnsiString; const aEnvironment : AnsiString; const aInputStream : Tstream; const aOutputStream : TStream; const aOwnerThread : TThread) : Dword;');
 CL.AddDelphiFunction('Function ALWinExec1X( const aCommandLine : AnsiString; const aInputStream : Tstream; const aOutputStream : TStream; const aOwnerThread : TThread) : Dword;');
 CL.AddDelphiFunction('Procedure ALWinExec2X( const aCommandLine : AnsiString; const aCurrentDirectory : AnsiString);');
 CL.AddDelphiFunction('Procedure ALWinExec3X( const aUserName : ANSIString; const aPassword : ANSIString; const aCommandLine : ANSIString; const aCurrentDirectory : AnsiString; const aLogonFlags : dword);');
 CL.AddDelphiFunction('Function ALWinExecAndWait4X( const aCommandLine : AnsiString; const aCurrentDirectory : AnsiString; const aEnvironment : AnsiString; const aVisibility : integer) : DWORD;');
 CL.AddDelphiFunction('Function ALWinExecAndWait5X( const aCommandLine : AnsiString; const aVisibility : integer) : DWORD;');
 CL.AddDelphiFunction('Function ALWinExecAndWaitV2X( const aCommandLine : AnsiString; const aVisibility : integer) : DWORD');
 CL.AddDelphiFunction('Function ALNTSetPrivilegeX( const sPrivilege : AnsiString; bEnabled : Boolean) : Boolean');
 CL.AddDelphiFunction('Function ALStartServiceX( const aServiceName : AnsiString; const aComputerName : AnsiString; const aTimeOut : integer) : boolean');
 CL.AddDelphiFunction('Function ALStopServiceX( const aServiceName : AnsiString; const aComputerName : AnsiString; const aTimeOut : integer) : boolean');
 CL.AddDelphiFunction('Function ALMakeServiceAutorestartingX( const aServiceName : AnsiString; const aComputerName : AnsiString; const aTimeToRestartInSec : integer; const aTimeToResetInSec : integer) : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ALWinExecAndWait5_P( const aCommandLine : AnsiString; const aVisibility : integer) : Dword;
Begin Result := ALExecute2.ALWinExecAndWait(aCommandLine, aVisibility); END;

(*----------------------------------------------------------------------------*)
Function ALWinExecAndWait4_P( const aCommandLine : AnsiString; const aCurrentDirectory : AnsiString; const aEnvironment : AnsiString; const aVisibility : integer) : DWORD;
Begin Result := ALExecute2.ALWinExecAndWait(aCommandLine, aCurrentDirectory, aEnvironment, aVisibility); END;

(*----------------------------------------------------------------------------*)
Procedure ALWinExec3_P( const aUserName : ANSIString; const aPassword : ANSIString; const aCommandLine : ANSIString; const aCurrentDirectory : AnsiString; const aLogonFlags : dword);
Begin ALExecute2.ALWinExec(aUserName, aPassword, aCommandLine, aCurrentDirectory, aLogonFlags); END;

(*----------------------------------------------------------------------------*)
Procedure ALWinExec2_P( const aCommandLine : AnsiString; const aCurrentDirectory : AnsiString);
Begin ALExecute2.ALWinExec(aCommandLine, aCurrentDirectory); END;

(*----------------------------------------------------------------------------*)
Function ALWinExec1_P( const aCommandLine : AnsiString; const aInputStream : Tstream; const aOutputStream : TStream; const aOwnerThread : TThread) : Dword;
Begin Result := ALExecute2.ALWinExec(aCommandLine, aInputStream, aOutputStream, aOwnerThread); END;

(*----------------------------------------------------------------------------*)
Function ALWinExec0_P( const aCommandLine : AnsiString; const aCurrentDirectory : AnsiString; const aEnvironment : AnsiString; const aInputStream : Tstream; const aOutputStream : TStream; const aOwnerThread : TThread) : Dword;
Begin Result := ALExecute2.ALWinExec(aCommandLine, aCurrentDirectory, aEnvironment, aInputStream, aOutputStream, aOwnerThread); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALExecute_Routines2(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AlGetEnvironmentString, 'AlGetEnvironmentStringX', cdRegister);
 S.RegisterDelphiFunction(@ALWinExec0_P, 'ALWinExec0X', cdRegister);
 S.RegisterDelphiFunction(@ALWinExec1_P, 'ALWinExec1X', cdRegister);
 S.RegisterDelphiFunction(@ALWinExec2_P, 'ALWinExec2X', cdRegister);
 S.RegisterDelphiFunction(@ALWinExec3_P, 'ALWinExec3X', cdRegister);
 S.RegisterDelphiFunction(@ALWinExecAndWait4_P, 'ALWinExecAndWait4X', cdRegister);
 S.RegisterDelphiFunction(@ALWinExecAndWait5_P, 'ALWinExecAndWait5X', cdRegister);
 S.RegisterDelphiFunction(@ALWinExecAndWaitV2, 'ALWinExecAndWaitV2X', cdRegister);
 S.RegisterDelphiFunction(@ALNTSetPrivilege, 'ALNTSetPrivilegeX', cdRegister);
 S.RegisterDelphiFunction(@ALStartService, 'ALStartServiceX', cdRegister);
 S.RegisterDelphiFunction(@ALStopService, 'ALStopServiceX', cdRegister);
 S.RegisterDelphiFunction(@ALMakeServiceAutorestarting, 'ALMakeServiceAutorestartingX', cdRegister);
end;



{ TPSImport_ALExecute }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALExecute.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALExecute2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALExecute.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALExecute_Routines2(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
