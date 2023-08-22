unit SortGrid;

{*******************************************************************************
*        TSortGrid 2.00 (02-08-2001)                                           *
*        freeware component for Delphi 2-6 by Karsten Bendsen.                 *
*        Original Author:  Bill Menees                                         *
*                                                                              *
*        compiles under Lazarus 0.9.28.2                                       *
*     But still known bugs:                                                    *
*        - throws SIGSEGV on termination                                       *
*        - exception in the code part where the grid lines are drawn           *
*                                                                              *
*  If You can fix these left bugs, please reply to BREAKOUTBOX at web DE       *
*  ATM I don't urgently need this component so I don't continue debugging ..   *
*  2010-08-04                                                                  *
*******************************************************************************}

interface

uses
  ExtCtrls, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MyGrids, Printers, Menus, Registry, contnrs;

type
  TPrintMode = (pmPrint, pmPreview, pmPageCount);
  TMyPrintRange = (prAll, prSelected);
  TSortStyle = (ssAutomatic, ssNormal, ssNumeric, ssNumericExtended, ssDateTime, ssTime, ssCustom);
  TSortCustom = function (const Str1, Str2: String): Integer;
  TSortDirection = (sdAscending, sdDescending);

  TSetChecked = procedure(Sender: TObject; ACol, ARow: integer; State: Boolean) of object;
  TGetCombobox = procedure(Sender: TObject; ACol, ARow: integer; var Strs: TStringList; var Width, Height: integer; var Sorted: Boolean) of object;
  TSetCombobox = procedure(Sender: TObject; ACol, ARow: integer; Str: String) of object;
  TSetEllipsis = procedure(Sender: TObject; ACol, ARow: integer) of object;

  TSortOptions = class(TPersistent)
  private
    fSecondaryIndex: String;
    fCanSort: Boolean;
    fSortStyle: TSortStyle;
    fSortCaseSen: Boolean;
    fSortCol: Integer;
    fSortDirection: TSortDirection;
    fSortCustom: TSortCustom;
    fUpdateOnSizeChange: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    property SortCustom: TSortCustom read fSortCustom write fSortCustom;  //Used only if SortStyle = ssCustom.
  private
  published
    property CanSort: Boolean read fCanSort write fCanSort;
    property SecondaryIndex: String read fSecondaryIndex write fSecondaryIndex;
    property SortStyle: TSortStyle read fSortStyle write fSortStyle;
    property SortCaseSensitive: Boolean read fSortCaseSen write fSortCaseSen;
    property SortCol: Integer read fSortCol write fSortCol;
    property SortDirection: TSortDirection read fSortDirection write fSortDirection;
    property UpdateOnSizeChange: Boolean read fUpdateOnSizeChange write fUpdateOnSizeChange;
  end;

  TPrintOptions = class(TPersistent)
  private
    fJobTitle: String;
    fPageTitle: String;
    fCopies: Cardinal;
    fPrintRange: TMyPrintRange;
    fPreviewPage,fFromRow, fToRow: Cardinal;
  protected
  public
  private
  published
    property JobTitle: string read fJobTitle write fJobTitle;
    property PageTitle: string read fPageTitle write fPageTitle;
    property Copies: Cardinal read fCopies write fCopies default 1;
    property PrintRange: TMyPrintRange read fPrintRange write fPrintRange;
    property FromRow: Cardinal read fFromRow write fFromRow;
    property ToRow: Cardinal read fToRow write fToRow;
    property PreviewPage: Cardinal read fPreviewPage write fPreviewPage;
  end;

  TSortedListEntry = record
    Str: String;
    RowNum: integer;
    SortOption: TSortOptions;
  end;
  PSortedListEntry = ^TSortedListEntry;
  TSortedList = class(TList)
  public
    function GetItem(const I: Integer): PSortedListEntry;
    procedure Reset;
  end;

  TCellBevelStyle = (cbNone, cbRaised, cbLowered);
  {*** NOTE: This is one of the structures in TFormatOptions.}
  TCellBevel = record
      Style: TCellBevelStyle;
      UpperLeftColor: TColor;
      LowerRightColor: TColor;
  end;
  TVertAlignment = (taTopJustify, taBottomJustify, taMiddle);
  {*** NOTE: These are the display options you can set for each cell in OnGetCellFormat.}
  TFormatOptions = record
      Brush: TBrush;
      Font: TFont;
      AlignmentHorz: TAlignment;
      AlignmentVert: TVertAlignment;
      Bevel: TCellBevel;
      HideText: Boolean;
  end;

  TFontSetting = class(TObject)
  public
      FontColor,BackColor: TColor;
      Bold,Italic,UnderLine: Boolean;
      Valid: Boolean;
  end;

  TFontList = class(TObjectList)
  private
    function GetItem(Index: Integer): TFontSetting;
    procedure SetItem(Index: Integer; const Value: TFontSetting);
  public
    property Items[Index: Integer]: TFontSetting read GetItem write SetItem; default;
    procedure ChangeCount(Number: integer);
  end;

  //New event types
  TFormatDrawCellEvent = procedure(Sender: TObject; Col, Row: integer; State: TGridDrawState; var FormatOptions: TFormatOptions; var CheckBox, Combobox, Ellipsis: Boolean) of object;
  TSetFilterEvent = procedure(ARows: TStrings; var Accept: Boolean) of object;
  TSearchEvent = procedure(ARows: TStrings; var Accept: Boolean) of object;
  TUpdateGridEvent = procedure(Sender: TObject; ARow: integer) of object;
  TSizeChangedEvent = procedure(Sender: TObject; OldColCount, OldRowCount: integer) of object;
  TBeginSortEvent = procedure(Sender: TObject; var Col: integer) of object;
  TEndSortEvent = procedure(Sender: TObject; Col: integer) of object;
  TGetSortStyleEvent = procedure(Sender: TObject; Col: integer; var SortStyle: TSortStyle) of object;
  TCellValidateEvent = procedure(Sender: TObject; ACol, ARow: integer; const OldValue: string; var NewValue: String; var Valid: Boolean) of object;


  TSortGrid = class(TMyStringGrid) //class(TMyStringGrid)
  private
    ColFontList: TFontList;
    RowFontList: TFontList;
    DrawColBeforeRow: Boolean;
    FFilterCount: integer;

    BitmapUp, BitmapDown: TBitmap;
    FSortOptions: TSortOptions;
    FFixedRows: Integer;
    FPrintOptions: TPrintOptions;
    FMouseDownRow: Integer;
    FMouseDownCol: Integer;
    FUpdateSelected: Boolean;
    OldUpdateSize: Boolean;
    FDragPoint: TPoint;
    FDragging: Boolean;

    FUserSettings: TStringList;
    FMultiSelect: Boolean;
    fOriginRowCount:integer;

    FHideRows: Boolean;
    FPopupMenu: TPopupMenu;
    fFiltered: Boolean;
    fSortedList: TSortedList;
    fAlignmentHorz: TAlignment;
    fAlignmentVert: TVertAlignment;
    fClickSorting: Boolean;
    fBevelStyle: TCellBevelStyle;
    fProportionalScrollBars: Boolean;
    fExtendedKeys: Boolean;
    fDisableModify: Boolean;
    fSorting: Boolean;
    fModified: Boolean;
    fOldCellText: String;
    fOldCol, fOldRow: integer;
    fOldModifiedValue: Boolean;
    fEntered: Boolean;
    fOnGetCellFormat: TFormatDrawCellEvent;
    fOnSetFilter: TSetFilterEvent;
    fOnSearch: TSearchEvent;
    fOnModified: TNotifyEvent;
    fOnRowSelected: TNotifyEvent;
    fOnRowInsert: TUpdateGridEvent;
    fOnRowDelete: TUpdateGridEvent;
    fOnColumnInsert: TUpdateGridEvent;
    fOnColumnDelete: TUpdateGridEvent;
    fOnColumnWidthsChanged: TNotifyEvent;
    fOnRowHeightsChanged: TNotifyEvent;
    fOnSizeChanged: TSizeChangedEvent;
    fOnEndUpdate: TNotifyEvent;
    fOnBeginSort: TBeginSortEvent;
    fOnEndSort: TEndSortEvent;
    fOnGetSortStyle: TGetSortStyleEvent;
    fOnCellValidate: TCellValidateEvent;

    fPageCount: Cardinal;
    fOnSetChecked: TSetChecked;
    fOnGetCombobox: TGetCombobox;
    fOnSetCombobox: TSetCombobox;
    fOnSetEllipsis: TSetEllipsis;
    ListBox: TListBox;
    fSelectedRows: TStringList;
    fLastRows: TStrings;
    fRangeSet: Boolean;
    FHideRow: Boolean;

    procedure InitValidate;
    procedure ValidateCell;
    function GetColFont(ACol: integer): TFontSetting;
    procedure SetColFont(ACol: integer; FontSet: TFontSetting);
    function GetRowFont(ARow: integer): TFontSetting;
    procedure SetRowFont(ARow: integer; FontSet: TFontSetting);
    function FontSettingToStr(FontSet: TFontSetting):string;
    function StrToFontSetting(Str: string):TFontSetting;
    function ParentForm: TForm;
    procedure SetAlignmentHorz(Value: TAlignment);
    procedure SetAlignmentVert(Value: TVertAlignment);
    procedure SetBevelStyle(Value: TCellBevelStyle);
    procedure WM_Size(var Msg: TWMSize); message WM_SIZE;
    procedure SetProportionalScrollBars(Value: Boolean);
    procedure DrawToCanvas(ACanvas: TCanvas; Mode: TPrintMode; FromRow, ToRow: Integer);
    function Search(ARow: Integer): integer;
    function GetChecked(ACol, ARow: Integer): Boolean;
    procedure SetChecked(ACol, ARow: Integer; const Value: Boolean);
    function GetComboBox(ACol, ARow: Integer): Boolean;
    procedure ListBoxOnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListBoxOnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListBoxOnExit(Sender: TObject);
    function GetCellDrawState(const ACol, ARow: integer): TGridDrawState;

    function GetRowSelected(ARow: Integer): Boolean;
    procedure SetRowSelected(ARow: Integer; const Value: Boolean);
    procedure DeSelectAll;
    function GetColCommaText(ACol: Integer; UpdateRowCnt: Boolean): string;
    procedure SetColCommaText(ACol: Integer; UpdateRowCnt: Boolean; const Value: string);
    procedure SetModified(const Value: Boolean);
    procedure SetUserSettings(const Value: TStringList);
    function ResizingCol(X, Y: integer): boolean;

    procedure SetHideRows(Value: Boolean);
    procedure SetFiltered(Value: Boolean);

    procedure UpdateScrollPage;
    procedure SetMultiSelect(const Value: Boolean);

    function GetStringsToSave(SaveWidth: Boolean): TStrings;
    function SetStringsFromLoad(List1: TStrings; RestoreWidth: Boolean): Boolean;
  protected
    function SelectCell(ACol, ARow: integer): Boolean; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;

    procedure ColumnMoved(FromIndex, ToIndex: Integer); override;
    procedure SetSortOptions(value: TSortOptions);
    procedure SizeChanged(OldColCount, OldRowCount: integer); override;
    procedure DrawCell(ACol, ARow: integer; ARect: TRect; AState: TGridDrawState); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function DetermineSortStyle(const ACol: integer): TSortStyle;
    procedure InitializeFormatOptions(ACol,ARow: Integer; var FmtOpts: TFormatOptions; var CheckBox, Combobox, Ellipsis: Boolean);
    procedure ColWidthsChanged; override;
    procedure RowHeightsChanged; override;

    procedure SetEditText(ACol, ARow: integer; const Value: string); {$IFNDEF FPC}override;{$ENDIF}

    procedure Click; override;
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    //How may records are hidden by filter
    property FilterCount: integer read FFilterCount;

    //Get/set how a column should be painted
    property ColFont[ACol: integer]: TFontSetting read GetColFont write SetColFont;
    //Get/set how a row should be painted
    property RowFont[ARow: integer]: TFontSetting read GetRowFont write SetRowFont;

    //Load grid from a file, LoadWidth tells if the column and grid width should be restored
    function LoadFromFile(const FileName: String; RestoreWidth: Boolean): Boolean;
    //Save grid to a file, LoadWidth tells if the column and grid width should be stored
    procedure SaveToFile(const FileName: String; SaveWidth: Boolean);
    //Load grid from registry, only text is restored
    procedure LoadFromReg(RegRoot: HKey; RegKey, RegName: String; RestoreWidth: Boolean);
    //Save grid to registry
    procedure SaveToReg(RegRoot: HKey; RegKey, RegName: String; SaveWidth: Boolean);
    //Save grid as comma separated text
    procedure SaveToCSV(const FileName: String);

    //CommaText is a bit buggy the way I see it. Use the property to retrive or set all cell values in a column
    property ColCommaText[ACol: Integer; UpdateRowCnt: Boolean]: string read GetColCommaText write SetColCommaText;

    //See if row is checked or set if row should be checked
    property CellChecked[ACol, ARow: Integer]: Boolean read GetChecked write SetChecked;

    //See if row is selected or set if row should be selected
    property RowSelected[ARow: Integer]: Boolean read GetRowSelected write SetRowSelected;
    //Which rows is selected
    property SelectedRows: TStringList read fSelectedRows;
    //If you want to retrive the rows in ascending order, call SortRowsSel before reading SelectedRows
    procedure SortRowsSel;
    //How many rows is selected
    function SelCount: Integer;

    //Sort the column
    procedure SortColumn(ACol: integer);
    //The grid is being sorted
    property Sorting: Boolean read fSorting;

    //Is the grid modified. Property is read/write, but it should not be necessary to write the property.
    property Modified: Boolean read fModified write SetModified;

    //Clears all values for the grid, don't clear column headers
    procedure Clear;

    //Repaint a row
    procedure InvalidateRow(ARow: integer);
    //Repaint a col
    procedure InvalidateCol(ACol: integer);
    //Call this to stop repainting of the grid, when doing updates like changing cell values.
    procedure BeginUpdate; override;
    //Tell the grid that you are done.
    procedure EndUpdate; override;

    //Set selected cell to match ACol, ARow. If MakeVisible the grid is scroll'ed so the cell is visible
    procedure MoveTo(ACol, ARow: integer; MakeVisible: Boolean=True);
    //The grid is scroll'ed so the cell is visible
    procedure FocusColRow(ACol, ARow: integer);
    //Returns column number of column that matches Header
    function FindCol(Header: String): Integer;
    //Returns row number of row that matches value
    function FindRow(ACol: integer; Value: string; CaseSensitive: boolean = False): integer;
    //Returns row number of row that is accepted in the OnSearch event
    function FindFirst(var ARow: integer): boolean;
    //Returns next row after current row that is accepted in the OnSearch event    
    function FindNext(var ARow: integer): boolean;
    //Is all cells in a row empty
    function RowEmpty(ARow: Integer): Boolean;

    //Autosize a column to fit the text width. If AlwaysSize hidden columns are made visible and autosized
    procedure AutoSizeColumns(AlwaysSize: Boolean=False);
    //Autosize all columns
    procedure AutoSizeCol(const ACol: integer; AlwaysSize: Boolean=True );

    procedure DeleteRow(ARow: integer); override;
    procedure DeleteColumn(ACol: integer); override;
    procedure MoveRow(FromIndex, ToIndex: integer);
    procedure MoveColumn(FromIndex, ToIndex: integer);
    procedure SwapRows(ARow1, ARow2: integer);
    procedure SwapColumns(ACol1, ACol2: integer);
    //Append a row, can be used when the grid is filtered
    procedure AddRow(ACells: TStrings);
    //Insert a row at a specific place, don't use when grid filtered
    procedure InsertRow(ARow: integer);
    //Append a column
    procedure AddCol(Header: string);
    //Insert a column at a specific place
    procedure InsertColumn(ACol: integer);

    //Searching all rows for FindValue in the FindCol. If a match is found the SetCol in this row
    //is updated with SetValue.  UpdateAll says if the function should terminate after first update.
    function UpdateCell(FindValue: string; FindACol: integer; SetValue: string; SetCol: integer;
                        UpdateAll: boolean): boolean;

    procedure Print;
    procedure PrintPreview(Image: TImage);
    function PageCount: Integer;
  published
    property FixedRows: Integer read fFixedRows default 1;
    property PopupMenu: TPopupMenu read fPopupMenu write fPopupMenu;
    property SortOptions: TSortOptions read fSortOptions write SetSortOptions;
    property PrintOptions: TPrintOptions read fPrintOptions write fPrintOptions;
    //Hide/Show all rows, the grid appears empty if rows hidden
    property HideRows: Boolean read FHideRow write SetHideRows;
    //Toggle if the grid should appear as filter, the grid is filtered according to SetFilter event
    property Filtered: Boolean read fFiltered write SetFiltered;
    //Support real multiselect with shift, ctrl
    property MultiSelect: Boolean read fMultiSelect write SetMultiSelect;
    //Read or set settings associated with a file, they are saved/loaded with SaveTo/LoadFrom File
    property UserSettings: TStringList read fUserSettings write SetUserSettings;
    //How should text appear in the cells
    property AlignmentHorz: TAlignment read fAlignmentHorz write SetAlignmentHorz;
    property AlignmentVert: TVertAlignment read fAlignmentVert write SetAlignmentVert;
    property BevelStyle: TCellBevelStyle read fBevelStyle write SetBevelStyle;
    //Doesn't work
    property ProportionalScrollBars: Boolean read fProportionalScrollBars write SetProportionalScrollBars;
    //Use Insert/Delete to add/remove a row
    property ExtendedKeys: Boolean read fExtendedKeys write fExtendedKeys;

    property OnModified: TNotifyEvent read fOnModified write fOnModified;
    property OnRowSelected: TNotifyEvent read fOnRowSelected write fOnRowSelected;
    property OnRowInsert: TUpdateGridEvent read fOnRowInsert write fOnRowInsert;
    property OnRowDelete: TUpdateGridEvent read fOnRowDelete write fOnRowDelete;
    property OnColumnInsert: TUpdateGridEvent read fOnColumnInsert write fOnColumnInsert;
    property OnColumnDelete: TUpdateGridEvent read fOnColumnDelete write fOnColumnDelete;
    property OnColumnWidthsChanged: TNotifyEvent read fOnColumnWidthsChanged write fOnColumnWidthsChanged;
    property OnRowHeightsChanged: TNotifyEvent read fOnRowHeightsChanged write fOnRowHeightsChanged;
    property OnSizeChanged: TSizeChangedEvent read fOnSizeChanged write fOnSizeChanged;
    //Use this to select color, font etc for each cell
    property OnGetCellFormat: TFormatDrawCellEvent read fOnGetCellFormat write fOnGetCellFormat;
    //What rows are accepted when filtering
    property OnSetFilter: TSetFilterEvent read fOnSetFilter write fOnSetFilter;
    //Alot like OnSetFilter event, just with search function
    property OnSearch: TSearchEvent read fOnSearch write fOnSearch;
    //An update has ended, meaning that must likely there are new data in the grid, rowcount etc. may have changed
    property OnEndUpdate: TNotifyEvent read fOnEndUpdate write fOnEndUpdate;
    //Decide the sortstyle runtime
    property OnGetSortStyle: TGetSortStyleEvent read fOnGetSortStyle write fOnGetSortStyle;
    //Accept user input when editing a cell
    property OnCellValidate: TCellValidateEvent read fOnCellValidate write fOnCellValidate;
    //A checkbox was checked or unchecked in a cell
    property OnSetChecked: TSetChecked read fOnSetChecked write fOnSetChecked;
    //What strings should be displayed in a cell which acts as a combobox
    property OnGetComboBox: TGetComboBox read fOnGetComboBox write fOnGetComboBox;
    //User selection froom the combobox
    property OnSetComboBox: TSetComboBox read fOnSetComboBox write fOnSetComboBox;
    //User clicked on a cell with a button
    property OnSetEllipsis: TSetEllipsis read fOnSetEllipsis write fOnSetEllipsis;
  end;

  procedure Register;
  function ExtendedCompare(const Str1, Str2: String): Integer;
  function NormalCompare(const Str1, Str2: String): Integer;
  function DateTimeCompare(const Str1, Str2: String): Integer;
  function NumericCompare(const Str1, Str2: String): Integer;
  function TimeCompare(const Str1, Str2: String): Integer;
  function Compare(Item1, Item2: Pointer): Integer;

implementation

const
   FontColSettings = 'FontColSettings';
   FontRowSettings = 'FontRowSettings';   
   GenerelSettings = 'GenerelSettings';
   CustomSettings = 'UserSettings';

{$R SortGrid.Res}

{*****Misc Non-Member Functions************************************************}

constructor TSortOptions.Create;
begin
  fSortDirection := sdAscending;
  fSortCol := 0;
  fSortStyle := ssNormal;
  fSortCaseSen := False;
  fCanSort := True;
end;

destructor TSortOptions.Destroy;
begin
  inherited Destroy;
end;

constructor TSortGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUserSettings := TStringList.Create;
  FFilterCount := 0;
  FDragging:= False;
  FDragPoint.X := -1;
  fSortedList:=TSortedList.Create;
  fAlignmentHorz:=taLeftJustify;
  fAlignmentVert:=taTopJustify;
  fClickSorting:=True;
  fBevelStyle:=cbNone;
  fExtendedKeys:=False;
  fDisableModify:=False;
  Modified:=False;
  fMouseDownCol := -1;
  fEntered:=False;
  FUpdateSelected:= True;
  FixedCols:=0;
  frangeset:=False;

  InitValidate;

  fOriginRowCount:=RowCount;

  ColFontList := TFontList.Create;
  RowFontList := TFontList.Create;
  ColFontList.ChangeCount(ColCount);
  RowFontList.ChangeCount(RowCount);

  fLastRows := TStringList.Create;
  fLastRows.Add( IntToStr(Row));
  fSelectedRows := TStringList.Create;
  fSelectedRows.Add( IntToStr(Row) );

  fSortOptions := TSortOptions.Create;
  fPrintOptions := TPrintOptions.Create;

  BitMapUp := TBitMap.Create;
  BitMapDown := TBitMap.Create;
  BitMapUp.LoadFromResourceName(HInstance,'UP');
  BitMapDown.LoadFromResourceName(HInstance,'DOWN');

  ListBox:= TListBox.Create(Self);
  {$IFDEF FPC}
  ListBox.OnMouseUp:= @ListBoxOnMouseUp;
  ListBox.OnKeyUp:= @ListBoxOnKeyUp;
  ListBox.OnExit := @ListBoxOnExit;
  {$ELSE}
  ListBox.OnMouseUp:= ListBoxOnMouseUp;
  ListBox.OnKeyUp:= ListBoxOnKeyUp;
  ListBox.OnExit := ListBoxOnExit;
  {$ENDIF}
  ListBox.Sorted := True;
  ListBox.TabStop:= False;
  ListBox.Hide;
end;


destructor TSortGrid.Destroy;
begin
  FUserSettings.Free;
  fSortedList.Reset;
  fSortedList.Free;
  fLastRows.Free;
  fSelectedRows.Free;
  BitmapUp.Free;
  BitmapDown.Free;
  ColFontList.Free;
  RowFontList.Free;
//  ListBox.Free;  //why does this causes an error?, but only after the listbox has been displayed???
  inherited Destroy;
end;


{******Misc********************************************************************}
function TSortGrid.ParentForm: TForm;
begin
  Result:= GetParentForm(Self) as TForm;
end;


function TSortGrid.GetColCommaText(ACol: Integer; UpdateRowCnt: Boolean): string;
var
  Strs: TStringList;
begin
  Strs:= TStringlist.Create;
  Strs.AddStrings( Cols[ACol] );
  if Strs[ Strs.Count-1 ] = '' then
    Strs.Add('');

  Result:= Strs.CommaText;
  Strs.Free;
end;


procedure TSortGrid.SetColCommaText(ACol: Integer; UpdateRowCnt: Boolean; const Value: string);
var
  i: Integer;
  Strs: TStringList;
begin
  Strs:= TStringlist.Create;
  Strs.CommaText:= Value;
  //Set Rowcount
  if (Strs.Count>1)and (UpdateRowCnt) then
    RowCount:= Strs.Count;
  //Set value
  for i:= 0 to Strs.Count-1 do
    Cells[ACol,i]:= Strs[i];
  Strs.Free;
end;


procedure TSortGrid.SetMultiSelect(const Value: Boolean);
begin
  fMultiSelect := Value;
  if Value then
    Options := Options+[goRowSelect];
end;


{******Misc OnEvent************************************************************}

procedure TSortGrid.ColumnMoved(FromIndex, ToIndex: Integer);
var
  ACol: integer;
begin
  //Swap ColFontArray settings
  ColFontList.Exchange(FromIndex, ToIndex);

  Modified := True;

  ACol := SortOptions.fSortCol;
  if (ACol = FromIndex) then
      SortOptions.fSortCol := ToIndex                    //SoctCol flyttes hertil
  else if (ACol >= ToIndex) and (ACol <= FromIndex) then //SortCol flyttes mod højre
      SortOptions.fSortCol := SortOptions.fSortCol+1
  else if (ACol <= ToIndex) and (ACol >= FromIndex) then //SortCol flyttes mod venstre
      SortOptions.fSortCol := SortOptions.fSortCol-1;

  inherited ColumnMoved(FromIndex,ToIndex);
end;


function TSortGrid.SelectCell(ACol, ARow: Integer): Boolean;
var
  Dummy: TFormatOptions;
  CheckBox, ComboBox, Ellipsis: Boolean;
begin
  if EditorMode then  //må ikke kunne vælge cell hvis i editormode!
  begin
      //Er cellen combobox/picklist?
      InitializeFormatOptions(ACol,ARow, Dummy, CheckBox, ComboBox, Ellipsis);

      if ComboBox then
      begin
          GetComboBox(ACol, ARow);
          if ( GetKeyState(VK_TAB) < 0{Tab key}) and
             (ACol < ColCount-2) and (SelectCell(ACol+1, ARow)) then  Col := ACol+1;
      end;

      if ComboBox or CheckBox then
          Result := False
      else
          Result := inherited SelectCell(ACol, ARow);
  end
  else
      Result := inherited SelectCell(ACol, ARow);

  if Result and FUpdateSelected then
  begin
    DeSelectAll;
    fSelectedRows.Add( IntToStr(ARow) );
    fLastRows[0] := IntToStr(ARow);
    if Assigned(FOnRowSelected) then OnRowSelected(Self);
  end;

  //invalidate row currently selected can't know if has combobox or checkbox
  InvalidateRow(Row);
  InvalidateRow(ARow);
end;


procedure TSortGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
//MultiSelect
  if fMultiSelect and not EditorMode then
  begin
    FUpdateSelected:= False;//se selectcell
    if key = VK_SHIFT then
    begin
        Options := Options+[goRangeSelect];
        DeselectAll;//sletter alt undtaget rangeselected
    end
    else if ssShift in Shift then
    begin
      fLastRows[0] := IntToStr(Row);//***
    end
    else if ((Key=VK_HOME) or (Key=VK_END) or (Key=VK_PRIOR) or (Key=VK_NEXT) or
        (Key=VK_UP) or (Key=VK_DOWN) or (Key=VK_LEFT) or (Key=VK_RIGHT) ) then
      FUpdateSelected:= True;//"Kalder" SelectCell
  end;

//Extended Keys
  if ExtendedKeys and not EditorMode then
  begin
    if Shift = [ssCtrl] then
    begin
      case Key of
        VK_INSERT: InsertRow(Row);
        VK_DELETE: if RowCount > 2 then DeleteRow(Row);
      end;
    end
    else if Shift = [ssCtrl, ssShift] then
    begin
      case Key of
        VK_INSERT: InsertColumn(Col);
        VK_DELETE: if ColCount > 1 then DeleteColumn(Col);
      end;
    end;
  end;
  inherited KeyDown(Key, Shift);
end;

procedure TSortGrid.KeyUp(var Key: Word; Shift: TShiftState);
var
  Dummy: TFormatOptions;
  CheckBox, ComboBox, Ellipsis: Boolean;
  i: Integer;
begin
  //do some stuff if cell is a checkbox, listbox or ellipsis when space hitted
  if Key = VK_SPACE then
  begin
      InitializeFormatOptions(Col,Row, Dummy, CheckBox, ComboBox, Ellipsis);
      if ComboBox then
          if not GetCombobox(Col, Row) then//Clicked on field without compobox and listbox should perhaps be hidden
              ListBox.Hide;
      if CheckBox then
          CellChecked[Col,Row] := not CellChecked[Col,Row];
      if Ellipsis then
          OnSetEllipsis(Self, Col, Row);
  end;

  if fMultiSelect and not EditorMode then
  begin
    FUpdateSelected:= True;
    if Key = VK_SHIFT then
    begin
       if fSelectedRows.Count = 0 then//I'm not quite sure why I'm doing this//****
       //If cnt=0 rangeselect is enabled (I guess) so make sure one row is selected seems like a good idea
       begin
        DeSelectAll;
        fLastRows.Delete(0);
        for i := Selection.Top to Selection.Bottom do
        begin
            fSelectedRows.Add( IntToStr(i));
            fLastRows.Add(IntToStr(i));
        end;
       end;
    end
    else if ((Key=VK_HOME) or (Key=VK_END) or (Key=VK_PRIOR) or (Key=VK_NEXT) or
        (Key=VK_UP) or (Key=VK_DOWN) or (Key=VK_LEFT) or (Key=VK_RIGHT) ) and not (ssShift in Shift) then
    begin
        DeSelectAll;
        fLastRows.Delete(0);
        for i := Selection.Top to Selection.Bottom do
        begin
            fSelectedRows.Add( IntToStr(i));
            fLastRows.Add(IntToStr(i));
        end;
        Options := Options-[goRangeSelect];
    end;

    if (Assigned(fOnRowSelected)) and not EditorMode then
       OnRowSelected(Self);
  end;
end;

procedure TSortGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    ARow, ACol: Integer;
    AColLeft: Integer;
begin
    ListBox.Hide;  //Hide Listbox always

    MouseToCell(x,y,ACol,ARow);
    if ARow = -1 then ARow := RowCount-1;

    fMouseDownCol := ACol;//If col changes betweem mouse Up&Down, don't sort, bacause col has been moved

    fMouseDownRow := ARow;//Bruges til noget med getCellStyle

    //Hvis selected nedenunder måske drag'n'drop hvis ikke vælges den ved mouseup
    if (ARow > 0) and (fMultiSelect) and (Shift=[ssLeft]) and not (GetRowSelected(ARow)) and not EditorMode then
    begin
       Options := Options-[goRangeSelect];
       Row := ARow;
       DeSelectAll;
       fLastRows[0] := IntToStr(ARow);
       fSelectedRows.Add( IntToStr(ARow));
       if Assigned(fOnRowSelected) then
          OnRowSelected(Self);
    end;

    if (GetRowSelected(ARow)) and (ARow > 0) then//kun hvis valgt row kan drag begyndes
       FDragPoint := Point(X,Y);

    //MultiSelect                      only when using shift + mousedown   or   Editing so cell editor can be moved or Row 0 selected to drag and resize col
    if (fMultiSelect = False) or ((goRangeSelect in Options) and (Shift=[ssLeft,ssShift])) or EditorMode or (ARow = 0) then
        inherited MouseDown(Button,Shift,X,Y);

    //Autosizeclick
    if (Button = mbLeft) and (ssDouble in Shift) and (ARow = 0) and ResizingCol(X,Y) then
    begin
        //ACol changes depening on you are to the left or right of the edge betweem two cells
        //Therefore it is neccesary to check both cells to see if the cursor is betweem two cells
        AColLeft := CellRect(ACol,0).Right;
        if (AColLeft <= X+3) and (AColLeft >= X-3) then
            AutoSizeCol(ACol)
        else if ACol > 0 then
        begin
            AColLeft := CellRect(ACol-1,0).Right;
            if (AColLeft <= X+3) and (AColLeft >= X-3) then
                AutoSizeCol(ACol-1);
        end;
    end;

    //?
    if (Button = mbLeft) and (ssDouble in Shift) and Assigned(OnDblClick) then
        OnDblClick(Self);
end;

procedure TSortGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i,ARow,ACol: integer;

  procedure GetCellStyle;
  var
    Dummy: TFormatOptions;
    CheckBox, ComboBox, Ellipsis: Boolean;
  begin
    if (FMouseDownCol = ACol) and (FMouseDownRow = ARow) and (ARow > 0) then
    begin
      InitializeFormatOptions(ACol,ARow, Dummy, CheckBox, ComboBox, Ellipsis);
      //Checkbox, just toggle the selection setchecked procedure see if the cell is a checkbox
      if CheckBox then
        CellChecked[ACol,ARow] := not CellChecked[ACol,ARow];

      if ComboBox then
        if not GetCombobox(ACol, ARow) then//Clicked on field without compobox and listbox should perhaps be hidden
          ListBox.Hide;

      i := CellRect(ACol, ARow).Right;//Angiver højre side af cell
      if (Ellipsis) and (X >= i-16) and (X <= i) and Assigned(fOnSetEllipsis) then
        OnSetEllipsis(Self, ACol, ARow);
    end;
  end;

begin
  if FDragging then Exit;
  FDragPoint.X := -1;
  SetFocus;  //Doesn't happend automaticly

  inherited MouseUp(Button,Shift,X,Y);

  MouseToCell(X,Y,ACol,ARow);

  if (Button = mbRight) and (ARow <> 0) and (FPopupMenu <> nil) then
      FPopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);

  //Determine and handles if the cell if Checkbox, Combobox or Ellipsis
  GetCellStyle;

  //SortClick
  if (ARow = 0) and (ACol = fMouseDownCol) and not ResizingCol(X,Y) then
  begin
    if (SortOptions.SortDirection = sdAscending) and (SortOptions.fSortCol = ACol) then
      SortOptions.fSortDirection := sdDescending
    else
      SortOptions.fSortDirection := sdAscending;
    if Button = mbRight then
      SortOptions.fSortDirection := sdDescending;

    SortColumn(ACol);
    Exit;
  end;

  //Exit ved column resize
  if (ARow = 0) or (fMouseDownRow = 0) then Exit;

  if ARow = -1 then ARow := RowCount-1;

  //Multiselect
  if fMultiSelect and not EditorMode and (Button = mbLeft) then
  begin
    if ssCtrl in Shift then
    begin
          if fSelectedRows.IndexOf( IntToStr(ARow) ) > -1  then //Er tilføjet skal fjernes
          begin
            if fSelectedRows.Count > 1 then
            begin
              fSelectedRows.Delete( fSelectedRows.IndexOf( IntToStr(ARow) ) );
              fLastRows.Delete( fLastRows.IndexOf( IntToStr(ARow) ));
              Row := StrToInt(fLastRows[fLastRows.Count-1]);
              InvalidateRow(ARow);
            end;
          end
          else
          begin  //Tilføj row
              fSelectedRows.Add( IntToStr(ARow) );
              fLastRows.Add( IntToStr(ARow) );
              Row := ARow;
              InvalidateRow(ARow);
          end;

          Options := Options-[goRangeSelect];
    end
    else if ssShift in Shift then
    begin
        DeselectAll;//Sletter alt på nær RangeSelected
        fLastRows.Delete(0);
        for i:= Selection.Top to Selection.Bottom do
        begin
            fLastRows.Add( IntToStr(i));
            fSelectedRows.Add( IntToStr(i));
        end;
    end
    else //Shift er tom ved left mouse button up
    begin
        Options := Options-[goRangeSelect];
        Row := ARow;  //Bliver vist nok ikke gjort i mouseup automatisk
        DeSelectAll;
        fLastRows[0] := IntToStr(ARow);
        fSelectedRows.Add( IntToStr(ARow));
    end;

    if Assigned(fOnRowSelected) then
      OnRowSelected(Self);
  end;
end;

function TSortGrid.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
{  inherited DoMouseWheelDown(Shift,MousePos);
  DeSelectAll;
  fLastRows[0] := IntToStr(Row);
  fSelectedRows.Add( IntToStr(Row));}
  Result := True;
  FocusColRow(Col, TopRow+2);
end;

function TSortGrid.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
{  inherited DoMouseWheelUp(Shift,MousePos);
  DeSelectAll;
  fLastRows[0] := IntToStr(Row);
  fSelectedRows.Add( IntToStr(Row));}
  Result := True;
  FocusColRow(Col, TopRow-2);
end;


//*********** Drag'n'drop Stuff *************
function TSortGrid.ResizingCol(X,Y: integer): boolean;
var
  ACol,ARow: Integer;
begin
  //If cursor inside +/- 5 pixels of a cell edge it is resizing the col
  MouseToCell(X,Y,ACol,ARow);
  Result := ((CellRect(ACol,0).Left-5  <= X) and (CellRect(ACol,0).Left+5  >= X) or
             (CellRect(ACol,0).Right-5 <= X) and (CellRect(ACol,0).Right+5 >= X) ) and (ARow=0);
end;

procedure TSortGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
    if (FDragPoint.X <> -1) and (Shift = [ssLeft]) and
    ((abs(FDragPoint.X - X) >10) or (abs(FDragPoint.Y - Y) >10)) then
    begin
        FDragPoint.X := -1;
        FDragging := True;
        BeginDrag(True,-1);//also gives startdrag event
        FDragging := False;
    end;

    inherited MouseMove(Shift,X,Y);
end;

{*******Proportional Scrollbar*************************************************}
procedure TSortGrid.SetProportionalScrollBars(Value: Boolean);
begin
  fProportionalScrollBars:=Value;
  UpdateScrollPage;
end;

procedure TSortGrid.ColWidthsChanged;
begin
  inherited ColWidthsChanged;
  if Assigned(fOnColumnWidthsChanged) then
     fOnColumnWidthsChanged(Self);
  UpdateScrollPage;
end;

procedure TSortGrid.RowHeightsChanged;
begin
  inherited RowHeightsChanged;
  if Assigned(fOnRowHeightsChanged) then
    fOnRowHeightsChanged(Self);
  UpdateScrollPage;
end;

procedure TSortGrid.WM_Size(var Msg: TWMSize);
var
  iCol, iWidth: Integer;
begin
  {$IFDEF FPC}
  //??? FixMe !
  {$ELSE}
  inherited;
  {$ENDIF}

  //Stretch LastCol
  if ColCount = (LeftCol+VisibleColCount) then//last col visible
  begin
    iWidth := 0;
    for iCol := LeftCol to ColCount-2 do
      Inc(iWidth, ColWidths[iCol]);
    iWidth := Width-iWidth-(VisibleColCount+3);
    if iWidth > 0 then
      ColWidths[ColCount-1] := iWidth;
  end;

  Invalidate;  //Avoid some gfx mistakes, but the grid flickers :-(
  UpdateScrollPage;
end;

procedure TSortGrid.UpdateScrollPage;
    function LMax(const A, B: integer): integer;
    begin
         Result:=B;
         if A > B then Result:=A;
    end;
var
  SI: TScrollInfo;
begin
  if not ProportionalScrollBars then Exit;
     {Make the scroll bar(s) proportional.}
     {To do this correctly, I should sum colwidths and rowheights,
     but I just approximate by basing the proportion on visible rows or cols
     divided by row or col count...}
     {Also, I can't really figure out Borland's scroll bar range and position
     scheme.  Thus, sometimes when you click on the end of the scroll bar, you
     still have to scroll farther with the arrows to actually get to the end
     of the grid.  If anyone knows how to fix this, PLEASE let me know...}
  if (ScrollBars = ssVertical) or (ScrollBars = ssBoth) then
  begin
    SI.cbSize:=sizeof(SI);
    SI.fMask:=SIF_PAGE or SIF_POS or SIF_RANGE;
    GetScrollInfo(Handle, SB_VERT, SI);
    SI.fMask:=SIF_PAGE;
    SI.nPage:=LMax(Round((((VisibleRowCount+1))/RowCount)*(SI.nMax-SI.nMin+1)), 1);
    SetScrollInfo(Handle, SB_VERT, SI, false);
  end;

  if (ScrollBars = ssHorizontal) or (ScrollBars = ssBoth) then
  begin
    SI.cbSize:=sizeof(SI);
    SI.fMask:=SIF_PAGE or SIF_POS or SIF_RANGE;
    GetScrollInfo(Handle, SB_HORZ, SI);
    SI.fMask:=SIF_PAGE;
    SI.nPage:=LMax(Round((((VisibleColCount)/ColCount)*(SI.nMax-SI.nMin+1))), 1);
    SetScrollInfo(Handle, SB_HORZ, SI, True);
  end;
end;



{********Validate Cell*********************************************************}
procedure TSortGrid.Click;
begin
     try
        inherited Click;
     finally
            if fEntered then ValidateCell;
     end;
end;

procedure TSortGrid.DoEnter;
begin
     try
        inherited DoEnter;
        fEntered:=True;
     finally
            InitValidate;
     end;
end;

procedure TSortGrid.DoExit;
begin
     try
        Click;
     finally
            inherited DoExit;
            fEntered:=False;
     end;
end;

procedure TSortGrid.InitValidate;
begin
     if not EditorMode then Exit;
     fOldCol:=Col;
     fOldRow:=Row;
     fOldCellText:=Cells[fOldCol, fOldRow];
     fOldModifiedValue:=Modified;
end;

procedure TSortGrid.ValidateCell;
var
   NewValue: String;
   Valid: Boolean;
begin
     if not EditorMode then Exit;
     
     if fOldCellText<>Cells[fOldCol, fOldRow] then
     begin
          NewValue:=Cells[fOldCol, fOldRow];
          Valid:=True;
          if Assigned(fOnCellValidate) then
             fOnCellValidate(Self, fOldCol, fOldRow, fOldCellText, NewValue, Valid);
          //Since Value is also a VAR parameter, we always
          //use it if it was changed in OnCellValidate.
          if not Valid then
          begin
               if NewValue <> Cells[fOldCol, fOldRow] then
                  Cells[fOldCol, fOldRow]:=NewValue
               else
                  Cells[fOldCol, fOldRow]:=fOldCellText;
               Modified:=fOldModifiedValue;
          end
          else if NewValue <> Cells[fOldCol, fOldRow] then
               Cells[fOldCol, fOldRow]:=NewValue;
     end;
     InitValidate;
end;

{********Cell Format***********************************************************}

function TSortGrid.FontSettingToStr(FontSet: TFontSetting): string;
var
    FontLst: TStringList;
begin
    FontLst := TStringList.Create;
    FontLst.Add( ColorToString( FontSet.FontColor ));                //Font Color
    if FontSet.Bold then FontLst.Add('1') else FontLst.Add('0');     //Bold
    if FontSet.Italic then FontLst.Add('1') else FontLst.Add('0');   //Italic
    if FontSet.Underline then FontLst.Add('1') else FontLst.Add('0');//Underline
    FontLst.Add( ColorToString(FontSet.BackColor));                  //Back Color
    result := FontLst.CommaText;
    FontLst.Free;
end;

function TSortGrid.StrToFontSetting(Str: string): TFontSetting;
var
    FontLst: TStringList;
begin
    //Fontsettings and something stored
    FontLst:= TStringList.Create;
    FontLst.CommaText := Str;
    Result := TFontSetting.Create;
    Result.FontColor := StringToColor( FontLst[0] );//Font Color
    Result.Bold      := FontLst[1] = '1';           //Bold
    Result.Italic    := FontLst[2] = '1';           //Italic
    Result.Underline := FontLst[3] = '1';           //Underline
    Result.BackColor := StringToColor( FontLst[4] );//Back Color
    FontLst.Free;
end;

function TSortGrid.GetColFont(ACol: integer): TFontSetting;
begin
    Result := ColFontList[ACol];
end;

procedure TSortGrid.SetColFont(ACol: integer; FontSet: TFontSetting);
begin
    FontSet.Valid := True;
    ColFontList[ACol] := FontSet;
    InvalidateCol(ACol);
    Modified := True;
end;

function TSortGrid.GetRowFont(ARow: integer): TFontSetting;
begin
    Result := RowFontList[Row];
end;

procedure TSortGrid.SetRowFont(ARow: integer; FontSet: TFontSetting);
begin
    FontSet.Valid := True;
    RowFontList[ARow] := FontSet;
    Modified := True;
    InvalidateRow(ARow);
end;

procedure TSortGrid.SetAlignmentHorz(Value: TAlignment);
begin
  fAlignmentHorz:=Value;
  Invalidate;
end;

procedure TSortGrid.SetAlignmentVert(Value: TVertAlignment);
begin
  fAlignmentVert:=Value;
  Invalidate;
end;

procedure TSortGrid.SetBevelStyle(Value: TCellBevelStyle);
begin
  fBevelStyle:=Value;
  Invalidate;
end;

function TSortGrid.GetCellDrawState(const ACol, ARow: integer): TGridDrawState;
    function PointInGridRect(Col, Row: integer; const Rect: TGridRect): Boolean;
    begin
      Result := (Col >= Rect.Left) and (Col <= Rect.Right) and (Row >= Rect.Top)
        and (Row <= Rect.Bottom);
    end;
var
   DrawState: TGridDrawState;
begin
     DrawState:=[];
     if (ARow < 1) and (ACol < 0) then Include(DrawState, gdFixed);
     if Focused and (ARow = Row) and (ACol = Col) then Include(DrawState, gdFocused);
     if PointInGridRect(ACol, ACol, Selection) then Include(DrawState, gdSelected);
     Result:=DrawState;
end;

procedure TSortGrid.InitializeFormatOptions(ACol,ARow: Integer; var FmtOpts: TFormatOptions; var CheckBox, Combobox, Ellipsis: Boolean);
begin
  //Setup good defaults for FormatOptions.
  FmtOpts.HideText:=False;
  FmtOpts.Font := Canvas.Font;
  FmtOpts.Brush := Canvas.Brush;
  FmtOpts.AlignmentHorz := AlignmentHorz;
  FmtOpts.AlignmentVert := AlignmentVert;
  FmtOpts.Bevel.Style := BevelStyle;
  //Set defaults for the bevel colors.
  case BevelStyle of
    cbRaised:
      begin
        FmtOpts.Bevel.UpperLeftColor:=clBtnHighlight;
        FmtOpts.Bevel.LowerRightColor:=clBtnShadow;
      end;
    cbLowered:
      begin
        FmtOpts.Bevel.UpperLeftColor:=clBtnShadow;
        FmtOpts.Bevel.LowerRightColor:=clBtnHighlight;
      end;
    else
      FmtOpts.Bevel.UpperLeftColor:=clWindow;
    FmtOpts.Bevel.LowerRightColor:=clWindow;
  end;
  CheckBox := False;
  Combobox := False;
  Ellipsis := False;
  //Now do the OnGetCellFormat event if necessary.
  if Assigned(fOnGetCellFormat) then
    fOnGetCellFormat(Self, ACol, ARow, GetCellDrawState(ACol,ARow), FmtOpts, CheckBox, Combobox, Ellipsis);
end;

//ComboBoxes
function TSortGrid.GetComboBox(ACol, ARow: Integer): Boolean;
var
  Dummy: TFormatOptions;
  ComboBox, Sorted, DummyB : Boolean;
  Strs: TStringList;
  aWidth, aHeight: integer;
begin
  Result:= False;
  InitializeFormatOptions( ACol, ARow, Dummy, Dummyb, ComboBox, DummyB);
  if ComboBox and (Assigned(fOnGetComboBox)) then
  begin
    Strs := TStringList.Create;
    aWidth := 0;
    aHeight:= 0;
    Sorted := True;
    //FixMe:  is aWidth and aHeight okay here ?
    OnGetComboBox( Self, ACol, ARow, Strs, aWidth, aHeight, Sorted);
    if Strs.Count > 0 then
    begin
      ListBox.Parent:= ParentForm;
      ListBox.Clear;
      ListBox.Sorted := Sorted;
      ListBox.Items.AddStrings( Strs);
      if ListBox.Items.IndexOf( Cells[ACol,ARow] ) = -1
        then ListBox.ItemIndex:= 0
        else ListBox.ItemIndex:= ListBox.Items.IndexOf( Cells[ACol,ARow] );

      ListBox.Left:= CellRect(ACol, ARow).Left+Left+2;
      ListBox.Top:= CellRect(ACol, ARow).Top+Top+1;
      if aWidth = 0
        then ListBox.Width:= CellRect( ACol, ARow).Right-CellRect(ACol, ARow).Left+1
      else ListBox.Width:= aWidth;
      if (aHeight = 0) and (ListBox.Items.Count < 10)
        then aHeight := ListBox.Items.Count*ListBox.ItemHeight+5;
      ListBox.Height := aHeight;
      ListBox.Show;
      ListBox.SetFocus;
      Result:= True;
    end;
    Strs.Free;
  end;
end;

procedure TSortGrid.ListBoxOnExit(Sender: TObject);
var
  ACol, ARow: Integer;
begin
  MouseToCell(ListBox.Left-Left-2,  ListBox.Top-Top-1, ACol, ARow);
  Cells[ACol, ARow]:= ListBox.Items[ ListBox.ItemIndex ];
  ListBox.Hide;
  InvalidateCol(ACol);
  SetFocus;
  if Assigned(fOnSetComboBox) then
    fOnSetComboBox(Self,ACol,ARow, ListBox.Items[ ListBox.ItemIndex ]);
end;

procedure TSortGrid.ListBoxOnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if (Key = VK_RETURN) or (Key = VK_SPACE) then
        ListBoxOnExit(Self);
end;

procedure TSortGrid.ListBoxOnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ListBoxOnExit(Self);
end;

procedure TSortGrid.SetUserSettings(const Value: TStringList);
begin
  Modified := True;
  fUserSettings := Value;
end;

//Checkboxes
procedure TSortGrid.SetChecked(ACol, ARow: Integer; Const Value: Boolean);
var
  Dummy: TFormatOptions;
  CheckBox, Dummyb: Boolean;
//  iCol: Integer;
begin
  InitializeFormatOptions(ACol,ARow, Dummy, CheckBox, Dummyb, Dummyb);
  if CheckBox = True then
  begin
    if Value = True then
      Cells[ACol,ARow] := 'true'
    else
      Cells[ACol,ARow] := '';

    InvalidateRow(ARow);  
    if Assigned(fOnSetChecked) then fOnSetChecked(Self, ACol, ARow, Value);

{    if (Row <> ARow) then
        for iCol := 0 to ColCount-1 do
              if SelectCell(iCol, ARow) then
              begin
                  MoveTo(iCol,ARow);
                  Break;
              end;}
  end;
end;

function TSortGrid.GetChecked(ACol, ARow: Integer): Boolean;
var
  Dummy: TFormatOptions;
  CheckBox, Dummyb: Boolean;
begin
  InitializeFormatOptions(ACol,ARow, Dummy, CheckBox, Dummyb, Dummyb);
  if (CheckBox = True) and (Cells[ACol,ARow] = 'true') then
    Result := True
  else
    Result := False;
end;

procedure TSortGrid.DrawCell(ACol, ARow: integer; ARect: TRect; AState: TGridDrawState);
var
  xOffset, yOffset: Integer;
  FmtOpts: TFormatOptions;
  CheckBox, Combobox, Ellipsis: Boolean;
  BmpChk, BmpUnChk:TBitmap;
  aText: String;
  aWidth: Integer;
  I: Integer;
  FontSet: TFontSetting;
  RowFontValid, ColFontValid: boolean;
begin
  if (ARow > 0) and (FNowUpdating or FHideRows) then
    begin
      //Sletter gridlinjer, TStringGrid tegner dem udenom Drawcell proceduren
      Canvas.FillRect( Rect(ARect.Left,ARect.Top,ARect.Right+Self.Width+1,ARect.Bottom+1));
      exit;
    end;

  InitializeFormatOptions(ACol,ARow, FmtOpts, CheckBox, Combobox, Ellipsis);//AState

  //Hide if checkbox
  if CheckBox = True then
      FmtOpts.HideText := True;

  //Bruger RangeSelect til at vælge rows, hvis row inden for range så marker row
  if (goRangeSelect in Options) and (ARow >= Selection.Top) and (ARow  <= Selection.Bottom) then
  begin
      FmtOpts.Font.Color  := clHighlightText;
      FmtOpts.Brush.Color := clHighlight;
  end//Marker row hvis i selectrows liste
  else if (MultiSelect) and (fSelectedRows.IndexOf( IntToStr(ARow)) > -1) and not (goEditing in Options) then
  begin
      FmtOpts.Font.Color  := clHighlightText;
      FmtOpts.Brush.Color := clHighlight;
  end
  else
  begin
      //User ColFont and RowFont setttings if valid
      RowFontValid := (RowFontList.Count > ARow) and RowFontList[ARow].Valid;
      ColFontValid := (ColFontList.Count > ACol) and ColFontList[ACol].Valid;

      if (DrawColBeforeRow and ColFontValid) //Always use Col for drawing
          or (ColFontValid and not RowFontValid) then //use colfont, because row font not valid
      begin
          FmtOpts.Font.Color  := ColFontList[ACol].FontColor;                                          //Font Color
          FmtOpts.Brush.Color := ColFontList[ACol].BackColor;                                          //Back Color
          if ColFontList[ACol].Bold      then FmtOpts.Font.Style := FmtOpts.Font.Style+[fsBold];       //Bold
          if ColFontList[ACol].Italic    then FmtOpts.Font.Style := FmtOpts.Font.Style+[fsItalic];     //Italic
          if ColFontList[ACol].Underline then FmtOpts.Font.Style := FmtOpts.Font.Style+[fsUnderline];  //Underline
      end
      else if RowFontValid then
      begin//Use row settings to paint
          FontSet := StrToFontSetting( Cells[ColCount,ARow] );
          FmtOpts.Font.Color  := FontSet.FontColor;                                          //Font Color
          FmtOpts.Brush.Color := FontSet.BackColor;                                          //Back Color
          if FontSet.Bold      then FmtOpts.Font.Style := FmtOpts.Font.Style+[fsBold];       //Bold
          if FontSet.Italic    then FmtOpts.Font.Style := FmtOpts.Font.Style+[fsItalic];     //Italic
          if FontSet.Underline then FmtOpts.Font.Style := FmtOpts.Font.Style+[fsUnderline];  //Underline
      end;
  end;

  Canvas.Font := FmtOpts.Font;
//    Brush.Color := FmtOpts.Brush.Color; //flicker skærm ved updatering, ved ikke om det er ok at fjerne

  aText := Cells[ACol, ARow];

  //Text displayed in Header
  if ARow = 0 then
  begin
    aWidth := ColWidths[ACol]-1;
    if (SortOptions.fSortCol = ACol) and FSortOptions.FCanSort then//Use Offset for up/down arrow IF the col is sorted
        Dec( aWidth,11);//width of up/down bitmap
    if Canvas.TextWidth( aText) > aWidth then
    begin
      aText[ Length( aText)-1] := '.';
      aText[ Length( aText)] := '.';
      while (Canvas.TextWidth( aText) > aWidth) and (Length( aText) > 3) do
      begin
          Delete( aText, Length( aText), 1);
          aText[ Length(aText)-1] := '.';
      end;
    end;
  end;

  //Calculate horizontal offset.
  case FmtOpts.AlignmentHorz of
     taRightJustify: xOffset := ARect.Right-ARect.Left-Canvas.TextWidth( aText )-2;
     taCenter:       xOffset := (ARect.Right-ARect.Left-Canvas.TextWidth( aText )) div 2;
     else xOffset:=2;
  end;

  //Calculate vertical offset.
  case FmtOpts.AlignmentVert of
     taBottomJustify: yOffset:=ARect.Bottom-ARect.Top-Canvas.TextHeight( aText )-3;
     taMiddle:        yOffset:=(ARect.Bottom-ARect.Top-Canvas.TextHeight( aText )) div 2;
     else yOffset:=2;
  end;

  //Draw Up/Down Bitmap
  if (SortOptions.fSortCol = ACol) and FSortOptions.FCanSort then
  begin
      if ARow = 0
        then Inc(xOffset,11); //width of up/down bitmap
      //Width ~ a X-OffSet value, so Up/Down Bitmap fits, when HeaderWidth less that Bitmap.width
      if ARect.Right-ARect.Left > 10
        then aWidth := 8
        else aWidth := ARect.Right-ARect.Left-3;
      //I ~ an Y-Offset value for Up/Down Bitmap
      I := (RowHeights[0] div 2) -4;

      if SortOptions.SortDirection = sdAscending
        then Canvas.CopyRect( Rect( ARect.Left+3,I,ARect.Left+aWidth+3,I+7),
                              BitmapUp.Canvas, Rect(0,0,aWidth,7))
        else Canvas.CopyRect( Rect( ARect.Left+3,I,ARect.Left+aWidth+3,I+7),
                              BitmapDown.Canvas, Rect(0,0,aWidth,7));
  end;

  //Now do the text drawing.
  if not FmtOpts.HideText then
      Canvas.TextRect(ARect, ARect.Left+xOffset, ARect.Top+yOffset, aText)
  else
      Canvas.TextRect(ARect, ARect.Left+xOffset, ARect.Top+yOffset, '');

  //Checkbox
  if CheckBox = True then
  begin
    BmpChk := TBitMap.Create;
    BmpUnChk := TBitMap.Create;
    BmpChk.LoadFromResourceName(HInstance,'CHECKED');
    BmpUnChk.LoadFromResourceName(HInstance,'UNCHECKED');

    yOffSet := ARect.Top+(RowHeights[ARow] div 2) -5;
    if ARect.Right-ARect.Left > 10
      then aWidth := 10
      else aWidth := ARect.Right-ARect.Left-1;

    xOffSet:= ARect.Left+ (ARect.Right-ARect.Left-aWidth) div 2;

    if Cells[ACol,ARow] = 'true' then
      Canvas.CopyRect(Rect(xOffSet,yOffSet,xOffSet+aWidth,yOffSet+10), BmpChk.Canvas, Rect(0,0,aWidth,10))
    else
      Canvas.CopyRect(Rect(xOffSet,yOffSet,xOffSet+aWidth,yOffSet+10), BmpUnChk.Canvas, Rect(0,0,aWidth,10));

    BmpChk.Free;
    BmpUnChk.Free;
  end;

  //Combobox
  if (Combobox = True) and (((Row = ARow) and (Col = ACol)) or ((Row = ARow) and Editormode)) then
  begin
    BmpChk := TBitMap.Create;
    BmpChk.LoadFromResourceName(HInstance,'COMBOBOX');

    if ARect.Right-ARect.Left >= 16
      then aWidth := 16
      else aWidth := ARect.Right-ARect.Left;

    xOffSet:= ARect.Right-aWidth;

    Canvas.CopyRect(Rect(xOffSet,ARect.Top,xOffSet+aWidth,ARect.Bottom), BmpChk.Canvas, Rect(0,0,aWidth,16));

    BmpChk.Free;
  end;

  //Ellipsis Button
  if (Ellipsis = True) and (Row = ARow) and (Col <> ACol)  then
  begin
    BmpChk := TBitMap.Create;
    BmpChk.LoadFromResourceName(HInstance,'ELLIPSIS');
    if ARect.Right-ARect.Left >= 16
      then aWidth := 16
      else aWidth := ARect.Right-ARect.Left;

    xOffSet:= ARect.Right-aWidth;

    Canvas.CopyRect(Rect(xOffSet,ARect.Top,xOffSet+aWidth,ARect.Bottom), BmpChk.Canvas, Rect(0,0,aWidth,16));

    BmpChk.Free;
  end;

  //Draw Bevel.
  if (FmtOpts.Bevel.Style <> cbNone) and
     (ACol >= 0) and (ARow >= 1) then
  begin
    //Draw from bottom-most lines out to mimic behaviour of
    //fixed cells when FixedXXXXLine is toggled.
    with ARect do
    begin
      if goFixedVertLine in Options then
      begin
        Canvas.Pen.Color := FmtOpts.Bevel.LowerRightColor;
        Canvas.PolyLine([Point(Right-1, Top), Point(Right-1, Bottom)]);
      end;
      if goFixedHorzLine in Options then
      begin
        Canvas.Pen.Color := FmtOpts.Bevel.LowerRightColor;
        Canvas.PolyLine([Point(Left, Bottom-1), Point(Right, Bottom-1)]);
      end;
      if goFixedVertLine in Options then
      begin
        Canvas.Pen.Color := FmtOpts.Bevel.UpperLeftColor;
        Canvas.PolyLine([Point(Left, Top), Point(Left, Bottom)]);
      end;
      if goFixedHorzLine in Options then
      begin
        Canvas.Pen.Color := FmtOpts.Bevel.UpperLeftColor;
        Canvas.PolyLine([Point(Left, Top), Point(Right, Top)]);
      end;
    end;
  end;

  if Assigned( OnDrawCell ) then
    OnDrawCell(Self, ACol, ARow, ARect, AState );
end;

procedure TSortGrid.InvalidateRow(ARow: Integer);
begin
  inherited InvalidateRow(ARow);
end;

procedure TSortGrid.InvalidateCol(ACol: Integer);
begin
  inherited InvalidateCol(ACol);
end;

{******MultiSelect*************************************************************}
function TSortGrid.GetRowSelected(ARow: Integer):Boolean;
begin
  Result := fSelectedRows.IndexOf( IntToStr(ARow) ) > -1;
end;

procedure TSortGrid.SetRowSelected(ARow: Integer; const Value: Boolean);
begin
  Options := Options-[goRangeSelect];

  if Value = True then
  begin
    if fSelectedRows.IndexOf( IntToStr(ARow) ) = -1 then
    begin
      fSelectedRows.Add( IntToStr(ARow));
      fLastRows.Add( IntToStr(ARow));
    end;
  end
  else
    if fSelectedRows.IndexOf( IntToStr(ARow) ) > -1 then
    begin
      fSelectedRows.Delete(fSelectedRows.IndexOf( IntToStr(ARow) ));
      fLastRows.Delete(fLastRows.IndexOf( IntToStr(ARow) ));
    end;

  if Assigned(FOnRowSelected)then
      OnRowSelected(self);

  if not FNowUpdating then
      InvalidateRow(ARow);
end;

procedure TSortGrid.DeSelectAll;
begin
  while fSelectedRows.Count > 0 do
  begin
     InvalidateRow(StrToInt(fSelectedRows[0]));
     fSelectedRows.Delete(0);
  end;

  while fLastRows.Count > 1 do
      fLastRows.Delete(0);
  fLastRows[0] := '';
end;

function TSortGrid.SelCount: Integer;
begin
  if goRangeSelect in Options then
      Result := Selection.Bottom - Selection.Top + 1
  else
      Result := fSelectedRows.Count;
  if Result = 0 then Result := 1;
end;

procedure TSortGrid.SortRowsSel;
var
  i,iLength:Integer;
  S: String;
begin
  iLength := 0;
  for i := 0 to fSelectedRows.Count-1 do//get the longest item
    if Length( fSelectedRows[i] ) > iLength then
      iLength := Length( fSelectedRows[i] );

  for i := 0 to fSelectedRows.Count-1 do//set items to same length by putting '0' in front then use sort to make a numerical sort
  begin
    S := fSelectedRows[i];
    while Length(S) < iLength do
      S := '0'+S;
    fSelectedRows[i] := S;
  end;

  fSelectedRows.Sort;
end;


{******TableEdit procedures****************************************************}

procedure TSortGrid.SizeChanged(OldColCount, OldRowCount: integer);
begin
  inherited SizeChanged(OldColCount, OldRowCount);
  Modified := True;
  UpdateScrollPage;

  if fSortOptions.fUpdateOnSizeChange = True then
    SortColumn(SortOptions.fSortCol);

  if fNowUpdating=False then
  try
    MoveTo(0,1);
  except
  end;

  ColFontList.ChangeCount(ColCount - OldColCount);
  RowFontList.ChangeCount(RowCount - OldRowCount);

  //Just some internal testing
  if RowCount < 2 then
      showmessage('Rowsize too small');

  if Assigned(fOnSizeChanged) then
      fOnSizeChanged(Self, OldColCount, OldRowCount);
end;

//Check if Grid is modified
procedure TSortGrid.SetEditText(ACol, ARow: integer; const Value: string);
begin
  try
    if Value <> Cells[ACol, ARow] then
      Modified:=True;
  finally
    inherited SetEditText(ACol, ARow, Value);
  end;
end;

procedure TSortGrid.SetModified(const Value: Boolean);
begin
  if fDisableModify then Exit;
  fModified := Value;
  if Value and (Assigned(FOnModified)) then
      OnModified(Self);
end;

//AutoSizes the ACol column.
procedure TSortGrid.AutoSizeCol(const ACol: integer; AlwaysSize: Boolean=True);
var
  MaxWidth, TextW, HeaderWidth, iRow: Integer;
  FmtOpts: TFormatOptions;
  Dummy: Boolean;
begin
  if (ColWidths[ACol] = -1) and not AlwaysSize then
    Exit;

  //Resize the column to display the largest value.
  MaxWidth := 0;
  HeaderWidth := 0;
  for iRow := 0 to RowCount-1 do
  begin
    InitializeFormatOptions(Col,iRow,FmtOpts,dummy,dummy,dummy);
    Canvas.Font := FmtOpts.Font;
    TextW := Canvas.TextWidth(Cells[ACol, iRow]);

    if iRow = 0 then
    begin
        HeaderWidth := TextW;
        if (ACol = SortOptions.fSortCol) and SortOptions.fCanSort then
          Inc(HeaderWidth, 12);
    end
    else if TextW > MaxWidth then
        MaxWidth := TextW;
  end;

  if HeaderWidth > MaxWidth then
      MaxWidth := HeaderWidth;

  if MaxWidth > 0 then
      ColWidths[ACol] := MaxWidth+Canvas.TextWidth('X')
  else
      ColWidths[ACol] := Canvas.TextWidth('xx');
end;

//AutoSizes ALL columns
procedure TSortGrid.AutoSizeColumns(AlwaysSize: Boolean=False);
var
  iCol: Integer;
begin
  BeginUpdate;
  for iCol := 0 to ColCount-1 do
    AutoSizeCol(iCol, AlwaysSize);
  EndUpdate;
end;

function TSortGrid.FindCol(Header: String): Integer;
var
    iCol: Integer;
begin
    Result := -1;//outside grid
    Header := LowerCase(Header);
    for iCol:= 0 to ColCount-1 do
    if LowerCase(Cells[iCol, 0]) = Header then
    begin
      Result:= iCol;
      Break;
    end;
end;

function TSortGrid.FindRow(ACol: integer; Value: string; CaseSensitive: boolean): integer;
var
    iRow: integer;
    Value2: string;
begin
    Result := -1;

    if CaseSensitive then Value := LowerCase(Value);

    for iRow := 1 to RowCount-1+FilterCount do
    begin
        if CaseSensitive then
            Value2 := LowerCase( Cells[ACol, iRow] )
        else
            Value2 := Cells[ACol, iRow];

        if Value = Value2 then
        begin
            Result := iRow;
            Break;
        end;
    end;
end;


//Clears the grid.
procedure TSortGrid.Clear;
var
  I: integer;
begin
  BeginUpdate;
  ColFontList.Clear;
  RowFontList.Clear;

  Row := 1;
  fSelectedRows.Add( '1' );
  DeSelectAll;
  fLastRows[0] := '1';

  for I := 1 to (RowCount-1) do
    Rows[I].Clear;
  fModified := False;
  RowCount := 2;
  AutoSizeColumns(True);

  EndUpdate;

  if Assigned(FOnRowSelected) then OnRowSelected(Self);
end;

procedure TSortGrid.KeyPress(var Key: Char);
var
  ARow,ACol: Integer;
  Moved: Boolean;
begin
  //I have to do this here because KeyDown doesn't get called
  //when the enter key is pressed in the inplace editor.
  if Key = #13 then ValidateCell;

  //Jumps to row with sortgrid.cells[0, arow][1] = key
  if EditorMode = False then
  begin
    ACol := SortOptions.SortCol;
    Moved := False;
    Key := UpCase(Key);
    for ARow := Row+1 to RowCount-1 do
    if (Length(Cells[ACol,ARow]) > 0) and (UpCase(Cells[ACol,ARow][1]) = Key) then
    begin
      MoveTo(ACol,ARow);
      Moved := True;
      Break;
    end;

    if Moved = False then
    for ARow := 1 to Row do
    if (Length(Cells[ACol,ARow]) > 0) and (UpCase(Cells[ACol,ARow][1]) = Key) then
    begin
      MoveTo(ACol,ARow);
      Break;
    end;
  end;

  inherited KeyPress(Key);
end;

//Moves the selected cell to (ACol, ARow) and makes it visible.
procedure TSortGrid.MoveTo(ACol, ARow: integer; MakeVisible: Boolean=True);
begin
  if ACol < 0 then ACol := 0;
  if ACol > ColCount-1 then ACol := ColCount-1;
  if ARow < 1 then ARow := 1;
  if ARow > RowCount-1 then ARow := RowCount-1;

  if SelectCell(ACol, ARow) = True then
  begin
    LockWindowUpdate(ParentForm.Handle);

    MoveColRow(ACol, ARow, True, True);

    DeSelectAll;
    fSelectedRows.Add( IntToStr(ARow) );
    fLastRows[0] := IntToStr(ARow);
    
    Col := ACol;
    Row := ARow;

    invalidate;

    //Make sure the selected Coloumn is Visible
    if MakeVisible then
        FocusColRow(ACol, ARow);

    LockWindowUpdate(0);//Calls invalidate
  end;
end;

procedure TSortGrid.FocusColRow(ACol, ARow: integer);
var
    MaxRow: Integer;
begin
    //Just to make sure
    if ACol < 0 then ACol := 0;
    if ACol > ColCount-1 then ACol := ColCount-1;
    if ARow < 1 then ARow := 1;
    if ARow > RowCount-1 then ARow := RowCount-1;

    //Make sure the selected Coloumn is Visible
    if (ACol > (LeftCol+VisibleColCount-1)) or (ACol < LeftCol) then
      repeat
        LeftCol := LeftCol+1;
      until
        (ACol <= (LeftCol+VisibleColCount-1)) and (ACol >= LeftCol);

    //Make sure the selected Row is at the top
    MaxRow := RowCount-VisibleRowCount;
    if MaxRow < 1 then MaxRow := 1;

    if ARow > MaxRow then
      TopRow := MaxRow
    else
    begin
      if ARow < 2 then
        TopRow := 1
      else
        TopRow := ARow-1;
    end;
end;

procedure TSortGrid.InsertRow(ARow: integer);
begin
     RowCount:=RowCount+1;
     if ARow < RowCount-2 then//Laver lidt fusk hvis sidste row insertes
       MoveRow(RowCount-1, ARow)
     else
       Inc(ARow);
     Rows[ARow].Clear;
     Row:= ARow;

     DeSelectAll;
     fLastRows[0] := IntToStr(ARow);
     fSelectedRows.Add( IntToStr(ARow));

     if Assigned(fOnRowInsert) then fOnRowInsert(Self, ARow);
end;

procedure TSortGrid.InsertColumn(ACol: integer);
begin
     ColCount:=ColCount+1;
     MoveColumn(ColCount-1, ACol);
     Cols[ACol].Clear;
     Col := ACol;
     if Assigned(fOnColumnInsert) then fOnColumnInsert(Self, ACol);
end;

procedure TSortGrid.DeleteRow(ARow: integer);
var
  ASE: Boolean;
begin
  Modified := True;
  {If goAlwaysShowEditor is enabled then DeleteRow and MoveRow leave the caret past the last row or
    in one of the fixed rows.  So I turn it off before the delete and then back on after to get it working correctly.}
  if goAlwaysShowEditor in Options then
  begin
    Options:=Options-[goAlwaysShowEditor];
    ASE:=True;
  end
  else
    ASE:=False;

  if RowCount > 2 then
    inherited DeleteRow(ARow)
  else
    Rows[1].Clear;

  RowFontList.Delete(ARow);

  if ASE then Options:=Options+[goAlwaysShowEditor];
  if Assigned(fOnRowDelete) then fOnRowDelete(Self, ARow);
end;

procedure TSortGrid.DeleteColumn(ACol: integer);
var
  ASE: Boolean;
begin
  Cols[ACol].Clear;
  //See DeleteRow for comments...
  ASE:=False;
  if goAlwaysShowEditor in Options then
  begin
    Options:=Options-[goAlwaysShowEditor];
    ASE:=True;
  end;
  inherited DeleteColumn(ACol);
  if ASE then Options:=Options+[goAlwaysShowEditor];
  if Assigned(fOnColumnDelete) then fOnColumnDelete(Self, ACol);
end;

procedure TSortGrid.MoveRow(FromIndex, ToIndex: integer);
var
  ASE: Boolean;
begin
  //See DeleteRow for comments...
  ASE:=False;
  if goAlwaysShowEditor in Options then
  begin
    Options:=Options-[goAlwaysShowEditor];
    ASE:=True;
  end;
  inherited MoveRow(FromIndex, ToIndex);
  if ASE then Options:=Options+[goAlwaysShowEditor];

  RowFontList.Exchange(FromIndex, ToIndex);
end;

procedure TSortGrid.MoveColumn(FromIndex, ToIndex: integer);
var
    ASE: Boolean;
begin
    //See DeleteRow for comments...
    ASE:=False;
    if goAlwaysShowEditor in Options then
    begin
        Options:=Options-[goAlwaysShowEditor];
        ASE:=True;
    end;
    inherited MoveColumn(FromIndex, ToIndex);
    if ASE then Options:=Options+[goAlwaysShowEditor];
end;

procedure TSortGrid.SwapRows(ARow1, ARow2: integer);
begin
     if ARow1 < ARow2 then
     begin
          MoveRow(ARow2, ARow1);
          MoveRow(ARow1+1, ARow2);
     end
     else if ARow2 < ARow1 then
     begin
          MoveRow(ARow1, ARow2);
          MoveRow(ARow2+1, ARow1);
     end;
end;

procedure TSortGrid.SwapColumns(ACol1, ACol2: integer);
begin
     if ACol1 < ACol2 then
     begin
          MoveColumn(ACol2, ACol1);
          MoveColumn(ACol1+1, ACol2);
     end
     else if ACol2 < ACol1 then
     begin
          MoveColumn(ACol1, ACol2);
          MoveColumn(ACol2+1, ACol1);
     end;
end;



{ ****** Sort **************************************************************** }

procedure TSortGrid.SetSortOptions(value: TSortOptions);
begin
 fSortOptions.Assign(value);
end;

function TSortedList.GetItem(const i: Integer): PSortedListEntry;
begin
  //Cast the pointer.
  Result:= PSortedListEntry( Items[i]);
end;

procedure TSortedList.Reset;
var
  I: Integer;
begin
     //Dispose of anything in the list first.
     for i:= 0 to Self.Count-1 do
      {$IFDEF FPC}
      //FixMe: that's a memory leak :
      if Self.Items[i] <> nil then Self.Items[i]:= nil;
      {$ELSE}
      if Items[i] <> nil then Dispose( Items[i]);
      {$ENDIF}
     //Now clear the list.
     Clear;
end;

function TSortGrid.DetermineSortStyle(const ACol: integer): TSortStyle;
var
  i: Integer;
  DoNumeric, DoDateTime, DoTime: Boolean;
begin
  DoNumeric:=True;
  DoDateTime:=True;
  DoTime:=True;

  //Note: We only go through the rows once.
  //This code depends on the fact that no
  //entry can be both a date and number.
  for i:=1 to RowCount-1 do
  begin
    if DoNumeric then
    begin
      try
        StrToFloat(Cells[ACol, i]);
      except
        on EConvertError do DoNumeric:=False;
      end;
    end;

    if DoTime then
    begin
      try
        StrToTime(Cells[ACol, i]);
      except
        on EConvertError do DoTime:=False;
      end;
    end;

    if DoDateTime then
    begin
      try
        StrToDateTime(Cells[ACol, i]);
      except
        on EConvertError do DoDateTime:=False;
      end;
    end;
  end;

  if DoNumeric then Result := ssNumeric
  else if DoDateTime then Result := ssDateTime
  else if DoTime then Result := ssTime
  else Result := ssNormal;
end;

function ExtendedCompare(const Str1, Str2: String): Integer;
var
  St1,St2, S1,S2: String;
  i,len, iPos1,iPos2: Integer;
begin
  S1 := Str1;
  S2 := Str2;

  if (S1 = '') or (S2 = '') then
  begin
    Result := -1;
    Exit;
  end;

  ///***Deleting first chars if equal and not numbers
  len := Length(Str1);
  if Length(Str2) < len then len := Length(Str2);//finder korteste string

  S1 := '';
  S2 := '';
  for I := 1 to Len do//Copy all non equal chars to S and S2, but all numbers
    if (Str1[i] <> Str2[i]) or (Str1[i] in ['0'..'9']) then
    begin
      if i = Len then
      begin
         S1 := S1+Copy(Str1,i,length(Str1));
         S2 := S2+Copy(Str2,i,length(Str2));
      end
      else
      begin
         S1:= S1+Str1[i];
         S2:= S2+Str2[i];
      end;
    end;

  ///***Deleting last chars if equal and not numbers
  St1 := S1;
  St2 := S2;
  len := Length(St1);
  if Length(St2) < len then len := Length(St2);//finder korteste string

  iPos1 := Length(St1);
  iPos2 := Length(St2);
  for i := 0 to Len-1 do//Copy all non equal chars to S and S2, but all numbers
    if (St1[iPos1-i] = St2[iPos2-i]) and not (St1[iPos1-i] in ['0'..'9']) then
    begin
      delete(S1, Length(S1),1);
      delete(S2, Length(S2),1);
    end;

  try
    if S1 = S2 then Result := 0
    else if StrToInt(S1) < StrToInt(S2) then Result:=-1
    else Result:=1;
  except
    Result:= NormalCompare(S1, S2);
  end;
end;

function NormalCompare(const Str1, Str2: String): Integer;
var s1, s2 : ansistring;
begin
  //Result:= StrComp( PChar(Str1), PChar( Str2));
  s1:= Str1;
  s2:= Str2;
  Result:= StrComp( PChar(s1), PChar( s2));
end;

function DateTimeCompare(const Str1, Str2: String): Integer;
var
  Val1, Val2: TDateTime;
begin
  try
    Val1:=StrToDateTime(Str1);
    Val2:=StrToDateTime(Str2);
    if Val1 < Val2 then Result:=-1
    else if Val2 < Val1 then Result:=1
    else Result:=0;
  except
    Result:= NormalCompare(Str1, Str2);
  end;
end;

function TimeCompare(const Str1, Str2: String): Integer;
var
  Val1, Val2: TDateTime;
begin
  try
    Val1:=StrToTime(Str1);
    Val2:=StrToTime(Str2);
    if Val1 < Val2 then Result:=-1
    else if Val2 < Val1 then Result:=1
    else Result:=0;
   except
     Result:= NormalCompare(Str1, Str2);
   end;
end;

function NumericCompare(const Str1, Str2: String): Integer;
var
  Val1, Val2: Extended;
begin
  try
    Val1:=StrToFloat(Str1);
    Val2:=StrToFloat(Str2);
    if Val1 < Val2 then Result:=-1
    else if Val2 < Val1 then Result:=1
    else Result:=0;
  except
    Result:= NormalCompare(Str1, Str2);
  end;
end;

function Compare(Item1, Item2: Pointer): Integer;
var
  Entry1, Entry2: PSortedListEntry;
begin
  Entry1 := Item1;
  Entry2 := Item2;

  //Handle Case-Insensitivity.
  if Entry1^.SortOption.fSortCaseSen = False then
  begin
    Entry1^.Str := Lowercase(Entry1^.Str);
    Entry2^.Str := Lowercase(Entry2^.Str);
  end;

  //Determine compare type and do the comparison.
  case Entry1^.SortOption.SortStyle of
      ssNumericExtended: Result:=ExtendedCompare(Entry1^.Str, Entry2^.Str);
      ssNumeric: Result:=NumericCompare(Entry1^.Str, Entry2^.Str);
      ssDateTime: Result:=DateTimeCompare(Entry1^.Str, Entry2^.Str);
      ssTime: Result:=TimeCompare(Entry1^.Str, Entry2^.Str);
      ssCustom: Result:=Entry1^.SortOption.SortCustom(Entry1^.Str, Entry2^.Str)
    else
      Result:=NormalCompare(Entry1^.Str, Entry2^.Str);
  end;

  //Now, make sure we don't swap the rows if the Keys are equal.
  //If they're equal then we sort by row number.
  if Result = 0 then
  begin
    if Entry1^.RowNum < Entry2^.RowNum then Result:=-1
    else if Entry1^.RowNum > Entry2^.RowNum then Result:=1
    else Result:=0; //Sometimes an item does get compared to itself.
  end
    else //Reverse polarity if descending sort.
    if Entry1^.SortOption.SortDirection = sdDescending then
      Result:=-1*Result;
end;

//Sorts the variable rows using Column ACol as a key
procedure TSortGrid.SortColumn(ACol: integer);
var
  I,I2,iRow,iCol: Integer;
  Item: PSortedListEntry;
  BufferGrid, BufferGrid2: array of TStrings;//add to dyn array, because faster than to cells property
  PrevSelected, StringList: TStringList;
  SortStyle: TSortStyle;
  FirstSelectedRow: Boolean;
begin
  iCol := 0;
  if not FSortOptions.FCanSort then Exit;//Don't sort

  SortOptions.fSortCol := ACol;//set before so it can be changed in OnBeginSort if needed
  fSorting:=True;//Sorting
  BeginUpdate;
  if Assigned(fOnBeginSort) then fOnBeginSort(Self, ACol);

  //Restore selected rows
  FirstSelectedRow := True;
  PrevSelected := TStringList.Create;
  PrevSelected.Sorted := True;
  PrevSelected.AddStrings( FSelectedRows );

  StringList := TStringList.Create;
  StringList.CommaText := SortOptions.fSecondaryIndex;
  if StringList.IndexOf(IntToStr(ACol)) > -1 then
    StringList.Delete( StringList.IndexOf(IntToStr(ACol)) );//don't sort col twice
  StringList.Insert(0, IntToStr(ACol));

  //copy grid to dynamic grid, faster
  SetLength(BufferGrid,RowCount);
  SetLength(BufferGrid2,RowCount);
  for iRow := 0 to RowCount-1 do
  begin
    BufferGrid[iRow] := TStringList.Create;
    BufferGrid[iRow].Assign( Rows[iRow] );
    BufferGrid2[iRow] := TStringList.Create;
  end;

  for I2 := StringList.Count-1 downto 0 do//Loop to sort all columns
  begin
    iCol := StrToInt(StringList[I2]);

    fSortedList.Reset;
    //Insert the Row Number and Key (Str) into tList class
    for I:=1 to RowCount-1 do
    begin
      New(Item);
      Item^.Str := BufferGrid[i][iCol];
      Item^.RowNum := I;
      Item^.SortOption := SortOptions;

      fSortedList.Add(Item);
    end;

    if Assigned(fOnGetSortStyle) then
      begin
        fOnGetSortStyle(Self, iCol, SortStyle);//Get sortstyle via OnEvent
        SortOptions.fSortStyle := SortStyle;
      end
    else if SortOptions.fSortStyle = ssAutomatic //Determine sortstyle auto.
           then SortOptions.fSortStyle := DetermineSortStyle(iCol);

    //Sortere
    {$IFDEF FPC}
    fSortedList.Sort( @Compare);
    {$ELSE}
    fSortedList.Sort( Compare);
    {$ENDIF}

    //Now rearrange the rows of the grid in sorted order.
    if iCol = StrToInt( StringList[0] ) then//write to cells property if last sorted col
    for i:=0 to fSortedList.Count-1 do
    begin
      Item := fSortedList.GetItem(i);
      Rows[i+1].Assign( BufferGrid[ Item^.RowNum ]);

      if PrevSelected.IndexOf( IntToStr(Item^.RowNum) ) > -1 then
      begin
         if FirstSelectedRow then
         begin
            FirstSelectedRow := False;
            //Delete selected rows info
            Row := i+1; //Set row første gang
            fLastRows.Clear;
            fSelectedRows.Clear;
         end;

         fLastRows.Add( IntToStr(i+1) );
         fSelectedRows.Add( IntToStr(i+1) );
      end;
    end
    else//else write to temp dynamic array
    begin
      for i:=0 to fSortedList.Count-1 do
      begin
        Item := fSortedList.GetItem(i);
        BufferGrid2[i+1].Assign( BufferGrid[ Item^.RowNum ]);
      end;

      for i := 0 to RowCount-1 do
        BufferGrid[i].Assign (BufferGrid2[i]);
    end;
  end;

  StringList.Free;
  PrevSelected.Free;
  for iRow := 0 to RowCount-1 do
  begin
    BufferGrid[iRow].Free;
    BufferGrid2[iRow].Free;
  end;

  FSorting := False;
  SortOptions.SortCustom := nil;
  if Assigned(fOnEndSort) then
    fOnEndSort(Self, iCol);
  EndUpdate;
end;



{*******Search & Filter********************************************************}
function TSortGrid.FindFirst(var ARow: integer): boolean;
begin
  ARow := Search(1);
  Result := ARow <> -1;
end;

function TSortGrid.FindNext(var ARow: integer): boolean;
begin
  ARow := Search(Row+1);
  Result := ARow <> -1;
end;

function TSortGrid.Search(ARow: Integer): integer;
var
  iRow: Integer;
  Accept: Boolean;
  TmpGrd: array of TStrings;
begin
  Result:= -1;
  //Copy contents to TmpGrd, just to make it quicker
  SetLength(TmpGrd,RowCount);
  for iRow:= Arow to RowCount-1 do
  begin
    TmpGrd[iRow]:= TStringList.Create;
    TmpGrd[iRow].Assign( Rows[iRow] );
  end;

  for iRow:= ARow to RowCount-1 do
  begin
    Accept:= False;
    fOnSearch( TmpGrd[iRow], Accept);

    if Accept= True then
    begin
      Result := iRow;
      Break;
    end;
  end;

  for iRow := 0 to RowCount-1 do
    TmpGrd[iRow].Free;
end;

procedure TSortGrid.SetHideRows(Value: Boolean);
begin
    FHideRows := Value;
    Row := 1;   //Move row to place 1, looks stupid if marked row in the middle of nothing. Also deletes selected row info though :(
    Invalidate; //Draw with hidden rows
end;

procedure TSortGrid.SetFiltered(Value: Boolean);
var
  iRow, iCol: Integer;
  B, AlreadyUpdating, Accept: Boolean;
  TmpRows: TStringList;
  TmpGrd: array of array of string;
  aRows: array of integer;
  iToRow1, iToRow2, iFromRow: Integer;

    function RowFiltered(iRow: Integer): Boolean;
    var
      i: integer;
    begin
        Result:= False;
        for i:= 0 to High(aRows) do
            if iRow = aRows[i] then
            begin
                Result := True;
                Exit;
            end;
    end;

begin
  fFiltered := Value;

  //Nothing to do
  if ( FFiltered and RowEmpty(1) ) or
     ( not FFiltered and (FilterCount = 0) ) then Exit;

  B := Modified;
  AlreadyUpdating := NowUpdating;
  if not AlreadyUpdating then
      BeginUpdate;

  if FFiltered = True then
  begin
      FFilterCount := 0;
      TmpRows := TStringList.Create;

      //When I say filtered I mean the rows that should be shown not hidden
      //Calls fOnSetFilter event to determine if row should be filtered
      //if filtered copies row# to dynamic array: aRows
      for iRow := 1 to RowCount-1 do
      begin
        Accept := False;
        TmpRows.Clear;
        TmpRows.AddStrings( Rows[iRow] );
        if not Assigned(fOnSetFilter) then Break;
        fOnSetFilter( TmpRows, Accept);

        if Accept = True then
        begin
            SetLength( aRows, Length(aRows)+1 );
            aRows[high(aRows)] := iRow;
        end;
      end;

      TmpRows.Free;

      //Count of rows filtered
      FFilterCount := RowCount-1 - Length(aRows);

      SetLength(TmpGrd,ColCount,RowCount);//Copy grid to temp
      for iRow:= 0 to RowCount-1 do
          for iCol:= 0 to ColCount-1 do
              TmpGrd[iCol,iRow]:= Cells[iCol, iRow];

      //Now to a little moving of the rows, the concept is place the filtered
      //rows before rowcount and the others after rowcount, they are still there but invisible.
      iFromRow:= RowCount - Filtercount;//New RowCount
      iToRow1:= 0;//Copy filtered Rows to a place before iFromRow
      iToRow2:= 0;//Other rows after iFromRow

      //Copy row 0 to filtered rows
      SetLength( aRows, Length(aRows)+1 );
      aRows[high(aRows)] := 0;

      //Copies rows back to grid depending on their filtering state
      for iRow:= 0 to RowCount-1 do
          if RowFiltered(iRow) then//Show Row
          begin
              for iCol:= 0 to ColCount-1 do
                  Cells[iCol, iToRow1] := TmpGrd[iCol,iRow];
              Inc(iToRow1);
          end
          else
          begin
              for iCol:= 0 to ColCount-1 do
                  Cells[iCol, iFromRow+iToRow2] := TmpGrd[iCol,iRow];
              Inc(iToRow2);
          end;

      //Sets rowcount to only shows the filtered rows, the other rows lay after rowcount
      if FilterCount <> RowCount-1 then
      begin
          RowCount := RowCount-FilterCount;
          SortColumn( SortOptions.fSortCol );
      end
      else//all song filtered away
      begin
          SwapRows(1, RowCount);
          RowCount := 2;
      end;
      MoveTo(0,1);
  end
  else
  begin
      RowCount := RowCount+FilterCount;
      if RowEmpty(1) then DeleteRow(1);
      if FilterCount <> 0 then
        SortColumn( SortOptions.fSortCol );
      FFilterCount := 0;
  end;

  if not AlreadyUpdating then
      EndUpdate;
  Modified := b;
end;


{*******File*******************************************************************}
function TSortGrid.LoadFromFile(const FileName: String; RestoreWidth: Boolean): Boolean;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.LoadFromFile( FileName );
    Result := SetStringsFromLoad( List, RestoreWidth );
  except
    Result := False;
  end;
  List.Free;
end;

procedure TSortGrid.SaveToFile(const FileName: String; SaveWidth: Boolean);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.AddStrings( GetStringsToSave(SaveWidth) );
    List.SaveToFile( FileName );
  except
    MessageDLG('Can''t write to file:' +#13+ Filename, mtError, [mbOK], 0);
  end;
  List.Free;
end;

procedure TSortGrid.LoadFromReg(RegRoot: HKey; RegKey, RegName: String; RestoreWidth: Boolean);
var
  TheReg: TRegistry;
  i: integer;
  List: TStringList;
begin
  List := TStringList.Create;
  TheReg := TRegistry.Create;
  TheReg.RootKey:= RegRoot;

  if TheReg.OpenKey(RegKey,False) then
  begin
      i := 0;
      while( TheReg.ValueExists(RegName+IntToStr(i)) ) do
      begin
          List.Add( TheReg.ReadString(RegName+IntToStr(i)) );
          Inc(i);
      end;
      SetStringsFromLoad( List, RestoreWidth );
  end;

  TheReg.Free;
  List.Free;
end;

procedure TSortGrid.SaveToReg(RegRoot: HKey; RegKey, RegName: String; SaveWidth: Boolean);
var
  TheReg: TRegistry;
  i: integer;
  List: TStringList;
begin
  List := TStringList.Create;
  TheReg:= TRegistry.Create;
  TheReg.RootKey:= RegRoot;
  TheReg.OpenKey(RegKey, True);
  List.AddStrings( GetStringsToSave(SaveWidth) );
  for i := 0 to List.Count-1 do
    TheReg.WriteString(RegName+IntToStr(i), List[i]);
  TheReg.Free;
  List.Free;
end;


function TSortGrid.GetStringsToSave(SaveWidth: Boolean): TStrings;
var
  List: TStringList;
  i: Integer;
begin
  List := TStringList.Create;
  Result := TStringList.Create;
  Result.Clear;

  //Generelt settings
  List.Clear;
  List.Add(GenerelSettings);
  if DrawColBeforeRow then List.Add('1') else List.Add('0'); //Draw Col settings
  Result.Add( List.CommaText );

  //ColFont settings
  List.Clear;
  List.Add(FontColSettings);
  for i := 0 to ColFontList.Count-1 do
    List.Add( FontSettingToStr(ColFontList[i]) );
  Result.Add( List.CommaText );

  //RowFont settings
  List.Clear;
  List.Add(FontRowSettings);
  for i := 0 to RowFontList.Count-1 do
    List.Add( FontSettingToStr(RowFontList[i]) );
  Result.Add( List.CommaText );

  //User settings
  List.Clear;
  List.Add(CustomSettings);
  List.AddStrings( FUserSettings );
  Result.Add( List.CommaText );

  //Windows size
  if SaveWidth = True then
  begin
    List.Clear;
    List.Add( IntToStr( ParentForm.Width) );//Form size
    List.Add( IntToStr( ParentForm.Height) );
    for I := 0 to ColCount-1 do  //col width
      List.Add( IntToStr(ColWidths[I]) );
    List.Add( IntToStr( ParentForm.Left) ); //Form pos
    List.Add( IntToStr( ParentForm.Top) );
  end
  else
    for I := 0 to ColCount+3 do
      List.Add( '-1' );
  Result.Add( List.CommaText );

  //Contents
  for I := 0 to RowCount-1 do
    Result.Add( Rows[I].CommaText );

  List.Free;
end;


function TSortGrid.SetStringsFromLoad(List1: TStrings; RestoreWidth: Boolean): Boolean;
var
  List2: TStringList;
  FrmWidth, FrmHeight, iCol, iRow, i: Integer;
  r: TRect; //Desktop rect
begin
  List2 := TStringList.Create;
  try
    BeginUpdate;
    Clear;

    //Generelt settings
    List2.CommaText := List1[0];
    if List2[0] = GenerelSettings then
    begin
        //when settings read delete it so always contents from col 1+
        List1.Delete(0);
        List2.Delete(0);  //generel settings const
        DrawColBeforeRow := (List2[0] = '1');  //Draw Col settings
    end;

    //ColFont settings
    List2.CommaText := List1[0];
    if List2[0] = FontColSettings then
    begin
        List1.Delete(0);
        List2.Delete(0);
        ColFontList.ChangeCount(List2.Count);
        for i := 0 to List2.Count-1 do
            ColFontList[i] := StrToFontSetting(List2[i])
    end;

    //RowFont settings
    List2.CommaText := List1[0];
    if List2[0] = FontRowSettings then
    begin
        List1.Delete(0);
        List2.Delete(0);
        RowFontList.ChangeCount(List2.Count);
        for i := 0 to List2.Count-1 do
            RowFontList[i] := StrToFontSetting(List2[i])
    end;

    //Load User settings
    FUserSettings.Clear;
    List2.CommaText := List1[0];
    if List2[0] = CustomSettings then
    begin
        List1.Delete(0);
        List2.Delete(0);
        FUserSettings.AddStrings(List2);
    end;

    //Load Contents
    for iRow := 1 to List1.Count-1 do
    begin
      List2.CommaText := List1[iRow];
      for iCol := 0 to List2.Count-1 do
        Cells[iCol,iRow-1] := List2[iCol];
    end;
    RowCount := List1.Count-1;
    ColCount := List2.Count;

    //Restore saved Size
    if RestoreWidth = True then
    begin
      List2.CommaText := List1[0];
      //Form Size
      SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);//get visible desktop area
      FrmWidth := StrToInt(List2[0]);
      FrmHeight := StrToInt(List2[1]);
      if ((R.Right-R.Left) <= FrmWidth) and ((R.Bottom-R.Top) <= FrmHeight) then
        ParentForm.WindowState := wsMaximized
      else
      begin
        if List2[ColCount+2] <> '-1' then
          ParentForm.Left := StrToInt(List2[ColCount+2]);
        if List2[ColCount+3] <> '-1' then
          ParentForm.Top := StrToInt(List2[ColCount+3]);
        ParentForm.Width := FrmWidth;
        ParentForm.Height := FrmHeight;
      end;
      //Col width
      for iCol := 0 to ColCount-1 do
          ColWidths[iCol] := StrToInt(List2[iCol+2]);
    end
    else
      AutoSizeColumns(True);
    //Sort properly
    SortOptions.fSortDirection := sdAscending;
    SortColumn(0);

    Modified := False;
    Result := True;
    EndUpdate;
  except
    Result := False;
    EndUpdate;
  end;

  List2.Free;
end;


procedure TSortGrid.SaveToCSV(const FileName: String);
var
   F:TextFile;
   iRow,iCol : integer;
   quote, s: string;
begin
  try
    AssignFile(F, Filename);
    Rewrite(F);
    for iRow := 0 to RowCount-1 do
    begin
      for iCol := 0 to ColCount-1 do
      begin
        S := Cells[iCol,iRow];
        if Pos(',', S) > 0 then Quote := '"' else Quote := '';
        if iCol = ColCount-1 then
          Writeln(F, Quote,S,Quote)
        else
          Write(F, Quote,S,Quote,',');
      end;
    end;
    CloseFile(F);
  except
    MessageDLG('Can''t write to file:' +#13+ Filename, mtError, [mbOK], 0);
  end;
end;


procedure TSortGrid.AddRow(ACells: TStrings);
var
  ToRow, iCol: integer;
  Accept: boolean;
begin
  //You will have to call SortColumn your self after adding a row
  if Filtered then
  begin
      Accept := True;
      //Filter new row?
      fOnSetFilter(ACells, Accept);
      if Accept then //Accept=show row
      begin
          if RowEmpty(1) then
              ToRow := 1
          else
          begin
              if FilterCount > 0 then
                  SwapRows(RowCount, RowCount+Abs(FilterCount) );
              RowCount := RowCount+1;
              ToRow := RowCount-1;
          end;
      end
      else
      begin
          Inc(FFilterCount);
          ToRow := RowCount-1+FFilterCount;
      end;
  end
  else
  begin
      //Row must be empty
      if not RowEmpty( RowCount-1 ) then
          RowCount := RowCount+1;
      //Insert row last in grid
      ToRow := RowCount-1;
  end;

  //Insert row
  for iCol := 0 to ACells.Count-1 do
      Cells[iCol, ToRow] := ACells[iCol];
end;

procedure TSortGrid.AddCol(Header: string);
begin
  ColCount:= ColCount+1;
  Cells[ ColCount-1, 0] := Header;
end;


function TSortGrid.RowEmpty(ARow: Integer): Boolean;
var
  iCol: Integer;
begin
  Result:= True;
  for iCol:= 0 to ColCount-1 do
    if Cells[iCol, ARow] <> '' then
    begin
      Result:= False;
      Break;
    end;
end;


procedure TSortGrid.BeginUpdate;
begin
  inherited;

  OldUpdateSize := fSortOptions.fUpdateOnSizeChange;
  fSortOptions.fUpdateOnSizeChange := False;
end;

procedure TSortGrid.EndUpdate;
begin
  inherited;

  fSortOptions.fUpdateOnSizeChange := OldUpdateSize;
  if Assigned(fOnEndUpdate) then fOnEndUpdate(Self);
end;


function TSortGrid.UpdateCell( FindValue: string; FindACol: integer; SetValue: string;
                               SetCol: integer; UpdateAll: boolean): boolean;
var
    iRow: integer;
begin
    //Return true if a cell is updated
    //Search for a row with FindValue in FindCol and then update [SetCol,row] with SetValue
    Result := False;
    for iRow := 1 to RowCount + FilterCount do
        if Cells[FindACol, iRow] = FindValue then
        begin
            Cells[SetCol, iRow] := SetValue;
            Result := True;
            if not UpdateAll then Exit;
        end;
end;



{*************Print***************************************************************************}
function TSortGrid.PageCount: Integer;
begin
  SetFiltered(False);
  PrintOptions.PrintRange := prAll;
  fPageCount := 0;
  DrawToCanvas(nil, pmPageCount, 1,RowCount-1);
  Result := fPageCount;
end;

procedure TSortGrid.PrintPreview(Image: TImage);
begin
  SetFiltered(False);
  PrintOptions.PrintRange := prAll;
  fPageCount := 0;
  DrawToCanvas(Image.Canvas, pmPreview, 1,RowCount-1);
end;

procedure TSortGrid.Print;
begin
  if Printer.Printers.Count = 0 then
  begin
    MessageDlg('No Printer is installed', mtError, [mbOK],0);
    Exit;
  end;
  SetFiltered(False);
  Printer.Title := PrintOptions.fJobTitle;
  Printer.Copies := PrintOptions.fCopies;
  Printer.BeginDoc;
  DrawToCanvas(Printer.Canvas, pmPrint, PrintOptions.FromRow,PrintOptions.ToRow);
  Printer.EndDoc;
end;

procedure TSortGrid.DrawToCanvas(ACanvas: TCanvas; Mode: TPrintMode; FromRow, ToRow: Integer);
var
  PageWidth, PageHeight, PageRow,PageCol,I, iRow, FromCol,ToCol, X,Y: Integer;
  DoPaint: Boolean;

  function ScaleX(I:Integer): Integer;
  begin
    if Mode = pmPreview
      then result:= I
      {$IFDEF FPC}
      //FixMe: is Printer.Canvas.Handle okay ?
      else result:= I * ( GetDeviceCaps( Printer.Canvas.Handle, LOGPIXELSX)
      {$ELSE}
      else result:= I * ( GetDeviceCaps( Printer.Handle, LOGPIXELSX)
      {$ENDIF}
                          div Screen.PixelsPerInch);
  end;

  function ScaleY(I:Integer): Integer;
  begin
    if Mode = pmPreview
      then result := I
      else
        {$IFDEF FPC}
        //FixMe: is Printer.Canvas.Handle okay ?
        result := I * ( GetDeviceCaps(Printer.Canvas.Handle, LOGPIXELSY)
        {$ELSE}
        result := I * ( GetDeviceCaps(Printer.Handle, LOGPIXELSY)
        {$ENDIF}
                        div Screen.PixelsPerInch);
  end;

  procedure DrawCells(iRow:Integer);
  var
    iCol,I: Integer;
    R: TRect;
  begin
//Alignment must be done another day
    for iCol := FromCol to ToCol do
    begin
      //X Offset
      X := 0;
      for I := FromCol to iCol-1 do
        Inc(X, ScaleX(ColWidths[I]+1));
      //Text Rect
      R := Rect(X,Y, X+ScaleX(ColWidths[iCol]), Y+ScaleY(RowHeights[iRow]));
      //Draw on the Canvas
      if DoPaint then
        ACanvas.TextRect(R, X, Y, Cells[iCol, iRow]);
    end;
  end;

  procedure DrawTitle; //draw Header and Footer
  var
    S: String;
tmpfont:tfont;//I have no idea why you can't use gettextwidth when acanvas = printer.canvas, it returns wrong value
  begin
    if DoPaint then
begin
      ACanvas.Font.Size := 10;
canvas.font := acanvas.font;
end;
tmpfont:=font;

    //Title
    S := PrintOptions.PageTitle;
    if DoPaint then
      ACanvas.TextOut( (PageWidth div 2) - (ScaleX(Canvas.TextWidth(S) div 2)), ScaleY(1), S);
    //Page nr
    S := 'Page '+IntToStr(PageRow);
    if (ToCol < ColCount-1) or (PageCol > 1) then
      S := S+'-'+IntToStr(PageCol);
    if DoPaint then
      ACanvas.TextOut( PageWidth - ScaleX(Canvas.TextWidth(S)+10), PageHeight-ScaleY(19), S);

    if DoPaint then
begin
      ACanvas.Font.Size := Font.Size;
canvas.font := tmpfont;//Delphi 4.0 warning is wrong
end;
    Y := ScaleY(20);
    DrawCells(0);
  end;

begin
  //page size
  PageWidth := Printer.PageWidth;
  PageHeight := Printer.PageHeight;
  if Mode = pmPreview then
  begin
    {$IFDEF FPC}
    //FixMe: is Printer.Canvas.Handle okay ?
    PageWidth := PageWidth div ((GetDeviceCaps(Printer.Canvas.Handle, LOGPIXELSX) div Screen.PixelsPerInch));
    PageHeight := PageHeight div ((GetDeviceCaps(Printer.Canvas.Handle, LOGPIXELSY) div Screen.PixelsPerInch));
    {$ELSE}
    PageWidth := PageWidth div ((GetDeviceCaps(Printer.Handle, LOGPIXELSX) div Screen.PixelsPerInch));
    PageHeight := PageHeight div ((GetDeviceCaps(Printer.Handle, LOGPIXELSY) div Screen.PixelsPerInch));
    {$ENDIF}
    ACanvas.Brush.Color := ClWhite;
    ACanvas.FillRect( Rect(0,0,PageWidth,PageHeight));
  end;
  if Mode <> pmPageCount then
  begin
    ACanvas.Font := Font;
    ACanvas.Font.Color := clBlack;
  end;
  PageCol := 0;
  FromCol := -2;
  ToCol := -1;
  //scan cols
  repeat
    //Scan missing cols
    if FromCol = ToCol then
      Inc(FromCol)
    else
      FromCol := ToCol+1;
    Inc(ToCol);
    //Get Cols with width that fits page
    X := 0;
    for I := FromCol to ColCount-1 do
    begin
      Inc(X, ScaleX(ColWidths[I]+1));
      if X <= PageWidth then
        ToCol := I;
    end;
    PageRow := 1;
    Inc(PageCol);
    //Mode = PageCount
    Inc(fPageCount);
    //preview mode
    DoPaint := (((Mode = pmPreview) and (fPageCount = PrintOptions.PreviewPage)) or (Mode = pmPrint));
    //Header & Footer
    DrawTitle;
    //Contents
    iRow := FromRow;
    repeat
      Inc(Y, ScaleY(RowHeights[iRow]));
      if Y <= PageHeight-ScaleY(20) then
      begin //draw contents to canvas
        DrawCells(iRow);
        Inc(iRow);
      end
      else//New page
      begin
        if (DoPaint = True) and (Mode = pmPreview) then
          Exit;
        if Mode = pmPrint then
          Printer.NewPage;
        Inc(fPageCount);//pagecount
        DoPaint := (((Mode = pmPreview) and (fPageCount = PrintOptions.PreviewPage)) or (Mode = pmPrint));
        Inc(PageRow);
        DrawTitle;
      end;
      if (iRow = ToRow+1) and (ToCol < ColCount-1) and (Y <= PageHeight-ScaleY(20)) then
      begin
        if (DoPaint = True) and (Mode = pmPreview) then
          Exit;
        if Mode = pmPrint then
          Printer.NewPage;
        DrawTitle;
      end;
    until
      iRow = ToRow+1;
  until
    ToCol = ColCount-1;
end;

{procedure TSortGrid.DrawToCanvas(ACanvas: TCanvas; Mode: TPrintMode);
var
  PageWidth, PageHeight, PageRow,PageCol,I, iRow, FromCol,ToCol, X,Y: Integer;
  DoPaint: Boolean;

  function ScaleX(I:Integer): Integer;
  begin
    if Mode = pmPreview then
      Result := I
    else
      Result := I * (GetDeviceCaps(Printer.Handle, LOGPIXELSX) div Screen.PixelsPerInch);
  end;
  function ScaleY(I:Integer): Integer;
  begin
    if Mode = pmPreview then
      Result := I
    else
      Result := I * (GetDeviceCaps(Printer.Handle, LOGPIXELSY) div Screen.PixelsPerInch);
  end;

  procedure DrawCells(iRow:Integer);
  var
    iCol,I: Integer;
    R: TRect;
  begin
//Alignment must be done another day
    for iCol := FromCol to ToCol do
    begin
      //X Offset
      X := 0;
      for I := FromCol to iCol-1 do
        Inc(X, ScaleX(ColWidths[I]+1));
      //Text Rect
      R := Rect(X,Y, X+ScaleX(ColWidths[iCol]), Y+ScaleY(RowHeights[iRow]));
      //Draw on the Canvas
      if DoPaint then
        ACanvas.TextRect(R, X, Y, Cells[iCol, iRow]);
    end;
  end;

  procedure DrawTitle; //draw Header and Footer
  var
    S: String;
tmpfont:tfont;//I have no idea why you can't use gettextwidth when acanvas = printer.canvas, it returns wrong value
  begin
    if DoPaint then
begin
      ACanvas.Font.Size := 10;
tmpfont:=font;
canvas.font := acanvas.font;
end
else
tmpfont:=font;//to quite delphi warning
    //Title
    S := PrintOptions.PageTitle;
    if DoPaint then
      ACanvas.TextOut( (PageWidth div 2) - (ScaleX(Canvas.TextWidth(S) div 2)), ScaleY(1), S);
    //Page nr
    S := 'Page '+IntToStr(PageRow);
    if (ToCol < ColCount-1) or (PageCol > 1) then
      S := S+'-'+IntToStr(PageCol);
    if DoPaint then
      ACanvas.TextOut( PageWidth - ScaleX(Canvas.TextWidth(S)+10), PageHeight-ScaleY(19), S);

    if DoPaint then
begin
      ACanvas.Font.Size := Font.Size;
canvas.font := tmpfont;
end;
    Y := ScaleY(20);
    DrawCells(0);
  end;

begin
  //page size
  PageWidth := Printer.PageWidth;
  PageHeight := Printer.PageHeight;
  if Mode = pmPreview then
  begin
    PageWidth := PageWidth div ((GetDeviceCaps(Printer.Handle, LOGPIXELSX) div Screen.PixelsPerInch));
    PageHeight := PageHeight div ((GetDeviceCaps(Printer.Handle, LOGPIXELSY) div Screen.PixelsPerInch));
    ACanvas.Brush.Color := ClWhite;
    ACanvas.FillRect( Rect(0,0,PageWidth,PageHeight));
  end;
  if Mode <> pmPageCount then
  begin
    ACanvas.Font := Font;
    ACanvas.Font.Color := clBlack;
  end;
  PageCol := 0;
  FromCol := -2;
  ToCol := -1;
  //scan cols
  repeat
    //Scan missing cols
    if FromCol = ToCol then
      Inc(FromCol)
    else
      FromCol := ToCol+1;
    Inc(ToCol);
    //Get Cols with width that fits page
    X := 0;
    for I := FromCol to ColCount-1 do
    begin
      Inc(X, ScaleX(ColWidths[I]+1));
      if X <= PageWidth then
        ToCol := I;
    end;
    PageRow := 1;
    Inc(PageCol);
    //Mode = PageCount
    Inc(fPageCount);
    //preview mode
    DoPaint := (((Mode = pmPreview) and (fPageCount = PrintOptions.PreviewPage)) or (Mode = pmPrint));
    //Header & Footer
    DrawTitle;
    //Contents
    iRow := 1;
    repeat
      if ((PrintOptions.PrintRange = prSelected) and (RowSelected[iRow])) or (PrintOptions.PrintRange = prAll) then//determine if the row should be printed
      begin
        Inc(Y, ScaleY(RowHeights[iRow]));
        if Y <= PageHeight-ScaleY(20) then
        begin //draw contents to canvas
          DrawCells(iRow);
          Inc(iRow);
        end
        else//New page
        begin
          if (DoPaint = True) and (Mode = pmPreview) then
            Exit;
          if Mode = pmPrint then
            Printer.NewPage;
          Inc(fPageCount);//pagecount
          DoPaint := (((Mode = pmPreview) and (fPageCount = PrintOptions.PreviewPage)) or (Mode = pmPrint));
          Inc(PageRow);
          DrawTitle;
        end;
        if (iRow = RowCount-1+1) and (ToCol < ColCount-1) and (Y <= PageHeight-ScaleY(20)) then
        begin
          if (DoPaint = True) and (Mode = pmPreview) then
            Exit;
          if Mode = pmPrint then
            Printer.NewPage;
          DrawTitle;
        end;
      end
      else
        Inc(iRow);
    until
      iRow = RowCount-1+1;
  until
    ToCol = ColCount-1;
end;
}


procedure TFontList.SetItem(Index: Integer; const Value: TFontSetting);
begin
  inherited Items[Index] := Value;
end;

function TFontList.GetItem(Index: Integer): TFontSetting;
begin
  Result := (inherited Items[Index]) as TFontSetting;
end;


procedure TFontList.ChangeCount(Number: integer);
var
    i: integer;
begin
    if Number > 0 then
    for i := 0 to Number do
        Add( TFontSetting.Create )
    else if Number < 0 then
    for i := Number to 0 do
        Delete( Count-1 );
end;


procedure Register;
begin
  RegisterComponents( 'Grids', [TSortGrid]);
end;


end.
