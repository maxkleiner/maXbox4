unit uPSI_JvFileUtil;
{
  V3.8.6
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
  TPSImport_JvFileUtil = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvFileUtil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvFileUtil_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,RTLConsts
  ,Messages
  ,Consts
  ,Controls
  ,JvFileUtil
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvFileUtil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvFileUtil(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure CopyFileJ( const FileName, DestName : string; ProgressControl : TControl)');
 CL.AddDelphiFunction('Procedure CopyFileEx( const FileName, DestName : string; OverwriteReadOnly, ShellDialog : Boolean; ProgressControl : TControl)');
 CL.AddDelphiFunction('Procedure MoveFileJ( const FileName, DestName : TFileName)');
 CL.AddDelphiFunction('Procedure MoveFileEx( const FileName, DestName : TFileName; ShellDialog : Boolean)');
 CL.AddDelphiFunction('Function GetFileSizeJ( const FileName : string) : Int64');
 CL.AddDelphiFunction('Function GetFileSizeJ( const FileName : string) : Longint');
 CL.AddDelphiFunction('Function FileDateTime( const FileName : string) : TDateTime');
 CL.AddDelphiFunction('Function HasAttr( const FileName : string; Attr : Integer) : Boolean');
 CL.AddDelphiFunction('Function DeleteFiles( const FileMask : string) : Boolean');
 CL.AddDelphiFunction('Function DeleteFilesEx( const FileMasks : array of string) : Boolean');
 CL.AddDelphiFunction('Function ClearDir( const Path : string; Delete : Boolean) : Boolean');
 CL.AddDelphiFunction('Function NormalDir( const DirName : string) : string');
 CL.AddDelphiFunction('Function RemoveBackSlashJ( const DirName : string) : string');
 CL.AddDelphiFunction('Function ValidFileName( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function DirExists( Name : string) : Boolean');
 CL.AddDelphiFunction('Procedure ForceDirectoriesJ( Dir : string)');
 CL.AddDelphiFunction('Function FileLock( Handle : Integer; Offset, LockSize : Longint) : Integer;');
 CL.AddDelphiFunction('Function FileLock1( Handle : Integer; Offset, LockSize : Int64) : Integer;');
 CL.AddDelphiFunction('Function FileUnlock( Handle : Integer; Offset, LockSize : Longint) : Integer;');
 CL.AddDelphiFunction('Function FileUnlock1( Handle : Integer; Offset, LockSize : Int64) : Integer;');
 CL.AddDelphiFunction('Function GetTempDir : string');
 CL.AddDelphiFunction('Function GetWindowsDir : string');
 CL.AddDelphiFunction('Function GetSystemDir : string');
 CL.AddDelphiFunction('Function BrowseDirectory( var AFolderName : string; const DlgText : string; AHelpContext : THelpContext) : Boolean');
 CL.AddDelphiFunction('Function BrowseComputer( var ComputerName : string; const DlgText : string; AHelpContext : THelpContext) : Boolean');
 CL.AddDelphiFunction('Function ShortToLongFileName( const ShortName : string) : string');
 CL.AddDelphiFunction('Function ShortToLongPath( const ShortName : string) : string');
 CL.AddDelphiFunction('Function LongToShortFileName( const LongName : string) : string');
 CL.AddDelphiFunction('Function LongToShortPath( const LongName : string) : string');
 CL.AddDelphiFunction('Procedure CreateFileLink( const FileName, DisplayName : string; Folder : Integer)');
 CL.AddDelphiFunction('Procedure DeleteFileLink( const DisplayName : string; Folder : Integer)');
 CL.AddDelphiFunction('Function IsPathDelimiterJ( const S : string; Index : Integer) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function FileUnlock1_P( Handle : Integer; Offset, LockSize : Int64) : Integer;
Begin Result := JvFileUtil.FileUnlock(Handle, Offset, LockSize); END;

(*----------------------------------------------------------------------------*)
Function FileUnlock_P( Handle : Integer; Offset, LockSize : Longint) : Integer;
Begin Result := JvFileUtil.FileUnlock(Handle, Offset, LockSize); END;

(*----------------------------------------------------------------------------*)
Function FileLock1_P( Handle : Integer; Offset, LockSize : Int64) : Integer;
Begin Result := JvFileUtil.FileLock(Handle, Offset, LockSize); END;

(*----------------------------------------------------------------------------*)
Function FileLock_P( Handle : Integer; Offset, LockSize : Longint) : Integer;
Begin Result := JvFileUtil.FileLock(Handle, Offset, LockSize); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvFileUtil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CopyFile, 'CopyFileJ', cdRegister);
 S.RegisterDelphiFunction(@CopyFileEx, 'CopyFileEx', cdRegister);
 S.RegisterDelphiFunction(@MoveFile, 'MoveFileJ', cdRegister);
 S.RegisterDelphiFunction(@MoveFileEx, 'MoveFileEx', cdRegister);
 S.RegisterDelphiFunction(@GetFileSize, 'GetFileSizeJ', cdRegister);
 S.RegisterDelphiFunction(@GetFileSize, 'GetFileSizeJ', cdRegister);
 S.RegisterDelphiFunction(@FileDateTime, 'FileDateTime', cdRegister);
 S.RegisterDelphiFunction(@HasAttr, 'HasAttr', cdRegister);
 S.RegisterDelphiFunction(@DeleteFiles, 'DeleteFiles', cdRegister);
 S.RegisterDelphiFunction(@DeleteFilesEx, 'DeleteFilesEx', cdRegister);
 S.RegisterDelphiFunction(@ClearDir, 'ClearDir', cdRegister);
 S.RegisterDelphiFunction(@NormalDir, 'NormalDir', cdRegister);
 S.RegisterDelphiFunction(@RemoveBackSlash, 'RemoveBackSlashJ', cdRegister);
 S.RegisterDelphiFunction(@ValidFileName, 'ValidFileName', cdRegister);
 S.RegisterDelphiFunction(@DirExists, 'DirExists', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'ForceDirectoriesJ', cdRegister);
 S.RegisterDelphiFunction(@FileLock, 'FileLock', cdRegister);
 S.RegisterDelphiFunction(@FileLock1_P, 'FileLock1', cdRegister);
 S.RegisterDelphiFunction(@FileUnlock, 'FileUnlock', cdRegister);
 S.RegisterDelphiFunction(@FileUnlock1_P, 'FileUnlock1', cdRegister);
 S.RegisterDelphiFunction(@GetTempDir, 'GetTempDir', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsDir, 'GetWindowsDir', cdRegister);
 S.RegisterDelphiFunction(@GetSystemDir, 'GetSystemDir', cdRegister);
 S.RegisterDelphiFunction(@BrowseDirectory, 'BrowseDirectory', cdRegister);
 S.RegisterDelphiFunction(@BrowseComputer, 'BrowseComputer', cdRegister);
 S.RegisterDelphiFunction(@ShortToLongFileName, 'ShortToLongFileName', cdRegister);
 S.RegisterDelphiFunction(@ShortToLongPath, 'ShortToLongPath', cdRegister);
 S.RegisterDelphiFunction(@LongToShortFileName, 'LongToShortFileName', cdRegister);
 S.RegisterDelphiFunction(@LongToShortPath, 'LongToShortPath', cdRegister);
 S.RegisterDelphiFunction(@CreateFileLink, 'CreateFileLink', cdRegister);
 S.RegisterDelphiFunction(@DeleteFileLink, 'DeleteFileLink', cdRegister);
 S.RegisterDelphiFunction(@IsPathDelimiter, 'IsPathDelimiterJ', cdRegister);
end;



{ TPSImport_JvFileUtil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFileUtil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvFileUtil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFileUtil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvFileUtil(ri);
  RIRegister_JvFileUtil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
