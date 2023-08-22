unit uPSI_FileUtil;
{
   set on to 3.9.9.88 with prefix l like lazarus
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
  TPSImport_FileUtil = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TFileSearcher(CL: TPSPascalCompiler);
procedure SIRegister_TFileIterator(CL: TPSPascalCompiler);
procedure SIRegister_FileUtil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TFileSearcher(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFileIterator(CL: TPSRuntimeClassImporter);
procedure RIRegister_FileUtil_Routines(S: TPSExec);
procedure RIRegister_FileUtil(CL: TPSRuntimeClassImporter);


procedure Register;

implementation


uses
   Masks
  //,LazUTF8
  ,LazFileUtils
  ,FileUtil
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FileUtil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileSearcher(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFileIterator', 'TFileSearcher') do
  with CL.AddClassN(CL.FindClass('TFileIterator'),'TFileSearcher') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Search( const ASearchPath : String; ASearchMask : String; ASearchSubDirs : Boolean; CaseSensitive : Boolean)');
    RegisterProperty('MaskSeparator', 'char', iptrw);
    RegisterProperty('FollowSymLink', 'Boolean', iptrw);
    RegisterProperty('FileAttribute', 'Word', iptrw);
    RegisterProperty('DirectoryAttribute', 'Word', iptrw);
    RegisterProperty('OnDirectoryFound', 'TDirectoryFoundEvent', iptrw);
    RegisterProperty('OnFileFound', 'TFileFoundEvent', iptrw);
    RegisterProperty('OnDirectoryEnter', 'TDirectoryEnterEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileIterator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TFileIterator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TFileIterator') do begin
    RegisterMethod('Procedure Stop');
    RegisterMethod('Function IsDirectory : Boolean');
    RegisterProperty('FileName', 'String', iptr);
    RegisterProperty('FileInfo', 'TSearchRec', iptr);
    RegisterProperty('Level', 'Integer', iptr);
    RegisterProperty('Path', 'String', iptr);
    RegisterProperty('Searching', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_FileUtil(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('UTF8FileHeader','String').SetString( #$ef#$bb#$bf);
 CL.AddDelphiFunction('Function lCompareFilenames( const Filename1, Filename2 : string) : integer');
 CL.AddDelphiFunction('Function lCompareFilenamesIgnoreCase( const Filename1, Filename2 : string) : integer');
 CL.AddDelphiFunction('Function lCompareFilenames( const Filename1, Filename2 : string; ResolveLinks : boolean) : integer');
 CL.AddDelphiFunction('Function lCompareFilenames( Filename1 : PChar; Len1 : integer; Filename2 : PChar; Len2 : integer; ResolveLinks : boolean) : integer');
 CL.AddDelphiFunction('Function lFilenameIsAbsolute( const TheFilename : string) : boolean');
 CL.AddDelphiFunction('Function lFilenameIsWinAbsolute( const TheFilename : string) : boolean');
 CL.AddDelphiFunction('Function lFilenameIsUnixAbsolute( const TheFilename : string) : boolean');
 CL.AddDelphiFunction('Procedure lCheckIfFileIsExecutable( const AFilename : string)');
 CL.AddDelphiFunction('Procedure lCheckIfFileIsSymlink( const AFilename : string)');
 CL.AddDelphiFunction('Function lFileIsReadable( const AFilename : string) : boolean');
 CL.AddDelphiFunction('Function lFileIsWritable( const AFilename : string) : boolean');
 CL.AddDelphiFunction('Function lFileIsText( const AFilename : string) : boolean');
 CL.AddDelphiFunction('Function lFileIsText( const AFilename : string; out FileReadable : boolean) : boolean');
 CL.AddDelphiFunction('Function lFileIsExecutable( const AFilename : string) : boolean');
 CL.AddDelphiFunction('Function lFileIsSymlink( const AFilename : string) : boolean');
 CL.AddDelphiFunction('Function lFileIsHardLink( const AFilename : string) : boolean');
 CL.AddDelphiFunction('Function lFileSize( const Filename : string) : int64;');
 CL.AddDelphiFunction('Function lGetFileDescription( const AFilename : string) : string');
 CL.AddDelphiFunction('Function lReadAllLinks( const Filename : string; ExceptionOnError : boolean) : string');
 CL.AddDelphiFunction('Function lTryReadAllLinks( const Filename : string) : string');
 CL.AddDelphiFunction('Function lDirPathExists( const FileName : String) : Boolean');
 CL.AddDelphiFunction('Function lForceDirectory( DirectoryName : string) : boolean');
 CL.AddDelphiFunction('Function lDeleteDirectory( const DirectoryName : string; OnlyChildren : boolean) : boolean');
 CL.AddDelphiFunction('Function lProgramDirectory : string');
 CL.AddDelphiFunction('Function lDirectoryIsWritable( const DirectoryName : string) : boolean');
 CL.AddDelphiFunction('Function lExtractFileNameOnly( const AFilename : string) : string');
 CL.AddDelphiFunction('Function lExtractFileNameWithoutExt( const AFilename : string) : string');
 CL.AddDelphiFunction('Function lCompareFileExt( const Filename, Ext : string; CaseSensitive : boolean) : integer;');
 CL.AddDelphiFunction('Function lCompareFileExt( const Filename, Ext : string) : integer;');
 CL.AddDelphiFunction('Function lFilenameIsPascalUnit( const Filename : string) : boolean');
 CL.AddDelphiFunction('Function lAppendPathDelim( const Path : string) : string');
 CL.AddDelphiFunction('Function lChompPathDelim( const Path : string) : string');
 CL.AddDelphiFunction('Function lTrimFilename( const AFilename : string) : string');
 CL.AddDelphiFunction('Function lCleanAndExpandFilename( const Filename : string) : string');
 CL.AddDelphiFunction('Function lCleanAndExpandDirectory( const Filename : string) : string');
 CL.AddDelphiFunction('Function lCreateAbsoluteSearchPath( const SearchPath, BaseDirectory : string) : string');
 CL.AddDelphiFunction('Function lCreateRelativePath( const Filename, BaseDirectory : string; UsePointDirectory : boolean; AlwaysRequireSharedBaseFolder : Boolean) : string');
 CL.AddDelphiFunction('Function lCreateAbsolutePath( const Filename, BaseDirectory : string) : string');
 CL.AddDelphiFunction('Function lFileIsInPath( const Filename, Path : string) : boolean');
 CL.AddDelphiFunction('Function lFileIsInDirectory( const Filename, Directory : string) : boolean');
  CL.AddTypeS('TSearchFileInPathFlag', '( sffDontSearchInBasePath, sffSearchLoUpCase )');
  CL.AddTypeS('TSearchFileInPathFlags', 'set of TSearchFileInPathFlag');
 CL.AddConstantN('AllDirectoryEntriesMask','String').SetString( '*');
 CL.AddDelphiFunction('Function lGetAllFilesMask : string');
 CL.AddDelphiFunction('Function lGetExeExt : string');
 CL.AddDelphiFunction('Function lSearchFileInPath( const Filename, BasePath, SearchPath, Delimiter : string; Flags : TSearchFileInPathFlags) : string');
 CL.AddDelphiFunction('Function lSearchAllFilesInPath( const Filename, BasePath, SearchPath, Delimiter : string; Flags : TSearchFileInPathFlags) : TStrings');
 CL.AddDelphiFunction('Function lFindDiskFilename( const Filename : string) : string');
 CL.AddDelphiFunction('Function lFindDiskFileCaseInsensitive( const Filename : string) : string');
 CL.AddDelphiFunction('Function lFindDefaultExecutablePath( const Executable : string; const BaseDir : string) : string');
 CL.AddDelphiFunction('Function lGetDarwinSystemFilename( Filename : string) : string');
  SIRegister_TFileIterator(CL);
  CL.AddTypeS('TFileFoundEvent', 'Procedure ( FileIterator : TFileIterator)');
  CL.AddTypeS('TDirectoryFoundEvent', 'Procedure ( FileIterator : TFileIterator)');
  CL.AddTypeS('TDirectoryEnterEvent', 'Procedure ( FileIterator : TFileIterator)');
  SIRegister_TFileSearcher(CL);
 CL.AddDelphiFunction('Function lFindAllFiles( const SearchPath : String; SearchMask : String; SearchSubDirs : Boolean) : TStringList');
 CL.AddDelphiFunction('Function lFindAllDirectories( const SearchPath : string; SearchSubDirs : Boolean) : TStringList');
 // CL.AddTypeS('TCopyFileFlag', '( cffOverwriteFile, cffCreateDestDirectory, cffPreserveTime )');
 // CL.AddTypeS('TCopyFileFlags', 'set of TCopyFileFlag');
 CL.AddDelphiFunction('Function lCopyFile( const SrcFilename, DestFilename : string; Flags : TCopyFileFlags) : boolean');
 CL.AddDelphiFunction('Function lCopyFile( const SrcFilename, DestFilename : string; PreserveTime : boolean) : boolean');
 CL.AddDelphiFunction('Function lCopyDirTree( const SourceDir, TargetDir : string; Flags : TCopyFileFlags) : Boolean');
 CL.AddDelphiFunction('Function lReadFileToString( const Filename : string) : string');
 CL.AddDelphiFunction('Function lGetTempFilename( const Directory, Prefix : string) : string');
 {CL.AddDelphiFunction('Function NeedRTLAnsi : boolean');
 CL.AddDelphiFunction('Procedure SetNeedRTLAnsi( NewValue : boolean)');
 CL.AddDelphiFunction('Function UTF8ToSys( const s : string) : string');
 CL.AddDelphiFunction('Function SysToUTF8( const s : string) : string');
 CL.AddDelphiFunction('Function ConsoleToUTF8( const s : string) : string');
 CL.AddDelphiFunction('Function UTF8ToConsole( const s : string) : string');}
 CL.AddDelphiFunction('Function FileExistsUTF8( const Filename : string) : boolean');
 CL.AddDelphiFunction('Function FileAgeUTF8( const FileName : string) : Longint');
 CL.AddDelphiFunction('Function DirectoryExistsUTF8( const Directory : string) : Boolean');
 CL.AddDelphiFunction('Function ExpandFileNameUTF8( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExpandUNCFileNameUTF8( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractShortPathNameUTF8( const FileName : String) : String');
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
 CL.AddDelphiFunction('Function ParamStrUTF8( Param : Integer) : string');
 CL.AddDelphiFunction('Function GetEnvironmentStringUTF8( Index : Integer) : string');
 CL.AddDelphiFunction('Function GetEnvironmentVariableUTF8( const EnvVar : string) : String');
 CL.AddDelphiFunction('Function GetAppConfigDirUTF8( Global : Boolean; Create : boolean) : string');
 CL.AddDelphiFunction('Function GetAppConfigFileUTF8( Global : Boolean; SubDir : boolean; CreateDir : boolean) : string');
 CL.AddDelphiFunction('Function SysErrorMessageUTF8( ErrorCode : Integer) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function FileCreateUTF81_P( const FileName : string; Rights : Cardinal) : THandle;
Begin Result := FileUtil.FileCreateUTF8(FileName, Rights); END;

(*----------------------------------------------------------------------------*)
Function FileCreateUTF8_P( const FileName : string) : THandle;
Begin Result := FileUtil.FileCreateUTF8(FileName); END;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherOnDirectoryEnter_W(Self: TFileSearcher; const T: TDirectoryEnterEvent);
begin Self.OnDirectoryEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherOnDirectoryEnter_R(Self: TFileSearcher; var T: TDirectoryEnterEvent);
begin T := Self.OnDirectoryEnter; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherOnFileFound_W(Self: TFileSearcher; const T: TFileFoundEvent);
begin Self.OnFileFound := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherOnFileFound_R(Self: TFileSearcher; var T: TFileFoundEvent);
begin T := Self.OnFileFound; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherOnDirectoryFound_W(Self: TFileSearcher; const T: TDirectoryFoundEvent);
begin Self.OnDirectoryFound := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherOnDirectoryFound_R(Self: TFileSearcher; var T: TDirectoryFoundEvent);
begin T := Self.OnDirectoryFound; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherDirectoryAttribute_W(Self: TFileSearcher; const T: Word);
begin Self.DirectoryAttribute := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherDirectoryAttribute_R(Self: TFileSearcher; var T: Word);
begin T := Self.DirectoryAttribute; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherFileAttribute_W(Self: TFileSearcher; const T: Word);
begin Self.FileAttribute := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherFileAttribute_R(Self: TFileSearcher; var T: Word);
begin T := Self.FileAttribute; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherFollowSymLink_W(Self: TFileSearcher; const T: Boolean);
begin Self.FollowSymLink := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherFollowSymLink_R(Self: TFileSearcher; var T: Boolean);
begin T := Self.FollowSymLink; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherMaskSeparator_W(Self: TFileSearcher; const T: char);
begin Self.MaskSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearcherMaskSeparator_R(Self: TFileSearcher; var T: char);
begin T := Self.MaskSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TFileIteratorSearching_R(Self: TFileIterator; var T: Boolean);
begin T := Self.Searching; end;

(*----------------------------------------------------------------------------*)
procedure TFileIteratorPath_R(Self: TFileIterator; var T: String);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TFileIteratorLevel_R(Self: TFileIterator; var T: Integer);
begin T := Self.Level; end;

(*----------------------------------------------------------------------------*)
procedure TFileIteratorFileInfo_R(Self: TFileIterator; var T: TSearchRec);
begin T := Self.FileInfo; end;

(*----------------------------------------------------------------------------*)
procedure TFileIteratorFileName_R(Self: TFileIterator; var T: String);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
{Function CompareFileExt_P( const Filename, Ext : string) : integer;
Begin Result := FileUtil.CompareFileExt(Filename, Ext); END;}

(*----------------------------------------------------------------------------*)
Function CompareFileExt_P( const Filename, Ext : string; CaseSensitive : boolean) : integer;
Begin Result := FileUtil.CompareFileExt(Filename, Ext, CaseSensitive); END;

(*----------------------------------------------------------------------------*)
Function FileSize_P( const Filename : string) : int64;
Begin Result := FileUtil.FileSize(Filename); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileSearcher(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileSearcher) do begin
    RegisterConstructor(@TFileSearcher.Create, 'Create');
    RegisterMethod(@TFileSearcher.Search, 'Search');
    RegisterPropertyHelper(@TFileSearcherMaskSeparator_R,@TFileSearcherMaskSeparator_W,'MaskSeparator');
    RegisterPropertyHelper(@TFileSearcherFollowSymLink_R,@TFileSearcherFollowSymLink_W,'FollowSymLink');
    RegisterPropertyHelper(@TFileSearcherFileAttribute_R,@TFileSearcherFileAttribute_W,'FileAttribute');
    RegisterPropertyHelper(@TFileSearcherDirectoryAttribute_R,@TFileSearcherDirectoryAttribute_W,'DirectoryAttribute');
    RegisterPropertyHelper(@TFileSearcherOnDirectoryFound_R,@TFileSearcherOnDirectoryFound_W,'OnDirectoryFound');
    RegisterPropertyHelper(@TFileSearcherOnFileFound_R,@TFileSearcherOnFileFound_W,'OnFileFound');
    RegisterPropertyHelper(@TFileSearcherOnDirectoryEnter_R,@TFileSearcherOnDirectoryEnter_W,'OnDirectoryEnter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileIterator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileIterator) do begin
    RegisterMethod(@TFileIterator.Stop, 'Stop');
    RegisterMethod(@TFileIterator.IsDirectory, 'IsDirectory');
    RegisterPropertyHelper(@TFileIteratorFileName_R,nil,'FileName');
    RegisterPropertyHelper(@TFileIteratorFileInfo_R,nil,'FileInfo');
    RegisterPropertyHelper(@TFileIteratorLevel_R,nil,'Level');
    RegisterPropertyHelper(@TFileIteratorPath_R,nil,'Path');
    RegisterPropertyHelper(@TFileIteratorSearching_R,nil,'Searching');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FileUtil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CompareFilenames, 'lCompareFilenames', cdRegister);
 S.RegisterDelphiFunction(@CompareFilenamesIgnoreCase, 'lCompareFilenamesIgnoreCase', cdRegister);
 S.RegisterDelphiFunction(@CompareFilenames2, 'lCompareFilenames2', cdRegister);
 S.RegisterDelphiFunction(@CompareFilenamesP, 'lCompareFilenamesP', cdRegister);
 S.RegisterDelphiFunction(@FilenameIsAbsolute, 'lFilenameIsAbsolute', cdRegister);
 S.RegisterDelphiFunction(@FilenameIsWinAbsolute, 'lFilenameIsWinAbsolute', cdRegister);
 S.RegisterDelphiFunction(@FilenameIsUnixAbsolute, 'lFilenameIsUnixAbsolute', cdRegister);
 S.RegisterDelphiFunction(@CheckIfFileIsExecutable, 'lCheckIfFileIsExecutable', cdRegister);
 S.RegisterDelphiFunction(@CheckIfFileIsSymlink, 'lCheckIfFileIsSymlink', cdRegister);
 S.RegisterDelphiFunction(@FileIsReadable, 'lFileIsReadable', cdRegister);
 S.RegisterDelphiFunction(@FileIsWritable, 'lFileIsWritable', cdRegister);
 S.RegisterDelphiFunction(@FileIsText, 'lFileIsText', cdRegister);
 S.RegisterDelphiFunction(@FileIsText2, 'lFileIsText2', cdRegister);
 S.RegisterDelphiFunction(@FileIsExecutable, 'lFileIsExecutable', cdRegister);
 S.RegisterDelphiFunction(@FileIsSymlink, 'lFileIsSymlink', cdRegister);
 S.RegisterDelphiFunction(@FileIsHardLink, 'lFileIsHardLink', cdRegister);
 S.RegisterDelphiFunction(@FileSize, 'lFileSize', cdRegister);
 S.RegisterDelphiFunction(@GetFileDescription, 'lGetFileDescription', cdRegister);
 //S.RegisterDelphiFunction(@ReadAllLinks, 'ReadAllLinks', cdRegister);
 S.RegisterDelphiFunction(@TryReadAllLinks, 'lTryReadAllLinks', cdRegister);
 S.RegisterDelphiFunction(@DirPathExists, 'lDirPathExists', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectory, 'lForceDirectory', cdRegister);
 S.RegisterDelphiFunction(@DeleteDirectory, 'lDeleteDirectory', cdRegister);
 S.RegisterDelphiFunction(@ProgramDirectory, 'lProgramDirectory', cdRegister);
 S.RegisterDelphiFunction(@DirectoryIsWritable, 'lDirectoryIsWritable', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileNameOnly, 'lExtractFileNameOnly', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileNameWithoutExt, 'lExtractFileNameWithoutExt', cdRegister);
 S.RegisterDelphiFunction(@CompareFileExt, 'lCompareFileExt', cdRegister);
 //S.RegisterDelphiFunction(@CompareFileExt, 'CompareFileExt', cdRegister);
 S.RegisterDelphiFunction(@FilenameIsPascalUnit, 'lFilenameIsPascalUnit', cdRegister);
 S.RegisterDelphiFunction(@AppendPathDelim, 'lAppendPathDelim', cdRegister);
 S.RegisterDelphiFunction(@ChompPathDelim, 'lChompPathDelim', cdRegister);
 S.RegisterDelphiFunction(@TrimFilename, 'lTrimFilename', cdRegister);
 S.RegisterDelphiFunction(@CleanAndExpandFilename, 'lCleanAndExpandFilename', cdRegister);
 S.RegisterDelphiFunction(@CleanAndExpandDirectory, 'lCleanAndExpandDirectory', cdRegister);
 S.RegisterDelphiFunction(@CreateAbsoluteSearchPath, 'lCreateAbsoluteSearchPath', cdRegister);
 S.RegisterDelphiFunction(@CreateRelativePath, 'lCreateRelativePath', cdRegister);
 S.RegisterDelphiFunction(@CreateAbsolutePath, 'lCreateAbsolutePath', cdRegister);
 S.RegisterDelphiFunction(@FileIsInPath, 'lFileIsInPath', cdRegister);
 S.RegisterDelphiFunction(@FileIsInDirectory, 'lFileIsInDirectory', cdRegister);
 S.RegisterDelphiFunction(@GetAllFilesMask, 'lGetAllFilesMask', cdRegister);
 S.RegisterDelphiFunction(@GetExeExt, 'lGetExeExt', cdRegister);
 S.RegisterDelphiFunction(@SearchFileInPath, 'lSearchFileInPath', cdRegister);
 S.RegisterDelphiFunction(@SearchAllFilesInPath, 'lSearchAllFilesInPath', cdRegister);
 S.RegisterDelphiFunction(@FindDiskFilename, 'lFindDiskFilename', cdRegister);
 S.RegisterDelphiFunction(@FindDiskFileCaseInsensitive, 'lFindDiskFileCaseInsensitive', cdRegister);
 S.RegisterDelphiFunction(@FindDefaultExecutablePath, 'lFindDefaultExecutablePath', cdRegister);
 //S.RegisterDelphiFunction(@GetDarwinSystemFilename, 'GetDarwinSystemFilename', cdRegister);
 S.RegisterDelphiFunction(@FindAllFiles, 'lFindAllFiles', cdRegister);
 S.RegisterDelphiFunction(@FindAllDirectories, 'lFindAllDirectories', cdRegister);
 S.RegisterDelphiFunction(@CopyFile, 'lCopyFile', cdRegister);
 S.RegisterDelphiFunction(@CopyFile2, 'lCopyFile2', cdRegister);
 S.RegisterDelphiFunction(@CopyDirTree, 'lCopyDirTree', cdRegister);
 S.RegisterDelphiFunction(@ReadFileToString, 'lReadFileToString', cdRegister);
 S.RegisterDelphiFunction(@GetTempFilename, 'lGetTempFilename', cdRegister);
 //S.RegisterDelphiFunction(@NeedRTLAnsi, 'NeedRTLAnsi', cdRegister);
 {S.RegisterDelphiFunction(@SetNeedRTLAnsi, 'SetNeedRTLAnsi', cdRegister);
 S.RegisterDelphiFunction(@UTF8ToSys, 'UTF8ToSys', cdRegister);
 S.RegisterDelphiFunction(@SysToUTF8, 'SysToUTF8', cdRegister);
 S.RegisterDelphiFunction(@ConsoleToUTF8, 'ConsoleToUTF8', cdRegister);
 S.RegisterDelphiFunction(@UTF8ToConsole, 'UTF8ToConsole', cdRegister);  }
 S.RegisterDelphiFunction(@FileExistsUTF8, 'FileExistsUTF8', cdRegister);
 S.RegisterDelphiFunction(@FileAgeUTF8, 'FileAgeUTF8', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExistsUTF8, 'DirectoryExistsUTF8', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileNameUTF8, 'ExpandFileNameUTF8', cdRegister);
 S.RegisterDelphiFunction(@ExpandUNCFileNameUTF8, 'ExpandUNCFileNameUTF8', cdRegister);
 //S.RegisterDelphiFunction(@ExtractShortPathNameUTF8, 'ExtractShortPathNameUTF8', cdRegister);
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
 S.RegisterDelphiFunction(@FileCreateUTF81_P, 'FileCreateUTF81', cdRegister);
 //S.RegisterDelphiFunction(@ParamStrUTF8, 'ParamStrUTF8', cdRegister);
 //S.RegisterDelphiFunction(@GetEnvironmentStringUTF8, 'GetEnvironmentStringUTF8', cdRegister);
 //S.RegisterDelphiFunction(@GetEnvironmentVariableUTF8, 'GetEnvironmentVariableUTF8', cdRegister);
 S.RegisterDelphiFunction(@GetAppConfigDirUTF8, 'GetAppConfigDirUTF8', cdRegister);
 S.RegisterDelphiFunction(@GetAppConfigFileUTF8, 'GetAppConfigFileUTF8', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessageUTF8, 'SysErrorMessageUTF8', cdRegister);
end;

procedure RIRegister_FileUtil(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFileIterator(CL);
  RIRegister_TFileSearcher(CL);
end;


{ TPSImport_FileUtil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileUtil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FileUtil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileUtil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FileUtil(ri);
  RIRegister_FileUtil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
