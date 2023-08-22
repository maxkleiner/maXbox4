unit VendorTestFramework;

interface

uses
   Sysutils, DB, Variants, SqlTimSt, FMTBcd;

const
  DBXCTSSEEDField = 'SEED_ID';        { Do not localize }
  DBXCTSGenFieldSuffix = '_FIELD';    { Do not localize }
  DBXNOTNULL = ' NOT NULL';           { Do not localize }
  DEFAULT_SEED = 111;

const
  ///Multibyte characters for widestr gen
  HIRAGANA_L_a =  #$3042;
  HIRAGANA_U_A =  #$3041;
  HIRAGANA_L_i =  #$3043;
  HIRAGANA_U_I =  #$3044;
  HIRAGANA_L_tu = #$3063;
  HIRAGANA_U_TU = #$3064;
  HIRAGANA_U_NI = #$306B;
  HIRAGANA_U_ZO = #$305E;
  HIRAGANA_U_SO = #$305D;
  HIRAGANA_U_MO = #$3080;
  HIRAGANA_U_YU = #$3086;
  SQUARE_DAASU  = #$3324;
  GEORGIAN_DON  = #$10A3;
  GEORGIAN_FI   = #$10F6;

  WideCharData : array[0..13] of WideChar = ( HIRAGANA_L_a, HIRAGANA_U_A,
    HIRAGANA_L_i,  HIRAGANA_U_I,  HIRAGANA_L_tu, HIRAGANA_U_TU,
    HIRAGANA_U_NI, HIRAGANA_U_ZO, HIRAGANA_U_SO, HIRAGANA_U_MO,
    HIRAGANA_U_YU, SQUARE_DAASU,  GEORGIAN_DON , GEORGIAN_FI );


type
  TSQLType = ( sqlUnknown, sqlBoolean,
    //characters and strings
    sqlVarchar, sqlFixedChar, sqlFixedWideChar, sqlWideVarchar,
    //numbers
    sqlSmallint, sqlInteger, sqlWord, sqlLargeInt, sqlFloat, sqlCurrency,
    sqlDouble, sqlNumeric, sqlDecimal, sqlAutoInc,
    //dates and times
    sqlTimeStamp, sqlTime, sqlDateTime, sqlDate,
    //binary
    sqlBytes, sqlVarBytes,  sqlBlob, sqlMemo, sqlWideMemo, sqlGraphic, sqlFmtMemo,
    sqlTypedBinary, sqlCursor, sqlADT, sqlArray, sqlOraBlob, sqlOraClob, sqlRaw,
    sqlVariant, sqlGuid );

  TSQLTypeArray = array of TSQLType;
  TVariantArray = array of Variant;

const
  //set of known SQL types
  AllSqlTypes = [sqlUnknown, sqlBoolean, sqlVarchar, sqlFixedChar,
    sqlFixedWideChar, sqlWideVarchar, sqlSmallint, sqlInteger, sqlWord,
    sqlLargeint, sqlFloat, sqlCurrency, sqlDouble, sqlNumeric, sqlDecimal,
    sqlAutoInc, sqlTimeStamp, sqlTime, sqlDateTime, sqlDate, sqlBytes,
    sqlVarBytes,  sqlBlob, sqlMemo, sqlGraphic, sqlFmtMemo, sqlTypedBinary,
    sqlCursor, sqlADT, sqlArray, sqlOraBlob, sqlOraClob, sqlVariant, sqlGuid ];

type
  {$IF CompilerVersion < 18.0 }
    TBytes = array of Byte;
  {$IFEND}

  TSQLTypeSet = set of TSQLType;

  // TTypeInfo is used to describe what the DDL will look like when types are created
  TDBTypeInfo = class
  private
    FIsSimpleDDL: Boolean;
    FSupportsPrecision: Boolean;
    FSupportsScale: Boolean;
    FSupportsLength: Boolean;
    FRequiresQuotes: Boolean;
    FUseParenthesis: Boolean;
    FNullable: Boolean;
    procedure SetSupportsPrecision( Supported: Boolean );
    procedure SetSupportsScale( Supported: Boolean );
    procedure SetSupportsLength( Supported: Boolean );
    procedure SetRequiresQuotes( QuotesRequired: Boolean );
  public
    constructor Create;
    property HasSimpleTypeDDL: Boolean read FIsSimpleDDL write FIsSimpleDDL;
    property SupportsPrecision: Boolean read FSupportsPrecision write SetSupportsPrecision;
    property SupportsScale: Boolean read FSupportsScale write SetSupportsScale;
    property SupportsLength: Boolean read FSupportsLength write SetSupportsLength;
    property RequiresQuotes: Boolean read FRequiresQuotes write SetRequiresQuotes;
    property UsesParenthesis: Boolean read FUseParenthesis write FUseParenthesis;
    property IsNullable: Boolean read FNullable write FNullable;
  end;




  TColumnInfo = class;

  TColumnInfoArray = array of TColumnInfo;

  // TColumnInfo is used to describe the metadata of a column keep read only?
  TColumnInfo = class
  private
    FSqlType: TSQLType;
    FLength : Integer;
    FPrecision: Integer;
    FScale: Integer;
    FName: WideString;
  public
    constructor Create; overload;
    constructor Create( ASqlType: TSQLType ); overload;
    constructor Create( ASqlType: TSQLType; ALength: Integer ); overload;
    constructor Create( ASqlType: TSQLType; APrecision: Integer; AScale: Integer); overload;
    constructor Create( AColumn: TColumnInfo ); overload;

    property FieldName: WideString read FName write FName;
    property SQLType: TSQLType read FSqlType;
    property Length: Integer read FLength;
    property Precision: Integer read FPrecision;
    property Scale: Integer read FScale;
  end;

  ETypeRegistryException = class(Exception);
  EInvalidRegistrationException = class(ETypeRegistryException);

  //TTypeRegistry:
  //  Dialects register the types the dialect knows about, along w/ the keyword used
  //  to create that type.
  TTypeRegistry = class
  private
    FSupportedTypes: TSQLTypeSet;
    FReqQuoteTypes: TSQLTypeSet;
    FCacheIsDirty: Boolean;
    FSQLTypeNames: array[TSQLType] of WideString;
    FTypeInfo: array[TSQLType] of TDBTypeInfo;
    FMapToFieldType: array[TSQLType] of TFieldType;
    FCount: Integer;
    function  GetTypeInfo( ASQLType: TSQLType ): TDBTypeInfo;
    function  GetMappingFromSQLType( ASQLType: TSQLType ): TFieldType;
    function  GetSQLKeyWord( ASQLType: TSQLType ): WideString;
    procedure UpdateCache;
    function  QueryQuotableTypes: TSQLTypeSet;
  public
    constructor Create;
    procedure RegisterSQLType( ASQLType: TSQLType; SQLKeyword: WideString;
      FieldMapping: TFieldType );
    procedure UnregisterSQLType( ASQLType: TSQLType);
    function  GetTypeDDL( ASQLType: TSQLType ): WideString; overload;
    function  GetTypeDDL( ASQLType: TSQLType; Length: Integer ): WideString; overload;
    function  GetTypeDDL( ASQLType: TSQLType; Precision: Integer; Scale: Integer ): WideString; overload;
    function  GetSQLType(SQLKeyword: WideString): TSQLType;

    property  TypeInfo[Index: TSQLType]: TDBTypeInfo read GetTypeInfo;
    property  MapsTo[Index: TSQLType]: TFieldType read GetMappingFromSQLType;
    property  SQLKeyword[Index: TSQLType]: WideString read GetSQLKeyWord;
    property  KnownSQLTypes: TSQLTypeSet read FSupportedTypes;
    property  TypesRequiringQuotes: TSQLTypeSet read QueryQuotableTypes;
    property  Count: Integer read FCount;
  end;

  TSQLGenMode = (sgmSQLExpr, sgmTDBX);

  TBaseDialect = class;
  TBaseDialectClass = class of TBaseDialect;

  EDialectException = Exception;
  EInvalidDialect = EDialectException;

  //TBaseDialect
  TBaseDialect = class
  private
    FTypes: TTypeRegistry;
    FMasterRowCount: Integer;
    FLength: Integer;
    FScale: Integer;
    FPrecision: Integer;
    FDefaultSeedValue: LongWord;
  strict protected
    FConnectionName: WideString;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    //Create table commands
    function  MakeCreateStatementForTypes( TableName: WideString;
      Columns: Array of TColumnInfo ): WideString;
    function  MakeCreateStatementForSQLTypes( TableName: WideString;
      SQLTypes: Array of TSQLType ): WideString;
    function  DropTableCommand(TableName: WideString): WideString; virtual;
    function  InsertIntoStatement( TableName: WideString;
      Columns: TColumnInfoArray; GenMode: TSQLGenMode = sgmTDBX ): WideString; virtual;

    function  Compare( Recieved, Expected: Variant; SQLType: TSQLType): Integer; virtual;
    function  GetTypeInfo(const VendorType: WideString ): TDBTypeInfo; virtual;
    function  QuoteStr( const AValue: String ): WideString; virtual;

    property  RegisteredTypes: TTypeRegistry read FTypes;
    property  MasterRowCount: Integer read FMasterRowCount write FMasterRowCount;
    property  DefaultLength: Integer read FLength write FLength;
    property  DefaultPrecision: Integer read FPrecision write FPrecision;
    property  DefaultScale: Integer read FScale write FScale;
    property  DefaultSeed: LongWord read FDefaultSeedValue write FDefaultSeedValue;
    property  ConnectionName: WideString read FConnectionName write FConnectionName;
  end;

  //when in dgmCreate it will update the seed
  //when in dgmCheck it doesn't modify seed
  TDataGenMode = (dgmNone, dgmUnlocked, dgmLocked);

  ///<summary>
  ///  A Class to generate data.
  ///  <Remarks>
  ///  Each time Get<DataType> is called the Seed value will update if generation is unlocked.
  ///  Calling LockSeed will allow you to call Get<DataType> for each datatype without
  ///  altering the Seed value. This might be useful for checking data after it has been
  ///  posted to a database.
  ///  Seed initialization is determined by the Dialects DefaultSeed property.
  ///  </Remarks>
  ///</summary>
  TDataGenerator = class
  private
    FSeed: LongWord;
    FInRowMode: Boolean;
    FValuesLength: Integer;
    FDefaultValuesLength: Integer;

    FDialect: TBaseDialect;
    FRowSignature: TSQLTypeArray;
    FMode: TDataGenMode;

    function  SignatureMatches(const ColumnTypes: array of TSQLType): Boolean;
    procedure SetSignature(const ColumnTypes: array of TSQLType);

    procedure SetSeed(Seed: LongWord);
    function  BytesToStr(const InBytes: TBytes): String;
    function  StrToBytes(const InString: String): TBytes;
  protected
    function  GetPrecisionScaleData( Precision: Integer; Scale: Integer ): String; virtual;
    function  GetBlobBytes( Length: Integer ): TBytes;

    function  GetsqlBooleanData: Variant; virtual;
    function  GetsqlVarcharData( Length: Integer ): Variant; virtual;
    function  GetsqlFixedCharData( Length: Integer ): Variant; virtual;
    function  GetsqlFixedWideCharData( Length: Integer ): Variant; virtual;
    function  GetsqlWideVarcharData(SLength: Integer): WideString; virtual;
    function  GetsqlSmallintData: Variant; virtual;
    function  GetsqlIntegerData: Variant; virtual;
    function  GetsqlInt64Data: Variant; virtual;
    function  GetsqlWordData: Variant; virtual;
    function  GetsqlLargeintData: Variant; virtual;
    function  GetsqlFloatData: Variant; virtual;
    function  GetsqlCurrencyData(Precision: Integer; Scale: Integer): Variant; virtual;
    function  GetsqlDoubleData: Variant; virtual;
    function  GetsqlNumericData(Precision: Integer; Scale: Integer): Variant; virtual;
    function  GetsqlDecimalData(Precision: Integer; Scale: Integer): Variant; virtual;
    function  GetsqlAutoIncData: Variant; virtual;
    function  GetsqlTimeStampData: Variant; virtual;
    function  GetsqlTimeData: Variant; virtual;
    function  GetsqlDateTimeData: Variant; virtual;
    function  GetsqlDateData: Variant; virtual;
    function  GetsqlBytesData: Variant; virtual;
    function  GetsqlVarBytesData(Length: Integer): Variant; virtual;
    function  GetsqlBlobData(Length: Integer): Variant; virtual;
    function  GetsqlMemoData: Variant; virtual;
    function  GetsqlGraphicData: Variant; virtual;
    function  GetsqlFmtMemoData: Variant; virtual;
    function  GetsqlTypedBinaryData: Variant; virtual;
    function  GetsqlCursorData: Variant; virtual;
    function  GetsqlADTData: Variant; virtual;
    function  GetsqlArrayData: Variant; virtual;
    function  GetsqlOraBlobData: Variant; virtual;
    function  GetsqlOraClobData: Variant; virtual;
    function  GetsqlVariantData(Length: Integer): Variant; virtual;
    function  GetsqlGuidData: Variant; virtual;

    procedure UpdateSeed;
  public
    constructor Create(ADialect: TBaseDialect); virtual;

    function GetString( Length: Integer ): String; virtual;
    function GetBoolean:    Boolean; virtual;
    function GetDateTime:   TDatetime; virtual;
    function GetDate: TDateTime; virtual;
    function GetTime: TDateTime; virtual;
    function GetTimeStamp:  TSQLTimeStamp; virtual;
    function GetWideString( Length:Integer): WideString; virtual;
    function GetInt16:      Smallint; virtual;
    function GetInt32:      Integer; virtual;
    function GetInt64:      Int64; virtual;
    function GetDouble:     Double; virtual;
    function GetFMTBcd( Precision: Integer; Scale: Integer): TBCD; virtual;
    function GetByteArray( Length: Integer):  TBytes; virtual;

    function GetValueForType(const SQLType: TSQLType): Variant;
      ///Return a row's worth of data matching ColumnTypes data type
      ///until the seed is changed, which will set generator to check mode
    function GenerateValuesForRow(const ColumnTypes: array of TSQLType): TVariantArray; overload;

      //Uses ColumnInfo to determin an appropiate way to assign the param
      //value. This is binding to dataset which isn't ideal, but is the only
      //way I can think of assignment without using variants
    procedure AssignParamValue( AParam: TParam; AColumn: TColumnInfo );

    procedure ResetSeed;
    procedure LockSeed;
    procedure UnlockSeed;
    procedure Next;

    //setting the seed manually puts generator into check mode
    property SeedValue: LongWord read FSeed write SetSeed;
    property GeneratorMode: TDataGenMode read FMode;
  end;




var
  ///<Summary>Used for debug output.</Summary>
  VerboseLoggingEnabled: Boolean;

implementation

uses
  StrUtils, TypInfo, DateUtils;




{ TBaseVendorDialect }

function TBaseDialect.Compare(Recieved, Expected: Variant;
  SQLType: TSQLType): Integer;
var
  LeftInt,RightInt: Int64;
  LeftDouble, RightDouble: Double;
  LeftDate, RightDate: TDateTime;
const
  Tolerance = 0.0001;
begin
  Result := -1;
  case SQLType of
  sqlBoolean:
    begin
      Result := Ord(StrToBool(VarToStr(Recieved))) - Ord(StrToBool(VarToStr(Expected)))
    end;
  sqlWideVarchar, sqlFixedWideChar:
    begin
      Result := AnsiCompareText(VarToWideStr(Expected),VarToWideStr(Recieved) );
    end;
  sqlVarchar, sqlFixedChar, sqlMemo,sqlFmtMemo:
    begin
      Result := AnsiCompareText(VarToStr(Expected),VarToStr(Recieved) );
    end;
  sqlSmallint..sqlLargeint,sqlAutoInc:
    begin
      LeftInt := Recieved; RightInt := Expected;
      if LeftInt = RightInt then Result := 0
      else if LeftInt < RightInt then Result := -1
      else Result := 1;
    end;
  sqlFloat..sqlDecimal:
    begin
      LeftDouble := StrToFloat(VarToStr(Recieved));
      RightDouble := StrToFloat(VarToStr(Expected));
      if (LeftDouble = RightDouble) or (Abs(LeftDouble-RightDouble)<Tolerance) then
        Result := 0
      else if LeftDouble < RightDouble then Result := -1
      else Result := 1;
    end;
  sqlTimeStamp..sqlDate:
    begin
      LeftDate := StrToDateTime(VarToStr(Recieved));
      RightDate := StrToDateTime(VarToStr(Recieved));
      Result := CompareDateTime(LeftDate,RightDate);
    end;
  sqlUnknown, sqlBytes,sqlVarBytes,sqlBlob,sqlGraphic,sqlTypedBinary,
    sqlCursor,sqlADT,sqlArray..sqlGuid:
      Raise Exception.Create('Compare in GenericDialect cannot handle: ' +
        GetEnumName(TypeInfo(TSQLType), Ord(SQLType)) );
  end;
end;

constructor TBaseDialect.Create;
begin
  inherited;
  FTypes := TTypeRegistry.Create;
  FConnectionName := '';
  FDefaultSeedValue := DEFAULT_SEED;
  //init default values todo: extract values to consts
  FMasterRowCount := 4;
  FLength := 12;
  FPrecision := 16;
  FScale := 4;

  //register some generic types that most vendors support
  with FTypes do
  begin
    RegisterSQLType(sqlInteger, 'INT', ftInteger );
    RegisterSQLType(sqlFloat, 'FLOAT', ftFloat );
    RegisterSQLType(sqlNumeric, 'NUMERIC', ftFMTBcd);
      TypeInfo[sqlNumeric].SupportsPrecision := True;
      TypeInfo[sqlNumeric].SupportsScale := True;
    RegisterSQLType(sqlFixedChar, 'CHAR', ftFixedChar );
      TypeInfo[sqlFixedChar].SupportsLength := True;
      TypeInfo[sqlFixedChar].RequiresQuotes := True;
    RegisterSQLType(sqlVarchar, 'VARCHAR', ftString );
      TypeInfo[sqlVarchar].SupportsLength := True;
      TypeInfo[sqlVarchar].RequiresQuotes := True;
  end;
end;

// Vendor's could override this in case the 'if exists Table' can be used
destructor TBaseDialect.Destroy;
begin
  FTypes.Free;
  inherited;
end;

function TBaseDialect.DropTableCommand(TableName: WideString): WideString;
begin
  Result := 'Drop table ' + TableName;
end;

function TBaseDialect.GetTypeInfo(const VendorType: WideString): TDBTypeInfo;
begin
  Result := nil;
  //todo: fix in highlander
  Assert(false,'GetTypeInfo must be extended from. Working around .NET compiler issue.');
end;

function TBaseDialect.InsertIntoStatement(TableName: WideString;
  Columns: TColumnInfoArray; GenMode: TSQLGenMode = sgmTDBX): WideString;
const
  InsertSQL = 'insert into %s(%s) values(%s)';
  FldTemplate = ' %s,';
  DBXMarker = ' ?,';
  SQLExprMarker = ' :p_%d,';
var
  FieldNameList: WideString;
  ParamPlaceHolders: WideString;
  I: Integer;
begin
  FieldNameList := '';
  ParamPlaceHolders := '';

  for I := 0 to High(Columns) do
  begin
    //make look like F_1, F_2, ... F_N,
    FieldNameList := FieldNameList + Format(FldTemplate,[Columns[I].FieldName]);

    if GenMode = sgmTDBX then
      ParamPlaceHolders := ParamPlaceHolders + DBXMarker //make it look like ?, ?, ?,
    else
      ParamPlaceHolders := ParamPlaceHolders + Format(SQLExprMarker,[I]);  //make look like :p_1, :p_2,
  end;

  //cleanup last comma
  Delete( FieldNameList,Length(FieldNameList), 1);
  Delete( ParamPlaceHolders, Length(ParamPlaceHolders),1);

  Result := Format(InsertSQL,[TableName,FieldNameList,ParamPlaceHolders]);
end;

function TBaseDialect.MakeCreateStatementForSQLTypes( TableName: WideString;
  SQLTypes: array of TSQLType): WideString;
var
  I: Integer;
  ColInfo: Array of TColumnInfo;
begin
  SetLength(ColInfo,Length(SQLTypes));
  for I := Low(SQLTypes) to High(SQLTypes)  do
    ColInfo[I] := TColumnInfo.Create(SQLTypes[I], DefaultLength, DefaultPrecision);
  Result := MakeCreateStatementForTypes(TableName,ColInfo);
  ColInfo := nil;
end;

function TBaseDialect.MakeCreateStatementForTypes( TableName: WideString;
  Columns: array of TColumnInfo): WideString;
const
  CreateTable = 'Create Table %s( %s )';
  FieldNameTemplate = 'F_%d';
  FieldTemplate = ' %s %s,';
var
  I: Integer;
  FieldNames: WideString;
  STemp: WideString;
begin
  FieldNames := '';
  for I := Low(Columns) to High(Columns) do
  begin
    if Columns[I].Length <> 0 then
      STemp := RegisteredTypes.GetTypeDDL(Columns[I].SQLType, Columns[I].Length)
    else if (Columns[I].Precision <> 0) then
      STemp := RegisteredTypes.GetTypeDDL(Columns[I].SQLType,
        Columns[I].Precision, Columns[I].Scale )
    else
      STemp := RegisteredTypes.GetTypeDDL(Columns[I].SQLType);

    //if name wasn't set previously, give it a name
    if Columns[I].FieldName = '' then
      Columns[I].FieldName := Format(FieldNameTemplate,[I]);
    
    FieldNames := FieldNames + Format(FieldTemplate,[Columns[I].FieldName, STemp]);
  end;

  //get rid of trailing comma
  Delete(FieldNames,Length(FieldNames),1);

  Result := Format(CreateTable,[TableName,FieldNames]);
end;

function TBaseDialect.QuoteStr(const AValue: String): WideString;
begin
  Result := QuotedStr(AValue);
end;

{ TTypeRegistry }


constructor TTypeRegistry.Create;
var
  AFieldType: TSQLType;
begin
  inherited;
  for AFieldType in AllSqlTypes do
  begin
    FSQLTypeNames[AFieldType] := '';
    FTypeInfo[AFieldType] := nil;
  end;
end;

function TTypeRegistry.GetTypeDDL(ASQLType: TSQLType): WideString;
begin
  Result := FSQLTypeNames[ASQLType];

  if not TypeInfo[ASQLType].IsNullable then
    Result := Result + DBXNOTNULL;
end;

function TTypeRegistry.GetTypeDDL(ASQLType: TSQLType;
  Length: Integer): WideString;
const
  SQLSyntax = '%s(%d)';
begin
  Result := GetTypeDDL(ASQLType);
  if TypeInfo[ASQLType].SupportsLength and TypeInfo[ASQLType].UsesParenthesis then
    Result := Format(SQLSyntax,[Result,Length]);

  if not TypeInfo[ASQLType].IsNullable then
    Result := Result + DBXNOTNULL;
end;

function TTypeRegistry.GetMappingFromSQLType( ASQLType: TSQLType ): TFieldType;
begin
  if FSQLTypeNames[ASQLType] <> '' then
    Result := FMapToFieldType[ASQLType]
  else
    Result := ftUnknown;
end;

function TTypeRegistry.GetTypeInfo(ASQLType: TSQLType): TDBTypeInfo;
begin
  if not Assigned(FTypeInfo[ASQLType]) then
    FTypeInfo[ASQLType] := TDBTypeInfo.Create;
  Result := FTypeInfo[ASQLType];
end;

function TTypeRegistry.QueryQuotableTypes: TSQLTypeSet;
begin
  //optimized in case nothing has changed in the type registry
  if FCacheIsDirty then
    UpdateCache;
  Result := FReqQuoteTypes;
end;

function TTypeRegistry.GetSQLKeyWord(ASQLType: TSQLType): WideString;
begin
  if ASQLType in FSupportedTypes then
    Result := FSQLTypeNames[ASQLType]
  else
    Result := 'Unknown';
end;

function TTypeRegistry.GetSQLType(SQLKeyword: WideString): TSQLType;
var
  SQLType: TSQLType;
begin
  Result := sqlUnknown;
  for SQLType in FSupportedTypes do
    if (WideCompareText(FSQLTypeNames[SQLType],SQLKeyword) = 0) then
    begin
      Result := SQLType;
      Break
    end;
end;

function TTypeRegistry.GetTypeDDL(ASQLType: TSQLType; Precision,
  Scale: Integer): WideString;
const
  SQLSyntax = '%s(%d,%d)';
begin
  Result := GetTypeDDL(ASQLType);
  with TypeInfo[ASQLType] do
    if SupportsPrecision and SupportsScale and UsesParenthesis then
      Result := Format(SQLSyntax,[Result,Precision,Scale]);

  if not TypeInfo[ASQLType].IsNullable then
    Result := Result + DBXNOTNULL;
end;

procedure TTypeRegistry.RegisterSQLType(ASQLType: TSQLType;
  SQLKeyword: WideString; FieldMapping: TFieldType);
const
  ErrorMsg = 'Can not register SQL Type: %s as ftUnkown'; {Do not localize}
begin
  if FieldMapping = ftUnknown then
    Raise EInvalidRegistrationException.Create(Format(ErrorMsg,[SQLKeyword]));

  if not (ASQLType in FSupportedTypes) then
    Inc(FCount);
  //let properties know their cachies are dirty
  FCacheIsDirty := True;

  Include(FSupportedTypes,ASQLType);
  FSQLTypeNames[ASQLType] := SQLKeyword;
  FMapToFieldType[ASQLType] := FieldMapping;
end;

procedure TTypeRegistry.UnregisterSQLType(ASQLType: TSQLType);
begin
  if ASQLType in FSupportedTypes then
  begin
    Dec(FCount);
    FCacheIsDirty := True;
    Exclude(FSupportedTypes,ASQLType);
    FSQLTypeNames[ASQLType] := '';
    FMapToFieldType[ASQLType] := ftUnknown;
    if Assigned(FTypeInfo[ASQLType]) then
    begin
      FTypeInfo[ASQLType].Free;
      FTypeInfo[ASQLType] := nil;
    end;
  end;
end;

procedure TTypeRegistry.UpdateCache;
var
  SQLType: TSQLType;
begin
  //optimized in case nothing has changed in the type registry
  if FCacheIsDirty then
  begin
    FReqQuoteTypes := [];
    for SQLType in KnownSQLTypes do
    begin
      if TypeInfo[SQLType].RequiresQuotes then
        Include(FReqQuoteTypes,SQLType);
    end;
    FCacheIsDirty := False;
  end;
end;

{ TTypeInfo }

constructor TDBTypeInfo.Create;
begin
  inherited;
  FIsSimpleDDL := True;
  FSupportsPrecision := False;
  FSupportsScale := False;
  FSupportsLength := False;
  FNullable := True;
  //most vendors require parens, but say Oracle Blob doesn't require this
  //so user can override behavor for sqlBlob when registering for oracle
  FUseParenthesis := True;
end;

procedure TDBTypeInfo.SetRequiresQuotes(QuotesRequired: Boolean);
begin
  FRequiresQuotes := QuotesRequired;
end;

procedure TDBTypeInfo.SetSupportsLength(Supported: Boolean);
begin
  if Supported then
    HasSimpleTypeDDL := False;
  FSupportsLength := True;
end;

procedure TDBTypeInfo.SetSupportsPrecision(Supported: Boolean);
begin
  if Supported then
    HasSimpleTypeDDL := False;
  FSupportsPrecision := Supported;
end;

procedure TDBTypeInfo.SetSupportsScale(Supported: Boolean);
begin
  if Supported then
    HasSimpleTypeDDL := False;
  FSupportsScale := Supported;
end;


{ TBaseDataGenerator }

procedure TDataGenerator.AssignParamValue(AParam: TParam;
  AColumn: TColumnInfo);
begin
  case AColumn.SQLType of
    sqlBoolean:
      AParam.AsBoolean := GetBoolean;
    sqlVarchar, sqlFixedChar:
      AParam.AsString := GetString(AColumn.Length);
    sqlFixedWideChar:
      {$IFDEF CLR}   //<-- LAME!
      AParam.AsString := GetWideString(AColumn.Length);
      {$ENDIF}
      {$IFDEF WIN32}
      AParam.AsWideString := GetWideString(AColumn.Length);
      {$ENDIF}
    sqlWideVarchar:
      {$IFDEF CLR}
      AParam.AsString := GetWideString(AColumn.Length);
      {$ENDIF}
      {$IFDEF WIN32}
      AParam.AsWideString := GetWideString(AColumn.Length);
      {$ENDIF}

    sqlSmallint:
      AParam.AsSmallInt := GetInt16;
    sqlInteger, sqlWord:
      AParam.AsInteger := GetInt32;
    sqlLargeint:
      Raise Exception.Create('Int64 not supported with Param');
    sqlFloat, sqlDouble:
      AParam.AsFloat := GetDouble;

    sqlNumeric, sqlDecimal, sqlCurrency:
      AParam.AsFMTBCD := GetFMTBcd(AColumn.Precision,AColumn.Scale);

    sqlAutoInc:
      AParam.AsInteger := 0;
    sqlTimeStamp:
      AParam.AsSQLTimeStamp := GetTimeStamp;
    sqlTime:
      AParam.AsTime := GetTime;
    sqlDateTime:
      AParam.AsDateTime := GetDateTime;
    sqlDate:
      AParam.AsDate := GetDate;
    sqlBytes, sqlVarBytes, sqlBlob:
      AParam.AsBlob := BytesToStr( GetByteArray(AColumn.Length) );
    sqlMemo:
      AParam.AsString := GetString(AColumn.Length);
    sqlOraBlob, sqlRaw:
      AParam.AsBlob := BytesToStr( GetByteArray(AColumn.Length) );
    sqlOraClob:
      AParam.AsMemo := GetString(AColumn.Length) ;

    sqlGraphic, sqlFmtMemo, sqlTypedBinary,  sqlCursor,
    sqlADT, sqlArray, sqlVariant,
    sqlGuid:
      Raise Exception.Create('Type not supported yet.');
  end;
end;

function TDataGenerator.BytesToStr(const InBytes: TBytes): String;
var
  I: Integer;
begin
  SetLength(Result,Length(InBytes));
  for I := 1 to High(InBytes) do
    Result[I] := char(InBytes[I]);
end;

constructor TDataGenerator.Create(ADialect: TBaseDialect);
begin
  inherited Create;
  //if adialectclass is of wrong type than exception should be generated...
  FDialect := ADialect;

  FDefaultValuesLength := 64;
  FValuesLength := FDefaultValuesLength; //it's possible during usage to want to grow this...
  FInRowMode := False;
  FMode := dgmNone;
  ResetSeed;
end;

function TDataGenerator.GenerateValuesForRow(const ColumnTypes: array of TSQLType): TVariantArray;
var
  I: Integer;
begin
  SetLength(Result,Length(ColumnTypes));
  if not SignatureMatches(ColumnTypes) then
    SetSignature(ColumnTypes);

  FInRowMode := True;
  for I := 0 to High(Result) do
    Result[I] := GetValueForType(ColumnTypes[I]);

  UpdateSeed;

  FInRowMode := False;
end;

function TDataGenerator.GetBlobBytes(Length: Integer): TBytes;
var
  I: Integer;
  Bytes: TBytes;
begin
  SetLength(Bytes,Length);
  for I := 0 to High(Bytes) do
    Bytes[I] := ((FSEED+I+1) mod 17) + 90; //Similar to GetString
  Result := Bytes;
end;

function TDataGenerator.GetBoolean: Boolean;
begin
  Result := GetsqlBooleanData;
  UpdateSeed;
end;

function TDataGenerator.GetByteArray(Length: Integer): TBytes;
begin
  Result := GetsqlBlobData(Length);
  UpdateSeed;
end;

function TDataGenerator.GetDate: TDateTime;
begin
  Result := GetsqlDateData;
  UpdateSeed;  
end;

function TDataGenerator.GetDateTime: TDatetime;
begin
  Result := GetsqlDateTimeData;
  UpdateSeed;
end;

function TDataGenerator.GetDouble: Double;
begin
  Result := GetsqlDoubleData;
  UpdateSeed;
end;

function TDataGenerator.GetFMTBcd(Precision: Integer; Scale: Integer): TBcd;
var
  S: String;
  BCD: TBcd;
begin
  S := GetPrecisionScaleData(Precision,Scale );
  Delete(S,1,1);
  BCD := StrToBcd(S);
  Result := BCD;
  UpdateSeed;
end;

function TDataGenerator.GetInt16: Smallint;
begin
  Result := GetsqlSmallintData;
  UpdateSeed;  
end;

function TDataGenerator.GetInt32: Integer;
begin
  Result := GetsqlIntegerData;
  UpdateSeed;  
end;

function TDataGenerator.GetInt64: Int64;
begin
  Result := GetsqlInt64Data;
  UpdateSeed;  
end;

function TDataGenerator.GetPrecisionScaleData(Precision: Integer;
  Scale: Integer): String;
var
  ScalePart: String;
  IntegerPart: String;
  I: Integer;
  S: String;
begin
  //if this types suports precision and scale then make number that looks like
  // (precision-scale-1).scale, e.g. (10,3) -> 333333.333
  if (Precision<>0) and (Scale<>0) then
  begin
    ScalePart :=  DupeString(IntTOStr(FSeed mod 9), Scale-1);
    IntegerPart := '';
    for I := 0 to Precision- Scale-1 do
      IntegerPart := IntegerPart + IntToStr(((FSeed + I) mod 9));
//    IntegerPart := DupeString(IntTOStr(FSeed mod 9),Precision- Scale-1);
    S := IntegerPart  + '.' + ScalePart;
  end
  else
    S := IntTOStr(FSeed) + '.' + IntToStr(FSeed);
  SetLength(Result, Length(S));
  Result := S;
end;

function TDataGenerator.GetsqlADTData: Variant;
begin
  Assert(false, 'Function not implemented yet.');
end;

function TDataGenerator.GetsqlArrayData: Variant;
begin
  Assert(false, 'Function not implemented yet.');
end;

function TDataGenerator.GetsqlAutoIncData: Variant;
begin
  Assert(false, 'Function not implemented yet.');
end;

function TDataGenerator.GetsqlBlobData(Length: Integer): Variant;
begin
  Result := GetBlobBytes(Length);
end;

function TDataGenerator.GetsqlBooleanData: Variant;
begin
  // return seed's parity
  Result := FSeed mod 2 = 1
end;

function TDataGenerator.GetsqlBytesData: Variant;
begin
  Assert(false, 'Function not implemented yet.');
end;

function TDataGenerator.GetsqlCurrencyData(Precision: Integer; Scale: Integer): Variant;
begin
  Result := GetPrecisionScaleData( Precision, Scale);
end;

function TDataGenerator.GetsqlCursorData: Variant;
begin
  Assert(false, 'Function not implemented yet.');
end;

//use current seed value to generate year / month / day
//(using mod operator to keep dates within range
function TDataGenerator.GetsqlDateData: Variant;
const
  BaseYear = 1990;
begin
  // the mod value is chosen to be something less than the max number of the base units...
  // so there is nothing special about 25, 11 aside from that it garuntees
  // to fit the domain.
  Result := EncodeDate(BaseYear+FSeed, (FSeed mod 11)+1, (FSeed mod 25)+1);
end;

function TDataGenerator.GetsqlDateTimeData: Variant;
const
  BaseYear = 1990;
begin
  // the mod value is chosen to be something less than the max number of the base units...
  // so there is nothing special about 25, 53 11 or 57 aside from that it garuntees
  // to fit the domain.
  Result := EncodeDateTime(BaseYear+FSeed, (FSeed mod 11)+1, (FSeed mod 25)+1,
    (FSeed mod 11)+1, (FSeed mod 53)+1, (FSeed mod 57)+1, FSeed  );
end;

function TDataGenerator.GetsqlDecimalData(Precision: Integer; Scale: Integer): Variant;
begin
  Result := GetPrecisionScaleData(Precision,Scale);
end;

function TDataGenerator.GetsqlDoubleData: Variant;
begin
  Result := StrToFloat( GetPrecisionScaleData(0,0) );
end;

//generate char data
function TDataGenerator.GetsqlFixedCharData(Length: Integer): Variant;
var
  I: Integer;
  S: String;
begin
  S := '';
  if Length > 0 then
    for I := 1 to Length  do
      S := S + Char(65+((FSEED+I) mod 31))
  else
    S := Char(65+((FSEED) mod 31));
  Result := S;
end;

function TDataGenerator.GetsqlFixedWideCharData( Length: Integer ): Variant;
begin
  Assert(false, 'Function not implemented yet.');
end;

function TDataGenerator.GetsqlFloatData: Variant;
begin
  Result := GetPrecisionScaleData(0,0);
end;

function TDataGenerator.GetsqlFmtMemoData: Variant;
begin
  Assert(false, 'Function not implemented yet.');
end;

function TDataGenerator.GetsqlGraphicData: Variant;
begin
  Assert(false, 'Function not implemented yet.');
end;

function TDataGenerator.GetsqlGuidData: Variant;
const
  sGUID = '{%s-%s-%s-%s-%s}';
begin
  // Make guid out of Seed, eg ['{33333333-3333-3333-3333-333333333333}']
  Result := Format(sGUID,[DupeString(IntToStr(FSeed),8),
    DupeString(IntToStr(FSeed),4),
    DupeString(IntToStr(FSeed),4),
    DupeString(IntToStr(FSeed),4),
    DupeString(IntToStr(FSeed),12)]);
end;

function TDataGenerator.GetsqlInt64Data: Variant;
begin
  Result := FSeed;//High(Int64) - FSeed;
end;

function TDataGenerator.GetsqlIntegerData: Variant;
begin
  Result := FSeed;
end;

function TDataGenerator.GetsqlLargeintData: Variant;
begin
  Result := FSeed;
end;

function TDataGenerator.GetsqlMemoData: Variant;
begin
  Result := DupeString('Memo Data ', 100);
end;

function TDataGenerator.GetsqlNumericData(Precision: Integer; Scale: Integer): Variant;
begin
  Result := GetPrecisionScaleData(Precision,Scale);
end;

function TDataGenerator.GetsqlOraBlobData: Variant;
begin
  Assert(false, 'Function not implemented yet.');
end;

function TDataGenerator.GetsqlOraClobData: Variant;
begin
  Assert(false, 'Function not implemented yet.');
end;

function TDataGenerator.GetsqlSmallintData: Variant;
begin
  Result := FSeed mod 255;
end;

function TDataGenerator.GetsqlTimeData: Variant;
begin
  Result := EncodeTime((FSeed mod 12), ((FSeed + 59) mod 60),((FSeed + 59) mod 60),0);
end;

//cast result as VarToSQLTimeStamp() when time to use it
function TDataGenerator.GetsqlTimeStampData: Variant;
var
  TempDateTime: TDateTime;
begin
  //lame, for some reason delphi .NET doesn't have VarToDateTime?
  Result := VarSQLTimeStampCreate(DateTimeToStr( GetsqlDateTimeData ));
end;

function TDataGenerator.GetsqlTypedBinaryData: Variant;
begin
  Assert(false, 'Function not implemented yet.');
end;

function TDataGenerator.GetsqlVarBytesData(Length: Integer): Variant;
begin
  Result := GetBlobBytes(Length);
end;

function TDataGenerator.GetsqlVarcharData(Length: Integer): Variant;
var
  I: Integer;
  S: String;
begin
  SetLength(S,Length);
  for I := 1 to Length  do
    S[I] := Char(((FSEED+I) mod 17) + 90);
  Result := S;
end;

function TDataGenerator.GetsqlVariantData(Length: Integer): Variant;
begin
  Result := GetBlobBytes(Length);
end;

function TDataGenerator.GetsqlWideVarcharData(SLength: Integer): WideString;
var
  Data: WideString;
  I: Integer;
  AWord: Word;
begin

  SetLength(Data,SLength);
  Data[1] := HIRAGANA_L_a;//First character is always #$3042;
  for I := 2 to Length(Data) do
  begin
    AWord := Word(WideCharData[ I mod (Length(WideCharData)-1) ]);
    Data[I] := WideCharData[ I mod (Length(WideCharData)-1) ];
  end;
  Result := Data;
end;

function TDataGenerator.GetsqlWordData: Variant;
begin
  Result := FSeed;
end;

function TDataGenerator.GetString(Length: Integer ): String;
begin
  Result := GetsqlVarcharData(Length);
  UpdateSeed;
end;

function TDataGenerator.GetTime: TDateTime;
begin
  Result := GetsqlTimeData;
  UpdateSeed;  
end;

function TDataGenerator.GetTimeStamp: TSQLTimeStamp;
begin
  Result := VarToSQLTimeStamp( GetsqlTimeStampData );
  UpdateSeed;  
end;

function TDataGenerator.GetValueForType(const SQLType: TSQLType): Variant;
begin
  Result := Null;
  with FDialect do
  begin
    case SQLType of
      sqlUnknown: Result := Null;
      sqlBoolean: Result := GetsqlBooleanData;
      sqlVarchar: Result := GetsqlVarcharData(DefaultLength);
      sqlFixedChar: Result := GetsqlFixedCharData(DefaultLength);
      sqlFixedWideChar: Result := GetsqlFixedWideCharData(DefaultLength);
      sqlWideVarchar: Result := GetsqlWideVarcharData(DefaultLength);
      sqlSmallint: Result := GetsqlSmallintData;
      sqlInteger: Result := GetsqlIntegerData;
      sqlWord: Result := GetsqlWordData;
      sqlLargeint: Result := GetsqlLargeintData;
      sqlFloat: Result := GetsqlFloatData;
      sqlCurrency: Result := GetsqlCurrencyData(DefaultPrecision,DefaultScale);
      sqlDouble: Result := GetsqlDoubleData;
      sqlNumeric:  Result := GetsqlNumericData(DefaultPrecision,DefaultScale);
      sqlDecimal:  Result := GetsqlDecimalData(DefaultPrecision,DefaultScale);
      sqlAutoInc:  Result := GetsqlAutoIncData;
      sqlTimeStamp:  Result := GetsqlTimeStampData;
      sqlTime:  Result := GetsqlTimeData;
      sqlDateTime:  Result := GetsqlDateTimeData;
      sqlDate:  Result := GetsqlDateData;
      sqlBytes:  Result := GetsqlBytesData;
      sqlVarBytes:  Result := GetsqlVarBytesData(DefaultLength);
      sqlBlob:  Result := GetsqlBlobData(DefaultLength);
      sqlMemo:  Result := GetsqlMemoData;
      sqlGraphic:  Result := GetsqlGraphicData;
      sqlFmtMemo:  Result := GetsqlFmtMemoData;
      sqlTypedBinary:  Result := GetsqlTypedBinaryData;
      sqlCursor:  Result := GetsqlCursorData;
      sqlADT: Result := GetsqlADTData;
      sqlArray: Result := GetsqlArrayData;
      sqlOraBlob: Result := GetsqlOraBlobData;
      sqlOraClob: Result := GetsqlOraClobData;
      sqlVariant: Result := GetsqlVariantData(DefaultLength);
      sqlGuid: Result := GetsqlGuidData;
    end;
  end;
end;

function TDataGenerator.GetWideString(Length:Integer): WideString;
begin
  Result := GetsqlWideVarcharData(Length);
  UpdateSeed;
end;

procedure TDataGenerator.LockSeed;
begin
  FMode := dgmLocked;
end;

procedure TDataGenerator.Next;
begin
  if FMode <> dgmLocked then
    Inc(FSeed);
end;

procedure TDataGenerator.ResetSeed;
begin
  FSeed := FDialect.DefaultSeed;
  FMode := dgmUnlocked;
end;


function TDataGenerator.SignatureMatches(
  const ColumnTypes: array of TSQLType): Boolean;
var
  I: Integer;
begin
  Result := False;
  if Assigned(FRowSignature) then
  begin
    //if they have the same bounds, and every type is the same at each index
    //then the signatures can be considered the same.
    if (Low(FRowSignature)=Low(ColumnTypes)) and
      (High(FRowSignature) = High(ColumnTypes)) then
      for I := Low(FRowSignature) to High(FRowSignature) do
        Result := FRowSignature[I] = ColumnTypes[I];
  end
end;

function TDataGenerator.StrToBytes(const InString: String): TBytes;
var
  I: Integer;
begin
  SetLength(Result,Length(InString));
  for I := 1 to Length(InString) do
    Result[I-1] := Byte(InString[I]);
end;

procedure TDataGenerator.UnlockSeed;
begin
  FMode := dgmUnlocked;
end;

procedure TDataGenerator.UpdateSeed;
begin
  if FMode = dgmUnlocked then
    Inc(FSeed);
end;

procedure TDataGenerator.SetSeed(Seed: LongWord);
begin
  if Seed >= 0 then
  begin
    FSeed := Seed;
    FMode := dgmUnlocked;
  end;
end;

procedure TDataGenerator.SetSignature(const ColumnTypes: array of TSQLType);
var
  I: Integer;
begin
  FRowSignature := nil;

  SetLength(FRowSignature,Length(ColumnTypes));
  for I := Low(ColumnTypes) to High(ColumnTypes) do
    FRowSignature[I] := ColumnTypes[I];
  ResetSeed;
end;


{ TColumnInfo }

constructor TColumnInfo.Create(ASqlType: TSQLType);
begin
  inherited Create;
  FSqlType:= ASqlType;
end;

constructor TColumnInfo.Create;
begin
  inherited Create;
  FSqlType:= sqlUnknown;
end;

constructor TColumnInfo.Create(ASqlType: TSQLType; APrecision, AScale: Integer);
begin
  Create(ASqlType);
  FPrecision := APrecision;
  FScale := AScale;
end;

constructor TColumnInfo.Create(ASqlType: TSQLType; ALength: Integer);
begin
  Create(ASQLType);
  FLength := ALength;
end;

constructor TColumnInfo.Create(AColumn: TColumnInfo);
begin
  inherited Create;
  if Assigned(AColumn) then
  begin
    FSqlType := AColumn.SQLType;
    FLength := AColumn.Length;
    FPrecision := AColumn.Precision;
    FScale := AColumn.Scale;
  end;
end;

initialization
  //probably better to detect this on the command line
  VerboseLoggingEnabled := True;

end.
