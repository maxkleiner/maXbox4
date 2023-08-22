unit uPSI_fplotMain;
{
   at least an archimedes plot
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
  TPSImport_fplotMain = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
procedure SIRegister_fplotMain(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
procedure RIRegister_fplotMain(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinTypes
  ,WinProcs
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,ExtCtrls
  ,Spin
  ,fplotMain
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_fplotMain]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TForm1') do
  with CL.AddClassN(CL.FindClass('TForm'),'TfplotForm1') do begin
    RegisterProperty('RadioGroup1', 'TRadioGroup', iptrw);
    RegisterProperty('GroupBox1', 'TGroupBox', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Edit1', 'TEdit', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('Edit2', 'TEdit', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('Edit3', 'TEdit', iptrw);
    RegisterProperty('GroupBox2', 'TGroupBox', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('Label5', 'TLabel', iptrw);
    RegisterProperty('Label6', 'TLabel', iptrw);
    RegisterProperty('Edit4', 'TEdit', iptrw);
    RegisterProperty('Edit5', 'TEdit', iptrw);
    RegisterProperty('Edit6', 'TEdit', iptrw);
    RegisterProperty('ColorDialog1', 'TColorDialog', iptrw);
    RegisterProperty('GroupBox4', 'TGroupBox', iptrw);
    RegisterProperty('Label9', 'TLabel', iptrw);
    RegisterProperty('Edit7', 'TEdit', iptrw);
    RegisterProperty('Label10', 'TLabel', iptrw);
    RegisterProperty('Edit8', 'TEdit', iptrw);
    RegisterProperty('Label11', 'TLabel', iptrw);
    RegisterProperty('Edit9', 'TEdit', iptrw);
    RegisterProperty('GroupBox3', 'TGroupBox', iptrw);
    RegisterProperty('Shape1', 'TShape', iptrw);
    RegisterProperty('Label7', 'TLabel', iptrw);
    RegisterProperty('Label8', 'TLabel', iptrw);
    RegisterProperty('SpinEdit1', 'TSpinEdit', iptrw);
    RegisterProperty('SpinEdit2', 'TSpinEdit', iptrw);
    RegisterProperty('Button1', 'TButton', iptrw);
    RegisterProperty('Button2', 'TButton', iptrw);
    RegisterProperty('Button3', 'TButton', iptrw);
    RegisterProperty('Image1', 'TImage', iptrw);
    RegisterProperty('RadioGroup2', 'TRadioGroup', iptrw);
    RegisterMethod('Procedure Button1Click( Sender : TObject)');
    RegisterMethod('Procedure RadioGroup1Click( Sender : TObject)');
    RegisterMethod('Procedure Button3Click( Sender : TObject)');
    RegisterMethod('Procedure RadioGroup2Click( Sender : TObject)');
    RegisterMethod('Procedure BtnPlotClick( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_fplotMain(CL: TPSPascalCompiler);
begin
  SIRegister_TForm1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TForm1RadioGroup2_W(Self: TfplotForm1; const T: TRadioGroup);
Begin Self.RadioGroup2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RadioGroup2_R(Self: TfplotForm1; var T: TRadioGroup);
Begin T := Self.RadioGroup2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Image1_W(Self: TfplotForm1; const T: TImage);
Begin Self.Image1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Image1_R(Self: TfplotForm1; var T: TImage);
Begin T := Self.Image1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button3_W(Self: TfplotForm1; const T: TButton);
Begin Self.Button3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button3_R(Self: TfplotForm1; var T: TButton);
Begin T := Self.Button3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button2_W(Self: TfplotForm1; const T: TButton);
Begin Self.BtnPlot:= T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button2_R(Self: TfplotForm1; var T: TButton);
Begin T := Self.BtnPlot; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button1_W(Self: TfplotForm1; const T: TButton);
Begin Self.Button1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button1_R(Self: TfplotForm1; var T: TButton);
Begin T := Self.Button1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpinEdit2_W(Self: TfplotForm1; const T: TSpinEdit);
Begin Self.SpinEdit2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpinEdit2_R(Self: TfplotForm1; var T: TSpinEdit);
Begin T := Self.SpinEdit2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpinEdit1_W(Self: TfplotForm1; const T: TSpinEdit);
Begin Self.SpinEdit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpinEdit1_R(Self: TfplotForm1; var T: TSpinEdit);
Begin T := Self.SpinEdit1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label8_W(Self: TfplotForm1; const T: TLabel);
Begin Self.Label8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label8_R(Self: TfplotForm1; var T: TLabel);
Begin T := Self.Label8; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label7_W(Self: TfplotForm1; const T: TLabel);
Begin Self.Label7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label7_R(Self: TfplotForm1; var T: TLabel);
Begin T := Self.Label7; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Shape1_W(Self: TfplotForm1; const T: TShape);
Begin Self.Shape1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Shape1_R(Self: TfplotForm1; var T: TShape);
Begin T := Self.Shape1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupBox3_W(Self: TfplotForm1; const T: TGroupBox);
Begin Self.GroupBox3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupBox3_R(Self: TfplotForm1; var T: TGroupBox);
Begin T := Self.GroupBox3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit9_W(Self: TfplotForm1; const T: TEdit);
Begin Self.Edit9 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit9_R(Self: TfplotForm1; var T: TEdit);
Begin T := Self.Edit9; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label11_W(Self: TfplotForm1; const T: TLabel);
Begin Self.Label11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label11_R(Self: TfplotForm1; var T: TLabel);
Begin T := Self.Label11; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit8_W(Self: TfplotForm1; const T: TEdit);
Begin Self.Edit8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit8_R(Self: TfplotForm1; var T: TEdit);
Begin T := Self.Edit8; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label10_W(Self: TfplotForm1; const T: TLabel);
Begin Self.Label10 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label10_R(Self: TfplotForm1; var T: TLabel);
Begin T := Self.Label10; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit7_W(Self: TfplotForm1; const T: TEdit);
Begin Self.Edit7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit7_R(Self: TfplotForm1; var T: TEdit);
Begin T := Self.Edit7; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label9_W(Self: TfplotForm1; const T: TLabel);
Begin Self.Label9 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label9_R(Self: TfplotForm1; var T: TLabel);
Begin T := Self.Label9; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupBox4_W(Self: TfplotForm1; const T: TGroupBox);
Begin Self.GroupBox4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupBox4_R(Self: TfplotForm1; var T: TGroupBox);
Begin T := Self.GroupBox4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ColorDialog1_W(Self: TfplotForm1; const T: TColorDialog);
Begin Self.ColorDialog1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ColorDialog1_R(Self: TfplotForm1; var T: TColorDialog);
Begin T := Self.ColorDialog1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit6_W(Self: TfplotForm1; const T: TEdit);
Begin Self.Edit6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit6_R(Self: TfplotForm1; var T: TEdit);
Begin T := Self.Edit6; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit5_W(Self: TfplotForm1; const T: TEdit);
Begin Self.Edit5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit5_R(Self: TfplotForm1; var T: TEdit);
Begin T := Self.Edit5; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit4_W(Self: TfplotForm1; const T: TEdit);
Begin Self.Edit4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit4_R(Self: TfplotForm1; var T: TEdit);
Begin T := Self.Edit4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label6_W(Self: TfplotForm1; const T: TLabel);
Begin Self.Label6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label6_R(Self: TfplotForm1; var T: TLabel);
Begin T := Self.Label6; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label5_W(Self: TfplotForm1; const T: TLabel);
Begin Self.Label5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label5_R(Self: TfplotForm1; var T: TLabel);
Begin T := Self.Label5; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label4_W(Self: TfplotForm1; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label4_R(Self: TfplotForm1; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupBox2_W(Self: TfplotForm1; const T: TGroupBox);
Begin Self.GroupBox2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupBox2_R(Self: TfplotForm1; var T: TGroupBox);
Begin T := Self.GroupBox2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit3_W(Self: TfplotForm1; const T: TEdit);
Begin Self.Edit3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit3_R(Self: TfplotForm1; var T: TEdit);
Begin T := Self.Edit3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label3_W(Self: TfplotForm1; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label3_R(Self: TfplotForm1; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit2_W(Self: TfplotForm1; const T: TEdit);
Begin Self.Edit2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit2_R(Self: TfplotForm1; var T: TEdit);
Begin T := Self.Edit2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label2_W(Self: TfplotForm1; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label2_R(Self: TfplotForm1; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit1_W(Self: TfplotForm1; const T: TEdit);
Begin Self.Edit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit1_R(Self: TfplotForm1; var T: TEdit);
Begin T := Self.Edit1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label1_W(Self: TfplotForm1; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label1_R(Self: TfplotForm1; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupBox1_W(Self: TfplotForm1; const T: TGroupBox);
Begin Self.GroupBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupBox1_R(Self: TfplotForm1; var T: TGroupBox);
Begin T := Self.GroupBox1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RadioGroup1_W(Self: TfplotForm1; const T: TRadioGroup);
Begin Self.RadioGroup1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RadioGroup1_R(Self: TfplotForm1; var T: TRadioGroup);
Begin T := Self.RadioGroup1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TfplotForm1) do begin
    RegisterPropertyHelper(@TForm1RadioGroup1_R,@TForm1RadioGroup1_W,'RadioGroup1');
    RegisterPropertyHelper(@TForm1GroupBox1_R,@TForm1GroupBox1_W,'GroupBox1');
    RegisterPropertyHelper(@TForm1Label1_R,@TForm1Label1_W,'Label1');
    RegisterPropertyHelper(@TForm1Edit1_R,@TForm1Edit1_W,'Edit1');
    RegisterPropertyHelper(@TForm1Label2_R,@TForm1Label2_W,'Label2');
    RegisterPropertyHelper(@TForm1Edit2_R,@TForm1Edit2_W,'Edit2');
    RegisterPropertyHelper(@TForm1Label3_R,@TForm1Label3_W,'Label3');
    RegisterPropertyHelper(@TForm1Edit3_R,@TForm1Edit3_W,'Edit3');
    RegisterPropertyHelper(@TForm1GroupBox2_R,@TForm1GroupBox2_W,'GroupBox2');
    RegisterPropertyHelper(@TForm1Label4_R,@TForm1Label4_W,'Label4');
    RegisterPropertyHelper(@TForm1Label5_R,@TForm1Label5_W,'Label5');
    RegisterPropertyHelper(@TForm1Label6_R,@TForm1Label6_W,'Label6');
    RegisterPropertyHelper(@TForm1Edit4_R,@TForm1Edit4_W,'Edit4');
    RegisterPropertyHelper(@TForm1Edit5_R,@TForm1Edit5_W,'Edit5');
    RegisterPropertyHelper(@TForm1Edit6_R,@TForm1Edit6_W,'Edit6');
    RegisterPropertyHelper(@TForm1ColorDialog1_R,@TForm1ColorDialog1_W,'ColorDialog1');
    RegisterPropertyHelper(@TForm1GroupBox4_R,@TForm1GroupBox4_W,'GroupBox4');
    RegisterPropertyHelper(@TForm1Label9_R,@TForm1Label9_W,'Label9');
    RegisterPropertyHelper(@TForm1Edit7_R,@TForm1Edit7_W,'Edit7');
    RegisterPropertyHelper(@TForm1Label10_R,@TForm1Label10_W,'Label10');
    RegisterPropertyHelper(@TForm1Edit8_R,@TForm1Edit8_W,'Edit8');
    RegisterPropertyHelper(@TForm1Label11_R,@TForm1Label11_W,'Label11');
    RegisterPropertyHelper(@TForm1Edit9_R,@TForm1Edit9_W,'Edit9');
    RegisterPropertyHelper(@TForm1GroupBox3_R,@TForm1GroupBox3_W,'GroupBox3');
    RegisterPropertyHelper(@TForm1Shape1_R,@TForm1Shape1_W,'Shape1');
    RegisterPropertyHelper(@TForm1Label7_R,@TForm1Label7_W,'Label7');
    RegisterPropertyHelper(@TForm1Label8_R,@TForm1Label8_W,'Label8');
    RegisterPropertyHelper(@TForm1SpinEdit1_R,@TForm1SpinEdit1_W,'SpinEdit1');
    RegisterPropertyHelper(@TForm1SpinEdit2_R,@TForm1SpinEdit2_W,'SpinEdit2');
    RegisterPropertyHelper(@TForm1Button1_R,@TForm1Button1_W,'Button1');
    RegisterPropertyHelper(@TForm1Button2_R,@TForm1Button2_W,'Button2');
    RegisterPropertyHelper(@TForm1Button3_R,@TForm1Button3_W,'Button3');
    RegisterPropertyHelper(@TForm1Image1_R,@TForm1Image1_W,'Image1');
    RegisterPropertyHelper(@TForm1RadioGroup2_R,@TForm1RadioGroup2_W,'RadioGroup2');
    RegisterMethod(@TfplotForm1.Button1Click, 'Button1Click');
    RegisterMethod(@TfplotForm1.RadioGroup1Click, 'RadioGroup1Click');
    RegisterMethod(@TfplotForm1.Button3Click, 'Button3Click');
    RegisterMethod(@TfplotForm1.RadioGroup2Click, 'RadioGroup2Click');
    RegisterMethod(@TfplotForm1.BtnPlotClick, 'BtnPlotClick');
    RegisterMethod(@TfplotForm1.BtnPlotClick, 'Plot');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_fplotMain(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TForm1(CL);
end;

 
 
{ TPSImport_fplotMain }
(*----------------------------------------------------------------------------*)
procedure TPSImport_fplotMain.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_fplotMain(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_fplotMain.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_fplotMain(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
