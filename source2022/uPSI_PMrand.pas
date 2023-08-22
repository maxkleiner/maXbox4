unit uPSI_PMrand;
{
  ParkMillerRandom
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
  TPSImport_PMrand = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_PMrand(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PMrand_Routines(S: TPSExec);

procedure Register;

implementation


uses
   PMrand
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PMrand]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_PMrand(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure PMrandomize( I : word)');
 CL.AddDelphiFunction('Function PMrandom : longint');
 CL.AddDelphiFunction('Function Rrand : extended');
 CL.AddDelphiFunction('Function Irand( N : word) : word');
 CL.AddDelphiFunction('Function Brand( P : extended) : boolean');
 CL.AddDelphiFunction('Function Nrand : extended');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_PMrand_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PMrandomize, 'PMrandomize', cdRegister);
 S.RegisterDelphiFunction(@PMrandom, 'PMrandom', cdRegister);
 S.RegisterDelphiFunction(@Rrand, 'Rrand', cdRegister);
 S.RegisterDelphiFunction(@Irand, 'Irand', cdRegister);
 S.RegisterDelphiFunction(@Brand, 'Brand', cdRegister);
 S.RegisterDelphiFunction(@Nrand, 'Nrand', cdRegister);
end;

 
 
{ TPSImport_PMrand }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PMrand.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PMrand(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PMrand.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_PMrand(ri);
  RIRegister_PMrand_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
