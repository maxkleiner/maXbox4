unit uPSI_ImageWin;
{
   form template
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
  TPSImport_ImageWin = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TImageForm(CL: TPSPascalCompiler);
procedure SIRegister_ImageWin(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TImageForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_ImageWin(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Forms
  ,Controls
  ,FileCtrl
  ,StdCtrls
  ,ExtCtrls
  ,Buttons
  ,Spin
  ,ComCtrls
  ,Dialogs
  ,ImageWin
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ImageWin]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TImageForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TImageForm2') do
  with CL.AddClassN(CL.FindClass('TForm'),'TImageForm2') do begin
    RegisterProperty('DirectoryListBox1', 'TDirectoryListBox', iptrw);
    RegisterProperty('DriveComboBox1', 'TDriveComboBox', iptrw);
    RegisterProperty('FileEdit', 'TEdit', iptrw);
    RegisterProperty('UpDownGroup', 'TGroupBox', iptrw);
    RegisterProperty('SpeedButton1', 'TSpeedButton', iptrw);
    RegisterProperty('BitBtn1', 'TBitBtn', iptrw);
    RegisterProperty('DisabledGrp', 'TGroupBox', iptrw);
    RegisterProperty('SpeedButton2', 'TSpeedButton', iptrw);
    RegisterProperty('BitBtn2', 'TBitBtn', iptrw);
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('Image1', 'TImage', iptrw);
    RegisterProperty('FileListBox1', 'TFileListBox', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('ViewBtn', 'TBitBtn', iptrw);
    RegisterProperty('Bevel1', 'TBevel', iptrw);
    RegisterProperty('Bevel2', 'TBevel', iptrw);
    RegisterProperty('FilterComboBox1', 'TFilterComboBox', iptrw);
    RegisterProperty('GlyphCheck', 'TCheckBox', iptrw);
    RegisterProperty('StretchCheck', 'TCheckBox', iptrw);
    RegisterProperty('UpDownEdit', 'TEdit', iptrw);
    RegisterProperty('UpDown1', 'TUpDown', iptrw);
    RegisterProperty('FormCaption', 'string', iptrw);
    RegisterMethod('Procedure FileListBox1Click( Sender : TObject)');
    RegisterMethod('Procedure ViewBtnClick( Sender : TObject)');
    RegisterMethod('Procedure ViewAsGlyph( const FileExt : string)');
    RegisterMethod('Procedure GlyphCheckClick( Sender : TObject)');
    RegisterMethod('Procedure StretchCheckClick( Sender : TObject)');
    RegisterMethod('Procedure FileEditKeyPress( Sender : TObject; var Key : Char)');
    RegisterMethod('Procedure UpDownEditChange( Sender : TObject)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ImageWin(CL: TPSPascalCompiler);
begin
  SIRegister_TImageForm(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TImageFormFormCaption_W(Self: TImageForm2; const T: string);
Begin Self.FormCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFormCaption_R(Self: TImageForm2; var T: string);
Begin T := Self.FormCaption; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormUpDown1_W(Self: TImageForm2; const T: TUpDown);
Begin Self.UpDown1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormUpDown1_R(Self: TImageForm2; var T: TUpDown);
Begin T := Self.UpDown1; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormUpDownEdit_W(Self: TImageForm2; const T: TEdit);
Begin Self.UpDownEdit := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormUpDownEdit_R(Self: TImageForm2; var T: TEdit);
Begin T := Self.UpDownEdit; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormStretchCheck_W(Self: TImageForm2; const T: TCheckBox);
Begin Self.StretchCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormStretchCheck_R(Self: TImageForm2; var T: TCheckBox);
Begin T := Self.StretchCheck; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormGlyphCheck_W(Self: TImageForm2; const T: TCheckBox);
Begin Self.GlyphCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormGlyphCheck_R(Self: TImageForm2; var T: TCheckBox);
Begin T := Self.GlyphCheck; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFilterComboBox1_W(Self: TImageForm2; const T: TFilterComboBox);
Begin Self.FilterComboBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFilterComboBox1_R(Self: TImageForm2; var T: TFilterComboBox);
Begin T := Self.FilterComboBox1; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormBevel2_W(Self: TImageForm2; const T: TBevel);
Begin Self.Bevel2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormBevel2_R(Self: TImageForm2; var T: TBevel);
Begin T := Self.Bevel2; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormBevel1_W(Self: TImageForm2; const T: TBevel);
Begin Self.Bevel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormBevel1_R(Self: TImageForm2; var T: TBevel);
Begin T := Self.Bevel1; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormViewBtn_W(Self: TImageForm2; const T: TBitBtn);
Begin Self.ViewBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormViewBtn_R(Self: TImageForm2; var T: TBitBtn);
Begin T := Self.ViewBtn; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormLabel2_W(Self: TImageForm2; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormLabel2_R(Self: TImageForm2; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFileListBox1_W(Self: TImageForm2; const T: TFileListBox);
Begin Self.FileListBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFileListBox1_R(Self: TImageForm2; var T: TFileListBox);
Begin T := Self.FileListBox1; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormImage1_W(Self: TImageForm2; const T: TImage);
Begin Self.Image1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormImage1_R(Self: TImageForm2; var T: TImage);
Begin T := Self.Image1; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormPanel1_W(Self: TImageForm2; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormPanel1_R(Self: TImageForm2; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormBitBtn2_W(Self: TImageForm2; const T: TBitBtn);
Begin Self.BitBtn2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormBitBtn2_R(Self: TImageForm2; var T: TBitBtn);
Begin T := Self.BitBtn2; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormSpeedButton2_W(Self: TImageForm2; const T: TSpeedButton);
Begin Self.SpeedButton2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormSpeedButton2_R(Self: TImageForm2; var T: TSpeedButton);
Begin T := Self.SpeedButton2; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormDisabledGrp_W(Self: TImageForm2; const T: TGroupBox);
Begin Self.DisabledGrp := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormDisabledGrp_R(Self: TImageForm2; var T: TGroupBox);
Begin T := Self.DisabledGrp; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormBitBtn1_W(Self: TImageForm2; const T: TBitBtn);
Begin Self.BitBtn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormBitBtn1_R(Self: TImageForm2; var T: TBitBtn);
Begin T := Self.BitBtn1; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormSpeedButton1_W(Self: TImageForm2; const T: TSpeedButton);
Begin Self.SpeedButton1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormSpeedButton1_R(Self: TImageForm2; var T: TSpeedButton);
Begin T := Self.SpeedButton1; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormUpDownGroup_W(Self: TImageForm2; const T: TGroupBox);
Begin Self.UpDownGroup := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormUpDownGroup_R(Self: TImageForm2; var T: TGroupBox);
Begin T := Self.UpDownGroup; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFileEdit_W(Self: TImageForm2; const T: TEdit);
Begin Self.FileEdit := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFileEdit_R(Self: TImageForm2; var T: TEdit);
Begin T := Self.FileEdit; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormDriveComboBox1_W(Self: TImageForm2; const T: TDriveComboBox);
Begin Self.DriveComboBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormDriveComboBox1_R(Self: TImageForm2; var T: TDriveComboBox);
Begin T := Self.DriveComboBox1; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormDirectoryListBox1_W(Self: TImageForm2; const T: TDirectoryListBox);
Begin Self.DirectoryListBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormDirectoryListBox1_R(Self: TImageForm2; var T: TDirectoryListBox);
Begin T := Self.DirectoryListBox1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TImageForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TImageForm2) do begin
    RegisterPropertyHelper(@TImageFormDirectoryListBox1_R,@TImageFormDirectoryListBox1_W,'DirectoryListBox1');
    RegisterPropertyHelper(@TImageFormDriveComboBox1_R,@TImageFormDriveComboBox1_W,'DriveComboBox1');
    RegisterPropertyHelper(@TImageFormFileEdit_R,@TImageFormFileEdit_W,'FileEdit');
    RegisterPropertyHelper(@TImageFormUpDownGroup_R,@TImageFormUpDownGroup_W,'UpDownGroup');
    RegisterPropertyHelper(@TImageFormSpeedButton1_R,@TImageFormSpeedButton1_W,'SpeedButton1');
    RegisterPropertyHelper(@TImageFormBitBtn1_R,@TImageFormBitBtn1_W,'BitBtn1');
    RegisterPropertyHelper(@TImageFormDisabledGrp_R,@TImageFormDisabledGrp_W,'DisabledGrp');
    RegisterPropertyHelper(@TImageFormSpeedButton2_R,@TImageFormSpeedButton2_W,'SpeedButton2');
    RegisterPropertyHelper(@TImageFormBitBtn2_R,@TImageFormBitBtn2_W,'BitBtn2');
    RegisterPropertyHelper(@TImageFormPanel1_R,@TImageFormPanel1_W,'Panel1');
    RegisterPropertyHelper(@TImageFormImage1_R,@TImageFormImage1_W,'Image1');
    RegisterPropertyHelper(@TImageFormFileListBox1_R,@TImageFormFileListBox1_W,'FileListBox1');
    RegisterPropertyHelper(@TImageFormLabel2_R,@TImageFormLabel2_W,'Label2');
    RegisterPropertyHelper(@TImageFormViewBtn_R,@TImageFormViewBtn_W,'ViewBtn');
    RegisterPropertyHelper(@TImageFormBevel1_R,@TImageFormBevel1_W,'Bevel1');
    RegisterPropertyHelper(@TImageFormBevel2_R,@TImageFormBevel2_W,'Bevel2');
    RegisterPropertyHelper(@TImageFormFilterComboBox1_R,@TImageFormFilterComboBox1_W,'FilterComboBox1');
    RegisterPropertyHelper(@TImageFormGlyphCheck_R,@TImageFormGlyphCheck_W,'GlyphCheck');
    RegisterPropertyHelper(@TImageFormStretchCheck_R,@TImageFormStretchCheck_W,'StretchCheck');
    RegisterPropertyHelper(@TImageFormUpDownEdit_R,@TImageFormUpDownEdit_W,'UpDownEdit');
    RegisterPropertyHelper(@TImageFormUpDown1_R,@TImageFormUpDown1_W,'UpDown1');
    RegisterPropertyHelper(@TImageFormFormCaption_R,@TImageFormFormCaption_W,'FormCaption');
    RegisterMethod(@TImageForm2.FileListBox1Click, 'FileListBox1Click');
    RegisterMethod(@TImageForm2.ViewBtnClick, 'ViewBtnClick');
    RegisterMethod(@TImageForm2.ViewAsGlyph, 'ViewAsGlyph');
    RegisterMethod(@TImageForm2.GlyphCheckClick, 'GlyphCheckClick');
    RegisterMethod(@TImageForm2.StretchCheckClick, 'StretchCheckClick');
    RegisterMethod(@TImageForm2.FileEditKeyPress, 'FileEditKeyPress');
    RegisterMethod(@TImageForm2.UpDownEditChange, 'UpDownEditChange');
    RegisterMethod(@TImageForm2.FormCreate, 'FormCreate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ImageWin(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TImageForm(CL);
end;

 
 
{ TPSImport_ImageWin }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ImageWin.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ImageWin(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ImageWin.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ImageWin(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
