unit uPSI_KLibWindows;
{
ask hereby for Karol in https://github.com/karoloortiz/Delphi_Utils_Library/issues/2

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
  TPSImport_KLibWindows = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_KLibWindows(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_KLibWindows_Routines(S: TPSExec);

procedure Register;

implementation


uses
   KLibWindows
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_KLibWindows]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_KLibWindows(CL: TPSPascalCompiler);
begin
 //CL.AddDelphiFunction('Procedure downloadFile( info : TDownloadInfo; forceOverwrite : boolean)');
 CL.AddDelphiFunction('Function getFirstPortAvaliableklib( defaultPort : integer; host : string) : integer');
 CL.AddDelphiFunction('Function checkIfPortIsAvaliableklib( host : string; port : Word) : boolean');
 CL.AddDelphiFunction('Function checkIfAddressIsLocalhostklib( address : string) : boolean');
 CL.AddDelphiFunction('Function getIPFromHostNameklib( hostName : string) : string');
 CL.AddDelphiFunction('Function getIPklib : string');
 CL.AddDelphiFunction('Function checkIfRunUnderWineklib : boolean');
 CL.AddDelphiFunction('Function checkIfWindowsArchitectureIsX64klib : boolean');
  CL.AddTypeS('TPIDCredentials', 'record ownerUserName : string; domain : string; end');
  CL.AddTypeS('TWindowsArchitectureklib', '( WindowsX86, WindowsX64 )');
 CL.AddDelphiFunction('Function getWindowsArchitectureklib : TWindowsArchitectureklib');
 CL.AddDelphiFunction('Function checkIfUserIsAdminklib : boolean');
 CL.AddDelphiFunction('Function IsUserAnAdminklib : boolean');
  CL.AddTypeS('TShowWindowType', '( _SW_HIDE, _SW_SHOWNORMAL, _SW_NORMAL, _SW_S'
   +'HOWMINIMIZED, _SW_SHOWMAXIMIZED, _SW_MAXIMIZE, _SW_SHOWNOACTIVATE, _SW_SHO'
   +'W, _SW_MINIMIZE, _SW_SHOWMINNOACTIVE, _SW_SHOWNA, _SW_RESTORE, _SW_SHOWDEFAULT, _SW_FORCEMINIMIZE, _SW_MAX )');
 CL.AddDelphiFunction('Procedure openWebPageWithDefaultBrowserklib( url : string)');
 CL.AddDelphiFunction('Function shellExecuteOpenklib( fileName : string; params : string; directory : string; showWindowType : TShowWindowType; exceptionIfFunctionFails : boolean) : integer');
 CL.AddDelphiFunction('Function shellExecuteExeAsAdminklib( fileName : string; params : string; showWindowType : TShowWindowType; exceptionIfFunctionFails : boolean) : integer');
 CL.AddDelphiFunction('Function shellExecuteExeklib( fileName : string; params : string; showWindowType : TShowWindowType; exceptionIfFunctionFails : boolean; operation : string) : integer');
 CL.AddDelphiFunction('Function myShellExecuteklib( handle : integer; operation : string; fileName : string; params : string; directory : string; showWindowType : TShowWindowType; exceptionIfFunctionFails : boolean) : integer');
 CL.AddDelphiFunction('Function shellExecuteExCMDAndWaitklib( params : string; runAsAdmin : boolean; showWindowType : TShowWindowType; exceptionIfReturnCodeIsNot0 : boolean) : LongInt');
 CL.AddDelphiFunction('Function shellExecuteExAndWaitklib( fileName : string; params : string; runAsAdmin : boolean; showWindowType : TShowWindowType; exceptionIfReturnCodeIsNot0 : boolean) : LongInt');
 CL.AddDelphiFunction('Function executeAndWaitExeklib( fileName : string; params : string; exceptionIfReturnCodeIsNot0 : boolean) : LongInt');
 CL.AddDelphiFunction('Function netShareklib( targetDir : string; netName : string; netPassw : string; grantAllPermissionToEveryoneGroup : boolean) : string');
 CL.AddDelphiFunction('Procedure addTCP_IN_FirewallExceptionklib( ruleName : string; port : Word; description : string; grouping : string; executable : string)');
 CL.AddDelphiFunction('Procedure deleteFirewallExceptionklib( ruleName : string)');
 // CL.AddTypeS('TExplicitAccess', 'EXPLICIT_ACCESS_A');
 CL.AddDelphiFunction('Procedure grantAllPermissionsNetToTheObjectForTheEveryoneGroupklib( myObject : string)');
 CL.AddDelphiFunction('Procedure grantAllPermissionsNetToTheObjectForTheUsersGroupklib( myObject : string)');
 CL.AddDelphiFunction('Procedure grantAllPermissionNetToTheObjectklib( windowsGroupOrUser : string; myObject : string)');
 CL.AddDelphiFunction('Procedure grantAllPermissionsToTheObjectForTheEveryoneGroupklib( myObject : string)');
 CL.AddDelphiFunction('Procedure grantAllPermissionsToTheObjectForTheUsersGroupklib( myObject : string)');
 CL.AddDelphiFunction('Procedure grantAllPermissionsToTheObjectklib( windowsGroupOrUser : string; myObject : string)');
 CL.AddDelphiFunction('Procedure grantAllPermissionsToTheObjectForTheEveryoneGroup2klib( myObject : string)');
 CL.AddDelphiFunction('Procedure grantAllPermissionsToTheObjectForTheUsersGroup2klib( myObject : string)');
 CL.AddDelphiFunction('Procedure grantAllPermissionsToTheObject2klib( windowsGroupOrUser : string; myObject : string)');
 CL.AddDelphiFunction('Function checkIfWindowsGroupOrUserExistsklib( windowsGroupOrUser : string) : boolean');
 CL.AddDelphiFunction('Procedure createDesktopLinkklib( fileName : string; nameDesktopLink : string; description : string)');
 CL.AddDelphiFunction('Function getDesktopDirPathklib : string');
 CL.AddDelphiFunction('Procedure copyDirIntoTargetDirklib( sourceDir : string; targetDir : string; forceOverwrite : boolean)');
 CL.AddDelphiFunction('Procedure copyDirklib( sourceDir : string; destinationDir : string; silent : boolean)');
 CL.AddDelphiFunction('Procedure createHideDirklib( dirName : string; forceDelete : boolean)');
 CL.AddDelphiFunction('Procedure deleteDirectoryIfExistsklib( dirName : string; silent : boolean)');
 CL.AddDelphiFunction('Procedure myMoveFileklib( sourceFileName : string; targetFileName : string)');
 CL.AddDelphiFunction('Procedure createEmptyFileIfNotExistsklib( filename : string)');
 CL.AddDelphiFunction('Procedure createEmptyFileklib( filename : string)');
 CL.AddDelphiFunction('Function checkIfIsWindowsSubDirklib( subDir : string; mainDir : string) : boolean');
 CL.AddDelphiFunction('Function getParentDirklib( source : string) : string');
 CL.AddDelphiFunction('Function getValidFullPathInWindowsStyleklib( path : string) : string');
 CL.AddDelphiFunction('Function getPathInWindowsStyleklib( path : string) : string');
 CL.AddDelphiFunction('Function getStringWithEnvVariablesReadedklib( source : string) : string');
 CL.AddDelphiFunction('Function setProcessWindowToForegroundklib( processName : string) : boolean');
 CL.AddDelphiFunction('Function getPIDOfCurrentUserByProcessNameklib( nameProcess : string) : DWORD');
 CL.AddDelphiFunction('Function getWindowsUsernameklib : string');
 CL.AddDelphiFunction('Function checkUserOfProcessklib( userName : String; PID : DWORD) : boolean');
 CL.AddDelphiFunction('Function getPIDCredentialsklib( PID : DWORD) : TPIDCredentials');
 CL.AddDelphiFunction('Function getPIDByProcessNameklib( nameProcess : string) : DWORD');
 CL.AddDelphiFunction('Function getMainWindowHandleByPIDklib( PID : DWORD) : DWORD');
 CL.AddDelphiFunction('Procedure closeApplicationklib( handle : THandle)');
 CL.AddDelphiFunction('Function sendMemoryStreamUsing_WM_COPYDATAklib( handle : THandle; data : TMemoryStream) : integer');
 CL.AddDelphiFunction('Function sendStringUsing_WM_COPYDATAklib( handle : THandle; data : string; msgIdentifier : integer) : integer');
 CL.AddDelphiFunction('Procedure mySetForegroundWindowklib( handle : THandle)');
 CL.AddDelphiFunction('Function checkIfWindowExistsklib( className : string; captionForm : string) : boolean');
 CL.AddDelphiFunction('Function myFindWindowklib( className : string; captionForm : string) : THandle');
 CL.AddDelphiFunction('Function checkIfExistsKeyIn_HKEY_LOCAL_MACHINEklib( key : string) : boolean');
 CL.AddDelphiFunction('Procedure waitForMultipleklib( processHandle : THandle; timeout : DWORD; modalMode : boolean)');
 CL.AddDelphiFunction('Procedure waitForklib( processHandle : THandle; timeout : DWORD; modalMode : boolean)');
 CL.AddDelphiFunction('Procedure raiseLastSysErrorMessageklib');
 CL.AddDelphiFunction('Function getLastSysErrorMessageklib : string');
 CL.AddDelphiFunction('Function getLocaleDecimalSeparatorklib : char');
 CL.AddDelphiFunction('Procedure terminateCurrentProcessklib( exitCode : Cardinal; raiseExceptionEnabled : boolean)');
 CL.AddDelphiFunction('Procedure myTerminateProcessklib( processHandle : THandle; exitCode : Cardinal; raiseExceptionEnabled : boolean)');
 //CL.AddDelphiFunction('Function fixedGetNamedSecurityInfo( pObjectName : LPWSTR; ObjectType : SE_OBJECT_TYPE; SecurityInfo : SECURITY_INFORMATION; ppsidOwner, ppsidGroup : PPSID; ppDacl, ppSacl : PPACL; var ppSecurityDescriptor : PSECURITY_DESCRIPTOR) : DWORD');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_KLibWindows_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@downloadFile, 'downloadFileklib', cdRegister);
 S.RegisterDelphiFunction(@getFirstPortAvaliable, 'getFirstPortAvaliableklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfPortIsAvaliable, 'checkIfPortIsAvaliableklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfAddressIsLocalhost, 'checkIfAddressIsLocalhostklib', cdRegister);
 S.RegisterDelphiFunction(@getIPFromHostName, 'getIPFromHostNameklib', cdRegister);
 S.RegisterDelphiFunction(@getIP, 'getIPklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfRunUnderWine, 'checkIfRunUnderWineklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfWindowsArchitectureIsX64, 'checkIfWindowsArchitectureIsX64klib', cdRegister);
 S.RegisterDelphiFunction(@getWindowsArchitecture, 'getWindowsArchitectureklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfUserIsAdmin, 'checkIfUserIsAdminklib', cdRegister);
 S.RegisterDelphiFunction(@IsUserAnAdmin, 'IsUserAnAdminklib', cdRegister);
 S.RegisterDelphiFunction(@openWebPageWithDefaultBrowser, 'openWebPageWithDefaultBrowserklib', cdRegister);
 S.RegisterDelphiFunction(@shellExecuteOpen, 'shellExecuteOpenklib', cdRegister);
 S.RegisterDelphiFunction(@shellExecuteExeAsAdmin, 'shellExecuteExeAsAdminklib', cdRegister);
 S.RegisterDelphiFunction(@shellExecuteExe, 'shellExecuteExeklib', cdRegister);
 S.RegisterDelphiFunction(@myShellExecute, 'myShellExecuteklib', cdRegister);
 S.RegisterDelphiFunction(@shellExecuteExCMDAndWait, 'shellExecuteExCMDAndWaitklib', cdRegister);
 S.RegisterDelphiFunction(@shellExecuteExAndWait, 'shellExecuteExAndWaitklib', cdRegister);
 S.RegisterDelphiFunction(@executeAndWaitExe, 'executeAndWaitExeklib', cdRegister);
 S.RegisterDelphiFunction(@netShare, 'netShareklib', cdRegister);
 S.RegisterDelphiFunction(@addTCP_IN_FirewallException, 'addTCP_IN_FirewallExceptionklib', cdRegister);
 S.RegisterDelphiFunction(@deleteFirewallException, 'deleteFirewallExceptionklib', cdRegister);
 S.RegisterDelphiFunction(@grantAllPermissionsNetToTheObjectForTheEveryoneGroup, 'grantAllPermissionsNetToTheObjectForTheEveryoneGroupklib', cdRegister);
 S.RegisterDelphiFunction(@grantAllPermissionsNetToTheObjectForTheUsersGroup, 'grantAllPermissionsNetToTheObjectForTheUsersGroupklib', cdRegister);
 S.RegisterDelphiFunction(@grantAllPermissionNetToTheObject, 'grantAllPermissionNetToTheObjectklib', cdRegister);
 S.RegisterDelphiFunction(@grantAllPermissionsToTheObjectForTheEveryoneGroup, 'grantAllPermissionsToTheObjectForTheEveryoneGroupklib', cdRegister);
 S.RegisterDelphiFunction(@grantAllPermissionsToTheObjectForTheUsersGroup, 'grantAllPermissionsToTheObjectForTheUsersGroupklib', cdRegister);
 S.RegisterDelphiFunction(@grantAllPermissionsToTheObject, 'grantAllPermissionsToTheObjectklib', cdRegister);
 S.RegisterDelphiFunction(@grantAllPermissionsToTheObjectForTheEveryoneGroup2, 'grantAllPermissionsToTheObjectForTheEveryoneGroup2klib', cdRegister);
 S.RegisterDelphiFunction(@grantAllPermissionsToTheObjectForTheUsersGroup2, 'grantAllPermissionsToTheObjectForTheUsersGroup2klib', cdRegister);
 S.RegisterDelphiFunction(@grantAllPermissionsToTheObject2, 'grantAllPermissionsToTheObject2klib', cdRegister);
 S.RegisterDelphiFunction(@checkIfWindowsGroupOrUserExists, 'checkIfWindowsGroupOrUserExistsklib', cdRegister);
 S.RegisterDelphiFunction(@createDesktopLink, 'createDesktopLinkklib', cdRegister);
 S.RegisterDelphiFunction(@getDesktopDirPath, 'getDesktopDirPathklib', cdRegister);
 S.RegisterDelphiFunction(@copyDirIntoTargetDir, 'copyDirIntoTargetDirklib', cdRegister);
 S.RegisterDelphiFunction(@copyDir, 'copyDirklib', cdRegister);
 S.RegisterDelphiFunction(@createHideDir, 'createHideDirklib', cdRegister);
 S.RegisterDelphiFunction(@deleteDirectoryIfExists, 'deleteDirectoryIfExistsklib', cdRegister);
 S.RegisterDelphiFunction(@myMoveFile, 'myMoveFileklib', cdRegister);
 S.RegisterDelphiFunction(@createEmptyFileIfNotExists, 'createEmptyFileIfNotExistsklib', cdRegister);
 S.RegisterDelphiFunction(@createEmptyFile, 'createEmptyFileklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfIsWindowsSubDir, 'checkIfIsWindowsSubDirklib', cdRegister);
 S.RegisterDelphiFunction(@getParentDir, 'getParentDirklib', cdRegister);
 S.RegisterDelphiFunction(@getValidFullPathInWindowsStyle, 'getValidFullPathInWindowsStyleklib', cdRegister);
 S.RegisterDelphiFunction(@getPathInWindowsStyle, 'getPathInWindowsStyleklib', cdRegister);
 S.RegisterDelphiFunction(@getStringWithEnvVariablesReaded, 'getStringWithEnvVariablesReadedklib', cdRegister);
 S.RegisterDelphiFunction(@setProcessWindowToForeground, 'setProcessWindowToForegroundklib', cdRegister);
 S.RegisterDelphiFunction(@getPIDOfCurrentUserByProcessName, 'getPIDOfCurrentUserByProcessNameklib', cdRegister);
 S.RegisterDelphiFunction(@getWindowsUsername, 'getWindowsUsernameklib', cdRegister);
 S.RegisterDelphiFunction(@checkUserOfProcess, 'checkUserOfProcessklib', cdRegister);
 S.RegisterDelphiFunction(@getPIDCredentials, 'getPIDCredentialsklib', cdRegister);
 S.RegisterDelphiFunction(@getPIDByProcessName, 'getPIDByProcessNameklib', cdRegister);
 S.RegisterDelphiFunction(@getMainWindowHandleByPID, 'getMainWindowHandleByPIDklib', cdRegister);
 S.RegisterDelphiFunction(@closeApplication, 'closeApplicationklib', cdRegister);
 S.RegisterDelphiFunction(@sendMemoryStreamUsing_WM_COPYDATA, 'sendMemoryStreamUsing_WM_COPYDATAklib', cdRegister);
 S.RegisterDelphiFunction(@sendStringUsing_WM_COPYDATA, 'sendStringUsing_WM_COPYDATAklib', cdRegister);
 S.RegisterDelphiFunction(@mySetForegroundWindow, 'mySetForegroundWindowklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfWindowExists, 'checkIfWindowExistsklib', cdRegister);
 S.RegisterDelphiFunction(@myFindWindow, 'myFindWindowklib', cdRegister);
 S.RegisterDelphiFunction(@checkIfExistsKeyIn_HKEY_LOCAL_MACHINE, 'checkIfExistsKeyIn_HKEY_LOCAL_MACHINEklib', cdRegister);
 S.RegisterDelphiFunction(@waitForMultiple, 'waitForMultipleklib', cdRegister);
 S.RegisterDelphiFunction(@waitFor, 'waitForklib', cdRegister);
 S.RegisterDelphiFunction(@raiseLastSysErrorMessage, 'raiseLastSysErrorMessageklib', cdRegister);
 S.RegisterDelphiFunction(@getLastSysErrorMessage, 'getLastSysErrorMessageklib', cdRegister);
 S.RegisterDelphiFunction(@getLocaleDecimalSeparator, 'getLocaleDecimalSeparatorklib', cdRegister);
 S.RegisterDelphiFunction(@terminateCurrentProcess, 'terminateCurrentProcessklib', cdRegister);
 S.RegisterDelphiFunction(@myTerminateProcess, 'myTerminateProcessklib', cdRegister);
 //S.RegisterDelphiFunction(@fixedGetNamedSecurityInfo, 'fixedGetNamedSecurityInfo', CdStdCall);
end;



{ TPSImport_KLibWindows }
(*----------------------------------------------------------------------------*)
procedure TPSImport_KLibWindows.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_KLibWindows(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_KLibWindows.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_KLibWindows_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
