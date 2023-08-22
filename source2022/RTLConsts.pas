{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2007 CodeGear            }
{                                                       }
{*******************************************************}

unit RTLConsts;

interface

resourcestring
  SAncestorNotFound = 'Ancestor for ''%s'' not found';
  SAssignError = 'Cannot assign a %s to a %s';
  SBitsIndexError = 'Bits index out of range';
  SBucketListLocked = 'List is locked during an active ForEach';
  SCantWriteResourceStreamError = 'Can''t write to a read-only resource stream';
  SCharExpected = '''''%s'''' expected';
  SCheckSynchronizeError = 'CheckSynchronize called from thread $%x, which is NOT the main thread';
  SClassNotFound = 'Class %s not found';
  SDelimiterQuoteCharError = 'Delimiter and QuoteChar properties cannot have the same value';
  SDuplicateClass = 'A class named %s already exists';
  SDuplicateItem = 'List does not allow duplicates ($0%x)';
  SDuplicateName = 'A component named %s already exists';
  SDuplicateString = 'String list does not allow duplicates';
  SFCreateError = 'Cannot create file %s';
  SFCreateErrorEx = 'Cannot create file "%s". %s';
  SFixedColTooBig = 'Fixed column count must be less than column count';
  SFixedRowTooBig = 'Fixed row count must be less than row count';
  SFOpenError = 'Cannot open file %s';
  SFOpenErrorEx = 'Cannot open file "%s". %s';
  SGridTooLarge = 'Grid too large for operation';
  SIdentifierExpected = 'Identifier expected';
  SIndexOutOfRange = 'Grid index out of range';
  SIniFileWriteError = 'Unable to write to %s';
  SInvalidActionCreation = 'Invalid action creation';
  SInvalidActionEnumeration = 'Invalid action enumeration';
  SInvalidActionRegistration = 'Invalid action registration';
  SInvalidActionUnregistration = 'Invalid action unregistration';
  SInvalidBinary = 'Invalid binary value';
  SInvalidFileName = 'Invalid file name - %s';
  SInvalidImage = 'Invalid stream format';
  SInvalidMask = '''%s'' is an invalid mask at (%d)';
  SInvalidName = '''''%s'''' is not a valid component name';
  SInvalidProperty = 'Invalid property value';
  SInvalidPropertyElement = 'Invalid property element: %s';
  SInvalidPropertyPath = 'Invalid property path';
  SInvalidPropertyType = 'Invalid property type: %s';
  SInvalidPropertyValue = 'Invalid property value';
  SInvalidRegType = 'Invalid data type for ''%s''';
  SInvalidString = 'Invalid string constant';
  SInvalidStringGridOp = 'Cannot insert or delete rows from grid';
  SItemNotFound = 'Item not found ($0%x)';
  SLineTooLong = 'Line too long';
  SListCapacityError = 'List capacity out of bounds (%d)';
  SListCountError = 'List count out of bounds (%d)';
  SListIndexError = 'List index out of bounds (%d)';
  SMaskErr = 'Invalid input value';
  SMaskEditErr = 'Invalid input value.  Use escape key to abandon changes';
  SMemoryStreamError = 'Out of memory while expanding memory stream';
  SNoComSupport = '%s has not been registered as a COM class';
  SNotPrinting = 'Printer is not currently printing';
  SNumberExpected = 'Number expected';
  SParseError = '%s on line %d';
  SComponentNameTooLong = 'Component name ''%s'' exceeds 64 character limit';
  SPropertyException = 'Error reading %s%s%s: %s';
  SPrinting = 'Printing in progress';
  SReadError = 'Stream read error';
  SReadOnlyProperty = 'Property is read-only';
  SRegCreateFailed = 'Failed to create key %s';
  SRegGetDataFailed = 'Failed to get data for ''%s''';
  SRegisterError = 'Invalid component registration';
  SRegSetDataFailed = 'Failed to set data for ''%s''';
  SResNotFound = 'Resource %s not found';
  SSeekNotImplemented = '%s.Seek not implemented';
  SSortedListError = 'Operation not allowed on sorted list';
  SStringExpected = 'String expected';
  SSymbolExpected = '%s expected';
  STooManyDeleted = 'Too many rows or columns deleted';
  SUnknownGroup = '%s not in a class registration group';
  SUnknownProperty = 'Property %s does not exist';
  SWriteError = 'Stream write error';
  SStreamSetSize = 'Error setting stream size';
  SThreadCreateError = 'Thread creation error: %s';
  SThreadError = 'Thread Error: %s (%d)';

  SInvalidDateDay = '(%d, %d) is not a valid DateDay pair';
  SInvalidDateWeek = '(%d, %d, %d) is not a valid DateWeek triplet';
  SInvalidDateMonthWeek = '(%d, %d, %d, %d) is not a valid DateMonthWeek quad';
  SInvalidDayOfWeekInMonth = '(%d, %d, %d, %d) is not a valid DayOfWeekInMonth quad';
  SInvalidJulianDate = '%f Julian cannot be represented as a DateTime';
  SMissingDateTimeField = '?';

  SConvIncompatibleTypes2 = 'Incompatible conversion types [%s, %s]';
  SConvIncompatibleTypes3 = 'Incompatible conversion types [%s, %s, %s]';
  SConvIncompatibleTypes4 = 'Incompatible conversion types [%s - %s, %s - %s]';
  SConvUnknownType = 'Unknown conversion type %s';
  SConvDuplicateType = 'Conversion type (%s) already registered in %s';
  SConvUnknownFamily = 'Unknown conversion family %s';
  SConvDuplicateFamily = 'Conversion family (%s) already registered';
  SConvUnknownDescription = '[$%.8x]' deprecated; // no longer used
  SConvUnknownDescriptionWithPrefix = '[%s%.8x]';
  SConvIllegalType = 'Illegal type';
  SConvIllegalFamily = 'Illegal family';
  SConvFactorZero = '%s has a factor of zero';
  SConvStrParseError = 'Could not parse %s';
  SFailedToCallConstructor = 'TStrings descendant %s failed to call inherited constructor';

  sWindowsSocketError = 'Windows socket error: %s (%d), on API ''%s''';
  sAsyncSocketError = 'Asynchronous socket error %d';
  sNoAddress = 'No address specified';
  sCannotListenOnOpen = 'Can''t listen on an open socket';
  sCannotCreateSocket = 'Can''t create new socket';
  sSocketAlreadyOpen = 'Socket already open';
  sCantChangeWhileActive = 'Can''t change value while socket is active';
  sSocketMustBeBlocking = 'Socket must be in blocking mode';
  sSocketIOError = '%s error %d, %s';
  sSocketRead = 'Read';
  sSocketWrite = 'Write';

  SCmplxCouldNotParseImaginary = 'Could not parse imaginary portion';
  SCmplxCouldNotParseSymbol = 'Could not parse required ''%s'' symbol';
  SCmplxCouldNotParsePlus = 'Could not parse required ''+'' (or ''-'') symbol';
  SCmplxCouldNotParseReal = 'Could not parse real portion';
  SCmplxUnexpectedEOS = 'Unexpected end of string [%s]';
  SCmplxUnexpectedChars = 'Unexpected characters';
  SCmplxErrorSuffix = '%s [%s<?>%s]';

  hNoSystem = 'No Help Manager installed.';
  hNoTopics = 'No topic-based Help installed.';
  hNoContext = 'No context-sensitive Help installed.';
  hNothingFound = 'No help found for "%s"';
  hNoTableOfContents = 'No Table of Contents found.';

  { ************************************************************************* }
  { Distance's family type }
  SDistanceDescription = 'Distance';

  { Distance's various conversion types }
  SMicromicronsDescription = 'Micromicrons';
  SAngstromsDescription = 'Angstroms';
  SMillimicronsDescription = 'Millimicrons';
  SMicronsDescription = 'Microns';
  SMillimetersDescription = 'Millimeters';
  SCentimetersDescription = 'Centimeters';
  SDecimetersDescription = 'Decimeters';
  SMetersDescription = 'Meters';
  SDecametersDescription = 'Decameters';
  SHectometersDescription = 'Hectometers';
  SKilometersDescription = 'Kilometers';
  SMegametersDescription = 'Megameters';
  SGigametersDescription = 'Gigameters';
  SInchesDescription = 'Inches';
  SFeetDescription = 'Feet';
  SYardsDescription = 'Yards';
  SMilesDescription = 'Miles';
  SNauticalMilesDescription = 'NauticalMiles';
  SAstronomicalUnitsDescription = 'AstronomicalUnits';
  SLightYearsDescription = 'LightYears';
  SParsecsDescription = 'Parsecs';
  SCubitsDescription = 'Cubits';
  SFathomsDescription = 'Fathoms';
  SFurlongsDescription = 'Furlongs';
  SHandsDescription = 'Hands';
  SPacesDescription = 'Paces';
  SRodsDescription = 'Rods';
  SChainsDescription = 'Chains';
  SLinksDescription = 'Links';
  SPicasDescription = 'Picas';
  SPointsDescription = 'Points';

  { ************************************************************************* }
  { Area's family type }
  SAreaDescription = 'Area';

  { Area's various conversion types }
  SSquareMillimetersDescription = 'SquareMillimeters';
  SSquareCentimetersDescription = 'SquareCentimeters';
  SSquareDecimetersDescription = 'SquareDecimeters';
  SSquareMetersDescription = 'SquareMeters';
  SSquareDecametersDescription = 'SquareDecameters';
  SSquareHectometersDescription = 'SquareHectometers';
  SSquareKilometersDescription = 'SquareKilometers';
  SSquareInchesDescription = 'SquareInches';
  SSquareFeetDescription = 'SquareFeet';
  SSquareYardsDescription = 'SquareYards';
  SSquareMilesDescription = 'SquareMiles';
  SAcresDescription = 'Acres';
  SCentaresDescription = 'Centares';
  SAresDescription = 'Ares';
  SHectaresDescription = 'Hectares';
  SSquareRodsDescription = 'SquareRods';

  { ************************************************************************* }
  { Volume's family type }
  SVolumeDescription = 'Volume';

  { Volume's various conversion types }
  SCubicMillimetersDescription = 'CubicMillimeters';
  SCubicCentimetersDescription = 'CubicCentimeters';
  SCubicDecimetersDescription = 'CubicDecimeters';
  SCubicMetersDescription = 'CubicMeters';
  SCubicDecametersDescription = 'CubicDecameters';
  SCubicHectometersDescription = 'CubicHectometers';
  SCubicKilometersDescription = 'CubicKilometers';
  SCubicInchesDescription = 'CubicInches';
  SCubicFeetDescription = 'CubicFeet';
  SCubicYardsDescription = 'CubicYards';
  SCubicMilesDescription = 'CubicMiles';
  SMilliLitersDescription = 'MilliLiters';
  SCentiLitersDescription = 'CentiLiters';
  SDeciLitersDescription = 'DeciLiters';
  SLitersDescription = 'Liters';
  SDecaLitersDescription = 'DecaLiters';
  SHectoLitersDescription = 'HectoLiters';
  SKiloLitersDescription = 'KiloLiters';
  SAcreFeetDescription = 'AcreFeet';
  SAcreInchesDescription = 'AcreInches';
  SCordsDescription = 'Cords';
  SCordFeetDescription = 'CordFeet';
  SDecisteresDescription = 'Decisteres';
  SSteresDescription = 'Steres';
  SDecasteresDescription = 'Decasteres';

  { American Fluid Units }
  SFluidGallonsDescription = 'FluidGallons';
  SFluidQuartsDescription = 'FluidQuarts';
  SFluidPintsDescription = 'FluidPints';
  SFluidCupsDescription = 'FluidCups';
  SFluidGillsDescription = 'FluidGills';
  SFluidOuncesDescription = 'FluidOunces';
  SFluidTablespoonsDescription = 'FluidTablespoons';
  SFluidTeaspoonsDescription = 'FluidTeaspoons';

  { American Dry Units }
  SDryGallonsDescription = 'DryGallons';
  SDryQuartsDescription = 'DryQuarts';
  SDryPintsDescription = 'DryPints';
  SDryPecksDescription = 'DryPecks';
  SDryBucketsDescription = 'DryBuckets';
  SDryBushelsDescription = 'DryBushels';

  { English Imperial Fluid/Dry Units }
  SUKGallonsDescription = 'UKGallons';
  SUKPottlesDescription = 'UKPottle';
  SUKQuartsDescription = 'UKQuarts';
  SUKPintsDescription = 'UKPints';
  SUKGillsDescription = 'UKGill';
  SUKOuncesDescription = 'UKOunces';
  SUKPecksDescription = 'UKPecks';
  SUKBucketsDescription = 'UKBuckets';
  SUKBushelsDescription = 'UKBushels';

  { ************************************************************************* }
  { Mass's family type }
  SMassDescription = 'Mass';

  { Mass's various conversion types }
  SNanogramsDescription = 'Nanograms';
  SMicrogramsDescription = 'Micrograms';
  SMilligramsDescription = 'Milligrams';
  SCentigramsDescription = 'Centigrams';
  SDecigramsDescription = 'Decigrams';
  SGramsDescription = 'Grams';
  SDecagramsDescription = 'Decagrams';
  SHectogramsDescription = 'Hectograms';
  SKilogramsDescription = 'Kilograms';
  SMetricTonsDescription = 'MetricTons';
  SDramsDescription = 'Drams';
  SGrainsDescription = 'Grains';
  STonsDescription = 'Tons';
  SLongTonsDescription = 'LongTons';
  SOuncesDescription = 'Ounces';
  SPoundsDescription = 'Pounds';
  SStonesDescription = 'Stones';

  { ************************************************************************* }
  { Temperature's family type }
  STemperatureDescription = 'Temperature';

  { Temperature's various conversion types }
  SCelsiusDescription = 'Celsius';
  SKelvinDescription = 'Kelvin';
  SFahrenheitDescription = 'Fahrenheit';
  SRankineDescription = 'Rankine';
  SReaumurDescription = 'Reaumur';

  { ************************************************************************* }
  { Time's family type }
  STimeDescription = 'Time';

  { Time's various conversion types }
  SMilliSecondsDescription = 'MilliSeconds';
  SSecondsDescription = 'Seconds';
  SMinutesDescription = 'Minutes';
  SHoursDescription = 'Hours';
  SDaysDescription = 'Days';
  SWeeksDescription = 'Weeks';
  SFortnightsDescription = 'Fortnights';
  SMonthsDescription = 'Months';
  SYearsDescription = 'Years';
  SDecadesDescription = 'Decades';
  SCenturiesDescription = 'Centuries';
  SMillenniaDescription = 'Millennia';
  SDateTimeDescription = 'DateTime';
  SJulianDateDescription = 'JulianDate';
  SModifiedJulianDateDescription = 'ModifiedJulianDate';

  // The following strings are now found in SysConsts.pas
  SInvalidDate = '''''%s'''' is not a valid date' deprecated;
  SInvalidDateTime = '''''%s'''' is not a valid date and time' deprecated;
  SInvalidInteger = '''''%s'''' is not a valid integer value' deprecated;
  SInvalidTime = '''''%s'''' is not a valid time' deprecated;
  STimeEncodeError = 'Invalid argument to time encode' deprecated;

implementation

end.
