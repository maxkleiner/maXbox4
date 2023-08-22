unit uPSI_unlfit;
{
   nonlinear  and unit urkf
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
  TPSImport_unlfit = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_unlfit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_unlfit_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,ugausjor
  //,umarq
  //,ubfgs
  ,usimplex
  ,usimann
  ,ugenalg
  //,umcmc
  ,ustrings
  ,unlfit
  ,uminmax
  ,urkf

  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_unlfit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_unlfit(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure SetOptAlgo( Algo : TOptAlgo)');
 CL.AddDelphiFunction('Function GetOptAlgo : TOptAlgo');
 CL.AddDelphiFunction('Procedure SetMaxParam( N : Byte)');
 CL.AddDelphiFunction('Function GetMaxParam : Byte');
 CL.AddDelphiFunction('Procedure SetParamBounds( I : Byte; ParamMin, ParamMax : Float)');
 CL.AddDelphiFunction('Procedure GetParamBounds( I : Byte; var ParamMin, ParamMax : Float)');
 CL.AddDelphiFunction('Function NullParam( B : TVector; Lb, Ub : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure NLFit( RegFunc : TRegFunc; DerivProc : TDerivProc; X, Y : TVector; Lb, Ub : Integer; MaxIter : Integer; Tol : Float; B : TVector; FirstPar, LastPar : Integer; V : TMatrix)');
 CL.AddDelphiFunction('Procedure WNLFit( RegFunc : TRegFunc; DerivProc : TDerivProc; X, Y, S : TVector; Lb, Ub : Integer; MaxIter : Integer; Tol : Float; B : TVector; FirstPar, LastPar : Integer; V : TMatrix)');
 CL.AddDelphiFunction('Procedure SetMCFile( FileName : String)');
 CL.AddDelphiFunction('Procedure SimFit( RegFunc : TRegFunc; X, Y : TVector; Lb, Ub : Integer; B : TVector; FirstPar, LastPar : Integer; V : TMatrix)');
 CL.AddDelphiFunction('Procedure WSimFit( RegFunc : TRegFunc; X, Y, S : TVector; Lb, Ub : Integer; B : TVector; FirstPar, LastPar : Integer; V : TMatrix)');
 CL.AddDelphiFunction('Procedure RKF45( F : TDiffEqs; Neqn : Integer; Y, Yp : TVector; var T : Float; Tout, RelErr, AbsErr : Float; var Flag : Integer)');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_unlfit_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetOptAlgo, 'SetOptAlgo', cdRegister);
 S.RegisterDelphiFunction(@GetOptAlgo, 'GetOptAlgo', cdRegister);
 S.RegisterDelphiFunction(@SetMaxParam, 'SetMaxParam', cdRegister);
 S.RegisterDelphiFunction(@GetMaxParam, 'GetMaxParam', cdRegister);
 S.RegisterDelphiFunction(@SetParamBounds, 'SetParamBounds', cdRegister);
 S.RegisterDelphiFunction(@GetParamBounds, 'GetParamBounds', cdRegister);
 S.RegisterDelphiFunction(@NullParam, 'NullParam', cdRegister);
 S.RegisterDelphiFunction(@NLFit, 'NLFit', cdRegister);
 S.RegisterDelphiFunction(@WNLFit, 'WNLFit', cdRegister);
 S.RegisterDelphiFunction(@SetMCFile, 'SetMCFile', cdRegister);
 S.RegisterDelphiFunction(@SimFit, 'SimFit', cdRegister);
 S.RegisterDelphiFunction(@WSimFit, 'WSimFit', cdRegister);
 S.RegisterDelphiFunction(@RKF45, 'RKF45', cdRegister);

end;

 
 
{ TPSImport_unlfit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_unlfit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_unlfit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_unlfit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_unlfit(ri);
  RIRegister_unlfit_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
