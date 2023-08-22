unit uPSI_ueval;
{
  to test with maXcalc
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
  TPSImport_ueval = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ueval(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ueval_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,uminmax
  ,umath
  //,utrigo
  ,uhyper
  ,uranmt
  //,ufact
  //,ugamma
  //,uigamma
  //,ubeta
  //,uibeta
  //,ulambert
  ,ueval
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ueval]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ueval(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function InitEval : Integer');
 CL.AddDelphiFunction('Procedure SetVariable( VarName : Char; Value : Float)');
 CL.AddDelphiFunction('Procedure SetFunction( FuncName : String; Wrapper : TWrapper)');
 CL.AddDelphiFunction('Function Eval( ExpressionString : String) : Float');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ueval_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitEval, 'InitEval', cdRegister);
 S.RegisterDelphiFunction(@SetVariable, 'SetVariable', cdRegister);
 S.RegisterDelphiFunction(@SetFunction, 'SetFunction', cdRegister);
 S.RegisterDelphiFunction(@Eval, 'Eval', cdRegister);
end;

 
 
{ TPSImport_ueval }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ueval.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ueval(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ueval.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ueval(ri);
  RIRegister_ueval_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
