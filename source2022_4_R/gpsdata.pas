unit gpsdata;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Serial, StdCtrls, Menus, SerAddons;

type
  TGPS = class(TForm)
    Seriell: TSerial;
    NumSatTxt: TLabel;
    LaengeTxt: TLabel;
    HoeheTxt: TLabel;
    BreiteTxt: TLabel;
    NumSat: TLabel;
    Laenge: TLabel;
    Breite: TLabel;
    Hoehe: TLabel;
    Text: TLabel;
    Start: TButton;
    Stop: TButton;
    Einst: TButton;
    Status: TLabel;
    Empfang: TLabel;
    GPRMC: TLabel;
    GPGGA: TLabel;
    Edit1: TEdit;
    Debug: TLabel;
    DebugBox: TCheckBox;
    ZeitTxt: TLabel;
    GenauTxt: TLabel;
    Zeit: TLabel;
    Genau: TLabel;
    DatumTxt: TLabel;
    Datum: TLabel;
    BreiteNS: TLabel;
    LaengeOW: TLabel;
    HoeheM: TLabel;
    SerExtDlg: TSerExtDlg;
    GPGSA: TLabel;
    GPGSV: TLabel;
    procedure EinstClick(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure SeriellEventChar(Sender: TObject);
    procedure DebugBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  GPS: TGPS;
  Zeichenkette: String; // gesamte empfangene Zeichen (nur fuer Debug-Zwecke)
  Anzahl: integer;      // Anzahl empfangener Datensaetze
  DebugFlag: Boolean;   // Debug-Informationen anzeigen
  TeilString: String;   // bestimmter Teildatensatz
  TempString: String;   // Daten zwischen zwei Kommata
  Komma2: integer;      // Position des zweiten Kommas
  Warnung: Boolean;     // GPS-Warnung

implementation

{$R *.DFM}

procedure TGPS.EinstClick(Sender: TObject);
begin
  SerExtDlg.Execute;
end;

procedure TGPS.StartClick(Sender: TObject);
var
  Rueckgabe: boolean;
  i: integer;
begin
  // Button Einstellungen deaktivieren
  Einst.Enabled := False;

  // Schnittstelle checken
  if (COMAvailable (Seriell.COMPort) = false) then begin
    // erste verfuegbare suchen
    for i := 1 to 8 do begin
      if (COMAvailable (i) = True) then begin
        Seriell.COMPort := i;
        break;
      end;
    end;
  end;

  // Schnittstelle mit default Werten oeffnen
  Rueckgabe := Seriell.OpenComm;
  if (Rueckgabe = True) then begin
    Text.Caption := 'COM ' + IntToStr (Seriell.ComPort) + ' geoeffnet';

    // Felder loeschen
    GPGGA.Caption := '';
    GPRMC.Caption := '';
    GPGSA.Caption := '';
    GPGSV.Caption := '';
    NumSat.Caption := '0';
    Zeit.Caption := '000000';
    Datum.Caption := '000000';
    Genau.Caption := '0.0';
    Laenge.Caption := '0.0';
    LaengeOW.Caption := 'W';
    Breite.Caption := '0.0';
    BreiteNS.Caption := 'S';
    Hoehe.Caption := '0';
    HoeheM.Caption := 'M';
    Warnung := false;

    // Zeichenkette loeschen
    Empfang.Caption := '';
    Zeichenkette := '';
    Anzahl := 0;
    DebugFlag := false;
    if (DebugBox.Checked = true) then begin
      DebugFlag := true;
      Edit1.Visible := true;
    end;
  end else begin
    Text.Caption := 'Fehler beim Oeffnen von COM ' + IntToStr (Seriell.ComPort);
  end;
end;

procedure TGPS.StopClick(Sender: TObject);
begin
  // Schnittstelle schliessen
  Seriell.CloseComm;
  Text.Caption := '';
  if (DebugFlag = true) then
    Text.Caption := IntToStr (Anzahl) + ' - ' ;
  Text.Caption := Text.Caption + 'COM ' + IntToStr (Seriell.ComPort) + ' geschlossen';
  Edit1.Text := Zeichenkette;

  // Button Einstellungen aktivieren
  Einst.Enabled := true;
end;

function NaechstesDatum (Start: integer) : integer;
var
  i: integer;
  Komma: integer;   // Position des Kommas
begin
  Result := 1;
  if (Start = 0) then begin
    Komma := Pos(',', TeilString);
  end else begin
    if (Start = 1) then begin
      Komma := Komma2;
    end else begin
      Komma := Start;
    end;
  end;
  if (Komma <> 0) then begin
    TeilString[Komma] := '-';
    Komma2 := Pos(',', TeilString);
    if (Komma2 <> 0) then begin
      // Info kopieren
      TempString := '';
      TeilString[Komma2] := '-';
      for i := Komma + 1 to Komma2 - 1 do begin
        TempString := TempString + ' ';
        TempString[i-Komma] := TeilString [i];
      end;
    end else begin
      Result := 0;
    end;
  end else begin
    Result := 0;
  end;
end;

procedure TGPS.SeriellEventChar(Sender: TObject);
var
  Zeichen: String;
  Komma: integer;
  i: integer;
  Rueckgabe: integer;
  Fehler: boolean;
begin
  // Zeichen auslesen, default ohne Timeout !
  Zeichen := Seriell.ReceiveText;
  Anzahl := Anzahl + 1;
  Fehler := false;

  // ... und ausgeben
  if (DebugFlag = true) then begin
    Empfang.Caption := Zeichen;
  end else begin
    Empfang.Caption := '   ... Empfange Zeichen ...';
  end;

  // nur Debugging
  Zeichenkette := (* Zeichenkette + *) Zeichen;

  // nach Daten verzweigen ...
  // $GPGGA - GPS feste Daten
  if (strpos (PChar (Zeichen), PChar ('GGA')) <> nil) then begin
    TeilString := string (strpos (PChar (Zeichen), PChar ('GGA')));
    if (DebugFlag = true) then
      GPGGA.Caption := 'GPGGA';

    // Zeit
    Rueckgabe := NaechstesDatum (0);
    if (Rueckgabe = 0) then begin
      Fehler := true;
    end else begin
      Zeit.Caption := TempString;
    end;

    // Breitengrad
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        Breite.Caption := TempString;
      end;
    end;

    // Breite
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        BreiteNS.Caption := TempString;
      end;
    end;

    // Laengengrad
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        Laenge.Caption := TempString;
      end;
    end;

    // Laenge
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        LaengeOW.Caption := TempString;
      end;
    end;

    // Gueltigkeit
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        if (TempString = '1') then
          Text.Caption := ' Daten gueltig ...';
        if (TempString = '0') then
          Text.Caption := ' Daten ungueltig !!!';
      end;
    end;

    // Anzahl
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        NumSat.Caption := TempString;
      end;
    end;

    // Genauigkeit
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        Genau.Caption := TempString;
      end;
    end;

    // Hoehe
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        Hoehe.Caption := TempString;
      end;
    end;

    // Hoehe M
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe = 0) then begin
        Fehler := true;
      end else begin
        HoeheM.Caption := TempString;
      end;
    end;
  end;

  // $GPRMC - Minimum Navi Informationen
  if (strpos (PChar (Zeichen), PChar ('RMC')) <> nil) then begin
    TeilString := string (strpos (PChar (Zeichen), PChar ('RMC')));
    if (DebugFlag = true) then
      GPRMC.Caption := 'GPRMC';

    // naechstes Datum
    Fehler := true;
    Rueckgabe := NaechstesDatum (0);
    if (Rueckgabe <> 0) then begin
      Zeit.Caption := TempString;
      Rueckgabe := NaechstesDatum (1);
      if (Rueckgabe <> 0) then begin
        Fehler := false;
        if (TempString = 'V') then begin
          if (Warnung = false) then begin
            Text.Caption := Text.Caption + ' - GPS-Warnung !!!';
            Warnung := true;
          end;
        end;
      end;
    end;

    // Infos ueberspringen
    if (Fehler = false) then begin
      for i := 1 to 5 do begin
        Komma := Pos(',', TeilString);
        if (Komma <> 0) then begin
          TeilString[Komma] := '-';
        end else begin
          Fehler := true;
          break;
        end;
      end;
    end;

    // Datum
    if (Fehler = false) then begin
      Rueckgabe := NaechstesDatum (0);
      if (Rueckgabe <> 0) then begin
        Datum.Caption := TempString;
      end;
    end;
  end;

  // $GPGSA - Satelliten Informationen
  if (strpos (PChar (Zeichen), PChar ('GSA')) <> nil) then begin
    TeilString := string (strpos (PChar (Zeichen), PChar ('GSA')));
    if (DebugFlag = true) then
      GPGSA.Caption := 'GPGSA';
  end;

  // $GPGSV - sichtbare Satelliten
  if (strpos (PChar (Zeichen), PChar ('GSV')) <> nil) then begin
    TeilString := string (strpos (PChar (Zeichen), PChar ('GSV')));
    if (DebugFlag = true) then
      GPGSV.Caption := 'GPGSV';
  end;
end;

procedure TGPS.DebugBoxClick(Sender: TObject);
begin
  DebugFlag := false;
  Edit1.Visible := false;
  if (DebugBox.Checked = true) then begin
    DebugFlag := true;
    Edit1.Visible := true;
  end;
end;

end.
