unit uPSI_LazFileUtils;
{
   inc and inc on 
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
  TPSImport_LazFileUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_LazFileUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_LazFileUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   SysConst
  //,LazUTF8
  //,LazUtilsStrConsts
  ,LazFileUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_LazFileUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_LazFileUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function CompareFilenames( const Filename1, Filename2 : string) : integer');
 CL.AddDelphiFunction('Function CompareFilenamesIgnoreCase( const Filename1, Filename2 : string) : integer');
 CL.AddDelphiFunction('Function CompareFileExt( const Filename, Ext : string; CaseSensitive : boolean) : integer;');
 CL.AddDelphiFunction('Function CompareFileExt1( const Filename, Ext : string) : integer;');
 CL.AddDelphiFunction('Function CompareFilenameStarts( const Filename1, Filename2 : string) : integer');
 CL.AddDelphiFunction('Function CompareFilenames2( Filename1 : PChar; Len1 : integer; Filename2 : PChar; Len2 : integer) : integer');
 CL.AddDelphiFunction('Function CompareFilenamesP( Filename1, Filename2 : PChar; IgnoreCase : boolean) : integer');
 CL.AddDelphiFunction('Function DirPathExists( DirectoryName : string) : boolean');
 CL.AddDelphiFunction('Function DirectoryIsWritable( const DirectoryName : string) : boolean');
 CL.AddDelphiFunction('Function ExtractFileNameOnly( const AFilename : string) : string');
 CL.AddDelphiFunction('Function FilenameIsAbsolute( const TheFilename : string) : boolean');
 CL.AddDelphiFunction('Function FilenameIsWinAbsolute( const TheFilename : string) : boolean');
 CL.AddDelphiFunction('Function FilenameIsUnixAbsolute( const TheFilename : string) : boolean');
 CL.AddDelphiFunction('Function ForceDirectory( DirectoryName : string) : boolean');
 CL.AddDelphiFunction('Procedure CheckIfFileIsExecutable( const AFilename : string)');
 CL.AddDelphiFunction('Procedure CheckIfFileIsSymlink( const AFilename : string)');
 (*CL.AddDelphiFunction('Function FileIsExecutable( const AFilename : string) : boolean');
 CL.AddDelphiFunction('Function FileIsSymlink( const AFilename : string) : boolean');
 CL.AddDelphiFunction('Function FileIsHardLink( const AFilename : string) : boolean');
 CL.AddDelphiFunction('Function FileIsReadable( const AFilename : string) : boolean');
 CL.AddDelphiFunction('Function FileIsWritable( const AFilename : string) : boolean');*)
 CL.AddDelphiFunction('Function FileIsText( const AFilename : string) : boolean');
 CL.AddDelphiFunction('Function FileIsText2( const AFilename : string; out FileReadable : boolean) : boolean');
 CL.AddDelphiFunction('Function FilenameIsTrimmed( const TheFilename : string) : boolean');
 CL.AddDelphiFunction('Function FilenameIsTrimmed2( StartPos : PChar; NameLen : integer) : boolean');
 CL.AddDelphiFunction('Function TrimFilename( const AFilename : string) : string');
 CL.AddDelphiFunction('Function ResolveDots( const AFilename : string) : string');
 CL.AddDelphiFunction('Procedure ForcePathDelims( var FileName : string)');
 CL.AddDelphiFunction('Function GetForcedPathDelims( const FileName : string) : String');
 CL.AddDelphiFunction('Function CleanAndExpandFilename( const Filename : string) : string');
 CL.AddDelphiFunction('Function CleanAndExpandDirectory( const Filename : string) : string');
 CL.AddDelphiFunction('Function TrimAndExpandFilename( const Filename : string; const BaseDir : string) : string');
 CL.AddDelphiFunction('Function TrimAndExpandDirectory( const Filename : string; const BaseDir : string) : string');
 CL.AddDelphiFunction('Function TryCreateRelativePath( const Dest, Source : String; UsePointDirectory : boolean; AlwaysRequireSharedBaseFolder : Boolean; out RelPath : String) : Boolean');
 CL.AddDelphiFunction('Function CreateRelativePath( const Filename, BaseDirectory : string; UsePointDirectory : boolean; AlwaysRequireSharedBaseFolder : Boolean) : string');
 CL.AddDelphiFunction('Function FileIsInPath( const Filename, Path : string) : boolean');
 CL.AddDelphiFunction('Function AppendPathDelim( const Path : string) : string');
 CL.AddDelphiFunction('Function ChompPathDelim( const Path : string) : string');
 CL.AddDelphiFunction('Function CreateAbsoluteSearchPath( const SearchPath, BaseDirectory : string) : string');
 CL.AddDelphiFunction('Function CreateRelativeSearchPath( const SearchPath, BaseDirectory : string) : string');
 CL.AddDelphiFunction('Function MinimizeSearchPath( const SearchPath : string) : string');
 CL.AddDelphiFunction('Function FindPathInSearchPath( APath : PChar; APathLen : integer; SearchPath : PChar; SearchPathLen : integer) : PChar');
 (*CL.AddDelphiFunction('Function FileExistsUTF8( const Filename : string) : boolean');
 CL.AddDelphiFunction('Function FileAgeUTF8( const FileName : string) : Longint');
 CL.AddDelphiFunction('Function DirectoryExistsUTF8( const Directory : string) : Boolean');
 CL.AddDelphiFunction('Function ExpandFileNameUTF8( const FileName : string; BaseDir : string) : string');
 CL.AddDelphiFunction('Function FindFirstUTF8( const Path : string; Attr : Longint; out Rslt : TSearchRec) : Longint');
 CL.AddDelphiFunction('Function FindNextUTF8( var Rslt : TSearchRec) : Longint');
 CL.AddDelphiFunction('Procedure FindCloseUTF8( var F : TSearchrec)');
 CL.AddDelphiFunction('Function FileSetDateUTF8( const FileName : String; Age : Longint) : Longint');
 CL.AddDelphiFunction('Function FileGetAttrUTF8( const FileName : String) : Longint');
 CL.AddDelphiFunction('Function FileSetAttrUTF8( const Filename : String; Attr : longint) : Longint');
 CL.AddDelphiFunction('Function DeleteFileUTF8( const FileName : String) : Boolean');
 CL.AddDelphiFunction('Function RenameFileUTF8( const OldName, NewName : String) : Boolean');
 CL.AddDelphiFunction('Function FileSearchUTF8( const Name, DirList : String; ImplicitCurrentDir : Boolean) : String');
 CL.AddDelphiFunction('Function FileIsReadOnlyUTF8( const FileName : String) : Boolean');
 CL.AddDelphiFunction('Function GetCurrentDirUTF8 : String');
 CL.AddDelphiFunction('Function SetCurrentDirUTF8( const NewDir : String) : Boolean');
 CL.AddDelphiFunction('Function CreateDirUTF8( const NewDir : String) : Boolean');
 CL.AddDelphiFunction('Function RemoveDirUTF8( const Dir : String) : Boolean');
 CL.AddDelphiFunction('Function ForceDirectoriesUTF8( const Dir : string) : Boolean');
 CL.AddDelphiFunction('Function FileOpenUTF8( const FileName : string; Mode : Integer) : THandle');
 CL.AddDelphiFunction('Function FileCreateUTF8( const FileName : string) : THandle;');
 CL.AddDelphiFunction('Function FileCreateUTF81( const FileName : string; Rights : Cardinal) : THandle;');
 CL.AddDelphiFunction('Function FileCreateUtf82( const FileName : String; ShareMode : Integer; Rights : Cardinal) : THandle;');
 CL.AddDelphiFunction('Function FileSizeUtf8( const Filename : string) : int64');*)
 CL.AddDelphiFunction('Function GetFileDescription( const AFilename : string) : string');
 CL.AddDelphiFunction('Function GetAppConfigDirUTF8( Global : Boolean; Create : boolean) : string');
 CL.AddDelphiFunction('Function GetAppConfigFileUTF8( Global : Boolean; SubDir : boolean; CreateDir : boolean) : string');
 CL.AddDelphiFunction('Function GetTempFileNameUTF8( const Dir, Prefix : String) : String');
 CL.AddDelphiFunction('Function IsUNCPath( const Path : String) : Boolean');
 CL.AddDelphiFunction('Function ExtractUNCVolume( const Path : String) : String');
 CL.AddDelphiFunction('Function ExtractFileRoot( FileName : String) : String');
 CL.AddDelphiFunction('Function GetDarwinSystemFilename( Filename : string) : string');
 CL.AddDelphiFunction('Procedure SplitCmdLineParams( const Params : string; ParamList : TStrings; ReadBackslash : boolean)');
 CL.AddDelphiFunction('Function StrToCmdLineParam( const Param : string) : string');
 CL.AddDelphiFunction('Function MergeCmdLineParams( ParamList : TStrings) : string');
 CL.AddDelphiFunction('Procedure InvalidateFileStateCache( const Filename : string)');
  CL.AddDelphiFunction('Function FindAllFiles( const SearchPath : String; SearchMask : String; SearchSubDirs : Boolean) : TStringList');
 CL.AddDelphiFunction('Function FindAllDirectories( const SearchPath : string; SearchSubDirs : Boolean) : TStringList');
 CL.AddDelphiFunction('Function ReadFileToString( const Filename : string) : string');
 CL.AddDelphiFunction('function FindAllDocs(const Root, extmask: string): TStringlist;');
 CL.AddDelphiFunction('procedure Inc1(var X: longint; N: Longint);');
 CL.AddDelphiFunction('procedure Dec1(var X: longint; N: Longint);');
 CL.AddDelphiFunction('procedure Inc2(var X: longint; N: Longint);');
 CL.AddDelphiFunction('procedure Dec2(var X: longint; N: Longint);');



 (*type
  TCopyFileFlag = (
    cffOverwriteFile,
    cffCreateDestDirectory,
    cffPreserveTime
    );
  TCopyFileFlags = set of TCopyFileFlag;*)


  CL.AddTypeS('TCopyFileFlag', '(cffOverwriteFile, cffCreateDestDirectory, cffPreserveTime)');
  CL.AddTypeS('TCopyFileFlags', 'set of TCopyFileFlag');


 CL.AddDelphiFunction('Function CopyDirTree( const SourceDir, TargetDir : string; Flags : TCopyFileFlags) : Boolean');


 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
(*Function FileCreateUtf82_P( const FileName : String; ShareMode : Integer; Rights : Cardinal) : THandle;
Begin Result := LazFileUtils.FileCreateUtf8(FileName, ShareMode, Rights); END;

(*----------------------------------------------------------------------------*)
(*----------------------------------------------------------------------------*)
Function CompareFileExt1_P( const Filename, Ext : string) : integer;
Begin //Result := LazFileUtils.CompareFileExt(Filename, Ext);
END;

(*----------------------------------------------------------------------------*)
Function CompareFileExt_P( const Filename, Ext : string; CaseSensitive : boolean) : integer;
Begin Result := LazFileUtils.CompareFileExt(Filename, Ext, CaseSensitive); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_LazFileUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CompareFilenames, 'CompareFilenames', cdRegister);
 S.RegisterDelphiFunction(@CompareFilenamesIgnoreCase, 'CompareFilenamesIgnoreCase', cdRegister);
 S.RegisterDelphiFunction(@CompareFileExt, 'CompareFileExt', cdRegister);
 S.RegisterDelphiFunction(@CompareFileExt, 'CompareFileExt1', cdRegister);
 S.RegisterDelphiFunction(@CompareFilenameStarts, 'CompareFilenameStarts', cdRegister);
 S.RegisterDelphiFunction(@CompareFilenames2, 'CompareFilenames2', cdRegister);
 S.RegisterDelphiFunction(@CompareFilenamesP, 'CompareFilenamesP', cdRegister);
 S.RegisterDelphiFunction(@DirPathExists, 'DirPathExists', cdRegister);
 S.RegisterDelphiFunction(@DirectoryIsWritable, 'DirectoryIsWritable', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileNameOnly, 'ExtractFileNameOnly', cdRegister);
 S.RegisterDelphiFunction(@FilenameIsAbsolute, 'FilenameIsAbsolute', cdRegister);
 S.RegisterDelphiFunction(@FilenameIsWinAbsolute, 'FilenameIsWinAbsolute', cdRegister);
 S.RegisterDelphiFunction(@FilenameIsUnixAbsolute, 'FilenameIsUnixAbsolute', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectory, 'ForceDirectory', cdRegister);
 //S.RegisterDelphiFunction(@CheckIfFileIsExecutable, 'CheckIfFileIsExecutable', cdRegister);
 //S.RegisterDelphiFunction(@CheckIfFileIsSymlink, 'CheckIfFileIsSymlink', cdRegister);
 //S.RegisterDelphiFunction(@FileIsExecutable, 'FileIsExecutable', cdRegister);
 //S.RegisterDelphiFunction(@FileIsSymlink, 'FileIsSymlink', cdRegister);
 //S.RegisterDelphiFunction(@FileIsHardLink, 'FileIsHardLink', cdRegister);
 //7S.RegisterDelphiFunction(@FileIsReadable, 'FileIsReadable', cdRegister);
 //S.RegisterDelphiFunction(@FileIsWritable, 'FileIsWritable', cdRegister);
 S.RegisterDelphiFunction(@FileIsText, 'FileIsText', cdRegister);
 S.RegisterDelphiFunction(@FileIsText2, 'FileIsText2', cdRegister);
 S.RegisterDelphiFunction(@FilenameIsTrimmed, 'FilenameIsTrimmed', cdRegister);
 S.RegisterDelphiFunction(@FilenameIsTrimmed2, 'FilenameIsTrimmed2', cdRegister);
 S.RegisterDelphiFunction(@TrimFilename, 'TrimFilename', cdRegister);
 S.RegisterDelphiFunction(@ResolveDots, 'ResolveDots', cdRegister);
 S.RegisterDelphiFunction(@ForcePathDelims, 'ForcePathDelims', cdRegister);
 S.RegisterDelphiFunction(@GetForcedPathDelims, 'GetForcedPathDelims', cdRegister);
 S.RegisterDelphiFunction(@CleanAndExpandFilename, 'CleanAndExpandFilename', cdRegister);
 S.RegisterDelphiFunction(@CleanAndExpandDirectory, 'CleanAndExpandDirectory', cdRegister);
 S.RegisterDelphiFunction(@TrimAndExpandFilename, 'TrimAndExpandFilename', cdRegister);
 S.RegisterDelphiFunction(@TrimAndExpandDirectory, 'TrimAndExpandDirectory', cdRegister);
 S.RegisterDelphiFunction(@TryCreateRelativePath, 'TryCreateRelativePath', cdRegister);
 S.RegisterDelphiFunction(@CreateRelativePath, 'CreateRelativePath', cdRegister);
 S.RegisterDelphiFunction(@FileIsInPath, 'FileIsInPath', cdRegister);
 S.RegisterDelphiFunction(@AppendPathDelim, 'AppendPathDelim', cdRegister);
 S.RegisterDelphiFunction(@ChompPathDelim, 'ChompPathDelim', cdRegister);
 S.RegisterDelphiFunction(@CreateAbsoluteSearchPath, 'CreateAbsoluteSearchPath', cdRegister);
 S.RegisterDelphiFunction(@CreateRelativeSearchPath, 'CreateRelativeSearchPath', cdRegister);
 S.RegisterDelphiFunction(@MinimizeSearchPath, 'MinimizeSearchPath', cdRegister);
 S.RegisterDelphiFunction(@FindPathInSearchPath, 'FindPathInSearchPath', cdRegister);
 (*S.RegisterDelphiFunction(@FileExistsUTF8, 'FileExistsUTF8', cdRegister);
 S.RegisterDelphiFunction(@FileAgeUTF8, 'FileAgeUTF8', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExistsUTF8, 'DirectoryExistsUTF8', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileNameUTF8, 'ExpandFileNameUTF8', cdRegister);
 S.RegisterDelphiFunction(@FindFirstUTF8, 'FindFirstUTF8', cdRegister);
 S.RegisterDelphiFunction(@FindNextUTF8, 'FindNextUTF8', cdRegister);
 S.RegisterDelphiFunction(@FindCloseUTF8, 'FindCloseUTF8', cdRegister);
 S.RegisterDelphiFunction(@FileSetDateUTF8, 'FileSetDateUTF8', cdRegister);
 S.RegisterDelphiFunction(@FileGetAttrUTF8, 'FileGetAttrUTF8', cdRegister);
 S.RegisterDelphiFunction(@FileSetAttrUTF8, 'FileSetAttrUTF8', cdRegister);
 S.RegisterDelphiFunction(@DeleteFileUTF8, 'DeleteFileUTF8', cdRegister);
 S.RegisterDelphiFunction(@RenameFileUTF8, 'RenameFileUTF8', cdRegister);
 S.RegisterDelphiFunction(@FileSearchUTF8, 'FileSearchUTF8', cdRegister);
 S.RegisterDelphiFunction(@FileIsReadOnlyUTF8, 'FileIsReadOnlyUTF8', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentDirUTF8, 'GetCurrentDirUTF8', cdRegister);
 S.RegisterDelphiFunction(@SetCurrentDirUTF8, 'SetCurrentDirUTF8', cdRegister);
 S.RegisterDelphiFunction(@CreateDirUTF8, 'CreateDirUTF8', cdRegister);
 S.RegisterDelphiFunction(@RemoveDirUTF8, 'RemoveDirUTF8', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectoriesUTF8, 'ForceDirectoriesUTF8', cdRegister);
 S.RegisterDelphiFunction(@FileOpenUTF8, 'FileOpenUTF8', cdRegister);
 S.RegisterDelphiFunction(@FileCreateUTF8, 'FileCreateUTF8', cdRegister);
 S.RegisterDelphiFunction(@FileCreateUTF81, 'FileCreateUTF81', cdRegister);
 S.RegisterDelphiFunction(@FileCreateUtf82, 'FileCreateUtf82', cdRegister);
 S.RegisterDelphiFunction(@FileSizeUtf8, 'FileSizeUtf8', cdRegister); *)
 S.RegisterDelphiFunction(@GetFileDescription, 'GetFileDescription', cdRegister);
 S.RegisterDelphiFunction(@GetAppConfigDirUTF8, 'GetAppConfigDirUTF8', cdRegister);
 S.RegisterDelphiFunction(@GetAppConfigFileUTF8, 'GetAppConfigFileUTF8', cdRegister);
 S.RegisterDelphiFunction(@GetTempFileNameUTF8, 'GetTempFileNameUTF8', cdRegister);
 //S.RegisterDelphiFunction(@IsUNCPath, 'IsUNCPath', cdRegister);
 //S.RegisterDelphiFunction(@ExtractUNCVolume, 'ExtractUNCVolume', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileRoot, 'ExtractFileRoot', cdRegister);
 //S.RegisterDelphiFunction(@GetDarwinSystemFilename, 'GetDarwinSystemFilename', cdRegister);
 S.RegisterDelphiFunction(@SplitCmdLineParams, 'SplitCmdLineParams', cdRegister);
 S.RegisterDelphiFunction(@StrToCmdLineParam, 'StrToCmdLineParam', cdRegister);
 S.RegisterDelphiFunction(@MergeCmdLineParams, 'MergeCmdLineParams', cdRegister);
 S.RegisterDelphiFunction(@InvalidateFileStateCache, 'InvalidateFileStateCache', cdRegister);
 S.RegisterDelphiFunction(@FindAllFiles, 'FindAllFiles', cdRegister);
 S.RegisterDelphiFunction(@FindAllDirectories, 'FindAllDirectories', cdRegister);
 S.RegisterDelphiFunction(@ReadFileToString, 'ReadFileToString', cdRegister);
 S.RegisterDelphiFunction(@CopyDirTree, 'CopyDirTree', cdRegister);
 S.RegisterDelphiFunction(@FindallDocs, 'Findalldocs', cdRegister);
 S.RegisterDelphiFunction(@Inc1, 'Inc1', cdRegister);
 S.RegisterDelphiFunction(@Dec1, 'Dec1', cdRegister);
 S.RegisterDelphiFunction(@Inc1, 'Inc2', cdRegister);
 S.RegisterDelphiFunction(@Dec1, 'Dec2', cdRegister);



 end;



{ TPSImport_LazFileUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_LazFileUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_LazFileUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_LazFileUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_LazFileUtils(ri);
  RIRegister_LazFileUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
