unit uPSI_USolarSystem;
{
solar fire to astro fretwork

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
  TPSImport_USolarSystem = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_USolarSystem(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_USolarSystem_Routines(S: TPSExec);

procedure Register;

implementation


uses
   VectorGeometry
  ,USolarSystem
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_USolarSystem]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_USolarSystem(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOrbitalElements', 'record N : Double; i : Double; w : Double; a'
   +' : Double; e : Double; M : Double; end');
  CL.AddTypeS('TOrbitalElementsData', 'record NConst : Double; NVar : Double; i'
   +'Const : Double; iVar : Double; wConst : Double; wVar : Double; aConst : Do'
   +'uble; aVar : Double; eConst : Double; eVar : Double; MConst : Double; MVar : Double; end');
 CL.AddConstantN('cAUToKilometers','Extended').setExtended( 149.6e6);
 CL.AddConstantN('cEarthRadius','LongInt').SetInt( 6400);
 CL.AddDelphiFunction('Function GMTDateTimeToJulianDay( const dt : TDateTime) : Double');
 CL.AddDelphiFunction('Function ComputeOrbitalElements( const oeData : TOrbitalElementsData; const d : Double) : TOrbitalElements');
 CL.AddDelphiFunction('Function ComputePlanetPosition( const orbitalElements : TOrbitalElements) : TAffineVector;');
 CL.AddDelphiFunction('Function ComputePlanetPosition1( const orbitalElementsData : TOrbitalElementsData; const d : Double) : TAffineVector;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ComputePlanetPosition1_P( const orbitalElementsData : TOrbitalElementsData; const d : Double) : TAffineVector;
Begin Result := USolarSystem.ComputePlanetPosition(orbitalElementsData, d); END;

(*----------------------------------------------------------------------------*)
Function ComputePlanetPosition0_P( const orbitalElements : TOrbitalElements) : TAffineVector;
Begin Result := USolarSystem.ComputePlanetPosition(orbitalElements); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_USolarSystem_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GMTDateTimeToJulianDay, 'GMTDateTimeToJulianDay', cdRegister);
 S.RegisterDelphiFunction(@ComputeOrbitalElements, 'ComputeOrbitalElements', cdRegister);
 S.RegisterDelphiFunction(@ComputePlanetPosition0_P, 'ComputePlanetPosition', cdRegister);
 S.RegisterDelphiFunction(@ComputePlanetPosition1_P, 'ComputePlanetPosition1', cdRegister);
end;

 
 
{ TPSImport_USolarSystem }
(*----------------------------------------------------------------------------*)
procedure TPSImport_USolarSystem.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_USolarSystem(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_USolarSystem.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_USolarSystem_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
