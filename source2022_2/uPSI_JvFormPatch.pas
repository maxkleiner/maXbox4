unit uPSI_JvFormPatch;
{
  for the unit patch
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
  TPSImport_JvFormPatch = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TFoPatch(CL: TPSPascalCompiler);
procedure SIRegister_JvFormPatch(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TFoPatch(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvFormPatch(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,Forms
  ,StdCtrls
  ,Mask
  ,JvToolEdit
  ,JvFormPatch
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvFormPatch]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFoPatch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TFoPatch') do
  with CL.AddClassN(CL.FindClass('TForm'),'TFoPatch') do begin
    RegisterProperty('GroupBox1', 'TGroupBox', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('Edit1', 'TEdit', iptrw);
    RegisterProperty('FileNameBox1', 'TJvFilenameEdit', iptrw);
    RegisterProperty('FileNameBox2', 'TJvFilenameEdit', iptrw);
    RegisterProperty('OkBtn', 'TButton', iptrw);
    RegisterProperty('CancelBtn', 'TButton', iptrw);
    RegisterMethod('Procedure OkBtnClick( Sender : TObject)');
    RegisterProperty('Res', 'TStringList', iptrw);
    RegisterMethod('Procedure LoadFromStr( Value : TStringList)');
    RegisterMethod('Function SetFromStr : TStringList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvFormPatch(CL: TPSPascalCompiler);
begin
  SIRegister_TFoPatch(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TFoPatchRes_W(Self: TFoPatch; const T: TStringList);
Begin Self.Res := T; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchRes_R(Self: TFoPatch; var T: TStringList);
Begin T := Self.Res; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchCancelBtn_W(Self: TFoPatch; const T: TButton);
Begin Self.CancelBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchCancelBtn_R(Self: TFoPatch; var T: TButton);
Begin T := Self.CancelBtn; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchOkBtn_W(Self: TFoPatch; const T: TButton);
Begin Self.OkBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchOkBtn_R(Self: TFoPatch; var T: TButton);
Begin T := Self.OkBtn; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchFileNameBox2_W(Self: TFoPatch; const T: TJvFilenameEdit);
Begin Self.FileNameBox2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchFileNameBox2_R(Self: TFoPatch; var T: TJvFilenameEdit);
Begin T := Self.FileNameBox2; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchFileNameBox1_W(Self: TFoPatch; const T: TJvFilenameEdit);
Begin Self.FileNameBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchFileNameBox1_R(Self: TFoPatch; var T: TJvFilenameEdit);
Begin T := Self.FileNameBox1; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchEdit1_W(Self: TFoPatch; const T: TEdit);
Begin Self.Edit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchEdit1_R(Self: TFoPatch; var T: TEdit);
Begin T := Self.Edit1; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchLabel3_W(Self: TFoPatch; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchLabel3_R(Self: TFoPatch; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchLabel2_W(Self: TFoPatch; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchLabel2_R(Self: TFoPatch; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchLabel1_W(Self: TFoPatch; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchLabel1_R(Self: TFoPatch; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchGroupBox1_W(Self: TFoPatch; const T: TGroupBox);
Begin Self.GroupBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TFoPatchGroupBox1_R(Self: TFoPatch; var T: TGroupBox);
Begin T := Self.GroupBox1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFoPatch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFoPatch) do begin
    RegisterPropertyHelper(@TFoPatchGroupBox1_R,@TFoPatchGroupBox1_W,'GroupBox1');
    RegisterPropertyHelper(@TFoPatchLabel1_R,@TFoPatchLabel1_W,'Label1');
    RegisterPropertyHelper(@TFoPatchLabel2_R,@TFoPatchLabel2_W,'Label2');
    RegisterPropertyHelper(@TFoPatchLabel3_R,@TFoPatchLabel3_W,'Label3');
    RegisterPropertyHelper(@TFoPatchEdit1_R,@TFoPatchEdit1_W,'Edit1');
    RegisterPropertyHelper(@TFoPatchFileNameBox1_R,@TFoPatchFileNameBox1_W,'FileNameBox1');
    RegisterPropertyHelper(@TFoPatchFileNameBox2_R,@TFoPatchFileNameBox2_W,'FileNameBox2');
    RegisterPropertyHelper(@TFoPatchOkBtn_R,@TFoPatchOkBtn_W,'OkBtn');
    RegisterPropertyHelper(@TFoPatchCancelBtn_R,@TFoPatchCancelBtn_W,'CancelBtn');
    RegisterMethod(@TFoPatch.OkBtnClick, 'OkBtnClick');
    RegisterPropertyHelper(@TFoPatchRes_R,@TFoPatchRes_W,'Res');
    RegisterMethod(@TFoPatch.LoadFromStr, 'LoadFromStr');
    RegisterMethod(@TFoPatch.SetFromStr, 'SetFromStr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvFormPatch(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFoPatch(CL);
end;

 
 
{ TPSImport_JvFormPatch }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFormPatch.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvFormPatch(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFormPatch.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvFormPatch(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
