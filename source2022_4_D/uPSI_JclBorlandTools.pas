unit uPSI_JclBorlandTools;
{
   just a beta for different use
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
  TPSImport_JclBorlandTools = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclBorRADToolInstallations(CL: TPSPascalCompiler);
procedure SIRegister_TJclBDSInstallation(CL: TPSPascalCompiler);
procedure SIRegister_TJclDCCIL(CL: TPSPascalCompiler);
procedure SIRegister_TJclDelphiInstallation(CL: TPSPascalCompiler);
procedure SIRegister_TJclBCBInstallation(CL: TPSPascalCompiler);
procedure SIRegister_TJclBorRADToolInstallation(CL: TPSPascalCompiler);
procedure SIRegister_TJclBorRADToolRepository(CL: TPSPascalCompiler);
procedure SIRegister_TJclBorRADToolPalette(CL: TPSPascalCompiler);
procedure SIRegister_TJclBorlandMake(CL: TPSPascalCompiler);
procedure SIRegister_TJclBpr2Mak(CL: TPSPascalCompiler);
procedure SIRegister_TJclDCC32(CL: TPSPascalCompiler);
procedure SIRegister_TJclBCC32(CL: TPSPascalCompiler);
procedure SIRegister_TJclBorlandCommandLineTool(CL: TPSPascalCompiler);
procedure SIRegister_TJclCommandLineTool(CL: TPSPascalCompiler);
procedure SIRegister_IJclCommandLineTool(CL: TPSPascalCompiler);
procedure SIRegister_TJclBorRADToolIdePackages(CL: TPSPascalCompiler);
procedure SIRegister_TJclBorRADToolIdeTool(CL: TPSPascalCompiler);
procedure SIRegister_TJclHelp2Manager(CL: TPSPascalCompiler);
procedure SIRegister_TJclBorlandOpenHelp(CL: TPSPascalCompiler);
procedure SIRegister_TJclBorRADToolInstallationObject(CL: TPSPascalCompiler);
procedure SIRegister_JclBorlandTools(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclBorlandTools_Routines(S: TPSExec);
procedure RIRegister_TJclBorRADToolInstallations(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBDSInstallation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclDCCIL(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclDelphiInstallation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBCBInstallation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBorRADToolInstallation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBorRADToolRepository(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBorRADToolPalette(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBorlandMake(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBpr2Mak(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclDCC32(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBCC32(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBorlandCommandLineTool(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclCommandLineTool(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBorRADToolIdePackages(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBorRADToolIdeTool(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclHelp2Manager(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBorlandOpenHelp(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBorRADToolInstallationObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclBorlandTools(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  //,MSHelpServices_TLB
  ,IniFiles
  ,Contnrs
  ,JclBase
  ,JclSysUtils_max
  ,JclBorlandTools
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclBorlandTools]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBorRADToolInstallations(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclBorRADToolInstallations') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclBorRADToolInstallations') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function AnyInstanceRunning : Boolean');
    RegisterMethod('Function AnyUpdatePackNeeded( var Text : string) : Boolean');
    RegisterMethod('Function Iterate( TraverseMethod : TTraverseMethod) : Boolean');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Installations', 'TJclBorRADToolInstallation Integer', iptr);
    SetDefaultPropery('Installations');
    RegisterProperty('BCBInstallationFromVersion', 'TJclBorRADToolInstallation Integer', iptr);
    RegisterProperty('DelphiInstallationFromVersion', 'TJclBorRADToolInstallation Integer', iptr);
    RegisterProperty('BDSInstallationFromVersion', 'TJclBorRADToolInstallation Integer', iptr);
    RegisterProperty('BCBVersionInstalled', 'Boolean Integer', iptr);
    RegisterProperty('DelphiVersionInstalled', 'Boolean Integer', iptr);
    RegisterProperty('BDSVersionInstalled', 'Boolean Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBDSInstallation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorRADToolInstallation', 'TJclBDSInstallation') do
  with CL.AddClassN(CL.FindClass('TJclBorRADToolInstallation'),'TJclBDSInstallation') do
  begin
    RegisterMethod('Constructor Create( const AConfigDataLocation : string; ARootKey : Cardinal)');
    RegisterMethod('Function PackageSourceFileExtension : string');
    RegisterMethod('Function ProjectSourceFileExtension : string');
    RegisterMethod('Function RadToolKind : TJclBorRadToolKind');
    RegisterMethod('Function GetLatestUpdatePackForVersion( Version : Integer) : Integer');
    RegisterMethod('Function GetDefaultProjectsDir : string');
    RegisterMethod('Function GetCommonProjectsDir : string');
    RegisterMethod('Function GetDefaultProjectsDirectory( const RootDir : string; IDEVersionNumber : Integer) : string');
    RegisterMethod('Function GetCommonProjectsDirectory( const RootDir : string; IDEVersionNumber : Integer) : string');
    RegisterMethod('Function AddToCppSearchPath( const Path : string) : Boolean');
    RegisterMethod('Function AddToCppBrowsingPath( const Path : string) : Boolean');
    RegisterMethod('Function AddToCppLibraryPath( const Path : string) : Boolean');
    RegisterMethod('Function RemoveFromCppSearchPath( const Path : string) : Boolean');
    RegisterMethod('Function RemoveFromCppBrowsingPath( const Path : string) : Boolean');
    RegisterMethod('Function RemoveFromCppLibraryPath( const Path : string) : Boolean');
    RegisterProperty('CppSearchPath', 'TJclBorRADToolPath', iptrw);
    RegisterProperty('CppBrowsingPath', 'TJclBorRADToolPath', iptrw);
    RegisterProperty('CppLibraryPath', 'TJclBorRADToolPath', iptrw);
    RegisterMethod('Function CleanPackageCache( const BinaryFileName : string) : Boolean');
    RegisterMethod('Function CompileDelphiDotNetProject( const ProjectName, OutputDir : string; PEFormat : TJclBorPlatform; const CLRVersion : string; const ExtraOptions : string) : Boolean');
    RegisterProperty('DualPackageInstallation', 'Boolean', iptrw);
    RegisterProperty('Help2Manager', 'TJclHelp2Manager', iptr);
    RegisterProperty('DCCIL', 'TJclDCCIL', iptr);
    RegisterProperty('MaxDelphiCLRVersion', 'string', iptr);
    RegisterProperty('PdbCreate', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclDCCIL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclDCC32', 'TJclDCCIL') do
  with CL.AddClassN(CL.FindClass('TJclDCC32'),'TJclDCCIL') do
  begin
    RegisterMethod('Function MakeProject( const ProjectName, OutputDir, ExtraOptions : string) : Boolean');
    RegisterProperty('MaxCLRVersion', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclDelphiInstallation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorRADToolInstallation', 'TJclDelphiInstallation') do
  with CL.AddClassN(CL.FindClass('TJclBorRADToolInstallation'),'TJclDelphiInstallation') do
  begin
    RegisterMethod('Function InstallPackage( const PackageName, BPLPath, DCPPath : string) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBCBInstallation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorRADToolInstallation', 'TJclBCBInstallation') do
  with CL.AddClassN(CL.FindClass('TJclBorRADToolInstallation'),'TJclBCBInstallation') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBorRADToolInstallation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclBorRADToolInstallation') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclBorRADToolInstallation') do
  begin
    RegisterMethod('Constructor Create( const AConfigDataLocation : string; ARootKey : Cardinal)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure ExtractPaths( const Path : TJclBorRADToolPath; List : TStrings)');
    RegisterMethod('Function GetLatestUpdatePackForVersion( Version : Integer) : Integer');
    RegisterMethod('Function PackageSourceFileExtension : string');
    RegisterMethod('Function ProjectSourceFileExtension : string');
    RegisterMethod('Function RadToolKind : TJclBorRadToolKind');
    RegisterMethod('Function RadToolName : string');
    RegisterMethod('Function AnyInstanceRunning : Boolean');
    RegisterMethod('Function AddToDebugDCUPath( const Path : string) : Boolean');
    RegisterMethod('Function AddToLibrarySearchPath( const Path : string) : Boolean');
    RegisterMethod('Function AddToLibraryBrowsingPath( const Path : string) : Boolean');
    RegisterMethod('Function ConfigFileName( const Extension : string) : string');
    RegisterMethod('Function FindFolderInPath( Folder : string; List : TStrings) : Integer');
    RegisterMethod('Function CompilePackage( const PackageName, BPLPath, DCPPath : string) : Boolean');
    RegisterMethod('Function InstallPackage( const PackageName, BPLPath, DCPPath : string) : Boolean');
    RegisterMethod('Function UninstallPackage( const PackageName, BPLPath, DCPPath : string) : Boolean');
    RegisterMethod('Function InstallIDEPackage( const PackageName, BPLPath, DCPPath : string) : Boolean');
    RegisterMethod('Function UninstallIDEPackage( const PackageName, BPLPath, DCPPath : string) : Boolean');
    RegisterMethod('Function CompileProject( const ProjectName, OutputDir, DcpSearchPath : string) : Boolean');
    RegisterMethod('Function InstallExpert( const ProjectName, OutputDir, DcpSearchPath : string) : Boolean');
    RegisterMethod('Function UninstallExpert( const ProjectName, OutputDir : string) : Boolean');
    RegisterMethod('Function RegisterPackage( const BinaryFileName, Description : string) : Boolean;');
    RegisterMethod('Function RegisterPackage1( const PackageName, BPLPath, Description : string) : Boolean;');
    RegisterMethod('Function UnregisterPackage( const BinaryFileName : string) : Boolean;');
    RegisterMethod('Function UnregisterPackage1( const PackageName, BPLPath : string) : Boolean;');
    RegisterMethod('Function RegisterIDEPackage( const BinaryFileName, Description : string) : Boolean;');
    RegisterMethod('Function RegisterIDEPackage1( const PackageName, BPLPath, Description : string) : Boolean;');
    RegisterMethod('Function UnregisterIDEPackage( const BinaryFileName : string) : Boolean;');
    RegisterMethod('Function UnregisterIDEPackage1( const PackageName, BPLPath : string) : Boolean;');
    RegisterMethod('Function RegisterExpert( const BinaryFileName, Description : string) : Boolean;');
    RegisterMethod('Function RegisterExpert1( const ProjectName, OutputDir, Description : string) : Boolean;');
    RegisterMethod('Function UnregisterExpert( const BinaryFileName : string) : Boolean;');
    RegisterMethod('Function UnregisterExpert1( const ProjectName, OutputDir : string) : Boolean;');
    RegisterMethod('Function IsBDSPersonality : Boolean');
    RegisterMethod('Function GetDefaultProjectsDir : string');
    RegisterMethod('Function GetCommonProjectsDir : string');
    RegisterMethod('Function RemoveFromDebugDCUPath( const Path : string) : Boolean');
    RegisterMethod('Function RemoveFromLibrarySearchPath( const Path : string) : Boolean');
    RegisterMethod('Function RemoveFromLibraryBrowsingPath( const Path : string) : Boolean');
    RegisterMethod('Function SubstitutePath( const Path : string) : string');
    RegisterMethod('Function SupportsBCB : Boolean');
    RegisterMethod('Function SupportsVisualCLX : Boolean');
    RegisterMethod('Function SupportsVCL : Boolean');
    RegisterMethod('Function LibFolderName : string');
    RegisterMethod('Function ObjFolderName : string');
    RegisterProperty('CommandLineTools', 'TCommandLineTools', iptr);
    RegisterProperty('BCC32', 'TJclBCC32', iptr);
    RegisterProperty('DCC32', 'TJclDCC32', iptr);
    RegisterProperty('Bpr2Mak', 'TJclBpr2Mak', iptr);
    RegisterProperty('Make', 'IJclCommandLineTool', iptr);
    RegisterProperty('BinFolderName', 'string', iptr);
    RegisterProperty('BPLOutputPath', 'string', iptr);
    RegisterProperty('DebugDCUPath', 'TJclBorRADToolPath', iptrw);
    RegisterProperty('DCPOutputPath', 'string', iptr);
    RegisterProperty('DefaultProjectsDir', 'string', iptr);
    RegisterProperty('CommonProjectsDir', 'string', iptr);
    RegisterProperty('Description', 'string', iptr);
    RegisterProperty('Edition', 'TJclBorRADToolEdition', iptr);
    RegisterProperty('EditionAsText', 'string', iptr);
    RegisterProperty('EnvironmentVariables', 'TStrings', iptr);
    RegisterProperty('IdePackages', 'TJclBorRADToolIdePackages', iptr);
    RegisterProperty('IdeTools', 'TJclBorRADToolIdeTool', iptr);
    RegisterProperty('IdeExeBuildNumber', 'string', iptr);
    RegisterProperty('IdeExeFileName', 'string', iptr);
    RegisterProperty('InstalledUpdatePack', 'Integer', iptr);
    RegisterProperty('LatestUpdatePack', 'Integer', iptr);
    RegisterProperty('LibrarySearchPath', 'TJclBorRADToolPath', iptrw);
    RegisterProperty('LibraryBrowsingPath', 'TJclBorRADToolPath', iptrw);
    RegisterProperty('OpenHelp', 'TJclBorlandOpenHelp', iptr);
    RegisterProperty('MapCreate', 'Boolean', iptrw);
    RegisterProperty('JdbgCreate', 'Boolean', iptrw);
    RegisterProperty('JdbgInsert', 'Boolean', iptrw);
    RegisterProperty('MapDelete', 'Boolean', iptrw);
    RegisterProperty('ConfigData', 'TCustomIniFile', iptr);
    RegisterProperty('ConfigDataLocation', 'string', iptr);
    RegisterProperty('Globals', 'TStrings', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('Palette', 'TJclBorRADToolPalette', iptr);
    RegisterProperty('Repository', 'TJclBorRADToolRepository', iptr);
    RegisterProperty('RootDir', 'string', iptr);
    RegisterProperty('UpdateNeeded', 'Boolean', iptr);
    RegisterProperty('Valid', 'Boolean', iptr);
    RegisterProperty('VclIncludeDir', 'string', iptr);
    RegisterProperty('IDEVersionNumber', 'Integer', iptr);
    RegisterProperty('IDEVersionNumberStr', 'string', iptr);
    RegisterProperty('VersionNumber', 'Integer', iptr);
    RegisterProperty('VersionNumberStr', 'string', iptr);
    RegisterProperty('Personalities', 'TJclBorPersonalities', iptr);
    RegisterProperty('DCC', 'TJclDCC32', iptr);
    RegisterProperty('SupportsLibSuffix', 'Boolean', iptr);
    RegisterProperty('OutputCallback', 'TTextHandler', iptrw);
    RegisterProperty('IsTurboExplorer', 'Boolean', iptr);
    RegisterProperty('RootKey', 'Cardinal', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBorRADToolRepository(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorRADToolInstallationObject', 'TJclBorRADToolRepository') do
  with CL.AddClassN(CL.FindClass('TJclBorRADToolInstallationObject'),'TJclBorRADToolRepository') do begin
  RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AddObject( const FileName, ObjectType, PageName, ObjectName, IconFileName, Description, Author, Designer : string; const Ancestor : string)');
    RegisterMethod('Procedure CloseIniFile');
    RegisterMethod('Function FindPage( const Name : string; OptionalIndex : Integer) : string');
    RegisterMethod('Procedure RemoveObjects( const PartialPath, FileName, ObjectType : string)');
    RegisterProperty('FileName', 'string', iptr);
    RegisterProperty('IniFile', 'TIniFile', iptr);
    RegisterProperty('Pages', 'TStrings', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBorRADToolPalette(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorRADToolInstallationObject', 'TJclBorRADToolPalette') do
  with CL.AddClassN(CL.FindClass('TJclBorRADToolInstallationObject'),'TJclBorRADToolPalette') do begin
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure ComponentsOnTabToStrings( Index : Integer; Strings : TStrings; IncludeUnitName : Boolean; IncludeHiddenComponents : Boolean)');
    RegisterMethod('Function DeleteTabName( const TabName : string) : Boolean');
    RegisterMethod('Function TabNameExists( const TabName : string) : Boolean');
    RegisterProperty('ComponentsOnTab', 'string Integer', iptr);
    RegisterProperty('HiddenComponentsOnTab', 'string Integer', iptr);
    RegisterProperty('Key', 'string', iptr);
    RegisterProperty('TabNames', 'string Integer', iptr);
    RegisterProperty('TabNameCount', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBorlandMake(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorlandCommandLineTool', 'TJclBorlandMake') do
  with CL.AddClassN(CL.FindClass('TJclBorlandCommandLineTool'),'TJclBorlandMake') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBpr2Mak(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorlandCommandLineTool', 'TJclBpr2Mak') do
  with CL.AddClassN(CL.FindClass('TJclBorlandCommandLineTool'),'TJclBpr2Mak') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclDCC32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorlandCommandLineTool', 'TJclDCC32') do
  with CL.AddClassN(CL.FindClass('TJclBorlandCommandLineTool'),'TJclDCC32') do
  begin
    RegisterMethod('Function MakePackage( const PackageName, BPLPath, DCPPath : string; ExtraOptions : string) : Boolean');
    RegisterMethod('Function MakeProject( const ProjectName, OutputDir, DcpSearchPath : string; ExtraOptions : string) : Boolean');
    RegisterMethod('Procedure SetDefaultOptions');
    RegisterMethod('Function SupportsLibSuffix : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBCC32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorlandCommandLineTool', 'TJclBCC32') do
  with CL.AddClassN(CL.FindClass('TJclBorlandCommandLineTool'),'TJclBCC32') do
  begin
    RegisterMethod('Function SupportsLibSuffix : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBorlandCommandLineTool(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorRADToolInstallationObject', 'TJclBorlandCommandLineTool') do
  with CL.AddClassN(CL.FindClass('TJclBorRADToolInstallationObject'),'TJclBorlandCommandLineTool') do
  begin
   RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AddPathOption( const Option, Path : string)');
    RegisterMethod('Function Execute( const CommandLine : string) : Boolean');
    RegisterProperty('FileName', 'string', iptr);
    RegisterProperty('Output', 'string', iptr);
    RegisterProperty('OutputCallback', 'TTextHandler', iptrw);
    RegisterProperty('Options', 'TStrings', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclCommandLineTool(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TJclCommandLineTool') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TJclCommandLineTool') do
  begin
    RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclCommandLineTool(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IJclCommandLineTool') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclCommandLineTool, 'IJclCommandLineTool') do
  begin
    RegisterMethod('Function GetExeName : string', cdRegister);
    RegisterMethod('Function GetOptions : TStrings', cdRegister);
    RegisterMethod('Function GetOutput : string', cdRegister);
    RegisterMethod('Function GetOutputCallback : TTextHandler', cdRegister);
    RegisterMethod('Procedure AddPathOption( const Option, Path : string)', cdRegister);
    RegisterMethod('Function Execute( const CommandLine : string) : Boolean', cdRegister);
    RegisterMethod('Procedure SetOutputCallback( const CallbackMethod : TTextHandler)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBorRADToolIdePackages(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorRADToolInstallationObject', 'TJclBorRADToolIdePackages') do
  with CL.AddClassN(CL.FindClass('TJclBorRADToolInstallationObject'),'TJclBorRADToolIdePackages') do
  begin
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function AddPackage( const FileName, Description : string) : Boolean');
    RegisterMethod('Function AddIDEPackage( const FileName, Description : string) : Boolean');
    RegisterMethod('Function AddExpert( const FileName, Description : string) : Boolean');
    RegisterMethod('Function RemovePackage( const FileName : string) : Boolean');
    RegisterMethod('Function RemoveIDEPackage( const FileName : string) : Boolean');
    RegisterMethod('Function RemoveExpert( const FileName : string) : Boolean');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('IDECount', 'Integer', iptr);
    RegisterProperty('ExpertCount', 'Integer', iptr);
    RegisterProperty('PackageDescriptions', 'string Integer', iptr);
    RegisterProperty('IDEPackageDescriptions', 'string Integer', iptr);
    RegisterProperty('ExpertDescriptions', 'string Integer', iptr);
    RegisterProperty('PackageFileNames', 'string Integer', iptr);
    RegisterProperty('IDEPackageFileNames', 'string Integer', iptr);
    RegisterProperty('ExpertFileNames', 'string Integer', iptr);
    RegisterProperty('PackageDisabled', 'Boolean Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBorRADToolIdeTool(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorRADToolInstallationObject', 'TJclBorRADToolIdeTool') do
  with CL.AddClassN(CL.FindClass('TJclBorRADToolInstallationObject'),'TJclBorRADToolIdeTool') do
  begin
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterMethod('Function IndexOfPath( const Value : string) : Integer');
    RegisterMethod('Function IndexOfTitle( const Value : string) : Integer');
    RegisterMethod('Procedure RemoveIndex( const Index : Integer)');
    RegisterProperty('Key', 'string', iptr);
    RegisterProperty('Title', 'string Integer', iptrw);
    RegisterProperty('Path', 'string Integer', iptrw);
    RegisterProperty('Parameters', 'string Integer', iptrw);
    RegisterProperty('WorkingDir', 'string Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclHelp2Manager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorRADToolInstallationObject', 'TJclHelp2Manager') do
  with CL.AddClassN(CL.FindClass('TJclBorRADToolInstallationObject'),'TJclHelp2Manager') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function CreateTransaction : Boolean');
    RegisterMethod('Function CommitTransaction : Boolean');
    RegisterMethod('Function RegisterNameSpace( const Name, Collection, Description : WideString) : Boolean');
    RegisterMethod('Function UnregisterNameSpace( const Name : WideString) : Boolean');
    RegisterMethod('Function RegisterHelpFile( const NameSpace, Identifier : WideString; const LangId : Integer; const HxSFile, HxIFile : WideString) : Boolean');
    RegisterMethod('Function UnregisterHelpFile( const NameSpace, Identifier : WideString; const LangId : Integer) : Boolean');
    RegisterMethod('Function PlugNameSpaceIn( const SourceNameSpace, TargetNameSpace : WideString) : Boolean');
    RegisterMethod('Function UnPlugNameSpace( const SourceNameSpace, TargetNameSpace : WideString) : Boolean');
    RegisterMethod('Function PlugNameSpaceInBorlandHelp( const NameSpace : WideString) : Boolean');
    RegisterMethod('Function UnPlugNameSpaceFromBorlandHelp( const NameSpace : WideString) : Boolean');
    RegisterProperty('HxRegisterSession', 'IHxRegisterSession', iptr);
    RegisterProperty('HxRegister', 'IHxRegister', iptr);
    RegisterProperty('HxPlugin', 'IHxPlugin', iptr);
    RegisterProperty('IdeNamespace', 'WideString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBorlandOpenHelp(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBorRADToolInstallationObject', 'TJclBorlandOpenHelp') do
  with CL.AddClassN(CL.FindClass('TJclBorRADToolInstallationObject'),'TJclBorlandOpenHelp') do
  begin
    RegisterMethod('Function AddHelpFile( const HelpFileName, IndexName : string) : Boolean');
    RegisterMethod('Function RemoveHelpFile( const HelpFileName, IndexName : string) : Boolean');
    RegisterProperty('ContentFileName', 'string', iptr);
    RegisterProperty('GidFileName', 'string', iptr);
    RegisterProperty('IndexFileName', 'string', iptr);
    RegisterProperty('LinkFileName', 'string', iptr);
    RegisterProperty('ProjectFileName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBorRADToolInstallationObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TJclBorRADToolInstallationObject') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TJclBorRADToolInstallationObject') do
  begin
    RegisterProperty('Installation', 'TJclBorRADToolInstallation', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclBorlandTools(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclBorRADException');
  CL.AddTypeS('TJclBorRADToolKind', '( brDelphi, brCppBuilder, brBorlandDevStudio )');
  CL.AddTypeS('TJclBorRADToolEdition', '( deOPEN, dePRO, deSVR )');
  CL.AddTypeS('TJclBorRADToolEdition', '( deSTD, dePRO, deCSS, deARC )');
  CL.AddTypeS('TJclBorRADToolPath', 'string');
 CL.AddConstantN('SupportedDelphiVersions','LongInt').SetInt( 5 or  6 or  7 or  8 or  9 or  10 or  11);
 CL.AddConstantN('SupportedBCBVersions','LongInt').SetInt( 5 or  6 or  10 or  11);
 CL.AddConstantN('SupportedBDSVersions','LongInt').SetInt( 1 or  2 or  3 or  4 or  5);
 CL.AddConstantN('BorRADToolRepositoryPagesSection','String').SetString( 'Repository Pages');
 CL.AddConstantN('BorRADToolRepositoryDialogsPage','String').SetString( 'Dialogs');
 CL.AddConstantN('BorRADToolRepositoryFormsPage','String').SetString( 'Forms');
 CL.AddConstantN('BorRADToolRepositoryProjectsPage','String').SetString( 'Projects');
 CL.AddConstantN('BorRADToolRepositoryDataModulesPage','String').SetString( 'Data Modules');
 CL.AddConstantN('BorRADToolRepositoryObjectType','String').SetString( 'Type');
 CL.AddConstantN('BorRADToolRepositoryFormTemplate','String').SetString( 'FormTemplate');
 CL.AddConstantN('BorRADToolRepositoryProjectTemplate','String').SetString( 'ProjectTemplate');
 CL.AddConstantN('BorRADToolRepositoryObjectName','String').SetString( 'Name');
 CL.AddConstantN('BorRADToolRepositoryObjectPage','String').SetString( 'Page');
 CL.AddConstantN('BorRADToolRepositoryObjectIcon','String').SetString( 'Icon');
 CL.AddConstantN('BorRADToolRepositoryObjectDescr','String').SetString( 'Description');
 CL.AddConstantN('BorRADToolRepositoryObjectAuthor','String').SetString( 'Author');
 CL.AddConstantN('BorRADToolRepositoryObjectAncestor','String').SetString( 'Ancestor');
 CL.AddConstantN('BorRADToolRepositoryObjectDesigner','String').SetString( 'Designer');
 CL.AddConstantN('BorRADToolRepositoryDesignerDfm','String').SetString( 'dfm');
 CL.AddConstantN('BorRADToolRepositoryDesignerXfm','String').SetString( 'xfm');
 CL.AddConstantN('BorRADToolRepositoryObjectNewForm','String').SetString( 'DefaultNewForm');
 CL.AddConstantN('BorRADToolRepositoryObjectMainForm','String').SetString( 'DefaultMainForm');
 CL.AddConstantN('SourceExtensionDelphiPackage','String').SetString( '.dpk');
 CL.AddConstantN('SourceExtensionBCBPackage','String').SetString( '.bpk');
 CL.AddConstantN('SourceExtensionDelphiProject','String').SetString( '.dpr');
 CL.AddConstantN('SourceExtensionBCBProject','String').SetString( '.bpr');
 CL.AddConstantN('SourceExtensionBDSProject','String').SetString( '.bdsproj');
 CL.AddConstantN('SourceExtensionDProject','String').SetString( '.dproj');
 CL.AddConstantN('BinaryExtensionPackage','String').SetString( '.bpl');
 CL.AddConstantN('BinaryExtensionLibrary','String').SetString( '.dll');
 CL.AddConstantN('BinaryExtensionExecutable','String').SetString( '.exe');
 CL.AddConstantN('CompilerExtensionDCP','String').SetString( '.dcp');
 CL.AddConstantN('CompilerExtensionBPI','String').SetString( '.bpi');
 CL.AddConstantN('CompilerExtensionLIB','String').SetString( '.lib');
 CL.AddConstantN('CompilerExtensionTDS','String').SetString( '.tds');
 CL.AddConstantN('CompilerExtensionMAP','String').SetString( '.map');
 CL.AddConstantN('CompilerExtensionDRC','String').SetString( '.drc');
 CL.AddConstantN('CompilerExtensionDEF','String').SetString( '.def');
 CL.AddConstantN('SourceExtensionCPP','String').SetString( '.cpp');
 CL.AddConstantN('SourceExtensionH','String').SetString( '.h');
 CL.AddConstantN('SourceExtensionPAS','String').SetString( '.pas');
 CL.AddConstantN('SourceExtensionDFM','String').SetString( '.dfm');
 CL.AddConstantN('SourceExtensionXFM','String').SetString( '.xfm');
 CL.AddConstantN('SourceDescriptionPAS','String').SetString( 'Pascal source file');
 CL.AddConstantN('SourceDescriptionCPP','String').SetString( 'C++ source file');
 CL.AddConstantN('DesignerVCL','String').SetString( 'VCL');
 CL.AddConstantN('DesignerCLX','String').SetString( 'CLX');
 CL.AddConstantN('ProjectTypePackage','String').SetString( 'package');
 CL.AddConstantN('ProjectTypeLibrary','String').SetString( 'library');
 CL.AddConstantN('ProjectTypeProgram','String').SetString( 'program');
 CL.AddConstantN('Personality32Bit','String').SetString( '32 bit');
 CL.AddConstantN('Personality64Bit','String').SetString( '64 bit');
 CL.AddConstantN('PersonalityDelphi','String').SetString( 'Delphi');
 CL.AddConstantN('PersonalityDelphiDotNet','String').SetString( 'Delphi.net');
 CL.AddConstantN('PersonalityBCB','String').SetString( 'C++Builder');
 CL.AddConstantN('PersonalityCSB','String').SetString( 'C#Builder');
 CL.AddConstantN('PersonalityVB','String').SetString( 'Visual Basic');
 CL.AddConstantN('PersonalityDesign','String').SetString( 'Design');
 CL.AddConstantN('PersonalityUnknown','String').SetString( 'Unknown personality');
 CL.AddConstantN('PersonalityBDS','String').SetString( 'Borland Developer Studio');
 CL.AddConstantN('DOFDirectoriesSection','String').SetString( 'Directories');
 CL.AddConstantN('DOFUnitOutputDirKey','String').SetString( 'UnitOutputDir');
 CL.AddConstantN('DOFSearchPathName','String').SetString( 'SearchPath');
 CL.AddConstantN('DOFConditionals','String').SetString( 'Conditionals');
 CL.AddConstantN('DOFLinkerSection','String').SetString( 'Linker');
 CL.AddConstantN('DOFPackagesKey','String').SetString( 'Packages');
 CL.AddConstantN('DOFCompilerSection','String').SetString( 'Compiler');
 CL.AddConstantN('DOFPackageNoLinkKey','String').SetString( 'PackageNoLink');
 CL.AddConstantN('DOFAdditionalSection','String').SetString( 'Additional');
 CL.AddConstantN('DOFOptionsKey','String').SetString( 'Options');
  CL.AddTypeS('TJclBorPersonality', '( bpDelphi32, bpDelphi64, bpBCBuilder32, b'
   +'pBCBuilder64, bpDelphiNet32, bpDelphiNet64, bpCSBuilder32, bpCSBuilder64, '
   +'bpVisualBasic32, bpVisualBasic64, bpDesign, bpUnknown )');
  CL.AddTypeS('TJclBorPersonalities', 'set of TJclBorPersonality');
  CL.AddTypeS('TJclBorDesigner', '( bdVCL, bdCLX )');
  CL.AddTypeS('TJclBorDesigners', 'set of TJClBorDesigner');
  CL.AddTypeS('TJclBorPlatform', '( bp32bit, bp64bit )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclBorRADToolInstallation');
  SIRegister_TJclBorRADToolInstallationObject(CL);
  SIRegister_TJclBorlandOpenHelp(CL);
  CL.AddTypeS('TJclHelp2Object', '( hoRegisterSession, hoRegister, hoPlugin )');
  CL.AddTypeS('TJclHelp2Objects', 'set of TJclHelp2Object');
  SIRegister_TJclHelp2Manager(CL);
  SIRegister_TJclBorRADToolIdeTool(CL);
  SIRegister_TJclBorRADToolIdePackages(CL);
  SIRegister_IJclCommandLineTool(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclCommandLineToolError');
  SIRegister_TJclCommandLineTool(CL);
  SIRegister_TJclBorlandCommandLineTool(CL);
  SIRegister_TJclBCC32(CL);
  SIRegister_TJclDCC32(CL);
  CL.AddTypeS('TJclDCC', 'TJclDCC32');
  SIRegister_TJclBpr2Mak(CL);
  SIRegister_TJclBorlandMake(CL);
  SIRegister_TJclBorRADToolPalette(CL);
  SIRegister_TJclBorRADToolRepository(CL);
  CL.AddTypeS('TCommandLineTool', '( clAsm, clBcc32, clDcc32, clDccIL, clMake,clProj2Mak )');
  CL.AddTypeS('TCommandLineTools', 'set of TCommandLineTool');
  //CL.AddTypeS('TJclBorRADToolInstallationClass', 'class of TJclBorRADToolInstallation');
  SIRegister_TJclBorRADToolInstallation(CL);
  SIRegister_TJclBCBInstallation(CL);
  SIRegister_TJclDelphiInstallation(CL);
  SIRegister_TJclDCCIL(CL);
  SIRegister_TJclBDSInstallation(CL);
  CL.AddTypeS('TTraverseMethod', 'Function ( Installation : TJclBorRADToolInstallation) : Boolean');
  SIRegister_TJclBorRADToolInstallations(CL);
 CL.AddDelphiFunction('Function BPLFileName( const BPLPath, PackageFileName : string) : string');
 CL.AddDelphiFunction('Function BinaryFileName( const OutputPath, ProjectFileName : string) : string');
 CL.AddDelphiFunction('Function IsDelphiPackage( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function IsDelphiProject( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function IsBCBPackage( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function IsBCBProject( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Procedure GetDPRFileInfo( const DPRFileName : string; out BinaryExtension : string; const LibSuffix : String)');
 CL.AddDelphiFunction('Procedure GetBPRFileInfo( const BPRFileName : string; out BinaryFileName : string; const Description : String)');
 CL.AddDelphiFunction('Procedure GetDPKFileInfo( const DPKFileName : string; out RunOnly : Boolean; const LibSuffix : String; const Description : String)');
 CL.AddDelphiFunction('Procedure GetBPKFileInfo( const BPKFileName : string; out RunOnly : Boolean; const BinaryFileName : String; const Description : String)');
  CL.AddDelphiFunction('function SamePath(const Path1, Path2: string): Boolean;');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationsBDSVersionInstalled_R(Self: TJclBorRADToolInstallations; var T: Boolean; const t1: Integer);
begin T := Self.BDSVersionInstalled[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationsDelphiVersionInstalled_R(Self: TJclBorRADToolInstallations; var T: Boolean; const t1: Integer);
begin T := Self.DelphiVersionInstalled[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationsBCBVersionInstalled_R(Self: TJclBorRADToolInstallations; var T: Boolean; const t1: Integer);
begin T := Self.BCBVersionInstalled[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationsBDSInstallationFromVersion_R(Self: TJclBorRADToolInstallations; var T: TJclBorRADToolInstallation; const t1: Integer);
begin T := Self.BDSInstallationFromVersion[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationsDelphiInstallationFromVersion_R(Self: TJclBorRADToolInstallations; var T: TJclBorRADToolInstallation; const t1: Integer);
begin T := Self.DelphiInstallationFromVersion[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationsBCBInstallationFromVersion_R(Self: TJclBorRADToolInstallations; var T: TJclBorRADToolInstallation; const t1: Integer);
begin T := Self.BCBInstallationFromVersion[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationsInstallations_R(Self: TJclBorRADToolInstallations; var T: TJclBorRADToolInstallation; const t1: Integer);
begin T := Self.Installations[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationsCount_R(Self: TJclBorRADToolInstallations; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationPdbCreate_W(Self: TJclBDSInstallation; const T: Boolean);
begin Self.PdbCreate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationPdbCreate_R(Self: TJclBDSInstallation; var T: Boolean);
begin T := Self.PdbCreate; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationMaxDelphiCLRVersion_R(Self: TJclBDSInstallation; var T: string);
begin T := Self.MaxDelphiCLRVersion; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationDCCIL_R(Self: TJclBDSInstallation; var T: TJclDCCIL);
begin T := Self.DCCIL; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationHelp2Manager_R(Self: TJclBDSInstallation; var T: TJclHelp2Manager);
begin T := Self.Help2Manager; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationDualPackageInstallation_W(Self: TJclBDSInstallation; const T: Boolean);
begin Self.DualPackageInstallation := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationDualPackageInstallation_R(Self: TJclBDSInstallation; var T: Boolean);
begin T := Self.DualPackageInstallation; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationCppLibraryPath_W(Self: TJclBDSInstallation; const T: TJclBorRADToolPath);
begin Self.CppLibraryPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationCppLibraryPath_R(Self: TJclBDSInstallation; var T: TJclBorRADToolPath);
begin T := Self.CppLibraryPath; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationCppBrowsingPath_W(Self: TJclBDSInstallation; const T: TJclBorRADToolPath);
begin Self.CppBrowsingPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationCppBrowsingPath_R(Self: TJclBDSInstallation; var T: TJclBorRADToolPath);
begin T := Self.CppBrowsingPath; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationCppSearchPath_W(Self: TJclBDSInstallation; const T: TJclBorRADToolPath);
begin Self.CppSearchPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBDSInstallationCppSearchPath_R(Self: TJclBDSInstallation; var T: TJclBorRADToolPath);
begin T := Self.CppSearchPath; end;

(*----------------------------------------------------------------------------*)
procedure TJclDCCILMaxCLRVersion_R(Self: TJclDCCIL; var T: string);
begin T := Self.MaxCLRVersion; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationRootKey_R(Self: TJclBorRADToolInstallation; var T: Cardinal);
begin T := Self.RootKey; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationIsTurboExplorer_R(Self: TJclBorRADToolInstallation; var T: Boolean);
begin T := Self.IsTurboExplorer; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationOutputCallback_W(Self: TJclBorRADToolInstallation; const T: TTextHandler);
begin Self.OutputCallback := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationOutputCallback_R(Self: TJclBorRADToolInstallation; var T: TTextHandler);
begin T := Self.OutputCallback; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationSupportsLibSuffix_R(Self: TJclBorRADToolInstallation; var T: Boolean);
begin T := Self.SupportsLibSuffix; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationDCC_R(Self: TJclBorRADToolInstallation; var T: TJclDCC32);
begin //T := Self.DCC;
end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationPersonalities_R(Self: TJclBorRADToolInstallation; var T: TJclBorPersonalities);
begin T := Self.Personalities; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationVersionNumberStr_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.VersionNumberStr; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationVersionNumber_R(Self: TJclBorRADToolInstallation; var T: Integer);
begin T := Self.VersionNumber; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationIDEVersionNumberStr_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.IDEVersionNumberStr; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationIDEVersionNumber_R(Self: TJclBorRADToolInstallation; var T: Integer);
begin T := Self.IDEVersionNumber; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationVclIncludeDir_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.VclIncludeDir; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationValid_R(Self: TJclBorRADToolInstallation; var T: Boolean);
begin T := Self.Valid; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationUpdateNeeded_R(Self: TJclBorRADToolInstallation; var T: Boolean);
begin T := Self.UpdateNeeded; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationRootDir_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.RootDir; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationRepository_R(Self: TJclBorRADToolInstallation; var T: TJclBorRADToolRepository);
begin T := Self.Repository; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationPalette_R(Self: TJclBorRADToolInstallation; var T: TJclBorRADToolPalette);
begin T := Self.Palette; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationName_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationGlobals_R(Self: TJclBorRADToolInstallation; var T: TStrings);
begin T := Self.Globals; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationConfigDataLocation_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.ConfigDataLocation; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationConfigData_R(Self: TJclBorRADToolInstallation; var T: TCustomIniFile);
begin T := Self.ConfigData; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationMapDelete_W(Self: TJclBorRADToolInstallation; const T: Boolean);
begin Self.MapDelete := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationMapDelete_R(Self: TJclBorRADToolInstallation; var T: Boolean);
begin T := Self.MapDelete; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationJdbgInsert_W(Self: TJclBorRADToolInstallation; const T: Boolean);
begin Self.JdbgInsert := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationJdbgInsert_R(Self: TJclBorRADToolInstallation; var T: Boolean);
begin T := Self.JdbgInsert; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationJdbgCreate_W(Self: TJclBorRADToolInstallation; const T: Boolean);
begin Self.JdbgCreate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationJdbgCreate_R(Self: TJclBorRADToolInstallation; var T: Boolean);
begin T := Self.JdbgCreate; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationMapCreate_W(Self: TJclBorRADToolInstallation; const T: Boolean);
begin Self.MapCreate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationMapCreate_R(Self: TJclBorRADToolInstallation; var T: Boolean);
begin T := Self.MapCreate; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationOpenHelp_R(Self: TJclBorRADToolInstallation; var T: TJclBorlandOpenHelp);
begin T := Self.OpenHelp; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationLibraryBrowsingPath_W(Self: TJclBorRADToolInstallation; const T: TJclBorRADToolPath);
begin Self.LibraryBrowsingPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationLibraryBrowsingPath_R(Self: TJclBorRADToolInstallation; var T: TJclBorRADToolPath);
begin T := Self.LibraryBrowsingPath; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationLibrarySearchPath_W(Self: TJclBorRADToolInstallation; const T: TJclBorRADToolPath);
begin Self.LibrarySearchPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationLibrarySearchPath_R(Self: TJclBorRADToolInstallation; var T: TJclBorRADToolPath);
begin T := Self.LibrarySearchPath; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationLatestUpdatePack_R(Self: TJclBorRADToolInstallation; var T: Integer);
begin T := Self.LatestUpdatePack; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationInstalledUpdatePack_R(Self: TJclBorRADToolInstallation; var T: Integer);
begin T := Self.InstalledUpdatePack; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationIdeExeFileName_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.IdeExeFileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationIdeExeBuildNumber_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.IdeExeBuildNumber; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationIdeTools_R(Self: TJclBorRADToolInstallation; var T: TJclBorRADToolIdeTool);
begin T := Self.IdeTools; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationIdePackages_R(Self: TJclBorRADToolInstallation; var T: TJclBorRADToolIdePackages);
begin T := Self.IdePackages; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationEnvironmentVariables_R(Self: TJclBorRADToolInstallation; var T: TStrings);
begin T := Self.EnvironmentVariables; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationEditionAsText_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.EditionAsText; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationEdition_R(Self: TJclBorRADToolInstallation; var T: TJclBorRADToolEdition);
begin T := Self.Edition; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationDescription_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationCommonProjectsDir_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.CommonProjectsDir; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationDefaultProjectsDir_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.DefaultProjectsDir; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationDCPOutputPath_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.DCPOutputPath; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationDebugDCUPath_W(Self: TJclBorRADToolInstallation; const T: TJclBorRADToolPath);
begin Self.DebugDCUPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationDebugDCUPath_R(Self: TJclBorRADToolInstallation; var T: TJclBorRADToolPath);
begin T := Self.DebugDCUPath; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationBPLOutputPath_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.BPLOutputPath; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationBinFolderName_R(Self: TJclBorRADToolInstallation; var T: string);
begin T := Self.BinFolderName; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationMake_R(Self: TJclBorRADToolInstallation; var T: IJclCommandLineTool);
begin T := Self.Make; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationBpr2Mak_R(Self: TJclBorRADToolInstallation; var T: TJclBpr2Mak);
begin T := Self.Bpr2Mak; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationDCC32_R(Self: TJclBorRADToolInstallation; var T: TJclDCC32);
begin T := Self.DCC32; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationBCC32_R(Self: TJclBorRADToolInstallation; var T: TJclBCC32);
begin T := Self.BCC32; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationCommandLineTools_R(Self: TJclBorRADToolInstallation; var T: TCommandLineTools);
begin T := Self.CommandLineTools; end;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationUnregisterExpert1_P(Self: TJclBorRADToolInstallation;  const ProjectName, OutputDir : string) : Boolean;
Begin Result := Self.UnregisterExpert(ProjectName, OutputDir); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationUnregisterExpert_P(Self: TJclBorRADToolInstallation;  const BinaryFileName : string) : Boolean;
Begin Result := Self.UnregisterExpert(BinaryFileName); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationRegisterExpert1_P(Self: TJclBorRADToolInstallation;  const ProjectName, OutputDir, Description : string) : Boolean;
Begin Result := Self.RegisterExpert(ProjectName, OutputDir, Description); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationRegisterExpert_P(Self: TJclBorRADToolInstallation;  const BinaryFileName, Description : string) : Boolean;
Begin Result := Self.RegisterExpert(BinaryFileName, Description); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationUnregisterIDEPackage1_P(Self: TJclBorRADToolInstallation;  const PackageName, BPLPath : string) : Boolean;
Begin Result := Self.UnregisterIDEPackage(PackageName, BPLPath); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationUnregisterIDEPackage_P(Self: TJclBorRADToolInstallation;  const BinaryFileName : string) : Boolean;
Begin Result := Self.UnregisterIDEPackage(BinaryFileName); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationRegisterIDEPackage1_P(Self: TJclBorRADToolInstallation;  const PackageName, BPLPath, Description : string) : Boolean;
Begin Result := Self.RegisterIDEPackage(PackageName, BPLPath, Description); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationRegisterIDEPackage_P(Self: TJclBorRADToolInstallation;  const BinaryFileName, Description : string) : Boolean;
Begin Result := Self.RegisterIDEPackage(BinaryFileName, Description); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationUnregisterPackage1_P(Self: TJclBorRADToolInstallation;  const PackageName, BPLPath : string) : Boolean;
Begin Result := Self.UnregisterPackage(PackageName, BPLPath); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationUnregisterPackage_P(Self: TJclBorRADToolInstallation;  const BinaryFileName : string) : Boolean;
Begin Result := Self.UnregisterPackage(BinaryFileName); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationRegisterPackage1_P(Self: TJclBorRADToolInstallation;  const PackageName, BPLPath, Description : string) : Boolean;
Begin Result := Self.RegisterPackage(PackageName, BPLPath, Description); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationRegisterPackage_P(Self: TJclBorRADToolInstallation;  const BinaryFileName, Description : string) : Boolean;
Begin Result := Self.RegisterPackage(BinaryFileName, Description); END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationCompileDelphiPackage1_P(Self: TJclBorRADToolInstallation;  const PackageName, BPLPath, DCPPath, ExtraOptions : string) : Boolean;
Begin //Result := Self.CompileDelphiPackage(PackageName, BPLPath, DCPPath, ExtraOptions);
END;

(*----------------------------------------------------------------------------*)
Function TJclBorRADToolInstallationCompileDelphiPackage_P(Self: TJclBorRADToolInstallation;  const PackageName, BPLPath, DCPPath : string) : Boolean;
Begin //Result := Self.CompileDelphiPackage(PackageName, BPLPath, DCPPath);
END;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolRepositoryPages_R(Self: TJclBorRADToolRepository; var T: TStrings);
begin T := Self.Pages; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolRepositoryIniFile_R(Self: TJclBorRADToolRepository; var T: TIniFile);
begin T := Self.IniFile; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolRepositoryFileName_R(Self: TJclBorRADToolRepository; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolPaletteTabNameCount_R(Self: TJclBorRADToolPalette; var T: Integer);
begin T := Self.TabNameCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolPaletteTabNames_R(Self: TJclBorRADToolPalette; var T: string; const t1: Integer);
begin T := Self.TabNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolPaletteKey_R(Self: TJclBorRADToolPalette; var T: string);
begin T := Self.Key; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolPaletteHiddenComponentsOnTab_R(Self: TJclBorRADToolPalette; var T: string; const t1: Integer);
begin T := Self.HiddenComponentsOnTab[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolPaletteComponentsOnTab_R(Self: TJclBorRADToolPalette; var T: string; const t1: Integer);
begin T := Self.ComponentsOnTab[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorlandCommandLineToolOptions_R(Self: TJclBorlandCommandLineTool; var T: TStrings);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorlandCommandLineToolOutputCallback_W(Self: TJclBorlandCommandLineTool; const T: TTextHandler);
begin Self.OutputCallback := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorlandCommandLineToolOutputCallback_R(Self: TJclBorlandCommandLineTool; var T: TTextHandler);
begin T := Self.OutputCallback; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorlandCommandLineToolOutput_R(Self: TJclBorlandCommandLineTool; var T: string);
begin T := Self.Output; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorlandCommandLineToolFileName_R(Self: TJclBorlandCommandLineTool; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdePackagesPackageDisabled_R(Self: TJclBorRADToolIdePackages; var T: Boolean; const t1: Integer);
begin T := Self.PackageDisabled[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdePackagesExpertFileNames_R(Self: TJclBorRADToolIdePackages; var T: string; const t1: Integer);
begin T := Self.ExpertFileNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdePackagesIDEPackageFileNames_R(Self: TJclBorRADToolIdePackages; var T: string; const t1: Integer);
begin T := Self.IDEPackageFileNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdePackagesPackageFileNames_R(Self: TJclBorRADToolIdePackages; var T: string; const t1: Integer);
begin T := Self.PackageFileNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdePackagesExpertDescriptions_R(Self: TJclBorRADToolIdePackages; var T: string; const t1: Integer);
begin T := Self.ExpertDescriptions[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdePackagesIDEPackageDescriptions_R(Self: TJclBorRADToolIdePackages; var T: string; const t1: Integer);
begin T := Self.IDEPackageDescriptions[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdePackagesPackageDescriptions_R(Self: TJclBorRADToolIdePackages; var T: string; const t1: Integer);
begin T := Self.PackageDescriptions[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdePackagesExpertCount_R(Self: TJclBorRADToolIdePackages; var T: Integer);
begin T := Self.ExpertCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdePackagesIDECount_R(Self: TJclBorRADToolIdePackages; var T: Integer);
begin T := Self.IDECount; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdePackagesCount_R(Self: TJclBorRADToolIdePackages; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdeToolWorkingDir_W(Self: TJclBorRADToolIdeTool; const T: string; const t1: Integer);
begin Self.WorkingDir[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdeToolWorkingDir_R(Self: TJclBorRADToolIdeTool; var T: string; const t1: Integer);
begin T := Self.WorkingDir[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdeToolParameters_W(Self: TJclBorRADToolIdeTool; const T: string; const t1: Integer);
begin Self.Parameters[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdeToolParameters_R(Self: TJclBorRADToolIdeTool; var T: string; const t1: Integer);
begin T := Self.Parameters[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdeToolPath_W(Self: TJclBorRADToolIdeTool; const T: string; const t1: Integer);
begin Self.Path[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdeToolPath_R(Self: TJclBorRADToolIdeTool; var T: string; const t1: Integer);
begin T := Self.Path[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdeToolTitle_W(Self: TJclBorRADToolIdeTool; const T: string; const t1: Integer);
begin Self.Title[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdeToolTitle_R(Self: TJclBorRADToolIdeTool; var T: string; const t1: Integer);
begin T := Self.Title[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdeToolKey_R(Self: TJclBorRADToolIdeTool; var T: string);
begin T := Self.Key; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdeToolCount_W(Self: TJclBorRADToolIdeTool; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolIdeToolCount_R(Self: TJclBorRADToolIdeTool; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclHelp2ManagerIdeNamespace_R(Self: TJclHelp2Manager; var T: WideString);
begin T := Self.IdeNamespace; end;

(*----------------------------------------------------------------------------*)
(*procedure TJclHelp2ManagerHxPlugin_R(Self: TJclHelp2Manager; var T: IHxPlugin);
begin T := Self.HxPlugin; end;
*)
(*----------------------------------------------------------------------------*)
//7procedure TJclHelp2ManagerHxRegister_R(Self: TJclHelp2Manager; var T: IHxRegister);
//7begin T := Self.HxRegister; end;

(*----------------------------------------------------------------------------*)
//procedure TJclHelp2ManagerHxRegisterSession_R(Self: TJclHelp2Manager; var T: IHxRegisterSession);
//begin T := Self.HxRegisterSession; end;

(*----------------------------------------------------------------------------*)
Function TJclHelp2ManagerCreate_P(Self: TClass; CreateNewInstance: Boolean;  AInstallation : TJclBorRADToolInstallation):TObject;
Begin //Result := TJclHelp2Manager.Create(AInstallation);
END;

(*----------------------------------------------------------------------------*)
procedure TJclBorlandOpenHelpProjectFileName_R(Self: TJclBorlandOpenHelp; var T: string);
begin T := Self.ProjectFileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorlandOpenHelpLinkFileName_R(Self: TJclBorlandOpenHelp; var T: string);
begin T := Self.LinkFileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorlandOpenHelpIndexFileName_R(Self: TJclBorlandOpenHelp; var T: string);
begin T := Self.IndexFileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorlandOpenHelpGidFileName_R(Self: TJclBorlandOpenHelp; var T: string);
begin T := Self.GidFileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorlandOpenHelpContentFileName_R(Self: TJclBorlandOpenHelp; var T: string);
begin T := Self.ContentFileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclBorRADToolInstallationObjectInstallation_R(Self: TJclBorRADToolInstallationObject; var T: TJclBorRADToolInstallation);
begin T := Self.Installation; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclBorlandTools_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@BPLFileName, 'BPLFileName', cdRegister);
 S.RegisterDelphiFunction(@BinaryFileName, 'BinaryFileName', cdRegister);
 S.RegisterDelphiFunction(@IsDelphiPackage, 'IsDelphiPackage', cdRegister);
 S.RegisterDelphiFunction(@IsDelphiProject, 'IsDelphiProject', cdRegister);
 S.RegisterDelphiFunction(@IsBCBPackage, 'IsBCBPackage', cdRegister);
 S.RegisterDelphiFunction(@IsBCBProject, 'IsBCBProject', cdRegister);
 S.RegisterDelphiFunction(@GetDPRFileInfo, 'GetDPRFileInfo', cdRegister);
 S.RegisterDelphiFunction(@GetBPRFileInfo, 'GetBPRFileInfo', cdRegister);
 S.RegisterDelphiFunction(@GetDPKFileInfo, 'GetDPKFileInfo', cdRegister);
 S.RegisterDelphiFunction(@GetBPKFileInfo, 'GetBPKFileInfo', cdRegister);
 S.RegisterDelphiFunction(@SamePath, 'SamePath', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBorRADToolInstallations(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBorRADToolInstallations) do
  begin
    RegisterConstructor(@TJclBorRADToolInstallations.Create, 'Create');
    RegisterMethod(@TJclBorRADToolInstallations.AnyInstanceRunning, 'AnyInstanceRunning');
    RegisterMethod(@TJclBorRADToolInstallations.AnyUpdatePackNeeded, 'AnyUpdatePackNeeded');
    RegisterMethod(@TJclBorRADToolInstallations.Iterate, 'Iterate');
    RegisterPropertyHelper(@TJclBorRADToolInstallationsCount_R,nil,'Count');
    RegisterPropertyHelper(@TJclBorRADToolInstallationsInstallations_R,nil,'Installations');
    RegisterPropertyHelper(@TJclBorRADToolInstallationsBCBInstallationFromVersion_R,nil,'BCBInstallationFromVersion');
    RegisterPropertyHelper(@TJclBorRADToolInstallationsDelphiInstallationFromVersion_R,nil,'DelphiInstallationFromVersion');
    RegisterPropertyHelper(@TJclBorRADToolInstallationsBDSInstallationFromVersion_R,nil,'BDSInstallationFromVersion');
    RegisterPropertyHelper(@TJclBorRADToolInstallationsBCBVersionInstalled_R,nil,'BCBVersionInstalled');
    RegisterPropertyHelper(@TJclBorRADToolInstallationsDelphiVersionInstalled_R,nil,'DelphiVersionInstalled');
    RegisterPropertyHelper(@TJclBorRADToolInstallationsBDSVersionInstalled_R,nil,'BDSVersionInstalled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBDSInstallation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBDSInstallation) do
  begin
    RegisterConstructor(@TJclBDSInstallation.Create, 'Create');
    RegisterMethod(@TJclBDSInstallation.PackageSourceFileExtension, 'PackageSourceFileExtension');
    RegisterMethod(@TJclBDSInstallation.ProjectSourceFileExtension, 'ProjectSourceFileExtension');
    RegisterMethod(@TJclBDSInstallation.RadToolKind, 'RadToolKind');
    RegisterMethod(@TJclBDSInstallation.GetLatestUpdatePackForVersion, 'GetLatestUpdatePackForVersion');
    RegisterMethod(@TJclBDSInstallation.GetDefaultProjectsDir, 'GetDefaultProjectsDir');
    RegisterMethod(@TJclBDSInstallation.GetCommonProjectsDir, 'GetCommonProjectsDir');
    RegisterMethod(@TJclBDSInstallation.GetDefaultProjectsDirectory, 'GetDefaultProjectsDirectory');
    RegisterMethod(@TJclBDSInstallation.GetCommonProjectsDirectory, 'GetCommonProjectsDirectory');
    RegisterMethod(@TJclBDSInstallation.AddToCppSearchPath, 'AddToCppSearchPath');
    RegisterMethod(@TJclBDSInstallation.AddToCppBrowsingPath, 'AddToCppBrowsingPath');
    RegisterMethod(@TJclBDSInstallation.AddToCppLibraryPath, 'AddToCppLibraryPath');
    RegisterMethod(@TJclBDSInstallation.RemoveFromCppSearchPath, 'RemoveFromCppSearchPath');
    RegisterMethod(@TJclBDSInstallation.RemoveFromCppBrowsingPath, 'RemoveFromCppBrowsingPath');
    RegisterMethod(@TJclBDSInstallation.RemoveFromCppLibraryPath, 'RemoveFromCppLibraryPath');
    RegisterPropertyHelper(@TJclBDSInstallationCppSearchPath_R,@TJclBDSInstallationCppSearchPath_W,'CppSearchPath');
    RegisterPropertyHelper(@TJclBDSInstallationCppBrowsingPath_R,@TJclBDSInstallationCppBrowsingPath_W,'CppBrowsingPath');
    RegisterPropertyHelper(@TJclBDSInstallationCppLibraryPath_R,@TJclBDSInstallationCppLibraryPath_W,'CppLibraryPath');
    RegisterMethod(@TJclBDSInstallation.CleanPackageCache, 'CleanPackageCache');
    RegisterMethod(@TJclBDSInstallation.CompileDelphiDotNetProject, 'CompileDelphiDotNetProject');
    RegisterPropertyHelper(@TJclBDSInstallationDualPackageInstallation_R,@TJclBDSInstallationDualPackageInstallation_W,'DualPackageInstallation');
    RegisterPropertyHelper(@TJclBDSInstallationHelp2Manager_R,nil,'Help2Manager');
    RegisterPropertyHelper(@TJclBDSInstallationDCCIL_R,nil,'DCCIL');
    RegisterPropertyHelper(@TJclBDSInstallationMaxDelphiCLRVersion_R,nil,'MaxDelphiCLRVersion');
    RegisterPropertyHelper(@TJclBDSInstallationPdbCreate_R,@TJclBDSInstallationPdbCreate_W,'PdbCreate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclDCCIL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclDCCIL) do
  begin
    RegisterMethod(@TJclDCCIL.MakeProject, 'MakeProject');
    RegisterPropertyHelper(@TJclDCCILMaxCLRVersion_R,nil,'MaxCLRVersion');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclDelphiInstallation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclDelphiInstallation) do
  begin
    RegisterMethod(@TJclDelphiInstallation.InstallPackage, 'InstallPackage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBCBInstallation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBCBInstallation) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBorRADToolInstallation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBorRADToolInstallation) do
  begin
    RegisterConstructor(@TJclBorRADToolInstallation.Create, 'Create');
    RegisterMethod(@TJclBorRADToolInstallation.Destroy, 'Free');
    RegisterMethod(@TJclBorRADToolInstallation.ExtractPaths, 'ExtractPaths');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.GetLatestUpdatePackForVersion, 'GetLatestUpdatePackForVersion');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.PackageSourceFileExtension, 'PackageSourceFileExtension');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.ProjectSourceFileExtension, 'ProjectSourceFileExtension');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.RadToolKind, 'RadToolKind');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.RadToolName, 'RadToolName');
    RegisterMethod(@TJclBorRADToolInstallation.AnyInstanceRunning, 'AnyInstanceRunning');
    RegisterMethod(@TJclBorRADToolInstallation.AddToDebugDCUPath, 'AddToDebugDCUPath');
    RegisterMethod(@TJclBorRADToolInstallation.AddToLibrarySearchPath, 'AddToLibrarySearchPath');
    RegisterMethod(@TJclBorRADToolInstallation.AddToLibraryBrowsingPath, 'AddToLibraryBrowsingPath');
    //RegisterVirtualMethod(@TJclBorRADToolInstallation.ConfigFileName, 'ConfigFileName');
    RegisterMethod(@TJclBorRADToolInstallation.FindFolderInPath, 'FindFolderInPath');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.CompilePackage, 'CompilePackage');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.InstallPackage, 'InstallPackage');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.UninstallPackage, 'UninstallPackage');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.InstallIDEPackage, 'InstallIDEPackage');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.UninstallIDEPackage, 'UninstallIDEPackage');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.CompileProject, 'CompileProject');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.InstallExpert, 'InstallExpert');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.UninstallExpert, 'UninstallExpert');
    RegisterVirtualMethod(@TJclBorRADToolInstallationRegisterPackage_P, 'RegisterPackage');
    RegisterVirtualMethod(@TJclBorRADToolInstallationRegisterPackage1_P, 'RegisterPackage1');
    RegisterVirtualMethod(@TJclBorRADToolInstallationUnregisterPackage_P, 'UnregisterPackage');
    RegisterVirtualMethod(@TJclBorRADToolInstallationUnregisterPackage1_P, 'UnregisterPackage1');
    RegisterVirtualMethod(@TJclBorRADToolInstallationRegisterIDEPackage_P, 'RegisterIDEPackage');
    RegisterVirtualMethod(@TJclBorRADToolInstallationRegisterIDEPackage1_P, 'RegisterIDEPackage1');
    RegisterVirtualMethod(@TJclBorRADToolInstallationUnregisterIDEPackage_P, 'UnregisterIDEPackage');
    RegisterVirtualMethod(@TJclBorRADToolInstallationUnregisterIDEPackage1_P, 'UnregisterIDEPackage1');
    RegisterVirtualMethod(@TJclBorRADToolInstallationRegisterExpert_P, 'RegisterExpert');
    RegisterVirtualMethod(@TJclBorRADToolInstallationRegisterExpert1_P, 'RegisterExpert1');
    RegisterVirtualMethod(@TJclBorRADToolInstallationUnregisterExpert_P, 'UnregisterExpert');
    RegisterVirtualMethod(@TJclBorRADToolInstallationUnregisterExpert1_P, 'UnregisterExpert1');
    //RegisterMethod(@TJclBorRADToolInstallation.IsBDSPersonality, 'IsBDSPersonality');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.GetDefaultProjectsDir, 'GetDefaultProjectsDir');
    RegisterVirtualMethod(@TJclBorRADToolInstallation.GetCommonProjectsDir, 'GetCommonProjectsDir');
    RegisterMethod(@TJclBorRADToolInstallation.RemoveFromDebugDCUPath, 'RemoveFromDebugDCUPath');
    RegisterMethod(@TJclBorRADToolInstallation.RemoveFromLibrarySearchPath, 'RemoveFromLibrarySearchPath');
    RegisterMethod(@TJclBorRADToolInstallation.RemoveFromLibraryBrowsingPath, 'RemoveFromLibraryBrowsingPath');
    RegisterMethod(@TJclBorRADToolInstallation.SubstitutePath, 'SubstitutePath');
    //RegisterMethod(@TJclBorRADToolInstallation.SupportsBCB, 'SupportsBCB');
    RegisterMethod(@TJclBorRADToolInstallation.SupportsVisualCLX, 'SupportsVisualCLX');
    RegisterMethod(@TJclBorRADToolInstallation.SupportsVCL, 'SupportsVCL');
    RegisterMethod(@TJclBorRADToolInstallation.LibFolderName, 'LibFolderName');
    RegisterMethod(@TJclBorRADToolInstallation.ObjFolderName, 'ObjFolderName');
    RegisterPropertyHelper(@TJclBorRADToolInstallationCommandLineTools_R,nil,'CommandLineTools');
    RegisterPropertyHelper(@TJclBorRADToolInstallationBCC32_R,nil,'BCC32');
    RegisterPropertyHelper(@TJclBorRADToolInstallationDCC32_R,nil,'DCC32');
    RegisterPropertyHelper(@TJclBorRADToolInstallationBpr2Mak_R,nil,'Bpr2Mak');
    RegisterPropertyHelper(@TJclBorRADToolInstallationMake_R,nil,'Make');
    RegisterPropertyHelper(@TJclBorRADToolInstallationBinFolderName_R,nil,'BinFolderName');
    RegisterPropertyHelper(@TJclBorRADToolInstallationBPLOutputPath_R,nil,'BPLOutputPath');
    RegisterPropertyHelper(@TJclBorRADToolInstallationDebugDCUPath_R,@TJclBorRADToolInstallationDebugDCUPath_W,'DebugDCUPath');
    RegisterPropertyHelper(@TJclBorRADToolInstallationDCPOutputPath_R,nil,'DCPOutputPath');
    RegisterPropertyHelper(@TJclBorRADToolInstallationDefaultProjectsDir_R,nil,'DefaultProjectsDir');
    RegisterPropertyHelper(@TJclBorRADToolInstallationCommonProjectsDir_R,nil,'CommonProjectsDir');
    RegisterPropertyHelper(@TJclBorRADToolInstallationDescription_R,nil,'Description');
    RegisterPropertyHelper(@TJclBorRADToolInstallationEdition_R,nil,'Edition');
    RegisterPropertyHelper(@TJclBorRADToolInstallationEditionAsText_R,nil,'EditionAsText');
    RegisterPropertyHelper(@TJclBorRADToolInstallationEnvironmentVariables_R,nil,'EnvironmentVariables');
    RegisterPropertyHelper(@TJclBorRADToolInstallationIdePackages_R,nil,'IdePackages');
    RegisterPropertyHelper(@TJclBorRADToolInstallationIdeTools_R,nil,'IdeTools');
    RegisterPropertyHelper(@TJclBorRADToolInstallationIdeExeBuildNumber_R,nil,'IdeExeBuildNumber');
    RegisterPropertyHelper(@TJclBorRADToolInstallationIdeExeFileName_R,nil,'IdeExeFileName');
    RegisterPropertyHelper(@TJclBorRADToolInstallationInstalledUpdatePack_R,nil,'InstalledUpdatePack');
    RegisterPropertyHelper(@TJclBorRADToolInstallationLatestUpdatePack_R,nil,'LatestUpdatePack');
    RegisterPropertyHelper(@TJclBorRADToolInstallationLibrarySearchPath_R,@TJclBorRADToolInstallationLibrarySearchPath_W,'LibrarySearchPath');
    RegisterPropertyHelper(@TJclBorRADToolInstallationLibraryBrowsingPath_R,@TJclBorRADToolInstallationLibraryBrowsingPath_W,'LibraryBrowsingPath');
    RegisterPropertyHelper(@TJclBorRADToolInstallationOpenHelp_R,nil,'OpenHelp');
    RegisterPropertyHelper(@TJclBorRADToolInstallationMapCreate_R,@TJclBorRADToolInstallationMapCreate_W,'MapCreate');
    RegisterPropertyHelper(@TJclBorRADToolInstallationJdbgCreate_R,@TJclBorRADToolInstallationJdbgCreate_W,'JdbgCreate');
    RegisterPropertyHelper(@TJclBorRADToolInstallationJdbgInsert_R,@TJclBorRADToolInstallationJdbgInsert_W,'JdbgInsert');
    RegisterPropertyHelper(@TJclBorRADToolInstallationMapDelete_R,@TJclBorRADToolInstallationMapDelete_W,'MapDelete');
    RegisterPropertyHelper(@TJclBorRADToolInstallationConfigData_R,nil,'ConfigData');
    RegisterPropertyHelper(@TJclBorRADToolInstallationConfigDataLocation_R,nil,'ConfigDataLocation');
    RegisterPropertyHelper(@TJclBorRADToolInstallationGlobals_R,nil,'Globals');
    RegisterPropertyHelper(@TJclBorRADToolInstallationName_R,nil,'Name');
    RegisterPropertyHelper(@TJclBorRADToolInstallationPalette_R,nil,'Palette');
    RegisterPropertyHelper(@TJclBorRADToolInstallationRepository_R,nil,'Repository');
    RegisterPropertyHelper(@TJclBorRADToolInstallationRootDir_R,nil,'RootDir');
    RegisterPropertyHelper(@TJclBorRADToolInstallationUpdateNeeded_R,nil,'UpdateNeeded');
    RegisterPropertyHelper(@TJclBorRADToolInstallationValid_R,nil,'Valid');
    RegisterPropertyHelper(@TJclBorRADToolInstallationVclIncludeDir_R,nil,'VclIncludeDir');
    RegisterPropertyHelper(@TJclBorRADToolInstallationIDEVersionNumber_R,nil,'IDEVersionNumber');
    RegisterPropertyHelper(@TJclBorRADToolInstallationIDEVersionNumberStr_R,nil,'IDEVersionNumberStr');
    RegisterPropertyHelper(@TJclBorRADToolInstallationVersionNumber_R,nil,'VersionNumber');
    RegisterPropertyHelper(@TJclBorRADToolInstallationVersionNumberStr_R,nil,'VersionNumberStr');
    RegisterPropertyHelper(@TJclBorRADToolInstallationPersonalities_R,nil,'Personalities');
    RegisterPropertyHelper(@TJclBorRADToolInstallationDCC_R,nil,'DCC');
    RegisterPropertyHelper(@TJclBorRADToolInstallationSupportsLibSuffix_R,nil,'SupportsLibSuffix');
    RegisterPropertyHelper(@TJclBorRADToolInstallationOutputCallback_R,@TJclBorRADToolInstallationOutputCallback_W,'OutputCallback');
    RegisterPropertyHelper(@TJclBorRADToolInstallationIsTurboExplorer_R,nil,'IsTurboExplorer');
    RegisterPropertyHelper(@TJclBorRADToolInstallationRootKey_R,nil,'RootKey');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBorRADToolRepository(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBorRADToolRepository) do begin
    RegisterMethod(@TJclBorRADToolRepository.Destroy, 'Free');
    RegisterMethod(@TJclBorRADToolRepository.AddObject, 'AddObject');
    RegisterMethod(@TJclBorRADToolRepository.CloseIniFile, 'CloseIniFile');
    RegisterMethod(@TJclBorRADToolRepository.FindPage, 'FindPage');
    RegisterMethod(@TJclBorRADToolRepository.RemoveObjects, 'RemoveObjects');
    RegisterPropertyHelper(@TJclBorRADToolRepositoryFileName_R,nil,'FileName');
    RegisterPropertyHelper(@TJclBorRADToolRepositoryIniFile_R,nil,'IniFile');
    RegisterPropertyHelper(@TJclBorRADToolRepositoryPages_R,nil,'Pages');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBorRADToolPalette(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBorRADToolPalette) do
  begin
  RegisterMethod(@TJclBorRADToolPalette.Destroy, 'Free');
    RegisterMethod(@TJclBorRADToolPalette.ComponentsOnTabToStrings, 'ComponentsOnTabToStrings');
    RegisterMethod(@TJclBorRADToolPalette.DeleteTabName, 'DeleteTabName');
    RegisterMethod(@TJclBorRADToolPalette.TabNameExists, 'TabNameExists');
    RegisterPropertyHelper(@TJclBorRADToolPaletteComponentsOnTab_R,nil,'ComponentsOnTab');
    RegisterPropertyHelper(@TJclBorRADToolPaletteHiddenComponentsOnTab_R,nil,'HiddenComponentsOnTab');
    RegisterPropertyHelper(@TJclBorRADToolPaletteKey_R,nil,'Key');
    RegisterPropertyHelper(@TJclBorRADToolPaletteTabNames_R,nil,'TabNames');
    RegisterPropertyHelper(@TJclBorRADToolPaletteTabNameCount_R,nil,'TabNameCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBorlandMake(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBorlandMake) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBpr2Mak(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBpr2Mak) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclDCC32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclDCC32) do
  begin
    RegisterMethod(@TJclDCC32.MakePackage, 'MakePackage');
    RegisterMethod(@TJclDCC32.MakeProject, 'MakeProject');
    RegisterVirtualMethod(@TJclDCC32.SetDefaultOptions, 'SetDefaultOptions');
   // RegisterMethod(@TJclDCC32.SupportsLibSuffix, 'SupportsLibSuffix');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBCC32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBCC32) do
  begin
    //RegisterMethod(@TJclBCC32.SupportsLibSuffix, 'SupportsLibSuffix');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBorlandCommandLineTool(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBorlandCommandLineTool) do
  begin
    RegisterMethod(@TJclBorlandCommandLineTool.Destroy, 'Free');
    RegisterMethod(@TJclBorlandCommandLineTool.AddPathOption, 'AddPathOption');
    RegisterVirtualMethod(@TJclBorlandCommandLineTool.Execute, 'Execute');
    RegisterPropertyHelper(@TJclBorlandCommandLineToolFileName_R,nil,'FileName');
    RegisterPropertyHelper(@TJclBorlandCommandLineToolOutput_R,nil,'Output');
    RegisterPropertyHelper(@TJclBorlandCommandLineToolOutputCallback_R,@TJclBorlandCommandLineToolOutputCallback_W,'OutputCallback');
    RegisterPropertyHelper(@TJclBorlandCommandLineToolOptions_R,nil,'Options');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclCommandLineTool(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclCommandLineTool) do begin
    RegisterMethod(@TJclCommandLineTool.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBorRADToolIdePackages(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBorRADToolIdePackages) do
  begin
    RegisterMethod(@TJclBorRADToolIdePackages.AddPackage, 'AddPackage');
    RegisterMethod(@TJclBorRADToolIdePackages.Destroy, 'Free');
    RegisterMethod(@TJclBorRADToolIdePackages.AddIDEPackage, 'AddIDEPackage');
    RegisterMethod(@TJclBorRADToolIdePackages.AddExpert, 'AddExpert');
    RegisterMethod(@TJclBorRADToolIdePackages.RemovePackage, 'RemovePackage');
    RegisterMethod(@TJclBorRADToolIdePackages.RemoveIDEPackage, 'RemoveIDEPackage');
    RegisterMethod(@TJclBorRADToolIdePackages.RemoveExpert, 'RemoveExpert');
    RegisterPropertyHelper(@TJclBorRADToolIdePackagesCount_R,nil,'Count');
    RegisterPropertyHelper(@TJclBorRADToolIdePackagesIDECount_R,nil,'IDECount');
    RegisterPropertyHelper(@TJclBorRADToolIdePackagesExpertCount_R,nil,'ExpertCount');
    RegisterPropertyHelper(@TJclBorRADToolIdePackagesPackageDescriptions_R,nil,'PackageDescriptions');
    RegisterPropertyHelper(@TJclBorRADToolIdePackagesIDEPackageDescriptions_R,nil,'IDEPackageDescriptions');
    RegisterPropertyHelper(@TJclBorRADToolIdePackagesExpertDescriptions_R,nil,'ExpertDescriptions');
    RegisterPropertyHelper(@TJclBorRADToolIdePackagesPackageFileNames_R,nil,'PackageFileNames');
    RegisterPropertyHelper(@TJclBorRADToolIdePackagesIDEPackageFileNames_R,nil,'IDEPackageFileNames');
    RegisterPropertyHelper(@TJclBorRADToolIdePackagesExpertFileNames_R,nil,'ExpertFileNames');
    RegisterPropertyHelper(@TJclBorRADToolIdePackagesPackageDisabled_R,nil,'PackageDisabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBorRADToolIdeTool(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBorRADToolIdeTool) do
  begin
    RegisterPropertyHelper(@TJclBorRADToolIdeToolCount_R,@TJclBorRADToolIdeToolCount_W,'Count');
    RegisterMethod(@TJclBorRADToolIdeTool.IndexOfPath, 'IndexOfPath');
    RegisterMethod(@TJclBorRADToolIdeTool.IndexOfTitle, 'IndexOfTitle');
    RegisterMethod(@TJclBorRADToolIdeTool.RemoveIndex, 'RemoveIndex');
    RegisterPropertyHelper(@TJclBorRADToolIdeToolKey_R,nil,'Key');
    RegisterPropertyHelper(@TJclBorRADToolIdeToolTitle_R,@TJclBorRADToolIdeToolTitle_W,'Title');
    RegisterPropertyHelper(@TJclBorRADToolIdeToolPath_R,@TJclBorRADToolIdeToolPath_W,'Path');
    RegisterPropertyHelper(@TJclBorRADToolIdeToolParameters_R,@TJclBorRADToolIdeToolParameters_W,'Parameters');
    RegisterPropertyHelper(@TJclBorRADToolIdeToolWorkingDir_R,@TJclBorRADToolIdeToolWorkingDir_W,'WorkingDir');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclHelp2Manager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclHelp2Manager) do
  begin
    RegisterConstructor(@TJclHelp2Manager.Create, 'Create');
    RegisterMethod(@TJclHelp2Manager.Destroy, 'Free');
    RegisterMethod(@TJclHelp2Manager.CreateTransaction, 'CreateTransaction');
    RegisterMethod(@TJclHelp2Manager.CommitTransaction, 'CommitTransaction');
    RegisterMethod(@TJclHelp2Manager.RegisterNameSpace, 'RegisterNameSpace');
    RegisterMethod(@TJclHelp2Manager.UnregisterNameSpace, 'UnregisterNameSpace');
    RegisterMethod(@TJclHelp2Manager.RegisterHelpFile, 'RegisterHelpFile');
    RegisterMethod(@TJclHelp2Manager.UnregisterHelpFile, 'UnregisterHelpFile');
    RegisterMethod(@TJclHelp2Manager.PlugNameSpaceIn, 'PlugNameSpaceIn');
    RegisterMethod(@TJclHelp2Manager.UnPlugNameSpace, 'UnPlugNameSpace');
    RegisterMethod(@TJclHelp2Manager.PlugNameSpaceInBorlandHelp, 'PlugNameSpaceInBorlandHelp');
    RegisterMethod(@TJclHelp2Manager.UnPlugNameSpaceFromBorlandHelp, 'UnPlugNameSpaceFromBorlandHelp');
    //RegisterPropertyHelper(@TJclHelp2ManagerHxRegisterSession_R,nil,'HxRegisterSession');
    //RegisterPropertyHelper(@TJclHelp2ManagerHxRegister_R,nil,'HxRegister');
    //RegisterPropertyHelper(@TJclHelp2ManagerHxPlugin_R,nil,'HxPlugin');
    RegisterPropertyHelper(@TJclHelp2ManagerIdeNamespace_R,nil,'IdeNamespace');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBorlandOpenHelp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBorlandOpenHelp) do
  begin
    RegisterMethod(@TJclBorlandOpenHelp.AddHelpFile, 'AddHelpFile');
    RegisterMethod(@TJclBorlandOpenHelp.RemoveHelpFile, 'RemoveHelpFile');
    RegisterPropertyHelper(@TJclBorlandOpenHelpContentFileName_R,nil,'ContentFileName');
    RegisterPropertyHelper(@TJclBorlandOpenHelpGidFileName_R,nil,'GidFileName');
    RegisterPropertyHelper(@TJclBorlandOpenHelpIndexFileName_R,nil,'IndexFileName');
    RegisterPropertyHelper(@TJclBorlandOpenHelpLinkFileName_R,nil,'LinkFileName');
    RegisterPropertyHelper(@TJclBorlandOpenHelpProjectFileName_R,nil,'ProjectFileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBorRADToolInstallationObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBorRADToolInstallationObject) do
  begin
    RegisterPropertyHelper(@TJclBorRADToolInstallationObjectInstallation_R,nil,'Installation');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclBorlandTools(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclBorRADException) do
  with CL.Add(TJclBorRADToolInstallation) do
  RIRegister_TJclBorRADToolInstallationObject(CL);
  RIRegister_TJclBorlandOpenHelp(CL);
  RIRegister_TJclHelp2Manager(CL);
  RIRegister_TJclBorRADToolIdeTool(CL);
  RIRegister_TJclBorRADToolIdePackages(CL);
  with CL.Add(EJclCommandLineToolError) do
  RIRegister_TJclCommandLineTool(CL);
  RIRegister_TJclBorlandCommandLineTool(CL);
  RIRegister_TJclBCC32(CL);
  RIRegister_TJclDCC32(CL);
  RIRegister_TJclBpr2Mak(CL);
  RIRegister_TJclBorlandMake(CL);
  RIRegister_TJclBorRADToolPalette(CL);
  RIRegister_TJclBorRADToolRepository(CL);
  RIRegister_TJclBorRADToolInstallation(CL);
  RIRegister_TJclBCBInstallation(CL);
  RIRegister_TJclDelphiInstallation(CL);
  RIRegister_TJclDCCIL(CL);
  RIRegister_TJclBDSInstallation(CL);
  RIRegister_TJclBorRADToolInstallations(CL);
end;

 
 
{ TPSImport_JclBorlandTools }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclBorlandTools.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclBorlandTools(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclBorlandTools.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclBorlandTools_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
