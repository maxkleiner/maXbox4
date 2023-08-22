unit uPSI_UGetParens;
{
   dff
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
  TPSImport_UGetParens = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_UGetParens(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_UGetParens_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,UGetParens
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UGetParens]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_UGetParens(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure GetParens( Variables : string; OpChar : char; var list : TStringlist)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_UGetParens_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetParens, 'GetParens', cdRegister);
end;

 
 
{ TPSImport_UGetParens }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UGetParens.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UGetParens(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UGetParens.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_UGetParens(ri);
  RIRegister_UGetParens_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
