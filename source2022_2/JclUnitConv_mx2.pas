{**************************************************************************************************}
{                                                                                                  }
{ Project JEDI Code Library (JCL)                                                                  }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is JclUnitConv.pas.                                                            }
{                                                                                                  }
{ The Initial Developer of the Original Code is documented in the accompanying                     }
{ help file JCL.chm. Portions created by these individuals are Copyright (C) of these individuals. }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Contains routines to perform conversion between various units such as length coordinate,         }
{ temperature, angle, mass and pressure conversions.                                               }
{                                                                                                  }
{ Unit owner: Marcel van Brakel                                                                    }
{ Last modified: December 17, 2000                                                                 }
{                                                                                                  }
{**************************************************************************************************}

unit JclUnitConv_mX2;

//{$I jcl.inc}

//{$WEAKPACKAGEUNIT ON}

interface

//uses
  //JclUnitConv_mX;

const

  { Temperature constants }

  CelsiusFreezingPoint    = 0.0;
  FahrenheitFreezingPoint = 32.0;
  KelvinFreezingPoint     = 273.15;
  CelsiusBoilingPoint     = 100.0 + CelsiusFreezingPoint;
  FahrenheitBoilingPoint  = 180.0 + FahrenheitFreezingPoint;
  KelvinBoilingPoint      = 100.0 + KelvinFreezingPoint;
  CelsiusAbsoluteZero     = -273.15;
  FahrenheitAbsoluteZero  = -459.67;
  KelvinAbsoluteZero      = 0.0;

  { Mathematical constants }

  DegPerCycle      = 360.0;
  DegPerGrad       = 0.9;
  DegPerRad        = 57.295779513082320876798154814105;
  GradPerCycle     = 400.0;
  GradPerDeg       = 1.1111111111111111111111111111111;
  GradPerRad       = 63.661977236758134307553505349006;
  RadPerCycle      = 6.283185307179586476925286766559;
  RadPerDeg        = 0.017453292519943295769236907684886;
  RadPerGrad       = 0.015707963267948966192313216916398;
  CyclePerDeg      = 0.0027777777777777777777777777777778;
  CyclePerGrad     = 0.0025;
  CyclePerRad      = 0.15915494309189533576888376337251;
  ArcMinutesPerDeg        = 60.0;
  ArcSecondsPerArcMinute  = 60.0;
  ArcSecondsPerDeg        = ArcSecondsPerArcMinute * ArcMinutesPerDeg;
  DegPerArcMinute         = 1/ArcMinutesPerDeg;
  DegPerArcSecond         = 1/ArcSecondsPerDeg;

  //type float = double;

function HowAOneLinerCanBiteYou(const Step, Max: Longint): Longint;
function MakePercentage(const Step, Max: Longint): Longint;

{ Temperature conversion }

function CelsiusToKelvin(const T: double): double;
function CelsiusToFahrenheit(const T: double): double;
function KelvinToCelsius(const T: double): double;
function KelvinToFahrenheit(const T: double): double;
function FahrenheitToCelsius(const T: double): double;
function FahrenheitToKelvin(const T: double): double;

{ Angle conversion }

function CycleToDeg(const Cycles: double): double;
function CycleToGrad(const Cycles: double): double;
function CycleToRad(const Cycles: double): double;
function DegToCycle(const Degrees: double): double;
function DegToGrad(const Degrees: double): double;
function DegToRad(const Degrees: double): double;
function GradToCycle(const Grads: double): double;
function GradToDeg(const Grads: double): double;
function GradToRad(const Grads: double): double;
function RadToCycle(const Radians: double): double;
function RadToDeg(const Radians: double): double;
function RadToGrad(const Radians: double): double;
function DmsToDeg(const D, M: Integer; const S: double): double;
function DmsToRad(const D, M: Integer; const S: double): double;
procedure DegToDms(const Degrees: double; out D, M: Integer; out S: double);
function DegToDmsStr(const Degrees: double; const SecondPrecision: Cardinal): string;

{ Coordinate conversion }

procedure CartesianToPolar(const X, Y: double; out R, Phi: double);
procedure PolarToCartesian(const R, Phi: double; out X, Y: double);
procedure CartesianToCylinder(const X, Y, Z: double; out R, Phi, Zeta: double);
procedure CartesianToSpheric(const X, Y, Z: double; out Rho, Phi, Theta: double);
procedure CylinderToCartesian(const R, Phi, Zeta: double; out X, Y, Z: double);
procedure SphericToCartesian(const Rho, Theta, Phi: double; out X, Y, Z: double);

{ Length conversion }

function CmToInch(const Cm: double): double;
function InchToCm(const Inch: double): double;
function FeetToMetre(const Feet: double): double;
function MetreToFeet(const Metre: double): double;
function YardToMetre(const Yard: double): double;
function MetreToYard(const Metre: double): double;
function NmToKm(const Nm: double): double;
function KmToNm(const Km: double): double;
function KmToSm(const Km: double): double;
function SmToKm(const Sm: double): double;

{ Volume conversion }

function LitreToGalUs(const Litre: double): double;
function GalUsToLitre(const GalUs: double): double;
function GalUsToGalCan(const GalUs: double): double;
function GalCanToGalUs(const GalCan: double): double;
function GalUsToGalUk(const GalUs: double): double;
function GalUkToGalUs(const GalUk: double): double;
function LitreToGalCan(const Litre: double): double;
function GalCanToLitre(const GalCan: double): double;
function LitreToGalUk(const Litre: double): double;
function GalUkToLitre(const GalUk: double): double;

{ Mass conversion }

function KgToLb(const Kg: double): double;
function LbToKg(const Lb: double): double;
function KgToOz(const Kg: double): double;
function OzToKg(const Oz: double): double;
function CwtUsToKg(const Cwt: double): double;
function CwtUkToKg(const Cwt: double): double;
function KaratToKg(const Karat: double): double;
function KgToCwtUs(const Kg: double): double;
function KgToCwtUk(const Kg: double): double;
function KgToKarat(const Kg: double): double;
function KgToSton(const Kg: double): double;
function KgToLton(const Kg: double): double;
function StonToKg(const STon: double): double;
function LtonToKg(const Lton: double): double;
function QrUsToKg(const Qr: double): double;
function QrUkToKg(const Qr: double): double;
function KgToQrUs(const Kg: double): double;
function KgToQrUk(const Kg: double): double;

{ Pressure conversion }

function PascalToBar(const Pa: double): double;
function PascalToAt(const Pa: double): double;
function PascalToTorr(const Pa: double): double;
function BarToPascal(const Bar: double): double;
function AtToPascal(const At: double): double;
function TorrToPascal(const Torr: double): double;

{ Other conversion }

function KnotToMs(const Knot: double): double;
function HpElectricToWatt(const HpE: double): double;
function HpMetricToWatt(const HpM: double): double;
function MsToKnot(const ms: double): double;
function WattToHpElectric(const W: double): double;
function WattToHpMetric(const W: double): double;

implementation

uses
  SysUtils, JclResources, JclMath;

//--------------------------------------------------------------------------------------------------

function HowAOneLinerCanBiteYou(const Step, Max: Longint): Longint;
begin
  Result := MakePercentage(Step, Max);
end;

function MakePercentage(const Step, Max: Longint): Longint;
begin
  Assert(Max <> 0, 'must <>0');
  Result := Round((Step * 100.0) / Max);
end;

//--------------------------------------------------------------------------------------------------

function KelvinToFahrenheit(const T: double): double;
begin
  Result := CelsiusToFahrenheit(T - KelvinFreezingPoint);
end;

//--------------------------------------------------------------------------------------------------

function FahrenheitToKelvin(const T: double): double;
begin
  Result := FahrenheitToCelsius(T) + KelvinFreezingPoint;
end;

//--------------------------------------------------------------------------------------------------

function CelsiusToKelvin(const T: double): double;
begin
  Result := T + KelvinFreezingPoint;
end;

//--------------------------------------------------------------------------------------------------

function KelvinToCelsius(const T: double): double;
begin
  Result := T - KelvinFreezingPoint;
end;

//--------------------------------------------------------------------------------------------------

function CelsiusToFahrenheit(const T: double): double;
begin
  Result := (((FahrenheitBoilingPoint-FahrenheitFreezingPoint) /
    CelsiusBoilingPoint) * T) + FahrenheitFreezingPoint;
end;

//--------------------------------------------------------------------------------------------------

function FahrenheitToCelsius(const T: double): double;
begin
  Result := (CelsiusBoilingPoint /
    (FahrenheitBoilingPoint-FahrenheitFreezingPoint)) *
    (T - FahrenheitFreezingPoint);
end;

//==================================================================================================
// Angle conversion
//==================================================================================================

function CycleToDeg(const Cycles: double): double;
begin
  Result := Cycles * DegPerCycle;
end;

//--------------------------------------------------------------------------------------------------

function CycleToGrad(const Cycles: double): double;
begin
  Result := Cycles * GradPerCycle;
end;

//--------------------------------------------------------------------------------------------------

function CycleToRad(const Cycles: double): double;
begin
  Result := Cycles * RadPerCycle;
end;

//--------------------------------------------------------------------------------------------------

function DegToGrad(const Degrees: double): double;
begin
  Result := Degrees * GradPerDeg;
end;

//--------------------------------------------------------------------------------------------------

function DegToCycle(const Degrees: double): double;
begin
  Result := Degrees * CyclePerDeg;
end;

//--------------------------------------------------------------------------------------------------

function DegToRad(const Degrees: double): double;
begin
  Result := Degrees * RadPerDeg;
end;

//--------------------------------------------------------------------------------------------------

function GradToCycle(const Grads: double): double;
begin
  Result := Grads * CyclePerGrad;
end;

//--------------------------------------------------------------------------------------------------

function GradToDeg(const Grads: double): double;
begin
  Result := Grads * DegPerGrad;
end;

//--------------------------------------------------------------------------------------------------

function GradToRad(const Grads: double): double;
begin
  Result := Grads * RadPerGrad;
end;

//--------------------------------------------------------------------------------------------------

function RadToCycle(const Radians: double): double;
begin
  Result := Radians * CyclePerRad;
end;

//--------------------------------------------------------------------------------------------------

function RadToDeg(const Radians: double): double;
begin
  Result := Radians * DegPerRad;
end;

//--------------------------------------------------------------------------------------------------

function RadToGrad(const Radians: double): double;
begin
  Result := Radians * GradPerRad;
end;

//--------------------------------------------------------------------------------------------------

function DmsToDeg(const D, M: Integer; const S: double): double;
begin
  //DomainCheck((M < 0) or (M > 60) or (S < 0.0) or (S > 60.0));
  Result := Abs(D) + M * DegPerArcMinute + S * DegPerArcSecond;
  if D < 0 then
    Result := -Result;
end;

//--------------------------------------------------------------------------------------------------

function DmsToRad(const D, M: Integer; const S: double): double;
begin
  Result := DegToRad(DmsToDeg(D, M, S));
end;

//--------------------------------------------------------------------------------------------------

procedure DegToDms(const Degrees: double; out D, M: Integer; out S: double);
var
  DD, MM: double;
begin
  DD := Abs(Degrees);
  MM := Frac(DD) * ArcMinutesPerDeg;
  D := Trunc(DD);
  M := Trunc(MM);
  S := Frac(MM) * ArcSecondsPerArcMinute;
  if Degrees < 0 then
    D := -D;
end;

//--------------------------------------------------------------------------------------------------

function DegToDmsStr(const Degrees: double; const SecondPrecision: Cardinal): string;
var
  D, M: Integer;
  S: double;
begin
  DegToDMS(Degrees, D, M, S);
  Result := Format('%d° %d'' %.*f"', [D, M, SecondPrecision, S]);
end;

//==================================================================================================
// Coordinate conversion
//==================================================================================================

procedure CartesianToCylinder(const X, Y, Z: double; out R, Phi, Zeta: double);
begin
  Zeta := Z;
  CartesianToPolar(X, Y, R, Phi);
end;

//--------------------------------------------------------------------------------------------------

procedure CartesianToPolar(const X, Y: double; out R, Phi: double);
begin
  R := Sqrt(Sqr(X) + Sqr(Y));
  Phi := ArcTan2(Y, X);
  if Phi < 0 then
    Phi := Phi + TwoPi;
end;

//--------------------------------------------------------------------------------------------------

procedure CartesianToSpheric(const X, Y, Z: double; out Rho, Phi, Theta: double);
begin
  Rho := Sqrt(X*X+Y*Y+Z*Z);
  Phi := ArcTan2(Y, X);
  if Phi < 0 then
    Phi := Phi + TwoPi;
  Theta := 0;
  if Rho > 0 then
    Theta := ArcCos(Z/Rho);
end;

//--------------------------------------------------------------------------------------------------

procedure CylinderToCartesian(const R, Phi, Zeta: double; out X, Y, Z: double);
var
  Sine, CoSine: extended;
begin
  SinCos(Phi, Sine, Cosine);
  X := R * CoSine;
  Y := R * Sine;
  Z := Zeta;
end;

//--------------------------------------------------------------------------------------------------

procedure PolarToCartesian(const R, Phi: double; out X, Y: double);
var
  Sine, CoSine: extended;
begin
  SinCos(Phi, Sine, CoSine);
  X := R * CoSine;
  Y := R * Sine;
end;

//--------------------------------------------------------------------------------------------------

procedure SphericToCartesian(const Rho, Theta, Phi: double; out X, Y, Z: double);
var
  SineTheta, CoSineTheta: extended;
  SinePhi, CoSinePhi: extended;
begin
  SinCos(Theta, SineTheta, CoSineTheta);
  SinCos(Phi, SinePhi, CoSinePhi);
  X := Rho * SineTheta * CoSinePhi;
  Y := Rho * SineTheta * SinePhi;
  Z := Rho * CoSineTheta;
end;

//==================================================================================================
// Length conversion
//==================================================================================================

function CmToInch(const Cm: double): double;
begin
  Result := Cm / 2.54;
end;

//--------------------------------------------------------------------------------------------------

function InchToCm(const Inch: double): double;
begin
  Result := Inch * 2.54;
end;

//--------------------------------------------------------------------------------------------------

function FeetToMetre(const Feet: double): double;
begin
  Result := Feet * 0.3048;
end;

//--------------------------------------------------------------------------------------------------

function MetreToFeet(const Metre: double): double;
begin
  Result := Metre / 0.3048;
end;

//--------------------------------------------------------------------------------------------------

function YardToMetre(const Yard: double): double;
begin
  Result := Yard * 0.9144;
end;

//--------------------------------------------------------------------------------------------------

function MetreToYard(const Metre: double): double;
begin
  Result := Metre / 0.9144;
end;

//--------------------------------------------------------------------------------------------------

function NmToKm(const Nm: double): double;
begin
  Result := Nm * 1.852;
end;

//--------------------------------------------------------------------------------------------------

function KmToNm(const Km: double): double;
begin
  Result := Km / 1.852;
end;

//--------------------------------------------------------------------------------------------------

function KmToSm(const Km: double): double;
begin
  Result := Km / 1.609344;
end;

//--------------------------------------------------------------------------------------------------

function SmToKm(const Sm: double): double;
begin
  Result := Sm * 1.609344;
end;

//==================================================================================================
// Volume conversion
//==================================================================================================

function LitreToGalUs(const Litre: double): double;
begin
  Result := Litre / 3.785411784;
end;

//--------------------------------------------------------------------------------------------------

function GalUsToLitre(const GalUs: double): double;
begin
  Result := GalUs * 3.785411784;
end;

//--------------------------------------------------------------------------------------------------

function GalUsToGalCan(const GalUs: double): double;
begin
  Result := GalUs / 1.2009499255;
end;

//--------------------------------------------------------------------------------------------------

function GalCanToGalUs(const GalCan: double): double;
begin
  Result := GalCan * 1.2009499255;
end;

//--------------------------------------------------------------------------------------------------

function GalUsToGalUk(const GalUs: double): double;
begin
  Result := GalUs / 1.20095045385;
end;

//--------------------------------------------------------------------------------------------------

function GalUkToGalUs(const GalUk: double): double;
begin
  Result := GalUk * 1.20095045385;
end;

//--------------------------------------------------------------------------------------------------

function LitreToGalCan(const Litre: double): double;
begin
  Result := Litre / 4.54609;
end;

//--------------------------------------------------------------------------------------------------

function GalCanToLitre(const GalCan: double): double;
begin
  Result := GalCan * 4.54609;
end;

//--------------------------------------------------------------------------------------------------

function LitreToGalUk(const Litre: double): double;
begin
  Result := Litre / 4.54609;
end;

//--------------------------------------------------------------------------------------------------

function GalUkToLitre(const GalUk: double): double;
begin
  Result := GalUk * 4.54609;
end;

//==================================================================================================
// Mass conversion
//==================================================================================================

function KgToLb(const Kg: double): double;
begin
  Result := Kg / 0.45359237;
end;

//--------------------------------------------------------------------------------------------------

function LbToKg(const Lb: double): double;
begin
  Result := Lb * 0.45359237;
end;

//--------------------------------------------------------------------------------------------------

function KgToOz(const Kg: double): double;
begin
  Result := Kg * 35.2739619496;
end;

//--------------------------------------------------------------------------------------------------

function OzToKg(const Oz: double): double;
begin
  Result := Oz / 35.2739619496;
end;

//--------------------------------------------------------------------------------------------------

function QrUsToKg(const Qr: double) : double;
begin
  Result := Qr * 11.34;
end;

//--------------------------------------------------------------------------------------------------

function QrUkToKg(const Qr: double) : double;
begin
  Result := Qr * 12.7;
end;

//--------------------------------------------------------------------------------------------------

function KgToQrUs(const Kg: double) : double;
begin
  Result := Kg / 11.34;
end;

//--------------------------------------------------------------------------------------------------

function KgToQrUk(const Kg: double) : double;
begin
  Result := Kg / 12.7;
end;

//--------------------------------------------------------------------------------------------------

function CwtUsToKg(const Cwt: double) : double;
begin
  Result := Cwt * 45.35924;
end;

//--------------------------------------------------------------------------------------------------

function CwtUkToKg(const Cwt: double) : double;
begin
  Result := Cwt * 50.80235;
end;

//--------------------------------------------------------------------------------------------------

function KgToCwtUs(const Kg: double) : double;
begin
  Result := Kg / 45.35924;
end;

//--------------------------------------------------------------------------------------------------

function KgToCwtUk(const Kg: double) : double;
begin
  Result := Kg / 50.80235;
end;

//--------------------------------------------------------------------------------------------------

function LtonToKg(const Lton: double) : double;
begin
  Result := Lton * 1016.047;
end;

//--------------------------------------------------------------------------------------------------

function StonToKg(const Ston: double) : double;
begin
  Result := Ston * 907.1847;
end;

//--------------------------------------------------------------------------------------------------

function KgToLton(const Kg: double) : double;
begin
  Result := Kg / 1016.047;
end;

//--------------------------------------------------------------------------------------------------

function KgToSton(const Kg: double) : double;
begin
  Result := Kg / 907.1847;
end;

//--------------------------------------------------------------------------------------------------

function KgToKarat(const Kg: double) : double;
begin
  Result := Kg / 0.0002;
end;

//--------------------------------------------------------------------------------------------------

function KaratToKg(const Karat: double) : double;
begin
  Result := Karat * 0.0002;
end;


//==================================================================================================
// Pressure conversion
//==================================================================================================

function PascalToBar(const Pa: double): double;
begin
  Result := Pa / 100000.0;
end;

//--------------------------------------------------------------------------------------------------

function PascalToAt(const Pa: double): double;
begin
  Result := Pa / (9.80665 * 10000.0);
end;

//--------------------------------------------------------------------------------------------------

function PascalToTorr(const Pa: double): double;
begin
  Result := Pa / 133.3224;
end;

//--------------------------------------------------------------------------------------------------

function BarToPascal(const Bar: double): double;
begin
  Result := Bar * 100000.0;
end;

//--------------------------------------------------------------------------------------------------

function AtToPascal(const At: double): double;
begin
  Result := At * (9.80665 * 10000.0);
end;

//--------------------------------------------------------------------------------------------------

function TorrToPascal(const Torr: double): double;
begin
  Result := Torr * 133.3224;
end;

//==================================================================================================
// Other conversion
//==================================================================================================

function KnotToMs(const Knot: double): double;
begin
  Result := Knot * 0.514444444444;
end;

//--------------------------------------------------------------------------------------------------

function HpElectricToWatt(const HpE: double): double;
begin
  Result := HpE * 746.0;
end;

//--------------------------------------------------------------------------------------------------

function HpMetricToWatt(const HpM: double): double;
begin
  Result := HpM * 735.4988;
end;

//--------------------------------------------------------------------------------------------------

function MsToKnot(const ms: double): double;
begin
  Result := ms / 0.514444444444;
end;

//--------------------------------------------------------------------------------------------------

function WattToHpElectric(const W: double): double;
begin
  Result := W / 746.0;
end;

//--------------------------------------------------------------------------------------------------

function WattToHpMetric(const W: double): double;
begin
  Result := W / 735.4988;
end;

//--------------------------------------------------------------------------------------------------

{var  maxy: smallint;
begin
 maxy:= 3;
 println('conversion utils tester');
 Assert(Maxy <> 0, 'input must <> 0');
 Assert2(Maxy <> 0, 'input must <> 0');

 writeln(floattostr(kmtonm(23.3)))
 writeln(floattostr(AttoPascal(10.3)))}

end.
