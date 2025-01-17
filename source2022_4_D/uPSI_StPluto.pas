unit uPSI_StPluto;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_StPluto = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StPluto(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StPluto_Routines(S: TPSExec);

procedure Register;

implementation


uses
   StAstroP
  ,StMath
  ,StPluto
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StPluto]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StPluto(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function ComputePluto( JD : Double) : TStEclipticalCord');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StPluto_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ComputePluto, 'ComputePluto', cdRegister);
end;

 
 
{ TPSImport_StPluto }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StPluto.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StPluto(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StPluto.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StPluto(ri);
  RIRegister_StPluto_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
