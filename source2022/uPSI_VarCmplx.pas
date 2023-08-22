unit uPSI_VarCmplx;
{
  for wolfram variants
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
  TPSImport_VarCmplx = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_VarCmplx(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_VarCmplx_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Variants
  ,VarCmplx
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VarCmplx]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_VarCmplx(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function VarComplexCreate : Variant;');
 CL.AddDelphiFunction('Function VarComplexCreate1( const AReal : Double) : Variant;');
 CL.AddDelphiFunction('Function VarComplexCreate2( const AReal, AImaginary : Double) : Variant;');
 CL.AddDelphiFunction('Function VarComplexCreate3( const AText : string) : Variant;');
 CL.AddDelphiFunction('Function VarComplex : TVarType');
 CL.AddDelphiFunction('Function VarIsComplex( const AValue : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarAsComplex( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexSimplify( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexAbsSqr( const AValue : Variant) : Double');
 CL.AddDelphiFunction('Function VarComplexAbs( const AValue : Variant) : Double');
 CL.AddDelphiFunction('Function VarComplexAngle( const AValue : Variant) : Double');
 CL.AddDelphiFunction('Function VarComplexSign( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexConjugate( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexInverse( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexExp( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexLn( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexLog2( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexLog10( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexLogN( const AValue : Variant; const X : Double) : Variant');
 CL.AddDelphiFunction('Function VarComplexSqr( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexSqrt( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexPower( const AValue, APower : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexTimesPosI( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexTimesNegI( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexTimesImaginary( const AValue : Variant; const AFactor : Double) : Variant');
 CL.AddDelphiFunction('Function VarComplexTimesReal( const AValue : Variant; const AFactor : Double) : Variant');
 CL.AddDelphiFunction('Function VarComplexCos( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexSin( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexTan( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexCot( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexSec( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexCsc( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcCos( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcSin( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcTan( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcCot( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcSec( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcCsc( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexCosH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexSinH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexTanH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexCotH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexSecH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexCscH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcCosH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcSinH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcTanH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcCotH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcSecH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Function VarComplexArcCscH( const AValue : Variant) : Variant');
 CL.AddDelphiFunction('Procedure VarComplexToPolar( const AValue : Variant; var ARadius, ATheta : Double; AFixTheta : Boolean)');
 CL.AddDelphiFunction('Function VarComplexFromPolar( const ARadius, ATheta : Double) : Variant');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function VarComplexCreate3_P( const AText : string) : Variant;
Begin Result := VarCmplx.VarComplexCreate(AText); END;

(*----------------------------------------------------------------------------*)
Function VarComplexCreate2_P( const AReal, AImaginary : Double) : Variant;
Begin Result := VarCmplx.VarComplexCreate(AReal, AImaginary); END;

(*----------------------------------------------------------------------------*)
Function VarComplexCreate1_P( const AReal : Double) : Variant;
Begin Result := VarCmplx.VarComplexCreate(AReal); END;

(*----------------------------------------------------------------------------*)
Function VarComplexCreate_P : Variant;
Begin Result := VarCmplx.VarComplexCreate; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VarCmplx_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@VarComplexCreate, 'VarComplexCreate', cdRegister);
 S.RegisterDelphiFunction(@VarComplexCreate1_P, 'VarComplexCreate1', cdRegister);
 S.RegisterDelphiFunction(@VarComplexCreate2_P, 'VarComplexCreate2', cdRegister);
 S.RegisterDelphiFunction(@VarComplexCreate3_P, 'VarComplexCreate3', cdRegister);
 S.RegisterDelphiFunction(@VarComplex, 'VarComplex', cdRegister);
 S.RegisterDelphiFunction(@VarIsComplex, 'VarIsComplex', cdRegister);
 S.RegisterDelphiFunction(@VarAsComplex, 'VarAsComplex', cdRegister);
 S.RegisterDelphiFunction(@VarComplexSimplify, 'VarComplexSimplify', cdRegister);
 S.RegisterDelphiFunction(@VarComplexAbsSqr, 'VarComplexAbsSqr', cdRegister);
 S.RegisterDelphiFunction(@VarComplexAbs, 'VarComplexAbs', cdRegister);
 S.RegisterDelphiFunction(@VarComplexAngle, 'VarComplexAngle', cdRegister);
 S.RegisterDelphiFunction(@VarComplexSign, 'VarComplexSign', cdRegister);
 S.RegisterDelphiFunction(@VarComplexConjugate, 'VarComplexConjugate', cdRegister);
 S.RegisterDelphiFunction(@VarComplexInverse, 'VarComplexInverse', cdRegister);
 S.RegisterDelphiFunction(@VarComplexExp, 'VarComplexExp', cdRegister);
 S.RegisterDelphiFunction(@VarComplexLn, 'VarComplexLn', cdRegister);
 S.RegisterDelphiFunction(@VarComplexLog2, 'VarComplexLog2', cdRegister);
 S.RegisterDelphiFunction(@VarComplexLog10, 'VarComplexLog10', cdRegister);
 S.RegisterDelphiFunction(@VarComplexLogN, 'VarComplexLogN', cdRegister);
 S.RegisterDelphiFunction(@VarComplexSqr, 'VarComplexSqr', cdRegister);
 S.RegisterDelphiFunction(@VarComplexSqrt, 'VarComplexSqrt', cdRegister);
 S.RegisterDelphiFunction(@VarComplexPower, 'VarComplexPower', cdRegister);
 S.RegisterDelphiFunction(@VarComplexTimesPosI, 'VarComplexTimesPosI', cdRegister);
 S.RegisterDelphiFunction(@VarComplexTimesNegI, 'VarComplexTimesNegI', cdRegister);
 S.RegisterDelphiFunction(@VarComplexTimesImaginary, 'VarComplexTimesImaginary', cdRegister);
 S.RegisterDelphiFunction(@VarComplexTimesReal, 'VarComplexTimesReal', cdRegister);
 S.RegisterDelphiFunction(@VarComplexCos, 'VarComplexCos', cdRegister);
 S.RegisterDelphiFunction(@VarComplexSin, 'VarComplexSin', cdRegister);
 S.RegisterDelphiFunction(@VarComplexTan, 'VarComplexTan', cdRegister);
 S.RegisterDelphiFunction(@VarComplexCot, 'VarComplexCot', cdRegister);
 S.RegisterDelphiFunction(@VarComplexSec, 'VarComplexSec', cdRegister);
 S.RegisterDelphiFunction(@VarComplexCsc, 'VarComplexCsc', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcCos, 'VarComplexArcCos', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcSin, 'VarComplexArcSin', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcTan, 'VarComplexArcTan', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcCot, 'VarComplexArcCot', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcSec, 'VarComplexArcSec', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcCsc, 'VarComplexArcCsc', cdRegister);
 S.RegisterDelphiFunction(@VarComplexCosH, 'VarComplexCosH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexSinH, 'VarComplexSinH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexTanH, 'VarComplexTanH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexCotH, 'VarComplexCotH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexSecH, 'VarComplexSecH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexCscH, 'VarComplexCscH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcCosH, 'VarComplexArcCosH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcSinH, 'VarComplexArcSinH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcTanH, 'VarComplexArcTanH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcCotH, 'VarComplexArcCotH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcSecH, 'VarComplexArcSecH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexArcCscH, 'VarComplexArcCscH', cdRegister);
 S.RegisterDelphiFunction(@VarComplexToPolar, 'VarComplexToPolar', cdRegister);
 S.RegisterDelphiFunction(@VarComplexFromPolar, 'VarComplexFromPolar', cdRegister);
end;

 
 
{ TPSImport_VarCmplx }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VarCmplx.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VarCmplx(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VarCmplx.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_VarCmplx(ri);
  RIRegister_VarCmplx_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
