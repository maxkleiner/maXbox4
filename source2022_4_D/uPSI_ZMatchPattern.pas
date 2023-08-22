unit uPSI_ZMatchPattern;
{
   straigth regex like grep
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
  TPSImport_ZMatchPattern = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ZMatchPattern(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ZMatchPattern_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ZMatchPattern
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZMatchPattern]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ZMatchPattern(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function IsMatch( const Pattern, Text : string) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ZMatchPattern_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsMatch, 'IsMatch', cdRegister);
end;

 
 
{ TPSImport_ZMatchPattern }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZMatchPattern.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZMatchPattern(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZMatchPattern.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ZMatchPattern(ri);
  RIRegister_ZMatchPattern_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
