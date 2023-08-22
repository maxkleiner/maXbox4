(******************************************************************************)
(*                                                                            *)
(*   Komponenten                                                              *)
(*   TSerial, TSerPort, TSerStdDlg                                            *)
(*                                                                            *)
(*   Komponenten zur Daten�bertragung �ber die serielle Schnittstelle,        *)
(*   serielle Schnittstelle als I/O-Port,                                     *)
(*   Standarddialog zur Konfiguration einer Schnittstelle                     *)
(*                                                                            *)
(*   (c) 1998-2007  Rainer Reusch und Toolbox                                 *)
(*   (c) 1998-2007  Rainer Reusch und Computer & Literatur Verlag             *)
(*                                                                            *)
(*   Internet: http://reweb.fh-weingarten.de/toolbox/Projekte/Serial          *)
(*             http://www.toolbox-mag.de                                      *)
(*             http://www.cul.de                                              *)
(*                                                                            *)
(*   E-Mail:   toolbox@reusch-elektronik.de                                   *)
(*             jb@toolbox-mag.de                                              *)
(*                                                                            *)
(*   Borland Delphi 2.0, 3.0, 4.03, 5.0, 6.0, 7.0, BDS2006                    *)
(*   Borland C++ Builder 1.0, 3.0, 4.0, 5.0, 6.0                              *)
(*   Lazarus ab V0.9.6                                                        *)
(*                                                                            *)
(****V4.3***********************************************************Build 1****)

{
RECHTLICHES:
DIE KOMPONENTENSAMMLUNG "SERIAL" IST  URHEBERRECHTLICH  GESCH�TZT.  SIE DARF VON
LESERN DER ZEITSCHRIFT TOOLBOX UND LESERN DES  COMPUTER&LITERATUR-VERLAGES  OHNE
ENTRICHTUNG EINER LIZENZGEB�HR BENUTZT WERDEN. DAS  GILT  F�R  DIE  PRIVATE  UND
GEWERBLICHE  NUTZUNG.  DIE  WEITERGABE  ODER  DER  VERKAUF  DES  QUELLKODES ODER
DER DCU-DATEI IST VERBOTEN!
DIE PUBLIKATION DER QUELLTEXTE ERFOLGT "AS IS". F�R DIE EINHALTUNG ZUGESICHERTER
EIGENSCHAFTEN ODER F�R SCH�DEN, DIE DURCH DEN  EINSATZ  DER  KOMPONENTENSAMMLUNG
ENTSTANDEN SEIN K�NNTEN, �BERNEHMEN WEDER  DER  TOOLBOX-VERLAG,  DER  C&L-VERLAG
NOCH DER AUTOR JEGLICHE HAFTUNG. SIE NUTZEN DIE KOMPONENTENSAMMLUNG  AUF  EIGENE
GEFAHR!

LICENCE AGREEMENT:
THE COMPONENT COLLECTION "SERIAL" IS PROTECTED BY COPYRIGHT LAW.  IT IS NO FREE-
WARE! THIS COLLECTION CAN BE USED BY READERS OF THE  COMPUTER MAGAZINE 'TOOLBOX'
OR BY ANY OTHER READERS FROM THE COMPUTER & LITERATUR PUBLISHING COMPANY WITHOUT
ANY LICENCE FEE. THIS APPLIES THE  PRIVATE  AS WELL AS  COMMERCIAL USAGE.  IT IS
STRICTLY PROHIBITED TO COPY, DISTRIBUTE, OR SELL THE COMPONENT COLLECTION.
THE PUBLICATION OF  THE SOURCES  IS  MADE  "AS IS".  THERE  IS  NO  WARRANTY  OR
LIABILITY GIVEN FOR ADHERENCE,  ASSURED PROPERTIES,  OR DAMAGES  WHICH  MIGHT BE
CAUSED BY THE USE OF THIS SOFTWARE. USAGE IS ON YOUR OWN RISK!

�nderungen gegen�ber V1.0:
- Unterst�tzung aller vom Standarddialog angebotenen Baudraten
- Einstellungsdialog mit erweiterten M�glichkeiten
- ComboBox zur Schnittstellenauswahl

�nderungen gegen�ber V2.0:
- Neue Komponente TSerPort (serielle Schnittstelle als I/O-Port)
- Korrigierte Behandlung vorhandener Schnittstellen
- Korrekturen f�r Delphi 2.0

�nderungen gegen�ber V3.02:
- Die Empfangs- und Senderoutinen von TSerial wurden dahingehend
  erweitert, da� nun auch unter Windows NT die Anzahl der �bertragenen
  Datenbytes als Funktionsergebnis zur�ck geliefert wird.
- Die Deklaration der Methode TSerial.ReceiveData wurde ge�ndert.

�nderungen gegen�ber V3.1:
- Neue Eigenschaften RTSActive und DTRActive in der Komponente TSerial.
- Unterst�tzung der Baudraten 50 und 150 Baud in TSerial.
- M�glichkeit zur Festlegung eines Timeout beim Senden und Empfangen (TSerial).
- Thread-Synchronisierung zur Verhinderung eines Stack-Overflow (lt. Leserangabe).

�nderungen gegen�ber V3.2x:
- Delphi 4, 5 und weitere Versionen als Standard. Sonderbehandlung nun f�r
  �ltere Delphi-Versionen.
- Nun auch f�r Borland C++Builder 4 geeignet.
- TSerial: Thread-Synchronisierung nun �ber Eigenschaft w�hlbar (kein Stack-
  Overflow bei sehr langen �bertragungen oder bessere Performance).
- TSerial: Neue Eigenschaft EnableEvents. Damit l��t sich (vor�bergehend)
  global die Ereignisbehandlung deaktivieren.
- TSerial: Der auf Schnittstellenereignisse wartende Thread wird nur noch
  gestartet, wenn mindestens eine Behandlungsroutine zugeordnet ist (keine
  unn�tige Prozessorauslastung mehr, wenn keine Ereignisbehandlung fest-
  gelegt ist).
- TSerial: Die �bertragungsmethoden wurden als Prozeduralvariablen ausgef�hrt.
  Abh�ngig von der Plattform (95/98 oder NT) werden entsprechende Routinen
  zugeordnet. Bessere Performance.
- TSerExtDlg: Ungereimtheiten bei der Auswahl der Baudrate wurden behoben.

�nderungen gegen�ber V3.31
- In den Komponenten TSerSel, TSerExtDlg und TCOMComboBox wird das Fehlen von
  Schnittstellen nun korrekt behandelt.

�nderungen gegen�ber V3.32
- Im Formular TFormCOMSetup (Komponente TSerExtDlg) wurden die Komponenten
  TSpinButton durch TUpDown ersetzt. Damit ist die Komponentensammlung auch f�r
  alle Versionen des C++Builder geeignet.
- Formal nun eine Unterst�tzung bis COM99.
- TSerial: Neue Methoden SetConfig, GetConfig, ConfigToStr, StrToConfig zum
  Speichern und Wiederherstellen von Schnittstellen-Einstellungen.

�nderungen gegen�ber V3.4
- Beseitigung eines Fehlers in TSerPort: Die Eigenschaft Active wird nun auch
  beim Aufruf von OpenComm gesetzt. Damit ist das Schlie�en m�glich.

�nderungen gegen�ber V3.41
- TSerial: Neue Funktion Purge zum Anhalten der �bertragung und L�schen der
  Puffer.
- Variablen und Methoden im Private-Teil von TCustomSerial wurden in den
  Protected-Teil verschoben. Notwendig f�r einwandfreie Funktion unter dem
  C++Builder.
- TSerial: �nderung in RText_95 und RText_NT. ReadFile wird nur noch aufgerufen,
  wenn sich tats�chlich Zeichen im Empfangspuffer befinden. Ma�nahme verhindert
  eine Exception bei leerem Empfangspuffer und dem Versuch, Zeichen ein zu lesen.
- Die neuen Funktionen LastCOM und COMAvailable.

�nderungen gegen�ber V3.5
- Saubere Einbindung der Komponentensammlung unter CLX von Delphi 6.

�nderungen gegen�ber V3.6
- Neues Konzept der Pr�fung vorhandener serieller Schnittstellen
  Durch einen manuellen Aufruf der Prozedur InitSerial wird explizit
  auf eine angegebene Anzahl Schnittstellen gepr�ft.
- TSerial: Eigenschaft SyncWait
  Das Warten beim Senden und Empfangen kann nun abgeschaltet werden.
  Beim Senden nur auf der NT-Plattform von Bedeutung (�bertragung im Hintergrund).
- TSerial: Verbesserungen bei der Methode ReceiveData

�nderungen gegen�ber V3.7
- Neue Aufteilung der Units. Unit Serial enth�lt nur noch TSerial, TSerPort
  und TSerStdDlg.
- Keine explizite Unterscheidung mehr zwischen VCL und CLX
- Abfrage, ob gesendet werden kann (Abfrage der Handshake-Leitungen bei
  Hardwire-Handshake)
- TSerial und TSerPort: Neue Methode PortByIndex
- TSerial und TSerPort: Eigenschaft Ports wurde in den Public-Bereich verschoben.
- Fehlerbeseitigung in Eigenschaft TCustomSerial.Ports. Inhalt ist nun korrekt.

�nderungen gegen�ber V4.0
- Zentrale Schnittstellenverwaltung in eigener Klasse.
  Das Hinzukommen oder Verschwinden von Schnittstellen wird erkannt.
- TSerial und TSerPort: Ereignis, wenn ge�ffnete Schnittstelle entfernt
  worden ist.
- TSerial: Neues Ereignis OnData (bestimmte Datenmenge im Empfangspuffer)
- TSerial: Baudrate 28800
- TSerial.CanTransmitt: Sind beide Hardwire-Handshakes aktiviert, liefert
  die Eigenschaft nun nur noch true, wenn beide Handshake-Eing�nge Sendebereit-
  schaft signalisieren.
- TSerPort: Neue Eigenschaft Out_TxD (TxD-Ausgang als Port)
- TSerPort: Out_Rts und Out_Dtr optimiert und daher etwas schneller.
- Wieder aufgetauchter Fehler bei Schnittstellen ab COM10 behoben.
- Fehler in TSerial behoben: Keine Schutzverletzung mehr, wenn eine Sende-/
  Empfangsroutine vor erstmaligem �ffnen der Schnittstelle aufgerufen wird.
- Unterstuetzung von Lazarus (v0.9.6), mit Einschraenkung

�nderungen gegen�ber V4.1
- COMManager.CheckPorts: Die Erkennung von Schnittstellen �ber COM9 wurde
  optimiert.

�nderungen gegen�ber V4.11
- COMManager: Das Fenster zum Empfang system�bergreifender Botschaften wird nun
  direkt �ber das Windows-API erzeugt. Die VCL/CLX wird nun nicht mehr durch
  die Komponente eingeschleppt. Die Erkennung hinzugef�gter und entfernter
  Schnittstellen funktioniert jetzt auch unter Lazarus.
- COMManager: Registrierung von Feedback-Prozeduren.  
- TSerial: Die Baudrate kann nun frei gew�hlt werden (soweit das technisch
  m�glich ist). Die Eigenschaft Baudrate ist nun vom Typ "integer".
  Hinweis: Der Datensatz der seriellen Konfigurationsdaten hat sich ge�ndert!
- TSerial: Die Vorgaben bei BufSizeRec, BufSizeTrm, XOffLimit und XOnLimit
  wurden ge�ndert. Minimale Puffergr��en nun 4096 Byte.
- TSerStdDlg: Fehler behoben. Dialog erscheint nun auch bei Schnittstellen �ber
  COM9.

�nderungen gegen�ber V4.2
- TSerial: Fehler in StrToConfig korrigiert.
- TSerial: Basiswert f�r Timeout-Festlegung heraufgesetzt, wg. Problem bei
  niedrigen Baudraten.

Hinweise:
---------
Es wird automatisch bis COM4 (entsprechend Konstante MaxPort) auf vorhandene
Schnittstellen gepr�ft. Sollen Schnittstellen h�herer Nummer genutzt werden
k�nnen, mu� die Methode COMManager.CheckPorts unter Angabe der Schnittstellen-
nummer, bis zu der gepr�ft werden soll, aufgerufen werden. Es werden Schnitt-
stellen bis COM99 unterst�tzt. Der Aufruf dieser Methode ist jederzeit m�glich,
um die Zahl unterst�tzter Schnittstellen zu erweitern. Bereits gepr�fte
Schnittstellen werden dabei nicht erneut gepr�ft (Zeitersparnis). �ndern sich
die vorhandenen Schnittstellen, wird erneut automatisch auf vorhandene
Schnittstellen gepr�ft und ggf. das entsprechende Ereignis ausgel�st.

Delphi 6 und CLX-Anwendungen:
Die Komponentensammlung ist unter VCL und CLX einsetzbar.

Lazarus:
Bei Lazarus muss die Compiler-Direktive "LAZARUS" aktiviert werden.
}

{ $DEFINE LAZARUS}  { Lazarus }

{$IFDEF VER90}  {$DEFINE OLDDELPHI} {$ENDIF}  { Delphi 2 }
{$IFDEF VER100} {$DEFINE OLDDELPHI} {$ENDIF}  { Delphi 3 }
{$IFDEF VER93}  {$DEFINE OLDDELPHI} {$ENDIF}  { C++Builder 1 }
{$IFDEF VER110} {$DEFINE OLDDELPHI} {$ENDIF}  { C++Builder 3 }

unit Serial;

{$IFNDEF OLDDELPHI}
  {$J+}
{$ENDIF}

{$IFDEF LAZARUS}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  // In COMManager.Ports verwaltete Informationen zur Schnittstelle
  TCustomSerial = class;
  TCOMInfo = record
    Number    : integer;        // Schnittstellennummer (z.B. "2" bei COM2)
    Instance  : TCustomSerial;  // Enth�lt Zeiger auf Instanz, wenn Schnittstelle ge�ffnet
  end;
  PCOMInfo = ^TCOMInfo;
  // Registrierbare R�ckmelde-Prozeduren (bei Ver�nderungen der vorhandenen Schnittstellen)
  TFeedbackProc = procedure of object;
  PFeedback = ^TFeedback;  // Listeneintr�ge
  TFeedback = record
    Proc : TFeedbackProc;
    Next : PFeedback;
  end;
  // unsichtbares Fenster (f�r system�bergreifende Botschaften)
  TObjProc  = procedure (Message, wParam, lParam : longint) of object;
  TMsgWindow = class
  private
    WindowClass: TWndClass;
  public
    CName  : array[0..255] of char;
    Handle : THandle;
    TheObjProc : TObjProc;
    constructor Create(Name : string; MsgProc : TObjProc); virtual;
    destructor Destroy; override;
  end;
  // zentrale Schnittstellen-Verwaltung (wird automatisch instanziiert)
  TCOMManager = class
  private
    FCheckedPorts  : integer;       // Nummer der Schnittstelle, bis zu deren Existenz gepr�ft wurde
    FPorts         : TStringList;   // Liste der gefundenen seriellen Schnittstellen
    FOnPortAdded   : TNotifyEvent;  // Schnittstelle kam hinzu
    FOnPortRemoved : TNotifyEvent;  // Schnittstelle wurde entfernt
    Feedback       : PFeedback;     // Liste registrierter R�ckmelde-Prozeduren
    MsgWindow      : TMsgWindow;    // unsichtbares Fenster f�r Botschaften
    procedure WinProc(Message, wParam, lParam : longint);  // Botschaftsverarbeitung
    function FeedbackExists(Proc : TFeedbackProc) : boolean;  // pr�ft, ob Eintrag in der Liste schon vorhanden
   public
    constructor Create;   // Konstruktor
    destructor  Destroy; override; // Destruktor
    procedure CheckPorts(ToPort : integer);
    function RecheckPorts : boolean;
    function PortExists(Port : integer) : boolean;
    function Port2Index(Port : integer) : integer;
    procedure RegisterFeedback(Proc : TFeedbackProc);
    procedure UnregisterFeedback(Proc : TFeedbackProc);
    procedure AssignCOM(Instance : TCustomSerial);
    property CheckedPorts : integer read FCheckedPorts;
    property Ports : TStringList read FPorts;  // Liste der verf�gbaren Schnittstellen
    // Ereignisse
    property OnPortAdded : TNotifyEvent read FOnPortAdded write FOnPortAdded;  // parallele/serielle Schnittstelle kam hinzu
    property OnPortRemoved : TNotifyEvent read FOnPortRemoved write FOnPortRemoved;  // parallele/serielle Schnittstelle wurde entfernt
  end;

  // �bertragungsparameter
  TDataBits   = (db_4,db_5,db_6,db_7,db_8);
  TParityBit  = (none,odd,even,mark,space);
  TStopBits   = (sb_1,sb_15,sb_2);

  // TSerial-Konfigurationsdatensatz
  TSerialConfig = record
    Valid : boolean;             // true: Parameter sind g�ltig
    COMPort : integer;           // Schnittstelle
    Baudrate : integer;          // �bertragungsrate (ge�ndert ab V4.2)
    DataBits : TDataBits;        // Anzahl Datenbits
    ParityBit : TParityBit;      // Parit�tsbit
    StopBits : TStopBits;        // Anzahl Stoppbits
    BufSizeTrm : integer;        // Gr��e des Sendepuffers
    BufSizeRec : integer;        // Gr��e des Empfangspuffers
    HandshakeRtsCts : boolean;   // Hardwire-Handshake RTS/CTS
    HandshakeDtrDsr : boolean;   // Hardwire-Handshake DTR/DSR
    HandshakeXOnXOff : boolean;  // Handshake XOn/XOff-Protokoll
    RTSActive : boolean;         // RTS-Ausgang aktiv setzen (wenn nicht zum Handshake benutzt)
    DTRActive : boolean;         // DTR-Ausgang aktiv setzen (wenn nicht zum Handshake benutzt)
    XOnChar : char;              // XOn-Zeichen
    XOffChar : char;             // XOff-Zeichen
    XOffLimit : integer;         // XOff-Limit
    XOnLimit : integer;          // XOn-Limit
    ErrorChar : char;            // Fehlerersatzzeichen
    EofChar : char;              // EOF-Zeichen
    EventChar : char;            // Ereigniszeichen
    ContinueOnXOff : boolean;    // �bertragung fortsetzen auch bei XOff
    UseErrorChar : boolean;      // Fehlerersatzzeichen verwenden
    EliminateNullChar : boolean; // Nullzeichen entfernen
    AbortOnError : boolean;      // bei Fehler abbrechen
    RecTimeOut : integer;        // Timeout (ms) f�r Datenempfang (0=kein Timeout)
    TrmTimeOut : integer;        // Timeout (ms) f�r Daten�bertragung (0=kein Timeout)
  end { record };

  TSerial = class;
  // Thread f�r Daten�bertragung im Hintergrund (von TSerial ben�tigt)
  TSerThread = class(TThread)
    constructor Create(SerComp : TSerial);
    procedure Execute;  override;
  private
    {$IFDEF OLDDELPHI}
    Event : integer;
    {$ELSE}
    Event : cardinal;
    {$ENDIF}
    Serial : TSerial;
    procedure EventHandling;
  end;

  // Thread f�r Handshake-Eing�nge (von TSerPort ben�tigt)
  TSerPort = class;
  TSerPortThread = class(TThread)
    constructor Create(SerComp : TSerPort);
    procedure Execute;  override;
  private
    Serial : TSerPort;
  end;

  // --- Basiskomponente TCustomSerial ---
  TCustomSerial = class(TComponent)
  private
    procedure PanicClose; virtual;                     // Schnittstelle ging verloren
  protected
    FActive            : boolean;          // true: Schnittstelle ge�ffnet/�ffnen
    FCOMPort           : integer;          // zu �ffnende Schnittstelle (1..), 0 wenn keine vorhanden
    FSerHandle         : THandle;          // Handle der ge�ffneten Schnittstelle
    FBufSizeTrm        : integer;          // Gr��e des Sendepuffers
    FBufSizeRec        : integer;          // Gr��e des Empfangspuffers
    FThreadPriority    : TThreadPriority;  // Priorit�t des im Hintergrund laufenden Thread
    FOnCOMRemoved      : TNotifyEvent;     // Ereignis: Schnittstelle wurde entfernt
    Overlapped         : TOverlapped;      // ben�tigter Overlapped-Record
    dcb                : TDCB;             // Device Control Block
    procedure SetCOMPort(Value : integer); // Schnittstelle ausw�hlen
  public
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    destructor  Destroy; override;                     // Destruktor
    procedure PortByIndex(Index : integer);            // Schnittstelle aus Liste vorhandener Schnittstellen
    property SerHandle : THandle read FSerHandle;      // Schnittstellen-Handle
  published
    property COMPort : integer read FCOMPort write SetCOMPort;                  // zu verwendende Schnittstelle (1..)
    property ThreadPriority : TThreadPriority read FThreadPriority write FThreadPriority;  // Priorit�t des Thread
    property OnCOMRemoved : TNotifyEvent read FOnCOMRemoved write FOnCOMRemoved; // Ereignis: Schnittstelle wurde entfernt
  end;

  // --- Komponente TSerial ---
  TRText = function : string of object;                                   // Textempfang
  {$IFDEF OLDDELPHI}
  TTData = function (var Data; DataSize : integer) : integer of object;   // Daten senden
  TRData = function (var Buf; BufSize : integer) : integer of object;     // Datenempfang
  TTText = function (s : string) : integer of object;                     // Text senden
  {$ELSE}
  TTData = function (var Data; DataSize : cardinal) : cardinal of object; // Daten senden
  TRData = function (var Buf; BufSize : cardinal) : cardinal of object;   // Datenempfang
  TTText = function (s : string) : cardinal of object;                    // Text senden
  {$ENDIF}

  TSerial = class(TCustomSerial)
  private
    { Private-Deklarationen }
    IsNT               : boolean;          // true, wenn Windows NT vorliegt
    FBaudrate          : integer;          // �bertragungsrate (ge�ndert ab V4.2)
    FDataBits          : TDataBits;        // Anzahl Datenbits
    FParityBit         : TParityBit;       // Parit�tsbit
    FStopBits          : TStopBits;        // Anzahl Stopp-Bits
    FHandshakeRtsCts   : boolean;          // true: Hardwire-Handshake RTS/CTS
    FHandshakeDtrDsr   : boolean;          // true: Hardwire-Handshake DTR/DSR
    FHandshakeXOnXOff  : boolean;          // true: Handshake nach XOn/XOff-Protokoll
    FRTSActive         : boolean;          // true: RTS-Leitung aktiv (wenn nicht f�r Handshake verwendet)
    FDTRActive         : boolean;          // true: DTR-Leitung aktiv (wenn nicht f�r Handshake verwendet)
    FXOnChar           : char;             // XOn-Zeichen
    FXOffChar          : char;             // XOff-Zeichen
    FXOffLimit         : integer;          // XOff-Limit (nicht gr��er als FBufSizeRec)
    FXOnLimit          : integer;          // XOn-Limit (nicht gr��er als XOff-Limit)
    FErrorChar         : char;             // Fehlerersatzzeichen (wenn UseErrorChar)
    FEofChar           : char;             // End-Of-File-Zeichen
    FEventChar         : char;             // Ereignis-Zeichen
    FDataSize          : integer;          // Umfang empfangener Daten f�r Ereignis OnData
    FParityCheck       : boolean;          // true: Parit�tspr�fung (Parit�tsbit einstellen!)
    FContinueOnXOff    : boolean;          // true: �bertragung auch bei XOff fortsetzen
    FUseErrorChar      : boolean;          // true: Fehlerersatzzeichen verwenden
    FEliminateNullChar : boolean;          // true: Null-Zeichen entfernen
    FAbortOnError      : boolean;          // true: Bei Fehler abbrechen
    FRecTimeOut,                           // Timeout (ms) f�r Datenempfang (0=kein Timeout)
    FTrmTimeOut        : integer;          // Timeout (ms) f�r daten�bertragung (0=kein Timeout)
    FSyncEventHandling : boolean;          // true: Ereignisbehandlung erfolgt Thread-synchronisiert
    FEnableEvents      : boolean;          // false: Schnittstellenereignisse werden ignoriert
    FSyncWait          : boolean;          // true: Sende-/Empfangsroutinen kehren erst zur�ck, wenn fertig. Nur NT.
    FOnBreak           : TNotifyEvent;     // UART-Ereignis EV_BREAK
    FOnCts             : TNotifyEvent;     // UART-Ereignis EV_CTS
    FOnDsr             : TNotifyEvent;     // UART-Ereignis EV_DSR
    FOnError           : TNotifyEvent;     // UART-Ereignis EV_ERROR
    FOnRing            : TNotifyEvent;     // UART-Ereignis EV_RING
    FOnDcd             : TNotifyEvent;     // UART-Ereignis EV_RLSD
    FOnRxChar          : TNotifyEvent;     // UART-Ereignis EV_RXCHAR
    FOnEventChar       : TNotifyEvent;     // UART-Ereignis EV_RXFLAG
    FOnTxEmpty         : TNotifyEvent;     // UART-Ereignis EV_TXEMPTY
    FOnData            : TNotifyEvent;     // UART-Ereignis EV_RXCHAR mit Umfang empfangener Daten
    SerThread          : TSerThread;       // Thread f�r Datentransfer im Hintergrund
    procedure SetActive(Value : boolean);      // �ffnen/schlie�en
    procedure SetBaudrate(Value : integer);    // �bertragungsrate setzen
    procedure SetParityBit(Value : TParityBit);// Parit�tsbit setzen
    procedure SetBufSizeTrm(Value : integer);  // Gr��e des Sendepuffers setzen
    procedure SetBufSizeRec(Value : integer);  // Gr��e des Empfangspuffers setzen
    procedure SetXOffLimit(Value : integer);   // XOff-Limit setzen
    procedure SetXOnLimit(Value : integer);    // XOn-Limit setzen
    procedure SetRecTimeOut(Value : integer);  // Timeout beim Empfang
    procedure SetTrmTimeOut(Value : integer);  // Timeout beim Senden
    function GetBufTrm : integer;              // Anzahl Zeichen, die sich noch im Sendepuffer befinden
    function GetBufRec : integer;              // Anzahl Zeichen, die sich im Empfangspuffer befinden
    function GetCanTransmitt : boolean;        // Pr�fen, ob Handshake senden erlaubt
    procedure SetDataSize(Value : integer);    // Datenmenge f�r OnData festlegen
    function OpenIt : boolean;                 // Schnittstelle �ffnen, Thread starten
    procedure CloseIt;                         // Schnittstelle schlie�en, Thread beenden
    procedure PanicClose; override;            // Schnittstelle ging verloren
    procedure DataInBuffer(var InQueue, OutQueue : integer);  // Ermitteln, wieviele Zeichen sind im Sende-/Empfangspuffer befinden
    function RText_00 : string; virtual;                                   // Text empfangen
    function RText_95 : string; virtual;
    function RText_NT : string; virtual;
    {$IFDEF OLDDELPHI}
    function TData_00(var Data; DataSize : integer) : integer; virtual;    // Daten senden (Dummy)
    function TData_95(var Data; DataSize : integer) : integer; virtual;    // Daten senden (Win 95/98)
    function TData_NT(var Data; DataSize : integer) : integer; virtual;    // Daten senden (Win NT)
    function RData_00(var Buf; BufSize : integer) : integer; virtual;      // Daten empfangen
    function RData_95(var Buf; BufSize : integer) : integer; virtual;
    function RData_NT(var Buf; BufSize : integer) : integer; virtual;
    function TText_00(s : string) : integer; virtual;                      // Text senden
    function TText_95(s : string) : integer; virtual;
    function TText_NT(s : string) : integer; virtual;
    {$ELSE}
    function TData_00(var Data; DataSize : cardinal) : cardinal; virtual;
    function TData_95(var Data; DataSize : cardinal) : cardinal; virtual;
    function TData_NT(var Data; DataSize : cardinal) : cardinal; virtual;
    function RData_00(var Buf; BufSize : cardinal) : cardinal; virtual;
    function RData_95(var Buf; BufSize : cardinal) : cardinal; virtual;
    function RData_NT(var Buf; BufSize : cardinal) : cardinal; virtual;
    function TText_00(s : string) : cardinal; virtual;
    function TText_95(s : string) : cardinal; virtual;
    function TText_NT(s : string) : cardinal; virtual;
    {$ENDIF}
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    TransmittData : TTData;  // Daten senden
    ReceiveData : TRData;    // Daten empfangen
    TransmittText : TTText;  // Text senden
    ReceiveText : TRText;    // Text empfangen
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    destructor  Destroy; override;                     // Destruktor
    function OpenComm : boolean; virtual;   // Schnittstelle �ffnen
    procedure CloseComm; virtual;           // Schnittstelle schlie�en
    function SendSerialData(Data: TByteArray; DataSize : cardinal): cardinal; // Daten senden mX3
    function ReceiveSerialData(var Buf: TByteArray; BufSize : cardinal): cardinal;   // Datenempfang
    function SendSerialText(Data: String): cardinal; // Daten senden mX3
    function ReceiveSerialText: string; // Daten senden mX3


    function Purge(TxAbort,RxAbort,TxClear,RxClear : boolean) : boolean;        // �bertragung abbrechen, Puffer l�schen
    procedure SetConfig(SerialConfig : TSerialConfig); virtual;                 // Einstellungen setzen
    function GetConfig : TSerialConfig; virtual;                                // Einstellungen ermitteln
    function ConfigToStr(SerialConfig : TSerialConfig) : string; virtual;       // Konfigurationsdaten in String umwandeln
    function StrToConfig(CfgStr : string) : TSerialConfig; virtual;             // Konfigurationsstring in Record umwandeln
    property BufTrm : integer read GetBufTrm;                                   // Anzahl Zeichen im Sendepuffer
    property BufRec : integer read GetBufRec;                                   // Anzahl Zeichen im Empfangspuffer
    property CanTransmitt : boolean read GetCanTransmitt;                       // Abfrage, ob Handshake senden erlaubt
  published
    { Published-Deklarationen }
    // Eigenschaften
    property Active : boolean read FActive write SetActive;                     // Schnittstelle �ffnen/schlie�en
    property Baudrate : integer read FBaudrate write SetBaudrate;               // �bertragungsrate
    property DataBits : TDataBits read FDataBits write FDataBits;               // Anzahl datenbits
    property ParityBit : TParityBit read FParityBit write SetParityBit;           // Parit�tsbit
    property StopBits : TStopBits read FStopBits write FStopBits;               // Anzahl Stoppbits
    property BufSizeTrm : integer read FBufSizeTrm write SetBufSizeTrm;         // Gr��e des Sendepuffers
    property BufSizeRec : integer read FBufSizeRec write SetBufSizeRec;         // Gr��e des Empfangspuffers
    property HandshakeRtsCts : boolean read FHandshakeRtsCts write FHandshakeRtsCts;     // Hardwire-Handshake RTS/CTS
    property HandshakeDtrDsr : boolean read FHandshakeDtrDsr write FHandshakeDtrDsr;     // Hardwire-Handshake DTR/DSR
    property HandshakeXOnXOff : boolean read FHandshakeXOnXOff write FHandshakeXOnXOff;  // Handshake XOn/XOff-Protokoll
    property RTSActive : boolean read FRTSActive write FRTSActive;              // RTS-Ausgang aktiv setzen (wenn nicht zum Handshake benutzt)
    property DTRActive : boolean read FDTRActive write FDTRActive;              // DTR-Ausgang aktiv setzen (wenn nicht zum Handshake benutzt)
    property XOnChar : char read FXOnChar write FXOnChar;                       // XOn-Zeichen
    property XOffChar : char read FXOffChar write FXOffChar;                    // XOff-Zeichen
    property XOffLimit : integer read FXOffLimit write SetXOffLimit;            // XOff-Limit
    property XOnLimit : integer read FXOnLimit write SetXOnLimit;               // XOn-Limit
    property ErrorChar : char read FErrorChar write FErrorChar;                 // Fehlerersatzzeichen
    property EofChar : char read FEofChar write FEofChar;                       // EOF-Zeichen
    property EventChar : char read FEventChar write FEventChar;                 // Ereigniszeichen
    property DataSize : integer read FDataSize write SetDataSize;                 // Level f�r Ereignis OnData
    property ParityCheck : boolean read FParityCheck;                           // Parit�tspr�fung verwenden
    property ContinueOnXOff : boolean read FContinueOnXOff write FContinueOnXOff;  // �bertragung fortsetzen auch bei XOff
    property UseErrorChar : boolean read FUseErrorChar write FUseErrorChar;     // Fehlerersatzzeichen verwenden
    property EliminateNullChar : boolean read FEliminateNullChar write FEliminateNullChar;  // Nullzeichen entfernen
    property AbortOnError : boolean read FAbortOnError write FAbortOnError;     // bei Fehler abbrechen
    property RecTimeOut : integer read FRecTimeOut write SetRecTimeOut;         // Timeout (ms) f�r Datenempfang (0=kein Timeout)
    property TrmTimeOut : integer read FTrmTimeOut write SetTrmTimeOut;         // Timeout (ms) f�r Daten�bertragung (0=kein Timeout)
    property SyncEventHandling : boolean read FSyncEventHandling write FSyncEventHandling;  // true: Ereignisbehandlung �ber Synchronize-Aufruf
    property EnableEvents : boolean read FEnableEvents write FEnableEvents;     // false: Schnittstellenereignisse (vor�bergehend) ignorieren
    property SyncWait : boolean read FSyncWait write FSyncWait;                 // true: Sende-/Empfangsroutinen kehren erst zur�ck, wenn fertig. Nur NT.
    // Ereignisse
    property OnBreak : TNotifyEvent read FOnBreak write FOnBreak;               // UART-Ereignis EV_BREAK
    property OnCts : TNotifyEvent read FOnCts write FOnCts;                     // UART-Ereignis EV_CTS
    property OnDsr : TNotifyEvent read FOnDsr write FOnDsr;                     // UART-Ereignis EV_DSR
    property OnError : TNotifyEvent read FOnError write FOnError;               // UART-Ereignis EV_ERROR
    property OnRing : TNotifyEvent read FOnRing write FOnRing;                  // UART-Ereignis EV_RING
    property OnDcd : TNotifyEvent read FOnDcd write FOnDcd;                     // UART-Ereignis EV_RLSD
    property OnRxChar : TNotifyEvent read FOnRxChar write FOnRxChar;            // UART-Ereignis EV_RXCHAR
    property OnEventChar : TNotifyEvent read FOnEventChar write FOnEventChar;   // UART-Ereignis EV_RXFLAG
    property OnTxEmpty : TNotifyEvent read FOnTxEmpty write FOnTxEmpty;         // UART-Ereignis EV_TXEMPTY
    property OnData : TNotifyEvent read FOnData write FOnData;                  // UART-Ereignis EV_RXCHAR mit Datenmenge
  end;

  // --- Komponente TSerPort ---
  TSerPort = class(TCustomSerial)
  private
    FOut_DTR : boolean;  // Grundstellung: false (+12V)
    FOut_RTS : boolean;  // Grundstellung: false (+12V)
    FOut_TxD : boolean;  // Grundstellung: true (-12V)
    FIn_DCD,
    FIn_DSR,
    FIn_CTS,
    FIn_RI   : boolean;
    FOnCts             : TNotifyEvent;     // UART-Ereignis EV_CTS
    FOnDsr             : TNotifyEvent;     // UART-Ereignis EV_DSR
    FOnRing            : TNotifyEvent;     // UART-Ereignis EV_RING
    FOnDcd             : TNotifyEvent;     // UART-Ereignis EV_RLSD
    FPollingMode       : boolean;          // Betrieb im Polling Mode (kein IRQ erforderlich)
    IsPolling          : boolean;
    SerPortThread          : TSerPortThread;   // Thread f�r Datentransfer im Hintergrund
    procedure SetActive(Value : boolean);      // �ffnen/schlie�en
    procedure SetOutDtr(Value : boolean);      // DTR-Ausgang
    procedure SetOutRts(Value : boolean);      // RTS-Ausgang
    procedure SetOutTxD(Value : boolean);      // TxD-Ausgang
    function GetInDCD : boolean;               // DCD-Eingang
    function GetInDSR : boolean;               // DSR-Eingang
    function GetInCTS : boolean;               // CTS-Eingang
    function GetInRI : boolean;                // RI-Eingang
    function OpenIt : boolean;                 // Schnittstelle �ffnen, Thread starten
    procedure CloseIt;                         // Schnittstelle schlie�en, Thread beenden
    procedure PanicClose; override;            // Schnittstelle ging verloren
  protected
    { Protected-Deklarationen }
  public
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    destructor  Destroy; override;                     // Destruktor
    function OpenComm : boolean; virtual;   // Schnittstelle �ffnen
    procedure CloseComm; virtual;           // Schnittstelle schlie�en
  published
    // Eigenschaften
    property Active : boolean read FActive write SetActive;                     // Schnittstelle �ffnen/schlie�en
    property Out_DTR : boolean read FOut_DTR write SetOutDtr;
    property Out_RTS : boolean read FOut_RTS write SetOutRts;
    property Out_TxD : boolean read FOut_TxD write SetOutTxD;
    property In_DCD : boolean read GetInDCD;
    property In_DSR : boolean read GetInDSR;
    property In_CTS : boolean read GetInCTS;
    property In_RI : boolean read GetInRI;
    property PollingMode : boolean read FPollingMode write FPollingMode;
    // Ereignisse
    property OnCts : TNotifyEvent read FOnCts write FOnCts;                     // UART-Ereignis EV_CTS
    property OnDsr : TNotifyEvent read FOnDsr write FOnDsr;                     // UART-Ereignis EV_DSR
    property OnRing : TNotifyEvent read FOnRing write FOnRing;                  // UART-Ereignis EV_RING
    property OnDcd : TNotifyEvent read FOnDcd write FOnDcd;                     // UART-Ereignis EV_RLSD
  end;

  // --- Komponente TSerStdDlg ---
  TSerStdDlg = class(TComponent)
  private
    { Private-Deklarationen }
    FSerial  : TSerial;
    cc : TCommConfig;
  protected
    { Protected-Deklarationen }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    function Execute : boolean;  // Dialog anzeigen
  published
    { Published-Deklarationen }
    // Eigenschaften
    property Serial : TSerial read FSerial write FSerial;  // zugeordnete Komponente
  end;

procedure Register;

const
  MaxPort      = 4;  { Bei automatischer Initialisierung wird bis COM4 gepr�ft }
  MaxSupported = 99; { Unterst�tzung bis COM99 }
  // Standard-�bertragungsraten
  br_000050 = 50;
  br_000110 = 110;
  br_000150 = 150;
  br_000300 = 300;
  br_000600 = 600;
  br_001200 = 1200;
  br_002400 = 2400;
  br_004800 = 4800;
  br_009600 = 9600;
  br_014400 = 14400;
  br_019200 = 19200;
  br_028800 = 28800;
  br_038400 = 38400;
  br_056000 = 56000;
  br_057600 = 57600;
  br_115200 = 115200;
  br_128000 = 128000;
  br_230400 = 230400;
  br_256000 = 256000;
  br_460800 = 460800;
  br_921600 = 921600;
  ParityNames : array[0..4] of string =
    ('none','odd','even','mark','space');
  StopbitsNames : array[0..2] of string =
    ('1','1,5','2');

var
  COMManager : TCOMManager;

implementation

type
  // Verwaltung der Fenster
  PWindowList = ^TWindowList;
  TWindowList = record
    Handle   : THandle;
    TheClass : TMsgWindow;
    Next     : PWindowList;
  end;

var
  WindowList : PWindowList;  // Fensterliste

const
  SerCfgID  : array[0..3] of char = 'RRS1';  // ID f�r Konfigurationsstring TSerial (Version 1) (ge�ndert ab V4.2)
  // WM_DEVICECHANGE: Ereignisse
  DBT_DEVICEARRIVAL           = $8000;  // system detected a new device
  DBT_DEVICEQUERYREMOVE       = $8001;  // wants to remove, may fail
  DBT_DEVICEQUERYREMOVEFAILED = $8002;  // removal aborted
  DBT_DEVICEREMOVEPENDING     = $8003;  // about to remove, still avail.
  DBT_DEVICEREMOVECOMPLETE    = $8004;  // device is gone
  DBT_DEVICETYPESPECIFIC      = $8005;  // type specific event
  DBT_CUSTOMEVENT             = $8006;  // user-defined event
  // WM_DEVICECHANGE: Ger�tetypen
  DBT_DEVTYP_OEM              = $00000000;  // oem-defined device type
  DBT_DEVTYP_DEVNODE          = $00000001;  // devnode number
  DBT_DEVTYP_VOLUME           = $00000002;  // logical volume
  DBT_DEVTYP_PORT             = $00000003;  // serial, parallel
  DBT_DEVTYP_NET              = $00000004;  // network resource
  DBT_DEVTYP_DEVICEINTERFACE  = $00000005;  // device interface class
  DBT_DEVTYP_HANDLE           = $00000006;  // file system handle
  // Quarzfrequenz (Basis f�r die Berechnung realer �bertragungsraten)
  fBaud = 115200*16*5;  // 9,216MHz
  // Basiswert f�r die Festlegung von Timeout-Werten
  TimeoutBase = 12000;

(******************************************************************************)
(*** TMsgWindow                                                             ***)
(******************************************************************************)

{$IFDEF LAZARUS}
function WindowProc(Window, Message : LongWord;
  WParam, LParam : LongInt): Longint; stdcall;
{$ELSE}
function WindowProc(Window : HWnd; Message, WParam : Word;
  LParam : Longint): Longint; stdcall;
{$ENDIF}
// zentrale Botschaftsverarbeitung f�r die hier angelegten Fenster
var
  p, q : PWindowList;
begin
  // Dispatch (Botschaft an Fenster weiter leiten)
  p:=WindowList;
  q:=nil;
  while (p<>nil) and (q=nil) do
  begin
    if p^.Handle=Window then q:=p;
    p:=p^.Next;
  end;
  if q<>nil then  // Aufruf der Botschaftsverarbeitungsroutine
    q^.TheClass.TheObjProc(Message,WParam,LParam);
  // Standardverarbeitung
  Result:=DefWindowProc(Window,Message,WParam,LParam);
end;

constructor TMsgWindow.Create(Name : string; MsgProc : TObjProc);
// Konstruktor
var
  i : integer;
  Ok : boolean;
  p, w : PWindowList;
begin
  inherited Create;
  TheObjProc:=MsgProc;
  // Verarbeitung der Parameter
  Handle:=0;
  if Length(Name)>0 then
  begin
    for i:=0 to Length(Name)-1 do CName[i]:=Name[i+1];
    CName[Length(Name)]:=#0;
    Ok:=true;
  end
  else Ok:=false;
  // Fensterklasse registrieren
  if Ok and (HPrevInst=0) then
  begin
    WindowClass.style:=0;
    WindowClass.lpfnWndProc:=@WindowProc;
    WindowClass.cbClsExtra:=0;
    WindowClass.cbWndExtra:=0;
    WindowClass.hInstance:=HInstance;
    WindowClass.hIcon:=0;
    WindowClass.hCursor:=0;
    WindowClass.hbrBackground:=0;
    WindowClass.lpszMenuName:=nil;
    WindowClass.lpszClassName:=CName;
    Ok:=Windows.RegisterClass(WindowClass)<>0;
  end
  else Ok:=false;
  // Fenster erzeugen
  if Ok then
  begin
    Handle:=CreateWindow(
      CName,
      CName,
      ws_Overlapped,
      10,
      10,
      200,
      200,
      0,
      0,
      HInstance,
      nil);
    Ok:=Handle<>0;
  end;
  // neues Fenster in die Liste aufnehmen
  if Ok then
  begin
    New(w);
    w^.Handle:=Handle;
    w^.TheClass:=Self;
    w^.Next:=nil;
    if WindowList=nil then
      WindowList:=w  // Liste ist leer
    else
    begin  // Liste enth�lt bereits Eintr�ge
      p:=WindowList;
      while p^.Next<>nil do p:=p^.Next;
      p^.Next:=w;
    end;
  end;
end;

destructor TMsgWindow.Destroy;
// Fenster l�schen, Instanz aus der Liste entfernen, Instanz freigeben
var
  p, q : PWindowList;
begin
  DestroyWindow(Handle);
  Windows.UnregisterClass(CName,HInstance);
  // Eintrag aus Liste entfernen
  p:=WindowList;
  q:=nil;
  while p^.TheClass<>Self do
  begin
    q:=p;
    p:=p^.Next;
  end;
  if q=nil then WindowList:=p^.Next  // erster Eintrag in der Liste
           else q^.Next:=p^.Next;
  Dispose(p);
  inherited Destroy;
end;

(*** TCOMManager ***)

constructor TCOMManager.Create;
var
  WndName : string;
begin
  FCheckedPorts:=0;
  FPorts:=TSTringList.Create;
  FOnPortAdded:=nil;
  FOnPortRemoved:=nil;
  Feedback:=nil;
  WndName:='Ser'+DateTimeToStr(Now);
  MsgWindow:=TMsgWindow.Create(WndName,WinProc);  // Fenster f�r Botschaften anlegen
  CheckPorts(MaxPort);
end;

destructor TCOMManager.Destroy;
var
  i : integer;
begin
  MsgWindow.Free;  // Fenster f�r Botschaften l�schen
  if FPorts.Count>0 then
    for i:=0 to FPorts.Count-1 do Dispose(PCOMInfo(FPorts.Objects[i]));
  FPorts.Free;
end;

procedure TCOMManager.WinProc(Message, wParam, lParam : longint);
// Verarbeitung von Windows-Botschaften
type
  TDev_Broadcast_Hdr = packed record
    dbch_size,
    dbch_devicetype,
    dbch_reserved : cardinal;
  end;
  PDev_Broadcast_Hdr = ^TDev_Broadcast_Hdr;
var
  fb : boolean;
  p : PFeedback;
begin
  if Message=WM_DEVICECHANGE then
  begin
    fb:=false;
    if wParam=DBT_DEVICEARRIVAL then
    begin  // Ger�t wurde hinzugef�gt
      if PDev_Broadcast_Hdr(lParam).dbch_devicetype=DBT_DEVTYP_PORT then
      begin  // eine parallele oder serielle Schnittstelle kam hinzu
        if RecheckPorts then  // Ports erneut scannen
        begin
          try  // Ereignis ausl�sen
            if Assigned(FOnPortAdded) then FOnPortAdded(Self);
          except
            FOnPortAdded:=nil;
          end;
          fb:=true;  // Feedbacks aufrufen (sp�ter)
        end;
      end;
    end
    else
    if wParam=DBT_DEVICEREMOVECOMPLETE then
    begin  // Ger�t wurde vollst�ndig entfernt
      if PDev_Broadcast_Hdr(lParam).dbch_devicetype=DBT_DEVTYP_PORT then
      begin  // eine parallele oder serielle Schnittstelle wurde entfernt
        if RecheckPorts then  // Ports erneut scannen
        begin
          try
            if Assigned(FOnPortRemoved) then FOnPortRemoved(Self);
          except
            FOnPortRemoved:=nil;
          end;
          fb:=true;  // Feedbacks aufrufen (sp�ter)
        end;
      end;
    end;
    // registrierte Feedback-Prozeduren aufrufen (falls vorhanden und erforderlich)
    if fb then
    begin
      p:=Feedback;
      while p<>nil do
      begin
        try
          p^.Proc;
          p:=p^.Next;
        except
          p:=nil;
        end;
      end;
    end;
  end;
end;

procedure TCOMManager.CheckPorts(ToPort : integer);
// Pr�ft, welche seriellen Schnittstellen vorhanden sind
// Es wird ab der ersten nicht gepr�ften Schnittstellennummer gepr�ft
// Ergebnis wird in FPorts abgelegt
// registrierte Feedback-Prozeduren werden aufgerufen
var
  c : array[0..63] of char;
  {$IFDEF OLDDELPHI}
  i, j : integer;
  {$ELSE}
  i, j : cardinal;
  {$ENDIF}
  FromPort : integer;
  CommConfig : TCommConfig;
  ci : PCOMInfo;
  p : PFeedback;
begin
  if ToPort>MaxSupported then ToPort:=MaxSupported;
  FromPort:=FCheckedPorts+1;
  if FromPort>ToPort then Exit;  // alles schon gepr�ft
  i:=SizeOf(CommConfig);
  for j:=FromPort to ToPort do
  begin
    if j<10 then
    begin
      c:='COMx'+#0;
      c[3]:=chr($30+j);
    end
    else
    begin
      c:='\\.\COMx'+#0+#0;
      c[7]:=chr($30+(j div 10));
      c[8]:=chr($30+(j mod 10));
    end;
    if GetDefaultCommConfig(@c[4],CommConfig,i) or GetDefaultCommConfig(c,CommConfig,i) then  // V4.11
    begin
      New(ci);
      ci^.Number:=j;
      ci^.Instance:=nil;
      if j>9 then
        FPorts.AddObject(StrPas(@c[4]),TObject(ci))
      else
        FPorts.AddObject(c,TObject(ci));
    end;
  end;
  FCheckedPorts:=ToPort;  // V4.11
  // registrierte Feedback-Prozeduren aufrufen (falls vorhanden) V4.2
  p:=Feedback;
  while p<>nil do
  begin
    try
      p^.Proc;
      p:=p^.Next;
    except
      p:=nil;
    end;
  end;
end;

function TCOMManager.RecheckPorts : boolean;
// Pr�ft die seriellen Schnittstellen nochmal
// Ergebnis true, wenn sich Ver�nderungen ergeben haben
var
  ToPort, i, j : integer;
  BPorts : TStringList;  // Backup der zuletzt gefundenen Ports
begin
  // Backup der COM-Port-Liste anfertigen
  BPorts:=FPorts;
  FPorts:=TStringList.Create;
  // Schnittstellen komplett scannen
  ToPort:=FCheckedPorts;
  FPorts.Clear;
  FCheckedPorts:=0;
  CheckPorts(ToPort);
  // neue Liste und Backup abgleichen
  Result:=FPorts.Count<>BPorts.Count;
  if BPorts.Count>0 then
  begin
    for i:=0 to BPorts.Count-1 do
    begin
      if PortExists(PCOMInfo(BPorts.Objects[i])^.Number) then
      begin
        j:=Port2Index(PCOMInfo(BPorts.Objects[i])^.Number);
        PCOMInfo(FPorts.Objects[j])^.Instance:=PCOMInfo(BPorts.Objects[i])^.Instance;
      end
      else
      begin  // Schnittstelle existiert nicht mehr
        if Assigned(PCOMInfo(BPorts.Objects[i])^.Instance) then  // Schnittstelle war ge�ffnet
          PCOMInfo(BPorts.Objects[i])^.Instance.PanicClose;
        Result:=true;
      end;
    end;
  end;
  BPorts.Free;
end;

function TCOMManager.PortExists(Port : integer) : boolean;
// Pr�ft, ob angegebener Port existiert
var
  i : integer;
begin
  Result:=false;
  if FPorts.Count>0 then
  begin
    i:=0;
    repeat
      Result:=PCOMInfo(FPorts.Objects[i])^.Number=Port;
      inc(i);
    until Result or (i>=FPorts.Count);
  end;
end;

function TCOMManager.Port2Index(Port : integer) : integer;
// Liefert Listenindex aus Liste der gefundenen Schnittstellen
// anhand der Schnittstellennummer
// Ergebnis -1, wenn ung�ltige Schnittstelle angegeben wurde
var
  i : integer;
begin
  Result:=-1;
  if FPorts.Count>0 then
  begin
    i:=0;
    repeat
      if PCOMInfo(FPorts.Objects[i])^.Number=Port then Result:=i;
      inc(i);
    until (Result>=0) or (i>=FPorts.Count);
  end;
 end;

function TCOMManager.FeedbackExists(Proc : TFeedbackProc) : boolean;
// Liefert true, wenn angegebene Feedback-Prozedur in der Liste schon eingetragen ist
var
  p : PFeedback;
begin
  Result:=false;
  if Feedback=nil then Exit;
  // Liste abklappern
  p:=Feedback;
  repeat
    Result:=Addr(p^.Proc)=Addr(Proc);
    p:=p^.Next;
  until Result or (p=nil);
end;

procedure TCOMManager.RegisterFeedback(Proc : TFeedbackProc);
// eine R�ckmelde-Prozedur registrieren (in die Liste aufnehmen)
// eine Prozedur kann nur einmal registriert werden
var
  p, q : PFeedback;
begin
  if FeedbackExists(Proc) then Exit;  // raus, wenn Prozedur schon registriert ist
  // neuer Eintrag
  New(p);
  p^.Proc:=Proc;
  p^.Next:=nil;
  if Feedback=nil then Feedback:=p  // erster Eintrag
  else
  begin  // letzten Eintrag der Liste suchen
    q:=Feedback;
    while q^.Next<>nil do q:=q^.Next;
    q^.Next:=p;  // neuen Eintrag anh�ngen
  end;
end;

procedure TCOMManager.UnregisterFeedback(Proc : TFeedbackProc);
// eine R�ckmelde-Prozedur l�schen (aus der Liste entfernen)
var
  p, q : PFeedback;
begin
  if not FeedbackExists(Proc) then Exit;  // raus, wenn Prozedur nicht registriert ist
  if Addr(Feedback^.Proc)=Addr(Proc) then
  begin  // erster Eintrag ist der gesuchte
    p:=Feedback;
    Feedback:=p^.Next;
    Dispose(p);
  end
  else
  begin
    // Eintrag suchen
    p:=Feedback;
    q:=p^.Next;
    while Addr(q^.Proc)<>Addr(Proc) do
    begin
      p:=q;
      q:=p^.Next;
    end;
    // Eintrag l�schen
    p^.Next:=q^.Next;
    Dispose(q);
  end;
end;

procedure TCOMManager.AssignCOM(Instance : TCustomSerial);
// TSerial/TSerPort-Instanz in Ports.Objects.Instance vermerken,
// wenn Schnittstelle ge�ffnet ist oder Vermerk entfernen, wenn
// Schnittstelle geschlossen ist.
// Nur f�r internen Gebrauch! Wird von TSerial/TSerPort-Instanz aufgerufen.
var
  i : integer;
  Ok : boolean;
begin
  if FPorts.Count>0 then
  begin
    Ok:=false;
    i:=0;
    repeat
      if Instance.COMPort=PCOMInfo(FPorts.Objects[i]).Number then
      begin  // verwendete Schnittstelle wurde in der Liste gefunden
        if Instance.FActive then
          PCOMInfo(FPorts.Objects[i])^.Instance:=Instance
        else
          PCOMInfo(FPorts.Objects[i])^.Instance:=nil;
        Ok:=true;
      end;
      inc(i);
    until Ok or (i>=FPorts.Count);
  end;
end;

(******************************************************************************)
(*** TCustomSerial                                                          ***)
(******************************************************************************)

constructor TCustomSerial.Create(AOwner: TComponent);
// Konstruktor
begin
  inherited Create(AOwner);
  FActive:=false;                    // geschlossen
  FSerHandle:=INVALID_HANDLE_VALUE;  // ung�ltiges Handle
  FBufSizeTrm:=16384;                // Gr��e des Sendepuffers (ab V4.2)
  FBufSizeRec:=16384;                // Gr��e des Empfangspuffers (ab V4.2)
  FOnCOMRemoved:=nil;
  // auf kleinste vorhandene Schnittstelle setzen
  if COMManager.Ports.Count>0 then PortByIndex(0)
                              else FCOMPort:=0;  // keine Schnittstelle vorhanden
end;

destructor TCustomSerial.Destroy;
// Destruktor
begin
  inherited Destroy;
end;

procedure TCustomSerial.PortByIndex(Index : integer);
// Serielle Schnittstelle (COMPort) gem�� Listenindex (Ports) festlegen
// Index: 0..Ports.Count-1
// keine �nderung bei ung�ltigem Wert
begin
  with COMManager do
    if (Ports.Count>0) and (Index>=0) and (Index<Ports.Count) then
      FCOMPort:=PCOMInfo(Ports.Objects[Index])^.Number;
end;

procedure TCustomSerial.PanicClose;
// Nur f�r internen Gebrauch!
// Wird vom COMManager aufgerufen, wenn die ge�ffnete Schnittstelle verloren ging
begin
  FActive:=false;  // als geschlossen betrachten
  if Assigned(FOnCOMRemoved) then FOnCOMRemoved(Self);  // Ereignis
end;

procedure TCustomSerial.SetCOMPort(Value : integer);
// Zu verwendende Schnittstelle festlegen
// Value=1 -> COM1
// Nicht vorhandene Schnittstelle wird nicht akzeptiert
// Value=0 -> keine Schnittstelle
begin
  if Value=0 then FCOMPort:=0
  else
  if COMManager.PortExists(Value) then FCOMPort:=Value;
end;

(******************************************************************************)
(*** TSerThread                                                             ***)
(******************************************************************************)

constructor TSerThread.Create;
// Konstruktor des Thread
// Thread wird nur angelegt, wenn mind. eine Ereignismethode deklariert ist.
begin
  inherited Create(false);
  Serial:=SerComp;
  Priority:=Serial.ThreadPriority;
  FreeOnTerminate:=true;
end;

procedure TSerThread.EventHandling;
// Behandlung von Schnittstellenereignissen, Aufruf der zugeordneten
// Behandlungsroutinen.
begin
  if Serial.EnableEvents then
  begin
    if (Event and EV_BREAK)>0 then Serial.OnBreak(Serial);
    if (Event and EV_CTS)>0 then Serial.OnCts(Serial);
    if (Event and EV_DSR)>0 then Serial.OnDsr(Serial);
    if (Event and EV_ERR)>0 then Serial.OnError(Serial);
    if (Event and EV_RING)>0 then Serial.OnRing(Serial);
    if (Event and EV_RLSD)>0 then Serial.OnDcd(Serial);
    if (Event and EV_RXCHAR)>0 then
    begin
      if Assigned(Serial.OnRxChar) then Serial.OnRxChar(Serial);
      if Assigned(Serial.OnData) and (Serial.DataSize>0) then
      begin  // pr�fen, ob geforderte Datenmenge empfangen wurde
        if Serial.BufRec>=Serial.DataSize then Serial.OnData(Serial);
      end;
    end;
    if (Event and EV_RXFLAG)>0 then Serial.OnEventChar(Serial);
    if (Event and EV_TXEMPTY)>0 then Serial.OnTxEmpty(Serial);
  end;
end;

procedure TSerThread.Execute;
// Thread-Routine, wartet auf Schnittstellenereignisse
begin
  // Thread-Routine, wird beim Start des Thread durchlaufen
  while (not Terminated) do
  begin
    if WaitCommEvent(Serial.SerHandle,Event,nil) then
    begin
      if Serial.SyncEventHandling then
        Synchronize(EventHandling)  // An der Schnittstelle ist vorgegebenes Ereignis aufgetreten
      else
        EventHandling;  // dito ohne Thread-Synchronisation (bessere Performance)
    end;
  end;
end;

(******************************************************************************)
(*** TSerial                                                                ***)
(******************************************************************************)

constructor TSerial.Create(AOwner: TComponent);
// Konstruktor
var
  VerInfo : TOSVersionInfo;
begin
  inherited Create(AOwner);
  // Betriebssystemplattform ermitteln
  IsNT:=false;
  VerInfo.dwOSVersionInfoSize:=sizeof(VerInfo);
  if (GetVersionEx(VerInfo)) then
    IsNT:=VerInfo.dwPlatformId=VER_PLATFORM_WIN32_NT;
  // Grundeinstellungen
  FBaudrate:=br_009600;              // 9600 Baud
  FDataBits:=db_8;                   // 8 Datenbit
  FBufSizeTrm:=16384;                // 16384 Byte Sendepuffergr��e (ab V4.2)
  FBufSizeRec:=16384;                // 16384 Byte Empfangspufergr��e (ab V4.2)
  FHandshakeRtsCts:=false;           // kein Handshake
  FHandshakeDtrDsr:=false;
  FHandshakeXOnXOff:=false;
  FRTSActive:=false;
  FDTRActive:=false;
  FXOnChar:=#17;                     // XOn-Zeichen
  FXOffChar:=#19;                    // XOff-zeichen
  FXOffLimit:=8192;                  // XOff-Limit (ge�ndert V4.2)
  FXOnLimit:=512;                    // XOn-Limit (ge�ndert V4.2)
  FErrorChar:='?';                   // Fehlerersatzzeichen
  FEofChar:=#$1A;                    // EOF-Zeichen (^Z)
  FEventChar:=#$0D;                  // Ereigniszeichen
  FDataSize:=0;                      // keine Reaktion bei empfangener Datenmenge
  FParityCheck:=false;               // Parit�tspr�fung
  FContinueOnXOff:=false;            // weiter senden trotz XOff
  FUseErrorChar:=false;              // Fehlerersatzzeichen verwenden
  FEliminateNullChar:=false;         // Nullzeichen entfernen
  FAbortOnError:=false;              // bei Fehler abbrechen
  FThreadPriority:=tpNormal;         // Thread-Priorit�t
  FSyncEventHandling:=false;         // keine Thread-Synchronisierung bei Ereignisbehandlung
  FEnableEvents:=true;               // Ereignisse behandeln
  FSyncWait:=true;                   // Beim Senden/Empfangen warten
  // Weitere Initialisierungen
  ReceiveData:=RData_00;
  TransmittData:=TData_00;
  ReceiveText:=RText_00;
  TransmittText:=TText_00;
end;

destructor TSerial.Destroy;
// Destruktor
begin
  CloseIt;  // Schnittstelle schlie�en
  inherited Destroy;
end;

function TSerial.OpenIt : boolean;
// Schnittstelle �ffnen
var
  i : integer;
  c : array[0..63] of char;
  ctmo : TCommTimeOuts;
  b : boolean;
begin
  Result:=false;
  if (not FActive) and (COMPort>0) then
  begin
    // Schnittstelle �ffnen
    if FCOMPort<10 then
    begin
      c:='COMx'+#0;
      c[3]:=chr($30+FCOMPort);
    end
    else
    begin
      c:='\\.\COMx'+#0+#0;
      c[7]:=chr($30+(FCOMPort div 10));
      c[8]:=chr($30+(FCOMPort mod 10));
    end;
    FSerHandle:=CreateFile(c,
      GENERIC_READ or GENERIC_WRITE,
      0,
      nil,
      OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OVERLAPPED,
      0);
    if (FSerHandle<>INVALID_HANDLE_VALUE) then
    begin  // Overlapped-Struktur initialisieren
      with Overlapped do
      begin
        Internal:=0;
        InternalHigh:=0;
        Offset:=0;
        OffsetHigh:=0;
        hEvent:=0;
      end;
      // Puffergr��en festlegen
      if (not SetupComm(FSerHandle,BufSizeRec,BufSizeTrm)) then
      begin
        CloseHandle(FSerHandle);
        FSerHandle:=INVALID_HANDLE_VALUE;
      end;
    end;
    if (FSerHandle<>INVALID_HANDLE_VALUE) then
    begin  // Schnittstellen initialisieren (DCB)
      dcb.DCBLength:=SizeOf(TDCB);
      c:='baud=9600 parity=N data=8 stop=1'+#0;
      b:=BuildCommDCB(c,dcb);  // dcb
      if b then
      begin
        dcb.BaudRate:=FBaudrate; // ge�ndert ab V4.2
        dcb.ByteSize:=ord(FDataBits)+4;    // number of bits/byte, 4-8
        dcb.Parity:=ord(FParityBit);       // 0-4=no,odd,even,mark,space
        dcb.StopBits:=ord(FStopBits);      // 0,1,2 = 1, 1.5, 2
        dcb.Flags:=1;  // fBinary
        dcb.Flags:=dcb.Flags or (ord(FParityCheck) shl 1); // fParity
        dcb.Flags:=dcb.Flags or (ord(FHandshakeRTSCTS) shl 2); // fOutxCtsFlow
        dcb.Flags:=dcb.Flags or (ord(FHandshakeDTRDSR) shl 3); // fOutxDsrFlow
        if FHandshakeDTRDSR then dcb.Flags:=dcb.Flags or (DTR_CONTROL_HANDSHAKE shl 4)
        else
        if FDTRActive then dcb.Flags:=dcb.Flags or (DTR_CONTROL_ENABLE shl 4)  // fDtrControl
        else dcb.Flags:=dcb.Flags or (DTR_CONTROL_DISABLE shl 4);  // fDtrControl
        // fDsrSensitivity=0
        dcb.Flags:=dcb.Flags or (ord (FContinueOnXOff) shl 7);  // fTXContinueOnXoff
        dcb.Flags:=dcb.Flags or (ord (FHandshakeXOnXOff) shl 8);  // fOutX
        dcb.Flags:=dcb.Flags or (ord (FHandshakeXOnXOff) shl 9);  // fInX
        dcb.Flags:=dcb.Flags or (ord (FUseErrorChar) shl 10);  // fErrorChar
        dcb.Flags:=dcb.Flags or (ord (FEliminateNullChar) shl 11);  // fNull
        if FHandshakeRTSCTS then dcb.Flags:=dcb.Flags or (RTS_CONTROL_HANDSHAKE shl 12)
        else
        if FRTSActive then dcb.Flags:=dcb.Flags or (RTS_CONTROL_ENABLE shl 12)  // fRtsControl
        else dcb.Flags:=dcb.Flags or (RTS_CONTROL_DISABLE shl 12);  // fRtsControl
        dcb.Flags:=dcb.Flags or (ord (FAbortOnError) shl 14);  // fAbortOnError
        // fDummy2=0
        dcb.XonChar:=FXOnChar;
        dcb.XoffChar:=FXOffChar;
        dcb.XOnLim:=FXOnLimit;
        dcb.XOffLim:=FXOffLimit;
        dcb.ErrorChar:=FErrorChar;
        dcb.EofChar:=FEofChar;
        dcb.EvtChar:=FEventChar;
      end;
      if b then b:=SetCommState(FSerHandle,dcb);
      if (not b) then
      begin  // Initialisierung fehlgeschlagen
        CloseHandle(FSerHandle);  // Schnittstelle schlie�en
        FSerHandle:=INVALID_HANDLE_VALUE;
      end;
    end;
    if (FSerHandle<>INVALID_HANDLE_VALUE) and ((FRecTimeOut>0) or (FTrmTimeOut>0)) then
    with ctmo do
    begin  // Timeouts festlegen
      if FRecTimeOut>0 then
      begin
        ReadIntervalTimeout:=0;
        ReadIntervalTimeout:=FRecTimeOut;
        ReadTotalTimeoutMultiplier:=TimeoutBase div dcb.Baudrate;
        if ReadTotalTimeoutMultiplier=0 then ReadTotalTimeoutMultiplier:=1;
        ReadTotalTimeoutConstant:=FRecTimeOut;
      end
      else
      begin
        ReadIntervalTimeout:=0;
        ReadTotalTimeoutMultiplier:=0;
        ReadTotalTimeoutConstant:=0;
      end;
      if FTrmTimeOut>0 then
      begin
        WriteTotalTimeoutMultiplier:=TimeoutBase div dcb.Baudrate;
        if WriteTotalTimeoutMultiplier=0 then WriteTotalTimeoutMultiplier:=1;
        WriteTotalTimeoutConstant:=FTrmTimeOut;
      end
      else
      begin
        WriteTotalTimeoutMultiplier:=0;
        WriteTotalTimeoutConstant:=0;
      end;
      SetCommTimeOuts(FSerHandle,ctmo);
    end;
    i:=0;
    if (FSerHandle<>INVALID_HANDLE_VALUE) then
    begin  // Ereignismaske (wird entsprechend deklarierter Ereignisbehandlungsmethoden festgelegt)
      if Assigned(OnBreak) then i:=EV_BREAK;
      if Assigned(OnCts) then i:=i or EV_CTS;
      if Assigned(OnDsr) then i:=i or EV_DSR;
      if Assigned(OnError) then i:=i or EV_ERR;
      if Assigned(OnRing) then i:=i or EV_RING;
      if Assigned(OnDcd) then i:=i or EV_RLSD;
      if Assigned(OnRxChar) or Assigned(OnData) then i:=i or EV_RXCHAR;
      if Assigned(OnEventChar) then i:=i or EV_RXFLAG;
      if Assigned(OnTxEmpty) then i:=i or EV_TXEMPTY;
      if (not SetCommMask(FSerHandle,i)) then
      begin  // Fehler beim Setzen der Maske
        CloseHandle(FSerHandle);  // Schnittstelle schlie�en
        FSerHandle:=INVALID_HANDLE_VALUE;
      end;
    end;
    SerThread:=nil;
    if (FSerHandle<>INVALID_HANDLE_VALUE) and (i<>0) then
    begin  // Thread erzeugen und starten, wenn mindestens ein Ereignis festgelegt ist
       SerThread:=TSerThread.Create(Self);  // Thread anlegen
       // SerThread.Priority:=ThreadPriority;  // wird in SerThread erledigt
    end;
    Result:=FSerHandle<>INVALID_HANDLE_VALUE;
    if Result then
    begin  // Plattformabh�ngige �bertragungsfunktionen festlegen
      if IsNT then
      begin
        ReceiveData:=RData_NT;
        TransmittData:=TData_NT;
        ReceiveText:=RText_NT;
        TransmittText:=TText_NT;
      end
      else
      begin
        ReceiveData:=RData_95;
        TransmittData:=TData_95;
        ReceiveText:=RText_95;
        TransmittText:=TText_95;
      end;
    end
    else
    begin
      ReceiveData:=RData_00;
      TransmittData:=TData_00;
      ReceiveText:=RText_00;
      TransmittText:=TText_00;
    end;
    FActive:=Result;
    if FActive then
      COMManager.AssignCOM(Self);  // COMManager �ber das �ffnen informieren
  end;
end;

procedure TSerial.CloseIt;
// Schnittstelle schlie�en
begin
  if FActive then
  begin
    if Assigned(SerThread) then
      SerThread.Terminate;  // Thread zum Beenden auffordern
    SetCommMask(FSerHandle,0);
    CloseHandle(FSerHandle);
    FSerHandle:=INVALID_HANDLE_VALUE;
    ReceiveData:=RData_00;
    TransmittData:=TData_00;
    ReceiveText:=RText_00;
    TransmittText:=TText_00;
    FActive:=false;
    COMManager.AssignCOM(Self);  // COMManager �ber das Schlie�en informieren
  end;
end;

procedure TSerial.PanicClose;
// Schnittstelle ging verloren
// Schnittstelle als geschlossen betrachten
begin
  if Assigned(SerThread) then
    SerThread.Terminate;  // Thread zum Beenden auffordern
  FSerHandle:=INVALID_HANDLE_VALUE;
  ReceiveData:=RData_00;
  TransmittData:=TData_00;
  ReceiveText:=RText_00;
  TransmittText:=TText_00;
  inherited PanicClose;
end;

procedure TSerial.DataInBuffer(var InQueue, OutQueue : integer);
// Anzahl Zeichen, die im Sende- und Empfangspuffer stehen
var
  ComStat : TComStat;
  {$IFDEF OLDDELPHI}
  e : integer;
  {$ELSE}
  e : cardinal;
  {$ENDIF}
begin
  InQueue:=0;
  OutQueue:=0;
  if FActive then
  begin
    if ClearCommError(FSerHandle,e,@ComStat) then begin
      InQueue:=ComStat.cbInQue;
      OutQueue:=ComStat.cbOutQue;
    end;
  end;
end;

function TSerial.SendSerialData(Data: TByteArray; DataSize: cardinal): cardinal;
begin
  result:= TransmittData(Data, DataSize);
end;

function TSerial.ReceiveSerialData(var Buf: TByteArray; BufSize: cardinal): cardinal;
begin
  result:= ReceiveData(Buf, BufSize);
end;


function TSerial.ReceiveSerialText: string;
begin
  result:= ReceiveText;
end;

function TSerial.SendSerialText(Data: String): cardinal;
begin
  result:= TransmittText(Data);
  //
end;

procedure TSerial.SetActive(Value : boolean);
// Schnittstelle �ffnen/schlie�en
begin
  if Value and (not FActive) then FActive:=OpenIt  // �ffnen
  else
  if (not Value) and FActive then CloseIt;  // schlie�en
end;

procedure TSerial.SetBaudrate(Value : integer);
// �bertragungsrate setzen
// die real m�gliche Baudrate wird berechnet
// ge�ndert ab V4.2
begin
  FBaudrate:=fBaud div (fBaud div Value);
  if FBaudrate<50 then FBaudrate:=50;
  if FBaudrate>921600 then FBaudrate:=921600;
end;

procedure TSerial.SetParityBit(Value : TParityBit);
// Parit�tsbit setzen
begin
  FParityBit:=Value;
  FParityCheck:=Value>none;  // Flag fParity (DCB)
end;

procedure TSerial.SetBufSizeTrm(Value : integer);
// Gr��e des Sendepuffers festlegen
// Mindestgr��e 4096 Byte
begin
  if Value<4096 then Value:=4096;  // ge�ndert ab V4.2
  FBufSizeTrm:=Value;
end;

procedure TSerial.SetBufSizeRec(Value : integer);
// Gr��e des Empfangspuffers festlegen
// Mindestgr��e 4096 Byte
// XOff- und XOn-Limit werden bei Bedarf angepa�t
begin
  if Value<4096 then Value:=4096;  // ge�ndert ab V4.2
  FBufSizeRec:=Value;
  if FXOffLimit>Value then FXOffLimit:=Value;
  if FXOnLimit>=FXOffLimit then FXOnLimit:=FXOffLimit-1;
end;

procedure TSerial.SetXOffLimit(Value : integer);
// Oberer F�llgrad des Empfangspuffers, bei dem das XOff-Zeichen ausgegeben wird
// (XOn/XOff-Protokoll)
// Wert wird bei Bedarf korrigiert (nicht gr��er als Empfangspuffergr��e und
// nicht kleiner als XOn-Limit)
begin
  if Value<=FXOnLimit then Value:=FXOnLimit+1;
  if Value>FBufSizeRec then Value:=FBufSizeRec;
  FXOffLimit:=Value;
end;

procedure TSerial.SetXOnLimit(Value : integer);
// Unterer F�llgrad des Empfangspuffers, bei dem das XOn-Zeichen ausgegeben wird
// (XOn/XOff-Protokoll)
// Wert wird bei Bedarf korrigiert (nicht gr��er XOff-Limit und
// nicht kleiner als 0)
begin
  if Value>=FXOffLimit then Value:=FXOffLimit-1;
  if Value<0 then Value:=0;
  FXOnLimit:=Value;
end;

procedure TSerial.SetRecTimeOut(Value : integer);
// Timeout f�r Datenempfang
begin
  if Value<0 then Value:=0;
  FRecTimeOut:=Value;
end;

procedure TSerial.SetTrmTimeOut(Value : integer);
// Timeout f�r Datensendung
begin
  if Value<0 then Value:=0;
  FTrmTimeOut:=Value;
end;

function TSerial.GetBufTrm : integer;
// Anzahl Zeichenermitteln, die sich im Sendepuffer befinden
var
  i : integer;
begin
  DataInBuffer(i,Result);
end;

function TSerial.GetBufRec : integer;
// Anzahl Zeichenermitteln, die sich im Empfangspuffer befinden
var
  i : integer;
begin
  DataInBuffer(Result,i);
end;

function TSerial.GetCanTransmitt : boolean;
// Pr�fen, ob Hardwire-Handshake senden erlaubt
// Zustand der Handshake-EIng�nge CTS bzw. DSR
// Ergebnis true, wenn ja oder Software-Handshake oder kein Handshake
// Ergebnis false, wenn Schnittstelle geschlossen
var
  {$IFDEF OLDDELPHI}
  Status : integer;
  {$ELSE}
  Status : cardinal;
  {$ENDIF}
begin
  Result:=false;
  if FActive then
  begin
    if FHandshakeRtsCts or FHandshakeDtrDsr then
    begin  // Hardwire-Handshake ist eingestellt
      GetCommModemStatus(FSerHandle,Status);
      if FHandshakeRtsCts and FHandshakeDtrDsr then  // CTS und DSR  (ge�ndert ab V4.1)
        Result:=(Status and (MS_CTS_ON or MS_DSR_ON)) = (MS_CTS_ON or MS_DSR_ON)
      else
      if FHandshakeRtsCts then  // nur CTS
        Result:=(Status and MS_CTS_ON)<>0
      else
        Result:=(Status and MS_DSR_ON)<>0;  // nur DSR
    end
    else Result:=true; // kein Hardwire-Handshake
  end;
end;

procedure TSerial.SetDataSize(Value : integer);
// Datenmenge im Empfangspuffer, bei der das Ereignis OnData ausgel�st wird,
// festlegen
// Bei Value=0 wird das Ereignis nicht ausgel�st.
begin
  if Value<0 then Value:=0;
  if Value>FBufSizeRec then Value:=FBufSizeRec;
  FDataSize:=Value;
end;

function TSerial.OpenComm : boolean;
// Serielle Schnittstelle �ffnen (public deklarierte Funktion)
// Alternative zur Eigenschaft Active
begin
  Result:=OpenIt;
end;

procedure TSerial.CloseComm;
// Serielle Schnittstelle schlie�en (public deklarierte Funktion)
// Alternative zur Eigenschaft Active
begin
  CloseIt;
end;

function TSerial.Purge(TxAbort,RxAbort,TxClear,RxClear : boolean) : boolean;
// Inhalt des Sende-/Empfangspuffers l�schen
// �bertragung (senden/empfangen) abbrechen
// Die Funktion verwendet die API-Funktion PurgeComm
// Hinweis: Diese Funktion darf unter Win32s nicht aufgerufen werden!
// TxAbort=true -> Senden abbrechen
// RxAbort=true -> Empfang abbrechen
// TxClear=true -> Inhalt des Sendepuffers l�schen
// RxClear=true -> Inhalt des Empfangspuffers l�schen
// Ergebnis true, wenn Aktion erfolgreich ausgef�hrt werden konnte
begin
  if FActive then
    Result:=PurgeComm(FSerHandle,ord(TxAbort) or
                                (ord(RxAbort) shl 1) or
                                (ord(TxClear) shl 2) or
                                (ord(RxClear) shl 3))
  else Result:=false;
end;

procedure TSerial.SetConfig(SerialConfig : TSerialConfig);
// Konfiguration aus Record in Eigenschaften �bernehmen
// �bernahme erfolgt nur, wenn SerialConfig.Valid=true
begin
  if SerialConfig.Valid then
  begin
    COMPort:=SerialConfig.COMPort;                     // Schnittstelle
    Baudrate:=SerialConfig.Baudrate;                   // �bertragungsrate
    DataBits:=SerialConfig.DataBits;                   // Anzahl datenbits
    ParityBit:=SerialConfig.ParityBit;                 // Parit�tsbit
    StopBits:=SerialConfig.StopBits;                   // Anzahl Stoppbits
    BufSizeTrm:=SerialConfig.BufSizeTrm;               // Gr��e des Sendepuffers
    BufSizeRec:=SerialConfig.BufSizeRec;               // Gr��e des Empfangspuffers
    HandshakeRtsCts:=SerialConfig.HandshakeRtsCts;     // Hardwire-Handshake RTS/CTS
    HandshakeDtrDsr:=SerialConfig.HandshakeDtrDsr;     // Hardwire-Handshake DTR/DSR
    HandshakeXOnXOff:=SerialConfig.HandshakeXOnXOff;   // Handshake XOn/XOff-Protokoll
    RTSActive:=SerialConfig.RTSActive;                 // RTS-Ausgang aktiv setzen (wenn nicht zum Handshake benutzt)
    DTRActive:=SerialConfig.DTRActive;                 // DTR-Ausgang aktiv setzen (wenn nicht zum Handshake benutzt)
    XOnChar:=SerialConfig.XOnChar;                     // XOn-Zeichen
    XOffChar:=SerialConfig.XOffChar;                   // XOff-Zeichen
    XOffLimit:=SerialConfig.XOffLimit;                 // XOff-Limit
    XOnLimit:=SerialConfig.XOnLimit;                   // XOn-Limit
    ErrorChar:=SerialConfig.ErrorChar;                 // Fehlerersatzzeichen
    EofChar:=SerialConfig.EofChar;                     // EOF-Zeichen
    EventChar:=SerialConfig.EventChar;                 // Ereigniszeichen
    ContinueOnXOff:=SerialConfig.ContinueOnXOff;       // �bertragung fortsetzen auch bei XOff
    UseErrorChar:=SerialConfig.UseErrorChar;           // Fehlerersatzzeichen verwenden
    EliminateNullChar:=SerialConfig.EliminateNullChar; // Nullzeichen entfernen
    AbortOnError:=SerialConfig.AbortOnError;           // bei Fehler abbrechen
    RecTimeOut:=SerialConfig.RecTimeOut;               // Timeout (ms) f�r Datenempfang (0=kein Timeout)
    TrmTimeOut:=SerialConfig.TrmTimeOut;               // Timeout (ms) f�r Daten�bertragung (0=kein Timeout)
  end;
end;

function TSerial.GetConfig : TSerialConfig;
// aktuelle Einstellungen als Funktionsergebnis zur�ck liefern
begin
  Result.Valid:=true;                          // Parameter sind g�ltig
  Result.COMPort:=COMPort;                     // Schnittstelle
  Result.Baudrate:=Baudrate;                   // �bertragungsrate
  Result.DataBits:=DataBits;                   // Anzahl datenbits
  Result.ParityBit:=ParityBit;                 // Parit�tsbit
  Result.StopBits:=StopBits;                   // Anzahl Stoppbits
  Result.BufSizeTrm:=BufSizeTrm;               // Gr��e des Sendepuffers
  Result.BufSizeRec:=BufSizeRec;               // Gr��e des Empfangspuffers
  Result.HandshakeRtsCts:=HandshakeRtsCts;     // Hardwire-Handshake RTS/CTS
  Result.HandshakeDtrDsr:=HandshakeDtrDsr;     // Hardwire-Handshake DTR/DSR
  Result.HandshakeXOnXOff:=HandshakeXOnXOff;   // Handshake XOn/XOff-Protokoll
  Result.RTSActive:=RTSActive;                 // RTS-Ausgang aktiv setzen (wenn nicht zum Handshake benutzt)
  Result.DTRActive:=DTRActive;                 // DTR-Ausgang aktiv setzen (wenn nicht zum Handshake benutzt)
  Result.XOnChar:=XOnChar;                     // XOn-Zeichen
  Result.XOffChar:=XOffChar;                   // XOff-Zeichen
  Result.XOffLimit:=XOffLimit;                 // XOff-Limit
  Result.XOnLimit:=XOnLimit;                   // XOn-Limit
  Result.ErrorChar:=ErrorChar;                 // Fehlerersatzzeichen
  Result.EofChar:=EofChar;                     // EOF-Zeichen
  Result.EventChar:=EventChar;                 // Ereigniszeichen
  Result.ContinueOnXOff:=ContinueOnXOff;       // �bertragung fortsetzen auch bei XOff
  Result.UseErrorChar:=UseErrorChar;           // Fehlerersatzzeichen verwenden
  Result.EliminateNullChar:=EliminateNullChar; // Nullzeichen entfernen
  Result.AbortOnError:=AbortOnError;           // bei Fehler abbrechen
  Result.RecTimeOut:=RecTimeOut;               // Timeout (ms) f�r Datenempfang (0=kein Timeout)
  Result.TrmTimeOut:=TrmTimeOut;               // Timeout (ms) f�r Daten�bertragung (0=kein Timeout)
end;

function TSerial.ConfigToStr(SerialConfig : TSerialConfig) : string;
// Konfigurationsdaten in String umwandeln
// Bei ung�ltigen Daten wird ein Leerstring zur�ck geliefert
var
  i : integer;
  r : array[0..127] of char;
  p : byte;

  procedure Int2RStr(Value, DefLength, Index : integer);
  // Integer -> String mit Nullen vorangestellt
  // Ergebnis wird ab r[Index] abgelegt
  var
    j : integer;
    s : string;
  begin
    s:=IntToStr(Value);
    while Length(s)<DefLength do s:='0'+s;
    for j:=1 to DefLength do r[Index+j-1]:=s[j];
  end;

  procedure Char2Str(AChar : char; Index : integer);
  // Wandelt Zeichenkode in 3-stelligen Dezimalstring um
  // Ergebnis wird ab r[Index] abgelegt
  var
    j : integer;
    s : string;
  begin
    s:=IntToStr(byte(AChar));
    while Length(s)<3 do s:='0'+s;
    for j:=1 to 3 do r[Index+j-1]:=s[j];
  end;

begin
  if SerialConfig.Valid then
  begin
    for i:=0 to SizeOf(r)-1 do r[i]:=#0;
    // ID und Version (0)
    for i:=0 to 3 do r[i]:=SerCfgID[i];
    // Schnittstelle (4)
    Int2RStr(SerialConfig.COMPort,3,4);
    // Baudrate (7)
    Int2RStr(SerialConfig.Baudrate,6,7);
    // Datenbits (13, alt 9)
    Int2RStr(ord(SerialConfig.DataBits),1,13);  // ab hier �nderung ab V4.2
    // ParityBit (14, alt 10)
    Int2RStr(ord(SerialConfig.ParityBit),1,14);
    // StoppBits (15, alt 11)
    Int2RStr(ord(SerialConfig.StopBits),1,15);
    // Sendepuffergr��e (16, alt 12)
    Int2RStr(SerialConfig.BufSizeTrm,8,16);
    // Empfangspuffergr��e (24, alt 20)
    Int2RStr(SerialConfig.BufSizeRec,8,24);
    // Handshake RTS/CTS (32, alt 28)
    Int2RStr(ord(SerialConfig.HandshakeRtsCts),1,32);
    // Handshake DTR/DSR (33, alt 29)
    Int2RStr(ord(SerialConfig.HandshakeDtrDsr),1,33);
    // Handshake XOn/XOff (34, alt 30)
    Int2RStr(ord(SerialConfig.HandshakeXOnXOff),1,34);
    // RTS-Zustand (35, alt 31)
    Int2RStr(ord(SerialConfig.RTSActive),1,35);
    // DTR-Zustand (36, alt 32)
    Int2RStr(ord(SerialConfig.DTRActive),1,36);
    // XOn-Zeichen (37, alt 33)
    Char2Str(SerialConfig.XOnChar,37);
    // XOff-Zeichen (40, alt 36)
    Char2Str(SerialConfig.XOffChar,40);
    // XOff-Limit (43, alt 39)
    Int2RStr(SerialConfig.XOffLimit,8,43);
    // XOn-Limit (51, alt 47)
    Int2RStr(SerialConfig.XOnLimit,8,51);
    // Fehlerzeichen (59, alt 55)
    Char2Str(SerialConfig.ErrorChar,59);
    // EOF-Zeichen (62, alt 58)
    Char2Str(SerialConfig.EofChar,62);
    // Ereigniszeichen (65, alt 61)
    Char2Str(SerialConfig.EventChar,65);
    // Continue On XOff (68, alt 64)
    Int2RStr(ord(SerialConfig.ContinueOnXOff),1,68);
    // Fehlerzeichen verwenden (69, alt 65)
    Int2RStr(ord(SerialConfig.UseErrorChar),1,69);
    // Nullzeichen entfernen (70, alt 66)
    Int2RStr(ord(SerialConfig.EliminateNullChar),1,70);
    // Abbruch bei Fehler (71, alt 67)
    Int2RStr(ord(SerialConfig.AbortOnError),1,71);
    // Empfangen TimeOut (72, alt 68)
    Int2RStr(SerialConfig.RecTimeOut,10,72);
    // Senden TimeOut (82, alt 78)
    Int2RStr(SerialConfig.TrmTimeOut,10,82);
    // String-Parit�t (92, alt 88) (3 Ziffern)
    p:=0;
    for i:=0 to 91 do p:=p xor ord(r[i]);
    Int2RStr(p,3,92);
    // Ergebnis
    Result:=StrPas(r);
  end
  else Result:=EmptyStr;
end;

function TSerial.StrToConfig(CfgStr : string) : TSerialConfig;
// Konfigurationsstring in Record umwandeln
// Bei einem Fehler im String ist Result.Valid:=false,
// die restlichen Einstellungen entsprechen aktueller
var
  i : integer;
  Ok : boolean;
  p : byte;
  r : array[0..127] of char;

  function RStr2Int(DefLength, Index : integer; var Value : integer) : boolean;
  // Teilstring r[Index] der L�nge DefLength in Zahl umwandeln
  // Ergebnis in Value
  // Ergebnis true, wenn String g�ltige Zeichen enth�lt
  var
    j : integer;
    c : array[0..15] of char;
  begin
    for j:=0 to DefLength-1 do c[j]:=r[Index+j];
    c[DefLength]:=#0;
    val(c,Value,j);
    Result:=j=0;
  end;

  function Str2Char(Index : integer) : char;
  // Wandelt 3-stelligen ASCII-Kode-String in Zeichen um
  var
    j, e : integer;
    c : array[0..3] of char;
  begin
    for j:=0 to 2 do c[j]:=r[Index+j];
    c[3]:=#0;
    val(c,j,e);
    Result:=chr(j);
  end;

begin
  Result:=GetConfig;
  Result.Valid:=false;
  if Length(CfgStr)>4 then
  begin
    for i:=0 to SizeOf(r)-1 do r[i]:=#0;
    StrPCopy(r,CfgStr);
    // ID und Version
    Ok:=true;
    for i:=0 to 3 do Ok:=Ok and (r[i]=SerCfgID[i]);
    if Ok then
    begin // Parit�tspr�fung
      p:=0;
      for i:=0 to 91 do p:=p xor ord(r[i]);
      Ok:=RStr2Int(3,92,i);
      Ok:=Ok and (p=i);
    end;
    if Ok then
    begin  // Schnittstelle
      Ok:=RStr2Int(3,4,i);
      if Ok then Result.COMPort:=i;
    end;
    if Ok then
    begin  // Baudrate
      Ok:=RStr2Int(6,7,i);
      Ok:=Ok and (i>=50) and (i<=921600);  // g�ltige Baudrate
      if Ok then Result.Baudrate:=i;  // Fehler orrigiert ab V4.3
    end;
    if Ok then
    begin  // Datenbits
      Ok:=RStr2Int(1,13,i);
      Ok:=Ok and (i<5);  // g�ltige Anzahl Datenbits
      if Ok then Result.DataBits:=TDataBits(i);
    end;
    if Ok then
    begin  // Parit�tsbit
      Ok:=RStr2Int(1,14,i);
      Ok:=Ok and (i<5);  // g�ltige Parit�tsangabe
      if Ok then Result.ParityBit:=TParityBit(i);
    end;
    if Ok then
    begin  // Stoppbits
      Ok:=RStr2Int(1,15,i);
      Ok:=Ok and (i<3);  // g�ltige Angabe
      if Ok then Result.StopBits:=TStopBits(i);
    end;
    if Ok then
    begin  // Sendepuffergr��e
      Ok:=RStr2Int(8,16,i);
      if Ok then Result.BufSizeTrm:=i;
    end;
    if Ok then
    begin  // Empfangspuffergr��e
      Ok:=RStr2Int(8,24,i);
      if Ok then Result.BufSizeRec:=i;
    end;
    if Ok then
    begin  // Handshake RTS/CTS
      Ok:=RStr2Int(1,32,i);
      if Ok then Result.HandshakeRtsCts:=i>0;
    end;
    if Ok then
    begin  // Handshake DTR/DSR
      Ok:=RStr2Int(1,33,i);
      if Ok then Result.HandshakeDtrDsr:=i>0;
    end;
    if Ok then
    begin  // Handshake XOn/XOff
      Ok:=RStr2Int(1,34,i);
      if Ok then Result.HandshakeXOnXOff:=i>0;
    end;
    if Ok then
    begin  // RTS-Zustand
      Ok:=RStr2Int(1,35,i);
      if Ok then Result.RTSActive:=i>0;
    end;
    if Ok then
    begin  // DTR-Zustand
      Ok:=RStr2Int(1,36,i);
      if Ok then Result.DTRActive:=i>0;
    end;
    // XOn-Zeichen
    if Ok then Result.XOnChar:=Str2Char(33);
    // XOff-Zeichen
    if Ok then Result.XOffChar:=Str2Char(36);
    if Ok then
    begin  // XOff-Limit
      Ok:=RStr2Int(8,43,i);
      if Ok then Result.XOffLimit:=i;
    end;
    begin  // XOn-Limit
      Ok:=RStr2Int(8,51,i);
      if Ok then Result.XOnLimit:=i;
    end;
    // Fehler-Zeichen
    if Ok then Result.ErrorChar:=Str2Char(59);
    // EOF-Zeichen
    if Ok then Result.EofChar:=Str2Char(62);
    // Ereignis-Zeichen
    if Ok then Result.EventChar:=Str2Char(65);
    if Ok then
    begin  // Continue on XOff
      Ok:=RStr2Int(1,68,i);
      if Ok then Result.ContinueOnXOff:=i>0;
    end;
    if Ok then
    begin  // Fehlerzeichen benutzen
      Ok:=RStr2Int(1,69,i);
      if Ok then Result.UseErrorChar:=i>0;
    end;
    if Ok then
    begin  // Nullzeichen entfernen
      Ok:=RStr2Int(1,70,i);
      if Ok then Result.EliminateNullChar:=i>0;
    end;
    if Ok then
    begin  // Abbruch bei Fehler
      Ok:=RStr2Int(1,71,i);
      if Ok then Result.AbortOnError:=i>0;
    end;
    if Ok then
    begin  // Timeout Empfang
      Ok:=RStr2Int(10,72,i);
      if Ok then Result.RecTimeOut:=i;
    end;
    if Ok then
    begin  // Timeout Senden
      Ok:=RStr2Int(10,82,i);
      if Ok then Result.TrmTimeOut:=i;
    end;
    Result.Valid:=Ok;
  end;
end;

function TSerial.TData_00;
// Dummy-Routine Daten �bertragen
begin
  Result:=0;
end;

function TSerial.TData_95;
// Daten �bertragen
// Die Funktion kehrt erst zur�ck, wenn die Daten �bertragen sind
// Data: Zeiger auf zu �bertragende Daten
// DataSize: Umfang der zu �bertragenden Daten
// Ergebnis: tats�chlich �bertragene (in Sendepuffer gestellte) Daten
begin
  WriteFile(FSerHandle,Data,DataSize,Result,@Overlapped);
end;

function TSerial.TData_NT;
// Daten �bertragen
// SyncWait=true:  Es wird gewartet, bis alle Daten �bertragen sind
// SyncWait=false: Sofortige R�ckkehr (�bertragung im Hintergrund)
// Data: Zeiger auf zu �bertragende Daten
// DataSize: Umfang der zu �bertragenden Daten
// Ergebnis: tats�chlich �bertragene (in Sendepuffer gestellte) Daten
begin
  if not WriteFile(FSerHandle, Data, DataSize, Result, @Overlapped)
    and (GetLastError = ERROR_IO_PENDING) then
    GetOverlappedResult(FSerHandle, Overlapped, Result, FSyncWait);
end;

function TSerial.RData_00;
// Dummy-Routine f�r Daten empfangen
begin
  Result:=0;
end;

function TSerial.RData_95;
// Daten empfangen (Empfangspuffer leeren)
// SyncWait=true:  Es wird gewartet, bis angeforderte Menge Daten vorhanden oder Timeout
// SyncWait=false: Sofortige R�ckkehr mit vorhandenen Daten, maximal angeforderte
// Buf: Zeiger auf Puffer, welcher die Daten �bernehmen soll
// BufSize: Gr��e des Puffers
// Ergebnis: Anzahl Datenbytes, die in den Puffer geschrieben wurden
var
  {$IFDEF OLDDELPHI}
  n : integer;
  {$ELSE}
  n : cardinal;
  {$ENDIF}
begin
  if BufSize>0 then
  begin
    if FSyncWait then n:=BufSize
                 else n:=BufRec;
    if n>BufSize then n:=BufSize;
    ReadFile(FSerHandle, Buf, n, Result, @Overlapped);
  end;
end;

function TSerial.RData_NT;
// Daten empfangen (Empfangspuffer leeren)
// SyncWait=true:  Es wird gewartet, bis angeforderte Menge Daten vorhanden oder Timeout
// SyncWait=false: Sofortige R�ckkehr mit vorhandenen Daten, maximal angeforderte
// Buf: Zeiger auf Puffer, welcher die Daten �bernehmen soll
// BufSize: Gr��e des Puffers
// Ergebnis: Anzahl Datenbytes, die in den Puffer geschrieben wurden
var
  {$IFDEF OLDDELPHI}
  n : integer;
  {$ELSE}
  n : cardinal;
  {$ENDIF}
begin
  if BufSize>0 then
  begin
    if FSyncWait then n:=BufSize
                 else n:=BufRec;
    if n>BufSize then n:=BufSize;
    if not ReadFile(FSerHandle, Buf, n, Result, @Overlapped)
      and (GetLastError = ERROR_IO_PENDING) then
      GetOverlappedResult(FSerHandle, Overlapped, Result, FSyncWait);
  end;
end;


function TSerial.TText_00;
// Dummy-Funktion zur Text�bertragung
begin
  Result:=0;
end;

function TSerial.TText_95;
// Text �bertragen
// R�ckkehr nach der �bertragung der Daten oder Timeout
// s: Zu sendender Text
// Ergebnis: tats�chlich �bertragene (in Sendepuffer gestellte) Zeichen
//           (bei nicht ge�ffneter Schnittstelle 0)
begin
  WriteFile(FSerHandle,s[1],Length(s),Result,@Overlapped)
end;

function TSerial.TText_NT;
// Text �bertragen
// SyncWait=true:  R�ckkehr nach der �bertragung der Daten oder Timeout
// SyncWait=false: Sofortige R�ckkehr (�bertragung im Hintergrund)
// s: Zu sendender Text
// Ergebnis: tats�chlich �bertragene (in Sendepuffer gestellte) Zeichen
//           (bei nicht ge�ffneter Schnittstelle 0)
begin
  if not WriteFile(FSerHandle, s[1], Length(s), Result, @Overlapped)
    and (GetLastError = ERROR_IO_PENDING) then
    GetOverlappedResult(FSerHandle, Overlapped, Result, FSyncWait);
end;

function TSerial.RText_00 : string;
// Dummy-Routine f�r Textempfang
begin
  Result:='';
end;

function TSerial.RText_95 : string;
// Text empfangen (Empfangspuffer leeren)
// Sofortige R�ckkehr
// Ergebnis: Eingelesener Text
//           (bei nicht ge�ffneter Schnittstelle Leerstring)
var
  {$IFDEF OLDDELPHI}
  n, m : integer;
  {$ELSE}
  n, m : cardinal;
  {$ENDIF}
begin
  n:=BufRec;
  if n>0 then
  begin
    SetLength(Result,n);
    ReadFile(FSerHandle,Result[1],n,m,@Overlapped);
  end
  else Result:=EmptyStr;
end;

function TSerial.RText_NT : string;
// Text empfangen (Empfangspuffer leeren)
// Sofortige R�ckkehr
// Ergebnis: Eingelesener Text
//           (bei nicht ge�ffneter Schnittstelle Leerstring)
var
  {$IFDEF OLDDELPHI}
  n, m : integer;
  {$ELSE}
  n, m : cardinal;
  {$ENDIF}
begin
  n:=BufRec;
  if n>0 then
  begin
    SetLength(Result,n);
    if not ReadFile(FSerHandle, Result[1], n, m, @Overlapped)
      and (GetLastError = ERROR_IO_PENDING) then
      GetOverlappedResult(FSerHandle, Overlapped, m, FSyncWait);
  end
  else Result:=EmptyStr;
end;

(******************************************************************************)
(*** TSerPortThread                                                         ***)
(******************************************************************************)

constructor TSerPortThread.Create;
// Konstruktor des Thread
begin
  inherited Create(false);
  Serial:=SerComp;
  Priority:=Serial.ThreadPriority;
  FreeOnTerminate:=true;
end;

procedure TSerPortThread.Execute;
// Thread-Routine, wartet auf Schnittstellenereignisse
var
  {$IFDEF OLDDELPHI}
  e : integer;
  Status : integer;
  {$ELSE}
  e : cardinal;
  Status : cardinal;
  {$ENDIF}
  First : boolean;
begin
  // Thread-Routine, wird beim Start des Thread durchlaufen
  First:=true;
  while (not Terminated) do
  begin
    if (First or (WaitCommEvent(Serial.SerHandle,e,nil))) then
    begin  // An der Schnittstelle ist vorgegebenes Ereignis aufgetreten
      First:=false;
      GetCommModemStatus(Serial.SerHandle,Status);
      Serial.FIn_CTS:=(Status and MS_CTS_ON)=0;
      Serial.FIn_DSR:=(Status and MS_DSR_ON)=0;
      Serial.FIn_RI:=(Status and MS_RING_ON)=0;
      Serial.FIn_DCD:=(Status and MS_RLSD_ON)=0;
      if Assigned(Serial.OnCts) and ((e and EV_CTS)>0) then Serial.OnCts(Serial);
      if Assigned(Serial.OnDsr) and ((e and EV_DSR)>0) then Serial.OnDsr(Serial);
      if Assigned(Serial.OnRing) and ((e and EV_RING)>0) then Serial.OnRing(Serial);
      if Assigned(Serial.OnDcd) and ((e and EV_RLSD)>0) then Serial.OnDcd(Serial);
    end;
  end;
end;

(******************************************************************************)
(*** TSerPort                                                               ***)
(******************************************************************************)

constructor TSerPort.Create(AOwner: TComponent);
// Konstruktor
begin
  inherited Create(AOwner);
  FOut_DTR:=false;
  FOut_RTS:=false;
  FOut_TxD:=true;
  FIn_DCD:=false;
  FIn_DSR:=false;
  FIn_CTS:=false;
  FIn_RI:=false;
  FOnCts:=nil;
  FOnDsr:=nil;
  FOnRing:=nil;
  FOnDcd:=nil;
  SerPortThread:=nil;
  FPollingMode:=false;
end;

destructor TSerPort.Destroy;
// Destruktor
begin
  CloseIt;
  inherited Destroy;
end;

function TSerPort.OpenIt : boolean;
// Schnittstelle �ffnen und initialisieren
var
  c : array[0..63] of char;
  i : integer;
begin
  IsPolling:=FPollingMode;  // Polling-Modus
  // Schnittstelle �ffnen
  if FCOMPort<10 then
  begin
    c:='COMx'+#0;
    c[3]:=chr($30+FCOMPort);
  end
  else
  begin
    c:='\\.\COMx'+#0+#0;
    c[7]:=chr($30+(FCOMPort div 10));
    c[8]:=chr($30+(FCOMPort mod 10));
  end;
  FSerHandle:=CreateFile(c,
    GENERIC_READ or GENERIC_WRITE,
    0,
    nil,
    OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OVERLAPPED,
    0);
  if (FSerHandle<>INVALID_HANDLE_VALUE) then
  begin
    with Overlapped do
    begin
      Internal:=0;
      InternalHigh:=0;
      Offset:=0;
      OffsetHigh:=0;
      hEvent:=0;
    end;
    if (not SetupComm(FSerHandle,FBufSizeRec,FBufSizeTrm)) then
    begin
      CloseHandle(FSerHandle);
      FSerHandle:=INVALID_HANDLE_VALUE;
    end;
  end;
  if (FSerHandle<>INVALID_HANDLE_VALUE) then
  begin
    // DCB
    dcb.DCBLength:=SizeOf(TDCB);
    c:='baud=9600 parity=N data=8 stop=1'+#0;
    BuildCommDCB(c,dcb);  // dcb
    // Schnittstellen initialisieren
    if (not SetCommState(FSerHandle,dcb)) then
    begin
      CloseHandle(FSerHandle);
      FSerHandle:=INVALID_HANDLE_VALUE;
    end;
  end;
  if (FSerHandle<>INVALID_HANDLE_VALUE) then
  begin
    if (not IsPolling) then
    begin   // Thread initialisieren (kein Polling Mode)
      SetCommMask(FSerHandle,EV_CTS or EV_DSR or EV_RING or EV_RLSD);  // auf �nderung der Handshake-Leitungen reagieren
      SerPortThread:=TSerPortThread.Create(Self);  // Thread anlegen
    end;
    // Ausg�nge gem�� Voreinstellung setzen
    if FOut_DTR then i:=CLRDTR
                else i:=SETDTR;
    EscapeCommFunction(FSerHandle,i);
    if FOut_RTS then i:=CLRRTS
                else i:=SETRTS;
    EscapeCommFunction(FSerHandle,i);
    if FOut_TxD then i:=CLRBREAK
                else i:=SETBREAK;
    EscapeCommFunction(FSerHandle,i);
  end;
  Result:=FSerHandle<>INVALID_HANDLE_VALUE;
  FActive:=Result;
  if FActive then
    COMManager.AssignCOM(Self);  // COMManager �ber das �ffnen informieren
end;

procedure TSerPort.CloseIt;
// Schnittstelle schlie�en
begin
  if FActive then
  begin
    if (not IsPolling) then
    begin  // kein Polling Mode
      SerPortThread.Terminate;  // Thread zum Beenden auffordern
      SetCommMask(FSerHandle,0);
    end;
    CloseHandle(FSerHandle);
    FSerHandle:=INVALID_HANDLE_VALUE;
    FActive:=false;
    IsPolling:=false;
    COMManager.AssignCOM(Self);  // COMManager �ber das Schlie�en informieren
  end;
end;

procedure TSerPort.PanicClose;
// Schnittstelle ging verloren
// Schnittstelle als geschlossen betrachten
begin
  if (not IsPolling) then
    SerPortThread.Terminate;  // Thread zum Beenden auffordern
  FSerHandle:=INVALID_HANDLE_VALUE;
  IsPolling:=false;
  inherited PanicClose;
end;

procedure TSerPort.SetActive(Value : boolean);
// Schnittstelle �ffnen/schlie�en
begin
  if Value and (not FActive) then FActive:=OpenIt  // �ffnen
  else
  if (not Value) and FActive then CloseIt;  // schlie�en
end;

procedure TSerPort.SetOutDtr(Value : boolean);
// DTR-Ausgang (Value=false -> "0" -> +12V)
begin
  FOut_DTR:=Value;
  if FActive then
    EscapeCommFunction(FSerHandle,ord(Value)+SETDTR);  // V4.1
end;

procedure TSerPort.SetOutRts(Value : boolean);
// DTR-Ausgang (Value=false -> "0" -> +12V)
begin
  FOut_RTS:=Value;
  if FActive then
    EscapeCommFunction(FSerHandle,ord(Value)+SETRTS);  // V4.1
end;

procedure TSerPort.SetOutTxD(Value : boolean);
// TxD-Ausgang (Value=false -> "0" -> +12V)
begin
  FOut_TxD:=Value;
  if FActive then
    EscapeCommFunction(FSerHandle,ord(Value)+SETBREAK);  // V4.1
end;

function TSerPort.GetInDCD : boolean;
// DCD-Eingang (+12V -> "0" -> Result=false)
// Im Polling Mode wird der Leitungsstatus ermittelt
var
  {$IFDEF OLDDELPHI}
  Status : integer;
  {$ELSE}
  Status : cardinal;
  {$ENDIF}
begin
  if IsPolling then
  begin
    GetCommModemStatus(FSerHandle,Status);
    FIn_DCD:=(Status and MS_RLSD_ON)=0;
  end;
  Result:=FIn_DCD;
end;

function TSerPort.GetInDSR : boolean;
// DSR-Eingang (+12V -> "0" -> Result=false)
// Im Polling Mode wird der Leitungsstatus ermittelt
var
  {$IFDEF OLDDELPHI}
  Status : integer;
  {$ELSE}
  Status : cardinal;
  {$ENDIF}
begin
  if IsPolling then
  begin
    GetCommModemStatus(FSerHandle,Status);
    FIn_DSR:=(Status and MS_DSR_ON)=0;
  end;
  Result:=FIn_DSR;
end;

function TSerPort.GetInCTS : boolean;
// CTS-Eingang (+12V -> "0" -> Result=false)
// Im Polling Mode wird der Leitungsstatus ermittelt
var
  {$IFDEF OLDDELPHI}
  Status : integer;
  {$ELSE}
  Status : cardinal;
  {$ENDIF}
begin
  if IsPolling then
  begin
    GetCommModemStatus(FSerHandle,Status);
    FIn_CTS:=(Status and MS_CTS_ON)=0;
  end;
  Result:=FIn_CTS;
end;

function TSerPort.GetInRI : boolean;
// RI-Eingang (+12V -> "0" -> Result=false)
// Im Polling Mode wird der Leitungsstatus ermittelt
var
  {$IFDEF OLDDELPHI}
  Status : integer;
  {$ELSE}
  Status : cardinal;
  {$ENDIF}
begin
  if IsPolling then
  begin
    GetCommModemStatus(FSerHandle,Status);
    FIn_RI:=(Status and MS_RING_ON)=0;
  end;
  Result:=FIn_RI;
end;

function TSerPort.OpenComm : boolean;
// Serielle Schnittstelle �ffnen (public deklarierte Funktion)
// Alternative zur Eigenschaft Active
begin
  Result:=OpenIt;
end;

procedure TSerPort.CloseComm;
// Serielle Schnittstelle schlie�en (public deklarierte Funktion)
// Alternative zur Eigenschaft Active
begin
  CloseIt;
end;

(******************************************************************************)
(*** TSerStdDlg                                                             ***)
(******************************************************************************)

constructor TSerStdDlg.Create(AOwner: TComponent);
// Konstruktor
var
  c : array[0..63] of char;
begin
  inherited Create(AOwner);
  FSerial:=nil;
  // COMMCONFIG und DCB initialisieren
  cc.dwSize:=SizeOf(cc);
  cc.wVersion:=1;
  cc.wReserved:=0;
  cc.dwProviderSubType:=0;
  cc.dwProviderOffset:=0;
  cc.dwProviderSize:=0;
  cc.dcb.DCBLength:=SizeOf(TDCB);
  c:='baud=9600 parity=N data=8 stop=1'+#0;
  BuildCommDCB(c,cc.dcb);  // dcb
end;

procedure TSerStdDlg.Notification(AComponent: TComponent; Operation: TOperation);
// Pr�fen, ob eine zugewiesene Komponente entfernt wurde
begin
  inherited;
  if (Operation=opRemove) and (AComponent=FSerial) then FSerial:=nil;
end;

function TSerStdDlg.Execute : boolean;
// Auswahldialog darstellen
var
  c : array[0..5] of char;
  h : integer;
begin
  c:='COMx'+#0+#0;
  if Assigned(FSerial) then
  begin
    if FSerial.FCOMPort<10 then c[3]:=chr($30+FSerial.FCOMPort)
    else
    begin
      c[3]:=chr($30+(FSerial.FCOMPort div 10));
      c[4]:=chr($30+(FSerial.FCOMPort mod 10));
    end;
  end
  else c[3]:='1';
  // In TSerial gesetzte Parameter �bernehmen
  if Assigned(FSerial) then
  begin
    cc.dcb.Baudrate:=FSerial.Baudrate;  // ge�ndert ab V4.2
    cc.dcb.ByteSize:=ord(FSerial.Databits)+4;
    cc.dcb.Parity:=ord(FSerial.ParityBit);
    cc.dcb.Flags:=cc.dcb.Flags and $FFFFFFFD;  // Flag fParity l�schen
    cc.dcb.Flags:=cc.dcb.Flags or (ord(FSerial.ParityBit>none) shl 1);  // Flag fParity
    cc.dcb.StopBits:=ord(FSerial.StopBits);
    if FSerial.HandshakeRtsCts then
    begin
      cc.dcb.Flags:=cc.dcb.Flags or 4;  // Flag fOutxCtsFlow setzen
      cc.dcb.Flags:=cc.dcb.Flags and $FFFFCFFF;  // Flag fRtsControl l�schen
      cc.dcb.Flags:=cc.dcb.Flags or (RTS_CONTROL_HANDSHAKE shl 12);  // Flag setzen
    end
    else
    if FSerial.HandshakeXOnXOff then
      cc.dcb.Flags:=cc.dcb.Flags or $300  // Flags fOutx und fInx setzen
    else cc.dcb.Flags:=cc.dcb.Flags and $FFFFCCFF;  // relevante Flags l�schen
  end;
  // Dialog aufrufen
  h:=0;
  //  if Owner is TForm then h:=TForm(Owner).Handle;
  Result:=CommConfigDialog(c,h,cc);
  if Result and Assigned(FSerial) then
  begin  // �nderungen in TSerial-Komponente �bernehmen
    case cc.dcb.BaudRate of
      CBR_110    : FSerial.Baudrate:=br_000110;
      CBR_300    : FSerial.Baudrate:=br_000300;
      CBR_600    : FSerial.Baudrate:=br_000600;
      CBR_1200   : FSerial.Baudrate:=br_001200;
      CBR_2400   : FSerial.Baudrate:=br_002400;
      CBR_4800   : FSerial.Baudrate:=br_004800;
      CBR_9600   : FSerial.Baudrate:=br_009600;
      CBR_14400  : FSerial.Baudrate:=br_014400;
      CBR_19200  : FSerial.Baudrate:=br_019200;
      28800      : FSerial.Baudrate:=br_028800;
      CBR_38400  : FSerial.Baudrate:=br_038400;
      CBR_56000  : FSerial.Baudrate:=br_056000;
      CBR_57600  : FSerial.Baudrate:=br_057600;
      CBR_115200 : FSerial.Baudrate:=br_115200;
      CBR_128000 : FSerial.Baudrate:=br_128000;
      230400     : FSerial.Baudrate:=br_230400;
      CBR_256000 : FSerial.Baudrate:=br_256000;
      460800     : FSerial.Baudrate:=br_460800;
      921600     : FSerial.Baudrate:=br_921600;
    end { case };   // andere Werte werden ignoriert
    FSerial.Databits:=TDatabits(cc.dcb.ByteSize-4);
    FSerial.ParityBit:=TParityBit(cc.dcb.Parity);
    FSerial.StopBits:=TStopBits(cc.dcb.StopBits);
    FSerial.HandshakeRtsCts:=(cc.dcb.Flags and $3000)>0;
    FSerial.HandshakeXOnXOff:=(cc.dcb.Flags and $100)>0;
  end;
end;

(******************************************************************************)

procedure Register;
// Komponentenregistrierung
begin
  RegisterComponents('Toolbox', [TSerial,TSerPort,TSerStdDlg]);
end;

{$IFNDEF OLDDELPHI}
initialization
begin
  WindowList:=nil;  // Initialisierung der Fensterliste
  COMManager:=TCOMManager.Create;
end;

finalization

COMManager.Free;

{$ELSE}
begin
  WindowList:=nil;  // Initialisierung der Fensterliste
  COMManager:=TCOMManager.Create;
{$ENDIF}
end.

