unit dbTreeCBox;

{ TDbTreeLookupComboBox: ComboBox that shows a DBTreeView instead of a list.
  Version 0.85  May-17-1998  (C) 1997,98 Christoph R. Kirchner
}

{ Requires the TDBTreeView component, a data-aware TTreeView component
  that you can find in dbTree.PAS. If you do not have it, please look at:
  http://www.geocities.com/SiliconValley/Heights/7874/delphi.htm
}

{ Users of this unit must accept this disclaimer of  warranty:
    "This unit is supplied as is. The author disclaims all warranties,
    expressed or implied, including, without limitation, the warranties of
    merchantability and of fitness for any purpose.
    The author assumes no liability for damages, direct or consequential,
    which may result from the use of this unit."

  This Unit is donated to the public as public domain.

  This Unit can be freely used and distributed in commercial and private
  environments provided this notice is not modified in any way.

  If you do find this Unit handy and you feel guilty for using such a great
  product without paying someone - sorry :-)

  Please forward any comments or suggestions to Christoph Kirchner at:
  ckirchner@geocities.com

  Maybe you can find an update of this component at my homepage:
  http://www.geocities.com/SiliconValley/Heights/7874/delphi.htm
}

{$DEFINE RedefineTDBLookupControl} { See below about this switch...}
{ Please $DEFINE RedefineTDBLookupControl if you do not want to change the
  definition of TDBLookupControl in the unit DBCtrls.

  Otherwise you have to do the following: (Tested with Delphi 2.0 only)
  - Copy DBCtrls.PAS from Delphi\Source\VCL into Delphi\Lib
  - Replace the definition of TDBLookupControl in the unit DBCtrls with the
    definition of TCustomDBLookupControl in this unit.
    (Changes are marked with *)

  This is needed because the TDBLookupControl is useless outside DBCtrls.PAS -
  too many important functions are in the private section. This could happen
  due to a (IMHO) big mistake in Borlands definition of the Delphi-language:
  Private declarations are not private but protected inside the unit. For this,
  the Borland-programmers did not care about a useful declaration of
  TDBLookupControl - they just declared all decendants in the same unit.
}
{ Thanks to Peter M. Jagielski (73737.1761@compuserve.com) for contributing
  an idea how to get the rect a window can use without getting hidden by the
  Win95-Taskbar. (He published a procedure SizeForTaskBar in sizetask.zip). }

interface

uses SysUtils, Windows, Messages, Classes, Controls, Forms,
  Graphics, Menus, StdCtrls, ExtCtrls, DB, DBTables, Mask, Buttons,
  DBCtrls, ComCtrls, dbTree, TreeVwEx, Variants;

type

  TDbTreeLookupComboBox = class;

  TCloseUpAction = (caCancel, caAccept, caClear);
  TCloseUpEvent = procedure (Action: TCloseUpAction) of object;
  TAcceptNodeEvent = procedure (Node: TTreeNode; var Accept: Boolean) of object;

  TDBTreeLCBOption = (dtAcceptLeavesOnly, dtDontAcceptRoot,
                      dtKeepDataSetConnected);
  TDBTreeLCBOptions = set of TDBTreeLCBOption;

{ Options:

  dtAcceptLeavesOnly:
    The User can only select nodes that have no children.
    If you use the event OnAcceptNode, Accept is set to false if the
    node has children. But you can accept the node anyway by setting
    Accept to true.
  dtDontAcceptRoot:
    The User can not select the root-node.
    If you use the event OnAcceptNode, Accept is set to false if the
    node is the root-node. But you can accept the node anyway by setting
    Accept to true.
  dtKeepDataSetConnected:
    The DataSource TDbTreeLookupComboBox.ListSource or the LookupDataSet
    of TDbTreeLookupComboBox.ListField will be always connected to the
    TDBTreeView of the dropdown-panel. If you set dtKeepDataSetConnected
    to false, a complete rebuild of the tree is needed before each dropdown.
}


  TTreeSelect = class(TForm)
  private
    FCallingDbTreeLookupComboBox: TDbTreeLookupComboBox;
    FOnCloseUp: TCloseUpEvent;
    FOnAcceptNode: TAcceptNodeEvent;
    FDBTreeView: TCustomDBTreeView;
    FOldOnDBTreeViewMouseSelect: TNotifyEvent;
    FDBTreeViewSelfCreated: Boolean; { true: We will destroy it at end }
    FPosUnderComboBox: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Deactivate; override;
    procedure Loaded; override;
    procedure OnDBTreeViewMouseSelect(Sender: TObject); virtual;
    function  GetDBTreeView: TCustomDBTreeView; virtual;
    procedure SetDBTreeView(Value: TCustomDBTreeView); virtual;
    property OnAcceptNode: TAcceptNodeEvent
      read FOnAcceptNode write FOnAcceptNode;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CloseUp(Action: TCloseUpAction);
    function CanAccept(Node: TTreeNode): Boolean; virtual;
    property DBTreeView: TCustomDBTreeView read GetDBTreeView write SetDBTreeView;
    property OnCloseUp: TCloseUpEvent read FOnCloseUp write FOnCloseUp;
    property CallingDbTreeLookupComboBox: TDbTreeLookupComboBox
      read FCallingDbTreeLookupComboBox;
    property PosUnderComboBox: Boolean read FPosUnderComboBox;
  end;


{$IFDEF RedefineTDBLookupControl}
{ This part is copied from the unit DBCtrls.
  Copyright (c) 1995,96 Borland International }

  TCustomDBLookupControl = class;

  TDataSourceLink = class(TDataLink)
  private
    FDBLookupControl: TCustomDBLookupControl;
  protected
    procedure ActiveChanged; override;
    procedure RecordChanged(Field: TField); override;
  end;

  TListSourceLink = class(TDataLink)
  private
    FDBLookupControl: TCustomDBLookupControl;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
  end;

  TCustomDBLookupControl = class(TCustomControl)
  private
    FLookupSource: TDataSource;
    FDataLink: TDataSourceLink;
    FListLink: TListSourceLink;
    FDataFieldName: string;
    FKeyFieldName: string;
    FListFieldName: string;
    FListFieldIndex: Integer;
    FDataField: TField;
    FMasterField: TField;
    FKeyField: TField;
    FListField: TField;
    FListFields: TList;
    FKeyValue: Variant;
    FSearchText: string;
    FLookupMode: Boolean;
    FListActive: Boolean;
    FFocused: Boolean;
    procedure CheckNotCircular;
    procedure CheckNotLookup;
    procedure DataLinkActiveChanged;
    function GetDataSource: TDataSource;
    function GetKeyFieldName: string;
    function GetListSource: TDataSource;
    function GetReadOnly: Boolean;
    procedure SetDataFieldName(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetKeyFieldName(const Value: string);
    procedure SetKeyValue(const Value: Variant);
    procedure SetListFieldName(const Value: string);
    procedure SetListSource(Value: TDataSource);
    procedure SetLookupMode(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    procedure WMGetDlgCode(var Message: TMessage); message WM_GETDLGCODE;
    procedure WMKillFocus(var Message: TMessage); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TMessage); message WM_SETFOCUS;
  protected
  { * Moved from private to protected and made virtual: }
    procedure DataLinkRecordChanged(Field: TField);  virtual;
  { * Moved (virtual) procedures from private to protected: }
    function CanModify: Boolean;
    procedure KeyValueChanged; virtual;
    procedure ListLinkActiveChanged; virtual;
    procedure ListLinkDataChanged; virtual;
    function LocateKey: Boolean;
    procedure SelectKeyValue(const Value: Variant);
    function GetTextHeight: Integer;
    function GetBorderSize: Integer;
  { * Read private "Fxxx" with protected "FFxxx":}
    property FFLookupMode: Boolean read FLookupMode;
    property FFKeyField: TField read FKeyField;
    property FFDataField: TField read FDataField;
    property FFDataFieldName: string read FDataFieldName;
    property FFDataLink: TDataSourceLink read FDataLink;
    property FFListLink: TListSourceLink read FListLink;
    property FFListField: TField read FListField;
    property FFListActive: Boolean read FListActive;
    property FFFocused: Boolean read FFocused;
  { * Read and write private "Fxxx" with protected "FFxxx":}
    property FFSearchText: string read FSearchText write FSearchText;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    property DataField: string read FDataFieldName write SetDataFieldName;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property KeyField: string read GetKeyFieldName write SetKeyFieldName;
    property KeyValue: Variant read FKeyValue write SetKeyValue;
    property ListField: string read FListFieldName write SetListFieldName;
    property ListFieldIndex: Integer
      read FListFieldIndex write FListFieldIndex default 0;
    property ListSource: TDataSource read GetListSource write SetListSource;
    property ParentColor default False;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property TabStop default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;
{$ELSE DEF RedefineTDBLookupControl}
  TCustomDBLookupControl = class(TDBLookupControl)
  end;
{$ENDIF DEF RedefineTDBLookupControl}

{ TDbTreeLookupComboBox }

  TCreateTreeSelectEvent = function: TTreeSelect of object;
  TGetTreeSelectEvent = function: TTreeSelect of object;
  TDropDownAlign = (daLeft, daRight, daCenter);

  TDbTreeLookupComboBox = class(TCustomDBLookupControl)
  private
    FButtonWidth: Integer;
    FText: string;
    FDropDownWidth: Integer;
    FDropDownAlign: TDropDownAlign;
    FDropDownHeight: Integer;
    FListVisible: Boolean;
    FPressed: Boolean;
    FTracking: Boolean;
    FAlignment: TAlignment;
    FOnDropDown: TNotifyEvent;
    FOnCloseUp: TCloseUpEvent;
    FNoMouseDropDown: Boolean;
    FOptions: TDBTreeLCBOptions;
    procedure ListLinkActiveChanged; override;
    procedure StopTracking;
    procedure TrackButton(X, Y: Integer);
    procedure ProcessSearchKey(Key: Char);
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  private { TreeView }
    FTreeSelect: TTreeSelect;
    FTreeSelectSelfCreated: Boolean;
    FListTreeIDField: string;
    FListTreeParentField: string;
    FListTreeRootID: string;
    FOnAcceptNode: TAcceptNodeEvent;
    FOnCreateTreeSelect: TCreateTreeSelectEvent;
    FTreeSelectOnDestroy: TNotifyEvent;
    procedure AcceptNode(Node: TTreeNode; var Accept: Boolean);
    procedure SetTreeSelect(Value: TTreeSelect);
    function GetTreeSelect: TTreeSelect;
    procedure SetListTreeIDField(const Value: String);
    procedure SetListTreeParentField(const Value: String);
    procedure TreeSelectFormDestroy(Sender: TObject);
    function GetTvDataset: TDataset;
    function GetDBTreeView: TCustomDBTreeView;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure DataLinkRecordChanged(Field: TField);
      {$IFDEF RedefineTDBLookupControl} override; {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CloseUp(Action: TCloseUpAction);
    procedure DropDown;
    procedure KeyValueChanged; override;
    property KeyValue;
    property ListVisible: Boolean read FListVisible;
    property Text: string read FText;
  { TreeView }
  { You can use PrepareDropdown to build the tree of the dropdown-panel
    before first dropdown happens (datasets have to be open already) -
    the first dropdown will get faster then: }
    procedure PrepareDropdown;
  { The dataset of the DBTreeView of the dropdown-panel: }
    property DBTreeViewDataset: TDataset read GetTvDataset;
  { The dropdown-panel itself: }
    property TreeSelect: TTreeSelect read GetTreeSelect write SetTreeSelect;
  { The DBTreeView of the dropdown-panel: }
    property DBTreeView: TCustomDBTreeView read GetDBTreeView;
  published
    property Color;
    property Ctl3D;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragMode;
    property DropDownAlign: TDropDownAlign
      read FDropDownAlign write FDropDownAlign default daLeft;
    property DropDownWidth: Integer
      read FDropDownWidth write FDropDownWidth default 0;
    property DropDownHeight: Integer
      read FDropDownHeight write FDropDownHeight default 0;
    property Enabled;
    property Font;
    property KeyField;
    property ListField;
{   property ListFieldIndex; }
    property ListSource;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnCloseUp: TCloseUpEvent read FOnCloseUp write FOnCloseUp;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  published { TreeView }
    property ListTreeIDField: string
      read FListTreeIDField write SetListTreeIDField;
    property ListTreeParentField: string
      read FListTreeParentField write SetListTreeParentField;
    property ListTreeRootID: string
      read FListTreeRootID write FListTreeRootID;
    property OnAcceptNode: TAcceptNodeEvent
      read FOnAcceptNode write FOnAcceptNode;
    property OnCreateTreeSelect: TCreateTreeSelectEvent
      read FOnCreateTreeSelect write FOnCreateTreeSelect;
    property Options: TDBTreeLCBOptions read FOptions write FOptions
      default [dtKeepDataSetConnected];
  end;



implementation

{$IFDEF RedefineTDBLookupControl}
uses DBConsts;


{ TDataSourceLink }

procedure TDataSourceLink.ActiveChanged;
begin
  if FDBLookupControl <> nil then FDBLookupControl.DataLinkActiveChanged;
end;

procedure TDataSourceLink.RecordChanged(Field: TField);
begin
  if FDBLookupControl <> nil then FDBLookupControl.DataLinkRecordChanged(Field);
end;

{ TListSourceLink }

procedure TListSourceLink.ActiveChanged;
begin
  if FDBLookupControl <> nil then FDBLookupControl.ListLinkActiveChanged;
end;

procedure TListSourceLink.DataSetChanged;
begin
  if FDBLookupControl <> nil then FDBLookupControl.ListLinkDataChanged;
end;

{ TCustomDBLookupControl }

function VarEquals(const V1, V2: Variant): Boolean;
begin
  Result := False;
  try
    Result := V1 = V2;
  except
  end;
end;

var
  SearchTickCount: Integer = 0;

constructor TCustomDBLookupControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if NewStyleControls then
    ControlStyle := [csOpaque] else
    ControlStyle := [csOpaque, csFramed];
  ParentColor := False;
  TabStop := True;
  FLookupSource := TDataSource.Create(Self);
  FDataLink := TDataSourceLink.Create;
  FDataLink.FDBLookupControl := Self;
  FListLink := TListSourceLink.Create;
  FListLink.FDBLookupControl := Self;
  FListFields := TList.Create;
  FKeyValue := Null;
end;

destructor TCustomDBLookupControl.Destroy;
begin
  FDataLink.FDBLookupControl := nil;
  FDataLink.Free;
  FListFields.Free;
  FListLink.FDBLookupControl := nil;
  FListLink.Free;
  inherited Destroy;
end;

function TCustomDBLookupControl.CanModify: Boolean;
begin
  Result := FListActive and not ReadOnly and ((FDataLink.DataSource = nil) or
    (FMasterField <> nil) and FMasterField.CanModify);
end;

procedure TCustomDBLookupControl.CheckNotCircular;
begin
  if FDataLink.Active and FDataLink.DataSet.IsLinkedTo(ListSource) then
{$IFDEF Ver90}
    DataBaseError(LoadStr(SCircularDataLink));
{$ELSE DEF Ver90} { Delphi >= 3.0: }
    DataBaseError(SCircularDataLink);
{$ENDIF DEF Ver90}
end;

procedure TCustomDBLookupControl.CheckNotLookup;
begin
  if FLookupMode then
{$IFDEF Ver90}
    DataBaseError(LoadStr(SPropDefByLookup));
{$ELSE DEF Ver90} { Delphi >= 3.0: }
    DataBaseError('SPropDefByLookup');
{$ENDIF DEF Ver90}
  if FDataLink.DataSourceFixed then
{$IFDEF Ver90}
    DataBaseError(LoadStr(SDataSourceFixed));
{$ELSE DEF Ver90} { Delphi >= 3.0: }
    DataBaseError('SDataSourceFixed');
{$ENDIF DEF Ver90}
end;

procedure TCustomDBLookupControl.DataLinkActiveChanged;
begin
  FDataField := nil;
  FMasterField := nil;
  if Assigned(FDataLink) and FDataLink.Active and (FDataFieldName <> '') then
  begin
    CheckNotCircular;
    FDataField := FDataLink.DataSet.FieldByName(FDataFieldName);
    FMasterField := FDataField;
  end;
  SetLookupMode((FDataField <> nil) and FDataField.Lookup);
  DataLinkRecordChanged(nil);
end;

procedure TCustomDBLookupControl.DataLinkRecordChanged(Field: TField);
begin
  if (Field = nil) or (Field = FMasterField) then
    if FMasterField <> nil then
      SetKeyValue(FMasterField.Value) else
      SetKeyValue(Null);
end;

function TCustomDBLookupControl.GetBorderSize: Integer;
var
  Params: TCreateParams;
  R: TRect;
begin
  CreateParams(Params);
  SetRect(R, 0, 0, 0, 0);
  AdjustWindowRectEx(R, Params.Style, False, Params.ExStyle);
  Result := R.Bottom - R.Top;
end;

function TCustomDBLookupControl.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TCustomDBLookupControl.GetKeyFieldName: string;
begin
  if FLookupMode then Result := '' else Result := FKeyFieldName;
end;

function TCustomDBLookupControl.GetListSource: TDataSource;
begin
  if FLookupMode then
    Result := nil
  else
    Result := FListLink.DataSource;
end;

function TCustomDBLookupControl.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

function TCustomDBLookupControl.GetTextHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  Result := Metrics.tmHeight;
end;

procedure TCustomDBLookupControl.KeyValueChanged;
begin
end;

procedure TCustomDBLookupControl.ListLinkActiveChanged;
var
  DataSet: TDataSet;
  ResultField: TField;
begin
  FListActive := False;
  FKeyField := nil;
  FListField := nil;
  FListFields.Clear;
  if FListLink.Active and (FKeyFieldName <> '') then
  begin
    CheckNotCircular;
    DataSet := FListLink.DataSet;
    FKeyField := DataSet.FieldByName(FKeyFieldName);
    DataSet.GetFieldList(FListFields, FListFieldName);
    if FLookupMode then
    begin
      ResultField := DataSet.FieldByName(FDataField.LookupResultField);
      if FListFields.IndexOf(ResultField) < 0 then
        FListFields.Insert(0, ResultField);
      FListField := ResultField;
    end else
    begin
      if FListFields.Count = 0 then FListFields.Add(FKeyField);
      if (FListFieldIndex >= 0) and (FListFieldIndex < FListFields.Count) then
        FListField := FListFields[FListFieldIndex] else
        FListField := FListFields[0];
    end;
    FListActive := True;
  end;
end;

procedure TCustomDBLookupControl.ListLinkDataChanged;
begin
end;

function TCustomDBLookupControl.LocateKey: Boolean;
begin
  Result := False;
  try
    if (not VarIsNull(FKeyValue)) and
       FListLink.Active and
       FListLink.DataSet.Locate(FKeyFieldName, FKeyValue, []) then
      Result := True;
  except
  end;
end;

procedure TCustomDBLookupControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FDataLink <> nil) and (AComponent = DataSource) then DataSource := nil;
    if (FListLink <> nil) and (AComponent = ListSource) then ListSource := nil;
  end;
end;

procedure TCustomDBLookupControl.SelectKeyValue(const Value: Variant);
begin
  if (FMasterField <> nil) then
  begin
    if VarIsEmpty(Value) then
    begin
      if not FMasterField.IsNull then
      begin
        if not (FMasterField.Dataset.State in [dsEdit, dsInsert]) then
          FMasterField.DataSet.Edit;
        FMasterField.Clear;
      end;
    end
    else
    begin
      if (FMasterField.Value <> Value) then
      begin
        if not (FMasterField.Dataset.State in [dsEdit, dsInsert]) then
          FMasterField.DataSet.Edit;
        FMasterField.Value := Value;
      end;
    end;
  end
  else
    SetKeyValue(Value);
  Repaint;
  Click;
end;

procedure TCustomDBLookupControl.SetDataFieldName(const Value: string);
begin
  if FDataFieldName <> Value then
  begin
    FDataFieldName := Value;
    DataLinkActiveChanged;
  end;
end;

procedure TCustomDBLookupControl.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TCustomDBLookupControl.SetKeyFieldName(const Value: string);
begin
  CheckNotLookup;
  if FKeyFieldName <> Value then
  begin
    FKeyFieldName := Value;
    ListLinkActiveChanged;
  end;
end;

procedure TCustomDBLookupControl.SetKeyValue(const Value: Variant);
begin
  if not VarEquals(FKeyValue, Value) then
  begin
    FKeyValue := Value;
    KeyValueChanged;
  end;
end;

procedure TCustomDBLookupControl.SetListFieldName(const Value: string);
begin
  if FListFieldName <> Value then
  begin
    FListFieldName := Value;
    ListLinkActiveChanged;
  end;
end;

procedure TCustomDBLookupControl.SetListSource(Value: TDataSource);
begin
  CheckNotLookup;
  FListLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TCustomDBLookupControl.SetLookupMode(Value: Boolean);
begin
  if FLookupMode <> Value then
    if Value then
    begin
      FMasterField := FDataField.DataSet.FieldByName(FDataField.KeyFields);
      FLookupSource.DataSet := FDataField.LookupDataSet;
      FKeyFieldName := FDataField.LookupKeyFields;
      FLookupMode := True;
      FListLink.DataSource := FLookupSource;
    end else
    begin
      try
        FListLink.DataSource := nil;
      except end;
        FLookupMode := False;
        FKeyFieldName := '';
      try
        FLookupSource.DataSet := nil;
      except end;
      try
        FMasterField := FDataField;
      except end;
    end;
end;

procedure TCustomDBLookupControl.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TCustomDBLookupControl.WMGetDlgCode(var Message: TMessage);
begin
  Message.Result := DLGC_WANTARROWS or DLGC_WANTCHARS;
end;

procedure TCustomDBLookupControl.WMKillFocus(var Message: TMessage);
begin
  FFocused := False;
  Invalidate;
end;

procedure TCustomDBLookupControl.WMSetFocus(var Message: TMessage);
begin
  FFocused := True;
  Invalidate;
end;

{$ENDIF DEF RedefineTDBLookupControl}





{ TDbTreeLookupComboBox ----------------------------------------------------- }

constructor TDbTreeLookupComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 145;
  Height := 0;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  FOnAcceptNode := nil;
  FOnCreateTreeSelect := nil;
  FTreeSelect := nil;
  FTreeSelectSelfCreated := false;
  FOptions := [dtKeepDataSetConnected];
  FListTreeRootID := '';
end;

destructor TDbTreeLookupComboBox.Destroy;
begin
  inherited Destroy;
end;

procedure TDbTreeLookupComboBox.CloseUp(Action: TCloseUpAction);
var
  ListValue: Variant;
begin
  if FListVisible then
  begin
    if GetCapture <> 0 then
      SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    try
      if (Action = caAccept) then
        ListValue := FFListLink.DataSet.FieldByName(FFKeyField.FieldName).Value
      else
        ListValue := Unassigned;
    except
      ListValue := Unassigned;
    end;
{   ListValue := FDataList.KeyValue; }
    FListVisible := False;
    FTreeSelect.Hide;
    SetWindowPos(FTreeSelect.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
    if not (dtKeepDataSetConnected in Options) then
      FTreeSelect.DBTreeView.DataSource := nil;
    FFSearchText := '';
    FListVisible := True; { CanModify cannot get true if FListVisible = False }
    if (Action <> caCancel) and CanModify then
      SelectKeyValue(ListValue);
    FListVisible := False;
    if Assigned(FOnCloseUp) then
      FOnCloseUp(Action);
    FNoMouseDropDown := true;
    Invalidate;
  end;
end;

procedure TDbTreeLookupComboBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    if NewStyleControls and Ctl3D then
      ExStyle := ExStyle or WS_EX_CLIENTEDGE
    else
      Style := Style or WS_BORDER;
  end;
end;

function GetScreenRect: TRect;
{ Get the rect a window can use without getting hidden by the Win95-Taskbar.
  Thanks to Peter M. Jagielski (73737.1761@compuserve.com) for contributing
  an idea how to do this (procedure SizeForTaskBar in sizetask.zip). }
var
  TaskBarHandle: HWnd;   { Handle to the Win95 Taskbar }
  TaskBarCoord: TRect;   { Coordinates of the Win95 Taskbar }
  CxScreen: Integer;     { Width of screen in pixels }
  CyScreen: Integer;     { Height of screen in pixels }
  CxFullScreen: Integer; { Width of client area in pixels }
  CyFullScreen: Integer; { Heigth of client area in pixels }
  CyCaption: Integer;    { Height of a window's title bar in pixels }
begin
  result.Left := 0;
  result.Top := 0;
{ Get Win95 Taskbar handle: }
  TaskBarHandle := FindWindow('Shell_TrayWnd', nil);
  if (TaskBarHandle = 0) then
  begin
  { We're running WinNT w/o Win95 shell, so use TScreen-values: }
    result.Right := Screen.Width - 1;
    result.Bottom := Screen.Height - 1;
  end
  else { We're running Win95 or WinNT w/Win95 shell: }
  begin
  { Get coordinates of Win95 Taskbar: }
    GetWindowRect(TaskBarHandle, TaskBarCoord);
  { Get various screen dimensions: }
    CxScreen := GetSystemMetrics(SM_CXSCREEN);
    CyScreen := GetSystemMetrics(SM_CYSCREEN);
    CxFullScreen := GetSystemMetrics(SM_CXFULLSCREEN);
    CyFullScreen := GetSystemMetrics(SM_CYFULLSCREEN);
    CyCaption     := GetSystemMetrics(SM_CYCAPTION);
    result.Right  := CxScreen - (CxScreen - CxFullScreen) - 1;
    result.Bottom := CyScreen - (CyScreen - CyFullScreen) + CyCaption - 1;
  { look if Taskbar is on either top or left: }
    if (TaskBarCoord.Top = -2) and (TaskBarCoord.Left = -2) then
      if TaskBarCoord.Right > TaskBarCoord.Bottom then
      { Taskbar on top }
        result.Top  := TaskBarCoord.Bottom
      else
      { Taskbar on left }
        result.Left := TaskBarCoord.Right;
  end;
end;

procedure TDbTreeLookupComboBox.DropDown;
var
  ComboBoxOrigin: TPoint;
  X: Integer;
  Y: Integer;
  ScreenRect: TRect;
{ I: Integer; S: string; }
begin
  if not FListVisible and FFListActive then
  begin
    if Assigned(FOnDropDown) then FOnDropDown(Self);
    if FDropDownWidth > 0 then
      TreeSelect.Width := FDropDownWidth
    else
      TreeSelect.Width := Width;
    if FDropDownHeight > 0 then
      FTreeSelect.Height := FDropDownHeight;
{
    FTreeSelect.ReadOnly := not CanModify;
    FTreeSelect.KeyField := FKeyFieldName;
    for I := 0 to FListFields.Count - 1 do
      S := S + TField(FListFields[I]).FieldName + ';';
    FTreeSelect.ListField := S;
    FTreeSelect.ListFieldIndex := FListFields.IndexOf(FListField);
    FTreeSelect.ListSource := FListLink.DataSource;
    FTreeSelect.KeyValue := KeyValue;
}
    ScreenRect.TopLeft := ScreenToClient(GetScreenRect.TopLeft);
    ScreenRect.BottomRight := ScreenToClient(GetScreenRect.BottomRight);
    ScreenRect := GetScreenRect;
    ComboBoxOrigin := Parent.ClientToScreen(Point(Left, Top));
    Y := ComboBoxOrigin.Y + Height;
    if Y + FTreeSelect.Height > ScreenRect.Bottom then
    begin
      Y := ComboBoxOrigin.Y - FTreeSelect.Height;
      FTreeSelect.FPosUnderComboBox := false;
    end
    else
      FTreeSelect.FPosUnderComboBox := true;
    case FDropDownAlign of
      daRight: X := ComboBoxOrigin.X - (FTreeSelect.Width - Width);
      daCenter: X := ComboBoxOrigin.X - ((FTreeSelect.Width - Width) div 2);
      else X := ComboBoxOrigin.X;
    end;
    if ((X + FTreeSelect.Width) > ScreenRect.Right) then
      X := ScreenRect.Right - (FTreeSelect.Width - 1);
    if (X < ScreenRect.Left) then
      X := ScreenRect.Left;
    FTreeSelect.DBTreeView.Color := Color;
    FTreeSelect.DBTreeView.Font := Font;
    FTreeSelect.DBTreeView.TableTextField := FFListField.Fieldname;
  { Now, if not done already, we connect the Datasource. We will disconnect
    it at CloseUp if not dtKeepDataSetConnected in Options: }
    if (FTreeSelect.DBTreeView.DataSource = nil) then
      FTreeSelect.DBTreeView.DataSource := FFListLink.DataSource;
    LocateKey; { TTable(ListSource.DataSet).FindKey([KeyValue]); }
    with FTreeSelect.DBTreeView do
    begin
      If (Items.GetFirstNode <> nil) then
      begin
        Items.GetFirstNode.MakeVisible; { begin at top of list }
{       Selected := Items.GetFirstNode; }
      end;
      SynchronizeSelectedNodeToCurrentRecord;
    end;
    FTreeSelect.Resize;
  { Show window: }
    SetWindowPos(FTreeSelect.Handle, HWND_TOP, X, Y, 0, 0,
      SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
    FTreeSelect.Show;
    FListVisible := True;
    Repaint;
  end;
end;

procedure TDbTreeLookupComboBox.ProcessSearchKey(Key: Char);
var
  aDBTreeView: TCustomDBTreeView;
  i: Integer;
  TickCount: Integer;
  S: string;
  Accept: Boolean;
  IDList: TStringList;
begin
  case Key of
    #8, #27: FFSearchText := '';
    #32..#255:
      if CanModify and FListLink.Active then
      begin
        TickCount := GetTickCount;
        if ((TickCount - SearchTickCount) > 2000) then
          FFSearchText := '';
        SearchTickCount := TickCount;
        if (Length(FFSearchText) < 32) then
        begin
          S := FFSearchText + Key;
          aDBTreeView := DBTreeView;
          if Assigned(aDBTreeView) then
          begin
            if (aDBTreeView.DataSource = nil) then
              aDBTreeView.DataSource := FFListLink.DataSource;
            IDList := aDBTreeView.TextIDList(AnsiUpperCase(S),
              [tvftCaseInsensitive, tvftPartial]);
            if (IDList <> nil) then
            try
              for i := 0 to IDList.Count - 1 do
              begin
                Accept := true;
                AcceptNode(aDBTreeView.GetIDNode(IDList[i]), Accept);
                if Accept then
                begin
                  SelectKeyValue(IDList[i]);
                  FFSearchText := S;
                  break;
                end;
              end;
            finally
              IDList.Free;
            end;
          end;
        end;
      end;
  end;
end;

procedure TDbTreeLookupComboBox.KeyDown(var Key: Word; Shift: TShiftState);
var
  aDBTreeView: TCustomDBTreeView;
  Node: TTreeNode;
  Accept: Boolean;
begin
  inherited KeyDown(Key, Shift);
  if FFListActive and ((Key = VK_UP) or (Key = VK_DOWN)) then
    if ssAlt in Shift then
    begin
      if FListVisible then
        CloseUp(caAccept)
      else
        DropDown;
      Key := 0;
    end
    else
    begin
      if (not FListVisible) then
      begin
        aDBTreeView := DBTreeView;
        if Assigned(aDBTreeView) then
        begin
          if (aDBTreeView.DataSource = nil) then
            aDBTreeView.DataSource := FFListLink.DataSource;
          if VarIsEmpty(KeyValue) or VarIsNull(KeyValue) then
          begin
          { There is no entry in KeyValue.
            Search first item that we can accept: }
            Node := aDBTreeView.TopItem;
            if (Node <> nil) then
            begin
              while (Node <> nil) do
              begin
                Accept := true;
                AcceptNode(Node, Accept);
                if Accept then
                  break;
                Node := Node.GetNext;
              end;
              if (Node <> nil) then
                SelectKeyValue(aDBTreeView.IDOfNode(Node));
            end;
          end
          else
          begin
            Node := aDBTreeView.GetIDNode(KeyValue);
            if (Node <> nil) then
            begin
              repeat
                if (Key = VK_UP) then
                  Node := Node.GetPrev
                else
                  Node := Node.GetNext;
                if (Node <> nil) then
                begin
                  Accept := true;
                  AcceptNode(Node, Accept);
                end;
              until (Node = nil) or Accept;
              if Accept then
                SelectKeyValue(aDBTreeView.IDOfNode(Node));
            end;
          end;
          Key := 0;
        end;
      end;
    end;
end;

procedure TDbTreeLookupComboBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  ProcessSearchKey(Key);
end;

procedure TDbTreeLookupComboBox.KeyValueChanged;
begin
  if FFLookupMode and Assigned(FFDataField) then
  begin
    FText := FFDataField.DisplayText;
    FAlignment := FFDataField.Alignment;
  end else
  if FFListActive and LocateKey then
  begin
    FText := FFListField.DisplayText;
    FAlignment := FFListField.Alignment;
  end else
  begin
    FText := '';
    FAlignment := taLeftJustify;
  end;
  Invalidate;
end;

procedure TDbTreeLookupComboBox.ListLinkActiveChanged;
begin
  inherited;
  KeyValueChanged;
  if Assigned(FTreeSelect) then
    try
      TreeSelect.DBTreeView.DataSource := FFListLink.DataSource;
    except end;
end;

procedure TDbTreeLookupComboBox.SetListTreeIDField(const Value: String);
begin
  FListTreeIDField := Value;
  if Assigned(FTreeSelect) then
    try
      TreeSelect.DBTreeView.TableIDField := Value;
    except end;
end;

procedure TDbTreeLookupComboBox.SetListTreeParentField(const Value: String);
begin
  FListTreeParentField := Value;
  if Assigned(FTreeSelect) then
    try
      TreeSelect.DBTreeView.TableParentField := Value;
    except end;
end;

procedure TDbTreeLookupComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    SetFocus;
    if not FFFocused then Exit;
    if FListVisible then CloseUp(caCancel) else
      if FFListActive and not FNoMouseDropDown then
      begin
        MouseCapture := True;
        FTracking := True;
        TrackButton(X, Y);
        DropDown;
      end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TDbTreeLookupComboBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ListPos: TPoint;
  MousePos: TSmallPoint;
  ADBTreeView: TCustomDBTreeView;
begin
  FNoMouseDropDown := false;
  if FTracking then
  begin
    TrackButton(X, Y);
    if FListVisible then
    begin
      ADBTreeView := DBTreeView;
      if Assigned(ADBTreeView) then
      begin
        ListPos := ADBTreeView.ScreenToClient(ClientToScreen(Point(X, Y)));
        if PtInRect(ADBTreeView.ClientRect, ListPos) then
        begin
          StopTracking;
          MousePos := PointToSmallPoint(ListPos);
          SendMessage(ADBTreeView.Handle, WM_LBUTTONDOWN, 0, Integer(MousePos));
          Exit;
        end;
      end;
    end;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TDbTreeLookupComboBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FNoMouseDropDown := false;
  StopTracking;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TDbTreeLookupComboBox.Paint;
var
  W, X, Flags: Integer;
  Text: string;
  Alignment: TAlignment;
  Selected: Boolean;
  R: TRect;
begin
  Canvas.Font := Font;
  Canvas.Brush.Color := Color;
  Selected := FFFocused and not FListVisible and
    not (csPaintCopy in ControlState);
  if Selected then
  begin
    Canvas.Font.Color := clHighlightText;
    Canvas.Brush.Color := clHighlight;
  end;
  if (csPaintCopy in ControlState) and (FFDataField <> nil) then
  begin
    Text := FFDataField.DisplayText;
    Alignment := FFDataField.Alignment;
  end else
  begin
    Text := FText;
    Alignment := FAlignment;
  end;
  W := ClientWidth - FButtonWidth;
  X := 2;
  case Alignment of
    taRightJustify: X := W - Canvas.TextWidth(Text) - 3;
    taCenter: X := (W - Canvas.TextWidth(Text)) div 2;
  end;
  SetRect(R, 1, 1, W - 1, ClientHeight - 1);
  Canvas.TextRect(R, X, 2, Text);
  if Selected then Canvas.DrawFocusRect(R);
  SetRect(R, W, 0, ClientWidth, ClientHeight);
  if not FFListActive then
    Flags := DFCS_SCROLLCOMBOBOX or DFCS_INACTIVE
  else if FPressed then
    Flags := DFCS_SCROLLCOMBOBOX or DFCS_FLAT or DFCS_PUSHED
  else
    Flags := DFCS_SCROLLCOMBOBOX;
  DrawFrameControl(Canvas.Handle, R, DFC_SCROLL, Flags);
end;

procedure TDbTreeLookupComboBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, GetTextHeight + GetBorderSize + 4);
end;

procedure TDbTreeLookupComboBox.StopTracking;
begin
  if FTracking then
  begin
    TrackButton(-1, -1);
    FTracking := False;
    MouseCapture := False;
  end;
end;

procedure TDbTreeLookupComboBox.TrackButton(X, Y: Integer);
var
  NewState: Boolean;
begin
  NewState := PtInRect(Rect(ClientWidth - FButtonWidth, 0, ClientWidth,
    ClientHeight), Point(X, Y));
  if FPressed <> NewState then
  begin
    FPressed := NewState;
    Repaint;
  end;
end;

procedure TDbTreeLookupComboBox.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> FTreeSelect) then
    CloseUp(caCancel);
end;

procedure TDbTreeLookupComboBox.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls then
  begin
    RecreateWnd;
    Height := 0;
  end;
  inherited;
end;

procedure TDbTreeLookupComboBox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Height := 0;
end;

procedure TDbTreeLookupComboBox.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := 0; {Integer(FDataLink); }
end;

procedure TDbTreeLookupComboBox.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure TDbTreeLookupComboBox.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  CloseUp(caCancel);
end;

function TDbTreeLookupComboBox.GetTvDataset: TDataset;
var
  FDataField: TField;
begin
  if (FFListLink.DataSet = nil) then
  begin
    FDataField := FFDataLink.DataSet.FieldByName(FFDataFieldName);
    if (FDataField <> nil) and (FDataField.LookupDataSet <> nil) then
    begin
      Result := FDataField.LookupDataSet;
    end
    else
    begin
{     Result := nil; }
      raise Exception.Create('ListSource is not set.');
    end;
  end
  else
    Result := FFListLink.DataSet;
end;

function TDbTreeLookupComboBox.GetDBTreeView: TCustomDBTreeView;
var
  aTreeSelect: TTreeSelect;
begin
  aTreeSelect := TreeSelect;
  if Assigned(aTreeSelect) then
    result := aTreeSelect.DBTreeView
  else
    result := nil;
end;

procedure TDbTreeLookupComboBox.TreeSelectFormDestroy(Sender: TObject);
begin
  FTreeSelect := nil;
  if Assigned(FTreeSelectOnDestroy) then FTreeSelectOnDestroy(Sender);
end;

procedure TDbTreeLookupComboBox.SetTreeSelect(Value: TTreeSelect);
begin
  if (Value <> FTreeSelect) then
  begin
    if FTreeSelectSelfCreated and Assigned(FTreeSelect) then
    begin
      FTreeSelectSelfCreated := false;
      FTreeSelect.Free;
    end;
    if Assigned(Value) then
    begin
      FTreeSelect := Value;
      FTreeSelectOnDestroy := FTreeSelect.OnDestroy;
      FTreeSelect.OnDestroy := TreeSelectFormDestroy;
      FTreeSelect.OnCloseUp := CloseUp;
      FTreeSelect.OnAcceptNode := AcceptNode;
      FTreeSelect.FCallingDbTreeLookupComboBox := self;
      with FTreeSelect.DBTreeView do
      begin
        TableIDField := ListTreeIDField;
        TableParentField := ListTreeParentField;
        RootID := ListTreeRootID;
        if Assigned(FFListField) then
          TableTextField := FFListField.Fieldname;
        if (dtKeepDataSetConnected in self.Options) and
           Assigned(FFListLink) and (FFListLink.DataSource <> nil) then
        begin
          if (FFListLink.DataSource.Dataset <> nil) then
            FFListLink.DataSource.Dataset.First;
          DataSource := FFListLink.DataSource;
        end;
      end;
    end
    else
    begin
      FTreeSelect := nil;
    end;
  end;
end;

function TDbTreeLookupComboBox.GetTreeSelect: TTreeSelect;
begin
  if not Assigned(FTreeSelect) then
  begin
    if Assigned(FOnCreateTreeSelect) then
      TreeSelect := FOnCreateTreeSelect;
    if not Assigned(FTreeSelect) then
    begin
      TreeSelect := TTreeSelect.Create(Self);
      FTreeSelectSelfCreated := true;
    end
    else
      FTreeSelectSelfCreated := false;
  end;
  result := FTreeSelect;
end;

procedure TDbTreeLookupComboBox.DataLinkRecordChanged(Field: TField);
begin
  inherited;
  if (Field = nil) or (Field = FFDataField) then
    if FFDataField <> nil then
      KeyValueChanged;
end;

procedure TDbTreeLookupComboBox.PrepareDropdown;
begin
  GetTreeSelect;
end;

procedure TDbTreeLookupComboBox.AcceptNode(
  Node: TTreeNode; var Accept: Boolean);
begin
  if Accept and (Node <> nil) then
  begin
    if (dtAcceptLeavesOnly in Options) and Node.HasChildren then
      Accept := false; { The User can only select nodes that have no children }
    if (dtDontAcceptRoot in Options) and (Node.Parent = nil) then
      Accept := false; { The User can not select the root-node }
  end;
  if Assigned(FOnAcceptNode) then FOnAcceptNode(Node, Accept);
end;

procedure TDbTreeLookupComboBox.WMPaint(var Message: TWMPaint);
begin
  inherited;
end;




{ TTreeSelect ---------------------------------------------------------------- }

constructor TTreeSelect.Create(AOwner: TComponent);
begin
  if (ClassType = TTreeSelect) then
  begin
  (* PCL *)
    inherited CreateNew(AOwner);
    Left := 0;
    Top := 0;
    ClientHeight := 166;
    ClientWidth := 212;
    Font.Color := clWindowText;
    Font.Height := -11;
    Font.Name := 'MS Sans Serif';
    Font.Style := [];
    Position := poDefault;
    PixelsPerInch := 96;
  (* PCL *)
  end
  else
    inherited Create(AOwner); { load descendants with *.dfm }
  BorderIcons := [];
  BorderStyle := bsNone;
  Visible := False;
  AutoScroll := false;
  KeyPreview := True;
  FOnCloseUp := nil;
  FDBTreeView := nil;
  FOnAcceptNode := nil;
  FOldOnDBTreeViewMouseSelect := nil;
  FDBTreeViewSelfCreated := false;
end;

destructor TTreeSelect.Destroy;
begin
  inherited Destroy;
end;

procedure TTreeSelect.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP or WS_BORDER;
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TTreeSelect.Loaded;
begin
  inherited Loaded;
  KeyPreview := True;
end;

procedure TTreeSelect.Deactivate;
begin
  CloseUp(caCancel);
end;

procedure TTreeSelect.CloseUp(Action: TCloseUpAction);
begin
  FDBTreeView.SynchronizeCurrentRecordToSelectedNode;
  if (Action = caCancel) or
     ((Action = caAccept) and CanAccept(DBTreeView.Selected)) or
     ((Action = caClear) and CanAccept(nil)) then
  begin
    if Assigned(FOnCloseUp) then FOnCloseUp(Action);
  end
{ else
    MessageBeep(MB_ICONEXCLAMATION); {}
end;

procedure TTreeSelect.SetDBTreeView(Value: TCustomDBTreeView);
var
  FIgnoreWMChars: TIgnoreWMChars;
begin
  if (Value <> FDBTreeView) then
  begin
    if FDBTreeViewSelfCreated and Assigned(FDBTreeView) then
    begin
      FDBTreeViewSelfCreated := false;
      FDBTreeView.Free;
    end;
    if Assigned(Value) then
    begin
      FDBTreeView := Value;
      with FDBTreeView do
      begin
        FOldOnDBTreeViewMouseSelect := OnMouseSelect;
        OnMouseSelect := OnDBTreeViewMouseSelect;
      { Avoid beep at CloseUp with enter-key pressed: }
        FIgnoreWMChars := IgnoreWMChars;
        Include(FIgnoreWMChars, #13);
        Include(FIgnoreWMChars, #27);
        IgnoreWMChars := FIgnoreWMChars;
      end;
    end
    else
    begin
      FDBTreeView := nil;
      FOldOnDBTreeViewMouseSelect := nil;
    end;
  end;
end;

function TTreeSelect.GetDBTreeView: TCustomDBTreeView;
var
  i: Integer;
begin
  if not Assigned(FDBTreeView) then
  begin
    for I := 0 to ComponentCount -1 do
    { Look for a DBTreeView inserted as component already: }
      if Components[I] is TCustomDBTreeView then
      begin
        DBTreeView := TCustomDBTreeView(Components[I]);
        break;
      end;
    if not Assigned(FDBTreeView) then
    begin
    { No DBTreeView found, create one: }
      DBTreeView := TCustomDBTreeView.Create(self);
      FDBTreeView.Parent := self;
      with FDBTreeView do
      begin
        Options := [dtAutoExpand, dtAutoShowRoot,
                    dtMouseMoveSelect, dtRebuildFocusedOnly];
        ReadOnly := true;
      { SortType := stNone; recommended, but default }
        Align := alClient;
        Ctl3D := false;
        ParentCtl3D := false;
        BorderStyle := bsNone;
      end;
      FDBTreeViewSelfCreated := true;
    end;
  end;
  result := FDBTreeView;
end;

procedure TTreeSelect.OnDBTreeViewMouseSelect(Sender: TObject);
begin
  if Assigned(FOldOnDBTreeViewMouseSelect) then
    FOldOnDBTreeViewMouseSelect(Sender);
  if Assigned(FOnAcceptNode) then
  begin
    CloseUp(caAccept);
  end;
end;

procedure TTreeSelect.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key = 13) then
  begin
    CloseUp(caAccept);
    Key := 0;
  end
  else
    if (Key = 27) then
    begin
      CloseUp(caCancel);
      Key := 0;
    end
    else
      if (ssAlt in Shift) and ((Key = VK_UP) or (Key = VK_DOWN)) then
      begin
        CloseUp(caAccept);
        Key := 0;
      end;
end;

function TTreeSelect.CanAccept(Node: TTreeNode): Boolean;
var
  Accept: Boolean;
begin
  Accept := true;
  if Assigned(FOnAcceptNode) then
  begin
    FOnAcceptNode(Node, Accept);
  end;
  result := Accept;
end;


end.
