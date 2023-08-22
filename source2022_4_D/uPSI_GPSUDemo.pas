unit uPSI_GPSUDemo;
{
   formtemplate
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
  TPSImport_GPSUDemo = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TFDemo(CL: TPSPascalCompiler);
procedure SIRegister_GPSUDemo(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TFDemo(CL: TPSRuntimeClassImporter);
procedure RIRegister_GPSUDemo(CL: TPSRuntimeClassImporter);

//procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Variants
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,GPS
  ,StdCtrls
  ,CPortCtl
  ,ExtCtrls
  ,GPSUDemo
  ;
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_GPSUDemo]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFDemo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TFDemo') do
  with CL.AddClassN(CL.FindClass('TForm'),'TFDemo') do begin
    RegisterProperty('GPS1', 'TGPS', iptrw);
    RegisterProperty('BTN_Start', 'TButton', iptrw);
    RegisterProperty('LBL_Latitude', 'TLabel', iptrw);
    RegisterProperty('LBL_Longitude', 'TLabel', iptrw);
    RegisterProperty('LBL_Altitude', 'TLabel', iptrw);
    RegisterProperty('LBL_NbSats', 'TLabel', iptrw);
    RegisterProperty('LBL_NbSatsUsed', 'TLabel', iptrw);
    RegisterProperty('SHP_Connected', 'TShape', iptrw);
    RegisterProperty('CMB_COMPort', 'TComComboBox', iptrw);
    RegisterProperty('LBL_COMPort', 'TLabel', iptrw);
    RegisterProperty('CHK_Valid', 'TCheckBox', iptrw);
    RegisterProperty('LBL_Speed', 'TLabel', iptrw);
    RegisterProperty('LBL_Time', 'TLabel', iptrw);
    RegisterProperty('LBL_GPSSpeed', 'TGPSSpeed', iptrw);
    RegisterProperty('LBL_Course', 'TLabel', iptrw);
    RegisterProperty('GPSSpeed1', 'TGPSSpeed', iptrw);
    RegisterProperty('GPSSpeed2', 'TGPSSpeed', iptrw);
    RegisterProperty('GPStoGPX1', 'TGPStoGPX', iptrw);
    RegisterProperty('GPSSatellitesPosition1', 'TGPSSatellitesPosition', iptrw);
    RegisterProperty('GPSCompass1', 'TGPSCompass', iptrw);
    RegisterProperty('GPSSatellitesReception1', 'TGPSSatellitesReception', iptrw);
    RegisterMethod('Procedure CMB_COMPortChange( Sender : TObject)');
    RegisterMethod('Procedure BTN_StartClick( Sender : TObject)');
    RegisterMethod('Procedure GPS1AfterOpen( Sender : TObject)');
    RegisterMethod('Procedure GPS1AfterClose( Sender : TObject)');
    RegisterMethod('Procedure GPS1GPSDatasChange( Sender : TObject; GPSDatas : TGPSDatas)');
    RegisterMethod('Procedure CHK_ValidClick( Sender : TObject)');
    RegisterMethod('Procedure FormClose( Sender : TObject; var Action : TCloseAction)');
    RegisterMethod('Procedure Button1Click( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GPSUDemo(CL: TPSPascalCompiler);
begin
  SIRegister_TFDemo(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TFDemoGPSSatellitesReception1_W(Self: TFDemo; const T: TGPSSatellitesReception);
Begin Self.GPSSatellitesReception1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPSSatellitesReception1_R(Self: TFDemo; var T: TGPSSatellitesReception);
Begin T := Self.GPSSatellitesReception1; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPSCompass1_W(Self: TFDemo; const T: TGPSCompass);
Begin Self.GPSCompass1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPSCompass1_R(Self: TFDemo; var T: TGPSCompass);
Begin T := Self.GPSCompass1; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPSSatellitesPosition1_W(Self: TFDemo; const T: TGPSSatellitesPosition);
Begin Self.GPSSatellitesPosition1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPSSatellitesPosition1_R(Self: TFDemo; var T: TGPSSatellitesPosition);
Begin T := Self.GPSSatellitesPosition1; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPStoGPX1_W(Self: TFDemo; const T: TGPStoGPX);
Begin Self.GPStoGPX1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPStoGPX1_R(Self: TFDemo; var T: TGPStoGPX);
Begin T := Self.GPStoGPX1; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPSSpeed2_W(Self: TFDemo; const T: TGPSSpeed);
Begin Self.GPSSpeed2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPSSpeed2_R(Self: TFDemo; var T: TGPSSpeed);
Begin T := Self.GPSSpeed2; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPSSpeed1_W(Self: TFDemo; const T: TGPSSpeed);
Begin Self.GPSSpeed1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPSSpeed1_R(Self: TFDemo; var T: TGPSSpeed);
Begin T := Self.GPSSpeed1; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Course_W(Self: TFDemo; const T: TLabel);
Begin Self.LBL_Course := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Course_R(Self: TFDemo; var T: TLabel);
Begin T := Self.LBL_Course; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_GPSSpeed_W(Self: TFDemo; const T: TGPSSpeed);
Begin Self.LBL_GPSSpeed := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_GPSSpeed_R(Self: TFDemo; var T: TGPSSpeed);
Begin T := Self.LBL_GPSSpeed; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Time_W(Self: TFDemo; const T: TLabel);
Begin Self.LBL_Time := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Time_R(Self: TFDemo; var T: TLabel);
Begin T := Self.LBL_Time; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Speed_W(Self: TFDemo; const T: TLabel);
Begin Self.LBL_Speed := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Speed_R(Self: TFDemo; var T: TLabel);
Begin T := Self.LBL_Speed; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoCHK_Valid_W(Self: TFDemo; const T: TCheckBox);
Begin Self.CHK_Valid := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoCHK_Valid_R(Self: TFDemo; var T: TCheckBox);
Begin T := Self.CHK_Valid; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_COMPort_W(Self: TFDemo; const T: TLabel);
Begin Self.LBL_COMPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_COMPort_R(Self: TFDemo; var T: TLabel);
Begin T := Self.LBL_COMPort; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoCMB_COMPort_W(Self: TFDemo; const T: TComComboBox);
Begin Self.CMB_COMPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoCMB_COMPort_R(Self: TFDemo; var T: TComComboBox);
Begin T := Self.CMB_COMPort; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoSHP_Connected_W(Self: TFDemo; const T: TShape);
Begin Self.SHP_Connected := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoSHP_Connected_R(Self: TFDemo; var T: TShape);
Begin T := Self.SHP_Connected; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_NbSatsUsed_W(Self: TFDemo; const T: TLabel);
Begin Self.LBL_NbSatsUsed := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_NbSatsUsed_R(Self: TFDemo; var T: TLabel);
Begin T := Self.LBL_NbSatsUsed; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_NbSats_W(Self: TFDemo; const T: TLabel);
Begin Self.LBL_NbSats := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_NbSats_R(Self: TFDemo; var T: TLabel);
Begin T := Self.LBL_NbSats; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Altitude_W(Self: TFDemo; const T: TLabel);
Begin Self.LBL_Altitude := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Altitude_R(Self: TFDemo; var T: TLabel);
Begin T := Self.LBL_Altitude; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Longitude_W(Self: TFDemo; const T: TLabel);
Begin Self.LBL_Longitude := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Longitude_R(Self: TFDemo; var T: TLabel);
Begin T := Self.LBL_Longitude; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Latitude_W(Self: TFDemo; const T: TLabel);
Begin Self.LBL_Latitude := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoLBL_Latitude_R(Self: TFDemo; var T: TLabel);
Begin T := Self.LBL_Latitude; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoBTN_Start_W(Self: TFDemo; const T: TButton);
Begin Self.BTN_Start := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoBTN_Start_R(Self: TFDemo; var T: TButton);
Begin T := Self.BTN_Start; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPS1_W(Self: TFDemo; const T: TGPS);
Begin Self.GPS1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFDemoGPS1_R(Self: TFDemo; var T: TGPS);
Begin T := Self.GPS1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFDemo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFDemo) do
  begin
    RegisterPropertyHelper(@TFDemoGPS1_R,@TFDemoGPS1_W,'GPS1');
    RegisterPropertyHelper(@TFDemoBTN_Start_R,@TFDemoBTN_Start_W,'BTN_Start');
    RegisterPropertyHelper(@TFDemoLBL_Latitude_R,@TFDemoLBL_Latitude_W,'LBL_Latitude');
    RegisterPropertyHelper(@TFDemoLBL_Longitude_R,@TFDemoLBL_Longitude_W,'LBL_Longitude');
    RegisterPropertyHelper(@TFDemoLBL_Altitude_R,@TFDemoLBL_Altitude_W,'LBL_Altitude');
    RegisterPropertyHelper(@TFDemoLBL_NbSats_R,@TFDemoLBL_NbSats_W,'LBL_NbSats');
    RegisterPropertyHelper(@TFDemoLBL_NbSatsUsed_R,@TFDemoLBL_NbSatsUsed_W,'LBL_NbSatsUsed');
    RegisterPropertyHelper(@TFDemoSHP_Connected_R,@TFDemoSHP_Connected_W,'SHP_Connected');
    RegisterPropertyHelper(@TFDemoCMB_COMPort_R,@TFDemoCMB_COMPort_W,'CMB_COMPort');
    RegisterPropertyHelper(@TFDemoLBL_COMPort_R,@TFDemoLBL_COMPort_W,'LBL_COMPort');
    RegisterPropertyHelper(@TFDemoCHK_Valid_R,@TFDemoCHK_Valid_W,'CHK_Valid');
    RegisterPropertyHelper(@TFDemoLBL_Speed_R,@TFDemoLBL_Speed_W,'LBL_Speed');
    RegisterPropertyHelper(@TFDemoLBL_Time_R,@TFDemoLBL_Time_W,'LBL_Time');
    RegisterPropertyHelper(@TFDemoLBL_GPSSpeed_R,@TFDemoLBL_GPSSpeed_W,'LBL_GPSSpeed');
    RegisterPropertyHelper(@TFDemoLBL_Course_R,@TFDemoLBL_Course_W,'LBL_Course');
    RegisterPropertyHelper(@TFDemoGPSSpeed1_R,@TFDemoGPSSpeed1_W,'GPSSpeed1');
    RegisterPropertyHelper(@TFDemoGPSSpeed2_R,@TFDemoGPSSpeed2_W,'GPSSpeed2');
    RegisterPropertyHelper(@TFDemoGPStoGPX1_R,@TFDemoGPStoGPX1_W,'GPStoGPX1');
    RegisterPropertyHelper(@TFDemoGPSSatellitesPosition1_R,@TFDemoGPSSatellitesPosition1_W,'GPSSatellitesPosition1');
    RegisterPropertyHelper(@TFDemoGPSCompass1_R,@TFDemoGPSCompass1_W,'GPSCompass1');
    RegisterPropertyHelper(@TFDemoGPSSatellitesReception1_R,@TFDemoGPSSatellitesReception1_W,'GPSSatellitesReception1');
    RegisterMethod(@TFDemo.CMB_COMPortChange, 'CMB_COMPortChange');
    RegisterMethod(@TFDemo.BTN_StartClick, 'BTN_StartClick');
    RegisterMethod(@TFDemo.GPS1AfterOpen, 'GPS1AfterOpen');
    RegisterMethod(@TFDemo.GPS1AfterClose, 'GPS1AfterClose');
    RegisterMethod(@TFDemo.GPS1GPSDatasChange, 'GPS1GPSDatasChange');
    RegisterMethod(@TFDemo.CHK_ValidClick, 'CHK_ValidClick');
    RegisterMethod(@TFDemo.FormClose, 'FormClose');
    RegisterMethod(@TFDemo.Button1Click, 'Button1Click');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GPSUDemo(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFDemo(CL);
end;

 
 
{ TPSImport_GPSUDemo }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GPSUDemo.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GPSUDemo(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GPSUDemo.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GPSUDemo(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
