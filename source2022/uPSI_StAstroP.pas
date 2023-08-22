unit uPSI_StAstroP;
{
  SysTools4     adapted by mX
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
  TPSImport_StAstroP = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_StAstroP(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StAstroP_Routines(S: TPSExec);

procedure Register;

implementation


uses
   StAstroP
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StAstroP]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StAstroP(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('StdDate','Extended').setExtended( 2451545.0);
 CL.AddConstantN('OB2000','Extended').setExtended( 0.409092804);
 CL.AddTypeS('TStPlanetsRec', 'record RA, DC, Elong: Double; end');
 CL.AddTypeS('TStEclipticalCord', 'record LO, BO, RO: Double; end');
 CL.AddTypeS('TStRectangularCord', 'record X, Y, Z: Double; end');

 CL.AddTypeS('TStPlanetsArray', 'array[1..8] of TStPlanetsRec;');
 {TStPlanetsRec = packed record
    RA,
    DC,
    Elong  : Double;
  end;}
  //TStPlanetsArray = array[1..8] of TStPlanetsRec;


 CL.AddDelphiFunction('Procedure PlanetsPos( JD : Double; var PA : TStPlanetsArray)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StAstroP_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PlanetsPos, 'PlanetsPos', cdRegister);
end;



{ TPSImport_StAstroP }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StAstroP.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StAstroP(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StAstroP.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StAstroP(ri);
  RIRegister_StAstroP_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
