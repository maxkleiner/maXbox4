unit uPSI_StRandom;
{
   SysToolsç    add as float
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
  TPSImport_StRandom = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStRandomMother(CL: TPSPascalCompiler);
procedure SIRegister_TStRandomCombined(CL: TPSPascalCompiler);
procedure SIRegister_TStRandomSystem(CL: TPSPascalCompiler);
procedure SIRegister_TStRandomBase(CL: TPSPascalCompiler);
procedure SIRegister_StRandom(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStRandomMother(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStRandomCombined(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStRandomSystem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStRandomBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_StRandom(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StBase
  ,StRandom
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StRandom]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStRandomMother(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStRandomBase', 'TStRandomMother') do
  with CL.AddClassN(CL.FindClass('TStRandomBase'),'TStRandomMother') do begin
    RegisterMethod('Constructor Create( aSeed : integer)');
    RegisterMethod('function AsFloat : double;');
    RegisterProperty('Seed', 'integer', iptw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStRandomCombined(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStRandomBase', 'TStRandomCombined') do
  with CL.AddClassN(CL.FindClass('TStRandomBase'),'TStRandomCombined') do begin
    RegisterMethod('Constructor Create( aSeed1, aSeed2 : integer)');
    RegisterMethod('function AsFloat : double;');
    RegisterProperty('Seed1', 'integer', iptrw);
    RegisterProperty('Seed2', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStRandomSystem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStRandomBase', 'TStRandomSystem') do
  with CL.AddClassN(CL.FindClass('TStRandomBase'),'TStRandomSystem') do begin
    RegisterMethod('Constructor Create( aSeed : integer)');
    RegisterMethod('function AsFloat : double;');
    RegisterProperty('Seed', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStRandomBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStRandomBase') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStRandomBase') do begin
    RegisterMethod('Function AsFloat : double');
    RegisterMethod('Function AsInt( aUpperLimit : integer) : integer');
    RegisterMethod('Function AsIntInRange( aLowerLimit : integer; aUpperLimit : integer) : integer');
    RegisterMethod('Function AsBeta( aShape1, aShape2 : double) : double');
    RegisterMethod('Function AsCauchy : double');
    RegisterMethod('Function AsChiSquared( aFreedom : integer) : double');
    RegisterMethod('Function AsErlang( aMean : double; aOrder : integer) : double');
    RegisterMethod('Function AsExponential( aMean : double) : double');
    RegisterMethod('Function AsF( aFreedom1 : integer; aFreedom2 : integer) : double');
    RegisterMethod('Function AsGamma( aShape : double; aScale : double) : double');
    RegisterMethod('Function AsLogNormal( aMean : double; aStdDev : double) : double');
    RegisterMethod('Function AsNormal( aMean : double; aStdDev : double) : double');
    RegisterMethod('Function AsT( aFreedom : integer) : double');
    RegisterMethod('Function AsWeibull( aShape : double; aScale : double) : double');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StRandom(CL: TPSPascalCompiler);
begin
  SIRegister_TStRandomBase(CL);
  SIRegister_TStRandomSystem(CL);
  SIRegister_TStRandomCombined(CL);
  SIRegister_TStRandomMother(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStRandomMotherSeed_W(Self: TStRandomMother; const T: integer);
begin Self.Seed := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRandomCombinedSeed2_W(Self: TStRandomCombined; const T: integer);
begin Self.Seed2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRandomCombinedSeed2_R(Self: TStRandomCombined; var T: integer);
begin T := Self.Seed2; end;

(*----------------------------------------------------------------------------*)
procedure TStRandomCombinedSeed1_W(Self: TStRandomCombined; const T: integer);
begin Self.Seed1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRandomCombinedSeed1_R(Self: TStRandomCombined; var T: integer);
begin T := Self.Seed1; end;

(*----------------------------------------------------------------------------*)
procedure TStRandomSystemSeed_W(Self: TStRandomSystem; const T: integer);
begin Self.Seed := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRandomSystemSeed_R(Self: TStRandomSystem; var T: integer);
begin T := Self.Seed; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStRandomMother(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStRandomMother) do begin
    RegisterConstructor(@TStRandomMother.Create, 'Create');
     RegisterMethod(@TStRandomMother.AsFloat, 'AsFloat');
     RegisterPropertyHelper(nil,@TStRandomMotherSeed_W,'Seed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStRandomCombined(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStRandomCombined) do begin
    RegisterConstructor(@TStRandomCombined.Create, 'Create');
         RegisterMethod(@TStRandomCombined.AsFloat, 'AsFloat');
    RegisterPropertyHelper(@TStRandomCombinedSeed1_R,@TStRandomCombinedSeed1_W,'Seed1');
    RegisterPropertyHelper(@TStRandomCombinedSeed2_R,@TStRandomCombinedSeed2_W,'Seed2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStRandomSystem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStRandomSystem) do begin
    RegisterConstructor(@TStRandomSystem.Create, 'Create');
    RegisterMethod(@TStRandomSystem.AsFloat, 'AsFloat');
    RegisterPropertyHelper(@TStRandomSystemSeed_R,@TStRandomSystemSeed_W,'Seed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStRandomBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStRandomBase) do begin
    //RegisterVirtualAbstractMethod(@TStRandomBase, @!.AsFloat, 'AsFloat');
    RegisterMethod(@TStRandomBase.AsInt, 'AsInt');
    RegisterMethod(@TStRandomBase.AsIntInRange, 'AsIntInRange');
    RegisterMethod(@TStRandomBase.AsBeta, 'AsBeta');
    RegisterMethod(@TStRandomBase.AsCauchy, 'AsCauchy');
    RegisterMethod(@TStRandomBase.AsChiSquared, 'AsChiSquared');
    RegisterMethod(@TStRandomBase.AsErlang, 'AsErlang');
    RegisterMethod(@TStRandomBase.AsExponential, 'AsExponential');
    RegisterMethod(@TStRandomBase.AsF, 'AsF');
    RegisterMethod(@TStRandomBase.AsGamma, 'AsGamma');
    RegisterMethod(@TStRandomBase.AsLogNormal, 'AsLogNormal');
    RegisterMethod(@TStRandomBase.AsNormal, 'AsNormal');
    RegisterMethod(@TStRandomBase.AsT, 'AsT');
    RegisterMethod(@TStRandomBase.AsWeibull, 'AsWeibull');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StRandom(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStRandomBase(CL);
  RIRegister_TStRandomSystem(CL);
  RIRegister_TStRandomCombined(CL);
  RIRegister_TStRandomMother(CL);
end;

 
 
{ TPSImport_StRandom }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StRandom.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StRandom(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StRandom.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StRandom(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
