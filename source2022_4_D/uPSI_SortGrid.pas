unit uPSI_SortGrid;
{
   sensor planning observation
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
  TPSImport_SortGrid = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSortGrid(CL: TPSPascalCompiler);
procedure SIRegister_TFontList(CL: TPSPascalCompiler);
procedure SIRegister_TFontSetting(CL: TPSPascalCompiler);
procedure SIRegister_TSortedList(CL: TPSPascalCompiler);
procedure SIRegister_TPrintOptions(CL: TPSPascalCompiler);
procedure SIRegister_TSortOptions(CL: TPSPascalCompiler);
procedure SIRegister_SortGrid(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SortGrid_Routines(S: TPSExec);
procedure RIRegister_TSortGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFontList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFontSetting(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSortedList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPrintOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSortOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_SortGrid(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ExtCtrls
  ,Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,MyGrids
  ,Printers
  ,Menus
  ,Registry
  ,contnrs
  ,SortGrid
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SortGrid]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSortGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMyStringGrid', 'TSortGrid') do
  with CL.AddClassN(CL.FindClass('TMyStringGrid'),'TSortGrid') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterPublishedProperties;
    RegisterProperty('FilterCount', 'integer', iptr);
    RegisterProperty('ColFont', 'TFontSetting integer', iptrw);
    RegisterProperty('RowFont', 'TFontSetting integer', iptrw);
    RegisterMethod('Function LoadFromFile( const FileName : String; RestoreWidth : Boolean) : Boolean');
    RegisterMethod('Procedure SaveToFile( const FileName : String; SaveWidth : Boolean)');
    RegisterMethod('Procedure LoadFromReg( RegRoot : HKey; RegKey, RegName : String; RestoreWidth : Boolean)');
    RegisterMethod('Procedure SaveToReg( RegRoot : HKey; RegKey, RegName : String; SaveWidth : Boolean)');
    RegisterMethod('Procedure SaveToCSV( const FileName : String)');
    RegisterProperty('ColCommaText', 'string Integer Boolean', iptrw);
    RegisterProperty('CellChecked', 'Boolean Integer Integer', iptrw);
    RegisterProperty('RowSelected', 'Boolean Integer', iptrw);
    RegisterProperty('SelectedRows', 'TStringList', iptr);
    RegisterMethod('Procedure SortRowsSel');
    RegisterMethod('Function SelCount : Integer');
    RegisterMethod('Procedure SortColumn( ACol : integer)');
    RegisterProperty('Sorting', 'Boolean', iptr);
    RegisterProperty('Modified', 'Boolean', iptrw);
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure InvalidateRow( ARow : integer)');
    RegisterMethod('Procedure InvalidateCol( ACol : integer)');
    RegisterMethod('Procedure MoveTo( ACol, ARow : integer; MakeVisible : Boolean)');
    RegisterMethod('Procedure FocusColRow( ACol, ARow : integer)');
    RegisterMethod('Function FindCol( Header : String) : Integer');
    RegisterMethod('Function FindRow( ACol : integer; Value : string; CaseSensitive : boolean) : integer');
    RegisterMethod('Function FindFirst( var ARow : integer) : boolean');
    RegisterMethod('Function FindNext( var ARow : integer) : boolean');
    RegisterMethod('Function RowEmpty( ARow : Integer) : Boolean');
    RegisterMethod('Procedure AutoSizeColumns( AlwaysSize : Boolean)');
    RegisterMethod('Procedure AutoSizeCol( const ACol : integer; AlwaysSize : Boolean)');
    RegisterMethod('Procedure MoveRow( FromIndex, ToIndex : integer)');
    RegisterMethod('Procedure MoveColumn( FromIndex, ToIndex : integer)');
    RegisterMethod('Procedure SwapRows( ARow1, ARow2 : integer)');
    RegisterMethod('Procedure SwapColumns( ACol1, ACol2 : integer)');
    RegisterMethod('Procedure AddRow( ACells : TStrings)');
    RegisterMethod('Procedure InsertRow( ARow : integer)');
    RegisterMethod('Procedure AddCol( Header : string)');
    RegisterMethod('Procedure InsertColumn( ACol : integer)');
    RegisterMethod('Function UpdateCell( FindValue : string; FindACol : integer; SetValue : string; SetCol : integer; UpdateAll : boolean) : boolean');
    RegisterMethod('Procedure Print');
    RegisterMethod('Procedure PrintPreview( Image : TImage)');
    RegisterMethod('Function PageCount : Integer');
    RegisterProperty('FixedRows', 'Integer', iptr);
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
    RegisterProperty('SortOptions', 'TSortOptions', iptrw);
    RegisterProperty('PrintOptions', 'TPrintOptions', iptrw);
    RegisterProperty('HideRows', 'Boolean', iptrw);
    RegisterProperty('Filtered', 'Boolean', iptrw);
    RegisterProperty('MultiSelect', 'Boolean', iptrw);
    RegisterProperty('UserSettings', 'TStringList', iptrw);
    RegisterProperty('AlignmentHorz', 'TAlignment', iptrw);
    RegisterProperty('AlignmentVert', 'TVertAlignment', iptrw);
    RegisterProperty('BevelStyle', 'TCellBevelStyle', iptrw);
    RegisterProperty('ProportionalScrollBars', 'Boolean', iptrw);
    RegisterProperty('ExtendedKeys', 'Boolean', iptrw);
    RegisterProperty('OnModified', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRowSelected', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRowInsert', 'TUpdateGridEvent', iptrw);
    RegisterProperty('OnRowDelete', 'TUpdateGridEvent', iptrw);
    RegisterProperty('OnColumnInsert', 'TUpdateGridEvent', iptrw);
    RegisterProperty('OnColumnDelete', 'TUpdateGridEvent', iptrw);
    RegisterProperty('OnColumnWidthsChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRowHeightsChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnSizeChanged', 'TSizeChangedEvent', iptrw);
    RegisterProperty('OnGetCellFormat', 'TFormatDrawCellEvent', iptrw);
    RegisterProperty('OnSetFilter', 'TSetFilterEvent', iptrw);
    RegisterProperty('OnSearch', 'TSearchEvent', iptrw);
    RegisterProperty('OnEndUpdate', 'TNotifyEvent', iptrw);
    RegisterProperty('OnGetSortStyle', 'TGetSortStyleEvent', iptrw);
    RegisterProperty('OnCellValidate', 'TCellValidateEvent', iptrw);
    RegisterProperty('OnSetChecked', 'TSetChecked', iptrw);
    RegisterProperty('OnGetComboBox', 'TGetComboBox', iptrw);
    RegisterProperty('OnSetComboBox', 'TSetComboBox', iptrw);
    RegisterProperty('OnSetEllipsis', 'TSetEllipsis', iptrw);
    RegisterProperty('Parent', 'TWinControl', iptRW);
    RegisterProperty('Canvas', 'TCanvas', iptr);
    {property Col;
    property ColWidths;
    property EditorMode;
    property GridHeight;
    property GridWidth;
    property LeftCol;
    property Selection;
    property Row;
    property RowHeights;
    property TabStops;
    property TopRow;}
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFontList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TFontList') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TFontList') do begin
    RegisterProperty('Items', 'TFontSetting Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterMethod('Procedure ChangeCount( Number : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFontSetting(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TFontSetting') do
  with CL.AddClassN(CL.FindClass('TObject'),'TFontSetting') do begin
    RegisterProperty('FontColor', 'TColor', iptrw);
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('Bold', 'Boolean', iptrw);
    RegisterProperty('Italic', 'Boolean', iptrw);
    RegisterProperty('UnderLine', 'Boolean', iptrw);
    RegisterProperty('Valid', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSortedList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TSortedList') do
  with CL.AddClassN(CL.FindClass('TList'),'TSortedList') do begin
    RegisterMethod('Function GetItem( const I : Integer) : PSortedListEntry');
    RegisterMethod('Procedure Reset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPrintOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TPrintOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TPrintOptions') do begin
    RegisterProperty('JobTitle', 'string', iptrw);
    RegisterProperty('PageTitle', 'string', iptrw);
    RegisterProperty('Copies', 'Cardinal', iptrw);
    RegisterProperty('PrintRange', 'TMyPrintRange', iptrw);
    RegisterProperty('FromRow', 'Cardinal', iptrw);
    RegisterProperty('ToRow', 'Cardinal', iptrw);
    RegisterProperty('PreviewPage', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSortOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSortOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSortOptions') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('SortCustom', 'TSortCustom', iptrw);
    RegisterProperty('CanSort', 'Boolean', iptrw);
    RegisterProperty('SecondaryIndex', 'String', iptrw);
    RegisterProperty('SortStyle', 'TSortStyle', iptrw);
    RegisterProperty('SortCaseSensitive', 'Boolean', iptrw);
    RegisterProperty('SortCol', 'Integer', iptrw);
    RegisterProperty('SortDirection', 'TSortDirection', iptrw);
    RegisterProperty('UpdateOnSizeChange', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SortGrid(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPrintMode', '( pmPrint, pmPreview, pmPageCount )');
  CL.AddTypeS('TMyPrintRange', '( prAll, prSelected )');
  CL.AddTypeS('TSortStyle', '( ssAutomatic, ssNormal, ssNumeric, ssNumericExten'
   +'ded, ssDateTime, ssTime, ssCustom )');
  CL.AddTypeS('TSortDirection', '( sdAscending, sdDescending )');
  CL.AddTypeS('TSetChecked', 'Procedure ( Sender : TObject; ACol, ARow : integer; State : Boolean)');
  CL.AddTypeS('TGetCombobox', 'Procedure ( Sender : TObject; ACol, ARow : integ'
   +'er; var Strs : TStringList; var Width, Height : integer; var Sorted : Boolean)');
  CL.AddTypeS('TSetCombobox', 'Procedure ( Sender : TObject; ACol, ARow : integer; Str : String)');
  CL.AddTypeS('TSetEllipsis', 'Procedure ( Sender : TObject; ACol, ARow : integer)');
  SIRegister_TSortOptions(CL);
  SIRegister_TPrintOptions(CL);
  CL.AddTypeS('TSortedListEntry', 'record Str: String; RowNum : integer; SortOption: TSortOptions; end');
  //CL.AddTypeS('PSortedListEntry', '^TSortedListEntry // will not work');
  SIRegister_TSortedList(CL);
  CL.AddTypeS('TCellBevelStyle', '( cbNone, cbRaised, cbLowered )');
  CL.AddTypeS('TCellBevel', 'record Style: TCellBevelStyle; UpperLeftColor: TColor; LowerRightColor : TColor; end');
  CL.AddTypeS('TVertAlignment', '( taTopJustify, taBottomJustify, taMiddle )');
  CL.AddTypeS('TFormatOptions', 'record Brush : TBrush; Font : TFont; Alignment'
   +'Horz : TAlignment; AlignmentVert : TVertAlignment; Bevel : TCellBevel; HideText : Boolean; end');
  SIRegister_TFontSetting(CL);
  SIRegister_TFontList(CL);
  CL.AddTypeS('TFormatDrawCellEvent', 'Procedure ( Sender : TObject; Col, Row :'
   +' integer; State : TGridDrawState; var FormatOptions : TFormatOptions; var '
   +'CheckBox, Combobox, Ellipsis : Boolean)');
  CL.AddTypeS('TSetFilterEvent', 'Procedure ( ARows : TStrings; var Accept : Boolean)');
  CL.AddTypeS('TSearchEvent', 'Procedure ( ARows : TStrings; var Accept : Boolean)');
  CL.AddTypeS('TUpdateGridEvent', 'Procedure ( Sender : TObject; ARow : integer)');
  CL.AddTypeS('TSizeChangedEvent', 'Procedure ( Sender : TObject; OldColCount, OldRowCount : integer)');
  CL.AddTypeS('TBeginSortEvent', 'Procedure ( Sender : TObject; var Col : integer)');
  CL.AddTypeS('TEndSortEvent', 'Procedure ( Sender : TObject; Col : integer)');
  CL.AddTypeS('TGetSortStyleEvent', 'Procedure ( Sender : TObject; Col : integer; var SortStyle : TSortStyle)');
  CL.AddTypeS('TCellValidateEvent', 'Procedure ( Sender : TObject; ACol, ARow :'
   +' integer; const OldValue : string; var NewValue : String; var Valid : Boolean)');
  SIRegister_TSortGrid(CL);
 CL.AddDelphiFunction('Function ExtendedCompare( const Str1, Str2 : String) : Integer');
 CL.AddDelphiFunction('Function NormalCompare( const Str1, Str2 : String) : Integer');
 CL.AddDelphiFunction('Function DateTimeCompare( const Str1, Str2 : String) : Integer');
 CL.AddDelphiFunction('Function NumericCompare( const Str1, Str2 : String) : Integer');
 CL.AddDelphiFunction('Function TimeCompare( const Str1, Str2 : String) : Integer');
 //CL.AddDelphiFunction('Function Compare( Item1, Item2 : Pointer) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSortGridOnSetEllipsis_W(Self: TSortGrid; const T: TSetEllipsis);
begin Self.OnSetEllipsis := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnSetEllipsis_R(Self: TSortGrid; var T: TSetEllipsis);
begin T := Self.OnSetEllipsis; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnSetComboBox_W(Self: TSortGrid; const T: TSetComboBox);
begin Self.OnSetComboBox := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnSetComboBox_R(Self: TSortGrid; var T: TSetComboBox);
begin T := Self.OnSetComboBox; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnGetComboBox_W(Self: TSortGrid; const T: TGetComboBox);
begin Self.OnGetComboBox := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnGetComboBox_R(Self: TSortGrid; var T: TGetComboBox);
begin T := Self.OnGetComboBox; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnSetChecked_W(Self: TSortGrid; const T: TSetChecked);
begin Self.OnSetChecked := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnSetChecked_R(Self: TSortGrid; var T: TSetChecked);
begin T := Self.OnSetChecked; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnCellValidate_W(Self: TSortGrid; const T: TCellValidateEvent);
begin Self.OnCellValidate := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnCellValidate_R(Self: TSortGrid; var T: TCellValidateEvent);
begin T := Self.OnCellValidate; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnGetSortStyle_W(Self: TSortGrid; const T: TGetSortStyleEvent);
begin Self.OnGetSortStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnGetSortStyle_R(Self: TSortGrid; var T: TGetSortStyleEvent);
begin T := Self.OnGetSortStyle; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnEndUpdate_W(Self: TSortGrid; const T: TNotifyEvent);
begin Self.OnEndUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnEndUpdate_R(Self: TSortGrid; var T: TNotifyEvent);
begin T := Self.OnEndUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnSearch_W(Self: TSortGrid; const T: TSearchEvent);
begin Self.OnSearch := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnSearch_R(Self: TSortGrid; var T: TSearchEvent);
begin T := Self.OnSearch; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnSetFilter_W(Self: TSortGrid; const T: TSetFilterEvent);
begin Self.OnSetFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnSetFilter_R(Self: TSortGrid; var T: TSetFilterEvent);
begin T := Self.OnSetFilter; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnGetCellFormat_W(Self: TSortGrid; const T: TFormatDrawCellEvent);
begin Self.OnGetCellFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnGetCellFormat_R(Self: TSortGrid; var T: TFormatDrawCellEvent);
begin T := Self.OnGetCellFormat; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnSizeChanged_W(Self: TSortGrid; const T: TSizeChangedEvent);
begin Self.OnSizeChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnSizeChanged_R(Self: TSortGrid; var T: TSizeChangedEvent);
begin T := Self.OnSizeChanged; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnRowHeightsChanged_W(Self: TSortGrid; const T: TNotifyEvent);
begin Self.OnRowHeightsChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnRowHeightsChanged_R(Self: TSortGrid; var T: TNotifyEvent);
begin T := Self.OnRowHeightsChanged; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnColumnWidthsChanged_W(Self: TSortGrid; const T: TNotifyEvent);
begin Self.OnColumnWidthsChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnColumnWidthsChanged_R(Self: TSortGrid; var T: TNotifyEvent);
begin T := Self.OnColumnWidthsChanged; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnColumnDelete_W(Self: TSortGrid; const T: TUpdateGridEvent);
begin Self.OnColumnDelete := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnColumnDelete_R(Self: TSortGrid; var T: TUpdateGridEvent);
begin T := Self.OnColumnDelete; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnColumnInsert_W(Self: TSortGrid; const T: TUpdateGridEvent);
begin Self.OnColumnInsert := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnColumnInsert_R(Self: TSortGrid; var T: TUpdateGridEvent);
begin T := Self.OnColumnInsert; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnRowDelete_W(Self: TSortGrid; const T: TUpdateGridEvent);
begin Self.OnRowDelete := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnRowDelete_R(Self: TSortGrid; var T: TUpdateGridEvent);
begin T := Self.OnRowDelete; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnRowInsert_W(Self: TSortGrid; const T: TUpdateGridEvent);
begin Self.OnRowInsert := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnRowInsert_R(Self: TSortGrid; var T: TUpdateGridEvent);
begin T := Self.OnRowInsert; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnRowSelected_W(Self: TSortGrid; const T: TNotifyEvent);
begin Self.OnRowSelected := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnRowSelected_R(Self: TSortGrid; var T: TNotifyEvent);
begin T := Self.OnRowSelected; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnModified_W(Self: TSortGrid; const T: TNotifyEvent);
begin Self.OnModified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridOnModified_R(Self: TSortGrid; var T: TNotifyEvent);
begin T := Self.OnModified; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridExtendedKeys_W(Self: TSortGrid; const T: Boolean);
begin Self.ExtendedKeys := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridExtendedKeys_R(Self: TSortGrid; var T: Boolean);
begin T := Self.ExtendedKeys; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridProportionalScrollBars_W(Self: TSortGrid; const T: Boolean);
begin Self.ProportionalScrollBars := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridProportionalScrollBars_R(Self: TSortGrid; var T: Boolean);
begin T := Self.ProportionalScrollBars; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridBevelStyle_W(Self: TSortGrid; const T: TCellBevelStyle);
begin Self.BevelStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridBevelStyle_R(Self: TSortGrid; var T: TCellBevelStyle);
begin T := Self.BevelStyle; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridAlignmentVert_W(Self: TSortGrid; const T: TVertAlignment);
begin Self.AlignmentVert := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridAlignmentVert_R(Self: TSortGrid; var T: TVertAlignment);
begin T := Self.AlignmentVert; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridAlignmentHorz_W(Self: TSortGrid; const T: TAlignment);
begin Self.AlignmentHorz := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridAlignmentHorz_R(Self: TSortGrid; var T: TAlignment);
begin T := Self.AlignmentHorz; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridUserSettings_W(Self: TSortGrid; const T: TStringList);
begin Self.UserSettings := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridUserSettings_R(Self: TSortGrid; var T: TStringList);
begin T := Self.UserSettings; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridMultiSelect_W(Self: TSortGrid; const T: Boolean);
begin Self.MultiSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridMultiSelect_R(Self: TSortGrid; var T: Boolean);
begin T := Self.MultiSelect; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridFiltered_W(Self: TSortGrid; const T: Boolean);
begin Self.Filtered := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridFiltered_R(Self: TSortGrid; var T: Boolean);
begin T := Self.Filtered; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridHideRows_W(Self: TSortGrid; const T: Boolean);
begin Self.HideRows := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridHideRows_R(Self: TSortGrid; var T: Boolean);
begin T := Self.HideRows; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridPrintOptions_W(Self: TSortGrid; const T: TPrintOptions);
begin Self.PrintOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridPrintOptions_R(Self: TSortGrid; var T: TPrintOptions);
begin T := Self.PrintOptions; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridSortOptions_W(Self: TSortGrid; const T: TSortOptions);
begin Self.SortOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridSortOptions_R(Self: TSortGrid; var T: TSortOptions);
begin T := Self.SortOptions; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridPopupMenu_W(Self: TSortGrid; const T: TPopupMenu);
begin Self.PopupMenu := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridPopupMenu_R(Self: TSortGrid; var T: TPopupMenu);
begin T := Self.PopupMenu; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridFixedRows_R(Self: TSortGrid; var T: Integer);
begin T := Self.FixedRows; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridModified_W(Self: TSortGrid; const T: Boolean);
begin Self.Modified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridModified_R(Self: TSortGrid; var T: Boolean);
begin T := Self.Modified; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridSorting_R(Self: TSortGrid; var T: Boolean);
begin T := Self.Sorting; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridSelectedRows_R(Self: TSortGrid; var T: TStringList);
begin T := Self.SelectedRows; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridRowSelected_W(Self: TSortGrid; const T: Boolean; const t1: Integer);
begin Self.RowSelected[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridRowSelected_R(Self: TSortGrid; var T: Boolean; const t1: Integer);
begin T := Self.RowSelected[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridCellChecked_W(Self: TSortGrid; const T: Boolean; const t1: Integer; const t2: Integer);
begin Self.CellChecked[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridCellChecked_R(Self: TSortGrid; var T: Boolean; const t1: Integer; const t2: Integer);
begin T := Self.CellChecked[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridColCommaText_W(Self: TSortGrid; const T: string; const t1: Integer; const t2: Boolean);
begin Self.ColCommaText[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridColCommaText_R(Self: TSortGrid; var T: string; const t1: Integer; const t2: Boolean);
begin T := Self.ColCommaText[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridRowFont_W(Self: TSortGrid; const T: TFontSetting; const t1: integer);
begin Self.RowFont[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridRowFont_R(Self: TSortGrid; var T: TFontSetting; const t1: integer);
begin T := Self.RowFont[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridColFont_W(Self: TSortGrid; const T: TFontSetting; const t1: integer);
begin Self.ColFont[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridColFont_R(Self: TSortGrid; var T: TFontSetting; const t1: integer);
begin T := Self.ColFont[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSortGridFilterCount_R(Self: TSortGrid; var T: integer);
begin T := Self.FilterCount; end;

(*----------------------------------------------------------------------------*)
procedure TFontListItems_W(Self: TFontList; const T: TFontSetting; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontListItems_R(Self: TFontList; var T: TFontSetting; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingValid_W(Self: TFontSetting; const T: Boolean);
Begin Self.Valid := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingValid_R(Self: TFontSetting; var T: Boolean);
Begin T := Self.Valid; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingUnderLine_W(Self: TFontSetting; const T: Boolean);
Begin Self.UnderLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingUnderLine_R(Self: TFontSetting; var T: Boolean);
Begin T := Self.UnderLine; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingItalic_W(Self: TFontSetting; const T: Boolean);
Begin Self.Italic := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingItalic_R(Self: TFontSetting; var T: Boolean);
Begin T := Self.Italic; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingBold_W(Self: TFontSetting; const T: Boolean);
Begin Self.Bold := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingBold_R(Self: TFontSetting; var T: Boolean);
Begin T := Self.Bold; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingBackColor_W(Self: TFontSetting; const T: TColor);
Begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingBackColor_R(Self: TFontSetting; var T: TColor);
Begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingFontColor_W(Self: TFontSetting; const T: TColor);
Begin Self.FontColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontSettingFontColor_R(Self: TFontSetting; var T: TColor);
Begin T := Self.FontColor; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsPreviewPage_W(Self: TPrintOptions; const T: Cardinal);
begin Self.PreviewPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsPreviewPage_R(Self: TPrintOptions; var T: Cardinal);
begin T := Self.PreviewPage; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsToRow_W(Self: TPrintOptions; const T: Cardinal);
begin Self.ToRow := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsToRow_R(Self: TPrintOptions; var T: Cardinal);
begin T := Self.ToRow; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsFromRow_W(Self: TPrintOptions; const T: Cardinal);
begin Self.FromRow := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsFromRow_R(Self: TPrintOptions; var T: Cardinal);
begin T := Self.FromRow; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsPrintRange_W(Self: TPrintOptions; const T: TMyPrintRange);
begin Self.PrintRange := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsPrintRange_R(Self: TPrintOptions; var T: TMyPrintRange);
begin T := Self.PrintRange; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsCopies_W(Self: TPrintOptions; const T: Cardinal);
begin Self.Copies := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsCopies_R(Self: TPrintOptions; var T: Cardinal);
begin T := Self.Copies; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsPageTitle_W(Self: TPrintOptions; const T: string);
begin Self.PageTitle := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsPageTitle_R(Self: TPrintOptions; var T: string);
begin T := Self.PageTitle; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsJobTitle_W(Self: TPrintOptions; const T: string);
begin Self.JobTitle := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintOptionsJobTitle_R(Self: TPrintOptions; var T: string);
begin T := Self.JobTitle; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsUpdateOnSizeChange_W(Self: TSortOptions; const T: Boolean);
begin Self.UpdateOnSizeChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsUpdateOnSizeChange_R(Self: TSortOptions; var T: Boolean);
begin T := Self.UpdateOnSizeChange; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSortDirection_W(Self: TSortOptions; const T: TSortDirection);
begin Self.SortDirection := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSortDirection_R(Self: TSortOptions; var T: TSortDirection);
begin T := Self.SortDirection; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSortCol_W(Self: TSortOptions; const T: Integer);
begin Self.SortCol := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSortCol_R(Self: TSortOptions; var T: Integer);
begin T := Self.SortCol; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSortCaseSensitive_W(Self: TSortOptions; const T: Boolean);
begin Self.SortCaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSortCaseSensitive_R(Self: TSortOptions; var T: Boolean);
begin T := Self.SortCaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSortStyle_W(Self: TSortOptions; const T: TSortStyle);
begin Self.SortStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSortStyle_R(Self: TSortOptions; var T: TSortStyle);
begin T := Self.SortStyle; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSecondaryIndex_W(Self: TSortOptions; const T: String);
begin Self.SecondaryIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSecondaryIndex_R(Self: TSortOptions; var T: String);
begin T := Self.SecondaryIndex; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsCanSort_W(Self: TSortOptions; const T: Boolean);
begin Self.CanSort := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsCanSort_R(Self: TSortOptions; var T: Boolean);
begin T := Self.CanSort; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSortCustom_W(Self: TSortOptions; const T: TSortCustom);
begin Self.SortCustom := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortOptionsSortCustom_R(Self: TSortOptions; var T: TSortCustom);
begin T := Self.SortCustom; end;


procedure TControlParentR(Self: TControl; var T: TWinControl); begin T := Self.Parent; end;
procedure TControlParentW(Self: TControl; T: TWinControl); begin Self.Parent:= T; end;

procedure TBitmapCanvas_R(Self: TSortGrid; var T: TCanvas); begin T:= Self.Canvas; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_SortGrid_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ExtendedCompare, 'ExtendedCompare', cdRegister);
 S.RegisterDelphiFunction(@NormalCompare, 'NormalCompare', cdRegister);
 S.RegisterDelphiFunction(@DateTimeCompare, 'DateTimeCompare', cdRegister);
 S.RegisterDelphiFunction(@NumericCompare, 'NumericCompare', cdRegister);
 S.RegisterDelphiFunction(@TimeCompare, 'TimeCompare', cdRegister);
 //S.RegisterDelphiFunction(@Compare, 'Compare', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSortGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSortGrid) do begin
    RegisterConstructor(@TSortGrid.Create, 'Create');
    RegisterMethod(@TSortGrid.Destroy, 'Free');
    RegisterPropertyHelper(@TSortGridFilterCount_R,nil,'FilterCount');
    RegisterPropertyHelper(@TSortGridColFont_R,@TSortGridColFont_W,'ColFont');
    RegisterPropertyHelper(@TSortGridRowFont_R,@TSortGridRowFont_W,'RowFont');
    RegisterMethod(@TSortGrid.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TSortGrid.SaveToFile, 'SaveToFile');
    RegisterMethod(@TSortGrid.LoadFromReg, 'LoadFromReg');
    RegisterMethod(@TSortGrid.SaveToReg, 'SaveToReg');
    RegisterMethod(@TSortGrid.SaveToCSV, 'SaveToCSV');
    RegisterPropertyHelper(@TSortGridColCommaText_R,@TSortGridColCommaText_W,'ColCommaText');
    RegisterPropertyHelper(@TSortGridCellChecked_R,@TSortGridCellChecked_W,'CellChecked');
    RegisterPropertyHelper(@TSortGridRowSelected_R,@TSortGridRowSelected_W,'RowSelected');
    RegisterPropertyHelper(@TSortGridSelectedRows_R,nil,'SelectedRows');
    RegisterMethod(@TSortGrid.SortRowsSel, 'SortRowsSel');
    RegisterMethod(@TSortGrid.SelCount, 'SelCount');
    RegisterMethod(@TSortGrid.SortColumn, 'SortColumn');
    RegisterPropertyHelper(@TSortGridSorting_R,nil,'Sorting');
    RegisterPropertyHelper(@TSortGridModified_R,@TSortGridModified_W,'Modified');
    RegisterMethod(@TSortGrid.Clear, 'Clear');
    RegisterMethod(@TSortGrid.InvalidateRow, 'InvalidateRow');
    RegisterMethod(@TSortGrid.InvalidateCol, 'InvalidateCol');
    RegisterMethod(@TSortGrid.MoveTo, 'MoveTo');
    RegisterMethod(@TSortGrid.FocusColRow, 'FocusColRow');
    RegisterMethod(@TSortGrid.FindCol, 'FindCol');
    RegisterMethod(@TSortGrid.FindRow, 'FindRow');
    RegisterMethod(@TSortGrid.FindFirst, 'FindFirst');
    RegisterMethod(@TSortGrid.FindNext, 'FindNext');
    RegisterMethod(@TSortGrid.RowEmpty, 'RowEmpty');
    RegisterMethod(@TSortGrid.AutoSizeColumns, 'AutoSizeColumns');
    RegisterMethod(@TSortGrid.AutoSizeCol, 'AutoSizeCol');
    RegisterMethod(@TSortGrid.MoveRow, 'MoveRow');
    RegisterMethod(@TSortGrid.MoveColumn, 'MoveColumn');
    RegisterMethod(@TSortGrid.SwapRows, 'SwapRows');
    RegisterMethod(@TSortGrid.SwapColumns, 'SwapColumns');
    RegisterMethod(@TSortGrid.AddRow, 'AddRow');
    RegisterMethod(@TSortGrid.InsertRow, 'InsertRow');
    RegisterMethod(@TSortGrid.AddCol, 'AddCol');
    RegisterMethod(@TSortGrid.InsertColumn, 'InsertColumn');
    RegisterMethod(@TSortGrid.UpdateCell, 'UpdateCell');
    RegisterMethod(@TSortGrid.Print, 'Print');
    RegisterMethod(@TSortGrid.PrintPreview, 'PrintPreview');
    RegisterMethod(@TSortGrid.PageCount, 'PageCount');
    RegisterPropertyHelper(@TSortGridFixedRows_R,nil,'FixedRows');
    RegisterPropertyHelper(@TSortGridPopupMenu_R,@TSortGridPopupMenu_W,'PopupMenu');
    RegisterPropertyHelper(@TSortGridSortOptions_R,@TSortGridSortOptions_W,'SortOptions');
    RegisterPropertyHelper(@TSortGridPrintOptions_R,@TSortGridPrintOptions_W,'PrintOptions');
    RegisterPropertyHelper(@TSortGridHideRows_R,@TSortGridHideRows_W,'HideRows');
    RegisterPropertyHelper(@TSortGridFiltered_R,@TSortGridFiltered_W,'Filtered');
    RegisterPropertyHelper(@TSortGridMultiSelect_R,@TSortGridMultiSelect_W,'MultiSelect');
    RegisterPropertyHelper(@TSortGridUserSettings_R,@TSortGridUserSettings_W,'UserSettings');
    RegisterPropertyHelper(@TSortGridAlignmentHorz_R,@TSortGridAlignmentHorz_W,'AlignmentHorz');
    RegisterPropertyHelper(@TSortGridAlignmentVert_R,@TSortGridAlignmentVert_W,'AlignmentVert');
    RegisterPropertyHelper(@TSortGridBevelStyle_R,@TSortGridBevelStyle_W,'BevelStyle');
    RegisterPropertyHelper(@TSortGridProportionalScrollBars_R,@TSortGridProportionalScrollBars_W,'ProportionalScrollBars');
    RegisterPropertyHelper(@TSortGridExtendedKeys_R,@TSortGridExtendedKeys_W,'ExtendedKeys');
    RegisterPropertyHelper(@TSortGridOnModified_R,@TSortGridOnModified_W,'OnModified');
    RegisterPropertyHelper(@TSortGridOnRowSelected_R,@TSortGridOnRowSelected_W,'OnRowSelected');
    RegisterPropertyHelper(@TSortGridOnRowInsert_R,@TSortGridOnRowInsert_W,'OnRowInsert');
    RegisterPropertyHelper(@TSortGridOnRowDelete_R,@TSortGridOnRowDelete_W,'OnRowDelete');
    RegisterPropertyHelper(@TSortGridOnColumnInsert_R,@TSortGridOnColumnInsert_W,'OnColumnInsert');
    RegisterPropertyHelper(@TSortGridOnColumnDelete_R,@TSortGridOnColumnDelete_W,'OnColumnDelete');
    RegisterPropertyHelper(@TSortGridOnColumnWidthsChanged_R,@TSortGridOnColumnWidthsChanged_W,'OnColumnWidthsChanged');
    RegisterPropertyHelper(@TSortGridOnRowHeightsChanged_R,@TSortGridOnRowHeightsChanged_W,'OnRowHeightsChanged');
    RegisterPropertyHelper(@TSortGridOnSizeChanged_R,@TSortGridOnSizeChanged_W,'OnSizeChanged');
    RegisterPropertyHelper(@TSortGridOnGetCellFormat_R,@TSortGridOnGetCellFormat_W,'OnGetCellFormat');
    RegisterPropertyHelper(@TSortGridOnSetFilter_R,@TSortGridOnSetFilter_W,'OnSetFilter');
    RegisterPropertyHelper(@TSortGridOnSearch_R,@TSortGridOnSearch_W,'OnSearch');
    RegisterPropertyHelper(@TSortGridOnEndUpdate_R,@TSortGridOnEndUpdate_W,'OnEndUpdate');
    RegisterPropertyHelper(@TSortGridOnGetSortStyle_R,@TSortGridOnGetSortStyle_W,'OnGetSortStyle');
    RegisterPropertyHelper(@TSortGridOnCellValidate_R,@TSortGridOnCellValidate_W,'OnCellValidate');
    RegisterPropertyHelper(@TSortGridOnSetChecked_R,@TSortGridOnSetChecked_W,'OnSetChecked');
    RegisterPropertyHelper(@TSortGridOnGetComboBox_R,@TSortGridOnGetComboBox_W,'OnGetComboBox');
    RegisterPropertyHelper(@TSortGridOnSetComboBox_R,@TSortGridOnSetComboBox_W,'OnSetComboBox');
    RegisterPropertyHelper(@TSortGridOnSetEllipsis_R,@TSortGridOnSetEllipsis_W,'OnSetEllipsis');
    RegisterPropertyHelper(@TControlParentR, @TControlParentW, 'PARENT');
    RegisterPropertyHelper(@TBitmapCanvas_R,nil,'Canvas');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFontList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFontList) do
  begin
    RegisterPropertyHelper(@TFontListItems_R,@TFontListItems_W,'Items');
    RegisterMethod(@TFontList.ChangeCount, 'ChangeCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFontSetting(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFontSetting) do
  begin
    RegisterPropertyHelper(@TFontSettingFontColor_R,@TFontSettingFontColor_W,'FontColor');
    RegisterPropertyHelper(@TFontSettingBackColor_R,@TFontSettingBackColor_W,'BackColor');
    RegisterPropertyHelper(@TFontSettingBold_R,@TFontSettingBold_W,'Bold');
    RegisterPropertyHelper(@TFontSettingItalic_R,@TFontSettingItalic_W,'Italic');
    RegisterPropertyHelper(@TFontSettingUnderLine_R,@TFontSettingUnderLine_W,'UnderLine');
    RegisterPropertyHelper(@TFontSettingValid_R,@TFontSettingValid_W,'Valid');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSortedList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSortedList) do
  begin
    RegisterMethod(@TSortedList.GetItem, 'GetItem');
    RegisterMethod(@TSortedList.Reset, 'Reset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPrintOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPrintOptions) do
  begin
    RegisterPropertyHelper(@TPrintOptionsJobTitle_R,@TPrintOptionsJobTitle_W,'JobTitle');
    RegisterPropertyHelper(@TPrintOptionsPageTitle_R,@TPrintOptionsPageTitle_W,'PageTitle');
    RegisterPropertyHelper(@TPrintOptionsCopies_R,@TPrintOptionsCopies_W,'Copies');
    RegisterPropertyHelper(@TPrintOptionsPrintRange_R,@TPrintOptionsPrintRange_W,'PrintRange');
    RegisterPropertyHelper(@TPrintOptionsFromRow_R,@TPrintOptionsFromRow_W,'FromRow');
    RegisterPropertyHelper(@TPrintOptionsToRow_R,@TPrintOptionsToRow_W,'ToRow');
    RegisterPropertyHelper(@TPrintOptionsPreviewPage_R,@TPrintOptionsPreviewPage_W,'PreviewPage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSortOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSortOptions) do
  begin
    RegisterConstructor(@TSortOptions.Create, 'Create');
    RegisterPropertyHelper(@TSortOptionsSortCustom_R,@TSortOptionsSortCustom_W,'SortCustom');
    RegisterPropertyHelper(@TSortOptionsCanSort_R,@TSortOptionsCanSort_W,'CanSort');
    RegisterPropertyHelper(@TSortOptionsSecondaryIndex_R,@TSortOptionsSecondaryIndex_W,'SecondaryIndex');
    RegisterPropertyHelper(@TSortOptionsSortStyle_R,@TSortOptionsSortStyle_W,'SortStyle');
    RegisterPropertyHelper(@TSortOptionsSortCaseSensitive_R,@TSortOptionsSortCaseSensitive_W,'SortCaseSensitive');
    RegisterPropertyHelper(@TSortOptionsSortCol_R,@TSortOptionsSortCol_W,'SortCol');
    RegisterPropertyHelper(@TSortOptionsSortDirection_R,@TSortOptionsSortDirection_W,'SortDirection');
    RegisterPropertyHelper(@TSortOptionsUpdateOnSizeChange_R,@TSortOptionsUpdateOnSizeChange_W,'UpdateOnSizeChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SortGrid(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSortOptions(CL);
  RIRegister_TPrintOptions(CL);
  RIRegister_TSortedList(CL);
  RIRegister_TFontSetting(CL);
  RIRegister_TFontList(CL);
  RIRegister_TSortGrid(CL);
end;

 
 
{ TPSImport_SortGrid }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SortGrid.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SortGrid(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SortGrid.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SortGrid(ri);
  RIRegister_SortGrid_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
