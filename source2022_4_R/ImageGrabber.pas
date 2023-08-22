unit ImageGrabber;

// adopted to maXbox by mX

interface

uses
  Windows, Classes, Graphics, SysUtils, VFW;

type

  { Typen für TImageGrabber }

  TCaptureDriverDialog = (cddDisplay, cddFormat, cddSource);
  TCaptureDriverDialogs = set of TCaptureDriverDialog;

  { Vorwärtsdeklarationen }

  TCaptureDrivers = class;
  TCaptureDriver = class;

  { TImageGrabber-Klasse }

  TImageGrabber = class
  private
    FCaptureDrivers: TCaptureDrivers;
    FSupportedDialogs: TCaptureDriverDialogs;
    FVideoFormat: string;
    FWidth: Cardinal;
    FHeight: Cardinal;
    FVideoFormatSupported: Boolean;
    FConnected: Boolean;
    CaptureWindow: HWND;
    Decompressor: HIC;
    SelectedCaptureDriverIndex: Integer;
    VideoBitmapInfo: PBitmapInfo;
    GrabBitmapInfo: PBitmapInfo;
    GrabBitmapBits: Pointer;
    function GetSupportedDialogs: TCaptureDriverDialogs;
    function GetVideoFormat: string;
    function GetVideoFormatSupported: Boolean;
    function GetWidth: Cardinal;
    function GetHeight: Cardinal;
    procedure VideoFormatChanged;
    procedure SelectCaptureDriver(Index: Integer);
    function FrameCallback(ACaptureWindow: HWND; AHeader: PVIDEOHDR): DWORD;
    procedure RaiseCouldNotCreateCaptureWindowException;
    procedure RaiseAlreadyConnectedException;
    procedure RaiseCaptureDriverNotConnectedException;
    procedure RaiseNoCaptureDriverSelectedException;
    procedure RaiseCouldNotConnectToCaptureDriverException;
    procedure RaiseCouldNotDisconnectFromCaptureDriverException;
    procedure RaiseNoCodecForVideoFormatException;
    procedure RaiseUnableToCreateBitmapException;
    procedure RaiseCodecErrorException;
    procedure RaiseGrabErrorException;
    procedure RaiseCouldNotOpenDialogException;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    procedure OpenDialog(Dialog: TCaptureDriverDialog);
    function Grab: TBitmap;
    property CaptureDrivers: TCaptureDrivers read FCaptureDrivers;
    property SupportedDialogs: TCaptureDriverDialogs read GetSupportedDialogs;
    property VideoFormat: string read GetVideoFormat;
    property VideoFormatSupported: Boolean read GetVideoFormatSupported;
    property Width: Cardinal read GetWidth;
    property Height: Cardinal read GetHeight;
    property Connected: Boolean read FConnected;
  end;

  { TCaptureDrivers-Klasse }

  TCaptureDrivers = class (TCollection)
  private
    Owner: TImageGrabber;
    function GetItem(Index: Integer): TCaptureDriver;
  public
    constructor Create(ImageGrabber: TImageGrabber);
    function Add: TCaptureDriver;
    property Items[Index: Integer]: TCaptureDriver read GetItem; default;
  end;

  { TCaptureDriver-Klasse }

  TCaptureDriver = class (TCollectionItem)
  private
    FName: string;
    FVersion: string;
    procedure SetSelected(ASelected: Boolean);
    function GetSelected: Boolean;
  public
    procedure Select;
    property Name: string read FName;
    property Version: string read FVersion;
    property Selected: Boolean read GetSelected write SetSelected;
  end;

  { Exception-Klassen }

  EImageGrabber = class (Exception);
  ECouldNotCreateCaptureWindow = class (EImageGrabber);
  EAlreadyConnected = class (EImageGrabber);
  ECaptureDriverNotConnected = class (EImageGrabber);
  ENoCaptureDriverSelected = class (EImageGrabber);
  ECouldNotConnectToCaptureDriver = class (EImageGrabber);
  ECouldNotDisconnectFromCaptureDriver = class (EImageGrabber);
  ENoCodecForVideoFormat = class (EImageGrabber);
  EUnableToCreateBitmap = class (EImageGrabber);
  ECodecError = class (EImageGrabber);
  EGrabError = class (EImageGrabber);
  ECouldNotOpenDialog = class (EImageGrabber);

implementation

{ Callback-Funktion }

function FrameCallback(CaptureWindow: HWND; Header: PVIDEOHDR): DWORD; stdcall;
var
  ImageGrabber: TImageGrabber;
begin
  { zugehöriges ImageGrabber-Objekt aus den Benutzerdaten ermitteln }
  ImageGrabber := TImageGrabber(capGetUserData(CaptureWindow));

  { prüfen, ob gültiges Objekt gefunden wurde }
  if Assigned(ImageGrabber) then
    { Callback-Methode des ImageGrabber-Objekt aufrufen }
    Result := ImageGrabber.FrameCallback(CaptureWindow, Header)
  else
    { erfolgreiche Ausführung anzeigen }
    Result := 1;
end;

{ TImageGrabber }

constructor TImageGrabber.Create;
const
  CaptureDriverNameBufferSize = 255;
  CaptureDriverVersionBufferSize = 255;
var
  NameBuffer: array[0..CaptureDriverNameBufferSize - 1] of Char;
  VersionBuffer: array[0..CaptureDriverVersionBufferSize - 1] of Char;
  Counter: Cardinal;
begin
  { Aufnahmefenster erzeugen }
  CaptureWindow := capCreateCaptureWindowA('ImageGrabberCaptureWindow', 0, 0, 0, 0, 0, 0, 0);
  if CaptureWindow = 0 then
    RaiseCouldNotCreateCaptureWindowException;

  { Zeiger auf sich selbst in den Benutzerdaten des Fensters speichern }
  capSetUserData(CaptureWindow, Cardinal(Self));

  { Call-Back-Function zuweisen }
  capSetCallbackOnFrame(CaptureWindow, ImageGrabber.FrameCallback);

  { Liste mit installierten Aufnahmetreibern erzeugen }
  FCaptureDrivers := TCaptureDrivers.Create(Self);
  for Counter := 0 to 9 do
    { Name und Version des Aufnahmetreibers ermitteln }
    if capGetDriverDescription(Counter, @NameBuffer, CaptureDriverNameBufferSize, @VersionBuffer, CaptureDriverVersionBufferSize) then
      { falls Aufnahmetreiber gefunden, entsprechendes Objekt erstellen, der Liste hinzufügen und Informationen eintragen }
      with FCaptureDrivers.Add do
      begin
        FName := NameBuffer;
        FVersion := VersionBuffer;
      end;

  { falls kein Aufnahmetreiber gefunden wurde, SelectedCaptureDriverIndex auf -1 setzen }
  { ansonsten ersten Aufnahmetreiber anwählen }
  if FCaptureDrivers.Count=0 then
    SelectedCaptureDriverIndex:=-1;

  { um GrabBitmapInfo und VideoBitmapInfo konsistent zu halten, GrabBitmapInfo dynamisch erzeugen und vorbereiten }
  New(GrabBitmapInfo);
  FillChar(GrabBitmapInfo^, SizeOf(GrabBitmapInfo^), 0);
  with GrabBitmapInfo.bmiHeader do
  begin
    biSize := SizeOf(GrabBitmapInfo.bmiHeader);
    biPlanes := 1;
    biBitCount := 24;
  end;
end;

destructor TImageGrabber.Destroy;
begin
  { falls noch verbunden, trennen }
  if FConnected then
    Disconnect;

  { Aufnahmefenster freigeben, wenn nötig }
  if CaptureWindow <> 0 then
    DestroyWindow(CaptureWindow);

  { dynamische Variable GrabBitmapInfo freigeben, falls nötig }
  if Assigned(GrabBitmapInfo) then
    Dispose(GrabBitmapInfo);

  { Liste der Aufnahmetreiber freigeben }
  FCaptureDrivers.Free;

  { geerbten Destruktor aufrufen }
  inherited Destroy;
end;

function TImageGrabber.GetSupportedDialogs: TCaptureDriverDialogs;
begin
  { Exception auslösen, wenn keine Verbindung zum Aufnahmetreiber besteht }
  if not FConnected then
    RaiseCaptureDriverNotConnectedException;

  { unterstützte Dialogfenster zurückliefern }
  Result := FSupportedDialogs;
end;

function TImageGrabber.GetVideoFormat: string;
begin
  { Exception auslösen, wenn keine Verbindung zum Aufnahmetreiber besteht }
  if not FConnected then
    RaiseCaptureDriverNotConnectedException;

  { Bezeichner für das Videoformat zurückliefern }
  Result := FVideoFormat;
end;

function TImageGrabber.GetVideoFormatSupported: Boolean;
begin
  { Exception auslösen, wenn keine Verbindung zum Aufnahmetreiber besteht }
  if not FConnected then
    RaiseCaptureDriverNotConnectedException;

  { zurückliefern, ob für das aktuelle Videoformat ein Codec installiert ist }
  Result := FVideoFormatSupported;
end;

function TImageGrabber.GetWidth: Cardinal;
begin
  { Exception auslösen, wenn keine Verbindung zum Aufnahmetreiber besteht }
  if not FConnected then
    RaiseCaptureDriverNotConnectedException;

  { Breite des Bildes zurückliefern }
  Result := FWidth;
end;

function TImageGrabber.GetHeight: Cardinal;
begin
  { Exception auslösen, wenn keine Verbindung zum Aufnahmetreiber besteht }
  if not FConnected then
    RaiseCaptureDriverNotConnectedException;

  { Höhe des Bildes zurückliefern }
  Result := FHeight;
end;

procedure TImageGrabber.VideoFormatChanged;
type
  TCompressionDigits = array[0..3] of Byte;
var
  Size: DWORD;
  Counter: Integer;
  Digit: Byte;
begin
  { altes VideoBitmapInfo freigeben, wenn nötig }
  if Assigned(VideoBitmapInfo) then
  begin
    FreeMem(VideoBitmapInfo);
    VideoBitmapInfo := nil;
  end;

  { neues VideoBitmapInfo ermitteln }
  Size := capGetVideoFormat(CaptureWindow,nil,0);
  if Size > 0 then
  begin
    GetMem(VideoBitmapInfo, Size);
    capGetVideoFormat(CaptureWindow, VideoBitmapInfo, Size);
  end;

  { Bildgröße aus VideoBitmapInfo lesen }
  FWidth := VideoBitmapInfo.bmiHeader.biWidth;
  FHeight := VideoBitmapInfo.bmiHeader.biHeight;

  { Bezeichner für das Videoformat ermitteln }
  FVideoFormat:='unbekannt';
  case VideoBitmapInfo.bmiHeader.biCompression of
    BI_RGB, BI_BITFIELDS: FVideoFormat := 'RGB' + IntToStr(VideoBitmapInfo.bmiHeader.biBitCount);
    BI_RLE8: FVideoFormat := 'RLE8';
    BI_RLE4: FVideoFormat := 'RLE4';
  else
    FVideoFormat := '';
    for Counter := 0 to 3 do
    begin
      Digit := TCompressionDigits(VideoBitmapInfo.bmiHeader.biCompression)[Counter];
      if Digit <> 0 then
       FVideoFormat := FVideoFormat + Chr(Digit);
    end;
  end;

  { Bildgröße in GrabBitmapInfo eintragen }
  GrabBitmapInfo.bmiHeader.biWidth := FWidth;
  GrabBitmapInfo.bmiHeader.biHeight := FHeight;

  { Codec für das neue Videoformat suchen und FVideoFormatSupported entsprechend setzen }
  Decompressor := ICLocate(ICTYPE_VIDEO, 0, @VideoBitmapInfo.bmiHeader, @GrabBitmapInfo.bmiHeader, ICMODE_DECOMPRESS);
  FVideoFormatSupported := Decompressor<>0;
end;

procedure TImageGrabber.SelectCaptureDriver(Index: Integer);
begin
  { überprüfen, ob ein anderer Aufnahmetreiber ausgewählt werden soll }
  if Index <> SelectedCaptureDriverIndex then
  begin
    { falls Verbindung zum Aufnahmetreiber besteht, vorübergehend trennen }
    { ansonsten neuen Aufnahmetreiber direkt als angewählt übernehmen }
    if FConnected then
    begin
      Disconnect;
      SelectedCaptureDriverIndex := Index;
      Connect;
    end
    else
      SelectedCaptureDriverIndex := Index;
  end;
end;

function TImageGrabber.FrameCallback(ACaptureWindow: HWND; AHeader: PVIDEOHDR): DWORD;
begin
  { Bilddaten des aufgenommenen Frames mit Hilfe des Decoders umwandeln und in der Aufnahme-Bitmap ablegen }
  if ICDecompress(Decompressor, 0, @VideoBitmapInfo.bmiHeader, AHeader.lpData, @GrabBitmapInfo.bmiHeader,GrabBitmapBits) <> ICERR_OK then
    RaiseCodecErrorException;

  { erfolgreiche Ausführung anzeigen }
  Result := 1;
end;

procedure TImageGrabber.RaiseCouldNotCreateCaptureWindowException;
begin
  { Exception auslösen }
  raise ECouldNotCreateCaptureWindow.Create('Aufnahmefenster konnte nicht erzeugt werden.');
end;

procedure TImageGrabber.RaiseAlreadyConnectedException;
begin
  { Exception auslösen }
  raise EAlreadyConnected.Create('Es besteht bereits eine Verbindung zum Aufnahmetreiber.');
end;

procedure TImageGrabber.RaiseCaptureDriverNotConnectedException;
begin
  { Exception auslösen }
  raise ECaptureDriverNotConnected.Create('Es besteht keine Verbindung zum Aufnahmetreiber.');
end;

procedure TImageGrabber.RaiseNoCaptureDriverSelectedException;
begin
  { Exception auslösen }
  raise ENoCaptureDriverSelected.Create('Es ist kein Aufnahmetreiber ausgewählt.');
end;

procedure TImageGrabber.RaiseCouldNotConnectToCaptureDriverException;
begin
  { Exception auslösen }
  raise ECouldNotConnectToCaptureDriver.Create('Es konnte keine Verbindung zum Aufnahmetreiber hergestellt werden.');
end;

procedure TImageGrabber.RaiseCouldNotDisconnectFromCaptureDriverException;
begin
  { Exception auslösen }
  raise ECouldNotDisconnectFromCaptureDriver.Create('Die Verbindung zum Aufnahmetreiber konnte nicht getrennt werden.');
end;

procedure TImageGrabber.RaiseNoCodecForVideoFormatException;
begin
  { Exception auslösen }
  raise ENoCodecForVideoFormat.Create('Für das eingestellte Videoformat ist kein Decoder installiert.');
end;

procedure TImageGrabber.RaiseUnableToCreateBitmapException;
begin
  { Exception auslösen }
  raise EUnableToCreateBitmap.Create('Aufnahme-Bitmap konnte nicht erzeugt werden.');
end;

procedure TImageGrabber.RaiseCodecErrorException;
begin
  { Exception auslösen }
  raise ECodecError.Create('Der Decoder hat einen Fehler verursacht.');
end;

procedure TImageGrabber.RaiseGrabErrorException;
begin
  { Exception auslösen }
  raise EGrabError.Create('Bei Aufnahme des Bildes ist ein Fehler aufgetreten.');
end;

procedure TImageGrabber.RaiseCouldNotOpenDialogException;
begin
  { Exception auslösen }
  raise ECouldNotOpenDialog.Create('Dialogfenster des Aufnahmetreibers konnte nicht geöffnet werden.');
end;

procedure TImageGrabber.Connect;
var
  Capabilities: TCAPDRIVERCAPS;
begin
  { Exception auslösen, wenn bereits eine Verbindung zum Aufnahmetreiber besteht }
  if FConnected then
    RaiseAlreadyConnectedException;

  { Exception auslösen, wenn kein Aufnahmetreiber ausgewählt ist }
  if SelectedCaptureDriverIndex = -1 then
    RaiseNoCaptureDriverSelectedException;

  { zum Aufnahmetreiber verbinden, wenn möglich }
  FConnected := capDriverConnect(CaptureWindow, 0);

  { Exception auslösen, falls Verbindungsaufnahme fehlgeschlagen ist }
  if not FConnected then
    RaiseCouldNotConnectToCaptureDriverException;

  { unterstützte Dialogfenster ermitteln }
  capDriverGetCaps(CaptureWindow, @Capabilities, SizeOf(Capabilities));
  FSupportedDialogs := [];
  if Capabilities.fHasDlgVideoDisplay then
    Include(FSupportedDialogs, cddDisplay);
  if Capabilities.fHasDlgVideoFormat then
    Include(FSupportedDialogs, cddFormat);
  if Capabilities.fHasDlgVideoSource then
    Include(FSupportedDialogs, cddSource);

  { Information über das Videoformat des Aufnahmetreibers ermitteln }
  VideoFormatChanged;
end;

procedure TImageGrabber.Disconnect;
begin
  { Exception auslösen, wenn keine Verbindung zum Aufnahmetreiber besteht }
  if not FConnected then
    RaiseCaptureDriverNotConnectedException;

  { Verbindung zum Aufnahmetreiber trennen }
  if not capDriverDisconnect(CaptureWindow) then
    RaiseCouldNotDisconnectFromCaptureDriverException;

  { VideoBitmapInfo freigeben, wenn nötig }
  if Assigned(VideoBitmapInfo) then
  begin
    FreeMem(VideoBitmapInfo);
    VideoBitmapInfo := nil;
  end;

  { anzeigen, dass keine Verbindung mehr besteht }
  FConnected := False;
end;

procedure TImageGrabber.OpenDialog(Dialog: TCaptureDriverDialog);
begin
  { Exception auslösen, wenn keine Verbindung zum Aufnahmetreiber besteht }
  if not FConnected then
    RaiseCaptureDriverNotConnectedException;

  { entsprechnedes Dialogfenster öffnen }
  case Dialog of
   cddDisplay: if not capDlgVideoDisplay(CaptureWindow) then
                 RaiseCouldNotOpenDialogException;
   cddFormat:
     begin
       if not capDlgVideoFormat(CaptureWindow) then
         RaiseCouldNotOpenDialogException;
       VideoFormatChanged;
     end;
   cddSource:
     if not capDlgVideoSource(CaptureWindow) then
       RaiseCouldNotOpenDialogException;
  end;
end;

function TImageGrabber.Grab;
var
  DesktopDC: HDC;
  DIB: HBITMAP;
begin
  { Variablen initialisieren }
  Result := nil;
  DIB := 0;

  try
   { Exception auslösen, wenn keine Verbindung zum Aufnahmetreiber besteht }
   if not FConnected then
     RaiseCaptureDriverNotConnectedException;

   { Exception auslösen, wenn für das aktuelle Videoformat kein Codec installiert ist }
   if not FVideoFormatSupported then
     RaiseNoCodecForVideoFormatException;

   { Geräteunabhängige Bitmap erzeugen und im Fehlerfall Exception auslösen }
   DesktopDC:=GetDC(0);
   DIB:=CreateDIBSection(DesktopDC,GrabBitmapInfo^,DIB_RGB_COLORS,GrabBitmapBits,0,0);
   ReleaseDC(0,DesktopDC);
   if DIB=0 then
     RaiseUnableToCreateBitmapException;

   { Bitmap-Objekt erzeugen }
   Result:=TBitmap.Create;
   Result.Handle:=DIB;
   DIB:=0; { Das TBitmap-Objekt ist jetzt Eigentümer der geräteunabhängige Bitmap. }

   { Codec initialisieren }
   if ICDecompressBegin(Decompressor,@VideoBitmapInfo.bmiHeader,@GrabBitmapInfo.bmiHeader)<>ICERR_OK then
     RaiseCodecErrorException;

   try
     { Grab-Vorgang auslösen }
     if not capGrabFrame(CaptureWindow) then
       RaiseGrabErrorException;

    finally
      { Codec deinitialisieren }
      if ICDecompressEnd(Decompressor)<>ICERR_OK then
        RaiseCodecErrorException;
    end;

  except
    { im Fehlerfall das Bitmap-Objekt und wenn nötig die geräteunabhängige Bitmap freigeben }
    Result.Free;
    if DIB <> 0 then
      DeleteObject(DIB);

    { Exception erneuern }
    raise;
  end;
end;


{ TCaptureDrivers }
constructor TCaptureDrivers.Create(ImageGrabber: TImageGrabber);
begin
  { geerbten Constructor aufrufen }
  inherited Create(TCaptureDriver);

  { Eigentümer sichern }
  Owner := ImageGrabber;
end;

function TCaptureDrivers.GetItem(Index: Integer): TCaptureDriver;
begin
  { geerbte Methode aufrufen und Typumwandlung durchführen }
  Result := TCaptureDriver(inherited GetItem(Index));
end;

function TCaptureDrivers.Add;
begin
  { geerbte Methode aufrufen und Typumwandlung durchführen }
  Result := TCaptureDriver(inherited Add);
end;

{ TCaptureDriver }

procedure TCaptureDriver.SetSelected(ASelected: Boolean);
begin
  { sich selbst im zugehörigen TComPortInterface-Objekt auswählen oder Auswahl aufheben }
  if ASelected then
    TCaptureDrivers(Collection).Owner.SelectCaptureDriver(Index)
  else
    if GetSelected then
      TCaptureDrivers(Collection).Owner.SelectCaptureDriver(-1);
end;

function TCaptureDriver.GetSelected;
begin
  { zurückliefern, ob der eigene Index der dem ausgewählten Aufnahmetreiber im zugehörigen TImageGrabber-Objekt entspricht }
  Result := TCaptureDrivers(Collection).Owner.SelectedCaptureDriverIndex=Index;
end;

procedure TCaptureDriver.Select;
begin
  { Auswahl über die SetSelected-Methode durchführen }
  SetSelected(True);
end;

end.

