unit uPSI_dbTree;
{
   the first and best dbtreeview  , add free
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
  TPSImport_dbTree = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDBTreeView(CL: TPSPascalCompiler);
procedure SIRegister_TCustomDBTreeView(CL: TPSPascalCompiler);
procedure SIRegister_TTreeIDNode(CL: TPSPascalCompiler);
procedure SIRegister_TTreeViewLink(CL: TPSPascalCompiler);
procedure SIRegister_dbTree(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDBTreeView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomDBTreeView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTreeIDNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTreeViewLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_dbTree(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,CommCtrl
  ,Dialogs
  ,BDE
  ,Dbconsts
  ,DB
  ,DBTables
  ,StdCtrls
  ,ComCtrls
  ,TreeVwEx
  ,ECDataLink
  ,dbTvRecordList
  ,dbTree
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_dbTree]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBTreeView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomDBTreeView', 'TDBTreeView') do
  with CL.AddClassN(CL.FindClass('TCustomDBTreeView'),'TDBTreeView') do begin
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
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
    //RegisterProperty('Selected', 'TTreeNode', iptrw);
    RegisterProperty('TopItem', 'TTreeNode', iptrw);
    RegisterProperty('ItemIndex', 'integer', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomDBTreeView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTreeViewEx', 'TCustomDBTreeView') do
  with CL.AddClassN(CL.FindClass('TCustomTreeViewEx'),'TCustomDBTreeView') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure RebuildTree');
    RegisterMethod('Procedure BuildTreeIfNeeded');
    RegisterMethod('Procedure Insert( AsChild : Boolean)');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Function MoveNode( Source, Destination : TTreeNode; Mode : TNodeAttachMode) : Boolean');
    RegisterMethod('Function FindTextID( const S : string; var ID : string; TVFindTextOptions : TTVFindTextOptions) : Boolean');
    RegisterMethod('Function TextIDList( const S : string; TVFindTextOptions : TTVFindTextOptions) : TStringList');
    RegisterMethod('Function GetExpanded( Separator : Char) : string');
    RegisterMethod('Procedure SetExpanded( const List : string; Separator : Char)');
    RegisterMethod('Procedure SynchronizeSelectedNodeToCurrentRecord');
    RegisterMethod('Procedure SynchronizeCurrentRecordToSelectedNode');
    RegisterMethod('Function IDOfNode( Node : TTreeNode) : string');
    RegisterMethod('Function GetIDNode( const aID : string) : TTreeNode');
    RegisterProperty('DataSet', 'TDataSet', iptr);
    RegisterProperty('SelectedID', 'string', iptrw);
    RegisterProperty('IDs', 'string Integer', iptr);
    RegisterProperty('DataSource', 'TDataSource', iptrw);
    RegisterProperty('TableIDField', 'string', iptrw);
    RegisterProperty('TableParentField', 'string', iptrw);
    RegisterProperty('TableTextField', 'string', iptrw);
    RegisterProperty('RootID', 'string', iptrw);
    RegisterProperty('OnClosedLoop', 'TNotifyEvent', iptrw);
    RegisterProperty('OnGetNextID', 'TDBTVGetNextIDEvent', iptrw);
    RegisterProperty('OnRootNotFound', 'TNotifyEvent', iptrw);
    RegisterProperty('Options', 'TDBTreeOptions', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTreeIDNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTreeNode', 'TTreeIDNode') do
  with CL.AddClassN(CL.FindClass('TTreeNode'),'TTreeIDNode') do begin
    RegisterMethod('Constructor Create( AOwner : TTreeNodes)');
         RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('ID', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTreeViewLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TECDataLink', 'TTreeViewLink') do
  with CL.AddClassN(CL.FindClass('TECDataLink'),'TTreeViewLink') do
  begin
    RegisterMethod('Constructor Create( ATreeView : TCustomDBTreeView)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_dbTree(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomDBTreeView');
  CL.AddTypeS('TDBTreeOption', '( dtAllowDelete, dtAllowInsert, dtAutoDragMove,'
   +' dtAutoExpand, dtAutoShowRoot, dtCancelOnExit, dtConfirmDelete, dtFocusOnE'
   +'dit, dtInsertAsChild, dtMouseMoveSelect, dtRebuildFocusedOnly, dtRootItemR'
   +'eadOnly, dtSynchronizeDataSet )');
  CL.AddTypeS('TDBTreeOptions', 'set of TDBTreeOption');
  CL.AddTypeS('TDBTVGetNextIDEvent', 'Function ( Sender : TObject; DataSet : TDataSet) : string');
  CL.AddTypeS('TTVFindTextOption', '( tvftCaseInsensitive, tvftPartial )');
  CL.AddTypeS('TTVFindTextOptions', 'set of TTVFindTextOption');
  CL.AddTypeS('TDBTreeViewState', '( dtvsBuilding, dtvsDatasetInEditMode, dtvsE'
   +'ditAfterReBuild, dtvsDatasetInInsertMode, dtvsLostFocusWhileDatasetInEditM'
   +'odes, dtvsChangingDataset, dtvsNeedReBuildAfterPost, dtvsNeedReBuild, dtvsDataSetNeedsRefresh )');
  CL.AddTypeS('TDBTreeViewStates', 'set of TDBTreeViewState');
  SIRegister_TTreeViewLink(CL);
  SIRegister_TTreeIDNode(CL);
  SIRegister_TCustomDBTreeView(CL);
  SIRegister_TDBTreeView(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewOptions_W(Self: TCustomDBTreeView; const T: TDBTreeOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewOptions_R(Self: TCustomDBTreeView; var T: TDBTreeOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewOnRootNotFound_W(Self: TCustomDBTreeView; const T: TNotifyEvent);
begin Self.OnRootNotFound := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewOnRootNotFound_R(Self: TCustomDBTreeView; var T: TNotifyEvent);
begin T := Self.OnRootNotFound; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewOnGetNextID_W(Self: TCustomDBTreeView; const T: TDBTVGetNextIDEvent);
begin Self.OnGetNextID := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewOnGetNextID_R(Self: TCustomDBTreeView; var T: TDBTVGetNextIDEvent);
begin T := Self.OnGetNextID; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewOnClosedLoop_W(Self: TCustomDBTreeView; const T: TNotifyEvent);
begin Self.OnClosedLoop := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewOnClosedLoop_R(Self: TCustomDBTreeView; var T: TNotifyEvent);
begin T := Self.OnClosedLoop; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewRootID_W(Self: TCustomDBTreeView; const T: string);
begin Self.RootID := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewRootID_R(Self: TCustomDBTreeView; var T: string);
begin T := Self.RootID; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewTableTextField_W(Self: TCustomDBTreeView; const T: string);
begin Self.TableTextField := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewTableTextField_R(Self: TCustomDBTreeView; var T: string);
begin T := Self.TableTextField; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewTableParentField_W(Self: TCustomDBTreeView; const T: string);
begin Self.TableParentField := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewTableParentField_R(Self: TCustomDBTreeView; var T: string);
begin T := Self.TableParentField; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewTableIDField_W(Self: TCustomDBTreeView; const T: string);
begin Self.TableIDField := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewTableIDField_R(Self: TCustomDBTreeView; var T: string);
begin T := Self.TableIDField; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewDataSource_W(Self: TCustomDBTreeView; const T: TDataSource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewDataSource_R(Self: TCustomDBTreeView; var T: TDataSource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewIDs_R(Self: TCustomDBTreeView; var T: string; const t1: Integer);
begin T := Self.IDs[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewSelectedID_W(Self: TCustomDBTreeView; const T: string);
begin Self.SelectedID := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewSelectedID_R(Self: TCustomDBTreeView; var T: string);
begin T := Self.SelectedID; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBTreeViewDataSet_R(Self: TCustomDBTreeView; var T: TDataSet);
begin T := Self.DataSet; end;

(*----------------------------------------------------------------------------*)
procedure TTreeIDNodeID_W(Self: TTreeIDNode; const T: string);
begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeIDNodeID_R(Self: TTreeIDNode; var T: string);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBTreeView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBTreeView) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomDBTreeView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomDBTreeView) do begin
    RegisterConstructor(@TCustomDBTreeView.Create, 'Create');
      RegisterMethod(@TCustomDBTreeView.Destroy, 'Free');
      RegisterMethod(@TCustomDBTreeView.RebuildTree, 'RebuildTree');
    RegisterMethod(@TCustomDBTreeView.BuildTreeIfNeeded, 'BuildTreeIfNeeded');
    RegisterMethod(@TCustomDBTreeView.Insert, 'Insert');
    RegisterMethod(@TCustomDBTreeView.Delete, 'Delete');
    RegisterMethod(@TCustomDBTreeView.MoveNode, 'MoveNode');
    RegisterMethod(@TCustomDBTreeView.FindTextID, 'FindTextID');
    RegisterMethod(@TCustomDBTreeView.TextIDList, 'TextIDList');
    RegisterMethod(@TCustomDBTreeView.GetExpanded, 'GetExpanded');
    RegisterMethod(@TCustomDBTreeView.SetExpanded, 'SetExpanded');
    RegisterMethod(@TCustomDBTreeView.SynchronizeSelectedNodeToCurrentRecord, 'SynchronizeSelectedNodeToCurrentRecord');
    RegisterMethod(@TCustomDBTreeView.SynchronizeCurrentRecordToSelectedNode, 'SynchronizeCurrentRecordToSelectedNode');
    RegisterMethod(@TCustomDBTreeView.IDOfNode, 'IDOfNode');
    RegisterMethod(@TCustomDBTreeView.GetIDNode, 'GetIDNode');
    RegisterPropertyHelper(@TCustomDBTreeViewDataSet_R,nil,'DataSet');
    RegisterPropertyHelper(@TCustomDBTreeViewSelectedID_R,@TCustomDBTreeViewSelectedID_W,'SelectedID');
    RegisterPropertyHelper(@TCustomDBTreeViewIDs_R,nil,'IDs');
    RegisterPropertyHelper(@TCustomDBTreeViewDataSource_R,@TCustomDBTreeViewDataSource_W,'DataSource');
    RegisterPropertyHelper(@TCustomDBTreeViewTableIDField_R,@TCustomDBTreeViewTableIDField_W,'TableIDField');
    RegisterPropertyHelper(@TCustomDBTreeViewTableParentField_R,@TCustomDBTreeViewTableParentField_W,'TableParentField');
    RegisterPropertyHelper(@TCustomDBTreeViewTableTextField_R,@TCustomDBTreeViewTableTextField_W,'TableTextField');
    RegisterPropertyHelper(@TCustomDBTreeViewRootID_R,@TCustomDBTreeViewRootID_W,'RootID');
    RegisterPropertyHelper(@TCustomDBTreeViewOnClosedLoop_R,@TCustomDBTreeViewOnClosedLoop_W,'OnClosedLoop');
    RegisterPropertyHelper(@TCustomDBTreeViewOnGetNextID_R,@TCustomDBTreeViewOnGetNextID_W,'OnGetNextID');
    RegisterPropertyHelper(@TCustomDBTreeViewOnRootNotFound_R,@TCustomDBTreeViewOnRootNotFound_W,'OnRootNotFound');
    RegisterPropertyHelper(@TCustomDBTreeViewOptions_R,@TCustomDBTreeViewOptions_W,'Options');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTreeIDNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTreeIDNode) do
  begin
    RegisterConstructor(@TTreeIDNode.Create, 'Create');
    RegisterMethod(@TTreeIDNode.Assign, 'Assign');
    RegisterPropertyHelper(@TTreeIDNodeID_R,@TTreeIDNodeID_W,'ID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTreeViewLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTreeViewLink) do
  begin
    RegisterConstructor(@TTreeViewLink.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_dbTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomDBTreeView) do
  RIRegister_TTreeViewLink(CL);
  RIRegister_TTreeIDNode(CL);
  RIRegister_TCustomDBTreeView(CL);
  RIRegister_TDBTreeView(CL);
end;

 
 
{ TPSImport_dbTree }
(*----------------------------------------------------------------------------*)
procedure TPSImport_dbTree.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_dbTree(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_dbTree.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_dbTree(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
