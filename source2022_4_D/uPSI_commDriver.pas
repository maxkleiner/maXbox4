unit uPSI_commDriver;
{
Tservice manager to prototype   - rename tparameter2   - with module2

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
  TPSImport_commDriver = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCommDriver(CL: TPSPascalCompiler);
procedure SIRegister_TWaiter(CL: TPSPascalCompiler);
procedure SIRegister_TModuleList2(CL: TPSPascalCompiler);
procedure SIRegister_TModule2(CL: TPSPascalCompiler);
procedure SIRegister_TMetaData(CL: TPSPascalCompiler);
procedure SIRegister_TParameter2(CL: TPSPascalCompiler);
procedure SIRegister_TFloatType2(CL: TPSPascalCompiler);
procedure SIRegister_TStringType2(CL: TPSPascalCompiler);
procedure SIRegister_TEnumerationType(CL: TPSPascalCompiler);
procedure SIRegister_TOrdinalType(CL: TPSPascalCompiler);
procedure SIRegister_TParameterType(CL: TPSPascalCompiler);
procedure SIRegister_IDriverManager(CL: TPSPascalCompiler);
procedure SIRegister_commDriver(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCommDriver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWaiter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TModuleList2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TModule2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMetaData(CL: TPSRuntimeClassImporter);
procedure RIRegister_TParameter2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFloatType2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStringType2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEnumerationType(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOrdinalType(CL: TPSRuntimeClassImporter);
procedure RIRegister_TParameterType(CL: TPSRuntimeClassImporter);
procedure RIRegister_commDriver(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  //,SyncObjs
  ,commDriver2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_commDriver]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCommDriver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TCommDriver') do
  with CL.AddClassN(CL.FindClass('TThread'),'TCommDriver') do begin
    RegisterMethod('Constructor Create( aName : STRING)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GetMetaData : TMetaData');
    RegisterMethod('Function PublicClassName : STRING');
    RegisterMethod('Procedure SetData( aData : TStrings)');
    RegisterMethod('Procedure Execute');
    RegisterMethod('Procedure Use');
    RegisterMethod('Procedure UnUse');
    RegisterMethod('Procedure CollectValues( s : tStringList)');
    RegisterProperty('Module', 'TModule', iptrw);
    RegisterProperty('Name', 'STRING', iptr);
    RegisterProperty('Error', 'BOOLEAN', iptr);
    RegisterProperty('ErrorMsg', 'STRING', iptr);
    RegisterProperty('Value', 'DOUBLE', iptrw);
    RegisterProperty('Waiter', 'TWaiter', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWaiter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEvent', 'TWaiter') do
  with CL.AddClassN(CL.FindClass('TEvent'),'TWaiter') do
  begin
    RegisterMethod('Constructor Create( aName : STRING)');
    RegisterMethod('Procedure Using');
    RegisterMethod('Procedure Unusing');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TModuleList2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tObjectList', 'TModuleList') do
  with CL.AddClassN(CL.FindClass('tObjectList'),'TModuleList2') do
  begin
    RegisterProperty('Items', 'TModule INTEGER', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TModule2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tObject', 'TModule') do
  with CL.AddClassN(CL.FindClass('tObject'),'TModule2') do begin
    RegisterMethod('Constructor Create( aOwner : tObjectList)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Owner', 'TObjectList', iptrw);
    RegisterProperty('Handle', 'THandle', iptrw);
    RegisterProperty('Filename', 'STRING', iptrw);
    RegisterProperty('FilePath', 'STRING', iptrw);
    RegisterProperty('Version', 'TStringlist', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMetaData(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tObjectList', 'TMetaData') do
  with CL.AddClassN(CL.FindClass('tObjectList'),'TMetaData') do
  begin
    RegisterMethod('Constructor Create( aClass : TCommDriverClass)');
    RegisterMethod('Function ParamByName( aName : STRING) : TParameter2');
    RegisterMethod('Function GetValue( aName : STRING) : VARIANT');
    RegisterMethod('Procedure SetValue( aName : STRING; Value : VARIANT)');
    RegisterMethod('Procedure GetMetaData( r : TStrings)');
    RegisterProperty('Items', 'TParameter2 INTEGER', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TParameter2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tObject', 'TParameter') do
  with CL.AddClassN(CL.FindClass('tObject'),'TParameter2') do
  begin
    RegisterMethod('Constructor Create( aName : STRING; aType : TParameterType; aPubName : STRING)');
    RegisterMethod('Constructor CreateValue( aName : STRING; aType : TParameterType; aValue : VARIANT; aPubName : STRING)');
    RegisterMethod('Function GetMetaString : STRING');
    RegisterProperty('ParamType', 'TParameterType', iptr);
    RegisterProperty('PublicName', 'STRING', iptrw);
    RegisterProperty('Name', 'STRING', iptr);
    RegisterProperty('Data', 'VARIANT', iptrw);
    RegisterProperty('DataName', 'STRING', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFloatType2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TParameterType', 'TFloatType') do
  with CL.AddClassN(CL.FindClass('TParameterType'),'TFloatType2') do
  begin
    RegisterMethod('Function Checkdata( aValue : VARIANT) : VARIANT');
    RegisterMethod('Function ValueToString( Value : VARIANT) : STRING');
    RegisterMethod('Function StringToValue( Value : STRING) : VARIANT');
    RegisterMethod('Function GetMetaString : STRING');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringType2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TParameterType', 'TStringType') do
  with CL.AddClassN(CL.FindClass('TParameterType'),'TStringType2') do
  begin
    RegisterMethod('Function Checkdata( aValue : VARIANT) : VARIANT');
    RegisterMethod('Function ValueToString( Value : VARIANT) : STRING');
    RegisterMethod('Function StringToValue( Value : STRING) : VARIANT');
    RegisterMethod('Function GetMetaString : STRING');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEnumerationType(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tParameterType', 'TEnumerationType') do
  with CL.AddClassN(CL.FindClass('tParameterType'),'TEnumerationType') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Checkdata( aValue : VARIANT) : VARIANT');
    RegisterMethod('Function ValueToString( Value : VARIANT) : STRING');
    RegisterMethod('Function StringToValue( Value : STRING) : VARIANT');
    RegisterMethod('Function GetMetaString : STRING');
    RegisterProperty('Enums', 'TStringList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOrdinalType(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tParameterType', 'TOrdinalType') do
  with CL.AddClassN(CL.FindClass('tParameterType'),'TOrdinalType') do
  begin
    RegisterMethod('Function Checkdata( aValue : VARIANT) : VARIANT');
    RegisterMethod('Function ValueToString( Value : VARIANT) : STRING');
    RegisterMethod('Function GetMetaString : STRING');
    RegisterMethod('Function StringToValue( Value : STRING) : VARIANT');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TParameterType(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tObject', 'TParameterType') do
  with CL.AddClassN(CL.FindClass('tObject'),'TParameterType') do
  begin
    RegisterMethod('Function CheckData( aValue : VARIANT) : VARIANT');
    RegisterMethod('Function ValueToString( Value : VARIANT) : STRING');
    RegisterMethod('Function StringToValue( Value : STRING) : VARIANT');
    RegisterMethod('Function GetMetaString : STRING');
    RegisterProperty('TypeName', 'STRING', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDriverManager(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDriverManager') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDriverManager, 'IDriverManager') do
  begin
    RegisterMethod('Function InstallDriver( aClass : TCommDriverClass) : INTEGER', cdRegister);
    RegisterMethod('Function RemoveDriver( aClass : TCommDriverClass) : INTEGER', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_commDriver(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCommDriver');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMetaData');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TParameter2');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TParameterType');
  //CL.AddTypeS('TCommDriverClass', 'class of TCommDriver');
  SIRegister_IDriverManager(CL);
  SIRegister_TParameterType(CL);
  SIRegister_TOrdinalType(CL);
  SIRegister_TEnumerationType(CL);
  SIRegister_TStringType2(CL);
  SIRegister_TFloatType2(CL);
  SIRegister_TParameter2(CL);
  SIRegister_TMetaData(CL);
  SIRegister_TModule2(CL);
  SIRegister_TModuleList2(CL);
  SIRegister_TWaiter(CL);
  SIRegister_TCommDriver(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCommDriverWaiter_R(Self: TCommDriver; var T: TWaiter);
begin T := Self.Waiter; end;

(*----------------------------------------------------------------------------*)
procedure TCommDriverValue_W(Self: TCommDriver; const T: DOUBLE);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommDriverValue_R(Self: TCommDriver; var T: DOUBLE);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TCommDriverErrorMsg_R(Self: TCommDriver; var T: STRING);
begin T := Self.ErrorMsg; end;

(*----------------------------------------------------------------------------*)
procedure TCommDriverError_R(Self: TCommDriver; var T: BOOLEAN);
begin T := Self.Error; end;

(*----------------------------------------------------------------------------*)
procedure TCommDriverName_R(Self: TCommDriver; var T: STRING);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TCommDriverModule_W(Self: TCommDriver; const T: TModule2);
begin Self.Module := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommDriverModule_R(Self: TCommDriver; var T: TModule2);
begin T := Self.Module; end;

(*----------------------------------------------------------------------------*)
procedure TModuleListItems_W(Self: TModuleList2; const T: TModule2; const t1: INTEGER);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TModuleListItems_R(Self: TModuleList2; var T: TModule2; const t1: INTEGER);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TModuleVersion_R(Self: TModule2; var T: TStringlist);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TModuleFilePath_W(Self: TModule2; const T: STRING);
begin Self.FilePath := T; end;

(*----------------------------------------------------------------------------*)
procedure TModuleFilePath_R(Self: TModule2; var T: STRING);
begin T := Self.FilePath; end;

(*----------------------------------------------------------------------------*)
procedure TModuleFilename_W(Self: TModule2; const T: STRING);
begin Self.Filename := T; end;

(*----------------------------------------------------------------------------*)
procedure TModuleFilename_R(Self: TModule2; var T: STRING);
begin T := Self.Filename; end;

(*----------------------------------------------------------------------------*)
procedure TModuleHandle_W(Self: TModule2; const T: THandle);
begin Self.Handle := T; end;

(*----------------------------------------------------------------------------*)
procedure TModuleHandle_R(Self: TModule2; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TModuleOwner_W(Self: TModule2; const T: TObjectList);
begin Self.Owner := T; end;

(*----------------------------------------------------------------------------*)
procedure TModuleOwner_R(Self: TModule2; var T: TObjectList);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TMetaDataItems_R(Self: TMetaData; var T: TParameter2; const t1: INTEGER);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TParameterDataName_W(Self: TParameter2; const T: STRING);
begin Self.DataName := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterDataName_R(Self: TParameter2; var T: STRING);
begin T := Self.DataName; end;

(*----------------------------------------------------------------------------*)
procedure TParameterData_W(Self: TParameter2; const T: VARIANT);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterData_R(Self: TParameter2; var T: VARIANT);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TParameterName_R(Self: TParameter2; var T: STRING);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TParameterPublicName_W(Self: TParameter2; const T: STRING);
begin Self.PublicName := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterPublicName_R(Self: TParameter2; var T: STRING);
begin T := Self.PublicName; end;

(*----------------------------------------------------------------------------*)
procedure TParameterParamType_R(Self: TParameter2; var T: TParameterType);
begin T := Self.ParamType; end;

(*----------------------------------------------------------------------------*)
procedure TEnumerationTypeEnums_R(Self: TEnumerationType; var T: TStringList);
begin T := Self.Enums; end;

(*----------------------------------------------------------------------------*)
procedure TParameterTypeTypeName_R(Self: TParameterType; var T: STRING);
begin T := Self.TypeName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCommDriver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommDriver) do begin
    RegisterVirtualConstructor(@TCommDriver.Create, 'Create');
    RegisterMethod(@TCommDriver.Destroy, 'Free');
    //RegisterVirtualAbstractMethod(@TCommDriver, @!.GetMetaData, 'GetMetaData');
    //RegisterVirtualAbstractMethod(@TCommDriver, @!.PublicClassName, 'PublicClassName');
    //RegisterVirtualAbstractMethod(@TCommDriver, @!.SetData, 'SetData');
    RegisterMethod(@TCommDriver.Execute, 'Execute');
    RegisterVirtualMethod(@TCommDriver.Use, 'Use');
    RegisterVirtualMethod(@TCommDriver.UnUse, 'UnUse');
    RegisterVirtualMethod(@TCommDriver.CollectValues, 'CollectValues');
    RegisterPropertyHelper(@TCommDriverModule_R,@TCommDriverModule_W,'Module');
    RegisterPropertyHelper(@TCommDriverName_R,nil,'Name');
    RegisterPropertyHelper(@TCommDriverError_R,nil,'Error');
    RegisterPropertyHelper(@TCommDriverErrorMsg_R,nil,'ErrorMsg');
    RegisterPropertyHelper(@TCommDriverValue_R,@TCommDriverValue_W,'Value');
    RegisterPropertyHelper(@TCommDriverWaiter_R,nil,'Waiter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWaiter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWaiter) do
  begin
    RegisterConstructor(@TWaiter.Create, 'Create');
    RegisterMethod(@TWaiter.Using, 'Using');
    RegisterMethod(@TWaiter.Unusing, 'Unusing');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TModuleList2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TModuleList2) do
  begin
    RegisterPropertyHelper(@TModuleListItems_R,@TModuleListItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TModule2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TModule2) do
  begin
    RegisterConstructor(@TModule2.Create, 'Create');
    RegisterMethod(@TModule2.Destroy, 'Free');
    RegisterPropertyHelper(@TModuleOwner_R,@TModuleOwner_W,'Owner');
    RegisterPropertyHelper(@TModuleHandle_R,@TModuleHandle_W,'Handle');
    RegisterPropertyHelper(@TModuleFilename_R,@TModuleFilename_W,'Filename');
    RegisterPropertyHelper(@TModuleFilePath_R,@TModuleFilePath_W,'FilePath');
    RegisterPropertyHelper(@TModuleVersion_R,nil,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMetaData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMetaData) do
  begin
    RegisterConstructor(@TMetaData.Create, 'Create');
    RegisterMethod(@TMetaData.ParamByName, 'ParamByName');
    RegisterMethod(@TMetaData.GetValue, 'GetValue');
    RegisterMethod(@TMetaData.SetValue, 'SetValue');
    RegisterMethod(@TMetaData.GetMetaData, 'GetMetaData');
    RegisterPropertyHelper(@TMetaDataItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParameter2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParameter2) do
  begin
    RegisterConstructor(@TParameter2.Create, 'Create');
    RegisterConstructor(@TParameter2.CreateValue, 'CreateValue');
    RegisterMethod(@TParameter2.GetMetaString, 'GetMetaString');
    RegisterPropertyHelper(@TParameterParamType_R,nil,'ParamType');
    RegisterPropertyHelper(@TParameterPublicName_R,@TParameterPublicName_W,'PublicName');
    RegisterPropertyHelper(@TParameterName_R,nil,'Name');
    RegisterPropertyHelper(@TParameterData_R,@TParameterData_W,'Data');
    RegisterPropertyHelper(@TParameterDataName_R,@TParameterDataName_W,'DataName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFloatType2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFloatType2) do
  begin
    RegisterMethod(@TFloatType2.Checkdata, 'Checkdata');
    RegisterMethod(@TFloatType2.ValueToString, 'ValueToString');
    RegisterMethod(@TFloatType2.StringToValue, 'StringToValue');
    RegisterMethod(@TFloatType2.GetMetaString, 'GetMetaString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringType2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringType2) do
  begin
    RegisterMethod(@TStringType2.Checkdata, 'Checkdata');
    RegisterMethod(@TStringType2.ValueToString, 'ValueToString');
    RegisterMethod(@TStringType2.StringToValue, 'StringToValue');
    RegisterMethod(@TStringType2.GetMetaString, 'GetMetaString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEnumerationType(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEnumerationType) do begin
    RegisterConstructor(@TEnumerationType.Create, 'Create');
    RegisterMethod(@TEnumerationType.Destroy, 'Free');
    RegisterMethod(@TEnumerationType.Checkdata, 'Checkdata');
    RegisterMethod(@TEnumerationType.ValueToString, 'ValueToString');
    RegisterMethod(@TEnumerationType.StringToValue, 'StringToValue');
    RegisterMethod(@TEnumerationType.GetMetaString, 'GetMetaString');
    RegisterPropertyHelper(@TEnumerationTypeEnums_R,nil,'Enums');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOrdinalType(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOrdinalType) do
  begin
    RegisterMethod(@TOrdinalType.Checkdata, 'Checkdata');
    RegisterMethod(@TOrdinalType.ValueToString, 'ValueToString');
    RegisterMethod(@TOrdinalType.GetMetaString, 'GetMetaString');
    RegisterMethod(@TOrdinalType.StringToValue, 'StringToValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParameterType(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParameterType) do
  begin
    //RegisterVirtualAbstractMethod(@TParameterType, @!.CheckData, 'CheckData');
    //RegisterVirtualAbstractMethod(@TParameterType, @!.ValueToString, 'ValueToString');
    //RegisterVirtualAbstractMethod(@TParameterType, @!.StringToValue, 'StringToValue');
    //RegisterVirtualAbstractMethod(@TParameterType, @!.GetMetaString, 'GetMetaString');
    RegisterPropertyHelper(@TParameterTypeTypeName_R,nil,'TypeName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_commDriver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommDriver) do
  with CL.Add(TMetaData) do
  with CL.Add(TParameter2) do
  with CL.Add(TParameterType) do
  RIRegister_TParameterType(CL);
  RIRegister_TOrdinalType(CL);
  RIRegister_TEnumerationType(CL);
  RIRegister_TStringType2(CL);
  RIRegister_TFloatType2(CL);
  RIRegister_TParameter2(CL);
  RIRegister_TMetaData(CL);
  RIRegister_TModule2(CL);
  RIRegister_TModuleList2(CL);
  RIRegister_TWaiter(CL);
  RIRegister_TCommDriver(CL);
end;

 
 
{ TPSImport_commDriver }
(*----------------------------------------------------------------------------*)
procedure TPSImport_commDriver.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_commDriver(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_commDriver.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_commDriver(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
