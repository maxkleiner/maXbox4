unit uPSI_JsDBTreeView;
{
   from js in heaven - add free
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
  TPSImport_JsDBTreeView = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJsDBTreeView(CL: TPSPascalCompiler);
procedure SIRegister_TJsDBTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_TJsDBTreeViewDataLink(CL: TPSPascalCompiler);
procedure SIRegister_TJsCustomDBTreeView(CL: TPSPascalCompiler);
procedure SIRegister_JsDBTreeView(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJsDBTreeView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJsDBTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJsDBTreeViewDataLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJsCustomDBTreeView(CL: TPSRuntimeClassImporter);
procedure RIRegister_JsDBTreeView(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,CommCtrl
  ,Controls
  ,ExtCtrls
  ,ComCtrls
  ,DB
  ,JsDBTreeView
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JsDBTreeView]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsDBTreeView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJsCustomDBTreeView', 'TJsDBTreeView') do
  with CL.AddClassN(CL.FindClass('TJsCustomDBTreeView'),'TJsDBTreeView') do begin
   RegisterPublishedProperties;

    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('ShowButtons', 'Boolean', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('ShowLines', 'Boolean', iptrw);
    RegisterProperty('ShowRoot', 'Boolean', iptrw);

    RegisterProperty('BORDERWIDTH', 'Integer', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
    RegisterProperty('SCROLLBARS', 'TScrollStyle', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONChange', 'TTVChangedEvent', iptrw);
    RegisterProperty('ONChanging', 'TTVChangingEvent', iptrw);
    RegisterProperty('OnCollapsed', 'TTVExpandedEvent', iptrw);
  RegisterProperty('OnCollapsing', 'TTVCollapsingEvent', iptrw);
  RegisterProperty('OnCompare', 'TTVCompareEvent', iptrw);
  RegisterProperty('OnAddition', 'TTVExpandedEvent', iptrw);
  RegisterProperty('OnCustomDraw', 'TTVCustomDrawEvent', iptrw);
  RegisterProperty('OnCustomDrawItem', 'TTVCustomDrawItemEvent', iptrw);
   RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('Indent', 'Integer', iptrw);
    //RegisterProperty('Items', 'TTreeNodes Integer', iptrw);
    RegisterProperty('Items', 'TTreeNodes', iptrw);
    RegisterProperty('ShowLines', 'boolean', iptrw);
    RegisterProperty('ShowRoot', 'boolean', iptrw);
    RegisterProperty('SortType', 'TSortType', iptrw);
    RegisterProperty('StateImages', 'TCustomImageList', iptrw);
    //RegisterProperty('Constraints', 'TCustomImageList', iptrw);
    RegisterProperty('MultiSelect', 'boolean', iptrw);
    RegisterProperty('AutoExpand', 'boolean', iptrw);
    RegisterProperty('HotTrack', 'boolean', iptrw);
    RegisterProperty('ShowHint', 'boolean', iptrw);
    RegisterProperty('ToolTips', 'boolean', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ShowColumnHeaders', 'boolean', iptrw);
    RegisterProperty('ShowWorkAreas', 'boolean', iptrw);
    RegisterProperty('Canvas', 'TCanvas', iptrw);

    //RegisterProperty('Selected', 'TTreeNode', iptrw);
    RegisterProperty('TopItem', 'TTreeNode', iptrw);
    RegisterProperty('ItemIndex', 'integer', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsDBTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTreeNode', 'TJsDBTreeNode') do
  with CL.AddClassN(CL.FindClass('TTreeNode'),'TJsDBTreeNode') do begin
    RegisterMethod('Procedure SetMasterValue( AValue : Variant)');
    RegisterMethod('procedure MoveTo(Destination: TTreeNode; Mode: TNodeAttachMode);');
   RegisterProperty('MasterValue', 'Variant', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsDBTreeViewDataLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataLink', 'TJsDBTreeViewDataLink') do
  with CL.AddClassN(CL.FindClass('TDataLink'),'TJsDBTreeViewDataLink') do
  begin
    RegisterMethod('Constructor Create( ATreeView : TJsCustomDBTreeView)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsCustomDBTreeView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTreeView', 'TJsCustomDBTreeView') do
  with CL.AddClassN(CL.FindClass('TCustomTreeView'),'TJsCustomDBTreeView') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure DragDrop( Source : TObject; X, Y : Integer)');
    RegisterMethod('Procedure RefreshChild( ANode : TJsDBTreeNode)');
    RegisterMethod('Procedure UpdateTree');
    RegisterMethod('Procedure LinkActive( Value : Boolean)');
    RegisterMethod('Procedure UpdateLock');
    RegisterMethod('Procedure UpdateUnLock( const AUpdateTree : Boolean)');
    RegisterMethod('Function UpdateLocked : Boolean');
    RegisterMethod('Function AddChildNode( const Node : TTreeNode; const Select : Boolean) : TJsDBTreeNode');
    RegisterMethod('Procedure DeleteNode( Node : TTreeNode)');
    RegisterMethod('Function DeleteChildren( ParentNode : TTreeNode) : Boolean');
    RegisterMethod('Function FindNextNode( const Node : TTreeNode) : TTreeNode');
    RegisterMethod('Function FindNode( AMasterValue : Variant) : TJsDBTreeNode');
    RegisterMethod('Function SelectNode( AMasterValue : Variant) : TTreeNode');
    RegisterProperty('DataSource', 'TDataSource', iptrw);
    RegisterProperty('DataLink', 'TJsDBTreeViewDataLink', iptr);
    RegisterProperty('MasterField', 'string', iptrw);
    RegisterProperty('ParentField', 'string', iptrw);
    RegisterProperty('DetailField', 'string', iptrw);
    RegisterProperty('KeyField', 'string', iptrw);
    RegisterProperty('ItemField', 'string', iptrw);
    RegisterProperty('IconField', 'string', iptrw);
    RegisterProperty('StartMasterValue', 'string', iptrw);
    RegisterProperty('GetDetailValue', 'TGetDetailValue', iptrw);
    RegisterProperty('PersistentNode', 'Boolean', iptrw);
    RegisterProperty('SelectedIndex', 'Integer', iptrw);
    RegisterProperty('UseFilter', 'Boolean', iptrw);
    RegisterProperty('Mirror', 'Boolean', iptrw);
    RegisterProperty('Items', 'TTreeNodes', iptrw);


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JsDBTreeView(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJsDBTreeNode');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJsDBTreeViewDataLink');
  CL.AddTypeS('TFieldTypes', 'set of TFieldType');
  SIRegister_TJsCustomDBTreeView(CL);
  SIRegister_TJsDBTreeViewDataLink(CL);
  SIRegister_TJsDBTreeNode(CL);
  SIRegister_TJsDBTreeView(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJsDBTreeViewError');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJsDBTreeNodeMasterValue_R(Self: TJsDBTreeNode; var T: Variant);
begin T := Self.MasterValue; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewMirror_W(Self: TJsCustomDBTreeView; const T: Boolean);
begin Self.Mirror := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewMirror_R(Self: TJsCustomDBTreeView; var T: Boolean);
begin T := Self.Mirror; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewUseFilter_W(Self: TJsCustomDBTreeView; const T: Boolean);
begin Self.UseFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewUseFilter_R(Self: TJsCustomDBTreeView; var T: Boolean);
begin T := Self.UseFilter; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewSelectedIndex_W(Self: TJsCustomDBTreeView; const T: Integer);
begin Self.SelectedIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewSelectedIndex_R(Self: TJsCustomDBTreeView; var T: Integer);
begin T := Self.SelectedIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewPersistentNode_W(Self: TJsCustomDBTreeView; const T: Boolean);
begin Self.PersistentNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewPersistentNode_R(Self: TJsCustomDBTreeView; var T: Boolean);
begin T := Self.PersistentNode; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewGetDetailValue_W(Self: TJsCustomDBTreeView; const T: TGetDetailValue);
begin Self.GetDetailValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewGetDetailValue_R(Self: TJsCustomDBTreeView; var T: TGetDetailValue);
begin T := Self.GetDetailValue; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewStartMasterValue_W(Self: TJsCustomDBTreeView; const T: string);
begin Self.StartMasterValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewStartMasterValue_R(Self: TJsCustomDBTreeView; var T: string);
begin T := Self.StartMasterValue; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewIconField_W(Self: TJsCustomDBTreeView; const T: string);
begin Self.IconField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewIconField_R(Self: TJsCustomDBTreeView; var T: string);
begin T := Self.IconField; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewItemField_W(Self: TJsCustomDBTreeView; const T: string);
begin Self.ItemField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewItemField_R(Self: TJsCustomDBTreeView; var T: string);
begin T := Self.ItemField; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewKeyField_W(Self: TJsCustomDBTreeView; const T: string);
begin Self.KeyField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewKeyField_R(Self: TJsCustomDBTreeView; var T: string);
begin T := Self.KeyField; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewDetailField_W(Self: TJsCustomDBTreeView; const T: string);
begin Self.DetailField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewDetailField_R(Self: TJsCustomDBTreeView; var T: string);
begin T := Self.DetailField; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewParentField_W(Self: TJsCustomDBTreeView; const T: string);
begin Self.ParentField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewParentField_R(Self: TJsCustomDBTreeView; var T: string);
begin T := Self.ParentField; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewMasterField_W(Self: TJsCustomDBTreeView; const T: string);
begin Self.MasterField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewMasterField_R(Self: TJsCustomDBTreeView; var T: string);
begin T := Self.MasterField; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewDataLink_R(Self: TJsCustomDBTreeView; var T: TJsDBTreeViewDataLink);
begin T := Self.DataLink; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewDataSource_W(Self: TJsCustomDBTreeView; const T: TDataSource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsCustomDBTreeViewDataSource_R(Self: TJsCustomDBTreeView; var T: TDataSource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsDBTreeView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsDBTreeView) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsDBTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsDBTreeNode) do begin
    RegisterMethod(@TJsDBTreeNode.SetMasterValue, 'SetMasterValue');
    RegisterMethod(@TJsDBTreeNode.MoveTo, 'MoveTo');
     RegisterPropertyHelper(@TJsDBTreeNodeMasterValue_R,nil,'MasterValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsDBTreeViewDataLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsDBTreeViewDataLink) do
  begin
    RegisterConstructor(@TJsDBTreeViewDataLink.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsCustomDBTreeView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsCustomDBTreeView) do begin
    RegisterConstructor(@TJsCustomDBTreeView.Create, 'Create');
         RegisterMethod(@TJsCustomDBTreeView.Destroy, 'Free');
       RegisterMethod(@TJsCustomDBTreeView.DragDrop, 'DragDrop');
    RegisterMethod(@TJsCustomDBTreeView.RefreshChild, 'RefreshChild');
    RegisterMethod(@TJsCustomDBTreeView.UpdateTree, 'UpdateTree');
    RegisterVirtualMethod(@TJsCustomDBTreeView.LinkActive, 'LinkActive');
    RegisterMethod(@TJsCustomDBTreeView.UpdateLock, 'UpdateLock');
    RegisterMethod(@TJsCustomDBTreeView.UpdateUnLock, 'UpdateUnLock');
    RegisterMethod(@TJsCustomDBTreeView.UpdateLocked, 'UpdateLocked');
    RegisterMethod(@TJsCustomDBTreeView.AddChildNode, 'AddChildNode');
    RegisterMethod(@TJsCustomDBTreeView.DeleteNode, 'DeleteNode');
    RegisterMethod(@TJsCustomDBTreeView.DeleteChildren, 'DeleteChildren');
    RegisterMethod(@TJsCustomDBTreeView.FindNextNode, 'FindNextNode');
    RegisterMethod(@TJsCustomDBTreeView.FindNode, 'FindNode');
    RegisterMethod(@TJsCustomDBTreeView.SelectNode, 'SelectNode');
    RegisterPropertyHelper(@TJsCustomDBTreeViewDataSource_R,@TJsCustomDBTreeViewDataSource_W,'DataSource');
    RegisterPropertyHelper(@TJsCustomDBTreeViewDataLink_R,nil,'DataLink');
    RegisterPropertyHelper(@TJsCustomDBTreeViewMasterField_R,@TJsCustomDBTreeViewMasterField_W,'MasterField');
    RegisterPropertyHelper(@TJsCustomDBTreeViewParentField_R,@TJsCustomDBTreeViewParentField_W,'ParentField');
    RegisterPropertyHelper(@TJsCustomDBTreeViewDetailField_R,@TJsCustomDBTreeViewDetailField_W,'DetailField');
    RegisterPropertyHelper(@TJsCustomDBTreeViewKeyField_R,@TJsCustomDBTreeViewKeyField_W,'KeyField');
    RegisterPropertyHelper(@TJsCustomDBTreeViewItemField_R,@TJsCustomDBTreeViewItemField_W,'ItemField');
    RegisterPropertyHelper(@TJsCustomDBTreeViewIconField_R,@TJsCustomDBTreeViewIconField_W,'IconField');
    RegisterPropertyHelper(@TJsCustomDBTreeViewStartMasterValue_R,@TJsCustomDBTreeViewStartMasterValue_W,'StartMasterValue');
    RegisterPropertyHelper(@TJsCustomDBTreeViewGetDetailValue_R,@TJsCustomDBTreeViewGetDetailValue_W,'GetDetailValue');
    RegisterPropertyHelper(@TJsCustomDBTreeViewPersistentNode_R,@TJsCustomDBTreeViewPersistentNode_W,'PersistentNode');
    RegisterPropertyHelper(@TJsCustomDBTreeViewSelectedIndex_R,@TJsCustomDBTreeViewSelectedIndex_W,'SelectedIndex');
    RegisterPropertyHelper(@TJsCustomDBTreeViewUseFilter_R,@TJsCustomDBTreeViewUseFilter_W,'UseFilter');
    RegisterPropertyHelper(@TJsCustomDBTreeViewMirror_R,@TJsCustomDBTreeViewMirror_W,'Mirror');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JsDBTreeView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsDBTreeNode) do
  with CL.Add(TJsDBTreeViewDataLink) do
  RIRegister_TJsCustomDBTreeView(CL);
  RIRegister_TJsDBTreeViewDataLink(CL);
  RIRegister_TJsDBTreeNode(CL);
  RIRegister_TJsDBTreeView(CL);
  with CL.Add(EJsDBTreeViewError) do
end;

 
 
{ TPSImport_JsDBTreeView }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JsDBTreeView.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JsDBTreeView(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JsDBTreeView.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JsDBTreeView(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
