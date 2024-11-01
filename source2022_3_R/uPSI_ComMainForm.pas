unit uPSI_ComMainForm;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_ComMainForm = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
procedure SIRegister_ComMainForm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
procedure RIRegister_ComMainForm(CL: TPSRuntimeClassImporter);

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
  ,CPort
  ,CPortCtl
  ,ComMainForm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ComMainForm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TForm1') do
  with CL.AddClassN(CL.FindClass('TForm'),'TForm1') do
  begin
    RegisterProperty('ComPort', 'TComPort', iptrw);
    RegisterProperty('Memo', 'TMemo', iptrw);
    RegisterProperty('Button_Open', 'TButton', iptrw);
    RegisterProperty('Button_Settings', 'TButton', iptrw);
    RegisterProperty('Edit_Data', 'TEdit', iptrw);
    RegisterProperty('Button_Send', 'TButton', iptrw);
    RegisterProperty('NewLine_CB', 'TCheckBox', iptrw);
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('Bt_Store', 'TButton', iptrw);
    RegisterProperty('Bt_Load', 'TButton', iptrw);
    RegisterProperty('ComLed1', 'TComLed', iptrw);
    RegisterProperty('ComLed2', 'TComLed', iptrw);
    RegisterProperty('ComLed3', 'TComLed', iptrw);
    RegisterProperty('ComLed4', 'TComLed', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('Label5', 'TLabel', iptrw);
    RegisterProperty('ComLed5', 'TComLed', iptrw);
    RegisterProperty('ComLed6', 'TComLed', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Label6', 'TLabel', iptrw);
    RegisterMethod('Procedure Button_OpenClick( Sender : TObject)');
    RegisterMethod('Procedure Button_SettingsClick( Sender : TObject)');
    RegisterMethod('Procedure Button_SendClick( Sender : TObject)');
    RegisterMethod('Procedure ComPortOpen( Sender : TObject)');
    RegisterMethod('Procedure ComPortClose( Sender : TObject)');
    RegisterMethod('Procedure ComPortRxChar( Sender : TObject; Count : Integer)');
    RegisterMethod('Procedure Bt_LoadClick( Sender : TObject)');
    RegisterMethod('Procedure Bt_StoreClick( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ComMainForm(CL: TPSPascalCompiler);
begin
  SIRegister_TForm1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TForm1Label6_W(Self: TForm1; const T: TLabel);
Begin Self.Label6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label6_R(Self: TForm1; var T: TLabel);
Begin T := Self.Label6; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label1_W(Self: TForm1; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label1_R(Self: TForm1; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed6_W(Self: TForm1; const T: TComLed);
Begin Self.ComLed6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed6_R(Self: TForm1; var T: TComLed);
Begin T := Self.ComLed6; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed5_W(Self: TForm1; const T: TComLed);
Begin Self.ComLed5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed5_R(Self: TForm1; var T: TComLed);
Begin T := Self.ComLed5; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label5_W(Self: TForm1; const T: TLabel);
Begin Self.Label5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label5_R(Self: TForm1; var T: TLabel);
Begin T := Self.Label5; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label4_W(Self: TForm1; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label4_R(Self: TForm1; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label3_W(Self: TForm1; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label3_R(Self: TForm1; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label2_W(Self: TForm1; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label2_R(Self: TForm1; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed4_W(Self: TForm1; const T: TComLed);
Begin Self.ComLed4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed4_R(Self: TForm1; var T: TComLed);
Begin T := Self.ComLed4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed3_W(Self: TForm1; const T: TComLed);
Begin Self.ComLed3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed3_R(Self: TForm1; var T: TComLed);
Begin T := Self.ComLed3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed2_W(Self: TForm1; const T: TComLed);
Begin Self.ComLed2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed2_R(Self: TForm1; var T: TComLed);
Begin T := Self.ComLed2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed1_W(Self: TForm1; const T: TComLed);
Begin Self.ComLed1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComLed1_R(Self: TForm1; var T: TComLed);
Begin T := Self.ComLed1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Bt_Load_W(Self: TForm1; const T: TButton);
Begin Self.Bt_Load := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Bt_Load_R(Self: TForm1; var T: TButton);
Begin T := Self.Bt_Load; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Bt_Store_W(Self: TForm1; const T: TButton);
Begin Self.Bt_Store := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Bt_Store_R(Self: TForm1; var T: TButton);
Begin T := Self.Bt_Store; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Panel1_W(Self: TForm1; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Panel1_R(Self: TForm1; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1NewLine_CB_W(Self: TForm1; const T: TCheckBox);
Begin Self.NewLine_CB := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1NewLine_CB_R(Self: TForm1; var T: TCheckBox);
Begin T := Self.NewLine_CB; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button_Send_W(Self: TForm1; const T: TButton);
Begin Self.Button_Send := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button_Send_R(Self: TForm1; var T: TButton);
Begin T := Self.Button_Send; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit_Data_W(Self: TForm1; const T: TEdit);
Begin Self.Edit_Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit_Data_R(Self: TForm1; var T: TEdit);
Begin T := Self.Edit_Data; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button_Settings_W(Self: TForm1; const T: TButton);
Begin Self.Button_Settings := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button_Settings_R(Self: TForm1; var T: TButton);
Begin T := Self.Button_Settings; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button_Open_W(Self: TForm1; const T: TButton);
Begin Self.Button_Open := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button_Open_R(Self: TForm1; var T: TButton);
Begin T := Self.Button_Open; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Memo_W(Self: TForm1; const T: TMemo);
Begin Self.Memo := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Memo_R(Self: TForm1; var T: TMemo);
Begin T := Self.Memo; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComPort_W(Self: TForm1; const T: TComPort);
Begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComPort_R(Self: TForm1; var T: TComPort);
Begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TForm1) do
  begin
    RegisterPropertyHelper(@TForm1ComPort_R,@TForm1ComPort_W,'ComPort');
    RegisterPropertyHelper(@TForm1Memo_R,@TForm1Memo_W,'Memo');
    RegisterPropertyHelper(@TForm1Button_Open_R,@TForm1Button_Open_W,'Button_Open');
    RegisterPropertyHelper(@TForm1Button_Settings_R,@TForm1Button_Settings_W,'Button_Settings');
    RegisterPropertyHelper(@TForm1Edit_Data_R,@TForm1Edit_Data_W,'Edit_Data');
    RegisterPropertyHelper(@TForm1Button_Send_R,@TForm1Button_Send_W,'Button_Send');
    RegisterPropertyHelper(@TForm1NewLine_CB_R,@TForm1NewLine_CB_W,'NewLine_CB');
    RegisterPropertyHelper(@TForm1Panel1_R,@TForm1Panel1_W,'Panel1');
    RegisterPropertyHelper(@TForm1Bt_Store_R,@TForm1Bt_Store_W,'Bt_Store');
    RegisterPropertyHelper(@TForm1Bt_Load_R,@TForm1Bt_Load_W,'Bt_Load');
    RegisterPropertyHelper(@TForm1ComLed1_R,@TForm1ComLed1_W,'ComLed1');
    RegisterPropertyHelper(@TForm1ComLed2_R,@TForm1ComLed2_W,'ComLed2');
    RegisterPropertyHelper(@TForm1ComLed3_R,@TForm1ComLed3_W,'ComLed3');
    RegisterPropertyHelper(@TForm1ComLed4_R,@TForm1ComLed4_W,'ComLed4');
    RegisterPropertyHelper(@TForm1Label2_R,@TForm1Label2_W,'Label2');
    RegisterPropertyHelper(@TForm1Label3_R,@TForm1Label3_W,'Label3');
    RegisterPropertyHelper(@TForm1Label4_R,@TForm1Label4_W,'Label4');
    RegisterPropertyHelper(@TForm1Label5_R,@TForm1Label5_W,'Label5');
    RegisterPropertyHelper(@TForm1ComLed5_R,@TForm1ComLed5_W,'ComLed5');
    RegisterPropertyHelper(@TForm1ComLed6_R,@TForm1ComLed6_W,'ComLed6');
    RegisterPropertyHelper(@TForm1Label1_R,@TForm1Label1_W,'Label1');
    RegisterPropertyHelper(@TForm1Label6_R,@TForm1Label6_W,'Label6');
    RegisterMethod(@TForm1.Button_OpenClick, 'Button_OpenClick');
    RegisterMethod(@TForm1.Button_SettingsClick, 'Button_SettingsClick');
    RegisterMethod(@TForm1.Button_SendClick, 'Button_SendClick');
    RegisterMethod(@TForm1.ComPortOpen, 'ComPortOpen');
    RegisterMethod(@TForm1.ComPortClose, 'ComPortClose');
    RegisterMethod(@TForm1.ComPortRxChar, 'ComPortRxChar');
    RegisterMethod(@TForm1.Bt_LoadClick, 'Bt_LoadClick');
    RegisterMethod(@TForm1.Bt_StoreClick, 'Bt_StoreClick');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ComMainForm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TForm1(CL);
end;

 
 
{ TPSImport_ComMainForm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ComMainForm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ComMainForm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ComMainForm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ComMainForm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
