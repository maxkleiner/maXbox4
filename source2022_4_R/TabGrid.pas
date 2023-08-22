unit TabGrid;

interface

uses Variants, Windows, SysUtils, Messages, Classes, Controls, Forms, Graphics,
     StdCtrls, DBCtrls, Grids, DBGrids, Db;

type
  TDBTabGrid = class(TCustomDBGrid)
  private
    FEnterKeyIsTabKey:Boolean;
    FShowArrow:Boolean;
    FSortColumn:string;
    FSortDesc:Boolean;
    FScrollBarWidth:Integer;
    FAutoAppend:Boolean;
    FAlternateRowColor: TColor;
    procedure SetSortColumn(value:string);
    procedure SetSortDesc(value:Boolean);
    procedure SetShowArrow(value:Boolean);
    procedure SetAlternateRowColor(const Value: TColor);
  protected
    procedure KeyPress (var key:Char); override;
    procedure KeyDown (var key:Word; Shift:TShiftState); override;
    function  CreateEditor: TInplaceEdit; override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState); override;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure WriteText(ACanvas: TCanvas; ARect: TRect; DX, DY: Integer; const Text: string; Alignment: TAlignment; ARightToLeft: Boolean);
    procedure ColumnMoved(FromIndex, ToIndex:Longint); override; // Prozedur war protected
    function GetScrollBarWidth:Integer; // neu
    property VisibleRowCount; // Property war protected
    property Canvas;
    property SelectedRows;
  published
    property ShowArrow: Boolean read FShowArrow write SetShowArrow default false; // JS
    property SortColumn: string read FSortColumn write SetSortColumn; // JS
    property SortDesc: Boolean read FSortDesc write SetSortDesc default false; // JS
    property EnterKeyIsTabKey: Boolean read FEnterKeyIsTabKey write FEnterKeyIsTabKey default true; // JS
    property AlternateRowColor: TColor read FAlternateRowColor write SetAlternateRowColor default clNone; // JS
    property AutoAppend: Boolean read FAutoAppend write FAutoAppend default True; // JS
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Columns stored False; //StoreColumns;
    property Constraints;
    property Ctl3D;
    property DataSource;
    property DefaultDrawing;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property Font;
    property ImeMode;
    property ImeName;
    property Options;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TitleFont;
    property Visible;
    property OnCellClick;
    property OnColEnter;
    property OnColExit;
    property OnColumnMoved;
    property OnDrawDataCell;  { obsolete }
    property OnDrawColumnCell;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditButtonClick;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate; // neu
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseEnter; // neu
    property OnMouseLeave; // neu
    property OnMouseUp;
    property OnMouseWheel; // neu
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
    property OnTitleClick;
  end;

IMPLEMENTATION
uses Math, DBConsts, VDBConsts, Dialogs, RTLConsts;

{**************************************************************************************************}
{*** TDBGridInplaceEdit ***************************************************************************}
{**************************************************************************************************}
type
  TDBTabGridInplaceEdit = class(TInplaceEditList)
  private
    FDataList: TDBLookupListBox;
    FUseDataList: Boolean;
    FLookupSource: TDatasource;
  protected
    procedure CloseUp(Accept: Boolean); override;
    procedure DoEditButtonClick; override;
    procedure DropDown; override;
    procedure UpdateContents; override;
    procedure KeyDown (var key:Word; Shift:TShiftState); override; // neu
  public
    constructor Create(Owner: TComponent); override;
    property  DataList: TDBLookupListBox read FDataList;
  end;

constructor TDBTabGridInplaceEdit.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FLookupSource := TDataSource.Create(Self);
end;

procedure TDBTabGridInplaceEdit.CloseUp(Accept: Boolean);
var MasterField: TField;
    ListValue: Variant;
begin
  if ListVisible then begin
     if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
     if ActiveList = DataList
     then ListValue := DataList.KeyValue
     else if PickList.ItemIndex <> -1 then ListValue := PickList.Items[Picklist.ItemIndex];
     SetWindowPos(ActiveList.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
     ListVisible := False;
     if Assigned(FDataList) then FDataList.ListSource := nil;

     FLookupSource.Dataset := nil;
     Invalidate;
     if Accept then
        if ActiveList = DataList
//      then with TCustomDBGrid(Grid), Columns[SelectedIndex].Field do begin // D7
        then with TCustomDBGrid(Grid), TDBGrid(Grid).Columns[SelectedIndex].Field do begin
                  MasterField := DataSet.FieldByName(KeyFields);
//                if MasterField.CanModify and FDataLink.Edit then MasterField.Value := ListValue; // D7
                  if MasterField.CanModify and TDBTabGrid(Grid).DataLink.Edit then MasterField.Value:=ListValue;
        end
        else if (not VarIsNull(ListValue)) and EditCanModify then
//               with TCustomDBGrid(Grid), Columns[SelectedIndex].Field do Text:=ListValue; // D7
                 with TCustomDBGrid(Grid), TDBGrid(Grid).Columns[SelectedIndex].Field do Text:=ListValue;
  end;
end;

procedure TDBTabGridInplaceEdit.DoEditButtonClick;
begin
//  TCustomDBGrid(Grid).EditButtonClick; // D7
  TDBTabGrid(Grid).EditButtonClick;
end;

procedure TDBTabGridInplaceEdit.DropDown;
var Column: TColumn;
begin
  if not ListVisible then begin
//    with TCustomDBGrid(Grid) do Column := Columns[SelectedIndex];
    with TDBTabGrid(Grid) do Column := Columns[SelectedIndex];
    if ActiveList = FDataList
    then with Column.Field do begin
         FDataList.Color := Color;
         FDataList.Font := Font;
         FDataList.RowCount := Column.DropDownRows;
         FLookupSource.DataSet := LookupDataSet;
         FDataList.KeyField := LookupKeyFields;
         FDataList.ListField := LookupResultField;
         FDataList.ListSource := FLookupSource;
         FDataList.KeyValue := DataSet.FieldByName(KeyFields).Value;
    end
    else if ActiveList = PickList then begin
            PickList.Items.Assign(Column.PickList);
            DropDownRows := Column.DropDownRows;
    end;
  end;
  inherited DropDown;
end;

procedure TDBTabGridInplaceEdit.UpdateContents;
var Column: TColumn;
begin
  inherited UpdateContents;
  if FUseDataList then begin
     if FDataList = nil then begin
        FDataList := TPopupDataList.Create(Self);
        FDataList.Visible := False;
        FDataList.Parent := Self;
        FDataList.OnMouseUp := ListMouseUp;
     end;
     ActiveList := FDataList;
  end;

//  with TCustomDBGrid(Grid) do Column := Columns[SelectedIndex];
  with TDBTabGrid(Grid) do Column := Columns[SelectedIndex];
  Self.ReadOnly := Column.ReadOnly;
  Font.Assign(Column.Font);
  ImeMode := Column.ImeMode;
  ImeName := Column.ImeName;
end;

{**************************************************************************************************}
{*** Änderungen ***********************************************************************************}
{**************************************************************************************************}
procedure TDBTabGridInplaceEdit.KeyDown(var key:Word; Shift:TShiftState);
begin
  if TDBTabGrid(Grid).FEnterKeyIsTabKey and (key=vk_return) and ((Shift=[]) or (Shift=[ssShift])) then key:=vk_tab;
  inherited KeyDown(key,shift);
end;

{**************************************************************************************************}
{*** TDBTabGrid ***********************************************************************************}
{**************************************************************************************************}
procedure TDBTabGrid.KeyPress (var key:Char);
// Damit man sich auch mit der Return-Taste eine Spalte weiterbewegen kann, wie Tab-Taste.
begin
  if FEnterKeyIsTabKey and (key=#13) then key:=#0;
  inherited KeyPress(key);
end;

procedure TDBTabGrid.KeyDown (var key:Word; Shift:TShiftState);
begin
  if FEnterKeyIsTabKey and (Key=vk_return) and ((Shift=[]) or (Shift=[ssShift])) then key:=vk_tab;

{
// AutoAppend funktioniert noch nicht, weil EOF nicht true ist
  if (Key=vk_Down) and (not FAutoAppend) and (DataLink.DataSet <> nil) then with Datalink.Dataset do
     if (State=dsBrowse) and Eof and CanModify and (not ReadOnly) and (dgEditing in Options) then begin
     Key:=0;
     end;
}
  inherited KeyDown(key,Shift);
end;

function  TDBTabGrid.CreateEditor: TInplaceEdit;
begin
  Result:=TDBTabGridInplaceEdit.Create(Self);
end;

function TDBTabGrid.GetScrollBarWidth:Integer;
begin
  result:=FScrollBarWidth; // 16 Pixel
end;

procedure TDBTabGrid.ColumnMoved(FromIndex, ToIndex:Longint); // Prozedur war protected
begin
  inherited;
end;

{*** TDBTabGrid Zeichnen **************************************************************************}
var DrawBitmap: TBitmap;
    UserCount: Integer;

procedure UsesBitmap;
begin
  if UserCount = 0 then DrawBitmap := TBitmap.Create;
  Inc(UserCount);
end;

procedure ReleaseBitmap;
begin
  Dec(UserCount);
  if UserCount = 0 then DrawBitmap.Free;
end;

constructor TDBTabGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScrollBarWidth:=GetSystemMetrics(SM_CXVScroll); // 16 Pixel bei XP mit SP1, 17 Pixel bei XP mit SP2
  FEnterKeyIsTabKey:=true;
  FShowArrow:=false;
  FSortColumn:='';
  FSortDesc:=false;
  FAutoAppend:=true;
  FAlternateRowColor:=clNone;
  UsesBitmap;
end;

destructor TDBTabGrid.Destroy;
begin
  inherited Destroy;
  ReleaseBitmap;
end;

procedure TDBTabGrid.SetAlternateRowColor(const Value: TColor);
begin
  if FAlternateRowColor <> Value then begin
     FAlternateRowColor:=Value;
     Invalidate;
  end;
end;

procedure TDBTabGrid.WriteText(ACanvas: TCanvas; ARect: TRect; DX, DY: Integer; const Text: string; Alignment: TAlignment; ARightToLeft: Boolean);
{
// Bei den Konstanten ist immer DT_Wordbreak enthalten
// Das führt dann dazu, das der Text z.B. in gelben Spalten nicht bis zum rechten Spaltenrand ausgeschrieben wird
const AlignFlags : array [TAlignment] of Integer =
      ( DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
        DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
        DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX );
}

const AlignFlags : array [TAlignment] of Integer =
      ( DT_LEFT or DT_EXPANDTABS or DT_NOPREFIX,
        DT_RIGHT or DT_EXPANDTABS or DT_NOPREFIX,
        DT_CENTER or DT_EXPANDTABS or DT_NOPREFIX );

  RTL: array [Boolean] of Integer = (0, DT_RTLREADING);

var B, R: TRect;
    Hold, Left: Integer;
    I: TColorRef;
begin
  I := ColorToRGB(ACanvas.Brush.Color);
  if GetNearestColor(ACanvas.Handle, I) = I
  then begin { Use ExtTextOut for solid colors }
    { In BiDi, because we changed the window origin, the text that does not change alignment, actually gets its alignment changed. }
    if (ACanvas.CanvasOrientation = coRightToLeft) and (not ARightToLeft) then ChangeBiDiModeAlignment(Alignment);
    case Alignment of
      taLeftJustify:    Left := ARect.Left + DX;
      taRightJustify:   Left := ARect.Right - ACanvas.TextWidth(Text) - 3;
      else { taCenter } Left := ARect.Left + (ARect.Right - ARect.Left) shr 1 - (ACanvas.TextWidth(Text) shr 1);
    end;
    ACanvas.TextRect(ARect, Left, ARect.Top + DY, Text);
  end
  else begin { Use FillRect and Drawtext for dithered colors }
    DrawBitmap.Canvas.Lock;
    try
        with DrawBitmap, ARect do begin{ Use offscreen bitmap to eliminate flicker and  brush origin tics in painting / scrolling.}
             Width := Max(Width, Right - Left);
             Height := Max(Height, Bottom - Top);
             R := Rect(DX, DY, Right - Left - 1, Bottom - Top - 1);
             B := Rect(0, 0, Right - Left, Bottom - Top);
        end;
        with DrawBitmap.Canvas do begin
             Font := ACanvas.Font;
             Font.Color := ACanvas.Font.Color;
             Brush := ACanvas.Brush;
             Brush.Style := bsSolid;
             FillRect(B);
             SetBkMode(Handle, TRANSPARENT);
             if (ACanvas.CanvasOrientation = coRightToLeft) then ChangeBiDiModeAlignment(Alignment);
             DrawText(Handle, PChar(Text), Length(Text), R, AlignFlags[Alignment] or RTL[ARightToLeft]);
        end;
        if (ACanvas.CanvasOrientation = coRightToLeft) then begin
           Hold := ARect.Left;
           ARect.Left := ARect.Right;
           ARect.Right := Hold;
        end;
        ACanvas.CopyRect(ARect, DrawBitmap.Canvas, B);
    finally
        DrawBitmap.Canvas.Unlock;
    end;
  end;
end;

procedure TDBTabGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var Value: string;

  function RowIsMultiSelected: Boolean;
  var Index:Integer;
  begin
    Result:=(dgMultiSelect in Options) and Datalink.Active and SelectedRows.Find(Datalink.Datasource.Dataset.Bookmark, Index);
  end;

begin
  if Assigned(OnDrawColumnCell)
  then OnDrawColumnCell(Self, Rect, DataCol, Column, State)
  else begin // DefaultDrawColumnCell
         Value:='';
         if (Assigned(Column.Field)) and (Column.Field.Visible) then value:=Column.Field.DisplayText;
         if RowIsMultiSelected and not (gdSelected in State) then Canvas.Brush.Color:=clBlue; // hellblau
//         WriteText(Canvas, Rect, 2, 2, Value, Column.Alignment, UseRightToLeftAlignmentForField(Column.Field, Column.Alignment));
         WriteText(Canvas, Rect, 2, 2, Value, Column.Alignment, false);
  end;
end;

procedure TDBTabGrid.SetShowArrow(value:Boolean);
begin
  if value<>FShowArrow then begin
     FShowArrow:=value;
     InvalidateTitles;
  end;
end;

procedure TDBTabGrid.SetSortColumn(value:string);
begin
  if value<>FSortColumn then begin
     FSortColumn:=value;
     InvalidateTitles;
  end;
end;

procedure TDBTabGrid.SetSortDesc(value:Boolean);
begin
  if value<>FSortDesc then begin
     FSortDesc:=value;
     InvalidateTitles;
  end;
end;

procedure TDBTabGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var x:integer;

  procedure PaintArrowUp;
  var SaveCol : TColor;
  begin
{
    with Canvas do begin
         SaveCol:=Pen.Color;
         Pen.Color:=clGray;
         MoveTo(aRect.Right-10, aRect.Top+11);
         LineTo(aRect.Right-7, aRect.Top+5);
         Pen.Color:=clWhite;
         MoveTo(aRect.Right-6, aRect.Top+5);
         LineTo(aRect.Right-3, aRect.Top+11);
         LineTo(aRect.Right-10, aRect.Top+11);
         Pen.Color:=SaveCol;
    end;
}
    with Canvas do begin
         SaveCol:=Pen.Color;
         Pen.Color:=clGray;
         MoveTo(aRect.Right-9, aRect.Top+10);
         LineTo(aRect.Right-6, aRect.Top+7);
         LineTo(aRect.Right-3, aRect.Top+10);
         LineTo(aRect.Right-9, aRect.Top+10);
         Pixels[aRect.Right-6,aRect.Top+8]:=clGray;
         Pixels[aRect.Right-5,aRect.Top+9]:=clGray;
         Pixels[aRect.Right-6,aRect.Top+9]:=clGray;
         Pixels[aRect.Right-7,aRect.Top+9]:=clGray;
         Pen.Color:=SaveCol;
    end;
  end;

  procedure PaintArrowDown;
  var SaveCol : TColor;
//      APolyLine: array[0..2] of TPoint;
  begin
{
    with Canvas do begin
         SaveCol:=Pen.Color;
         Pen.Color:=clGray;
         MoveTo(aRect.Right-3, aRect.Top+5);
         LineTo(aRect.Right-10, aRect.Top+5);
         LineTo(aRect.Right-7, aRect.Top+11);
         Pen.Color:=clWhite;
         MoveTo(aRect.Right-6, aRect.Top+11);
         LineTo(aRect.Right-3, aRect.Top+5);
         Pen.Color:=SaveCol;
    end;
}
    with Canvas do begin
         SaveCol:=Pen.Color;
         Pen.Color:=clGray;
         MoveTo(aRect.Right-9, aRect.Top+7);
         LineTo(aRect.Right-3, aRect.Top+7);
         LineTo(aRect.Right-6, aRect.Top+10);
         LineTo(aRect.Right-9, aRect.Top+7);
         Pixels[aRect.Right-5,aRect.Top+8]:=clGray;
         Pixels[aRect.Right-6,aRect.Top+8]:=clGray;
         Pixels[aRect.Right-7,aRect.Top+8]:=clGray;
         Pixels[aRect.Right-6,aRect.Top+9]:=clGray;
         Pen.Color:=SaveCol;
    end;
  end;

begin
  x:=aCol;
  inherited DrawCell(ACol, ARow, ARect, AState);

  if FShowArrow and (dgTitles in Options) and (FSortColumn<>'') and (aRow<1) then begin
     if (dgIndicator in Options) then x:=x-1;
     if (x>-1) and (Columns[x].Fieldname=FSortColumn) then
        if FSortDesc
        then PaintArrowDown
        else PaintArrowUp;
  end;
end;

END.

