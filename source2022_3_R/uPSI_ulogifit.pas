unit uPSI_ulogifit;
{
  wint utypes, usvdfit;

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
  TPSImport_ulogifit = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ulogifit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ulogifit_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,umath
  ,ulinfit
  ,unlfit
  ,ulogifit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ulogifit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ulogifit(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure LogiFit( X, Y : TVector; Lb, Ub : Integer; ConsTerm : Boolean; General : Boolean; MaxIter : Integer; Tol : Float; B : TVector; V : TMatrix)');
 CL.AddDelphiFunction('Procedure WLogiFit( X, Y, S : TVector; Lb, Ub : Integer; ConsTerm : Boolean; General : Boolean; MaxIter : Integer; Tol : Float; B : TVector; V : TMatrix)');
 CL.AddDelphiFunction('Function LogiFit_Func( X : Float; B : TVector) : Float');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ulogifit_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LogiFit, 'LogiFit', cdRegister);
 S.RegisterDelphiFunction(@WLogiFit, 'WLogiFit', cdRegister);
 S.RegisterDelphiFunction(@LogiFit_Func, 'LogiFit_Func', cdRegister);
end;

 
 
{ TPSImport_ulogifit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ulogifit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ulogifit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ulogifit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ulogifit_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
