unit CTSVendorUtils;

interface

uses
  VendorTestFramework, Sysutils, DB, Variants, Classes,
  DBXCommon;

const
  DBXCTSSEEDField = 'SEED_ID';      { Do not localize }
  DBXCTSGenFieldSuffix = '_FIELD';  { Do not localize }

type
  ///<summary>
  ///  A Class designed to help aid working with Dialects.
  ///</summary>
  TCTSUtils = class
  protected
    FDialect: TBaseDialect;
    FDataGenerator: TDataGenerator;
  public
    constructor Create( ADialect: TBaseDialect );

    destructor Destroy; override;
    /// <summary>
    ///    Pass SQLType Array to create an array of ColumnInfo which can be used with dialect
    ///    for creating Table DDL. Can also be used to insert with parameters.
    ///  <summary>
    function  BuildColumnInfoArray( const ForTypes: TSQLTypeArray ): TColumnInfoArray; overload;

    /// <summary>
    ///    Same as BuildColumnInfoArray but you can pass SQLType Set if you don't want
    ///    to bother creating a type array.
    ///  <summary>
    function  BuildColumnInfoArray( const ForTypes: TSQLTypeSet ): TColumnInfoArray; overload;

    /// <summary>
    ///   Be sure to clean up your ColumnInfoArray when you are through with it.
    ///  </summary>
    procedure ClearColumnInfoArray( Columns: TColumnInfoArray );

    ///  <Summary>
    ///  Uses Column to set appropiate TDBXDatatype
    ///  </Summary>
    procedure SetDbxParamForColumn( Param: TDBXParameter; const Column: TColumnInfo);

    ///  <Summary>
    ///  Uses Column information to determine what kind of data to generate for parameter value.
    ///  </Summary>
    procedure GenerateValueForDbxParam( DbxParam: TDBXParameter; const Column: TColumnInfo);
  end;

  //how to handle transactions
  TTransactionMode = ( tmNone, tmCommit, tmRollback );

  //Ignore exceptions when executing simple SQL Statements, e.g. Drop table etc.
  TExecuteSQLOption = (optIgnoreException, optRaiseException);


  TConnectedCTSHelper = class(TCTSUtils)
  protected
    FConnection: TDBXConnection;
  public
    constructor Create( ADialect: TBaseDialect );
    destructor Destroy; override;

    class function GetConnectionFromName(const ConnectionName: WideString): TDBXConnection;
    procedure  ExecuteSQLStatement(SQL: WideString;
      TransactionType: TTransactionMode = tmCommit;
      IgnoreException: TExecuteSQLOption = optRaiseException);
  end;


  ///Class to help with the differet DB Objects that will be used
  ///  throughout the CTS
  TCTSDbObjects = class(TConnectedCTSHelper)
  private const
    /// Use the corrisponding properties for the name
    DBXCTSMaster    = 'CTSMaster';      { Do not localize }
    DBXCTSDetail    = 'CTSDetail';      { Do not localize }
    DBXCTSAllTypes  = 'CTSAllTypes';    { Do not localize }
  protected
    class function GetMasterTableName: WideString; static;
    class function GetDetailTableName: WideString; static;
    class function GetAllTypesTableName: WideString; static;

    procedure CreateMasterTable; virtual;
    procedure DropMasterTable; virtual;

    procedure CreateDetailTable; virtual;
    procedure DropDetailTable; virtual;

    procedure CreateAllTypesTable; virtual;
    procedure DropAllTypesTable; virtual;

    function  GetMasterSQL: WideString; virtual;
    function  GetDetailSQL: WideString; virtual;
    function  GetAllTypesSQL: WideString; virtual;

    procedure FillMasterTable; virtual;
    procedure FillDetailTable; virtual;
    procedure FillAllTypesTable; virtual;
  public
    procedure InitDBObjects; virtual;
    procedure CreateDBObjects; virtual;   //add objects to database
    procedure CleanUpDBObjects; virtual;  //remove objects from the database that were added in CreateDBObjects

    function  GetAllTypesColumns: TColumnInfoArray;

    class function GetUserToken: WideString;
    class property MasterTable: WideString read GetMasterTableName;
    class property DetailTable: WideString read GetDetailTableName;
    class property AlllTypesTable: WideString read GetAllTypesTableName;
  end;


   TInterval = class(TObject)
  private
    FStart: TDateTime;
    FStop: TDateTime;

    function GetTotalSeconds: Int64;
    function GetTotalMinuets: Int64;
    function GetTotalHours: Int64;
    function GetTimeSpan: TDateTime;
  public
    constructor Create;
    procedure Start;
    procedure Stop;
    procedure Clear;
    property TimeSpan: TDateTime read GetTimeSpan;
    property TotalSeconds: Int64 read GetTotalSeconds;
    property TotalMinuets: Int64 read GetTotalMinuets;
    property TotalHours: Int64 read GetTotalHours;
    function ToString: String; overload;
  end;


implementation

uses
  SQLExpr, { <--Only using for the FldTypeMap[]}
  DBByteBuffer,
  FMTBcd,
  //Classes,
  DateUtils,
  StrUtils;


{ TInterval }

procedure TInterval.Clear;
begin
  FStart := 0;
  FStop := 0;
end;

constructor TInterval.Create;
begin
  inherited;
  Clear;
end;

function TInterval.GetTimeSpan: TDateTime;
begin
  Assert( FStop > FStart );
  Result := FStop - FStart;
end;

function TInterval.GetTotalHours: Int64;
begin
  Result := HoursBetween(FStart,FStop);
end;

function TInterval.GetTotalMinuets: Int64;
begin
  Result := MinutesBetween(FStart,FStop);
end;

function TInterval.GetTotalSeconds: Int64;
begin
  Result := SecondsBetween(FStart,FStop);
end;

procedure TInterval.Start;
begin
  FStart := Now;
end;

procedure TInterval.Stop;
begin
  FStop := Now;
end;

function TInterval.ToString: String;
var
  H,M,S,MS: Word;
const
  TimeFormat = '%d:%d:%d.%d';
begin
  DecodeTime( FStop - FStart,H,M,S,MS );
  Result := Format(TimeFormat,[H,M,S,MS]);
end;

  


{ TCTSDbObjects }
procedure TCTSDbObjects.CleanUpDBObjects;
begin
  DropDetailTable;
  DropMasterTable;
  DropAllTypesTable;
end;

procedure TCTSDbObjects.CreateAllTypesTable;
begin
  ExecuteSQLStatement(GetAllTypesSQL, tmNone);
end;

procedure TCTSDbObjects.CreateDBObjects;
begin
  CreateMasterTable;
  CreateDetailTable;
  CreateAllTypesTable;
end;

procedure TCTSDbObjects.CreateDetailTable;
begin
  ExecuteSQLStatement(GetDetailSQL, tmNone);
end;

procedure TCTSDbObjects.CreateMasterTable;
begin
  ExecuteSQLStatement(GetMasterSQL, tmNone);
end;

procedure TCTSDbObjects.DropAllTypesTable;
begin
  ExecuteSQLStatement(
    FDialect.DropTableCommand(TCTSDbObjects.AlllTypesTable),
    tmNone, optIgnoreException);
end;

procedure TCTSDbObjects.DropDetailTable;
begin
  ExecuteSQLStatement(
    FDialect.DropTableCommand(TCTSDbObjects.DetailTable),tmNone,optIgnoreException );
end;

procedure TCTSDbObjects.DropMasterTable;
begin
  ExecuteSQLStatement(
    FDialect.DropTableCommand(TCTSDbObjects.MasterTable),
    tmNone, optIgnoreException);
end;

procedure TCTSDbObjects.FillAllTypesTable;
var
  I, J: Integer;
  AllColumns: TColumnInfoArray;
  Command: TDBXCommand;
  DbxParam: TDBXParameter;
  Transaction: TDbxTransaction;

  procedure InitializeCommandParams;
  var
   Column: TColumnInfo;
  begin
    //create command and set the command text
    Command := FConnection.CreateCommand;
    Command.Text := FDialect.InsertIntoStatement( TCTSDbObjects.AlllTypesTable,
      AllColumns );

    for Column in AllColumns do
    begin
      DbxParam := Command.CreateParameter;
      SetDbxParamForColumn(DbxParam,Column);
      Command.Parameters.AddParameter( DbxParam );
    end;
  end;

begin
  if VerboseLoggingEnabled then
    Writeln('Begin FillAllTypesTable: ', FDialect.ClassName);

  //the columns I'm interested in creating data for.
  AllColumns := GetAllTypesColumns;

  InitializeCommandParams;

  try
    //start a transaction
    Transaction := FConnection.BeginTransaction();
    //fill the table with some data
    for I := 0 to FDialect.MasterRowCount do
    begin
      //hack work around for MySQL
      //todo: fix hack once MySQL driver is fixed
      if AnsiCompareText(FDialect.ConnectionName, 'MySQLConnection') = 0 then
        InitializeCommandParams;

      FDataGenerator.Next;
      FDataGenerator.LockSeed;
      for J := 0 to Length(AllColumns) - 1 do
        GenerateValueForDbxParam(Command.Parameters[J],AllColumns[J]);
      FDataGenerator.UnlockSeed;

      Command.Prepare;
      Command.ExecuteQuery;

      //part of previous hack since a Command needs to be Free'd
      if AnsiCompareText(FDialect.ConnectionName, 'MySQLConnection') = 0 then
        Command.Free;


      if VerboseLoggingEnabled then
        WriteLn( 'Exec''d: ' + Command.Text );
    end;
    FConnection.CommitFreeAndNil(Transaction);
  finally
    ClearColumnInfoArray(AllColumns);
    FConnection.RollbackIncompleteFreeAndNil(Transaction);
    Command.Free;
  end;
  if VerboseLoggingEnabled then
    Writeln('Finished FillAllTypesTable: ', FDialect.ClassName);
end;

procedure TCTSDbObjects.FillDetailTable;
const
  InsertSQL = 'insert into %s values(%d,%d,%s)';
var
  I,J,ID: Integer;
begin
  ID := 1;
  for I := 1 to 4 do
    for J := 1 to I do
    begin
      ExecuteSQLStatement( Format(InsertSQL,[ TCTSDbObjects.DetailTable,ID,I,
        QuotedStr('Some data: ' + IntToStr(J)+IntToStr(I)) ] ));
      Inc(ID);
    end;
end;

procedure TCTSDbObjects.FillMasterTable;
const
  InsertSQL = 'insert into %s values(%d,%d,%s)';
var
  I: Integer;
begin
  for I := 1 to FDialect.MasterRowCount do
    ExecuteSQLStatement( Format(InsertSQL,[ TCTSDbObjects.MasterTable,I,I,
      QuotedStr('Some data: ' + IntToStr(I))]),tmCommit );
end;

function TCTSDbObjects.GetAllTypesColumns: TColumnInfoArray;
var
  I: Integer;
  TempColumns: TColumnInfoArray;
const
  IDFieldName = 'F_INT_ID';
begin
  TempColumns := BuildColumnInfoArray(FDialect.RegisteredTypes.KnownSQLTypes);
  SetLength(Result,Length(TempColumns)+1);

  Result[0] := TColumnInfo.Create(sqlInteger);
  Result[0].FieldName := IDFieldName;

  //Copy to result, taking into account ID field at position 0
  for I := 0 to High(TempColumns) do
    Result[I+1] := TempColumns[I];
end;

function TCTSDbObjects.GetAllTypesSQL: WideString;
var
  AllColumns: TColumnInfoArray;
  SQLStatement: WideString;
begin
  AllColumns := GetAllTypesColumns;
  try
    SQLStatement := FDialect.MakeCreateStatementForTypes(
      TCTSDbObjects.AlllTypesTable, AllColumns );
  finally
    ClearColumnInfoArray(AllColumns);
  end;
  Result := SQLStatement;
end;

class function TCTSDbObjects.GetAllTypesTableName: WideString;
begin
 Result :=  DBXCTSAllTypes + GetUserToken;
end;

function TCTSDbObjects.GetDetailSQL: WideString;
const
  CreateDetail = 'Create TABLE %s(ID INT, MASTERID INT, VCHARFIELD VARCHAR(32))';
begin
  Result := Format(CreateDetail,[TCTSDbObjects.DetailTable]);
end;

class function TCTSDbObjects.GetDetailTableName: WideString;
begin
 Result :=  DBXCTSDetail + GetUserToken;
end;

function TCTSDbObjects.GetMasterSQL: WideString;
const
  CreateMaster = 'Create TABLE %s(ID INT, INTFIELD INT, VCHARFIELD VARCHAR(32))';
begin
  //GetUserToken
  Result := Format(CreateMaster,[TCTSDbObjects.MasterTable]);
end;

class function TCTSDbObjects.GetMasterTableName: WideString;
begin
 Result :=  DBXCTSMaster + GetUserToken;
end;

class function TCTSDbObjects.GetUserToken: WideString;
var
  UserName: WideString;
const
  MAXTokenLength = 8;
begin
  UserName := GetEnvironmentVariable('USERNAME');
  UserName := StringReplace(UserName, '-', '_', []);
  if Length(UserName) > MAXTokenLength then
    UserName := LeftStr(UserName,MAXTokenLength);
  Result := UserName;
end;



procedure TCTSDbObjects.InitDBObjects;
begin
  FillMasterTable;
  FillDetailTable;
  FillAllTypesTable;
end;

{ TConnectedCTSHelper }

constructor TConnectedCTSHelper.Create(ADialect: TBaseDialect);
begin
    inherited Create(ADialect);
    try
      FConnection := TConnectedCTSHelper.GetConnectionFromName(
        FDialect.ConnectionName);

    finally
    end;
end;

destructor TConnectedCTSHelper.Destroy;
begin
  if Assigned(FConnection) then
    FConnection.Free;
  inherited;
end;

procedure TConnectedCTSHelper.ExecuteSQLStatement(SQL: WideString;
  TransactionType: TTransactionMode; IgnoreException: TExecuteSQLOption);
var
  Transaction: TDBXTransaction;
  Command: TDBXCommand;
  MetaData : TDBXDatabaseMetaData;
begin
  //if not FConnection.IsOpen then
    //FConnection.Open;
    
  if FConnection.IsOpen then
  begin
    try
      MetaData := FConnection.DatabaseMetaData;
      if MetaData.SupportsTransactions and (TransactionType <> tmNone) then
        Transaction := FConnection.BeginTransaction();
      try
        Command := FConnection.CreateCommand;
        Command.Text := SQL;
        Command.ExecuteQuery;

        if MetaData.SupportsTransactions and
          (TransactionType in [tmCommit, tmRollback]) then
          FConnection.CommitFreeAndNil(Transaction);

        if VerboseLoggingEnabled then
          WriteLn( 'Executed SQL: ' + #13#10#9+ SQL );
      finally
        if MetaData.SupportsTransactions and (TransactionType = tmRollback) then
          FConnection.RollbackIncompleteFreeAndNil(Transaction);
        if Assigned(Command) then
          Command.Free;
      end;
    //here I can ignore exceptions that might be raised when performing trivial
    //work with the database, e.g. "Drop Table Foo"
    except on E: Exception do
      if IgnoreException = optRaiseException then
        Raise;
    end;
  end;
end;

class function TConnectedCTSHelper.GetConnectionFromName(
    const ConnectionName: WideString): TDBXConnection;
var
  ConnectionFactory: TDBXConnectionFactory;
  ConnectionProps: TDBXProperties;
begin
  ConnectionFactory:= TDBXConnectionFactory.GetConnectionFactory;
  ConnectionProps  := ConnectionFactory.GetConnectionProperties(ConnectionName);
  Result   := ConnectionFactory.GetConnection(widestring(ConnectionProps.Properties),
    	ConnectionProps.Values[TDBXPropertyNames.UserName],
      ConnectionProps.Values[TDBXPropertyNames.Password]);
end;

{ TCTSUtils }

function TCTSUtils.BuildColumnInfoArray(
  const ForTypes: TSQLTypeSet): TColumnInfoArray;
var
  ASQLType: TSQLType;
  SQLTypes: TSQLTypeArray;
begin
  for ASQLType in ForTypes do
  begin
    SetLength(SQLTypes, Length(SQLTypes)+1);
    SQLTypes[High(SQLTypes)] := ASQLType;
  end;
  Result := BuildColumnInfoArray(SQLTypes);
  SQLTypes := nil;
end;

function TCTSUtils.BuildColumnInfoArray(
  const ForTypes: TSQLTypeArray): TColumnInfoArray;
var
  I: Integer;
  ASQLType: TSQLType;
  Columns: TColumnInfoArray;
const
  FieldNameTemplate = 'F%d_%s';

begin
  I := 0;
  for ASQLType in ForTypes do
  begin
    //instead of determining the length of the set ahead of time, just grow by 1
    SetLength(Columns, Length(Columns)+1);
    with FDialect.RegisteredTypes.TypeInfo[ASQLType] do
    begin
      if SupportsLength then
        Columns[I] := TColumnInfo.Create(ASQLType,FDialect.DefaultLength)
      else if SupportsPrecision and SupportsScale then
        Columns[I] := TColumnInfo.Create(ASQLType,FDialect.DefaultPrecision,
          FDialect.DefaultScale)
      else
        Columns[I] := TColumnInfo.Create(ASQLType);

      Columns[I].FieldName := UpperCase( Format(FieldNameTemplate,
        [I,FDialect.RegisteredTypes.SQLKeyword[ASQLType]]));
    end;
    Inc(I);
  end;
  Result := Columns;
end;

procedure TCTSUtils.ClearColumnInfoArray(Columns: TColumnInfoArray);
var
  I: Integer;
begin
  for I := Low(Columns) to High(Columns) do
    if Assigned(Columns[I]) then
      Columns[I].Free;
  Columns := nil;
end;

constructor TCTSUtils.Create(ADialect: TBaseDialect);
begin
  inherited Create;
  Assert(Assigned(ADialect), 'Invalid Dialect instance.');
  FDialect := ADialect;
  FDataGenerator := TDataGenerator.Create(FDialect);
end;

destructor TCTSUtils.Destroy;
begin
  inherited;
end;

procedure TCTSUtils.GenerateValueForDbxParam(DbxParam: TDBXParameter;
  const Column: TColumnInfo);
var
  FieldType: TFieldType;
  ExtractedBytes: TBytes;
begin
  FieldType := FDialect.RegisteredTypes.MapsTo[Column.SQLType];

  with DbxParam do
  begin
    case FieldType of
      ftString, ftFixedChar, ftMemo, ftAdt:
        Value.SetAnsiString(FDataGenerator.GetString(Column.Length));
      ftWideString, ftWideMemo, ftFixedWideChar:
{$IF DEFINED(CLR)}

        Value.SetWideString(FDataGenerator.GetWideString(Column.Length));
{$ELSE}
        Value.SetWideString(FDataGenerator.GetWideString(Column.Length));
{$IFEND}
      ftSmallint, ftWord:
        Value.SetInt16(FDataGenerator.GetInt16);
      ftAutoInc, ftInteger:
        Value.SetInt32(FDataGenerator.GetInt32);
      ftTime:
        Value.SetTime(DateTimeToTimeStamp(FDataGenerator.GetTime).Time);
      ftDate:
        Value.SetDate(DateTimeToTimeStamp(FDataGenerator.GetDate).Date);
      ftBCD, ftFMTBCD:
        if Column.SQLType = sqlLargeInt then
          Value.SetInt64(FDataGenerator.GetInt64)
        else if Column.SQLType = sqlInteger then
          Value.SetBcd(  IntegerToBcd(FDataGenerator.GetInt32) )
        else
          Value.SetBCD(FDataGenerator.GetFMTBcd(Column.Precision,Column.Scale));
      ftCurrency, ftFloat:
        Value.SetDouble( FDataGenerator.GetDouble );
      ftTimeStamp:
        Value.SetTimestamp(FDataGenerator.GetTimeStamp);
      ftBoolean:
        Value.SetBoolean( FDataGenerator.GetBoolean );
{$IF DEFINED(CLR)}
      ftBytes, ftVarBytes,
      ftBlob, ftGraphic..ftTypedBinary,ftOraBlob,ftOraClob:
      begin
        ExtractedBytes := FDataGenerator.GetByteArray(Column.Length);//Buffer.GetBytes;
        Value.SetDynamicBytes(0, ExtractedBytes, 0, Length(ExtractedBytes));
      end;
{$ELSE}
// Needed for Spacely to preserve older interface.
// CLR section above will work for both native and managed in Highlander.
      ftBytes, ftVarBytes:
      begin
        ExtractedBytes := FDataGenerator.GetByteArray(Column.Length);//Buffer.GetBytes;
        Size := Length(ExtractedBytes);
        Value.SetDynamicBytes(0, ExtractedBytes, 0, Length(ExtractedBytes));
      end;
      ftBlob, ftGraphic..ftTypedBinary,ftOraBlob:
      begin
        ExtractedBytes := FDataGenerator.GetByteArray(Column.Length);//Buffer.GetBytes;
        Size := Length(ExtractedBytes); //this seems optional, and probably only needed for outParams from SP's
        Value.SetDynamicBytes(0, ExtractedBytes, 0, Length(ExtractedBytes));
      end;
      ftOraClob:
      begin
        Value.SetAnsiString(FDataGenerator.GetString(Column.Length));
      end;
{$IFEND}
      ftArray, ftDataSet,
      ftReference, ftCursor: {Nothing};
    end;
  end;
end;

procedure TCTSUtils.SetDbxParamForColumn(Param: TDBXParameter;
  const Column: TColumnInfo);
var
  iFldType, iSubType: Word;
  DataType: TFieldType;
begin
  DataType := FDialect.RegisteredTypes.MapsTo[Column.SQLType];
  iFldType := FldTypeMap[DataType];

  //because VCL wants Int64 as FmtBCD we need to update the actual field type
  //for the TDBX layer
  if Column.SQLType = sqlLargeInt then
    iFldType := TDBXDataTypes.Int64Type;


  iSubType := 0;
  if iFldType in [TDBXDataTypes.BlobType, TDBXDataTypes.AnsiStringType] then
    iSubType := Word(FldSubTypeMap[DataType]);

  with Param do
  begin
    ChildPosition      := 0;  //ChildPosArray[I] <-- ADT or Array field type this will play a role only oracle?
    ParameterDirection := TDBXParameterDirections.InParameter;
    DataType           := iFldType;
    SubType            := iSubType;
    Size               := 0; //For in params size can be 0? otherwise use TParam.GetDataSize
    Precision          := Column.Precision;
    Scale              := Column.Scale;
    Name               := Column.FieldName;
  end;
end;

end.
