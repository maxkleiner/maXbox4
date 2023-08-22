{$I ..\switches.inc}

unit D2_VistaHelperU;

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

    PRODUCT_UNLICENSED                      = DWord ($ABCDABCD);

    { Possible values for the "wSuiteMask" field in "OSVersionInfoEx" }
    VER_SERVER_NT                      = DWORD($80000000);
    VER_WORKSTATION_NT                 = $40000000;
    VER_SUITE_SMALLBUSINESS            = $00000001;
    VER_SUITE_ENTERPRISE               = $00000002;
    VER_SUITE_BACKOFFICE               = $00000004;
    VER_SUITE_COMMUNICATIONS           = $00000008;
    VER_SUITE_TERMINAL                 = $00000010;
    VER_SUITE_SMALLBUSINESS_RESTRICTED = $00000020;
    VER_SUITE_EMBEDDEDNT               = $00000040;
    VER_SUITE_DATACENTER               = $00000080;
    VER_SUITE_SINGLEUSERTS             = $00000100;
    VER_SUITE_PERSONAL                 = $00000200;
    VER_SUITE_BLADE                    = $00000400;

    { Possible values for the "wProductType" field in "OSVersionInfoEx" }
    VER_NT_WORKSTATION       = $0000001;
    VER_NT_DOMAIN_CONTROLLER = $0000002;
    VER_NT_SERVER            = $0000003;

type
    POSVERSIONINFOEXA = ^OSVERSIONINFOEXA;
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
    LPOSVERSIONINFOEXA = ^OSVERSIONINFOEXA;
    TOSVersionInfoExA = _OSVERSIONINFOEXA;
    TOSVersionInfoEx = TOSVersionInfoExA;

function IsWindowsVista: Boolean;
procedure SetVistaFonts(const AForm: TForm { TCustomForm });
procedure SetVistaContentFonts(const AFont: TFont);
function GetProductType (var sType: String) : Boolean;

implementation

uses SysUtils;

const
  VistaFont = 'Segoe UI';
  VistaContentFont = 'Calibri';

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
end;

procedure GetVersionInfo (var OSVersionInfoEx: TOSVersionInfoEx);

var
    pOSVersionInfo : Windows.POSVersionInfo;

begin
    OSVersionInfoEx.dwOSVersionInfoSize := SizeOf (TOSVersionInfoEx);

    pOSVersionInfo := Pointer (@OSVersionInfoEx);

    GetVersionEx (pOSVersionInfo^);
end;

function GetProductInfo (var dwReturnedProductType: DWord) : Boolean;

type
    TGetProductInfo = function (dwOSMajorVersion, dwOSMinorVersion,
                                dwSpMajorVersion, dwSpMinorVersion: DWord;
                                var dwReturnedProductType: DWord) : Bool;
        stdcall;

var
    _GetProductInfo : TGetProductInfo;
    OSVersionInfoEx : TOSVersionInfoEx;
    VerInfo : TOSVersioninfo;

begin
    Result := false;

    _GetProductInfo:= GetProcAddress (GetModuleHandle ('kernel32'),
                                      'GetProductInfo');

    if not (Assigned (_GetProductInfo)) then
        exit;

    VerInfo.dwOSVersionInfoSize := SizeOf (TOSVersionInfo);
    GetVersionEx (VerInfo);

    FillChar (OSVersionInfoEx, SizeOf (TOSVersionInfoEx), #0);
    GetVersionInfo (OSVersionInfoEx);

    Result := _GetProductInfo (VerInfo.dwMajorVersion,
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
      PRODUCT_SMALLBUSINESS_SERVER_PREMIUM : sType := 'PRODUCT_SMALLBUSINESS_SERVER_PREMIUM';
      PRODUCT_UNLICENSED : sType := 'PRODUCT_UNLICENSED';
      else sType := 'ProductType unknown';
    end;
end;

end.
