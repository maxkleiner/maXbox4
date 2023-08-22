unit uPSI_JvParserForm;
{
  build a AST or BNF
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
  TPSImport_JvParserForm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TJvHTMLParserForm(CL: TPSPascalCompiler);
procedure SIRegister_JvParserForm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvHTMLParserForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvParserForm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //Controls
  //Forms
  StdCtrls
  ,JvTypes
  ,JvComponent
  ,JvParserForm
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvParserForm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHTMLParserForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvForm', 'TJvHTMLParserForm') do
  with CL.AddClassN(CL.FindClass('TJvForm'),'TJvHTMLParserForm') do begin
    RegisterProperty('ListBox1', 'TListBox', iptrw);
    RegisterProperty('GroupBox1', 'TGroupBox', iptrw);
    RegisterProperty('edKeyword', 'TEdit', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('edStartTag', 'TEdit', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('edEndTag', 'TEdit', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('Label5', 'TLabel', iptrw);
    RegisterProperty('cbTakeText', 'TComboBox', iptrw);
    RegisterProperty('edMustBe', 'TEdit', iptrw);
    RegisterProperty('btnAdd', 'TButton', iptrw);
    RegisterProperty('btnRemove', 'TButton', iptrw);
    RegisterProperty('OkBtn', 'TButton', iptrw);
    RegisterProperty('CancelBtn', 'TButton', iptrw);
    RegisterMethod('Procedure edKeywordChange( Sender : TObject)');
    RegisterMethod('Procedure Button1Click( Sender : TObject)');
    RegisterMethod('Procedure ListBox1Click( Sender : TObject)');
    RegisterMethod('Procedure Button2Click( Sender : TObject)');
    RegisterMethod('Procedure edStartTagChange( Sender : TObject)');
    RegisterMethod('Procedure edEndTagChange( Sender : TObject)');
    RegisterMethod('Procedure cbTakeTextChange( Sender : TObject)');
    RegisterMethod('Procedure edMustBeChange( Sender : TObject)');
    RegisterMethod('Procedure OkBtnClick( Sender : TObject)');
    RegisterMethod('Procedure CancelBtnClick( Sender : TObject)');
    RegisterMethod('Procedure LoadFromStr( Value : TStrings)');
    RegisterMethod('Procedure SaveToStr( Value : TStrings)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvParserForm(CL: TPSPascalCompiler);
begin
  SIRegister_TJvHTMLParserForm(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormCancelBtn_W(Self: TJvHTMLParserForm; const T: TButton);
Begin Self.CancelBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormCancelBtn_R(Self: TJvHTMLParserForm; var T: TButton);
Begin T := Self.CancelBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormOkBtn_W(Self: TJvHTMLParserForm; const T: TButton);
Begin Self.OkBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormOkBtn_R(Self: TJvHTMLParserForm; var T: TButton);
Begin T := Self.OkBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormbtnRemove_W(Self: TJvHTMLParserForm; const T: TButton);
Begin Self.btnRemove := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormbtnRemove_R(Self: TJvHTMLParserForm; var T: TButton);
Begin T := Self.btnRemove; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormbtnAdd_W(Self: TJvHTMLParserForm; const T: TButton);
Begin Self.btnAdd := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormbtnAdd_R(Self: TJvHTMLParserForm; var T: TButton);
Begin T := Self.btnAdd; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormedMustBe_W(Self: TJvHTMLParserForm; const T: TEdit);
Begin Self.edMustBe := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormedMustBe_R(Self: TJvHTMLParserForm; var T: TEdit);
Begin T := Self.edMustBe; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormcbTakeText_W(Self: TJvHTMLParserForm; const T: TComboBox);
Begin Self.cbTakeText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormcbTakeText_R(Self: TJvHTMLParserForm; var T: TComboBox);
Begin T := Self.cbTakeText; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormLabel5_W(Self: TJvHTMLParserForm; const T: TLabel);
Begin Self.Label5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormLabel5_R(Self: TJvHTMLParserForm; var T: TLabel);
Begin T := Self.Label5; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormLabel4_W(Self: TJvHTMLParserForm; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormLabel4_R(Self: TJvHTMLParserForm; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormLabel3_W(Self: TJvHTMLParserForm; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormLabel3_R(Self: TJvHTMLParserForm; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormedEndTag_W(Self: TJvHTMLParserForm; const T: TEdit);
Begin Self.edEndTag := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormedEndTag_R(Self: TJvHTMLParserForm; var T: TEdit);
Begin T := Self.edEndTag; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormLabel2_W(Self: TJvHTMLParserForm; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormLabel2_R(Self: TJvHTMLParserForm; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormedStartTag_W(Self: TJvHTMLParserForm; const T: TEdit);
Begin Self.edStartTag := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormedStartTag_R(Self: TJvHTMLParserForm; var T: TEdit);
Begin T := Self.edStartTag; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormLabel1_W(Self: TJvHTMLParserForm; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormLabel1_R(Self: TJvHTMLParserForm; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormedKeyword_W(Self: TJvHTMLParserForm; const T: TEdit);
Begin Self.edKeyword := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormedKeyword_R(Self: TJvHTMLParserForm; var T: TEdit);
Begin T := Self.edKeyword; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormGroupBox1_W(Self: TJvHTMLParserForm; const T: TGroupBox);
Begin Self.GroupBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormGroupBox1_R(Self: TJvHTMLParserForm; var T: TGroupBox);
Begin T := Self.GroupBox1; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormListBox1_W(Self: TJvHTMLParserForm; const T: TListBox);
Begin Self.ListBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFormListBox1_R(Self: TJvHTMLParserForm; var T: TListBox);
Begin T := Self.ListBox1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHTMLParserForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHTMLParserForm) do
  begin
    RegisterPropertyHelper(@TJvHTMLParserFormListBox1_R,@TJvHTMLParserFormListBox1_W,'ListBox1');
    RegisterPropertyHelper(@TJvHTMLParserFormGroupBox1_R,@TJvHTMLParserFormGroupBox1_W,'GroupBox1');
    RegisterPropertyHelper(@TJvHTMLParserFormedKeyword_R,@TJvHTMLParserFormedKeyword_W,'edKeyword');
    RegisterPropertyHelper(@TJvHTMLParserFormLabel1_R,@TJvHTMLParserFormLabel1_W,'Label1');
    RegisterPropertyHelper(@TJvHTMLParserFormedStartTag_R,@TJvHTMLParserFormedStartTag_W,'edStartTag');
    RegisterPropertyHelper(@TJvHTMLParserFormLabel2_R,@TJvHTMLParserFormLabel2_W,'Label2');
    RegisterPropertyHelper(@TJvHTMLParserFormedEndTag_R,@TJvHTMLParserFormedEndTag_W,'edEndTag');
    RegisterPropertyHelper(@TJvHTMLParserFormLabel3_R,@TJvHTMLParserFormLabel3_W,'Label3');
    RegisterPropertyHelper(@TJvHTMLParserFormLabel4_R,@TJvHTMLParserFormLabel4_W,'Label4');
    RegisterPropertyHelper(@TJvHTMLParserFormLabel5_R,@TJvHTMLParserFormLabel5_W,'Label5');
    RegisterPropertyHelper(@TJvHTMLParserFormcbTakeText_R,@TJvHTMLParserFormcbTakeText_W,'cbTakeText');
    RegisterPropertyHelper(@TJvHTMLParserFormedMustBe_R,@TJvHTMLParserFormedMustBe_W,'edMustBe');
    RegisterPropertyHelper(@TJvHTMLParserFormbtnAdd_R,@TJvHTMLParserFormbtnAdd_W,'btnAdd');
    RegisterPropertyHelper(@TJvHTMLParserFormbtnRemove_R,@TJvHTMLParserFormbtnRemove_W,'btnRemove');
    RegisterPropertyHelper(@TJvHTMLParserFormOkBtn_R,@TJvHTMLParserFormOkBtn_W,'OkBtn');
    RegisterPropertyHelper(@TJvHTMLParserFormCancelBtn_R,@TJvHTMLParserFormCancelBtn_W,'CancelBtn');
    RegisterMethod(@TJvHTMLParserForm.edKeywordChange, 'edKeywordChange');
    RegisterMethod(@TJvHTMLParserForm.Button1Click, 'Button1Click');
    RegisterMethod(@TJvHTMLParserForm.ListBox1Click, 'ListBox1Click');
    RegisterMethod(@TJvHTMLParserForm.Button2Click, 'Button2Click');
    RegisterMethod(@TJvHTMLParserForm.edStartTagChange, 'edStartTagChange');
    RegisterMethod(@TJvHTMLParserForm.edEndTagChange, 'edEndTagChange');
    RegisterMethod(@TJvHTMLParserForm.cbTakeTextChange, 'cbTakeTextChange');
    RegisterMethod(@TJvHTMLParserForm.edMustBeChange, 'edMustBeChange');
    RegisterMethod(@TJvHTMLParserForm.OkBtnClick, 'OkBtnClick');
    RegisterMethod(@TJvHTMLParserForm.CancelBtnClick, 'CancelBtnClick');
    RegisterMethod(@TJvHTMLParserForm.LoadFromStr, 'LoadFromStr');
    RegisterMethod(@TJvHTMLParserForm.SaveToStr, 'SaveToStr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvParserForm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvHTMLParserForm(CL);
end;

 
 
{ TPSImport_JvParserForm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvParserForm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvParserForm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvParserForm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvParserForm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
