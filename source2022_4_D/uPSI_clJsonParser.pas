unit uPSI_clJsonParser;
{
another approach in rest api api.parser.com    with stringbuilder

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
  TPSImport_clJsonParser = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TclJSONObject(CL: TPSPascalCompiler);
procedure SIRegister_TclJSONArray(CL: TPSPascalCompiler);
procedure SIRegister_TclJSONBoolean(CL: TPSPascalCompiler);
procedure SIRegister_TclJSONString(CL: TPSPascalCompiler);
procedure SIRegister_TclJSONValue(CL: TPSPascalCompiler);
procedure SIRegister_TclJSONPair(CL: TPSPascalCompiler);
procedure SIRegister_TclJSONBase(CL: TPSPascalCompiler);
procedure SIRegister_EclJSONError(CL: TPSPascalCompiler);
procedure SIRegister_clJsonParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TclJSONObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TclJSONArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TclJSONBoolean(CL: TPSRuntimeClassImporter);
procedure RIRegister_TclJSONString(CL: TPSRuntimeClassImporter);
procedure RIRegister_TclJSONValue(CL: TPSRuntimeClassImporter);
procedure RIRegister_TclJSONPair(CL: TPSRuntimeClassImporter);
procedure RIRegister_TclJSONBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_EclJSONError(CL: TPSRuntimeClassImporter);
procedure RIRegister_clJsonParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,clJsonParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_clJsonParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TclJSONObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TclJSONBase', 'TclJSONObject') do
  with CL.AddClassN(CL.FindClass('TclJSONBase'),'TclJSONObject') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Function MemberByName( const AName : string) : TclJSONPair;');
    RegisterMethod('Function MemberByName6( const AName : WideString) : TclJSONPair;');
    RegisterMethod('Function ValueByName( const AName : string) : string;');
    RegisterMethod('Function ValueByName7( const AName : string) : string;');
    RegisterMethod('Function ValueByName8( const AName : WideString) : WideString;');
    RegisterMethod('Function ObjectByName( const AName : string) : TclJSONObject;');
    RegisterMethod('Function ObjectByName9( const AName : string) : TclJSONObject;');
    RegisterMethod('Function ObjectByName10( const AName : WideString) : TclJSONObject;');
    RegisterMethod('Function ArrayByName11( const AName : string) : TclJSONArray;');
    RegisterMethod('Function ArrayByName( const AName : string) : TclJSONArray;');
    RegisterMethod('Function ArrayByName12( const AName : WideString) : TclJSONArray;');
    RegisterMethod('Function BooleanByName13( const AName : string) : Boolean;');
    RegisterMethod('Function BooleanByName( const AName : string) : Boolean;');
    RegisterMethod('Function BooleanByName14( const AName : WideString) : Boolean;');
    RegisterMethod('Function AddMember15( APair : TclJSONPair) : TclJSONPair;');
   RegisterMethod('Function AddMember( APair : TclJSONPair) : TclJSONPair;');

    RegisterMethod('Function AddMember16( const AName : WideString; AValue : TclJSONBase) : TclJSONPair;');
    RegisterMethod('Function AddMember17( const AName : string; AValue : TclJSONBase) : TclJSONPair;');
    RegisterMethod('Function AddString18( const AName, AValue : string) : TclJSONString;');
    RegisterMethod('Function AddString( const AName, AValue : string) : TclJSONString;');

    RegisterMethod('Function AddString19( const AName, AValue : WideString) : TclJSONString;');
    RegisterMethod('Function AddRequiredString20( const AName, AValue : string) : TclJSONString;');
    RegisterMethod('Function AddRequiredString21( const AName, AValue : WideString) : TclJSONString;');
    RegisterMethod('Function AddValue22( const AName, AValue : string) : TclJSONValue;');
    RegisterMethod('Function AddValue( const AName, AValue : string) : TclJSONValue;');
    RegisterMethod('Function AddValue23( const AName, AValue : WideString) : TclJSONValue;');
    RegisterMethod('Function AddBoolean24( const AName : string; AValue : Boolean) : TclJSONBoolean;');
    RegisterMethod('Function AddBoolean( const AName : string; AValue : Boolean) : TclJSONBoolean;');
    RegisterMethod('Function AddBoolean25( const AName : WideString; AValue : Boolean) : TclJSONBoolean;');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Members', 'TclJSONPair Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TclJSONArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TclJSONBase', 'TclJSONArray') do
  with CL.AddClassN(CL.FindClass('TclJSONBase'),'TclJSONArray') do
  begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Function Add( AItem : TclJSONBase) : TclJSONBase');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'TclJSONBase Integer', iptr);
    RegisterProperty('Objects', 'TclJSONObject Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TclJSONBoolean(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TclJSONValue', 'TclJSONBoolean') do
  with CL.AddClassN(CL.FindClass('TclJSONValue'),'TclJSONBoolean') do
  begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create4( AValue : Boolean);');
    RegisterProperty('Value', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TclJSONString(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TclJSONValue', 'TclJSONString') do
  with CL.AddClassN(CL.FindClass('TclJSONValue'),'TclJSONString') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TclJSONValue(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TclJSONBase', 'TclJSONValue') do
  with CL.AddClassN(CL.FindClass('TclJSONBase'),'TclJSONValue') do
  begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( const AValue : string);');
    RegisterMethod('Constructor Create2( const AValue : WideString);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TclJSONPair(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TclJSONBase', 'TclJSONPair') do
  with CL.AddClassN(CL.FindClass('TclJSONBase'),'TclJSONPair') do
  begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free;');
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('NameWideString', 'WideString', iptrw);
    RegisterProperty('Value', 'TclJSONBase', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TclJSONBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TclJSONBase') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TclJSONBase') do
  begin
    RegisterMethod('Function Parse( const AJSONString : string) : TclJSONBase');
    RegisterMethod('Function ParseObject( const AJSONString : string) : TclJSONObject');
    RegisterMethod('Function GetJSONString : string');
    RegisterProperty('ValueString', 'string', iptrw);
    RegisterProperty('ValueWideString', 'WideString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EclJSONError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EclJSONError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EclJSONError') do
  begin
    RegisterMethod('Constructor Create( const AErrorMsg : string; AErrorCode : Integer; ADummy : Boolean)');
    RegisterProperty('ErrorCode', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_clJsonParser(CL: TPSPascalCompiler);
begin
  SIRegister_EclJSONError(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TclJSONString');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TclJSONPair');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TclJSONObject');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TclJSONArray');
  SIRegister_TclJSONBase(CL);
  SIRegister_TclJSONPair(CL);
  SIRegister_TclJSONValue(CL);
  SIRegister_TclJSONString(CL);
  SIRegister_TclJSONBoolean(CL);
  SIRegister_TclJSONArray(CL);
  SIRegister_TclJSONObject(CL);
 CL.AddConstantN('cUnexpectedDataEndCode','LongInt').SetInt( - 100);
 CL.AddConstantN('cUnexpectedDataSymbolCode','LongInt').SetInt( - 101);
 CL.AddConstantN('cInvalidControlSymbolCode','LongInt').SetInt( - 102);
 CL.AddConstantN('cInvalidUnicodeEscSequenceCode','LongInt').SetInt( - 103);
 CL.AddConstantN('cUnrecognizedEscSequenceCode','LongInt').SetInt( - 104);
 CL.AddConstantN('cUnexpectedDataTypeCode','LongInt').SetInt( - 106);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TclJSONObjectMembers_R(Self: TclJSONObject; var T: TclJSONPair; const t1: Integer);
begin T := Self.Members[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONObjectCount_R(Self: TclJSONObject; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectAddBoolean25_P(Self: TclJSONObject;  const AName : WideString; AValue : Boolean) : TclJSONBoolean;
Begin Result := Self.AddBoolean(AName, AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectAddBoolean24_P(Self: TclJSONObject;  const AName : string; AValue : Boolean) : TclJSONBoolean;
Begin Result := Self.AddBoolean(AName, AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectAddValue23_P(Self: TclJSONObject;  const AName, AValue : WideString) : TclJSONValue;
Begin Result := Self.AddValue(AName, AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectAddValue22_P(Self: TclJSONObject;  const AName, AValue : string) : TclJSONValue;
Begin Result := Self.AddValue(AName, AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectAddRequiredString21_P(Self: TclJSONObject;  const AName, AValue : WideString) : TclJSONString;
Begin Result := Self.AddRequiredString(AName, AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectAddRequiredString20_P(Self: TclJSONObject;  const AName, AValue : string) : TclJSONString;
Begin Result := Self.AddRequiredString(AName, AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectAddString19_P(Self: TclJSONObject;  const AName, AValue : WideString) : TclJSONString;
Begin Result := Self.AddString(AName, AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectAddString18_P(Self: TclJSONObject;  const AName, AValue : string) : TclJSONString;
Begin Result := Self.AddString(AName, AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectAddMember17_P(Self: TclJSONObject;  const AName : string; AValue : TclJSONBase) : TclJSONPair;
Begin Result := Self.AddMember(AName, AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectAddMember16_P(Self: TclJSONObject;  const AName : WideString; AValue : TclJSONBase) : TclJSONPair;
Begin Result := Self.AddMember(AName, AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectAddMember15_P(Self: TclJSONObject;  APair : TclJSONPair) : TclJSONPair;
Begin Result := Self.AddMember(APair); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectBooleanByName14_P(Self: TclJSONObject;  const AName : WideString) : Boolean;
Begin Result := Self.BooleanByName(AName); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectBooleanByName13_P(Self: TclJSONObject;  const AName : string) : Boolean;
Begin Result := Self.BooleanByName(AName); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectArrayByName12_P(Self: TclJSONObject;  const AName : WideString) : TclJSONArray;
Begin Result := Self.ArrayByName(AName); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectArrayByName11_P(Self: TclJSONObject;  const AName : string) : TclJSONArray;
Begin Result := Self.ArrayByName(AName); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectObjectByName10_P(Self: TclJSONObject;  const AName : WideString) : TclJSONObject;
Begin Result := Self.ObjectByName(AName); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectObjectByName9_P(Self: TclJSONObject;  const AName : string) : TclJSONObject;
Begin Result := Self.ObjectByName(AName); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectValueByName8_P(Self: TclJSONObject;  const AName : WideString) : WideString;
Begin Result := Self.ValueByName(AName); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectValueByName7_P(Self: TclJSONObject;  const AName : string) : string;
Begin Result := Self.ValueByName(AName); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectMemberByName6_P(Self: TclJSONObject;  const AName : WideString) : TclJSONPair;
Begin Result := Self.MemberByName(AName); END;

(*----------------------------------------------------------------------------*)
Function TclJSONObjectMemberByName5_P(Self: TclJSONObject;  const AName : string) : TclJSONPair;
Begin Result := Self.MemberByName(AName); END;

(*----------------------------------------------------------------------------*)
procedure TclJSONArrayObjects_R(Self: TclJSONArray; var T: TclJSONObject; const t1: Integer);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONArrayItems_R(Self: TclJSONArray; var T: TclJSONBase; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONArrayCount_R(Self: TclJSONArray; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONBooleanValue_W(Self: TclJSONBoolean; const T: Boolean);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONBooleanValue_R(Self: TclJSONBoolean; var T: Boolean);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
Function TclJSONBooleanCreate4_P(Self: TClass; CreateNewInstance: Boolean;  AValue : Boolean):TObject;
Begin Result := TclJSONBoolean.Create(AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONBooleanCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TclJSONBoolean.Create; END;

(*----------------------------------------------------------------------------*)
Function TclJSONValueCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const AValue : WideString):TObject;
Begin Result := TclJSONValue.Create(AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONValueCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const AValue : string):TObject;
Begin Result := TclJSONValue.Create(AValue); END;

(*----------------------------------------------------------------------------*)
Function TclJSONValueCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TclJSONValue.Create; END;

(*----------------------------------------------------------------------------*)
procedure TclJSONPairValue_W(Self: TclJSONPair; const T: TclJSONBase);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONPairValue_R(Self: TclJSONPair; var T: TclJSONBase);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONPairNameWideString_W(Self: TclJSONPair; const T: WideString);
begin Self.NameWideString := T; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONPairNameWideString_R(Self: TclJSONPair; var T: WideString);
begin T := Self.NameWideString; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONPairName_W(Self: TclJSONPair; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONPairName_R(Self: TclJSONPair; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONBaseValueWideString_W(Self: TclJSONBase; const T: WideString);
begin Self.ValueWideString := T; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONBaseValueWideString_R(Self: TclJSONBase; var T: WideString);
begin T := Self.ValueWideString; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONBaseValueString_W(Self: TclJSONBase; const T: string);
begin Self.ValueString := T; end;

(*----------------------------------------------------------------------------*)
procedure TclJSONBaseValueString_R(Self: TclJSONBase; var T: string);
begin T := Self.ValueString; end;

(*----------------------------------------------------------------------------*)
procedure EclJSONErrorErrorCode_R(Self: EclJSONError; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TclJSONObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TclJSONObject) do
  begin
    RegisterConstructor(@TclJSONObject.Create, 'Create');
    RegisterMethod(@TclJSONObject.Destroy, 'Free');
    RegisterMethod(@TclJSONObjectMemberByName5_P, 'MemberByName');
    RegisterMethod(@TclJSONObjectMemberByName6_P, 'MemberByName6');
    RegisterMethod(@TclJSONObjectValueByName7_P, 'ValueByName7');
    RegisterMethod(@TclJSONObjectValueByName7_P, 'ValueByName');
    RegisterMethod(@TclJSONObjectValueByName8_P, 'ValueByName8');
    RegisterMethod(@TclJSONObjectObjectByName9_P, 'ObjectByName9');
    RegisterMethod(@TclJSONObjectObjectByName9_P, 'ObjectByName');
    RegisterMethod(@TclJSONObjectObjectByName10_P, 'ObjectByName10');
    RegisterMethod(@TclJSONObjectArrayByName11_P, 'ArrayByName11');
     RegisterMethod(@TclJSONObjectArrayByName11_P, 'ArrayByName');
    RegisterMethod(@TclJSONObjectArrayByName12_P, 'ArrayByName12');
    RegisterMethod(@TclJSONObjectBooleanByName13_P, 'BooleanByName13');
    RegisterMethod(@TclJSONObjectBooleanByName13_P, 'BooleanByName');

    RegisterMethod(@TclJSONObjectBooleanByName14_P, 'BooleanByName14');
    RegisterMethod(@TclJSONObjectAddMember15_P, 'AddMember15');
    RegisterMethod(@TclJSONObjectAddMember15_P, 'AddMember');
    RegisterMethod(@TclJSONObjectAddMember16_P, 'AddMember16');
    RegisterMethod(@TclJSONObjectAddMember17_P, 'AddMember17');
    RegisterMethod(@TclJSONObjectAddString18_P, 'AddString18');
    RegisterMethod(@TclJSONObjectAddString18_P, 'AddString');
    RegisterMethod(@TclJSONObjectAddString19_P, 'AddString19');
    RegisterMethod(@TclJSONObjectAddRequiredString20_P, 'AddRequiredString20');
    RegisterMethod(@TclJSONObjectAddRequiredString21_P, 'AddRequiredString21');
    RegisterMethod(@TclJSONObjectAddValue22_P, 'AddValue22');
    RegisterMethod(@TclJSONObjectAddValue22_P, 'AddValue');
    RegisterMethod(@TclJSONObjectAddValue23_P, 'AddValue23');
    RegisterMethod(@TclJSONObjectAddBoolean24_P, 'AddBoolean24');
    RegisterMethod(@TclJSONObjectAddBoolean24_P, 'AddBoolean');
    RegisterMethod(@TclJSONObjectAddBoolean25_P, 'AddBoolean25');
    RegisterPropertyHelper(@TclJSONObjectCount_R,nil,'Count');
    RegisterPropertyHelper(@TclJSONObjectMembers_R,nil,'Members');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TclJSONArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TclJSONArray) do
  begin
    RegisterConstructor(@TclJSONArray.Create, 'Create');
    RegisterMethod(@TclJSONArray.Destroy, 'Free');
    RegisterMethod(@TclJSONArray.Add, 'Add');
    RegisterPropertyHelper(@TclJSONArrayCount_R,nil,'Count');
    RegisterPropertyHelper(@TclJSONArrayItems_R,nil,'Items');
    RegisterPropertyHelper(@TclJSONArrayObjects_R,nil,'Objects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TclJSONBoolean(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TclJSONBoolean) do
  begin
    RegisterConstructor(@TclJSONBooleanCreate_P, 'Create');
    RegisterConstructor(@TclJSONBooleanCreate4_P, 'Create4');
    RegisterPropertyHelper(@TclJSONBooleanValue_R,@TclJSONBooleanValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TclJSONString(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TclJSONString) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TclJSONValue(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TclJSONValue) do
  begin
    RegisterConstructor(@TclJSONValueCreate_P, 'Create');
    RegisterConstructor(@TclJSONValueCreate1_P, 'Create1');
    RegisterConstructor(@TclJSONValueCreate2_P, 'Create2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TclJSONPair(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TclJSONPair) do
  begin
    RegisterConstructor(@TclJSONPair.Create, 'Create');
    RegisterMethod(@TclJSONPair.Destroy, 'Free');
    RegisterPropertyHelper(@TclJSONPairName_R,@TclJSONPairName_W,'Name');
    RegisterPropertyHelper(@TclJSONPairNameWideString_R,@TclJSONPairNameWideString_W,'NameWideString');
    RegisterPropertyHelper(@TclJSONPairValue_R,@TclJSONPairValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TclJSONBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TclJSONBase) do
  begin
    RegisterMethod(@TclJSONBase.Parse, 'Parse');
    RegisterMethod(@TclJSONBase.ParseObject, 'ParseObject');
    RegisterMethod(@TclJSONBase.GetJSONString, 'GetJSONString');
    RegisterPropertyHelper(@TclJSONBaseValueString_R,@TclJSONBaseValueString_W,'ValueString');
    RegisterPropertyHelper(@TclJSONBaseValueWideString_R,@TclJSONBaseValueWideString_W,'ValueWideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EclJSONError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EclJSONError) do
  begin
    RegisterConstructor(@EclJSONError.Create, 'Create');
    RegisterPropertyHelper(@EclJSONErrorErrorCode_R,nil,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_clJsonParser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EclJSONError(CL);
  with CL.Add(TclJSONString) do
  with CL.Add(TclJSONPair) do
  with CL.Add(TclJSONObject) do
  with CL.Add(TclJSONArray) do
  RIRegister_TclJSONBase(CL);
  RIRegister_TclJSONPair(CL);
  RIRegister_TclJSONValue(CL);
  RIRegister_TclJSONString(CL);
  RIRegister_TclJSONBoolean(CL);
  RIRegister_TclJSONArray(CL);
  RIRegister_TclJSONObject(CL);
end;

 
 
{ TPSImport_clJsonParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_clJsonParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_clJsonParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_clJsonParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_clJsonParser(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
