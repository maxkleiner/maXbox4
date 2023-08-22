unit uPSI_ShellAPI;
{
  another shell support in 3.9.3.6
  add getSystemPath
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
  TPSImport_ShellAPI = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{function SHBrowseForFolder(var lpbi: TBrowseInfo): PItemIDList; stdcall;
  far; external Shell32 name 'SHBrowseForFolder';

function SHGetPathFromIDList(pidl: PItemIDList; pszPath: LPSTR): BOOL; stdcall;
  far; external Shell32 name 'SHGetPathFromIDList';

function SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer;
  var ppidl: PItemIDList): HResult; stdcall; far; external Shell32
  name 'SHGetSpecialFolderLocation';  }
  


{ compile-time registration functions }
procedure SIRegister_ShellAPI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ShellAPI_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,ShellAPI
  ,ActiveX
  ,ShlObj , Forms;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ShellAPI]);
end;

  { TSHItemID -- Item ID }
(*type  PSHItemID = ^TSHItemID;
  TSHItemID = packed record { mkid }
    cb: Word; { Size of the ID (including cb itself) }
    abID: array [0..0] of Byte; { The item ID (variable length) }
  end;


 { TItemIDList -- List if item IDs (combined with 0-terminator) }
 PItemIDList = ^TItemIDList;
  TItemIDList = packed record { idl }
    mkid: TSHItemID;
  end; *)



function GetSystemPath(Folder: Integer): TFilename ;

{   Call this function with one of the constants declared above. }

var
    PIDL    : PItemIDList ;
    Path    : LPSTR ;
    AMalloc : IMalloc ;

begin
Path:= StrAlloc(MAX_PATH);
   SHGetSpecialFolderLocation(Application.Handle, Folder, PIDL);
if SHGetPathFromIDList (PIDL, Path) then begin
    Result:= IncludeTrailingPathDelimiter(Path);
    end else begin
      Result:= '';
    end;
   SHGetMalloc(AMalloc);
   AMalloc.Free(PIDL);
   StrDispose(Path);
   //CSIDL_COMMON_DOCUMENTS

end;

function GetSystemPath2(Folder: Integer): string;
var
  PIDL: PItemIDList;
  Path: LPSTR;
  AMalloc: IMalloc;
begin
  Path := StrAlloc(MAX_PATH);
  SHGetSpecialFolderLocation(Application.Handle, Folder, PIDL);

  if SHGetPathFromIDList(PIDL, Path) then Result := Path;

  SHGetMalloc(AMalloc);
  AMalloc.Free(PIDL);
  StrDispose(Path);
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ShellAPI(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('HDROP', 'Longint');

//    CSIDL_COMMON_DOCUMENTS              = $002e; { All Users\Documents }

 // CL.AddTypeS('PPWideChar', '^PWideChar // will not work');
 CL.AddDelphiFunction('Function DragQueryFile( Drop : HDROP; FileIndex : UINT; FileName : PChar; cb : UINT) : UINT');
 //CL.AddDelphiFunction('Function DragQueryFileA( Drop : HDROP; FileIndex : UINT; FileName : PAnsiChar; cb : UINT) : UINT');
 //CL.AddDelphiFunction('Function DragQueryFileW( Drop : HDROP; FileIndex : UINT; FileName : PWideChar; cb : UINT) : UINT');
 CL.AddDelphiFunction('Function DragQueryPoint( Drop : HDROP; var Point : TPoint) : BOOL');
 CL.AddDelphiFunction('Procedure DragFinish( Drop : HDROP)');
 CL.AddDelphiFunction('Procedure DragAcceptFiles( Wnd : HWND; Accept : BOOL)');
 CL.AddDelphiFunction('Function ShellExecute( hWnd : HWND; Operation, FileName, Parameters, Directory : PChar; ShowCmd : Integer) : HINST');
// CL.AddDelphiFunction('Function ShellExecuteA( hWnd : HWND; Operation, FileName, Parameters, Directory : PAnsiChar; ShowCmd : Integer) : HINST');
// CL.AddDelphiFunction('Function ShellExecuteW( hWnd : HWND; Operation, FileName, Parameters, Directory : PWideChar; ShowCmd : Integer) : HINST');
 CL.AddDelphiFunction('Function FindExecutable( FileName, Directory : PChar; Result : PChar) : HINST');
 //CL.AddDelphiFunction('Function FindExecutableA( FileName, Directory : PAnsiChar; Result : PAnsiChar) : HINST');
 //CL.AddDelphiFunction('Function FindExecutableW( FileName, Directory : PWideChar; Result : PWideChar) : HINST');
// CL.AddDelphiFunction('Function CommandLineToArgvW( lpCmdLine : LPCWSTR; var pNumArgs : Integer) : PPWideChar');
 CL.AddDelphiFunction('Function ShellAbout( Wnd : HWND; szApp, szOtherStuff : PChar; Icon : HICON) : Integer');
 //CL.AddDelphiFunction('Function ShellAboutA( Wnd : HWND; szApp, szOtherStuff : PAnsiChar; Icon : HICON) : Integer');
 //CL.AddDelphiFunction('Function ShellAboutW( Wnd : HWND; szApp, szOtherStuff : PWideChar; Icon : HICON) : Integer');
 CL.AddDelphiFunction('Function DuplicateIcon( hInst : HINST; Icon : HICON) : HICON');
 CL.AddDelphiFunction('Function ExtractAssociatedIcon( hInst : HINST; lpIconPath : PChar; var lpiIcon : Word) : HICON');
// CL.AddDelphiFunction('Function ExtractAssociatedIconA( hInst : HINST; lpIconPath : PAnsiChar; var lpiIcon : Word) : HICON');
 //CL.AddDelphiFunction('Function ExtractAssociatedIconW( hInst : HINST; lpIconPath : PWideChar; var lpiIcon : Word) : HICON');
 CL.AddDelphiFunction('Function ExtractIcon( hInst : HINST; lpszExeFileName : PChar; nIconIndex : UINT) : HICON');

 CL.AddDelphiFunction('function GetSystemPathSH(Folder: Integer): TFilename ;');
 CL.AddDelphiFunction('function GetSystemPath(Folder: Integer): string;');

 //CL.AddDelphiFunction('Function ExtractIconA( hInst : HINST; lpszExeFileName : PAnsiChar; nIconIndex : UINT) : HICON');
 //CL.AddDelphiFunction('Function ExtractIconW( hInst : HINST; lpszExeFileName : PWideChar; nIconIndex : UINT) : HICON');
 // CL.AddTypeS('PDragInfoA', '^_DRAGINFOA // will not work');
 // CL.AddTypeS('PDragInfoW', '^_DRAGINFOW // will not work');
  //CL.AddTypeS('PDragInfo', 'PDragInfoA');
 // CL.AddTypeS('_DRAGINFOA', 'record uSize : UINT; pt : TPoint; fNC : BOOL; lpFi'
  // +'leList : PAnsiChar; grfKeyState : DWORD; end');
 // CL.AddTypeS('TDragInfoA', '_DRAGINFOA');
  //CL.AddTypeS('LPDRAGINFOA', 'PDragInfoA');
  //CL.AddTypeS('_DRAGINFOW', 'record uSize : UINT; pt : TPoint; fNC : BOOL; lpFi'
  // +'leList : PWideChar; grfKeyState : DWORD; end');
  //CL.AddTypeS('TDragInfoW', '_DRAGINFOW');
  //CL.AddTypeS('LPDRAGINFOW', 'PDragInfoW');
  //CL.AddTypeS('_DRAGINFO', '_DRAGINFOA');
 CL.AddConstantN('ABM_NEW','LongWord').SetUInt( $00000000);
 CL.AddConstantN('ABM_REMOVE','LongWord').SetUInt( $00000001);
 CL.AddConstantN('ABM_QUERYPOS','LongWord').SetUInt( $00000002);
 CL.AddConstantN('ABM_SETPOS','LongWord').SetUInt( $00000003);
 CL.AddConstantN('ABM_GETSTATE','LongWord').SetUInt( $00000004);
 CL.AddConstantN('ABM_GETTASKBARPOS','LongWord').SetUInt( $00000005);
 CL.AddConstantN('ABM_ACTIVATE','LongWord').SetUInt( $00000006);
 CL.AddConstantN('ABM_GETAUTOHIDEBAR','LongWord').SetUInt( $00000007);
 CL.AddConstantN('ABM_SETAUTOHIDEBAR','LongWord').SetUInt( $00000008);
 CL.AddConstantN('ABM_WINDOWPOSCHANGED','LongWord').SetUInt( $0000009);
 CL.AddConstantN('ABN_STATECHANGE','LongWord').SetUInt( $0000000);
 CL.AddConstantN('ABN_POSCHANGED','LongWord').SetUInt( $0000001);
 CL.AddConstantN('ABN_FULLSCREENAPP','LongWord').SetUInt( $0000002);
 CL.AddConstantN('ABN_WINDOWARRANGE','LongWord').SetUInt( $0000003);
 CL.AddConstantN('ABS_AUTOHIDE','LongWord').SetUInt( $0000001);
 CL.AddConstantN('ABS_ALWAYSONTOP','LongWord').SetUInt( $0000002);
 CL.AddConstantN('ABE_LEFT','LongInt').SetInt( 0);
 CL.AddConstantN('ABE_TOP','LongInt').SetInt( 1);
 CL.AddConstantN('ABE_RIGHT','LongInt').SetInt( 2);
 CL.AddConstantN('ABE_BOTTOM','LongInt').SetInt( 3);
 // CL.AddTypeS('PAppBarData', '^TAppBarData // will not work');
  CL.AddTypeS('_AppBarData', 'record cbSize : DWORD; hWnd : HWND; uCallbackMess'
   +'age : UINT; uEdge : UINT; rc : TRect; lParam : LPARAM; end');
  CL.AddTypeS('TAppBarData', '_AppBarData');
  CL.AddTypeS('APPBARDATA', '_AppBarData');

  CL.AddTypeS('_SHFILEINFOA', 'record hIcon : HICON; iIcon : integer; dwAttributes'
   +' : DWORD; szDisplayName: array [0..260-1] of char; szTypeName: array [0..79] of Char; end');

  (* _SHFILEINFOA = record
    hIcon: HICON;                      { out: icon }
    iIcon: Integer;                    { out: icon index }
    dwAttributes: DWORD;               { out: SFGAO_ flags }
    szDisplayName: array [0..260-1] of  AnsiChar; { out: display name (or path) }
    szTypeName: array [0..79] of AnsiChar;             { out: type name }
  end;*)


   //TSHFileInfo = TSHFileInfoA;
   //TSHFileInfoA = _SHFILEINFOA;
   CL.AddTypeS('TSHFileInfoA','_SHFILEINFOA');

   CL.AddTypeS('TSHFileInfo','TSHFileInfoA');
   //SHFILEINFOA = _SHFILEINFOA;
  CL.AddTypeS('SHFILEINFOA','_SHFILEINFOA');
  CL.AddTypeS('SHFILEINFO','SHFILEINFOA');

 CL.AddDelphiFunction('Function SHAppBarMessage( dwMessage : DWORD; var pData : TAppBarData) : UINT');
 CL.AddDelphiFunction('Function DoEnvironmentSubst( szString : PChar; cbString : UINT) : DWORD');
 //CL.AddDelphiFunction('Function DoEnvironmentSubstA( szString : PAnsiChar; cbString : UINT) : DWORD');
 //CL.AddDelphiFunction('Function DoEnvironmentSubstW( szString : PWideChar; cbString : UINT) : DWORD');
 CL.AddDelphiFunction('Function ExtractIconEx( lpszFile : PChar; nIconIndex : Integer; var phiconLarge, phiconSmall : HICON; nIcons : UINT) : UINT');
 //CL.AddDelphiFunction('Function ExtractIconExA( lpszFile : PAnsiChar; nIconIndex : Integer; var phiconLarge, phiconSmall : HICON; nIcons : UINT) : UINT');
 //CL.AddDelphiFunction('Function ExtractIconExW( lpszFile : PWideChar; nIconIndex : Integer; var phiconLarge, phiconSmall : HICON; nIcons : UINT) : UINT');
 CL.AddConstantN('FO_MOVE','LongWord').SetUInt( $0001);
 CL.AddConstantN('FO_COPY','LongWord').SetUInt( $0002);
 CL.AddConstantN('FO_DELETE','LongWord').SetUInt( $0003);
 CL.AddConstantN('FO_RENAME','LongWord').SetUInt( $0004);
 CL.AddConstantN('FOF_MULTIDESTFILES','LongWord').SetUInt( $0001);
 CL.AddConstantN('FOF_CONFIRMMOUSE','LongWord').SetUInt( $0002);
 CL.AddConstantN('FOF_SILENT','LongWord').SetUInt( $0004);
 CL.AddConstantN('FOF_RENAMEONCOLLISION','LongWord').SetUInt( $0008);
 CL.AddConstantN('FOF_NOCONFIRMATION','LongWord').SetUInt( $0010);
 CL.AddConstantN('FOF_WANTMAPPINGHANDLE','LongWord').SetUInt( $0020);
 CL.AddConstantN('FOF_ALLOWUNDO','LongWord').SetUInt( $0040);
 CL.AddConstantN('FOF_FILESONLY','LongWord').SetUInt( $0080);
 CL.AddConstantN('FOF_SIMPLEPROGRESS','LongWord').SetUInt( $0100);
 CL.AddConstantN('FOF_NOCONFIRMMKDIR','LongWord').SetUInt( $0200);
 CL.AddConstantN('FOF_NOERRORUI','LongWord').SetUInt( $0400);
  CL.AddTypeS('FILEOP_FLAGS', 'Word');
 CL.AddConstantN('PO_DELETE','LongWord').SetUInt( $0013);
 CL.AddConstantN('PO_RENAME','LongWord').SetUInt( $0014);
 CL.AddConstantN('PO_PORTCHANGE','LongWord').SetUInt( $0020);
 CL.AddConstantN('PO_REN_PORT','LongWord').SetUInt( $0034);
  CL.AddTypeS('PRINTEROP_FLAGS', 'Word');
 // CL.AddTypeS('PSHFileOpStructA', '^TSHFileOpStructA // will not work');
 // CL.AddTypeS('PSHFileOpStructW', '^TSHFileOpStructW // will not work');
  //CL.AddTypeS('PSHFileOpStruct', 'PSHFileOpStructA');
  (*CL.AddTypeS('_SHFILEOPSTRUCTA', 'record Wnd : HWND; wFunc : UINT; pFrom : PAn'
   +'siChar; pTo : PAnsiChar; fFlags : FILEOP_FLAGS; fAnyOperationsAborted : BO'
   +'OL; hNameMappings : Pointer; lpszProgressTitle : PAnsiChar; end');
  CL.AddTypeS('_SHFILEOPSTRUCTW', 'record Wnd : HWND; wFunc : UINT; pFrom : PWi'
   +'deChar; pTo : PWideChar; fFlags : FILEOP_FLAGS; fAnyOperationsAborted : BO'
   +'OL; hNameMappings : Pointer; lpszProgressTitle : PWideChar; end');*)
 (* CL.AddTypeS('_SHFILEOPSTRUCT', '_SHFILEOPSTRUCTA');
  CL.AddTypeS('TSHFileOpStructA', '_SHFILEOPSTRUCTA');
  CL.AddTypeS('TSHFileOpStructW', '_SHFILEOPSTRUCTW');
  CL.AddTypeS('TSHFileOpStruct', 'TSHFileOpStructA');
  CL.AddTypeS('SHFILEOPSTRUCTA', '_SHFILEOPSTRUCTA');
  CL.AddTypeS('SHFILEOPSTRUCTW', '_SHFILEOPSTRUCTW');
  CL.AddTypeS('SHFILEOPSTRUCT', 'SHFILEOPSTRUCTA');
 CL.AddDelphiFunction('Function SHFileOperation( const lpFileOp : TSHFileOpStruct) : Integer');
 CL.AddDelphiFunction('Function SHFileOperationA( const lpFileOp : TSHFileOpStructA) : Integer');
 CL.AddDelphiFunction('Function SHFileOperationW( const lpFileOp : TSHFileOpStructW) : Integer'); *)
 CL.AddDelphiFunction('Procedure SHFreeNameMappings( hNameMappings : THandle)');
 // CL.AddTypeS('PSHNameMappingA', '^TSHNameMappingA // will not work');
 // CL.AddTypeS('PSHNameMappingW', '^TSHNameMappingW // will not work');
  (*CL.AddTypeS('PSHNameMapping', 'PSHNameMappingA');
  CL.AddTypeS('_SHNAMEMAPPINGA', 'record pszOldPath : PAnsiChar; pszNewPath : P'
   +'AnsiChar; cchOldPath : Integer; cchNewPath : Integer; end');
  CL.AddTypeS('_SHNAMEMAPPINGW', 'record pszOldPath : PWideChar; pszNewPath : P'
   +'WideChar; cchOldPath : Integer; cchNewPath : Integer; end');
  CL.AddTypeS('_SHNAMEMAPPING', '_SHNAMEMAPPINGA');
  CL.AddTypeS('TSHNameMappingA', '_SHNAMEMAPPINGA');
  CL.AddTypeS('TSHNameMappingW', '_SHNAMEMAPPINGW');
  CL.AddTypeS('TSHNameMapping', 'TSHNameMappingA');
  CL.AddTypeS('SHNAMEMAPPINGA', '_SHNAMEMAPPINGA');
  CL.AddTypeS('SHNAMEMAPPINGW', '_SHNAMEMAPPINGW');
  CL.AddTypeS('SHNAMEMAPPING', 'SHNAMEMAPPINGA');  *)
 CL.AddConstantN('SE_ERR_FNF','LongInt').SetInt( 2);
 CL.AddConstantN('SE_ERR_PNF','LongInt').SetInt( 3);
 CL.AddConstantN('SE_ERR_ACCESSDENIED','LongInt').SetInt( 5);
 CL.AddConstantN('SE_ERR_OOM','LongInt').SetInt( 8);
 CL.AddConstantN('SE_ERR_DLLNOTFOUND','LongInt').SetInt( 32);
 CL.AddConstantN('SE_ERR_SHARE','LongInt').SetInt( 26);
 CL.AddConstantN('SE_ERR_ASSOCINCOMPLETE','LongInt').SetInt( 27);
 CL.AddConstantN('SE_ERR_DDETIMEOUT','LongInt').SetInt( 28);
 CL.AddConstantN('SE_ERR_DDEFAIL','LongInt').SetInt( 29);
 CL.AddConstantN('SE_ERR_DDEBUSY','LongInt').SetInt( 30);
 CL.AddConstantN('SE_ERR_NOASSOC','LongInt').SetInt( 31);
 CL.AddConstantN('SEE_MASK_CLASSNAME','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SEE_MASK_CLASSKEY','LongWord').SetUInt( $00000003);
 CL.AddConstantN('SEE_MASK_IDLIST','LongWord').SetUInt( $00000004);
 CL.AddConstantN('SEE_MASK_INVOKEIDLIST','LongWord').SetUInt( $0000000c);
 CL.AddConstantN('SEE_MASK_ICON','LongWord').SetUInt( $00000010);
 CL.AddConstantN('SEE_MASK_HOTKEY','LongWord').SetUInt( $00000020);
 CL.AddConstantN('SEE_MASK_NOCLOSEPROCESS','LongWord').SetUInt( $00000040);
 CL.AddConstantN('SEE_MASK_CONNECTNETDRV','LongWord').SetUInt( $00000080);
 CL.AddConstantN('SEE_MASK_FLAG_DDEWAIT','LongWord').SetUInt( $00000100);
 CL.AddConstantN('SEE_MASK_DOENVSUBST','LongWord').SetUInt( $00000200);
 CL.AddConstantN('SEE_MASK_FLAG_NO_UI','LongWord').SetUInt( $00000400);
 CL.AddConstantN('SEE_MASK_UNICODE','LongWord').SetUInt( $00010000);
 CL.AddConstantN('SEE_MASK_NO_CONSOLE','LongWord').SetUInt( $00008000);
 CL.AddConstantN('SEE_MASK_ASYNCOK','LongWord').SetUInt( $00100000);
  //CL.AddTypeS('PShellExecuteInfoA', '^TShellExecuteInfoA // will not work');
  //CL.AddTypeS('PShellExecuteInfoW', '^TShellExecuteInfoW // will not work');
  //CL.AddTypeS('PShellExecuteInfo', 'PShellExecuteInfoA');
  (*CL.AddTypeS('_SHELLEXECUTEINFOA', 'record cbSize : DWORD; fMask : ULONG; Wnd '
   +': HWND; lpVerb : PAnsiChar; lpFile : PAnsiChar; lpParameters : PAnsiChar; '
   +'lpDirectory : PAnsiChar; nShow : Integer; hInstApp : HINST; lpIDList : Poi'
   +'nter; lpClass : PAnsiChar; hkeyClass : HKEY; dwHotKey : DWORD; hIcon : THa'
   +'ndle; hProcess : THandle; end');
  CL.AddTypeS('_SHELLEXECUTEINFOW', 'record cbSize : DWORD; fMask : ULONG; Wnd '
   +': HWND; lpVerb : PWideChar; lpFile : PWideChar; lpParameters : PWideChar; '
   +'lpDirectory : PWideChar; nShow : Integer; hInstApp : HINST; lpIDList : Poi'
   +'nter; lpClass : PWideChar; hkeyClass : HKEY; dwHotKey : DWORD; hIcon : THa'
   +'ndle; hProcess : THandle; end');
  CL.AddTypeS('_SHELLEXECUTEINFO', '_SHELLEXECUTEINFOA');
  CL.AddTypeS('TShellExecuteInfoA', '_SHELLEXECUTEINFOA');
  CL.AddTypeS('TShellExecuteInfoW', '_SHELLEXECUTEINFOW');
  CL.AddTypeS('TShellExecuteInfo', 'TShellExecuteInfoA');
  CL.AddTypeS('SHELLEXECUTEINFOA', '_SHELLEXECUTEINFOA');
  CL.AddTypeS('SHELLEXECUTEINFOW', '_SHELLEXECUTEINFOW');
  CL.AddTypeS('SHELLEXECUTEINFO', 'SHELLEXECUTEINFOA');
 CL.AddDelphiFunction('Function ShellExecuteEx( lpExecInfo : PShellExecuteInfo) : BOOL');
 CL.AddDelphiFunction('Function ShellExecuteExA( lpExecInfo : PShellExecuteInfoA) : BOOL');
 CL.AddDelphiFunction('Function ShellExecuteExW( lpExecInfo : PShellExecuteInfoW) : BOOL');  *)
 // CL.AddTypeS('PNotifyIconDataA', '^TNotifyIconDataA // will not work');
 // CL.AddTypeS('PNotifyIconDataW', '^TNotifyIconDataW // will not work');
//  CL.AddTypeS('PNotifyIconData', 'PNotifyIconDataA');
 (* CL.AddTypeS('_NOTIFYICONDATA', '_NOTIFYICONDATAA');
  CL.AddTypeS('TNotifyIconDataA', '_NOTIFYICONDATAA');
  CL.AddTypeS('TNotifyIconDataW', '_NOTIFYICONDATAW');
  CL.AddTypeS('TNotifyIconData', 'TNotifyIconDataA');
  CL.AddTypeS('NOTIFYICONDATAA', '_NOTIFYICONDATAA');
  CL.AddTypeS('NOTIFYICONDATAW', '_NOTIFYICONDATAW');
  CL.AddTypeS('NOTIFYICONDATA', 'NOTIFYICONDATAA');*)
 CL.AddConstantN('NIM_ADD','LongWord').SetUInt( $00000000);
 CL.AddConstantN('NIM_MODIFY','LongWord').SetUInt( $00000001);
 CL.AddConstantN('NIM_DELETE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('NIM_SETFOCUS','LongWord').SetUInt( $00000003);
 CL.AddConstantN('NIM_SETVERSION','LongWord').SetUInt( $00000004);
 CL.AddConstantN('NIF_MESSAGE','LongWord').SetUInt( $00000001);
 CL.AddConstantN('NIF_ICON','LongWord').SetUInt( $00000002);
 CL.AddConstantN('NIF_TIP','LongWord').SetUInt( $00000004);
 CL.AddConstantN('NIF_STATE','LongWord').SetUInt( $00000008);
 CL.AddConstantN('NIF_INFO','LongWord').SetUInt( $00000010);
 CL.AddConstantN('NIIF_NONE','LongWord').SetUInt( $00000000);
 CL.AddConstantN('NIIF_INFO','LongWord').SetUInt( $00000001);
 CL.AddConstantN('NIIF_WARNING','LongWord').SetUInt( $00000002);
 CL.AddConstantN('NIIF_ERROR','LongWord').SetUInt( $00000003);
 CL.AddConstantN('NIIF_ICON_MASK','LongWord').SetUInt( $0000000F);
 CL.AddConstantN('NIN_SELECT','LongWord').SetUInt( $0400);
 CL.AddConstantN('NINF_KEY','LongWord').SetUInt( $1);
 CL.AddConstantN('NIN_BALLOONSHOW','LongInt').SetInt( $0400 + 2);
 CL.AddConstantN('NIN_BALLOONHIDE','LongInt').SetInt( $0400 + 3);
 CL.AddConstantN('NIN_BALLOONTIMEOUT','LongInt').SetInt( $0400 + 4);
 CL.AddConstantN('NIN_BALLOONUSERCLICK','LongInt').SetInt( $0400 + 5);
// CL.AddDelphiFunction('Function Shell_NotifyIcon( dwMessage : DWORD; lpData : PNotifyIconData) : BOOL');
 //CL.AddDelphiFunction('Function Shell_NotifyIconA( dwMessage : DWORD; lpData : PNotifyIconDataA) : BOOL');
// CL.AddDelphiFunction('Function Shell_NotifyIconW( dwMessage : DWORD; lpData : PNotifyIconDataW) : BOOL');
  //CL.AddTypeS('PSHFileInfoA', '^TSHFileInfoA // will not work');
 // CL.AddTypeS('PSHFileInfoW', '^TSHFileInfoW // will not work');
  (*CL.AddTypeS('PSHFileInfo', 'PSHFileInfoA');
  CL.AddTypeS('_SHFILEINFO', '_SHFILEINFOA');
  CL.AddTypeS('TSHFileInfoA', '_SHFILEINFOA');
  CL.AddTypeS('TSHFileInfoW', '_SHFILEINFOW');
  CL.AddTypeS('TSHFileInfo', 'TSHFileInfoA');
  CL.AddTypeS('SHFILEINFOA', '_SHFILEINFOA');
  CL.AddTypeS('SHFILEINFOW', '_SHFILEINFOW');
  CL.AddTypeS('SHFILEINFO', 'SHFILEINFOA');*)
 CL.AddConstantN('SHGFI_ICON','LongWord').SetUInt( $000000100);
 CL.AddConstantN('SHGFI_DISPLAYNAME','LongWord').SetUInt( $000000200);
 CL.AddConstantN('SHGFI_TYPENAME','LongWord').SetUInt( $000000400);
 CL.AddConstantN('SHGFI_ATTRIBUTES','LongWord').SetUInt( $000000800);
 CL.AddConstantN('SHGFI_ICONLOCATION','LongWord').SetUInt( $000001000);
 CL.AddConstantN('SHGFI_EXETYPE','LongWord').SetUInt( $000002000);
 CL.AddConstantN('SHGFI_SYSICONINDEX','LongWord').SetUInt( $000004000);
 CL.AddConstantN('SHGFI_LINKOVERLAY','LongWord').SetUInt( $000008000);
 CL.AddConstantN('SHGFI_SELECTED','LongWord').SetUInt( $000010000);
 CL.AddConstantN('SHGFI_LARGEICON','LongWord').SetUInt( $000000000);
 CL.AddConstantN('SHGFI_SMALLICON','LongWord').SetUInt( $000000001);
 CL.AddConstantN('SHGFI_OPENICON','LongWord').SetUInt( $000000002);
 CL.AddConstantN('SHGFI_SHELLICONSIZE','LongWord').SetUInt( $000000004);
 CL.AddConstantN('SHGFI_PIDL','LongWord').SetUInt( $000000008);
 CL.AddConstantN('SHGFI_USEFILEATTRIBUTES','LongWord').SetUInt( $000000010);

 //CL.AddConstantN('CSIDL_COMMON_DOCUMENTS','LongWord').SetUInt($002e);

 CL.AddDelphiFunction('Function SHGetFileInfo( pszPath : PChar; dwFileAttributes : DWORD; var psfi : TSHFileInfo; cbFileInfo, uFlags : UINT) : DWORD');
 //CL.AddDelphiFunction('Function SHGetFileInfoA( pszPath : PAnsiChar; dwFileAttributes : DWORD; var psfi : TSHFileInfoA; cbFileInfo, uFlags : UINT) : DWORD');
 //CL.AddDelphiFunction('Function SHGetFileInfoW( pszPath : PAnsiChar; dwFileAttributes : DWORD; var psfi : TSHFileInfoW; cbFileInfo, uFlags : UINT) : DWORD');
 CL.AddConstantN('SHGNLI_PIDL','LongWord').SetUInt( $000000001);
 CL.AddConstantN('SHGNLI_PREFIXNAME','LongWord').SetUInt( $000000002);
 CL.AddConstantN('SHGNLI_NOUNIQUE','LongWord').SetUInt( $000000004);
 CL.AddConstantN('shell32','String').SetString( 'shell32.dll');
 CL.AddConstantN('shell32linux','String').SetString( 'libshell32.borland.so');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ShellAPI_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DragQueryFile, 'DragQueryFile', CdStdCall);
 //S.RegisterDelphiFunction(@DragQueryFileA, 'DragQueryFileA', CdStdCall);
 //S.RegisterDelphiFunction(@DragQueryFileW, 'DragQueryFileW', CdStdCall);
 S.RegisterDelphiFunction(@DragQueryPoint, 'DragQueryPoint', CdStdCall);
 S.RegisterDelphiFunction(@DragFinish, 'DragFinish', CdStdCall);
 S.RegisterDelphiFunction(@DragAcceptFiles, 'DragAcceptFiles', CdStdCall);
 S.RegisterDelphiFunction(@ShellExecute, 'ShellExecute', CdStdCall);
 //S.RegisterDelphiFunction(@ShellExecuteA, 'ShellExecuteA', CdStdCall);
 //S.RegisterDelphiFunction(@ShellExecuteW, 'ShellExecuteW', CdStdCall);
 S.RegisterDelphiFunction(@FindExecutable, 'FindExecutable', CdStdCall);
 //S.RegisterDelphiFunction(@FindExecutableA, 'FindExecutableA', CdStdCall);
 //S.RegisterDelphiFunction(@FindExecutableW, 'FindExecutableW', CdStdCall);
 S.RegisterDelphiFunction(@CommandLineToArgvW, 'CommandLineToArgvW', CdStdCall);
 S.RegisterDelphiFunction(@ShellAbout, 'ShellAbout', CdStdCall);
// S.RegisterDelphiFunction(@ShellAboutA, 'ShellAboutA', CdStdCall);
// S.RegisterDelphiFunction(@ShellAboutW, 'ShellAboutW', CdStdCall);
 S.RegisterDelphiFunction(@DuplicateIcon, 'DuplicateIcon', CdStdCall);
 S.RegisterDelphiFunction(@ExtractAssociatedIcon, 'ExtractAssociatedIcon', CdStdCall);
// S.RegisterDelphiFunction(@ExtractAssociatedIconA, 'ExtractAssociatedIconA', CdStdCall);
// S.RegisterDelphiFunction(@ExtractAssociatedIconW, 'ExtractAssociatedIconW', CdStdCall);
 S.RegisterDelphiFunction(@ExtractIcon, 'ExtractIcon', CdStdCall);
 //S.RegisterDelphiFunction(@ExtractIconA, 'ExtractIconA', CdStdCall);
 //S.RegisterDelphiFunction(@ExtractIconW, 'ExtractIconW', CdStdCall);
 S.RegisterDelphiFunction(@SHAppBarMessage, 'SHAppBarMessage', CdStdCall);
 S.RegisterDelphiFunction(@DoEnvironmentSubst, 'DoEnvironmentSubst', CdStdCall);
 S.RegisterDelphiFunction(@DoEnvironmentSubstA, 'DoEnvironmentSubstA', CdStdCall);
 S.RegisterDelphiFunction(@DoEnvironmentSubstW, 'DoEnvironmentSubstW', CdStdCall);
 S.RegisterDelphiFunction(@ExtractIconEx, 'ExtractIconEx', CdStdCall);
 //S.RegisterDelphiFunction(@ExtractIconExA, 'ExtractIconExA', CdStdCall);
 //S.RegisterDelphiFunction(@ExtractIconExW, 'ExtractIconExW', CdStdCall);
 S.RegisterDelphiFunction(@SHFileOperation, 'SHFileOperation', CdStdCall);
 //S.RegisterDelphiFunction(@SHFileOperationA, 'SHFileOperationA', CdStdCall);
 //S.RegisterDelphiFunction(@SHFileOperationW, 'SHFileOperationW', CdStdCall);
 S.RegisterDelphiFunction(@SHFreeNameMappings, 'SHFreeNameMappings', CdStdCall);
 S.RegisterDelphiFunction(@ShellExecuteEx, 'ShellExecuteEx', CdStdCall);
 //S.RegisterDelphiFunction(@ShellExecuteExA, 'ShellExecuteExA', CdStdCall);
 //S.RegisterDelphiFunction(@ShellExecuteExW, 'ShellExecuteExW', CdStdCall);
 S.RegisterDelphiFunction(@Shell_NotifyIcon, 'Shell_NotifyIcon', CdStdCall);
 //S.RegisterDelphiFunction(@Shell_NotifyIconA, 'Shell_NotifyIconA', CdStdCall);
 //S.RegisterDelphiFunction(@Shell_NotifyIconW, 'Shell_NotifyIconW', CdStdCall);
 S.RegisterDelphiFunction(@SHGetFileInfo, 'SHGetFileInfo', CdStdCall);
 S.RegisterDelphiFunction(@GetSystemPath, 'GetSystemPathSH', CdStdCall);
 S.RegisterDelphiFunction(@GetSystemPath2, 'GetSystemPath', CdStdCall);

 S.RegisterDelphiFunction(@SHGetFileInfoA, 'SHGetFileInfoA', CdStdCall);
 S.RegisterDelphiFunction(@SHGetFileInfoA, 'SHGetFileInfo', CdStdCall);

 //S.RegisterDelphiFunction(@SHGetFileInfoW, 'SHGetFileInfoW', CdStdCall);
end;

 
 
{ TPSImport_ShellAPI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ShellAPI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ShellAPI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ShellAPI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ShellAPI(ri);
  RIRegister_ShellAPI_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
