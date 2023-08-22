unit FIFO;

interface

uses SysUtils, Classes;

type

  { TFIFO-Klasse }

  TFIFO = class
  private
    FData: TMemoryStream;
    FSize: Cardinal;
    procedure RaiseNotEnoughData;
  public
    destructor Destroy; override;
    procedure WriteData(var Data: TMemoryStream; Size: Cardinal);
    procedure ReadData(var Data: TMemoryStream; Size: Cardinal);
    procedure RemoveData(Size: Cardinal);
    procedure Clear;
    property Data: TMemoryStream read FData;
    property Size: Cardinal read FSize;
  end;

  { Exception-Klassen }

  EFIFO = class (Exception);
  ENotEnoughData = class (EFIFO);

implementation

{ TFIFO }

destructor TFIFO.Destroy;
begin
  { Speicher freigeben, wenn n�tig }
  ReallocMem(pointer(FData), 0);

  { geerbten Destruktor aufrufen }
  inherited Destroy;
end;

procedure TFIFO.RaiseNotEnoughData;
begin
  { Exception ausl�sen }
  raise ENotEnoughData.Create('Es befinden sich nicht gen�gend Daten im FIFO.');
end;

procedure TFIFO.WriteData(var Data: TMemoryStream; Size: Cardinal);
var
  NewSize: Cardinal;
begin
  { �berpr�fen, ob �berhaupt Daten in den FIFO geschrieben werden sollen }
  if Size > 0 then
  begin
    { neue Gr��e des FIFO-Speichers berechnen }
    NewSize := FSize + Size;

    { Gr��e der FIFO-Speichers anpassen }
    ReallocMem(pointer(FData), NewSize);

    { neue Daten in den erweiterten FIFO-Speicher schreiben und neue Gr��e �bernehmen }
    Move(Data, PByteArray(FData)^[FSize], Size);
    FSize := NewSize;
  end;
end;

procedure TFIFO.ReadData(var Data: TMemoryStream; Size: Cardinal);
begin
  { Exception ausl�sen falls mehr Daten ausgelesen werden sollen, als vorhanden sind }
  if Size > FSize then
    RaiseNotEnoughData;

  { auszulesende Daten kopieren }
  Move(pointer(FData), Data, Size);

  { ausgelesene Daten aus dem FIFO-Speicher entfernen }
  RemoveData(Size);
end;

procedure TFIFO.RemoveData(Size: Cardinal);
var
  NewSize: Cardinal;
begin
  { Exception ausl�sen falls mehr Daten entfernt werden sollen, als vorhanden sind }
  if Size > FSize then
    RaiseNotEnoughData;

  { �berpr�fen, ob �berhaupt Daten entfernt werden sollen }
  if Size > 0 then
  begin
    { neue Gr��e des FIFO-Speichers berechnen }
    NewSize := FSize - Size;

    { verbleibende Daten an den Anfang des FIFO-Speichers verschieben }
    Move(PByteArray(FData)^[Size], FData, NewSize);

    { Gr��e der FIFO-Speichers anpassen und neue Gr��e �bernehmen }
    ReallocMem(pointer(FData), NewSize);
    FSize := NewSize;
  end;
end;

procedure TFIFO.Clear;
begin
  { Speicher freigeben }
  ReallocMem(pointer(FData), 0);

  { Gr��e der FIFO-Speichers auf Null setzen }
  FSize := 0;
end;

end.

