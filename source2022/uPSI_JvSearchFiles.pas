unit uPSI_JvSearchFiles;
{
   docu engine maXdoc
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
  TPSImport_JvSearchFiles = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvSearchFiles(CL: TPSPascalCompiler);
procedure SIRegister_TJvSearchParams(CL: TPSPascalCompiler);
procedure SIRegister_TJvSearchAttributes(CL: TPSPascalCompiler);
procedure SIRegister_JvSearchFiles(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvSearchFiles(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvSearchParams(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvSearchAttributes(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvSearchFiles(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,JvComponentBase
  ,JvJCLUtils
  ,JvWin32
  ,JvSearchFiles
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvSearchFiles]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSearchFiles(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvSearchFiles') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvSearchFiles') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Abort');
    RegisterMethod('Function Search : Boolean');
    RegisterProperty('FindData', 'TWin32FindData', iptr);
    RegisterProperty('Files', 'TStrings', iptr);
    RegisterProperty('Directories', 'TStrings', iptr);
    RegisterProperty('IsRootDirValid', 'Boolean', iptr);
    RegisterProperty('Searching', 'Boolean', iptr);
    RegisterProperty('TotalDirectories', 'Integer', iptr);
    RegisterProperty('TotalFileSize', 'Int64', iptr);
    RegisterProperty('TotalFiles', 'Integer', iptr);
    RegisterProperty('DirOption', 'TJvDirOption', iptrw);
    RegisterProperty('RecurseDepth', 'Integer', iptrw);
    RegisterProperty('RootDirectory', 'string', iptrw);
    RegisterProperty('Options', 'TJvSearchOptions', iptrw);
    RegisterProperty('ErrorResponse', 'TJvErrorResponse', iptrw);
    RegisterProperty('DirParams', 'TJvSearchParams', iptrw);
    RegisterProperty('FileParams', 'TJvSearchParams', iptrw);
    RegisterProperty('OnBeginScanDir', 'TJvFileSearchEvent', iptrw);
    RegisterProperty('OnFindFile', 'TJvFileSearchEvent', iptrw);
    RegisterProperty('OnFindDirectory', 'TJvFileSearchEvent', iptrw);
    RegisterProperty('OnAbort', 'TNotifyEvent', iptrw);
    RegisterProperty('OnError', 'TJvSearchFilesError', iptrw);
    RegisterProperty('OnCheck', 'TJvCheckEvent', iptrw);
    RegisterProperty('OnProgress', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSearchParams(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvSearchParams') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvSearchParams') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function Check( const AFindData : TWin32FindData) : Boolean');
    RegisterProperty('FileMask', 'string', iptrw);
    RegisterProperty('FileMaskSeperator', 'Char', iptrw);
    RegisterProperty('Attributes', 'TJvSearchAttributes', iptrw);
    RegisterProperty('SearchTypes', 'TJvSearchTypes', iptrw);
    RegisterProperty('MinSize', 'Int64', iptrw);
    RegisterProperty('MaxSize', 'Int64', iptrw);
    RegisterProperty('LastChangeAfter', 'TDateTime', iptrw);
    RegisterProperty('LastChangeBefore', 'TDateTime', iptrw);
    RegisterProperty('FileMasks', 'TStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSearchAttributes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvSearchAttributes') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvSearchAttributes') do
  begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('IncludeAttr', 'DWORD', iptrw);
    RegisterProperty('ExcludeAttr', 'DWORD', iptrw);
    RegisterProperty('ReadOnly', 'TJvAttrFlagKind', iptrw);
    RegisterProperty('Hidden', 'TJvAttrFlagKind', iptrw);
    RegisterProperty('System', 'TJvAttrFlagKind', iptrw);
    RegisterProperty('Archive', 'TJvAttrFlagKind', iptrw);
    RegisterProperty('Normal', 'TJvAttrFlagKind', iptrw);
    RegisterProperty('Temporary', 'TJvAttrFlagKind', iptrw);
    RegisterProperty('SparseFile', 'TJvAttrFlagKind', iptrw);
    RegisterProperty('ReparsePoint', 'TJvAttrFlagKind', iptrw);
    RegisterProperty('Compressed', 'TJvAttrFlagKind', iptrw);
    RegisterProperty('OffLine', 'TJvAttrFlagKind', iptrw);
    RegisterProperty('NotContentIndexed', 'TJvAttrFlagKind', iptrw);
    RegisterProperty('Encrypted', 'TJvAttrFlagKind', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvSearchFiles(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvAttrFlagKind', '( tsMustBeSet, tsDontCare, tsMustBeUnSet )');
  CL.AddTypeS('TJvDirOption', '( doExcludeSubDirs, doIncludeSubDirs, doExcludeI'
   +'nvalidDirs, doExcludeCompleteInvalidDirs )');
  CL.AddTypeS('TJvSearchOption', '( soAllowDuplicates, soCheckRootDirValid, soE'
   +'xcludeFilesInRootDir, soOwnerData, soSearchDirs, soSearchFiles, soSorted, '
   +'soStripDirs, soIncludeSystemHiddenDirs, soIncludeSystemHiddenFiles )');
  CL.AddTypeS('TJvSearchOptions', 'set of TJvSearchOption');
  CL.AddTypeS('TJvSearchType', '( stAttribute, stFileMask, stFileMaskCaseSensit'
   +'ive, stLastChangeAfter, stLastChangeBefore, stMaxSize, stMinSize )');
  CL.AddTypeS('TJvSearchTypes', 'set of TJvSearchType');
  CL.AddTypeS('TJvFileSearchEvent', 'Procedure ( Sender : TObject; const AName : string)');
  CL.AddTypeS('TJvSearchFilesError','Procedure (Sender: TObject; var Handled: Boolean)');
  CL.AddTypeS('TJvCheckEvent', 'Procedure ( Sender : TObject; var Result : Boolean)');
  CL.AddTypeS('TJvErrorResponse', '( erAbort, erIgnore, erRaise )');
  SIRegister_TJvSearchAttributes(CL);
  SIRegister_TJvSearchParams(CL);
  SIRegister_TJvSearchFiles(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnProgress_W(Self: TJvSearchFiles; const T: TNotifyEvent);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnProgress_R(Self: TJvSearchFiles; var T: TNotifyEvent);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnCheck_W(Self: TJvSearchFiles; const T: TJvCheckEvent);
begin Self.OnCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnCheck_R(Self: TJvSearchFiles; var T: TJvCheckEvent);
begin T := Self.OnCheck; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnError_W(Self: TJvSearchFiles; const T: TJvSearchFilesError);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnError_R(Self: TJvSearchFiles; var T: TJvSearchFilesError);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnAbort_W(Self: TJvSearchFiles; const T: TNotifyEvent);
begin Self.OnAbort := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnAbort_R(Self: TJvSearchFiles; var T: TNotifyEvent);
begin T := Self.OnAbort; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnFindDirectory_W(Self: TJvSearchFiles; const T: TJvFileSearchEvent);
begin Self.OnFindDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnFindDirectory_R(Self: TJvSearchFiles; var T: TJvFileSearchEvent);
begin T := Self.OnFindDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnFindFile_W(Self: TJvSearchFiles; const T: TJvFileSearchEvent);
begin Self.OnFindFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnFindFile_R(Self: TJvSearchFiles; var T: TJvFileSearchEvent);
begin T := Self.OnFindFile; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnBeginScanDir_W(Self: TJvSearchFiles; const T: TJvFileSearchEvent);
begin Self.OnBeginScanDir := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOnBeginScanDir_R(Self: TJvSearchFiles; var T: TJvFileSearchEvent);
begin T := Self.OnBeginScanDir; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesFileParams_W(Self: TJvSearchFiles; const T: TJvSearchParams);
begin Self.FileParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesFileParams_R(Self: TJvSearchFiles; var T: TJvSearchParams);
begin T := Self.FileParams; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesDirParams_W(Self: TJvSearchFiles; const T: TJvSearchParams);
begin Self.DirParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesDirParams_R(Self: TJvSearchFiles; var T: TJvSearchParams);
begin T := Self.DirParams; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesErrorResponse_W(Self: TJvSearchFiles; const T: TJvErrorResponse);
begin Self.ErrorResponse := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesErrorResponse_R(Self: TJvSearchFiles; var T: TJvErrorResponse);
begin T := Self.ErrorResponse; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOptions_W(Self: TJvSearchFiles; const T: TJvSearchOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesOptions_R(Self: TJvSearchFiles; var T: TJvSearchOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesRootDirectory_W(Self: TJvSearchFiles; const T: string);
begin Self.RootDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesRootDirectory_R(Self: TJvSearchFiles; var T: string);
begin T := Self.RootDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesRecurseDepth_W(Self: TJvSearchFiles; const T: Integer);
begin Self.RecurseDepth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesRecurseDepth_R(Self: TJvSearchFiles; var T: Integer);
begin T := Self.RecurseDepth; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesDirOption_W(Self: TJvSearchFiles; const T: TJvDirOption);
begin Self.DirOption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesDirOption_R(Self: TJvSearchFiles; var T: TJvDirOption);
begin T := Self.DirOption; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesTotalFiles_R(Self: TJvSearchFiles; var T: Integer);
begin T := Self.TotalFiles; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesTotalFileSize_R(Self: TJvSearchFiles; var T: Int64);
begin T := Self.TotalFileSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesTotalDirectories_R(Self: TJvSearchFiles; var T: Integer);
begin T := Self.TotalDirectories; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesSearching_R(Self: TJvSearchFiles; var T: Boolean);
begin T := Self.Searching; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesIsRootDirValid_R(Self: TJvSearchFiles; var T: Boolean);
begin T := Self.IsRootDirValid; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesDirectories_R(Self: TJvSearchFiles; var T: TStrings);
begin T := Self.Directories; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesFiles_R(Self: TJvSearchFiles; var T: TStrings);
begin T := Self.Files; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchFilesFindData_R(Self: TJvSearchFiles; var T: TWin32FindData);
begin T := Self.FindData; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsFileMasks_W(Self: TJvSearchParams; const T: TStrings);
begin Self.FileMasks := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsFileMasks_R(Self: TJvSearchParams; var T: TStrings);
begin T := Self.FileMasks; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsLastChangeBefore_W(Self: TJvSearchParams; const T: TDateTime);
begin Self.LastChangeBefore := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsLastChangeBefore_R(Self: TJvSearchParams; var T: TDateTime);
begin T := Self.LastChangeBefore; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsLastChangeAfter_W(Self: TJvSearchParams; const T: TDateTime);
begin Self.LastChangeAfter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsLastChangeAfter_R(Self: TJvSearchParams; var T: TDateTime);
begin T := Self.LastChangeAfter; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsMaxSize_W(Self: TJvSearchParams; const T: Int64);
begin Self.MaxSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsMaxSize_R(Self: TJvSearchParams; var T: Int64);
begin T := Self.MaxSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsMinSize_W(Self: TJvSearchParams; const T: Int64);
begin Self.MinSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsMinSize_R(Self: TJvSearchParams; var T: Int64);
begin T := Self.MinSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsSearchTypes_W(Self: TJvSearchParams; const T: TJvSearchTypes);
begin Self.SearchTypes := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsSearchTypes_R(Self: TJvSearchParams; var T: TJvSearchTypes);
begin T := Self.SearchTypes; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsAttributes_W(Self: TJvSearchParams; const T: TJvSearchAttributes);
begin Self.Attributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsAttributes_R(Self: TJvSearchParams; var T: TJvSearchAttributes);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsFileMaskSeperator_W(Self: TJvSearchParams; const T: Char);
begin Self.FileMaskSeperator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsFileMaskSeperator_R(Self: TJvSearchParams; var T: Char);
begin T := Self.FileMaskSeperator; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsFileMask_W(Self: TJvSearchParams; const T: string);
begin Self.FileMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchParamsFileMask_R(Self: TJvSearchParams; var T: string);
begin T := Self.FileMask; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesEncrypted_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.Encrypted := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesEncrypted_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.Encrypted; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesNotContentIndexed_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.NotContentIndexed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesNotContentIndexed_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.NotContentIndexed; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesOffLine_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.OffLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesOffLine_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.OffLine; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesCompressed_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.Compressed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesCompressed_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.Compressed; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesReparsePoint_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.ReparsePoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesReparsePoint_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.ReparsePoint; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesSparseFile_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.SparseFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesSparseFile_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.SparseFile; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesTemporary_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.Temporary := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesTemporary_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.Temporary; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesNormal_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.Normal := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesNormal_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.Normal; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesArchive_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.Archive := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesArchive_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.Archive; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesSystem_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.System := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesSystem_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.System; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesHidden_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.Hidden := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesHidden_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.Hidden; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesReadOnly_W(Self: TJvSearchAttributes; const T: TJvAttrFlagKind);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesReadOnly_R(Self: TJvSearchAttributes; var T: TJvAttrFlagKind);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesExcludeAttr_W(Self: TJvSearchAttributes; const T: DWORD);
begin Self.ExcludeAttr := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesExcludeAttr_R(Self: TJvSearchAttributes; var T: DWORD);
begin T := Self.ExcludeAttr; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesIncludeAttr_W(Self: TJvSearchAttributes; const T: DWORD);
begin Self.IncludeAttr := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSearchAttributesIncludeAttr_R(Self: TJvSearchAttributes; var T: DWORD);
begin T := Self.IncludeAttr; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSearchFiles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSearchFiles) do begin
    RegisterConstructor(@TJvSearchFiles.Create, 'Create');
    RegisterMethod(@TJvSearchFiles.Destroy, 'Free');
     RegisterMethod(@TJvSearchFiles.Abort, 'Abort');
    RegisterMethod(@TJvSearchFiles.Search, 'Search');
    RegisterPropertyHelper(@TJvSearchFilesFindData_R,nil,'FindData');
    RegisterPropertyHelper(@TJvSearchFilesFiles_R,nil,'Files');
    RegisterPropertyHelper(@TJvSearchFilesDirectories_R,nil,'Directories');
    RegisterPropertyHelper(@TJvSearchFilesIsRootDirValid_R,nil,'IsRootDirValid');
    RegisterPropertyHelper(@TJvSearchFilesSearching_R,nil,'Searching');
    RegisterPropertyHelper(@TJvSearchFilesTotalDirectories_R,nil,'TotalDirectories');
    RegisterPropertyHelper(@TJvSearchFilesTotalFileSize_R,nil,'TotalFileSize');
    RegisterPropertyHelper(@TJvSearchFilesTotalFiles_R,nil,'TotalFiles');
    RegisterPropertyHelper(@TJvSearchFilesDirOption_R,@TJvSearchFilesDirOption_W,'DirOption');
    RegisterPropertyHelper(@TJvSearchFilesRecurseDepth_R,@TJvSearchFilesRecurseDepth_W,'RecurseDepth');
    RegisterPropertyHelper(@TJvSearchFilesRootDirectory_R,@TJvSearchFilesRootDirectory_W,'RootDirectory');
    RegisterPropertyHelper(@TJvSearchFilesOptions_R,@TJvSearchFilesOptions_W,'Options');
    RegisterPropertyHelper(@TJvSearchFilesErrorResponse_R,@TJvSearchFilesErrorResponse_W,'ErrorResponse');
    RegisterPropertyHelper(@TJvSearchFilesDirParams_R,@TJvSearchFilesDirParams_W,'DirParams');
    RegisterPropertyHelper(@TJvSearchFilesFileParams_R,@TJvSearchFilesFileParams_W,'FileParams');
    RegisterPropertyHelper(@TJvSearchFilesOnBeginScanDir_R,@TJvSearchFilesOnBeginScanDir_W,'OnBeginScanDir');
    RegisterPropertyHelper(@TJvSearchFilesOnFindFile_R,@TJvSearchFilesOnFindFile_W,'OnFindFile');
    RegisterPropertyHelper(@TJvSearchFilesOnFindDirectory_R,@TJvSearchFilesOnFindDirectory_W,'OnFindDirectory');
    RegisterPropertyHelper(@TJvSearchFilesOnAbort_R,@TJvSearchFilesOnAbort_W,'OnAbort');
    RegisterPropertyHelper(@TJvSearchFilesOnError_R,@TJvSearchFilesOnError_W,'OnError');
    RegisterPropertyHelper(@TJvSearchFilesOnCheck_R,@TJvSearchFilesOnCheck_W,'OnCheck');
    RegisterPropertyHelper(@TJvSearchFilesOnProgress_R,@TJvSearchFilesOnProgress_W,'OnProgress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSearchParams(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSearchParams) do  begin
    RegisterConstructor(@TJvSearchParams.Create, 'Create');
    RegisterMethod(@TJvSearchParams.Destroy, 'Free');
    RegisterMethod(@TJvSearchParams.Assign, 'Assign');
    RegisterMethod(@TJvSearchParams.Check, 'Check');
    RegisterPropertyHelper(@TJvSearchParamsFileMask_R,@TJvSearchParamsFileMask_W,'FileMask');
    RegisterPropertyHelper(@TJvSearchParamsFileMaskSeperator_R,@TJvSearchParamsFileMaskSeperator_W,'FileMaskSeperator');
    RegisterPropertyHelper(@TJvSearchParamsAttributes_R,@TJvSearchParamsAttributes_W,'Attributes');
    RegisterPropertyHelper(@TJvSearchParamsSearchTypes_R,@TJvSearchParamsSearchTypes_W,'SearchTypes');
    RegisterPropertyHelper(@TJvSearchParamsMinSize_R,@TJvSearchParamsMinSize_W,'MinSize');
    RegisterPropertyHelper(@TJvSearchParamsMaxSize_R,@TJvSearchParamsMaxSize_W,'MaxSize');
    RegisterPropertyHelper(@TJvSearchParamsLastChangeAfter_R,@TJvSearchParamsLastChangeAfter_W,'LastChangeAfter');
    RegisterPropertyHelper(@TJvSearchParamsLastChangeBefore_R,@TJvSearchParamsLastChangeBefore_W,'LastChangeBefore');
    RegisterPropertyHelper(@TJvSearchParamsFileMasks_R,@TJvSearchParamsFileMasks_W,'FileMasks');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSearchAttributes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSearchAttributes) do begin
    RegisterMethod(@TJvSearchAttributes.Assign, 'Assign');
    RegisterPropertyHelper(@TJvSearchAttributesIncludeAttr_R,@TJvSearchAttributesIncludeAttr_W,'IncludeAttr');
    RegisterPropertyHelper(@TJvSearchAttributesExcludeAttr_R,@TJvSearchAttributesExcludeAttr_W,'ExcludeAttr');
    RegisterPropertyHelper(@TJvSearchAttributesReadOnly_R,@TJvSearchAttributesReadOnly_W,'ReadOnly');
    RegisterPropertyHelper(@TJvSearchAttributesHidden_R,@TJvSearchAttributesHidden_W,'Hidden');
    RegisterPropertyHelper(@TJvSearchAttributesSystem_R,@TJvSearchAttributesSystem_W,'System');
    RegisterPropertyHelper(@TJvSearchAttributesArchive_R,@TJvSearchAttributesArchive_W,'Archive');
    RegisterPropertyHelper(@TJvSearchAttributesNormal_R,@TJvSearchAttributesNormal_W,'Normal');
    RegisterPropertyHelper(@TJvSearchAttributesTemporary_R,@TJvSearchAttributesTemporary_W,'Temporary');
    RegisterPropertyHelper(@TJvSearchAttributesSparseFile_R,@TJvSearchAttributesSparseFile_W,'SparseFile');
    RegisterPropertyHelper(@TJvSearchAttributesReparsePoint_R,@TJvSearchAttributesReparsePoint_W,'ReparsePoint');
    RegisterPropertyHelper(@TJvSearchAttributesCompressed_R,@TJvSearchAttributesCompressed_W,'Compressed');
    RegisterPropertyHelper(@TJvSearchAttributesOffLine_R,@TJvSearchAttributesOffLine_W,'OffLine');
    RegisterPropertyHelper(@TJvSearchAttributesNotContentIndexed_R,@TJvSearchAttributesNotContentIndexed_W,'NotContentIndexed');
    RegisterPropertyHelper(@TJvSearchAttributesEncrypted_R,@TJvSearchAttributesEncrypted_W,'Encrypted');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvSearchFiles(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvSearchAttributes(CL);
  RIRegister_TJvSearchParams(CL);
  RIRegister_TJvSearchFiles(CL);
end;

 
 
{ TPSImport_JvSearchFiles }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSearchFiles.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvSearchFiles(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSearchFiles.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvSearchFiles(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
