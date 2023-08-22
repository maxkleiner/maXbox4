
{*******************************************************}
{                                                       }
{       Borland Delphi Run-time Library                 }
{       Win32 Shell API Interface Unit                  }
{                                                       }
{       Copyright (c) 1985-1999, Microsoft Corporation  }
{                                                       }
{       Translator: Borland Software Corporation        }
{                                                       }
{*******************************************************}

unit ShellAPI;

{$WEAKPACKAGEUNIT}

interface

uses Windows;

(*$HPPEMIT '#include <shellapi.h>'*)


type
  {$EXTERNALSYM HDROP}
  HDROP = Longint;
  PPWideChar = ^PWideChar;

{$EXTERNALSYM DragQueryFile}
function DragQueryFile(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT): UINT; stdcall;
{$EXTERNALSYM DragQueryFileA}
function DragQueryFileA(Drop: HDROP; FileIndex: UINT; FileName: PAnsiChar; cb: UINT): UINT; stdcall;
{$EXTERNALSYM DragQueryFileW}
function DragQueryFileW(Drop: HDROP; FileIndex: UINT; FileName: PWideChar; cb: UINT): UINT; stdcall;
{$EXTERNALSYM DragQueryPoint}
function DragQueryPoint(Drop: HDROP; var Point: TPoint): BOOL; stdcall;
{$EXTERNALSYM DragFinish}
procedure DragFinish(Drop: HDROP); stdcall;
{$EXTERNALSYM DragAcceptFiles}
procedure DragAcceptFiles(Wnd: HWND; Accept: BOOL); stdcall;
{$EXTERNALSYM ShellExecute}
function ShellExecute(hWnd: HWND; Operation, FileName, Parameters,
  Directory: PChar; ShowCmd: Integer): HINST; stdcall;
{$EXTERNALSYM ShellExecuteA}
function ShellExecuteA(hWnd: HWND; Operation, FileName, Parameters,
  Directory: PAnsiChar; ShowCmd: Integer): HINST; stdcall;
{$EXTERNALSYM ShellExecuteW}
function ShellExecuteW(hWnd: HWND; Operation, FileName, Parameters,
  Directory: PWideChar; ShowCmd: Integer): HINST; stdcall;
{$EXTERNALSYM FindExecutable}
function FindExecutable(FileName, Directory: PChar; Result: PChar): HINST; stdcall;
{$EXTERNALSYM FindExecutableA}
function FindExecutableA(FileName, Directory: PAnsiChar; Result: PAnsiChar): HINST; stdcall;
{$EXTERNALSYM FindExecutableW}
function FindExecutableW(FileName, Directory: PWideChar; Result: PWideChar): HINST; stdcall;
{$EXTERNALSYM CommandLineToArgvW}
function CommandLineToArgvW(lpCmdLine: LPCWSTR; var pNumArgs: Integer): PPWideChar; stdcall;
{$EXTERNALSYM ShellAbout}
function ShellAbout(Wnd: HWND; szApp, szOtherStuff: PChar; Icon: HICON): Integer; stdcall;
{$EXTERNALSYM ShellAboutA}
function ShellAboutA(Wnd: HWND; szApp, szOtherStuff: PAnsiChar; Icon: HICON): Integer; stdcall;
{$EXTERNALSYM ShellAboutW}
function ShellAboutW(Wnd: HWND; szApp, szOtherStuff: PWideChar; Icon: HICON): Integer; stdcall;
{$EXTERNALSYM DuplicateIcon}
function DuplicateIcon(hInst: HINST; Icon: HICON): HICON; stdcall;
{$EXTERNALSYM ExtractAssociatedIcon}
function ExtractAssociatedIcon(hInst: HINST; lpIconPath: PChar;
  var lpiIcon: Word): HICON; stdcall;
{$EXTERNALSYM ExtractAssociatedIconA}
function ExtractAssociatedIconA(hInst: HINST; lpIconPath: PAnsiChar;
  var lpiIcon: Word): HICON; stdcall;
{$EXTERNALSYM ExtractAssociatedIconW}
function ExtractAssociatedIconW(hInst: HINST; lpIconPath: PWideChar;
  var lpiIcon: Word): HICON; stdcall;
{$EXTERNALSYM ExtractIcon}
function ExtractIcon(hInst: HINST; lpszExeFileName: PChar;
  nIconIndex: UINT): HICON; stdcall;
{$EXTERNALSYM ExtractIconA}
function ExtractIconA(hInst: HINST; lpszExeFileName: PAnsiChar;
  nIconIndex: UINT): HICON; stdcall;
{$EXTERNALSYM ExtractIconW}
function ExtractIconW(hInst: HINST; lpszExeFileName: PWideChar;
  nIconIndex: UINT): HICON; stdcall;

type
  PDragInfoA = ^_DRAGINFOA;
  PDragInfoW = ^_DRAGINFOW;
  PDragInfo = PDragInfoA;
  _DRAGINFOA = record
    uSize: UINT;                 { init with SizeOf(DRAGINFO) }
    pt: TPoint;
    fNC: BOOL;
    lpFileList: PAnsiChar;
    grfKeyState: DWORD;
  end;
  TDragInfoA = _DRAGINFOA;
  LPDRAGINFOA = PDragInfoA;
  _DRAGINFOW = record
    uSize: UINT;                 { init with SizeOf(DRAGINFO) }
    pt: TPoint;
    fNC: BOOL;
    lpFileList: PWideChar;
    grfKeyState: DWORD;
  end;
  TDragInfoW = _DRAGINFOW;
  LPDRAGINFOW = PDragInfoW;
  _DRAGINFO = _DRAGINFOA;

const
{ AppBar stuff }

  {$EXTERNALSYM ABM_NEW}
  ABM_NEW           = $00000000;
  {$EXTERNALSYM ABM_REMOVE}
  ABM_REMOVE        = $00000001;
  {$EXTERNALSYM ABM_QUERYPOS}
  ABM_QUERYPOS      = $00000002;
  {$EXTERNALSYM ABM_SETPOS}
  ABM_SETPOS        = $00000003;
  {$EXTERNALSYM ABM_GETSTATE}
  ABM_GETSTATE      = $00000004;
  {$EXTERNALSYM ABM_GETTASKBARPOS}
  ABM_GETTASKBARPOS = $00000005;
  {$EXTERNALSYM ABM_ACTIVATE}
  ABM_ACTIVATE      = $00000006;  { lParam = True/False means activate/deactivate }
  {$EXTERNALSYM ABM_GETAUTOHIDEBAR}
  ABM_GETAUTOHIDEBAR = $00000007;
  {$EXTERNALSYM ABM_SETAUTOHIDEBAR}
  ABM_SETAUTOHIDEBAR = $00000008;  { this can fail at any time.  MUST check the result
                                     lParam = TRUE/FALSE  Set/Unset
                                     uEdge = what edge }
  {$EXTERNALSYM ABM_WINDOWPOSCHANGED}
  ABM_WINDOWPOSCHANGED = $0000009;

{ these are put in the wparam of callback messages }

  {$EXTERNALSYM ABN_STATECHANGE}
  ABN_STATECHANGE    = $0000000;
  {$EXTERNALSYM ABN_POSCHANGED}
  ABN_POSCHANGED     = $0000001;
  {$EXTERNALSYM ABN_FULLSCREENAPP}
  ABN_FULLSCREENAPP  = $0000002;
  {$EXTERNALSYM ABN_WINDOWARRANGE}
  ABN_WINDOWARRANGE  = $0000003; { lParam = True means hide }

{ flags for get state }

  {$EXTERNALSYM ABS_AUTOHIDE}
  ABS_AUTOHIDE    = $0000001;
  {$EXTERNALSYM ABS_ALWAYSONTOP}
  ABS_ALWAYSONTOP = $0000002;

  {$EXTERNALSYM ABE_LEFT}
  ABE_LEFT        = 0;
  {$EXTERNALSYM ABE_TOP}
  ABE_TOP         = 1;
  {$EXTERNALSYM ABE_RIGHT}
  ABE_RIGHT       = 2;
  {$EXTERNALSYM ABE_BOTTOM}
  ABE_BOTTOM      = 3;

type
  PAppBarData = ^TAppBarData;
  {$EXTERNALSYM _AppBarData}
  _AppBarData = record
    cbSize: DWORD;
    hWnd: HWND;
    uCallbackMessage: UINT;
    uEdge: UINT;
    rc: TRect;
    lParam: LPARAM; { message specific }
  end;
  TAppBarData = _AppBarData;
  {$EXTERNALSYM APPBARDATA}
  APPBARDATA = _AppBarData;

{$EXTERNALSYM SHAppBarMessage}
function SHAppBarMessage(dwMessage: DWORD; var pData: TAppBarData): UINT; stdcall;


{$EXTERNALSYM DoEnvironmentSubst}
function DoEnvironmentSubst(szString: PChar; cbString: UINT): DWORD; stdcall;
{$EXTERNALSYM DoEnvironmentSubstA}
function DoEnvironmentSubstA(szString: PAnsiChar; cbString: UINT): DWORD; stdcall;
{$EXTERNALSYM DoEnvironmentSubstW}
function DoEnvironmentSubstW(szString: PWideChar; cbString: UINT): DWORD; stdcall;
{$EXTERNALSYM ExtractIconEx}
function ExtractIconEx(lpszFile: PChar; nIconIndex: Integer;
  var phiconLarge, phiconSmall: HICON; nIcons: UINT): UINT; stdcall;
{$EXTERNALSYM ExtractIconExA}
function ExtractIconExA(lpszFile: PAnsiChar; nIconIndex: Integer;
  var phiconLarge, phiconSmall: HICON; nIcons: UINT): UINT; stdcall;
{$EXTERNALSYM ExtractIconExW}
function ExtractIconExW(lpszFile: PWideChar; nIconIndex: Integer;
  var phiconLarge, phiconSmall: HICON; nIcons: UINT): UINT; stdcall;


{ Shell File Operations }

const
  {$EXTERNALSYM FO_MOVE}
  FO_MOVE           = $0001;
  {$EXTERNALSYM FO_COPY}
  FO_COPY           = $0002;
  {$EXTERNALSYM FO_DELETE}
  FO_DELETE         = $0003;
  {$EXTERNALSYM FO_RENAME}
  FO_RENAME         = $0004;

  {$EXTERNALSYM FOF_MULTIDESTFILES}
  FOF_MULTIDESTFILES         = $0001;
  {$EXTERNALSYM FOF_CONFIRMMOUSE}
  FOF_CONFIRMMOUSE           = $0002;
  {$EXTERNALSYM FOF_SILENT}
  FOF_SILENT                 = $0004;  { don't create progress/report }
  {$EXTERNALSYM FOF_RENAMEONCOLLISION}
  FOF_RENAMEONCOLLISION      = $0008;
  {$EXTERNALSYM FOF_NOCONFIRMATION}
  FOF_NOCONFIRMATION         = $0010;  { Don't prompt the user. }
  {$EXTERNALSYM FOF_WANTMAPPINGHANDLE}
  FOF_WANTMAPPINGHANDLE      = $0020;  { Fill in SHFILEOPSTRUCT.hNameMappings
                                         Must be freed using SHFreeNameMappings }
  {$EXTERNALSYM FOF_ALLOWUNDO}
  FOF_ALLOWUNDO              = $0040;
  {$EXTERNALSYM FOF_FILESONLY}
  FOF_FILESONLY              = $0080;  { on *.*, do only files }
  {$EXTERNALSYM FOF_SIMPLEPROGRESS}
  FOF_SIMPLEPROGRESS         = $0100;  { means don't show names of files }
  {$EXTERNALSYM FOF_NOCONFIRMMKDIR}
  FOF_NOCONFIRMMKDIR         = $0200;  { don't confirm making any needed dirs }
  {$EXTERNALSYM FOF_NOERRORUI}
  FOF_NOERRORUI              = $0400;  { don't put up error UI }

type
  {$EXTERNALSYM FILEOP_FLAGS}
  FILEOP_FLAGS = Word;

const
  {$EXTERNALSYM PO_DELETE}
  PO_DELETE       = $0013;  { printer is being deleted }
  {$EXTERNALSYM PO_RENAME}
  PO_RENAME       = $0014;  { printer is being renamed }
  {$EXTERNALSYM PO_PORTCHANGE}
  PO_PORTCHANGE   = $0020;  { port this printer connected to is being changed
                              if this id is set, the strings received by
                              the copyhook are a doubly-null terminated
                              list of strings.  The first is the printer
                              name and the second is the printer port. }
  {$EXTERNALSYM PO_REN_PORT}
  PO_REN_PORT     = $0034;  { PO_RENAME and PO_PORTCHANGE at same time. }

{ no POF_ flags currently defined }

type
  {$EXTERNALSYM PRINTEROP_FLAGS}
  PRINTEROP_FLAGS = Word;

{ implicit parameters are:
      if pFrom or pTo are unqualified names the current directories are
      taken from the global current drive/directory settings managed
      by Get/SetCurrentDrive/Directory

      the global confirmation settings }

  PSHFileOpStructA = ^TSHFileOpStructA;
  PSHFileOpStructW = ^TSHFileOpStructW;
  PSHFileOpStruct = PSHFileOpStructA;
  {$EXTERNALSYM _SHFILEOPSTRUCTA}
  _SHFILEOPSTRUCTA = packed record
    Wnd: HWND;
    wFunc: UINT;
    pFrom: PAnsiChar;
    pTo: PAnsiChar;
    fFlags: FILEOP_FLAGS;
    fAnyOperationsAborted: BOOL;
    hNameMappings: Pointer;
    lpszProgressTitle: PAnsiChar; { only used if FOF_SIMPLEPROGRESS }
  end;
  {$EXTERNALSYM _SHFILEOPSTRUCTW}
  _SHFILEOPSTRUCTW = packed record
    Wnd: HWND;
    wFunc: UINT;
    pFrom: PWideChar;
    pTo: PWideChar;
    fFlags: FILEOP_FLAGS;
    fAnyOperationsAborted: BOOL;
    hNameMappings: Pointer;
    lpszProgressTitle: PWideChar; { only used if FOF_SIMPLEPROGRESS }
  end;
  {$EXTERNALSYM _SHFILEOPSTRUCT}
  _SHFILEOPSTRUCT = _SHFILEOPSTRUCTA;
  TSHFileOpStructA = _SHFILEOPSTRUCTA;
  TSHFileOpStructW = _SHFILEOPSTRUCTW;
  TSHFileOpStruct = TSHFileOpStructA;
  {$EXTERNALSYM SHFILEOPSTRUCTA}
  SHFILEOPSTRUCTA = _SHFILEOPSTRUCTA;
  {$EXTERNALSYM SHFILEOPSTRUCTW}
  SHFILEOPSTRUCTW = _SHFILEOPSTRUCTW;
  {$EXTERNALSYM SHFILEOPSTRUCT}
  SHFILEOPSTRUCT = SHFILEOPSTRUCTA;

{$EXTERNALSYM SHFileOperation}
function SHFileOperation(const lpFileOp: TSHFileOpStruct): Integer; stdcall;
{$EXTERNALSYM SHFileOperationA}
function SHFileOperationA(const lpFileOp: TSHFileOpStructA): Integer; stdcall;
{$EXTERNALSYM SHFileOperationW}
function SHFileOperationW(const lpFileOp: TSHFileOpStructW): Integer; stdcall;
{$EXTERNALSYM SHFreeNameMappings}
procedure SHFreeNameMappings(hNameMappings: THandle); stdcall;

type
  PSHNameMappingA = ^TSHNameMappingA;
  PSHNameMappingW = ^TSHNameMappingW;
  PSHNameMapping = PSHNameMappingA;
  {$EXTERNALSYM _SHNAMEMAPPINGA}
  _SHNAMEMAPPINGA = record
    pszOldPath: PAnsiChar;
    pszNewPath: PAnsiChar;
    cchOldPath: Integer;
    cchNewPath: Integer;
  end;
  {$EXTERNALSYM _SHNAMEMAPPINGW}
  _SHNAMEMAPPINGW = record
    pszOldPath: PWideChar;
    pszNewPath: PWideChar;
    cchOldPath: Integer;
    cchNewPath: Integer;
  end;
  {$EXTERNALSYM _SHNAMEMAPPING}
  _SHNAMEMAPPING = _SHNAMEMAPPINGA;
  TSHNameMappingA = _SHNAMEMAPPINGA;
  TSHNameMappingW = _SHNAMEMAPPINGW;
  TSHNameMapping = TSHNameMappingA;
  {$EXTERNALSYM SHNAMEMAPPINGA}
  SHNAMEMAPPINGA = _SHNAMEMAPPINGA;
  {$EXTERNALSYM SHNAMEMAPPINGW}
  SHNAMEMAPPINGW = _SHNAMEMAPPINGW;
  {$EXTERNALSYM SHNAMEMAPPING}
  SHNAMEMAPPING = SHNAMEMAPPINGA;


{ ShellExecute() and ShellExecuteEx() error codes }
const
{ regular WinExec() codes }
  {$EXTERNALSYM SE_ERR_FNF}
  SE_ERR_FNF              = 2;       { file not found }
  {$EXTERNALSYM SE_ERR_PNF}
  SE_ERR_PNF              = 3;       { path not found }
  {$EXTERNALSYM SE_ERR_ACCESSDENIED}
  SE_ERR_ACCESSDENIED     = 5;       { access denied }
  {$EXTERNALSYM SE_ERR_OOM}
  SE_ERR_OOM              = 8;       { out of memory }
  {$EXTERNALSYM SE_ERR_DLLNOTFOUND}
  SE_ERR_DLLNOTFOUND      = 32;

{ error values for ShellExecute() beyond the regular WinExec() codes }
  {$EXTERNALSYM SE_ERR_SHARE}
  SE_ERR_SHARE                    = 26;
  {$EXTERNALSYM SE_ERR_ASSOCINCOMPLETE}
  SE_ERR_ASSOCINCOMPLETE          = 27;
  {$EXTERNALSYM SE_ERR_DDETIMEOUT}
  SE_ERR_DDETIMEOUT               = 28;
  {$EXTERNALSYM SE_ERR_DDEFAIL}
  SE_ERR_DDEFAIL                  = 29;
  {$EXTERNALSYM SE_ERR_DDEBUSY}
  SE_ERR_DDEBUSY                  = 30;
  {$EXTERNALSYM SE_ERR_NOASSOC}
  SE_ERR_NOASSOC                  = 31;

{ Note CLASSKEY overrides CLASSNAME }
  {$EXTERNALSYM SEE_MASK_CLASSNAME}
  SEE_MASK_CLASSNAME      = $00000001;
  {$EXTERNALSYM SEE_MASK_CLASSKEY}
  SEE_MASK_CLASSKEY       = $00000003;
{ Note INVOKEIDLIST overrides IDLIST }
  {$EXTERNALSYM SEE_MASK_IDLIST}
  SEE_MASK_IDLIST         = $00000004;
  {$EXTERNALSYM SEE_MASK_INVOKEIDLIST}
  SEE_MASK_INVOKEIDLIST   = $0000000c;
  {$EXTERNALSYM SEE_MASK_ICON}
  SEE_MASK_ICON           = $00000010;
  {$EXTERNALSYM SEE_MASK_HOTKEY}
  SEE_MASK_HOTKEY         = $00000020;
  {$EXTERNALSYM SEE_MASK_NOCLOSEPROCESS}
  SEE_MASK_NOCLOSEPROCESS = $00000040;
  {$EXTERNALSYM SEE_MASK_CONNECTNETDRV}
  SEE_MASK_CONNECTNETDRV  = $00000080;
  {$EXTERNALSYM SEE_MASK_FLAG_DDEWAIT}
  SEE_MASK_FLAG_DDEWAIT   = $00000100;
  {$EXTERNALSYM SEE_MASK_DOENVSUBST}
  SEE_MASK_DOENVSUBST     = $00000200;
  {$EXTERNALSYM SEE_MASK_FLAG_NO_UI}
  SEE_MASK_FLAG_NO_UI     = $00000400;
  {$EXTERNALSYM SEE_MASK_UNICODE}
  SEE_MASK_UNICODE        = $00010000; // !!! changed from previous SDK (was $00004000)
  {$EXTERNALSYM SEE_MASK_NO_CONSOLE}
  SEE_MASK_NO_CONSOLE     = $00008000;
  {$EXTERNALSYM SEE_MASK_ASYNCOK}
  SEE_MASK_ASYNCOK        = $00100000;

type
  PShellExecuteInfoA = ^TShellExecuteInfoA;
  PShellExecuteInfoW = ^TShellExecuteInfoW;
  PShellExecuteInfo = PShellExecuteInfoA;
  {$EXTERNALSYM _SHELLEXECUTEINFOA}
  _SHELLEXECUTEINFOA = record
    cbSize: DWORD;
    fMask: ULONG;
    Wnd: HWND;
    lpVerb: PAnsiChar;
    lpFile: PAnsiChar;
    lpParameters: PAnsiChar;
    lpDirectory: PAnsiChar;
    nShow: Integer;
    hInstApp: HINST;
    { Optional fields }
    lpIDList: Pointer;
    lpClass: PAnsiChar;
    hkeyClass: HKEY;
    dwHotKey: DWORD;
    hIcon: THandle;
    hProcess: THandle;
  end;
  {$EXTERNALSYM _SHELLEXECUTEINFOW}
  _SHELLEXECUTEINFOW = record
    cbSize: DWORD;
    fMask: ULONG;
    Wnd: HWND;
    lpVerb: PWideChar;
    lpFile: PWideChar;
    lpParameters: PWideChar;
    lpDirectory: PWideChar;
    nShow: Integer;
    hInstApp: HINST;
    { Optional fields }
    lpIDList: Pointer;
    lpClass: PWideChar;
    hkeyClass: HKEY;
    dwHotKey: DWORD;
    hIcon: THandle;
    hProcess: THandle;
  end;
  {$EXTERNALSYM _SHELLEXECUTEINFO}
  _SHELLEXECUTEINFO = _SHELLEXECUTEINFOA;
  TShellExecuteInfoA = _SHELLEXECUTEINFOA;
  TShellExecuteInfoW = _SHELLEXECUTEINFOW;
  TShellExecuteInfo = TShellExecuteInfoA;
  {$EXTERNALSYM SHELLEXECUTEINFOA}
  SHELLEXECUTEINFOA = _SHELLEXECUTEINFOA;
  {$EXTERNALSYM SHELLEXECUTEINFOW}
  SHELLEXECUTEINFOW = _SHELLEXECUTEINFOW;
  {$EXTERNALSYM SHELLEXECUTEINFO}
  SHELLEXECUTEINFO = SHELLEXECUTEINFOA;

{$EXTERNALSYM ShellExecuteEx}
function ShellExecuteEx(lpExecInfo: PShellExecuteInfo):BOOL; stdcall;
{$EXTERNALSYM ShellExecuteExA}
function ShellExecuteExA(lpExecInfo: PShellExecuteInfoA):BOOL; stdcall;
{$EXTERNALSYM ShellExecuteExW}
function ShellExecuteExW(lpExecInfo: PShellExecuteInfoW):BOOL; stdcall;

{ Tray notification definitions }

type
  PNotifyIconDataA = ^TNotifyIconDataA;
  PNotifyIconDataW = ^TNotifyIconDataW;
  PNotifyIconData = PNotifyIconDataA;
  _NOTIFYICONDATAA = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..127] of AnsiChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array [0..255] of AnsiChar;
    uTimeout: UINT;
    szInfoTitle: array [0..63] of AnsiChar;
    dwInfoFlags: DWORD;
  end;
  _NOTIFYICONDATAW = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..127] of WideChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array [0..255] of WideChar;
    uTimeout: UINT;
    szInfoTitle: array [0..63] of WideChar;
    dwInfoFlags: DWORD;
  end;
  _NOTIFYICONDATA = _NOTIFYICONDATAA;
  TNotifyIconDataA = _NOTIFYICONDATAA;
  TNotifyIconDataW = _NOTIFYICONDATAW;
  TNotifyIconData = TNotifyIconDataA;
  {$EXTERNALSYM NOTIFYICONDATAA}
  NOTIFYICONDATAA = _NOTIFYICONDATAA;
  {$EXTERNALSYM NOTIFYICONDATAW}
  NOTIFYICONDATAW = _NOTIFYICONDATAW;
  {$EXTERNALSYM NOTIFYICONDATA}
  NOTIFYICONDATA = NOTIFYICONDATAA;

const
  {$EXTERNALSYM NIM_ADD}
  NIM_ADD         = $00000000;
  {$EXTERNALSYM NIM_MODIFY}
  NIM_MODIFY      = $00000001;
  {$EXTERNALSYM NIM_DELETE}
  NIM_DELETE      = $00000002;
  {$EXTERNALSYM NIM_SETFOCUS}
  NIM_SETFOCUS    = $00000003;
  {$EXTERNALSYM NIM_SETVERSION}
  NIM_SETVERSION  = $00000004;

  {$EXTERNALSYM NIF_MESSAGE}
  NIF_MESSAGE     = $00000001;
  {$EXTERNALSYM NIF_ICON}
  NIF_ICON        = $00000002;
  {$EXTERNALSYM NIF_TIP}
  NIF_TIP         = $00000004;
  {$EXTERNALSYM NIF_STATE}
  NIF_STATE       = $00000008;
  {$EXTERNALSYM NIF_INFO}
  NIF_INFO        = $00000010;

  {$EXTERNALSYM NIIF_NONE}
  NIIF_NONE       = $00000000;
  {$EXTERNALSYM NIIF_INFO}
  NIIF_INFO       = $00000001;
  {$EXTERNALSYM NIIF_WARNING}
  NIIF_WARNING    = $00000002;
  {$EXTERNALSYM NIIF_ERROR}
  NIIF_ERROR      = $00000003;
  {$EXTERNALSYM NIIF_ICON_MASK}
  NIIF_ICON_MASK  = $0000000F;

  {$EXTERNALSYM NIN_SELECT}
  NIN_SELECT      = $0400;
  {$EXTERNALSYM NINF_KEY}
  NINF_KEY        =  $1;
  {$EXTERNALSYM NIN_KEYSELECT}
  NIN_KEYSELECT   = NIN_SELECT or NINF_KEY;

  {$EXTERNALSYM NIN_BALLOONSHOW}
  NIN_BALLOONSHOW       = $0400 + 2;
  {$EXTERNALSYM NIN_BALLOONHIDE}
  NIN_BALLOONHIDE       = $0400 + 3;
  {$EXTERNALSYM NIN_BALLOONTIMEOUT}
  NIN_BALLOONTIMEOUT    = $0400 + 4;
  {$EXTERNALSYM NIN_BALLOONUSERCLICK}
  NIN_BALLOONUSERCLICK  = $0400 + 5;

{$EXTERNALSYM Shell_NotifyIcon}
function Shell_NotifyIcon(dwMessage: DWORD; lpData: PNotifyIconData): BOOL; stdcall;
{$EXTERNALSYM Shell_NotifyIconA}
function Shell_NotifyIconA(dwMessage: DWORD; lpData: PNotifyIconDataA): BOOL; stdcall;
{$EXTERNALSYM Shell_NotifyIconW}
function Shell_NotifyIconW(dwMessage: DWORD; lpData: PNotifyIconDataW): BOOL; stdcall;

{ Begin SHGetFileInfo }

(*
 * The SHGetFileInfo API provides an easy way to get attributes
 * for a file given a pathname.
 *
 *   PARAMETERS
 *
 *     pszPath              file name to get info about
 *     dwFileAttributes     file attribs, only used with SHGFI_USEFILEATTRIBUTES
 *     psfi                 place to return file info
 *     cbFileInfo           size of structure
 *     uFlags               flags
 *
 *   RETURN
 *     TRUE if things worked
 *)

type
  PSHFileInfoA = ^TSHFileInfoA;
  PSHFileInfoW = ^TSHFileInfoW;
  PSHFileInfo = PSHFileInfoA;
  {$EXTERNALSYM _SHFILEINFOA}
  _SHFILEINFOA = record
    hIcon: HICON;                      { out: icon }
    iIcon: Integer;                    { out: icon index }
    dwAttributes: DWORD;               { out: SFGAO_ flags }
    szDisplayName: array [0..MAX_PATH-1] of  AnsiChar; { out: display name (or path) }
    szTypeName: array [0..79] of AnsiChar;             { out: type name }
  end;
  {$EXTERNALSYM _SHFILEINFOW}
  _SHFILEINFOW = record
    hIcon: HICON;                      { out: icon }
    iIcon: Integer;                    { out: icon index }
    dwAttributes: DWORD;               { out: SFGAO_ flags }
    szDisplayName: array [0..MAX_PATH-1] of  WideChar; { out: display name (or path) }
    szTypeName: array [0..79] of WideChar;             { out: type name }
  end;
  {$EXTERNALSYM _SHFILEINFO}
  _SHFILEINFO = _SHFILEINFOA;
  TSHFileInfoA = _SHFILEINFOA;
  TSHFileInfoW = _SHFILEINFOW;
  TSHFileInfo = TSHFileInfoA;
  {$EXTERNALSYM SHFILEINFOA}
  SHFILEINFOA = _SHFILEINFOA;
  {$EXTERNALSYM SHFILEINFOW}
  SHFILEINFOW = _SHFILEINFOW;
  {$EXTERNALSYM SHFILEINFO}
  SHFILEINFO = SHFILEINFOA;

const
  {$EXTERNALSYM SHGFI_ICON}
  SHGFI_ICON              = $000000100;     { get icon }
  {$EXTERNALSYM SHGFI_DISPLAYNAME}
  SHGFI_DISPLAYNAME       = $000000200;     { get display name }
  {$EXTERNALSYM SHGFI_TYPENAME}
  SHGFI_TYPENAME          = $000000400;     { get type name }
  {$EXTERNALSYM SHGFI_ATTRIBUTES}
  SHGFI_ATTRIBUTES        = $000000800;     { get attributes }
  {$EXTERNALSYM SHGFI_ICONLOCATION}
  SHGFI_ICONLOCATION      = $000001000;     { get icon location }
  {$EXTERNALSYM SHGFI_EXETYPE}
  SHGFI_EXETYPE           = $000002000;     { return exe type }
  {$EXTERNALSYM SHGFI_SYSICONINDEX}
  SHGFI_SYSICONINDEX      = $000004000;     { get system icon index }
  {$EXTERNALSYM SHGFI_LINKOVERLAY}
  SHGFI_LINKOVERLAY       = $000008000;     { put a link overlay on icon }
  {$EXTERNALSYM SHGFI_SELECTED}
  SHGFI_SELECTED          = $000010000;     { show icon in selected state }
  {$EXTERNALSYM SHGFI_LARGEICON}
  SHGFI_LARGEICON         = $000000000;     { get large icon }
  {$EXTERNALSYM SHGFI_SMALLICON}
  SHGFI_SMALLICON         = $000000001;     { get small icon }
  {$EXTERNALSYM SHGFI_OPENICON}
  SHGFI_OPENICON          = $000000002;     { get open icon }
  {$EXTERNALSYM SHGFI_SHELLICONSIZE}
  SHGFI_SHELLICONSIZE     = $000000004;     { get shell size icon }
  {$EXTERNALSYM SHGFI_PIDL}
  SHGFI_PIDL              = $000000008;     { pszPath is a pidl }
  {$EXTERNALSYM SHGFI_USEFILEATTRIBUTES}
  SHGFI_USEFILEATTRIBUTES = $000000010;     { use passed dwFileAttribute }

{$EXTERNALSYM SHGetFileInfo}
function SHGetFileInfo(pszPath: PAnsiChar; dwFileAttributes: DWORD;
  var psfi: TSHFileInfo; cbFileInfo, uFlags: UINT): DWORD; stdcall;
{$EXTERNALSYM SHGetFileInfoA}
function SHGetFileInfoA(pszPath: PAnsiChar; dwFileAttributes: DWORD;
  var psfi: TSHFileInfoA; cbFileInfo, uFlags: UINT): DWORD; stdcall;
{$EXTERNALSYM SHGetFileInfoW}
function SHGetFileInfoW(pszPath: PAnsiChar; dwFileAttributes: DWORD;
  var psfi: TSHFileInfoW; cbFileInfo, uFlags: UINT): DWORD; stdcall;

const
  {$EXTERNALSYM SHGNLI_PIDL}
  SHGNLI_PIDL             = $000000001;     { pszLinkTo is a pidl }
  {$EXTERNALSYM SHGNLI_PREFIXNAME}
  SHGNLI_PREFIXNAME       = $000000002;     { Make name "Shortcut to xxx" }
  {$EXTERNALSYM SHGNLI_NOUNIQUE}
  SHGNLI_NOUNIQUE         = $000000004;     { don't do the unique name generation }

{$IFDEF MSWINDOWS}
  shell32 = 'shell32.dll';
{$ENDIF}
{$IFDEF LINUX}
  shell32 = 'libshell32.borland.so';
{$ENDIF}

implementation

function CommandLineToArgvW; external shell32 name 'CommandLineToArgvW';
function DoEnvironmentSubst; external shell32 name 'DoEnvironmentSubstA';
function DoEnvironmentSubstA; external shell32 name 'DoEnvironmentSubstA';
function DoEnvironmentSubstW; external shell32 name 'DoEnvironmentSubstW';
procedure DragAcceptFiles; external shell32 name 'DragAcceptFiles';
procedure DragFinish; external shell32 name 'DragFinish';
function DragQueryFile; external shell32 name 'DragQueryFileA';
function DragQueryFileA; external shell32 name 'DragQueryFileA';
function DragQueryFileW; external shell32 name 'DragQueryFileW';
function DragQueryPoint; external shell32 name 'DragQueryPoint';
function DuplicateIcon; external shell32 name 'DuplicateIcon';
function ExtractAssociatedIcon; external shell32 name 'ExtractAssociatedIconA';
function ExtractAssociatedIconA; external shell32 name 'ExtractAssociatedIconA';
function ExtractAssociatedIconW; external shell32 name 'ExtractAssociatedIconW';
function ExtractIcon; external shell32 name 'ExtractIconA';
function ExtractIconA; external shell32 name 'ExtractIconA';
function ExtractIconW; external shell32 name 'ExtractIconW';
function ExtractIconEx; external shell32 name 'ExtractIconExA';
function ExtractIconExA; external shell32 name 'ExtractIconExA';
function ExtractIconExW; external shell32 name 'ExtractIconExW';
function FindExecutable; external shell32 name 'FindExecutableA';
function FindExecutableA; external shell32 name 'FindExecutableA';
function FindExecutableW; external shell32 name 'FindExecutableW';
function SHAppBarMessage; external shell32 name 'SHAppBarMessage';
function SHFileOperation; external shell32 name 'SHFileOperationA';
function SHFileOperationA; external shell32 name 'SHFileOperationA';
function SHFileOperationW; external shell32 name 'SHFileOperationW';
procedure SHFreeNameMappings; external shell32 name 'SHFreeNameMappings';
function SHGetFileInfo; external shell32 name 'SHGetFileInfoA';
function SHGetFileInfoA; external shell32 name 'SHGetFileInfoA';
function SHGetFileInfoW; external shell32 name 'SHGetFileInfoW';
function ShellAbout; external shell32 name 'ShellAboutA';
function ShellAboutA; external shell32 name 'ShellAboutA';
function ShellAboutW; external shell32 name 'ShellAboutW';
function ShellExecute; external shell32 name 'ShellExecuteA';
function ShellExecuteA; external shell32 name 'ShellExecuteA';
function ShellExecuteW; external shell32 name 'ShellExecuteW';
function ShellExecuteEx; external shell32 name 'ShellExecuteExA';
function ShellExecuteExA; external shell32 name 'ShellExecuteExA';
function ShellExecuteExW; external shell32 name 'ShellExecuteExW';
function Shell_NotifyIcon; external shell32 name 'Shell_NotifyIconA';
function Shell_NotifyIconA; external shell32 name 'Shell_NotifyIconA';
function Shell_NotifyIconW; external shell32 name 'Shell_NotifyIconW';

end.
