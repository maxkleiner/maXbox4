unit uPSI_DBClient;
{
  to set a dataset for dbgrid
  active=true fix  - onTCustomClientDataSet.OnReconcileError  - params   - create blob stream   - enable controls
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
  TPSImport_DBClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TClientBlobStream(CL: TPSPascalCompiler);
procedure SIRegister_TClientDataSet(CL: TPSPascalCompiler);
procedure SIRegister_TCustomClientDataSet(CL: TPSPascalCompiler);
procedure SIRegister_TAggregates(CL: TPSPascalCompiler);
procedure SIRegister_TAggregate(CL: TPSPascalCompiler);
procedure SIRegister_TConnectionBroker(CL: TPSPascalCompiler);
procedure SIRegister_TCustomRemoteServer(CL: TPSPascalCompiler);
procedure SIRegister_EReconcileError(CL: TPSPascalCompiler);
procedure SIRegister_EDBClient(CL: TPSPascalCompiler);
procedure SIRegister_DBClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DBClient_Routines(S: TPSExec);
procedure RIRegister_TClientBlobStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TClientDataSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomClientDataSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAggregates(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAggregate(CL: TPSRuntimeClassImporter);
procedure RIRegister_TConnectionBroker(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomRemoteServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_EReconcileError(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDBClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,VarUtils
  ,Variants
  ,DB
  ,DSIntf
  ,DBCommon
  ,DBCommonTypes
  ,Midas
  ,SqlTimSt
  //,ActiveX
  ,DBClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TClientBlobStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMemoryStream', 'TClientBlobStream') do
  with CL.AddClassN(CL.FindClass('TMemoryStream'),'TClientBlobStream') do begin
    RegisterMethod('Constructor Create( Field : TBlobField; Mode : TBlobStreamMode)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Truncate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TClientDataSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomClientDataSet', 'TClientDataSet') do
  with CL.AddClassN(CL.FindClass('TCustomClientDataSet'),'TClientDataSet') do begin
    RegisterPublishedProperties;
    //property IndexName: Widestring read GetIndexName write SetIndexName;
    RegisterProperty('IndexName', 'WideString', iptrw);
    RegisterProperty('CommandText', 'WideString', iptrw);
   //RegisterProperty('ProviderName', 'string', iptrw);
    RegisterProperty('Active', 'boolean', iptrw);
    RegisterProperty('Ranged', 'boolean', iptrw);
    RegisterProperty('Params', 'TParams',iptrw);
    RegisterProperty('ObjectView', 'boolean',iptrw);
    RegisterProperty('MasterSource', 'TDataSource',iptrw);
    RegisterProperty('IndexDefs', 'TIndexDefs',iptrw);
    RegisterProperty('FetchOnDemand', 'boolean',iptrw);
    RegisterProperty('IsClone', 'boolean',iptrw);
    RegisterProperty('AutoCalcFields', 'boolean',iptrw);
    RegisterProperty('ProviderEOF', 'boolean',iptrw);
    RegisterProperty('ReadOnly', 'boolean',iptrw);
    RegisterProperty('StoreDefs', 'boolean',iptrw);

    RegisterProperty('Filter', 'string',iptrw);
    RegisterProperty('Filtered', 'boolean',iptrw);
    RegisterProperty('FilterOptions', 'TFilterOptions',iptrw);
    RegisterProperty('Constraints', 'TCheckConstraints',iptrw);

    //property OnReconcileError: TReconcileErrorEvent read FOnReconcileError write FOnReconcileError;
     //property BeforeApplyUpdates: BeforeApplyUpdates read FBeforeApplyUpdates write FBeforeApplyUpdates;
    //property AfterApplyUpdates: TRemoteEvent read FAfterApplyUpdates write FAfterApplyUpdates;
     RegisterProperty('BeforeApplyUpdates', 'TRemoteEvent', iptrw);
     RegisterProperty('AfterApplyUpdates', 'TRemoteEvent', iptrw);
     RegisterProperty('OnReconcileError', 'TReconcileErrorEvent2', iptrw);
   // RegisterProperty('OnWillExecute', 'TWillExecuteEvent', iptrw);


   //  property Filter;
    //property Filtered;
    //property FilterOptions;
   // property Constraints stored ConstraintsStored;

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomClientDataSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWideDataSet', 'TCustomClientDataSet') do
  with CL.AddClassN(CL.FindClass('TWideDataSet'),'TCustomClientDataSet') do begin
    RegisterPublishedProperties;
    RegisterProperty('ProviderName', 'string', iptrw);
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('ConnectionBroker', 'TConnectionBroker', iptrw);
    RegisterProperty('IndexFieldNames', 'Widestring', iptrw);
    RegisterProperty('MasterFields', 'Widestring', iptrw);
    RegisterProperty('PacketRecords', 'Integer', iptrw);
    RegisterProperty('RemoteServer', 'TCustomRemoteServer', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Open');   //active
    RegisterMethod('Procedure Close');
         RegisterMethod('Procedure Free');
     RegisterMethod('Function FIELDBYNAME( const FIELDNAME : STRING) : TFIELD');
    RegisterMethod('Function FINDFIELD( const FIELDNAME : STRING) : TFIELD');
    //RegisterMethod('Function FINDFIELD( const FIELDNAME : WideString) : TFIELD');
     RegisterMethod('Procedure EDIT');
    RegisterMethod('Function LOCATE( const KEYFIELDS : String; const KEYVALUES : VARIANT; OPTIONS : TLOCATEOPTIONS) : BOOLEAN');
    RegisterMethod('Procedure APPEND');
    RegisterMethod('procedure AppendRecord(const Values: array of const);');

    RegisterMethod('Procedure NEXT');
    RegisterMethod('Procedure FIRST');
      RegisterMethod('Function FINDFIRST : BOOLEAN');
   RegisterMethod('Function FINDLAST : BOOLEAN');
   RegisterMethod('Function FINDNEXT : BOOLEAN');
   RegisterMethod('Function FINDPRIOR : BOOLEAN');
   RegisterMethod('Procedure GETFIELDNAMES( LIST : TSTRINGS)');
//  RegisterMethod('Procedure GOTOBOOKMARK( BOOKMARK : TBOOKMARK)');
   RegisterMethod('Procedure INSERT');
   RegisterMethod('Procedure INSERTRECORD( const VALUES : array of const)');
   RegisterMethod('Function ISEMPTY : BOOLEAN');
    //RegisterMethod('Procedure OPEN');
    RegisterMethod('Procedure POST');
    RegisterMethod('Procedure PRIOR');
    RegisterMethod('Procedure REFRESH');
   RegisterMethod('Procedure CANCEL');
   RegisterMethod('Procedure DELETE');
   RegisterMethod('Procedure LAST');
   //RegisterMethod('Procedure Command');
   RegisterMethod('function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream;');
   RegisterMethod('function BookmarkValid(Bookmark: TBookmark): Boolean; ');
   RegisterMethod('function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer;');


    //RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure AddIndex( const Name, Fields : string; Options : TIndexOptions; const DescFields : string; const CaseInsFields : string; const GroupingLevel : Integer)');
    RegisterMethod('Procedure AppendData( const Data : OleVariant; HitEOF : Boolean)');
    RegisterMethod('Procedure ApplyRange');
    RegisterMethod('Function ApplyUpdates( MaxErrors : Integer) : Integer');
    RegisterMethod('Procedure CancelRange');
    RegisterMethod('Procedure CancelUpdates');
    RegisterMethod('Procedure CreateDataSet');
    RegisterMethod('Procedure CloneCursor( Source : TCustomClientDataSet; Reset : Boolean; KeepSettings : Boolean)');
    RegisterMethod('Function ConstraintsDisabled : Boolean');
    RegisterMethod('Function DataRequest( Data : OleVariant) : OleVariant');
    RegisterMethod('Procedure DeleteIndex( const Name : string)');
    RegisterMethod('Procedure DisableConstraints');
    RegisterMethod('Procedure EnableConstraints');
    RegisterMethod('Procedure EditKey');
    RegisterMethod('Procedure EditRangeEnd');
    RegisterMethod('Procedure EditRangeStart');
    RegisterMethod('Procedure EmptyDataSet');
    RegisterMethod('Procedure Execute');
    RegisterMethod('Procedure FetchBlobs');
    RegisterMethod('Procedure FetchDetails');
    RegisterMethod('Procedure RefreshRecord');
    RegisterMethod('Procedure FetchParams');
    RegisterMethod('Function FindKey( const KeyValues : array of const) : Boolean');
    RegisterMethod('Procedure FindNearest( const KeyValues : array of const)');
    RegisterMethod('Function GetGroupState( Level : Integer) : TGroupPosInds');
    RegisterMethod('Procedure GetIndexInfo( IndexName : string)');
    RegisterMethod('Procedure GetIndexNames( List : TStrings)');
    RegisterMethod('Function GetNextPacket : Integer');
    RegisterMethod('Function GetOptionalParam( const ParamName : string) : OleVariant');
    RegisterMethod('Procedure GotoCurrent( DataSet : TCustomClientDataSet)');
    RegisterMethod('Function GotoKey : Boolean');
    RegisterMethod('Procedure GotoNearest');
    RegisterProperty('HasAppServer', 'Boolean', iptr);
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure MergeChangeLog');
    RegisterMethod('Function Reconcile( const Results : OleVariant) : Boolean');
    RegisterMethod('Procedure RevertRecord');
    RegisterMethod('Procedure SaveToFile( const FileName : string; Format : TDataPacketFormat)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream; Format : TDataPacketFormat)');
    RegisterMethod('Procedure SetAltRecBuffers( Old, New, Cur : PChar)');
    RegisterMethod('Procedure SetKey');
    RegisterMethod('Procedure SetOptionalParam( const ParamName : string; const Value : OleVariant; IncludeInDelta : Boolean)');
    RegisterMethod('Procedure SetProvider( Provider : TComponent)');
    RegisterMethod('Procedure SetRange( const StartValues, EndValues : array of const)');
    RegisterMethod('Procedure SetRangeEnd');
    RegisterMethod('Procedure SetRangeStart');
    RegisterMethod('procedure ActivateFilters;');
    RegisterMethod('function UpdateStatus: TUpdateStatus;');
    RegisterMethod('Procedure DISABLECONTROLS');
    //RegisterMethod('Procedure EDIT');
    RegisterMethod('Procedure ENABLECONTROLS');


    {procedure AddDataPacket(const Data: OleVariant; HitEOF: Boolean); virtual;
    procedure AddFieldDesc(FieldDescs: TFieldDescList; var DescNo: Integer;
      var FieldID: Integer; FieldDefs: TFieldDefs);
    procedure AllocKeyBuffers;
    function AllocRecordBuffer: PChar; override;
    procedure Check(Status: DBResult);
    procedure CheckDetailRecords; virtual;
    procedure CheckProviderEOF; virtual;
    procedure CheckSetKeyMode;
    procedure ClearCalcFields(Buffer: PChar); override;
    procedure CloseCursor; override;
    procedure DataConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean); override;
    procedure DataEvent(Event: TDataEvent; Info: Longint); override;
    procedure DeactivateFilters;}

    RegisterMethod('Function UndoLastChange( FollowChange : Boolean) : Boolean');
    RegisterProperty('ActiveAggs', 'TList Integer', iptr);
    RegisterProperty('ChangeCount', 'Integer', iptr);
    RegisterProperty('CloneSource', 'TCustomClientDataSet', iptr);
    RegisterProperty('Data', 'OleVariant', iptrw);
    RegisterProperty('XMLData', 'string', iptrw);
    RegisterProperty('AppServer', 'IAppServer', iptrw);
    RegisterProperty('DataSize', 'Integer', iptr);
    RegisterProperty('Delta', 'OleVariant', iptr);
    RegisterProperty('GroupingLevel', 'Integer', iptr);
    RegisterProperty('IndexFieldCount', 'Integer', iptr);
    RegisterProperty('IndexFields', 'TField Integer', iptrw);
    RegisterProperty('KeyExclusive', 'Boolean', iptrw);
    RegisterProperty('KeyFieldCount', 'Integer', iptrw);
    RegisterProperty('KeySize', 'Word', iptr);
    RegisterProperty('Active', 'boolean', iptrw);
     RegisterProperty('LogChanges', 'Boolean', iptrw);
    RegisterProperty('SavePoint', 'Integer', iptrw);
    RegisterProperty('StatusFilter', 'TUpdateStatusSet', iptrw);
      RegisterProperty('CANMODIFY', 'BOOLEAN', iptr);
   RegisterProperty('DATASETFIELD', 'TDATASETFIELD', iptrw);
   RegisterProperty('DATASOURCE', 'TDATASOURCE', iptr);
   RegisterProperty('DEFAULTFIELDS', 'BOOLEAN', iptr);
   RegisterProperty('DESIGNER', 'TDATASETDESIGNER', iptr);
   RegisterProperty('EOF', 'BOOLEAN', iptr);
   RegisterProperty('BOF', 'BOOLEAN', iptr);
   RegisterProperty('SQL', 'TStrings', iptrw);

   RegisterProperty('BLOCKREADSIZE', 'INTEGER', iptrw);
   RegisterProperty('FIELDCOUNT', 'INTEGER', iptr);
   RegisterProperty('FIELDDEFS', 'TFIELDDEFS', iptrw);
   RegisterProperty('FIELDDEFLIST', 'TFIELDDEFLIST', iptr);
   RegisterProperty('FIELDS', 'TFIELDS', iptr);
   RegisterProperty('FIELDLIST', 'TFIELDLIST', iptr);
   RegisterProperty('FIELDVALUES', 'VARIANT String', iptrw);
   RegisterProperty('FOUND', 'BOOLEAN', iptr);
   RegisterProperty('RECORDCOUNT', 'INTEGER', iptr);
   RegisterProperty('RECNO', 'INTEGER', iptrw);
   RegisterProperty('RECORDSIZE', 'WORD', iptr);
   //    RegisterProperty('OnExecuteComplete', 'TExecuteCompleteEvent', iptrw);
   // RegisterProperty('OnWillExecute', 'TWillExecuteEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAggregates(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TAggregates') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TAggregates') do begin
    RegisterMethod('Constructor Create( Owner : TPersistent)');
    RegisterMethod('Function Add : TAggregate');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Find( const DisplayName : string) : TAggregate');
    RegisterMethod('Function IndexOf( const DisplayName : string) : Integer');
    RegisterProperty('Items', 'TAggregate Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAggregate(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TAggregate') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TAggregate') do begin
    RegisterMethod('Constructor Create( Aggregates : TAggregates; ADataSet : TCustomClientDataSet);');
    RegisterMethod('Assign(Source: TPersistent);');
    RegisterMethod('Function Value : Variant');
    RegisterProperty('AggHandle', 'hDSAggregate', iptrw);
    RegisterProperty('InUse', 'Boolean', iptrw);
    RegisterProperty('DataSet', 'TCustomClientDataSet', iptr);
    RegisterProperty('DataSize', 'Integer', iptr);
    RegisterProperty('DataType', 'TFieldType', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('AggregateName', 'String', iptrw);
    RegisterProperty('Expression', 'string', iptrw);
    RegisterProperty('GroupingLevel', 'Integer', iptrw);
    RegisterProperty('IndexName', 'string', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('OnUpdate', 'TAggUpdateEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TConnectionBroker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomRemoteServer', 'TConnectionBroker') do
  with CL.AddClassN(CL.FindClass('TCustomRemoteServer'),'TConnectionBroker') do
  begin
    RegisterProperty('Connection', 'TCustomRemoteServer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomRemoteServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomConnection', 'TCustomRemoteServer') do
  with CL.AddClassN(CL.FindClass('TCustomConnection'),'TCustomRemoteServer') do begin
    RegisterMethod('Function GetServer : IAppServer');
    RegisterMethod('Function GetServerList : OleVariant');
    RegisterMethod('Procedure GetProviderNames( Proc : TGetStrProc)');
    RegisterProperty('AppServer', 'Variant', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EReconcileError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDBClient', 'EReconcileError') do
  with CL.AddClassN(CL.FindClass('EDBClient'),'EReconcileError') do begin
    RegisterMethod('Constructor Create( NativeError, Context : string; ErrorCode, PreviousError : DBResult)');
    RegisterProperty('Context', 'string', iptr);
    RegisterProperty('PreviousError', 'DBResult', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDBClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDatabaseError', 'EDBClient') do
  with CL.AddClassN(CL.FindClass('EDatabaseError'),'EDBClient') do begin
    RegisterMethod('Constructor Create( Message : string; ErrorCode : DBResult)');
    RegisterProperty('ErrorCode', 'DBResult', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBClient(CL: TPSPascalCompiler);
begin
  SIRegister_EDBClient(CL);
  SIRegister_EReconcileError(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomClientDataSet');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TClientDataSet');
  CL.AddTypeS('TGetUsernameEvent', 'Procedure ( Sender : TObject; var Username: string)');
  SIRegister_TCustomRemoteServer(CL);
  SIRegister_TConnectionBroker(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAggregate');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAggregates');
  CL.AddTypeS('TAggUpdateEvent', 'Procedure ( Agg : TAggregate)');
  SIRegister_TAggregate(CL);
  SIRegister_TAggregates(CL);
  //CL.AddTypeS('TFieldDescList', 'array of DSFLDDesc');
  //CL.AddTypeS('TCDSRecInfo', 'TRecInfo');
  //CL.AddTypeS('PKeyBuffer', '^TKeyBuffer // will not work');
  CL.AddTypeS('TKeyBuffer', 'record Modified : Boolean; Exclusive : Boolean; Fi'
   +'eldCount : Integer; {Data : record end ;} end');
  CL.AddTypeS('TCDSKeyBuffer', 'TKeyBuffer');
  CL.AddTypeS('TDataPacketFormat', '( dfBinary, dfXML, dfXMLUTF8 )');
  CL.AddTypeS('TReconcileAction', '( raSkip, raAbort, raMerge, raCorrect, raCancel, raRefresh )');
  CL.AddTypeS('TReconcileErrorEvent', 'Procedure ( DataSet : TCustomClientDataS'
   +'et; E : EReconcileError; UpdateKind : TUpdateKind; var Action : TReconcileAction) of object');
  CL.AddTypeS('TRemoteEvent', 'Procedure ( Sender : TObject; var OwnerData : OleVariant)');

  CL.AddTypeS('TReconcileErrorEvent2', 'Procedure ( DataSet : TCustomClientDataS'
   +'et; E : EReconcileError;  UpdateKind : TUpdateKind; var Action : TReconcileAction) of object');
  CL.AddTypeS('TRemoteEvent', 'Procedure ( Sender : TObject; var OwnerData : OleVariant)');

   // TReconcileErrorEvent = procedure(DataSet: TCustomClientDataSet; E: EReconcileError;
   // UpdateKind: TUpdateKind; var Action: TReconcileAction) of object;

  {CL.AddTypeS('TReconcileInfo', 'record DataSet : TDataSet; UpdateKind : TUpdat'
   +'eKind; ReconcileError : EReconcileError; ActionRef :  ^TReconcileAction //'
   +' will not work; end'); }
  CL.AddTypeS('TDataSetOption', '( doDisableInserts, doDisableDeletes, doDisableEdits, doNoResetCall )');
  CL.AddTypeS('TDataSetOptions', 'set of TDataSetOption');
  CL.AddTypeS('TFetchOption', '( foRecord, foBlobs, foDetails )');
  CL.AddTypeS('TFetchOptions', 'set of TFetchOption');
  SIRegister_TCustomClientDataSet(CL);
  SIRegister_TClientDataSet(CL);
  SIRegister_TClientBlobStream(CL);
 CL.AddConstantN('AllParamTypes','LongInt').Value.ts32 := ord(ptUnknown) or ord(ptInput) or ord(ptOutput) or ord(ptInputOutput) or ord(ptResult);
 CL.AddDelphiFunction('Function PackageParams( Params : TParams; Types : TParamTypes) : OleVariant');
 CL.AddDelphiFunction('Procedure UnpackParams( const Source : OleVariant; Dest : TParams)');
 CL.AddConstantN('AllRecords','LongInt').SetInt( - 1);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetStatusFilter_W(Self: TCustomClientDataSet; const T: TUpdateStatusSet);
begin Self.StatusFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetStatusFilter_R(Self: TCustomClientDataSet; var T: TUpdateStatusSet);
begin T := Self.StatusFilter; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetSavePoint_W(Self: TCustomClientDataSet; const T: Integer);
begin Self.SavePoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetSavePoint_R(Self: TCustomClientDataSet; var T: Integer);
begin T := Self.SavePoint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetLogChanges_W(Self: TCustomClientDataSet; const T: Boolean);
begin Self.LogChanges := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetLogChanges_R(Self: TCustomClientDataSet; var T: Boolean);
begin T := Self.LogChanges; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetKeySize_R(Self: TCustomClientDataSet; var T: Word);
begin T := Self.KeySize; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetKeyFieldCount_W(Self: TCustomClientDataSet; const T: Integer);
begin Self.KeyFieldCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetKeyFieldCount_R(Self: TCustomClientDataSet; var T: Integer);
begin T := Self.KeyFieldCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetKeyExclusive_W(Self: TCustomClientDataSet; const T: Boolean);
begin Self.KeyExclusive := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetKeyExclusive_R(Self: TCustomClientDataSet; var T: Boolean);
begin T := Self.KeyExclusive; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetIndexFields_W(Self: TCustomClientDataSet; const T: TField; const t1: Integer);
begin Self.IndexFields[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetIndexFields_R(Self: TCustomClientDataSet; var T: TField; const t1: Integer);
begin T := Self.IndexFields[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetIndexFieldCount_R(Self: TCustomClientDataSet; var T: Integer);
begin T := Self.IndexFieldCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetGroupingLevel_R(Self: TCustomClientDataSet; var T: Integer);
begin T := Self.GroupingLevel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetDelta_R(Self: TCustomClientDataSet; var T: OleVariant);
begin T := Self.Delta; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetDataSize_R(Self: TCustomClientDataSet; var T: Integer);
begin T := Self.DataSize; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetAppServer_W(Self: TCustomClientDataSet; const T: IAppServer);
begin Self.AppServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetAppServer_R(Self: TCustomClientDataSet; var T: IAppServer);
begin T := Self.AppServer; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetXMLData_W(Self: TCustomClientDataSet; const T: string);
begin Self.XMLData := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetXMLData_R(Self: TCustomClientDataSet; var T: string);
begin T := Self.XMLData; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetActive_W(Self: TCustomClientDataSet; const T: boolean);
begin Self.Active:= T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetActive_R(Self: TCustomClientDataSet; var T: boolean);
begin T:= Self.Active; end;


(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetData_W(Self: TCustomClientDataSet; const T: OleVariant);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetData_R(Self: TCustomClientDataSet; var T: OleVariant);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetCloneSource_R(Self: TCustomClientDataSet; var T: TCustomClientDataSet);
begin T := Self.CloneSource; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetChangeCount_R(Self: TCustomClientDataSet; var T: Integer);
begin T := Self.ChangeCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetActiveAggs_R(Self: TCustomClientDataSet; var T: TList; const t1: Integer);
begin T := Self.ActiveAggs[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetHasAppServer_R(Self: TCustomClientDataSet; var T: Boolean);
begin T := Self.HasAppServer; end;

(*----------------------------------------------------------------------------*)
Function TCustomClientDataSetGetFieldData_P(Self: TCustomClientDataSet;  FieldNo : Integer; Buffer : Pointer) : Boolean;
Begin Result := Self.GetFieldData(FieldNo, Buffer); END;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetRemoteServer_W(Self: TCustomClientDataSet; const T: TCustomRemoteServer);
begin Self.RemoteServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetRemoteServer_R(Self: TCustomClientDataSet; var T: TCustomRemoteServer);
begin T := Self.RemoteServer; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetPacketRecords_W(Self: TCustomClientDataSet; const T: Integer);
begin Self.PacketRecords := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetPacketRecords_R(Self: TCustomClientDataSet; var T: Integer);
begin T := Self.PacketRecords; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetMasterFields_W(Self: TCustomClientDataSet; const T: Widestring);
begin Self.MasterFields := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetMasterFields_R(Self: TCustomClientDataSet; var T: Widestring);
begin T := Self.MasterFields; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetIndexFieldNames_W(Self: TCustomClientDataSet; const T: Widestring);
begin Self.IndexFieldNames := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetIndexFieldNames_R(Self: TCustomClientDataSet; var T: Widestring);
begin T := Self.IndexFieldNames; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetConnectionBroker_W(Self: TCustomClientDataSet; const T: TConnectionBroker);
begin Self.ConnectionBroker := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetConnectionBroker_R(Self: TCustomClientDataSet; var T: TConnectionBroker);
begin T := Self.ConnectionBroker; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetFileName_W(Self: TCustomClientDataSet; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetFileName_R(Self: TCustomClientDataSet; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetProviderName_W(Self: TCustomClientDataSet; const T: string);
begin Self.ProviderName := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomClientDataSetProviderName_R(Self: TCustomClientDataSet; var T: string);
begin T := Self.ProviderName; end;

(*----------------------------------------------------------------------------*)
procedure TAggregatesItems_W(Self: TAggregates; const T: TAggregate; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TAggregatesItems_R(Self: TAggregates; var T: TAggregate; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateOnUpdate_W(Self: TAggregate; const T: TAggUpdateEvent);
begin Self.OnUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateOnUpdate_R(Self: TAggregate; var T: TAggUpdateEvent);
begin T := Self.OnUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateVisible_W(Self: TAggregate; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateVisible_R(Self: TAggregate; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateIndexName_W(Self: TAggregate; const T: string);
begin Self.IndexName := T; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateIndexName_R(Self: TAggregate; var T: string);
begin T := Self.IndexName; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateGroupingLevel_W(Self: TAggregate; const T: Integer);
begin Self.GroupingLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateGroupingLevel_R(Self: TAggregate; var T: Integer);
begin T := Self.GroupingLevel; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateExpression_W(Self: TAggregate; const T: string);
begin Self.Expression := T; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateExpression_R(Self: TAggregate; var T: string);
begin T := Self.Expression; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateAggregateName_W(Self: TAggregate; const T: String);
begin Self.AggregateName := T; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateAggregateName_R(Self: TAggregate; var T: String);
begin T := Self.AggregateName; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateActive_W(Self: TAggregate; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateActive_R(Self: TAggregate; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateDataType_R(Self: TAggregate; var T: TFieldType);
begin T := Self.DataType; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateDataSize_R(Self: TAggregate; var T: Integer);
begin T := Self.DataSize; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateDataSet_R(Self: TAggregate; var T: TCustomClientDataSet);
begin T := Self.DataSet; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateInUse_W(Self: TAggregate; const T: Boolean);
begin Self.InUse := T; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateInUse_R(Self: TAggregate; var T: Boolean);
begin T := Self.InUse; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateAggHandle_W(Self: TAggregate; const T: hDSAggregate);
begin Self.AggHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TAggregateAggHandle_R(Self: TAggregate; var T: hDSAggregate);
begin T := Self.AggHandle; end;

(*----------------------------------------------------------------------------*)
Function TAggregateCreate_P(Self: TClass; CreateNewInstance: Boolean;  Aggregates : TAggregates; ADataSet : TCustomClientDataSet):TObject;
Begin Result := TAggregate.Create(Aggregates, ADataSet); END;

(*----------------------------------------------------------------------------*)
procedure TConnectionBrokerConnection_W(Self: TConnectionBroker; const T: TCustomRemoteServer);
begin Self.Connection := T; end;

(*----------------------------------------------------------------------------*)
procedure TConnectionBrokerConnection_R(Self: TConnectionBroker; var T: TCustomRemoteServer);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure TCustomRemoteServerAppServer_R(Self: TCustomRemoteServer; var T: Variant);
begin T := Self.AppServer; end;

(*----------------------------------------------------------------------------*)
procedure EReconcileErrorPreviousError_R(Self: EReconcileError; var T: DBResult);
begin T := Self.PreviousError; end;

(*----------------------------------------------------------------------------*)
procedure EReconcileErrorContext_R(Self: EReconcileError; var T: string);
begin T := Self.Context; end;

(*----------------------------------------------------------------------------*)
procedure EDBClientErrorCode_R(Self: EDBClient; var T: DBResult);
begin T := Self.ErrorCode; end;


procedure TDATASETFIELDCOUNT_R(Self: TCustomClientDataSet; var T: INTEGER);
begin T := Self.FIELDCOUNT; end;


procedure TDATASETEOF_R(Self: TCustomClientDataSet; var T: BOOLEAN);
begin T := Self.EOF; end;

procedure TDATASETBOF_R(Self: TCustomClientDataSet; var T: BOOLEAN);
begin T := Self.BOF; end;


procedure TDATASETDEFAULTFIELDS_R(Self: TCustomClientDataSet; var T: BOOLEAN);
begin T := Self.DEFAULTFIELDS; end;

procedure TDATASETDATASOURCE_R(Self: TCustomClientDataSet; var T: TDATASOURCE);
begin T := Self.DATASOURCE; end;


procedure TDATASETCANMODIFY_R(Self: TCustomClientDataSet; var T: BOOLEAN);
begin T := Self.CANMODIFY; end;

procedure TDATASETFOUND_R(Self: TCustomClientDataSet; var T: BOOLEAN);
begin T := Self.FOUND; end;

procedure TDATASETFIELDVALUES_W(Self: TCustomClientDataSet; const T: VARIANT; const t1: String);
begin Self.FIELDVALUES[t1] := T; end;

procedure TDATASETFIELDVALUES_R(Self: TCustomClientDataSet; var T: VARIANT; const t1: String);
begin T := Self.FIELDVALUES[t1]; end;

procedure TDATASETFIELDS_R(Self: TCustomClientDataSet; var T: TFIELDS);
begin T := Self.FIELDS; end;

//{$IFNDEF FPC}

procedure TDATASETFIELDLIST_R(Self: TCustomClientDataSet; var T: TFIELDLIST);
begin T := Self.FIELDLIST; end;


procedure TDATASETFIELDDEFLIST_R(Self: TCustomClientDataSet; var T: TFIELDDEFLIST);
begin T := Self.FIELDDEFLIST; end;

procedure TDATASETFIELDDEFS_W(Self: TCustomClientDataSet; const T: TFIELDDEFS);
begin Self.FIELDDEFS := T; end;

procedure TDATASETFIELDDEFS_R(Self: TCustomClientDataSet; var T: TFIELDDEFS);
begin T := Self.FIELDDEFS; end;

procedure TDATASETBLOCKREADSIZE_W(Self: TCustomClientDataSet; const T: INTEGER);
begin Self.BLOCKREADSIZE := T; end;

procedure TDATASETBLOCKREADSIZE_R(Self: TCustomClientDataSet; var T: INTEGER);
begin T := Self.BLOCKREADSIZE; end;

procedure TDATASETDESIGNER_R(Self: TCustomClientDataSet; var T: TDATASETDESIGNER);
begin T := Self.DESIGNER; end;


procedure TDATASETDATASETFIELD_W(Self: TCustomClientDataSet; const T: TDATASETFIELD);
begin Self.DATASETFIELD := T; end;


procedure TDATASETDATASETFIELD_R(Self: TCustomClientDataSet; var T: TDATASETFIELD);
begin T := Self.DATASETFIELD; end;

procedure TDATASETRECORDSIZE_R(Self: TCustomClientDataSet; var T: WORD);
begin T := Self.RECORDSIZE; end;

procedure TDATASETRECNO_W(Self: TCustomClientDataSet; const T: INTEGER);
begin Self.RECNO := T; end;

procedure TDATASETRECNO_R(Self: TCustomClientDataSet; var T: INTEGER);
begin T := Self.RECNO; end;

procedure TDATASETRECORDCOUNT_R(Self: TCustomClientDataSet; var T: INTEGER);
begin T := Self.RECORDCOUNT; end;

procedure TDATASETActive_W(Self: TCustomClientDataSet; var T: boolean);
begin Self.Active:= T; end;

procedure TDATASETActive_R(Self: TCustomClientDataSet; var T: boolean);
begin T := Self.Active; end;


procedure TDataSetSQL_W(Self: TCustomClientDataSet; const T: TStrings);
begin //Self.SQL:= T;
 end;

(*----------------------------------------------------------------------------*)
procedure TDataSetSQL_R(Self: TCustomClientDataSet; var T: TStrings);
begin //T:= Self.SQL;
 end;




(*----------------------------------------------------------------------------*)
procedure RIRegister_DBClient_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PackageParams, 'PackageParams', cdRegister);
 S.RegisterDelphiFunction(@UnpackParams, 'UnpackParams', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TClientBlobStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TClientBlobStream) do begin
    RegisterConstructor(@TClientBlobStream.Create, 'Create');
    RegisterMethod(@TClientBlobStream.Destroy, 'Free');
    RegisterMethod(@TClientBlobStream.Truncate, 'Truncate');
  end;
end;

procedure TTClientDataSetonrc_W(Self: TClientDataSet; const T: TReconcileErrorEvent );
begin Self.OnReconcileError := T; end;

(*----------------------------------------------------------------------------*)
procedure TClientDataSetonrc_R(Self: TClientDataSet; var T: TReconcileErrorEvent );
begin T := Self.OnReconcileError; end;


procedure TTClientDataSetbef_W(Self: TClientDataSet; const T: TRemoteEvent );
begin Self.BeforeApplyUpdates := T; end;

(*----------------------------------------------------------------------------*)
procedure TClientDataSetbef_R(Self: TClientDataSet; var T: TRemoteEvent );
begin T := Self.BeforeApplyUpdates; end;

procedure TTClientDataSetaft_W(Self: TClientDataSet; const T: TRemoteEvent );
begin Self.AfterApplyUpdates := T; end;

(*----------------------------------------------------------------------------*)
procedure TClientDataSetaft_R(Self: TClientDataSet; var T: TRemoteEvent );
begin T := Self.AfterApplyUpdates; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TClientDataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TClientDataSet) do begin
  //RegisterMethod(@TClientDataSet.Command, 'Command');
    RegisterPropertyHelper(@TClientDataSetonrc_R,@TTClientDataSetonrc_W,'OnReconcileError');
    RegisterPropertyHelper(@TClientDataSetbef_R,@TTClientDataSetbef_W,'BeforeApplyUpdates');
    RegisterPropertyHelper(@TClientDataSetaft_R,@TTClientDataSetaft_W,'AfterApplyUpdates');

  end;
end;

 //RegisterProperty('BeforeApplyUpdates', 'TRemoteEvent', iptrw);
   //  RegisterProperty('AfterApplyUpdates', 'TRemoteEvent', iptrw);


(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomClientDataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomClientDataSet) do begin
    RegisterPropertyHelper(@TCustomClientDataSetProviderName_R,@TCustomClientDataSetProviderName_W,'ProviderName');
    RegisterPropertyHelper(@TCustomClientDataSetFileName_R,@TCustomClientDataSetFileName_W,'FileName');
    RegisterPropertyHelper(@TCustomClientDataSetConnectionBroker_R,@TCustomClientDataSetConnectionBroker_W,'ConnectionBroker');
    RegisterPropertyHelper(@TCustomClientDataSetIndexFieldNames_R,@TCustomClientDataSetIndexFieldNames_W,'IndexFieldNames');
    RegisterPropertyHelper(@TCustomClientDataSetMasterFields_R,@TCustomClientDataSetMasterFields_W,'MasterFields');
    RegisterPropertyHelper(@TCustomClientDataSetPacketRecords_R,@TCustomClientDataSetPacketRecords_W,'PacketRecords');
    RegisterPropertyHelper(@TCustomClientDataSetRemoteServer_R,@TCustomClientDataSetRemoteServer_W,'RemoteServer');
    RegisterConstructor(@TCustomClientDataSet.Create, 'Create');
      RegisterMethod(@TCustomClientDataSet.Destroy, 'Free');

    RegisterMethod(@TCustomClientDataSet.Open, 'Open');
    RegisterMethod(@TCustomClientDataSet.Close, 'Close');
    RegisterMethod(@TCustomClientDataSet.APPEND, 'APPEND');
    RegisterMethod(@TCustomClientDataSet.NEXT, 'NEXT');
    RegisterMethod(@TCustomClientDataSet.FIRST, 'FIRST');
    RegisterMethod(@TCustomClientDataSet.FINDFIRST, 'FINDFIRST');
   RegisterMethod(@TCustomClientDataSet.FINDLAST, 'FINDLAST');
   RegisterMethod(@TCustomClientDataSet.FINDNEXT, 'FINDNEXT');
   RegisterMethod(@TCustomClientDataSet.FINDPRIOR, 'FINDPRIOR');
   RegisterMethod(@TCustomClientDataSet.UpdateStatus, 'UpdateStatus');

   //function UpdateStatus: TUpdateStatus; override;

     //RegisterMethod(@TDATASET.OPEN, 'OPEN');
    RegisterVirtualMethod(@TCustomClientDataSet.POST, 'POST');
    RegisterMethod(@TCustomClientDataSet.PRIOR, 'PRIOR');
    RegisterMethod(@TCustomClientDataSet.REFRESH, 'REFRESH');
    RegisterVirtualMethod(@TCustomClientDataSet.CANCEL, 'CANCEL');
    RegisterVirtualMethod(@TCustomClientDataSet.Delete, 'Delete');
    RegisterVirtualMethod(@TCustomClientDataSet.LAST, 'LAST');

    RegisterMethod(@TDATASET.GETFIELDNAMES, 'GETFIELDNAMES');
  //  RegisterMethod(@TDATASET.GOTOBOOKMARK, 'GOTOBOOKMARK');
    RegisterMethod(@TDATASET.INSERT, 'INSERT');
    RegisterMethod(@TDATASET.INSERTRECORD, 'INSERTRECORD');
    RegisterMethod(@TDATASET.ISEMPTY, 'ISEMPTY');
     RegisterMethod(@TDATASET.EDIT, 'EDIT');
     RegisterMethod(@TDATASET.CreateBlobStream, 'CreateBlobStream');
     RegisterMethod(@TDATASET.BookmarkValid, 'BookmarkValid');
     RegisterMethod(@TDATASET.CompareBookmarks, 'CompareBookmarks');
     RegisterMethod(@TDATASET.ENABLECONTROLS, 'ENABLECONTROLS');
     RegisterMethod(@TDATASET.DISABLECONTROLS, 'DISABLECONTROLS');

    RegisterMethod(@TCustomClientDataSet.AddIndex, 'AddIndex');
    RegisterMethod(@TCustomClientDataSet.AppendData, 'AppendData');
    RegisterMethod(@TCustomClientDataSet.ApplyRange, 'ApplyRange');
    RegisterVirtualMethod(@TCustomClientDataSet.ApplyUpdates, 'ApplyUpdates');
    RegisterMethod(@TCustomClientDataSet.CancelRange, 'CancelRange');
    RegisterMethod(@TCustomClientDataSet.CancelUpdates, 'CancelUpdates');
    RegisterMethod(@TCustomClientDataSet.CreateDataSet, 'CreateDataSet');
    RegisterVirtualMethod(@TCustomClientDataSet.CloneCursor, 'CloneCursor');
    RegisterMethod(@TCustomClientDataSet.ConstraintsDisabled, 'ConstraintsDisabled');
    RegisterVirtualMethod(@TCustomClientDataSet.DataRequest, 'DataRequest');
    RegisterMethod(@TCustomClientDataSet.DeleteIndex, 'DeleteIndex');
    RegisterMethod(@TCustomClientDataSet.DisableConstraints, 'DisableConstraints');
    RegisterMethod(@TCustomClientDataSet.EnableConstraints, 'EnableConstraints');
    RegisterMethod(@TCustomClientDataSet.EditKey, 'EditKey');
   RegisterMethod(@TCustomClientDataSet.FIELDBYNAME, 'FIELDBYNAME');
   RegisterMethod(@TCustomClientDataSet.FINDFIELD, 'FINDFIELD');
   RegisterMethod(@TCustomClientDataSet.Locate, 'LOCATE');
   RegisterMethod(@TCustomClientDataSet.AppendRecord, 'AppendRecord');

   // RegisterMethod(@TCustomClientDataSet.ActivateFilters, 'activatefilters');

   //RegisterMethod(@TCustomClientDataSet.Command, 'Command');

    RegisterMethod(@TCustomClientDataSet.EditRangeEnd, 'EditRangeEnd');
    RegisterMethod(@TCustomClientDataSet.EditRangeStart, 'EditRangeStart');
    RegisterVirtualMethod(@TCustomClientDataSet.EmptyDataSet, 'EmptyDataSet');
    RegisterVirtualMethod(@TCustomClientDataSet.Execute, 'Execute');
    RegisterMethod(@TCustomClientDataSet.FetchBlobs, 'FetchBlobs');
    RegisterMethod(@TCustomClientDataSet.FetchDetails, 'FetchDetails');
    RegisterMethod(@TCustomClientDataSet.RefreshRecord, 'RefreshRecord');
    RegisterMethod(@TCustomClientDataSet.FetchParams, 'FetchParams');
    RegisterVirtualMethod(@TCustomClientDataSet.FindKey, 'FindKey');
    RegisterMethod(@TCustomClientDataSet.FindNearest, 'FindNearest');
    RegisterMethod(@TCustomClientDataSet.GetGroupState, 'GetGroupState');
    RegisterMethod(@TCustomClientDataSet.GetIndexInfo, 'GetIndexInfo');
    RegisterMethod(@TCustomClientDataSet.GetIndexNames, 'GetIndexNames');
    RegisterVirtualMethod(@TCustomClientDataSet.GetNextPacket, 'GetNextPacket');
    RegisterMethod(@TCustomClientDataSet.GetOptionalParam, 'GetOptionalParam');
    RegisterMethod(@TCustomClientDataSet.GotoCurrent, 'GotoCurrent');
    RegisterMethod(@TCustomClientDataSet.GotoKey, 'GotoKey');
    RegisterMethod(@TCustomClientDataSet.GotoNearest, 'GotoNearest');
    RegisterPropertyHelper(@TCustomClientDataSetHasAppServer_R,nil,'HasAppServer');
    RegisterMethod(@TCustomClientDataSet.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TCustomClientDataSet.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TCustomClientDataSet.MergeChangeLog, 'MergeChangeLog');
    RegisterMethod(@TCustomClientDataSet.Reconcile, 'Reconcile');
    RegisterMethod(@TCustomClientDataSet.RevertRecord, 'RevertRecord');
    RegisterMethod(@TCustomClientDataSet.SaveToFile, 'SaveToFile');
    RegisterMethod(@TCustomClientDataSet.SaveToStream, 'SaveToStream');
    RegisterMethod(@TCustomClientDataSet.SetAltRecBuffers, 'SetAltRecBuffers');
    RegisterMethod(@TCustomClientDataSet.SetKey, 'SetKey');
    RegisterVirtualMethod(@TCustomClientDataSet.SetOptionalParam, 'SetOptionalParam');
    RegisterMethod(@TCustomClientDataSet.SetProvider, 'SetProvider');
    RegisterMethod(@TCustomClientDataSet.SetRange, 'SetRange');
    RegisterMethod(@TCustomClientDataSet.SetRangeEnd, 'SetRangeEnd');
    RegisterMethod(@TCustomClientDataSet.SetRangeStart, 'SetRangeStart');
    RegisterMethod(@TCustomClientDataSet.UndoLastChange, 'UndoLastChange');
    RegisterPropertyHelper(@TCustomClientDataSetActiveAggs_R,nil,'ActiveAggs');
    RegisterPropertyHelper(@TCustomClientDataSetChangeCount_R,nil,'ChangeCount');
    RegisterPropertyHelper(@TCustomClientDataSetCloneSource_R,nil,'CloneSource');
    RegisterPropertyHelper(@TCustomClientDataSetData_R,@TCustomClientDataSetData_W,'Data');
    RegisterPropertyHelper(@TCustomClientDataSetXMLData_R,@TCustomClientDataSetXMLData_W,'XMLData');
    RegisterPropertyHelper(@TCustomClientDataSetActive_R,@TCustomClientDataSetActive_W,'XMLData');
    RegisterPropertyHelper(@TCustomClientDataSetAppServer_R,@TCustomClientDataSetAppServer_W,'AppServer');
    RegisterPropertyHelper(@TCustomClientDataSetDataSize_R,nil,'DataSize');
    RegisterPropertyHelper(@TCustomClientDataSetDelta_R,nil,'Delta');
    RegisterPropertyHelper(@TCustomClientDataSetGroupingLevel_R,nil,'GroupingLevel');
    RegisterPropertyHelper(@TCustomClientDataSetIndexFieldCount_R,nil,'IndexFieldCount');
    RegisterPropertyHelper(@TCustomClientDataSetIndexFields_R,@TCustomClientDataSetIndexFields_W,'IndexFields');
    RegisterPropertyHelper(@TCustomClientDataSetKeyExclusive_R,@TCustomClientDataSetKeyExclusive_W,'KeyExclusive');
    RegisterPropertyHelper(@TCustomClientDataSetKeyFieldCount_R,@TCustomClientDataSetKeyFieldCount_W,'KeyFieldCount');
    RegisterPropertyHelper(@TCustomClientDataSetKeySize_R,nil,'KeySize');
    RegisterPropertyHelper(@TCustomClientDataSetLogChanges_R,@TCustomClientDataSetLogChanges_W,'LogChanges');
    RegisterPropertyHelper(@TCustomClientDataSetSavePoint_R,@TCustomClientDataSetSavePoint_W,'SavePoint');
    RegisterPropertyHelper(@TCustomClientDataSetStatusFilter_R,@TCustomClientDataSetStatusFilter_W,'StatusFilter');

   RegisterPropertyHelper(@TDATASETCANMODIFY_R,nil,'CANMODIFY');
   RegisterPropertyHelper(@TDATASETDATASOURCE_R,nil,'DATASOURCE');
   RegisterPropertyHelper(@TDATASETDEFAULTFIELDS_R,nil,'DEFAULTFIELDS');
   RegisterPropertyHelper(@TDATASETEOF_R,nil,'EOF');
   RegisterPropertyHelper(@TDATASETBOF_R,nil,'BOF');
   //RegisterPropertyHelper(@TDATASETSQL_R,@TDATASETSQL_W,'SQL');

   RegisterPropertyHelper(@TDATASETFIELDCOUNT_R,nil,'FIELDCOUNT');
   RegisterPropertyHelper(@TDATASETFIELDS_R,nil,'FIELDS');
   RegisterPropertyHelper(@TDATASETFIELDVALUES_R,@TDATASETFIELDVALUES_W,'FIELDVALUES');
   RegisterPropertyHelper(@TDATASETFOUND_R,nil,'FOUND');
     RegisterPropertyHelper(@TDATASETFIELDLIST_R,nil,'FIELDLIST');
  RegisterPropertyHelper(@TDATASETDESIGNER_R,nil,'DESIGNER');
  RegisterPropertyHelper(@TDATASETDATASETFIELD_R,@TDATASETDATASETFIELD_W,'DATASETFIELD');
  RegisterPropertyHelper(@TDATASETFIELDDEFS_R,@TDATASETFIELDDEFS_W,'FIELDDEFS');
  RegisterPropertyHelper(@TDATASETFIELDDEFLIST_R,nil,'FIELDDEFLIST');
  RegisterPropertyHelper(@TDATASETRECORDCOUNT_R,nil,'RECORDCOUNT');
  RegisterPropertyHelper(@TDATASETRECNO_R,@TDATASETRECNO_W,'RECNO');
  RegisterPropertyHelper(@TDATASETActive_R,@TDATASETActive_W,'Active');

  RegisterPropertyHelper(@TDATASETRECORDSIZE_R,nil,'RECORDSIZE');


  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAggregates(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAggregates) do begin
    RegisterConstructor(@TAggregates.Create, 'Create');
    RegisterMethod(@TAggregates.Add, 'Add');
    RegisterMethod(@TAggregates.Clear, 'Clear');
    RegisterMethod(@TAggregates.Find, 'Find');
    RegisterMethod(@TAggregates.IndexOf, 'IndexOf');
    RegisterPropertyHelper(@TAggregatesItems_R,@TAggregatesItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAggregate(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAggregate) do begin
    RegisterConstructor(@TAggregateCreate_P, 'Create');
    RegisterMethod(@TAggregate.Assign, 'Assign');
   RegisterMethod(@TAggregate.Value, 'Value');
    RegisterPropertyHelper(@TAggregateAggHandle_R,@TAggregateAggHandle_W,'AggHandle');
    RegisterPropertyHelper(@TAggregateInUse_R,@TAggregateInUse_W,'InUse');
    RegisterPropertyHelper(@TAggregateDataSet_R,nil,'DataSet');
    RegisterPropertyHelper(@TAggregateDataSize_R,nil,'DataSize');
    RegisterPropertyHelper(@TAggregateDataType_R,nil,'DataType');
    RegisterPropertyHelper(@TAggregateActive_R,@TAggregateActive_W,'Active');
    RegisterPropertyHelper(@TAggregateAggregateName_R,@TAggregateAggregateName_W,'AggregateName');
    RegisterPropertyHelper(@TAggregateExpression_R,@TAggregateExpression_W,'Expression');
    RegisterPropertyHelper(@TAggregateGroupingLevel_R,@TAggregateGroupingLevel_W,'GroupingLevel');
    RegisterPropertyHelper(@TAggregateIndexName_R,@TAggregateIndexName_W,'IndexName');
    RegisterPropertyHelper(@TAggregateVisible_R,@TAggregateVisible_W,'Visible');
    RegisterPropertyHelper(@TAggregateOnUpdate_R,@TAggregateOnUpdate_W,'OnUpdate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConnectionBroker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConnectionBroker) do begin
    RegisterPropertyHelper(@TConnectionBrokerConnection_R,@TConnectionBrokerConnection_W,'Connection');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomRemoteServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomRemoteServer) do begin
    RegisterVirtualMethod(@TCustomRemoteServer.GetServer, 'GetServer');
    RegisterVirtualMethod(@TCustomRemoteServer.GetServerList, 'GetServerList');
    RegisterVirtualMethod(@TCustomRemoteServer.GetProviderNames, 'GetProviderNames');
    RegisterPropertyHelper(@TCustomRemoteServerAppServer_R,nil,'AppServer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EReconcileError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EReconcileError) do begin
    RegisterConstructor(@EReconcileError.Create, 'Create');
    RegisterPropertyHelper(@EReconcileErrorContext_R,nil,'Context');
    RegisterPropertyHelper(@EReconcileErrorPreviousError_R,nil,'PreviousError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDBClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDBClient) do
  begin
    RegisterConstructor(@EDBClient.Create, 'Create');
    RegisterPropertyHelper(@EDBClientErrorCode_R,nil,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EDBClient(CL);
  RIRegister_EReconcileError(CL);
  with CL.Add(TCustomClientDataSet) do
  with CL.Add(TClientDataSet) do
  RIRegister_TCustomRemoteServer(CL);
  RIRegister_TConnectionBroker(CL);
  with CL.Add(TAggregate) do
  with CL.Add(TAggregates) do
  RIRegister_TAggregate(CL);
  RIRegister_TAggregates(CL);
  RIRegister_TCustomClientDataSet(CL);
  RIRegister_TClientDataSet(CL);
  RIRegister_TClientBlobStream(CL);
end;

 
 
{ TPSImport_DBClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBClient(ri);
  RIRegister_DBClient_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
