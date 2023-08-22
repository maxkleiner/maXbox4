unit uPSI_MandelbrotEngine;
{
   test bed for js
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
  TPSImport_MandelbrotEngine = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMandelbrotEngine(CL: TPSPascalCompiler);
procedure SIRegister_MandelbrotEngine(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMandelbrotEngine(CL: TPSRuntimeClassImporter);
procedure RIRegister_MandelbrotEngine(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //w3system
  //,GpW3
  MandelbrotEngine
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MandelbrotEngine]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMandelbrotEngine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMandelbrotEngine') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMandelbrotEngine') do
  begin
    RegisterMethod('Function GetLine( xStart, xEnd, y : float; numSamples : integer) : TIterationArray');
    RegisterProperty('MaxIterations', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MandelbrotEngine(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIterationArray', 'array of integer');
  SIRegister_TMandelbrotEngine(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMandelbrotEngineMaxIterations_W(Self: TMandelbrotEngine; const T: integer);
begin Self.MaxIterations := T; end;

(*----------------------------------------------------------------------------*)
procedure TMandelbrotEngineMaxIterations_R(Self: TMandelbrotEngine; var T: integer);
begin T := Self.MaxIterations; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMandelbrotEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMandelbrotEngine) do
  begin
    RegisterMethod(@TMandelbrotEngine.GetLine, 'GetLine');
    RegisterPropertyHelper(@TMandelbrotEngineMaxIterations_R,@TMandelbrotEngineMaxIterations_W,'MaxIterations');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MandelbrotEngine(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMandelbrotEngine(CL);
end;

 
 
{ TPSImport_MandelbrotEngine }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MandelbrotEngine.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MandelbrotEngine(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MandelbrotEngine.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MandelbrotEngine(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
