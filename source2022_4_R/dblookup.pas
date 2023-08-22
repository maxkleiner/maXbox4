
{*******************************************************}
{                                                       }
{       CodeGear Delphi Visual Component Library        }
{                                                       }
{  	    Copyright (c) 1995-2007 CodeGear	        }
{                                                       }
{*******************************************************}

unit dblookup;

{$R-}

interface

uses Windows, Classes, StdCtrls, DB, Controls, Messages, SysUtils,
  Forms, Graphics, Menus, Buttons, DBGrids, DBTables, Grids, Dbctrls;

type

{ TDBLookupCombo }

  TPopupGrid = class;

  TDBLookupComboStyle = (csDropDown, csDropDownList);
  TDBLookupListOption = (loColLines, loRowLines, loTitles);
  TDBLookupListOptions = set of TDBLookupListOption;

  TDBLookupCombo = class(TCustomEdit)
  private
    FCanvas: TControlCanvas;
    FDropDownCount: Integer;
    FDropDownWidth: Integer;
    FTextMargin: Integer;
    FFieldLink: TFieldDataLink;
    FGrid: TPopupGrid;
    FButton: TSpeedButton;
    FBtnControl: TWinControl;
    FStyle: TDBLookupComboStyle;
    FOnDropDown: TNotifyEvent;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetLookupSource: TDataSource;
    function GetLookupDisplay: string;
    function GetLookupField: string;
    function GetReadOnly: Boolean;
    function GetValue: string;
    function GetDisplayValue: string;
    function GetMinHeight: Integer;
    function GetOptions: TDBLookupListOptions;
    function CanEdit: Boolean;
    function Editable: Boolean;
    procedure SetValue(const NewValue: string);
    procedure SetDisplayValue(const NewValue: string);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetLookupSource(Value: TDataSource);
    procedure SetLookupDisplay(const Value: string);
    procedure SetLookupField(const Value: string);
    procedure SetReadOnly(Value: Boolean);
    procedure SetOptions(Value: TDBLookupListOptions);
    procedure SetStyle(Value: TDBLookupComboStyle);
    procedure UpdateData(Sender: TObject);
    procedure FieldLinkActive(Sender: TObject);
    procedure NonEditMouseDown(var Message: TWMLButtonDown);
    procedure DoSelectAll;
    procedure SetEditRect;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Change; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure GridClick (Sender: TObject);
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DropDown; dynamic;
    procedure CloseUp; dynamic;
    property Value: string read GetValue write SetValue;
    property DisplayValue: string read GetDisplayValue write SetDisplayValue;
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property LookupSource: TDataSource read GetLookupSource write SetLookupSource;
    property LookupDisplay: string read GetLookupDisplay write SetLookupDisplay;
    property LookupField: string read GetLookupField write SetLookupField;
    property Options: TDBLookupListOptions read GetOptions write SetOptions default [];
    property Style: TDBLookupComboStyle read FStyle write SetStyle default csDropDown;
    property Anchors;
    property AutoSelect;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property DropDownCount: Integer read FDropDownCount write FDropDownCount default 8;
    property DropDownWidth: Integer read FDropDownWidth write FDropDownWidth default 0;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
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
  end;

{ TDBLookupList }

  TDBLookupList = class(TCustomDBGrid)
  private
    FFieldLink: TFieldDataLink;
    FLookupDisplay: string;
    FLookupField: string;
    FDisplayFld: TField;
    FValueFld: TField;
    FValue: string;
    FDisplayValue: string;
    FHiliteRow: Integer;
    FOptions: TDBLookupListOptions;
    FTitleOffset: Integer;
    FFoundValue: Boolean;
    FInCellSelect: Boolean;
    FOnListClick: TNotifyEvent;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetLookupSource: TDataSource;
    function GetReadOnly: Boolean;
    procedure FieldLinkActive(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetLookupSource(Value: TDataSource);
    procedure SetLookupDisplay(const Value: string);
    procedure SetLookupField(const Value: string);
    procedure SetValue(const Value: string);
    procedure SetDisplayValue(const Value: string);
    procedure SetReadOnly(Value: Boolean);
    procedure SetOptions(Value: TDBLookupListOptions);
    procedure UpdateData(Sender: TObject);
    procedure NewLayout;
    procedure DoLookup;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  protected
    function HighlightCell(DataCol, DataRow: Integer; const Value: string;
      AState: TGridDrawState): Boolean; override;
    function CanGridAcceptKey(Key: Word; Shift: TShiftState): Boolean; override;
    procedure DefineFieldMap; override;
    procedure SetColumnAttributes; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function CanEdit: Boolean; virtual;
    procedure InitFields(ShowError: Boolean);
    procedure CreateWnd; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure LinkActive(Value: Boolean); override;
    procedure Paint; override;
    procedure Scroll(Distance: Integer); override;
    procedure ListClick; dynamic;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Value: string read FValue write SetValue;
    property DisplayValue: string read FDisplayValue write SetDisplayValue;
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property LookupSource: TDataSource read GetLookupSource write SetLookupSource;
    property LookupDisplay: string read FLookupDisplay write SetLookupDisplay;
    property LookupField: string read FLookupField write SetLookupField;
    property Options: TDBLookupListOptions read FOptions write SetOptions default [];
    property OnClick: TNotifyEvent read FOnListClick write FOnListClick;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property Align;
    property Anchors;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDrag;
  end;

{ TPopupGrid }

  TPopupGrid = class(TDBLookupList)
  private
    FCombo: TDBLookupCombo;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function CanEdit: Boolean; override;
    procedure LinkActive(Value: Boolean); override;
  public
    property RowCount;
    constructor Create(AOwner: TComponent); override;
  end;

{ TComboButton }

  TComboButton = class(TSpeedButton)
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  end;

implementation

uses DBConsts, bdeconst;

{ TDBLookupCombo }

constructor TDBLookupCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := False;
  FFieldLink := TFieldDataLink.Create;
  FFieldLink.Control := Self;
  FFieldLink.OnDataChange := DataChange;
  FFieldLink.OnEditingChange := EditingChange;
  FFieldLink.OnUpdateData := UpdateData;
  FFieldLink.OnActiveChange := FieldLinkActive;
  FBtnControl := TWinControl.Create(Self);
  FBtnControl.Width := 17;
  FBtnControl.Height := 17;
  FBtnControl.Visible := True;
  FBtnControl.Parent := Self;
  FButton := TComboButton.Create(Self);
  FButton.SetBounds(0, 0, FBtnControl.Width, FBtnControl.Height);
  FButton.Glyph.Handle := LoadBitmap(0, PChar(32738));
  FButton.Visible := True;
  FButton.Parent := FBtnControl;
  FGrid := TPopupGrid.Create(Self);
  FGrid.FCombo := Self;
  FGrid.Parent := Self;
  FGrid.Visible := False;
  FGrid.OnClick := GridClick;
  Height := 25;
  FDropDownCount := 8;
end;

destructor TDBLookupCombo.Destroy;
begin
  FFieldLink.OnDataChange := nil;
  FFieldLink.Free;
  FFieldLink := nil;
  inherited Destroy;
end;

procedure TDBLookupCombo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FFieldLink <> nil) then
  begin
    if (AComponent = DataSource) then DataSource := nil
    else if (AComponent = LookupSource) then
      LookupSource := nil;
  end;
end;

function TDBLookupCombo.Editable: Boolean;
begin
  Result := (FFieldLink.DataSource = nil) or
    ((FGrid.FValueFld = FGrid.FDisplayFld) and (FStyle <> csDropDownList));
end;

function TDBLookupCombo.CanEdit: Boolean;
begin
  Result := (FFieldLink.DataSource = nil) or
    (FFieldLink.Editing and Editable);
end;

procedure TDBLookupCombo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Key in [VK_BACK, VK_DELETE, VK_INSERT] then
  begin
    if Editable then
      FFieldLink.Edit;
    if not CanEdit then
      Key := 0;
  end
  else if not Editable and (Key in [VK_HOME, VK_END, VK_LEFT, VK_RIGHT]) then
    Key := 0;

  if (Key in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR]) then
  begin
    if not FGrid.Visible then DropDown
    else begin
      FFieldLink.Edit;
      if (FFieldLink.DataSource = nil) or FFieldLink.Editing then
        FGrid.KeyDown(Key, Shift);
    end;
    Key := 0;
  end;
end;

procedure TDBLookupCombo.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (Key in [#32..#255]) and (FFieldLink.Field <> nil) and
    not FFieldLink.Field.IsValidChar(Key) and Editable then
  begin
    Key := #0;
    MessageBeep(0)
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      begin
        if Editable then FFieldLink.Edit;
        if not CanEdit then Key := #0;
      end;
    char(VK_RETURN):
      Key := #0;
    char(VK_ESCAPE):
      begin
        if not FGrid.Visible then
          FFieldLink.Reset
        else CloseUp;
        DoSelectAll;
        Key := #0;
      end;
  end;
end;

procedure TDBLookupCombo.Change;
begin
  if FFieldLink.Editing then FFieldLink.Modified;
  inherited Change;
end;

function TDBLookupCombo.GetDataSource: TDataSource;
begin
  Result := FFieldLink.DataSource;
end;

procedure TDBLookupCombo.SetDataSource(Value: TDataSource);
begin
  if (Value <> nil) and (Value = LookupSource) then
    raise EInvalidOperation.Create (SLookupSourceError);
  if (Value <> nil) and (LookupSource <> nil) and (Value.DataSet <> nil) and
    (Value.DataSet = LookupSource.DataSet) then
    raise EInvalidOperation.Create(SLookupSourceError);
  FFieldLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDBLookupCombo.GetLookupSource: TDataSource;
begin
  Result := FGrid.LookupSource;
end;

procedure TDBLookupCombo.SetLookupSource(Value: TDataSource);
begin
  if (Value <> nil) and ((Value = DataSource) or
    ((Value.DataSet <> nil) and (Value.DataSet = FFieldLink.DataSet))) then
    raise EInvalidOperation.Create(SLookupSourceError);
  FGrid.LookupSource := Value;
  DataChange(Self);
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TDBLookupCombo.SetLookupDisplay(const Value: string);
begin
  FGrid.LookupDisplay := Value;
  FGrid.InitFields(True);
  SetValue('');
  DataChange(Self);
end;

function TDBLookupCombo.GetLookupDisplay: string;
begin
  Result := FGrid.LookupDisplay;
end;

procedure TDBLookupCombo.SetLookupField(const Value: string);
begin
  FGrid.LookupField := Value;
  FGrid.InitFields(True);
  DataChange(Self);
end;

function TDBLookupCombo.GetLookupField: string;
begin
  Result := FGrid.LookupField;
end;

function TDBLookupCombo.GetDataField: string;
begin
  Result := FFieldLink.FieldName;
end;

procedure TDBLookupCombo.SetDataField(const Value: string);
begin
  FFieldLink.FieldName := Value;
end;

procedure TDBLookupCombo.DataChange(Sender: TObject);
begin
  if (FFieldLink.Field <> nil) and not (csLoading in ComponentState) then
    Value := FFieldLink.Field.AsString
  else Text := '';
end;

function TDBLookupCombo.GetValue: String;
begin
  if Editable then
    Result := Text else
    Result := FGrid.Value;
end;

function TDBLookupCombo.GetDisplayValue: String;
begin
  Result := Text;
end;

procedure TDBLookupCombo.SetDisplayValue(const NewValue: String);
begin
  if FGrid.DisplayValue <> NewValue then
    if FGrid.DataLink.Active then
    begin
      FGrid.DisplayValue := NewValue;
      Text := FGrid.DisplayValue;
    end;
end;

procedure TDBLookupCombo.SetValue(const NewValue: String);
begin
  if FGrid.DataLink.Active and FFieldLink.Active and
    ((DataSource = LookupSource) or
    (DataSource.DataSet = LookupSource.DataSet)) then
    raise EInvalidOperation.Create(SLookupSourceError);
  if (FGrid.Value <> NewValue) or (Text <> NewValue) then
    if FGrid.DataLink.Active then
    begin
      FGrid.Value := NewValue;
      Text := FGrid.DisplayValue;
    end;
end;

function TDBLookupCombo.GetReadOnly: Boolean;
begin
  Result := FFieldLink.ReadOnly;
end;

procedure TDBLookupCombo.SetReadOnly(Value: Boolean);
begin
  FFieldLink.ReadOnly := Value;
  inherited ReadOnly := not CanEdit;
end;

procedure TDBLookupCombo.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not CanEdit;
end;

procedure TDBLookupCombo.UpdateData(Sender: TObject);
begin
  if FFieldLink.Field <> nil then
    if Editable then
      FFieldLink.Field.AsString := Text else
      FFieldLink.Field.AsString := FGrid.Value;
end;

procedure TDBLookupCombo.FieldLinkActive(Sender: TObject);
begin
  if FFieldLink.Active and FGrid.DataLink.Active then
  begin
    FGrid.SetValue('');
    DataChange(Self)
  end;
end;

procedure TDBLookupCombo.WMPaste(var Message: TMessage);
begin
  if Editable then FFieldLink.Edit;
  if CanEdit then inherited;
end;

procedure TDBLookupCombo.WMCut(var Message: TMessage);
begin
  if Editable then FFieldLink.Edit;
  if CanEdit then inherited;
end;

procedure TDBLookupCombo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TDBLookupCombo.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
  FGrid.HandleNeeded;
  DataChange(Self);
end;

procedure TDBLookupCombo.SetEditRect;
var
  Loc: TRect;
begin
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := FBtnControl.Left - 2;
  Loc.Top := 0;
  Loc.Left := 0;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
end;

procedure TDBLookupCombo.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
begin
  inherited;
  if (csDesigning in ComponentState) then
    FGrid.SetBounds(0, Height + 1, 10, 10);
  MinHeight := GetMinHeight;
  if Height < MinHeight then Height := MinHeight
  else begin
    if NewStyleControls then
      FBtnControl.SetBounds(ClientWidth - FButton.Width, 0, FButton.Width, ClientHeight)
    else
      FBtnControl.SetBounds(ClientWidth - FButton.Width, 1, FButton.Width, ClientHeight - 1);
    FButton.Height := FBtnControl.Height;
    SetEditRect;
  end;
end;

function TDBLookupCombo.GetMinHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  I := SysMetrics.tmHeight;
  if I > Metrics.tmHeight then I := Metrics.tmHeight;
  FTextMargin := I div 4;
  Result := Metrics.tmHeight + FTextMargin + GetSystemMetrics(SM_CYBORDER) * 4 + 1;
end;

procedure TDBLookupCombo.WMPaint(var Message: TWMPaint);
var
  PS: TPaintStruct;
  ARect: TRect;
  TextLeft, TextTop: Integer;
  Focused: Boolean;
  DC: HDC;
const
  Formats: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT,
    DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX);
begin
  if Editable then
  begin
    inherited;
    Exit;
  end;

  if FCanvas = nil then
  begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := Self;
  end;

  DC := Message.DC;
  if DC = 0 then DC := BeginPaint(Handle, PS);
  FCanvas.Handle := DC;
  try
    Focused := GetFocus = Handle;
    FCanvas.Font := Font;
    with FCanvas do
    begin
      ARect := ClientRect;
      Brush.Color := clWindowFrame;
      FrameRect(ARect);
      InflateRect(ARect, -1, -1);
      Brush.Style := bsSolid;
      Brush.Color := Color;
      FillRect (ARect);
      TextTop := FTextMargin;
      ARect.Left := ARect.Left + 2;
      ARect.Right := FBtnControl.Left - 2;
      TextLeft := FTextMargin;
      if Focused then
      begin
        Brush.Color := clHighlight;
        Font.Color := clHighlightText;
        ARect.Top := ARect.Top + 2;
        ARect.Bottom := ARect.Bottom - 2;
      end;
      ExtTextOut(FCanvas.Handle, TextLeft, TextTop, ETO_OPAQUE or ETO_CLIPPED, @ARect,
        PChar(Text), Length(Text), nil);
      if Focused then
        DrawFocusRect(ARect);
    end;
  finally
    FCanvas.Handle := 0;
    if Message.DC = 0 then EndPaint(Handle, PS);
  end;
end;

procedure TDBLookupCombo.CMFontChanged(var Message: TMessage);
begin
  inherited;
  GetMinHeight;
end;

procedure TDBLookupCombo.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  FButton.Enabled := Enabled;
end;

procedure TDBLookupCombo.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  CloseUp;
end;

procedure TDBLookupCombo.CMCancelMode(var Message: TCMCancelMode);
begin
  with Message do
    if (Sender <> Self) and (Sender <> FBtnControl) and
      (Sender <> FButton) and (Sender <> FGrid) then CloseUp;
end;

procedure TDBLookupCombo.CMHintShow(var Message: TMessage);
begin
  Message.Result := Integer(FGrid.Visible);
end;

procedure TDBLookupCombo.DropDown;
var
  ItemCount: Integer;
  P: TPoint;
  Y: Integer;
  GridWidth, GridHeight, BorderWidth: Integer;
  SysBorderWidth, SysBorderHeight: Integer;
begin
  if not FGrid.Visible and (Width > 20) then
  begin
    if Assigned(FOnDropDown) then FOnDropDown(Self);
    ItemCount := DropDownCount;
    if ItemCount = 0 then ItemCount := 1;
    SysBorderWidth := GetSystemMetrics(SM_CXBORDER);
    SysBorderHeight := GetSystemMetrics(SM_CYBORDER);
    P := ClientOrigin;
    if NewStyleControls then
    begin
      Dec(P.X, 2 * SysBorderWidth);
      Dec(P.Y, SysBorderHeight);
    end;
    if loRowLines in Options then
      BorderWidth := 1 else
      BorderWidth := 0;
    GridHeight := (FGrid.DefaultRowHeight + BorderWidth) *
      (ItemCount + FGrid.FTitleOffset) + 2;
    FGrid.Height := GridHeight;
    if ItemCount > FGrid.RowCount then
    begin
      ItemCount := FGrid.RowCount;
      GridHeight := (FGrid.DefaultRowHeight + BorderWidth) *
        (ItemCount + FGrid.FTitleOffset) + 4;
    end;
    if NewStyleControls then
      Y := P.Y + ClientHeight + 3 * SysBorderHeight else
      Y := P.Y + Height - 1;
    if (Y + GridHeight) > Screen.Height then
    begin
      Y := P.Y - GridHeight + 1;
      if Y < 0 then
      begin
        if NewStyleControls then
          Y := P.Y + ClientHeight + 3 * SysBorderHeight else
          Y := P.Y + Height - 1;
      end;
    end;
    GridWidth := DropDownWidth;
    if GridWidth = 0 then
    begin
      if NewStyleControls then
        GridWidth := Width + 2 * SysBorderWidth else
        GridWidth := Width - 4;
    end;
    if NewStyleControls then
      SetWindowPos(FGrid.Handle, 0, P.X, Y, GridWidth, GridHeight, SWP_NOACTIVATE) else
      SetWindowPos (FGrid.Handle, 0, P.X + Width - GridWidth, Y, GridWidth, GridHeight, SWP_NOACTIVATE);
    if Length(LookupField) = 0 then
      FGrid.DisplayValue := Text;
    FGrid.Visible := True;
    Windows.SetFocus(Handle);
  end;
end;

procedure TDBLookupCombo.CloseUp;
begin
  FGrid.Visible := False;
end;

procedure TDBLookupCombo.GridClick(Sender: TObject);
begin
  FFieldLink.Edit;
  if (FFieldLink.DataSource = nil) or FFieldLink.Editing then
  begin
    FFieldLink.Modified;
    Text := FGrid.DisplayValue;
  end;
end;

procedure TDBLookupCombo.SetStyle(Value: TDBLookupComboStyle);
begin
  if FStyle <> Value then
    FStyle := Value;
end;

procedure TDBLookupCombo.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if Editable then
    inherited
  else
    NonEditMouseDown(Message);
end;

procedure TDBLookupCombo.WMLButtonUp(var Message: TWMLButtonUp);
begin
  if not Editable then MouseCapture := False;
  inherited;
end;

procedure TDBLookupCombo.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if Editable then
    inherited
  else
    NonEditMouseDown(Message);
end;

procedure TDBLookupCombo.NonEditMouseDown(var Message: TWMLButtonDown);
var
  CtrlState: TControlState;
begin
  SetFocus;
  HideCaret (Handle);

  if FGrid.Visible then CloseUp
  else DropDown;

  MouseCapture := True;
  if csClickEvents in ControlStyle then
  begin
    CtrlState := ControlState;
    Include(CtrlState, csClicked);
    ControlState := CtrlState;
  end;
  with Message do
    MouseDown(mbLeft, KeysToShiftState(Keys), XPos, YPos);
end;

procedure MouseDragToGrid(Ctrl: TControl; Grid: TPopupGrid; X, Y: Integer);
var
  pt, clientPt: TPoint;
begin
  if Grid.Visible then
  begin
    pt.X := X;
    pt.Y := Y;
    pt := Ctrl.ClientToScreen (pt);
    clientPt := Grid.ClientOrigin;
    if (pt.X >= clientPt.X) and (pt.Y >= clientPt.Y) and
       (pt.X <= clientPt.X + Grid.ClientWidth) and
       (pt.Y <= clientPt.Y + Grid.ClientHeight) then
    begin
      Ctrl.Perform(WM_LBUTTONUP, 0, MakeLong (X, Y));
      pt := Grid.ScreenToClient(pt);
      Grid.Perform(WM_LBUTTONDOWN, 0, MakeLong (pt.x, pt.y));
    end;
  end;
end;

procedure TDBLookupCombo.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if (ssLeft in Shift) and not Editable and (GetCapture = Handle) then
    MouseDragToGrid(Self, FGrid, X, Y);
end;

procedure TDBLookupCombo.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if not Editable then HideCaret(Handle);
end;

procedure TDBLookupCombo.CMExit(var Message: TCMExit);
begin
  try
    FFieldLink.UpdateRecord;
  except
    DoSelectAll;
    SetFocus;
    raise;
  end;
  inherited;
  if not Editable then Invalidate;
end;

procedure TDBLookupCombo.CMEnter(var Message: TCMGotFocus);
begin
  if AutoSelect and not (csLButtonDown in ControlState) then DoSelectAll;
  inherited;
  if not Editable then Invalidate;
end;

procedure TDBLookupCombo.DoSelectAll;
begin
  if Editable then SelectAll;
end;

procedure TDBLookupCombo.SetOptions(Value: TDBLookupListOptions);
begin
  FGrid.Options := Value;
end;

function TDBLookupCombo.GetOptions: TDBLookupListOptions;
begin
  Result := FGrid.Options;
end;

procedure TDBLookupCombo.Loaded;
begin
  inherited Loaded;
  DataChange(Self);
end;

{ TLookupList }

constructor TDBLookupList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFieldLink := TFieldDataLink.Create;
  FFieldLink.Control := Self;
  FFieldLink.OnDataChange := DataChange;
  FFieldLink.OnUpdateData := UpdateData;
  FFieldLink.OnActiveChange := FieldLinkActive;
  FTitleOffset := 0;
  FUpdateFields := False;
  FHiliteRow := -1;
  inherited Options := [dgRowSelect];
  FixedCols := 0;
  FixedRows := 0;
  Width := 121;
  Height := 97;
end;

destructor TDBLookupList.Destroy;
begin
  FFieldLink.OnDataChange := nil;
  FFieldLink.Free;
  FFieldLink := nil;
  inherited Destroy;
end;

procedure TDBLookupList.CreateWnd;
begin
  inherited CreateWnd;
  DataChange(Self);
end;

procedure TDBLookupList.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FFieldLink <> nil) and
    (AComponent = DataSource) then
    DataSource := nil;
end;

function TDBLookupList.GetDataSource: TDataSource;
begin
  Result := FFieldLink.DataSource;
end;

procedure TDBLookupList.SetDataSource(Value: TDataSource);
begin
  if (Value <> nil) and ((Value = LookupSource) or ((Value.DataSet <> nil)
    and (Value.DataSet = DataLink.DataSet))) then
    raise EInvalidOperation.Create(SLookupSourceError);
  FFieldLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDBLookupList.GetLookupSource: TDataSource;
begin
  Result := inherited DataSource;
end;

procedure TDBLookupList.NewLayout;
begin
  InitFields(True);
  LayoutChanged;
  FValue := '';
  DataChange(Self);
end;

procedure TDBLookupList.SetLookupSource(Value: TDataSource);
begin
  if (Value <> nil) and ((Value = DataSource) or
    ((Value.DataSet <> nil) and (Value.DataSet = FFieldLink.DataSet))) then
    raise EInvalidOperation.Create(SLookupSourceError);
  if (Value <> nil) and (Value.DataSet <> nil) and
    not (Value.DataSet.InheritsFrom(TTable)) then
    raise EInvalidOperation.Create(SLookupTableError);
  inherited DataSource := Value;
  NewLayout;
end;

procedure TDBLookupList.SetLookupDisplay(const Value: string);
begin
  if Value <> LookupDisplay then
  begin
    FLookupDisplay := Value;
    NewLayout;
  end;
end;

procedure TDBLookupList.SetLookupField(const Value: string);
begin
  if Value <> LookupField then
  begin
    FLookupField := Value;
    NewLayout;
  end;
end;

procedure TDBLookupList.SetValue(const Value: string);
begin
  if DataLink.Active and FFieldLink.Active and
    ((DataSource = LookupSource) or
    (DataSource.DataSet = LookupSource.DataSet)) then
    raise EInvalidOperation.Create(SLookupSourceError);

  if (FValue <> Value) or (Row = FTitleOffset) then
    if DataLink.Active and (FValueFld <> nil) then
    begin
      FValue := Value;
      FHiliteRow := -1;
      DoLookup;
      if FFoundValue and (FValueFld <> FDisplayFld) then
        FDisplayValue := FDisplayFld.AsString
      else if (FValueFld = FDisplayFld) then FDisplayValue := FValue
      else FDisplayValue := '';
    end;
end;

procedure TDBLookupList.SetDisplayValue(const Value: string);
begin
  if (FDisplayValue <> Value) or (Row = FTitleOffset) then
  begin
    FFoundValue := False;
    if DataLink.Active and (FDisplayFld <> nil) then
    begin
      FHiliteRow := -1;
      FFoundValue := False;
      if inherited DataSource.DataSet is TTable then
        with TTable(inherited DataSource.DataSet) do
        begin
          SetKey;
          FDisplayFld.AsString := Value;
          FFoundValue := GotoKey;
        end;
      FDisplayValue := Value;
      if FValueFld = FDisplayFld then FValue := FDisplayValue
      else if not FFoundValue then
      begin
        FDisplayValue := '';
        FValue := '';
      end
      else FValue := FValueFld.AsString;
    end;
  end;
end;

procedure TDBLookupList.DoLookup;
begin
  FFoundValue := False;
  if not HandleAllocated then Exit;
  if Value = '' then Exit;
  if inherited DataSource.DataSet is TTable then
    with TTable(inherited DataSource.DataSet) do
    begin
      if (IndexFieldCount > 0) then
      begin
        if AnsiCompareText(IndexFields[0].FieldName, LookupField) <> 0 then
          raise EInvalidOperation.Create(Format(SLookupIndexError, [LookupField]));
      end;
      if State = dsSetKey then Exit;
      SetKey;
      FValueFld.AsString := Value;
      FFoundValue := GotoKey;
      if not FFoundValue then First;
    end;
end;

function TDBLookupList.GetDataField: string;
begin
  Result := FFieldLink.FieldName;
end;

procedure TDBLookupList.SetDataField(const Value: string);
begin
  FFieldLink.FieldName := Value;
end;

function TDBLookupList.GetReadOnly: Boolean;
begin
  Result := FFieldLink.ReadOnly;
end;

function TDBLookupList.CanEdit: Boolean;
begin
  Result := (FFieldLink.DataSource = nil) or FFieldLink.Editing;
end;

procedure TDBLookupList.SetReadOnly(Value: Boolean);
begin
  FFieldLink.ReadOnly := Value;
end;

procedure TDBLookupList.DataChange(Sender: TObject);
begin
  if (FFieldLink.Field <> nil) and not (csLoading in ComponentState) then
    Value := FFieldLink.Field.AsString else
    Value := '';
end;

procedure TDBLookupList.UpdateData(Sender: TObject);
begin
  if FFieldLink.Field <> nil then
    FFieldLink.Field.AsString := Value;
end;

procedure TDBLookupList.InitFields(ShowError: Boolean);
var
  Pos: Integer;
begin
  FDisplayFld := nil;
  FValueFld := nil;
  if not DataLink.Active or (Length(LookupField) = 0) then Exit;
  with Datalink.DataSet do
  begin
    FValueFld := FindField(LookupField);
    if (FValueFld = nil) and ShowError then
      raise EInvalidOperation.Create(Format(SFieldNotFound, [Self.Name, LookupField]))
    else if FValueFld <> nil then
    begin
      if Length(LookupDisplay) > 0 then
      begin
        Pos := 1;
        FDisplayFld := FindField(ExtractFieldName(LookupDisplay, Pos));
        if (FDisplayFld = nil) and ShowError then
        begin
          Pos := 1;
          raise EInvalidOperation.Create(Format(SFieldNotFound,
            [Self.Name, ExtractFieldName(LookupDisplay, Pos)]));
        end;
      end;
      if FDisplayFld = nil then FDisplayFld := FValueFld;
    end;
  end;
end;

procedure TDBLookupList.DefineFieldMap;
var
  Pos: Integer;
begin
  InitFields(False);
  if FValueFld <> nil then
  begin
    if Length(LookupDisplay) = 0 then
      Datalink.AddMapping (FValueFld.FieldName)
    else begin
      Pos := 1;
      while Pos <= Length(LookupDisplay) do
        Datalink.AddMapping(ExtractFieldName(LookupDisplay, Pos));
    end;
  end;
end;

procedure TDBLookupList.SetColumnAttributes;
var
  I: Integer;
  TotalWidth, BorderWidth: Integer;
begin
  inherited SetColumnAttributes;
  if FieldCount > 0 then
  begin
    BorderWidth := 0;
    if loColLines in FOptions then BorderWidth := 1;
    TotalWidth := 0;
    for I := 0 to ColCount - 2 do
      TotalWidth := TotalWidth + ColWidths[I] + BorderWidth;
    if (ColCount = 1) or (TotalWidth < (ClientWidth - 15)) then
      ColWidths[ColCount-1] := ClientWidth - TotalWidth;
  end;
end;

procedure TDBLookupList.WMSize(var Message: TWMSize);
begin
  inherited;
  SetColumnAttributes;
end;

function TDBLookupList.CanGridAcceptKey(Key: Word; Shift: TShiftState): Boolean;
var
  MyOnKeyDown: TKeyEvent;
begin
  Result := True;
  if Key = VK_INSERT then Result := False
  else if Key in [VK_UP, VK_DOWN, VK_NEXT, VK_RIGHT, VK_LEFT, VK_PRIOR,
    VK_HOME, VK_END] then
  begin
    FFieldLink.Edit;
    if (Key in [VK_UP, VK_DOWN, VK_RIGHT, VK_LEFT]) and not CanEdit then
      Result := False
    else if (inherited DataSource <> nil) and
      (inherited DataSource.State <> dsInactive) then
    begin
      if (FHiliteRow >= 0) and (FHiliteRow <> DataLink.ActiveRecord) then
      begin
        Row := FHiliteRow;
        Datalink.ActiveRecord := FHiliteRow;
      end
      else if (FHiliteRow < 0) then
      begin
        if FFoundValue then
          DoLookup
        else begin
          DataLink.DataSource.DataSet.First;
          Row := FTitleOffset;
          Key := 0;
          MyOnKeyDown := OnKeyDown;
          if Assigned(MyOnKeyDown) then MyOnKeyDown(Self, Key, Shift);
          InvalidateRow (FTitleOffset);
          ListClick;
          Result := False;
        end;
      end;
    end;
  end;
end;

procedure TDBLookupList.KeyDown(var Key: Word; Shift: TShiftState);
begin
  try
    FInCellSelect := True;
    inherited KeyDown (Key, Shift);
  finally
    FInCellSelect := False;
  end;
  if (Key in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR, VK_HOME, VK_END]) and
    CanEdit then ListClick;
end;

procedure TDBLookupList.KeyPress(var Key: Char);
begin
  inherited KeyPress (Key);
  case Key of
    #32..#255:
      DataLink.Edit;
    Char (VK_ESCAPE):
      begin
        FFieldLink.Reset;
        Key := #0;
      end;
  end;
end;

procedure TDBLookupList.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  CellHit: TGridCoord;
  MyOnMouseDown: TMouseEvent;
begin
  if not (csDesigning in ComponentState) and CanFocus and TabStop then
  begin
    SetFocus;
    if ValidParentForm(Self).ActiveControl <> Self then
    begin
      MouseCapture := False;
      Exit;
    end;
  end;
  if ssDouble in Shift then
  begin
    DblClick;
    Exit;
  end;
  if (Button = mbLeft) and (DataLink.DataSource <> nil) and
    (FDisplayFld <> nil) then
  begin
    CellHit := MouseCoord(X, Y);
    if (CellHit.Y >= FTitleOffset) then
    begin
      FFieldLink.Edit;
      FGridState := gsSelecting;
      SetTimer(Handle, 1, 60, nil);
      if (CellHit.Y <> (FHiliteRow + FTitleOffset)) then
      begin
        InvalidateRow(FHiliteRow + FTitleOffset);
        InvalidateRow(CellHit.Y);
      end;
      Row := CellHit.Y;
      Datalink.ActiveRecord := Row - FTitleOffset;
    end;
  end;
  MyOnMouseDown := OnMouseDown;
  if Assigned(MyOnMouseDown) then MyOnMouseDown(Self, Button, Shift, X, Y);
end;

procedure TDBLookupList.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if (FGridState = gsSelecting) and (Row >= FTitleOffset) then
    Datalink.ActiveRecord := Row - FTitleOffset;
end;

procedure TDBLookupList.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  OldState: TGridState;
begin
  OldState := FGridState;
  inherited MouseUp(Button, Shift, X, Y);
  if OldState = gsSelecting then
  begin
    if Row >= FTitleOffset then
      Datalink.ActiveRecord := Row - FTitleOffset;
    ListClick;
  end;
end;

procedure TDBLookupList.ListClick;
begin
  if CanEdit and (FDisplayFld <> nil) then
  begin
    if FFieldLink.Editing then FFieldLink.Modified;
    FDisplayValue := FDisplayFld.AsString;
    if (FValueFld <> FDisplayFld) then
      FValue := FValueFld.AsString
    else FValue := FDisplayValue;
  end;
  if Assigned(FOnListClick) then FOnListClick(Self);
end;

function TDBLookupList.HighlightCell(DataCol, DataRow: Integer;
  const Value: string; AState: TGridDrawState): Boolean;
var
  OldActive: Integer;
begin
  Result := False;
  if not DataLink.Active or (FValueFld = nil) then Exit;
  if CanEdit and ((FGridState = gsSelecting) or FInCellSelect) then
  begin
    if Row = (DataRow + FTitleOffset) then
    begin
      Result := True;
      FHiliteRow := DataRow;
    end;
  end
  else begin
    OldActive := DataLink.ActiveRecord;
    try
      DataLink.ActiveRecord := DataRow;
      if FValue = FValueFld.AsString then
      begin
        Result := True;
        FHiliteRow := DataRow;
      end;
    finally
      DataLink.ActiveRecord := OldActive;
    end;
  end;
end;

procedure TDBLookupList.Paint;
begin
  FHiliteRow := -1;
  inherited Paint;
  if Focused and (FHiliteRow <> -1) then
    Canvas.DrawFocusRect(BoxRect(0, FHiliteRow, MaxInt, FHiliteRow));
end;

procedure TDBLookupList.Scroll(Distance: Integer);
begin
  if FHiliteRow >= 0 then
  begin
    FHiliteRow := FHiliteRow - Distance;
    if FHiliteRow >= VisibleRowCount then FHiliteRow := -1;
  end;
  inherited Scroll(Distance);
end;

procedure TDBLookupList.LinkActive(Value: Boolean);
begin
  inherited LinkActive(Value);
  if DataLink.Active then
  begin
    if not (LookupSource.DataSet.InheritsFrom(TTable)) then
      raise EInvalidOperation.Create(SLookupTableError);
    SetValue('');
    DataChange(Self);
  end;
end;

procedure TDBLookupList.FieldLinkActive(Sender: TObject);
begin
  if FFieldLink.Active and DataLink.Active then DataChange(Self);
end;

procedure TDBLookupList.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if FHiliteRow <> -1 then InvalidateRow(FHiliteRow);
end;

procedure TDBLookupList.CMExit(var Message: TCMExit);
begin
  try
    FFieldLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  inherited;
  if FHiliteRow <> -1 then InvalidateRow(FHiliteRow);
end;

procedure TDBLookupList.SetOptions(Value: TDBLookupListOptions);
var
  NewGridOptions: TDBGridOptions;
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    FTitleOffset := 0;
    NewGridOptions := [dgRowSelect];
    if loColLines in Value then
      NewGridOptions := NewGridOptions + [dgColLines];
    if loRowLines in Value then
      NewGridOptions := NewGridOptions + [dgRowLines];
    if loTitles in Value then
    begin
      FTitleOffset := 1;
      NewGridOptions := NewGridOptions + [dgTitles];
    end;
    inherited Options := NewGridOptions;
  end;
end;

procedure TDBLookupList.Loaded;
begin
  inherited Loaded;
  DataChange(Self);
end;

{ TPopupGrid }

constructor TPopupGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAcquireFocus := False;
  TabStop := False;
end;

procedure TPopupGrid.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WindowClass.Style := CS_SAVEBITS;
end;

procedure TPopupGrid.CreateWnd;
begin
  inherited CreateWnd;
  if not (csDesigning in ComponentState) then
    Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
  FCombo.DataChange(Self);
end;

procedure TPopupGrid.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;
  FCombo.CloseUp;
end;

function TPopupGrid.CanEdit: Boolean;
begin
  Result := (FCombo.FFieldLink.DataSource = nil) or FCombo.FFieldLink.Editing;
end;

procedure TPopupGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FCombo.FFieldLink.Edit;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TPopupGrid.LinkActive(Value: Boolean);
begin
  if Parent = nil then Exit;
  inherited LinkActive (Value);
  if DataLink.Active then
  begin
    if FValueFld = nil then InitFields(True);
    SetValue ('');
    FCombo.DataChange(Self);
  end;
end;

procedure TPopupGrid.CMHintShow(var Message: TMessage);
begin
  Message.Result := 1;
end;

{ TComboButton }

procedure TComboButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  with TDBLookupCombo (Parent.Parent) do
    if not FGrid.Visible then
      if (Handle <> GetFocus) and CanFocus then
      begin
        SetFocus;
        if GetFocus <> Handle then Exit;
      end;
  inherited MouseDown (Button, Shift, X, Y);
  with TDBLookupCombo (Parent.Parent) do
    if FGrid.Visible then CloseUp
    else DropDown;
end;

procedure TComboButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove (Shift, X, Y);
  if (ssLeft in Shift) and (GetCapture = Parent.Handle) then
    MouseDragToGrid(Self, TDBLookupCombo(Parent.Parent).FGrid, X, Y);
end;

end.
