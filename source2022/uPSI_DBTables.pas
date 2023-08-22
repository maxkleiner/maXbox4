unit uPSI_DBTables;
{
code implementing the class wrapper is taken from Carlo Kok's conv utility
  all constructors and destructors by max
  plus updatemode /object - checkconstraints  - tblobstream free
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
  TPSImport_DBTables = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TBlobStream(CL: TPSPascalCompiler);
procedure SIRegister_TUpdateSQL(CL: TPSPascalCompiler);
procedure SIRegister_TQuery(CL: TPSPascalCompiler);
procedure SIRegister_TStoredProc(CL: TPSPascalCompiler);
procedure SIRegister_TBatchMove(CL: TPSPascalCompiler);
procedure SIRegister_TTable(CL: TPSPascalCompiler);
procedure SIRegister_TIndexFiles(CL: TPSPascalCompiler);
procedure SIRegister_TDBDataSet(CL: TPSPascalCompiler);
procedure SIRegister_TNestedTable(CL: TPSPascalCompiler);
procedure SIRegister_TBDEDataSet(CL: TPSPascalCompiler);
procedure SIRegister_TSQLUpdateObject(CL: TPSPascalCompiler);
procedure SIRegister_TDataSetUpdateObject(CL: TPSPascalCompiler);
procedure SIRegister_TDatabase(CL: TPSPascalCompiler);
procedure SIRegister_TParamList(CL: TPSPascalCompiler);
procedure SIRegister_TSession(CL: TPSPascalCompiler);
procedure SIRegister_TSessionList(CL: TPSPascalCompiler);
procedure SIRegister_TBDECallback(CL: TPSPascalCompiler);
procedure SIRegister_TDBError(CL: TPSPascalCompiler);
procedure SIRegister_EDBEngineError(CL: TPSPascalCompiler);
procedure SIRegister_DBTables(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DBTables_Routines(S: TPSExec);
procedure RIRegister_TBlobStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TUpdateSQL(CL: TPSRuntimeClassImporter);
procedure RIRegister_TQuery(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStoredProc(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBatchMove(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIndexFiles(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBDataSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNestedTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBDEDataSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSQLUpdateObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDataSetUpdateObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDatabase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TParamList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSession(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSessionList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBDECallback(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBError(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDBEngineError(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBTables(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,Windows
  ,DB
  ,DBCommon
  ,DBCommonTypes
  ,BDE
  ,SMINTF
  ,DBTables
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBTables]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlobStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TBlobStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TBlobStream') do begin
    RegisterMethod('Constructor Create( Field : TBlobField; Mode : TBlobStreamMode)');
    RegisterMethod('Procedure Truncate');
    RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TUpdateSQL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSQLUpdateObject', 'TUpdateSQL') do
  with CL.AddClassN(CL.FindClass('TSQLUpdateObject'),'TUpdateSQL') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
   //RegisterMethod('Constructor Create(AParent: TIdCustomHTTP);');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Apply1( ADataset : TDataset; UpdateKind : TUpdateKind);');
    RegisterMethod('Procedure ExecSQL( UpdateKind : TUpdateKind)');
    RegisterMethod('Procedure SetParams( ADataset : TDataset; UpdateKind : TUpdateKind);');
    RegisterMethod('Procedure SetParams1( UpdateKind : TUpdateKind);');
    RegisterProperty('DatabaseName', 'string', iptrw);
    RegisterProperty('Query', 'TQuery TUpdateKind', iptr);
    RegisterProperty('SQL', 'TStrings TUpdateKind', iptrw);
    RegisterProperty('SessionName', 'string', iptrw);
    RegisterProperty('ModifySQL', 'TStrings', iptrw);
    RegisterProperty('InsertSQL', 'TStrings', iptrw);
    RegisterProperty('DeleteSQL', 'TStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TQuery(CL: TPSPascalCompiler);
begin                            
  //Tquery.filteroptions
  //with RegClassS(CL,'TDBDataSet', 'TQuery') do
  with CL.AddClassN(CL.FindClass('TDBDataSet'),'TQuery') do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create(AOwner: TComponent);');
   //RegisterMethod('Constructor Create(AParent: TIdCustomHTTP);');
    RegisterMethod('Procedure Free;');
    //RegisterMethod('Procedure Clear;');
    RegisterMethod('Procedure ExecSQL');
    RegisterMethod('Function ParamByName( const Value : string) : TParam');
    RegisterMethod('Procedure Prepare');
    RegisterMethod('Procedure UnPrepare');
    //RegisterMethod('Procedure OpenCursor');
    //RegisterMethod('Procedure CloseCursor');
    RegisterProperty('Prepared', 'Boolean', iptrw);
    RegisterProperty('ParamCount', 'Word', iptr);
    RegisterProperty('Local', 'Boolean', iptr);
    RegisterProperty('Text', 'string', iptr);
    RegisterProperty('RowsAffected', 'Integer', iptr);
    RegisterProperty('SQLBinary', 'PChar', iptrw);
    RegisterProperty('Constrained', 'Boolean', iptrw);
    RegisterProperty('DataSource', 'TDataSource', iptrw);
    RegisterProperty('ParamCheck', 'Boolean', iptrw);
    RegisterProperty('RequestLive', 'Boolean', iptrw);
    RegisterProperty('SQL', 'TStrings', iptrw);
    //RegisterProperty('Clear', 'TStrings', iptrw);
    RegisterProperty('Params', 'TParams', iptrw);
    RegisterProperty('UniDirectional', 'Boolean', iptrw);
    RegisterProperty('UniDirectional', 'Boolean', iptrw);
    RegisterProperty('FilterOptions', 'TFilterOptions', iptrw);
    Registerpublishedproperties;
    RegisterProperty('UpdateMode', 'TUpdateMode', iptrw);
    RegisterProperty('Constraints', 'TCheckConstraints', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStoredProc(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBDataSet', 'TStoredProc') do
  with CL.AddClassN(CL.FindClass('TDBDataSet'),'TStoredProc') do begin
     RegisterMethod('Constructor Create(AOwner: TComponent);');
   //RegisterMethod('Constructor Create(AParent: TIdCustomHTTP);');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure CopyParams( Value : TParams)');
    RegisterMethod('Function DescriptionsAvailable : Boolean');
    RegisterMethod('Procedure ExecProc');
    RegisterMethod('Function ParamByName( const Value : string) : TParam');
    RegisterMethod('Procedure Prepare');
    RegisterMethod('Procedure GetResults');
    RegisterMethod('Procedure UnPrepare');
    RegisterProperty('Handle', 'HDBICur', iptr);
    RegisterProperty('ParamCount', 'Word', iptr);
    RegisterProperty('Prepared', 'Boolean', iptrw);
    RegisterProperty('StoredProcName', 'string', iptrw);
    RegisterProperty('Overload', 'Word', iptrw);
    RegisterProperty('Params', 'TParams', iptrw);
    RegisterProperty('ParamBindMode', 'TParamBindMode', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBatchMove(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TBatchMove') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TBatchMove') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
   //RegisterMethod('Constructor Create(AParent: TIdCustomHTTP);');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Execute');
    RegisterProperty('ChangedCount', 'Longint', iptr);
    RegisterProperty('KeyViolCount', 'Longint', iptr);
    RegisterProperty('MovedCount', 'Longint', iptr);
    RegisterProperty('ProblemCount', 'Longint', iptr);
    RegisterProperty('AbortOnKeyViol', 'Boolean', iptrw);
    RegisterProperty('AbortOnProblem', 'Boolean', iptrw);
    RegisterProperty('CommitCount', 'Integer', iptrw);
    RegisterProperty('ChangedTableName', 'TFileName', iptrw);
    RegisterProperty('Destination', 'TTable', iptrw);
    RegisterProperty('KeyViolTableName', 'TFileName', iptrw);
    RegisterProperty('Mappings', 'TStrings', iptrw);
    RegisterProperty('Mode', 'TBatchMode', iptrw);
    RegisterProperty('ProblemTableName', 'TFileName', iptrw);
    RegisterProperty('RecordCount', 'Longint', iptrw);
    RegisterProperty('Source', 'TBDEDataSet', iptrw);
    RegisterProperty('Transliterate', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBDataSet', 'TTable') do
  with CL.AddClassN(CL.FindClass('TDBDataSet'),'TTable') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
   //RegisterMethod('Constructor Create(AParent: TIdCustomHTTP);');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function BatchMove( ASource : TBDEDataSet; AMode : TBatchMode) : Longint');
    RegisterMethod('Procedure AddIndex( const Name, Fields : string; Options : TIndexOptions; const DescFields : string)');
    RegisterMethod('Procedure ApplyRange');
    RegisterMethod('Procedure CancelRange');
    RegisterMethod('Procedure CloseIndexFile( const IndexFileName : string)');
    RegisterMethod('Procedure CreateTable');
    RegisterMethod('Procedure DeleteIndex( const Name : string)');
    RegisterMethod('Procedure DeleteTable');
    RegisterMethod('Procedure EditKey');
    RegisterMethod('Procedure EditRangeEnd');
    RegisterMethod('Procedure EditRangeStart');
    RegisterMethod('Procedure EmptyTable');
    RegisterMethod('Function FindKey( const KeyValues : array of const) : Boolean');
    RegisterMethod('Procedure FindNearest( const KeyValues : array of const)');
    RegisterMethod('Procedure GetIndexNames( List : TStrings)');
    RegisterMethod('Procedure GotoCurrent( Table : TTable)');
    RegisterMethod('Function GotoKey : Boolean');
    RegisterMethod('Procedure GotoNearest');
    RegisterMethod('Procedure LockTable( LockType : TLockType)');
    RegisterMethod('Procedure OpenIndexFile( const IndexName : string)');
    RegisterMethod('Procedure RenameTable( const NewTableName : string)');
    RegisterMethod('Procedure SetKey');
    RegisterMethod('Procedure SetRange( const StartValues, EndValues : array of const)');
    RegisterMethod('Procedure SetRangeEnd');
    RegisterMethod('Procedure SetRangeStart');
    RegisterMethod('Procedure UnlockTable( LockType : TLockType)');
    RegisterProperty('InMemory', 'Boolean', iptr);
    RegisterProperty('Exists', 'Boolean', iptr);
    RegisterProperty('IndexFieldCount', 'Integer', iptr);
    RegisterProperty('IndexFields', 'TField Integer', iptrw);
    RegisterProperty('KeyExclusive', 'Boolean', iptrw);
    RegisterProperty('KeyFieldCount', 'Integer', iptrw);
    RegisterProperty('TableLevel', 'Integer', iptrw);
    RegisterProperty('DefaultIndex', 'Boolean', iptrw);
    RegisterProperty('Exclusive', 'Boolean', iptrw);
    RegisterProperty('IndexDefs', 'TIndexDefs', iptrw);
    RegisterProperty('IndexFieldNames', 'string', iptrw);
    RegisterProperty('IndexFiles', 'TStrings', iptrw);
    RegisterProperty('IndexName', 'string', iptrw);
    RegisterProperty('MasterFields', 'string', iptrw);
    RegisterProperty('MasterSource', 'TDataSource', iptrw);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
    RegisterProperty('StoreDefs', 'Boolean', iptrw);
    RegisterProperty('TableName', 'TFileName', iptrw);
    RegisterProperty('TableType', 'TTableType', iptrw);
    RegisterProperty('Ranged', 'Boolean', iptr);
    registerpublishedproperties;
    RegisterProperty('UpdateMode', 'TUpdateMode', iptrw);
    RegisterProperty('Constraints', 'TCheckConstraints', iptrw);
     //property Constraints stored ConstraintsStored;
    // property UpdateMode: TUpdateMode read FUpdateMode write SetUpdateMode default upWhereAll;

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIndexFiles(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TIndexFiles') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TIndexFiles') do begin
    RegisterMethod('Constructor Create( AOwner : TTable)');
    RegisterMethod('function Add(const S: string): Integer;');
  RegisterMethod('procedure Clear;');
  RegisterMethod('procedure Delete(Index: Integer)');
  RegisterMethod('procedure Insert(Index: Integer; const S: string)');
 end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBDataSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBDEDataSet', 'TDBDataSet') do
  with CL.AddClassN(CL.FindClass('TBDEDataSet'),'TDBDataSet') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
   //RegisterMethod('Constructor Create(AParent: TIdCustomHTTP);');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function CheckOpen( Status : DBIResult) : Boolean');
    RegisterMethod('Procedure CloseDatabase( Database : TDatabase)');
    RegisterMethod('Function OpenDatabase : TDatabase');
    RegisterProperty('Database', 'TDatabase', iptr);
    RegisterProperty('DBHandle', 'HDBIDB', iptr);
    RegisterProperty('DBLocale', 'TLocale', iptr);
    RegisterProperty('DBSession', 'TSession', iptr);
    RegisterProperty('Handle', 'HDBICur', iptrw);
    RegisterProperty('AutoRefresh', 'Boolean', iptrw);
    RegisterProperty('DatabaseName', 'string', iptrw);
    RegisterProperty('SessionName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNestedTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBDEDataSet', 'TNestedTable') do
  with CL.AddClassN(CL.FindClass('TBDEDataSet'),'TNestedTable') do begin
   registerpublishedproperties;
    RegisterProperty('DataSetField', 'TDataSetField', iptrw);
    RegisterProperty('ObjectView', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBDEDataSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataSet', 'TBDEDataSet') do
  with CL.AddClassN(CL.FindClass('TDataSet'),'TBDEDataSet') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
   //RegisterMethod('Constructor Create(AParent: TIdCustomHTTP);');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure ApplyUpdates');
    RegisterMethod('Procedure CancelUpdates');
    RegisterProperty('CacheBlobs', 'Boolean', iptrw);
    RegisterMethod('Procedure CommitUpdates');
    RegisterMethod('Function ConstraintCallBack( Req : DsInfoReq; var ADataSources : DataSources) : DBIResult');
    RegisterMethod('Function ConstraintsDisabled : Boolean');
    RegisterMethod('Procedure DisableConstraints');
    RegisterMethod('Procedure EnableConstraints');
    RegisterMethod('Procedure FetchAll');
    RegisterMethod('Procedure FlushBuffers');
    RegisterMethod('Procedure GetIndexInfo');
    RegisterMethod('Procedure RevertRecord');
    RegisterProperty('ExpIndex', 'Boolean', iptr);
    RegisterProperty('Handle', 'HDBICur', iptr);
    RegisterProperty('KeySize', 'Word', iptr);
    RegisterProperty('Locale', 'TLocale', iptr);
    RegisterProperty('UpdateObject', 'TDataSetUpdateObject', iptrw);
    RegisterProperty('UpdatesPending', 'Boolean', iptr);
    RegisterProperty('UpdateRecordTypes', 'TUpdateRecordTypes', iptrw);
    RegisterProperty('CachedUpdates', 'Boolean', iptrw);
    RegisterProperty('OnUpdateError', 'TUpdateErrorEvent', iptrw);
    RegisterProperty('OnUpdateRecord', 'TUpdateRecordEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSQLUpdateObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataSetUpdateObject', 'TSQLUpdateObject') do
  with CL.AddClassN(CL.FindClass('TDataSetUpdateObject'),'TSQLUpdateObject') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataSetUpdateObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDataSetUpdateObject') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDataSetUpdateObject') do begin
    RegisterMethod('Procedure Apply( UpdateKind : TUpdateKind)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDatabase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomConnection', 'TDatabase') do
  with CL.AddClassN(CL.FindClass('TCustomConnection'),'TDatabase') do begin
      RegisterMethod('Constructor Create(AOwner: TComponent);');
   //RegisterMethod('Constructor Create(AParent: TIdCustomHTTP);');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure ApplyUpdates( const DataSets : array of TDBDataSet)');
    RegisterMethod('Procedure CloseDataSets');
    RegisterMethod('Procedure Commit');
    RegisterMethod('Function Execute( const SQL : string; Params : TParams; Cache : Boolean; Cursor : phDBICur) : Integer');
    RegisterMethod('Procedure FlushSchemaCache( const TableName : string)');
    RegisterMethod('Procedure GetFieldNames( const TableName : string; List : TStrings)');
    RegisterMethod('Procedure GetTableNames( List : TStrings; SystemTables : Boolean)');
    RegisterMethod('Procedure Rollback');
    RegisterMethod('Procedure StartTransaction');
    RegisterMethod('Procedure ValidateName( const Name : string)');
    RegisterProperty('DataSets', 'TDBDataSet Integer', iptr);
    RegisterProperty('Directory', 'string', iptrw);
    RegisterProperty('Handle', 'HDBIDB', iptrw);
    RegisterProperty('IsSQLBased', 'Boolean', iptr);
    RegisterProperty('InTransaction', 'Boolean', iptr);
    RegisterProperty('Locale', 'TLocale', iptr);
    RegisterProperty('Session', 'TSession', iptr);
    RegisterProperty('Temporary', 'Boolean', iptrw);
    RegisterProperty('SessionAlias', 'Boolean', iptr);
    RegisterProperty('TraceFlags', 'TTraceFlags', iptrw);
    RegisterProperty('AliasName', 'string', iptrw);
    RegisterProperty('DatabaseName', 'string', iptrw);
    RegisterProperty('DriverName', 'string', iptrw);
    RegisterProperty('Exclusive', 'Boolean', iptrw);
    RegisterProperty('HandleShared', 'Boolean', iptrw);
    RegisterProperty('KeepConnection', 'Boolean', iptrw);
    RegisterProperty('Params', 'TStrings', iptrw);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
    RegisterProperty('SessionName', 'string', iptrw);
    RegisterProperty('TransIsolation', 'TTransIsolation', iptrw);
    RegisterProperty('OnLogin', 'TDatabaseLoginEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TParamList(CL: TPSPascalCompiler);
begin
  //Tparamlist
  //with RegClassS(CL,'TObject', 'TParamList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TParamList') do begin
    RegisterMethod('Constructor Create( Params : TStrings)');
    RegisterProperty('Buffer', 'PChar', iptr);
    RegisterProperty('FieldCount', 'Integer', iptr);
    RegisterProperty('FieldDescs', 'TFieldDescList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSession(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSession') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSession') do begin
      RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AddAlias( const Name, Driver : string; List : TStrings)');
    RegisterMethod('Procedure AddDriver( const Name : string; List : TStrings)');
    RegisterMethod('Procedure AddStandardAlias( const Name, Path, DefaultDriver : string)');
    RegisterProperty('ConfigMode', 'TConfigMode', iptrw);
    RegisterMethod('Procedure AddPassword( const Password : string)');
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure CloseDatabase( Database : TDatabase)');
    RegisterMethod('Procedure DeleteAlias( const Name : string)');
    RegisterMethod('Procedure DeleteDriver( const Name : string)');
    RegisterMethod('Procedure DropConnections');
    RegisterMethod('Function FindDatabase( const DatabaseName : string) : TDatabase');
    RegisterMethod('Procedure GetAliasNames( List : TStrings)');
    RegisterMethod('Procedure GetAliasParams( const AliasName : string; List : TStrings)');
    RegisterMethod('Function GetAliasDriverName( const AliasName : string) : string');
    RegisterMethod('Procedure GetConfigParams( const Path, Section : string; List : TStrings)');
    RegisterMethod('Procedure GetDatabaseNames( List : TStrings)');
    RegisterMethod('Procedure GetDriverNames( List : TStrings)');
    RegisterMethod('Procedure GetDriverParams( const DriverName : string; List : TStrings)');
    RegisterMethod('Procedure GetFieldNames( const DatabaseName, TableName : string; List : TStrings)');
    RegisterMethod('Function GetPassword : Boolean');
    RegisterMethod('Procedure GetTableNames( const DatabaseName, Pattern : string; Extensions, SystemTables : Boolean; List : TStrings)');
    RegisterMethod('Procedure GetStoredProcNames( const DatabaseName : string; List : TStrings)');
    RegisterMethod('Function IsAlias( const Name : string) : Boolean');
    RegisterMethod('Procedure ModifyAlias( Name : string; List : TStrings)');
    RegisterMethod('Procedure ModifyDriver( Name : string; List : TStrings)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function OpenDatabase( const DatabaseName : string) : TDatabase');
    RegisterMethod('Procedure RemoveAllPasswords');
    RegisterMethod('Procedure RemovePassword( const Password : string)');
    RegisterMethod('Procedure SaveConfigFile');
    RegisterProperty('DatabaseCount', 'Integer', iptr);
    RegisterProperty('Databases', 'TDatabase Integer', iptr);
    RegisterProperty('Handle', 'HDBISES', iptr);
    RegisterProperty('Locale', 'TLocale', iptr);
    RegisterProperty('TraceFlags', 'TTraceFlags', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('AutoSessionName', 'Boolean', iptrw);
    RegisterProperty('KeepConnections', 'Boolean', iptrw);
    RegisterProperty('NetFileDir', 'string', iptrw);
    RegisterProperty('PrivateDir', 'string', iptrw);
    RegisterProperty('SessionName', 'string', iptrw);
    RegisterProperty('SQLHourGlass', 'Boolean', iptrw);
    RegisterProperty('OnPassword', 'TPasswordEvent', iptrw);
    RegisterProperty('OnStartup', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSessionList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSessionList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSessionList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('CurrentSession', 'TSession', iptrw);
    RegisterMethod('Function FindSession( const SessionName : string) : TSession');
    RegisterMethod('Procedure GetSessionNames( List : TStrings)');
    RegisterMethod('Function OpenSession( const SessionName : string) : TSession');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Sessions', 'TSession Integer', iptr);
    SetDefaultPropery('Sessions');
    RegisterProperty('List', 'TSession string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBDECallback(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBDECallback') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBDECallback') do begin
    RegisterMethod('Constructor Create( AOwner : TObject; Handle : hDBICur; CBType : CBType; CBBuf : Pointer; CBBufSize : Integer; CallbackEvent : TBDECallbackEvent; Chain : Boolean)');
       RegisterMethod('Procedure Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDBError') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDBError') do begin
    RegisterMethod('Constructor Create( Owner : EDBEngineError; ErrorCode : DBIResult; NativeError : Longint; Message : PChar)');
     RegisterMethod('Procedure Free');
      RegisterProperty('Category', 'Byte', iptr);
    RegisterProperty('ErrorCode', 'DBIResult', iptr);
    RegisterProperty('SubCode', 'Byte', iptr);
    RegisterProperty('Message', 'string', iptr);
    RegisterProperty('NativeError', 'Longint', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDBEngineError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDatabaseError', 'EDBEngineError') do
  with CL.AddClassN(CL.FindClass('EDatabaseError'),'EDBEngineError') do begin
    RegisterMethod('Constructor Create( ErrorCode : DBIResult)');
     RegisterMethod('Procedure Free');
     RegisterProperty('ErrorCount', 'Integer', iptr);
    RegisterProperty('Errors', 'TDBError Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBTables(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('dbfOpened','LongInt').SetInt( 0);
 CL.AddConstantN('dbfPrepared','LongInt').SetInt( 1);
 CL.AddConstantN('dbfExecSQL','LongInt').SetInt( 2);
 CL.AddConstantN('dbfTable','LongInt').SetInt( 3);
 CL.AddConstantN('dbfFieldList','LongInt').SetInt( 4);
 CL.AddConstantN('dbfIndexList','LongInt').SetInt( 5);
 CL.AddConstantN('dbfStoredProc','LongInt').SetInt( 6);
 CL.AddConstantN('dbfExecProc','LongInt').SetInt( 7);
 CL.AddConstantN('dbfProcDesc','LongInt').SetInt( 8);
 CL.AddConstantN('dbfDatabase','LongInt').SetInt( 9);
 CL.AddConstantN('dbfProvider','LongInt').SetInt( 10);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDBError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSession');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDatabase');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBDEDataSet');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDBDataSet');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTable');
  SIRegister_EDBEngineError(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ENoResultSet');
  SIRegister_TDBError(CL);
 CL.AddTypeS('THandle', 'LongWord');
 //CL.AddTypeS('TFileName', 'string'); in strutils
 CL.AddTypeS('HDBIDB', 'longword');
  CL.AddTypeS('TLocale', '___Pointer');
  //CL.AddTypeS('TBDECallbackEvent', 'Function ( CBInfo : Pointer) : CBRType');
  SIRegister_TBDECallback(CL);
  SIRegister_TSessionList(CL);
  CL.AddTypeS('TConfigModes', '( cfmVirtual, cfmPersistent, cfmSession )');
  CL.AddTypeS('TConfigMode', 'set of TConfigModes');
  CL.AddTypeS('TPasswordEvent', 'Procedure ( Sender : TObject; var Continue : Boolean)');
  CL.AddTypeS('TDatabaseEvent', '( dbOpen, dbClose, dbAdd, dbRemove, dbAddAlias'
   +', dbDeleteAlias, dbAddDriver, dbDeleteDriver )');
  //CL.AddTypeS('TDatabaseNotifyEvent', 'Procedure ( DBEvent : TDatabaseEvent; co'
   //+'nst Param)');
  CL.AddTypeS('TTraceFlag', '( tfQPrepare, tfQExecute, tfError, tfStmt, tfConne'
   +'ct, tfTransact, tfBlob, tfMisc, tfVendor, tfDataIn, tfDataOut )');
  CL.AddTypeS('TTraceFlags', 'set of TTraceFlag');
  SIRegister_TSession(CL);
  //CL.AddTypeS('TFieldDescList', 'array of BDEFLDDesc');
  SIRegister_TParamList(CL);
  CL.AddTypeS('TTransIsolation', '( tiDirtyRead, tiReadCommitted, tiRepeatableRead )');
  CL.AddTypeS('TDatabaseLoginEvent', 'Procedure ( Database : TDatabase; LoginPa'
   +'rams : TStrings)');
  SIRegister_TDatabase(CL);
  CL.AddTypeS('TRecNoStatus', '( rnDbase, rnParadox, rnNotSupported )');
  SIRegister_TDataSetUpdateObject(CL);
  SIRegister_TSQLUpdateObject(CL);
  CL.AddTypeS('TBlobDataArray', 'array of TBlobData');
  SIRegister_TBDEDataSet(CL);
  SIRegister_TNestedTable(CL);
  //CL.AddTypeS('TDBFlags', 'set of Integer');
  SIRegister_TDBDataSet(CL);
  CL.AddTypeS('TBatchMode', '( batAppend, batUpdate, batAppendUpdate, batDelete, batCopy )');
  CL.AddTypeS('TTableType', '( ttDefault, ttParadox, ttDBase, ttFoxPro, ttASCII)');
  CL.AddTypeS('TLockType', '( ltReadLock, ltWriteLock )');
  CL.AddTypeS('TIndexName', 'string');
  //CL.AddTypeS('TIndexDescList', 'array of IDXDesc');
  //CL.AddTypeS('TValCheckList', 'array of VCHKDesc');
  SIRegister_TIndexFiles(CL);
  SIRegister_TTable(CL);
  SIRegister_TBatchMove(CL);
  CL.AddTypeS('TParamBindMode', '( pbByName, pbByNumber )');
  //CL.AddTypeS('TServerDescList', 'array of TServerDesc');
  //CL.AddTypeS('TSPParamDescList', 'array of BDESPParamDesc');
  SIRegister_TStoredProc(CL);
  SIRegister_TQuery(CL);
  SIRegister_TUpdateSQL(CL);
  SIRegister_TBlobStream(CL);
 CL.AddDelphiFunction('Function AnsiToNative( Locale : TLocale; const AnsiStr : string; NativeStr : PChar; MaxLen : Integer) : PChar');
 CL.AddDelphiFunction('Procedure NativeToAnsi( Locale : TLocale; NativeStr : PChar; var AnsiStr : string)');
 CL.AddDelphiFunction('Procedure AnsiToNativeBuf( Locale : TLocale; Source, Dest : PChar; Len : Integer)');
 CL.AddDelphiFunction('Procedure NativeToAnsiBuf( Locale : TLocale; Source, Dest : PChar; Len : Integer)');
 CL.AddDelphiFunction('Function NativeCompareStr( Locale : TLocale; const S1, S2 : string; Len : Integer) : Integer');
 CL.AddDelphiFunction('Function NativeCompareStrBuf( Locale : TLocale; const S1, S2 : PChar; Len : Integer) : Integer');
 CL.AddDelphiFunction('Function NativeCompareText( Locale : TLocale; const S1, S2 : string; Len : Integer) : Integer');
 CL.AddDelphiFunction('Function NativeCompareTextBuf( Locale : TLocale; const S1, S2 : PChar; Len : Integer) : Integer');
 //CL.AddDelphiFunction('Function GetFieldSource( ADataSet : TDataSet; var ADataSources : DataSources) : Boolean');
 //CL.AddDelphiFunction('Procedure DbiError( ErrorCode : DBIResult)');
 //CL.AddDelphiFunction('Procedure Check( Status : DBIResult)');
 //CL.AddDelphiFunction('Procedure RegisterBDEInitProc( const InitProc : TBDEInitProc)');
 CL.AddConstantN('cmVirtual','LongInt').Value.ts32 := ord(cfmVirtual);
 CL.AddConstantN('cmPersistent','LongInt').Value.ts32 := ord(cfmPersistent);
 CL.AddConstantN('cmSession','LongInt').Value.ts32 := ord(cfmSession);
 CL.AddConstantN('cmAll','LongInt').Value.ts32 := ord(cfmVirtual) or ord(cfmPersistent) or ord(cfmSession);
end;


(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TUpdateSQLDeleteSQL_W(Self: TUpdateSQL; const T: TStrings);
begin Self.DeleteSQL := T; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLDeleteSQL_R(Self: TUpdateSQL; var T: TStrings);
begin T := Self.DeleteSQL; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLInsertSQL_W(Self: TUpdateSQL; const T: TStrings);
begin Self.InsertSQL := T; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLInsertSQL_R(Self: TUpdateSQL; var T: TStrings);
begin T := Self.InsertSQL; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLModifySQL_W(Self: TUpdateSQL; const T: TStrings);
begin Self.ModifySQL := T; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLModifySQL_R(Self: TUpdateSQL; var T: TStrings);
begin T := Self.ModifySQL; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLSessionName_W(Self: TUpdateSQL; const T: string);
begin Self.SessionName := T; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLSessionName_R(Self: TUpdateSQL; var T: string);
begin T := Self.SessionName; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLSQL_W(Self: TUpdateSQL; const T: TStrings; const t1: TUpdateKind);
begin Self.SQL[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLSQL_R(Self: TUpdateSQL; var T: TStrings; const t1: TUpdateKind);
begin T := Self.SQL[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLQuery_R(Self: TUpdateSQL; var T: TQuery; const t1: TUpdateKind);
begin T := Self.Query[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLDatabaseName_W(Self: TUpdateSQL; const T: string);
begin Self.DatabaseName := T; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateSQLDatabaseName_R(Self: TUpdateSQL; var T: string);
begin T := Self.DatabaseName; end;

(*----------------------------------------------------------------------------*)
Procedure TUpdateSQLSetParams1_P(Self: TUpdateSQL;  UpdateKind : TUpdateKind);
Begin Self.SetParams(UpdateKind); END;

(*----------------------------------------------------------------------------*)
Procedure TUpdateSQLSetParams_P(Self: TUpdateSQL;  ADataset : TDataset; UpdateKind : TUpdateKind);
Begin Self.SetParams(ADataset, UpdateKind); END;

(*----------------------------------------------------------------------------*)
Procedure TUpdateSQLApply1_P(Self: TUpdateSQL;  ADataset : TDataset; UpdateKind : TUpdateKind);
Begin Self.Apply(ADataset, UpdateKind); END;

(*----------------------------------------------------------------------------*)
Procedure TUpdateSQLApply_P(Self: TUpdateSQL;  UpdateKind : TUpdateKind);
Begin Self.Apply(UpdateKind); END;

(*----------------------------------------------------------------------------*)
procedure TQueryUniDirectional_W(Self: TQuery; const T: Boolean);
begin Self.UniDirectional := T; end;

(*----------------------------------------------------------------------------*)
procedure TQueryUniDirectional_R(Self: TQuery; var T: Boolean);
begin T := Self.UniDirectional; end;

(*----------------------------------------------------------------------------*)
procedure TQueryParams_W(Self: TQuery; const T: TParams);
begin Self.Params := T; end;

(*----------------------------------------------------------------------------*)
procedure TQueryParams_R(Self: TQuery; var T: TParams);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TQuerySQL_W(Self: TQuery; const T: TStrings);
begin Self.SQL := T; end;

(*----------------------------------------------------------------------------*)
procedure TQuerySQL_R(Self: TQuery; var T: TStrings);
begin T := Self.SQL; end;

(*----------------------------------------------------------------------------*)
procedure TQueryRequestLive_W(Self: TQuery; const T: Boolean);
begin Self.RequestLive := T; end;

(*----------------------------------------------------------------------------*)
procedure TQueryRequestLive_R(Self: TQuery; var T: Boolean);
begin T := Self.RequestLive; end;

(*----------------------------------------------------------------------------*)
procedure TQueryParamCheck_W(Self: TQuery; const T: Boolean);
begin Self.ParamCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TQueryFilterOptions_W(Self: TQuery; const T: TFilterOptions);
begin Self.FilterOptions:= T; end;

(*----------------------------------------------------------------------------*)
procedure TQueryFilterOptions_R(Self: TQuery; var T: TFilterOptions);
begin T := Self.FilterOptions; end;


(*----------------------------------------------------------------------------*)
procedure TQueryParamCheck_R(Self: TQuery; var T: Boolean);
begin T := Self.ParamCheck; end;

(*----------------------------------------------------------------------------*)
procedure TQueryDataSource_W(Self: TQuery; const T: TDataSource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TQueryDataSource_R(Self: TQuery; var T: TDataSource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TQueryConstrained_W(Self: TQuery; const T: Boolean);
begin Self.Constrained := T; end;

(*----------------------------------------------------------------------------*)
procedure TQueryConstrained_R(Self: TQuery; var T: Boolean);
begin T := Self.Constrained; end;

(*----------------------------------------------------------------------------*)
procedure TQuerySQLBinary_W(Self: TQuery; const T: PChar);
begin Self.SQLBinary := T; end;

(*----------------------------------------------------------------------------*)
procedure TQuerySQLBinary_R(Self: TQuery; var T: PChar);
begin T := Self.SQLBinary; end;

(*----------------------------------------------------------------------------*)
procedure TQueryRowsAffected_R(Self: TQuery; var T: Integer);
begin T := Self.RowsAffected; end;

(*----------------------------------------------------------------------------*)
procedure TQueryText_R(Self: TQuery; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TQueryLocal_R(Self: TQuery; var T: Boolean);
begin T := Self.Local; end;

(*----------------------------------------------------------------------------*)
procedure TQueryParamCount_R(Self: TQuery; var T: Word);
begin T := Self.ParamCount; end;

(*----------------------------------------------------------------------------*)
procedure TQueryPrepared_W(Self: TQuery; const T: Boolean);
begin Self.Prepared := T; end;

(*----------------------------------------------------------------------------*)
procedure TQueryPrepared_R(Self: TQuery; var T: Boolean);
begin T := Self.Prepared; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcParamBindMode_W(Self: TStoredProc; const T: TParamBindMode);
begin Self.ParamBindMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcParamBindMode_R(Self: TStoredProc; var T: TParamBindMode);
begin T := Self.ParamBindMode; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcParams_W(Self: TStoredProc; const T: TParams);
begin Self.Params := T; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcParams_R(Self: TStoredProc; var T: TParams);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcOverload_W(Self: TStoredProc; const T: Word);
begin Self.Overload := T; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcOverload_R(Self: TStoredProc; var T: Word);
begin T := Self.Overload; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcStoredProcName_W(Self: TStoredProc; const T: string);
begin Self.StoredProcName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcStoredProcName_R(Self: TStoredProc; var T: string);
begin T := Self.StoredProcName; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcPrepared_W(Self: TStoredProc; const T: Boolean);
begin Self.Prepared := T; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcPrepared_R(Self: TStoredProc; var T: Boolean);
begin T := Self.Prepared; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcParamCount_R(Self: TStoredProc; var T: Word);
begin T := Self.ParamCount; end;

(*----------------------------------------------------------------------------*)
procedure TStoredProcHandle_R(Self: TStoredProc; var T: HDBICur);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveTransliterate_W(Self: TBatchMove; const T: Boolean);
begin Self.Transliterate := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveTransliterate_R(Self: TBatchMove; var T: Boolean);
begin T := Self.Transliterate; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveSource_W(Self: TBatchMove; const T: TBDEDataSet);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveSource_R(Self: TBatchMove; var T: TBDEDataSet);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveRecordCount_W(Self: TBatchMove; const T: Longint);
begin Self.RecordCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveRecordCount_R(Self: TBatchMove; var T: Longint);
begin T := Self.RecordCount; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveProblemTableName_W(Self: TBatchMove; const T: TFileName);
begin Self.ProblemTableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveProblemTableName_R(Self: TBatchMove; var T: TFileName);
begin T := Self.ProblemTableName; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveMode_W(Self: TBatchMove; const T: TBatchMode);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveMode_R(Self: TBatchMove; var T: TBatchMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveMappings_W(Self: TBatchMove; const T: TStrings);
begin Self.Mappings := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveMappings_R(Self: TBatchMove; var T: TStrings);
begin T := Self.Mappings; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveKeyViolTableName_W(Self: TBatchMove; const T: TFileName);
begin Self.KeyViolTableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveKeyViolTableName_R(Self: TBatchMove; var T: TFileName);
begin T := Self.KeyViolTableName; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveDestination_W(Self: TBatchMove; const T: TTable);
begin Self.Destination := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveDestination_R(Self: TBatchMove; var T: TTable);
begin T := Self.Destination; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveChangedTableName_W(Self: TBatchMove; const T: TFileName);
begin Self.ChangedTableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveChangedTableName_R(Self: TBatchMove; var T: TFileName);
begin T := Self.ChangedTableName; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveCommitCount_W(Self: TBatchMove; const T: Integer);
begin Self.CommitCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveCommitCount_R(Self: TBatchMove; var T: Integer);
begin T := Self.CommitCount; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveAbortOnProblem_W(Self: TBatchMove; const T: Boolean);
begin Self.AbortOnProblem := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveAbortOnProblem_R(Self: TBatchMove; var T: Boolean);
begin T := Self.AbortOnProblem; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveAbortOnKeyViol_W(Self: TBatchMove; const T: Boolean);
begin Self.AbortOnKeyViol := T; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveAbortOnKeyViol_R(Self: TBatchMove; var T: Boolean);
begin T := Self.AbortOnKeyViol; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveProblemCount_R(Self: TBatchMove; var T: Longint);
begin T := Self.ProblemCount; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveMovedCount_R(Self: TBatchMove; var T: Longint);
begin T := Self.MovedCount; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveKeyViolCount_R(Self: TBatchMove; var T: Longint);
begin T := Self.KeyViolCount; end;

(*----------------------------------------------------------------------------*)
procedure TBatchMoveChangedCount_R(Self: TBatchMove; var T: Longint);
begin T := Self.ChangedCount; end;

(*----------------------------------------------------------------------------*)
procedure TTableRanged_R(Self: TTable; var T: Boolean);
begin T := Self.Ranged; end;

(*----------------------------------------------------------------------------*)
procedure TTableTableType_W(Self: TTable; const T: TTableType);
begin Self.TableType := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableTableType_R(Self: TTable; var T: TTableType);
begin T := Self.TableType; end;

(*----------------------------------------------------------------------------*)
procedure TTableTableName_W(Self: TTable; const T: TFileName);
begin Self.TableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableTableM_R(Self: TTable; var T: boolean);
begin //T:= Self.InMemory;
 end;

(*----------------------------------------------------------------------------*)
procedure TTableTableM_W(Self: TTable; const T: boolean);
begin //Self.inMemory:= T;
 end;


(*----------------------------------------------------------------------------*)
procedure TTableTableName_R(Self: TTable; var T: TFileName);
begin T := Self.TableName; end;

(*----------------------------------------------------------------------------*)
procedure TTableStoreDefs_W(Self: TTable; const T: Boolean);
begin Self.StoreDefs := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableStoreDefs_R(Self: TTable; var T: Boolean);
begin T := Self.StoreDefs; end;

(*----------------------------------------------------------------------------*)
procedure TTableReadOnly_W(Self: TTable; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableReadOnly_R(Self: TTable; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TTableMasterSource_W(Self: TTable; const T: TDataSource);
begin Self.MasterSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableMasterSource_R(Self: TTable; var T: TDataSource);
begin T := Self.MasterSource; end;

(*----------------------------------------------------------------------------*)
procedure TTableMasterFields_W(Self: TTable; const T: string);
begin Self.MasterFields := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableMasterFields_R(Self: TTable; var T: string);
begin T := Self.MasterFields; end;

(*----------------------------------------------------------------------------*)
procedure TTableIndexName_W(Self: TTable; const T: string);
begin Self.IndexName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableIndexName_R(Self: TTable; var T: string);
begin T := Self.IndexName; end;

(*----------------------------------------------------------------------------*)
procedure TTableIndexFiles_W(Self: TTable; const T: TStrings);
begin Self.IndexFiles := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableIndexFiles_R(Self: TTable; var T: TStrings);
begin T := Self.IndexFiles; end;

(*----------------------------------------------------------------------------*)
procedure TTableIndexFieldNames_W(Self: TTable; const T: string);
begin Self.IndexFieldNames := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableIndexFieldNames_R(Self: TTable; var T: string);
begin T := Self.IndexFieldNames; end;

(*----------------------------------------------------------------------------*)
procedure TTableIndexDefs_W(Self: TTable; const T: TIndexDefs);
begin Self.IndexDefs := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableIndexDefs_R(Self: TTable; var T: TIndexDefs);
begin T := Self.IndexDefs; end;

(*----------------------------------------------------------------------------*)
procedure TTableExclusive_W(Self: TTable; const T: Boolean);
begin Self.Exclusive := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableExclusive_R(Self: TTable; var T: Boolean);
begin T := Self.Exclusive; end;

(*----------------------------------------------------------------------------*)
procedure TTableDefaultIndex_W(Self: TTable; const T: Boolean);
begin Self.DefaultIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableDefaultIndex_R(Self: TTable; var T: Boolean);
begin T := Self.DefaultIndex; end;

(*----------------------------------------------------------------------------*)
procedure TTableTableLevel_W(Self: TTable; const T: Integer);
begin Self.TableLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableTableLevel_R(Self: TTable; var T: Integer);
begin T := Self.TableLevel; end;

(*----------------------------------------------------------------------------*)
procedure TTableKeyFieldCount_W(Self: TTable; const T: Integer);
begin Self.KeyFieldCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableKeyFieldCount_R(Self: TTable; var T: Integer);
begin T := Self.KeyFieldCount; end;

(*----------------------------------------------------------------------------*)
procedure TTableKeyExclusive_W(Self: TTable; const T: Boolean);
begin Self.KeyExclusive := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableKeyExclusive_R(Self: TTable; var T: Boolean);
begin T := Self.KeyExclusive; end;

(*----------------------------------------------------------------------------*)
procedure TTableIndexFields_W(Self: TTable; const T: TField; const t1: Integer);
begin Self.IndexFields[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TTableIndexFields_R(Self: TTable; var T: TField; const t1: Integer);
begin T := Self.IndexFields[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTableIndexFieldCount_R(Self: TTable; var T: Integer);
begin T := Self.IndexFieldCount; end;

(*----------------------------------------------------------------------------*)
procedure TTableExists_R(Self: TTable; var T: Boolean);
begin T := Self.Exists; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetSessionName_W(Self: TDBDataSet; const T: string);
begin Self.SessionName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetSessionName_R(Self: TDBDataSet; var T: string);
begin T := Self.SessionName; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetDatabaseName_W(Self: TDBDataSet; const T: string);
begin Self.DatabaseName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetDatabaseName_R(Self: TDBDataSet; var T: string);
begin T := Self.DatabaseName; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetAutoRefresh_W(Self: TDBDataSet; const T: Boolean);
begin Self.AutoRefresh := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetAutoRefresh_R(Self: TDBDataSet; var T: Boolean);
begin T := Self.AutoRefresh; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetHandle_W(Self: TDBDataSet; const T: HDBICur);
begin Self.Handle := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetHandle_R(Self: TDBDataSet; var T: HDBICur);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetDBSession_R(Self: TDBDataSet; var T: TSession);
begin T := Self.DBSession; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetDBLocale_R(Self: TDBDataSet; var T: TLocale);
begin T := Self.DBLocale; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetDBHandle_R(Self: TDBDataSet; var T: HDBIDB);
begin T := Self.DBHandle; end;

(*----------------------------------------------------------------------------*)
procedure TDBDataSetDatabase_R(Self: TDBDataSet; var T: TDatabase);
begin T := Self.Database; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetOnUpdateRecord_W(Self: TBDEDataSet; const T: TUpdateRecordEvent);
begin Self.OnUpdateRecord := T; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetOnUpdateRecord_R(Self: TBDEDataSet; var T: TUpdateRecordEvent);
begin T := Self.OnUpdateRecord; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetOnUpdateError_W(Self: TBDEDataSet; const T: TUpdateErrorEvent);
begin Self.OnUpdateError := T; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetOnUpdateError_R(Self: TBDEDataSet; var T: TUpdateErrorEvent);
begin T := Self.OnUpdateError; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetCachedUpdates_W(Self: TBDEDataSet; const T: Boolean);
begin Self.CachedUpdates := T; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetCachedUpdates_R(Self: TBDEDataSet; var T: Boolean);
begin T := Self.CachedUpdates; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetUpdateRecordTypes_W(Self: TBDEDataSet; const T: TUpdateRecordTypes);
begin Self.UpdateRecordTypes := T; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetUpdateRecordTypes_R(Self: TBDEDataSet; var T: TUpdateRecordTypes);
begin T := Self.UpdateRecordTypes; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetUpdatesPending_R(Self: TBDEDataSet; var T: Boolean);
begin T := Self.UpdatesPending; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetUpdateObject_W(Self: TBDEDataSet; const T: TDataSetUpdateObject);
begin Self.UpdateObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetUpdateObject_R(Self: TBDEDataSet; var T: TDataSetUpdateObject);
begin T := Self.UpdateObject; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetLocale_R(Self: TBDEDataSet; var T: TLocale);
begin T := Self.Locale; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetKeySize_R(Self: TBDEDataSet; var T: Word);
begin T := Self.KeySize; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetHandle_R(Self: TBDEDataSet; var T: HDBICur);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetExpIndex_R(Self: TBDEDataSet; var T: Boolean);
begin T := Self.ExpIndex; end;

(*----------------------------------------------------------------------------*)
Function TBDEDataSetGetFieldData1_P(Self: TBDEDataSet;  FieldNo : Integer; Buffer : Pointer) : Boolean;
Begin Result := Self.GetFieldData(FieldNo, Buffer); END;

(*----------------------------------------------------------------------------*)
Function TBDEDataSetGetFieldData_P(Self: TBDEDataSet;  Field : TField; Buffer : Pointer) : Boolean;
Begin Result := Self.GetFieldData(Field, Buffer); END;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetCacheBlobs_W(Self: TBDEDataSet; const T: Boolean);
begin Self.CacheBlobs := T; end;

(*----------------------------------------------------------------------------*)
procedure TBDEDataSetCacheBlobs_R(Self: TBDEDataSet; var T: Boolean);
begin T := Self.CacheBlobs; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseOnLogin_W(Self: TDatabase; const T: TDatabaseLoginEvent);
begin Self.OnLogin := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseOnLogin_R(Self: TDatabase; var T: TDatabaseLoginEvent);
begin T := Self.OnLogin; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseTransIsolation_W(Self: TDatabase; const T: TTransIsolation);
begin Self.TransIsolation := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseTransIsolation_R(Self: TDatabase; var T: TTransIsolation);
begin T := Self.TransIsolation; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseSessionName_W(Self: TDatabase; const T: string);
begin Self.SessionName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseSessionName_R(Self: TDatabase; var T: string);
begin T := Self.SessionName; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseReadOnly_W(Self: TDatabase; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseReadOnly_R(Self: TDatabase; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseParams_W(Self: TDatabase; const T: TStrings);
begin Self.Params := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseParams_R(Self: TDatabase; var T: TStrings);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseKeepConnection_W(Self: TDatabase; const T: Boolean);
begin Self.KeepConnection := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseKeepConnection_R(Self: TDatabase; var T: Boolean);
begin T := Self.KeepConnection; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseHandleShared_W(Self: TDatabase; const T: Boolean);
begin Self.HandleShared := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseHandleShared_R(Self: TDatabase; var T: Boolean);
begin T := Self.HandleShared; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseExclusive_W(Self: TDatabase; const T: Boolean);
begin Self.Exclusive := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseExclusive_R(Self: TDatabase; var T: Boolean);
begin T := Self.Exclusive; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseDriverName_W(Self: TDatabase; const T: string);
begin Self.DriverName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseDriverName_R(Self: TDatabase; var T: string);
begin T := Self.DriverName; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseDatabaseName_W(Self: TDatabase; const T: string);
begin Self.DatabaseName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseDatabaseName_R(Self: TDatabase; var T: string);
begin T := Self.DatabaseName; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseAliasName_W(Self: TDatabase; const T: string);
begin Self.AliasName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseAliasName_R(Self: TDatabase; var T: string);
begin T := Self.AliasName; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseTraceFlags_W(Self: TDatabase; const T: TTraceFlags);
begin Self.TraceFlags := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseTraceFlags_R(Self: TDatabase; var T: TTraceFlags);
begin T := Self.TraceFlags; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseSessionAlias_R(Self: TDatabase; var T: Boolean);
begin T := Self.SessionAlias; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseTemporary_W(Self: TDatabase; const T: Boolean);
begin Self.Temporary := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseTemporary_R(Self: TDatabase; var T: Boolean);
begin T := Self.Temporary; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseSession_R(Self: TDatabase; var T: TSession);
begin T := Self.Session; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseLocale_R(Self: TDatabase; var T: TLocale);
begin T := Self.Locale; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseInTransaction_R(Self: TDatabase; var T: Boolean);
begin T := Self.InTransaction; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseIsSQLBased_R(Self: TDatabase; var T: Boolean);
begin T := Self.IsSQLBased; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseHandle_W(Self: TDatabase; const T: HDBIDB);
begin Self.Handle := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseHandle_R(Self: TDatabase; var T: HDBIDB);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseDirectory_W(Self: TDatabase; const T: string);
begin Self.Directory := T; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseDirectory_R(Self: TDatabase; var T: string);
begin T := Self.Directory; end;

(*----------------------------------------------------------------------------*)
procedure TDatabaseDataSets_R(Self: TDatabase; var T: TDBDataSet; const t1: Integer);
begin T := Self.DataSets[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TParamListFieldDescs_R(Self: TParamList; var T: TFieldDescList);
begin T := Self.FieldDescs; end;

(*----------------------------------------------------------------------------*)
procedure TParamListFieldCount_R(Self: TParamList; var T: Integer);
begin T := Self.FieldCount; end;

(*----------------------------------------------------------------------------*)
procedure TParamListBuffer_R(Self: TParamList; var T: PChar);
begin T := Self.Buffer; end;

(*----------------------------------------------------------------------------*)
procedure TSessionOnStartup_W(Self: TSession; const T: TNotifyEvent);
begin Self.OnStartup := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionOnStartup_R(Self: TSession; var T: TNotifyEvent);
begin T := Self.OnStartup; end;

(*----------------------------------------------------------------------------*)
procedure TSessionOnPassword_W(Self: TSession; const T: TPasswordEvent);
begin Self.OnPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionOnPassword_R(Self: TSession; var T: TPasswordEvent);
begin T := Self.OnPassword; end;

(*----------------------------------------------------------------------------*)
procedure TSessionSQLHourGlass_W(Self: TSession; const T: Boolean);
begin Self.SQLHourGlass := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionSQLHourGlass_R(Self: TSession; var T: Boolean);
begin T := Self.SQLHourGlass; end;

(*----------------------------------------------------------------------------*)
procedure TSessionSessionName_W(Self: TSession; const T: string);
begin Self.SessionName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionSessionName_R(Self: TSession; var T: string);
begin T := Self.SessionName; end;

(*----------------------------------------------------------------------------*)
procedure TSessionPrivateDir_W(Self: TSession; const T: string);
begin Self.PrivateDir := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionPrivateDir_R(Self: TSession; var T: string);
begin T := Self.PrivateDir; end;

(*----------------------------------------------------------------------------*)
procedure TSessionNetFileDir_W(Self: TSession; const T: string);
begin Self.NetFileDir := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionNetFileDir_R(Self: TSession; var T: string);
begin T := Self.NetFileDir; end;

(*----------------------------------------------------------------------------*)
procedure TSessionKeepConnections_W(Self: TSession; const T: Boolean);
begin Self.KeepConnections := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionKeepConnections_R(Self: TSession; var T: Boolean);
begin T := Self.KeepConnections; end;

(*----------------------------------------------------------------------------*)
procedure TSessionAutoSessionName_W(Self: TSession; const T: Boolean);
begin Self.AutoSessionName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionAutoSessionName_R(Self: TSession; var T: Boolean);
begin T := Self.AutoSessionName; end;

(*----------------------------------------------------------------------------*)
procedure TSessionActive_W(Self: TSession; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionActive_R(Self: TSession; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TSessionTraceFlags_W(Self: TSession; const T: TTraceFlags);
begin Self.TraceFlags := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionTraceFlags_R(Self: TSession; var T: TTraceFlags);
begin T := Self.TraceFlags; end;

(*----------------------------------------------------------------------------*)
procedure TSessionLocale_R(Self: TSession; var T: TLocale);
begin T := Self.Locale; end;

(*----------------------------------------------------------------------------*)
procedure TSessionHandle_R(Self: TSession; var T: HDBISES);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TSessionDatabases_R(Self: TSession; var T: TDatabase; const t1: Integer);
begin T := Self.Databases[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSessionDatabaseCount_R(Self: TSession; var T: Integer);
begin T := Self.DatabaseCount; end;

(*----------------------------------------------------------------------------*)
procedure TSessionConfigMode_W(Self: TSession; const T: TConfigMode);
begin Self.ConfigMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionConfigMode_R(Self: TSession; var T: TConfigMode);
begin T := Self.ConfigMode; end;

(*----------------------------------------------------------------------------*)
procedure TSessionListList_R(Self: TSessionList; var T: TSession; const t1: string);
begin T := Self.List[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSessionListSessions_R(Self: TSessionList; var T: TSession; const t1: Integer);
begin T := Self.Sessions[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSessionListCount_R(Self: TSessionList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TSessionListCurrentSession_W(Self: TSessionList; const T: TSession);
begin Self.CurrentSession := T; end;

(*----------------------------------------------------------------------------*)
procedure TSessionListCurrentSession_R(Self: TSessionList; var T: TSession);
begin T := Self.CurrentSession; end;

(*----------------------------------------------------------------------------*)
procedure TDBErrorNativeError_R(Self: TDBError; var T: Longint);
begin T := Self.NativeError; end;

(*----------------------------------------------------------------------------*)
procedure TDBErrorMessage_R(Self: TDBError; var T: string);
begin T := Self.Message; end;

(*----------------------------------------------------------------------------*)
procedure TDBErrorSubCode_R(Self: TDBError; var T: Byte);
begin T := Self.SubCode; end;

(*----------------------------------------------------------------------------*)
procedure TDBErrorErrorCode_R(Self: TDBError; var T: DBIResult);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TDBErrorCategory_R(Self: TDBError; var T: Byte);
begin T := Self.Category; end;

(*----------------------------------------------------------------------------*)
procedure EDBEngineErrorErrors_R(Self: EDBEngineError; var T: TDBError; const t1: Integer);
begin T := Self.Errors[t1]; end;

(*----------------------------------------------------------------------------*)
procedure EDBEngineErrorErrorCount_R(Self: EDBEngineError; var T: Integer);
begin T := Self.ErrorCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBTables_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AnsiToNative, 'AnsiToNative', cdRegister);
 S.RegisterDelphiFunction(@NativeToAnsi, 'NativeToAnsi', cdRegister);
 S.RegisterDelphiFunction(@AnsiToNativeBuf, 'AnsiToNativeBuf', cdRegister);
 S.RegisterDelphiFunction(@NativeToAnsiBuf, 'NativeToAnsiBuf', cdRegister);
 S.RegisterDelphiFunction(@NativeCompareStr, 'NativeCompareStr', cdRegister);
 S.RegisterDelphiFunction(@NativeCompareStrBuf, 'NativeCompareStrBuf', cdRegister);
 S.RegisterDelphiFunction(@NativeCompareText, 'NativeCompareText', cdRegister);
 S.RegisterDelphiFunction(@NativeCompareTextBuf, 'NativeCompareTextBuf', cdRegister);
 S.RegisterDelphiFunction(@GetFieldSource, 'GetFieldSource', cdRegister);
 S.RegisterDelphiFunction(@DbiError, 'DbiError', cdRegister);
 S.RegisterDelphiFunction(@Check, 'Check', cdRegister);
 S.RegisterDelphiFunction(@RegisterBDEInitProc, 'RegisterBDEInitProc', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlobStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlobStream) do begin
    RegisterConstructor(@TBlobStream.Create, 'Create');
    RegisterMethod(@TBlobStream.Truncate, 'Truncate');
    RegisterMethod(@TBlobStream.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TUpdateSQL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TUpdateSQL) do begin
    RegisterVirtualConstructor(@TUpdateSQL.Create, 'Create');
    RegisterMethod(@TUpdateSQL.Destroy, 'Free');
    RegisterMethod(@TUpdateSQLApply1_P, 'Apply1');
    RegisterVirtualMethod(@TUpdateSQL.ExecSQL, 'ExecSQL');
    RegisterVirtualMethod(@TUpdateSQLSetParams_P, 'SetParams');
    RegisterVirtualMethod(@TUpdateSQLSetParams1_P, 'SetParams1');
    RegisterPropertyHelper(@TUpdateSQLDatabaseName_R,@TUpdateSQLDatabaseName_W,'DatabaseName');
    RegisterPropertyHelper(@TUpdateSQLQuery_R,nil,'Query');
    RegisterPropertyHelper(@TUpdateSQLSQL_R,@TUpdateSQLSQL_W,'SQL');
    RegisterPropertyHelper(@TUpdateSQLSessionName_R,@TUpdateSQLSessionName_W,'SessionName');
    RegisterPropertyHelper(@TUpdateSQLModifySQL_R,@TUpdateSQLModifySQL_W,'ModifySQL');
    RegisterPropertyHelper(@TUpdateSQLInsertSQL_R,@TUpdateSQLInsertSQL_W,'InsertSQL');
    RegisterPropertyHelper(@TUpdateSQLDeleteSQL_R,@TUpdateSQLDeleteSQL_W,'DeleteSQL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TQuery(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TQuery) do begin
    RegisterVirtualConstructor(@TQuery.Create, 'Create');
    RegisterMethod(@TQuery.Destroy, 'Free');
    //RegisterMethod(@TQuery.Clear, 'Clear');
    RegisterMethod(@TQuery.ExecSQL, 'ExecSQL');
    RegisterMethod(@TQuery.ParamByName, 'ParamByName');
    RegisterMethod(@TQuery.Prepare, 'Prepare');
    RegisterMethod(@TQuery.UnPrepare, 'UnPrepare');
    RegisterPropertyHelper(@TQueryPrepared_R,@TQueryPrepared_W,'Prepared');
    RegisterPropertyHelper(@TQueryParamCount_R,nil,'ParamCount');
    RegisterPropertyHelper(@TQueryLocal_R,nil,'Local');
    RegisterPropertyHelper(@TQueryText_R,nil,'Text');
    RegisterPropertyHelper(@TQueryRowsAffected_R,nil,'RowsAffected');
    RegisterPropertyHelper(@TQuerySQLBinary_R,@TQuerySQLBinary_W,'SQLBinary');
    RegisterPropertyHelper(@TQueryConstrained_R,@TQueryConstrained_W,'Constrained');
    RegisterPropertyHelper(@TQueryDataSource_R,@TQueryDataSource_W,'DataSource');
    RegisterPropertyHelper(@TQueryParamCheck_R,@TQueryParamCheck_W,'ParamCheck');
    RegisterPropertyHelper(@TQueryRequestLive_R,@TQueryRequestLive_W,'RequestLive');
    RegisterPropertyHelper(@TQuerySQL_R,@TQuerySQL_W,'SQL');
    RegisterPropertyHelper(@TQueryParams_R,@TQueryParams_W,'Params');
    RegisterPropertyHelper(@TQueryFilterOptions_R,@TQueryFilterOptions_W,'FilterOptions');

    RegisterPropertyHelper(@TQueryUniDirectional_R,@TQueryUniDirectional_W,'UniDirectional');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStoredProc(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStoredProc) do begin
    RegisterVirtualConstructor(@TStoredProc.Create, 'Create');
    RegisterMethod(@TStoredProc.Destroy, 'Free');
    RegisterMethod(@TStoredProc.CopyParams, 'CopyParams');
    RegisterMethod(@TStoredProc.DescriptionsAvailable, 'DescriptionsAvailable');
    RegisterMethod(@TStoredProc.ExecProc, 'ExecProc');
    RegisterMethod(@TStoredProc.ParamByName, 'ParamByName');
    RegisterMethod(@TStoredProc.Prepare, 'Prepare');
    RegisterMethod(@TStoredProc.GetResults, 'GetResults');
    RegisterMethod(@TStoredProc.UnPrepare, 'UnPrepare');
    RegisterPropertyHelper(@TStoredProcHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TStoredProcParamCount_R,nil,'ParamCount');
    RegisterPropertyHelper(@TStoredProcPrepared_R,@TStoredProcPrepared_W,'Prepared');
    RegisterPropertyHelper(@TStoredProcStoredProcName_R,@TStoredProcStoredProcName_W,'StoredProcName');
    RegisterPropertyHelper(@TStoredProcOverload_R,@TStoredProcOverload_W,'Overload');
    RegisterPropertyHelper(@TStoredProcParams_R,@TStoredProcParams_W,'Params');
    RegisterPropertyHelper(@TStoredProcParamBindMode_R,@TStoredProcParamBindMode_W,'ParamBindMode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBatchMove(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBatchMove) do begin
    RegisterVirtualConstructor(@TBatchMove.Create, 'Create');
    RegisterMethod(@TBatchMove.Destroy, 'Free');
    RegisterMethod(@TBatchMove.Execute, 'Execute');
    RegisterPropertyHelper(@TBatchMoveChangedCount_R,nil,'ChangedCount');
    RegisterPropertyHelper(@TBatchMoveKeyViolCount_R,nil,'KeyViolCount');
    RegisterPropertyHelper(@TBatchMoveMovedCount_R,nil,'MovedCount');
    RegisterPropertyHelper(@TBatchMoveProblemCount_R,nil,'ProblemCount');
    RegisterPropertyHelper(@TBatchMoveAbortOnKeyViol_R,@TBatchMoveAbortOnKeyViol_W,'AbortOnKeyViol');
    RegisterPropertyHelper(@TBatchMoveAbortOnProblem_R,@TBatchMoveAbortOnProblem_W,'AbortOnProblem');
    RegisterPropertyHelper(@TBatchMoveCommitCount_R,@TBatchMoveCommitCount_W,'CommitCount');
    RegisterPropertyHelper(@TBatchMoveChangedTableName_R,@TBatchMoveChangedTableName_W,'ChangedTableName');
    RegisterPropertyHelper(@TBatchMoveDestination_R,@TBatchMoveDestination_W,'Destination');
    RegisterPropertyHelper(@TBatchMoveKeyViolTableName_R,@TBatchMoveKeyViolTableName_W,'KeyViolTableName');
    RegisterPropertyHelper(@TBatchMoveMappings_R,@TBatchMoveMappings_W,'Mappings');
    RegisterPropertyHelper(@TBatchMoveMode_R,@TBatchMoveMode_W,'Mode');
    RegisterPropertyHelper(@TBatchMoveProblemTableName_R,@TBatchMoveProblemTableName_W,'ProblemTableName');
    RegisterPropertyHelper(@TBatchMoveRecordCount_R,@TBatchMoveRecordCount_W,'RecordCount');
    RegisterPropertyHelper(@TBatchMoveSource_R,@TBatchMoveSource_W,'Source');
    RegisterPropertyHelper(@TBatchMoveTransliterate_R,@TBatchMoveTransliterate_W,'Transliterate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTable) do begin
    RegisterVirtualConstructor(@TTable.Create, 'Create');
    RegisterMethod(@TTable.Destroy, 'Free');
    RegisterMethod(@TTable.BatchMove, 'BatchMove');
    RegisterMethod(@TTable.AddIndex, 'AddIndex');
    RegisterMethod(@TTable.ApplyRange, 'ApplyRange');
    RegisterMethod(@TTable.CancelRange, 'CancelRange');
    RegisterMethod(@TTable.CloseIndexFile, 'CloseIndexFile');
    RegisterMethod(@TTable.CreateTable, 'CreateTable');
    RegisterMethod(@TTable.DeleteIndex, 'DeleteIndex');
    RegisterMethod(@TTable.DeleteTable, 'DeleteTable');
    RegisterMethod(@TTable.EditKey, 'EditKey');
    RegisterMethod(@TTable.EditRangeEnd, 'EditRangeEnd');
    RegisterMethod(@TTable.EditRangeStart, 'EditRangeStart');
    RegisterMethod(@TTable.EmptyTable, 'EmptyTable');
    RegisterMethod(@TTable.FindKey, 'FindKey');
    RegisterMethod(@TTable.FindNearest, 'FindNearest');
    RegisterMethod(@TTable.GetIndexNames, 'GetIndexNames');
    RegisterMethod(@TTable.GotoCurrent, 'GotoCurrent');
    RegisterMethod(@TTable.GotoKey, 'GotoKey');
    RegisterMethod(@TTable.GotoNearest, 'GotoNearest');
    RegisterMethod(@TTable.LockTable, 'LockTable');
    RegisterMethod(@TTable.OpenIndexFile, 'OpenIndexFile');
    RegisterMethod(@TTable.RenameTable, 'RenameTable');
    RegisterMethod(@TTable.SetKey, 'SetKey');
    RegisterMethod(@TTable.SetRange, 'SetRange');
    RegisterMethod(@TTable.SetRangeEnd, 'SetRangeEnd');
    RegisterMethod(@TTable.SetRangeStart, 'SetRangeStart');
    RegisterMethod(@TTable.UnlockTable, 'UnlockTable');
    RegisterPropertyHelper(@TTableExists_R,nil,'Exists');
    RegisterPropertyHelper(@TTableIndexFieldCount_R,nil,'IndexFieldCount');
    RegisterPropertyHelper(@TTableIndexFields_R,@TTableIndexFields_W,'IndexFields');
    RegisterPropertyHelper(@TTableKeyExclusive_R,@TTableKeyExclusive_W,'KeyExclusive');
    RegisterPropertyHelper(@TTableKeyFieldCount_R,@TTableKeyFieldCount_W,'KeyFieldCount');
    RegisterPropertyHelper(@TTableTableLevel_R,@TTableTableLevel_W,'TableLevel');
    RegisterPropertyHelper(@TTableDefaultIndex_R,@TTableDefaultIndex_W,'DefaultIndex');
    RegisterPropertyHelper(@TTableExclusive_R,@TTableExclusive_W,'Exclusive');
    RegisterPropertyHelper(@TTableIndexDefs_R,@TTableIndexDefs_W,'IndexDefs');
    RegisterPropertyHelper(@TTableIndexFieldNames_R,@TTableIndexFieldNames_W,'IndexFieldNames');
    RegisterPropertyHelper(@TTableIndexFiles_R,@TTableIndexFiles_W,'IndexFiles');
    RegisterPropertyHelper(@TTableIndexName_R,@TTableIndexName_W,'IndexName');
    RegisterPropertyHelper(@TTableMasterFields_R,@TTableMasterFields_W,'MasterFields');
    RegisterPropertyHelper(@TTableMasterSource_R,@TTableMasterSource_W,'MasterSource');
    RegisterPropertyHelper(@TTableReadOnly_R,@TTableReadOnly_W,'ReadOnly');
    RegisterPropertyHelper(@TTableStoreDefs_R,@TTableStoreDefs_W,'StoreDefs');
    RegisterPropertyHelper(@TTableTableName_R,@TTableTableName_W,'TableName');
    RegisterPropertyHelper(@TTableTableType_R,@TTableTableType_W,'TableType');
    RegisterPropertyHelper(@TTableTableM_R,@TTableTableM_W,'InMemory');
    RegisterPropertyHelper(@TTableRanged_R,nil,'Ranged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIndexFiles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIndexFiles) do begin
    RegisterConstructor(@TIndexFiles.Create, 'Create');
    RegisterMethod(@TIndexFiles.Add, 'Add');
    RegisterMethod(@TIndexFiles.Clear, 'Clear');
    RegisterMethod(@TIndexFiles.Delete, 'Delete');
    RegisterMethod(@TIndexFiles.Insert, 'Insert');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBDataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBDataSet) do begin
    RegisterVirtualConstructor(@TDBDataSet.Create, 'Create');
    RegisterMethod(@TDBDataSet.Destroy, 'Free');
    RegisterMethod(@TDBDataSet.CheckOpen, 'CheckOpen');
    RegisterMethod(@TDBDataSet.CloseDatabase, 'CloseDatabase');
    RegisterMethod(@TDBDataSet.OpenDatabase, 'OpenDatabase');
    RegisterPropertyHelper(@TDBDataSetDatabase_R,nil,'Database');
    RegisterPropertyHelper(@TDBDataSetDBHandle_R,nil,'DBHandle');
    RegisterPropertyHelper(@TDBDataSetDBLocale_R,nil,'DBLocale');
    RegisterPropertyHelper(@TDBDataSetDBSession_R,nil,'DBSession');
    RegisterPropertyHelper(@TDBDataSetHandle_R,@TDBDataSetHandle_W,'Handle');
    RegisterPropertyHelper(@TDBDataSetAutoRefresh_R,@TDBDataSetAutoRefresh_W,'AutoRefresh');
    RegisterPropertyHelper(@TDBDataSetDatabaseName_R,@TDBDataSetDatabaseName_W,'DatabaseName');
    RegisterPropertyHelper(@TDBDataSetSessionName_R,@TDBDataSetSessionName_W,'SessionName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNestedTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNestedTable) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBDEDataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBDEDataSet) do begin
    RegisterVirtualConstructor(@TBDEDataSet.Create, 'Create');
    RegisterMethod(@TBDEDataSet.Destroy, 'Free');
    RegisterMethod(@TBDEDataSet.ApplyUpdates, 'ApplyUpdates');
    RegisterMethod(@TBDEDataSet.CancelUpdates, 'CancelUpdates');
    RegisterPropertyHelper(@TBDEDataSetCacheBlobs_R,@TBDEDataSetCacheBlobs_W,'CacheBlobs');
    RegisterMethod(@TBDEDataSet.CommitUpdates, 'CommitUpdates');
    RegisterMethod(@TBDEDataSet.ConstraintCallBack, 'ConstraintCallBack');
    RegisterMethod(@TBDEDataSet.ConstraintsDisabled, 'ConstraintsDisabled');
    RegisterMethod(@TBDEDataSet.DisableConstraints, 'DisableConstraints');
    RegisterMethod(@TBDEDataSet.EnableConstraints, 'EnableConstraints');
    RegisterMethod(@TBDEDataSet.FetchAll, 'FetchAll');
    RegisterMethod(@TBDEDataSet.FlushBuffers, 'FlushBuffers');
    RegisterMethod(@TBDEDataSet.GetIndexInfo, 'GetIndexInfo');
    RegisterMethod(@TBDEDataSet.RevertRecord, 'RevertRecord');
    RegisterPropertyHelper(@TBDEDataSetExpIndex_R,nil,'ExpIndex');
    RegisterPropertyHelper(@TBDEDataSetHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TBDEDataSetKeySize_R,nil,'KeySize');
    RegisterPropertyHelper(@TBDEDataSetLocale_R,nil,'Locale');
    RegisterPropertyHelper(@TBDEDataSetUpdateObject_R,@TBDEDataSetUpdateObject_W,'UpdateObject');
    RegisterPropertyHelper(@TBDEDataSetUpdatesPending_R,nil,'UpdatesPending');
    RegisterPropertyHelper(@TBDEDataSetUpdateRecordTypes_R,@TBDEDataSetUpdateRecordTypes_W,'UpdateRecordTypes');
    RegisterPropertyHelper(@TBDEDataSetCachedUpdates_R,@TBDEDataSetCachedUpdates_W,'CachedUpdates');
    RegisterPropertyHelper(@TBDEDataSetOnUpdateError_R,@TBDEDataSetOnUpdateError_W,'OnUpdateError');
    RegisterPropertyHelper(@TBDEDataSetOnUpdateRecord_R,@TBDEDataSetOnUpdateRecord_W,'OnUpdateRecord');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSQLUpdateObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSQLUpdateObject) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataSetUpdateObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataSetUpdateObject) do begin
    //RegisterVirtualAbstractMethod(@TDataSetUpdateObject, @Apply, 'Apply');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDatabase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDatabase) do begin
    RegisterVirtualConstructor(@TDatabase.Create, 'Create');
    RegisterMethod(@TDatabase.Destroy, 'Free');
    RegisterMethod(@TDatabase.ApplyUpdates, 'ApplyUpdates');
    RegisterMethod(@TDatabase.CloseDataSets, 'CloseDataSets');
    RegisterMethod(@TDatabase.Commit, 'Commit');
    RegisterMethod(@TDatabase.Execute, 'Execute');
    RegisterMethod(@TDatabase.FlushSchemaCache, 'FlushSchemaCache');
    RegisterMethod(@TDatabase.GetFieldNames, 'GetFieldNames');
    RegisterMethod(@TDatabase.GetTableNames, 'GetTableNames');
    RegisterMethod(@TDatabase.Rollback, 'Rollback');
    RegisterMethod(@TDatabase.StartTransaction, 'StartTransaction');
    RegisterMethod(@TDatabase.ValidateName, 'ValidateName');
    RegisterPropertyHelper(@TDatabaseDataSets_R,nil,'DataSets');
    RegisterPropertyHelper(@TDatabaseDirectory_R,@TDatabaseDirectory_W,'Directory');
    RegisterPropertyHelper(@TDatabaseHandle_R,@TDatabaseHandle_W,'Handle');
    RegisterPropertyHelper(@TDatabaseIsSQLBased_R,nil,'IsSQLBased');
    RegisterPropertyHelper(@TDatabaseInTransaction_R,nil,'InTransaction');
    RegisterPropertyHelper(@TDatabaseLocale_R,nil,'Locale');
    RegisterPropertyHelper(@TDatabaseSession_R,nil,'Session');
    RegisterPropertyHelper(@TDatabaseTemporary_R,@TDatabaseTemporary_W,'Temporary');
    RegisterPropertyHelper(@TDatabaseSessionAlias_R,nil,'SessionAlias');
    RegisterPropertyHelper(@TDatabaseTraceFlags_R,@TDatabaseTraceFlags_W,'TraceFlags');
    RegisterPropertyHelper(@TDatabaseAliasName_R,@TDatabaseAliasName_W,'AliasName');
    RegisterPropertyHelper(@TDatabaseDatabaseName_R,@TDatabaseDatabaseName_W,'DatabaseName');
    RegisterPropertyHelper(@TDatabaseDriverName_R,@TDatabaseDriverName_W,'DriverName');
    RegisterPropertyHelper(@TDatabaseExclusive_R,@TDatabaseExclusive_W,'Exclusive');
    RegisterPropertyHelper(@TDatabaseHandleShared_R,@TDatabaseHandleShared_W,'HandleShared');
    RegisterPropertyHelper(@TDatabaseKeepConnection_R,@TDatabaseKeepConnection_W,'KeepConnection');
    RegisterPropertyHelper(@TDatabaseParams_R,@TDatabaseParams_W,'Params');
    RegisterPropertyHelper(@TDatabaseReadOnly_R,@TDatabaseReadOnly_W,'ReadOnly');
    RegisterPropertyHelper(@TDatabaseSessionName_R,@TDatabaseSessionName_W,'SessionName');
    RegisterPropertyHelper(@TDatabaseTransIsolation_R,@TDatabaseTransIsolation_W,'TransIsolation');
    RegisterPropertyHelper(@TDatabaseOnLogin_R,@TDatabaseOnLogin_W,'OnLogin');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParamList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParamList) do begin
    RegisterConstructor(@TParamList.Create, 'Create');
    RegisterPropertyHelper(@TParamListBuffer_R,nil,'Buffer');
    RegisterPropertyHelper(@TParamListFieldCount_R,nil,'FieldCount');
    RegisterPropertyHelper(@TParamListFieldDescs_R,nil,'FieldDescs');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSession(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSession) do begin
    RegisterVirtualConstructor(@TSession.Create, 'Create');
    RegisterMethod(@TSession.Destroy, 'Free');
    RegisterMethod(@TSession.AddAlias, 'AddAlias');
    RegisterMethod(@TSession.AddDriver, 'AddDriver');
    RegisterMethod(@TSession.AddStandardAlias, 'AddStandardAlias');
    RegisterPropertyHelper(@TSessionConfigMode_R,@TSessionConfigMode_W,'ConfigMode');
    RegisterMethod(@TSession.AddPassword, 'AddPassword');
    RegisterMethod(@TSession.Close, 'Close');
    RegisterMethod(@TSession.CloseDatabase, 'CloseDatabase');
    RegisterMethod(@TSession.DeleteAlias, 'DeleteAlias');
    RegisterMethod(@TSession.DeleteDriver, 'DeleteDriver');
    RegisterMethod(@TSession.DropConnections, 'DropConnections');
    RegisterMethod(@TSession.FindDatabase, 'FindDatabase');
    RegisterMethod(@TSession.GetAliasNames, 'GetAliasNames');
    RegisterMethod(@TSession.GetAliasParams, 'GetAliasParams');
    RegisterMethod(@TSession.GetAliasDriverName, 'GetAliasDriverName');
    RegisterMethod(@TSession.GetConfigParams, 'GetConfigParams');
    RegisterMethod(@TSession.GetDatabaseNames, 'GetDatabaseNames');
    RegisterMethod(@TSession.GetDriverNames, 'GetDriverNames');
    RegisterMethod(@TSession.GetDriverParams, 'GetDriverParams');
    RegisterMethod(@TSession.GetFieldNames, 'GetFieldNames');
    RegisterMethod(@TSession.GetPassword, 'GetPassword');
    RegisterMethod(@TSession.GetTableNames, 'GetTableNames');
    RegisterMethod(@TSession.GetStoredProcNames, 'GetStoredProcNames');
    RegisterMethod(@TSession.IsAlias, 'IsAlias');
    RegisterMethod(@TSession.ModifyAlias, 'ModifyAlias');
    RegisterMethod(@TSession.ModifyDriver, 'ModifyDriver');
    RegisterMethod(@TSession.Open, 'Open');
    RegisterMethod(@TSession.OpenDatabase, 'OpenDatabase');
    RegisterMethod(@TSession.RemoveAllPasswords, 'RemoveAllPasswords');
    RegisterMethod(@TSession.RemovePassword, 'RemovePassword');
    RegisterMethod(@TSession.SaveConfigFile, 'SaveConfigFile');
    RegisterPropertyHelper(@TSessionDatabaseCount_R,nil,'DatabaseCount');
    RegisterPropertyHelper(@TSessionDatabases_R,nil,'Databases');
    RegisterPropertyHelper(@TSessionHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TSessionLocale_R,nil,'Locale');
    RegisterPropertyHelper(@TSessionTraceFlags_R,@TSessionTraceFlags_W,'TraceFlags');
    RegisterPropertyHelper(@TSessionActive_R,@TSessionActive_W,'Active');
    RegisterPropertyHelper(@TSessionAutoSessionName_R,@TSessionAutoSessionName_W,'AutoSessionName');
    RegisterPropertyHelper(@TSessionKeepConnections_R,@TSessionKeepConnections_W,'KeepConnections');
    RegisterPropertyHelper(@TSessionNetFileDir_R,@TSessionNetFileDir_W,'NetFileDir');
    RegisterPropertyHelper(@TSessionPrivateDir_R,@TSessionPrivateDir_W,'PrivateDir');
    RegisterPropertyHelper(@TSessionSessionName_R,@TSessionSessionName_W,'SessionName');
    RegisterPropertyHelper(@TSessionSQLHourGlass_R,@TSessionSQLHourGlass_W,'SQLHourGlass');
    RegisterPropertyHelper(@TSessionOnPassword_R,@TSessionOnPassword_W,'OnPassword');
    RegisterPropertyHelper(@TSessionOnStartup_R,@TSessionOnStartup_W,'OnStartup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSessionList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSessionList) do begin
    RegisterConstructor(@TSessionList.Create, 'Create');
    RegisterPropertyHelper(@TSessionListCurrentSession_R,@TSessionListCurrentSession_W,'CurrentSession');
    RegisterMethod(@TSessionList.FindSession, 'FindSession');
    RegisterMethod(@TSessionList.GetSessionNames, 'GetSessionNames');
    RegisterMethod(@TSessionList.OpenSession, 'OpenSession');
    RegisterPropertyHelper(@TSessionListCount_R,nil,'Count');
    RegisterPropertyHelper(@TSessionListSessions_R,nil,'Sessions');
    RegisterPropertyHelper(@TSessionListList_R,nil,'List');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBDECallback(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBDECallback) do begin
    RegisterConstructor(@TBDECallback.Create, 'Create');
    RegisterMethod(@TBDECallback.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBError) do begin
    RegisterConstructor(@TDBError.Create, 'Create');
     RegisterMethod(@TDBError.Destroy, 'Free');
      RegisterPropertyHelper(@TDBErrorCategory_R,nil,'Category');
    RegisterPropertyHelper(@TDBErrorErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@TDBErrorSubCode_R,nil,'SubCode');
    RegisterPropertyHelper(@TDBErrorMessage_R,nil,'Message');
    RegisterPropertyHelper(@TDBErrorNativeError_R,nil,'NativeError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDBEngineError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDBEngineError) do begin
    RegisterConstructor(@EDBEngineError.Create, 'Create');
      RegisterMethod(@EDBEngineError.Destroy, 'Free');
    RegisterPropertyHelper(@EDBEngineErrorErrorCount_R,nil,'ErrorCount');
    RegisterPropertyHelper(@EDBEngineErrorErrors_R,nil,'Errors');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBTables(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBError) do
  with CL.Add(TSession) do
  with CL.Add(TDatabase) do
  with CL.Add(TBDEDataSet) do
  with CL.Add(TDBDataSet) do
  with CL.Add(TTable) do
  RIRegister_EDBEngineError(CL);
  with CL.Add(ENoResultSet) do
  RIRegister_TDBError(CL);
  RIRegister_TBDECallback(CL);
  RIRegister_TSessionList(CL);
  RIRegister_TSession(CL);
  RIRegister_TParamList(CL);
  RIRegister_TDatabase(CL);
  RIRegister_TDataSetUpdateObject(CL);
  RIRegister_TSQLUpdateObject(CL);
  RIRegister_TBDEDataSet(CL);
  RIRegister_TNestedTable(CL);
  RIRegister_TDBDataSet(CL);
  RIRegister_TIndexFiles(CL);
  RIRegister_TTable(CL);
  RIRegister_TBatchMove(CL);
  RIRegister_TStoredProc(CL);
  RIRegister_TQuery(CL);
  RIRegister_TUpdateSQL(CL);
  RIRegister_TBlobStream(CL);
end;



{ TPSImport_DBTables }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBTables.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBTables(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBTables.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBTables(ri);
  RIRegister_DBTables_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
