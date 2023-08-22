unit uPSI_fmath;
{
  from umath an extension in double
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
  TPSImport_fmath = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_fmath(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_fmath_Routines(S: TPSExec);

procedure Register;

implementation


uses
   fmath
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_fmath]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_fmath(CL: TPSPascalCompiler);
begin
 { CL.AddTypeS('Float', 'Real');
  CL.AddTypeS('Float', 'Single');
  CL.AddTypeS('Float', 'Extended');
  CL.AddTypeS('Float', 'Double');
 CL.AddConstantN('PI','Extended').setExtended( 3.14159265358979323846);
 CL.AddConstantN('LN2','Extended').setExtended( 0.69314718055994530942);
 CL.AddConstantN('LN10','Extended').setExtended( 2.30258509299404568402);
 CL.AddConstantN('LNPI','Extended').setExtended( 1.14472988584940017414);
 CL.AddConstantN('INVLN2','Extended').setExtended( 1.44269504088896340736);
 CL.AddConstantN('INVLN10','Extended').setExtended( 0.43429448190325182765);
 CL.AddConstantN('TWOPI','Extended').setExtended( 6.28318530717958647693);
 CL.AddConstantN('PIDIV2','Extended').setExtended( 1.57079632679489661923);
 CL.AddConstantN('SQRTPI','Extended').setExtended( 1.77245385090551602730);
 CL.AddConstantN('SQRT2PI','Extended').setExtended( 2.50662827463100050242);
 CL.AddConstantN('INVSQRT2PI','Extended').setExtended( 0.39894228040143267794);
 CL.AddConstantN('LNSQRT2PI','Extended').setExtended( 0.91893853320467274178);
 CL.AddConstantN('LN2PIDIV2','Extended').setExtended( 0.91893853320467274178);
 CL.AddConstantN('SQRT2','Extended').setExtended( 1.41421356237309504880);
 CL.AddConstantN('SQRT2DIV2','Extended').setExtended( 0.70710678118654752440);
 CL.AddConstantN('GOLD','Extended').setExtended( 1.61803398874989484821);
 CL.AddConstantN('CGOLD','Extended').setExtended( 0.38196601125010515179);
 CL.AddConstantN('MACHEP','Extended').setExtended( 1.192093E-7);
 CL.AddConstantN('MAXNUM','Extended').setExtended( 3.402823E+38);
 CL.AddConstantN('MINNUM','Extended').setExtended( 1.175495E-38);
 CL.AddConstantN('MAXLOG','Extended').setExtended( 88.72283);
 CL.AddConstantN('MINLOG','Extended').setExtended( - 87.33655);
 CL.AddConstantN('MAXFAC','LongInt').SetInt( 33);
 CL.AddConstantN('MAXGAM','Extended').setExtended( 34.648);
 CL.AddConstantN('MAXLGM','Extended').setExtended( 1.0383E+36);
 CL.AddConstantN('MACHEP','Extended').setExtended( 2.220446049250313E-16);
 CL.AddConstantN('MAXNUM','Extended').setExtended( 1.797693134862315E+308);
 CL.AddConstantN('MINNUM','Extended').setExtended( 2.225073858507202E-308);
 CL.AddConstantN('MAXLOG','Extended').setExtended( 709.7827128933840);
 CL.AddConstantN('MINLOG','Extended').setExtended( - 708.3964185322641);
 CL.AddConstantN('MAXFAC','LongInt').SetInt( 170);
 CL.AddConstantN('MAXGAM','Extended').setExtended( 171.624376956302);
 CL.AddConstantN('MAXLGM','Extended').setExtended( 2.556348E+305);
 CL.AddConstantN('MACHEP','Extended').setExtended( 1.08420217248550444E-19);
 CL.AddConstantN('MAXNUM','Extended').setExtended( 1.18973149535723103E+4932);
 CL.AddConstantN('MINNUM','Extended').setExtended( 3.36210314311209558E-4932);
 CL.AddConstantN('MAXLOG','Extended').setExtended( 11356.5234062941439);
 CL.AddConstantN('MINLOG','Extended').setExtended( - 11355.137111933024);
 CL.AddConstantN('MAXFAC','LongInt').SetInt( 1754);
 CL.AddConstantN('MAXGAM','Extended').setExtended( 1755.455);
 CL.AddConstantN('MAXLGM','Extended').setExtended( 1.04848146839019521E+4928);
 CL.AddConstantN('MACHEP','Extended').setExtended( 1.818989404E-12);
 CL.AddConstantN('MAXNUM','Extended').setExtended( 4.253529586E+37);
 CL.AddConstantN('MINNUM','Extended').setExtended( 2.350988703E-38);
 CL.AddConstantN('MAXLOG','Extended').setExtended( 8.664339757E+01);
 CL.AddConstantN('MINLOG','Extended').setExtended( - 4.253529586E+01);
 CL.AddConstantN('MAXFAC','LongInt').SetInt( 33);
 CL.AddConstantN('MAXGAM','Extended').setExtended( 34.64809785);
 CL.AddConstantN('MAXLGM','Extended').setExtended( 1.038324114E+36); }
 CL.AddConstantN('FN_OK','LongInt').SetInt( 0);
 CL.AddConstantN('FN_DOMAIN','LongInt').SetInt( - 1);
 CL.AddConstantN('FN_SING','LongInt').SetInt( - 2);
 CL.AddConstantN('FN_OVERFLOW','LongInt').SetInt( - 3);
 CL.AddConstantN('FN_UNDERFLOW','LongInt').SetInt( - 4);
 CL.AddConstantN('FN_TLOSS','LongInt').SetInt( - 5);
 CL.AddConstantN('FN_PLOSS','LongInt').SetInt( - 6);
 //CL.AddConstantN('NFACT','LongInt').SetInt( 33);
 CL.AddDelphiFunction('Function MathError : Integer');
 CL.AddDelphiFunction('Function FMin( X, Y : Float) : Float');
 CL.AddDelphiFunction('Function FMax( X, Y : Float) : Float');
 CL.AddDelphiFunction('Function IMin( X, Y : Integer) : Integer');
 CL.AddDelphiFunction('Function IMax( X, Y : Integer) : Integer');
 CL.AddDelphiFunction('Function FSgn( X : Float) : Integer');
 CL.AddDelphiFunction('Function Sgn0( X : Float) : Integer');
 CL.AddDelphiFunction('Function DSgn( A, B : Float) : Float');
 CL.AddDelphiFunction('Procedure FSwap( var X, Y : Float)');
 CL.AddDelphiFunction('Procedure ISwap( var X, Y : Integer)');
 CL.AddDelphiFunction('Function fExpo( X : Float) : Float');
 CL.AddDelphiFunction('Function fExp2( X : Float) : Float');
 CL.AddDelphiFunction('Function fExp10( X : Float) : Float');
 CL.AddDelphiFunction('Function fLog( X : Float) : Float');
 CL.AddDelphiFunction('Function fLog2( X : Float) : Float');
 CL.AddDelphiFunction('Function fLog10( X : Float) : Float');
 CL.AddDelphiFunction('Function fLogA( X, A : Float) : Float');
 CL.AddDelphiFunction('Function fIntPower( X : Float; N : Integer) : Float');
 CL.AddDelphiFunction('Function fPower( X, Y : Float) : Float');
 CL.AddDelphiFunction('Function Pythag( X, Y : Float) : Float');
 CL.AddDelphiFunction('Function FixAngle( Theta : Float) : Float');
 CL.AddDelphiFunction('Function fTan( X : Float) : Float');
 CL.AddDelphiFunction('Function fArcSin( X : Float) : Float');
 CL.AddDelphiFunction('Function fArcCos( X : Float) : Float');
 CL.AddDelphiFunction('Function fArcTan2( Y, X : Float) : Float');
 CL.AddDelphiFunction('Procedure fSinCos( X : Float; var SinX, CosX : Float)');
 CL.AddDelphiFunction('Function fSinh( X : Float) : Float');
 CL.AddDelphiFunction('Function fCosh( X : Float) : Float');
 CL.AddDelphiFunction('Function fTanh( X : Float) : Float');
 CL.AddDelphiFunction('Function fArcSinh( X : Float) : Float');
 CL.AddDelphiFunction('Function fArcCosh( X : Float) : Float');
 CL.AddDelphiFunction('Function fArcTanh( X : Float) : Float');
 CL.AddDelphiFunction('Procedure fSinhCosh( X : Float; var SinhX, CoshX : Float)');
 CL.AddDelphiFunction('Function fFact( N : Integer) : Float');
 CL.AddDelphiFunction('Function fBinomial( N, K : Integer) : Float');
 CL.AddDelphiFunction('Function fGamma( X : Float) : Float');
 CL.AddDelphiFunction('Function fSgnGamma( X : Float) : Integer');
 CL.AddDelphiFunction('Function LnGamma( X : Float) : Float');
 CL.AddDelphiFunction('Function fIGamma( A, X : Float) : Float');
 CL.AddDelphiFunction('Function fJGamma( A, X : Float) : Float');
 CL.AddDelphiFunction('Function fBeta( X, Y : Float) : Float');
 CL.AddDelphiFunction('Function fIBeta( A, B, X : Float) : Float');
 CL.AddDelphiFunction('Function fErf( X : Float) : Float');
 CL.AddDelphiFunction('Function fErfc( X : Float) : Float');
 CL.AddDelphiFunction('Function fPBinom(N: Integer; P: Float; K : Integer) : Float');
 CL.AddDelphiFunction('Function FBinom(N: Integer; P: Float; K : Integer) : Float');
 CL.AddDelphiFunction('Function PPoisson( Mu : Float; K : Integer) : Float');
 CL.AddDelphiFunction('Function FPoisson( Mu : Float; K : Integer) : Float');
 CL.AddDelphiFunction('Function fDNorm( X : Float) : Float');
 CL.AddDelphiFunction('Function FNorm( X : Float) : Float');
 CL.AddDelphiFunction('Function PNorm( X : Float) : Float');
 CL.AddDelphiFunction('Function InvNorm( P : Float) : Float');
 CL.AddDelphiFunction('Function fDStudent( Nu : Integer; X : Float) : Float');
 CL.AddDelphiFunction('Function FStudent( Nu : Integer; X : Float) : Float');
 CL.AddDelphiFunction('Function PStudent( Nu : Integer; X : Float) : Float');
 CL.AddDelphiFunction('Function fDKhi2( Nu : Integer; X : Float) : Float');
 CL.AddDelphiFunction('Function FKhi2( Nu : Integer; X : Float) : Float');
 CL.AddDelphiFunction('Function PKhi2( Nu : Integer; X : Float) : Float');
 CL.AddDelphiFunction('Function fDSnedecor( Nu1, Nu2 : Integer; X : Float) : Float');
 CL.AddDelphiFunction('Function FSnedecor( Nu1, Nu2 : Integer; X : Float) : Float');
 CL.AddDelphiFunction('Function PSnedecor( Nu1, Nu2 : Integer; X : Float) : Float');
 CL.AddDelphiFunction('Function fDExpo( A, X : Float) : Float');
 CL.AddDelphiFunction('Function FExpo( A, X : Float) : Float');
 CL.AddDelphiFunction('Function fDBeta( A, B, X : Float) : Float');
 CL.AddDelphiFunction('Function FBeta( A, B, X : Float) : Float');
 CL.AddDelphiFunction('Function fDGamma( A, B, X : Float) : Float');
 CL.AddDelphiFunction('Function FGamma( A, B, X : Float) : Float');
 CL.AddDelphiFunction('Procedure RMarIn( Seed1, Seed2 : Integer)');
 CL.AddDelphiFunction('Function IRanMar : LongInt');
 CL.AddDelphiFunction('Function RanMar : Float');
 CL.AddDelphiFunction('Function RanGaussStd : Float');
 CL.AddDelphiFunction('Function RanGauss( Mu, Sigma : Float) : Float');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_fmath_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MathError, 'MathError', cdRegister);
 S.RegisterDelphiFunction(@FMin, 'FMin', cdRegister);
 S.RegisterDelphiFunction(@FMax, 'FMax', cdRegister);
 S.RegisterDelphiFunction(@IMin, 'IMin', cdRegister);
 S.RegisterDelphiFunction(@IMax, 'IMax', cdRegister);
 S.RegisterDelphiFunction(@Sgn, 'fSgn', cdRegister);
 S.RegisterDelphiFunction(@Sgn0, 'Sgn0', cdRegister);
 S.RegisterDelphiFunction(@DSgn, 'DSgn', cdRegister);
 S.RegisterDelphiFunction(@FSwap, 'FSwap', cdRegister);
 S.RegisterDelphiFunction(@ISwap, 'ISwap', cdRegister);
 S.RegisterDelphiFunction(@Expo, 'fExpo', cdRegister);
 S.RegisterDelphiFunction(@Exp2, 'fExp2', cdRegister);
 S.RegisterDelphiFunction(@Exp10, 'fExp10', cdRegister);
 S.RegisterDelphiFunction(@Log, 'fLog', cdRegister);
 S.RegisterDelphiFunction(@Log2, 'fLog2', cdRegister);
 S.RegisterDelphiFunction(@Log10, 'fLog10', cdRegister);
 S.RegisterDelphiFunction(@LogA, 'fLogA', cdRegister);
 S.RegisterDelphiFunction(@IntPower, 'fIntPower', cdRegister);
 S.RegisterDelphiFunction(@Power, 'fPower', cdRegister);
 S.RegisterDelphiFunction(@Pythag, 'Pythag', cdRegister);
 S.RegisterDelphiFunction(@FixAngle, 'FixAngle', cdRegister);
 S.RegisterDelphiFunction(@Tan, 'fTan', cdRegister);
 S.RegisterDelphiFunction(@ArcSin, 'fArcSin', cdRegister);
 S.RegisterDelphiFunction(@ArcCos, 'fArcCos', cdRegister);
 S.RegisterDelphiFunction(@ArcTan2, 'fArcTan2', cdRegister);
 S.RegisterDelphiFunction(@SinCos, 'fSinCos', cdRegister);
 S.RegisterDelphiFunction(@Sinh, 'fSinh', cdRegister);
 S.RegisterDelphiFunction(@Cosh, 'fCosh', cdRegister);
 S.RegisterDelphiFunction(@Tanh, 'fTanh', cdRegister);
 S.RegisterDelphiFunction(@ArcSinh, 'fArcSinh', cdRegister);
 S.RegisterDelphiFunction(@ArcCosh, 'fArcCosh', cdRegister);
 S.RegisterDelphiFunction(@ArcTanh, 'fArcTanh', cdRegister);
 S.RegisterDelphiFunction(@SinhCosh, 'fSinhCosh', cdRegister);
 S.RegisterDelphiFunction(@Fact, 'fFact', cdRegister);
 S.RegisterDelphiFunction(@Binomial, 'fBinomial', cdRegister);
 S.RegisterDelphiFunction(@Gamma, 'fGamma', cdRegister);
 S.RegisterDelphiFunction(@SgnGamma, 'fSgnGamma', cdRegister);
 S.RegisterDelphiFunction(@LnGamma, 'fLnGamma', cdRegister);
 S.RegisterDelphiFunction(@IGamma, 'fIGamma', cdRegister);
 S.RegisterDelphiFunction(@JGamma, 'fJGamma', cdRegister);
 S.RegisterDelphiFunction(@Beta, 'fBeta', cdRegister);
 S.RegisterDelphiFunction(@IBeta, 'fIBeta', cdRegister);
 S.RegisterDelphiFunction(@Erf, 'fErf', cdRegister);
 S.RegisterDelphiFunction(@Erfc, 'fErfc', cdRegister);
 S.RegisterDelphiFunction(@PBinom, 'fPBinom', cdRegister);
 S.RegisterDelphiFunction(@FBinom, 'FBinom', cdRegister);
 S.RegisterDelphiFunction(@PPoisson, 'PPoisson', cdRegister);
 S.RegisterDelphiFunction(@FPoisson, 'FPoisson', cdRegister);
 S.RegisterDelphiFunction(@DNorm, 'fDNorm', cdRegister);
 S.RegisterDelphiFunction(@FNorm, 'FNorm', cdRegister);
 S.RegisterDelphiFunction(@PNorm, 'PNorm', cdRegister);
 S.RegisterDelphiFunction(@InvNorm, 'InvNorm', cdRegister);
 S.RegisterDelphiFunction(@DStudent, 'fDStudent', cdRegister);
 S.RegisterDelphiFunction(@FStudent, 'FStudent', cdRegister);
 S.RegisterDelphiFunction(@PStudent, 'PStudent', cdRegister);
 S.RegisterDelphiFunction(@DKhi2, 'fDKhi2', cdRegister);
 S.RegisterDelphiFunction(@FKhi2, 'FKhi2', cdRegister);
 S.RegisterDelphiFunction(@PKhi2, 'PKhi2', cdRegister);
 S.RegisterDelphiFunction(@DSnedecor, 'fDSnedecor', cdRegister);
 S.RegisterDelphiFunction(@FSnedecor, 'FSnedecor', cdRegister);
 S.RegisterDelphiFunction(@PSnedecor, 'PSnedecor', cdRegister);
 S.RegisterDelphiFunction(@DExpo, 'fDExpo', cdRegister);
 S.RegisterDelphiFunction(@FExpo, 'FExpo', cdRegister);
 S.RegisterDelphiFunction(@DBeta, 'DBeta', cdRegister);
 S.RegisterDelphiFunction(@FBeta, 'FBeta', cdRegister);
 S.RegisterDelphiFunction(@DGamma, 'fDGamma', cdRegister);
 S.RegisterDelphiFunction(@FGamma, 'FGamma', cdRegister);
 S.RegisterDelphiFunction(@RMarIn, 'RMarIn', cdRegister);
 S.RegisterDelphiFunction(@IRanMar, 'IRanMar', cdRegister);
 S.RegisterDelphiFunction(@RanMar, 'RanMar', cdRegister);
 S.RegisterDelphiFunction(@RanGaussStd, 'RanGaussStd', cdRegister);
 S.RegisterDelphiFunction(@RanGauss, 'RanGauss', cdRegister);
end;



{ TPSImport_fmath }
(*----------------------------------------------------------------------------*)
procedure TPSImport_fmath.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_fmath(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_fmath.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_fmath(ri);
  RIRegister_fmath_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
