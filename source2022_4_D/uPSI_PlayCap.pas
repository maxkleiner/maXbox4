unit uPSI_PlayCap;
{
  beside avi cap
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
  TPSImport_PlayCap = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TfrmCap(CL: TPSPascalCompiler);
procedure SIRegister_PlayCap(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TfrmCap(CL: TPSRuntimeClassImporter);
procedure RIRegister_PlayCap(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
 // ,DirectShow
  ,ExtCtrls
  ,StdCtrls
  ,ComCtrls
  ,ComObj
  ,ActiveX
  ,Menus
  ,PlayCap
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PlayCap]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TfrmCap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TfrmCap') do
  with CL.AddClassN(CL.FindClass('TForm'),'TfrmCap') do
  begin
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('pnlView', 'TPanel', iptrw);
    RegisterProperty('btnVideoDevProps', 'TButton', iptrw);
    RegisterProperty('btnCapture', 'TButton', iptrw);
    RegisterProperty('btnPreview', 'TButton', iptrw);
    RegisterProperty('btnExit', 'TButton', iptrw);
    RegisterProperty('StatusBar1', 'TStatusBar', iptrw);
    RegisterProperty('btnVideoComprProps', 'TButton', iptrw);
    RegisterProperty('MainMenu1', 'TMainMenu', iptrw);
    RegisterProperty('Datei1', 'TMenuItem', iptrw);
    RegisterProperty('mnuDatei', 'TMenuItem', iptrw);
    RegisterProperty('N1', 'TMenuItem', iptrw);
    RegisterProperty('mnuExit', 'TMenuItem', iptrw);
    RegisterProperty('mnuVDevice', 'TMenuItem', iptrw);
    RegisterProperty('mnuVCompress', 'TMenuItem', iptrw);
    RegisterProperty('mnuADevice', 'TMenuItem', iptrw);
    RegisterProperty('mnuACompress', 'TMenuItem', iptrw);
    RegisterProperty('btnAudioDevProps', 'TButton', iptrw);
    RegisterProperty('btnAudioComprProps', 'TButton', iptrw);
    RegisterProperty('chkVideoCompress', 'TCheckBox', iptrw);
    RegisterProperty('chkAudioCompress', 'TCheckBox', iptrw);
    RegisterProperty('Timer1', 'TTimer', iptrw);
    RegisterProperty('ProgressBar1', 'TProgressBar', iptrw);
    RegisterProperty('Panel2', 'TPanel', iptrw);
    RegisterProperty('edStart', 'TEdit', iptrw);
    RegisterProperty('edDauer', 'TEdit', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('SaveDialog1', 'TSaveDialog', iptrw);
    RegisterProperty('Memo1', 'TMemo', iptrw);
    RegisterProperty('btnStopCapture', 'TButton', iptrw);
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure FormClose( Sender : TObject; var Action : TCloseAction)');
    RegisterMethod('Procedure FormResize( Sender : TObject)');
    RegisterMethod('Procedure btnCaptureClick( Sender : TObject)');
    RegisterMethod('Procedure btnPreviewClick( Sender : TObject)');
    RegisterMethod('Procedure btnExitClick( Sender : TObject)');
    RegisterMethod('Procedure btnVideoComprPropsClick( Sender : TObject)');
    RegisterMethod('Procedure mnuVDeviceClick( Sender : TObject)');
    RegisterMethod('Procedure mnuVCompressClick( Sender : TObject)');
    RegisterMethod('Procedure mnuADeviceClick( Sender : TObject)');
    RegisterMethod('Procedure mnuACompressClick( Sender : TObject)');
    RegisterMethod('Procedure btnAudioDevPropsClick( Sender : TObject)');
    RegisterMethod('Procedure btnAudioComprPropsClick( Sender : TObject)');
    RegisterMethod('Procedure Timer1Timer( Sender : TObject)');
    RegisterMethod('Procedure FormActivate( Sender : TObject)');
    RegisterMethod('Procedure mnuDateiClick( Sender : TObject)');
    RegisterMethod('Procedure btnVideoDevPropsClick( Sender : TObject)');
    RegisterMethod('Procedure btnStopCaptureClick( Sender : TObject)');
    RegisterProperty('DeviceName', 'WideString', iptrw);
    RegisterProperty('ComprName', 'WideString', iptrw);
    RegisterProperty('rtStart', 'TREFERENCE_TIME', iptrw);
    RegisterProperty('rtStop', 'TREFERENCE_TIME', iptrw);
    RegisterMethod('Function GetInterfaces : HRESULT');
    RegisterMethod('Function FindDevice( Category : TGUID; bstrName : WideString; var ppSrcFilter : IBaseFilter) : HRESULT');
    RegisterMethod('Function SetupVideoWindow : HRESULT');
    RegisterMethod('Function HandleGraphEvent : HRESULT');
    RegisterMethod('Procedure Msg( szFormat : String; hr : HRESULT)');
    RegisterMethod('Procedure CloseInterfaces');
    RegisterMethod('Procedure ResizeVideoWindow');
    RegisterMethod('Function InititInterfacesAndFilter : HRESULT');
    RegisterMethod('Function Enumerate( category : TGUID; var item : TMenuItem) : HRESULT');
    RegisterMethod('Function FillListDevices : HRESULT');
    RegisterMethod('Function SupportsPropertyPage( pFilter : IBaseFilter) : BOOL');
    RegisterMethod('Function FindFilterFromName( szNameToFind : String) : IBaseFilter');
    RegisterMethod('Procedure WMGrafNotify( var msg : TMessage)');
    RegisterMethod('Function DisplayECEvent( lEventCode : Integer) : String');
    RegisterMethod('Function ShowPins( pFilter : IBaseFilter) : HRESULT');
    RegisterMethod('Procedure ShowFilterProperties( mnuTitel : TMenuTitel; const categorie : TGUID)');
    RegisterMethod('Function PreviewVideo( devname : WideString) : HRESULT');
    RegisterMethod('Function FindNeededFilter( comprName : WideString; audioFilter : WideString; audioCompr : WideString) : HRESULT');
    RegisterMethod('Procedure FilterLoop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PlayCap(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPLAYSTATE', '( Stopped, Paused, Running, Init )');
 CL.AddConstantN('ONE_SECOND','Int64').SetInt64( 10000000);
 CL.AddConstantN('ZehntelSekunde','Int64').SetInt64( 1000000);
 CL.AddConstantN('MAX_TIME','LongWord').SetUInt( $7FFFFFFFFFFFFFFF);
 CL.AddConstantN('WM_GRAPHNOTIFY','LongInt').SetInt( WM_APP + 1);
  CL.AddTypeS('TMenutitel', '( Videogeraet, VideoCompression, Audiogeraet, Audi'
   +'oCompression )');
  SIRegister_TfrmCap(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TfrmCaprtStop_W(Self: TfrmCap; const T: TREFERENCE_TIME);
Begin Self.rtStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCaprtStop_R(Self: TfrmCap; var T: TREFERENCE_TIME);
Begin T := Self.rtStop; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCaprtStart_W(Self: TfrmCap; const T: TREFERENCE_TIME);
Begin Self.rtStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCaprtStart_R(Self: TfrmCap; var T: TREFERENCE_TIME);
Begin T := Self.rtStart; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapComprName_W(Self: TfrmCap; const T: WideString);
Begin Self.ComprName := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapComprName_R(Self: TfrmCap; var T: WideString);
Begin T := Self.ComprName; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapDeviceName_W(Self: TfrmCap; const T: WideString);
Begin Self.DeviceName := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapDeviceName_R(Self: TfrmCap; var T: WideString);
Begin T := Self.DeviceName; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnStopCapture_W(Self: TfrmCap; const T: TButton);
Begin Self.btnStopCapture := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnStopCapture_R(Self: TfrmCap; var T: TButton);
Begin T := Self.btnStopCapture; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapMemo1_W(Self: TfrmCap; const T: TMemo);
Begin Self.Memo1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapMemo1_R(Self: TfrmCap; var T: TMemo);
Begin T := Self.Memo1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapSaveDialog1_W(Self: TfrmCap; const T: TSaveDialog);
Begin Self.SaveDialog1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapSaveDialog1_R(Self: TfrmCap; var T: TSaveDialog);
Begin T := Self.SaveDialog1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapLabel2_W(Self: TfrmCap; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapLabel2_R(Self: TfrmCap; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapLabel1_W(Self: TfrmCap; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapLabel1_R(Self: TfrmCap; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapedDauer_W(Self: TfrmCap; const T: TEdit);
Begin Self.edDauer := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapedDauer_R(Self: TfrmCap; var T: TEdit);
Begin T := Self.edDauer; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapedStart_W(Self: TfrmCap; const T: TEdit);
Begin Self.edStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapedStart_R(Self: TfrmCap; var T: TEdit);
Begin T := Self.edStart; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapPanel2_W(Self: TfrmCap; const T: TPanel);
Begin Self.Panel2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapPanel2_R(Self: TfrmCap; var T: TPanel);
Begin T := Self.Panel2; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapProgressBar1_W(Self: TfrmCap; const T: TProgressBar);
Begin Self.ProgressBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapProgressBar1_R(Self: TfrmCap; var T: TProgressBar);
Begin T := Self.ProgressBar1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapTimer1_W(Self: TfrmCap; const T: TTimer);
Begin Self.Timer1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapTimer1_R(Self: TfrmCap; var T: TTimer);
Begin T := Self.Timer1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapchkAudioCompress_W(Self: TfrmCap; const T: TCheckBox);
Begin Self.chkAudioCompress := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapchkAudioCompress_R(Self: TfrmCap; var T: TCheckBox);
Begin T := Self.chkAudioCompress; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapchkVideoCompress_W(Self: TfrmCap; const T: TCheckBox);
Begin Self.chkVideoCompress := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapchkVideoCompress_R(Self: TfrmCap; var T: TCheckBox);
Begin T := Self.chkVideoCompress; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnAudioComprProps_W(Self: TfrmCap; const T: TButton);
Begin Self.btnAudioComprProps := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnAudioComprProps_R(Self: TfrmCap; var T: TButton);
Begin T := Self.btnAudioComprProps; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnAudioDevProps_W(Self: TfrmCap; const T: TButton);
Begin Self.btnAudioDevProps := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnAudioDevProps_R(Self: TfrmCap; var T: TButton);
Begin T := Self.btnAudioDevProps; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuACompress_W(Self: TfrmCap; const T: TMenuItem);
Begin Self.mnuACompress := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuACompress_R(Self: TfrmCap; var T: TMenuItem);
Begin T := Self.mnuACompress; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuADevice_W(Self: TfrmCap; const T: TMenuItem);
Begin Self.mnuADevice := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuADevice_R(Self: TfrmCap; var T: TMenuItem);
Begin T := Self.mnuADevice; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuVCompress_W(Self: TfrmCap; const T: TMenuItem);
Begin Self.mnuVCompress := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuVCompress_R(Self: TfrmCap; var T: TMenuItem);
Begin T := Self.mnuVCompress; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuVDevice_W(Self: TfrmCap; const T: TMenuItem);
Begin Self.mnuVDevice := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuVDevice_R(Self: TfrmCap; var T: TMenuItem);
Begin T := Self.mnuVDevice; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuExit_W(Self: TfrmCap; const T: TMenuItem);
Begin Self.mnuExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuExit_R(Self: TfrmCap; var T: TMenuItem);
Begin T := Self.mnuExit; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapN1_W(Self: TfrmCap; const T: TMenuItem);
Begin Self.N1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapN1_R(Self: TfrmCap; var T: TMenuItem);
Begin T := Self.N1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuDatei_W(Self: TfrmCap; const T: TMenuItem);
Begin Self.mnuDatei := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapmnuDatei_R(Self: TfrmCap; var T: TMenuItem);
Begin T := Self.mnuDatei; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapDatei1_W(Self: TfrmCap; const T: TMenuItem);
Begin Self.Datei1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapDatei1_R(Self: TfrmCap; var T: TMenuItem);
Begin T := Self.Datei1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapMainMenu1_W(Self: TfrmCap; const T: TMainMenu);
Begin Self.MainMenu1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapMainMenu1_R(Self: TfrmCap; var T: TMainMenu);
Begin T := Self.MainMenu1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnVideoComprProps_W(Self: TfrmCap; const T: TButton);
Begin Self.btnVideoComprProps := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnVideoComprProps_R(Self: TfrmCap; var T: TButton);
Begin T := Self.btnVideoComprProps; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapStatusBar1_W(Self: TfrmCap; const T: TStatusBar);
Begin Self.StatusBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapStatusBar1_R(Self: TfrmCap; var T: TStatusBar);
Begin T := Self.StatusBar1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnExit_W(Self: TfrmCap; const T: TButton);
Begin Self.btnExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnExit_R(Self: TfrmCap; var T: TButton);
Begin T := Self.btnExit; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnPreview_W(Self: TfrmCap; const T: TButton);
Begin Self.btnPreview := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnPreview_R(Self: TfrmCap; var T: TButton);
Begin T := Self.btnPreview; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnCapture_W(Self: TfrmCap; const T: TButton);
Begin Self.btnCapture := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnCapture_R(Self: TfrmCap; var T: TButton);
Begin T := Self.btnCapture; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnVideoDevProps_W(Self: TfrmCap; const T: TButton);
Begin Self.btnVideoDevProps := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapbtnVideoDevProps_R(Self: TfrmCap; var T: TButton);
Begin T := Self.btnVideoDevProps; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCappnlView_W(Self: TfrmCap; const T: TPanel);
Begin Self.pnlView := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCappnlView_R(Self: TfrmCap; var T: TPanel);
Begin T := Self.pnlView; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapPanel1_W(Self: TfrmCap; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmCapPanel1_R(Self: TfrmCap; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TfrmCap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TfrmCap) do
  begin
    RegisterPropertyHelper(@TfrmCapPanel1_R,@TfrmCapPanel1_W,'Panel1');
    RegisterPropertyHelper(@TfrmCappnlView_R,@TfrmCappnlView_W,'pnlView');
    RegisterPropertyHelper(@TfrmCapbtnVideoDevProps_R,@TfrmCapbtnVideoDevProps_W,'btnVideoDevProps');
    RegisterPropertyHelper(@TfrmCapbtnCapture_R,@TfrmCapbtnCapture_W,'btnCapture');
    RegisterPropertyHelper(@TfrmCapbtnPreview_R,@TfrmCapbtnPreview_W,'btnPreview');
    RegisterPropertyHelper(@TfrmCapbtnExit_R,@TfrmCapbtnExit_W,'btnExit');
    RegisterPropertyHelper(@TfrmCapStatusBar1_R,@TfrmCapStatusBar1_W,'StatusBar1');
    RegisterPropertyHelper(@TfrmCapbtnVideoComprProps_R,@TfrmCapbtnVideoComprProps_W,'btnVideoComprProps');
    RegisterPropertyHelper(@TfrmCapMainMenu1_R,@TfrmCapMainMenu1_W,'MainMenu1');
    RegisterPropertyHelper(@TfrmCapDatei1_R,@TfrmCapDatei1_W,'Datei1');
    RegisterPropertyHelper(@TfrmCapmnuDatei_R,@TfrmCapmnuDatei_W,'mnuDatei');
    RegisterPropertyHelper(@TfrmCapN1_R,@TfrmCapN1_W,'N1');
    RegisterPropertyHelper(@TfrmCapmnuExit_R,@TfrmCapmnuExit_W,'mnuExit');
    RegisterPropertyHelper(@TfrmCapmnuVDevice_R,@TfrmCapmnuVDevice_W,'mnuVDevice');
    RegisterPropertyHelper(@TfrmCapmnuVCompress_R,@TfrmCapmnuVCompress_W,'mnuVCompress');
    RegisterPropertyHelper(@TfrmCapmnuADevice_R,@TfrmCapmnuADevice_W,'mnuADevice');
    RegisterPropertyHelper(@TfrmCapmnuACompress_R,@TfrmCapmnuACompress_W,'mnuACompress');
    RegisterPropertyHelper(@TfrmCapbtnAudioDevProps_R,@TfrmCapbtnAudioDevProps_W,'btnAudioDevProps');
    RegisterPropertyHelper(@TfrmCapbtnAudioComprProps_R,@TfrmCapbtnAudioComprProps_W,'btnAudioComprProps');
    RegisterPropertyHelper(@TfrmCapchkVideoCompress_R,@TfrmCapchkVideoCompress_W,'chkVideoCompress');
    RegisterPropertyHelper(@TfrmCapchkAudioCompress_R,@TfrmCapchkAudioCompress_W,'chkAudioCompress');
    RegisterPropertyHelper(@TfrmCapTimer1_R,@TfrmCapTimer1_W,'Timer1');
    RegisterPropertyHelper(@TfrmCapProgressBar1_R,@TfrmCapProgressBar1_W,'ProgressBar1');
    RegisterPropertyHelper(@TfrmCapPanel2_R,@TfrmCapPanel2_W,'Panel2');
    RegisterPropertyHelper(@TfrmCapedStart_R,@TfrmCapedStart_W,'edStart');
    RegisterPropertyHelper(@TfrmCapedDauer_R,@TfrmCapedDauer_W,'edDauer');
    RegisterPropertyHelper(@TfrmCapLabel1_R,@TfrmCapLabel1_W,'Label1');
    RegisterPropertyHelper(@TfrmCapLabel2_R,@TfrmCapLabel2_W,'Label2');
    RegisterPropertyHelper(@TfrmCapSaveDialog1_R,@TfrmCapSaveDialog1_W,'SaveDialog1');
    RegisterPropertyHelper(@TfrmCapMemo1_R,@TfrmCapMemo1_W,'Memo1');
    RegisterPropertyHelper(@TfrmCapbtnStopCapture_R,@TfrmCapbtnStopCapture_W,'btnStopCapture');
    RegisterMethod(@TfrmCap.FormCreate, 'FormCreate');
    RegisterMethod(@TfrmCap.FormClose, 'FormClose');
    RegisterMethod(@TfrmCap.FormResize, 'FormResize');
    RegisterMethod(@TfrmCap.btnCaptureClick, 'btnCaptureClick');
    RegisterMethod(@TfrmCap.btnPreviewClick, 'btnPreviewClick');
    RegisterMethod(@TfrmCap.btnExitClick, 'btnExitClick');
    RegisterMethod(@TfrmCap.btnVideoComprPropsClick, 'btnVideoComprPropsClick');
    RegisterMethod(@TfrmCap.mnuVDeviceClick, 'mnuVDeviceClick');
    RegisterMethod(@TfrmCap.mnuVCompressClick, 'mnuVCompressClick');
    RegisterMethod(@TfrmCap.mnuADeviceClick, 'mnuADeviceClick');
    RegisterMethod(@TfrmCap.mnuACompressClick, 'mnuACompressClick');
    RegisterMethod(@TfrmCap.btnAudioDevPropsClick, 'btnAudioDevPropsClick');
    RegisterMethod(@TfrmCap.btnAudioComprPropsClick, 'btnAudioComprPropsClick');
    RegisterMethod(@TfrmCap.Timer1Timer, 'Timer1Timer');
    RegisterMethod(@TfrmCap.FormActivate, 'FormActivate');
    RegisterMethod(@TfrmCap.mnuDateiClick, 'mnuDateiClick');
    RegisterMethod(@TfrmCap.btnVideoDevPropsClick, 'btnVideoDevPropsClick');
    RegisterMethod(@TfrmCap.btnStopCaptureClick, 'btnStopCaptureClick');
    RegisterPropertyHelper(@TfrmCapDeviceName_R,@TfrmCapDeviceName_W,'DeviceName');
    RegisterPropertyHelper(@TfrmCapComprName_R,@TfrmCapComprName_W,'ComprName');
    RegisterPropertyHelper(@TfrmCaprtStart_R,@TfrmCaprtStart_W,'rtStart');
    RegisterPropertyHelper(@TfrmCaprtStop_R,@TfrmCaprtStop_W,'rtStop');
    RegisterMethod(@TfrmCap.GetInterfaces, 'GetInterfaces');
    RegisterMethod(@TfrmCap.FindDevice, 'FindDevice');
    RegisterMethod(@TfrmCap.SetupVideoWindow, 'SetupVideoWindow');
    RegisterMethod(@TfrmCap.HandleGraphEvent, 'HandleGraphEvent');
    RegisterMethod(@TfrmCap.Msg, 'Msg');
    RegisterMethod(@TfrmCap.CloseInterfaces, 'CloseInterfaces');
    RegisterMethod(@TfrmCap.ResizeVideoWindow, 'ResizeVideoWindow');
    RegisterMethod(@TfrmCap.InititInterfacesAndFilter, 'InititInterfacesAndFilter');
    RegisterMethod(@TfrmCap.Enumerate, 'Enumerate');
    RegisterMethod(@TfrmCap.FillListDevices, 'FillListDevices');
    RegisterMethod(@TfrmCap.SupportsPropertyPage, 'SupportsPropertyPage');
    RegisterMethod(@TfrmCap.FindFilterFromName, 'FindFilterFromName');
    RegisterMethod(@TfrmCap.WMGrafNotify, 'WMGrafNotify');
    RegisterMethod(@TfrmCap.DisplayECEvent, 'DisplayECEvent');
    RegisterMethod(@TfrmCap.ShowPins, 'ShowPins');
    RegisterMethod(@TfrmCap.ShowFilterProperties, 'ShowFilterProperties');
    RegisterMethod(@TfrmCap.PreviewVideo, 'PreviewVideo');
    RegisterMethod(@TfrmCap.FindNeededFilter, 'FindNeededFilter');
    RegisterMethod(@TfrmCap.FilterLoop, 'FilterLoop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PlayCap(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TfrmCap(CL);
end;

 
 
{ TPSImport_PlayCap }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PlayCap.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PlayCap(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PlayCap.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PlayCap(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
