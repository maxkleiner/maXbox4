unit uPSI_flcMaths;
{
from double to extended flc- prefix

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
  TPSImport_flcMaths = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_flcMaths(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcMaths_Routines(S: TPSExec);

procedure Register;

implementation


uses
   flcStdTypes
  ,flcMaths
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcMaths]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_flcMaths(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('flcPi','Extended').setExtended( 3.14159265358979323846+ 0.26433832795028841971e-20+ 0.69399375105820974944e-40+ 0.59230781640628620899e-60+ 0.86280348253421170679e-80+ 0.82148086513282306647e-100+ 0.09384460955058223172e-120+ 0.53594081284811174502e-140+ 0.84102701938521105559e-160+ 0.64462294895493038196e-180);
 CL.AddConstantN('flcPi2','Extended').setExtended( 6.283185307179586476925286766559006);
 CL.AddConstantN('flcPi3','Extended').setExtended( 9.424777960769379715387930149838509);
 CL.AddConstantN('flcPi4','Extended').setExtended( 12.56637061435917295385057353311801);
 CL.AddConstantN('flcPiOn2','Extended').setExtended( 1.570796326794896619231321691639751);
 CL.AddConstantN('flcPiOn3','Extended').setExtended( 1.047197551196597746154214461093168);
 CL.AddConstantN('flcPiOn4','Extended').setExtended( 0.785398163397448309615660845819876);
 CL.AddConstantN('flcPiSq','Extended').setExtended( 9.869604401089358618834490999876151);
 CL.AddConstantN('flcPiE','Extended').setExtended( 22.45915771836104547342715220454374);
 CL.AddConstantN('flcLnPi','Extended').setExtended( 1.144729885849400174143427351353059);
 CL.AddConstantN('flcLogPi','Extended').setExtended( 0.497149872694133854351268288290899);
 CL.AddConstantN('flcSqrtPi','Extended').setExtended( 1.772453850905516027298167483341145);
 CL.AddConstantN('flcSqrt2Pi','Extended').setExtended( 2.506628274631000502415765284811045);
 CL.AddConstantN('flcLnSqrt2Pi','Extended').setExtended( 0.918938533204672741780329736405618);
 CL.AddConstantN('flcDegPerRad','Extended').setExtended( 57.29577951308232087679815481410517);
 CL.AddConstantN('flcDegPerGrad','Extended').setExtended( 0.9);
 CL.AddConstantN('flcDegPerCycle','Extended').setExtended( 360.0);
 CL.AddConstantN('flcGradPerCycle','Extended').setExtended( 400.0);
 CL.AddConstantN('flcGradPerDeg','Extended').setExtended( 1.111111111111111111111111111111111);
 CL.AddConstantN('flcGradPerRad','Extended').setExtended( 63.661977236758134307553505349006);
 CL.AddConstantN('flcRadPerDeg','Extended').setExtended( 0.017453292519943295769236907684886);
 CL.AddConstantN('flcRadPerGrad','Extended').setExtended( 0.015707963267948966192313216916398);
 CL.AddConstantN('flcRadPerCycle','Extended').setExtended( 6.283185307179586476925286766559);
 CL.AddConstantN('flcCyclePerDeg','Extended').setExtended( 0.002777777777777777777777777777778);
 CL.AddConstantN('flcCyclePerRad','Extended').setExtended( 0.15915494309189533576888376337251);
 CL.AddConstantN('flcCyclePerGrad','Extended').setExtended( 0.0025);
 CL.AddConstantN('flcE','Extended').setExtended( 2.718281828459045235360287471352663);
 CL.AddConstantN('flcE2','Extended').setExtended( 7.389056098930650227230427460575008);
 CL.AddConstantN('flcExpM2','Extended').setExtended( 0.135335283236612691893999494972484);
 CL.AddConstantN('flcLn2','Extended').setExtended( 0.693147180559945309417232121458177);
 CL.AddConstantN('flcLn10','Extended').setExtended( 2.302585092994045684017991454684364);
 CL.AddConstantN('flcLogE','Extended').setExtended( 0.434294481903251827651128918916605);
 CL.AddConstantN('flcLog2','Extended').setExtended( 0.301029995663981195213738894724493);
 CL.AddConstantN('flcLog3','Extended').setExtended( 0.477121254719662437295027903255115);
 CL.AddConstantN('flcSqrt2','Extended').setExtended( 1.414213562373095048801688724209698);
 CL.AddConstantN('flcSqrt3','Extended').setExtended( 1.732050807568877293527446341505872);
 CL.AddConstantN('flcSqrt5','Extended').setExtended( 2.236067977499789696409173668731276);
 CL.AddConstantN('flcSqrt7','Extended').setExtended( 2.645751311064590590501615753639260);
  //CL.AddTypeS('MFloat', 'Double');
  //CL.AddTypeS('MFloatArray', 'DoubleArray');
  //CL.AddTypeS('MFloat', 'Extended');                        // check t<pe
  CL.AddTypeS('ExtendedArray', 'array of MFloat');
  //ExtendedArray = array of Extended;
  CL.AddTypeS('MFloatArray', 'ExtendedArray');
  CL.AddTypeS('Int64Array', 'array of Int64');
  CL.AddTypeS('flcfx', 'function (const x: Float): Float;');
  CL.AddTypeS('MFloatArray2', 'array of Mfloat');

  //Int64Array  = array of Int64;
 // CL.AddTypeS('PMFloat', '^MFloat // will not work');
 CL.AddDelphiFunction('Procedure SetFPUPrecisionSingle');
 CL.AddDelphiFunction('Procedure SetFPUPrecisionDouble');
 CL.AddDelphiFunction('Procedure SetFPUPrecisionExtended');
 CL.AddDelphiFunction('Procedure SetFPURoundingNearest');
 CL.AddDelphiFunction('Procedure SetFPURoundingDown');
 CL.AddDelphiFunction('Procedure SetFPURoundingUp');
 CL.AddDelphiFunction('Procedure SetFPURoundingTruncate');
 CL.AddDelphiFunction('Function flcPolyEval( const X : MFloat; const Coef : array of MFloat; const N : Integer) : MFloat');
 CL.AddDelphiFunction('Function flcSign( const R : Integer) : Integer;');
 CL.AddDelphiFunction('Function flcSign1( const R : Int64) : Integer;');
 CL.AddDelphiFunction('Function flcSign2( const R : Single) : Integer;');
 CL.AddDelphiFunction('Function flcSign3( const R : Double) : Integer;');
 CL.AddDelphiFunction('Function flcSign4( const R : Extended) : Integer;');
 CL.AddDelphiFunction('Function flcFloatMod( const A, B : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcATan360( const X, Y : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcInverseTangentDeg( const X, Y : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcInverseTangentRad( const X, Y : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcInverseSinDeg( const Y, R : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcInverseSinRad( const Y, R : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcInverseCosDeg( const X, R : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcInverseCosRad( const X, R : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcDMSToReal( const Degs, Mins, Secs : MFloat) : MFloat');
 CL.AddDelphiFunction('Procedure flcRealToDMS( const X : MFloat; var Degs, Mins, Secs : MFloat)');
 CL.AddDelphiFunction('Procedure flcPolarToRectangular( const R, Theta : MFloat; var X, Y : MFloat)');
 CL.AddDelphiFunction('Procedure flcRectangularToPolar( const X, Y : MFloat; var R, Theta : MFloat)');
 CL.AddDelphiFunction('Function flcDistance( const X1, Y1, X2, Y2 : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcIsPrime( const N : Int64) : Boolean');
 CL.AddDelphiFunction('Function flcIsPrimeFactor( const N, F : Int64) : Boolean');
 CL.AddDelphiFunction('Function flcPrimeFactors( const N : Int64) : Int64Array');
 CL.AddDelphiFunction('Function flcGCD( const N1, N2 : Integer) : Integer;');
 CL.AddDelphiFunction('Function flcGCD1( const N1, N2 : Int64) : Int64;');
 CL.AddDelphiFunction('Function flcIsRelativePrime( const X, Y : Int64) : Boolean');
 CL.AddDelphiFunction('Function flcInvMod( const A, N : Integer) : Integer;');
 CL.AddDelphiFunction('Function flcInvMod1( const A, N : Int64) : Int64;');
 CL.AddDelphiFunction('Function flcExpMod( A, Z : Integer; const N : Integer) : Integer;');
 CL.AddDelphiFunction('Function flcExpMod1( A, Z : Int64; const N : Int64) : Int64;');
 CL.AddDelphiFunction('Function flcJacobi( const A, N : Integer) : Integer');
 CL.AddConstantN('FactorialMaxN','LongInt').SetInt( 1754);
 //CL.AddConstantN('FactorialMaxN','LongInt').SetInt( 170);
 CL.AddDelphiFunction('Function flcFactorial( const N : Integer) : MFloat');
 CL.AddDelphiFunction('Function flcCombinations( const N, C : Integer) : MFloat');
 CL.AddDelphiFunction('Function flcPermutations( const N, P : Integer) : MFloat');
 CL.AddDelphiFunction('Function flcFibonacci( const N : Integer) : Int64');
 CL.AddDelphiFunction('Function flcGammaLn( X : Extended) : Extended');
 CL.AddDelphiFunction('Procedure flcFourierTransform( const AngleNumerator : MFloat; const RealIn, ImagIn : array of MFloat; var RealOut, ImagOut : MFloatArray)');
 CL.AddDelphiFunction('Procedure flcFFT( const RealIn, ImagIn : array of MFloat; var RealOut, ImagOut : MFloatArray)');
 CL.AddDelphiFunction('Procedure flcInverseFFT( const RealIn, ImagIn : array of MFloat; var RealOut, ImagOut : MFloatArray)');
 CL.AddDelphiFunction('Procedure flcCalcFrequency( const FrequencyIndex : Integer; const RealIn, ImagIn : array of MFloat; var RealOut, ImagOut : MFloat)');
 CL.AddDelphiFunction('Function flcSecantSolver( const f : flcfx; const y, Guess1, Guess2 : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcNewtonSolver( const f, df : flcfx; const y, Guess : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcFirstDerivative( const f : flcfx; const x : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcSecondDerivative( const f : flcfx; const x : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcThirdDerivative( const f : flcfx; const x : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcFourthDerivative( const f : flcfx; const x : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcSimpsonIntegration( const f : flcfx; const a, b : MFloat; N : Integer) : MFloat');
 CL.AddDelphiFunction('Procedure TestMathClass');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ExpMod10_P( A, Z : Int64; const N : Int64) : Int64;
Begin Result := flcMaths.ExpMod(A, Z, N); END;

(*----------------------------------------------------------------------------*)
Function ExpMod9_P( A, Z : Integer; const N : Integer) : Integer;
Begin Result := flcMaths.ExpMod(A, Z, N); END;

(*----------------------------------------------------------------------------*)
Function InvMod8_P( const A, N : Int64) : Int64;
Begin Result := flcMaths.InvMod(A, N); END;

(*----------------------------------------------------------------------------*)
Function InvMod7_P( const A, N : Integer) : Integer;
Begin Result := flcMaths.InvMod(A, N); END;

(*----------------------------------------------------------------------------*)
Function GCD6_P( const N1, N2 : Int64) : Int64;
Begin Result := flcMaths.GCD(N1, N2); END;

(*----------------------------------------------------------------------------*)
Function GCD5_P( const N1, N2 : Integer) : Integer;
Begin Result := flcMaths.GCD(N1, N2); END;

(*----------------------------------------------------------------------------*)
Function Sign4_P( const R : Extended) : Integer;
Begin Result := flcMaths.Sign(R); END;

(*----------------------------------------------------------------------------*)
Function Sign3_P( const R : Double) : Integer;
Begin Result := flcMaths.Sign(R); END;

(*----------------------------------------------------------------------------*)
Function Sign2_P( const R : Single) : Integer;
Begin Result := flcMaths.Sign(R); END;

(*----------------------------------------------------------------------------*)
Function Sign1_P( const R : Int64) : Integer;
Begin Result := flcMaths.Sign(R); END;

(*----------------------------------------------------------------------------*)
Function Sign0_P( const R : Integer) : Integer;
Begin Result := flcMaths.Sign(R); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcMaths_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetFPUPrecisionSingle, 'SetFPUPrecisionSingle', cdRegister);
 S.RegisterDelphiFunction(@SetFPUPrecisionDouble, 'SetFPUPrecisionDouble', cdRegister);
 S.RegisterDelphiFunction(@SetFPUPrecisionExtended, 'SetFPUPrecisionExtended', cdRegister);
 S.RegisterDelphiFunction(@SetFPURoundingNearest, 'SetFPURoundingNearest', cdRegister);
 S.RegisterDelphiFunction(@SetFPURoundingDown, 'SetFPURoundingDown', cdRegister);
 S.RegisterDelphiFunction(@SetFPURoundingUp, 'SetFPURoundingUp', cdRegister);
 S.RegisterDelphiFunction(@SetFPURoundingTruncate, 'SetFPURoundingTruncate', cdRegister);
 S.RegisterDelphiFunction(@PolyEval, 'flcPolyEval', cdRegister);
 S.RegisterDelphiFunction(@Sign0_P, 'flcSign', cdRegister);
 S.RegisterDelphiFunction(@Sign1_P, 'flcSign1', cdRegister);
 S.RegisterDelphiFunction(@Sign2_P, 'flcSign2', cdRegister);
 S.RegisterDelphiFunction(@Sign3_P, 'flcSign3', cdRegister);
 S.RegisterDelphiFunction(@Sign4_P, 'flcSign4', cdRegister);
 S.RegisterDelphiFunction(@FloatMod, 'flcFloatMod', cdRegister);
 S.RegisterDelphiFunction(@ATan360, 'flcATan360', cdRegister);
 S.RegisterDelphiFunction(@InverseTangentDeg, 'flcInverseTangentDeg', cdRegister);
 S.RegisterDelphiFunction(@InverseTangentRad, 'flcInverseTangentRad', cdRegister);
 S.RegisterDelphiFunction(@InverseSinDeg, 'flcInverseSinDeg', cdRegister);
 S.RegisterDelphiFunction(@InverseSinRad, 'flcInverseSinRad', cdRegister);
 S.RegisterDelphiFunction(@InverseCosDeg, 'flcInverseCosDeg', cdRegister);
 S.RegisterDelphiFunction(@InverseCosRad, 'flcInverseCosRad', cdRegister);
 S.RegisterDelphiFunction(@DMSToReal, 'flcDMSToReal', cdRegister);
 S.RegisterDelphiFunction(@RealToDMS, 'flcRealToDMS', cdRegister);
 S.RegisterDelphiFunction(@PolarToRectangular, 'flcPolarToRectangular', cdRegister);
 S.RegisterDelphiFunction(@RectangularToPolar, 'flcRectangularToPolar', cdRegister);
 S.RegisterDelphiFunction(@Distance, 'flcDistance', cdRegister);
 S.RegisterDelphiFunction(@IsPrime, 'flcIsPrime', cdRegister);
 S.RegisterDelphiFunction(@IsPrimeFactor, 'flcIsPrimeFactor', cdRegister);
 S.RegisterDelphiFunction(@PrimeFactors2, 'flcPrimeFactors', cdRegister);
 S.RegisterDelphiFunction(@GCD5_P, 'flcGCD', cdRegister);
 S.RegisterDelphiFunction(@GCD6_P, 'flcGCD1', cdRegister);
 S.RegisterDelphiFunction(@IsRelativePrime, 'flcIsRelativePrime', cdRegister);
 S.RegisterDelphiFunction(@InvMod7_P, 'flcInvMod', cdRegister);
 S.RegisterDelphiFunction(@InvMod8_P, 'flcInvMod1', cdRegister);
 S.RegisterDelphiFunction(@ExpMod9_P, 'flcExpMod', cdRegister);
 S.RegisterDelphiFunction(@ExpMod10_P, 'flcExpMod1', cdRegister);
 S.RegisterDelphiFunction(@Jacobi, 'flcJacobi', cdRegister);
 S.RegisterDelphiFunction(@Factorial, 'flcFactorial', cdRegister);
 S.RegisterDelphiFunction(@Combinations, 'flcCombinations', cdRegister);
 S.RegisterDelphiFunction(@Permutations, 'flcPermutations', cdRegister);
 S.RegisterDelphiFunction(@Fibonacci, 'flcFibonacci', cdRegister);
 S.RegisterDelphiFunction(@GammaLn, 'flcGammaLn', cdRegister);
 S.RegisterDelphiFunction(@FourierTransform, 'flcFourierTransform', cdRegister);
 S.RegisterDelphiFunction(@FFT, 'flcFFT', cdRegister);
 S.RegisterDelphiFunction(@InverseFFT, 'flcInverseFFT', cdRegister);
 S.RegisterDelphiFunction(@CalcFrequency, 'flcCalcFrequency', cdRegister);
 S.RegisterDelphiFunction(@SecantSolver, 'flcSecantSolver', cdRegister);
 S.RegisterDelphiFunction(@NewtonSolver, 'flcNewtonSolver', cdRegister);
 S.RegisterDelphiFunction(@FirstDerivative, 'flcFirstDerivative', cdRegister);
 S.RegisterDelphiFunction(@SecondDerivative, 'flcSecondDerivative', cdRegister);
 S.RegisterDelphiFunction(@ThirdDerivative, 'flcThirdDerivative', cdRegister);
 S.RegisterDelphiFunction(@FourthDerivative, 'flcFourthDerivative', cdRegister);
 S.RegisterDelphiFunction(@SimpsonIntegration, 'flcSimpsonIntegration', cdRegister);
 S.RegisterDelphiFunction(@Test, 'TestMathClass', cdRegister);
end;

 
 
{ TPSImport_flcMaths }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcMaths.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcMaths(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcMaths.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcMaths_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
