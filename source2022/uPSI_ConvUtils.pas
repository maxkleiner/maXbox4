unit uPSI_ConvUtils;
{

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
  TPSImport_ConvUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TConvTypeProcs(CL: TPSPascalCompiler);
procedure SIRegister_TConvTypeFactor(CL: TPSPascalCompiler);
procedure SIRegister_TConvTypeInfo(CL: TPSPascalCompiler);
procedure SIRegister_ConvUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TConvTypeProcs(CL: TPSRuntimeClassImporter);
procedure RIRegister_TConvTypeFactor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TConvTypeInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_ConvUtils(CL: TPSRuntimeClassImporter);
procedure RIRegister_ConvUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Math
  ,Types
  ,ConvUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ConvUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TConvTypeProcs(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TConvTypeInfo', 'TConvTypeProcs') do
  with CL.AddClassN(CL.FindClass('TConvTypeInfo'),'TConvTypeProcs') do
  begin
    RegisterMethod('Constructor Create( const AConvFamily : TConvFamily; const ADescription : string; const AToCommonProc, AFromCommonProc : TConversionProc)');
    RegisterMethod('function ToCommon(const AValue: Double): Double;');
    RegisterMethod('function FromCommon(const AValue: Double): Double;');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TConvTypeFactor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TConvTypeInfo', 'TConvTypeFactor') do
  with CL.AddClassN(CL.FindClass('TConvTypeInfo'),'TConvTypeFactor') do
  begin
    RegisterMethod('Constructor Create( const AConvFamily : TConvFamily; const ADescription : string; const AFactor : Double)');
    RegisterMethod('function ToCommon(const AValue: Double): Double;');
    RegisterMethod('function FromCommon(const AValue: Double): Double;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TConvTypeInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TConvTypeInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TConvTypeInfo') do
  begin
    RegisterMethod('Constructor Create( const AConvFamily : TConvFamily; const ADescription : string)');
    RegisterMethod('Function ToCommon( const AValue : Double) : Double');
    RegisterMethod('Function FromCommon( const AValue : Double) : Double');
    RegisterProperty('ConvFamily', 'TConvFamily', iptr);
    RegisterProperty('ConvType', 'TConvType', iptr);
    RegisterProperty('Description', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ConvUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TConvFamily', 'Word');
  CL.AddTypeS('TConvType', 'Word');
  CL.AddTypeS('TConvTypeArray', 'array of TConvType');
  CL.AddTypeS('TConvFamilyArray', 'array of TConvFamily');
 CL.AddDelphiFunction('Function Convert( const AValue : Double; const AFrom, ATo : TConvType) : Double;');
 CL.AddDelphiFunction('Function Convert1( const AValue : Double; const AFrom1, AFrom2, ATo1, ATo2 : TConvType) : Double;');
 CL.AddDelphiFunction('Function ConvertFrom( const AFrom : TConvType; const AValue : Double) : Double');
 CL.AddDelphiFunction('Function ConvertTo( const AValue : Double; const ATo : TConvType) : Double');
 CL.AddDelphiFunction('Function ConvUnitAdd( const AValue1 : Double; const AType1 : TConvType; const AValue2 : Double; const AType2, AResultType : TConvType) : Double');
 CL.AddDelphiFunction('Function ConvUnitDiff( const AValue1 : Double; const AType1 : TConvType; const AValue2 : Double; const AType2, AResultType : TConvType) : Double');
 CL.AddDelphiFunction('Function ConvUnitInc( const AValue : Double; const AType, AAmountType : TConvType) : Double;');
 CL.AddDelphiFunction('Function ConvUnitInc1( const AValue : Double; const AType : TConvType; const AAmount : Double; const AAmountType : TConvType) : Double;');
 CL.AddDelphiFunction('Function ConvUnitDec( const AValue : Double; const AType, AAmountType : TConvType) : Double;');
 CL.AddDelphiFunction('Function ConvUnitDec1( const AValue : Double; const AType : TConvType; const AAmount : Double; const AAmountType : TConvType) : Double;');
 CL.AddDelphiFunction('Function ConvUnitWithinPrevious( const AValue, ATest : Double; const AType : TConvType; const AAmount : Double; const AAmountType : TConvType) : Boolean');
 CL.AddDelphiFunction('Function ConvUnitWithinNext( const AValue, ATest : Double; const AType : TConvType; const AAmount : Double; const AAmountType : TConvType) : Boolean');
 CL.AddDelphiFunction('Function ConvUnitCompareValue( const AValue1 : Double; const AType1 : TConvType; const AValue2 : Double; const AType2 : TConvType) : TValueRelationship');
 CL.AddDelphiFunction('Function ConvUnitSameValue( const AValue1 : Double; const AType1 : TConvType; const AValue2 : Double; const AType2 : TConvType) : Boolean');
 CL.AddDelphiFunction('Function RegisterConversionType( const AFamily : TConvFamily; const ADescription : string; const AFactor : Double) : TConvType;');
 //§CL.AddDelphiFunction('Function RegisterConversionType1( const AFamily : TConvFamily; const ADescription : string; const AToCommonProc, AFromCommonProc : TConversionProc) : TConvType;');
 CL.AddDelphiFunction('Procedure UnregisterConversionType( const AType : TConvType)');
 CL.AddDelphiFunction('Function RegisterConversionFamily( const ADescription : string) : TConvFamily');
 CL.AddDelphiFunction('Procedure UnregisterConversionFamily( const AFamily : TConvFamily)');
 CL.AddDelphiFunction('Function CompatibleConversionTypes( const AFrom, ATo : TConvType) : Boolean');
 CL.AddDelphiFunction('Function CompatibleConversionType( const AType : TConvType; const AFamily : TConvFamily) : Boolean');
 CL.AddDelphiFunction('Procedure GetConvTypes( const AFamily : TConvFamily; out ATypes : TConvTypeArray)');
 CL.AddDelphiFunction('Procedure GetConvFamilies( out AFamilies : TConvFamilyArray)');
 CL.AddDelphiFunction('Function StrToConvUnit( AText : string; out AType : TConvType) : Double');
 CL.AddDelphiFunction('Function TryStrToConvUnit( AText : string; out AValue : Double; out AType : TConvType) : Boolean');
 CL.AddDelphiFunction('Function ConvUnitToStr( const AValue : Double; const AType : TConvType) : string');
 CL.AddDelphiFunction('Function ConvTypeToDescription( const AType : TConvType) : string');
 CL.AddDelphiFunction('Function ConvFamilyToDescription( const AFamily : TConvFamily) : string');
 CL.AddDelphiFunction('Function DescriptionToConvType( const ADescription : string; out AType : TConvType) : Boolean;');
 CL.AddDelphiFunction('Function DescriptionToConvType1( const AFamily : TConvFamily; const ADescription : string; out AType : TConvType) : Boolean;');
 CL.AddDelphiFunction('Function DescriptionToConvFamily( const ADescription : string; out AFamily : TConvFamily) : Boolean');
 CL.AddDelphiFunction('Function ConvTypeToFamily( const AType : TConvType) : TConvFamily;');
 CL.AddDelphiFunction('Function TryConvTypeToFamily1( const AType : TConvType; out AFamily : TConvFamily) : Boolean;');
 CL.AddDelphiFunction('Function ConvTypeToFamily( const AFrom, ATo : TConvType) : TConvFamily;');
 CL.AddDelphiFunction('Function TryConvTypeToFamily( const AFrom, ATo : TConvType; out AFamily : TConvFamily) : Boolean;');
 CL.AddDelphiFunction('Procedure RaiseConversionError( const AText : string);');
 CL.AddDelphiFunction('Procedure RaiseConversionError1( const AText : string; const AArgs : array of const);');
 CL.AddDelphiFunction('Procedure RaiseConversionRegError( AFamily : TConvFamily; const ADescription : string)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EConversionError');
 //CL.AddConstantN('CIllegalConvFamily','TConvFamily').SetString( '0');
 //CL.AddConstantN('CIllegalConvType','TConvType').SetString( '0');
  SIRegister_TConvTypeInfo(CL);
  CL.AddTypeS('TConvTypeList', 'array of TConvTypeInfo');
  SIRegister_TConvTypeFactor(CL);
  SIRegister_TConvTypeProcs(CL);
 CL.AddDelphiFunction('Function RegisterConversionType( AConvTypeInfo : TConvTypeInfo; out AType : TConvType) : Boolean;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function RegisterConversionType_P( AConvTypeInfo : TConvTypeInfo; out AType : TConvType) : Boolean;
Begin Result := ConvUtils.RegisterConversionType(AConvTypeInfo, AType); END;

(*----------------------------------------------------------------------------*)
procedure TConvTypeInfoDescription_R(Self: TConvTypeInfo; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TConvTypeInfoConvType_R(Self: TConvTypeInfo; var T: TConvType);
begin T := Self.ConvType; end;

(*----------------------------------------------------------------------------*)
procedure TConvTypeInfoConvFamily_R(Self: TConvTypeInfo; var T: TConvFamily);
begin T := Self.ConvFamily; end;

(*----------------------------------------------------------------------------*)
Procedure RaiseConversionError1_P( const AText : string; const AArgs : array of const);
Begin ConvUtils.RaiseConversionError(AText, AArgs); END;

(*----------------------------------------------------------------------------*)
Procedure RaiseConversionError_P( const AText : string);
Begin ConvUtils.RaiseConversionError(AText); END;

(*----------------------------------------------------------------------------*)
Function TryConvTypeToFamily_P( const AFrom, ATo : TConvType; out AFamily : TConvFamily) : Boolean;
Begin Result := ConvUtils.TryConvTypeToFamily(AFrom, ATo, AFamily); END;

(*----------------------------------------------------------------------------*)
Function ConvTypeToFamily_P( const AFrom, ATo : TConvType) : TConvFamily;
Begin Result := ConvUtils.ConvTypeToFamily(AFrom, ATo); END;

(*----------------------------------------------------------------------------*)
Function TryConvTypeToFamily1_P( const AType : TConvType; out AFamily : TConvFamily) : Boolean;
Begin Result := ConvUtils.TryConvTypeToFamily(AType, AFamily); END;

(*----------------------------------------------------------------------------*)
Function ConvTypeToFamily1_P( const AType : TConvType) : TConvFamily;
Begin Result := ConvUtils.ConvTypeToFamily(AType); END;

(*----------------------------------------------------------------------------*)
Function DescriptionToConvType1_P( const AFamily : TConvFamily; const ADescription : string; out AType : TConvType) : Boolean;
Begin Result := ConvUtils.DescriptionToConvType(AFamily, ADescription, AType); END;

(*----------------------------------------------------------------------------*)
Function DescriptionToConvType_P( const ADescription : string; out AType : TConvType) : Boolean;
Begin Result := ConvUtils.DescriptionToConvType(ADescription, AType); END;

(*----------------------------------------------------------------------------*)
Function RegisterConversionType1_P( const AFamily : TConvFamily; const ADescription : string; const AToCommonProc, AFromCommonProc : TConversionProc) : TConvType;
Begin Result := ConvUtils.RegisterConversionType(AFamily, ADescription, AToCommonProc, AFromCommonProc); END;

(*----------------------------------------------------------------------------*)
Function RegisterConversionType2_P( const AFamily : TConvFamily; const ADescription : string; const AFactor : Double) : TConvType;
Begin Result := ConvUtils.RegisterConversionType(AFamily, ADescription, AFactor); END;

(*----------------------------------------------------------------------------*)
Function ConvUnitDec1_P( const AValue : Double; const AType : TConvType; const AAmount : Double; const AAmountType : TConvType) : Double;
Begin Result := ConvUtils.ConvUnitDec(AValue, AType, AAmount, AAmountType); END;

(*----------------------------------------------------------------------------*)
Function ConvUnitDec_P( const AValue : Double; const AType, AAmountType : TConvType) : Double;
Begin Result := ConvUtils.ConvUnitDec(AValue, AType, AAmountType); END;

(*----------------------------------------------------------------------------*)
Function ConvUnitInc1_P( const AValue : Double; const AType : TConvType; const AAmount : Double; const AAmountType : TConvType) : Double;
Begin Result := ConvUtils.ConvUnitInc(AValue, AType, AAmount, AAmountType); END;

(*----------------------------------------------------------------------------*)
Function ConvUnitInc_P( const AValue : Double; const AType, AAmountType : TConvType) : Double;
Begin Result := ConvUtils.ConvUnitInc(AValue, AType, AAmountType); END;

(*----------------------------------------------------------------------------*)
Function Convert1_P( const AValue : Double; const AFrom1, AFrom2, ATo1, ATo2 : TConvType) : Double;
Begin Result := ConvUtils.Convert(AValue, AFrom1, AFrom2, ATo1, ATo2); END;

(*----------------------------------------------------------------------------*)
Function Convert_P( const AValue : Double; const AFrom, ATo : TConvType) : Double;
Begin Result := ConvUtils.Convert(AValue, AFrom, ATo); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConvTypeProcs(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConvTypeProcs) do
  begin
    RegisterConstructor(@TConvTypeProcs.Create, 'Create');
    RegisterMethod(@TConvTypeProcs.ToCommon, 'ToCommon');
    RegisterMethod(@TConvTypeProcs.FromCommon, 'ToCommon');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConvTypeFactor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConvTypeFactor) do
  begin
    RegisterConstructor(@TConvTypeFactor.Create, 'Create');
    RegisterMethod(@TConvTypeProcs.ToCommon, 'ToCommon');
    RegisterMethod(@TConvTypeProcs.FromCommon, 'ToCommon');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConvTypeInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConvTypeInfo) do
  begin
    RegisterConstructor(@TConvTypeInfo.Create, 'Create');
    //RegisterVirtualAbstractMethod(@TConvTypeInfo, @!.ToCommon, 'ToCommon');
    //RegisterVirtualAbstractMethod(@TConvTypeInfo, @!.FromCommon, 'FromCommon');
    RegisterPropertyHelper(@TConvTypeInfoConvFamily_R,nil,'ConvFamily');
    RegisterPropertyHelper(@TConvTypeInfoConvType_R,nil,'ConvType');
    RegisterPropertyHelper(@TConvTypeInfoDescription_R,nil,'Description');
  end;
end;

procedure RIRegister_ConvUtils(CL: TPSRuntimeClassImporter);
 begin
  with CL.Add(EConversionError) do
  RIRegister_TConvTypeInfo(CL);
  RIRegister_TConvTypeFactor(CL);
  RIRegister_TConvTypeProcs(CL);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ConvUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Convert, 'Convert', cdRegister);
 S.RegisterDelphiFunction(@Convert1_P, 'Convert1', cdRegister);
 S.RegisterDelphiFunction(@ConvertFrom, 'ConvertFrom', cdRegister);
 S.RegisterDelphiFunction(@ConvertTo, 'ConvertTo', cdRegister);
 S.RegisterDelphiFunction(@ConvUnitAdd, 'ConvUnitAdd', cdRegister);
 S.RegisterDelphiFunction(@ConvUnitDiff, 'ConvUnitDiff', cdRegister);
 S.RegisterDelphiFunction(@ConvUnitInc, 'ConvUnitInc', cdRegister);
 S.RegisterDelphiFunction(@ConvUnitInc1_P, 'ConvUnitInc1', cdRegister);
 S.RegisterDelphiFunction(@ConvUnitDec, 'ConvUnitDec', cdRegister);
 S.RegisterDelphiFunction(@ConvUnitDec1_P, 'ConvUnitDec1', cdRegister);
 S.RegisterDelphiFunction(@ConvUnitWithinPrevious, 'ConvUnitWithinPrevious', cdRegister);
 S.RegisterDelphiFunction(@ConvUnitWithinNext, 'ConvUnitWithinNext', cdRegister);
 S.RegisterDelphiFunction(@ConvUnitCompareValue, 'ConvUnitCompareValue', cdRegister);
 S.RegisterDelphiFunction(@ConvUnitSameValue, 'ConvUnitSameValue', cdRegister);
 S.RegisterDelphiFunction(@RegisterConversionType, 'RegisterConversionType', cdRegister);
 S.RegisterDelphiFunction(@RegisterConversionType1_P, 'RegisterConversionType1', cdRegister);
 S.RegisterDelphiFunction(@UnregisterConversionType, 'UnregisterConversionType', cdRegister);
 S.RegisterDelphiFunction(@RegisterConversionFamily, 'RegisterConversionFamily', cdRegister);
 S.RegisterDelphiFunction(@UnregisterConversionFamily, 'UnregisterConversionFamily', cdRegister);
 S.RegisterDelphiFunction(@CompatibleConversionTypes, 'CompatibleConversionTypes', cdRegister);
 S.RegisterDelphiFunction(@CompatibleConversionType, 'CompatibleConversionType', cdRegister);
 S.RegisterDelphiFunction(@GetConvTypes, 'GetConvTypes', cdRegister);
 S.RegisterDelphiFunction(@GetConvFamilies, 'GetConvFamilies', cdRegister);
 S.RegisterDelphiFunction(@StrToConvUnit, 'StrToConvUnit', cdRegister);
 S.RegisterDelphiFunction(@TryStrToConvUnit, 'TryStrToConvUnit', cdRegister);
 S.RegisterDelphiFunction(@ConvUnitToStr, 'ConvUnitToStr', cdRegister);
 S.RegisterDelphiFunction(@ConvTypeToDescription, 'ConvTypeToDescription', cdRegister);
 S.RegisterDelphiFunction(@ConvFamilyToDescription, 'ConvFamilyToDescription', cdRegister);
 S.RegisterDelphiFunction(@DescriptionToConvType, 'DescriptionToConvType', cdRegister);
 S.RegisterDelphiFunction(@DescriptionToConvType1_P, 'DescriptionToConvType1', cdRegister);
 S.RegisterDelphiFunction(@DescriptionToConvFamily, 'DescriptionToConvFamily', cdRegister);
 S.RegisterDelphiFunction(@ConvTypeToFamily, 'ConvTypeToFamily', cdRegister);
 S.RegisterDelphiFunction(@TryConvTypeToFamily1_P, 'TryConvTypeToFamily1', cdRegister);
 S.RegisterDelphiFunction(@ConvTypeToFamily, 'ConvTypeToFamily', cdRegister);
 S.RegisterDelphiFunction(@TryConvTypeToFamily, 'TryConvTypeToFamily', cdRegister);
 S.RegisterDelphiFunction(@RaiseConversionError, 'RaiseConversionError', cdRegister);
 S.RegisterDelphiFunction(@RaiseConversionError1_P, 'RaiseConversionError1', cdRegister);
 S.RegisterDelphiFunction(@RaiseConversionRegError, 'RaiseConversionRegError', cdRegister);
 S.RegisterDelphiFunction(@RegisterConversionType, 'RegisterConversionType', cdRegister);
end;

 
 
{ TPSImport_ConvUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ConvUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ConvUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ConvUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ConvUtils(ri);
  RIRegister_ConvUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
