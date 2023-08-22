unit uPSI_StdConvs;
{
with convutils
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
  TPSImport_StdConvs = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StdConvs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StdConvs_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ConvUtils
  ,StdConvs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StdConvs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StdConvs(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MetersPerInch','Extended').setExtended( 0.0254);
 CL.AddConstantN('MetersPerFoot','Extended').SetExtended( MetersPerInch * 12);
 CL.AddConstantN('MetersPerYard','Extended').SetExtended( MetersPerFoot * 3);
 CL.AddConstantN('MetersPerMile','Extended').SetExtended( MetersPerFoot * 5280);
 CL.AddConstantN('MetersPerNauticalMiles','LongInt').SetInt( 1852);
 CL.AddConstantN('MetersPerAstronomicalUnit','Extended').setExtended( 1.49598E11);
 CL.AddConstantN('MetersPerLightSecond','Extended').setExtended( 2.99792458E8);
 CL.AddConstantN('MetersPerLightYear','Extended').setExtended( MetersPerLightSecond * 31556925.9747);
 CL.AddConstantN('MetersPerParsec','Extended').setExtended( MetersPerAstronomicalUnit * 206264.806247096);
 CL.AddConstantN('MetersPerCubit','Extended').setExtended( 0.4572);
 CL.AddConstantN('MetersPerFathom','Extended').SetExtended( MetersPerFoot * 6);
 CL.AddConstantN('MetersPerFurlong','Extended').SetExtended( MetersPerYard * 220);
 CL.AddConstantN('MetersPerHand','Extended').SetExtended( MetersPerInch * 4);
 CL.AddConstantN('MetersPerPace','Extended').SetExtended( MetersPerInch * 30);
 CL.AddConstantN('MetersPerRod','Extended').setExtended( MetersPerFoot * 16.5);
 CL.AddConstantN('MetersPerChain','Extended').SetExtended( MetersPerRod * 4);
 CL.AddConstantN('MetersPerLink','Extended').SetExtended( MetersPerChain / 100);
 CL.AddConstantN('MetersPerPoint','Extended').setExtended( MetersPerInch * 0.013837);
 CL.AddConstantN('MetersPerPica','Extended').SetExtended( MetersPerPoint * 12);
 CL.AddConstantN('SquareMetersPerAcre','Extended').SetExtended( SquareMetersPerSquareYard * 4840);
 CL.AddConstantN('CubicMetersPerCord','Extended').SetExtended( CubicMetersPerCubicFoot * 128);
 CL.AddConstantN('CubicMetersPerCordFoot','Extended').SetExtended( CubicMetersPerCubicFoot * 16);
 CL.AddConstantN('CubicMetersPerUSFluidGallon','Extended').SetExtended( CubicMetersPerCubicInch * 231);
 CL.AddConstantN('CubicMetersPerUSFluidQuart','Extended').SetExtended( CubicMetersPerUSFluidGallon / 4);
 CL.AddConstantN('CubicMetersPerUSFluidPint','Extended').SetExtended( CubicMetersPerUSFluidQuart / 2);
 CL.AddConstantN('CubicMetersPerUSFluidCup','Extended').SetExtended( CubicMetersPerUSFluidPint / 2);
 CL.AddConstantN('CubicMetersPerUSFluidGill','Extended').SetExtended( CubicMetersPerUSFluidCup / 2);
 CL.AddConstantN('CubicMetersPerUSFluidOunce','Extended').SetExtended( CubicMetersPerUSFluidCup / 8);
 CL.AddConstantN('CubicMetersPerUSFluidTablespoon','Extended').SetExtended( CubicMetersPerUSFluidOunce / 2);
 CL.AddConstantN('CubicMetersPerUSFluidTeaspoon','Extended').SetExtended( CubicMetersPerUSFluidOunce / 6);
 CL.AddConstantN('CubicMetersPerUSDryGallon','Extended').setExtended( CubicMetersPerCubicInch * 268.8025);
 CL.AddConstantN('CubicMetersPerUSDryQuart','Extended').SetExtended( CubicMetersPerUSDryGallon / 4);
 CL.AddConstantN('CubicMetersPerUSDryPint','Extended').SetExtended( CubicMetersPerUSDryQuart / 2);
 CL.AddConstantN('CubicMetersPerUSDryPeck','Extended').SetExtended( CubicMetersPerUSDryGallon * 2);
 CL.AddConstantN('CubicMetersPerUSDryBucket','Extended').SetExtended( CubicMetersPerUSDryPeck * 2);
 CL.AddConstantN('CubicMetersPerUSDryBushel','Extended').SetExtended( CubicMetersPerUSDryBucket * 2);
 CL.AddConstantN('CubicMetersPerUKGallon','Extended').setExtended( 0.00454609);
 CL.AddConstantN('CubicMetersPerUKPottle','Extended').SetExtended( CubicMetersPerUKGallon / 2);
 CL.AddConstantN('CubicMetersPerUKQuart','Extended').SetExtended( CubicMetersPerUKPottle / 2);
 CL.AddConstantN('CubicMetersPerUKPint','Extended').SetExtended( CubicMetersPerUKQuart / 2);
 CL.AddConstantN('CubicMetersPerUKGill','Extended').SetExtended( CubicMetersPerUKPint / 4);
 CL.AddConstantN('CubicMetersPerUKOunce','Extended').SetExtended( CubicMetersPerUKPint / 20);
 CL.AddConstantN('CubicMetersPerUKPeck','Extended').SetExtended( CubicMetersPerUKGallon * 2);
 CL.AddConstantN('CubicMetersPerUKBucket','Extended').SetExtended( CubicMetersPerUKPeck * 2);
 CL.AddConstantN('CubicMetersPerUKBushel','Extended').SetExtended( CubicMetersPerUKBucket * 2);
 CL.AddConstantN('GramsPerPound','Extended').setExtended( 453.59237);
 CL.AddConstantN('GramsPerDrams','Extended').SetExtended( GramsPerPound / 256);
 CL.AddConstantN('GramsPerGrains','Extended').SetExtended( GramsPerPound / 7000);
 CL.AddConstantN('GramsPerTons','Extended').SetExtended( GramsPerPound * 2000);
 CL.AddConstantN('GramsPerLongTons','Extended').SetExtended( GramsPerPound * 2240);
 CL.AddConstantN('GramsPerOunces','Extended').SetExtended( GramsPerPound / 16);
 CL.AddConstantN('GramsPerStones','Extended').SetExtended( GramsPerPound * 14);
 CL.AddDelphiFunction('Function FahrenheitToCelsius( const AValue : Double) : Double');
 CL.AddDelphiFunction('Function CelsiusToFahrenheit( const AValue : Double) : Double');
 CL.AddDelphiFunction('Procedure InitStdConvs');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StdConvs_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FahrenheitToCelsius, 'FahrenheitToCelsius', cdRegister);
 S.RegisterDelphiFunction(@CelsiusToFahrenheit, 'CelsiusToFahrenheit', cdRegister);
 S.RegisterDelphiFunction(@InitStdConvs, 'InitStdConvs', cdRegister);
end;

 
 
{ TPSImport_StdConvs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StdConvs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StdConvs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StdConvs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StdConvs(ri);
  RIRegister_StdConvs_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
