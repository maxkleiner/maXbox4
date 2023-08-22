unit uPSI_delphi_arduino_Unit1;
{
   arduino tester
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
  TPSImport_delphi_arduino_Unit1 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
procedure SIRegister_delphi_arduino_Unit1(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
procedure RIRegister_delphi_arduino_Unit1(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Variants
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,ComCtrls
  ,CPort
  ,CPortCtl
  ,Menus
  ,delphi_arduino_Unit1
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_delphi_arduino_Unit1]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TForm1') do
  with CL.AddClassN(CL.FindClass('TForm'),'TledForm') do
  begin
    RegisterProperty('btn_connect', 'TButton', iptrw);
    RegisterProperty('ComPort1', 'TComPort', iptrw);
    RegisterProperty('StatusBar1', 'TStatusBar', iptrw);
    RegisterProperty('btn_Setup', 'TButton', iptrw);
    RegisterProperty('chk_led1', 'TCheckBox', iptrw);
    RegisterProperty('chk_led2', 'TCheckBox', iptrw);
    RegisterProperty('chk_led3', 'TCheckBox', iptrw);
    RegisterProperty('chk_led4', 'TCheckBox', iptrw);
    RegisterProperty('chk_led5', 'TCheckBox', iptrw);
    RegisterProperty('btn_loop', 'TButton', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('Label5', 'TLabel', iptrw);
    RegisterProperty('Label6', 'TLabel', iptrw);
    RegisterProperty('Label7', 'TLabel', iptrw);
    RegisterProperty('Label8', 'TLabel', iptrw);
    RegisterProperty('Label9', 'TLabel', iptrw);
    RegisterProperty('Label10', 'TLabel', iptrw);
    RegisterProperty('Label11', 'TLabel', iptrw);
    RegisterProperty('Label12', 'TLabel', iptrw);
    RegisterMethod('Procedure btn_connectClick( Sender : TObject)');
    RegisterMethod('Procedure btn_SetupClick( Sender : TObject)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure chk_led1Click( Sender : TObject)');
    RegisterMethod('Procedure chk_led2Click( Sender : TObject)');
    RegisterMethod('Procedure chk_led3Click( Sender : TObject)');
    RegisterMethod('Procedure chk_led4Click( Sender : TObject)');
    RegisterMethod('Procedure chk_led5Click( Sender : TObject)');
    RegisterMethod('Procedure FormClose( Sender : TObject; var Action : TCloseAction)');
    RegisterMethod('Procedure btn_loopClick( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_delphi_arduino_Unit1(CL: TPSPascalCompiler);
begin
  SIRegister_TForm1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TForm1Label12_W(Self: TledForm; const T: TLabel);
Begin Self.Label12 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label12_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label12; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label11_W(Self: TledForm; const T: TLabel);
Begin Self.Label11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label11_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label11; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label10_W(Self: TledForm; const T: TLabel);
Begin Self.Label10 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label10_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label10; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label9_W(Self: TledForm; const T: TLabel);
Begin Self.Label9 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label9_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label9; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label8_W(Self: TledForm; const T: TLabel);
Begin Self.Label8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label8_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label8; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label7_W(Self: TledForm; const T: TLabel);
Begin Self.Label7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label7_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label7; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label6_W(Self: TledForm; const T: TLabel);
Begin Self.Label6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label6_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label6; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label5_W(Self: TledForm; const T: TLabel);
Begin Self.Label5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label5_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label5; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label4_W(Self: TledForm; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label4_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label3_W(Self: TledForm; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label3_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label2_W(Self: TledForm; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label2_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label1_W(Self: TledForm; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label1_R(Self: TledForm; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1btn_loop_W(Self: TledForm; const T: TButton);
Begin Self.btn_loop := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1btn_loop_R(Self: TledForm; var T: TButton);
Begin T := Self.btn_loop; end;

(*----------------------------------------------------------------------------*)
procedure TForm1chk_led5_W(Self: TledForm; const T: TCheckBox);
Begin Self.chk_led5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1chk_led5_R(Self: TledForm; var T: TCheckBox);
Begin T := Self.chk_led5; end;

(*----------------------------------------------------------------------------*)
procedure TForm1chk_led4_W(Self: TledForm; const T: TCheckBox);
Begin Self.chk_led4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1chk_led4_R(Self: TledForm; var T: TCheckBox);
Begin T := Self.chk_led4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1chk_led3_W(Self: TledForm; const T: TCheckBox);
Begin Self.chk_led3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1chk_led3_R(Self: TledForm; var T: TCheckBox);
Begin T := Self.chk_led3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1chk_led2_W(Self: TledForm; const T: TCheckBox);
Begin Self.chk_led2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1chk_led2_R(Self: TledForm; var T: TCheckBox);
Begin T := Self.chk_led2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1chk_led1_W(Self: TledForm; const T: TCheckBox);
Begin Self.chk_led1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1chk_led1_R(Self: TledForm; var T: TCheckBox);
Begin T := Self.chk_led1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1btn_Setup_W(Self: TledForm; const T: TButton);
Begin Self.btn_Setup := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1btn_Setup_R(Self: TledForm; var T: TButton);
Begin T := Self.btn_Setup; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StatusBar1_W(Self: TledForm; const T: TStatusBar);
Begin Self.StatusBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StatusBar1_R(Self: TledForm; var T: TStatusBar);
Begin T := Self.StatusBar1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComPort1_W(Self: TledForm; const T: TComPort);
Begin Self.ComPort1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComPort1_R(Self: TledForm; var T: TComPort);
Begin T := Self.ComPort1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1btn_connect_W(Self: TledForm; const T: TButton);
Begin Self.btn_connect := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1btn_connect_R(Self: TledForm; var T: TButton);
Begin T := Self.btn_connect; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TledForm) do begin
    RegisterPropertyHelper(@TForm1btn_connect_R,@TForm1btn_connect_W,'btn_connect');
    RegisterPropertyHelper(@TForm1ComPort1_R,@TForm1ComPort1_W,'ComPort1');
    RegisterPropertyHelper(@TForm1StatusBar1_R,@TForm1StatusBar1_W,'StatusBar1');
    RegisterPropertyHelper(@TForm1btn_Setup_R,@TForm1btn_Setup_W,'btn_Setup');
    RegisterPropertyHelper(@TForm1chk_led1_R,@TForm1chk_led1_W,'chk_led1');
    RegisterPropertyHelper(@TForm1chk_led2_R,@TForm1chk_led2_W,'chk_led2');
    RegisterPropertyHelper(@TForm1chk_led3_R,@TForm1chk_led3_W,'chk_led3');
    RegisterPropertyHelper(@TForm1chk_led4_R,@TForm1chk_led4_W,'chk_led4');
    RegisterPropertyHelper(@TForm1chk_led5_R,@TForm1chk_led5_W,'chk_led5');
    RegisterPropertyHelper(@TForm1btn_loop_R,@TForm1btn_loop_W,'btn_loop');
    RegisterPropertyHelper(@TForm1Label1_R,@TForm1Label1_W,'Label1');
    RegisterPropertyHelper(@TForm1Label2_R,@TForm1Label2_W,'Label2');
    RegisterPropertyHelper(@TForm1Label3_R,@TForm1Label3_W,'Label3');
    RegisterPropertyHelper(@TForm1Label4_R,@TForm1Label4_W,'Label4');
    RegisterPropertyHelper(@TForm1Label5_R,@TForm1Label5_W,'Label5');
    RegisterPropertyHelper(@TForm1Label6_R,@TForm1Label6_W,'Label6');
    RegisterPropertyHelper(@TForm1Label7_R,@TForm1Label7_W,'Label7');
    RegisterPropertyHelper(@TForm1Label8_R,@TForm1Label8_W,'Label8');
    RegisterPropertyHelper(@TForm1Label9_R,@TForm1Label9_W,'Label9');
    RegisterPropertyHelper(@TForm1Label10_R,@TForm1Label10_W,'Label10');
    RegisterPropertyHelper(@TForm1Label11_R,@TForm1Label11_W,'Label11');
    RegisterPropertyHelper(@TForm1Label12_R,@TForm1Label12_W,'Label12');
    RegisterMethod(@TledForm.btn_connectClick, 'btn_connectClick');
    RegisterMethod(@TledForm.btn_SetupClick, 'btn_SetupClick');
    RegisterMethod(@TledForm.FormCreate, 'FormCreate');
    RegisterMethod(@TledForm.chk_led1Click, 'chk_led1Click');
    RegisterMethod(@TledForm.chk_led2Click, 'chk_led2Click');
    RegisterMethod(@TledForm.chk_led3Click, 'chk_led3Click');
    RegisterMethod(@TledForm.chk_led4Click, 'chk_led4Click');
    RegisterMethod(@TledForm.chk_led5Click, 'chk_led5Click');
    RegisterMethod(@TledForm.FormClose, 'FormClose');
    RegisterMethod(@TledForm.btn_loopClick, 'btn_loopClick');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_delphi_arduino_Unit1(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TForm1(CL);
end;

 
 
{ TPSImport_delphi_arduino_Unit1 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_delphi_arduino_Unit1.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_delphi_arduino_Unit1(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_delphi_arduino_Unit1.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_delphi_arduino_Unit1(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
