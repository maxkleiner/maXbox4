unit uPSI_JclFileUtils_max;
{
   modern fs in os  map to Jx_  or Tx
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
  TPSImport_JclFileUtils_max = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclFileMaskComparator(CL: TPSPascalCompiler);
procedure SIRegister_TJclMappedTextReader(CL: TPSPascalCompiler);
procedure SIRegister_TJclFileMappingStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclSwapFileMapping(CL: TPSPascalCompiler);
procedure SIRegister_TJclFileMapping(CL: TPSPascalCompiler);
procedure SIRegister_TJclCustomFileMapping(CL: TPSPascalCompiler);
procedure SIRegister_TJclFileMappingView(CL: TPSPascalCompiler);
procedure SIRegister_TJclTempFileStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclFileVersionInfo(CL: TPSPascalCompiler);
procedure SIRegister_TJclFileEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_IJclFileEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_TJclFileAttributeMask(CL: TPSPascalCompiler);
procedure SIRegister_TJclCustomFileAttrMask(CL: TPSPascalCompiler);
procedure SIRegister_JclFileUtils_max(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJclFileMaskComparator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMappedTextReader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclFileMappingStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSwapFileMapping(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclFileMapping(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclCustomFileMapping(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclFileMappingView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclTempFileStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclFileVersionInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclFileEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclFileAttributeMask(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclCustomFileAttrMask(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclFileUtils_max_Routines(S: TPSExec);
procedure RIRegister_JclFileUtils_max(CL: TPSRuntimeClassImporter);


procedure Register;

implementation


uses
  // JclUnitVersioning
  Types
  //,Libc
  ,Windows
  ,JclBase_max
  ,JclFileUtils_max
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclFileUtils_max]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileMaskComparator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclFileMaskComparator') do
  with CL.AddClassN(CL.FindClass('TObject'),'TxJclFileMaskComparator') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
       RegisterMethod('Function Compare( const NameExt : string) : Boolean');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Exts', 'string Integer', iptr);
    RegisterProperty('FileMask', 'string', iptrw);
    RegisterProperty('Masks', 'string Integer', iptr);
    RegisterProperty('Names', 'string Integer', iptr);
    RegisterProperty('Separator', 'Char', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMappedTextReader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJclMappedTextReader') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TxJclMappedTextReader') do begin
    RegisterMethod('Constructor Create2( MemoryStream : TCustomMemoryStream; FreeStream : Boolean; const AIndexOption : TJclMappedTextReaderIndex);');
    RegisterMethod('Constructor Create3( const FileName : string; const AIndexOption : TJclMappedTextReaderIndex);');
    RegisterMethod('Procedure GoBegin');
      RegisterMethod('Procedure Free');
       RegisterMethod('Function Read : Char');
    RegisterMethod('Function ReadLn : string');
    RegisterProperty('AsString', 'string', iptr);
    RegisterProperty('Chars', 'Char Integer', iptr);
    RegisterProperty('Content', 'PChar', iptr);
    RegisterProperty('Eof', 'Boolean', iptr);
    RegisterProperty('IndexOption', 'TJclMappedTextReaderIndex', iptr);
    RegisterProperty('Lines', 'string Integer', iptr);
    RegisterProperty('LineCount', 'Integer', iptr);
    RegisterProperty('PositionFromLine', 'Integer Integer', iptr);
    RegisterProperty('Position', 'Integer', iptrw);
    RegisterProperty('Size', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileMappingStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMemoryStream', 'TJclFileMappingStream') do
  with CL.AddClassN(CL.FindClass('TCustomMemoryStream'),'TxJclFileMappingStream') do begin
    RegisterMethod('Constructor Create( const FileName : string; FileMode : WordfmShareDenyWrite)');
  RegisterMethod('Procedure Free');
     end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSwapFileMapping(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclCustomFileMapping', 'TJclSwapFileMapping') do
  with CL.AddClassN(CL.FindClass('TxJclCustomFileMapping'),'TxJclSwapFileMapping') do begin
    RegisterMethod('Constructor Create( const Name : string; Protect : Cardinal; const MaximumSize : Int64; SecAttr : PSecurityAttributes)');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileMapping(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclCustomFileMapping', 'TJclFileMapping') do
  with CL.AddClassN(CL.FindClass('TxJclCustomFileMapping'),'TxJclFileMapping') do begin
    RegisterMethod('Constructor Create( const FileName : string; FileMode : Cardinal; const Name : string; Protect : Cardinal; const MaximumSize : Int64; SecAttr : PSecurityAttributes);');
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create1( const FileHandle : THandle; const Name : string; Protect : Cardinal; const MaximumSize : Int64; SecAttr : PSecurityAttributes);');
    RegisterProperty('FileHandle', 'THandle', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclCustomFileMapping(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclCustomFileMapping') do
  with CL.AddClassN(CL.FindClass('TObject'),'TxJclCustomFileMapping') do begin
    RegisterMethod('Constructor Open( const Name : string; const InheritHandle : Boolean; const DesiredAccess : Cardinal)');
    RegisterMethod('Function Add( const Access, Count : Cardinal; const Offset : Int64) : Integer');
    RegisterMethod('Function AddAt( const Access, Count : Cardinal; const Offset : Int64; const Address : Pointer) : Integer');
    RegisterMethod('Procedure Delete( const Index : Integer)');
    RegisterMethod('Function IndexOf( const View : TJclFileMappingView) : Integer');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Existed', 'Boolean', iptr);
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('RoundViewOffset', 'TJclFileMappingRoundOffset', iptrw);
    RegisterProperty('Views', 'TJclFileMappingView Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileMappingView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMemoryStream', 'TJclFileMappingView') do
  with CL.AddClassN(CL.FindClass('TCustomMemoryStream'),'TxJclFileMappingView') do begin
  RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( const FileMap : TJclCustomFileMapping; Access, Size : Cardinal; ViewOffset : Int64)');
    RegisterMethod('Constructor CreateAt( FileMap : TJclCustomFileMapping; Access, Size : Cardinal; ViewOffset : Int64; Address : Pointer)');
    RegisterMethod('Function Flush( const Count : Cardinal) : Boolean');
    RegisterMethod('Procedure LoadFromStream( const Stream : TStream)');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterProperty('Index', 'Integer', iptr);
    RegisterProperty('FileMapping', 'TJclCustomFileMapping', iptr);
    RegisterProperty('Offset', 'Int64', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclTempFileStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THandleStream', 'TJclTempFileStream') do
  with CL.AddClassN(CL.FindClass('THandleStream'),'TxJclTempFileStream') do begin
    RegisterMethod('Constructor Create( const Prefix : string)');
      RegisterMethod('Procedure Free');
     RegisterProperty('FileName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileVersionInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclFileVersionInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TxJclFileVersionInfo') do begin
    RegisterMethod('Constructor Attach( VersionInfoData : Pointer; Size : Integer)');
    RegisterMethod('Constructor Create( const FileName : string)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function VersionLanguageId( const LangIdRec : TLangIdRec) : string');
    RegisterMethod('Function VersionLanguageName( const LangId : Word) : string');
    RegisterMethod('Function TranslationMatchesLanguages( Exact : Boolean) : Boolean');
    RegisterProperty('BinFileVersion', 'string', iptr);
    RegisterProperty('BinProductVersion', 'string', iptr);
    RegisterProperty('Comments', 'string', iptr);
    RegisterProperty('CompanyName', 'string', iptr);
    RegisterProperty('FileDescription', 'string', iptr);
    RegisterProperty('FixedInfo', 'TVSFixedFileInfo', iptr);
    RegisterProperty('FileFlags', 'TFileFlags', iptr);
    RegisterProperty('FileOS', 'DWORD', iptr);
    RegisterProperty('FileSubType', 'DWORD', iptr);
    RegisterProperty('FileType', 'DWORD', iptr);
    RegisterProperty('FileVersion', 'string', iptr);
    RegisterProperty('Items', 'TStrings', iptr);
    RegisterProperty('InternalName', 'string', iptr);
    RegisterProperty('LanguageCount', 'Integer', iptr);
    RegisterProperty('LanguageIds', 'string Integer', iptr);
    RegisterProperty('LanguageIndex', 'Integer', iptrw);
    RegisterProperty('Languages', 'TLangIdRec Integer', iptr);
    RegisterProperty('LanguageNames', 'string Integer', iptr);
    RegisterProperty('LegalCopyright', 'string', iptr);
    RegisterProperty('LegalTradeMarks', 'string', iptr);
    RegisterProperty('OriginalFilename', 'string', iptr);
    RegisterProperty('PrivateBuild', 'string', iptr);
    RegisterProperty('ProductName', 'string', iptr);
    RegisterProperty('ProductVersion', 'string', iptr);
    RegisterProperty('SpecialBuild', 'string', iptr);
    RegisterProperty('TranslationCount', 'Integer', iptr);
    RegisterProperty('Translations', 'TLangIdRec Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJclFileEnumerator') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJclFileEnumerator') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure AfterConstruction');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function FillList( List : TStrings) : TFileSearchTaskID');
    RegisterMethod('Function ForEach2( Handler : TFileHandler) : TFileSearchTaskID;');
    RegisterMethod('Function ForEach3( Handler : TFileHandlerEx) : TFileSearchTaskID;');
    RegisterMethod('Procedure StopTask( ID : TFileSearchTaskID)');
    RegisterMethod('Procedure StopAllTasks( Silently : Boolean)');
    RegisterProperty('FileMask', 'string', iptrw);
    RegisterProperty('IncludeSubDirectories', 'Boolean', iptrw);
    RegisterProperty('IncludeHiddenSubDirectories', 'Boolean', iptrw);
    RegisterProperty('SearchOption', 'Boolean TFileSearchOption', iptrw);
    RegisterProperty('LastChangeAfterAsString', 'string', iptrw);
    RegisterProperty('LastChangeBeforeAsString', 'string', iptrw);
    RegisterProperty('CaseSensitiveSearch', 'Boolean', iptrw);
    RegisterProperty('FileMasks', 'TStrings', iptrw);
    RegisterProperty('RootDirectory', 'string', iptrw);
    RegisterProperty('SubDirectoryMask', 'string', iptrw);
    RegisterProperty('AttributeMask', 'TJclFileAttributeMask', iptrw);
    RegisterProperty('FileSizeMin', 'Int64', iptrw);
    RegisterProperty('FileSizeMax', 'Int64', iptrw);
    RegisterProperty('LastChangeAfter', 'TDateTime', iptrw);
    RegisterProperty('LastChangeBefore', 'TDateTime', iptrw);
    RegisterProperty('Options', 'TFileSearchOptions', iptrw);
    RegisterProperty('RunningTasks', 'Integer', iptr);
    RegisterProperty('SynchronizationMode', 'TFileEnumeratorSyncMode', iptrw);
    RegisterProperty('OnEnterDirectory', 'TFileHandler', iptrw);
    RegisterProperty('OnTerminateTask', 'TFileSearchTerminationEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclFileEnumerator(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IJclFileEnumerator') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclFileEnumerator, 'IJclFileEnumerator') do
  begin
    RegisterMethod('Function GetAttributeMask : TJclFileAttributeMask', cdRegister);
    RegisterMethod('Function GetCaseSensitiveSearch : Boolean', cdRegister);
    RegisterMethod('Function GetRootDirectory : string', cdRegister);
    RegisterMethod('Function GetFileMask : string', cdRegister);
    RegisterMethod('Function GetFileMasks : TStrings', cdRegister);
    RegisterMethod('Function GetFileSizeMax : Int64', cdRegister);
    RegisterMethod('Function GetFileSizeMin : Int64', cdRegister);
    RegisterMethod('Function GetIncludeSubDirectories : Boolean', cdRegister);
    RegisterMethod('Function GetIncludeHiddenSubDirectories : Boolean', cdRegister);
    RegisterMethod('Function GetLastChangeAfter : TDateTime', cdRegister);
    RegisterMethod('Function GetLastChangeBefore : TDateTime', cdRegister);
    RegisterMethod('Function GetLastChangeAfterStr : string', cdRegister);
    RegisterMethod('Function GetLastChangeBeforeStr : string', cdRegister);
    RegisterMethod('Function GetRunningTasks : Integer', cdRegister);
    RegisterMethod('Function GetSubDirectoryMask : string', cdRegister);
    RegisterMethod('Function GetSynchronizationMode : TFileEnumeratorSyncMode', cdRegister);
    RegisterMethod('Function GetOnEnterDirectory : TFileHandler', cdRegister);
    RegisterMethod('Function GetOnTerminateTask : TFileSearchTerminationEvent', cdRegister);
    RegisterMethod('Function GetOption( const Option : TFileSearchOption) : Boolean', cdRegister);
    RegisterMethod('Function GetOptions : TFileSearchoptions', cdRegister);
    RegisterMethod('Procedure SetAttributeMask( const Value : TJclFileAttributeMask)', cdRegister);
    RegisterMethod('Procedure SetCaseSensitiveSearch( const Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SetRootDirectory( const Value : string)', cdRegister);
    RegisterMethod('Procedure SetFileMask( const Value : string)', cdRegister);
    RegisterMethod('Procedure SetFileMasks( const Value : TStrings)', cdRegister);
    RegisterMethod('Procedure SetFileSizeMax( const Value : Int64)', cdRegister);
    RegisterMethod('Procedure SetFileSizeMin( const Value : Int64)', cdRegister);
    RegisterMethod('Procedure SetIncludeSubDirectories( const Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SetIncludeHiddenSubDirectories( const Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SetLastChangeAfter( const Value : TDateTime)', cdRegister);
    RegisterMethod('Procedure SetLastChangeBefore( const Value : TDateTime)', cdRegister);
    RegisterMethod('Procedure SetLastChangeAfterStr( const Value : string)', cdRegister);
    RegisterMethod('Procedure SetLastChangeBeforeStr( const Value : string)', cdRegister);
    RegisterMethod('Procedure SetOption( const Option : TFileSearchOption; const Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SetOptions( const Value : TFileSearchOptions)', cdRegister);
    RegisterMethod('Procedure SetSubDirectoryMask( const Value : string)', cdRegister);
    RegisterMethod('Procedure SetSynchronizationMode( const Value : TFileEnumeratorSyncMode)', cdRegister);
    RegisterMethod('Procedure SetOnEnterDirectory( const Value : TFileHandler)', cdRegister);
    RegisterMethod('Procedure SetOnTerminateTask( const Value : TFileSearchTerminationEvent)', cdRegister);
    RegisterMethod('Function FillList( List : TStrings) : TFileSearchTaskID', cdRegister);
    RegisterMethod('Function ForEach( Handler : TFileHandler) : TFileSearchTaskID;', cdRegister);
    RegisterMethod('Function ForEach1( Handler : TFileHandlerEx) : TFileSearchTaskID;', cdRegister);
    RegisterMethod('Procedure StopTask( ID : TFileSearchTaskID)', cdRegister);
    RegisterMethod('Procedure StopAllTasks( Silently : Boolean)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileAttributeMask(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclCustomFileAttrMask', 'TJclFileAttributeMask') do
  with CL.AddClassN(CL.FindClass('TJclCustomFileAttrMask'),'TJclFileAttributeMask') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclCustomFileAttrMask(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJclCustomFileAttrMask') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJclCustomFileAttrMask') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Match( FileAttributes : Integer) : Boolean;');
    RegisterMethod('Function Match1( const FileInfo : TSearchRec) : Boolean;');
    RegisterProperty('Required', 'Integer', iptrw);
    RegisterProperty('Rejected', 'Integer', iptrw);
    RegisterProperty('Attribute', 'TAttributeInterest Integer', iptrw);
    SetDefaultPropery('Attribute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclFileUtils_max(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ERROR_NO_MORE_FILES','LongInt').SetInt( 18);
 //CL.AddDelphiFunction('Function stat64( FileName : PChar; var StatBuffer : TStatBuf64) : Integer');
 //CL.AddDelphiFunction('Function fstat64( FileDes : Integer; var StatBuffer : TStatBuf64) : Integer');
 //CL.AddDelphiFunction('Function lstat64( FileName : PChar; var StatBuffer : TStatBuf64) : Integer');
 CL.AddConstantN('LPathSeparator','String').SetString( '/');
 CL.AddConstantN('LDirDelimiter','String').SetString( '/');
 CL.AddConstantN('LDirSeparator','String').SetString( ':');
 CL.AddConstantN('JXPathDevicePrefix','String').SetString( '\\.\');
 CL.AddConstantN('JXPathSeparator','String').SetString( '\');
 CL.AddConstantN('JXDirDelimiter','String').SetString( '\');
 CL.AddConstantN('JXDirSeparator','String').SetString( ';');
 CL.AddConstantN('JXPathUncPrefix','String').SetString( '\\');
 CL.AddConstantN('faNormalFile','LongWord').SetUInt( $00000080);
 //CL.AddConstantN('faUnixSpecific','').SetString( faSymLink);
  CL.AddTypeS('JXTCompactPath', '( cpCenter, cpEnd )');
    CL.AddTypeS('_WIN32_FILE_ATTRIBUTE_DATA', 'record dwFileAttributes : DWORD; f'
   +'tCreationTime : TFileTime; ftLastAccessTime : TFileTime; ftLastWriteTime :'
   +' TFileTime; nFileSizeHigh : DWORD; nFileSizeLow : DWORD; end');
  CL.AddTypeS('TWin32FileAttributeData', '_WIN32_FILE_ATTRIBUTE_DATA');
  CL.AddTypeS('WIN32_FILE_ATTRIBUTE_DATA', '_WIN32_FILE_ATTRIBUTE_DATA');

 CL.AddDelphiFunction('Function jxPathAddSeparator( const Path : string) : string');
 CL.AddDelphiFunction('Function jxPathAddExtension( const Path, Extension : string) : string');
 CL.AddDelphiFunction('Function jxPathAppend( const Path, Append : string) : string');
 CL.AddDelphiFunction('Function jxPathBuildRoot( const Drive : Byte) : string');
 CL.AddDelphiFunction('Function jxPathCanonicalize( const Path : string) : string');
 CL.AddDelphiFunction('Function jxPathCommonPrefix( const Path1, Path2 : string) : Integer');
 CL.AddDelphiFunction('Function jxPathCompactPath( const DC : HDC; const Path : string; const Width : Integer; CmpFmt : TCompactPath) : string');
 CL.AddDelphiFunction('Procedure jxPathExtractElements( const Source : string; var Drive, Path, FileName, Ext : string)');
 CL.AddDelphiFunction('Function jxPathExtractFileDirFixed( const S : string) : string');
 CL.AddDelphiFunction('Function jxPathExtractFileNameNoExt( const Path : string) : string');
 CL.AddDelphiFunction('Function jxPathExtractPathDepth( const Path : string; Depth : Integer) : string');
 CL.AddDelphiFunction('Function jxPathGetDepth( const Path : string) : Integer');
 CL.AddDelphiFunction('Function jxPathGetLongName( const Path : string) : string');
 CL.AddDelphiFunction('Function jxPathGetShortName( const Path : string) : string');
 CL.AddDelphiFunction('Function jxPathGetLongName( const Path : string) : string');
 CL.AddDelphiFunction('Function jxPathGetShortName( const Path : string) : string');
 CL.AddDelphiFunction('Function jxPathGetRelativePath( Origin, Destination : string) : string');
 CL.AddDelphiFunction('Function jxPathGetTempPath : string');
 CL.AddDelphiFunction('Function PathGetTempPath : string');
 CL.AddDelphiFunction('Function jxPathIsAbsolute( const Path : string) : Boolean');
 CL.AddDelphiFunction('Function jxPathIsChild( const Path, Base : string) : Boolean');
 CL.AddDelphiFunction('Function jxPathIsDiskDevice( const Path : string) : Boolean');
 CL.AddDelphiFunction('Function jxPathIsUNC( const Path : string) : Boolean');
 CL.AddDelphiFunction('Function jxPathRemoveSeparator( const Path : string) : string');
 CL.AddDelphiFunction('Function jxPathRemoveExtension( const Path : string) : string');
 CL.AddDelphiFunction('Function jxPathGetPhysicalPath( const LocalizedPath : string) : string');
 CL.AddDelphiFunction('Function jxPathGetLocalizedPath( const PhysicalPath : string) : string');
  CL.AddTypeS('JxTFileListOption', '( flFullNames, flRecursive, flMaskedSubfolders)');
  CL.AddTypeS('JxTFileListOptions', 'set of TFileListOption');
  CL.AddTypeS('JxTJclAttributeMatch', '( amAny, amExact, amSubSetOf, amSuperSetOf, amCustom )');
  CL.AddTypeS('TFileHandler', 'Procedure ( const FileName : string)');
  CL.AddTypeS('TFileHandlerEx', 'Procedure ( const Directory : string; const FileInfo : TSearchRec)');
 CL.AddDelphiFunction('Function BuildFileList( const Path : string; const Attr : Integer; const List : TStrings) : Boolean');
 //CL.AddDelphiFunction('Function AdvBuildFileList( const Path : string; const Attr : Integer; const Files : TStrings; const AttributeMatch : TJclAttributeMatch; const Options : TFileListOptions; const SubfoldersMask : string; const FileMatchFunc : TFileMatchFunc) : Boolean');
 CL.AddDelphiFunction('Function jxVerifyFileAttributeMask( var RejectedAttributes, RequiredAttributes : Integer) : Boolean');
 CL.AddDelphiFunction('Function jxIsFileAttributeMatch( FileAttributes, RejectedAttributes, RequiredAttributes : Integer) : Boolean');
 CL.AddDelphiFunction('Function jxFileAttributesStr( const FileInfo : TSearchRec) : string');
 CL.AddDelphiFunction('Function jxIsFileNameMatch( FileName : string; const Mask : string; const CaseSensitive : Boolean) : Boolean');
 CL.AddDelphiFunction('Procedure jxEnumFiles( const Path : string; HandleFile : TFileHandlerEx; RejectedAttributes : Integer; RequiredAttributes : Integer; Abort : TObject)');
 CL.AddDelphiFunction('Procedure jxEnumDirectories( const Root : string; const HandleDirectory : TFileHandler; const IncludeHiddenDirectories : Boolean; const SubDirectoriesMask : string; Abort : TObject; ResolveSymLinks : Boolean)');
 CL.AddDelphiFunction('Procedure jxCreateEmptyFile( const FileName : string)');
 CL.AddDelphiFunction('Function jxCloseVolume( var Volume : THandle) : Boolean');
 CL.AddDelphiFunction('Function jxDeleteDirectory( const DirectoryName : string; MoveToRecycleBin : Boolean) : Boolean');
 CL.AddDelphiFunction('Function jxCopyDirectory( ExistingDirectoryName, NewDirectoryName : string) : Boolean');
 CL.AddDelphiFunction('Function jxMoveDirectory( ExistingDirectoryName, NewDirectoryName : string) : Boolean');
 CL.AddDelphiFunction('Function jxDelTree( const Path : string) : Boolean');
 //CL.AddDelphiFunction('Function DelTreeEx( const Path : string; AbortOnFailure : Boolean; Progress : TDelTreeProgress) : Boolean');
 CL.AddDelphiFunction('Function jxDiskInDrive( Drive : Char) : Boolean');
 CL.AddDelphiFunction('Function jxDirectoryExists( const Name : string; ResolveSymLinks : Boolean) : Boolean');
 CL.AddDelphiFunction('Function jxFileCreateTemp( var Prefix : string) : THandle');
 CL.AddDelphiFunction('Function jxFileBackup( const FileName : string; Move : Boolean) : Boolean');
 CL.AddDelphiFunction('Function jxFileCopy( const ExistingFileName, NewFileName : string; ReplaceExisting : Boolean) : Boolean');
 CL.AddDelphiFunction('Function jxFileDelete( const FileName : string; MoveToRecycleBin : Boolean) : Boolean');
 CL.AddDelphiFunction('Function jxFileExists( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function jxFileMove( const ExistingFileName, NewFileName : string; ReplaceExisting : Boolean) : Boolean');
 CL.AddDelphiFunction('Function jxFileRestore( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function jxGetBackupFileName( const FileName : string) : string');
 CL.AddDelphiFunction('Function jxIsBackupFileName( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function jxFileGetDisplayName( const FileName : string) : string');
 CL.AddDelphiFunction('Function jxFileGetGroupName( const FileName : string; ResolveSymLinks : Boolean) : string');
 CL.AddDelphiFunction('Function jxFileGetOwnerName( const FileName : string; ResolveSymLinks : Boolean) : string');
 CL.AddDelphiFunction('Function jxFileGetSize( const FileName : string) : Int64');
 CL.AddDelphiFunction('Function jxFileGetTempName( const Prefix : string) : string');
 CL.AddDelphiFunction('Function jxFileGetTypeName( const FileName : string) : string');
 CL.AddDelphiFunction('Function jxFindUnusedFileName( FileName : string; const FileExt : string; NumberPrefix : string) : string');
 CL.AddDelphiFunction('Function jxForceDirectories( Name : string) : Boolean');
 CL.AddDelphiFunction('Function jxGetDirectorySize( const Path : string) : Int64');
 CL.AddDelphiFunction('Function jxGetDriveTypeStr( const Drive : Char) : string');
 CL.AddDelphiFunction('Function jxGetFileAgeCoherence( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Procedure jxGetFileAttributeList( const Items : TStrings; const Attr : Integer)');
 CL.AddDelphiFunction('Procedure jxGetFileAttributeListEx( const Items : TStrings; const Attr : Integer)');
 CL.AddDelphiFunction('Function jxGetFileInformation( const FileName : string; out FileInfo : TSearchRec) : Boolean;');
 CL.AddDelphiFunction('Function jxGetFileInformation1( const FileName : string) : TSearchRec;');
 //CL.AddDelphiFunction('Function GetFileStatus( const FileName : string; out StatBuf : TStatBuf64; const ResolveSymLinks : Boolean) : Integer');
 CL.AddDelphiFunction('Function jxGetFileLastWrite( const FileName : string) : TFileTime;');
 CL.AddDelphiFunction('Function jxGetFileLastWrite1( const FileName : string; out LocalTime : TDateTime) : Boolean;');
 CL.AddDelphiFunction('Function jxGetFileLastAccess( const FileName : string) : TFileTime;');
 CL.AddDelphiFunction('Function jxGetFileLastAccess1( const FileName : string; out LocalTime : TDateTime) : Boolean;');
 CL.AddDelphiFunction('Function jxGetFileCreation( const FileName : string) : TFileTime;');
 CL.AddDelphiFunction('Function jxGetFileCreation1( const FileName : string; out LocalTime : TDateTime) : Boolean;');
 CL.AddDelphiFunction('Function jxGetFileLastWrite( const FileName : string; out TimeStamp : Integer; ResolveSymLinks : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function jxGetFileLastWrite1( const FileName : string; out LocalTime : TDateTime; ResolveSymLinks : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function jxGetFileLastWrite2( const FileName : string; ResolveSymLinks : Boolean) : Integer;');
 CL.AddDelphiFunction('Function jxGetFileLastAccess( const FileName : string; out TimeStamp : Integer; ResolveSymLinks : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function jxGetFileLastAccess1( const FileName : string; out LocalTime : TDateTime; ResolveSymLinks : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function jxGetFileLastAccess2( const FileName : string; ResolveSymLinks : Boolean) : Integer;');
 CL.AddDelphiFunction('Function jxGetFileLastAttrChange( const FileName : string; out TimeStamp : Integer; ResolveSymLinks : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function jxGetFileLastAttrChange1( const FileName : string; out LocalTime : TDateTime; ResolveSymLinks : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function jxGetFileLastAttrChange2( const FileName : string; ResolveSymLinks : Boolean) : Integer;');
 CL.AddDelphiFunction('Function jxGetModulePath( const Module : HMODULE) : string');
 CL.AddDelphiFunction('Function jxGetSizeOfFile( const FileName : string) : Int64;');
 CL.AddDelphiFunction('Function jxGetSizeOfFile1( const FileInfo : TSearchRec) : Int64;');
 CL.AddDelphiFunction('Function jxGetSizeOfFile2( Handle : THandle) : Int64;');
 CL.AddDelphiFunction('Function jxGetStandardFileInfo( const FileName : string) : TWin32FileAttributeData');
 CL.AddDelphiFunction('Function jxIsDirectory( const FileName : string; ResolveSymLinks : Boolean) : Boolean');
 CL.AddDelphiFunction('Function jxIsRootDirectory( const CanonicFileName : string) : Boolean');
 CL.AddDelphiFunction('Function jxLockVolume( const Volume : string; var Handle : THandle) : Boolean');
 CL.AddDelphiFunction('Function jxOpenVolume( const Drive : Char) : THandle');
 CL.AddDelphiFunction('Function jxSetDirLastWrite( const DirName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function jxSetDirLastAccess( const DirName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function jxSetDirCreation( const DirName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function jxSetFileLastWrite( const FileName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function jxSetFileLastAccess( const FileName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function jxSetFileCreation( const FileName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Procedure jxShredFile( const FileName : string; Times : Integer)');
 CL.AddDelphiFunction('Function jxUnlockVolume( var Handle : THandle) : Boolean');
 CL.AddDelphiFunction('Function jxCreateSymbolicLink( const Name, Target : string) : Boolean');
 CL.AddDelphiFunction('Function jxSymbolicLinkTarget( const Name : string) : string');
  CL.AddTypeS('TAttributeInterest', '( aiIgnored, aiRejected, aiRequired )');
  SIRegister_TJclCustomFileAttrMask(CL);
  SIRegister_TJclFileAttributeMask(CL);
  CL.AddTypeS('TFileSearchOption', '( fsIncludeSubDirectories, fsIncludeHiddenS'
   +'ubDirectories, fsLastChangeAfter, fsLastChangeBefore, fsMaxSize, fsMinSize)');
  CL.AddTypeS('TFileSearchOptions', 'set of TFileSearchOption');
  CL.AddTypeS('TFileSearchTaskID', 'Integer');
  CL.AddTypeS('TFileSearchTerminationEvent', 'Procedure ( const ID : TFileSearc'
   +'hTaskID; const Aborted : Boolean)');
  CL.AddTypeS('TFileEnumeratorSyncMode', '( smPerFile, smPerDirectory )');
  SIRegister_IJclFileEnumerator(CL);
  SIRegister_TJclFileEnumerator(CL);
 CL.AddDelphiFunction('Function JxFileSearch : IJclFileEnumerator');
  CL.AddTypeS('JxTFileFlag', '( ffDebug, ffInfoInferred, ffPatched, ffPreRelease, ffPrivateBuild, ffSpecialBuild )');
  CL.AddTypeS('JxTFileFlags', 'set of TFileFlag');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclFileVersionInfoError');
  SIRegister_TJclFileVersionInfo(CL);
 CL.AddDelphiFunction('Function jxOSIdentToString( const OSIdent : DWORD) : string');
 CL.AddDelphiFunction('Function jxOSFileTypeToString( const OSFileType : DWORD; const OSFileSubType : DWORD) : string');
 CL.AddDelphiFunction('Function jxVersionResourceAvailable( const FileName : string) : Boolean');
  CL.AddTypeS('TFileVersionFormat', '( vfMajorMinor, vfFull )');
 CL.AddDelphiFunction('Function jxFormatVersionString( const HiV, LoV : Word) : string;');
 CL.AddDelphiFunction('Function jxFormatVersionString1( const Major, Minor, Build, Revision : Word) : string;');
 //CL.AddDelphiFunction('Function FormatVersionString2( const FixedInfo : TVSFixedFileInfo; VersionFormat : TFileVersionFormat) : string;');
 //CL.AddDelphiFunction('Procedure VersionExtractFileInfo( const FixedInfo : TVSFixedFileInfo; var Major, Minor, Build, Revision : Word)');
 //CL.AddDelphiFunction('Procedure VersionExtractProductInfo( const FixedInfo : TVSFixedFileInfo; var Major, Minor, Build, Revision : Word)');
 //CL.AddDelphiFunction('Function VersionFixedFileInfo( const FileName : string; var FixedInfo : TVSFixedFileInfo) : Boolean');
 CL.AddDelphiFunction('Function jxVersionFixedFileInfoString( const FileName : string; VersionFormat : TFileVersionFormat; const NotAvailableText : string) : string');
  SIRegister_TJclTempFileStream(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclCustomFileMapping');
  SIRegister_TJclFileMappingView(CL);
  CL.AddTypeS('TJclFileMappingRoundOffset', '( rvDown, rvUp )');
  SIRegister_TJclCustomFileMapping(CL);
  SIRegister_TJclFileMapping(CL);
  SIRegister_TJclSwapFileMapping(CL);
  SIRegister_TJclFileMappingStream(CL);
  CL.AddTypeS('TJclMappedTextReaderIndex', '( tiNoIndex, tiFull )');
  //CL.AddTypeS('PPCharArray', '^TPCharArray // will not work');
  SIRegister_TJclMappedTextReader(CL);
  SIRegister_TJclFileMaskComparator(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclPathError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclFileUtilsError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclTempFileStreamError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclTempFileStreamError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclFileMappingError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclFileMappingViewError');
 CL.AddDelphiFunction('Function jxPathGetLongName2( const Path : string) : string');
 CL.AddDelphiFunction('Function jxWin32DeleteFile( const FileName : string; MoveToRecycleBin : Boolean) : Boolean');
 CL.AddDelphiFunction('Function jxWin32MoveFileReplaceExisting( const SrcFileName, DstFileName : string) : Boolean');
 CL.AddDelphiFunction('Function jxWin32BackupFile( const FileName : string; Move : Boolean) : Boolean');
 CL.AddDelphiFunction('Function jxWin32RestoreFile( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function jxSamePath( const Path1, Path2 : string) : Boolean');
 CL.AddDelphiFunction('Procedure jxPathListAddItems( var List : string; const Items : string)');
 CL.AddDelphiFunction('Procedure jxPathListIncludeItems( var List : string; const Items : string)');
 CL.AddDelphiFunction('Procedure jxPathListDelItems( var List : string; const Items : string)');
 CL.AddDelphiFunction('Procedure jxPathListDelItem( var List : string; const Index : Integer)');
 CL.AddDelphiFunction('Function jxPathListItemCount( const List : string) : Integer');
 CL.AddDelphiFunction('Function jxPathListGetItem( const List : string; const Index : Integer) : string');
 CL.AddDelphiFunction('Procedure jxPathListSetItem( var List : string; const Index : Integer; const Value : string)');
 CL.AddDelphiFunction('Function jxPathListItemIndex( const List, Item : string) : Integer');
 CL.AddDelphiFunction('Function jxParamName( Index : Integer; const Separator : string; const AllowedPrefixCharacters : string; TrimName : Boolean) : string');
 CL.AddDelphiFunction('Function jxParamValue( Index : Integer; const Separator : string; TrimValue : Boolean) : string;');
 CL.AddDelphiFunction('Function jxParamValue1( const SearchName : string; const Separator : string; CaseSensitive : Boolean; const AllowedPrefixCharacters : string; TrimValue : Boolean) : string;');
 CL.AddDelphiFunction('Function jxParamPos( const SearchName : string; const Separator : string; CaseSensitive : Boolean; const AllowedPrefixCharacters : string) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ParamValue1_P( const SearchName : string; const Separator : string; CaseSensitive : Boolean; const AllowedPrefixCharacters : string; TrimValue : Boolean) : string;
Begin Result := JclFileUtils_max.ParamValue(SearchName, Separator, CaseSensitive, AllowedPrefixCharacters, TrimValue); END;

(*----------------------------------------------------------------------------*)
Function ParamValue_P( Index : Integer; const Separator : string; TrimValue : Boolean) : string;
Begin Result := JclFileUtils_max.ParamValue(Index, Separator, TrimValue); END;

(*----------------------------------------------------------------------------*)
procedure TJclFileMaskComparatorSeparator_W(Self: TJclFileMaskComparator; const T: Char);
begin Self.Separator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileMaskComparatorSeparator_R(Self: TJclFileMaskComparator; var T: Char);
begin T := Self.Separator; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileMaskComparatorNames_R(Self: TJclFileMaskComparator; var T: string; const t1: Integer);
begin T := Self.Names[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileMaskComparatorMasks_R(Self: TJclFileMaskComparator; var T: string; const t1: Integer);
begin T := Self.Masks[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileMaskComparatorFileMask_W(Self: TJclFileMaskComparator; const T: string);
begin Self.FileMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileMaskComparatorFileMask_R(Self: TJclFileMaskComparator; var T: string);
begin T := Self.FileMask; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileMaskComparatorExts_R(Self: TJclFileMaskComparator; var T: string; const t1: Integer);
begin T := Self.Exts[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileMaskComparatorCount_R(Self: TJclFileMaskComparator; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclMappedTextReaderSize_R(Self: TJclMappedTextReader; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TJclMappedTextReaderPosition_W(Self: TJclMappedTextReader; const T: Integer);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMappedTextReaderPosition_R(Self: TJclMappedTextReader; var T: Integer);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TJclMappedTextReaderPositionFromLine_R(Self: TJclMappedTextReader; var T: Integer; const t1: Integer);
begin T := Self.PositionFromLine[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMappedTextReaderLineCount_R(Self: TJclMappedTextReader; var T: Integer);
begin T := Self.LineCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclMappedTextReaderLines_R(Self: TJclMappedTextReader; var T: string; const t1: Integer);
begin T := Self.Lines[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMappedTextReaderIndexOption_R(Self: TJclMappedTextReader; var T: TJclMappedTextReaderIndex);
begin T := Self.IndexOption; end;

(*----------------------------------------------------------------------------*)
procedure TJclMappedTextReaderEof_R(Self: TJclMappedTextReader; var T: Boolean);
begin T := Self.Eof; end;

(*----------------------------------------------------------------------------*)
procedure TJclMappedTextReaderContent_R(Self: TJclMappedTextReader; var T: PChar);
begin T := Self.Content; end;

(*----------------------------------------------------------------------------*)
procedure TJclMappedTextReaderChars_R(Self: TJclMappedTextReader; var T: Char; const t1: Integer);
begin T := Self.Chars[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMappedTextReaderAsString_R(Self: TJclMappedTextReader; var T: string);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
Function TJclMappedTextReaderCreate3_P(Self: TClass; CreateNewInstance: Boolean;  const FileName : string; const AIndexOption : TJclMappedTextReaderIndex):TObject;
Begin Result := TJclMappedTextReader.Create(FileName, AIndexOption); END;

(*----------------------------------------------------------------------------*)
Function TJclMappedTextReaderCreate2_P(Self: TClass; CreateNewInstance: Boolean;  MemoryStream : TCustomMemoryStream; FreeStream : Boolean; const AIndexOption : TJclMappedTextReaderIndex):TObject;
Begin Result := TJclMappedTextReader.Create(MemoryStream, FreeStream, AIndexOption); END;

(*----------------------------------------------------------------------------*)
procedure TJclFileMappingFileHandle_R(Self: TJclFileMapping; var T: THandle);
begin T := Self.FileHandle; end;

(*----------------------------------------------------------------------------*)
Function TJclFileMappingCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const FileHandle : THandle; const Name : string; Protect : Cardinal; const MaximumSize : Int64; SecAttr : PSecurityAttributes):TObject;
Begin Result := TJclFileMapping.Create(FileHandle, Name, Protect, MaximumSize, SecAttr); END;

(*----------------------------------------------------------------------------*)
Function TJclFileMappingCreate_P(Self: TClass; CreateNewInstance: Boolean;  const FileName : string; FileMode : Cardinal; const Name : string; Protect : Cardinal; const MaximumSize : Int64; SecAttr : PSecurityAttributes):TObject;
Begin Result := TJclFileMapping.Create(FileName, FileMode, Name, Protect, MaximumSize, SecAttr); END;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileMappingViews_R(Self: TJclCustomFileMapping; var T: TJclFileMappingView; const t1: Integer);
begin T := Self.Views[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileMappingRoundViewOffset_W(Self: TJclCustomFileMapping; const T: TJclFileMappingRoundOffset);
begin Self.RoundViewOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileMappingRoundViewOffset_R(Self: TJclCustomFileMapping; var T: TJclFileMappingRoundOffset);
begin T := Self.RoundViewOffset; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileMappingName_R(Self: TJclCustomFileMapping; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileMappingHandle_R(Self: TJclCustomFileMapping; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileMappingExisted_R(Self: TJclCustomFileMapping; var T: Boolean);
begin T := Self.Existed; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileMappingCount_R(Self: TJclCustomFileMapping; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileMappingViewOffset_R(Self: TJclFileMappingView; var T: Int64);
begin T := Self.Offset; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileMappingViewFileMapping_R(Self: TJclFileMappingView; var T: TJclCustomFileMapping);
begin T := Self.FileMapping; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileMappingViewIndex_R(Self: TJclFileMappingView; var T: Integer);
begin T := Self.Index; end;

(*----------------------------------------------------------------------------*)
procedure TJclTempFileStreamFileName_R(Self: TJclTempFileStream; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
Function FormatVersionString2_P( const FixedInfo : TVSFixedFileInfo; VersionFormat : TFileVersionFormat) : string;
Begin Result := JclFileUtils_max.FormatVersionString(FixedInfo, VersionFormat); END;

(*----------------------------------------------------------------------------*)
Function FormatVersionString1_P( const Major, Minor, Build, Revision : Word) : string;
Begin Result := JclFileUtils_max.FormatVersionString(Major, Minor, Build, Revision); END;

(*----------------------------------------------------------------------------*)
Function FormatVersionString_P( const HiV, LoV : Word) : string;
Begin Result := JclFileUtils_max.FormatVersionString(HiV, LoV); END;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoTranslations_R(Self: TJclFileVersionInfo; var T: TLangIdRec; const t1: Integer);
begin T := Self.Translations[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoTranslationCount_R(Self: TJclFileVersionInfo; var T: Integer);
begin T := Self.TranslationCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoSpecialBuild_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.SpecialBuild; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoProductVersion_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.ProductVersion; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoProductName_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.ProductName; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoPrivateBuild_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.PrivateBuild; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoOriginalFilename_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.OriginalFilename; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoLegalTradeMarks_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.LegalTradeMarks; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoLegalCopyright_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.LegalCopyright; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoLanguageNames_R(Self: TJclFileVersionInfo; var T: string; const t1: Integer);
begin T := Self.LanguageNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoLanguages_R(Self: TJclFileVersionInfo; var T: TLangIdRec; const t1: Integer);
begin T := Self.Languages[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoLanguageIndex_W(Self: TJclFileVersionInfo; const T: Integer);
begin Self.LanguageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoLanguageIndex_R(Self: TJclFileVersionInfo; var T: Integer);
begin T := Self.LanguageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoLanguageIds_R(Self: TJclFileVersionInfo; var T: string; const t1: Integer);
begin T := Self.LanguageIds[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoLanguageCount_R(Self: TJclFileVersionInfo; var T: Integer);
begin T := Self.LanguageCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoInternalName_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.InternalName; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoItems_R(Self: TJclFileVersionInfo; var T: TStrings);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoFileVersion_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.FileVersion; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoFileType_R(Self: TJclFileVersionInfo; var T: DWORD);
begin T := Self.FileType; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoFileSubType_R(Self: TJclFileVersionInfo; var T: DWORD);
begin T := Self.FileSubType; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoFileOS_R(Self: TJclFileVersionInfo; var T: DWORD);
begin T := Self.FileOS; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoFileFlags_R(Self: TJclFileVersionInfo; var T: TFileFlags);
begin T := Self.FileFlags; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoFixedInfo_R(Self: TJclFileVersionInfo; var T: TVSFixedFileInfo);
begin T := Self.FixedInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoFileDescription_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.FileDescription; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoCompanyName_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.CompanyName; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoComments_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.Comments; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoBinProductVersion_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.BinProductVersion; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileVersionInfoBinFileVersion_R(Self: TJclFileVersionInfo; var T: string);
begin T := Self.BinFileVersion; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorOnTerminateTask_W(Self: TJclFileEnumerator; const T: TFileSearchTerminationEvent);
begin Self.OnTerminateTask := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorOnTerminateTask_R(Self: TJclFileEnumerator; var T: TFileSearchTerminationEvent);
begin T := Self.OnTerminateTask; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorOnEnterDirectory_W(Self: TJclFileEnumerator; const T: TFileHandler);
begin Self.OnEnterDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorOnEnterDirectory_R(Self: TJclFileEnumerator; var T: TFileHandler);
begin T := Self.OnEnterDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorSynchronizationMode_W(Self: TJclFileEnumerator; const T: TFileEnumeratorSyncMode);
begin Self.SynchronizationMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorSynchronizationMode_R(Self: TJclFileEnumerator; var T: TFileEnumeratorSyncMode);
begin T := Self.SynchronizationMode; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorRunningTasks_R(Self: TJclFileEnumerator; var T: Integer);
begin T := Self.RunningTasks; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorOptions_W(Self: TJclFileEnumerator; const T: TFileSearchOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorOptions_R(Self: TJclFileEnumerator; var T: TFileSearchOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorLastChangeBefore_W(Self: TJclFileEnumerator; const T: TDateTime);
begin Self.LastChangeBefore := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorLastChangeBefore_R(Self: TJclFileEnumerator; var T: TDateTime);
begin T := Self.LastChangeBefore; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorLastChangeAfter_W(Self: TJclFileEnumerator; const T: TDateTime);
begin Self.LastChangeAfter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorLastChangeAfter_R(Self: TJclFileEnumerator; var T: TDateTime);
begin T := Self.LastChangeAfter; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorFileSizeMax_W(Self: TJclFileEnumerator; const T: Int64);
begin Self.FileSizeMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorFileSizeMax_R(Self: TJclFileEnumerator; var T: Int64);
begin T := Self.FileSizeMax; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorFileSizeMin_W(Self: TJclFileEnumerator; const T: Int64);
begin Self.FileSizeMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorFileSizeMin_R(Self: TJclFileEnumerator; var T: Int64);
begin T := Self.FileSizeMin; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorAttributeMask_W(Self: TJclFileEnumerator; const T: TJclFileAttributeMask);
begin Self.AttributeMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorAttributeMask_R(Self: TJclFileEnumerator; var T: TJclFileAttributeMask);
begin T := Self.AttributeMask; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorSubDirectoryMask_W(Self: TJclFileEnumerator; const T: string);
begin Self.SubDirectoryMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorSubDirectoryMask_R(Self: TJclFileEnumerator; var T: string);
begin T := Self.SubDirectoryMask; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorRootDirectory_W(Self: TJclFileEnumerator; const T: string);
begin Self.RootDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorRootDirectory_R(Self: TJclFileEnumerator; var T: string);
begin T := Self.RootDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorFileMasks_W(Self: TJclFileEnumerator; const T: TStrings);
begin Self.FileMasks := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorFileMasks_R(Self: TJclFileEnumerator; var T: TStrings);
begin T := Self.FileMasks; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorCaseSensitiveSearch_W(Self: TJclFileEnumerator; const T: Boolean);
begin Self.CaseSensitiveSearch := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorCaseSensitiveSearch_R(Self: TJclFileEnumerator; var T: Boolean);
begin T := Self.CaseSensitiveSearch; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorLastChangeBeforeAsString_W(Self: TJclFileEnumerator; const T: string);
begin Self.LastChangeBeforeAsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorLastChangeBeforeAsString_R(Self: TJclFileEnumerator; var T: string);
begin T := Self.LastChangeBeforeAsString; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorLastChangeAfterAsString_W(Self: TJclFileEnumerator; const T: string);
begin Self.LastChangeAfterAsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorLastChangeAfterAsString_R(Self: TJclFileEnumerator; var T: string);
begin T := Self.LastChangeAfterAsString; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorSearchOption_W(Self: TJclFileEnumerator; const T: Boolean; const t1: TFileSearchOption);
begin Self.SearchOption[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorSearchOption_R(Self: TJclFileEnumerator; var T: Boolean; const t1: TFileSearchOption);
begin T := Self.SearchOption[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorIncludeHiddenSubDirectories_W(Self: TJclFileEnumerator; const T: Boolean);
begin Self.IncludeHiddenSubDirectories := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorIncludeHiddenSubDirectories_R(Self: TJclFileEnumerator; var T: Boolean);
begin T := Self.IncludeHiddenSubDirectories; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorIncludeSubDirectories_W(Self: TJclFileEnumerator; const T: Boolean);
begin Self.IncludeSubDirectories := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorIncludeSubDirectories_R(Self: TJclFileEnumerator; var T: Boolean);
begin T := Self.IncludeSubDirectories; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorFileMask_W(Self: TJclFileEnumerator; const T: string);
begin Self.FileMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileEnumeratorFileMask_R(Self: TJclFileEnumerator; var T: string);
begin T := Self.FileMask; end;

(*----------------------------------------------------------------------------*)
Function TJclFileEnumeratorForEach3_P(Self: TJclFileEnumerator;  Handler : TFileHandlerEx) : TFileSearchTaskID;
Begin Result := Self.ForEach(Handler); END;

(*----------------------------------------------------------------------------*)
Function TJclFileEnumeratorForEach2_P(Self: TJclFileEnumerator;  Handler : TFileHandler) : TFileSearchTaskID;
Begin Result := Self.ForEach(Handler); END;

(*----------------------------------------------------------------------------*)
Function IJclFileEnumeratorForEach1_P(Self: IJclFileEnumerator;  Handler : TFileHandlerEx) : TFileSearchTaskID;
Begin Result := Self.ForEach(Handler); END;

(*----------------------------------------------------------------------------*)
Function IJclFileEnumeratorForEach_P(Self: IJclFileEnumerator;  Handler : TFileHandler) : TFileSearchTaskID;
Begin Result := Self.ForEach(Handler); END;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileAttrMaskAttribute_W(Self: TJclCustomFileAttrMask; const T: TAttributeInterest; const t1: Integer);
begin Self.Attribute[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileAttrMaskAttribute_R(Self: TJclCustomFileAttrMask; var T: TAttributeInterest; const t1: Integer);
begin T := Self.Attribute[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileAttrMaskRejected_W(Self: TJclCustomFileAttrMask; const T: Integer);
begin Self.Rejected := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileAttrMaskRejected_R(Self: TJclCustomFileAttrMask; var T: Integer);
begin T := Self.Rejected; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileAttrMaskRequired_W(Self: TJclCustomFileAttrMask; const T: Integer);
begin Self.Required := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomFileAttrMaskRequired_R(Self: TJclCustomFileAttrMask; var T: Integer);
begin T := Self.Required; end;

(*----------------------------------------------------------------------------*)
Function TJclCustomFileAttrMaskMatch1_P(Self: TJclCustomFileAttrMask;  const FileInfo : TSearchRec) : Boolean;
Begin Result := Self.Match(FileInfo); END;

(*----------------------------------------------------------------------------*)
Function TJclCustomFileAttrMaskMatch_P(Self: TJclCustomFileAttrMask;  FileAttributes : Integer) : Boolean;
Begin Result := Self.Match(FileAttributes); END;

(*----------------------------------------------------------------------------*)
Function GetSizeOfFile2_P( Handle : THandle) : Int64;
Begin Result := JclFileUtils_max.GetSizeOfFile(Handle); END;

(*----------------------------------------------------------------------------*)
Function GetSizeOfFile1_P( const FileInfo : TSearchRec) : Int64;
Begin Result := JclFileUtils_max.GetSizeOfFile(FileInfo); END;

(*----------------------------------------------------------------------------*)
Function GetSizeOfFile_P( const FileName : string) : Int64;
Begin Result := JclFileUtils_max.GetSizeOfFile(FileName); END;

(*----------------------------------------------------------------------------*)
Function GetFileLastAttrChange2_P( const FileName : string; ResolveSymLinks : Boolean) : Integer;
Begin //Result := //JclFileUtils_max.GetFileLastAttrChange(FileName, ResolveSymLinks);
END;

(*----------------------------------------------------------------------------*)
Function GetFileLastAttrChange1_P( const FileName : string; out LocalTime : TDateTime; ResolveSymLinks : Boolean) : Boolean;
Begin //Result := JclFileUtils_max.GetFileLastAttrChange(FileName, LocalTime, ResolveSymLinks);
END;

(*----------------------------------------------------------------------------*)
Function GetFileLastAttrChange_P( const FileName : string; out TimeStamp : Integer; ResolveSymLinks : Boolean) : Boolean;
Begin //Result := JclFileUtils_max.GetFileLastAttrChange(FileName, TimeStamp, ResolveSymLinks);
END;

(*----------------------------------------------------------------------------*)
Function GetFileLastAccess2_P( const FileName : string; ResolveSymLinks : Boolean) : Integer;
Begin //Result := JclFileUtils_max.GetFileLastAccess(FileName, ResolveSymLinks);
END;

(*----------------------------------------------------------------------------*)
Function GetFileLastAccess1_P( const FileName : string; out LocalTime : TDateTime; ResolveSymLinks : Boolean) : Boolean;
Begin //Result := JclFileUtils_max.GetFileLastAccess(FileName, LocalTime, ResolveSymLinks);
END;

(*----------------------------------------------------------------------------*)
Function GetFileLastAccess_P( const FileName : string; out TimeStamp : Integer; ResolveSymLinks : Boolean) : Boolean;
Begin //Result := JclFileUtils_max.GetFileLastAccess(FileName, TimeStamp, ResolveSymLinks);
END;

(*----------------------------------------------------------------------------*)
Function GetFileLastWrite2( const FileName : string; ResolveSymLinks : Boolean) : Integer;
Begin //Result := JclFileUtils_max.GetFileLastWrite(FileName, ResolveSymLinks);
END;

(*----------------------------------------------------------------------------*)
Function GetFileLastWrite1_P( const FileName : string; out LocalTime : TDateTime; ResolveSymLinks : Boolean) : Boolean;
Begin //Result := JclFileUtils_max.GetFileLastWrite(FileName, LocalTime, ResolveSymLinks);
END;

(*----------------------------------------------------------------------------*)
Function GetFileLastWrite_P( const FileName : string; out TimeStamp : Integer; ResolveSymLinks : Boolean) : Boolean;
Begin //Result := JclFileUtils_max.GetFileLastWrite(FileName, TimeStamp, ResolveSymLinks);
END;

(*----------------------------------------------------------------------------*)
Function GetFileCreation1_P( const FileName : string; out LocalTime : TDateTime) : Boolean;
Begin Result := JclFileUtils_max.GetFileCreation(FileName, LocalTime); END;

(*----------------------------------------------------------------------------*)
Function GetFileCreation_P( const FileName : string) : TFileTime;
Begin Result := JclFileUtils_max.GetFileCreation(FileName); END;

(*----------------------------------------------------------------------------*)
Function GetFileLastAccess3_P( const FileName : string; out LocalTime : TDateTime) : Boolean;
Begin Result := JclFileUtils_max.GetFileLastAccess(FileName, LocalTime); END;

(*----------------------------------------------------------------------------*)
Function GetFileLastAccess( const FileName : string) : TFileTime;
Begin Result := JclFileUtils_max.GetFileLastAccess(FileName); END;

(*----------------------------------------------------------------------------*)
Function GetFileLastWrite3_P( const FileName : string; out LocalTime : TDateTime) : Boolean;
Begin Result := JclFileUtils_max.GetFileLastWrite(FileName, LocalTime); END;

(*----------------------------------------------------------------------------*)
Function GetFileLastWrite( const FileName : string) : TFileTime;
Begin Result := JclFileUtils_max.GetFileLastWrite(FileName); END;

(*----------------------------------------------------------------------------*)
Function GetFileInformation1_P( const FileName : string) : TSearchRec;
Begin Result := JclFileUtils_max.GetFileInformation(FileName); END;

(*----------------------------------------------------------------------------*)
Function GetFileInformation_P( const FileName : string; out FileInfo : TSearchRec) : Boolean;
Begin Result := JclFileUtils_max.GetFileInformation(FileName, FileInfo); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileMaskComparator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileMaskComparator) do begin
    RegisterConstructor(@TJclFileMaskComparator.Create, 'Create');
    RegisterMethod(@TJclFileMaskComparator.Destroy, 'Free');
    RegisterMethod(@TJclFileMaskComparator.Compare, 'Compare');
    RegisterPropertyHelper(@TJclFileMaskComparatorCount_R,nil,'Count');
    RegisterPropertyHelper(@TJclFileMaskComparatorExts_R,nil,'Exts');
    RegisterPropertyHelper(@TJclFileMaskComparatorFileMask_R,@TJclFileMaskComparatorFileMask_W,'FileMask');
    RegisterPropertyHelper(@TJclFileMaskComparatorMasks_R,nil,'Masks');
    RegisterPropertyHelper(@TJclFileMaskComparatorNames_R,nil,'Names');
    RegisterPropertyHelper(@TJclFileMaskComparatorSeparator_R,@TJclFileMaskComparatorSeparator_W,'Separator');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMappedTextReader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMappedTextReader) do begin
    RegisterConstructor(@TJclMappedTextReaderCreate2_P, 'Create2');
    RegisterConstructor(@TJclMappedTextReaderCreate3_P, 'Create3');
     RegisterMethod(@TJclMappedTextReader.Destroy, 'Free');
      RegisterMethod(@TJclMappedTextReader.GoBegin, 'GoBegin');
    RegisterMethod(@TJclMappedTextReader.Read, 'Read');
    RegisterMethod(@TJclMappedTextReader.ReadLn, 'ReadLn');
    RegisterPropertyHelper(@TJclMappedTextReaderAsString_R,nil,'AsString');
    RegisterPropertyHelper(@TJclMappedTextReaderChars_R,nil,'Chars');
    RegisterPropertyHelper(@TJclMappedTextReaderContent_R,nil,'Content');
    RegisterPropertyHelper(@TJclMappedTextReaderEof_R,nil,'Eof');
    RegisterPropertyHelper(@TJclMappedTextReaderIndexOption_R,nil,'IndexOption');
    RegisterPropertyHelper(@TJclMappedTextReaderLines_R,nil,'Lines');
    RegisterPropertyHelper(@TJclMappedTextReaderLineCount_R,nil,'LineCount');
    RegisterPropertyHelper(@TJclMappedTextReaderPositionFromLine_R,nil,'PositionFromLine');
    RegisterPropertyHelper(@TJclMappedTextReaderPosition_R,@TJclMappedTextReaderPosition_W,'Position');
    RegisterPropertyHelper(@TJclMappedTextReaderSize_R,nil,'Size');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileMappingStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileMappingStream) do begin
    RegisterConstructor(@TJclFileMappingStream.Create, 'Create');
       RegisterMethod(@TJclFileMappingStream.Destroy, 'Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSwapFileMapping(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSwapFileMapping) do begin
    RegisterConstructor(@TJclSwapFileMapping.Create, 'Create');
       RegisterMethod(@TJclSwapFileMapping.Destroy, 'Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileMapping(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileMapping) do begin
    RegisterConstructor(@TJclFileMappingCreate_P, 'Create');
     RegisterMethod(@TJclFileMapping.Destroy, 'Free');
    RegisterConstructor(@TJclFileMappingCreate1_P, 'Create1');
    RegisterPropertyHelper(@TJclFileMappingFileHandle_R,nil,'FileHandle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclCustomFileMapping(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclCustomFileMapping) do begin
    RegisterConstructor(@TJclCustomFileMapping.Open, 'Open');
    RegisterMethod(@TJclCustomFileMapping.Add, 'Add');
    RegisterMethod(@TJclCustomFileMapping.AddAt, 'AddAt');
    RegisterMethod(@TJclCustomFileMapping.Delete, 'Delete');
    RegisterMethod(@TJclCustomFileMapping.IndexOf, 'IndexOf');
    RegisterPropertyHelper(@TJclCustomFileMappingCount_R,nil,'Count');
    RegisterPropertyHelper(@TJclCustomFileMappingExisted_R,nil,'Existed');
    RegisterPropertyHelper(@TJclCustomFileMappingHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TJclCustomFileMappingName_R,nil,'Name');
    RegisterPropertyHelper(@TJclCustomFileMappingRoundViewOffset_R,@TJclCustomFileMappingRoundViewOffset_W,'RoundViewOffset');
    RegisterPropertyHelper(@TJclCustomFileMappingViews_R,nil,'Views');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileMappingView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileMappingView) do begin
    RegisterConstructor(@TJclFileMappingView.Create, 'Create');
    RegisterConstructor(@TJclFileMappingView.CreateAt, 'CreateAt');
      RegisterMethod(@TJclFileMappingView.Destroy, 'Free');
       RegisterMethod(@TJclFileMappingView.Flush, 'Flush');
    RegisterMethod(@TJclFileMappingView.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJclFileMappingView.LoadFromFile, 'LoadFromFile');
    RegisterPropertyHelper(@TJclFileMappingViewIndex_R,nil,'Index');
    RegisterPropertyHelper(@TJclFileMappingViewFileMapping_R,nil,'FileMapping');
    RegisterPropertyHelper(@TJclFileMappingViewOffset_R,nil,'Offset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclTempFileStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclTempFileStream) do begin
    RegisterConstructor(@TJclTempFileStream.Create, 'Create');
        RegisterMethod(@TJclTempFileStream.Destroy, 'Free');
      RegisterPropertyHelper(@TJclTempFileStreamFileName_R,nil,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileVersionInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileVersionInfo) do begin
    RegisterConstructor(@TJclFileVersionInfo.Attach, 'Attach');
    RegisterConstructor(@TJclFileVersionInfo.Create, 'Create');
           RegisterMethod(@TJclFileVersionInfo.Destroy, 'Free');
     RegisterMethod(@TJclFileVersionInfo.VersionLanguageId, 'VersionLanguageId');
    RegisterMethod(@TJclFileVersionInfo.VersionLanguageName, 'VersionLanguageName');
    RegisterMethod(@TJclFileVersionInfo.TranslationMatchesLanguages, 'TranslationMatchesLanguages');
    RegisterPropertyHelper(@TJclFileVersionInfoBinFileVersion_R,nil,'BinFileVersion');
    RegisterPropertyHelper(@TJclFileVersionInfoBinProductVersion_R,nil,'BinProductVersion');
    RegisterPropertyHelper(@TJclFileVersionInfoComments_R,nil,'Comments');
    RegisterPropertyHelper(@TJclFileVersionInfoCompanyName_R,nil,'CompanyName');
    RegisterPropertyHelper(@TJclFileVersionInfoFileDescription_R,nil,'FileDescription');
    RegisterPropertyHelper(@TJclFileVersionInfoFixedInfo_R,nil,'FixedInfo');
    RegisterPropertyHelper(@TJclFileVersionInfoFileFlags_R,nil,'FileFlags');
    RegisterPropertyHelper(@TJclFileVersionInfoFileOS_R,nil,'FileOS');
    RegisterPropertyHelper(@TJclFileVersionInfoFileSubType_R,nil,'FileSubType');
    RegisterPropertyHelper(@TJclFileVersionInfoFileType_R,nil,'FileType');
    RegisterPropertyHelper(@TJclFileVersionInfoFileVersion_R,nil,'FileVersion');
    RegisterPropertyHelper(@TJclFileVersionInfoItems_R,nil,'Items');
    RegisterPropertyHelper(@TJclFileVersionInfoInternalName_R,nil,'InternalName');
    RegisterPropertyHelper(@TJclFileVersionInfoLanguageCount_R,nil,'LanguageCount');
    RegisterPropertyHelper(@TJclFileVersionInfoLanguageIds_R,nil,'LanguageIds');
    RegisterPropertyHelper(@TJclFileVersionInfoLanguageIndex_R,@TJclFileVersionInfoLanguageIndex_W,'LanguageIndex');
    RegisterPropertyHelper(@TJclFileVersionInfoLanguages_R,nil,'Languages');
    RegisterPropertyHelper(@TJclFileVersionInfoLanguageNames_R,nil,'LanguageNames');
    RegisterPropertyHelper(@TJclFileVersionInfoLegalCopyright_R,nil,'LegalCopyright');
    RegisterPropertyHelper(@TJclFileVersionInfoLegalTradeMarks_R,nil,'LegalTradeMarks');
    RegisterPropertyHelper(@TJclFileVersionInfoOriginalFilename_R,nil,'OriginalFilename');
    RegisterPropertyHelper(@TJclFileVersionInfoPrivateBuild_R,nil,'PrivateBuild');
    RegisterPropertyHelper(@TJclFileVersionInfoProductName_R,nil,'ProductName');
    RegisterPropertyHelper(@TJclFileVersionInfoProductVersion_R,nil,'ProductVersion');
    RegisterPropertyHelper(@TJclFileVersionInfoSpecialBuild_R,nil,'SpecialBuild');
    RegisterPropertyHelper(@TJclFileVersionInfoTranslationCount_R,nil,'TranslationCount');
    RegisterPropertyHelper(@TJclFileVersionInfoTranslations_R,nil,'Translations');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileEnumerator) do begin
    RegisterConstructor(@TJclFileEnumerator.Create, 'Create');
           RegisterMethod(@TJclFileEnumerator.Destroy, 'Free');
        RegisterMethod(@TJclFileEnumerator.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TJclFileEnumerator.Assign, 'Assign');
    RegisterMethod(@TJclFileEnumerator.FillList, 'FillList');
    RegisterMethod(@TJclFileEnumeratorForEach2_P, 'ForEach2');
    RegisterMethod(@TJclFileEnumeratorForEach3_P, 'ForEach3');
    RegisterMethod(@TJclFileEnumerator.StopTask, 'StopTask');
    RegisterMethod(@TJclFileEnumerator.StopAllTasks, 'StopAllTasks');
    RegisterPropertyHelper(@TJclFileEnumeratorFileMask_R,@TJclFileEnumeratorFileMask_W,'FileMask');
    RegisterPropertyHelper(@TJclFileEnumeratorIncludeSubDirectories_R,@TJclFileEnumeratorIncludeSubDirectories_W,'IncludeSubDirectories');
    RegisterPropertyHelper(@TJclFileEnumeratorIncludeHiddenSubDirectories_R,@TJclFileEnumeratorIncludeHiddenSubDirectories_W,'IncludeHiddenSubDirectories');
    RegisterPropertyHelper(@TJclFileEnumeratorSearchOption_R,@TJclFileEnumeratorSearchOption_W,'SearchOption');
    RegisterPropertyHelper(@TJclFileEnumeratorLastChangeAfterAsString_R,@TJclFileEnumeratorLastChangeAfterAsString_W,'LastChangeAfterAsString');
    RegisterPropertyHelper(@TJclFileEnumeratorLastChangeBeforeAsString_R,@TJclFileEnumeratorLastChangeBeforeAsString_W,'LastChangeBeforeAsString');
    RegisterPropertyHelper(@TJclFileEnumeratorCaseSensitiveSearch_R,@TJclFileEnumeratorCaseSensitiveSearch_W,'CaseSensitiveSearch');
    RegisterPropertyHelper(@TJclFileEnumeratorFileMasks_R,@TJclFileEnumeratorFileMasks_W,'FileMasks');
    RegisterPropertyHelper(@TJclFileEnumeratorRootDirectory_R,@TJclFileEnumeratorRootDirectory_W,'RootDirectory');
    RegisterPropertyHelper(@TJclFileEnumeratorSubDirectoryMask_R,@TJclFileEnumeratorSubDirectoryMask_W,'SubDirectoryMask');
    RegisterPropertyHelper(@TJclFileEnumeratorAttributeMask_R,@TJclFileEnumeratorAttributeMask_W,'AttributeMask');
    RegisterPropertyHelper(@TJclFileEnumeratorFileSizeMin_R,@TJclFileEnumeratorFileSizeMin_W,'FileSizeMin');
    RegisterPropertyHelper(@TJclFileEnumeratorFileSizeMax_R,@TJclFileEnumeratorFileSizeMax_W,'FileSizeMax');
    RegisterPropertyHelper(@TJclFileEnumeratorLastChangeAfter_R,@TJclFileEnumeratorLastChangeAfter_W,'LastChangeAfter');
    RegisterPropertyHelper(@TJclFileEnumeratorLastChangeBefore_R,@TJclFileEnumeratorLastChangeBefore_W,'LastChangeBefore');
    RegisterPropertyHelper(@TJclFileEnumeratorOptions_R,@TJclFileEnumeratorOptions_W,'Options');
    RegisterPropertyHelper(@TJclFileEnumeratorRunningTasks_R,nil,'RunningTasks');
    RegisterPropertyHelper(@TJclFileEnumeratorSynchronizationMode_R,@TJclFileEnumeratorSynchronizationMode_W,'SynchronizationMode');
    RegisterPropertyHelper(@TJclFileEnumeratorOnEnterDirectory_R,@TJclFileEnumeratorOnEnterDirectory_W,'OnEnterDirectory');
    RegisterPropertyHelper(@TJclFileEnumeratorOnTerminateTask_R,@TJclFileEnumeratorOnTerminateTask_W,'OnTerminateTask');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileAttributeMask(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileAttributeMask) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclCustomFileAttrMask(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclCustomFileAttrMask) do begin
    RegisterConstructor(@TJclCustomFileAttrMask.Create, 'Create');
            RegisterMethod(@TJclCustomFileAttrMask.Destroy, 'Free');
       RegisterMethod(@TJclCustomFileAttrMask.Assign, 'Assign');
    RegisterMethod(@TJclCustomFileAttrMask.Clear, 'Clear');
    RegisterMethod(@TJclCustomFileAttrMaskMatch_P, 'Match');
    RegisterMethod(@TJclCustomFileAttrMaskMatch1_P, 'Match1');
    RegisterPropertyHelper(@TJclCustomFileAttrMaskRequired_R,@TJclCustomFileAttrMaskRequired_W,'Required');
    RegisterPropertyHelper(@TJclCustomFileAttrMaskRejected_R,@TJclCustomFileAttrMaskRejected_W,'Rejected');
    RegisterPropertyHelper(@TJclCustomFileAttrMaskAttribute_R,@TJclCustomFileAttrMaskAttribute_W,'Attribute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclFileUtils_max_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@stat64, 'stat64', CdCdecl);
 //S.RegisterDelphiFunction(@fstat64, 'fstat64', CdCdecl);
 //S.RegisterDelphiFunction(@lstat64, 'lstat64', CdCdecl);
 S.RegisterDelphiFunction(@PathAddSeparator, 'jxPathAddSeparator', cdRegister);
 S.RegisterDelphiFunction(@PathAddExtension, 'jxPathAddExtension', cdRegister);
 S.RegisterDelphiFunction(@PathAppend, 'jxPathAppend', cdRegister);
 S.RegisterDelphiFunction(@PathBuildRoot, 'jxPathBuildRoot', cdRegister);
 S.RegisterDelphiFunction(@PathCanonicalize, 'jxPathCanonicalize', cdRegister);
 S.RegisterDelphiFunction(@PathCommonPrefix, 'jxPathCommonPrefix', cdRegister);
 S.RegisterDelphiFunction(@PathCompactPath, 'jxPathCompactPath', cdRegister);
 S.RegisterDelphiFunction(@PathExtractElements, 'jxPathExtractElements', cdRegister);
 S.RegisterDelphiFunction(@PathExtractFileDirFixed, 'jxPathExtractFileDirFixed', cdRegister);
 S.RegisterDelphiFunction(@PathExtractFileNameNoExt, 'jxPathExtractFileNameNoExt', cdRegister);
 S.RegisterDelphiFunction(@PathExtractPathDepth, 'jxPathExtractPathDepth', cdRegister);
 S.RegisterDelphiFunction(@PathGetDepth, 'jxPathGetDepth', cdRegister);
 S.RegisterDelphiFunction(@PathGetLongName, 'jxPathGetLongName', cdRegister);
 S.RegisterDelphiFunction(@PathGetShortName, 'jxPathGetShortName', cdRegister);
 S.RegisterDelphiFunction(@PathGetLongName, 'jxPathGetLongName', cdRegister);
 S.RegisterDelphiFunction(@PathGetShortName, 'jxPathGetShortName', cdRegister);
 S.RegisterDelphiFunction(@PathGetRelativePath, 'jxPathGetRelativePath', cdRegister);
 S.RegisterDelphiFunction(@PathGetTempPath, 'jxPathGetTempPath', cdRegister);
 S.RegisterDelphiFunction(@PathGetTempPath, 'PathGetTempPath', cdRegister);
 S.RegisterDelphiFunction(@PathIsAbsolute, 'jxPathIsAbsolute', cdRegister);
 S.RegisterDelphiFunction(@PathIsChild, 'jxPathIsChild', cdRegister);
 S.RegisterDelphiFunction(@PathIsDiskDevice, 'jxPathIsDiskDevice', cdRegister);
 S.RegisterDelphiFunction(@PathIsUNC, 'jxPathIsUNC', cdRegister);
 S.RegisterDelphiFunction(@PathRemoveSeparator, 'jxPathRemoveSeparator', cdRegister);
 S.RegisterDelphiFunction(@PathRemoveExtension, 'jxPathRemoveExtension', cdRegister);
 S.RegisterDelphiFunction(@PathGetPhysicalPath, 'jxPathGetPhysicalPath', cdRegister);
 S.RegisterDelphiFunction(@PathGetLocalizedPath, 'jxPathGetLocalizedPath', cdRegister);
 S.RegisterDelphiFunction(@BuildFileList, 'jxBuildFileList', cdRegister);
 S.RegisterDelphiFunction(@AdvBuildFileList, 'jxAdvBuildFileList', cdRegister);
 S.RegisterDelphiFunction(@VerifyFileAttributeMask, 'jxVerifyFileAttributeMask', cdRegister);
 S.RegisterDelphiFunction(@IsFileAttributeMatch, 'jxIsFileAttributeMatch', cdRegister);
 S.RegisterDelphiFunction(@FileAttributesStr, 'jxFileAttributesStr', cdRegister);
 S.RegisterDelphiFunction(@IsFileNameMatch, 'jxIsFileNameMatch', cdRegister);
 S.RegisterDelphiFunction(@EnumFiles, 'jxEnumFiles', cdRegister);
 S.RegisterDelphiFunction(@EnumDirectories, 'jxEnumDirectories', cdRegister);
 S.RegisterDelphiFunction(@CreateEmptyFile, 'jxCreateEmptyFile', cdRegister);
 S.RegisterDelphiFunction(@CloseVolume, 'jxCloseVolume', cdRegister);
 S.RegisterDelphiFunction(@DeleteDirectory, 'jxDeleteDirectory', cdRegister);
 S.RegisterDelphiFunction(@CopyDirectory, 'jxCopyDirectory', cdRegister);
 S.RegisterDelphiFunction(@MoveDirectory, 'jxMoveDirectory', cdRegister);
 S.RegisterDelphiFunction(@DelTree, 'jxDelTree', cdRegister);
 S.RegisterDelphiFunction(@DelTreeEx, 'jxDelTreeEx', cdRegister);
 S.RegisterDelphiFunction(@DiskInDrive, 'jxDiskInDrive', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'jxDirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@FileCreateTemp, 'jxFileCreateTemp', cdRegister);
 S.RegisterDelphiFunction(@FileBackup, 'jxFileBackup', cdRegister);
 S.RegisterDelphiFunction(@FileCopy, 'jxFileCopy', cdRegister);
 S.RegisterDelphiFunction(@FileDelete, 'jxFileDelete', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'jxFileExists', cdRegister);
 S.RegisterDelphiFunction(@FileMove, 'jxFileMove', cdRegister);
 S.RegisterDelphiFunction(@FileRestore, 'jxFileRestore', cdRegister);
 S.RegisterDelphiFunction(@GetBackupFileName, 'jxGetBackupFileName', cdRegister);
 S.RegisterDelphiFunction(@IsBackupFileName, 'jxIsBackupFileName', cdRegister);
 S.RegisterDelphiFunction(@FileGetDisplayName, 'jxFileGetDisplayName', cdRegister);
 S.RegisterDelphiFunction(@FileGetGroupName, 'jxFileGetGroupName', cdRegister);
 S.RegisterDelphiFunction(@FileGetOwnerName, 'jxFileGetOwnerName', cdRegister);
 S.RegisterDelphiFunction(@FileGetSize, 'jxFileGetSize', cdRegister);
 S.RegisterDelphiFunction(@FileGetTempName, 'jxFileGetTempName', cdRegister);
 S.RegisterDelphiFunction(@FileGetTypeName, 'jxFileGetTypeName', cdRegister);
 S.RegisterDelphiFunction(@FindUnusedFileName, 'jxFindUnusedFileName', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'jxForceDirectories', cdRegister);
 S.RegisterDelphiFunction(@GetDirectorySize, 'jxGetDirectorySize', cdRegister);
 S.RegisterDelphiFunction(@GetDriveTypeStr, 'jxGetDriveTypeStr', cdRegister);
 S.RegisterDelphiFunction(@GetFileAgeCoherence, 'jxGetFileAgeCoherence', cdRegister);
 S.RegisterDelphiFunction(@GetFileAttributeList, 'jxGetFileAttributeList', cdRegister);
 S.RegisterDelphiFunction(@GetFileAttributeListEx, 'jxGetFileAttributeListEx', cdRegister);
 S.RegisterDelphiFunction(@GetFileInformation, 'jxGetFileInformation', cdRegister);
 S.RegisterDelphiFunction(@GetFileInformation1_P, 'jxGetFileInformation1', cdRegister);
 //S.RegisterDelphiFunction(@GetFileStatus, 'GetFileStatus', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastWrite, 'jxGetFileLastWrite', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastWrite1_P, 'jxGetFileLastWrite1', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastAccess, 'jxGetFileLastAccess', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastAccess1_P, 'jxGetFileLastAccess1', cdRegister);
 S.RegisterDelphiFunction(@GetFileCreation, 'jxGetFileCreation', cdRegister);
 S.RegisterDelphiFunction(@GetFileCreation1_P, 'jxGetFileCreation1', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastWrite, 'jxGetFileLastWrite', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastWrite1_P, 'jxGetFileLastWrite1', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastWrite3_P, 'jxGetFileLastWrite2', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastAccess, 'jxGetFileLastAccess', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastAccess1_P, 'jxGetFileLastAccess1', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastAccess2_P, 'jxGetFileLastAccess2', cdRegister);
 //S.RegisterDelphiFunction(@GetFileLastAttrChange, 'GetFileLastAttrChange', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastAttrChange1_P, 'jxGetFileLastAttrChange1', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastAttrChange2_P, 'jxGetFileLastAttrChange2', cdRegister);
 S.RegisterDelphiFunction(@GetModulePath, 'jxGetModulePath', cdRegister);
 S.RegisterDelphiFunction(@GetSizeOfFile, 'jxGetSizeOfFile', cdRegister);
 S.RegisterDelphiFunction(@GetSizeOfFile1_P, 'jxGetSizeOfFile1', cdRegister);
 S.RegisterDelphiFunction(@GetSizeOfFile2_P, 'jxGetSizeOfFile2', cdRegister);
 S.RegisterDelphiFunction(@GetStandardFileInfo, 'jxGetStandardFileInfo', cdRegister);
 S.RegisterDelphiFunction(@IsDirectory, 'jxIsDirectory', cdRegister);
 S.RegisterDelphiFunction(@IsRootDirectory, 'jxIsRootDirectory', cdRegister);
 S.RegisterDelphiFunction(@LockVolume, 'jxLockVolume', cdRegister);
 S.RegisterDelphiFunction(@OpenVolume, 'jxOpenVolume', cdRegister);
 S.RegisterDelphiFunction(@SetDirLastWrite, 'jxSetDirLastWrite', cdRegister);
 S.RegisterDelphiFunction(@SetDirLastAccess, 'jxSetDirLastAccess', cdRegister);
 S.RegisterDelphiFunction(@SetDirCreation, 'jxSetDirCreation', cdRegister);
 S.RegisterDelphiFunction(@SetFileLastWrite, 'jxSetFileLastWrite', cdRegister);
 S.RegisterDelphiFunction(@SetFileLastAccess, 'jxSetFileLastAccess', cdRegister);
 S.RegisterDelphiFunction(@SetFileCreation, 'jxSetFileCreation', cdRegister);
 S.RegisterDelphiFunction(@ShredFile, 'jxShredFile', cdRegister);
 S.RegisterDelphiFunction(@UnlockVolume, 'jxUnlockVolume', cdRegister);
 //S.RegisterDelphiFunction(@CreateSymbolicLink, 'CreateSymbolicLink', cdRegister);
 //S.RegisterDelphiFunction(@SymbolicLinkTarget, 'SymbolicLinkTarget', cdRegister);
 S.RegisterDelphiFunction(@FileSearch, 'jxFileSearch', cdRegister);
 S.RegisterDelphiFunction(@OSIdentToString, 'jxOSIdentToString', cdRegister);
 S.RegisterDelphiFunction(@OSFileTypeToString, 'jxOSFileTypeToString', cdRegister);
 S.RegisterDelphiFunction(@VersionResourceAvailable, 'jxVersionResourceAvailable', cdRegister);
 S.RegisterDelphiFunction(@FormatVersionString, 'jxFormatVersionString', cdRegister);
 S.RegisterDelphiFunction(@FormatVersionString1_P, 'jxFormatVersionString1', cdRegister);
 S.RegisterDelphiFunction(@FormatVersionString2_P, 'jxFormatVersionString2', cdRegister);
 S.RegisterDelphiFunction(@VersionExtractFileInfo, 'jxVersionExtractFileInfo', cdRegister);
 S.RegisterDelphiFunction(@VersionExtractProductInfo, 'jxVersionExtractProductInfo', cdRegister);
 S.RegisterDelphiFunction(@VersionFixedFileInfo, 'jxVersionFixedFileInfo', cdRegister);
 S.RegisterDelphiFunction(@VersionFixedFileInfoString, 'jxVersionFixedFileInfoString', cdRegister);
 S.RegisterDelphiFunction(@PathGetLongName, 'jxPathGetLongName', cdRegister);
// S.RegisterDelphiFunction(@Win32DeleteFile, 'Win32DeleteFile', cdRegister);
 //S.RegisterDelphiFunction(@Win32MoveFileReplaceExisting, 'Win32MoveFileReplaceExisting', cdRegister);
 //S.RegisterDelphiFunction(@Win32BackupFile, 'Win32BackupFile', cdRegister);
 //S.RegisterDelphiFunction(@Win32RestoreFile, 'Win32RestoreFile', cdRegister);
 S.RegisterDelphiFunction(@SamePath, 'jxSamePath', cdRegister);
 S.RegisterDelphiFunction(@PathListAddItems, 'jxPathListAddItems', cdRegister);
 S.RegisterDelphiFunction(@PathListIncludeItems, 'jxPathListIncludeItems', cdRegister);
 S.RegisterDelphiFunction(@PathListDelItems, 'jxPathListDelItems', cdRegister);
 S.RegisterDelphiFunction(@PathListDelItem, 'jxPathListDelItem', cdRegister);
 S.RegisterDelphiFunction(@PathListItemCount, 'jxPathListItemCount', cdRegister);
 S.RegisterDelphiFunction(@PathListGetItem, 'jxPathListGetItem', cdRegister);
 S.RegisterDelphiFunction(@PathListSetItem, 'jxPathListSetItem', cdRegister);
 S.RegisterDelphiFunction(@PathListItemIndex, 'jxPathListItemIndex', cdRegister);
 S.RegisterDelphiFunction(@ParamName, 'jxParamName', cdRegister);
 S.RegisterDelphiFunction(@ParamValue, 'jxParamValue', cdRegister);
 S.RegisterDelphiFunction(@ParamValue1_P, 'jxParamValue1', cdRegister);
 S.RegisterDelphiFunction(@ParamPos, 'jxParamPos', cdRegister);
end;

procedure RIRegister_JclFileUtils_max(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJclCustomFileAttrMask(CL);
  RIRegister_TJclFileAttributeMask(CL);
  RIRegister_TJclFileEnumerator(CL);
    with CL.Add(EJclFileVersionInfoError) do
  RIRegister_TJclFileVersionInfo(CL);
   RIRegister_TJclTempFileStream(CL);
  with CL.Add(TJclCustomFileMapping) do
  RIRegister_TJclFileMappingView(CL);
  RIRegister_TJclCustomFileMapping(CL);
  RIRegister_TJclFileMapping(CL);
  RIRegister_TJclSwapFileMapping(CL);
  RIRegister_TJclFileMappingStream(CL);
  RIRegister_TJclMappedTextReader(CL);
  RIRegister_TJclFileMaskComparator(CL);
  with CL.Add(EJclPathError) do
  with CL.Add(EJclFileUtilsError) do
  with CL.Add(EJclTempFileStreamError) do
  with CL.Add(EJclTempFileStreamError) do
  with CL.Add(EJclFileMappingError) do
  with CL.Add(EJclFileMappingViewError) do

end;


 
{ TPSImport_JclFileUtils_max }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclFileUtils_max.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclFileUtils_max(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclFileUtils_max.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclFileUtils_max_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
