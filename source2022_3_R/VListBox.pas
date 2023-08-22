{
Virtual List Box - Delphi VCL-Compatible Component
Copyright © 1995, 2006 Optimax Corporation.
Derived from a Turbo Power demo unit.
}

unit VListBox;

interface

uses
  SysUtils,
  Classes,
  WinTypes,
  WinProcs,
  Messages,
  Menus,
  Graphics,
  Controls,
  StdCtrls,
  Forms,
  Dialogs;

const
  VScrollingAccel1Pixels = 60;
  VScrollingAccel2Pixels = 120;
  VScrollingAccel1Rows   = 5;
  VScrollingAccel2Rows   = 15;


type
  TLBColorIndex =
    (
      clbWindow,
      clbText,
      clbHighlight,
      clbHighText,
      clbDisabled,
      clbHorizGrid,
      clbVertGrid,
      clbHeader,
      clbHeaderText
    );

  TOnColorChangeEvent = procedure(AnIndex: TLBColorIndex;
    AColor: TColor) of object;

  TBaseLbColors = class(TPersistent)
    private
      FColor: array[TLBColorIndex] of TColor;
      FOnChange: TOnColorChangeEvent;
    protected
      procedure SetColor(AnIndex: Integer; AColor: TColor); virtual;
      function GetColor(AnIndex: Integer): TColor; virtual;
    public
      constructor Create;
    public
      property Window: TColor index Ord(clbWindow)
        read GetColor write SetColor;
      property Text: TColor index Ord(clbText)
        read GetColor write SetColor;
      property Highlight: TColor index Ord(clbHighlight)
        read GetColor write SetColor;
      property HighText: TColor index Ord(clbHighText)
        read GetColor write SetColor;
      property Disabled: TColor index Ord(clbDisabled)
        read GetColor write SetColor;
      property GridHoriz: TColor index Ord(clbHorizGrid)
        read GetColor write SetColor;
      property GridVert: TColor index Ord(clbVertGrid)
        read GetColor write SetColor;
      property Header: TColor index Ord(clbHeader)
        read GetColor write SetColor;
      property HeaderText: TColor index Ord(clbHeaderText)
        read GetColor write SetColor;
    public
      property OnChange: TOnColorChangeEvent
        read FOnChange write FOnChange;
    end;


  TLbColors = class(TBaseLbColors)
    published
      property Window default clWindow;
      property Text default clWindowText;
      property Highlight default clHighlight;
      property HighText default clHighlightText;
      property Disabled default clGrayText;
      property GridHoriz default clBtnFace;
      property GridVert default clBtnFace;
      property Header default clBtnFace;
      property HeaderText default clBlack;
    end;


  TZeroOrOne = 0..1;

  TVirtListBoxOption =
    (
    oDisableHScroll, oDoNotEraseBkgnd, oHideFocusRect, oHideHeader,
    oHideHGrid, oHideVGrid, oHeaderCursor, oHideSelection,
    oDoNotHighlightSelected, oDisableDragSplitter, oHeaderButton
    );
  TVirtListBoxOptions = set of TVirtListBoxOption;

  TSelectionChange = (selNone, selSelect, selDeselect, selToggle, selSelectAll, selDeselectAll);

  TOnChangeEvent =
    procedure(Sender: TObject; OldIndex: Integer) of object;
  TIsSelectedEvent = procedure(Sender: TObject; Index: Integer;
    var Selected : Boolean) of object;
  TSelectEvent =  procedure(Sender: TObject; Index: Integer;
    Selected: Boolean) of object;
  TQuerySplitterEvent = function (AnIndex: Integer): Integer of object;
  TTopIndexChangedEvent = procedure(Sender: TObject; NewTopIndex: LongInt) of object;
  TQueryItemEvent = function(RecNum, ColNum: Integer): AnsiString of object;
  TQuerySelectionEvent = procedure(RecNum: Integer; var Selected: Boolean) of object;
  TQueryHeaderEvent = function(ColNum: Integer): AnsiString of object;
  TQueryFieldAttrEvent = procedure(RecNum, FieldNum: Integer;
    var Align: TAlignment; Canvas: TCanvas) of object;
  TSelectionChangeEvent = procedure(RecNum: Integer; SelChange: TSelectionChange) of object;
  TResizeColumnEvent = procedure(SplitNum: Integer;
    NewPos: Integer) of object;
  TDrawItemEvent = procedure(RecNum, FieldNum: Integer;
    Rect: TRect; State: TOwnerDrawState) of object;
  TBeforeAfterDrawItemEvent = procedure(RecNum, FieldNum: Integer;
    Rect: TRect; Align: TAlignment; State: TOwnerDrawState) of object;
  TRowPaintEvent = procedure(RecNum: Integer; Rect: TRect;
    State: TOwnerDrawState; Canvas: TCanvas) of object;
  TControlPaintEvent = procedure(SenderCanvas: TCanvas) of object;
  TMouseWheelEvent = procedure(Sender : TObject; Shift : TShiftState;
    Delta, XPos, YPos : Word) of object;
  THeaderClickEvent = procedure(Sender: TObject; Col: Integer) of object;


  TBaseVirtListBox = class(TCustomControl)
  protected
    FColumnCount: Integer;
    FRecCount: Integer;
    FItemIndex: Integer;
    FPrevItemIndex: Integer;
    FBlockBeginIndex: Integer;
    FSelCount: Integer;
    FTopIndex: Integer;
    FBorderStyle: TBorderStyle;
    FGridLineWidth: Integer;
    FScrollBars: TScrollStyle;
    FColors: TLBColors;
    FOldFontChange: TNotifyEvent;
    FFontHeader: TFont;
    FOptions: TVirtListBoxOptions;
    FOWnerDrawHeader: Boolean;
    FOwnerDraw: Boolean;
    FMultiSelect: Boolean;
    FMouseDragging: Boolean;
    FDefColWidth: Integer;
    FRowHeight: Integer;  {height of one row}
    FHeaderHeight: Integer; {height of the header row}
    FHalfRow: TZeroOrOne; {number of rows partially visible at the bottom}
    FVisibleRows: Integer; {number of full rows visible in window}
    FVSHigh: Integer; {vertical scroll limit}
    FHSHigh: Integer; {horizontal scroll limit}
    FHDelta: Integer; {horizontal scroll delta = leftmost field index}
    FHaveHorzScroll: Boolean; {do we have a horizontal scroll bar?}
    FHaveVertScroll: Boolean; {do we have a vertical scroll bar?}
    FHorizDivisor,
    FVertDivisor: Integer; {divisor for scroll bar position calculation}
    FCapture: Boolean; {if True, we have the capture}
    FOnChange: TOnChangeEvent;
    FOnTopIndexChanged : TTopIndexChangedEvent;
    FOnIsSelected: TIsSelectedEvent;
    FOnSelect: TSelectEvent;
    FQuerySplitter: TQuerySplitterEvent;
    FQueryItem: TQueryItemEvent;
    FQueryHeader: TQueryHeaderEvent;
    FQueryFieldAttr: TQueryFieldAttrEvent;
    FQuerySelection: TQuerySelectionEvent;
    FResizeColumn: TResizeColumnEvent;
    FDrawItem: TDrawItemEvent;
    FLeftOffset: Integer; {distance between v-splitter and text}
    FWheelDelta: Integer;
    FOnSelectionChange: TSelectionChangeEvent;
    FOnBeforePaint,
    FOnAfterPaint: TControlPaintEvent;
    FOnAfterPaintRow: TRowPaintEvent;
    FOnBeforePaintRow: TRowPaintEvent;
    FOnHeaderClick: THeaderClickEvent;
    FOnAfterDrawItem: TBeforeAfterDrawItemEvent;
    FOnBeforeDrawItem: TBeforeAfterDrawItemEvent;
    FOnMouseWheel: TMouseWheelEvent;
  protected
    class function ScaleDown(ANumber, ADivisor : Integer): Integer;
    class function ScaleUp(ANumber, ADivisor: Integer): Integer;
    procedure SetLeftOffset(const Value: Integer);
    procedure SetMultiSelect(Value : Boolean); virtual;
    procedure ColorsChange(AnIndex: TLBColorIndex; AColor: TColor);
    procedure FontChange(Sender: TObject);
    function HaveHScroll: Boolean;
    function HaveVScroll: Boolean;
    procedure InitScrollInfo;
    procedure SetVScrollRange;
    procedure SetVScrollPos;
    procedure SetHScrollRange;
    procedure SetHScrollPos;
    procedure ScrollRight;
    procedure ScrollLeft;
    procedure Redraw(PrevIndex: Integer);
    procedure DrawSelection(PrevSel: Integer);
    procedure DrawLeftAt(R: TRect; X, NextCol: Integer; const S: AnsiString);
    procedure DrawRightAt(R: TRect; X, NextCol: Integer; const S: AnsiString);

    procedure DrawLeftAt2(R: TRect; X, YOffset: Integer; const S: AnsiString);
    procedure DrawRightAt2(R: TRect; X, YOffset: Integer; const S: AnsiString);

    procedure SetDefColWidth(const Value: Integer);
    procedure DrawHeaderTrailer;
    function QueryDragHandle(X: Integer): Integer;
    function IsInHeader(Y: Integer): Boolean;
    procedure SetNumRows(ANumber: Integer);
    procedure SetNumCols(ANumber: Integer); virtual;
    function GetNumCols: Integer; virtual;
    procedure SetLeftColIndex(const Value: Integer);
    function GetItemIndex: Integer;
    procedure SetItemIndex(Index: Integer);
    procedure SetTopIndex(Index: Integer);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetScrollBars(Value: TScrollStyle);
    procedure SetRowHeight(ANumber: Integer);
    procedure SetHeaderHeight(ANumber: Integer);
    procedure SetFontHeader(AFont: TFont);
    procedure SetOptions(Value: TVirtListBoxOptions);
    function EffectiveHeaderHeight: Integer;
    function GetItemRect(AnIndex: Integer): TRect;
    function GetHeaderRect: TRect;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Paint; override;
    procedure Click; override;
    procedure DrawHeader;
    procedure DrawHeaderSection(AIndex: Integer; Depressed: Boolean = False);
    procedure DrawItem(AnIndex: Integer);
    procedure CalcRows;
    procedure UpdateRows;
    function QuerySplitter(AnIndex: Integer): Integer; virtual;
    function QueryItem(RecNum, FldNum: Integer): AnsiString; virtual;
    procedure DoQuerySelection(RecNum: Integer; var Selected: Boolean); virtual;
    function QueryHeader(FldNum: Integer): AnsiString; virtual;
    procedure DoQueryField(RecNum, FieldNum: Integer;
      Selected: Boolean; var Align: TAlignment); virtual;
    procedure DoOnChange(Index: Integer); virtual;
    procedure DoOnTopIndexChanged(NewTopIndex : LongInt); virtual;
    procedure DoHeaderClick(Col: Integer); virtual;
    procedure DoResizeColumn(SplitNum: Integer; NewPos: Integer); virtual;
    procedure DoOnMouseWheel(Shift : TShiftState;
      Delta, XPos, YPos: SmallInt); virtual;
    procedure DoSelectionChange(RecNum: Integer; SelChange: TSelectionChange); virtual;
  protected
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SetCursor;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure WMEraseBkgnd(var msg: TWMEraseBkgnd); message WM_EraseBkgnd;
    procedure WMLButtonDown(var Msg: TWMMouse); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Msg: TWMMouse); message WM_LBUTTONUP;
    procedure WMLButtonDblClk(var Msg: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMKeyDown(var Msg: TWMKeyDown); message WM_KeyDown;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMCreate(var Msg: TWMCreate); message WM_Create;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMMouseWheel(var Msg : TMessage); message WM_MOUSEWHEEL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ClientToRow(Y: Integer): Integer;
    function ClientToCol(X: Integer): Integer;
    procedure ClientToGrid(APoint: TPoint; var Col, Row: Integer);
    function GridRect(Col, Row: Integer): TRect;
    function ClientToGridRect(APoint: TPoint): TRect;
    procedure Clear;
    procedure InvalidateRows;
    function IsHeaderVisible: Boolean;
    procedure DeselectAll;
    procedure SelectAll;
    procedure BlockSelect(IndexFrom, IndexTo: Integer; Select: TSelectionChange);
    function DefaultQueryItem(RecNum, FldNum: Integer): AnsiString;
    function DefaultQueryHeader(FldNum: Integer): AnsiString;
    function DefaultQuerySplitter(AnIndex: Integer): Integer;
  public
    property BorderStyle: TBorderStyle
      read FBorderStyle write SetBorderStyle default bsSingle;
    property ScrollBars: TScrollStyle
      read FScrollBars write SetScrollBars;
    property RecCount: Integer read FRecCount write SetNumRows;
    property NumRows: Integer read FRecCount write SetNumRows;
    property NumItems: Integer read FRecCount write SetNumRows;
    property NumCols: Integer read GetNumCols write SetNumCols;
    property ColCOunt: Integer read GetNumCols write SetNumCols;
    property ItemRect[AnIndex: Integer]: TRect read GetItemRect;
    property HeaderRect: TRect read GetHeaderRect;
    property RowHeight: Integer read FRowHeight write SetRowHeight default 15;
    property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight default 18;
    property Colors: TLBColors read FColors write FColors;
    property Options: TVirtListBoxOptions read FOptions write SetOptions default[oHeaderButton];
    property FontHeader: TFont read FFontHeader write SetFontHeader;
    property TopIndex: Integer read FTopIndex write SetTopIndex;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property SelCount: Integer read FSelCount;
    property LeftColIndex: Integer read FHDelta write SetLeftColIndex; {!!!}
    property OwnerDrawHeader: Boolean read FOwnerDrawHeader write FOwnerDrawHeader;
    property OwnerDraw: Boolean read FOwnerDraw write FOwnerDraw;
    property OnBeforeDrawItem: TBeforeAfterDrawItemEvent
      read FOnBeforeDrawItem write FOnBeforeDrawItem;
    property OnAfterDrawItem: TBeforeAfterDrawItemEvent
      read FOnAfterDrawItem write FOnAfterDrawItem;
    property OnDrawItem: TDrawItemEvent
      read FDrawItem write FDrawItem;
    property DefColWidth: Integer
      read FDefColWidth write SetDefColWidth default 90;
    property LeftOffset: Integer
      read FLeftOffset write SetLeftOffset default 5;
    property Canvas;
    property OnChange: TOnChangeEvent
      read FOnChange write FOnChange;
    property OnSelectionChange: TSelectionChangeEvent
      read FOnSelectionChange write FOnSelectionChange;
    property OnTopIndexChanged: TTopIndexChangedEvent
      read FOnTopIndexChanged write FOnTopiNdexChanged;
    property OnQuerySplitter: TQuerySplitterEvent
      read FQuerySplitter write FQuerySplitter;
    property OnQueryItem: TQueryItemEvent
      read FQueryItem write FQueryItem;
    property OnQuerySelection: TQuerySelectionEvent
      read FQuerySelection write FQuerySelection;
    property OnQueryHeader: TQueryHeaderEvent
      read FQueryHeader write FQueryHeader;
    property OnQueryField : TQueryFieldAttrEvent
      read FQueryFieldAttr write FQueryFieldAttr;
    property OnResizeColumn: TResizeColumnEvent
      read FResizeColumn write FResizeColumn;
    property OnAfterPaintRow: TRowPaintEvent
      read FOnAfterPaintRow write FOnAFterPAintRow;
    property OnBeforePaintRow: TRowPaintEvent
      read FOnBeforePaintRow write FOnBeforePAintRow;
    property OnAfterPaint: TControlPaintEvent
      read FOnAfterPaint write FOnAFterPAint;
    property OnBeforePaint: TControlPaintEvent
      read FOnBeforePaint write FOnBeforePAint;
    property OnHeaderClick: THeaderClickEvent
      read FOnHeaderClick write FOnHeaderClick;
    property WheelDelta: Integer
      read FWheelDelta write FWheelDelta default 3;
    property MultiSelect: Boolean
      read FMultiSelect write FMultiSelect;
    property OnMouseWheel : TMouseWheelEvent
      read FOnMouseWheel write FOnMouseWheel;
  end;


  TVirtListBox = class(TBaseVirtListBox)
    published
      property Align;
      property BorderStyle;
      property Colors;
      property Ctl3D;
      property Anchors;
      property DefColWidth;
      property DragCursor;
      property DragMode;
      property Enabled;
      property Font;
      property FontHeader;
      property ParentColor;
      property ParentCtl3D;
      property ParentFont;
      property ParentShowHint;
      property PopupMenu;
      property ScrollBars;
      property ShowHint;
      property TabOrder;
      property TabStop;
      property Visible;
      property Options;
      property OwnerDrawHeader;
      property OwnerDraw;
      property MultiSelect;
      property LeftOffset;
      property OnClick;
      property OnHeaderClick;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDrag;
      property OnEnter;
      property OnExit;
      property OnKeyDown;
      property OnKeyPress;
      property OnKeyUp;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
      property OnMouseWheel;
      property NumRows;
      property NumCols;
      property HeaderHeight;
      property RowHeight;
      property WheelDelta;
      property OnBeforeDrawItem;
      property OnDrawItem;
      property OnAfterDrawItem;
      property OnChange;
      property OnTopIndexChanged;
      property OnQuerySplitter;
      property OnQueryField;
      property OnQueryItem;
      property OnQueryHeader;
      property OnResizeColumn;
      property OnAfterPaintRow;
      property OnBeforePaintRow;
      property OnAfterPaint;
      property OnBeforePaint;
      property OnSelectionChange;
      property OnQuerySelection;
    end;




  TVirtListBoxEx = class(TVirtListBox)
    protected
      FColumns: TStringList;
    protected
      procedure SetColumns(const Value: TStrings);
      function GetColumns: TStrings;
      procedure OnChangeColumns(Sender: TObject);
      function GetNumCols: Integer; override;
      function GetSplitter(AnIndex: Integer): Integer;
      procedure SetSplitter(AnIndex: Integer; const Value: Integer);
      function QuerySplitter(AnIndex: Integer): Integer; override;
      procedure DoResizeColumn(SplitNum: Integer; NewPos: Integer); override;
      procedure Loaded; override;
      procedure FixColumnWidths;
      function GetColumnWidth(Index: Integer): Integer;
      procedure SetColumnWidth(Index: Integer; const Value: Integer);
    public
      constructor Create(AnOwner: TComponent); override;
      destructor Destroy; override;
      function QueryHeader(FldNum: Integer): AnsiString; override;
      property Splitter[AnIndex: Integer]: Integer read GetSplitter write SetSplitter;
      property ColumnWidth[AnIndex: Integer]: Integer read GetColumnWidth write SetColumnWidth;
    published
      property Columns: TStrings read GetColumns write SetColumns;
      property NumCols: Integer read GetNumCols;
    end;


  procedure Register;

implementation

const
  HDR_VMARGIN = 4;
  HDR_HMARGIN = 5;


procedure Register;
begin
  RegisterComponents('Optimax', [TVirtListBox, TVirtListBoxEx]);
end;


function Max(I1, I2: Integer): Integer;
begin
  if I1 >= I2 then
    Result := I1
  else
    Result := I2;
end;

function Min(I1, I2: Integer): Integer;
begin
  if I1 <= I2 then
    Result := I1
  else
    Result := I2;
end;



function GetShiftState: TShiftState;
begin
  Result := KeyDataToShiftState(GetAsyncKeyState(VK_SHIFT)) +
    KeyDataToShiftState(GetAsyncKeyState(VK_CONTROL));
end;



procedure DrawVertLine(Canvas: TCanvas; X, Y: Integer);
begin
  Canvas.MoveTo(X,0);
  Canvas.LineTo(X,Y);
end;


procedure DrawHorizLine(Canvas: TCanvas; X, Y: Integer);
begin
  Canvas.Pen.Color := clBlack; {!!!}
  Canvas.MoveTo(0,Y);
  Canvas.LineTo(X,Y);
end;



procedure DrawTopLeft(Canvas: TCanvas; R: TRect; Color: TColor);
begin
  Canvas.Pen.Color := Color;
  Canvas.MoveTo(R.Left,R.Bottom);
  Canvas.LineTo(R.Left,R.Top);
  Canvas.MoveTo(R.Left,R.Top);
  Canvas.LineTo(R.Right-1,R.Top);
end;


procedure DrawBotRight(Canvas: TCanvas; R: TRect; Color: TColor);
begin
  Canvas.Pen.Color := Color;
  Canvas.MoveTo(R.Right-1,R.Top);
  Canvas.LineTo(R.Right-1,R.Bottom);
  Canvas.MoveTo(R.Right-1,R.Bottom);
  Canvas.LineTo(R.Left,R.Bottom);
end;





{

}

constructor TBaseLBColors.Create;
  begin
    FColor[clbWindow] := clWindow;
    FColor[clbText] := clWindowText;
    FColor[clbHighlight] := clHighlight;
    FColor[clbHighText] := clHighlightText;
    FColor[clbDisabled] := clGrayText;
    FColor[clbHorizGrid] := clBtnFace;
    FColor[clbVertGrid] := clBtnFace;
    FColor[clbHeader] := clBtnFace;
    FColor[clbHeaderText] := clBlack;
  end;


procedure TBaseLbColors.SetColor;
  begin
    if FColor[TLbColorIndex(AnIndex)] = AColor then
      Exit;
    FColor[TLbColorIndex(AnIndex)] := AColor;
    if Assigned(FOnChange) then
      FOnChange(TLbColorIndex(AnIndex),AColor);
  end;


function TBaseLbColors.GetColor;
  begin
    Result := FColor[TLbColorIndex(AnIndex)];
  end;



class function TBaseVirtListBox.ScaleDown;
  begin
    ScaleDown := ANumber div ADivisor;
  end;


class function TBaseVirtListBox.ScaleUp;
  begin
    ScaleUp := ANumber * ADivisor;
  end;





constructor TBaseVirtListBox.Create(AOwner: TComponent);
  begin
    inherited Create(AOwner);
    ControlStyle := [csCaptureMouse, csFramed, csOpaque, csDoubleClicks];
    FColors := TLBColors.Create;
    FColors.OnChange := ColorsChange;
    FOldFontChange := Font.OnChange;
    Font.OnChange := FontChange;
    FFontHeader := TFont.Create;
    FFontHeader.OnChange := FontChange;
    FLeftOffset := 5;
    FGridLineWidth := 1;
    FScrollBars := ssBoth;
    FBorderStyle := bsSingle;
    FRowHeight := 15; // Abs(Font.Height) + 2; {!!!}
    FWheelDelta := 3;
    FHeaderHeight := 18; // Abs(FontHeader.Height) + HDR_VMARGIN;
    FColumnCount := 0;
    FHalfRow := 1;
    FDefColWidth := 90;
    Color := clWindow;
    ParentColor := False;
    TabStop := True;
    SetBounds(Left, Top,  200, 100);
    ItemIndex := -1;
    FPrevItemIndex := -1;
    FBlockBeginIndex := 0;
    FOptions := [oHeaderButton]; 
  end;


destructor TBaseVirtListBox.Destroy;
  begin
    FFontHeader.Free;
    FColors.Free;
    inherited Destroy;
  end;


procedure TBaseVirtListBox.ColorsChange;
  begin
    if AnIndex = clbText then
      if Font.Color <> AColor then
        Font.Color := AColor;
    Invalidate;
  end;


procedure TBaseVirtListBox.FontChange;
  begin
    try
      FColors.Text := Font.Color;
      if Assigned(FOldFontChange) then
        FOldFontChange(Sender);
    except
    end;
    UpdateRows;
  end;


procedure TBaseVirtListBox.SetBorderStyle;
  begin
    if FBorderStyle = Value then
      Exit;
    FBorderStyle := Value;
    RecreateWnd;
  end;


procedure TBaseVirtListBox.SetNumRows(ANumber: Integer);
  begin
    if ANumber < 0 then
      ANumber := MaxInt;
    FRecCount := ANumber;
    if FRecCount <= FItemIndex then
      ItemIndex := FRecCount - 1;
    SetVScrollRange;
    if FRecCount < FTopIndex then
      TopIndex := FRecCount
    else begin
      SetVScrollPos;
      InvalidateRows;
    end;
  end;


function TBaseVirtListBox.GetNumCols: Integer;
begin
  Result := FColumnCount;
end;


procedure TBaseVirtListBox.SetNumCols(ANumber: Integer);
  begin
    if ANumber = FColumnCount then
      Exit;
    LeftColIndex := 0;
    if ANumber < 0 then
      ANumber := MaxInt
    else if ANumber = 0 then
      ANumber := 1;
    FColumnCount := ANumber;
    SetHScrollRange;
    SetHScrollPos;
    Invalidate;
  end;


procedure TBaseVirtListBox.SetOptions;
  begin
    if Value <> FOptions then begin
      FOptions := Value;
      UpdateRows;
      Invalidate;
    end;
  end;


procedure TBaseVirtListBox.SetRowHeight(ANumber: Integer);
  begin
    if FRowHeight <> ANumber then begin
      FRowHeight := ANumber;
      UpdateRows;
    end;
  end;


procedure TBaseVirtListBox.SetHeaderHeight(ANumber: Integer);
begin
  if FHeaderHeight <> ANumber then begin
    FHeaderHeight := ANumber;
    UpdateRows;
  end;
end;



procedure TBaseVirtListBox.SetFontHeader(AFont: TFont);
  begin
    FFontHeader.Assign(AFont);
    UpdateRows;
  end;


procedure TBaseVirtListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    Style := Style or WS_TABSTOP;
    if FBorderStyle = bsSingle then Style := Style or WS_BORDER;
    if FScrollBars in [ssVertical, ssBoth]
      then Style := Style or WS_VSCROLL;
    if FScrollBars in [ssHorizontal, ssBoth]
      then Style := Style or WS_HSCROLL;
    WindowClass.style := CS_DBLCLKS;
  end;
end;


procedure TBaseVirtListBox.SetScrollBars(Value: TScrollStyle);
begin
  if FScrollBars = Value then
    Exit;
  FScrollBars := Value;
  RecreateWnd;
end;


function TBaseVirtListBox.HaveHScroll;
begin
  Result := (FScrollBars in [ssHorizontal, ssBoth])
    and not (oDisableHScroll in Options);
end;


function TBaseVirtListBox.HaveVScroll;
begin
  Result := (FScrollBars in [ssVertical, ssBoth]);
end;


procedure TBaseVirtListBox.SetVScrollRange;
var
  ItemRange : LongInt;
begin
  (*
  FVertDivisor := 1;
  if FRecCount < FVisibleRows then
    FVSHigh := 0
  else
    FVSHigh := FrecCount;
  if HaveVScroll then
    SetScrollRange(Handle, sb_Vert, 0, Pred(FVSHigh), False);
  *)
  ItemRange := NumRows;
  FVertDivisor := 1;
  if ItemRange < FVisibleRows then
    FVSHigh := 1
  else if ItemRange <= High(SmallInt) then
    FVSHigh := ItemRange
  else begin
    FVertDivisor := 2*(ItemRange div 32768);
    FVSHigh := ItemRange div FVertDivisor;
  end;
  if FHaveVertScroll then
    if not ((NumRows > FVisibleRows)
    or (csDesigning in ComponentState)) then
      FVSHigh := 0
    else
  else
    FVSHigh := 0;
  SetVScrollPos;
end;


procedure TBaseVirtListBox.SetVScrollPos;
var
  SI : TScrollInfo;
begin
  if not HandleAllocated then
    Exit;
  with SI do begin
    cbSize := SizeOf(SI);
    fMask := SIF_RANGE or SIF_PAGE or SIF_POS;
    nMin := 0;
    nMax := Pred(FVSHigh);
    nPage := FVisibleRows;
    nPos := ScaleDown(FTopIndex, FVertDivisor);
    nTrackPos := nPos;
  end;
  SetScrollInfo(Handle, SB_VERT, SI, True);
end;


procedure TBaseVirtListBox.SetHScrollRange;
begin
  FHorizDivisor := 1;
  if NumCols <= 1 then
    FHSHigh := 0
  else
    FHSHigh := Pred(NumCols);
  if HaveHScroll then
    SetScrollRange(Handle, sb_Horz, 0, FHSHigh, False);
end;


procedure TBaseVirtListBox.SetHScrollPos;
begin
  if HaveHScroll then
    SetScrollPos(Handle, sb_Horz,
      ScaleDown(FHDelta,FHorizDivisor), True);
end;


procedure TBaseVirtListBox.WMSetFocus;
begin
  inherited;
  DrawItem(ItemIndex);
  // InvalidateRows;
end;


procedure TBaseVirtListBox.WMKillFocus;
begin
  inherited;
  if not (csDestroying in ComponentState) and (ItemIndex < RecCount) then
    DrawItem(ItemIndex);
  // InvalidateRows;
end;


procedure TBaseVirtListBox.WMSetCursor(var Msg: TWMSetCursor);
var
  P: TPoint;
  I: Integer;
begin
  if not FCapture then begin
    GetCursorPos(P);
    P := ScreenToClient(P);
    I := QueryDragHandle(P.X);
    if I >= 0 then begin
      if not (oDisableDragSplitter in Options) then
        Cursor := crHSplit
      else
        Cursor := crDefault;
    end else if IsInHeader(P.Y)
    and (oHeaderCursor in FOptions) then
      Cursor := crHandPoint
    else
      Cursor := crDefault;
  end;
  inherited;
end;


procedure TBaseVirtListBox.WMSize(var Msg: TWMSize);
begin
  inherited;
  UpdateRows;
end;


procedure TBaseVirtListBox.Paint;
var
  ClipRect,
  R: TRect;
  F: TRect;
  Offset,
  X: Integer;


  procedure DrawVertLine(Left: Integer);
  begin
    Canvas.MoveTo(Left,EffectiveHeaderHeight);
    Canvas.LineTo(Left,ClientHeight);
  end;

  procedure DrawVerticalGrid;
  var
    I: Integer;
  begin
    {Draw Vertical Grid}
    if not (oHideVGrid in Options) then
      Canvas.Pen.Color := Colors.GridVert
    else
      Canvas.Pen.Color := Colors.Window;
    if FHDelta > 0 then
      Offset := QuerySplitter(Pred(FHDelta))
    else
      Offset := 0;
    for I := FHDelta to Pred(NumCols) do begin ///Succ(FHDelta) NumCols
      X := QuerySplitter(I) - Offset - 1;
      if X > ClientWidth then
        Break;
      DrawVertLine(X);
    end;
  end;

  procedure DrawItems;
  var
    LastRow,
    I: Integer;
  begin
    {display the items}
    Canvas.Font := Self.Font;
    Canvas.Brush.Color := Colors.Window;
    LastRow := Pred(FVisibleRows+FHalfRow);
    if (FTopIndex + LastRow) >= FRecCount then
      LastRow := FRecCount - FTopIndex - 1;
    for I := 0 to LastRow do
      DrawItem(FTopIndex+i);
  end;

  procedure EraseRemaining;
  {Erase the remainder of the background}
    {Determine the position of the last item}
  var
    X0, X1,
    I: Integer;
  begin
    Canvas.Font := Self.Font;
    Canvas.Brush.Color := Colors.Window;
    X0 := -1;
    if FRecCount = 0 then begin
      R := Rect(-1,EffectiveHeaderHeight,ClientWidth,EffectiveHeaderHeight);
    end else begin
      R := ItemRect[Pred(FRecCount)];
      if R.Bottom >= ClientHeight then
        Exit;
    end;
    //if (oHideHGrid in Options) then
    //  Dec(R.Bottom);

    X := 0; /// QuerySplitter(0);
    if FHDelta > 0 then
      Offset := QuerySplitter(Pred(FHDelta)); ///-QuerySplitter(0);
    for I := FHDelta to Pred(NumCols) do begin //Succ(FHDelta) NumCols
      X1 := QuerySplitter(I) - Offset - 1;
      SetRect(F,Succ(X0),R.Bottom,X1,ClientHeight);
      Canvas.FillRect(F);
      X0 := X1;
      if X0 > ClientWidth then
        Break;
    end; {for}

    if X0 < ClientWidth then begin
      SetRect(F,Succ(X0),R.Bottom,
        ClientWidth,ClientHeight);
      Canvas.FillRect(F);
    end;
  end; {EraseRemaining}

begin {Paint}
  if Assigned(FOnBeforePaint) then
    FOnBeforePaint(Canvas);
  ClipRect := Canvas.ClipRect;
  if IsHeaderVisible and (ClipRect.Top <= FHeaderHeight) then
    DrawHeader;
  DrawItems;
  EraseRemaining;
  DrawVerticalGrid;
  if Assigned(FOnAfterPaint) then
    FOnAfterPaint(Canvas);
end; {Paint}



procedure TBaseVirtListBox.DrawLeftAt(R: TRect;
X, NextCol: Integer; const S: AnsiString);
{-Draw S at col in the current row left justified within R}
var
  Y: Integer;
begin
  R.Left := X;
  /// if not (oHideVGrid in Options) then
    /// Inc(Fr.Left);
  R.Right := nextCol;
  SetTextAlign(Canvas.Handle,ta_Left or ta_Top);
  {draw the string}
  Y := (((R.Bottom - R.Top) - Abs(Canvas.Font.Height)) div 2) + R.Top;
  ExtTextOut(Canvas.Handle,X+FLeftOffset,Y,
    eto_Clipped+eto_Opaque,@R,PChar(S),Length(S),nil);
end;


procedure TBaseVirtListBox.DrawRightAt(R: TRect;
X, NextCol: Integer; const S: AnsiString);
{-Draw S at col in the current row right justified within R}
var
  Y: Integer;
begin
  R.Left := X;
  /// if not (oHideVGrid in Options) then
    /// Inc(Fr.Left);
  R.Right := nextCol;
  SetTextAlign(Canvas.Handle,ta_Right or ta_Top);
  Y := (((R.Bottom - R.Top) - Abs(Canvas.Font.Height)) div 2) + R.Top;
  {draw the string}
  ExtTextOut(Canvas.Handle,R.right-FLeftOffset,Y,
    eto_Clipped+eto_Opaque,@R,PChar(S),Length(S),nil);
end;



procedure TBaseVirtListBox.DrawLeftAt2(R: TRect;
  X, YOffset: Integer; const S: AnsiString);
var
  Y: Integer;
begin
  SetTextAlign(Canvas.Handle,ta_Left or ta_Top);
  Y := (((R.Bottom - R.Top) - Abs(Canvas.Font.Height)) div 2) + R.Top + YOffset - 1;
  ExtTextOut(Canvas.Handle,X,Y, eto_Clipped+eto_Opaque,@R,PChar(S),Length(S),nil);
end;


procedure TBaseVirtListBox.DrawRightAt2(R: TRect;
  X, YOffset: Integer; const S: AnsiString);
var
  Y: Integer;
begin
  SetTextAlign(Canvas.Handle,ta_Right or ta_Top);
  Y := (((R.Bottom - R.Top) - Abs(Canvas.Font.Height)) div 2) + R.Top + YOffset - 1;
  ExtTextOut(Canvas.Handle,X,Y,
    eto_Clipped+eto_Opaque,@R,PChar(S),Length(S),nil);
end;





procedure TBaseVirtListBox.DrawHeader;
var
  FieldNo: Integer;
begin {DrawHeader}
  for FieldNo := FHDelta to Pred(NumCols) do begin
    DrawHeaderSection(FieldNo);
  end;
  DrawHeaderTrailer;
end; {DrawHeader}



procedure TBaseVirtListBox.DrawHeaderTrailer;
var
  HR: TRect;
  LastSplitter, ScrollOffset: Integer;
begin
  Canvas.Font.Assign(Self.FontHeader);
  Canvas.Brush.Color := Colors.Header;
  if FHDelta > 0 then
    ScrollOffset := QuerySplitter(FHDelta-1)
  else
    ScrollOffset := 0;
  if NumCols > 0 then
    LastSplitter := QuerySplitter(NumCols-1)
  else
    LastSplitter := 0;
  HR := HeaderRect;
  HR.Left := LastSplitter - ScrollOffset;
  DrawLeftAt2(HR,HR.Left,0,'');
end;


procedure TBaseVirtListBox.DrawHeaderSection(AIndex: Integer;
  Depressed: Boolean);
var
  CR,
  FR: TRect;
  S: AnsiString;
  CellRight,
  ScrollOffset: Integer;
  FieldNo: Integer;
  TextJustify: TAlignment;
begin {DrawHeaderSection}
  Canvas.Font.Assign(Self.FontHeader);
  Canvas.Brush.Color := Colors.Header;
  FR := HeaderRect;
  Dec(FR.Bottom);
  CR := ClientRect;
  FieldNo := AIndex;

  if FHDelta > 0 then
    ScrollOffset := QuerySplitter(FHDelta-1)
  else
    ScrollOffset := 0;

  if AIndex <= FHDelta then
    FR.Left := 0
  else begin
    FR.Left := QuerySplitter(AIndex-1);
    FR.Left := FR.Left - ScrollOffset;
  end;

  if FR.Left > ClientWidth then
    Exit;

  FR.Right := QuerySplitter(AIndex);
  FR.Right := FR.Right - ScrollOffset;

  CellRight := FR.Right-1;

  S := '';
  if OwnerDrawHeader then begin
    if not (oHideVGrid in Options) then
      Inc(FR.Left);
    DrawLeftAt(FR, FR.Left, CellRight, S);
    TextJustify := taLeftJustify;
    DoQueryField(-1,FieldNo,False,TextJustify);
    case TextJustify of
      taLeftJustify: SetTextAlign(Canvas.Handle,ta_Left or ta_Top);
      taRightJustify: SetTextAlign(Canvas.Handle,ta_Right or ta_Top);
    end;
    if Assigned(FOnBeforeDrawItem) then
      FOnBeforeDrawItem(-1,FieldNo,FR,TextJustify,[]);
    if Assigned(FDrawItem) then
      FDrawItem(-1,FieldNo,FR,[]);
    if Assigned(FOnAfterDrawItem) then
      FOnAfterDrawItem(-1,FieldNo,FR,TextJustify,[]);
  end else begin
    TextJustify := taLeftJustify;
    S := QueryHeader(FieldNo);
    DoQueryField(-1,FieldNo,False,TextJustify);
    if Assigned(FOnBeforeDrawItem) then
      FOnBeforeDrawItem(-1,FieldNo,FR,TextJustify,[]);
    if Depressed then case TextJustify of
      taLeftJustify: DrawLeftAt2(FR, FR.Left+FLeftOffset+2, 2, S);
      taRightJustify: DrawRightAt2(FR, FR.Right-FLeftOffset+2, 2, S);
    end else case TextJustify of
      taLeftJustify: DrawLeftAt2(FR, FR.Left+FLeftOffset, 0, S);
      taRightJustify: DrawRightAt2(FR, FR.Right-FLeftOffset, 0, S);
    end;

    if Assigned(FOnAfterDrawItem) then
      FOnAfterDrawItem(-1,FieldNo,FR,TextJustify,[]);
  end;

  // Canvas.Pen.Color := clBlack;
  //DrawVertLine(Canvas,FR.Right,FHeaderHeight-2);
  if Depressed then begin
    DrawTopLeft(Canvas,FR,clGray);
    DrawBotRight(Canvas,FR,clWhite);
  end else begin
    DrawTopLeft(Canvas,FR,clWhite);
    DrawBotRight(Canvas,FR,clGray);
  end;
end;




procedure TBaseVirtListBox.DrawItem(AnIndex: Integer);
var
  CliWidth: Integer;
  FR: TRect;
  S: AnsiString;
  CellLeft,
  CellRight,
  fLeft,
  fRight,
  fWidth : Integer;
  OdState: TOwnerDrawState;
  TextJustify: TAlignment;
  IsSelected: Boolean;

  procedure ResetGraphicsState;
  begin
    Canvas.Font := Font;
    if IsSelected and not (oDoNotHighlightSelected in Options)
    and ((odFocused in ODState) or not (oHideSelection in Options)) then begin
      Canvas.Font.Color := Colors.HighText;
      Canvas.Brush.Color := Colors.Highlight;
    end else begin
      Canvas.Font.Color := Colors.Text;
      Canvas.Brush.Color := Colors.Window;
    end;
    TextJustify := taLeftJustify;
  end;

var
  F: Integer;
begin {DrawItem}
  if (AnIndex < 0) then
    Exit;

  CellLeft := 1;
  if FHDelta > 0 then
    FLeft := QuerySplitter(Pred(FHDelta))
  else
    FLeft := 0;

  IsSelected := (AnIndex = FItemIndex);
  if MultiSelect then
    DoQuerySelection(AnIndex,IsSelected);

  OdState := [];
  if IsSelected then
    ODState := ODState + [odSelected];
  if GetFocus = Handle then
    ODState := ODState + [odFocused];

  FR := ItemRect[AnIndex];
  CliWidth := ClientWidth;


  if Assigned(FOnBeforePaintRow) then
    FOnBeforePaintRow(AnIndex,FR,ODState,Canvas);

  ResetGraphicsState;
  DrawLeftAt(FR, 0, CellLeft, '');

  for F := FHDelta to NumCols-1 do begin
    FRight := QuerySplitter(f) - 1;
    //FWidth := FRight-FLeft;
    //CellRight := CellLeft+FWidth-1;
    CellRight := FRight;

    S := '';
    if OwnerDraw then begin
      if not (oDoNotEraseBkgnd in Options) then
        DrawLeftAt(FR, CellLeft, CellRight, S);

      FR.Left := CellLeft;
      FR.Right := CellRight;

      if CellLeft <> CellRight then begin
        DoQueryField(AnIndex,F,IsSelected,TextJustify);
        case TextJustify of
          taLeftJustify: SetTextAlign(Canvas.Handle,ta_Left or ta_Top);
          taRightJustify: SetTextAlign(Canvas.Handle,ta_Right or ta_Top);
        end;

        if Assigned(FOnBeforeDrawItem) then
          FOnBeforeDrawItem(AnIndex,F,FR,TextJustify,ODState);
        if Assigned(FDrawItem) then
          FDrawItem(AnIndex,F,FR,ODState);
        if Assigned(FOnAfterDrawItem) then
          FOnAfterDrawItem(AnIndex,F,FR,TextJustify,ODState);
        CellLeft := CellRight;
      end;
    end else begin // not Owner Draw

      //DefaultDrawItem(AnIndex,F,);

      if (AnIndex < FRecCount) and (AnIndex >= 0) then
        S := QueryItem(AnIndex,F);
      if CellLeft <> CellRight then begin
        DoQueryField(AnIndex,F,IsSelected,TextJustify);
        if Assigned(FOnBeforeDrawItem) then
          FOnBeforeDrawItem(AnIndex,F,FR,TextJustify,ODState);
        case TextJustify of
          taLeftJustify: DrawLeftAt(FR, CellLeft, CellRight, S);
          taRightJustify: DrawRightAt(FR, CellLeft, CellRight, S);
        end;
        if Assigned(FOnAfterDrawItem) then
          FOnAfterDrawItem(AnIndex,F,FR,TextJustify,ODState);
        CellLeft := CellRight;
      end;

    end;
    if not (oHideVGrid in Options) then begin
      Inc(CellLeft); // Allow for the vertical grid
    end;
    if CellLeft >= CliWidth then
      Break;
    FLeft := FRight;
    ResetGraphicsState;
  end; {for}

  FR := ItemRect[AnIndex];
  if CellLeft < CliWidth then
    DrawLeftAt(FR, CellLeft, CliWidth, '');

  ResetGraphicsState;
  {Horizontal Grid}
  if not (oHideHGrid in Options) then begin
    if AnIndex < FRecCount then begin
      Canvas.Pen.Color := Colors.GridHoriz;
      Canvas.MoveTo(0,FR.Bottom-1);
      Canvas.LineTo(CliWidth,FR.Bottom-1);
    end;
  end;

  if Assigned(FOnAfterPaintRow) then
    FOnAFterPAintRow(AnIndex,FR,ODState,Canvas);

  {-Draw focus rectangle if necessary}
  if not (oHideFocusRect in Options) and (AnIndex = FItemIndex)
  and (GetFocus = Handle) then begin
    DrawFocusRect(Canvas.Handle,ItemRect[AnIndex]);
  end;

end;


function TBaseVirtListBox.GetItemRect(AnIndex: Integer): TRect;
var
  row: Integer;
  lTop: Integer;
begin
  Row := Succ(AnIndex - FTopIndex);
  with Result do begin
    left := 0;
    right := ClientWidth;
    if (row <= (FVisibleRows+FHalfRow)) then begin
      lTop := EffectiveHeaderHeight;
      lTop := lTop + Pred(row)*FRowHeight;
      top := lTop;
      bottom := Top + FRowHeight;
    end else begin
      top := ClientHeight;
      bottom := Succ(ClientHeight);
    end;
  end;
  (*
  if not (oHideHGrid in Options) then
    Inc(Result.Top);
  *)  
end;


function TBaseVirtListBox.GetHeaderRect: TRect;
begin
  with Result do begin
    Left := 0;
    Top := 0;
    Right := ClientWidth;
    Bottom := EffectiveHeaderHeight;
  end;
end;


function TBaseVirtListBox.DefaultQuerySplitter(AnIndex: Integer): Integer;
begin
  if AnIndex > NumCols then
    Result := QuerySplitter(AnIndex) + ClientWidth
  else
    Result := Succ(AnIndex)*DefColWidth;
end;


function TBaseVirtListBox.DefaultQueryItem;
begin
  Result := EmptyStr;
end;


function TBaseVirtListBox.DefaultQueryHeader;
begin
  Result := EmptyStr;
end;


function TBaseVirtListBox.QuerySplitter;
begin
  if Assigned(FQuerySplitter) then
    Result := FQuerySplitter(AnIndex)
  else
    Result := DefaultQuerySplitter(AnIndex);
end;


function TBaseVirtListBox.QueryItem;
begin
  if Assigned(FQueryItem) then
    Result := FQueryItem(RecNum,FldNum)
  else
    Result := DefaultQueryItem(RecNum,FldNum);
end;


function TBaseVirtListBox.QueryHeader;
begin
  if Assigned(FQueryHeader) then
    Result := FQueryHeader(FldNum)
  else
    Result := DefaultQueryHeader(FldNum);
end;


procedure TBaseVirtListBox.DoQueryField;
begin
  if Assigned(FQueryFieldAttr) then
    FQueryFieldAttr(RecNum, FieldNum,Align,Canvas);
end;


procedure TBaseVirtListBox.DoQuerySelection(RecNum: Integer;
  var Selected: Boolean);
begin
  if Assigned(FQuerySelection) then
    FQuerySelection(RecNum,Selected);
end;



procedure TBaseVirtListBox.CalcRows;
begin
  FVisibleRows := ((ClientHeight-EffectiveHeaderHeight) div FRowHeight);
  if (Height mod FRowHeight) <> 0 then
    FHalfRow := 1
  else
    FHalfRow := 0;
end;


procedure TBaseVirtListBox.UpdateRows;
begin
  SetHScrollRange;
  SetHScrollPos;
  CalcRows;
  SetVScrollRange;
  SetVScrollPos;
  Invalidate;
end;


function TBaseVirtListBox.GetItemIndex;
begin
  Result := FItemIndex;
  if (FItemIndex > Pred(FRecCount)) then
    Result := -1;
end;


procedure TBaseVirtListBox.SetItemIndex;
var
  FullPage: Bool;
  Shift: TShiftState;
begin
  FullPage := False;

  if Index < 0 then
    Exit;
  if (Index >= FRecCount) then
    Exit;

  if MultiSelect then begin
    Shift := GetShiftState;
    if not (ssCtrl in Shift) and not FMouseDragging then begin
      DoSelectionChange(FPrevItemIndex,selDeselectAll);
      Invalidate;
    end;
  end else begin
    DoSelectionChange(FPrevItemIndex,selDeselect);
    Invalidate;
  end;
  ///
  FItemIndex := Index;
  ///
  if MultiSelect then begin
    if ssShift in Shift then
      BlockSelect(FBlockBeginIndex,Index,selSelect)
    else begin
      if ssCtrl in Shift then
        DoSelectionChange(Index,selToggle)
      else begin
        if FMouseDragging then begin
          BlockSelect(FBlockBeginIndex,Index,selSelect);
          if Index > FBlockBeginIndex then
            BlockSelect(Index+1,Max(FTopIndex+FVisibleRows,NumRows-1),selDeselect)
          else
            BlockSelect(FTopIndex-1,Max(Index-1,-1),selDeselect);
        end else
          DoSelectionChange(Index,selSelect);
      end;
      Redraw(Index);
    end;
  end;

  {make sure the item is visible}
  if (Index >=0) and (Index < FTopIndex) then
    begin
      TopIndex := Index;
      FullPage := True;
    end
  else if Index >= (FTopIndex+Pred(FVisibleRows))
  then begin
    FullPage := True;
    TopIndex := Index-Pred(FVisibleRows);
    if FTopIndex < 0 then
      FTopIndex := 0;
  end;


  {update vertical scroll bar}
  SetVScrollPos;
  if FullPage then
    {redraw window}
    Redraw(-1)
  else if FPrevItemIndex >= FRecCount then
    Redraw(-1)
  else
    Redraw(FItemIndex);
  DoOnChange(FItemIndex);

  if not (ssShift in Shift) and not FMouseDragging then
    FBlockBeginIndex := Index;

  FPrevItemIndex := FItemIndex;
end;


procedure  TBaseVirtListBox.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self,Index);
end;


procedure TBaseVirtListBox.SetTopIndex(Index: Integer);
{-Set the index of the first visible entry in the list}
begin
  if (Index <> FTopIndex) and (Index >= 0)
  and (Index < FRecCount) then begin
    FTopIndex := Index;
    DoOnTopIndexChanged(Index);
    SetVScrollPos;
    InvalidateRows;
  end;
end;


procedure TBaseVirtListBox.Redraw(PrevIndex: Integer);
var
  R: TRect;
begin
  if PrevIndex < 0 then begin
    SetRect(R,0,EffectiveHeaderHeight,ClientWidth,ClientHeight);
    InvalidateRect(Handle,@R,False);
  end else
    DrawSelection(PrevIndex);
end;


procedure TBaseVirtListBox.DrawSelection(PrevSel: Integer);
begin
  DrawItem(PrevSel);
  DrawItem(FItemIndex);
end;


procedure TBaseVirtListBox.WMHScroll(var Msg: TWMHScroll);

procedure HScrollPrim(Delta : Integer);
  var
    SaveD : Integer;
  begin
    if NumCols <= 1 then
      Exit;
    SaveD := FHDelta;
    if Delta < 0 then begin
      if (Delta + FHDelta) < 0 then
        FHDelta := 0
      else
        FHDelta := FHDelta + Delta;
    end else begin
      if Integer(FHDelta)+Delta > Integer(FHSHigh) then
        FHDelta := FHSHigh
      else
        FHDelta := FHDelta + Delta;
    end;    
    if FHDelta <> SaveD then begin
      SetHScrollPos;
      Invalidate;
      //Update;
    end;
  end;

begin
  if (oDisableHScroll in Options) then
    Exit;
  case Msg.ScrollCode of
    sb_LineDown:
      HScrollPrim(+1);
    sb_LineUp:
      HScrollPrim(-1);
    sb_PageDown:
      HScrollPrim(NumCols div 2);
    sb_PageUp:
      HScrollPrim(-(NumCols div 2));
    sb_ThumbPosition,
    sb_ThumbTrack:
      if FHDelta <> Msg.Pos then begin
        FHDelta := Msg.Pos;
        SetHScrollPos;
        Invalidate;
        Update;
      end;
  end;
end;


procedure TBaseVirtListBox.WMVScroll(var Msg: TWMHScroll);
var
  I : Integer;

procedure VScrollPrim(Rows : Integer);
  var
    I : Integer;
  begin
    I := FTopIndex+Rows;
    if I < 0 then begin
      if Rows > 0 then
        I := Pred(FRecCount)
      else
        I := 0
    end else if (I > Pred(FRecCount)) then
      I := Pred(FRecCount);
    TopIndex := I;
  end;

begin
  case Msg.ScrollCode of
    sb_LineDown       :
      VScrollPrim(+1);
    sb_LineUp         :
      VScrollPrim(-1);
    sb_PageDown       :
      VScrollPrim(+FVisibleRows);
    sb_PageUp         :
      VScrollPrim(-FVisibleRows);
    sb_ThumbPosition,
    sb_ThumbTrack     :
      begin
        if Msg.Pos = 0 then
          I := 0
        else if Msg.Pos = FVSHigh then
          if FVisibleRows >= Pred(FRecCount) then
            I := 0
          else
            I := FRecCount-Pred(FVisibleRows)
        else
          I := ScaleUp(Msg.Pos,FVertDivisor);
        TopIndex := I;
      end;
  end;
end;


procedure TBaseVirtListBox.WMEraseBkgnd;
begin
 Msg.Result := 1
end;


procedure TBaseVirtListBox.WMCreate;
begin
  inherited;
  UpdateRows;
end;


function TBaseVirtListBox.ClientToRow;
var
  HeaderY: Integer;
begin
  HeaderY := EffectiveHeaderHeight;
  if (Y <= HeaderY) then
    Result := -1
  else begin
    Y := (Y-HeaderY);
    Result := FTopIndex+(Y div FRowHeight);
    if (Result > FRecCount) then
      Result := -1;
  end;
end;


function TBaseVirtListBox.ClientToCol;
var
  I,
  Offset,
  SplitX: Integer;
begin
  SplitX := -1;
  if FHDelta > 0 then
    Offset := QuerySplitter(FHDelta-1)
  else
    Offset := 0;
  for I := FHDelta to Pred(NumCols) do begin
    SplitX := QuerySplitter(I) - Offset;
    if (SplitX > X) or (SplitX > ClientWidth) then
      Break;
  end;
  if X > SplitX then
    Inc(I);
  Result := I;
end;


procedure TBaseVirtListBox.ClientToGrid;
begin
  Col := ClientToCol(APoint.X);
  Row := ClientToRow(APoint.Y);
end;


function TBaseVirtListBox.GridRect;
var
  Offset: Integer;
begin
  Result := GetItemRect(Row);
  if FHDelta > 0 then
    Offset := QuerySplitter(FHDelta - 1)
  else
    Offset := 0;
  if Col > FHDelta then
    Result.Left := QuerySplitter(Col-1) - Offset
  else
    Result.Left := 0;
  Result.Right := QuerySplitter(Col) + Offset;
  if Result.Left < 0 then
    Result.Left := 0;
  if Result.Right > ClientWidth then
    Result.Right := ClientWidth;
end;



function TBaseVirtListBox.ClientToGridRect;
var
  Row,
  Col: Integer;
begin
  ClientToGrid(APoint,Col,Row);
  Result := GridRect(Col,Row);
end;


procedure TBaseVirtListBox.WMLButtonDown;
var
  PrvPt,
  Pt : TPoint;
  I, ExtraRows : Integer;
  VMargin,
  HMargin: Integer;
  SplitterIndex: Integer;

  procedure Yield;
    var
      msg: TMsg;
    begin
      if PeekMessage(Msg, 0, 0, 0, pm_Remove) then begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
    end;

  procedure SplitterDrag;
    var
      OldMode: TPenMode;
      LeftLimit,
      RightLimit: Integer;
    begin
      if Dragging then
        EndDrag(False);

      HMargin := -1;

      if SplitterIndex > 0 then
        LeftLimit := QuerySplitter(SplitterIndex-1) + HMargin
      else
        LeftLimit := HMargin;
      if FHDelta > 0 then
        LeftLimit := LeftLimit - QuerySplitter(Pred(FHDelta));

      if LeftLimit < HMargin then
        LeftLimit := HMargin;

      RightLimit := Pred(ClientWidth);
      WinProcs.GetCursorPos(PrvPt);
      PrvPt := ScreenToClient(PrvPt);
      with Canvas do begin
        OldMode := Pen.Mode;
        Pen.Mode := pmXor;
        MoveTo(PrvPt.X,0);
        LineTo(PrvPt.X,ClientHeight);
      end;
      SetCapture(Handle);
      FCapture := True;
      repeat
        WinProcs.GetCursorPos(Pt);
        Pt := ScreenToClient(Pt);
        if Pt.X < LeftLimit then
          Pt.X := LeftLimit;
        if Pt.X > RightLimit then
          Pt.X := RightLimit;
        if PrvPt.X <> Pt.X then
          with Canvas do begin
            MoveTo(PrvPt.X,0);
            LineTo(PrvPt.X,ClientHeight);
            MoveTo(Pt.X,0);
            LineTo(Pt.X,ClientHeight);
          end;
        PrvPt := Pt;
        Yield;
      until WinProcs.GetAsyncKeyState(vk_LButton) >= 0;
      with Canvas do begin
        MoveTo(Pt.X,0);
        LineTo(Pt.X,ClientHeight);
        Pen.Mode := OldMode;
      end;
      ReleaseCapture;
      FCapture := False;
      if FHDelta > 0 then
        Pt.X := Pt.X + QuerySplitter(Pred(FHDelta));
      DoResizeColumn(SplitterIndex, Pt.X);
      Invalidate;
    end;


  procedure HeaderDrag;
  var
    ColIndex: Integer;
    FirstIteration: Boolean;
  begin
    WinProcs.GetCursorPos(Pt);
    Pt := ScreenToClient(Pt);
    ColIndex := ClientToCol(Pt.X);
    if ColIndex >= NumCols then
      Exit;
    MouseDown(mbLeft,[],Msg.XPos,Msg.YPos);
    if oHeaderButton in Options then begin
      if not Dragging then begin
        SetCapture(Handle);
        FCapture := True;
      end;
      FMouseDragging := True;
      FirstIteration := True;
      repeat
        WinProcs.GetCursorPos(Pt);
        Pt := ScreenToClient(Pt);
        if FirstIteration then begin
          if (Pt.Y > 0) and (Pt.Y < EffectiveheaderHeight) then
            DrawHeaderSection(ColIndex,True)
          else
            DrawHeaderSection(ColIndex,False);
        end;
        Yield;
        FirstIteration := False;
      until (WinProcs.GetAsyncKeyState(vk_LButton) >= 0) or Dragging;
      FMouseDragging := False;
      if not Dragging then begin
        ReleaseCapture;
        FCapture := False;
      end;
      DrawHeader;
    end;
    DoHeaderClick(ColIndex);
  end;


  procedure MouseScroll;
  var
    FirstIteration: Boolean;
  begin
    // Non-header, client-area cick
    MouseDown(mbLeft,[],Msg.XPos,Msg.YPos);
    if (FRecCount = 0) then
      Exit;

    HMargin := 0; /// QuerySplitter(0);
    VMargin := 2;
    if not Dragging then begin
      SetCapture(Handle);
      FCapture := True;
    end;  
    FirstIteration := True;
    repeat
      WinProcs.GetCursorPos(Pt);
      Pt := ScreenToClient(Pt);
      if Pt.X < HMargin then
        ScrollLeft
      else if Pt.X > (ClientWidth-HMargin) then
        ScrollRight;
      if Pt.Y <= 1 then begin
        if Pt.Y < -VScrollingAccel2Pixels then
          SetItemIndex(FTopIndex-VScrollingAccel2Rows)
        else if Pt.Y < -VScrollingAccel1Pixels then
          SetItemIndex(FTopIndex-VScrollingAccel1Rows)
        else
          SetItemIndex(FTopIndex-1);
      end else if Pt.Y >= (ClientHeight-1) then begin
        if (Pt.Y - ClientHeight + 1) > VScrollingAccel2Pixels then
          ExtraRows := VScrollingAccel2Rows
        else if (Pt.Y - ClientHeight + 1) > VScrollingAccel1Pixels then
          ExtraRows := VScrollingAccel1Rows
        else
          ExtraRows := 0;
        SetItemIndex(FTopIndex+FVisibleRows+ExtraRows);
      end else begin
        {convert to an index}
        I := ClientToRow(Pt.Y);
        if ((I <= FRecCount) and (I <> ItemIndex)) or FirstIteration then
          SetItemIndex(I);
      end;
      Yield;
      FMouseDragging := True;
      FirstIteration := False;
    until (WinProcs.GetAsyncKeyState(vk_LButton) >= 0) or Dragging;
    FMouseDragging := False;
    if not Dragging then begin
      ReleaseCapture;
      FCapture := False;
    end;
    if ClientToRow(Msg.YPos) = FItemIndex
      then Click;
  end;

begin
  if FPrevItemIndex > 0 then
    DrawFocusRect(Canvas.Handle,ItemRect[FPrevItemIndex]);
  SplitterIndex := QueryDragHandle(msg.XPos);
  if (SplitterIndex >= 0) and not (oDisableDragSplitter in Options) then
    SplitterDrag
  else if Msg.YPos < EffectiveHeaderHeight then
    HeaderDrag
  else
    MouseScroll;
  SetFocus;
end;


procedure TBaseVirtListBox.WMLButtonUp(var Msg: TWMMouse);
begin
  FMouseDragging := False;
  inherited;
end;


procedure TBaseVirtListBox.WMLButtonDblClk(var Msg: TWMLButtonDblClk);
begin
  inherited;
  if ClientToRow(Msg.YPos) <> FItemIndex
    then Exit;
  DblClick;
end;


procedure TBaseVirtListBox.WMKeyDown;
var
  I : Integer;
begin
  KeyDown(Msg.CharCode,KeyDataToShiftState(Msg.KeyData));
  case Msg.CharCode of
    vk_Left :
      ScrollLeft;
    vk_Right :
      ScrollRight;
    vk_Up :
      SetItemIndex(FItemIndex-1);
    vk_Down :
      if FItemIndex < Pred(FRecCount) then
        SetItemIndex(FItemIndex+1);
    vk_Home :
      SetItemIndex(0);
    vk_End :
      if FRecCount <> 0 then
        SetItemIndex(FRecCount-1);
    vk_Prior :
      if FRecCount <> 0 then begin
        if FVisibleRows = 1 then
          I := FItemIndex-1
        else
          I := FItemIndex-Pred(FVisibleRows);
        if I < 0 then
          I := 0;
        SetItemIndex(I);
      end;
    vk_Next :
      if FRecCount <> 0 then begin
        if FVisibleRows = 1 then
          I := FItemIndex+1
        else
          I := FItemIndex+Pred(FVisibleRows);
        if I > FRecCount then
          I := Pred(FRecCount);
        SetItemIndex(I);
      end;
  end;
end;


procedure TBaseVirtListBox.WMGetDlgCode;
begin
  inherited;
  Msg.Result := Msg.Result or DLGC_WANTARROWS;
end;


procedure TBaseVirtListBox.ScrollLeft;
begin
  if (oDisableHScroll in Options) then
    Exit;
  if (FHDelta > 0) then begin
    Dec(FHDelta);
    SetHScrollPos;
    Invalidate;
    Update;
  end;
end;


procedure TBaseVirtListBox.ScrollRight;
begin
  if (oDisableHScroll in Options) then
    Exit;
  if FHDelta < FHSHigh then begin
    Inc(FHDelta);
    SetHScrollPos;
    Invalidate;
    Update;
  end;
end;



function TBaseVirtListBox.QueryDragHandle(X: Integer): Integer;
var
  Found  : Boolean;
  f ,
  cRight : Integer;
  Offset: Integer;
begin
  Found := False;
  if FHDelta > 0 then
    Offset := QuerySplitter(Pred(FHDelta))
  else
    Offset := 0;
  for F := Pred(NumCols) downto FHDelta do begin
    CRight := QuerySplitter(F) - Offset;
    Found := (x >= (cRight-3)) and (x <= (cRight+2));
    if Found then
      Break;
    (*
    if (cRight > ClientWidth) then
      Break;
    *)
  end;
  if found then
    Result := f
  else
    Result := -1;
end;


function TBaseVirtListBox.IsInHeader(Y: Integer): Boolean;
begin
  Result := IsHeaderVisible
    and (Y <= FHeaderHeight);
end;


procedure TBaseVirtListBox.Clear;
begin
  NumRows := 0;
  NumCols := 0;
end;


procedure TBaseVirtListBox.InvalidateRows;
var
  R: TRect;
begin
  SetRect(R,0,EffectiveHeaderHeight,ClientWidth,ClientHeight);
  InvalidateRect(Handle,@R,False);
end;


procedure TBaseVirtListBox.DoResizeColumn(SplitNum, NewPos: Integer);
begin
  if Assigned(FResizeColumn) then
    FResizeColumn(SplitNum,NewPos);
end;


procedure TBaseVirtListBox.DoHeaderClick;
begin
  if Assigned(FOnHeaderClick) and (Col < NumCols) then
    FOnHeaderClick(Self,Col);
end;



procedure TBaseVirtListBox.SetLeftColIndex(const Value: Integer);
begin
  FHDelta := Value;
  if FHDelta < 0 then
    raise Exception.Create('LeftColIndex < 0');
  Invalidate;
end;



procedure TBaseVirtListBox.SetLeftOffset(const Value: Integer);
begin
  FLeftOffset := Value;
  Invalidate;
end;


function TBaseVirtListBox.IsHeaderVisible: Boolean;
begin
  Result := not (oHideHeader in Options);
end;



procedure TBaseVirtListBox.WMMouseWheel(var Msg: TMessage);
var
  Shift: TShiftState;
begin
  Shift := KeysToShiftState(Msg.wParamLo);
  {$R-}
  DoOnMouseWheel({fwKeys}Shift, {zDelta}Msg.WParamHi, {xPos}Msg.LParamLo, {yPos}Msg.LParamHi);
  {$R+}
end;


procedure TBaseVirtListBox.DoOnMouseWheel(Shift: TShiftState; Delta, XPos,
  YPos: SmallInt);
var
  I: Integer;
begin
  if Assigned(FOnMouseWheel) then
    FOnMouseWheel(Self, Shift, Delta, XPos, YPos);
  if Delta < 0 then begin
    for I := 1 to {vlb}WheelDelta do
      Perform(WM_VSCROLL, MAKELONG(SB_LINEDOWN, 0), 0);
  end else if Delta > 0 then begin
    for I := 1 to {vlb}WheelDelta do
      Perform(WM_VSCROLL, MAKELONG(SB_LINEUP, 0), 0);
  end;
end;


procedure TBaseVirtListBox.InitScrollInfo;
begin
  if not HandleAllocated then
    Exit;
  {initialize scroll bars, if any}
  SetVScrollRange;
  SetVScrollPos;
  SetHScrollRange;
  SetHScrollPos;
end;




procedure TBaseVirtListBox.CreateWnd;
begin
  inherited CreateWnd;
  FHaveVertScroll := FScrollBars in [ssVertical, ssBoth];
  FHaveHorzScroll := FScrollBars in [ssHorizontal, ssBoth];
  ItemIndex := 0; {-1;}
  InitScrollInfo;
end;


function TBaseVirtListBox.EffectiveHeaderHeight: Integer;
begin
  if IsHeaderVisible then
    Result := FHeaderHeight 
  else
    Result := 0;
end;


procedure TBaseVirtListBox.SetMultiSelect(Value: Boolean);
begin
  if (csDesigning in ComponentState)
  or (csLoading in ComponentState) then
    if Value <> FMultiSelect then
      FMultiSelect := Value;
end;


procedure TBaseVirtListBox.DoOnTopIndexChanged(NewTopIndex: Integer);
begin
  if Assigned(FOnTopIndexChanged) then
    FOnTopIndexChanged(Self, NewTopIndex);
end;



{ TVirtListBoxEx }

constructor TVirtListBoxEx.Create;
begin
  FColumns := TStringList.Create;
  inherited Create(AnOwner);
  if csDesigning in ComponentState then begin
    FColumns.AddObject('',Pointer(200));
  end;
  FColumns.OnChange := OnChangeColumns;
end;


destructor TVirtListBoxEx.Destroy;
begin
  FColumns.Free;
  inherited;
end;


function TVirtListBoxEx.GetColumns: TStrings;
begin
  Result := FColumns;
end;


function TVirtListBoxEx.GetNumCols: Integer;
begin
  Result := FColumns.Count;
end;



procedure TVirtListBoxEx.OnChangeColumns;
begin
  inherited NumCols := FColumns.Count;
end;


function TVirtListBoxEx.QueryHeader(FldNum: Integer): AnsiString;
begin
  if Assigned(FQueryHeader) then
    Result := FQueryHeader(FldNum)
  else if Assigned(FColumns) then begin
    if FldNum < FColumns.Count then
      Result := FColumns[FldNum]
    else
      Result := DefaultQueryHeader(FldNum);
  end else
    Result := DefaultQueryHeader(FldNum);
end;


procedure TVirtListBoxEx.SetColumns(const Value: TStrings);
begin
  FColumns.Assign(Value);
  inherited NumCols := FColumns.Count;
end;



function TVirtListBoxEx.GetSplitter(AnIndex: Integer): Integer;
begin
  if FColumns.Count > 0 then
    Result := Integer(FColumns.Objects[AnIndex])
  else
    Result := 0;
end;



procedure TVirtListBoxEx.SetSplitter(AnIndex: Integer;
  const Value: Integer);
begin
  if FColumns.Count = 0 then
    Exit;
  FColumns.Objects[AnIndex] := Pointer(Value);
end;




procedure TVirtListBoxEx.DoResizeColumn(SplitNum, NewPos: Integer);
var
  DiffPos, I: Integer;
begin
  if Assigned(FResizeColumn) then
    FResizeColumn(SplitNum,NewPos)
  else begin
    DiffPos := NewPos - Integer(Columns.Objects[SplitNum]);
    Columns.Objects[SplitNum] := Pointer(NewPos);
    for I := SplitNum+1 to Columns.Count-1 do
      Columns.Objects[I] := Pointer( Integer(Columns.Objects[I])+DiffPos );
  end;
end;




function TVirtListBoxEx.QuerySplitter(AnIndex: Integer): Integer;
begin
  Result := 0;
  if csDesigning in ComponentState then
    Result := DefaultQuerySplitter(AnIndex)
  else begin
    if Assigned(FQuerySplitter) then
      Result := FQuerySplitter(AnIndex);
    if Result = 0 then begin
      Result := Integer(Columns.Objects[AnIndex]);
      if Result = 0 then
        Result := DefaultQuerySplitter(AnIndex);
    end;
  end;
end;



procedure TVirtListBoxEx.Loaded;
begin
  inherited;
  FixColumnWidths;
end;


procedure TVirtListBoxEx.FixColumnWidths;
var
  I: Integer;
begin
  for I := 0 to Columns.Count-1 do
    Columns.Objects[I] := Pointer(DefaultQuerySplitter(I));
end;



procedure TBaseVirtListBox.SetDefColWidth(const Value: Integer);
begin
  FDefColWidth := Value;
  Invalidate;
end;


function TVirtListBoxEx.GetColumnWidth(Index: Integer): Integer;
begin
  if Index > 0 then
    Result := Splitter[Index] - Splitter[Index-1]
  else
    Result := 0;
end;



procedure TVirtListBoxEx.SetColumnWidth(Index: Integer;
  const Value: Integer);
var
  I, X, Diff: Integer;
begin
  if Index > 0 then
    X := Splitter[Index-1]
  else
    X := 0;
  Diff := Splitter[Index] - X;
  if Diff <> 0 then
    for I := Index+1 to Columns.Count-1 do
      Splitter[I] := Splitter[I] + Diff;
end;




procedure TBaseVirtListBox.DoSelectionChange(RecNum: Integer;
  SelChange: TSelectionChange);
var
  IsSelected: Boolean;
begin
  if (RecNum >= RecCount) then
    Exit;
  if RecNum >= 0 then
    DoQuerySelection(RecNum,IsSelected);
  case SelChange of
    selSelect:
      if not IsSelected then
        Inc(FSelCount);
    selDeselect:
      if IsSelected then
        Dec(FSelCount);
    selToggle : begin
      if IsSelected then
        Inc(FSelCount)
      else
        Dec(FSelCount);
    end;
    selSelectAll:
      FSelCount := NumRows;
    selDeselectAll:
      FSelCount := 0;
  end;
  if Assigned(FOnSelectionChange) then
    FOnSelectionChange(RecNum,SelChange);
end;

procedure TBaseVirtListBox.Click;
begin
  inherited;
end;

procedure TBaseVirtListBox.DeselectAll;
begin
  DoSelectionChange(-1,selDeselectAll);
end;

procedure TBaseVirtListBox.SelectAll;
begin
  DoSelectionChange(-1,selSelectAll);
end;


procedure TBaseVirtListBox.BlockSelect(IndexFrom, IndexTo: Integer; Select: TSelectionChange);
var
  I: Integer;
begin
  if IndexFrom > IndexTo then begin
    I := IndexFrom;
    IndexFrom := IndexTo;
    IndexTo := I;
  end;
  for I := IndexFrom to IndexTo do
    DoSelectionChange(I,Select);
  Invalidate;
end;


end.





