unit uPSI_ComObj;
{
  a last package for COM OLE and ADO utilities
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
 
 
{ compile-time registration functions }
procedure SIRegister_EOleException(CL: TPSPascalCompiler);
procedure SIRegister_EOleSysError(CL: TPSPascalCompiler);
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
procedure SIRegister_ComObj(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ComObj_Routines(S: TPSExec);
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
procedure RIRegister_ComObj(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,Windows
  ,ActiveX
  ,WinUtils
  ,ComObj
  //,DB
  ,OleDB
  ,ADOInt
  ,WideStrings
  ,ADODB
   ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ComObj]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EOleException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EOleSysError', 'EOleException') do
  with CL.AddClassN(CL.FindClass('EOleSysError'),'EOleException') do
  begin
    RegisterMethod('Constructor Create( const Message : string; ErrorCode : HRESULT; const Source, HelpFile : string; HelpContext : Integer)');
    RegisterProperty('HelpFile', 'string', iptrw);
    RegisterProperty('Source', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EOleSysError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EOleError', 'EOleSysError') do
  with CL.AddClassN(CL.FindClass('EOleError'),'EOleSysError') do
  begin
    RegisterMethod('Constructor Create( const Message : string; ErrorCode : HRESULT; HelpContext : Integer)');
    RegisterProperty('ErrorCode', 'HRESULT', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAutoIntfObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TAutoIntfObject') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TAutoIntfObject') do
  begin
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
  with CL.AddClassN(CL.FindClass('TTypedComObjectFactory'),'TAutoObjectFactory') do
  begin
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
    // procedure Initialize; override;
 
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTypedComObjectFactory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComObjectFactory', 'TTypedComObjectFactory') do
  with CL.AddClassN(CL.FindClass('TComObjectFactory'),'TTypedComObjectFactory') do
  begin
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
  with CL.AddClassN(CL.FindClass('TObject'),'TComObjectFactory') do
  begin
    RegisterMethod('Constructor Create( ComServer : TComServerObject; ComClass : TComClass; const ClassID : TGUID; const ClassName, Description : string; Instancing : TClassInstancing; ThreadingModel : TThreadingModel)');
  
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
  with CL.AddClassN(CL.FindClass('TObject'),'TComObject') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Constructor CreateAggregated( const Controller : IUnknown)');
    RegisterMethod('Constructor CreateFromFactory( Factory : TComObjectFactory; const Controller : IUnknown)');
   //   destructor Destroy; override;
  
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
  
    RegisterMethod('Procedure ForEachFactory( ComServer : TComServerObject; FactoryProc : TFactoryProc)');
    RegisterMethod('Function GetFactoryFromClass( ComClass : TClass) : TComObjectFactory');
    RegisterMethod('Function GetFactoryFromClassID( const ClassID : TGUID) : TComObjectFactory');
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

(*----------------------------------------------------------------------------*)
procedure SIRegister_ComObj(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TComObjectFactory');
  SIRegister_TComServerObject(CL);
  CL.AddTypeS('TFactoryProc', 'Procedure (Factory : TComObjectFactory)');
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
  CL.AddTypeS('TConnectEvent','Procedure(const Sink : IUnknown; Connecting : Boolean)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAutoObjectFactory');
  SIRegister_TAutoObject(CL);
  //CL.AddTypeS('TAutoClass', 'class of TAutoObject');
  SIRegister_TAutoObjectFactory(CL);
  SIRegister_TAutoIntfObject(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EOleError');
  SIRegister_EOleSysError(CL);
  SIRegister_EOleException(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EOleRegistrationError');
 CL.AddDelphiFunction('Procedure DispatchInvoke( const Dispatch : IDispatch; CallDesc : PCallDesc; DispIDs : PDispIDList; Params : Pointer; Result : PVariant)');
 CL.AddDelphiFunction('Procedure DispatchInvokeError( Status : Integer; const ExcepInfo : TExcepInfo)');
 CL.AddDelphiFunction('Function HandleSafeCallException( ExceptObject : TObject; ExceptAddr : Pointer; const ErrorIID : TGUID; const ProgID, HelpFileName : WideString) : HResult');
 
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
 CL.AddDelphiFunction('Procedure CreateRegKey(const Key,ValueName,Value:string;RootKey: DWord)');
 CL.AddDelphiFunction('Procedure DeleteRegKey(const Key : string; RootKey : DWord)');
 CL.AddDelphiFunction('Function GetRegStringValue( const Key, ValueName : string; RootKey : DWord) : string');
 CL.AddDelphiFunction('Function StringToLPOLESTR( const Source : string) : POleStr');
 CL.AddDelphiFunction('Procedure RegisterComServer( const DLLName : string)');
 CL.AddDelphiFunction('Procedure RegisterAsService( const ClassID, ServiceName : string)');
 CL.AddDelphiFunction('Function CreateClassID : string');
 CL.AddDelphiFunction('Procedure InterfaceConnect( const Source : IUnknown; const IID : TIID; const Sink : IUnknown; var Connection : Longint)');
 CL.AddDelphiFunction('Procedure InterfaceDisconnect( const Source : IUnknown; const IID : TIID; var Connection : Longint)');
 CL.AddDelphiFunction('Function GetDispatchPropValue(Disp: IDispatch; DispID : Integer) : OleVariant;');
 CL.AddDelphiFunction('Function GetDispatchPropValue1(Disp: IDispatch; Name : WideString) : OleVariant;');
 CL.AddDelphiFunction('Procedure SetDispatchPropValue2(Disp: IDispatch; DispID : Integer; const Value : OleVariant);');
 CL.AddDelphiFunction('Procedure SetDispatchPropValue3(Disp: IDispatch; Name : WideString; const Value : OleVariant);');
 CL.AddDelphiFunction('Function ComClassManager : TComClassManager');
 
 //  from ADODB OLE Utils
 
 CL.AddDelphiFunction('Function CreateADOObject( const ClassID : TGUID) : IUnknown');
 CL.AddDelphiFunction('Function ADOTypeToFieldType( const ADOType : DataTypeEnum; EnableBCD : Boolean) : TFieldType');
 CL.AddDelphiFunction('Function FieldTypeToADOType( const FieldType : TFieldType) : DataTypeEnum');
 CL.AddDelphiFunction('Function StringToVarArray( const Value : string) : OleVariant');
 CL.AddDelphiFunction('Function VarDataSize( const Value : OleVariant) : Integer');
 CL.AddDelphiFunction('Function OleEnumToOrd( OleEnumArray : array of TOleEnum; Value : TOleEnum) : Integer');
 CL.AddDelphiFunction('Function GetStates( State : Integer) : TObjectStates');
 CL.AddDelphiFunction('Function ExecuteOptionsToOrd( ExecuteOptions : TExecuteOptions) : Integer');
 CL.AddDelphiFunction('Function OrdToExecuteOptions(Options: Integer) : TExecuteOptions');
 CL.AddDelphiFunction('Function ExtractFieldName( const Fields : WideString; var Pos : Integer) : WideString');
 CL.AddDelphiFunction('Function GetFilterStr( Field : TField; Value : Variant; Partial : Boolean) : WideString');
 CL.AddDelphiFunction('Function FieldListCheckSum( DataSet : TDataset) : Integer');

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
procedure RIRegister_ComObj_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DispatchInvoke, 'DispatchInvoke', cdRegister);
 S.RegisterDelphiFunction(@DispatchInvokeError, 'DispatchInvokeError', cdRegister);
 S.RegisterDelphiFunction(@HandleSafeCallException,'HandleSafeCallException', cdRegister);
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
 S.RegisterDelphiFunction(@StringToLPOLESTR, 'StringToLPOLESTR', cdRegister);
 S.RegisterDelphiFunction(@RegisterComServer, 'RegisterComServer', cdRegister);
 S.RegisterDelphiFunction(@RegisterAsService, 'RegisterAsService', cdRegister);
 S.RegisterDelphiFunction(@CreateClassID, 'CreateClassID', cdRegister);
 S.RegisterDelphiFunction(@InterfaceConnect, 'InterfaceConnect', cdRegister);
 S.RegisterDelphiFunction(@InterfaceDisconnect, 'InterfaceDisconnect', cdRegister);
 S.RegisterDelphiFunction(@GetDispatchPropValue, 'GetDispatchPropValue', cdRegister);
 S.RegisterDelphiFunction(@GetDispatchPropValue1, 'GetDispatchPropValue1', cdRegister);
 S.RegisterDelphiFunction(@SetDispatchPropValue2, 'SetDispatchPropValue2', cdRegister);
 S.RegisterDelphiFunction(@SetDispatchPropValue3, 'SetDispatchPropValue3', cdRegister);
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
 S.RegisterDelphiFunction(@ExtractFieldName, 'ExtractFieldName', cdRegister);
 S.RegisterDelphiFunction(@GetFilterStr, 'GetFilterStr', cdRegister);
 S.RegisterDelphiFunction(@FieldListCheckSum, 'FieldListCheckSum', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EOleException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EOleException) do
  begin
    RegisterConstructor(@EOleException.Create, 'Create');
    RegisterPropertyHelper(@EOleExceptionHelpFile_R,@EOleExceptionHelpFile_W,'HelpFile');
    RegisterPropertyHelper(@EOleExceptionSource_R,@EOleExceptionSource_W,'Source');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EOleSysError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EOleSysError) do
  begin
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
  with CL.Add(TAutoObjectFactory) do
  begin
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
  with CL.Add(TAutoObject) do
  begin
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
  with CL.Add(TComObjectFactory) do
  begin
    RegisterConstructor(@TComObjectFactory.Create, 'Create');
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
  with CL.Add(TComObject) do
  begin
    RegisterConstructor(@TComObject.Create, 'Create');
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
  with CL.Add(TComClassManager) do
  begin
    RegisterConstructor(@TComClassManager.Create, 'Create');
    RegisterMethod(@TComClassManager.ForEachFactory, 'ForEachFactory');
    RegisterMethod(@TComClassManager.GetFactoryFromClass, 'GetFactoryFromClass');
    RegisterMethod(@TComClassManager.GetFactoryFromClassID, 'GetFactoryFromClassID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComServerObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComServerObject) do
  begin
    RegisterPropertyHelper(@TComServerObjectHelpFileName_R,@TComServerObjectHelpFileName_W,'HelpFileName');
    RegisterPropertyHelper(@TComServerObjectServerFileName_R,nil,'ServerFileName');
    RegisterPropertyHelper(@TComServerObjectServerKey_R,nil,'ServerKey');
    RegisterPropertyHelper(@TComServerObjectServerName_R,nil,'ServerName');
    RegisterPropertyHelper(@TComServerObjectTypeLib_R,nil,'TypeLib');
    RegisterPropertyHelper(@TComServerObjectStartSuspended_R,nil,'StartSuspended');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ComObj(CL: TPSRuntimeClassImporter);
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
  SIRegister_ComObj(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ComObj.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ComObj(ri);
  RIRegister_ComObj_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
