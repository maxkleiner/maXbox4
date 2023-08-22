unit uPSI_DrawFigures;
{
   in pantograph  to polygraph

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
  TPSImport_DrawFigures = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_DrawFigures(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DrawFigures_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Graphics
  ,GraphicsPrimitivesLibrary
  ,DrawFigures
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DrawFigures]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_DrawFigures(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure DrawCube( const PantoGraph : TPantoGraph; const color : TColor)');
 CL.AddDelphiFunction('Procedure DrawSphere( const PantoGraph : TPantoGraph; const LatitudeColor, LongitudeColor : TColor; const LatitudeCircles, LongitudeSemicircles, PointsInCircle : WORD)');
 CL.AddDelphiFunction('Procedure DrawSurface( const PantoGraph : TPantoGraph)');
 CL.AddDelphiFunction('Procedure DrawFootballField( const PantoGraph : TPantoGraph; const ColorField, ColorLetters, ColorGoals : TColor)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_DrawFigures_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DrawCube, 'DrawCube', cdRegister);
 S.RegisterDelphiFunction(@DrawSphere, 'DrawSphere', cdRegister);
 S.RegisterDelphiFunction(@DrawSurface, 'DrawSurface', cdRegister);
 S.RegisterDelphiFunction(@DrawFootballField, 'DrawFootballField', cdRegister);
end;

 
 
{ TPSImport_DrawFigures }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DrawFigures.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DrawFigures(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DrawFigures.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DrawFigures_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
