unit uPSI_UJSONFunctions;
{
Register more free methods

still on work!

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
  TPSImport_UJSONFunctions = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPCJSONObject(CL: TPSPascalCompiler);
procedure SIRegister_TPCJSONArray(CL: TPSPascalCompiler);
procedure SIRegister_TPCJSONList(CL: TPSPascalCompiler);
procedure SIRegister_TPCJSONNameValue(CL: TPSPascalCompiler);
procedure SIRegister_TPCJSONVariantValue(CL: TPSPascalCompiler);
procedure SIRegister_TPCJSONData(CL: TPSPascalCompiler);
procedure SIRegister_UJSONFunctions(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPCJSONObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPCJSONArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPCJSONList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPCJSONNameValue(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPCJSONVariantValue(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPCJSONData(CL: TPSRuntimeClassImporter);
procedure RIRegister_UJSONFunctions(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // fpjson
  //,jsonparser
  //,DBXJSON
  DateUtils
  ,Variants
  //,ULog
  ,UJSONFunctions
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UJSONFunctions]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPCJSONObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPCJSONList', 'TPCJSONObject') do
  with CL.AddClassN(CL.FindClass('TPCJSONList'),'TPCJSONObject') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Constructor CreateFromJSONObject( JSONObject : TJSONObject)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Function FindName( Name : String) : TPCJSONNameValue');
    RegisterMethod('Function IndexOfName( Name : String) : Integer');
    RegisterMethod('Procedure DeleteName( Name : String)');
    RegisterMethod('Function GetAsVariant( Name : String) : TPCJSONVariantValue');
    RegisterMethod('Function GetAsObject( Name : String) : TPCJSONObject');
    RegisterMethod('Function GetAsArray( Name : String) : TPCJSONArray');
    RegisterMethod('Function AsString( ParamName : String; DefValue : String) : String');
    RegisterMethod('Function AsInteger( ParamName : String; DefValue : Integer) : Integer');
    RegisterMethod('Function AsCardinal( ParamName : String; DefValue : Cardinal) : Cardinal');
    RegisterMethod('Function AsInt64( ParamName : String; DefValue : Int64) : Int64');
    RegisterMethod('Function AsDouble( ParamName : String; DefValue : Double) : Double');
    RegisterMethod('Function AsBoolean( ParamName : String; DefValue : Boolean) : Boolean');
    RegisterMethod('Function AsDateTime( ParamName : String; DefValue : TDateTime) : TDateTime');
    RegisterMethod('Function AsCurrency( ParamName : String; DefValue : Currency) : Currency');
    RegisterMethod('Function SaveAsStream( ParamName : String; Stream : TStream) : Integer');
    RegisterMethod('Function LoadAsStream( ParamName : String; Stream : TStream) : Integer');
    RegisterMethod('Function GetNameValue( index : Integer) : TPCJSONNameValue');
    RegisterMethod('Function IsNull( ParamName : String) : Boolean');
    RegisterMethod('Procedure SetAs( Name : String; Value : TPCJSONData)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPCJSONArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPCJSONList', 'TPCJSONArray') do
  with CL.AddClassN(CL.FindClass('TPCJSONList'),'TPCJSONArray') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Constructor CreateFromJSONArray( JSONArray : TJSONArray)');
    RegisterMethod('Function GetAsVariant( index : Integer) : TPCJSONVariantValue');
    RegisterMethod('Function GetAsObject( index : Integer) : TPCJSONObject');
    RegisterMethod('Function GetAsArray( index : Integer) : TPCJSONArray');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPCJSONList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPCJSONData', 'TPCJSONList') do
  with CL.AddClassN(CL.FindClass('TPCJSONData'),'TPCJSONList') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free;');
    RegisterProperty('Items', 'TPCJSONData Integer', iptrw);
    RegisterMethod('Procedure Insert( Index : Integer; PCJSONData : TPCJSONData)');
    RegisterMethod('Procedure Delete( index : Integer)');
    RegisterMethod('Function Count : Integer');
    RegisterMethod('Procedure Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPCJSONNameValue(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPCJSONData', 'TPCJSONNameValue') do
  with CL.AddClassN(CL.FindClass('TPCJSONData'),'TPCJSONNameValue') do
  begin
    RegisterMethod('Constructor Create( AName : String)');
     RegisterMethod('Procedure Free;');
    RegisterProperty('Name', 'String', iptr);
    RegisterProperty('Value', 'TPCJSONData', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPCJSONVariantValue(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPCJSONData', 'TPCJSONVariantValue') do
  with CL.AddClassN(CL.FindClass('TPCJSONData'),'TPCJSONVariantValue') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Constructor CreateFromJSONValue( JSONValue : TJSONValue)');
    RegisterProperty('Value', 'Variant', iptrw);
    RegisterMethod('Function AsString( DefValue : String) : String');
    RegisterMethod('Function AsInteger( DefValue : Integer) : Integer');
    RegisterMethod('Function AsInt64( DefValue : Int64) : Int64');
    RegisterMethod('Function AsDouble( DefValue : Double) : Double');
    RegisterMethod('Function AsBoolean( DefValue : Boolean) : Boolean');
    RegisterMethod('Function AsDateTime( DefValue : TDateTime) : TDateTime');
    RegisterMethod('Function AsCurrency( DefValue : Currency) : Currency');
    RegisterMethod('Function AsCardinal( DefValue : Cardinal) : Cardinal');
    RegisterMethod('Function IsNull : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPCJSONData(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPCJSONData') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPCJSONData') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function ParseJSONValue0( const JSONObject : String) : TPCJSONData;');
    RegisterMethod('Function ParseJSONValue1( const JSONObject : TBytes) : TPCJSONData;');
    RegisterMethod('Function _GetCount : Integer');
    RegisterMethod('Function ToJSON( pretty : Boolean) : AnsiString');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure Assign( PCJSONData : TPCJSONData)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UJSONFunctions(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TJSONValue', 'TJSONData');
  SIRegister_TPCJSONData(CL);
  //CL.AddTypeS('TPCJSONDataClass', 'class of TPCJSONData');
  SIRegister_TPCJSONVariantValue(CL);
  SIRegister_TPCJSONNameValue(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPCJSONArray');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPCJSONObject');
  SIRegister_TPCJSONList(CL);
  SIRegister_TPCJSONArray(CL);
  SIRegister_TPCJSONObject(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPCParametresError');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPCJSONListItems_W(Self: TPCJSONList; const T: TPCJSONData; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TPCJSONListItems_R(Self: TPCJSONList; var T: TPCJSONData; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPCJSONNameValueValue_W(Self: TPCJSONNameValue; const T: TPCJSONData);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TPCJSONNameValueValue_R(Self: TPCJSONNameValue; var T: TPCJSONData);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TPCJSONNameValueName_R(Self: TPCJSONNameValue; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TPCJSONVariantValueValue_W(Self: TPCJSONVariantValue; const T: Variant);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TPCJSONVariantValueValue_R(Self: TPCJSONVariantValue; var T: Variant);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
Function TPCJSONDataParseJSONValue1_P(Self: TPCJSONData;  const JSONObject : TBytes) : TPCJSONData;
Begin //Result := Self.ParseJSONValue(JSONObject);
 END;

(*----------------------------------------------------------------------------*)
Function TPCJSONDataParseJSONValue0_P(Self: TPCJSONData;  const JSONObject : String) : TPCJSONData;
Begin Result := Self.ParseJSONValue(JSONObject); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPCJSONObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPCJSONObject) do
  begin
    RegisterConstructor(@TPCJSONObject.Create, 'Create');
     RegisterMethod(@TPCJSONObject.Free, 'Free');
    //RegisterConstructor(@TPCJSONObject.CreateFromJSONObject, 'CreateFromJSONObject');
    RegisterMethod(@TPCJSONObject.FindName, 'FindName');
    RegisterMethod(@TPCJSONObject.IndexOfName, 'IndexOfName');
    RegisterMethod(@TPCJSONObject.DeleteName, 'DeleteName');
    RegisterMethod(@TPCJSONObject.GetAsVariant, 'GetAsVariant');
    RegisterMethod(@TPCJSONObject.GetAsObject, 'GetAsObject');
    RegisterMethod(@TPCJSONObject.GetAsArray, 'GetAsArray');
    RegisterMethod(@TPCJSONObject.AsString, 'AsString');
    RegisterMethod(@TPCJSONObject.AsInteger, 'AsInteger');
    RegisterMethod(@TPCJSONObject.AsCardinal, 'AsCardinal');
    RegisterMethod(@TPCJSONObject.AsInt64, 'AsInt64');
    RegisterMethod(@TPCJSONObject.AsDouble, 'AsDouble');
    RegisterMethod(@TPCJSONObject.AsBoolean, 'AsBoolean');
    RegisterMethod(@TPCJSONObject.AsDateTime, 'AsDateTime');
    RegisterMethod(@TPCJSONObject.AsCurrency, 'AsCurrency');
    RegisterMethod(@TPCJSONObject.SaveAsStream, 'SaveAsStream');
    RegisterMethod(@TPCJSONObject.LoadAsStream, 'LoadAsStream');
    RegisterMethod(@TPCJSONObject.GetNameValue, 'GetNameValue');
    RegisterMethod(@TPCJSONObject.IsNull, 'IsNull');
    RegisterMethod(@TPCJSONObject.SetAs, 'SetAs');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPCJSONArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPCJSONArray) do
  begin
    RegisterConstructor(@TPCJSONArray.Create, 'Create');
   // RegisterConstructor(@TPCJSONArray.CreateFromJSONArray, 'CreateFromJSONArray');
    RegisterMethod(@TPCJSONArray.GetAsVariant, 'GetAsVariant');
    RegisterMethod(@TPCJSONArray.GetAsObject, 'GetAsObject');
    RegisterMethod(@TPCJSONArray.GetAsArray, 'GetAsArray');
     RegisterMethod(@TPCJSONArray.Free, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPCJSONList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPCJSONList) do
  begin
    RegisterConstructor(@TPCJSONList.Create, 'Create');
    RegisterPropertyHelper(@TPCJSONListItems_R,@TPCJSONListItems_W,'Items');
    RegisterMethod(@TPCJSONList.Insert, 'Insert');
    RegisterMethod(@TPCJSONList.Delete, 'Delete');
    RegisterMethod(@TPCJSONList.Count, 'Count');
    RegisterMethod(@TPCJSONList.Clear, 'Clear');
     RegisterMethod(@TPCJSONList.Free, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPCJSONNameValue(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPCJSONNameValue) do
  begin
    RegisterConstructor(@TPCJSONNameValue.Create, 'Create');
    RegisterPropertyHelper(@TPCJSONNameValueName_R,nil,'Name');
    RegisterPropertyHelper(@TPCJSONNameValueValue_R,@TPCJSONNameValueValue_W,'Value');
     RegisterMethod(@TPCJSONNameValue.Free, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPCJSONVariantValue(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPCJSONVariantValue) do
  begin
    RegisterConstructor(@TPCJSONVariantValue.Create, 'Create');
 //   RegisterConstructor(@TPCJSONVariantValue.CreateFromJSONValue, 'CreateFromJSONValue');
    RegisterPropertyHelper(@TPCJSONVariantValueValue_R,@TPCJSONVariantValueValue_W,'Value');
    RegisterMethod(@TPCJSONVariantValue.AsString, 'AsString');
    RegisterMethod(@TPCJSONVariantValue.AsInteger, 'AsInteger');
    RegisterMethod(@TPCJSONVariantValue.AsInt64, 'AsInt64');
    RegisterMethod(@TPCJSONVariantValue.AsDouble, 'AsDouble');
    RegisterMethod(@TPCJSONVariantValue.AsBoolean, 'AsBoolean');
    RegisterMethod(@TPCJSONVariantValue.AsDateTime, 'AsDateTime');
    RegisterMethod(@TPCJSONVariantValue.AsCurrency, 'AsCurrency');
    RegisterMethod(@TPCJSONVariantValue.AsCardinal, 'AsCardinal');
    RegisterMethod(@TPCJSONVariantValue.IsNull, 'IsNull');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPCJSONData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPCJSONData) do
  begin
    RegisterVirtualConstructor(@TPCJSONData.Create, 'Create');
    RegisterMethod(@TPCJSONDataParseJSONValue0_P, 'ParseJSONValue0');
    RegisterMethod(@TPCJSONDataParseJSONValue1_P, 'ParseJSONValue1');
    RegisterMethod(@TPCJSONData._GetCount, '_GetCount');
    RegisterMethod(@TPCJSONData.ToJSON, 'ToJSON');
    RegisterMethod(@TPCJSONData.SaveToStream, 'SaveToStream');
    RegisterMethod(@TPCJSONData.Assign, 'Assign');
    RegisterMethod(@TPCJSONData.Free, 'Free');
    //regist

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UJSONFunctions(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPCJSONData(CL);
  RIRegister_TPCJSONVariantValue(CL);
  RIRegister_TPCJSONNameValue(CL);
  with CL.Add(TPCJSONArray) do
  with CL.Add(TPCJSONObject) do
  RIRegister_TPCJSONList(CL);
  RIRegister_TPCJSONArray(CL);
  RIRegister_TPCJSONObject(CL);
  with CL.Add(EPCParametresError) do
end;

 
 
{ TPSImport_UJSONFunctions }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UJSONFunctions.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UJSONFunctions(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UJSONFunctions.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UJSONFunctions(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
