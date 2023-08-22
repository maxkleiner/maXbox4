unit uPSI_ulambert;
{
   add beta function and more
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
  TPSImport_ulambert = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_ulambert(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ulambert_Routines(S: TPSExec);

procedure Register;

//function Beta(X, Y : Float) : Float;


implementation


uses
   utypes
  ,umath
  ,ulambert, ugamma, ubinom, ucholesk, ulu, unormal
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ulambert]);
end;




(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ulambert(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function LambertW( X : Float; UBranch, Offset : Boolean) : Float');
 CL.AddDelphiFunction('Function Beta(X, Y : Float) : Float');
  CL.AddDelphiFunction('Function Binomial( N, K : Integer) : Float');
 CL.AddDelphiFunction('Function PBinom( N : Integer; P : Float; K : Integer) : Float');
 CL.AddDelphiFunction('Procedure Cholesky( A, L : TMatrix; Lb, Ub : Integer)');
  CL.AddDelphiFunction('Procedure LU_Decomp( A : TMatrix; Lb, Ub : Integer)');
 CL.AddDelphiFunction('Procedure LU_Solve( A : TMatrix; B : TVector; Lb, Ub : Integer; X : TVector)');
 CL.AddDelphiFunction('Function DNorm( X : Float) : Float');



 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ulambert_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LambertW, 'LambertW', cdRegister);
 S.RegisterDelphiFunction(@Beta, 'Beta', cdRegister);
  S.RegisterDelphiFunction(@Binomial, 'Binomial', cdRegister);
 S.RegisterDelphiFunction(@PBinom, 'PBinom', cdRegister);
 S.RegisterDelphiFunction(@Cholesky, 'Cholesky', cdRegister);
 S.RegisterDelphiFunction(@LU_Decomp, 'LU_Decomp', cdRegister);
 S.RegisterDelphiFunction(@LU_Solve, 'LU_Solve', cdRegister);
 S.RegisterDelphiFunction(@DNorm, 'DNorm', cdRegister);


 end;



{ TPSImport_ulambert }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ulambert.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ulambert(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ulambert.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ulambert(ri);
  RIRegister_ulambert_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
