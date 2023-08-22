unit uPSI_StStat;
{
  SysTools4   add an S to avoid namespace conflict
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
  TPSImport_StStat = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_StStat(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StStat_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Math
  ,StMath
  ,StConst
  ,StBase
  ,StStat
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StStat]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StStat(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function AveDev( const Data : array of Double) : Double');
 CL.AddDelphiFunction('Function AveDev16( const Data, NData : Integer) : Double');
 CL.AddDelphiFunction('Function Confidence( Alpha, StandardDev : Double; Size : LongInt) : Double');
 CL.AddDelphiFunction('Function Correlation( const Data1, Data2 : array of Double) : Double');
 CL.AddDelphiFunction('Function Correlation16( const Data1, Data2, NData : Integer) : Double');
 CL.AddDelphiFunction('Function Covariance( const Data1, Data2 : array of Double) : Double');
 CL.AddDelphiFunction('Function Covariance16( const Data1, Data2, NData : Integer) : Double');
 CL.AddDelphiFunction('Function DevSq( const Data : array of Double) : Double');
 CL.AddDelphiFunction('Function DevSq16( const Data, NData : Integer) : Double');
 CL.AddDelphiFunction('Procedure Frequency( const Data : array of Double; const Bins : array of Double; var Counts : array of LongInt)');
 //CL.AddDelphiFunction('Procedure Frequency16( const Data, NData : Integer; const Bins, NBins : Integer; var Counts)');
 CL.AddDelphiFunction('Function GeometricMeanS( const Data : array of Double) : Double');
 CL.AddDelphiFunction('Function GeometricMean16( const Data, NData : Integer) : Double');
 CL.AddDelphiFunction('Function HarmonicMeanS( const Data : array of Double) : Double');
 CL.AddDelphiFunction('Function HarmonicMean16( const Data, NData : Integer) : Double');
 CL.AddDelphiFunction('Function Largest( const Data : array of Double; K : Integer) : Double');
 CL.AddDelphiFunction('Function Largest16( const Data, NData : Integer; K : Integer) : Double');
 CL.AddDelphiFunction('Function MedianS( const Data : array of Double) : Double');
 CL.AddDelphiFunction('Function Median16( const Data, NData : Integer) : Double');
 CL.AddDelphiFunction('Function Mode( const Data : array of Double) : Double');
 CL.AddDelphiFunction('Function Mode16( const Data, NData : Integer) : Double');
 CL.AddDelphiFunction('Function Percentile( const Data : array of Double; K : Double) : Double');
 CL.AddDelphiFunction('Function Percentile16( const Data, NData : Integer; K : Double) : Double');
 CL.AddDelphiFunction('Function PercentRank( const Data : array of Double; X : Double) : Double');
 CL.AddDelphiFunction('Function PercentRank16( const Data, NData : Integer; X : Double) : Double');
 CL.AddDelphiFunction('Function Permutations( Number, NumberChosen : Integer) : Extended');
 CL.AddDelphiFunction('Function Combinations( Number, NumberChosen : Integer) : Extended');
 CL.AddDelphiFunction('Function FactorialS( N : Integer) : Extended');
 CL.AddDelphiFunction('Function Rank( Number : Double; const Data : array of Double; Ascending : Boolean) : Integer');
 CL.AddDelphiFunction('Function Rank16( Number : Double; const Data, NData : Integer; Ascending : Boolean) : Integer');
 CL.AddDelphiFunction('Function Smallest( const Data : array of Double; K : Integer) : Double');
 CL.AddDelphiFunction('Function Smallest16( const Data, NData : Integer; K : Integer) : Double');
 CL.AddDelphiFunction('Function TrimMean( const Data : array of Double; Percent : Double) : Double');
 CL.AddDelphiFunction('Function TrimMean16( const Data, NData : Integer; Percent : Double) : Double');
  CL.AddTypeS('TStLinEst', 'record B0 : Double; B1 : double; seB0 : double; seB'
   +'1 : Double; R2 : Double; sigma : Double; SSr : double; SSe : Double; F0 : '
   +'Double; df : Integer; end');
 CL.AddDelphiFunction('Procedure LinEst( const KnownY : array of Double; const KnownX : array of Double; var LF : TStLinEst; ErrorStats : Boolean)');
 CL.AddDelphiFunction('Procedure LogEst( const KnownY : array of Double; const KnownX : array of Double; var LF : TStLinEst; ErrorStats : Boolean)');
 CL.AddDelphiFunction('Function Forecast( X : Double; const KnownY : array of Double; const KnownX : array of Double) : Double');
 CL.AddDelphiFunction('Function ForecastExponential( X : Double; const KnownY : array of Double; const KnownX : array of Double) : Double');
 CL.AddDelphiFunction('Function Intercept( const KnownY : array of Double; const KnownX : array of Double) : Double');
 CL.AddDelphiFunction('Function RSquared( const KnownY : array of Double; const KnownX : array of Double) : Double');
 CL.AddDelphiFunction('Function Slope( const KnownY : array of Double; const KnownX : array of Double) : Double');
 CL.AddDelphiFunction('Function StandardErrorY( const KnownY : array of Double; const KnownX : array of Double) : Double');
 CL.AddDelphiFunction('Function BetaDist( X, Alpha, Beta, A, B : Single) : Single');
 CL.AddDelphiFunction('Function BetaInv( Probability, Alpha, Beta, A, B : Single) : Single');
 CL.AddDelphiFunction('Function BinomDist( NumberS, Trials : Integer; ProbabilityS : Single; Cumulative : Boolean) : Single');
 CL.AddDelphiFunction('Function CritBinom( Trials : Integer; ProbabilityS, Alpha : Single) : Integer');
 CL.AddDelphiFunction('Function ChiDist( X : Single; DegreesFreedom : Integer) : Single');
 CL.AddDelphiFunction('Function ChiInv( Probability : Single; DegreesFreedom : Integer) : Single');
 CL.AddDelphiFunction('Function ExponDist( X, Lambda : Single; Cumulative : Boolean) : Single');
 CL.AddDelphiFunction('Function FDist( X : Single; DegreesFreedom1, DegreesFreedom2 : Integer) : Single');
 CL.AddDelphiFunction('Function FInv( Probability : Single; DegreesFreedom1, DegreesFreedom2 : Integer) : Single');
 CL.AddDelphiFunction('Function LogNormDist( X, Mean, StandardDev : Single) : Single');
 CL.AddDelphiFunction('Function LogInv( Probability, Mean, StandardDev : Single) : Single');
 CL.AddDelphiFunction('Function NormDist( X, Mean, StandardDev : Single; Cumulative : Boolean) : Single');
 CL.AddDelphiFunction('Function NormInv( Probability, Mean, StandardDev : Single) : Single');
 CL.AddDelphiFunction('Function NormSDist( Z : Single) : Single');
 CL.AddDelphiFunction('Function NormSInv( Probability : Single) : Single');
 CL.AddDelphiFunction('Function Poisson( X : Integer; Mean : Single; Cumulative : Boolean) : Single');
 CL.AddDelphiFunction('Function TDist( X : Single; DegreesFreedom : Integer; TwoTails : Boolean) : Single');
 CL.AddDelphiFunction('Function TInv( Probability : Single; DegreesFreedom : Integer) : Single');
 CL.AddDelphiFunction('Function Erfc( X : Single) : Single');
 CL.AddDelphiFunction('Function GammaLn( X : Single) : Single');
 CL.AddDelphiFunction('Function LargestSort( const Data : array of Double; K : Integer) : Double');
 CL.AddDelphiFunction('Function SmallestSort( const Data : array of double; K : Integer) : Double');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StStat_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AveDev, 'AveDev', cdRegister);
 S.RegisterDelphiFunction(@AveDev16, 'AveDev16', cdRegister);
 S.RegisterDelphiFunction(@Confidence, 'Confidence', cdRegister);
 S.RegisterDelphiFunction(@Correlation, 'Correlation', cdRegister);
 S.RegisterDelphiFunction(@Correlation16, 'Correlation16', cdRegister);
 S.RegisterDelphiFunction(@Covariance, 'Covariance', cdRegister);
 S.RegisterDelphiFunction(@Covariance16, 'Covariance16', cdRegister);
 S.RegisterDelphiFunction(@DevSq, 'DevSq', cdRegister);
 S.RegisterDelphiFunction(@DevSq16, 'DevSq16', cdRegister);
 S.RegisterDelphiFunction(@Frequency, 'Frequency', cdRegister);
 //S.RegisterDelphiFunction(@Frequency16, 'Frequency16', cdRegister);
 S.RegisterDelphiFunction(@GeometricMean, 'GeometricMeanS', cdRegister);
 S.RegisterDelphiFunction(@GeometricMean16, 'GeometricMean16', cdRegister);
 S.RegisterDelphiFunction(@HarmonicMean, 'HarmonicMeanS', cdRegister);
 S.RegisterDelphiFunction(@HarmonicMean16, 'HarmonicMean16', cdRegister);
 S.RegisterDelphiFunction(@Largest, 'Largest', cdRegister);
 S.RegisterDelphiFunction(@Largest16, 'Largest16', cdRegister);
 S.RegisterDelphiFunction(@Median, 'MedianS', cdRegister);
 S.RegisterDelphiFunction(@Median16, 'Median16', cdRegister);
 S.RegisterDelphiFunction(@Mode, 'Mode', cdRegister);
 S.RegisterDelphiFunction(@Mode16, 'Mode16', cdRegister);
 S.RegisterDelphiFunction(@Percentile, 'Percentile', cdRegister);
 S.RegisterDelphiFunction(@Percentile16, 'Percentile16', cdRegister);
 S.RegisterDelphiFunction(@PercentRank, 'PercentRank', cdRegister);
 S.RegisterDelphiFunction(@PercentRank16, 'PercentRank16', cdRegister);
 S.RegisterDelphiFunction(@Permutations, 'Permutations', cdRegister);
 S.RegisterDelphiFunction(@Combinations, 'Combinations', cdRegister);
 S.RegisterDelphiFunction(@Factorial, 'FactorialS', cdRegister);
 S.RegisterDelphiFunction(@Rank, 'Rank', cdRegister);
 S.RegisterDelphiFunction(@Rank16, 'Rank16', cdRegister);
 S.RegisterDelphiFunction(@Smallest, 'Smallest', cdRegister);
 S.RegisterDelphiFunction(@Smallest16, 'Smallest16', cdRegister);
 S.RegisterDelphiFunction(@TrimMean, 'TrimMean', cdRegister);
 S.RegisterDelphiFunction(@TrimMean16, 'TrimMean16', cdRegister);
 S.RegisterDelphiFunction(@LinEst, 'LinEst', cdRegister);
 S.RegisterDelphiFunction(@LogEst, 'LogEst', cdRegister);
 S.RegisterDelphiFunction(@Forecast, 'Forecast', cdRegister);
 S.RegisterDelphiFunction(@ForecastExponential, 'ForecastExponential', cdRegister);
 S.RegisterDelphiFunction(@Intercept, 'Intercept', cdRegister);
 S.RegisterDelphiFunction(@RSquared, 'RSquared', cdRegister);
 S.RegisterDelphiFunction(@Slope, 'Slope', cdRegister);
 S.RegisterDelphiFunction(@StandardErrorY, 'StandardErrorY', cdRegister);
 S.RegisterDelphiFunction(@BetaDist, 'BetaDist', cdRegister);
 S.RegisterDelphiFunction(@BetaInv, 'BetaInv', cdRegister);
 S.RegisterDelphiFunction(@BinomDist, 'BinomDist', cdRegister);
 S.RegisterDelphiFunction(@CritBinom, 'CritBinom', cdRegister);
 S.RegisterDelphiFunction(@ChiDist, 'ChiDist', cdRegister);
 S.RegisterDelphiFunction(@ChiInv, 'ChiInv', cdRegister);
 S.RegisterDelphiFunction(@ExponDist, 'ExponDist', cdRegister);
 S.RegisterDelphiFunction(@FDist, 'FDist', cdRegister);
 S.RegisterDelphiFunction(@FInv, 'FInv', cdRegister);
 S.RegisterDelphiFunction(@LogNormDist, 'LogNormDist', cdRegister);
 S.RegisterDelphiFunction(@LogInv, 'LogInv', cdRegister);
 S.RegisterDelphiFunction(@NormDist, 'NormDist', cdRegister);
 S.RegisterDelphiFunction(@NormInv, 'NormInv', cdRegister);
 S.RegisterDelphiFunction(@NormSDist, 'NormSDist', cdRegister);
 S.RegisterDelphiFunction(@NormSInv, 'NormSInv', cdRegister);
 S.RegisterDelphiFunction(@Poisson, 'Poisson', cdRegister);
 S.RegisterDelphiFunction(@TDist, 'TDist', cdRegister);
 S.RegisterDelphiFunction(@TInv, 'TInv', cdRegister);
 S.RegisterDelphiFunction(@Erfc, 'Erfc', cdRegister);
 S.RegisterDelphiFunction(@GammaLn, 'GammaLn', cdRegister);
 S.RegisterDelphiFunction(@LargestSort, 'LargestSort', cdRegister);
 S.RegisterDelphiFunction(@SmallestSort, 'SmallestSort', cdRegister);
end;

 
 
{ TPSImport_StStat }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StStat.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StStat(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StStat.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StStat(ri);
  RIRegister_StStat_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
