(******************************************************************************)
(*                                                                            *)
(*   Komponente zur Auswertung eines DCF77-Signals                            *)
(*   empfangen mit einer "Expert Mouse Clock" an der seriellen Schnittstelle  *)
(*                                                                            *)
(*   (c) 1999 Rainer Reusch & Toolbox                                         *)
(*   (c) 1999 Rainer Reusch & Computer- und Literaturverlag                   *)
(*                                                                            *)
(*   Borland Delphi 2, 3, 4                                                   *)
(*                                                                            *)
(****V1.0**********************************************************************)

{
Diese Komponente ist für das Funkuhrenmodul "Expert Mouse Clock" von GUDE
Analog- und Digitalsysteme GmbH, Köln ausgelegt. Der Anschluß an die serielle
Schnittstelle erfolgt wie vorgesehen. Anschlußbelegung:
DTR: positive Versorgungsspannung
RTS: negative Versorgungsspannung
RxD: Signaleingang (50 Baud, 8n1 muß eingestellt sein)
Die serielle Schnittstelle muß einen Interrupt auslösen können.
Hinweis: Diese Komponente erfordert die Komponenten-Unit "Serial" V3.2 (!)
oder höher.

RECHTLICHES:
DIESE KOMPONENTE IST URHEBERRECHTLICH GESCHÜTZT! DIE WEITERGABE UND DER VERKAUF
DES QUELLTEXTES IST UNTERSAGT. DIESER QUELLTEXT WIRD LEDIGLICH LESERN DER
ZEITSCHRIFT TOOLBOX UND LESERN DES COMPUTER- UND LITERATURVERLAGES ZUM EIGENEN
GEBRAUCH ZUR VERFÜGUNG GESTELLT. EINE LIZENZGEBÜHR IST VON DIESEN ANWENDERN
NICHT ZU ENTRICHTEN.
DER GEBRAUCH DER KOMPONENTE UND DER DAZUGEHÖRIGEN BEISPIELPROGRAMME ERFOLGT AUF
EIGENE GEFAHR. FÜR BESCHÄDIGUNGEN AN GERÄTEN ODER DATENVERLUSTE ÜBERNEHMEN
WEDER DER AUTOR NOCH DER VERLAG JEGLICHE HAFTUNG.

Für Hinweise auf Probleme und Fehler, sowie Kommentare sind wir dankbar.
Richten Sie Ihre Anfrage bitte an folgende Adresse:
  Redaktion Toolbox
  10, Rue des Hauts Champs
  F-88110 Luvigny
  FAX: 0033-329-4240-03
  E-Mail: jb@toolbox-mag.de
}

UNIT clockExpert;

INTERFACE

USES
  Windows, Messages, Classes, SysUtils, ExtCtrls, Serial;

TYPE
  (* Status der DCF-Komponente *)
  TDCFStatus = (NotOpened,        (* serielle Schnittstelle ist nicht geöffnet *)
                NoSignal,         (* kein DCF-Signal            *)
                Synchronizing,    (* warten auf Minutenanfang   *)
                ReceiveData,      (* Datenbits werden aufgenommen *)
                TimeAvailable);   (* DCF-Zeit steht zur Verfügung *)
  (* DCF-Komponente *)
  TExpertClock = CLASS (TComponent)
  PRIVATE
    FStatus : TDCFStatus;              (* Empfangsstatus           *)
    FReserveTransmitter,               (* Reservesender in Betrieb *)
    FSummerTime : BOOLEAN;             (* Sommerzeit               *)
    FSwitchSecond : BOOLEAN;           (* Schaltsekunde;           *) 
    FHour, FMinute, FSecond : WORD;    (* Funkuhrzeit              *)
    FDay, FMonth : WORD;               (* Funk-Datum               *)
    FYear : WORD;
    FDayOfWeek : BYTE;                 (* Funk-Wochentag                *)
    FQuality,                          (* aktuelle Empfangsqualität     *)
    FQualityLimit : INTEGER;           (* Qualitätsvorgabe für Ereignis OnQualityAttained *)
    FOnDCFClock : TNotifyEvent;        (* DCF-Datenbit trifft ein       *)
    FOnStatusChanged : TNotifyEvent;   (* der Status hat sich geändert  *)
    FOnTimeChanged : TNotifyEvent;     (* Die Uhrzeit hat sich geändert *)
    FOnQualityAttained : TNotifyEvent; (* vorgegebene Qualität wurde erreicht *)
    LSummerTime : BOOLEAN;             (* letzte Zeitdaten für Qualitätsermittlung *)
    LHour, LMinute : WORD;
    LDay, LMonth : WORD;
    LYear : WORD;
    LDayOfWeek : BYTE;
    BitCount : INTEGER;                (* Bitzähler für Daten in einer Minute *)
    QualityEvent : BOOLEAN;
    FUNCTION GetCOMPort : INTEGER;
    PROCEDURE SetCOMPort(Value : INTEGER);
    FUNCTION GetActive : BOOLEAN;
    PROCEDURE SetActive(Value : BOOLEAN);
    PROCEDURE SetQualityLimit(Value : INTEGER);
    FUNCTION GetNow : TDateTime;
    FUNCTION GetDayOfWeek : INTEGER;
    FUNCTION SetTimeParameters : BOOLEAN;
    PROCEDURE ErrorTime;
  PROTECTED
    SerPort : TSerial;   (* Zugang zu serieller Schnittstelle   *)
    Timer59,             (* Timer generiert 59. Sekunde         *)
    TimerOut : TTimer;   (* TimeOut-Timer (Erkennung eines fehlenden Signals) *)
    LastHi : DWord;      (* Zeitpunkt der letzten High-Flanke DCF-Signal *)
    Data : ARRAY[0..59] OF BOOLEAN;  (* empfangene Datenbits    *)
    PROCEDURE SerPort1Cts(Sender: TObject);
    PROCEDURE Timer59Timer(Sender: TObject);
    PROCEDURE TimerOutTimer(Sender: TObject);
  PUBLIC
    CONSTRUCTOR Create(AOwner: TComponent); Override;                (* Konstruktor   *)
    DESTRUCTOR  Destroy; Override;                                   (* Destruktor     *)
    PROPERTY Status : TDCFStatus Read FStatus;                       (* Empfangsstatus *)
    PROPERTY ReserveTransmitter : BOOLEAN Read FReserveTransmitter;  (* Reservesender  *)
    PROPERTY SummerTime : BOOLEAN Read FSummerTime;                  (* Sommerzeit     *)
    PROPERTY SwitchSecond : BOOLEAN Read FSwitchSecond;              (* Schaltsekunde  *)
    PROPERTY Hour : WORD Read FHour;                                 (* DCF-Stunde     *)
    PROPERTY Minute : WORD Read FMinute;                             (* DCF-Minute     *)
    PROPERTY Second : WORD Read FSecond;                             (* DCF-Sekunde    *)
    PROPERTY Day : WORD Read FDay;                                   (* DCF-Tag        *)
    PROPERTY Month : WORD Read FMonth;                               (* DCF-Monat      *)
    PROPERTY Year : WORD Read FYear;                                 (* DCF-Jahr (19xx, 20xx)   *)
    PROPERTY Now : TDateTime Read GetNow;                            (* aktuelle Zeit           *)
    PROPERTY DayOfWeek : INTEGER Read GetDayOfWeek;                  (* Wochentag (1=Sonntag, Delphi-konform) *)
    PROPERTY Quality : INTEGER Read FQuality;                        (* Empfangsqualität (-1..) *)
  PUBLISHED
    PROPERTY COMPort : INTEGER Read GetCOMPort Write SetCOMPort;     (* serielle Schnittstelle  *)
    PROPERTY QualityLimit : INTEGER Read FQualityLimit Write SetQualityLimit;   (* zu erreichende Empfangsqualität für Ereignis *)
    PROPERTY Active : BOOLEAN Read GetActive Write SetActive;        (* Komponente aktivieren   *)
    PROPERTY OnDCFClock : TNotifyEvent Read FOnDCFClock Write FOnDCFClock;      (* DCF-Taktsignal          *)
    PROPERTY OnStatusChanged : TNotifyEvent Read FOnStatusChanged Write FOnStatusChanged;  (* Statusänderung   *)
    PROPERTY OnTimeChanged : TNotifyEvent Read FOnTimeChanged Write FOnTimeChanged;        (* DCF-Zeitänderung *)
    PROPERTY OnQualityAttained : TNotifyEvent Read FOnQualityAttained Write FOnQualityAttained;  (* Qualität ist erreicht *)
  END;

PROCEDURE Register;

IMPLEMENTATION

CONSTRUCTOR TExpertClock.Create(AOwner: TComponent);
(* Initialisierungen *)
BEGIN
  Inherited Create(AOwner);
  FStatus          := NoSignal;
  ErrorTime;  (* versch. Eigenschaften initialisieren *)
  FOnDCFClock      := NIL;
  FOnStatusChanged := NIL;
  FQuality         := -1;
  FQualityLimit    := 1;
  QualityEvent     := FALSE;
  (* serielle Schnittstelle *)
  SerPort          := TSerial.Create(Self);
  WITH SerPort DO BEGIN
    Baudrate       := br_000050;
    DTRActive      := TRUE;
    ThreadPriority := tpHighest;
    OnRxChar       := SerPort1Cts; (* RxD bildet den Dateneingang *)
    (* weitere Initialisierungen *)
    COMPort        := 0;
    AbortOnError   := FALSE;
    Active         := FALSE;
    BufSizeRec     := 2048;
    BufSizeTrm     := 2048;
    COMPort        := 0;
    ContinueOnXOff := FALSE;
    DataBits       := db_8;
    EliminateNullChar := FALSE;
    EofChar           := #26;
    ErrorChar         := '?';
    HandshakeDtrDsr   := FALSE;
    HandshakeRtsCts   := FALSE;
    HandshakeXOnXOff  := FALSE;
    ParityBit         := none;
    RecTimeOut        := 0;
    RTSActive         := FALSE;
    StopBits          := sb_1;
    TrmTimeOut        := 0;
    UseErrorChar      := FALSE;
    XOffChar          := #19;
    XOffLimit         := 1600;
    XOnChar           := #17;
    XOnLimit          := 400;
  END;
  (* Timer für 59. Sekunde *)
  Timer59 := TTimer.Create(Self);
  WITH Timer59 DO BEGIN
    Enabled   := FALSE;
    Interval  := 1000;
    OnTimer   := Timer59Timer;
  END;
  (* Timeout-Timer *)
  TimerOut := TTimer.Create(Self);
  WITH TimerOut DO BEGIN
    Enabled  := FALSE;
    Interval := 3000;
    OnTimer  := TimerOutTimer;
  END;
END;

DESTRUCTOR TExpertClock.Destroy;
(* Komponente freigeben *)
BEGIN
  SerPort.Free;
  Timer59.Free;
  Inherited Destroy;
END;

FUNCTION TExpertClock.GetCOMPort : INTEGER;
(* verwendete serielle Schnittstelle abfragen *)
BEGIN
  Result := SerPort.COMPort;
END;

PROCEDURE TExpertClock.SetCOMPort(Value : INTEGER);
(* zu verwendende serielle Schnittstelle festlegen *)
BEGIN
  SerPort.COMPort := Value;
END;

FUNCTION TExpertClock.GetActive : BOOLEAN;
(* Aktivierungszustand abfragen *)
BEGIN
  Result := SerPort.Active;
END;

PROCEDURE TExpertClock.SetActive(Value : BOOLEAN);
(* Komponente aktivieren/deaktivieren *)
BEGIN
  IF Value <> SerPort.Active THEN BEGIN
    ErrorTime;
    SerPort.Active := Value;
    IF Value THEN FStatus := NoSignal
             ELSE FStatus := NotOpened;
    IF Assigned(FOnStatusChanged) THEN OnStatusChanged(Self);
  END;
END;

PROCEDURE TExpertClock.SetQualityLimit(Value : INTEGER);
(* Qualitätsgrenze festlegen, die erreicht werden muß,  *)
(* damit das Ereignis OnQualityAttained auftritt        *)
(* nur Werte > 0 werden akzeptiert, Maximalwert 8       *)
BEGIN
  IF Value > 0 THEN BEGIN
    IF Value > 8 THEN Value := 8;
    FQualityLimit := Value;
  END;
END;

FUNCTION TExpertClock.GetNow : TDateTime;
(* Liefert aktuelles Datum und Uhrzeit                                    *)
(* Liegt keine DCF-Zeit vor, wird die Rechnerzeit übergeben               *)
(* Ist die DCF-Zeit nicht plausibel, wird 1.1.1980 00:00:00 zurückgegeben *)
BEGIN
  IF FStatus = TimeAvailable THEN
    TRY
      Result := EncodeDate(FYear, FMonth, FDay) + 
                EncodeTime(FHour, FMinute, FSecond, 0);
    EXCEPT
      Result := EncodeDate(1980, 1, 1) + EncodeTime(0, 0, 0, 0);
    END
  ELSE
    Result := SysUtils.Now;
END;

FUNCTION TExpertClock.GetDayOfWeek : INTEGER;
(* Liefert den Wochentag                                    *)
(* Die Numerierung der Wochentage ist Delphi-konform,       *)
(* das heißt, Sonntag=1, Samstag=7                          *)
(* Liegt keine DCF-Zeit vor, wird die Rechnerzeit verwendet *)
(* Ist die DCF-Zeit nicht plausibel, wird      *)
(* Dienstag (1.1.1980 00:00:00) zurückgegeben  *)
BEGIN
  IF FStatus = TimeAvailable THEN
    TRY
      Result := FDayOfWeek + 1;
      IF Result = 8 THEN Result := 1;
    EXCEPT
      Result := 3;
    END
  ELSE
    Result := SysUtils.DayOfWeek(SysUtils.Now);
END;

FUNCTION TExpertClock.SetTimeParameters : BOOLEAN; Register;
(* Konvertiert in Data gesammelte Info in Zeit- und Datumsangaben *)
(* Ergebnis true, wenn Infos korrekt sind                         *)
VAR
  b  : BOOLEAN;
  dt : TDateTime;
  w  : WORD;

  FUNCTION CheckParity(FirstBit, LastBit : INTEGER) : BOOLEAN; Register;
  (* Liefert true, wenn Anzahl gesetzter Bits gerade ist *)
  (* FirstBit : erstes Bit in Data                       *)
  (* LastBit : letztes Bit in Data                       *)
  VAR
    ii, nn : INTEGER;
  BEGIN
    nn := 0;
    FOR ii := FirstBit TO LastBit DO Inc(nn, Ord(Data[ii]));
    Result := NOT System.Odd(nn);
  END;
BEGIN
  (* Datenauswertung  *)
  FReserveTransmitter := Data[15];
  FSummerTime         := Data[17];
  FSwitchSecond       := Data[19];
  FHour         := Ord(Data[29])         + (Ord(Data[30]) SHL 1) + 
                   (Ord(Data[31]) SHL 2) + (Ord(Data[32]) SHL 3) +
                   10 * (Ord(Data[33])   + (Ord(Data[34]) SHL 1));
  FMinute       := Ord(Data[21])         + (Ord(Data[22]) SHL 1) + 
                   (Ord(Data[23]) SHL 2) + (Ord(Data[24]) SHL 3) +
                   10 * (Ord(Data[25])   + (Ord(Data[26]) SHL 1) +
                   (Ord(Data[27]) SHL 2));
  FDay          := Ord(Data[36])         + (Ord(Data[37]) SHL 1) + 
                   (Ord(Data[38]) SHL 2) + (Ord(Data[39]) SHL 3) +
                   10 * (Ord(Data[40])   + (Ord(Data[41]) SHL 1));
  FMonth        := Ord(Data[45])         + (Ord(Data[46]) SHL 1) + 
                   (Ord(Data[47]) SHL 2) + (Ord(Data[48]) SHL 3) +
                   10 * (Ord(Data[49]));
  FYear         := Ord(Data[50])         + (Ord(Data[51]) SHL 1) +
                   (Ord(Data[52]) SHL 2) + (Ord(Data[53]) SHL 3) +
                   10 * (Ord(Data[54])   + (Ord(Data[55]) SHL 1) + 
                   (Ord(Data[56]) SHL 2) + (Ord(Data[57]) SHL 3));
  FDayOfWeek    := Ord(Data[42])         + (Ord(Data[43]) SHL 1) + 
                   (Ord(Data[44]) SHL 2);
  (* Paritätsprüfung *)
  Result := CheckParity(21, 28);                   (* Minute *)
  Result := Result AND CheckParity(29, 35);        (* Stunde *)
  Result := Result AND CheckParity(36, 58);        (* Datum  *)
  Result := Result AND (NOT Data[0]) AND Data[20]; (* Bit 0 muß 0 und Bit 20 muß 1 sein *)
  (* Jahrkorrektur (Y2K-konform) *)
  IF FYear > 79 THEN FYear := FYear + 1900
                ELSE FYear := FYear + 2000;
  (* Qualitätsprüfung *)
  IF Result THEN Inc(FQuality)
            ELSE FQuality := -1;
  IF FQuality > 0 THEN BEGIN  (* Vergleichswert ist vorhanden *)
    b := LSummerTime = FSummerTime;
    b := b AND (LHour = FHour) AND (LMinute + 1 = FMinute);
    b := b AND (LDay = FDay) AND (LMonth = FMonth) AND (LYear = FYear);
    b := b AND (LDayOfWeek = FDayOfWeek);
    IF NOT b THEN FQuality := 0;
  END;
  IF Result THEN BEGIN
    LSummerTime := FSummerTime;
    LHour       := FHour;
    LMinute     := FMinute;
    LDay        := FDay;
    LMonth      := FMonth;
    LYear       := FYear;
    LDayOfWeek  := FDayOfWeek;
  END;
  IF (FQuality = FQualityLimit) AND Assigned(FOnQualityAttained) THEN 
    QualityEvent := TRUE;
END;

PROCEDURE TExpertClock.ErrorTime;
(* Interne Zeitvariablen auf Fehlerzeit (1.1.1980 0:0:0) setzen *)
BEGIN
  FReserveTransmitter := FALSE;
  FSummerTime         := FALSE;
  FHour               := 0;
  FMinute             := 0;
  FSecond             := 0;
  FDay                := 1;
  FMonth              := 1;
  FYear               := 1980;
  FDayOfWeek          := 2;  (* ist ein Dienstag *)
  LSummerTime         := FALSE;
  LHour               := 0;
  LMinute             := 0;
  LDay                := 1;
  LMonth              := 1;
  LYear               := 1980;
  LDayOfWeek          := 2;  (* ist ein Dienstag *)
END;

PROCEDURE TExpertClock.SerPort1Cts(Sender: TObject);
(* Ein "Datenbyte" wurde empfangen (DCF-Signal) *)
VAR
  t : DWord;
  
  FUNCTION GetBit : BOOLEAN;
  (* Bit einlesen *)
  VAR
    d : BYTE;
  BEGIN
    WHILE SerPort.BufRec > 1 DO SerPort.ReceiveData(d, 1); (* Puffer leeren *)
    SerPort.ReceiveData(d, 1);
    Result := (d AND $F0) <> $F0;
  END;

BEGIN
  t := GetTickCount;  (* Zeitpunkt der Flanke erfassen *)
  IF Assigned(FOnDCFClock) THEN OnDCFClock(Self);
  CASE FStatus OF
    NoSignal      : BEGIN  (* Signal wurde jetzt erkannt *)
                      LastHi   := t;
                      FStatus  := Synchronizing;  (* neuer Status *)
                      BitCount := 0;
                      IF Assigned(FOnStatusChanged) THEN 
                        OnStatusChanged(Self);
                    END;
    Synchronizing : BEGIN  (* warten auf Minutenanfang *)
                      IF BitCount > 59 THEN BitCount := 0;
                      IF (t - LastHi > 1500) AND (t - LastHi < 2500) THEN BEGIN
                        (* Minutenanfang wurde erkannt *)
                        BitCount       := 0;
                        Data[BitCount] := GetBit;
                        Inc(BitCount);
                        FStatus := ReceiveData;  (* neuer Status *)
                        IF Assigned(FOnStatusChanged) THEN 
                          OnStatusChanged(Self);
                      END;
                      LastHi           := t;
                      TimerOut.Enabled := FALSE; (* TimeOut-Timer zurücksetzen *)
                      TimerOut.Enabled := TRUE;
                    END;
    ReceiveData   : BEGIN  (* Datenbits einlesen *)
                      IF BitCount > 59 THEN BitCount := 0;
                      IF t-LastHi > 1500 THEN BitCount := 0; (* Minutenanfang wurde erkannt *)
                      Data[BitCount] := GetBit;
                      Inc(BitCount);
                      LastHi := t;
                      IF BitCount = 59 THEN Timer59.Enabled := TRUE;
                      TimerOut.Enabled := FALSE;  (* TimeOut-Timer zurücksetzen *)
                      TimerOut.Enabled := TRUE;
                    END;
    TimeAvailable : BEGIN  (* Datenbits einlesen, Zeitinformationen aktualisieren *)
                      IF BitCount > 59 THEN BitCount := 0;
                      IF t - LastHi > 1500 THEN BitCount := 0;  (* Minutenanfang wurde erkannt *)
                      Data[BitCount] := GetBit;
                      Inc(BitCount);
                      FSecond := BitCount;
                      LastHi  := t;
                      IF BitCount = 59 THEN Timer59.Enabled := TRUE;  (* künstlicher Takt für 59. Sek. *)
                      IF Assigned(FOnTimeChanged) THEN OnTimeChanged(Self);
                      IF QualityEvent THEN BEGIN
                        OnQualityAttained(Self);
                        QualityEvent := FALSE;
                      END;
                      TimerOut.Enabled := FALSE;  (* TimeOut-Timer zurücksetzen *)
                      TimerOut.Enabled := TRUE;
                    END;
  END;
END;

PROCEDURE TExpertClock.Timer59Timer(Sender: TObject);
(* Künstliche Generierung der 59. Sekunde *)
VAR
  s : TDCFStatus;
BEGIN
  Timer59.Enabled := FALSE;
  FSecond         := 0;
  (* die neuen Daten auswerten *)
  s := FStatus;
  IF SetTimeParameters THEN FStatus := TimeAvailable
                       ELSE FStatus := NoSignal;
  IF Assigned(FOnTimeChanged) THEN OnTimeChanged(Self);
  IF FStatus < TimeAvailable THEN BEGIN  
    (* Zeitinformationen sind fehlerhaft *)
    FQuality := -1;
    ErrorTime;
  END;
  IF (s<>FStatus) AND Assigned(FOnStatusChanged) THEN 
    OnStatusChanged(Self);  (* über neuen Status informieren *)
  Inc(BitCount);
END;

PROCEDURE TExpertClock.TimerOutTimer(Sender: TObject);
(* Tritt dieses Timer-Ereignis ein, wird seit 3 Sek. kein *)
(* Signal mehr empfangen                                  *)
BEGIN
  TimerOut.Enabled := FALSE;
  FStatus          := NoSignal; (* neuer Status                 *)
  FQuality         := -1;       (* die Qualität ist beim Teufel *)
  ErrorTime;
  IF Assigned(FOnStatusChanged) THEN OnStatusChanged(Self);
END;

PROCEDURE Register;
{ Registrierung der Komponente }
BEGIN
  //RegisterComponents('Toolbox',[TExpertClock]);
END;

END.
