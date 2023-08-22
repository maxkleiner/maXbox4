unit uPSI_JclShell;
{
  another shell in a shell  ASIAS
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
  TPSImport_JclShell = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclShell(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclShell_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,ShlObj
  ,JclBase
  ,JclWin32
  ,JclShell
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclShell]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclShell(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TSHDeleteOption', '( doSilent, doAllowUndo, doFilesOnly )');
  CL.AddTypeS('TSHDeleteOptions', 'set of TSHDeleteOption');
  CL.AddTypeS('TSHRenameOption', '( roSilent, roRenameOnCollision )');
  CL.AddTypeS('TSHRenameOptions', 'set of TSHRenameOption');
 CL.AddDelphiFunction('Function SHDeleteFiles( Parent : HWND; const Files : string; Options : TSHDeleteOptions) : Boolean');
 CL.AddDelphiFunction('Function SHDeleteFolder( Parent : HWND; const Folder : string; Options : TSHDeleteOptions) : Boolean');
 CL.AddDelphiFunction('Function SHRenameFile( const Src, Dest : string; Options : TSHRenameOptions) : Boolean');
  CL.AddTypeS('TEnumFolderFlag', '( efFolders, efNonFolders, efIncludeHidden )');
  CL.AddTypeS('TEnumFolderFlags', 'set of TEnumFolderFlag');
  //CL.AddTypeS('TEnumFolderRec', 'record DisplayName : string; Attributes : DWOR'
   //+'D; IconLarge : HICON; IconSmall : HICON; Item : PItemIdList; EnumIdList : '
   //+'IEnumIdList; Folder : IShellFolder; end');
// CL.AddDelphiFunction('Function SHEnumFolderFirst( const Folder : string; Flags : TEnumFolderFlags; var F : TEnumFolderRec) : Boolean');
 //CL.AddDelphiFunction('Function SHEnumSpecialFolderFirst( SpecialFolder : DWORD; Flags : TEnumFolderFlags; var F : TEnumFolderRec) : Boolean');
 //CL.AddDelphiFunction('Procedure SHEnumFolderClose( var F : TEnumFolderRec)');
 //CL.AddDelphiFunction('Function SHEnumFolderNext( var F : TEnumFolderRec) : Boolean');
 CL.AddDelphiFunction('Function GetSpecialFolderLocation( const Folder : Integer) : string');
 CL.AddDelphiFunction('Function DisplayPropDialog( const Handle : HWND; const FileName : string) : Boolean;');
 //CL.AddDelphiFunction('Function DisplayPropDialog1( const Handle : HWND; const Item : PItemIdList) : Boolean;');
// CL.AddDelphiFunction('Function DisplayContextMenuPidl( const Handle : HWND; const Folder : IShellFolder; Item : PItemIdList; Pos : TPoint) : Boolean');
 CL.AddDelphiFunction('Function DisplayContextMenu( const Handle : HWND; const FileName : string; Pos : TPoint) : Boolean');
 CL.AddDelphiFunction('Function OpenFolder( const Path : string; Parent : HWND) : Boolean');
 CL.AddDelphiFunction('Function OpenSpecialFolder( FolderID : Integer; Parent : HWND) : Boolean');
 CL.AddDelphiFunction('Function SHReallocMem( var P : ___Pointer; Count : Integer) : Boolean');
 CL.AddDelphiFunction('Function SHAllocMem( out P : ___Pointer; Count : Integer) : Boolean');
 CL.AddDelphiFunction('Function SHGetMem( var P : ___Pointer; Count : Integer) : Boolean');
 CL.AddDelphiFunction('Function SHFreeMem( var P : ___Pointer) : Boolean');
 //CL.AddDelphiFunction('Function DriveToPidlBind( const DriveName : string; out Folder : IShellFolder) : PItemIdList');
 //CL.AddDelphiFunction('Function PathToPidl( const Path : string; Folder : IShellFolder) : PItemIdList');
 //CL.AddDelphiFunction('Function PathToPidlBind( const FileName : string; out Folder : IShellFolder) : PItemIdList');
 //CL.AddDelphiFunction('Function PidlBindToParent( const IdList : PItemIdList; out Folder : IShellFolder; out Last : PItemIdList) : Boolean');
 //CL.AddDelphiFunction('Function PidlCompare( const Pidl1, Pidl2 : PItemIdList) : Boolean');
 //CL.AddDelphiFunction('Function PidlCopy( const Source : PItemIdList; out Dest : PItemIdList) : Boolean');
 //CL.AddDelphiFunction('Function PidlFree( var IdList : PItemIdList) : Boolean');
 //CL.AddDelphiFunction('Function PidlGetDepth( const Pidl : PItemIdList) : Integer');
 //CL.AddDelphiFunction('Function PidlGetLength( const Pidl : PItemIdList) : Integer');
 //CL.AddDelphiFunction('Function PidlGetNext( const Pidl : PItemIdList) : PItemIdList');
 //CL.AddDelphiFunction('Function PidlToPath( IdList : PItemIdList) : string');
 //CL.AddDelphiFunction('Function StrRetFreeMem( StrRet : TStrRet) : Boolean');
 //CL.AddDelphiFunction('Function StrRetToString( IdList : PItemIdList; StrRet : TStrRet; Free : Boolean) : string');
  //CL.AddTypeS('PShellLink', '^TShellLink // will not work');
  //CL.AddTypeS('TShellLink', 'record Arguments : string; ShowCmd : Integer; Work'
  // +'ingDirectory : string; IdList : PItemIDList; Target : string; Description '
  // +': string; IconLocation : string; IconIndex : Integer; HotKey : Word; end');
 //CL.AddDelphiFunction('Procedure ShellLinkFree( var Link : TShellLink)');
// CL.AddDelphiFunction('Function ShellLinkResolve( const FileName : string; var Link : TShellLink) : HRESULT');
 //CL.AddDelphiFunction('Function ShellLinkCreate( const Link : TShellLink; const FileName : string) : HRESULT');
 //CL.AddDelphiFunction('Function ShellLinkCreateSystem( const Link : TShellLink; const Folder : Integer; const FileName : string) : HRESULT');
 //CL.AddDelphiFunction('Function ShellLinkGetIcon( const Link : TShellLink; const Icon : TIcon) : Boolean');
 //CL.AddDelphiFunction('Function SHDllGetVersion( const FileName : string; var Version : TDllVersionInfo) : Boolean');
 CL.AddDelphiFunction('Function GetSystemIcon( IconIndex : Integer; Flags : Cardinal) : HICON');
 CL.AddDelphiFunction('Function OverlayIcon( var Icon : HICON; Overlay : HICON; Large : Boolean) : Boolean');
 CL.AddDelphiFunction('Function OverlayIconShortCut( var Large, Small : HICON) : Boolean');
 CL.AddDelphiFunction('Function OverlayIconShared( var Large, Small : HICON) : Boolean');
 //CL.AddDelphiFunction('Function SHGetItemInfoTip( const Folder : IShellFolder; Item : PItemIdList) : string');
 CL.AddDelphiFunction('Function ShellExecEx( const FileName : string; const Parameters : string; const Verb : string; CmdShow : Integer) : Boolean');
 CL.AddDelphiFunction('Function ShellExec( Wnd : Integer; const Operation, FileName, Parameters, Directory : string; ShowCommand : Integer) : Boolean');
 CL.AddDelphiFunction('Function ShellExecAndWait( const FileName : string; const Parameters : string; const Verb : string; CmdShow : Integer) : Boolean');
 CL.AddDelphiFunction('Function ShellOpenAs( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function ShellRasDial( const EntryName : string) : Boolean');
 CL.AddDelphiFunction('Function ShellRunControlPanel( const NameOrFileName : string; AppletNumber : Integer) : Boolean');
 CL.AddDelphiFunction('Function GetFileNameIcon( const FileName : string; Flags : Cardinal) : HICON');
  CL.AddTypeS('TJclFileExeType', '( etError, etMsDos, etWin16, etWin32Gui, etWin32Con )');
 CL.AddDelphiFunction('Function GetFileExeType( const FileName : TFileName) : TJclFileExeType');
 CL.AddDelphiFunction('Function ShellFindExecutable( const FileName, DefaultDir : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function DisplayPropDialog1_P( const Handle : HWND; const Item : PItemIdList) : Boolean;
Begin Result := JclShell.DisplayPropDialog(Handle, Item); END;

(*----------------------------------------------------------------------------*)
Function DisplayPropDialog_P( const Handle : HWND; const FileName : string) : Boolean;
Begin Result := JclShell.DisplayPropDialog(Handle, FileName); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclShell_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SHDeleteFiles, 'SHDeleteFiles', cdRegister);
 S.RegisterDelphiFunction(@SHDeleteFolder, 'SHDeleteFolder', cdRegister);
 S.RegisterDelphiFunction(@SHRenameFile, 'SHRenameFile', cdRegister);
 S.RegisterDelphiFunction(@SHEnumFolderFirst, 'SHEnumFolderFirst', cdRegister);
 S.RegisterDelphiFunction(@SHEnumSpecialFolderFirst, 'SHEnumSpecialFolderFirst', cdRegister);
 S.RegisterDelphiFunction(@SHEnumFolderClose, 'SHEnumFolderClose', cdRegister);
 S.RegisterDelphiFunction(@SHEnumFolderNext, 'SHEnumFolderNext', cdRegister);
 S.RegisterDelphiFunction(@GetSpecialFolderLocation, 'GetSpecialFolderLocation', cdRegister);
 S.RegisterDelphiFunction(@DisplayPropDialog, 'DisplayPropDialog', cdRegister);
 S.RegisterDelphiFunction(@DisplayPropDialog1_P, 'DisplayPropDialog1', cdRegister);
 S.RegisterDelphiFunction(@DisplayContextMenuPidl, 'DisplayContextMenuPidl', cdRegister);
 S.RegisterDelphiFunction(@DisplayContextMenu, 'DisplayContextMenu', cdRegister);
 S.RegisterDelphiFunction(@OpenFolder, 'OpenFolder', cdRegister);
 S.RegisterDelphiFunction(@OpenSpecialFolder, 'OpenSpecialFolder', cdRegister);
 S.RegisterDelphiFunction(@SHReallocMem, 'SHReallocMem', cdRegister);
 S.RegisterDelphiFunction(@SHAllocMem, 'SHAllocMem', cdRegister);
 S.RegisterDelphiFunction(@SHGetMem, 'SHGetMem', cdRegister);
 S.RegisterDelphiFunction(@SHFreeMem, 'SHFreeMem', cdRegister);
 S.RegisterDelphiFunction(@DriveToPidlBind, 'DriveToPidlBind', cdRegister);
 S.RegisterDelphiFunction(@PathToPidl, 'PathToPidl', cdRegister);
 S.RegisterDelphiFunction(@PathToPidlBind, 'PathToPidlBind', cdRegister);
 S.RegisterDelphiFunction(@PidlBindToParent, 'PidlBindToParent', cdRegister);
 S.RegisterDelphiFunction(@PidlCompare, 'PidlCompare', cdRegister);
 S.RegisterDelphiFunction(@PidlCopy, 'PidlCopy', cdRegister);
 S.RegisterDelphiFunction(@PidlFree, 'PidlFree', cdRegister);
 S.RegisterDelphiFunction(@PidlGetDepth, 'PidlGetDepth', cdRegister);
 S.RegisterDelphiFunction(@PidlGetLength, 'PidlGetLength', cdRegister);
 S.RegisterDelphiFunction(@PidlGetNext, 'PidlGetNext', cdRegister);
 S.RegisterDelphiFunction(@PidlToPath, 'PidlToPath', cdRegister);
 S.RegisterDelphiFunction(@StrRetFreeMem, 'StrRetFreeMem', cdRegister);
 S.RegisterDelphiFunction(@StrRetToString, 'StrRetToString', cdRegister);
 S.RegisterDelphiFunction(@ShellLinkFree, 'ShellLinkFree', cdRegister);
 S.RegisterDelphiFunction(@ShellLinkResolve, 'ShellLinkResolve', cdRegister);
 S.RegisterDelphiFunction(@ShellLinkCreate, 'ShellLinkCreate', cdRegister);
 S.RegisterDelphiFunction(@ShellLinkCreateSystem, 'ShellLinkCreateSystem', cdRegister);
 S.RegisterDelphiFunction(@ShellLinkGetIcon, 'ShellLinkGetIcon', cdRegister);
 S.RegisterDelphiFunction(@SHDllGetVersion, 'SHDllGetVersion', cdRegister);
 S.RegisterDelphiFunction(@GetSystemIcon, 'GetSystemIcon', cdRegister);
 S.RegisterDelphiFunction(@OverlayIcon, 'OverlayIcon', cdRegister);
 S.RegisterDelphiFunction(@OverlayIconShortCut, 'OverlayIconShortCut', cdRegister);
 S.RegisterDelphiFunction(@OverlayIconShared, 'OverlayIconShared', cdRegister);
 S.RegisterDelphiFunction(@SHGetItemInfoTip, 'SHGetItemInfoTip', cdRegister);
 S.RegisterDelphiFunction(@ShellExecEx, 'ShellExecEx', cdRegister);
 S.RegisterDelphiFunction(@ShellExec, 'ShellExec', cdRegister);
 S.RegisterDelphiFunction(@ShellExecAndWait, 'ShellExecAndWait', cdRegister);
 S.RegisterDelphiFunction(@ShellOpenAs, 'ShellOpenAs', cdRegister);
 S.RegisterDelphiFunction(@ShellRasDial, 'ShellRasDial', cdRegister);
 S.RegisterDelphiFunction(@ShellRunControlPanel, 'ShellRunControlPanel', cdRegister);
 S.RegisterDelphiFunction(@GetFileNameIcon, 'GetFileNameIcon', cdRegister);
 S.RegisterDelphiFunction(@GetFileExeType, 'GetFileExeType', cdRegister);
 S.RegisterDelphiFunction(@ShellFindExecutable, 'ShellFindExecutable', cdRegister);
end;

 
 
{ TPSImport_JclShell }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclShell.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclShell(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclShell.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclShell(ri);
  RIRegister_JclShell_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
