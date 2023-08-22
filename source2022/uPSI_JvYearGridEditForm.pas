unit uPSI_JvYearGridEditForm;
{
  prebuild form
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
  TPSImport_JvYearGridEditForm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TYearGridEditForm(CL: TPSPascalCompiler);
procedure SIRegister_JvYearGridEditForm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TYearGridEditForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvYearGridEditForm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  //,Windows
  //,Messages
  //,Graphics
  //,Controls
  //,Forms
  Dialogs
  ,StdCtrls
  ,Buttons
  ,ExtCtrls
  ,JvComponent
  ,JvYearGridEditForm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvYearGridEditForm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TYearGridEditForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvForm', 'TYearGridEditForm') do
  with CL.AddClassN(CL.FindClass('TJvForm'),'TYearGridEditForm') do begin
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('BitBtn1', 'TBitBtn', iptrw);
    RegisterProperty('BitBtn2', 'TBitBtn', iptrw);
    RegisterProperty('MemoText', 'TMemo', iptrw);
    RegisterProperty('BtnLoad', 'TButton', iptrw);
    RegisterProperty('BtnSave', 'TButton', iptrw);
    RegisterProperty('OpenDialog', 'TOpenDialog', iptrw);
    RegisterProperty('SaveDialog', 'TSaveDialog', iptrw);
    RegisterMethod('Procedure BtnLoadClick( Sender : TObject)');
    RegisterMethod('Procedure BtnSaveClick( Sender : TObject)');
    RegisterMethod('Procedure FormShow( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvYearGridEditForm(CL: TPSPascalCompiler);
begin
  SIRegister_TYearGridEditForm(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormSaveDialog_W(Self: TYearGridEditForm; const T: TSaveDialog);
Begin Self.SaveDialog := T; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormSaveDialog_R(Self: TYearGridEditForm; var T: TSaveDialog);
Begin T := Self.SaveDialog; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormOpenDialog_W(Self: TYearGridEditForm; const T: TOpenDialog);
Begin Self.OpenDialog := T; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormOpenDialog_R(Self: TYearGridEditForm; var T: TOpenDialog);
Begin T := Self.OpenDialog; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormBtnSave_W(Self: TYearGridEditForm; const T: TButton);
Begin Self.BtnSave := T; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormBtnSave_R(Self: TYearGridEditForm; var T: TButton);
Begin T := Self.BtnSave; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormBtnLoad_W(Self: TYearGridEditForm; const T: TButton);
Begin Self.BtnLoad := T; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormBtnLoad_R(Self: TYearGridEditForm; var T: TButton);
Begin T := Self.BtnLoad; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormMemoText_W(Self: TYearGridEditForm; const T: TMemo);
Begin Self.MemoText := T; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormMemoText_R(Self: TYearGridEditForm; var T: TMemo);
Begin T := Self.MemoText; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormBitBtn2_W(Self: TYearGridEditForm; const T: TBitBtn);
Begin Self.BitBtn2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormBitBtn2_R(Self: TYearGridEditForm; var T: TBitBtn);
Begin T := Self.BitBtn2; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormBitBtn1_W(Self: TYearGridEditForm; const T: TBitBtn);
Begin Self.BitBtn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormBitBtn1_R(Self: TYearGridEditForm; var T: TBitBtn);
Begin T := Self.BitBtn1; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormPanel1_W(Self: TYearGridEditForm; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TYearGridEditFormPanel1_R(Self: TYearGridEditForm; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TYearGridEditForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TYearGridEditForm) do begin
    RegisterPropertyHelper(@TYearGridEditFormPanel1_R,@TYearGridEditFormPanel1_W,'Panel1');
    RegisterPropertyHelper(@TYearGridEditFormBitBtn1_R,@TYearGridEditFormBitBtn1_W,'BitBtn1');
    RegisterPropertyHelper(@TYearGridEditFormBitBtn2_R,@TYearGridEditFormBitBtn2_W,'BitBtn2');
    RegisterPropertyHelper(@TYearGridEditFormMemoText_R,@TYearGridEditFormMemoText_W,'MemoText');
    RegisterPropertyHelper(@TYearGridEditFormBtnLoad_R,@TYearGridEditFormBtnLoad_W,'BtnLoad');
    RegisterPropertyHelper(@TYearGridEditFormBtnSave_R,@TYearGridEditFormBtnSave_W,'BtnSave');
    RegisterPropertyHelper(@TYearGridEditFormOpenDialog_R,@TYearGridEditFormOpenDialog_W,'OpenDialog');
    RegisterPropertyHelper(@TYearGridEditFormSaveDialog_R,@TYearGridEditFormSaveDialog_W,'SaveDialog');
    RegisterMethod(@TYearGridEditForm.BtnLoadClick, 'BtnLoadClick');
    RegisterMethod(@TYearGridEditForm.BtnSaveClick, 'BtnSaveClick');
    RegisterMethod(@TYearGridEditForm.FormShow, 'FormShow');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvYearGridEditForm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TYearGridEditForm(CL);
end;

 
 
{ TPSImport_JvYearGridEditForm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvYearGridEditForm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvYearGridEditForm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvYearGridEditForm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvYearGridEditForm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
