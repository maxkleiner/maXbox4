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
    SAncestorNotFound = 'Vorfahr f�r '#39'%s'#39' nicht gefunden';
    SAssignError = '%s kann nicht zu %s zugewiesen werden';
    SBitsIndexError = 'Bits-Index au�erhalb des zul�ssigen Bereichs';
    SBucketListLocked = 'Liste ist w�hrend eines aktiven ForEach gesperrt';
    SCantWriteResourceStreamError = 'In einen zum Lesen ge�ffneten Ressourcen-Stream kann nicht geschrieben werden';
    SCharExpected = ''#39''#39'%s'#39''#39' erwartet';
    SCheckSynchronizeError = 'CheckSynchronize wurde vom Thread $%x aufgerufen, der NICHT der Haupt-Thread ist.';
    SClassNotFound = 'Klasse %s nicht gefunden';
    SDelimiterQuoteCharError = 'Die Eigenschaften Delimiter und QuoteChar d�rfen nicht denselben Wert besitzen';
    SDuplicateClass = 'Klasse mit der Bezeichnung %s existiert bereits';
    SDuplicateItem = 'Liste gestattet keine doppelten Eintr�ge ($0%x)';
    SDuplicateName = 'Komponente mit der Bezeichnung %s existiert bereits';
    SDuplicateString = 'In der Stringliste sind Duplikate nicht erlaubt';
    SFCreateError = 'Datei %s kann nicht erstellt werden';
    SFCreateErrorEx = 'Datei "%s" kann nicht erstellt werden. %s';
    SFixedColTooBig = 'Die Anzahl fester Spalten muss kleiner sein als die Spaltenanzahl';
    SFixedRowTooBig = 'Die Anzahl fester Zeilen muss kleiner sein als die Zeilenanzahl';
    SFOpenError = 'Datei %s kann nicht ge�ffnet werden';
    SFOpenErrorEx = 'Datei %s kann nicht ge�ffnet werden. %s';
    SGridTooLarge = 'Gitter zu gro� f�r Operation';
    SIdentifierExpected = 'Bezeichner erwartet';
    SIndexOutOfRange = 'Gitterindex au�erhalb des zul�ssigen Bereichs';
    SIniFileWriteError = 'In %s kann nicht geschrieben werden';
    SInvalidActionCreation = 'Ung�ltige Aktionserstellung';
    SInvalidActionEnumeration = 'Ung�ltige Aktionsaufz�hlung';
    SInvalidActionRegistration = 'Ung�ltige Aktionsregistrierung';
    SInvalidActionUnregistration = 'Ung�ltige Aufhebung der Aktionsregistrierung';
    SInvalidBinary = 'Ung�ltiger Bin�rwert';
    SInvalidFileName = 'Ung�ltiger Dateiname - %s';
    SInvalidImage = 'Ung�ltiges Stream-Format';
    SInvalidMask = ''#39'%s'#39' ist eine ung�ltige Maske f�r (%d)';
    SInvalidName = ''#39''#39'%s'#39''#39' ist kein g�ltiger Komponentenname';
    SInvalidProperty = 'Ung�ltiger Eigenschaftswert';
    SInvalidPropertyElement = 'Ung�ltiges Eigenschaftselement: %s';
    SInvalidPropertyPath = 'Ung�ltiger Pfad f�r Eigenschaft';
    SInvalidPropertyType = 'Ung�ltiger Eigenschaftstyp: %s';
    SInvalidPropertyValue = 'Ung�ltiger Eigenschaftswert';
    SInvalidRegType = 'Ung�ltiger Datentyp f�r '#39'%s'#39'';
    SInvalidString = 'Ung�ltige Stringkonstante';
    SInvalidStringGridOp = 'Es k�nnen keine Zeilen des Tabellengitters gel�scht oder eingef�gt werden';
    SItemNotFound = 'Eintrag nicht gefunden ($0%x)';
    SLineTooLong = 'Zeile zu lang';
    SListCapacityError = 'Kapazit�t der Liste ist ersch�pft (%d)';
    SListCountError = 'Zu viele Eintr�ge in der Liste (%d)';
    SListIndexError = 'Listenindex �berschreitet das Maximum (%d)';
    SMaskErr = 'Ung�ltiger Eingabewert';
    SMaskEditErr = 'Ung�ltiger Eingabewert. Mit der Taste ESC machen Sie die �nderungen r�ckg�ngig';
    SMemoryStreamError = 'Expandieren des Speicher-Stream wegen Speichermangel nicht m�glich';
    SNoComSupport = '%s wurde nicht als COM-Klasse registriert';
    SNotPrinting = 'Der Drucker druckt aktuell nicht';
    SNumberExpected = 'Zahl erwartet';
    SAnsiUTF8Expected = 'ANSI- oder UTF8-Codierung erwartet';
    SParseError = '%s in Zeile %d';
    SComponentNameTooLong = 'Komponentenname '#39'%s'#39' �berschreitet 64 Zeichen';
    SPropertyException = 'Fehler beim Lesen von %s%s%s: %s';
    SPrinting = 'Druckvorgang l�uft';
    SReadError = 'Stream-Lesefehler';
    SReadOnlyProperty = 'Eigenschaft kann nur gelesen werden';
    SRegCreateFailed = 'Erzeugung von Schl�ssel %s misslungen';
    SRegGetDataFailed = 'Fehler beim Holen der Daten f�r '#39'%s'#39'';
    SRegisterError = 'Ung�ltige Komponentenregistrierung';
    SRegSetDataFailed = 'Fehler beim Setzen der Daten f�r '#39'%s'#39'';
    SResNotFound = 'Ressource %s wurde nicht gefunden';
    SSeekNotImplemented = '%s.Seek nicht implementiert';
    SSortedListError = 'Operation f�r sortierte Listen nicht zul�ssig';
    SStringExpected = 'String erwartet';
    SSymbolExpected = '%s erwartet';
    STooManyDeleted = 'Zu viele Zeilen oder Spalten gel�scht';
    SUnknownGroup = '%s befindet sich nicht in einer Gruppe f�r Klassenregistrierungen';
    SUnknownProperty = 'Eigenschaft %s existiert nicht';
    SWriteError = 'Stream-Schreibfehler';
    SStreamSetSize = 'Fehler beim Setzen der Gr��e des Stream';
    SThreadCreateError = 'Fehler beim Erzeugen des Thread: %s';
    SThreadError = 'Thread-Fehler: %s (%d)';
    SThreadExternalTerminate = 'Ein extern erstellter Thread kann nicht beendet werden';
    SThreadExternalWait = 'Auf einen extern erstellten Thread kann nicht gewartet werden';

    SInvalidDateDay = '(%d, %d) ist kein g�ltiger Wert f�r die Tagesangabe im Datum';
    SInvalidDateWeek = '(%d, %d, %d) ist kein g�ltiger Wert f�r die Wochenangabe im Datum';
    SInvalidDateMonthWeek = '(%d, %d, %d, %d) ist kein g�ltiger Wert f�r die Monats- und Wochenangabe im Datum';
    SInvalidDayOfWeekInMonth = '(%d, %d, %d, %d) ist kein g�ltiger Wert f�r die Tages- und Monatsangabe im Datum';
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
    SConvIllegalType = 'Ung�ltiger Typ';
    SConvIllegalFamily = 'Ung�ltige Familie';
    SConvFactorZero = '%s hat den Faktor Null';
    SConvStrParseError = '%s konnte nicht analysiert werden';
    SFailedToCallConstructor = 'Der Nachkomme von TStrings %s konnte den geerbten Konstruktor nicht aufrufen';

    sWindowsSocketError = 'Windows-Socket-Fehler: %s (%d), bei API '#39'%s'#39'';
    sAsyncSocketError = 'Asynchroner Socket-Fehler %d';
    sNoAddress = 'Keine Adresse angegeben';
    sCannotListenOnOpen = 'Offener Socket kann nicht �berwacht werden';
    sCannotCreateSocket = 'Es kann kein neuer Socket erzeugt werden';
    sSocketAlreadyOpen = 'Socket ist bereits ge�ffnet';
    sCantChangeWhileActive = 'Wert kann nicht ge�ndert werden, w�hrend der Socket aktiv ist';
    sSocketMustBeBlocking = 'Socket muss sich im Blocking-Modus befinden';
    sSocketIOError = '%s-Fehler %d, %s';
    sSocketRead = 'Lesen';
    sSocketWrite = 'Schreiben';

    SCmplxCouldNotParseImaginary = 'Imagin�rer Anteil konnte nicht analysiert werden';
    SCmplxCouldNotParseSymbol = 'Erforderliches '#39'%s'#39'-Symbol kann nicht analysiert werden';
    SCmplxCouldNotParsePlus = 'Erforderliches '#39'+'#39' (oder '#39'-'#39') Symbol konnte nicht analysiert werden';
    SCmplxCouldNotParseReal = 'Realer Anteil konnte nicht analysiert werden';
    SCmplxUnexpectedEOS = 'Unerwartetes Ende des Strings [%s]';
    SCmplxUnexpectedChars = 'Unerwartete Zeichen';
    SCmplxErrorSuffix = '%s [%s<?>%s]';

    hNoSystem = 'Kein Hilfemanager installiert.';
    hNoTopics = 'Keine themenbasierte Hilfe installiert.';
    hNoContext = 'Keine kontextsensitive Hilfe installiert.';
    hNoContextFound = 'Keine Hilfe f�r Kontext %d gefunden.';
    hNothingFound = 'Keine Hilfe gefunden f�r "%s"';
    hNoTableOfContents = 'Kein Inhaltsverzeichnis gefunden';
    hNoFilterViewer = 'Kein Hilfe-Viewer, der Filter unterst�tzt';

    sArgumentOutOfRange_InvalidHighSurrogate = 'Ein g�ltiges hohes Ersatzzeichen ist >= $D800 und <= $DBFF';
    sArgumentOutOfRange_InvalidLowSurrogate = 'Ein g�ltiges niedriges Ersatzzeichen ist >= $DC00 und <= $DFFF';
    sArgumentOutOfRange_Index = 'Index au�erhalb des Bereichs (%d).  Muss >= 0 und < %d sein';
    sArgumentOutOfRange_StringIndex = 'String-Index au�erhalb des Bereichs (%d).  Muss >= 1 und <= %d sein';
    sArgumentOutOfRange_InvalidUTF32 = 'Ung�ltiger UTF32-Zeichenwert.  Muss >= 0 und <= $10FFF sein, ausgenommen Ersatzpaarbereiche'; 
    sArgument_InvalidHighSurrogate = 'Hohes Ersatzzeichen ohne folgendes niedriges Ersatzzeichen bei Index: %d. �berpr�fen Sie, ob der String korrekt codiert ist';
    sArgument_InvalidLowSurrogate = 'Niedriges Ersatzzeichen ohne vorausgehendes hohes Ersatzzeichen bei Index: %d. �berpr�fen Sie, ob der String korrekt codiert ist';

    sNoConstruct = 'Klasse %s soll nicht erzeugt werden';

    sCannotCallAcquireOnConditionVar = 'Acquire kann nicht f�r TConditionVariable aufgerufen werden.  Es muss WaitFor mit einem externen TMutex aufgerufen werden';

  { ************************************************************************* }
  { Distance's family type }
    SDistanceDescription = 'Entfernung';

  { Distance's various conversion types }
    SMicromicronsDescription = 'Mikromikron';
    SAngstromsDescription = 'Angstr�m';
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
    SFeetDescription = 'Fu�';
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
    SAreaDescription = 'Fl�che';

  { Area's various conversion types }
    SSquareMillimetersDescription = 'Quadratmillimeter';
    SSquareCentimetersDescription = 'Quadratzentimeter';
    SSquareDecimetersDescription = 'Quadratdezimeter';
    SSquareMetersDescription = 'Quadratmeter';
    SSquareDecametersDescription = 'Quadratdekameter';
    SSquareHectometersDescription = 'Quadrathektometer';
    SSquareKilometersDescription = 'Quadratkilometer';
    SSquareInchesDescription = 'Quadratzoll';
    SSquareFeetDescription = 'Quadratfu�';
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
    SCubicFeetDescription = 'Kubikfu�';
    SCubicYardsDescription = 'Kubik-Yard';
    SCubicMilesDescription = 'Kubikmeilen';
    SMilliLitersDescription = 'Milliliter';
    SCentiLitersDescription = 'Zentiliter';
    SDeciLitersDescription = 'Deziliter';
    SLitersDescription = 'Liter';
    SDecaLitersDescription = 'Dekaliter';
    SHectoLitersDescription = 'Hektoliter';
    SKiloLitersDescription = 'Kiloliter';
    SAcreFeetDescription = 'Morgen/Fu�';
    SAcreInchesDescription = 'Morgen/Zoll';
    SCordsDescription = 'Klaster';
    SCordFeetDescription = 'Klasterfu�';
    SDecisteresDescription = 'Dezister';
    SSteresDescription = 'Ster';
    SDecasteresDescription = 'Dekaster';

  { American Fluid Units }
    SFluidGallonsDescription = 'Gallone (Fl�ssigkeit)';
    SFluidQuartsDescription = 'Quart (Fl�ssigkeit)';
    SFluidPintsDescription = 'Pinte (Fl�ssigkeit)';
    SFluidCupsDescription = 'Tasse (Fl�ssigkeit)';
    SFluidGillsDescription = 'Gill (Fl�ssigkeit)';
    SFluidOuncesDescription = 'Unze (Fl�ssigkeit)';
    SFluidTablespoonsDescription = 'Essl�ffel (Fl�ssigkeit)';
    SFluidTeaspoonsDescription = 'Teel�ffel (Fl�ssigkeit)';

  { American Dry Units }
    SDryGallonsDescription = 'Gallone (Trockenma�)';
    SDryQuartsDescription = 'Quart (Trockenma�)';
    SDryPintsDescription = 'Pinte (Trockenma�)';
    SDryPecksDescription = 'Viertelscheffel (Trockenma�)';
    SDryBucketsDescription = 'DryBuckets';
    SDryBushelsDescription = 'Scheffel (Trockenma�)';

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

    SInvalidDate = ''#39''#39'%s'#39''#39' ist kein g�ltiges Datum' deprecated 'Use SysConsts.SInvalidDate';
    SInvalidDateTime = ''#39''#39'%s'#39''#39' ist keine g�ltige Datums-/Zeitangabe' deprecated 'Use SysConsts.SInvalidDateTime';
    SInvalidInteger = ''#39''#39'%s'#39''#39' ist kein g�ltiger Integer-Wert' deprecated 'Use SysConsts.SInvalidInteger';
    SInvalidTime = ''#39''#39'%s'#39''#39' ist keine g�ltige Zeitangabe' deprecated 'Use SysConsts.SInvalidTime';
    STimeEncodeError = 'Ung�ltiges Argument zum Codieren der Uhrzeit' deprecated 'Use SysConsts.STimeEncodeError';

implementation

end.
