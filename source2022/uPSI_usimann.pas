unit uPSI_usimann;
{
   //  Optimization by Simulated Annealing

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
  TPSImport_usimann = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_usimann(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_usimann_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,urandom
  ,umedian
  ,usimann
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_usimann]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_usimann(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure InitSAParams( NT, NS, NCycles : Integer; RT : Float)');
 CL.AddDelphiFunction('Procedure SA_CreateLogFile( FileName : String)');
 CL.AddDelphiFunction('Procedure SimAnn( Func : TFuncNVar; X, Xmin, Xmax : TVector; Lb, Ub : Integer; var F_min : Float)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_usimann_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitSAParams, 'InitSAParams', cdRegister);
 S.RegisterDelphiFunction(@SA_CreateLogFile, 'SA_CreateLogFile', cdRegister);
 S.RegisterDelphiFunction(@SimAnn, 'SimAnn', cdRegister);
end;

 
 
{ TPSImport_usimann }
(*----------------------------------------------------------------------------*)
procedure TPSImport_usimann.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_usimann(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_usimann.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_usimann(ri);
  RIRegister_usimann_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
