  unit uPSI_WinAPI;
{
   first Spring
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
  TPSImport_WinAPI = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


function AttachConsole(dwProcessID: Integer): Boolean;

   stdcall; external 'kernel32.dll' name 'AttachConsole';

function FreeConsole(): Boolean; 

   stdcall; external 'kernel32.dll' name 'FreeConsole';


{ compile-time registration functions }
procedure SIRegister_WinAPI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_WinAPI_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,WinSvc
  ,Forms , Graphics
  ,Spring_Utils_WinAPI
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WinAPI]);
end;


procedure makecaption(leftSide, Rightside:string; form:TForm);
var
  Metrics:NonClientMetrics;
  captionarea,spacewidth,nbrspaces:integer;
  b:TBitmap;
begin
  b:=TBitmap.create;  {to get a canvas}
  metrics.cbsize:=sizeof(Metrics);
  if SystemParametersInfo(SPI_GetNonCLientMetrics, sizeof(Metrics),@metrics,0)
  then  with metrics   do
  begin
    b.canvas.font.name:=Pchar(@metrics.LFCaptionFont.LfFaceName);
    with metrics.LFCaptionFont, b.canvas.font do
    begin
      height:=LFHeight;
      if lfweight=700 then style:=[fsbold];
      if lfitalic<>0 then style:=style+[fsitalic];
    end;
    {subtract 3 buttons + Icon + some border space}
    captionarea:=form.clientwidth-4*iCaptionwidth-4*iBorderWidth;;
    {n = # of spaces to insert}
    spacewidth:=b.canvas.textwidth(' ');
    nbrspaces:=(captionarea-b.canvas.textwidth(Leftside + Rightside)) div spacewidth;
    if nbrspaces>3 then form.caption:=LeftSide+stringofchar(' ',nbrspaces)+RightSide
    else form.caption:=LeftSide+' '+RightSide;
  end;
  b.free;
end;

procedure GetKLList(List: TStrings);
var
  AList : array [0..9] of Hkl;
  AklName: array [0..255] of Char;
  i: Longint;
begin
  List.Clear;
  for i := 0 to GetKeyboardLayoutList(SizeOf(AList), AList) - 1 do begin
      GetLocaleInfo(LoWord(AList[i]), LOCALE_SLANGUAGE, AklName, SizeOf(AklName));
      List.AddObject(AklName, Pointer(AList[i]));
    end;
end;

var
  _SetSuspendState: function (Hibernate, ForceCritical, DisableWakeEvent: BOOL): BOOL
  stdcall = nil;

  function LinkAPI(const module, functionname: string): Pointer; forward;

function SetSuspendState(Hibernate, ForceCritical, DisableWakeEvent: Boolean): Boolean;
begin
  if not Assigned(_SetSuspendState) then
    @_SetSuspendState := LinkAPI('POWRPROF.dll', 'SetSuspendState');
  if Assigned(_SetSuspendState) then
    Result := _SetSuspendState(Hibernate, ForceCritical,
      DisableWakeEvent)
  else
    Result := False;
end;

function LinkAPI(const module, functionname: string): Pointer;
var
  hLib: HMODULE;
begin
  hLib := GetModulehandle(PChar(module));
  if hLib = 0 then
    hLib := LoadLibrary(PChar(module));
  if hLib <> 0 then
    Result := getProcAddress(hLib, PChar(functionname))
  else
    Result := nil;
end;


function ServiceGetStatus(sMachine, sService: PChar): DWORD;
  {******************************************}
  {*** Parameters: ***}
  {*** sService: specifies the name of the service to open
  {*** sMachine: specifies the name of the target computer
  {*** ***}
  {*** Return Values: ***}
  {*** -1 = Error opening service ***}
  {*** 1 = SERVICE_STOPPED ***}
  {*** 2 = SERVICE_START_PENDING ***}
  {*** 3 = SERVICE_STOP_PENDING ***}
  {*** 4 = SERVICE_RUNNING ***}
  {*** 5 = SERVICE_CONTINUE_PENDING ***}
  {*** 6 = SERVICE_PAUSE_PENDING ***}
  {*** 7 = SERVICE_PAUSED ***}
  {******************************************}
var
  SCManHandle, SvcHandle: SC_Handle;
  SS: TServiceStatus;
  dwStat: DWORD;
begin
  dwStat := 0;
  // Open service manager handle.
  SCManHandle := OpenSCManager(sMachine, nil, SC_MANAGER_CONNECT);
  if (SCManHandle > 0) then
  begin
    SvcHandle := OpenService(SCManHandle, sService, SERVICE_QUERY_STATUS);
    // if Service installed
    if (SvcHandle > 0) then
    begin
      // SS structure holds the service status (TServiceStatus);
      if (QueryServiceStatus(SvcHandle, SS)) then
        dwStat := ss.dwCurrentState;
      CloseServiceHandle(SvcHandle);
    end;
    CloseServiceHandle(SCManHandle);
  end;
  Result := dwStat;
end;

function ServiceRunning(sMachine, sService: PChar): Boolean;
begin
  Result := SERVICE_RUNNING = ServiceGetStatus(sMachine, sService);
end;


procedure TBackgroundWorkerWaitFor(isworking: boolean; fWindow: HWND);
var
  Msg: TMSG;
begin
  while IsWorking do
    if PeekMessage(Msg, fWindow, 0, 0, PM_REMOVE) then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_WinAPI(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('VER_NT_WORKSTATION','LongWord').SetUInt( $0000001);
 CL.AddConstantN('VER_NT_DOMAIN_CONTROLLER','LongWord').SetUInt( $0000002);
 CL.AddConstantN('VER_NT_SERVER','LongWord').SetUInt( $0000003);
 CL.AddConstantN('VER_SERVER_NT','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('VER_WORKSTATION_NT','LongWord').SetUInt( $40000000);
 CL.AddConstantN('VER_SUITE_SMALLBUSINESS','LongWord').SetUInt( $00000001);
 CL.AddConstantN('VER_SUITE_ENTERPRISE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('VER_SUITE_BACKOFFICE','LongWord').SetUInt( $00000004);
 CL.AddConstantN('VER_SUITE_COMMUNICATIONS','LongWord').SetUInt( $00000008);
 CL.AddConstantN('VER_SUITE_TERMINAL','LongWord').SetUInt( $00000010);
 CL.AddConstantN('VER_SUITE_SMALLBUSINESS_RESTRICTED','LongWord').SetUInt( $00000020);
 CL.AddConstantN('VER_SUITE_EMBEDDEDNT','LongWord').SetUInt( $00000040);
 CL.AddConstantN('VER_SUITE_DATACENTER','LongWord').SetUInt( $00000080);
 CL.AddConstantN('VER_SUITE_SINGLEUSERTS','LongWord').SetUInt( $00000100);
 CL.AddConstantN('VER_SUITE_PERSONAL','LongWord').SetUInt( $00000200);
 CL.AddConstantN('VER_SUITE_BLADE','LongWord').SetUInt( $00000400);
 CL.AddConstantN('VER_SUITE_EMBEDDED_RESTRICTED','LongWord').SetUInt( $00000800);
 CL.AddConstantN('VER_SUITE_SECURITY_APPLIANCE','LongWord').SetUInt( $00001000);
 CL.AddConstantN('VER_SUITE_STORAGE_SERVER','LongWord').SetUInt( $00002000);
 CL.AddConstantN('VER_SUITE_COMPUTE_SERVER','LongWord').SetUInt( $00004000);
 CL.AddConstantN('iphlpapilib','String').SetString( 'iphlpapi.dll');
 CL.AddConstantN('MAX_ADAPTER_DESCRIPTION_LENGTH','LongInt').SetInt( 128);
 CL.AddConstantN('MAX_ADAPTER_NAME_LENGTH','LongInt').SetInt( 256);
 CL.AddConstantN('MAX_ADAPTER_ADDRESS_LENGTH','LongInt').SetInt( 8);
 CL.AddConstantN('DEFAULT_MINIMUM_ENTITIES','LongInt').SetInt( 32);
 CL.AddConstantN('MAX_HOSTNAME_LEN','LongInt').SetInt( 128);
 CL.AddConstantN('MAX_DOMAIN_NAME_LEN','LongInt').SetInt( 128);
 CL.AddConstantN('MAX_SCOPE_ID_LEN','LongInt').SetInt( 256);
  CL.AddTypeS('time_t', 'Longint');
 // CL.AddTypeS('PIP_MASK_STRING', '^IP_MASK_STRING // will not work');
  //CL.AddTypeS('PIP_ADDRESS_STRING', '^IP_ADDRESS_STRING // will not work');
  //CL.AddTypeS('IP_MASK_STRING', 'IP_ADDRESS_STRING');
  //CL.AddTypeS('TIpAddressString', 'IP_ADDRESS_STRING');
  //CL.AddTypeS('PIpAddressString', 'PIP_MASK_STRING');
 // CL.AddTypeS('PIP_ADDR_STRING', '^IP_ADDR_STRING // will not work');
  //CL.AddTypeS('_IP_ADDR_STRING', 'record Next : PIP_ADDR_STRING; IpAddress : IP'
  // +'_ADDRESS_STRING; IpMask : IP_MASK_STRING; Context : DWORD; end');
  //CL.AddTypeS('IP_ADDR_STRING', '_IP_ADDR_STRING');
  //CL.AddTypeS('TIpAddrString', 'IP_ADDR_STRING');
  //CL.AddTypeS('PIpAddrString', 'PIP_ADDR_STRING');
  //CL.AddTypeS('PIP_ADAPTER_INFO', '^IP_ADAPTER_INFO // will not work');
  //CL.AddTypeS('IP_ADAPTER_INFO', '_IP_ADAPTER_INFO');
  //CL.AddTypeS('TIpAdapterInfo', 'IP_ADAPTER_INFO');
  //CL.AddTypeS('PIpAdapterInfo', 'PIP_ADAPTER_INFO');
 //CL.AddDelphiFunction('Function GetAdaptersInfo( pAdapterInfo : PIP_ADAPTER_INFO; var pOutBufLen : ULONG) : DWORD');
 CL.AddConstantN('SERVICE_RUNS_IN_SYSTEM_PROCESS','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SERVICE_CONFIG_DESCRIPTION','LongInt').SetInt( 1);
 CL.AddConstantN('SERVICE_CONFIG_FAILURE_ACTIONS','LongInt').SetInt( 2);
  //CL.AddTypeS('LPSERVICE_DESCRIPTIONA', '^SERVICE_DESCRIPTIONA // will not work');
  CL.AddTypeS('_SERVICE_DESCRIPTIONA', 'record lpDescription : string; end');
  CL.AddTypeS('SERVICE_DESCRIPTIONA', '_SERVICE_DESCRIPTIONA');
  CL.AddTypeS('TServiceDescriptionA', 'SERVICE_DESCRIPTIONA');
  //CL.AddTypeS('PServiceDescriptionA', 'LPSERVICE_DESCRIPTIONA');
  //CL.AddTypeS('LPSERVICE_DESCRIPTIONW', '^SERVICE_DESCRIPTIONW // will not work');
  {CL.AddTypeS('_SERVICE_DESCRIPTIONW', 'record lpDescription : LPWSTR; end');
  CL.AddTypeS('SERVICE_DESCRIPTIONW', '_SERVICE_DESCRIPTIONW');
  CL.AddTypeS('TServiceDescriptionW', 'SERVICE_DESCRIPTIONW');
  CL.AddTypeS('PServiceDescriptionW', 'LPSERVICE_DESCRIPTIONW');
  CL.AddTypeS('SERVICE_DESCRIPTION', 'SERVICE_DESCRIPTIONW');
  CL.AddTypeS('LPSERVICE_DESCRIPTION', 'LPSERVICE_DESCRIPTIONW');
  CL.AddTypeS('TServiceDescription', 'TServiceDescriptionW');
  CL.AddTypeS('PServiceDescription', 'PServiceDescriptionW');
  CL.AddTypeS('SERVICE_DESCRIPTION', 'SERVICE_DESCRIPTIONA');
  CL.AddTypeS('LPSERVICE_DESCRIPTION', 'LPSERVICE_DESCRIPTIONA');
  CL.AddTypeS('TServiceDescription', 'TServiceDescriptionA');
  CL.AddTypeS('PServiceDescription', 'PServiceDescriptionA');}
  //CL.AddTypeS('LPSERVICE_STATUS_PROCESS', '^SERVICE_STATUS_PROCESS // will not '
  // +'work');
  CL.AddTypeS('_SERVICE_STATUS_PROCESS', 'record dwServiceType : DWORD; dwCurre'
   +'ntState : DWORD; dwControlsAccepted : DWORD; dwWin32ExitCode : DWORD; dwSe'
   +'rviceSpecificExitCode : DWORD; dwCheckPoint : DWORD; dwWaitHint : DWORD; d'
   +'wProcessId : DWORD; dwServiceFlags : DWORD; end');
  CL.AddTypeS('SERVICE_STATUS_PROCESS', '_SERVICE_STATUS_PROCESS');
  CL.AddTypeS('TServiceStatusProcess', 'SERVICE_STATUS_PROCESS');
  //CL.AddTypeS('PServiceStatusProcess', 'LPSERVICE_STATUS_PROCESS');
  CL.AddTypeS('_SC_ENUM_TYPE', '( SC_ENUM_PROCESS_INFO )');
  CL.AddTypeS('SC_ENUM_TYPE', '_SC_ENUM_TYPE');
  CL.AddTypeS('SC_HANDLE', 'THandle');

  CL.AddConstantN('FILE_FLAG_WRITE_THROUGH','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('FILE_FLAG_OVERLAPPED','LongWord').SetUInt( $40000000);
 CL.AddConstantN('FILE_FLAG_NO_BUFFERING','LongWord').SetUInt( $20000000);
 CL.AddConstantN('FILE_FLAG_RANDOM_ACCESS','LongWord').SetUInt( $10000000);
 CL.AddConstantN('FILE_FLAG_SEQUENTIAL_SCAN','LongWord').SetUInt( $8000000);
 CL.AddConstantN('FILE_FLAG_DELETE_ON_CLOSE','LongWord').SetUInt( $4000000);
 CL.AddConstantN('FILE_FLAG_BACKUP_SEMANTICS','LongWord').SetUInt( $2000000);
 CL.AddConstantN('FILE_FLAG_POSIX_SEMANTICS','LongWord').SetUInt( $1000000);
 CL.AddConstantN('CREATE_NEW','LongInt').SetInt( 1);
 CL.AddConstantN('CREATE_ALWAYS','LongInt').SetInt( 2);
 CL.AddConstantN('OPEN_EXISTING','LongInt').SetInt( 3);
 CL.AddConstantN('OPEN_ALWAYS','LongInt').SetInt( 4);
 CL.AddConstantN('TRUNCATE_EXISTING','LongInt').SetInt( 5);
 CL.AddConstantN('PROGRESS_CONTINUE','LongInt').SetInt( 0);
 CL.AddConstantN('PROGRESS_CANCEL','LongInt').SetInt( 1);
 CL.AddConstantN('PROGRESS_STOP','LongInt').SetInt( 2);
 CL.AddConstantN('PROGRESS_QUIET','LongInt').SetInt( 3);
 CL.AddConstantN('CALLBACK_CHUNK_FINISHED','LongWord').SetUInt( $00000000);
 CL.AddConstantN('CALLBACK_STREAM_SWITCH','LongWord').SetUInt( $00000001);
 CL.AddConstantN('COPY_FILE_FAIL_IF_EXISTS','LongWord').SetUInt( $00000001);
 CL.AddConstantN('COPY_FILE_RESTARTABLE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('PIPE_ACCESS_INBOUND','LongInt').SetInt( 1);
 CL.AddConstantN('PIPE_ACCESS_OUTBOUND','LongInt').SetInt( 2);
 CL.AddConstantN('PIPE_ACCESS_DUPLEX','LongInt').SetInt( 3);
 CL.AddConstantN('PIPE_CLIENT_END','LongInt').SetInt( 0);
 CL.AddConstantN('PIPE_SERVER_END','LongInt').SetInt( 1);
 CL.AddConstantN('PIPE_WAIT','LongInt').SetInt( 0);
 CL.AddConstantN('PIPE_NOWAIT','LongInt').SetInt( 1);
 CL.AddConstantN('PIPE_READMODE_BYTE','LongInt').SetInt( 0);
 CL.AddConstantN('PIPE_READMODE_MESSAGE','LongInt').SetInt( 2);
 CL.AddConstantN('PIPE_TYPE_BYTE','LongInt').SetInt( 0);
 CL.AddConstantN('PIPE_TYPE_MESSAGE','LongInt').SetInt( 4);
 CL.AddConstantN('PIPE_UNLIMITED_INSTANCES','LongInt').SetInt( 255);
 CL.AddConstantN('SECURITY_CONTEXT_TRACKING','LongWord').SetUInt( $40000);
 CL.AddConstantN('SECURITY_EFFECTIVE_ONLY','LongWord').SetUInt( $80000);
 CL.AddConstantN('SECURITY_SQOS_PRESENT','LongWord').SetUInt( $100000);
 CL.AddConstantN('SECURITY_VALID_SQOS_FLAGS','LongWord').SetUInt( $1F0000);
 // CL.AddTypeS('TRTLCriticalSectionDebug', '_RTL_CRITICAL_SECTION_DEBUG');
  //CL.AddTypeS('RTL_CRITICAL_SECTION_DEBUG', '_RTL_CRITICAL_SECTION_DEBUG');
  CL.AddTypeS('_IMAGE_DEBUG_DIRECTORY', 'record Characteristics : DWORD; TimeDa'
   +'teStamp : DWORD; MajorVersion : Word; MinorVersion : Word; _Type : DWORD; '
   +'SizeOfData : DWORD; AddressOfRawData : DWORD; PointerToRawData : DWORD; end');
  CL.AddTypeS('TImageDebugDirectory', '_IMAGE_DEBUG_DIRECTORY');
  CL.AddTypeS('IMAGE_DEBUG_DIRECTORY', '_IMAGE_DEBUG_DIRECTORY');
   CL.AddConstantN('SidTypeUser','LongInt').SetInt( 1);
 CL.AddConstantN('SidTypeGroup','LongInt').SetInt( 2);
 CL.AddConstantN('SidTypeDomain','LongInt').SetInt( 3);
 CL.AddConstantN('SidTypeAlias','LongInt').SetInt( 4);
 CL.AddConstantN('SidTypeWellKnownGroup','LongInt').SetInt( 5);
 CL.AddConstantN('SidTypeDeletedAccount','LongInt').SetInt( 6);
 CL.AddConstantN('SidTypeInvalid','LongInt').SetInt( 7);
 CL.AddConstantN('SidTypeUnknown','LongInt').SetInt( 8);
  CL.AddTypeS('SID_NAME_USE', 'DWORD');
  CL.AddConstantN('NMPWAIT_WAIT_FOREVER','LongWord').SetUInt( DWORD ( $FFFFFFFF ));
 CL.AddConstantN('NMPWAIT_NOWAIT','LongInt').SetInt( 1);
 CL.AddConstantN('NMPWAIT_USE_DEFAULT_WAIT','LongInt').SetInt( 0);



  CL.AddTypeS('_SYSTEM_INFO', 'record dwOemId: DWORD; wProcessorArchitecture: WORD; wReserved : WORD; dwPageSize : DWORD; '
   +'lpMinimumApplicationAddress: TObject; lpMaximumApplicationAddress: TObject; dwActiveProcessorMask : DWORD;'
   +'dwNumberOfProcessors : DWORD; dwProcessorType : DWORD; dwAllocationGranularity : DWORD; wProcessorLevel : WORD; wProcessorRevision: Word; end');

{  _SYSTEM_INFO = record
    case Integer of
      0: (
        dwOemId: DWORD);
      1: (
        wProcessorArchitecture: Word;
        wReserved: Word;
        dwPageSize: DWORD;
        lpMinimumApplicationAddress: Pointer;
        lpMaximumApplicationAddress: Pointer;
        dwActiveProcessorMask: DWORD;
        dwNumberOfProcessors: DWORD;
        dwProcessorType: DWORD;
        dwAllocationGranularity: DWORD;
        wProcessorLevel: Word;
        wProcessorRevision: Word);
  end; }
  {_TOKEN_PRIVILEGES = record
    PrivilegeCount: DWORD;
    Privileges: array[0..0] of TLUIDAndAttributes;
  end;}

  // TLargeInteger = Int64;

  //LARGE_INTEGER = _LARGE_INTEGER;
   CL.AddConstantN('ACCESS_OBJECT_GUID','LongInt').SetInt( 0);
 CL.AddConstantN('ACCESS_PROPERTY_SET_GUID','LongInt').SetInt( 1);
 CL.AddConstantN('ACCESS_PROPERTY_GUID','LongInt').SetInt( 2);
 CL.AddConstantN('ACCESS_MAX_LEVEL','LongInt').SetInt( 4);
  CL.AddTypeS('AUDIT_EVENT_TYPE', 'DWORD');
 CL.AddConstantN('AUDIT_ALLOW_NO_PRIVILEGE','LongWord').SetUInt( $1);
 CL.AddConstantN('SE_PRIVILEGE_ENABLED_BY_DEFAULT','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SE_PRIVILEGE_ENABLED','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SE_PRIVILEGE_USED_FOR_ACCESS','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('PRIVILEGE_SET_ALL_NECESSARY','LongInt').SetInt( 1);
   CL.AddTypeS('_LUID_AND_ATTRIBUTES', 'record Luid : TLargeInteger; Attributes: DWORD; end');
  CL.AddTypeS('TLUIDAndAttributes', '_LUID_AND_ATTRIBUTES');
  CL.AddTypeS('LUID_AND_ATTRIBUTES', '_LUID_AND_ATTRIBUTES');
   CL.AddTypeS('_TOKEN_PRIVILEGES', 'record PrivilegeCount : DWORD; '
   +'Privileges: array[0..0] of TLUIDAndAttributes; end');

   CL.AddTypeS('TSecurityImpersonationLevel', '( SecurityAnonymous, SecurityIden'
   +'tification, SecurityImpersonation, SecurityDelegation )');
 //CL.AddConstantN('SECURITY_MAX_IMPERSONATION_LEVEL','string').SetString( SecurityDelegation);
 //CL.AddConstantN('DEFAULT_IMPERSONATION_LEVEL','string').SetString( SecurityImpersonation);
 CL.AddConstantN('TOKEN_ASSIGN_PRIMARY','LongWord').SetUInt( $0001);
 CL.AddConstantN('TOKEN_DUPLICATE','LongWord').SetUInt( $0002);
 CL.AddConstantN('TOKEN_IMPERSONATE','LongWord').SetUInt( $0004);
 CL.AddConstantN('TOKEN_QUERY','LongWord').SetUInt( $0008);
 CL.AddConstantN('TOKEN_QUERY_SOURCE','LongWord').SetUInt( $0010);
 CL.AddConstantN('TOKEN_ADJUST_PRIVILEGES','LongWord').SetUInt( $0020);
 CL.AddConstantN('TOKEN_ADJUST_GROUPS','LongWord').SetUInt( $0040);
 CL.AddConstantN('TOKEN_ADJUST_DEFAULT','LongWord').SetUInt( $0080);
 //CL.AddConstantN('TOKEN_EXECUTE','').SetString( STANDARD_RIGHTS_EXECUTE);
  CL.AddTypeS('TTokenType', '( TokenTPad, TokenPrimary, TokenImpersonation )');
  CL.AddTypeS('TTokenInformationClass', '( TokenICPad, TokenUser, TokenGroups, '
   +'TokenPrivileges, TokenOwner, TokenPrimaryGroup, TokenDefaultDacl, TokenSou'
   +'rce, TokenType, TokenImpersonationLevel, TokenStatistics )');
    CL.AddTypeS('TSystemInfo', '_SYSTEM_INFO');
  CL.AddTypeS('SYSTEM_INFO', '_SYSTEM_INFO');
   CL.AddTypeS('TTokenPrivileges', '_TOKEN_PRIVILEGES');
  CL.AddTypeS('TOKEN_PRIVILEGES', '_TOKEN_PRIVILEGES');
  {CL.AddConstantN('OWNER_SECURITY_INFORMATION','LongWord').SetUInt( $00000001);
 CL.AddConstantN('GROUP_SECURITY_INFORMATION','LongWord').SetUInt( $00000002);
 CL.AddConstantN('DACL_SECURITY_INFORMATION','LongWord').SetUInt( $00000004);
 CL.AddConstantN('SACL_SECURITY_INFORMATION','LongWord').SetUInt( $00000008);
 CL.AddConstantN('IMAGE_DOS_SIGNATURE','LongWord').SetUInt( $5A4D);
 CL.AddConstantN('IMAGE_OS2_SIGNATURE','LongWord').SetUInt( $454E);
 CL.AddConstantN('IMAGE_OS2_SIGNATURE_LE','LongWord').SetUInt( $454C);
 CL.AddConstantN('IMAGE_VXD_SIGNATURE','LongWord').SetUInt( $454C);}
 //CL.AddConstantN('IMAGE_NT_SIGNATURE','LongWord').SetUInt( $00004550);
 CL.AddConstantN('SEM_FAILCRITICALERRORS','LongInt').SetInt( 1);
 CL.AddConstantN('SEM_NOGPFAULTERRORBOX','LongInt').SetInt( 2);
 CL.AddConstantN('SEM_NOALIGNMENTFAULTEXCEPT','LongInt').SetInt( 4);
 CL.AddConstantN('SEM_NOOPENFILEERRORBOX','LongWord').SetUInt( $8000);
 CL.AddConstantN('SEVERITY_SUCCESS','LongInt').SetInt( 0);
 CL.AddConstantN('SEVERITY_ERROR','LongInt').SetInt( 1);
  CL.AddConstantN('S_OK','LongWord').SetUInt( $00000000);
 CL.AddConstantN('S_FALSE','LongWord').SetUInt( $00000001);
 CL.AddConstantN('NOERROR','LongInt').SetInt( 0);
 CL.AddConstantN('E_UNEXPECTED','LongWord').SetUInt( $8000FFFF);
 CL.AddConstantN('E_NOTIMPL','LongWord').SetUInt( $80004001);
 CL.AddConstantN('E_OUTOFMEMORY','LongWord').SetUInt($8007000E );
 CL.AddConstantN('E_INVALIDARG','LongWord').SetUInt($80070057 );
 CL.AddConstantN('E_NOINTERFACE','LongWord').SetUInt( $80004002);
 CL.AddConstantN('E_POINTER','LongWord').SetUInt($80004003);
 CL.AddConstantN('E_HANDLE','LongWord').SetUInt($80070006);
 CL.AddConstantN('E_ABORT','LongWord').SetUInt($80004004);
 CL.AddConstantN('E_FAIL','LongWord').SetUInt( $80004005);
 CL.AddConstantN('E_ACCESSDENIED','LongWord').SetUInt($80070005);
 CL.AddConstantN('E_PENDING','LongWord').SetUInt($8000000A);

 //of unit messages
  CL.AddConstantN('WM_NULL','LongWord').SetUInt( $0000);
 CL.AddConstantN('WM_CREATE','LongWord').SetUInt( $0001);
 CL.AddConstantN('WM_DESTROY','LongWord').SetUInt( $0002);
 CL.AddConstantN('WM_MOVE','LongWord').SetUInt( $0003);
 CL.AddConstantN('WM_SIZE','LongWord').SetUInt( $0005);
 CL.AddConstantN('WM_ACTIVATE','LongWord').SetUInt( $0006);
 CL.AddConstantN('WM_SETFOCUS','LongWord').SetUInt( $0007);
 CL.AddConstantN('WM_KILLFOCUS','LongWord').SetUInt( $0008);
 CL.AddConstantN('WM_ENABLE','LongWord').SetUInt( $000A);
 CL.AddConstantN('WM_SETREDRAW','LongWord').SetUInt( $000B);
 CL.AddConstantN('WM_SETTEXT','LongWord').SetUInt( $000C);
 CL.AddConstantN('WM_GETTEXT','LongWord').SetUInt( $000D);
 CL.AddConstantN('WM_GETTEXTLENGTH','LongWord').SetUInt( $000E);
 CL.AddConstantN('WM_PAINT','LongWord').SetUInt( $000F);
 CL.AddConstantN('WM_CLOSE','LongWord').SetUInt( $0010);
 CL.AddConstantN('WM_QUERYENDSESSION','LongWord').SetUInt( $0011);
 CL.AddConstantN('WM_QUIT','LongWord').SetUInt( $0012);
 CL.AddConstantN('WM_QUERYOPEN','LongWord').SetUInt( $0013);
 CL.AddConstantN('WM_ERASEBKGND','LongWord').SetUInt( $0014);
 CL.AddConstantN('WM_SYSCOLORCHANGE','LongWord').SetUInt( $0015);
 CL.AddConstantN('WM_ENDSESSION','LongWord').SetUInt( $0016);
 CL.AddConstantN('WM_SYSTEMERROR','LongWord').SetUInt( $0017);
 CL.AddConstantN('WM_SHOWWINDOW','LongWord').SetUInt( $0018);
 CL.AddConstantN('WM_CTLCOLOR','LongWord').SetUInt( $0019);
 CL.AddConstantN('WM_WININICHANGE','LongWord').SetUInt( $001A);
 CL.AddConstantN('WM_SETTINGCHANGE','longword').SetUint( $001A);
 CL.AddConstantN('WM_DEVMODECHANGE','LongWord').SetUInt( $001B);
 CL.AddConstantN('WM_ACTIVATEAPP','LongWord').SetUInt( $001C);
 CL.AddConstantN('WM_FONTCHANGE','LongWord').SetUInt( $001D);
 CL.AddConstantN('WM_TIMECHANGE','LongWord').SetUInt( $001E);
 CL.AddConstantN('WM_CANCELMODE','LongWord').SetUInt( $001F);
 CL.AddConstantN('WM_SETCURSOR','LongWord').SetUInt( $0020);
 CL.AddConstantN('WM_MOUSEACTIVATE','LongWord').SetUInt( $0021);
 CL.AddConstantN('WM_CHILDACTIVATE','LongWord').SetUInt( $0022);
 CL.AddConstantN('WM_QUEUESYNC','LongWord').SetUInt( $0023);
 CL.AddConstantN('WM_GETMINMAXINFO','LongWord').SetUInt( $0024);
 CL.AddConstantN('WM_PAINTICON','LongWord').SetUInt( $0026);
 CL.AddConstantN('WM_ICONERASEBKGND','LongWord').SetUInt( $0027);
 CL.AddConstantN('WM_NEXTDLGCTL','LongWord').SetUInt( $0028);
 CL.AddConstantN('WM_SPOOLERSTATUS','LongWord').SetUInt( $002A);
 CL.AddConstantN('WM_DRAWITEM','LongWord').SetUInt( $002B);
 CL.AddConstantN('WM_MEASUREITEM','LongWord').SetUInt( $002C);
 CL.AddConstantN('WM_DELETEITEM','LongWord').SetUInt( $002D);
 CL.AddConstantN('WM_VKEYTOITEM','LongWord').SetUInt( $002E);
 CL.AddConstantN('WM_CHARTOITEM','LongWord').SetUInt( $002F);
 CL.AddConstantN('WM_SETFONT','LongWord').SetUInt( $0030);
 CL.AddConstantN('WM_GETFONT','LongWord').SetUInt( $0031);
 CL.AddConstantN('WM_SETHOTKEY','LongWord').SetUInt( $0032);
 CL.AddConstantN('WM_GETHOTKEY','LongWord').SetUInt( $0033);
 CL.AddConstantN('WM_QUERYDRAGICON','LongWord').SetUInt( $0037);
 CL.AddConstantN('WM_COMPAREITEM','LongWord').SetUInt( $0039);
 CL.AddConstantN('WM_GETOBJECT','LongWord').SetUInt( $003D);
 CL.AddConstantN('WM_COMPACTING','LongWord').SetUInt( $0041);
 CL.AddConstantN('WM_COMMNOTIFY','LongWord').SetUInt( $0044);
 CL.AddConstantN('WM_WINDOWPOSCHANGING','LongWord').SetUInt( $0046);
 CL.AddConstantN('WM_WINDOWPOSCHANGED','LongWord').SetUInt( $0047);
 CL.AddConstantN('WM_POWER','LongWord').SetUInt( $0048);
 CL.AddConstantN('WM_COPYDATA','LongWord').SetUInt( $004A);
 CL.AddConstantN('WM_CANCELJOURNAL','LongWord').SetUInt( $004B);
 CL.AddConstantN('WM_NOTIFY','LongWord').SetUInt( $004E);
 CL.AddConstantN('WM_INPUTLANGCHANGEREQUEST','LongWord').SetUInt( $0050);
 CL.AddConstantN('WM_INPUTLANGCHANGE','LongWord').SetUInt( $0051);
 CL.AddConstantN('WM_TCARD','LongWord').SetUInt( $0052);
 CL.AddConstantN('WM_HELP','LongWord').SetUInt( $0053);
 CL.AddConstantN('WM_USERCHANGED','LongWord').SetUInt( $0054);
 CL.AddConstantN('WM_NOTIFYFORMAT','LongWord').SetUInt( $0055);
 CL.AddConstantN('WM_CONTEXTMENU','LongWord').SetUInt( $007B);
 CL.AddConstantN('WM_STYLECHANGING','LongWord').SetUInt( $007C);
 CL.AddConstantN('WM_STYLECHANGED','LongWord').SetUInt( $007D);
 CL.AddConstantN('WM_DISPLAYCHANGE','LongWord').SetUInt( $007E);
 CL.AddConstantN('WM_GETICON','LongWord').SetUInt( $007F);
 CL.AddConstantN('WM_SETICON','LongWord').SetUInt( $0080);
 CL.AddConstantN('WM_NCCREATE','LongWord').SetUInt( $0081);
 CL.AddConstantN('WM_NCDESTROY','LongWord').SetUInt( $0082);
 CL.AddConstantN('WM_NCCALCSIZE','LongWord').SetUInt( $0083);
 CL.AddConstantN('WM_NCHITTEST','LongWord').SetUInt( $0084);
 CL.AddConstantN('WM_NCPAINT','LongWord').SetUInt( $0085);
 CL.AddConstantN('WM_NCACTIVATE','LongWord').SetUInt( $0086);
 CL.AddConstantN('WM_GETDLGCODE','LongWord').SetUInt( $0087);
 CL.AddConstantN('WM_NCMOUSEMOVE','LongWord').SetUInt( $00A0);
 CL.AddConstantN('WM_NCLBUTTONDOWN','LongWord').SetUInt( $00A1);
 CL.AddConstantN('WM_NCLBUTTONUP','LongWord').SetUInt( $00A2);
 CL.AddConstantN('WM_NCLBUTTONDBLCLK','LongWord').SetUInt( $00A3);
 CL.AddConstantN('WM_NCRBUTTONDOWN','LongWord').SetUInt( $00A4);
 CL.AddConstantN('WM_NCRBUTTONUP','LongWord').SetUInt( $00A5);
 CL.AddConstantN('WM_NCRBUTTONDBLCLK','LongWord').SetUInt( $00A6);
 CL.AddConstantN('WM_NCMBUTTONDOWN','LongWord').SetUInt( $00A7);
 CL.AddConstantN('WM_NCMBUTTONUP','LongWord').SetUInt( $00A8);
 CL.AddConstantN('WM_NCMBUTTONDBLCLK','LongWord').SetUInt( $00A9);
 CL.AddConstantN('WM_NCXBUTTONDOWN','LongWord').SetUInt( $00AB);
 CL.AddConstantN('WM_NCXBUTTONUP','LongWord').SetUInt( $00AC);
 CL.AddConstantN('WM_NCXBUTTONDBLCLK','LongWord').SetUInt( $00AD);
 CL.AddConstantN('WM_INPUT','LongWord').SetUInt( $00FF);
 CL.AddConstantN('WM_KEYFIRST','LongWord').SetUInt( $0100);
 CL.AddConstantN('WM_KEYDOWN','LongWord').SetUInt( $0100);
 CL.AddConstantN('WM_KEYUP','LongWord').SetUInt( $0101);
 CL.AddConstantN('WM_CHAR','LongWord').SetUInt( $0102);
 CL.AddConstantN('WM_DEADCHAR','LongWord').SetUInt( $0103);
 CL.AddConstantN('WM_SYSKEYDOWN','LongWord').SetUInt( $0104);
 CL.AddConstantN('WM_SYSKEYUP','LongWord').SetUInt( $0105);
 CL.AddConstantN('WM_SYSCHAR','LongWord').SetUInt( $0106);
 CL.AddConstantN('WM_SYSDEADCHAR','LongWord').SetUInt( $0107);
 CL.AddConstantN('WM_UNICHAR','LongWord').SetUInt( $0109);
 CL.AddConstantN('WM_KEYLAST','LongWord').SetUInt( $0109);
 CL.AddConstantN('WM_INITDIALOG','LongWord').SetUInt( $0110);
 CL.AddConstantN('WM_COMMAND','LongWord').SetUInt( $0111);
 CL.AddConstantN('WM_SYSCOMMAND','LongWord').SetUInt( $0112);
 CL.AddConstantN('WM_TIMER','LongWord').SetUInt( $0113);
 CL.AddConstantN('WM_HSCROLL','LongWord').SetUInt( $0114);
 CL.AddConstantN('WM_VSCROLL','LongWord').SetUInt( $0115);
 CL.AddConstantN('WM_INITMENU','LongWord').SetUInt( $0116);
 CL.AddConstantN('WM_INITMENUPOPUP','LongWord').SetUInt( $0117);
 CL.AddConstantN('WM_MENUSELECT','LongWord').SetUInt( $011F);
 CL.AddConstantN('WM_MENUCHAR','LongWord').SetUInt( $0120);
 CL.AddConstantN('WM_ENTERIDLE','LongWord').SetUInt( $0121);
 CL.AddConstantN('WM_MENURBUTTONUP','LongWord').SetUInt( $0122);
 CL.AddConstantN('WM_MENUDRAG','LongWord').SetUInt( $0123);
 CL.AddConstantN('WM_MENUGETOBJECT','LongWord').SetUInt( $0124);
 CL.AddConstantN('WM_UNINITMENUPOPUP','LongWord').SetUInt( $0125);
 CL.AddConstantN('WM_MENUCOMMAND','LongWord').SetUInt( $0126);
 CL.AddConstantN('WM_CHANGEUISTATE','LongWord').SetUInt( $0127);
 CL.AddConstantN('WM_UPDATEUISTATE','LongWord').SetUInt( $0128);
 CL.AddConstantN('WM_QUERYUISTATE','LongWord').SetUInt( $0129);
 CL.AddConstantN('WM_CTLCOLORMSGBOX','LongWord').SetUInt( $0132);
 CL.AddConstantN('WM_CTLCOLOREDIT','LongWord').SetUInt( $0133);
 CL.AddConstantN('WM_CTLCOLORLISTBOX','LongWord').SetUInt( $0134);
 CL.AddConstantN('WM_CTLCOLORBTN','LongWord').SetUInt( $0135);
 CL.AddConstantN('WM_CTLCOLORDLG','LongWord').SetUInt( $0136);
 CL.AddConstantN('WM_CTLCOLORSCROLLBAR','LongWord').SetUInt( $0137);
 CL.AddConstantN('WM_CTLCOLORSTATIC','LongWord').SetUInt( $0138);
 CL.AddConstantN('WM_MOUSEFIRST','LongWord').SetUInt( $0200);
 CL.AddConstantN('WM_MOUSEMOVE','LongWord').SetUInt( $0200);
 CL.AddConstantN('WM_LBUTTONDOWN','LongWord').SetUInt( $0201);
 CL.AddConstantN('WM_LBUTTONUP','LongWord').SetUInt( $0202);
 CL.AddConstantN('WM_LBUTTONDBLCLK','LongWord').SetUInt( $0203);
 CL.AddConstantN('WM_RBUTTONDOWN','LongWord').SetUInt( $0204);
 CL.AddConstantN('WM_RBUTTONUP','LongWord').SetUInt( $0205);
 CL.AddConstantN('WM_RBUTTONDBLCLK','LongWord').SetUInt( $0206);
 CL.AddConstantN('WM_MBUTTONDOWN','LongWord').SetUInt( $0207);
 CL.AddConstantN('WM_MBUTTONUP','LongWord').SetUInt( $0208);
 CL.AddConstantN('WM_MBUTTONDBLCLK','LongWord').SetUInt( $0209);
 CL.AddConstantN('WM_MOUSEWHEEL','LongWord').SetUInt( $020A);
 CL.AddConstantN('WM_MOUSELAST','LongWord').SetUInt( $020A);
 CL.AddConstantN('WM_PARENTNOTIFY','LongWord').SetUInt( $0210);
 CL.AddConstantN('WM_ENTERMENULOOP','LongWord').SetUInt( $0211);
 CL.AddConstantN('WM_EXITMENULOOP','LongWord').SetUInt( $0212);
 CL.AddConstantN('WM_NEXTMENU','LongWord').SetUInt( $0213);
 CL.AddConstantN('WM_SIZING','LongInt').SetInt( 532);
 CL.AddConstantN('WM_CAPTURECHANGED','LongInt').SetInt( 533);
 CL.AddConstantN('WM_MOVING','LongInt').SetInt( 534);
 CL.AddConstantN('WM_POWERBROADCAST','LongInt').SetInt( 536);
 CL.AddConstantN('WM_DEVICECHANGE','LongInt').SetInt( 537);
 CL.AddConstantN('WM_IME_STARTCOMPOSITION','LongWord').SetUInt( $010D);
 CL.AddConstantN('WM_IME_ENDCOMPOSITION','LongWord').SetUInt( $010E);
 CL.AddConstantN('WM_IME_COMPOSITION','LongWord').SetUInt( $010F);
 CL.AddConstantN('WM_IME_KEYLAST','LongWord').SetUInt( $010F);
 CL.AddConstantN('WM_IME_SETCONTEXT','LongWord').SetUInt( $0281);
 CL.AddConstantN('WM_IME_NOTIFY','LongWord').SetUInt( $0282);
 CL.AddConstantN('WM_IME_CONTROL','LongWord').SetUInt( $0283);
 CL.AddConstantN('WM_IME_COMPOSITIONFULL','LongWord').SetUInt( $0284);
 CL.AddConstantN('WM_IME_SELECT','LongWord').SetUInt( $0285);
 CL.AddConstantN('WM_IME_CHAR','LongWord').SetUInt( $0286);
 CL.AddConstantN('WM_IME_REQUEST','LongWord').SetUInt( $0288);
 CL.AddConstantN('WM_IME_KEYDOWN','LongWord').SetUInt( $0290);
 CL.AddConstantN('WM_IME_KEYUP','LongWord').SetUInt( $0291);
 CL.AddConstantN('WM_MDICREATE','LongWord').SetUInt( $0220);
 CL.AddConstantN('WM_MDIDESTROY','LongWord').SetUInt( $0221);
 CL.AddConstantN('WM_MDIACTIVATE','LongWord').SetUInt( $0222);
 CL.AddConstantN('WM_MDIRESTORE','LongWord').SetUInt( $0223);
 CL.AddConstantN('WM_MDINEXT','LongWord').SetUInt( $0224);
 CL.AddConstantN('WM_MDIMAXIMIZE','LongWord').SetUInt( $0225);
 CL.AddConstantN('WM_MDITILE','LongWord').SetUInt( $0226);
 CL.AddConstantN('WM_MDICASCADE','LongWord').SetUInt( $0227);
 CL.AddConstantN('WM_MDIICONARRANGE','LongWord').SetUInt( $0228);
 CL.AddConstantN('WM_MDIGETACTIVE','LongWord').SetUInt( $0229);
 CL.AddConstantN('WM_MDISETMENU','LongWord').SetUInt( $0230);
 CL.AddConstantN('WM_ENTERSIZEMOVE','LongWord').SetUInt( $0231);
 CL.AddConstantN('WM_EXITSIZEMOVE','LongWord').SetUInt( $0232);
 CL.AddConstantN('WM_DROPFILES','LongWord').SetUInt( $0233);
 CL.AddConstantN('WM_MDIREFRESHMENU','LongWord').SetUInt( $0234);
 CL.AddConstantN('WM_MOUSEHOVER','LongWord').SetUInt( $02A1);
 CL.AddConstantN('WM_MOUSELEAVE','LongWord').SetUInt( $02A3);
 CL.AddConstantN('WM_NCMOUSEHOVER','LongWord').SetUInt( $02A0);
 CL.AddConstantN('WM_NCMOUSELEAVE','LongWord').SetUInt( $02A2);
 CL.AddConstantN('WM_WTSSESSION_CHANGE','LongWord').SetUInt( $02B1);
 CL.AddConstantN('WM_TABLET_FIRST','LongWord').SetUInt( $02C0);
 CL.AddConstantN('WM_TABLET_LAST','LongWord').SetUInt( $02DF);
 CL.AddConstantN('WM_CUT','LongWord').SetUInt( $0300);
 CL.AddConstantN('WM_COPY','LongWord').SetUInt( $0301);
 CL.AddConstantN('WM_PASTE','LongWord').SetUInt( $0302);
 CL.AddConstantN('WM_CLEAR','LongWord').SetUInt( $0303);
 CL.AddConstantN('WM_UNDO','LongWord').SetUInt( $0304);
 CL.AddConstantN('WM_RENDERFORMAT','LongWord').SetUInt( $0305);
 CL.AddConstantN('WM_RENDERALLFORMATS','LongWord').SetUInt( $0306);
 CL.AddConstantN('WM_DESTROYCLIPBOARD','LongWord').SetUInt( $0307);
 CL.AddConstantN('WM_DRAWCLIPBOARD','LongWord').SetUInt( $0308);
 CL.AddConstantN('WM_PAINTCLIPBOARD','LongWord').SetUInt( $0309);
 CL.AddConstantN('WM_VSCROLLCLIPBOARD','LongWord').SetUInt( $030A);
 CL.AddConstantN('WM_SIZECLIPBOARD','LongWord').SetUInt( $030B);
 CL.AddConstantN('WM_ASKCBFORMATNAME','LongWord').SetUInt( $030C);
 CL.AddConstantN('WM_CHANGECBCHAIN','LongWord').SetUInt( $030D);
 CL.AddConstantN('WM_HSCROLLCLIPBOARD','LongWord').SetUInt( $030E);
 CL.AddConstantN('WM_QUERYNEWPALETTE','LongWord').SetUInt( $030F);
 CL.AddConstantN('WM_PALETTEISCHANGING','LongWord').SetUInt( $0310);
 CL.AddConstantN('WM_PALETTECHANGED','LongWord').SetUInt( $0311);
 CL.AddConstantN('WM_HOTKEY','LongWord').SetUInt( $0312);
 CL.AddConstantN('WM_PRINT','LongInt').SetInt( 791);
 CL.AddConstantN('WM_PRINTCLIENT','LongInt').SetInt( 792);
 CL.AddConstantN('WM_APPCOMMAND','LongWord').SetUInt( $0319);
 CL.AddConstantN('WM_THEMECHANGED','LongWord').SetUInt( $031A);
 CL.AddConstantN('WM_HANDHELDFIRST','LongInt').SetInt( 856);
 CL.AddConstantN('WM_HANDHELDLAST','LongInt').SetInt( 863);
 CL.AddConstantN('WM_PENWINFIRST','LongWord').SetUInt( $0380);
 CL.AddConstantN('WM_PENWINLAST','LongWord').SetUInt( $038F);
 CL.AddConstantN('WM_COALESCE_FIRST','LongWord').SetUInt( $0390);
 CL.AddConstantN('WM_COALESCE_LAST','LongWord').SetUInt( $039F);
 CL.AddConstantN('WM_DDE_FIRST','LongWord').SetUInt( $03E0);
 CL.AddConstantN('WM_DDE_INITIATE','LongInt').SetInt( WM_DDE_FIRST + 0);
 CL.AddConstantN('WM_DDE_TERMINATE','LongInt').SetInt( WM_DDE_FIRST + 1);
 CL.AddConstantN('WM_DDE_ADVISE','LongInt').SetInt( WM_DDE_FIRST + 2);
 CL.AddConstantN('WM_DDE_UNADVISE','LongInt').SetInt( WM_DDE_FIRST + 3);
 CL.AddConstantN('WM_DDE_ACK','LongInt').SetInt( WM_DDE_FIRST + 4);
 CL.AddConstantN('WM_DDE_DATA','LongInt').SetInt( WM_DDE_FIRST + 5);
 CL.AddConstantN('WM_DDE_REQUEST','LongInt').SetInt( WM_DDE_FIRST + 6);
 CL.AddConstantN('WM_DDE_POKE','LongInt').SetInt( WM_DDE_FIRST + 7);
 CL.AddConstantN('WM_DDE_EXECUTE','LongInt').SetInt( WM_DDE_FIRST + 8);
 CL.AddConstantN('WM_DDE_LAST','LongInt').SetInt( WM_DDE_FIRST + 8);
 CL.AddConstantN('WM_DWMCOMPOSITIONCHANGED','LongWord').SetUInt( $031E);
 CL.AddConstantN('WM_DWMNCRENDERINGCHANGED','LongWord').SetUInt( $031F);
 CL.AddConstantN('WM_DWMCOLORIZATIONCOLORCHANGED','LongWord').SetUInt( $0320);
 CL.AddConstantN('WM_DWMWINDOWMAXIMIZEDCHANGE','LongWord').SetUInt( $0321);
 CL.AddConstantN('WM_APP','LongWord').SetUInt( $8000);
 CL.AddConstantN('WM_USER','LongWord').SetUInt( $0400);
 CL.AddConstantN('BN_CLICKED','LongInt').SetInt( 0);
 CL.AddConstantN('BN_PAINT','LongInt').SetInt( 1);
 CL.AddConstantN('BN_HILITE','LongInt').SetInt( 2);
 CL.AddConstantN('BN_UNHILITE','LongInt').SetInt( 3);
 CL.AddConstantN('BN_DISABLE','LongInt').SetInt( 4);
 CL.AddConstantN('BN_DOUBLECLICKED','LongInt').SetInt( 5);
 //CL.AddConstantN('BN_PUSHED','').SetString( BN_HILITE);
 //CL.AddConstantN('BN_UNPUSHED','').SetString( BN_UNHILITE);
 //CL.AddConstantN('BN_DBLCLK','').SetString( BN_DOUBLECLICKED);
 CL.AddConstantN('BN_SETFOCUS','LongInt').SetInt( 6);
 CL.AddConstantN('BN_KILLFOCUS','LongInt').SetInt( 7);
 CL.AddConstantN('BM_GETCHECK','LongWord').SetUInt( $00F0);
 CL.AddConstantN('BM_SETCHECK','LongWord').SetUInt( $00F1);
 CL.AddConstantN('BM_GETSTATE','LongWord').SetUInt( $00F2);
 CL.AddConstantN('BM_SETSTATE','LongWord').SetUInt( $00F3);
 CL.AddConstantN('BM_SETSTYLE','LongWord').SetUInt( $00F4);
 CL.AddConstantN('BM_CLICK','LongWord').SetUInt( $00F5);
 CL.AddConstantN('BM_GETIMAGE','LongWord').SetUInt( $00F6);
 CL.AddConstantN('BM_SETIMAGE','LongWord').SetUInt( $00F7);
 CL.AddConstantN('LBN_ERRSPACE','LongInt').SetInt( ( - 2 ));
 CL.AddConstantN('LBN_SELCHANGE','LongInt').SetInt( 1);
 CL.AddConstantN('LBN_DBLCLK','LongInt').SetInt( 2);
 CL.AddConstantN('LBN_SELCANCEL','LongInt').SetInt( 3);
 CL.AddConstantN('LBN_SETFOCUS','LongInt').SetInt( 4);
 CL.AddConstantN('LBN_KILLFOCUS','LongInt').SetInt( 5);
 CL.AddConstantN('LB_ADDSTRING','LongWord').SetUInt( $0180);
 CL.AddConstantN('LB_INSERTSTRING','LongWord').SetUInt( $0181);
 CL.AddConstantN('LB_DELETESTRING','LongWord').SetUInt( $0182);
 CL.AddConstantN('LB_SELITEMRANGEEX','LongWord').SetUInt( $0183);
 CL.AddConstantN('LB_RESETCONTENT','LongWord').SetUInt( $0184);
 CL.AddConstantN('LB_SETSEL','LongWord').SetUInt( $0185);
 CL.AddConstantN('LB_SETCURSEL','LongWord').SetUInt( $0186);
 CL.AddConstantN('LB_GETSEL','LongWord').SetUInt( $0187);
 CL.AddConstantN('LB_GETCURSEL','LongWord').SetUInt( $0188);
 CL.AddConstantN('LB_GETTEXT','LongWord').SetUInt( $0189);
 CL.AddConstantN('LB_GETTEXTLEN','LongWord').SetUInt( $018A);
 CL.AddConstantN('LB_GETCOUNT','LongWord').SetUInt( $018B);
 CL.AddConstantN('LB_SELECTSTRING','LongWord').SetUInt( $018C);
 CL.AddConstantN('LB_DIR','LongWord').SetUInt( $018D);
 CL.AddConstantN('LB_GETTOPINDEX','LongWord').SetUInt( $018E);
 CL.AddConstantN('LB_FINDSTRING','LongWord').SetUInt( $018F);
 CL.AddConstantN('LB_GETSELCOUNT','LongWord').SetUInt( $0190);
 CL.AddConstantN('LB_GETSELITEMS','LongWord').SetUInt( $0191);
 CL.AddConstantN('LB_SETTABSTOPS','LongWord').SetUInt( $0192);
 CL.AddConstantN('LB_GETHORIZONTALEXTENT','LongWord').SetUInt( $0193);
 CL.AddConstantN('LB_SETHORIZONTALEXTENT','LongWord').SetUInt( $0194);
 CL.AddConstantN('LB_SETCOLUMNWIDTH','LongWord').SetUInt( $0195);
 CL.AddConstantN('LB_ADDFILE','LongWord').SetUInt( $0196);
 CL.AddConstantN('LB_SETTOPINDEX','LongWord').SetUInt( $0197);
 CL.AddConstantN('LB_GETITEMRECT','LongWord').SetUInt( $0198);
 CL.AddConstantN('LB_GETITEMDATA','LongWord').SetUInt( $0199);
 CL.AddConstantN('LB_SETITEMDATA','LongWord').SetUInt( $019A);
 CL.AddConstantN('LB_SELITEMRANGE','LongWord').SetUInt( $019B);
 CL.AddConstantN('LB_SETANCHORINDEX','LongWord').SetUInt( $019C);
 CL.AddConstantN('LB_GETANCHORINDEX','LongWord').SetUInt( $019D);
 CL.AddConstantN('LB_SETCARETINDEX','LongWord').SetUInt( $019E);
 CL.AddConstantN('LB_GETCARETINDEX','LongWord').SetUInt( $019F);
 CL.AddConstantN('LB_SETITEMHEIGHT','LongWord').SetUInt( $01A0);
 CL.AddConstantN('LB_GETITEMHEIGHT','LongWord').SetUInt( $01A1);
 CL.AddConstantN('LB_FINDSTRINGEXACT','LongWord').SetUInt( $01A2);
 CL.AddConstantN('LB_SETLOCALE','LongWord').SetUInt( $01A5);
 CL.AddConstantN('LB_GETLOCALE','LongWord').SetUInt( $01A6);
 CL.AddConstantN('LB_SETCOUNT','LongWord').SetUInt( $01A7);
 CL.AddConstantN('LB_INITSTORAGE','LongWord').SetUInt( $01A8);
 CL.AddConstantN('LB_ITEMFROMPOINT','LongWord').SetUInt( $01A9);
 CL.AddConstantN('LB_MSGMAX','LongInt').SetInt( 432);
 CL.AddConstantN('CBN_ERRSPACE','LongInt').SetInt( ( - 1 ));
 CL.AddConstantN('CBN_SELCHANGE','LongInt').SetInt( 1);
 CL.AddConstantN('CBN_DBLCLK','LongInt').SetInt( 2);
 CL.AddConstantN('CBN_SETFOCUS','LongInt').SetInt( 3);
 CL.AddConstantN('CBN_KILLFOCUS','LongInt').SetInt( 4);
 CL.AddConstantN('CBN_EDITCHANGE','LongInt').SetInt( 5);
 CL.AddConstantN('CBN_EDITUPDATE','LongInt').SetInt( 6);
 CL.AddConstantN('CBN_DROPDOWN','LongInt').SetInt( 7);
 CL.AddConstantN('CBN_CLOSEUP','LongInt').SetInt( 8);
 CL.AddConstantN('CBN_SELENDOK','LongInt').SetInt( 9);
 CL.AddConstantN('CBN_SELENDCANCEL','LongInt').SetInt( 10);
 CL.AddConstantN('CB_GETEDITSEL','LongWord').SetUInt( $0140);
 CL.AddConstantN('CB_LIMITTEXT','LongWord').SetUInt( $0141);
 CL.AddConstantN('CB_SETEDITSEL','LongWord').SetUInt( $0142);
 CL.AddConstantN('CB_ADDSTRING','LongWord').SetUInt( $0143);
 CL.AddConstantN('CB_DELETESTRING','LongWord').SetUInt( $0144);
 CL.AddConstantN('CB_DIR','LongWord').SetUInt( $0145);
 CL.AddConstantN('CB_GETCOUNT','LongWord').SetUInt( $0146);
 CL.AddConstantN('CB_GETCURSEL','LongWord').SetUInt( $0147);
 CL.AddConstantN('CB_GETLBTEXT','LongWord').SetUInt( $0148);
 CL.AddConstantN('CB_GETLBTEXTLEN','LongWord').SetUInt( $0149);
 CL.AddConstantN('CB_INSERTSTRING','LongWord').SetUInt( $014A);
 CL.AddConstantN('CB_RESETCONTENT','LongWord').SetUInt( $014B);
 CL.AddConstantN('CB_FINDSTRING','LongWord').SetUInt( $014C);
 CL.AddConstantN('CB_SELECTSTRING','LongWord').SetUInt( $014D);
 CL.AddConstantN('CB_SETCURSEL','LongWord').SetUInt( $014E);
 CL.AddConstantN('CB_SHOWDROPDOWN','LongWord').SetUInt( $014F);
 CL.AddConstantN('CB_GETITEMDATA','LongWord').SetUInt( $0150);
 CL.AddConstantN('CB_SETITEMDATA','LongWord').SetUInt( $0151);
 CL.AddConstantN('CB_GETDROPPEDCONTROLRECT','LongWord').SetUInt( $0152);
 CL.AddConstantN('CB_SETITEMHEIGHT','LongWord').SetUInt( $0153);
 CL.AddConstantN('CB_GETITEMHEIGHT','LongWord').SetUInt( $0154);
 CL.AddConstantN('CB_SETEXTENDEDUI','LongWord').SetUInt( $0155);
 CL.AddConstantN('CB_GETEXTENDEDUI','LongWord').SetUInt( $0156);
 CL.AddConstantN('CB_GETDROPPEDSTATE','LongWord').SetUInt( $0157);
 CL.AddConstantN('CB_FINDSTRINGEXACT','LongWord').SetUInt( $0158);
 CL.AddConstantN('CB_SETLOCALE','LongInt').SetInt( 345);
 CL.AddConstantN('CB_GETLOCALE','LongInt').SetInt( 346);
 CL.AddConstantN('CB_GETTOPINDEX','LongInt').SetInt( 347);
 CL.AddConstantN('CB_SETTOPINDEX','LongInt').SetInt( 348);
 CL.AddConstantN('CB_GETHORIZONTALEXTENT','LongInt').SetInt( 349);
 CL.AddConstantN('CB_SETHORIZONTALEXTENT','LongInt').SetInt( 350);
 CL.AddConstantN('CB_GETDROPPEDWIDTH','LongInt').SetInt( 351);
 CL.AddConstantN('CB_SETDROPPEDWIDTH','LongInt').SetInt( 352);
 CL.AddConstantN('CB_INITSTORAGE','LongInt').SetInt( 353);
 CL.AddConstantN('CB_MSGMAX','LongInt').SetInt( 354);
 CL.AddConstantN('EN_SETFOCUS','LongWord').SetUInt( $0100);
 CL.AddConstantN('EN_KILLFOCUS','LongWord').SetUInt( $0200);
 CL.AddConstantN('EN_CHANGE','LongWord').SetUInt( $0300);
 CL.AddConstantN('EN_UPDATE','LongWord').SetUInt( $0400);
 CL.AddConstantN('EN_ERRSPACE','LongWord').SetUInt( $0500);
 CL.AddConstantN('EN_MAXTEXT','LongWord').SetUInt( $0501);
 CL.AddConstantN('EN_HSCROLL','LongWord').SetUInt( $0601);
 CL.AddConstantN('EN_VSCROLL','LongWord').SetUInt( $0602);
 CL.AddConstantN('EM_GETSEL','LongWord').SetUInt( $00B0);
 CL.AddConstantN('EM_SETSEL','LongWord').SetUInt( $00B1);
 CL.AddConstantN('EM_GETRECT','LongWord').SetUInt( $00B2);
 CL.AddConstantN('EM_SETRECT','LongWord').SetUInt( $00B3);
 CL.AddConstantN('EM_SETRECTNP','LongWord').SetUInt( $00B4);
 CL.AddConstantN('EM_SCROLL','LongWord').SetUInt( $00B5);
 CL.AddConstantN('EM_LINESCROLL','LongWord').SetUInt( $00B6);
 CL.AddConstantN('EM_SCROLLCARET','LongWord').SetUInt( $00B7);
 CL.AddConstantN('EM_GETMODIFY','LongWord').SetUInt( $00B8);
 CL.AddConstantN('EM_SETMODIFY','LongWord').SetUInt( $00B9);
 CL.AddConstantN('EM_GETLINECOUNT','LongWord').SetUInt( $00BA);
 CL.AddConstantN('EM_LINEINDEX','LongWord').SetUInt( $00BB);
 CL.AddConstantN('EM_SETHANDLE','LongWord').SetUInt( $00BC);
 CL.AddConstantN('EM_GETHANDLE','LongWord').SetUInt( $00BD);
 CL.AddConstantN('EM_GETTHUMB','LongWord').SetUInt( $00BE);
 CL.AddConstantN('EM_LINELENGTH','LongWord').SetUInt( $00C1);
 CL.AddConstantN('EM_REPLACESEL','LongWord').SetUInt( $00C2);
 CL.AddConstantN('EM_GETLINE','LongWord').SetUInt( $00C4);
 CL.AddConstantN('EM_LIMITTEXT','LongWord').SetUInt( $00C5);
 CL.AddConstantN('EM_CANUNDO','LongWord').SetUInt( $00C6);
 CL.AddConstantN('EM_UNDO','LongWord').SetUInt( $00C7);
 CL.AddConstantN('EM_FMTLINES','LongWord').SetUInt( $00C8);
 CL.AddConstantN('EM_LINEFROMCHAR','LongWord').SetUInt( $00C9);
 CL.AddConstantN('EM_SETTABSTOPS','LongWord').SetUInt( $00CB);
 CL.AddConstantN('EM_SETPASSWORDCHAR','LongWord').SetUInt( $00CC);
 CL.AddConstantN('EM_EMPTYUNDOBUFFER','LongWord').SetUInt( $00CD);
 CL.AddConstantN('EM_GETFIRSTVISIBLELINE','LongWord').SetUInt( $00CE);
 CL.AddConstantN('EM_SETREADONLY','LongWord').SetUInt( $00CF);
 CL.AddConstantN('EM_SETWORDBREAKPROC','LongWord').SetUInt( $00D0);
 CL.AddConstantN('EM_GETWORDBREAKPROC','LongWord').SetUInt( $00D1);
 CL.AddConstantN('EM_GETPASSWORDCHAR','LongWord').SetUInt( $00D2);
 CL.AddConstantN('EM_SETMARGINS','LongInt').SetInt( 211);
 CL.AddConstantN('EM_GETMARGINS','LongInt').SetInt( 212);
 CL.AddConstantN('EM_SETLIMITTEXT','longint').SetInt( $00C5);
 CL.AddConstantN('EM_GETLIMITTEXT','LongInt').SetInt( 213);
 CL.AddConstantN('EM_POSFROMCHAR','LongInt').SetInt( 214);
 CL.AddConstantN('EM_CHARFROMPOS','LongInt').SetInt( 215);
 CL.AddConstantN('EM_SETIMESTATUS','LongInt').SetInt( 216);
 CL.AddConstantN('EM_GETIMESTATUS','LongInt').SetInt( 217);
 CL.AddConstantN('SBM_SETPOS','LongInt').SetInt( 224);
 CL.AddConstantN('SBM_GETPOS','LongInt').SetInt( 225);
 CL.AddConstantN('SBM_SETRANGE','LongInt').SetInt( 226);
 CL.AddConstantN('SBM_SETRANGEREDRAW','LongInt').SetInt( 230);
 CL.AddConstantN('SBM_GETRANGE','LongInt').SetInt( 227);
 CL.AddConstantN('SBM_ENABLE_ARROWS','LongInt').SetInt( 228);
 CL.AddConstantN('SBM_SETSCROLLINFO','LongInt').SetInt( 233);
 CL.AddConstantN('SBM_GETSCROLLINFO','LongInt').SetInt( 234);
  CL.AddConstantN('PRF_CHECKVISIBLE','LongInt').SetInt( 1);
 CL.AddConstantN('PRF_NONCLIENT','LongInt').SetInt( 2);
 CL.AddConstantN('PRF_CLIENT','LongInt').SetInt( 4);
 CL.AddConstantN('PRF_ERASEBKGND','LongInt').SetInt( 8);
 CL.AddConstantN('PRF_CHILDREN','LongWord').SetUInt( $10);
 CL.AddConstantN('PRF_OWNED','LongWord').SetUInt( $20);
 CL.AddConstantN('BDR_RAISEDOUTER','LongInt').SetInt( 1);
 CL.AddConstantN('BDR_SUNKENOUTER','LongInt').SetInt( 2);
 CL.AddConstantN('BDR_RAISEDINNER','LongInt').SetInt( 4);
 CL.AddConstantN('BDR_SUNKENINNER','LongInt').SetInt( 8);
 CL.AddConstantN('BDR_OUTER','LongInt').SetInt( 3);
 CL.AddConstantN('BDR_INNER','LongInt').SetInt( 12);
 CL.AddConstantN('BDR_RAISED','LongInt').SetInt( 5);
 CL.AddConstantN('BDR_SUNKEN','LongInt').SetInt( 10);
 //CL.AddConstantN('OLE_E_FIRST','LongWord').SetUInt( HRESULT ( $80040000 ));
 //CL.AddConstantN('OLE_E_LAST','LongWord').SetUInt( HRESULT ( $800400FF ));
 CL.AddConstantN('OLE_S_FIRST','LongWord').SetUInt( $40000);
 CL.AddConstantN('OLE_S_LAST','LongWord').SetUInt( $400FF);
 CL.AddConstantN('OLE_E_OLEVERB','LongWord').SetUInt(( $80040000 ));
 CL.AddConstantN('OLE_E_ADVF','LongWord').SetUInt(( $80040001 ));
 CL.AddConstantN('OLE_E_ENUM_NOMORE','LongWord').SetUInt(  ( $80040002 ));
 CL.AddConstantN('OLE_E_ADVISENOTSUPPORTED','LongWord').SetUInt(  ( $80040003 ));
 CL.AddConstantN('OLE_E_NOCONNECTION','LongWord').SetUInt(  ( $80040004 ));
 CL.AddConstantN('OLE_E_NOTRUNNING','LongWord').SetUInt(  ( $80040005 ));
 CL.AddConstantN('OLE_E_NOCACHE','LongWord').SetUInt(  ( $80040006 ));
 CL.AddConstantN('OLE_E_BLANK','LongWord').SetUInt( ( $80040007 ));
 CL.AddConstantN('OLE_E_CLASSDIFF','LongWord').SetUInt(( $80040008 ));
 CL.AddConstantN('OLE_E_CANT_GETMONIKER','LongWord').SetUInt(( $80040009 ));
 CL.AddConstantN('OLE_E_CANT_BINDTOSOURCE','LongWord').SetUInt(( $8004000A ));
 CL.AddConstantN('OLE_E_STATIC','LongWord').SetUInt( ( $8004000B ));
 CL.AddConstantN('OLE_E_PROMPTSAVECANCELLED','LongWord').SetUInt( ( $8004000C ));
 CL.AddConstantN('OLE_E_INVALIDRECT','LongWord').SetUInt( ( $8004000D ));
 CL.AddConstantN('OLE_E_WRONGCOMPOBJ','LongWord').SetUInt(( $8004000E ));
 CL.AddConstantN('OLE_E_INVALIDHWND','LongWord').SetUInt( ( $8004000F ));
 CL.AddConstantN('OLE_E_NOT_INPLACEACTIVE','LongWord').SetUInt( ( $80040010 ));
 CL.AddConstantN('OLE_E_CANTCONVERT','LongWord').SetUInt(  ( $80040011 ));
 CL.AddConstantN('OLE_E_NOSTORAGE','LongWord').SetUInt( ( $80040012 ));
 CL.AddConstantN('E_UNEXPECTED','LongWord').SetUInt(  ( $8000FFFF ));
 CL.AddConstantN('E_NOTIMPL','LongWord').SetUInt(  ( $80004001 ));
 CL.AddConstantN('E_OUTOFMEMORY','LongWord').SetUInt(( $8007000E ));
 CL.AddConstantN('E_INVALIDARG','LongWord').SetUInt( ( $80070057 ));
 CL.AddConstantN('E_NOINTERFACE','LongWord').SetUInt( ( $80004002 ));
 CL.AddConstantN('E_POINTER','LongWord').SetUInt( ( $80004003 ));
 CL.AddConstantN('E_HANDLE','LongWord').SetUInt( ( $80070006 ));
 CL.AddConstantN('E_ABORT','LongWord').SetUInt( ( $80004004 ));
 CL.AddConstantN('E_FAIL','LongWord').SetUInt( ( $80004005 ));
 CL.AddConstantN('E_ACCESSDENIED','LongWord').SetUInt(( $80070005 ));
 CL.AddConstantN('E_PENDING','LongWord').SetUInt( ( $8000000A ));
 CL.AddConstantN('MARSHAL_S_FIRST','LongWord').SetUInt( $40120);
 CL.AddConstantN('MARSHAL_S_LAST','LongWord').SetUInt( $4012F);
 CL.AddConstantN('NULLREGION','LongInt').SetInt( 1);
 CL.AddConstantN('SIMPLEREGION','LongInt').SetInt( 2);
 CL.AddConstantN('COMPLEXREGION','LongInt').SetInt( 3);

 // {$EXTERNALSYM EM_GETIMESTATUS}
  //EM_GETIMESTATUS        = 217;

  CL.AddTypeS('tagFONTSIGNATURE',' record fsUsb: array[0..3] of DWORD; fsCsb: array[0..1] of DWORD; end');
  CL.AddTypeS('TFontSignature', 'tagFONTSIGNATURE');
  CL.AddTypeS('FONTSIGNATURE', 'tagFONTSIGNATURE');

 CL.AddTypeS('tagBITMAPCOREHEADER', 'record bcSize : DWORD; bcWidth : Word; bc'
   +'Height : Word; bcPlanes : Word; bcBitCount : Word; end');
  CL.AddTypeS('TBitmapCoreHeader', 'tagBITMAPCOREHEADER');
  CL.AddTypeS('BITMAPCOREHEADER', 'tagBITMAPCOREHEADER');

  CL.AddTypeS('tagCHARSETINFO', 'record ciCharset : UINT; ciACP : UINT; fs : TFontSignature; end');
  CL.AddTypeS('TCharsetInfo', 'tagCHARSETINFO');
  CL.AddTypeS('CHARSETINFO', 'tagCHARSETINFO');

  CL.AddTypeS('tagMETAHEADER', 'record mtType : Word; mtHeaderSize : Word; mtVe'
   +'rsion : Word; mtSize : DWORD; mtNoObjects : Word; mtMaxRecord : DWORD; mtN'
   +'oParameters : Word; end');
  CL.AddTypeS('TMetaHeader', 'tagMETAHEADER');
  CL.AddTypeS('METAHEADER', 'tagMETAHEADER');
   CL.AddTypeS('tagENHMETAHEADER', 'record iType : DWORD; nSize : DWORD; rclBoun'
   +'ds : TRect; rclFrame : TRect; dSignature : DWORD; nVersion : DWORD; nBytes'
   +' : DWORD; nRecords : DWORD; nHandles : Word; sReserved : Word; nDescriptio'
   +'n : DWORD; offDescription : DWORD; nPalEntries : DWORD; szlDevice : TSize;'
   +' szlMillimeters : TSize; cbPixelFormat : DWORD; offPixelFormat : DWORD; bO'
   +'penGL : DWORD; end');
  CL.AddTypeS('TEnhMetaHeader', 'tagENHMETAHEADER');
  CL.AddTypeS('ENHMETAHEADER', 'tagENHMETAHEADER');
 CL.AddConstantN('TMPF_FIXED_PITCH','LongInt').SetInt( 1);
 CL.AddConstantN('TMPF_VECTOR','LongInt').SetInt( 2);
 CL.AddConstantN('TMPF_DEVICE','LongInt').SetInt( 8);
 CL.AddConstantN('TMPF_TRUETYPE','LongInt').SetInt( 4);

   CL.AddTypeS('tagPANOSE', 'record bFamilyType : Byte; bSerifStyle : Byte; bWei'
   +'ght : Byte; bProportion : Byte; bContrast : Byte; bStrokeVariation : Byte;'
   +' bArmStyle : Byte; bLetterform : Byte; bMidline : Byte; bXHeight : Byte; end');
  CL.AddTypeS('TPanose', 'tagPANOSE');
  CL.AddTypeS('PANOSE', 'tagPANOSE');
    CL.AddTypeS('_RASTERIZER_STATUS', 'record nSize : SHORT; wFlags : SHORT; nLanguageID : SHORT; end');
  CL.AddTypeS('TRasterizerStatus', '_RASTERIZER_STATUS');
  CL.AddTypeS('RASTERIZER_STATUS', '_RASTERIZER_STATUS');

  CL.AddDelphiFunction('Function GetCharWidth( DC : HDC; FirstChar, LastChar : UINT; const Widths: UInt) : BOOL');
  CL.AddDelphiFunction('Function GetCharWidth32( DC : HDC; FirstChar, LastChar : UINT; const Widths: UInt) : BOOL');
 CL.AddDelphiFunction('Function GetClipBox( DC : HDC; var Rect : TRect) : Integer');
 CL.AddDelphiFunction('Function GetClipRgn( DC : HDC; rgn : HRGN) : Integer');
 CL.AddDelphiFunction('Function GetMetaRgn( DC : HDC; rgn : HRGN) : Integer');
  CL.AddDelphiFunction('Function LineTo( DC : HDC; X, Y : Integer) : BOOL');
 CL.AddDelphiFunction('Function ImpersonateSelf( ImpersonationLevel : TSecurityImpersonationLevel) : BOOL');
 CL.AddDelphiFunction('Function VerLanguageName( wLang : DWORD; szLang : PChar; nSize : DWORD) : DWORD');
  CL.AddDelphiFunction('Function SetEvent( hEvent : THandle) : BOOL');
 CL.AddDelphiFunction('Function ResetEvent( hEvent : THandle) : BOOL');
 CL.AddDelphiFunction('Function PulseEvent( hEvent : THandle) : BOOL');
 CL.AddDelphiFunction('Function ReleaseMutex( hMutex : THandle) : BOOL');
 CL.AddDelphiFunction('Function ReleaseSemaphore( hSemaphore : THandle; lReleaseCount : Longint; lpPreviousCount : ___Pointer) : BOOL');
  CL.AddDelphiFunction('Function GetAtomName( nAtom : ATOM; lpBuffer : PChar; nSize : Integer) : UINT');
  CL.AddDelphiFunction('Function GlobalAddAtom( lpString : PChar) : ATOM');
 CL.AddDelphiFunction('Function GlobalFindAtom( lpString : PChar) : ATOM');
 CL.AddDelphiFunction('Function GlobalGetAtomName( nAtom : ATOM; lpBuffer : PChar; nSize : Integer) : UINT');
  CL.AddDelphiFunction('Function GetProfileInt( lpAppName, lpKeyName : PChar; nDefault : Integer) : UINT');
CL.AddDelphiFunction('Function GetProfileString( lpAppName, lpKeyName, lpDefault : PChar; lpReturnedString : PChar; nSize : DWORD) : DWORD');
  CL.AddDelphiFunction('Function GetProfileSection( lpAppName : PChar; lpReturnedString : PChar; nSize : DWORD) : DWORD');
  CL.AddDelphiFunction('Function WriteProfileString( lpAppName, lpKeyName, lpString : PChar) : BOOL');
 CL.AddDelphiFunction('Function AddAtom( lpString : PChar) : ATOM');
 CL.AddDelphiFunction('Function FindAtom( lpString : PChar) : ATOM');


    CL.AddTypeS('tagLOGFONTA', 'record lfHeight: longint; lfWidth : longint;'
   +'lfEscapement : longint; lfOrientation : longint; lfWeight : longInt;'
   +'lfItalic: byte; lfUnderline : byte; lfStrikeOut: byte; lfCharSet'
   +' : byte; lfOutPrecision : byte; lfClipPrecision : byte; lfQuality'
   +': byte; lfPitchAndFamily : byte; lfFaceName: array[0..32 - 1] of Char; end');

  CL.AddTypeS('_SYSTEM_POWER_STATUS', 'record ACLineStatus : Byte; BatteryFlag '
   +': Byte; BatteryLifePercent : Byte; Reserved1 : Byte; BatteryLifeTime : DWORD; BatteryFullLifeTime : DWORD; end');
  CL.AddTypeS('TSystemPowerStatus', '_SYSTEM_POWER_STATUS');
  CL.AddTypeS('SYSTEM_POWER_STATUS', '_SYSTEM_POWER_STATUS');

  //TCanvas
  //Em_setrect

  {tagLOGFONTA = packed record
    lfHeight: Longint;
    lfWidth: Longint;
    lfEscapement: Longint;
    lfOrientation: Longint;
    lfWeight: Longint;
    lfItalic: Byte;
    lfUnderline: Byte;
    lfStrikeOut: Byte;
    lfCharSet: Byte;
    lfOutPrecision: Byte;
    lfClipPrecision: Byte;
    lfQuality: Byte;
    lfPitchAndFamily: Byte;
    lfFaceName: array[0..LF_FACESIZE - 1] of AnsiChar;
  end;}

   CL.AddTypeS('tagLOGFONT', 'tagLOGFONTA');
  CL.AddTypeS('TLogFontA', 'tagLOGFONTA');
 // CL.AddTypeS('TLogFontW', 'tagLOGFONTW');
  CL.AddTypeS('TLogFont', 'TLogFontA');

  {_PRIVILEGE_SET = record
    PrivilegeCount: DWORD;
    Control: DWORD;
    Privilege: array[0..0] of TLUIDAndAttributes;
  end; }

     CL.AddTypeS('_PRIVILEGE_SET', 'record PrivilegeCount: DWORD; Control: DWORD;'
   +'Privilege: array[0..0] of TLUIDAndAttributes; end');

  CL.AddTypeS('TPrivilegeSet', '_PRIVILEGE_SET');

  //TPrivilegeSet = _PRIVILEGE_SET;

   CL.AddTypeS('tagNONCLIENTMETRICSA', 'record cbSize : UINT; iBorderWidth : Int'
   +'eger; iScrollWidth : Integer; iScrollHeight : Integer; iCaptionWidth : Int'
   +'eger; iCaptionHeight : Integer; lfCaptionFont : TLogFontA; iSmCaptionWidth'
   +' : Integer; iSmCaptionHeight : Integer; lfSmCaptionFont : TLogFontA; iMenu'
   +'Width : Integer; iMenuHeight : Integer; lfMenuFont : TLogFontA; lfStatusFo'
   +'nt : TLogFontA; lfMessageFont : TLogFontA; end');

  CL.AddTypeS('LOGFONTA', 'tagLOGFONTA');
  //CL.AddTypeS('LOGFONTW', 'tagLOGFONTW');
  CL.AddTypeS('LOGFONT', 'LOGFONTA');


 CL.AddTypeS('tagNONCLIENTMETRICS', 'tagNONCLIENTMETRICSA');
  CL.AddTypeS('TNonClientMetricsA', 'tagNONCLIENTMETRICSA');
   CL.AddTypeS('TNonClientMetrics', 'TNonClientMetricsA');
  CL.AddTypeS('NONCLIENTMETRICSA', 'tagNONCLIENTMETRICSA');
  //CL.AddTypeS('NONCLIENTMETRICSW', 'tagNONCLIENTMETRICSW');
  CL.AddTypeS('NONCLIENTMETRICS', 'NONCLIENTMETRICSA');

 CL.AddTypeS('TFNSendAsyncProc', 'TFarProc');

 (*CL.AddTypeS('_ENUM_SERVICE_STATUS_PROCESSA', 'record lpServiceName : LPSTR; l'
   +'pDisplayName : LPSTR; ServiceStatusProcess : SERVICE_STATUS_PROCESS; end');
  CL.AddTypeS('ENUM_SERVICE_STATUS_PROCESSA', '_ENUM_SERVICE_STATUS_PROCESSA');
  CL.AddTypeS('TEnumServiceStatusProcessA', 'ENUM_SERVICE_STATUS_PROCESSA');
  CL.AddTypeS('PEnumServiceStatusProcessA', 'LPENUM_SERVICE_STATUS_PROCESSA');
  CL.AddTypeS('_ENUM_SERVICE_STATUS_PROCESSW', 'record lpServiceName : LPWSTR; '
   +'lpDisplayName : LPWSTR; ServiceStatusProcess : SERVICE_STATUS_PROCESS; end');
  CL.AddTypeS('ENUM_SERVICE_STATUS_PROCESSW', '_ENUM_SERVICE_STATUS_PROCESSW');
  CL.AddTypeS('TEnumServiceStatusProcessW', 'ENUM_SERVICE_STATUS_PROCESSW');
  CL.AddTypeS('PEnumServiceStatusProcessW', 'LPENUM_SERVICE_STATUS_PROCESSW');
  CL.AddTypeS('ENUM_SERVICE_STATUS_PROCESS', 'ENUM_SERVICE_STATUS_PROCESSW');
  CL.AddTypeS('LPENUM_SERVICE_STATUS_PROCESS', 'LPENUM_SERVICE_STATUS_PROCESSW');
  CL.AddTypeS('TEnumServiceStatusProcess', 'TEnumServiceStatusProcessW');
  CL.AddTypeS('PEnumServiceStatusProcess', 'PEnumServiceStatusProcessW');
  CL.AddTypeS('ENUM_SERVICE_STATUS_PROCESS', 'ENUM_SERVICE_STATUS_PROCESSA');
  CL.AddTypeS('LPENUM_SERVICE_STATUS_PROCESS', 'LPENUM_SERVICE_STATUS_PROCESSA');
  CL.AddTypeS('TEnumServiceStatusProcess', 'TEnumServiceStatusProcessA');
  CL.AddTypeS('PEnumServiceStatusProcess', 'PEnumServiceStatusProcessA'); *)
 CL.AddDelphiFunction('Function QueryServiceConfig2A( hService : SC_HANDLE; dwInfoLevel : DWORD; var lpBuffer : BYTE; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function QueryServiceConfig2W( hService : SC_HANDLE; dwInfoLevel : DWORD; var lpBuffer : BYTE; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function QueryServiceConfig2( hService : SC_HANDLE; dwInfoLevel : DWORD; var lpBuffer : BYTE; cbBufSize : DWORD; var pcbBytesNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function EnumServicesStatusExA(hSCManager: SC_HANDLE; InfoLevel: DWord; dwServiceType: DWORD; dwServiceState: DWORD;'+
                      ' var lpServices : BYTE; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned, lpResumeHandle : DWORD; var pszGroupName : string) : BOOL');
 CL.AddDelphiFunction('Function EnumServicesStatusExW( hSCManager : SC_HANDLE; InfoLevel : DWord; dwServiceType : DWORD; dwServiceState : DWORD;'+
                     ' var lpServices : BYTE; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned, lpResumeHandle : DWORD; var pszGroupName : string) : BOOL');
 CL.AddDelphiFunction('Function EnumServicesStatusEx( hSCManager : SC_HANDLE; InfoLevel : Dword; dwServiceType : DWORD; dwServiceState : DWORD;'+
                     ' var lpServices : BYTE; cbBufSize : DWORD; var pcbBytesNeeded, lpServicesReturned, lpResumeHandle : DWORD; var pszGroupName : string) : BOOL');
 CL.AddDelphiFunction('Function ConvertSidToStringSid( sid : Dword; var stringSid : string) : BOOL');

 CL.AddDelphiFunction('Procedure GetSystemInfo( var lpSystemInfo : TSystemInfo)');
 CL.AddDelphiFunction('Function IsProcessorFeaturePresent( ProcessorFeature : DWORD) : BOOL');
  CL.AddDelphiFunction('Function SetStdHandle( nStdHandle : DWORD; hHandle : THandle) : BOOL');
 CL.AddDelphiFunction('Function DeviceIoControl( hDevice : THandle; dwIoControlCode : DWORD; lpInBuffer : TObject; nInBufferSize : DWORD; lpOutBuffer: TObject; nOutBufferSize: DWORD; var lpBytesReturned: DWORD; lpOverlapped : TOverlapped) : BOOL');
 CL.AddDelphiFunction('Function SetFileTime( hFile : THandle; lpCreationTime, lpLastAccessTime, lpLastWriteTime : TFileTime) : BOOL');
 CL.AddDelphiFunction('Function DuplicateHandle( hSourceProcessHandle, hSourceHandle, hTargetProcessHandle : THandle; lpTargetHandle : THandle; dwDesiredAccess : DWORD; bInheritHandle : BOOL; dwOptions : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetHandleInformation( hObject : THandle; var lpdwFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetHandleInformation( hObject : THandle; dwMask : DWORD; dwFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('procedure makeCaption(leftSide, Rightside:string; form:TForm);');
 CL.AddDelphiFunction('Function OpenProcessToken( ProcessHandle : THandle; DesiredAccess : DWORD; var TokenHandle : THandle) : BOOL');
 CL.AddDelphiFunction('Function OpenThreadToken( ThreadHandle : THandle; DesiredAccess : DWORD; OpenAsSelf : BOOL; var TokenHandle : THandle) : BOOL');
 CL.AddDelphiFunction('Function PrivilegeCheck( ClientToken : THandle; const RequiredPrivileges : TPrivilegeSet; var pfResult : BOOL) : BOOL');
 CL.AddDelphiFunction('Procedure SetFileApisToOEM');
 CL.AddDelphiFunction('Procedure SetFileApisToANSI');
 CL.AddDelphiFunction('Function AreFileApisANSI : BOOL');
 CL.AddDelphiFunction('Function RevertToSelf : BOOL');
 CL.AddDelphiFunction('Function SendMessageTimeout( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM; fuFlags, uTimeout : UINT; var lpdwResult : DWORD) : LRESULT');
 CL.AddDelphiFunction('Function SendMessageCallback( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM; lpResultCallBack : TFNSendAsyncProc; dwData : DWORD) : BOOL');
  CL.AddDelphiFunction('Function SetErrorMode( uMode : UINT) : UINT');
 //CL.AddDelphiFunction('Function Succeeded( Status : HRESULT) : BOOL');
 //CL.AddDelphiFunction('Function Failed( Status : HRESULT) : BOOL');
 //CL.AddDelphiFunction('Function IsError( Status : HRESULT) : BOOL');
 CL.AddDelphiFunction('Function HResultCode( hr : HRESULT) : Integer');
 CL.AddDelphiFunction('Function HResultFacility( hr : HRESULT) : Integer');
 CL.AddDelphiFunction('Function HResultSeverity( hr : HRESULT) : Integer');
 CL.AddDelphiFunction('Function MakeResult( sev, fac, code : Integer) : HResult');
 CL.AddConstantN('FACILITY_NT_BIT','LongWord').SetUInt( $10000000);
 CL.AddDelphiFunction('Function HResultFromWin32( x : Integer) : HRESULT');
 CL.AddDelphiFunction('Function HResultFromNT( x : Integer) : HRESULT');
 CL.AddDelphiFunction('Function GetSystemPowerStatus( var lpSystemPowerStatus : TSystemPowerStatus) : BOOL');
 CL.AddDelphiFunction('Function SetSystemPowerState( fSuspend, fForce : BOOL) : BOOL');
 CL.AddDelphiFunction('Function CloseEventLog( hEventLog : THandle) : BOOL');
 CL.AddDelphiFunction('Function DeregisterEventSource( hEventLog : THandle) : BOOL');
 CL.AddDelphiFunction('Function NotifyChangeEventLog( hEventLog, hEvent : THandle) : BOOL');
 CL.AddDelphiFunction('Function GetNumberOfEventLogRecords( hEventLog : THandle; var NumberOfRecords : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetOldestEventLogRecord( hEventLog : THandle; var OldestRecord : DWORD) : BOOL');
  CL.AddTypeS('_DEBUG_EVENT', 'record dwDebugEventCode : DWORD; dwProcessId : DWORD; dwThreadId : DWORD; end');
  CL.AddTypeS('TDebugEvent', '_DEBUG_EVENT');
  CL.AddTypeS('DEBUG_EVENT', '_DEBUG_EVENT');

    CL.AddDelphiFunction('Function ContinueDebugEvent( dwProcessId, dwThreadId, dwContinueStatus : DWORD) : BOOL');
 CL.AddDelphiFunction('Function DebugActiveProcess( dwProcessId : DWORD) : BOOL');
 CL.AddDelphiFunction('Function WaitForDebugEvent( var lpDebugEvent : TDebugEvent; dwMilliseconds : DWORD) : BOOL');
  CL.AddDelphiFunction('Procedure FatalAppExit( uAction : UINT; lpMessageText : PChar)');

   CL.AddTypeS('_LDT_ENTRY', 'record LimitLow : DWORD; BaseLow : DWORD; Flags : Longint; end');

  CL.AddTypeS('TLDTEntry', '_LDT_ENTRY');
  CL.AddTypeS('LDT_ENTRY', '_LDT_ENTRY');
   CL.AddConstantN('SLE_ERROR','LongInt').SetInt( 1);
 CL.AddConstantN('SLE_MINORERROR','LongInt').SetInt( 2);
 CL.AddConstantN('SLE_WARNING','LongInt').SetInt( 3);

  CL.AddDelphiFunction('Function GetThreadSelectorEntry( hThread : THandle; dwSelector : DWORD; var lpSelectorEntry : TLDTEntry) : BOOL');
  CL.AddDelphiFunction('Procedure SetDebugErrorLevel( dwLevel : DWORD)');
 CL.AddDelphiFunction('Function CreateFileMapping( hFile : THandle; lpFileMappingAttributes : PSecurityAttributes; flProtect, dwMaximumSizeHigh, dwMaximumSizeLow : DWORD; lpName : PChar) : THandle');
 CL.AddDelphiFunction('Function OpenFileMapping( dwDesiredAccess : DWORD; bInheritHandle : BOOL; lpName : PChar) : THandle');
   CL.AddDelphiFunction('Function GetProcessHeap : THandle');
 CL.AddDelphiFunction('Function GetProcessHeaps( NumberOfHeaps : DWORD; var ProcessHeaps : THandle) : DWORD');
  CL.AddDelphiFunction('Function GlobalAlloc( uFlags : UINT; dwBytes : DWORD) : HGLOBAL');
 CL.AddDelphiFunction('Function GlobalReAlloc( hMem : HGLOBAL; dwBytes : DWORD; uFlags : UINT) : HGLOBAL');
 CL.AddDelphiFunction('Function GlobalSize( hMem : HGLOBAL) : DWORD');
 CL.AddDelphiFunction('Function GlobalFlags( hMem : HGLOBAL) : UINT');
 //CL.AddDelphiFunction('Function GlobalLock( hMem : HGLOBAL) : Pointer');
 CL.AddDelphiFunction('Function GlobalUnlock( hMem : HGLOBAL) : BOOL');
 CL.AddDelphiFunction('Function GlobalFree( hMem : HGLOBAL) : HGLOBAL');
 CL.AddDelphiFunction('Function GlobalCompact( dwMinFree : DWORD) : UINT');
 CL.AddDelphiFunction('Procedure GlobalFix( hMem : HGLOBAL)');
 CL.AddDelphiFunction('Procedure GlobalUnfix( hMem : HGLOBAL)');
 CL.AddDelphiFunction('Function GlobalUnWire( hMem : HGLOBAL) : BOOL');
 CL.AddDelphiFunction('Procedure GlobalMemoryStatus( var lpBuffer : TMemoryStatus)');
 CL.AddDelphiFunction('Function LocalAlloc( uFlags, uBytes : UINT) : HLOCAL');
CL.AddDelphiFunction('Function HeapCreate( flOptions, dwInitialSize, dwMaximumSize : DWORD) : THandle');
 CL.AddDelphiFunction('Function HeapDestroy( hHeap : THandle) : BOOL');
 CL.AddDelphiFunction('Function HeapCompact( hHeap : THandle; dwFlags : DWORD) : UINT');
CL.AddDelphiFunction('Function HeapLock( hHeap : THandle) : BOOL');
 CL.AddDelphiFunction('Function HeapUnlock( hHeap : THandle) : BOOL');
CL.AddDelphiFunction('Function IsBadStringPtr( lpsz : PChar; ucchMax : UINT) : BOOL');
 CL.AddDelphiFunction('Function GetEnvironmentStrings : PChar');
 CL.AddDelphiFunction('Function FreeEnvironmentStrings( EnvBlock : PChar) : BOOL');
 CL.AddDelphiFunction('Function TlsAlloc : DWORD');
 CL.AddConstantN('TLS_OUT_OF_INDEXES','LongWord').SetUInt( DWORD ( $FFFFFFFF ));
 CL.AddDelphiFunction('Function TlsFree( dwTlsIndex : DWORD) : BOOL');
 //CL.AddDelphiFunction('Procedure GetStartupInfo( var lpStartupInfo : TStartupInfo)');
 CL.AddDelphiFunction('Function SetWindowText( hWnd : HWND; lpString : PChar) : BOOL');
 CL.AddDelphiFunction('Function GetWindowText( hWnd : HWND; lpString : PChar; nMaxCount : Integer) : Integer');
 CL.AddDelphiFunction('Function GetWindowTextLength( hWnd : HWND) : Integer');
 CL.AddDelphiFunction('Function GetClientRect( hWnd : HWND; var lpRect : TRect) : BOOL');
 CL.AddDelphiFunction('Function GetWindowRect( hWnd : HWND; var lpRect : TRect) : BOOL');
 CL.AddDelphiFunction('Function AdjustWindowRect( var lpRect : TRect; dwStyle : DWORD; bMenu : BOOL) : BOOL');
 CL.AddDelphiFunction('Function AdjustWindowRectEx( var lpRect : TRect; dwStyle : DWORD; bMenu : BOOL; dwExStyle : DWORD) : BOOL');
 CL.AddDelphiFunction('Function EnumThreadWindows( dwThreadId : DWORD; lpfn : Tobject; lParam : LPARAM) : BOOL');
 CL.AddDelphiFunction('procedure GetKLList(List: TStrings);');
 CL.AddDelphiFunction('procedure GetKeyboardList(List: TStrings);');
 CL.AddDelphiFunction('function SetSuspendState(Hibernate, ForceCritical, DisableWakeEvent: Boolean):boolean');
 CL.AddDelphiFunction('function ServiceRunning(sMachine, sService: PChar): Boolean;');
 CL.AddDelphiFunction('function isServiceRunning(sMachine, sService: PChar): Boolean;');
 CL.AddDelphiFunction('Function WriteFile2( hFile : THandle; const Buffer, nNumberOfBytesToWrite : DWORD; var lpNumberOfBytesWritten : DWORD; lpOverlapped : Tobject) : BOOL');
 CL.AddDelphiFunction('Function ReadFile2( hFile : THandle; var Buffer, nNumberOfBytesToRead : DWORD; var lpNumberOfBytesRead : DWORD; lpOverlapped : Tobject) : BOOL');
 CL.AddDelphiFunction('Function CreateNamedPipe( lpName : PChar; dwOpenMode, dwPipeMode, nMaxInstances, nOutBufferSize, nInBufferSize, nDefaultTimeOut : DWORD; lpSecurityAttributes : PChar) : THandle');
 CL.AddDelphiFunction('Function GetNamedPipeHandleState( hNamedPipe : THandle; lpState, lpCurInstances, lpMaxCollectionCount, lpCollectDataTimeout : Pchar; lpUserName : PChar; nMaxUserNameSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function CallNamedPipe( lpNamedPipeName : PChar; lpInBuffer : pchar; nInBufferSize : DWORD; lpOutBuffer : Pchar; nOutBufferSize : DWORD; var lpBytesRead : DWORD; nTimeOut : DWORD) : BOOL');
 CL.AddDelphiFunction('Function WaitNamedPipe( lpNamedPipeName : PChar; nTimeOut : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetKernelObjectSecurity( Handle : THandle; RequestedInformation : pchar; pSecurityDescriptor : Pchar; nLength : DWORD; var lpnLengthNeeded : DWORD) : BOOL');
  CL.AddDelphiFunction('Function AreAllAccessesGranted( GrantedAccess, DesiredAccess : DWORD) : BOOL');
 CL.AddDelphiFunction('Function AreAnyAccessesGranted( GrantedAccess, DesiredAccess : DWORD) : BOOL');
 CL.AddDelphiFunction('Procedure MapGenericMask( var AccessMask : DWORD; const GenericMapping : TGenericMapping)');
  CL.AddDelphiFunction('Function ConnectNamedPipe( hNamedPipe : THandle; lpOverlapped : Pchar) : BOOL');
 CL.AddDelphiFunction('Function DisconnectNamedPipe( hNamedPipe : THandle) : BOOL');
 // CL.AddDelphiFunction('Function EncryptFile( lpFilename : PChar) : BOOL');
 //CL.AddDelphiFunction('Function DecryptFile( lpFilename : PChar; dwReserved : DWORD) : BOOL');
 CL.AddConstantN('EFS_USE_RECOVERY_KEYS','LongWord').SetUInt( $1);
 CL.AddConstantN('CREATE_FOR_IMPORT','LongInt').SetInt( 1);
 CL.AddConstantN('CREATE_FOR_DIR','LongInt').SetInt( 2);
 CL.AddDelphiFunction('Function CreateMailslot( lpName : PChar; nMaxMessageSize : DWORD; lReadTimeout : DWORD; lpSecurityAttributes : Pchar) : THandle');
 CL.AddDelphiFunction('Function GetMailslotInfo( hMailslot : THandle; lpMaxMessageSize : pchar; var lpNextSize : DWORD; lpMessageCount, lpReadTimeout : Pchar) : BOOL');
 CL.AddDelphiFunction('Function SetMailslotInfo( hMailslot : THandle; lReadTimeout : DWORD) : BOOL');
 CL.AddDelphiFunction('procedure BackgroundWorkerWaitFor(isworking: boolean; fWindow: HWND);');
 CL.AddDelphiFunction('function AttachConsole(dwProcessID: Integer): Boolean;');
 CL.AddDelphiFunction('function FreeConsole(): Boolean;');

  //TPrivilegeSet
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_WinAPI_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetAdaptersInfo, 'GetAdaptersInfo', CdStdCall);
 S.RegisterDelphiFunction(@QueryServiceConfig2A, 'QueryServiceConfig2A', CdStdCall);
 S.RegisterDelphiFunction(@QueryServiceConfig2W, 'QueryServiceConfig2W', CdStdCall);
 S.RegisterDelphiFunction(@QueryServiceConfig2, 'QueryServiceConfig2', CdStdCall);
 S.RegisterDelphiFunction(@EnumServicesStatusExA, 'EnumServicesStatusExA', CdStdCall);
 S.RegisterDelphiFunction(@EnumServicesStatusExW, 'EnumServicesStatusExW', CdStdCall);
 S.RegisterDelphiFunction(@EnumServicesStatusEx, 'EnumServicesStatusEx', CdStdCall);
 S.RegisterDelphiFunction(@ConvertSidToStringSid, 'ConvertSidToStringSid', CdStdCall);
 S.RegisterDelphiFunction(@GetSystemInfo, 'GetSystemInfo', CdStdCall);
 S.RegisterDelphiFunction(@IsProcessorFeaturePresent, 'IsProcessorFeaturePresent', CdStdCall);
 S.RegisterDelphiFunction(@SetStdHandle, 'SetStdHandle', CdStdCall);
// S.RegisterDelphiFunction(@WriteFile, 'WriteFile', CdStdCall);
// S.RegisterDelphiFunction(@ReadFile, 'ReadFile', CdStdCall);
 //S.RegisterDelphiFunction(@FlushFileBuffers, 'FlushFileBuffers', CdStdCall);
 S.RegisterDelphiFunction(@DeviceIoControl, 'DeviceIoControl', CdStdCall);
 S.RegisterDelphiFunction(@SetEndOfFile, 'SetEndOfFile', CdStdCall);
// S.RegisterDelphiFunction(@SetFilePointer, 'SetFilePointer', CdStdCall);
// S.RegisterDelphiFunction(@FindClose, 'FindClose', CdStdCall);
// S.RegisterDelphiFunction(@GetFileTime, 'GetFileTime', CdStdCall);
 S.RegisterDelphiFunction(@SetFileTime, 'SetFileTime', CdStdCall);
 //S.RegisterDelphiFunction(@CloseHandle, 'CloseHandle', CdStdCall);
 S.RegisterDelphiFunction(@DuplicateHandle, 'DuplicateHandle', CdStdCall);
 S.RegisterDelphiFunction(@GetHandleInformation, 'GetHandleInformation', CdStdCall);
 S.RegisterDelphiFunction(@SetHandleInformation, 'SetHandleInformation', CdStdCall);
 S.RegisterDelphiFunction(@makeCaption, 'makeCaption', cdRegister);
  S.RegisterDelphiFunction(@OpenProcessToken, 'OpenProcessToken', CdStdCall);
 S.RegisterDelphiFunction(@OpenThreadToken, 'OpenThreadToken', CdStdCall);
 S.RegisterDelphiFunction(@PrivilegeCheck, 'PrivilegeCheck', CdStdCall);
 S.RegisterDelphiFunction(@RevertToSelf, 'RevertToSelf', CdStdCall);
 //S.RegisterDelphiFunction(@SetThreadToken, 'SetThreadToken', CdStdCall);
 //S.RegisterDelphiFunction(@AccessCheck, 'AccessCheck', CdStdCall);
 S.RegisterDelphiFunction(@SetFileApisToOEM, 'SetFileApisToOEM', CdStdCall);
 S.RegisterDelphiFunction(@SetFileApisToANSI, 'SetFileApisToANSI', CdStdCall);
 S.RegisterDelphiFunction(@AreFileApisANSI, 'AreFileApisANSI', CdStdCall);
  S.RegisterDelphiFunction(@SendMessageTimeout, 'SendMessageTimeout', CdStdCall);
 S.RegisterDelphiFunction(@SendMessageCallback, 'SendMessageCallback', CdStdCall);
 S.RegisterDelphiFunction(@SetErrorMode, 'SetErrorMode', CdStdCall);
 S.RegisterDelphiFunction(@HResultCode, 'HResultCode', cdRegister);
 S.RegisterDelphiFunction(@HResultFacility, 'HResultFacility', cdRegister);
 S.RegisterDelphiFunction(@HResultSeverity, 'HResultSeverity', cdRegister);
 S.RegisterDelphiFunction(@MakeResult, 'MakeResult', cdRegister);
 S.RegisterDelphiFunction(@HResultFromWin32, 'HResultFromWin32', cdRegister);
 S.RegisterDelphiFunction(@HResultFromNT, 'HResultFromNT', cdRegister);
 S.RegisterDelphiFunction(@GetSystemPowerStatus, 'GetSystemPowerStatus', CdStdCall);
 S.RegisterDelphiFunction(@SetSystemPowerState, 'SetSystemPowerState', CdStdCall);
  S.RegisterDelphiFunction(@GetCharWidth, 'GetCharWidth', CdStdCall);
  S.RegisterDelphiFunction(@GetCharWidth32, 'GetCharWidth32', CdStdCall);
  S.RegisterDelphiFunction(@GetClipBox, 'GetClipBox', CdStdCall);
 S.RegisterDelphiFunction(@GetClipRgn, 'GetClipRgn', CdStdCall);
 S.RegisterDelphiFunction(@GetMetaRgn, 'GetMetaRgn', CdStdCall);
  S.RegisterDelphiFunction(@LineTo, 'LineTo', CdStdCall);
   S.RegisterDelphiFunction(@ImpersonateSelf, 'ImpersonateSelf', CdStdCall);
 S.RegisterDelphiFunction(@CloseEventLog, 'CloseEventLog', CdStdCall);
 S.RegisterDelphiFunction(@DeregisterEventSource, 'DeregisterEventSource', CdStdCall);
 S.RegisterDelphiFunction(@NotifyChangeEventLog, 'NotifyChangeEventLog', CdStdCall);
 S.RegisterDelphiFunction(@GetNumberOfEventLogRecords, 'GetNumberOfEventLogRecords', CdStdCall);
 S.RegisterDelphiFunction(@GetOldestEventLogRecord, 'GetOldestEventLogRecord', CdStdCall);
  S.RegisterDelphiFunction(@WaitForDebugEvent, 'WaitForDebugEvent', CdStdCall);
 S.RegisterDelphiFunction(@ContinueDebugEvent, 'ContinueDebugEvent', CdStdCall);
 S.RegisterDelphiFunction(@DebugActiveProcess, 'DebugActiveProcess', CdStdCall);
 S.RegisterDelphiFunction(@FatalAppExit, 'FatalAppExit', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadSelectorEntry, 'GetThreadSelectorEntry', CdStdCall);
   S.RegisterDelphiFunction(@SetDebugErrorLevel, 'SetDebugErrorLevel', CdStdCall);
  S.RegisterDelphiFunction(@CreateFileMapping, 'CreateFileMapping', CdStdCall);
  S.RegisterDelphiFunction(@OpenFileMapping, 'OpenFileMapping', CdStdCall);
 S.RegisterDelphiFunction(@GetProcessHeap, 'GetProcessHeap', CdStdCall);
 S.RegisterDelphiFunction(@GetProcessHeaps, 'GetProcessHeaps', CdStdCall);
  S.RegisterDelphiFunction(@GlobalAlloc, 'GlobalAlloc', CdStdCall);
 S.RegisterDelphiFunction(@GlobalReAlloc, 'GlobalReAlloc', CdStdCall);
 S.RegisterDelphiFunction(@GlobalSize, 'GlobalSize', CdStdCall);
 S.RegisterDelphiFunction(@GlobalFlags, 'GlobalFlags', CdStdCall);
 S.RegisterDelphiFunction(@GlobalLock, 'GlobalLock', CdStdCall);
 S.RegisterDelphiFunction(@GlobalUnlock, 'GlobalUnlock', CdStdCall);
 S.RegisterDelphiFunction(@GlobalFree, 'GlobalFree', CdStdCall);
 S.RegisterDelphiFunction(@GlobalCompact, 'GlobalCompact', CdStdCall);
 S.RegisterDelphiFunction(@GlobalFix, 'GlobalFix', CdStdCall);
 S.RegisterDelphiFunction(@GlobalUnfix, 'GlobalUnfix', CdStdCall);
 S.RegisterDelphiFunction(@GlobalUnWire, 'GlobalUnWire', CdStdCall);
 S.RegisterDelphiFunction(@GlobalMemoryStatus, 'GlobalMemoryStatus', CdStdCall);
 S.RegisterDelphiFunction(@HeapCreate, 'HeapCreate', CdStdCall);
 S.RegisterDelphiFunction(@HeapDestroy, 'HeapDestroy', CdStdCall);
 S.RegisterDelphiFunction(@HeapCompact, 'HeapCompact', CdStdCall);
 S.RegisterDelphiFunction(@HeapLock, 'HeapLock', CdStdCall);
 S.RegisterDelphiFunction(@HeapUnlock, 'HeapUnlock', CdStdCall);
  S.RegisterDelphiFunction(@IsBadStringPtr, 'IsBadStringPtr', CdStdCall);
 S.RegisterDelphiFunction(@GetEnvironmentStrings, 'GetEnvironmentStrings', CdStdCall);
 S.RegisterDelphiFunction(@FreeEnvironmentStrings, 'FreeEnvironmentStrings', CdStdCall);
  //S.RegisterDelphiFunction(@GetStartupInfo, 'GetStartupInfo', CdStdCall);
S.RegisterDelphiFunction(@TlsAlloc, 'TlsAlloc', CdStdCall);
 S.RegisterDelphiFunction(@TlsFree, 'TlsFree', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowText, 'SetWindowText', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowText, 'GetWindowText', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowTextLength, 'GetWindowTextLength', CdStdCall);
 S.RegisterDelphiFunction(@GetClientRect, 'GetClientRect', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowRect, 'GetWindowRect', CdStdCall);
 S.RegisterDelphiFunction(@AdjustWindowRect, 'AdjustWindowRect', CdStdCall);
 S.RegisterDelphiFunction(@AdjustWindowRectEx, 'AdjustWindowRectEx', CdStdCall);
 S.RegisterDelphiFunction(@EnumThreadWindows, 'EnumThreadWindows', CdStdCall);
 S.RegisterDelphiFunction(@GetKLList, 'GetKLList', cdRegister);
 S.RegisterDelphiFunction(@GetKLList, 'GetKeyboardList', cdRegister);
 S.RegisterDelphiFunction(@SetSuspendState, 'SetSuspendState', cdRegister);
 S.RegisterDelphiFunction(@ServiceRunning, 'ServiceRunning', cdRegister);
 S.RegisterDelphiFunction(@ServiceRunning, 'isServiceRunning', cdRegister);
  S.RegisterDelphiFunction(@WriteFile, 'WriteFile2', CdStdCall);
 S.RegisterDelphiFunction(@ReadFile, 'ReadFile2', CdStdCall);
 S.RegisterDelphiFunction(@AreAllAccessesGranted, 'AreAllAccessesGranted', CdStdCall);
 S.RegisterDelphiFunction(@AreAnyAccessesGranted, 'AreAnyAccessesGranted', CdStdCall);
 S.RegisterDelphiFunction(@MapGenericMask, 'MapGenericMask', CdStdCall);
 S.RegisterDelphiFunction(@GetKernelObjectSecurity, 'GetKernelObjectSecurity', CdStdCall);
  S.RegisterDelphiFunction(@CreateNamedPipe, 'CreateNamedPipe', CdStdCall);
 S.RegisterDelphiFunction(@GetNamedPipeHandleState, 'GetNamedPipeHandleState', CdStdCall);
 S.RegisterDelphiFunction(@CallNamedPipe, 'CallNamedPipe', CdStdCall);
 S.RegisterDelphiFunction(@WaitNamedPipe, 'WaitNamedPipe', CdStdCall);
S.RegisterDelphiFunction(@ConnectNamedPipe, 'ConnectNamedPipe', CdStdCall);
 S.RegisterDelphiFunction(@DisconnectNamedPipe, 'DisconnectNamedPipe', CdStdCall);
 S.RegisterDelphiFunction(@CreateMailslot, 'CreateMailslot', CdStdCall);
// S.RegisterDelphiFunction(@EncryptFile, 'EncryptFile', CdStdCall);
// S.RegisterDelphiFunction(@DecryptFile, 'DecryptFile', CdStdCall);
  S.RegisterDelphiFunction(@GetMailslotInfo, 'GetMailslotInfo', CdStdCall);
 S.RegisterDelphiFunction(@SetMailslotInfo, 'SetMailslotInfo', CdStdCall);
S.RegisterDelphiFunction(@VerLanguageName, 'VerLanguageName', CdStdCall);
  S.RegisterDelphiFunction(@SetEvent, 'SetEvent', CdStdCall);
 S.RegisterDelphiFunction(@ResetEvent, 'ResetEvent', CdStdCall);
 S.RegisterDelphiFunction(@PulseEvent, 'PulseEvent', CdStdCall);
 S.RegisterDelphiFunction(@ReleaseSemaphore, 'ReleaseSemaphore', CdStdCall);
 S.RegisterDelphiFunction(@ReleaseMutex, 'ReleaseMutex', CdStdCall);

 S.RegisterDelphiFunction(@GlobalAddAtom, 'GlobalAddAtom', CdStdCall);
 S.RegisterDelphiFunction(@GlobalFindAtom, 'GlobalFindAtom', CdStdCall);
 S.RegisterDelphiFunction(@GlobalGetAtomName, 'GlobalGetAtomName', CdStdCall);
 S.RegisterDelphiFunction(@AddAtom, 'AddAtom', CdStdCall);
 S.RegisterDelphiFunction(@FindAtom, 'FindAtom', CdStdCall);
 S.RegisterDelphiFunction(@GetAtomName, 'GetAtomName', CdStdCall);
 S.RegisterDelphiFunction(@GetProfileInt, 'GetProfileInt', CdStdCall);
 S.RegisterDelphiFunction(@GetProfileString, 'GetProfileString', CdStdCall);
 S.RegisterDelphiFunction(@WriteProfileString, 'WriteProfileString', CdStdCall);
 S.RegisterDelphiFunction(@GetProfileSection, 'GetProfileSection', CdStdCall);
 S.RegisterDelphiFunction(@TBackgroundWorkerWaitFor, 'BackgroundWorkerWaitFor', CdStdCall);

 S.RegisterDelphiFunction(@AttachConsole, 'AttachConsole', CdStdCall);
 S.RegisterDelphiFunction(@FreeConsole, 'FreeConsole', CdStdCall);


 //procedure TBackgroundWorkerWaitFor(isworking: boolean; fWindow: HWND);


end;


 
{ TPSImport_WinAPI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinAPI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WinAPI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinAPI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_WinAPI(ri);
  RIRegister_WinAPI_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 

end.
