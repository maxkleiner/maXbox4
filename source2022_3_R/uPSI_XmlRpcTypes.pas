unit uPSI_XmlRpcTypes;
{
type set for xmlrpc client

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
  TPSImport_XmlRpcTypes = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_EXmlRpcError(CL: TPSPascalCompiler);
procedure SIRegister_TRpcFunction(CL: TPSPascalCompiler);
procedure SIRegister_IRpcFunction(CL: TPSPascalCompiler);
procedure SIRegister_TRpcStruct(CL: TPSPascalCompiler);
procedure SIRegister_IRpcStruct(CL: TPSPascalCompiler);
procedure SIRegister_TRpcArray(CL: TPSPascalCompiler);
procedure SIRegister_IRpcArray(CL: TPSPascalCompiler);
procedure SIRegister_TRpcCustomArray(CL: TPSPascalCompiler);
procedure SIRegister_IRpcCustomArray(CL: TPSPascalCompiler);
procedure SIRegister_TRpcResult(CL: TPSPascalCompiler);
procedure SIRegister_IRpcResult(CL: TPSPascalCompiler);
procedure SIRegister_TRpcStructItem(CL: TPSPascalCompiler);
procedure SIRegister_TRpcFunctionItem(CL: TPSPascalCompiler);
procedure SIRegister_TRpcArrayItem(CL: TPSPascalCompiler);
procedure SIRegister_TRpcCustomItem(CL: TPSPascalCompiler);
procedure SIRegister_IRpcCustomItem(CL: TPSPascalCompiler);
procedure SIRegister_XmlRpcTypes(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_EXmlRpcError(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcFunction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcStruct(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcCustomArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcResult(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcStructItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcFunctionItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcArrayItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcCustomItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_XmlRpcTypes(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,DIMime
  ,XmlRpcCommon
  ,XmlRpcTypes
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XmlRpcTypes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EXmlRpcError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EXmlRpcError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EXmlRpcError') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcFunction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRpcCustomArray', 'TRpcFunction') do
  with CL.AddClassN(CL.FindClass('TRpcCustomArray'),'TRpcFunction') do begin
    RegisterMethod('Procedure SetError( Code : Integer; const Msg : string)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('ObjectMethod', 'string', iptrw);
    RegisterProperty('RequestXML', 'string', iptr);
    RegisterProperty('ResponseXML', 'string', iptr);
    RegisterProperty('ErrorXML', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IRpcFunction(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IRpcCustomArray', 'IRpcFunction') do
  with CL.AddInterface(CL.FindInterface('IRpcCustomArray'),IRpcFunction, 'IRpcFunction') do
  begin
    RegisterMethod('Function GetRequestXML : string', cdRegister);
    RegisterMethod('Function GetResponseXML : string', cdRegister);
    RegisterMethod('Function GetErrorXML : string', cdRegister);
    RegisterMethod('Function GetObjectMethod : string', cdRegister);
    RegisterMethod('Procedure SetObjectMethod( const Value : string)', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Procedure SetError( Code : Integer; const Msg : string)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcStruct(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TRpcStruct') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TRpcStruct') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure AddItem20( const Key : string; Value : Integer);');
    RegisterMethod('Procedure AddItem21( const Key : string; const Value : string);');
    RegisterMethod('Procedure AddItem22( const Key : string; Value : Double);');
    RegisterMethod('Procedure AddItem23( const Key : string; Value : Boolean);');
    RegisterMethod('Procedure AddItem24( const Key : string; Value : IRpcArray);');
    RegisterMethod('Procedure AddItem25( const Key : string; Value : IRpcStruct);');
    RegisterMethod('Procedure AddItemDateTime( const Key : string; Value : TDateTime)');
    RegisterMethod('Procedure AddItemBase64Str( const Key : string; const Value : string)');
    RegisterMethod('Procedure AddItemBase64Raw( const Key : string; const Value : string)');
    RegisterMethod('Procedure AddItemBase64StrFromFile( const Key : string; const FileName : string)');
    RegisterMethod('Procedure AddItemBase64StrFromStream( const Key : string; Stream : TStream)');
    RegisterMethod('Function KeyExists( const Key : string) : Boolean');
    RegisterMethod('Procedure Delete26( Index : Integer);');
    RegisterMethod('Procedure Delete27( const Key : string);');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Count : Integer');
    RegisterMethod('Function IndexOf( const Key : string) : Integer');
    RegisterMethod('Function GetAsXML : string');
    RegisterMethod('Procedure LoadRawData( DataType : TDataType; const Key, Value : string)');
    RegisterProperty('KeyList', 'TStringList', iptr);
    RegisterProperty('Items', 'TRpcStructItem Integer', iptrw);
    RegisterProperty('Keys', 'TRpcStructItem string', iptrw);
    SetDefaultPropery('Keys');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IRpcStruct(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInterface', 'IRpcStruct') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IRpcStruct, 'IRpcStruct') do begin
    RegisterMethod('Function InternalAddItem( const Key : string) : TRpcStructItem', cdRegister);
    RegisterMethod('Function GetKeyList : TStringList', cdRegister);
    //RegisterMethod('Procedure Free');
    RegisterMethod('Function GetItems( Index : Integer) : TRpcStructItem', cdRegister);
    RegisterMethod('Procedure SetItems( Index : Integer; AItem : TRpcStructItem)', cdRegister);
    RegisterMethod('Function GetKeys( Key : string) : TRpcStructItem', cdRegister);
    RegisterMethod('Procedure SetKeys( Key : string; const AItem : TRpcStructItem)', cdRegister);
    RegisterMethod('Procedure AddItem12( const Key : string; Value : Integer);', cdRegister);
    RegisterMethod('Procedure AddItem13( const Key : string; const Value : string);', cdRegister);
    RegisterMethod('Procedure AddItem14( const Key : string; Value : Double);', cdRegister);
    RegisterMethod('Procedure AddItem15( const Key : string; Value : Boolean);', cdRegister);
    RegisterMethod('Procedure AddItem16( const Key : string; Value : IRpcArray);', cdRegister);
    RegisterMethod('Procedure AddItem17( const Key : string; Value : IRpcStruct);', cdRegister);
    RegisterMethod('Procedure AddItemDateTime( const Key : string; Value : TDateTime)', cdRegister);
    RegisterMethod('Procedure AddItemBase64Str( const Key : string; const Value : string)', cdRegister);
    RegisterMethod('Procedure AddItemBase64Raw( const Key : string; const Value : string)', cdRegister);
    RegisterMethod('Procedure AddItemBase64StrFromFile( const Key : string; const FileName : string)', cdRegister);
    RegisterMethod('Procedure AddItemBase64StrFromStream( const Key : string; Stream : TStream)', cdRegister);
    RegisterMethod('Function KeyExists( const Key : string) : Boolean', cdRegister);
    RegisterMethod('Procedure Delete18( Index : Integer);', cdRegister);
    RegisterMethod('Procedure Delete19( const Key : string);', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Function Count : Integer', cdRegister);
    RegisterMethod('Function IndexOf( const Key : string) : Integer', cdRegister);
    RegisterMethod('Function GetAsXML : string', cdRegister);
    RegisterMethod('Procedure LoadRawData( DataType : TDataType; const Key, Value : string)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRpcCustomArray', 'TRpcArray') do
  with CL.AddClassN(CL.FindClass('TRpcCustomArray'),'TRpcArray') do
  begin
    RegisterMethod('Function GetAsXML : string');
    RegisterMethod('Procedure LoadRawData( DataType : TDataType; Value : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IRpcArray(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IRpcCustomArray', 'IRpcArray') do
  with CL.AddInterface(CL.FindInterface('IRpcCustomArray'),IRpcArray, 'IRpcArray') do
  begin
    RegisterMethod('Function GetAsXML : string', cdRegister);
    RegisterMethod('Procedure LoadRawData( DataType : TDataType; Value : string)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcCustomArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TRpcCustomArray') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TRpcCustomArray') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure AddItem6( const Value : string);');
    RegisterMethod('Procedure AddItem7( Value : Integer);');
    RegisterMethod('Procedure AddItem8( Value : Boolean);');
    RegisterMethod('Procedure AddItem9( Value : Double);');
    RegisterMethod('Procedure AddItem10( Value : IRpcStruct);');
    RegisterMethod('Procedure AddItem11( Value : IRpcArray);');
    RegisterMethod('Procedure AddItemBase64Raw( const Value : string)');
    RegisterMethod('Procedure AddItemBase64Str( const Value : string)');
    RegisterMethod('Procedure AddItemBase64StrFromFile( const FileName : string)');
    RegisterMethod('Procedure AddItemBase64StrFromStream( Stream : TStream)');
    RegisterMethod('Procedure AddItemDateTime( Value : TDateTime)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Count : Integer');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterProperty('Items', 'TRpcArrayItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IRpcCustomArray(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInterface', 'IRpcCustomArray') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IRpcCustomArray, 'IRpcCustomArray') do
  begin
    RegisterMethod('Function GetItems( Index : Integer) : TRpcArrayItem', cdRegister);
    RegisterMethod('Procedure SetItems( Index : Integer; AItem : TRpcArrayItem)', cdRegister);
    RegisterMethod('Procedure AddItem( const Value : string);', cdRegister);
    RegisterMethod('Procedure AddItem1( Value : Integer);', cdRegister);
    RegisterMethod('Procedure AddItem2( Value : Boolean);', cdRegister);
    RegisterMethod('Procedure AddItem3( Value : Double);', cdRegister);
    RegisterMethod('Procedure AddItem4( Value : IRpcStruct);', cdRegister);
    RegisterMethod('Procedure AddItem5( Value : IRpcArray);', cdRegister);
    RegisterMethod('Procedure AddItemBase64Raw( const Value : string)', cdRegister);
    RegisterMethod('Procedure AddItemBase64Str( const Value : string)', cdRegister);
    RegisterMethod('Procedure AddItemBase64StrFromFile( const FileName : string)', cdRegister);
    RegisterMethod('Procedure AddItemBase64StrFromStream( Stream : TStream)', cdRegister);
    RegisterMethod('Procedure AddItemDateTime( Value : TDateTime)', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Function Count : Integer', cdRegister);
    RegisterMethod('Procedure Delete( Index : Integer)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcResult(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRpcCustomItem', 'TRpcResult') do
  with CL.AddClassN(CL.FindClass('TRpcCustomItem'),'TRpcResult') do
  begin
    RegisterMethod('Procedure SetError( Code : Integer; const Msg : string)');
    RegisterMethod('Function IsError : Boolean');
    RegisterProperty('ErrorCode', 'Integer', iptr);
    RegisterProperty('ErrorMsg', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IRpcResult(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IRpcCustomItem', 'IRpcResult') do
  with CL.AddInterface(CL.FindInterface('IRpcCustomItem'),IRpcResult, 'IRpcResult') do
  begin
    RegisterMethod('Function GetErrorCode : Integer', cdRegister);
    RegisterMethod('Function GetErrorMsg : string', cdRegister);
    RegisterMethod('Procedure SetError( Code : Integer; const Msg : string)', cdRegister);
    RegisterMethod('Function IsError : Boolean', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcStructItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRpcCustomItem', 'TRpcStructItem') do
  with CL.AddClassN(CL.FindClass('TRpcCustomItem'),'TRpcStructItem') do
  begin
    RegisterProperty('Name', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcFunctionItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRpcCustomItem', 'TRpcFunctionItem') do
  with CL.AddClassN(CL.FindClass('TRpcCustomItem'),'TRpcFunctionItem') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcArrayItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRpcCustomItem', 'TRpcArrayItem') do
  with CL.AddClassN(CL.FindClass('TRpcCustomItem'),'TRpcArrayItem') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcCustomItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TRpcCustomItem') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TRpcCustomItem') do
  begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function IsArray : Boolean');
    RegisterMethod('Function IsBase64 : Boolean');
    RegisterMethod('Function IsBoolean : Boolean');
    RegisterMethod('Function IsDate : Boolean');
    RegisterMethod('Function IsFloat : Boolean');
    RegisterMethod('Function IsError : Boolean');
    RegisterMethod('Function IsInteger : Boolean');
    RegisterMethod('Function IsString : Boolean');
    RegisterMethod('Function IsStruct : Boolean');
    RegisterMethod('Procedure Base64StrLoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure Base64StrSaveToStream( Stream : TStream)');
    RegisterMethod('Procedure Base64StrLoadFromFile( const FileName : string)');
    RegisterMethod('Procedure Base64StrSaveToFile( const FileName : string)');
    RegisterProperty('AsRawString', 'string', iptrw);
    RegisterProperty('AsString', 'string', iptrw);
    RegisterProperty('AsInteger', 'Integer', iptrw);
    RegisterProperty('AsFloat', 'Double', iptrw);
    RegisterProperty('AsBoolean', 'Boolean', iptrw);
    RegisterProperty('AsDateTime', 'TDateTime', iptrw);
    RegisterProperty('AsBase64Str', 'string', iptrw);
    RegisterProperty('AsBase64Raw', 'string', iptrw);
    RegisterProperty('AsArray', 'IRpcArray', iptrw);
    RegisterProperty('AsStruct', 'IRpcStruct', iptrw);
    RegisterProperty('DataType', 'TDataType', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IRpcCustomItem(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInterface', 'IRpcCustomItem') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IRpcCustomItem, 'IRpcCustomItem') do
  begin
    RegisterMethod('Function GetAsRawString : string', cdRegister);
    RegisterMethod('Procedure SetAsRawString( const Value : string)', cdRegister);
    RegisterMethod('Function GetAsString : string', cdRegister);
    RegisterMethod('Procedure SetAsString( const Value : string)', cdRegister);
    RegisterMethod('Function GetAsInteger : Integer', cdRegister);
    RegisterMethod('Procedure SetAsInteger( Value : Integer)', cdRegister);
    RegisterMethod('Function GetAsFloat : Double', cdRegister);
    RegisterMethod('Procedure SetAsFloat( Value : Double)', cdRegister);
    RegisterMethod('Function GetAsBoolean : Boolean', cdRegister);
    RegisterMethod('Procedure SetAsBoolean( Value : Boolean)', cdRegister);
    RegisterMethod('Function GetAsDateTime : TDateTime', cdRegister);
    RegisterMethod('Procedure SetAsDateTime( Value : TDateTime)', cdRegister);
    RegisterMethod('Function GetAsBase64Str : string', cdRegister);
    RegisterMethod('Procedure SetAsBase64Str( const Value : string)', cdRegister);
    RegisterMethod('Function GetAsArray : IRpcArray', cdRegister);
    RegisterMethod('Procedure SetAsArray( Value : IRpcArray)', cdRegister);
    RegisterMethod('Function GetAsStruct : IRpcStruct', cdRegister);
    RegisterMethod('Procedure SetAsStruct( Value : IRpcStruct)', cdRegister);
    RegisterMethod('Function GetAsBase64Raw : string', cdRegister);
    RegisterMethod('Procedure SetAsBase64Raw( const Value : string)', cdRegister);
    RegisterMethod('Function GetDataType : TDataType', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Function IsArray : Boolean', cdRegister);
    RegisterMethod('Function IsBase64 : Boolean', cdRegister);
    RegisterMethod('Function IsBoolean : Boolean', cdRegister);
    RegisterMethod('Function IsDate : Boolean', cdRegister);
    RegisterMethod('Function IsFloat : Boolean', cdRegister);
    RegisterMethod('Function IsError : Boolean', cdRegister);
    RegisterMethod('Function IsInteger : Boolean', cdRegister);
    RegisterMethod('Function IsString : Boolean', cdRegister);
    RegisterMethod('Function IsStruct : Boolean', cdRegister);
    RegisterMethod('Procedure Base64StrLoadFromStream( Stream : TStream)', cdRegister);
    RegisterMethod('Procedure Base64StrSaveToStream( Stream : TStream)', cdRegister);
    RegisterMethod('Procedure Base64StrLoadFromFile( const FileName : string)', cdRegister);
    RegisterMethod('Procedure Base64StrSaveToFile( const FileName : string)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XmlRpcTypes(CL: TPSPascalCompiler);
begin
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IRpcArray, 'IRpcArray');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IRpcStruct, 'IRpcStruct');
  CL.AddTypeS('TRPCDataType2', '( dtFloat, dtInteger, dtString, dtBoolean, dtDateTi'
   +'me, dtBase64, dtStruct, dtArray, dtError, dtNone, dtName, dtValue )');
  SIRegister_IRpcCustomItem(CL);
  SIRegister_TRpcCustomItem(CL);
  SIRegister_TRpcArrayItem(CL);
  SIRegister_TRpcFunctionItem(CL);
  SIRegister_TRpcStructItem(CL);
  SIRegister_IRpcResult(CL);
  SIRegister_TRpcResult(CL);
  SIRegister_IRpcCustomArray(CL);
  SIRegister_TRpcCustomArray(CL);
  SIRegister_IRpcArray(CL);
  SIRegister_TRpcArray(CL);
  SIRegister_IRpcStruct(CL);
  SIRegister_TRpcStruct(CL);
  SIRegister_IRpcFunction(CL);
  SIRegister_TRpcFunction(CL);
  SIRegister_EXmlRpcError(CL);
  CL.AddTypeS('TRpcParameter', 'TRpcResult');
  CL.AddTypeS('TRpcReturn', 'TRpcFunction');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRpcFunctionErrorXML_R(Self: TRpcFunction; var T: string);
begin T := Self.ErrorXML; end;

(*----------------------------------------------------------------------------*)
procedure TRpcFunctionResponseXML_R(Self: TRpcFunction; var T: string);
begin T := Self.ResponseXML; end;

(*----------------------------------------------------------------------------*)
procedure TRpcFunctionRequestXML_R(Self: TRpcFunction; var T: string);
begin T := Self.RequestXML; end;

(*----------------------------------------------------------------------------*)
procedure TRpcFunctionObjectMethod_W(Self: TRpcFunction; const T: string);
begin Self.ObjectMethod := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcFunctionObjectMethod_R(Self: TRpcFunction; var T: string);
begin T := Self.ObjectMethod; end;

(*----------------------------------------------------------------------------*)
procedure TRpcStructKeys_W(Self: TRpcStruct; const T: TRpcStructItem; const t1: string);
begin Self.Keys[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcStructKeys_R(Self: TRpcStruct; var T: TRpcStructItem; const t1: string);
begin T := Self.Keys[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TRpcStructItems_W(Self: TRpcStruct; const T: TRpcStructItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcStructItems_R(Self: TRpcStruct; var T: TRpcStructItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TRpcStructKeyList_R(Self: TRpcStruct; var T: TStringList);
begin T := Self.KeyList; end;

(*----------------------------------------------------------------------------*)
Procedure TRpcStructDelete27_P(Self: TRpcStruct;  const Key : string);
Begin Self.Delete(Key); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcStructDelete26_P(Self: TRpcStruct;  Index : Integer);
Begin Self.Delete(Index); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcStructAddItem25_P(Self: TRpcStruct;  const Key : string; Value : IRpcStruct);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcStructAddItem24_P(Self: TRpcStruct;  const Key : string; Value : IRpcArray);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcStructAddItem23_P(Self: TRpcStruct;  const Key : string; Value : Boolean);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcStructAddItem22_P(Self: TRpcStruct;  const Key : string; Value : Double);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcStructAddItem21_P(Self: TRpcStruct;  const Key : string; const Value : string);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcStructAddItem20_P(Self: TRpcStruct;  const Key : string; Value : Integer);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcStructDelete19_P(Self: IRpcStruct;  const Key : string);
Begin Self.Delete(Key); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcStructDelete18_P(Self: IRpcStruct;  Index : Integer);
Begin Self.Delete(Index); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcStructAddItem17_P(Self: IRpcStruct;  const Key : string; Value : IRpcStruct);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcStructAddItem16_P(Self: IRpcStruct;  const Key : string; Value : IRpcArray);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcStructAddItem15_P(Self: IRpcStruct;  const Key : string; Value : Boolean);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcStructAddItem14_P(Self: IRpcStruct;  const Key : string; Value : Double);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcStructAddItem13_P(Self: IRpcStruct;  const Key : string; const Value : string);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcStructAddItem12_P(Self: IRpcStruct;  const Key : string; Value : Integer);
Begin Self.AddItem(Key, Value); END;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomArrayItems_W(Self: TRpcCustomArray; const T: TRpcArrayItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomArrayItems_R(Self: TRpcCustomArray; var T: TRpcArrayItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TRpcCustomArrayAddItem11_P(Self: TRpcCustomArray;  Value : IRpcArray);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcCustomArrayAddItem10_P(Self: TRpcCustomArray;  Value : IRpcStruct);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcCustomArrayAddItem9_P(Self: TRpcCustomArray;  Value : Double);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcCustomArrayAddItem8_P(Self: TRpcCustomArray;  Value : Boolean);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcCustomArrayAddItem7_P(Self: TRpcCustomArray;  Value : Integer);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TRpcCustomArrayAddItem6_P(Self: TRpcCustomArray;  const Value : string);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcCustomArrayAddItem5_P(Self: IRpcCustomArray;  Value : IRpcArray);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcCustomArrayAddItem4_P(Self: IRpcCustomArray;  Value : IRpcStruct);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcCustomArrayAddItem3_P(Self: IRpcCustomArray;  Value : Double);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcCustomArrayAddItem2_P(Self: IRpcCustomArray;  Value : Boolean);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcCustomArrayAddItem1_P(Self: IRpcCustomArray;  Value : Integer);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
Procedure IRpcCustomArrayAddItem_P(Self: IRpcCustomArray;  const Value : string);
Begin Self.AddItem(Value); END;

(*----------------------------------------------------------------------------*)
procedure TRpcResultErrorMsg_R(Self: TRpcResult; var T: string);
begin T := Self.ErrorMsg; end;

(*----------------------------------------------------------------------------*)
procedure TRpcResultErrorCode_R(Self: TRpcResult; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TRpcStructItemName_W(Self: TRpcStructItem; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcStructItemName_R(Self: TRpcStructItem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemDataType_R(Self: TRpcCustomItem; var T: TDataType);
begin T := Self.DataType; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsStruct_W(Self: TRpcCustomItem; const T: IRpcStruct);
begin Self.AsStruct := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsStruct_R(Self: TRpcCustomItem; var T: IRpcStruct);
begin T := Self.AsStruct; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsArray_W(Self: TRpcCustomItem; const T: IRpcArray);
begin Self.AsArray := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsArray_R(Self: TRpcCustomItem; var T: IRpcArray);
begin T := Self.AsArray; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsBase64Raw_W(Self: TRpcCustomItem; const T: string);
begin Self.AsBase64Raw := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsBase64Raw_R(Self: TRpcCustomItem; var T: string);
begin T := Self.AsBase64Raw; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsBase64Str_W(Self: TRpcCustomItem; const T: string);
begin Self.AsBase64Str := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsBase64Str_R(Self: TRpcCustomItem; var T: string);
begin T := Self.AsBase64Str; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsDateTime_W(Self: TRpcCustomItem; const T: TDateTime);
begin Self.AsDateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsDateTime_R(Self: TRpcCustomItem; var T: TDateTime);
begin T := Self.AsDateTime; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsBoolean_W(Self: TRpcCustomItem; const T: Boolean);
begin Self.AsBoolean := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsBoolean_R(Self: TRpcCustomItem; var T: Boolean);
begin T := Self.AsBoolean; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsFloat_W(Self: TRpcCustomItem; const T: Double);
begin Self.AsFloat := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsFloat_R(Self: TRpcCustomItem; var T: Double);
begin T := Self.AsFloat; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsInteger_W(Self: TRpcCustomItem; const T: Integer);
begin Self.AsInteger := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsInteger_R(Self: TRpcCustomItem; var T: Integer);
begin T := Self.AsInteger; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsString_W(Self: TRpcCustomItem; const T: string);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsString_R(Self: TRpcCustomItem; var T: string);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsRawString_W(Self: TRpcCustomItem; const T: string);
begin Self.AsRawString := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCustomItemAsRawString_R(Self: TRpcCustomItem; var T: string);
begin T := Self.AsRawString; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EXmlRpcError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EXmlRpcError) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcFunction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcFunction) do begin
    RegisterMethod(@TRpcFunction.SetError, 'SetError');
     RegisterMethod(@TRpcFunction.Clear, 'Clear');
    RegisterPropertyHelper(@TRpcFunctionObjectMethod_R,@TRpcFunctionObjectMethod_W,'ObjectMethod');
    RegisterPropertyHelper(@TRpcFunctionRequestXML_R,nil,'RequestXML');
    RegisterPropertyHelper(@TRpcFunctionResponseXML_R,nil,'ResponseXML');
    RegisterPropertyHelper(@TRpcFunctionErrorXML_R,nil,'ErrorXML');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcStruct(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcStruct) do begin
    RegisterConstructor(@TRpcStruct.Create, 'Create');
    RegisterMethod(@TRpcStruct.Destroy, 'Free');
    RegisterMethod(@TRpcStructAddItem20_P, 'AddItem20');
    RegisterMethod(@TRpcStructAddItem21_P, 'AddItem21');
    RegisterMethod(@TRpcStructAddItem22_P, 'AddItem22');
    RegisterMethod(@TRpcStructAddItem23_P, 'AddItem23');
    RegisterMethod(@TRpcStructAddItem24_P, 'AddItem24');
    RegisterMethod(@TRpcStructAddItem25_P, 'AddItem25');
    RegisterMethod(@TRpcStruct.AddItemDateTime, 'AddItemDateTime');
    RegisterMethod(@TRpcStruct.AddItemBase64Str, 'AddItemBase64Str');
    RegisterMethod(@TRpcStruct.AddItemBase64Raw, 'AddItemBase64Raw');
    RegisterMethod(@TRpcStruct.AddItemBase64StrFromFile, 'AddItemBase64StrFromFile');
    RegisterMethod(@TRpcStruct.AddItemBase64StrFromStream, 'AddItemBase64StrFromStream');
    RegisterMethod(@TRpcStruct.KeyExists, 'KeyExists');
    RegisterMethod(@TRpcStructDelete26_P, 'Delete26');
    RegisterMethod(@TRpcStructDelete27_P, 'Delete27');
    RegisterMethod(@TRpcStruct.Clear, 'Clear');
    RegisterMethod(@TRpcStruct.Count, 'Count');
    RegisterMethod(@TRpcStruct.IndexOf, 'IndexOf');
    RegisterMethod(@TRpcStruct.GetAsXML, 'GetAsXML');
    RegisterMethod(@TRpcStruct.LoadRawData, 'LoadRawData');
    RegisterPropertyHelper(@TRpcStructKeyList_R,nil,'KeyList');
    RegisterPropertyHelper(@TRpcStructItems_R,@TRpcStructItems_W,'Items');
    RegisterPropertyHelper(@TRpcStructKeys_R,@TRpcStructKeys_W,'Keys');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcArray) do
  begin
    RegisterMethod(@TRpcArray.GetAsXML, 'GetAsXML');
    RegisterMethod(@TRpcArray.LoadRawData, 'LoadRawData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcCustomArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcCustomArray) do begin
    RegisterConstructor(@TRpcCustomArray.Create, 'Create');
     RegisterMethod(@TRpcCustomArray.Destroy, 'Free');
       RegisterMethod(@TRpcCustomArrayAddItem6_P, 'AddItem6');
    RegisterMethod(@TRpcCustomArrayAddItem7_P, 'AddItem7');
    RegisterMethod(@TRpcCustomArrayAddItem8_P, 'AddItem8');
    RegisterMethod(@TRpcCustomArrayAddItem9_P, 'AddItem9');
    RegisterMethod(@TRpcCustomArrayAddItem10_P, 'AddItem10');
    RegisterMethod(@TRpcCustomArrayAddItem11_P, 'AddItem11');
    RegisterMethod(@TRpcCustomArray.AddItemBase64Raw, 'AddItemBase64Raw');
    RegisterMethod(@TRpcCustomArray.AddItemBase64Str, 'AddItemBase64Str');
    RegisterMethod(@TRpcCustomArray.AddItemBase64StrFromFile, 'AddItemBase64StrFromFile');
    RegisterMethod(@TRpcCustomArray.AddItemBase64StrFromStream, 'AddItemBase64StrFromStream');
    RegisterMethod(@TRpcCustomArray.AddItemDateTime, 'AddItemDateTime');
    RegisterVirtualMethod(@TRpcCustomArray.Clear, 'Clear');
    RegisterMethod(@TRpcCustomArray.Count, 'Count');
    RegisterMethod(@TRpcCustomArray.Delete, 'Delete');
    RegisterPropertyHelper(@TRpcCustomArrayItems_R,@TRpcCustomArrayItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcResult(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcResult) do
  begin
    RegisterMethod(@TRpcResult.SetError, 'SetError');
    RegisterMethod(@TRpcResult.IsError, 'IsError');
    RegisterPropertyHelper(@TRpcResultErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@TRpcResultErrorMsg_R,nil,'ErrorMsg');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcStructItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcStructItem) do
  begin
    RegisterPropertyHelper(@TRpcStructItemName_R,@TRpcStructItemName_W,'Name');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcFunctionItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcFunctionItem) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcArrayItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcArrayItem) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcCustomItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcCustomItem) do
  begin
    RegisterMethod(@TRpcCustomItem.Clear, 'Clear');
    RegisterMethod(@TRpcCustomItem.IsArray, 'IsArray');
    RegisterMethod(@TRpcCustomItem.IsBase64, 'IsBase64');
    RegisterMethod(@TRpcCustomItem.IsBoolean, 'IsBoolean');
    RegisterMethod(@TRpcCustomItem.IsDate, 'IsDate');
    RegisterMethod(@TRpcCustomItem.IsFloat, 'IsFloat');
    RegisterMethod(@TRpcCustomItem.IsError, 'IsError');
    RegisterMethod(@TRpcCustomItem.IsInteger, 'IsInteger');
    RegisterMethod(@TRpcCustomItem.IsString, 'IsString');
    RegisterMethod(@TRpcCustomItem.IsStruct, 'IsStruct');
    RegisterVirtualMethod(@TRpcCustomItem.Base64StrLoadFromStream, 'Base64StrLoadFromStream');
    RegisterVirtualMethod(@TRpcCustomItem.Base64StrSaveToStream, 'Base64StrSaveToStream');
    RegisterVirtualMethod(@TRpcCustomItem.Base64StrLoadFromFile, 'Base64StrLoadFromFile');
    RegisterVirtualMethod(@TRpcCustomItem.Base64StrSaveToFile, 'Base64StrSaveToFile');
    RegisterPropertyHelper(@TRpcCustomItemAsRawString_R,@TRpcCustomItemAsRawString_W,'AsRawString');
    RegisterPropertyHelper(@TRpcCustomItemAsString_R,@TRpcCustomItemAsString_W,'AsString');
    RegisterPropertyHelper(@TRpcCustomItemAsInteger_R,@TRpcCustomItemAsInteger_W,'AsInteger');
    RegisterPropertyHelper(@TRpcCustomItemAsFloat_R,@TRpcCustomItemAsFloat_W,'AsFloat');
    RegisterPropertyHelper(@TRpcCustomItemAsBoolean_R,@TRpcCustomItemAsBoolean_W,'AsBoolean');
    RegisterPropertyHelper(@TRpcCustomItemAsDateTime_R,@TRpcCustomItemAsDateTime_W,'AsDateTime');
    RegisterPropertyHelper(@TRpcCustomItemAsBase64Str_R,@TRpcCustomItemAsBase64Str_W,'AsBase64Str');
    RegisterPropertyHelper(@TRpcCustomItemAsBase64Raw_R,@TRpcCustomItemAsBase64Raw_W,'AsBase64Raw');
    RegisterPropertyHelper(@TRpcCustomItemAsArray_R,@TRpcCustomItemAsArray_W,'AsArray');
    RegisterPropertyHelper(@TRpcCustomItemAsStruct_R,@TRpcCustomItemAsStruct_W,'AsStruct');
    RegisterPropertyHelper(@TRpcCustomItemDataType_R,nil,'DataType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XmlRpcTypes(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRpcCustomItem(CL);
  RIRegister_TRpcArrayItem(CL);
  RIRegister_TRpcFunctionItem(CL);
  RIRegister_TRpcStructItem(CL);
  RIRegister_TRpcResult(CL);
  RIRegister_TRpcCustomArray(CL);
  RIRegister_TRpcArray(CL);
  RIRegister_TRpcStruct(CL);
  RIRegister_TRpcFunction(CL);
  RIRegister_EXmlRpcError(CL);
end;

 
 
{ TPSImport_XmlRpcTypes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlRpcTypes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XmlRpcTypes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlRpcTypes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XmlRpcTypes(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
