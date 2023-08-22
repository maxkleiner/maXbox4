unit uPSI_usimplex;
{
   nr. 500! of units
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
  TPSImport_usimplex = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_usimplex(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_usimplex_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,usimplex
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_usimplex]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_usimplex(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure SaveSimplex( FileName : string)');
 CL.AddDelphiFunction('Procedure Simplex( Func : TFuncNVar; X : TVector; Lb, Ub : Integer; MaxIter : Integer; Tol : Float; var F_min : Float)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_usimplex_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SaveSimplex, 'SaveSimplex', cdRegister);
 S.RegisterDelphiFunction(@Simplex, 'Simplex', cdRegister);
end;

 
 
{ TPSImport_usimplex }
(*----------------------------------------------------------------------------*)
procedure TPSImport_usimplex.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_usimplex(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_usimplex.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_usimplex(ri);
  RIRegister_usimplex_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
