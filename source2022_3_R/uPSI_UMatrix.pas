unit uPSI_UMatrix;
{
TmX463     Gaussian_Elimination fix     array[1..30] of Extended

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
  TPSImport_UMatrix = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_UMatrix(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_UMatrix_Routines(S: TPSExec);

procedure Register;

implementation


uses
   UMatrix
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UMatrix]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_UMatrix(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('Float', 'extended');
  CL.AddTypeS('TNvector', 'array[1..30] of Extended');
  //TNvector = array[1..TNArraySize] of Float;
   CL.AddTypeS('TNmatrix', 'array[1..30] of TNvector');

  //TNmatrix = array[1..TNArraySize] of TNvector;

 CL.AddConstantN('TNNearlyZero','Extended').setExtended( 1E-07);
 CL.AddConstantN('TNArraySize','LongInt').SetInt( 30);
 CL.AddDelphiFunction('Procedure Determinant( Dimen : integer; Data : TNmatrix; var Det : Float; var Error : byte)');
 CL.AddDelphiFunction('Procedure Inverse2( Dimen : integer; Data : TNmatrix; var Inv : TNmatrix; var Error : byte)');
 CL.AddDelphiFunction('Procedure Gaussian_Elimination( Dimen : integer; Coefficients : TNmatrix; Constants : TNvector; var Solution : TNvector; var Error : byte)');
 CL.AddDelphiFunction('Procedure Partial_Pivoting( Dimen : integer; Coefficients : TNmatrix; Constants : TNvector; var Solution : TNvector; var Error : byte)');
 CL.AddDelphiFunction('Procedure LU_Decompose( Dimen : integer; Coefficients : TNmatrix; var Decomp : TNmatrix; var Permute : TNmatrix; var Error : byte)');
 CL.AddDelphiFunction('Procedure LU_Solve2( Dimen : integer; var Decomp : TNmatrix; Constants : TNvector; var Permute : TNmatrix; var Solution : TNvector; var Error : byte)');
 CL.AddDelphiFunction('Procedure Gauss_Seidel( Dimen : integer; Coefficients : TNmatrix; Constants : TNvector; Tol : Float; MaxIter : integer; var Solution : TNvector; var Iter : integer; var Error : byte)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_UMatrix_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Determinant, 'Determinant', cdRegister);
 S.RegisterDelphiFunction(@Inverse, 'Inverse2', cdRegister);
 S.RegisterDelphiFunction(@Gaussian_Elimination, 'Gaussian_Elimination', cdRegister);
 S.RegisterDelphiFunction(@Partial_Pivoting, 'Partial_Pivoting', cdRegister);
 S.RegisterDelphiFunction(@LU_Decompose, 'LU_Decompose', cdRegister);
 S.RegisterDelphiFunction(@LU_Solve, 'LU_Solve2', cdRegister);
 S.RegisterDelphiFunction(@Gauss_Seidel, 'Gauss_Seidel', cdRegister);
end;

 
 
{ TPSImport_UMatrix }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UMatrix.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UMatrix(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UMatrix.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UMatrix_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
