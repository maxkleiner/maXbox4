unit winsvc2;

interface
  uses winsvc, windows;

const
 // A service started automatically by the service control manager during system startup.
  SERVICE_AUTO_START   = $00000002;
// A device driver started by the system loader. This value is valid only for driver services.
  {SERVICE_BOOT_START   = $00000000;
//A service started by the service control manager when a process calls the StartService function.
  SERVICE_DEMAND_START = $00000003;
//A service that cannot be started. Attempts to start the service result in the error code ERROR_SERVICE_DISABLED.
  SERVICE_DISABLED =     $00000004;
  SERVICE_SYSTEM_START = $00000001;
  SERVICE_KERNEL_DRIVER       = $00000001;
  SERVICE_FILE_SYSTEM_DRIVER  = $00000002;
  SERVICE_ADAPTER             = $00000004;
  SERVICE_RECOGNIZER_DRIVER   = $00000008;  }

  SERVICE_DRIVER              =
    (SERVICE_KERNEL_DRIVER or
     SERVICE_FILE_SYSTEM_DRIVER or
     SERVICE_RECOGNIZER_DRIVER);

  //SERVICE_WIN32_OWN_PROCESS   = $00000010;
  //SERVICE_WIN32_SHARE_PROCESS = $00000020;
  SERVICE_WIN32               =
    (SERVICE_WIN32_OWN_PROCESS or
     SERVICE_WIN32_SHARE_PROCESS);

  //SERVICE_INTERACTIVE_PROCESS = $00000100;

  SERVICE_TYPE_ALL            =
    (SERVICE_WIN32 or
     SERVICE_ADAPTER or
     SERVICE_DRIVER  or
     SERVICE_INTERACTIVE_PROCESS);

  // constants for QueryServiceConfig2
  SERVICE_CONFIG_DELAYED_AUTO_START_INFO = 3;
  //SERVICE_CONFIG_DESCRIPTION = 1;
  //SERVICE_CONFIG_FAILURE_ACTIONS = 2;
  SERVICE_CONFIG_FAILURE_ACTIONS_FLAG = 4;
  SERVICE_CONFIG_PREFERRED_NODE = 9;
  SERVICE_CONFIG_PRESHUTDOWN_INFO = 7;
  SERVICE_CONFIG_REQUIRED_PRIVILEGES_INFO = 6;
  SERVICE_CONFIG_SERVICE_SID_INFO = 5;
  SERVICE_CONFIG_TRIGGER_INFO = 8;

type
  // for QueryServiceConfig2, Description.
  TSvcDescription = record
    Length: DWord;
    Desc: array[1..4096] of char;
  end;


function ChangeServiceType(ServiceName: String; TypeID: DWord): Boolean;
function GetServiceStatus2(ServiceName: String; ErrorState: Boolean): Boolean;
function StartService2(ServiceName: string): boolean;
function StopService2(ServiceName: string): boolean;

{function QueryServiceConfig2(hService: THandle; dwInfoLevel: DWord;
      lpBuffer: Pointer; bufsize: DWord; var BytesNeeded: DWord): BOOL;
      stdcall; external 'advapi32.dll' name 'QueryServiceConfig2A'; }

implementation

function ChangeServiceType(ServiceName: String; TypeID: DWord): Boolean;
// changes service type (eg Automatic, Manual, Disabled)
// returns true if service type successfully changed, false if a problem.
var
  schandle: THandle;
  scService: THandle;
begin
  try
    schandle := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
    Result := (schandle <> 0);
    if not Result then exit;
    scService := OpenService(schandle, PChar(ServiceName), SERVICE_CHANGE_CONFIG);
    Result := (scService <> 0);
    if not Result then exit;
    Result := ChangeServiceConfig(scService, SERVICE_NO_CHANGE, TypeID,
        SERVICE_NO_CHANGE, nil, nil, nil, nil, nil, nil, nil);
    if not Result then exit;
  finally
    CloseServiceHandle(scService);
    CloseServiceHandle(scHandle);
  end;
end;

function GetServiceStatus2(ServiceName: String; ErrorState: Boolean): Boolean;
// returns whether the specified service name is started or not.
// ErrorState is true or false based on error.
// Function return is true if service is started, false if service is stopped.
var
  schandle: THandle;
  scService: THandle;
  ServiceStatus: TServiceStatus;
begin
  try
    Result := false;
    schandle := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
    ErrorState := (schandle = 0);
    if ErrorState then exit;
    scService := OpenService(schandle, PChar(ServiceName), SERVICE_ALL_ACCESS);
    ErrorState := (scService = 0);
    if ErrorState then exit;
    ErrorState := not QueryServiceStatus(scService, ServiceStatus);
    if ErrorState then exit;
    if (ServiceStatus.dwCurrentState <> SERVICE_STOPPED) and
       (ServiceStatus.dwCurrentState <> SERVICE_STOP_PENDING) then
      Result := true
    else
      Result := false;
  finally
    CloseServiceHandle(scService);
    CloseServiceHandle(scHandle);
  end;
end;

function StartService2(ServiceName: string): boolean;
// starts service listed by service name.
// Result true if started, false if not for some reason
var
  schandle: THandle;
  scService: THandle;
  ServiceStatus: TServiceStatus;
  args: PChar;
begin
  try
    schandle := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
    Result := (schandle = 0);
    if Result then exit;
    scService := OpenService(schandle, PChar(ServiceName), SERVICE_ALL_ACCESS);
    Result := (scService = 0);
    if Result then exit;

    Result := QueryServiceStatus(scService, ServiceStatus);
    if not Result then exit;
    // if service is not stopped, don't bother trying to start it.
    Result := (ServiceStatus.dwCurrentState = SERVICE_STOPPED);
    if not Result then exit;
    // now start service
    args := nil;
    Result := StartService(scService, 0, args);
    if not Result then exit;
    repeat
      QueryServiceStatus(scService, ServiceStatus);
      sleep(20);
    until (ServiceStatus.dwCurrentState <> SERVICE_START_PENDING);
    Result := (ServiceStatus.dwCurrentState = SERVICE_RUNNING);
  finally
    CloseServiceHandle(scService);
    CloseServiceHandle(scHandle);
  end;
end;

function StopDependentServices(scService: THandle): Boolean;
// stops all dependent services for the service handle given, no error checking
type
  TSvcStatus = array[0..512] of TEnumServiceStatus;
  PSvcStatus = ^TSvcStatus;
var
  EnumRec: PSvcStatus;
  bytesNeeded, numservices: integer;
  i: integer;
begin
  New(ENumRec);
  Result := EnumDependentServices(scService, SERVICE_ACTIVE or SERVICE_INACTIVE, ENumRec^[0],
                             sizeof(TSvcStatus), cardinal(BytesNeeded), cardinal(numServices));
  for i := 0 to NumServices-1 do begin
      StopService2(String(ENumRec^[i].lpServiceName));
    end;
  Dispose(ENumRec);
end;

function StopService2(ServiceName: string): boolean;
// stops service listed by service name.
// Result true if started, false if not for some reason
var
  schandle: THandle;
  scService: THandle;
  ServiceStatus: TServiceStatus;
begin
  try
    schandle := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
    Result := (schandle = 0);
    if Result then exit;
    scService := OpenService(schandle, PChar(ServiceName), SERVICE_ALL_ACCESS);
    Result := (scService = 0);
    if Result then exit;

    Result := QueryServiceStatus(scService, ServiceStatus);
    if not Result then exit;
    // if service is not started, don't bother trying to start it.
    Result := (ServiceStatus.dwCurrentState = SERVICE_RUNNING);
    if not Result then exit;
    // now stop service, starting with dependent services.
    StopDependentServices(scService);
    // Send a stop code to the service.
    ControlService(scService, SERVICE_CONTROL_STOP, ServiceStatus);
    if not Result then exit;
    repeat
      QueryServiceStatus(scService, ServiceStatus);
      sleep(20);
    until (ServiceStatus.dwCurrentState <> SERVICE_STOP_PENDING);
    Result := (ServiceStatus.dwCurrentState = SERVICE_STOPPED);
  finally
    CloseServiceHandle(scService);
    CloseServiceHandle(scHandle);
  end;
end;

end.