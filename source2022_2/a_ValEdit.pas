{*******************************************************}
{                                                       }
{       CodeGear Delphi Visual Component Library        }
{                                                       }
{           Copyright (c) 1995-2007 CodeGear            }
{                                                       }
{*******************************************************}

unit ValEdit;

interface

uses Windows, SysUtils, Classes, Messages, Controls, Grids, StdCtrls;

type

{ Forward Declarations }

  TItemProp = class;
  TValueListStrings = class;

{ TValueListEditor }

  TDisplayOption = (doColumnTitles, doAutoColResize, doKeyColFixed);
  TDisplayOptions = set of TDisplayOption;

  TKeyOption = (keyEdit, keyAdd, keyDelete, keyUnique);
  TKeyOptions = set of TKeyOption;

  TGetPickListEvent = procedure(Sender: TObject; const KeyName: string;
    Values: TStrings) of object;

  TOnValidateEvent = procedure(Sender: TObject; ACol, ARow: Longint;
    const KeyName, KeyValue: string) of object;

  TValueListEditor = class(TCustomDrawGrid)
  private
    FTitleCaptions: TStrings;
    FStrings: TValueListStrings;
    FKeyOptions: TKeyOptions;
    FDisplayOptions: TDisplayOptions;
    FDropDownRows: Integer;
    FDupKeySave: string;
    FDeleting: Boolean;
    FAdjustingColWidths: Boolean;
    FEditUpdate: Integer;
    FCountSave: Integer;
    FEditList: TInplaceEditList;
    FOnGetPickList: TGetPickListEvent;
    FOnEditButtonClick: TNotifyEvent;
    FOnValidate: TOnValidateEvent;
    procedure DisableEditUpdate;
    procedure EnableEditUpdate;
    function GetItemProp(const KeyOrIndex: Variant): TItemProp;
    function GetKey(Index: Integer): string;
    function GetValue(const Key: string): string;
    function GetOnStringsChange: TNotifyEvent;
    function GetOnStringsChanging: TNotifyEvent;
    function GetStrings: TStrings;
    procedure PutItemProp(const KeyOrIndex: Variant; const Value: TItemProp);
    procedure SetDisplayOptions(const Value: TDisplayOptions);
    procedure SetDropDownRows(const Value: Integer);
    procedure SetKey(Index: Integer; const Value: string);
    procedure SetKeyOptions(Value: TKeyOptions);
    procedure SetTitleCaptions(const Value: TStrings);
    procedure SetValue(const Key, Value: string);
    procedure SetOnStringsChange(const Value: TNotifyEvent);
    procedure SetOnStringsChanging(const Value: TNotifyEvent);
    procedure SetOnEditButtonClick(const Value: TNotifyEvent);
    function GetOptions: TGridOptions;
    procedure SetOptions(const Value: TGridOptions);
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
  protected
    procedure AdjustColWidths; virtual;
    procedure AdjustRowCount; virtual;
    procedure ColWidthsChanged; override;
    function CanEditModify: Boolean; override;
    function CreateEditor: TInplaceEdit; override;
    procedure CreateWnd; override;
    procedure DoExit; override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    procedure DoOnValidate; virtual;
    procedure EditListGetItems(ACol, ARow: Integer; Items: TStrings);
    function GetCell(ACol, ARow: Integer): string; virtual;
    function GetColCount: Integer;
    function GetEditLimit: Integer; override;
    function GetEditMask(ACol, ARow: Longint): string; override;
    function GetEditStyle(ACol, ARow: Longint): TEditStyle; override;
    function GetEditText(ACol, ARow: Integer): string; override;
    function GetPickList(Values: TStrings; ClearFirst: Boolean = True): Boolean;
    function GetRowCount: Integer;
    function IsEmptyRow: Boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Resize; override;
    procedure RowMoved(FromIndex, ToIndex: Longint); override;
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    procedure SetCell(ACol, ARow: Integer; const Value: string); virtual;
    procedure SetEditText(ACol, ARow: Integer; const Value: string); override;
    procedure SetStrings(const Value: TStrings); virtual;
    procedure StringsChanging; dynamic;
    function TitleCaptionsStored: Boolean;
    property EditList: TInplaceEditList read FEditList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DeleteRow(ARow: Integer); override;
    function FindRow(const KeyName: string; var Row: Integer): Boolean;
    function InsertRow(const KeyName, Value: string; Append: Boolean): Integer;
    procedure Refresh;
    function RestoreCurrentRow: Boolean;
    property Cells[ACol, ARow: Integer]: string read GetCell write SetCell;
    property ColCount read GetColCount;
    property ItemProps[const KeyOrIndex: Variant]: TItemProp read GetItemProp write PutItemProp;
    property Keys[Index: Integer]: string read GetKey write SetKey;
    property RowCount: Integer read GetRowCount;
    property Values[const Key: string]: string read GetValue write SetValue;
    property VisibleColCount;
    property VisibleRowCount;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DefaultColWidth default 150;
    property DefaultDrawing;
    property DefaultRowHeight default 18;
    property DisplayOptions: TDisplayOptions read FDisplayOptions
      write SetDisplayOptions default [doColumnTitles, doAutoColResize, doKeyColFixed];
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownRows: Integer read FDropDownRows write SetDropDownRows default 8;
    property Enabled;
    property FixedColor;
    property FixedCols default 0;
    property Font;
    property GridLineWidth;
    property KeyOptions: TKeyOptions read FKeyOptions write SetKeyOptions default [];
    property Options: TGridOptions read GetOptions write SetOptions default [goFixedVertLine, goFixedHorzLine,
      goVertLine, goHorzLine, goColSizing, goEditing, goAlwaysShowEditor,
      goThumbTracking];
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ScrollBars;
    property ShowHint;
    property Strings: TStrings read GetStrings write SetStrings;
    property TabOrder;
    property TitleCaptions: TStrings read FTitleCaptions write SetTitleCaptions stored TitleCaptionsStored;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawCell;
    property OnEditButtonClick: TNotifyEvent read FOnEditButtonClick
      write SetOnEditButtonClick;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetEditMask;
    property OnGetEditText;
    property OnGetPickList: TGetPickListEvent read FOnGetPickList write FOnGetPickList;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnRowMoved;
    property OnSelectCell;
    property OnSetEditText;
    property OnStartDock;
    property OnStartDrag;
    property OnStringsChange: TNotifyEvent read GetOnStringsChange
      write SetOnStringsChange;
    property OnStringsChanging: TNotifyEvent read GetOnStringsChanging
      write SetOnStringsChanging;
    property OnTopLeftChanged;
    property OnValidate: TOnValidateEvent read FOnValidate write FOnValidate;
  end;

  (*$HPPEMIT 'class DELPHICLASS TItemProp;' *)

{ TValueListStrings }

  TItemProps = array of TItemProp;

  TValueListStrings = class(TStringList)
  private
    FItemProps: TItemProps;
    FEditor: TValueListEditor;
    function GetItemProp(const KeyOrIndex: Variant): TItemProp;
    procedure PutItemProp(const KeyOrIndex: Variant; const Value: TItemProp);
    procedure FreeItemProps;
  protected
    procedure Changed; override;
    procedure Changing; override;
    function FindItemProp(const KeyOrIndex: Variant; Create: Boolean = False): TItemProp;
    procedure InsertItem(Index: Integer; const S: string; AObject: TObject); override;
    procedure Put(Index: Integer; const S: String); override;
  public
    constructor Create(AEditor: TValueListEditor); reintroduce;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function KeyIsValid(const Key: string; RaiseError: Boolean = True): Boolean;
    procedure Clear; override;
    procedure CustomSort(Compare: TStringListSortCompare); override;
    procedure Delete(Index: Integer); override;
    procedure Exchange(Index1, Index2: Integer); override;
    property ItemProps[const KeyOrIndex: Variant]: TItemProp read GetItemProp write PutItemProp;
  end;

{ TItemProp }

  TItemProp = class(TPersistent)
  private
    FEditor: TValueListEditor;
    FEditMask: string;
    FEditStyle: TEditStyle;
    FPickList: TStrings;
    FMaxLength: Integer;
    FReadOnly: Boolean;
    FKeyDesc: string;
    function GetPickList: TStrings;
    procedure PickListChange(Sender: TObject);
    procedure SetEditMask(const Value: string);
    procedure SetMaxLength(const Value: Integer);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetEditStyle(const Value: TEditStyle);
    procedure SetPickList(const Value: TStrings);
    procedure SetKeyDesc(const Value: string);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure UpdateEdit;
  public
    constructor Create(AEditor: TValueListEditor);
    destructor Destroy; override;
    function HasPickList: Boolean;
  published
    property EditMask: string read FEditMask write SetEditMask;
    property EditStyle: TEditStyle read FEditStyle write SetEditStyle;
    property KeyDesc: string read FKeyDesc write SetKeyDesc;
    property PickList: TStrings read GetPickList write SetPickList;
    property MaxLength: Integer read FMaxLength write SetMaxLength;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
  end;

implementation

uses Forms, Dialogs, TypInfo, Variants, Consts;

{$IFDEF LINUX}
function VarTypeIsOrdinal(const VType: TVarType): Boolean;
begin
  Result := (VType and varTypeMask) in [varSmallInt, varInteger, varByte];
end;

function VarIsOrdinal(const V: Variant): Boolean;
begin
  Result := VarTypeIsOrdinal(TVarData(V).VType);
end;
{$ENDIF}

{ TValueListEditor }

constructor TValueListEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csPannable];
  FStrings := TValueListStrings.Create(Self);
  FTitleCaptions := TStringList.Create;
  FTitleCaptions.Add(SKeyCaption);
  FTitleCaptions.Add(SValueCaption);
  ColCount := 2;
  inherited RowCount := 2;
  FixedCols := 0;
  DefaultColWidth := 150;
  DefaultRowHeight := 18;
  Width := 306;
  Height := 300;
  Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
    goColSizing, goEditing, goAlwaysShowEditor, goThumbTracking];
  FDisplayOptions := [doColumnTitles, doAutoColResize, doKeyColFixed];
  Col := 1;
  FDropDownRows := 8;
end;

destructor TValueListEditor.Destroy;
begin
  inherited;
  FTitleCaptions.Free;
  FStrings.Free;
end;

function TValueListEditor.CreateEditor: TInplaceEdit;
begin
  FEditList := TInplaceEditList.Create(Self);
  EditList.DropDownRows := FDropDownRows;
  EditList.OnEditButtonClick := FOnEditButtonClick;
  EditList.OnGetPickListitems := EditListGetItems;
  Result := FEditList;
end;

{ Helper Functions }

function FormatLine(const Key, Value: string): string;
begin
  Result := Format('%s=%s', [Key, Value]);
end;

function TValueListEditor.IsEmptyRow: Boolean;
begin
  Result := ((Row - FixedRows) < Strings.Count) and
    (Cells[0, Row] = '') and (Cells[1, Row] = '');
end;

function TValueListEditor.FindRow(const KeyName: string;
  var Row: Integer): Boolean;
begin
  Row := Strings.IndexOfName(KeyName);
  Result := Row <> -1;
  if Result then Inc(Row, FixedRows);
end;

{ Property Set/Get }

function TValueListEditor.GetColCount: Integer;
begin
  Result := inherited ColCount;
end;

function TValueListEditor.GetRowCount: Integer;
begin
  Result := inherited RowCount;
end;

function TValueListEditor.GetCell(ACol, ARow: Integer): string;
var
  Index: Integer;
  ValPos: Integer;
begin
  if (ARow = 0) and (doColumnTitles in DisplayOptions) then
  begin
    if ACol < FTitleCaptions.Count then
      Result := FTitleCaptions[ACol] else
      Result := '';
  end
  else if Strings.Count = 0 then
    Result := ''
  else
  begin
    Index := ARow - FixedRows;
    if ACol = 0 then
      Result := Strings.Names[Index]
    else
    begin
      Result := Strings.Strings[Index];
      ValPos := Pos('=', Result);
      if ValPos > 0 then
        Delete(Result, 1, ValPos);
    end;
  end;
end;

procedure TValueListEditor.SetCell(ACol, ARow: Integer;
  const Value: string);
var
  Index: Integer;
  Line: string;
begin
  Index := ARow - FixedRows;
  if ACol = 0 then
    Line := FormatLine(Value, Cells[1, ARow]) else
    Line := FormatLine(Cells[0, ARow], Value);
  if Index >= Strings.Count then
    Strings.Add(Line) else
    Strings[Index] := Line;
end;

procedure TValueListEditor.SetDropDownRows(const Value: Integer);
begin
  FDropDownRows := Value;
  if Assigned(EditList) then
    EditList.DropDownRows := Value;
end;

function TValueListEditor.GetKey(Index: Integer): string;
begin
  Result := GetCell(0, Index);
end;

procedure TValueListEditor.SetKey(Index: Integer; const Value: string);
begin
  SetCell(0, Index, Value);
end;

function TValueListEditor.GetValue(const Key: string): string;
var
  I: Integer;
begin
  if FindRow(Key, I) then
    Result := Cells[1, I] else
    Result := '';
end;

procedure TValueListEditor.SetValue(const Key, Value: string);
var
  I: Integer;
begin
  if FindRow(Key, I) then Cells[1, I] := Value
  else InsertRow(Key, Value, True);
end;

procedure TValueListEditor.SetTitleCaptions(const Value: TStrings);
begin
  FTitleCaptions.Assign(Value);
  Refresh;
end;

function TValueListEditor.TitleCaptionsStored: Boolean;
begin
  Result := TitleCaptions.Text <> (SKeyCaption+SLineBreak+SValueCaption+SLineBreak);
end;

function TValueListEditor.GetStrings: TStrings;
begin
  Result := FStrings;
end;

procedure TValueListEditor.SetStrings(const Value: TStrings);
begin
  FStrings.Assign(Value);
end;

procedure TValueListEditor.SetDisplayOptions(const Value: TDisplayOptions);

  procedure SetColumnTitles(Visible: Boolean);
  begin
    if Visible then
    begin
      if RowCount < 2 then inherited RowCount := 2;
      FixedRows := 1;
    end else
      FixedRows := 0;
  end;

begin
  if (doColumnTitles in DisplayOptions) <> (doColumnTitles in Value) then
    SetColumnTitles(doColumnTitles in Value);
  FDisplayOptions := Value;
  AdjustColWidths;
  Refresh;
end;

function TValueListEditor.GetItemProp(const KeyOrIndex: Variant): TItemProp;
begin
  Result := FStrings.GetItemProp(KeyOrIndex);
end;

procedure TValueListEditor.PutItemProp(const KeyOrIndex: Variant; const Value: TItemProp);
begin
  FStrings.PutItemProp(KeyOrIndex, Value);
end;

procedure TValueListEditor.SetKeyOptions(Value: TKeyOptions);
begin
  { Need to be able to Edit when you can Add }
  if not (keyEdit in Value) and (keyEdit in FKeyOptions) then
    Value := Value - [keyAdd];
  if (keyAdd in Value) and not (keyAdd in FKeyOptions) then
    Value := Value + [keyEdit];
  if not (keyEdit in Value) and (Col = 0) then
    Col := 1;
  FKeyOptions := Value;
end;

function TValueListEditor.GetOnStringsChange: TNotifyEvent;
begin
  Result := FStrings.OnChange;
end;

function TValueListEditor.GetOnStringsChanging: TNotifyEvent;
begin
  Result := FStrings.OnChanging;
end;

procedure TValueListEditor.SetOnStringsChange(const Value: TNotifyEvent);
begin
  FStrings.OnChange := Value;
end;

procedure TValueListEditor.SetOnStringsChanging(const Value: TNotifyEvent);
begin
  FStrings.OnChanging := Value;
end;

procedure TValueListEditor.SetOnEditButtonClick(const Value: TNotifyEvent);
begin
  FOnEditButtonClick := Value;
  if Assigned(EditList) then
    EditList.OnEditButtonClick := FOnEditButtonClick;
end;

{ Display / Refresh }

procedure TValueListEditor.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
  CellText: string;
  ItemProp: TItemProp;
begin
  if DefaultDrawing then
  begin
    if (ACol = 0) and (ARow > FixedRows-1) then
      ItemProp := FStrings.FindItemProp(ARow-FixedRows, False)
    else
      ItemProp := nil;
    if (ItemProp <> nil) and (ItemProp.KeyDesc <> '') then
      CellText := ItemProp.KeyDesc
    else
      CellText := Cells[ACol, ARow];
    Canvas.TextRect(ARect, ARect.Left+2, ARect.Top+2, CellText);
  end;
  inherited DrawCell(ACol, ARow, ARect, AState);
end;

procedure TValueListEditor.AdjustColWidths;

begin
  if not FAdjustingColWidths and HandleAllocated and Showing and
     (doAutoColResize in DisplayOptions) then
  begin
    FAdjustingColWidths := True;
    try
      if (ColWidths[0] + ColWidths[1]) <> (ClientWidth - 2) then
      begin
        if doKeyColFixed in DisplayOptions then
          ColWidths[1] := ClientWidth - ColWidths[0] - 2
        else
        begin
          ColWidths[0] := (ClientWidth - 2) div 2;
          ColWidths[1] := ColWidths[0] + ((ClientWidth - 2) mod 2);
        end;
      end;
    finally
      FAdjustingColWidths := False;
    end;
  end;
end;

procedure TValueListEditor.AdjustRowCount;
var
  NewRowCount: Integer;
begin
  if Strings.Count > 0 then
    NewRowCount := Strings.Count + FixedRows else
    NewRowCount := FixedRows + 1;
  if NewRowCount <> RowCount then
  begin
    if NewRowCount < Row then
      Row := NewRowCount - 1;
    if (doColumnTitles in DisplayOptions) and (Row = 0) then Row := 1;
    inherited RowCount := NewRowCount;
  end;
end;

procedure TValueListEditor.Resize;
begin
  inherited;
  AdjustColWidths;
end;

procedure TValueListEditor.ColWidthsChanged;
begin
  AdjustColWidths;
  inherited;
end;

procedure TValueListEditor.Refresh;
begin
  if FEditUpdate = 0 then
  begin
    AdjustRowCount;
    Invalidate;
    InvalidateEditor;
  end;
end;

procedure TValueListEditor.StringsChanging;
begin
  HideEdit;
end;

{ Editing }

function TValueListEditor.CanEditModify: Boolean;
var
  ItemProp: TItemProp;
begin
  Result := inherited CanEditModify;
  if Result then
  begin
    ItemProp := FStrings.FindItemProp(Row-FixedRows);
    if Assigned(ItemProp) then
      Result := not ItemProp.ReadOnly;
  end;
end;

procedure TValueListEditor.DisableEditUpdate;
begin
  if FEditUpdate = 0 then
    FCountSave := Strings.Count;
  Inc(FEditUpdate);
end;

procedure TValueListEditor.EnableEditUpdate;
begin
  Dec(FEditUpdate);
  if (FEditUpdate = 0) and (FCountSave <> Strings.Count) then
      Refresh;
end;

function TValueListEditor.GetEditLimit: Integer;
var
  ItemProp: TItemProp;
begin
  ItemProp := FStrings.FindItemProp(Row-FixedRows);
  if Assigned(ItemProp) then
    Result := ItemProp.MaxLength else
    Result := inherited GetEditLimit;
end;

function TValueListEditor.GetEditMask(ACol, ARow: Integer): string;
var
  ItemProp: TItemProp;
begin
  ItemProp := FStrings.FindItemProp(Row-FixedRows);
  if Assigned(ItemProp) then
    Result := ItemProp.EditMask else
    Result := '';
  if Assigned(OnGetEditMask) then
    OnGetEditMask(Self, ACol, ARow, Result);
end;

function TValueListEditor.GetEditStyle(ACol, ARow: Integer): TEditStyle;
var
  ItemProp: TItemProp;
begin
  Result := esSimple;
  if (ACol <> 0) then
  begin
    ItemProp := FStrings.FindItemProp(Row-FixedRows);
    if Assigned(ItemProp) and (ItemProp.EditStyle <> esSimple) then
      Result := ItemProp.EditStyle
    else if GetPickList(EditList.PickList.Items) then
      Result := esPickList;
  end;
end;

function TValueListEditor.GetEditText(ACol, ARow: Longint): string;
begin
  Result := Cells[ACol, ARow];
  if Assigned(OnGetEditText) then OnGetEditText(Self, ACol, ARow, Result);
end;

procedure TValueListEditor.SetEditText(ACol, ARow: Longint; const Value: string);
begin
  inherited SetEditText(ACol, ARow, Value);
  DisableEditUpdate;
  try
    if ((ARow - FixedRows) >= Strings.Count) and (Value <> '') then
    begin
      Strings.Append('');
      FCountSave := FStrings.Count;
    end;
    if (Value <> Cells[ACol, ARow]) then
    begin
      { If the Key is being updated, defer any error about duplicates until
        we try to we try to write it a second time (which will happen when
        the user tries to move to a different cell) }
      if (ACol = 0) and not FStrings.KeyIsValid(Value, False) and
         (FDupKeySave <> Value) then
        FDupKeySave := Value
      else
      begin
        FDupKeySave := '';
        Cells[ACol, ARow] := Value;
      end;
    end;
  finally
    EnableEditUpdate;
  end;
end;

procedure TValueListEditor.EditListGetItems(ACol, ARow: Integer;
  Items: TStrings);
var
  ItemProp: TItemProp;
begin
  if (ACol <> 0) then
  begin
    ItemProp := FStrings.FindItemProp(Row-FixedRows);
    if Assigned(ItemProp) and ItemProp.HasPickList then
      Items.Assign(ItemProp.PickList)
    else
      Items.Clear;
    GetPickList(Items, False);
  end;
end;

function TValueListEditor.GetPickList(Values: TStrings;
  ClearFirst: Boolean = True): Boolean;
begin
  if Assigned(FOnGetPickList) and (Keys[Row] <> '') then
  begin
    Values.BeginUpdate;
    try
      if ClearFirst then
        Values.Clear;
      FOnGetPickList(Self, Keys[Row], Values);
      Result := Values.Count > 0;
      EditList.PickListLoaded := Result;
    finally
      Values.EndUpdate;
    end
  end
  else
    Result := False;
end;

function TValueListEditor.InsertRow(const KeyName, Value: string;
  Append: Boolean): Integer;
begin
  Result := Row;
  { If row is empty, use it, otherwise add a new row }
  if (Result > Strings.Count) or not IsEmptyRow then
  begin
    Strings.BeginUpdate;
    try
      if Append then
        Result := Strings.Add(FormatLine(KeyName, Value)) + FixedRows else
        Strings.Insert(Result - FixedRows, FormatLine(KeyName, Value));
    finally
      Strings.EndUpdate;
    end;
  end else
  begin
    Cells[0, Result] := KeyName;
    Cells[1, Result] := Value;
  end;
end;

procedure TValueListEditor.DeleteRow(ARow: Integer);
begin
  if FDeleting then Exit;
  FDeleting := True;
  try
    if (Row >= RowCount - 1) and (Strings.Count > 1) then
      Row := Row - 1;
    Strings.Delete(ARow - FixedRows);
  finally
    FDeleting := False;
  end;
end;

function TValueListEditor.RestoreCurrentRow: Boolean;

  function RestoreInplaceEditor: Boolean;
  var
    ChangedText: string;
  begin
    Result := False;
    if Assigned(EditList) and EditList.Modified then
    begin
      ChangedText := EditList.EditText;
      EditList.RestoreContents;
      Result := ChangedText <> EditList.EditText;
      if Result then
        EditList.SelectAll;
    end;
  end;

begin
  Result := RestoreInplaceEditor;
  if not Result and IsEmptyRow then
  begin
    DeleteRow(Row);
    Result := True;
  end
end;

procedure TValueListEditor.RowMoved(FromIndex, ToIndex: Longint);
begin
  Strings.Move(FromIndex, ToIndex);
  inherited RowMoved(FromIndex, ToIndex);
end;

procedure TValueListEditor.DoOnValidate;
begin
  if Assigned(FOnValidate) and (InplaceEditor <> nil) and InplaceEditor.Modified then
  begin
    FOnValidate(Self, Col, Row, GetCell(0, Row), GetCell(1, Row)); ///!!!
  end;
end;

function TValueListEditor.SelectCell(ACol, ARow: Integer): Boolean;
begin
  { Delete any blank rows when moving to a new row }
  if (ARow <> Row) and (Strings.Count > 0) and IsEmptyRow and not FDeleting then
  begin
    Result := (ARow < Row);
    DeleteRow(Row);
    { When the selected cell is below, we need to adjust for the deletion }
    if not Result then
      FocusCell(ACol, ARow - 1, True);
  end else
  begin
    DoOnValidate;
    Result := inherited SelectCell(ACol, ARow) and
              ((goRowSelect in Options) or (keyEdit in KeyOptions) or (ACol > 0));
  end;
end;

procedure TValueListEditor.KeyDown(var Key: Word; Shift: TShiftState);

  function InsertOK: Boolean;
  begin
    Result := (Length(Cells[0, Row]) > 0) and (keyAdd in KeyOptions)
  end;

  procedure SetRow(NewRow: Integer);
  begin
    Row := NewRow;
    Key := 0;
  end;

begin
  case Key of
    VK_DOWN:
      if Shift = [ssCtrl] then
        SetRow(RowCount - 1)
      else if (Shift = []) and (Row = RowCount - 1) and InsertOK then
        SetRow(InsertRow('', '', True));
    VK_UP:
      if Shift = [ssCtrl] then SetRow(FixedRows);
    VK_INSERT:
      if InsertOK then SetRow(InsertRow('', '', False));
    VK_DELETE:
      if (Shift = [ssCtrl]) and (keyDelete in KeyOptions) then
      begin
        DeleteRow(Row);
        Key := 0;
      end;
    VK_ESCAPE:
      RestoreCurrentRow;
  end;
  inherited KeyDown(Key, Shift);
end;


function TValueListEditor.GetOptions: TGridOptions;
begin
  Result := inherited Options;
end;

procedure TValueListEditor.SetOptions(const Value: TGridOptions);
begin
  if goColMoving in Value then
    raise Exception.CreateRes(@SNoColumnMoving);
  inherited Options := Value;
end;

procedure TValueListEditor.CreateWnd;
begin
  inherited;
  { Clear the default vertical scrollbar since this will affect the client
    width of the control which will cause problems when calculating the
    column widths in the AdjustColWidths function }
  SetScrollRange(Handle, SB_VERT, 0, 0, False);
end;

procedure TValueListEditor.DoExit;
begin
  try
    DoOnValidate;
  except
    SetFocus;
    raise;
  end;
  inherited;
  HideEdit;
end;

procedure TValueListEditor.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if Showing then
    AdjustColWidths;
end;

procedure TValueListEditor.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  try
    DoOnValidate;
  except
    SetFocus;
    raise;
  end;
  inherited;
  HideEdit;
end;

{ TValueListStrings }

constructor TValueListStrings.Create(AEditor: TValueListEditor);
begin
  FEditor := AEditor;
  inherited Create;
end;

destructor TValueListStrings.Destroy;
begin
  FreeItemProps;
  inherited;
end;

procedure TValueListStrings.Assign(Source: TPersistent);
var
  I: Integer;
  ItemProp: TItemProp;
  ValStrings: TValueListStrings;
begin
  inherited;
  if Source is TValueListStrings then
  begin
    ValStrings := TValueListStrings(Source);
    for I := 0 to Count - 1 do
    begin
      ItemProp := ValStrings.FindItemProp(I);
      if Assigned(ItemProp) then
        ItemProps[I] := ItemProp;
    end;
  end;
end;

procedure TValueListStrings.Changing;
begin
  inherited;
  if (UpdateCount = 0) and Assigned(FEditor) and (FEditor.FEditUpdate = 0) then
    FEditor.StringsChanging;
end;

procedure TValueListStrings.Changed;
begin
  inherited;
  if (UpdateCount = 0) and Assigned(FEditor) then
    FEditor.Refresh;
end;

function TValueListStrings.KeyIsValid(const Key: string; RaiseError: Boolean = True): Boolean;
var
  Index: Integer;
begin
  Result := True;
  if Pos('=', Key) <> 0 then
    raise Exception.CreateRes(@SNoEqualsInKey);
  if Assigned(FEditor) and (keyUnique in FEditor.KeyOptions) then
  begin
    if Key <> '' then
    begin
      Index := IndexOfName(Key);
      Result := (Index = -1);
      if not Result and RaiseError then
        raise Exception.CreateResFmt(@SKeyConflict, [Key]);
    end;
  end;
end;

procedure TValueListStrings.Clear;
begin
  inherited;
  FreeItemProps;
end;

procedure TValueListStrings.CustomSort(Compare: TStringListSortCompare);
var
  I, OldIndex: Integer;
  OldOrder: TList;
  OldProps: TItemProps;
begin
  OldOrder := TList.Create;
  try
    { Preserve the existing order so we can re-associate the ItemProps }
    OldOrder.Count := Count;
    OldProps := Copy(FItemProps, 0, Count);
    for I := 0 to Count - 1 do
      OldOrder[I] := Pointer(Get(I));
    { Do the Sort }
    inherited;
    { Find and move the ItemProps }
    for I := 0 to Count - 1 do
    begin
      OldIndex := OldOrder.IndexOf(Pointer(Get(I)));
      FItemProps[I] := OldProps[OldIndex];
    end;
  finally
    OldOrder.Free;
  end;
  FEditor.InvalidateEditor;
end;

procedure TValueListStrings.Delete(Index: Integer);
begin
  Changing;
  inherited;
  FItemProps[Index].Free;
  if Index < Count then
    System.Move(FItemProps[Index + 1], FItemProps[Index],
      (Count - Index) * SizeOf(TItemProp));
  SetLength(FItemProps, Count);
  Changed;
end;

procedure TValueListStrings.Exchange(Index1, Index2: Integer);
var
  Item: TItemProp;
begin
  Changing;
  inherited;
  Item := FItemProps[Index1];
  FItemProps[Index1] := FItemProps[Index2];
  FItemProps[Index2] := Item;
  Changed;
end;

function TValueListStrings.FindItemProp(const KeyOrIndex: Variant;
  Create: Boolean = False): TItemProp;
var
  Index: Integer;
begin
  if (Count > 0) and Assigned(FItemProps) then
  begin
    if VarIsOrdinal(KeyOrIndex) then
      Index := KeyOrIndex
    else
    begin
      Index := IndexOfName(KeyOrIndex);
      if Create and (Index = -1) then
        raise Exception.CreateResFmt(@SKeyNotFound, [KeyOrIndex]);
    end;
    Result := FItemProps[Index];
    if Create and not Assigned(Result) then
    begin
      Result := TItemProp.Create(FEditor);
      FItemProps[Index] := Result;
    end;
  end
  else
    Result := nil;
end;

procedure TValueListStrings.InsertItem(Index: Integer; const S: string;
  AObject: TObject);
var
  OldCount: Integer;
begin
  KeyIsValid(ExtractName(S));
  Changing;
  OldCount := Count;
  inherited;
  SetLength(FItemProps, Count);
  if Index < OldCount then
    System.Move(FItemProps[Index], FItemProps[Index + 1],
      (OldCount - Index) * SizeOf(TItemProp));
  FItemProps[Index] := nil;
  Changed;
end;

function TValueListStrings.GetItemProp(const KeyOrIndex: Variant): TItemProp;
begin
  Result := FindItemProp(KeyOrIndex, True);
end;

procedure TValueListStrings.Put(Index: Integer; const S: String);
var
  Name: string;
begin
  Name := ExtractName(S);
  KeyIsValid(Name, IndexOfName(Name) <> Index);
  inherited;
end;

procedure TValueListStrings.PutItemProp(const KeyOrIndex: Variant;
  const Value: TItemProp);
begin
  FindItemProp(KeyOrIndex, True).Assign(Value);
end;

procedure TValueListStrings.FreeItemProps;
var
  I: Integer;
begin
  for I := 0 to Length(FItemProps) - 1 do
    FItemProps[I].Free;
  SetLength(FItemProps, 0);
end;

{ TItemProp }

constructor TItemProp.Create(AEditor: TValueListEditor);
begin
  FEditor := AEditor;
end;

destructor TItemProp.Destroy;
begin
  inherited;
  FPickList.Free;
end;

procedure TItemProp.AssignTo(Dest: TPersistent);
begin
  if Dest is TItemProp then
    with Dest as TItemProp do
    begin
      EditMask := Self.EditMask;
      EditStyle := Self.EditStyle;
      PickList.Assign(Self.PickList);
      MaxLength := Self.MaxLength;
      ReadOnly := Self.ReadOnly;
      KeyDesc := Self.KeyDesc;
    end
  else
    inherited;
end;

procedure TItemProp.SetEditMask(const Value: string);
begin
  FEditMask := Value;
  UpdateEdit;
end;

procedure TItemProp.SetEditStyle(const Value: TEditStyle);
begin
  FEditStyle := Value;
  UpdateEdit;
end;

procedure TItemProp.SetKeyDesc(const Value: string);
begin
  FKeyDesc := Value;
end;

procedure TItemProp.SetMaxLength(const Value: Integer);
begin
  FMaxLength := Value;
  UpdateEdit;
end;

function TItemProp.HasPickList: Boolean;
begin
  Result := Assigned(FPickList) and (FPickList.Count > 0);
end;

function TItemProp.GetPickList: TStrings;
begin
  if not Assigned(FPickList) then
  begin
    FPickList := TStringList.Create;
    TStringList(FPickList).OnChange := PickListChange;
  end;
  Result := FPickList;
end;

procedure TItemProp.SetPickList(const Value: TStrings);
begin
  GetPickList.Assign(Value);
  UpdateEdit;
end;

procedure TItemProp.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  UpdateEdit;
end;

procedure TItemProp.UpdateEdit;
begin
  if Assigned(FEditor) and FEditor.EditorMode and
     (FEditor.FStrings.UpdateCount = 0) then
    FEditor.InvalidateEditor;
end;

procedure TItemProp.PickListChange(Sender: TObject);
begin
  if (EditStyle = esSimple) and (PickList.Count > 0) then
    EditStyle := esPickList
  else if (EditStyle = esPickList) and (PickList.Count = 0) then
    EditStyle := esSimple;
end;

end.
