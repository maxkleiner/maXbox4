unit uPSI_cFileUtils;
{
   tod und teufel tour 2012  , selftest CFileUtils
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
  TPSImport_cFileUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 
{ compile-time registration functions }
procedure SIRegister_EFileError(CL: TPSPascalCompiler);
procedure SIRegister_cFileUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_EFileError(CL: TPSRuntimeClassImporter);
procedure RIRegister_cFileUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,cFileUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cFileUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EFileError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EFileError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EFileError') do begin
    RegisterMethod('Constructor Create( const FileError : TFileError; const Msg : string)');
    RegisterMethod('Constructor CreateFmt( const FileError : TFileError; const Msg : string; const Args : array of const)');
    RegisterProperty('FileError', 'TFileError', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cFileUtils(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('PathSeparator','String').SetString( '/' '\');
 CL.AddDelphiFunction('Function PathHasDriveLetterA( const Path : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function PathHasDriveLetter( const Path : String) : Boolean');
 CL.AddDelphiFunction('Function PathIsDriveLetterA( const Path : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function PathIsDriveLetter( const Path : String) : Boolean');
 CL.AddDelphiFunction('Function PathIsDriveRootA( const Path : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function PathIsDriveRoot( const Path : String) : Boolean');
 CL.AddDelphiFunction('Function PathIsRootA( const Path : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function PathIsRoot( const Path : String) : Boolean');
 CL.AddDelphiFunction('Function PathIsUNCPathA( const Path : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function PathIsUNCPath( const Path : String) : Boolean');
 CL.AddDelphiFunction('Function PathIsAbsoluteA( const Path : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function PathIsAbsolute( const Path : String) : Boolean');
 CL.AddDelphiFunction('Function PathIsDirectoryA( const Path : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function PathIsDirectory( const Path : String) : Boolean');
 CL.AddDelphiFunction('Function PathInclSuffixA( const Path : AnsiString; const PathSep : Char) : AnsiString');
 CL.AddDelphiFunction('Function PathInclSuffix( const Path : String; const PathSep : Char) : String');
 CL.AddDelphiFunction('Function PathExclSuffixA( const Path : AnsiString; const PathSep : Char) : AnsiString');
 CL.AddDelphiFunction('Function PathExclSuffix( const Path : String; const PathSep : Char) : String');
 CL.AddDelphiFunction('Procedure PathEnsureSuffixA( var Path : AnsiString; const PathSep : Char)');
 CL.AddDelphiFunction('Procedure PathEnsureSuffix( var Path : String; const PathSep : Char)');
 CL.AddDelphiFunction('Procedure PathEnsureNoSuffixA( var Path : AnsiString; const PathSep : Char)');
 CL.AddDelphiFunction('Procedure PathEnsureNoSuffix( var Path : String; const PathSep : Char)');
 //CL.AddDelphiFunction('Function PathCanonicalA( const Path : AnsiString; const PathSep : Char) : AnsiString');
 CL.AddDelphiFunction('Function PathCanonical( const Path : String; const PathSep : Char) : String');
 //CL.AddDelphiFunction('Function PathExpandA( const Path : AnsiString; const BasePath : AnsiString; const PathSep :Char) : AnsiString');
 CL.AddDelphiFunction('Function PathExpand( const Path : String; const BasePath : String; const PathSep : Char) : String');
 CL.AddDelphiFunction('Function PathLeftElementA( const Path : AnsiString; const PathSep : Char) : AnsiString');
 CL.AddDelphiFunction('Function PathLeftElement( const Path : String; const PathSep : Char) : String');
 CL.AddDelphiFunction('Procedure PathSplitLeftElementA( const Path : AnsiString; var LeftElement, RightPath : AnsiString; const PathSep : Char)');
 CL.AddDelphiFunction('Procedure PathSplitLeftElement( const Path : String; var LeftElement, RightPath : String; const PathSep : Char)');
 CL.AddDelphiFunction('Procedure DecodeFilePathA( const FilePath : AnsiString; var Path, FileName : AnsiString; const PathSep : Char)');
 CL.AddDelphiFunction('Procedure DecodeFilePath( const FilePath : String; var Path, FileName : String; const PathSep : Char)');
 CL.AddDelphiFunction('Function FileNameValidA( const FileName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function FileNameValid( const FileName : String) : String');
 //CL.AddDelphiFunction('Function FilePathA( const FileName, Path : AnsiString; const BasePath : AnsiString; const PathSep : Char) : AnsiString');
 CL.AddDelphiFunction('Function FilePath( const FileName, Path : String; const BasePath : String; const PathSep : Char) : String');
 CL.AddDelphiFunction('Function DirectoryExpandA( const Path : AnsiString; const BasePath : AnsiString; const PathSep : Char) : AnsiString');
 CL.AddDelphiFunction('Function DirectoryExpand( const Path : String; const BasePath : String; const PathSep : Char) : String');
 CL.AddDelphiFunction('Function UnixPathToWinPath( const Path : AnsiString) : AnsiString');
  CL.AddDelphiFunction('Function WinPathToUnixPath( const Path : AnsiString) : AnsiString');
  SIRegister_EFileError(CL);
  CL.AddTypeS('TFileHandle', 'Integer');
  CL.AddTypeS('TFileAccess', '( faRead, faWrite, faReadWrite )');
  CL.AddTypeS('TFileSharing', '( fsDenyNone, fsDenyRead, fsDenyWrite, fsDenyReadWrite, fsExclusive )');
  CL.AddTypeS('TFileOpenFlags', '( foDeleteOnClose, foNoBuffering, foWri'
   +'teThrough, foRandomAccessHint, foSequentialScanHint, foSeekToEndOfFile )');
  CL.AddTypeS('TFileCreationMode', '( fcCreateNew, fcCreateAlways, fcOpenExisti'
   +'ng, fcOpenAlways, fcTruncateExisting )');
  CL.AddTypeS('TFileSeekPosition', '( fpOffsetFromStart, fpOffsetFromCurrent, fpOffsetFromEnd )');
 // CL.AddTypeS('PFileOpenWait', '^TFileOpenWait // will not work');
  //CL.AddTypeS('TFileOpenWait', 'record Wait : Boolean; UserData : LongWord; Tim'
   //+'eout : Integer; RetryInterval : Integer; RetryRandomise : Boolean; Callbac'
   //+'k : TFileOpenWaitProcedure; Aborted : Boolean; Signal : THandle; end');
 //CL.AddDelphiFunction('Function FileOpenExA( const FileName : AnsiString; const FileAccess : TFileAccess; const FileSharing : TFileSharing; const FileOpenFlags : TFileOpenFlags; const FileCreationMode : TFileCreationMode; const FileOpenWait : PFileOpenWait) : TFileHandle');
 CL.AddDelphiFunction('Function FileSeekEx( const FileHandle : TFileHandle; const FileOffset : Int64; const FilePosition : TFileSeekPosition) : Int64');
 CL.AddDelphiFunction('Procedure FileCloseEx( const FileHandle : TFileHandle)');
 CL.AddDelphiFunction('Function FileExistsA( const FileName : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function CFileExists( const FileName : String) : Boolean');
 CL.AddDelphiFunction('Function CFileGetSize( const FileName : String) : Int64');
 CL.AddDelphiFunction('Function FileGetDateTime( const FileName : String) : TDateTime');
 CL.AddDelphiFunction('Function FileGetDateTime2( const FileName : String) : TDateTime');
 CL.AddDelphiFunction('Function FileIsReadOnly( const FileName : String) : Boolean');
 CL.AddDelphiFunction('Procedure FileDeleteEx( const FileName : String)');
 CL.AddDelphiFunction('Procedure FileRenameEx( const OldFileName, NewFileName : String)');
 //CL.AddDelphiFunction('Function ReadFileStrA( const FileName : AnsiString; const FileSharing : TFileSharing; const FileCreationMode : TFileCreationMode; const FileOpenWait : PFileOpenWait) : AnsiString');
 CL.AddDelphiFunction('Function DirectoryEntryExists( const Name : String) : Boolean');
 CL.AddDelphiFunction('Function DirectoryEntrySize( const Name : String) : Int64');
 CL.AddDelphiFunction('Function CDirectoryExists( const DirectoryName : String) : Boolean');
 CL.AddDelphiFunction('Function DirectoryGetDateTime( const DirectoryName : String) : TDateTime');
 CL.AddDelphiFunction('Procedure CDirectoryCreate( const DirectoryName : String)');
 CL.AddDelphiFunction('Procedure DirCreate( const DirectoryName : String)');
 CL.AddDelphiFunction('Function GetFirstFileNameMatching( const FileMask : String) : String');
 CL.AddDelphiFunction('Function DirEntryGetAttr( const FileName : AnsiString) : Integer');
 CL.AddDelphiFunction('Function DirEntryIsDirectory( const FileName : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function FileHasAttr( const FileName : String; const Attr : Word) : Boolean');
 CL.AddDelphiFunction('Procedure CCopyFile( const FileName, DestName : String)');
 CL.AddDelphiFunction('Procedure CMoveFile( const FileName, DestName : String)');
 CL.AddDelphiFunction('Function CDeleteFiles( const FileMask : String) : Boolean');
  CL.AddTypeS('TLogicalDriveType', '( DriveRemovable, DriveFixed, DriveRemote, '
   +'DriveCDRom, DriveRamDisk, DriveTypeUnknown )');
 CL.AddDelphiFunction('Function DriveIsValid( const Drive : Char) : Boolean');
 CL.AddDelphiFunction('Function DriveGetType( const Path : AnsiString) : TLogicalDriveType');
 CL.AddDelphiFunction('Function DriveFreeSpace( const Path : AnsiString) : Int64');
 CL.AddDelphiFunction('Procedure SelfTestCFileUtils');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure EFileErrorFileError_R(Self: EFileError; var T: TFileError);
begin T := Self.FileError; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EFileError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EFileError) do begin
    RegisterConstructor(@EFileError.Create, 'Create');
    RegisterConstructor(@EFileError.CreateFmt, 'CreateFmt');
    RegisterPropertyHelper(@EFileErrorFileError_R,nil,'FileError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cFileUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PathHasDriveLetterA, 'PathHasDriveLetterA', cdRegister);
 S.RegisterDelphiFunction(@PathHasDriveLetter, 'PathHasDriveLetter', cdRegister);
 S.RegisterDelphiFunction(@PathIsDriveLetterA, 'PathIsDriveLetterA', cdRegister);
 S.RegisterDelphiFunction(@PathIsDriveLetter, 'PathIsDriveLetter', cdRegister);
 S.RegisterDelphiFunction(@PathIsDriveRootA, 'PathIsDriveRootA', cdRegister);
 S.RegisterDelphiFunction(@PathIsDriveRoot, 'PathIsDriveRoot', cdRegister);
 S.RegisterDelphiFunction(@PathIsRootA, 'PathIsRootA', cdRegister);
 S.RegisterDelphiFunction(@PathIsRoot, 'PathIsRoot', cdRegister);
 S.RegisterDelphiFunction(@PathIsUNCPathA, 'PathIsUNCPathA', cdRegister);
 S.RegisterDelphiFunction(@PathIsUNCPath, 'PathIsUNCPath', cdRegister);
 S.RegisterDelphiFunction(@PathIsAbsoluteA, 'PathIsAbsoluteA', cdRegister);
 S.RegisterDelphiFunction(@PathIsAbsolute, 'PathIsAbsolute', cdRegister);
 S.RegisterDelphiFunction(@PathIsDirectoryA, 'PathIsDirectoryA', cdRegister);
 S.RegisterDelphiFunction(@PathIsDirectory, 'PathIsDirectory', cdRegister);
 S.RegisterDelphiFunction(@PathInclSuffixA, 'PathInclSuffixA', cdRegister);
 S.RegisterDelphiFunction(@PathInclSuffix, 'PathInclSuffix', cdRegister);
 S.RegisterDelphiFunction(@PathExclSuffixA, 'PathExclSuffixA', cdRegister);
 S.RegisterDelphiFunction(@PathExclSuffix, 'PathExclSuffix', cdRegister);
 S.RegisterDelphiFunction(@PathEnsureSuffixA, 'PathEnsureSuffixA', cdRegister);
 S.RegisterDelphiFunction(@PathEnsureSuffix, 'PathEnsureSuffix', cdRegister);
 S.RegisterDelphiFunction(@PathEnsureNoSuffixA, 'PathEnsureNoSuffixA', cdRegister);
 S.RegisterDelphiFunction(@PathEnsureNoSuffix, 'PathEnsureNoSuffix', cdRegister);
 //S.RegisterDelphiFunction(@PathCanonicalA, 'PathCanonicalA', cdRegister);
 S.RegisterDelphiFunction(@PathCanonical, 'PathCanonical', cdRegister);
 //S.RegisterDelphiFunction(@PathExpandA, 'PathExpandA', cdRegister);
 S.RegisterDelphiFunction(@PathExpand, 'PathExpand', cdRegister);
 S.RegisterDelphiFunction(@PathLeftElementA, 'PathLeftElementA', cdRegister);
 S.RegisterDelphiFunction(@PathLeftElement, 'PathLeftElement', cdRegister);
 S.RegisterDelphiFunction(@PathSplitLeftElementA, 'PathSplitLeftElementA', cdRegister);
 S.RegisterDelphiFunction(@PathSplitLeftElement, 'PathSplitLeftElement', cdRegister);
 S.RegisterDelphiFunction(@DecodeFilePathA, 'DecodeFilePathA', cdRegister);
 S.RegisterDelphiFunction(@DecodeFilePath, 'DecodeFilePath', cdRegister);
 S.RegisterDelphiFunction(@FileNameValidA, 'FileNameValidA', cdRegister);
 S.RegisterDelphiFunction(@FileNameValid, 'FileNameValid', cdRegister);
 //S.RegisterDelphiFunction(@FilePathA, 'FilePathA', cdRegister);
 S.RegisterDelphiFunction(@FilePath, 'FilePath', cdRegister);
 //S.RegisterDelphiFunction(@DirectoryExpandA, 'DirectoryExpandA', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExpand, 'DirectoryExpand', cdRegister);
 S.RegisterDelphiFunction(@UnixPathToWinPath, 'UnixPathToWinPath', cdRegister);
 S.RegisterDelphiFunction(@WinPathToUnixPath, 'WinPathToUnixPath', cdRegister);
 // RIRegister_EFileError(CL);
 S.RegisterDelphiFunction(@FileOpenExA, 'FileOpenExA', cdRegister);
 S.RegisterDelphiFunction(@FileSeekEx, 'FileSeekEx', cdRegister);
 S.RegisterDelphiFunction(@FileCloseEx, 'FileCloseEx', cdRegister);
 S.RegisterDelphiFunction(@FileExistsA, 'FileExistsA', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'CFileExists', cdRegister);
 S.RegisterDelphiFunction(@FileGetSize, 'CFileGetSize', cdRegister);
 S.RegisterDelphiFunction(@FileGetDateTime, 'FileGetDateTime', cdRegister);
 S.RegisterDelphiFunction(@FileGetDateTime2, 'FileGetDateTime2', cdRegister);
 S.RegisterDelphiFunction(@FileIsReadOnly, 'FileIsReadOnly', cdRegister);
 S.RegisterDelphiFunction(@FileDeleteEx, 'FileDeleteEx', cdRegister);
 S.RegisterDelphiFunction(@FileRenameEx, 'FileRenameEx', cdRegister);
 S.RegisterDelphiFunction(@ReadFileStrA, 'ReadFileStrA', cdRegister);
 S.RegisterDelphiFunction(@DirectoryEntryExists, 'DirectoryEntryExists', cdRegister);
 S.RegisterDelphiFunction(@DirectoryEntrySize, 'DirectoryEntrySize', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'CDirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@DirectoryGetDateTime, 'DirectoryGetDateTime', cdRegister);
 S.RegisterDelphiFunction(@DirectoryCreate, 'CDirectoryCreate', cdRegister);
 S.RegisterDelphiFunction(@DirectoryCreate, 'DirCreate', cdRegister);
 S.RegisterDelphiFunction(@GetFirstFileNameMatching, 'GetFirstFileNameMatching', cdRegister);
 S.RegisterDelphiFunction(@DirEntryGetAttr, 'DirEntryGetAttr', cdRegister);
 S.RegisterDelphiFunction(@DirEntryIsDirectory, 'DirEntryIsDirectory', cdRegister);
 S.RegisterDelphiFunction(@FileHasAttr, 'FileHasAttr', cdRegister);
 S.RegisterDelphiFunction(@CopyFile, 'CCopyFile', cdRegister);
 S.RegisterDelphiFunction(@MoveFile, 'CMoveFile', cdRegister);
 S.RegisterDelphiFunction(@DeleteFiles, 'CDeleteFiles', cdRegister);
 S.RegisterDelphiFunction(@DriveIsValid, 'DriveIsValid', cdRegister);
 S.RegisterDelphiFunction(@DriveGetType, 'DriveGetType', cdRegister);
 S.RegisterDelphiFunction(@DriveFreeSpace, 'DriveFreeSpace', cdRegister);
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestCFileUtils', cdRegister);
end;



{ TPSImport_cFileUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cFileUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cFileUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cFileUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cFileUtils(ri);
  RIRegister_cFileUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
