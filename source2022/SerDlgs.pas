(******************************************************************************)
(*                                                                            *)
(*   Dialogelemente für TSerial und TSerPort (ab V4.2)                        *)
(*                                                                            *)
(*   (c) 2006 Rainer Reusch & Toolbox                                         *)
(*                                                                            *)
(*   Internet: http://reweb.fh-weingarten.de/toolbox/Projekte/Serial          *)
(*             http://www.toolbox-mag.de                                      *)
(*             http://www.cul.de                                              *)
(*                                                                            *)
(*   E-Mail:   toolbox@reusch-elektronik.de                                   *)
(*             jb@toolbox-mag.de                                              *)
(*                                                                            *)
(*   Borland Delphi 5, 6, 7                                                   *)
(*   Borland C++Builder 6                                                     *)
(*   Lazarus 0.9.6, 0.9.10                                                    *) 
(*                                                                            *)
(****V1.0************************************************************Build2****)

{
RECHTLICHES:
DIE KOMPONENTENSAMMLUNG "SERDLGS" IST  URHEBERRECHTLICH  GESCHÜTZT. SIE DARF VON
LESERN DER ZEITSCHRIFT TOOLBOX UND LESERN DES  COMPUTER&LITERATUR-VERLAGES  OHNE
ENTRICHTUNG EINER LIZENZGEBÜHR BENUTZT WERDEN. DAS  GILT  FÜR  DIE  PRIVATE  UND
GEWERBLICHE  NUTZUNG.  DIE  WEITERGABE  ODER  DER  VERKAUF  DES  QUELLKODES ODER
DER DCU-DATEI IST VERBOTEN!
DIE PUBLIKATION DER QUELLTEXTE ERFOLGT "AS IS". FÜR DIE EINHALTUNG ZUGESICHERTER
EIGENSCHAFTEN ODER FÜR SCHÄDEN, DIE DURCH DEN  EINSATZ  DER  KOMPONENTENSAMMLUNG
ENTSTANDEN SEIN KÖNNTEN, ÜBERNEHMEN WEDER  DER  TOOLBOX-VERLAG,  DER  C&L-VERLAG
NOCH DER AUTOR JEGLICHE HAFTUNG. SIE NUTZEN DIE KOMPONENTENSAMMLUNG  AUF  EIGENE
GEFAHR!

LICENCE AGREEMENT:
THE COMPONENT COLLECTION "SERDLGS" IS PROTECTED BY COPYRIGHT LAW. IT IS NO FREE-
WARE! THIS COLLECTION CAN BE USED BY READERS OF THE  COMPUTER MAGAZINE 'TOOLBOX'
OR BY ANY OTHER READERS FROM THE COMPUTER & LITERATUR PUBLISHING COMPANY WITHOUT
ANY LICENCE FEE. THIS APPLIES THE  PRIVATE  AS WELL AS  COMMERCIAL USAGE.  IT IS
STRICTLY PROHIBITED TO COPY, DISTRIBUTE, OR SELL THE COMPONENT COLLECTION.
THE PUBLICATION OF  THE SOURCES  IS  MADE  "AS IS".  THERE  IS  NO  WARRANTY  OR
LIABILITY GIVEN FOR ADHERENCE,  ASSURED PROPERTIES,  OR DAMAGES  WHICH  MIGHT BE
CAUSED BY THE USE OF THIS SOFTWARE. USAGE IS ON YOUR OWN RISK!
}

{ $DEFINE LAZARUS}  // bei Lazarus muss die Direktive aktiviert sein

{$IFDEF LAZARUS}
  {$MODE DELPHI}
{$ENDIF}

unit SerDlgs;

interface

uses
  SysUtils, Controls, Classes, StdCtrls, Serial;

type
  // Basisklasse für serielle Comboboxen
  TSerComboBox = class (TCustomComboBox)
  published
    property Color;
    property DropDownCount;
    property Enabled;
    property Font;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
  end;
  // Combobox zur Auswahl der seriellen Schnittstelle
  TSerPortComboBox = class (TSerComboBox)
  private
    FSerial : TCustomSerial;
    procedure Feedback;
  protected
    procedure Loaded; override;
    procedure Change; override;  // Auswahl hat sich geändert
  public
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    destructor  Destroy; override;                     // Destruktor
    procedure UpdateList;                              // Liste aktualisieren
  published
    property Serial : TCustomSerial read FSerial write FSerial;
  end;
  // Combobox zur Auswahl der Übertragungsrate
  TSerBaudComboBox = class (TSerComboBox)
  private
    FSerial : TSerial;
    FText   : string;
  protected
    procedure Loaded; override;
    procedure Change; override;  // Auswahl hat sich geändert
  public
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    destructor  Destroy; override;                     // Destruktor
    procedure InitList(FromBaud, ToBaud : integer);    // Liste mit Standardwerten füllen
    procedure ClearList;                               // Liste leeren
    procedure AddList(Baud : integer);                 // einen Eintrag in die Liste hinzufügen
    procedure UpdateList;                              // Auswahl aktualisieren
  published
    property Serial : TSerial read FSerial write FSerial;
    property Text : string read FText write FText;     // zusätzlicher Text
  end;
  // Combobox zur Auswahl der Anzahl der Datenbits
  TSerDataBitsComboBox = class (TSerComboBox)
  private
    FSerial : TSerial;
    FText   : string;
    FMin    : TDataBits;
    FMax    : TDataBits;
    procedure SetMin(Value : TDataBits);
    procedure SetMax(Value : TDataBits);
  protected
    procedure Loaded; override;
    procedure Change; override;  // Auswahl hat sich geändert
  public
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    destructor  Destroy; override;                     // Destruktor
    procedure UpdateList;                              // Liste aktualisieren
  published
    property Serial : TSerial read FSerial write FSerial;
    property Text : string read FText write FText;     // zusätzlicher Text
    property Min : TDataBits read FMin write SetMin;   // kleinste Einstellung
    property Max : TDataBits read FMax write SetMax;   // größte Einstellung
  end;
  // Combobox zur Auswahl der Anzahl der Stoppbits
  TSerStopBitsComboBox = class (TSerComboBox)
  private
    FSerial : TSerial;
    FText   : string;
  protected
    procedure Loaded; override;
    procedure Change; override;  // Auswahl hat sich geändert
  public
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    destructor  Destroy; override;                     // Destruktor
    procedure UpdateList;                              // Auswahl aktualisieren
  published
    property Serial : TSerial read FSerial write FSerial;
    property Text : string read FText write FText;     // zusätzlicher Text
  end;
  // Combobox zur Auswahl des Paritätsbits
  TSerParityBitComboBox = class (TSerComboBox)
  private
    FSerial : TSerial;
  protected
    procedure Loaded; override;
    procedure Change; override;  // Auswahl hat sich geändert
  public
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    destructor  Destroy; override;                     // Destruktor
    procedure UpdateList;                              // Auswahl aktualisieren
  published
    property Serial : TSerial read FSerial write FSerial;
  end;
  // Combobox zur Auswahl der Handshake
  TSerHandshakeComboBox = class (TSerComboBox)
  private
    FSerial : TSerial;
    FViewNone,
    FViewSoft,
    FViewRTSCTS,
    FViewDTRDSR : boolean;
    FTextNone,
    FTextSoft,
    FTextRTSCTS,
    FTextDTRDSR : string;
    procedure SetViewNone(Value : boolean);
    procedure SetViewSoft(Value : boolean);
    procedure SetViewRTSCTS(Value : boolean);
    procedure SetViewDTRDSR(Value : boolean);
    procedure SetTextNone(Value : string);
    procedure SetTextSoft(Value : string);
    procedure SetTextRTSCTS(Value : string);
    procedure SetTextDTRDSR(Value : string);
  protected
    procedure Loaded; override;
    procedure Change; override;  // Auswahl hat sich geändert
  public
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    destructor  Destroy; override;                     // Destruktor
    procedure UpdateList;                              // Liste aktualisieren
  published
    property Serial : TSerial read FSerial write FSerial;
    property ViewNone : boolean read FViewNone write SetViewNone;        // Anzeige "keinen"
    property ViewSoft : boolean read FViewSoft write SetViewSoft;        // Anzeige "Software"
    property ViewRTSCTS : boolean read FViewRTSCTS write SetViewRTSCTS;  // Anzeige "RTS/CTS"
    property ViewDTRDSR : boolean read FViewDTRDSR write SetViewDTRDSR;  // Anzeige "DTR/DSR"
    property TextNone : string read FTextNone write SetTextNone;         // Text "keinen"
    property TextSoft : string read FTextSoft write SetTextSoft;         // Text "Software"
    property TextRTSCTS : string read FTextRTSCTS write SetTextRTSCTS;   // Text "RTS/CTS"
    property TextDTRDSR : string read FTextDTRDSR write SetTextDTRDSR;   // Text "DTR/DSR"
  end;
  // Checkbox RTS aktiv
  TSerRTSCheckBox = class (TCustomCheckBox)
  private
    FSerial   : TSerial;
    FCaption2 : TCaption;
    IsDTR     : boolean;
    procedure SetCaption(Value : TCaption);
  protected
    procedure Loaded; override;
    procedure Click; override;  // Auswahl hat sich geändert
  public
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    destructor  Destroy; override;                     // Destruktor
    procedure Update; override;                        // Anzeige aktualisieren
  published
    property Serial : TSerial read FSerial write FSerial;
    property Caption : TCaption read FCaption2 write SetCaption;  // Text
    property Enabled;
    property Font;
    property ShowHint;
    property TabOrder;
    property Visible;
    property OnClick;
  end;
  // Checkbox DTR aktiv
  TSerDTRCheckBox = class (TSerRTSCheckBox)
  public
    constructor Create(AOwner: TComponent); override;  // Konstruktor
    destructor  Destroy; override;                     // Destruktor
  end;

procedure Register;

implementation

resourcestring
  // verwendete Texte
  spb_none  = 'none';
  spb_odd   = 'odd';
  spb_even  = 'even';
  spb_mark  = 'mark';
  spb_space = 'space';
  shs_none  = 'none';
  shs_soft  = 'XOn/XOff';
  shs_rts   = 'RTS/CTS';
  shs_dtr   = 'DTR/DSR';

const
  // Standard-Übertragungsraten
  Baudrates : array[0..20] of integer =
    (br_000050,br_000110,br_000150,br_000300,br_000600,br_001200,br_002400,
     br_004800,br_009600,br_014400,br_019200,br_028800,br_038400,br_056000,
     br_057600,br_115200,br_128000,br_230400,br_256000,br_460800,br_921600);

(*** TSerPortComboBox *********************************************************)

constructor TSerPortComboBox.Create(AOwner: TComponent);
// Konstruktor
begin
  inherited Create(AOwner);
  Parent:=AOwner as TWinControl;
  Style:=csDropDownList;
  FSerial:=nil;
  COMManager.RegisterFeedback(Feedback);  // Feedback-Methode beim COMManager registrieren
end;

destructor  TSerPortComboBox.Destroy;
// Destruktor
begin
  COMManager.UnregisterFeedback(Feedback);  // Registrierung löschen
  inherited Destroy;
end;

procedure TSerPortComboBox.Loaded;
// Einstellungen beim Programmstart übernehmen
begin
  inherited Loaded;
  UpdateList;
end;

procedure TSerPortComboBox.UpdateList;
// Liste der vorhandenen Schnittstellen aktualisieren
var
  i, p : integer;
begin
  Items.Assign(COMManager.Ports);
  p:=-1;
  if Assigned(FSerial) and (Items.Count>0) then
    for i:=0 to Items.Count-1 do
      if PCOMInfo(COMManager.Ports.Objects[i])^.Number=FSerial.COMPort then p:=i;
  ItemIndex:=p;
end;

procedure TSerPortComboBox.Feedback;
// Rückmeldung vom COMManager:
// Bei den vorhandenen Schnittstellen hat sich eine Änderung ergeben
begin
  UpdateList;  // Liste aktualisieren
end;

procedure TSerPortComboBox.Change;
// Änderung der Auswahl durch den Anwender
begin
  if Assigned(FSerial) then
  begin  // Seriell-Komponente aktualisieren
    if COMManager.Ports.Count>0 then FSerial.PortByIndex(ItemIndex)
                                else FSerial.COMPort:=0;
  end;
  inherited Change;
end;

(*** TSerBaudComboBox *********************************************************)

constructor TSerBaudComboBox.Create(AOwner: TComponent);
// Konstruktor
begin
  inherited Create(AOwner);
  Parent:=AOwner as TWinControl;
  Style:=csDropDownList;
  FSerial:=nil;
  FText:=' Baud';  // zusätzlicher Text in jedem Eintrag
  InitList(50,921600);  // Standard-Übertragungsraten von 50 bis 921600 Baud
  UpdateList;
end;

destructor  TSerBaudComboBox.Destroy;
// Destruktor
begin
  inherited Destroy;
end;

procedure TSerBaudComboBox.Loaded;
// Einstellungen beim Programmstart übernehmen
begin
  inherited Loaded;
  UpdateList;
end;

procedure TSerBaudComboBox.Change;
// Änderung der Auswahl durch den Anwender
begin
  if Assigned(FSerial) then
    FSerial.Baudrate:=integer(Items.Objects[ItemIndex]);  // Seriell-Komponente aktualisieren
  inherited Change;
end;

procedure TSerBaudComboBox.InitList(FromBaud, ToBaud : integer);
// ComboBox mit einer Liste einstellbarer Standardübertragungsraten füllen
var
  b1, b2, i : integer;
begin
  // Parameter prüfen
  b1:=0;
  b2:=20;
  for i:=0 to 20 do
    if FromBaud>=Baudrates[i] then b1:=i;
  for i:=20 downto 0 do
    if ToBaud<=Baudrates[i] then b2:=i;
  if b2<b1 then Exit;
  // neue Liste
  Clear;
  for i:=b1 to b2 do
    Items.AddObject(IntToStr(Baudrates[i])+FText,pointer(Baudrates[i]));
  UpdateList;
end;

procedure TSerBaudComboBox.ClearList;
// Liste der Übertragungsraten löschen
begin
  Clear;
end;

procedure TSerBaudComboBox.AddList(Baud : integer);
// Einen Eintrag der Liste von Übertragungsraten hinzufügen
// in Objects wird die Baudrate als Integerzahl vermerkt
const
  // Quarzfrequenz (Basis für die Berechnung realer übertragungsraten
  Freq = 115200*16*5;  // 9,216MHz
begin
  if (Baud<50) or (Baud>921600) then Exit;  // Werte außerhalb des Bereichs werden nicht akzeptiert
  Baud:=Freq div (Freq div Baud);  // Übertragungsrate auf technisch möglichen Wert runden
  Items.AddObject(IntToStr(Baud)+FText,pointer(Baud));
end;

procedure TSerBaudComboBox.UpdateList;
// Liste neu generieren (aus Objects-Einträgen)
var
  i, j : integer;
begin
  if Items.Count=0 then Exit;
  // Einträge aktualisieren
  for i:=0 to Items.Count-1 do
    Items[i]:=IntToStr(integer(Items.Objects[i]))+FText;
  // passenden Eintrag suchen
  if Assigned(FSerial) then
  begin
    j:=-1;
    for i:=0 to Items.Count-1 do
      if integer(Items.Objects[i])=FSerial.Baudrate then j:=i;
    ItemIndex:=j;
  end;
end;

(*** TSerDataBitsComboBox *****************************************************)

constructor TSerDataBitsComboBox.Create(AOwner: TComponent);
// Konstruktor
begin
  inherited Create(AOwner);
  Parent:=AOwner as TWinControl;
  Style:=csDropDownList;
  FSerial:=nil;
  FText:=' Bit';  // Vorgabe zusätzlicher Text
  FMin:=db_4;
  FMax:=db_8;
  UpdateList;
end;

destructor  TSerDataBitsComboBox.Destroy;
// Destruktor
begin
  inherited Destroy;
end;

procedure TSerDataBitsComboBox.Loaded;
// Einstellungen beim Programmstart übernehmen
begin
  inherited Loaded;
  UpdateList;
end;

procedure TSerDataBitsComboBox.UpdateList;
// Liste initialisieren
var
  i : TDataBits;
begin
  Clear;
  for i:=FMin to FMax do
    Items.Add(IntToStr(ord(i)+4)+FText);
  if Assigned(FSerial) then ItemIndex:=ord(FSerial.DataBits)-ord(FMin);
end;

procedure TSerDataBitsComboBox.Change;
// Änderung der Auswahl durch den Anwender
begin
  if Assigned(FSerial) then
    FSerial.DataBits:=TDataBits(ItemIndex+ord(FMin));  // Seriell-Komponente aktualisieren
  inherited Change;
end;

procedure TSerDataBitsComboBox.SetMin(Value : TDataBits);
// kleinste Einstellung in der Liste festlegen
begin
  if Value>FMax then Value:=FMax;
  FMin:=Value;
  UpdateList;
  if Assigned(FSerial) then ItemIndex:=ord(FSerial.DataBits);
end;

procedure TSerDataBitsComboBox.SetMax(Value : TDataBits);
// größte Einstellung in der Liste festlegen
begin
  if Value<FMin then Value:=FMin;
  FMax:=Value;
  UpdateList;
  if Assigned(FSerial) then ItemIndex:=ord(FSerial.DataBits);
end;

(*** TSerStopBitsComboBox *****************************************************)

constructor TSerStopBitsComboBox.Create(AOwner: TComponent);
// Konstruktor
begin
  inherited Create(AOwner);
  Parent:=AOwner as TWinControl;
  Style:=csDropDownList;
  FSerial:=nil;
  FText:=' Bit';  // Vorgabe zusätzlicher Text
  UpdateList;
end;

destructor  TSerStopBitsComboBox.Destroy;
// Destruktor
begin
  inherited Destroy;
end;

procedure TSerStopBitsComboBox.Loaded;
// Einstellungen beim Programmstart übernehmen
begin
  inherited Loaded;
  UpdateList;
end;

procedure TSerStopBitsComboBox.UpdateList;
// Liste initialisieren
begin
  Clear;
  Items.Add('1'+FText);
  Items.Add('1,5'+FText);
  Items.Add('2'+FText);
  if Assigned(FSerial) then ItemIndex:=ord(FSerial.StopBits);
end;

procedure TSerStopBitsComboBox.Change;
// Änderung der Auswahl durch den Anwender
begin
  if Assigned(FSerial) then
    FSerial.StopBits:=TStopBits(ItemIndex);  // Seriell-Komponente aktualisieren
  inherited Change;
end;

(*** TSerParityBitComboBox *****************************************************)

constructor TSerParityBitComboBox.Create(AOwner: TComponent);
// Konstruktor
begin
  inherited Create(AOwner);
  Parent:=AOwner as TWinControl;
  Style:=csDropDownList;
  FSerial:=nil;
  UpdateList;
end;

destructor TSerParityBitComboBox.Destroy;
// Destruktor
begin
  inherited Destroy;
end;

procedure TSerParityBitComboBox.Loaded;
// Einstellungen beim Programmstart übernehmen
begin
  inherited Loaded;
  UpdateList;
end;

procedure TSerParityBitComboBox.UpdateList;
// Liste initialisieren
begin
  Clear;
  Items.Add(spb_none);  // Textkonstanten
  Items.Add(spb_odd);
  Items.Add(spb_even);
  Items.Add(spb_mark);
  Items.Add(spb_space);
  if Assigned(FSerial) then ItemIndex:=ord(FSerial.ParityBit);
end;

procedure TSerParityBitComboBox.Change;
// Änderung der Auswahl durch den Anwender
begin
  if Assigned(FSerial) then
    FSerial.ParityBit:=TParityBit(ItemIndex);  // Seriell-Komponente aktualisieren
  inherited Change;
end;

(*** TSerHandshakeComboBox *****************************************************)

constructor TSerHandshakeComboBox.Create(AOwner: TComponent);
// Konstruktor
begin
  inherited Create(AOwner);
  Parent:=AOwner as TWinControl;
  Style:=csDropDownList;
  FSerial:=nil;
  FViewNone:=true;
  FViewSoft:=true;
  FViewRTSCTS:=true;
  FViewDTRDSR:=true;
  FTextNone:=shs_none;
  FTextSoft:=shs_soft;
  FTextRTSCTS:=shs_rts;
  FTextDTRDSR:=shs_dtr;
  UpdateList;
end;

destructor TSerHandshakeComboBox.Destroy;
// Destruktor
begin
  inherited Destroy;
end;

procedure TSerHandshakeComboBox.Loaded;
// Einstellungen beim Programmstart übernehmen
begin
  inherited Loaded;
  UpdateList;
end;

procedure TSerHandshakeComboBox.UpdateList;
// Liste initialisieren
var
  i, j, k : integer;
begin
  // Liste neu anlegen (Objects wird als Identifikation verwendet)
  Clear;
  if FViewNone then Items.AddObject(FTextNone,pointer(0));
  if FViewSoft then Items.AddObject(FTextSoft,pointer(1));
  if FViewRTSCTS then Items.AddObject(FTextRTSCTS,pointer(2));
  if FViewDTRDSR then Items.AddObject(FTextDTRDSR,pointer(3));
  // gemäß Serial-Einstellung nach passendem Eintrag suchen
  k:=-1;
  if Assigned(FSerial) and (Items.Count>0) then
  begin
    i:=0;
    if (FSerial.HandshakeXOnXOff) and FViewSoft then i:=1
    else
    if (FSerial.HandshakeRTSCTS) and FViewRTSCTS then i:=2
    else
    if (FSerial.HandshakeDTRDSR) and FViewDTRDSR then i:=3;
    k:=-1;
    for j:=0 to Items.Count-1 do
      if integer(Items.Objects[j])=i then k:=j;
  end;
  ItemIndex:=k;
end;

procedure TSerHandshakeComboBox.Change;
// Änderung der Auswahl durch den Anwender
begin
  if Assigned(FSerial) and (ItemIndex>=0) then
  begin
    case integer(Items.Objects[ItemIndex]) of
      0: begin  // kein
           FSerial.HandshakeXOnXOff:=false;
           FSerial.HandshakeRTSCTS:=false;
           FSerial.HandshakeDTRDSR:=false;
         end;
      1: begin  // XOn/XOff
           FSerial.HandshakeXOnXOff:=true;
           FSerial.HandshakeRTSCTS:=false;
           FSerial.HandshakeDTRDSR:=false;
         end;
      2: begin  // RTS/CTS
           FSerial.HandshakeXOnXOff:=false;
           FSerial.HandshakeRTSCTS:=true;
           FSerial.HandshakeDTRDSR:=false;
         end;
      3: begin  // DTR/DSR
           FSerial.HandshakeXOnXOff:=false;
           FSerial.HandshakeRTSCTS:=false;
           FSerial.HandshakeDTRDSR:=true;
         end;
    end { case };
  end;
  inherited Change;
end;

procedure TSerHandshakeComboBox.SetViewNone(Value : boolean);
// Eintrag "keinen" anzeigen/nicht anzeigen
begin
  if Value=FViewNone then Exit;
  FViewNone:=Value;
  UpdateList;
end;

procedure TSerHandshakeComboBox.SetViewSoft(Value : boolean);
// Eintrag "Software" anzeigen/nicht anzeigen
begin
  if Value=FViewSoft then Exit;
  FViewSoft:=Value;
  UpdateList;
end;

procedure TSerHandshakeComboBox.SetViewRTSCTS(Value : boolean);
// Eintrag "RTS/CTS" anzeigen/nicht anzeigen
begin
  if Value=FViewRTSCTS then Exit;
  FViewRTSCTS:=Value;
  UpdateList;
end;

procedure TSerHandshakeComboBox.SetViewDTRDSR(Value : boolean);
// Eintrag "DTR/DSR" anzeigen/nicht anzeigen
begin
  if Value=FViewDTRDSR then Exit;
  FViewDTRDSR:=Value;
  UpdateList;
end;

procedure TSerHandshakeComboBox.SetTextNone(Value : string);
// Text für "keinen" festlegen
begin
  if Value=FTextNone then Exit;
  FTextNone:=Value;
  UpdateList;
end;

procedure TSerHandshakeComboBox.SetTextSoft(Value : string);
// Text für "Software" festlegen
begin
  if Value=FTextSoft then Exit;
  FTextSoft:=Value;
  UpdateList;
end;

procedure TSerHandshakeComboBox.SetTextRTSCTS(Value : string);
// Text für "RTS/CTS" festlegen
begin
  if Value=FTextRTSCTS then Exit;
  FTextRTSCTS:=Value;
  UpdateList;
end;

procedure TSerHandshakeComboBox.SetTextDTRDSR(Value : string);
// Text für "DTR/DSR" festlegen
begin
  if Value=FTextDTRDSR then Exit;
  FTextDTRDSR:=Value;
  UpdateList;
end;

(*** TSerRTSCheckBox **********************************************************)

constructor TSerRTSCheckBox.Create(AOwner: TComponent);
// Konstruktor
begin
  inherited Create(AOwner);
  Parent:=AOwner as TWinControl;
  IsDTR:=false;
  FSerial:=nil;
end;

destructor  TSerRTSCheckBox.Destroy;
// Destruktor
begin
  inherited Destroy;
end;

procedure TSerRTSCheckBox.Loaded;
// Einstellungen beim Programmstart übernehmen
begin
  inherited Loaded;
  Update;
end;

procedure TSerRTSCheckBox.Update;
// Anzeige aktualisieren
begin
  if Assigned(FSerial) then
  case IsDTR of
    false : Checked:=FSerial.RTSActive;
    true  : Checked:=FSerial.DTRActive;
  end { case };
  inherited Caption:=FCaption2;
  inherited Update;
end;

procedure TSerRTSCheckBox.Click;
// Auswahl hat sich geändert
begin
  if Assigned(FSerial) then
  case IsDTR of
    false : FSerial.RTSActive:=Checked;
    true  : FSerial.DTRActive:=Checked;
  end { case };
  inherited Click;
end;

procedure TSerRTSCheckBox.SetCaption(Value : TCaption);
// Text festlegen
begin
  FCaption2:=Value;
  Update;
end;

(*** TSerDTRCheckBox **********************************************************)

constructor TSerDTRCheckBox.Create(AOwner: TComponent);
// Konstruktor
begin
  inherited Create(AOwner);
  IsDTR:=true;
end;

destructor  TSerDTRCheckBox.Destroy;
// Destruktor
begin
  inherited Destroy;
end;

(*** Allgemeines **************************************************************)

procedure Register;
// Komponentenregistrierung
begin
  RegisterComponents('Toolbox',
    [TSerPortComboBox,TSerBaudComboBox,TSerDataBitsComboBox,TSerStopBitsComboBox,
     TSerParityBitComboBox,TSerHandshakeComboBox,TSerRTSCheckBox,TSerDTRCheckBox]);
end;

end.
