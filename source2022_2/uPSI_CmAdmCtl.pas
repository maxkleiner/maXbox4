unit uPSI_CmAdmCtl;
{
  also in xrtl
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
  TPSImport_CmAdmCtl = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCOMAdminCatalogCollection(CL: TPSPascalCompiler);
procedure SIRegister_CoCOMAdminCatalogCollection(CL: TPSPascalCompiler);
procedure SIRegister_TCOMAdminCatalogObject(CL: TPSPascalCompiler);
procedure SIRegister_CoCOMAdminCatalogObject(CL: TPSPascalCompiler);
procedure SIRegister_TCOMAdminCatalog(CL: TPSPascalCompiler);
procedure SIRegister_CoCOMAdminCatalog(CL: TPSPascalCompiler);
procedure SIRegister_CmAdmCtl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCOMAdminCatalogCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoCOMAdminCatalogCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCOMAdminCatalogObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoCOMAdminCatalogObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCOMAdminCatalog(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoCOMAdminCatalog(CL: TPSRuntimeClassImporter);
procedure RIRegister_CmAdmCtl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ActiveX
  ,Graphics
  ,OleServer
  ,OleCtrls
  ,StdVCL
  ,COMAdmin
  ,CmAdmCtl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CmAdmCtl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCOMAdminCatalogCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TCOMAdminCatalogCollection') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TCOMAdminCatalogCollection') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure ConnectTo( svrIntf : ICatalogCollection)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Function Get_Item( lIndex : Integer) : TCOMAdminCatalogObject');
    RegisterMethod('Function Get_Count : Integer');
    RegisterMethod('Procedure Remove( lIndex : Integer)');
    RegisterMethod('Function Add : TCOMAdminCatalogObject');
    RegisterMethod('Procedure Populate');
    RegisterMethod('Function SaveChanges : Integer');
    RegisterMethod('Function GetCollection( const bstrCollName : WideString; varObjectKey : OleVariant) : TCOMAdminCatalogCollection');
    RegisterMethod('Function Get_Name : OleVariant');
    RegisterMethod('Function Get_AddEnabled : WordBool');
    RegisterMethod('Function Get_RemoveEnabled : WordBool');
    RegisterMethod('Function GetUtilInterface : IDispatch');
    RegisterMethod('Function Get_DataStoreMajorVersion : Integer');
    RegisterMethod('Function Get_DataStoreMinorVersion : Integer');
    RegisterMethod('Procedure PopulateByKey( aKeys : PSafeArray)');
    RegisterMethod('Procedure PopulateByQuery( const bstrQueryString : WideString; lQueryType : Integer)');
    RegisterProperty('DefaultInterface', 'ICatalogCollection', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Name', 'OleVariant', iptr);
    RegisterProperty('AddEnabled', 'WordBool', iptr);
    RegisterProperty('RemoveEnabled', 'WordBool', iptr);
    RegisterProperty('DataStoreMajorVersion', 'Integer', iptr);
    RegisterProperty('DataStoreMinorVersion', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoCOMAdminCatalogCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoCOMAdminCatalogCollection') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoCOMAdminCatalogCollection') do begin
    RegisterMethod('Function Create : ICatalogCollection');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCOMAdminCatalogObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TCOMAdminCatalogObject') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TCOMAdminCatalogObject') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure ConnectTo( svrIntf : ICatalogObject)');
    RegisterMethod('Function Get_Value( const bstrPropName : WideString) : OleVariant');
    RegisterMethod('Procedure Set_Value( const bstrPropName : WideString; retval : OleVariant)');
    RegisterMethod('Function Get_Key : OleVariant');
    RegisterMethod('Function Get_Name : OleVariant');
    RegisterMethod('Function IsPropertyReadOnly( const bstrPropName : WideString) : WordBool');
    RegisterMethod('Function Get_Valid : WordBool');
    RegisterMethod('Function IsPropertyWriteOnly( const bstrPropName : WideString) : WordBool');
    RegisterProperty('Value', 'OleVariant WideString', iptrw);
    RegisterProperty('DefaultInterface', 'ICatalogObject', iptr);
    RegisterProperty('Key', 'OleVariant', iptr);
    RegisterProperty('Name', 'OleVariant', iptr);
    RegisterProperty('Valid', 'WordBool', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoCOMAdminCatalogObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoCOMAdminCatalogObject') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoCOMAdminCatalogObject') do begin
    RegisterMethod('Function Create : ICatalogObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCOMAdminCatalog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TCOMAdminCatalog') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TCOMAdminCatalog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure ConnectTo( svrIntf : ICOMAdminCatalog)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Function GetCollection( const bstrCollName : WideString) : TCOMAdminCatalogCollection');
    RegisterMethod('Function ICOMAdminCatalog_Connect( const bstrConnectString : WideString) : TCOMAdminCatalogCollection');
    RegisterMethod('Function Get_MajorVersion : Integer');
    RegisterMethod('Function Get_MinorVersion : Integer');
    RegisterMethod('Function GetCollectionByQuery( const bstrCollName : WideString; var aQuery : PSafeArray) : TCOMAdminCatalogCollection');
    RegisterMethod('Procedure ImportComponent( const bstrApplIdOrName : WideString; const bstrCLSIDOrProgId : WideString)');
    RegisterMethod('Procedure InstallComponent( const bstrApplIdOrName : WideString; const bstrDLL : WideString; const bstrTLB : WideString; const bstrPSDLL : WideString)');
    RegisterMethod('Procedure ShutdownApplication( const bstrApplIdOrName : WideString)');
    RegisterMethod('Procedure ExportApplication( const bstrApplIdOrName : WideString; const bstrApplicationFile : WideString; lOptions : Integer)');
    RegisterMethod('Procedure InstallApplication( const bstrApplicationFile : WideString; const bstrDestinationDirectory : WideString; lOptions : Integer; const bstrUserId : WideString; const bstrPassword : WideString; const bstrRSN : WideString)');
    RegisterMethod('Procedure StopRouter');
    RegisterMethod('Procedure RefreshRouter');
    RegisterMethod('Procedure StartRouter');
    RegisterMethod('Procedure InstallMultipleComponents( const bstrApplIdOrName : WideString; var varFileNames : PSafeArray; var varCLSIDS : PSafeArray)');
    RegisterMethod('Procedure GetMultipleComponentsInfo( const bstrApplIdOrName : WideString; var varFileNames : PSafeArray; out varCLSIDS : PSafeArray; out varClassNames : PSafeArray; out varFileFlags : PSafeArray; out varComponentFlags : PSafeArray)');
    RegisterMethod('Procedure RefreshComponents');
    RegisterMethod('Procedure BackupREGDB( const bstrBackupFilePath : WideString)');
    RegisterMethod('Procedure RestoreREGDB( const bstrBackupFilePath : WideString)');
    RegisterMethod('Procedure QueryApplicationFile( const bstrApplicationFile : WideString; out bstrApplicationName : WideString; out bstrApplicationDescription : WideString; out bHasUsers : WordBool; out bIsProxy : WordBool; out varFileNames : PSafeArray)');
    RegisterMethod('Procedure StartApplication( const bstrApplIdOrName : WideString)');
    RegisterMethod('Function ServiceCheck( lService : Integer) : Integer');
    RegisterMethod('Procedure InstallMultipleEventClasses( const bstrApplIdOrName : WideString; var varFileNames : PSafeArray; var varCLSIDS : PSafeArray)');
    RegisterMethod('Procedure InstallEventClass( const bstrApplIdOrName : WideString; const bstrDLL : WideString; const bstrTLB : WideString; const bstrPSDLL : WideString)');
    RegisterMethod('Procedure GetEventClassesForIID( const bstrIID : WideString; out varCLSIDS : PSafeArray; out varProgIDs : PSafeArray; out varDescriptions : PSafeArray)');
    RegisterProperty('DefaultInterface', 'ICOMAdminCatalog', iptr);
    RegisterProperty('MajorVersion', 'Integer', iptr);
    RegisterProperty('MinorVersion', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoCOMAdminCatalog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoCOMAdminCatalog') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoCOMAdminCatalog') do begin
    RegisterMethod('Function Create : ICOMAdminCatalog');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CmAdmCtl(CL: TPSPascalCompiler);
begin
  SIRegister_CoCOMAdminCatalog(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCOMAdminCatalogCollection');
  SIRegister_TCOMAdminCatalog(CL);
  SIRegister_CoCOMAdminCatalogObject(CL);
  SIRegister_TCOMAdminCatalogObject(CL);
  SIRegister_CoCOMAdminCatalogCollection(CL);
  SIRegister_TCOMAdminCatalogCollection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogCollectionDataStoreMinorVersion_R(Self: TCOMAdminCatalogCollection; var T: Integer);
begin T := Self.DataStoreMinorVersion; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogCollectionDataStoreMajorVersion_R(Self: TCOMAdminCatalogCollection; var T: Integer);
begin T := Self.DataStoreMajorVersion; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogCollectionRemoveEnabled_R(Self: TCOMAdminCatalogCollection; var T: WordBool);
begin T := Self.RemoveEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogCollectionAddEnabled_R(Self: TCOMAdminCatalogCollection; var T: WordBool);
begin T := Self.AddEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogCollectionName_R(Self: TCOMAdminCatalogCollection; var T: OleVariant);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogCollectionCount_R(Self: TCOMAdminCatalogCollection; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogCollectionDefaultInterface_R(Self: TCOMAdminCatalogCollection; var T: ICatalogCollection);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogObjectValid_R(Self: TCOMAdminCatalogObject; var T: WordBool);
begin T := Self.Valid; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogObjectName_R(Self: TCOMAdminCatalogObject; var T: OleVariant);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogObjectKey_R(Self: TCOMAdminCatalogObject; var T: OleVariant);
begin T := Self.Key; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogObjectDefaultInterface_R(Self: TCOMAdminCatalogObject; var T: ICatalogObject);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogObjectValue_W(Self: TCOMAdminCatalogObject; const T: OleVariant; const t1: WideString);
begin Self.Value[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogObjectValue_R(Self: TCOMAdminCatalogObject; var T: OleVariant; const t1: WideString);
begin T := Self.Value[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogMinorVersion_R(Self: TCOMAdminCatalog; var T: Integer);
begin T := Self.MinorVersion; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogMajorVersion_R(Self: TCOMAdminCatalog; var T: Integer);
begin T := Self.MajorVersion; end;

(*----------------------------------------------------------------------------*)
procedure TCOMAdminCatalogDefaultInterface_R(Self: TCOMAdminCatalog; var T: ICOMAdminCatalog);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCOMAdminCatalogCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCOMAdminCatalogCollection) do begin
    RegisterConstructor(@TCOMAdminCatalogCollection.Create, 'Create');
    RegisterMethod(@TCOMAdminCatalogCollection.Connect, 'Connect');
    RegisterMethod(@TCOMAdminCatalogCollection.ConnectTo, 'ConnectTo');
    RegisterMethod(@TCOMAdminCatalogCollection.Disconnect, 'Disconnect');
    RegisterMethod(@TCOMAdminCatalogCollection.Get_Item, 'Get_Item');
    RegisterMethod(@TCOMAdminCatalogCollection.Get_Count, 'Get_Count');
    RegisterMethod(@TCOMAdminCatalogCollection.Remove, 'Remove');
    RegisterMethod(@TCOMAdminCatalogCollection.Add, 'Add');
    RegisterMethod(@TCOMAdminCatalogCollection.Populate, 'Populate');
    RegisterMethod(@TCOMAdminCatalogCollection.SaveChanges, 'SaveChanges');
    RegisterMethod(@TCOMAdminCatalogCollection.GetCollection, 'GetCollection');
    RegisterMethod(@TCOMAdminCatalogCollection.Get_Name, 'Get_Name');
    RegisterMethod(@TCOMAdminCatalogCollection.Get_AddEnabled, 'Get_AddEnabled');
    RegisterMethod(@TCOMAdminCatalogCollection.Get_RemoveEnabled, 'Get_RemoveEnabled');
    RegisterMethod(@TCOMAdminCatalogCollection.GetUtilInterface, 'GetUtilInterface');
    RegisterMethod(@TCOMAdminCatalogCollection.Get_DataStoreMajorVersion, 'Get_DataStoreMajorVersion');
    RegisterMethod(@TCOMAdminCatalogCollection.Get_DataStoreMinorVersion, 'Get_DataStoreMinorVersion');
    RegisterMethod(@TCOMAdminCatalogCollection.PopulateByKey, 'PopulateByKey');
    RegisterMethod(@TCOMAdminCatalogCollection.PopulateByQuery, 'PopulateByQuery');
    RegisterPropertyHelper(@TCOMAdminCatalogCollectionDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TCOMAdminCatalogCollectionCount_R,nil,'Count');
    RegisterPropertyHelper(@TCOMAdminCatalogCollectionName_R,nil,'Name');
    RegisterPropertyHelper(@TCOMAdminCatalogCollectionAddEnabled_R,nil,'AddEnabled');
    RegisterPropertyHelper(@TCOMAdminCatalogCollectionRemoveEnabled_R,nil,'RemoveEnabled');
    RegisterPropertyHelper(@TCOMAdminCatalogCollectionDataStoreMajorVersion_R,nil,'DataStoreMajorVersion');
    RegisterPropertyHelper(@TCOMAdminCatalogCollectionDataStoreMinorVersion_R,nil,'DataStoreMinorVersion');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoCOMAdminCatalogCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoCOMAdminCatalogCollection) do begin
    RegisterMethod(@CoCOMAdminCatalogCollection.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCOMAdminCatalogObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCOMAdminCatalogObject) do begin
    RegisterConstructor(@TCOMAdminCatalogObject.Create, 'Create');
    RegisterMethod(@TCOMAdminCatalogObject.ConnectTo, 'ConnectTo');
    RegisterMethod(@TCOMAdminCatalogObject.Get_Value, 'Get_Value');
    RegisterMethod(@TCOMAdminCatalogObject.Set_Value, 'Set_Value');
    RegisterMethod(@TCOMAdminCatalogObject.Get_Key, 'Get_Key');
    RegisterMethod(@TCOMAdminCatalogObject.Get_Name, 'Get_Name');
    RegisterMethod(@TCOMAdminCatalogObject.IsPropertyReadOnly, 'IsPropertyReadOnly');
    RegisterMethod(@TCOMAdminCatalogObject.Get_Valid, 'Get_Valid');
    RegisterMethod(@TCOMAdminCatalogObject.IsPropertyWriteOnly, 'IsPropertyWriteOnly');
    RegisterPropertyHelper(@TCOMAdminCatalogObjectValue_R,@TCOMAdminCatalogObjectValue_W,'Value');
    RegisterPropertyHelper(@TCOMAdminCatalogObjectDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TCOMAdminCatalogObjectKey_R,nil,'Key');
    RegisterPropertyHelper(@TCOMAdminCatalogObjectName_R,nil,'Name');
    RegisterPropertyHelper(@TCOMAdminCatalogObjectValid_R,nil,'Valid');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoCOMAdminCatalogObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoCOMAdminCatalogObject) do begin
    RegisterMethod(@CoCOMAdminCatalogObject.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCOMAdminCatalog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCOMAdminCatalog) do begin
    RegisterConstructor(@TCOMAdminCatalog.Create, 'Create');
    RegisterMethod(@TCOMAdminCatalog.Connect, 'Connect');
    RegisterMethod(@TCOMAdminCatalog.ConnectTo, 'ConnectTo');
    RegisterMethod(@TCOMAdminCatalog.Disconnect, 'Disconnect');
    RegisterMethod(@TCOMAdminCatalog.GetCollection, 'GetCollection');
    RegisterMethod(@TCOMAdminCatalog.ICOMAdminCatalog_Connect, 'ICOMAdminCatalog_Connect');
    RegisterMethod(@TCOMAdminCatalog.Get_MajorVersion, 'Get_MajorVersion');
    RegisterMethod(@TCOMAdminCatalog.Get_MinorVersion, 'Get_MinorVersion');
    RegisterMethod(@TCOMAdminCatalog.GetCollectionByQuery, 'GetCollectionByQuery');
    RegisterMethod(@TCOMAdminCatalog.ImportComponent, 'ImportComponent');
    RegisterMethod(@TCOMAdminCatalog.InstallComponent, 'InstallComponent');
    RegisterMethod(@TCOMAdminCatalog.ShutdownApplication, 'ShutdownApplication');
    RegisterMethod(@TCOMAdminCatalog.ExportApplication, 'ExportApplication');
    RegisterMethod(@TCOMAdminCatalog.InstallApplication, 'InstallApplication');
    RegisterMethod(@TCOMAdminCatalog.StopRouter, 'StopRouter');
    RegisterMethod(@TCOMAdminCatalog.RefreshRouter, 'RefreshRouter');
    RegisterMethod(@TCOMAdminCatalog.StartRouter, 'StartRouter');
    RegisterMethod(@TCOMAdminCatalog.InstallMultipleComponents, 'InstallMultipleComponents');
    RegisterMethod(@TCOMAdminCatalog.GetMultipleComponentsInfo, 'GetMultipleComponentsInfo');
    RegisterMethod(@TCOMAdminCatalog.RefreshComponents, 'RefreshComponents');
    RegisterMethod(@TCOMAdminCatalog.BackupREGDB, 'BackupREGDB');
    RegisterMethod(@TCOMAdminCatalog.RestoreREGDB, 'RestoreREGDB');
    RegisterMethod(@TCOMAdminCatalog.QueryApplicationFile, 'QueryApplicationFile');
    RegisterMethod(@TCOMAdminCatalog.StartApplication, 'StartApplication');
    RegisterMethod(@TCOMAdminCatalog.ServiceCheck, 'ServiceCheck');
    RegisterMethod(@TCOMAdminCatalog.InstallMultipleEventClasses, 'InstallMultipleEventClasses');
    RegisterMethod(@TCOMAdminCatalog.InstallEventClass, 'InstallEventClass');
    RegisterMethod(@TCOMAdminCatalog.GetEventClassesForIID, 'GetEventClassesForIID');
    RegisterPropertyHelper(@TCOMAdminCatalogDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TCOMAdminCatalogMajorVersion_R,nil,'MajorVersion');
    RegisterPropertyHelper(@TCOMAdminCatalogMinorVersion_R,nil,'MinorVersion');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoCOMAdminCatalog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoCOMAdminCatalog) do begin
    RegisterMethod(@CoCOMAdminCatalog.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CmAdmCtl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_CoCOMAdminCatalog(CL);
  with CL.Add(TCOMAdminCatalogCollection) do
  RIRegister_TCOMAdminCatalog(CL);
  RIRegister_CoCOMAdminCatalogObject(CL);
  RIRegister_TCOMAdminCatalogObject(CL);
  RIRegister_CoCOMAdminCatalogCollection(CL);
  RIRegister_TCOMAdminCatalogCollection(CL);
end;



{ TPSImport_CmAdmCtl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CmAdmCtl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CmAdmCtl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CmAdmCtl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CmAdmCtl(ri);
end;
(*----------------------------------------------------------------------------*)


end.
