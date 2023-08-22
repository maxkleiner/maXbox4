unit uPSI_ChessPrg;
{
   chess form template
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
  TPSImport_ChessPrg = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TChessForm1(CL: TPSPascalCompiler);
procedure SIRegister_ChessPrg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TChessForm1(CL: TPSRuntimeClassImporter);
procedure RIRegister_ChessPrg(CL: TPSRuntimeClassImporter);

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
  ,ChessBrd
  ,Spin
  ,ChessPrg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ChessPrg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TChessForm1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TChessForm1') do
  with CL.AddClassN(CL.FindClass('TForm'),'TChessForm1') do
  begin
    RegisterProperty('ButtonBack', 'TButton', iptrw);
    RegisterProperty('ButtonForward', 'TButton', iptrw);
    RegisterProperty('Buttonnew', 'TButton', iptrw);
    RegisterProperty('ListBox1', 'TListBox', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('RadioGroup1', 'TRadioGroup', iptrw);
    RegisterProperty('RadioGroup2', 'TRadioGroup', iptrw);
    RegisterProperty('CheckBoxWhiteOnTop', 'TCheckBox', iptrw);
    RegisterProperty('ComboBox1', 'TComboBox', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('CheckBoxCoords', 'TCheckBox', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('CheckBoxLines', 'TCheckBox', iptrw);
    RegisterProperty('ButtonStop', 'TButton', iptrw);
    RegisterProperty('ButtonMove', 'TButton', iptrw);
    RegisterProperty('ImageCm36', 'TImage', iptrw);
    RegisterProperty('ImageFr40', 'TImage', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('ComboBox2', 'TComboBox', iptrw);
    RegisterProperty('SpinEdit1', 'TSpinEdit', iptrw);
    RegisterProperty('ChessBrd1', 'TChessBrd', iptrw);
    RegisterMethod('Procedure UpdateListBox');
    RegisterMethod('Procedure ButtonBackClick( Sender : TObject)');
    RegisterMethod('Procedure ChessBrd1LegalMove( Sender : TObject; oldSq, newSq : Square)');
    RegisterMethod('Procedure ButtonForwardClick( Sender : TObject)');
    RegisterMethod('Procedure ButtonnewClick( Sender : TObject)');
    RegisterMethod('Procedure RadioGroup2Click( Sender : TObject)');
    RegisterMethod('Procedure RadioGroup1Click( Sender : TObject)');
    RegisterMethod('Procedure CheckBoxWhiteOnTopClick( Sender : TObject)');
    RegisterMethod('Procedure ChessBrd1Draw( Sender : TObject)');
    RegisterMethod('Procedure ChessBrd1Mate( Sender : TObject; oldSq, newSq : Square)');
    RegisterMethod('Procedure CheckBoxCoordsClick( Sender : TObject)');
    RegisterMethod('Procedure SpinEdit1Change( Sender : TObject)');
    RegisterMethod('Procedure Timer1Timer( Sender : TObject)');
    RegisterMethod('Procedure CheckBoxLinesClick( Sender : TObject)');
    RegisterMethod('Procedure ListBox1Click( Sender : TObject)');
    RegisterMethod('Procedure ButtonMoveClick( Sender : TObject)');
    RegisterMethod('Procedure ButtonStopClick( Sender : TObject)');
    RegisterMethod('Procedure ComboBox1Change( Sender : TObject)');
    RegisterMethod('Procedure ChessBrd1CalculateMove( Sender : TObject; var oldsq, newsq : Square)');
    RegisterMethod('Procedure ChessBrd1CalculationFailed( Sender : TObject; oldSq, newSq : Square)');
    RegisterMethod('Procedure ComboBox2Change( Sender : TObject)');
    //RegisterMethod('Procedure Free( Sender : TObject)');
    RegisterMethod('procedure FormDestroy(Sender: TObject);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ChessPrg(CL: TPSPascalCompiler);
begin
  SIRegister_TChessForm1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TChessForm1ChessBrd1_W(Self: TChessForm1; const T: TChessBrd);
Begin Self.ChessBrd1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ChessBrd1_R(Self: TChessForm1; var T: TChessBrd);
Begin T := Self.ChessBrd1; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1SpinEdit1_W(Self: TChessForm1; const T: TSpinEdit);
Begin Self.SpinEdit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1SpinEdit1_R(Self: TChessForm1; var T: TSpinEdit);
Begin T := Self.SpinEdit1; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ComboBox2_W(Self: TChessForm1; const T: TComboBox);
Begin Self.ComboBox2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ComboBox2_R(Self: TChessForm1; var T: TComboBox);
Begin T := Self.ComboBox2; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1Label4_W(Self: TChessForm1; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1Label4_R(Self: TChessForm1; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ImageFr40_W(Self: TChessForm1; const T: TImage);
Begin Self.ImageFr40 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ImageFr40_R(Self: TChessForm1; var T: TImage);
Begin T := Self.ImageFr40; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ImageCm36_W(Self: TChessForm1; const T: TImage);
Begin Self.ImageCm36 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ImageCm36_R(Self: TChessForm1; var T: TImage);
Begin T := Self.ImageCm36; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ButtonMove_W(Self: TChessForm1; const T: TButton);
Begin Self.ButtonMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ButtonMove_R(Self: TChessForm1; var T: TButton);
Begin T := Self.ButtonMove; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ButtonStop_W(Self: TChessForm1; const T: TButton);
Begin Self.ButtonStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ButtonStop_R(Self: TChessForm1; var T: TButton);
Begin T := Self.ButtonStop; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1CheckBoxLines_W(Self: TChessForm1; const T: TCheckBox);
Begin Self.CheckBoxLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1CheckBoxLines_R(Self: TChessForm1; var T: TCheckBox);
Begin T := Self.CheckBoxLines; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1Label3_W(Self: TChessForm1; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1Label3_R(Self: TChessForm1; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1CheckBoxCoords_W(Self: TChessForm1; const T: TCheckBox);
Begin Self.CheckBoxCoords := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1CheckBoxCoords_R(Self: TChessForm1; var T: TCheckBox);
Begin T := Self.CheckBoxCoords; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1Label2_W(Self: TChessForm1; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1Label2_R(Self: TChessForm1; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ComboBox1_W(Self: TChessForm1; const T: TComboBox);
Begin Self.ComboBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ComboBox1_R(Self: TChessForm1; var T: TComboBox);
Begin T := Self.ComboBox1; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1CheckBoxWhiteOnTop_W(Self: TChessForm1; const T: TCheckBox);
Begin Self.CheckBoxWhiteOnTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1CheckBoxWhiteOnTop_R(Self: TChessForm1; var T: TCheckBox);
Begin T := Self.CheckBoxWhiteOnTop; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1RadioGroup2_W(Self: TChessForm1; const T: TRadioGroup);
Begin Self.RadioGroup2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1RadioGroup2_R(Self: TChessForm1; var T: TRadioGroup);
Begin T := Self.RadioGroup2; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1RadioGroup1_W(Self: TChessForm1; const T: TRadioGroup);
Begin Self.RadioGroup1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1RadioGroup1_R(Self: TChessForm1; var T: TRadioGroup);
Begin T := Self.RadioGroup1; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1Label1_W(Self: TChessForm1; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1Label1_R(Self: TChessForm1; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ListBox1_W(Self: TChessForm1; const T: TListBox);
Begin Self.ListBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ListBox1_R(Self: TChessForm1; var T: TListBox);
Begin T := Self.ListBox1; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1Buttonnew_W(Self: TChessForm1; const T: TButton);
Begin Self.Buttonnew := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1Buttonnew_R(Self: TChessForm1; var T: TButton);
Begin T := Self.Buttonnew; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ButtonForward_W(Self: TChessForm1; const T: TButton);
Begin Self.ButtonForward := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ButtonForward_R(Self: TChessForm1; var T: TButton);
Begin T := Self.ButtonForward; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ButtonBack_W(Self: TChessForm1; const T: TButton);
Begin Self.ButtonBack := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessForm1ButtonBack_R(Self: TChessForm1; var T: TButton);
Begin T := Self.ButtonBack; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChessForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChessForm1) do
  begin
    RegisterPropertyHelper(@TChessForm1ButtonBack_R,@TChessForm1ButtonBack_W,'ButtonBack');
    RegisterPropertyHelper(@TChessForm1ButtonForward_R,@TChessForm1ButtonForward_W,'ButtonForward');
    RegisterPropertyHelper(@TChessForm1Buttonnew_R,@TChessForm1Buttonnew_W,'Buttonnew');
    RegisterPropertyHelper(@TChessForm1ListBox1_R,@TChessForm1ListBox1_W,'ListBox1');
    RegisterPropertyHelper(@TChessForm1Label1_R,@TChessForm1Label1_W,'Label1');
    RegisterPropertyHelper(@TChessForm1RadioGroup1_R,@TChessForm1RadioGroup1_W,'RadioGroup1');
    RegisterPropertyHelper(@TChessForm1RadioGroup2_R,@TChessForm1RadioGroup2_W,'RadioGroup2');
    RegisterPropertyHelper(@TChessForm1CheckBoxWhiteOnTop_R,@TChessForm1CheckBoxWhiteOnTop_W,'CheckBoxWhiteOnTop');
    RegisterPropertyHelper(@TChessForm1ComboBox1_R,@TChessForm1ComboBox1_W,'ComboBox1');
    RegisterPropertyHelper(@TChessForm1Label2_R,@TChessForm1Label2_W,'Label2');
    RegisterPropertyHelper(@TChessForm1CheckBoxCoords_R,@TChessForm1CheckBoxCoords_W,'CheckBoxCoords');
    RegisterPropertyHelper(@TChessForm1Label3_R,@TChessForm1Label3_W,'Label3');
    RegisterPropertyHelper(@TChessForm1CheckBoxLines_R,@TChessForm1CheckBoxLines_W,'CheckBoxLines');
    RegisterPropertyHelper(@TChessForm1ButtonStop_R,@TChessForm1ButtonStop_W,'ButtonStop');
    RegisterPropertyHelper(@TChessForm1ButtonMove_R,@TChessForm1ButtonMove_W,'ButtonMove');
    RegisterPropertyHelper(@TChessForm1ImageCm36_R,@TChessForm1ImageCm36_W,'ImageCm36');
    RegisterPropertyHelper(@TChessForm1ImageFr40_R,@TChessForm1ImageFr40_W,'ImageFr40');
    RegisterPropertyHelper(@TChessForm1Label4_R,@TChessForm1Label4_W,'Label4');
    RegisterPropertyHelper(@TChessForm1ComboBox2_R,@TChessForm1ComboBox2_W,'ComboBox2');
    RegisterPropertyHelper(@TChessForm1SpinEdit1_R,@TChessForm1SpinEdit1_W,'SpinEdit1');
    RegisterPropertyHelper(@TChessForm1ChessBrd1_R,@TChessForm1ChessBrd1_W,'ChessBrd1');
    RegisterMethod(@TChessForm1.UpdateListBox, 'UpdateListBox');
    RegisterMethod(@TChessForm1.ButtonBackClick, 'ButtonBackClick');
    RegisterMethod(@TChessForm1.ChessBrd1LegalMove, 'ChessBrd1LegalMove');
    RegisterMethod(@TChessForm1.ButtonForwardClick, 'ButtonForwardClick');
    RegisterMethod(@TChessForm1.ButtonnewClick, 'ButtonnewClick');
    RegisterMethod(@TChessForm1.RadioGroup2Click, 'RadioGroup2Click');
    RegisterMethod(@TChessForm1.RadioGroup1Click, 'RadioGroup1Click');
    RegisterMethod(@TChessForm1.CheckBoxWhiteOnTopClick, 'CheckBoxWhiteOnTopClick');
    RegisterMethod(@TChessForm1.ChessBrd1Draw, 'ChessBrd1Draw');
    RegisterMethod(@TChessForm1.ChessBrd1Mate, 'ChessBrd1Mate');
    RegisterMethod(@TChessForm1.CheckBoxCoordsClick, 'CheckBoxCoordsClick');
    RegisterMethod(@TChessForm1.SpinEdit1Change, 'SpinEdit1Change');
    RegisterMethod(@TChessForm1.Timer1Timer, 'Timer1Timer');
    RegisterMethod(@TChessForm1.CheckBoxLinesClick, 'CheckBoxLinesClick');
    RegisterMethod(@TChessForm1.ListBox1Click, 'ListBox1Click');
    RegisterMethod(@TChessForm1.ButtonMoveClick, 'ButtonMoveClick');
    RegisterMethod(@TChessForm1.ButtonStopClick, 'ButtonStopClick');
    RegisterMethod(@TChessForm1.ComboBox1Change, 'ComboBox1Change');
    RegisterMethod(@TChessForm1.ChessBrd1CalculateMove, 'ChessBrd1CalculateMove');
    RegisterMethod(@TChessForm1.ChessBrd1CalculationFailed, 'ChessBrd1CalculationFailed');
    RegisterMethod(@TChessForm1.ComboBox2Change, 'ComboBox2Change');
      RegisterMethod(@TChessForm1.formdestroy, 'FormDestroy');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ChessPrg(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TChessForm1(CL);
end;

 
 
{ TPSImport_ChessPrg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ChessPrg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ChessPrg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ChessPrg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ChessPrg(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
