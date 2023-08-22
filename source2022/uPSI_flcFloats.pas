unit uPSI_flcFloats;
{
now for the V47590 V    retypes floats  with orig utils

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
  TPSImport_flcFloats = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_flcFloats(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcFloats_Routines(S: TPSExec);

procedure Register;

implementation


uses
   flcStdTypes
  ,flcUtils
  ,flcFloats
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcFloats]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_flcFloats(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function flcDoubleMin( const A, B : Double) : Double');
 CL.AddDelphiFunction('Function flcDoubleMax( const A, B : Double) : Double');
 CL.AddDelphiFunction('Function flcExtendedMin( const A, B : Extended) : Extended');
 CL.AddDelphiFunction('Function flcExtendedMax( const A, B : Extended) : Extended');
 CL.AddDelphiFunction('Function flcFloatMin( const A, B : Float) : Float');
 CL.AddDelphiFunction('Function flcFloatMax( const A, B : Float) : Float');
 CL.AddDelphiFunction('Function flcFloatClip( const Value : Float; const Low, High : Float) : Float');
 CL.AddDelphiFunction('Function flcInSingleRange( const A : Float) : Boolean');
 CL.AddDelphiFunction('Function flcInDoubleRange( const A : Float) : Boolean');
 CL.AddDelphiFunction('Function flcInCurrencyRange0( const A : Float) : Boolean;');
 CL.AddDelphiFunction('Function flcInCurrencyRange1( const A : Int64) : Boolean;');
 CL.AddDelphiFunction('Function flcExtendedExponentBase2( const A : Extended; var Exponent : Integer) : Boolean');
 CL.AddDelphiFunction('Function flcExtendedExponentBase10( const A : Extended; var Exponent : Integer) : Boolean');
 CL.AddDelphiFunction('Function flcExtendedIsInfinity( const A : Extended) : Boolean');
 CL.AddDelphiFunction('Function flcExtendedIsNaN( const A : Extended) : Boolean');
 CL.AddConstantN('flcSingleCompareDelta','Extended').setExtended( 1.0E-34);
 CL.AddConstantN('flcDoubleCompareDelta','Extended').setExtended( 1.0E-280);
 //CL.AddConstantN('ExtendedCompareDelta','').SetString( DoubleCompareDelta);
 CL.AddConstantN('flcExtendedCompareDelta','Extended').setExtended( 1.0E-4400);
 //CL.AddConstantN('DefaultCompareDelta','').SetString( SingleCompareDelta);
 CL.AddDelphiFunction('Function flcFloatZero( const A : Float; const CompareDelta : Float) : Boolean');
 CL.AddDelphiFunction('Function flcFloatOne( const A : Float; const CompareDelta : Float) : Boolean');
 CL.AddDelphiFunction('Function flcFloatsEqual( const A, B : Float; const CompareDelta : Float) : Boolean');
 CL.AddDelphiFunction('Function flcFloatsCompare( const A, B : Float; const CompareDelta : Float) : TCompareResult');
 CL.AddConstantN('flcSingleCompareEpsilon','Extended').setExtended( 1.0E-5);
 CL.AddConstantN('flcDoubleCompareEpsilon','Extended').setExtended( 1.0E-13);
 CL.AddConstantN('flcExtendedCompareEpsilon','Extended').setExtended( 1.0E-17);
 CL.AddConstantN('flcDefaultCompareEpsilon','Extended').setExtended( 1.0E-10);
 CL.AddDelphiFunction('Function flcExtendedApproxEqual( const A, B : Extended; const CompareEpsilon : Double) : Boolean');
 CL.AddDelphiFunction('Function flcExtendedApproxCompare( const A, B : Extended; const CompareEpsilon : Double) : TCompareResult');
 CL.AddDelphiFunction('Function flcDoubleApproxEqual( const A, B : Double; const CompareEpsilon : Double) : Boolean');
 CL.AddDelphiFunction('Function flcDoubleApproxCompare( const A, B : Double; const CompareEpsilon : Double) : TCompareResult');
 CL.AddDelphiFunction('Function flcFloatApproxEqual( const A, B : Float; const CompareEpsilon : Float) : Boolean');
 CL.AddDelphiFunction('Function flcFloatApproxCompare( const A, B : Float; const CompareEpsilon : Float) : TCompareResult');
 CL.AddDelphiFunction('Function flcFloatToStringA( const A : Float) : AnsiString');
 CL.AddDelphiFunction('Function flcFloatToStringB( const A : Float) : RawByteString');
 CL.AddDelphiFunction('Function flcFloatToStringU( const A : Float) : UnicodeString');
 CL.AddDelphiFunction('Function flcFloatToString( const A : Float) : String');
 CL.AddDelphiFunction('Function flots( const A : Float) : String');
 //CL.AddDelphiFunction('Function flcTryStringToFloatPA( const BufP : ___Pointer; const BufLen : Integer; out Value : Float; out StrLen : Integer) : TConvertResult');
 //CL.AddDelphiFunction('Function flcTryStringToFloatPW( const BufP : ___Pointer; const BufLen : Integer; out Value : Float; out StrLen : Integer) : TConvertResult');
 //CL.AddDelphiFunction('Function flcTryStringToFloatP( const BufP : ___Pointer; const BufLen : Integer; out Value : Float; out StrLen : Integer) : TConvertResult');
 CL.AddDelphiFunction('Function flcTryStringToFloatB( const A : RawByteString; out B : Float) : Boolean');
 CL.AddDelphiFunction('Function flcTryStringToFloatU( const A : UnicodeString; out B : Float) : Boolean');
 CL.AddDelphiFunction('Function flcTryStringToFloat( const A : String; out B : Float) : Boolean');
 CL.AddDelphiFunction('Function flcStringToFloatB( const A : RawByteString) : Float');
 CL.AddDelphiFunction('Function flcStringToFloatU( const A : UnicodeString) : Float');
 CL.AddDelphiFunction('Function flcStringToFloat( const A : String) : Float');
 CL.AddDelphiFunction('Function flcStringToFloatDefB( const A : RawByteString; const Default : Float) : Float');
 CL.AddDelphiFunction('Function flcStringToFloatDefU( const A : UnicodeString; const Default : Float) : Float');
 CL.AddDelphiFunction('Function flcStringToFloatDef( const A : String; const Default : Float) : Float');
 CL.AddDelphiFunction('Procedure FLCFloatStringTest');
 CL.AddDelphiFunction('Procedure FLCFloatTest');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function InCurrencyRange1_P( const A : Int64) : Boolean;
Begin Result := flcFloats.InCurrencyRange(A); END;

(*----------------------------------------------------------------------------*)
Function InCurrencyRange0_P( const A : Float) : Boolean;
Begin Result := flcFloats.InCurrencyRange(A); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcFloats_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DoubleMin, 'flcDoubleMin', cdRegister);
 S.RegisterDelphiFunction(@DoubleMax, 'flcDoubleMax', cdRegister);
 S.RegisterDelphiFunction(@ExtendedMin, 'flcExtendedMin', cdRegister);
 S.RegisterDelphiFunction(@ExtendedMax, 'flcExtendedMax', cdRegister);
 S.RegisterDelphiFunction(@FloatMin, 'flcFloatMin', cdRegister);
 S.RegisterDelphiFunction(@FloatMax, 'flcFloatMax', cdRegister);
 S.RegisterDelphiFunction(@FloatClip, 'flcFloatClip', cdRegister);
 S.RegisterDelphiFunction(@InSingleRange, 'flcInSingleRange', cdRegister);
 S.RegisterDelphiFunction(@InDoubleRange, 'flcInDoubleRange', cdRegister);
 S.RegisterDelphiFunction(@InCurrencyRange0_P, 'flcInCurrencyRange0', cdRegister);
 S.RegisterDelphiFunction(@InCurrencyRange1_P, 'flcInCurrencyRange1', cdRegister);
 S.RegisterDelphiFunction(@ExtendedExponentBase2, 'flcExtendedExponentBase2', cdRegister);
 S.RegisterDelphiFunction(@ExtendedExponentBase10, 'flcExtendedExponentBase10', cdRegister);
 S.RegisterDelphiFunction(@ExtendedIsInfinity, 'flcExtendedIsInfinity', cdRegister);
 S.RegisterDelphiFunction(@ExtendedIsNaN, 'flcExtendedIsNaN', cdRegister);
 S.RegisterDelphiFunction(@FloatZero, 'flcFloatZero', cdRegister);
 S.RegisterDelphiFunction(@FloatOne, 'flcFloatOne', cdRegister);
 S.RegisterDelphiFunction(@FloatsEqual, 'flcFloatsEqual', cdRegister);
 S.RegisterDelphiFunction(@FloatsCompare, 'flcFloatsCompare', cdRegister);
 S.RegisterDelphiFunction(@ExtendedApproxEqual, 'flcExtendedApproxEqual', cdRegister);
 S.RegisterDelphiFunction(@ExtendedApproxCompare, 'flcExtendedApproxCompare', cdRegister);
 S.RegisterDelphiFunction(@DoubleApproxEqual, 'flcDoubleApproxEqual', cdRegister);
 S.RegisterDelphiFunction(@DoubleApproxCompare, 'flcDoubleApproxCompare', cdRegister);
 S.RegisterDelphiFunction(@FloatApproxEqual, 'flcFloatApproxEqual', cdRegister);
 S.RegisterDelphiFunction(@FloatApproxCompare, 'flcFloatApproxCompare', cdRegister);
 S.RegisterDelphiFunction(@FloatToStringA, 'flcFloatToStringA', cdRegister);
 S.RegisterDelphiFunction(@FloatToStringB, 'flcFloatToStringB', cdRegister);
 S.RegisterDelphiFunction(@FloatToStringU, 'flcFloatToStringU', cdRegister);
 S.RegisterDelphiFunction(@FloatToString, 'flcFloatToString', cdRegister);
 S.RegisterDelphiFunction(@FloatToString, 'flots', cdRegister);
 S.RegisterDelphiFunction(@TryStringToFloatPA, 'flcTryStringToFloatPA', cdRegister);
 S.RegisterDelphiFunction(@TryStringToFloatPW, 'flcTryStringToFloatPW', cdRegister);
 S.RegisterDelphiFunction(@TryStringToFloatP, 'flcTryStringToFloatP', cdRegister);
 S.RegisterDelphiFunction(@TryStringToFloatB, 'flcTryStringToFloatB', cdRegister);
 S.RegisterDelphiFunction(@TryStringToFloatU, 'flcTryStringToFloatU', cdRegister);
 S.RegisterDelphiFunction(@TryStringToFloat, 'flcTryStringToFloat', cdRegister);
 S.RegisterDelphiFunction(@StringToFloatB, 'flcStringToFloatB', cdRegister);
 S.RegisterDelphiFunction(@StringToFloatU, 'flcStringToFloatU', cdRegister);
 S.RegisterDelphiFunction(@StringToFloat, 'flcStringToFloat', cdRegister);
 S.RegisterDelphiFunction(@StringToFloatDefB, 'flcStringToFloatDefB', cdRegister);
 S.RegisterDelphiFunction(@StringToFloatDefU, 'flcStringToFloatDefU', cdRegister);
 S.RegisterDelphiFunction(@StringToFloatDef, 'flcStringToFloatDef', cdRegister);
 S.RegisterDelphiFunction(@Test, 'FLCFloatStringTest', cdRegister);
 S.RegisterDelphiFunction(@Test_Float, 'FLCFloatTest', cdRegister);
end;

 
 
{ TPSImport_flcFloats }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcFloats.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcFloats(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcFloats.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcFloats_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
