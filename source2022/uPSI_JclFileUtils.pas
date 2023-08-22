unit uPSI_JclFileUtils;
{

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
  TPSImport_JclFileUtils = class(TPSPlugin)
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
procedure SIRegister_JclFileUtils(CL: TPSPascalCompiler);

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
procedure RIRegister_JclFileUtils(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclFileUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,JclBase
  ,JclSysInfo
  ,JclFileUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclFileUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileMaskComparator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclFileMaskComparator') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclFileMaskComparator') do begin
    RegisterMethod('Constructor Create');
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
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJclMappedTextReader') do
  begin
    RegisterMethod('Constructor Create( MemoryStream : TCustomMemoryStream; FreeStream : Boolean; const AIndexOption : TJclMappedTextReaderIndex);');
    RegisterMethod('Constructor Create1( const FileName : string; const AIndexOption : TJclMappedTextReaderIndex);');
    RegisterMethod('Procedure GoBegin');
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
  with CL.AddClassN(CL.FindClass('TCustomMemoryStream'),'TJclFileMappingStream') do
  begin
    RegisterMethod('Constructor Create( const FileName : string; FileMode : WordfmShareDenyWrite)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSwapFileMapping(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclCustomFileMapping', 'TJclSwapFileMapping') do
  with CL.AddClassN(CL.FindClass('TJclCustomFileMapping'),'TJclSwapFileMapping') do
  begin
    RegisterMethod('Constructor Create( const Name : string; Protect : Cardinal; const MaximumSize : Int64; const SecAttr : PSecurityAttributes)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileMapping(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclCustomFileMapping', 'TJclFileMapping') do
  with CL.AddClassN(CL.FindClass('TJclCustomFileMapping'),'TJclFileMapping') do
  begin
    RegisterMethod('Constructor Create( const FileName : string; FileMode : Cardinal; const Name : string; Protect : Cardinal; const MaximumSize : Int64; const SecAttr : PSecurityAttributes);');
    RegisterMethod('Constructor Create1( const FileHandle : THandle; const Name : string; Protect : Cardinal; const MaximumSize : Int64; const SecAttr : PSecurityAttributes);');
    RegisterProperty('FileHandle', 'THandle', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclCustomFileMapping(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclCustomFileMapping') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclCustomFileMapping') do
  begin
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
  with CL.AddClassN(CL.FindClass('TCustomMemoryStream'),'TJclFileMappingView') do
  begin
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
  with CL.AddClassN(CL.FindClass('THandleStream'),'TJclTempFileStream') do
  begin
    RegisterMethod('Constructor Create( const Prefix : string)');
    RegisterProperty('FileName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileVersionInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclFileVersionInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclFileVersionInfo') do
  begin
    RegisterMethod('Constructor Attach( VersionInfoData : Pointer; Size : Integer)');
    RegisterMethod('Constructor Create( const FileName : string)');
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
procedure SIRegister_JclFileUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('PathSeparator','String').SetString( '/');
 CL.AddConstantN('PathDevicePrefix','String').SetString( '\\.\');
 CL.AddConstantN('PathSeparator','String').SetString( '\');
 CL.AddConstantN('PathUncPrefix','String').SetString( '\\');
  CL.AddTypeS('TCompactPath', '( cpCenter, cpEnd )');
 CL.AddDelphiFunction('Function PathAddSeparator( const Path : string) : string');
 CL.AddDelphiFunction('Function PathAddExtension( const Path, Extension : string) : string');
 CL.AddDelphiFunction('Function PathAppend( const Path, Append : string) : string');
 CL.AddDelphiFunction('Function PathBuildRoot( const Drive : Byte) : string');
 CL.AddDelphiFunction('Function PathCanonicalize( const Path : string) : string');
 CL.AddDelphiFunction('Function PathCommonPrefix( const Path1, Path2 : string) : Integer');
 CL.AddDelphiFunction('Function PathCompactPath( const DC : HDC; const Path : string; const Width : Integer; CmpFmt : TCompactPath) : string;');
 CL.AddDelphiFunction('Function PathCompactPath1( const Canvas : TCanvas; const Path : string; const Width : Integer; CmpFmt : TCompactPath) : string;');
 CL.AddDelphiFunction('Procedure PathExtractElements( const Source : string; var Drive, Path, FileName, Ext : string)');
 CL.AddDelphiFunction('Function PathExtractFileDirFixed( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function PathExtractFileNameNoExt( const Path : string) : string');
 CL.AddDelphiFunction('Function PathExtractPathDepth( const Path : string; Depth : Integer) : string');
 CL.AddDelphiFunction('Function PathGetDepth( const Path : string) : Integer');
 CL.AddDelphiFunction('Function PathGetLongName( const Path : string) : string');
 CL.AddDelphiFunction('Function PathGetLongName2( Path : string) : string');
 CL.AddDelphiFunction('Function PathGetShortName( const Path : string) : string');
 CL.AddDelphiFunction('Function PathIsAbsolute( const Path : string) : Boolean');
 CL.AddDelphiFunction('Function PathIsChild( const Path, Base : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function PathIsDiskDevice( const Path : string) : Boolean');
 CL.AddDelphiFunction('Function PathIsUNC( const Path : string) : Boolean');
 CL.AddDelphiFunction('Function PathRemoveSeparator( const Path : string) : string');
 CL.AddDelphiFunction('Function PathRemoveExtension( const Path : string) : string');
  CL.AddTypeS('TFileListOption', '( flFullNames, flRecursive, flMaskedSubfolder'
   +'s )');
  CL.AddTypeS('TFileListOptions', 'set of TFileListOption');
  CL.AddTypeS('TJclAttributeMatch', '( amAny, amExact, amSubSetOf, amSuperSetOf'
   +', amCustom )');
 CL.AddDelphiFunction('Function BuildFileList( const Path : string; const Attr : Integer; const List : TStrings) : Boolean');
 //CL.AddDelphiFunction('Function AdvBuildFileList( const Path : string; const Attr : Integer; const Files : TStrings; const AttributeMatch : TJclAttributeMatch; const Options : TFileListOptions; const SubfoldersMask : string; const FileMatchFunc : TFileMatchFunc) : Boolean');
 CL.AddDelphiFunction('Function CloseVolume( var Volume : THandle) : Boolean');
 CL.AddDelphiFunction('Procedure CreateEmptyFile( const FileName : string)');
 CL.AddDelphiFunction('Function DeleteDirectory( const DirectoryName : string; MoveToRecycleBin : Boolean) : Boolean');
 CL.AddDelphiFunction('Function DelTree( const Path : string) : Boolean');
// CL.AddDelphiFunction('Function DelTreeEx( const Path : string; AbortOnFailure : Boolean; Progress : TDelTreeProgress) : Boolean');
 CL.AddDelphiFunction('Function DirectoryExists( const Name : string) : Boolean');
 CL.AddDelphiFunction('Function DiskInDrive( Drive : Char) : Boolean');
 CL.AddDelphiFunction('Function FileCreateTemp( var Prefix : string) : THandle');
 CL.AddDelphiFunction('Function FileExists( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function GetBackupFileName( const FileName : string) : string');
 CL.AddDelphiFunction('Function FileGetDisplayName( const FileName : string) : string');
 CL.AddDelphiFunction('Function FileGetSize( const FileName : string) : Integer');
 CL.AddDelphiFunction('Function FileGetTempName( const Prefix : string) : string');
 CL.AddDelphiFunction('Function FileGetTypeName( const FileName : string) : string');
 CL.AddDelphiFunction('Function FindUnusedFileName( const FileName, FileExt, Suffix : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ForceDirectories( Name : string) : Boolean');
 CL.AddDelphiFunction('Function GetDirectorySize( const Path : string) : Int64');
 CL.AddDelphiFunction('Function GetDriveTypeStr( const Drive : Char) : string');
 CL.AddDelphiFunction('Function GetFileAgeCoherence( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Procedure GetFileAttributeList( const Items : TStrings; const Attr : Integer)');
 CL.AddDelphiFunction('Procedure GetFileAttributeListEx( const Items : TStrings; const Attr : Integer)');
 CL.AddDelphiFunction('Function GetFileInformation( const FileName : string) : TSearchRec');
 CL.AddDelphiFunction('Function GetFileLastWrite( const FileName : string) : TFileTime');
 CL.AddDelphiFunction('Function GetFileLastAccess( const FileName : string) : TFileTime');
 CL.AddDelphiFunction('Function GetFileCreation( const FileName : string) : TFileTime');
 CL.AddDelphiFunction('Function GetModulePath( const Module : HMODULE) : string');
 CL.AddDelphiFunction('Function GetSizeOfFile( const FileName : string) : Int64;');
 CL.AddDelphiFunction('Function GetSizeOfFile1( Handle : THandle) : Int64;');
 //CL.AddDelphiFunction('Function GetStandardFileInfo( const FileName : string) : TWin32FileAttributeData');
 CL.AddDelphiFunction('Function IsDirectory( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function LockVolume( const Volume : string; var Handle : THandle) : Boolean');
 CL.AddDelphiFunction('Function OpenVolume( const Drive : Char) : THandle');
 CL.AddDelphiFunction('Function SetDirLastWrite( const DirName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function SetDirLastAccess( const DirName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function SetDirCreation( const DirName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function SetFileLastWrite( const FileName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function SetFileLastAccess( const FileName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function SetFileCreation( const FileName : string; const DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Procedure ShredFile( const FileName : string; Times : Integer)');
 CL.AddDelphiFunction('Function UnlockVolume( var Handle : THandle) : Boolean');
 CL.AddDelphiFunction('Function Win32DeleteFile( const FileName : string; MoveToRecycleBin : Boolean) : Boolean');
 CL.AddDelphiFunction('Function Win32BackupFile( const FileName : string; Move : Boolean) : Boolean');
 CL.AddDelphiFunction('Function Win32RestoreFile( const FileName : string) : Boolean');
  CL.AddTypeS('TFileFlag', '( ffDebug, ffInfoInferred, ffPatched, ffPreRelease,'
   +' ffPrivateBuild, ffSpecialBuild )');
  CL.AddTypeS('TFileFlags', 'set of TFileFlag');
  //CL.AddTypeS('PLangIdRec', '^TLangIdRec // will not work');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclFileVersionInfoError');
  SIRegister_TJclFileVersionInfo(CL);
 CL.AddDelphiFunction('Function OSIdentToString( const OSIdent : DWORD) : string');
 CL.AddDelphiFunction('Function OSFileTypeToString( const OSFileType : DWORD; const OSFileSubType : DWORD) : string');
 CL.AddDelphiFunction('Function VersionResourceAvailable( const FileName : string) : Boolean');
 //CL.AddDelphiFunction('Function VersionFixedFileInfo( const FileName : string; var FixedInfo : TVSFixedFileInfo) : Boolean');
 CL.AddDelphiFunction('Function FormatVersionString( const HiV, LoV : Word) : string;');
 CL.AddDelphiFunction('Function FormatVersionString1( const Major, Minor, Build, Revision : Word) : string;');
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
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclFileMappingError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclFileMappingViewError');
end;

(* === run-time registration functions === *)
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
Function TJclMappedTextReaderCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const FileName : string; const AIndexOption : TJclMappedTextReaderIndex):TObject;
Begin Result := TJclMappedTextReader.Create(FileName, AIndexOption); END;

(*----------------------------------------------------------------------------*)
Function TJclMappedTextReaderCreate_P(Self: TClass; CreateNewInstance: Boolean;  MemoryStream : TCustomMemoryStream; FreeStream : Boolean; const AIndexOption : TJclMappedTextReaderIndex):TObject;
Begin Result := TJclMappedTextReader.Create(MemoryStream, FreeStream, AIndexOption); END;

(*----------------------------------------------------------------------------*)
procedure TJclFileMappingFileHandle_R(Self: TJclFileMapping; var T: THandle);
begin T := Self.FileHandle; end;

(*----------------------------------------------------------------------------*)
Function TJclFileMappingCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const FileHandle : THandle; const Name : string; Protect : Cardinal; const MaximumSize : Int64; const SecAttr : PSecurityAttributes):TObject;
Begin Result := TJclFileMapping.Create(FileHandle, Name, Protect, MaximumSize, SecAttr); END;

(*----------------------------------------------------------------------------*)
Function TJclFileMappingCreate_P(Self: TClass; CreateNewInstance: Boolean;  const FileName : string; FileMode : Cardinal; const Name : string; Protect : Cardinal; const MaximumSize : Int64; const SecAttr : PSecurityAttributes):TObject;
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
Function FormatVersionString1_P( const Major, Minor, Build, Revision : Word) : string;
Begin Result := JclFileUtils.FormatVersionString(Major, Minor, Build, Revision); END;

(*----------------------------------------------------------------------------*)
Function FormatVersionString_P( const HiV, LoV : Word) : string;
Begin Result := JclFileUtils.FormatVersionString(HiV, LoV); END;

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
Function GetSizeOfFile1_P( Handle : THandle) : Int64;
Begin Result := JclFileUtils.GetSizeOfFile(Handle); END;

(*----------------------------------------------------------------------------*)
Function GetSizeOfFile_P( const FileName : string) : Int64;
Begin Result := JclFileUtils.GetSizeOfFile(FileName); END;

(*----------------------------------------------------------------------------*)
Function PathCompactPath1_P( const Canvas : TCanvas; const Path : string; const Width : Integer; CmpFmt : TCompactPath) : string;
Begin Result := JclFileUtils.PathCompactPath(Canvas, Path, Width, CmpFmt); END;

(*----------------------------------------------------------------------------*)
Function PathCompactPath_P( const DC : HDC; const Path : string; const Width : Integer; CmpFmt : TCompactPath) : string;
Begin Result := JclFileUtils.PathCompactPath(DC, Path, Width, CmpFmt); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileMaskComparator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileMaskComparator) do
  begin
    RegisterConstructor(@TJclFileMaskComparator.Create, 'Create');
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
  with CL.Add(TJclMappedTextReader) do
  begin
    RegisterConstructor(@TJclMappedTextReaderCreate_P, 'Create');
    RegisterConstructor(@TJclMappedTextReaderCreate1_P, 'Create1');
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
  with CL.Add(TJclFileMappingStream) do
  begin
    RegisterConstructor(@TJclFileMappingStream.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSwapFileMapping(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSwapFileMapping) do
  begin
    RegisterConstructor(@TJclSwapFileMapping.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileMapping(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileMapping) do
  begin
    RegisterConstructor(@TJclFileMappingCreate_P, 'Create');
    RegisterConstructor(@TJclFileMappingCreate1_P, 'Create1');
    RegisterPropertyHelper(@TJclFileMappingFileHandle_R,nil,'FileHandle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclCustomFileMapping(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclCustomFileMapping) do
  begin
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
  with CL.Add(TJclFileMappingView) do
  begin
    RegisterConstructor(@TJclFileMappingView.Create, 'Create');
    RegisterConstructor(@TJclFileMappingView.CreateAt, 'CreateAt');
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
  with CL.Add(TJclTempFileStream) do
  begin
    RegisterConstructor(@TJclTempFileStream.Create, 'Create');
    RegisterPropertyHelper(@TJclTempFileStreamFileName_R,nil,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileVersionInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileVersionInfo) do begin
    RegisterConstructor(@TJclFileVersionInfo.Attach, 'Attach');
    RegisterConstructor(@TJclFileVersionInfo.Create, 'Create');
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


procedure RIRegister_JclFileUtils(CL: TPSRuntimeClassImporter);
begin
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
  with CL.Add(EJclFileMappingError) do
  with CL.Add(EJclFileMappingViewError) do
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_JclFileUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PathAddSeparator, 'PathAddSeparator', cdRegister);
 S.RegisterDelphiFunction(@PathAddExtension, 'PathAddExtension', cdRegister);
 S.RegisterDelphiFunction(@PathAppend, 'PathAppend', cdRegister);
 S.RegisterDelphiFunction(@PathBuildRoot, 'PathBuildRoot', cdRegister);
 S.RegisterDelphiFunction(@PathCanonicalize, 'PathCanonicalize', cdRegister);
 S.RegisterDelphiFunction(@PathCommonPrefix, 'PathCommonPrefix', cdRegister);
 S.RegisterDelphiFunction(@PathCompactPath, 'PathCompactPath', cdRegister);
 S.RegisterDelphiFunction(@PathCompactPath1_P, 'PathCompactPath1', cdRegister);
 S.RegisterDelphiFunction(@PathExtractElements, 'PathExtractElements', cdRegister);
 S.RegisterDelphiFunction(@PathExtractFileDirFixed, 'PathExtractFileDirFixed', cdRegister);
 S.RegisterDelphiFunction(@PathExtractFileNameNoExt, 'PathExtractFileNameNoExt', cdRegister);
 S.RegisterDelphiFunction(@PathExtractPathDepth, 'PathExtractPathDepth', cdRegister);
 S.RegisterDelphiFunction(@PathGetDepth, 'PathGetDepth', cdRegister);
 S.RegisterDelphiFunction(@PathGetLongName, 'PathGetLongName', cdRegister);
 S.RegisterDelphiFunction(@PathGetLongName2, 'PathGetLongName2', cdRegister);
 S.RegisterDelphiFunction(@PathGetShortName, 'PathGetShortName', cdRegister);
 S.RegisterDelphiFunction(@PathIsAbsolute, 'PathIsAbsolute', cdRegister);
 S.RegisterDelphiFunction(@PathIsChild, 'PathIsChild', cdRegister);
 S.RegisterDelphiFunction(@PathIsDiskDevice, 'PathIsDiskDevice', cdRegister);
 S.RegisterDelphiFunction(@PathIsUNC, 'PathIsUNC', cdRegister);
 S.RegisterDelphiFunction(@PathRemoveSeparator, 'PathRemoveSeparator', cdRegister);
 S.RegisterDelphiFunction(@PathRemoveExtension, 'PathRemoveExtension', cdRegister);
 S.RegisterDelphiFunction(@BuildFileList, 'BuildFileList', cdRegister);
 S.RegisterDelphiFunction(@AdvBuildFileList, 'AdvBuildFileList', cdRegister);
 S.RegisterDelphiFunction(@CloseVolume, 'CloseVolume', cdRegister);
 S.RegisterDelphiFunction(@CreateEmptyFile, 'CreateEmptyFile', cdRegister);
 S.RegisterDelphiFunction(@DeleteDirectory, 'DeleteDirectory', cdRegister);
 S.RegisterDelphiFunction(@DelTree, 'DelTree', cdRegister);
 S.RegisterDelphiFunction(@DelTreeEx, 'DelTreeEx', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'DirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@DiskInDrive, 'DiskInDrive', cdRegister);
 S.RegisterDelphiFunction(@FileCreateTemp, 'FileCreateTemp', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'FileExists', cdRegister);
 S.RegisterDelphiFunction(@GetBackupFileName, 'GetBackupFileName', cdRegister);
 S.RegisterDelphiFunction(@FileGetDisplayName, 'FileGetDisplayName', cdRegister);
 S.RegisterDelphiFunction(@FileGetSize, 'FileGetSize', cdRegister);
 S.RegisterDelphiFunction(@FileGetTempName, 'FileGetTempName', cdRegister);
 S.RegisterDelphiFunction(@FileGetTypeName, 'FileGetTypeName', cdRegister);
 S.RegisterDelphiFunction(@FindUnusedFileName, 'FindUnusedFileName', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'ForceDirectories', cdRegister);
 S.RegisterDelphiFunction(@GetDirectorySize, 'GetDirectorySize', cdRegister);
 S.RegisterDelphiFunction(@GetDriveTypeStr, 'GetDriveTypeStr', cdRegister);
 S.RegisterDelphiFunction(@GetFileAgeCoherence, 'GetFileAgeCoherence', cdRegister);
 S.RegisterDelphiFunction(@GetFileAttributeList, 'GetFileAttributeList', cdRegister);
 S.RegisterDelphiFunction(@GetFileAttributeListEx, 'GetFileAttributeListEx', cdRegister);
 S.RegisterDelphiFunction(@GetFileInformation, 'GetFileInformation', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastWrite, 'GetFileLastWrite', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastAccess, 'GetFileLastAccess', cdRegister);
 S.RegisterDelphiFunction(@GetFileCreation, 'GetFileCreation', cdRegister);
 S.RegisterDelphiFunction(@GetModulePath, 'GetModulePath', cdRegister);
 S.RegisterDelphiFunction(@GetSizeOfFile, 'GetSizeOfFile', cdRegister);
 S.RegisterDelphiFunction(@GetSizeOfFile1_P, 'GetSizeOfFile1', cdRegister);
 S.RegisterDelphiFunction(@GetStandardFileInfo, 'GetStandardFileInfo', cdRegister);
 S.RegisterDelphiFunction(@IsDirectory, 'IsDirectory', cdRegister);
 S.RegisterDelphiFunction(@LockVolume, 'LockVolume', cdRegister);
 S.RegisterDelphiFunction(@OpenVolume, 'OpenVolume', cdRegister);
 S.RegisterDelphiFunction(@SetDirLastWrite, 'SetDirLastWrite', cdRegister);
 S.RegisterDelphiFunction(@SetDirLastAccess, 'SetDirLastAccess', cdRegister);
 S.RegisterDelphiFunction(@SetDirCreation, 'SetDirCreation', cdRegister);
 S.RegisterDelphiFunction(@SetFileLastWrite, 'SetFileLastWrite', cdRegister);
 S.RegisterDelphiFunction(@SetFileLastAccess, 'SetFileLastAccess', cdRegister);
 S.RegisterDelphiFunction(@SetFileCreation, 'SetFileCreation', cdRegister);
 S.RegisterDelphiFunction(@ShredFile, 'ShredFile', cdRegister);
 S.RegisterDelphiFunction(@UnlockVolume, 'UnlockVolume', cdRegister);
 S.RegisterDelphiFunction(@Win32DeleteFile, 'Win32DeleteFile', cdRegister);
 S.RegisterDelphiFunction(@Win32BackupFile, 'Win32BackupFile', cdRegister);
 S.RegisterDelphiFunction(@Win32RestoreFile, 'Win32RestoreFile', cdRegister);
 S.RegisterDelphiFunction(@OSIdentToString, 'OSIdentToString', cdRegister);
 S.RegisterDelphiFunction(@OSFileTypeToString, 'OSFileTypeToString', cdRegister);
 S.RegisterDelphiFunction(@VersionResourceAvailable, 'VersionResourceAvailable', cdRegister);
 S.RegisterDelphiFunction(@VersionFixedFileInfo, 'VersionFixedFileInfo', cdRegister);
 S.RegisterDelphiFunction(@FormatVersionString, 'FormatVersionString', cdRegister);
 S.RegisterDelphiFunction(@FormatVersionString1_P, 'FormatVersionString1', cdRegister);
 { RIRegister_TJclTempFileStream(CL);
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
  with CL.Add(EJclFileMappingError) do
  with CL.Add(EJclFileMappingViewError) do}
end;

 
 
{ TPSImport_JclFileUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclFileUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclFileUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclFileUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclFileUtils(ri);
  RIRegister_JclFileUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
