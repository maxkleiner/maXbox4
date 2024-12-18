{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvWinDialogs.PAS, released on 2002-05-13.

The Initial Developer of the Original Code is Serhiy Perevoznyk.
All Rights Reserved.

Contributor(s):
Michael Beck

Last Modified: 2002-05-15

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}
{$I WINDOWSONLY.INC}

unit JvWinDialogs;

interface

uses
  ShellAPI, Windows, Classes, Forms, SysUtils, Graphics, Dialogs,
  Controls, ShlObj, ComObj, ActiveX, CommDlg,
  JvBaseDlg, JvTypes, JvComponent, JvFunctions_max; // For OSCheck

type
  EShellOleError = class(Exception);
  EWinDialogError = class(Exception);

  TShellLinkInfo = record
    PathName: string;
    Arguments: string;
    Description: string;
    WorkingDirectory: string;
    IconLocation: string;
    IconIndex: Integer;
    ShowCmd: Integer;
    HotKey: Word;
  end;

  TSpecialFolderInfo = record
    Name: string;
    ID: Integer;
  end;

const
  OFN_EX_NOPLACESBAR = 1; // for new style of standard Windows dialogs

  SpecialFolders: array [0..29] of TSpecialFolderInfo = (
    (Name: 'Alt Startup'; ID: CSIDL_ALTSTARTUP),
    (Name: 'Application Data'; ID: CSIDL_APPDATA),
    (Name: 'Recycle Bin'; ID: CSIDL_BITBUCKET),
    (Name: 'Common Alt Startup'; ID: CSIDL_COMMON_ALTSTARTUP),
    (Name: 'Common Desktop'; ID: CSIDL_COMMON_DESKTOPDIRECTORY),
    (Name: 'Common Favorites'; ID: CSIDL_COMMON_FAVORITES),
    (Name: 'Common Programs'; ID: CSIDL_COMMON_PROGRAMS),
    (Name: 'Common Start Menu'; ID: CSIDL_COMMON_STARTMENU),
    (Name: 'Common Startup'; ID: CSIDL_COMMON_STARTUP),
    (Name: 'Controls'; ID: CSIDL_CONTROLS),
    (Name: 'Cookies'; ID: CSIDL_COOKIES),
    (Name: 'Desktop'; ID: CSIDL_DESKTOP),
    (Name: 'Desktop Directory'; ID: CSIDL_DESKTOPDIRECTORY),
    (Name: 'Drives'; ID: CSIDL_DRIVES),
    (Name: 'Favorites'; ID: CSIDL_FAVORITES),
    (Name: 'Fonts'; ID: CSIDL_FONTS),
    (Name: 'History'; ID: CSIDL_HISTORY),
    (Name: 'Internet'; ID: CSIDL_INTERNET),
    (Name: 'Internet Cache'; ID: CSIDL_INTERNET_CACHE),
    (Name: 'Network Neighborhood'; ID: CSIDL_NETHOOD),
    (Name: 'Network Top'; ID: CSIDL_NETWORK),
    (Name: 'Personal'; ID: CSIDL_PERSONAL),
    (Name: 'Printers'; ID: CSIDL_PRINTERS),
    (Name: 'Printer Links'; ID: CSIDL_PRINTHOOD),
    (Name: 'Programs'; ID: CSIDL_PROGRAMS),
    (Name: 'Recent Documents'; ID: CSIDL_RECENT),
    (Name: 'Send To'; ID: CSIDL_SENDTO),
    (Name: 'Start Menu'; ID: CSIDL_STARTMENU),
    (Name: 'Startup'; ID: CSIDL_STARTUP),
    (Name: 'Templates'; ID: CSIDL_TEMPLATES));

  {SHObjectProperties Flags}
  OPF_PRINTERNAME = $01;
  OPF_PATHNAME = $02;

type
  TOpenFileNameEx = packed record
    lStructSize: DWORD;            // Size of the structure in bytes.
    hWndOwner: HWND;               // Handle that is the parent of the dialog.
    hInstance: HINST;              // Application instance handle.
    lpstrFilter: PAnsiChar;        // String containing filter information.
    lpstrCustomFilter: PAnsiChar;  // Will hold the filter chosen by the user.
    nMaxCustFilter: DWORD;         // Size of lpstrCustomFilter, in bytes.
    nFilterIndex: DWORD;           // Index of the filter to be shown.
    lpstrFile: PAnsiChar;          // File name to start with (and retrieve).
    nMaxFile: DWORD;               // Size of lpstrFile, in bytes.
    lpstrFileTitle: PAnsiChar;     // File name without path will be returned.
    nMaxFileTitle: DWORD;          // Size of lpstrFileTitle, in bytes.
    lpstrInitialDir: PAnsiChar;    // Starting directory.
    lpstrTitle: PAnsiChar;         // Title of the open dialog.
    Flags: DWORD;                  // Controls user selection Options.
    nFileOffset: Word;             // Offset of file name in filepath=lpstrFile.
    nFileExtension: Word;          // Offset of extension in filepath=lpstrFile.
    lpstrDefExt: PAnsiChar;        // Default extension if no extension typed.
    lCustData: LPARAM;             // Custom data to be passed to hook.
    lpfnHook: function(Wnd: HWND; Msg: UINT; wParam: WPARAM;
      lParam: LPARAM): UINT stdcall; // Hook.
    lpTemplateName: PAnsiChar;     // Template dialog, if applicable.
    // Extended structure starts here.
    pvReserved: Pointer;           // Reserved, use nil.
    dwReserved: DWORD;             // Reserved, use 0.
    FlagsEx: DWORD;                // Extended Flags.
  end;

  TShellObjectType = (sdPathObject, sdPrinterObject);
  TShellObjectTypes = set of TShellObjectType;

  TJvFormatDriveKind = (ftQuick, ftStandard, ftBootable);
  TJvDriveCapacity = (dcDefault, dcSize360kB, dcSize720kB);
  TJvFormatDriveError = (errParams, errSysError, errAborted, errCannotFormat, errOther);
  TJvFormatDriveErrorEvent = procedure(Sender: TObject; Error: TJvFormatDriveError) of object;

  TJvFormatDriveDialog = class(TJvCommonDialogF)
  private
    FDrive: Char;
    FFormatType: TJvFormatDriveKind;
    FCapacity: TJvDriveCapacity;
    FHandle: Integer;
    FOnError: TJvFormatDriveErrorEvent;
    procedure SetDrive(Value: Char);
  protected
    procedure DoError(ErrValue: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean; override;
  published
    property Drive: Char read FDrive write SetDrive default 'A';
    property FormatType: TJvFormatDriveKind read FFormatType write FFormatType;
    property Capacity: TJvDriveCapacity read FCapacity write FCapacity;
    property OnError: TJvFormatDriveErrorEvent read FOnError write FOnError;
  end;

  TJvOrganizeFavoritesDialog = class(TJvCommonDialog)
  public
    function Execute: Boolean; override;
  end;

  TJvControlPanelDialog = class(TJvCommonDialogP)
  public
    procedure Execute; override;
  end;

  TJvCplInfo = record
     Icon: TIcon;
     Name: string;
     Info: string;
     lData: Longint;
  end;

  // the signature of procedures in CPL's that implements Control Panel functionality
  TCplApplet = function(hwndCPl: HWND; uMsg: DWORD; lParam1, lParam2: Longint): Longint; stdcall;
  
  // (rom) largely reimplemented
  TJvAppletDialog = class(TJvCommonDialogF)
  private
    FAppletName: string;
    FAppletIndex: Integer;
    FModule: HMODULE;
    FCount: Integer;
    FAppletFunc: TCplApplet;
    FAppletInfo: array of TJvCplInfo;
    function GetAppletInfo(Index: Integer): TJvCplInfo;
    procedure SetAppletName(const AAppletName: string);
    procedure Unload;
    procedure Load;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
    property Count: Integer read FCount;
    property AppletInfo[Index: Integer]: TJvCplInfo read GetAppletInfo;
  published
    property AppletName: string read FAppletName write SetAppletName;
    property AppletIndex: Integer read FAppletIndex write FAppletIndex default 0;
  end;

  TJvComputerNameDialog = class(TJvCommonDialog)
  private
    FComputerName: string;
    FCaption: string;
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean; override;
    property ComputerName: string read FComputerName;
  published
    property Caption: string read FCaption write FCaption;
  end;

  TJvBrowseFolderDialog = class(TJvCommonDialog)
  private
    FFolderName: string;
    FCaption: string;
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean; override;
    property FolderName: string read FFolderName;
  published
    property Caption: string read FCaption write FCaption;
  end;

  TJvOutOfMemoryDialog = class(TJvCommonDialog)
  private
    FCaption: string;
  public
    function Execute: Boolean; override;
  published
    property Caption: string read FCaption write FCaption;
  end;

  // (rom) changed to new TJvCommonDialogF to get better Execute
  TJvChangeIconDialog = class(TJvCommonDialogF)
  private
    FIconIndex: Integer;
    FFileName: string;
  public
    function Execute: Boolean; override;
  published
    property IconIndex: Integer read FIconIndex write FIconIndex;
    property FileName: string read FFileName write FFileName;
  end;

  TJvShellAboutDialog = class(TJvCommonDialog)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
    FCaption: string;
    FIcon: TIcon;
    FOtherText: string;
    FProduct: string;
  private
    procedure SetIcon(NewValue: TIcon);
  private
    function StoreIcon: Boolean;
  public
    function Execute: Boolean; override;
  published
    property Caption: string read FCaption write FCaption;
    property Icon: TIcon read FIcon write SetIcon stored StoreIcon;
    property OtherText: string read FOtherText write FOtherText;
    property Product: string read FProduct write FProduct;
  end;

  TJvRunDialog = class(TJvCommonDialogP)
  private
    FCaption: string;
    FDescription: string;
    FIcon: TIcon;
    procedure SetIcon(const Value: TIcon);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute; override;
  published
    property Caption: string read FCaption write FCaption;
    property Description: string read FDescription write FDescription;
    property Icon: TIcon read FIcon write SetIcon;
  end;

  TJvObjectPropertiesDialog = class(TJvCommonDialogF)
  private
    FObjectName: TFileName;
    FObjectType: TShellObjectType;
    FInitialTab: string;
  public
    function Execute: Boolean; override;
  published
    property ObjectName: TFileName read FObjectName write FObjectName;
    property ObjectType: TShellObjectType read FObjectType write FObjectType;
    property InitialTab: string read FInitialTab write FInitialTab;
  end;

  TJvNewLinkDialog = class(TJvCommonDialogP)
  private
    FDestinationFolder: string;
  public
    procedure Execute; override;
  published
    property DestinationFolder: string read FDestinationFolder write
      FDestinationFolder;
  end;

  TJvAddHardwareDialog = class(TJvCommonDialogP)
  public
    procedure Execute; override;
  end;

  TJvOpenWithDialog = class(TJvCommonDialogP)
  private
    FFileName: string;
  public
    procedure Execute; override;
  published
    property FileName: string read FFileName write FFileName;
  end;

  TJvDiskFullDialog = class(TJvCommonDialogF)
  private
    FDriveChar: Char;
    procedure SetDriveChar(Value: Char);
    function GetDrive: UINT;
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean; override;
  published
    property DriveChar: Char read FDriveChar write SetDriveChar default 'C';
  end;

  TJvExitWindowsDialog = class(TJvCommonDialogP)
  public
    procedure Execute; override;
  end;

  TJvOpenDialog2000 = class(TOpenDialog)
  public
    function Execute: Boolean; override;
  end;

  TJvSaveDialog2000 = class(TSaveDialog)
  public
    function Execute: Boolean; override;
  end;

// Tools routines
function GetSpecialFolderPath(const FolderName: string; CanCreate: Boolean): string;
procedure AddToRecentDocs(const Filename: string);
procedure ClearRecentDocs;
function ExtractIconFromFile(FileName: string; Index: Integer): HICON;
function CreateShellLink(const AppName, Desc: string; Dest: string): string;
procedure GetShellLinkInfo(const LinkFile: WideString; var SLI: TShellLinkInfo);
procedure SetShellLinkInfo(const LinkFile: WideString; const SLI:
  TShellLinkInfo);
function RecycleFile(FileToRecycle: string): Boolean;
function CopyFile(FromFile, ToDir: string): Boolean;
function ShellObjectTypeEnumToConst(ShellObjectType: TShellObjectType): UINT;
function ShellObjectTypeConstToEnum(ShellObjectType: UINT): TShellObjectType;
function ShellMessageBox(Instance: THandle; Owner: HWND; Text: PChar;
  Caption: PChar; Style: UINT; Parameters: array of Pointer): Integer; cdecl;

type
  FreePIDLProc = procedure(PIDL: PItemIDList); stdcall;
  SHChangeIconProc = function(Wnd: HWND; szFileName: PChar; Reserved: Integer;
    var lpIconIndex: Integer): DWORD; stdcall;
  SHChangeIconProcW = function(Wnd: HWND; szFileName: PWideChar;
    Reserved: Integer; var lpIconIndex: Integer): DWORD; stdcall;
  SHFormatDriveProc = function(Wnd: HWND; drive: UINT; fmtID: UINT;
    Options: UINT): DWORD; stdcall;
  SHShutDownDialogProc = procedure(Wnd: HWND); stdcall;
  SHRunDialogProc = function(Wnd: HWND; Unknown1: Integer; Unknown2: Pointer;
    szTitle: PChar; szPrompt: PChar; uiFlages: Integer): DWORD; stdcall;
  SHFindFilesProc = function(Root: PItemIDList; SavedSearchFile: PItemIDList): LongBool; stdcall;
  SHFindComputerProc = function(Reserved1: PItemIDList; Reserved2: PItemIDList): LongBool; stdcall;
  SHObjectPropertiesProc = function(Owner: HWND; Flags: UINT;
    ObjectName: Pointer; InitialTabName: Pointer): LongBool; stdcall;
  SHNetConnectionDialogProc = function(Owner: HWND; ResourceName: Pointer;
    ResourceType: DWORD): DWORD; stdcall;
  SHStartNetConnectionDialogProc = function(Owner: HWND;
    ResourceName: PWideChar; ResourceType: DWORD): DWORD; stdcall;
  SHOutOfMemoryMessageBoxProc = function(Owner: HWND; Caption: Pointer;
    Style: UINT): Integer; stdcall;
  SHHandleDiskFullProc = procedure(Owner: HWND; uDrive: UINT); stdcall;
  NewLinkHereProc = procedure(HWND: THandle; HInstance: THandle; CmdLine: PChar;
    cmdShow: Integer); stdcall;
  SHOpenWithProc = procedure(HWND: THandle; HInstance: THandle; cmdLine: PChar;
    cmdShow: Integer); stdcall;
  GetOpenFileNameExProc = function(var OpenFile: TOpenFilenameEx): BOOL; stdcall;
  GetSaveFileNameExProc = function(var SaveFile: TOpenFileNameEx): BOOL; stdcall;

implementation

var
  FreePIDL: FreePIDLProc = nil;
  GetOpenFileNameEx: GetOpenFileNameExProc = nil;
  GetSaveFileNameEx: GetSaveFileNameExProc = nil;
  SHFormatDrive: SHFormatDriveProc = nil;
  SHShutDownDialog: SHShutDownDialogProc = nil;
  SHRunDialog: SHRunDialogProc = nil;
  SHFindFiles: SHFindFilesProc = nil;
  SHFindComputer: SHFindComputerProc = nil;
  SHObjectProperties: SHObjectPropertiesProc = nil;
  SHNetConnectionDialog: SHNetConnectionDialogProc = nil;
  SHStartNetConnectionDialog: SHStartNetConnectionDialogProc = nil;
  SHOutOfMemoryMessageBox: SHOutOfMemoryMessageBoxProc = nil;
  SHHandleDiskFull: SHHandleDiskFullProc = nil;
  NewLinkHere: NewLinkHereProc = nil;
  SHOpenWith: SHOpenWithProc = nil;
  SHChangeIcon: SHChangeIconProc = nil;
  SHChangeIconW: SHChangeIconProcW = nil;

resourcestring
  //SDiskFullError =
  //  'TJvDiskFullDialog does not support removable media or network drives.';
  SNotSupported = 'This function is not supported by your version of Windows';
  SInvalidDriveChar = 'Invalid drive (%s)';
  SUnsupportedDisk =
    'Unsupported drive (%s): JvDiskFullDialog only supports fixed drives.';

const
  Shell32 = 'shell32.dll';

var
  ShellHandle: THandle = 0;
  CommHandle: THandle = 0;
  AppWizHandle: THandle = 0;

procedure LoadJvDialogs;
begin
  ShellHandle := Windows.LoadLibrary(PChar(Shell32));
  if ShellHandle <> 0 then
  begin
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      SHChangeIconW := GetProcAddress(ShellHandle, PChar(62))
    else
      SHChangeIcon := GetProcAddress(ShellHandle, PChar(62));
    SHFormatDrive := GetProcAddress(ShellHandle, PChar('SHFormatDrive'));
    FreePIDL := GetProcAddress(ShellHandle, PChar(155));
    SHShutDownDialog := GetProcAddress(ShellHandle, PChar(60));
    SHRunDialog := GetProcAddress(ShellHandle, PChar(61));
    SHFindFiles := GetProcAddress(ShellHandle, PChar(90));
    SHFindComputer := GetProcAddress(ShellHandle, PChar(91));
    SHObjectProperties := GetProcAddress(ShellHandle, PChar(178));
    SHNetConnectionDialog := GetProcAddress(ShellHandle, PChar(160));
    SHOutOfMemoryMessageBox := GetProcAddress(ShellHandle, PChar(126));
    SHHandleDiskFull := GetProcAddress(ShellHandle, PChar(185));
    SHStartNetConnectionDialog := GetProcAddress(ShellHandle, PChar(215));
    SHOpenWith := GetProcAddress(ShellHandle, PChar('OpenAs_RunDLLA'));
  end;

  CommHandle := Windows.LoadLibrary('comdlg32.dll');
  if CommHandle <> 0 then
  begin
    GetOpenFileNameEx := GetProcAddress(CommHandle, PChar('GetOpenFileNameA'));
    GetSaveFileNameEx := GetProcAddress(CommHandle, PChar('GetSaveFileNameA'));
  end;

  AppWizHandle := Windows.LoadLibrary('appwiz.cpl');
  if AppWizHandle <> 0 then
    NewLinkHere := GetProcAddress(AppWizHandle, PChar('NewLinkHereA'));
end;

procedure UnloadJvDialogs;
begin
  if ShellHandle <> 0 then
    FreeLibrary(ShellHandle);
  if CommHandle <> 0 then
    FreeLibrary(CommHandle);
  if AppWizHandle <> 0 then
    FreeLibrary(AppWizHandle);
end;

{  Although most Win32 applications do not need to be able
   to format disks, some do. Windows 95 and Windows NT provide
   an API function called SHFormatDrive, which presents the
   same dialog box as the Windows 95 and Windows NT shells,
   formats the specified diskette.

   The SHFormatDrive API provides access to the Shell's format
   dialog box. This allows applications that want to format disks to bring
   up the same dialog box that the Shell uses for disk formatting.

   PARAMETERS
      hwnd    = The window handle of the window that will own the
                dialog. NOTE that hwnd == NULL does not cause this
                dialog to come up as a "top level application"
                window. This parameter should always be non-null,
                this dialog box is only designed to be the child of
                another window, not a stand-alone application.

      drive   = The 0 based (A: == 0) drive number of the drive
                to format.

      fmtID   = Currently must be set to SHFMT_ID_DEFAULT.

      Options = There are currently only two option bits defined.

                   SHFMT_OPT_FULL
                   SHFMT_OPT_SYSONLY

                SHFMT_OPT_FULL specifies that the "Quick Format"
                setting should be cleared by default. If the user
                leaves the "Quick Format" setting cleared, then a
                full format will be applied (this is useful for
                users that detect "unformatted" disks and want
                to bring up the format dialog box).

                If Options is set to zero (0), then the "Quick Format"
                setting is set by default. In addition, if the user leaves
                it set, a quick format is performed. Under Windows NT 4.0,
                this flag is ignored and the "Quick Format" box is always
                checked when the dialog box first appears. The user can
                still change it. This is by design.

                The SHFMT_OPT_SYSONLY initializes the dialog to
                default to just sys the disk.

                All other bits are Reserved for future expansion
                and must be 0.

                Please note that this is a bit field and not a
                value, treat it accordingly.

      RETURN
         The return is either one of the SHFMT_* values, or if
         the returned DWORD value is not == to one of these
         values, then the return is the physical format ID of the
         last successful format. The LOWORD of this value can be
         passed on subsequent calls as the fmtID parameter to
         "format the same type you did last time".
}

const
  SHFMT_ID_DEFAULT = $FFFF;
  SHFMT_OPT_FULL = $0001;
  SHFMT_OPT_SYSONLY = $0002;
  // Special return values. PLEASE NOTE that these are DWORD values.
  SHFMT_ERROR = $FFFFFFFF; // Error on last format
  // drive may be formatable
  SHFMT_CANCEL = $FFFFFFFE; // Last format wascanceled
  SHFMT_NOFORMAT = $FFFFFFFD; // Drive is not formatable

type
  LPFNORGFAV = function(Wnd: hWnd; Str: LPTSTR): Integer; stdcall;

function ExtractIconFromFile(FileName: string; Index: Integer): HICON;
var
  iNumberOfIcons: Integer;
begin
  Result := 0;
  if FileExists(FileName) then
  begin
    iNumberOfIcons := ExtractIcon(hInstance, PChar(FileName), Cardinal(-1));
    if (Index > 0) and (Index < iNumberOfIcons) and (iNumberOfIcons > 0) then
      Result := ExtractIcon(hInstance, PChar(FileName), Index);
  end;
end;

//=== TJvOrganizeFavoritesDialog =============================================

function TJvOrganizeFavoritesDialog.Execute: Boolean;
var
  SHModule: THandle;
  Path: string;
  lpfnDoOrganizeFavDlg: LPFNORGFAV;
begin
//  lpfnDoOrganizeFavDlg := nil;
  ShModule := SafeLoadLibrary('shdocvw.dll');
  try
    if ShModule <= HINSTANCE_ERROR then
    begin
      Result := False;
      Exit;
    end;
    Path := GetSpecialFolderPath('Favorites', True) + #0#0;
    lpfnDoOrganizeFavDlg := LPFNORGFAV(GetProcAddress(SHModule,
      'DoOrganizeFavDlg'));
    if not Assigned(lpfnDoOrganizeFavDlg) then
      raise EWinDialogError.Create(SNotSupported);
    lpfnDoOrganizeFavDlg(Application.Handle, PChar(Path));
  finally
    FreeLibrary(SHModule);
  end;
  Result := True;
end;

//=== TJvControlPanelDialog ==================================================

procedure TJvControlPanelDialog.Execute;
begin
  ShellExecute(0, 'open', 'Control.exe', nil, nil, SW_SHOWDEFAULT);
end;

//=== TJvAppletDialog ========================================================

const
  CPL_INIT = 1;
  CPL_GETCOUNT = 2;
  CPL_INQUIRE = 3;
  CPL_SELECT = 4;
  CPL_DBLCLK = 5;
  CPL_STOP = 6;
  CPL_EXIT = 7;
  CPL_NEWINQUIRE = 8;

type
  PCPLInfo = ^TCPLInfo;
  TCplInfo = packed record
    idIcon: Integer;
    idName: Integer;
    idInfo: Integer;
    lData: Longint;
  end;

constructor TJvAppletDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAppletName := '';
  FAppletIndex := 0;
  FModule := HINSTANCE_ERROR;
  FCount := 0;
  FAppletFunc := nil;
  SetLength(FAppletInfo, 0);
end;

destructor TJvAppletDialog.Destroy;
begin
  Unload;
  inherited Destroy;
end;

procedure TJvAppletDialog.Unload;
var
  I: Integer;
begin
  if (FModule > HINSTANCE_ERROR) and Assigned(FAppletFunc) then
  begin
    FAppletFunc(Application.Handle, CPL_EXIT, AppletIndex, AppletInfo[AppletIndex].lData);
    FreeLibrary(FModule);
  end;
  for I := 0 to Count-1 do
  begin
    FAppletInfo[I].Icon.Free;
    FAppletInfo[I].Name := '';
    FAppletInfo[I].Info := '';
  end;
  FModule := HINSTANCE_ERROR;
  FCount := 0;
  FAppletFunc := nil;
  SetLength(FAppletInfo, 0);
end;

procedure TJvAppletDialog.Load;
var
  I: Integer;
  AplInfo: TCplInfo;
  Buffer: array [0..1023] of Char;
begin
  Unload;
  if AppletName <> '' then
  begin
    FModule := LoadLibrary(PChar(AppletName));
    if FModule <= HINSTANCE_ERROR then
      Exit;
    FAppletFunc := TCplApplet(GetProcAddress(FModule, 'CPlApplet'));
    if Assigned(FAppletFunc) and (FAppletFunc(Application.Handle, CPL_INIT, 0, 0) <> 0) then
    begin
      FCount := FAppletFunc(Application.Handle, CPL_GETCOUNT, 0, 0);
      SetLength(FAppletInfo, FCount);
      for I := 0 to Count-1 do
      begin
        FAppletFunc(Application.Handle, CPL_INQUIRE, I, Longint(@AplInfo));
        with FAppletInfo[I] do
        begin
          Icon := TIcon.Create;
          Icon.Handle := LoadIcon(FModule, MakeIntResource(AplInfo.idIcon));
          LoadString(FModule, AplInfo.idName, Buffer, SizeOf(Buffer));
          Name := Buffer;
          LoadString(FModule, AplInfo.idInfo, Buffer, SizeOf(Buffer));
          Info := Buffer;
        end;
      end;
    end
    else
    begin
      FreeLibrary(FModule);
      FModule := HINSTANCE_ERROR;
    end;
  end;
  if AppletIndex >= Count then
    AppletIndex := 0;
end;

function TJvAppletDialog.GetAppletInfo(Index: Integer): TJvCplInfo;
begin
  FillChar(Result, SizeOf(Result), #0);
  if (Index >= 0) and (Index < Count) then
    Result := FAppletInfo[Index];
end;

procedure TJvAppletDialog.SetAppletName(const AAppletName: string);
begin
  Unload;
  FAppletName := AAppletName;
  Load;
end;

function TJvAppletDialog.Execute: Boolean;
begin
  Result := False;
  if Assigned(FAppletFunc) and (AppletIndex >= 0) and (AppletIndex < Count) then
  begin
    FAppletFunc(Application.Handle, CPL_DBLCLK, AppletIndex, AppletInfo[AppletIndex].lData);
    Result := True;
  end;
end;

//=== TJvComputerNameDialog ==================================================

constructor TJvComputerNameDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComputerName := '';
end;

function TJvComputerNameDialog.Execute: Boolean;
var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  NameBuffer: array [0..MAX_PATH] of Char;
  WindowList: Pointer;
begin
  Result := False;

  if Failed(SHGetSpecialFolderLocation(Application.Handle, CSIDL_NETWORK,
    ItemIDList)) then
    Exit;

  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  BrowseInfo.hwndOwner := Application.Handle;
  BrowseInfo.pidlRoot := ItemIDList;
  BrowseInfo.pszDisplayName := NameBuffer;
  BrowseInfo.lpszTitle := PChar(FCaption);
  BrowseInfo.ulFlags := BIF_BROWSEFORCOMPUTER;
  WindowList := DisableTaskWindows(0);
  try
    Result := SHBrowseForFolder(BrowseInfo) <> nil;
  finally
    EnableTaskWindows(WindowList);
    FreePidl(BrowseInfo.pidlRoot);
  end;
  if Result then
    FComputerName := NameBuffer;
end;

//=== TJvBrowseFolderDialog ==================================================

constructor TJvBrowseFolderDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFolderName := '';
end;

function TJvBrowseFolderDialog.Execute: Boolean;
var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  ItemSelected: PItemIDList;
  NameBuffer: array [0..MAX_PATH] of Char;
  WindowList: Pointer;
begin
  ItemIDList := nil;
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  BrowseInfo.hwndOwner := Application.Handle;
  BrowseInfo.pidlRoot := ItemIDList;
  BrowseInfo.pszDisplayName := NameBuffer;
  BrowseInfo.lpszTitle := PChar(FCaption);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  WindowList := DisableTaskWindows(0);
  try
    ItemSelected := SHBrowseForFolder(BrowseInfo);
    Result := ItemSelected <> nil;
  finally
    EnableTaskWindows(WindowList);
  end;

  if Result then
  begin
    SHGetPathFromIDList(ItemSelected, NameBuffer);
    FFolderName := NameBuffer;
  end;
  FreePIDL(BrowseInfo.pidlRoot);
end;

//=== TJvFormatDialog ========================================================

constructor TJvFormatDriveDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDrive := 'A';
  if AOwner is TCustomForm then
    FHandle := TCustomForm(AOwner).Handle
  else
    FHandle := 0;
end;

function TJvFormatDriveDialog.Execute: Boolean;
var
  iDrive, iCapacity, iFormatType, RetVal: Integer;
begin
  iDrive := Ord(FDrive) - Ord('A');
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    iCapacity := 0; // other styles not supported
    if FFormatType = ftQuick then
      iFormatType := 1
    else
      iFormatType := 0;
  end
  else
  begin
    case FCapacity of
      dcSize360kB:
        iCapacity := 3;
      dcSize720kB:
        iCapacity := 5;
    else
      iCapacity := 0;
    end;
    iFormatType := Ord(FFormatType);
  end;

  RetVal := SHFormatDrive(FHandle, iDrive, iCapacity, iFormatType);
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := RetVal = 0
  else
    Result := RetVal = 6;
  if not Result then
    DoError(RetVal);
end;

procedure TJvFormatDriveDialog.DoError(ErrValue: Integer);
var
  Err: TJvFormatDriveError;
begin
  if Assigned(FOnError) then
  begin
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      Err := errOther
    else
      case ErrValue of
        0:
          Err := errParams;
        -1:
          Err := errSysError;
        -2:
          Err := errAborted;
        -3:
          Err := errCannotFormat;
      else
        Err := errOther;
      end; // case
    FOnError(Self, Err);
  end;
end;

procedure TJvFormatDriveDialog.SetDrive(Value: Char);
begin
  // (rom) secured
  Value := UpCase(Value);
  if Value in ['A'..'Z'] then
    FDrive := UpCase(Value);
end;

function GetSpecialFolderPath(const FolderName: string; CanCreate: Boolean): string;
var
  Folder: Integer;
  Found: Boolean;
  I: Integer;
  PIDL: PItemIDList;
  Buf: array [0..MAX_PATH] of Char;
begin
  Found := False;
  Folder := 0;
  Result := '';
  for I := Low(SpecialFolders) to High(SpecialFolders) do
  begin
    if AnsiCompareText(FolderName, SpecialFolders[I].Name) = 0 then
    begin
      Folder := SpecialFolders[I].ID;
      Found := True;
      Break;
    end;
  end;
  if not Found then
    Exit;
  { Get path of selected location }
  {JPR}
  if Succeeded(SHGetSpecialFolderLocation(0, Folder, PIDL)) then
  begin
    if SHGetPathFromIDList(PIDL, Buf) then
      Result := Buf;
    CoTaskMemFree(PIDL);
  end;
 {JPR}
end;

procedure AddToRecentDocs(const Filename: string);
begin
  SHAddToRecentDocs(SHARD_PATH, PChar(Filename));
end;

procedure ClearRecentDocs;
begin
  SHAddToRecentDocs(SHARD_PATH, nil);
end;

function ExecuteShellMessageBox(MethodPtr: Pointer; Instance: THandle;
  Owner: HWND; Text: Pointer; Caption: Pointer; Style: UINT;
  Parameters: array of Pointer): Integer;
type
  PPointer = ^Pointer;
var
  ParamCount: Integer;
  ParamBuffer: PChar;
  BufferIndex: Integer;
begin
  ParamCount := High(Parameters) + 1;
  GetMem(ParamBuffer, ParamCount * SizeOf(Pointer));
  try
    for BufferIndex := 0 to High(Parameters) do
    begin
      PPointer(@ParamBuffer[BufferIndex * SizeOf(Pointer)])^ :=
      Parameters[High(Parameters) - BufferIndex];
    end;
    asm
      mov ECX, ParamCount
      cmp ECX, 0
      je  @MethodCall
      mov EDX, ParamBuffer
      @StartLoop:
      push DWORD PTR[EDX]
      add  EDX, 4
      loop @StartLoop
      @MethodCall:
      push Style
      push Caption
      push Text
      push Owner
      push Instance

      call MethodPtr
      mov  Result, EAX
    end;
  finally
    FreeMem(ParamBuffer);
  end;
end;

function ShellMessageBox(Instance: THandle; Owner: HWND; Text: PChar;
  Caption: PChar;  Style: UINT; Parameters: array of Pointer): Integer;
var
  MethodPtr: Pointer;
  ShellDLL: HMODULE;
begin
  ShellDLL := LoadLibrary(PChar(Shell32));
  MethodPtr := GetProcAddress(ShellDLL, PChar(183));
  if MethodPtr <> nil then
  begin
    Result := ExecuteShellMessageBox(MethodPtr, Instance, Owner, Text, Caption,
      Style, Parameters);
  end
  else
  begin
    Result := ID_CANCEL;
  end;
end;

//=== TJvOutOfMemoryDialog ===================================================

function TJvOutOfMemoryDialog.Execute: Boolean;
var
  CaptionBuffer: Pointer;
begin
  CaptionBuffer := nil;
  if FCaption <> '' then
    GetMem(CaptionBuffer, (Length(FCaption) + 1) * SizeOf(WideChar));

  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    if CaptionBuffer <> nil then
      StringToWideChar(FCaption, PWideChar(CaptionBuffer), Length(FCaption) + 1);
  end
  else
  begin
    if CaptionBuffer <> nil then
      StrPCopy(PChar(CaptionBuffer), FCaption);
  end;
  if Assigned(SHOutOfMemoryMessageBox) then
    Result := Boolean(SHOutOfMemoryMessageBox(Application.Handle, CaptionBuffer,
      MB_OK or MB_ICONHAND))
  else
    raise EWinDialogError.Create(sNotSupported);
end;

//=== TJvShellAboutDialog ====================================================

constructor TJvShellAboutDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIcon := TIcon.Create;
end;

destructor TJvShellAboutDialog.Destroy;
begin
  FIcon.Free;
  inherited Destroy;
end;

procedure TJvShellAboutDialog.SetIcon(NewValue: TIcon);
begin
  FIcon.Assign(NewValue);
end;

function TJvShellAboutDialog.StoreIcon: Boolean;
begin
  Result := (not FIcon.Empty);
end;

function TJvShellAboutDialog.Execute: Boolean;
const
  AboutText = 'JvDialogs 2.0';
  CaptionSeparator = '#';
var
  CaptionText: string;
begin
  if Caption = '' then
    CaptionText := AboutText
  else
    CaptionText := Caption;

  CaptionText := CaptionText + CaptionSeparator + Product;

  OSCheck(LongBool(ShellAbout(Application.MainForm.Handle,
    PChar(CaptionText), PChar(OtherText), FIcon.Handle)));
  Result := True;
end;

//=== TJvRunDialog ===========================================================

constructor TJvRunDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaption := '';
  FDescription := '';
  FIcon := TIcon.Create;
end;

destructor TJvRunDialog.Destroy;
begin
  FIcon.Free;
  inherited Destroy;
end;

procedure TJvRunDialog.Execute;
var
  CaptionBuffer: Pointer;
  DescriptionBuffer: Pointer;
begin
  CaptionBuffer := nil;
  DescriptionBuffer := nil;

  if FCaption <> '' then
    GetMem(CaptionBuffer, (Length(FCaption) + 1) * SizeOf(WideChar));

  if FDescription <> '' then
    GetMem(DescriptionBuffer, (Length(FDescription) + 1) * SizeOf(WideChar));

  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    if CaptionBuffer <> nil then
      StringToWideChar(FCaption, PWideChar(CaptionBuffer), Length(FCaption) + 1);
    if DescriptionBuffer <> nil then
      StringToWideChar(FDescription, PWideChar(DescriptionBuffer),
        Length(FDescription) + 1);
  end
  else
  begin
    if CaptionBuffer <> nil then
      StrPCopy(PChar(CaptionBuffer), FCaption);
    if DescriptionBuffer <> nil then
      StrPCopy(PChar(DescriptionBuffer), FDescription);
  end;

  if Assigned(SHRunDialog) then
    SHRunDialog(Application.Handle, FIcon.Handle, nil, CaptionBuffer,
      DescriptionBuffer, 0)
  else
    raise EWinDialogError.Create(sNotSupported);
end;

procedure TJvRunDialog.SetIcon(const Value: TIcon);
begin
  FIcon.Assign(Value);
end;

//=== TJvObjectPropertiesDialog ==============================================

function TJvObjectPropertiesDialog.Execute: Boolean;
var
  ObjectNameBuffer: Pointer;
  TabNameBuffer: Pointer;
begin
  GetMem(ObjectNameBuffer, (Length(ObjectName) + 1) * SizeOf(WideChar));
  try
    if SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      StringToWideChar(ObjectName, PWideChar(ObjectNameBuffer),
        Length(ObjectName) + 1);
    end
    else
    begin
      StrPCopy(PChar(ObjectNameBuffer), ObjectName);
    end;

    GetMem(TabNameBuffer, (Length(InitialTab) + 1) * SizeOf(WideChar));
    try
      if SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT then
      begin
        StringToWideChar(InitialTab, PWideChar(TabNameBuffer),
          Length(InitialTab) + 1);
      end
      else
      begin
        StrPCopy(PChar(TabNameBuffer), InitialTab);
      end;
      Result := SHObjectProperties(Application.Handle,
        ShellObjectTypeEnumToConst(ObjectType), ObjectNameBuffer,
        TabNameBuffer);
    finally
      FreeMem(TabNameBuffer);
    end;
  finally
    FreeMem(ObjectNameBuffer);
  end;
end;

function ShellObjectTypeEnumToConst(ShellObjectType: TShellObjectType): UINT;
begin
  case ShellObjectType of
    sdPathObject:
      Result := OPF_PATHNAME;
    sdPrinterObject:
      Result := OPF_PRINTERNAME;
  else
    Result := 0;
  end;
end;

function ShellObjectTypeConstToEnum(ShellObjectType: UINT): TShellObjectType;
begin
  case ShellObjectType of
    OPF_PATHNAME:
      Result := sdPathObject;
    OPF_PRINTERNAME:
      Result := sdPrinterObject;
  else
    Result := sdPathObject;
  end;
end;

//=== TJvNewLinkDialog =======================================================

procedure TJvNewLinkDialog.Execute;
begin
  NewLinkHere(0, 0, PChar(DestinationFolder), 0);
end;

//=== TJvAddHardwareDialog ===================================================

procedure TJvAddHardwareDialog.Execute;
var
  APModule: THandle;
  Applet: TCplApplet;
begin
  APModule := LoadLibrary('hdwwiz.cpl');
  if APModule <= HINSTANCE_ERROR then
    Exit;
  Applet := TCplApplet(GetProcAddress(APModule, 'CPlApplet'));
  Applet(0, CPL_DBLCLK, 0, 0);
  FreeLibrary(APModule);
end;

function CreateShellLink(const AppName, Desc: string; Dest: string): string;
{ Creates a shell link for application or document specified in  }
{ AppName with description Desc.  Link will be located in folder }
{ specified by Dest, which is one of the string constants shown  }
{ at the top of this unit.  Returns the full path name of the    }
{ link file. }
var
  SL: IShellLink;
  PF: IPersistFile;
  LnkName: WideString;
begin
  OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
    IShellLink, SL));
  { The IShellLink implementer must also support the IPersistFile }
  { interface. Get an interface pointer to it. }
  PF := SL as IPersistFile;
  OleCheck(SL.SetPath(PChar(AppName))); // set link path to proper file
  if Desc <> '' then
    OleCheck(SL.SetDescription(PChar(Desc))); // set description
  { create a path location and filename for link file }
  LnkName := GetSpecialFolderPath(Dest, True) + '\' +
    ChangeFileExt(AppName, 'lnk');
  PF.Save(PWideChar(LnkName), True); // save link file
  Result := LnkName;
end;

procedure GetShellLinkInfo(const LinkFile: WideString; var SLI: TShellLinkInfo);
{ Retrieves information on an existing shell link }
var
  SL: IShellLink;
  PF: IPersistFile;
  FindData: TWin32FindData;
  AStr: array [0..MAX_PATH] of Char;
begin
  OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
    IShellLink, SL));
  { The IShellLink implementer must also support the IPersistFile }
  { interface. Get an interface pointer to it. }
  PF := SL as IPersistFile;
  { Load file into IPersistFile object }
  OleCheck(PF.Load(PWideChar(LinkFile), STGM_READ));
  { Resolve the link by calling the Resolve interface function. }
  OleCheck(SL.Resolve(0, SLR_ANY_MATCH or SLR_NO_UI));
  { Get all the info! }
  with SLI do
  begin
    OleCheck(SL.GetPath(AStr, MAX_PATH, FindData, SLGP_SHORTPATH));
    PathName := AStr;
    OleCheck(SL.GetArguments(AStr, MAX_PATH));
    Arguments := AStr;
    OleCheck(SL.GetDescription(AStr, MAX_PATH));
    Description := AStr;
    OleCheck(SL.GetWorkingDirectory(AStr, MAX_PATH));
    WorkingDirectory := AStr;
    OleCheck(SL.GetIconLocation(AStr, MAX_PATH, IconIndex));
    IconLocation := AStr;
    OleCheck(SL.GetShowCmd(ShowCmd));
    OleCheck(SL.GetHotKey(HotKey));
  end;
end;

procedure SetShellLinkInfo(const LinkFile: WideString; const SLI:
  TShellLinkInfo);
{ Sets information for an existing shell link }
var
  SL: IShellLink;
  PF: IPersistFile;
begin
  OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
    IShellLink, SL));
  { The IShellLink implementer must also support the IPersistFile }
  { interface. Get an interface pointer to it. }
  PF := SL as IPersistFile;
  { Load file into IPersistFile object }
  OleCheck(PF.Load(PWideChar(LinkFile), STGM_SHARE_DENY_WRITE));
  { Resolve the link by calling the Resolve interface function. }
  OleCheck(SL.Resolve(0, SLR_ANY_MATCH or SLR_UPDATE or SLR_NO_UI));
  { Set all the info! }
  with SLI, SL do
  begin
    OleCheck(SetPath(PChar(PathName)));
    OleCheck(SetArguments(PChar(Arguments)));
    OleCheck(SetDescription(PChar(Description)));
    OleCheck(SetWorkingDirectory(PChar(WorkingDirectory)));
    OleCheck(SetIconLocation(PChar(IconLocation), IconIndex));
    OleCheck(SetShowCmd(ShowCmd));
    OleCheck(SetHotKey(HotKey));
  end;
  PF.Save(PWideChar(LinkFile), True); // save file
end;

function RecycleFile(FileToRecycle: string): Boolean;
var
  OpStruct: TSHFileOpStruct;
  PFromC: PChar;
  ResultVal: Integer;
begin
  if not FileExists(FileToRecycle) then
  begin
    RecycleFile := False;
    Exit;
  end
  else
  begin
    PFromC := PChar(ExpandFileName(FileToRecycle) + #0#0);
    OpStruct.Wnd := 0;
    OpStruct.wFunc := FO_DELETE;
    OpStruct.pFrom := PFromC;
    OpStruct.pTo := nil;
    OpStruct.fFlags := FOF_ALLOWUNDO;
    OpStruct.fAnyOperationsAborted := False;
    OpStruct.hNameMappings := nil;
    ResultVal := ShFileOperation(OpStruct);
    RecycleFile := (ResultVal = 0);
  end;
end;

function CopyFile(FromFile, ToDir: string): Boolean;
var
  F: TShFileOpStruct;
begin
  F.Wnd := 0;
  F.wFunc := FO_COPY;
  FromFile := FromFile + #0;
  F.pFrom := PChar(FromFile);
  ToDir := ToDir + #0;
  F.pTo := PChar(ToDir);
  F.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
  Result := ShFileOperation(F) = 0;
end;

// (rom) ExecuteApplet function removed

//=== TJvOpenWithDialog ======================================================

procedure TJvOpenWithDialog.Execute;
begin
  SHOpenWith(0, 0, PChar(FFileName), SW_SHOW);
end;

//=== TJvDiskFullDialog ======================================================

constructor TJvDiskFullDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DriveChar := 'C';
end;

function TJvDiskFullDialog.GetDrive: UINT;
begin
  Result := Ord(FDriveChar) - Ord('A');
end;

function TJvDiskFullDialog.Execute: Boolean;
begin
  if not Assigned(SHHandleDiskFull) then
    raise EWinDialogError.Create(SNotSupported);
  Result := GetDriveType(PChar(DriveChar + ':\')) = 3;
  if Result then
    SHHandleDiskFull(GetFocus, GetDrive);
  // (rom) disabled to make Result work
  //else
  //  raise EWinDialogError.CreateFmt(SUnSupportedDisk, [DriveChar]);
end;

procedure TJvDiskFullDialog.SetDriveChar(Value: Char);
begin
  if Value in ['a'..'z'] then
    Value := Char(Ord(Value) - $20);
  if not (Value in ['A'..'Z']) then
    raise EWinDialogError.CreateFmt(SInvalidDriveChar, [Value]);
  FDriveChar := Value;
end;

//=== TJvExitWindowsDialog ===================================================

procedure TJvExitWindowsDialog.Execute;
begin
  SHShutDownDialog(Application.Handle);
end;

//=== TJvChangeIconDialog ====================================================

function TJvChangeIconDialog.Execute: Boolean;
var
  Buf: array [0..MAX_PATH] of Char;
  BufW: array [0..MAX_PATH] of WideChar;
begin
  if Assigned(SHChangeIconW) then
  begin
    StringToWideChar(FileName, BufW, SizeOf(BufW));
    Result := SHChangeIconW(Application.Handle, BufW, SizeOf(BufW), FIconIndex) = 1;
    if Result then
      FileName := BufW;
  end
  else
  if Assigned(SHChangeIcon) then
  begin
    StrPCopy(Buf, FileName);
    Result := SHChangeIcon(Application.Handle, Buf, SizeOf(Buf), FIconIndex) = 1;
    if Result then
      FileName := Buf;
  end
  else
    raise EWinDialogError.Create(SNotSupported);
end;

function OpenInterceptor(var DialogData: TOpenFileName): BOOL; stdcall;
var
  DialogDataEx: TOpenFileNameEx;
begin
  Move(DialogData, DialogDataEx, SizeOf(DialogData));
  DialogDataEx.FlagsEx := 0;
  DialogDataEx.lStructSize := SizeOf(TOpenFileNameEx);
  Result := GetOpenFileNameEx(DialogDataEx);
end;

function SaveInterceptor(var DialogData: TOpenFileName): BOOL; stdcall;
var
  DialogDataEx: TOpenFileNameEx;
begin
  Move(DialogData, DialogDataEx, SizeOf(DialogData));
  DialogDataEx.FlagsEx := 0;
  DialogDataEx.lStructSize := SizeOf(TOpenFileNameEx);
  Result := GetSaveFileNameEx(DialogDataEx);
end;

//=== TJvOpenDialog2000 ======================================================

function TJvOpenDialog2000.Execute: Boolean;
begin
  if (Win32MajorVersion >= 5) and (Win32Platform = VER_PLATFORM_WIN32_NT) then
    Result := DoExecute(@OpenInterceptor)
  else
    Result := inherited Execute;
end;

//=== TJvSaveDialog2000 ======================================================

function TJvSaveDialog2000.Execute: Boolean;
begin
  if (Win32MajorVersion >= 5) and (Win32Platform = VER_PLATFORM_WIN32_NT) then
    Result := DoExecute(@SaveInterceptor)
  else
    Result := inherited Execute;
end;

initialization
  LoadJvDialogs;

finalization
  UnloadJvDialogs;

end.

