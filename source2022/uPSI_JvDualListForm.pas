unit uPSI_JvDualListForm;
{
  duallist, duallist dialog, dualform
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
  TPSImport_JvDualListForm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDualListForm(CL: TPSPascalCompiler);
procedure SIRegister_JvDualListForm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvDualListForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDualListForm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  //Graphics
  //Controls
  //Forms
  StdCtrls
  ,ExtCtrls
  ,JvListBox
  ,JvCtrls
  ,JvComponent
  //,ExStdCtrls
  ,JvDualListForm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDualListForm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDualListForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvForm', 'TJvDualListForm') do
  with CL.AddClassN(CL.FindClass('TJvForm'),'TJvDualListForm') do begin
    RegisterProperty('SrcList', 'TListBox', iptrw);
    RegisterProperty('DstList', 'TListBox', iptrw);
    RegisterProperty('SrcLabel', 'TLabel', iptrw);
    RegisterProperty('DstLabel', 'TLabel', iptrw);
    RegisterProperty('IncBtn', 'TButton', iptrw);
    RegisterProperty('IncAllBtn', 'TButton', iptrw);
    RegisterProperty('ExclBtn', 'TButton', iptrw);
    RegisterProperty('ExclAllBtn', 'TButton', iptrw);
    RegisterProperty('Bevel1', 'TBevel', iptrw);
    RegisterProperty('PanelButtons', 'TPanel', iptrw);
    RegisterProperty('OkBtn', 'TButton', iptrw);
    RegisterProperty('CancelBtn', 'TButton', iptrw);
    RegisterProperty('HelpBtn', 'TButton', iptrw);
    RegisterMethod('Procedure IncBtnClick( Sender : TObject)');
    RegisterMethod('Procedure IncAllBtnClick( Sender : TObject)');
    RegisterMethod('Procedure ExclBtnClick( Sender : TObject)');
    RegisterMethod('Procedure ExclAllBtnClick( Sender : TObject)');
    RegisterMethod('Procedure SrcListDragOver( Sender, Source : TObject; X, Y : Integer; State : TDragState; var Accept : Boolean)');
    RegisterMethod('Procedure DstListDragOver( Sender, Source : TObject; X, Y : Integer; State : TDragState; var Accept : Boolean)');
    RegisterMethod('Procedure SrcListDragDrop( Sender, Source : TObject; X, Y : Integer)');
    RegisterMethod('Procedure DstListDragDrop( Sender, Source : TObject; X, Y : Integer)');
    RegisterMethod('Procedure SrcListKeyDown( Sender : TObject; var Key : Word; Shift : TShiftState)');
    RegisterMethod('Procedure DstListKeyDown( Sender : TObject; var Key : Word; Shift : TShiftState)');
    RegisterMethod('Procedure HelpBtnClick( Sender : TObject)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure ListClick( Sender : TObject)');
    RegisterMethod('Procedure FormResize( Sender : TObject)');
    RegisterMethod('Procedure SetButtons');
    RegisterProperty('ShowHelp', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDualListForm(CL: TPSPascalCompiler);
begin
  SIRegister_TJvDualListForm(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDualListFormShowHelp_W(Self: TJvDualListForm; const T: Boolean);
begin Self.ShowHelp := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormShowHelp_R(Self: TJvDualListForm; var T: Boolean);
begin T := Self.ShowHelp; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormHelpBtn_W(Self: TJvDualListForm; const T: TButton);
Begin Self.HelpBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormHelpBtn_R(Self: TJvDualListForm; var T: TButton);
Begin T := Self.HelpBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormCancelBtn_W(Self: TJvDualListForm; const T: TButton);
Begin Self.CancelBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormCancelBtn_R(Self: TJvDualListForm; var T: TButton);
Begin T := Self.CancelBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormOkBtn_W(Self: TJvDualListForm; const T: TButton);
Begin Self.OkBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormOkBtn_R(Self: TJvDualListForm; var T: TButton);
Begin T := Self.OkBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormPanelButtons_W(Self: TJvDualListForm; const T: TPanel);
Begin Self.PanelButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormPanelButtons_R(Self: TJvDualListForm; var T: TPanel);
Begin T := Self.PanelButtons; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormBevel1_W(Self: TJvDualListForm; const T: TBevel);
Begin Self.Bevel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormBevel1_R(Self: TJvDualListForm; var T: TBevel);
Begin T := Self.Bevel1; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormExclAllBtn_W(Self: TJvDualListForm; const T: TButton);
Begin Self.ExclAllBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormExclAllBtn_R(Self: TJvDualListForm; var T: TButton);
Begin T := Self.ExclAllBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormExclBtn_W(Self: TJvDualListForm; const T: TButton);
Begin Self.ExclBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormExclBtn_R(Self: TJvDualListForm; var T: TButton);
Begin T := Self.ExclBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormIncAllBtn_W(Self: TJvDualListForm; const T: TButton);
Begin Self.IncAllBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormIncAllBtn_R(Self: TJvDualListForm; var T: TButton);
Begin T := Self.IncAllBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormIncBtn_W(Self: TJvDualListForm; const T: TButton);
Begin Self.IncBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormIncBtn_R(Self: TJvDualListForm; var T: TButton);
Begin T := Self.IncBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormDstLabel_W(Self: TJvDualListForm; const T: TLabel);
Begin Self.DstLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormDstLabel_R(Self: TJvDualListForm; var T: TLabel);
Begin T := Self.DstLabel; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormSrcLabel_W(Self: TJvDualListForm; const T: TLabel);
Begin Self.SrcLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormSrcLabel_R(Self: TJvDualListForm; var T: TLabel);
Begin T := Self.SrcLabel; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormDstList_W(Self: TJvDualListForm; const T: TListBox);
Begin Self.DstList := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormDstList_R(Self: TJvDualListForm; var T: TListBox);
Begin T := Self.DstList; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormSrcList_W(Self: TJvDualListForm; const T: TListBox);
Begin Self.SrcList := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListFormSrcList_R(Self: TJvDualListForm; var T: TListBox);
Begin T := Self.SrcList; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDualListForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDualListForm) do begin
    RegisterPropertyHelper(@TJvDualListFormSrcList_R,@TJvDualListFormSrcList_W,'SrcList');
    RegisterPropertyHelper(@TJvDualListFormDstList_R,@TJvDualListFormDstList_W,'DstList');
    RegisterPropertyHelper(@TJvDualListFormSrcLabel_R,@TJvDualListFormSrcLabel_W,'SrcLabel');
    RegisterPropertyHelper(@TJvDualListFormDstLabel_R,@TJvDualListFormDstLabel_W,'DstLabel');
    RegisterPropertyHelper(@TJvDualListFormIncBtn_R,@TJvDualListFormIncBtn_W,'IncBtn');
    RegisterPropertyHelper(@TJvDualListFormIncAllBtn_R,@TJvDualListFormIncAllBtn_W,'IncAllBtn');
    RegisterPropertyHelper(@TJvDualListFormExclBtn_R,@TJvDualListFormExclBtn_W,'ExclBtn');
    RegisterPropertyHelper(@TJvDualListFormExclAllBtn_R,@TJvDualListFormExclAllBtn_W,'ExclAllBtn');
    RegisterPropertyHelper(@TJvDualListFormBevel1_R,@TJvDualListFormBevel1_W,'Bevel1');
    RegisterPropertyHelper(@TJvDualListFormPanelButtons_R,@TJvDualListFormPanelButtons_W,'PanelButtons');
    RegisterPropertyHelper(@TJvDualListFormOkBtn_R,@TJvDualListFormOkBtn_W,'OkBtn');
    RegisterPropertyHelper(@TJvDualListFormCancelBtn_R,@TJvDualListFormCancelBtn_W,'CancelBtn');
    RegisterPropertyHelper(@TJvDualListFormHelpBtn_R,@TJvDualListFormHelpBtn_W,'HelpBtn');
    RegisterMethod(@TJvDualListForm.IncBtnClick, 'IncBtnClick');
    RegisterMethod(@TJvDualListForm.IncAllBtnClick, 'IncAllBtnClick');
    RegisterMethod(@TJvDualListForm.ExclBtnClick, 'ExclBtnClick');
    RegisterMethod(@TJvDualListForm.ExclAllBtnClick, 'ExclAllBtnClick');
    RegisterMethod(@TJvDualListForm.SrcListDragOver, 'SrcListDragOver');
    RegisterMethod(@TJvDualListForm.DstListDragOver, 'DstListDragOver');
    RegisterMethod(@TJvDualListForm.SrcListDragDrop, 'SrcListDragDrop');
    RegisterMethod(@TJvDualListForm.DstListDragDrop, 'DstListDragDrop');
    RegisterMethod(@TJvDualListForm.SrcListKeyDown, 'SrcListKeyDown');
    RegisterMethod(@TJvDualListForm.DstListKeyDown, 'DstListKeyDown');
    RegisterMethod(@TJvDualListForm.HelpBtnClick, 'HelpBtnClick');
    RegisterMethod(@TJvDualListForm.FormCreate, 'FormCreate');
    RegisterMethod(@TJvDualListForm.ListClick, 'ListClick');
    RegisterMethod(@TJvDualListForm.FormResize, 'FormResize');
    RegisterMethod(@TJvDualListForm.SetButtons, 'SetButtons');
    RegisterPropertyHelper(@TJvDualListFormShowHelp_R,@TJvDualListFormShowHelp_W,'ShowHelp');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDualListForm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDualListForm(CL);
end;

 
 
{ TPSImport_JvDualListForm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDualListForm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDualListForm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDualListForm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDualListForm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
