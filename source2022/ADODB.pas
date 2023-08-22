
{*************************************************************}
{                                                             }
{       Borland Delphi Visual Component Library               }
{       ADO Components                                        }
{                                                             }
{       Copyright (c) 1999-2005 Borland Software Corporation  }
{                                                             }
{*************************************************************}

unit ADODB;

interface

{$R-,Q-}

uses
  Windows, Variants, ActiveX, SysUtils, Classes, TypInfo, DB, OleDB, ADOInt, WideStrings;

type

{ Forward declarations }

  TADOCommand = class;
  TCustomADODataSet = class;
  TADODataSet = class;
  TParameters = class;
  TADOConnection = class;

{ Redclare ADO types exposed by this unit }

  _Connection = ADOInt._Connection;
{$EXTERNALSYM _Connection}
  _Command = ADOInt._Command;
{$EXTERNALSYM _Command}
  _Recordset = ADOInt.Recordset;
{$EXTERNALSYM _Recordset}
  Error = ADOInt.Error;
{$EXTERNALSYM Error}
  Errors = ADOInt.Errors;
{$EXTERNALSYM Errors}
  _Parameter = ADOInt._Parameter;
{$EXTERNALSYM _Parameter}
  Parameters = ADOInt.Parameters;
{$EXTERNALSYM Parameters}
  Property_ = ADOInt.Property_;
{$EXTERNALSYM Property_}
  Properties = ADOInt.Properties;
{$EXTERNALSYM Properties}

{ Errors }

  EADOError = class(EDatabaseError);

{ TADOConnection }

  TConnectMode = (cmUnknown, cmRead, cmWrite, cmReadWrite, cmShareDenyRead,
    cmShareDenyWrite, cmShareExclusive, cmShareDenyNone);

  TConnectOption = (coConnectUnspecified, coAsyncConnect);

  TCursorLocation = (clUseServer, clUseClient);

  TCursorType = (ctUnspecified, ctOpenForwardOnly, ctKeyset, ctDynamic,
    ctStatic);

  TEventStatus = (esOK, esErrorsOccured, esCantDeny, esCancel, esUnwantedEvent);

  TExecuteOption = (eoAsyncExecute, eoAsyncFetch, eoAsyncFetchNonBlocking,
    eoExecuteNoRecords);
  TExecuteOptions = set of TExecuteOption;

  TIsolationLevel = (ilUnspecified, ilChaos, ilReadUncommitted, ilBrowse,
    ilCursorStability, ilReadCommitted, ilRepeatableRead, ilSerializable,
    ilIsolated);

  TADOLockType = (ltUnspecified, ltReadOnly, ltPessimistic, ltOptimistic,
    ltBatchOptimistic);

  TObjectState = (stClosed, stOpen, stConnecting, stExecuting, stFetching);
  TObjectStates = set of TObjectState;

  TSchemaInfo = (siAsserts, siCatalogs, siCharacterSets, siCollations,
    siColumns, siCheckConstraints, siConstraintColumnUsage,
    siConstraintTableUsage, siKeyColumnUsage, siReferentialConstraints,
    siTableConstraints, siColumnsDomainUsage, siIndexes, siColumnPrivileges,
    siTablePrivileges, siUsagePrivileges, siProcedures, siSchemata,
    siSQLLanguages, siStatistics, siTables, siTranslations, siProviderTypes,
    siViews, siViewColumnUsage, siViewTableUsage, siProcedureParameters,
    siForeignKeys, siPrimaryKeys, siProcedureColumns, siDBInfoKeywords,
    siDBInfoLiterals, siCubes, siDimensions, siHierarchies, siLevels,
    siMeasures, siProperties, siMembers, siProviderSpecific);

  TXactAttribute = (xaCommitRetaining, xaAbortRetaining);
  TXactAttributes = set of TXactAttribute;

  TBeginTransCompleteEvent = procedure(Connection: TADOConnection;
    TransactionLevel: Integer; const Error: Error;
    var EventStatus: TEventStatus) of object;

  TCommandType = (cmdUnknown, cmdText, cmdTable, cmdStoredProc, cmdFile, cmdTableDirect);

  TConnectErrorEvent = procedure(Connection: TADOConnection;
    const Error: Error; var EventStatus: TEventStatus) of object;

  TDisconnectEvent = procedure(Connection: TADOConnection;
    var EventStatus: TEventStatus) of object;

  TExecuteCompleteEvent = procedure(Connection: TADOConnection;
    RecordsAffected: Integer; const Error: Error;  var EventStatus: TEventStatus;
    const Command: _Command; const Recordset: _Recordset) of object;

  TWillConnectEvent = procedure(Connection: TADOConnection;
    var ConnectionString, UserID, Password: WideString;
    var ConnectOptions: TConnectOption; var EventStatus: TEventStatus) of object;

  TWillExecuteEvent = procedure(Connection: TADOConnection;
    var CommandText: WideString; var CursorType: TCursorType;
    var LockType: TADOLockType; var CommandType: TCommandType;
    var ExecuteOptions: TExecuteOptions; var EventStatus: TEventStatus;
    const Command: _Command; const Recordset: _Recordset) of object;

  TInfoMessageEvent = procedure(Connection: TADOConnection; const Error: Error;
    var EventStatus: TEventStatus) of object;

  TADOConnection = class(TCustomConnection, IUnknown, ConnectionEventsVT)
  private
    FCommands: TList;
    FConnectionObject: _Connection;
    FConnEventsID: Integer;
    FConnectionString: WideString;
    FDefaultDatabase: WideString;
    FUserID: WideString;
    FPassword: WideString;
    FConnectOptions: TConnectOption;
    FIsolationLevel: TIsolationLevel;
    FTransactionLevel: Integer;
    FKeepConnection: Boolean;
    FOnBeginTransComplete: TBeginTransCompleteEvent;
    FOnConnectComplete: TConnectErrorEvent;
    FOnCommitTransComplete: TConnectErrorEvent;
    FOnRollbackTransComplete: TConnectErrorEvent;
    FOnDisconnect: TDisconnectEvent;
    FOnInfoMessage: TInfoMessageEvent;
    FOnWillConnect: TWillConnectEvent;
    FOnExecuteComplete: TExecuteCompleteEvent;
    FOnWillExecute: TWillExecuteEvent;
    procedure ClearRefs;
    function IsProviderStored: Boolean;
    function IsDefaultDatabaseStored: Boolean;
    function GetADODataSet(Index: Integer): TCustomADODataSet;
    function GetAttributes: TXactAttributes;
    function GetCommand(Index: Integer): TADOCommand;
    function GetCommandCount: Integer;
    function GetCommandTimeout: Integer;
    function GetConnectionString: WideString;
    function GetConnectionTimeout: Integer;
    function GetCursorLocation: TCursorLocation;
    function GetDefaultDatabase: WideString;
    function GetIsolationLevel: TIsolationLevel;
    function GetMode: TConnectMode;
    function GetProperties: Properties;
    function GetProvider: WideString;
    function GetState: TObjectStates;
    function GetVersion: WideString;
    procedure SetAttributes(const Value: TXactAttributes);
    procedure SetCommandTimeout(const Value: Integer);
    procedure SetConnectionString(const Value: WideString);
    procedure SetConnectionTimeout(const Value: Integer);
    procedure SetCursorLocation(const Value: TCursorLocation);
    procedure SetDefaultDatabase(const Value: WideString);
    procedure SetIsolationLevel(const Value: TIsolationLevel);
    procedure SetMode(const Value: TConnectMode);
    procedure SetProvider(const Value: WideString);
    procedure SetConnectOptions(const Value: TConnectOption);
    function GetInTransaction: Boolean;
    procedure SetConnectionObject(const Value: _Connection);
    procedure SetKeepConnection(const Value: Boolean);
  protected
    { ConnectionEvents }
    function ConnectionPoint: IConnectionPoint;
    procedure InfoMessage(const pError: Error; var adStatus: EventStatusEnum;
      const pConnection: _Connection); safecall;
    procedure BeginTransComplete(TransactionLevel: Integer; const pError: Error;
      var adStatus: EventStatusEnum; const pConnection: _Connection); safecall;
    procedure CommitTransComplete(const pError: Error; var adStatus: EventStatusEnum;
      const pConnection: _Connection); safecall;
    procedure RollbackTransComplete(const pError: Error; var adStatus: EventStatusEnum;
      const pConnection: _Connection); safecall;
    procedure WillExecute(var Source: WideString; var CursorType: CursorTypeEnum;
      var LockType: LockTypeEnum; var Options: Integer;
      var adStatus: EventStatusEnum; const pCommand: _Command;
      const pRecordset: _Recordset; const pConnection: _Connection); safecall;
    procedure ExecuteComplete(RecordsAffected: Integer; const pError: Error;
      var adStatus: EventStatusEnum; const pCommand: _Command;
      const pRecordset: _Recordset; const pConnection: _Connection); safecall;
    procedure WillConnect(var ConnectionString: WideString; var UserID: WideString;
      var Password: WideString; var Options: Integer;
      var adStatus: EventStatusEnum; const pConnection: _Connection); safecall;
    procedure ConnectComplete(const pError: Error; var adStatus: EventStatusEnum;
      const pConnection: _Connection); safecall;
    procedure Disconnect(var adStatus: EventStatusEnum; const pConnection: _Connection); safecall;
  protected
    procedure CheckActive;
    procedure CheckDisconnect; virtual;
    procedure CheckInactive;
    procedure DoConnect; override;
    procedure DoDisconnect; override;
    function GetConnected: Boolean; override;
    function GetErrors: Errors;
    procedure Loaded; override;
    procedure RegisterClient(Client: TObject; Event: TConnectChangeEvent = nil); override;
    procedure UnRegisterClient(Client: TObject); override;
    procedure WaitForConnectComplete; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function BeginTrans: Integer;
    procedure Cancel;
    procedure CommitTrans;
    procedure Execute(const CommandText: WideString; var RecordsAffected: Integer;
      const ExecuteOptions: TExecuteOptions = [eoExecuteNoRecords]); overload;
    function Execute(const CommandText: WideString;
      const CommandType: TCommandType = cmdText; const ExecuteOptions: TExecuteOptions = []): _Recordset; overload;
    procedure GetProcedureNames(List: TWideStrings); overload;
    procedure GetProcedureNames(List: TStrings); overload;
    procedure GetFieldNames(const TableName: WideString; List: TWideStrings); overload;
    procedure GetFieldNames(const TableName: string; List: TStrings); overload;
    procedure GetTableNames(List: TWideStrings; SystemTables: Boolean = False); overload;
    procedure GetTableNames(List: TStrings; SystemTables: Boolean = False); overload;
    procedure Open(const UserID: WideString; const Password: WideString); overload;
    procedure OpenSchema(const Schema: TSchemaInfo; const Restrictions: OleVariant;
      const SchemaID: OleVariant; DataSet: TADODataSet);
    procedure RollbackTrans;
    property ConnectionObject: _Connection read FConnectionObject write SetConnectionObject;
    property CommandCount: Integer read GetCommandCount;
    property Commands[Index: Integer]: TADOCommand read GetCommand;
    property DataSets[Index: Integer]: TCustomADODataSet read GetADODataSet;
    property Errors: Errors read GetErrors;
    property InTransaction: Boolean read GetInTransaction;
    property Properties: Properties read GetProperties;
    property State: TObjectStates read GetState;
    property Version: WideString read GetVersion;
  published
    property Attributes: TXactAttributes read GetAttributes write SetAttributes default [];
    property CommandTimeout: Integer read GetCommandTimeout write SetCommandTimeout default 30;
    property Connected;
    property ConnectionString: WideString read GetConnectionString write SetConnectionString;
    property ConnectionTimeout: Integer read GetConnectionTimeout write SetConnectionTimeout default 15;
    property ConnectOptions: TConnectOption read FConnectOptions write SetConnectOptions default coConnectUnspecified;
    property CursorLocation: TCursorLocation read GetCursorLocation write SetCursorLocation default clUseClient;
    property DefaultDatabase: WideString read GetDefaultDatabase write SetDefaultDatabase stored IsDefaultDatabaseStored;
    property IsolationLevel: TIsolationLevel read GetIsolationLevel write SetIsolationLevel default ilCursorStability;
    property KeepConnection: Boolean read FKeepConnection write SetKeepConnection default True;
    property LoginPrompt default True;
    property Mode: TConnectMode read GetMode write SetMode default cmUnknown;
    property Provider: WideString read GetProvider write SetProvider stored IsProviderStored;
    { Events }
    property AfterConnect;
    property BeforeConnect;
    property AfterDisconnect;
    property BeforeDisconnect;
    property OnDisconnect: TDisconnectEvent read FOnDisconnect write FOnDisconnect;
    property OnInfoMessage: TInfoMessageEvent read FOnInfoMessage write FOnInfoMessage;
    property OnBeginTransComplete: TBeginTransCompleteEvent read FOnBeginTransComplete write FOnBeginTransComplete;
    property OnCommitTransComplete: TConnectErrorEvent read FOnCommitTransComplete write FOnCommitTransComplete;
    property OnRollbackTransComplete: TConnectErrorEvent read FOnRollbackTransComplete write FOnRollbackTransComplete;
    property OnConnectComplete: TConnectErrorEvent read FOnConnectComplete write FOnConnectComplete;
    property OnWillConnect: TWillConnectEvent read FOnWillConnect write FOnWillConnect;
    property OnExecuteComplete: TExecuteCompleteEvent read FOnExecuteComplete write FOnExecuteComplete;
    property OnWillExecute: TWillExecuteEvent read FOnWillExecute write FOnWillExecute;
    property OnLogin;
  end;

{ TRDSConnection }

  TRDSConnection = class(TCustomConnection)
  private
    FDataSpace: DataSpace;
    FComputerName: WideString;
    FServerName: WideString;
    FAppServer: OleVariant;
    FInternetTimeout: Integer;
    FIsAppServer: Boolean;
    procedure CheckInactive;
    procedure ClearRefs;
    procedure SetServerName(const Value: WideString);
    procedure SetComputerName(const Value: WideString);
  protected
    procedure DoConnect; override;
    procedure DoDisconnect; override;
    function GetConnected: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetRecordset(const CommandText: WideString;
      ConnectionString: WideString = ''): _Recordset;
    property AppServer: OleVariant read FAppServer;
    property DataSpaceObject: DataSpace read FDataSpace;
  published
    property ComputerName: WideString read FComputerName write SetComputerName;
    property Connected;
    property InternetTimeout: Integer read FInternetTimeout write FInternetTimeout default 0;
    property ServerName: WideString read FServerName write SetServerName stored FIsAppServer;
    property AfterConnect;
    property AfterDisconnect;
    property BeforeConnect;
    property BeforeDisconnect;
  end;

{ TParameter }

  TDataType = TFieldType;
  TParameterAttribute = (paSigned, paNullable, paLong);
  TParameterAttributes = set of TParameterAttribute;
  TParameterDirection = (pdUnknown, pdInput, pdOutput, pdInputOutput,
    pdReturnValue);

  TParameter = class(TCollectionItem)
  private
    FParameter: _Parameter;
    function GetAttributes: TParameterAttributes;
    function GetDataType: TDataType;
    function GetName: WideString;
    function GetNumericScale: Byte;
    function GetParameter: _Parameter;
    function GetParameterDirection: TParameterDirection;
    function GetPrecision: Byte;
    function GetProperties: Properties;
    function GetSize: Integer;
    function GetValue: Variant;
    procedure SetAttributes(const Value: TParameterAttributes);
    procedure SetDataType(const Value: TDataType);
    procedure SetName(const Value: WideString);
    procedure SetNumericScale(const Value: Byte);
    procedure SetParameterDirection(const Value: TParameterDirection);
    procedure SetPrecision(const Value: Byte);
    procedure SetSize(const Value: Integer);
    procedure SetValue(const Value: Variant);
    function GetParameters: TParameters;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function GetDisplayName: string; override;
    function IsEqual(Value: TParameter): Boolean;
  public
    procedure Assign(Source: TPersistent); override;
    procedure AppendChunk(Val: OleVariant);
    procedure LoadFromFile(const FileName: string; DataType: TDataType);
    procedure LoadFromStream(Stream: TStream; DataType: TDataType);
    property ParameterObject: _Parameter read GetParameter;
    property Parameters: TParameters read GetParameters;
    property Properties: Properties read GetProperties;
  published
    property Name: WideString read GetName write SetName;
    property Attributes: TParameterAttributes read GetAttributes write SetAttributes default [];
    property DataType: TDataType read GetDataType write SetDataType default ftUnknown;
    property Direction: TParameterDirection read GetParameterDirection write SetParameterDirection default pdInput;
    property NumericScale: Byte read GetNumericScale write SetNumericScale default 0;
    property Precision: Byte read GetPrecision write SetPrecision default 0;
    property Size: Integer read GetSize write SetSize default 0;
    property Value: Variant read GetValue write SetValue;
  end;

{ TParameters }

  TPropList = array of PPropInfo;

  TParameters = class(TOwnedCollection)
  private
    FModified: Boolean;
    function GetCommand: TADOCommand;
    function GetItem(Index: Integer): TParameter;
    function GetParamCollection: Parameters;
    function GetParamValue(const ParamName: WideString): Variant;
    procedure SetItem(Index: Integer; const Value: TParameter);
    procedure SetParamValue(const ParamName: WideString; const Value: Variant);
  protected
    function Create_Parameter(const Name: WideString;
      DataType: TDataType; Direction: TParameterDirection = pdInput;
      Size: Integer = 0): _Parameter;
    function GetAttrCount: Integer; override;
    function GetAttr(Index: Integer): string; override;
    function GetItemAttr(Index, ItemIndex: Integer): string; override;
    function InternalRefresh: Boolean;
    procedure AppendParameters;
    procedure Update(Item: TCollectionItem); override;
    property Modified: Boolean read FModified;
  public
    function AddParameter: TParameter;
    procedure AssignValues(Value: TParameters);
    function CreateParameter(const Name: WideString; DataType: TDataType;
      Direction: TParameterDirection; Size: Integer; Value: OleVariant): TParameter;
    function FindParam(const Value: WideString): TParameter;
    procedure GetParamList(List: TList; const ParamNames: WideString);
    function IsEqual(Value: TParameters): Boolean;
    function ParamByName(const Value: WideString): TParameter;
    function ParseSQL(SQL: WideString; DoCreate: Boolean): WideString;
    function Refresh: Boolean;
    property ParamValues[const ParamName: WideString]: Variant read GetParamValue write SetParamValue;
    property Command: TADOCommand read GetCommand;
    property Items[Index: Integer]: TParameter read GetItem write SetItem; default;
    property ParameterCollection: Parameters read GetParamCollection;
  end;

{ TADOCommand }

  TADOCommand = class(TComponent)
  private
    FCommandObject: _Command;
    FConnection: TADOConnection;
    FConnectionString: WideString;
    FCommandText: WideString;
    FCommandTextAlias: string;
    FComponentRef: TComponent;
    FExecuteOptions: TExecuteOptions;
    FParameters: TParameters;
    FConnectionFlags: set of 1..8;
    FParamCheck: Boolean;
    function GetCommandTimeOut: Integer;
    function GetCommandType: TCommandType;
    function GetPrepared: WordBool;
    function GetProperties: Properties;
    function GetState: TObjectStates;
    procedure SetCommandTimeOut(const Value: Integer);
    procedure SetComandType(const Value: TCommandType);
    procedure SetConnection(const Value: TADOConnection);
    procedure SetConnectionString(const Value: WideString);
    procedure SetParameters(const Value: TParameters);
    procedure SetPrepared(const Value: WordBool);
    function GetActiveConnection: _Connection;
  protected
    procedure AssignCommandText(const Value: WideString; Loading: Boolean = False);
    procedure CheckCommandText;
    procedure ClearActiveConnection;
    function ComponentLoading: Boolean;
    procedure ConnectionStateChange(Sender: TObject; Connecting: Boolean);
    procedure Initialize(DoAppend: Boolean = True); virtual;
    procedure OpenConnection; virtual;
    procedure SetCommandText(const Value: WideString); virtual;
    function SetConnectionFlag(Flag: Integer; Value: Boolean): Boolean; virtual;
    property ActiveConnection: _Connection read GetActiveConnection;
    property CommandTextAlias: string read FCommandTextAlias write FCommandTextAlias;
    property ComponentRef: TComponent read FComponentRef write FComponentRef;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Cancel;
    function Execute: _Recordset; overload;
    function Execute(const Parameters: OleVariant): _Recordset; overload;
    function Execute(var RecordsAffected: Integer; const Parameters: OleVariant): _Recordset; overload;
    property CommandObject: _Command read FCommandObject;
    property Properties: Properties read GetProperties;
    property States: TObjectStates read GetState;
  published
    property CommandText: WideString read FCommandText write SetCommandText;
    property CommandTimeout: Integer read GetCommandTimeOut write SetCommandTimeOut default 30;
    property CommandType: TCommandType read GetCommandType write SetComandType default cmdText;
    property Connection: TADOConnection read FConnection write SetConnection;
    property ConnectionString: WideString read FConnectionString write SetConnectionString;
    property ExecuteOptions: TExecuteOptions read FExecuteOptions write FExecuteOptions default [];
    property Prepared: WordBool read GetPrepared write SetPrepared default False;
    property Parameters: TParameters read FParameters write SetParameters;
    property ParamCheck: Boolean read FParamCheck write FParamCheck default True;
  end;

{ TCustomADODataSet }

  TCursorOption = (coHoldRecords, coMovePrevious, coAddNew, coDelete, coUpdate,
    coBookmark, coApproxPosition, coUpdateBatch, coResync, coNotify, coFind,
    coSeek, coIndex);
  TCursorOptions = set of TCursorOption;

  TEventReason = (erAddNew, erDelete, erUpdate, erUndoUpdate, erUndoAddNew,
    erUndoDelete, erRequery, erResynch, erClose, erMove, erFirstChange,
    erMoveFirst, erMoveNext, erMovePrevious, erMoveLast);

  TFilterGroup = (fgUnassigned, fgNone, fgPendingRecords, fgAffectedRecords,
    fgFetchedRecords, fgPredicate, fgConflictingRecords);

  TMarshalOption = (moMarshalAll, moMarshalModifiedOnly);

  TRecordStatus = (rsOK, rsNew, rsModified, rsDeleted, rsUnmodified, rsInvalid,
    rsMultipleChanges, rsPendingChanges, rsCanceled, rsCantRelease,
    rsConcurrencyViolation, rsIntegrityViolation, rsMaxChangesExceeded,
    rsObjectOpen, rsOutOfMemory, rsPermissionDenied, rsSchemaViolation,
    rsDBDeleted);
  TRecordStatusSet = set of TRecordStatus;

  TAffectRecords = (arCurrent, arFiltered, arAll, arAllChapters);

  TPersistFormat = (pfADTG, pfXML);

  TSeekOption = (soFirstEQ, soLastEQ, soAfterEQ, soAfter, soBeforeEQ, soBefore);

  PVariantList = ^TVariantList;
  TVariantList = array[0..0] of OleVariant;

  TWillChangeFieldEvent = procedure(DataSet: TCustomADODataSet;
    const FieldCount: Integer; const Fields: OleVariant;
    var EventStatus: TEventStatus) of object;

  TFieldChangeCompleteEvent = procedure(DataSet: TCustomADODataSet;
    const FieldCount: Integer; const Fields: OleVariant;
    const Error: Error; var EventStatus: TEventStatus) of object;

  TWillChangeRecordEvent = procedure(DataSet: TCustomADODataSet;
    const Reason: TEventReason; const RecordCount: Integer;
    var EventStatus: TEventStatus) of object;

  TRecordChangeCompleteEvent = procedure(DataSet: TCustomADODataSet;
    const Reason: TEventReason; const RecordCount: Integer;
    const Error: Error; var EventStatus: TEventStatus) of object;

  TEndOfRecordsetEvent = procedure (DataSet: TCustomADODataSet;
    var MoreData: WordBool; var EventStatus: TEventStatus) of object;

  TFetchProgressEvent = procedure(DataSet: TCustomADODataSet;
    Progress, MaxProgress: Integer; var EventStatus: TEventStatus) of object;

  TRecordsetErrorEvent = procedure(DataSet: TCustomADODataSet;
    const Reason: TEventReason; const Error: Error; var EventStatus: TEventStatus) of object;

  TRecordsetReasonEvent = procedure(DataSet: TCustomADODataSet;
    const Reason: TEventReason; var EventStatus: TEventStatus) of object;

  TRecordsetEvent = procedure(DataSet: TCustomADODataSet;
    const Error: Error; var EventStatus: TEventStatus) of object;

  TRecordsetCreate = procedure(DataSet: TCustomADODataSet;
    const Recordset: _Recordset) of object;

  TCustomADODataSet = class(TWideDataSet, IUnknown, RecordsetEventsVt)
  private
    FRecordsetObject: _Recordset;
    FFindCursor: _Recordset;
    FLookupCursor: _Recordset;
    FLockCursor: _Recordset;
    FRowset: IRowset;
    FAccessor: IAccessor;
    FRowsetFind: IRowsetFind;
    FHAccessor: HACCESSOR;
    FOleRecBufSize: Integer;
    FEventsID: Integer;
    FCommand: TADOCommand;
    FFilterBuffer: PChar;
    FRecBufSize: Integer;
    FCacheSize: Integer;
    FDetailFilter: string;
    FIndexFieldNames: string;
    FMaxRecords: Integer;
    FModifiedFields: TList;
    FParentRecNo: Integer;
    FIndexFields: TList;
    FIndexDefs: TIndexDefs;
    FParams: TParams;
    FIndexName: WideString;
    FDesignerData: string;
    FMasterDataLink: TMasterDataLink;
    FFilterGroup: TFilterGroup;
    FCursorLocation: TCursorLocation;
    FCursorType: TCursorType;
    FLockType: TADOLockType;
    FMarshalOptions: TMarshalOption;
    FRSCommandType: TCommandType;
    FParentDataSet: TCustomADODataSet;
    FBlockReadInfo: Pointer;
    FStoreDefs: Boolean;
    FEnableBCD: Boolean;
    FConnectionChanged: Boolean;
    FOnWillChangeField: TWillChangeFieldEvent;
    FOnFieldChangeComplete: TFieldChangeCompleteEvent;
    FOnWillChangeRecord: TWillChangeRecordEvent;
    FOnRecordChangeComplete: TRecordChangeCompleteEvent;
    FOnWillChangeRecordset: TRecordsetReasonEvent;
    FOnRecordsetChangeComplete: TRecordsetErrorEvent;
    FOnWillMove: TRecordsetReasonEvent;
    FOnMoveComplete: TRecordsetErrorEvent;
    FOnEndOfRecordset: TEndOfRecordsetEvent;
    FOnFetchComplete: TRecordsetEvent;
    FOnFetchProgress: TFetchProgressEvent;
    FOnRecordsetCreate: TRecordsetCreate;
    function GetCacheSize: Integer;
    function GetCommandTimeout: Integer;
    function GetCommandType: TCommandType;
    function GetConnection: TADOConnection;
    function GetConnectionString: WideString;
    function GetCursorLocation: TCursorLocation;
    function GetCursorType: TCursorType;
    function GetExecuteOptions: TExecuteOptions;
    function GetFilterGroup: TFilterGroup;
    function GetIndexField(Index: Integer): TField;
    function GetIndexFieldCount: Integer;
    function GetIndexFieldNames: string;
    function GetIndexName: WideString;
    function GetLockType: TADOLockType;
    function GetMarshalOptions: TMarshalOption;
    function GetMasterFields: WideString;
    function GetMaxRecords: Integer;
    function GetParamCheck: Boolean;
    function GetParameters: TParameters;
    function GetPrepared: Boolean;
    function GetProperties: Properties;
    function GetRecordsetState: TObjectStates;
    function GetRecordStatus: TRecordStatusSet;
    function GetSort: WideString;
    procedure PropertyChanged;
    procedure ReadDesignerData(Reader: TReader);
    procedure RefreshIndexFields;
    procedure SetCacheSize(const Value: Integer);
    procedure SetCommandTimeout(const Value: Integer);
    procedure SetCommandType(const Value: TCommandType);
    procedure SetConnectionString(const Value: WideString);
    procedure SetCursorLocation(const Value: TCursorLocation);
    procedure SetCursorType(const Value: TCursorType);
    procedure SetExecuteOptions(const Value: TExecuteOptions);
    procedure SetFilterGroup(const Value: TFilterGroup);
    procedure SetIndexField(Index: Integer; const Value: TField);
    procedure SetIndexFieldNames(const Value: string);
    procedure SetIndexName(const Value: WideString);
    procedure SetLockType(const Value: TADOLockType);
    procedure SetMarshalOptions(const Value: TMarshalOption);
    procedure SetMasterFields(const Value: WideString);
    procedure SetMaxRecords(const Value: Integer);
    procedure SetParamCheck(const Value: Boolean);
    procedure SetParameters(const Value: TParameters);
    procedure SetRecordset(const Value: _Recordset);
    procedure SetPrepared(const Value: Boolean);
    procedure SetSort(const Value: WideString);
    procedure WriteDesignerData(Writer: TWriter);
  protected
    { IProviderSupport2 }
    procedure PSEndTransaction(Commit: Boolean); override;
    procedure PSExecute; override;
    function PSExecuteStatement(const ASQL: WideString; AParams: TParams;
      ResultSet: Pointer = nil): Integer; override;
    procedure PSGetAttributes(List: TList); override;
    function PSGetDefaultOrder: TIndexDef; override;
    function PSGetKeyFieldsW: WideString; override;
    function PSGetParams: TParams; override;
    function PSGetQuoteCharW: WideString; override;
    function PSGetTableNameW: WideString; override;
    function PSGetIndexDefs(IndexTypes: TIndexOptions = [ixPrimary..ixNonMaintained]): TIndexDefs; override;
    function PSGetUpdateException(E: Exception; Prev: EUpdateError): EUpdateError; override;
    function PSInTransaction: Boolean; override;
    function PSIsSQLBased: Boolean; override;
    function PSIsSQLSupported: Boolean; override;
    procedure PSReset; override;
    procedure PSSetParams(AParams: TParams); override;
    procedure PSSetCommandText(const CommandText: WideString); override;
    procedure PSStartTransaction; override;
    function PSUpdateRecord(UpdateKind: TUpdateKind; Delta: TDataSet): Boolean; override;
    function PSGetCommandText: string; override;
    function PSGetCommandType: TPSCommandType; override;
  protected
    procedure ActivateTextFilter(const FilterText: string);
    function AllocRecordBuffer: PChar; override;
    procedure CheckActive; override;
    procedure CheckFieldCompatibility(Field: TField; FieldDef: TFieldDef); override;
    procedure ClearCalcFields(Buffer: PChar); override;
    procedure DataEvent(Event: TDataEvent; Info: Longint); override;
    procedure DeactivateFilters;
    procedure DefChanged(Sender: TObject); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DestroyLookupCursor; virtual;
    procedure DoOnNewRecord; override;
    procedure EnableEvents;
    function FindRecord(Restart, GoForward: Boolean): Boolean; override;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    function GetActiveRecBuf(var RecBuf: PChar): Boolean;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function GetCanModify: Boolean; override;
    function GetCommandText: WideString;
    function GetDataSource: TDataSource; override;
    function GetRecNo: Integer; override;
    function GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    function GetRecordCount: Integer; override;
    function GetRecordSize: Word; override;
    function GetStateFieldValue(State: TDataSetState; Field: TField): Variant; override;
    procedure InitOleDBAccess(Initializing: Boolean);
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure InternalCancel; override;
    procedure InternalClose; override;
    procedure InternalDelete; override;
    procedure InternalEdit; override;
    procedure InternalFirst; override;
    function InternalGetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalInitRecord(Buffer: PChar); override;
    procedure InternalInsert; override;
    procedure InternalLast; override;
    procedure InternalOpen; override;
    procedure InternalPost; override;
    procedure InternalRefresh; override;
    procedure InternalRequery(Options: TExecuteOptions = []);
    procedure InternalSetSort(Value: WideString);
    procedure InternalSetToRecord(Buffer: PChar); override;
    function IsCursorOpen: Boolean; override;
    procedure Loaded; override;
    function LocateRecord(const KeyFields: string; const KeyValues: OleVariant;
      Options: TLocateOptions; SyncCursor: Boolean): Boolean;
    procedure MasterChanged(Sender: TObject); virtual;
    procedure MasterDisabled(Sender: TObject); virtual;
    procedure OpenCursor(InfoQuery: Boolean); override;
    procedure PrepareCursor; virtual;
    procedure RefreshParams;
    procedure ReleaseLock;
    procedure SetBlockReadSize(Value: Integer); override;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure SetCommandText(const Value: WideString);
    procedure SetConnection(const Value: TADOConnection); virtual;
    function SetConnectionFlag(Flag: Integer; Value: Boolean): Boolean; virtual;
    procedure SetDataSource(const Value: TDataSource); virtual;
    function SetDetailFilter: Boolean;
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    procedure SetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean); override;
    procedure SetFiltered(Value: Boolean); override;
    procedure SetFilterOptions(Value: TFilterOptions); override;
    procedure SetFilterText(const Value: string); override;
    procedure SetParamsFromCursor;
    procedure SetRecNo(Value: Integer); override;
    procedure UpdateIndexDefs; override;
    procedure UpdateRecordSetPosition(Buffer: PChar);
  {  property MasterDataLink: TMasterDataLink read FMasterDataLink;
    property Command: TADOCommand read FCommand;
    property CommandText: WideString read GetCommandText write SetCommandText;
    property CommandTimeout: Integer read GetCommandTimeout write SetCommandTimeout default 30;
    property CommandType: TCommandType read GetCommandType write SetCommandType default cmdText;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property FieldDefs stored FStoreDefs;
    property IndexDefs: TIndexDefs read FIndexDefs write FIndexDefs;
    property IndexFieldNames: string read GetIndexFieldNames write SetIndexFieldNames;
    property MasterFields: WideString read GetMasterFields write SetMasterFields;
    property ParamCheck: Boolean read GetParamCheck write SetParamCheck default True;
    property Parameters: TParameters read GetParameters write SetParameters;
    property Prepared: Boolean read GetPrepared write SetPrepared default False;
    property StoreDefs: Boolean read FStoreDefs write FStoreDefs default False;}
  protected
    { RecordsetEvents }
    function ConnectionPoint: IConnectionPoint;
    procedure WillChangeField(cFields: Integer; Fields: OleVariant;
      var adStatus: EventStatusEnum; const pRecordset: _Recordset); safecall;
    procedure FieldChangeComplete(cFields: Integer; Fields: OleVariant;
      const pError: Error; var adStatus: EventStatusEnum;
      const pRecordset: _Recordset); safecall;
    procedure WillChangeRecord(adReason: EventReasonEnum;
      cRecords: Integer; var adStatus: EventStatusEnum;
      const pRecordset: _Recordset); safecall;
    procedure RecordChangeComplete(adReason: EventReasonEnum;
      cRecords: Integer; const pError: Error;
      var adStatus: EventStatusEnum; const pRecordset: _Recordset); safecall;
    procedure WillChangeRecordset(adReason: EventReasonEnum;
      var adStatus: EventStatusEnum; const pRecordset: _Recordset); safecall;
    procedure RecordsetChangeComplete(adReason: EventReasonEnum;
      const pError: Error; var adStatus: EventStatusEnum;
      const pRecordset: _Recordset); safecall;
    procedure WillMove(adReason: EventReasonEnum;
      var adStatus: EventStatusEnum; const pRecordset: _Recordset); safecall;
    procedure MoveComplete(adReason: EventReasonEnum; const pError: Error;
      var adStatus: EventStatusEnum; const pRecordset: _Recordset); safecall;
    procedure EndOfRecordset(var fMoreData: WordBool;
      var adStatus: EventStatusEnum; const pRecordset: _Recordset); safecall;
    procedure FetchProgress(Progress, MaxProgress: Integer;
      var adStatus: EventStatusEnum; const pRecordset: _Recordset); safecall;
    procedure FetchComplete(const pError: Error;
      var adStatus: EventStatusEnum; const pRecordset: _Recordset); safecall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function BookmarkValid(Bookmark: TBookmark): Boolean; override;
    procedure CancelBatch(AffectRecords: TAffectRecords = arAll);
    procedure CancelUpdates;
    procedure Clone(Source: TCustomADODataSet; LockType: TADOLockType = ltUnspecified);
    function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; override;
    function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;
    procedure DeleteRecords(AffectRecords: TAffectRecords = arAll);
    property EnableBCD: Boolean read FEnableBCD write FEnableBCD default True;
    procedure FilterOnBookmarks(Bookmarks: array of const);
    function GetBlobFieldData(FieldNo: Integer; var Buffer: TBlobByteData): Integer; override;
    procedure GetDetailLinkFields(MasterFields, DetailFields: TList); override;
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
    function GetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean): Boolean; override;
    function GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean; overload; override;
    function IsSequenced: Boolean; override;
    procedure LoadFromFile(const FileName: WideString);
    function Locate(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean; override;
    function Lookup(const KeyFields: string; const KeyValues: Variant;
      const ResultFields: string): Variant; override;
    function NextRecordset(var RecordsAffected: Integer): _Recordset;
    procedure Requery(Options: TExecuteOptions = []);
    procedure SaveToFile(const FileName: WideString = ''; Format: TPersistFormat = pfADTG);
    function Seek(const KeyValues: Variant; SeekOption: TSeekOption = soFirstEQ): Boolean;
    function Supports(CursorOptions: TCursorOptions): Boolean;
    procedure UpdateBatch(AffectRecords: TAffectRecords = arAll);
    function UpdateStatus: TUpdateStatus; override;
    property DesignerData: string read FDesignerData write FDesignerData;
    property IndexName: WideString read GetIndexName write SetIndexName;
    property IndexFieldCount: Integer read GetIndexFieldCount;
    property IndexFields[Index: Integer]: TField read GetIndexField write SetIndexField;
    property FilterGroup: TFilterGroup read GetFilterGroup write SetFilterGroup;
    property Properties: Properties read GetProperties;
    property Recordset: _Recordset read FRecordsetObject write SetRecordset;
    property RecordsetState: TObjectStates read GetRecordsetState;
    property RecordStatus: TRecordStatusSet read GetRecordStatus;
    property Sort: WideString read GetSort write SetSort;
    property MasterDataLink: TMasterDataLink read FMasterDataLink;
    property Command: TADOCommand read FCommand;
    property CommandText: WideString read GetCommandText write SetCommandText;
    property CommandTimeout: Integer read GetCommandTimeout write SetCommandTimeout default 30;
    property CommandType: TCommandType read GetCommandType write SetCommandType default cmdText;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property FieldDefs stored FStoreDefs;
    property IndexDefs: TIndexDefs read FIndexDefs write FIndexDefs;
    property IndexFieldNames: string read GetIndexFieldNames write SetIndexFieldNames;
    property MasterFields: WideString read GetMasterFields write SetMasterFields;
    property ParamCheck: Boolean read GetParamCheck write SetParamCheck default True;
    property Parameters: TParameters read GetParameters write SetParameters;
    property Prepared: Boolean read GetPrepared write SetPrepared default False;
    property StoreDefs: Boolean read FStoreDefs write FStoreDefs default False;

  published
    property Active default False;
    property AutoCalcFields;
    property CacheSize: Integer read GetCacheSize write SetCacheSize default 1;
    property Connection: TADOConnection read GetConnection write SetConnection;
    property ConnectionString: WideString read GetConnectionString write SetConnectionString;
    property CursorLocation: TCursorLocation read GetCursorLocation write SetCursorLocation default clUseClient;
    property CursorType: TCursorType read GetCursorType write SetCursorType default ctKeyset;
    property ExecuteOptions: TExecuteOptions read GetExecuteOptions write SetExecuteOptions default [];
    property Filter;
    property Filtered;
    property LockType: TADOLockType read GetLockType write SetLockType default ltOptimistic;
    property MarshalOptions: TMarshalOption read GetMarshalOptions write SetMarshalOptions default moMarshalAll;
    property MaxRecords: Integer read GetMaxRecords write SetMaxRecords default 0;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
    property OnWillChangeField: TWillChangeFieldEvent read FOnWillChangeField write FOnWillChangeField;
    property OnFieldChangeComplete: TFieldChangeCompleteEvent read FOnFieldChangeComplete write FOnFieldChangeComplete;
    property OnWillChangeRecord: TWillChangeRecordEvent read FOnWillChangeRecord write FOnWillChangeRecord;
    property OnRecordChangeComplete: TRecordChangeCompleteEvent read FOnRecordChangeComplete write FOnRecordChangeComplete;
    property OnWillChangeRecordset: TRecordsetReasonEvent read FOnWillChangeRecordset write FOnWillChangeRecordset;
    property OnRecordsetChangeComplete: TRecordsetErrorEvent read FOnRecordsetChangeComplete write FOnRecordsetChangeComplete;
    property OnWillMove: TRecordsetReasonEvent read FOnWillMove write FOnWillMove;
    property OnMoveComplete: TRecordsetErrorEvent read FOnMoveComplete write FOnMoveComplete;
    property OnEndOfRecordset: TEndOfRecordsetEvent read FOnEndOfRecordset write FOnEndOfRecordset;
    property OnFetchComplete: TRecordsetEvent read FOnFetchComplete write FOnFetchComplete;
    property OnFetchProgress: TFetchProgressEvent read FOnFetchProgress write FOnFetchProgress;
    property OnRecordsetCreate: TRecordsetCreate read FOnRecordsetCreate write FOnRecordsetCreate;
  end;

{ TADODataSet }

  TADODataSet = class(TCustomADODataSet)
  private
    FRDSConnection: TRDSConnection;
    procedure SetRDSConnection(Value: TRDSConnection);
  protected
    procedure DataEvent(Event: TDataEvent; Info: Longint); override;
    procedure OpenCursor(InfoQuery: Boolean); override;
    procedure SetConnection(const Value: TADOConnection); override;
    procedure SetDataSetField(const Value: TDataSetField); override;
  public
    procedure CreateDataSet;
    procedure GetIndexNames(List: TStrings);
    property IndexDefs;
  published
    property CommandText;
    property CommandTimeout;
    property CommandType;
    property DataSetField;
    property DataSource;
    property EnableBCD;
    property FieldDefs;
    property IndexName;
    property IndexFieldNames;
    property MasterFields;
    property ParamCheck;
    property Parameters;
    property Prepared;
    property RDSConnection: TRDSConnection read FRDSConnection write SetRDSConnection;
    property StoreDefs;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
   end;

{ TADOTable }

  TADOTable = class(TCustomADODataSet)
  private
    function GetTableDirect: Boolean;
    procedure SetTableDirect(const Value: Boolean);
    function GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    procedure GetIndexNames(List: TStrings);
    property IndexDefs;
  published
    property CommandTimeout;
    property EnableBCD;
    property IndexFieldNames;
    property IndexName;
    property MasterFields;
    property MasterSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly stored False;
    property TableDirect: Boolean read GetTableDirect write SetTableDirect default False;
    property TableName: WideString read GetCommandText write SetCommandText;
  end;

{ TADOQuery }

  TADOQuery = class(TCustomADODataSet)
  private
    FSQL: TWideStrings;
    FRowsAffected: Integer;
    function GetSQL: TWideStrings;
    procedure SetSQL(const Value: TWideStrings);
  protected
    procedure QueryChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecSQL: Integer; {for TQuery compatibility}
    property RowsAffected: Integer read FRowsAffected;
  published
    property CommandTimeout;
    property DataSource;
    property EnableBCD;
    property ParamCheck;
    property Parameters;
    property Prepared;
    property SQL: TWideStrings read GetSQL write SetSQL;
  end;

{ TADOStoredProc }

  TADOStoredProc = class(TCustomADODataSet)
  public
    constructor Create(AOwner: TComponent); override;
    procedure ExecProc;
  published
    property CommandTimeout;
    property DataSource;
    property EnableBCD;
    property ProcedureName: WideString read GetCommandText write SetCommandText;
    property Parameters;
    property Prepared;
  end;

{ TADOBlobStream }

  TADOBlobStream = class(TMemoryStream)
  private
    FField: TBlobField;
    FDataSet: TCustomADODataSet;
    FBuffer: PChar;
    FFieldNo: Integer;
    FModified: Boolean;
    FData: Variant;
    FFieldData: Variant;
  protected
    procedure ReadBlobData;
    function Realloc(var NewCapacity: Longint): Pointer; override;
  public
    constructor Create(Field: TBlobField; Mode: TBlobStreamMode);
    destructor Destroy; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    procedure Truncate;
  end;

{ Global Functions }

procedure CreateUDLFile(const FileName, ProviderName, DataSourceName: WideString);
function DataLinkDir: string;
procedure GetProviderNames(Names: TWideStrings); overload;
procedure GetProviderNames(Names: TStrings); overload;
function PromptDataSource(ParentHandle: THandle; InitialString: WideString): WideString;
function PromptDataLinkFile(ParentHandle: THandle; InitialFile: WideString): WideString;
function GetDataLinkFiles(FileNames: TWideStrings; Directory: string = ''): Integer; overload;
function GetDataLinkFiles(FileNames: TStrings; Directory: string = ''): Integer; overload;

{global utilities}
function CreateADOObject(const ClassID: TGUID): IUnknown;

function ADOTypeToFieldType(const ADOType: DataTypeEnum; EnableBCD: Boolean = True): TFieldType;

function FieldTypeToADOType(const FieldType: TFieldType): DataTypeEnum;

function StringToVarArray(const Value: string): OleVariant;

function VarDataSize(const Value: OleVariant): Integer;

function OleEnumToOrd(OleEnumArray: array of TOleEnum; Value: TOleEnum): Integer;

function GetStates(State: Integer): TObjectStates;

function ExecuteOptionsToOrd(ExecuteOptions: TExecuteOptions): Integer;

function OrdToExecuteOptions(Options: Integer): TExecuteOptions;

function ExtractFieldName(const Fields: WideString; var Pos: Integer): WideString;

function GetFilterStr(Field: TField; Value: Variant; Partial: Boolean = False): WideString;

function PropertyExists(const PropList: ADOInt.Properties; const PropName: WideString): Boolean;

function FieldListCheckSum(DataSet: TDataset): Integer;



implementation

uses DBCommon, Mtx, DBConsts, ComObj, ADOConst, WideStrUtils;

type
  PRecInfo = ^TRecInfo;
  TRecInfo = packed record
    Bookmark: OleVariant;
    BookmarkFlag: TBookmarkFlag;
    RecordStatus: Integer;
    RecordNumber: Integer;
  end;

const
  { Connection Flags }
  cfOpen       = 1;
  cfExecute    = 2;
  cfIndex      = 3;
  cfParameters = 4;
  cfProvider   = 5;

  bfNA = TBookmarkFlag(Ord(High(TBookmarkFlag)) + 1);
  RSOnlyCommandTypes = [cmdTableDirect, cmdFile]; { Command Types valid only in RecordSet.Open calls }

var
  GlobalMalloc: IMalloc;

{ Enum Mappings }

const
  CommandTypeValues: array[TCommandType] of TOleEnum = (adCmdUnknown,
    adCmdText, adCmdTable, adCmdStoredProc, adCmdFile, adCmdTableDirect);

  ConnectModeValues: array[TConnectMode] of TOleEnum = (adModeUnknown,
    adModeRead, adModeWrite, adModeReadWrite, adModeShareDenyRead,
    adModeShareDenyWrite, adModeShareExclusive, adModeShareDenyNone);

  ConnectOptionValues: array[TConnectOption] of TOleEnum = (adConnectUnspecified,
    adAsyncConnect);

  CursorLocationValues: array[TCursorLocation] of TOleEnum = (adUseServer, adUseClient);

  CursorOptionValues: array[TCursorOption] of TOleEnum = (adHoldRecords,
    adMovePrevious, adAddNew, adDelete, adUpdate, adBookmark, adApproxPosition,
    adUpdateBatch, adResync, adNotify, adFind, adSeek, adIndex);

  CursorTypeValues: array[TCursorType] of TOleEnum = (adOpenUnspecified,
    adOpenForwardOnly, adOpenKeyset, adOpenDynamic, adOpenStatic);

  DataTypeValues: array[TDataType] of TOleEnum = (
    adEmpty, adVarChar, adSmallint, adInteger, adUnsignedSmallint, // 0..4
    adBoolean, adDouble, adDouble, adCurrency, adDate, adDate, // 5..10
    adDate, adBinary, adVarBinary, adInteger, adLongVarBinary, // 11..15
    adLongVarChar, adLongVarBinary, adLongVarBinary, adLongVarBinary, //16..19
    adLongVarBinary, adLongVarBinary, adEmpty, adChar, adVarWChar, adBigInt, // 20..25
    adEmpty, adEmpty, adEmpty, adEmpty, adEmpty, adEmpty, adVariant, // 26..32
    adIUnknown, adIDispatch, adGuid, adEmpty, adEmpty, // 33..37
    adWChar, adLongVarWChar, adEmpty, adEmpty // 38..41
    );

  EventReasonValues: array[TEventReason] of TOleEnum = (adRsnAddNew,
    adRsnDelete, adRsnUpdate, adRsnUndoUpdate, adRsnUndoAddNew, adRsnUndoDelete,
    adRsnRequery, adRsnResynch, adRsnClose, adRsnMove, adRsnFirstChange,
    adRsnMoveFirst, adRsnMoveNext, adRsnMovePrevious, adRsnMoveLast);

  EventStatusValues: array[TEventStatus] of TOleEnum = (adStatusOK,
    adStatusErrorsOccurred, adStatusCantDeny, adStatusCancel,
    adStatusUnwantedEvent);

  ExecuteOptionValues: array[TExecuteOption] of TOleEnum = (adAsyncExecute,
    adAsyncFetch, adAsyncFetchNonBlocking, adExecuteNoRecords);

  FilterGroupValues: array[TFilterGroup] of TOleEnum = ($FFFFFFFF {Unassigned},
    adFilterNone, adFilterPendingRecords, adFilterAffectedRecords,
    adFilterFetchedRecords, adFilterPredicate, adFilterConflictingRecords);

  IsolationLevelValues: array[TIsolationLevel] of TOleEnum = (adXactUnspecified,
    adXactChaos, adXactReadUncommitted, adXactBrowse, adXactCursorStability,
    adXactReadCommitted, adXactRepeatableRead, adXactSerializable,
    adXactIsolated);

  LockTypeValues: array[TADOLockType] of TOleEnum = (adLockUnspecified,
    adLockReadOnly, adLockPessimistic, adLockOptimistic,
    adLockBatchOptimistic);

  MarshalOptionValues: array[TMarshalOption] of TOleEnum = (adMarshalAll,
    adMarshalModifiedOnly);

  ObjectStateValues: array[TObjectState] of TOleEnum = (adStateClosed,
    adStateOpen, adStateConnecting, adStateExecuting, adStateFetching);

  ParameterAttributeValues: array[TParameterAttribute] of TOleEnum =
    (adParamSigned, adParamNullable, adParamLong);

  ParameterDirectionValues: array[TParameterDirection] of TOleEnum =
    (adParamUnknown, adParamInput, adParamOutput, adParamInputOutput,
     adParamReturnValue);

  RecordStatusValues: array[TRecordStatus] of TOleEnum = (adRecOK, adRecNew,
    adRecModified, adRecDeleted, adRecUnmodified, adRecInvalid,
    adRecMultipleChanges, adRecPendingChanges, adRecCanceled, adRecCantRelease,
    adRecConcurrencyViolation, adRecIntegrityViolation,adRecMaxChangesExceeded,
    adRecObjectOpen, adRecOutOfMemory, adRecPermissionDenied,
    adRecSchemaViolation, adRecDBDeleted);

  SeekOptionValues: array[TSeekOption] of TOleEnum = (adSeekFirstEQ,
    adSeekLastEQ, adSeekAfterEQ, adSeekAfter, adSeekBeforeEQ, adSeekBefore);

  AffectRecordsValues: array[TAffectRecords] of TOleEnum =
    (adAffectCurrent, adAffectGroup, adAffectAll, adAffectAllChapters);

  XactAttributeValues: array[TXactAttribute] of TOleEnum = (adXactCommitRetaining,
    adXactAbortRetaining);

{ Utility Functions }

function CreateADOObject(const ClassID: TGUID): IUnknown;
var
  Status: HResult;
  FPUControlWord: Word;
begin
  asm
    FNSTCW  FPUControlWord
  end;
  Status := CoCreateInstance(ClassID, nil, CLSCTX_INPROC_SERVER or
    CLSCTX_LOCAL_SERVER, IUnknown, Result);
  asm
    FNCLEX
    FLDCW FPUControlWord
  end;
  if (Status = REGDB_E_CLASSNOTREG) then
    raise Exception.CreateRes(@SADOCreateError) else
    OleCheck(Status);
end;

function ADOTypeToFieldType(const ADOType: DataTypeEnum; EnableBCD: Boolean = True): TFieldType;
begin
  case ADOType of
    adEmpty: Result := ftUnknown;
    adTinyInt, adSmallInt: Result := ftSmallint;
    adError, adInteger, adUnsignedInt: Result := ftInteger;
    adBigInt, adUnsignedBigInt: Result := ftLargeInt;
    adUnsignedTinyInt, adUnsignedSmallInt: Result := ftWord;
    adSingle, adDouble: Result := ftFloat;
    adCurrency: Result := ftBCD;
    adBoolean: Result := ftBoolean;
    adDBDate: Result := ftDate;
    adDBTime: Result := ftTime;
    adDate, adDBTimeStamp, adFileTime, adDBFileTime: Result := ftDateTime;
    adChar: Result := ftFixedChar;
    adVarChar: Result := ftString;
    adWChar: Result := ftFixedWideChar;
    adBSTR, adVarWChar: Result := ftWideString;
    adLongVarChar: Result := ftMemo;
    adLongVarWChar: Result := ftWideMemo;
    adLongVarBinary: Result := ftBlob;
    adBinary: Result := ftBytes;
    adVarBinary: Result := ftVarBytes;
    adChapter: Result := ftDataSet;
    adPropVariant, adVariant: Result := ftVariant;
    adIUnknown: Result := ftInterface;
    adIDispatch: Result := ftIDispatch;
    adGUID: Result := ftGUID;
    adDecimal, adNumeric, adVarNumeric:
      if EnableBCD then Result := ftBCD
      else Result := ftFloat;
  else
    Result := ftUnknown;
  end;
end;

function FieldTypeToADOType(const FieldType: TFieldType): DataTypeEnum;
begin
  case FieldType of
    ftUnknown: Result := adEmpty;
    ftString: Result := adVarChar;
    ftWideString: Result := adVarWChar;
    ftSmallint: Result := adSmallint;
    ftInteger, ftAutoInc: Result := adInteger;
    ftWord: Result := adUnsignedSmallInt;
    ftBoolean: Result := adBoolean;
    ftFloat: Result := adDouble;
    ftCurrency, ftBCD: Result := adCurrency;
    ftDate: Result := adDBDate;
    ftTime: Result := adDBTime;
    ftDateTime: Result := adDBTimeStamp;
    ftBytes: Result := adBinary;
    ftVarBytes: Result := adVarBinary;
    ftMemo: Result := adLongVarChar;
    ftWideMemo: Result := adLongVarWChar;
    ftBlob, ftGraphic..ftTypedBinary: Result := adLongVarBinary;
    ftFixedChar: Result := adChar;
    ftFixedWideChar: Result := adWChar;
    ftLargeint: Result := adBigInt;
    ftVariant: Result := adVariant;
    ftInterface: Result := adIUnknown;
    ftIDispatch: Result := adIDispatch;
    ftGuid: Result := adGUID;
  else
    DatabaseErrorFmt(SNoMatchingADOType, [FieldTypeNames[FieldType]]);
    Result := adEmpty;
  end;
end;

function StringToVarArray(const Value: string): OleVariant;
var
  PData: Pointer;
  Size: Integer;
begin
  Size := Length(Value);
  Result := VarArrayCreate([0, Size-1], varByte);
  PData := VarArrayLock(Result);
  try
    Move(Pointer(Value)^, PData^, Size);
  finally
    VarArrayUnlock(Result);
  end;
end;

function VarDataSize(const Value: OleVariant): Integer;
begin
  if VarIsNull(Value) then
    Result := -1
  else if VarIsArray(Value) then
    Result := VarArrayHighBound(Value, 1) + 1
  else if TVarData(Value).VType = varOleStr then
  begin
    Result := Length(PWideString(@TVarData(Value).VOleStr)^);
    if Result = 0 then
      Result := -1;
  end
  else
    Result := SizeOf(OleVariant);
end;

function OleEnumToOrd(OleEnumArray: array of TOleEnum; Value: TOleEnum): Integer;
begin
  for Result := Low(OleEnumArray) to High(OleEnumArray) do
    if Value = OleEnumArray[Result] then Exit;
  Result := High(OleEnumArray) + 1;
end;

function GetStates(State: Integer): TObjectStates;
var
  Os: TObjectState;
begin
  Result := [];
  for Os := stOpen to High(TObjectState) do
    if (ObjectStateValues[Os] and State) <> 0 then
      Include(Result, Os);
  if Result = [] then Result := [stClosed];
end;

function ExecuteOptionsToOrd(ExecuteOptions: TExecuteOptions): Integer;
var
  Eo: TExecuteOption;
begin
  Result := 0;
  if ExecuteOptions <> [] then
    for Eo := Low(TExecuteOption) to High(TExecuteOption) do
      if Eo in ExecuteOptions then
        Inc(Result, ExecuteOptionValues[Eo]);
end;

function OrdToExecuteOptions(Options: Integer): TExecuteOptions;
var
  Eo: TExecuteOption;
begin
  Result := [];
  if Options <> 0 then
    for Eo := Low(TExecuteOption) to High(TExecuteOption) do
      if (ExecuteOptionValues[Eo] and Options) <> 0 then
        Include(Result, Eo);
end;

function ExtractFieldName(const Fields: WideString; var Pos: Integer): WideString;
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(Fields)) and (Fields[I] <> ';') do Inc(I);
  Result := Copy(Fields, Pos, I - Pos);
  if (I <= Length(Fields)) and (Fields[I] = ';') then Inc(I);
  Pos := I;
end;

function GetFilterStr(Field: TField; Value: Variant; Partial: Boolean = False): WideString;
var
  Operator,
  FieldName,
  QuoteCh: WideString;
begin
  QuoteCh := '';
  Operator := '=';
  FieldName := Field.FieldName;
  if Pos(' ', FieldName) > 0 then
    FieldName := WideFormat('[%s]', [FieldName]);
  if VarIsNull(Value) or VarIsClear(Value) then
    Value := 'Null'
  else
    case Field.DataType of
      ftDate, ftTime, ftDateTime:
        QuoteCh := '#';
      ftString, ftFixedChar, ftWideString, ftFixedWideChar:
        begin
          if Partial and (Value <> '') then
          begin
            Value := Value + '*';
            Operator := ' like ';     { Do not localize }
          end;
          if Pos('''', Value) > 0 then
            QuoteCh := '#' else
            QuoteCh := '''';
        end;
    end;
  Result := WideFormat('(%s%s%s%s%2:s)', [FieldName, Operator, QuoteCh, VarToWideStr(Value)]);
end;

function PropertyExists(const PropList: ADOInt.Properties; const PropName: WideString): Boolean;
var
  I: Integer;
begin
  for I := PropList.Count - 1  downto 0 do
    if PropList[I].Name = PropName then
    begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

function FieldListCheckSum(DataSet: TDataset): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to DataSet.Fields.Count - 1 do
    Result := Result + (Integer(Dataset.Fields[I]) shr (I mod 16));
end;

{ Public Global Functions }

procedure CreateUDLFile(const FileName, ProviderName, DataSourceName: WideString);
const
  ConnStrTemplate = 'Provider=%s;Data Source=%s'; { Do not localize }
var
  ConnStr: WideString;
  DataInit: IDataInitialize;
begin
  DataInit := CreateComObject(CLSID_DataLinks) as IDataInitialize;
  ConnStr := Format(ConnStrTemplate, [ProviderName, DataSourceName]);
  OleCheck(DataInit.WriteStringToStorage(PWideChar(FileName),
              PWideChar(ConnStr), CREATE_NEW));
end;

procedure GetProviderNames(Names: TWideStrings);
var
  RSCon: ADORecordsetConstruction;
  Rowset: IRowset;
  SourcesRowset: ISourcesRowset;
  SourcesRecordset: _Recordset;
  SourcesName, SourcesType: TField;
begin
  SourcesRecordset := CreateADOObject(CLASS_Recordset) as _Recordset;
  RSCon := SourcesRecordset as ADORecordsetConstruction;
  SourcesRowset := CreateComObject(CLSID_OLEDB_ENUMERATOR) as ISourcesRowset;
  OleCheck(SourcesRowset.GetSourcesRowset(nil, IRowset, 0, nil, IUnknown(Rowset)));
  RSCon.Rowset := RowSet;
  with TADODataSet.Create(nil) do
  try
    Recordset := SourcesRecordset;
    First;
    SourcesName := FieldByName('SOURCES_NAME'); { do not localize }
    SourcesType := FieldByName('SOURCES_TYPE'); { do not localize }
    Names.BeginUpdate;
    try
      while not EOF do
      begin
        if SourcesType.AsInteger = DBSOURCETYPE_DATASOURCE then
          Names.Add(SourcesName.AsWideString);
        Next;
      end;
    finally
      Names.EndUpdate;
    end;
  finally
    Free;
  end;
end;

procedure GetProviderNames(Names: TStrings);
var
  s: WideString;
  wNames: TWideStringList;
begin
  wNames := TWideStringList.Create;
  try
    GetProviderNames(wNames);
    with Names do
    begin
      BeginUpdate;
      for s in wNames do Add(s);
      EndUpdate;
    end;
  finally
    wNames.Free;
  end;
end;

function PromptDataSource(ParentHandle: THandle; InitialString: WideString): WideString;
var
  DataInit: IDataInitialize;
  DBPrompt: IDBPromptInitialize;
  DataSource: IUnknown;
  InitStr: PWideChar;
begin
  Result := InitialString;
  DataInit := CreateComObject(CLSID_DataLinks) as IDataInitialize;
  if InitialString <> '' then
    DataInit.GetDataSource(nil, CLSCTX_INPROC_SERVER,
      PWideChar(InitialString), IUnknown, DataSource);
  DBPrompt := CreateComObject(CLSID_DataLinks) as IDBPromptInitialize;
  if Succeeded(DBPrompt.PromptDataSource(nil, ParentHandle,
    DBPROMPTOPTIONS_PROPERTYSHEET, 0, nil, nil, IUnknown, DataSource)) then
  begin
    InitStr := nil;
    DataInit.GetInitializationString(DataSource, True, InitStr);
    Result := InitStr;
  end;
end;

function PromptDataLinkFile(ParentHandle: THandle; InitialFile: WideString): WideString;
var
  SelectedFile: PWideChar;
  InitialDir: WideString;
  DBPrompt: IDBPromptInitialize;
begin
  Result := InitialFile;
  DBPrompt := CreateComObject(CLSID_DataLinks) as IDBPromptInitialize;
  if InitialFile <> '' then
    InitialDir := ExtractFilePath(InitialFile);
    InitialFile := '*.udl';
  if Succeeded(DBPrompt.PromptFileName(ParentHandle, 0, Pointer(InitialDir),
     Pointer(InitialFile), SelectedFile)) then
    Result := SelectedFile;
end;

function DataLinkDir: string;
const
  CVMASKKEY  = 'SOFTWARE\Microsoft\Windows\CurrentVersion';
  COMMONFILESDIR = 'CommonFilesDir';
  DLDRELATIVE = '\System\OLE DB\Data Links';
var
  Buffer: array[0..MAX_PATH] of Char;
  phkResult: HKEY;
  DataSize: Longint;
begin
  Result := '';
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE, CVMASKKEY, 0, KEY_QUERY_VALUE, phkResult) = 0 then
  try
    DataSize := Sizeof(Buffer);
    if RegQueryValueEx(phkResult, COMMONFILESDIR, nil,  nil, @Buffer, @DataSize) = ERROR_SUCCESS then
      Result := string(Buffer) + DLDRELATIVE;
  finally
    RegCloseKey(phkResult);
  end;
end;

function GetDataLinkFiles(FileNames: TWideStrings; Directory: string = ''): Integer;
const
  FileMask = '\*.udl';
var
  Status: Integer;
  SearchRec: TSearchRec;
begin
  with FileNames do
  begin
    BeginUpdate;
    try
      Clear;
      if Directory = '' then Directory := DataLinkDir;
      Status := FindFirst(Directory+FileMask, faAnyFile, SearchRec);
      while Status = 0 do
      begin
        if (SearchRec.Attr and faDirectory) = 0 then
          Add(SearchRec.Name);
        Status := FindNext(SearchRec);
      end;
      FindClose(SearchRec);
    finally
      EndUpdate;
    end;
  end;
  Result := FileNames.Count;
end;

function GetDataLinkFiles(FileNames: TStrings; Directory: string = ''): Integer;
var
  s: WideString;
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    GetDataLinkFiles(wList, Directory);
    with wList do
    begin
      BeginUpdate;
      for s in wList do FileNames.Add(s);
      EndUpdate;
    end;
  finally
    wList.Free;
  end;
  Result := FileNames.Count;
end;

procedure ApplicationHandleException(Sender: TObject);
begin
  if Assigned(Classes.ApplicationHandleException) then
    Classes.ApplicationHandleException(Sender);
end;

{ TADOConnection }

constructor TADOConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnectionObject := CreateADOObject(CLASS_Connection) as _Connection;
  OleCheck(ConnectionPoint.Advise(Self as IUnknown, FConnEventsID));
  FCommands := TList.Create;
  LoginPrompt := True;
  FIsolationLevel := ilCursorStability;
  CursorLocation := clUseClient;
  FKeepConnection := True;
end;

destructor TADOConnection.Destroy;
begin
  Destroying;
  Close;
  ClearRefs;
  FreeAndNil(FCommands);
  if FConnEventsID > 0 then
    OleCheck(ConnectionPoint.UnAdvise(FConnEventsID));
  FConnEventsID := 0;
  FConnectionObject := nil;
  inherited Destroy;
end;

procedure TADOConnection.Loaded;
begin
  try
    inherited Loaded;
  except
    { Need to trap any exceptions opening while we are loading here }
    ApplicationHandleException(Self);
  end;
end;

procedure TADOConnection.CheckActive;
begin
  if Connected then Exit;
  Open;
  WaitForConnectComplete;
end;

procedure TADOConnection.CheckInactive;
begin
  { At design time, force connection to be closed as needed }
  if Connected and (csDesigning in ComponentState) then
    Close;
end;

procedure TADOConnection.ClearRefs;
begin
  if Assigned(FCommands) then
    while FCommands.Count > 0 do
      TADOCommand(FCommands[0]).Connection := nil;
  while DataSetCount > 0 do
    DataSets[0].Connection := nil;
end;

function TADOConnection.BeginTrans: Integer;
begin
  Result := ConnectionObject.BeginTrans;
  FTransactionLevel := Result;
end;

procedure TADOConnection.CommitTrans;
begin
  ConnectionObject.CommitTrans;
  if FTransactionLevel > 0 then Dec(FTransactionLevel);
  CheckDisconnect;
end;

procedure TADOConnection.RollbackTrans;
begin
  ConnectionObject.RollbackTrans;
  if FTransactionLevel > 0 then Dec(FTransactionLevel);
  CheckDisconnect;
end;

procedure TADOConnection.Cancel;
begin
  ConnectionObject.Cancel;
end;

procedure TADOConnection.WaitForConnectComplete;
begin
  if Assigned(ConnectionObject) then
    while (ConnectionObject.State = adStateConnecting) do
      DBApplication.ProcessMessages;
end;

procedure TADOConnection.DoConnect;
begin
  ConnectionObject.Open(ConnectionObject.ConnectionString, FUserID, FPassword,
    ConnectOptionValues[FConnectOptions]);
  if FDefaultDatabase <> '' then
    ConnectionObject.DefaultDatabase := FDefaultDatabase;
end;

procedure TADOConnection.DoDisconnect;
begin
  if Assigned(ConnectionObject) then
  begin
    while InTransaction do RollbackTrans;
    ConnectionObject.Close;
  end;
end;

procedure TADOConnection.CheckDisconnect;
var
  I: Integer;
begin
  if Connected and not (KeepConnection or InTransaction or (csLoading in ComponentState)) then
  begin
    for I := 0 to DataSetCount - 1 do
      if (DataSets[I].State <> dsInActive) then Exit;
    Close;
  end;
end;

procedure TADOConnection.Execute(const CommandText: WideString;
  var RecordsAffected: Integer; const ExecuteOptions: TExecuteOptions = [eoExecuteNoRecords]);
var
  VarRecsAffected: OleVariant;
begin
  CheckActive;
  ConnectionObject.Execute(CommandText, VarRecsAffected,
    adCmdText+ExecuteOptionsToOrd(ExecuteOptions));
  RecordsAffected := VarRecsAffected;
end;

function TADOConnection.Execute(const CommandText: WideString;
  const CommandType: TCommandType = cmdText;
  const ExecuteOptions: TExecuteOptions = []): _Recordset;
var
  VarRecsAffected: OleVariant;
begin
  CheckActive;
  Result := ConnectionObject.Execute(CommandText, VarRecsAffected,
    Integer(CommandTypeValues[CommandType])+ExecuteOptionsToOrd(ExecuteOptions));
end;

procedure TADOConnection.Open(const UserID, Password: WideString);
begin
  FUserID := UserID;
  FPassword := Password;
  try
    SetConnected(True);
  finally
    FUserID := '';
    FPassword := '';
  end;
end;

procedure TADOConnection.OpenSchema(const Schema: TSchemaInfo;
  const Restrictions, SchemaID: OleVariant; DataSet: TADODataSet);
var
  SchemaOrd: TOleEnum;
begin
  CheckActive;
  if Schema = siProviderSpecific then
    SchemaOrd := adSchemaProviderSpecific else
    SchemaOrd := SchemaEnum(Schema);
  DataSet.Recordset := ConnectionObject.OpenSchema(SchemaOrd, Restrictions,
    SchemaID);
end;

procedure TADOConnection.GetProcedureNames(List: TWideStrings);
var
  NameField: TField;
  DataSet: TADODataSet;
begin
  CheckActive;
  DataSet := TADODataSet.Create(nil);
  try
    OpenSchema(siProcedures, EmptyParam, EmptyParam, DataSet);
    NameField := DataSet.FieldByName('PROCEDURE_NAME'); { do not localize }
    while not DataSet.EOF do
    begin
      List.Add(NameField.AsWideString);
      DataSet.Next;
    end;
  finally
    DataSet.Free;
  end;
end;

procedure TADOConnection.GetProcedureNames(List: TStrings);
var
  s: WideString;
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    GetProcedureNames(wList);
    with List do
    begin
      BeginUpdate;
      for s in wList do Add(s);
      EndUpdate;
    end;
  finally
    wList.Free;
  end;
end;

procedure TADOConnection.GetFieldNames(const TableName: WideString;
  List: TWideStrings);
const
  COLUMN_NAME = 'COLUMN_NAME'; { Do not localize }
var
  Fields: _Recordset;
begin
  CheckActive;
  Fields := ConnectionObject.OpenSchema(adSchemaColumns, VarArrayOf([Null, Null, TableName]),
    EmptyParam);
  with List do
  begin
    BeginUpdate;
    try
      Clear;
      while not Fields.EOF do
      begin
        Add(VarTowideStr(Fields.Fields[COLUMN_NAME].Value));
        Fields.MoveNext;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TADOConnection.GetFieldNames(const TableName: string;
  List: TStrings);
var
  s: WideString;
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    GetFieldNames(TableName, wList);
    with List do
    begin
      BeginUpdate;
      for s in wList do Add(s);
      EndUpdate;
    end;
  finally
    wList.Free;
  end;
end;

procedure TADOConnection.GetTableNames(List: TWideStrings;
  SystemTables: Boolean);
var
  TypeField,
  NameField: TField;
  TableType: WideString;
  DataSet: TADODataSet;
begin
  CheckActive;
  DataSet := TADODataSet.Create(nil);
  try
    OpenSchema(siTables, EmptyParam, EmptyParam, DataSet);
    TypeField := DataSet.FieldByName('TABLE_TYPE'); { do not localize }
    NameField := DataSet.FieldByName('TABLE_NAME'); { do not localize }
    List.BeginUpdate;
    try
      List.Clear;
      while not DataSet.EOF do
      begin
        TableType := TypeField.AsWideString;
        if (TableType = 'TABLE') or (TableType = 'VIEW') or     { do not localize }
           (SystemTables and (TableType = 'SYSTEM TABLE')) then { do not localize }
          List.Add(NameField.AsWideString);
        DataSet.Next;
      end;
    finally
      List.EndUpdate;
    end;
  finally
    DataSet.Free;
  end;
end;

procedure TADOConnection.GetTableNames(List: TStrings;
  SystemTables: Boolean);
var
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    GetTableNames(wList, SystemTables);
    List.Assign(wList);
  finally
    wList.Free;
  end;
end;


{ ConnectionEvents }

function TADOConnection.ConnectionPoint: IConnectionPoint;
var
  ConnPtContainer: IConnectionPointContainer;
begin
  OleCheck(ConnectionObject.QueryInterface(IConnectionPointContainer,
    ConnPtContainer));
  OleCheck(ConnPtContainer.FindConnectionPoint(DIID_ConnectionEvents, Result));
end;

procedure TADOConnection.BeginTransComplete(TransactionLevel: Integer;
  const pError: Error; var adStatus: EventStatusEnum;
  const pConnection: _Connection);
var
  EventStatus: TEventStatus;
begin
  if Assigned(FOnBeginTransComplete) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    FOnBeginTransComplete(Self, TransactionLevel, pError, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end;
end;

procedure TADOConnection.CommitTransComplete(const pError: Error;
  var adStatus: EventStatusEnum; const pConnection: _Connection);
var
  EventStatus: TEventStatus;
begin
  if Assigned(FOnCommitTransComplete) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    FOnCommitTransComplete(Self, pError, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end;
end;

procedure TADOConnection.ConnectComplete(const pError: Error;
  var adStatus: EventStatusEnum; const pConnection: _Connection);
var
  EventStatus: TEventStatus;
begin
  if Assigned(FOnConnectComplete) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    FOnConnectComplete(Self, pError, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end;
end;

procedure TADOConnection.Disconnect(var adStatus: EventStatusEnum;
  const pConnection: _Connection);
var
  I: Integer;
  EventStatus: TEventStatus;
begin
  if Assigned(FOnDisconnect) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    FOnDisconnect(Self, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end;
  for I := 0 to DataSetCount - 1 do
    with DataSets[I] do
      if stClosed in RecordsetState then Close;
end;

procedure TADOConnection.ExecuteComplete(RecordsAffected: Integer;
  const pError: Error; var adStatus: EventStatusEnum;
  const pCommand: _Command; const pRecordset: _Recordset;
  const pConnection: _Connection);

  procedure CheckForAsyncExecute;
  var
    I: Integer;
  begin
    try
      if not Assigned(pError) and Assigned(pRecordset) and
         ((pRecordset.State and adStateOpen) <> 0) then
        for I := 0 to DataSetCount - 1 do
          with DataSets[I] do
          if (Recordset = pRecordset) and (eoAsyncExecute in ExecuteOptions) then
          begin
            OpenCursorComplete;
            Break;
          end;
    except
      ApplicationHandleException(Self);
    end;
  end;

var
  EventStatus: TEventStatus;
begin
  if Assigned(FOnExecuteComplete) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    FOnExecuteComplete(Self, RecordsAffected, pError, EventStatus, pCommand, pRecordset);
    adStatus := EventStatusValues[EventStatus];
  end;
  CheckForAsyncExecute;
end;

procedure TADOConnection.InfoMessage(const pError: Error;
  var adStatus: EventStatusEnum; const pConnection: _Connection);
var
  EventStatus: TEventStatus;
begin
  if Assigned(FOnInfoMessage) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    FOnInfoMessage(Self, pError, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end;
end;

procedure TADOConnection.RollbackTransComplete(const pError: Error;
  var adStatus: EventStatusEnum; const pConnection: _Connection);
var
  EventStatus: TEventStatus;
begin
  if Assigned(FOnRollbackTransComplete) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    FOnRollbackTransComplete(Self, pError, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end;
end;

procedure TADOConnection.WillConnect(var ConnectionString, UserID,
  Password: WideString; var Options: Integer;
  var adStatus: EventStatusEnum; const pConnection: _Connection);

  function ExtractUserID(ConnStr: string): string;
  var
    UIDPos, UIDLen: Integer;
  begin
    UIDPos := Pos(CT_USERID, AnsiUpperCase(ConnStr)) + Length(CT_USERID);
    if UIDPos > Length(CT_USERID) then
    begin
      UIDLen := Pos(';', Copy(ConnStr, UIDPos, 255)) - 1;
      Result := Copy(ConnStr, UIDPos, UIDLen);
    end else
      Result := '';
  end;

  function GetUserName(ConnStr: string): string;
  var
    DataInit: IDataInitialize;
    DataLinkFileName: WideString;
    InnerConnStr: POleStr;
  begin
    if CompareText(Copy(ConnStr, 1, 10), CT_FILENAME) = 0 then
    begin
      DataInit := CreateComObject(CLSID_DataLinks) as IDataInitialize;
      DataLinkFileName := Copy(ConnStr, 11, MAX_PATH);
      if Succeeded(DataInit.LoadStringFromStorage(PWideChar(DataLinkFileName), InnerConnStr)) then
        Result := ExtractUserID(InnerConnStr);
    end
    else
      Result := ExtractUserID(ConnStr);
  end;

var
  SPassword, SUserID: string;
  EventStatus: TEventStatus;
  ConnectOptions: TConnectOption;
begin
  if Assigned(FOnWillConnect) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    ConnectOptions := TConnectOption(OleEnumToOrd(ConnectOptionValues, Options));
    FOnWillConnect(Self, ConnectionString, UserID, Password, ConnectOptions,
      EventStatus);
    adStatus := EventStatusValues[EventStatus];
    Options := ConnectOptionValues[ConnectOptions];
  end;
  if LoginPrompt then
  begin
    if UserID = '' then
      SUserID := UserID;
      SUserID := GetUserName(ConnectionString);
    if Assigned(LoginDialogExProc) then
      if LoginDialogExProc(Name, SUserID, SPassword, False) then
      begin
        UserID := SUserID;
        Password := SPassword;
      end else
        adStatus := adStatusCancel;
  end;
  if Assigned(OnLogin) then
    OnLogin(Self, UserID, Password);
end;

procedure TADOConnection.WillExecute(var Source: WideString;
  var CursorType: CursorTypeEnum; var LockType: LockTypeEnum;
  var Options: Integer; var adStatus: EventStatusEnum;
  const pCommand: _Command; const pRecordset: _Recordset;
  const pConnection: _Connection);

  function ExtractCommandType: TCommandType;
  begin
  { Can't use OleEnumToOrd for this since it also contains the Execute options }
    for Result := Low(TCommandType) to High(TCommandType) do
      if (CommandTypeValues[Result] and Options) <> 0 then Exit;
    Result := cmdText;
  end;

var
  ECursorType: TCursorType;
  ELockType: TADOLockType;
  EventStatus: TEventStatus;
  ExecuteOptions: TExecuteOptions;
  CommandType: TCommandType;
begin
  if Assigned(FOnWillExecute) then
  begin
    ECursorType := TCursorType(OleEnumToOrd(CursorTypeValues, CursorType));
    ELockType := TADOLockType(OleEnumToOrd(LockTypeValues, LockType));
    CommandType := ExtractCommandType;
    ExecuteOptions := OrdToExecuteOptions(Options);
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    FOnWillExecute(Self, Source, ECursorType, ELockType, CommandType,
      ExecuteOptions, EventStatus, pCommand, pRecordset);
    CursorType := CursorTypeValues[ECursorType];
    LockType := LockTypeValues[ELockType];
    Options := Integer(CommandTypeValues[CommandType]) + ExecuteOptionsToOrd(ExecuteOptions);
    adStatus := EventStatusValues[EventStatus];
  end;
end;

{ Property Access }

function TADOConnection.GetAttributes: TXactAttributes;
var
  Attributes: Integer;
  Xa: TXactAttribute;
begin
  Result := [];
  Attributes := ConnectionObject.Attributes;
  if Attributes <> 0 then
    for Xa := Low(TXactAttribute) to High(TXactAttribute) do
      if (XactAttributeValues[Xa] and Attributes) <> 0 then
        Include(Result, Xa);
end;

procedure TADOConnection.SetAttributes(const Value: TXactAttributes);
var
  Attributes: LongWord;
  Xa: TXactAttribute;
begin
  Attributes := 0;
  if Value <> [] then
    for Xa := Low(TXactAttribute) to High(TXactAttribute) do
      if Xa in Value then
        Attributes := Attributes + XactAttributeValues[Xa];
  ConnectionObject.Attributes := Attributes;
end;

function TADOConnection.GetCommandTimeout: Integer;
begin
  Result := ConnectionObject.CommandTimeOut;
end;

procedure TADOConnection.SetCommandTimeout(const Value: Integer);
begin
  ConnectionObject.CommandTimeOut := Value;
end;

function TADOConnection.GetConnected: Boolean;
begin
  WaitForConnectComplete;
  Result := Assigned(ConnectionObject) and ((adStateOpen and ConnectionObject.State) <> 0);
end;

procedure TADOConnection.SetConnectionObject(const Value: _Connection);
begin
  CheckInActive;
  if Assigned(Value) then
  begin
    OleCheck(ConnectionPoint.UnAdvise(FConnEventsID));
    FConnectionObject := Value;
    OleCheck(ConnectionPoint.Advise(Self as IUnknown, FConnEventsID));
  end;
end;

function TADOConnection.GetConnectionString: WideString;
begin
  if (csWriting in ComponentState) and Connected then
    Result := FConnectionString
  else
    Result := ConnectionObject.ConnectionString;
end;

procedure TADOConnection.SetConnectionString(const Value: WideString);
begin
  if ConnectionString <> Value then
  begin
    CheckInactive;
    ConnectionObject.ConnectionString := Value;
    FConnectionString := Value;
  end;
end;

function TADOConnection.GetConnectionTimeout: Integer;
begin
  Result := ConnectionObject.ConnectionTimeout;
end;

procedure TADOConnection.SetConnectionTimeout(const Value: Integer);
begin
  if ConnectionTimeout <> Value then
  begin
    CheckInactive;
    ConnectionObject.ConnectionTimeout := Value;
  end;
end;

procedure TADOConnection.SetConnectOptions(const Value: TConnectOption);
begin
  if ConnectOptions <> Value then
  begin
    CheckInactive;
    FConnectOptions := Value;
  end;
end;

function TADOConnection.GetCursorLocation: TCursorLocation;
begin
  Result := TCursorLocation(OleEnumToOrd(CursorLocationValues,
    ConnectionObject.CursorLocation));
end;

procedure TADOConnection.SetCursorLocation(const Value: TCursorLocation);
begin
  ConnectionObject.CursorLocation := CursorLocationValues[Value];
end;


procedure TADOConnection.RegisterClient(Client: TObject; Event: TConnectChangeEvent = nil);
begin
  inherited;
  if (Client is TADOCommand) and not (TADOCommand(Client).Owner is TCustomADODataSet) then
    FCommands.Add(Client);
end;

procedure TADOConnection.UnRegisterClient(Client: TObject);
begin
  inherited;
  if (Client is TADOCommand) and not (TADOCommand(Client).Owner is TCustomADODataSet) then
    FCommands.Remove(Client);
end;

function TADOConnection.GetCommand(Index: Integer): TADOCommand;
begin
  Result := FCommands[Index];
end;

function TADOConnection.GetCommandCount: Integer;
begin
  Result := FCommands.Count;
end;

function TADOConnection.GetADODataSet(Index: Integer): TCustomADODataSet;
begin
  Result := GetDataSet(Index) as TCustomADODataSet;
end;

function TADOConnection.IsDefaultDatabaseStored: Boolean;
begin
  Result := FDefaultDatabase <> '';
end;

function TADOConnection.GetDefaultDatabase: WideString;
begin
  if Connected then
  try
    Result := ConnectionObject.DefaultDatabase
  except
    { Ignore errors reading this property }
  end
  else
    Result := FDefaultDatabase;
end;

procedure TADOConnection.SetDefaultDatabase(const Value: WideString);
begin
  if DefaultDatabase <> Value then
  begin
    FDefaultDatabase := Value;
    if Connected then
      ConnectionObject.DefaultDatabase := Value;
  end;
end;

function TADOConnection.GetErrors: Errors;
begin
  Result := ConnectionObject.Errors;
end;

function TADOConnection.GetInTransaction: Boolean;
begin
  Result := FTransactionLevel > 0;
end;

function TADOConnection.GetIsolationLevel: TIsolationLevel;
var
  OleEnum: TOleEnum;
begin
  { IsolationLevelEnum has several duplicate values, here we try to return the
    one specified by the user if it matches }
  OleEnum := ConnectionObject.IsolationLevel;
  if IsolationLevelValues[FIsolationLevel] = OleEnum then
    Result := FIsolationLevel
  else
  begin
    Result := TIsolationLevel(OleEnumToOrd(IsolationLevelValues, OleEnum));
    FIsolationLevel := Result;
  end;
end;

procedure TADOConnection.SetIsolationLevel(const Value: TIsolationLevel);
begin
  ConnectionObject.IsolationLevel := IsolationLevelValues[Value];
  FIsolationLevel := Value;
end;

function TADOConnection.GetMode: TConnectMode;
begin
  Result := TConnectMode(OleEnumToOrd(ConnectModeValues, ConnectionObject.Mode));
end;

procedure TADOConnection.SetMode(const Value: TConnectMode);
begin
  if Mode <> Value then
  begin
    CheckInactive;
    ConnectionObject.Mode := ConnectModeValues[Value];
  end;
end;

function TADOConnection.GetProperties: Properties;
begin
  Result := ConnectionObject.Properties;
end;

function TADOConnection.GetProvider: WideString;
begin
  Result := ConnectionObject.Provider;
end;

procedure TADOConnection.SetProvider(const Value: WideString);
begin
  if Provider <> Value then
  begin
    CheckInactive;
    ConnectionObject.Provider := Value;
  end;
end;

function TADOConnection.IsProviderStored: Boolean;
begin
  if Connected then
    Result := Provider <> 'MSDASQL.1' else
    Result := Provider <> 'MSDASQL';
end;

function TADOConnection.GetState: TObjectStates;
begin
  Result := GetStates(ConnectionObject.State);
end;

function TADOConnection.GetVersion: WideString;
begin
  Result := ConnectionObject.Version;
end;

procedure TADOConnection.SetKeepConnection(const Value: Boolean);
begin
  if FKeepConnection <> Value then
  begin
    FKeepConnection := Value;
    CheckDisconnect;
  end;
end;


{ TRDSConnection }

const
  DataFactoryProgID = 'RDSServer.DataFactory';

constructor TRDSConnection.Create(AOwner: TComponent);
begin
  inherited;
  SetServerName(DataFactoryProgID);
end;

destructor TRDSConnection.Destroy;
begin
  Destroying;
  Close;
  ClearRefs;
  FDataSpace := nil;
  inherited Destroy;
end;

procedure TRDSConnection.CheckInactive;
begin
  { At design time, force connection to be closed as needed }
  if Connected and (csDesigning in ComponentState) then
    Close;
end;

procedure TRDSConnection.ClearRefs;
var
  I: Integer;
begin
  for I := (DataSetCount - 1) downto 0 do
    if DataSets[I] is TADODataSet then
      TADODataSet(DataSets[I]).RDSConnection := nil;
end;

procedure TRDSConnection.DoConnect;
begin
  if not Assigned(FDataSpace) then
    FDataSpace := CreateADOObject(CLASS_DataSpace) as DataSpace;
  FDataSpace.InternetTimeout := InternetTimeout;
  FAppServer := FDataSpace.CreateObject(ServerName, ComputerName);
end;

procedure TRDSConnection.DoDisconnect;
begin
  VarClear(FAppServer);
end;

function TRDSConnection.GetConnected: Boolean;
begin
  Result := not VarIsClear(FAppServer);
end;

function TRDSConnection.GetRecordset(const CommandText: Widestring;
  ConnectionString: WideString = ''): _Recordset;

  function GetFromDataFactory: _RecordSet;
  begin
    Result := IUnknown(AppServer.Query(ConnectionString, CommandText, 0)) as _Recordset;
  end;

  function GetFromProperty: _RecordSet;
  var
    Status, DispID: Integer;
    ExcepInfo: TExcepInfo;
    VarResult: OleVariant;
    FServDisp: IDispatch;
    DispParams: TDispParams;
  begin
    FServDisp := IUnknown(FAppServer) as IDispatch;
    FillChar(DispParams, SizeOf(DispParams), 0);
    OLECheck(FServDisp.GetIDsOfNames(GUID_NULL, @CommandText, 1, 0, @DispID));
    Status := FServDisp.Invoke(DispID, GUID_NULL, LOCALE_USER_DEFAULT,
      DISPATCH_PROPERTYGET, DispParams, @VarResult, @ExcepInfo, nil);
    if Status <> 0 then DispatchInvokeError(Status, ExcepInfo);
    Result := IUnknown(VarResult) as _Recordset;
  end;

begin
  if not Connected then Open;
  if FIsAppServer then
    Result := GetFromProperty else
    Result := GetFromDataFactory;
end;

procedure TRDSConnection.SetComputerName(const Value: WideString);
begin
  CheckInactive;
  FComputerName := Value;
end;

procedure TRDSConnection.SetServerName(const Value: WideString);
begin
  CheckInactive;
  FServerName := Value;
  { Determine if the name is the default RDSServer.DataFactory }
  FIsAppServer := Pos(UpperCase(Value), UpperCase(DataFactoryProgID)) <> 1;
end;

{ TParameters }

function TParameters.Create_Parameter(const Name: WideString;
  DataType: TDataType; Direction: TParameterDirection = pdInput;
  Size: Integer = 0): _Parameter;
const
  ValidDirectionValues: array[TParameterDirection] of TOleEnum =
    (adParamInput, adParamInput, adParamOutput, adParamInputOutput,
     adParamReturnValue);
begin
  Result := Command.CommandObject.CreateParameter(Name, DataTypeValues[DataType],
    ValidDirectionValues[Direction], Size, Null);
end;

function TParameters.Refresh: Boolean;
begin
  Command.SetConnectionFlag(cfParameters, True);
  try
    Command.Initialize(False);
    Result := InternalRefresh;
  finally
    Command.SetConnectionFlag(cfParameters, False);
  end;
end;

function TParameters.InternalRefresh: Boolean;

  { This method uses OLEDB instead of ADO to get the parameter info.  This
    prevents an exception from being raised when the parameter information
    is not available }

  procedure RefreshFromOleDB;
  var
    I: Integer;
    ParamCount: UINT;
    ParamInfo: PDBParamInfoArray;
    NamesBuffer: POleStr;
    Name: WideString;
    Parameter: _Parameter;
    Direction: ParameterDirectionEnum;
    OLEDBCommand: ICommand;
    OLEDBParameters: ICommandWithParameters;
    CommandPrepare: ICommandPrepare;
  begin
    OLEDBCommand := (Command.CommandObject as ADOCommandConstruction).OLEDBCommand as ICommand;
    OLEDBCommand.QueryInterface(ICommandWithParameters, OLEDBParameters);
    OLEDBParameters.SetParameterInfo(0, nil, nil);
    if Assigned(OLEDBParameters) then
    begin
      ParamInfo := nil;
      NamesBuffer := nil;
      try
        OLEDBCommand.QueryInterface(ICommandPrepare, CommandPrepare);
        if Assigned(CommandPrepare) then CommandPrepare.Prepare(0);
        if OLEDBParameters.GetParameterInfo(ParamCount, PDBPARAMINFO(ParamInfo), @NamesBuffer) = S_OK then
          for I := 0 to ParamCount - 1 do
            with ParamInfo[I] do
            begin
              { When no default name, fabricate one like ADO does }
              if pwszName = nil then
                Name := 'Param' + IntToStr(I+1) else { Do not localize }
                Name := pwszName;
              { ADO maps DBTYPE_BYTES to adVarBinary }
              if wType = DBTYPE_BYTES then wType := adVarBinary;
              { ADO maps DBTYPE_STR to adVarChar }
              if wType = DBTYPE_STR then wType := adVarChar;
              { ADO maps DBTYPE_WSTR to adVarWChar }
              if wType = DBTYPE_WSTR then wType := adVarWChar;
              Direction := dwFlags and $F;
              { Verify that the Direction is initialized }
              if Direction = adParamUnknown then Direction := adParamInput;
              Parameter := Command.CommandObject.CreateParameter(Name, wType, Direction, ulParamSize, EmptyParam);
              Parameter.Precision := bPrecision;
              Parameter.NumericScale := ParamInfo[I].bScale;
              Parameter.Attributes := dwFlags and $FFFFFFF0; { Mask out Input/Output flags }
              AddParameter.FParameter := Parameter;
            end;
      finally
        if Assigned(CommandPrepare) then CommandPrepare.Unprepare;
        if (ParamInfo <> nil) then GlobalMalloc.Free(ParamInfo);
        if (NamesBuffer <> nil) then GlobalMalloc.Free(NamesBuffer);
      end;
    end;
  end;

  procedure RefreshFromADO;
  var
    I: Integer;
    Parameter: _Parameter;
  begin
    with Command.CommandObject do
    try
      Parameters.Refresh;
      for I := 0 to Parameters.Count - 1 do
        with Parameters[I] do
        begin
        { We can't use the instance of the parameter in the ADO collection because
          it will be freed when the connection is closed even though we have a
          reference to it.  So instead we create our own and copy the settings }
          Parameter := CreateParameter(Name, Type_, Direction, Size, EmptyParam);
          Parameter.Precision := Precision;
          Parameter.NumericScale := NumericScale;
          Parameter.Attributes := Attributes;
          AddParameter.FParameter := Parameter;
        end;
    except
      { do nothing }
    end;
  end;

begin
  BeginUpdate;
  try
    Clear;
    if Command.CommandType = cmdText then
      RefreshFromOLEDB else
      RefreshFromADO;
    Result := Count > 0;
  finally
    EndUpdate;
  end;
end;

procedure TParameters.Update(Item: TCollectionItem);
begin
  FModified := True;
end;

function TParameters.AddParameter: TParameter;
begin
  Result := Add as TParameter;
end;

procedure TParameters.AppendParameters;
var
  I: Integer;
begin
  if Modified then
  begin
    try
      { Create a dummy parameter first, so that we won't raise an exception
        on the call to Count if the provider does not supply parameter info }
      ParameterCollection.Append(Create_Parameter('_', ftInteger));
      for I := ParameterCollection.Count - 1 downto 0 do
        ParameterCollection.Delete(I);
    except
      { just in case... }
    end;
    for I := 0 to Count - 1 do
      ParameterCollection.Append(Items[I].ParameterObject);
    FModified := False;
  end;
end;

function TParameters.CreateParameter(const Name: WideString;
  DataType: TDataType; Direction: TParameterDirection; Size: Integer;
  Value: OleVariant): TParameter;
begin
  Result := AddParameter;
  Result.FParameter := Create_Parameter(Name, DataType, Direction, Size);
  { Don't try to assign value when it is an EmptyParam (used when optional) }
  if not ((TVarData(Value).VType = varError) and
    (LongWord(TVarData(EmptyParam).VError) = $80020004)) then
    Result.FParameter.Value := Value;
end;

procedure TParameters.AssignValues(Value: TParameters);
var
  I: Integer;
  P: TParameter;
begin
  for I := 0 to Value.Count - 1 do
  begin
    P := FindParam(Value[I].Name);
    if P <> nil then
      P.Assign(Value[I]);
  end;
end;

function TParameters.IsEqual(Value: TParameters): Boolean;
var
  I: Integer;
begin
  Result := Count = Value.Count;
  if Result then
    for I := 0 to Count - 1 do
    begin
      Result := Items[I].IsEqual(Value.Items[I]);
      if not Result then Break;
    end
end;

function TParameters.FindParam(const Value: WideString): TParameter;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Result := TParameter(inherited Items[I]);
    if CompareText(Result.Name, Value) = 0 then Exit;
  end;
  Result := nil;
end;

function TParameters.ParamByName(const Value: WideString): TParameter;

  function GetComponent: TComponent;
  begin
    Result := GetCommand;
    if Assigned(Result) and (Result.Owner is TCustomADODataSet) then
      Result := Command.Owner;
  end;

begin
  Result := FindParam(Value);
  if Result = nil then
    DatabaseErrorFmt(SParameterNotFound, [Value], GetComponent);
end;

procedure TParameters.GetParamList(List: TList; const ParamNames: WideString);
var
  Pos: Integer;
begin
  Pos := 1;
  while Pos <= Length(ParamNames) do
    List.Add(ParamByName(ExtractFieldName(ParamNames, Pos)));
end;

function TParameters.GetParamValue(const ParamName: WideString): Variant;
var
  I: Integer;
  Params: TList;
begin
  if Pos(';', ParamName) <> 0 then
  begin
    Params := TList.Create;
    try
      GetParamList(Params, ParamName);
      Result := VarArrayCreate([0, Params.Count - 1], varVariant);
      for I := 0 to Params.Count - 1 do
        Result[I] := TParameter(Params[I]).Value;
    finally
      Params.Free;
    end;
  end else
    Result := ParamByName(ParamName).Value
end;

procedure TParameters.SetParamValue(const ParamName: WideString;
  const Value: Variant);
var
  I: Integer;
  Params: TList;
begin
  if Pos(';', ParamName) <> 0 then
  begin
    Params := TList.Create;
    try
      GetParamList(Params, ParamName);
      for I := 0 to Params.Count - 1 do
        TParameter(Params[I]).Value := Value[I];
    finally
      Params.Free;
    end;
  end else
    ParamByName(ParamName).Value := Value;
end;

function TParameters.ParseSQL(SQL: WideString; DoCreate: Boolean): WideString;
const
  Literals = ['''', '"', '`'];
var
  Value, CurPos, StartPos: PWideChar;
  CurChar: WideChar;
  Literal: Boolean;
  EmbeddedLiteral: Boolean;
  Name: WideString;

  function NameDelimiter: Boolean;
  begin
    Result := InOpSet(CurChar, [' ', ',', ';', ')', #13, #10]);
  end;

  function IsLiteral: Boolean;
  begin
    Result := InOpSet(CurChar, Literals);
  end;

  function StripLiterals(Buffer: PWideChar): WideString;
  var
    Len: Word;
    TempBuf: PWideChar;

    procedure StripChar;
    begin
      if InOpSet(TempBuf^, Literals) then
        WStrMove(TempBuf, TempBuf + 1, Len - 1);
      if InOpSet(TempBuf[WStrLen(TempBuf) - 1], Literals) then
        TempBuf[WStrLen(TempBuf) - 1] := #0;
    end;

  begin
    Len := WStrLen(Buffer) + 1;
    TempBuf := AllocMem(Len * 2);
    Result := '';
    try
      WStrCopy(TempBuf, Buffer);
      StripChar;
      Result := TempBuf;
    finally
      FreeMem(TempBuf, Len * 2);
    end;
  end;

begin
  Result := SQL;
  Value := PWideChar(Result);
  if DoCreate then Clear;
  CurPos := Value;
  Literal := False;
  EmbeddedLiteral := False;
  repeat
    CurChar := CurPos^;
    if (CurChar = ':') and not Literal and ((CurPos + 1)^ <> ':') then
    begin
      StartPos := CurPos;
      while (CurChar <> #0) and (Literal or not NameDelimiter) do
      begin
        Inc(CurPos);
        CurChar := CurPos^;
        if IsLiteral then
        begin
          Literal := Literal xor True;
          if CurPos = StartPos + 1 then EmbeddedLiteral := True;
        end;
      end;
      CurPos^ := #0;
      if EmbeddedLiteral then
      begin
        Name := StripLiterals(StartPos + 1);
        EmbeddedLiteral := False;
      end
      else Name := WideString(StartPos + 1);
      if DoCreate then
        AddParameter.Name := Name;
      CurPos^ := CurChar;
      StartPos^ := '?';
      Inc(StartPos);
      WStrMove(StartPos, CurPos, WStrLen(CurPos) + 1);
      CurPos := StartPos;
    end
    else if (CurChar = ':') and not Literal and ((CurPos + 1)^ = ':') then
      WStrMove(CurPos, CurPos + 1, WStrLen(CurPos) + 1)
    else if IsLiteral then Literal := Literal xor True;
    Inc(CurPos);
  until CurChar = #0;
end;

function TParameters.GetAttr(Index: Integer): string;
begin
  case Index of
    0: Result := sNameAttr;
    1: Result := sValueAttr;
  else
    Result := ''; { do not localize }
  end;
end;

function TParameters.GetAttrCount: Integer;
begin
  Result := 2;
end;

function TParameters.GetItemAttr(Index, ItemIndex: Integer): string;
begin
  case Index of
    0: begin
         Result := Items[ItemIndex].Name;
         if Result = '' then Result := IntToStr(ItemIndex);
       end;
    1: Result := VarToWideStr(Items[ItemIndex].Value);
  else
    Result := '';
  end;
end;

{ Property Access }

function TParameters.GetCommand: TADOCommand;
begin
  Result := GetOwner as TADOCommand;
end;

function TParameters.GetItem(Index: Integer): TParameter;
begin
  Result := TParameter(inherited Items[Index]);
end;

procedure TParameters.SetItem(Index: Integer; const Value: TParameter);
begin
  inherited SetItem(Index, TCollectionItem(Value));
end;

function TParameters.GetParamCollection: Parameters;
begin
  Result := Command.CommandObject.Parameters;
end;

{ TParameter }

procedure TParameter.AppendChunk(Val: OleVariant);
begin
  ParameterObject.AppendChunk(Val);
end;

procedure TParameter.Assign(Source: TPersistent);

  procedure AssignParameter(Parameter: TParameter);
  begin
    Attributes := Parameter.Attributes;
    if Parameter.DataType <> ftUnknown then
      DataType := Parameter.DataType;
    Direction := Parameter.Direction;
    Name := Parameter.Name;
    NumericScale := Parameter.NumericScale;
    Precision := Parameter.Precision;
    Size := Parameter.Size;
    Value := Parameter.Value;
  end;

  procedure AssignField(Field: TField);
  begin
    DataType := Field.DataType;
    Size := Field.Size;
    Value := Field.Value;
  end;

  procedure AssignParam(Param: TParam);
  begin
    if Param.ParamType = ptUnknown then
      Direction := pdInput else
      Direction := TParameterDirection(Param.ParamType);
    Name := Param.Name;
    Attributes := [];
    NumericScale := Param.NumericScale;
    Precision := Param.Precision;
    Size := Param.Size;
    Value := Param.Value;
    if DataType = ftUnknown then
      DataType := Param.DataType;
  end;

  procedure LoadFromStreamPersist(const StreamPersist: IStreamPersist);
  var
    MS: TMemoryStream;
  begin
    MS := TMemoryStream.Create;
    try
      StreamPersist.SaveToStream(MS);
      LoadFromStream(MS, ftGraphic);
    finally
      MS.Free;
    end;
  end;

  procedure LoadFromStrings(Source: TStrings);
  begin
    Value := Source.Text;
    DataType := ftString;
  end;

var
  StreamPersist: IStreamPersist;
begin
  if Source is TParameter then
    AssignParameter(TParameter(Source))
  else if Source is TField then
    AssignField(TField(Source))
  else if Source is TParam then
    AssignParam(TParam(Source))
  else if Source is TStrings then
    LoadFromStrings(TStrings(Source))
  else if Supports(Source, IStreamPersist, StreamPersist) then
    LoadFromStreamPersist(StreamPersist)
  else
    inherited Assign(Source);
end;

procedure TParameter.AssignTo(Dest: TPersistent);

  procedure AssignToParam(Param: TParam);
  begin
    Param.Name := Name;
    Param.ParamType := TParamType(Direction);
    Param.DataType := DataType;
    Param.Size := Size;
    Param.Precision := Precision;
    Param.NumericScale := NumericScale;
    Param.Value := Value;
  end;

begin
  if Dest is TField then
    TField(Dest).Value := Value
  else if Dest is TParam then
    AssignToParam(TParam(Dest)) else
    inherited AssignTo(Dest);
end;

procedure TParameter.LoadFromFile(const FileName: string; DataType: TDataType);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream, DataType);
  finally
    Stream.Free;
  end;
end;

procedure TParameter.LoadFromStream(Stream: TStream; DataType: TDataType);
var
  StrData: string;
  WStrData: WideString;
  BinData: OleVariant;
  DataPtr: Pointer;
  Len: Integer;
begin
  Self.DataType := DataType;
  with Stream do
  begin
    Position := 0;
    Len := Size;
    case DataType of
      ftString, ftFixedChar, ftMemo:
        begin
          SetLength(StrData, Len);
          ReadBuffer(Pointer(StrData)^, Len);
          Self.Value := StrData;
        end;
      ftWideString, ftFixedWideChar, ftWideMemo:
        begin
          SetLength(WStrData, Len div 2);
          ReadBuffer(Pointer(WStrData)^, Len);
          Self.Value := WStrData;
        end;
      else { Assume binary for all others }
        begin
          BinData := VarArrayCreate([0, Len-1], varByte);
          DataPtr := VarArrayLock(BinData);
          try
            ReadBuffer(DataPtr^, Len);
            Self.Value := BinData;
          finally
            VarArrayUnlock(BinData);
          end;
        end;
    end;
  end;
end;

function TParameter.IsEqual(Value: TParameter): Boolean;
begin
  Result := (VarType(Self.Value) = VarType(Value.Value)) and
    (VarIsClear(Self.Value) or (Self.Value = Value.Value)) and (Name = Value.Name) and
    (DataType = Value.DataType) and (Direction = Value.Direction) and
    (NumericScale = Value.NumericScale) and (Precision = Value.Precision) and
    (Size = Value.Size);
end;

function TParameter.GetAttributes: TParameterAttributes;
var
  Attributes: Integer;
  Pa: TParameterAttribute;
begin
  Result := [];
  Attributes := ParameterObject.Attributes;
  if Attributes <> 0 then
    for Pa := Low(TParameterAttribute) to High(TParameterAttribute) do
      if (ParameterAttributeValues[Pa] and Attributes) <> 0 then
        Include(Result, Pa);
end;

procedure TParameter.SetAttributes(const Value: TParameterAttributes);
var
  Attributes: LongWord;
  Pa: TParameterAttribute;
begin
  Attributes := 0;
  if Value <> [] then
    for Pa := Low(TParameterAttribute) to High(TParameterAttribute) do
      if Pa in Value then
        Attributes := Attributes + ParameterAttributeValues[Pa];
  ParameterObject.Attributes := Attributes;
  Changed(False);
end;

function TParameter.GetDataType: TDataType;
begin
  Result := ADOTypeToFieldType(ParameterObject.Type_);
end;

procedure TParameter.SetDataType(const Value: TDataType);
begin
  ParameterObject.Type_ := DataTypeValues[Value];
  Changed(False);
end;

function TParameter.GetDisplayName: string;
begin
  Result := GetName;
end;

function TParameter.GetName: WideString;
begin
  Result := ParameterObject.Name;
end;

procedure TParameter.SetName(const Value: WideString);
begin
  ParameterObject.Name := Value;
  Changed(False);
end;

function TParameter.GetNumericScale: Byte;
begin
  Result := ParameterObject.NumericScale;
end;

procedure TParameter.SetNumericScale(const Value: Byte);
begin
  ParameterObject.NumericScale := Value;
  Changed(False);
end;

function TParameter.GetParameter: _Parameter;
begin
  if not Assigned(FParameter) then
    FParameter := Parameters.Create_Parameter('', ftUnknown);
  Result := FParameter;
end;

function TParameter.GetParameterDirection: TParameterDirection;
begin
  Result := TParameterDirection(OleEnumToOrd(ParameterDirectionValues,
    ParameterObject.Direction));
end;

procedure TParameter.SetParameterDirection(const Value: TParameterDirection);
begin
  ParameterObject.Direction := ParameterDirectionValues[Value];
  Changed(False);
end;

function TParameter.GetParameters: TParameters;
begin
  Result := TParameters(Collection);
end;

function TParameter.GetPrecision: Byte;
begin
  Result := ParameterObject.Precision;
end;

procedure TParameter.SetPrecision(const Value: Byte);
begin
  ParameterObject.Precision := Value;
  Changed(False);
end;

function TParameter.GetProperties: Properties;
begin
  Result := ParameterObject.Properties;
end;

function TParameter.GetSize: Integer;
begin
  Result := ParameterObject.Size;
end;

procedure TParameter.SetSize(const Value: Integer);
begin
  ParameterObject.Size := Value;
  Changed(False);
end;

function TParameter.GetValue: Variant;
begin
  Result := ParameterObject.Value;
end;

procedure TParameter.SetValue(const Value: Variant);
const
  SizedDataTypes = [ftUnknown, ftString, ftFixedChar, ftWideString, ftFixedWideChar,
    ftMemo, ftWideMemo, ftBlob, ftBytes, ftVarBytes];
var
  NewSize: Integer;
  NewValue: OleVariant;
begin
  if VarIsClear(Value) or VarIsNull(Value) then
    NewValue := Null
  else
  begin
    if DataType = ftUnknown then
      SetDataType(VarTypeToDataType(VarType(Value)));
    { Convert blob data stored in AnsiStrings into variant arrays first }
    if (DataType = ftBlob) and (VarType(Value) = varString) then
      NewValue := StringToVarArray(Value) else
      NewValue := Value;
  end;
  if DataType in SizedDataTypes then
  begin
    NewSize := VarDataSize(NewValue);
    if (Size = 0) or (NewSize > Size) then
      Size := NewSize;
  end;
  ParameterObject.Value := NewValue;
end;

{ TADOCommand }

constructor TADOCommand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommandObject := CreateADOObject(CLASS_Command) as _Command;
  FParameters := TParameters.Create(Self, TParameter);
  FParamCheck := True;
  CommandType := cmdText;
  CommandTextAlias := 'CommandText'; { Do not localize }
  ComponentRef := Self;
end;

destructor TADOCommand.Destroy;
begin
  inherited Destroy;
  Connection := nil;
  FCommandObject := nil;
  FreeAndNil(FParameters);
end;

procedure TADOCommand.Assign(Source: TPersistent);
var
  Command: TADOCommand;
begin
  if Source is TADOCommand then
  begin
    Command := TADOCommand(Source);
    if Assigned(Command.Connection) then
      Connection := Command.Connection else
      ConnectionString := Command.ConnectionString;
    CommandTimeout := Command.CommandTimeout;
    CommandType := Command.CommandType;
    CommandText := Command.CommandText;
    Prepared := Command.Prepared;
    Parameters := Command.Parameters;
  end else
    inherited;
end;

procedure TADOCommand.Cancel;
begin
  CommandObject.Cancel;
end;

procedure TADOCommand.CheckCommandText;
begin
  if CommandText = '' then
    DatabaseErrorFmt(SMissingCommandText, [CommandTextAlias], FComponentRef);
end;

function TADOCommand.SetConnectionFlag(Flag: Integer;
  Value: Boolean): Boolean;
begin
  Result := Flag in FConnectionFlags;
  if Value then
  begin
    if not Result then
    begin
      if FConnectionFlags = [] then OpenConnection;
      Include(FConnectionFlags, Flag);
    end;
  end else
  begin
    if Result then
    begin
      Exclude(FConnectionFlags, Flag);
      if (FConnectionFlags = []) and Assigned(Connection) then
        Connection.CheckDisconnect;
    end;
  end;
end;

procedure TADOCommand.OpenConnection;
begin
  if not Assigned(CommandObject.Get_ActiveConnection) then
  begin
    if ConnectionString <> '' then
      CommandObject._Set_ActiveConnection(FConnectionString)
    else if Assigned(FConnection) then
    begin
      FConnection.CheckActive;
      CommandObject.Set_ActiveConnection(FConnection.ConnectionObject);
    end else
      DatabaseError(SMissingConnection);
  end;
end;

function TADOCommand.ComponentLoading: Boolean;
begin
  Result := (csLoading in ComponentState) or (Assigned(Owner) and
    (csLoading in Owner.ComponentState));
end;

function TADOCommand.Execute: _Recordset;
begin
  Result := Execute(EmptyParam);
end;

function TADOCommand.Execute(const Parameters: OleVariant): _Recordset;
var
  RecordsAffected: Integer;
begin
  RecordsAffected := 0;
  Result := Execute(RecordsAffected, Parameters);
end;

function TADOCommand.Execute(var RecordsAffected: Integer;
  const Parameters: OleVariant): _Recordset;
var
  VarRecsAffected: OleVariant;
begin
  SetConnectionFlag(cfExecute, True);
  try
    Initialize;
    Result := CommandObject.Execute(VarRecsAffected, Parameters,
      Integer(CommandObject.CommandType) + ExecuteOptionsToOrd(FExecuteOptions));
    RecordsAffected := VarRecsAffected;
  finally
    SetConnectionFlag(cfExecute, False);
  end;
end;

procedure TADOCommand.Initialize(DoAppend: Boolean);
var
  BracketText: WideString;
begin
  CheckCommandText;
  if DoAppend then
  begin
    { Put brackets around table names with spaces }
    if (CommandType in [cmdTable, cmdStoredProc]) and
       (Pos(' ', FCommandText) > 0) and (FCommandText[1] <> '[') then
    begin
      BracketText:= FCommandText;
      { Left bracket goes after any owner qualifier }
      if (Pos('.', BracketText) > 0) then
        BracketText:= WideStringReplace(BracketText, '.', '.[', []) else
        BracketText:= '[' + BracketText;
      { Right bracket goes before any grouping indicator }
      if (Pos(';', BracketText) > 0) then
        BracketText:= WideStringReplace(BracketText, ';', '];', []) else
        BracketText:= BracketText + ']';
      CommandObject.CommandText := BracketText;
    end;
    Parameters.AppendParameters;
  end;
end;

{ Property Access }

function TADOCommand.GetActiveConnection: _Connection;
begin
  Result := CommandObject.Get_ActiveConnection;
end;

procedure TADOCommand.AssignCommandText(const Value: WideString; Loading: Boolean);

  procedure InitParameters;
  var
    I: Integer;
    List: TParameters;
    NativeCommand: WideString;
  begin
    List := TParameters.Create(Self, TParameter);
    try
      NativeCommand := List.ParseSQL(Value, True);
      { Preserve existing values }
      List.AssignValues(Parameters);
      CommandObject.CommandText := NativeCommand;
      if not Loading and (Assigned(Connection) or (ConnectionString <> '')) then
      begin
        try
          SetConnectionFlag(cfParameters, True);
          try
            { Retrieve additional parameter info from the server if supported }
            Parameters.InternalRefresh;
            { Use additional parameter info from server to initialize our list }
            if Parameters.Count = List.Count then
              for I := 0 to List.Count - 1 do
              begin
                List[I].DataType := Parameters[I].DataType;
                List[I].Size := Parameters[I].Size;
                List[I].NumericScale := Parameters[I].NumericScale;
                List[I].Precision := Parameters[I].Precision;
                List[I].Direction := Parameters[I].Direction;
                List[I].Attributes := Parameters[I].Attributes;
              end
          finally
            SetConnectionFlag(cfParameters, False);
          end;
        except
          { Ignore error if server cannot provide parameter info }
        end;
        if List.Count > 0 then
          Parameters.Assign(List);
      end;
    finally
      List.Free;
    end;
  end;

begin
  if (CommandType = cmdText) and (Value <> '') and ParamCheck then
    InitParameters
  else
  begin
    CommandObject.CommandText := Value;
    if not Loading then Parameters.Clear;
  end;
end;

procedure TADOCommand.SetCommandText(const Value: WideString);
begin
  FCommandText := Value;
  AssignCommandText(Value, ComponentLoading);
end;

function TADOCommand.GetCommandTimeOut: Integer;
begin
  Result := CommandObject.CommandTimeout;
end;

procedure TADOCommand.SetCommandTimeOut(const Value: Integer);
begin
  CommandObject.CommandTimeout := Value;
end;

function TADOCommand.GetCommandType: TCommandType;
begin
  Result := TCommandType(OleEnumToOrd(CommandTypeValues,
    CommandObject.CommandType));
end;

procedure TADOCommand.SetComandType(const Value: TCommandType);
begin
  CommandObject.CommandType := CommandTypeValues[Value];
end;

procedure TADOCommand.ClearActiveConnection;
begin
  CommandObject.Set_ActiveConnection(nil);
end;

procedure TADOCommand.ConnectionStateChange(Sender: TObject;
  Connecting: Boolean);
begin
  if not Connecting then ClearActiveConnection;
end;

procedure TADOCommand.SetConnection(const Value: TADOConnection);
begin
  if Connection <> Value then
  begin
    FConnectionString := '';
    if Assigned(FConnection) then
      FConnection.UnRegisterClient(Self);
    FConnection := Value;
    if Assigned(FConnection) then
      FConnection.RegisterClient(Self, ConnectionStateChange);
    ClearActiveConnection;
  end;
end;

procedure TADOCommand.SetConnectionString(const Value: WideString);
begin
  if ConnectionString <> Value then
  begin
    Connection := nil;
    FConnectionString := Value;
    ClearActiveConnection;
  end;
end;

procedure TADOCommand.SetParameters(const Value: TParameters);
begin
  FParameters.Assign(Value);
end;

function TADOCommand.GetPrepared: WordBool;
begin
  Result := CommandObject.Prepared;
end;

procedure TADOCommand.SetPrepared(const Value: WordBool);
begin
  CommandObject.Prepared := Value;
end;

function TADOCommand.GetState: TObjectStates;
begin
  Result := GetStates(CommandObject.State);
end;

function TADOCommand.GetProperties: Properties;
begin
  Result := CommandObject.Properties;
end;

{ TCustomADODataSet }

procedure InitializeMasterFields(Dataset: TCustomADODataset);
var
  I: Integer;
  MasterFieldList: string;
begin
  with DataSet do
    { Assign MasterFields from parameters as needed by the MasterDataLink }
    if (Parameters.Count > 0) and Assigned(MasterDataLink.DataSource) and
      Assigned(MasterDataLink.DataSource.DataSet) then
    begin
      for I := 0 to Parameters.Count - 1 do
        if (Parameters[I].Direction in [pdInput, pdInputOutput]) and
          (MasterDataLink.DataSource.DataSet.FindField(Parameters[I].Name) <> nil) then
          MasterFieldList := MasterFieldList + Parameters[I].Name + ';';
      MasterFields := Copy(MasterFieldList, 1, Length(MasterFieldList)-1);
      SetParamsFromCursor;
    end;
end;

constructor TCustomADODataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommand := TADOCommand.Create(Self);
  FCommand.ComponentRef := Self;
  FIndexDefs := TIndexDefs.Create(Self);
  FModifiedFields := TList.Create;
  FIndexFields := TList.Create;
  FCursorType := ctKeyset;
  FLockType := ltOptimistic;
  FCursorLocation := clUseClient;
  FCacheSize := 1;
  CommandType := cmdText;
  NestedDataSetClass := TADODataSet;
  FMasterDataLink := TMasterDataLink.Create(Self);
  MasterDataLink.OnMasterChange := MasterChanged;
  MasterDataLink.OnMasterDisable := MasterDisabled;
  EnableBCD := True;
end;

destructor TCustomADODataSet.Destroy;
begin
  Destroying;
  Close;
  SetConnection(nil);
  FreeAndNil(FCommand);
  FreeAndNil(FModifiedFields);
  FreeAndNil(FIndexDefs);
  FreeAndNil(FIndexFields);
  FreeAndNil(FMasterDataLink);
  FreeAndNil(FParams);
  inherited Destroy;
end;

procedure TCustomADODataSet.Loaded;
begin
  try
    inherited Loaded;
  except
    { Need to trap any exceptions opening while we are loading here }
    ApplicationHandleException(Self);
  end;
end;

function TCustomADODataSet.SetConnectionFlag(Flag: Integer;
  Value: Boolean): Boolean;
begin
  Result := Command.SetConnectionFlag(Flag, Value);
end;

procedure TCustomADODataSet.OpenCursor(InfoQuery: Boolean);
const
  AsyncOptions = [eoAsyncExecute, eoAsyncFetch, eoAsyncFetchNonBlocking];
var
  ActiveConnection,
  Source: OleVariant;

  procedure InitializeConnection;
  var
    UseCommand: Boolean;
  begin
    { Async operations require a connection component so we can hook events }
    if not Assigned(Connection) and (ExecuteOptions * AsyncOptions <> []) then
      DatabaseError(SConnectionRequired);
    FConnectionChanged := False;
    ActiveConnection := EmptyParam;
    UseCommand := not (CommandType in RSOnlyCommandTypes);
    if UseCommand then
    begin
      SetConnectionFlag(cfOpen, True);
      Command.Initialize;
      InitializeMasterFields(Self);
      Source := Command.CommandObject;
    end else
    begin
      { Can't use command for cmdFile and cmdTableDirect }
      if Assigned(Connection) then
      begin
        Connection.Open;
        ActiveConnection := Connection.ConnectionObject;
      end else if ConnectionString <> '' then
        ActiveConnection := ConnectionString;
      Command.CheckCommandText;
      Source := CommandText;
    end;
  end;

  procedure InitializeRecordset;
  begin
    FRecordsetObject := CreateADOObject(CLASS_Recordset) as _Recordset;
    Recordset.CursorLocation := CursorLocationValues[FCursorLocation];
    Recordset.CacheSize := FCacheSize;
    Recordset.MaxRecords := FMaxRecords;
    if FIndexName <> '' then
    begin
      Recordset.Index := FIndexName;
      RefreshIndexFields;
    end;
    EnableEvents;
    if Assigned(FOnRecordsetCreate) then
    begin
      if VarType(ActiveConnection) = varDispatch then
        Recordset.Set_ActiveConnection(ActiveConnection)
      else if Assigned(Command.CommandObject.Get_ActiveConnection) then
        Recordset.Set_ActiveConnection(Command.CommandObject.Get_ActiveConnection);
      FOnRecordsetCreate(Self, FRecordsetObject);
    end;
  end;

var
  VarRecsAffected: OleVariant;
begin
  if not Assigned(Recordset) then
  begin
    InitializeConnection;
    InitializeRecordset;
    Recordset.Open(Source, ActiveConnection,
      CursorTypeValues[FCursorType], LockTypeValues[FLockType],
      Integer(CommandTypeValues[CommandType]) + ExecuteOptionsToOrd(ExecuteOptions));
    while Recordset.State = adStateClosed do
    try
      FRecordsetObject := Recordset.NextRecordset(VarRecsAffected);
      if Recordset = nil then Abort;
    except
      DatabaseError(SNoResultSet, Self);
    end;
  end else
    EnableEvents;
  if (eoAsyncExecute in ExecuteOptions) and ((Recordset.State and adStateExecuting) <> 0) then
    SetState(dsOpening);
  inherited OpenCursor(False);
end;

procedure TCustomADODataSet.InternalOpen;
begin
  SetUniDirectional(CursorType = ctOpenForwardOnly);
  if Recordset.Supports(adBookmark) then
    BookmarkSize := SizeOf(OleVariant) else
    BookmarkSize := 0;
  FieldDefs.Updated := False;
  FieldDefs.Update;
  if DefaultFields then CreateFields;
  Reserved := Pointer(FieldListCheckSum(Self));
  BindFields(True);
  FRecBufSize := SizeOf(TRecInfo) + (Fields.Count * SizeOf(OleVariant));
  PrepareCursor;
end;

procedure TCustomADODataSet.InternalClose;
begin
  BindFields(False);
  if DefaultFields then DestroyFields;
  FIndexFields.Clear;
  DestroyLookupCursor;
  if stOpen in RecordsetState then
  begin
    if FEventsID > 0 then
    begin
      OleCheck(ConnectionPoint.UnAdvise(FEventsID));
      FEventsID := 0;
    end;
  end;
  FFindCursor := nil;
  FRecordsetObject := nil;
  FFilterGroup := fgUnassigned;
  FDetailFilter := '';
  SetConnectionFlag(cfOpen, False);
end;

procedure TCustomADODataSet.InternalRefresh;
begin
  if Recordset.Supports(adResync) then
    Recordset.Resync(adAffectAll, adResyncAllValues)
  else
    InternalRequery;
end;

procedure TCustomADODataSet.InternalRequery(Options: TExecuteOptions = []);
begin
  if FConnectionChanged then
    DatabaseError(SCantRequery);
  try
    Recordset.Requery(ExecuteOptionsToOrd(Options));
  except
    if Recordset.State = adStateClosed then Close;
    raise;
  end;
  DestroyLookupCursor;
end;

procedure TCustomADODataSet.Requery(Options: TExecuteOptions = []);
begin
  CheckBrowseMode;
  InternalRequery(Options);
  First;
end;

procedure TCustomADODataSet.CheckActive;
begin
  { Block here to prevent errors }
  while State = dsOpening do
    DBApplication.ProcessMessages;
  inherited CheckActive;
end;

procedure TCustomADODataSet.CheckFieldCompatibility(Field: TField;
  FieldDef: TFieldDef);
var
  Compatible: Boolean;
begin
  case Field.DataType of
    ftVariant:          { TVariantField should work for any field type }
      Compatible := True;
    ftFloat, ftCurrency, ftBCD: { Numeric and Doubles are interchangeable }
      Compatible := FieldDef.DataType in [ftFloat, ftCurrency, ftBCD];
    ftString, ftWideString: { As are string and widestring }
      Compatible := FieldDef.DataType in [ftString, ftWideString];
  else
    Compatible := False;
  end;
  if not Compatible then inherited;
end;

function TCustomADODataSet.IsCursorOpen: Boolean;
begin
  Result := stOpen in RecordsetState;
end;

procedure TCustomADODataSet.DefChanged(Sender: TObject);
begin
  FStoreDefs := True;
end;

procedure TCustomADODataSet.InternalInitFieldDefs;
const
  SIsAutoInc: WideString = 'ISAUTOINCREMENT'; { do not localize }
var
  HasAutoIncProp: Boolean;

  { Determine if the field's property list contains an ISAUTOINCREMENT entry }
  procedure AddFieldDef(F: Field; FieldDefs: TFieldDefs);
  var
    FieldType: TFieldType;
    FieldDef: TFieldDef;
    I: Integer;
    FName: WideString;
    FSize: Integer;
    FPrecision: Integer;
  begin
    FieldType := ADOTypeToFieldType(F.Type_, EnableBCD);
    if FieldType <> ftUnknown then
    begin
      FSize := 0;
      FPrecision := 0;
      FieldDef := FieldDefs.AddFieldDef;
      with FieldDef do
      begin
        FieldNo := FieldDefs.Count;
        I := 0;
        FName := F.Name;
        while (FName = '') or (FieldDefs.IndexOf(FName) >= 0) do
        begin
          Inc(I);
          if F.Name = '' then
            FName := WideFormat('COLUMN%d', [I]) else { Do not localize }
            FName := WideFormat('%s_%d', [F.Name, I]);
        end;
        Name := FName;
        if (F.Type_ = adNumeric) and (F.NumericScale = 0) and
           (F.Precision < 10) then
          FieldType := ftInteger;
        case FieldType of
          ftString, ftWideString, ftBytes, ftVarBytes, ftFixedChar, ftFixedWideChar:
            FSize := F.DefinedSize;
          ftBCD:
            begin
              FPrecision := F.Precision;
              FSize := ShortInt(F.NumericScale);
              if FSize < 0 then FSize := 4;
            end;
          ftInteger:
            if HasAutoIncProp and (F.Properties[SIsAutoInc].Value = True) then
              FieldType := ftAutoInc;
          ftGuid:
            FSize := 38;
        end;

        if ((adFldRowID and F.Attributes) <> 0) then
           Attributes := Attributes + [faHiddenCol];
        if ((adFldFixed and F.Attributes) <> 0) then
           Attributes := Attributes + [faFixed];
        if (((adFldUpdatable+adFldUnknownUpdatable) and F.Attributes) = 0) or
           (FieldType = ftAutoInc) then
          Attributes := Attributes + [faReadOnly];
        DataType := FieldType;
        Size := FSize;
        Precision := FPrecision;
        if (DataType = ftDataSet) and (Fields.Count = 0) then
          ObjectView := True;
      end;
    end;
  end;

var
  Count, I: Integer;
begin
  FieldDefs.Clear;
  Count := Recordset.Fields.Count;
  if Count > 0 then
    HasAutoIncProp := PropertyExists(Recordset.Fields[0].Properties, SIsAutoInc);
  for I := 0 to Count - 1 do
    AddFieldDef(Recordset.Fields[I], FieldDefs);
end;

{ Routine to initialize OLE DB Intefaces for data access.  Not currently
  used but may be in a future release }

procedure TCustomADODataSet.InitOleDBAccess(Initializing: Boolean);

  procedure InitBinding(var Binding: TDBBinding; const ColInfo: TDBColumnInfo;
    var Offset: UINT);
  begin
    FillChar(Binding, SizeOf(Binding), 0);
    with Binding do
    begin
      dwPart := DBPART_VALUE + DBPART_LENGTH + DBPART_STATUS;
      iOrdinal := ColInfo.iOrdinal;
      wType := ColInfo.wType;
      obStatus := Offset;
      obLength := Offset + 4;
      obValue := Offset + 8;

      if (wType = DBTYPE_WSTR) and (ColInfo.ulColumnSize <> $FFFFFFFF) then
        cbMaxLen := ColInfo.ulColumnSize * SizeOf(WideChar)
      else
        cbMaxLen := ColInfo.ulColumnSize;
      Inc(Offset, (cbMaxLen + 15) and not 7); {cbMaxLen+Status+Length, rounded up to nearest 8 byte boundry};
    end;
  end;

  procedure SetupBindings;
  var
    Offset, Count, I: UINT;
    ColumnsInfo: IColumnsInfo;
    StringsBuffer: PWideChar;
    ColumnInfo: PDBColumnInfoArray;
    FFieldBindings: array of TDBBinding;
  begin
    Count := 0;
    StringsBuffer := nil;
    ColumnsInfo := FRowset as IColumnsInfo;
    OleCheck(ColumnsInfo.GetColumnInfo(Count, PDBColumnInfo(ColumnInfo),
      StringsBuffer));
    try
      Offset := 0;
      SetLength(FFieldBindings, Count);
      for I := 0 to Count - 1 do
        InitBinding(FFieldBindings[I], ColumnInfo[I], Offset);
      OleCheck(FAccessor.CreateAccessor(DBACCESSOR_ROWDATA, Count,
        PDBBindingArray(FFieldBindings), Offset, FHAccessor, nil));
      FOleRecBufSize := Offset;
    finally
      GlobalMalloc.Free(StringsBuffer);
      GlobalMalloc.Free(ColumnInfo);
    end;
  end;

begin
  if Initializing then
  begin
    FRowset := (Recordset as ADORecordsetConstruction).Rowset as IRowset;
    FRowset.QueryInterface(IAccessor, FAccessor);
    FRowset.QueryInterface(IRowsetFind, FRowsetFind);
    SetupBindings;
  end else
  begin
    if Assigned(FAccessor) and (FHAccessor <> 0) then
    begin
      FAccessor.ReleaseAccessor(FHAccessor, nil);
      FHAccessor := 0;
    end;
    FAccessor := nil;
    FRowsetFind := nil;
    FRowset := nil;
  end;
end;

procedure TCustomADODataSet.PrepareCursor;
begin
  if (FIndexFieldNames <> '') then
    InternalSetSort(StringReplace(FIndexFieldNames, ';', ',', [rfReplaceAll]));
  if MasterDataLink.Active and (Parameters.Count = 0) then
    SetDetailFilter;
  if Filtered and (Filter <> '') then
    ActivateTextFilter(Filter);
  if Recordset.Supports(adMovePrevious + adBookmark) then
    InternalFirst;
end;

procedure TCustomADODataSet.InternalHandleException;
begin
  ApplicationHandleException(Self);
end;

procedure TCustomADODataSet.LoadFromFile(const FileName: WideString);
begin
  Close;
  CommandType := cmdFile;
  LockType := ltBatchOptimistic;
  CommandText := FileName;
  Open;
end;

procedure TCustomADODataSet.SaveToFile(const FileName: WideString;
  Format: TPersistFormat);
begin
  CheckBrowseMode;
  if FileExists(FileName) then DeleteFile(FileName);
  if LowerCase(ExtractFileExt(FileName)) = '.xml' then
    Format := pfXML;
  Recordset.Save(FileName, PersistFormatEnum(Format));
  CursorPosChanged;
end;

procedure TCustomADODataSet.Clone(Source: TCustomADODataSet;
  LockType: TADOLockType);
begin
  Close;
  FRecordsetObject := Source.Recordset.Clone(LockTypeValues[LockType]);
  try
    Open;
  except
    FRecordsetObject := nil;
    raise;
  end;
end;

function TCustomADODataSet.NextRecordset(
  var RecordsAffected: Integer): _Recordset;
var
  VarRecsAffected: OleVariant;
begin
  CheckBrowseMode;
  Result := RecordSet.NextRecordSet(VarRecsAffected);
  RecordsAffected := VarRecsAffected;
end;

procedure TCustomADODataSet.DataEvent(Event: TDataEvent; Info: Integer);
begin
  case Event of
    dePropertyChange:
      IndexDefs.Updated := False;
    deLayoutChange:
      if Active and Assigned(Reserved) and
        (FieldListCheckSum(Self) <> Integer(Reserved)) then
        Reserved := nil;
  end;
  inherited;
end;

procedure TCustomADODataSet.DefineProperties(Filer: TFiler);

  function DesignerDataStored: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := TCustomADODataSet(Filer.Ancestor).DesignerData <> DesignerData else
      Result := DesignerData <> '';
  end;

begin
  inherited;
  Filer.DefineProperty('DesignerData', ReadDesignerData, WriteDesignerData,
    DesignerDataStored);
end;

procedure TCustomADODataSet.ReadDesignerData(Reader: TReader);
begin
  FDesignerData := Reader.ReadString;
end;

procedure TCustomADODataSet.WriteDesignerData(Writer: TWriter);
begin
  Writer.WriteString(FDesignerData);
end;

{ Master / Detail }

procedure TCustomADODataSet.MasterChanged(Sender: TObject);
begin
  if not Active then Exit;
  if Parameters.Count = 0 then
  begin
    CheckBrowseMode;
    if SetDetailFilter then First;
  end else
    RefreshParams;
end;

procedure TCustomADODataSet.MasterDisabled(Sender: TObject);
begin
  if Parameters.Count = 0 then
  begin
    CheckBrowseMode;
    DeactivateFilters;
  end;
end;

procedure TCustomADODataSet.RefreshParams; 
var  
  DataSet: TDataSet;

  function MasterFieldsChanged: boolean;
  var
    I: Integer;
    MasterField: TField;
  begin
    Result := False;
    if MasterDataLink.DataSource <> nil then
      for I := 0 to MasterDataLink.Fields.Count - 1 do
      begin
        MasterField := TField(MasterDataLink.Fields[I]);
        if Parameters.ParamByName(MasterField.FieldName).Value <> MasterField.Value then
        begin
          Result := True;
          break;
        end;
      end;
  end;

begin
  DisableControls;
  try
    if MasterDataLink.DataSource <> nil then
    begin
      DataSet := MasterDataLink.DataSource.DataSet;
      if DataSet <> nil then
        if DataSet.Active and (DataSet.State <> dsSetKey) and MasterFieldsChanged then
        begin
          SetParamsFromCursor;
          Requery;
        end;
    end;
  finally
    EnableControls;
  end;
end;

procedure TCustomADODataSet.SetParamsFromCursor;
var
  I: Integer;
begin
  if MasterDataLink.DataSource <> nil then
    for I := 0 to MasterDataLink.Fields.Count - 1 do
      with TField(MasterDataLink.Fields[I]) do
        Parameters.ParamByName(FieldName).Assign(MasterDataLink.Fields[I]);
end;

function TCustomADODataSet.SetDetailFilter: Boolean;
var
  I: Integer;
  LinkField: TField;
  FieldExpr, FilterStr: string;
begin
  for I := 0 to MasterDataLink.Fields.Count - 1 do
  begin
    if IndexFieldCount > I then
      LinkField := IndexFields[I] else
      LinkField := MasterDataLink.Fields[I];
    FieldExpr := GetFilterStr(LinkField, TField(MasterDataLink.Fields[I]).Value);
    if FilterStr <> '' then
      FilterStr := FilterStr + ' AND ' + FieldExpr      { Do not localize }
    else
      FilterStr := FieldExpr;
    end;
  Result := FDetailFilter <> FilterStr;
  if Result then
  begin
    FDetailFilter := FilterStr;
    ActivateTextFilter(FilterStr);
  end;
end;

procedure TCustomADODataSet.DoOnNewRecord;
var
  I: Integer;
  LinkField: TField;
begin
  PRecInfo(ActiveBuffer)^.RecordStatus := adRecNew;
  FModifiedFields.Clear;
  if MasterDataLink.Active and (MasterDataLink.Fields.Count > 0) then
    for I := 0 to MasterDataLink.Fields.Count - 1 do
    begin
      if IndexFieldCount > I then
        LinkField := IndexFields[I] else
        LinkField := FindField(TField(MasterDataLink.Fields[I]).FieldName);
      if LinkField <> nil then
        LinkField.Assign(TField(MasterDataLink.Fields[I]));
    end;
  inherited DoOnNewRecord;
end;

{ Bookmarks }

procedure TCustomADODataSet.InternalGotoBookmark(Bookmark: Pointer);
begin
  Recordset.Bookmark := POleVariant(Bookmark)^;
end;

procedure TCustomADODataSet.InternalSetToRecord(Buffer: PChar);
begin
  if PRecInfo(Buffer)^.BookmarkFlag in [bfCurrent, bfInserted] then
    InternalGotoBookmark(@PRecInfo(Buffer)^.Bookmark);
end;

function TCustomADODataSet.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := PRecInfo(Buffer)^.BookmarkFlag;
end;

procedure TCustomADODataSet.SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag);
begin
  PRecInfo(Buffer).BookmarkFlag := Value;
end;

procedure TCustomADODataSet.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  Initialize(POleVariant(Data)^);
  POleVariant(Data)^ := PRecInfo(Buffer).Bookmark;
end;

procedure TCustomADODataSet.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  if Assigned(Data) then
    PRecInfo(Buffer).Bookmark := POleVariant(Data)^ else
    PRecInfo(Buffer).BookmarkFlag := bfNA;
end;

function TCustomADODataSet.BookmarkValid(Bookmark: TBookmark): Boolean;
begin
  Result := False;
  if Assigned(Bookmark) and not VarIsNull(POleVariant(Bookmark)^) then
  try
    Recordset.Bookmark := POleVariant(Bookmark)^;
    CursorPosChanged;
    Result := True;
  except
  end;
end;

function TCustomADODataSet.CompareBookmarks(Bookmark1,
  Bookmark2: TBookmark): Integer;
var
  B1, B2: Integer;
const
  RetCodes: array[Boolean, Boolean] of ShortInt = ((2, -1),(1, 0));
begin
  Result := RetCodes[Bookmark1 = nil, Bookmark2 = nil];
  if Result = 2 then
  try
    Result := RecordSet.CompareBookmarks(POleVariant(Bookmark1)^,
      POleVariant(Bookmark2)^) - 1;
    if Result > 1 then
    begin
      B1 := POleVariant(Bookmark1)^;
      B2 := POleVariant(Bookmark2)^;
      if B1 > B2 then
        Result := 1 else
        Result := -1;
    end;
  except
    Result := 0;
  end;
end;

{ Record Functions }

function TCustomADODataSet.GetRecordSize: Word;
begin
  Result := FRecBufSize;
end;

function TCustomADODataSet.AllocRecordBuffer: PChar;
begin
  Result := AllocMem(FRecBufSize);
  Initialize(PRecInfo(Result)^);
  Initialize(PVariantList(Result+SizeOf(TRecInfo))^, Fields.Count);
end;

procedure TCustomADODataSet.FreeRecordBuffer(var Buffer: PChar);
begin
  Finalize(PRecInfo(Buffer)^);
  if Fields.Count > 0 then
    Finalize(PVariantList(Buffer+SizeOf(TRecInfo))^, Fields.Count);
  FreeMem(Buffer);
end;

function TCustomADODataSet.InternalGetRecord(Buffer: PChar;
  GetMode: TGetMode; DoCheck: Boolean): TGetResult;
begin
  if (Assigned(FParentDataSet) and FParentDataSet.Active and
     (FParentDataSet.IsEmpty or (FParentDataset.State = dsInsert))) or
     (MasterDataLink.Active and (DataSource.DataSet.IsEmpty or
                                (DataSource.DataSet.State = dsInsert))) then
  begin
    Result := grEOF;
    Exit;
  end;
  try
    Result := grOK;
    case GetMode of
      gmNext:
        begin
          { Don't call MoveNext during open if no bookmark support }
          if (State <> dsInactive) or (BookmarkSize > 0) then
            if not Recordset.EOF then
              Recordset.MoveNext;
          if Recordset.EOF then
            Result := grEOF;
          { This code blanks out the field values for active
            buffer on forward only recordsets. }
          if BookmarkSize = 0 then
            Finalize(PVariantList(ActiveBuffer+SizeOf(TRecInfo))^, Fields.Count);
        end;
      gmPrior:
        begin
          if not Recordset.BOF then Recordset.MovePrevious;
          if Recordset.BOF then Result := grBOF;
        end;
      gmCurrent:
        begin
          if Recordset.BOF then Result := grBOF;
          if Recordset.EOF then Result := grEOF;
        end;
    end;
    if Result = grOK then
    begin
      with PRecInfo(Buffer)^ do
      begin
        RecordStatus := Recordset.Status;
        if (BookmarkSize > 0) and ((adRecDeleted and RecordStatus) = 0) then
        begin
          BookmarkFlag := bfCurrent;
          Bookmark := Recordset.Bookmark;
          if ControlsDisabled then
            RecordNumber := -2 else
            RecordNumber := Recordset.AbsolutePosition;
        end else
          BookmarkFlag := bfNA;
      end;
      Finalize(PVariantList(Buffer+SizeOf(TRecInfo))^, Fields.Count);
      GetCalcFields(Buffer);
    end;
  except
    if DoCheck then raise;
    Result := grError;
  end;
end;

function TCustomADODataSet.GetRecord(Buffer: PChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
var
  Accept: Boolean;
  SaveState: TDataSetState;
begin
  if (BookmarkSize = 0) and (BufferCount > 1) then
    DatabaseError(SBookmarksRequired);
  if Filtered and Assigned(OnFilterRecord) then
  begin
    FFilterBuffer := Buffer;
    SaveState := SetTempState(dsFilter);
    try
      Accept := True;
      repeat
        Result := InternalGetRecord(Buffer, GetMode, DoCheck);
        if Result = grOK then
        begin
          OnFilterRecord(Self, Accept);
          if not Accept and (GetMode = gmCurrent) then
            Result := grError;
        end;
      until Accept or (Result <> grOK);
    except
      ApplicationHandleException(Self);
      Result := grError;
    end;
    RestoreState(SaveState);
  end else
    Result := InternalGetRecord(Buffer, GetMode, DoCheck)
end;

procedure TCustomADODataSet.InternalInitRecord(Buffer: PChar);
var
  I: Integer;
begin
  for I := 0 to Fields.Count - 1 do
    PVariantList(Buffer+SizeOf(TRecInfo))[I] := Null;
end;

procedure TCustomADODataSet.ClearCalcFields(Buffer: PChar);
var
  I: Integer;
begin
  if CalcFieldsSize > 0 then
    for I := 0 to Fields.Count - 1 do
      with Fields[I] do
        if FieldKind in [fkCalculated, fkLookup] then
          PVariantList(Buffer+SizeOf(TRecInfo))[Index] := Null;
end;

function TCustomADODataSet.GetActiveRecBuf(var RecBuf: PChar): Boolean;
begin
  case State of
    dsBlockRead,
    dsBrowse:
      if IsEmpty or ((BookmarkSize = 0) and Recordset.EOF) then
        RecBuf := nil else
        RecBuf := ActiveBuffer;
    dsEdit, dsInsert, dsNewValue: RecBuf := ActiveBuffer;
    dsCalcFields,
    dsInternalCalc: RecBuf := CalcBuffer;
    dsFilter: RecBuf := FFilterBuffer;
  else
    RecBuf := nil;
  end;
  Result := RecBuf <> nil;
end;

procedure TCustomADODataSet.UpdateRecordSetPosition(Buffer: PChar);
begin
  if (State <> dsCalcFields) and (BookmarkSize > 0) and (RecordSet.BOF or
     RecordSet.EOF or (RecordSet.Bookmark <> PRecInfo(Buffer)^.Bookmark)) then
  begin
    if Assigned(FParentDataSet) and (FParentDataSet.Active) then
      FParentDataSet.UpdateRecordSetPosition(FParentDataSet.ActiveBuffer);
    InternalSetToRecord(Buffer);
    CursorPosChanged;
  end;
end;

{ Field Data }

function TCustomADODataSet.GetBlobFieldData(FieldNo: Integer;
  var Buffer: TBlobByteData): Integer;
begin
  Result := inherited GetBlobFieldData(FieldNo, Buffer);
end;

function TCustomADODataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
begin
  Result := GetFieldData(Field, Buffer, True);
end;

function TCustomADODataSet.GetFieldData(Field: TField; Buffer: Pointer;
  NativeFormat: Boolean): Boolean;
var
  RecBuf: PChar;
  Data: OleVariant;

  procedure CurrToBuffer(const C: Currency);
  begin
    if NativeFormat then
      DataConvert(Field, @C, Buffer, True) else
      Currency(Buffer^) := C;
  end;

  procedure VarToBuffer;
  begin
    with tagVariant(Data) do
      case Field.DataType of
        ftGuid, ftFixedChar, ftString:
          begin
            PChar(Buffer)[Field.Size] := #0;
            WideCharToMultiByte(0, 0, bStrVal, SysStringLen(bStrVal)+1,
              Buffer, Field.Size, nil, nil);
          end;
        ftFixedWideChar, ftWideString:
          WStrCopy(Buffer, bstrVal);
        ftSmallint:
          if vt = VT_UI1 then
            SmallInt(Buffer^) := Byte(cVal) else
            SmallInt(Buffer^) := iVal;
        ftWord:
          if vt = VT_UI1 then
            Word(Buffer^) := bVal else
            Word(Buffer^) := uiVal;
        ftAutoInc, ftInteger:
          Integer(Buffer^) := Data;
        ftFloat, ftCurrency:
          if vt = VT_R8 then
            Double(Buffer^) := dblVal else
            Double(Buffer^) := Data;
        ftBCD:
          if vt = VT_CY then
            CurrToBuffer(cyVal) else
            CurrToBuffer(Data);
        ftBoolean:
          WordBool(Buffer^) := vbool;
        ftDate, ftTime, ftDateTime:
          if NativeFormat then
            DataConvert(Field, @date, Buffer, True) else
            TOleDate(Buffer^) := date;
        ftBytes, ftVarBytes:
          if NativeFormat then
            DataConvert(Field, @Data, Buffer, True) else
            OleVariant(Buffer^) := Data;
        ftInterface: IUnknown(Buffer^) := Data;
        ftIDispatch: IDispatch(Buffer^) := Data;
        ftLargeInt:
          if Decimal(Data).sign > 0 then
            LargeInt(Buffer^):=-1*Decimal(Data).Lo64
          else
            LargeInt(Buffer^):=Decimal(Data).Lo64;
        ftBlob..ftTypedBinary, ftVariant, ftWideMemo: OleVariant(Buffer^) := Data;
      else
        DatabaseErrorFmt(SUsupportedFieldType, [FieldTypeNames[Field.DataType],
          Field.DisplayName]);
      end;
  end;

  procedure RefreshBuffers;
  begin
    Reserved := Pointer(FieldListCheckSum(Self));
    UpdateCursorPos;
    Resync([]);
  end;

begin
  if not Assigned(Reserved) then RefreshBuffers;
  Result := GetActiveRecBuf(RecBuf);
  if not Result then Exit;
  Data := PVariantList(RecBuf+SizeOf(TRecInfo))[Field.Index];
  if VarIsClear(Data) and (Field.FieldNo > 0) then
  begin
    { Don't try to read data from a deleted record }
    if (PRecInfo(RecBuf)^.RecordStatus and adRecDeleted) = 0 then
    begin
      UpdateRecordSetPosition(RecBuf);
      Data := Recordset.Fields[Field.FieldNo-1].Value;
    end;
    if VarIsClear(Data) then Data := Null;
    PVariantList(RecBuf+SizeOf(TRecInfo))[Field.Index] := Data;
  end;
  Result := not VarIsNull(Data);
  if Result and (Buffer <> nil) then
    VarToBuffer;
end;

function TCustomADODataSet.GetFieldData(FieldNo: Integer;
  Buffer: Pointer): Boolean;
begin
  Result := GetFieldData(FieldByNumber(FieldNo), Buffer);
end;

function TCustomADODataSet.GetStateFieldValue(State: TDataSetState;
  Field: TField): Variant;
begin
  if IsEmpty or not (Self.State in [dsBrowse, dsEdit]) then
    Result := Null
  else
  begin
    UpdateCursorPos;
    case State of
      dsOldValue:
        Result := Recordset.Fields[Field.FieldNo-1].OriginalValue;
      dsCurValue:
        Result := Recordset.Fields[Field.FieldNo-1].UnderlyingValue;
    else
      Result := inherited GetStateFieldValue(State, Field);
    end;
  end;
end;

procedure TCustomADODataSet.SetFieldData(Field: TField; Buffer: Pointer);
begin
  SetFieldData(Field, Buffer, True);
end;

procedure TCustomADODataSet.SetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean);

  procedure BufferToVar(var Data: OleVariant);
  begin
    case Field.DataType of
      ftString, ftFixedChar, ftGuid:
        Data := string(PChar(Buffer));
      ftWideString, ftFixedWideChar:
        Data := WideString(PWideChar(Buffer));
      ftAutoInc, ftInteger:
        Data := LongInt(Buffer^);
      ftSmallInt:
        Data := SmallInt(Buffer^);
      ftWord:
        Data := Word(Buffer^);
      ftBoolean:
        Data := WordBool(Buffer^);
      ftFloat, ftCurrency:
        Data := Double(Buffer^);
      ftBlob, ftMemo, ftGraphic, ftVariant, ftWideMemo:
        Data := Variant(Buffer^);
      ftInterface:
        Data := IUnknown(Buffer^);
      ftIDispatch:
        Data := IDispatch(Buffer^);
      ftDate, ftTime, ftDateTime:
        if NativeFormat then
          DataConvert(Field, Buffer, @TVarData(Data).VDate, False) else
          Data := TDateTime(Buffer^);
      ftBCD:
        if NativeFormat then
          DataConvert(Field, Buffer, @TVarData(Data).VCurrency, False) else
          Data := Currency(Buffer^);
      ftBytes, ftVarBytes:
        if NativeFormat then
          DataConvert(Field, Buffer, @Data, False) else
          Data := OleVariant(Buffer^);
      ftLargeInt:
        Data := LargeInt(Buffer^);
      else
        DatabaseErrorFmt(SUsupportedFieldType, [FieldTypeNames[Field.DataType],
          Field.DisplayName]);
    end;
  end;

var
  Data: OleVariant;
  RecBuf: PChar;
begin
  with Field do
  begin
    if not (State in dsWriteModes) then DatabaseError(SNotEditing, Self);
    GetActiveRecBuf(RecBuf);
    if FieldNo > 0 then
    begin
      if ReadOnly and not (State in [dsSetKey, dsFilter]) then
        DatabaseErrorFmt(SFieldReadOnly, [DisplayName]);
      Validate(Buffer);
      if FModifiedFields.IndexOf(Field) = -1 then
        FModifiedFields.Add(Field);
    end;
    if Buffer = nil then
      Data := Null else
      BufferToVar(Data);
    PVariantList(RecBuf+SizeOf(TRecInfo))[Field.Index] := Data;
    if not (State in [dsCalcFields, dsInternalCalc, dsFilter, dsNewValue]) then
      DataEvent(deFieldChange, Longint(Field));
  end;
end;

function TCustomADODataSet.CreateBlobStream(Field: TField;
  Mode: TBlobStreamMode): TStream;
begin
  Result := TADOBlobStream.Create(Field as TBlobField, Mode);
end;

procedure TCustomADODataSet.SetBlockReadSize(Value: Integer);
begin
  inherited;
  FBlockReadInfo := nil; { Placeholder for future optimization here }
end;

{ Record Navigation / Editing }

procedure TCustomADODataSet.InternalFirst;
begin
  if not Recordset.BOF then
  begin
    Recordset.MoveFirst;
    if Recordset.Supports(adMovePrevious) and not Recordset.BOF then
      Recordset.MovePrevious;
  end;
end;

procedure TCustomADODataSet.InternalLast;
begin
  if not Recordset.EOF then
  begin
    Recordset.MoveLast;
    if not Recordset.EOF then
      Recordset.MoveNext;
  end;
end;

function TCustomADODataSet.GetCanModify: Boolean;
begin
  Result := Recordset.Supports(adUpdate);
end;

procedure TCustomADODataSet.InternalEdit;
var
  I: Integer;
begin
  FModifiedFields.Clear;
  if FRecordsetObject.LockType = adLockPessimistic then
  begin
    UpdateCursorPos;
    FLockCursor := FRecordsetObject.Clone(adLockUnspecified);
    FLockCursor.Bookmark := FRecordsetObject.Bookmark;
    { Find an updatable field, and then assign the existing value to lock }
    for I := 0 to FLockCursor.Fields.Count - 1 do
      if ((adFldUpdatable+adFldUnknownUpdatable) and
          Recordset.Fields[I].Attributes) <> 0 then
      begin
        FLockCursor.Fields[I].Value := FLockCursor.Fields[I].Value;
        Break;
      end;
  end;
end;

procedure TCustomADODataSet.InternalInsert;
begin
end;

procedure TCustomADODataSet.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin
  if Append then SetBookmarkFlag(Buffer, bfEOF);
  InternalPost;
end;

procedure TCustomADODataSet.InternalPost;

  procedure UpdateData;
  var
    I: Integer;
    FieldData: PVariantList;
    Data: OleVariant;
  begin
    try
      FieldData := PVariantList(ActiveBuffer + SizeOf(TRecInfo));
      for I := 0 to FModifiedFields.Count - 1 do
        with TField(FModifiedFields[I]) do
        begin
          Data := Unassigned;
          Data := FieldData[Index];
          if not VarIsClear(Data) and
             (((adFldUpdatable+adFldUnknownUpdatable) and
             Recordset.Fields[FieldNo-1].Attributes) <> 0) then
            Recordset.Fields[FieldNo-1].Value := Data;
        end;
      if (Recordset.EditMode * (adEditInProgress + adEditAdd)) <> 0 then
        Recordset.Update(EmptyParam, EmptyParam);
      ReleaseLock;
    except
      CursorPosChanged;
      Recordset.CancelUpdate;
      raise;
    end;
  end;

  procedure CheckForFlyAway;
  begin
    if BookmarkSize > 0 then
    try
      { Check for fly away }
      Recordset.Bookmark := Recordset.Bookmark;
      if Recordset.EOF or Recordset.BOF then
      begin
        { If recordset is empty, then this prevents an error calling InternalFirst }
        if not Recordset.BOF and Recordset.Supports(adMovePrevious) then
          Recordset.MovePrevious;
        { Reposition to last record we were on }
        CursorPosChanged;
        UpdateCursorPos;
      end;
    except
      CursorPosChanged;
    end;
  end;

begin
  inherited;
  UpdateCursorPos;
  try
    if State = dsEdit then
      UpdateData
    else
    begin
      Recordset.AddNew(EmptyParam, EmptyParam);
      try
        UpdateData;
      except
        { When appending recordset may be left in an invalid state, reset it }
        if Recordset.EOF and Recordset.BOF and (Recordset.RecordCount > 0) and EOF then
          Recordset.MoveLast;
        raise;
      end;
    end;
  except
    on E: Exception do
      DatabaseError(E.Message);
  end;
  CheckForFlyAway;
end;

procedure DoRecordsetDelete(DataSet: TCustomADODataSet; AffectRecords: TAffectRecords);
begin
  with DataSet do
  try
    Recordset.Delete(AffectRecordsValues[AffectRecords]);
    { When CacheSize > 1, Recordset allows fetching of deleted records.
      Calling MovePrevious seems to work around it }
    if (CacheSize > 1) and (PRecInfo(ActiveBuffer).RecordNumber <> 1) then
    begin
      Recordset.MovePrevious;
      Recordset.MoveNext;
    end;
    Recordset.MoveNext;
  except
    on E: Exception do
    begin
      Recordset.CancelUpdate;
      DatabaseError(E.Message);
    end;
  end;
end;

procedure TCustomADODataSet.InternalDelete;
begin
  DoRecordsetDelete(Self, arCurrent);
end;

procedure TCustomADODataSet.DeleteRecords(AffectRecords: TAffectRecords);
begin
  CheckActive;
  UpdateCursorPos;
  CursorPosChanged;
  DoRecordsetDelete(Self, AffectRecords);
  Resync([]);
end;

procedure TCustomADODataSet.ReleaseLock;
begin
  if Assigned(FLockCursor) then
  begin
    FLockCursor.CancelUpdate;
    FLockCursor := nil;
  end;
end;

procedure TCustomADODataSet.InternalCancel;
begin
  ReleaseLock;
end;

procedure TCustomADODataSet.CancelUpdates;
begin
  CancelBatch;
end;

procedure TCustomADODataSet.CancelBatch(AffectRecords: TAffectRecords);
begin
  Cancel;
  UpdateCursorPos;
  Recordset.CancelBatch(AffectRecordsValues[AffectRecords]);
  { If all records were previously deleted, ADO does not reset EOF flag }
  if Recordset.EOF and RecordSet.BOF and (Recordset.RecordCount > 0) then
    Recordset.MoveFirst else
    UpdateCursorPos;
  Resync([]);
end;

procedure TCustomADODataSet.UpdateBatch(AffectRecords: TAffectRecords);
begin
  CheckBrowseMode;
  Recordset.UpdateBatch(AffectRecordsValues[AffectRecords]);
  UpdateCursorPos;
  Resync([]);
end;

{ Filters }

procedure TCustomADODataSet.ActivateTextFilter(const FilterText: string);
begin
  try
    Recordset.Filter := FilterText;
  except
    CursorPosChanged;
    raise;
  end;
end;

procedure TCustomADODataSet.DeactivateFilters;
begin
  Recordset.Filter := '';
end;

procedure TCustomADODataSet.SetFilterOptions(Value: TFilterOptions);
begin
  if Value <> [] then
    DatabaseError(SNoFilterOptions);
end;

procedure TCustomADODataSet.SetFilterText(const Value: string);
begin
  if Filter <> Value then
  begin
    if (Parameters.Count = 0) and (Value <> '') and (MasterFields <> '') then
      DatabaseError(SNoDetailFilter, Self);
    if Active and Filtered then
    begin
      CheckBrowseMode;
      if Value <> '' then
        ActivateTextFilter(Value) else
        DeactivateFilters;
      DestroyLookupCursor;
      First;
    end;
    inherited SetFilterText(Value);
    FFilterGroup := fgUnassigned;
  end;
end;

procedure TCustomADODataSet.SetFiltered(Value: Boolean);
begin
  if Filtered <> Value then
  begin
    if Active then
    begin
      CheckBrowseMode;
      DestroyLookupCursor;
      if Value then
      begin
        if FFilterGroup <> fgUnassigned then
          Recordset.Filter := Integer(FilterGroupValues[FFilterGroup]) else
          ActivateTextFilter(Filter)
      end
      else
        DeactivateFilters;
      inherited SetFiltered(Value);
      First;
    end else
      inherited SetFiltered(Value);
  end;
end;

function TCustomADODataSet.GetFilterGroup: TFilterGroup;
var
  FilterVar: OleVariant;
begin
  if Active and Filtered then
  begin
    FilterVar := Recordset.Filter;
    if (VarType(FilterVar) = varInteger) and
      (FilterVar >= adFilterNone) and (FilterVar <= adFilterConflictingRecords) then
      FFilterGroup := TFilterGroup(DWORD(OleEnumToOrd(FilterGroupValues, FilterVar)))
    else
      FFilterGroup := fgUnassigned;
  end;
  Result := FFilterGroup;
end;

procedure TCustomADODataSet.SetFilterGroup(const Value: TFilterGroup);
begin
  CheckBrowseMode;
  inherited SetFilterText('');
  FFilterGroup := Value;
  if (FFilterGroup <> fgUnassigned) and Filtered then
  begin
    Recordset.Filter := Integer(FilterGroupValues[FFilterGroup]);
    First;
  end;
end;

procedure TCustomADODataSet.FilterOnBookmarks(Bookmarks: array of const);
var
  I: Integer;
  BookmarkData: OleVariant;
begin
  CheckBrowseMode;
  BookmarkData := VarArrayCreate([Low(Bookmarks), High(Bookmarks)], varVariant);
  for I := Low(Bookmarks) to High(Bookmarks) do
     BookmarkData[I] := POleVariant(TVarRec(Bookmarks[I]).VPointer)^;
  inherited SetFilterText('');
  FFilterGroup := fgUnassigned;
  DestroyLookupCursor;
  try
    Recordset.Filter := BookmarkData;
    First;
    inherited SetFiltered(True);
  except
    inherited SetFiltered(False);
    raise;
  end;
end;

function TCustomADODataSet.FindRecord(Restart,
  GoForward: Boolean): Boolean;
var
  Cursor: _Recordset;
begin
  CheckBrowseMode;
  SetFound(False);
  UpdateCursorPos;
  CursorPosChanged;
  DoBeforeScroll;
  if not Filtered then
  begin
    if Restart then FFindCursor := nil;
    if not Assigned(FFindCursor) then
    begin
      FFindCursor := Recordset.Clone(adLockReadOnly);
      FFindCursor.Filter := Filter;
    end else
      if not Restart then FFindCursor.Bookmark := Recordset.Bookmark;
    Cursor := FFindCursor;
  end else
    Cursor := Recordset;
  try
    if GoForward then
    begin
      if Restart then
        Cursor.MoveFirst else
        Cursor.MoveNext;
    end else
    begin
      if Restart then
        Cursor.MoveLast else
        Cursor.MovePrevious;
    end;
    if Cursor <> Recordset then
      Recordset.Bookmark := FFindCursor.Bookmark;
    Resync([rmExact, rmCenter]);
    SetFound(True);
  except
    { Exception = not found }
  end;
  Result := Found;
  if Result then DoAfterScroll;
end;

{ Lookup and Locate }

procedure TCustomADODataSet.DestroyLookupCursor;
begin
  FLookupCursor := nil;
  FFindCursor := nil;
end;

function TCustomADODataSet.LocateRecord(const KeyFields: string;
  const KeyValues: OleVariant; Options: TLocateOptions;
  SyncCursor: Boolean): Boolean;
var
  Fields: TList;
  Buffer: PChar;
  I, FieldCount: Integer;
  Partial: Boolean;
  SortList, FieldExpr, LocateFilter: string;
begin
  CheckBrowseMode;
  UpdateCursorPos;
  CursorPosChanged;
  Buffer := TempBuffer;
  Partial := loPartialKey in Options;
  Fields := TList.Create;
  DoBeforeScroll;
  try
    try
      GetFieldList(Fields, KeyFields);
      if not Assigned(FLookupCursor) then
        FLookupCursor := Recordset.Clone(adLockReadOnly);
      if CursorLocation = clUseClient then
      begin
        for I := 0 to Fields.Count - 1 do
          with TField(Fields[I]) do
            if Pos(' ', FieldName) > 0 then
            SortList := Format('%s[%s],', [SortList, FieldName]) else
            SortList := Format('%s%s,', [SortList, FieldName]);
        SetLength(SortList, Length(SortList)-1);
        if FLookupCursor.Sort <> SortList then
          FLookupCursor.Sort := SortList;
      end;
      FLookupCursor.Filter := '';
      FFilterBuffer := Buffer;
      SetTempState(dsFilter);
      try
        InitRecord(Buffer);
        FieldCount := Fields.Count;
        if FieldCount = 1 then
          FLookupCursor.Find(GetFilterStr(FieldByName(KeyFields), KeyValues, Partial), 0,
           adSearchForward, EmptyParam)
        else
        begin
          for I := 0 to FieldCount - 1 do
          begin
            FieldExpr := GetFilterStr(Fields[I], KeyValues[I], (Partial and (I = FieldCount-1)));
            if LocateFilter <> '' then
               LocateFilter := LocateFilter + ' AND ' + FieldExpr else    { Do not localize }
               LocateFilter := FieldExpr;
          end;
          FLookupCursor.Filter := LocateFilter;
        end;
      finally
        RestoreState(dsBrowse);
      end;
    finally
      Fields.Free;
    end;
    Result := not FLookupCursor.EOF;
    if Result then
      if SyncCursor then
      begin
        Recordset.Bookmark := FLookupCursor.Bookmark;
        if Recordset.EOF or Recordset.BOF then
        begin
          Result := False;
          CursorPosChanged;
        end
      end
      else
        { For lookups, read all field values into the temp buffer }
        for I := 0 to Self.Fields.Count - 1 do
         with Self.Fields[I] do
          if FieldKind = fkData then
            PVariantList(Buffer+SizeOf(TRecInfo))[Index] := FLookupCursor.Fields[FieldNo-1].Value;
  except
    Result := False;
  end;
end;

function TCustomADODataSet.Lookup(const KeyFields: string; const KeyValues: Variant;
  const ResultFields: string): Variant;
begin
  Result := Null;
  if LocateRecord(KeyFields, KeyValues, [], False) then
  begin
    SetTempState(dsCalcFields);
    try
      CalculateFields(TempBuffer);
      Result := FieldValues[ResultFields];
    finally
      RestoreState(dsBrowse);
    end;
  end;
end;

function TCustomADODataSet.Locate(const KeyFields: string;
  const KeyValues: Variant; Options: TLocateOptions): Boolean;
begin
  DoBeforeScroll;
  Result := LocateRecord(KeyFields, KeyValues, Options, True);
  if Result then
  begin
    Resync([rmExact, rmCenter]);
    DoAfterScroll;
  end;
end;

function TCustomADODataSet.Seek(const KeyValues: Variant;
  SeekOption: TSeekOption = soFirstEQ): Boolean;
begin
  DoBeforeScroll;
  CheckBrowseMode;
  try
    Recordset.Seek(KeyValues, SeekOptionValues[SeekOption]);
    Result := not RecordSet.EOF;
  except
    Result := False;
  end;
  if Result then
  begin
    Resync([rmExact, rmCenter]);
    DoAfterScroll;
  end else
    CursorPosChanged;
end;

{ Indexes }

procedure TCustomADODataSet.UpdateIndexDefs;
const
  SUnique = 'UNIQUE';                      { Do not localize + 5 }
  SIndexName = 'INDEX_NAME';
  SColumnName = 'COLUMN_NAME';
  SPrimaryKey = 'PRIMARY_KEY';
  SAutoUpdate = 'AUTO_UPDATE';
  SOrdinalPosition = 'ORDINAL_POSITION';
var
  IndexInfo: _Recordset;
begin
  try
    FieldDefs.Update;
    IndexDefs.Clear;
    if (CommandType in [cmdTable, cmdTableDirect]) and (CommandText <> '') then
    begin
      SetConnectionFlag(cfIndex, True);
      try
        IndexInfo := Command.ActiveConnection.OpenSchema(adSchemaIndexes,
          VarArrayOf([Unassigned, Unassigned, Unassigned, Unassigned, CommandText]),
          EmptyParam);
        while not IndexInfo.EOF do
        begin
          if TagVariant(IndexInfo.Fields[SOrdinalPosition].Value).ulVal > 1 then
            with IndexDefs.Find(IndexInfo.Fields[SIndexName].Value) do
              Fields := Format('%s;%s', [Fields, IndexInfo.Fields[SColumnName].Value])
          else
            with IndexDefs.AddIndexDef do
            begin
              Name := VarToWideStr(IndexInfo.Fields[SIndexName].Value);
              Fields := VarToWideStr(IndexInfo.Fields[SColumnName].Value);
              if IndexInfo.Fields[SPrimaryKey].Value = True then
                Options := Options + [ixPrimary];
              if IndexInfo.Fields[SUnique].Value = True then
                Options := Options + [ixUnique];
              if IndexInfo.Fields[SAutoUpdate].Value = False then
                Options := Options + [ixNonMaintained];
            end;
          IndexInfo.MoveNext;
        end;
      finally
        SetConnectionFlag(cfIndex, False);
      end;
    end;
  except
    { do nothing }
  end;
end;

{ RecordsetEvents }

procedure TCustomADODataSet.EnableEvents;
begin
  if Assigned(FOnWillChangeField) or Assigned(FOnFieldChangeComplete) or
    Assigned(FOnWillChangeRecord) or Assigned(FOnRecordChangeComplete) or
    Assigned(FOnWillChangeRecordset) or Assigned(FOnRecordsetChangeComplete) or
    Assigned(FOnWillMove) or Assigned(FOnMoveComplete) or
    Assigned(FOnEndOfRecordset) or Assigned(FOnFetchComplete) or
    Assigned(FOnFetchProgress) then
  begin
    if (CommandType = cmdTableDirect) and (CursorLocation = clUseServer) then
      DatabaseError(SEventsNotSupported);
    OleCheck(ConnectionPoint.Advise(Self as IUnknown, FEventsID));
  end;
end;

function TCustomADODataSet.ConnectionPoint: IConnectionPoint;
var
  ConnPtContainer: IConnectionPointContainer;
begin
  OleCheck(Recordset.QueryInterface(IConnectionPointContainer,
    ConnPtContainer));
  OleCheck(ConnPtContainer.FindConnectionPoint(DIID_RecordsetEvents, Result));
end;

procedure TCustomADODataSet.WillChangeField(cFields: Integer;
  Fields: OleVariant; var adStatus: EventStatusEnum;
  const pRecordset: _Recordset);
var
  EventStatus: TEventStatus;
begin
  if Assigned(OnWillChangeField) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    OnWillChangeField(Self, cFields, Fields, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end else
    adStatus := adStatusUnwantedEvent;
end;

procedure TCustomADODataSet.FieldChangeComplete(cFields: Integer;
  Fields: OleVariant; const pError: Error; var adStatus: EventStatusEnum;
  const pRecordset: _Recordset);
var
  EventStatus: TEventStatus;
begin
  if Assigned(OnFieldChangeComplete) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    OnFieldChangeComplete(Self, cFields, Fields, pError, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end else
    adStatus := adStatusUnwantedEvent;
end;

procedure TCustomADODataSet.WillChangeRecord(adReason: EventReasonEnum;
  cRecords: Integer; var adStatus: EventStatusEnum;
  const pRecordset: _Recordset);
var
  EventStatus: TEventStatus;
begin
  if Assigned(OnWillChangeRecord) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    OnWillChangeRecord(Self, TEventReason(OleEnumToOrd(EventReasonValues,
      adReason)), cRecords, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end else
    adStatus := adStatusUnwantedEvent;
end;

procedure TCustomADODataSet.RecordChangeComplete(adReason: EventReasonEnum;
  cRecords: Integer; const pError: Error; var adStatus: EventStatusEnum;
  const pRecordset: _Recordset);
var
  EventStatus: TEventStatus;
begin
  if Assigned(OnRecordChangeComplete) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    OnRecordChangeComplete(Self, TEventReason(OleEnumToOrd(EventReasonValues,
      adReason)), cRecords, pError, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end else
    adStatus := adStatusUnwantedEvent;
end;

procedure TCustomADODataSet.WillChangeRecordset(adReason: EventReasonEnum;
  var adStatus: EventStatusEnum; const pRecordset: _Recordset);
var
  EventStatus: TEventStatus;
begin
  if Assigned(OnWillChangeRecordset) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    OnWillChangeRecordset(Self, TEventReason(OleEnumToOrd(EventReasonValues,
      adReason)), EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end else
    adStatus := adStatusUnwantedEvent;
end;

procedure TCustomADODataSet.RecordsetChangeComplete(
  adReason: EventReasonEnum; const pError: Error;
  var adStatus: EventStatusEnum; const pRecordset: _Recordset);
var
  EventStatus: TEventStatus;
begin
  if Assigned(OnRecordsetChangeComplete) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    OnRecordsetChangeComplete(Self, TEventReason(OleEnumToOrd(EventReasonValues, adReason)),
      pError, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end else
    adStatus := adStatusUnwantedEvent;
end;

procedure TCustomADODataSet.WillMove(adReason: EventReasonEnum;
  var adStatus: EventStatusEnum; const pRecordset: _Recordset);
var
  EventStatus: TEventStatus;
begin
  if Assigned(OnWillMove) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    OnWillMove(Self, TEventReason(OleEnumToOrd(EventReasonValues, adReason)),
      EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end else
    adStatus := adStatusUnwantedEvent;
end;

procedure TCustomADODataSet.MoveComplete(adReason: EventReasonEnum;
  const pError: Error; var adStatus: EventStatusEnum;
  const pRecordset: _Recordset);
var
  EventStatus: TEventStatus;
begin
  if Assigned(OnMoveComplete) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    OnMoveComplete(Self, TEventReason(OleEnumToOrd(EventReasonValues, adReason)),
      pError, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end else
    adStatus := adStatusUnwantedEvent;
end;

procedure TCustomADODataSet.EndOfRecordset(var fMoreData: WordBool;
  var adStatus: EventStatusEnum; const pRecordset: _Recordset);
var
  EventStatus: TEventStatus;
begin
  if Assigned(OnEndOfRecordset) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    OnEndOfRecordset(Self, fMoreData, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end else
    adStatus := adStatusUnwantedEvent;
end;

procedure TCustomADODataSet.FetchComplete(const pError: Error;
  var adStatus: EventStatusEnum; const pRecordset: _Recordset);
var
  EventStatus: TEventStatus;
begin
  if Assigned(OnFetchComplete) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    OnFetchComplete(Self, pError, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end else
    adStatus := adStatusUnwantedEvent;
end;

procedure TCustomADODataSet.FetchProgress(Progress, MaxProgress: Integer;
  var adStatus: EventStatusEnum; const pRecordset: _Recordset);
var
  EventStatus: TEventStatus;
begin
  if Assigned(OnFetchProgress) then
  begin
    EventStatus := TEventStatus(OleEnumToOrd(EventStatusValues, adStatus));
    OnFetchProgress(Self, Progress, MaxProgress, EventStatus);
    adStatus := EventStatusValues[EventStatus];
  end
  { Note that if we return unwanted for this event it also disables Fetchcomplete }
  else if not Assigned(OnFetchComplete) then
    adStatus := adStatusUnwantedEvent;
end;

{ Informational }

function TCustomADODataSet.GetRecordCount: Longint;
begin
  CheckActive;
  Result := Recordset.RecordCount;
end;

function TCustomADODataSet.GetRecNo: Longint;
var
  BufPtr: PChar;
begin
  CheckActive;
  if IsEmpty or (State = dsInsert) then
    Result := -1
  else
  begin
    if State = dsCalcFields then
      BufPtr := CalcBuffer else
      BufPtr := ActiveBuffer;
    Result := PRecInfo(BufPtr).RecordNumber;
    { If record was read with controls disabled, then the RecordNumber is
      initialized to -2 as a flag to re-read the value from the recordset }
    if Result = -2 then
    begin
      { Position to recordset to the appropriate record }
      InternalSetToRecord(BufPtr);
      CursorPosChanged;
      Result := Recordset.AbsolutePosition;
    end;
  end;
end;

procedure TCustomADODataSet.SetRecNo(Value: Integer);
begin
  if RecNo <> Value then
  begin
    DoBeforeScroll;
    Recordset.AbsolutePosition := Value;
    Resync([rmCenter]);
    DoAfterScroll;
  end;
end;

function TCustomADODataSet.IsSequenced: Boolean;
begin
  Result := Assigned(RecordSet) and Recordset.Supports(adApproxPosition) and
    (CursorLocation <> clUseServer) and not Filtered;
end;

function TCustomADODataSet.Supports(CursorOptions: TCursorOptions): Boolean;
var
  Opt: TCursorOption;
  Options: TOleEnum;
begin
  CheckActive;
  begin
    Options := 0;
    for Opt := Low(TCursorOption) to High(TCursorOption) do
      if Opt in CursorOptions then
        Options := Options + CursorOptionValues[Opt];
    Result := Recordset.Supports(Options);
  end;
end;

{ Property Access }

procedure TCustomADODataSet.PropertyChanged;
begin
  if not (csReading in ComponentState) then
    DataEvent(dePropertyChange, 0);
end;

function TCustomADODataSet.GetCacheSize: Integer;
begin
  if Assigned(Recordset) then
    FCacheSize := Recordset.CacheSize;
  Result := FCacheSize;
end;

procedure TCustomADODataSet.SetCacheSize(const Value: Integer);
begin
  FCacheSize := Value;
  if Assigned(Recordset) then
    Recordset.CacheSize := FCacheSize;
end;

function TCustomADODataSet.GetCommandText: WideString;
begin
  Result := Command.CommandText;
end;

procedure TCustomADODataSet.SetCommandText(const Value: WideString);
begin
  if CommandText <> Value then
  begin
    CheckInactive;
    Command.CommandText := Value;
    PropertyChanged;
  end;
end;

function TCustomADODataSet.GetCommandTimeout: Integer;
begin
  Result := Command.CommandTimeout;
end;

procedure TCustomADODataSet.SetCommandTimeout(const Value: Integer);
begin
  Command.CommandTimeout := Value;
end;

function TCustomADODataSet.GetCommandType: TCommandType;
begin
  if (FRSCommandType in RSOnlyCommandTypes) then
    Result := FRSCommandType else
    Result := Command.CommandType;
end;

procedure TCustomADODataSet.SetCommandType(const Value: TCommandType);
begin
  if CommandType <> Value then
  begin
    CheckInactive;
    FRSCommandType := Value;
    if not (Value in RSOnlyCommandTypes) then
      Command.CommandType := Value else
      Command.CommandType := cmdUnknown;
    PropertyChanged;
  end;
end;

function TCustomADODataSet.GetConnection: TADOConnection;
begin
  if Assigned(Command) then
    Result := Command.Connection else
    Result := nil;
end;

procedure TCustomADODataSet.SetConnection(const Value: TADOConnection);
begin
  if Connection <> Value then
  begin
    { At design time we require the dataset to be closed }
    if (csDesigning in ComponentState) then CheckInactive;
    { Set a flag that we can no longer requery if active }
    FConnectionChanged := Active;
    { Allow nil assignment while open for disconnected recordsets }
    if Active and (Value = nil) then
      RecordSet.Set_ActiveConnection(nil);
    if Assigned(Connection) then Connection.UnregisterClient(Self);
    if Assigned(Command) then Command.Connection := Value;
    if Assigned(Value) then
    begin
      Value.RegisterClient(Self);
      if Active and Assigned(Value.ConnectionObject) then
        RecordSet.Set_ActiveConnection(Value.ConnectionObject);
    end;
    if not (csLoading in ComponentState) then
      DataEvent(dePropertyChange, 0);
  end;
end;

function TCustomADODataSet.GetConnectionString: WideString;
begin
  Result := Command.ConnectionString;
end;

procedure TCustomADODataSet.SetConnectionString(const Value: WideString);
begin
  if ConnectionString <> Value then
  begin
    CheckInactive;
    Connection := nil;
    Command.ConnectionString := Value
  end;
end;

function TCustomADODataSet.GetCursorLocation: TCursorLocation;
begin
  if Assigned(Recordset) then
    FCursorLocation := TCursorLocation(OleEnumToOrd(CursorLocationValues,
      Recordset.CursorLocation));
  Result := FCursorLocation;
end;

procedure TCustomADODataSet.SetCursorLocation(const Value: TCursorLocation);
begin
  if CursorLocation <> Value then
  begin
    CheckInactive;
    FCursorLocation := Value;
    PropertyChanged;
  end;
end;

function TCustomADODataSet.GetCursorType: TCursorType;
begin
  if Assigned(Recordset) then
    FCursorType := TCursorType(OleEnumToOrd(CursorTypeValues,
      Recordset.CursorType));
  Result := FCursorType;
end;

procedure TCustomADODataSet.SetCursorType(const Value: TCursorType);
begin
  if CursorType <> Value then
  begin
    CheckInactive;
    FCursorType := Value;
    PropertyChanged;
  end;
end;

function TCustomADODataSet.GetDataSource: TDataSource;
begin
  Result := MasterDataLink.DataSource;
end;

procedure TCustomADODataSet.SetDataSource(const Value: TDataSource);
begin
  if IsLinkedTo(Value) then DatabaseError(SCircularDataLink, Self);
  MasterDataLink.DataSource := Value;
end;

function TCustomADODataSet.GetExecuteOptions: TExecuteOptions;
begin
  Result := Command.ExecuteOptions;
end;

procedure TCustomADODataSet.SetExecuteOptions(const Value: TExecuteOptions);
begin
  Command.ExecuteOptions := Value;
end;

function TCustomADODataSet.GetLockType: TADOLockType;
begin
  if Assigned(Recordset) then
    FLockType := TADOLockType(OleEnumToOrd(LockTypeValues, Recordset.LockType));
  Result := FLockType;
end;

procedure TCustomADODataSet.SetLockType(const Value: TADOLockType);
begin
  if LockType <> Value then
  begin
    CheckInactive;
    FLockType := Value;
  end;
end;

function TCustomADODataSet.GetMarshalOptions: TMarshalOption;
begin
  if Assigned(Recordset) then
    FMarshalOptions := TMarshalOption(OleEnumToOrd(MarshalOptionValues,
      Recordset.MarshalOptions));
  Result := FMarshalOptions;
end;

procedure TCustomADODataSet.SetMarshalOptions(const Value: TMarshalOption);
begin
  if Assigned(Recordset) then
    Recordset.MarshalOptions := MarshalOptionValues[Value];
  FMarshalOptions := Value;
end;

function TCustomADODataSet.GetMasterFields: WideString;
begin
  Result := MasterDataLink.FieldNames;
end;

procedure TCustomADODataSet.SetMasterFields(const Value: WideString);
begin
  if (Value <> '') and (Filter <> '') then
    DatabaseError(SNoDetailFilter, Self);
  MasterDataLink.FieldNames := Value;
end;

function TCustomADODataSet.GetMaxRecords: Integer;
begin
  if Assigned(Recordset) then
    FMaxRecords := Recordset.MaxRecords;
  Result := FMaxRecords;
end;

procedure TCustomADODataSet.SetMaxRecords(const Value: Integer);
begin
  if MaxRecords <> Value then
  begin
    CheckInactive;
    FMaxRecords := Value;
  end;
end;

function TCustomADODataSet.GetParamCheck: Boolean;
begin
  Result := Command.ParamCheck;
end;

procedure TCustomADODataSet.SetParamCheck(const Value: Boolean);
begin
  Command.ParamCheck := Value;
end;

function TCustomADODataSet.GetParameters: TParameters;
begin
  Result := Command.Parameters;
end;

procedure TCustomADODataSet.SetParameters(const Value: TParameters);
begin
  Command.Parameters.Assign(Value);
end;

function TCustomADODataSet.GetPrepared: Boolean;
begin
  Result := Command.Prepared;
end;

procedure TCustomADODataSet.SetPrepared(const Value: Boolean);
begin
  Command.Prepared := Value;
end;

function TCustomADODataSet.GetProperties: Properties;
begin
  if Assigned(Recordset) then
    Result := Recordset.Properties else
    Result := nil;
end;

procedure TCustomADODataSet.SetRecordset(const Value: _Recordset);
begin
  Close;
  if Assigned(Value) then
  try
    if (Value.State and adStateOpen) = 0 then
      DatabaseError(SRecordsetNotOpen, Self);
    FRecordsetObject := Value;
    Open;
  except
    Close;
    raise;
  end;
end;

function TCustomADODataSet.GetRecordsetState: TObjectStates;
begin
  if Assigned(Recordset) then
    Result := GetStates(Recordset.State) else
    Result := [];
end;

function TCustomADODataSet.GetRecordStatus: TRecordStatusSet;
var
  Status: Integer;
  RecStatus: TRecordStatus;
begin
  CheckActive;
  Result := [];
  if State = dsCalcFields then
    Status := PRecInfo(CalcBuffer).RecordStatus else
    Status := PRecInfo(ActiveBuffer).RecordStatus;
  for RecStatus := Low(TRecordStatus) to High(TRecordStatus) do
    if (RecordStatusValues[RecStatus] and Status) <> 0 then
      Include(Result, RecStatus);
end;

function TCustomADODataSet.GetSort: WideString;
begin
  if Assigned(Recordset) then
    Result := Recordset.Sort else
    Result := '';
end;

procedure TCustomADODataSet.InternalSetSort(Value: WideString);
begin
  Recordset.Sort := Value;
  RefreshIndexFields;
end;

procedure TCustomADODataSet.SetSort(const Value: WideString);
begin
  CheckActive;
  UpdateCursorPos;
  InternalSetSort(Value);
  Resync([]);
end;

function TCustomADODataSet.GetIndexFieldNames: string;
begin
  if Active and (FIndexName = '') then
  begin
    if Supports([coIndex]) and (Recordset.Index <> '') then
    begin
      IndexDefs.Update;
      FIndexFieldNames := IndexDefs.Find(Recordset.Index).Fields;
    end else
      FIndexFieldNames := StringReplace(Sort, ',', ';', [rfReplaceAll]);
  end;
  Result := FIndexFieldNames;
end;

procedure TCustomADODataSet.SetIndexFieldNames(const Value: string);
begin
  if IndexFieldNames <> Value then
  begin
    if Active then
      if Supports([coIndex]) then
      begin
        IndexDefs.Update;
        Recordset.Index := IndexDefs.FindIndexForFields(Value).Name;
        First;
      end else
        Sort := StringReplace(Value, ';', ',', [rfReplaceAll]);
    FIndexFieldNames := Value;
    FIndexName := '';
  end;
end;

function TCustomADODataSet.GetIndexField(Index: Integer): TField;
begin
  Result := FIndexFields[Index];
end;

procedure TCustomADODataSet.SetIndexField(Index: Integer;
  const Value: TField);
begin
  GetIndexField(Index).Assign(Value);
end;

function TCustomADODataSet.GetIndexFieldCount: Integer;
begin
  RefreshIndexFields;
  Result := FIndexFields.Count;
end;

procedure TCustomADODataSet.RefreshIndexFields;
var
  IndexDef: TIndexDef;
  FList: string;
begin
  if Active and (IndexName <> '') then
  begin
    IndexDefs.Update;
    IndexDef := IndexDefs.Find(IndexName);
    if IndexDef <> nil then
      FList := IndexDef.Fields else
      FList := '';
  end else
  begin
    FList := StringReplace(Sort, ',', ';', [rfReplaceAll]);
    FList := StringReplace(FList, ' DESC', '', [rfReplaceAll]);   { Do not localize }
    FList := StringReplace(FList, ' ASC', '', [rfReplaceAll]);    { Do not localize }
    FList := StringReplace(FList, '[', '', [rfReplaceAll]);
    FList := StringReplace(FList, ']', '', [rfReplaceAll]);
  end;
  FIndexFields.Clear;
  GetFieldList(FIndexFields, FList);
end;

function TCustomADODataSet.GetIndexName: WideString;
begin
  if Active and (FIndexName <> RecordSet.Index) then
    FIndexName := RecordSet.Index;
  Result := FIndexName;
end;

procedure TCustomADODataSet.SetIndexName(const Value: WideString);
begin
  if Active then
  begin
    Filter := '';
    RecordSet.Index := Value;
    Resync([]);
  end;
  FIndexName := Value;
  FIndexFieldNames := '';
  RefreshIndexFields;
end;

function TCustomADODataSet.UpdateStatus: TUpdateStatus;
var
  RecordStatus: TRecordStatusSet;
begin
  RecordStatus := GetRecordStatus;
  if rsDeleted in RecordStatus then
    Result := usDeleted
  else if rsNew in RecordStatus then
    Result := usInserted
  else if rsModified in RecordStatus then
    Result := usModified
  else
    Result := usUnmodified;
end;

{ TCustomADODataSet IProviderSupport }

function TCustomADODataSet.PSGetDefaultOrder: TIndexDef;

  function GetIdx(IdxType: TIndexOption): TIndexDef;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to IndexDefs.Count - 1 do
      if IdxType in IndexDefs[i].Options then
      try
        Result := IndexDefs[i];
        GetFieldList(nil, Result.Fields);
        break;
      except
        Result := nil;
      end;
  end;

var
  DefIdx: TIndexDef;
begin
  DefIdx := nil;
  IndexDefs.Update;
  try
    if IndexName <> '' then
      DefIdx := IndexDefs.Find(IndexName)
    else if IndexFieldNames <> '' then
      DefIdx := IndexDefs.GetIndexForFields(IndexFieldNames, False);
    if Assigned(DefIdx) then
      GetFieldList(nil, DefIdx.Fields);
  except
    DefIdx := nil;
  end;
  if not Assigned(DefIdx) then
    DefIdx := GetIdx(ixPrimary);
  if not Assigned(DefIdx) then
    DefIdx := GetIdx(ixUnique);
  if Assigned(DefIdx) then
  begin
    Result := TIndexDef.Create(nil);
    Result.Assign(DefIdx);
  end else
    Result := nil;
end;

procedure TCustomADODataSet.PSExecute;
begin
  Command.Execute;
end;

function TCustomADODataSet.PSExecuteStatement(const ASQL: WideString; AParams: TParams;
  ResultSet: Pointer = nil): Integer;
var
  I: Integer;
  RS: _RecordSet;
  Cmd: TADOCommand;
  InProvider: Boolean;
begin
  InProvider := SetConnectionFlag(cfProvider, True);
  try
    Cmd := TADOCommand.Create(Self);
    try
      Cmd.CommandObject._Set_ActiveConnection(Command.CommandObject.Get_ActiveConnection);
      Cmd.ParamCheck := False;
      Cmd.CommandText := ASQL;
      { Initialize parameter settings from the server if possible }
      try
        if Cmd.Parameters.Refresh and (Cmd.Parameters.Count = AParams.Count) then
          for I := 0 to AParams.Count - 1 do
          begin
            if Cmd.Parameters[I].DataType <> AParams[I].DataType then
              Cmd.Parameters[I].DataType := AParams[I].DataType;
            Cmd.Parameters[I].Value := AParams[I].Value;
          end
        else
          Cmd.Parameters.Assign(AParams);
      except
        Cmd.Parameters.Assign(AParams);
      end;
      if Assigned(ResultSet) then
      begin
        RS := Cmd.Execute;
        TDataSet(ResultSet^) := TADODataSet.Create(nil);
        TADODataSet(ResultSet^).RecordSet := RS;
      end else
      begin
        Cmd.ExecuteOptions := [eoExecuteNoRecords];
        Cmd.Execute(Result, EmptyParam);
      end
    finally
      Cmd.Free;
    end;
  finally
    SetConnectionFlag(cfProvider, InProvider);
  end;
end;

function TCustomADODataSet.PSGetKeyFieldsW: WideString;
var
  i, Pos: Integer;
  IndexFound: Boolean;
begin
  Result := inherited PSGetKeyFieldsW;
  if Result = '' then
  begin
    IndexFound := False;
    IndexDefs.Update;
    for i := 0 to IndexDefs.Count - 1 do
      if ixUnique in IndexDefs[I].Options then
      begin
        Result := IndexDefs[I].Fields;
        IndexFound := (FieldCount = 0);
        if not IndexFound then
        begin
          Pos := 1;
          while Pos <= Length(Result) do
          begin
            IndexFound := FindField(ExtractFieldName(Result, Pos)) <> nil;
            if not IndexFound then Break;
          end;
        end;
        if IndexFound then Break;
      end;
    if not IndexFound then
      Result := '';
  end;
end;

function TCustomADODataSet.PSGetParams: TParams;
begin
  if not Assigned(FParams) then
    FParams := TParams.Create(Self);
  FParams.Assign(Parameters);
  Result := FParams;
end;

function TCustomADODataSet.PSGetTableNameW: WideString;
begin
  case CommandType of
    cmdTable, cmdTableDirect: Result := CommandText;
    cmdText, cmdUnknown: Result := GetTableNameFromSQL(CommandText);
  else
    Result := '';
  end;
end;

function TCustomADODataSet.PSGetQuoteCharW: WideString;
begin
  Result := '';
end;

function TCustomADODataSet.PSInTransaction: Boolean;

  function InMTSTransaction: Boolean;
  var
    ObjectContext: IObjectContext;
  begin
    Result := False;
    try
      ObjectContext := GetObjectContext;
      if Assigned(ObjectContext) then
        Result := ObjectContext.IsInTransaction;
    except
    end;
  end;

begin
  if Assigned(Connection) then
    Result := Connection.InTransaction else
    Result := False;
  if not Result then
    Result := InMTSTransAction;
end;

procedure TCustomADODataSet.PSStartTransaction;
begin
  SetConnectionFlag(cfProvider, True);
  try
    Command.CommandObject.Get_ActiveConnection.BeginTrans;
  except
    SetConnectionFlag(cfProvider, False);
    raise;
  end;
end;

procedure TCustomADODataSet.PSEndTransaction(Commit: Boolean);
var
  ActiveConnection: _Connection;
begin
  ActiveConnection := Command.CommandObject.Get_ActiveConnection;
  if Assigned(ActiveConnection) then
  try
    if Commit then
      ActiveConnection.CommitTrans else
      ActiveConnection.RollbackTrans;
  finally
    SetConnectionFlag(cfProvider, False);
  end;
end;

function TCustomADODataSet.PSIsSQLBased: Boolean;
begin
  Result := True;
end;

procedure TCustomADODataSet.PSReset;
begin
  inherited;
end;

procedure TCustomADODataSet.PSSetCommandText(const CommandText: WideString);
begin
  if CommandText <> '' then
    Self.CommandText := CommandText;
end;

procedure TCustomADODataSet.PSSetParams(AParams: TParams);

  procedure SetTableFilter;
  var
    I: Integer;
    FieldExpr, FilterStr: string;
  begin
    Open;
    for I := 0 to AParams.Count - 1 do
    begin
      FieldExpr := GetFilterStr(FieldByName(AParams[I].Name), AParams[I].Value);
      if FilterStr <> '' then
        FilterStr := FilterStr + ' AND ' + FieldExpr     { Do not localize }
      else
        FilterStr := FieldExpr;
    end;
    ActivateTextFilter(FilterStr);
    First;
  end;

begin
  if AParams.Count > 0 then
  begin
    if (CommandType in [cmdTable, cmdTableDirect]) then
      SetTableFilter
    else
    begin
      Parameters.Assign(AParams);
      Close;
    end;
  end;
  PSReset;
end;

function TCustomADODataSet.PSGetIndexDefs(IndexTypes: TIndexOptions): TIndexDefs;
begin
  Result := GetIndexDefs(IndexDefs, IndexTypes);
end;

procedure TCustomADODataSet.PSGetAttributes(List: TList);
begin
  inherited;
end;

function TCustomADODataSet.PSGetUpdateException(E: Exception;
  Prev: EUpdateError): EUpdateError;
var
  PrevErr: Integer;
begin
  if E is EOleException then
  begin
    if Prev <> nil then
      PrevErr := Prev.ErrorCode else
      PrevErr := 0;
    with EOleException(E) do
      Result := EUpdateError.Create(E.Message, '', ErrorCode, PrevErr, E);
  end else
    Result := inherited PSGetUpdateException(E, Prev);
end;

function TCustomADODataSet.PSIsSQLSupported: Boolean;
begin
  Result := True;
end;

function TCustomADODataSet.PSUpdateRecord(UpdateKind: TUpdateKind;
  Delta: TDataSet): Boolean;
begin
  { OnUpdateRecord is not supported }
  Result := False;
end;

function TCustomADODataSet.PSGetCommandText: string;
begin
  Result := CommandText;
end;

function TCustomADODataSet.PSGetCommandType: TPSCommandType;
begin
  case FCommand.CommandType of
    cmdText : Result := ctQuery;
    cmdTable,
    cmdTableDirect,
    cmdFile : Result := ctTable;
    cmdStoredProc : Result := ctStoredProc;
    else
      Result := ctUnknown;
  end;
end;

procedure TCustomADODataSet.GetDetailLinkFields(MasterFields,
  DetailFields: TList);

  function AddFieldToList(const FieldName: string; DataSet: TDataSet;
    List: TList): Boolean;
  var
    Field: TField;
  begin
    Field := DataSet.FindField(FieldName);
    if (Field <> nil) then
      List.Add(Field);
    Result := Field <> nil;
  end;

var
  i: Integer;
  Idx: TIndexDef;
begin
  MasterFields.Clear;
  DetailFields.Clear;
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
  begin
    if Parameters.Count > 0 then
    begin
      for i := 0 to Parameters.Count - 1 do
        if AddFieldToList(Parameters[i].Name, DataSource.DataSet, MasterFields) then
           AddFieldToList(Parameters[i].Name, Self, DetailFields)
    end
    else if (Self.MasterFields <> '') then
    begin
      Idx := nil;
      DataSource.DataSet.GetFieldList(MasterFields, Self.MasterFields);
      UpdateIndexDefs;
      if IndexName <> '' then
        Idx := IndexDefs.Find(IndexName)
      else if IndexFieldNames <> '' then
        Idx := IndexDefs.GetIndexForFields(IndexFieldNames, False)
      else
        for i := 0 to IndexDefs.Count - 1 do
          if ixPrimary in IndexDefs[i].Options then
          begin
            Idx := IndexDefs[i];
            break;
          end;
      if Idx <> nil then
        GetFieldList(DetailFields, Idx.Fields);
    end;
  end;
end;

{ TADODataSet }

procedure TADODataSet.CreateDataSet;

  procedure CreateFields;
  var
    Options, I: Integer;
  begin
    for I := 0 to FieldDefs.Count - 1 do
    with FieldDefs[I] do
    begin
      if Required then
        Options := 0 else
        Options := adFldIsNullable + adFldMayBeNull;
      if (DataType in [ftMemo, ftWideMemo, ftBlob]) and (Size = 0) then
        Size := High(Integer);
      Recordset.Fields.Append(Name, FieldTypeToADOType(DataType), Size, Options);
    end;
  end;

begin
  CheckInactive;
  InitFieldDefsFromFields;
  FRecordsetObject := CreateADOObject(CLASS_Recordset) as _Recordset;
  try
    Recordset.CursorLocation := adUseClient;
    CreateFields;
    Recordset.Open(EmptyParam, EmptyParam, adOpenUnspecified, adLockUnspecified, 0);
    Open;
  except
    FRecordsetObject := nil;
    raise;
  end;
end;

procedure TADODataSet.DataEvent(Event: TDataEvent; Info: Integer);
begin
  case Event of
    deParentScroll:
      begin
        CheckBrowseMode;
        if FParentRecNo <> FParentDataSet.RecNo then
        begin
          First;
          FParentRecNo := FParentDataSet.RecNo;
        end else
        begin
          UpdateCursorPos;
          Resync([]);
        end;
      end;
    deConnectChange:
      if Active and not Bool(Info) and Assigned(RDSConnection) then
        if (CursorLocation = clUseClient) and not (csDestroying in ComponentState) then
          Recordset.Set_ActiveConnection(nil) else
          Close;
  end;
  inherited;
end;

procedure TADODataSet.GetIndexNames(List: TStrings);
begin
  IndexDefs.Update;
  IndexDefs.GetItemNames(List);
end;

procedure TADODataSet.OpenCursor(InfoQuery: Boolean);
var
  ParentIsEmpty: Boolean;
begin
  if not Assigned(FRecordsetObject) then
  begin
    if DataSetField <> nil then
    begin
      FParentDataSet := DataSetField.DataSet as TCustomADODataSet;
      OpenParentDataSet(FParentDataSet);
      ParentIsEmpty := FParentDataSet.RecordSet.EOF and FParentDataSet.RecordSet.BOF;
      if ParentIsEmpty then
        FParentDataSet.RecordSet.AddNew(EmptyParam, EmptyParam);
      try
        FRecordsetObject := IUnknown(FParentDataSet.Recordset.Fields[DataSetField.FieldName].Value) as _Recordset;
      finally
        if ParentIsEmpty then
          FParentDataSet.RecordSet.CancelUpdate;
      end;
    end
    else if Assigned(RDSConnection)then
      FRecordsetObject := RDSConnection.GetRecordSet(CommandText, ConnectionString);
  end;
  inherited;
end;

procedure TADODataSet.SetConnection(const Value: TADOConnection);
begin
  if Assigned(Value) or (csDestroying in ComponentState) then
    RDSConnection := nil;
  inherited;
end;

procedure TADODataSet.SetRDSConnection(Value: TRDSConnection);
begin
  if Assigned(Value) then
    Connection := nil;
  if Assigned(FRDSConnection) then FRDSConnection.UnRegisterClient(Self);
  FRDSConnection := Value;
  if Assigned(FRDSConnection) then FRDSConnection.RegisterClient(Self);
end;

procedure TADODataSet.SetDataSetField(const Value: TDataSetField);
begin
  if Assigned(Value) then
  begin
    Close;
    ConnectionString := '';
    Connection := nil;
    CommandText := '';
    CursorLocation := clUseClient;
  end;
  inherited;
end;

{ TADOTable }

constructor TADOTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CommandType := cmdTable;
  Command.CommandTextAlias := 'TableName'; { Do not localize }
end;

{ Property Access }

function TADOTable.GetReadOnly: Boolean;
begin
  Result := LockType = ltReadOnly;
end;

procedure TADOTable.SetReadOnly(const Value: Boolean);
begin
  if Value then
    LockType := ltReadOnly else
    LockType := ltOptimistic;
end;

function TADOTable.GetTableDirect: Boolean;
begin
  Result := CommandType = cmdTableDirect;
end;

procedure TADOTable.SetTableDirect(const Value: Boolean);
begin
  if Value then
    CommandType := cmdTableDirect else
    CommandType := cmdTable;
end;

procedure TADOTable.GetIndexNames(List: TStrings);
begin
  IndexDefs.Update;
  IndexDefs.GetItemNames(List);
end;

{ TADOQuery }

constructor TADOQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSQL := TWideStringList.Create;
  TWideStringList(FSQL).OnChange := QueryChanged;
  Command.CommandTextAlias := 'SQL'; { Do not localize }
end;

destructor TADOQuery.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FSQL);
end;

function TADOQuery.ExecSQL: Integer;
begin
  InitializeMasterFields(Self);
  Command.Execute(FRowsAffected, EmptyParam);
  Result := FRowsAffected;
end;

procedure TADOQuery.QueryChanged(Sender: TObject);
begin
  if not (csLoading in ComponentState) then
    Close;
  CommandText := FSQL.Text;
end;

{ Property Access }

function TADOQuery.GetSQL: TWideStrings;
begin
  Result := FSQL;
end;

procedure TADOQuery.SetSQL(const Value: TWideStrings);
begin
  FSQL.Assign(Value);
end;

{ TADOStoredProc }

constructor TADOStoredProc.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Command.CommandType := cmdStoredProc;
  Command.CommandTextAlias := 'ProcedureName'; { Do not localize }
end;

procedure TADOStoredProc.ExecProc;
begin
  InitializeMasterFields(Self);
  Command.Execute;
end;

{ TADOBlobStream }

constructor TADOBlobStream.Create(Field: TBlobField; Mode: TBlobStreamMode);
begin
  FField := Field;
  FFieldNo := FField.FieldNo - 1;
  FDataSet := FField.DataSet as TCustomADODataSet;
  FFieldData := Null;
  FData := Null;
  if not FDataSet.GetActiveRecBuf(FBuffer) then Exit;
  if Mode <> bmRead then
  begin
    if FField.ReadOnly then
      DatabaseErrorFmt(SFieldReadOnly, [FField.DisplayName], FDataSet);
    if not (FDataSet.State in [dsEdit, dsInsert]) then
      DatabaseError(SNotEditing, FDataSet);
  end;
  if Mode = bmWrite then Truncate
  else ReadBlobData;
end;

destructor TADOBlobStream.Destroy;
begin
  if FModified then
  try
    FDataSet.SetFieldData(FField, @FData);
    FField.Modified := True;
    FDataSet.DataEvent(deFieldChange, Longint(FField));
  except
    ApplicationHandleException(Self);
  end;
  inherited Destroy;
end;

procedure TADOBlobStream.ReadBlobData;
begin
  FDataSet.GetFieldData(FField, @FFieldData, True);
  if not VarIsNull(FFieldData) then
  begin
    if VarType(FFieldData) = varOleStr then
    begin
      if FField.BlobType = ftWideMemo then
        Size := Length(WideString(FFieldData)) * sizeof(widechar)
      else
      begin
        { Convert OleStr into a pascal string (format used by TBlobField) }
        FFieldData := string(FFieldData);
        Size := Length(FFieldData);
      end;
    end else
      Size := VarArrayHighBound(FFieldData, 1) + 1;
    FFieldData := Null;
  end;
end;

function TADOBlobStream.Realloc(var NewCapacity: Longint): Pointer;

  procedure VarAlloc(var V: Variant; Field: TFieldType);
  var
    W: WideString;
    S: string;
  begin
    if Field = ftMemo then
    begin
      if not VarIsNull(V) then S := string(V);
      SetLength(S, NewCapacity);
      V := S;
    end else
    if Field = ftWideMemo then
    begin
      if not VarIsNull(V) then W := WideString(V);
      SetLength(W, NewCapacity div 2);
      V := W;
    end else
    begin
      if VarIsClear(V) or VarIsNull(V) then
        V := VarArrayCreate([0, NewCapacity-1], varByte) else
        VarArrayRedim(V, NewCapacity-1);
    end;
  end;

begin
  Result := Memory;
  if NewCapacity <> Capacity then
  begin
    if VarIsArray(FData) then VarArrayUnlock(FData);
    if NewCapacity = 0 then
    begin
      FData := Null;
      Result := nil;
    end else
    begin
      if VarIsNull(FFieldData) then
        VarAlloc(FData, FField.DataType) else
        FData := FFieldData;
      if VarIsArray(FData) then
        Result := VarArrayLock(FData) else
        Result := TVarData(FData).VString;
    end;
  end;
end;

function TADOBlobStream.Write(const Buffer; Count: Longint): Longint;
begin
  Result := inherited Write(Buffer, Count);
  FModified := True;
end;

procedure TADOBlobStream.Truncate;
begin
  Clear;
  FModified := True;
end;

initialization
  OleCheck(CoGetMalloc(1, GlobalMalloc));
finalization
  GlobalMalloc := nil;
end.
