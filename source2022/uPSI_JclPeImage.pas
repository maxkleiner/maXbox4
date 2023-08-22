unit uPSI_JclPeImage;
{
  analyze PE Header
  This unit contains various classes and support routines to read the contents of portable         }
{ executable (PE) files. You can use these classes to, for example examine the contents of the     }
{ imports section of an executable. In addition the unit contains support for Borland specific     }
{ structures and name unmangling.   JclPeImages.pas TClPeBorImage filename violation   this hot one                                                            }
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
  TPSImport_JclPeImage = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclPeMapImgHooks(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeMapImgHookItem(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeSectionStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeNameSearch(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeBorImage(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeBorForm(CL: TPSPascalCompiler);
procedure SIRegister_TJclPePackageInfo(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeImage(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeCLRHeader(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeCertificateList(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeCertificate(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeDebugList(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeRelocList(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeRelocEntry(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeRootResourceList(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeResourceList(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeResourceItem(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeResourceRawStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeExportFuncList(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeExportFuncItem(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeImportList(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeImportLibItem(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeImportFuncItem(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeBorImagesCache(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeImagesCache(CL: TPSPascalCompiler);
procedure SIRegister_TJclPeImageBaseList(CL: TPSPascalCompiler);
procedure SIRegister_JclPeImage(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJclPeMapImgHooks(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeMapImgHookItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeSectionStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeNameSearch(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeBorImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeBorForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPePackageInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeCLRHeader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeCertificateList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeCertificate(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeDebugList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeRelocList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeRelocEntry(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeRootResourceList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeResourceList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeResourceItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeResourceRawStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeExportFuncList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeExportFuncItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeImportList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeImportLibItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeImportFuncItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeBorImagesCache(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeImagesCache(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclPeImageBaseList(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclPeImage_Routines(S: TPSExec);

procedure RIRegister_JclPeImage(CL: TPSRuntimeClassImporter);


procedure Register;

implementation


uses
   Windows
  ,ImageHlp
  ,TypInfo
  ,Contnrs
  ,JclBase
  ,JclDateTime
  ,JclFileUtils
  ,JclStrings
  ,JclSysInfo
  ,JclWin32
  ,JclPeImage
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclPeImage]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeMapImgHooks(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TJclPeMapImgHooks') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TJclPeMapImgHooks') do begin
    RegisterMethod('Function HookImport( Base : Pointer; const ModuleName, FunctionName : string; NewAddress : Pointer; var OriginalAddress : Pointer) : Boolean');
    RegisterMethod('Function IsWin9xDebugThunk( P : Pointer) : Boolean');
    RegisterMethod('Function ReplaceImport( Base : Pointer; ModuleName : string; FromProc, ToProc : Pointer) : Boolean');
    RegisterMethod('Function SystemBase : Pointer');
    RegisterMethod('Procedure UnhookAll');
    RegisterMethod('Function UnhookByNewAddress( NewAddress : Pointer) : Boolean');
    RegisterProperty('Items', 'TJclPeMapImgHookItem Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('ItemFromOriginalAddress', 'TJclPeMapImgHookItem Pointer', iptr);
    RegisterProperty('ItemFromNewAddress', 'TJclPeMapImgHookItem Pointer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeMapImgHookItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPeMapImgHookItem') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPeMapImgHookItem') do begin
    RegisterMethod('Function Unhook : Boolean');
    RegisterProperty('BaseAddress', 'Pointer', iptr);
    RegisterProperty('FunctionName', 'string', iptr);
    RegisterProperty('ModuleName', 'string', iptr);
    RegisterProperty('NewAddress', 'Pointer', iptr);
    RegisterProperty('OriginalAddress', 'Pointer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeSectionStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMemoryStream', 'TJclPeSectionStream') do
  with CL.AddClassN(CL.FindClass('TCustomMemoryStream'),'TJclPeSectionStream') do
  begin
    RegisterMethod('Constructor Create( Instance : HMODULE; const ASectionName : string)');
    RegisterProperty('Instance', 'HMODULE', iptr);
    RegisterProperty('SectionHeader', 'TImageSectionHeader', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeNameSearch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TJclPeNameSearch') do
  with CL.AddClassN(CL.FindClass('TThread'),'TJclPeNameSearch') do begin
    RegisterMethod('Constructor Create( const FunctionName, Path : string; Options : TJclPeNameSearchOptions)');
    RegisterMethod('Procedure Start');
    RegisterProperty('OnFound', 'TJclPeNameSearchFoundEvent', iptrw);
    RegisterProperty('OnProcessFile', 'TJclPeNameSearchNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeBorImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclPeImage', 'TJclPeBorImage') do
  with CL.AddClassN(CL.FindClass('TJclPeImage'),'TJclPeBorImage') do begin
    RegisterMethod('Constructor Create( ANoExceptions: Boolean)');
 // constructor Create(ANoExceptions: Boolean = False); override;
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function DependedPackages( List : TStrings; FullPathName, Descriptions : Boolean) : Boolean');
    RegisterMethod('Function FreeLibHandle : Boolean');
    RegisterProperty('Forms', 'TJclPeBorForm Integer', iptr);
    RegisterProperty('FormCount', 'Integer', iptr);
    RegisterProperty('FormFromName', 'TJclPeBorForm string', iptr);
    RegisterProperty('IsBorlandImage', 'Boolean', iptr);
    RegisterProperty('IsPackage', 'Boolean', iptr);
    RegisterProperty('LibHandle', 'THandle', iptr);
    RegisterProperty('PackageCompilerVersion', 'Integer', iptr);
    RegisterProperty('PackageInfo', 'TJclPePackageInfo', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeBorForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPeBorForm') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPeBorForm') do begin
    RegisterMethod('Procedure ConvertFormToText( const Stream : TStream);');
    RegisterMethod('Procedure ConvertFormToText1( const Strings : TStrings);');
    RegisterProperty('FormClassName', 'string', iptr);
    RegisterProperty('FormFlags', 'TFilerFlags', iptr);
    RegisterProperty('FormObjectName', 'string', iptr);
    RegisterProperty('FormPosition', 'Integer', iptr);
    RegisterProperty('DisplayName', 'string', iptr);
    RegisterProperty('ResItem', 'TJclPeResourceItem', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPePackageInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPePackageInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPePackageInfo') do begin
    RegisterMethod('Constructor Create( ALibHandle : THandle)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function PackageModuleTypeToString( Flags : Integer) : string');
    RegisterMethod('Function PackageOptionsToString( Flags : Integer) : string');
    RegisterMethod('Function ProducerToString( Flags : Integer) : string');
    RegisterMethod('Function UnitInfoFlagsToString( UnitFlags : Byte) : string');
    RegisterProperty('Available', 'Boolean', iptr);
    RegisterProperty('Contains', 'TStrings', iptr);
    RegisterProperty('ContainsCount', 'Integer', iptr);
    RegisterProperty('ContainsNames', 'string Integer', iptr);
    RegisterProperty('ContainsFlags', 'Byte Integer', iptr);
    RegisterProperty('Description', 'string', iptr);
    RegisterProperty('DcpName', 'string', iptr);
    RegisterProperty('EnsureExtension', 'Boolean', iptrw);
    RegisterProperty('Flags', 'Integer', iptr);
    RegisterProperty('Requires', 'TStrings', iptr);
    RegisterProperty('RequiresCount', 'Integer', iptr);
    RegisterProperty('RequiresNames', 'string Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPeImage') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPeImage') do begin
    RegisterMethod('Constructor Create( ANoExceptions : Boolean)');
      RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AttachLoadedModule( const Handle : HMODULE)');
    RegisterMethod('Function CalculateCheckSum : DWORD');
    RegisterMethod('Function DirectoryEntryToData( Directory : Word) : Pointer');
    RegisterMethod('Function GetSectionHeader( const SectionName : string; var Header : PImageSectionHeader) : Boolean');
    RegisterMethod('Function GetSectionName( const Header : PImageSectionHeader) : string');
    RegisterMethod('Function IsCLR : Boolean');
    RegisterMethod('Function IsSystemImage : Boolean');
    RegisterMethod('Function RawToVa( Raw : DWORD) : Pointer');
    RegisterMethod('Function RvaToSection( Rva : DWORD) : PImageSectionHeader');
    RegisterMethod('Function RvaToVa( Rva : DWORD) : Pointer');
    RegisterMethod('Function RvaToVaEx( Rva : DWORD) : Pointer');
    RegisterMethod('Function StatusOK : Boolean');
    RegisterMethod('Procedure TryGetNamesForOrdinalImports');
    RegisterMethod('Function VerifyCheckSum : Boolean');
    RegisterMethod('Function DebugTypeNames( DebugType : DWORD) : string');
    RegisterMethod('Function DirectoryNames( Directory : Word) : string');
    RegisterMethod('Function ExpandBySearchPath( const ModuleName, BasePath : string) : TFileName');
    RegisterMethod('Function HeaderNames( Index : TJclPeHeader) : string');
    RegisterMethod('Function LoadConfigNames( Index : TJclLoadConfig) : string');
    RegisterMethod('Function ShortSectionInfo( Characteristics : DWORD) : string');
    RegisterMethod('Function StampToDateTime( TimeDateStamp : DWORD) : TDateTime');
    RegisterProperty('AttachedImage', 'Boolean', iptr);
    RegisterProperty('CertificateList', 'TJclPeCertificateList', iptr);
    RegisterProperty('CLRHeader', 'TJclPeCLRHeader', iptr);
    RegisterProperty('DebugList', 'TJclPeDebugList', iptr);
    RegisterProperty('Description', 'string', iptr);
    RegisterProperty('Directories', 'TImageDataDirectory Word', iptr);
    RegisterProperty('DirectoryExists', 'Boolean Word', iptr);
    RegisterProperty('ExportList', 'TJclPeExportFuncList', iptr);
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('FileProperties', 'TJclPeFileProperties', iptr);
    RegisterProperty('HeaderValues', 'string TJclPeHeader', iptr);
    RegisterProperty('ImageSectionCount', 'Integer', iptr);
    RegisterProperty('ImageSectionHeaders', 'TImageSectionHeader Integer', iptr);
    RegisterProperty('ImageSectionNames', 'string Integer', iptr);
    RegisterProperty('ImageSectionNameFromRva', 'string DWORD', iptr);
    RegisterProperty('ImportList', 'TJclPeImportList', iptr);
    RegisterProperty('LoadConfigValues', 'string TJclLoadConfig', iptr);
    RegisterProperty('LoadedImage', 'TLoadedImage', iptr);
    RegisterProperty('MappedAddress', 'DWORD', iptr);
    RegisterProperty('OptionalHeader', 'TImageOptionalHeader', iptr);
    RegisterProperty('ReadOnlyAccess', 'Boolean', iptrw);
    RegisterProperty('RelocationList', 'TJclPeRelocList', iptr);
    RegisterProperty('ResourceList', 'TJclPeRootResourceList', iptr);
    RegisterProperty('Status', 'TJclPeImageStatus', iptr);
    RegisterProperty('UnusedHeaderBytes', 'TImageDataDirectory', iptr);
    RegisterProperty('VersionInfo', 'TJclFileVersionInfo', iptr);
    RegisterProperty('VersionInfoAvailable', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeCLRHeader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPeCLRHeader') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPeCLRHeader') do begin
    RegisterMethod('Constructor Create( AImage : TJclPeImage)');
    RegisterProperty('HasMetadata', 'Boolean', iptr);
    RegisterProperty('Header', 'TImageCor20Header', iptr);
    RegisterProperty('VersionString', 'string', iptr);
    RegisterProperty('Image', 'TJclPeImage', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeCertificateList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclPeImageBaseList', 'TJclPeCertificateList') do
  with CL.AddClassN(CL.FindClass('TJclPeImageBaseList'),'TJclPeCertificateList') do
  begin
    RegisterMethod('Constructor Create( AImage : TJclPeImage)');
    RegisterProperty('Items', 'TJclPeCertificate Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeCertificate(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPeCertificate') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPeCertificate') do begin
    RegisterProperty('Data', 'Pointer', iptr);
    RegisterProperty('Header', 'TWinCertificate', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeDebugList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclPeImageBaseList', 'TJclPeDebugList') do
  with CL.AddClassN(CL.FindClass('TJclPeImageBaseList'),'TJclPeDebugList') do begin
    RegisterMethod('Constructor Create( AImage : TJclPeImage)');
    RegisterProperty('Items', 'TImageDebugDirectory Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeRelocList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclPeImageBaseList', 'TJclPeRelocList') do
  with CL.AddClassN(CL.FindClass('TJclPeImageBaseList'),'TJclPeRelocList') do begin
    RegisterMethod('Constructor Create( AImage : TJclPeImage)');
    RegisterProperty('AllItems', 'TJclPeRelocation Integer', iptr);
    RegisterProperty('AllItemCount', 'Integer', iptr);
    RegisterProperty('Items', 'TJclPeRelocEntry Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeRelocEntry(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPeRelocEntry') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPeRelocEntry') do begin
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Relocations', 'TJclPeRelocation Integer', iptr);
    SetDefaultPropery('Relocations');
    RegisterProperty('Size', 'DWORD', iptr);
    RegisterProperty('VirtualAddress', 'DWORD', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeRootResourceList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclPeResourceList', 'TJclPeRootResourceList') do
  with CL.AddClassN(CL.FindClass('TJclPeResourceList'),'TJclPeRootResourceList') do
  begin
    RegisterMethod('Function FindResource( ResourceType : TJclPeResourceKind; const ResourceName : string) : TJclPeResourceItem;');
    RegisterMethod('Function FindResource1( const ResourceType : PChar; const ResourceName : PChar) : TJclPeResourceItem;');
    RegisterMethod('Function ListResourceNames( ResourceType : TJclPeResourceKind; const Strings : TStrings) : Boolean');
    RegisterProperty('ManifestContent', 'TStrings', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeResourceList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclPeImageBaseList', 'TJclPeResourceList') do
  with CL.AddClassN(CL.FindClass('TJclPeImageBaseList'),'TJclPeResourceList') do begin
    RegisterMethod('Constructor Create( AImage : TJclPeImage; AParentItem : TJclPeResourceItem; ADirectory : PImageResourceDirectory)');
    RegisterMethod('Function FindName( const Name : string) : TJclPeResourceItem');
    RegisterProperty('Directory', 'PImageResourceDirectory', iptr);
    RegisterProperty('Items', 'TJclPeResourceItem Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('ParentItem', 'TJclPeResourceItem', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeResourceItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPeResourceItem') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPeResourceItem') do begin
    RegisterMethod('Constructor Create( AImage : TJclPeImage; AParentItem : TJclPeResourceItem; AEntry : PImageResourceDirectoryEntry)');
    RegisterMethod('Function CompareName( AName : PChar) : Boolean');
    RegisterMethod('Procedure Free;');
    RegisterProperty('DataEntry', 'PImageResourceDataEntry', iptr);
    RegisterProperty('Entry', 'PImageResourceDirectoryEntry', iptr);
    RegisterProperty('Image', 'TJclPeImage', iptr);
    RegisterProperty('IsDirectory', 'Boolean', iptr);
    RegisterProperty('IsName', 'Boolean', iptr);
    RegisterProperty('LangID', 'LANGID', iptr);
    RegisterProperty('List', 'TJclPeResourceList', iptr);
    RegisterProperty('Level', 'Byte', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('ParameterName', 'string', iptr);
    RegisterProperty('ParentItem', 'TJclPeResourceItem', iptr);
    RegisterProperty('RawEntryData', 'Pointer', iptr);
    RegisterProperty('RawEntryDataSize', 'Integer', iptr);
    RegisterProperty('ResourceType', 'TJclPeResourceKind', iptr);
    RegisterProperty('ResourceTypeStr', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeResourceRawStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMemoryStream', 'TJclPeResourceRawStream') do
  with CL.AddClassN(CL.FindClass('TCustomMemoryStream'),'TJclPeResourceRawStream') do
  begin
    RegisterMethod('Constructor Create( AResourceItem : TJclPeResourceItem)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeExportFuncList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclPeImageBaseList', 'TJclPeExportFuncList') do
  with CL.AddClassN(CL.FindClass('TJclPeImageBaseList'),'TJclPeExportFuncList') do begin
    RegisterMethod('Constructor Create( AImage : TJclPeImage)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure CheckForwards( PeImageCache : TJclPeImagesCache)');
    RegisterMethod('Function ItemName( Item : TJclPeExportFuncItem) : string');
    RegisterMethod('Function OrdinalValid( Ordinal : DWORD) : Boolean');
    RegisterMethod('Procedure PrepareForFastNameSearch');
    RegisterMethod('Function SmartFindName( const CompareName : string; Options : TJclSmartCompOptions) : TJclPeExportFuncItem');
    RegisterMethod('Procedure SortList( SortType : TJclPeExportSort; Descending : Boolean)');
    RegisterProperty('AnyForwards', 'Boolean', iptr);
    RegisterProperty('Base', 'DWORD', iptr);
    RegisterProperty('ExportDir', 'PImageExportDirectory', iptr);
    RegisterProperty('ForwardedLibsList', 'TStrings', iptr);
    RegisterProperty('FunctionCount', 'DWORD', iptr);
    RegisterProperty('Items', 'TJclPeExportFuncItem Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('ItemFromAddress', 'TJclPeExportFuncItem DWORD', iptr);
    RegisterProperty('ItemFromName', 'TJclPeExportFuncItem string', iptr);
    RegisterProperty('ItemFromOrdinal', 'TJclPeExportFuncItem DWORD', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('TotalResolveCheck', 'TJclPeResolveCheck', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeExportFuncItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPeExportFuncItem') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPeExportFuncItem') do begin
    RegisterProperty('Address', 'DWORD', iptr);
    RegisterProperty('AddressOrForwardStr', 'string', iptr);
    RegisterProperty('IsExportedVariable', 'Boolean', iptr);
    RegisterProperty('IsForwarded', 'Boolean', iptr);
    RegisterProperty('ForwardedName', 'string', iptr);
    RegisterProperty('ForwardedLibName', 'string', iptr);
    RegisterProperty('ForwardedFuncOrdinal', 'DWORD', iptr);
    RegisterProperty('ForwardedFuncName', 'string', iptr);
    RegisterProperty('Hint', 'Word', iptr);
    RegisterProperty('MappedAddress', 'Pointer', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('Ordinal', 'Word', iptr);
    RegisterProperty('ResolveCheck', 'TJclPeResolveCheck', iptr);
    RegisterProperty('SectionName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeImportList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclPeImageBaseList', 'TJclPeImportList') do
  with CL.AddClassN(CL.FindClass('TJclPeImageBaseList'),'TJclPeImportList') do begin
    RegisterMethod('Constructor Create( AImage : TJclPeImage)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure CheckImports( PeImageCache : TJclPeImagesCache)');
    RegisterMethod('Function MakeBorlandImportTableForMappedImage : Boolean');
    RegisterMethod('Function SmartFindName( const CompareName, LibName : string; Options : TJclSmartCompOptions) : TJclPeImportFuncItem');
    RegisterMethod('Procedure SortAllItemsList( SortType : TJclPeImportSort; Descending : Boolean)');
    RegisterMethod('Procedure SortList( SortType : TJclPeImportLibSort)');
    RegisterMethod('Procedure TryGetNamesForOrdinalImports');
    RegisterProperty('AllItems', 'TJclPeImportFuncItem Integer', iptr);
    RegisterProperty('AllItemCount', 'Integer', iptr);
    RegisterProperty('FilterModuleName', 'string', iptrw);
    RegisterProperty('Items', 'TJclPeImportLibItem Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('LinkerProducer', 'TJclPeLinkerProducer', iptr);
    RegisterProperty('UniqueLibItemCount', 'Integer', iptr);
    RegisterProperty('UniqueLibItemFromName', 'TJclPeImportLibItem string', iptr);
    RegisterProperty('UniqueLibItems', 'TJclPeImportLibItem Integer', iptr);
    RegisterProperty('UniqueLibNames', 'string Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeImportLibItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclPeImageBaseList', 'TJclPeImportLibItem') do
  with CL.AddClassN(CL.FindClass('TJclPeImageBaseList'),'TJclPeImportLibItem') do begin
    RegisterMethod('Constructor Create( AImage : TJclPeImage)');
    RegisterMethod('Procedure SortList( SortType : TJclPeImportSort; Descending : Boolean)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('FileName', 'TFileName', iptr);
    RegisterProperty('ImportDescriptor', 'Pointer', iptr);
    RegisterProperty('ImportDirectoryIndex', 'Integer', iptr);
    RegisterProperty('ImportKind', 'TJclPeImportKind', iptr);
    RegisterProperty('Items', 'TJclPeImportFuncItem Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('OriginalName', 'string', iptr);
    RegisterProperty('ThunkData', 'PImageThunkData', iptr);
    RegisterProperty('TotalResolveCheck', 'TJclPeResolveCheck', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeImportFuncItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPeImportFuncItem') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPeImportFuncItem') do begin
    RegisterMethod('Procedure Free;');
    RegisterProperty('Ordinal', 'Word', iptr);
    RegisterProperty('Hint', 'Word', iptr);
    RegisterProperty('ImportLib', 'TJclPeImportLibItem', iptr);
    RegisterProperty('IndirectImportName', 'Boolean', iptr);
    RegisterProperty('IsByOrdinal', 'Boolean', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('ResolveCheck', 'TJclPeResolveCheck', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeBorImagesCache(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclPeImagesCache', 'TJclPeBorImagesCache') do
  with CL.AddClassN(CL.FindClass('TJclPeImagesCache'),'TJclPeBorImagesCache') do begin
    RegisterProperty('Images', 'TJclPeBorImage TFileName', iptr);
    SetDefaultPropery('Images');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeImagesCache(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPeImagesCache') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPeImagesCache') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Images', 'TJclPeImage TFileName', iptr);
    SetDefaultPropery('Images');
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeImageBaseList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TJclPeImageBaseList') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TJclPeImageBaseList') do begin
    RegisterMethod('Constructor Create( AImage : TJclPeImage)');
    RegisterProperty('Image', 'TJclPeImage', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclPeImage(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJclSmartCompOption', '( scSimpleCompare, scIgnoreCase )');
  CL.AddTypeS('TJclSmartCompOptions', 'set of TJclSmartCompOption');
 CL.AddDelphiFunction('Function PeStripFunctionAW( const FunctionName : string) : string');
 CL.AddDelphiFunction('Function PeSmartFunctionNameSame( const ComparedName, FunctionName: string; Options: TJclSmartCompOptions) : Boolean');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclPeImageError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclPeImage');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclPeBorImage');
  //CL.AddTypeS('TJclPeImageClass', 'class of TJclPeImage');
  SIRegister_TJclPeImageBaseList(CL);
  SIRegister_TJclPeImagesCache(CL);
  SIRegister_TJclPeBorImagesCache(CL);
  CL.AddTypeS('TJclPeImportSort', '( isName, isOrdinal, isHint, isLibImport )');
  CL.AddTypeS('TJclPeImportLibSort', '( ilName, ilIndex )');
  CL.AddTypeS('TJclPeImportKind', '( ikImport, ikDelayImport, ikBoundImport )');
  CL.AddTypeS('TJclPeResolveCheck', '( icNotChecked, icResolved, icUnresolved )');
  CL.AddTypeS('TJclPeLinkerProducer', '( lrBorland, lrMicrosoft )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclPeImportLibItem');
  SIRegister_TJclPeImportFuncItem(CL);
  SIRegister_TJclPeImportLibItem(CL);
  SIRegister_TJclPeImportList(CL);
  CL.AddTypeS('TJclPeExportSort', '(esName, esOrdinal, esHint, esAddress, esForwarded, esAddrOrFwd, esSection )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclPeExportFuncList');
  SIRegister_TJclPeExportFuncItem(CL);
  SIRegister_TJclPeExportFuncList(CL);
  CL.AddTypeS('TJclPeResourceKind', '( rtUnknown0, rtCursorEntry, rtBitmap, rtI'
   +'conEntry, rtMenu, rtDialog, rtString, rtFontDir, rtFont, rtAccelerators, r'
   +'tRCData, rtMessageTable, rtCursor, rtUnknown13, rtIcon, rtUnknown15, rtVer'
   +'sion, rtDlgInclude, rtUnknown18, rtPlugPlay, rtVxd, rtAniCursor, rtAniIcon'
   +', rtHmtl, rtManifest, rtUserDefined )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclPeResourceList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclPeResourceItem');
  SIRegister_TJclPeResourceRawStream(CL);
  SIRegister_TJclPeResourceItem(CL);
  SIRegister_TJclPeResourceList(CL);
  SIRegister_TJclPeRootResourceList(CL);
  CL.AddTypeS('TJclPeRelocation', 'record Address: Word; RelocType: Byte; VirtualAddress : DWORD; end');
  { CL.AddTypeS('_IMAGE_FILE_HEADER', 'record Machine : Word; NumberOfSections : '
   +'Word; TimeDateStamp : DWORD; PointerToSymbolTable : DWORD; NumberOfSymbols'
   +' : DWORD; SizeOfOptionalHeader : Word; Characteristics : Word; end');
  CL.AddTypeS('TImageFileHeader', '_IMAGE_FILE_HEADER');   //also in upsi_utilsmax4   }
  // CL.AddTypeS('TImageFileHeader', 'record Size : DWORD; CreationTime : TDat'
   //+'eTime; LastAccessTime : TDateTime; LastWriteTime : TDateTime; Attributes: Integer; end');
  CL.AddTypeS('TImageNtHeaders', 'record Signature: DWORD; FileHeader: TImageFileHeader; OptionalHeader : DWORD; end');

 { _IMAGE_FILE_HEADER = packed record
    Machine: Word;
    NumberOfSections: Word;
    TimeDateStamp: DWORD;
    PointerToSymbolTable: DWORD;
    NumberOfSymbols: DWORD;
    SizeOfOptionalHeader: Word;
    Characteristics: Word;
  end;
   _IMAGE_NT_HEADERS = packed record
    Signature: DWORD;
    FileHeader: TImageFileHeader;
    OptionalHeader: TImageOptionalHeader;
  end; }
  SIRegister_TJclPeRelocEntry(CL);
  SIRegister_TJclPeRelocList(CL);
  //SIRegister_TJclPeDebugList(CL);
  SIRegister_TJclPeCertificate(CL);
  SIRegister_TJclPeCertificateList(CL);
  SIRegister_TJclPeCLRHeader(CL);
  CL.AddTypeS('TJclPeHeader', '( JclPeHeader_Signature, JclPeHeader_Machine, Jc'
   +'lPeHeader_NumberOfSections, JclPeHeader_TimeDateStamp, JclPeHeader_Pointer'
   +'ToSymbolTable, JclPeHeader_NumberOfSymbols, JclPeHeader_SizeOfOptionalHead'
   +'er, JclPeHeader_Characteristics, JclPeHeader_Magic, JclPeHeader_LinkerVers'
   +'ion, JclPeHeader_SizeOfCode, JclPeHeader_SizeOfInitializedData, JclPeHeade'
   +'r_SizeOfUninitializedData, JclPeHeader_AddressOfEntryPoint, JclPeHeader_Ba'
   +'seOfCode, JclPeHeader_BaseOfData, JclPeHeader_ImageBase, JclPeHeader_Secti'
   +'onAlignment, JclPeHeader_FileAlignment, JclPeHeader_OperatingSystemVersion'
   +', JclPeHeader_ImageVersion, JclPeHeader_SubsystemVersion, JclPeHeader_Win3'
   +'2VersionValue, JclPeHeader_SizeOfImage, JclPeHeader_SizeOfHeaders, JclPeHe'
   +'ader_CheckSum, JclPeHeader_Subsystem, JclPeHeader_DllCharacteristics, JclP'
   +'eHeader_SizeOfStackReserve, JclPeHeader_SizeOfStackCommit, JclPeHeader_Siz'
   +'eOfHeapReserve, JclPeHeader_SizeOfHeapCommit, JclPeHeader_LoaderFlags, Jcl'
   +'PeHeader_NumberOfRvaAndSizes )');
  CL.AddTypeS('TJclLoadConfig', '( JclLoadConfig_Characteristics, JclLoadConfig'
   +'_TimeDateStamp, JclLoadConfig_Version, JclLoadConfig_GlobalFlagsClear, Jcl'
   +'LoadConfig_GlobalFlagsSet, JclLoadConfig_CriticalSectionDefaultTimeout, Jc'
   +'lLoadConfig_DeCommitFreeBlockThreshold, JclLoadConfig_DeCommitTotalFreeThr'
   +'eshold, JclLoadConfig_LockPrefixTable, JclLoadConfig_MaximumAllocationSize'
   +', JclLoadConfig_VirtualMemoryThreshold, JclLoadConfig_ProcessHeapFlags, Jc'
   +'lLoadConfig_ProcessAffinityMask, JclLoadConfig_CSDVersion, JclLoadConfig_R'
   +'eserved1, JclLoadConfig_EditList, JclLoadConfig_Reserved )');
  CL.AddTypeS('TJclPeFileProperties', 'record Size : DWORD; CreationTime : TDat'
   +'eTime; LastAccessTime : TDateTime; LastWriteTime : TDateTime; Attributes: Integer; end');
  CL.AddTypeS('TJclPeImageStatus', '( stNotLoaded, stOk, stNotPE, stNotFound, stError )');
  SIRegister_TJclPeImage(CL);
  SIRegister_TJclPePackageInfo(CL);
  SIRegister_TJclPeBorForm(CL);
  SIRegister_TJclPeBorImage(CL);
  CL.AddTypeS('TJclPeNameSearchOption', '( seImports, seDelayImports, seBoundImports, seExports )');
  CL.AddTypeS('TJclPeNameSearchOptions', 'set of TJclPeNameSearchOption');
  CL.AddTypeS('TJclPeNameSearchNotifyEvent', 'Procedure ( Sender : TObject; PeI'
   +'mage : TJclPeImage; var Process : Boolean)');
  CL.AddTypeS('TJclPeNameSearchFoundEvent', 'Procedure ( Sender : TObject; cons'
   +'t FileName : TFileName; const FunctionName : string; Option : TJclPeNameSearchOption)');
  SIRegister_TJclPeNameSearch(CL);
  CL.AddTypeS('TJclRebaseImageInfo', 'record OldImageSize : DWORD; OldImageBase'
   +' : DWORD; NewImageSize : DWORD; NewImageBase : DWORD; end');
 CL.AddDelphiFunction('Function IsValidPeFile( const FileName : TFileName) : Boolean');
 CL.AddDelphiFunction('Function PeGetNtHeaders( const FileName : TFileName; var NtHeaders : TImageNtHeaders) : Boolean');
 CL.AddDelphiFunction('Function PeCreateNameHintTable( const FileName : TFileName) : Boolean');
 CL.AddDelphiFunction('Function PeRebaseImage( const ImageName : TFileName; NewBase : DWORD; TimeStamp : DWORD; MaxNewSize : DWORD) : TJclRebaseImageInfo');
 CL.AddDelphiFunction('Function PeVerifyCheckSum( const FileName : TFileName) : Boolean');
 CL.AddDelphiFunction('Function PeClearCheckSum( const FileName : TFileName) : Boolean');
 CL.AddDelphiFunction('Function PeUpdateCheckSum( const FileName : TFileName) : Boolean');
 CL.AddDelphiFunction('Function PeDoesExportFunction( const FileName : TFileName; const FunctionName : string; Options : TJclSmartCompOptions) : Boolean');
 CL.AddDelphiFunction('Function PeIsExportFunctionForwardedEx( const FileName : TFileName; const FunctionName : string; var ForwardedName : string; Options : TJclSmartCompOptions) : Boolean');
 CL.AddDelphiFunction('Function PeIsExportFunctionForwarded( const FileName : TFileName; const FunctionName : string; Options : TJclSmartCompOptions) : Boolean');
 CL.AddDelphiFunction('Function PeDoesImportFunction( const FileName : TFileName; const FunctionName : string; const LibraryName : string; Options : TJclSmartCompOptions) : Boolean');
 CL.AddDelphiFunction('Function PeDoesImportLibrary( const FileName : TFileName; const LibraryName : string; Recursive : Boolean) : Boolean');
 CL.AddDelphiFunction('Function PeImportedLibraries( const FileName : TFileName; const LibrariesList : TStrings; Recursive : Boolean; FullPathName : Boolean) : Boolean');
 CL.AddDelphiFunction('Function PeImportedFunctions( const FileName : TFileName; const FunctionsList : TStrings; const LibraryName : string; IncludeLibNames : Boolean) : Boolean');
 CL.AddDelphiFunction('Function PeExportedFunctions( const FileName : TFileName; const FunctionsList : TStrings) : Boolean');
 CL.AddDelphiFunction('Function PeExportedNames( const FileName : TFileName; const FunctionsList : TStrings) : Boolean');
 CL.AddDelphiFunction('Function PeExportedVariables( const FileName : TFileName; const FunctionsList : TStrings) : Boolean');
 CL.AddDelphiFunction('Function PeResourceKindNames( const FileName : TFileName; ResourceType : TJclPeResourceKind; const NamesList : TStrings) : Boolean');
 CL.AddDelphiFunction('Function PeBorFormNames( const FileName : TFileName; const NamesList : TStrings) : Boolean');
 CL.AddDelphiFunction('Function PeBorDependedPackages( const FileName : TFileName; PackagesList : TStrings; FullPathName, Descriptions : Boolean) : Boolean');
 CL.AddDelphiFunction('Function PeFindMissingImports( const FileName : TFileName; MissingImportsList : TStrings) : Boolean;');
 CL.AddDelphiFunction('Function PeFindMissingImports1( RequiredImportsList, MissingImportsList : TStrings) : Boolean;');
 CL.AddDelphiFunction('Function PeCreateRequiredImportList( const FileName : TFileName; RequiredImportsList : TStrings) : Boolean');
 //CL.AddDelphiFunction('Function PeMapImgNtHeaders( const BaseAddress : Pointer) : PImageNtHeaders');
 //CL.AddDelphiFunction('Function PeMapImgLibraryName( const BaseAddress : Pointer) : string');
 //CL.AddDelphiFunction('Function PeMapImgSections( const NtHeaders : PImageNtHeaders) : PImageSectionHeader');
 //CL.AddDelphiFunction('Function PeMapImgFindSection( const NtHeaders : PImageNtHeaders; const SectionName : string) : PImageSectionHeader');
 CL.AddDelphiFunction('Function PeMapImgExportedVariables( const Module : HMODULE; const VariablesList : TStrings) : Boolean');
 //CL.AddDelphiFunction('Function PeMapImgResolvePackageThunk( Address : Pointer) : Pointer');
 CL.AddDelphiFunction('Function PeMapFindResource( const Module : HMODULE; const ResourceType : PChar; const ResourceName : string) : ___Pointer');
  SIRegister_TJclPeSectionStream(CL);
  SIRegister_TJclPeMapImgHookItem(CL);
  SIRegister_TJclPeMapImgHooks(CL);
 //CL.AddDelphiFunction('Function PeDbgImgNtHeaders( ProcessHandle : THandle; BaseAddress : Pointer; var NtHeaders : TImageNtHeaders) : Boolean');
 //CL.AddDelphiFunction('Function PeDbgImgLibraryName( ProcessHandle : THandle; BaseAddress : Pointer; var Name : string) : Boolean');
  CL.AddTypeS('TJclBorUmSymbolKind', '(skData, skFunction, skConstructor, skDestructor, skRTTI, skVTable )');
  CL.AddTypeS('TJclBorUmSymbolModifier', '( smQualified, smLinkProc )');
  CL.AddTypeS('TJclBorUmSymbolModifiers', 'set of TJclBorUmSymbolModifier');
  CL.AddTypeS('TJclBorUmDescription', 'record Kind : TJclBorUmSymbolKind; Modifiers : TJclBorUmSymbolModifiers; end');
  CL.AddTypeS('TJclBorUmResult', '( urOk, urNotMangled, urMicrosoft, urError )');
  CL.AddTypeS('TJclPeUmResult', '( umNotMangled, umBorland, umMicrosoft )');
 CL.AddDelphiFunction('Function PeBorUnmangleName( const Name : string; var Unmangled : string; var Description : TJclBorUmDescription; var BasePos : Integer) : TJclBorUmResult;');
 CL.AddDelphiFunction('Function PeBorUnmangleName1( const Name : string; var Unmangled : string; var Description : TJclBorUmDescription) : TJclBorUmResult;');
 CL.AddDelphiFunction('Function PeBorUnmangleName2( const Name : string; var Unmangled : string) : TJclBorUmResult;');
 CL.AddDelphiFunction('Function PeBorUnmangleName3( const Name : string) : string;');
 CL.AddDelphiFunction('Function PeIsNameMangled( const Name : string) : TJclPeUmResult');
 CL.AddDelphiFunction('Function PeUnmangleName( const Name : string; var Unmangled : string) : TJclPeUmResult');
 CL.AddDelphiFunction('function list_modules(aexename: string): string;');
 CL.AddDelphiFunction('function list_units(aexename: string): string;');
 CL.AddDelphiFunction('procedure GetResourceHeader(var ResourceHeader: String; const FormName: String; const FileSize: Integer);');
 CL.AddDelphiFunction('function GetResourceFormFile(List: TStrings; const FormName, FileName: String) : Boolean;');
 CL.AddDelphiFunction('function GetImageBase(const FileName: TFileName): DWORD;');


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function PeBorUnmangleName3_P( const Name : string) : string;
Begin Result := JclPeImage.PeBorUnmangleName(Name); END;

(*----------------------------------------------------------------------------*)
Function PeBorUnmangleName2_P( const Name : string; var Unmangled : string) : TJclBorUmResult;
Begin Result := JclPeImage.PeBorUnmangleName(Name, Unmangled); END;

(*----------------------------------------------------------------------------*)
Function PeBorUnmangleName1_P( const Name : string; var Unmangled : string; var Description : TJclBorUmDescription) : TJclBorUmResult;
Begin Result := JclPeImage.PeBorUnmangleName(Name, Unmangled, Description); END;

(*----------------------------------------------------------------------------*)
Function PeBorUnmangleName_P( const Name : string; var Unmangled : string; var Description : TJclBorUmDescription; var BasePos : Integer) : TJclBorUmResult;
Begin Result := JclPeImage.PeBorUnmangleName(Name, Unmangled, Description, BasePos); END;

(*----------------------------------------------------------------------------*)
procedure TJclPeMapImgHooksItemFromNewAddress_R(Self: TJclPeMapImgHooks; var T: TJclPeMapImgHookItem; const t1: Pointer);
begin T := Self.ItemFromNewAddress[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeMapImgHooksItemFromOriginalAddress_R(Self: TJclPeMapImgHooks; var T: TJclPeMapImgHookItem; const t1: Pointer);
begin T := Self.ItemFromOriginalAddress[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeMapImgHooksItems_R(Self: TJclPeMapImgHooks; var T: TJclPeMapImgHookItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeMapImgHookItemOriginalAddress_R(Self: TJclPeMapImgHookItem; var T: Pointer);
begin T := Self.OriginalAddress; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeMapImgHookItemNewAddress_R(Self: TJclPeMapImgHookItem; var T: Pointer);
begin T := Self.NewAddress; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeMapImgHookItemModuleName_R(Self: TJclPeMapImgHookItem; var T: string);
begin T := Self.ModuleName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeMapImgHookItemFunctionName_R(Self: TJclPeMapImgHookItem; var T: string);
begin T := Self.FunctionName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeMapImgHookItemBaseAddress_R(Self: TJclPeMapImgHookItem; var T: Pointer);
begin T := Self.BaseAddress; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeSectionStreamSectionHeader_R(Self: TJclPeSectionStream; var T: TImageSectionHeader);
begin T := Self.SectionHeader; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeSectionStreamInstance_R(Self: TJclPeSectionStream; var T: HMODULE);
begin T := Self.Instance; end;

(*----------------------------------------------------------------------------*)
Function PeFindMissingImports1_P( RequiredImportsList, MissingImportsList : TStrings) : Boolean;
Begin Result := JclPeImage.PeFindMissingImports(RequiredImportsList, MissingImportsList); END;

(*----------------------------------------------------------------------------*)
Function PeFindMissingImports_P( const FileName : TFileName; MissingImportsList : TStrings) : Boolean;
Begin Result := JclPeImage.PeFindMissingImports(FileName, MissingImportsList); END;

(*----------------------------------------------------------------------------*)
procedure TJclPeNameSearchOnProcessFile_W(Self: TJclPeNameSearch; const T: TJclPeNameSearchNotifyEvent);
begin Self.OnProcessFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeNameSearchOnProcessFile_R(Self: TJclPeNameSearch; var T: TJclPeNameSearchNotifyEvent);
begin T := Self.OnProcessFile; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeNameSearchOnFound_W(Self: TJclPeNameSearch; const T: TJclPeNameSearchFoundEvent);
begin Self.OnFound := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeNameSearchOnFound_R(Self: TJclPeNameSearch; var T: TJclPeNameSearchFoundEvent);
begin T := Self.OnFound; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorImagePackageInfo_R(Self: TJclPeBorImage; var T: TJclPePackageInfo);
begin T := Self.PackageInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorImagePackageCompilerVersion_R(Self: TJclPeBorImage; var T: Integer);
begin T := Self.PackageCompilerVersion; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorImageLibHandle_R(Self: TJclPeBorImage; var T: THandle);
begin T := Self.LibHandle; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorImageIsPackage_R(Self: TJclPeBorImage; var T: Boolean);
begin T := Self.IsPackage; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorImageIsBorlandImage_R(Self: TJclPeBorImage; var T: Boolean);
begin T := Self.IsBorlandImage; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorImageFormFromName_R(Self: TJclPeBorImage; var T: TJclPeBorForm; const t1: string);
begin T := Self.FormFromName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorImageFormCount_R(Self: TJclPeBorImage; var T: Integer);
begin T := Self.FormCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorImageForms_R(Self: TJclPeBorImage; var T: TJclPeBorForm; const t1: Integer);
begin T := Self.Forms[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorFormResItem_R(Self: TJclPeBorForm; var T: TJclPeResourceItem);
begin T := Self.ResItem; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorFormDisplayName_R(Self: TJclPeBorForm; var T: string);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorFormFormPosition_R(Self: TJclPeBorForm; var T: Integer);
begin T := Self.FormPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorFormFormObjectName_R(Self: TJclPeBorForm; var T: string);
begin T := Self.FormObjectName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorFormFormFlags_R(Self: TJclPeBorForm; var T: TFilerFlags);
begin T := Self.FormFlags; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorFormFormClassName_R(Self: TJclPeBorForm; var T: string);
begin T := Self.FormClassName; end;

(*----------------------------------------------------------------------------*)
Procedure TJclPeBorFormConvertFormToText1_P(Self: TJclPeBorForm;  const Strings : TStrings);
Begin Self.ConvertFormToText(Strings); END;

(*----------------------------------------------------------------------------*)
Procedure TJclPeBorFormConvertFormToText_P(Self: TJclPeBorForm;  const Stream : TStream);
Begin Self.ConvertFormToText(Stream); END;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoRequiresNames_R(Self: TJclPePackageInfo; var T: string; const t1: Integer);
begin T := Self.RequiresNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoRequiresCount_R(Self: TJclPePackageInfo; var T: Integer);
begin T := Self.RequiresCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoRequires_R(Self: TJclPePackageInfo; var T: TStrings);
begin T := Self.Requires; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoFlags_R(Self: TJclPePackageInfo; var T: Integer);
begin T := Self.Flags; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoEnsureExtension_W(Self: TJclPePackageInfo; const T: Boolean);
begin Self.EnsureExtension := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoEnsureExtension_R(Self: TJclPePackageInfo; var T: Boolean);
begin T := Self.EnsureExtension; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoDcpName_R(Self: TJclPePackageInfo; var T: string);
begin T := Self.DcpName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoDescription_R(Self: TJclPePackageInfo; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoContainsFlags_R(Self: TJclPePackageInfo; var T: Byte; const t1: Integer);
begin T := Self.ContainsFlags[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoContainsNames_R(Self: TJclPePackageInfo; var T: string; const t1: Integer);
begin T := Self.ContainsNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoContainsCount_R(Self: TJclPePackageInfo; var T: Integer);
begin T := Self.ContainsCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoContains_R(Self: TJclPePackageInfo; var T: TStrings);
begin T := Self.Contains; end;

(*----------------------------------------------------------------------------*)
procedure TJclPePackageInfoAvailable_R(Self: TJclPePackageInfo; var T: Boolean);
begin T := Self.Available; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageVersionInfoAvailable_R(Self: TJclPeImage; var T: Boolean);
begin T := Self.VersionInfoAvailable; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageVersionInfo_R(Self: TJclPeImage; var T: TJclFileVersionInfo);
begin T := Self.VersionInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageUnusedHeaderBytes_R(Self: TJclPeImage; var T: TImageDataDirectory);
begin T := Self.UnusedHeaderBytes; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageStatus_R(Self: TJclPeImage; var T: TJclPeImageStatus);
begin T := Self.Status; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageResourceList_R(Self: TJclPeImage; var T: TJclPeRootResourceList);
begin T := Self.ResourceList; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageRelocationList_R(Self: TJclPeImage; var T: TJclPeRelocList);
begin T := Self.RelocationList; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageReadOnlyAccess_W(Self: TJclPeImage; const T: Boolean);
begin Self.ReadOnlyAccess := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageReadOnlyAccess_R(Self: TJclPeImage; var T: Boolean);
begin T := Self.ReadOnlyAccess; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageOptionalHeader_R(Self: TJclPeImage; var T: TImageOptionalHeader);
begin T := Self.OptionalHeader; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageMappedAddress_R(Self: TJclPeImage; var T: DWORD);
begin T := Self.MappedAddress; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageLoadedImage_R(Self: TJclPeImage; var T: TLoadedImage);
begin T := Self.LoadedImage; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageLoadConfigValues_R(Self: TJclPeImage; var T: string; const t1: TJclLoadConfig);
begin T := Self.LoadConfigValues[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageImportList_R(Self: TJclPeImage; var T: TJclPeImportList);
begin T := Self.ImportList; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageImageSectionNameFromRva_R(Self: TJclPeImage; var T: string; const t1: DWORD);
begin T := Self.ImageSectionNameFromRva[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageImageSectionNames_R(Self: TJclPeImage; var T: string; const t1: Integer);
begin T := Self.ImageSectionNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageImageSectionHeaders_R(Self: TJclPeImage; var T: TImageSectionHeader; const t1: Integer);
begin T := Self.ImageSectionHeaders[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageImageSectionCount_R(Self: TJclPeImage; var T: Integer);
begin T := Self.ImageSectionCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageHeaderValues_R(Self: TJclPeImage; var T: string; const t1: TJclPeHeader);
begin T := Self.HeaderValues[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageFileProperties_R(Self: TJclPeImage; var T: TJclPeFileProperties);
begin T := Self.FileProperties; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageFileName_W(Self: TJclPeImage; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageFileName_R(Self: TJclPeImage; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageExportList_R(Self: TJclPeImage; var T: TJclPeExportFuncList);
begin T := Self.ExportList; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageDirectoryExists_R(Self: TJclPeImage; var T: Boolean; const t1: Word);
begin T := Self.DirectoryExists[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageDirectories_R(Self: TJclPeImage; var T: TImageDataDirectory; const t1: Word);
begin T := Self.Directories[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageDescription_R(Self: TJclPeImage; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageDebugList_R(Self: TJclPeImage; var T: TJclPeDebugList);
begin T := Self.DebugList; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageCLRHeader_R(Self: TJclPeImage; var T: TJclPeCLRHeader);
begin T := Self.CLRHeader; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageCertificateList_R(Self: TJclPeImage; var T: TJclPeCertificateList);
begin T := Self.CertificateList; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageAttachedImage_R(Self: TJclPeImage; var T: Boolean);
begin T := Self.AttachedImage; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeCLRHeaderImage_R(Self: TJclPeCLRHeader; var T: TJclPeImage);
begin T := Self.Image; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeCLRHeaderVersionString_R(Self: TJclPeCLRHeader; var T: string);
begin T := Self.VersionString; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeCLRHeaderHeader_R(Self: TJclPeCLRHeader; var T: TImageCor20Header);
begin T := Self.Header; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeCLRHeaderHasMetadata_R(Self: TJclPeCLRHeader; var T: Boolean);
begin T := Self.HasMetadata; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeCertificateListItems_R(Self: TJclPeCertificateList; var T: TJclPeCertificate; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeCertificateHeader_R(Self: TJclPeCertificate; var T: TWinCertificate);
begin T := Self.Header; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeCertificateData_R(Self: TJclPeCertificate; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeDebugListItems_R(Self: TJclPeDebugList; var T: TImageDebugDirectory; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeRelocListItems_R(Self: TJclPeRelocList; var T: TJclPeRelocEntry; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeRelocListAllItemCount_R(Self: TJclPeRelocList; var T: Integer);
begin T := Self.AllItemCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeRelocListAllItems_R(Self: TJclPeRelocList; var T: TJclPeRelocation; const t1: Integer);
begin T := Self.AllItems[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeRelocEntryVirtualAddress_R(Self: TJclPeRelocEntry; var T: DWORD);
begin T := Self.VirtualAddress; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeRelocEntrySize_R(Self: TJclPeRelocEntry; var T: DWORD);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeRelocEntryRelocations_R(Self: TJclPeRelocEntry; var T: TJclPeRelocation; const t1: Integer);
begin T := Self.Relocations[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeRelocEntryCount_R(Self: TJclPeRelocEntry; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeRootResourceListManifestContent_R(Self: TJclPeRootResourceList; var T: TStrings);
begin T := Self.ManifestContent; end;

(*----------------------------------------------------------------------------*)
Function TJclPeRootResourceListFindResource1_P(Self: TJclPeRootResourceList;  const ResourceType : PChar; const ResourceName : PChar) : TJclPeResourceItem;
Begin Result := Self.FindResource(ResourceType, ResourceName); END;

(*----------------------------------------------------------------------------*)
Function TJclPeRootResourceListFindResource_P(Self: TJclPeRootResourceList;  ResourceType : TJclPeResourceKind; const ResourceName : string) : TJclPeResourceItem;
Begin Result := Self.FindResource(ResourceType, ResourceName); END;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceListParentItem_R(Self: TJclPeResourceList; var T: TJclPeResourceItem);
begin T := Self.ParentItem; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceListItems_R(Self: TJclPeResourceList; var T: TJclPeResourceItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceListDirectory_R(Self: TJclPeResourceList; var T: PImageResourceDirectory);
begin T := Self.Directory; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemResourceTypeStr_R(Self: TJclPeResourceItem; var T: string);
begin T := Self.ResourceTypeStr; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemResourceType_R(Self: TJclPeResourceItem; var T: TJclPeResourceKind);
begin T := Self.ResourceType; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemRawEntryDataSize_R(Self: TJclPeResourceItem; var T: Integer);
begin T := Self.RawEntryDataSize; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemRawEntryData_R(Self: TJclPeResourceItem; var T: Pointer);
begin T := Self.RawEntryData; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemParentItem_R(Self: TJclPeResourceItem; var T: TJclPeResourceItem);
begin T := Self.ParentItem; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemParameterName_R(Self: TJclPeResourceItem; var T: string);
begin T := Self.ParameterName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemName_R(Self: TJclPeResourceItem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemLevel_R(Self: TJclPeResourceItem; var T: Byte);
begin T := Self.Level; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemList_R(Self: TJclPeResourceItem; var T: TJclPeResourceList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemLangID_R(Self: TJclPeResourceItem; var T: LANGID);
begin T := Self.LangID; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemIsName_R(Self: TJclPeResourceItem; var T: Boolean);
begin T := Self.IsName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemIsDirectory_R(Self: TJclPeResourceItem; var T: Boolean);
begin T := Self.IsDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemImage_R(Self: TJclPeResourceItem; var T: TJclPeImage);
begin T := Self.Image; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemEntry_R(Self: TJclPeResourceItem; var T: PImageResourceDirectoryEntry);
begin T := Self.Entry; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeResourceItemDataEntry_R(Self: TJclPeResourceItem; var T: PImageResourceDataEntry);
begin T := Self.DataEntry; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncListTotalResolveCheck_R(Self: TJclPeExportFuncList; var T: TJclPeResolveCheck);
begin T := Self.TotalResolveCheck; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncListName_R(Self: TJclPeExportFuncList; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncListItemFromOrdinal_R(Self: TJclPeExportFuncList; var T: TJclPeExportFuncItem; const t1: DWORD);
begin T := Self.ItemFromOrdinal[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncListItemFromName_R(Self: TJclPeExportFuncList; var T: TJclPeExportFuncItem; const t1: string);
begin T := Self.ItemFromName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncListItemFromAddress_R(Self: TJclPeExportFuncList; var T: TJclPeExportFuncItem; const t1: DWORD);
begin T := Self.ItemFromAddress[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncListItems_R(Self: TJclPeExportFuncList; var T: TJclPeExportFuncItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncListFunctionCount_R(Self: TJclPeExportFuncList; var T: DWORD);
begin T := Self.FunctionCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncListForwardedLibsList_R(Self: TJclPeExportFuncList; var T: TStrings);
begin T := Self.ForwardedLibsList; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncListExportDir_R(Self: TJclPeExportFuncList; var T: PImageExportDirectory);
begin T := Self.ExportDir; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncListBase_R(Self: TJclPeExportFuncList; var T: DWORD);
begin T := Self.Base; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncListAnyForwards_R(Self: TJclPeExportFuncList; var T: Boolean);
begin T := Self.AnyForwards; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemSectionName_R(Self: TJclPeExportFuncItem; var T: string);
begin T := Self.SectionName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemResolveCheck_R(Self: TJclPeExportFuncItem; var T: TJclPeResolveCheck);
begin T := Self.ResolveCheck; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemOrdinal_R(Self: TJclPeExportFuncItem; var T: Word);
begin T := Self.Ordinal; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemName_R(Self: TJclPeExportFuncItem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemMappedAddress_R(Self: TJclPeExportFuncItem; var T: Pointer);
begin T := Self.MappedAddress; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemHint_R(Self: TJclPeExportFuncItem; var T: Word);
begin T := Self.Hint; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemForwardedFuncName_R(Self: TJclPeExportFuncItem; var T: string);
begin T := Self.ForwardedFuncName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemForwardedFuncOrdinal_R(Self: TJclPeExportFuncItem; var T: DWORD);
begin T := Self.ForwardedFuncOrdinal; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemForwardedLibName_R(Self: TJclPeExportFuncItem; var T: string);
begin T := Self.ForwardedLibName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemForwardedName_R(Self: TJclPeExportFuncItem; var T: string);
begin T := Self.ForwardedName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemIsForwarded_R(Self: TJclPeExportFuncItem; var T: Boolean);
begin T := Self.IsForwarded; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemIsExportedVariable_R(Self: TJclPeExportFuncItem; var T: Boolean);
begin T := Self.IsExportedVariable; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemAddressOrForwardStr_R(Self: TJclPeExportFuncItem; var T: string);
begin T := Self.AddressOrForwardStr; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeExportFuncItemAddress_R(Self: TJclPeExportFuncItem; var T: DWORD);
begin T := Self.Address; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportListUniqueLibNames_R(Self: TJclPeImportList; var T: string; const t1: Integer);
begin T := Self.UniqueLibNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportListUniqueLibItems_R(Self: TJclPeImportList; var T: TJclPeImportLibItem; const t1: Integer);
begin T := Self.UniqueLibItems[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportListUniqueLibItemFromName_R(Self: TJclPeImportList; var T: TJclPeImportLibItem; const t1: string);
begin T := Self.UniqueLibItemFromName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportListUniqueLibItemCount_R(Self: TJclPeImportList; var T: Integer);
begin T := Self.UniqueLibItemCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportListLinkerProducer_R(Self: TJclPeImportList; var T: TJclPeLinkerProducer);
begin T := Self.LinkerProducer; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportListItems_R(Self: TJclPeImportList; var T: TJclPeImportLibItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportListFilterModuleName_W(Self: TJclPeImportList; const T: string);
begin Self.FilterModuleName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportListFilterModuleName_R(Self: TJclPeImportList; var T: string);
begin T := Self.FilterModuleName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportListAllItemCount_R(Self: TJclPeImportList; var T: Integer);
begin T := Self.AllItemCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportListAllItems_R(Self: TJclPeImportList; var T: TJclPeImportFuncItem; const t1: Integer);
begin T := Self.AllItems[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportLibItemTotalResolveCheck_R(Self: TJclPeImportLibItem; var T: TJclPeResolveCheck);
begin T := Self.TotalResolveCheck; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportLibItemThunkData_R(Self: TJclPeImportLibItem; var T: PImageThunkData);
begin T := Self.ThunkData; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportLibItemOriginalName_R(Self: TJclPeImportLibItem; var T: string);
begin T := Self.OriginalName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportLibItemName_R(Self: TJclPeImportLibItem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportLibItemItems_R(Self: TJclPeImportLibItem; var T: TJclPeImportFuncItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportLibItemImportKind_R(Self: TJclPeImportLibItem; var T: TJclPeImportKind);
begin T := Self.ImportKind; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportLibItemImportDirectoryIndex_R(Self: TJclPeImportLibItem; var T: Integer);
begin T := Self.ImportDirectoryIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportLibItemImportDescriptor_R(Self: TJclPeImportLibItem; var T: Pointer);
begin T := Self.ImportDescriptor; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportLibItemFileName_R(Self: TJclPeImportLibItem; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportLibItemCount_R(Self: TJclPeImportLibItem; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportFuncItemResolveCheck_R(Self: TJclPeImportFuncItem; var T: TJclPeResolveCheck);
begin T := Self.ResolveCheck; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportFuncItemName_R(Self: TJclPeImportFuncItem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportFuncItemIsByOrdinal_R(Self: TJclPeImportFuncItem; var T: Boolean);
begin T := Self.IsByOrdinal; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportFuncItemIndirectImportName_R(Self: TJclPeImportFuncItem; var T: Boolean);
begin T := Self.IndirectImportName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportFuncItemImportLib_R(Self: TJclPeImportFuncItem; var T: TJclPeImportLibItem);
begin T := Self.ImportLib; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportFuncItemHint_R(Self: TJclPeImportFuncItem; var T: Word);
begin T := Self.Hint; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImportFuncItemOrdinal_R(Self: TJclPeImportFuncItem; var T: Word);
begin T := Self.Ordinal; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorImagesCacheImages_R(Self: TJclPeBorImagesCache; var T: TJclPeBorImage; const t1: TFileName);
begin T := Self.Images[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImagesCacheCount_R(Self: TJclPeImagesCache; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImagesCacheImages_R(Self: TJclPeImagesCache; var T: TJclPeImage; const t1: TFileName);
begin T := Self.Images[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeImageBaseListImage_R(Self: TJclPeImageBaseList; var T: TJclPeImage);
begin T := Self.Image; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeMapImgHooks(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeMapImgHooks) do
  begin
    RegisterMethod(@TJclPeMapImgHooks.HookImport, 'HookImport');
    RegisterMethod(@TJclPeMapImgHooks.IsWin9xDebugThunk, 'IsWin9xDebugThunk');
    RegisterMethod(@TJclPeMapImgHooks.ReplaceImport, 'ReplaceImport');
    RegisterMethod(@TJclPeMapImgHooks.SystemBase, 'SystemBase');
    RegisterMethod(@TJclPeMapImgHooks.UnhookAll, 'UnhookAll');
    RegisterMethod(@TJclPeMapImgHooks.UnhookByNewAddress, 'UnhookByNewAddress');
    RegisterPropertyHelper(@TJclPeMapImgHooksItems_R,nil,'Items');
    RegisterPropertyHelper(@TJclPeMapImgHooksItemFromOriginalAddress_R,nil,'ItemFromOriginalAddress');
    RegisterPropertyHelper(@TJclPeMapImgHooksItemFromNewAddress_R,nil,'ItemFromNewAddress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeMapImgHookItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeMapImgHookItem) do
  begin
    RegisterMethod(@TJclPeMapImgHookItem.Unhook, 'Unhook');
    RegisterPropertyHelper(@TJclPeMapImgHookItemBaseAddress_R,nil,'BaseAddress');
    RegisterPropertyHelper(@TJclPeMapImgHookItemFunctionName_R,nil,'FunctionName');
    RegisterPropertyHelper(@TJclPeMapImgHookItemModuleName_R,nil,'ModuleName');
    RegisterPropertyHelper(@TJclPeMapImgHookItemNewAddress_R,nil,'NewAddress');
    RegisterPropertyHelper(@TJclPeMapImgHookItemOriginalAddress_R,nil,'OriginalAddress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeSectionStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeSectionStream) do
  begin
    RegisterConstructor(@TJclPeSectionStream.Create, 'Create');
    RegisterPropertyHelper(@TJclPeSectionStreamInstance_R,nil,'Instance');
    RegisterPropertyHelper(@TJclPeSectionStreamSectionHeader_R,nil,'SectionHeader');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeNameSearch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeNameSearch) do
  begin
    RegisterConstructor(@TJclPeNameSearch.Create, 'Create');
    RegisterMethod(@TJclPeNameSearch.Start, 'Start');
    RegisterPropertyHelper(@TJclPeNameSearchOnFound_R,@TJclPeNameSearchOnFound_W,'OnFound');
    RegisterPropertyHelper(@TJclPeNameSearchOnProcessFile_R,@TJclPeNameSearchOnProcessFile_W,'OnProcessFile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeBorImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeBorImage) do begin
   RegisterConstructor(@TJclPeBorImage.Create, 'Create');
    RegisterMethod(@TJclPeBorImage.DependedPackages, 'DependedPackages');
    RegisterMethod(@TJclPeBorImage.Destroy, 'Free');
    RegisterMethod(@TJclPeBorImage.FreeLibHandle, 'FreeLibHandle');
    RegisterPropertyHelper(@TJclPeBorImageForms_R,nil,'Forms');
    RegisterPropertyHelper(@TJclPeBorImageFormCount_R,nil,'FormCount');
    RegisterPropertyHelper(@TJclPeBorImageFormFromName_R,nil,'FormFromName');
    RegisterPropertyHelper(@TJclPeBorImageIsBorlandImage_R,nil,'IsBorlandImage');
    RegisterPropertyHelper(@TJclPeBorImageIsPackage_R,nil,'IsPackage');
    RegisterPropertyHelper(@TJclPeBorImageLibHandle_R,nil,'LibHandle');
    RegisterPropertyHelper(@TJclPeBorImagePackageCompilerVersion_R,nil,'PackageCompilerVersion');
    RegisterPropertyHelper(@TJclPeBorImagePackageInfo_R,nil,'PackageInfo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeBorForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeBorForm) do begin
    RegisterMethod(@TJclPeBorFormConvertFormToText_P, 'ConvertFormToText');
    RegisterMethod(@TJclPeBorFormConvertFormToText1_P, 'ConvertFormToText1');
    RegisterPropertyHelper(@TJclPeBorFormFormClassName_R,nil,'FormClassName');
    RegisterPropertyHelper(@TJclPeBorFormFormFlags_R,nil,'FormFlags');
    RegisterPropertyHelper(@TJclPeBorFormFormObjectName_R,nil,'FormObjectName');
    RegisterPropertyHelper(@TJclPeBorFormFormPosition_R,nil,'FormPosition');
    RegisterPropertyHelper(@TJclPeBorFormDisplayName_R,nil,'DisplayName');
    RegisterPropertyHelper(@TJclPeBorFormResItem_R,nil,'ResItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPePackageInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPePackageInfo) do
  begin
    RegisterConstructor(@TJclPePackageInfo.Create, 'Create');
     RegisterMethod(@TJclPePackageInfo.Destroy, 'Free');
    RegisterMethod(@TJclPePackageInfo.PackageModuleTypeToString, 'PackageModuleTypeToString');
    RegisterMethod(@TJclPePackageInfo.PackageOptionsToString, 'PackageOptionsToString');
    RegisterMethod(@TJclPePackageInfo.ProducerToString, 'ProducerToString');
    RegisterMethod(@TJclPePackageInfo.UnitInfoFlagsToString, 'UnitInfoFlagsToString');
    RegisterPropertyHelper(@TJclPePackageInfoAvailable_R,nil,'Available');
    RegisterPropertyHelper(@TJclPePackageInfoContains_R,nil,'Contains');
    RegisterPropertyHelper(@TJclPePackageInfoContainsCount_R,nil,'ContainsCount');
    RegisterPropertyHelper(@TJclPePackageInfoContainsNames_R,nil,'ContainsNames');
    RegisterPropertyHelper(@TJclPePackageInfoContainsFlags_R,nil,'ContainsFlags');
    RegisterPropertyHelper(@TJclPePackageInfoDescription_R,nil,'Description');
    RegisterPropertyHelper(@TJclPePackageInfoDcpName_R,nil,'DcpName');
    RegisterPropertyHelper(@TJclPePackageInfoEnsureExtension_R,@TJclPePackageInfoEnsureExtension_W,'EnsureExtension');
    RegisterPropertyHelper(@TJclPePackageInfoFlags_R,nil,'Flags');
    RegisterPropertyHelper(@TJclPePackageInfoRequires_R,nil,'Requires');
    RegisterPropertyHelper(@TJclPePackageInfoRequiresCount_R,nil,'RequiresCount');
    RegisterPropertyHelper(@TJclPePackageInfoRequiresNames_R,nil,'RequiresNames');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeImage) do begin
    RegisterConstructor(@TJclPeImage.Create, 'Create');
     RegisterMethod(@TJclPeImage.Destroy, 'Free');
     RegisterMethod(@TJclPeImage.AttachLoadedModule, 'AttachLoadedModule');
    RegisterMethod(@TJclPeImage.CalculateCheckSum, 'CalculateCheckSum');
    RegisterMethod(@TJclPeImage.DirectoryEntryToData, 'DirectoryEntryToData');
    RegisterMethod(@TJclPeImage.GetSectionHeader, 'GetSectionHeader');
    RegisterMethod(@TJclPeImage.GetSectionName, 'GetSectionName');
    RegisterMethod(@TJclPeImage.IsCLR, 'IsCLR');
    RegisterMethod(@TJclPeImage.IsSystemImage, 'IsSystemImage');
    RegisterMethod(@TJclPeImage.RawToVa, 'RawToVa');
    RegisterMethod(@TJclPeImage.RvaToSection, 'RvaToSection');
    RegisterMethod(@TJclPeImage.RvaToVa, 'RvaToVa');
    RegisterMethod(@TJclPeImage.RvaToVaEx, 'RvaToVaEx');
    RegisterMethod(@TJclPeImage.StatusOK, 'StatusOK');
    RegisterMethod(@TJclPeImage.TryGetNamesForOrdinalImports, 'TryGetNamesForOrdinalImports');
    RegisterMethod(@TJclPeImage.VerifyCheckSum, 'VerifyCheckSum');
    RegisterMethod(@TJclPeImage.DebugTypeNames, 'DebugTypeNames');
    RegisterMethod(@TJclPeImage.DirectoryNames, 'DirectoryNames');
    RegisterMethod(@TJclPeImage.ExpandBySearchPath, 'ExpandBySearchPath');
    RegisterMethod(@TJclPeImage.HeaderNames, 'HeaderNames');
    RegisterMethod(@TJclPeImage.LoadConfigNames, 'LoadConfigNames');
    RegisterMethod(@TJclPeImage.ShortSectionInfo, 'ShortSectionInfo');
    RegisterMethod(@TJclPeImage.StampToDateTime, 'StampToDateTime');
    RegisterPropertyHelper(@TJclPeImageAttachedImage_R,nil,'AttachedImage');
    RegisterPropertyHelper(@TJclPeImageCertificateList_R,nil,'CertificateList');
    RegisterPropertyHelper(@TJclPeImageCLRHeader_R,nil,'CLRHeader');
    RegisterPropertyHelper(@TJclPeImageDebugList_R,nil,'DebugList');
    RegisterPropertyHelper(@TJclPeImageDescription_R,nil,'Description');
    RegisterPropertyHelper(@TJclPeImageDirectories_R,nil,'Directories');
    RegisterPropertyHelper(@TJclPeImageDirectoryExists_R,nil,'DirectoryExists');
    RegisterPropertyHelper(@TJclPeImageExportList_R,nil,'ExportList');
    RegisterPropertyHelper(@TJclPeImageFileName_R,@TJclPeImageFileName_W,'FileName');
    RegisterPropertyHelper(@TJclPeImageFileProperties_R,nil,'FileProperties');
    RegisterPropertyHelper(@TJclPeImageHeaderValues_R,nil,'HeaderValues');
    RegisterPropertyHelper(@TJclPeImageImageSectionCount_R,nil,'ImageSectionCount');
    RegisterPropertyHelper(@TJclPeImageImageSectionHeaders_R,nil,'ImageSectionHeaders');
    RegisterPropertyHelper(@TJclPeImageImageSectionNames_R,nil,'ImageSectionNames');
    RegisterPropertyHelper(@TJclPeImageImageSectionNameFromRva_R,nil,'ImageSectionNameFromRva');
    RegisterPropertyHelper(@TJclPeImageImportList_R,nil,'ImportList');
    RegisterPropertyHelper(@TJclPeImageLoadConfigValues_R,nil,'LoadConfigValues');
    RegisterPropertyHelper(@TJclPeImageLoadedImage_R,nil,'LoadedImage');
    RegisterPropertyHelper(@TJclPeImageMappedAddress_R,nil,'MappedAddress');
    RegisterPropertyHelper(@TJclPeImageOptionalHeader_R,nil,'OptionalHeader');
    RegisterPropertyHelper(@TJclPeImageReadOnlyAccess_R,@TJclPeImageReadOnlyAccess_W,'ReadOnlyAccess');
    RegisterPropertyHelper(@TJclPeImageRelocationList_R,nil,'RelocationList');
    RegisterPropertyHelper(@TJclPeImageResourceList_R,nil,'ResourceList');
    RegisterPropertyHelper(@TJclPeImageStatus_R,nil,'Status');
    RegisterPropertyHelper(@TJclPeImageUnusedHeaderBytes_R,nil,'UnusedHeaderBytes');
    RegisterPropertyHelper(@TJclPeImageVersionInfo_R,nil,'VersionInfo');
    RegisterPropertyHelper(@TJclPeImageVersionInfoAvailable_R,nil,'VersionInfoAvailable');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeCLRHeader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeCLRHeader) do
  begin
    RegisterConstructor(@TJclPeCLRHeader.Create, 'Create');
    RegisterPropertyHelper(@TJclPeCLRHeaderHasMetadata_R,nil,'HasMetadata');
    RegisterPropertyHelper(@TJclPeCLRHeaderHeader_R,nil,'Header');
    RegisterPropertyHelper(@TJclPeCLRHeaderVersionString_R,nil,'VersionString');
    RegisterPropertyHelper(@TJclPeCLRHeaderImage_R,nil,'Image');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeCertificateList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeCertificateList) do
  begin
    RegisterConstructor(@TJclPeCertificateList.Create, 'Create');
    RegisterPropertyHelper(@TJclPeCertificateListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeCertificate(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeCertificate) do
  begin
    RegisterPropertyHelper(@TJclPeCertificateData_R,nil,'Data');
    RegisterPropertyHelper(@TJclPeCertificateHeader_R,nil,'Header');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeDebugList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeDebugList) do
  begin
    RegisterConstructor(@TJclPeDebugList.Create, 'Create');
    RegisterPropertyHelper(@TJclPeDebugListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeRelocList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeRelocList) do
  begin
    RegisterConstructor(@TJclPeRelocList.Create, 'Create');
    RegisterPropertyHelper(@TJclPeRelocListAllItems_R,nil,'AllItems');
    RegisterPropertyHelper(@TJclPeRelocListAllItemCount_R,nil,'AllItemCount');
    RegisterPropertyHelper(@TJclPeRelocListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeRelocEntry(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeRelocEntry) do
  begin
    RegisterPropertyHelper(@TJclPeRelocEntryCount_R,nil,'Count');
    RegisterPropertyHelper(@TJclPeRelocEntryRelocations_R,nil,'Relocations');
    RegisterPropertyHelper(@TJclPeRelocEntrySize_R,nil,'Size');
    RegisterPropertyHelper(@TJclPeRelocEntryVirtualAddress_R,nil,'VirtualAddress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeRootResourceList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeRootResourceList) do
  begin
    RegisterMethod(@TJclPeRootResourceListFindResource_P, 'FindResource');
    RegisterMethod(@TJclPeRootResourceListFindResource1_P, 'FindResource1');
    RegisterMethod(@TJclPeRootResourceList.ListResourceNames, 'ListResourceNames');
    RegisterPropertyHelper(@TJclPeRootResourceListManifestContent_R,nil,'ManifestContent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeResourceList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeResourceList) do
  begin
    RegisterConstructor(@TJclPeResourceList.Create, 'Create');
    RegisterMethod(@TJclPeResourceList.FindName, 'FindName');
    RegisterPropertyHelper(@TJclPeResourceListDirectory_R,nil,'Directory');
    RegisterPropertyHelper(@TJclPeResourceListItems_R,nil,'Items');
    RegisterPropertyHelper(@TJclPeResourceListParentItem_R,nil,'ParentItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeResourceItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeResourceItem) do
  begin
    RegisterConstructor(@TJclPeResourceItem.Create, 'Create');
    RegisterMethod(@TJclPeResourceItem.Destroy, 'Free');
    RegisterMethod(@TJclPeResourceItem.CompareName, 'CompareName');
    RegisterPropertyHelper(@TJclPeResourceItemDataEntry_R,nil,'DataEntry');
    RegisterPropertyHelper(@TJclPeResourceItemEntry_R,nil,'Entry');
    RegisterPropertyHelper(@TJclPeResourceItemImage_R,nil,'Image');
    RegisterPropertyHelper(@TJclPeResourceItemIsDirectory_R,nil,'IsDirectory');
    RegisterPropertyHelper(@TJclPeResourceItemIsName_R,nil,'IsName');
    RegisterPropertyHelper(@TJclPeResourceItemLangID_R,nil,'LangID');
    RegisterPropertyHelper(@TJclPeResourceItemList_R,nil,'List');
    RegisterPropertyHelper(@TJclPeResourceItemLevel_R,nil,'Level');
    RegisterPropertyHelper(@TJclPeResourceItemName_R,nil,'Name');
    RegisterPropertyHelper(@TJclPeResourceItemParameterName_R,nil,'ParameterName');
    RegisterPropertyHelper(@TJclPeResourceItemParentItem_R,nil,'ParentItem');
    RegisterPropertyHelper(@TJclPeResourceItemRawEntryData_R,nil,'RawEntryData');
    RegisterPropertyHelper(@TJclPeResourceItemRawEntryDataSize_R,nil,'RawEntryDataSize');
    RegisterPropertyHelper(@TJclPeResourceItemResourceType_R,nil,'ResourceType');
    RegisterPropertyHelper(@TJclPeResourceItemResourceTypeStr_R,nil,'ResourceTypeStr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeResourceRawStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeResourceRawStream) do
  begin
    RegisterConstructor(@TJclPeResourceRawStream.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeExportFuncList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeExportFuncList) do
  begin
    RegisterConstructor(@TJclPeExportFuncList.Create, 'Create');
    RegisterMethod(@TJclPeExportFuncList.Destroy, 'Free');
    RegisterMethod(@TJclPeExportFuncList.CheckForwards, 'CheckForwards');
    RegisterMethod(@TJclPeExportFuncList.ItemName, 'ItemName');
    RegisterMethod(@TJclPeExportFuncList.OrdinalValid, 'OrdinalValid');
    RegisterMethod(@TJclPeExportFuncList.PrepareForFastNameSearch, 'PrepareForFastNameSearch');
    RegisterMethod(@TJclPeExportFuncList.SmartFindName, 'SmartFindName');
    RegisterMethod(@TJclPeExportFuncList.SortList, 'SortList');
    RegisterPropertyHelper(@TJclPeExportFuncListAnyForwards_R,nil,'AnyForwards');
    RegisterPropertyHelper(@TJclPeExportFuncListBase_R,nil,'Base');
    RegisterPropertyHelper(@TJclPeExportFuncListExportDir_R,nil,'ExportDir');
    RegisterPropertyHelper(@TJclPeExportFuncListForwardedLibsList_R,nil,'ForwardedLibsList');
    RegisterPropertyHelper(@TJclPeExportFuncListFunctionCount_R,nil,'FunctionCount');
    RegisterPropertyHelper(@TJclPeExportFuncListItems_R,nil,'Items');
    RegisterPropertyHelper(@TJclPeExportFuncListItemFromAddress_R,nil,'ItemFromAddress');
    RegisterPropertyHelper(@TJclPeExportFuncListItemFromName_R,nil,'ItemFromName');
    RegisterPropertyHelper(@TJclPeExportFuncListItemFromOrdinal_R,nil,'ItemFromOrdinal');
    RegisterPropertyHelper(@TJclPeExportFuncListName_R,nil,'Name');
    RegisterPropertyHelper(@TJclPeExportFuncListTotalResolveCheck_R,nil,'TotalResolveCheck');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeExportFuncItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeExportFuncItem) do
  begin
    RegisterPropertyHelper(@TJclPeExportFuncItemAddress_R,nil,'Address');
    RegisterPropertyHelper(@TJclPeExportFuncItemAddressOrForwardStr_R,nil,'AddressOrForwardStr');
    RegisterPropertyHelper(@TJclPeExportFuncItemIsExportedVariable_R,nil,'IsExportedVariable');
    RegisterPropertyHelper(@TJclPeExportFuncItemIsForwarded_R,nil,'IsForwarded');
    RegisterPropertyHelper(@TJclPeExportFuncItemForwardedName_R,nil,'ForwardedName');
    RegisterPropertyHelper(@TJclPeExportFuncItemForwardedLibName_R,nil,'ForwardedLibName');
    RegisterPropertyHelper(@TJclPeExportFuncItemForwardedFuncOrdinal_R,nil,'ForwardedFuncOrdinal');
    RegisterPropertyHelper(@TJclPeExportFuncItemForwardedFuncName_R,nil,'ForwardedFuncName');
    RegisterPropertyHelper(@TJclPeExportFuncItemHint_R,nil,'Hint');
    RegisterPropertyHelper(@TJclPeExportFuncItemMappedAddress_R,nil,'MappedAddress');
    RegisterPropertyHelper(@TJclPeExportFuncItemName_R,nil,'Name');
    RegisterPropertyHelper(@TJclPeExportFuncItemOrdinal_R,nil,'Ordinal');
    RegisterPropertyHelper(@TJclPeExportFuncItemResolveCheck_R,nil,'ResolveCheck');
    RegisterPropertyHelper(@TJclPeExportFuncItemSectionName_R,nil,'SectionName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeImportList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeImportList) do
  begin
    RegisterConstructor(@TJclPeImportList.Create, 'Create');
    RegisterMethod(@TJclPeImportList.Destroy, 'Free');
    RegisterMethod(@TJclPeImportList.CheckImports, 'CheckImports');
    RegisterMethod(@TJclPeImportList.MakeBorlandImportTableForMappedImage, 'MakeBorlandImportTableForMappedImage');
    RegisterMethod(@TJclPeImportList.SmartFindName, 'SmartFindName');
    RegisterMethod(@TJclPeImportList.SortAllItemsList, 'SortAllItemsList');
    RegisterMethod(@TJclPeImportList.SortList, 'SortList');
    RegisterMethod(@TJclPeImportList.TryGetNamesForOrdinalImports, 'TryGetNamesForOrdinalImports');
    RegisterPropertyHelper(@TJclPeImportListAllItems_R,nil,'AllItems');
    RegisterPropertyHelper(@TJclPeImportListAllItemCount_R,nil,'AllItemCount');
    RegisterPropertyHelper(@TJclPeImportListFilterModuleName_R,@TJclPeImportListFilterModuleName_W,'FilterModuleName');
    RegisterPropertyHelper(@TJclPeImportListItems_R,nil,'Items');
    RegisterPropertyHelper(@TJclPeImportListLinkerProducer_R,nil,'LinkerProducer');
    RegisterPropertyHelper(@TJclPeImportListUniqueLibItemCount_R,nil,'UniqueLibItemCount');
    RegisterPropertyHelper(@TJclPeImportListUniqueLibItemFromName_R,nil,'UniqueLibItemFromName');
    RegisterPropertyHelper(@TJclPeImportListUniqueLibItems_R,nil,'UniqueLibItems');
    RegisterPropertyHelper(@TJclPeImportListUniqueLibNames_R,nil,'UniqueLibNames');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeImportLibItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeImportLibItem) do
  begin
    RegisterConstructor(@TJclPeImportLibItem.Create, 'Create');
    RegisterMethod(@TJclPeImportLibItem.SortList, 'SortList');
    RegisterPropertyHelper(@TJclPeImportLibItemCount_R,nil,'Count');
    RegisterPropertyHelper(@TJclPeImportLibItemFileName_R,nil,'FileName');
    RegisterPropertyHelper(@TJclPeImportLibItemImportDescriptor_R,nil,'ImportDescriptor');
    RegisterPropertyHelper(@TJclPeImportLibItemImportDirectoryIndex_R,nil,'ImportDirectoryIndex');
    RegisterPropertyHelper(@TJclPeImportLibItemImportKind_R,nil,'ImportKind');
    RegisterPropertyHelper(@TJclPeImportLibItemItems_R,nil,'Items');
    RegisterPropertyHelper(@TJclPeImportLibItemName_R,nil,'Name');
    RegisterPropertyHelper(@TJclPeImportLibItemOriginalName_R,nil,'OriginalName');
    RegisterPropertyHelper(@TJclPeImportLibItemThunkData_R,nil,'ThunkData');
    RegisterPropertyHelper(@TJclPeImportLibItemTotalResolveCheck_R,nil,'TotalResolveCheck');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeImportFuncItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeImportFuncItem) do begin
  RegisterMethod(@TJclPeImportFuncItem.Destroy, 'Free');
    RegisterPropertyHelper(@TJclPeImportFuncItemOrdinal_R,nil,'Ordinal');
    RegisterPropertyHelper(@TJclPeImportFuncItemHint_R,nil,'Hint');
    RegisterPropertyHelper(@TJclPeImportFuncItemImportLib_R,nil,'ImportLib');
    RegisterPropertyHelper(@TJclPeImportFuncItemIndirectImportName_R,nil,'IndirectImportName');
    RegisterPropertyHelper(@TJclPeImportFuncItemIsByOrdinal_R,nil,'IsByOrdinal');
    RegisterPropertyHelper(@TJclPeImportFuncItemName_R,nil,'Name');
    RegisterPropertyHelper(@TJclPeImportFuncItemResolveCheck_R,nil,'ResolveCheck');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeBorImagesCache(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeBorImagesCache) do
  begin
    RegisterPropertyHelper(@TJclPeBorImagesCacheImages_R,nil,'Images');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeImagesCache(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeImagesCache) do
  begin
    RegisterConstructor(@TJclPeImagesCache.Create, 'Create');
    RegisterMethod(@TJclPeImagesCache.Destroy, 'Free');
    RegisterMethod(@TJclPeImagesCache.Clear, 'Clear');
    RegisterPropertyHelper(@TJclPeImagesCacheImages_R,nil,'Images');
    RegisterPropertyHelper(@TJclPeImagesCacheCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeImageBaseList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeImageBaseList) do
  begin
    RegisterConstructor(@TJclPeImageBaseList.Create, 'Create');
    RegisterPropertyHelper(@TJclPeImageBaseListImage_R,nil,'Image');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclPeImage_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PeStripFunctionAW, 'PeStripFunctionAW', cdRegister);
 S.RegisterDelphiFunction(@PeSmartFunctionNameSame, 'PeSmartFunctionNameSame', cdRegister);
 S.RegisterDelphiFunction(@IsValidPeFile, 'IsValidPeFile', cdRegister);
 S.RegisterDelphiFunction(@PeGetNtHeaders, 'PeGetNtHeaders', cdRegister);
 S.RegisterDelphiFunction(@PeCreateNameHintTable, 'PeCreateNameHintTable', cdRegister);
 S.RegisterDelphiFunction(@PeRebaseImage, 'PeRebaseImage', cdRegister);
 S.RegisterDelphiFunction(@PeVerifyCheckSum, 'PeVerifyCheckSum', cdRegister);
 S.RegisterDelphiFunction(@PeClearCheckSum, 'PeClearCheckSum', cdRegister);
 S.RegisterDelphiFunction(@PeUpdateCheckSum, 'PeUpdateCheckSum', cdRegister);
 S.RegisterDelphiFunction(@PeDoesExportFunction, 'PeDoesExportFunction', cdRegister);
 S.RegisterDelphiFunction(@PeIsExportFunctionForwardedEx, 'PeIsExportFunctionForwardedEx', cdRegister);
 S.RegisterDelphiFunction(@PeIsExportFunctionForwarded, 'PeIsExportFunctionForwarded', cdRegister);
 S.RegisterDelphiFunction(@PeDoesImportFunction, 'PeDoesImportFunction', cdRegister);
 S.RegisterDelphiFunction(@PeDoesImportLibrary, 'PeDoesImportLibrary', cdRegister);
 S.RegisterDelphiFunction(@PeImportedLibraries, 'PeImportedLibraries', cdRegister);
 S.RegisterDelphiFunction(@PeImportedFunctions, 'PeImportedFunctions', cdRegister);
 S.RegisterDelphiFunction(@PeExportedFunctions, 'PeExportedFunctions', cdRegister);
 S.RegisterDelphiFunction(@PeExportedNames, 'PeExportedNames', cdRegister);
 S.RegisterDelphiFunction(@PeExportedVariables, 'PeExportedVariables', cdRegister);
 S.RegisterDelphiFunction(@PeResourceKindNames, 'PeResourceKindNames', cdRegister);
 S.RegisterDelphiFunction(@PeBorFormNames, 'PeBorFormNames', cdRegister);
 S.RegisterDelphiFunction(@PeBorDependedPackages, 'PeBorDependedPackages', cdRegister);
 S.RegisterDelphiFunction(@PeFindMissingImports, 'PeFindMissingImports', cdRegister);
 S.RegisterDelphiFunction(@PeFindMissingImports1_P, 'PeFindMissingImports1', cdRegister);
 S.RegisterDelphiFunction(@PeCreateRequiredImportList, 'PeCreateRequiredImportList', cdRegister);
 S.RegisterDelphiFunction(@PeMapImgNtHeaders, 'PeMapImgNtHeaders', cdRegister);
 S.RegisterDelphiFunction(@PeMapImgLibraryName, 'PeMapImgLibraryName', cdRegister);
 S.RegisterDelphiFunction(@PeMapImgSections, 'PeMapImgSections', cdRegister);
 S.RegisterDelphiFunction(@PeMapImgFindSection, 'PeMapImgFindSection', cdRegister);
 S.RegisterDelphiFunction(@PeMapImgExportedVariables, 'PeMapImgExportedVariables', cdRegister);
 S.RegisterDelphiFunction(@PeMapImgResolvePackageThunk, 'PeMapImgResolvePackageThunk', cdRegister);
 S.RegisterDelphiFunction(@PeMapFindResource, 'PeMapFindResource', cdRegister);
 S.RegisterDelphiFunction(@PeDbgImgNtHeaders, 'PeDbgImgNtHeaders', cdRegister);
 S.RegisterDelphiFunction(@PeDbgImgLibraryName, 'PeDbgImgLibraryName', cdRegister);
 S.RegisterDelphiFunction(@PeBorUnmangleName, 'PeBorUnmangleName', cdRegister);
 S.RegisterDelphiFunction(@PeBorUnmangleName1_P, 'PeBorUnmangleName1', cdRegister);
 S.RegisterDelphiFunction(@PeBorUnmangleName2_P, 'PeBorUnmangleName2', cdRegister);
 S.RegisterDelphiFunction(@PeBorUnmangleName3_P, 'PeBorUnmangleName3', cdRegister);
 S.RegisterDelphiFunction(@PeIsNameMangled, 'PeIsNameMangled', cdRegister);
 S.RegisterDelphiFunction(@PeUnmangleName, 'PeUnmangleName', cdRegister);
 S.RegisterDelphiFunction(@list_modules, 'list_modules', cdRegister);
 S.RegisterDelphiFunction(@list_modules, 'list_units', cdRegister);
 S.RegisterDelphiFunction(@GetResourceHeader, 'GetResourceHeader', cdRegister);
 S.RegisterDelphiFunction(@GetResourceFormFile, 'GetResourceFormFile', cdRegister);
 S.RegisterDelphiFunction(@GetImageBase, 'GetImageBase', cdRegister);

end;

procedure RIRegister_JclPeImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclPeImageError) do
  with CL.Add(TJclPeImage) do
  with CL.Add(TJclPeBorImage) do
  RIRegister_TJclPeImageBaseList(CL);
  RIRegister_TJclPeImagesCache(CL);
  RIRegister_TJclPeBorImagesCache(CL);
  with CL.Add(TJclPeImportLibItem) do
  RIRegister_TJclPeImportFuncItem(CL);
  RIRegister_TJclPeImportLibItem(CL);
  RIRegister_TJclPeImportList(CL);
  with CL.Add(TJclPeExportFuncList) do
  RIRegister_TJclPeExportFuncItem(CL);
  RIRegister_TJclPeExportFuncList(CL);
  with CL.Add(TJclPeResourceList) do
  with CL.Add(TJclPeResourceItem) do
  RIRegister_TJclPeResourceRawStream(CL);
  RIRegister_TJclPeResourceItem(CL);
  RIRegister_TJclPeResourceList(CL);
  RIRegister_TJclPeRootResourceList(CL);
  RIRegister_TJclPeRelocEntry(CL);
  RIRegister_TJclPeRelocList(CL);
  RIRegister_TJclPeDebugList(CL);
  RIRegister_TJclPeCertificate(CL);
  RIRegister_TJclPeCertificateList(CL);
  RIRegister_TJclPeCLRHeader(CL);
  RIRegister_TJclPeImage(CL);
  RIRegister_TJclPePackageInfo(CL);
  RIRegister_TJclPeBorForm(CL);
  RIRegister_TJclPeBorImage(CL);
  RIRegister_TJclPeNameSearch(CL);
  RIRegister_TJclPeSectionStream(CL);
  RIRegister_TJclPeMapImgHookItem(CL);
  RIRegister_TJclPeMapImgHooks(CL);
end;



{ TPSImport_JclPeImage }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclPeImage.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclPeImage(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclPeImage.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclPeImage(ri);
  RIRegister_JclPeImage_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
