unit uPSI_WinSvc;
{
    more services tools
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
  TPSImport_WinSvc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 
{ compile-time registration functions }
procedure SIRegister_WinSvc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_WinSvc_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,WinSvc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WinSvc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_WinSvc(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SERVICES_ACTIVE_DATABASEA','String').SetString( 'ServicesActive');
 CL.AddConstantN('SERVICES_ACTIVE_DATABASEW','String').SetString( 'ServicesActive');
 CL.AddConstantN('SERVICES_ACTIVE_DATABASE','String').SetString(' SERVICES_ACTIVE_DATABASEA');
 CL.AddConstantN('SERVICES_FAILED_DATABASEA','String').SetString( 'ServicesFailed');
 CL.AddConstantN('SERVICES_FAILED_DATABASEW','String').SetString( 'ServicesFailed');
 CL.AddConstantN('SERVICES_FAILED_DATABASE','String').SetString( 'SERVICES_FAILED_DATABASEA');
 CL.AddConstantN('SC_GROUP_IDENTIFIERA','String').SetString( '+');
 CL.AddConstantN('SC_GROUP_IDENTIFIERW','String').SetString( '+');
 CL.AddConstantN('SC_GROUP_IDENTIFIER','string').SetString( 'SC_GROUP_IDENTIFIERA');
 CL.AddConstantN('SERVICE_NO_CHANGE','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('SERVICE_ACTIVE','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SERVICE_INACTIVE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SERVICE_CONTROL_STOP','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SERVICE_CONTROL_PAUSE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SERVICE_CONTROL_CONTINUE','LongWord').SetUInt( $00000003);
 CL.AddConstantN('SERVICE_CONTROL_INTERROGATE','LongWord').SetUInt( $00000004);
 CL.AddConstantN('SERVICE_CONTROL_SHUTDOWN','LongWord').SetUInt( $00000005);
 CL.AddConstantN('SERVICE_STOPPED','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SERVICE_START_PENDING','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SERVICE_STOP_PENDING','LongWord').SetUInt( $00000003);
 CL.AddConstantN('SERVICE_RUNNING','LongWord').SetUInt( $00000004);
 CL.AddConstantN('SERVICE_CONTINUE_PENDING','LongWord').SetUInt( $00000005);
 CL.AddConstantN('SERVICE_PAUSE_PENDING','LongWord').SetUInt( $00000006);
 CL.AddConstantN('SERVICE_PAUSED','LongWord').SetUInt( $00000007);
 CL.AddConstantN('SERVICE_ACCEPT_STOP','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SERVICE_ACCEPT_PAUSE_CONTINUE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SERVICE_ACCEPT_SHUTDOWN','LongWord').SetUInt( $00000004);
 CL.AddConstantN('SC_MANAGER_CONNECT','LongWord').SetUInt( $0001);
 CL.AddConstantN('SC_MANAGER_CREATE_SERVICE','LongWord').SetUInt( $0002);
 CL.AddConstantN('SC_MANAGER_ENUMERATE_SERVICE','LongWord').SetUInt( $0004);
 CL.AddConstantN('SC_MANAGER_LOCK','LongWord').SetUInt( $0008);
 CL.AddConstantN('SC_MANAGER_QUERY_LOCK_STATUS','LongWord').SetUInt( $0010);
 CL.AddConstantN('SC_MANAGER_MODIFY_BOOT_CONFIG','LongWord').SetUInt( $0020);
 CL.AddConstantN('SERVICE_QUERY_CONFIG','LongWord').SetUInt( $0001);
 CL.AddConstantN('SERVICE_CHANGE_CONFIG','LongWord').SetUInt( $0002);
 CL.AddConstantN('SERVICE_QUERY_STATUS','LongWord').SetUInt( $0004);
 CL.AddConstantN('SERVICE_ENUMERATE_DEPENDENTS','LongWord').SetUInt( $0008);
 CL.AddConstantN('SERVICE_START','LongWord').SetUInt( $0010);
 CL.AddConstantN('SERVICE_STOP','LongWord').SetUInt( $0020);
 CL.AddConstantN('SERVICE_PAUSE_CONTINUE','LongWord').SetUInt( $0040);
 CL.AddConstantN('SERVICE_INTERROGATE','LongWord').SetUInt( $0080);
 CL.AddConstantN('SERVICE_USER_DEFINED_CONTROL','LongWord').SetUInt( $0100);
 CL.AddConstantN('SERVICE_KERNEL_DRIVER','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SERVICE_FILE_SYSTEM_DRIVER','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SERVICE_ADAPTER','LongWord').SetUInt( $00000004);
 CL.AddConstantN('SERVICE_RECOGNIZER_DRIVER','LongWord').SetUInt( $00000008);
 CL.AddConstantN('SERVICE_WIN32_OWN_PROCESS','LongWord').SetUInt( $00000010);
 CL.AddConstantN('SERVICE_WIN32_SHARE_PROCESS','LongWord').SetUInt( $00000020);
 CL.AddConstantN('SERVICE_INTERACTIVE_PROCESS','LongWord').SetUInt( $00000100);
 CL.AddConstantN('SERVICE_BOOT_START','LongWord').SetUInt( $00000000);
 CL.AddConstantN('SERVICE_SYSTEM_START','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SERVICE_AUTO_START','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SERVICE_DEMAND_START','LongWord').SetUInt( $00000003);
 CL.AddConstantN('SERVICE_DISABLED','LongWord').SetUInt( $00000004);
 CL.AddConstantN('SERVICE_ERROR_IGNORE','LongWord').SetUInt( $00000000);
 CL.AddConstantN('SERVICE_ERROR_NORMAL','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SERVICE_ERROR_SEVERE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SERVICE_ERROR_CRITICAL','LongWord').SetUInt( $00000003);
  CL.AddTypeS('SC_HANDLE', 'THandle');
  //CL.AddTypeS('LPSC_HANDLE', '^SC_HANDLE // will not work');
  CL.AddTypeS('SERVICE_STATUS_HANDLE', 'DWORD');
  //CL.AddTypeS('PLPSTRA', '^PAnsiChar // will not work');
  //CL.AddTypeS('PLPWSTRW', '^PWideChar // will not work');
  //CL.AddTypeS('PLPSTR', 'PLPSTRA');
  //CL.AddTypeS('PServiceStatus', '^TServiceStatus // will not work');
  CL.AddTypeS('_SERVICE_STATUS', 'record dwServiceType : DWORD; dwCurrentState '
   +': DWORD; dwControlsAccepted : DWORD; dwWin32ExitCode : DWORD; dwServiceSpe'
   +'cificExitCode : DWORD; dwCheckPoint : DWORD; dwWaitHint : DWORD; end');
  CL.AddTypeS('SERVICE_STATUS', '_SERVICE_STATUS');
  CL.AddTypeS('TServiceStatus', '_SERVICE_STATUS');
  //CL.AddTypeS('PEnumServiceStatusA', '^TEnumServiceStatusA // will not work');
  //CL.AddTypeS('PEnumServiceStatusW', '^TEnumServiceStatusW // will not work');
  //CL.AddTypeS('PEnumServiceStatus', 'PEnumServiceStatusA');
  CL.AddTypeS('_ENUM_SERVICE_STATUSA', 'record lpServiceName : PChar; lpDis'
   +'playName : PChar; ServiceStatus : TServiceStatus; end');
  CL.AddTypeS('ENUM_SERVICE_STATUSA', '_ENUM_SERVICE_STATUSA');
  //CL.AddTypeS('_ENUM_SERVICE_STATUSW', 'record lpServiceName : PWideChar; lpDis'
  // +'playName : PWideChar; ServiceStatus : TServiceStatus; end');
  //CL.AddTypeS('ENUM_SERVICE_STATUSW', '_ENUM_SERVICE_STATUSW');
  CL.AddTypeS('_ENUM_SERVICE_STATUS', '_ENUM_SERVICE_STATUSA');
  CL.AddTypeS('TEnumServiceStatusA', '_ENUM_SERVICE_STATUSA');
  //CL.AddTypeS('TEnumServiceStatusW', '_ENUM_SERVICE_STATUSW');
  CL.AddTypeS('TEnumServiceStatus', 'TEnumServiceStatusA');
  CL.AddTypeS('SC_LOCK', '___Pointer');
  //CL.AddTypeS('PQueryServiceLockStatusA', '^TQueryServiceLockStatusA // will not work');
  //CL.AddTypeS('PQueryServiceLockStatusW', '^TQueryServiceLockStatusW // will not work');
  //CL.AddTypeS('PQueryServiceLockStatus', 'PQueryServiceLockStatusA');
  CL.AddTypeS('_QUERY_SERVICE_LOCK_STATUSA', 'record fIsLocked : DWORD; lpLockO'
   +'wner : PChar; dwLockDuration : DWORD; end');
  //CL.AddTypeS('_QUERY_SERVICE_LOCK_STATUSW', 'record fIsLocked : DWORD; lpLockO'
  // +'wner : PWideChar; dwLockDuration : DWORD; end');
  CL.AddTypeS('_QUERY_SERVICE_LOCK_STATUS', '_QUERY_SERVICE_LOCK_STATUSA');
  CL.AddTypeS('QUERY_SERVICE_LOCK_STATUSA', '_QUERY_SERVICE_LOCK_STATUSA');
  //CL.AddTypeS('QUERY_SERVICE_LOCK_STATUSW', '_QUERY_SERVICE_LOCK_STATUSW');
  CL.AddTypeS('QUERY_SERVICE_LOCK_STATUS', 'QUERY_SERVICE_LOCK_STATUSA');
  CL.AddTypeS('TQueryServiceLockStatusA', '_QUERY_SERVICE_LOCK_STATUSA');
  //CL.AddTypeS('TQueryServiceLockStatusW', '_QUERY_SERVICE_LOCK_STATUSW');
  CL.AddTypeS('TQueryServiceLockStatus', 'TQueryServiceLockStatusA');
  //CL.AddTypeS('PQueryServiceConfigA', '^TQueryServiceConfigA // will not work');
  //CL.AddTypeS('PQueryServiceConfigW', '^TQueryServiceConfigW // will not work');
  //CL.AddTypeS('PQueryServiceConfig', 'PQueryServiceConfigA');
  CL.AddTypeS('_QUERY_SERVICE_CONFIGA', 'record dwServiceType : DWORD; dwStartT'
   +'ype : DWORD; dwErrorControl : DWORD; lpBinaryPathName : PChar; lpLoadO'
   +'rderGroup : PChar; dwTagId : DWORD; lpDependencies : PChar; lpServ'
   +'iceStartName : PChar; lpDisplayName : PChar; end');
  //CL.AddTypeS('_QUERY_SERVICE_CONFIGW', 'record dwServiceType : DWORD; dwStartT'
   //+'ype : DWORD; dwErrorControl : DWORD; lpBinaryPathName : PWideChar; lpLoadO'
   //+'rderGroup : PWideChar; dwTagId : DWORD; lpDependencies : PWideChar; lpServ'
   //+'iceStartName : PWideChar; lpDisplayName : PWideChar; end');
  CL.AddTypeS('_QUERY_SERVICE_CONFIG', '_QUERY_SERVICE_CONFIGA');
  CL.AddTypeS('QUERY_SERVICE_CONFIGA', '_QUERY_SERVICE_CONFIGA');
  //CL.AddTypeS('QUERY_SERVICE_CONFIGW', '_QUERY_SERVICE_CONFIGW');
  CL.AddTypeS('QUERY_SERVICE_CONFIG', 'QUERY_SERVICE_CONFIGA');
  CL.AddTypeS('TQueryServiceConfigA', '_QUERY_SERVICE_CONFIGA');
  //CL.AddTypeS('TQueryServiceConfigW', '_QUERY_SERVICE_CONFIGW');
  CL.AddTypeS('TQueryServiceConfig', 'TQueryServiceConfigA');
  {CL.AddTypeS('LPSERVICE_MAIN_FUNCTIONA', 'TFarProc');
  CL.AddTypeS('LPSERVICE_MAIN_FUNCTIONW', 'TFarProc');
  CL.AddTypeS('LPSERVICE_MAIN_FUNCTION', 'LPSERVICE_MAIN_FUNCTIONA');
  CL.AddTypeS('TServiceMainFunctionA', 'LPSERVICE_MAIN_FUNCTIONA');
  CL.AddTypeS('TServiceMainFunctionW', 'LPSERVICE_MAIN_FUNCTIONW');
  CL.AddTypeS('TServiceMainFunction', 'TServiceMainFunctionA');}
  //CL.AddTypeS('PServiceTableEntryA', '^TServiceTableEntryA // will not work');
  //CL.AddTypeS('PServiceTableEntryW', '^TServiceTableEntryW // will not work');
  {CL.AddTypeS('PServiceTableEntry', 'PServiceTableEntryA');
  CL.AddTypeS('_SERVICE_TABLE_ENTRYA', 'record lpServiceName : PAnsiChar; lpSer'
   +'viceProc : TServiceMainFunctionA; end');
  CL.AddTypeS('_SERVICE_TABLE_ENTRYW', 'record lpServiceName : PWideChar; lpSer'
   +'viceProc : TServiceMainFunctionW; end');
  CL.AddTypeS('_SERVICE_TABLE_ENTRY', '_SERVICE_TABLE_ENTRYA');
  CL.AddTypeS('SERVICE_TABLE_ENTRYA', '_SERVICE_TABLE_ENTRYA');
  CL.AddTypeS('SERVICE_TABLE_ENTRYW', '_SERVICE_TABLE_ENTRYW');
  CL.AddTypeS('SERVICE_TABLE_ENTRY', 'SERVICE_TABLE_ENTRYA');
  CL.AddTypeS('TServiceTableEntryA', '_SERVICE_TABLE_ENTRYA');
  CL.AddTypeS('TServiceTableEntryW', '_SERVICE_TABLE_ENTRYW');
  CL.AddTypeS('TServiceTableEntry', 'TServiceTableEntryA');
  CL.AddTypeS('LPHANDLER_FUNCTION', 'TFarProc');
  CL.AddTypeS('THandlerFunction', 'LPHANDLER_FUNCTION'); }
 //CL.AddDelphiFunction('Function ChangeServiceConfig( hService : SC_HANDLE; dwServiceType, dwStartType, dwErrorControl : DWORD; lpBinaryPathName, lpLoadOrderGroup : PChar; lpdwTagId : LPDWORD; lpDependencies, lpServiceStartName, lpPassword, lpDisplayName : PChar) : BOOL');
// CL.AddDelphiFunction('Function ChangeServiceConfigA( hService : SC_HANDLE; dwServiceType, dwStartType, dwErrorControl : DWORD; lpBinaryPathName, lpLoadOrderGroup : PAnsiChar; lpdwTagId : LPDWORD; lpDependencies, lpServiceStartName, lpPassword, lpDisplayName : PAnsiChar) : BOOL');
// CL.AddDelphiFunction('Function ChangeServiceConfigW( hService : SC_HANDLE; dwServiceType, dwStartType, dwErrorControl : DWORD; lpBinaryPathName, lpLoadOrderGroup : PWideChar; lpdwTagId : LPDWORD; lpDependencies, lpServiceStartName, lpPassword, lpDisplayName : PWideChar) : BOOL');
 CL.AddDelphiFunction('Function CloseServiceHandle( hSCObject : SC_HANDLE) : BOOL');
 CL.AddDelphiFunction('Function ControlService( hService : SC_HANDLE; dwControl : DWORD; var lpServiceStatus : TServiceStatus) : BOOL');
 CL.AddDelphiFunction('Function CreateService( hSCManager : SC_HANDLE; lpServiceName, lpDisplayName : PChar; dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl : DWORD; lpBinaryPathName, lpLoadOrderGroup : PChar;'
 +' lpdwTagId : DWORD; lpDependencies, lpServiceStartName, lpPassword : PChar) : SC_HANDLE');
 CL.AddDelphiFunction('Function CreateServiceA( hSCManager : SC_HANDLE; lpServiceName, lpDisplayName : PChar; dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl : DWORD; lpBinaryPathName, lpLoadOrderGroup : PChar; '
 +'lpdwTagId : DWORD; lpDependencies, lpServiceStartName, lpPassword : PChar) : SC_HANDLE');
 //CL.AddDelphiFunction('Function CreateServiceW( hSCManager : SC_HANDLE; lpServiceName, lpDisplayName : PWideChar; dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl : DWORD; lpBinaryPathName, lpLoadOrderGroup : PWideChar; lpdwTagId : LPDWORD;'+
 //' lpDependencies, lpServiceStartName, lpPassword : PWideChar) : SC_HANDLE');
 CL.AddDelphiFunction('Function DeleteService( hService : SC_HANDLE) : BOOL');
 CL.AddDelphiFunction('Function EnumDependentServices( hService : SC_HANDLE; dwServiceState : DWORD; var lpServices : TEnumServiceStatus; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function EnumDependentServicesA( hService : SC_HANDLE; dwServiceState : DWORD; var lpServices : TEnumServiceStatusA; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function EnumDependentServicesW( hService : SC_HANDLE; dwServiceState : DWORD; var lpServices : TEnumServiceStatusW; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned : DWORD) : BOOL');
 CL.AddDelphiFunction('Function EnumServicesStatus( hSCManager : SC_HANDLE; dwServiceType, dwServiceState : DWORD; var lpServices : TEnumServiceStatus; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned, lpResumeHandle : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function EnumServicesStatusA( hSCManager : SC_HANDLE; dwServiceType, dwServiceState : DWORD; var lpServices : TEnumServiceStatusA; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned, lpResumeHandle : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function EnumServicesStatusW( hSCManager : SC_HANDLE; dwServiceType, dwServiceState : DWORD; var lpServices : TEnumServiceStatusW; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned, lpResumeHandle : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetServiceKeyName( hSCManager : SC_HANDLE; lpDisplayName, lpServiceName : PChar; var lpcchBuffer : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function GetServiceKeyNameA( hSCManager : SC_HANDLE; lpDisplayName, lpServiceName : PAnsiChar; var lpcchBuffer : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function GetServiceKeyNameW( hSCManager : SC_HANDLE; lpDisplayName, lpServiceName : PWideChar; var lpcchBuffer : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetServiceDisplayName( hSCManager : SC_HANDLE; lpServiceName, lpDisplayName : PChar; var lpcchBuffer : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function GetServiceDisplayNameA( hSCManager : SC_HANDLE; lpServiceName, lpDisplayName : PAnsiChar; var lpcchBuffer : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function GetServiceDisplayNameW( hSCManager : SC_HANDLE; lpServiceName, lpDisplayName : PWideChar; var lpcchBuffer : DWORD) : BOOL');
 CL.AddDelphiFunction('Function LockServiceDatabase( hSCManager : SC_HANDLE) : SC_LOCK');
 CL.AddDelphiFunction('Function NotifyBootConfigStatus( BootAcceptable : BOOL) : BOOL');
 CL.AddDelphiFunction('Function OpenSCManager( lpMachineName, lpDatabaseName : PChar; dwDesiredAccess : DWORD) : SC_HANDLE');
 //CL.AddDelphiFunction('Function OpenSCManagerA( lpMachineName, lpDatabaseName : PAnsiChar; dwDesiredAccess : DWORD) : SC_HANDLE');
 //CL.AddDelphiFunction('Function OpenSCManagerW( lpMachineName, lpDatabaseName : PWideChar; dwDesiredAccess : DWORD) : SC_HANDLE');
 CL.AddDelphiFunction('Function OpenService( hSCManager : SC_HANDLE; lpServiceName : PChar; dwDesiredAccess : DWORD) : SC_HANDLE');
 //CL.AddDelphiFunction('Function OpenServiceA( hSCManager : SC_HANDLE; lpServiceName : PAnsiChar; dwDesiredAccess : DWORD) : SC_HANDLE');
 //CL.AddDelphiFunction('Function OpenServiceW( hSCManager : SC_HANDLE; lpServiceName : PWideChar; dwDesiredAccess : DWORD) : SC_HANDLE');
 //CL.AddDelphiFunction('Function QueryServiceConfig( hService : SC_HANDLE; lpServiceConfig : PQueryServiceConfig; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function QueryServiceConfigA( hService : SC_HANDLE; lpServiceConfig : PQueryServiceConfigA; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function QueryServiceConfigW( hService : SC_HANDLE; lpServiceConfig : PQueryServiceConfigW; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function QueryServiceLockStatus( hSCManager : SC_HANDLE; var lpLockStatus : TQueryServiceLockStatus; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function QueryServiceLockStatusA( hSCManager : SC_HANDLE; var lpLockStatus : TQueryServiceLockStatusA; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function QueryServiceLockStatusW( hSCManager : SC_HANDLE; var lpLockStatus : TQueryServiceLockStatusW; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function QueryServiceObjectSecurity( hService : SC_HANDLE; dwSecurityInformation : SECURITY_INFORMATION; lpSecurityDescriptor : PSECURITY_DESCRIPTOR; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function QueryServiceStatus( hService : SC_HANDLE; var lpServiceStatus : TServiceStatus) : BOOL');
 //CL.AddDelphiFunction('Function RegisterServiceCtrlHandler( lpServiceName : PChar; lpHandlerProc : ThandlerFunction) : SERVICE_STATUS_HANDLE');
 //CL.AddDelphiFunction('Function RegisterServiceCtrlHandlerA( lpServiceName : PAnsiChar; lpHandlerProc : ThandlerFunction) : SERVICE_STATUS_HANDLE');
 //CL.AddDelphiFunction('Function RegisterServiceCtrlHandlerW( lpServiceName : PWideChar; lpHandlerProc : ThandlerFunction) : SERVICE_STATUS_HANDLE');
 //CL.AddDelphiFunction('Function SetServiceObjectSecurity( hService : SC_HANDLE; dwSecurityInformation : SECURITY_INFORMATION; lpSecurityDescriptor : PSECURITY_DESCRIPTOR) : BOOL');
 CL.AddDelphiFunction('Function SetServiceStatus( hServiceStatus : SERVICE_STATUS_HANDLE; var lpServiceStatus : TServiceStatus) : BOOL');
 //CL.AddDelphiFunction('Function StartServiceCtrlDispatcher( var lpServiceStartTable : TServiceTableEntry) : BOOL');
 //CL.AddDelphiFunction('Function StartServiceCtrlDispatcherA( var lpServiceStartTable : TServiceTableEntryA) : BOOL');
 //CL.AddDelphiFunction('Function StartServiceCtrlDispatcherW( var lpServiceStartTable : TServiceTableEntryW) : BOOL');
 CL.AddDelphiFunction('Function StartService( hService : SC_HANDLE; dwNumServiceArgs : DWORD; var lpServiceArgVectors : PChar) : BOOL');
 //CL.AddDelphiFunction('Function StartServiceA( hService : SC_HANDLE; dwNumServiceArgs : DWORD; var lpServiceArgVectors : PAnsiChar) : BOOL');
 //CL.AddDelphiFunction('Function StartServiceW( hService : SC_HANDLE; dwNumServiceArgs : DWORD; var lpServiceArgVectors : PWideChar) : BOOL');
 CL.AddDelphiFunction('Function UnlockServiceDatabase( ScLock : SC_LOCK) : BOOL');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_WinSvc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ChangeServiceConfig, 'ChangeServiceConfig', CdStdCall);
 //S.RegisterDelphiFunction(@ChangeServiceConfigA, 'ChangeServiceConfigA', CdStdCall);
 //S.RegisterDelphiFunction(@ChangeServiceConfigW, 'ChangeServiceConfigW', CdStdCall);
 S.RegisterDelphiFunction(@CloseServiceHandle, 'CloseServiceHandle', CdStdCall);
 S.RegisterDelphiFunction(@ControlService, 'ControlService', CdStdCall);
 S.RegisterDelphiFunction(@CreateService, 'CreateService', CdStdCall);
 //S.RegisterDelphiFunction(@CreateServiceA, 'CreateServiceA', CdStdCall);
 //S.RegisterDelphiFunction(@CreateServiceW, 'CreateServiceW', CdStdCall);
 S.RegisterDelphiFunction(@DeleteService, 'DeleteService', CdStdCall);
 S.RegisterDelphiFunction(@EnumDependentServices, 'EnumDependentServices', CdStdCall);
 //S.RegisterDelphiFunction(@EnumDependentServicesA, 'EnumDependentServicesA', CdStdCall);
 //S.RegisterDelphiFunction(@EnumDependentServicesW, 'EnumDependentServicesW', CdStdCall);
 S.RegisterDelphiFunction(@EnumServicesStatus, 'EnumServicesStatus', CdStdCall);
 //S.RegisterDelphiFunction(@EnumServicesStatusA, 'EnumServicesStatusA', CdStdCall);
 //S.RegisterDelphiFunction(@EnumServicesStatusW, 'EnumServicesStatusW', CdStdCall);
 S.RegisterDelphiFunction(@GetServiceKeyName, 'GetServiceKeyName', CdStdCall);
 //S.RegisterDelphiFunction(@GetServiceKeyNameA, 'GetServiceKeyNameA', CdStdCall);
 //S.RegisterDelphiFunction(@GetServiceKeyNameW, 'GetServiceKeyNameW', CdStdCall);
 S.RegisterDelphiFunction(@GetServiceDisplayName, 'GetServiceDisplayName', CdStdCall);
 //S.RegisterDelphiFunction(@GetServiceDisplayNameA, 'GetServiceDisplayNameA', CdStdCall);
 //S.RegisterDelphiFunction(@GetServiceDisplayNameW, 'GetServiceDisplayNameW', CdStdCall);
 S.RegisterDelphiFunction(@LockServiceDatabase, 'LockServiceDatabase', CdStdCall);
 S.RegisterDelphiFunction(@NotifyBootConfigStatus, 'NotifyBootConfigStatus', CdStdCall);
 S.RegisterDelphiFunction(@OpenSCManager, 'OpenSCManager', CdStdCall);
 //S.RegisterDelphiFunction(@OpenSCManagerA, 'OpenSCManagerA', CdStdCall);
 //S.RegisterDelphiFunction(@OpenSCManagerW, 'OpenSCManagerW', CdStdCall);
 S.RegisterDelphiFunction(@OpenService, 'OpenService', CdStdCall);
 //S.RegisterDelphiFunction(@OpenServiceA, 'OpenServiceA', CdStdCall);
 //S.RegisterDelphiFunction(@OpenServiceW, 'OpenServiceW', CdStdCall);
 S.RegisterDelphiFunction(@QueryServiceConfig, 'QueryServiceConfig', CdStdCall);
 //S.RegisterDelphiFunction(@QueryServiceConfigA, 'QueryServiceConfigA', CdStdCall);
 //S.RegisterDelphiFunction(@QueryServiceConfigW, 'QueryServiceConfigW', CdStdCall);
 S.RegisterDelphiFunction(@QueryServiceLockStatus, 'QueryServiceLockStatus', CdStdCall);
 //S.RegisterDelphiFunction(@QueryServiceLockStatusA, 'QueryServiceLockStatusA', CdStdCall);
 //S.RegisterDelphiFunction(@QueryServiceLockStatusW, 'QueryServiceLockStatusW', CdStdCall);
 S.RegisterDelphiFunction(@QueryServiceObjectSecurity, 'QueryServiceObjectSecurity', CdStdCall);
 S.RegisterDelphiFunction(@QueryServiceStatus, 'QueryServiceStatus', CdStdCall);
 S.RegisterDelphiFunction(@RegisterServiceCtrlHandler, 'RegisterServiceCtrlHandler', CdStdCall);
 //S.RegisterDelphiFunction(@RegisterServiceCtrlHandlerA, 'RegisterServiceCtrlHandlerA', CdStdCall);
 //S.RegisterDelphiFunction(@RegisterServiceCtrlHandlerW, 'RegisterServiceCtrlHandlerW', CdStdCall);
 S.RegisterDelphiFunction(@SetServiceObjectSecurity, 'SetServiceObjectSecurity', CdStdCall);
 S.RegisterDelphiFunction(@SetServiceStatus, 'SetServiceStatus', CdStdCall);
 S.RegisterDelphiFunction(@StartServiceCtrlDispatcher, 'StartServiceCtrlDispatcher', CdStdCall);
 //S.RegisterDelphiFunction(@StartServiceCtrlDispatcherA, 'StartServiceCtrlDispatcherA', CdStdCall);
 //S.RegisterDelphiFunction(@StartServiceCtrlDispatcherW, 'StartServiceCtrlDispatcherW', CdStdCall);
 S.RegisterDelphiFunction(@StartService, 'StartService', CdStdCall);
 //S.RegisterDelphiFunction(@StartServiceA, 'StartServiceA', CdStdCall);
 //S.RegisterDelphiFunction(@StartServiceW, 'StartServiceW', CdStdCall);
 S.RegisterDelphiFunction(@UnlockServiceDatabase, 'UnlockServiceDatabase', CdStdCall);
end;


 
{ TPSImport_WinSvc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinSvc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WinSvc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinSvc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_WinSvc(ri);
  RIRegister_WinSvc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
