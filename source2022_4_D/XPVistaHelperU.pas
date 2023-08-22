//{$I ..\switches.inc}

unit XPVistaHelperU;

//mixed with a function block

interface

uses Forms, Graphics, Windows;

const
    { Possible values for "dwReturnedProductType" in "GetProductInfo" }
    PRODUCT_UNDEFINED                       = $00000000;

    PRODUCT_ULTIMATE                        = $00000001;
    PRODUCT_HOME_BASIC                      = $00000002;
    PRODUCT_HOME_PREMIUM                    = $00000003;
    PRODUCT_ENTERPRISE                      = $00000004;
    PRODUCT_HOME_BASIC_N                    = $00000005;
    PRODUCT_BUSINESS                        = $00000006;
    PRODUCT_STANDARD_SERVER                 = $00000007;
    PRODUCT_DATACENTER_SERVER               = $00000008;
    PRODUCT_SMALLBUSINESS_SERVER            = $00000009;
    PRODUCT_ENTERPRISE_SERVER               = $0000000A;
    PRODUCT_STARTER                         = $0000000B;
    PRODUCT_DATACENTER_SERVER_CORE          = $0000000C;
    PRODUCT_STANDARD_SERVER_CORE            = $0000000D;
    PRODUCT_ENTERPRISE_SERVER_CORE          = $0000000E;
    PRODUCT_ENTERPRISE_SERVER_IA64          = $0000000F;
    PRODUCT_BUSINESS_N                      = $00000010;
    PRODUCT_WEB_SERVER                      = $00000011;
    PRODUCT_CLUSTER_SERVER                  = $00000012;
    PRODUCT_HOME_SERVER                     = $00000013;
    PRODUCT_STORAGE_EXPRESS_SERVER          = $00000014;
    PRODUCT_STORAGE_STANDARD_SERVER         = $00000015;
    PRODUCT_STORAGE_WORKGROUP_SERVER        = $00000016;
    PRODUCT_STORAGE_ENTERPRISE_SERVER       = $00000017;
    PRODUCT_SERVER_FOR_SMALLBUSINESS        = $00000018;
    PRODUCT_SMALLBUSINESS_SERVER_PREMIUM    = $00000019;

    PRODUCT_UNLICENSED                      = $ABCDABCD;

    { Possible values for the "wSuiteMask" field in "OSVersionInfoEx" }
    //VER_SERVER_NT                      = $80000000;
    //VER_WORKSTATION_NT                 = $40000000;
    //VER_SUITE_SMALLBUSINESS            = $00000001;
    //VER_SUITE_ENTERPRISE               = $00000002;
    //VER_SUITE_BACKOFFICE               = $00000004;
    //VER_SUITE_COMMUNICATIONS           = $00000008;
    //VER_SUITE_TERMINAL                 = $00000010;
    //VER_SUITE_SMALLBUSINESS_RESTRICTED = $00000020;
    //VER_SUITE_EMBEDDEDNT               = $00000040;
    //VER_SUITE_DATACENTER               = $00000080;
    //VER_SUITE_SINGLEUSERTS             = $00000100;
    //VER_SUITE_PERSONAL                 = $00000200;
    //VER_SUITE_BLADE                    = $00000400;

    { Possible values for the "wProductType" field in "OSVersionInfoEx" }
    //VER_NT_WORKSTATION       = $0000001;
    //VER_NT_DOMAIN_CONTROLLER = $0000002;
    //VER_NT_SERVER            = $0000003;

type
    //POSVERSIONINFOEXA = ^OSVERSIONINFOEXA;
    _OSVERSIONINFOEXA = record
        dwOSVersionInfoSize: DWORD;
        dwMajorVersion: DWORD;
        dwMinorVersion: DWORD;
        dwBuildNumber: DWORD;
        dwPlatformId: DWORD;
        szCSDVersion: array [0..127] of CHAR;     // Maintenance string for PSS usage
        wServicePackMajor: WORD;
        wServicePackMinor: WORD;
        wSuiteMask: WORD;
        wProductType: BYTE;
        wReserved: BYTE;
    end;
    OSVERSIONINFOEXA = _OSVERSIONINFOEXA;
    //LPOSVERSIONINFOEXA = ^OSVERSIONINFOEXA;
    TOSVersionInfoExA = _OSVERSIONINFOEXA;
    TOSVersionInfoEx = TOSVersionInfoExA;

//from elevationutils

function SetSystemTime(DateTime : TDateTime; DOW : word) : boolean;
{ Systemzeit ändern
  DateTime: Zu setzendes Datum und Uhrzeit
  DOW: Wochentag (Montag=1, Sonntag=7)
  Funktionsergebnis: true, wenn Aktion erfogreich }


    function IsElevated: Boolean;

procedure CoCreateInstanceAsAdmin(
  aHWnd: HWND;           // parent for elevation prompt window
  const aClassID: TGUID; // COM class guid
  const aIID: TGUID;     // interface id implemented by class
  out aObj               // interface pointer
);


// from nettools

type
  TDrivesProperty = array['A'..'Z'] of boolean;
  TPasswordUsage  = (pu_None, pu_Default, pu_Defined);  // Paßwort bei Laufwerk-Mapping

function TrimNetResource(UNC : string) : string;
// Entfernt alle Unterverzeichnisse einer UNC-Pfadangabe, das heißt, es
// bleibt nur der Rechnername und Netzwerkressource übrig.

procedure GetFreeDrives(var FreeDrives : TDrivesProperty);
// Ermitteln, welche Laufwerksbuchstaben noch frei sind (ab C:)
// Das boolsche Array 'A'..'Z' wird entsprechend besetzt
// true: Laufwerksbuchstabe ist noch frei

procedure GetMappedDrives(var MappedDrives : TDrivesProperty);
// Ermitteln, welche Laufwerksbuchstaben einer Netzwerkressource zugeordnet sind
// Das boolsche Array 'A'..'Z' wird entsprechend besetzt
// true: Laufwerksbuchstabe ist Netzlaufwerk

function MapDrive(UNCPath : string; Drive : char;
                  PasswordUsage : TPasswordUsage; Password : string;
                  UserUsage     : TPasswordUsage; User : string;
                  Comment : string) : boolean;
// Netzlaufwerk mappen
// UNCPath: Netzwerkpfad bestehend aus \\Rechner\Netzressource
// Drive  : lokaler Laufwerksbuchstabe, der dem Netzwerkpfad zugeordnet werden soll
// PasswordUsage: kein, aktuelles oder in Password angegebenes Paßwort verwenden
// Password: zu verwendendes Paßwort, wenn PasswordUsage=pu_Defined
// Comment: Kommentar
// Funktionsergebnis: true, wenn Aktion erfogreich

function UnmapDrive(Drive : char; Force : boolean) : boolean;
// Mapping eines Netzlaufwerks aufheben
// Drive: Buchstabe des gemappten Laufwerks
// Force: true = Aufhebung erzwingen
// Funktionsergebnis: true, wenn Aktion erfolgreich


function IsWindowsVista: Boolean;
procedure SetVistaFonts(const AForm: TForm { TCustomForm });
procedure SetVistaContentFonts(const AFont: TFont);
function GetProductType (var sType: String) : Boolean;

implementation

uses SysUtils,  ActiveX, ComObj;

   //IsNT:=Win32Platform=VER_PLATFORM_WIN32_NT;
const
  { in Delphi nicht deklariertes }
  ANYSIZE_ARRAY    = 1;
  SE_CREATE_TOKEN_NAME        = 'SeCreateTokenPrivilege';
  SE_ASSIGNPRIMARYTOKEN_NAME  = 'SeAssignPrimaryTokenPrivilege';
  SE_LOCK_MEMORY_NAME         = 'SeLockMemoryPrivilege';
  SE_INCREASE_QUOTA_NAME      = 'SeIncreaseQuotaPrivilege';
  SE_UNSOLICITED_INPUT_NAME   = 'SeUnsolicitedInputPrivilege';
  SE_MACHINE_ACCOUNT_NAME     = 'SeMachineAccountPrivilege';
  SE_TCB_NAME                 = 'SeTcbPrivilege';
  SE_SECURITY_NAME            = 'SeSecurityPrivilege';
  SE_TAKE_OWNERSHIP_NAME      = 'SeTakeOwnershipPrivilege';
  SE_LOAD_DRIVER_NAME         = 'SeLoadDriverPrivilege';
  SE_SYSTEM_PROFILE_NAME      = 'SeSystemProfilePrivilege';
  SE_SYSTEMTIME_NAME          = 'SeSystemtimePrivilege';
  SE_PROF_SINGLE_PROCESS_NAME = 'SeProfileSingleProcessPrivilege';
  SE_INC_BASE_PRIORITY_NAME   = 'SeIncreaseBasePriorityPrivilege';
  SE_CREATE_PAGEFILE_NAME     = 'SeCreatePagefilePrivilege';
  SE_CREATE_PERMANENT_NAME    = 'SeCreatePermanentPrivilege';
  SE_BACKUP_NAME              = 'SeBackupPrivilege';
  SE_RESTORE_NAME             = 'SeRestorePrivilege';
  SE_SHUTDOWN_NAME            = 'SeShutdownPrivilege';
  SE_DEBUG_NAME               = 'SeDebugPrivilege';
  SE_AUDIT_NAME               = 'SeAuditPrivilege';
  SE_SYSTEM_ENVIRONMENT_NAME  = 'SeSystemEnvironmentPrivilege';
  SE_CHANGE_NOTIFY_NAME       = 'SeChangeNotifyPrivilege';
  SE_REMOTE_SHUTDOWN_NAME     = 'SeRemoteShutdownPrivilege';

  PrivilegeSet : boolean = false;   // true, wenn SetTimePrivilege erfolgreich aufgerufen
  IsNT : boolean = false;           // true: Plattform Windows NT

function SetTimePrivilege : boolean;
{ Setzt die Erlaubnis, die Systemzeit zu ändern }
var
  hToken : THandle;
  ptkp, ptkpold : PTokenPrivileges;
  r : dword;
begin
  Result:=false;
  // Privileg setzen
  // Token Handle des aktuellen Prozesses ermitteln
  if OpenProcessToken(GetCurrentProcess,
    TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
  begin
    // LUID für shut down ermitteln und Privileg setzen
    GetMem(ptkp,sizeof(TTOKENPRIVILEGES) +
      (1-ANYSIZE_ARRAY) * sizeof(TLUIDANDATTRIBUTES));
    LookupPrivilegeValue(nil, SE_SYSTEMTIME_NAME,
      ptkp^.Privileges[0].Luid);
    ptkp^.PrivilegeCount:=1;  // Anzahl zu setzender Privilegien
    ptkp^.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
    // Privileg für diesen Prozess setzen
    r:=0;
    ptkpold:=nil;
    if AdjustTokenPrivileges(hToken, false, ptkp^, 0, ptkpold^, r) then
    begin
      //PrivilegeSet:=true;
      Result:=true;
    end;
  end;
end;

function SetDateTimeNT(var SystemTime : TSystemTime) : boolean;
{ Ändert die Systemzeit (NT) }
var
  t : TSystemTime;
begin
  Result:=false;
  t:=SystemTime;
  if not PrivilegeSet then SetTimePrivilege;
  if PrivilegeSet then Result:=SetLocalTime(t);
end;

function SetDateTime95(var SystemTime : TSystemTime) : boolean;
{ Ändert die Systemzeit (95/98) }
var
  t : TSystemTime;
begin
  t:=SystemTime;
  Result:=SetLocalTime(t);
end;

function SetSystemTime(DateTime : TDateTime; DOW : word) : boolean;
// DOW Delphi-konform. Das heißt: Montag=1, Sonntag=7
var
  t : TSystemTime;
begin
  DecodeDate(DateTime,t.wYear,t.wMonth,t.wDay);
  DecodeTime(DateTime,t.wHour,t.wMinute,t.wSecond,t.wMilliseconds);
  if DOW=7 then DOW:=0;  // DOW Windows-konform
  t.WdayOfWeek:=DOW;
  if IsNT then Result:=SetDateTimeNT(t)
          else Result:=SetDateTime95(t);
end;


type
  // Vista SDK - extended BIND_OPTS2 struct
  BIND_OPTS3 = packed record
    cbStruct:            DWORD;
    grfFlags:            DWORD;
    grfMode:             DWORD;
    dwTickCountDeadline: DWORD;
    dwTrackFlags:        DWORD;
    dwClassContext:      DWORD;
    locale:              LCID;
    pServerInfo:         PCOSERVERINFO;
    hwnd:                HWND;
  end;
  PBIND_OPTS3 = ^BIND_OPTS3;

  // Vista SDK - extended TOKEN_INFORMATION_CLASS enum
  TOKEN_INFORMATION_CLASS = (
    TokenICPad, // dummy padding element
    TokenUser,
    TokenGroups,
    TokenPrivileges,
    TokenOwner,
    TokenPrimaryGroup,
    TokenDefaultDacl,
    TokenSource,
    TokenType,
    TokenImpersonationLevel,
    TokenStatistics,
    TokenRestrictedSids,
    TokenSessionId,
    TokenGroupsAndPrivileges,
    TokenSessionReference,
    TokenSandBoxInert,
    TokenAuditPolicy,
    TokenOrigin,
    TokenElevationType,
    TokenLinkedToken,
    TokenElevation,
    TokenHasRestrictions,
    TokenAccessInformation,
    TokenVirtualizationAllowed,
    TokenVirtualizationEnabled,
    TokenIntegrityLevel,
    TokenUIAccess,
	TokenMandatoryPolicy,
    TokenLogonSid,
    MaxTokenInfoClass  // MaxTokenInfoClass should always be the last enum
  );

  TOKEN_ELEVATION = packed record
    TokenIsElevated: DWORD;
  end;
  PTOKEN_ELEVATION = ^TOKEN_ELEVATION;

function CoGetObject(pszName: PWideChar; pBindOptions: PBIND_OPTS3;
  const iid: TIID; out ppv
): HResult; stdcall; external 'ole32.dll' name 'CoGetObject';

function GetTokenInformation(TokenHandle: THandle;
  TokenInformationClass: TOKEN_INFORMATION_CLASS; TokenInformation: Pointer;
  TokenInformationLength: DWORD; var ReturnLength: DWORD
): BOOL; stdcall; external advapi32 name 'GetTokenInformation';

function IsElevated: Boolean;
var
  Token: THandle;
  Elevation: TOKEN_ELEVATION;
  Dummy: Cardinal;
begin
  Result := False;
  
  if OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, Token) then begin
    Dummy := 0;
    if GetTokenInformation(Token, TokenElevation, @Elevation,
      SizeOf(TOKEN_ELEVATION), Dummy)
    then
      Result := (Elevation.TokenIsElevated <> 0);

    CloseHandle(Token);
  end;
end;

procedure CoCreateInstanceAsAdmin(aHWnd: HWND; const aClassID, aIID: TGUID;
  out aObj);
var
  BO: BIND_OPTS3;
  MonikerName: WideString;
begin
  if (not IsElevated) then begin
    { Request elevated out-of-process instance. }
    MonikerName := 'Elevation:Administrator!new:' + GUIDToString(aClassID);

    FillChar(BO, SizeOf(BIND_OPTS3), 0);
    BO.cbStruct := SizeOf(BIND_OPTS3);
    BO.dwClassContext := CLSCTX_LOCAL_SERVER;
	BO.hwnd := aHWnd;

    OleCheck(CoGetObject(PWideChar(MonikerName), @BO, aIID, aObj));
  end else
    { Request normal in-process instance. }
    OleCheck(CoCreateInstance(aClassID, nil, CLSCTX_ALL, aIID, aObj));
end;
  

const
  VistaFont = 'Segoe UI';
  VistaContentFont = 'Calibri';
  
  var
    DriveName : array[0..3] of char = 'A:'+#0+#0;

function TrimNetResource(UNC : string) : string;
var
  i, n : integer;
begin
  Result:=UNC;
  if Length(UNC)>0 then begin
    i:=0;
    n:=0;
    repeat
      inc(i);
      inc(n,ord(UNC[i]='\'));
    until (i=Length(UNC)) or (n=4);
    if n=4 then Result:=Copy(UNC,1,i-1)
  end;
end;

procedure GetFreeDrives(var FreeDrives : TDrivesProperty);
var
  d : char;
begin
  for d:='C' to 'Z' do begin
    DriveName[0]:=d;
    FreeDrives[d]:=GetDriveType(@DriveName)<2;
  end;
end;

procedure GetMappedDrives(var MappedDrives : TDrivesProperty);
var
  d : char;
begin
  for d:='A' to 'Z' do
  begin
    DriveName[0]:=d;
    MappedDrives[d]:=GetDriveType(@DriveName)=DRIVE_REMOTE;
  end;
end;

function MapDrive(UNCPath : string; Drive : char;
                  PasswordUsage : TPasswordUsage; Password : string;
                  UserUsage     : TPasswordUsage; User : string;
                  Comment : string) : boolean;
var
  NetResource : TNetResource;
  pwd      : array[0..255] of char;
  username : array[0..255] of char;
  p    : PChar;
  u    : PChar;
begin
  DriveName[0]:=Drive;
  with NetResource do begin
    dwScope:=RESOURCE_GLOBALNET;
    dwType:=RESOURCETYPE_DISK;
    dwDisplayType:=RESOURCEDISPLAYTYPE_GENERIC;
    dwUsage:=RESOURCEUSAGE_CONNECTABLE;
    lpLocalName:=@DriveName;
    lpRemoteName:=PChar(UNCPath);
    lpComment:=PChar(Comment);
    lpProvider:=nil;
  end;
  p:=@pwd;
  case PasswordUsage of
    pu_None    : pwd[0]:=#0;
    pu_Default : p:=nil;
    pu_Defined : StrPCopy(@pwd,Password);
  end { case };
  u:=@username;
  case UserUsage of
    pu_None    : username[0]:=#0;
    pu_Default : u:=nil;
    pu_Defined : StrPCopy(@username,User);
  end { case };
  Result:=WNetAddConnection2(NetResource,p,u,CONNECT_UPDATE_PROFILE)=NO_ERROR;
end;

function UnmapDrive(Drive : char; Force : boolean) : boolean;
begin
  DriveName[0]:=Drive;
  Result:=WNetCancelConnection2(@DriveName,CONNECT_UPDATE_PROFILE,Force)=NO_ERROR;
end;


function IsWindowsVista: Boolean;
var
  VerInfo: TOSVersioninfo;
begin
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(VerInfo);
  Result := VerInfo.dwMajorVersion >= 6;
end;

procedure SetVistaFonts(const AForm: TForm { TCustomForm });

var
    sFont : String;

begin
  sFont := AForm.Font.Name;

  if IsWindowsVista
    and (lstrcmpi(PChar (sFont), PChar (VistaFont)) <> 0)
    and (Screen.Fonts.IndexOf(VistaFont) >= 0) then
  begin
    AForm.Font.Size := AForm.Font.Size + 1;
    AForm.Font.Name := VistaFont;
  end;
end;

procedure SetVistaContentFonts(const AFont: TFont);

var
    sFont : String;

begin
  sFont := AFont.Name;

  if (IsWindowsVista)
    and (lstrcmpi(PChar (sFont), PChar (VistaContentFont)) <> 0)
    and (Screen.Fonts.IndexOf(VistaContentFont) >= 0) then
  begin
    AFont.Size := AFont.Size + 1;
    AFont.Name := VistaContentFont;
  end;
  //GetVersionInfo
  //GetProductType
end;

procedure GetVersionInfo2 (var OSVersionInfoEx: TOSVersionInfoEx);

var
    pOSVersionInfo : Windows.POSVersionInfo;

begin
    OSVersionInfoEx.dwOSVersionInfoSize := SizeOf (TOSVersionInfoEx);

    pOSVersionInfo := Pointer (@OSVersionInfoEx);

    GetVersionEx (pOSVersionInfo^);
end;

type
    TGetProductInfo = function (dwOSMajorVersion, dwOSMinorVersion,
                                dwSpMajorVersion, dwSpMinorVersion: DWord;
                                var dwReturnedProductType: DWord) : Bool; stdcall;



function GetProductInfo (var dwReturnedProductType: DWord) : Boolean;

(*type
    TGetProductInfo = function (dwOSMajorVersion, dwOSMinorVersion,
                                dwSpMajorVersion, dwSpMinorVersion: DWord;
                                var dwReturnedProductType: DWord) : Bool;
        stdcall;*)

var
    _GetProductInfo : TGetProductInfo;
    OSVersionInfoEx : TOSVersionInfoEx;
    VerInfo : TOSVersioninfo;

begin
    Result := false;

    _GetProductInfo:= GetProcAddress(GetModuleHandle('kernel32'),'GetProductInfo');

    if not (Assigned (_GetProductInfo)) then Exit;

    VerInfo.dwOSVersionInfoSize := SizeOf (TOSVersionInfo);
    GetVersionEx (VerInfo);

    FillChar (OSVersionInfoEx, SizeOf (TOSVersionInfoEx), #0);
    GetVersionInfo2(OSVersionInfoEx);

    Result:= _GetProductInfo (VerInfo.dwMajorVersion,
                               VerInfo.dwMinorVersion,
                               OSVersionInfoEx.wServicePackMajor,
                               OSVersionInfoEx.wServicePackMinor,
                               dwReturnedProductType);
end;

function GetProductType (var sType: String) : Boolean;

var
    dwProductType : DWord;

begin
    Result := false;

    if not (GetProductInfo (dwProductType)) then
        exit;

    Result := true;

    case dwProductType of
      PRODUCT_UNDEFINED : sType := 'PRODUCT_UNDEFINED';
      PRODUCT_ULTIMATE : sType := 'PRODUCT_ULTIMATE';
      PRODUCT_HOME_BASIC : sType := 'PRODUCT_HOME_BASIC';
      PRODUCT_HOME_PREMIUM : sType := 'PRODUCT_HOME_PREMIUM';
      PRODUCT_ENTERPRISE : sType := 'PRODUCT_ENTERPRISE';
      PRODUCT_HOME_BASIC_N : sType := 'PRODUCT_HOME_BASIC_N';
      PRODUCT_BUSINESS : sType := 'PRODUCT_BUSINESS';
      PRODUCT_STANDARD_SERVER : sType := 'PRODUCT_STANDARD_SERVER';
      PRODUCT_DATACENTER_SERVER : sType := 'PRODUCT_DATACENTER_SERVER';
      PRODUCT_SMALLBUSINESS_SERVER : sType := 'PRODUCT_SMALLBUSINESS_SERVER';
      PRODUCT_ENTERPRISE_SERVER : sType := 'PRODUCT_ENTERPRISE_SERVER';
      PRODUCT_STARTER : sType := 'PRODUCT_STARTER';
      PRODUCT_DATACENTER_SERVER_CORE : sType := 'PRODUCT_DATACENTER_SERVER_CORE';
      PRODUCT_STANDARD_SERVER_CORE : sType := 'PRODUCT_STANDARD_SERVER_CORE';
      PRODUCT_ENTERPRISE_SERVER_CORE : sType := 'PRODUCT_ENTERPRISE_SERVER_CORE';
      PRODUCT_ENTERPRISE_SERVER_IA64 : sType := 'PRODUCT_ENTERPRISE_SERVER_IA64';
      PRODUCT_BUSINESS_N : sType := 'PRODUCT_BUSINESS_N';
      PRODUCT_WEB_SERVER : sType := 'PRODUCT_WEB_SERVER';
      PRODUCT_CLUSTER_SERVER : sType := 'PRODUCT_CLUSTER_SERVER';
      PRODUCT_HOME_SERVER : sType := 'PRODUCT_HOME_SERVER';
      PRODUCT_STORAGE_EXPRESS_SERVER : sType := 'PRODUCT_STORAGE_EXPRESS_SERVER';
      PRODUCT_STORAGE_STANDARD_SERVER : sType := 'PRODUCT_STORAGE_STANDARD_SERVER';
      PRODUCT_STORAGE_WORKGROUP_SERVER : sType := 'PRODUCT_STORAGE_WORKGROUP_SERVER';
      PRODUCT_STORAGE_ENTERPRISE_SERVER : sType := 'PRODUCT_STORAGE_ENTERPRISE_SERVER';
      PRODUCT_SERVER_FOR_SMALLBUSINESS : sType := 'PRODUCT_SERVER_FOR_SMALLBUSINESS';
 PRODUCT_SMALLBUSINESS_SERVER_PREMIUM : sType:= 'PRODUCT_SMALLBUSINESS_SERVER_PREMIUM';
      PRODUCT_UNLICENSED : sType := 'PRODUCT_UNLICENSED';
      else sType := 'ProductType unknown';
    end;
end;

end.
