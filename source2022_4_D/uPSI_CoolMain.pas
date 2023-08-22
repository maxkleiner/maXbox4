unit uPSI_CoolMain;
{
   web for box
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
  TPSImport_CoolMain = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TwebMainForm(CL: TPSPascalCompiler);
procedure SIRegister_CoolMain(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TwebMainForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoolMain(CL: TPSRuntimeClassImporter);

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
  ,ExtCtrls
  ,Menus
  ,ComCtrls
  ,OleCtrls
  ,Buttons
  ,ToolWin
  ,ActnList
  ,ImgList
  ,SHDocVw
  ,CoolMain
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CoolMain]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TwebMainForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TwebMainForm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TwebMainForm') do begin
    RegisterProperty('StatusBar1', 'TStatusBar', iptrw);
    RegisterProperty('MainMenu1', 'TMainMenu', iptrw);
    RegisterProperty('File1', 'TMenuItem', iptrw);
    RegisterProperty('Exit1', 'TMenuItem', iptrw);
    RegisterProperty('View1', 'TMenuItem', iptrw);
    RegisterProperty('NavigatorImages', 'TImageList', iptrw);
    RegisterProperty('NavigatorHotImages', 'TImageList', iptrw);
    RegisterProperty('LinksImages', 'TImageList', iptrw);
    RegisterProperty('LinksHotImages', 'TImageList', iptrw);
    RegisterProperty('CoolBar1', 'TCoolBar', iptrw);
    RegisterProperty('ToolBar1', 'TToolBar', iptrw);
    RegisterProperty('BackBtn', 'TToolButton', iptrw);
    RegisterProperty('ForwardBtn', 'TToolButton', iptrw);
    RegisterProperty('StopBtn', 'TToolButton', iptrw);
    RegisterProperty('RefreshBtn', 'TToolButton', iptrw);
    RegisterProperty('ToolBar2', 'TToolBar', iptrw);
    RegisterProperty('ToolButton6', 'TToolButton', iptrw);
    RegisterProperty('ToolButton5', 'TToolButton', iptrw);
    RegisterProperty('ToolButton7', 'TToolButton', iptrw);
    RegisterProperty('ToolButton8', 'TToolButton', iptrw);
    RegisterProperty('Animate1', 'TAnimate', iptrw);
    RegisterProperty('URLs', 'TComboBox', iptrw);
    RegisterProperty('Help1', 'TMenuItem', iptrw);
    RegisterProperty('About1', 'TMenuItem', iptrw);
    RegisterProperty('Toolbar3', 'TMenuItem', iptrw);
    RegisterProperty('Statusbar2', 'TMenuItem', iptrw);
    RegisterProperty('Go1', 'TMenuItem', iptrw);
    RegisterProperty('Back1', 'TMenuItem', iptrw);
    RegisterProperty('Forward1', 'TMenuItem', iptrw);
    RegisterProperty('Stop1', 'TMenuItem', iptrw);
    RegisterProperty('Refresh1', 'TMenuItem', iptrw);
    RegisterProperty('N2', 'TMenuItem', iptrw);
    RegisterProperty('ActionList1', 'TActionList', iptrw);
    RegisterProperty('BackAction', 'TAction', iptrw);
    RegisterProperty('ForwardAction', 'TAction', iptrw);
    RegisterProperty('StopAction', 'TAction', iptrw);
    RegisterProperty('RefreshAction', 'TAction', iptrw);
    RegisterProperty('WebBrowser1', 'TWebBrowser', iptrw);
    RegisterMethod('Procedure Exit1Click( Sender : TObject)');
    RegisterMethod('Procedure About1Click( Sender : TObject)');
    RegisterMethod('Procedure StopClick( Sender : TObject)');
    RegisterMethod('Procedure URLsKeyDown( Sender : TObject; var Key : Word; Shift : TShiftState)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure LinksClick( Sender : TObject)');
    RegisterMethod('Procedure RefreshClick( Sender : TObject)');
    RegisterMethod('Procedure BackClick( Sender : TObject)');
    RegisterMethod('Procedure ForwardClick( Sender : TObject)');
    RegisterMethod('Procedure FormDestroy( Sender : TObject)');
    RegisterMethod('Procedure URLsClick( Sender : TObject)');
    RegisterMethod('Procedure FormKeyDown( Sender : TObject; var Key : Word; Shift : TShiftState)');
    RegisterMethod('Procedure Toolbar3Click( Sender : TObject)');
    RegisterMethod('Procedure Statusbar2Click( Sender : TObject)');
    RegisterMethod('Procedure BackActionUpdate( Sender : TObject)');
    RegisterMethod('Procedure ForwardActionUpdate( Sender : TObject)');
    RegisterMethod('Procedure WebBrowser1BeforeNavigate2( Sender : TObject; const pDisp : IDispatch; var URL, Flags, TargetFrameName, PostData, Headers : OleVariant; var Cancel : WordBool)');
    RegisterMethod('Procedure WebBrowser1DownloadBegin( Sender : TObject)');
    RegisterMethod('Procedure WebBrowser1DownloadComplete( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoolMain(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('CM_HOMEPAGEREQUEST','LongWord').SetUInt( WM_USER + $1000);
  SIRegister_TwebMainForm(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TwebMainFormWebBrowser1_W(Self: TwebMainForm; const T: TWebBrowser);
Begin Self.WebBrowser1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormWebBrowser1_R(Self: TwebMainForm; var T: TWebBrowser);
Begin T := Self.WebBrowser1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormRefreshAction_W(Self: TwebMainForm; const T: TAction);
Begin Self.RefreshAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormRefreshAction_R(Self: TwebMainForm; var T: TAction);
Begin T := Self.RefreshAction; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormStopAction_W(Self: TwebMainForm; const T: TAction);
Begin Self.StopAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormStopAction_R(Self: TwebMainForm; var T: TAction);
Begin T := Self.StopAction; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormForwardAction_W(Self: TwebMainForm; const T: TAction);
Begin Self.ForwardAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormForwardAction_R(Self: TwebMainForm; var T: TAction);
Begin T := Self.ForwardAction; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormBackAction_W(Self: TwebMainForm; const T: TAction);
Begin Self.BackAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormBackAction_R(Self: TwebMainForm; var T: TAction);
Begin T := Self.BackAction; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormActionList1_W(Self: TwebMainForm; const T: TActionList);
Begin Self.ActionList1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormActionList1_R(Self: TwebMainForm; var T: TActionList);
Begin T := Self.ActionList1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormN2_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.N2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormN2_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.N2; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormRefresh1_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.Refresh1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormRefresh1_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.Refresh1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormStop1_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.Stop1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormStop1_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.Stop1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormForward1_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.Forward1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormForward1_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.Forward1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormBack1_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.Back1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormBack1_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.Back1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormGo1_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.Go1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormGo1_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.Go1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormStatusbar2_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.Statusbar2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormStatusbar2_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.Statusbar2; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolbar3_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.Toolbar3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolbar3_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.Toolbar3; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormAbout1_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.About1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormAbout1_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.About1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormHelp1_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.Help1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormHelp1_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.Help1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormURLs_W(Self: TwebMainForm; const T: TComboBox);
Begin Self.URLs := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormURLs_R(Self: TwebMainForm; var T: TComboBox);
Begin T := Self.URLs; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormAnimate1_W(Self: TwebMainForm; const T: TAnimate);
Begin Self.Animate1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormAnimate1_R(Self: TwebMainForm; var T: TAnimate);
Begin T := Self.Animate1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolButton8_W(Self: TwebMainForm; const T: TToolButton);
Begin Self.ToolButton8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolButton8_R(Self: TwebMainForm; var T: TToolButton);
Begin T := Self.ToolButton8; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolButton7_W(Self: TwebMainForm; const T: TToolButton);
Begin Self.ToolButton7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolButton7_R(Self: TwebMainForm; var T: TToolButton);
Begin T := Self.ToolButton7; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolButton5_W(Self: TwebMainForm; const T: TToolButton);
Begin Self.ToolButton5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolButton5_R(Self: TwebMainForm; var T: TToolButton);
Begin T := Self.ToolButton5; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolButton6_W(Self: TwebMainForm; const T: TToolButton);
Begin Self.ToolButton6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolButton6_R(Self: TwebMainForm; var T: TToolButton);
Begin T := Self.ToolButton6; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolBar2_W(Self: TwebMainForm; const T: TToolBar);
Begin Self.ToolBar2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolBar2_R(Self: TwebMainForm; var T: TToolBar);
Begin T := Self.ToolBar2; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormRefreshBtn_W(Self: TwebMainForm; const T: TToolButton);
Begin Self.RefreshBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormRefreshBtn_R(Self: TwebMainForm; var T: TToolButton);
Begin T := Self.RefreshBtn; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormStopBtn_W(Self: TwebMainForm; const T: TToolButton);
Begin Self.StopBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormStopBtn_R(Self: TwebMainForm; var T: TToolButton);
Begin T := Self.StopBtn; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormForwardBtn_W(Self: TwebMainForm; const T: TToolButton);
Begin Self.ForwardBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormForwardBtn_R(Self: TwebMainForm; var T: TToolButton);
Begin T := Self.ForwardBtn; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormBackBtn_W(Self: TwebMainForm; const T: TToolButton);
Begin Self.BackBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormBackBtn_R(Self: TwebMainForm; var T: TToolButton);
Begin T := Self.BackBtn; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolBar1_W(Self: TwebMainForm; const T: TToolBar);
Begin Self.ToolBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormToolBar1_R(Self: TwebMainForm; var T: TToolBar);
Begin T := Self.ToolBar1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormCoolBar1_W(Self: TwebMainForm; const T: TCoolBar);
Begin Self.CoolBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormCoolBar1_R(Self: TwebMainForm; var T: TCoolBar);
Begin T := Self.CoolBar1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormLinksHotImages_W(Self: TwebMainForm; const T: TImageList);
Begin Self.LinksHotImages := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormLinksHotImages_R(Self: TwebMainForm; var T: TImageList);
Begin T := Self.LinksHotImages; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormLinksImages_W(Self: TwebMainForm; const T: TImageList);
Begin Self.LinksImages := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormLinksImages_R(Self: TwebMainForm; var T: TImageList);
Begin T := Self.LinksImages; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormNavigatorHotImages_W(Self: TwebMainForm; const T: TImageList);
Begin Self.NavigatorHotImages := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormNavigatorHotImages_R(Self: TwebMainForm; var T: TImageList);
Begin T := Self.NavigatorHotImages; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormNavigatorImages_W(Self: TwebMainForm; const T: TImageList);
Begin Self.NavigatorImages := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormNavigatorImages_R(Self: TwebMainForm; var T: TImageList);
Begin T := Self.NavigatorImages; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormView1_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.View1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormView1_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.View1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormExit1_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.Exit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormExit1_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.Exit1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormFile1_W(Self: TwebMainForm; const T: TMenuItem);
Begin Self.File1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormFile1_R(Self: TwebMainForm; var T: TMenuItem);
Begin T := Self.File1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormMainMenu1_W(Self: TwebMainForm; const T: TMainMenu);
Begin Self.MainMenu1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormMainMenu1_R(Self: TwebMainForm; var T: TMainMenu);
Begin T := Self.MainMenu1; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormStatusBar1_W(Self: TwebMainForm; const T: TStatusBar);
Begin Self.StatusBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwebMainFormStatusBar1_R(Self: TwebMainForm; var T: TStatusBar);
Begin T := Self.StatusBar1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TwebMainForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TwebMainForm) do
  begin
    RegisterPropertyHelper(@TwebMainFormStatusBar1_R,@TwebMainFormStatusBar1_W,'StatusBar1');
    RegisterPropertyHelper(@TwebMainFormMainMenu1_R,@TwebMainFormMainMenu1_W,'MainMenu1');
    RegisterPropertyHelper(@TwebMainFormFile1_R,@TwebMainFormFile1_W,'File1');
    RegisterPropertyHelper(@TwebMainFormExit1_R,@TwebMainFormExit1_W,'Exit1');
    RegisterPropertyHelper(@TwebMainFormView1_R,@TwebMainFormView1_W,'View1');
    RegisterPropertyHelper(@TwebMainFormNavigatorImages_R,@TwebMainFormNavigatorImages_W,'NavigatorImages');
    RegisterPropertyHelper(@TwebMainFormNavigatorHotImages_R,@TwebMainFormNavigatorHotImages_W,'NavigatorHotImages');
    RegisterPropertyHelper(@TwebMainFormLinksImages_R,@TwebMainFormLinksImages_W,'LinksImages');
    RegisterPropertyHelper(@TwebMainFormLinksHotImages_R,@TwebMainFormLinksHotImages_W,'LinksHotImages');
    RegisterPropertyHelper(@TwebMainFormCoolBar1_R,@TwebMainFormCoolBar1_W,'CoolBar1');
    RegisterPropertyHelper(@TwebMainFormToolBar1_R,@TwebMainFormToolBar1_W,'ToolBar1');
    RegisterPropertyHelper(@TwebMainFormBackBtn_R,@TwebMainFormBackBtn_W,'BackBtn');
    RegisterPropertyHelper(@TwebMainFormForwardBtn_R,@TwebMainFormForwardBtn_W,'ForwardBtn');
    RegisterPropertyHelper(@TwebMainFormStopBtn_R,@TwebMainFormStopBtn_W,'StopBtn');
    RegisterPropertyHelper(@TwebMainFormRefreshBtn_R,@TwebMainFormRefreshBtn_W,'RefreshBtn');
    RegisterPropertyHelper(@TwebMainFormToolBar2_R,@TwebMainFormToolBar2_W,'ToolBar2');
    RegisterPropertyHelper(@TwebMainFormToolButton6_R,@TwebMainFormToolButton6_W,'ToolButton6');
    RegisterPropertyHelper(@TwebMainFormToolButton5_R,@TwebMainFormToolButton5_W,'ToolButton5');
    RegisterPropertyHelper(@TwebMainFormToolButton7_R,@TwebMainFormToolButton7_W,'ToolButton7');
    RegisterPropertyHelper(@TwebMainFormToolButton8_R,@TwebMainFormToolButton8_W,'ToolButton8');
    RegisterPropertyHelper(@TwebMainFormAnimate1_R,@TwebMainFormAnimate1_W,'Animate1');
    RegisterPropertyHelper(@TwebMainFormURLs_R,@TwebMainFormURLs_W,'URLs');
    RegisterPropertyHelper(@TwebMainFormHelp1_R,@TwebMainFormHelp1_W,'Help1');
    RegisterPropertyHelper(@TwebMainFormAbout1_R,@TwebMainFormAbout1_W,'About1');
    RegisterPropertyHelper(@TwebMainFormToolbar3_R,@TwebMainFormToolbar3_W,'Toolbar3');
    RegisterPropertyHelper(@TwebMainFormStatusbar2_R,@TwebMainFormStatusbar2_W,'Statusbar2');
    RegisterPropertyHelper(@TwebMainFormGo1_R,@TwebMainFormGo1_W,'Go1');
    RegisterPropertyHelper(@TwebMainFormBack1_R,@TwebMainFormBack1_W,'Back1');
    RegisterPropertyHelper(@TwebMainFormForward1_R,@TwebMainFormForward1_W,'Forward1');
    RegisterPropertyHelper(@TwebMainFormStop1_R,@TwebMainFormStop1_W,'Stop1');
    RegisterPropertyHelper(@TwebMainFormRefresh1_R,@TwebMainFormRefresh1_W,'Refresh1');
    RegisterPropertyHelper(@TwebMainFormN2_R,@TwebMainFormN2_W,'N2');
    RegisterPropertyHelper(@TwebMainFormActionList1_R,@TwebMainFormActionList1_W,'ActionList1');
    RegisterPropertyHelper(@TwebMainFormBackAction_R,@TwebMainFormBackAction_W,'BackAction');
    RegisterPropertyHelper(@TwebMainFormForwardAction_R,@TwebMainFormForwardAction_W,'ForwardAction');
    RegisterPropertyHelper(@TwebMainFormStopAction_R,@TwebMainFormStopAction_W,'StopAction');
    RegisterPropertyHelper(@TwebMainFormRefreshAction_R,@TwebMainFormRefreshAction_W,'RefreshAction');
    RegisterPropertyHelper(@TwebMainFormWebBrowser1_R,@TwebMainFormWebBrowser1_W,'WebBrowser1');
    RegisterMethod(@TwebMainForm.Exit1Click, 'Exit1Click');
    RegisterMethod(@TwebMainForm.About1Click, 'About1Click');
    RegisterMethod(@TwebMainForm.StopClick, 'StopClick');
    RegisterMethod(@TwebMainForm.URLsKeyDown, 'URLsKeyDown');
    RegisterMethod(@TwebMainForm.FormCreate, 'FormCreate');
    RegisterMethod(@TwebMainForm.LinksClick, 'LinksClick');
    RegisterMethod(@TwebMainForm.RefreshClick, 'RefreshClick');
    RegisterMethod(@TwebMainForm.BackClick, 'BackClick');
    RegisterMethod(@TwebMainForm.ForwardClick, 'ForwardClick');
    RegisterMethod(@TwebMainForm.FormDestroy, 'FormDestroy');
    RegisterMethod(@TwebMainForm.URLsClick, 'URLsClick');
    RegisterMethod(@TwebMainForm.FormKeyDown, 'FormKeyDown');
    RegisterMethod(@TwebMainForm.Toolbar3Click, 'Toolbar3Click');
    RegisterMethod(@TwebMainForm.Statusbar2Click, 'Statusbar2Click');
    RegisterMethod(@TwebMainForm.BackActionUpdate, 'BackActionUpdate');
    RegisterMethod(@TwebMainForm.ForwardActionUpdate, 'ForwardActionUpdate');
    RegisterMethod(@TwebMainForm.WebBrowser1BeforeNavigate2, 'WebBrowser1BeforeNavigate2');
    RegisterMethod(@TwebMainForm.WebBrowser1DownloadBegin, 'WebBrowser1DownloadBegin');
    RegisterMethod(@TwebMainForm.WebBrowser1DownloadComplete, 'WebBrowser1DownloadComplete');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoolMain(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TwebMainForm(CL);
end;

 
 
{ TPSImport_CoolMain }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CoolMain.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CoolMain(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CoolMain.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CoolMain(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
