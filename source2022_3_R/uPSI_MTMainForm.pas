unit uPSI_MTMainForm;
{
  terminal form term
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
  TPSImport_MTMainForm = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMainForm(CL: TPSPascalCompiler);
procedure SIRegister_MTMainForm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMainForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_MTMainForm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,CPort
  ,StdCtrls
  ,CPortCtl
  ,ExtCtrls
  ,Menus
  ,IniFiles
  ,ComCtrls
  ,MTMainForm
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MTMainForm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMainForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TMainForm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TvtMainForm') do begin
    RegisterProperty('Panel', 'TPanel', iptrw);
    RegisterProperty('ComTerminal', 'TComTerminal', iptrw);
    RegisterProperty('ConnButton', 'TButton', iptrw);
    RegisterProperty('ComPort', 'TComPort', iptrw);
    RegisterProperty('PortButton', 'TButton', iptrw);
    RegisterProperty('TermButton', 'TButton', iptrw);
    RegisterProperty('FontButton', 'TButton', iptrw);
    RegisterProperty('TerminalReady', 'TComLed', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('ComLed1', 'TComLed', iptrw);
    RegisterProperty('PopupMenu1', 'TPopupMenu', iptrw);
    RegisterProperty('Copy1', 'TMenuItem', iptrw);
    RegisterProperty('Paste1', 'TMenuItem', iptrw);
    RegisterProperty('Button1', 'TButton', iptrw);
    RegisterProperty('ComDataPacket1', 'TComDataPacket', iptrw);
    RegisterProperty('StatusBar1', 'TStatusBar', iptrw);
    RegisterMethod('Procedure ConnButtonClick( Sender : TObject)');
    RegisterMethod('Procedure ComPortAfterOpen( Sender : TObject)');
    RegisterMethod('Procedure ComPortAfterClose( Sender : TObject)');
    RegisterMethod('Procedure PortButtonClick( Sender : TObject)');
    RegisterMethod('Procedure TermButtonClick( Sender : TObject)');
    RegisterMethod('Procedure FontButtonClick( Sender : TObject)');
    RegisterMethod('Procedure Paste1Click( Sender : TObject)');
    RegisterMethod('Procedure FormShow( Sender : TObject)');
    RegisterMethod('Procedure FormClose( Sender : TObject; var Action : TCloseAction)');
    RegisterMethod('Procedure Button1Click( Sender : TObject)');
    RegisterMethod('Procedure ComDataPacket1Packet( Sender : TObject; const Str : string)');
    RegisterMethod('Procedure ComDataPacket1CustomStart( Sender : TObject; const Str : string; var Pos : Integer)');
    RegisterMethod('Procedure ComDataPacket1CustomStop( Sender : TObject; const Str : string; var Pos : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MTMainForm(CL: TPSPascalCompiler);
begin
  SIRegister_TMainForm(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMainFormStatusBar1_W(Self: TvtMainForm; const T: TStatusBar);
Begin Self.StatusBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormStatusBar1_R(Self: TvtMainForm; var T: TStatusBar);
Begin T := Self.StatusBar1; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormComDataPacket1_W(Self: TvtMainForm; const T: TComDataPacket);
Begin Self.ComDataPacket1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormComDataPacket1_R(Self: TvtMainForm; var T: TComDataPacket);
Begin T := Self.ComDataPacket1; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormButton1_W(Self: TvtMainForm; const T: TButton);
Begin Self.Button1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormButton1_R(Self: TvtMainForm; var T: TButton);
Begin T := Self.Button1; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormPaste1_W(Self: TvtMainForm; const T: TMenuItem);
Begin Self.Paste1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormPaste1_R(Self: TvtMainForm; var T: TMenuItem);
Begin T := Self.Paste1; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormCopy1_W(Self: TvtMainForm; const T: TMenuItem);
Begin Self.Copy1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormCopy1_R(Self: TvtMainForm; var T: TMenuItem);
Begin T := Self.Copy1; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormPopupMenu1_W(Self: TvtMainForm; const T: TPopupMenu);
Begin Self.PopupMenu1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormPopupMenu1_R(Self: TvtMainForm; var T: TPopupMenu);
Begin T := Self.PopupMenu1; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormComLed1_W(Self: TvtMainForm; const T: TComLed);
Begin Self.ComLed1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormComLed1_R(Self: TvtMainForm; var T: TComLed);
Begin T := Self.ComLed1; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormLabel2_W(Self: TvtMainForm; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormLabel2_R(Self: TvtMainForm; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormLabel1_W(Self: TvtMainForm; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormLabel1_R(Self: TvtMainForm; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormTerminalReady_W(Self: TvtMainForm; const T: TComLed);
Begin Self.TerminalReady := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormTerminalReady_R(Self: TvtMainForm; var T: TComLed);
Begin T := Self.TerminalReady; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormFontButton_W(Self: TvtMainForm; const T: TButton);
Begin Self.FontButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormFontButton_R(Self: TvtMainForm; var T: TButton);
Begin T := Self.FontButton; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormTermButton_W(Self: TvtMainForm; const T: TButton);
Begin Self.TermButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormTermButton_R(Self: TvtMainForm; var T: TButton);
Begin T := Self.TermButton; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormPortButton_W(Self: TvtMainForm; const T: TButton);
Begin Self.PortButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormPortButton_R(Self: TvtMainForm; var T: TButton);
Begin T := Self.PortButton; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormComPort_W(Self: TvtMainForm; const T: TComPort);
Begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormComPort_R(Self: TvtMainForm; var T: TComPort);
Begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormConnButton_W(Self: TvtMainForm; const T: TButton);
Begin Self.ConnButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormConnButton_R(Self: TvtMainForm; var T: TButton);
Begin T := Self.ConnButton; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormComTerminal_W(Self: TvtMainForm; const T: TComTerminal);
Begin Self.ComTerminal := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormComTerminal_R(Self: TvtMainForm; var T: TComTerminal);
Begin T := Self.ComTerminal; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormPanel_W(Self: TvtMainForm; const T: TPanel);
Begin Self.Panel := T; end;

(*----------------------------------------------------------------------------*)
procedure TMainFormPanel_R(Self: TvtMainForm; var T: TPanel);
Begin T := Self.Panel; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMainForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TvtMainForm) do begin
    RegisterPropertyHelper(@TMainFormPanel_R,@TMainFormPanel_W,'Panel');
    RegisterPropertyHelper(@TMainFormComTerminal_R,@TMainFormComTerminal_W,'ComTerminal');
    RegisterPropertyHelper(@TMainFormConnButton_R,@TMainFormConnButton_W,'ConnButton');
    RegisterPropertyHelper(@TMainFormComPort_R,@TMainFormComPort_W,'ComPort');
    RegisterPropertyHelper(@TMainFormPortButton_R,@TMainFormPortButton_W,'PortButton');
    RegisterPropertyHelper(@TMainFormTermButton_R,@TMainFormTermButton_W,'TermButton');
    RegisterPropertyHelper(@TMainFormFontButton_R,@TMainFormFontButton_W,'FontButton');
    RegisterPropertyHelper(@TMainFormTerminalReady_R,@TMainFormTerminalReady_W,'TerminalReady');
    RegisterPropertyHelper(@TMainFormLabel1_R,@TMainFormLabel1_W,'Label1');
    RegisterPropertyHelper(@TMainFormLabel2_R,@TMainFormLabel2_W,'Label2');
    RegisterPropertyHelper(@TMainFormComLed1_R,@TMainFormComLed1_W,'ComLed1');
    RegisterPropertyHelper(@TMainFormPopupMenu1_R,@TMainFormPopupMenu1_W,'PopupMenu1');
    RegisterPropertyHelper(@TMainFormCopy1_R,@TMainFormCopy1_W,'Copy1');
    RegisterPropertyHelper(@TMainFormPaste1_R,@TMainFormPaste1_W,'Paste1');
    RegisterPropertyHelper(@TMainFormButton1_R,@TMainFormButton1_W,'Button1');
    RegisterPropertyHelper(@TMainFormComDataPacket1_R,@TMainFormComDataPacket1_W,'ComDataPacket1');
    RegisterPropertyHelper(@TMainFormStatusBar1_R,@TMainFormStatusBar1_W,'StatusBar1');
    RegisterMethod(@TvtMainForm.ConnButtonClick, 'ConnButtonClick');
    RegisterMethod(@TvtMainForm.ComPortAfterOpen, 'ComPortAfterOpen');
    RegisterMethod(@TvtMainForm.ComPortAfterClose, 'ComPortAfterClose');
    RegisterMethod(@TvtMainForm.PortButtonClick, 'PortButtonClick');
    RegisterMethod(@TvtMainForm.TermButtonClick, 'TermButtonClick');
    RegisterMethod(@TvtMainForm.FontButtonClick, 'FontButtonClick');
    RegisterMethod(@TvtMainForm.Paste1Click, 'Paste1Click');
    RegisterMethod(@TvtMainForm.FormShow, 'FormShow');
    RegisterMethod(@TvtMainForm.FormClose, 'FormClose');
    RegisterMethod(@TvtMainForm.Button1Click, 'Button1Click');
    RegisterMethod(@TvtMainForm.ComDataPacket1Packet, 'ComDataPacket1Packet');
    RegisterMethod(@TvtMainForm.ComDataPacket1CustomStart, 'ComDataPacket1CustomStart');
    RegisterMethod(@TvtMainForm.ComDataPacket1CustomStop, 'ComDataPacket1CustomStop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MTMainForm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMainForm(CL);
end;

 
 
{ TPSImport_MTMainForm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MTMainForm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MTMainForm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MTMainForm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MTMainForm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
