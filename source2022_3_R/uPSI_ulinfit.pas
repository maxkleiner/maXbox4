unit uPSI_ulinfit;
{
    regress stat lib   with svdfit
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
  TPSImport_ulinfit = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ulinfit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ulinfit_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,usvdfit
  ,ulinfit
  ,usvd
  ;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ulinfit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ulinfit(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure LinFit( X, Y : TVector; Lb, Ub : Integer; B : TVector; V : TMatrix)');
 CL.AddDelphiFunction('Procedure WLinFit( X, Y, S : TVector; Lb, Ub : Integer; B : TVector; V : TMatrix)');
 CL.AddDelphiFunction('Procedure SVDLinFit( X, Y : TVector; Lb, Ub : Integer; SVDTol : Float; B : TVector; V : TMatrix)');
 CL.AddDelphiFunction('Procedure WSVDLinFit( X, Y, S : TVector; Lb, Ub : Integer; SVDTol : Float; B : TVector; V : TMatrix)');
  CL.AddDelphiFunction('Procedure SVDFit( X : TMatrix; Y : TVector; Lb, Ub, Nvar : Integer; ConsTerm : Boolean; SVDTol : Float; B : TVector; V : TMatrix)');
 CL.AddDelphiFunction('Procedure WSVDFit( X : TMatrix; Y, S : TVector; Lb, Ub, Nvar : Integer; ConsTerm : Boolean; SVDTol : Float; B : TVector; V : TMatrix)');
 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ulinfit_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LinFit, 'LinFit', cdRegister);
 S.RegisterDelphiFunction(@WLinFit, 'WLinFit', cdRegister);
 S.RegisterDelphiFunction(@SVDLinFit, 'SVDLinFit', cdRegister);
 S.RegisterDelphiFunction(@WSVDLinFit, 'WSVDLinFit', cdRegister);
 S.RegisterDelphiFunction(@SVDFit, 'SVDFit', cdRegister);
 S.RegisterDelphiFunction(@WSVDFit, 'WSVDFit', cdRegister);
end;

 
 
{ TPSImport_ulinfit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ulinfit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ulinfit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ulinfit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ulinfit_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
