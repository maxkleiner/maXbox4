unit uPSI_ScreenThreeDLab;
{
   starter to 3D printing
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
  TPSImport_ScreenThreeDLab = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TFormLab3D(CL: TPSPascalCompiler);
procedure SIRegister_ScreenThreeDLab(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TFormLab3D(CL: TPSRuntimeClassImporter);
procedure RIRegister_ScreenThreeDLab(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ExtCtrls
  ,StdCtrls
  ,Spin
  ,ScreenThreeDLab
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ScreenThreeDLab]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFormLab3D(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TFormLab3D') do
  with CL.AddClassN(CL.FindClass('TForm'),'TFormLab3D') do
  begin
    RegisterProperty('GroupBoxEyePosition', 'TGroupBox', iptrw);
    RegisterProperty('LabelAzimuth', 'TLabel', iptrw);
    RegisterProperty('SpinEditAzimuth', 'TSpinEdit', iptrw);
    RegisterProperty('LabelElevation', 'TLabel', iptrw);
    RegisterProperty('SpinEditElevation', 'TSpinEdit', iptrw);
    RegisterProperty('LabelDistance', 'TLabel', iptrw);
    RegisterProperty('SpinEditDistance', 'TSpinEdit', iptrw);
    RegisterProperty('GroupBoxScreen', 'TGroupBox', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('SpinEditScreenWidthHeight', 'TSpinEdit', iptrw);
    RegisterProperty('SpinEditScreenToCamera', 'TSpinEdit', iptrw);
    RegisterProperty('ComboBoxFigure', 'TComboBox', iptrw);
    RegisterProperty('Panel3DLab', 'TPanel', iptrw);
    RegisterProperty('Image', 'TImage', iptrw);
    RegisterProperty('LabelFigureSelect', 'TLabel', iptrw);
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure SpinEditBoxChange( Sender : TObject)');
    RegisterMethod('Procedure ComboBoxFigureChange( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ScreenThreeDLab(CL: TPSPascalCompiler);
begin
  SIRegister_TFormLab3D(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabelFigureSelect_W(Self: TFormLab3D; const T: TLabel);
Begin Self.LabelFigureSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabelFigureSelect_R(Self: TFormLab3D; var T: TLabel);
Begin T := Self.LabelFigureSelect; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DImage_W(Self: TFormLab3D; const T: TImage);
Begin Self.Image := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DImage_R(Self: TFormLab3D; var T: TImage);
Begin T := Self.Image; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DPanel3DLab_W(Self: TFormLab3D; const T: TPanel);
Begin Self.Panel3DLab := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DPanel3DLab_R(Self: TFormLab3D; var T: TPanel);
Begin T := Self.Panel3DLab; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DComboBoxFigure_W(Self: TFormLab3D; const T: TComboBox);
Begin Self.ComboBoxFigure := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DComboBoxFigure_R(Self: TFormLab3D; var T: TComboBox);
Begin T := Self.ComboBoxFigure; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DSpinEditScreenToCamera_W(Self: TFormLab3D; const T: TSpinEdit);
Begin Self.SpinEditScreenToCamera := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DSpinEditScreenToCamera_R(Self: TFormLab3D; var T: TSpinEdit);
Begin T := Self.SpinEditScreenToCamera; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DSpinEditScreenWidthHeight_W(Self: TFormLab3D; const T: TSpinEdit);
Begin Self.SpinEditScreenWidthHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DSpinEditScreenWidthHeight_R(Self: TFormLab3D; var T: TSpinEdit);
Begin T := Self.SpinEditScreenWidthHeight; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabel3_W(Self: TFormLab3D; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabel3_R(Self: TFormLab3D; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabel1_W(Self: TFormLab3D; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabel1_R(Self: TFormLab3D; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DGroupBoxScreen_W(Self: TFormLab3D; const T: TGroupBox);
Begin Self.GroupBoxScreen := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DGroupBoxScreen_R(Self: TFormLab3D; var T: TGroupBox);
Begin T := Self.GroupBoxScreen; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DSpinEditDistance_W(Self: TFormLab3D; const T: TSpinEdit);
Begin Self.SpinEditDistance := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DSpinEditDistance_R(Self: TFormLab3D; var T: TSpinEdit);
Begin T := Self.SpinEditDistance; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabelDistance_W(Self: TFormLab3D; const T: TLabel);
Begin Self.LabelDistance := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabelDistance_R(Self: TFormLab3D; var T: TLabel);
Begin T := Self.LabelDistance; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DSpinEditElevation_W(Self: TFormLab3D; const T: TSpinEdit);
Begin Self.SpinEditElevation := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DSpinEditElevation_R(Self: TFormLab3D; var T: TSpinEdit);
Begin T := Self.SpinEditElevation; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabelElevation_W(Self: TFormLab3D; const T: TLabel);
Begin Self.LabelElevation := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabelElevation_R(Self: TFormLab3D; var T: TLabel);
Begin T := Self.LabelElevation; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DSpinEditAzimuth_W(Self: TFormLab3D; const T: TSpinEdit);
Begin Self.SpinEditAzimuth := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DSpinEditAzimuth_R(Self: TFormLab3D; var T: TSpinEdit);
Begin T := Self.SpinEditAzimuth; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabelAzimuth_W(Self: TFormLab3D; const T: TLabel);
Begin Self.LabelAzimuth := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DLabelAzimuth_R(Self: TFormLab3D; var T: TLabel);
Begin T := Self.LabelAzimuth; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DGroupBoxEyePosition_W(Self: TFormLab3D; const T: TGroupBox);
Begin Self.GroupBoxEyePosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TFormLab3DGroupBoxEyePosition_R(Self: TFormLab3D; var T: TGroupBox);
Begin T := Self.GroupBoxEyePosition; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFormLab3D(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFormLab3D) do
  begin
    RegisterPropertyHelper(@TFormLab3DGroupBoxEyePosition_R,@TFormLab3DGroupBoxEyePosition_W,'GroupBoxEyePosition');
    RegisterPropertyHelper(@TFormLab3DLabelAzimuth_R,@TFormLab3DLabelAzimuth_W,'LabelAzimuth');
    RegisterPropertyHelper(@TFormLab3DSpinEditAzimuth_R,@TFormLab3DSpinEditAzimuth_W,'SpinEditAzimuth');
    RegisterPropertyHelper(@TFormLab3DLabelElevation_R,@TFormLab3DLabelElevation_W,'LabelElevation');
    RegisterPropertyHelper(@TFormLab3DSpinEditElevation_R,@TFormLab3DSpinEditElevation_W,'SpinEditElevation');
    RegisterPropertyHelper(@TFormLab3DLabelDistance_R,@TFormLab3DLabelDistance_W,'LabelDistance');
    RegisterPropertyHelper(@TFormLab3DSpinEditDistance_R,@TFormLab3DSpinEditDistance_W,'SpinEditDistance');
    RegisterPropertyHelper(@TFormLab3DGroupBoxScreen_R,@TFormLab3DGroupBoxScreen_W,'GroupBoxScreen');
    RegisterPropertyHelper(@TFormLab3DLabel1_R,@TFormLab3DLabel1_W,'Label1');
    RegisterPropertyHelper(@TFormLab3DLabel3_R,@TFormLab3DLabel3_W,'Label3');
    RegisterPropertyHelper(@TFormLab3DSpinEditScreenWidthHeight_R,@TFormLab3DSpinEditScreenWidthHeight_W,'SpinEditScreenWidthHeight');
    RegisterPropertyHelper(@TFormLab3DSpinEditScreenToCamera_R,@TFormLab3DSpinEditScreenToCamera_W,'SpinEditScreenToCamera');
    RegisterPropertyHelper(@TFormLab3DComboBoxFigure_R,@TFormLab3DComboBoxFigure_W,'ComboBoxFigure');
    RegisterPropertyHelper(@TFormLab3DPanel3DLab_R,@TFormLab3DPanel3DLab_W,'Panel3DLab');
    RegisterPropertyHelper(@TFormLab3DImage_R,@TFormLab3DImage_W,'Image');
    RegisterPropertyHelper(@TFormLab3DLabelFigureSelect_R,@TFormLab3DLabelFigureSelect_W,'LabelFigureSelect');
    RegisterMethod(@TFormLab3D.FormCreate, 'FormCreate');
    RegisterMethod(@TFormLab3D.SpinEditBoxChange, 'SpinEditBoxChange');
    RegisterMethod(@TFormLab3D.ComboBoxFigureChange, 'ComboBoxFigureChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ScreenThreeDLab(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFormLab3D(CL);
end;

 
 
{ TPSImport_ScreenThreeDLab }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ScreenThreeDLab.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ScreenThreeDLab(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ScreenThreeDLab.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ScreenThreeDLab(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
