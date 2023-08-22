{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

{*******************************************************}
{       Standard conversions types                      }
{*******************************************************}

{ ***************************************************************************
  Physical, Fluidic, Thermal, and Temporal conversion units

  The metric units and prefixes in this unit follow the various
  SI/NIST standards (http://physics.nist.gov/cuu/Units/index.html and
  http://www.bipm.fr/enus/3_SI).  We have decided to use the Deca instead
  of Deka to represent 10 of something.

  Great conversion sites
    http://www.ex.ac.uk/cimt/dictunit/dictunit.htm      !! GREAT SITE !!
    http://www.unc.edu/~rowlett/units/index.html        !! GREAT SITE !!
    http://www.footrule.com                             !! GREAT SITE !!
    http://www.sciencemadesimple.com/conversions.html
    http://www.numberexchange.net/Convert/Weight.html
    http://students.washington.edu/kyle/temp.html
    http://www.convertit.com


  ***************************************************************************
  References:
  [1]  NIST: Mendenhall Order of 1893
  [2]  http://ds.dial.pipex.com/nib/metric.htm
  [3]  http://www.footrule.com
  [4]  NIST (http://physics.nist.gov/cuu/Units/outside.html)
  [5]  NIST (http://physics.nist.gov/cuu/Units/meter.html)
  [6]  Accepted best guess, but nobody really knows
  [7]  http://www.ex.ac.uk/cimt/dictunit/dictunit.htm

}

unit StdConvs;

interface

uses
  SysUtils, ConvUtils;

var
  { ************************************************************************* }
  { Distance Conversion Units }
  { basic unit of measurement is meters }
  cbDistance: TConvFamily;

  duMicromicrons: TConvType;
  duAngstroms: TConvType;
  duMillimicrons: TConvType;
  duMicrons: TConvType;
  duMillimeters: TConvType;
  duCentimeters: TConvType;
  duDecimeters: TConvType;
  duMeters: TConvType;
  duDecameters: TConvType;
  duHectometers: TConvType;
  duKilometers: TConvType;
  duMegameters: TConvType;
  duGigameters: TConvType;
  duInches: TConvType;
  duFeet: TConvType;
  duYards: TConvType;
  duMiles: TConvType;
  duNauticalMiles: TConvType;
  duAstronomicalUnits: TConvType;
  duLightYears: TConvType;
  duParsecs: TConvType;
  duCubits: TConvType;
  duFathoms: TConvType;
  duFurlongs: TConvType;
  duHands: TConvType;
  duPaces: TConvType;
  duRods: TConvType;
  duChains: TConvType;
  duLinks: TConvType;
  duPicas: TConvType;
  duPoints: TConvType;

  { ************************************************************************* }
  { Area Conversion Units }
  { basic unit of measurement is square meters }
  cbArea: TConvFamily;

  auSquareMillimeters: TConvType;
  auSquareCentimeters: TConvType;
  auSquareDecimeters: TConvType;
  auSquareMeters: TConvType;
  auSquareDecameters: TConvType;
  auSquareHectometers: TConvType;
  auSquareKilometers: TConvType;
  auSquareInches: TConvType;
  auSquareFeet: TConvType;
  auSquareYards: TConvType;
  auSquareMiles: TConvType;
  auAcres: TConvType;
  auCentares: TConvType;
  auAres: TConvType;
  auHectares: TConvType;
  auSquareRods: TConvType;

  { ************************************************************************* }
  { Volume Conversion Units }
  { basic unit of measurement is cubic meters }
  cbVolume: TConvFamily;

  vuCubicMillimeters: TConvType;
  vuCubicCentimeters: TConvType;
  vuCubicDecimeters: TConvType;
  vuCubicMeters: TConvType;
  vuCubicDecameters: TConvType;
  vuCubicHectometers: TConvType;
  vuCubicKilometers: TConvType;
  vuCubicInches: TConvType;
  vuCubicFeet: TConvType;
  vuCubicYards: TConvType;
  vuCubicMiles: TConvType;
  vuMilliLiters: TConvType;
  vuCentiLiters: TConvType;
  vuDeciLiters: TConvType;
  vuLiters: TConvType;
  vuDecaLiters: TConvType;
  vuHectoLiters: TConvType;
  vuKiloLiters: TConvType;
  vuAcreFeet: TConvType;
  vuAcreInches: TConvType;
  vuCords: TConvType;
  vuCordFeet: TConvType;
  vuDecisteres: TConvType;
  vuSteres: TConvType;
  vuDecasteres: TConvType;

  vuFluidGallons: TConvType; { American Fluid Units }
  vuFluidQuarts: TConvType;
  vuFluidPints: TConvType;
  vuFluidCups: TConvType;
  vuFluidGills: TConvType;
  vuFluidOunces: TConvType;
  vuFluidTablespoons: TConvType;
  vuFluidTeaspoons: TConvType;

  vuDryGallons: TConvType; { American Dry Units }
  vuDryQuarts: TConvType;
  vuDryPints: TConvType;
  vuDryPecks: TConvType;
  vuDryBuckets: TConvType;
  vuDryBushels: TConvType;

  vuUKGallons: TConvType; { English Imperial Fluid/Dry Units }
  vuUKPottles: TConvType;
  vuUKQuarts: TConvType;
  vuUKPints: TConvType;
  vuUKGills: TConvType;
  vuUKOunces: TConvType;
  vuUKPecks: TConvType;
  vuUKBuckets: TConvType;
  vuUKBushels: TConvType;

  { ************************************************************************* }
  { Mass Conversion Units }
  { basic unit of measurement is grams }
  cbMass: TConvFamily;

  muNanograms: TConvType;
  muMicrograms: TConvType;
  muMilligrams: TConvType;
  muCentigrams: TConvType;
  muDecigrams: TConvType;
  muGrams: TConvType;
  muDecagrams: TConvType;
  muHectograms: TConvType;
  muKilograms: TConvType;
  muMetricTons: TConvType;
  muDrams: TConvType; // Avoirdupois Units
  muGrains: TConvType;
  muLongTons: TConvType;
  muTons: TConvType;
  muOunces: TConvType;
  muPounds: TConvType;
  muStones: TConvType;

  { ************************************************************************* }
  { Temperature Conversion Units }
  { basic unit of measurement is celsius }
  cbTemperature: TConvFamily;

  tuCelsius: TConvType;
  tuKelvin: TConvType;
  tuFahrenheit: TConvType;
  tuRankine: TConvType;
  tuReaumur: TConvType;

  { ************************************************************************* }
  { Time Conversion Units }
  { basic unit of measurement is days (which is also the same as TDateTime) }
  cbTime: TConvFamily;

  tuMilliSeconds: TConvType;
  tuSeconds: TConvType;
  tuMinutes: TConvType;
  tuHours: TConvType;
  tuDays: TConvType;
  tuWeeks: TConvType;
  tuFortnights: TConvType;
  tuMonths: TConvType;
  tuYears: TConvType;
  tuDecades: TConvType;
  tuCenturies: TConvType;
  tuMillennia: TConvType;
  tuDateTime: TConvType;
  tuJulianDate: TConvType;
  tuModifiedJulianDate: TConvType;


{ Constants (and their derivatives) used in this unit }
const
  MetersPerInch = 0.0254; // [1]
  MetersPerFoot = MetersPerInch * 12;
  MetersPerYard = MetersPerFoot * 3;
  MetersPerMile = MetersPerFoot * 5280;
  MetersPerNauticalMiles = 1852;
  MetersPerAstronomicalUnit = 1.49598E11; // [4]
  MetersPerLightSecond = 2.99792458E8; // [5]
  MetersPerLightYear = MetersPerLightSecond * 31556925.9747; // [7]
  MetersPerParsec = MetersPerAstronomicalUnit * 206264.806247096; // 60 * 60 * (180 / Pi)
  MetersPerCubit = 0.4572; // [6][7]
  MetersPerFathom = MetersPerFoot * 6;
  MetersPerFurlong = MetersPerYard * 220;
  MetersPerHand = MetersPerInch * 4;
  MetersPerPace = MetersPerInch * 30;
  MetersPerRod = MetersPerFoot * 16.5;
  MetersPerChain = MetersPerRod * 4;
  MetersPerLink = MetersPerChain / 100;
  MetersPerPoint = MetersPerInch * 0.013837; // [7]
  MetersPerPica = MetersPerPoint * 12;

  SquareMetersPerSquareInch = MetersPerInch * MetersPerInch;
  SquareMetersPerSquareFoot = MetersPerFoot * MetersPerFoot;
  SquareMetersPerSquareYard = MetersPerYard * MetersPerYard;
  SquareMetersPerSquareMile = MetersPerMile * MetersPerMile;
  SquareMetersPerAcre = SquareMetersPerSquareYard * 4840;
  SquareMetersPerSquareRod = MetersPerRod * MetersPerRod;

  CubicMetersPerCubicInch = MetersPerInch * MetersPerInch * MetersPerInch;
  CubicMetersPerCubicFoot = MetersPerFoot * MetersPerFoot * MetersPerFoot;
  CubicMetersPerCubicYard = MetersPerYard * MetersPerYard * MetersPerYard;
  CubicMetersPerCubicMile = MetersPerMile * MetersPerMile * MetersPerMile;
  CubicMetersPerAcreFoot = SquareMetersPerAcre * MetersPerFoot;
  CubicMetersPerAcreInch = SquareMetersPerAcre * MetersPerInch;
  CubicMetersPerCord = CubicMetersPerCubicFoot * 128;
  CubicMetersPerCordFoot = CubicMetersPerCubicFoot * 16;

  CubicMetersPerUSFluidGallon = CubicMetersPerCubicInch * 231; // [2][3][7]
  CubicMetersPerUSFluidQuart = CubicMetersPerUSFluidGallon / 4;
  CubicMetersPerUSFluidPint = CubicMetersPerUSFluidQuart / 2;
  CubicMetersPerUSFluidCup = CubicMetersPerUSFluidPint / 2;
  CubicMetersPerUSFluidGill = CubicMetersPerUSFluidCup / 2;
  CubicMetersPerUSFluidOunce = CubicMetersPerUSFluidCup / 8;
  CubicMetersPerUSFluidTablespoon = CubicMetersPerUSFluidOunce / 2;
  CubicMetersPerUSFluidTeaspoon = CubicMetersPerUSFluidOunce / 6;

  CubicMetersPerUSDryGallon = CubicMetersPerCubicInch * 268.8025; // [7]
  CubicMetersPerUSDryQuart = CubicMetersPerUSDryGallon / 4;
  CubicMetersPerUSDryPint = CubicMetersPerUSDryQuart / 2;
  CubicMetersPerUSDryPeck = CubicMetersPerUSDryGallon * 2;
  CubicMetersPerUSDryBucket = CubicMetersPerUSDryPeck * 2;
  CubicMetersPerUSDryBushel = CubicMetersPerUSDryBucket * 2;

  CubicMetersPerUKGallon = 0.00454609; // [2][7]
  CubicMetersPerUKPottle = CubicMetersPerUKGallon / 2;
  CubicMetersPerUKQuart = CubicMetersPerUKPottle / 2;
  CubicMetersPerUKPint = CubicMetersPerUKQuart / 2;
  CubicMetersPerUKGill = CubicMetersPerUKPint / 4;
  CubicMetersPerUKOunce = CubicMetersPerUKPint / 20;
  CubicMetersPerUKPeck = CubicMetersPerUKGallon * 2;
  CubicMetersPerUKBucket = CubicMetersPerUKPeck * 2;
  CubicMetersPerUKBushel = CubicMetersPerUKBucket * 2;

  GramsPerPound = 453.59237; // [1][7]
  GramsPerDrams = GramsPerPound / 256;
  GramsPerGrains = GramsPerPound / 7000;
  GramsPerTons = GramsPerPound * 2000;
  GramsPerLongTons = GramsPerPound * 2240;
  GramsPerOunces = GramsPerPound / 16;
  GramsPerStones = GramsPerPound * 14;


{ simple temperature conversion }
function FahrenheitToCelsius(const AValue: Double): Double;
function CelsiusToFahrenheit(const AValue: Double): Double;

{ C++ clients should call this routine to ensure the unit is initialized }
procedure InitStdConvs;

implementation

uses
  RTLConsts, DateUtils;

function FahrenheitToCelsius(const AValue: Double): Double;
begin
  Result := ((AValue - 32) * 5) / 9;
end;

function CelsiusToFahrenheit(const AValue: Double): Double;
begin
  Result := ((AValue * 9) / 5) + 32;
end;

function KelvinToCelsius(const AValue: Double): Double;
begin
  Result := AValue - 273.15;
end;

function CelsiusToKelvin(const AValue: Double): Double;
begin
  Result := AValue + 273.15;
end;

function RankineToCelsius(const AValue: Double): Double;
begin
  Result := FahrenheitToCelsius(AValue - 459.67);
end;

function CelsiusToRankine(const AValue: Double): Double;
begin
  Result := CelsiusToFahrenheit(AValue) + 459.67;
end;

function ReaumurToCelsius(const AValue: Double): Double;
begin
  Result := FahrenheitToCelsius(((AValue * 9) / 4) + 32);
end;

function CelsiusToReaumur(const AValue: Double): Double;
begin
  Result := ((CelsiusToFahrenheit(AValue) - 32) * 4) / 9;
end;

function ConvDateTimeToJulianDate(const AValue: Double): Double;
begin
  Result := DateTimeToJulianDate(AValue);
end;

function ConvJulianDateToDateTime(const AValue: Double): Double;
begin
  Result := JulianDateToDateTime(AValue);
end;

function ConvDateTimeToModifiedJulianDate(const AValue: Double): Double;
begin
  Result := DateTimeToModifiedJulianDate(AValue);
end;

function ConvModifiedJulianDateToDateTime(const AValue: Double): Double;
begin
  Result := ModifiedJulianDateToDateTime(AValue);
end;

procedure InitStdConvs;
begin
  { Nothing to do, the implementation will arrange to call 'initialization' }
end;


initialization

  { ************************************************************************* }
  { Distance's family type }
  cbDistance := RegisterConversionFamily(SDistanceDescription);

  { Distance's various conversion types }
  duMicromicrons := RegisterConversionType(cbDistance, SMicromicronsDescription, 1E-12);
  duAngstroms := RegisterConversionType(cbDistance, SAngstromsDescription, 1E-10);
  duMillimicrons := RegisterConversionType(cbDistance, SMillimicronsDescription, 1E-9);
  duMicrons := RegisterConversionType(cbDistance, SMicronsDescription, 1E-6);
  duMillimeters := RegisterConversionType(cbDistance, SMillimetersDescription, 0.001);
  duCentimeters := RegisterConversionType(cbDistance, SCentimetersDescription, 0.01);
  duDecimeters := RegisterConversionType(cbDistance, SDecimetersDescription, 0.1);
  duMeters := RegisterConversionType(cbDistance, SMetersDescription, 1);
  duDecameters := RegisterConversionType(cbDistance, SDecametersDescription, 10);
  duHectometers := RegisterConversionType(cbDistance, SHectometersDescription, 100);
  duKilometers := RegisterConversionType(cbDistance, SKilometersDescription, 1000);
  duMegameters := RegisterConversionType(cbDistance, SMegametersDescription, 1E+6);
  duGigameters := RegisterConversionType(cbDistance, SGigametersDescription, 1E+9);
  duInches := RegisterConversionType(cbDistance, SInchesDescription, MetersPerInch);
  duFeet := RegisterConversionType(cbDistance, SFeetDescription, MetersPerFoot);
  duYards := RegisterConversionType(cbDistance, SYardsDescription, MetersPerYard);
  duMiles := RegisterConversionType(cbDistance, SMilesDescription, MetersPerMile);
  duNauticalMiles := RegisterConversionType(cbDistance, SNauticalMilesDescription, MetersPerNauticalMiles);
  duAstronomicalUnits := RegisterConversionType(cbDistance, SAstronomicalUnitsDescription, MetersPerAstronomicalUnit);
  duLightYears := RegisterConversionType(cbDistance, SLightYearsDescription, MetersPerLightYear);
  duParsecs := RegisterConversionType(cbDistance, SParsecsDescription, MetersPerParsec);
  duCubits := RegisterConversionType(cbDistance, SCubitsDescription, MetersPerCubit);
  duFathoms := RegisterConversionType(cbDistance, SFathomsDescription, MetersPerFathom);
  duFurlongs := RegisterConversionType(cbDistance, SFurlongsDescription, MetersPerFurlong);
  duHands := RegisterConversionType(cbDistance, SHandsDescription, MetersPerHand);
  duPaces := RegisterConversionType(cbDistance, SPacesDescription, MetersPerPace);
  duRods := RegisterConversionType(cbDistance, SRodsDescription, MetersPerRod);
  duChains := RegisterConversionType(cbDistance, SChainsDescription, MetersPerChain);
  duLinks := RegisterConversionType(cbDistance, SLinksDescription, MetersPerLink);
  duPicas := RegisterConversionType(cbDistance, SPicasDescription, MetersPerPica);
  duPoints := RegisterConversionType(cbDistance, SPointsDescription, MetersPerPoint);

  { ************************************************************************* }
  { Area's family type }
  cbArea := RegisterConversionFamily(SAreaDescription);

  { Area's various conversion types }
  auSquareMillimeters := RegisterConversionType(cbArea, SSquareMillimetersDescription, 1E-6);
  auSquareCentimeters := RegisterConversionType(cbArea, SSquareCentimetersDescription, 0.0001);
  auSquareDecimeters := RegisterConversionType(cbArea, SSquareDecimetersDescription, 0.01);
  auSquareMeters := RegisterConversionType(cbArea, SSquareMetersDescription, 1);
  auSquareDecameters := RegisterConversionType(cbArea, SSquareDecametersDescription, 100);
  auSquareHectometers := RegisterConversionType(cbArea, SSquareHectometersDescription, 10000);
  auSquareKilometers := RegisterConversionType(cbArea, SSquareKilometersDescription, 1E+6);
  auSquareInches := RegisterConversionType(cbArea, SSquareInchesDescription, SquareMetersPerSquareInch);
  auSquareFeet := RegisterConversionType(cbArea, SSquareFeetDescription, SquareMetersPerSquareFoot);
  auSquareYards := RegisterConversionType(cbArea, SSquareYardsDescription, SquareMetersPerSquareYard);
  auSquareMiles := RegisterConversionType(cbArea, SSquareMilesDescription, SquareMetersPerSquareMile);
  auAcres := RegisterConversionType(cbArea, SAcresDescription, SquareMetersPerAcre);
  auCentares := RegisterConversionType(cbArea, SCentaresDescription, 1);
  auAres := RegisterConversionType(cbArea, SAresDescription, 100);
  auHectares := RegisterConversionType(cbArea, SHectaresDescription, 10000);
  auSquareRods := RegisterConversionType(cbArea, SSquareRodsDescription, SquareMetersPerSquareRod);

  { ************************************************************************* }
  { Volume's family type }
  cbVolume := RegisterConversionFamily(SVolumeDescription);

  { Volume's various conversion types }
  vuCubicMillimeters := RegisterConversionType(cbVolume, SCubicMillimetersDescription, 1E-9);
  vuCubicCentimeters := RegisterConversionType(cbVolume, SCubicCentimetersDescription, 1E-6);
  vuCubicDecimeters := RegisterConversionType(cbVolume, SCubicDecimetersDescription, 0.001);
  vuCubicMeters := RegisterConversionType(cbVolume, SCubicMetersDescription, 1);
  vuCubicDecameters := RegisterConversionType(cbVolume, SCubicDecametersDescription, 1000);
  vuCubicHectometers := RegisterConversionType(cbVolume, SCubicHectometersDescription, 1E+6);
  vuCubicKilometers := RegisterConversionType(cbVolume, SCubicKilometersDescription, 1E+9);
  vuCubicInches := RegisterConversionType(cbVolume, SCubicInchesDescription, CubicMetersPerCubicInch);
  vuCubicFeet := RegisterConversionType(cbVolume, SCubicFeetDescription, CubicMetersPerCubicFoot);
  vuCubicYards := RegisterConversionType(cbVolume, SCubicYardsDescription, CubicMetersPerCubicYard);
  vuCubicMiles := RegisterConversionType(cbVolume, SCubicMilesDescription, CubicMetersPerCubicMile);
  vuMilliLiters := RegisterConversionType(cbVolume, SMilliLitersDescription, 1E-6);
  vuCentiLiters := RegisterConversionType(cbVolume, SCentiLitersDescription, 1E-5);
  vuDeciLiters := RegisterConversionType(cbVolume, SDeciLitersDescription, 1E-4);
  vuLiters := RegisterConversionType(cbVolume, SLitersDescription, 0.001);
  vuDecaLiters := RegisterConversionType(cbVolume, SDecaLitersDescription, 0.01);
  vuHectoLiters := RegisterConversionType(cbVolume, SHectoLitersDescription, 0.1);
  vuKiloLiters := RegisterConversionType(cbVolume, SKiloLitersDescription, 1);
  vuAcreFeet := RegisterConversionType(cbVolume, SAcreFeetDescription, CubicMetersPerAcreFoot);
  vuAcreInches := RegisterConversionType(cbVolume, SAcreInchesDescription, CubicMetersPerAcreInch);
  vuCords := RegisterConversionType(cbVolume, SCordsDescription, CubicMetersPerCord);
  vuCordFeet := RegisterConversionType(cbVolume, SCordFeetDescription, CubicMetersPerCordFoot);
  vuDecisteres := RegisterConversionType(cbVolume, SDecisteresDescription, 0.1);
  vuSteres := RegisterConversionType(cbVolume, SSteresDescription, 1);
  vuDecasteres := RegisterConversionType(cbVolume, SDecasteresDescription, 10);

  { American Fluid Units }
  vuFluidGallons := RegisterConversionType(cbVolume, SFluidGallonsDescription, CubicMetersPerUSFluidGallon);
  vuFluidQuarts := RegisterConversionType(cbVolume, SFluidQuartsDescription, CubicMetersPerUSFluidQuart);
  vuFluidPints := RegisterConversionType(cbVolume, SFluidPintsDescription, CubicMetersPerUSFluidPint);
  vuFluidCups := RegisterConversionType(cbVolume, SFluidCupsDescription, CubicMetersPerUSFluidCup);
  vuFluidGills := RegisterConversionType(cbVolume, SFluidGillsDescription, CubicMetersPerUSFluidGill);
  vuFluidOunces := RegisterConversionType(cbVolume, SFluidOuncesDescription, CubicMetersPerUSFluidOunce);
  vuFluidTablespoons := RegisterConversionType(cbVolume, SFluidTablespoonsDescription, CubicMetersPerUSFluidTablespoon);
  vuFluidTeaspoons := RegisterConversionType(cbVolume, SFluidTeaspoonsDescription, CubicMetersPerUSFluidTeaspoon);

  { American Dry Units }
  vuDryGallons := RegisterConversionType(cbVolume, SDryGallonsDescription, CubicMetersPerUSDryGallon);
  vuDryQuarts := RegisterConversionType(cbVolume, SDryQuartsDescription, CubicMetersPerUSDryQuart);
  vuDryPints := RegisterConversionType(cbVolume, SDryPintsDescription, CubicMetersPerUSDryPint);
  vuDryPecks := RegisterConversionType(cbVolume, SDryPecksDescription, CubicMetersPerUSDryPeck);
  vuDryBuckets := RegisterConversionType(cbVolume, SDryBucketsDescription, CubicMetersPerUSDryBucket);
  vuDryBushels := RegisterConversionType(cbVolume, SDryBushelsDescription, CubicMetersPerUSDryBushel);

  { English Imperial Fluid/Dry Units }
  vuUKGallons := RegisterConversionType(cbVolume, SUKGallonsDescription, CubicMetersPerUKGallon);
  vuUKPottles := RegisterConversionType(cbVolume, SUKPottlesDescription, CubicMetersPerUKPottle);
  vuUKQuarts := RegisterConversionType(cbVolume, SUKQuartsDescription, CubicMetersPerUKQuart);
  vuUKPints := RegisterConversionType(cbVolume, SUKPintsDescription, CubicMetersPerUKPint);
  vuUKGills := RegisterConversionType(cbVolume, SUKGillsDescription, CubicMetersPerUKGill);
  vuUKOunces := RegisterConversionType(cbVolume, SUKOuncesDescription, CubicMetersPerUKOunce);
  vuUKPecks := RegisterConversionType(cbVolume, SUKPecksDescription, CubicMetersPerUKPeck);
  vuUKBuckets := RegisterConversionType(cbVolume, SUKBucketsDescription, CubicMetersPerUKBucket);
  vuUKBushels := RegisterConversionType(cbVolume, SUKBushelsDescription, CubicMetersPerUKBushel);

  { ************************************************************************* }
  { Mass's family type }
  cbMass := RegisterConversionFamily(SMassDescription);

  { Mass's various conversion types }
  muNanograms := RegisterConversionType(cbMass, SNanogramsDescription, 1E-9);
  muMicrograms := RegisterConversionType(cbMass, SMicrogramsDescription, 1E-6);
  muMilligrams := RegisterConversionType(cbMass, SMilligramsDescription, 0.001);
  muCentigrams := RegisterConversionType(cbMass, SCentigramsDescription, 0.01);
  muDecigrams := RegisterConversionType(cbMass, SDecigramsDescription, 0.1);
  muGrams := RegisterConversionType(cbMass, SGramsDescription, 1);
  muDecagrams := RegisterConversionType(cbMass, SDecagramsDescription, 10);
  muHectograms := RegisterConversionType(cbMass, SHectogramsDescription, 100);
  muKilograms := RegisterConversionType(cbMass, SKilogramsDescription, 1000);
  muMetricTons := RegisterConversionType(cbMass, SMetricTonsDescription, 1E+6);
  muDrams := RegisterConversionType(cbMass, SDramsDescription, GramsPerDrams);
  muGrains := RegisterConversionType(cbMass, SGrainsDescription, GramsPerGrains);
  muTons := RegisterConversionType(cbMass, STonsDescription, GramsPerTons);
  muLongTons := RegisterConversionType(cbMass, SLongTonsDescription, GramsPerLongTons);
  muOunces := RegisterConversionType(cbMass, SOuncesDescription, GramsPerOunces);
  muPounds := RegisterConversionType(cbMass, SPoundsDescription, GramsPerPound);
  muStones := RegisterConversionType(cbMass, SStonesDescription, GramsPerStones);

  { ************************************************************************* }
  { Temperature's family type }
  cbTemperature := RegisterConversionFamily(STemperatureDescription);

  { Temperature's various conversion types }
  tuCelsius := RegisterConversionType(cbTemperature, SCelsiusDescription, 1);
  tuKelvin := RegisterConversionType(cbTemperature, SKelvinDescription,
    KelvinToCelsius, CelsiusToKelvin);
  tuFahrenheit := RegisterConversionType(cbTemperature, SFahrenheitDescription,
    FahrenheitToCelsius, CelsiusToFahrenheit);
  tuRankine := RegisterConversionType(cbTemperature, SRankineDescription,
    RankineToCelsius, CelsiusToRankine);
  tuReaumur := RegisterConversionType(cbTemperature, SReaumurDescription,
    ReaumurToCelsius, CelsiusToReaumur);

  { ************************************************************************* }
  { Time's family type }
  cbTime := RegisterConversionFamily(STimeDescription);

  { Time's various conversion types }
  tuMilliSeconds := RegisterConversionType(cbTime, SMilliSecondsDescription, 1 / MSecsPerDay);
  tuSeconds := RegisterConversionType(cbTime, SSecondsDescription, 1 / SecsPerDay);
  tuMinutes := RegisterConversionType(cbTime, SMinutesDescription, 1 / MinsPerDay);
  tuHours := RegisterConversionType(cbTime, SHoursDescription, 1 / HoursPerDay);
  tuDays := RegisterConversionType(cbTime, SDaysDescription, 1);
  tuWeeks := RegisterConversionType(cbTime, SWeeksDescription, DaysPerWeek);
  tuFortnights := RegisterConversionType(cbTime, SFortnightsDescription, WeeksPerFortnight * DaysPerWeek);
  tuMonths := RegisterConversionType(cbTime, SMonthsDescription, ApproxDaysPerMonth);
  tuYears := RegisterConversionType(cbTime, SYearsDescription, ApproxDaysPerYear);
  tuDecades := RegisterConversionType(cbTime, SDecadesDescription, ApproxDaysPerYear * YearsPerDecade);
  tuCenturies := RegisterConversionType(cbTime, SCenturiesDescription, ApproxDaysPerYear * YearsPerCentury);
  tuMillennia := RegisterConversionType(cbTime, SMillenniaDescription, ApproxDaysPerYear * YearsPerMillennium);
  tuDateTime := RegisterConversionType(cbTime, SDateTimeDescription, 1);
  tuJulianDate := RegisterConversionType(cbTime, SJulianDateDescription,
    ConvJulianDateToDateTime, ConvDateTimeToJulianDate);
  tuModifiedJulianDate := RegisterConversionType(cbTime, SModifiedJulianDateDescription,
    ConvModifiedJulianDateToDateTime, ConvDateTimeToModifiedJulianDate);

finalization

  { Unregister all the conversion types we are responsible for }
  UnregisterConversionFamily(cbDistance);
  UnregisterConversionFamily(cbArea);
  UnregisterConversionFamily(cbVolume);
  UnregisterConversionFamily(cbMass);
  UnregisterConversionFamily(cbTemperature);
  UnregisterConversionFamily(cbTime);
end.
