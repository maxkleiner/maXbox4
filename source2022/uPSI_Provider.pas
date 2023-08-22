unit uPSI_Provider;
{
   add more properties for CDS mX 3.9.9.192
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
  TPSImport_Provider = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_IProviderContainer(CL: TPSPascalCompiler);
procedure SIRegister_TLocalAppServer(CL: TPSPascalCompiler);
procedure SIRegister_TSQLResolver(CL: TPSPascalCompiler);
procedure SIRegister_TDataSetResolver(CL: TPSPascalCompiler);
procedure SIRegister_TCustomResolver(CL: TPSPascalCompiler);
procedure SIRegister_TUpdateTree(CL: TPSPascalCompiler);
procedure SIRegister_TProvider(CL: TPSPascalCompiler);
procedure SIRegister_TDataSetProvider(CL: TPSPascalCompiler);
procedure SIRegister_TBaseProvider(CL: TPSPascalCompiler);
procedure SIRegister_TCustomProvider(CL: TPSPascalCompiler);
procedure SIRegister_TPacketDataSet(CL: TPSPascalCompiler);
procedure SIRegister_TDataPacketWriter(CL: TPSPascalCompiler);
procedure SIRegister_TCustomPacketWriter(CL: TPSPascalCompiler);
procedure SIRegister_EDSWriter(CL: TPSPascalCompiler);
procedure SIRegister_Provider(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Provider_Routines(S: TPSExec);
procedure RIRegister_TLocalAppServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSQLResolver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDataSetResolver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomResolver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TUpdateTree(CL: TPSRuntimeClassImporter);
procedure RIRegister_TProvider(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDataSetProvider(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBaseProvider(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomProvider(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPacketDataSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDataPacketWriter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomPacketWriter(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDSWriter(CL: TPSRuntimeClassImporter);
procedure RIRegister_Provider(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,VarUtils
  ,Variants
  ,DBClient
  ,DB
  ,DSIntf
  ,ActiveX
  ,Midas
  ,SqlTimSt
  ,WideStrings
  ,Provider
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Provider]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IProviderContainer(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IProviderContainer') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IProviderContainer, 'IProviderContainer') do
  begin
    RegisterMethod('Procedure RegisterProvider( Prov : TCustomProvider)', cdRegister);
    RegisterMethod('Procedure UnRegisterProvider( Prov : TCustomProvider)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLocalAppServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TLocalAppServer') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TLocalAppServer') do begin
    RegisterMethod('Constructor Create( AProvider : TCustomProvider);');
    RegisterMethod('Constructor Create1( ADataset : TDataset);');
      RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSQLResolver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomResolver', 'TSQLResolver') do
  with CL.AddClassN(CL.FindClass('TCustomResolver'),'TSQLResolver') do begin
    RegisterMethod('Constructor Create( AProvider : TDataSetProvider)');
      RegisterMethod('Procedure Free');
      RegisterMethod('procedure FreeTreeData(Tree: TUpdateTree)');
     RegisterMethod('procedure InitTreeData(Tree: TUpdateTree)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataSetResolver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomResolver', 'TDataSetResolver') do
  with CL.AddClassN(CL.FindClass('TCustomResolver'),'TDataSetResolver') do begin
    RegisterMethod('Constructor Create( AProvider : TDataSetProvider)');
    RegisterMethod('Procedure InternalBeforeResolve(Tree: TUpdateTree)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomResolver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomResolver') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomResolver') do begin
    RegisterMethod('Constructor Create( AProvider : TBaseProvider)');
      RegisterMethod('Procedure Free');
    RegisterMethod('Function ApplyUpdates( const Delta : OleVariant; MaxErrors : Integer; out ErrorCount : Integer) : OleVariant');
    RegisterMethod('Procedure FreeTreeData( Tree : TUpdateTree)');
    RegisterMethod('Procedure InitKeyFields( Tree : TUpdateTree; ADelta : TPacketDataSet)');
    RegisterMethod('Procedure InitTreeData( Tree : TUpdateTree)');
    RegisterMethod('Procedure InternalBeforeResolve( Tree : TUpdateTree)');
    RegisterMethod('Function InternalUpdateRecord( Tree : TUpdateTree) : Boolean');
    RegisterMethod('Function RowRequest( Row : OleVariant; Options : TFetchOptions) : OleVariant');
    RegisterProperty('Provider', 'TBaseProvider', iptr);
    RegisterProperty('UpdateTree', 'TUpdateTree', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TUpdateTree(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TUpdateTree') do
  with CL.AddClassN(CL.FindClass('TObject'),'TUpdateTree') do begin
    RegisterMethod('Constructor Create( AParent : TUpdateTree; AResolver : TCustomResolver)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function DoUpdates : Boolean');
    RegisterMethod('Procedure InitData( ASource : TDataSet)');
    RegisterMethod('Procedure InitDelta( ADelta : TPacketDataSet);');
    RegisterMethod('Procedure InitDelta1( const ADelta : OleVariant);');
    RegisterMethod('Procedure InitErrorPacket( E : EUpdateError; Response : TResolverResponse)');
    RegisterMethod('Procedure RefreshData( Options : TFetchOptions)');
    RegisterProperty('Data', 'Pointer', iptrw);
    RegisterProperty('Delta', 'TPacketDataSet', iptrw);
    RegisterProperty('DetailCount', 'Integer', iptr);
    RegisterProperty('Details', 'TUpdateTree Integer', iptr);
    RegisterProperty('ErrorDS', 'TPacketDataSet', iptrw);
    RegisterProperty('HasErrors', 'Boolean', iptr);
    RegisterProperty('IsNested', 'Boolean', iptr);
    RegisterProperty('Name', 'WideString', iptrw);
    RegisterProperty('Parent', 'TUpdateTree', iptr);
    RegisterProperty('Resolver', 'TCustomResolver', iptr);
    RegisterProperty('Source', 'TDataSet', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TProvider(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataSetProvider', 'TProvider') do
  with CL.AddClassN(CL.FindClass('TDataSetProvider'),'TProvider') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataSetProvider(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseProvider', 'TDataSetProvider') do
  with CL.AddClassN(CL.FindClass('TBaseProvider'),'TDataSetProvider') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free;');
    RegisterProperty('Params', 'TParams', iptr);
    RegisterProperty('DataSet', 'TDataSet', iptrw);
    RegisterProperty('Constraints', 'Boolean', iptrw);
    RegisterProperty('ResolveToDataSet', 'Boolean', iptrw);
    RegisterProperty('OnGetTableName', 'TGetTableNameEvent', iptrw);
    RegisterProperty('OnGetDataSetProperties', 'TGetDSProps', iptrw);
    RegisterPublishedProperties;
      RegisterProperty('Exported', 'boolean', iptrw);
      RegisterProperty('Options', 'TProviderOptions', iptrw);
      RegisterProperty('UpdateMode', 'TUpdateMode', iptrw);
    RegisterProperty('ProviderEOF', 'boolean',iptrw);
    RegisterProperty('onGetData', 'TProviderDataEvent',iptrw);
    RegisterProperty('onUpdateData', 'TProviderDataEvent',iptrw);
    //RegisterProperty('ReadOnly', 'boolean',iptrw);
    //RegisterProperty('StoreDefs', 'boolean',iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBaseProvider(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomProvider', 'TBaseProvider') do
  with CL.AddClassN(CL.FindClass('TCustomProvider'),'TBaseProvider') do begin
       RegisterMethod('Procedure Free');
     RegisterProperty('Resolver', 'TCustomResolver', iptr);
    RegisterProperty('Options', 'TProviderOptions', iptrw);
    RegisterProperty('UpdateMode', 'TUpdateMode', iptrw);
    RegisterProperty('OnGetData', 'TProviderDataEvent', iptrw);
    RegisterProperty('OnUpdateData', 'TProviderDataEvent', iptrw);
    RegisterProperty('OnUpdateError', 'TResolverErrorEvent', iptrw);
    RegisterProperty('BeforeUpdateRecord', 'TBeforeUpdateRecordEvent', iptrw);
    RegisterProperty('AfterUpdateRecord', 'TAfterUpdateRecordEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomProvider(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomProvider') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomProvider') do begin
       RegisterMethod('Procedure Free');
     RegisterMethod('Function ApplyUpdates( const Delta : OleVariant; MaxErrors : Integer; out ErrorCount : Integer) : OleVariant;');
    RegisterMethod('Function ApplyUpdates1( const Delta : OleVariant; MaxErrors : Integer; out ErrorCount : Integer; var OwnerData : OleVariant) : OleVariant;');
    RegisterMethod('Function GetRecords( Count : Integer; out RecsOut : Integer; Options : Integer) : OleVariant;');
    RegisterMethod('Function GetRecords1( Count : Integer; out RecsOut : Integer; Options : Integer; const CommandText : WideString; var Params, OwnerData : OleVariant) : OleVariant;');
    RegisterMethod('Function RowRequest( const Row : OleVariant; RequestType : Integer; var OwnerData : OleVariant) : OleVariant');
    RegisterMethod('Procedure Execute( const CommandText : WideString; var Params, OwnerData : OleVariant)');
    RegisterMethod('Function GetParams( var OwnerData : OleVariant) : OleVariant');
    RegisterMethod('Function DataRequest( Input : OleVariant) : OleVariant');
    RegisterProperty('Data', 'OleVariant', iptr);
    RegisterProperty('Exported', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPacketDataSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomClientDataSet', 'TPacketDataSet') do
  with CL.AddClassN(CL.FindClass('TCustomClientDataSet'),'TPacketDataSet') do
  begin
    RegisterMethod('Procedure AssignCurValues( Source : TDataSet);');
    RegisterMethod('Procedure AssignCurValues1( const CurValues : Variant);');
    RegisterMethod('Procedure CreateFromDelta( Source : TPacketDataSet)');
    RegisterMethod('Function HasCurValues : Boolean');
    RegisterMethod('Function HasMergeConflicts : Boolean');
    RegisterMethod('Procedure InitAltRecBuffers( CheckModified : Boolean)');
    RegisterMethod('Function UpdateKind : TUpdateKind');
    RegisterProperty('NewValuesModified', 'Boolean', iptr);
    RegisterProperty('StreamMetaData', 'Boolean', iptrw);
    RegisterProperty('UseCurValues', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataPacketWriter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPacketWriter', 'TDataPacketWriter') do
  with CL.AddClassN(CL.FindClass('TCustomPacketWriter'),'TDataPacketWriter') do begin
    RegisterMethod('Procedure GetDataPacket( DataSet : TDataSet; var RecsOut : Integer; out Data : OleVariant)');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Procedure Free');
     RegisterProperty('Constraints', 'Boolean', iptrw);
    RegisterProperty('PacketOptions', 'TGetRecordOptions', iptrw);
    RegisterProperty('Options', 'TProviderOptions', iptrw);
    RegisterProperty('OnGetParams', 'TGetParamsEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomPacketWriter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCustomPacketWriter') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCustomPacketWriter') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDSWriter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EDSWriter') do
  with CL.AddClassN(CL.FindClass('Exception'),'EDSWriter') do begin
    RegisterMethod('Constructor Create( ErrMsg : string; Status : Integer)');
    RegisterProperty('ErrorCode', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Provider(CL: TPSPascalCompiler);
begin
  SIRegister_EDSWriter(CL);
  SIRegister_TCustomPacketWriter(CL);
  CL.AddTypeS('TGetRecordOption', '( grMetaData, grReset, grXML, grXMLUTF8 )');
  CL.AddTypeS('TGetRecordOptions', 'set of TGetRecordOption');
  //CL.AddTypeS('TDataRequestEvent', 'Function ( Sender : TObject; Input : OleVariant) : OleVariant');
  CL.AddTypeS('TProviderOption', '( poFetchBlobsOnDemand, poFetchDetailsOnDeman'
   +'d, poIncFieldProps, poCascadeDeletes, poCascadeUpdates, poReadOnly, poAllo'
   +'wMultiRecordUpdates, poDisableInserts, poDisableEdits, poDisableDeletes, p'
   +'oNoReset, poAutoRefresh, poPropogateChanges, poAllowCommandText, poRetainS'
   +'erverOrder, poUseQuoteChar )');
  CL.AddTypeS('TProviderOptions', 'set of TProviderOption');
   CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomClientDataSet');
   CL.AddTypeS('TProviderDataEvent', 'procedure(Sender: TObject; DataSet: TCustomClientDataSet) of object');

  //CL.AddTypeS('PPutFieldInfo', '^TPutFieldInfo // will not work');
  {CL.AddTypeS('TPutFieldProc', 'Procedure ( Info : PPutFieldInfo)');
  CL.AddTypeS('TPutFieldInfo', 'record FieldNo : Integer; Field : TField; DataS'
   +'et : TDataSet; Size : Integer; IsDetail : Boolean; Opened : Boolean; PutPr'
   +'oc : TPutFieldProc; LocalFieldIndex : Integer; FieldInfos : Pointer; end');}
  //CL.AddTypeS('TInfoArray', 'array of TPutFieldInfo');
  //CL.AddTypeS('TGetParamsEvent', 'Procedure ( DataSet : TDataSet; Params : TList)');
  //CL.AddTypeS('TOnValidate', 'Procedure ( const Delta : OleVariant)');
  SIRegister_TDataPacketWriter(CL);
  SIRegister_TPacketDataSet(CL);
  SIRegister_TCustomProvider(CL);
 CL.AddConstantN('ResetOption','Integer').SetInt( 1 shl ord( grReset));
 CL.AddConstantN('MetaDataOption','Integer').SetInt( 1 shl ord( grMetaData));
 CL.AddConstantN('XMLOption','Integer').SetInt( 1 shl ord( grXML));
 CL.AddConstantN('XMLUTF8Option','Integer').SetInt( 1 shl ord( grXMLUTF8));
  CL.AddClassN(CL.FindClass('TOBJECT'),'TUpdateTree');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomResolver');
  CL.AddTypeS('TResolverResponse', '( rrSkip, rrAbort, rrMerge, rrApply, rrIgnore )');
 // CL.AddTypeS('TProviderDataEvent', 'Procedure ( Sender : TObject; DataSet : TC'
   //+'ustomClientDataSet)');
  {CL.AddTypeS('TBeforeUpdateRecordEvent', 'Procedure ( Sender : TObject; Source'
   +'DS : TDataSet; DeltaDS : TCustomClientDataSet; UpdateKind : TUpdateKind; v'
   +'ar Applied : Boolean)');
  CL.AddTypeS('TAfterUpdateRecordEvent', 'Procedure ( Sender : TObject; SourceD'
   +'S : TDataSet; DeltaDS : TCustomClientDataSet; UpdateKind : TUpdateKind)');
  CL.AddTypeS('TResolverErrorEvent', 'Procedure ( Sender : TObject; DataSet : T'
   +'CustomClientDataSet; E : EUpdateError; UpdateKind : TUpdateKind; var Respo'
   +'nse : TResolverResponse)');
  CL.AddTypeS('TBeforeCommitEvent', 'Procedure ( Sender : TObject; DeltaDS : TC'
   +'ustomClientDataSet; ErrorCount, MaxErrors : integer; const ResultVar : Ole'
   +'Variant)');
  SIRegister_TBaseProvider(CL);
  CL.AddTypeS('TGetTableNameEvent', 'Procedure ( Sender : TObject; DataSet : TD'
   +'ataSet; var TableName : WideString)');
  CL.AddTypeS('TGetDSProps', 'Procedure ( Sender : TObject; DataSet : TDataSet;'
   +' out Properties : OleVariant)'); }
  SIRegister_TDataSetProvider(CL);
  SIRegister_TProvider(CL);
  SIRegister_TUpdateTree(CL);
  SIRegister_TCustomResolver(CL);
  SIRegister_TDataSetResolver(CL);
  SIRegister_TSQLResolver(CL);
  SIRegister_TLocalAppServer(CL);
  SIRegister_IProviderContainer(CL);
 CL.AddDelphiFunction('Function GetObjectProperty( Instance : TPersistent; const PropName : string) : TObject');
 CL.AddDelphiFunction('Function GetStringProperty( Instance : TPersistent; const PropName : string) : WideString');
 CL.AddDelphiFunction('Function VarArrayFromStrings( Strings : TStrings) : Variant');
 CL.AddDelphiFunction('Function VarArrayFromWideStrings( Strings : TWideStrings) : Variant');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TLocalAppServerCreate1_P(Self: TClass; CreateNewInstance: Boolean;  ADataset : TDataset):TObject;
Begin Result := TLocalAppServer.Create(ADataset); END;

(*----------------------------------------------------------------------------*)
Function TLocalAppServerCreate_P(Self: TClass; CreateNewInstance: Boolean;  AProvider : TCustomProvider):TObject;
Begin Result := TLocalAppServer.Create(AProvider); END;

(*----------------------------------------------------------------------------*)
procedure TCustomResolverUpdateTree_R(Self: TCustomResolver; var T: TUpdateTree);
begin T := Self.UpdateTree; end;

(*----------------------------------------------------------------------------*)
procedure TCustomResolverProvider_R(Self: TCustomResolver; var T: TBaseProvider);
begin T := Self.Provider; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeSource_W(Self: TUpdateTree; const T: TDataSet);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeSource_R(Self: TUpdateTree; var T: TDataSet);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeResolver_R(Self: TUpdateTree; var T: TCustomResolver);
begin T := Self.Resolver; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeParent_R(Self: TUpdateTree; var T: TUpdateTree);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeName_W(Self: TUpdateTree; const T: WideString);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeName_R(Self: TUpdateTree; var T: WideString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeIsNested_R(Self: TUpdateTree; var T: Boolean);
begin T := Self.IsNested; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeHasErrors_R(Self: TUpdateTree; var T: Boolean);
begin T := Self.HasErrors; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeErrorDS_W(Self: TUpdateTree; const T: TPacketDataSet);
begin Self.ErrorDS := T; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeErrorDS_R(Self: TUpdateTree; var T: TPacketDataSet);
begin T := Self.ErrorDS; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeDetails_R(Self: TUpdateTree; var T: TUpdateTree; const t1: Integer);
begin T := Self.Details[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeDetailCount_R(Self: TUpdateTree; var T: Integer);
begin T := Self.DetailCount; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeDelta_W(Self: TUpdateTree; const T: TPacketDataSet);
begin Self.Delta := T; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeDelta_R(Self: TUpdateTree; var T: TPacketDataSet);
begin T := Self.Delta; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeData_W(Self: TUpdateTree; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TUpdateTreeData_R(Self: TUpdateTree; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
Procedure TUpdateTreeInitDelta1_P(Self: TUpdateTree;  const ADelta : OleVariant);
Begin Self.InitDelta(ADelta); END;

(*----------------------------------------------------------------------------*)
Procedure TUpdateTreeInitDelta_P(Self: TUpdateTree;  ADelta : TPacketDataSet);
Begin Self.InitDelta(ADelta); END;

(*----------------------------------------------------------------------------*)
procedure TDataSetProviderOnGetDataSetProperties_W(Self: TDataSetProvider; const T: TGetDSProps);
begin Self.OnGetDataSetProperties := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataSetProviderOnGetDataSetProperties_R(Self: TDataSetProvider; var T: TGetDSProps);
begin T := Self.OnGetDataSetProperties; end;

(*----------------------------------------------------------------------------*)
procedure TDataSetProviderOnGetTableName_W(Self: TDataSetProvider; const T: TGetTableNameEvent);
begin Self.OnGetTableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataSetProviderOnGetTableName_R(Self: TDataSetProvider; var T: TGetTableNameEvent);
begin T := Self.OnGetTableName; end;

(*----------------------------------------------------------------------------*)
procedure TDataSetProviderResolveToDataSet_W(Self: TDataSetProvider; const T: Boolean);
begin Self.ResolveToDataSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataSetProviderResolveToDataSet_R(Self: TDataSetProvider; var T: Boolean);
begin T := Self.ResolveToDataSet; end;

(*----------------------------------------------------------------------------*)
procedure TDataSetProviderConstraints_W(Self: TDataSetProvider; const T: Boolean);
begin Self.Constraints := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataSetProviderConstraints_R(Self: TDataSetProvider; var T: Boolean);
begin T := Self.Constraints; end;

(*----------------------------------------------------------------------------*)
procedure TDataSetProviderDataSet_W(Self: TDataSetProvider; const T: TDataSet);
begin Self.DataSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataSetProviderDataSet_R(Self: TDataSetProvider; var T: TDataSet);
begin T := Self.DataSet; end;

(*----------------------------------------------------------------------------*)
procedure TDataSetProviderParams_R(Self: TDataSetProvider; var T: TParams);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderAfterUpdateRecord_W(Self: TBaseProvider; const T: TAfterUpdateRecordEvent);
begin Self.AfterUpdateRecord := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderAfterUpdateRecord_R(Self: TBaseProvider; var T: TAfterUpdateRecordEvent);
begin T := Self.AfterUpdateRecord; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderBeforeUpdateRecord_W(Self: TBaseProvider; const T: TBeforeUpdateRecordEvent);
begin Self.BeforeUpdateRecord := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderBeforeUpdateRecord_R(Self: TBaseProvider; var T: TBeforeUpdateRecordEvent);
begin T := Self.BeforeUpdateRecord; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderOnUpdateError_W(Self: TBaseProvider; const T: TResolverErrorEvent);
begin Self.OnUpdateError := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderOnUpdateError_R(Self: TBaseProvider; var T: TResolverErrorEvent);
begin T := Self.OnUpdateError; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderOnUpdateData_W(Self: TBaseProvider; const T: TProviderDataEvent);
begin Self.OnUpdateData := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderOnUpdateData_R(Self: TBaseProvider; var T: TProviderDataEvent);
begin T := Self.OnUpdateData; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderOnGetData_W(Self: TBaseProvider; const T: TProviderDataEvent);
begin Self.OnGetData := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderOnGetData_R(Self: TBaseProvider; var T: TProviderDataEvent);
begin T := Self.OnGetData; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderUpdateMode_W(Self: TBaseProvider; const T: TUpdateMode);
begin Self.UpdateMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderUpdateMode_R(Self: TBaseProvider; var T: TUpdateMode);
begin T := Self.UpdateMode; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderOptions_W(Self: TBaseProvider; const T: TProviderOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderOptions_R(Self: TBaseProvider; var T: TProviderOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TBaseProviderResolver_R(Self: TBaseProvider; var T: TCustomResolver);
begin T := Self.Resolver; end;

(*----------------------------------------------------------------------------*)
procedure TCustomProviderExported_W(Self: TCustomProvider; const T: Boolean);
begin Self.Exported := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomProviderExported_R(Self: TCustomProvider; var T: Boolean);
begin T := Self.Exported; end;

(*----------------------------------------------------------------------------*)
procedure TCustomProviderData_R(Self: TCustomProvider; var T: OleVariant);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
Function TCustomProviderGetRecords1_P(Self: TCustomProvider;  Count : Integer; out RecsOut : Integer; Options : Integer; const CommandText : WideString; var Params, OwnerData : OleVariant) : OleVariant;
Begin Result := Self.GetRecords(Count, RecsOut, Options, CommandText, Params, OwnerData); END;

(*----------------------------------------------------------------------------*)
Function TCustomProviderGetRecords_P(Self: TCustomProvider;  Count : Integer; out RecsOut : Integer; Options : Integer) : OleVariant;
Begin Result := Self.GetRecords(Count, RecsOut, Options); END;

(*----------------------------------------------------------------------------*)
Function TCustomProviderApplyUpdates1_P(Self: TCustomProvider;  const Delta : OleVariant; MaxErrors : Integer; out ErrorCount : Integer; var OwnerData : OleVariant) : OleVariant;
Begin Result := Self.ApplyUpdates(Delta, MaxErrors, ErrorCount, OwnerData); END;

(*----------------------------------------------------------------------------*)
Function TCustomProviderApplyUpdates_P(Self: TCustomProvider;  const Delta : OleVariant; MaxErrors : Integer; out ErrorCount : Integer) : OleVariant;
Begin Result := Self.ApplyUpdates(Delta, MaxErrors, ErrorCount); END;

(*----------------------------------------------------------------------------*)
procedure TPacketDataSetUseCurValues_W(Self: TPacketDataSet; const T: Boolean);
begin Self.UseCurValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TPacketDataSetUseCurValues_R(Self: TPacketDataSet; var T: Boolean);
begin T := Self.UseCurValues; end;

(*----------------------------------------------------------------------------*)
procedure TPacketDataSetStreamMetaData_W(Self: TPacketDataSet; const T: Boolean);
begin Self.StreamMetaData := T; end;

(*----------------------------------------------------------------------------*)
procedure TPacketDataSetStreamMetaData_R(Self: TPacketDataSet; var T: Boolean);
begin T := Self.StreamMetaData; end;

(*----------------------------------------------------------------------------*)
procedure TPacketDataSetNewValuesModified_R(Self: TPacketDataSet; var T: Boolean);
begin T := Self.NewValuesModified; end;

(*----------------------------------------------------------------------------*)
Procedure TPacketDataSetAssignCurValues1_P(Self: TPacketDataSet;  const CurValues : Variant);
Begin Self.AssignCurValues(CurValues); END;

(*----------------------------------------------------------------------------*)
Procedure TPacketDataSetAssignCurValues_P(Self: TPacketDataSet;  Source : TDataSet);
Begin Self.AssignCurValues(Source); END;

(*----------------------------------------------------------------------------*)
procedure TDataPacketWriterOnGetParams_W(Self: TDataPacketWriter; const T: TGetParamsEvent);
begin Self.OnGetParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataPacketWriterOnGetParams_R(Self: TDataPacketWriter; var T: TGetParamsEvent);
begin T := Self.OnGetParams; end;

(*----------------------------------------------------------------------------*)
procedure TDataPacketWriterOptions_W(Self: TDataPacketWriter; const T: TProviderOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataPacketWriterOptions_R(Self: TDataPacketWriter; var T: TProviderOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TDataPacketWriterPacketOptions_W(Self: TDataPacketWriter; const T: TGetRecordOptions);
begin Self.PacketOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataPacketWriterPacketOptions_R(Self: TDataPacketWriter; var T: TGetRecordOptions);
begin T := Self.PacketOptions; end;

(*----------------------------------------------------------------------------*)
procedure TDataPacketWriterConstraints_W(Self: TDataPacketWriter; const T: Boolean);
begin Self.Constraints := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataPacketWriterConstraints_R(Self: TDataPacketWriter; var T: Boolean);
begin T := Self.Constraints; end;

(*----------------------------------------------------------------------------*)
procedure EDSWriterErrorCode_R(Self: EDSWriter; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Provider_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetObjectProperty, 'GetObjectProperty', cdRegister);
 S.RegisterDelphiFunction(@GetStringProperty, 'GetStringProperty', cdRegister);
 S.RegisterDelphiFunction(@VarArrayFromStrings, 'VarArrayFromStrings', cdRegister);
 S.RegisterDelphiFunction(@VarArrayFromWideStrings, 'VarArrayFromWideStrings', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLocalAppServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLocalAppServer) do begin
    RegisterConstructor(@TLocalAppServerCreate_P, 'Create');
    RegisterConstructor(@TLocalAppServerCreate1_P, 'Create1');
    RegisterMethod(@TLocalAppServer.Destroy, 'Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSQLResolver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSQLResolver) do begin
    RegisterConstructor(@TSQLResolver.Create, 'Create');
    RegisterMethod(@TSQLResolver.Destroy, 'Free');
    RegisterMethod(@TSQLResolver.FreeTreeData, 'FreeTreeData');
   RegisterMethod(@TSQLResolver.InitTreeData, 'InitTreeData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataSetResolver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataSetResolver) do begin
    RegisterConstructor(@TDataSetResolver.Create, 'Create');
   RegisterMethod(@TDataSetResolver.InternalBeforeResolve, 'InternalBeforeResolve');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomResolver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomResolver) do begin
    RegisterConstructor(@TCustomResolver.Create, 'Create');
    RegisterMethod(@TCustomResolver.Destroy, 'Free');
     RegisterVirtualMethod(@TCustomResolver.ApplyUpdates, 'ApplyUpdates');
    RegisterVirtualMethod(@TCustomResolver.FreeTreeData, 'FreeTreeData');
    RegisterVirtualMethod(@TCustomResolver.InitKeyFields, 'InitKeyFields');
    RegisterVirtualMethod(@TCustomResolver.InitTreeData, 'InitTreeData');
    RegisterVirtualMethod(@TCustomResolver.InternalBeforeResolve, 'InternalBeforeResolve');
    RegisterVirtualMethod(@TCustomResolver.InternalUpdateRecord, 'InternalUpdateRecord');
    RegisterVirtualMethod(@TCustomResolver.RowRequest, 'RowRequest');
    RegisterPropertyHelper(@TCustomResolverProvider_R,nil,'Provider');
    RegisterPropertyHelper(@TCustomResolverUpdateTree_R,nil,'UpdateTree');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TUpdateTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TUpdateTree) do begin
    RegisterConstructor(@TUpdateTree.Create, 'Create');
    RegisterVirtualMethod(@TUpdateTree.Clear, 'Clear');
     RegisterMethod(@TUpdateTree.Destroy, 'Free');
     RegisterVirtualMethod(@TUpdateTree.DoUpdates, 'DoUpdates');
    RegisterVirtualMethod(@TUpdateTree.InitData, 'InitData');
    RegisterVirtualMethod(@TUpdateTreeInitDelta_P, 'InitDelta');
    RegisterVirtualMethod(@TUpdateTreeInitDelta1_P, 'InitDelta1');
    RegisterVirtualMethod(@TUpdateTree.InitErrorPacket, 'InitErrorPacket');
    RegisterVirtualMethod(@TUpdateTree.RefreshData, 'RefreshData');
    RegisterPropertyHelper(@TUpdateTreeData_R,@TUpdateTreeData_W,'Data');
    RegisterPropertyHelper(@TUpdateTreeDelta_R,@TUpdateTreeDelta_W,'Delta');
    RegisterPropertyHelper(@TUpdateTreeDetailCount_R,nil,'DetailCount');
    RegisterPropertyHelper(@TUpdateTreeDetails_R,nil,'Details');
    RegisterPropertyHelper(@TUpdateTreeErrorDS_R,@TUpdateTreeErrorDS_W,'ErrorDS');
    RegisterPropertyHelper(@TUpdateTreeHasErrors_R,nil,'HasErrors');
    RegisterPropertyHelper(@TUpdateTreeIsNested_R,nil,'IsNested');
    RegisterPropertyHelper(@TUpdateTreeName_R,@TUpdateTreeName_W,'Name');
    RegisterPropertyHelper(@TUpdateTreeParent_R,nil,'Parent');
    RegisterPropertyHelper(@TUpdateTreeResolver_R,nil,'Resolver');
    RegisterPropertyHelper(@TUpdateTreeSource_R,@TUpdateTreeSource_W,'Source');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProvider(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProvider) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataSetProvider(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataSetProvider) do begin
    RegisterConstructor(@TDataSetProvider.Create, 'Create');
   RegisterMethod(@TDataSetProvider.Destroy, 'Free');
     RegisterPropertyHelper(@TDataSetProviderParams_R,nil,'Params');
    RegisterPropertyHelper(@TDataSetProviderDataSet_R,@TDataSetProviderDataSet_W,'DataSet');
    RegisterPropertyHelper(@TDataSetProviderConstraints_R,@TDataSetProviderConstraints_W,'Constraints');
    RegisterPropertyHelper(@TDataSetProviderResolveToDataSet_R,@TDataSetProviderResolveToDataSet_W,'ResolveToDataSet');
    RegisterPropertyHelper(@TDataSetProviderOnGetTableName_R,@TDataSetProviderOnGetTableName_W,'OnGetTableName');
    RegisterPropertyHelper(@TDataSetProviderOnGetDataSetProperties_R,@TDataSetProviderOnGetDataSetProperties_W,'OnGetDataSetProperties');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBaseProvider(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseProvider) do begin
    RegisterPropertyHelper(@TBaseProviderResolver_R,nil,'Resolver');
       RegisterMethod(@TBaseProvider.Destroy, 'Free');
    RegisterPropertyHelper(@TBaseProviderOptions_R,@TBaseProviderOptions_W,'Options');
    RegisterPropertyHelper(@TBaseProviderUpdateMode_R,@TBaseProviderUpdateMode_W,'UpdateMode');
    RegisterPropertyHelper(@TBaseProviderOnGetData_R,@TBaseProviderOnGetData_W,'OnGetData');
    RegisterPropertyHelper(@TBaseProviderOnUpdateData_R,@TBaseProviderOnUpdateData_W,'OnUpdateData');
    RegisterPropertyHelper(@TBaseProviderOnUpdateError_R,@TBaseProviderOnUpdateError_W,'OnUpdateError');
    RegisterPropertyHelper(@TBaseProviderBeforeUpdateRecord_R,@TBaseProviderBeforeUpdateRecord_W,'BeforeUpdateRecord');
    RegisterPropertyHelper(@TBaseProviderAfterUpdateRecord_R,@TBaseProviderAfterUpdateRecord_W,'AfterUpdateRecord');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomProvider(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomProvider) do begin
    RegisterMethod(@TCustomProviderApplyUpdates_P, 'ApplyUpdates');
       RegisterMethod(@TCustomProvider.Destroy, 'Free');
        RegisterMethod(@TCustomProviderApplyUpdates1_P, 'ApplyUpdates1');
    RegisterMethod(@TCustomProviderGetRecords_P, 'GetRecords');
    RegisterMethod(@TCustomProviderGetRecords1_P, 'GetRecords1');
    RegisterVirtualMethod(@TCustomProvider.RowRequest, 'RowRequest');
    RegisterVirtualMethod(@TCustomProvider.Execute, 'Execute');
    RegisterVirtualMethod(@TCustomProvider.GetParams, 'GetParams');
    RegisterVirtualMethod(@TCustomProvider.DataRequest, 'DataRequest');
    RegisterPropertyHelper(@TCustomProviderData_R,nil,'Data');
    RegisterPropertyHelper(@TCustomProviderExported_R,@TCustomProviderExported_W,'Exported');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPacketDataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPacketDataSet) do begin
    RegisterMethod(@TPacketDataSetAssignCurValues_P, 'AssignCurValues');
    RegisterMethod(@TPacketDataSetAssignCurValues1_P, 'AssignCurValues1');
    RegisterMethod(@TPacketDataSet.CreateFromDelta, 'CreateFromDelta');
    RegisterMethod(@TPacketDataSet.HasCurValues, 'HasCurValues');
    RegisterMethod(@TPacketDataSet.HasMergeConflicts, 'HasMergeConflicts');
    RegisterMethod(@TPacketDataSet.InitAltRecBuffers, 'InitAltRecBuffers');
    RegisterMethod(@TPacketDataSet.UpdateKind, 'UpdateKind');
    RegisterPropertyHelper(@TPacketDataSetNewValuesModified_R,nil,'NewValuesModified');
    RegisterPropertyHelper(@TPacketDataSetStreamMetaData_R,@TPacketDataSetStreamMetaData_W,'StreamMetaData');
    RegisterPropertyHelper(@TPacketDataSetUseCurValues_R,@TPacketDataSetUseCurValues_W,'UseCurValues');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataPacketWriter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataPacketWriter) do begin
    RegisterVirtualMethod(@TDataPacketWriter.GetDataPacket, 'GetDataPacket');
       RegisterMethod(@TDataPacketWriter.Destroy, 'Free');
      RegisterMethod(@TDataPacketWriter.Reset, 'Reset');
    RegisterPropertyHelper(@TDataPacketWriterConstraints_R,@TDataPacketWriterConstraints_W,'Constraints');
    RegisterPropertyHelper(@TDataPacketWriterPacketOptions_R,@TDataPacketWriterPacketOptions_W,'PacketOptions');
    RegisterPropertyHelper(@TDataPacketWriterOptions_R,@TDataPacketWriterOptions_W,'Options');
    RegisterPropertyHelper(@TDataPacketWriterOnGetParams_R,@TDataPacketWriterOnGetParams_W,'OnGetParams');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomPacketWriter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomPacketWriter) do begin
    RegisterVirtualConstructor(@TCustomPacketWriter.Create, 'Create');
        RegisterMethod(@TCustomPacketWriter.Destroy, 'Free');
    //     RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDSWriter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDSWriter) do begin
    RegisterConstructor(@EDSWriter.Create, 'Create');
    RegisterPropertyHelper(@EDSWriterErrorCode_R,nil,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Provider(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EDSWriter(CL);
  RIRegister_TCustomPacketWriter(CL);
  RIRegister_TDataPacketWriter(CL);
  RIRegister_TPacketDataSet(CL);
  RIRegister_TCustomProvider(CL);
  with CL.Add(TUpdateTree) do
  with CL.Add(TCustomResolver) do
  RIRegister_TBaseProvider(CL);
  RIRegister_TDataSetProvider(CL);
  RIRegister_TProvider(CL);
  RIRegister_TUpdateTree(CL);
  RIRegister_TCustomResolver(CL);
  RIRegister_TDataSetResolver(CL);
  RIRegister_TSQLResolver(CL);
  RIRegister_TLocalAppServer(CL);
end;

 
 
{ TPSImport_Provider }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Provider.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Provider(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Provider.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Provider_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
