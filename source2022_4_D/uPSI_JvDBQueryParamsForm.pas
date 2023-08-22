unit uPSI_JvDBQueryParamsForm;
{
  form lib  FTL
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
  TPSImport_JvDBQueryParamsForm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TJvQueryParamsDialog(CL: TPSPascalCompiler);
procedure SIRegister_JvDBQueryParamsForm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvDBQueryParamsForm_Routines(S: TPSExec);
procedure RIRegister_TJvQueryParamsDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDBQueryParamsForm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Controls
  ,Forms
  ,StdCtrls
  ,DB
  ,JvComponent
  ,JvDBQueryParamsForm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDBQueryParamsForm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvQueryParamsDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvForm', 'TJvQueryParamsDialog') do
  with CL.AddClassN(CL.FindClass('TJvForm'),'TJvQueryParamsDialog') do begin
    RegisterProperty('GroupBox1', 'TGroupBox', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('ParamValue', 'TEdit', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('NullValue', 'TCheckBox', iptrw);
    RegisterProperty('OkBtn', 'TButton', iptrw);
    RegisterProperty('CancelBtn', 'TButton', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('TypeList', 'TComboBox', iptrw);
    RegisterProperty('ParamList', 'TListBox', iptrw);
    RegisterProperty('HelpBtn', 'TButton', iptrw);
    RegisterMethod('Procedure ParamListChange( Sender : TObject)');
    RegisterMethod('Procedure TypeListChange( Sender : TObject)');
    RegisterMethod('Procedure ParamValueExit( Sender : TObject)');
    RegisterMethod('Procedure NullValueClick( Sender : TObject)');
    RegisterMethod('Procedure OkBtnClick( Sender : TObject)');
    RegisterMethod('Procedure HelpBtnClick( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDBQueryParamsForm(CL: TPSPascalCompiler);
begin
  SIRegister_TJvQueryParamsDialog(CL);
 CL.AddDelphiFunction('Function EditQueryParams( DataSet : TDataSet; List : TParams; AHelpContext : THelpContext) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogHelpBtn_W(Self: TJvQueryParamsDialog; const T: TButton);
Begin Self.HelpBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogHelpBtn_R(Self: TJvQueryParamsDialog; var T: TButton);
Begin T := Self.HelpBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogParamList_W(Self: TJvQueryParamsDialog; const T: TListBox);
Begin Self.ParamList := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogParamList_R(Self: TJvQueryParamsDialog; var T: TListBox);
Begin T := Self.ParamList; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogTypeList_W(Self: TJvQueryParamsDialog; const T: TComboBox);
Begin Self.TypeList := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogTypeList_R(Self: TJvQueryParamsDialog; var T: TComboBox);
Begin T := Self.TypeList; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogLabel3_W(Self: TJvQueryParamsDialog; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogLabel3_R(Self: TJvQueryParamsDialog; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogCancelBtn_W(Self: TJvQueryParamsDialog; const T: TButton);
Begin Self.CancelBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogCancelBtn_R(Self: TJvQueryParamsDialog; var T: TButton);
Begin T := Self.CancelBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogOkBtn_W(Self: TJvQueryParamsDialog; const T: TButton);
Begin Self.OkBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogOkBtn_R(Self: TJvQueryParamsDialog; var T: TButton);
Begin T := Self.OkBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogNullValue_W(Self: TJvQueryParamsDialog; const T: TCheckBox);
Begin Self.NullValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogNullValue_R(Self: TJvQueryParamsDialog; var T: TCheckBox);
Begin T := Self.NullValue; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogLabel2_W(Self: TJvQueryParamsDialog; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogLabel2_R(Self: TJvQueryParamsDialog; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogParamValue_W(Self: TJvQueryParamsDialog; const T: TEdit);
Begin Self.ParamValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogParamValue_R(Self: TJvQueryParamsDialog; var T: TEdit);
Begin T := Self.ParamValue; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogLabel1_W(Self: TJvQueryParamsDialog; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogLabel1_R(Self: TJvQueryParamsDialog; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogGroupBox1_W(Self: TJvQueryParamsDialog; const T: TGroupBox);
Begin Self.GroupBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQueryParamsDialogGroupBox1_R(Self: TJvQueryParamsDialog; var T: TGroupBox);
Begin T := Self.GroupBox1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDBQueryParamsForm_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EditQueryParams, 'EditQueryParams', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvQueryParamsDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvQueryParamsDialog) do
  begin
    RegisterPropertyHelper(@TJvQueryParamsDialogGroupBox1_R,@TJvQueryParamsDialogGroupBox1_W,'GroupBox1');
    RegisterPropertyHelper(@TJvQueryParamsDialogLabel1_R,@TJvQueryParamsDialogLabel1_W,'Label1');
    RegisterPropertyHelper(@TJvQueryParamsDialogParamValue_R,@TJvQueryParamsDialogParamValue_W,'ParamValue');
    RegisterPropertyHelper(@TJvQueryParamsDialogLabel2_R,@TJvQueryParamsDialogLabel2_W,'Label2');
    RegisterPropertyHelper(@TJvQueryParamsDialogNullValue_R,@TJvQueryParamsDialogNullValue_W,'NullValue');
    RegisterPropertyHelper(@TJvQueryParamsDialogOkBtn_R,@TJvQueryParamsDialogOkBtn_W,'OkBtn');
    RegisterPropertyHelper(@TJvQueryParamsDialogCancelBtn_R,@TJvQueryParamsDialogCancelBtn_W,'CancelBtn');
    RegisterPropertyHelper(@TJvQueryParamsDialogLabel3_R,@TJvQueryParamsDialogLabel3_W,'Label3');
    RegisterPropertyHelper(@TJvQueryParamsDialogTypeList_R,@TJvQueryParamsDialogTypeList_W,'TypeList');
    RegisterPropertyHelper(@TJvQueryParamsDialogParamList_R,@TJvQueryParamsDialogParamList_W,'ParamList');
    RegisterPropertyHelper(@TJvQueryParamsDialogHelpBtn_R,@TJvQueryParamsDialogHelpBtn_W,'HelpBtn');
    RegisterMethod(@TJvQueryParamsDialog.ParamListChange, 'ParamListChange');
    RegisterMethod(@TJvQueryParamsDialog.TypeListChange, 'TypeListChange');
    RegisterMethod(@TJvQueryParamsDialog.ParamValueExit, 'ParamValueExit');
    RegisterMethod(@TJvQueryParamsDialog.NullValueClick, 'NullValueClick');
    RegisterMethod(@TJvQueryParamsDialog.OkBtnClick, 'OkBtnClick');
    RegisterMethod(@TJvQueryParamsDialog.HelpBtnClick, 'HelpBtnClick');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDBQueryParamsForm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvQueryParamsDialog(CL);
end;

 
 
{ TPSImport_JvDBQueryParamsForm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBQueryParamsForm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDBQueryParamsForm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBQueryParamsForm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDBQueryParamsForm(ri);
  RIRegister_JvDBQueryParamsForm_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
