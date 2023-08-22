unit uPSI_JclUnitConv_mX2;
{
   a big routine lib  from float to double
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
  TPSImport_JclUnitConv_mX2 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclUnitConv_mX2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclUnitConv_mX2_Routines(S: TPSExec);

procedure Register;

implementation


uses
   JclUnitConv_mX2;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclUnitConv_mX2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclUnitConv_mX2(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('CelsiusFreezingPoint','Extended').setExtended( 0.0);
 CL.AddConstantN('FahrenheitFreezingPoint','Extended').setExtended( 32.0);
 CL.AddConstantN('KelvinFreezingPoint','Extended').setExtended( 273.15);
 CL.AddConstantN('CelsiusAbsoluteZero','Extended').setExtended( - 273.15);
 CL.AddConstantN('FahrenheitAbsoluteZero','Extended').setExtended( - 459.67);
 CL.AddConstantN('KelvinAbsoluteZero','Extended').setExtended( 0.0);
 CL.AddConstantN('DegPerCycle','Extended').setExtended( 360.0);
 CL.AddConstantN('DegPerGrad','Extended').setExtended( 0.9);
 CL.AddConstantN('DegPerRad','Extended').setExtended( 57.295779513082320876798154814105);
 CL.AddConstantN('GradPerCycle','Extended').setExtended( 400.0);
 CL.AddConstantN('GradPerDeg','Extended').setExtended( 1.1111111111111111111111111111111);
 CL.AddConstantN('GradPerRad','Extended').setExtended( 63.661977236758134307553505349006);
 CL.AddConstantN('RadPerCycle','Extended').setExtended( 6.283185307179586476925286766559);
 CL.AddConstantN('RadPerDeg','Extended').setExtended( 0.017453292519943295769236907684886);
 CL.AddConstantN('RadPerGrad','Extended').setExtended( 0.015707963267948966192313216916398);
 CL.AddConstantN('CyclePerDeg','Extended').setExtended( 0.0027777777777777777777777777777778);
 CL.AddConstantN('CyclePerGrad','Extended').setExtended( 0.0025);
 CL.AddConstantN('CyclePerRad','Extended').setExtended( 0.15915494309189533576888376337251);
 CL.AddConstantN('ArcMinutesPerDeg','Extended').setExtended( 60.0);
 CL.AddConstantN('ArcSecondsPerArcMinute','Extended').setExtended( 60.0);
 CL.AddDelphiFunction('Function HowAOneLinerCanBiteYou( const Step, Max : Longint) : Longint');
 CL.AddDelphiFunction('Function MakePercentage( const Step, Max : Longint) : Longint');
 CL.AddDelphiFunction('Function CelsiusToKelvin( const T : double) : double');
 CL.AddDelphiFunction('Function CelsiusToFahrenheit2( const T : double) : double');
 CL.AddDelphiFunction('Function KelvinToCelsius( const T : double) : double');
 CL.AddDelphiFunction('Function KelvinToFahrenheit( const T : double) : double');
 CL.AddDelphiFunction('Function FahrenheitToCelsius2( const T : double) : double');
 CL.AddDelphiFunction('Function FahrenheitToKelvin( const T : double) : double');
 CL.AddDelphiFunction('Function CycleToDegJ( const Cycles : double) : double');
 CL.AddDelphiFunction('Function CycleToGradJ( const Cycles : double) : double');
 CL.AddDelphiFunction('Function CycleToRadJ( const Cycles : double) : double');
 CL.AddDelphiFunction('Function DegToCycleJ( const Degrees : double) : double');
 CL.AddDelphiFunction('Function DegToGradJ( const Degrees : double) : double');
 CL.AddDelphiFunction('Function DegToRadJ( const Degrees : double) : double');
 CL.AddDelphiFunction('Function GradToCycleJ( const Grads : double) : double');
 CL.AddDelphiFunction('Function GradToDegJ( const Grads : double) : double');
 CL.AddDelphiFunction('Function GradToRadJ( const Grads : double) : double');
 CL.AddDelphiFunction('Function RadToCycleJ( const Radians : double) : double');
 CL.AddDelphiFunction('Function RadToDegJ( const Radians : double) : double');
 CL.AddDelphiFunction('Function RadToGradJ( const Radians : double) : double');
 CL.AddDelphiFunction('Function DmsToDeg( const D, M : Integer; const S : double) : double');
 CL.AddDelphiFunction('Function DmsToRad( const D, M : Integer; const S : double) : double');
 CL.AddDelphiFunction('Procedure DegToDms( const Degrees : double; out D, M : Integer; out S : double)');
 CL.AddDelphiFunction('Function DegToDmsStr( const Degrees : double; const SecondPrecision : Cardinal) : string');
 CL.AddDelphiFunction('Procedure CartesianToPolar( const X, Y : double; out R, Phi : double)');
 CL.AddDelphiFunction('Procedure PolarToCartesian( const R, Phi : double; out X, Y : double)');
 CL.AddDelphiFunction('Procedure CartesianToCylinder( const X, Y, Z : double; out R, Phi, Zeta : double)');
 CL.AddDelphiFunction('Procedure CartesianToSpheric( const X, Y, Z : double; out Rho, Phi, Theta : double)');
 CL.AddDelphiFunction('Procedure CylinderToCartesian( const R, Phi, Zeta : double; out X, Y, Z : double)');
 CL.AddDelphiFunction('Procedure SphericToCartesian( const Rho, Theta, Phi : double; out X, Y, Z : double)');
 CL.AddDelphiFunction('Function CmToInch( const Cm : double) : double');
 CL.AddDelphiFunction('Function InchToCm( const Inch : double) : double');
 CL.AddDelphiFunction('Function FeetToMetre( const Feet : double) : double');
 CL.AddDelphiFunction('Function MetreToFeet( const Metre : double) : double');
 CL.AddDelphiFunction('Function YardToMetre( const Yard : double) : double');
 CL.AddDelphiFunction('Function MetreToYard( const Metre : double) : double');
 CL.AddDelphiFunction('Function NmToKm( const Nm : double) : double');
 CL.AddDelphiFunction('Function KmToNm( const Km : double) : double');
 CL.AddDelphiFunction('Function KmToSm( const Km : double) : double');
 CL.AddDelphiFunction('Function SmToKm( const Sm : double) : double');
 CL.AddDelphiFunction('Function LitreToGalUs( const Litre : double) : double');
 CL.AddDelphiFunction('Function GalUsToLitre( const GalUs : double) : double');
 CL.AddDelphiFunction('Function GalUsToGalCan( const GalUs : double) : double');
 CL.AddDelphiFunction('Function GalCanToGalUs( const GalCan : double) : double');
 CL.AddDelphiFunction('Function GalUsToGalUk( const GalUs : double) : double');
 CL.AddDelphiFunction('Function GalUkToGalUs( const GalUk : double) : double');
 CL.AddDelphiFunction('Function LitreToGalCan( const Litre : double) : double');
 CL.AddDelphiFunction('Function GalCanToLitre( const GalCan : double) : double');
 CL.AddDelphiFunction('Function LitreToGalUk( const Litre : double) : double');
 CL.AddDelphiFunction('Function GalUkToLitre( const GalUk : double) : double');
 CL.AddDelphiFunction('Function KgToLb( const Kg : double) : double');
 CL.AddDelphiFunction('Function LbToKg( const Lb : double) : double');
 CL.AddDelphiFunction('Function KgToOz( const Kg : double) : double');
 CL.AddDelphiFunction('Function OzToKg( const Oz : double) : double');
 CL.AddDelphiFunction('Function CwtUsToKg( const Cwt : double) : double');
 CL.AddDelphiFunction('Function CwtUkToKg( const Cwt : double) : double');
 CL.AddDelphiFunction('Function KaratToKg( const Karat : double) : double');
 CL.AddDelphiFunction('Function KgToCwtUs( const Kg : double) : double');
 CL.AddDelphiFunction('Function KgToCwtUk( const Kg : double) : double');
 CL.AddDelphiFunction('Function KgToKarat( const Kg : double) : double');
 CL.AddDelphiFunction('Function KgToSton( const Kg : double) : double');
 CL.AddDelphiFunction('Function KgToLton( const Kg : double) : double');
 CL.AddDelphiFunction('Function StonToKg( const STon : double) : double');
 CL.AddDelphiFunction('Function LtonToKg( const Lton : double) : double');
 CL.AddDelphiFunction('Function QrUsToKg( const Qr : double) : double');
 CL.AddDelphiFunction('Function QrUkToKg( const Qr : double) : double');
 CL.AddDelphiFunction('Function KgToQrUs( const Kg : double) : double');
 CL.AddDelphiFunction('Function KgToQrUk( const Kg : double) : double');
 CL.AddDelphiFunction('Function PascalToBar( const Pa : double) : double');
 CL.AddDelphiFunction('Function PascalToAt( const Pa : double) : double');
 CL.AddDelphiFunction('Function PascalToTorr( const Pa : double) : double');
 CL.AddDelphiFunction('Function BarToPascal( const Bar : double) : double');
 CL.AddDelphiFunction('Function AtToPascal( const At : double) : double');
 CL.AddDelphiFunction('Function TorrToPascal( const Torr : double) : double');
 CL.AddDelphiFunction('Function KnotToMs( const Knot : double) : double');
 CL.AddDelphiFunction('Function HpElectricToWatt( const HpE : double) : double');
 CL.AddDelphiFunction('Function HpMetricToWatt( const HpM : double) : double');
 CL.AddDelphiFunction('Function MsToKnot( const ms : double) : double');
 CL.AddDelphiFunction('Function WattToHpElectric( const W : double) : double');
 CL.AddDelphiFunction('Function WattToHpMetric( const W : double) : double');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JclUnitConv_mX2_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HowAOneLinerCanBiteYou, 'HowAOneLinerCanBiteYou', cdRegister);
 S.RegisterDelphiFunction(@MakePercentage, 'MakePercentage', cdRegister);
 S.RegisterDelphiFunction(@CelsiusToKelvin, 'CelsiusToKelvin', cdRegister);
 S.RegisterDelphiFunction(@CelsiusToFahrenheit, 'CelsiusToFahrenheit2', cdRegister);
 S.RegisterDelphiFunction(@KelvinToCelsius, 'KelvinToCelsius', cdRegister);
 S.RegisterDelphiFunction(@KelvinToFahrenheit, 'KelvinToFahrenheit', cdRegister);
 S.RegisterDelphiFunction(@FahrenheitToCelsius, 'FahrenheitToCelsius2', cdRegister);
 S.RegisterDelphiFunction(@FahrenheitToKelvin, 'FahrenheitToKelvin', cdRegister);
 S.RegisterDelphiFunction(@CycleToDeg, 'CycleToDegJ', cdRegister);
 S.RegisterDelphiFunction(@CycleToGrad, 'CycleToGradJ', cdRegister);
 S.RegisterDelphiFunction(@CycleToRad, 'CycleToRadJ', cdRegister);
 S.RegisterDelphiFunction(@DegToCycle, 'DegToCycleJ', cdRegister);
 S.RegisterDelphiFunction(@DegToGrad, 'DegToGradJ', cdRegister);
 S.RegisterDelphiFunction(@DegToRad, 'DegToRadJ', cdRegister);
 S.RegisterDelphiFunction(@GradToCycle, 'GradToCycleJ', cdRegister);
 S.RegisterDelphiFunction(@GradToDeg, 'GradToDegJ', cdRegister);
 S.RegisterDelphiFunction(@GradToRad, 'GradToRadJ', cdRegister);
 S.RegisterDelphiFunction(@RadToCycle, 'RadToCycleJ', cdRegister);
 S.RegisterDelphiFunction(@RadToDeg, 'RadToDegJ', cdRegister);
 S.RegisterDelphiFunction(@RadToGrad, 'RadToGradJ', cdRegister);
 S.RegisterDelphiFunction(@DmsToDeg, 'DmsToDeg', cdRegister);
 S.RegisterDelphiFunction(@DmsToRad, 'DmsToRad', cdRegister);
 S.RegisterDelphiFunction(@DegToDms, 'DegToDms', cdRegister);
 S.RegisterDelphiFunction(@DegToDmsStr, 'DegToDmsStr', cdRegister);
 S.RegisterDelphiFunction(@CartesianToPolar, 'CartesianToPolar', cdRegister);
 S.RegisterDelphiFunction(@PolarToCartesian, 'PolarToCartesian', cdRegister);
 S.RegisterDelphiFunction(@CartesianToCylinder, 'CartesianToCylinder', cdRegister);
 S.RegisterDelphiFunction(@CartesianToSpheric, 'CartesianToSpheric', cdRegister);
 S.RegisterDelphiFunction(@CylinderToCartesian, 'CylinderToCartesian', cdRegister);
 S.RegisterDelphiFunction(@SphericToCartesian, 'SphericToCartesian', cdRegister);
 S.RegisterDelphiFunction(@CmToInch, 'CmToInch', cdRegister);
 S.RegisterDelphiFunction(@InchToCm, 'InchToCm', cdRegister);
 S.RegisterDelphiFunction(@FeetToMetre, 'FeetToMetre', cdRegister);
 S.RegisterDelphiFunction(@MetreToFeet, 'MetreToFeet', cdRegister);
 S.RegisterDelphiFunction(@YardToMetre, 'YardToMetre', cdRegister);
 S.RegisterDelphiFunction(@MetreToYard, 'MetreToYard', cdRegister);
 S.RegisterDelphiFunction(@NmToKm, 'NmToKm', cdRegister);
 S.RegisterDelphiFunction(@KmToNm, 'KmToNm', cdRegister);
 S.RegisterDelphiFunction(@KmToSm, 'KmToSm', cdRegister);
 S.RegisterDelphiFunction(@SmToKm, 'SmToKm', cdRegister);
 S.RegisterDelphiFunction(@LitreToGalUs, 'LitreToGalUs', cdRegister);
 S.RegisterDelphiFunction(@GalUsToLitre, 'GalUsToLitre', cdRegister);
 S.RegisterDelphiFunction(@GalUsToGalCan, 'GalUsToGalCan', cdRegister);
 S.RegisterDelphiFunction(@GalCanToGalUs, 'GalCanToGalUs', cdRegister);
 S.RegisterDelphiFunction(@GalUsToGalUk, 'GalUsToGalUk', cdRegister);
 S.RegisterDelphiFunction(@GalUkToGalUs, 'GalUkToGalUs', cdRegister);
 S.RegisterDelphiFunction(@LitreToGalCan, 'LitreToGalCan', cdRegister);
 S.RegisterDelphiFunction(@GalCanToLitre, 'GalCanToLitre', cdRegister);
 S.RegisterDelphiFunction(@LitreToGalUk, 'LitreToGalUk', cdRegister);
 S.RegisterDelphiFunction(@GalUkToLitre, 'GalUkToLitre', cdRegister);
 S.RegisterDelphiFunction(@KgToLb, 'KgToLb', cdRegister);
 S.RegisterDelphiFunction(@LbToKg, 'LbToKg', cdRegister);
 S.RegisterDelphiFunction(@KgToOz, 'KgToOz', cdRegister);
 S.RegisterDelphiFunction(@OzToKg, 'OzToKg', cdRegister);
 S.RegisterDelphiFunction(@CwtUsToKg, 'CwtUsToKg', cdRegister);
 S.RegisterDelphiFunction(@CwtUkToKg, 'CwtUkToKg', cdRegister);
 S.RegisterDelphiFunction(@KaratToKg, 'KaratToKg', cdRegister);
 S.RegisterDelphiFunction(@KgToCwtUs, 'KgToCwtUs', cdRegister);
 S.RegisterDelphiFunction(@KgToCwtUk, 'KgToCwtUk', cdRegister);
 S.RegisterDelphiFunction(@KgToKarat, 'KgToKarat', cdRegister);
 S.RegisterDelphiFunction(@KgToSton, 'KgToSton', cdRegister);
 S.RegisterDelphiFunction(@KgToLton, 'KgToLton', cdRegister);
 S.RegisterDelphiFunction(@StonToKg, 'StonToKg', cdRegister);
 S.RegisterDelphiFunction(@LtonToKg, 'LtonToKg', cdRegister);
 S.RegisterDelphiFunction(@QrUsToKg, 'QrUsToKg', cdRegister);
 S.RegisterDelphiFunction(@QrUkToKg, 'QrUkToKg', cdRegister);
 S.RegisterDelphiFunction(@KgToQrUs, 'KgToQrUs', cdRegister);
 S.RegisterDelphiFunction(@KgToQrUk, 'KgToQrUk', cdRegister);
 S.RegisterDelphiFunction(@PascalToBar, 'PascalToBar', cdRegister);
 S.RegisterDelphiFunction(@PascalToAt, 'PascalToAt', cdRegister);
 S.RegisterDelphiFunction(@PascalToTorr, 'PascalToTorr', cdRegister);
 S.RegisterDelphiFunction(@BarToPascal, 'BarToPascal', cdRegister);
 S.RegisterDelphiFunction(@AtToPascal, 'AtToPascal', cdRegister);
 S.RegisterDelphiFunction(@TorrToPascal, 'TorrToPascal', cdRegister);
 S.RegisterDelphiFunction(@KnotToMs, 'KnotToMs', cdRegister);
 S.RegisterDelphiFunction(@HpElectricToWatt, 'HpElectricToWatt', cdRegister);
 S.RegisterDelphiFunction(@HpMetricToWatt, 'HpMetricToWatt', cdRegister);
 S.RegisterDelphiFunction(@MsToKnot, 'MsToKnot', cdRegister);
 S.RegisterDelphiFunction(@WattToHpElectric, 'WattToHpElectric', cdRegister);
 S.RegisterDelphiFunction(@WattToHpMetric, 'WattToHpMetric', cdRegister);
end;

 
 
{ TPSImport_JclUnitConv_mX2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclUnitConv_mX2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclUnitConv_mX2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclUnitConv_mX2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclUnitConv_mX2(ri);
  RIRegister_JclUnitConv_mX2_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
