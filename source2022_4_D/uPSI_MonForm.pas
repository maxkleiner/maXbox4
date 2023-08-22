unit uPSI_MonForm;
{
  TFL #20
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
  TPSImport_MonForm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMonitorForm(CL: TPSPascalCompiler);
procedure SIRegister_MonForm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMonitorForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_MonForm(CL: TPSRuntimeClassImporter);

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
  //,Typinfo
  //,IPCThrd
  ,Buttons
  ,ComCtrls
  ,ExtCtrls
  ,Menus
  ,MonForm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MonForm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMonitorForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TMonitorForm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TMonitorForm') do begin
    RegisterProperty('DownX', 'TLabel', iptrw);
    RegisterProperty('DownY', 'TLabel', iptrw);
    RegisterProperty('SizeX', 'TLabel', iptrw);
    RegisterProperty('SizeY', 'TLabel', iptrw);
    RegisterProperty('MoveX', 'TLabel', iptrw);
    RegisterProperty('MoveY', 'TLabel', iptrw);
    RegisterProperty('Bevel1', 'TBevel', iptrw);
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('PauseButton', 'TSpeedButton', iptrw);
    RegisterProperty('StatusBar', 'TStatusBar', iptrw);
    RegisterProperty('MouseMove', 'TCheckBox', iptrw);
    RegisterProperty('MouseDown', 'TCheckBox', iptrw);
    RegisterProperty('WindowSize', 'TCheckBox', iptrw);
    RegisterProperty('MainMenu', 'TMainMenu', iptrw);
    RegisterProperty('Options1', 'TMenuItem', iptrw);
    RegisterProperty('AutoClientSwitch1', 'TMenuItem', iptrw);
    RegisterProperty('PlaceHolder21', 'TMenuItem', iptrw);
    RegisterProperty('File1', 'TMenuItem', iptrw);
    RegisterProperty('miFileExit', 'TMenuItem', iptrw);
    RegisterProperty('miClients', 'TMenuItem', iptrw);
    RegisterProperty('PlaceHolder1', 'TMenuItem', iptrw);
    RegisterProperty('Help1', 'TMenuItem', iptrw);
    RegisterProperty('About1', 'TMenuItem', iptrw);
    RegisterProperty('ShowTraceButton', 'TSpeedButton', iptrw);
    RegisterProperty('ClearButton', 'TSpeedButton', iptrw);
    RegisterProperty('ExitButton', 'TSpeedButton', iptrw);
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure FormDestroy( Sender : TObject)');
    RegisterMethod('Procedure ClientMenuClick( Sender : TObject)');
    RegisterMethod('Procedure miClientsClick( Sender : TObject)');
    RegisterMethod('Procedure SetTraceFlags( Sender : TObject)');
    RegisterMethod('Procedure AutoClientSwitch1Click( Sender : TObject)');
    RegisterMethod('Procedure miFileExitClick( Sender : TObject)');
    RegisterMethod('Procedure ShowTraceButtonClick( Sender : TObject)');
    RegisterMethod('Procedure PauseButtonClick( Sender : TObject)');
    RegisterMethod('Procedure ClearButtonClick( Sender : TObject)');
    RegisterMethod('Procedure ExitButtonClick( Sender : TObject)');
    RegisterMethod('Procedure About1Click( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MonForm(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('WM_SETTRACEDATA','LongInt').SetInt( WM_USER + 1);
 CL.AddConstantN('WM_UPDATESTATUS','LongInt').SetInt( WM_USER + 2);
 CL.AddConstantN('WM_UPDATEMENU','LongInt').SetInt( WM_USER + 3);
  CL.AddTypeS('TWMTraceData', 'record Msg : Cardinal; X : Smallint; Y : Smallin'
   +'t; Flag : TClientFlag; Result : Longint; end');
  CL.AddTypeS('TLabelRec', 'record XLabel : TLabel; YLabel : TLabel; end');
  SIRegister_TMonitorForm(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMonitorFormExitButton_W(Self: TMonitorForm; const T: TSpeedButton);
Begin Self.ExitButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormExitButton_R(Self: TMonitorForm; var T: TSpeedButton);
Begin T := Self.ExitButton; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormClearButton_W(Self: TMonitorForm; const T: TSpeedButton);
Begin Self.ClearButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormClearButton_R(Self: TMonitorForm; var T: TSpeedButton);
Begin T := Self.ClearButton; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormShowTraceButton_W(Self: TMonitorForm; const T: TSpeedButton);
Begin Self.ShowTraceButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormShowTraceButton_R(Self: TMonitorForm; var T: TSpeedButton);
Begin T := Self.ShowTraceButton; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormAbout1_W(Self: TMonitorForm; const T: TMenuItem);
Begin Self.About1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormAbout1_R(Self: TMonitorForm; var T: TMenuItem);
Begin T := Self.About1; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormHelp1_W(Self: TMonitorForm; const T: TMenuItem);
Begin Self.Help1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormHelp1_R(Self: TMonitorForm; var T: TMenuItem);
Begin T := Self.Help1; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormPlaceHolder1_W(Self: TMonitorForm; const T: TMenuItem);
Begin Self.PlaceHolder1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormPlaceHolder1_R(Self: TMonitorForm; var T: TMenuItem);
Begin T := Self.PlaceHolder1; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormmiClients_W(Self: TMonitorForm; const T: TMenuItem);
Begin Self.miClients := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormmiClients_R(Self: TMonitorForm; var T: TMenuItem);
Begin T := Self.miClients; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormmiFileExit_W(Self: TMonitorForm; const T: TMenuItem);
Begin Self.miFileExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormmiFileExit_R(Self: TMonitorForm; var T: TMenuItem);
Begin T := Self.miFileExit; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormFile1_W(Self: TMonitorForm; const T: TMenuItem);
Begin Self.File1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormFile1_R(Self: TMonitorForm; var T: TMenuItem);
Begin T := Self.File1; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormPlaceHolder21_W(Self: TMonitorForm; const T: TMenuItem);
Begin Self.PlaceHolder21 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormPlaceHolder21_R(Self: TMonitorForm; var T: TMenuItem);
Begin T := Self.PlaceHolder21; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormAutoClientSwitch1_W(Self: TMonitorForm; const T: TMenuItem);
Begin Self.AutoClientSwitch1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormAutoClientSwitch1_R(Self: TMonitorForm; var T: TMenuItem);
Begin T := Self.AutoClientSwitch1; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormOptions1_W(Self: TMonitorForm; const T: TMenuItem);
Begin Self.Options1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormOptions1_R(Self: TMonitorForm; var T: TMenuItem);
Begin T := Self.Options1; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormMainMenu_W(Self: TMonitorForm; const T: TMainMenu);
Begin Self.MainMenu := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormMainMenu_R(Self: TMonitorForm; var T: TMainMenu);
Begin T := Self.MainMenu; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormWindowSize_W(Self: TMonitorForm; const T: TCheckBox);
Begin Self.WindowSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormWindowSize_R(Self: TMonitorForm; var T: TCheckBox);
Begin T := Self.WindowSize; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormMouseDown_W(Self: TMonitorForm; const T: TCheckBox);
Begin Self.MouseDown := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormMouseDown_R(Self: TMonitorForm; var T: TCheckBox);
Begin T := Self.MouseDown; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormMouseMove_W(Self: TMonitorForm; const T: TCheckBox);
Begin Self.MouseMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormMouseMove_R(Self: TMonitorForm; var T: TCheckBox);
Begin T := Self.MouseMove; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormStatusBar_W(Self: TMonitorForm; const T: TStatusBar);
Begin Self.StatusBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormStatusBar_R(Self: TMonitorForm; var T: TStatusBar);
Begin T := Self.StatusBar; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormPauseButton_W(Self: TMonitorForm; const T: TSpeedButton);
Begin Self.PauseButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormPauseButton_R(Self: TMonitorForm; var T: TSpeedButton);
Begin T := Self.PauseButton; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormPanel1_W(Self: TMonitorForm; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormPanel1_R(Self: TMonitorForm; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormBevel1_W(Self: TMonitorForm; const T: TBevel);
Begin Self.Bevel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormBevel1_R(Self: TMonitorForm; var T: TBevel);
Begin T := Self.Bevel1; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormMoveY_W(Self: TMonitorForm; const T: TLabel);
Begin Self.MoveY := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormMoveY_R(Self: TMonitorForm; var T: TLabel);
Begin T := Self.MoveY; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormMoveX_W(Self: TMonitorForm; const T: TLabel);
Begin Self.MoveX := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormMoveX_R(Self: TMonitorForm; var T: TLabel);
Begin T := Self.MoveX; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormSizeY_W(Self: TMonitorForm; const T: TLabel);
Begin Self.SizeY := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormSizeY_R(Self: TMonitorForm; var T: TLabel);
Begin T := Self.SizeY; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormSizeX_W(Self: TMonitorForm; const T: TLabel);
Begin Self.SizeX := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormSizeX_R(Self: TMonitorForm; var T: TLabel);
Begin T := Self.SizeX; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormDownY_W(Self: TMonitorForm; const T: TLabel);
Begin Self.DownY := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormDownY_R(Self: TMonitorForm; var T: TLabel);
Begin T := Self.DownY; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormDownX_W(Self: TMonitorForm; const T: TLabel);
Begin Self.DownX := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorFormDownX_R(Self: TMonitorForm; var T: TLabel);
Begin T := Self.DownX; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMonitorForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMonitorForm) do
  begin
    RegisterPropertyHelper(@TMonitorFormDownX_R,@TMonitorFormDownX_W,'DownX');
    RegisterPropertyHelper(@TMonitorFormDownY_R,@TMonitorFormDownY_W,'DownY');
    RegisterPropertyHelper(@TMonitorFormSizeX_R,@TMonitorFormSizeX_W,'SizeX');
    RegisterPropertyHelper(@TMonitorFormSizeY_R,@TMonitorFormSizeY_W,'SizeY');
    RegisterPropertyHelper(@TMonitorFormMoveX_R,@TMonitorFormMoveX_W,'MoveX');
    RegisterPropertyHelper(@TMonitorFormMoveY_R,@TMonitorFormMoveY_W,'MoveY');
    RegisterPropertyHelper(@TMonitorFormBevel1_R,@TMonitorFormBevel1_W,'Bevel1');
    RegisterPropertyHelper(@TMonitorFormPanel1_R,@TMonitorFormPanel1_W,'Panel1');
    RegisterPropertyHelper(@TMonitorFormPauseButton_R,@TMonitorFormPauseButton_W,'PauseButton');
    RegisterPropertyHelper(@TMonitorFormStatusBar_R,@TMonitorFormStatusBar_W,'StatusBar');
    RegisterPropertyHelper(@TMonitorFormMouseMove_R,@TMonitorFormMouseMove_W,'MouseMove');
    RegisterPropertyHelper(@TMonitorFormMouseDown_R,@TMonitorFormMouseDown_W,'MouseDown');
    RegisterPropertyHelper(@TMonitorFormWindowSize_R,@TMonitorFormWindowSize_W,'WindowSize');
    RegisterPropertyHelper(@TMonitorFormMainMenu_R,@TMonitorFormMainMenu_W,'MainMenu');
    RegisterPropertyHelper(@TMonitorFormOptions1_R,@TMonitorFormOptions1_W,'Options1');
    RegisterPropertyHelper(@TMonitorFormAutoClientSwitch1_R,@TMonitorFormAutoClientSwitch1_W,'AutoClientSwitch1');
    RegisterPropertyHelper(@TMonitorFormPlaceHolder21_R,@TMonitorFormPlaceHolder21_W,'PlaceHolder21');
    RegisterPropertyHelper(@TMonitorFormFile1_R,@TMonitorFormFile1_W,'File1');
    RegisterPropertyHelper(@TMonitorFormmiFileExit_R,@TMonitorFormmiFileExit_W,'miFileExit');
    RegisterPropertyHelper(@TMonitorFormmiClients_R,@TMonitorFormmiClients_W,'miClients');
    RegisterPropertyHelper(@TMonitorFormPlaceHolder1_R,@TMonitorFormPlaceHolder1_W,'PlaceHolder1');
    RegisterPropertyHelper(@TMonitorFormHelp1_R,@TMonitorFormHelp1_W,'Help1');
    RegisterPropertyHelper(@TMonitorFormAbout1_R,@TMonitorFormAbout1_W,'About1');
    RegisterPropertyHelper(@TMonitorFormShowTraceButton_R,@TMonitorFormShowTraceButton_W,'ShowTraceButton');
    RegisterPropertyHelper(@TMonitorFormClearButton_R,@TMonitorFormClearButton_W,'ClearButton');
    RegisterPropertyHelper(@TMonitorFormExitButton_R,@TMonitorFormExitButton_W,'ExitButton');
    RegisterMethod(@TMonitorForm.FormCreate, 'FormCreate');
    RegisterMethod(@TMonitorForm.FormDestroy, 'FormDestroy');
    RegisterMethod(@TMonitorForm.ClientMenuClick, 'ClientMenuClick');
    RegisterMethod(@TMonitorForm.miClientsClick, 'miClientsClick');
    RegisterMethod(@TMonitorForm.SetTraceFlags, 'SetTraceFlags');
    RegisterMethod(@TMonitorForm.AutoClientSwitch1Click, 'AutoClientSwitch1Click');
    RegisterMethod(@TMonitorForm.miFileExitClick, 'miFileExitClick');
    RegisterMethod(@TMonitorForm.ShowTraceButtonClick, 'ShowTraceButtonClick');
    RegisterMethod(@TMonitorForm.PauseButtonClick, 'PauseButtonClick');
    RegisterMethod(@TMonitorForm.ClearButtonClick, 'ClearButtonClick');
    RegisterMethod(@TMonitorForm.ExitButtonClick, 'ExitButtonClick');
    RegisterMethod(@TMonitorForm.About1Click, 'About1Click');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MonForm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMonitorForm(CL);
end;

 
 
{ TPSImport_MonForm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MonForm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MonForm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MonForm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MonForm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
