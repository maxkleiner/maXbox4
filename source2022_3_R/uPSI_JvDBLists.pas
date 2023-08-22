unit uPSI_JvDBLists;
{
  as table support
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
  TPSImport_JvDBLists = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvIndexList(CL: TPSPascalCompiler);
procedure SIRegister_TJvStoredProcList(CL: TPSPascalCompiler);
procedure SIRegister_TJvTableList(CL: TPSPascalCompiler);
procedure SIRegister_TJvLangDrivList(CL: TPSPascalCompiler);
procedure SIRegister_TJvDriverDesc(CL: TPSPascalCompiler);
procedure SIRegister_TJvDatabaseDesc(CL: TPSPascalCompiler);
procedure SIRegister_TJvTableItems(CL: TPSPascalCompiler);
procedure SIRegister_TJvCustomTableItems(CL: TPSPascalCompiler);
procedure SIRegister_TJvDatabaseItems(CL: TPSPascalCompiler);
procedure SIRegister_TJvCustomDatabaseItems(CL: TPSPascalCompiler);
procedure SIRegister_TJvDBListDataSet(CL: TPSPascalCompiler);
procedure SIRegister_TJvBDEItems(CL: TPSPascalCompiler);
procedure SIRegister_TJvCustomBDEItems(CL: TPSPascalCompiler);
procedure SIRegister_JvDBLists(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvIndexList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvStoredProcList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvTableList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvLangDrivList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvDriverDesc(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvDatabaseDesc(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvTableItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCustomTableItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvDatabaseItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCustomDatabaseItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvDBListDataSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvBDEItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCustomBDEItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDBLists(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DB
  ,DBTables
  ,Bde
  ,WinTypes
  ,WinProcs
  ,DbiTypes
  ,DbiProcs
  ,DbiErrs
  ,JvDBUtils
  ,JvDBLists
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDBLists]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvIndexList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomTableItems', 'TJvIndexList') do
  with CL.AddClassN(CL.FindClass('TJvCustomTableItems'),'TJvIndexList') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvStoredProcList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomDatabaseItems', 'TJvStoredProcList') do
  with CL.AddClassN(CL.FindClass('TJvCustomDatabaseItems'),'TJvStoredProcList') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   //   property ExtendedInfo;
   // property SystemItems;
     registerpublishedproperties;
    RegisterProperty('ExtendedInfo', 'boolean', iptrw);
    RegisterProperty('SystemItems', 'boolean', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTableList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomDatabaseItems', 'TJvTableList') do
  with CL.AddClassN(CL.FindClass('TJvCustomDatabaseItems'),'TJvTableList') do begin
    RegisterMethod('Function GetTableName : string');
     registerpublishedproperties;
    RegisterProperty('ExtendedInfo', 'boolean', iptrw);
    RegisterProperty('FileMask', 'boolean', iptrw);
    RegisterProperty('SystemItems', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvLangDrivList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomBDEItems', 'TJvLangDrivList') do
  with CL.AddClassN(CL.FindClass('TJvCustomBDEItems'),'TJvLangDrivList') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDriverDesc(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvDriverDesc') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvDriverDesc') do
  begin
    RegisterMethod('Constructor Create( const DriverType : string)');
    RegisterProperty('Description', 'DRVType', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDatabaseDesc(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvDatabaseDesc') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvDatabaseDesc') do
  begin
    RegisterMethod('Constructor Create( const DatabaseName : string)');
    RegisterProperty('Description', 'DBDesc', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTableItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomTableItems', 'TJvTableItems') do
  with CL.AddClassN(CL.FindClass('TJvCustomTableItems'),'TJvTableItems') do begin
  //published
   registerpublishedproperties;
    RegisterProperty('ItemType', 'TTabItemType', iptrw);
    RegisterProperty('PhysTypes', 'boolean', iptrw);
    //property ItemType;
    //property PhysTypes;

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCustomTableItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvDBListDataSet', 'TJvCustomTableItems') do
  with CL.AddClassN(CL.FindClass('TJvDBListDataSet'),'TJvCustomTableItems') do
  begin
    RegisterProperty('TableName', 'TFileName', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDatabaseItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomDatabaseItems', 'TJvDatabaseItems') do
  with CL.AddClassN(CL.FindClass('TJvCustomDatabaseItems'),'TJvDatabaseItems') do begin
   registerpublishedproperties;
    {property ItemType;
    property ExtendedInfo;
    property FileMask;
    property SystemItems;}
    RegisterProperty('ItemType', 'TDBItemType', iptrw);
    RegisterProperty('ExtendedInfo', 'boolean', iptrw);
    RegisterProperty('FileMask', 'boolean', iptrw);
    RegisterProperty('SystemItems', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCustomDatabaseItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvDBListDataSet', 'TJvCustomDatabaseItems') do
  with CL.AddClassN(CL.FindClass('TJvDBListDataSet'),'TJvCustomDatabaseItems') do
  begin
    RegisterProperty('ItemName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDBListDataSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBDataSet', 'TJvDBListDataSet') do
  with CL.AddClassN(CL.FindClass('TDBDataSet'),'TJvDBListDataSet') do
  begin
    RegisterMethod('Function Locate( const KeyFields : string; const KeyValues : Variant; Options : TLocateOptions) : Boolean');
    RegisterProperty('RecordCount', 'Longint', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvBDEItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomBDEItems', 'TJvBDEItems') do
  with CL.AddClassN(CL.FindClass('TJvCustomBDEItems'),'TJvBDEItems') do begin
   registerpublishedproperties;
    RegisterProperty('ItemType', 'TBDEItemType', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCustomBDEItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBDEDataSet', 'TJvCustomBDEItems') do
  with CL.AddClassN(CL.FindClass('TBDEDataSet'),'TJvCustomBDEItems') do
  begin
    RegisterMethod('Function Locate( const KeyFields : string; const KeyValues : Variant; Options : TLocateOptions) : Boolean');
    RegisterProperty('DBSession', 'TSession', iptr);
    RegisterProperty('RecordCount', 'Longint', iptr);
    RegisterProperty('SessionName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDBLists(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TBDEItemType', '( bdDatabases, bdDrivers, bdLangDrivers, bdUsers, bdRepositories )');
  SIRegister_TJvCustomBDEItems(CL);
  SIRegister_TJvBDEItems(CL);
  SIRegister_TJvDBListDataSet(CL);
  CL.AddTypeS('TDBItemType', '( dtTables, dtStoredProcs, dtFiles, dtFunctions )');
  SIRegister_TJvCustomDatabaseItems(CL);
  SIRegister_TJvDatabaseItems(CL);
  CL.AddTypeS('TTabItemType', '( dtFields, dtIndices, dtValChecks, dtRefInt, dtSecurity, dtFamily )');
  SIRegister_TJvCustomTableItems(CL);
  SIRegister_TJvTableItems(CL);
  SIRegister_TJvDatabaseDesc(CL);
  SIRegister_TJvDriverDesc(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvDatabaseList');
  SIRegister_TJvLangDrivList(CL);
  SIRegister_TJvTableList(CL);
  SIRegister_TJvStoredProcList(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvFieldList');
  SIRegister_TJvIndexList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDriverDescDescription_R(Self: TJvDriverDesc; var T: DRVType);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TJvDatabaseDescDescription_R(Self: TJvDatabaseDesc; var T: DBDesc);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomTableItemsTableName_W(Self: TJvCustomTableItems; const T: TFileName);
begin Self.TableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomTableItemsTableName_R(Self: TJvCustomTableItems; var T: TFileName);
begin T := Self.TableName; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomDatabaseItemsItemName_R(Self: TJvCustomDatabaseItems; var T: string);
begin T := Self.ItemName; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBListDataSetRecordCount_R(Self: TJvDBListDataSet; var T: Longint);
begin T := Self.RecordCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomBDEItemsSessionName_W(Self: TJvCustomBDEItems; const T: string);
begin Self.SessionName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomBDEItemsSessionName_R(Self: TJvCustomBDEItems; var T: string);
begin T := Self.SessionName; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomBDEItemsRecordCount_R(Self: TJvCustomBDEItems; var T: Longint);
begin T := Self.RecordCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomBDEItemsDBSession_R(Self: TJvCustomBDEItems; var T: TSession);
begin T := Self.DBSession; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvIndexList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvIndexList) do
  begin
    RegisterConstructor(@TJvIndexList.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvStoredProcList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvStoredProcList) do
  begin
    RegisterConstructor(@TJvStoredProcList.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTableList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTableList) do
  begin
    RegisterMethod(@TJvTableList.GetTableName, 'GetTableName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvLangDrivList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvLangDrivList) do
  begin
    RegisterConstructor(@TJvLangDrivList.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDriverDesc(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDriverDesc) do
  begin
    RegisterConstructor(@TJvDriverDesc.Create, 'Create');
    RegisterPropertyHelper(@TJvDriverDescDescription_R,nil,'Description');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDatabaseDesc(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDatabaseDesc) do
  begin
    RegisterConstructor(@TJvDatabaseDesc.Create, 'Create');
    RegisterPropertyHelper(@TJvDatabaseDescDescription_R,nil,'Description');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTableItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTableItems) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCustomTableItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCustomTableItems) do
  begin
    RegisterPropertyHelper(@TJvCustomTableItemsTableName_R,@TJvCustomTableItemsTableName_W,'TableName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDatabaseItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDatabaseItems) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCustomDatabaseItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCustomDatabaseItems) do
  begin
    RegisterPropertyHelper(@TJvCustomDatabaseItemsItemName_R,nil,'ItemName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDBListDataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDBListDataSet) do
  begin
    RegisterMethod(@TJvDBListDataSet.Locate, 'Locate');
    RegisterPropertyHelper(@TJvDBListDataSetRecordCount_R,nil,'RecordCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvBDEItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvBDEItems) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCustomBDEItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCustomBDEItems) do
  begin
    RegisterMethod(@TJvCustomBDEItems.Locate, 'Locate');
    RegisterPropertyHelper(@TJvCustomBDEItemsDBSession_R,nil,'DBSession');
    RegisterPropertyHelper(@TJvCustomBDEItemsRecordCount_R,nil,'RecordCount');
    RegisterPropertyHelper(@TJvCustomBDEItemsSessionName_R,@TJvCustomBDEItemsSessionName_W,'SessionName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDBLists(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvCustomBDEItems(CL);
  RIRegister_TJvBDEItems(CL);
  RIRegister_TJvDBListDataSet(CL);
  RIRegister_TJvCustomDatabaseItems(CL);
  RIRegister_TJvDatabaseItems(CL);
  RIRegister_TJvCustomTableItems(CL);
  RIRegister_TJvTableItems(CL);
  RIRegister_TJvDatabaseDesc(CL);
  RIRegister_TJvDriverDesc(CL);
  with CL.Add(TJvDatabaseList) do
  RIRegister_TJvLangDrivList(CL);
  RIRegister_TJvTableList(CL);
  RIRegister_TJvStoredProcList(CL);
  with CL.Add(TJvFieldList) do
  RIRegister_TJvIndexList(CL);
end;

 
 
{ TPSImport_JvDBLists }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBLists.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDBLists(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBLists.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDBLists(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
