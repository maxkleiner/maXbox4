unit uPSI_dbTreeCBox;
{
   of dbtreeview
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
  TPSImport_dbTreeCBox = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDbTreeLookupComboBox(CL: TPSPascalCompiler);
procedure SIRegister_TCustomDBLookupControl(CL: TPSPascalCompiler);
procedure SIRegister_TTreeSelect(CL: TPSPascalCompiler);
procedure SIRegister_dbTreeCBox(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDbTreeLookupComboBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomDBLookupControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTreeSelect(CL: TPSRuntimeClassImporter);
procedure RIRegister_dbTreeCBox(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Controls
  ,Forms
  ,Graphics
  ,Menus
  ,StdCtrls
  ,ExtCtrls
  ,DB
  ,DBTables
  ,Mask
  ,Buttons
  ,DBCtrls
  ,ComCtrls
  ,dbTree
  ,TreeVwEx
  ,dbTreeCBox
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_dbTreeCBox]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDbTreeLookupComboBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomDBLookupControl', 'TDbTreeLookupComboBox') do
  with CL.AddClassN(CL.FindClass('TCustomDBLookupControl'),'TDbTreeLookupComboBox') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure CloseUp( Action : TCloseUpAction)');
         RegisterMethod('Procedure Free');
    RegisterMethod('Procedure DropDown');
    RegisterMethod('Procedure KeyValueChanged');
    RegisterProperty('ListVisible', 'Boolean', iptr);
    RegisterProperty('Text', 'string', iptr);
    RegisterMethod('Procedure PrepareDropdown');
    RegisterProperty('DBTreeViewDataset', 'TDataset', iptr);
    RegisterProperty('TreeSelect', 'TTreeSelect', iptrw);
    RegisterProperty('DBTreeView', 'TCustomDBTreeView', iptr);
    RegisterProperty('DropDownAlign', 'TDropDownAlign', iptrw);
    RegisterProperty('DropDownWidth', 'Integer', iptrw);
    RegisterProperty('DropDownHeight', 'Integer', iptrw);
    RegisterProperty('OnCloseUp', 'TCloseUpEvent', iptrw);
    RegisterProperty('OnDropDown', 'TNotifyEvent', iptrw);
    RegisterProperty('ListTreeIDField', 'string', iptrw);
    RegisterProperty('ListTreeParentField', 'string', iptrw);
    RegisterProperty('ListTreeRootID', 'string', iptrw);
    RegisterProperty('OnAcceptNode', 'TAcceptNodeEvent', iptrw);
    RegisterProperty('OnCreateTreeSelect', 'TCreateTreeSelectEvent', iptrw);
    RegisterProperty('Options', 'TDBTreeLCBOptions', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomDBLookupControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TCustomDBLookupControl') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TCustomDBLookupControl') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
  //with RegClassS(CL,'TDBLookupControl', 'TCustomDBLookupControl') do
  with CL.AddClassN(CL.FindClass('TDBLookupControl'),'TCustomDBLookupControl') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTreeSelect(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TTreeSelect') do
  with CL.AddClassN(CL.FindClass('TForm'),'TTreeSelect') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure CloseUp( Action : TCloseUpAction)');
    RegisterMethod('Function CanAccept( Node : TTreeNode) : Boolean');
    RegisterProperty('DBTreeView', 'TCustomDBTreeView', iptrw);
    RegisterProperty('OnCloseUp', 'TCloseUpEvent', iptrw);
    RegisterProperty('CallingDbTreeLookupComboBox', 'TDbTreeLookupComboBox', iptr);
    RegisterProperty('PosUnderComboBox', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_dbTreeCBox(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDbTreeLookupComboBox');
  CL.AddTypeS('TCloseUpAction', '( caCancel, caAccept, caClear )');
  CL.AddTypeS('TCloseUpEvent', 'Procedure ( Action : TCloseUpAction)');
  CL.AddTypeS('TAcceptNodeEvent', 'Procedure ( Node : TTreeNode; var Accept : Boolean)');
  CL.AddTypeS('TDBTreeLCBOption', '( dtAcceptLeavesOnly, dtDontAcceptRoot, dtKeepDataSetConnected )');
  CL.AddTypeS('TDBTreeLCBOptions', 'set of TDBTreeLCBOption');
  SIRegister_TTreeSelect(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomDBLookupControl');
  SIRegister_TCustomDBLookupControl(CL);
  SIRegister_TCustomDBLookupControl(CL);
  CL.AddTypeS('TCreateTreeSelectEvent', 'Function  : TTreeSelect');
  CL.AddTypeS('TGetTreeSelectEvent', 'Function  : TTreeSelect');
  CL.AddTypeS('TDropDownAlign', '( daLeft, daRight, daCenter )');
  SIRegister_TDbTreeLookupComboBox(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxOptions_W(Self: TDbTreeLookupComboBox; const T: TDBTreeLCBOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxOptions_R(Self: TDbTreeLookupComboBox; var T: TDBTreeLCBOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxOnCreateTreeSelect_W(Self: TDbTreeLookupComboBox; const T: TCreateTreeSelectEvent);
begin Self.OnCreateTreeSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxOnCreateTreeSelect_R(Self: TDbTreeLookupComboBox; var T: TCreateTreeSelectEvent);
begin T := Self.OnCreateTreeSelect; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxOnAcceptNode_W(Self: TDbTreeLookupComboBox; const T: TAcceptNodeEvent);
begin Self.OnAcceptNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxOnAcceptNode_R(Self: TDbTreeLookupComboBox; var T: TAcceptNodeEvent);
begin T := Self.OnAcceptNode; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxListTreeRootID_W(Self: TDbTreeLookupComboBox; const T: string);
begin Self.ListTreeRootID := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxListTreeRootID_R(Self: TDbTreeLookupComboBox; var T: string);
begin T := Self.ListTreeRootID; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxListTreeParentField_W(Self: TDbTreeLookupComboBox; const T: string);
begin Self.ListTreeParentField := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxListTreeParentField_R(Self: TDbTreeLookupComboBox; var T: string);
begin T := Self.ListTreeParentField; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxListTreeIDField_W(Self: TDbTreeLookupComboBox; const T: string);
begin Self.ListTreeIDField := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxListTreeIDField_R(Self: TDbTreeLookupComboBox; var T: string);
begin T := Self.ListTreeIDField; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxOnDropDown_W(Self: TDbTreeLookupComboBox; const T: TNotifyEvent);
begin Self.OnDropDown := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxOnDropDown_R(Self: TDbTreeLookupComboBox; var T: TNotifyEvent);
begin T := Self.OnDropDown; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxOnCloseUp_W(Self: TDbTreeLookupComboBox; const T: TCloseUpEvent);
begin Self.OnCloseUp := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxOnCloseUp_R(Self: TDbTreeLookupComboBox; var T: TCloseUpEvent);
begin T := Self.OnCloseUp; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxDropDownHeight_W(Self: TDbTreeLookupComboBox; const T: Integer);
begin Self.DropDownHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxDropDownHeight_R(Self: TDbTreeLookupComboBox; var T: Integer);
begin T := Self.DropDownHeight; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxDropDownWidth_W(Self: TDbTreeLookupComboBox; const T: Integer);
begin Self.DropDownWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxDropDownWidth_R(Self: TDbTreeLookupComboBox; var T: Integer);
begin T := Self.DropDownWidth; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxDropDownAlign_W(Self: TDbTreeLookupComboBox; const T: TDropDownAlign);
begin Self.DropDownAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxDropDownAlign_R(Self: TDbTreeLookupComboBox; var T: TDropDownAlign);
begin T := Self.DropDownAlign; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxDBTreeView_R(Self: TDbTreeLookupComboBox; var T: TCustomDBTreeView);
begin T := Self.DBTreeView; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxTreeSelect_W(Self: TDbTreeLookupComboBox; const T: TTreeSelect);
begin Self.TreeSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxTreeSelect_R(Self: TDbTreeLookupComboBox; var T: TTreeSelect);
begin T := Self.TreeSelect; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxDBTreeViewDataset_R(Self: TDbTreeLookupComboBox; var T: TDataset);
begin T := Self.DBTreeViewDataset; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxText_R(Self: TDbTreeLookupComboBox; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TDbTreeLookupComboBoxListVisible_R(Self: TDbTreeLookupComboBox; var T: Boolean);
begin T := Self.ListVisible; end;

(*----------------------------------------------------------------------------*)
procedure TTreeSelectPosUnderComboBox_R(Self: TTreeSelect; var T: Boolean);
begin T := Self.PosUnderComboBox; end;

(*----------------------------------------------------------------------------*)
procedure TTreeSelectCallingDbTreeLookupComboBox_R(Self: TTreeSelect; var T: TDbTreeLookupComboBox);
begin T := Self.CallingDbTreeLookupComboBox; end;

(*----------------------------------------------------------------------------*)
procedure TTreeSelectOnCloseUp_W(Self: TTreeSelect; const T: TCloseUpEvent);
begin Self.OnCloseUp := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeSelectOnCloseUp_R(Self: TTreeSelect; var T: TCloseUpEvent);
begin T := Self.OnCloseUp; end;

(*----------------------------------------------------------------------------*)
procedure TTreeSelectDBTreeView_W(Self: TTreeSelect; const T: TCustomDBTreeView);
begin Self.DBTreeView := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeSelectDBTreeView_R(Self: TTreeSelect; var T: TCustomDBTreeView);
begin T := Self.DBTreeView; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDbTreeLookupComboBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDbTreeLookupComboBox) do begin
           RegisterMethod(@TDbTreeLookupComboBox.Destroy, 'Free');
    RegisterConstructor(@TDbTreeLookupComboBox.Create, 'Create');
    RegisterMethod(@TDbTreeLookupComboBox.CloseUp, 'CloseUp');
    RegisterMethod(@TDbTreeLookupComboBox.DropDown, 'DropDown');
    RegisterMethod(@TDbTreeLookupComboBox.KeyValueChanged, 'KeyValueChanged');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxListVisible_R,nil,'ListVisible');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxText_R,nil,'Text');
    RegisterMethod(@TDbTreeLookupComboBox.PrepareDropdown, 'PrepareDropdown');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxDBTreeViewDataset_R,nil,'DBTreeViewDataset');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxTreeSelect_R,@TDbTreeLookupComboBoxTreeSelect_W,'TreeSelect');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxDBTreeView_R,nil,'DBTreeView');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxDropDownAlign_R,@TDbTreeLookupComboBoxDropDownAlign_W,'DropDownAlign');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxDropDownWidth_R,@TDbTreeLookupComboBoxDropDownWidth_W,'DropDownWidth');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxDropDownHeight_R,@TDbTreeLookupComboBoxDropDownHeight_W,'DropDownHeight');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxOnCloseUp_R,@TDbTreeLookupComboBoxOnCloseUp_W,'OnCloseUp');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxOnDropDown_R,@TDbTreeLookupComboBoxOnDropDown_W,'OnDropDown');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxListTreeIDField_R,@TDbTreeLookupComboBoxListTreeIDField_W,'ListTreeIDField');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxListTreeParentField_R,@TDbTreeLookupComboBoxListTreeParentField_W,'ListTreeParentField');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxListTreeRootID_R,@TDbTreeLookupComboBoxListTreeRootID_W,'ListTreeRootID');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxOnAcceptNode_R,@TDbTreeLookupComboBoxOnAcceptNode_W,'OnAcceptNode');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxOnCreateTreeSelect_R,@TDbTreeLookupComboBoxOnCreateTreeSelect_W,'OnCreateTreeSelect');
    RegisterPropertyHelper(@TDbTreeLookupComboBoxOptions_R,@TDbTreeLookupComboBoxOptions_W,'Options');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomDBLookupControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomDBLookupControl) do
  begin
    RegisterConstructor(@TCustomDBLookupControl.Create, 'Create');
  end;
  with CL.Add(TCustomDBLookupControl) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTreeSelect(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTreeSelect) do
  begin
    RegisterConstructor(@TTreeSelect.Create, 'Create');
    RegisterMethod(@TTreeSelect.CloseUp, 'CloseUp');
    RegisterVirtualMethod(@TTreeSelect.CanAccept, 'CanAccept');
    RegisterPropertyHelper(@TTreeSelectDBTreeView_R,@TTreeSelectDBTreeView_W,'DBTreeView');
    RegisterPropertyHelper(@TTreeSelectOnCloseUp_R,@TTreeSelectOnCloseUp_W,'OnCloseUp');
    RegisterPropertyHelper(@TTreeSelectCallingDbTreeLookupComboBox_R,nil,'CallingDbTreeLookupComboBox');
    RegisterPropertyHelper(@TTreeSelectPosUnderComboBox_R,nil,'PosUnderComboBox');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_dbTreeCBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDbTreeLookupComboBox) do
  RIRegister_TTreeSelect(CL);
  with CL.Add(TCustomDBLookupControl) do
  RIRegister_TCustomDBLookupControl(CL);
  RIRegister_TCustomDBLookupControl(CL);
  RIRegister_TDbTreeLookupComboBox(CL);
end;

 
 
{ TPSImport_dbTreeCBox }
(*----------------------------------------------------------------------------*)
procedure TPSImport_dbTreeCBox.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_dbTreeCBox(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_dbTreeCBox.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_dbTreeCBox(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
