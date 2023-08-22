unit uPSI_ADOInt;
{
   to get the recordset   and commandset   2  retyped by max   4.2.8.10
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
  TPSImport_ADOInt = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_CoParameter(CL: TPSPascalCompiler);
procedure SIRegister_CoRecordset(CL: TPSPascalCompiler);
procedure SIRegister_CoCommand(CL: TPSPascalCompiler);
procedure SIRegister_CoConnection(CL: TPSPascalCompiler);
procedure SIRegister_IDataspace(CL: TPSPascalCompiler);
procedure SIRegister_ADORecordsetConstruction(CL: TPSPascalCompiler);
procedure SIRegister_ADOCommandConstruction(CL: TPSPascalCompiler);
procedure SIRegister_ADOConnectionConstruction(CL: TPSPascalCompiler);
procedure SIRegister_ADOConnectionConstruction15(CL: TPSPascalCompiler);
procedure SIRegister_RecordsetEventsVt(CL: TPSPascalCompiler);
procedure SIRegister_ConnectionEventsVt(CL: TPSPascalCompiler);
procedure SIRegister__Command(CL: TPSPascalCompiler);
procedure SIRegister_Parameters(CL: TPSPascalCompiler);
procedure SIRegister__Parameter(CL: TPSPascalCompiler);
procedure SIRegister_Field15(CL: TPSPascalCompiler);
procedure SIRegister_Field(CL: TPSPascalCompiler);
procedure SIRegister_Fields(CL: TPSPascalCompiler);
procedure SIRegister_Fields15(CL: TPSPascalCompiler);
procedure SIRegister__Recordset(CL: TPSPascalCompiler);
procedure SIRegister_Recordset20(CL: TPSPascalCompiler);
procedure SIRegister_Recordset15(CL: TPSPascalCompiler);
procedure SIRegister__Connection(CL: TPSPascalCompiler);
procedure SIRegister_Connection15(CL: TPSPascalCompiler);
procedure SIRegister_Command15(CL: TPSPascalCompiler);
procedure SIRegister_Errors(CL: TPSPascalCompiler);
procedure SIRegister_Error(CL: TPSPascalCompiler);
procedure SIRegister_Property_(CL: TPSPascalCompiler);
procedure SIRegister_Properties(CL: TPSPascalCompiler);
procedure SIRegister__ADO(CL: TPSPascalCompiler);
procedure SIRegister__DynaCollection(CL: TPSPascalCompiler);
procedure SIRegister__Collection(CL: TPSPascalCompiler);
procedure SIRegister_ADOInt(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CoParameter(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoRecordset(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoCommand(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_ADOInt(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ActiveX
  ,ADOInt
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ADOInt]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_CoParameter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoParameter') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoParameter') do
  begin
    RegisterMethod('Function Create : _Parameter');
    RegisterMethod('Function CreateRemote( const MachineName : string) : _Parameter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoRecordset(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoRecordset') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoRecordset') do
  begin
    RegisterMethod('Function Create : _Recordset');
    RegisterMethod('Function CreateRemote( const MachineName : string) : _Recordset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoCommand(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoCommand') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoCommand') do
  begin
    RegisterMethod('Function Create : _Command');
    RegisterMethod('Function CreateRemote( const MachineName : string) : _Command');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoConnection') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoConnection') do
  begin
    RegisterMethod('Function Create : _Connection');
    RegisterMethod('Function CreateRemote( const MachineName : string) : _Connection');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDataspace(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'IDataspace') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),IDataspace, 'IDataspace') do
  begin
    RegisterMethod('Function CreateObject( const bstrProgid : WideString; const bstrConnection : WideString) : OleVariant', CdStdCall);
    RegisterMethod('Function Get_InternetTimeout : Integer', CdStdCall);
    RegisterMethod('Procedure Set_InternetTimeout( plInetTimeout : Integer)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ADORecordsetConstruction(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ADORecordsetConstruction') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ADORecordsetConstruction, 'ADORecordsetConstruction') do
  begin
    RegisterMethod('Function Get_Rowset : IUnknown', CdStdCall);
    RegisterMethod('Procedure Set_Rowset( const ppRowset : IUnknown)', CdStdCall);
    RegisterMethod('Function Get_Chapter : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Chapter( plChapter : Integer)', CdStdCall);
    RegisterMethod('Function Get_RowPosition : IUnknown', CdStdCall);
    RegisterMethod('Procedure Set_RowPosition( const ppRowPos : IUnknown)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ADOCommandConstruction(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'ADOCommandConstruction') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),ADOCommandConstruction, 'ADOCommandConstruction') do
  begin
    RegisterMethod('Function Get_OLEDBCommand : IUnknown', CdStdCall);
    RegisterMethod('Procedure Set_OLEDBCommand( const ppOLEDBCommand : IUnknown)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ADOConnectionConstruction(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'ADOConnectionConstruction15', 'ADOConnectionConstruction') do
  with CL.AddInterface(CL.FindInterface('ADOConnectionConstruction15'),ADOConnectionConstruction, 'ADOConnectionConstruction') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ADOConnectionConstruction15(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'ADOConnectionConstruction15') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),ADOConnectionConstruction15, 'ADOConnectionConstruction15') do
  begin
    RegisterMethod('Function Get_DSO : IUnknown', CdStdCall);
    RegisterMethod('Function Get_Session : IUnknown', CdStdCall);
    RegisterMethod('Procedure WrapDSOandSession( const pDSO : IUnknown; const pSession : IUnknown)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_RecordsetEventsVt(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'RecordsetEventsVt') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),RecordsetEventsVt, 'RecordsetEventsVt') do
  begin
    RegisterMethod('Procedure WillChangeField( cFields : Integer; Fields : OleVariant; var adStatus : EventStatusEnum; const pRecordset : _Recordset)', CdStdCall);
    RegisterMethod('Procedure FieldChangeComplete( cFields : Integer; Fields : OleVariant; const pError : Error; var adStatus : EventStatusEnum; const pRecordset : _Recordset)', CdStdCall);
    RegisterMethod('Procedure WillChangeRecord( adReason : EventReasonEnum; cRecords : Integer; var adStatus : EventStatusEnum; const pRecordset : _Recordset)', CdStdCall);
    RegisterMethod('Procedure RecordChangeComplete( adReason : EventReasonEnum; cRecords : Integer; const pError : Error; var adStatus : EventStatusEnum; const pRecordset : _Recordset)', CdStdCall);
    RegisterMethod('Procedure WillChangeRecordset( adReason : EventReasonEnum; var adStatus : EventStatusEnum; const pRecordset : _Recordset)', CdStdCall);
    RegisterMethod('Procedure RecordsetChangeComplete( adReason : EventReasonEnum; const pError : Error; var adStatus : EventStatusEnum; const pRecordset : _Recordset)', CdStdCall);
    RegisterMethod('Procedure WillMove( adReason : EventReasonEnum; var adStatus : EventStatusEnum; const pRecordset : _Recordset)', CdStdCall);
    RegisterMethod('Procedure MoveComplete( adReason : EventReasonEnum; const pError : Error; var adStatus : EventStatusEnum; const pRecordset : _Recordset)', CdStdCall);
    RegisterMethod('Procedure EndOfRecordset( var fMoreData : WordBool; var adStatus : EventStatusEnum; const pRecordset : _Recordset)', CdStdCall);
    RegisterMethod('Procedure FetchProgress( Progress, MaxProgress : Integer; var adStatus : EventStatusEnum; const pRecordset : _Recordset)', CdStdCall);
    RegisterMethod('Procedure FetchComplete( const pError : Error; var adStatus : EventStatusEnum; const pRecordset : _Recordset)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ConnectionEventsVt(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'ConnectionEventsVt') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),ConnectionEventsVt, 'ConnectionEventsVt') do
  begin
    RegisterMethod('Procedure InfoMessage( const pError : Error; var adStatus : EventStatusEnum; const pConnection : _Connection)', CdStdCall);
    RegisterMethod('Procedure BeginTransComplete( TransactionLevel : Integer; const pError : Error; var adStatus : EventStatusEnum; const pConnection : _Connection)', CdStdCall);
    RegisterMethod('Procedure CommitTransComplete( const pError : Error; var adStatus : EventStatusEnum; const pConnection : _Connection)', CdStdCall);
    RegisterMethod('Procedure RollbackTransComplete( const pError : Error; var adStatus : EventStatusEnum; const pConnection : _Connection)', CdStdCall);
    RegisterMethod('Procedure WillExecute( var Source : WideString; var CursorType : CursorTypeEnum; var LockType : LockTypeEnum; var Options : Integer; var adStatus : EventStatusEnum; const pCommand : _Command; const pR' +
      'ecordset : _Recordset; const pConnection : _Connection)', CdStdCall);
    RegisterMethod('Procedure ExecuteComplete( RecordsAffected : Integer; const pError : Error; var adStatus : EventStatusEnum; const pCommand : _Command; const pRecordset : _Recordset; const pConnection : _Connection)', CdStdCall);
    RegisterMethod('Procedure WillConnect( var ConnectionString : WideString; var UserID : WideString; var Password : WideString; var Options : Integer; var adStatus : EventStatusEnum; const pConnection : _Connection)', CdStdCall);
    RegisterMethod('Procedure ConnectComplete( const pError : Error; var adStatus : EventStatusEnum; const pConnection : _Connection)', CdStdCall);
    RegisterMethod('Procedure Disconnect( var adStatus : EventStatusEnum; const pConnection : _Connection)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__Command(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'Command15', '_Command') do
  with CL.AddInterface(CL.FindInterface('Command15'),_Command, '_Command') do
  begin
    RegisterMethod('Function Get_State : Integer', CdStdCall);
    RegisterMethod('Procedure Cancel', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Parameters(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'_DynaCollection', 'Parameters') do
  with CL.AddInterface(CL.FindInterface('_DynaCollection'),Parameters, 'Parameters') do
  begin
    RegisterMethod('Function Get_Item( Index : OleVariant) : _Parameter', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__Parameter(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'_ADO', '_Parameter') do
  with CL.AddInterface(CL.FindInterface('_ADO'),_Parameter, '_Parameter') do
  begin
    RegisterMethod('Function Get_Name : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Name( const pbstr : WideString)', CdStdCall);
    RegisterMethod('Function Get_Value : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Value( pvar : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_Type_ : DataTypeEnum', CdStdCall);
    RegisterMethod('Procedure Set_Type_( psDataType : DataTypeEnum)', CdStdCall);
    RegisterMethod('Procedure Set_Direction( plParmDirection : ParameterDirectionEnum)', CdStdCall);
    RegisterMethod('Function Get_Direction : ParameterDirectionEnum', CdStdCall);
    RegisterMethod('Procedure Set_Precision( pbPrecision : Byte)', CdStdCall);
    RegisterMethod('Function Get_Precision : Byte', CdStdCall);
    RegisterMethod('Procedure Set_NumericScale( pbScale : Byte)', CdStdCall);
    RegisterMethod('Function Get_NumericScale : Byte', CdStdCall);
    RegisterMethod('Procedure Set_Size( pl : Integer)', CdStdCall);
    RegisterMethod('Function Get_Size : Integer', CdStdCall);
    RegisterMethod('Procedure AppendChunk( Val : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_Attributes : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Attributes( plParmAttribs : Integer)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Field15(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'_ADO', 'Field15') do
  with CL.AddInterface(CL.FindInterface('_ADO'),Field15, 'Field15') do
  begin
    RegisterMethod('Function Get_ActualSize : Integer', CdStdCall);
    RegisterMethod('Function Get_Attributes : Integer', CdStdCall);
    RegisterMethod('Function Get_DefinedSize : Integer', CdStdCall);
    RegisterMethod('Function Get_Name : WideString', CdStdCall);
    RegisterMethod('Function Get_Type_ : DataTypeEnum', CdStdCall);
    RegisterMethod('Function Get_Value : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Value( pvar : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_Precision : Byte', CdStdCall);
    RegisterMethod('Function Get_NumericScale : Byte', CdStdCall);
    RegisterMethod('Procedure AppendChunk( Data : OleVariant)', CdStdCall);
    RegisterMethod('Function GetChunk( Length : Integer) : OleVariant', CdStdCall);
    RegisterMethod('Function Get_OriginalValue : OleVariant', CdStdCall);
    RegisterMethod('Function Get_UnderlyingValue : OleVariant', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Field(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'_ADO', 'Field') do
  with CL.AddInterface(CL.FindInterface('_ADO'),Field, 'Field') do
  begin
    RegisterMethod('Function Get_ActualSize : Integer', CdStdCall);
    RegisterMethod('Function Get_Attributes : Integer', CdStdCall);
    RegisterMethod('Function Get_DefinedSize : Integer', CdStdCall);
    RegisterMethod('Function Get_Name : WideString', CdStdCall);
    RegisterMethod('Function Get_Type_ : DataTypeEnum', CdStdCall);
    RegisterMethod('Function Get_Value : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Value( pvar : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_Precision : Byte', CdStdCall);
    RegisterMethod('Function Get_NumericScale : Byte', CdStdCall);
    RegisterMethod('Procedure AppendChunk( Data : OleVariant)', CdStdCall);
    RegisterMethod('Function GetChunk( Length : Integer) : OleVariant', CdStdCall);
    RegisterMethod('Function Get_OriginalValue : OleVariant', CdStdCall);
    RegisterMethod('Function Get_UnderlyingValue : OleVariant', CdStdCall);
    RegisterMethod('Function Get_DataFormat : IUnknown', CdStdCall);
    RegisterMethod('Procedure Set_DataFormat( const ppiDF : IUnknown)', CdStdCall);
    RegisterMethod('Procedure Set_Precision( pbPrecision : Byte)', CdStdCall);
    RegisterMethod('Procedure Set_NumericScale( pbNumericScale : Byte)', CdStdCall);
    RegisterMethod('Procedure Set_Type_( pDataType : DataTypeEnum)', CdStdCall);
    RegisterMethod('Procedure Set_DefinedSize( pl : Integer)', CdStdCall);
    RegisterMethod('Procedure Set_Attributes( pl : Integer)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Fields(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'Fields15', 'Fields') do
  with CL.AddInterface(CL.FindInterface('Fields15'),Fields, 'Fields') do
  begin
    RegisterMethod('Procedure Append( const Name : WideString; Type_ : DataTypeEnum; DefinedSize : Integer; Attrib : FieldAttributeEnum)', CdStdCall);
    RegisterMethod('Procedure Delete( Index : OleVariant)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Fields15(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'_Collection', 'Fields15') do
  with CL.AddInterface(CL.FindInterface('_Collection'),Fields15, 'Fields15') do
  begin
    RegisterMethod('Function Get_Item( Index : OleVariant) : Field', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__Recordset(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'Recordset20', '_Recordset') do
  with CL.AddInterface(CL.FindInterface('Recordset20'),_Recordset, '_Recordset') do begin
    //['{00000555-0000-0010-8000-00AA006D2EA4}']

    RegisterMethod('Procedure Seek( KeyValues : OleVariant; SeekOption : SeekEnum)', CdStdCall);
    RegisterMethod('Procedure Set_Index( const pbstrIndex : WideString)', CdStdCall);
    RegisterMethod('Function Get_Index : WideString', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Recordset20(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'Recordset15', 'Recordset20') do
  with CL.AddInterface(CL.FindInterface('Recordset15'),Recordset20, 'Recordset20') do
  begin
    RegisterMethod('Procedure Cancel', CdStdCall);
    RegisterMethod('Function Get_DataSource : IUnknown', CdStdCall);
    RegisterMethod('Procedure Set_DataSource( const ppunkDataSource : IUnknown)', CdStdCall);
    RegisterMethod('Procedure Save( const FileName : WideString; PersistFormat : PersistFormatEnum)', CdStdCall);
    RegisterMethod('Function Get_ActiveCommand : IDispatch', CdStdCall);
    RegisterMethod('Procedure Set_StayInSync( pbStayInSync : WordBool)', CdStdCall);
    RegisterMethod('Function Get_StayInSync : WordBool', CdStdCall);
    RegisterMethod('Function GetString( StringFormat : StringFormatEnum; NumRows : Integer; const ColumnDelimeter : WideString; const RowDelimeter : WideString; const NullExpr : WideString) : WideString', CdStdCall);
    RegisterMethod('Function Get_DataMember : WideString', CdStdCall);
    RegisterMethod('Procedure Set_DataMember( const pbstrDataMember : WideString)', CdStdCall);
    RegisterMethod('Function CompareBookmarks( Bookmark1 : OleVariant; Bookmark2 : OleVariant) : CompareEnum', CdStdCall);
    RegisterMethod('Function Clone( LockType : LockTypeEnum) : _Recordset', CdStdCall);
    RegisterMethod('Procedure Resync( AffectRecords : AffectEnum; ResyncValues : ResyncEnum)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Recordset15(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'_ADO', 'Recordset15') do
  with CL.AddInterface(CL.FindInterface('_ADO'),Recordset15, 'Recordset15') do
  begin
    RegisterMethod('Function Get_AbsolutePosition : PositionEnum', CdStdCall);
    RegisterMethod('Procedure Set_AbsolutePosition( pl : PositionEnum)', CdStdCall);
    RegisterMethod('Procedure Set_ActiveConnection( const pvar : IDispatch)', CdStdCall);
    RegisterMethod('Procedure _Set_ActiveConnection( pvar : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_ActiveConnection : OleVariant', CdStdCall);
    RegisterMethod('Function Get_BOF : WordBool', CdStdCall);
    RegisterMethod('Function Get_Bookmark : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Bookmark( pvBookmark : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_CacheSize : Integer', CdStdCall);
    RegisterMethod('Procedure Set_CacheSize( pl : Integer)', CdStdCall);
    RegisterMethod('Function Get_CursorType : CursorTypeEnum', CdStdCall);
    RegisterMethod('Procedure Set_CursorType( plCursorType : CursorTypeEnum)', CdStdCall);
    RegisterMethod('Function Get_EOF : WordBool', CdStdCall);
    RegisterMethod('Function Get_Fields : Fields', CdStdCall);
    RegisterMethod('Function Get_LockType : LockTypeEnum', CdStdCall);
    RegisterMethod('Procedure Set_LockType( plLockType : LockTypeEnum)', CdStdCall);
    RegisterMethod('Function Get_MaxRecords : Integer', CdStdCall);
    RegisterMethod('Procedure Set_MaxRecords( plMaxRecords : Integer)', CdStdCall);
    RegisterMethod('Function Get_RecordCount : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Source( const pvSource : IDispatch)', CdStdCall);
    RegisterMethod('Procedure _Set_Source( const pvSource : WideString)', CdStdCall);
    RegisterMethod('Function Get_Source : OleVariant', CdStdCall);
    RegisterMethod('Procedure AddNew( FieldList : OleVariant; Values : OleVariant)', CdStdCall);
    RegisterMethod('Procedure CancelUpdate', CdStdCall);
    RegisterMethod('Procedure Close', CdStdCall);
    RegisterMethod('Procedure Delete( AffectRecords : AffectEnum)', CdStdCall);
    RegisterMethod('Function GetRows( Rows : Integer; Start : OleVariant; Fields : OleVariant) : OleVariant', CdStdCall);
    RegisterMethod('Procedure Move( NumRecords : Integer; Start : OleVariant)', CdStdCall);
    RegisterMethod('Procedure MoveNext', CdStdCall);
    RegisterMethod('Procedure MovePrevious', CdStdCall);
    RegisterMethod('Procedure MoveFirst', CdStdCall);
    RegisterMethod('Procedure MoveLast', CdStdCall);
    RegisterMethod('Procedure Open( Source : OleVariant; ActiveConnection : OleVariant; CursorType : CursorTypeEnum; LockType : LockTypeEnum; Options : Integer)', CdStdCall);
    RegisterMethod('Procedure Requery( Options : Integer)', CdStdCall);
    RegisterMethod('Procedure _xResync( AffectRecords : AffectEnum)', CdStdCall);
    RegisterMethod('Procedure Update( Fields : OleVariant; Values : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_AbsolutePage : PositionEnum', CdStdCall);
    RegisterMethod('Procedure Set_AbsolutePage( pl : PositionEnum)', CdStdCall);
    RegisterMethod('Function Get_EditMode : EditModeEnum', CdStdCall);
    RegisterMethod('Function Get_Filter : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Filter( Criteria : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_PageCount : Integer', CdStdCall);
    RegisterMethod('Function Get_PageSize : Integer', CdStdCall);
    RegisterMethod('Procedure Set_PageSize( pl : Integer)', CdStdCall);
    RegisterMethod('Function Get_Sort : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Sort( const Criteria : WideString)', CdStdCall);
    RegisterMethod('Function Get_Status : Integer', CdStdCall);
    RegisterMethod('Function Get_State : Integer', CdStdCall);
    RegisterMethod('Function _xClone : _Recordset', CdStdCall);
    RegisterMethod('Procedure UpdateBatch( AffectRecords : AffectEnum)', CdStdCall);
    RegisterMethod('Procedure CancelBatch( AffectRecords : AffectEnum)', CdStdCall);
    RegisterMethod('Function Get_CursorLocation : CursorLocationEnum', CdStdCall);
    RegisterMethod('Procedure Set_CursorLocation( plCursorLoc : CursorLocationEnum)', CdStdCall);
    RegisterMethod('Function NextRecordset( out RecordsAffected : OleVariant) : _Recordset', CdStdCall);
    RegisterMethod('Function Supports( CursorOptions : CursorOptionEnum) : WordBool', CdStdCall);
    RegisterMethod('Function Get_Collect( Index : OleVariant) : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Collect( Index : OleVariant; pvar : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_MarshalOptions : MarshalOptionsEnum', CdStdCall);
    RegisterMethod('Procedure Set_MarshalOptions( peMarshal : MarshalOptionsEnum)', CdStdCall);
    RegisterMethod('Procedure Find( const Criteria : WideString; SkipRecords : Integer; SearchDirection : SearchDirectionEnum; Start : OleVariant)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__Connection(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'Connection15', '_Connection') do
  with CL.AddInterface(CL.FindInterface('Connection15'),_Connection, '_Connection') do
  begin
    RegisterMethod('Procedure Cancel', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Connection15(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'_ADO', 'Connection15') do
  with CL.AddInterface(CL.FindInterface('_ADO'),Connection15, 'Connection15') do
  begin
    RegisterMethod('Function Get_ConnectionString : WideString', CdStdCall);
    RegisterMethod('Procedure Set_ConnectionString( const pbstr : WideString)', CdStdCall);
    RegisterMethod('Function Get_CommandTimeout : Integer', CdStdCall);
    RegisterMethod('Procedure Set_CommandTimeout( plTimeout : Integer)', CdStdCall);
    RegisterMethod('Function Get_ConnectionTimeout : Integer', CdStdCall);
    RegisterMethod('Procedure Set_ConnectionTimeout( plTimeout : Integer)', CdStdCall);
    RegisterMethod('Function Get_Version : WideString', CdStdCall);
    RegisterMethod('Procedure Close', CdStdCall);
    RegisterMethod('Function Execute( const CommandText : WideString; out RecordsAffected : OleVariant; Options : Integer) : _Recordset', CdStdCall);
    RegisterMethod('Function BeginTrans : Integer', CdStdCall);
    RegisterMethod('Procedure CommitTrans', CdStdCall);
    RegisterMethod('Procedure RollbackTrans', CdStdCall);
    RegisterMethod('Procedure Open( const ConnectionString : WideString; const UserID : WideString; const Password : WideString; Options : Integer)', CdStdCall);
    RegisterMethod('Function Get_Errors : Errors', CdStdCall);
    RegisterMethod('Function Get_DefaultDatabase : WideString', CdStdCall);
    RegisterMethod('Procedure Set_DefaultDatabase( const pbstr : WideString)', CdStdCall);
    RegisterMethod('Function Get_IsolationLevel : IsolationLevelEnum', CdStdCall);
    RegisterMethod('Procedure Set_IsolationLevel( Level : IsolationLevelEnum)', CdStdCall);
    RegisterMethod('Function Get_Attributes : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Attributes( plAttr : Integer)', CdStdCall);
    RegisterMethod('Function Get_CursorLocation : CursorLocationEnum', CdStdCall);
    RegisterMethod('Procedure Set_CursorLocation( plCursorLoc : CursorLocationEnum)', CdStdCall);
    RegisterMethod('Function Get_Mode : ConnectModeEnum', CdStdCall);
    RegisterMethod('Procedure Set_Mode( plMode : ConnectModeEnum)', CdStdCall);
    RegisterMethod('Function Get_Provider : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Provider( const pbstr : WideString)', CdStdCall);
    RegisterMethod('Function Get_State : Integer', CdStdCall);
    RegisterMethod('Function OpenSchema( Schema : SchemaEnum; Restrictions : OleVariant; SchemaID : OleVariant) : _Recordset', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Command15(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'_ADO', 'Command15') do
  with CL.AddInterface(CL.FindInterface('_ADO'),Command15, 'Command15') do
  begin
    RegisterMethod('Function Get_ActiveConnection : _Connection', CdStdCall);
    RegisterMethod('Procedure Set_ActiveConnection( const ppvObject : _Connection)', CdStdCall);
    RegisterMethod('Procedure _Set_ActiveConnection( ppvObject : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_CommandText : WideString', CdStdCall);
    RegisterMethod('Procedure Set_CommandText( const pbstr : WideString)', CdStdCall);
    RegisterMethod('Function Get_CommandTimeout : Integer', CdStdCall);
    RegisterMethod('Procedure Set_CommandTimeout( pl : Integer)', CdStdCall);
    RegisterMethod('Function Get_Prepared : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_Prepared( pfPrepared : WordBool)', CdStdCall);
    RegisterMethod('Function Execute( out RecordsAffected : OleVariant; const Parameters : OleVariant; Options : Integer) : _Recordset', CdStdCall);
    RegisterMethod('Function CreateParameter( const Name : WideString; Type_ : DataTypeEnum; Direction : ParameterDirectionEnum; Size : Integer; Value : OleVariant) : _Parameter', CdStdCall);
    RegisterMethod('Function Get_Parameters : Parameters', CdStdCall);
    RegisterMethod('Procedure Set_CommandType( plCmdType : CommandTypeEnum)', CdStdCall);
    RegisterMethod('Function Get_CommandType : CommandTypeEnum', CdStdCall);
    RegisterMethod('Function Get_Name : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Name( const pbstrName : WideString)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Errors(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'_Collection', 'Errors') do
  with CL.AddInterface(CL.FindInterface('_Collection'),Errors, 'Errors') do
  begin
    RegisterMethod('Function Get_Item( Index : OleVariant) : Error', CdStdCall);
    RegisterMethod('Procedure Clear', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Error(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'Error') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),Error, 'Error') do
  begin
    RegisterMethod('Function Get_Number : Integer', CdStdCall);
    RegisterMethod('Function Get_Source : WideString', CdStdCall);
    RegisterMethod('Function Get_Description : WideString', CdStdCall);
    RegisterMethod('Function Get_HelpFile : WideString', CdStdCall);
    RegisterMethod('Function Get_HelpContext : Integer', CdStdCall);
    RegisterMethod('Function Get_SQLState : WideString', CdStdCall);
    RegisterMethod('Function Get_NativeError : Integer', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Property_(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'Property_') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),Property_, 'Property_') do
  begin
    RegisterMethod('Function Get_Value : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Value( pval : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_Name : WideString', CdStdCall);
    RegisterMethod('Function Get_Type_ : DataTypeEnum', CdStdCall);
    RegisterMethod('Function Get_Attributes : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Attributes( plAttributes : Integer)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Properties(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'_Collection', 'Properties') do
  with CL.AddInterface(CL.FindInterface('_Collection'),Properties, 'Properties') do
  begin
    RegisterMethod('Function Get_Item( Index : OleVariant) : Property_', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__ADO(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', '_ADO') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),_ADO, '_ADO') do
  begin
    RegisterMethod('Function Get_Properties : Properties', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__DynaCollection(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'_Collection', '_DynaCollection') do
  with CL.AddInterface(CL.FindInterface('_Collection'),_DynaCollection, '_DynaCollection') do
  begin
    RegisterMethod('Procedure Append( const Object_ : IDispatch)', CdStdCall);
    RegisterMethod('Procedure Delete( Index : OleVariant)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__Collection(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', '_Collection') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),_Collection, '_Collection') do
  begin
    RegisterMethod('Function Get_Count : Integer', CdStdCall);
    RegisterMethod('Function _NewEnum : IUnknown', CdStdCall);
    RegisterMethod('Procedure Refresh', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ADOInt(CL: TPSPascalCompiler);
begin
 (*
 CL.AddConstantN('LIBID_ADODB','TGUID').SetString( '{00000201-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('CLASS_Connection','TGUID').SetString( '{00000514-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('CLASS_Command','TGUID').SetString( '{00000507-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('CLASS_Recordset','TGUID').SetString( '{00000535-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('CLASS_Parameter','TGUID').SetString( '{0000050B-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('CLASS_DataSpace','TGUID').SetString( '{BD96C556-65A3-11D0-983A-00C04FC29E36}');
 CL.AddConstantN('CLASS_DataFactory','TGUID').SetString( '{9381D8F5-0288-11D0-9501-00AA00B911A5}');
 CL.AddConstantN('IID__Collection','TGUID').SetString( '{00000512-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID__DynaCollection','TGUID').SetString( '{00000513-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID__ADO','TGUID').SetString( '{00000534-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Properties','TGUID').SetString( '{00000504-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Property_','TGUID').SetString( '{00000503-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Error','TGUID').SetString( '{00000500-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Errors','TGUID').SetString( '{00000501-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Command15','TGUID').SetString( '{00000508-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Connection15','TGUID').SetString( '{00000515-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID__Connection','TGUID').SetString( '{00000550-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Recordset15','TGUID').SetString( '{0000050E-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Recordset20','TGUID').SetString( '{0000054F-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID__Recordset','TGUID').SetString( '{00000555-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Fields15','TGUID').SetString( '{00000506-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Fields','TGUID').SetString( '{0000054D-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Field','TGUID').SetString( '{0000054C-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID__Parameter','TGUID').SetString( '{0000050C-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Parameters','TGUID').SetString( '{0000050D-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID__Command','TGUID').SetString( '{0000054E-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_ConnectionEventsVt','TGUID').SetString( '{00000402-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('DIID_ConnectionEvents','TGUID').SetString( '{00000400-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_RecordsetEventsVt','TGUID').SetString( '{00000403-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('DIID_RecordsetEvents','TGUID').SetString( '{00000266-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_ADOConnectionConstruction15','TGUID').SetString( '{00000516-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_ADOConnectionConstruction','TGUID').SetString( '{00000551-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_ADOCommandConstruction','TGUID').SetString( '{00000517-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_ADORecordsetConstruction','TGUID').SetString( '{00000283-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_Field15','TGUID').SetString( '{00000505-0000-0010-8000-00AA006D2EA4}');
 CL.AddConstantN('IID_IDataspace','TGUID').SetString( '{BD96C556-65A3-11D0-983A-00C04FC29E34}');
    *)

    //  TOleEnum = type LongWord;
  CL.AddTypeS('TOleEnum', 'LongWord');
 CL.AddConstantN('IID_Recordset15','string').SetString( '{0000050E-0000-0010-8000-00AA006D2EA4}');

  CL.AddConstantN('IID_Recordset20','string').SetString( '{0000054F-0000-0010-8000-00AA006D2EA4}'']');
 CL.AddConstantN('IID__Recordset','string').SetString( '00000555-0000-0010-8000-00AA006D2EA4');
//7 CL.AddConstantN('CLASS_Command','TGUID').SetString( '{00000507-0000-0010-8000-00AA006D2EA4}');
// CL.AddConstantN('CLASS_Recordset','TGUID').SetString( '{00000535-0000-0010-8000-00AA006D2EA4}');
// CL.AddConstantN('CLASS_Parameter','TGUID').SetString( '{0000050B-0000-0010-8000-00AA006D2EA4}');
// CL.AddConstantN('CLASS_DataSpace','TGUID').SetString( '{BD96C556-65A3-11D0-983A-00C04FC29E36}');



 CL.AddConstantN('CT_USERID','String').SetString( 'USER ID=');
 CL.AddConstantN('CT_PROVIDER','String').SetString( 'PROVIDER=');
 CL.AddConstantN('CT_FILENAME','String').SetString( 'FILE NAME=');
  //CL.AddTypeS('CursorTypeEnum', 'TOleEnum');
 CL.AddConstantN('adOpenUnspecified','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('adOpenForwardOnly','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adOpenKeyset','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adOpenDynamic','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adOpenStatic','LongWord').SetUInt( $00000003);
  CL.AddTypeS('CursorOptionEnum', 'TOleEnum');
 CL.AddConstantN('adHoldRecords','LongWord').SetUInt( $00000100);
 CL.AddConstantN('adMovePrevious','LongWord').SetUInt( $00000200);
 CL.AddConstantN('adAddNew','LongWord').SetUInt( $01000400);
 CL.AddConstantN('adDelete','LongWord').SetUInt( $01000800);
 CL.AddConstantN('adUpdate','LongWord').SetUInt( $01008000);
 CL.AddConstantN('adBookmark','LongWord').SetUInt( $00002000);
 CL.AddConstantN('adApproxPosition','LongWord').SetUInt( $00004000);
 CL.AddConstantN('adUpdateBatch','LongWord').SetUInt( $00010000);
 CL.AddConstantN('adResync','LongWord').SetUInt( $00020000);
 CL.AddConstantN('adNotify','LongWord').SetUInt( $00040000);
 CL.AddConstantN('adFind','LongWord').SetUInt( $00080000);
 CL.AddConstantN('adSeek','LongWord').SetUInt( $00400000);
 CL.AddConstantN('adIndex','LongWord').SetUInt( $00800000);
 // CL.AddTypeS('LockTypeEnum', 'TOleEnum');
 CL.AddConstantN('adLockUnspecified','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('adLockReadOnly','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adLockPessimistic','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adLockOptimistic','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adLockBatchOptimistic','LongWord').SetUInt( $00000004);
  CL.AddTypeS('ExecuteOptionEnum', 'TOleEnum');
 CL.AddConstantN('adOptionUnspecified','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('adAsyncExecute','LongWord').SetUInt( $00000010);
 CL.AddConstantN('adAsyncFetch','LongWord').SetUInt( $00000020);
 CL.AddConstantN('adAsyncFetchNonBlocking','LongWord').SetUInt( $00000040);
 CL.AddConstantN('adExecuteNoRecords','LongWord').SetUInt( $00000080);
  CL.AddTypeS('ConnectOptionEnum', 'TOleEnum');
 CL.AddConstantN('adConnectUnspecified','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('adAsyncConnect','LongWord').SetUInt( $00000010);
  CL.AddTypeS('ObjectStateEnum', 'TOleEnum');
 CL.AddConstantN('adStateClosed','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adStateOpen','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adStateConnecting','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adStateExecuting','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adStateFetching','LongWord').SetUInt( $00000008);
  CL.AddTypeS('CursorLocationEnum', 'TOleEnum');
 CL.AddConstantN('adUseNone','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adUseServer','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adUseClient','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adUseClientBatch','LongWord').SetUInt( $00000003);
  CL.AddTypeS('DataTypeEnum', 'TOleEnum');
 CL.AddConstantN('adEmpty','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adTinyInt','LongWord').SetUInt( $00000010);
 CL.AddConstantN('adSmallInt','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adInteger','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adBigInt','LongWord').SetUInt( $00000014);
 CL.AddConstantN('adUnsignedTinyInt','LongWord').SetUInt( $00000011);
 CL.AddConstantN('adUnsignedSmallInt','LongWord').SetUInt( $00000012);
 CL.AddConstantN('adUnsignedInt','LongWord').SetUInt( $00000013);
 CL.AddConstantN('adUnsignedBigInt','LongWord').SetUInt( $00000015);
 CL.AddConstantN('adSingle','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adDouble','LongWord').SetUInt( $00000005);
 CL.AddConstantN('adCurrency','LongWord').SetUInt( $00000006);
 CL.AddConstantN('adDecimal','LongWord').SetUInt( $0000000E);
 CL.AddConstantN('adNumeric','LongWord').SetUInt( $00000083);
 CL.AddConstantN('adBoolean','LongWord').SetUInt( $0000000B);
 CL.AddConstantN('adError','LongWord').SetUInt( $0000000A);
 CL.AddConstantN('adUserDefined','LongWord').SetUInt( $00000084);
 CL.AddConstantN('adVariant','LongWord').SetUInt( $0000000C);
 CL.AddConstantN('adIDispatch','LongWord').SetUInt( $00000009);
 CL.AddConstantN('adIUnknown','LongWord').SetUInt( $0000000D);
 CL.AddConstantN('adGUID','LongWord').SetUInt( $00000048);
 CL.AddConstantN('adDate','LongWord').SetUInt( $00000007);
 CL.AddConstantN('adDBDate','LongWord').SetUInt( $00000085);
 CL.AddConstantN('adDBTime','LongWord').SetUInt( $00000086);
 CL.AddConstantN('adDBTimeStamp','LongWord').SetUInt( $00000087);
 CL.AddConstantN('adBSTR','LongWord').SetUInt( $00000008);
 CL.AddConstantN('adChar','LongWord').SetUInt( $00000081);
 CL.AddConstantN('adVarChar','LongWord').SetUInt( $000000C8);
 CL.AddConstantN('adLongVarChar','LongWord').SetUInt( $000000C9);
 CL.AddConstantN('adWChar','LongWord').SetUInt( $00000082);
 CL.AddConstantN('adVarWChar','LongWord').SetUInt( $000000CA);
 CL.AddConstantN('adLongVarWChar','LongWord').SetUInt( $000000CB);
 CL.AddConstantN('adBinary','LongWord').SetUInt( $00000080);
 CL.AddConstantN('adVarBinary','LongWord').SetUInt( $000000CC);
 CL.AddConstantN('adLongVarBinary','LongWord').SetUInt( $000000CD);
 CL.AddConstantN('adChapter','LongWord').SetUInt( $00000088);
 CL.AddConstantN('adFileTime','LongWord').SetUInt( $00000040);
 CL.AddConstantN('adDBFileTime','LongWord').SetUInt( $00000089);
 CL.AddConstantN('adPropVariant','LongWord').SetUInt( $0000008A);
 CL.AddConstantN('adVarNumeric','LongWord').SetUInt( $0000008B);
  CL.AddTypeS('FieldAttributeEnum', 'TOleEnum');
 CL.AddConstantN('adFldUnspecified','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('adFldMayDefer','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adFldUpdatable','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adFldUnknownUpdatable','LongWord').SetUInt( $00000008);
 CL.AddConstantN('adFldFixed','LongWord').SetUInt( $00000010);
 CL.AddConstantN('adFldIsNullable','LongWord').SetUInt( $00000020);
 CL.AddConstantN('adFldMayBeNull','LongWord').SetUInt( $00000040);
 CL.AddConstantN('adFldLong','LongWord').SetUInt( $00000080);
 CL.AddConstantN('adFldRowID','LongWord').SetUInt( $00000100);
 CL.AddConstantN('adFldRowVersion','LongWord').SetUInt( $00000200);
 CL.AddConstantN('adFldCacheDeferred','LongWord').SetUInt( $00001000);
 CL.AddConstantN('adFldNegativeScale','LongWord').SetUInt( $00004000);
 CL.AddConstantN('adFldKeyColumn','LongWord').SetUInt( $00008000);
  CL.AddTypeS('EditModeEnum', 'TOleEnum');
 CL.AddConstantN('adEditNone','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adEditInProgress','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adEditAdd','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adEditDelete','LongWord').SetUInt( $00000004);
  CL.AddTypeS('RecordStatusEnum', 'TOleEnum');
 CL.AddConstantN('adRecOK','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adRecNew','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adRecModified','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adRecDeleted','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adRecUnmodified','LongWord').SetUInt( $00000008);
 CL.AddConstantN('adRecInvalid','LongWord').SetUInt( $00000010);
 CL.AddConstantN('adRecMultipleChanges','LongWord').SetUInt( $00000040);
 CL.AddConstantN('adRecPendingChanges','LongWord').SetUInt( $00000080);
 CL.AddConstantN('adRecCanceled','LongWord').SetUInt( $00000100);
 CL.AddConstantN('adRecCantRelease','LongWord').SetUInt( $00000400);
 CL.AddConstantN('adRecConcurrencyViolation','LongWord').SetUInt( $00000800);
 CL.AddConstantN('adRecIntegrityViolation','LongWord').SetUInt( $00001000);
 CL.AddConstantN('adRecMaxChangesExceeded','LongWord').SetUInt( $00002000);
 CL.AddConstantN('adRecObjectOpen','LongWord').SetUInt( $00004000);
 CL.AddConstantN('adRecOutOfMemory','LongWord').SetUInt( $00008000);
 CL.AddConstantN('adRecPermissionDenied','LongWord').SetUInt( $00010000);
 CL.AddConstantN('adRecSchemaViolation','LongWord').SetUInt( $00020000);
 CL.AddConstantN('adRecDBDeleted','LongWord').SetUInt( $00040000);
  CL.AddTypeS('GetRowsOptionEnum', 'TOleEnum');
 CL.AddConstantN('adGetRowsRest','LongWord').SetUInt( $FFFFFFFF);
  CL.AddTypeS('PositionEnum', 'TOleEnum');
 CL.AddConstantN('adPosUnknown','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('adPosBOF','LongWord').SetUInt( $FFFFFFFE);
 CL.AddConstantN('adPosEOF','LongWord').SetUInt( $FFFFFFFD);
  CL.AddTypeS('BookmarkEnum', 'TOleEnum');
 CL.AddConstantN('adBookmarkCurrent','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adBookmarkFirst','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adBookmarkLast','LongWord').SetUInt( $00000002);
  CL.AddTypeS('MarshalOptionsEnum', 'TOleEnum');
 CL.AddConstantN('adMarshalAll','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adMarshalModifiedOnly','LongWord').SetUInt( $00000001);
  CL.AddTypeS('AffectEnum', 'TOleEnum');
 CL.AddConstantN('adAffectCurrent','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adAffectGroup','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adAffectAll','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adAffectAllChapters','LongWord').SetUInt( $00000004);
  CL.AddTypeS('ResyncEnum', 'TOleEnum');
 CL.AddConstantN('adResyncUnderlyingValues','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adResyncAllValues','LongWord').SetUInt( $00000002);
  CL.AddTypeS('CompareEnum', 'TOleEnum');
 CL.AddConstantN('adCompareLessThan','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adCompareEqual','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adCompareGreaterThan','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adCompareNotEqual','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adCompareNotComparable','LongWord').SetUInt( $00000004);
  CL.AddTypeS('FilterGroupEnum', 'TOleEnum');
 CL.AddConstantN('adFilterNone','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adFilterPendingRecords','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adFilterAffectedRecords','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adFilterFetchedRecords','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adFilterPredicate','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adFilterConflictingRecords','LongWord').SetUInt( $00000005);
  CL.AddTypeS('SearchDirectionEnum', 'TOleEnum');
 CL.AddConstantN('adSearchForward','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adSearchBackward','LongWord').SetUInt( $FFFFFFFF);
  CL.AddTypeS('PersistFormatEnum', 'TOleEnum');
 CL.AddConstantN('adPersistADTG','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adPersistXML','LongWord').SetUInt( $00000001);
  CL.AddTypeS('StringFormatEnum', 'TOleEnum');
 CL.AddConstantN('adClipString','LongWord').SetUInt( $00000002);
  CL.AddTypeS('ConnectPromptEnum', 'TOleEnum');
 CL.AddConstantN('adPromptAlways','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adPromptComplete','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adPromptCompleteRequired','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adPromptNever','LongWord').SetUInt( $00000004);
  CL.AddTypeS('ConnectModeEnum', 'TOleEnum');
 CL.AddConstantN('adModeUnknown','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adModeRead','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adModeWrite','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adModeReadWrite','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adModeShareDenyRead','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adModeShareDenyWrite','LongWord').SetUInt( $00000008);
 CL.AddConstantN('adModeShareExclusive','LongWord').SetUInt( $0000000C);
 CL.AddConstantN('adModeShareDenyNone','LongWord').SetUInt( $00000010);
  CL.AddTypeS('IsolationLevelEnum', 'TOleEnum');
 CL.AddConstantN('adXactUnspecified','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('adXactChaos','LongWord').SetUInt( $00000010);
 CL.AddConstantN('adXactReadUncommitted','LongWord').SetUInt( $00000100);
 CL.AddConstantN('adXactBrowse','LongWord').SetUInt( $00000100);
 CL.AddConstantN('adXactCursorStability','LongWord').SetUInt( $00001000);
 CL.AddConstantN('adXactReadCommitted','LongWord').SetUInt( $00001000);
 CL.AddConstantN('adXactRepeatableRead','LongWord').SetUInt( $00010000);
 CL.AddConstantN('adXactSerializable','LongWord').SetUInt( $00100000);
 CL.AddConstantN('adXactIsolated','LongWord').SetUInt( $00100000);
  CL.AddTypeS('XactAttributeEnum', 'TOleEnum');
 CL.AddConstantN('adXactCommitRetaining','LongWord').SetUInt( $00020000);
 CL.AddConstantN('adXactAbortRetaining','LongWord').SetUInt( $00040000);
 CL.AddConstantN('adXactAsyncPhaseOne','LongWord').SetUInt( $00080000);
 CL.AddConstantN('adXactSyncPhaseOne','LongWord').SetUInt( $00100000);
  CL.AddTypeS('PropertyAttributesEnum', 'TOleEnum');
 CL.AddConstantN('adPropNotSupported','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adPropRequired','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adPropOptional','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adPropRead','LongWord').SetUInt( $00000200);
 CL.AddConstantN('adPropWrite','LongWord').SetUInt( $00000400);
  CL.AddTypeS('ErrorValueEnum', 'TOleEnum');
 CL.AddConstantN('adErrInvalidArgument','LongWord').SetUInt( $00000BB9);
 CL.AddConstantN('adErrNoCurrentRecord','LongWord').SetUInt( $00000BCD);
 CL.AddConstantN('adErrIllegalOperation','LongWord').SetUInt( $00000C93);
 CL.AddConstantN('adErrInTransaction','LongWord').SetUInt( $00000CAE);
 CL.AddConstantN('adErrFeatureNotAvailable','LongWord').SetUInt( $00000CB3);
 CL.AddConstantN('adErrItemNotFound','LongWord').SetUInt( $00000CC1);
 CL.AddConstantN('adErrObjectInCollection','LongWord').SetUInt( $00000D27);
 CL.AddConstantN('adErrObjectNotSet','LongWord').SetUInt( $00000D5C);
 CL.AddConstantN('adErrDataConversion','LongWord').SetUInt( $00000D5D);
 CL.AddConstantN('adErrObjectClosed','LongWord').SetUInt( $00000E78);
 CL.AddConstantN('adErrObjectOpen','LongWord').SetUInt( $00000E79);
 CL.AddConstantN('adErrProviderNotFound','LongWord').SetUInt( $00000E7A);
 CL.AddConstantN('adErrBoundToCommand','LongWord').SetUInt( $00000E7B);
 CL.AddConstantN('adErrInvalidParamInfo','LongWord').SetUInt( $00000E7C);
 CL.AddConstantN('adErrInvalidConnection','LongWord').SetUInt( $00000E7D);
 CL.AddConstantN('adErrNotReentrant','LongWord').SetUInt( $00000E7E);
 CL.AddConstantN('adErrStillExecuting','LongWord').SetUInt( $00000E7F);
 CL.AddConstantN('adErrOperationCancelled','LongWord').SetUInt( $00000E80);
 CL.AddConstantN('adErrStillConnecting','LongWord').SetUInt( $00000E81);
 CL.AddConstantN('adErrNotExecuting','LongWord').SetUInt( $00000E83);
 CL.AddConstantN('adErrUnsafeOperation','LongWord').SetUInt( $00000E84);
  CL.AddTypeS('ParameterAttributesEnum', 'TOleEnum');
 CL.AddConstantN('adParamSigned','LongWord').SetUInt( $00000010);
 CL.AddConstantN('adParamNullable','LongWord').SetUInt( $00000040);
 CL.AddConstantN('adParamLong','LongWord').SetUInt( $00000080);
  CL.AddTypeS('ParameterDirectionEnum', 'TOleEnum');
 CL.AddConstantN('adParamUnknown','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adParamInput','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adParamOutput','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adParamInputOutput','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adParamReturnValue','LongWord').SetUInt( $00000004);
  CL.AddTypeS('CommandTypeEnum', 'TOleEnum');
 CL.AddConstantN('adCmdUnspecified','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('adCmdUnknown','LongWord').SetUInt( $00000008);
 CL.AddConstantN('adCmdText','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adCmdTable','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adCmdStoredProc','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adCmdFile','LongWord').SetUInt( $00000100);
 CL.AddConstantN('adCmdTableDirect','LongWord').SetUInt( $00000200);
  CL.AddTypeS('EventStatusEnum', 'TOleEnum');
 CL.AddConstantN('adStatusOK','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adStatusErrorsOccurred','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adStatusCantDeny','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adStatusCancel','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adStatusUnwantedEvent','LongWord').SetUInt( $00000005);
  CL.AddTypeS('EventReasonEnum', 'TOleEnum');
 CL.AddConstantN('adRsnAddNew','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adRsnDelete','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adRsnUpdate','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adRsnUndoUpdate','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adRsnUndoAddNew','LongWord').SetUInt( $00000005);
 CL.AddConstantN('adRsnUndoDelete','LongWord').SetUInt( $00000006);
 CL.AddConstantN('adRsnRequery','LongWord').SetUInt( $00000007);
 CL.AddConstantN('adRsnResynch','LongWord').SetUInt( $00000008);
 CL.AddConstantN('adRsnClose','LongWord').SetUInt( $00000009);
 CL.AddConstantN('adRsnMove','LongWord').SetUInt( $0000000A);
 CL.AddConstantN('adRsnFirstChange','LongWord').SetUInt( $0000000B);
 CL.AddConstantN('adRsnMoveFirst','LongWord').SetUInt( $0000000C);
 CL.AddConstantN('adRsnMoveNext','LongWord').SetUInt( $0000000D);
 CL.AddConstantN('adRsnMovePrevious','LongWord').SetUInt( $0000000E);
 CL.AddConstantN('adRsnMoveLast','LongWord').SetUInt( $0000000F);
  CL.AddTypeS('SchemaEnum', 'TOleEnum');
 CL.AddConstantN('adSchemaProviderSpecific','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('adSchemaAsserts','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adSchemaCatalogs','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adSchemaCharacterSets','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adSchemaCollations','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adSchemaColumns','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adSchemaCheckConstraints','LongWord').SetUInt( $00000005);
 CL.AddConstantN('adSchemaConstraintColumnUsage','LongWord').SetUInt( $00000006);
 CL.AddConstantN('adSchemaConstraintTableUsage','LongWord').SetUInt( $00000007);
 CL.AddConstantN('adSchemaKeyColumnUsage','LongWord').SetUInt( $00000008);
 CL.AddConstantN('adSchemaReferentialConstraints','LongWord').SetUInt( $00000009);
 CL.AddConstantN('adSchemaTableConstraints','LongWord').SetUInt( $0000000A);
 CL.AddConstantN('adSchemaColumnsDomainUsage','LongWord').SetUInt( $0000000B);
 CL.AddConstantN('adSchemaIndexes','LongWord').SetUInt( $0000000C);
 CL.AddConstantN('adSchemaColumnPrivileges','LongWord').SetUInt( $0000000D);
 CL.AddConstantN('adSchemaTablePrivileges','LongWord').SetUInt( $0000000E);
 CL.AddConstantN('adSchemaUsagePrivileges','LongWord').SetUInt( $0000000F);
 CL.AddConstantN('adSchemaProcedures','LongWord').SetUInt( $00000010);
 CL.AddConstantN('adSchemaSchemata','LongWord').SetUInt( $00000011);
 CL.AddConstantN('adSchemaSQLLanguages','LongWord').SetUInt( $00000012);
 CL.AddConstantN('adSchemaStatistics','LongWord').SetUInt( $00000013);
 CL.AddConstantN('adSchemaTables','LongWord').SetUInt( $00000014);
 CL.AddConstantN('adSchemaTranslations','LongWord').SetUInt( $00000015);
 CL.AddConstantN('adSchemaProviderTypes','LongWord').SetUInt( $00000016);
 CL.AddConstantN('adSchemaViews','LongWord').SetUInt( $00000017);
 CL.AddConstantN('adSchemaViewColumnUsage','LongWord').SetUInt( $00000018);
 CL.AddConstantN('adSchemaViewTableUsage','LongWord').SetUInt( $00000019);
 CL.AddConstantN('adSchemaProcedureParameters','LongWord').SetUInt( $0000001A);
 CL.AddConstantN('adSchemaForeignKeys','LongWord').SetUInt( $0000001B);
 CL.AddConstantN('adSchemaPrimaryKeys','LongWord').SetUInt( $0000001C);
 CL.AddConstantN('adSchemaProcedureColumns','LongWord').SetUInt( $0000001D);
 CL.AddConstantN('adSchemaDBInfoKeywords','LongWord').SetUInt( $0000001E);
 CL.AddConstantN('adSchemaDBInfoLiterals','LongWord').SetUInt( $0000001F);
 CL.AddConstantN('adSchemaCubes','LongWord').SetUInt( $00000020);
 CL.AddConstantN('adSchemaDimensions','LongWord').SetUInt( $00000021);
 CL.AddConstantN('adSchemaHierarchies','LongWord').SetUInt( $00000022);
 CL.AddConstantN('adSchemaLevels','LongWord').SetUInt( $00000023);
 CL.AddConstantN('adSchemaMeasures','LongWord').SetUInt( $00000024);
 CL.AddConstantN('adSchemaProperties','LongWord').SetUInt( $00000025);
 CL.AddConstantN('adSchemaMembers','LongWord').SetUInt( $00000026);
 CL.AddConstantN('adSchemaTrustees','LongWord').SetUInt( $00000027);
  CL.AddTypeS('SeekEnum', 'TOleEnum');
 CL.AddConstantN('adSeekFirstEQ','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adSeekLastEQ','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adSeekAfterEQ','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adSeekAfter','LongWord').SetUInt( $00000008);
 CL.AddConstantN('adSeekBeforeEQ','LongWord').SetUInt( $00000010);
 CL.AddConstantN('adSeekBefore','LongWord').SetUInt( $00000020);
  CL.AddTypeS('ADCPROP_UPDATECRITERIA_ENUM', 'TOleEnum');
 CL.AddConstantN('adCriteriaKey','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adCriteriaAllCols','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adCriteriaUpdCols','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adCriteriaTimeStamp','LongWord').SetUInt( $00000003);
  CL.AddTypeS('ADCPROP_ASYNCTHREADPRIORITY_ENUM', 'TOleEnum');
 CL.AddConstantN('adPriorityLowest','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adPriorityBelowNormal','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adPriorityNormal','LongWord').SetUInt( $00000003);
 CL.AddConstantN('adPriorityAboveNormal','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adPriorityHighest','LongWord').SetUInt( $00000005);
  CL.AddTypeS('CEResyncEnum', 'TOleEnum');
 CL.AddConstantN('adResyncNone','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adResyncAutoIncrement','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adResyncConflicts','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adResyncUpdates','LongWord').SetUInt( $00000004);
 CL.AddConstantN('adResyncInserts','LongWord').SetUInt( $00000008);
 CL.AddConstantN('adResyncAll','LongWord').SetUInt( $0000000F);
  CL.AddTypeS('ADCPROP_AUTORECALC_ENUM', 'TOleEnum');
 CL.AddConstantN('adRecalcUpFront','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adRecalcAlways','LongWord').SetUInt( $00000001);
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),_Collection, '_Collection');
  //CL.AddTypeS('_CollectionDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),_DynaCollection, '_DynaCollection');
  //CL.AddTypeS('_DynaCollectionDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IDispatch'),_ADO, '_ADO');
  //CL.AddTypeS('_ADODisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),Properties, 'Properties');
  //CL.AddTypeS('PropertiesDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),Property_, 'Property_');
  //CL.AddTypeS('Property_Disp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),Error, 'Error');
  //CL.AddTypeS('ErrorDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),Errors, 'Errors');
  //CL.AddTypeS('ErrorsDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),Command15, 'Command15');
  //CL.AddTypeS('Command15Disp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),Connection15, 'Connection15');
  //CL.AddTypeS('Connection15Disp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),_Connection, '_Connection');
  //CL.AddTypeS('_ConnectionDisp', 'dispinterface');
   // CL.AddInterface(CL.FindInterface('IUNKNOWN'),Recordset15, 'Recordset15');

  CL.AddInterface(CL.FindInterface('_Ado'),Recordset15, 'Recordset15');
  //CL.AddTypeS('Recordset15Disp', 'dispinterface');
 // CL.AddInterface(CL.FindInterface('Recordset15'),IID_Recordset20, 'Recordset20');
   CL.AddInterface(CL.FindInterface('Recordset15'),Recordset20, 'Recordset20');

  //CL.AddTypeS('Recordset20Disp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('Recordset20'),_Recordset, '_Recordset');
  //CL.AddTypeS('_RecordsetDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),Fields15, 'Fields15');
  //CL.AddTypeS('Fields15Disp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),Fields, 'Fields');
  //CL.AddTypeS('FieldsDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),Field, 'Field');
  //CL.AddTypeS('FieldDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),_Parameter, '_Parameter');
  //CL.AddTypeS('_ParameterDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),Parameters, 'Parameters');
  //CL.AddTypeS('ParametersDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),_Command, '_Command');
  //CL.AddTypeS('_CommandDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ConnectionEventsVt, 'ConnectionEventsVt');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),RecordsetEventsVt, 'RecordsetEventsVt');
  //CL.AddTypeS('ConnectionEvents', 'dispinterface');
  //CL.AddTypeS('RecordsetEvents', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ADOConnectionConstruction15, 'ADOConnectionConstruction15');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ADOConnectionConstruction, 'ADOConnectionConstruction');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ADOCommandConstruction, 'ADOCommandConstruction');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ADORecordsetConstruction, 'ADORecordsetConstruction');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),Field15, 'Field15');
  //CL.AddTypeS('Field15Disp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDataspace, 'IDataspace');
  //CL.AddTypeS('IDataspaceDisp', 'dispinterface');
  CL.AddTypeS('Connection', '_Connection');
  CL.AddTypeS('Command', '_Command');
  CL.AddTypeS('Recordset', '_Recordset');
  CL.AddTypeS('Parameter', '_Parameter');
  CL.AddTypeS('DataSpace', 'IDataspace');
  CL.AddTypeS('SearchDirection', 'SearchDirectionEnum');
  SIRegister__Collection(CL);
  SIRegister__DynaCollection(CL);
  SIRegister__ADO(CL);
  SIRegister_Properties(CL);
  SIRegister_Property_(CL);
  SIRegister_Error(CL);
  SIRegister_Errors(CL);
  SIRegister_Command15(CL);
  SIRegister_Connection15(CL);
  SIRegister__Connection(CL);
  SIRegister_Recordset15(CL);
  SIRegister_Recordset20(CL);
  SIRegister__Recordset(CL);
  SIRegister_Fields15(CL);
  SIRegister_Fields(CL);
  SIRegister_Field(CL);
  SIRegister_Field15(CL);
  SIRegister__Parameter(CL);
  SIRegister_Parameters(CL);
  SIRegister__Command(CL);
  SIRegister_ConnectionEventsVt(CL);
  SIRegister_RecordsetEventsVt(CL);
  SIRegister_ADOConnectionConstruction15(CL);
  SIRegister_ADOConnectionConstruction(CL);
  SIRegister_ADOCommandConstruction(CL);
  SIRegister_ADORecordsetConstruction(CL);
  SIRegister_IDataspace(CL);
  SIRegister_CoConnection(CL);
  SIRegister_CoCommand(CL);
  SIRegister_CoRecordset(CL);
  SIRegister_CoParameter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_CoParameter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoParameter) do
  begin
    RegisterMethod(@CoParameter.Create, 'Create');
    RegisterMethod(@CoParameter.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoRecordset(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoRecordset) do
  begin
    RegisterMethod(@CoRecordset.Create, 'Create');
    RegisterMethod(@CoRecordset.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoCommand(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoCommand) do
  begin
    RegisterMethod(@CoCommand.Create, 'Create');
    RegisterMethod(@CoCommand.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoConnection) do
  begin
    RegisterMethod(@CoConnection.Create, 'Create');
    RegisterMethod(@CoConnection.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ADOInt(CL: TPSRuntimeClassImporter);
begin
  RIRegister_CoConnection(CL);
  RIRegister_CoCommand(CL);
  RIRegister_CoRecordset(CL);
  RIRegister_CoParameter(CL);
end;

 
 
{ TPSImport_ADOInt }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ADOInt.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ADOInt(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ADOInt.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ADOInt(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
