unit uPSI_ComObjOleDB_utils;
{
  a last package for COM OLE and ADO utilities with DB.const
  olesyserror of oleauto and comobj   autoobject of comobj not oleauto
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
  TPSImport_ComObj = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
   procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
                     //TAutoObject and EOLESysError in:
//check C:\maXbook\maxbox3\mX3999\maxbox3\source2\source\fundamentals_lib\uPSI_OleAuto.pas
 
  // difference!!
  //with RegClassS(CL,'EOleError', 'EOleSysError') do
 { with CL.AddClassN(CL.FindClass('EOleError'),'EOleSysError') do
  begin
    RegisterMethod('Constructor Create( const Message : string; ErrorCode : HRESULT; 

   in oleauto    RegisterMethod('Constructor Create( ErrorCode : Integer)');
    oleexception
      RegisterMethod('Constructor Create( const Message : string; ErrorCode : HRESULT; const Source, HelpFile : string; HelpContext : Integer)');
 
  }
 
{ compile-time registration functions }
procedure SIRegister_EOleException(CL: TPSPascalCompiler);
procedure SIRegister_EOleSysError(CL: TPSPascalCompiler);

procedure SIRegister_ADOConst(CL: TPSPascalCompiler);

procedure SIRegister_TAutoIntfObject(CL: TPSPascalCompiler);
procedure SIRegister_TAutoObjectFactory(CL: TPSPascalCompiler);
procedure SIRegister_TAutoObject(CL: TPSPascalCompiler);
procedure SIRegister_TTypedComObjectFactory(CL: TPSPascalCompiler);
procedure SIRegister_TTypedComObject(CL: TPSPascalCompiler);
procedure SIRegister_TComObjectFactory(CL: TPSPascalCompiler);
procedure SIRegister_TComObject(CL: TPSPascalCompiler);
procedure SIRegister_IServerExceptionHandler(CL: TPSPascalCompiler);
procedure SIRegister_TComClassManager(CL: TPSPascalCompiler);
procedure SIRegister_TComServerObject(CL: TPSPascalCompiler);
procedure SIRegister_ComObj2(CL: TPSPascalCompiler);

procedure SIRegister__Command(CL: TPSPascalCompiler);
procedure SIRegister__Recordset(CL: TPSPascalCompiler);


{ run-time registration functions }
procedure RIRegister_ComObj2_Routines(S: TPSExec);
procedure RIRegister_EOleException(CL: TPSRuntimeClassImporter);
procedure RIRegister_EOleSysError(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAutoIntfObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAutoObjectFactory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAutoObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTypedComObjectFactory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTypedComObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComObjectFactory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComClassManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComServerObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_ComObj2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,Windows
  ,ActiveX
  //,WinUtils
  ,ComObj
  //,DB
  ,OleDB
  ,ADOInt
  ,WideStrings
  ,ADODB;
  //ADOConst;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ComObj]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EOleException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EOleSysError', 'EOleException') do
  with CL.AddClassN(CL.FindClass('EOleSysError'),'EOleException') do begin
    RegisterMethod('Constructor Create( const Message : string; ErrorCode : HRESULT; const Source, HelpFile : string; HelpContext : Integer)');
    RegisterProperty('HelpFile', 'string', iptrw);
    RegisterProperty('Source', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EOleSysError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EOleError', 'EOleSysError') do
  with CL.AddClassN(CL.FindClass('EOleError'),'EOleSysError') do begin
    RegisterMethod('Constructor Create( const Message : string; ErrorCode : HRESULT; HelpContext : Integer)');
    RegisterProperty('ErrorCode', 'HRESULT', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAutoIntfObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TAutoIntfObject') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TAutoIntfObject') do begin
    RegisterMethod('Constructor Create(const TypeLib: ITypeLib; const DispIntf : TGUID)');
    RegisterProperty('DispIntfEntry', 'PInterfaceEntry', iptr);
    RegisterProperty('DispTypeInfo', 'ITypeInfo', iptr);
    RegisterProperty('DispIID', 'TGUID', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAutoObjectFactory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTypedComObjectFactory', 'TAutoObjectFactory') do
  with CL.AddClassN(CL.FindClass('TTypedComObjectFactory'),'TAutoObjectFactory') do begin
    RegisterMethod('Constructor Create( ComServer : TComServerObject; AutoClass : TAutoClass; const ClassID : TGUID; Instancing : TClassInstancing; ThreadingModel : TThreadingModel)');
    RegisterMethod('Function GetIntfEntry( Guid : TGUID) : PInterfaceEntry');
    RegisterProperty('DispIntfEntry', 'PInterfaceEntry', iptr);
    RegisterProperty('DispTypeInfo', 'ITypeInfo', iptr);
    RegisterProperty('EventIID', 'TGUID', iptr);
    RegisterProperty('EventTypeInfo', 'ITypeInfo', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAutoObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTypedComObject', 'TAutoObject') do
  with CL.AddClassN(CL.FindClass('TTypedComObject'),'TAutoObject') do begin
    RegisterMethod('procedure Initialize;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTypedComObjectFactory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComObjectFactory', 'TTypedComObjectFactory') do
  with CL.AddClassN(CL.FindClass('TComObjectFactory'),'TTypedComObjectFactory') do begin
    RegisterMethod('Constructor Create( ComServer : TComServerObject; TypedComClass : TTypedComClass; const ClassID : TGUID; Instancing : TClassInstancing; ThreadingModel : TThreadingModel)');
    RegisterMethod('Function GetInterfaceTypeInfo( TypeFlags : Integer) : ITypeInfo');
    // procedure UpdateRegistry(Register: Boolean); override;

    RegisterProperty('ClassInfo', 'ITypeInfo', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTypedComObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComObject', 'TTypedComObject') do
  with CL.AddClassN(CL.FindClass('TComObject'),'TTypedComObject') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComObjectFactory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TComObjectFactory') do
  with CL.AddClassN(CL.FindClass('TObject'),'TComObjectFactory') do begin
    RegisterMethod('Constructor Create( ComServer : TComServerObject; ComClass : TComClass; const ClassID : TGUID; const ClassName, Description : string; Instancing : TClassInstancing; ThreadingModel : TThreadingModel)');
     RegisterMethod('Procedure Free');
   // destructor Destroy; override;
    RegisterMethod('Function CreateComObject( const Controller : IUnknown) : TComObject');
    RegisterMethod('Procedure RegisterClassObject');
    RegisterMethod('Procedure UpdateRegistry( Register : Boolean)');
    RegisterProperty('ClassID', 'TGUID', iptr);
    RegisterProperty('ClassName', 'string', iptr);
    RegisterProperty('ComClass', 'TClass', iptr);
    RegisterProperty('ComServer', 'TComServerObject', iptr);
    RegisterProperty('Description', 'string', iptr);
    RegisterProperty('ErrorIID', 'TGUID', iptrw);
    RegisterProperty('LicString', 'WideString', iptrw);
    RegisterProperty('ProgID', 'string', iptr);
    RegisterProperty('Instancing', 'TClassInstancing', iptr);
    RegisterProperty('ShowErrors', 'Boolean', iptrw);
    RegisterProperty('SupportsLicensing', 'Boolean', iptrw);
    RegisterProperty('ThreadingModel', 'TThreadingModel', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TComObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'TComObject') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Constructor CreateAggregated( const Controller : IUnknown)');
    RegisterMethod('Constructor CreateFromFactory( Factory : TComObjectFactory; const Controller : IUnknown)');
   //   destructor Destroy; override;
      RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Initialize');
    RegisterMethod('Function ObjAddRef : Integer');
    RegisterMethod('Function ObjQueryInterface( const IID : TGUID; out Obj) : HResult');
    RegisterMethod('Function ObjRelease : Integer');
    RegisterProperty('Controller', 'IUnknown', iptr);
    RegisterProperty('Factory', 'TComObjectFactory', iptr);
    RegisterProperty('RefCount', 'Integer', iptr);
    RegisterProperty('ServerExceptionHandler', 'IServerExceptionHandler', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IServerExceptionHandler(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IServerExceptionHandler') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IServerExceptionHandler, 'IServerExceptionHandler') do begin
    RegisterMethod('Procedure OnException( const ServerClass, ExceptionClass, ErrorMessage : WideString; ExceptAddr : Integer; const ErrorIID, ProgID : WideString; var Handled : Integer; var Result : HResult)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComClassManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TComClassManager') do
  with CL.AddClassN(CL.FindClass('TObject'),'TComClassManager') do begin
    RegisterMethod('Constructor Create');
    //  destructor Destroy; override;
   RegisterMethod('Procedure Free');
  RegisterMethod('Procedure ForEachFactory(ComServer : TComServerObject; FactoryProc : TFactoryProc)');
    RegisterMethod('Function GetFactoryFromClass( ComClass : TClass) : TComObjectFactory');
    RegisterMethod('Function GetFactoryFromClassID(const ClassID : TGUID): TComObjectFactory');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComServerObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TComServerObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'TComServerObject') do begin
    RegisterProperty('HelpFileName', 'string', iptrw);
    RegisterProperty('ServerFileName', 'string', iptr);
    RegisterProperty('ServerKey', 'string', iptr);
    RegisterProperty('ServerName', 'string', iptr);
    RegisterProperty('TypeLib', 'ITypeLib', iptr);
    RegisterProperty('StartSuspended', 'Boolean', iptr);
  end;
end;


procedure SIRegister__Command(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'Command15', '_Command') do
  with CL.AddInterface(CL.FindInterface('Command15'),_Command, '_Command') do begin
    RegisterMethod('Function Get_State : Integer', CdStdCall);
    RegisterMethod('Procedure Cancel', CdStdCall);
  end;
end;

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



procedure SIRegister_ADOConst(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SInvalidEnumValue','String').SetString( 'Invalid Enum Value');
 CL.AddConstantN('SMissingConnection','String').SetString( 'Missing Connection or ConnectionString');
 CL.AddConstantN('SNoDetailFilter','String').SetString( 'Filter property cannot be used for detail tables');
 CL.AddConstantN('SBookmarksRequired','String').SetString( 'Dataset does not support bookmarks, which are required for multi-record data controls');
 CL.AddConstantN('SMissingCommandText','String').SetString( 'Missing %s property');
 CL.AddConstantN('SNoResultSet','String').SetString('CommandText does not return a result set');
 CL.AddConstantN('SADOCreateError','String').SetString( 'Error creating object.  Please verify that the Microsoft Data Access Components 2.1 (or later) have been properly installed');
 CL.AddConstantN('SEventsNotSupported','String').SetString( 'Events are not supported with server side TableDirect cursors');
 CL.AddConstantN('SUsupportedFieldType','String').SetString('Unsupported field type (%s) in field %s');
 CL.AddConstantN('SNoMatchingADOType','String').SetString( 'No matching ADO data type for %s');
 CL.AddConstantN('SConnectionRequired','String').SetString( 'A connection component is required for async ExecuteOptions');
 CL.AddConstantN('SCantRequery','String').SetString( 'Cannot perform a requery after connection has changed');
 CL.AddConstantN('SNoFilterOptions','String').SetString('FilterOptions are not supported');
 CL.AddConstantN('SRecordsetNotOpen','String').SetString( 'Recordset is not open');
 CL.AddConstantN('sNameAttr','String').SetString( 'Name');
 CL.AddConstantN('sValueAttr','String').SetString( 'Value');
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_ComObj2(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TComObjectFactory');
  SIRegister_TComServerObject(CL);
  
   SIRegister_ADOConst(CL);
   
  { FieldTypeNames: array[0..41] of string = (
    'Unknown', 'String', 'SmallInt', 'Integer', 'Word', 'Boolean', 'Float',
    'Currency', 'BCD', 'Date', 'Time', 'DateTime', 'Bytes', 'VarBytes',
    'AutoInc', 'Blob', 'Memo', 'Graphic', 'FmtMemo', 'ParadoxOle',
    'dBaseOle', 'TypedBinary', 'Cursor', 'FixedChar', 'WideString',
    'LargeInt', 'ADT', 'Array', 'Reference', 'DataSet', 'HugeBlob', 'HugeClob',
    'Variant', 'Interface', 'Dispatch', 'Guid', 'SQLTimeStamp', 'FMTBcdField',
    'FixedWideChar', 'WideMemo', 'SQLTimeStamp', 'String');
   }
   
  CL.AddTypeS('TFactoryProc', 'Procedure (Factory : TComObjectFactory)');

  CL.AddTypeS('TCallingConvention','(ccRegister, ccCdecl, ccPascal, ccStdCall, ccSafeCall)');

  
  SIRegister_TComClassManager(CL);
  
  
  SIRegister_IServerExceptionHandler(CL);
  SIRegister_TComObject(CL);
  //CL.AddTypeS('TComClass', 'class of TComObject');
  CL.AddTypeS('TClassInstancing', '(ciInternal,ciSingleInstance,ciMultiInstance )');
  CL.AddTypeS('TThreadingModel', '(tmSingle, tmApartment, tmFree, tmBoth, tmNeutral )');
  SIRegister_TComObjectFactory(CL);
  SIRegister_TTypedComObject(CL);
  //CL.AddTypeS('TTypedComClass', 'class of TTypedComObject');
  SIRegister_TTypedComObjectFactory(CL);
  CL.AddTypeS('TConnectEvent2','Procedure(const Sink : IUnknown; Connecting : Boolean)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAutoObjectFactory');
  SIRegister_TAutoObject(CL);
  //TAutoObject2  ??
  //CL.AddTypeS('TAutoClass', 'class of TAutoObject');
  SIRegister_TAutoObjectFactory(CL);
  SIRegister_TAutoIntfObject(CL);
  //CL.AddClassN(CL.FindClass('TOBJECT'),'EOleError');
  CL.AddClassN(CL.FindClass('Exception'),'EOleError');
  SIRegister_EOleSysError(CL);
  SIRegister_EOleException(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EOleRegistrationError');
 //CL.AddDelphiFunction('Procedure DispatchInvoke( const Dispatch : IDispatch; CallDesc : PCallDesc; DispIDs : PDispIDList; Params : Pointer; Result : PVariant)');
 //CL.AddDelphiFunction('Procedure DispatchInvokeError( Status : Integer; const ExcepInfo : TExcepInfo)');
 //CL.AddDelphiFunction('Function HandleSafeCallException( ExceptObject : TObject; ExceptAddr : Pointer; const ErrorIID : TGUID; const ProgID, HelpFileName : WideString) : HResult');
 
 CL.AddDelphiFunction('Function CreateComObject( const ClassID : TGUID) : IUnknown');
 CL.AddDelphiFunction('Function CreateRemoteComObject( const MachineName : WideString; const ClassID : TGUID) : IUnknown');
 //CL.AddDelphiFunction('Function CreateOleObject(const ClassName : string): IDispatch');
 //CL.AddDelphiFunction('Function GetActiveOleObject(const ClassName:string): IDispatch');
 CL.AddDelphiFunction('Procedure OleError2( ErrorCode : HResult)');
 CL.AddDelphiFunction('Procedure OleCheck2( Result : HResult)');
 CL.AddDelphiFunction('Function StringToGUID2( const S : string) : TGUID');
 CL.AddDelphiFunction('Function GUIDToString2( const ClassID : TGUID) : string');
 CL.AddDelphiFunction('Function ProgIDToClassID2( const ProgID : string) : TGUID');
 CL.AddDelphiFunction('Function ClassIDToProgID2( const ClassID : TGUID) : string');
 CL.AddDelphiFunction('Procedure CreateRegKey(const Key,ValueName,Value:string;RootKey:DWord)');
 CL.AddDelphiFunction('Procedure DeleteRegKey(const Key : string; RootKey : DWord)');
 CL.AddDelphiFunction('Function GetRegStringValue( const Key, ValueName : string; RootKey : DWord) : string');
 //CL.AddDelphiFunction('Function StringToLPOLESTR( const Source : string) : POleStr');
 CL.AddDelphiFunction('Procedure RegisterComServer( const DLLName : string)');
 CL.AddDelphiFunction('Procedure RegisterAsService( const ClassID, ServiceName : string)');
 CL.AddDelphiFunction('Function CreateClassID2 : string');
 CL.AddDelphiFunction('Procedure InterfaceConnect( const Source : IUnknown; const IID : TIID; const Sink : IUnknown; var Connection : Longint)');
 CL.AddDelphiFunction('Procedure InterfaceDisconnect( const Source : IUnknown; const IID : TIID; var Connection : Longint)');
 CL.AddDelphiFunction('Function GetDispatchPropValue(Disp: IDispatch; DispID : Integer) : OleVariant;');
 CL.AddDelphiFunction('Function GetDispatchPropValue1(Disp: IDispatch; Name : WideString) : OleVariant;');
 CL.AddDelphiFunction('Procedure SetDispatchPropValue2(Disp: IDispatch; DispID : Integer; const Value : OleVariant);');
 CL.AddDelphiFunction('Procedure SetDispatchPropValue3(Disp: IDispatch; Name : WideString; const Value : OleVariant);');
 CL.AddDelphiFunction('Function ComClassManager : TComClassManager');
 CL.AddDelphiFunction('function CoInitialize(pvReserved: TObject): HResult;');
 CL.AddDelphiFunction('function CoUnInitialize(pvReserved: TObject): HResult;');
 CL.AddDelphiFunction('function CoBuildVersion: Longint;');

 //procedure CoUninitialize; stdcall;
 //function CoBuildVersion: Longint; stdcall;
//function CoInitialize(pvReserved: Pointer): HResult; stdcall;


 //  from ADODB OLE Utils

  CL.AddTypeS('TOleEnum', 'LongWord');
  
//  type
  //DataTypeEnum = TOleEnum;
  CL.AddTypeS('DataTypeEnum', 'TOleEnum');

 
 CL.AddDelphiFunction('Function CreateADOObject( const ClassID : TGUID) : IUnknown');
 CL.AddDelphiFunction('Function ADOTypeToFieldType( const ADOType : DataTypeEnum; EnableBCD : Boolean) : TFieldType');
 CL.AddDelphiFunction('Function FieldTypeToADOType(const FieldType: TFieldType):DataTypeEnum');
 CL.AddDelphiFunction('Function StringToVarArray( const Value : string) : OleVariant');
 CL.AddDelphiFunction('Function VarDataSize( const Value : OleVariant) : Integer');
 CL.AddDelphiFunction('Function OleEnumToOrd( OleEnumArray : array of TOleEnum; Value : TOleEnum) : Integer');
 CL.AddDelphiFunction('Function GetStates( State : Integer) : TObjectStates');
 CL.AddDelphiFunction('Function ExecuteOptionsToOrd(ExecuteOptions:TExecuteOptions): Integer');
 CL.AddDelphiFunction('Function OrdToExecuteOptions(Options: Integer) : TExecuteOptions');
 CL.AddDelphiFunction('Function ExtractFieldNameWide( const Fields : WideString; var Pos : Integer) : WideString');
 CL.AddDelphiFunction('Function GetFilterStr( Field : TField; Value : Variant; Partial : Boolean) : WideString');
 CL.AddDelphiFunction('Function FieldListCheckSum( DataSet : TDataset) : Integer');

 //from ADOInt.pas

     //  TOleEnum = type LongWord;
  CL.AddTypeS('CursorOptionEnum', 'TOleEnum');


  CL.AddInterface(CL.FindInterface('IUNKNOWN'),_Recordset, '_Recordset');
  //CL.AddTypeS('_RecordsetDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),_Command, '_Command');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),_Connection, '_Connection');


 // SIRegister__Recordset(CL);
 // SIRegister__Command(CL);


  CL.AddConstantN('IID_Recordset20','string').SetString('{0000054F-0000-0010-8000-00AA006D2EA4}'']');
 CL.AddConstantN('IID__Recordset','string').SetString( '00000555-0000-0010-8000-00AA006D2EA4');
                 //test with stringtiGUID
 //7 CL.AddConstantN('CLASS_Command','TGUID').SetString( '{00000507-0000-0010-8000-00AA006D2EA4}');
// CL.AddConstantN('CLASS_Recordset','TGUID').SetString( '{00000535-0000-0010-8000-00AA006D2EA4}');

 { CL.AddTypeS('Connection', '_Connection');
  CL.AddTypeS('Command', '_Command');
  CL.AddTypeS('Recordset', '_Recordset');
  CL.AddTypeS('Parameter', '_Parameter');
  CL.AddTypeS('DataSpace', 'IDataspace');
  CL.AddTypeS('SearchDirection', 'SearchDirectionEnum');
  }

  //CL.AddTypeS('Command', '_Command');
  //CL.AddTypeS('Recordset', '_Recordset');


 CL.AddConstantN('CT_USERID','String').SetString( 'USER ID=');
 CL.AddConstantN('CT_PROVIDER','String').SetString( 'PROVIDER=');
 CL.AddConstantN('CT_FILENAME','String').SetString( 'FILE NAME=');
  //CL.AddTypeS('CursorTypeEnum', 'TOleEnum');
 CL.AddConstantN('adOpenUnspecified','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('adOpenForwardOnly','LongWord').SetUInt( $00000000);
 CL.AddConstantN('adOpenKeyset','LongWord').SetUInt( $00000001);
 CL.AddConstantN('adOpenDynamic','LongWord').SetUInt( $00000002);
 CL.AddConstantN('adOpenStatic','LongWord').SetUInt( $00000003);
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


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure SetDispatchPropValue3_P( Disp : IDispatch; Name : WideString; const Value : OleVariant);
Begin ComObj.SetDispatchPropValue(Disp, Name, Value); END;

(*----------------------------------------------------------------------------*)
Procedure SetDispatchPropValue2_P( Disp : IDispatch; DispID : Integer; const Value : OleVariant);
Begin ComObj.SetDispatchPropValue(Disp, DispID, Value); END;

(*----------------------------------------------------------------------------*)
Function GetDispatchPropValue1_P( Disp : IDispatch; Name : WideString) : OleVariant;
Begin Result := ComObj.GetDispatchPropValue(Disp, Name); END;

(*----------------------------------------------------------------------------*)
Function GetDispatchPropValue_P( Disp : IDispatch; DispID : Integer) : OleVariant;
Begin Result := ComObj.GetDispatchPropValue(Disp, DispID); END;

(*----------------------------------------------------------------------------*)
procedure EOleExceptionSource_W(Self: EOleException; const T: string);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure EOleExceptionSource_R(Self: EOleException; var T: string);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure EOleExceptionHelpFile_W(Self: EOleException; const T: string);
begin Self.HelpFile := T; end;

(*----------------------------------------------------------------------------*)
procedure EOleExceptionHelpFile_R(Self: EOleException; var T: string);
begin T := Self.HelpFile; end;

(*----------------------------------------------------------------------------*)
procedure EOleSysErrorErrorCode_W(Self: EOleSysError; const T: HRESULT);
begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure EOleSysErrorErrorCode_R(Self: EOleSysError; var T: HRESULT);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TAutoIntfObjectDispIID_R(Self: TAutoIntfObject; var T: TGUID);
begin T := Self.DispIID; end;

(*----------------------------------------------------------------------------*)
procedure TAutoIntfObjectDispTypeInfo_R(Self: TAutoIntfObject; var T: ITypeInfo);
begin T := Self.DispTypeInfo; end;

(*----------------------------------------------------------------------------*)
procedure TAutoIntfObjectDispIntfEntry_R(Self: TAutoIntfObject; var T: PInterfaceEntry);
begin T := Self.DispIntfEntry; end;

(*----------------------------------------------------------------------------*)
procedure TAutoObjectFactoryEventTypeInfo_R(Self: TAutoObjectFactory; var T: ITypeInfo);
begin T := Self.EventTypeInfo; end;

(*----------------------------------------------------------------------------*)
procedure TAutoObjectFactoryEventIID_R(Self: TAutoObjectFactory; var T: TGUID);
begin T := Self.EventIID; end;

(*----------------------------------------------------------------------------*)
procedure TAutoObjectFactoryDispTypeInfo_R(Self: TAutoObjectFactory; var T: ITypeInfo);
begin T := Self.DispTypeInfo; end;

(*----------------------------------------------------------------------------*)
procedure TAutoObjectFactoryDispIntfEntry_R(Self: TAutoObjectFactory; var T: PInterfaceEntry);
begin T := Self.DispIntfEntry; end;

(*----------------------------------------------------------------------------*)
procedure TTypedComObjectFactoryClassInfo_R(Self: TTypedComObjectFactory; var T: ITypeInfo);
begin T := Self.ClassInfo; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryThreadingModel_R(Self: TComObjectFactory; var T: TThreadingModel);
begin T := Self.ThreadingModel; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactorySupportsLicensing_W(Self: TComObjectFactory; const T: Boolean);
begin Self.SupportsLicensing := T; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactorySupportsLicensing_R(Self: TComObjectFactory; var T: Boolean);
begin T := Self.SupportsLicensing; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryShowErrors_W(Self: TComObjectFactory; const T: Boolean);
begin Self.ShowErrors := T; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryShowErrors_R(Self: TComObjectFactory; var T: Boolean);
begin T := Self.ShowErrors; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryInstancing_R(Self: TComObjectFactory; var T: TClassInstancing);
begin T := Self.Instancing; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryProgID_R(Self: TComObjectFactory; var T: string);
begin T := Self.ProgID; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryLicString_W(Self: TComObjectFactory; const T: WideString);
begin Self.LicString := T; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryLicString_R(Self: TComObjectFactory; var T: WideString);
begin T := Self.LicString; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryErrorIID_W(Self: TComObjectFactory; const T: TGUID);
begin Self.ErrorIID := T; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryErrorIID_R(Self: TComObjectFactory; var T: TGUID);
begin T := Self.ErrorIID; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryDescription_R(Self: TComObjectFactory; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryComServer_R(Self: TComObjectFactory; var T: TComServerObject);
begin T := Self.ComServer; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryComClass_R(Self: TComObjectFactory; var T: TClass);
begin T := Self.ComClass; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryClassName_R(Self: TComObjectFactory; var T: string);
begin T := Self.ClassName; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactoryClassID_R(Self: TComObjectFactory; var T: TGUID);
begin T := Self.ClassID; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectServerExceptionHandler_W(Self: TComObject; const T: IServerExceptionHandler);
begin Self.ServerExceptionHandler := T; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectServerExceptionHandler_R(Self: TComObject; var T: IServerExceptionHandler);
begin T := Self.ServerExceptionHandler; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectRefCount_R(Self: TComObject; var T: Integer);
begin T := Self.RefCount; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectFactory_R(Self: TComObject; var T: TComObjectFactory);
begin T := Self.Factory; end;

(*----------------------------------------------------------------------------*)
procedure TComObjectController_R(Self: TComObject; var T: IUnknown);
begin T := Self.Controller; end;

(*----------------------------------------------------------------------------*)
procedure TComServerObjectStartSuspended_R(Self: TComServerObject; var T: Boolean);
begin T := Self.StartSuspended; end;

(*----------------------------------------------------------------------------*)
procedure TComServerObjectTypeLib_R(Self: TComServerObject; var T: ITypeLib);
begin T := Self.TypeLib; end;

(*----------------------------------------------------------------------------*)
procedure TComServerObjectServerName_R(Self: TComServerObject; var T: string);
begin T := Self.ServerName; end;

(*----------------------------------------------------------------------------*)
procedure TComServerObjectServerKey_R(Self: TComServerObject; var T: string);
begin T := Self.ServerKey; end;

(*----------------------------------------------------------------------------*)
procedure TComServerObjectServerFileName_R(Self: TComServerObject; var T: string);
begin T := Self.ServerFileName; end;

(*----------------------------------------------------------------------------*)
procedure TComServerObjectHelpFileName_W(Self: TComServerObject; const T: string);
begin Self.HelpFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TComServerObjectHelpFileName_R(Self: TComServerObject; var T: string);
begin T := Self.HelpFileName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ComObj2_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@DispatchInvoke, 'DispatchInvoke', cdRegister);
 //S.RegisterDelphiFunction(@DispatchInvokeError, 'DispatchInvokeError', cdRegister);
 //S.RegisterDelphiFunction(@HandleSafeCallException,'HandleSafeCallException', cdRegister);
 S.RegisterDelphiFunction(@CreateComObject, 'CreateComObject', cdRegister);
 S.RegisterDelphiFunction(@CreateRemoteComObject, 'CreateRemoteComObject', cdRegister);
 //S.RegisterDelphiFunction(@CreateOleObject, 'CreateOleObject', cdRegister);
 //S.RegisterDelphiFunction(@GetActiveOleObject, 'GetActiveOleObject', cdRegister);
 S.RegisterDelphiFunction(@OleError, 'OleError2', cdRegister);
 S.RegisterDelphiFunction(@OleCheck, 'OleCheck2', cdRegister);
 S.RegisterDelphiFunction(@StringToGUID, 'StringToGUID2', cdRegister);
 S.RegisterDelphiFunction(@GUIDToString, 'GUIDToString2', cdRegister);
 S.RegisterDelphiFunction(@ProgIDToClassID, 'ProgIDToClassID2', cdRegister);
 S.RegisterDelphiFunction(@ClassIDToProgID, 'ClassIDToProgID2', cdRegister);
 S.RegisterDelphiFunction(@CreateRegKey, 'CreateRegKey', cdRegister);
 S.RegisterDelphiFunction(@DeleteRegKey, 'DeleteRegKey', cdRegister);
 S.RegisterDelphiFunction(@GetRegStringValue, 'GetRegStringValue', cdRegister);
 //S.RegisterDelphiFunction(@StringToLPOLESTR, 'StringToLPOLESTR', cdRegister);
 S.RegisterDelphiFunction(@RegisterComServer, 'RegisterComServer', cdRegister);
 S.RegisterDelphiFunction(@RegisterAsService, 'RegisterAsService', cdRegister);
 S.RegisterDelphiFunction(@CreateClassID, 'CreateClassID2', cdRegister);
 S.RegisterDelphiFunction(@InterfaceConnect, 'InterfaceConnect', cdRegister);
 S.RegisterDelphiFunction(@InterfaceDisconnect, 'InterfaceDisconnect', cdRegister);
 S.RegisterDelphiFunction(@GetDispatchPropValue, 'GetDispatchPropValue', cdRegister);
 S.RegisterDelphiFunction(@GetDispatchPropValue1_P, 'GetDispatchPropValue1', cdRegister);
 S.RegisterDelphiFunction(@SetDispatchPropValue2_P, 'SetDispatchPropValue2', cdRegister);
 S.RegisterDelphiFunction(@SetDispatchPropValue3_P, 'SetDispatchPropValue3', cdRegister);
 S.RegisterDelphiFunction(@ComClassManager, 'ComClassManager', cdRegister);

  S.RegisterDelphiFunction(@CreateADOObject, 'CreateADOObject', cdRegister);
 S.RegisterDelphiFunction(@ADOTypeToFieldType, 'ADOTypeToFieldType', cdRegister);
 S.RegisterDelphiFunction(@FieldTypeToADOType, 'FieldTypeToADOType', cdRegister);
 S.RegisterDelphiFunction(@StringToVarArray, 'StringToVarArray', cdRegister);
 S.RegisterDelphiFunction(@VarDataSize, 'VarDataSize', cdRegister);
 S.RegisterDelphiFunction(@OleEnumToOrd, 'OleEnumToOrd', cdRegister);
 S.RegisterDelphiFunction(@GetStates, 'GetStates', cdRegister);
 S.RegisterDelphiFunction(@ExecuteOptionsToOrd, 'ExecuteOptionsToOrd', cdRegister);
 S.RegisterDelphiFunction(@OrdToExecuteOptions, 'OrdToExecuteOptions', cdRegister);
 S.RegisterDelphiFunction(@ExtractFieldName, 'ExtractFieldNameWide', cdRegister);
 S.RegisterDelphiFunction(@GetFilterStr, 'GetFilterStr', cdRegister);
 S.RegisterDelphiFunction(@FieldListCheckSum, 'FieldListCheckSum', cdRegister);
 S.RegisterDelphiFunction(@CoInitialize, 'CoInitialize', cdRegister);
 S.RegisterDelphiFunction(@CoUnInitialize, 'CoUnInitialize', cdRegister);
 S.RegisterDelphiFunction(@CoBuildVersion, 'CoBuildVersion', cdRegister);

 
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EOleException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EOleException) do begin
    RegisterConstructor(@EOleException.Create, 'Create');
    RegisterPropertyHelper(@EOleExceptionHelpFile_R,@EOleExceptionHelpFile_W,'HelpFile');
    RegisterPropertyHelper(@EOleExceptionSource_R,@EOleExceptionSource_W,'Source');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EOleSysError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EOleSysError) do begin
    RegisterConstructor(@EOleSysError.Create, 'Create');
    RegisterPropertyHelper(@EOleSysErrorErrorCode_R,@EOleSysErrorErrorCode_W,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAutoIntfObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAutoIntfObject) do
  begin
    RegisterConstructor(@TAutoIntfObject.Create, 'Create');
    RegisterPropertyHelper(@TAutoIntfObjectDispIntfEntry_R,nil,'DispIntfEntry');
    RegisterPropertyHelper(@TAutoIntfObjectDispTypeInfo_R,nil,'DispTypeInfo');
    RegisterPropertyHelper(@TAutoIntfObjectDispIID_R,nil,'DispIID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAutoObjectFactory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAutoObjectFactory) do begin
    RegisterConstructor(@TAutoObjectFactory.Create, 'Create');
    RegisterVirtualMethod(@TAutoObjectFactory.GetIntfEntry, 'GetIntfEntry');
    RegisterPropertyHelper(@TAutoObjectFactoryDispIntfEntry_R,nil,'DispIntfEntry');
    RegisterPropertyHelper(@TAutoObjectFactoryDispTypeInfo_R,nil,'DispTypeInfo');
    RegisterPropertyHelper(@TAutoObjectFactoryEventIID_R,nil,'EventIID');
    RegisterPropertyHelper(@TAutoObjectFactoryEventTypeInfo_R,nil,'EventTypeInfo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAutoObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAutoObject) do begin
    RegisterMethod(@TAutoObject.initialize, 'Initialize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTypedComObjectFactory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTypedComObjectFactory) do
  begin
    RegisterConstructor(@TTypedComObjectFactory.Create, 'Create');
    RegisterMethod(@TTypedComObjectFactory.GetInterfaceTypeInfo, 'GetInterfaceTypeInfo');
    RegisterPropertyHelper(@TTypedComObjectFactoryClassInfo_R,nil,'ClassInfo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTypedComObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTypedComObject) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComObjectFactory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComObjectFactory) do begin
    RegisterConstructor(@TComObjectFactory.Create, 'Create');
       RegisterMethod(@TComObjectFactory.Destroy, 'Free');

    RegisterVirtualMethod(@TComObjectFactory.CreateComObject, 'CreateComObject');
    RegisterMethod(@TComObjectFactory.RegisterClassObject, 'RegisterClassObject');
    RegisterVirtualMethod(@TComObjectFactory.UpdateRegistry, 'UpdateRegistry');
    RegisterPropertyHelper(@TComObjectFactoryClassID_R,nil,'ClassID');
    RegisterPropertyHelper(@TComObjectFactoryClassName_R,nil,'ClassName');
    RegisterPropertyHelper(@TComObjectFactoryComClass_R,nil,'ComClass');
    RegisterPropertyHelper(@TComObjectFactoryComServer_R,nil,'ComServer');
    RegisterPropertyHelper(@TComObjectFactoryDescription_R,nil,'Description');
    RegisterPropertyHelper(@TComObjectFactoryErrorIID_R,@TComObjectFactoryErrorIID_W,'ErrorIID');
    RegisterPropertyHelper(@TComObjectFactoryLicString_R,@TComObjectFactoryLicString_W,'LicString');
    RegisterPropertyHelper(@TComObjectFactoryProgID_R,nil,'ProgID');
    RegisterPropertyHelper(@TComObjectFactoryInstancing_R,nil,'Instancing');
    RegisterPropertyHelper(@TComObjectFactoryShowErrors_R,@TComObjectFactoryShowErrors_W,'ShowErrors');
    RegisterPropertyHelper(@TComObjectFactorySupportsLicensing_R,@TComObjectFactorySupportsLicensing_W,'SupportsLicensing');
    RegisterPropertyHelper(@TComObjectFactoryThreadingModel_R,nil,'ThreadingModel');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComObject) do begin
    RegisterConstructor(@TComObject.Create, 'Create');
       RegisterMethod(@TComObject.Destroy, 'Free');
    RegisterConstructor(@TComObject.CreateAggregated, 'CreateAggregated');
    RegisterConstructor(@TComObject.CreateFromFactory, 'CreateFromFactory');
    RegisterVirtualMethod(@TComObject.Initialize, 'Initialize');
    RegisterVirtualMethod(@TComObject.ObjAddRef, 'ObjAddRef');
    RegisterVirtualMethod(@TComObject.ObjQueryInterface, 'ObjQueryInterface');
    RegisterVirtualMethod(@TComObject.ObjRelease, 'ObjRelease');
    RegisterPropertyHelper(@TComObjectController_R,nil,'Controller');
    RegisterPropertyHelper(@TComObjectFactory_R,nil,'Factory');
    RegisterPropertyHelper(@TComObjectRefCount_R,nil,'RefCount');
    RegisterPropertyHelper(@TComObjectServerExceptionHandler_R,@TComObjectServerExceptionHandler_W,'ServerExceptionHandler');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComClassManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComClassManager) do begin
    RegisterConstructor(@TComClassManager.Create, 'Create');
       RegisterMethod(@TComClassManager.Destroy, 'Free');
    RegisterMethod(@TComClassManager.ForEachFactory, 'ForEachFactory');
    RegisterMethod(@TComClassManager.GetFactoryFromClass, 'GetFactoryFromClass');
    RegisterMethod(@TComClassManager.GetFactoryFromClassID, 'GetFactoryFromClassID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComServerObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComServerObject) do begin
    RegisterPropertyHelper(@TComServerObjectHelpFileName_R,@TComServerObjectHelpFileName_W,'HelpFileName');
    RegisterPropertyHelper(@TComServerObjectServerFileName_R,nil,'ServerFileName');
    RegisterPropertyHelper(@TComServerObjectServerKey_R,nil,'ServerKey');
    RegisterPropertyHelper(@TComServerObjectServerName_R,nil,'ServerName');
    RegisterPropertyHelper(@TComServerObjectTypeLib_R,nil,'TypeLib');
    RegisterPropertyHelper(@TComServerObjectStartSuspended_R,nil,'StartSuspended');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ComObj2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComObjectFactory) do
  RIRegister_TComServerObject(CL);
  RIRegister_TComClassManager(CL);
  RIRegister_TComObject(CL);
  RIRegister_TComObjectFactory(CL);
  RIRegister_TTypedComObject(CL);
  RIRegister_TTypedComObjectFactory(CL);
  with CL.Add(TAutoObjectFactory) do
  RIRegister_TAutoObject(CL);
  RIRegister_TAutoObjectFactory(CL);
  RIRegister_TAutoIntfObject(CL);
  with CL.Add(EOleError) do
    RIRegister_EOleSysError(CL);
   RIRegister_EOleException(CL);
  with CL.Add(EOleRegistrationError) do
end;

 
 
{ TPSImport_ComObj }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ComObj.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ComObj2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ComObj.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ComObj2(ri);
  RIRegister_ComObj2_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
