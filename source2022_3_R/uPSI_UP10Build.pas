unit uPSI_UP10Build;
{
   one last big function
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
  TPSImport_UP10Build = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_UP10Build(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_UP10Build_Routines(S: TPSExec);

procedure Register;

implementation


uses
   UParser10
  ,UP10Build
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UP10Build]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_UP10Build(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure ParseFunction( FunctionString : string; Variables : TStringlist; FunctionOne, FunctionTwo : TStringList; UsePascalNumbers : boolean; var FirstOP : TObject; var Error : boolean)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_UP10Build_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ParseFunction, 'ParseFunction', cdRegister);
end;

 
 
{ TPSImport_UP10Build }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UP10Build.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UP10Build(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UP10Build.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UP10Build_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
