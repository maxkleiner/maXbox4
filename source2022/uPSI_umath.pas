unit uPSI_umath;
{
   last six knight   , with aliases
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
  TPSImport_umath = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_umath(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_umath_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,uminmax
  ,umath
  ,ucorrel
  ,ugamdist
  ,uibeta
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_umath]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_umath(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function uExpo( X : Float) : Float');
 CL.AddDelphiFunction('Function uExp2( X : Float) : Float');
 CL.AddDelphiFunction('Function uExp10( X : Float) : Float');
 CL.AddDelphiFunction('Function Exp2( X : Float) : Float');
 CL.AddDelphiFunction('Function Exp10( X : Float) : Float');
 CL.AddDelphiFunction('Function uLog( X : Float) : Float');
 CL.AddDelphiFunction('Function uLog2( X : Float) : Float');
 CL.AddDelphiFunction('Function uLog10( X : Float) : Float');
 CL.AddDelphiFunction('Function uLogA( X, A : Float) : Float');
 CL.AddDelphiFunction('Function LogA( X, A : Float) : Float');
 CL.AddDelphiFunction('Function uIntPower( X : Float; N : Integer) : Float');
 CL.AddDelphiFunction('Function uPower( X, Y : Float) : Float');
 CL.AddDelphiFunction('function Correl(X, Y : TVector; Lb, Ub : Integer) : Float;');
 CL.AddDelphiFunction('function DStudent(Nu : Integer; X : Float) : Float;');
 CL.AddDelphiFunction('function DBeta(A, B, X : Float) : Float;');
 CL.AddDelphiFunction('function DGamma(A, B, X : Float) : Float;');
 CL.AddDelphiFunction('function DKhi2(Nu : Integer; X : Float) : Float;');
 CL.AddDelphiFunction('function DSnedecor(Nu1, Nu2 : Integer; X : Float) : Float;');
 CL.AddDelphiFunction('function IBeta(A, B, X : Float) : Float;');

// function IBeta(A, B, X : Float) : Float;
{ Incomplete Beta function}
(* function DBeta(A, B, X : Float) : Float;
{ Density of Beta distribution with parameters A and B }
function DGamma(A, B, X : Float) : Float;
{ Density of Gamma distribution with parameters A and B }
function DKhi2(Nu : Integer; X : Float) : Float;
{ Density of Khi-2 distribution with Nu d.o.f. }
function DStudent(Nu : Integer; X : Float) : Float;
{ Density of Student distribution with Nu d.o.f. }
function DSnedecor(Nu1, Nu2 : Integer; X : Float) : Float;
{ Density of Fisher-Snedecor distribution with Nu1 and Nu2 d.o.f. }*)

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_umath_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Expo, 'uExpo', cdRegister);
 S.RegisterDelphiFunction(@Exp2, 'uExp2', cdRegister);
 S.RegisterDelphiFunction(@Exp10, 'uExp10', cdRegister);
 S.RegisterDelphiFunction(@Exp2, 'Exp2', cdRegister);
 S.RegisterDelphiFunction(@Exp10, 'Exp10', cdRegister);
 S.RegisterDelphiFunction(@Log, 'uLog', cdRegister);
 S.RegisterDelphiFunction(@Log2, 'uLog2', cdRegister);
 S.RegisterDelphiFunction(@Log10, 'uLog10', cdRegister);
 S.RegisterDelphiFunction(@LogA, 'uLogA', cdRegister);
 S.RegisterDelphiFunction(@LogA, 'LogA', cdRegister);
 S.RegisterDelphiFunction(@IntPower, 'uIntPower', cdRegister);
 S.RegisterDelphiFunction(@Power, 'uPower', cdRegister);
 S.RegisterDelphiFunction(@Correl, 'Correl', cdRegister);
 S.RegisterDelphiFunction(@DBeta, 'Dbeta', cdRegister);
 S.RegisterDelphiFunction(@DGamma, 'DGamma', cdRegister);
 S.RegisterDelphiFunction(@DKhi2, 'DKhi2', cdRegister);
 S.RegisterDelphiFunction(@DStudent, 'DStudent', cdRegister);
 S.RegisterDelphiFunction(@DSnedecor, 'DSnedecor', cdRegister);
 S.RegisterDelphiFunction(@IBeta, 'IBeta', cdRegister);



end;



{ TPSImport_umath }
(*----------------------------------------------------------------------------*)
procedure TPSImport_umath.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_umath(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_umath.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_umath(ri);
  RIRegister_umath_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
