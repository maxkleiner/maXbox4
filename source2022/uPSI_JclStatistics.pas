unit uPSI_JclStatistics;
{

    extended with jclmath_max
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
  TPSImport_JclStatistics = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclStatistics(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclStatistics_Routines(S: TPSExec);

procedure Register;

implementation


uses
   JclBase
  ,JclStatistics
  ;


Type Float = Double;

{$DEFINE MATH_DOUBLE_PRECISION}  
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclStatistics]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclStatistics(CL: TPSPascalCompiler);
begin
 CL.AddTypeS('TDynFloatArray', 'array of Float;');
 CL.AddTypeS('TDynDoubleArray', 'array of Double;');

 CL.AddDelphiFunction('Function ArithmeticMean( const X : TDynDoubleArray) : Float');
 CL.AddDelphiFunction('Function GeometricMean( const X : TDynFloatArray) : Float');
 CL.AddDelphiFunction('Function HarmonicMean( const X : TDynFloatArray) : Float');
 CL.AddDelphiFunction('Function HeronianMean( const a, b : Float) : Float');
 CL.AddDelphiFunction('Function BinomialCoeff( N, R : Cardinal) : Float');
 CL.AddDelphiFunction('Function IsPositiveFloatArray( const X : TDynFloatArray) : Boolean');
 CL.AddDelphiFunction('Function MaxFloatArray( const B : TDynFloatArray) : Float');
 CL.AddDelphiFunction('Function MaxFloatArrayIndex( const B : TDynFloatArray) : Integer');
 CL.AddDelphiFunction('Function Median( const X : TDynFloatArray) : Float');
 CL.AddDelphiFunction('Function MinFloatArray( const B : TDynFloatArray) : Float');
 CL.AddDelphiFunction('Function MinFloatArrayIndex( const B : TDynFloatArray) : Integer');
 CL.AddDelphiFunction('Function PermutationJ( N, R : Cardinal) : Float');
 CL.AddDelphiFunction('Function PopulationVariance( const X : TDynFloatArray) : Float');
 CL.AddDelphiFunction('Procedure PopulationVarianceAndMean( const X : TDynFloatArray; var Variance, Mean : Float)');
 CL.AddDelphiFunction('Function SampleVariance( const X : TDynFloatArray) : Float');
 CL.AddDelphiFunction('Procedure SampleVarianceAndMean( const X : TDynFloatArray; var Variance, Mean : Float)');
 CL.AddDelphiFunction('Function SumFloatArray( const B : TDynFloatArray) : Float');
 CL.AddDelphiFunction('Function SumSquareDiffFloatArray( const B : TDynFloatArray; Diff : Float) : Float');
 CL.AddDelphiFunction('Function SumSquareFloatArray( const B : TDynFloatArray) : Float');
 CL.AddDelphiFunction('Function SumPairProductFloatArray( const X, Y : TDynFloatArray) : Float');
end;

 //TDynFloatArray    = array of Float;
(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JclStatistics_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ArithmeticMean, 'ArithmeticMean', cdRegister);
 S.RegisterDelphiFunction(@GeometricMean, 'GeometricMean', cdRegister);
 S.RegisterDelphiFunction(@HarmonicMean, 'HarmonicMean', cdRegister);
 S.RegisterDelphiFunction(@HeronianMean, 'HeronianMean', cdRegister);
 S.RegisterDelphiFunction(@BinomialCoeff, 'BinomialCoeff', cdRegister);
 S.RegisterDelphiFunction(@IsPositiveFloatArray, 'IsPositiveFloatArray', cdRegister);
 S.RegisterDelphiFunction(@MaxFloatArray, 'MaxFloatArray', cdRegister);
 S.RegisterDelphiFunction(@MaxFloatArrayIndex, 'MaxFloatArrayIndex', cdRegister);
 S.RegisterDelphiFunction(@Median, 'Median', cdRegister);
 S.RegisterDelphiFunction(@MinFloatArray, 'MinFloatArray', cdRegister);
 S.RegisterDelphiFunction(@MinFloatArrayIndex, 'MinFloatArrayIndex', cdRegister);
 S.RegisterDelphiFunction(@Permutation, 'PermutationJ', cdRegister);
 S.RegisterDelphiFunction(@PopulationVariance, 'PopulationVariance', cdRegister);
 S.RegisterDelphiFunction(@PopulationVarianceAndMean, 'PopulationVarianceAndMean', cdRegister);
 S.RegisterDelphiFunction(@SampleVariance, 'SampleVariance', cdRegister);
 S.RegisterDelphiFunction(@SampleVarianceAndMean, 'SampleVarianceAndMean', cdRegister);
 S.RegisterDelphiFunction(@SumFloatArray, 'SumFloatArray', cdRegister);
 S.RegisterDelphiFunction(@SumSquareDiffFloatArray, 'SumSquareDiffFloatArray', cdRegister);
 S.RegisterDelphiFunction(@SumSquareFloatArray, 'SumSquareFloatArray', cdRegister);
 S.RegisterDelphiFunction(@SumPairProductFloatArray, 'SumPairProductFloatArray', cdRegister);
end;

 
 
{ TPSImport_JclStatistics }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclStatistics.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclStatistics(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclStatistics.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclStatistics(ri);
  RIRegister_JclStatistics_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
