{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit RTLConsts;

interface

resourcestring
    SAncestorNotFound = 'Vorfahr für '#39'%s'#39' nicht gefunden';
    SAssignError = '%s kann nicht zu %s zugewiesen werden';
    SBitsIndexError = 'Bits-Index außerhalb des zulässigen Bereichs';
    SBucketListLocked = 'Liste ist während eines aktiven ForEach gesperrt';
    SCantWriteResourceStreamError = 'In einen zum Lesen geöffneten Ressourcen-Stream kann nicht geschrieben werden';
    SCharExpected = ''#39''#39'%s'#39''#39' erwartet';
    SCheckSynchronizeError = 'CheckSynchronize wurde vom Thread $%x aufgerufen, der NICHT der Haupt-Thread ist.';
    SClassNotFound = 'Klasse %s nicht gefunden';
    SDelimiterQuoteCharError = 'Die Eigenschaften Delimiter und QuoteChar dürfen nicht denselben Wert besitzen';
    SDuplicateClass = 'Klasse mit der Bezeichnung %s existiert bereits';
    SDuplicateItem = 'Liste gestattet keine doppelten Einträge ($0%x)';
    SDuplicateName = 'Komponente mit der Bezeichnung %s existiert bereits';
    SDuplicateString = 'In der Stringliste sind Duplikate nicht erlaubt';
    SFCreateError = 'Datei %s kann nicht erstellt werden';
    SFCreateErrorEx = 'Datei "%s" kann nicht erstellt werden. %s';
    SFixedColTooBig = 'Die Anzahl fester Spalten muss kleiner sein als die Spaltenanzahl';
    SFixedRowTooBig = 'Die Anzahl fester Zeilen muss kleiner sein als die Zeilenanzahl';
    SFOpenError = 'Datei %s kann nicht geöffnet werden';
    SFOpenErrorEx = 'Datei %s kann nicht geöffnet werden. %s';
    SGridTooLarge = 'Gitter zu groß für Operation';
    SIdentifierExpected = 'Bezeichner erwartet';
    SIndexOutOfRange = 'Gitterindex außerhalb des zulässigen Bereichs';
    SIniFileWriteError = 'In %s kann nicht geschrieben werden';
    SInvalidActionCreation = 'Ungültige Aktionserstellung';
    SInvalidActionEnumeration = 'Ungültige Aktionsaufzählung';
    SInvalidActionRegistration = 'Ungültige Aktionsregistrierung';
    SInvalidActionUnregistration = 'Ungültige Aufhebung der Aktionsregistrierung';
    SInvalidBinary = 'Ungültiger Binärwert';
    SInvalidFileName = 'Ungültiger Dateiname - %s';
    SInvalidImage = 'Ungültiges Stream-Format';
    SInvalidMask = ''#39'%s'#39' ist eine ungültige Maske für (%d)';
    SInvalidName = ''#39''#39'%s'#39''#39' ist kein gültiger Komponentenname';
    SInvalidProperty = 'Ungültiger Eigenschaftswert';
    SInvalidPropertyElement = 'Ungültiges Eigenschaftselement: %s';
    SInvalidPropertyPath = 'Ungültiger Pfad für Eigenschaft';
    SInvalidPropertyType = 'Ungültiger Eigenschaftstyp: %s';
    SInvalidPropertyValue = 'Ungültiger Eigenschaftswert';
    SInvalidRegType = 'Ungültiger Datentyp für '#39'%s'#39'';
    SInvalidString = 'Ungültige Stringkonstante';
    SInvalidStringGridOp = 'Es können keine Zeilen des Tabellengitters gelöscht oder eingefügt werden';
    SItemNotFound = 'Eintrag nicht gefunden ($0%x)';
    SLineTooLong = 'Zeile zu lang';
    SListCapacityError = 'Kapazität der Liste ist erschöpft (%d)';
    SListCountError = 'Zu viele Einträge in der Liste (%d)';
    SListIndexError = 'Listenindex überschreitet das Maximum (%d)';
    SMaskErr = 'Ungültiger Eingabewert';
    SMaskEditErr = 'Ungültiger Eingabewert. Mit der Taste ESC machen Sie die Änderungen rückgängig';
    SMemoryStreamError = 'Expandieren des Speicher-Stream wegen Speichermangel nicht möglich';
    SNoComSupport = '%s wurde nicht als COM-Klasse registriert';
    SNotPrinting = 'Der Drucker druckt aktuell nicht';
    SNumberExpected = 'Zahl erwartet';
    SAnsiUTF8Expected = 'ANSI- oder UTF8-Codierung erwartet';
    SParseError = '%s in Zeile %d';
    SComponentNameTooLong = 'Komponentenname '#39'%s'#39' überschreitet 64 Zeichen';
    SPropertyException = 'Fehler beim Lesen von %s%s%s: %s';
    SPrinting = 'Druckvorgang läuft';
    SReadError = 'Stream-Lesefehler';
    SReadOnlyProperty = 'Eigenschaft kann nur gelesen werden';
    SRegCreateFailed = 'Erzeugung von Schlüssel %s misslungen';
    SRegGetDataFailed = 'Fehler beim Holen der Daten für '#39'%s'#39'';
    SRegisterError = 'Ungültige Komponentenregistrierung';
    SRegSetDataFailed = 'Fehler beim Setzen der Daten für '#39'%s'#39'';
    SResNotFound = 'Ressource %s wurde nicht gefunden';
    SSeekNotImplemented = '%s.Seek nicht implementiert';
    SSortedListError = 'Operation für sortierte Listen nicht zulässig';
    SStringExpected = 'String erwartet';
    SSymbolExpected = '%s erwartet';
    STooManyDeleted = 'Zu viele Zeilen oder Spalten gelöscht';
    SUnknownGroup = '%s befindet sich nicht in einer Gruppe für Klassenregistrierungen';
    SUnknownProperty = 'Eigenschaft %s existiert nicht';
    SWriteError = 'Stream-Schreibfehler';
    SStreamSetSize = 'Fehler beim Setzen der Größe des Stream';
    SThreadCreateError = 'Fehler beim Erzeugen des Thread: %s';
    SThreadError = 'Thread-Fehler: %s (%d)';
    SThreadExternalTerminate = 'Ein extern erstellter Thread kann nicht beendet werden';
    SThreadExternalWait = 'Auf einen extern erstellten Thread kann nicht gewartet werden';

    SInvalidDateDay = '(%d, %d) ist kein gültiger Wert für die Tagesangabe im Datum';
    SInvalidDateWeek = '(%d, %d, %d) ist kein gültiger Wert für die Wochenangabe im Datum';
    SInvalidDateMonthWeek = '(%d, %d, %d, %d) ist kein gültiger Wert für die Monats- und Wochenangabe im Datum';
    SInvalidDayOfWeekInMonth = '(%d, %d, %d, %d) ist kein gültiger Wert für die Tages- und Monatsangabe im Datum';
    SInvalidJulianDate = '%f Julianischer Wert kann nicht als Datum/Uhrzeitwert dargestellt werden';
    SMissingDateTimeField = '?';

    SConvIncompatibleTypes2 = 'Inkompatible Konvertierungstypen [%s, %s]';
    SConvIncompatibleTypes3 = 'Inkompatible Konvertierungstypen [%s, %s, %s]';
    SConvIncompatibleTypes4 = 'Inkompatible Konvertierungstypen [%s - %s, %s - %s]';
    SConvUnknownType = 'Unbekannter Konvertierungstyp %s';
    SConvDuplicateType = 'Konvertierungstyp (%s) bereits registriert in %s';
    SConvUnknownFamily = 'Unbekannte Konvertierungsfamilie %s';
    SConvDuplicateFamily = 'Konvertierungsfamilie (%s) bereits registriert';
    SConvUnknownDescription = '[$%.8x]' deprecated; // no longer used
    SConvUnknownDescriptionWithPrefix = '[%s%.8x]';
    SConvIllegalType = 'Ungültiger Typ';
    SConvIllegalFamily = 'Ungültige Familie';
    SConvFactorZero = '%s hat den Faktor Null';
    SConvStrParseError = '%s konnte nicht analysiert werden';
    SFailedToCallConstructor = 'Der Nachkomme von TStrings %s konnte den geerbten Konstruktor nicht aufrufen';

    sWindowsSocketError = 'Windows-Socket-Fehler: %s (%d), bei API '#39'%s'#39'';
    sAsyncSocketError = 'Asynchroner Socket-Fehler %d';
    sNoAddress = 'Keine Adresse angegeben';
    sCannotListenOnOpen = 'Offener Socket kann nicht überwacht werden';
    sCannotCreateSocket = 'Es kann kein neuer Socket erzeugt werden';
    sSocketAlreadyOpen = 'Socket ist bereits geöffnet';
    sCantChangeWhileActive = 'Wert kann nicht geändert werden, während der Socket aktiv ist';
    sSocketMustBeBlocking = 'Socket muss sich im Blocking-Modus befinden';
    sSocketIOError = '%s-Fehler %d, %s';
    sSocketRead = 'Lesen';
    sSocketWrite = 'Schreiben';

    SCmplxCouldNotParseImaginary = 'Imaginärer Anteil konnte nicht analysiert werden';
    SCmplxCouldNotParseSymbol = 'Erforderliches '#39'%s'#39'-Symbol kann nicht analysiert werden';
    SCmplxCouldNotParsePlus = 'Erforderliches '#39'+'#39' (oder '#39'-'#39') Symbol konnte nicht analysiert werden';
    SCmplxCouldNotParseReal = 'Realer Anteil konnte nicht analysiert werden';
    SCmplxUnexpectedEOS = 'Unerwartetes Ende des Strings [%s]';
    SCmplxUnexpectedChars = 'Unerwartete Zeichen';
    SCmplxErrorSuffix = '%s [%s<?>%s]';

    hNoSystem = 'Kein Hilfemanager installiert.';
    hNoTopics = 'Keine themenbasierte Hilfe installiert.';
    hNoContext = 'Keine kontextsensitive Hilfe installiert.';
    hNoContextFound = 'Keine Hilfe für Kontext %d gefunden.';
    hNothingFound = 'Keine Hilfe gefunden für "%s"';
    hNoTableOfContents = 'Kein Inhaltsverzeichnis gefunden';
    hNoFilterViewer = 'Kein Hilfe-Viewer, der Filter unterstützt';

    sArgumentOutOfRange_InvalidHighSurrogate = 'Ein gültiges hohes Ersatzzeichen ist >= $D800 und <= $DBFF';
    sArgumentOutOfRange_InvalidLowSurrogate = 'Ein gültiges niedriges Ersatzzeichen ist >= $DC00 und <= $DFFF';
    sArgumentOutOfRange_Index = 'Index außerhalb des Bereichs (%d).  Muss >= 0 und < %d sein';
    sArgumentOutOfRange_StringIndex = 'String-Index außerhalb des Bereichs (%d).  Muss >= 1 und <= %d sein';
    sArgumentOutOfRange_InvalidUTF32 = 'Ungültiger UTF32-Zeichenwert.  Muss >= 0 und <= $10FFF sein, ausgenommen Ersatzpaarbereiche'; 
    sArgument_InvalidHighSurrogate = 'Hohes Ersatzzeichen ohne folgendes niedriges Ersatzzeichen bei Index: %d. Überprüfen Sie, ob der String korrekt codiert ist';
    sArgument_InvalidLowSurrogate = 'Niedriges Ersatzzeichen ohne vorausgehendes hohes Ersatzzeichen bei Index: %d. Überprüfen Sie, ob der String korrekt codiert ist';

    sNoConstruct = 'Klasse %s soll nicht erzeugt werden';

    sCannotCallAcquireOnConditionVar = 'Acquire kann nicht für TConditionVariable aufgerufen werden.  Es muss WaitFor mit einem externen TMutex aufgerufen werden';

  { ************************************************************************* }
  { Distance's family type }
    SDistanceDescription = 'Entfernung';

  { Distance's various conversion types }
    SMicromicronsDescription = 'Mikromikron';
    SAngstromsDescription = 'Angström';
    SMillimicronsDescription = 'Millimikron';
    SMicronsDescription = 'Mikron';
    SMillimetersDescription = 'Millimeter';
    SCentimetersDescription = 'Zentimeter';
    SDecimetersDescription = 'Dezimeter';
    SMetersDescription = 'Meter';
    SDecametersDescription = 'Dekameter';
    SHectometersDescription = 'Hektometer';
    SKilometersDescription = 'Kilometer';
    SMegametersDescription = 'Megameter';
    SGigametersDescription = 'Gigameter';
    SInchesDescription = 'Zoll';
    SFeetDescription = 'Fuß';
    SYardsDescription = 'Yard';
    SMilesDescription = 'Meile';
    SNauticalMilesDescription = 'Seemeile';
    SAstronomicalUnitsDescription = 'Astronomische Einheiten';
    SLightYearsDescription = 'Lichtjahr';
    SParsecsDescription = 'Parsecs';
    SCubitsDescription = 'Elle';
    SFathomsDescription = 'Faden';
    SFurlongsDescription = 'Achtelmeile';
    SHandsDescription = 'Handbreite';
    SPacesDescription = 'Schritt';
    SRodsDescription = 'Messrute';
    SChainsDescription = 'Messkette';
    SLinksDescription = 'Link';
    SPicasDescription = 'Pica';
    SPointsDescription = 'Punkt';

  { ************************************************************************* }
  { Area's family type }
    SAreaDescription = 'Fläche';

  { Area's various conversion types }
    SSquareMillimetersDescription = 'Quadratmillimeter';
    SSquareCentimetersDescription = 'Quadratzentimeter';
    SSquareDecimetersDescription = 'Quadratdezimeter';
    SSquareMetersDescription = 'Quadratmeter';
    SSquareDecametersDescription = 'Quadratdekameter';
    SSquareHectometersDescription = 'Quadrathektometer';
    SSquareKilometersDescription = 'Quadratkilometer';
    SSquareInchesDescription = 'Quadratzoll';
    SSquareFeetDescription = 'Quadratfuß';
    SSquareYardsDescription = 'Quadrat-Yard';
    SSquareMilesDescription = 'Quadratmeilen';
    SAcresDescription = 'Morgen';
    SCentaresDescription = 'Zentarien';
    SAresDescription = 'Ar';
    SHectaresDescription = 'Hektoar';
    SSquareRodsDescription = 'Quadratrute';

  { ************************************************************************* }
  { Volume's family type }
    SVolumeDescription = 'Volumen';

  { Volume's various conversion types }
    SCubicMillimetersDescription = 'Kubikmillimeter';
    SCubicCentimetersDescription = 'Kubikzentimeter';
    SCubicDecimetersDescription = 'Kubikdezimeter';
    SCubicMetersDescription = 'Kubikmeter';
    SCubicDecametersDescription = 'Kubikdekameter';
    SCubicHectometersDescription = 'Kubikhektometer';
    SCubicKilometersDescription = 'Kubikkilometer';
    SCubicInchesDescription = 'Kubikzoll';
    SCubicFeetDescription = 'Kubikfuß';
    SCubicYardsDescription = 'Kubik-Yard';
    SCubicMilesDescription = 'Kubikmeilen';
    SMilliLitersDescription = 'Milliliter';
    SCentiLitersDescription = 'Zentiliter';
    SDeciLitersDescription = 'Deziliter';
    SLitersDescription = 'Liter';
    SDecaLitersDescription = 'Dekaliter';
    SHectoLitersDescription = 'Hektoliter';
    SKiloLitersDescription = 'Kiloliter';
    SAcreFeetDescription = 'Morgen/Fuß';
    SAcreInchesDescription = 'Morgen/Zoll';
    SCordsDescription = 'Klaster';
    SCordFeetDescription = 'Klasterfuß';
    SDecisteresDescription = 'Dezister';
    SSteresDescription = 'Ster';
    SDecasteresDescription = 'Dekaster';

  { American Fluid Units }
    SFluidGallonsDescription = 'Gallone (Flüssigkeit)';
    SFluidQuartsDescription = 'Quart (Flüssigkeit)';
    SFluidPintsDescription = 'Pinte (Flüssigkeit)';
    SFluidCupsDescription = 'Tasse (Flüssigkeit)';
    SFluidGillsDescription = 'Gill (Flüssigkeit)';
    SFluidOuncesDescription = 'Unze (Flüssigkeit)';
    SFluidTablespoonsDescription = 'Esslöffel (Flüssigkeit)';
    SFluidTeaspoonsDescription = 'Teelöffel (Flüssigkeit)';

  { American Dry Units }
    SDryGallonsDescription = 'Gallone (Trockenmaß)';
    SDryQuartsDescription = 'Quart (Trockenmaß)';
    SDryPintsDescription = 'Pinte (Trockenmaß)';
    SDryPecksDescription = 'Viertelscheffel (Trockenmaß)';
    SDryBucketsDescription = 'DryBuckets';
    SDryBushelsDescription = 'Scheffel (Trockenmaß)';

  { English Imperial Fluid/Dry Units }
    SUKGallonsDescription = 'Gallone (UK)';
    SUKPottlesDescription = 'Pottle (UK)';
    SUKQuartsDescription = 'Quart (UK)';
    SUKPintsDescription = 'Pinte (UK)';
    SUKGillsDescription = 'Viertelpinte (UK)';
    SUKOuncesDescription = 'Unze (UK)';
    SUKPecksDescription = 'Viertelscheffel (UK)';
    SUKBucketsDescription = 'UKBuckets';
    SUKBushelsDescription = 'Scheffel (UK)';

  { ************************************************************************* }
  { Mass's family type }
    SMassDescription = 'Masse';

  { Mass's various conversion types }
    SNanogramsDescription = 'Nanogramm';
    SMicrogramsDescription = 'Mikrogramm';
    SMilligramsDescription = 'Milligramm';
    SCentigramsDescription = 'Zentigramm';
    SDecigramsDescription = 'Dezigramm';
    SGramsDescription = 'Gramm';
    SDecagramsDescription = 'Dekagramm';
    SHectogramsDescription = 'Hektogramm';
    SKilogramsDescription = 'Kilogramm';
    SMetricTonsDescription = 'Metrische Tonne';
    SDramsDescription = 'Drachme';
    SGrainsDescription = 'Gran';
    STonsDescription = 'Tonne';
    SLongTonsDescription = 'Tonne (UK)';
    SOuncesDescription = 'Unze';
    SPoundsDescription = 'Pfund';
    SStonesDescription = 'Stones';

  { ************************************************************************* }
  { Temperature's family type }
    STemperatureDescription = 'Temperatur';

  { Temperature's various conversion types }
    SCelsiusDescription = 'Celsius';
    SKelvinDescription = 'Kelvin';
    SFahrenheitDescription = 'Fahrenheit';
    SRankineDescription = 'Rangordnung';
    SReaumurDescription = 'Reaumur';

  { ************************************************************************* }
  { Time's family type }
    STimeDescription = 'Uhrzeit';

  { Time's various conversion types }
    SMilliSecondsDescription = 'Millisekunde';
    SSecondsDescription = 'Sekunde';
    SMinutesDescription = 'Minute';
    SHoursDescription = 'Stunde';
    SDaysDescription = 'Tag';
    SWeeksDescription = 'Woche';
    SFortnightsDescription = 'Vierzehn Tage';
    SMonthsDescription = 'Monat';
    SYearsDescription = 'Jahr';
    SDecadesDescription = 'Dekade';
    SCenturiesDescription = 'Jahrhundert';
    SMillenniaDescription = 'Jahrtausend';
    SDateTimeDescription = 'Datum/Uhrzeit';
    SJulianDateDescription = 'Julianisches Datum';
    SModifiedJulianDateDescription = 'Modifiziertes julianisches Datum';

    SInvalidDate = ''#39''#39'%s'#39''#39' ist kein gültiges Datum' deprecated 'Use SysConsts.SInvalidDate';
    SInvalidDateTime = ''#39''#39'%s'#39''#39' ist keine gültige Datums-/Zeitangabe' deprecated 'Use SysConsts.SInvalidDateTime';
    SInvalidInteger = ''#39''#39'%s'#39''#39' ist kein gültiger Integer-Wert' deprecated 'Use SysConsts.SInvalidInteger';
    SInvalidTime = ''#39''#39'%s'#39''#39' ist keine gültige Zeitangabe' deprecated 'Use SysConsts.SInvalidTime';
    STimeEncodeError = 'Ungültiges Argument zum Codieren der Uhrzeit' deprecated 'Use SysConsts.STimeEncodeError';

implementation

end.
