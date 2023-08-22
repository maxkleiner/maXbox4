(******************************************************************************)
(* Copyright © 2010, PLAIS Lionel All rights reserved.                        *)
(*                                                                            *)
(* Redistribution and use in source and binary forms, with or without         *)
(* modification, are permitted provided that the following conditions are     *)
(* met:                                                                       *)
(*                                                                            *)
(* Redistributions of source code must retain the above copyright notice,     *)
(* this list of conditions and the following disclaimer. Redistributions in   *)
(* binary form must reproduce the above copyright notice, this list of        *)
(* conditions and the following disclaimer in the documentation and/or        *)
(* other materials provided with the distribution. Neither the name of the    *)
(* ILP-WEB NETWORK nor the names of its contributors may be used to endorse   *)
(* or promote products derived from this software without specific prior      *)
(* written permission.                                                        *)
(*                                                                            *)
(* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS    *)
(* IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED      *)
(* TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A            *)
(* PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT         *)
(* HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,     *)
(* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED   *)
(* TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR     *)
(* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF     *)
(* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING       *)
(* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS         *)
(* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.               *)
(******************************************************************************)
(******************************************************************************)
(* File: GPS.pas                                                              *)
(* Component(s): TGPS                                                         *)
(* Components for the management of the NMEA 0183 frames received on COM      *)
(* ports.                                                                     *)
(* Copyright © 2010 ILP-WEB NETWORK                                           *)
(* Author(s) : PLAIS Lionel (lionel.plais@ilp-web.net)                        *)
(******************************************************************************)
unit GPS;

{$D+}

interface

uses
  SysUtils, Classes, Windows, {CPortTypes,} CPort, Math, StrUtils, ConvUtils,
  StdConvs, DateUtils, Forms, StdCtrls, Controls, Graphics, Imglist, Messages,
  GPX;

const
  // Maximum number of satellites referenced
  MAX_SATS = 12;
  // Characters starting and ending frames NMEA 0183
  MSG_START: String = '$';
  MSG_STOP: String = '*';
  // Default seconds between two segments
  SEC_BETWEEN_SEG = 5;

type
  // Satellite properties
  TSatellite = record
    Identification: Shortint;
    Elevation: 0..90;
    Azimut: Smallint;
    SignLevel: Smallint;
  end;
  // Array of satellites referenced
  TSatellites = array[1..MAX_SATS] of TSatellite;
  TGPSSatEvent = procedure(Sender: TObject; NbSat, NbSatUse: Shortint;
    Sats: TSatellites) of object;

  // GPS status informations
  TGPSDatas = record
    Latitude: Double;
    Longitude: Double;
    HeightAboveSea: Double;
    Speed: Double;
    UTCTime: TDateTime;
    Valid: Boolean;
    NbrSats: Shortint;
    NbrSatsUsed: Shortint;
    Course: Double;
  end;
  TGPSDatasEvent = procedure(Sender: TObject; GPSDatas: TGPSDatas) of object;

  // NMEA 0185's messages used
  TMsgGP = (
    msgGP,    // Unknown message
    msgGPGGA, // Global Positioning System Fix Data
    msgGPGLL, // Geographic position, Latitude and Longitude
    msgGPGSV, // Satellites in view
    msgGPRMA, // Recommended minimum specific GPS/Transit data Loran C
    msgGPRMC, // Recommended minimum specific GPS/Transit data
    msgGPZDA  // Date and time 
    );

  // Speed units
  TSpeedUnit = (suKilometre, suMile, suNauticalMile);

  // GPS componants links
  TGPSLink = class
  private
    FOnSatellitesChange: TGPSSatEvent;
    FOnGPSDatasChange: TGPSDatasEvent;
    FOnAfterOpen: TNotifyEvent;
    FOnAfterClose: TNotifyEvent;
  public
    property OnSatellitesChange: TGPSSatEvent
      read FOnSatellitesChange write FOnSatellitesChange;
    property OnGPSDatasChange: TGPSDatasEvent
      read FOnGPSDatasChange write FOnGPSDatasChange;
    property OnAfterOpen: TNotifyEvent read FOnAfterOpen write FOnAfterOpen;
    property OnAfterClose: TNotifyEvent read FOnAfterClose write FOnAfterClose;
  end;

  // The GPS base componant
  TCustomGPS = class (TComponent)
  private
    // COM Port components
    FCOMPort: TComPort;
    FCOMDataPacket: TComDataPacket;

    // State of the TGPS component
    FConnected: Boolean;

    // COM Port parameters
    FPort: TPort;
    FBaudRate: TBaudRate;
    FDataBits: TDataBits;
    FStopBits: TStopBits;
    FParity: TComParity;
    FFlowControl: TComFlowControl;

    // GPS informations
    FSatellites: TSatellites;
    FGPSDatas: TGPSDatas;

    // Componants links
    FLinks: TList;
    FHasLink: Boolean;

    // Notifications
    FOnSatellitesChange: TGPSSatEvent;
    FOnGPSDatasChange: TGPSDatasEvent;
    FOnAfterOpen: TNotifyEvent;
    FOnAfterClose: TNotifyEvent;
    procedure CallOnSatellitesChange();
    procedure CallOnGPSDatasChange();

    procedure SetConnected(const Value: Boolean);

    procedure SetPort(const Value: TPort);
    procedure SetBaudRate(const Value: TBaudRate);
    procedure SetDataBits(const Value: TDataBits);
    procedure SetStopBits(const Value: TStopBits);
    procedure SetParity(const Value: TComParity);
    procedure SetFlowControl(const Value: TComFlowControl);

    // Packets interpreting
    procedure PacketRecv(Sender: TObject; const Str: String);

    // COM Port connection
    procedure COMPortAfterConnect(Sender: TObject);
    procedure COMPortAfterDisconnect(Sender: TObject);

    // Componants links
    function HasLink(): Boolean;
  protected
    procedure DoOnSatellitesChange(NbSat, NbSatUse: Shortint;
      Sats: TSatellites); dynamic;
    procedure DoOnGPSDatasChange(GPSDatas: TGPSDatas); dynamic;
    procedure DoAfterClose(); dynamic;
    procedure DoAfterOpen(); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure Open();
    procedure Close();
    procedure ShowSetupDialog();

    // Componants links
    procedure RegisterLink(AGPSLink: TGPSLink);
    procedure UnRegisterLink(AGPSLink: TGPSLink);

    // GPS informations
    property Satellites: TSatellites read FSatellites;
    property GPSDatas: TGPSDatas read FGPSDatas;
  published
    // State of the TGPS component
    property Connected: Boolean
      read FConnected write SetConnected default False;

    // COM Port parameters
    property Port: TPort read FPort write SetPort;
    property BaudRate: TBaudRate read FBaudRate write SetBaudRate;
    property DataBits: TDataBits read FDataBits write SetDataBits;
    property StopBits: TStopBits read FStopBits write SetStopBits;
    property Parity: TComParity read FParity write SetParity;
    property FlowControl: TComFlowControl
      read FFlowControl write SetFlowControl;

    // Notifications
    property OnSatellitesChange: TGPSSatEvent
      read FOnSatellitesChange write FOnSatellitesChange;
    property OnGPSDatasChange: TGPSDatasEvent
      read FOnGPSDatasChange write FOnGPSDatasChange;
    property OnAfterOpen: TNotifyEvent read FOnAfterOpen write FOnAfterOpen;
    property OnAfterClose: TNotifyEvent read FOnAfterClose write FOnAfterClose;
  end;

  TGPS = class (TCustomGPS)
    // State of the TGPS component
    property Connected;

    // COM Port parameters
    property Port;
    property BaudRate;
    property DataBits;
    property StopBits;
    property Parity;
    property FlowControl;

    // Notifications
    property OnSatellitesChange;
    property OnGPSDatasChange;
    property OnAfterOpen;
    property OnAfterClose;
  end;

  TGPStoGPX = class (TComponent)
  private
    FActive: Boolean;
    FGPS: TCustomGPS;
    FGPSLink: TGPSLink;
    FFileName: String;
    FGPXFile: IXMLGpxType;
    FGPXTrack: IXMLTrkType;
    FGPXSeg: IXMLTrksegType;
    LastFixTime: TDateTime;
    procedure SetActive(const Value: Boolean);
    procedure SetGPS(const Value: TCustomGPS);
    procedure SetFileName(const Value: String);
    procedure GPSChange(Sender: TObject; GPSDatas: TGPSDatas);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure Connect();
    procedure Disconnect();
  published
    property Active: Boolean read FActive write SetActive;
    property GPS: TCustomGPS read FGPS write SetGPS;
    property FileName: String read FFileName write SetFileName;
  end;

  TGPSSpeed = class (TGraphicControl)
  private
    FGPS: TCustomGPS;
    FGPSLink: TGPSLink;
    FSpeedUnit: TSpeedUnit;

    procedure SetGPS(const Value: TCustomGPS);
    procedure SetSpeedUnit(const Value: TSpeedUnit);
    procedure SpeedChange(Sender: TObject; GPSDatas: TGPSDatas);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Paint(); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  published
    property GPS: TCustomGPS read FGPS write SetGPS;
    property Font;
    property SpeedUnit: TSpeedUnit
      read FSpeedUnit write SetSpeedUnit default suKilometre;
  end;

  TGPSSatellitesPosition = class (TGraphicControl)
  private
    FGPS: TCustomGPS;
    FGPSLink: TGPSLink;
    ImgSats: TBitmap;
    IML_Sats: TImageList;
    FCardFont: TFont;
    FSatFont: TFont;
    FPen: TPen;
    FBackgroundColor: TColor;

    procedure SetGPS(const Value: TCustomGPS);
    procedure SetCardFont(const Value: TFont);
    procedure SetSatFont(const Value: TFont);
    procedure SetPen(const Value: TPen);
    procedure SetBackgroundColor(const Value: TColor);

    procedure SatChange(Sender: TObject; NbSat, NbSatUse: Shortint;
      Sats: TSatellites);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Paint(); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  published
    procedure StyleChanged(Sender: TObject);
    property GPS: TCustomGPS read FGPS write SetGPS;
    property CardFont: TFont read FCardFont write SetCardFont;
    property SatFont: TFont read FSatFont write SetSatFont;
    property Pen: TPen read FPen write SetPen;
    property BackgroundColor: TColor read FBackgroundColor
      write SetBackgroundColor default clWindow;
  end;

  TGPSSatellitesReception = class (TGraphicControl)
  private
    FGPS: TCustomGPS;
    FGPSLink: TGPSLink;
    FBackColor: TColor;
    FBorderColor: TColor;
    FForeColor: TColor;

    ImgSats: TBitmap;

    procedure SetGPS(const Value: TCustomGPS);
    procedure SetBackColor(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetForeColor(const Value: TColor);
    procedure SatChange(Sender: TObject; NbSat, NbSatUse: Shortint;
      Sats: TSatellites);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Paint(); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  published
    procedure StyleChanged(Sender: TObject);
    property GPS: TCustomGPS read FGPS write SetGPS;
    property Font;
    property BackColor: TColor
      read FBackColor write SetBackColor stored True default clWindow;
    property BorderColor: TColor
      read FBorderColor write SetBorderColor stored True default clBlack;
    property ForeColor: TColor
      read FForeColor write SetForeColor stored True default clHotLight;
  end;

  TGPSCompass = class (TGraphicControl)
  private
    FGPS: TCustomGPS;
    FGPSLink: TGPSLink;
    ImgCompass: TBitmap;
    FCardFont: TFont;
    FPen: TPen;
    FBrush: TBrush;
    FBackgroundColor: TColor;

    procedure SetGPS(const Value: TCustomGPS);
    procedure SetCardFont(const Value: TFont);
    procedure SetPen(const Value: TPen);
    procedure SetBrush(const Value: TBrush);
    procedure SetBackgroundColor(const Value: TColor);

    procedure SatChange(Sender: TObject; NbSat, NbSatUse: Shortint;
      Sats: TSatellites);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Paint(); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  published
    procedure StyleChanged(Sender: TObject);
    property GPS: TCustomGPS read FGPS write SetGPS;
    property CardFont: TFont read FCardFont write SetCardFont;
    property Pen: TPen read FPen write SetPen;
    property Brush: TBrush read FBrush write SetBrush;
    property BackgroundColor: TColor read FBackgroundColor
      write SetBackgroundColor default clWindow;
  end;

procedure Register();

// Return the NMEA 0185's message type by its name
function IndexMsgGP(StrMsgGP: String): TMsgGP;
// Convert an angle string to its value
function StrCoordToAngle(Point: Char; Angle: String): Double;
// Convert a time string to its value
function StrTimeToTime(const Time: String): TDateTime;
// Convert an integer string to its value
function StrToInteger(const Str: String): Integer;
// Convert an real string to its value
function StrToReal(const Str: String): Extended;

function RotatePoint(Angle: Double; Ct, Pt: TPoint): TPoint;

procedure LoadRessource(RessourceName: String; ImageList: TImageList);

const
  // NMEA 0185's messages used
  LstMsgDiffGP: array[msgGPGGA..msgGPZDA] of String = (
    'GGA', // Global Positioning System Fix Data
    'GLL', // Geographic position, Latitude and Longitude
    'GSV', // Satellites in view
    'RMA', // Recommended minimum specific GPS/Transit data Loran C
    'RMC', // Recommended minimum specific GPS/Transit data
    'ZDA'  // Date and time
    );

var
  // Number of satellites in view
  SatRef: Smallint = 0;

implementation

{$R GPSIcons.res}

procedure Register();
begin
  RegisterComponents('GPS',
    [TGPS, TGPStoGPX, TGPSSpeed, TGPSSatellitesPosition,
    TGPSSatellitesReception, TGPSCompass]);
end;

constructor TCustomGPS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Create componants links list
  FLinks := TList.Create();

  // Create ComPort component
  FCOMPort := TComPort.Create(Nil);

  // Get back the ComPort parameters
  with FCOMPort do
  begin
    Port := FPort;
    FBaudRate := BaudRate;
    FDataBits := DataBits;
    FStopBits := StopBits;
    FParity := Parity;
    FFlowControl := FlowControl;

    // Implements triggers
    OnAfterOpen := COMPortAfterConnect;
    OnAfterClose := COMPortAfterDisconnect;
  end;

  // Create data packet's manager component
  FCOMDataPacket := TComDataPacket.Create(Nil);
  with FCOMDataPacket do
  begin
    // Specify characters starting and ending frames NMEA 0183
    StartString := MSG_START;
    StopString  := MSG_STOP;

    // Implements trigger for frames receiving
    OnPacket := PacketRecv;

    // Specify the ComPort used
    ComPort := FCOMPort;
  end;
end;

destructor TCustomGPS.Destroy();
begin
  // Close le ComPort connexion (trying…)
  Close();

  // Free components
  FCOMPort.Free();
  FCOMDataPacket.Free();

  inherited Destroy;

  // Destroy componants links list
  FLinks.Free();
end;

procedure TCustomGPS.Open();
begin
  // Open the ComPort connection
  FCOMPort.Open();
  FConnected := FCOMPort.Connected;
end;

procedure TCustomGPS.Close();
begin
  // Close the ComPort connection
  FCOMPort.Close();
  FConnected := FCOMPort.Connected;
end;

procedure TCustomGPS.ShowSetupDialog();
begin
  // Show the ComPort setup dialog
  FCOMPort.ShowSetupDialog();
end;

// Componants links
function TCustomGPS.HasLink(): Boolean;
var
  i: Integer;
  GPSLink: TGPSLink;
begin
  Result := False;
  // Examine links
  if FLinks.Count > 0 then
    for i := 0 to FLinks.Count - 1 do
    begin
      GPSLink := TGPSLink(FLinks[i]);
      if Assigned(GPSLink.OnSatellitesChange) then
        Result := True;
    end;
end;

procedure TCustomGPS.RegisterLink(AGPSLink: TGPSLink);
begin
  if FLinks.IndexOf(Pointer(AGPSLink)) > -1 then
    raise Exception.Create('Link (un)registration failed')
  else
    FLinks.Add(Pointer(AGPSLink));
  FHasLink := HasLink();
end;

procedure TCustomGPS.UnRegisterLink(AGPSLink: TGPSLink);
begin
  if FLinks.IndexOf(Pointer(AGPSLink)) = -1 then
    raise Exception.Create('Link (un)registration failed')
  else
    FLinks.Remove(Pointer(AGPSLink));
  FHasLink := HasLink();
end;

procedure TCustomGPS.CallOnSatellitesChange();
var
  i: Integer;
  GPSLink: TGPSLink;
begin
  // Trigger the satellites changing procedure
  DoOnSatellitesChange(FGPSDatas.NbrSats, FGPSDatas.NbrSatsUsed, FSatellites);

  for i := 0 to FLinks.Count - 1 do
  begin
    GPSLink := TGPSLink(FLinks[i]);
    if Assigned(GPSLink.OnSatellitesChange) then
      GPSLink.OnSatellitesChange(Self, FGPSDatas.NbrSats,
        FGPSDatas.NbrSatsUsed, FSatellites);
  end;
end;

procedure TCustomGPS.CallOnGPSDatasChange();
var
  i: Integer;
  GPSLink: TGPSLink;
begin
  // Trigger the GPS datas changing procedure
  DoOnGPSDatasChange(FGPSDatas);

  for i := 0 to FLinks.Count - 1 do
  begin
    GPSLink := TGPSLink(FLinks[i]);
    if Assigned(GPSLink.OnGPSDatasChange) then
      GPSLink.OnGPSDatasChange(Self, FGPSDatas);
  end;
end;

procedure TCustomGPS.SetConnected(const Value: Boolean);
begin
  // Open or close the connection if the value change
  if not ((csDesigning in ComponentState) or (csLoading in
    ComponentState)) then
  begin
    if Value <> FConnected then
      if Value then
        Open()
      else
        Close();
  end
  else
    FConnected := Value;
end;

procedure TCustomGPS.SetPort(const Value: TPort);
begin
  FCOMPort.Port := Value;
  FPort := FCOMPort.Port;
end;

procedure TCustomGPS.SetBaudRate(const Value: TBaudRate);
begin
  FCOMPort.BaudRate := Value;
  FBaudRate := FCOMPort.BaudRate;
end;

procedure TCustomGPS.SetDataBits(const Value: TDataBits);
begin
  FCOMPort.DataBits := Value;
  FDataBits := FCOMPort.DataBits;
end;

procedure TCustomGPS.SetStopBits(const Value: TStopBits);
begin
  FCOMPort.StopBits := Value;
  FStopBits := FCOMPort.StopBits;
end;

procedure TCustomGPS.SetParity(const Value: TComParity);
begin
  FCOMPort.Parity := Value;
  FParity := FCOMPort.Parity;
end;

procedure TCustomGPS.SetFlowControl(const Value: TComFlowControl);
begin
  FCOMPort.FlowControl := Value;
  FFlowControl := FCOMPort.FlowControl;
end;

procedure TCustomGPS.PacketRecv(Sender: TObject; const Str: String);
var
  Resultat: TStringList;
  MsgCorrect, TypeMsg: String;
  i: Integer;
begin
  Resultat := TStringList.Create();
  try
    // Split the message into different parts.
    MsgCorrect := AnsiReplaceStr('$' + Str, ',,', ' , , ');
    Resultat.Text := AnsiReplaceStr(
      LeftStr(MsgCorrect, Length(MsgCorrect) - 1), ',', #13#10);

    // Get the message type
    TypeMsg := MidStr(Resultat[0], 4, 3);

    // Retrieves data based on message type
    case IndexMsgGP(TypeMsg) of
      msgGPGGA:
      begin
        with FGPSDatas do
        begin
          UTCTime := StrTimeToTime(Resultat[1]);
          Latitude := StrCoordToAngle(Resultat[3][1], Resultat[2]);
          Longitude := StrCoordToAngle(Resultat[5][1], Resultat[4]);
          HeightAboveSea := StrToReal(Resultat[9]);
          NbrSatsUsed := StrToInteger(Resultat[7]);
        end;

        // Trigger change
        CallOnGPSDatasChange();
      end;
      msgGPGLL:
      begin
        with FGPSDatas do
        begin
          UTCTime := StrTimeToTime(Resultat[5]);
          Latitude := StrCoordToAngle(Resultat[2][1], Resultat[1]);
          Longitude := StrCoordToAngle(Resultat[4][1], Resultat[3]);
          Valid := AnsiSameText(Resultat[6], 'A');
        end;

        // Trigger change
        CallOnGPSDatasChange();
      end;
      msgGPGSV:
      begin
        // If there are satellites in referenced in the frame
        if Resultat.Count < 4 then
          FGPSDatas.NbrSats := 0
        else
          FGPSDatas.NbrSats := StrToInteger(Resultat[3]);

        if Resultat[2] = '1' then
        begin
          SatRef := 0;

          // Initiate satellites values
          for i := 1 to 12 do
            with FSatellites[i] do
            begin
              Identification := 0;
              Elevation := 0;
              Azimut := 0;
              SignLevel := 0;
            end;
        end;

        i := 4;

        // For each referenced satellites
        while (i + 4) <= (Resultat.Count) do
        begin
          with FSatellites[SatRef + 1] do
          begin
            Identification := StrToInteger(Resultat[i]);
            Elevation := StrToInteger(Resultat[i + 1]);
            Azimut := StrToInteger(Resultat[i + 2]);
            if Resultat[i + 3] <> '' then
              SignLevel := StrToInteger(Resultat[i + 3])
            else
              SignLevel := 0;
          end;
          Inc(i, 4);
          Inc(SatRef);
        end;

        // Trigger change
        CallOnSatellitesChange();
      end;
      msgGPRMA:
      begin
        with FGPSDatas do
        begin
          Latitude := StrCoordToAngle(Resultat[3][1], Resultat[2]);
          Longitude := StrCoordToAngle(Resultat[5][1], Resultat[4]);
          Valid := AnsiSameText(Resultat[1], 'A');
          Speed := Convert(StrToReal(Resultat[6]), duNauticalMiles,
            duKilometers);
        end;

        // Trigger change
        CallOnGPSDatasChange();
      end;
      msgGPRMC:
      begin
        with FGPSDatas do
        begin
          UTCTime := StrTimeToTime(Resultat[1]);
          Latitude := StrCoordToAngle(Resultat[4][1], Resultat[3]);
          Longitude := StrCoordToAngle(Resultat[6][1], Resultat[5]);
          Valid := AnsiSameText(Resultat[2], 'A');
          Speed := Convert(StrToReal(Resultat[7]), duNauticalMiles,
            duKilometers);
          Course := StrToReal(Resultat[8]);
        end;

        // Trigger change
        CallOnGPSDatasChange();
      end;
      msgGPZDA:
      begin
        FGPSDatas.UTCTime := StrTimeToTime(Resultat[1]);

        // Trigger change
        CallOnGPSDatasChange();
      end;
    end;
  finally
    Resultat.Free();
  end;
end;

procedure TCustomGPS.COMPortAfterConnect(Sender: TObject);
begin
  FConnected := True;
  DoAfterOpen();
end;

procedure TCustomGPS.COMPortAfterDisconnect(Sender: TObject);
begin
  FConnected := False;
  DoAfterClose();
end;

procedure TCustomGPS.DoOnSatellitesChange(NbSat, NbSatUse: Shortint;
  Sats: TSatellites);
begin
  if Assigned(FOnSatellitesChange) then
    FOnSatellitesChange(Self, NbSat, NbSatUse, Sats);
end;

procedure TCustomGPS.DoOnGPSDatasChange(GPSDatas: TGPSDatas);
begin
  if Assigned(FOnGPSDatasChange) then
    FOnGPSDatasChange(Self, GPSDatas);
end;

procedure TCustomGPS.DoAfterClose();
begin
  if Assigned(FOnAfterClose) then
    FOnAfterClose(Self);
end;

procedure TCustomGPS.DoAfterOpen();
begin
  if Assigned(FOnAfterOpen) then
    FOnAfterOpen(Self);
end;

constructor TGPStoGPX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LastFixTime := 0;
  FGPSLink := TGPSLink.Create();
  FGPSLink.OnGPSDatasChange := Nil;
  FGPSLink.OnGPSDatasChange := GPSChange;
end;

destructor TGPStoGPX.Destroy();
begin
  if Active then
    Disconnect();
  GPS := Nil;
  FGPSLink.Free();
  inherited Destroy();
end;

procedure TGPStoGPX.Connect();
begin
  if not FileExists(FFileName) then
  begin
    FGPXFile := Newgpx();
    with FGPXFile do
    begin
      Version := '1.1';
      if Application.Title <> '' then
        Creator := Application.Title
      else
        Creator := ExtractFileName(Application.ExeName);
      with Metadata do
      begin
        Name := FFileName;
        Author.Name := 'PLAIS Lionel';
        Author.Email.Id := 'lionel.plais';
        Author.Email.Domain := 'ilp-web.net';
        Author.Link.Text := 'Site Web de PLAIS Lionel';
        Author.Link.Href := 'http://www.ilp-web.net/';
      end;
    end;
  end
  else
    FGPXFile := Loadgpx(FFileName);

  FGPXTrack := FGPXFile.Trk.Add();
  FGPXTrack.Name := 'Track: ' + DateTimeToStr(Now());

  FGPXSeg := FGPXTrack.Trkseg.Add();

  FActive := True;
end;

procedure TGPStoGPX.Disconnect();
var
  XMLFile: TextFile;
begin
  if Assigned(FGPXFile) then
  begin
    AssignFile(XMLFile, FFileName);
    Rewrite(XMLFile);
    Write(XMLFile, FGPXFile.XML);
    CloseFile(XMLFile);
  end;

  FActive := False;
end;

procedure TGPStoGPX.SetActive(const Value: Boolean);
begin
  if not ((csDesigning in ComponentState) or (csLoading in
    ComponentState)) then
  begin
    if Value <> FActive then
      if Value then
        Connect()
      else
        Disconnect();
  end
  else
    FActive := Value;
end;

procedure TGPStoGPX.SetGPS(const Value: TCustomGPS);
begin
  if FGPS <> Value then
  begin
    if Assigned(FGPS) then
      FGPS.UnRegisterLink(FGPSLink);
    FGPS := Value;
    if Assigned(FGPS) then
    begin
      FGPS.FreeNotification(Self);
      FGPS.RegisterLink(FGPSLink);
    end;
  end;
end;

procedure TGPStoGPX.SetFileName(const Value: String);
begin
  if Active then
    Disconnect();
  FFileName := Value;
end;

procedure TGPStoGPX.GPSChange(Sender: TObject; GPSDatas: TGPSDatas);
var
  ID: Integer;
  OldLat, OldLon: Double;
  FormatDate: TFormatSettings;
  GPSTime: TDateTime;
  TZICurrent: TTimeZoneInformation;
begin
  if Active and GPSDatas.Valid then
  begin
    GetLocaleFormatSettings($0409, FormatDate);
    FormatDate.ShortDateFormat := 'yyyy-mm-dd"T"hh:nn:ss"Z"';
    ID := FGPXSeg.Trkpt.Count;
    if ID > 0 then
      with FGPXSeg.Trkpt.Items[ID - 1] do
      begin
        OldLat := StrToFloat(Lat, FormatDate);
        OldLon := StrToFloat(Lon, FormatDate);
      end
    else
    begin
      OldLat := 0;
      OldLon := 0;
    end;

    if not (SameValue(GPSDatas.Latitude, OldLat, 0.00001) or
      SameValue(GPSDatas.Longitude, OldLon, 0.00001)) and not
      (IsZero(GPSDatas.Latitude) or IsZero(GPSDatas.Longitude)) then
    begin
      GetTimeZoneInformation(TZICurrent);

      GPSTime := Date() + GPSDatas.UTCTime + TZICurrent.Bias;

      if (SecondsBetween(GPSTime, LastFixTime) > SEC_BETWEEN_SEG) and
        (LastFixTime > 0) then
      begin
        FGPXSeg := FGPXTrack.Trkseg.Add();
        FGPXTrack.Name := 'Track: ' + DateTimeToStr(Now());
      end;

      with FGPXSeg.Trkpt.Add() do
      begin
        Ele := FloatToStr(GPSDatas.HeightAboveSea, FormatDate);
        Time := DateToStr(GPSTime, FormatDate);
        Lat := FloatToStrF(GPSDatas.Latitude, ffFixed, 8, 6, FormatDate);
        Lon := FloatToStrF(GPSDatas.Longitude, ffFixed, 8, 6, FormatDate);
        Sat := GPSDatas.NbrSatsUsed;
        AddChild('speed').NodeValue := GPSDatas.Speed;

        LastFixTime := GPSTime;
      end;
    end;
  end;
end;

procedure TGPStoGPX.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FGPS) and (Operation = opRemove) then
    GPS := Nil;
end;

constructor TGPSSpeed.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGPSLink := TGPSLink.Create();
  FGPSLink.OnGPSDatasChange := Nil;
  FGPSLink.OnGPSDatasChange := SpeedChange;
end;

destructor TGPSSpeed.Destroy();
begin
  GPS := Nil;
  FGPSLink.Free();
  inherited Destroy();
end;

procedure TGPSSpeed.SetGPS(const Value: TCustomGPS);
begin
  if FGPS <> Value then
  begin
    if Assigned(FGPS) then
      FGPS.UnRegisterLink(FGPSLink);
    FGPS := Value;
    if Assigned(FGPS) then
    begin
      FGPS.FreeNotification(Self);
      FGPS.RegisterLink(FGPSLink);
    end;
  end;
end;

procedure TGPSSpeed.SetSpeedUnit(const Value: TSpeedUnit);
begin
  if FSpeedUnit <> Value then
  begin
    FSpeedUnit := Value;
    Refresh();
  end;
end;

procedure TGPSSpeed.SpeedChange(Sender: TObject; GPSDatas: TGPSDatas);
var
  Rect: TRect;
begin
  Canvas.Font := Font;
  Canvas.Brush.Color := Parent.Brush.Color;
  case SpeedUnit of
    suKilometre:
      Text := Format('%f km/h', [GPSDatas.Speed]);
    suMile:
      Text := Format('%f mi/h',
        [Convert(GPSDatas.Speed, duKilometers, duMiles)]);
    suNauticalMile:
      Text := Format('%f kn',
        [Convert(GPSDatas.Speed, duKilometers, duNauticalMiles)]);
  end;
  Rect := ClientRect;
  DrawText(Canvas.Handle, Pchar(Text), Length(Text), Rect,
    DT_CENTER + DT_VCENTER + DT_SINGLELINE + DT_END_ELLIPSIS);
end;

procedure TGPSSpeed.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FGPS) and (Operation = opRemove) then
    GPS := Nil;
end;

procedure TGPSSpeed.Paint();
var
  OrigBrushStyle: TBrushStyle;
  Rect: TRect;
  Speed: Double;
begin
  inherited;

  if csDesigning in ComponentState then
    with Canvas do
    begin
      OrigBrushStyle := Brush.Style;
      Brush.Style := bsClear;

      Pen.Color := clBackground;
      Pen.Style := psDash;
      MoveTo(0, 0);
      LineTo(Width - 1, 0);
      LineTo(Width - 1, Height - 1);
      LineTo(0, Height - 1);
      LineTo(0, 0);

      Brush.Style := OrigBrushStyle;
    end;

  Canvas.Font := Font;
  Canvas.Brush.Color := Parent.Brush.Color;
  if Assigned(GPS) then
    Speed := GPS.GPSDatas.Speed
  else
    Speed := 0;
  case SpeedUnit of
    suKilometre:
      Text := Format('%f km/h', [Speed]);
    suMile:
      Text := Format('%f mi/h', [Convert(Speed, duKilometers, duMiles)]);
    suNauticalMile:
      Text := Format('%f kn', [Convert(Speed, duKilometers, duNauticalMiles)]);
  end;
  Rect := ClientRect;
  DrawText(Canvas.Handle, Pchar(Text), Length(Text), Rect,
    DT_CENTER + DT_VCENTER + DT_SINGLELINE + DT_END_ELLIPSIS);
end;

constructor TGPSSatellitesPosition.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ImgSats := TBitmap.Create();
  IML_Sats := TImageList.Create(Self);
  IML_Sats.Height := 8;
  IML_Sats.Width := 8;
  IML_Sats.Clear();

  FCardFont := TFont.Create();
  with FCardFont do
  begin
    OnChange := StyleChanged;
    Size := 9;
    Color := $CC9966;
    Style := [fsBold];
    Name := 'Tahoma';
  end;

  FSatFont := TFont.Create();
  with FSatFont do
  begin
    OnChange := StyleChanged;
    Size := 8;
    Style := [];
    Color := clBlue;
    Name := 'Tahoma';
  end;

  FPen := TPen.Create();
  with FPen do
  begin
    OnChange := StyleChanged;
    Color := $CC9966;
    Width := 2;
  end;

  BackgroundColor := clWindow;

  LoadRessource('SatOn', IML_Sats);
  LoadRessource('SatOff', IML_Sats);

  FGPSLink := TGPSLink.Create();
  FGPSLink.OnSatellitesChange := Nil;
  FGPSLink.OnSatellitesChange := SatChange;
end;

destructor TGPSSatellitesPosition.Destroy();
begin
  FCardFont.Free();
  FSatFont.Free();
  FPen.Free();
  IML_Sats.Free();
  ImgSats.Free();
  FGPSLink.Free();
  inherited Destroy();
end;

procedure TGPSSatellitesPosition.SetGPS(const Value: TCustomGPS);
begin
  if FGPS <> Value then
  begin
    if Assigned(FGPS) then
      FGPS.UnRegisterLink(FGPSLink);
    FGPS := Value;
    if Assigned(FGPS) then
    begin
      FGPS.FreeNotification(Self);
      FGPS.RegisterLink(FGPSLink);
    end;
  end;
end;

procedure TGPSSatellitesPosition.SetCardFont(const Value: TFont);
begin
  FCardFont.Assign(Value);
end;

procedure TGPSSatellitesPosition.SetSatFont(const Value: TFont);
begin
  FSatFont.Assign(Value);
end;

procedure TGPSSatellitesPosition.SetPen(const Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TGPSSatellitesPosition.SetBackgroundColor(const Value: TColor);
begin
  if Value <> FBackgroundColor then
  begin
    FBackgroundColor := Value;
    Repaint();
  end;
end;

procedure TGPSSatellitesPosition.SatChange(Sender: TObject;
  NbSat, NbSatUse: Shortint; Sats: TSatellites);
begin
  Repaint();
end;

procedure TGPSSatellitesPosition.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FGPS) and (Operation = opRemove) then
    GPS := Nil;
end;

procedure TGPSSatellitesPosition.Paint();
var
  Rect1, Rect2, Rect3: TRect;
  i, LargTxt, HautTxt: Integer;
  Centre, PosSat: TPoint;
  Rapport: Double;
begin
  inherited;

  with Self do
  begin
    ImgSats.Width := Width;
    ImgSats.Height := Height;
    Rect1 := ClientRect;
    Rect2 := Rect(Width div 4, Height div 4, (Width div 4) *
      3, (Height div 4) * 3);
    Rect3 := Rect(Width div 2 - 4, Height div 2 - 4, Width div
      2 + 4, Height div 2 + 4);
    Centre := Point(Width div 2, Height div 2);
    Rapport := (Width / 180);
  end;

  ImgSats.Canvas.Pen := Pen;
  with ImgSats.Canvas do
  begin
    Brush.Color := BackgroundColor;
    FillRect(Self.ClientRect);

    Font := FCardFont;
    Brush.Style := bsClear;

    Ellipse(Rect1);
    Ellipse(Rect2);
    Ellipse(Rect3);

    LargTxt := (Self.Width - TextWidth('N')) div 2;
    TextOut(LargTxt, 4, 'N');
    LargTxt := (Self.Width - TextWidth('S')) div 2;
    HautTxt := Self.Height - TextHeight('S') - 4;
    TextOut(LargTxt, HautTxt, 'S');
    HautTxt := (Self.Height - TextHeight('E')) div 2;
    TextOut(4, HautTxt, 'E');
    LargTxt := Self.Width - TextWidth('O') - 4;
    HautTxt := (Self.Height - TextHeight('O')) div 2;
    TextOut(LargTxt, HautTxt, 'O');

    if Assigned(GPS) then
      for i := 1 to MAX_SATS do
        if GPS.Satellites[i].Identification > 0 then
        begin
          PosSat := RotatePoint(GPS.Satellites[i].Azimut - 90,
            Centre, Point(Round((-GPS.Satellites[i].Elevation + 90) *
            Rapport), 0));

          if GPS.Satellites[i].SignLevel > 0 then
            IML_Sats.Draw(ImgSats.Canvas, PosSat.X - 4, PosSat.Y -
              4, 0, dsTransparent, itImage)
          else
            IML_Sats.Draw(ImgSats.Canvas, PosSat.X - 4, PosSat.Y -
              4, 1, dsTransparent, itImage);

          Font := FSatFont;
          TextOut(PosSat.X + 2, PosSat.Y + 2,
            IntToStr(GPS.Satellites[i].Identification));
        end;
  end;
  Self.Canvas.Draw(0, 0, ImgSats);
end;

procedure TGPSSatellitesPosition.StyleChanged(Sender: TObject);
begin
  Invalidate();
end;

constructor TGPSSatellitesReception.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ImgSats := TBitmap.Create();

  FBackColor := clWindow;
  FBorderColor := clBlack;
  FForeColor := clHotLight;

  FGPSLink := TGPSLink.Create();
  FGPSLink.OnSatellitesChange := Nil;
  FGPSLink.OnSatellitesChange := SatChange;
end;

destructor TGPSSatellitesReception.Destroy();
begin
  ImgSats.Free();
  GPS := Nil;
  FGPSLink.Free();

  inherited Destroy();
end;

procedure TGPSSatellitesReception.SetGPS(const Value: TCustomGPS);
begin
  if FGPS <> Value then
  begin
    if Assigned(FGPS) then
      FGPS.UnRegisterLink(FGPSLink);
    FGPS := Value;
    if Assigned(FGPS) then
    begin
      FGPS.FreeNotification(Self);
      FGPS.RegisterLink(FGPSLink);
    end;
  end;
end;

procedure TGPSSatellitesReception.SetBackColor(const Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Repaint();
  end;
end;

procedure TGPSSatellitesReception.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Repaint();
  end;
end;

procedure TGPSSatellitesReception.SetForeColor(const Value: TColor);
begin
  if FForeColor <> Value then
  begin
    FForeColor := Value;
    Repaint();
  end;
end;

procedure TGPSSatellitesReception.SatChange(Sender: TObject;
  NbSat, NbSatUse: Shortint; Sats: TSatellites);
begin
  Repaint();
end;

procedure TGPSSatellitesReception.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FGPS) and (Operation = opRemove) then
    GPS := Nil;
end;

procedure TGPSSatellitesReception.Paint();
var
  i, Larg, Haut: Integer;
  RectGauge: TRect;
begin
  inherited;

  ImgSats.Width := Self.Width;
  ImgSats.Height := Self.Height;

  Larg := Self.Width - 20;
  Haut := Self.Height div MAX_SATS;

  ImgSats.Canvas.Font := Self.Font;
  ImgSats.Canvas.Brush.Color := FBackColor;
  ImgSats.Canvas.FillRect(Self.ClientRect);

  for i := 1 to MAX_SATS do
  begin
    RectGauge := Rect(20, Haut * (i - 1) + 2, Larg + 20, Haut * i - 2);

    with ImgSats.Canvas do
    begin
      Pen.Color := FBorderColor;
      Brush.Color := FBackColor;
      Rectangle(RectGauge);

      if not (csDesigning in ComponentState) and Assigned(GPS) then
      begin
        Brush.Style := bsClear;
        TextOut(5, Haut * (i - 1), IntToStr(GPS.Satellites[i].Identification));

        with RectGauge do begin
        Right := Round((Larg / 50) * GPS.Satellites[i].SignLevel) + 20;
        Left:=Left+1;
        Top:=Top+1;
        Bottom:=Bottom-1;
        end;

        Brush.Color := FForeColor;
        FillRect(RectGauge);
      end
      else
        TextOut(5, Haut * (i - 1), '0');
    end;
  end;

  Self.Canvas.Draw(0, 0, ImgSats);
end;

procedure TGPSSatellitesReception.StyleChanged(Sender: TObject);
begin
  Invalidate();
end;

constructor TGPSCompass.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ImgCompass := TBitmap.Create();

  FCardFont := TFont.Create();
  with FCardFont do
  begin
    OnChange := StyleChanged;
    Size := 9;
    Color := clRed;
    Style := [fsBold];
    Name := 'Tahoma';
  end;

  FPen := TPen.Create();
  with FPen do
  begin
    OnChange := StyleChanged;
    Color := $CC9966;
    Width := 2;
  end;

  FBrush := TBrush.Create();
  with FBrush do
  begin
    OnChange := StyleChanged;
    Color := $FFCC99;
  end;

  BackgroundColor := clWindow;

  FGPSLink := TGPSLink.Create();
  FGPSLink.OnSatellitesChange := Nil;
  FGPSLink.OnSatellitesChange := SatChange;
end;

destructor TGPSCompass.Destroy();
begin
  FCardFont.Free();
  FPen.Free();
  FBrush.Free();
  ImgCompass.Free();
  FGPSLink.Free();

  inherited Destroy();
end;

procedure TGPSCompass.SetGPS(const Value: TCustomGPS);
begin
  if FGPS <> Value then
  begin
    if Assigned(FGPS) then
      FGPS.UnRegisterLink(FGPSLink);
    FGPS := Value;
    if Assigned(FGPS) then
    begin
      FGPS.FreeNotification(Self);
      FGPS.RegisterLink(FGPSLink);
    end;
  end;
end;

procedure TGPSCompass.SetCardFont(const Value: TFont);
begin
  FCardFont.Assign(Value);
end;

procedure TGPSCompass.SetPen(const Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TGPSCompass.SetBrush(const Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TGPSCompass.SetBackgroundColor(const Value: TColor);
begin
  if Value <> FBackgroundColor then
  begin
    FBackgroundColor := Value;
    Repaint();
  end;
end;

procedure TGPSCompass.SatChange(Sender: TObject; NbSat, NbSatUse: Shortint;
  Sats: TSatellites);
begin
  Repaint();
end;

procedure TGPSCompass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FGPS) and (Operation = opRemove) then
    GPS := Nil;
end;

procedure TGPSCompass.Paint();
var
  Larg, Haut: Integer;
  PtCentre: TPoint;
  Points: array[0..4] of TPoint;
  Texte:  String;
  LargTxt, HautTxt: Integer;
  Angle:  Double;
begin
  inherited;

  ImgCompass.Width := Self.Width;
  ImgCompass.Height := Self.Height;

  PtCentre := Point(Self.Width div 2, Self.Height div 2);

  Larg := Self.Width div 3;
  Haut := Self.Height div 3;

  if Assigned(GPS) then
    Angle := GPS.GPSDatas.Course
  else
    Angle := 0;

  Points[0] := RotatePoint(Angle, PtCentre, Point(0, 0));
  Points[1] := RotatePoint(Angle, PtCentre, Point(-Larg, +Haut));
  Points[2] := RotatePoint(Angle, PtCentre, Point(0, -Haut));
  Points[3] := RotatePoint(Angle, PtCentre, Point(+Larg, +Haut));
  Points[4] := RotatePoint(Angle, PtCentre, Point(0, 0));

  ImgCompass.Canvas.Pen := Pen;
  ImgCompass.Canvas.Brush.Color := BackgroundColor;
  ImgCompass.Canvas.FillRect(ClientRect);
  ImgCompass.Canvas.Brush := Brush;
  with ImgCompass.Canvas do
  begin
    Polygon(Points);

    Font := CardFont;
    Brush.Style := bsClear;

    Texte := Format('%.0f°', [Angle]);
    HautTxt := (Self.Height - TextHeight(Texte)) div 2;
    LargTxt := (Self.Width - TextWidth(Texte)) div 2;
    Font.Color := clLtGray;
    TextOut(LargTxt + 1, HautTxt + 1, Texte);
    Font.Color := CardFont.Color;
    TextOut(LargTxt, HautTxt, Texte);
  end;
  Self.Canvas.Draw(0, 0, ImgCompass);
end;

procedure TGPSCompass.StyleChanged(Sender: TObject);
begin
  Invalidate();
end;

// Return the NMEA 0185's message type by its name
function IndexMsgGP(StrMsgGP: String): TMsgGP;
var
  i: TMsgGP;
begin
  Result := msgGP;
  for i := msgGPGGA to msgGPZDA do
    if AnsiSameText(LstMsgDiffGP[i], StrMsgGP) then
    begin
      Result := i;
      Break;
    end;
end;

// Convert an angle string to its value
function StrCoordToAngle(Point: Char; Angle: String): Double;
var
  PosPt: Shortint;
  FrmNmb: TFormatSettings;
  DegresStr, MinutsStr: String;
  Degres: Smallint;
  Minuts: Double;
begin
  // -> http://msdn.microsoft.com/library/0h88fahh
  GetLocaleFormatSettings($0409, FrmNmb);

  if Trim(Angle) <> '' then
  begin
    try
      PosPt := Pos(FrmNmb.DecimalSeparator, Angle);

      DegresStr := LeftStr(Angle, PosPt - 3);
      Degres := StrToInt(DegresStr);
      MinutsStr := MidStr(Angle, PosPt - 2, Length(Angle));
      Minuts := StrToFloat(MinutsStr, FrmNmb);
      Minuts := Minuts * (10 / 6);

      Result := Degres + (Minuts / 100);
    except
      Result := 0;
    end;

    // Put the sign
    if Point in ['S', 'W'] then
      Result := -Result;
  end
  else
    Result := 0;
end;

// Convert a time string to its value
function StrTimeToTime(const Time: String): TDateTime;
var
  TimeCorr: String;
begin
  if Trim(Time) <> '' then
  begin
    TimeCorr := Format('%s:%s:%s', [LeftStr(Time, 2),
      MidStr(Time, 3, 2), MidStr(Time, 5, 2)]);
    try
      Result := StrToTime(TimeCorr);
    except
      Result := 0;
    end;
  end
  else
    Result := 0;
end;

// Convert an integer string to its value
function StrToInteger(const Str: String): Integer;
begin
  try
    if Trim(Str) <> '' then
      try
        Result := StrToInt(Trim(Str));
      except
        Result := 0;
      end
    else
      Result := 0;
  except
    Result := 0;
  end;
end;

// Convert an real string to its value
function StrToReal(const Str: String): Extended;
var
  FrmNmb: TFormatSettings;
begin
  try
    // -> http://msdn.microsoft.com/library/0h88fahh
    GetLocaleFormatSettings($0409, FrmNmb);
    if Trim(Str) <> '' then
      try
        Result := StrToFloat(Trim(Str), FrmNmb);
      except
        Result := 0;
      end
    else
      Result := 0;
  except
    Result := 0;
  end;
end;

function RotatePoint(Angle: Double; Ct, Pt: TPoint): TPoint;
var
  AngG: Single;
begin
  AngG := (Pi * Angle) / 180;

  Pt.X := Pt.X + Ct.X;
  Pt.Y := Pt.Y + Ct.Y;

  with Result do
  begin
    X := Round((Pt.X - Ct.X) * Cos(AngG) - (Pt.Y - Ct.Y) * Sin(AngG) + Ct.X);
    Y := Round((Pt.X - Ct.X) * Sin(AngG) + (Pt.Y - Ct.Y) * Cos(AngG) + Ct.Y);
  end;
end;

procedure LoadRessource(RessourceName: String; ImageList: TImageList);
var
  Image: TBitmap;
begin
  Image := TBitmap.Create;
  try
    Image.LoadFromResourceName(HInstance, RessourceName);
    ImageList.Add(Image, Image);
  finally
    Image.Free;
  end;
end;

end.
