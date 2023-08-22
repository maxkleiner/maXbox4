unit uPSI_GPS;
{
  also GPS form
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_GPS = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGPSCompass(CL: TPSPascalCompiler);
procedure SIRegister_TGPSSatellitesReception(CL: TPSPascalCompiler);
procedure SIRegister_TGPSSatellitesPosition(CL: TPSPascalCompiler);
procedure SIRegister_TGPSSpeed(CL: TPSPascalCompiler);
procedure SIRegister_TGPStoGPX(CL: TPSPascalCompiler);
procedure SIRegister_TGPS(CL: TPSPascalCompiler);
procedure SIRegister_TCustomGPS(CL: TPSPascalCompiler);
procedure SIRegister_TGPSLink(CL: TPSPascalCompiler);
procedure SIRegister_GPS(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GPS_Routines(S: TPSExec);
procedure RIRegister_TGPSCompass(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGPSSatellitesReception(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGPSSatellitesPosition(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGPSSpeed(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGPStoGPX(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGPS(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomGPS(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGPSLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_GPS(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  //,CPortTypes
  ,CPort
  ,Math
  ,StrUtils
  ,ConvUtils
  ,StdConvs
  ,DateUtils
  ,Forms
  ,StdCtrls
  ,Controls
  ,Graphics
  ,Imglist
  ,Messages
  ,GPX
  ,GPS
  ;
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_GPS]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGPSCompass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TGPSCompass') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TGPSCompass') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
      RegisterMethod('Procedure StyleChanged( Sender : TObject)');
    RegisterProperty('GPS', 'TCustomGPS', iptrw);
    RegisterProperty('CardFont', 'TFont', iptrw);
    RegisterProperty('Pen', 'TPen', iptrw);
    RegisterProperty('Brush', 'TBrush', iptrw);
    RegisterProperty('BackgroundColor', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGPSSatellitesReception(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TGPSSatellitesReception') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TGPSSatellitesReception') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
      RegisterMethod('Procedure StyleChanged( Sender : TObject)');
    RegisterProperty('GPS', 'TCustomGPS', iptrw);
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('BorderColor', 'TColor', iptrw);
    RegisterProperty('ForeColor', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGPSSatellitesPosition(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TGPSSatellitesPosition') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TGPSSatellitesPosition') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
      RegisterMethod('Procedure StyleChanged( Sender : TObject)');
    RegisterProperty('GPS', 'TCustomGPS', iptrw);
    RegisterProperty('CardFont', 'TFont', iptrw);
    RegisterProperty('SatFont', 'TFont', iptrw);
    RegisterProperty('Pen', 'TPen', iptrw);
    RegisterProperty('BackgroundColor', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGPSSpeed(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TGPSSpeed') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TGPSSpeed') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
      RegisterProperty('GPS', 'TCustomGPS', iptrw);
    RegisterProperty('SpeedUnit', 'TSpeedUnit', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGPStoGPX(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TGPStoGPX') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TGPStoGPX') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Connect( )');
    RegisterMethod('Procedure Disconnect( )');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('GPS', 'TCustomGPS', iptrw);
    RegisterProperty('FileName', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGPS(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomGPS', 'TGPS') do
  with CL.AddClassN(CL.FindClass('TCustomGPS'),'TGPS') do begin
    registerpublishedproperties;
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomGPS(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomGPS') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomGPS') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Open( )');
    RegisterMethod('Procedure Close( )');
    RegisterMethod('Procedure ShowSetupDialog( )');
    RegisterMethod('Procedure RegisterLink( AGPSLink : TGPSLink)');
    RegisterMethod('Procedure UnRegisterLink( AGPSLink : TGPSLink)');
    RegisterProperty('Satellites', 'TSatellites', iptr);
    RegisterProperty('GPSDatas', 'TGPSDatas', iptr);
    RegisterProperty('Connected', 'Boolean', iptrw);
    RegisterProperty('Port', 'TPort', iptrw);
    RegisterProperty('BaudRate', 'TBaudRate', iptrw);
    RegisterProperty('DataBits', 'TDataBits', iptrw);
    RegisterProperty('StopBits', 'TStopBits', iptrw);
    RegisterProperty('Parity', 'TComParity', iptrw);
    RegisterProperty('FlowControl', 'TComFlowControl', iptrw);
    RegisterProperty('OnSatellitesChange', 'TGPSSatEvent', iptrw);
    RegisterProperty('OnGPSDatasChange', 'TGPSDatasEvent', iptrw);
    RegisterProperty('OnAfterOpen', 'TNotifyEvent', iptrw);
    RegisterProperty('OnAfterClose', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGPSLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TGPSLink') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TGPSLink') do begin
    RegisterProperty('OnSatellitesChange', 'TGPSSatEvent', iptrw);
    RegisterProperty('OnGPSDatasChange', 'TGPSDatasEvent', iptrw);
    RegisterProperty('OnAfterOpen', 'TNotifyEvent', iptrw);
    RegisterProperty('OnAfterClose', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GPS(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MAX_SATS','LongInt').SetInt( 12);
 CL.AddConstantN('GPSMSG_START','String').SetString( '$');
 CL.AddConstantN('GPSMSG_STOP','String').SetString( '*');
 CL.AddConstantN('SEC_BETWEEN_SEG','LongInt').SetInt( 5);
  CL.AddTypeS('TSatellite', 'record Identification : Shortint; Elevation : Shor'
   +'tint; Azimut : Smallint; SignLevel : Smallint; end');
  CL.AddTypeS('TSatellites', 'array[1..12] of TSatellite');
 //TSatellites = array[1..MAX_SATS] of TSatellite;

  CL.AddTypeS('TGPSSatEvent', 'Procedure ( Sender : TObject; NbSat, NbSatUse: Shortint; Sats : TSatellites)');
  CL.AddTypeS('TGPSDatas', 'record Latitude : Double; Longitude : Double; Heigh'
   +'tAboveSea : Double; Speed : Double; UTCTime : TDateTime; Valid : Boolean; '
   +'NbrSats : Shortint; NbrSatsUsed : Shortint; Course : Double; end');
  CL.AddTypeS('TGPSDatasEvent', 'Procedure ( Sender : TObject; GPSDatas : TGPSDatas)');
  CL.AddTypeS('TMsgGP', '( msgGP, msgGPGGA, msgGPGLL, msgGPGSV, msgGPRMA, msgGPRMC, msgGPZDA )');
  CL.AddTypeS('TSpeedUnit', '( suKilometre, suMile, suNauticalMile )');
  SIRegister_TGPSLink(CL);
  SIRegister_TCustomGPS(CL);
  SIRegister_TGPS(CL);
  SIRegister_TGPStoGPX(CL);
  SIRegister_TGPSSpeed(CL);
  SIRegister_TGPSSatellitesPosition(CL);
  SIRegister_TGPSSatellitesReception(CL);
  SIRegister_TGPSCompass(CL);
 //CL.AddDelphiFunction('Procedure Register( )');
 CL.AddDelphiFunction('Function IndexMsgGP( StrMsgGP : String) : TMsgGP');
 CL.AddDelphiFunction('Function StrCoordToAngle( Point : Char; Angle : String) : Double');
 CL.AddDelphiFunction('Function StrTimeToTime( const Time : String) : TDateTime');
 CL.AddDelphiFunction('Function StrToInteger( const Str : String) : Integer');
 CL.AddDelphiFunction('Function StrToReal( const Str : String) : Extended');
 CL.AddDelphiFunction('Function GPSRotatePoint( Angle : Double; Ct, Pt : TPoint) : TPoint');
 CL.AddDelphiFunction('Procedure LoadRessource( RessourceName : String; ImageList : TImageList)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TGPSCompassBackgroundColor_W(Self: TGPSCompass; const T: TColor);
begin Self.BackgroundColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSCompassBackgroundColor_R(Self: TGPSCompass; var T: TColor);
begin T := Self.BackgroundColor; end;

(*----------------------------------------------------------------------------*)
procedure TGPSCompassBrush_W(Self: TGPSCompass; const T: TBrush);
begin Self.Brush := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSCompassBrush_R(Self: TGPSCompass; var T: TBrush);
begin T := Self.Brush; end;

(*----------------------------------------------------------------------------*)
procedure TGPSCompassPen_W(Self: TGPSCompass; const T: TPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSCompassPen_R(Self: TGPSCompass; var T: TPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TGPSCompassCardFont_W(Self: TGPSCompass; const T: TFont);
begin Self.CardFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSCompassCardFont_R(Self: TGPSCompass; var T: TFont);
begin T := Self.CardFont; end;

(*----------------------------------------------------------------------------*)
procedure TGPSCompassGPS_W(Self: TGPSCompass; const T: TCustomGPS);
begin Self.GPS := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSCompassGPS_R(Self: TGPSCompass; var T: TCustomGPS);
begin T := Self.GPS; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesReceptionForeColor_W(Self: TGPSSatellitesReception; const T: TColor);
begin Self.ForeColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesReceptionForeColor_R(Self: TGPSSatellitesReception; var T: TColor);
begin T := Self.ForeColor; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesReceptionBorderColor_W(Self: TGPSSatellitesReception; const T: TColor);
begin Self.BorderColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesReceptionBorderColor_R(Self: TGPSSatellitesReception; var T: TColor);
begin T := Self.BorderColor; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesReceptionBackColor_W(Self: TGPSSatellitesReception; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesReceptionBackColor_R(Self: TGPSSatellitesReception; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesReceptionGPS_W(Self: TGPSSatellitesReception; const T: TCustomGPS);
begin Self.GPS := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesReceptionGPS_R(Self: TGPSSatellitesReception; var T: TCustomGPS);
begin T := Self.GPS; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesPositionBackgroundColor_W(Self: TGPSSatellitesPosition; const T: TColor);
begin Self.BackgroundColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesPositionBackgroundColor_R(Self: TGPSSatellitesPosition; var T: TColor);
begin T := Self.BackgroundColor; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesPositionPen_W(Self: TGPSSatellitesPosition; const T: TPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesPositionPen_R(Self: TGPSSatellitesPosition; var T: TPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesPositionSatFont_W(Self: TGPSSatellitesPosition; const T: TFont);
begin Self.SatFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesPositionSatFont_R(Self: TGPSSatellitesPosition; var T: TFont);
begin T := Self.SatFont; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesPositionCardFont_W(Self: TGPSSatellitesPosition; const T: TFont);
begin Self.CardFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesPositionCardFont_R(Self: TGPSSatellitesPosition; var T: TFont);
begin T := Self.CardFont; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesPositionGPS_W(Self: TGPSSatellitesPosition; const T: TCustomGPS);
begin Self.GPS := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSatellitesPositionGPS_R(Self: TGPSSatellitesPosition; var T: TCustomGPS);
begin T := Self.GPS; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSpeedSpeedUnit_W(Self: TGPSSpeed; const T: TSpeedUnit);
begin Self.SpeedUnit := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSpeedSpeedUnit_R(Self: TGPSSpeed; var T: TSpeedUnit);
begin T := Self.SpeedUnit; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSpeedGPS_W(Self: TGPSSpeed; const T: TCustomGPS);
begin Self.GPS := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSSpeedGPS_R(Self: TGPSSpeed; var T: TCustomGPS);
begin T := Self.GPS; end;

(*----------------------------------------------------------------------------*)
procedure TGPStoGPXFileName_W(Self: TGPStoGPX; const T: String);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPStoGPXFileName_R(Self: TGPStoGPX; var T: String);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TGPStoGPXGPS_W(Self: TGPStoGPX; const T: TCustomGPS);
begin Self.GPS := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPStoGPXGPS_R(Self: TGPStoGPX; var T: TCustomGPS);
begin T := Self.GPS; end;

(*----------------------------------------------------------------------------*)
procedure TGPStoGPXActive_W(Self: TGPStoGPX; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPStoGPXActive_R(Self: TGPStoGPX; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSOnAfterClose_W(Self: TCustomGPS; const T: TNotifyEvent);
begin Self.OnAfterClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSOnAfterClose_R(Self: TCustomGPS; var T: TNotifyEvent);
begin T := Self.OnAfterClose; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSOnAfterOpen_W(Self: TCustomGPS; const T: TNotifyEvent);
begin Self.OnAfterOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSOnAfterOpen_R(Self: TCustomGPS; var T: TNotifyEvent);
begin T := Self.OnAfterOpen; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSOnGPSDatasChange_W(Self: TCustomGPS; const T: TGPSDatasEvent);
begin Self.OnGPSDatasChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSOnGPSDatasChange_R(Self: TCustomGPS; var T: TGPSDatasEvent);
begin T := Self.OnGPSDatasChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSOnSatellitesChange_W(Self: TCustomGPS; const T: TGPSSatEvent);
begin Self.OnSatellitesChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSOnSatellitesChange_R(Self: TCustomGPS; var T: TGPSSatEvent);
begin T := Self.OnSatellitesChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSFlowControl_W(Self: TCustomGPS; const T: TComFlowControl);
begin Self.FlowControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSFlowControl_R(Self: TCustomGPS; var T: TComFlowControl);
begin T := Self.FlowControl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSParity_W(Self: TCustomGPS; const T: TComParity);
begin Self.Parity := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSParity_R(Self: TCustomGPS; var T: TComParity);
begin T := Self.Parity; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSStopBits_W(Self: TCustomGPS; const T: TStopBits);
begin Self.StopBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSStopBits_R(Self: TCustomGPS; var T: TStopBits);
begin T := Self.StopBits; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSDataBits_W(Self: TCustomGPS; const T: TDataBits);
begin Self.DataBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSDataBits_R(Self: TCustomGPS; var T: TDataBits);
begin T := Self.DataBits; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSBaudRate_W(Self: TCustomGPS; const T: TBaudRate);
begin Self.BaudRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSBaudRate_R(Self: TCustomGPS; var T: TBaudRate);
begin T := Self.BaudRate; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSPort_W(Self: TCustomGPS; const T: TPort);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSPort_R(Self: TCustomGPS; var T: TPort);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSConnected_W(Self: TCustomGPS; const T: Boolean);
begin Self.Connected := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSConnected_R(Self: TCustomGPS; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSGPSDatas_R(Self: TCustomGPS; var T: TGPSDatas);
begin T := Self.GPSDatas; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGPSSatellites_R(Self: TCustomGPS; var T: TSatellites);
begin T := Self.Satellites; end;

(*----------------------------------------------------------------------------*)
procedure TGPSLinkOnAfterClose_W(Self: TGPSLink; const T: TNotifyEvent);
begin Self.OnAfterClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSLinkOnAfterClose_R(Self: TGPSLink; var T: TNotifyEvent);
begin T := Self.OnAfterClose; end;

(*----------------------------------------------------------------------------*)
procedure TGPSLinkOnAfterOpen_W(Self: TGPSLink; const T: TNotifyEvent);
begin Self.OnAfterOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSLinkOnAfterOpen_R(Self: TGPSLink; var T: TNotifyEvent);
begin T := Self.OnAfterOpen; end;

(*----------------------------------------------------------------------------*)
procedure TGPSLinkOnGPSDatasChange_W(Self: TGPSLink; const T: TGPSDatasEvent);
begin Self.OnGPSDatasChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSLinkOnGPSDatasChange_R(Self: TGPSLink; var T: TGPSDatasEvent);
begin T := Self.OnGPSDatasChange; end;

(*----------------------------------------------------------------------------*)
procedure TGPSLinkOnSatellitesChange_W(Self: TGPSLink; const T: TGPSSatEvent);
begin Self.OnSatellitesChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPSLinkOnSatellitesChange_R(Self: TGPSLink; var T: TGPSSatEvent);
begin T := Self.OnSatellitesChange; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GPS_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
 S.RegisterDelphiFunction(@IndexMsgGP, 'IndexMsgGP', cdRegister);
 S.RegisterDelphiFunction(@StrCoordToAngle, 'StrCoordToAngle', cdRegister);
 S.RegisterDelphiFunction(@StrTimeToTime, 'StrTimeToTime', cdRegister);
 S.RegisterDelphiFunction(@StrToInteger, 'StrToInteger', cdRegister);
 S.RegisterDelphiFunction(@StrToReal, 'StrToReal', cdRegister);
 S.RegisterDelphiFunction(@RotatePoint, 'GPSRotatePoint', cdRegister);
 S.RegisterDelphiFunction(@LoadRessource, 'LoadRessource', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGPSCompass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGPSCompass) do begin
    RegisterConstructor(@TGPSCompass.Create, 'Create');
        RegisterMethod(@TGPSCompass.Destroy, 'Free');
    RegisterMethod(@TGPSCompass.StyleChanged, 'StyleChanged');
    RegisterPropertyHelper(@TGPSCompassGPS_R,@TGPSCompassGPS_W,'GPS');
    RegisterPropertyHelper(@TGPSCompassCardFont_R,@TGPSCompassCardFont_W,'CardFont');
    RegisterPropertyHelper(@TGPSCompassPen_R,@TGPSCompassPen_W,'Pen');
    RegisterPropertyHelper(@TGPSCompassBrush_R,@TGPSCompassBrush_W,'Brush');
    RegisterPropertyHelper(@TGPSCompassBackgroundColor_R,@TGPSCompassBackgroundColor_W,'BackgroundColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGPSSatellitesReception(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGPSSatellitesReception) do begin
    RegisterConstructor(@TGPSSatellitesReception.Create, 'Create');
        RegisterMethod(@TGPSSatellitesReception.Destroy, 'Free');
    RegisterMethod(@TGPSSatellitesReception.StyleChanged, 'StyleChanged');
    RegisterPropertyHelper(@TGPSSatellitesReceptionGPS_R,@TGPSSatellitesReceptionGPS_W,'GPS');
    RegisterPropertyHelper(@TGPSSatellitesReceptionBackColor_R,@TGPSSatellitesReceptionBackColor_W,'BackColor');
    RegisterPropertyHelper(@TGPSSatellitesReceptionBorderColor_R,@TGPSSatellitesReceptionBorderColor_W,'BorderColor');
    RegisterPropertyHelper(@TGPSSatellitesReceptionForeColor_R,@TGPSSatellitesReceptionForeColor_W,'ForeColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGPSSatellitesPosition(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGPSSatellitesPosition) do  begin
    RegisterConstructor(@TGPSSatellitesPosition.Create, 'Create');
        RegisterMethod(@TGPSSatellitesPosition.Destroy, 'Free');
    RegisterMethod(@TGPSSatellitesPosition.StyleChanged, 'StyleChanged');
    RegisterPropertyHelper(@TGPSSatellitesPositionGPS_R,@TGPSSatellitesPositionGPS_W,'GPS');
    RegisterPropertyHelper(@TGPSSatellitesPositionCardFont_R,@TGPSSatellitesPositionCardFont_W,'CardFont');
    RegisterPropertyHelper(@TGPSSatellitesPositionSatFont_R,@TGPSSatellitesPositionSatFont_W,'SatFont');
    RegisterPropertyHelper(@TGPSSatellitesPositionPen_R,@TGPSSatellitesPositionPen_W,'Pen');
    RegisterPropertyHelper(@TGPSSatellitesPositionBackgroundColor_R,@TGPSSatellitesPositionBackgroundColor_W,'BackgroundColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGPSSpeed(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGPSSpeed) do begin
    RegisterConstructor(@TGPSSpeed.Create, 'Create');
        RegisterMethod(@TGPSSpeed.Destroy, 'Free');
    RegisterPropertyHelper(@TGPSSpeedGPS_R,@TGPSSpeedGPS_W,'GPS');
    RegisterPropertyHelper(@TGPSSpeedSpeedUnit_R,@TGPSSpeedSpeedUnit_W,'SpeedUnit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGPStoGPX(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGPStoGPX) do begin
    RegisterConstructor(@TGPStoGPX.Create, 'Create');
        RegisterMethod(@TGPStoGPX.Destroy, 'Free');
      RegisterMethod(@TGPStoGPX.Connect, 'Connect');
    RegisterMethod(@TGPStoGPX.Disconnect, 'Disconnect');
    RegisterPropertyHelper(@TGPStoGPXActive_R,@TGPStoGPXActive_W,'Active');
    RegisterPropertyHelper(@TGPStoGPXGPS_R,@TGPStoGPXGPS_W,'GPS');
    RegisterPropertyHelper(@TGPStoGPXFileName_R,@TGPStoGPXFileName_W,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGPS(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGPS) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomGPS(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomGPS) do begin
    RegisterConstructor(@TCustomGPS.Create, 'Create');
        RegisterMethod(@TCustomGPS.Destroy, 'Free');
    RegisterMethod(@TCustomGPS.Open, 'Open');
    RegisterMethod(@TCustomGPS.Close, 'Close');
    RegisterMethod(@TCustomGPS.ShowSetupDialog, 'ShowSetupDialog');
    RegisterMethod(@TCustomGPS.RegisterLink, 'RegisterLink');
    RegisterMethod(@TCustomGPS.UnRegisterLink, 'UnRegisterLink');
    RegisterPropertyHelper(@TCustomGPSSatellites_R,nil,'Satellites');
    RegisterPropertyHelper(@TCustomGPSGPSDatas_R,nil,'GPSDatas');
    RegisterPropertyHelper(@TCustomGPSConnected_R,@TCustomGPSConnected_W,'Connected');
    RegisterPropertyHelper(@TCustomGPSPort_R,@TCustomGPSPort_W,'Port');
    RegisterPropertyHelper(@TCustomGPSBaudRate_R,@TCustomGPSBaudRate_W,'BaudRate');
    RegisterPropertyHelper(@TCustomGPSDataBits_R,@TCustomGPSDataBits_W,'DataBits');
    RegisterPropertyHelper(@TCustomGPSStopBits_R,@TCustomGPSStopBits_W,'StopBits');
    RegisterPropertyHelper(@TCustomGPSParity_R,@TCustomGPSParity_W,'Parity');
    RegisterPropertyHelper(@TCustomGPSFlowControl_R,@TCustomGPSFlowControl_W,'FlowControl');
    RegisterPropertyHelper(@TCustomGPSOnSatellitesChange_R,@TCustomGPSOnSatellitesChange_W,'OnSatellitesChange');
    RegisterPropertyHelper(@TCustomGPSOnGPSDatasChange_R,@TCustomGPSOnGPSDatasChange_W,'OnGPSDatasChange');
    RegisterPropertyHelper(@TCustomGPSOnAfterOpen_R,@TCustomGPSOnAfterOpen_W,'OnAfterOpen');
    RegisterPropertyHelper(@TCustomGPSOnAfterClose_R,@TCustomGPSOnAfterClose_W,'OnAfterClose');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGPSLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGPSLink) do
  begin
    RegisterPropertyHelper(@TGPSLinkOnSatellitesChange_R,@TGPSLinkOnSatellitesChange_W,'OnSatellitesChange');
    RegisterPropertyHelper(@TGPSLinkOnGPSDatasChange_R,@TGPSLinkOnGPSDatasChange_W,'OnGPSDatasChange');
    RegisterPropertyHelper(@TGPSLinkOnAfterOpen_R,@TGPSLinkOnAfterOpen_W,'OnAfterOpen');
    RegisterPropertyHelper(@TGPSLinkOnAfterClose_R,@TGPSLinkOnAfterClose_W,'OnAfterClose');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GPS(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TGPSLink(CL);
  RIRegister_TCustomGPS(CL);
  RIRegister_TGPS(CL);
  RIRegister_TGPStoGPX(CL);
  RIRegister_TGPSSpeed(CL);
  RIRegister_TGPSSatellitesPosition(CL);
  RIRegister_TGPSSatellitesReception(CL);
  RIRegister_TGPSCompass(CL);
end;

 
 
{ TPSImport_GPS }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GPS.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GPS(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GPS.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GPS(ri);
  RIRegister_GPS_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
