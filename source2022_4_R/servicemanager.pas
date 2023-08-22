{
  The following class TServiceManager can be used to manage your NT-Services.
  You can do things like start, stop, pause or querying a services status.
}

{
  Die folgende Klasse TServiceManager kann verwendet werden, um NT-Dienste
  zu verwalten. Hierbei gibt es Funktionen wie Start, Stop, Pause sowie
  Statusabfragen.
}


//  Thanks for this one to Frederik Schaller as well - it's a co-work }

unit ServiceMgr;

interface

uses
  SysUtils, Windows, WinSvc, Classes;

const
  //
  // Service Types
  //
  SERVICE_KERNEL_DRIVER       = $00000001;
  SERVICE_FILE_SYSTEM_DRIVER  = $00000002;
  SERVICE_ADAPTER             = $00000004;
  SERVICE_RECOGNIZER_DRIVER   = $00000008;

  SERVICE_DRIVER              =
    (SERVICE_KERNEL_DRIVER or
     SERVICE_FILE_SYSTEM_DRIVER or
     SERVICE_RECOGNIZER_DRIVER);

  SERVICE_WIN32_OWN_PROCESS   = $00000010;
  SERVICE_WIN32_SHARE_PROCESS = $00000020;
  SERVICE_WIN32               =
    (SERVICE_WIN32_OWN_PROCESS or
     SERVICE_WIN32_SHARE_PROCESS);

  SERVICE_INTERACTIVE_PROCESS = $00000100;

  SERVICE_TYPE_ALL            =
    (SERVICE_WIN32 or
     SERVICE_ADAPTER or
     SERVICE_DRIVER  or
     SERVICE_INTERACTIVE_PROCESS);

type
  PTStrings = ^TStrings;

  TServiceManager = class
  private
    { Private declarations }
    ServiceControlManager: SC_Handle;
    ServiceHandle: SC_Handle;
    MachineName: string;
    function pvGetServicesList(sMachine: string; dwServiceType,
      dwServiceState: DWord; slServicesList: TStrings): boolean;
  protected
    function DoStartService(NumberOfArgument: DWORD; ServiceArgVectors: PChar): Boolean;
  public
    { Public declarations }
    constructor Create(MachineName: string; DatabaseName: string = ''); overload;
    function Connect(pcMachineName: PChar = nil; DatabaseName: PChar = nil;
      Access: DWORD = SC_MANAGER_ALL_ACCESS): Boolean;  // Access may be SC_MANAGER_ALL_ACCESS
    function OpenServiceConnection(ServiceName: PChar): Boolean;
    function StartService: Boolean; overload; // Simple start
    function StartService(NumberOfArgument: DWORD; ServiceArgVectors: PChar): Boolean;
      overload; // More complex start
    function StopService: Boolean;
    procedure PauseService;
    procedure ContinueService;
    procedure ShutdownService;
    procedure DisableService;
    function GetStatus: DWORD;
    function ServiceRunning: Boolean;
    function ServiceStopped: Boolean;
    function ImageIndex: integer;
    function GetServicesList(PTString: PTStrings): Boolean;
  end;

implementation

{ TServiceManager }

constructor TServiceManager.Create(MachineName: string; DatabaseName: string = '');
begin
  inherited Create();
  Self.Connect(PAnsiChar(MachineName), PAnsiChar(DatabaseName));
end;


function TServiceManager.Connect(pcMachineName, DatabaseName: PChar;
  Access: DWORD): Boolean;
begin
  Result := False;
  { open a connection to the windows service manager }
  ServiceControlManager := OpenSCManager(pcMachineName, DatabaseName, Access);
  Result := (ServiceControlManager <> 0);
  Self.MachineName := pcMachineName;
end;


function TServiceManager.OpenServiceConnection(ServiceName: PChar): Boolean;
begin
  Result := False;
  { open a connetcion to a specific service }
  ServiceHandle := OpenService(ServiceControlManager, ServiceName, SERVICE_ALL_ACCESS);
  Result := (ServiceHandle <> 0);
end;

procedure TServiceManager.PauseService;
var
  ServiceStatus: TServiceStatus;
begin
  { Pause the service: attention not supported by all services }
  ControlService(ServiceHandle, SERVICE_CONTROL_PAUSE, ServiceStatus);
end;

function TServiceManager.StopService: Boolean;
var
  ServiceStatus: TServiceStatus;
begin
  { Stop the service }
  Result := ControlService(ServiceHandle, SERVICE_CONTROL_STOP, ServiceStatus);
end;

procedure TServiceManager.ContinueService;
var
  ServiceStatus: TServiceStatus;
begin
  { Continue the service after a pause: attention not supported by all services }
  ControlService(ServiceHandle, SERVICE_CONTROL_CONTINUE, ServiceStatus);
end;

procedure TServiceManager.ShutdownService;
var
  ServiceStatus: TServiceStatus;
begin
  { Shut service down: attention not supported by all services }
  ControlService(ServiceHandle, SERVICE_CONTROL_SHUTDOWN, ServiceStatus);
end;

function TServiceManager.StartService: Boolean;
begin
  Result := DoStartService(0, '');
end;

function TServiceManager.StartService(NumberOfArgument: DWORD;
  ServiceArgVectors: PChar): Boolean;
begin
  Result := DoStartService(NumberOfArgument, ServiceArgVectors);
end;

function TServiceManager.GetStatus: DWORD;
var
  ServiceStatus: TServiceStatus;
begin
{ Returns the status of the service. Maybe you want to check this
  more than once, so just call this function again.
  Results may be: SERVICE_STOPPED
                  SERVICE_START_PENDING
                  SERVICE_STOP_PENDING
                  SERVICE_RUNNING
                  SERVICE_CONTINUE_PENDING
                  SERVICE_PAUSE_PENDING
                  SERVICE_PAUSED   }
  Result := 0;
  QueryServiceStatus(ServiceHandle, ServiceStatus);
  Result := ServiceStatus.dwCurrentState;
end;

procedure TServiceManager.DisableService;
begin
  { Implementation is following... }
end;

function TServiceManager.ServiceRunning: Boolean;
begin
  Result := (GetStatus = SERVICE_RUNNING);
end;

function TServiceManager.ServiceStopped: Boolean;
begin
  Result := (GetStatus = SERVICE_STOPPED);
end;

function TServiceManager.DoStartService(NumberOfArgument: DWORD;
  ServiceArgVectors: PChar): Boolean;
var
  err: integer;
begin
  Result := WinSvc.StartService(ServiceHandle, NumberOfArgument, ServiceArgVectors);
end;

function TServiceManager.ImageIndex(): integer;
var s: Integer;
begin
  s := self.GetStatus;
  Result := 1;
  case s of
    SERVICE_STOPPED:           Result := 0;
    SERVICE_RUNNING:           Result := 2;
    SERVICE_START_PENDING,
    SERVICE_STOP_PENDING,
    SERVICE_CONTINUE_PENDING,
    SERVICE_PAUSE_PENDING,
    SERVICE_PAUSED:            Result := 1;
  end;
end;

function TServiceManager.pvGetServicesList(sMachine: string; dwServiceType,
      dwServiceState: DWord; slServicesList: TStrings): boolean;
  const
    cnMaxServices = 4096;

  type
    TSvcA = array[0..cnMaxServices] of TEnumServiceStatus;
    PSvcA = ^TSvcA;

  var
    j:             integer;
    schm:          SC_Handle;    // service control manager handle
    nBytesNeeded,                // bytes needed for the next buffer, if any
    nServices,                   // number of services
    nResumeHandle: DWord;        // pointer to the next unread service entry
    ssa:           PSvcA;        // service status array

  begin
    Result := false;

    // connect to the service control manager
    schm := OpenSCManager(PChar(sMachine), nil, SC_MANAGER_ALL_ACCESS);

    // if successful...
    if (schm > 0) then begin
      nResumeHandle := 0;
      New(ssa);
      EnumServicesStatus(schm, dwServiceType, dwServiceState, ssa^[0],
        SizeOf(ssa^), nBytesNeeded, nServices, nResumeHandle);

      // assume that our initial array was large enough to hold all
      // entries. add code to enumerate if necessary.

      for j := 0 to nServices-1 do begin
        slServicesList.Add(StrPas(ssa^[j].lpDisplayName));
      end;

      Result := true;

      Dispose(ssa);

      // close service control manager handle
      CloseServiceHandle(schm);
    end;
  end;

function TServiceManager.GetServicesList(PTString: PTStrings): Boolean;
  begin
    pvGetServicesList(Self.MachineName, SERVICE_WIN32, SERVICE_STATE_ALL, PTstring^);
    Result := true;
  end;
  
end.


----code_cleared_checked_clean----