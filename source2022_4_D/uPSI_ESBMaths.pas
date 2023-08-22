unit uPSI_ESBMaths;
{
   MATHMAX  , no currency otherwise floating point error!!
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
  TPSImport_ESBMaths = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ESBMaths(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ESBMaths_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ESBMaths
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ESBMaths]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ESBMaths(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ESBMinSingle','Single').setExtended( 1.5e-45);
 CL.AddConstantN('ESBMaxSingle','Single').setExtended( 3.4e+38);
 CL.AddConstantN('ESBMinDouble','Double').setExtended( 5.0e-324);
 CL.AddConstantN('ESBMaxDouble','Double').setExtended( 1.7e+308);
 CL.AddConstantN('ESBMinExtended','Extended').setExtended( 3.6e-4951);
 //CL.AddConstantN('ESBMaxExtended','Extended').setExtended( 1.1e+4932);
 //CL.AddConstantN('ESBMinCurrency','Currency').SetExtended( - 922337203685477.5807);
 //CL.AddConstantN('ESBMaxCurrency','Currency').SetExtended( 922337203685477.5807);
 CL.AddConstantN('ESBSqrt2','Extended').setExtended( 1.4142135623730950488);
 CL.AddConstantN('ESBSqrt3','Extended').setExtended( 1.7320508075688772935);
 CL.AddConstantN('ESBSqrt5','Extended').setExtended( 2.2360679774997896964);
 CL.AddConstantN('ESBSqrt10','Extended').setExtended( 3.1622776601683793320);
 CL.AddConstantN('ESBSqrtPi','Extended').setExtended( 1.77245385090551602729);
 CL.AddConstantN('ESBCbrt2','Extended').setExtended( 1.2599210498948731648);
 CL.AddConstantN('ESBCbrt3','Extended').setExtended( 1.4422495703074083823);
 CL.AddConstantN('ESBCbrt10','Extended').setExtended( 2.1544346900318837219);
 CL.AddConstantN('ESBCbrt100','Extended').setExtended( 4.6415888336127788924);
 CL.AddConstantN('ESBCbrtPi','Extended').setExtended( 1.4645918875615232630);
 CL.AddConstantN('ESBInvSqrt2','Extended').setExtended( 0.70710678118654752440);
 CL.AddConstantN('ESBInvSqrt3','Extended').setExtended( 0.57735026918962576451);
 CL.AddConstantN('ESBInvSqrt5','Extended').setExtended( 0.44721359549995793928);
 CL.AddConstantN('ESBInvSqrtPi','Extended').setExtended( 0.56418958354775628695);
 CL.AddConstantN('ESBInvCbrtPi','Extended').setExtended( 0.68278406325529568147);
 CL.AddConstantN('ESBe','Extended').setExtended( 2.7182818284590452354);
 CL.AddConstantN('ESBe2','Extended').setExtended( 7.3890560989306502272);
 CL.AddConstantN('ESBePi','Extended').setExtended( 23.140692632779269006);
 CL.AddConstantN('ESBePiOn2','Extended').setExtended( 4.8104773809653516555);
 CL.AddConstantN('ESBePiOn4','Extended').setExtended( 2.1932800507380154566);
 CL.AddConstantN('ESBLn2','Extended').setExtended( 0.69314718055994530942);
 CL.AddConstantN('ESBLn10','Extended').setExtended( 2.30258509299404568402);
 CL.AddConstantN('ESBLnPi','Extended').setExtended( 1.14472988584940017414);
 CL.AddConstantN('ESBLog10Base2','Extended').setExtended( 3.3219280948873623478);
 CL.AddConstantN('ESBLog2Base10','Extended').setExtended( 0.30102999566398119521);
 CL.AddConstantN('ESBLog3Base10','Extended').setExtended( 0.47712125471966243730);
 CL.AddConstantN('ESBLogPiBase10','Extended').setExtended( 0.4971498726941339);
 CL.AddConstantN('ESBLogEBase10','Extended').setExtended( 0.43429448190325182765);
 CL.AddConstantN('ESBPi','Extended').setExtended( 3.1415926535897932385);
 CL.AddConstantN('ESBInvPi','Extended').setExtended( 3.1830988618379067154e-1);
 CL.AddConstantN('ESBTwoPi','Extended').setExtended( 6.2831853071795864769);
 CL.AddConstantN('ESBThreePi','Extended').setExtended( 9.4247779607693797153);
 CL.AddConstantN('ESBPi2','Extended').setExtended( 9.8696044010893586188);
 CL.AddConstantN('ESBPiToE','Extended').setExtended( 22.459157718361045473);
 CL.AddConstantN('ESBPiOn2','Extended').setExtended( 1.5707963267948966192);
 CL.AddConstantN('ESBPiOn3','Extended').setExtended( 1.0471975511965977462);
 CL.AddConstantN('ESBPiOn4','Extended').setExtended( 0.7853981633974483096);
 CL.AddConstantN('ESBThreePiOn2','Extended').setExtended( 4.7123889803846898577);
 CL.AddConstantN('ESBFourPiOn3','Extended').setExtended( 4.1887902047863909846);
 CL.AddConstantN('ESBTwoToPower63','Extended').setExtended( 9223372036854775808.0);
 CL.AddConstantN('ESBOneRadian','Extended').setExtended( 57.295779513082320877);
 CL.AddConstantN('ESBOneDegree','Extended').setExtended( 1.7453292519943295769E-2);
 CL.AddConstantN('ESBOneMinute','Extended').setExtended( 2.9088820866572159615E-4);
 CL.AddConstantN('ESBOneSecond','Extended').setExtended( 4.8481368110953599359E-6);
 CL.AddConstantN('ESBGamma','Extended').setExtended( 0.57721566490153286061);
 CL.AddConstantN('ESBLnRt2Pi','Extended').setExtended( 9.189385332046727E-1);
  //CL.AddTypeS('LongWord', 'Cardinal');
  CL.AddTypeS('TBitList', 'Word');
 CL.AddDelphiFunction('Function UMul( const Num1, Num2 : LongWord) : LongWord');
 CL.AddDelphiFunction('Function UMulDiv2p32( const Num1, Num2 : LongWord) : LongWord');
 CL.AddDelphiFunction('Function UMulDiv( const Num1, Num2, Divisor : LongWord) : LongWord');
 CL.AddDelphiFunction('Function UMulMod( const Num1, Num2, Modulus : LongWord) : LongWord');
 CL.AddDelphiFunction('Function SameFloat( const X1, X2 : Extended) : Boolean');
 CL.AddDelphiFunction('Function FloatIsZero( const X : Extended) : Boolean');
 CL.AddDelphiFunction('Function FloatIsPositive( const X : Extended) : Boolean');
 CL.AddDelphiFunction('Function FloatIsNegative( const X : Extended) : Boolean');
 CL.AddDelphiFunction('Procedure IncLim( var B : Byte; const Limit : Byte)');
 CL.AddDelphiFunction('Procedure IncLimSI( var B : ShortInt; const Limit : ShortInt)');
 CL.AddDelphiFunction('Procedure IncLimW( var B : Word; const Limit : Word)');
 CL.AddDelphiFunction('Procedure IncLimI( var B : Integer; const Limit : Integer)');
 CL.AddDelphiFunction('Procedure IncLimL( var B : LongInt; const Limit : LongInt)');
 CL.AddDelphiFunction('Procedure DecLim( var B : Byte; const Limit : Byte)');
 CL.AddDelphiFunction('Procedure DecLimSI( var B : ShortInt; const Limit : ShortInt)');
 CL.AddDelphiFunction('Procedure DecLimW( var B : Word; const Limit : Word)');
 CL.AddDelphiFunction('Procedure DecLimI( var B : Integer; const Limit : Integer)');
 CL.AddDelphiFunction('Procedure DecLimL( var B : LongInt; const Limit : LongInt)');
 CL.AddDelphiFunction('Function MaxB( const B1, B2 : Byte) : Byte');
 CL.AddDelphiFunction('Function MinB( const B1, B2 : Byte) : Byte');
 CL.AddDelphiFunction('Function MaxSI( const B1, B2 : ShortInt) : ShortInt');
 CL.AddDelphiFunction('Function MinSI( const B1, B2 : ShortInt) : ShortInt');
 CL.AddDelphiFunction('Function MaxW( const B1, B2 : Word) : Word');
 CL.AddDelphiFunction('Function MinW( const B1, B2 : Word) : Word');
 CL.AddDelphiFunction('Function esbMaxI( const B1, B2 : Integer) : Integer');
 CL.AddDelphiFunction('Function esbMinI( const B1, B2 : Integer) : Integer');
 CL.AddDelphiFunction('Function MaxL( const B1, B2 : LongInt) : LongInt');
 CL.AddDelphiFunction('Function MinL( const B1, B2 : LongInt) : LongInt');
 CL.AddDelphiFunction('Procedure SwapB( var B1, B2 : Byte)');
 CL.AddDelphiFunction('Procedure SwapSI( var B1, B2 : ShortInt)');
 CL.AddDelphiFunction('Procedure SwapW( var B1, B2 : Word)');
 CL.AddDelphiFunction('Procedure SwapI( var B1, B2 : SmallInt)');
 CL.AddDelphiFunction('Procedure SwapL( var B1, B2 : LongInt)');
 CL.AddDelphiFunction('Procedure SwapI32( var B1, B2 : Integer)');
 CL.AddDelphiFunction('Procedure SwapC( var B1, B2 : LongWord)');
 CL.AddDelphiFunction('Procedure SwapInt64( var X, Y : Int64)');
 CL.AddDelphiFunction('Function esbSign( const B : LongInt) : ShortInt');
 CL.AddDelphiFunction('Function Max4Word( const X1, X2, X3, X4 : Word) : Word');
 CL.AddDelphiFunction('Function Min4Word( const X1, X2, X3, X4 : Word) : Word');
 CL.AddDelphiFunction('Function Max3Word( const X1, X2, X3 : Word) : Word');
 CL.AddDelphiFunction('Function Min3Word( const X1, X2, X3 : Word) : Word');
 CL.AddDelphiFunction('Function MaxBArray( const B : array of Byte) : Byte');
 CL.AddDelphiFunction('Function MaxWArray( const B : array of Word) : Word');
 CL.AddDelphiFunction('Function MaxSIArray( const B : array of ShortInt) : ShortInt');
 CL.AddDelphiFunction('Function MaxIArray( const B : array of Integer) : Integer');
 CL.AddDelphiFunction('Function MaxLArray( const B : array of LongInt) : LongInt');
 CL.AddDelphiFunction('Function MinBArray( const B : array of Byte) : Byte');
 CL.AddDelphiFunction('Function MinWArray( const B : array of Word) : Word');
 CL.AddDelphiFunction('Function MinSIArray( const B : array of ShortInt) : ShortInt');
 CL.AddDelphiFunction('Function MinIArray( const B : array of Integer) : Integer');
 CL.AddDelphiFunction('Function MinLArray( const B : array of LongInt) : LongInt');
 CL.AddDelphiFunction('Function SumBArray( const B : array of Byte) : Byte');
 CL.AddDelphiFunction('Function SumBArray2( const B : array of Byte) : Word');
 CL.AddDelphiFunction('Function SumSIArray( const B : array of ShortInt) : ShortInt');
 CL.AddDelphiFunction('Function SumSIArray2( const B : array of ShortInt) : Integer');
 CL.AddDelphiFunction('Function SumWArray( const B : array of Word) : Word');
 CL.AddDelphiFunction('Function SumWArray2( const B : array of Word) : LongInt');
 CL.AddDelphiFunction('Function SumIArray( const B : array of Integer) : Integer');
 CL.AddDelphiFunction('Function SumLArray( const B : array of LongInt) : LongInt');
 CL.AddDelphiFunction('Function SumLWArray( const B : array of LongWord) : LongWord');
 CL.AddDelphiFunction('Function ESBDigits( const X : LongWord) : Byte');
 CL.AddDelphiFunction('Function BitsHighest( const X : LongWord) : Integer');
 CL.AddDelphiFunction('Function ESBBitsNeeded( const X : LongWord) : Integer');
 CL.AddDelphiFunction('Function esbGCD( const X, Y : LongWord) : LongWord');
 CL.AddDelphiFunction('Function esbLCM( const X, Y : LongInt) : Int64');
 //CL.AddDelphiFunction('Function esbLCM( const X, Y : LongInt) : LongInt');
 CL.AddDelphiFunction('Function RelativePrime( const X, Y : LongWord) : Boolean');
 CL.AddDelphiFunction('Function Get87ControlWord : TBitList');
 CL.AddDelphiFunction('Procedure Set87ControlWord( const CWord : TBitList)');
 CL.AddDelphiFunction('Procedure SwapExt( var X, Y : Extended)');
 CL.AddDelphiFunction('Procedure SwapDbl( var X, Y : Double)');
 CL.AddDelphiFunction('Procedure SwapSing( var X, Y : Single)');
 CL.AddDelphiFunction('Function esbSgn( const X : Extended) : ShortInt');
 CL.AddDelphiFunction('Function Distance( const X1, Y1, X2, Y2 : Extended) : Extended');
 CL.AddDelphiFunction('Function ExtMod( const X, Y : Extended) : Extended');
 CL.AddDelphiFunction('Function ExtRem( const X, Y : Extended) : Extended');
 CL.AddDelphiFunction('Function CompMOD( const X, Y : Comp) : Comp');
 CL.AddDelphiFunction('Procedure Polar2XY( const Rho, Theta : Extended; var X, Y : Extended)');
 CL.AddDelphiFunction('Procedure XY2Polar( const X, Y : Extended; var Rho, Theta : Extended)');
 CL.AddDelphiFunction('Function DMS2Extended( const Degs, Mins, Secs : Extended) : Extended');
 CL.AddDelphiFunction('Procedure Extended2DMS( const X : Extended; var Degs, Mins, Secs : Extended)');
 CL.AddDelphiFunction('Function MaxExt( const X, Y : Extended) : Extended');
 CL.AddDelphiFunction('Function MinExt( const X, Y : Extended) : Extended');
 CL.AddDelphiFunction('Function MaxEArray( const B : array of Extended) : Extended');
 CL.AddDelphiFunction('Function MinEArray( const B : array of Extended) : Extended');
 CL.AddDelphiFunction('Function MaxSArray( const B : array of Single) : Single');
 CL.AddDelphiFunction('Function MinSArray( const B : array of Single) : Single');
 CL.AddDelphiFunction('Function MaxCArray( const B : array of Comp) : Comp');
 CL.AddDelphiFunction('Function MinCArray( const B : array of Comp) : Comp');
 CL.AddDelphiFunction('Function SumSArray( const B : array of Single) : Single');
 CL.AddDelphiFunction('Function SumEArray( const B : array of Extended) : Extended');
 CL.AddDelphiFunction('Function SumSqEArray( const B : array of Extended) : Extended');
 CL.AddDelphiFunction('Function SumSqDiffEArray( const B : array of Extended; Diff : Extended) : Extended');
 CL.AddDelphiFunction('Function SumXYEArray( const X, Y : array of Extended) : Extended');
 CL.AddDelphiFunction('Function SumCArray( const B : array of Comp) : Comp');
 CL.AddDelphiFunction('Function FactorialX( A : LongWord) : Extended');
 CL.AddDelphiFunction('Function PermutationX( N, R : LongWord) : Extended');
 CL.AddDelphiFunction('Function esbBinomialCoeff( N, R : LongWord) : Extended');
 CL.AddDelphiFunction('Function IsPositiveEArray( const X : array of Extended) : Boolean');
 CL.AddDelphiFunction('Function esbGeometricMean( const X : array of Extended) : Extended');
 CL.AddDelphiFunction('Function esbHarmonicMean( const X : array of Extended) : Extended');
 CL.AddDelphiFunction('Function ESBMean( const X : array of Extended) : Extended');
 CL.AddDelphiFunction('Function esbSampleVariance( const X : array of Extended) : Extended');
 CL.AddDelphiFunction('Function esbPopulationVariance( const X : array of Extended) : Extended');
 CL.AddDelphiFunction('Procedure esbSampleVarianceAndMean( const X : array of Extended; var Variance, Mean : Extended)');
 CL.AddDelphiFunction('Procedure esbPopulationVarianceAndMean( const X : array of Extended; var Variance, Mean : Extended)');
 CL.AddDelphiFunction('Function GetMedian( const SortedX : array of Extended) : Extended');
 CL.AddDelphiFunction('Function GetMode( const SortedX : array of Extended; var Mode : Extended) : Boolean');
 CL.AddDelphiFunction('Procedure GetQuartiles( const SortedX : array of Extended; var Q1, Q3 : Extended)');
 CL.AddDelphiFunction('Function ESBMagnitude( const X : Extended) : Integer');
 CL.AddDelphiFunction('Function ESBTan( Angle : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBCot( Angle : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBCosec( const Angle : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBSec( const Angle : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBArcTan( X, Y : Extended) : Extended');
 CL.AddDelphiFunction('Procedure ESBSinCos( Angle : Extended; var SinX, CosX : Extended)');
 CL.AddDelphiFunction('Function ESBArcCos( const X : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBArcSin( const X : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBArcSec( const X : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBArcCosec( const X : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBLog10( const X : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBLog2( const X : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBLogBase( const X, Base : Extended) : Extended');
 CL.AddDelphiFunction('Function Pow2( const X : Extended) : Extended');
 CL.AddDelphiFunction('Function IntPow( const Base : Extended; const Exponent : LongWord) : Extended');
 CL.AddDelphiFunction('Function ESBIntPower( const X : Extended; const N : LongInt) : Extended');
 CL.AddDelphiFunction('Function XtoY( const X, Y : Extended) : Extended');
 CL.AddDelphiFunction('Function esbTenToY( const Y : Extended) : Extended');
 CL.AddDelphiFunction('Function esbTwoToY( const Y : Extended) : Extended');
 CL.AddDelphiFunction('Function LogXtoBaseY( const X, Y : Extended) : Extended');
 CL.AddDelphiFunction('Function esbISqrt( const I : LongWord) : Longword');
 CL.AddDelphiFunction('Function ILog2( const I : LongWord) : LongWord');
 CL.AddDelphiFunction('Function IGreatestPowerOf2( const N : LongWord) : LongWord');
 CL.AddDelphiFunction('Function ESBArCosh( X : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBArSinh( X : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBArTanh( X : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBCosh( X : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBSinh( X : Extended) : Extended');
 CL.AddDelphiFunction('Function ESBTanh( X : Extended) : Extended');
 CL.AddDelphiFunction('Function InverseGamma( const X : Extended) : Extended');
 CL.AddDelphiFunction('Function esbGamma( const X : Extended) : Extended');
 CL.AddDelphiFunction('Function esbLnGamma( const X : Extended) : Extended');
 CL.AddDelphiFunction('Function esbBeta( const X, Y : Extended) : Extended');
 CL.AddDelphiFunction('Function IncompleteBeta( X : Extended; P, Q : Extended) : Extended');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ESBMaths_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@UMul, 'UMul', cdRegister);
 S.RegisterDelphiFunction(@UMulDiv2p32, 'UMulDiv2p32', cdRegister);
 S.RegisterDelphiFunction(@UMulDiv, 'UMulDiv', cdRegister);
 S.RegisterDelphiFunction(@UMulMod, 'UMulMod', cdRegister);
 S.RegisterDelphiFunction(@SameFloat, 'SameFloat', cdRegister);
 S.RegisterDelphiFunction(@FloatIsZero, 'FloatIsZero', cdRegister);
 S.RegisterDelphiFunction(@FloatIsPositive, 'FloatIsPositive', cdRegister);
 S.RegisterDelphiFunction(@FloatIsNegative, 'FloatIsNegative', cdRegister);
 S.RegisterDelphiFunction(@IncLim, 'IncLim', cdRegister);
 S.RegisterDelphiFunction(@IncLimSI, 'IncLimSI', cdRegister);
 S.RegisterDelphiFunction(@IncLimW, 'IncLimW', cdRegister);
 S.RegisterDelphiFunction(@IncLimI, 'IncLimI', cdRegister);
 S.RegisterDelphiFunction(@IncLimL, 'IncLimL', cdRegister);
 S.RegisterDelphiFunction(@DecLim, 'DecLim', cdRegister);
 S.RegisterDelphiFunction(@DecLimSI, 'DecLimSI', cdRegister);
 S.RegisterDelphiFunction(@DecLimW, 'DecLimW', cdRegister);
 S.RegisterDelphiFunction(@DecLimI, 'DecLimI', cdRegister);
 S.RegisterDelphiFunction(@DecLimL, 'DecLimL', cdRegister);
 S.RegisterDelphiFunction(@MaxB, 'MaxB', cdRegister);
 S.RegisterDelphiFunction(@MinB, 'MinB', cdRegister);
 S.RegisterDelphiFunction(@MaxSI, 'MaxSI', cdRegister);
 S.RegisterDelphiFunction(@MinSI, 'MinSI', cdRegister);
 S.RegisterDelphiFunction(@MaxW, 'MaxW', cdRegister);
 S.RegisterDelphiFunction(@MinW, 'MinW', cdRegister);
 S.RegisterDelphiFunction(@MaxI, 'esbMaxI', cdRegister);
 S.RegisterDelphiFunction(@MinI, 'esbMinI', cdRegister);
 S.RegisterDelphiFunction(@MaxL, 'MaxL', cdRegister);
 S.RegisterDelphiFunction(@MinL, 'MinL', cdRegister);
 S.RegisterDelphiFunction(@SwapB, 'SwapB', cdRegister);
 S.RegisterDelphiFunction(@SwapSI, 'SwapSI', cdRegister);
 S.RegisterDelphiFunction(@SwapW, 'SwapW', cdRegister);
 S.RegisterDelphiFunction(@SwapI, 'SwapI', cdRegister);
 S.RegisterDelphiFunction(@SwapL, 'SwapL', cdRegister);
 S.RegisterDelphiFunction(@SwapI32, 'SwapI32', cdRegister);
 S.RegisterDelphiFunction(@SwapC, 'SwapC', cdRegister);
 S.RegisterDelphiFunction(@SwapInt64, 'SwapInt64', cdRegister);
 S.RegisterDelphiFunction(@Sign, 'esbSign', cdRegister);
 S.RegisterDelphiFunction(@Max4Word, 'Max4Word', cdRegister);
 S.RegisterDelphiFunction(@Min4Word, 'Min4Word', cdRegister);
 S.RegisterDelphiFunction(@Max3Word, 'Max3Word', cdRegister);
 S.RegisterDelphiFunction(@Min3Word, 'Min3Word', cdRegister);
 S.RegisterDelphiFunction(@MaxBArray, 'MaxBArray', cdRegister);
 S.RegisterDelphiFunction(@MaxWArray, 'MaxWArray', cdRegister);
 S.RegisterDelphiFunction(@MaxSIArray, 'MaxSIArray', cdRegister);
 S.RegisterDelphiFunction(@MaxIArray, 'MaxIArray', cdRegister);
 S.RegisterDelphiFunction(@MaxLArray, 'MaxLArray', cdRegister);
 S.RegisterDelphiFunction(@MinBArray, 'MinBArray', cdRegister);
 S.RegisterDelphiFunction(@MinWArray, 'MinWArray', cdRegister);
 S.RegisterDelphiFunction(@MinSIArray, 'MinSIArray', cdRegister);
 S.RegisterDelphiFunction(@MinIArray, 'MinIArray', cdRegister);
 S.RegisterDelphiFunction(@MinLArray, 'MinLArray', cdRegister);
 S.RegisterDelphiFunction(@SumBArray, 'SumBArray', cdRegister);
 S.RegisterDelphiFunction(@SumBArray2, 'SumBArray2', cdRegister);
 S.RegisterDelphiFunction(@SumSIArray, 'SumSIArray', cdRegister);
 S.RegisterDelphiFunction(@SumSIArray2, 'SumSIArray2', cdRegister);
 S.RegisterDelphiFunction(@SumWArray, 'SumWArray', cdRegister);
 S.RegisterDelphiFunction(@SumWArray2, 'SumWArray2', cdRegister);
 S.RegisterDelphiFunction(@SumIArray, 'SumIArray', cdRegister);
 S.RegisterDelphiFunction(@SumLArray, 'SumLArray', cdRegister);
 S.RegisterDelphiFunction(@SumLWArray, 'SumLWArray', cdRegister);
 S.RegisterDelphiFunction(@ESBDigits, 'ESBDigits', cdRegister);
 S.RegisterDelphiFunction(@BitsHighest, 'BitsHighest', cdRegister);
 S.RegisterDelphiFunction(@ESBBitsNeeded, 'ESBBitsNeeded', cdRegister);
 S.RegisterDelphiFunction(@GCD, 'esbGCD', cdRegister);
 S.RegisterDelphiFunction(@LCM, 'esbLCM', cdRegister);
 //S.RegisterDelphiFunction(@LCM, 'esbLCM', cdRegister);
 S.RegisterDelphiFunction(@RelativePrime, 'RelativePrime', cdRegister);
 S.RegisterDelphiFunction(@Get87ControlWord, 'Get87ControlWord', cdRegister);
 S.RegisterDelphiFunction(@Set87ControlWord, 'Set87ControlWord', cdRegister);
 S.RegisterDelphiFunction(@SwapExt, 'SwapExt', cdRegister);
 S.RegisterDelphiFunction(@SwapDbl, 'SwapDbl', cdRegister);
 S.RegisterDelphiFunction(@SwapSing, 'SwapSing', cdRegister);
 S.RegisterDelphiFunction(@Sgn, 'esbSgn', cdRegister);
 S.RegisterDelphiFunction(@Distance, 'Distance', cdRegister);
 S.RegisterDelphiFunction(@ExtMod, 'ExtMod', cdRegister);
 S.RegisterDelphiFunction(@ExtRem, 'ExtRem', cdRegister);
 S.RegisterDelphiFunction(@CompMOD, 'CompMOD', cdRegister);
 S.RegisterDelphiFunction(@Polar2XY, 'Polar2XY', cdRegister);
 S.RegisterDelphiFunction(@XY2Polar, 'XY2Polar', cdRegister);
 S.RegisterDelphiFunction(@DMS2Extended, 'DMS2Extended', cdRegister);
 S.RegisterDelphiFunction(@Extended2DMS, 'Extended2DMS', cdRegister);
 S.RegisterDelphiFunction(@MaxExt, 'MaxExt', cdRegister);
 S.RegisterDelphiFunction(@MinExt, 'MinExt', cdRegister);
 S.RegisterDelphiFunction(@MaxEArray, 'MaxEArray', cdRegister);
 S.RegisterDelphiFunction(@MinEArray, 'MinEArray', cdRegister);
 S.RegisterDelphiFunction(@MaxSArray, 'MaxSArray', cdRegister);
 S.RegisterDelphiFunction(@MinSArray, 'MinSArray', cdRegister);
 S.RegisterDelphiFunction(@MaxCArray, 'MaxCArray', cdRegister);
 S.RegisterDelphiFunction(@MinCArray, 'MinCArray', cdRegister);
 S.RegisterDelphiFunction(@SumSArray, 'SumSArray', cdRegister);
 S.RegisterDelphiFunction(@SumEArray, 'SumEArray', cdRegister);
 S.RegisterDelphiFunction(@SumSqEArray, 'SumSqEArray', cdRegister);
 S.RegisterDelphiFunction(@SumSqDiffEArray, 'SumSqDiffEArray', cdRegister);
 S.RegisterDelphiFunction(@SumXYEArray, 'SumXYEArray', cdRegister);
 S.RegisterDelphiFunction(@SumCArray, 'SumCArray', cdRegister);
 S.RegisterDelphiFunction(@FactorialX, 'FactorialX', cdRegister);
 S.RegisterDelphiFunction(@PermutationX, 'PermutationX', cdRegister);
 S.RegisterDelphiFunction(@BinomialCoeff, 'esbBinomialCoeff', cdRegister);
 S.RegisterDelphiFunction(@IsPositiveEArray, 'IsPositiveEArray', cdRegister);
 S.RegisterDelphiFunction(@GeometricMean, 'esbGeometricMean', cdRegister);
 S.RegisterDelphiFunction(@HarmonicMean, 'esbHarmonicMean', cdRegister);
 S.RegisterDelphiFunction(@ESBMean, 'ESBMean', cdRegister);
 S.RegisterDelphiFunction(@SampleVariance, 'esbSampleVariance', cdRegister);
 S.RegisterDelphiFunction(@PopulationVariance, 'esbPopulationVariance', cdRegister);
 S.RegisterDelphiFunction(@SampleVarianceAndMean, 'esbSampleVarianceAndMean', cdRegister);
 S.RegisterDelphiFunction(@PopulationVarianceAndMean, 'esbPopulationVarianceAndMean', cdRegister);
 S.RegisterDelphiFunction(@GetMedian, 'GetMedian', cdRegister);
 S.RegisterDelphiFunction(@GetMode, 'GetMode', cdRegister);
 S.RegisterDelphiFunction(@GetQuartiles, 'GetQuartiles', cdRegister);
 S.RegisterDelphiFunction(@ESBMagnitude, 'ESBMagnitude', cdRegister);
 S.RegisterDelphiFunction(@ESBTan, 'ESBTan', cdRegister);
 S.RegisterDelphiFunction(@ESBCot, 'ESBCot', cdRegister);
 S.RegisterDelphiFunction(@ESBCosec, 'ESBCosec', cdRegister);
 S.RegisterDelphiFunction(@ESBSec, 'ESBSec', cdRegister);
 S.RegisterDelphiFunction(@ESBArcTan, 'ESBArcTan', cdRegister);
 S.RegisterDelphiFunction(@ESBSinCos, 'ESBSinCos', cdRegister);
 S.RegisterDelphiFunction(@ESBArcCos, 'ESBArcCos', cdRegister);
 S.RegisterDelphiFunction(@ESBArcSin, 'ESBArcSin', cdRegister);
 S.RegisterDelphiFunction(@ESBArcSec, 'ESBArcSec', cdRegister);
 S.RegisterDelphiFunction(@ESBArcCosec, 'ESBArcCosec', cdRegister);
 S.RegisterDelphiFunction(@ESBLog10, 'ESBLog10', cdRegister);
 S.RegisterDelphiFunction(@ESBLog2, 'ESBLog2', cdRegister);
 S.RegisterDelphiFunction(@ESBLogBase, 'ESBLogBase', cdRegister);
 S.RegisterDelphiFunction(@Pow2, 'Pow2', cdRegister);
 S.RegisterDelphiFunction(@IntPow, 'IntPow', cdRegister);
 S.RegisterDelphiFunction(@ESBIntPower, 'ESBIntPower', cdRegister);
 S.RegisterDelphiFunction(@XtoY, 'XtoY', cdRegister);
 S.RegisterDelphiFunction(@TenToY, 'esbTenToY', cdRegister);
 S.RegisterDelphiFunction(@TwoToY, 'esbTwoToY', cdRegister);
 S.RegisterDelphiFunction(@LogXtoBaseY, 'LogXtoBaseY', cdRegister);
 S.RegisterDelphiFunction(@ISqrt, 'esbISqrt', cdRegister);
 S.RegisterDelphiFunction(@ILog2, 'ILog2', cdRegister);
 S.RegisterDelphiFunction(@IGreatestPowerOf2, 'IGreatestPowerOf2', cdRegister);
 S.RegisterDelphiFunction(@ESBArCosh, 'ESBArCosh', cdRegister);
 S.RegisterDelphiFunction(@ESBArSinh, 'ESBArSinh', cdRegister);
 S.RegisterDelphiFunction(@ESBArTanh, 'ESBArTanh', cdRegister);
 S.RegisterDelphiFunction(@ESBCosh, 'ESBCosh', cdRegister);
 S.RegisterDelphiFunction(@ESBSinh, 'ESBSinh', cdRegister);
 S.RegisterDelphiFunction(@ESBTanh, 'ESBTanh', cdRegister);
 S.RegisterDelphiFunction(@InverseGamma, 'InverseGamma', cdRegister);
 S.RegisterDelphiFunction(@Gamma, 'esbGamma', cdRegister);
 S.RegisterDelphiFunction(@LnGamma, 'esbLnGamma', cdRegister);
 S.RegisterDelphiFunction(@Beta, 'esbBeta', cdRegister);
 S.RegisterDelphiFunction(@IncompleteBeta, 'IncompleteBeta', cdRegister);
end;

 
 
{ TPSImport_ESBMaths }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ESBMaths.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ESBMaths(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ESBMaths.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ESBMaths(ri);
  RIRegister_ESBMaths_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
