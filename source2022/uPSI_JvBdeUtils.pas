unit uPSI_JvBdeUtils;
{
   th bde
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
  TPSImport_JvBdeUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvCloneTable(CL: TPSPascalCompiler);
procedure SIRegister_TJvCloneDbDataset(CL: TPSPascalCompiler);
procedure SIRegister_TJvCloneDataset(CL: TPSPascalCompiler);
procedure SIRegister_TJvDBLocate(CL: TPSPascalCompiler);
procedure SIRegister_JvBdeUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvBdeUtils_Routines(S: TPSExec);
procedure RIRegister_TJvCloneTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCloneDbDataset(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCloneDataset(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvDBLocate(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvBdeUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Bde
  //,Registry
  //,RTLConsts
  ,DB, DBConsts
  ,DBTables
  //,IniFiles
  ,JvDBUtils
  ,JvBdeUtils
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvBdeUtils]);
end;

function CountPos(const subtxt: string; Text: string): Integer;
begin
  if (Length(subtxt)= 0) Or (Length(Text)= 0) Or (Pos(subtxt,Text)= 0) then
    result:= 0
  else
    result:= (Length(Text)- Length(StringReplace(Text,subtxt,'',
      [rfReplaceAll]))) div Length(subtxt);
end;



function dsGetRecordCount(DataSet: TBDEDataSet): Longint;
begin
  if DataSet.State = dsInactive then
    _DBError(SDataSetClosed);
  Check(DbiGetRecordCount(DataSet.Handle, Result));
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCloneTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTable', 'TJvCloneTable') do
  with CL.AddClassN(CL.FindClass('TTable'),'TJvCloneTable') do begin
    RegisterMethod('Procedure InitFromTable( SourceTable : TTable; Reset : Boolean)');
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCloneDbDataset(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBDataSet', 'TJvCloneDbDataset') do
  with CL.AddClassN(CL.FindClass('TDBDataSet'),'TJvCloneDbDataset') do begin
    RegisterMethod('Procedure InitFromDataSet( Source : TDBDataSet; Reset : Boolean)');
    RegisterProperty('SourceHandle', 'HDBICur', iptrw);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCloneDataset(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBDEDataSet', 'TJvCloneDataset') do
  with CL.AddClassN(CL.FindClass('TBDEDataSet'),'TJvCloneDataset') do
  begin
    RegisterProperty('SourceHandle', 'HDBICur', iptrw);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDBLocate(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvLocateObject', 'TJvDBLocate') do
  with CL.AddClassN(CL.FindClass('TJvLocateObject'),'TJvDBLocate') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvBdeUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TLocateFilter', '( lfTree, lfCallback )');
  CL.AddTypeS('TBDEDataSet', 'TDataSet');
  CL.AddTypeS('TDatabaseLoginEvent', 'TLoginEvent');
  SIRegister_TJvDBLocate(CL);
  SIRegister_TJvCloneDataset(CL);
  SIRegister_TJvCloneDbDataset(CL);
  SIRegister_TJvCloneTable(CL);
 CL.AddDelphiFunction('Function CreateDbLocate : TJvLocateObject');
 //CL.AddDelphiFunction('Function CheckOpen( Status : DBIResult) : Boolean');
 CL.AddDelphiFunction('Procedure FetchAllRecords( DataSet : TBDEDataSet)');
 CL.AddDelphiFunction('Function TransActive( Database : TDatabase) : Boolean');
 CL.AddDelphiFunction('Function AsyncQrySupported( Database : TDatabase) : Boolean');
 CL.AddDelphiFunction('Function GetQuoteChar( Database : TDatabase) : string');
 CL.AddDelphiFunction('Procedure ExecuteQuery( const DbName, QueryText : string)');
 CL.AddDelphiFunction('Procedure ExecuteQueryEx( const SessName, DbName, QueryText : string)');
 //CL.AddDelphiFunction('Procedure BdeTranslate( Locale : TLocale; Source, Dest : PChar; ToOem : Boolean)');
 CL.AddDelphiFunction('Function FieldLogicMap( FldType : TFieldType) : Integer');
 CL.AddDelphiFunction('Function FieldSubtypeMap( FldType : TFieldType) : Integer');
 //CL.AddDelphiFunction('Procedure ConvertStringToLogicType( Locale : TLocale; FldLogicType : Integer; FldSize : Word; const FldName, Value : string; Buffer : Pointer)');
 CL.AddDelphiFunction('Function GetAliasPath( const AliasName : string) : string');
 CL.AddDelphiFunction('Function IsDirectory( const DatabaseName : string) : Boolean');
 CL.AddDelphiFunction('Function GetBdeDirectory : string');
 //CL.AddDelphiFunction('Function BdeErrorMsg( ErrorCode : DBIResult) : string');
 CL.AddDelphiFunction('Function LoginToDatabase( Database : TDatabase; OnLogin : TDatabaseLoginEvent) : Boolean');
 CL.AddDelphiFunction('Function DataSetFindValue( ADataSet : TBDEDataSet; const Value, FieldName : string) : Boolean');
 CL.AddDelphiFunction('Function DataSetFindLike( ADataSet : TBDEDataSet; const Value, FieldName : string) : Boolean');
 CL.AddDelphiFunction('Function DataSetRecNo( DataSet : TDataSet) : Longint');
 CL.AddDelphiFunction('Function DataSetRecordCount( DataSet : TDataSet) : Longint');
 CL.AddDelphiFunction('Function DataSetPositionStr( DataSet : TDataSet) : string');
 CL.AddDelphiFunction('Procedure DataSetShowDeleted( DataSet : TBDEDataSet; Show : Boolean)');
 CL.AddDelphiFunction('Function CurrentRecordDeleted( DataSet : TBDEDataSet) : Boolean');
 CL.AddDelphiFunction('Function IsFilterApplicable( DataSet : TDataSet) : Boolean');
 CL.AddDelphiFunction('Function IsBookmarkStable( DataSet : TBDEDataSet) : Boolean');
 //CL.AddDelphiFunction('Function BookmarksCompare( DataSet : TBDEDataSet; Bookmark1, Bookmark2 : TBookmark) : Integer');
 //CL.AddDelphiFunction('Function SetToBookmark( ADataSet : TDataSet; ABookmark : TBookmark) : Boolean');
 CL.AddDelphiFunction('Procedure SetIndex( Table : TTable; const IndexFieldNames : string)');
 CL.AddDelphiFunction('Procedure RestoreIndex( Table : TTable)');
 CL.AddDelphiFunction('Procedure DeleteRange( Table : TTable; IndexFields : array of const; FieldValues : array of const)');
 CL.AddDelphiFunction('Procedure PackTable( Table : TTable)');
 CL.AddDelphiFunction('Procedure ReindexTable( Table : TTable)');
 CL.AddDelphiFunction('Procedure BdeFlushBuffers');
 //CL.AddDelphiFunction('Function GetNativeHandle( Database : TDatabase; Buffer : ___Pointer; BufSize : Integer) : ___Pointer');
 CL.AddDelphiFunction('Procedure ToggleDebugLayer( Active : Boolean; const DebugFile : string)');
 CL.AddDelphiFunction('Procedure DbNotSupported');
 CL.AddDelphiFunction('Procedure ExportDataSet( Source : TBDEDataSet; DestTable : TTable; TableType : TTableType; const AsciiCharSet : string; AsciiDelimited : Boolean; MaxRecordCount : Longint)');
 CL.AddDelphiFunction('Procedure ExportDataSetEx( Source : TBDEDataSet; DestTable : TTable; TableType : TTableType; const AsciiCharSet : string; AsciiDelimited : Boolean; AsciiDelimiter, AsciiSeparator : Char; MaxRecordCount : Longint)');
 CL.AddDelphiFunction('Procedure ImportDataSet( Source : TBDEDataSet; DestTable : TTable; MaxRecordCount : Longint; Mappings : TStrings; Mode : TBatchMode)');
 CL.AddDelphiFunction('Procedure InitRSRUN( Database : TDatabase; const ConName : string; ConType : Integer; const ConServer : string)');
 CL.AddDelphiFunction('Function dsGetRecordCount(DataSet: TBDEDataSet): Longint;');
 CL.AddDelphiFunction('Function GetRecordCount(DataSet: TBDEDataSet): Longint;');
 CL.AddDelphiFunction('function CountPos(const subtxt: string; Text: string): Integer;');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvCloneTableReadOnly_W(Self: TJvCloneTable; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCloneTableReadOnly_R(Self: TJvCloneTable; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TJvCloneDbDatasetReadOnly_W(Self: TJvCloneDbDataset; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCloneDbDatasetReadOnly_R(Self: TJvCloneDbDataset; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TJvCloneDbDatasetSourceHandle_W(Self: TJvCloneDbDataset; const T: HDBICur);
begin Self.SourceHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCloneDbDatasetSourceHandle_R(Self: TJvCloneDbDataset; var T: HDBICur);
begin T := Self.SourceHandle; end;

(*----------------------------------------------------------------------------*)
procedure TJvCloneDatasetReadOnly_W(Self: TJvCloneDataset; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCloneDatasetReadOnly_R(Self: TJvCloneDataset; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TJvCloneDatasetSourceHandle_W(Self: TJvCloneDataset; const T: HDBICur);
begin Self.SourceHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCloneDatasetSourceHandle_R(Self: TJvCloneDataset; var T: HDBICur);
begin T := Self.SourceHandle; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvBdeUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateDbLocate, 'CreateDbLocate', cdRegister);
 //S.RegisterDelphiFunction(@CheckOpen, 'CheckOpen', cdRegister);
 S.RegisterDelphiFunction(@FetchAllRecords, 'FetchAllRecords', cdRegister);
 S.RegisterDelphiFunction(@TransActive, 'TransActive', cdRegister);
 S.RegisterDelphiFunction(@AsyncQrySupported, 'AsyncQrySupported', cdRegister);
 S.RegisterDelphiFunction(@GetQuoteChar, 'GetQuoteChar', cdRegister);
 S.RegisterDelphiFunction(@ExecuteQuery, 'ExecuteQuery', cdRegister);
 S.RegisterDelphiFunction(@ExecuteQueryEx, 'ExecuteQueryEx', cdRegister);
 S.RegisterDelphiFunction(@BdeTranslate, 'BdeTranslate', cdRegister);
 S.RegisterDelphiFunction(@FieldLogicMap, 'FieldLogicMap', cdRegister);
 S.RegisterDelphiFunction(@FieldSubtypeMap, 'FieldSubtypeMap', cdRegister);
 S.RegisterDelphiFunction(@ConvertStringToLogicType, 'ConvertStringToLogicType', cdRegister);
 S.RegisterDelphiFunction(@GetAliasPath, 'GetAliasPath', cdRegister);
 S.RegisterDelphiFunction(@IsDirectory, 'IsDirectory', cdRegister);
 S.RegisterDelphiFunction(@GetBdeDirectory, 'GetBdeDirectory', cdRegister);
 S.RegisterDelphiFunction(@BdeErrorMsg, 'BdeErrorMsg', cdRegister);
 S.RegisterDelphiFunction(@LoginToDatabase, 'LoginToDatabase', cdRegister);
 S.RegisterDelphiFunction(@DataSetFindValue, 'DataSetFindValue', cdRegister);
 S.RegisterDelphiFunction(@DataSetFindLike, 'DataSetFindLike', cdRegister);
 S.RegisterDelphiFunction(@DataSetRecNo, 'DataSetRecNo', cdRegister);
 S.RegisterDelphiFunction(@DataSetRecordCount, 'DataSetRecordCount', cdRegister);
 S.RegisterDelphiFunction(@DataSetPositionStr, 'DataSetPositionStr', cdRegister);
 S.RegisterDelphiFunction(@DataSetShowDeleted, 'DataSetShowDeleted', cdRegister);
 S.RegisterDelphiFunction(@CurrentRecordDeleted, 'CurrentRecordDeleted', cdRegister);
 S.RegisterDelphiFunction(@IsFilterApplicable, 'IsFilterApplicable', cdRegister);
 S.RegisterDelphiFunction(@IsBookmarkStable, 'IsBookmarkStable', cdRegister);
 S.RegisterDelphiFunction(@BookmarksCompare, 'BookmarksCompare', cdRegister);
 S.RegisterDelphiFunction(@SetToBookmark, 'SetToBookmark', cdRegister);
 S.RegisterDelphiFunction(@SetIndex, 'SetIndex', cdRegister);
 S.RegisterDelphiFunction(@RestoreIndex, 'RestoreIndex', cdRegister);
 S.RegisterDelphiFunction(@DeleteRange, 'DeleteRange', cdRegister);
 S.RegisterDelphiFunction(@PackTable, 'PackTable', cdRegister);
 S.RegisterDelphiFunction(@ReindexTable, 'ReindexTable', cdRegister);
 S.RegisterDelphiFunction(@BdeFlushBuffers, 'BdeFlushBuffers', cdRegister);
 //S.RegisterDelphiFunction(@GetNativeHandle, 'GetNativeHandle', cdRegister);
 S.RegisterDelphiFunction(@ToggleDebugLayer, 'ToggleDebugLayer', cdRegister);
 S.RegisterDelphiFunction(@DbNotSupported, 'DbNotSupported', cdRegister);
 S.RegisterDelphiFunction(@ExportDataSet, 'ExportDataSet', cdRegister);
 S.RegisterDelphiFunction(@ExportDataSetEx, 'ExportDataSetEx', cdRegister);
 S.RegisterDelphiFunction(@ImportDataSet, 'ImportDataSet', cdRegister);
 S.RegisterDelphiFunction(@InitRSRUN, 'InitRSRUN', cdRegister);
 S.RegisterDelphiFunction(@dsGetRecordCount, 'dsGetRecordCount', cdRegister);
 S.RegisterDelphiFunction(@dsGetRecordCount, 'GetRecordCount', cdRegister);
 S.RegisterDelphiFunction(@CountPos, 'CountPos', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCloneTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCloneTable) do
  begin
    RegisterMethod(@TJvCloneTable.InitFromTable, 'InitFromTable');
    RegisterPropertyHelper(@TJvCloneTableReadOnly_R,@TJvCloneTableReadOnly_W,'ReadOnly');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCloneDbDataset(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCloneDbDataset) do
  begin
    RegisterMethod(@TJvCloneDbDataset.InitFromDataSet, 'InitFromDataSet');
    RegisterPropertyHelper(@TJvCloneDbDatasetSourceHandle_R,@TJvCloneDbDatasetSourceHandle_W,'SourceHandle');
    RegisterPropertyHelper(@TJvCloneDbDatasetReadOnly_R,@TJvCloneDbDatasetReadOnly_W,'ReadOnly');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCloneDataset(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCloneDataset) do
  begin
    RegisterPropertyHelper(@TJvCloneDatasetSourceHandle_R,@TJvCloneDatasetSourceHandle_W,'SourceHandle');
    RegisterPropertyHelper(@TJvCloneDatasetReadOnly_R,@TJvCloneDatasetReadOnly_W,'ReadOnly');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDBLocate(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDBLocate) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvBdeUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDBLocate(CL);
  RIRegister_TJvCloneDataset(CL);
  RIRegister_TJvCloneDbDataset(CL);
  RIRegister_TJvCloneTable(CL);
end;

 
 
{ TPSImport_JvBdeUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvBdeUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvBdeUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvBdeUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvBdeUtils(ri);
  RIRegister_JvBdeUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
