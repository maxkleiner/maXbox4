unit uPSI_JvDirFrm;
{
  list form
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
  TPSImport_JvDirFrm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDirectoryListDialog(CL: TPSPascalCompiler);
procedure SIRegister_JvDirFrm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvDirFrm_Routines(S: TPSExec);
procedure RIRegister_TJvDirectoryListDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDirFrm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // WinTypes
  //,WinProcs
  //,Controls
  //Forms
  StdCtrls
  ,JvxCtrls
  ,JvPlacemnt
  ,JvComponent
  ,JvDirFrm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDirFrm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDirectoryListDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvForm', 'TJvDirectoryListDialog') do
  with CL.AddClassN(CL.FindClass('TJvForm'),'TJvDirectoryListDialog') do begin
    RegisterProperty('DirectoryList', 'TJvTextListBox', iptrw);
    RegisterProperty('AddBtn', 'TButton', iptrw);
    RegisterProperty('RemoveBtn', 'TButton', iptrw);
    RegisterProperty('ModifyBtn', 'TButton', iptrw);
    RegisterProperty('OKBtn', 'TButton', iptrw);
    RegisterProperty('CancelBtn', 'TButton', iptrw);
    RegisterProperty('Storage', 'TJvFormStorage', iptrw);
    RegisterMethod('Procedure AddBtnClick( Sender : TObject)');
    RegisterMethod('Procedure ModifyBtnClick( Sender : TObject)');
    RegisterMethod('Procedure RemoveBtnClick( Sender : TObject)');
    RegisterMethod('Procedure DirectoryListClick( Sender : TObject)');
    RegisterMethod('Procedure FormShow( Sender : TObject)');
    RegisterMethod('Procedure DirectoryListDragDrop( Sender, Source : TObject; X, Y : Integer)');
    RegisterMethod('Procedure DirectoryListDragOver( Sender, Source : TObject; X, Y : Integer; State : TDragState; var Accept : Boolean)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDirFrm(CL: TPSPascalCompiler);
begin
  SIRegister_TJvDirectoryListDialog(CL);
 CL.AddDelphiFunction('Function EditFolderList( Folders : TStrings) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogStorage_W(Self: TJvDirectoryListDialog; const T: TJvFormStorage);
Begin //Self.Storage := T;
 end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogStorage_R(Self: TJvDirectoryListDialog; var T: TJvFormStorage);
Begin //T := Self.Storage;
 end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogCancelBtn_W(Self: TJvDirectoryListDialog; const T: TButton);
Begin Self.CancelBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogCancelBtn_R(Self: TJvDirectoryListDialog; var T: TButton);
Begin T := Self.CancelBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogOKBtn_W(Self: TJvDirectoryListDialog; const T: TButton);
Begin Self.OKBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogOKBtn_R(Self: TJvDirectoryListDialog; var T: TButton);
Begin T := Self.OKBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogModifyBtn_W(Self: TJvDirectoryListDialog; const T: TButton);
Begin Self.ModifyBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogModifyBtn_R(Self: TJvDirectoryListDialog; var T: TButton);
Begin T := Self.ModifyBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogRemoveBtn_W(Self: TJvDirectoryListDialog; const T: TButton);
Begin Self.RemoveBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogRemoveBtn_R(Self: TJvDirectoryListDialog; var T: TButton);
Begin T := Self.RemoveBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogAddBtn_W(Self: TJvDirectoryListDialog; const T: TButton);
Begin Self.AddBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogAddBtn_R(Self: TJvDirectoryListDialog; var T: TButton);
Begin T := Self.AddBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogDirectoryList_W(Self: TJvDirectoryListDialog; const T: TListBox);
Begin Self.DirectoryList := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoryListDialogDirectoryList_R(Self: TJvDirectoryListDialog; var T: TListBox);
Begin T := Self.DirectoryList; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDirFrm_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EditFolderList, 'EditFolderList', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDirectoryListDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDirectoryListDialog) do begin
    RegisterPropertyHelper(@TJvDirectoryListDialogDirectoryList_R,@TJvDirectoryListDialogDirectoryList_W,'DirectoryList');
    RegisterPropertyHelper(@TJvDirectoryListDialogAddBtn_R,@TJvDirectoryListDialogAddBtn_W,'AddBtn');
    RegisterPropertyHelper(@TJvDirectoryListDialogRemoveBtn_R,@TJvDirectoryListDialogRemoveBtn_W,'RemoveBtn');
    RegisterPropertyHelper(@TJvDirectoryListDialogModifyBtn_R,@TJvDirectoryListDialogModifyBtn_W,'ModifyBtn');
    RegisterPropertyHelper(@TJvDirectoryListDialogOKBtn_R,@TJvDirectoryListDialogOKBtn_W,'OKBtn');
    RegisterPropertyHelper(@TJvDirectoryListDialogCancelBtn_R,@TJvDirectoryListDialogCancelBtn_W,'CancelBtn');
    RegisterPropertyHelper(@TJvDirectoryListDialogStorage_R,@TJvDirectoryListDialogStorage_W,'Storage');
    RegisterMethod(@TJvDirectoryListDialog.AddBtnClick, 'AddBtnClick');
    RegisterMethod(@TJvDirectoryListDialog.ModifyBtnClick, 'ModifyBtnClick');
    RegisterMethod(@TJvDirectoryListDialog.RemoveBtnClick, 'RemoveBtnClick');
    RegisterMethod(@TJvDirectoryListDialog.DirectoryListClick, 'DirectoryListClick');
    RegisterMethod(@TJvDirectoryListDialog.FormShow, 'FormShow');
    RegisterMethod(@TJvDirectoryListDialog.DirectoryListDragDrop, 'DirectoryListDragDrop');
    RegisterMethod(@TJvDirectoryListDialog.DirectoryListDragOver, 'DirectoryListDragOver');
    RegisterMethod(@TJvDirectoryListDialog.FormCreate, 'FormCreate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDirFrm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDirectoryListDialog(CL);
end;

 
 
{ TPSImport_JvDirFrm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDirFrm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDirFrm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDirFrm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDirFrm(ri);
  RIRegister_JvDirFrm_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
