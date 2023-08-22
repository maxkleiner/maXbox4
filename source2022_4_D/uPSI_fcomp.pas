unit uPSI_fcomp;
{
  for complex numbers
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
  TPSImport_fcomp = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_fcomp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_fcomp_Routines(S: TPSExec);

procedure Register;

implementation


uses
   fmath
  ,fcomp
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_fcomp]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_fcomp(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('ComplexForm', '( Rec, Pol )');
  CL.AddTypeS('TComplex', 'record Form : ComplexForm; X : Float; Y : Float; R :'
   +' Float; Theta : Float; end');
 CL.AddDelphiFunction('Procedure CSet( var Z : TComplex; A, B : Float; F : ComplexForm)');
 CL.AddDelphiFunction('Procedure CConvert( var Z : TComplex; F : ComplexForm)');
 CL.AddDelphiFunction('Procedure CSwap( var X, Y : TComplex)');
 CL.AddDelphiFunction('Function CReal( Z : TComplex) : Float');
 CL.AddDelphiFunction('Function CImag( Z : TComplex) : Float');
 CL.AddDelphiFunction('Function CAbs( Z : TComplex) : Float');
 CL.AddDelphiFunction('Function CArg( Z : TComplex) : Float');
 CL.AddDelphiFunction('Function CCSgn( Z : TComplex) : Integer');
 CL.AddDelphiFunction('Procedure CNeg( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CConj( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CAdd( A, B : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CSub( A, B : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CDiv( A, B : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CMult( A, B : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CLn( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CExp( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CPower( A, B : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CIntPower( A : TComplex; N : Integer; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CRealPower( A : TComplex; X : Float; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CSqrt( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CRoot( A : TComplex; K, N : Integer; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CSin( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CCos( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CTan( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CArcSin( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CArcCos( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CArcTan( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CSinh( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CCosh( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CTanh( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CArcSinh( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CArcCosh( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CArcTanh( A : TComplex; var Z : TComplex)');
 CL.AddDelphiFunction('Procedure CLnGamma( A : TComplex; var Z : TComplex)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_fcomp_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CSet, 'CSet', cdRegister);
 S.RegisterDelphiFunction(@CConvert, 'CConvert', cdRegister);
 S.RegisterDelphiFunction(@CSwap, 'CSwap', cdRegister);
 S.RegisterDelphiFunction(@CReal, 'CReal', cdRegister);
 S.RegisterDelphiFunction(@CImag, 'CImag', cdRegister);
 S.RegisterDelphiFunction(@CAbs, 'CAbs', cdRegister);
 S.RegisterDelphiFunction(@CArg, 'CArg', cdRegister);
 S.RegisterDelphiFunction(@CSgn, 'CCSgn', cdRegister);
 S.RegisterDelphiFunction(@CNeg, 'CNeg', cdRegister);
 S.RegisterDelphiFunction(@CConj, 'CConj', cdRegister);
 S.RegisterDelphiFunction(@CAdd, 'CAdd', cdRegister);
 S.RegisterDelphiFunction(@CSub, 'CSub', cdRegister);
 S.RegisterDelphiFunction(@CDiv, 'CDiv', cdRegister);
 S.RegisterDelphiFunction(@CMult, 'CMult', cdRegister);
 S.RegisterDelphiFunction(@CLn, 'CLn', cdRegister);
 S.RegisterDelphiFunction(@CExp, 'CExp', cdRegister);
 S.RegisterDelphiFunction(@CPower, 'CPower', cdRegister);
 S.RegisterDelphiFunction(@CIntPower, 'CIntPower', cdRegister);
 S.RegisterDelphiFunction(@CRealPower, 'CRealPower', cdRegister);
 S.RegisterDelphiFunction(@CSqrt, 'CSqrt', cdRegister);
 S.RegisterDelphiFunction(@CRoot, 'CRoot', cdRegister);
 S.RegisterDelphiFunction(@CSin, 'CSin', cdRegister);
 S.RegisterDelphiFunction(@CCos, 'CCos', cdRegister);
 S.RegisterDelphiFunction(@CTan, 'CTan', cdRegister);
 S.RegisterDelphiFunction(@CArcSin, 'CArcSin', cdRegister);
 S.RegisterDelphiFunction(@CArcCos, 'CArcCos', cdRegister);
 S.RegisterDelphiFunction(@CArcTan, 'CArcTan', cdRegister);
 S.RegisterDelphiFunction(@CSinh, 'CSinh', cdRegister);
 S.RegisterDelphiFunction(@CCosh, 'CCosh', cdRegister);
 S.RegisterDelphiFunction(@CTanh, 'CTanh', cdRegister);
 S.RegisterDelphiFunction(@CArcSinh, 'CArcSinh', cdRegister);
 S.RegisterDelphiFunction(@CArcCosh, 'CArcCosh', cdRegister);
 S.RegisterDelphiFunction(@CArcTanh, 'CArcTanh', cdRegister);
 S.RegisterDelphiFunction(@CLnGamma, 'CLnGamma', cdRegister);
end;

 
 
{ TPSImport_fcomp }
(*----------------------------------------------------------------------------*)
procedure TPSImport_fcomp.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_fcomp(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_fcomp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_fcomp(ri);
  RIRegister_fcomp_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
