{------------------------------------------------------------------------------}
{                                                                              }
{  TSysImageList v1.52                                                         }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{------------------------------------------------------------------------------}

{$I DELPHIAREA.INC}

{$IFDEF COMPILER6_UP}
  {$WARN SYMBOL_PLATFORM OFF} // This is a Win32 component, no warning
{$ENDIF}

unit SysImg;

interface

uses
  Windows, SysUtils, Classes, Graphics,
  {$IFDEF COMPILER4_UP} ImgList {$ELSE} ComCtrls {$ENDIF};

type

  TIconSize = (isSmallIcons, isLargeIcons);
  TIconSet = (isSystem, isToolbar);

  {$IFDEF COMPILER4_UP}
  TSysImageList = class(TCustomImageList)
  {$ELSE}
  TSysImageList = class(TImageList)
  {$ENDIF}
  private
    fIconSet: TIconSet;
    fIconSize: TIconSize;
    hToolbar: THandle;
    procedure SetIconSet(Value: TIconSet);
    procedure SetIconSize(Value: TIconSize);
  protected
    procedure Loaded; override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure UpdateHandle;
    function SpecialImageIndexOf(FolderID: Integer; OpenIcon: Boolean): Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ImageIndexOf(const Path: String; OpenIcon: Boolean
      {$IFDEF COMPILER4_UP} = False {$ENDIF}): Integer;
  published
    Property BkColor default clNone;
    Property BlendColor default clNone;
    property DrawingStyle default dsTransparent;
    property IconSet: TIconSet read fIconSet write SetIconSet default isSystem;
    property IconSize: TIconSize read fIconSize write SetIconSize default isSmallIcons;
    property OnChange;
  end;

{$IFDEF COMPILER4_UP}
function GetSpecialFolderID(const Path: String): Integer;
function GetSpecialFolderPath(FolderID: Integer): String;
{$ENDIF}

procedure Register;

const
  SpecialFolderIDs: array[1..58] of Word = (
    // CSIDL_ADMINTOOLS
    // Version 5.0. The file system directory that is used to store administrative tools for an individual user. The Microsoft Management Console (MMC) will save customized consoles to this directory, and it will roam with the user.
    $0030,
    // CSIDL_ALTSTARTUP
    // The file system directory that corresponds to the user's nonlocalized Startup program group.
    $001D,
    //CSIDL_APPDATA
    // Version 4.71. The file system directory that serves as a common repository for application-specific data. A typical path is C:\Documents and Settings\username\Application Data. This CSIDL is supported by the redistributable Shfolder.dll for systems that do not have the Microsoft Internet Explorer 4.0 integrated Shell installed.
    $001A,
    //CSIDL_BITBUCKET
    // The virtual folder containing the objects in the user's Recycle Bin.
    $000A,
    // CSIDL_CDBURN_AREA
    // Version 6.0. The file system directory acting as a staging area for files waiting to be written to CD. A typical path is C:\Documents and Settings\username\Local Settings\Application Data\Microsoft\CD Burning.
    $003B,
    // CSIDL_COMMON_ADMINTOOLS
    // Version 5.0. The file system directory containing administrative tools for all users of the computer.
    $002F,
    // CSIDL_COMMON_ALTSTARTUP
    // The file system directory that corresponds to the nonlocalized Startup program group for all users. Valid only for Microsoft Windows NT systems.
    $001E,
    // CSIDL_COMMON_APPDATA
    // Version 5.0. The file system directory containing application data for all users. A typical path is C:\Documents and Settings\All Users\Application Data.
    $0023,
    // CSIDL_COMMON_DESKTOPDIRECTORY
    // The file system directory that contains files and folders that appear on the desktop for all users. A typical path is C:\Documents and Settings\All Users\Desktop. Valid only for Windows NT systems.
    $0019,
    // CSIDL_COMMON_DOCUMENTS
    // The file system directory that contains documents that are common to all users. A typical paths is C:\Documents and Settings\All Users\Documents. Valid for Windows NT systems and Microsoft Windows 95 and Windows 98 systems with Shfolder.dll installed.
    $002E,
    // CSIDL_COMMON_FAVORITES
    // The file system directory that serves as a common repository for favorite items common to all users. Valid only for Windows NT systems.
    $001F,
    // CSIDL_COMMON_MUSIC
    // Version 6.0. The file system directory that serves as a repository for music files common to all users. A typical path is C:\Documents and Settings\All Users\Documents\My Music.
    $0035,
    // CSIDL_COMMON_OEM_LINKS
    // This value is recognized in Windows Vista for backward compatibility, but the folder itself is no longer used.
    $003A,
    // CSIDL_COMMON_PICTURES
    // Version 6.0. The file system directory that serves as a repository for image files common to all users. A typical path is C:\Documents and Settings\All Users\Documents\My Pictures.
    $0036,
    // CSIDL_COMMON_PROGRAMS
    // The file system directory that contains the directories for the common program groups that appear on the Start menu for all users. A typical path is C:\Documents and Settings\All Users\Start Menu\Programs. Valid only for Windows NT systems.
    $0017,
    // CSIDL_COMMON_STARTMENU
    // The file system directory that contains the programs and folders that appear on the Start menu for all users. A typical path is C:\Documents and Settings\All Users\Start Menu. Valid only for Windows NT systems.
    $0016,
    // CSIDL_COMMON_STARTUP
    // The file system directory that contains the programs that appear in the Startup folder for all users. A typical path is C:\Documents and Settings\All Users\Start Menu\Programs\Startup. Valid only for Windows NT systems.
    $0018,
    // CSIDL_COMMON_TEMPLATES
    // The file system directory that contains the templates that are available to all users. A typical path is C:\Documents and Settings\All Users\Templates. Valid only for Windows NT systems.
    $002D,
    // CSIDL_COMMON_VIDEO
    // Version 6.0. The file system directory that serves as a repository for video files common to all users. A typical path is C:\Documents and Settings\All Users\Documents\My Videos.
    $0037,
    // CSIDL_COMPUTERSNEARME
    // The folder that represents other computers in your workgroup.
    $003D,
    // CSIDL_CONNECTIONS
    // The virtual folder that represents Network Connections, that contains network and dial-up connections.
    $0031,
    // CSIDL_CONTROLS
    // The virtual folder containing icons for the Control Panel applications.
    $0003,
    // CSIDL_COOKIES
    // The file system directory that serves as a common repository for Internet cookies. A typical path is C:\Documents and Settings\username\Cookies.
    $0021,
    // CSIDL_DESKTOP
    // The virtual folder representing the Windows desktop, the root of the namespace.
    $0000,
    // CSIDL_DESKTOPDIRECTORY
    // The file system directory used to physically store file objects on the desktop (not to be confused with the desktop folder itself). A typical path is C:\Documents and Settings\username\Desktop.
    $0010,
    // CSIDL_DRIVES
    // The virtual folder representing My Computer, containing everything on the local computer: storage devices, printers, and Control Panel. The folder may also contain mapped network drives.
    $0011,
    // CSIDL_FAVORITES
    // The file system directory that serves as a common repository for the user's favorite items. A typical path is C:\Documents and Settings\username\Favorites.
    $0006,
    // CSIDL_FONTS
    // A virtual folder containing fonts. A typical path is C:\Windows\Fonts.
    $0014,
    // CSIDL_HISTORY
    // The file system directory that serves as a common repository for Internet history items.
    $0022,
    // CSIDL_INTERNET
    // A virtual folder representing the Internet.
    $0001,
    // CSIDL_INTERNET_CACHE
    // Version 4.72. The file system directory that serves as a common repository for temporary Internet files. A typical path is C:\Documents and Settings\username\Local Settings\Temporary Internet Files.
    $0020,
    // CSIDL_LOCAL_APPDATA
    // Version 5.0. The file system directory that serves as a data repository for local (nonroaming) applications. A typical path is C:\Documents and Settings\username\Local Settings\Application Data.
    $001C,
    // CSIDL_MYDOCUMENTS
    // Version 6.0. The virtual folder representing the My Documents desktop item.
    $000C,
    // CSIDL_MYMUSIC
    // The file system directory that serves as a common repository for music files. A typical path is C:\Documents and Settings\User\My Documents\My Music.
    $000D,
    // CSIDL_MYPICTURES
    // Version 5.0. The file system directory that serves as a common repository for image files. A typical path is C:\Documents and Settings\username\My Documents\My Pictures.
    $0027,
    // CSIDL_MYVIDEO
    // Version 6.0. The file system directory that serves as a common repository for video files. A typical path is C:\Documents and Settings\username\My Documents\My Videos.
    $000E,
    // CSIDL_NETHOOD
    // A file system directory containing the link objects that may exist in the My Network Places virtual folder. It is not the same as CSIDL_NETWORK, which represents the network namespace root. A typical path is C:\Documents and Settings\username\NetHood.
    $0013,
    // CSIDL_NETWORK
    // A virtual folder representing Network Neighborhood, the root of the network namespace hierarchy.
    $0012,
    // CSIDL_PERSONAL
    // Version 6.0. The virtual folder representing the My Documents desktop item. This is equivalent to CSIDL_MYDOCUMENTS.
    // Previous to Version 6.0. The file system directory used to physically store a user's common repository of documents. A typical path is C:\Documents and Settings\username\My Documents. This should be distinguished from the virtual My Documents folder in the namespace. To access that virtual folder, use SHGetFolderLocation, which returns the ITEMIDLIST for the virtual location, or refer to the technique described in Managing the File System.
    $0005,
    // CSIDL_PRINTERS
    // The virtual folder containing installed printers.
    $0004,
    // CSIDL_PRINTHOOD
    // The file system directory that contains the link objects that can exist in the Printers virtual folder. A typical path is C:\Documents and Settings\username\PrintHood.
    $001B,
    // CSIDL_PROFILE
    // Version 5.0. The user's profile folder. A typical path is C:\Documents and Settings\username. Applications should not create files or folders at this level; they should put their data under the locations referred to by CSIDL_APPDATA or CSIDL_LOCAL_APPDATA.
    $0028,
    // CSIDL_PROFILES
    // Version 6.0. The file system directory containing user profile folders. A typical path is C:\Documents and Settings.
    $003E,
    // CSIDL_PROGRAM_FILES
    // Version 5.0. The Program Files folder. A typical path is C:\Program Files.
    $0026,
    // CSIDL_PROGRAM_FILESX86
    $002A,
    // CSIDL_PROGRAM_FILES_COMMON
    // Version 5.0. A folder for components that are shared across applications. A typical path is C:\Program Files\Common. Valid only for Windows NT, Windows 2000, and Windows XP systems. Not valid for Windows Millennium Edition (Windows Me).
    $002B,
    // CSIDL_PROGRAM_FILES_COMMONX86
    $002C,
    // CSIDL_PROGRAMS
    // The file system directory that contains the user's program groups (which are themselves file system directories). A typical path is C:\Documents and Settings\username\Start Menu\Programs.
    $0002,
    // CSIDL_RECENT
    // The file system directory that contains shortcuts to the user's most recently used documents. A typical path is C:\Documents and Settings\username\My Recent Documents. To create a shortcut in this folder, use SHAddToRecentDocs. In addition to creating the shortcut, this function updates the Shell's list of recent documents and adds the shortcut to the My Recent Documents submenu of the Start menu.
    $0008,
    // CSIDL_RESOURCES
    // Windows Vista. The file system directory that contains resource data. A typical path is C:\Windows\Resources.
    $0038,
    // CSIDL_RESOURCES_LOCALIZED
    $0039,
    // CSIDL_SENDTO
    // The file system directory that contains Send To menu items. A typical path is C:\Documents and Settings\username\SendTo.
    $0009,
    // CSIDL_STARTMENU
    // The file system directory containing Start menu items. A typical path is C:\Documents and Settings\username\Start Menu.
    $000B,
    // CSIDL_STARTUP
    // The file system directory that corresponds to the user's Startup program group. The system starts these programs whenever any user logs onto Windows NT or starts Windows 95. A typical path is C:\Documents and Settings\username\Start Menu\Programs\Startup.
    $0007,
    // CSIDL_SYSTEM
    // Version 5.0. The Windows System folder. A typical path is C:\Windows\System32.
    $0025,
    // CSIDL_SYSTEMX86
    $0029,
    // CSIDL_TEMPLATES
    // The file system directory that serves as a common repository for document templates. A typical path is C:\Documents and Settings\username\Templates.
    $0015,
    // CSIDL_WINDOWS
    // Version 5.0. The Windows directory or SYSROOT. This corresponds to the %windir% or %SYSTEMROOT% environment variables. A typical path is C:\Windows.
    $0024
  );

implementation

uses
  ShellAPI, ShlObj, ActiveX, CommCtrl {$IFDEF COMPILER4_UP}, ComCtrls {$ENDIF},
  Math;

procedure Register;
begin
  RegisterComponents('Delphi Area', [TSysImageList]);
end;

var
  TempFileLock: TRTLCriticalSection;
  {$IFDEF COMPILER4_UP}
  SpecialFoldersLock: TRTLCriticalSection;
  SpecialFolders: TStringList = nil;
  {$ENDIF}

{ Helper Functions }

function GetUniqueFileName(const Prefix, Ext: String): String;
var
  TempPath: String;
  TempFile: String;
begin
  SetString(TempPath, nil, MAX_PATH);
  GetTempPath(Length(TempPath), PChar(TempPath));
  SetString(TempFile, nil, MAX_PATH);
  GetTempFileName(PChar(TempPath), PChar(Prefix), 0, PChar(TempFile));
  SetLength(TempFile, StrLen(PChar(TempFile)));
  Result := TempFile + Ext;
end;

function IsNonExistingFile(const Path: String): Boolean;
var
  S, E: PChar;
begin
  S := PChar(Path);
  E := S;
  Inc(E, Length(Path));
  repeat
    Dec(E);
  until (E <= S) or (E^ = ':') or (E^ = '\') or (E^ = '/') or (E^ = '.');
  Result := (E > S) and (E^ = '.') and not FileExists(Path);
end;

{$IFNDEF COMPILER5_UP}
function ExcludeTrailingBackslash(const Path: String): String;
begin
  Result := Path;
  if (Length(Result) > 0) and (Result[Length(Result)] = '\') then
    SetLength(Result, Length(Result) - 1);
end;
{$ENDIF}

{$IFDEF COMPILER4_UP}
procedure GetSpecialFolders(List: TStrings);
var
  I: Integer;
  Path: String;
begin
  List.BeginUpdate;
  try
    List.Clear;
    for I := Low(SpecialFolderIDs) to High(SpecialFolderIDs) do
    begin
      Path := GetSpecialFolderPath(SpecialFolderIDs[I]);
      if Path <> '' then
        List.AddObject(ExcludeTrailingBackslash(Path), TObject(SpecialFolderIDs[I]));
    end;
  finally
    List.EndUpdate;
  end;
end;
{$ENDIF}

{$IFDEF COMPILER4_UP}
function GetSpecialFolderPath(FolderID: Integer): String;
begin
  SetString(Result, nil, MAX_PATH);
  if SHGetSpecialFolderPath(0, PChar(Result), FolderID, False) then
    SetLength(Result, StrLen(PChar(Result)))
  else
    Result := '';
end;
{$ENDIF}

{$IFDEF COMPILER4_UP}
function GetSpecialFolderID(const Path: String): Integer;
var
  Index: Integer;
begin
  Result := -1;
  if Path <> '' then
  begin
    EnterCriticalSection(SpecialFoldersLock);
    try
      if not Assigned(SpecialFolders) then
      begin
        SpecialFolders := TStringList.Create;
        {$IFDEF COMPILER6_UP}
        SpecialFolders.CaseSensitive := False;
        {$ENDIF}
        SpecialFolders.Duplicates := dupIgnore;
        SpecialFolders.Sorted := True;
        GetSpecialFolders(SpecialFolders);
      end;
    finally
      LeaveCriticalSection(SpecialFoldersLock);
    end;
    Index := SpecialFolders.IndexOf(ExcludeTrailingBackslash(Path));
    if Index >= 0 then
      Result := Integer(SpecialFolders.Objects[Index]);
  end;
end;
{$ENDIF}

{ TCustomSysImageList }

const
  IconSizeFlags: array[TIconSize] of Word = (SHGFI_SMALLICON, SHGFI_LARGEICON);
  OpenIconFlags: array[Boolean] of Word = (0, SHGFI_OPENICON);
  IconSizeStdIDs: array[TIconSize] of Integer = (IDB_STD_SMALL_COLOR, IDB_STD_LARGE_COLOR);
  IconSizeViewIDs: array[TIconSize] of Integer = (IDB_VIEW_SMALL_COLOR, IDB_VIEW_LARGE_COLOR);
  IconSizeHistIDs: array[TIconSize] of Integer = (IDB_HIST_SMALL_COLOR, IDB_HIST_LARGE_COLOR);

constructor TSysImageList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fIconSet := isSystem;
  fIconSize := isSmallIcons;
  ShareImages := True;
  DrawingStyle := dsTransparent;
  BlendColor := clNone;
  BkColor := clNone;
  UpdateHandle;
end;

destructor TSysImageList.Destroy;
begin
  if hToolbar <> 0 then
    DestroyWindow(hToolbar);
  inherited Destroy;
end;

procedure TSysImageList.Loaded;
begin
  inherited Loaded;
  UpdateHandle;
end;

procedure TSysImageList.DefineProperties(Filer: TFiler);
begin
  Handle := 0;
  inherited DefineProperties(Filer);
  UpdateHandle;
end;

procedure TSysImageList.SetIconSet(Value: TIconSet);
begin
  if fIconSet <> Value then
  begin
    fIconSet := Value;
    UpdateHandle;
  end;
end;

procedure TSysImageList.SetIconSize(Value: TIconSize);
begin
  if fIconSize <> Value then
  begin
    fIconSize := Value;
    UpdateHandle;
  end;
end;

procedure TSysImageList.UpdateHandle;
var
  FileInfo: TShFileInfo;
  TBAddBitmap: TTBAddBitmap;
begin
  if not (csLoading in ComponentState) then
  begin
    if hToolbar <> 0 then
    begin
      DestroyWindow(hToolbar);
      hToolbar := 0;
    end;
    case IconSet of
      isSystem:
      begin
        Handle := ShGetFileInfo(PChar(ParamStr(0)), 0, FileInfo, SizeOf(FileInfo),
          IconSizeFlags[IconSize] or SHGFI_SYSICONINDEX or SHGFI_ICONLOCATION);
      end;
      isToolbar:
      begin
        hToolbar := CreateWindow(TOOLBARCLASSNAME, nil, 0, 0, 0, 0, 0, 0, 0, HInstance, nil);
        TBAddBitmap.hInst := HINST_COMMCTRL;
        TBAddBitmap.nID := IconSizeStdIDs[IconSize];
        SendMessage(hToolbar, TB_ADDBITMAP, 1000, Integer(@TBAddBitmap));
        TBAddBitmap.nID := IconSizeViewIDs[IconSize];
        SendMessage(hToolbar, TB_ADDBITMAP, 1000, Integer(@TBAddBitmap));
        TBAddBitmap.nID := IconSizeHistIDs[IconSize];
        SendMessage(hToolbar, TB_ADDBITMAP, 1000, Integer(@TBAddBitmap));
        Handle := SendMessage(hToolbar, TB_GETIMAGELIST, 0, 0);
      end;
    end;
    BkColor := clNone;
  end;
end;

function TSysImageList.ImageIndexOf(const Path: String; OpenIcon: Boolean): Integer;
var
  {$IFDEF COMPILER4_UP}
  SpecialFolderID: Integer;
  {$ENDIF}
  FileInfo: TShFileInfo;
  DesktopFolder: IShellFolder;
  PIDL: PItemIDList;
  Malloc: IMalloc;
  NumChars, Flags: {$IFDEF COMPILER4_UP} Cardinal {$ELSE} LongInt {$ENDIF};
  WidePath: PWideChar;
  FileExt: String;
  TempFileName: String;
  TempFile: THandle;
begin
  {$IFDEF COMPILER4_UP}
  // If the path is a special folder, we get its special icon
  SpecialFolderID := GetSpecialFolderID(Path);
  if SpecialFolderID <> -1 then
  begin
    Result := SpecialImageIndexOf(SpecialFolderID, OpenIcon);
    if Result >= 0 then
      Exit;
  end;
  {$ENDIF}
  Result := 0;
  if Path = '' then
    Exit;
  // Let's get Shell ID of the path. It is called PIDL.
  Flags := 0;
  WidePath := StringToOleStr(Path);
  NumChars := Length(WidePath);
  SHGetDesktopFolder(DesktopFolder);
  DesktopFolder.ParseDisplayName(0, nil, WidePath, NumChars, PIDL, Flags);
  // If PIDL is obtained, we use it for finding the image index.
  // When path is not an existing file or URL, PIDL can be null.
  if PIDL <> nil then
  begin
    FillChar(FileInfo, SizeOf(FileInfo), 0);
    ShGetFileInfo(PChar(PIDL), 0, FileInfo, SizeOf(FileInfo), SHGFI_PIDL or
      SHGFI_SYSICONINDEX or IconSizeFlags[fIconSize] or OpenIconFlags[OpenIcon]);
    if FileInfo.iIcon > 0 then
      Result := FileInfo.iIcon;
    ShGetMalloc(Malloc);
    Malloc.Free(PIDL);
    Exit;
  end;
  // if the path is not a file or file exists, we are done
  if not IsNonExistingFile(Path) then
    Exit;
  // otherwise, we try to find the image index by using the file type
  FileExt := ExtractFileExt(Path);
  FillChar(FileInfo, SizeOf(FileInfo), 0);
  ShGetFileInfo(PChar('*.' + FileExt), FILE_ATTRIBUTE_NORMAL, FileInfo,
    SizeOf(FileInfo), SHGFI_USEFILEATTRIBUTES or SHGFI_SYSICONINDEX or
    IconSizeFlags[IconSize] or OpenIconFlags[OpenIcon]);
  if FileInfo.iIcon > 0 then
  begin
    Result := FileInfo.iIcon;
    Exit;
  end;
  // If the query using the file type failed, we create a temporary file as type of our file.
  // If there is any icon associated to that type, we will get it.
  EnterCriticalSection(TempFileLock);
  try
    TempFileName := GetUniqueFileName('sil', FileExt);
    TempFile := CreateFile(PChar(TempFileName), GENERIC_WRITE, FILE_SHARE_READ,
      nil, CREATE_NEW, FILE_ATTRIBUTE_TEMPORARY, 0);
    if TempFile <> INVALID_HANDLE_VALUE then
      FileClose(TempFile);
    try
      WidePath := StringToOleStr(TempFileName);
      NumChars := Length(WidePath);
      DesktopFolder.ParseDisplayName(0, nil, WidePath, NumChars, PIDL, Flags);
      if PIDL <> nil then
      begin
        FillChar(FileInfo, SizeOf(FileInfo), 0);
        ShGetFileInfo(PChar(PIDL), 0, FileInfo, SizeOf(FileInfo), SHGFI_PIDL or
          SHGFI_SYSICONINDEX or IconSizeFlags[fIconSize] or OpenIconFlags[OpenIcon]);
        if FileInfo.iIcon > 0 then
          Result := FileInfo.iIcon;
        ShGetMalloc(Malloc);
        Malloc.Free(PIDL);
      end;
    finally
      if TempFile <> INVALID_HANDLE_VALUE then
        DeleteFile(TempFileName);
    end;
  finally
    LeaveCriticalSection(TempFileLock);
  end;
end;

function TSysImageList.SpecialImageIndexOf(FolderID: Integer; OpenIcon: Boolean): Integer;
var
  FileInfo: TShFileInfo;
  PIDL: PItemIDList;
  Malloc: IMalloc;
begin
  Result := -1;
  if Succeeded(SHGetSpecialFolderLocation(0, FolderID, PIDL)) then
  begin
    FillChar(FileInfo, SizeOf(FileInfo), 0);
    ShGetFileInfo(PChar(PIDL), 0, FileInfo, SizeOf(FileInfo), SHGFI_PIDL or
      SHGFI_SYSICONINDEX or IconSizeFlags[fIconSize] or OpenIconFlags[OpenIcon]);
    Result := FileInfo.iIcon;
    ShGetMalloc(Malloc);
    Malloc.Free(PIDL);
  end
end;

initialization
  InitializeCriticalSection(TempFileLock);
  {$IFDEF COMPILER4_UP}
  InitializeCriticalSection(SpecialFoldersLock);
  {$ENDIF}
finalization
  DeleteCriticalSection(TempFileLock);
  {$IFDEF COMPILER4_UP}
  DeleteCriticalSection(SpecialFoldersLock);
  if Assigned(SpecialFolders) then SpecialFolders.Free;
  {$ENDIF}
end.
