unit uPSI_TreeVwEx;
{
   if dbtreeview to customtreeview
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
  TPSImport_TreeVwEx = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTreeViewEx(CL: TPSPascalCompiler);
procedure SIRegister_TCustomTreeViewEx(CL: TPSPascalCompiler);
procedure SIRegister_TreeVwEx(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTreeViewEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomTreeViewEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_TreeVwEx(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,CommCtrl
  ,Dialogs
  ,StdCtrls
  ,ComCtrls
  ,ImgList
  ,TreeVwEx
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TreeVwEx]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTreeViewEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTreeViewEx', 'TTreeViewEx') do
  with CL.AddClassN(CL.FindClass('TCustomTreeViewEx'),'TTreeViewEx') do begin
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
procedure SIRegister_TCustomTreeViewEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTreeView', 'TCustomTreeViewEx') do
  with CL.AddClassN(CL.FindClass('TCustomTreeView'),'TCustomTreeViewEx') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
         RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Insert( AsChild : Boolean)');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Procedure DeleteNode( Node : TTreeNode)');
    RegisterMethod('Function MoveNode( Source, Destination : TTreeNode; Mode : TNodeAttachMode) : Boolean');
    RegisterMethod('Function IsRootNode( Node : TTreeNode) : Boolean');
    RegisterMethod('Function IsSingleRootNode( Node : TTreeNode) : Boolean');
    RegisterProperty('IgnoreWMChars', 'TIgnoreWMChars', iptrw);
    RegisterProperty('RSelected', 'TTreeNode', iptr);
    RegisterProperty('Options', 'TTreeViewExOptions', iptrw);
    RegisterProperty('DragImageShow', 'TTVDragImageShow', iptrw);
    RegisterProperty('OnMouseSelect', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDragging', 'TTVDraggingEvent', iptrw);
    RegisterProperty('OnDeleting', 'TTVDeletingEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TreeVwEx(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomTreeViewEx');
  CL.AddTypeS('TTreeViewExOption', '( tveAllowDelete, tveAllowInsert, tveAutoDr'
   +'agMove, tveConfirmDelete, tveInsertAsChild, tveLabelsReadOnly, tveMouseMov'
   +'eSelect, tveMultipleRootsAllowed, tveRootItemReadOnly )');
  CL.AddTypeS('TTreeViewExOptions', 'set of TTreeViewExOption');
  CL.AddTypeS('TTVDragImageShow', '( tvdisDefault, tvdisAlways, tvdisNever )');
  CL.AddTypeS('TTreeViewExState', '( tvesIgnoreNextWMChar, tvesMouseStillDownAf'
   +'terDoubleClick, tvesRightButtonPressed, tvesWaitingForPopupMenu )');
  CL.AddTypeS('TTreeViewExStates', 'set of TTreeViewExState');
  CL.AddTypeS('TIgnoreWMChars', 'set of Char');
  CL.AddTypeS('TTVDraggingEvent', 'Procedure ( Sender : TObject; Node : TTreeNo'
   +'de; var AllowDrag : Boolean)');
  CL.AddTypeS('TTVDeletingEvent', 'Procedure ( Sender : TObject; Node : TTreeNo'
   +'de; var AllowDelete : Boolean)');
  SIRegister_TCustomTreeViewEx(CL);
  SIRegister_TTreeViewEx(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExOnDeleting_W(Self: TCustomTreeViewEx; const T: TTVDeletingEvent);
begin Self.OnDeleting := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExOnDeleting_R(Self: TCustomTreeViewEx; var T: TTVDeletingEvent);
begin T := Self.OnDeleting; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExOnDragging_W(Self: TCustomTreeViewEx; const T: TTVDraggingEvent);
begin Self.OnDragging := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExOnDragging_R(Self: TCustomTreeViewEx; var T: TTVDraggingEvent);
begin T := Self.OnDragging; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExOnMouseSelect_W(Self: TCustomTreeViewEx; const T: TNotifyEvent);
begin Self.OnMouseSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExOnMouseSelect_R(Self: TCustomTreeViewEx; var T: TNotifyEvent);
begin T := Self.OnMouseSelect; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExDragImageShow_W(Self: TCustomTreeViewEx; const T: TTVDragImageShow);
begin Self.DragImageShow := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExDragImageShow_R(Self: TCustomTreeViewEx; var T: TTVDragImageShow);
begin T := Self.DragImageShow; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExOptions_W(Self: TCustomTreeViewEx; const T: TTreeViewExOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExOptions_R(Self: TCustomTreeViewEx; var T: TTreeViewExOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExRSelected_R(Self: TCustomTreeViewEx; var T: TTreeNode);
begin T := Self.RSelected; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExIgnoreWMChars_W(Self: TCustomTreeViewEx; const T: TIgnoreWMChars);
begin Self.IgnoreWMChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewExIgnoreWMChars_R(Self: TCustomTreeViewEx; var T: TIgnoreWMChars);
begin T := Self.IgnoreWMChars; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTreeViewEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTreeViewEx) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomTreeViewEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomTreeViewEx) do begin
    RegisterConstructor(@TCustomTreeViewEx.Create, 'Create');
             RegisterMethod(@TCustomTreeViewEx.Destroy, 'Free');
      RegisterVirtualMethod(@TCustomTreeViewEx.Insert, 'Insert');
    RegisterVirtualMethod(@TCustomTreeViewEx.Delete, 'Delete');
    RegisterMethod(@TCustomTreeViewEx.DeleteNode, 'DeleteNode');
    RegisterVirtualMethod(@TCustomTreeViewEx.MoveNode, 'MoveNode');
    RegisterMethod(@TCustomTreeViewEx.IsRootNode, 'IsRootNode');
    RegisterMethod(@TCustomTreeViewEx.IsSingleRootNode, 'IsSingleRootNode');
    RegisterPropertyHelper(@TCustomTreeViewExIgnoreWMChars_R,@TCustomTreeViewExIgnoreWMChars_W,'IgnoreWMChars');
    RegisterPropertyHelper(@TCustomTreeViewExRSelected_R,nil,'RSelected');
    RegisterPropertyHelper(@TCustomTreeViewExOptions_R,@TCustomTreeViewExOptions_W,'Options');
    RegisterPropertyHelper(@TCustomTreeViewExDragImageShow_R,@TCustomTreeViewExDragImageShow_W,'DragImageShow');
    RegisterPropertyHelper(@TCustomTreeViewExOnMouseSelect_R,@TCustomTreeViewExOnMouseSelect_W,'OnMouseSelect');
    RegisterPropertyHelper(@TCustomTreeViewExOnDragging_R,@TCustomTreeViewExOnDragging_W,'OnDragging');
    RegisterPropertyHelper(@TCustomTreeViewExOnDeleting_R,@TCustomTreeViewExOnDeleting_W,'OnDeleting');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TreeVwEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomTreeViewEx) do
  RIRegister_TCustomTreeViewEx(CL);
  RIRegister_TTreeViewEx(CL);
end;

 
 
{ TPSImport_TreeVwEx }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TreeVwEx.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TreeVwEx(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TreeVwEx.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TreeVwEx(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
