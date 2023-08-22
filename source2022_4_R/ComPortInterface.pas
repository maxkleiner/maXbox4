unit ComPortInterface;

//mX Version    adapted type

interface

uses Windows, Classes, SysUtils;

const

  { Konstanten f�r die Flags von TDCB }

  ftBinary = $0001;
  ftParity = $0002;
  ftOutxCtsFlow = $0004;
  ftOutxDsrFlow = $0008;
  ftDtrControlMask = $0030;
  ftDsrSensitivity = $0040;
  ftTXContinueOnXoff = $0080;
  ftOutX = $0100;
  ftInX = $0200;
  ftErrorChar = $0400;
  ftNull = $0800;
  ftRtsControlMask = $3000;
  ftAbortOnError = $4000;

type

  { �bertragungsparametertypen }

  TTParity = (parNone, parOdd, parEven, parMark, parSpace);
  TTStopBits = (sbOne, sbOnePointFive, sbTwo);

  { Vorw�rtsdeklarationen }

  TComPorts = class;
  TTComPort = class;

  { TComPortInterface-Klasse }

  TComPortInterface = class
  private
    FComPorts: TComPorts;
    FTimeOut: Cardinal;
    FBreak: Boolean;
    FRTS: Boolean;
    FDTR: Boolean;
    PortHandle: THandle;
    SelectedComPortIndex: Integer;
    ConnectedPortNr: Cardinal;
    function GetBaudRate: Cardinal;
    procedure SetBaudRate(Value: Cardinal);
    function GetDataBits: Byte;
    procedure SetDataBits(Value: Byte);
    function GetStopBits: TTStopBits;
    procedure SetStopBits(Value: TTStopBits);
    function GetParity: TTParity;
    procedure SetParity(Value: TTParity);
    procedure SetTimeOut(Value: Cardinal);
    function GetBreak: Boolean;
    procedure SetBreak(Value: Boolean);
    function GetRTS: Boolean;
    procedure SetRTS(Value: Boolean);
    function GetDTR: Boolean;
    procedure SetDTR(Value: Boolean);
    function GetCTS: Boolean;
    function GetDSR: Boolean;
    function GetDCD: Boolean;
    function GetRI: Boolean;
    procedure SelectComPort(Index: Integer);
    function OpenPort(PortName: string): THandle;
    function GetPortName(PortNr: Cardinal): string;
    function GetConnected: Boolean;
    procedure RaiseComPortAlreadyOpenException;
    procedure RaiseComPortNotOpenException;
    procedure RaiseNoComPortSelectedException;
    procedure RaiseCouldNotOpenComPortException;
    procedure RaiseInvalidParameterException;
    procedure RaiseReadErrorException;
    procedure RaiseWriteErrorException;
  //protected
  public
    function ReadData(var Buffer; BufferSize: Cardinal): Cardinal;
    function ReadByte(var Buffer: Byte): Boolean;
    procedure WriteData(const Buffer; BufferSize: Cardinal);
    procedure WriteByte(Buffer: Byte);
    procedure ClearInputBuffer;
    procedure ClearOutputBuffer;
    property BaudRate: Cardinal read GetBaudRate write SetBaudRate;
    property DataBits: Byte read GetDataBits write SetDataBits;
    property StopBits: TTStopBits read GetStopBits write SetStopBits;
    property Parity: TTParity read GetParity write SetParity;
    property TimeOut: Cardinal read FTimeOut write SetTimeOut;
    property Break: Boolean read GetBreak write SetBreak;
    property RTS: Boolean read GetRTS write SetRTS;
    property DTR: Boolean read GetDTR write SetDTR;
    property CTS: Boolean read GetCTS;
    property DSR: Boolean read GetDSR;
    property DCD: Boolean read GetDCD;
    property RI: Boolean read GetRI;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RescanPorts;
    procedure Connect; virtual;
    procedure Disconnect; virtual;
    property ComPorts: TComPorts read FComPorts;
    property Connected: Boolean read GetConnected;
  end;

  { TComPorts-Klasse }

  TComPorts = class (TCollection)
  private
   Owner: TComPortInterface;
   function GetItem(Index: Integer): TTComPort;
  public
    constructor Create(AComPortInterface: TComPortInterface);
    function Add: TTComPort;
    property Items[Index: Integer]: TTComPort read GetItem; default;
  end;

  { TComPort-Klasse }

  TTComPort = class (TCollectionItem)
  private
    FName: string;
    FNr: Cardinal;
    procedure SetSelected(ASelected: Boolean);
    function GetSelected: Boolean;
  public
    procedure Select;
    property Name: string read FName;
    property Nr: Cardinal read FNr;
    property Selected: Boolean read GetSelected write SetSelected;
  end;

  {  Exception-Klassen }

  EComPortInterface = class (Exception);
  EComPortAlreadyOpen = class (EComPortInterface);
  EComPortNotOpen = class (EComPortInterface);
  ENoComPortSelected = class (EComPortInterface);
  ECouldNotOpenComPort = class (EComPortInterface);
  ECouldCloseComPort = class (EComPortInterface);
  EInvalidParameter = class (EComPortInterface);
  EReadError = class (EComPortInterface);
  EWriteError = class (EComPortInterface);

implementation

{ TComPortInterface }

constructor TComPortInterface.Create;
begin
  { geerbten Constructor aufrufen }
  inherited;

  { Liste f�r Schnittstellen erzeugen }
  FComPorts := TComPorts.Create(Self);

  { PortHandle-Variable initialisieren }
  PortHandle := INVALID_HANDLE_VALUE;

  { nach Schnittstellen suchen }
  RescanPorts;
end;

destructor TComPortInterface.Destroy;
begin
  { falls noch verbunden, trennen }
  if GetConnected then
    Disconnect;

  { Liste mit Schnittstellen freigeben }
  FComPorts.Free;

  { geerbten Destruktor aufrufen }
  inherited;
end;

function TComPortInterface.GetBaudRate: Cardinal;
var
  DCB: TDCB;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { BaudRate lesen und zur�ckliefern }
  Win32Check(GetCommState(PortHandle, DCB));
  Result := DCB.BaudRate;
end;

procedure TComPortInterface.SetBaudRate(Value: Cardinal);
var
  DCB: TDCB;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { aktuelle Einstellungen der Schnittstelle ermitteln, Baudrate �ndern und Einstellungen neu setzen }
  Win32Check(GetCommState(PortHandle, DCB));
  DCB.BaudRate := Value;
 if not SetCommState(PortHandle, DCB) then
    RaiseInvalidParameterException;
end;

function TComPortInterface.GetDataBits: Byte;
var
  DCB: TDCB;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { Anzahl der Daten-Bits lesen und zur�ckliefern }
  Win32Check(GetCommState(PortHandle, DCB));
  Result := DCB.ByteSize;
end;

procedure TComPortInterface.SetDataBits(Value: Byte);
var
  DCB: TDCB;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { aktuelle Einstellungen der Schnittstelle ermitteln, Anzahl der Daten-Bits �ndern und Einstellungen neu setzen }
  Win32Check(GetCommState(PortHandle, DCB));
  DCB.ByteSize := Value;
  if not SetCommState(PortHandle, DCB) then
    RaiseInvalidParameterException;
end;

function TComPortInterface.GetStopBits: TTStopBits;
var
  DCB: TDCB;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { Anzahl der Stop-Bits lesen und auswerten }
  Win32Check(GetCommState(PortHandle, DCB));
  case DCB.StopBits of
   ONE5STOPBITS: Result := sbOnePointFive;
   TWOSTOPBITS: Result := sbTwo;
  else
    Result := sbOne;
  end;
end;

procedure TComPortInterface.SetStopBits(Value: TTStopBits);
var
  DCB: TDCB;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { aktuelle Einstellungen der Schnittstelle ermitteln, Anzahl der Stop-Bits �ndern und Einstellungen neu setzen }
  Win32Check(GetCommState(PortHandle, DCB));
  case Value of
    sbOne: DCB.StopBits := ONESTOPBIT;
    sbOnePointFive: DCB.StopBits := ONE5STOPBITS;
    sbTwo: DCB.StopBits := TWOSTOPBITS;
  end;
  if not SetCommState(PortHandle, DCB) then
    RaiseInvalidParameterException;
end;

function TComPortInterface.GetParity: TTParity;
var
  DCB: TDCB;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { Parit�t lesen und auswerten }
  Win32Check(GetCommState(PortHandle, DCB));
  case DCB.Parity of
    ODDPARITY: Result := parOdd;
    EVENPARITY: Result := parEven;
    MARKPARITY: Result := parMark;
    SPACEPARITY: Result := parSpace;
  else
    Result := parNone;
  end;
end;

procedure TComPortInterface.SetParity(Value: TTParity);
var
  DCB: TDCB;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { aktuelle Einstellungen der Schnittstelle ermitteln, Parit�t �ndern und Einstellungen neu setzen }
  Win32Check(GetCommState(PortHandle, DCB));
  case Value of
    parNone: DCB.Parity := NOPARITY;
    parOdd: DCB.Parity := ODDPARITY;
    parEven: DCB.Parity := EVENPARITY;
    parMark: DCB.Parity := MARKPARITY;
    parSpace: DCB.Parity := SPACEPARITY;
  end;
  if not SetCommState(PortHandle, DCB) then
    RaiseInvalidParameterException;
end;

procedure TComPortInterface.SetTimeOut;
var
  TimeOuts: TCommTimeOuts;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { auf eine einfache Zeit�berschreitung beim Lesen pr�fen nach angegebener Zeit in Millisekunden }
  with TimeOuts do
  begin
    ReadIntervalTimeout := 0;
    ReadTotalTimeoutMultiplier := 0;
    ReadTotalTimeoutConstant := Value;
    WriteTotalTimeoutMultiplier := 0;
    WriteTotalTimeoutConstant := 0;
  end;
  if not SetCommTimeOuts(PortHandle, TimeOuts) then
    RaiseInvalidParameterException;

  { neuen Wert f�r die Zeit�berschreitung speichern }
  FTimeOut := Value;
end;

function TComPortInterface.GetBreak: Boolean;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { aktuellen Zustand zur�ckliefern }
  Result := FBreak;
end;

procedure TComPortInterface.SetBreak(Value: Boolean);
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { �berpr�fen, ob sich der Break-Zustand �ndert }
  if Value <> FBreak then
  begin
    { gew�nschten Zustand ausl�sen }
    if Value then
      Win32Check(EscapeCommFunction(PortHandle, Windows.SETBREAK))
    else
      Win32Check(EscapeCommFunction(PortHandle, CLRBREAK));

    { neuen Zustand speichern }
    FBreak := Value;
  end;
end;

function TComPortInterface.GetRTS: Boolean;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { aktuellen Zustand zur�ckliefern }
  Result := FRTS;
end;

procedure TComPortInterface.SetRTS(Value: Boolean);
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { �berpr�fen, ob sich der Zustand von RTS �ndert }
  if Value <> FRTS then
  begin
    { Leitung in gew�nschten Zustand versetzen }
    if Value then
      Win32Check(EscapeCommFunction(PortHandle, Windows.SETRTS))
    else
      Win32Check(EscapeCommFunction(PortHandle, CLRRTS));

    { neuen Zustand speichern }
    FRTS := Value;
  end;
end;

function TComPortInterface.GetDTR: Boolean;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { aktuellen Zustand zur�ckliefern }
  Result := FDTR;
end;

procedure TComPortInterface.SetDTR(Value: Boolean);
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { �berpr�fen, ob sich der Zustand von DTR �ndert }
  if Value <> FDTR then
  begin
    { Leitung in gew�nschten Zustand versetzen }
    if Value then
      Win32Check(EscapeCommFunction(PortHandle, Windows.SETDTR))
    else
      Win32Check(EscapeCommFunction(PortHandle, CLRDTR));

    { neuen Zustand speichern }
    FDTR := Value;
  end;
end;

function TComPortInterface.GetCTS: Boolean;
var
  State: Cardinal;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { Zustand der Leitung lesen und auswerten }
  Win32Check(GetCommModemStatus(PortHandle, State));
  Result := (State and MS_CTS_ON) = MS_CTS_ON;
end;

function TComPortInterface.GetDSR: Boolean;
var
  State: Cardinal;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { Zustand der Leitung lesen und auswerten }
  Win32Check(GetCommModemStatus(PortHandle, State));
  Result := (State and MS_DSR_ON) = MS_DSR_ON;
end;

function TComPortInterface.GetDCD: Boolean;
var
  State: Cardinal;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { Zustand der Leitung lesen und auswerten }
  Win32Check(GetCommModemStatus(PortHandle, State));
  Result := (State and MS_RLSD_ON) = MS_RLSD_ON;
end;

function TComPortInterface.GetRI: Boolean;
var
  State: Cardinal;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { Zustand der Leitung lesen und auswerten }
  Win32Check(GetCommModemStatus(PortHandle, State));
  Result := (State and MS_RING_ON) = MS_RING_ON;
end;

procedure TComPortInterface.SelectComPort(Index : Integer);
begin
  { �berpr�fen, ob eine andere Schnittstelle ausgew�hlt werden soll }
  if Index <> SelectedComPortIndex then
  begin
    { falls die Schnittstelle ge�ffnet ist, Schnittstelle vor�bergehend }
    { schlie�en, ansonsten neue Schnittstelle direkt als angew�hlt �bernehmen }
    if GetConnected then
    begin
      Disconnect;
      SelectedComPortIndex := Index;
      Connect;
    end
    else
      SelectedComPortIndex := Index;
  end;
end;

function TComPortInterface.OpenPort(PortName: string): THandle;
begin
  { Schnittstelle �ffnen und Handle zur�ckliefern }
  Result := CreateFile(PChar(PortName), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_FLAG_WRITE_THROUGH, 0);
end;

function TComPortInterface.GetPortName(PortNr: Cardinal): string;
begin
  { Schnittstellennamen aus "COM" und der Nummer zusammensetzen }
  Result := 'COM' + IntToStr(PortNr);
end;

function TComPortInterface.GetConnected;
begin
  { zur�ckliefern, ob die Schnittstelle offen ist }
  Result := PortHandle <> INVALID_HANDLE_VALUE;
end;

procedure TComPortInterface.RaiseComPortAlreadyOpenException;
begin
  { Exception ausl�sen }
  raise EComPortAlreadyOpen.Create('Schnittstelle ist bereits offen.');
end;

procedure TComPortInterface.RaiseComPortNotOpenException;
begin
  { Exception ausl�sen }
  raise EComPortNotOpen.Create('Schnittstelle ist nicht offen.');
end;

procedure TComPortInterface.RaiseNoComPortSelectedException;
begin
  { Exception ausl�sen }
  raise ENoComPortSelected.Create('Es ist keine Schnittstelle ausgew�hlt.');
end;

procedure TComPortInterface.RaiseCouldNotOpenComPortException;
begin
  { Exception ausl�sen }
  raise ECouldNotOpenComPort.Create('Schnittstelle konnte nicht ge�ffnet werden.');
end;

procedure TComPortInterface.RaiseInvalidParameterException;
begin
  { Exception ausl�sen }
  raise EInvalidParameter.Create('Parameter ist ung�ltig.');
end;

procedure TComPortInterface.RaiseReadErrorException;
begin
  { Exception ausl�sen }
  raise EReadError.Create('Ein Lesezugriff der Schnittstelle ist fehlgeschlagen.');
end;

procedure TComPortInterface.RaiseWriteErrorException;
begin
  { Exception ausl�sen }
  raise EWriteError.Create('Ein Schreibzugriff auf die Schnittstelle ist fehlgeschlagen.');
end;

function TComPortInterface.ReadData(var Buffer; BufferSize: Cardinal): Cardinal;
var
  Okay: Boolean;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { Daten von der Schnittstelle lesen }
  Okay := ReadFile(PortHandle, Buffer, BufferSize, Result, nil);
  if not Okay then
    RaiseReadErrorException;
end;

function TComPortInterface.ReadByte(var Buffer: Byte): Boolean;
begin
  { Byte von der Schnittstelle lesen }
  Result := ReadData(Buffer, 1) = 1;
end;

procedure TComPortInterface.WriteData(const Buffer; BufferSize: Cardinal);
var
  BytesWritten: Cardinal;
  Okay: Boolean;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { Daten �ber die Schnittstelle ausgeben }
  Okay := WriteFile(PortHandle, Buffer, BufferSize, BytesWritten, nil);
  if not Okay or (BytesWritten <> BufferSize) then
    RaiseWriteErrorException;
end;

procedure TComPortInterface.WriteByte(Buffer: Byte);
begin
 { Byte �ber die Schnittstelle ausgeben }
 WriteData(Buffer, 1);
end;

procedure TComPortInterface.ClearInputBuffer;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { Empfangspuffer l�schen }
  PurgeComm(PortHandle, PURGE_RXCLEAR);
end;

procedure TComPortInterface.ClearOutputBuffer;
begin
  { Exception ausl�sen, wenn Schnittstelle nicht offen }
  if not GetConnected then
    RaiseComPortNotOpenException;

  { Sendepuffer l�schen }
  PurgeComm(PortHandle, PURGE_TXCLEAR);
end;

procedure TComPortInterface.RescanPorts;
var
  PortHandle: THandle;
  PortName: string;
  Counter: Cardinal;
  AddPort: Boolean;
begin
  { evtl. vorhandene Schnittstellenobjekte freigeben }
  FComPorts.Clear;

  { zun�chst keine Schnittstelle als angew�hlt kennzeichnen }
  SelectedComPortIndex := -1;

  { Schnittstellen COM1 bis COM255 untersuchen }
  for Counter := 1 to 255 do
  begin
    { Schnittstellenname erzeugen }
    PortName := GetPortName(Counter);

    { falls die aktuell untersuchte Schnittstelle die ge�ffnete ist }
    { Flag in AddPort setzen }
    AddPort := GetConnected and (Counter = ConnectedPortNr);

    { Flag pr�fen }
    if AddPort then
      { neuen Index f�r die ausgew�hlte Schnittstelle �bernehmen  }
      SelectedComPortIndex := FComPorts.Count
    else
    begin
      { versuchen Schnittstelle zu �ffnen }
      PortHandle := OpenPort(PortName);

      { Flag in AddPort setzen, falls Schnittstelle ge�ffnet werden konnte }
      AddPort := PortHandle <> INVALID_HANDLE_VALUE;

      { Schnittstelle schlie�en, wenn n�tig }
      if AddPort then
        CloseHandle(PortHandle);
    end;

    { bei gesetztem Flag in AddPort, neues Schnittstellenobjekt }
    { erzeugen und Informationen eintragen }
    if AddPort then
      with FComPorts.Add do
      begin
        FName := PortName;
        FNr := Counter;
      end;
  end;

  { falls noch keine Schnittstelle ausgew�hlt ist und freie Schnittstellen }
  { gefunden wurden, die erste Schnittstelle ausw�hlen }
  if (SelectedComPortIndex = -1) and (FComPorts.Count > 0) then
    SelectedComPortIndex := 0;
end;

procedure TComPortInterface.Connect;
var
  DCB: TDCB;
begin
  { Exception ausl�sen, wenn Schnittstelle bereits offen }
  if GetConnected then
    RaiseComPortAlreadyOpenException;

  { Exception ausl�sen, wenn keine Schnittstelle ausgew�hlt ist }
  if SelectedComPortIndex = -1 then
    RaiseNoComPortSelectedException;

  { Schnittstelle �ffnen }
  PortHandle := OpenPort(FComPorts[SelectedComPortIndex].FName);

  { Exception ausl�sen, falls das �ffnen fehlgeschlagen ist }
  if PortHandle = INVALID_HANDLE_VALUE then
    RaiseCouldNotOpenComPortException;

  { aktuelle Einstellungen der Schnittstelle ermitteln, Flags �ndern und Einstellungen neu setzen }
  Win32Check(GetCommState(PortHandle, DCB));
  DCB.Flags := ftBinary or ftParity;
  if not SetCommState(PortHandle, DCB) then
    RaiseInvalidParameterException;

  { Zeit�berschreitung auf 500ms setzen }
  SetTimeOut(500);

  { Nummer der Schnittstelle �bernehmen }
  ConnectedPortNr := FComPorts[SelectedComPortIndex].Nr;

  { Variablen initialisieren }
  FBreak := False;
  FRTS := False;
  FDTR := False;
end;

procedure TComPortInterface.Disconnect;
begin
 { Exception ausl�sen, wenn Schnittstelle nicht offen }
 if not GetConnected then
   RaiseComPortNotOpenException;

 { Schnittstelle schlie�en und neuen Zustand durch PortHandle signalisieren }
 Win32Check(CloseHandle(PortHandle));
 PortHandle := INVALID_HANDLE_VALUE;
end;

{ TComPorts }                      

constructor TComPorts.Create;
begin
  { geerbten Constructor aufrufen }
  inherited Create(TTComPort);

  { Eigent�mer sichern }
  Owner := AComPortInterface;
end;

function TComPorts.GetItem(Index: Integer): TTComPort;
begin
  { geerbte Methode aufrufen und Typumwandlung durchf�hren }
  Result := TTComPort(inherited GetItem(Index));
end;

function TComPorts.Add: TTComPort;
begin
  { geerbte Methode aufrufen und Typumwandlung durchf�hren }
  Result := TTComPort(inherited Add);
end;

{ TComPort }

procedure TTComPort.SetSelected;
begin
  { sich selbst im zugeh�rigen TComPortInterface-Objekt ausw�hlen oder Auswahl aufheben }
  if ASelected then
   TComPorts(Collection).Owner.SelectComPort(Index)
  else
    if GetSelected then
      TComPorts(Collection).Owner.SelectComPort(-1);
end;

function TTComPort.GetSelected;
begin
  { zur�ckliefern, ob der eigene Index der der ausgew�hlten Schnittstelle im zugeh�rigen TComPortInterface-Objekt entspricht }
  Result := TComPorts(Collection).Owner.SelectedComPortIndex = Index;
end;

procedure TTComPort.Select;
begin
  { Auswahl �ber die SetSelected-Methode durchf�hren }
  SetSelected(True);
end;

end.

