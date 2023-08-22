unit uPSI_U_Oscilloscope4;
{
   oscillo code
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
  TPSImport_U_Oscilloscope4 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TOscfrmMain(CL: TPSPascalCompiler);
procedure SIRegister_U_Oscilloscope4(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOscfrmMain(CL: TPSRuntimeClassImporter);
procedure RIRegister_U_Oscilloscope4(CL: TPSRuntimeClassImporter);

procedure Register;

implementation




uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,UWaveIn4
  ,mmsystem
  ,ExtCtrls
  ,ComCtrls
  ,shellApi
  ,Menus
  ,Buttons
  ,ufrmOscilloscope4
  ,ufrmInputControl4
  ,U_Oscilloscope4
  ;


 //type TOscfrmMain =  TfrmMain;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_U_Oscilloscope4]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOscfrmMain(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TOscfrmMain') do
  //with CL.AddClassN(CL.FindClass('TForm'),'TOscfrmMain') do begin
  with CL.AddClassN(CL.FindClass('TForm'),'TOscfrmMain') do begin

    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('SweepEdt', 'TEdit', iptrw);
    RegisterProperty('SweepUD', 'TUpDown', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('TrigLevelBar', 'TTrackBar', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('ScaleLbl', 'TLabel', iptrw);
    RegisterProperty('MainMenu1', 'TMainMenu', iptrw);
    RegisterProperty('File1', 'TMenuItem', iptrw);
    RegisterProperty('menuSaveImage1', 'TMenuItem', iptrw);
    RegisterProperty('N1', 'TMenuItem', iptrw);
    RegisterProperty('menuExit', 'TMenuItem', iptrw);
    RegisterProperty('statustext', 'TPanel', iptrw);
    RegisterProperty('btnRun', 'TSpeedButton', iptrw);
    RegisterProperty('Panel3', 'TPanel', iptrw);
    RegisterProperty('GrpChannel1', 'TGroupBox', iptrw);
    RegisterProperty('Panel5', 'TPanel', iptrw);
    RegisterProperty('Panel6', 'TPanel', iptrw);
    RegisterProperty('grpChannel2', 'TGroupBox', iptrw);
    RegisterProperty('btnDual', 'TSpeedButton', iptrw);
    RegisterProperty('btnTriggCh1', 'TSpeedButton', iptrw);
    RegisterProperty('btnTriggCh2', 'TSpeedButton', iptrw);
    RegisterProperty('btnTrigPositiv', 'TSpeedButton', iptrw);
    RegisterProperty('btnTrigNegativ', 'TSpeedButton', iptrw);
    RegisterProperty('GroupBox1', 'TGroupBox', iptrw);
    RegisterProperty('btnTrigerOn', 'TSpeedButton', iptrw);
    RegisterProperty('trOfsCh1', 'TTrackBar', iptrw);
    RegisterProperty('trOfsCh2', 'TTrackBar', iptrw);
    RegisterProperty('Label5', 'TLabel', iptrw);
    RegisterProperty('Label6', 'TLabel', iptrw);
    RegisterProperty('Label7', 'TLabel', iptrw);
    RegisterProperty('Label8', 'TLabel', iptrw);
    RegisterProperty('upGainCh1', 'TUpDown', iptrw);
    RegisterProperty('upGainCh2', 'TUpDown', iptrw);
    RegisterProperty('edtGainCh1', 'TEdit', iptrw);
    RegisterProperty('edtGainCh2', 'TEdit', iptrw);
    RegisterProperty('GroupBox2', 'TGroupBox', iptrw);
    RegisterProperty('sp11025Sample', 'TSpeedButton', iptrw);
    RegisterProperty('sp22050Sample', 'TSpeedButton', iptrw);
    RegisterProperty('sp44100Sample', 'TSpeedButton', iptrw);
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('Panel4', 'TPanel', iptrw);
    RegisterProperty('frmOscilloscope1', 'TfrmOscilloscope', iptrw);
    RegisterProperty('trStartPos', 'TTrackBar', iptrw);
    RegisterProperty('btnCH1Gnd', 'TSpeedButton', iptrw);
    RegisterProperty('btnCH2Gnd', 'TSpeedButton', iptrw);
    RegisterProperty('Screen1', 'TMenuItem', iptrw);
    RegisterProperty('Color1', 'TMenuItem', iptrw);
    RegisterProperty('menuBlack', 'TMenuItem', iptrw);
    RegisterProperty('MenuGreen', 'TMenuItem', iptrw);
    RegisterProperty('btnExpand2', 'TSpeedButton', iptrw);
    RegisterProperty('btnExpand4', 'TSpeedButton', iptrw);
    RegisterProperty('btnExpand1', 'TSpeedButton', iptrw);
    RegisterProperty('btnExpand8', 'TSpeedButton', iptrw);
    RegisterProperty('Label12', 'TLabel', iptrw);
    RegisterProperty('Data1', 'TMenuItem', iptrw);
    RegisterProperty('MenuData_Time', 'TMenuItem', iptrw);
    RegisterProperty('PageControl1', 'TPageControl', iptrw);
    RegisterProperty('Runsheet', 'TTabSheet', iptrw);
    RegisterProperty('IntroSheet', 'TTabSheet', iptrw);
    RegisterProperty('Memo1', 'TMemo', iptrw);
    RegisterProperty('GroupBox3', 'TGroupBox', iptrw);
    RegisterProperty('Label11', 'TLabel', iptrw);
    RegisterProperty('Label13', 'TLabel', iptrw);
    RegisterProperty('btnGain0', 'TSpeedButton', iptrw);
    RegisterProperty('btnGain1', 'TSpeedButton', iptrw);
    RegisterProperty('btnGain2', 'TSpeedButton', iptrw);
    RegisterProperty('SpectrumBtn', 'TBitBtn', iptrw);
    RegisterProperty('BtnOneFrame', 'TSpeedButton', iptrw);
    RegisterProperty('CalibrateBtn', 'TBitBtn', iptrw);
    RegisterProperty('OnCh1Box', 'TCheckBox', iptrw);
    RegisterProperty('OnCh2Box', 'TCheckBox', iptrw);
    RegisterProperty('StaticText1', 'TStaticText', iptrw);
    RegisterProperty('frmInputControl1', 'TfrmInputControl', iptrw);
    RegisterProperty('GroupBox4', 'TGroupBox', iptrw);
    RegisterProperty('Label9', 'TLabel', iptrw);
    RegisterProperty('UpScaleLight', 'TUpDown', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('upBeamLight', 'TUpDown', iptrw);
    RegisterProperty('Label10', 'TLabel', iptrw);
    RegisterProperty('upFocus', 'TUpDown', iptrw);
    RegisterMethod('Procedure upFocusClick( Sender : TObject; Button : TUDBtnType)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure FormCloseQuery( Sender : TObject; var CanClose : Boolean)');
    RegisterMethod('Procedure SweepEdtChange( Sender : TObject)');
    RegisterMethod('Procedure Bufferfull( var Message : TMessage)');
    RegisterMethod('Procedure BtnOneFrameClick( Sender : TObject)');
    RegisterMethod('Procedure TrigLevelBarChange( Sender : TObject)');
    RegisterMethod('Procedure CalibrateBtnClick( Sender : TObject)');
    RegisterMethod('Procedure StaticText1Click( Sender : TObject)');
    RegisterMethod('Procedure SpectrumBtnClick( Sender : TObject)');
    RegisterMethod('Procedure FormActivate( Sender : TObject)');
    RegisterMethod('Procedure menuExitClick( Sender : TObject)');
    RegisterMethod('Procedure menuSaveImage1Click( Sender : TObject)');
    RegisterMethod('Procedure btnRunClick( Sender : TObject)');
    RegisterMethod('Procedure btnDualClick( Sender : TObject)');
    RegisterMethod('Procedure btnTrigerOnClick( Sender : TObject)');
    RegisterMethod('Procedure edtGainCh1Change( Sender : TObject)');
    RegisterMethod('Procedure edtGainCh2Change( Sender : TObject)');
    RegisterMethod('Procedure sp11025SampleClick( Sender : TObject)');
    RegisterMethod('Procedure sp22050SampleClick( Sender : TObject)');
    RegisterMethod('Procedure sp44100SampleClick( Sender : TObject)');
    RegisterMethod('Procedure trOfsCh1Change( Sender : TObject)');
    RegisterMethod('Procedure trOfsCh2Change( Sender : TObject)');
    RegisterMethod('Procedure upBeamLightClick( Sender : TObject; Button : TUDBtnType)');
    RegisterMethod('Procedure btnCh2OnClick( Sender : TObject)');
    RegisterMethod('Procedure btnCh1OnClick( Sender : TObject)');
    RegisterMethod('Procedure btnCH1GndClick( Sender : TObject)');
    RegisterMethod('Procedure btnCH2GndClick( Sender : TObject)');
    RegisterMethod('Procedure MenuGreenClick( Sender : TObject)');
    RegisterMethod('Procedure menuBlackClick( Sender : TObject)');
    RegisterMethod('Procedure trStartPosChange( Sender : TObject)');
    RegisterMethod('Procedure btnExpand2Click( Sender : TObject)');
    RegisterMethod('Procedure btnExpand1Click( Sender : TObject)');
    RegisterMethod('Procedure btnExpand4Click( Sender : TObject)');
    RegisterMethod('Procedure btnExpand8Click( Sender : TObject)');
    RegisterMethod('Procedure UpScaleLightChanging( Sender : TObject; var AllowChange : Boolean)');
    RegisterMethod('Procedure MenuData_TimeClick( Sender : TObject)');
    RegisterMethod('Procedure btnGain0Click( Sender : TObject)');
    RegisterMethod('Procedure btnGain1Click( Sender : TObject)');
    RegisterMethod('Procedure btnGain2Click( Sender : TObject)');
    RegisterMethod('Procedure Label12DblClick( Sender : TObject)');
    RegisterProperty('WaveIn', 'TWavein', iptrw);
    RegisterProperty('cy', 'integer', iptrw);
    RegisterProperty('hInc', 'single', iptrw);
    RegisterProperty('errcount', 'integer', iptrw);
    RegisterProperty('Ch1Gain', 'integer', iptrw);
    RegisterProperty('Ch2Gain', 'integer', iptrw);
    RegisterProperty('origbufsize', 'integer', iptrw);
    RegisterProperty('bufsize', 'integer', iptrw);
    RegisterProperty('framesize', 'integer', iptrw);
    RegisterProperty('xinc', 'integer', iptrw);
    RegisterProperty('X', 'integer', iptrw);
    RegisterProperty('Y', 'integer', iptrw);
    RegisterProperty('PlotPtsPerFrame', 'integer', iptrw);
    RegisterProperty('nbrframes', 'integer', iptrw);
    RegisterProperty('time1', 'TTime', iptrw);
    RegisterProperty('time2', 'TTime', iptrw);
    RegisterProperty('singleframe', 'boolean', iptrw);
    RegisterProperty('trigsign', 'integer', iptrw);
    RegisterProperty('triglevel', 'integer', iptrw);
    RegisterProperty('triggered', 'boolean', iptrw);
    RegisterProperty('triggerindex', 'integer', iptrw);
    RegisterProperty('trigbarchanging', 'boolean', iptrw);
    RegisterProperty('trigGrpchanging', 'boolean', iptrw);
    RegisterProperty('frameSaveBuf', 'array of byte', iptrw);
    RegisterProperty('calibrate', 'boolean', iptrw);
    RegisterProperty('Offsety', 'integer', iptrw);
    RegisterProperty('savedframedata', 'array of integer', iptrw);
    RegisterProperty('buffer1found', 'boolean', iptrw);
    RegisterProperty('inputfrm', 'TfrmInputControl', iptrw);
    RegisterMethod('Procedure Posterror( S : string)');
    RegisterMethod('Procedure setup');
    RegisterMethod('Procedure setmaxPtsToAvg');
    RegisterMethod('Procedure SetOscState');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_U_Oscilloscope4(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PBufArray', 'PByteARRAY');
  SIRegister_TOscfrmMain(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOscfrmMaininputfrm_W(Self: TOscfrmMain; const T: TfrmInputControl);
Begin Self.inputfrm := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaininputfrm_R(Self: TOscfrmMain; var T: TfrmInputControl);
Begin T := Self.inputfrm; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbuffer1found_W(Self: TOscfrmMain; const T: boolean);
Begin Self.buffer1found := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbuffer1found_R(Self: TOscfrmMain; var T: boolean);
Begin T := Self.buffer1found; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainsavedframedata_W(Self: TOscfrmMain; const T: array of integer);
Begin //Self.savedframedata := T;
end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainsavedframedata_R(Self: TOscfrmMain; var T: array of integer);
Begin //T := Self.savedframedata;
end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainOffsety_W(Self: TOscfrmMain; const T: integer);
Begin Self.Offsety := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainOffsety_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.Offsety; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaincalibrate_W(Self: TOscfrmMain; const T: boolean);
Begin Self.calibrate := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaincalibrate_R(Self: TOscfrmMain; var T: boolean);
Begin T := Self.calibrate; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainframeSaveBuf_W(Self: TOscfrmMain; const T: array of byte);
Begin //Self.frameSaveBuf := T;
end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainframeSaveBuf_R(Self: TOscfrmMain; var T: array of byte);
Begin //T := Self.frameSaveBuf;
end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrigGrpchanging_W(Self: TOscfrmMain; const T: boolean);
Begin Self.trigGrpchanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrigGrpchanging_R(Self: TOscfrmMain; var T: boolean);
Begin T := Self.trigGrpchanging; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrigbarchanging_W(Self: TOscfrmMain; const T: boolean);
Begin Self.trigbarchanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrigbarchanging_R(Self: TOscfrmMain; var T: boolean);
Begin T := Self.trigbarchanging; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintriggerindex_W(Self: TOscfrmMain; const T: integer);
Begin Self.triggerindex := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintriggerindex_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.triggerindex; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintriggered_W(Self: TOscfrmMain; const T: boolean);
Begin Self.triggered := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintriggered_R(Self: TOscfrmMain; var T: boolean);
Begin T := Self.triggered; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintriglevel_W(Self: TOscfrmMain; const T: integer);
Begin Self.triglevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintriglevel_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.triglevel; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrigsign_W(Self: TOscfrmMain; const T: integer);
Begin Self.trigsign := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrigsign_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.trigsign; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainsingleframe_W(Self: TOscfrmMain; const T: boolean);
Begin Self.singleframe := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainsingleframe_R(Self: TOscfrmMain; var T: boolean);
Begin T := Self.singleframe; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintime2_W(Self: TOscfrmMain; const T: TTime);
Begin Self.time2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintime2_R(Self: TOscfrmMain; var T: TTime);
Begin T := Self.time2; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintime1_W(Self: TOscfrmMain; const T: TTime);
Begin Self.time1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintime1_R(Self: TOscfrmMain; var T: TTime);
Begin T := Self.time1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainnbrframes_W(Self: TOscfrmMain; const T: integer);
Begin Self.nbrframes := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainnbrframes_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.nbrframes; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPlotPtsPerFrame_W(Self: TOscfrmMain; const T: integer);
Begin Self.PlotPtsPerFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPlotPtsPerFrame_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.PlotPtsPerFrame; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainY_W(Self: TOscfrmMain; const T: integer);
Begin Self.Y := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainY_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.Y; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainX_W(Self: TOscfrmMain; const T: integer);
Begin Self.X := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainX_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.X; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainxinc_W(Self: TOscfrmMain; const T: integer);
Begin Self.xinc := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainxinc_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.xinc; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainframesize_W(Self: TOscfrmMain; const T: integer);
Begin Self.framesize := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainframesize_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.framesize; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbufsize_W(Self: TOscfrmMain; const T: integer);
Begin Self.bufsize := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbufsize_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.bufsize; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainorigbufsize_W(Self: TOscfrmMain; const T: integer);
Begin Self.origbufsize := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainorigbufsize_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.origbufsize; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainCh2Gain_W(Self: TOscfrmMain; const T: integer);
Begin Self.Ch2Gain := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainCh2Gain_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.Ch2Gain; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainCh1Gain_W(Self: TOscfrmMain; const T: integer);
Begin Self.Ch1Gain := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainCh1Gain_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.Ch1Gain; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainerrcount_W(Self: TOscfrmMain; const T: integer);
Begin Self.errcount := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainerrcount_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.errcount; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainhInc_W(Self: TOscfrmMain; const T: single);
Begin Self.hInc := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainhInc_R(Self: TOscfrmMain; var T: single);
Begin T := Self.hInc; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaincy_W(Self: TOscfrmMain; const T: integer);
Begin Self.cy := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaincy_R(Self: TOscfrmMain; var T: integer);
Begin T := Self.cy; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainWaveIn_W(Self: TOscfrmMain; const T: TWavein);
Begin Self.WaveIn := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainWaveIn_R(Self: TOscfrmMain; var T: TWavein);
Begin T := Self.WaveIn; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainupFocus_W(Self: TOscfrmMain; const T: TUpDown);
Begin Self.upFocus := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainupFocus_R(Self: TOscfrmMain; var T: TUpDown);
Begin T := Self.upFocus; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel10_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label10 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel10_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label10; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainupBeamLight_W(Self: TOscfrmMain; const T: TUpDown);
Begin Self.upBeamLight := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainupBeamLight_R(Self: TOscfrmMain; var T: TUpDown);
Begin T := Self.upBeamLight; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel1_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel1_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainUpScaleLight_W(Self: TOscfrmMain; const T: TUpDown);
Begin Self.UpScaleLight := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainUpScaleLight_R(Self: TOscfrmMain; var T: TUpDown);
Begin T := Self.UpScaleLight; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel9_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label9 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel9_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label9; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainGroupBox4_W(Self: TOscfrmMain; const T: TGroupBox);
Begin Self.GroupBox4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainGroupBox4_R(Self: TOscfrmMain; var T: TGroupBox);
Begin T := Self.GroupBox4; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainfrmInputControl1_W(Self: TOscfrmMain; const T: TfrmInputControl);
Begin Self.frmInputControl1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainfrmInputControl1_R(Self: TOscfrmMain; var T: TfrmInputControl);
Begin T := Self.frmInputControl1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainStaticText1_W(Self: TOscfrmMain; const T: TStaticText);
Begin Self.StaticText1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainStaticText1_R(Self: TOscfrmMain; var T: TStaticText);
Begin T := Self.StaticText1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainOnCh2Box_W(Self: TOscfrmMain; const T: TCheckBox);
Begin Self.OnCh2Box := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainOnCh2Box_R(Self: TOscfrmMain; var T: TCheckBox);
Begin T := Self.OnCh2Box; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainOnCh1Box_W(Self: TOscfrmMain; const T: TCheckBox);
Begin Self.OnCh1Box := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainOnCh1Box_R(Self: TOscfrmMain; var T: TCheckBox);
Begin T := Self.OnCh1Box; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainCalibrateBtn_W(Self: TOscfrmMain; const T: TBitBtn);
Begin Self.CalibrateBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainCalibrateBtn_R(Self: TOscfrmMain; var T: TBitBtn);
Begin T := Self.CalibrateBtn; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainBtnOneFrame_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.BtnOneFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainBtnOneFrame_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.BtnOneFrame; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainSpectrumBtn_W(Self: TOscfrmMain; const T: TBitBtn);
Begin Self.SpectrumBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainSpectrumBtn_R(Self: TOscfrmMain; var T: TBitBtn);
Begin T := Self.SpectrumBtn; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnGain2_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnGain2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnGain2_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnGain2; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnGain1_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnGain1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnGain1_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnGain1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnGain0_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnGain0 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnGain0_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnGain0; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel13_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label13 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel13_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label13; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel11_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel11_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label11; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainGroupBox3_W(Self: TOscfrmMain; const T: TGroupBox);
Begin Self.GroupBox3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainGroupBox3_R(Self: TOscfrmMain; var T: TGroupBox);
Begin T := Self.GroupBox3; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainMemo1_W(Self: TOscfrmMain; const T: TMemo);
Begin Self.Memo1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainMemo1_R(Self: TOscfrmMain; var T: TMemo);
Begin T := Self.Memo1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainIntroSheet_W(Self: TOscfrmMain; const T: TTabSheet);
Begin Self.IntroSheet := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainIntroSheet_R(Self: TOscfrmMain; var T: TTabSheet);
Begin T := Self.IntroSheet; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainRunsheet_W(Self: TOscfrmMain; const T: TTabSheet);
Begin Self.Runsheet := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainRunsheet_R(Self: TOscfrmMain; var T: TTabSheet);
Begin T := Self.Runsheet; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPageControl1_W(Self: TOscfrmMain; const T: TPageControl);
Begin Self.PageControl1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPageControl1_R(Self: TOscfrmMain; var T: TPageControl);
Begin T := Self.PageControl1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainMenuData_Time_W(Self: TOscfrmMain; const T: TMenuItem);
Begin Self.MenuData_Time := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainMenuData_Time_R(Self: TOscfrmMain; var T: TMenuItem);
Begin T := Self.MenuData_Time; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainData1_W(Self: TOscfrmMain; const T: TMenuItem);
Begin Self.Data1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainData1_R(Self: TOscfrmMain; var T: TMenuItem);
Begin T := Self.Data1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel12_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label12 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel12_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label12; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnExpand8_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnExpand8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnExpand8_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnExpand8; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnExpand1_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnExpand1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnExpand1_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnExpand1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnExpand4_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnExpand4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnExpand4_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnExpand4; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnExpand2_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnExpand2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnExpand2_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnExpand2; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainMenuGreen_W(Self: TOscfrmMain; const T: TMenuItem);
Begin Self.MenuGreen := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainMenuGreen_R(Self: TOscfrmMain; var T: TMenuItem);
Begin T := Self.MenuGreen; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainmenuBlack_W(Self: TOscfrmMain; const T: TMenuItem);
Begin Self.menuBlack := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainmenuBlack_R(Self: TOscfrmMain; var T: TMenuItem);
Begin T := Self.menuBlack; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainColor1_W(Self: TOscfrmMain; const T: TMenuItem);
Begin Self.Color1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainColor1_R(Self: TOscfrmMain; var T: TMenuItem);
Begin T := Self.Color1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainScreen1_W(Self: TOscfrmMain; const T: TMenuItem);
Begin Self.Screen1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainScreen1_R(Self: TOscfrmMain; var T: TMenuItem);
Begin T := Self.Screen1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnCH2Gnd_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnCH2Gnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnCH2Gnd_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnCH2Gnd; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnCH1Gnd_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnCH1Gnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnCH1Gnd_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnCH1Gnd; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrStartPos_W(Self: TOscfrmMain; const T: TTrackBar);
Begin Self.trStartPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrStartPos_R(Self: TOscfrmMain; var T: TTrackBar);
Begin T := Self.trStartPos; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainfrmOscilloscope1_W(Self: TOscfrmMain; const T: TfrmOscilloscope);
Begin Self.frmOscilloscope1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainfrmOscilloscope1_R(Self: TOscfrmMain; var T: TfrmOscilloscope);
Begin T := Self.frmOscilloscope1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPanel4_W(Self: TOscfrmMain; const T: TPanel);
Begin Self.Panel4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPanel4_R(Self: TOscfrmMain; var T: TPanel);
Begin T := Self.Panel4; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPanel1_W(Self: TOscfrmMain; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPanel1_R(Self: TOscfrmMain; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainsp44100Sample_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.sp44100Sample := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainsp44100Sample_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.sp44100Sample; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainsp22050Sample_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.sp22050Sample := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainsp22050Sample_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.sp22050Sample; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainsp11025Sample_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.sp11025Sample := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainsp11025Sample_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.sp11025Sample; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainGroupBox2_W(Self: TOscfrmMain; const T: TGroupBox);
Begin Self.GroupBox2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainGroupBox2_R(Self: TOscfrmMain; var T: TGroupBox);
Begin T := Self.GroupBox2; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainedtGainCh2_W(Self: TOscfrmMain; const T: TEdit);
Begin Self.edtGainCh2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainedtGainCh2_R(Self: TOscfrmMain; var T: TEdit);
Begin T := Self.edtGainCh2; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainedtGainCh1_W(Self: TOscfrmMain; const T: TEdit);
Begin Self.edtGainCh1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainedtGainCh1_R(Self: TOscfrmMain; var T: TEdit);
Begin T := Self.edtGainCh1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainupGainCh2_W(Self: TOscfrmMain; const T: TUpDown);
Begin Self.upGainCh2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainupGainCh2_R(Self: TOscfrmMain; var T: TUpDown);
Begin T := Self.upGainCh2; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainupGainCh1_W(Self: TOscfrmMain; const T: TUpDown);
Begin Self.upGainCh1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainupGainCh1_R(Self: TOscfrmMain; var T: TUpDown);
Begin T := Self.upGainCh1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel8_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel8_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label8; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel7_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel7_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label7; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel6_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel6_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label6; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel5_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel5_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label5; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrOfsCh2_W(Self: TOscfrmMain; const T: TTrackBar);
Begin Self.trOfsCh2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrOfsCh2_R(Self: TOscfrmMain; var T: TTrackBar);
Begin T := Self.trOfsCh2; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrOfsCh1_W(Self: TOscfrmMain; const T: TTrackBar);
Begin Self.trOfsCh1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaintrOfsCh1_R(Self: TOscfrmMain; var T: TTrackBar);
Begin T := Self.trOfsCh1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnTrigerOn_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnTrigerOn := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnTrigerOn_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnTrigerOn; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainGroupBox1_W(Self: TOscfrmMain; const T: TGroupBox);
Begin Self.GroupBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainGroupBox1_R(Self: TOscfrmMain; var T: TGroupBox);
Begin T := Self.GroupBox1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnTrigNegativ_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnTrigNegativ := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnTrigNegativ_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnTrigNegativ; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnTrigPositiv_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnTrigPositiv := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnTrigPositiv_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnTrigPositiv; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnTriggCh2_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnTriggCh2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnTriggCh2_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnTriggCh2; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnTriggCh1_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnTriggCh1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnTriggCh1_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnTriggCh1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnDual_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnDual := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnDual_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnDual; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaingrpChannel2_W(Self: TOscfrmMain; const T: TGroupBox);
Begin Self.grpChannel2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMaingrpChannel2_R(Self: TOscfrmMain; var T: TGroupBox);
Begin T := Self.grpChannel2; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPanel6_W(Self: TOscfrmMain; const T: TPanel);
Begin Self.Panel6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPanel6_R(Self: TOscfrmMain; var T: TPanel);
Begin T := Self.Panel6; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPanel5_W(Self: TOscfrmMain; const T: TPanel);
Begin Self.Panel5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPanel5_R(Self: TOscfrmMain; var T: TPanel);
Begin T := Self.Panel5; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainGrpChannel1_W(Self: TOscfrmMain; const T: TGroupBox);
Begin Self.GrpChannel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainGrpChannel1_R(Self: TOscfrmMain; var T: TGroupBox);
Begin T := Self.GrpChannel1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPanel3_W(Self: TOscfrmMain; const T: TPanel);
Begin Self.Panel3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainPanel3_R(Self: TOscfrmMain; var T: TPanel);
Begin T := Self.Panel3; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnRun_W(Self: TOscfrmMain; const T: TSpeedButton);
Begin Self.btnRun := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainbtnRun_R(Self: TOscfrmMain; var T: TSpeedButton);
Begin T := Self.btnRun; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainstatustext_W(Self: TOscfrmMain; const T: TPanel);
Begin Self.statustext := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainstatustext_R(Self: TOscfrmMain; var T: TPanel);
Begin T := Self.statustext; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainmenuExit_W(Self: TOscfrmMain; const T: TMenuItem);
Begin Self.menuExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainmenuExit_R(Self: TOscfrmMain; var T: TMenuItem);
Begin T := Self.menuExit; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainN1_W(Self: TOscfrmMain; const T: TMenuItem);
Begin Self.N1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainN1_R(Self: TOscfrmMain; var T: TMenuItem);
Begin T := Self.N1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainmenuSaveImage1_W(Self: TOscfrmMain; const T: TMenuItem);
Begin Self.menuSaveImage1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainmenuSaveImage1_R(Self: TOscfrmMain; var T: TMenuItem);
Begin T := Self.menuSaveImage1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainFile1_W(Self: TOscfrmMain; const T: TMenuItem);
Begin Self.File1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainFile1_R(Self: TOscfrmMain; var T: TMenuItem);
Begin T := Self.File1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainMainMenu1_W(Self: TOscfrmMain; const T: TMainMenu);
Begin Self.MainMenu1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainMainMenu1_R(Self: TOscfrmMain; var T: TMainMenu);
Begin T := Self.MainMenu1; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainScaleLbl_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.ScaleLbl := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainScaleLbl_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.ScaleLbl; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel4_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel4_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainTrigLevelBar_W(Self: TOscfrmMain; const T: TTrackBar);
Begin Self.TrigLevelBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainTrigLevelBar_R(Self: TOscfrmMain; var T: TTrackBar);
Begin T := Self.TrigLevelBar; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel3_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel3_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainSweepUD_W(Self: TOscfrmMain; const T: TUpDown);
Begin Self.SweepUD := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainSweepUD_R(Self: TOscfrmMain; var T: TUpDown);
Begin T := Self.SweepUD; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainSweepEdt_W(Self: TOscfrmMain; const T: TEdit);
Begin Self.SweepEdt := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainSweepEdt_R(Self: TOscfrmMain; var T: TEdit);
Begin T := Self.SweepEdt; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel2_W(Self: TOscfrmMain; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TOscfrmMainLabel2_R(Self: TOscfrmMain; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOscfrmMain(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOscfrmMain) do
  begin
    RegisterPropertyHelper(@TOscfrmMainLabel2_R,@TOscfrmMainLabel2_W,'Label2');
    RegisterPropertyHelper(@TOscfrmMainSweepEdt_R,@TOscfrmMainSweepEdt_W,'SweepEdt');
    RegisterPropertyHelper(@TOscfrmMainSweepUD_R,@TOscfrmMainSweepUD_W,'SweepUD');
    RegisterPropertyHelper(@TOscfrmMainLabel3_R,@TOscfrmMainLabel3_W,'Label3');
    RegisterPropertyHelper(@TOscfrmMainTrigLevelBar_R,@TOscfrmMainTrigLevelBar_W,'TrigLevelBar');
    RegisterPropertyHelper(@TOscfrmMainLabel4_R,@TOscfrmMainLabel4_W,'Label4');
    RegisterPropertyHelper(@TOscfrmMainScaleLbl_R,@TOscfrmMainScaleLbl_W,'ScaleLbl');
    RegisterPropertyHelper(@TOscfrmMainMainMenu1_R,@TOscfrmMainMainMenu1_W,'MainMenu1');
    RegisterPropertyHelper(@TOscfrmMainFile1_R,@TOscfrmMainFile1_W,'File1');
    RegisterPropertyHelper(@TOscfrmMainmenuSaveImage1_R,@TOscfrmMainmenuSaveImage1_W,'menuSaveImage1');
    RegisterPropertyHelper(@TOscfrmMainN1_R,@TOscfrmMainN1_W,'N1');
    RegisterPropertyHelper(@TOscfrmMainmenuExit_R,@TOscfrmMainmenuExit_W,'menuExit');
    RegisterPropertyHelper(@TOscfrmMainstatustext_R,@TOscfrmMainstatustext_W,'statustext');
    RegisterPropertyHelper(@TOscfrmMainbtnRun_R,@TOscfrmMainbtnRun_W,'btnRun');
    RegisterPropertyHelper(@TOscfrmMainPanel3_R,@TOscfrmMainPanel3_W,'Panel3');
    RegisterPropertyHelper(@TOscfrmMainGrpChannel1_R,@TOscfrmMainGrpChannel1_W,'GrpChannel1');
    RegisterPropertyHelper(@TOscfrmMainPanel5_R,@TOscfrmMainPanel5_W,'Panel5');
    RegisterPropertyHelper(@TOscfrmMainPanel6_R,@TOscfrmMainPanel6_W,'Panel6');
    RegisterPropertyHelper(@TOscfrmMaingrpChannel2_R,@TOscfrmMaingrpChannel2_W,'grpChannel2');
    RegisterPropertyHelper(@TOscfrmMainbtnDual_R,@TOscfrmMainbtnDual_W,'btnDual');
    RegisterPropertyHelper(@TOscfrmMainbtnTriggCh1_R,@TOscfrmMainbtnTriggCh1_W,'btnTriggCh1');
    RegisterPropertyHelper(@TOscfrmMainbtnTriggCh2_R,@TOscfrmMainbtnTriggCh2_W,'btnTriggCh2');
    RegisterPropertyHelper(@TOscfrmMainbtnTrigPositiv_R,@TOscfrmMainbtnTrigPositiv_W,'btnTrigPositiv');
    RegisterPropertyHelper(@TOscfrmMainbtnTrigNegativ_R,@TOscfrmMainbtnTrigNegativ_W,'btnTrigNegativ');
    RegisterPropertyHelper(@TOscfrmMainGroupBox1_R,@TOscfrmMainGroupBox1_W,'GroupBox1');
    RegisterPropertyHelper(@TOscfrmMainbtnTrigerOn_R,@TOscfrmMainbtnTrigerOn_W,'btnTrigerOn');
    RegisterPropertyHelper(@TOscfrmMaintrOfsCh1_R,@TOscfrmMaintrOfsCh1_W,'trOfsCh1');
    RegisterPropertyHelper(@TOscfrmMaintrOfsCh2_R,@TOscfrmMaintrOfsCh2_W,'trOfsCh2');
    RegisterPropertyHelper(@TOscfrmMainLabel5_R,@TOscfrmMainLabel5_W,'Label5');
    RegisterPropertyHelper(@TOscfrmMainLabel6_R,@TOscfrmMainLabel6_W,'Label6');
    RegisterPropertyHelper(@TOscfrmMainLabel7_R,@TOscfrmMainLabel7_W,'Label7');
    RegisterPropertyHelper(@TOscfrmMainLabel8_R,@TOscfrmMainLabel8_W,'Label8');
    RegisterPropertyHelper(@TOscfrmMainupGainCh1_R,@TOscfrmMainupGainCh1_W,'upGainCh1');
    RegisterPropertyHelper(@TOscfrmMainupGainCh2_R,@TOscfrmMainupGainCh2_W,'upGainCh2');
    RegisterPropertyHelper(@TOscfrmMainedtGainCh1_R,@TOscfrmMainedtGainCh1_W,'edtGainCh1');
    RegisterPropertyHelper(@TOscfrmMainedtGainCh2_R,@TOscfrmMainedtGainCh2_W,'edtGainCh2');
    RegisterPropertyHelper(@TOscfrmMainGroupBox2_R,@TOscfrmMainGroupBox2_W,'GroupBox2');
    RegisterPropertyHelper(@TOscfrmMainsp11025Sample_R,@TOscfrmMainsp11025Sample_W,'sp11025Sample');
    RegisterPropertyHelper(@TOscfrmMainsp22050Sample_R,@TOscfrmMainsp22050Sample_W,'sp22050Sample');
    RegisterPropertyHelper(@TOscfrmMainsp44100Sample_R,@TOscfrmMainsp44100Sample_W,'sp44100Sample');
    RegisterPropertyHelper(@TOscfrmMainPanel1_R,@TOscfrmMainPanel1_W,'Panel1');
    RegisterPropertyHelper(@TOscfrmMainPanel4_R,@TOscfrmMainPanel4_W,'Panel4');
    RegisterPropertyHelper(@TOscfrmMainfrmOscilloscope1_R,@TOscfrmMainfrmOscilloscope1_W,'frmOscilloscope1');
    RegisterPropertyHelper(@TOscfrmMaintrStartPos_R,@TOscfrmMaintrStartPos_W,'trStartPos');
    RegisterPropertyHelper(@TOscfrmMainbtnCH1Gnd_R,@TOscfrmMainbtnCH1Gnd_W,'btnCH1Gnd');
    RegisterPropertyHelper(@TOscfrmMainbtnCH2Gnd_R,@TOscfrmMainbtnCH2Gnd_W,'btnCH2Gnd');
    RegisterPropertyHelper(@TOscfrmMainScreen1_R,@TOscfrmMainScreen1_W,'Screen1');
    RegisterPropertyHelper(@TOscfrmMainColor1_R,@TOscfrmMainColor1_W,'Color1');
    RegisterPropertyHelper(@TOscfrmMainmenuBlack_R,@TOscfrmMainmenuBlack_W,'menuBlack');
    RegisterPropertyHelper(@TOscfrmMainMenuGreen_R,@TOscfrmMainMenuGreen_W,'MenuGreen');
    RegisterPropertyHelper(@TOscfrmMainbtnExpand2_R,@TOscfrmMainbtnExpand2_W,'btnExpand2');
    RegisterPropertyHelper(@TOscfrmMainbtnExpand4_R,@TOscfrmMainbtnExpand4_W,'btnExpand4');
    RegisterPropertyHelper(@TOscfrmMainbtnExpand1_R,@TOscfrmMainbtnExpand1_W,'btnExpand1');
    RegisterPropertyHelper(@TOscfrmMainbtnExpand8_R,@TOscfrmMainbtnExpand8_W,'btnExpand8');
    RegisterPropertyHelper(@TOscfrmMainLabel12_R,@TOscfrmMainLabel12_W,'Label12');
    RegisterPropertyHelper(@TOscfrmMainData1_R,@TOscfrmMainData1_W,'Data1');
    RegisterPropertyHelper(@TOscfrmMainMenuData_Time_R,@TOscfrmMainMenuData_Time_W,'MenuData_Time');
    RegisterPropertyHelper(@TOscfrmMainPageControl1_R,@TOscfrmMainPageControl1_W,'PageControl1');
    RegisterPropertyHelper(@TOscfrmMainRunsheet_R,@TOscfrmMainRunsheet_W,'Runsheet');
    RegisterPropertyHelper(@TOscfrmMainIntroSheet_R,@TOscfrmMainIntroSheet_W,'IntroSheet');
    RegisterPropertyHelper(@TOscfrmMainMemo1_R,@TOscfrmMainMemo1_W,'Memo1');
    RegisterPropertyHelper(@TOscfrmMainGroupBox3_R,@TOscfrmMainGroupBox3_W,'GroupBox3');
    RegisterPropertyHelper(@TOscfrmMainLabel11_R,@TOscfrmMainLabel11_W,'Label11');
    RegisterPropertyHelper(@TOscfrmMainLabel13_R,@TOscfrmMainLabel13_W,'Label13');
    RegisterPropertyHelper(@TOscfrmMainbtnGain0_R,@TOscfrmMainbtnGain0_W,'btnGain0');
    RegisterPropertyHelper(@TOscfrmMainbtnGain1_R,@TOscfrmMainbtnGain1_W,'btnGain1');
    RegisterPropertyHelper(@TOscfrmMainbtnGain2_R,@TOscfrmMainbtnGain2_W,'btnGain2');
    RegisterPropertyHelper(@TOscfrmMainSpectrumBtn_R,@TOscfrmMainSpectrumBtn_W,'SpectrumBtn');
    RegisterPropertyHelper(@TOscfrmMainBtnOneFrame_R,@TOscfrmMainBtnOneFrame_W,'BtnOneFrame');
    RegisterPropertyHelper(@TOscfrmMainCalibrateBtn_R,@TOscfrmMainCalibrateBtn_W,'CalibrateBtn');
    RegisterPropertyHelper(@TOscfrmMainOnCh1Box_R,@TOscfrmMainOnCh1Box_W,'OnCh1Box');
    RegisterPropertyHelper(@TOscfrmMainOnCh2Box_R,@TOscfrmMainOnCh2Box_W,'OnCh2Box');
    RegisterPropertyHelper(@TOscfrmMainStaticText1_R,@TOscfrmMainStaticText1_W,'StaticText1');
    RegisterPropertyHelper(@TOscfrmMainfrmInputControl1_R,@TOscfrmMainfrmInputControl1_W,'frmInputControl1');
    RegisterPropertyHelper(@TOscfrmMainGroupBox4_R,@TOscfrmMainGroupBox4_W,'GroupBox4');
    RegisterPropertyHelper(@TOscfrmMainLabel9_R,@TOscfrmMainLabel9_W,'Label9');
    RegisterPropertyHelper(@TOscfrmMainUpScaleLight_R,@TOscfrmMainUpScaleLight_W,'UpScaleLight');
    RegisterPropertyHelper(@TOscfrmMainLabel1_R,@TOscfrmMainLabel1_W,'Label1');
    RegisterPropertyHelper(@TOscfrmMainupBeamLight_R,@TOscfrmMainupBeamLight_W,'upBeamLight');
    RegisterPropertyHelper(@TOscfrmMainLabel10_R,@TOscfrmMainLabel10_W,'Label10');
    RegisterPropertyHelper(@TOscfrmMainupFocus_R,@TOscfrmMainupFocus_W,'upFocus');
    RegisterMethod(@TOscfrmMain.upFocusClick, 'upFocusClick');
    RegisterMethod(@TOscfrmMain.FormCreate, 'FormCreate');
    RegisterMethod(@TOscfrmMain.FormCloseQuery, 'FormCloseQuery');
    RegisterMethod(@TOscfrmMain.SweepEdtChange, 'SweepEdtChange');
    RegisterMethod(@TOscfrmMain.Bufferfull, 'Bufferfull');
    RegisterMethod(@TOscfrmMain.BtnOneFrameClick, 'BtnOneFrameClick');
    RegisterMethod(@TOscfrmMain.TrigLevelBarChange, 'TrigLevelBarChange');
    RegisterMethod(@TOscfrmMain.CalibrateBtnClick, 'CalibrateBtnClick');
    RegisterMethod(@TOscfrmMain.StaticText1Click, 'StaticText1Click');
    RegisterMethod(@TOscfrmMain.SpectrumBtnClick, 'SpectrumBtnClick');
    RegisterMethod(@TOscfrmMain.FormActivate, 'FormActivate');
    RegisterMethod(@TOscfrmMain.menuExitClick, 'menuExitClick');
    RegisterMethod(@TOscfrmMain.menuSaveImage1Click, 'menuSaveImage1Click');
    RegisterMethod(@TOscfrmMain.btnRunClick, 'btnRunClick');
    RegisterMethod(@TOscfrmMain.btnDualClick, 'btnDualClick');
    RegisterMethod(@TOscfrmMain.btnTrigerOnClick, 'btnTrigerOnClick');
    RegisterMethod(@TOscfrmMain.edtGainCh1Change, 'edtGainCh1Change');
    RegisterMethod(@TOscfrmMain.edtGainCh2Change, 'edtGainCh2Change');
    RegisterMethod(@TOscfrmMain.sp11025SampleClick, 'sp11025SampleClick');
    RegisterMethod(@TOscfrmMain.sp22050SampleClick, 'sp22050SampleClick');
    RegisterMethod(@TOscfrmMain.sp44100SampleClick, 'sp44100SampleClick');
    RegisterMethod(@TOscfrmMain.trOfsCh1Change, 'trOfsCh1Change');
    RegisterMethod(@TOscfrmMain.trOfsCh2Change, 'trOfsCh2Change');
    RegisterMethod(@TOscfrmMain.upBeamLightClick, 'upBeamLightClick');
    RegisterMethod(@TOscfrmMain.btnCh2OnClick, 'btnCh2OnClick');
    RegisterMethod(@TOscfrmMain.btnCh1OnClick, 'btnCh1OnClick');
    RegisterMethod(@TOscfrmMain.btnCH1GndClick, 'btnCH1GndClick');
    RegisterMethod(@TOscfrmMain.btnCH2GndClick, 'btnCH2GndClick');
    RegisterMethod(@TOscfrmMain.MenuGreenClick, 'MenuGreenClick');
    RegisterMethod(@TOscfrmMain.menuBlackClick, 'menuBlackClick');
    RegisterMethod(@TOscfrmMain.trStartPosChange, 'trStartPosChange');
    RegisterMethod(@TOscfrmMain.btnExpand2Click, 'btnExpand2Click');
    RegisterMethod(@TOscfrmMain.btnExpand1Click, 'btnExpand1Click');
    RegisterMethod(@TOscfrmMain.btnExpand4Click, 'btnExpand4Click');
    RegisterMethod(@TOscfrmMain.btnExpand8Click, 'btnExpand8Click');
    RegisterMethod(@TOscfrmMain.UpScaleLightChanging, 'UpScaleLightChanging');
    RegisterMethod(@TOscfrmMain.MenuData_TimeClick, 'MenuData_TimeClick');
    RegisterMethod(@TOscfrmMain.btnGain0Click, 'btnGain0Click');
    RegisterMethod(@TOscfrmMain.btnGain1Click, 'btnGain1Click');
    RegisterMethod(@TOscfrmMain.btnGain2Click, 'btnGain2Click');
    RegisterMethod(@TOscfrmMain.Label12DblClick, 'Label12DblClick');
    RegisterPropertyHelper(@TOscfrmMainWaveIn_R,@TOscfrmMainWaveIn_W,'WaveIn');
    RegisterPropertyHelper(@TOscfrmMaincy_R,@TOscfrmMaincy_W,'cy');
    RegisterPropertyHelper(@TOscfrmMainhInc_R,@TOscfrmMainhInc_W,'hInc');
    RegisterPropertyHelper(@TOscfrmMainerrcount_R,@TOscfrmMainerrcount_W,'errcount');
    RegisterPropertyHelper(@TOscfrmMainCh1Gain_R,@TOscfrmMainCh1Gain_W,'Ch1Gain');
    RegisterPropertyHelper(@TOscfrmMainCh2Gain_R,@TOscfrmMainCh2Gain_W,'Ch2Gain');
    RegisterPropertyHelper(@TOscfrmMainorigbufsize_R,@TOscfrmMainorigbufsize_W,'origbufsize');
    RegisterPropertyHelper(@TOscfrmMainbufsize_R,@TOscfrmMainbufsize_W,'bufsize');
    RegisterPropertyHelper(@TOscfrmMainframesize_R,@TOscfrmMainframesize_W,'framesize');
    RegisterPropertyHelper(@TOscfrmMainxinc_R,@TOscfrmMainxinc_W,'xinc');
    RegisterPropertyHelper(@TOscfrmMainX_R,@TOscfrmMainX_W,'X');
    RegisterPropertyHelper(@TOscfrmMainY_R,@TOscfrmMainY_W,'Y');
    RegisterPropertyHelper(@TOscfrmMainPlotPtsPerFrame_R,@TOscfrmMainPlotPtsPerFrame_W,'PlotPtsPerFrame');
    RegisterPropertyHelper(@TOscfrmMainnbrframes_R,@TOscfrmMainnbrframes_W,'nbrframes');
    RegisterPropertyHelper(@TOscfrmMaintime1_R,@TOscfrmMaintime1_W,'time1');
    RegisterPropertyHelper(@TOscfrmMaintime2_R,@TOscfrmMaintime2_W,'time2');
    RegisterPropertyHelper(@TOscfrmMainsingleframe_R,@TOscfrmMainsingleframe_W,'singleframe');
    RegisterPropertyHelper(@TOscfrmMaintrigsign_R,@TOscfrmMaintrigsign_W,'trigsign');
    RegisterPropertyHelper(@TOscfrmMaintriglevel_R,@TOscfrmMaintriglevel_W,'triglevel');
    RegisterPropertyHelper(@TOscfrmMaintriggered_R,@TOscfrmMaintriggered_W,'triggered');
    RegisterPropertyHelper(@TOscfrmMaintriggerindex_R,@TOscfrmMaintriggerindex_W,'triggerindex');
    RegisterPropertyHelper(@TOscfrmMaintrigbarchanging_R,@TOscfrmMaintrigbarchanging_W,'trigbarchanging');
    RegisterPropertyHelper(@TOscfrmMaintrigGrpchanging_R,@TOscfrmMaintrigGrpchanging_W,'trigGrpchanging');
    RegisterPropertyHelper(@TOscfrmMainframeSaveBuf_R,@TOscfrmMainframeSaveBuf_W,'frameSaveBuf');
    RegisterPropertyHelper(@TOscfrmMaincalibrate_R,@TOscfrmMaincalibrate_W,'calibrate');
    RegisterPropertyHelper(@TOscfrmMainOffsety_R,@TOscfrmMainOffsety_W,'Offsety');
    RegisterPropertyHelper(@TOscfrmMainsavedframedata_R,@TOscfrmMainsavedframedata_W,'savedframedata');
    RegisterPropertyHelper(@TOscfrmMainbuffer1found_R,@TOscfrmMainbuffer1found_W,'buffer1found');
    RegisterPropertyHelper(@TOscfrmMaininputfrm_R,@TOscfrmMaininputfrm_W,'inputfrm');
    RegisterMethod(@TOscfrmMain.Posterror, 'Posterror');
    RegisterMethod(@TOscfrmMain.setup, 'setup');
    RegisterMethod(@TOscfrmMain.setmaxPtsToAvg, 'setmaxPtsToAvg');
    RegisterMethod(@TOscfrmMain.SetOscState, 'SetOscState');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_U_Oscilloscope4(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOscfrmMain(CL);
end;

 
 
{ TPSImport_U_Oscilloscope4 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_U_Oscilloscope4.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_U_Oscilloscope4(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_U_Oscilloscope4.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_U_Oscilloscope4(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
