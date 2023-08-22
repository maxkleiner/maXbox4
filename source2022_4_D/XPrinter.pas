(*********************************************************************)
(*                                                                   *)
(*   XPrint: Eine Komponente zur geräteunabhängigen Druckerausgabe   *)
(*                                                                   *)
(*   (c) 1997-2004 Rainer Reusch für Toolbox                         *)
(*   (c) 1997-2004 Rainer Reusch für Computer & Literatur-Verlag     *)
(*                                                                   *)
(*   Borland Delphi 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0                *)
(*   Borland C++Builder 3.0, 4.0, 5.0, 6.0                           *)
(*                                                                   *)
(****V1.6**************************************************Build 1****)

{$A+,B-,C-,D-,E-,F-,G+,H+,I-,J+,K-,L-,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y-,Z1}

{$DEFINE DELPHI4UP}
{$IFDEF VER110} {$UNDEF DELPHI4UP}                     {$ENDIF}  { C++Builder 3 }
{$IFDEF VER100} {$UNDEF DELPHI4UP}                     {$ENDIF}  { Delphi 3 }
{$IFDEF VER93}  Nicht für diese Version geeignet       {$ENDIF}  { C++Builder 1 }
{$IFDEF VER90}  {$UNDEF DELPHI4UP} {$DEFINE DELPHI1_2} {$ENDIF}  { Delphi 2 }
{$IFDEF VER80}  {$UNDEF DELPHI4UP} {$DEFINE DELPHI1_2} {$ENDIF}  { Delphi 1 }

unit XPrinter;

interface

uses
  {$IFDEF VER80}
  WinTypes,
  {$ELSE}
  WinSpool,
  {$ENDIF}
  WinProcs, Classes, Graphics, SysUtils, Printers;

type
  TXPrinterOrientation  = (xpoPortrait, xpoLandscape);
  TXPrinterCapability   = (xpcCopies, xpcOrientation, xpcCollation);
  TXPrinterCapabilities = set of TXPrinterCapability;
  TScaling = (pscDot,          { Skalierungseinheit "Pixel" (geräteabhängig) }
              pscMil,          {                    1/1000"                  }
              pscMetric10,     {                    1/10mm                   }
              pscMetric100);   {                    1/100mm                  }

  { TXPrinter-Konfigurationsdatensatz }
  TXTitleString = string[63];           { Datentyp Drucktitel }
  TFontString   = string[32];           { Datentyp Font-Name }
  TXPrintConfig = record
    Valid          : boolean;           { true: Parameter sind gültig }
    CurrentPrinter : integer;           { ausgewählter Drucker }
    Scaling        : TScaling;          { Skalierung }
    MarginLeft,                         { Randeinstellungen }
    MarginTop,
    MarginRight,
    MarginBottom   : integer;
    Font_Charset   : integer;           { Font-Einstellungen }
    Font_Color     : TColor;
    Font_Height    : integer;
    Font_Name      : TFontString;
    Font_Pitch     : TFontPitch;
    Font_Size      : integer;
    Font_Style     : TFontStyles;
    Copies         : integer;            { Anzahl Kopien }
    Orientation    : TXPrinterOrientation;  { Ausrichtung }
    Angle10        : integer;            { Winkel bei gedrehter Textausgabe }
    TextRotation   : boolean;            { gedrehte Textausgabe }
    Title          : TXTitleString;      { Druck-Titel }
  end { record };

  TXPrint = class (TComponent)
  private
    { Eigenschaften }
    fScaling : TScaling;   { eingestellte Skalierung }
    fMarginLeft,           { Randeinstellungen }
    fMarginTop,
    fMarginRight,
    fMarginBottom : integer;
    fPrintWidth,           { bedruckbarer Bereich }
    fPrintHeight  : integer;
    fPrintersInstalled : word;   { Anzahl vorhandener Drucker }
    fTextRotation : boolean;  { gedrehter Text einschalten }
    fAngle10 : integer;    { Drehwinkel für gedrehten Text in 0,1° }
    { Druckerparameter }
    pLogPixelsX,           { Auflösung (dpi) }
    pLogPixelsY,
    pPhysicalWidth,        { Blattgröße in Pixeln }
    pPhysicalHeight,
    pHorzRes,              { bedruckbarer Bereich in Pixeln }
    pVertRes,
    pPhysicalOffsetX,      { Abstand bedruckbarer Bereich vom Blattrand }
    pPhysicalOffsetY : integer;
    { für den internen Gebrauch }
    k : integer;           { Skalierungsfaktor }
    FontBackup : TFont;    { Backup für Font }
    SizeBackup : integer;  { zuletzt eingestellte Font-Größe in Twips }
    PrintOpened : boolean; { true, nach BeginDoc }
    DummyCreated: boolean; { true, wenn Dummy-Canvas angelegt wurde }
    UnrotatedFont: THandle;{ Handle des nicht gedrehten Fonds (Datensicherung) }
    function  PrintersInstalled : word;
    procedure SetupPrinter;
    procedure SetScaling(Value : TScaling);
    function  GetPrinterAvailable : boolean;
    function  GetPrinting : boolean;
    function  GetFont : TFont;
    procedure SetFont(Value : TFont);
    function  GetAborted : boolean;
    function  GetMinMarginLeft : integer;
    function  GetMinMarginTop : integer;
    function  GetMinMarginRight : integer;
    function  GetMinMarginBottom : integer;
    function  GetPrinterCapabilities : TXPrinterCapabilities;
    function  GetCopies : integer;
    procedure SetCopies(Value : integer);
    function  GetFonts : TStrings;
    function  GetHandle: HDC;
    function  GetPageNumber : integer;
    function  GetPrinters : TStrings;
    function  GetTitle : string;
    procedure SetTitle(Value : string);
    function  GetCurrentPrinter : integer;
    procedure SetCurrentPrinter(Value : integer);
    function  GetOrientation : TXPrinterOrientation;
    procedure SetOrientation(Value : TXPrinterOrientation);
    procedure SetAngleText;
    procedure UnsetAngleText;
    procedure SetTextRotation(Value : boolean);
    procedure SetAngle10(Value : integer);
    function  GetColorDepth : integer;
    function  GetCanUserDefFill : boolean;
  protected
    procedure DriverParams;
    procedure ClosePrinting;
    function  DotValX(ScaledVal : integer) : integer;
    function  DotValY(ScaledVal : integer) : integer;
    function  ScaleValX(DotVal : integer) : integer;
    function  ScaleValY(DotVal : integer) : integer;
  public
    Canvas : TCanvas;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Abort;
    procedure BeginDoc;
    procedure EndDoc;
    procedure NewPage;
    procedure SetFontSize(FontSize : integer);
    procedure SelectFont(AFont : TFont);
    function  XBounds(ALeft, ATop, AWidth, AHeight: Integer): TRect;
    procedure SetConfig(XPrintConfig : TXPrintConfig);
    procedure SyncIndex;
    function GetConfig : TXPrintConfig;
    function ConfigToStr(XPrintConfig : TXPrintConfig) : string;
    function StrToConfig(CfgStr : string) : TXPrintConfig;
    property PrinterAvailable : boolean read GetPrinterAvailable;
    property CurrentPrinter : integer read  GetCurrentPrinter
                                      write SetCurrentPrinter;
    property PrintWidth : integer read fPrintWidth;
    property PrintHeight : integer read fPrintHeight;
    property MinMarginLeft : integer read GetMinMarginLeft;
    property MinMarginTop : integer read GetMinMarginTop;
    property MinMarginRight : integer read GetMinMarginRight;
    property MinMarginBottom : integer read GetMinMarginBottom;
    property Capabilities : TXPrinterCapabilities read GetPrinterCapabilities;
    property Fonts : TStrings read GetFonts;
    property Handle : HDC read GetHandle;
    property PageNumber : integer read GetPageNumber;
    property Printers : TStrings read GetPrinters;
    property Printing : boolean read GetPrinting;
    property XResolution : integer read pLogPixelsX;
    property YResolution : integer read pLogPixelsY;
    property TextRotation : boolean             read  fTextRotation
                                                write SetTextRotation;
    property ColorDepth : integer read GetColorDepth;
    property CanUserDefFill : boolean read GetCanUserDefFill;
  published
    property Scaling : TScaling                 read    fScaling
                                                write   SetScaling
                                                default pscDot;
    property MarginLeft : integer               read  fMarginLeft
                                                write fMarginLeft;
    property MarginTop : integer                read  fMarginTop
                                                write fMarginTop;
    property MarginRight : integer              read  fMarginRight
                                                write fMarginRight;
    property MarginBottom : integer             read  fMarginBottom
                                                write fMarginBottom;
    property Font : TFont                       read  GetFont
                                                write SetFont;
    property Aborted : boolean                  read  GetAborted;
    property Copies : integer                   read  GetCopies
                                                write SetCopies;
    property Title : string                     read  GetTitle
                                                write SetTitle;
    property Orientation : TXPrinterOrientation read  GetOrientation
                                                write SetOrientation;
    property Angle10 : integer                  read  fAngle10
                                                write SetAngle10;
  end;

procedure Register;

implementation

const
  ParCfgID  : array[0..3] of char = 'RRP0';  { ID für Konfigurationsstring TXPrint (Version 0) }

constructor TXPrint.Create;
begin
  inherited Create(AOwner);
  DummyCreated:=false;
  UnrotatedFont:=0;
  fPrintersInstalled:=PrintersInstalled;
  if fPrintersInstalled>0 then
  begin
    Canvas:=Printer.Canvas;
    Printer.PrinterIndex:=-1;
  end
  else
  begin
    Canvas:=TCanvas.Create;
    DummyCreated:=true;
  end;
  PrintOpened:=false;
  pLogPixelsX:=300;   { angenommene Werte als Default }
  pLogPixelsY:=300;
  k:=1;
end;

destructor TXPrint.Destroy;
begin
  if DummyCreated then Canvas.Free;
  inherited Destroy;
end;

procedure TXPrint.DriverParams;
{ Druckertreiber-Parameter ermitteln }
{$IFDEF VER80}
var
  r : TPoint;
{$ENDIF}
begin
  if fPrintersInstalled>0 then
  begin
    pLogPixelsX:=GetDeviceCaps(Printer.Handle,LOGPIXELSX);
    pLogPixelsY:=GetDeviceCaps(Printer.Handle,LOGPIXELSY);
    {$IFDEF VER80}
    Escape(Printer.Handle,GETPHYSPAGESIZE,0,nil,@r);
    pPhysicalWidth:=r.x;
    pPhysicalHeight:=r.y;
    {$ELSE}
    pPhysicalWidth:=GetDeviceCaps(Printer.Handle,PHYSICALWIDTH);
    pPhysicalHeight:=GetDeviceCaps(Printer.Handle,PHYSICALHEIGHT);
    {$ENDIF}
    pHorzRes:=GetDeviceCaps(Printer.Handle,HORZRES);
    pVertRes:=GetDeviceCaps(Printer.Handle,VERTRES);
    {$IFDEF VER80}
    Escape(Printer.Handle,GETPRINTINGOFFSET,0,nil,@r);
    pPhysicalOffsetX:=r.x;
    pPhysicalOffsetY:=r.y;
    {$ELSE}
    pPhysicalOffsetX:=GetDeviceCaps(Printer.Handle,PHYSICALOFFSETX);
    pPhysicalOffsetY:=GetDeviceCaps(Printer.Handle,PHYSICALOFFSETY);
    {$ENDIF}
  end;
end;

procedure TXPrint.ClosePrinting;
begin
  if fPrintersInstalled>0 then
  begin
    { ursprünglichen Font wieder setzen }
    Canvas.Font.Color:=FontBackup.Color;
    Canvas.Font.Height:=FontBackup.Height;
    Canvas.Font.Name:=FontBackup.Name;
    Canvas.Font.Pitch:=FontBackup.Pitch;
    Canvas.Font.Size:=FontBackup.Size;
    Canvas.Font.Style:=FontBackup.Style;
    FontBackup.Free;
  end;
  PrintOpened:=false;
end;

function TXPrint.DotValX(ScaledVal : integer) : integer;
{ Rechnet skalierten Wert in Pixel um,
  abhängig von der Skalierung und der hor. Druckerauflösung }
begin
  if Scaling=pscDot then
    DotValX:=ScaledVal
  else
    DotValX:=longint(ScaledVal)*pLogPixelsX div k;
end;

function TXPrint.DotValY(ScaledVal : integer) : integer;
{ Rechnet skalierten Wert in Pixel um,
  abhängig von der Skalierung und der vert. Druckerauflösung }
begin
  if Scaling=pscDot then
    DotValY:=ScaledVal
  else
    DotValY:=longint(ScaledVal)*pLogPixelsY div k;
end;

function TXPrint.ScaleValX(DotVal : integer) : integer;
{ Rechnet einen Pixelwert in skalierten Wert um,
  abhängig von der Skalierung und der hor. Druckerauflösung }
begin
  if Scaling=pscDot then
    ScaleValX:=DotVal
  else
    ScaleValX:=longint(DotVal)*k div pLogPixelsX;
end;

function TXPrint.ScaleValY(DotVal : integer) : integer;
{ Rechnet einen Pixelwert in skalierten Wert um,
  abhängig von der Skalierung und der vert. Druckerauflösung }
begin
  if Scaling=pscDot then
    ScaleValY:=DotVal
  else
    ScaleValY:=longint(DotVal)*k div pLogPixelsY;
end;

procedure TXPrint.Abort;
{ Druckausgabe abbrechen }
begin
  if fPrintersInstalled>0 then
  begin
    Printer.Abort;
    ClosePrinting;
  end;
end;

procedure TXPrint.SetupPrinter;
{ Druckereinstellungen setzen }
var
  kx1, ky1, ox, oy, i : longint;
  kx2, ky2 : integer;
begin
  if fPrintersInstalled>0 then
  with Printer do
  begin
    if fScaling=pscDot then
    begin   { keine Skalierung }
      { bedruckbarer Bereich }
      i:=longint(pHorzRes-(MarginLeft-pPhysicalOffsetX)-1); { Pixel }
      i:=i-MarginRight+pPhysicalWidth-pPhysicalOffsetX-pHorzRes;
      fPrintWidth:=i;
      i:=longint(pVertRes-(MarginTop-pPhysicalOffsetY)-1);
      i:=i-MarginBottom+pPhysicalHeight-pPhysicalOffsetY-pVertRes;
      fPrintHeight:=i;
    end
    else
    begin   { Skalierung }
      { bedruckbarer Bereich }
      i:=longint(pHorzRes-(DotValX(MarginLeft)-pPhysicalOffsetX)-1); { Pixel }
      i:=i-DotValX(MarginRight)+pPhysicalWidth-pPhysicalOffsetX-pHorzRes;
      fPrintWidth:=longint(k)*i div pLogPixelsX;
      i:=longint(pVertRes-(DotValY(MarginTop)-pPhysicalOffsetY)-1);
      i:=i-DotValY(MarginBottom)+pPhysicalHeight-pPhysicalOffsetY-pVertRes;
      fPrintHeight:=longint(k)*i div pLogPixelsY;
      { Skalierung }
      kx2:=7200;   { Änderung V1.4 }
      ky2:=7200;
      kx1:=k*longint(7200 div pLogPixelsX);
      while kx1>32767 do
      begin
        kx1:=kx1 div 2;
        kx2:=kx2 div 2;
      end;
      ky1:=k*longint(7200 div pLogPixelsY);
      while ky1>32767 do
      begin
        ky1:=ky1 div 2;
        ky2:=ky2 div 2;
      end;
      SetMapMode(Handle,MM_Isotropic);   { Breite und Höhe im gleichen Verhältnis }
      ox:=(longint(MarginLeft)*pLogPixelsX div k)-pPhysicalOffsetX;
      oy:=(longint(MarginTop)*pLogPixelsY div k)-pPhysicalOffsetY;
      {$IFDEF VER80}
      SetWindowExt(Handle,kx1,ky1);
      SetViewPortExt(Handle,kx2,ky2);
      SetViewPortOrg(Handle,ox,oy);
      {$ELSE}
      SetWindowExtEx(Handle,kx1,ky1,nil);
      SetViewPortExtEx(Handle,kx2,ky2,nil);
      SetViewPortOrgEx(Handle,ox,oy,nil);
      {$ENDIF}
    end;
  end;
end;

procedure TXPrint.BeginDoc;
{ Druckausgabe öffnen }
var
  FS : integer;
begin
  if fPrintersInstalled>0 then
  begin
    DriverParams;   { Druckerparameter ermitteln }
    Printer.BeginDoc;
    PrintOpened:=true;
    SetupPrinter;
    with Printer do
    begin
      { Korrektur der Font-Auflösung, falls Drucker gewechselt wurde
        (geklaut im Quelltext der Unit PRINTERS) }
      FS:=Canvas.Font.Size;
      Canvas.Font.PixelsPerInch:=pLogPixelsY;
      Canvas.Font.Size:=FS;
      { Backup vom aktuellen Font erstellen }
      FontBackup:=TFont.Create;
      FontBackup.Color:=Canvas.Font.Color;
      FontBackup.Height:=Canvas.Font.Height;
      FontBackup.Name:=Canvas.Font.Name;
      FontBackup.Pitch:=Canvas.Font.Pitch;
      FontBackup.Size:=Canvas.Font.Size;
      FontBackup.Style:=Canvas.Font.Style;
      { Größe des vorgegebenen Fonts anpassen }
      FS:=Canvas.Font.Size;
      SetFontSize(FS);
    end;
  end;
end;

procedure TXPrint.EndDoc;
{ Druckerausgabe schließen }
begin
  if fPrintersInstalled>0 then
  begin
    Printer.EndDoc;
    ClosePrinting;
  end;
end;

procedure TXPrint.NewPage;
{ neue Seite }
begin
  if (PrintersInstalled>0) and PrintOpened then
  begin
    Printer.NewPage;
    SetupPrinter;
    SetFontSize(SizeBackup);
  end;
end;

procedure TXPrint.SetFontSize;
{ Font-Größe setzen }
begin
  if fPrintersInstalled>0 then
  begin
    SizeBackup:=FontSize;
    with Canvas.Font do
    if (fScaling=pscDot) or (not PrintOpened) then
      Size:=abs(FontSize)   { keine Skalierung }
    else
      Size:=longint(abs(FontSize))*k div PixelsPerInch;   { Druckerauflösung berücksichtigen }
  end;
end;

procedure TXPrint.SelectFont(AFont : TFont);
{ Den angegebenen Font als Drucker-Font setzen }
begin
  if fPrintersInstalled>0 then
  with Canvas.Font do
  begin
    Height:=-abs(AFont.Height);
    Name:=AFont.Name;
    Pitch:=AFont.Pitch;
    Style:=AFont.Style;
    SetFontSize(AFont.Size);
  end;
end;

function TXPrint.XBounds(ALeft, ATop, AWidth, AHeight: Integer): TRect;
begin
  {$IFDEF VER80}
  XBounds:=Bounds(DotValX(ALeft),DotValY(ATop),DotValX(AWidth),DotValY(AHeight));
  {$ELSE}
  XBounds:=Bounds(ALeft,ATop,AWidth,AHeight);
  {$ENDIF}
end;

function TXPrint.PrintersInstalled : word;
{ Ermittelt, wieviele Drucker im System eingerichtet sind }
{$IFDEF VER80}
const
  DevicesSize = 4096;
var
  i, j : word;
  Devices: PChar;
  {$ELSE}
var
  Buffer: PChar;
  {$IFDEF DELPHI4UP}
  Count, NumInfo: cardinal;
  Flags: cardinal;
  {$ELSE}
  Count, NumInfo: Integer;
  Flags: Integer;
  {$ENDIF}
  Level: Byte;
  {$ENDIF}
begin
  PrintersInstalled:=0;
  {$IFDEF VER80}
  GetMem(Devices, DevicesSize);
  try
    i:=0;
    GetProfileString('devices', nil, '', Devices, DevicesSize);
    if Devices[0]>#0 then
    begin   { mind. ein Drucker ist vorhanden }
      j:=0;
      repeat
        inc(j);
        if Devices[j]=#0 then
        begin
          inc(i);
          inc(j);
        end;
      until Devices[j]=#0;
    end;
  except
    i:=0;
  end;
  FreeMem(Devices, DevicesSize);
  PrintersInstalled:=i;
  {$ELSE}
  try
    if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      Flags := PRINTER_ENUM_CONNECTIONS or PRINTER_ENUM_LOCAL;
      Level := 4;
    end
    else
    begin
      Flags := PRINTER_ENUM_LOCAL;
      Level := 5;
    end;
    EnumPrinters(Flags, nil, Level, nil, 0, Count, NumInfo);
    GetMem(Buffer, Count);
    try
      if not EnumPrinters(Flags, nil, Level, PByte(Buffer), Count, Count, NumInfo) then
        Exit;
      PrintersInstalled:=NumInfo;
    finally
      FreeMem(Buffer, Count);
    end;
  except
    PrintersInstalled:=0;
  end;
  {$ENDIF}
end;

function TXPrint.GetPrinterAvailable : boolean;
{ Liefert true, wenn mindestens ein Drucker vorhanden ist }
begin
  GetPrinterAvailable:=fPrintersInstalled>0;
end;

function TXPrint.GetPrinting;
{ Prüfen, ob gerade eine Druckerausgabe läuft }
begin
  if fPrintersInstalled>0 then
    GetPrinting:=Printer.Printing
  else
    GetPrinting:=false;
end;

procedure TXPrint.SetScaling;
{ Skalierung setzen }
var
  ML, MT, MR, MB : integer;
begin
  if not PrintOpened then
  begin
    { Randpositionen in Pixel umrechnen }
    ML:=DotValX(MarginLeft);
    MT:=DotValY(MarginTop);
    MR:=DotValX(MarginRight);
    MB:=DotValY(MarginBottom);
    fScaling:=Value;
    k:=1;
    case fScaling of
      pscMetric10  : k:=254;
      pscMetric100 : k:=2540;
      pscMil       : k:=1000;
    end { case };
    { Randpositionen entsprechend Skalierung umrechnen }
    MarginLeft:=ScaleValX(ML);
    MarginTop:=ScaleValY(MT);
    MarginRight:=ScaleValX(MR);
    MarginBottom:=ScaleValY(MB);
  end;
end;

function TXPrint.GetFont;
{ aktueller Druck-Font }
begin
  GetFont:=Canvas.Font
end;

procedure TXPrint.SetFont;
{ aktuellen Druck-Font setzen (nur die Inhalte) }
begin
  Canvas.Font.Color:=Value.Color;
  Canvas.Font.Height:=Value.Height;
  Canvas.Font.Name:=Value.Name;
  Canvas.Font.Pitch:=Value.Pitch;
  Canvas.Font.Size:=Value.Size;
  Canvas.Font.Style:=Value.Style;
end;

function TXPrint.GetAborted;
{ Abfrage auf Abbruch }
begin
  if fPrintersInstalled>0 then
    GetAborted:=Printer.Aborted
  else
    GetAborted:=false;
end;

function TXPrint.GetMinMarginLeft : integer;
{ linker Rand: kleinstmögliche Randposition, gegeben durch den Druckertreiber }
begin
  GetMinMarginLeft:=ScaleValX(pPhysicalOffsetX);
end;

function TXPrint.GetMinMarginRight : integer;
{ rechter Rand: kleinstmögliche Randposition, gegeben durch den Druckertreiber }
begin
  GetMinMarginRight:=ScaleValX(pPhysicalWidth-pHorzRes-pPhysicalOffsetX);
end;

function TXPrint.GetMinMarginTop : integer;
{ oberer Rand: kleinstmögliche Randposition, gegeben durch den Druckertreiber }
begin
  GetMinMarginTop:=ScaleValY(pPhysicalOffsetY);
end;

function TXPrint.GetMinMarginBottom : integer;
{ unterer Rand: kleinstmögliche Randposition, gegeben durch den Druckertreiber }
begin
  GetMinMarginBottom:=ScaleValY(pPhysicalHeight-pVertRes-pPhysicalOffsetY);
end;

function TXPrint.GetPrinterCapabilities : TXPrinterCapabilities;
{ Druckereigenschaften }
var
  r : TXPrinterCapabilities;
begin
  r:=[];
  if fPrintersInstalled>0 then
  begin
    {$IFNDEF VER80}
    if pcCopies in Printer.Capabilities then r:=[xpcCopies];
    if pcOrientation in Printer.Capabilities then r:=r+[xpcOrientation];
    if pcCollation in Printer.Capabilities then r:=r+[xpcCollation];
    {$ENDIF}
  end;
  GetPrinterCapabilities:=r;
end;

function TXPrint.GetCopies;
{ Anzahl Kopien }
begin
  if fPrintersInstalled>0 then
  begin
    {$IFDEF VER80}
    GetCopies:=1;
    {$ELSE}
    GetCopies:=Printer.Copies;
    {$ENDIF}
  end
  else GetCopies:=1;
end;

procedure TXPrint.SetCopies;
{ Anzahl Kopien }
begin
  {$IFNDEF VER80}
  // nur in der 32-Bit-Version unterstützt
  if fPrintersInstalled>0 then Printer.Copies:=Value;
  {$ENDIF}
end;

function TXPrint.GetFonts;
{ verfügbare Drucker-Fonts }
begin
  if fPrintersInstalled>0 then
    GetFonts:=Printer.Fonts
  else
    GetFonts:=nil;
end;

function TXPrint.GetHandle;
{ Drucker-Handle }
begin
  if fPrintersInstalled>0 then
    GetHandle:=Printer.Handle
  else
    GetHandle:=0;
end;

function TXPrint.GetPageNumber : integer;
{ Seitennummer }
begin
  if fPrintersInstalled>0 then
    GetPageNumber:=Printer.PageNumber
  else
    GetPageNumber:=1;
end;

function TXPrint.GetPrinters;
{ verfügbare Drucker }
begin
  if fPrintersInstalled>0 then
    GetPrinters:=Printer.Printers
  else
    GetPrinters:=nil;
end;

function TXPrint.GetTitle;
{ Druck-Job-Name, erscheint im Druck-Manager }
begin
  if fPrintersInstalled>0 then
    GetTitle:=Printer.Title
  else
    GetTitle:='';
end;

procedure TXPrint.SetTitle;
{ Druck-Job-Name, erscheint im Druck-Manager }
begin
  if fPrintersInstalled>0 then
    Printer.Title:=Value;
end;

function TXPrint.GetCurrentPrinter;
{ aktueller Drucker }
begin
  if fPrintersInstalled>0 then
    GetCurrentPrinter:=Printer.PrinterIndex
  else
    GetCurrentPrinter:=0;
end;

procedure TXPrint.SetCurrentPrinter;
{ aktueller Drucker }
begin
  if fPrintersInstalled>0 then
  begin
    Printer.PrinterIndex:=Value;
    DriverParams;   { Druckerparameter ermitteln }
  end;
end;

function TXPrint.GetOrientation;
{ Ausrichtung }
begin
  if fPrintersInstalled>0 then
    GetOrientation:=TXPrinterOrientation(ord(Printer.Orientation))
  else
    GetOrientation:=xpoPortrait;
end;

procedure TXPrint.SetOrientation;
{ Ausrichtung }
begin
  if fPrintersInstalled>0 then
    Printer.Orientation:=TPrinterOrientation(ord(Value));
end;

procedure TXPrint.SetAngleText;
{ Font für gedrehten Text setzen }
var
  Size : integer;
  RotatedFont : HFont;
  Bold,
  Italic,
  Underline,
  StrikeOut : integer;
  {$IFDEF DELPHI1_2}
  c : array[0..SizeOf(TFontString)-1] of char;
  {$ENDIF}
begin
  {  Size:=36*abs(XPrint.Font.Size)*XPrint.Font.PixelsPerInch div 2540; }
  Size:=9*abs(Font.Size)*Font.PixelsPerInch div 635;
  if (fsBold in Font.Style) then Bold:=fw_bold
                            else Bold:=fw_normal;
  if (fsItalic in Font.Style) then Italic:=1
                              else Italic:=0;
  if (fsUnderline in Font.Style) then Underline:=1
                                 else Underline:=0;
  if (fsStrikeout in Font.Style) then Strikeout:=1
                                 else Strikeout:=0;
  {$IFDEF DELPHI1_2}
  StrPCopy(c,Font.Name);
  RotatedFont:=CreateFont(Size,0,Angle10,0,Bold,Italic,Underline,Strikeout,1,
    out_tt_precis,$10,2,FF_DONTCARE,c);
  {$ELSE}
  RotatedFont:=CreateFont(Size,0,Angle10,0,Bold,Italic,Underline,Strikeout,1,
    out_tt_precis,$10,2,FF_DONTCARE,PChar(Font.Name));
  {$ENDIF}
  UnrotatedFont:=SelectObject(Canvas.Handle,RotatedFont);
end;

procedure TXPrint.UnsetAngleText;
{ Font für gedrehten Text zurück nehmen }
var
  RotatedFont : HFont;
begin
  if UnrotatedFont<>0 then
  begin
    RotatedFont:=SelectObject(Canvas.Handle,UnrotatedFont);
    DeleteObject(RotatedFont);
    UnrotatedFont:=0;
  end;
end;

procedure TXPrint.SetTextRotation(Value : boolean);
begin
  if Value and (not fTextRotation) then
  begin  { Textdrehung einschalten }
    if fAngle10<>0 then
    begin
      SetAngleText;
      fTextRotation:=true;
    end;
  end
  else
  if (not Value) and fTextRotation then
  begin   { Textdrehung ausschalten }
    UnsetAngleText;
    fTextRotation:=false;
  end;
end;

procedure TXPrint.SetAngle10(Value : integer);
begin
  if fTextRotation then UnsetAngleText;
  fAngle10:=Value mod 3600;
  if fTextRotation and (fAngle10<>0) then SetAngleText
                                     else fTextRotation:=false;
end;

function TXPrint.GetColorDepth : integer;
begin
  if Handle>0 then Result:=GetDeviceCaps(Handle,BITSPIXEL)
              else Result:=0;
end;

function TXPrint.GetCanUserDefFill : boolean;
var
  i : integer;
begin
  if fPrintersInstalled>0 then
  begin
    i:=GetDeviceCaps(Handle,RASTERCAPS);
    Result:=(i and RC_STRETCHBLT)>0;
  end
  else Result:=false;
end;

procedure TXPrint.SetConfig(XPrintConfig : TXPrintConfig);
{ Konfiguration aus Record in Eigenschaften übernehmen
  Übernahme erfolgt nur, wenn XPrintConfig.Valid=true }
begin
  if XPrintConfig.Valid and (not PrintOpened) then
  begin
    CurrentPrinter:=XPrintConfig.CurrentPrinter;
    Scaling:=XPrintConfig.Scaling;
    MarginLeft:=XPrintConfig.MarginLeft;
    MarginTop:=XPrintConfig.MarginTop;
    MarginRight:=XPrintConfig.MarginRight;
    MarginBottom:=XPrintConfig.MarginBottom;
    {$IFNDEF DELPHI1_2}
    Font.Charset:=XPrintConfig.Font_Charset;
    {$ENDIF}
    Font.Color:=XPrintConfig.Font_Color;
    Font.Height:=XPrintConfig.Font_Height;
    Font.Name:=XPrintConfig.Font_Name;
    Font.Pitch:=XPrintConfig.Font_Pitch;
    Font.Size:=XPrintConfig.Font_Size;
    Font.Style:=XPrintConfig.Font_Style;
    Copies:=XPrintConfig.Copies;
    Orientation:=XPrintConfig.Orientation;
    Angle10:=XPrintConfig.Angle10;
    TextRotation:=XPrintConfig.TextRotation;
    Title:=XPrintConfig.Title;
  end;
end;

function TXPrint.GetConfig : TXPrintConfig;
{ aktuelle Einstellungen als Funktionsergebnis zurück liefern }
var
  i : integer;
  s : string;
begin
  Result.Valid:=true;                          { Parameter sind gültig }
  Result.CurrentPrinter:=CurrentPrinter;
  Result.Scaling:=Scaling;
  Result.MarginLeft:=MarginLeft;
  Result.MarginTop:=MarginTop;
  Result.MarginRight:=MarginRight;
  Result.MarginBottom:=MarginBottom;
  {$IFNDEF DELPHI1_2}
  Result.Font_Charset:=Font.Charset;
  {$ELSE}
  Result.Font_Charset:=0;
  {$ENDIF}
  Result.Font_Color:=Font.Color;
  Result.Font_Height:=Font.Height;
  for i:=1 to Length(Font.Name) do
    Result.Font_Name[i]:=Font.Name[i];
  Result.Font_Name[0]:=char(Length(Font.Name));
  Result.Font_Pitch:=Font.Pitch;
  Result.Font_Size:=Font.Size;
  Result.Font_Style:=Font.Style;
  Result.Copies:=Copies;
  Result.Orientation:=Orientation;
  Result.Angle10:=Angle10;
  Result.TextRotation:=TextRotation;
  s:=Title;
  {$IFNDEF VER80}
  if (Length(s)>=SizeOf(TXTitleString)) then SetLength(s,SizeOf(TXTitleString)-1);
  {$ELSE}
  if (Length(s)>=SizeOf(TXTitleString)) then s[0]:=chr(SizeOf(TXTitleString)-1);
  {$ENDIF}
  Result.Title:=Title;
end;

function TXPrint.ConfigToStr(XPrintConfig : TXPrintConfig) : string;
{ Konfigurationsdaten in String umwandeln
  Bei ungültigen Daten wird ein Leerstring zurück geliefert }
var
  i : integer;
  r : array[0..255] of char;
  p : byte;

  procedure Int2RStr(Value, DefLength, Index : integer);
  { Integer -> String mit Nullen vorangestellt
   Ergebnis wird ab r[Index] abgelegt }
  var
    j : integer;
    s : string;
  begin
    s:=IntToStr(abs(Value));
    while Length(s)<DefLength do s:='0'+s;
    if Value<0 then s[1]:='-';
    for j:=1 to DefLength do r[Index+j-1]:=s[j];
  end;

begin
  if XPrintConfig.Valid then
  begin
    for i:=0 to SizeOf(r)-1 do r[i]:=#0;
    { ID und Version (0) }
    for i:=0 to 3 do r[i]:=ParCfgID[i];
    { aktueller Drucker (4) }
    Int2RStr(XPrintConfig.CurrentPrinter,3,4);
    { Skalierung (7) }
    Int2RStr(ord(XPrintConfig.Scaling),1,7);
    { Linker Rand (8) }
    Int2RStr(XPrintConfig.MarginLeft,8,8);
    { Oberer Rand (16) }
    Int2RStr(XPrintConfig.MarginTop,8,16);
    { Rechter Rand (24) }
    Int2RStr(XPrintConfig.MarginRight,8,24);
    { Unterer Rand (32) }
    Int2RStr(XPrintConfig.MarginBottom,8,32);
    { Font.Charset (40) }
    Int2RStr(XPrintConfig.Font_Charset,3,40);
    { Font.Color (43) }
    Int2RStr(XPrintConfig.Font_Color,11,43);
    { Font.Height (54) }
    Int2RStr(XPrintConfig.Font_Height,4,54);
    { Font.Name (58) (ohne Längenbyte, Rest mit #127 aufgefüllt) }
    while Length(XPrintConfig.Font_Name)<SizeOf(XPrintConfig.Font_Name)-1 do
      XPrintConfig.Font_Name:=XPrintConfig.Font_Name+#127;
    for i:=1 to SizeOf(TFontString) do
      r[57+i]:=XPrintConfig.Font_Name[i];
    { Font.Pitch (58+SizeOf(TFontString)-1) }
    Int2RStr(ord(XPrintConfig.Font_Pitch),1,58+SizeOf(TFontString)-1);
    { Font.Size (59+SizeOf(TFontString)-1) }
    Int2RStr(XPrintConfig.Font_Size,4,59+SizeOf(TFontString)-1);
    { Font.Style (63+SizeOf(TFontString)-1) (1 Zeichen) }
    i:=$30;
    if fsBold in XPrintConfig.Font_Style then i:=i or $01;
    if fsItalic in XPrintConfig.Font_Style then i:=i or $02;
    if fsUnderline in XPrintConfig.Font_Style then i:=i or $04;
    if fsStrikeout in XPrintConfig.Font_Style then i:=i or $08;
    r[63+SizeOf(TFontString)-1]:=chr(i);
    { Copies (64+SizeOf(TFontString)-1) }
    Int2RStr(XPrintConfig.Copies,5,64+SizeOf(TFontString)-1);
    { Orientation (69+SizeOf(TFontString)-1) }
    Int2RStr(ord(XPrintConfig.Orientation),1,69+SizeOf(TFontString)-1);
    { Angle10 (70+SizeOf(TFontString)-1) }
    Int2RStr(XPrintConfig.Angle10,5,70+SizeOf(TFontString)-1);
    { TextRotation (75+SizeOf(TFontString)-1) }
    Int2RStr(byte(XPrintConfig.TextRotation),1,75+SizeOf(TFontString)-1);
    { Title (76+SizeOf(TFontString)-1) (ohne Längenbyte, Rest mit #127 aufgefüllt) }
    while Length(XPrintConfig.Title)<SizeOf(XPrintConfig.Title)-1 do
      XPrintConfig.Title:=XPrintConfig.Title+#127;
    for i:=1 to SizeOf(TXTitleString) do
      r[74+SizeOf(TFontString)+i]:=XPrintConfig.Title[i];
    { String-Parität (76+SizeOf(TFontString)+SizeOf(TXTitleString)-2) (3 Ziffern) }
    p:=0;
    for i:=0 to 73+SizeOf(TFontString)+SizeOf(TXTitleString) do p:=p xor ord(r[i]);
    Int2RStr(p,3,76+SizeOf(TFontString)+SizeOf(TXTitleString)-2);
    { Ergebnis }
    Result:=StrPas(r);
  end
  else Result:=EmptyStr;
end;

function TXPrint.StrToConfig(CfgStr : string) : TXPrintConfig;
{ Konfigurationsstring in Record umwandeln
  Bei einem Fehler im String ist Result.Valid:=false,
  die restlichen Einstellungen entsprechen aktueller }
var
  i : integer;
  Ok : boolean;
  p : byte;
  r : array[0..255] of char;

  function RStr2Int(DefLength, Index : integer; var Value : integer) : boolean;
  { Teilstring r[Index] der Länge DefLength in Zahl umwandeln
    Ergebnis in Value
    Ergebnis true, wenn String gültige Zeichen enthält }
  var
    j : integer;
    c : array[0..15] of char;
  begin
    for j:=0 to DefLength-1 do c[j]:=r[Index+j];
    c[DefLength]:=#0;
    val(c,Value,j);
    Result:=j=0;
  end;

begin
  Result:=GetConfig;
  Result.Valid:=false;
  if Length(CfgStr)>4 then
  begin
    for i:=0 to SizeOf(r)-1 do r[i]:=#0;
    StrPCopy(r,CfgStr);
    { ID und Version }
    Ok:=true;
    for i:=0 to 3 do Ok:=Ok and (r[i]=ParCfgID[i]);
    if Ok then
    begin { Paritätsprüfung }
      p:=0;
      for i:=0 to 73+SizeOf(TFontString)+SizeOf(TXTitleString) do
        p:=p xor ord(r[i]);
      Ok:=RStr2Int(3,76+SizeOf(TFontString)+SizeOf(TXTitleString)-2,i);
      Ok:=Ok and (p=i);
    end;
    { aktueller Drucker (4) }
    if Ok then
    begin
      Ok:=RStr2Int(3,4,i);
      if Ok then Result.CurrentPrinter:=i;
    end;
    { Skalierung (7) }
    if Ok then
    begin
      Ok:=RStr2Int(1,7,i);
      if Ok then Result.Scaling:=TScaling(i);
    end;
    { Linker Rand (8) }
    if Ok then
    begin
      Ok:=RStr2Int(8,8,i);
      if Ok then Result.MarginLeft:=i;
    end;
    { Oberer Rand (16) }
    if Ok then
    begin
      Ok:=RStr2Int(8,16,i);
      if Ok then Result.MarginTop:=i;
    end;
    { Rechter Rand (24) }
    if Ok then
    begin
      Ok:=RStr2Int(8,24,i);
      if Ok then Result.MarginRight:=i;
    end;
    { Unterer Rand (32) }
    if Ok then
    begin
      Ok:=RStr2Int(8,32,i);
      if Ok then Result.MarginBottom:=i;
    end;
    { Font.Charset (40) }
    if Ok then
    begin
      Ok:=RStr2Int(3,40,i);
      if Ok then Result.Font_Charset:=i;
    end;
    { Font.Color (43) }
    if Ok then
    begin
      Ok:=RStr2Int(11,43,i);
      if Ok then Result.Font_Color:=i;
    end;
    { Font.Height (54) }
    if Ok then
    begin
      Ok:=RStr2Int(4,54,i);
      if Ok then Result.Font_Height:=i;
    end;
    { Font.Name (58) (ohne Längenbyte, Rest mit #127 aufgefüllt) }
    if Ok then
    begin
      Result.Font_Name:=EmptyStr;
      i:=0;
      while (i<SizeOf(TFontString)) and (r[58+i]<#127) do
      begin
        Result.Font_Name:=Result.Font_Name+r[58+i];
        inc(i);
      end;
      Ok:=true;
    end;
    { Font.Pitch (58+SizeOf(TFontString)-1) }
    if Ok then
    begin
      Ok:=RStr2Int(1,58+SizeOf(TFontString)-1,i);
      if Ok then Result.Font_Pitch:=TFontPitch(i);
    end;
    { Font.Size (59+SizeOf(TFontString)-1) }
    if Ok then
    begin
      Ok:=RStr2Int(4,59+SizeOf(TFontString)-1,i);
      if Ok then Result.Font_Size:=i;
    end;
    { Font.Style (63+SizeOf(TFontString)-1) (1 Zeichen) }
    if Ok then
    begin
      i:=ord(r[63+SizeOf(TFontString)-1]) and $0F;
      Result.Font_Style:=[];
      if i and $01>0 then Result.Font_Style:=Result.Font_Style + [fsBold];
      if i and $02>0 then Result.Font_Style:=Result.Font_Style + [fsItalic];
      if i and $04>0 then Result.Font_Style:=Result.Font_Style + [fsUnderline];
      if i and $08>0 then Result.Font_Style:=Result.Font_Style + [fsStrikeOut];
    end;
    { Copies (64+SizeOf(TFontString)-1) }
    if Ok then
    begin
      Ok:=RStr2Int(5,64+SizeOf(TFontString)-1,i);
      if Ok then Result.Copies:=i;
    end;
    { Orientation (69+SizeOf(TFontString)-1) }
    if Ok then
    begin
      Ok:=RStr2Int(1,69+SizeOf(TFontString)-1,i);
      if Ok then Result.Orientation:=TXPrinterOrientation(i);
    end;
    { Angle 10 (70+SizeOf(TFontString)-1) }
    if Ok then
    begin
      Ok:=RStr2Int(5,70+SizeOf(TFontString)-1,i);
      if Ok then Result.Angle10:=i;
    end;
    { TextRotation }
    if Ok then
    begin
      Ok:=RStr2Int(1,75+SizeOf(TFontString)-1,i);
      if Ok then Result.TextRotation:=i>0;
    end;
    { Title (76+SizeOf(TFontString)-1) (ohne Längenbyte, Rest mit #127 aufgefüllt) }
    if Ok then
    begin
      Result.Title:=EmptyStr;
      i:=0;
      while (i<SizeOf(TXTitleString)) and (r[76+SizeOf(TFontString)-1+i]<#127) do
      begin
        Result.Title:=Result.Title+r[76+SizeOf(TFontString)-1+i];
        inc(i);
      end;
      Ok:=true;
    end;
    Result.Valid:=Ok;
  end;
end;

procedure TXPrint.SyncIndex;
// Diese Methode sollte aufgerufen werden, wenn Printer.PrinterIndex an der
// Komponente vorbei geändert wurde.
// Die Druckerinformationen werden neu geladen
begin
  if fPrintersInstalled>0 then DriverParams;   { Druckerparameter ermitteln }
end;

procedure Register;
{ Registrierung der Komponente }
begin
  //RegisterComponents('Toolbox',[TXPrint]);
end;

end.

