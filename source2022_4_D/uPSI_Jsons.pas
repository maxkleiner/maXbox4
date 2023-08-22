unit uPSI_Jsons;
{
jsodn for python php js  kotlin pascal
  rename TJsonObject to TJsonObject2

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
  TPSImport_Jsons = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJson(CL: TPSPascalCompiler);
procedure SIRegister_TJsonObject2(CL: TPSPascalCompiler);
procedure SIRegister_TJsonPair(CL: TPSPascalCompiler);
procedure SIRegister_TJsonArray2(CL: TPSPascalCompiler);
procedure SIRegister_TJsonValue(CL: TPSPascalCompiler);
procedure SIRegister_TJsonBase(CL: TPSPascalCompiler);
procedure SIRegister_Jsons(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJson(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJsonObject2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJsonPair(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJsonArray2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJsonValue(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJsonBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_Jsons(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   jsonsutilsEx
  ,Jsons
  ;

 //type  TJsonObject2  = TJsonObject;
   //    TJsonArray2 = TJsonArray;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Jsons]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJson(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJsonBase', 'TJson') do
  with CL.AddClassN(CL.FindClass('TJsonBase'),'TJson') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Parse( JsonString : String)');
    RegisterMethod('Function Stringify : String');
    RegisterMethod('Procedure Assign( Source : TJsonBase)');
    RegisterMethod('Procedure Delete21( const Index : Integer);');
    RegisterMethod('Procedure Delete22( const Name : String);');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Get23( const Index : Integer) : TJsonValue;');
    RegisterMethod('Function Get24( const Name : String) : TJsonValue;');
    RegisterMethod('Function Put25( const Value : TJsonEmpty) : TJsonValue;');
    RegisterMethod('Function Put26( const Value : TJsonNull) : TJsonValue;');
    RegisterMethod('Function Put27( const Value : Boolean) : TJsonValue;');
    RegisterMethod('Function Put28( const Value : Integer) : TJsonValue;');
    RegisterMethod('Function Put29( const Value : Extended) : TJsonValue;');
    RegisterMethod('Function Put30( const Value : String) : TJsonValue;');
    RegisterMethod('Function Put31( const Value : TJsonArray2) : TJsonValue;');
    RegisterMethod('Function Put32( const Value : TJsonObject2) : TJsonValue;');
    RegisterMethod('Function Put33( const Value : TJsonValue) : TJsonValue;');
    RegisterMethod('Function Put34( const Value : TJson) : TJsonValue;');
    RegisterMethod('Function Putbool( const Value : Boolean) : TJsonValue;');
    RegisterMethod('Function Putint( const Value : Integer) : TJsonValue;');
    RegisterMethod('Function Putext( const Value : Extended) : TJsonValue;');
    RegisterMethod('Function Putstr( const Value : String) : TJsonValue;');
    RegisterMethod('Function Putarr( const Value : TJsonArray2) : TJsonValue;');
    RegisterMethod('Function Putobj( const Value : TJsonObject2) : TJsonValue;');
    RegisterMethod('Function Putval( const Value : TJsonValue) : TJsonValue;');
    RegisterMethod('Function Putjson( const Value : TJson) : TJsonValue;');

    RegisterMethod('Function Put35( const Name : String; const Value : TJsonEmpty) : TJsonValue;');
    RegisterMethod('Function Put36( const Name : String; const Value : TJsonNull) : TJsonValue;');
    RegisterMethod('Function Put37( const Name : String; const Value : Boolean) : TJsonValue;');
    RegisterMethod('Function Put38( const Name : String; const Value : Integer) : TJsonValue;');
    RegisterMethod('Function Put39( const Name : String; const Value : Extended) : TJsonValue;');
    RegisterMethod('Function Put40( const Name : String; const Value : String) : TJsonValue;');
    RegisterMethod('Function Put41( const Name : String; const Value : TJsonArray2) : TJsonValue;');
    RegisterMethod('Function Put42( const Name : String; const Value : TJsonObject2) : TJsonValue;');
    RegisterMethod('Function Put43( const Name : String; const Value : TJsonValue) : TJsonValue;');
    RegisterMethod('Function Put44( const Name : String; const Value : TJson) : TJsonValue;');
    RegisterMethod('Function Put45( const Value : TJsonPair) : TJsonValue;');
    RegisterProperty('StructType', 'TJsonStructType', iptr);
    RegisterProperty('JsonObject', 'TJsonObject2', iptr);
    RegisterProperty('JsonArray', 'TJsonArray2', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Values', 'TJsonValue String', iptr);
    SetDefaultPropery('Values');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsonObject2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJsonBase', 'TJsonObject') do
  with CL.AddClassN(CL.FindClass('TJsonBase'),'TJsonObject2') do begin
    RegisterMethod('Constructor Create( AOwner : TJsonBase)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Parse( JsonString : String)');
    RegisterMethod('Procedure Assign( Source : TJsonBase)');
    RegisterMethod('Procedure Merge( Addition : TJsonObject2)');
    RegisterMethod('Function Stringify : String');
    RegisterMethod('Function Add( const Name : String) : TJsonPair');
    RegisterMethod('Function Insert( const Index : Integer; const Name : String) : TJsonPair');
    RegisterMethod('Function Put9( const Name : String; const Value : TJsonEmpty) : TJsonValue;');
    RegisterMethod('Function Put10( const Name : String; const Value : TJsonNull) : TJsonValue;');
    RegisterMethod('Function Put11( const Name : String; const Value : Boolean) : TJsonValue;');
    RegisterMethod('Function Put12( const Name : String; const Value : Integer) : TJsonValue;');
    RegisterMethod('Function Put13( const Name : String; const Value : Extended) : TJsonValue;');
    RegisterMethod('Function Put14( const Name : String; const Value : String) : TJsonValue;');
    RegisterMethod('Function Put15( const Name : String; const Value : TJsonArray2) : TJsonValue;');
    RegisterMethod('Function Put16( const Name : String; const Value : TJsonObject2) : TJsonValue;');
    RegisterMethod('Function Put17( const Name : String; const Value : TJsonValue) : TJsonValue;');
    RegisterMethod('Function Put18( const Value : TJsonPair) : TJsonValue;');
    RegisterMethod('Function Putbool( const Name : String; const Value : Boolean) : TJsonValue;');
    RegisterMethod('Function Putint( const Name : String; const Value : Integer) : TJsonValue;');
    RegisterMethod('Function Putext( const Name : String; const Value : Extended) : TJsonValue;');
    RegisterMethod('Function Putstr( const Name : String; const Value : String) : TJsonValue;');
    RegisterMethod('Function Putarr( const Name : String; const Value : TJsonArray2) : TJsonValue;');
    RegisterMethod('Function Putobj( const Name : String; const Value : TJsonObject2) : TJsonValue;');
    RegisterMethod('Function Putval( const Name : String; const Value : TJsonValue) : TJsonValue;');
    RegisterMethod('Function Putpair( const Value : TJsonPair) : TJsonValue;');

    RegisterMethod('Function Find( const Name : String) : Integer');
    RegisterMethod('Procedure Delete19( const Index : Integer);');
    RegisterMethod('Procedure Delete20( const Name : String);');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'TJsonPair Integer', iptr);
    RegisterProperty('Values', 'TJsonValue String', iptr);
    SetDefaultPropery('Values');
    RegisterProperty('AutoAdd', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsonPair(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJsonBase', 'TJsonPair') do
  with CL.AddClassN(CL.FindClass('TJsonBase'),'TJsonPair') do begin
    RegisterMethod('Constructor Create( AOwner : TJsonBase; const AName : String)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Parse( JsonString : String)');
    RegisterMethod('Function Stringify : String');
    RegisterMethod('Procedure Assign( Source : TJsonBase)');
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('Value', 'TJsonValue', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsonArray2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJsonBase', 'TJsonArray2') do
  with CL.AddClassN(CL.FindClass('TJsonBase'),'TJsonArray2') do begin
    RegisterMethod('Constructor Create( AOwner : TJsonBase)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Parse( JsonString : String)');
    RegisterMethod('Function Stringify : String');
    RegisterMethod('Procedure Assign( Source : TJsonBase)');
    RegisterMethod('Procedure Merge( Addition : TJsonArray2)');
    RegisterMethod('Function Add : TJsonValue');
    RegisterMethod('Function Insert( const Index : Integer) : TJsonValue');
    RegisterMethod('Function Put0( const Value : TJsonEmpty) : TJsonValue;');
    RegisterMethod('Function Put1( const Value : TJsonNull) : TJsonValue;');
    RegisterMethod('Function Put2( const Value : Boolean) : TJsonValue;');
    RegisterMethod('Function Put3( const Value : Integer) : TJsonValue;');
    RegisterMethod('Function Put4( const Value : Extended) : TJsonValue;');
    RegisterMethod('Function Put5( const Value : String) : TJsonValue;');
    RegisterMethod('Function Put6( const Value : TJsonArray2) : TJsonValue;');
    RegisterMethod('Function Put7( const Value : TJsonObject2) : TJsonValue;');
    RegisterMethod('Function Put8( const Value : TJsonValue) : TJsonValue;');
    RegisterMethod('Procedure Delete( const Index : Integer)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'TJsonValue Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsonValue(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJsonBase', 'TJsonValue') do
  with CL.AddClassN(CL.FindClass('TJsonBase'),'TJsonValue') do begin
    RegisterMethod('Constructor Create( AOwner : TJsonBase)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Parse( JsonString : String)');
    RegisterMethod('Function Stringify : String');
    RegisterMethod('Procedure Assign( Source : TJsonBase)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('ValueType', 'TJsonValueType', iptr);
    RegisterProperty('AsString', 'String', iptrw);
    RegisterProperty('AsNumber', 'Extended', iptrw);
    RegisterProperty('AsInteger', 'Integer', iptrw);
    RegisterProperty('AsBoolean', 'Boolean', iptrw);
    RegisterProperty('AsObject', 'TJsonObject2', iptrw);
    RegisterProperty('AsArray', 'TJsonArray2', iptrw);
    RegisterProperty('IsNull', 'Boolean', iptrw);
    RegisterProperty('IsEmpty', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsonBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJsonBase') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJsonBase') do  begin
    RegisterMethod('Constructor Create( AOwner : TJsonBase)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Parse( JsonString : String)');
    RegisterMethod('Function Stringify : String');
    RegisterMethod('Procedure Assign( Source : TJsonBase)');
    RegisterMethod('Function Encode( const S : String) : String');
    RegisterMethod('Function Decode( const S : String) : String');
    RegisterMethod('Procedure Split( const S : String; const Delimiter : Char; Strings : TStrings)');
    RegisterMethod('Function IsJsonObject( const S : String) : Boolean');
    RegisterMethod('Function IsJsonArray( const S : String) : Boolean');
    RegisterMethod('Function IsJsonString( const S : String) : Boolean');
    RegisterMethod('Function IsJsonNumber( const S : String) : Boolean');
    RegisterMethod('Function IsJsonBoolean( const S : String) : Boolean');
    RegisterMethod('Function IsJsonNull( const S : String) : Boolean');
    RegisterMethod('Function AnalyzeJsonValueType( const S : String) : TJsonValueType');
    RegisterProperty('Owner', 'TJsonBase', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Jsons(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJsonValueType', '( jvNone, jvNull, jvString, jvNumber, jvBoolean, jvObject, jvArray )');
  CL.AddTypeS('TJsonStructType', '( jsNone, jsArray, jsObject )');
  CL.AddTypeS('TJsonNull', '( jsnull2 )');
  CL.AddTypeS('TJsonEmpty', '( jsempty )');
  SIRegister_TJsonBase(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJsonObject2');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJsonArray2');
  SIRegister_TJsonValue(CL);
  SIRegister_TJsonArray2(CL);
  SIRegister_TJsonPair(CL);
  SIRegister_TJsonObject2(CL);
  SIRegister_TJson(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJsonValues_R(Self: TJson; var T: TJsonValue; const t1: String);
begin T := Self.Values[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJsonCount_R(Self: TJson; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJsonJsonArray_R(Self: TJson; var T: TJsonArray2);
begin T := Self.JsonArray; end;

(*----------------------------------------------------------------------------*)
procedure TJsonJsonObject_R(Self: TJson; var T: TJsonObject2);
begin T := Self.JsonObject; end;

(*----------------------------------------------------------------------------*)
procedure TJsonStructType_R(Self: TJson; var T: TJsonStructType);
begin T := Self.StructType; end;

(*----------------------------------------------------------------------------*)
Function TJsonPut45_P(Self: TJson;  const Value : TJsonPair) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut44_P(Self: TJson;  const Name : String; const Value : TJson) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut43_P(Self: TJson;  const Name : String; const Value : TJsonValue) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut42_P(Self: TJson;  const Name : String; const Value : TJsonObject2) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut41_P(Self: TJson;  const Name : String; const Value : TJsonArray2) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut40_P(Self: TJson;  const Name : String; const Value : String) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut39_P(Self: TJson;  const Name : String; const Value : Extended) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut38_P(Self: TJson;  const Name : String; const Value : Integer) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut37_P(Self: TJson;  const Name : String; const Value : Boolean) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut36_P(Self: TJson;  const Name : String; const Value : TJsonNull) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut35_P(Self: TJson;  const Name : String; const Value : TJsonEmpty) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut34_P(Self: TJson;  const Value : TJson) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut33_P(Self: TJson;  const Value : TJsonValue) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut32_P(Self: TJson;  const Value : TJsonObject2) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut31_P(Self: TJson;  const Value : TJsonArray2) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut30_P(Self: TJson;  const Value : String) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut29_P(Self: TJson;  const Value : Extended) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut28_P(Self: TJson;  const Value : Integer) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut27_P(Self: TJson;  const Value : Boolean) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut26_P(Self: TJson;  const Value : TJsonNull) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonPut25_P(Self: TJson;  const Value : TJsonEmpty) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonGet24_P(Self: TJson;  const Name : String) : TJsonValue;
Begin Result := Self.Get(Name); END;

(*----------------------------------------------------------------------------*)
Function TJsonGet23_P(Self: TJson;  const Index : Integer) : TJsonValue;
Begin Result := Self.Get(Index); END;

(*----------------------------------------------------------------------------*)
Procedure TJsonDelete22_P(Self: TJson;  const Name : String);
Begin Self.Delete(Name); END;

(*----------------------------------------------------------------------------*)
Procedure TJsonDelete21_P(Self: TJson;  const Index : Integer);
Begin Self.Delete(Index); END;

(*----------------------------------------------------------------------------*)
procedure TJsonObjectAutoAdd_W(Self: TJsonObject2; const T: Boolean);
begin Self.AutoAdd := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsonObjectAutoAdd_R(Self: TJsonObject2; var T: Boolean);
begin T := Self.AutoAdd; end;

(*----------------------------------------------------------------------------*)
procedure TJsonObjectValues_R(Self: TJsonObject2; var T: TJsonValue; const t1: String);
begin T := Self.Values[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJsonObjectItems_R(Self: TJsonObject2; var T: TJsonPair; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJsonObjectCount_R(Self: TJsonObject2; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
Procedure TJsonObjectDelete20_P(Self: TJsonObject2;  const Name : String);
Begin Self.Delete(Name); END;

(*----------------------------------------------------------------------------*)
Procedure TJsonObjectDelete19_P(Self: TJsonObject2;  const Index : Integer);
Begin Self.Delete(Index); END;

(*----------------------------------------------------------------------------*)
Function TJsonObjectPut18_P(Self: TJsonObject2;  const Value : TJsonPair) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonObjectPut17_P(Self: TJsonObject2;  const Name : String; const Value : TJsonValue) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonObjectPut16_P(Self: TJsonObject2;  const Name : String; const Value : TJsonObject2) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonObjectPut15_P(Self: TJsonObject2;  const Name : String; const Value : TJsonArray2) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonObjectPut14_P(Self: TJsonObject2;  const Name : String; const Value : String) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonObjectPut13_P(Self: TJsonObject2;  const Name : String; const Value : Extended) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonObjectPut12_P(Self: TJsonObject2;  const Name : String; const Value : Integer) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonObjectPut11_P(Self: TJsonObject2;  const Name : String; const Value : Boolean) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonObjectPut10_P(Self: TJsonObject2;  const Name : String; const Value : TJsonNull) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonObjectPut9_P(Self: TJsonObject2;  const Name : String; const Value : TJsonEmpty) : TJsonValue;
Begin Result := Self.Put(Name, Value); END;

(*----------------------------------------------------------------------------*)
procedure TJsonPairValue_R(Self: TJsonPair; var T: TJsonValue);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TJsonPairName_W(Self: TJsonPair; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsonPairName_R(Self: TJsonPair; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJsonArrayItems_R(Self: TJsonArray2; var T: TJsonValue; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJsonArrayCount_R(Self: TJsonArray2; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
Function TJsonArrayPut8_P(Self: TJsonArray2;  const Value : TJsonValue) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonArrayPut7_P(Self: TJsonArray2;  const Value : TJsonObject2) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonArrayPut6_P(Self: TJsonArray2;  const Value : TJsonArray2) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonArrayPut5_P(Self: TJsonArray2;  const Value : String) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonArrayPut4_P(Self: TJsonArray2;  const Value : Extended) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonArrayPut3_P(Self: TJsonArray2;  const Value : Integer) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonArrayPut2_P(Self: TJsonArray2;  const Value : Boolean) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonArrayPut1_P(Self: TJsonArray2;  const Value : TJsonNull) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
Function TJsonArrayPut0_P(Self: TJsonArray2;  const Value : TJsonEmpty) : TJsonValue;
Begin Result := Self.Put(Value); END;

(*----------------------------------------------------------------------------*)
procedure TJsonValueIsEmpty_W(Self: TJsonValue; const T: Boolean);
begin Self.IsEmpty := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueIsEmpty_R(Self: TJsonValue; var T: Boolean);
begin T := Self.IsEmpty; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueIsNull_W(Self: TJsonValue; const T: Boolean);
begin Self.IsNull := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueIsNull_R(Self: TJsonValue; var T: Boolean);
begin T := Self.IsNull; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsArray_W(Self: TJsonValue; const T: TJsonArray2);
begin Self.AsArray := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsArray_R(Self: TJsonValue; var T: TJsonArray2);
begin T := Self.AsArray; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsObject_W(Self: TJsonValue; const T: TJsonObject2);
begin Self.AsObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsObject_R(Self: TJsonValue; var T: TJsonObject2);
begin T := Self.AsObject; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsBoolean_W(Self: TJsonValue; const T: Boolean);
begin Self.AsBoolean := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsBoolean_R(Self: TJsonValue; var T: Boolean);
begin T := Self.AsBoolean; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsInteger_W(Self: TJsonValue; const T: Integer);
begin Self.AsInteger := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsInteger_R(Self: TJsonValue; var T: Integer);
begin T := Self.AsInteger; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsNumber_W(Self: TJsonValue; const T: Extended);
begin Self.AsNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsNumber_R(Self: TJsonValue; var T: Extended);
begin T := Self.AsNumber; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsString_W(Self: TJsonValue; const T: String);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueAsString_R(Self: TJsonValue; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TJsonValueValueType_R(Self: TJsonValue; var T: TJsonValueType);
begin T := Self.ValueType; end;

(*----------------------------------------------------------------------------*)
procedure TJsonBaseOwner_R(Self: TJsonBase; var T: TJsonBase);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJson(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJson) do begin
    RegisterConstructor(@TJson.Create, 'Create');
    RegisterMethod(@TJson.Destroy, 'Free');
    RegisterMethod(@TJson.Parse, 'Parse');
    RegisterMethod(@TJson.Stringify, 'Stringify');
    RegisterMethod(@TJson.Assign, 'Assign');
    RegisterMethod(@TJsonDelete21_P, 'Delete21');
    RegisterMethod(@TJsonDelete22_P, 'Delete22');
    RegisterMethod(@TJson.Clear, 'Clear');
    RegisterMethod(@TJsonGet23_P, 'Get23');
    RegisterMethod(@TJsonGet24_P, 'Get24');
    RegisterMethod(@TJsonPut25_P, 'Put25');
    RegisterMethod(@TJsonPut26_P, 'Put26');
    RegisterMethod(@TJsonPut27_P, 'Put27');
    RegisterMethod(@TJsonPut28_P, 'Put28');
    RegisterMethod(@TJsonPut29_P, 'Put29');
    RegisterMethod(@TJsonPut30_P, 'Put30');
    RegisterMethod(@TJsonPut31_P, 'Put31');
    RegisterMethod(@TJsonPut32_P, 'Put32');
    RegisterMethod(@TJsonPut33_P, 'Put33');
    RegisterMethod(@TJsonPut34_P, 'Put34');
    RegisterMethod(@TJsonPut27_P, 'Putbool');
    RegisterMethod(@TJsonPut28_P, 'Putint');
    RegisterMethod(@TJsonPut29_P, 'Putext');
    RegisterMethod(@TJsonPut30_P, 'Putstr');
    RegisterMethod(@TJsonPut31_P, 'Putarr');
    RegisterMethod(@TJsonPut32_P, 'Putobj');
    RegisterMethod(@TJsonPut33_P, 'Putval');
    RegisterMethod(@TJsonPut34_P, 'Putjson');

    RegisterMethod(@TJsonPut35_P, 'Put35');
    RegisterMethod(@TJsonPut36_P, 'Put36');
    RegisterMethod(@TJsonPut37_P, 'Put37');
    RegisterMethod(@TJsonPut38_P, 'Put38');
    RegisterMethod(@TJsonPut39_P, 'Put39');
    RegisterMethod(@TJsonPut40_P, 'Put40');
    RegisterMethod(@TJsonPut41_P, 'Put41');
    RegisterMethod(@TJsonPut42_P, 'Put42');
    RegisterMethod(@TJsonPut43_P, 'Put43');
    RegisterMethod(@TJsonPut44_P, 'Put44');
    RegisterMethod(@TJsonPut45_P, 'Put45');
    RegisterPropertyHelper(@TJsonStructType_R,nil,'StructType');
    RegisterPropertyHelper(@TJsonJsonObject_R,nil,'JsonObject');
    RegisterPropertyHelper(@TJsonJsonArray_R,nil,'JsonArray');
    RegisterPropertyHelper(@TJsonCount_R,nil,'Count');
    RegisterPropertyHelper(@TJsonValues_R,nil,'Values');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsonObject2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsonObject2) do begin
    RegisterConstructor(@TJsonObject2.Create, 'Create');
    RegisterMethod(@TJsonObject2.Destroy, 'Free');
    RegisterMethod(@TJsonObject2.Parse, 'Parse');
    RegisterMethod(@TJsonObject2.Assign, 'Assign');
    RegisterMethod(@TJsonObject2.Merge, 'Merge');
    RegisterMethod(@TJsonObject2.Add, 'Add');
    RegisterMethod(@TJsonObject2.Stringify, 'Stringify');
    RegisterMethod(@TJsonObject2.Insert, 'Insert');
    RegisterMethod(@TJsonObjectPut9_P, 'Put9');
    RegisterMethod(@TJsonObjectPut10_P, 'Put10');
    RegisterMethod(@TJsonObjectPut11_P, 'Put11');
    RegisterMethod(@TJsonObjectPut12_P, 'Put12');
    RegisterMethod(@TJsonObjectPut13_P, 'Put13');
    RegisterMethod(@TJsonObjectPut14_P, 'Put14');
    RegisterMethod(@TJsonObjectPut15_P, 'Put15');
    RegisterMethod(@TJsonObjectPut16_P, 'Put16');
    RegisterMethod(@TJsonObjectPut17_P, 'Put17');
    RegisterMethod(@TJsonObjectPut18_P, 'Put18');
    RegisterMethod(@TJsonObjectPut11_P, 'Putbool');
    RegisterMethod(@TJsonObjectPut12_P, 'Putint');
    RegisterMethod(@TJsonObjectPut13_P, 'Putext');
    RegisterMethod(@TJsonObjectPut14_P, 'Putstr');
    RegisterMethod(@TJsonObjectPut15_P, 'Putarr');
    RegisterMethod(@TJsonObjectPut16_P, 'Putobj');
    RegisterMethod(@TJsonObjectPut17_P, 'Putval');
    RegisterMethod(@TJsonObjectPut18_P, 'Putpair');

    RegisterMethod(@TJsonObject2.Find, 'Find');
    RegisterMethod(@TJsonObjectDelete19_P, 'Delete19');
    RegisterMethod(@TJsonObjectDelete20_P, 'Delete20');
    RegisterMethod(@TJsonObject2.Clear, 'Clear');
    RegisterPropertyHelper(@TJsonObjectCount_R,nil,'Count');
    RegisterPropertyHelper(@TJsonObjectItems_R,nil,'Items');
    RegisterPropertyHelper(@TJsonObjectValues_R,nil,'Values');
    RegisterPropertyHelper(@TJsonObjectAutoAdd_R,@TJsonObjectAutoAdd_W,'AutoAdd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsonPair(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsonPair) do begin
    RegisterConstructor(@TJsonPair.Create, 'Create');
    RegisterMethod(@TJsonPair.Destroy, 'Free');
    RegisterMethod(@TJsonPair.Parse, 'Parse');
    RegisterMethod(@TJsonPair.Stringify, 'Stringify');
    RegisterMethod(@TJsonPair.Assign, 'Assign');
    RegisterPropertyHelper(@TJsonPairName_R,@TJsonPairName_W,'Name');
    RegisterPropertyHelper(@TJsonPairValue_R,nil,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsonArray2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsonArray2) do begin
    RegisterConstructor(@TJsonArray2.Create, 'Create');
    RegisterMethod(@TJsonArray2.Destroy, 'Free');
    RegisterMethod(@TJsonArray2.Parse, 'Parse');
    RegisterMethod(@TJsonArray2.Stringify, 'Stringify');
    RegisterMethod(@TJsonArray2.Assign, 'Assign');
    RegisterMethod(@TJsonArray2.Merge, 'Merge');
    RegisterMethod(@TJsonArray2.Add, 'Add');
    RegisterMethod(@TJsonArray2.Insert, 'Insert');
    RegisterMethod(@TJsonArrayPut0_P, 'Put0');
    RegisterMethod(@TJsonArrayPut1_P, 'Put1');
    RegisterMethod(@TJsonArrayPut2_P, 'Put2');
    RegisterMethod(@TJsonArrayPut3_P, 'Put3');
    RegisterMethod(@TJsonArrayPut4_P, 'Put4');
    RegisterMethod(@TJsonArrayPut5_P, 'Put5');
    RegisterMethod(@TJsonArrayPut6_P, 'Put6');
    RegisterMethod(@TJsonArrayPut7_P, 'Put7');
    RegisterMethod(@TJsonArrayPut8_P, 'Put8');
    RegisterMethod(@TJsonArray2.Delete, 'Delete');
    RegisterMethod(@TJsonArray2.Clear, 'Clear');
    RegisterPropertyHelper(@TJsonArrayCount_R,nil,'Count');
    RegisterPropertyHelper(@TJsonArrayItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsonValue(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsonValue) do begin
    RegisterConstructor(@TJsonValue.Create, 'Create');
    RegisterMethod(@TJsonValue.Destroy, 'Free');
    RegisterMethod(@TJsonValue.Parse, 'Parse');
    RegisterMethod(@TJsonValue.Stringify, 'Stringify');
    RegisterMethod(@TJsonValue.Assign, 'Assign');
    RegisterMethod(@TJsonValue.Clear, 'Clear');
    RegisterPropertyHelper(@TJsonValueValueType_R,nil,'ValueType');
    RegisterPropertyHelper(@TJsonValueAsString_R,@TJsonValueAsString_W,'AsString');
    RegisterPropertyHelper(@TJsonValueAsNumber_R,@TJsonValueAsNumber_W,'AsNumber');
    RegisterPropertyHelper(@TJsonValueAsInteger_R,@TJsonValueAsInteger_W,'AsInteger');
    RegisterPropertyHelper(@TJsonValueAsBoolean_R,@TJsonValueAsBoolean_W,'AsBoolean');
    RegisterPropertyHelper(@TJsonValueAsObject_R,@TJsonValueAsObject_W,'AsObject');
    RegisterPropertyHelper(@TJsonValueAsArray_R,@TJsonValueAsArray_W,'AsArray');
    RegisterPropertyHelper(@TJsonValueIsNull_R,@TJsonValueIsNull_W,'IsNull');
    RegisterPropertyHelper(@TJsonValueIsEmpty_R,@TJsonValueIsEmpty_W,'IsEmpty');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsonBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsonBase) do begin
    RegisterConstructor(@TJsonBase.Create, 'Create');
    RegisterMethod(@TJsonBase.Destroy, 'Free');
    //RegisterVirtualAbstractMethod(@TJsonBase, @!.Parse, 'Parse');
    //RegisterVirtualAbstractMethod(@TJsonBase, @!.Stringify, 'Stringify');
    //RegisterVirtualAbstractMethod(@TJsonBase, @!.Assign, 'Assign');
    RegisterMethod(@TJsonBase.Encode, 'Encode');
    RegisterMethod(@TJsonBase.Decode, 'Decode');
    RegisterMethod(@TJsonBase.Split, 'Split');
    RegisterMethod(@TJsonBase.IsJsonObject, 'IsJsonObject');
    RegisterMethod(@TJsonBase.IsJsonArray, 'IsJsonArray');
    RegisterMethod(@TJsonBase.IsJsonString, 'IsJsonString');
    RegisterMethod(@TJsonBase.IsJsonNumber, 'IsJsonNumber');
    RegisterMethod(@TJsonBase.IsJsonBoolean, 'IsJsonBoolean');
    RegisterMethod(@TJsonBase.IsJsonNull, 'IsJsonNull');
    RegisterMethod(@TJsonBase.AnalyzeJsonValueType, 'AnalyzeJsonValueType');
    RegisterPropertyHelper(@TJsonBaseOwner_R,nil,'Owner');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Jsons(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJsonBase(CL);
  with CL.Add(TJsonObject2) do
  with CL.Add(TJsonArray2) do
  RIRegister_TJsonValue(CL);
  RIRegister_TJsonArray2(CL);
  RIRegister_TJsonPair(CL);
  RIRegister_TJsonObject2(CL);
  RIRegister_TJson(CL);
end;

 
 
{ TPSImport_Jsons }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Jsons.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Jsons(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Jsons.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Jsons(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
