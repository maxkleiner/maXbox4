unit uPSI_JvImagPrvw;
{
   form import images
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
  TPSImport_JvImagPrvw = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TImageForm(CL: TPSPascalCompiler);
procedure SIRegister_JvImagPrvw(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvImagPrvw_Routines(S: TPSExec);
procedure RIRegister_TImageForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvImagPrvw(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //Windows
  //,WinTypes
  //,WinProcs
  //Graphics
  Forms
  //,Controls
  ,StdCtrls
  ,ExtCtrls
  ,FileCtrl
  ,JvxCtrls
  ,JvPicClip
  ,JvPlacemnt
  ,Buttons
  ,JvComponent
  ,JvImagPrvw
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvImagPrvw]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TImageForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TImageForm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TImageForm') do begin
    RegisterProperty('DirectoryList', 'TDirectoryListBox', iptrw);
    RegisterProperty('DriveCombo', 'TDriveComboBox', iptrw);
    RegisterProperty('PathLabel', 'TLabel', iptrw);
    RegisterProperty('FileEdit', 'TEdit', iptrw);
    RegisterProperty('ImagePanel', 'TPanel', iptrw);
    RegisterProperty('Image', 'TImage', iptrw);
    RegisterProperty('FileListBox', 'TFileListBox', iptrw);
    RegisterProperty('ImageName', 'TLabel', iptrw);
    RegisterProperty('FilterCombo', 'TFilterComboBox', iptrw);
    RegisterProperty('StretchCheck', 'TCheckBox', iptrw);
    RegisterProperty('FilePics', 'TJvPicClip', iptrw);
    RegisterProperty('FormStorage', 'TJvFormStorage', iptrw);
    RegisterProperty('OkBtn', 'TButton', iptrw);
    RegisterProperty('CancelBtn', 'TButton', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('Label5', 'TLabel', iptrw);
    RegisterProperty('PreviewBtn', 'TSpeedButton', iptrw);
    RegisterMethod('Procedure FileListBoxClick( Sender : TObject)');
    RegisterMethod('Procedure StretchCheckClick( Sender : TObject)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure FileListBoxChange( Sender : TObject)');
    RegisterMethod('Procedure FileListBoxDblClick( Sender : TObject)');
    RegisterMethod('Procedure FormDestroy( Sender : TObject)');
    RegisterMethod('Procedure PreviewBtnClick( Sender : TObject)');
    RegisterMethod('Procedure OkBtnClick( Sender : TObject)');
    RegisterProperty('FileName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvImagPrvw(CL: TPSPascalCompiler);
begin
  SIRegister_TImageForm(CL);
 CL.AddDelphiFunction('Function SelectImage( var AFileName : string; const Extensions, Filter : string) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TImageFormFileName_W(Self: TImageForm; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFileName_R(Self: TImageForm; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormPreviewBtn_W(Self: TImageForm; const T: TSpeedButton);
Begin Self.PreviewBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormPreviewBtn_R(Self: TImageForm; var T: TSpeedButton);
Begin T := Self.PreviewBtn; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormLabel5_W(Self: TImageForm; const T: TLabel);
Begin Self.Label5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormLabel5_R(Self: TImageForm; var T: TLabel);
Begin T := Self.Label5; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormLabel4_W(Self: TImageForm; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormLabel4_R(Self: TImageForm; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormLabel3_W(Self: TImageForm; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormLabel3_R(Self: TImageForm; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormLabel2_W(Self: TImageForm; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormLabel2_R(Self: TImageForm; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormCancelBtn_W(Self: TImageForm; const T: TButton);
Begin Self.CancelBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormCancelBtn_R(Self: TImageForm; var T: TButton);
Begin T := Self.CancelBtn; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormOkBtn_W(Self: TImageForm; const T: TButton);
Begin Self.OkBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormOkBtn_R(Self: TImageForm; var T: TButton);
Begin T := Self.OkBtn; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFormStorage_W(Self: TImageForm; const T: TJvFormStorage);
Begin //Self.FormStorage := T;
 end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFormStorage_R(Self: TImageForm; var T: TJvFormStorage);
Begin //T := Self.FormStorage;
 end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFilePics_W(Self: TImageForm; const T: TJvPicClip);
Begin Self.FilePics := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFilePics_R(Self: TImageForm; var T: TJvPicClip);
Begin T := Self.FilePics; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormStretchCheck_W(Self: TImageForm; const T: TCheckBox);
Begin Self.StretchCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormStretchCheck_R(Self: TImageForm; var T: TCheckBox);
Begin T := Self.StretchCheck; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFilterCombo_W(Self: TImageForm; const T: TFilterComboBox);
Begin Self.FilterCombo := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFilterCombo_R(Self: TImageForm; var T: TFilterComboBox);
Begin T := Self.FilterCombo; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormImageName_W(Self: TImageForm; const T: TLabel);
Begin Self.ImageName := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormImageName_R(Self: TImageForm; var T: TLabel);
Begin T := Self.ImageName; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFileListBox_W(Self: TImageForm; const T: TFileListBox);
Begin Self.FileListBox := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFileListBox_R(Self: TImageForm; var T: TFileListBox);
Begin T := Self.FileListBox; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormImage_W(Self: TImageForm; const T: TImage);
Begin Self.Image := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormImage_R(Self: TImageForm; var T: TImage);
Begin T := Self.Image; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormImagePanel_W(Self: TImageForm; const T: TPanel);
Begin Self.ImagePanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormImagePanel_R(Self: TImageForm; var T: TPanel);
Begin T := Self.ImagePanel; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFileEdit_W(Self: TImageForm; const T: TEdit);
Begin Self.FileEdit := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormFileEdit_R(Self: TImageForm; var T: TEdit);
Begin T := Self.FileEdit; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormPathLabel_W(Self: TImageForm; const T: TLabel);
Begin Self.PathLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormPathLabel_R(Self: TImageForm; var T: TLabel);
Begin T := Self.PathLabel; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormDriveCombo_W(Self: TImageForm; const T: TDriveComboBox);
Begin Self.DriveCombo := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormDriveCombo_R(Self: TImageForm; var T: TDriveComboBox);
Begin T := Self.DriveCombo; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormDirectoryList_W(Self: TImageForm; const T: TDirectoryListBox);
Begin Self.DirectoryList := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageFormDirectoryList_R(Self: TImageForm; var T: TDirectoryListBox);
Begin T := Self.DirectoryList; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvImagPrvw_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SelectImage, 'SelectImage', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TImageForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TImageForm) do
  begin
    RegisterPropertyHelper(@TImageFormDirectoryList_R,@TImageFormDirectoryList_W,'DirectoryList');
    RegisterPropertyHelper(@TImageFormDriveCombo_R,@TImageFormDriveCombo_W,'DriveCombo');
    RegisterPropertyHelper(@TImageFormPathLabel_R,@TImageFormPathLabel_W,'PathLabel');
    RegisterPropertyHelper(@TImageFormFileEdit_R,@TImageFormFileEdit_W,'FileEdit');
    RegisterPropertyHelper(@TImageFormImagePanel_R,@TImageFormImagePanel_W,'ImagePanel');
    RegisterPropertyHelper(@TImageFormImage_R,@TImageFormImage_W,'Image');
    RegisterPropertyHelper(@TImageFormFileListBox_R,@TImageFormFileListBox_W,'FileListBox');
    RegisterPropertyHelper(@TImageFormImageName_R,@TImageFormImageName_W,'ImageName');
    RegisterPropertyHelper(@TImageFormFilterCombo_R,@TImageFormFilterCombo_W,'FilterCombo');
    RegisterPropertyHelper(@TImageFormStretchCheck_R,@TImageFormStretchCheck_W,'StretchCheck');
    RegisterPropertyHelper(@TImageFormFilePics_R,@TImageFormFilePics_W,'FilePics');
    RegisterPropertyHelper(@TImageFormFormStorage_R,@TImageFormFormStorage_W,'FormStorage');
    RegisterPropertyHelper(@TImageFormOkBtn_R,@TImageFormOkBtn_W,'OkBtn');
    RegisterPropertyHelper(@TImageFormCancelBtn_R,@TImageFormCancelBtn_W,'CancelBtn');
    RegisterPropertyHelper(@TImageFormLabel2_R,@TImageFormLabel2_W,'Label2');
    RegisterPropertyHelper(@TImageFormLabel3_R,@TImageFormLabel3_W,'Label3');
    RegisterPropertyHelper(@TImageFormLabel4_R,@TImageFormLabel4_W,'Label4');
    RegisterPropertyHelper(@TImageFormLabel5_R,@TImageFormLabel5_W,'Label5');
    RegisterPropertyHelper(@TImageFormPreviewBtn_R,@TImageFormPreviewBtn_W,'PreviewBtn');
    RegisterMethod(@TImageForm.FileListBoxClick, 'FileListBoxClick');
    RegisterMethod(@TImageForm.StretchCheckClick, 'StretchCheckClick');
    RegisterMethod(@TImageForm.FormCreate, 'FormCreate');
    RegisterMethod(@TImageForm.FileListBoxChange, 'FileListBoxChange');
    RegisterMethod(@TImageForm.FileListBoxDblClick, 'FileListBoxDblClick');
    RegisterMethod(@TImageForm.FormDestroy, 'FormDestroy');
    RegisterMethod(@TImageForm.PreviewBtnClick, 'PreviewBtnClick');
    RegisterMethod(@TImageForm.OkBtnClick, 'OkBtnClick');
    RegisterPropertyHelper(@TImageFormFileName_R,@TImageFormFileName_W,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvImagPrvw(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TImageForm(CL);
end;

 
 
{ TPSImport_JvImagPrvw }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvImagPrvw.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvImagPrvw(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvImagPrvw.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvImagPrvw(ri);
  RIRegister_JvImagPrvw_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
