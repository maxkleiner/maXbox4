unit HList;
{ enthält
   - THistoryList, verwendbar zur Verwaltung
     von geladenen Dateien und zum Anhängen an ein Menü
   - THistoryCombo, die Combobox, die diese
     die Eingaben automatisch in einer Liste sammelt

   Autor: Elmar Warken, 1995/1996 }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
{$ifdef Win32}
  Registry,
{$else}
  IniFiles,
{$endif}
  Menus;

type
  { Event, das bei Anwahl eines der automatisch zum Menü
    hinzugefügten Einträge ausgelöst wird: }
  TListMenuEvent = procedure(Sender : TObject; MenuText : string)
                     of object;

  THistoryList = class(TStringList)
  { Stringliste, die
    - sich selbst an ein Menü anhängen kann, wobei sie
      die Menüpunkte mit Zahlen durchnumeriert,
    - sich in die Registry/eine INI-Datei speichern
      und von dort wieder lesen kann }
  private
    FMaxLen : integer;
    FMenuItem : TMenuItem;
    MenuSizeBefore : integer;
    { Speichert die vorherige Menügröße zur späteren
      Rekonstruktion }
    FOnAutoItemClick : TListMenuEvent;

    procedure SetMenuItem(MenuItem : TMenuItem);
    procedure AddMenuItems;
    procedure RemoveMenuItems;
    procedure SetMaxLen(AnInt : integer);
    procedure DoAutoItemClick(Sender : TObject);
       { empfängt die OnClick-Ereignisse }
  public
    constructor Create;
    { Maximale Länge der Liste, Voreinstellung 10
      (wird nicht gespeichert, daher kein default-Teil): }
    property MaxLen : integer read FMaxLen write SetMaxLen;
    { Aufnahme eines Strings in die Liste, doppelte
      werden gelöscht: }
    procedure AddString(s : string);

    { Funktionsbereich INI-Datei: die beiden folgenden
      Funktionen müssen manuell aufgerufen werden
      (für die Automatisierung gibt es die THistoryCombo): }
    procedure SaveToIni(IniName, IniSection : string);
    procedure LoadFromIni(IniName, IniSection : string);

    { Funktionsbereich Menü: sobald MenuItem einmal gesetzt ist,
      paßt die Liste das Menü immer an. }
    property MenuItem : TMenuItem read FMenuItem write SetMenuItem;
    { der Kompatibilität zum Delphi 1-Buch wegen wird der Menü-Item auch
      unter dem folgenden Namen ansprechbar: }
    property Menu : TMenuItem read FMenuItem write SetMenuItem;
    property OnAutoItemClick : TListMenuEvent read FOnAutoItemClick
                                            write FOnAutoItemClick;
  end;

  THistoryCombo = class(TComboBox)
  { Combobox, die beim Laden aus einem Stream automatisch
    einen in einer INI-Datei gespeicherten zustand wiederherstellt,
    und bei Programmende die INI-Datei aktualisiert.
  }
  private
    property Items;
  protected
    FRegistryPath : string;
    FIniFileName : string;
    FIniSection : string;
    FHistoryList : THistoryList;
    FManualUpdate: Boolean;

    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override; { hier wird die INI-Datei geschrieben }
    procedure DoExit; override; { hier wird die Liste aktualisiert }
    procedure SetIniData(index : integer; str: string);
    procedure UpdateComboList; { Laden der HistoryList in die eigenen Items. }
  public
    property HistoryList : THistoryList read FHistoryList; { verwaltet
      die Liste der Strings (automatische Längenbeschränkung etc) }
    procedure UpdateList;
  published
    { Unter Win32: Pfad der Speicherung in der Registrierung }
    property RegistryPath : string index 0 read FRegistryPath write SetIniData;
    { Name der zu verwendenden INI-Datei: }
    property IniFileName : string index 1 read FIniFileName write SetIniData;
    { Name des zu verwendenden INI-Datei-Abschnitts: }
    property IniSection : string index 2 read FIniSection write SetIniData;
    { Extra-Property (siehe Hinsweis im Buch }
    property ManualUpdate: boolean read FManualUpdate write FManualUpdate default False;
  end;

procedure Register;

implementation

(********** THistoryList ***********)

constructor THistoryList.Create;
begin
  inherited Create;
  FMaxLen:=10;
end;

procedure THistoryList.SaveToIni(IniName, IniSection : string);
var
  i : integer;
{$ifdef Win32}
  IniFile : TRegIniFile;
{$else}
  IniFile : TIniFile;
{$endif}
begin
  { Da IniFile.FileName nicht nachträglich geändert werden kann,
    muß IniFile jedesmal neu initialisiert werden: }
{$ifdef Win32}
  IniFile:=TRegIniFile.Create(IniName);
{$else}
  IniFile:=TIniFile.Create(IniName);
{$endif}
  try
    { Falls die INI.Datei mehr Einträge enthält, als die aktuelle
      Liste, werden die überzähligen Einträge nicht überschrieben. }
    for i:=0 to Count-1 do
      IniFile.WriteString(IniSection, 'History'+IntToStr(i), Strings[i]);
  finally
    IniFile.Free;
  end;
end;

procedure THistoryList.LoadFromIni(IniName, IniSection : string);
var
  i : integer;
  s : string;
{$ifdef Win32}
  IniFile : TRegIniFile;
{$else}
  IniFile : TIniFile;
{$endif}
begin
{$ifdef Win32}
  IniFile:=TRegIniFile.Create(IniName);
{$else}
  IniFile:=TIniFile.Create(IniName);
{$endif}
  Clear;
  try
    { TIniFile.ReadSection sieht zwar aus, als könne sie
      die Strings auf einen Schlag lesen, liest aber nur die
      Variablennamen vor dem = }
    for i:=0 to FMaxLen-1 do begin
      s:=IniFile.ReadString(IniSection, 'History'+IntToStr(i), '');
      if s<>'' then
        Add(s);
    end;
  finally
    IniFile.Free;
  end;
end;

procedure THistoryList.SetMenuItem(MenuItem : TMenuItem);
begin
  if Assigned(FMenuItem) then
    RemoveMenuItems;
  FMenuItem:=MenuItem; { Property-zugehörige Variable setzen }
  MenuSizeBefore:=MenuItem.Count; { bisherige Menügröße speichern }
  AddMenuItems; { ab sofort bleibt das Menü aktuell }
end;

procedure THistoryList.RemoveMenuItems;
begin
  { alle Menüeinträge ab der gespeicherten Position
    MenuSizeBefore wieder entfernen: }
  if Assigned(FMenuItem) then
    while FMenuItem.Count>MenuSizeBefore do
      FMenuItem.Delete(FMenuItem.Count-1);
end;

procedure THistoryList.SetMaxLen(AnInt : integer);
begin
  if (AnInt>=1) and (AnInt<=100) then begin
    FMaxLen:=AnInt;
    while Count>FMaxLen do
      Delete(Count-1); { alle überzähligen Einträge löschen }
  end;
end;

procedure THistoryList.AddString(s : string);
var
  OldIndex : integer;
begin
  { String schon vorhanden? }
  OldIndex:=IndexOf(s);
  if OldIndex<>-1 then
    Delete(OldIndex); { dann das Duplikat löschen }
  Insert(0, s); { auf alle Fälle an erster Stelle einfügen }
  { Maximallänge überschritten? }
  if Count>FMaxLen then
    Delete(Count-1); { letzten Eintrag löschen }
  RemoveMenuItems; { Menü in Ursprungszustand versetzen... }
  AddMenuItems; { ...und alle Einträge neu anhängen. }
end;

procedure THistoryList.AddMenuItems;
{ Gegenstück zu RemoveMenuItems }
var
  i : integer;
begin
  if Assigned(FMenuItem) then begin
    FMenuItem.Add(NewLine); { mit einem Separator abtrennen }
    for i:=0 to Count-1 do
      FMenuItem.Add(NewItem(Format('&%d %s', [i+1, Strings[i]]), 0, False, True, DoAutoItemClick, 0, ''));
    { so sieht das Menü aus (erste Ziffer unterstrichen):
      ...
      ----------
      1 Eintrag1
      2 Eintrag2
    }
  end;
end;

procedure THistoryList.DoAutoItemClick(Sender : TObject);
var
  Text : String;
  Index : Integer;
begin
  if Assigned (FOnAutoItemClick) then begin
    Text:=(Sender as TMenuItem).Caption;
    { Text sieht so aus:
      &12 MenuText
      das "&" muß übersprungen werden, dann folgt bis
      zum Leerzeichen der Index, der angeklickt wurde }
    Index:=StrToInt(Copy(Text, 2, Pos(' ', Text)-2));
    { Index - 1 ergibt den Index in der internen
      Stringliste: }
    if Index>0 then
      FOnAutoItemClick(FMenuItem, Strings[index-1]);
  end;
end;

(********** THistoryCombo ***********)

constructor THistoryCombo.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FHistoryList:=THistoryList.Create;
end;

destructor THistoryCombo.Destroy;
begin
  { Automatische Speicherung, wenn die notwendigen
    Angaben gemacht sind: }
  if (FIniFileName<>'') and (FIniSection<>'') then begin
{$ifdef Win32}
    FHistoryList.SaveToIni(FRegistryPath, FIniSection);
{$else}
    FHistoryList.SaveToIni(FIniFileName, FIniSection);
{$endif}
  end;
  { da FHistoryList nicht in der Komponentenliste ist,
    muß sie manuell freigegeben werden: }
  FHistoryList.Free;
  inherited Destroy;
end;

procedure THistoryCombo.UpdateComboList;
begin
  Items:=FHistoryList;
end;

procedure THistoryCombo.UpdateList;
begin
  FHistoryList.AddString(Text);
  UpdateComboList;
end;

procedure THistoryCombo.DoExit;
{ Fokus-Wechsel -> Eintrag speichern. }
begin
  inherited DoExit;
  if not FManualUpdate then
    UpdateList;
end;

procedure THistoryCombo.SetIniData(index : integer; str: string);
begin
  case index of
    0: FRegistryPath:=str;
    1: FIniFileName:=str;
    2: FIniSection:=str;
  end;
  { Automatisches INI-Datei-Lesen, sobald alle notwendigen
    Angaben gemacht sind: }
{$ifdef Win32}
  if (FRegistryPath<>'') and (FIniSection<>'') then begin
    FHistoryList.LoadFromIni(FRegistryPath, FIniSection);
    UpdateComboList;
  end;
{$else}
  if (FIniFileName<>'') and (FIniSection<>'') then begin
    FHistoryList.LoadFromIni(FIniFileName, FIniSection);
    UpdateComboList;
  end;
{$endif}
end;

(************** Register ***************)

procedure Register;
begin
  RegisterComponents('Zum Buch', [THistoryCombo]);
end;

end.
