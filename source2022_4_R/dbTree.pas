unit dbTree;

{ TDBTreeView component: Data-Aware TTreeView component.
  Version 0.85  May-17-1998  (C) 1997,98 Christoph R. Kirchner
}
{ Users of this unit must accept this disclaimer of warranty:
    "This unit is supplied as is. The author disclaims all warranties,
    expressed or implied, including, without limitation, the warranties
    of merchantability and of fitness for any purpose.
    The author assumes no liability for damages, direct or
    consequential, which may result from the use of this unit."

  This Unit is donated to the public as public domain.

  This Unit can be freely used and distributed in commercial and
  private environments provided this notice is not modified in any way.

  If you do find this Unit handy and you feel guilty for using such a
  great product without paying someone - sorry :-)

  Please forward any comments or suggestions to Christoph Kirchner at:
  ckirchner@geocities.com

  Maybe you can find an update of this component at my
  "Delphi Component Building Site":
  http://www.geocities.com/SiliconValley/Heights/7874/delphi.htm

  Thanks to Maxim Monin for his TDBOutline-component I could start with.
}


interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  CommCtrl, Dialogs, BDE, Dbconsts, DB, DBTables, StdCtrls, ComCtrls,
  TreeVwEx, ECDataLink, dbTvRecordList;

type

  TCustomDBTreeView = class;

  TDBTreeOption = (
    dtAllowDelete, dtAllowInsert, dtAutoDragMove, dtAutoExpand,
    dtAutoShowRoot, dtCancelOnExit, dtConfirmDelete, dtFocusOnEdit,
    dtInsertAsChild, dtMouseMoveSelect, dtRebuildFocusedOnly,
    dtRootItemReadOnly, dtSynchronizeDataSet);
  TDBTreeOptions = set of TDBTreeOption;

{ Options:

  dtAutoDragMove:
    The user can move items by dragging them in the DBTreeView.
    The parent-field of the record of the moved item will be set to the
    ID of the new parent automatically.

  dtAutoExpand:
    The tree will get expanded completely after building.

  dtAutoShowRoot:
    The ShowRoot property specifies whether lines connecting root (top-
    level) items are displayed. If dtAutoShowRoot is in Options, the
    DBTreeView will set the ShowRoot property itself, depending on the
    numbers of root-items: If are more then one of them, the DBTreeView
    will set the ShowRoot property to True, otherwise it will set the
    ShowRoot property to False.
    ShowRoot = True will show lines connecting the root items if the
    ShowLines property is True, and If ShowButtons is set to True, a
    button will appear to the left of each root item.

  dtCancelOnExit:
    An insertion-operation get canceled if the user leaves the DbTreeView
    without changing the inserted record. This avoids empty records in the
    table. DtCancelOnExit is similar to dgCancelOnExit of TDBGrid.

  dtConfirmDelete:
    The user gets asked if he really want to delete the current record
    after he pressed the Del-key. If the current record has children, the
    user gets asked if he want to delete them first.

  dtFocusOnEdit:
    If the dataset changes to edit- or insert-mode, the DbTreeView will
    get the focus. This allows to user to edit the tree-node directly
    after pressing edit or insert on a navigation-button. Also, if the
    dateaset is in edit- or insert-mode and the DbTreeView receives the
    focus, the selected node goes into the edit-mode. Please do not set
    dtFocusOnEdit if there is TDBEdit, TDBMemo or TDBGrid on the form
    connected to the same dataset - the user could get confused too much.
    Also, please set dtSynchronizeDataSet too if you use dtFocusOnEdit.
    Setting dtFocusOnEdit is recommended if there is - more or less -
    only a DbTreeView and a DBNavigator on the form.

  dtInsertAsChild:
    The new item that is created by pressing the insert key gets
    inserted after the selected node if tveInsertAsChild is false or
    it gets inserted as a child of the selected node if tveInsertAsChild
    is true.

  dtMouseMoveSelect:
    If the user moves the mouse, the nearest node gets selected.
    If the user moves the mouse to the upper or lower border of the
    DbTreeView while left button pressed, the DbTreeView will scroll.
    This scrolling happens anyway if the user drags a node.
    The option dtMouseMoveSelect makes sense if the DbTreeView is shown
    in a dropdown-panel.

  dtRebuildFocusedOnly:
    If dtRebuildFocusedOnly is in Options, the DbTreeView will not
    rebuild the tree after the dataset changed unless the DbTreeView gets
    the focus. This is not set by default. The TDbTreeLookupComboBox uses
    this option to avoid needless rebuilds of the DbTreeView in the drop-
    down-panel until it gets visible.

  dtRootItemReadOnly:
    If there is a record in the dataset with the ID of RootID, then you
    can set it to read-only by setting RootItemReadOnly to true.

  dtSynchronizeDataSet:
    The current selected treenode will always represent the current record
    of the DataSet. If not dtSynchronizeDataSet in Options, selecting
    treenodes gets faster.
  }

  TDBTVGetNextIDEvent =
    function (Sender: TObject; DataSet: TDataSet): string of object;

  TTVFindTextOption = (tvftCaseInsensitive, tvftPartial);
  TTVFindTextOptions = set of TTVFindTextOption;

  TDBTreeViewState = (
    dtvsBuilding, dtvsDatasetInEditMode, dtvsEditAfterReBuild,
    dtvsDatasetInInsertMode, dtvsLostFocusWhileDatasetInEditModes,
    dtvsChangingDataset, dtvsNeedReBuildAfterPost, dtvsNeedReBuild,
    dtvsDataSetNeedsRefresh);
  TDBTreeViewStates = set of TDBTreeViewState;


  TTreeViewLink = class(TECDataLink)
  private
    FTreeView: TCustomDBTreeView;
  protected
    procedure DatasetRefreshed; override;
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure RecordChanged(Field: TField); override;
    procedure EditingChanged; override;
  { procedure UpdateData; override; }
    procedure DoBeforePost(DataSet: TDataSet); override;
    procedure DoAfterPost(DataSet: TDataSet); override;
    procedure DoAfterCancel(DataSet: TDataSet); override;
    procedure DoBeforeDelete(DataSet: TDataSet); override;
    procedure DoAfterDelete(DataSet: TDataSet); override;
    procedure DoBeforeEdit(DataSet: TDataSet); override;
    procedure DoBeforeInsert(DataSet: TDataSet); override;
  public
    constructor Create(ATreeView: TCustomDBTreeView);
  end;

  TTreeIDNode = class(TTreeNode)
  private
    FID: string;
  public
    constructor Create(AOwner: TTreeNodes);
    procedure Assign(Source: TPersistent); override;
    property ID: string read FID write FID;
  end;

  TCustomDBTreeView = class(TCustomTreeViewEx)
  private
    FOptions: TDBTreeOptions;
    FTreeViewLink: TTreeViewLink;
    FTableIDField: string;
    FTableParentField: string;
    FTableTextField: string;
    FRootID: string;
    FPrevState: TDataSetState;
    FDelRootID: string;
    FIDOfDeleted: string;
    FState: TDBTreeViewStates;
    FTVRecordList: TTVRecordList;
    FReBuildTimer: Longint;
    FSaveIDList: TStringList;
    FUserOnEdited: TTVEditedEvent;
    FOnClosedLoop: TNotifyEvent;
    FOnRootNotFound: TNotifyEvent;
    FOnGetNextID: TDBTVGetNextIDEvent;
    function  GetDataSource: TDataSource;
    procedure SetDataSource(ADataSource: TDataSource);
    procedure SetTableIDField(const Value: string);
    procedure SetTableParentField(const Value: string);
    procedure SetTableTextField(const Value: string);
    function  GetDataSet: TDataSet;
    procedure SetRootID(ID: string);
    procedure SetOptions(Value: TDBTreeOptions);
    function CreateTVRecordList: TTVRecordList;
    function  NeedRebuild: Boolean;
    procedure CreateTree(ParentNode: TTreeNode;
      const AParent: string; TempRecordList: TTVRecordList);
    function  AddNewNodeFromDataset(
      Node: TTreeNode; AsChild: Boolean): TTreeNode;
    function  GetDataSetIDNode: TTreeNode;
    function  GetID(AIndex: Integer): string;
    function  GetSelectedID: string;
    procedure SelectID(const Value: string);
    procedure IndexChanged;
    procedure AfterEdit(Sender: TObject; Node: TTreeNode; var S: string);
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure WMSetFocus(var Message: TMessage); message WM_SETFOCUS;
    procedure WMTimer(var Msg: TWMTimer); message WM_TIMER;
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function CreateNode: TTreeNode; override;
    function CanDelete(Node: TTreeNode): Boolean; override;
    function CanEdit(Node: TTreeNode): Boolean; override;
    procedure Edit(const Item: TTVItem); override;
    procedure Change(Node: TTreeNode); override;
    procedure Expand(Node: TTreeNode); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure KillAllTimer; override;
    function DragAllowed(Node: TTreeNode): Boolean; override;
    procedure ActiveChanged(Value: Boolean);
    procedure DataChanged;
    procedure RecordNumberChanged;
    procedure RecordChanged(Field: TField);
    procedure EditingChanged;
    procedure DataSetBeforePost;
    procedure DataSetAfterPost;
    procedure DataSetAfterCancel;
    procedure DataSetBeforeDelete;
    procedure DataSetAfterDelete;
    procedure DatasetRefreshed;
    procedure ClosedLoop;
    procedure RootNotFound;
    function DataSetLocate(const ID: string): Boolean;
    function GetDeleteQuestion(Node: TTreeNode): string; override;
    function DoDelete(Node: TTreeNode): Boolean; override;
  { Called by procedure Insert, GetNewID has to calculate the ID of a
    new record. It calls OnGetNextID: }
    function GetNewID: string; virtual;
    procedure BuildTree; virtual;
    property  TreeViewLink: TTreeViewLink read FTreeViewLink;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RebuildTree;
    procedure BuildTreeIfNeeded;
    procedure Insert(AsChild: Boolean); override;
    procedure Delete; override;
    function MoveNode(Source, Destination: TTreeNode;
                      Mode: TNodeAttachMode): Boolean; override;
    function FindTextID(const S: string; var ID: string;
      TVFindTextOptions: TTVFindTextOptions): Boolean;
    function TextIDList(const S: string;
      TVFindTextOptions: TTVFindTextOptions): TStringList;
  { With GetExpanded you can save all Items[].Expanded in a string
    (e.g. to save this in an INI-file)
    to restore all Items[].Expanded with SetExpanded: }
    function GetExpanded(Separator: Char): string;
    procedure SetExpanded(const List: string; Separator: Char);
  { If not dtSynchronizeDataSet in Options, use this procedure to show
    the current record of the dataset in the tree: }
    procedure SynchronizeSelectedNodeToCurrentRecord;
  { If not dtSynchronizeDataSet in Options, use this procedure to move
    the dataset to the selected node of the tree: }
    procedure SynchronizeCurrentRecordToSelectedNode;
(*
  { IsRootNode is true if the node has no parent: }
    function IsRootNode(Node: TTreeNode): Boolean;
  { IsSingleRootNode is true if the node is the only one without parent: }
    function IsSingleRootNode(Node: TTreeNode): Boolean;
*)
  { To get the ID of a Node: }
    function IDOfNode(Node: TTreeNode): string;
  { To get the Node that has the ID: }
    function GetIDNode(const aID: string): TTreeNode;
  { DataSource.DataSet: }
    property DataSet: TDataSet read GetDataSet;
  { The ID of the current selected node,
    or set Selected with SelectedID := ID: }
    property SelectedID: string read GetSelectedID write SelectID;
  { ID of Items[Index]. Index is 0 to Items.Count -1: }
    property IDs[Index: Integer]: string read GetID;
  { possible published: }
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property TableIDField: string read FTableIDField write SetTableIDField;
    property TableParentField: string
      read FTableParentField write SetTableParentField;
    property TableTextField: string
      read FTableTextField write SetTableTextField;
    property RootID: string read FRootID write SetRootID;
    property OnClosedLoop: TNotifyEvent read FOnClosedLoop write FOnClosedLoop;
  { Called by the procedure Insert, OnGetNextID has to calculate the ID of
    a new record. This is not needed if the type of the ID-field is ftAutoInc.
    You have to override GetNewID if you hide the record with the highest
    ID and the type of the ID-field is not ftAutoInc:
    - DataSet is TQuery and TQuery.SQL uses 'WHERE ...'
    - DataSet.MasterSource is set.
    If you use a TQuery as Dataset, it is recommended to calculate the
    new ID yourself.
    If you set the new ID on Dataset.OnNewRecord, please use OnGetNextID
    or your own GetNewID because the ID is needed before the Dataset gets
    into insert-mode. }
    property OnGetNextID: TDBTVGetNextIDEvent
      read FOnGetNextID write FOnGetNextID;
    property OnRootNotFound: TNotifyEvent
      read FOnRootNotFound write FOnRootNotFound;
    property Options: TDBTreeOptions read FOptions write SetOptions;
  end;


  TDBTreeView = class(TCustomDBTreeView)
  published
    property ShowButtons;
    property BorderStyle;
    property DragCursor;
    property ShowLines;
    property ShowRoot;
    property ReadOnly;
    property DragMode;
    property HideSelection;
    property Indent;
    property OnEditing;
    property OnEdited;
    property OnExpanding;
    property OnExpanded;
    property OnCollapsing;
    property OnCompare;
    property OnCollapsed;
    property OnChanging;
    property OnChange;
    property OnDeletion;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property OnMouseSelect;
    property Align;
    property Enabled;
    property Font;
    property Color;
    property ParentColor;
    property ParentCtl3D;
    property Ctl3D;
    property SortType;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnDragDrop;
    property OnDragOver;
    property OnStartDrag;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property PopupMenu;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Images;
    property StateImages;
    property DataSource;
    property DragImageShow default tvdisDefault;
    property TableIDField;
    property TableParentField;
    property TableTextField;
    property RootID;
    property OnClosedLoop;
    property OnGetNextID;
    property OnRootNotFound;
    property Options
      default [dtAllowDelete, dtAllowInsert, dtAutoDragMove, dtAutoExpand,
               dtAutoShowRoot, dtRootItemReadOnly, dtConfirmDelete,
               dtCancelOnExit, dtSynchronizeDataSet];
  end;


var
  sdbtvDefaultDeleteQuestion: string;


implementation

const
  Full = true;
  TimerIDRebuild = 1002;
  RebuildTickCount = 500;


{ TTreeIDNode --------------------------------------------------------------- }

constructor TTreeIDNode.Create(AOwner: TTreeNodes);
begin
  inherited Create(AOwner);
  FID := '';
end;

procedure TTreeIDNode.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if (Source <> nil) and (Source is TTreeIDNode) then
    FID := TTreeIDNode(Source).ID
  else
    FID := '';
end;


{ TTreeViewLink ------------------------------------------------------------- }

constructor TTreeViewLink.Create(ATreeView: TCustomDBTreeView);
begin
  inherited Create;
  FTreeView := ATreeView;
end;

procedure TTreeViewLink.DatasetRefreshed;
begin
  if Assigned(FTreeView) then
    FTreeView.DatasetRefreshed;
end;

procedure TTreeViewLink.ActiveChanged;
begin
  inherited;
  FTreeView.ActiveChanged(Active);
end;

procedure TTreeViewLink.DataSetChanged;
begin
  if not CanCheckRefresh then { we don't know if a refresh happend: }
    Include(FTreeView.FState, dtvsNeedReBuild);
  FTreeView.DataChanged;
end;

procedure TTreeViewLink.DataSetScrolled(Distance: Integer);
begin
  FTreeView.RecordNumberChanged;
end;

procedure TTreeViewLink.RecordChanged(Field: TField);
begin
  FTreeView.RecordChanged(Field);
end;

procedure TTreeViewLink.EditingChanged;
begin
  FTreeView.EditingChanged;
end;

procedure TTreeViewLink.DoBeforePost(DataSet: TDataSet);
begin
  inherited;
  FTreeView.DataSetBeforePost;
end;

procedure TTreeViewLink.DoAfterCancel(DataSet: TDataSet);
begin
  inherited;
  FTreeView.DataSetAfterCancel;
end;

procedure TTreeViewLink.DoBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  FTreeView.DataSetBeforeDelete;
end;

procedure TTreeViewLink.DoAfterDelete(DataSet: TDataSet);
begin
  inherited;
  FTreeView.DataSetAfterDelete;
end;

procedure TTreeViewLink.DoAfterPost(DataSet: TDataSet);
begin
  inherited;
  FTreeView.DataSetAfterPost;
end;

procedure TTreeViewLink.DoBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  FTreeView.BuildTreeIfNeeded;
end;

procedure TTreeViewLink.DoBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  FTreeView.BuildTreeIfNeeded;
end;

(*
procedure TTreeViewLink.DoBeforeCancel(DataSet: TDataSet);
begin
  inherited;
end;

procedure TTreeViewLink.DoAfterEdit(DataSet: TDataSet);
begin
  inherited;
end;

procedure TTreeViewLink.DoAfterInsert(DataSet: TDataSet);
begin
  inherited;
end;
*)

{ TCustomDBTreeView --------------------------------------------------------- }

constructor TCustomDBTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTreeViewLink := TTreeViewLink.Create(Self);
  FPrevState := dsInactive;
  FState := [];
  FRootID := '';
  FIDOfDeleted := '';
  FTVRecordList := nil;
  FReBuildTimer := 0;
  FUserOnEdited := nil;
  FOnClosedLoop := nil;
  FOnRootNotFound := nil;
  FOnGetNextID := nil;
  FSaveIDList := nil;
  Options := [dtAllowDelete, dtAllowInsert, dtAutoDragMove, dtAutoExpand,
              dtAutoShowRoot, dtRootItemReadOnly, dtConfirmDelete,
              dtCancelOnExit, dtSynchronizeDataSet];
end;

destructor TCustomDBTreeView.Destroy;
begin
  FTreeViewLink.Free;
  FTreeViewLink := nil;
  if Assigned(FTVRecordList) then
    FTVRecordList.Free;
  if Assigned(FSaveIDList) then
    FSaveIDList.Free;
  inherited Destroy;
end;

procedure TCustomDBTreeView.KillAllTimer;
begin
  inherited;
  if (FReBuildTimer <> 0) then
    KillTimer(Handle, TimerIDRebuild);
  FReBuildTimer := 0;
end;

function TCustomDBTreeView.GetDataSource: TDataSource;
begin
  Result := FTreeViewLink.DataSource;
end;

procedure TCustomDBTreeView.SetDataSource(ADataSource: TDataSource);
begin
  if (FTreeViewLink.DataSource <> ADataSource) then
  begin
    FTreeViewLink.DataSource := ADataSource;
  { BuildTree will be done at ActiveChanged }
  end;
end;

procedure TCustomDBTreeView.SetTableIDField(const Value: string);
begin
  if (FTableIDField <> Value) then
  begin
    FTableIDField := Value;
    BuildTree;
  end;
end;

procedure TCustomDBTreeView.SetTableParentField(const Value: string);
begin
  if (FTableParentField <> Value) then
  begin
    FTableParentField := Value;
    BuildTree;
  end;
end;

procedure TCustomDBTreeView.SetTableTextField(const Value: string);
begin
  if (FTableTextField <> Value) then
  begin
    FTableTextField := Value;
    BuildTree;
  end;
end;

function  TCustomDBTreeView.GetDataSet: TDataSet;
begin
  Result := FTreeViewLink.DataSet;
end;

procedure TCustomDBTreeView.Notification(
  AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FTreeViewLink <> nil) and
     (AComponent = DataSource) then
  begin
    KillAllTimer;
    DataSource := nil;
    Items.Clear;
    FRSelected := nil;
    if Assigned(FSaveIDList) then
    begin
      FSaveIDList.Free;
      FSaveIDList := nil;
    end;
  end;
end;

procedure TCustomDBTreeView.ActiveChanged(Value: Boolean);
begin
  if not Value then
  begin
    KillAllTimer;
    Items.Clear;
    FRSelected := nil;
    FPrevState := dsInactive;
    FState := [];
    if Assigned(FTVRecordList) then
    begin
      FTVRecordList.Free;
      FTVRecordList := nil;
    end;
    if Assigned(FSaveIDList) then
    begin
      FSaveIDList.Free;
      FSaveIDList := nil;
    end;
  end
  else
    if not (csDestroying in ComponentState) then
    begin
      FPrevState := DataSet.State;
      BuildTree;
    end;
end;

function TCustomDBTreeView.CreateTVRecordList: TTVRecordList;
var
  TVRecordList: TTVRecordList;
  aBookmark: TBookmark;
  IndexIDField: Integer;
  IndexParentField: Integer;
  IndexTextField: Integer;
begin
  TVRecordList := TTVRecordList.Create;
  aBookmark := nil;
  with DataSet do
  try
    aBookmark := GetBookmark;
    try
      if (FTableParentField = '') then
      begin
        IndexIDField := FieldByName(FTableIDField).Index;
        IndexTextField := FieldByName(FTableTextField).Index;
        First;
        while not EOF do
        begin
          TVRecordList.AddRecord(Fields[IndexIDField].AsString,
                                 '',
                                 Fields[IndexTextField].AsString);
          Next;
        end;
      end
      else
      begin
        IndexIDField := FieldByName(FTableIDField).Index;
        IndexParentField := FieldByName(FTableParentField).Index;
        IndexTextField := FieldByName(FTableTextField).Index;
        First;
        while not EOF do
        begin
          TVRecordList.AddRecord(Fields[IndexIDField].AsString,
                                 Fields[IndexParentField].AsString,
                                 Fields[IndexTextField].AsString);
          Next;
        end;
      end;
      TVRecordList.Sorted := true;
    except
      TVRecordList.Free;
      TVRecordList := nil;
      raise;
    end;
  finally
    if (aBookmark <> nil) then
    begin
      GotoBookmark(aBookmark);
      FreeBookmark(aBookmark);
    end;
  end;
  result := TVRecordList;
end;

procedure TCustomDBTreeView.BuildTree;
var
  TopItemID: string;
  SelectedItemID: string;
  Node: TTreeNode;
  PreviousSortType: TSortType;
  NewTVRecordList: TTVRecordList;

procedure StoreExpanded;
var
  i: Integer;
  Node: TTreeNode;
  IDIndex: Integer;
  DefaultExpand: Boolean;
begin
  if (FTVRecordList = nil) then
    exit;
  DefaultExpand := (dtAutoExpand in Options);
  for i := 0 to FTVRecordList.Count - 1 do
    TTvRecordInfo(FTVRecordList[i]).WasExpanded := DefaultExpand;
{ Store all Items[].Expanded to restore it after rebuild: }
  Node := Items.GetFirstNode;
  while (Node <> nil) do
  begin
    if (Node.Count > 0) then
    begin
      if FTVRecordList.FindID(IDOfNode(Node), IDIndex) then
        TTvRecordInfo(FTVRecordList[IDIndex]).WasExpanded := Node.Expanded;
    end;
    Node := Node.GetNext;
  end;
end; { StoreExpanded }

procedure ReStoreExpanded;
var
  IDIndex: Integer;
  DefaultExpand: Boolean;
  Node: TTreeNode;
begin
  DefaultExpand := (dtAutoExpand in Options);
  if (FTVRecordList <> nil) then
  begin
  { Expand previous expanded items: }
    Node := Items.GetFirstNode;
    while (Node <> nil) do
    begin
      if (Node.Count > 0) then
      begin
        if FTVRecordList.FindID(IDOfNode(Node), IDIndex) then
          Node.Expanded := TTvRecordInfo(FTVRecordList[IDIndex]).WasExpanded
        else
          Node.Expanded := DefaultExpand;
      end;
      Node := Node.GetNext;
    end;
  end
  else
    if DefaultExpand then
      FullExpand;
end; { ReStoreExpanded }

procedure DoCreateTree;
var
  i: Integer;
  ParentIndex: Integer;
  IDIndex: Integer;
  RootCount: Integer;
begin
  if (FTableParentField = '') then
  begin
    for i := 0 to NewTVRecordList.Count - 1 do
    begin
      with TTvRecordInfo(NewTVRecordList[i]) do
      begin
        Node := Items.Add(nil, Text);
        TTreeIDNode(Node).ID := ID;
      end;
    end;
    exit;
  end;
{ find root and call CreateTree: }
  Node := nil;
  if (FRootID <> '') then
  begin
    if NewTVRecordList.FindID(FRootID, IDIndex) then
    begin
      with TTvRecordInfo(NewTVRecordList[IDIndex]) do
      begin
      { Record with the ID = RootID found, add it first: }
        Node := Items.Add(nil, Text);
        TTreeIDNode(Node).ID := FRootID;
      end;
      CreateTree(Node, FRootID, NewTVRecordList);
      if (dtAutoShowRoot in Options) then
        ShowRoot := false;
    end;
    if (Node = nil) and (NewTVRecordList.Count > 0) then
    begin
    { No record with the ID = RootID found, but dataset is not empty: }
      RootNotFound;
      if NewTVRecordList.FindParent(FRootID, ParentIndex) then
      begin
      { At least one record with Parent = RootID found: }
        if (dtAutoShowRoot in Options) then
        { ShowRoot if more then one record with Parent = RootID exists: }
          ShowRoot :=
            (ParentIndex + 1 < NewTVRecordList.Count) and
            (NewTVRecordList.Parent[ParentIndex + 1].Parent = FRootID);
        CreateTree(nil, FRootID, NewTVRecordList);
      end;
    end;
  end
  else
  begin
  { FRootID = '': }
    RootCount := 0;
    for i := 0 to NewTVRecordList.Count - 1 do
    begin
      with TTvRecordInfo(NewTVRecordList[i]) do
        if not NewTVRecordList.FindID(Parent, IDIndex) then
        begin
        { Record without parent found: }
          Inc(RootCount);
          Node := Items.Add(nil, Text);
          TTreeIDNode(Node).ID := ID;
          CreateTree(Node, ID, NewTVRecordList);
        end;
    end;
    if (dtAutoShowRoot in Options) then
      ShowRoot := (RootCount > 1); { ShowRoot if more then one root }
  end;
end; { DoCreateTree }

procedure DoRefreshText;
var
  i: Integer;
begin
  for i := 0 to NewTVRecordList.Count - 1 do
  begin
    with TTvRecordInfo(NewTVRecordList[i]) do
      if (TTvRecordInfo(FTVRecordList[i]).Text <> Text) then
      begin
        Node := GetIDNode(ID);
        if (Node <> nil) and (Node.Text <> Text) then
          Node.Text := Text;
      end;
  end;
end; { DoRefreshText }

procedure DoTheBuild;
begin
  if (TopItem = nil) then
    TopItemID := FRootID
  else
    TopItemID := IDOfNode(TopItem);
  SelectedItemID := SelectedID;
  StoreExpanded;
  Items.Clear;
  if Assigned(FSaveIDList) then
  begin
    FSaveIDList.Free;
    FSaveIDList := nil;
  end;
  if (PreviousSortType <> stNone) then
  { adding nodes goes much faster without sorting: }
    SortType := stNone;
  DoCreateTree; { find root and call CreateTree }
  if (PreviousSortType <> stNone) then
    SortType := PreviousSortType;
  Exclude(FState, dtvsBuilding);
  if (Items.Count = 0) then
    exit;
  ReStoreExpanded; { Expand previous expanded items }
{ Find previous TopItem: }
  Node := GetIDNode(TopItemID);
  if (Node <> nil) then
    TopItem := Node;
{ Find previous Selected: }
  if (dtSynchronizeDataSet in Options) then
  begin
  { Select current record: }
    Node := GetDataSetIDNode;
    if (Node = nil) then
    begin
    { Current record not in Items: }
      if (Selected = nil) and (TopItem <> nil) then
        Selected := TopItem;
      if (Selected <> nil) then
        SynchronizeCurrentRecordToSelectedNode;
    end
    else
      Selected := Node;
  end
  else
  begin
    if (SelectedItemID <> '') then
    begin
      Node := GetIDNode(SelectedItemID);
      if (Node = nil) then
      begin
        if (TopItem <> nil) then
          Selected := TopItem;
      end
      else
        Selected := Node;
    end
    else
      if (TopItem <> nil) then
        Selected := TopItem;
  end;
end; { DoTheBuild }

begin { BuildTree }
  FRSelected := nil;
  KillAllTimer;
  FIDOfDeleted := '';
  if not NeedRebuild then exit;
  Exclude(FState, dtvsNeedReBuild);
  PreviousSortType := SortType;
  Items.BeginUpdate; { changes are not visible until EndUpdate }
  try
    DataSet.DisableControls;
    Include(FState, dtvsBuilding);
    if (dtvsDataSetNeedsRefresh in FState) then
    begin
    {$IFDEF Ver90}
      DataSet.UpdateCursorPos;
      if (DbiForceReread(DataSet.Handle) = 0) then
        DataSet.Resync([]);
    {$ELSE DEF Ver90} { Delphi >= 3.0: }
      if (Dataset is TBDEDataSet) then
      begin
        TBDEDataSet(DataSet).UpdateCursorPos;
        if (DbiForceReread(TBDEDataSet(DataSet).Handle) = 0) then
          DataSet.Resync([]);
      end;
    {$ENDIF DEF Ver90}
      Exclude(FState, dtvsDataSetNeedsRefresh);
    end;
    NewTVRecordList := CreateTVRecordList;
    if (NewTVRecordList <> nil) then
    begin
      try
        case NewTVRecordList.GetDifference(FTVRecordList) of
          tvrldNone:
            if (Items.GetFirstNode <> nil) and
               (IDOfNode(Items.GetFirstNode) <> FRootID) then
            { RootID has changed: }
              DoTheBuild;
          tvrldText:
            DoRefreshText;
          else
            DoTheBuild;
        end; { case }
      finally
        if Assigned(FTVRecordList) then
          FTVRecordList.Free;
        FTVRecordList := NewTVRecordList;
      end;
    end;
  finally
    Include(FState, dtvsBuilding);
    DataSet.EnableControls;
    Exclude(FState, dtvsBuilding);
    Items.EndUpdate; { make changes visible }
    Node := Selected;
    if (Node <> nil) then
    begin
      Node.MakeVisible;
      if (dtvsEditAfterReBuild in FState) then
        Node.EditText;
    end;
    Exclude(FState, dtvsEditAfterReBuild);
  end;
end;

function TCustomDBTreeView.NeedRebuild: Boolean;
begin
{ Function BuildTree produce some side effects by changing
  following properties, fields:
  1. DataSet's current record;
  2. Table.IndexFieldNames;
  3. Table.State -> dsBrowse;
  4. Table's buffer for searching;
  There are no ways retain and later restore State
  and search buffer(without using private methods).
  Therefore Building method is called only in Browse state,
  and when not used GoToKey method. }
  Result := false;
  if (FTableIDField = '') or (FTableTextField = '') or
     (csLoading in ComponentState) or (DataSet = nil) then
    exit;
  with DataSet do
  begin
    FPrevState := State;
    if (dtvsBuilding in FState) or (FDisableCount > 0) then
      exit;
    if State = dsBrowse then
      Result := true;
    if (FPrevState = dsSetKey) and (State = dsBrowse) then
      Result := false; { Catch calls of GoToKey method }
  end;
end;

procedure TCustomDBTreeView.CreateTree(ParentNode: TTreeNode;
  const AParent: string; TempRecordList: TTVRecordList);
var
  Node: TTreeNode;
  Index: Integer;
begin
  if TempRecordList.FindParent(AParent, Index) then
  begin
    with TempRecordList.Parent[Index] do
    begin
      if (ID = FRootID) or (ID = AParent) then
      begin
        ClosedLoop;
        exit;
      end;
      Node := Items.AddChild(ParentNode, Text);
      TTreeIDNode(Node).ID := ID;
      CreateTree(Node, ID, TempRecordList);
    end;
    Inc(Index);
    while (Index < TempRecordList.Count) do
    begin
      with TempRecordList.Parent[Index] do
      begin
        if (Parent <> AParent) then
          break;
        if (ID = FRootID) or (ID = AParent) then
          ClosedLoop
        else
        begin
          Node := Items.Add(Node, Text);
          TTreeIDNode(Node).ID := ID;
          CreateTree(Node, ID, TempRecordList);
        end;
      end;
      Inc(Index);
    end;
  end;
end;

procedure TCustomDBTreeView.BuildTreeIfNeeded;
begin
  if (dtvsNeedReBuild in FState) and (FDisableCount = 0) and
     (not (dtvsBuilding in FState)) and
     (DataSet.State = dsBrowse) and
     (FIDOfDeleted = '') and
     ((not (dtRebuildFocusedOnly in Options)) or Focused) then
    BuildTree;
end;

procedure TCustomDBTreeView.ClosedLoop;
begin
  if Assigned(FOnClosedLoop) then
    FOnClosedLoop(Self);
end;

procedure TCustomDBTreeView.RootNotFound;
begin
{ if (csDesigning in ComponentState) then
    ShowMessage('No record with root-ID (' + FRootID + ') found.'); {}
  if Assigned(FOnRootNotFound) then
    FOnRootNotFound(Self);
end;

function TCustomDBTreeView.AddNewNodeFromDataset(
  Node: TTreeNode; AsChild: Boolean): TTreeNode;
begin
  with DataSet do
  begin
    if not AsChild or (Node = nil) then
      Result := Items.Add(Node, FieldByName(FTableTextField).AsString)
    else
      Result := Items.AddChild(Node, FieldByName(FTableTextField).AsString);
    if (Result <> nil) then
      TTreeIDNode(Result).ID := FieldByName(FTableIDField).AsString;
  end;
end;

function TCustomDBTreeView.GetIDNode(const aID: string): TTreeNode;
begin
  Result := Items.GetFirstNode;
  while (Result <> nil) do
  begin
    if (IDOfNode(Result) = aID) then
      exit; // found
    Result := Result.GetNext;
  end;
end;

function TCustomDBTreeView.GetDataSetIDNode: TTreeNode;
begin
  Result := GetIDNode(DataSet.FieldByName(FTableIDField).AsString);
end;

procedure TCustomDBTreeView.DataChanged;
begin
  if (dtvsChangingDataset in FState) or (dtvsBuilding in FState) then
  { TCustomDBTreeView has changed Dataset, do nothing: }
    Exclude(FState, dtvsChangingDataset)
  else
    RecordNumberChanged;
end;

procedure TCustomDBTreeView.DatasetRefreshed;
begin
  Include(FState, dtvsNeedReBuild);
  Include(FState, dtvsDataSetNeedsRefresh);
  if (FReBuildTimer = 0) and
     (Focused or not (dtRebuildFocusedOnly in Options)) then
    FReBuildTimer := SetTimer(Handle, TimerIDRebuild, RebuildTickCount, nil);
end;

procedure TCustomDBTreeView.RecordNumberChanged;
begin
  if (FDisableCount = 0) and (not (dtvsBuilding in FState)) and
     (not IsEditing) and (FIDOfDeleted = '') then
    if (dtvsNeedReBuild in FState) and
       ((not (dtRebuildFocusedOnly in Options)) or Focused) then
      BuildTree
    else
      if (dtSynchronizeDataSet in Options) then
        SynchronizeSelectedNodeToCurrentRecord
end;

procedure TCustomDBTreeView.RecordChanged(Field: TField);
var
  Node: TTreeNode;
  FieldName: string;
begin
  if (FDisableCount = 0) and not (dtvsBuilding in FState) and
     (Field <> nil) then
  begin
    FieldName := UpperCase(Field.FieldName);
    if (FieldName = UpperCase(FTableTextField)) then
    begin
      Node := GetDataSetIDNode;
      if Node <> nil then
      begin
        Include(FState, dtvsChangingDataset);
        Node.Text := DataSet.FieldByName(FTableTextField).AsString;
      end;
    end
    else
      if (FieldName = UpperCase(FTableParentField)) or
         (FieldName = UpperCase(FTableIDField)) or
         ((DataSet is TTable) and
          (Pos(FieldName, UpperCase(TTable(DataSet).MasterFields)) > 0)) or
         (DataSet.Filtered and
          (Pos(FieldName, UpperCase(DataSet.Filter)) > 0)) then
      begin
      { maybe structure of tree changed: }
        if (DataSet.State = dsEdit) or (DataSet.State = dsInsert) then
          Include(FState, dtvsNeedReBuildAfterPost)
        else
          if (not (dtRebuildFocusedOnly in Options)) or Focused then
            BuildTree
          else
            Include(FState, dtvsNeedReBuild);
      end;
  end;
end;

procedure TCustomDBTreeView.EditingChanged;
var
  WasFocused: Boolean;
begin
  if (DataSet.State = dsEdit) then
  begin
    if (FDisableCount = 0) and not ReadOnly and not IsEditing then
    begin
    { DataSet.State has changed from dsEdit to dsBrowse, but that was not
      done by TCustomDBTreeView: }
      if (dtFocusOnEdit in Options) then
        SetFocus;
      if Focused then
      begin
      { TCustomDBTreeView is Focused: Set selected node to edit-mode: }
        if not (dtSynchronizeDataSet in Options) then
          SynchronizeSelectedNodeToCurrentRecord;
        if (Selected <> nil) then
          Selected.EditText;
      end;
    end;
    Include(FState, dtvsDatasetInEditMode);
  end
  else
    if (DataSet.State = dsInsert) then
    begin
      if (FDisableCount = 0) and not ReadOnly then
      begin
      { DataSet was set by someone (not by us) to insert-mode: }
        WasFocused := Focused;
        Inc(FDisableCount); { avoid BuildTree at next action: }
        DataSet.Cancel;     { Cancel insert-mode, because... }
        Insert(dtInsertAsChild in Options); { ... we will do it our way! }
        if (not WasFocused) then
        begin
          if (dtFocusOnEdit in Options) then
            SetFocus
          else
          begin
          { We don't have the focus, do not edit node: }
            if (Selected <> nil) then
              Selected.EndEdit(false);
          { If we get the focus later, please edit node: }
            Include(FState, dtvsLostFocusWhileDatasetInEditModes);
          end;
        end;
        Dec(FDisableCount);
      end;
      Include(FState, dtvsDatasetInInsertMode);
    end;
end;

procedure TCustomDBTreeView.DataSetBeforePost;
begin
  if (dtvsDatasetInEditMode in FState) then
  begin
  { DataSet.State has changed from dsEdit to dsBrowse, but that was not
    done by TCustomDBTreeView: }
    Exclude(FState, dtvsDatasetInEditMode);
    if (FDisableCount = 0) and IsEditing then
    begin
    { TCustomDBTreeView is still in edit-mode but someone posted e.g.
      by pressing post on a DBNavigator. End edit: }
      Inc(FDisableCount);
      with Selected do
      begin
        EndEdit(false);
        if (DataSet.FieldByName(FTableTextField).AsString <> Text) then
          DataSet.FieldByName(FTableTextField).AsString := Text;
      end;
      Dec(FDisableCount);
    end;
  end
  else
  begin
    if (dtvsDatasetInInsertMode in FState) then
    begin
    { DataSet.State has changed from dsInsert to dsBrowse, but that was
      not done by TCustomDBTreeView: }
      Exclude(FState, dtvsDatasetInInsertMode);
      if (FDisableCount = 0) then
      begin
        if IsEditing then
        begin
        { TCustomDBTreeView is still in insert-mode but someone posted
          e.g. by pressing post on a DBNavigator. End insert: }
          Inc(FDisableCount);
          with Selected do
          begin
            EndEdit(false);
            if (DataSet.FieldByName(FTableTextField).AsString <> Text) then
              DataSet.FieldByName(FTableTextField).AsString := Text;
          end;
          Dec(FDisableCount);
        end
        else
        begin
        { insert-mode was not done by us.
          Structure of tree has changed: }
          Include(FState, dtvsNeedReBuildAfterPost);
        end;
      end;
    end;
  end;
  Exclude(FState, dtvsLostFocusWhileDatasetInEditModes);
end;

procedure TCustomDBTreeView.DataSetAfterPost;
begin
  if (dtvsNeedReBuildAfterPost in FState) then
  begin
    Exclude(FState, dtvsNeedReBuildAfterPost);
    if (not (dtRebuildFocusedOnly in Options)) or Focused then
      BuildTree
    else
      Include(FState, dtvsNeedReBuild);
  end;
end;

procedure TCustomDBTreeView.DataSetAfterCancel;
var
  Node: TTreeNode;
begin
  Exclude(FState, dtvsNeedReBuildAfterPost);
  if (dtvsLostFocusWhileDatasetInEditModes in FState) then
  begin
    if (Selected <> nil) and not IsEditing then
    begin
    { Maybe we changed the Text of the node, but that was cancelled now: }
      Selected.Text := DataSet.FieldByName(FTableTextField).AsString;
    end;
    Exclude(FState, dtvsLostFocusWhileDatasetInEditModes);
  end;
  if (dtvsDatasetInEditMode in FState) then
  begin
  { DataSet.State has changed from dsEdit to dsBrowse, but that was not
    done by TCustomDBTreeView: }
    Exclude(FState, dtvsDatasetInEditMode);
    if (FDisableCount = 0) and IsEditing then
    { TCustomDBTreeView is still in edit-mode but someone canceled e.g.
      by pressing cancel on a DBNavigator. Stop edit: }
      Selected.EndEdit(true);
  end
  else
  begin
    if (dtvsDatasetInInsertMode in FState) then
    begin
    { DataSet.State has changed from dsInsert to dsBrowse, but that was
      not done by TCustomDBTreeView: }
      Exclude(FState, dtvsDatasetInInsertMode);
      if (FDisableCount = 0) then
      begin
      { Someone canceled inserting, e.g. by pressing cancel on a DBNavigator,
        or a TDBGrid with dgCancelOnExit in Options lost focus: }
        if IsEditing then
        begin
        { still in insert-mode. Stop insert: }
          Node := Selected;
          if (Node <> nil) then
          begin
            Node.EndEdit(true);
            if (Node.GetNextSibling <> nil) then
              Selected := Node.GetNextSibling
            else
              if (Node.GetPrevSibling <> nil) then
                Selected := Node.GetPrevSibling
              else
                if (Node.Parent <> nil) then
                  Selected := Node.Parent;
            Items.Delete(Node);
          end;
        end
        else
        begin
        { Maybe TDBGrid with dgCancelOnExit in Options lost focus and the
          empty record was deleted. }
        { if (DataSet.FieldByName(FTableIDField).AsString <> SelectedID) ...
          does not work because RecordNumberChanged happend already. So: }
          if Assigned(FTVRecordList) then
          begin
          { sorry, but we have to do a complete rebuild: }
            FTVRecordList.Free;
            FTVRecordList := nil;
          end;
          BuildTree;
        end;
      end;
    end;
  end;
end;

procedure TCustomDBTreeView.DataSetBeforeDelete;
var
  Node: TTreeNode;
begin
  if (FDisableCount = 0) and (not Readonly) then
  begin
    Node := GetDataSetIDNode;
    if (Node <> nil) then
    begin
      if (dtRootItemReadOnly in Options) and IsRootNode(Node) then
      { Do not let the user delete a RootNode if dtRootItemReadOnly in Options.
        The EAbort exception is Delphi's "silent" exception.
        When it is raised, no message box appears to inform the user: }
        raise EAbort.Create('RootItem is ReadOnly');
      if (dtConfirmDelete in Options) or Node.HasChildren then
      begin
        DeleteNode(Node); { ask user }
      { Raise the EAbort exception, Delphi's "silent" exception, to stop
        deletion of a record that does not exist anymore: }
        raise EAbort.Create(''); { exit dataset.delete }
      { Sorry, EAbort is not "silent" in the IDE, press F9 to continue... }
      end;
    end
    else
    { record is not in tree: }
      if (dtConfirmDelete in Options) then
      { No confirmation possible: }
        raise EAbort.Create(''); { exit dataset.delete }
  end;
{ No reason to abort deletion or do it ous way: }
  if (FDisableCount = 0) then
    try
      FIDOfDeleted := Dataset.FieldByName(FTableIDField).AsString;
    except
      FIDOfDeleted := '';
    end;
end;

procedure TCustomDBTreeView.DataSetAfterDelete;
var
  Node: TTreeNode;
begin
  if (FDisableCount = 0) then
    if (FIDOfDeleted <> '') then
    begin
      Node := Selected;
      if (Node.GetNextSibling <> nil) then
        Selected := Node.GetNextSibling
      else
        if (Node.GetPrevSibling <> nil) then
          Selected := Node.GetPrevSibling
        else
          if (Node.Parent <> nil) then
            Selected := Node.Parent;
      Items.Delete(Node);
      FIDOfDeleted := '';
    end
    else
      if (not (dtRebuildFocusedOnly in Options)) or Focused then
        BuildTree
      else
        Include(FState, dtvsNeedReBuild);
end;

function TCustomDBTreeView.DataSetLocate(const ID: string): Boolean;
begin
  with DataSet do
  begin
    if (ID = FieldByName(FTableIDField).AsString) then
    begin
      Result := true;
      exit; { nothing to do }
    end;
    if (ID = '') then
    begin
      Result := false;
      exit; { DataSet.Locate does not work with empty value }
    end;
    Include(FState, dtvsChangingDataset);
    Inc(FDisableCount);
    try
      Result := DataSet.Locate(FTableIDField, ID, []);
    finally
      Dec(FDisableCount);
    end;
  end;
end;

procedure TCustomDBTreeView.SynchronizeSelectedNodeToCurrentRecord;
var
  Node: TTreeNode;
begin
  Node := GetDataSetIDNode;
  if (Node <> nil) then
  begin
    Selected := Node;
    Node.MakeVisible;
    if (dtAutoExpand in Options) and Node.HasChildren then
    begin
      try
        Inc(FDisableCount);
        Node.Expand(dtAutoExpand in Options);
        Selected := Node;
      finally
        Dec(FDisableCount);
      end;
    end;
  end;
end;

procedure TCustomDBTreeView.SynchronizeCurrentRecordToSelectedNode;
begin
  if (Selected <> nil) and (DataSet <> nil) and (DataSet.Active) then
    DataSetLocate(SelectedID);
end;

procedure TCustomDBTreeView.IndexChanged;
begin
  if (not (dtvsBuilding in FState)) and (FDisableCount = 0) and
     (dtSynchronizeDataSet in Options) then
   SynchronizeCurrentRecordToSelectedNode;
end;

procedure TCustomDBTreeView.Expand(Node: TTreeNode);
begin
  inherited Expand(Node);
{
  if (not (dtvsBuilding in FState)) and (FDisableCount = 0) and
     (Selected <> nil) then
    Selected.MakeVisible;
}    
end;

procedure TCustomDBTreeView.SetRootID(ID: string);
begin
  if (FRootID <> ID) then
  begin
    FRootID := ID;
    if FTreeViewLink.Active then
      BuildTree;
  end;
end;

function TCustomDBTreeView.GetID(AIndex: Integer): string;
begin
  Result := '';
  if (AIndex >= 0) and (AIndex < Items.Count) then
    Result := IDOfNode(Items[AIndex]);
end;

function TCustomDBTreeView.GetSelectedID: string;
begin
  if Selected = nil then
    Result := FRootID
  else
    Result := IDOfNode(Selected);
end;

procedure TCustomDBTreeView.SelectID(const Value: string);
var
  Node: TTreeNode;
begin
  Node := GetIDNode(Value);
  if (Node <> nil) then
    Selected := Node;
end;

procedure TCustomDBTreeView.CNNotify(var Message: TWMNotify);
begin
  if (Message.NMHdr^.code = TVN_BEGINLABELEDIT) then
  begin
    inherited;
    if (DataSet = nil) then
      exit;
    if (Message.Result = 0) and (DataSet <> nil) then
    begin { node is in edit-mode now: }
      try
        if (DataSet.State = dsBrowse) then
        begin
          if not (dtSynchronizeDataSet in Options) then
            SynchronizeCurrentRecordToSelectedNode; { Synchronize now }
          if (dtvsNeedReBuild in FState) then
          begin
            Message.Result := 1;
            Include(FState, dtvsEditAfterReBuild);
            DatasetRefreshed;
          end
          else
          begin
            Inc(FDisableCount);
            try
              DataSet.Edit;
              if (dtvsNeedReBuild in FState) then
              begin
                DataSet.Cancel;
                Message.Result := 1;
                Include(FState, dtvsEditAfterReBuild);
                DatasetRefreshed;
              end;
            finally
              Dec(FDisableCount);
            end;
          end;
        end;
      except
        Message.Result := 1;
        raise;
      end;
    end;
  end
  else
    inherited;
end;

function TCustomDBTreeView.DragAllowed(Node: TTreeNode): Boolean;
var
  LDataSet: TDataSet;
begin
  result := inherited DragAllowed(Node);
  if result then
  begin
    LDataSet := DataSet;
    if (LDataSet <> nil) then
    begin
      result := LDataSet.CanModify;
      if result and (FTableParentField <> '') then
      begin
        result := LDataSet.FieldByName(FTableParentField).CanModify;
      end;
    end;
  end;
end;

function TCustomDBTreeView.CanDelete(Node: TTreeNode): Boolean;
begin
  KillAllTimer;
  result := inherited CanDelete(Node);
  if result then
  begin
    if (DataSet <> nil) then
      result := DataSet.CanModify;
  end;
end;

function TCustomDBTreeView.CanEdit(Node: TTreeNode): Boolean;
var
  LDataSet: TDataSet;
begin
  KillAllTimer;
  result := inherited CanEdit(Node);
  if result then
  begin
    LDataSet := DataSet;
    if (LDataSet <> nil) then
    begin
      result := LDataSet.CanModify;
      if result and (FTableTextField <> '') then
      begin
        result := LDataSet.FieldByName(FTableTextField).CanModify;
      end;
    end;
  end;
end;

procedure TCustomDBTreeView.AfterEdit(Sender: TObject;
  Node: TTreeNode; var S: string);
begin
  if Assigned(FUserOnEdited) then
    FUserOnEdited(Sender, Node, S);
  if (FDisableCount = 0) and (Node <> nil) then
  begin
    with DataSet do
    begin
      if (State <> dsInsert) and (State <> dsEdit) then
        exit;
      if (FieldByName(FTableIDField).AsString <> IDOfNode(Node)) then
        exit; { maybe an error: this is not the record we started to edit! }
      Inc(FDisableCount);
      try
        if (FieldByName(FTableTextField).AsString <> S) then
          FieldByName(FTableTextField).AsString := S;
        if Focused then { if we just lost focus, don't touch DataSet }
        begin
          Post;
        end;
      finally
        Dec(FDisableCount);
      end;
    end;
  end;
end;

procedure TCustomDBTreeView.Edit(const Item: TTVItem);
var
  DeleteAll: Boolean;
  Canceled: Boolean;
begin
  if Assigned(FUserOnEdited) then
    exit; { rekursive call }
  FUserOnEdited := OnEdited;
  OnEdited := AfterEdit;
  try
    inherited Edit(Item); { calls proc AfterEdit if something was changed }
  finally
    OnEdited := FUserOnEdited;
    FUserOnEdited := nil;
  end;
  if (FDisableCount > 0) then
    exit;
  if (DataSet = nil) then
    exit;
  if not Focused then
  begin
  { we just lost the focus: }
    if (dtCancelOnExit in Options) and (DataSet.State = dsInsert) then
    begin
      if not DataSet.Modified then
      begin
        Exclude(FState, dtvsDatasetInEditMode);
        Exclude(FState, dtvsDatasetInInsertMode);
        DeleteAll := true;
        Canceled := false;
        InternalDeleteNode(Selected, false, DeleteAll, Canceled, false);
        exit;
      end;
    end;
    Include(FState, dtvsLostFocusWhileDatasetInEditModes);
    exit;
  end;
  Exclude(FState, dtvsDatasetInEditMode);
  Exclude(FState, dtvsDatasetInInsertMode);
  if (DataSet.State = dsInsert) then
  begin
  { proc AfterEdit was not called: user canceled inserting }
    DeleteAll := true;
    Canceled := false;
    InternalDeleteNode(Selected, false, DeleteAll, Canceled, false);
  end
  else
    if (DataSet.State = dsEdit) then
    begin
    { proc AfterEdit was not called: user canceled editing }
      Inc(FDisableCount);
      try
        DataSet.Cancel;
      finally
        Dec(FDisableCount);
      end;
    end;
end;

procedure TCustomDBTreeView.Change(Node: TTreeNode);
begin
  if (FDisableCount = 0) then
  begin
    FTreeViewLink.CheckRefresh;
    if (dtvsNeedReBuild in FState) then
      BuildTree;
  end;
  IndexChanged;
  inherited Change(Node);
end;

procedure TCustomDBTreeView.SetOptions(Value: TDBTreeOptions);
var
  TreeViewExOptions: TTreeViewExOptions;
begin
  if (dtSynchronizeDataSet in Value) and
     not (dtSynchronizeDataSet in Options) then
    SynchronizeCurrentRecordToSelectedNode; { Synchronize now }
  TreeViewExOptions := [];
  if (dtAllowDelete in Value) then
    Include(TreeViewExOptions, tveAllowDelete);
  if (dtAllowInsert in Value) then
    Include(TreeViewExOptions, tveAllowInsert);
  if (dtAutoDragMove in Value) then
    Include(TreeViewExOptions, tveAutoDragMove);
  if (dtRootItemReadOnly in Value) then
    Include(TreeViewExOptions, tveRootItemReadOnly);
  if (dtConfirmDelete in Value) then
    Include(TreeViewExOptions, tveConfirmDelete);
  if (dtMouseMoveSelect in Value) then
    Include(TreeViewExOptions, tveMouseMoveSelect);
  if (dtInsertAsChild in Value) then
    Include(TreeViewExOptions, tveInsertAsChild);
  if (FRootID = '') then
    Include(TreeViewExOptions, tveMultipleRootsAllowed);
  inherited Options := TreeViewExOptions;
  FOptions := Value;
end;

function TCustomDBTreeView.GetNewID: string;
var
  FIndexName: string;
  FIndexFields: string;
  sID: string;
  IntValue: Integer;
  ValCode: Integer;
  WasFiltered: Boolean;
begin
  if Assigned(FOnGetNextID) then
  begin
    Result := FOnGetNextID(self, DataSet);
    exit;
  end;
  Result := '0';
  with DataSet do
  begin
    Inc(FDisableCount);
    try
      DisableControls;
      WasFiltered := Filtered;
      try { search for the highest ID-Value first: }
        Filtered := false;
        if (DataSet is TTable) then
          with TTable(DataSet) do
          begin
            FIndexFields := IndexFieldNames;
            FIndexName := IndexName;
            IndexFieldNames := FTableIDField;
          end;
        if (FieldByName(FTableIDField).DataType = ftString) or
           not (DataSet is TTable) or
           (CompareText(Copy(TTable(DataSet).IndexFieldNames, 1,
                             Length(FTableIDField)),
                        FTableIDField) <> 0) then
        begin
        { Check EVERY record for the highest ID-Value: }
          IntValue := 0;
          First;
          while not EOF do
          begin
            try
              sID := FieldByName(FTableIDField).AsString;
              Val(sID, IntValue, ValCode);
              if (ValCode = 0) then
                Inc(IntValue);
            except
            end;
            if (IntValue > StrToInt(Result)) then
              Result := IntToStr(IntValue);
            Next;
          end;
        end
        else
        begin
          Last;
          if not BOF then
          try
            Result := IntToStr(FieldByName(FTableIDField).AsInteger + 1);
          except
          end;
        end;
      finally
        if DataSet is TTable then
          with TTable(DataSet) do
          begin
            if FIndexName <> '' then
              IndexName := FIndexName
            else
              IndexFieldNames := FIndexFields;
          end;
        Filtered := WasFiltered;
      end;
    finally
      EnableControls;
      Dec(FDisableCount);
    end;
  end;
end;

{$HINTS OFF}
procedure TCustomDBTreeView.Insert(AsChild: Boolean);
var
  NewID: string;
  FSelectedID: string;
  NewNode: TTreeNode;
  ParentNode: TTreeNode;
begin
  if (DataSet = nil) then
  begin
    inherited;
    exit;
  end;
  if (FDisableCount = 0) then
  begin
    FTreeViewLink.CheckRefresh;
    if (dtvsNeedReBuild in FState) then
      BuildTree;
  end;
  if not DataSet.CanModify then
    exit;
  Inc(FDisableCount);
  try
    FSelectedID := SelectedID;
    NewID := GetNewID;
    NewNode := nil;
    with DataSet do
    begin
      try
//      DisableControls;
        Append;
        FieldByName(FTableIDField).Value := NewID;
        if AsChild and (Selected <> nil) then
        begin
          if (FSelectedID <> '') and (NewID <> FSelectedID) then
            FieldByName(FTableParentField).Value := FSelectedID;
          NewNode := AddNewNodeFromDataset(Selected, true);
        end
        else
        begin
          if (Selected <> nil) then
          begin
            ParentNode := Selected.Parent;
            if (ParentNode <> nil) and (ParentNode is TTreeIDNode) and
               (TTreeIDNode(ParentNode).ID <> '') and
               (TTreeIDNode(ParentNode).ID <> NewID) then
              FieldByName(FTableParentField).Value := TTreeIDNode(ParentNode).ID;
          end;
          NewNode := AddNewNodeFromDataset(Selected, false);
        end;
        if (NewNode <> nil) then
        begin
          Selected := NewNode;
          if (dtAutoShowRoot in Options) and (Items.Count = 2) and
             IsRootNode(Selected) then
            ShowRoot := true;
        end;
      finally
//        EnableControls;
      end;
    end;
    if (NewNode <> nil) then
    begin
      if (dtFocusOnEdit in Options) then
        SetFocus;
      if Focused then
        NewNode.EditText;
    end;
  finally
    Dec(FDisableCount);
  end;
end;
{$HINTS ON}

function TCustomDBTreeView.GetDeleteQuestion(Node: TTreeNode): string;
begin
  if (Node <> nil) and (Pos('%s', sdbtvDefaultDeleteQuestion) > 0) then
    result := Format(sdbtvDefaultDeleteQuestion, [Node.Text])
  else
    result := sdbtvDefaultDeleteQuestion;
end;

function TCustomDBTreeView.DoDelete(Node: TTreeNode): Boolean;
begin
  if (DataSet = nil) then
  begin
    result := inherited DoDelete(Node);
    exit;
  end;
  if DataSetLocate(IDOfNode(Node)) then
  begin
    if not (DataSet.FieldByName(FTableIDField).Value = IDOfNode(Node)) then
    begin
    { should NEVER happen, but I want to make sure
      not to delete another record }
      result := false;
      exit;
    end;
    Inc(FDisableCount); { no BuildTree please ! }
    try
      if (DataSet.State = dsInsert) then
        DataSet.Cancel { cancel of insert works like deleting it }
      else
        DataSet.Delete;
    finally
      Dec(FDisableCount);
    end;
    result := inherited DoDelete(Node);
    if result and (dtAutoShowRoot in Options) then
      if (Items.Count = 0) then
        ShowRoot := false
      else
        ShowRoot := not IsSingleRootNode(Items[0]);
  end
  else
    result := false;
end;

procedure TCustomDBTreeView.Delete;
begin
  if (DataSet = nil) then
  begin
    inherited;
    exit;
  end;
  if (FDisableCount = 0) then
  begin
    FTreeViewLink.CheckRefresh;
    if (dtvsNeedReBuild in FState) then
      BuildTree;
  end;
  if DataSet.CanModify then
    inherited;
end;

procedure TCustomDBTreeView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  KillAllTimer;
  if (FDisableCount = 0) then
  begin
    FTreeViewLink.CheckRefresh;
    if (dtvsNeedReBuild in FState) and
       (not (dtvsBuilding in FState)) and
       (not IsEditing) and (FIDOfDeleted = '') then
      BuildTree;
  end;
  inherited KeyDown(Key, Shift);
end;

procedure TCustomDBTreeView.WMTimer(var Msg: TWMTimer);
begin
  if (Msg.TimerID = TimerIDRebuild) then
  begin
        if (FDisableCount = 0) and (not (dtvsBuilding in FState)) and
           (not IsEditing) and (FIDOfDeleted = '') and
           (dtvsNeedReBuild in FState) then
        begin
          KillTimer(Handle, TimerIDRebuild);
          FReBuildTimer := 0;
          BuildTree;
        end
        else
          if not (dtvsNeedReBuild in FState) then
          begin
            KillTimer(Handle, TimerIDRebuild);
            FReBuildTimer := 0;
          end;
  end
  else
    inherited;
end;

function TCustomDBTreeView.MoveNode(Source, Destination: TTreeNode;
  Mode: TNodeAttachMode): Boolean;
var
  DestinationID: string;
begin
  if (DataSet = nil) or not DataSet.Active then
  begin
    Result := inherited MoveNode(Source, Destination, Mode);
    exit;
  end;
  Result := false;
  if (Source = nil) then
    exit;
  with DataSet do
  begin
    Inc(FDisableCount);
    try
//    DisableControls;
      if DataSetLocate(IDOfNode(Source)) then
      begin
        Edit;
        try
          Result := inherited MoveNode(Source, Destination, Mode);
          if Result then
          begin
            if (SortType = stNone) then
            begin
              if (Destination <> nil) then
                Destination.AlphaSort
              else
                AlphaSort;
              Source.MakeVisible;
            end;
            if (Source.Parent = nil) then
              DestinationID := FRootID
            else
              DestinationID := IDOfNode(Source.Parent);
            if (DestinationID <> '') then
              DataSet.FieldByName(FTableParentField).Value := DestinationID
            else
              DataSet.FieldByName(FTableParentField).Clear;
            Post;
            if Assigned(FTVRecordList) then
              FTVRecordList.ChangeParent(IDOfNode(Source), DestinationID);
            if (dtAutoShowRoot in Options) then
              if (Items.Count = 0) then
                ShowRoot := false
              else
                ShowRoot := not IsSingleRootNode(Items[0]);
          end
          else
            Cancel;
        except
          if (State = dsEdit) then
            Cancel;
          raise;
        end;
      end;
    finally
//    EnableControls;
      Dec(FDisableCount);
    end;
  end;
end;

function TCustomDBTreeView.GetExpanded(Separator: Char): string;
var
  Node: TTreeNode;
  FirstItem: Boolean;
begin
  result := '';
  FirstItem := true;
  Node := Items.GetFirstNode;
  while (Node <> nil) do
  begin
    if Node.Expanded and (Node.Count > 0) then
    begin
      if FirstItem then
      begin
        FirstItem := false;
        result := IDOfNode(Node);
      end
      else
        result := result + Separator + IDOfNode(Node);
    end;
    Node := Node.GetNext;
  end;
end;

procedure TCustomDBTreeView.SetExpanded(const List: string; Separator: Char);
var
  xList: string;
  Node: TTreeNode;
  SavedTopItem: TTreeNode;
begin
  Items.BeginUpdate; { changes are not visible until EndUpdate }
  SavedTopItem := TopItem;
  xList := Separator + List + Separator;
  Node := Items.GetFirstNode;
  while (Node <> nil) do
  begin
    Node.Expanded := (Pos(Separator + IDOfNode(Node) + Separator, xList) > 0);
    Node := Node.GetNext;
  end;
  if (SavedTopItem <> nil) then
    TopItem := SavedTopItem;
  Node := Selected;
  if (Node <> nil) then
    Node.MakeVisible;
  Items.EndUpdate;
end;

procedure TCustomDBTreeView.WMSetFocus(var Message: TMessage);
begin
{ We just received the focus. If the dateaset is in edit- or insert-mode
  and dtFocusOnEdit is in Options, we have to set the selected node into
  the edit-mode. }
  inherited;
  if (FDisableCount = 0) then
  begin
    FTreeViewLink.CheckRefresh;
    if (dtvsNeedReBuild in FState) then
      BuildTree;
    if ((dtFocusOnEdit in Options) or
        (dtvsLostFocusWhileDatasetInEditModes in FState)) and
       not IsEditing then
    begin
      Exclude(FState, dtvsLostFocusWhileDatasetInEditModes);
      if (DataSet <> nil) then
        with DataSet do
          if (State = dsEdit) or (State = dsInsert) then
          begin
            if not (dtSynchronizeDataSet in Options) then
              SynchronizeSelectedNodeToCurrentRecord;
            if (Selected <> nil) then
              Selected.EditText;
          end;
    end;
  end;
end;

procedure TCustomDBTreeView.RebuildTree;
begin
  Include(FState, dtvsNeedReBuild);
  BuildTree;
end;

function TCustomDBTreeView.FindTextID(const S: string; var ID: string;
  TVFindTextOptions: TTVFindTextOptions): Boolean;
begin
  if Assigned(FTVRecordList) then
    result := FTVRecordList.FindTextID(
      S, ID, TInternalTVFindTextOptions(TVFindTextOptions))
  else
    result := false;
end;

function TCustomDBTreeView.TextIDList(const S: string;
  TVFindTextOptions: TTVFindTextOptions): TStringList;
begin
  if Assigned(FTVRecordList) then
    result := FTVRecordList.TextIDList(
      S, TInternalTVFindTextOptions(TVFindTextOptions))
  else
    result := nil;
end;

function TCustomDBTreeView.IDOfNode(Node: TTreeNode): string;
begin
  if (Node = nil) then
    result := ''
  else
    if Node is TTreeIDNode then
      result := TTreeIDNode(Node).ID
    else
      result := '';
end;

function TCustomDBTreeView.CreateNode: TTreeNode;
begin
  Result := TTreeIDNode.Create(Items);
end;

procedure TCustomDBTreeView.DestroyWnd;
var
  Node: TTreeNode;
begin
  Node := Items.GetFirstNode;
  if (Node <> nil) then
  begin
    FSaveIDList := TStringList.Create;
    while (Node <> nil) do
    begin
      FSaveIDList.Add(IDOfNode(Node));
      Node := Node.GetNext;
    end;
  end;
  inherited DestroyWnd;
end;

procedure TCustomDBTreeView.CreateWnd;
var
  i: Integer;
  Node: TTreeNode;
begin
  inherited CreateWnd;
  if (FSaveIDList <> nil) then
  begin
    try
      if (FSaveIDList.Count = Items.Count) then
      begin
        Node := Items.GetFirstNode;
        for i := 0 to FSaveIDList.Count - 1 do
        begin
          if (FSaveIDList[i] <> '') then
            TTreeIDNode(Node).FID := FSaveIDList[i];
          Node := Node.GetNext;
        end;
      end;
    finally
      FSaveIDList.Free;
      FSaveIDList := nil;
    end;
  end;
end;





initialization
{$IFDEF Ver90}
  sdbtvDefaultDeleteQuestion := LoadStr(SDeleteRecordQuestion);
{$ELSE DEF Ver90} { Delphi >= 3.0: }
  sdbtvDefaultDeleteQuestion := 'Delete record ?';
{$ENDIF DEF Ver90}
end.
