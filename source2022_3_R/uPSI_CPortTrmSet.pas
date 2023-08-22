unit uPSI_CPortTrmSet;
{
   just a form and one function
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
  TPSImport_CPortTrmSet = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TComTrmSetForm(CL: TPSPascalCompiler);
procedure SIRegister_CPortTrmSet(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CPortTrmSet_Routines(S: TPSExec);
procedure RIRegister_TComTrmSetForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_CPortTrmSet(CL: TPSRuntimeClassImporter);

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
  ,CPortCtl
  ,CPortTrmSet
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CPortTrmSet]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TComTrmSetForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TComTrmSetForm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TComTrmSetForm') do begin
    RegisterProperty('GroupBox1', 'TGroupBox', iptrw);
    RegisterProperty('CheckBox1', 'TCheckBox', iptrw);
    RegisterProperty('CheckBox2', 'TCheckBox', iptrw);
    RegisterProperty('CheckBox3', 'TCheckBox', iptrw);
    RegisterProperty('CheckBox4', 'TCheckBox', iptrw);
    RegisterProperty('CheckBox5', 'TCheckBox', iptrw);
    RegisterProperty('GroupBox2', 'TGroupBox', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('ComboBox1', 'TComboBox', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('ComboBox2', 'TComboBox', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('ComboBox3', 'TComboBox', iptrw);
    RegisterProperty('Label5', 'TLabel', iptrw);
    RegisterProperty('Button1', 'TButton', iptrw);
    RegisterProperty('Button2', 'TButton', iptrw);
    RegisterProperty('Edit1', 'TEdit', iptrw);
    RegisterProperty('Edit2', 'TEdit', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CPortTrmSet(CL: TPSPascalCompiler);
begin
  SIRegister_TComTrmSetForm(CL);
 CL.AddDelphiFunction('Procedure EditComTerminal( ComTerminal : TCustomComTerminal)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormEdit2_W(Self: TComTrmSetForm; const T: TEdit);
Begin Self.Edit2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormEdit2_R(Self: TComTrmSetForm; var T: TEdit);
Begin T := Self.Edit2; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormEdit1_W(Self: TComTrmSetForm; const T: TEdit);
Begin Self.Edit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormEdit1_R(Self: TComTrmSetForm; var T: TEdit);
Begin T := Self.Edit1; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormButton2_W(Self: TComTrmSetForm; const T: TButton);
Begin Self.Button2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormButton2_R(Self: TComTrmSetForm; var T: TButton);
Begin T := Self.Button2; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormButton1_W(Self: TComTrmSetForm; const T: TButton);
Begin Self.Button1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormButton1_R(Self: TComTrmSetForm; var T: TButton);
Begin T := Self.Button1; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormLabel5_W(Self: TComTrmSetForm; const T: TLabel);
Begin Self.Label5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormLabel5_R(Self: TComTrmSetForm; var T: TLabel);
Begin T := Self.Label5; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormComboBox3_W(Self: TComTrmSetForm; const T: TComboBox);
Begin Self.ComboBox3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormComboBox3_R(Self: TComTrmSetForm; var T: TComboBox);
Begin T := Self.ComboBox3; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormLabel2_W(Self: TComTrmSetForm; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormLabel2_R(Self: TComTrmSetForm; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormComboBox2_W(Self: TComTrmSetForm; const T: TComboBox);
Begin Self.ComboBox2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormComboBox2_R(Self: TComTrmSetForm; var T: TComboBox);
Begin T := Self.ComboBox2; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormLabel4_W(Self: TComTrmSetForm; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormLabel4_R(Self: TComTrmSetForm; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormLabel3_W(Self: TComTrmSetForm; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormLabel3_R(Self: TComTrmSetForm; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormComboBox1_W(Self: TComTrmSetForm; const T: TComboBox);
Begin Self.ComboBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormComboBox1_R(Self: TComTrmSetForm; var T: TComboBox);
Begin T := Self.ComboBox1; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormLabel1_W(Self: TComTrmSetForm; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormLabel1_R(Self: TComTrmSetForm; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormGroupBox2_W(Self: TComTrmSetForm; const T: TGroupBox);
Begin Self.GroupBox2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormGroupBox2_R(Self: TComTrmSetForm; var T: TGroupBox);
Begin T := Self.GroupBox2; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormCheckBox5_W(Self: TComTrmSetForm; const T: TCheckBox);
Begin Self.CheckBox5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormCheckBox5_R(Self: TComTrmSetForm; var T: TCheckBox);
Begin T := Self.CheckBox5; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormCheckBox4_W(Self: TComTrmSetForm; const T: TCheckBox);
Begin Self.CheckBox4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormCheckBox4_R(Self: TComTrmSetForm; var T: TCheckBox);
Begin T := Self.CheckBox4; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormCheckBox3_W(Self: TComTrmSetForm; const T: TCheckBox);
Begin Self.CheckBox3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormCheckBox3_R(Self: TComTrmSetForm; var T: TCheckBox);
Begin T := Self.CheckBox3; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormCheckBox2_W(Self: TComTrmSetForm; const T: TCheckBox);
Begin Self.CheckBox2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormCheckBox2_R(Self: TComTrmSetForm; var T: TCheckBox);
Begin T := Self.CheckBox2; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormCheckBox1_W(Self: TComTrmSetForm; const T: TCheckBox);
Begin Self.CheckBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormCheckBox1_R(Self: TComTrmSetForm; var T: TCheckBox);
Begin T := Self.CheckBox1; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormGroupBox1_W(Self: TComTrmSetForm; const T: TGroupBox);
Begin Self.GroupBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTrmSetFormGroupBox1_R(Self: TComTrmSetForm; var T: TGroupBox);
Begin T := Self.GroupBox1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CPortTrmSet_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EditComTerminal, 'EditComTerminal', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComTrmSetForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComTrmSetForm) do
  begin
    RegisterPropertyHelper(@TComTrmSetFormGroupBox1_R,@TComTrmSetFormGroupBox1_W,'GroupBox1');
    RegisterPropertyHelper(@TComTrmSetFormCheckBox1_R,@TComTrmSetFormCheckBox1_W,'CheckBox1');
    RegisterPropertyHelper(@TComTrmSetFormCheckBox2_R,@TComTrmSetFormCheckBox2_W,'CheckBox2');
    RegisterPropertyHelper(@TComTrmSetFormCheckBox3_R,@TComTrmSetFormCheckBox3_W,'CheckBox3');
    RegisterPropertyHelper(@TComTrmSetFormCheckBox4_R,@TComTrmSetFormCheckBox4_W,'CheckBox4');
    RegisterPropertyHelper(@TComTrmSetFormCheckBox5_R,@TComTrmSetFormCheckBox5_W,'CheckBox5');
    RegisterPropertyHelper(@TComTrmSetFormGroupBox2_R,@TComTrmSetFormGroupBox2_W,'GroupBox2');
    RegisterPropertyHelper(@TComTrmSetFormLabel1_R,@TComTrmSetFormLabel1_W,'Label1');
    RegisterPropertyHelper(@TComTrmSetFormComboBox1_R,@TComTrmSetFormComboBox1_W,'ComboBox1');
    RegisterPropertyHelper(@TComTrmSetFormLabel3_R,@TComTrmSetFormLabel3_W,'Label3');
    RegisterPropertyHelper(@TComTrmSetFormLabel4_R,@TComTrmSetFormLabel4_W,'Label4');
    RegisterPropertyHelper(@TComTrmSetFormComboBox2_R,@TComTrmSetFormComboBox2_W,'ComboBox2');
    RegisterPropertyHelper(@TComTrmSetFormLabel2_R,@TComTrmSetFormLabel2_W,'Label2');
    RegisterPropertyHelper(@TComTrmSetFormComboBox3_R,@TComTrmSetFormComboBox3_W,'ComboBox3');
    RegisterPropertyHelper(@TComTrmSetFormLabel5_R,@TComTrmSetFormLabel5_W,'Label5');
    RegisterPropertyHelper(@TComTrmSetFormButton1_R,@TComTrmSetFormButton1_W,'Button1');
    RegisterPropertyHelper(@TComTrmSetFormButton2_R,@TComTrmSetFormButton2_W,'Button2');
    RegisterPropertyHelper(@TComTrmSetFormEdit1_R,@TComTrmSetFormEdit1_W,'Edit1');
    RegisterPropertyHelper(@TComTrmSetFormEdit2_R,@TComTrmSetFormEdit2_W,'Edit2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CPortTrmSet(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TComTrmSetForm(CL);
end;

 
 
{ TPSImport_CPortTrmSet }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CPortTrmSet.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CPortTrmSet(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CPortTrmSet.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CPortTrmSet(ri);
  RIRegister_CPortTrmSet_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
