unit uPSI_JclComplex;
{
  complex for  euler e^pi*i=0
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
  TPSImport_JclComplex = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclComplex(CL: TPSPascalCompiler);
procedure SIRegister_JclComplex(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJclComplex(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclComplex(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   JclBase
  ,JclMath
  ,JclResources
  ,JclStrings
  ,JclSysUtils
  ,JclComplex
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclComplex]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclComplex(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclComplex') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclComplex') do begin
    RegisterProperty('FracLength', 'Byte', iptrw);
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( const X, Y : Float; const ComplexType : TComplexKind);');
    RegisterProperty('RealPart', 'Float', iptr);
    RegisterProperty('ImaginaryPart', 'Float', iptr);
    RegisterProperty('Radius', 'Float', iptr);
    RegisterProperty('Angle', 'Float', iptr);
    RegisterProperty('AsString', 'string', iptrw);
    RegisterProperty('AsPolarString', 'string', iptrw);
    RegisterMethod('Function Assign( const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;');
    RegisterMethod('Function AssignZero : TJclComplex');
    RegisterMethod('Function AssignOne : TJclComplex');
    RegisterMethod('Function Duplicate : TJclComplex');
    RegisterMethod('Function CAdd( const AddValue : TJclComplex) : TJclComplex;');
    RegisterMethod('Function CAdd1( const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;');
    RegisterMethod('Function CDiv( const DivValue : TJclComplex) : TJclComplex;');
    RegisterMethod('Function CDiv1( const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;');
    RegisterMethod('Function CMul( const MulValue : TJclComplex) : TJclComplex;');
    RegisterMethod('Function CMul1( const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;');
    RegisterMethod('Function CSub( const SubValue : TJclComplex) : TJclComplex;');
    RegisterMethod('Function CSub1( const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;');
    RegisterMethod('Function CNeg : TJclComplex');
    RegisterMethod('Function CConjugate : TJclComplex');
    RegisterMethod('Function CNewAdd( const AddValue : TJclComplex) : TJclComplex;');
    RegisterMethod('Function CNewAdd1( const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;');
    RegisterMethod('Function CNewDiv( const DivValue : TJclComplex) : TJclComplex;');
    RegisterMethod('Function CNewDiv1( const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;');
    RegisterMethod('Function CNewMul( const MulValue : TJclComplex) : TJclComplex;');
    RegisterMethod('Function CNewMul1( const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;');
    RegisterMethod('Function CNewSub( const SubValue : TJclComplex) : TJclComplex;');
    RegisterMethod('Function CNewSub1( const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;');
    RegisterMethod('Function CNewNeg : TJclComplex');
    RegisterMethod('Function CNewConjugate : TJclComplex');
    RegisterMethod('Function CLn : TJclComplex');
    RegisterMethod('Function CNewLn : TJclComplex');
    RegisterMethod('Function CExp : TJclComplex');
    RegisterMethod('Function CNewExp : TJclComplex');
    RegisterMethod('Function CPwr( const PwrValue : TJclComplex) : TJclComplex;');
    RegisterMethod('Function CPwr1( const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;');
    RegisterMethod('Function CNewPwr( PwrValue : TJclComplex) : TJclComplex;');
    RegisterMethod('Function CNewPwr1( const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;');
    RegisterMethod('Function CIntPwr( const Pwr : Integer) : TJclComplex;');
    RegisterMethod('Function CNewIntPwr( const Pwr : Integer) : TJclComplex;');
    RegisterMethod('Function CRealPwr( const Pwr : Float) : TJclComplex;');
    RegisterMethod('Function CNewRealPwr( const Pwr : Float) : TJclComplex;');
    RegisterMethod('Function CRoot( const K, N : Word) : TJclComplex;');
    RegisterMethod('Function CNewRoot( const K, N : Word) : TJclComplex;');
    RegisterMethod('Function CSqrt : TJclComplex;');
    RegisterMethod('Function CNewSqrt : TJclComplex;');
    RegisterMethod('Function CCos : TJclComplex');
    RegisterMethod('Function CNewCos : TJclComplex');
    RegisterMethod('Function CSin : TJclComplex');
    RegisterMethod('Function CNewSin : TJclComplex');
    RegisterMethod('Function CTan : TJclComplex');
    RegisterMethod('Function CNewTan : TJclComplex');
    RegisterMethod('Function CCot : TJclComplex');
    RegisterMethod('Function CNewCot : TJclComplex');
    RegisterMethod('Function CSec : TJclComplex');
    RegisterMethod('Function CNewSec : TJclComplex');
    RegisterMethod('Function CCsc : TJclComplex');
    RegisterMethod('Function CNewCsc : TJclComplex');
    RegisterMethod('Function CCosH : TJclComplex');
    RegisterMethod('Function CNewCosH : TJclComplex');
    RegisterMethod('Function CSinH : TJclComplex');
    RegisterMethod('Function CNewSinH : TJclComplex');
    RegisterMethod('Function CTanH : TJclComplex');
    RegisterMethod('Function CNewTanH : TJclComplex');
    RegisterMethod('Function CCotH : TJclComplex');
    RegisterMethod('Function CNewCotH : TJclComplex');
    RegisterMethod('Function CSecH : TJclComplex');
    RegisterMethod('Function CNewSecH : TJclComplex');
    RegisterMethod('Function CCscH : TJclComplex');
    RegisterMethod('Function CNewCscH : TJclComplex');
    RegisterMethod('Function CI0 : TJclComplex');
    RegisterMethod('Function CNewI0 : TJclComplex');
    RegisterMethod('Function CJ0 : TJclComplex');
    RegisterMethod('Function CNewJ0 : TJclComplex');
    RegisterMethod('Function CApproxLnGamma : TJclComplex');
    RegisterMethod('Function CNewApproxLnGamma : TJclComplex');
    RegisterMethod('Function CLnGamma : TJclComplex');
    RegisterMethod('Function CNewLnGamma : TJclComplex');
    RegisterMethod('Function CGamma : TJclComplex');
    RegisterMethod('Function CNewGamma : TJclComplex');
    RegisterMethod('Function AbsoluteValue : Float;');
    RegisterMethod('Function AbsoluteValue1( const Coord : TRectCoord) : Float;');
    RegisterMethod('Function AbsoluteValueSqr : Float;');
    RegisterMethod('Function AbsoluteValueSqr1( const Coord : TRectCoord) : Float;');
    RegisterMethod('Function FormatExtended( const X : Float) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclComplex(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('TComplex_VERSION','Extended').setExtended( 5.01);
  CL.AddTypeS('TComplexKind', '( crRectangular, crPolar )');
  CL.AddTypeS('TCoords', 'record X : Float; Y : Float; R : Float; Theta : Float; end');
  CL.AddTypeS('TRectCoord', 'record X : Float; Y : Float; end');
  SIRegister_TJclComplex(CL);
 CL.AddConstantN('MaxTerm','Byte').SetUInt( 35);
 CL.AddConstantN('EpsilonSqr','Float').SetExtended(1E-20);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TJclComplexAbsoluteValueSqr1_P(Self: TJclComplex;  const Coord : TRectCoord) : Float;
Begin Result := Self.AbsoluteValueSqr(Coord); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexAbsoluteValueSqr_P(Self: TJclComplex) : Float;
Begin Result := Self.AbsoluteValueSqr; END;

(*----------------------------------------------------------------------------*)
Function TJclComplexAbsoluteValue1_P(Self: TJclComplex;  const Coord : TRectCoord) : Float;
Begin Result := Self.AbsoluteValue(Coord); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexAbsoluteValue_P(Self: TJclComplex) : Float;
Begin Result := Self.AbsoluteValue; END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewSqrt_P(Self: TJclComplex) : TJclComplex;
Begin Result := Self.CNewSqrt; END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCSqrt_P(Self: TJclComplex) : TJclComplex;
Begin Result := Self.CSqrt; END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewRoot_P(Self: TJclComplex;  const K, N : Word) : TJclComplex;
Begin Result := Self.CNewRoot(K, N); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCRoot_P(Self: TJclComplex;  const K, N : Word) : TJclComplex;
Begin Result := Self.CRoot(K, N); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewRealPwr_P(Self: TJclComplex;  const Pwr : Float) : TJclComplex;
Begin Result := Self.CNewRealPwr(Pwr); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCRealPwr_P(Self: TJclComplex;  const Pwr : Float) : TJclComplex;
Begin Result := Self.CRealPwr(Pwr); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewIntPwr_P(Self: TJclComplex;  const Pwr : Integer) : TJclComplex;
Begin Result := Self.CNewIntPwr(Pwr); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCIntPwr_P(Self: TJclComplex;  const Pwr : Integer) : TJclComplex;
Begin Result := Self.CIntPwr(Pwr); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewPwr1_P(Self: TJclComplex;  const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;
Begin Result := Self.CNewPwr(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewPwr_P(Self: TJclComplex;  PwrValue : TJclComplex) : TJclComplex;
Begin Result := Self.CNewPwr(PwrValue); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCPwr1_P(Self: TJclComplex;  const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;
Begin Result := Self.CPwr(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCPwr_P(Self: TJclComplex;  const PwrValue : TJclComplex) : TJclComplex;
Begin Result := Self.CPwr(PwrValue); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewSub1_P(Self: TJclComplex;  const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;
Begin Result := Self.CNewSub(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewSub_P(Self: TJclComplex;  const SubValue : TJclComplex) : TJclComplex;
Begin Result := Self.CNewSub(SubValue); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewMul1_P(Self: TJclComplex;  const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;
Begin Result := Self.CNewMul(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewMul_P(Self: TJclComplex;  const MulValue : TJclComplex) : TJclComplex;
Begin Result := Self.CNewMul(MulValue); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewDiv1_P(Self: TJclComplex;  const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;
Begin Result := Self.CNewDiv(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewDiv_P(Self: TJclComplex;  const DivValue : TJclComplex) : TJclComplex;
Begin Result := Self.CNewDiv(DivValue); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewAdd1_P(Self: TJclComplex;  const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;
Begin Result := Self.CNewAdd(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCNewAdd_P(Self: TJclComplex;  const AddValue : TJclComplex) : TJclComplex;
Begin Result := Self.CNewAdd(AddValue); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCSub1_P(Self: TJclComplex;  const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;
Begin Result := Self.CSub(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCSub_P(Self: TJclComplex;  const SubValue : TJclComplex) : TJclComplex;
Begin Result := Self.CSub(SubValue); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCMul1_P(Self: TJclComplex;  const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;
Begin Result := Self.CMul(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCMul_P(Self: TJclComplex;  const MulValue : TJclComplex) : TJclComplex;
Begin Result := Self.CMul(MulValue); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCDiv1_P(Self: TJclComplex;  const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;
Begin Result := Self.CDiv(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCDiv_P(Self: TJclComplex;  const DivValue : TJclComplex) : TJclComplex;
Begin Result := Self.CDiv(DivValue); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCAdd1_P(Self: TJclComplex;  const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;
Begin Result := Self.CAdd(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCAdd_P(Self: TJclComplex;  const AddValue : TJclComplex) : TJclComplex;
Begin Result := Self.CAdd(AddValue); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexAssign_P(Self: TJclComplex;  const X, Y : Float; const ComplexType : TComplexKind) : TJclComplex;
Begin Result := Self.Assign(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
procedure TJclComplexAsPolarString_W(Self: TJclComplex; const T: string);
begin Self.AsPolarString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclComplexAsPolarString_R(Self: TJclComplex; var T: string);
begin T := Self.AsPolarString; end;

(*----------------------------------------------------------------------------*)
procedure TJclComplexAsString_W(Self: TJclComplex; const T: string);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclComplexAsString_R(Self: TJclComplex; var T: string);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TJclComplexAngle_R(Self: TJclComplex; var T: Float);
begin T := Self.Angle; end;

(*----------------------------------------------------------------------------*)
procedure TJclComplexRadius_R(Self: TJclComplex; var T: Float);
begin T := Self.Radius; end;

(*----------------------------------------------------------------------------*)
procedure TJclComplexImaginaryPart_R(Self: TJclComplex; var T: Float);
begin T := Self.ImaginaryPart; end;

(*----------------------------------------------------------------------------*)
procedure TJclComplexRealPart_R(Self: TJclComplex; var T: Float);
begin T := Self.RealPart; end;

(*----------------------------------------------------------------------------*)
Function TJclComplexCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const X, Y : Float; const ComplexType : TComplexKind):TObject;
Begin Result := TJclComplex.Create(X, Y, ComplexType); END;

(*----------------------------------------------------------------------------*)
Function TJclComplexCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TJclComplex.Create; END;

(*----------------------------------------------------------------------------*)
procedure TJclComplexFracLength_W(Self: TJclComplex; const T: Byte);
begin Self.FracLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclComplexFracLength_R(Self: TJclComplex; var T: Byte);
begin T := Self.FracLength; end;

(*----------------------------------------------------------------------------*)
Function TJclComplexAssign_1P(Self: TJclComplex;  const Coord : TCoords; const ComplexType : TComplexKind) : TJclComplex;
Begin
  //Result:= Self.Assign(Coord, ComplexType);
  //Self.Assign(X, Y, ComplexType); END;
 END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclComplex(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclComplex) do begin
    RegisterPropertyHelper(@TJclComplexFracLength_R,@TJclComplexFracLength_W,'FracLength');
    RegisterConstructor(@TJclComplexCreate_P, 'Create');
    RegisterConstructor(@TJclComplexCreate1_P, 'Create1');
    RegisterPropertyHelper(@TJclComplexRealPart_R,nil,'RealPart');
    RegisterPropertyHelper(@TJclComplexImaginaryPart_R,nil,'ImaginaryPart');
    RegisterPropertyHelper(@TJclComplexRadius_R,nil,'Radius');
    RegisterPropertyHelper(@TJclComplexAngle_R,nil,'Angle');
    RegisterPropertyHelper(@TJclComplexAsString_R,@TJclComplexAsString_W,'AsString');
    RegisterPropertyHelper(@TJclComplexAsPolarString_R,@TJclComplexAsPolarString_W,'AsPolarString');
    RegisterMethod(@TJclComplexAssign_P, 'Assign');
    RegisterMethod(@TJclComplex.AssignZero, 'AssignZero');
    RegisterMethod(@TJclComplex.AssignOne, 'AssignOne');
    RegisterMethod(@TJclComplex.Duplicate, 'Duplicate');
    RegisterMethod(@TJclComplexCAdd_P, 'CAdd');
    RegisterMethod(@TJclComplexCAdd1_P, 'CAdd1');
    RegisterMethod(@TJclComplexCDiv_P, 'CDiv');
    RegisterMethod(@TJclComplexCDiv1_P, 'CDiv1');
    RegisterMethod(@TJclComplexCMul_P, 'CMul');
    RegisterMethod(@TJclComplexCMul1_P, 'CMul1');
    RegisterMethod(@TJclComplexCSub_P, 'CSub');
    RegisterMethod(@TJclComplexCSub1_P, 'CSub1');
    RegisterMethod(@TJclComplex.CNeg, 'CNeg');
    RegisterMethod(@TJclComplex.CConjugate, 'CConjugate');
    RegisterMethod(@TJclComplexCNewAdd_P, 'CNewAdd');
    RegisterMethod(@TJclComplexCNewAdd1_P, 'CNewAdd1');
    RegisterMethod(@TJclComplexCNewDiv_P, 'CNewDiv');
    RegisterMethod(@TJclComplexCNewDiv1_P, 'CNewDiv1');
    RegisterMethod(@TJclComplexCNewMul_P, 'CNewMul');
    RegisterMethod(@TJclComplexCNewMul1_P, 'CNewMul1');
    RegisterMethod(@TJclComplexCNewSub_P, 'CNewSub');
    RegisterMethod(@TJclComplexCNewSub1_P, 'CNewSub1');
    RegisterMethod(@TJclComplex.CNewNeg, 'CNewNeg');
    RegisterMethod(@TJclComplex.CNewConjugate, 'CNewConjugate');
    RegisterMethod(@TJclComplex.CLn, 'CLn');
    RegisterMethod(@TJclComplex.CNewLn, 'CNewLn');
    RegisterMethod(@TJclComplex.CExp, 'CExp');
    RegisterMethod(@TJclComplex.CNewExp, 'CNewExp');
    RegisterMethod(@TJclComplexCPwr_P, 'CPwr');
    RegisterMethod(@TJclComplexCPwr1_P, 'CPwr1');
    RegisterMethod(@TJclComplexCNewPwr_P, 'CNewPwr');
    RegisterMethod(@TJclComplexCNewPwr1_P, 'CNewPwr1');
    RegisterMethod(@TJclComplexCIntPwr_P, 'CIntPwr');
    RegisterMethod(@TJclComplexCNewIntPwr_P, 'CNewIntPwr');
    RegisterMethod(@TJclComplexCRealPwr_P, 'CRealPwr');
    RegisterMethod(@TJclComplexCNewRealPwr_P, 'CNewRealPwr');
    RegisterMethod(@TJclComplexCRoot_P, 'CRoot');
    RegisterMethod(@TJclComplexCNewRoot_P, 'CNewRoot');
    RegisterMethod(@TJclComplexCSqrt_P, 'CSqrt');
    RegisterMethod(@TJclComplexCNewSqrt_P, 'CNewSqrt');
    RegisterMethod(@TJclComplex.CCos, 'CCos');
    RegisterMethod(@TJclComplex.CNewCos, 'CNewCos');
    RegisterMethod(@TJclComplex.CSin, 'CSin');
    RegisterMethod(@TJclComplex.CNewSin, 'CNewSin');
    RegisterMethod(@TJclComplex.CTan, 'CTan');
    RegisterMethod(@TJclComplex.CNewTan, 'CNewTan');
    RegisterMethod(@TJclComplex.CCot, 'CCot');
    RegisterMethod(@TJclComplex.CNewCot, 'CNewCot');
    RegisterMethod(@TJclComplex.CSec, 'CSec');
    RegisterMethod(@TJclComplex.CNewSec, 'CNewSec');
    RegisterMethod(@TJclComplex.CCsc, 'CCsc');
    RegisterMethod(@TJclComplex.CNewCsc, 'CNewCsc');
    RegisterMethod(@TJclComplex.CCosH, 'CCosH');
    RegisterMethod(@TJclComplex.CNewCosH, 'CNewCosH');
    RegisterMethod(@TJclComplex.CSinH, 'CSinH');
    RegisterMethod(@TJclComplex.CNewSinH, 'CNewSinH');
    RegisterMethod(@TJclComplex.CTanH, 'CTanH');
    RegisterMethod(@TJclComplex.CNewTanH, 'CNewTanH');
    RegisterMethod(@TJclComplex.CCotH, 'CCotH');
    RegisterMethod(@TJclComplex.CNewCotH, 'CNewCotH');
    RegisterMethod(@TJclComplex.CSecH, 'CSecH');
    RegisterMethod(@TJclComplex.CNewSecH, 'CNewSecH');
    RegisterMethod(@TJclComplex.CCscH, 'CCscH');
    RegisterMethod(@TJclComplex.CNewCscH, 'CNewCscH');
    RegisterMethod(@TJclComplex.CI0, 'CI0');
    RegisterMethod(@TJclComplex.CNewI0, 'CNewI0');
    RegisterMethod(@TJclComplex.CJ0, 'CJ0');
    RegisterMethod(@TJclComplex.CNewJ0, 'CNewJ0');
    RegisterMethod(@TJclComplex.CApproxLnGamma, 'CApproxLnGamma');
    RegisterMethod(@TJclComplex.CNewApproxLnGamma, 'CNewApproxLnGamma');
    RegisterMethod(@TJclComplex.CLnGamma, 'CLnGamma');
    RegisterMethod(@TJclComplex.CNewLnGamma, 'CNewLnGamma');
    RegisterMethod(@TJclComplex.CGamma, 'CGamma');
    RegisterMethod(@TJclComplex.CNewGamma, 'CNewGamma');
    RegisterMethod(@TJclComplexAbsoluteValue_P, 'AbsoluteValue');
    RegisterMethod(@TJclComplexAbsoluteValue1_P, 'AbsoluteValue1');
    RegisterMethod(@TJclComplexAbsoluteValueSqr_P, 'AbsoluteValueSqr');
    RegisterMethod(@TJclComplexAbsoluteValueSqr1_P, 'AbsoluteValueSqr1');
    RegisterMethod(@TJclComplex.FormatExtended, 'FormatExtended');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclComplex(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJclComplex(CL);
end;

 
 
{ TPSImport_JclComplex }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclComplex.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclComplex(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclComplex.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclComplex(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
