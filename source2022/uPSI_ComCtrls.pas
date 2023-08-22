unit uPSI_ComCtrls;
{
without win utils  , advanced tlistview , more basemethods in customcontrol
add tBytesstream , redesign of construct and overrides , ttreenode.data   , changedevent  - tabheight 4.7.6.10
    TLVSelectItemEvent, caption rw  - add date of datetimepicker   , tupdown-max  pagecontrol change event, multiline}
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
  TPSImport_ComCtrls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ TBytesStream }

  TBytesStream = class(TMemoryStream)
  private
    FBytes: TBytes;
    
    FCapacity, FSize: Longint;

  protected
    function Realloc(var NewCapacity: Longint): Pointer; override;
  public
    constructor Create(const ABytes: TBytes); //overload;

    property Bytes: TBytes read FBytes;
  end;



{ compile-time registration functions }
procedure SIRegister_TComboBoxExActionLink(CL: TPSPascalCompiler);
procedure SIRegister_TComboBoxEx(CL: TPSPascalCompiler);
procedure SIRegister_TCustomComboBoxEx(CL: TPSPascalCompiler);
procedure SIRegister_TComboBoxExStrings(CL: TPSPascalCompiler);
procedure SIRegister_TComboExItems(CL: TPSPascalCompiler);
procedure SIRegister_TComboExItem(CL: TPSPascalCompiler);
procedure SIRegister_TPageScroller(CL: TPSPascalCompiler);
procedure SIRegister_TDateTimePicker(CL: TPSPascalCompiler);
procedure SIRegister_TMonthCalendar(CL: TPSPascalCompiler);
procedure SIRegister_TCommonCalendar(CL: TPSPascalCompiler);
procedure SIRegister_TMonthCalColors(CL: TPSPascalCompiler);
procedure SIRegister_TCoolBar(CL: TPSPascalCompiler);
procedure SIRegister_TCoolBands(CL: TPSPascalCompiler);
procedure SIRegister_TCoolBand(CL: TPSPascalCompiler);
procedure SIRegister_TToolBarDockObject(CL: TPSPascalCompiler);
procedure SIRegister_TToolBar(CL: TPSPascalCompiler);
procedure SIRegister_TToolBarEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_TToolButton(CL: TPSPascalCompiler);
procedure SIRegister_TToolButtonActionLink(CL: TPSPascalCompiler);
procedure SIRegister_TAnimate(CL: TPSPascalCompiler);
procedure SIRegister_TListViewActionLink(CL: TPSPascalCompiler);
//procedure SIRegister_TListView(CL: TPSPascalCompiler);   removed
//procedure SIRegister_TCustomListView(CL: TPSPascalCompiler);
procedure SIRegister_TIconOptions(CL: TPSPascalCompiler);
procedure SIRegister_TWorkAreas(CL: TPSPascalCompiler);
procedure SIRegister_TWorkArea(CL: TPSPascalCompiler);

procedure SIRegister_TListItem(CL: TPSPascalCompiler);
procedure SIRegister_TListItems(CL: TPSPascalCompiler);
procedure SIRegister_TListItemsEnumerator(CL: TPSPascalCompiler);
//procedure SIRegister_TListItem(CL: TPSPascalCompiler);
procedure SIRegister_TListColumn(CL: TPSPascalCompiler);
procedure SIRegister_TListColumns(CL: TPSPascalCompiler);
procedure SIRegister_TListView(CL: TPSPascalCompiler);
procedure SIRegister_TCustomListView(CL: TPSPascalCompiler);
procedure SIRegister_THotKey(CL: TPSPascalCompiler);
procedure SIRegister_TCustomHotKey(CL: TPSPascalCompiler);
procedure SIRegister_TUpDown(CL: TPSPascalCompiler);
procedure SIRegister_TCustomUpDown(CL: TPSPascalCompiler);
procedure SIRegister_TRichEdit(CL: TPSPascalCompiler);
procedure SIRegister_TCustomRichEdit(CL: TPSPascalCompiler);
procedure SIRegister_TConversion(CL: TPSPascalCompiler);
procedure SIRegister_TParaAttributes(CL: TPSPascalCompiler);
procedure SIRegister_TTextAttributes(CL: TPSPascalCompiler);
procedure SIRegister_TProgressBar(CL: TPSPascalCompiler);
procedure SIRegister_TTrackBar(CL: TPSPascalCompiler);
//procedure SIRegister_TTreeView(CL: TPSPascalCompiler);
procedure SIRegister_TCustomTreeView(CL: TPSPascalCompiler);
procedure SIRegister_TTreeNodes(CL: TPSPascalCompiler);
procedure SIRegister_TTreeNodesEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_TTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_TTreeView(CL: TPSPascalCompiler);
procedure SIRegister_TBytesStream(CL: TPSPascalCompiler);


procedure SIRegister_THeaderControl(CL: TPSPascalCompiler);
procedure SIRegister_TCustomHeaderControl(CL: TPSPascalCompiler);
procedure SIRegister_THeaderSections(CL: TPSPascalCompiler);
procedure SIRegister_THeaderSection(CL: TPSPascalCompiler);
procedure SIRegister_TStatusBar(CL: TPSPascalCompiler);
procedure SIRegister_TCustomStatusBar(CL: TPSPascalCompiler);
procedure SIRegister_TStatusPanels(CL: TPSPascalCompiler);
procedure SIRegister_TStatusPanel(CL: TPSPascalCompiler);
procedure SIRegister_TPageControl(CL: TPSPascalCompiler);
procedure SIRegister_TTabSheet(CL: TPSPascalCompiler);
procedure SIRegister_TTabControl(CL: TPSPascalCompiler);
procedure SIRegister_TCustomTabControl(CL: TPSPascalCompiler);
procedure SIRegister_ComCtrls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ComCtrls_Routines(S: TPSExec);
procedure RIRegister_TBytesStream(CL: TPSRuntimeClassImporter);

procedure RIRegister_TComboBoxExActionLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComboBoxEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomComboBoxEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComboBoxExStrings(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComboExItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComboExItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPageScroller(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDateTimePicker(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMonthCalendar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCommonCalendar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMonthCalColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCoolBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCoolBands(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCoolBand(CL: TPSRuntimeClassImporter);
procedure RIRegister_TToolBarDockObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TToolBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TToolBarEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TToolButton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TToolButtonActionLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAnimate(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListViewActionLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomListView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIconOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWorkAreas(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWorkArea(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListItemsEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListColumns(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListColumn(CL: TPSRuntimeClassImporter);
procedure RIRegister_THotKey(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomHotKey(CL: TPSRuntimeClassImporter);
procedure RIRegister_TUpDown(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomUpDown(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRichEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomRichEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TConversion(CL: TPSRuntimeClassImporter);
procedure RIRegister_TParaAttributes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTextAttributes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TProgressBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTrackBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTreeView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomTreeView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTreeNodes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTreeNodesEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_THeaderControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomHeaderControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_THeaderSections(CL: TPSRuntimeClassImporter);
procedure RIRegister_THeaderSection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStatusBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomStatusBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStatusPanels(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStatusPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPageControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTabSheet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTabControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomTabControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_ComCtrls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // WinUtils
  Messages
  ,Windows
  ,CommCtrl
  ,Controls
  ,Forms
  ,Menus
  ,Graphics
  ,StdCtrls
  //,RichEdit
  ,ToolWin
  ,ImgList
  ,ExtCtrls
  ,ListActns
  //,ShlObj
  ,GraphUtil
  ,ComCtrls
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ComCtrls]);
end;

{ TBytesStream }

const
  MemoryDelta = $2000; { Must be a power of 2 }


constructor TBytesStream.Create(const ABytes: TBytes);
begin
  inherited Create;
  FBytes := ABytes;
  SetPointer(Pointer(FBytes), Length(FBytes));
  FCapacity := FSize;
end;

function TBytesStream.Realloc(var NewCapacity: Integer): Pointer;
begin
  if (NewCapacity > 0) and (NewCapacity <> FSize) then
    NewCapacity := (NewCapacity + (MemoryDelta - 1)) and not (MemoryDelta - 1);
  Result := Pointer(FBytes);
  if NewCapacity <> FCapacity then
  begin
    SetLength(FBytes, NewCapacity);
    Result := Pointer(FBytes);
    if NewCapacity = 0 then
      Exit;
    if Result = nil then raise EStreamError.Create('@SMemoryStreamError');
  end;
end;




(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TComboBoxExActionLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TListActionLink', 'TComboBoxExActionLink') do
  with CL.AddClassN(CL.FindClass('TListActionLink'),'TComboBoxExActionLink') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComboBoxEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomComboBoxEx', 'TComboBoxEx') do
  with CL.AddClassN(CL.FindClass('TCustomComboBoxEx'),'TComboBoxEx') do begin
    RegisterPublishedProperties;
   RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
        RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
    end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomComboBoxEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomCombo', 'TCustomComboBoxEx') do
  with CL.AddClassN(CL.FindClass('TCustomCombo'),'TCustomComboBoxEx') do begin
    RegisterMethod('procedure Assign(Source: TPersistent)');
      RegisterMethod('Constructor Create(AOwner: TComponent);');
     RegisterMethod('Procedure Free');
     RegisterMethod('function Focused');
    RegisterProperty('AutoCompleteOptions', 'TAutoCompleteOptions', iptrw);
    RegisterProperty('DropDownCount', 'Integer', iptrw);
    RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('ItemsEx', 'TComboExItems', iptrw);
    RegisterProperty('SelText', 'string', iptrw);
    RegisterProperty('Style', 'TComboBoxExStyle', iptrw);
    RegisterProperty('StyleEx', 'TComboBoxExStyles', iptrw);
    RegisterProperty('OnBeginEdit', 'TNotifyEvent', iptrw);
    RegisterProperty('OnEndEdit', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComboBoxExStrings(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomComboBoxStrings', 'TComboBoxExStrings') do
  with CL.AddClassN(CL.FindClass('TCustomComboBoxStrings'),'TComboBoxExStrings') do begin
    RegisterMethod('Constructor Create( Owner : TCustomComboBoxEx)');
       RegisterMethod('Procedure Free');
       RegisterMethod('function Add(const S: String): Integer;');
       RegisterMethod('Function AddItem( const Caption : String; const ImageIndex, SelectedImageIndex, OverlayImageIndex, Indent : Integer; Data : Pointer) : TComboExItem');
    RegisterProperty('SortType', 'TListItemsSortType', iptrw);
    RegisterProperty('ItemsEx', 'TComboExItems', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComboExItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TListControlItems', 'TComboExItems') do
  with CL.AddClassN(CL.FindClass('TListControlItems'),'TComboExItems') do begin
    RegisterMethod('Function Add : TComboExItem');
    RegisterMethod('Function AddItem( const Caption : String; const ImageIndex, SelectedImageIndex, OverlayImageIndex, Indent : Integer; Data : Pointer) : TComboExItem');
    RegisterMethod('Function Insert( Index : Integer) : TComboExItem');
    RegisterProperty('ComboItems', 'TComboExItem Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComboExItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TListControlItem', 'TComboExItem') do
  with CL.AddClassN(CL.FindClass('TListControlItem'),'TComboExItem') do begin
   RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterProperty('Indent', 'Integer', iptrw);
    RegisterProperty('OverlayImageIndex', 'TImageIndex', iptrw);
    RegisterProperty('SelectedImageIndex', 'TImageIndex', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPageScroller(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TPageScroller') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TPageScroller') do begin
      RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Function GetButtonState( Button : TPageScrollerButton) : TPageScrollerButtonState');
    RegisterProperty('AutoScroll', 'Boolean', iptrw);
    RegisterProperty('ButtonSize', 'Integer', iptrw);
    RegisterProperty('Control', 'TWinControl', iptrw);
    RegisterProperty('DragScroll', 'Boolean', iptrw);
    RegisterProperty('Margin', 'Integer', iptrw);
    RegisterProperty('Orientation', 'TPageScrollerOrientation', iptrw);
    RegisterProperty('Position', 'Integer', iptrw);
    RegisterProperty('OnScroll', 'TPageScrollEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDateTimePicker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCommonCalendar', 'TDateTimePicker') do
  with CL.AddClassN(CL.FindClass('TCommonCalendar'),'TDateTimePicker') do begin

  RegisterMethod('Constructor Create(AOwner: TComponent);');
   RegisterPublishedProperties;
     RegisterProperty('DateTime', 'TDateTime', iptrw);
   //  property Date;
    RegisterProperty('Date', 'TDate', iptrw);
    RegisterProperty('DroppedDown', 'Boolean', iptr);
    RegisterProperty('CalAlignment', 'TDTCalAlignment', iptrw);
    RegisterProperty('Format', 'String', iptrw);
    RegisterProperty('Time', 'TTime', iptrw);
    RegisterProperty('ShowCheckbox', 'Boolean', iptrw);
    RegisterProperty('Checked', 'Boolean', iptrw);
    RegisterProperty('DateFormat', 'TDTDateFormat', iptrw);
    RegisterProperty('DateMode', 'TDTDateMode', iptrw);
    RegisterProperty('Kind', 'TDateTimeKind', iptrw);
    RegisterProperty('ParseInput', 'Boolean', iptrw);
    RegisterProperty('OnCloseUp', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDropDown', 'TNotifyEvent', iptrw);
    RegisterProperty('OnUserInput', 'TDTParseInputEvent', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     RegisterProperty('ParentColor', 'TColor', iptrw);
    RegisterProperty('BevelWidth','TBevelWidth',iptrw);

    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
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
     RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMonthCalendar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCommonCalendar', 'TMonthCalendar') do
  with CL.AddClassN(CL.FindClass('TCommonCalendar'),'TMonthCalendar') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterPublishedProperties;
      RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
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
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCommonCalendar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCommonCalendar') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCommonCalendar') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
   RegisterMethod('Procedure Free');
   RegisterPublishedProperties;
       RegisterProperty('Date', 'TDate', iptrw);
    RegisterMethod('Procedure BoldDays(Days : array of LongWord; var MonthBoldInfo : LongWord)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMonthCalColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TMonthCalColors') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TMonthCalColors') do begin
     RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterMethod('Constructor Create( AOwner : TCommonCalendar)');
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('TextColor', 'TColor', iptrw);
    RegisterProperty('TitleBackColor', 'TColor', iptrw);
    RegisterProperty('TitleTextColor', 'TColor', iptrw);
    RegisterProperty('MonthBackColor', 'TColor', iptrw);
    RegisterProperty('TrailingTextColor', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCoolBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TToolWindow', 'TCoolBar') do
  //   CL.AddClassN(CL.FindClass('TWinControl'),'TToolWindow');

  with CL.AddClassN(CL.FindClass('TToolWindow'),'TCoolBar') do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create(AOwner: TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('FlipChildren(AllLevels: Boolean)');
    RegisterProperty('BandBorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('BandMaximize', 'TCoolBandMaximize', iptrw);
    RegisterProperty('Bands', 'TCoolBands', iptrw);
    RegisterProperty('FixedSize', 'Boolean', iptrw);
    RegisterProperty('FixedOrder', 'Boolean', iptrw);
    RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('Bitmap', 'TBitmap', iptrw);
    RegisterProperty('ShowText', 'Boolean', iptrw);
    RegisterProperty('Vertical', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
      RegisterPublishedProperties;
   RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
   RegisterProperty('ALIGN', 'TALIGN', iptrw);
     RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
    RegisterProperty('OnGetSiteInfo', 'TGetSiteInfoEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCoolBands(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TCoolBands') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TCoolBands') do begin
    RegisterMethod('Constructor Create( CoolBar : TCoolBar)');
    RegisterMethod('Function Add : TCoolBand');
    RegisterMethod('Function FindBand( AControl : TControl) : TCoolBand');
    RegisterProperty('CoolBar', 'TCoolBar', iptr);
    RegisterProperty('Items', 'TCoolBand Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCoolBand(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TCoolBand') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TCoolBand') do begin
    RegisterMethod('Constructor Create(Collection: TCollection)');
     RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterProperty('Height', 'Integer', iptr);
    RegisterProperty('Bitmap', 'TBitmap', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('Break', 'Boolean', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('Control', 'TWinControl', iptrw);
    RegisterProperty('FixedBackground', 'Boolean', iptrw);
    RegisterProperty('FixedSize', 'Boolean', iptrw);
    RegisterProperty('HorizontalOnly', 'Boolean', iptrw);
    RegisterProperty('ImageIndex', 'TImageIndex', iptrw);
    RegisterProperty('MinHeight', 'Integer', iptrw);
    RegisterProperty('MinWidth', 'Integer', iptrw);
    RegisterProperty('ParentColor', 'Boolean', iptrw);
    RegisterProperty('ParentBitmap', 'Boolean', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TToolBarDockObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDragDockObject', 'TToolBarDockObject') do
  with CL.AddClassN(CL.FindClass('TDragDockObject'),'TToolBarDockObject') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TToolBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TToolWindow', 'TToolBar') do
  with CL.AddClassN(CL.FindClass('TToolWindow'),'TToolBar') do begin
  RegisterPublishedProperties;
    RegisterMethod('Constructor Create(AOwner: TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('FlipChildren(AllLevels: Boolean)');
      RegisterMethod('Function GetEnumerator : TToolBarEnumerator');
    RegisterMethod('Function TrackMenu( Button : TToolButton) : Boolean');
    RegisterProperty('ButtonCount', 'Integer', iptr);
    RegisterProperty('Buttons', 'TToolButton Integer', iptr);
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('CustomizeKeyName', 'string', iptrw);
    RegisterProperty('CustomizeValueName', 'string', iptrw);
    RegisterProperty('RowCount', 'Integer', iptr);
    RegisterProperty('ButtonHeight', 'Integer', iptrw);
    RegisterProperty('ButtonWidth', 'Integer', iptrw);
    RegisterProperty('Customizable', 'Boolean', iptrw);
    RegisterProperty('DisabledImages', 'TCustomImageList', iptrw);
    RegisterProperty('DrawingStyle', 'TTBDrawingStyle', iptrw);
    RegisterProperty('Flat', 'Boolean', iptrw);
    RegisterProperty('GradientEndColor', 'TColor', iptrw);
    RegisterProperty('GradientStartColor', 'TColor', iptrw);
    RegisterProperty('HideClippedButtons', 'Boolean', iptrw);
    RegisterProperty('HotImages', 'TCustomImageList', iptrw);
    RegisterProperty('HotTrackColor', 'TColor', iptrw);
    RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('Indent', 'Integer', iptrw);
    RegisterProperty('List', 'Boolean', iptrw);
    RegisterProperty('Menu', 'TMainMenu', iptrw);
    RegisterProperty('GradientDirection', 'TGradientDirection', iptrw);
    RegisterProperty('GradientDrawingOptions', 'TTBGradientDrawingOptions', iptrw);
    RegisterProperty('ShowCaptions', 'Boolean', iptrw);
    RegisterProperty('AllowTextButtons', 'Boolean', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterProperty('Wrapable', 'Boolean', iptrw);
    RegisterProperty('OnAdvancedCustomDraw', 'TTBAdvancedCustomDrawEvent', iptrw);
    RegisterProperty('OnAdvancedCustomDrawButton', 'TTBAdvancedCustomDrawBtnEvent', iptrw);
    RegisterProperty('OnCustomDraw', 'TTBCustomDrawEvent', iptrw);
    RegisterProperty('OnCustomDrawButton', 'TTBCustomDrawBtnEvent', iptrw);
    RegisterProperty('OnCustomizeAdded', 'TTBButtonEvent', iptrw);
    RegisterProperty('OnCustomizeCanInsert', 'TTBCustomizeQueryEvent', iptrw);
    RegisterProperty('OnCustomizeCanDelete', 'TTBCustomizeQueryEvent', iptrw);
    RegisterProperty('OnCustomized', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCustomizeDelete', 'TTBButtonEvent', iptrw);
    RegisterProperty('OnCustomizing', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCustomizeNewButton', 'TTBNewButtonEvent', iptrw);
    RegisterProperty('OnCustomizeReset', 'TNotifyEvent', iptrw);
    RegisterProperty('ALIGN', 'TALIGN', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
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
    RegisterProperty('OnGetSiteInfo', 'TGetSiteInfoEvent', iptrw);
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TToolBarEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TToolBarEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TToolBarEnumerator') do begin
    RegisterMethod('Constructor Create( AToolBar : TToolBar)');
    RegisterMethod('Function GetCurrent : TToolButton');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TToolButton', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TToolButton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TToolButton') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TToolButton') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);');
   RegisterPublishedProperties;
    RegisterMethod('Function CheckMenuDropdown : Boolean');
    RegisterProperty('Index', 'Integer', iptr);
    RegisterProperty('AllowAllUp', 'Boolean', iptrw);
    RegisterProperty('AutoSize', 'Boolean', iptrw);
    RegisterProperty('Down', 'Boolean', iptrw);
    RegisterProperty('DropdownMenu', 'TPopupMenu', iptrw);
    RegisterProperty('EnableDropdown', 'Boolean', iptrw);
    RegisterProperty('Grouped', 'Boolean', iptrw);
    RegisterProperty('ImageIndex', 'TImageIndex', iptrw);
    RegisterProperty('Indeterminate', 'Boolean', iptrw);
    RegisterProperty('Marked', 'Boolean', iptrw);
    RegisterProperty('MenuItem', 'TMenuItem', iptrw);
    RegisterProperty('Wrap', 'Boolean', iptrw);
    RegisterProperty('Style', 'TToolButtonStyle', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TToolButtonActionLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TControlActionLink', 'TToolButtonActionLink') do
  with CL.AddClassN(CL.FindClass('TControlActionLink'),'TToolButtonActionLink') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAnimate(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TAnimate') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TAnimate') do begin
    RegisterProperty('FrameCount', 'Integer', iptr);
    RegisterProperty('FrameHeight', 'Integer', iptr);
    RegisterProperty('FrameWidth', 'Integer', iptr);
    RegisterProperty('Open', 'Boolean', iptrw);
      RegisterMethod('Constructor Create(AOwner: TComponent);');
     RegisterMethod('Procedure Play( FromFrame, ToFrame : Word; Count : Integer)');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Procedure Seek( Frame : Smallint)');
    RegisterMethod('Procedure Stop');
    RegisterProperty('ResHandle', 'THandle', iptrw);
    RegisterProperty('ResId', 'Integer', iptrw);
    RegisterProperty('ResName', 'string', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Center', 'Boolean', iptrw);
    RegisterProperty('CommonAVI', 'TCommonAVI', iptrw);
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('Repetitions', 'Integer', iptrw);
    RegisterProperty('StartFrame', 'Smallint', iptrw);
    RegisterProperty('StopFrame', 'Smallint', iptrw);
    RegisterProperty('Timers', 'Boolean', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterProperty('OnOpen', 'TNotifyEvent', iptrw);
    RegisterProperty('OnClose', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStart', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStop', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListViewActionLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TListActionLink', 'TListViewActionLink') do
  with CL.AddClassN(CL.FindClass('TListActionLink'),'TListViewActionLink') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomListView', 'TListView') do
  with CL.AddClassN(CL.FindClass('TCustomListView'),'TListView') do begin
  RegisterPublishedProperties;
 // RegisterMethod('Constructor Create(AOwner: TComponent)');
  //RegisterMethod('Procedure Free)');
  //RegisterMethod('Procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer)');

  RegisterProperty('ViewStyle', 'TViewStyle', iptrw);
       //property ViewStyle;
  RegisterProperty('Parent', 'TWinControl', iptrw);
  RegisterProperty('HoverTime', 'Integer', iptrw);
  RegisterProperty('LargeImages', 'TCustomImageList', iptrw);
  RegisterProperty('Items', 'TListItems', iptrw);
  RegisterProperty('Visible', 'boolean', iptrw);
  RegisterProperty('ReadOnly', 'boolean', iptrw);
  RegisterProperty('GridLines', 'boolean', iptrw);
  RegisterProperty('Color', 'TColor', iptrw);
  RegisterProperty('Checkboxes', 'boolean', iptrw);
  RegisterProperty('Columns', 'TListColumns', iptrw);
  RegisterProperty('ColumnClick', 'boolean', iptrw);
  RegisterProperty('OnDblClick', 'TNotifyEvent', iptrw);
  RegisterProperty('OnEnter', 'TNotifyEvent', iptrw);
  RegisterProperty('OnExit', 'TNotifyEvent', iptrw);
  RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
  RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
  RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
  RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
  RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
  RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
   RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
   RegisterProperty('ONCHANGE', 'TLVChangeEvent', iptrw);
    RegisterProperty('MultiSelect', 'boolean', iptrw);
   RegisterProperty('OnSelectItem', 'TLVSelectItemEvent', iptrw);
   RegisterProperty('OnColumnClick', 'TLVColumnClickEvent', iptrw);
   RegisterProperty('OnColumnRightClick', 'TLVColumnRClickEvent', iptrw);
   RegisterProperty('OnCompare', 'TLVCompareEvent', iptrw);
 RegisterProperty('OnData', 'TLVOwnerDataEvent', iptrw);
   RegisterProperty('OnDataFind', 'TLVOwnerDataEvent', iptrw);
 RegisterProperty('OnDataStateChange', 'TLVOwnerDataStateChangeEvent', iptrw);
 RegisterProperty('OnDrawItem', 'TLVDrawItemEvent', iptrw);

  {   property OnData: TLVOwnerDataEvent read FOnData write FOnData;
    property OnDataFind: TLVOwnerDataFindEvent read FOnDataFind write FOnDataFind;
    property OnDataHint: TLVOwnerDataHintEvent read FOnDataHint write FOnDataHint;
    property OnDataStateChange: TLVOwnerDataStateChangeEvent read FOnDataStateChange write FOnDataStateChange;
    property OnDeletion: TLVDeletedEvent read FOnDeletion write FOnDeletion;
    property OnDrawItem: TLVDrawItemEvent read FOnDrawItem write FOnDrawItem;
  }
   //   property OnCompare: TLVCompareEvent read FOnCompare write FOnCompare;
     //property OnSelectItem: TLVSelectItemEvent read FOnSelectItem write FOnSelectItem;

  RegisterProperty('Enabled', 'boolean', iptrw);
  RegisterProperty('FlatScrollBars', 'boolean', iptrw);
  RegisterProperty('SmallImages', 'TCustomImageList', iptrw);
  RegisterProperty('StateImages', 'TCustomImageList', iptrw);
  RegisterProperty('ShowHint', 'boolean', iptrw);
  RegisterProperty('Font', 'TFont', iptrw);
  RegisterProperty('ItemIndex', 'integer', iptrw);
  RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
  RegisterProperty('BORDERWidth', 'integer', iptrw);
  RegisterProperty('SortType', 'TSortType', iptrw);
  RegisterProperty('IconOptions', 'TIconOptions', iptrw);
      RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
  // property IconOptions: TIconOptions read FIconOptions write SetIconOptions;
  //property Items: TListItems read FListItems write SetItems stored AreItemsStored;
   //property Columns: TListColumns read FListColumns write SetListColumns;
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomListView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMultiSelectListControl', 'TCustomListView') do
  with CL.AddClassN(CL.FindClass('TCustomMultiSelectListControl'),'TCustomListView') do begin
    RegisterPublishedProperties;
     RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterMethod('Procedure Free)');
    RegisterMethod('Procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer)');
     RegisterMethod('procedure AddItem(Item: String; AObject: TObject)');
    RegisterMethod('Procedure Clear)');
    RegisterMethod('ClearSelection;)');
    RegisterMethod('procedure CopySelection(Destination: TCustomListControl)');
    RegisterMethod('procedure DeleteSelected;');
    RegisterMethod('Function AlphaSort : Boolean');
    RegisterMethod('Procedure Arrange( Code : TListArrangement)');
    //RegisterMethod('procedure AddItem(Item: String; AObject: TObject)');
    RegisterMethod('Function FindCaption( StartIndex : Integer; Value : string; Partial, Inclusive, Wrap : Boolean) : TListItem');
    RegisterMethod('Function FindData( StartIndex : Integer; Value : Pointer; Inclusive, Wrap : Boolean) : TListItem');
    RegisterMethod('Function GetHitTestInfoAt( X, Y : Integer) : THitTests');
    RegisterMethod('Function GetItemAt( X, Y : Integer) : TListItem');
    RegisterMethod('Function GetNearestItem( Point : TPoint; Direction : TSearchDirection) : TListItem');
    RegisterMethod('Function GetNextItem( StartItem : TListItem; Direction : TSearchDirection; States : TItemStates) : TListItem');
    RegisterMethod('Function GetSearchString : string');
    RegisterMethod('Function IsEditing : Boolean');
    RegisterMethod('Function StringWidth(S: string): Integer');
    RegisterMethod('Procedure Scroll( DX, DY : Integer)');
    RegisterMethod('Procedure AddItem( Item : String; AObject : TObject)');
    RegisterMethod('Procedure CopySelection( Destination : TCustomListControl)');
    RegisterMethod('Procedure DeleteSelected');
    RegisterMethod('Procedure SelectAll');
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
    RegisterProperty('Checkboxes', 'Boolean', iptrw);
    RegisterProperty('Column', 'TListColumn Integer', iptr);
    RegisterProperty('DropTarget', 'TListItem', iptrw);
    RegisterProperty('FlatScrollBars', 'Boolean', iptrw);
    RegisterProperty('FullDrag', 'Boolean', iptrw);
    RegisterProperty('GridLines', 'Boolean', iptrw);
    RegisterProperty('HotTrack', 'Boolean', iptrw);
    RegisterProperty('HotTrackStyles', 'TListHotTrackStyles', iptrw);
    RegisterProperty('ItemFocused', 'TListItem', iptrw);
    RegisterProperty('RowSelect', 'Boolean', iptrw);
    RegisterProperty('SelCount', 'Integer', iptr);
    RegisterProperty('Selected', 'TListItem', iptrw);
    RegisterMethod('Function CustomSort( SortProc : TLVCompare; lParam : Longint) : Boolean');
    RegisterMethod('Function StringWidth( S : string) : Integer');
    RegisterMethod('Procedure UpdateItems( FirstIndex, LastIndex : Integer)');
    RegisterProperty('TopItem', 'TListItem', iptr);
    RegisterProperty('ViewOrigin', 'TPoint', iptr);
    RegisterProperty('VisibleRowCount', 'Integer', iptr);
    RegisterProperty('BoundingRect', 'TRect', iptr);
    RegisterProperty('WorkAreas', 'TWorkAreas', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIconOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIconOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIconOptions') do begin
    RegisterMethod('Constructor Create( AOwner : TCustomListView)');
    RegisterProperty('Arrangement', 'TIconArrangement', iptrw);
    RegisterProperty('AutoArrange', 'Boolean', iptrw);
    RegisterProperty('WrapText', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWorkAreas(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TWorkAreas') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TWorkAreas') do begin
    RegisterMethod('Function Add : TWorkArea');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Function Insert( Index : Integer) : TWorkArea');
    RegisterProperty('Items', 'TWorkArea Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWorkArea(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TWorkArea') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TWorkArea') do begin
    RegisterProperty('Rect', 'TRect', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TListItems') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TListItems') do begin
     RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterMethod('Constructor Create( AOwner : TCustomListView)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Function Add : TListItem');
    RegisterMethod('Function AddItem( Item : TListItem; Index : Integer) : TListItem');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Function GetEnumerator : TListItemsEnumerator');
    RegisterMethod('Function IndexOf( Value : TListItem) : Integer');
    RegisterMethod('Function Insert( Index : Integer) : TListItem');
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Handle', 'HWND', iptr);
    RegisterProperty('Item', 'TListItem Integer', iptrw);
    SetDefaultPropery('Item');
    RegisterProperty('Owner', 'TCustomListView', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListItemsEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TListItemsEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TListItemsEnumerator') do begin
    RegisterMethod('Constructor Create( AListItems : TListItems)');
    RegisterMethod('Function GetCurrent : TListItem');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TListItem', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TListItem') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TListItem') do begin
     RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterMethod('Constructor Create( AOwner : TListItems)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure CancelEdit');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Function DisplayRect( Code : TDisplayCode) : TRect');
    RegisterMethod('Function EditCaption : Boolean');
    RegisterMethod('Function GetPosition : TPoint');
    RegisterMethod('Procedure MakeVisible( PartialOK : Boolean)');
    RegisterMethod('Procedure Update');
    RegisterMethod('Procedure SetPosition( const Value : TPoint)');
    RegisterMethod('Function WorkArea : Integer');
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('Checked', 'Boolean', iptrw);
    RegisterProperty('Cut', 'Boolean', iptrw);
    RegisterProperty('Data', 'Pointer', iptrw);
    RegisterProperty('Deleting', 'Boolean', iptr);
    RegisterProperty('DropTarget', 'Boolean', iptrw);
    RegisterProperty('Focused', 'Boolean', iptrw);
    RegisterProperty('Handle', 'HWND', iptr);
    RegisterProperty('ImageIndex', 'TImageIndex', iptrw);
    RegisterProperty('Indent', 'Integer', iptrw);
    RegisterProperty('Index', 'Integer', iptr);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('ListView', 'TCustomListView', iptr);
    RegisterProperty('Owner', 'TListItems', iptr);
    RegisterProperty('OverlayIndex', 'TImageIndex', iptrw);
    RegisterProperty('Position', 'TPoint', iptrw);
    RegisterProperty('Selected', 'Boolean', iptrw);
    RegisterProperty('StateIndex', 'TImageIndex', iptrw);
    RegisterProperty('SubItems', 'TStrings', iptrw);
    RegisterProperty('SubItemImages', 'Integer Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListColumns(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TListColumns') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TListColumns') do begin
    RegisterMethod('Constructor Create( AOwner : TCustomListView)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Function Add : TListColumn');
    RegisterMethod('Function Owner : TCustomListView');
    RegisterProperty('Items', 'TListColumn Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListColumn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TListColumn') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TListColumn') do begin
    RegisterMethod('Constructor Create(Collection: TCollection)');
    RegisterMethod('procedure Assign(Source: TPersistent)');
   RegisterMethod('Procedure Free');
      RegisterProperty('WidthType', 'TWidth', iptr);
    RegisterProperty('Alignment', 'TAlignment', iptrw);
    RegisterProperty('AutoSize', 'Boolean', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('ImageIndex', 'TImageIndex', iptrw);
    RegisterProperty('MaxWidth', 'TWidth', iptrw);
    RegisterProperty('MinWidth', 'TWidth', iptrw);
    RegisterProperty('Tag', 'Integer', iptrw);
    RegisterProperty('Width', 'TWidth', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THotKey(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomHotKey', 'THotKey') do
  with CL.AddClassN(CL.FindClass('TCustomHotKey'),'THotKey') do begin
   RegisterPublishedProperties;
      RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGN', 'TALIGN', iptrw);
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomHotKey(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCustomHotKey') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCustomHotKey') do begin
   RegisterMethod('Constructor Create(AOwner: TComponent);');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TUpDown(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomUpDown', 'TUpDown') do
  with CL.AddClassN(CL.FindClass('TCustomUpDown'),'TUpDown') do begin
   RegisterPublishedProperties;
      RegisterProperty('ONCLICK', 'TUDClickEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGN', 'TALIGN', iptrw);
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
      RegisterProperty('Position', 'Integer', iptrw);
      RegisterProperty('AlignButton', 'TUDAlignButton', iptrw);
    RegisterProperty('ArrowKeys', 'Boolean', iptrw);
    RegisterProperty('Associate', 'TWinControl', iptrw);
    RegisterProperty('Min', 'SmallInt', iptrw);
    RegisterProperty('Max', 'SmallInt', iptrw);
    RegisterProperty('Increment', 'Integer', iptrw);
    RegisterProperty('Orientation', 'TUDOrientation', iptrw);
    RegisterProperty('Position', 'SmallInt', iptrw);
    RegisterProperty('Thousands', 'Boolean', iptrw);
    RegisterProperty('Wrap', 'Boolean', iptrw);
    RegisterProperty('OnChanging', 'TUDChangingEvent', iptrw);
    RegisterProperty('OnChangingEx', 'TUDChangingEventEx', iptrw);
    //RegisterProperty('OnClick', 'TUDClickEvent', iptrw);
    
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomUpDown(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCustomUpDown') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCustomUpDown') do begin
   RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Function DoCanChange( NewVal : SmallInt; Delta : SmallInt) : Boolean');
    RegisterMethod('Function CanChange : Boolean');
    RegisterMethod('Procedure Notification( AComponent : TComponent; Operation : TOperation)');
    RegisterMethod('Procedure Click( Button : TUDBtnType)');
    RegisterProperty('AlignButton', 'TUDAlignButton', iptrw);
    RegisterProperty('ArrowKeys', 'Boolean', iptrw);
    RegisterProperty('Associate', 'TWinControl', iptrw);
    RegisterProperty('Min', 'SmallInt', iptrw);
    RegisterProperty('Max', 'SmallInt', iptrw);
    RegisterProperty('Increment', 'Integer', iptrw);
    RegisterProperty('Orientation', 'TUDOrientation', iptrw);
    RegisterProperty('Position', 'SmallInt', iptrw);
    RegisterProperty('Thousands', 'Boolean', iptrw);
    RegisterProperty('Wrap', 'Boolean', iptrw);
    RegisterProperty('OnChanging', 'TUDChangingEvent', iptrw);
    RegisterProperty('OnChangingEx', 'TUDChangingEventEx', iptrw);
    RegisterProperty('OnClick', 'TUDClickEvent', iptrw);
     end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRichEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomRichEdit', 'TRichEdit') do
  with CL.AddClassN(CL.FindClass('TCustomRichEdit'),'TRichEdit') do begin
    RegisterPublishedProperties;
    RegisterProperty('WANTRETURNS', 'Boolean', iptrw);
    RegisterProperty('WANTTABS', 'Boolean', iptrw);
    RegisterProperty('WORDWRAP', 'Boolean', iptrw);
    RegisterProperty('PlainText', 'Boolean', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
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
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
 end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomRichEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMemo', 'TCustomRichEdit') do
  with CL.AddClassN(CL.FindClass('TCustomMemo'),'TCustomRichEdit') do begin
  RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Clear');
   RegisterMethod('function GetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer;');
  RegisterPublishedProperties;
    RegisterMethod('Function FindText( const SearchStr : string; StartPos, Length : Integer; Options : TSearchTypes) : Integer');
    RegisterMethod('Procedure Print( const Caption : string)');
    RegisterMethod('Procedure RegisterConversionFormat( const AExtension : string; AConversionClass : TConversionClass)');
    RegisterProperty('DefaultConverter', 'TConversionClass', iptrw);
    RegisterProperty('DefAttributes', 'TTextAttributes', iptrw);
    RegisterProperty('SelAttributes', 'TTextAttributes', iptrw);
    RegisterProperty('PageRect', 'TRect', iptrw);
    RegisterProperty('Paragraph', 'TParaAttributes', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TConversion(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TConversion') do
  with CL.AddClassN(CL.FindClass('TObject'),'TConversion') do begin
    RegisterMethod('Function ConvertReadStream( Stream : TStream; Buffer : PChar; BufSize : Integer) : Integer');
    RegisterMethod('Function ConvertWriteStream( Stream : TStream; Buffer : PChar; BufSize : Integer) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TParaAttributes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TParaAttributes') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TParaAttributes') do begin
     RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterMethod('Constructor Create( AOwner : TCustomRichEdit)');
    RegisterProperty('Alignment', 'TAlignment', iptrw);
    RegisterProperty('FirstIndent', 'Longint', iptrw);
    RegisterProperty('LeftIndent', 'Longint', iptrw);
    RegisterProperty('Numbering', 'TNumberingStyle', iptrw);
    RegisterProperty('RightIndent', 'Longint', iptrw);
    RegisterProperty('Tab', 'Longint Byte', iptrw);
    RegisterProperty('TabCount', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTextAttributes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTextAttributes') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTextAttributes') do begin
     RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterMethod('Constructor Create( AOwner : TCustomRichEdit; AttributeType : TAttributeType)');
    RegisterProperty('Charset', 'TFontCharset', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('ConsistentAttributes', 'TConsistentAttributes', iptr);
    RegisterProperty('Name', 'TFontName', iptrw);
    RegisterProperty('Pitch', 'TFontPitch', iptrw);
    RegisterProperty('Size', 'Integer', iptrw);
    RegisterProperty('Style', 'TFontStyles', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TProgressBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TProgressBar') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TProgressBar') do begin
   RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure StepIt');
    RegisterMethod('Procedure StepBy( Delta : Integer)');
    RegisterProperty('Min', 'Integer', iptrw);
    RegisterProperty('Max', 'Integer', iptrw);
    RegisterProperty('Orientation', 'TProgressBarOrientation', iptrw);
    RegisterProperty('Position', 'Integer', iptrw);
    RegisterProperty('Smooth', 'Boolean', iptrw);
    RegisterProperty('Step', 'Integer', iptrw);
      RegisterPublishedProperties;
   RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGN', 'TALIGN', iptrw);
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTrackBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TTrackBar') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TTrackBar') do begin
   RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterPublishedProperties;
    RegisterMethod('Procedure SetTick( Value : Integer)');
    RegisterProperty('LineSize', 'Integer', iptrw);
    RegisterProperty('Max', 'Integer', iptrw);
    RegisterProperty('Min', 'Integer', iptrw);
    RegisterProperty('Orientation', 'TTrackBarOrientation', iptrw);
    RegisterProperty('PageSize', 'Integer', iptrw);
    RegisterProperty('Frequency', 'Integer', iptrw);
    RegisterProperty('Position', 'Integer', iptrw);
    RegisterProperty('PositionToolTip', 'TPositionToolTip', iptrw);
    RegisterProperty('SliderVisible', 'Boolean', iptrw);
    RegisterProperty('SelEnd', 'Integer', iptrw);
    RegisterProperty('SelStart', 'Integer', iptrw);
    RegisterProperty('ShowSelRange', 'Boolean', iptrw);
    RegisterProperty('ThumbLength', 'Integer', iptrw);
    RegisterProperty('TickMarks', 'TTickMark', iptrw);
    RegisterProperty('TickStyle', 'TTickStyle', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterPublishedProperties;
     RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGN', 'TALIGN', iptrw);
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('ParentShowHint', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
     RegisterProperty('Step', 'Integer', iptrw);
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTreeView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTreeView', 'TTreeView') do
  with CL.AddClassN(CL.FindClass('TCustomTreeView'),'TTreeView') do begin
  //    RegisterMethod('Constructor Create(AOwner: TComponent);');
   //RegisterMethod('Procedure Free');
     RegisterPublishedProperties;
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('BORDERWIDTH', 'Integer', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
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
   // function GetItemIndex(Value: TListItem): Integer; reintroduce; overload;
   //   RegisterProperty('OnChange', 'TTVChangedEvent', iptr);

    //   TTVChangedEvent = procedure(Sender: TObject; Node: TTreeNode) of object;

    {property ShowLines;
    property ShowRoot;
    property SortType;}
   //   TSortType = (stNone, stData, stText, stBoth);
    //SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomTreeView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCustomTreeView') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCustomTreeView') do begin
     RegisterMethod('Constructor Create(AOwner: TComponent)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Function AlphaSort( ARecurse : Boolean) : Boolean');
    RegisterMethod('Function CustomSort( SortProc : TTVCompare; Data : Longint; ARecurse : Boolean) : Boolean');
    RegisterMethod('Procedure FullCollapse');
    RegisterMethod('Procedure FullExpand');
    RegisterMethod('Function GetHitTestInfoAt( X, Y : Integer) : THitTests');
    RegisterMethod('Function GetNodeAt( X, Y : Integer) : TTreeNode');
    RegisterMethod('Function IsEditing : Boolean');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('DropTarget', 'TTreeNode', iptrw);
    RegisterProperty('Selected', 'TTreeNode', iptrw);
    RegisterProperty('TopItem', 'TTreeNode', iptrw);
    RegisterMethod('Procedure Select( Node : TTreeNode; ShiftState : TShiftState);');
    RegisterMethod('Procedure Select1( const Nodes : array of TTreeNode);');
    RegisterMethod('Procedure Select2( Nodes : TList);');
    RegisterMethod('Procedure Deselect( Node : TTreeNode)');
    RegisterMethod('Procedure Subselect( Node : TTreeNode; Validate : Boolean)');
    RegisterProperty('SelectionCount', 'Cardinal', iptr);
    RegisterProperty('Selections', 'TTreeNode Integer', iptr);
    RegisterMethod('Procedure ClearSelection( KeepPrimary : Boolean)');
    RegisterMethod('Function GetSelections( AList : TList) : TTreeNode');
    RegisterMethod('Function FindNextToSelect : TTreeNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTreeNodes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTreeNodes') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTreeNodes') do begin
     RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterMethod('Constructor Create( AOwner : TCustomTreeView)');
     RegisterMethod('Procedure Free');
      RegisterMethod('Function AddChildFirst( Parent : TTreeNode; const S : string) : TTreeNode');
    RegisterMethod('Function AddChild( Parent : TTreeNode; const S : string) : TTreeNode');
    RegisterMethod('Function AddChildObjectFirst( Parent : TTreeNode; const S : string; Ptr : Pointer) : TTreeNode');
    RegisterMethod('Function AddChildObject( Parent : TTreeNode; const S : string; Ptr : Pointer) : TTreeNode');
    RegisterMethod('Function AddFirst( Sibling : TTreeNode; const S : string) : TTreeNode');
    RegisterMethod('Function Add( Sibling : TTreeNode; const S : string) : TTreeNode');
    RegisterMethod('Function AddObjectFirst( Sibling : TTreeNode; const S : string; Ptr : Pointer) : TTreeNode');
    RegisterMethod('Function AddObject( Sibling : TTreeNode; const S : string; Ptr : Pointer) : TTreeNode');
    RegisterMethod('Function AddNode( Node, Relative : TTreeNode; const S : string; Ptr : Pointer; Method : TNodeAttachMode) : TTreeNode');
    RegisterMethod('Function AlphaSort( ARecurse : Boolean) : Boolean');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function CustomSort( SortProc : TTVCompare; Data : Longint; ARecurse : Boolean) : Boolean');
    RegisterMethod('Procedure Delete( Node : TTreeNode)');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Function GetFirstNode : TTreeNode');
    RegisterMethod('Function GetEnumerator : TTreeNodesEnumerator');
    RegisterMethod('Function GetNode( ItemId : HTreeItem) : TTreeNode');
    RegisterMethod('Function Insert( Sibling : TTreeNode; const S : string) : TTreeNode');
    RegisterMethod('Function InsertObject( Sibling : TTreeNode; const S : string; Ptr : Pointer) : TTreeNode');
    RegisterMethod('Function InsertNode( Node, Sibling : TTreeNode; const S : string; Ptr : Pointer) : TTreeNode');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Handle', 'HWND', iptr);
    RegisterProperty('Item', 'TTreeNode Integer', iptr);
    SetDefaultPropery('Item');
    RegisterProperty('Owner', 'TCustomTreeView', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTreeNodesEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTreeNodesEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTreeNodesEnumerator') do begin
    RegisterMethod('Constructor Create( ATreeNodes : TTreeNodes)');
    RegisterMethod('Function GetCurrent : TTreeNode');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TTreeNode', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTreeNode') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTreeNode') do begin
     RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterMethod('Constructor Create( AOwner : TTreeNodes)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function AlphaSort( ARecurse : Boolean) : Boolean');
    RegisterMethod('Procedure Collapse( Recurse : Boolean)');
    RegisterMethod('Function CustomSort( SortProc : TTVCompare; Data : Longint; ARecurse : Boolean) : Boolean');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Procedure DeleteChildren');
    RegisterMethod('Function DisplayRect( TextOnly : Boolean) : TRect');
    RegisterMethod('Function EditText : Boolean');
    RegisterMethod('Procedure EndEdit( Cancel : Boolean)');
    RegisterMethod('Procedure Expand( Recurse : Boolean)');
    RegisterMethod('Function getFirstChild : TTreeNode');
    RegisterMethod('Function GetHandle : HWND');
    RegisterMethod('Function GetLastChild : TTreeNode');
    RegisterMethod('Function GetNext : TTreeNode');
    RegisterMethod('Function GetNextChild( Value : TTreeNode) : TTreeNode');
    RegisterMethod('Function getNextSibling : TTreeNode');
    RegisterMethod('Function GetNextVisible : TTreeNode');
    RegisterMethod('Function GetPrev : TTreeNode');
    RegisterMethod('Function GetPrevChild( Value : TTreeNode) : TTreeNode');
    RegisterMethod('Function getPrevSibling : TTreeNode');
    RegisterMethod('Function GetPrevVisible : TTreeNode');
    RegisterMethod('Function HasAsParent( Value : TTreeNode) : Boolean');
    RegisterMethod('Function IndexOf( Value : TTreeNode) : Integer');
    RegisterMethod('Procedure MakeVisible');
    RegisterMethod('Procedure MoveTo( Destination : TTreeNode; Mode : TNodeAttachMode)');
    RegisterProperty('AbsoluteIndex', 'Integer', iptr);
    RegisterMethod('Function IsFirstNode : Boolean');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Cut', 'Boolean', iptrw);
    RegisterProperty('Data', 'TObject', iptrw);     //instead of pointer
    RegisterProperty('Deleting', 'Boolean', iptr);
    RegisterProperty('Focused', 'Boolean', iptrw);
    RegisterProperty('DropTarget', 'Boolean', iptrw);
    RegisterProperty('Selected', 'Boolean', iptrw);
    RegisterProperty('Expanded', 'Boolean', iptrw);
    RegisterProperty('Handle', 'HWND', iptr);
    RegisterProperty('HasChildren', 'Boolean', iptrw);
    RegisterProperty('ImageIndex', 'TImageIndex', iptrw);
    RegisterProperty('Index', 'Integer', iptr);
    RegisterProperty('IsVisible', 'Boolean', iptr);
    RegisterProperty('Item', 'TTreeNode Integer', iptrw);
    SetDefaultPropery('Item');
    RegisterProperty('ItemId', 'HTreeItem', iptr);
    RegisterProperty('Level', 'Integer', iptr);
    RegisterProperty('OverlayIndex', 'Integer', iptrw);
    RegisterProperty('Owner', 'TTreeNodes', iptr);
    RegisterProperty('Parent', 'TTreeNode', iptr);
    RegisterProperty('SelectedIndex', 'Integer', iptrw);
    RegisterProperty('StateIndex', 'Integer', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('TreeView', 'TCustomTreeView', iptr);
    //RegisterProperty('OnChange', 'TTVChangedEvent', iptr);


    //  TTVChangedEvent = procedure(Sender: TObject; Node: TTreeNode) of object;

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THeaderControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomHeaderControl', 'THeaderControl') do
  with CL.AddClassN(CL.FindClass('TCustomHeaderControl'),'THeaderControl') do begin
    RegisterProperty('OnDrawSection', 'TDrawSectionEvent', iptrw);
    RegisterProperty('OnSectionClick', 'TSectionNotifyEvent', iptrw);
    RegisterProperty('OnSectionResize', 'TSectionNotifyEvent', iptrw);
    RegisterProperty('OnSectionTrack', 'TSectionTrackEvent', iptrw);
     RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomHeaderControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCustomHeaderControl') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCustomHeaderControl') do begin
   RegisterMethod('Constructor Create(AOwner: TComponent);');
   RegisterMethod('Procedure Free');
   RegisterMethod('procedure FlipChildren(AllLevels: Boolean);');
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('DragReorder', 'Boolean', iptrw);
    RegisterProperty('FullDrag', 'Boolean', iptrw);
    RegisterProperty('HotTrack', 'Boolean', iptrw);
    RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('Sections', 'THeaderSections', iptrw);
    RegisterProperty('Style', 'THeaderStyle', iptrw);
    RegisterProperty('OnCreateSectionClass', 'TCustomHCCreateSectionClassEvent', iptrw);
    RegisterProperty('OnDrawSection', 'TCustomDrawSectionEvent', iptrw);
    RegisterProperty('OnSectionClick', 'TCustomSectionNotifyEvent', iptrw);
    RegisterProperty('OnSectionDrag', 'TSectionDragEvent', iptrw);
    RegisterProperty('OnSectionEndDrag', 'TNotifyEvent', iptrw);
    RegisterProperty('OnSectionResize', 'TCustomSectionNotifyEvent', iptrw);
    RegisterProperty('OnSectionTrack', 'TCustomSectionTrackEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THeaderSections(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'THeaderSections') do
  with CL.AddClassN(CL.FindClass('TCollection'),'THeaderSections') do begin
    RegisterMethod('Constructor Create( HeaderControl : TCustomHeaderControl)');
    RegisterMethod('Function Add : THeaderSection');
    RegisterMethod('Function AddItem( Item : THeaderSection; Index : Integer) : THeaderSection');
    RegisterMethod('Function Insert( Index : Integer) : THeaderSection');
    RegisterProperty('Items', 'THeaderSection Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THeaderSection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'THeaderSection') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'THeaderSection') do begin
   RegisterMethod('Constructor Create(Collection: TCollection)');
    RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterMethod('Procedure ParentBiDiModeChanged');
    RegisterMethod('Function UseRightToLeftAlignment : Boolean');
    RegisterMethod('Function UseRightToLeftReading : Boolean');
    RegisterProperty('Left', 'Integer', iptr);
    RegisterProperty('Right', 'Integer', iptr);
    RegisterProperty('Alignment', 'TAlignment', iptrw);
    RegisterProperty('AllowClick', 'Boolean', iptrw);
    RegisterProperty('AutoSize', 'Boolean', iptrw);
    RegisterProperty('BiDiMode', 'TBiDiMode', iptrw);
    RegisterProperty('ImageIndex', 'TImageIndex', iptrw);
    RegisterProperty('MaxWidth', 'Integer', iptrw);
    RegisterProperty('MinWidth', 'Integer', iptrw);
    RegisterProperty('ParentBiDiMode', 'Boolean', iptrw);
    RegisterProperty('Style', 'THeaderSectionStyle', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStatusBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomStatusBar', 'TStatusBar') do
  with CL.AddClassN(CL.FindClass('TCustomStatusBar'),'TStatusBar') do begin
    RegisterPublishedProperties;
    RegisterProperty('OnDrawPanel', 'TDrawPanelEvent', iptrw);
    RegisterProperty('COLOR', 'TCOLOR', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    //RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('Panels', 'TStatusPanels', iptrw);
     RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);

 end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomStatusBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCustomStatusBar') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCustomStatusBar') do begin
    RegisterMethod('procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer)');
    RegisterMethod('Constructor Create(AOwner: TComponent);');
   RegisterMethod('Procedure Free');
    RegisterMethod('function ExecuteAction(Action: TBasicAction): Boolean;');
    RegisterMethod('procedure FlipChildren(AllLevels: Boolean);');

    RegisterPublishedProperties;
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('AutoHint', 'Boolean', iptrw);
    RegisterProperty('Panels', 'TStatusPanels', iptrw);
    RegisterProperty('SimplePanel', 'Boolean', iptrw);
    RegisterProperty('SimpleText', 'string', iptrw);
    RegisterProperty('SizeGrip', 'Boolean', iptrw);
    //RegisterProperty('COLOR', 'TCOLOR', iptrw);
    //RegisterProperty('Color', 'Boolean', iptrw);

    RegisterProperty('UseSystemFont', 'Boolean', iptrw);
    //RegisterProperty('OnCreatePanelClass', 'TSBCreatePanelClassEvent', iptrw);
    RegisterProperty('OnHint', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDrawPanel', 'TCustomDrawPanelEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStatusPanels(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TStatusPanels') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TStatusPanels') do begin
   RegisterMethod('procedure Assign(Source: TPersistent)');
    RegisterMethod('Constructor Create( StatusBar : TCustomStatusBar)');
    RegisterMethod('Function Add : TStatusPanel');
    RegisterMethod('Function AddItem( Item : TStatusPanel; Index : Integer) : TStatusPanel');
    RegisterMethod('Function Insert( Index : Integer) : TStatusPanel');
    RegisterProperty('Items', 'TStatusPanel Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStatusPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TStatusPanel') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TStatusPanel') do begin
    RegisterMethod('Constructor Create(Collection: TCollection)');
    RegisterMethod('Assign(Source: TPersistent);');
    RegisterMethod('Procedure ParentBiDiModeChanged');
    RegisterMethod('procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer)');
    RegisterMethod('Function UseRightToLeftAlignment : Boolean');
    RegisterMethod('Function UseRightToLeftReading : Boolean');
    RegisterProperty('Alignment', 'TAlignment', iptrw);
    RegisterProperty('Bevel', 'TStatusPanelBevel', iptrw);
    RegisterProperty('BiDiMode', 'TBiDiMode', iptrw);
    RegisterProperty('ParentBiDiMode', 'Boolean', iptrw);
    RegisterProperty('Style', 'TStatusPanelStyle', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPageControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTabControl', 'TPageControl') do
  with CL.AddClassN(CL.FindClass('TCustomTabControl'),'TPageControl') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
   RegisterMethod('Procedure Free');
      RegisterMethod('Function FindNextPage( CurPage : TTabSheet; GoForward, CheckTabVisible : Boolean) : TTabSheet');
    RegisterMethod('Procedure SelectNextPage( GoForward : Boolean; CheckTabVisible : Boolean)');
    RegisterProperty('ActivePageIndex', 'Integer', iptrw);
    RegisterProperty('PageCount', 'Integer', iptr);
    RegisterProperty('Pages', 'TTabSheet Integer', iptr);
    RegisterProperty('ActivePage', 'TTabSheet', iptrw);
   RegisterPublishedProperties;
       RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
   RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('ONChanging', 'TTabChangingEvent', iptrw);
    RegisterProperty('OnGetSiteInfo', 'TGetSiteInfoEvent', iptrw);
   RegisterProperty('ALIGN', 'TALIGN', iptrw);
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
    RegisterProperty('MultiLine', 'BOOLEAN', iptrw);
    RegisterProperty('TabHeight', 'integer', iptrw);
    RegisterProperty('TabIndex', 'Integer', iptr);
    RegisterProperty('TabWidth', 'integer', iptrw);
    RegisterProperty('ParentShowHint', 'Boolean', iptrw);
     RegisterProperty('Style', 'TTabStyle', iptrw);

    //property TabHeight;

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTabSheet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TTabSheet') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TTabSheet') do begin
  RegisterPublishedProperties;
     RegisterMethod('Constructor Create(AOwner: TComponent);');
   RegisterMethod('Procedure Free');
    RegisterProperty('PageControl', 'TPageControl', iptrw);
    RegisterProperty('TabIndex', 'Integer', iptr);
    RegisterProperty('Highlighted', 'Boolean', iptrw);
    RegisterProperty('ImageIndex', 'TImageIndex', iptrw);
    RegisterProperty('PageIndex', 'Integer', iptrw);
    RegisterProperty('TabVisible', 'Boolean', iptrw);
    RegisterProperty('OnHide', 'TNotifyEvent', iptrw);
    RegisterProperty('OnShow', 'TNotifyEvent', iptrw);
    RegisterProperty('Caption', 'string', iptrw);        //!!
    RegisterProperty('BorderWidth', 'integer', iptr);
    RegisterProperty('CANVAS', 'TCANVAS', iptr);
    RegisterProperty('AUTOSIZE', 'BOOLEAN', iptrw);
    RegisterProperty('CENTER', 'BOOLEAN', iptrw);
    RegisterProperty('PICTURE', 'TPICTURE', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
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
    RegisterProperty('ParentShowHint', 'Boolean', iptrw);
   end;
end;

//property PageIndex: Integer read GetPageIndex write SetPageIndex stored False;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTabControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTabControl', 'TTabControl') do
  with CL.AddClassN(CL.FindClass('TCustomTabControl'),'TTabControl') do begin
      RegisterPublishedProperties;
    RegisterProperty('Tabs', 'TStrings', iptr);
   //  RegisterPublishedProperties;
   RegisterProperty('TabIndex', 'Integer', iptr);
   RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGN', 'TALIGN', iptrw);
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('MultiLine', 'BOOLEAN', iptrw);
   RegisterProperty('MultiSelect', 'BOOLEAN', iptrw);

    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
    RegisterProperty('OnGetSiteInfo', 'TGetSiteInfoEvent', iptrw);
     RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('ONChanging', 'TTabChangingEvent', iptrw);
    RegisterProperty('TabHeight', 'integer', iptrw);
    RegisterProperty('TabWidth', 'integer', iptrw);
    RegisterProperty('ParentShowHint', 'Boolean', iptrw);
    RegisterProperty('Style', 'TTabStyle', iptrw);

    //property Style: TTabStyle
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomTabControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCustomTabControl') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCustomTabControl') do begin
     RegisterMethod('Constructor Create(AOwner: TComponent);');
     RegisterMethod('Procedure Free');
     RegisterPublishedProperties;
    RegisterMethod('Function IndexOfTabAt( X, Y : Integer) : Integer');
    RegisterMethod('Function GetHitTestInfoAt( X, Y : Integer) : THitTests');
    RegisterMethod('Function TabRect( Index : Integer) : TRect');
    RegisterMethod('Function RowCount : Integer');
    RegisterMethod('Procedure ScrollTabs( Delta : Integer)');
    RegisterProperty('Canvas', 'TCanvas', iptr);
    //RegisterProperty('Tabs', 'TStrings', iptr);
    //ttabcontrol
  end;
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_TBytesStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMemoryStream', 'TBytesStream') do
  with CL.AddClassN(CL.FindClass('TMemoryStream'),'TBytesStream') do begin
    RegisterMethod('Constructor Create( const ABytes : TBytes);');
    RegisterProperty('Bytes', 'TBytes', iptr);
  end;
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_ComCtrls(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('THitTest', '( htAbove, htBelow, htNowhere, htOnItem, htOnButton,'
   +' htOnIcon, htOnIndent, htOnLabel, htOnRight, htOnStateIcon, htToLeft, htToRight )');
  CL.AddTypeS('THitTests', 'set of THitTest');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomTabControl');
  CL.AddTypeS('TTabChangingEvent', 'Procedure ( Sender : TObject; var AllowChange: Boolean)');
  CL.AddTypeS('TGetSiteInfoEvent', 'procedure (Sender:TObject; DockClient:TControl; var InfluenceRect:TRect; MousePos: TPoint; var CanDock: Boolean)');

  CL.AddTypeS('TTabPosition', '( tpTop, tpBottom, tpLeft, tpRight )');
  CL.AddTypeS('TTabStyle', '( tsTabs, tsButtons, tsFlatButtons )');
  CL.AddTypeS('TDrawTabEvent', 'Procedure ( Control : TCustomTabControl; TabIndex: Integer; const Rect : TRect; Active : Boolean)');
  CL.AddTypeS('TTabGetImageEvent', 'Procedure ( Sender : TObject; TabIndex: Integer; var ImageIndex : Integer)');
  CL.AddTypeS('TWidth', 'Integer');
  CL.AddTypeS('_TREEITEM', 'record fake: byte; end;');

   //_TREEITEM = packed record end;

  CL.AddTypeS('HTREEITEM', '_TREEITEM');

  // HTREEITEM = ^_TREEITEM;
  SIRegister_TCustomTabControl(CL);
  SIRegister_TTabControl(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPageControl');
  SIRegister_TTabSheet(CL);
  SIRegister_TPageControl(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomStatusBar');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStatusPanel');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStatusPanels');
  CL.AddTypeS('TStatusPanelStyle', '( psText, psOwnerDraw )');
  CL.AddTypeS('TStatusPanelBevel', '( pbNone, pbLowered, pbRaised )');
  //CL.AddTypeS('TStatusPanelClass', 'class of TStatusPanel');
  SIRegister_TStatusPanel(CL);
  SIRegister_TStatusPanels(CL);
  CL.AddTypeS('TCustomDrawPanelEvent', 'Procedure ( StatusBar : TCustomStatusBa'
   +'r; Panel : TStatusPanel; const Rect : TRect)');
  //CL.AddTypeS('TSBCreatePanelClassEvent', 'Procedure ( Sender : TCustomStatusBa'
   //+'r; var PanelClass : TStatusPanelClass)');
  //CL.AddClassN(CL.FindClass('TComponent'),'TBasicAction');

  SIRegister_TCustomStatusBar(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStatusBar');
  CL.AddTypeS('TDrawPanelEvent', 'Procedure ( StatusBar : TStatusBar; Panel : TStatusPanel; const Rect : TRect)');
  SIRegister_TStatusBar(CL);
  CL.AddTypeS('TCustomDrawTarget', '( dtControl, dtItem, dtSubItem )');
  CL.AddTypeS('TCustomDrawStage', '( cdPrePaint, cdPostPaint, cdPreErase, cdPostErase )');
  CL.AddTypeS('TCustomDrawState', '( cdsSelected, cdsGrayed, cdsDisabled'
   +', cdsChecked, cdsFocused, cdsDefault, cdsHot, cdsMarked, cdsIndeterminate)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomHeaderControl');
  CL.AddClassN(CL.FindClass('TOBJECT'),'THeaderControl');
  CL.AddClassN(CL.FindClass('TOBJECT'),'THeaderSection');
  CL.AddTypeS('THeaderSectionStyle', '( hsText, hsOwnerDraw )');
  //CL.AddTypeS('THeaderSectionClass', 'class of THeaderSection');
  SIRegister_THeaderSection(CL);
  SIRegister_THeaderSections(CL);
  CL.AddTypeS('TSectionTrackState', '( tsTrackBegin, tsTrackMove, tsTrackEnd )');
  CL.AddTypeS('TCustomDrawSectionEvent', 'Procedure ( HeaderControl : TCustomHe'
   +'aderControl; Section : THeaderSection; const Rect : TRect; Pressed : Boolean)');
  CL.AddTypeS('TCustomSectionNotifyEvent', 'Procedure ( HeaderControl : TCustom'
   +'HeaderControl; Section : THeaderSection)');
  CL.AddTypeS('TCustomSectionTrackEvent', 'Procedure ( HeaderControl : TCustomH'
   +'eaderControl; Section : THeaderSection; Width : Integer; State : TSectionTrackState)');
  CL.AddTypeS('TSectionDragEvent', 'Procedure ( Sender : TObject; FromSection, '
   +'ToSection : THeaderSection; var AllowDrag : Boolean)');
  //CL.AddTypeS('TCustomHCCreateSectionClassEvent', 'Procedure ( Sender : TCustom'
   //+'HeaderControl; var SectionClass : THeaderSectionClass)');
  CL.AddTypeS('THeaderStyle', '( hsButtons, hsFlat )');
  SIRegister_TCustomHeaderControl(CL);
  CL.AddTypeS('TDrawSectionEvent', 'Procedure ( HeaderControl : THeaderControl;'
   +' Section : THeaderSection; const Rect : TRect; Pressed : Boolean)');
  CL.AddTypeS('TSectionNotifyEvent', 'Procedure ( HeaderControl : THeaderControl; Section : THeaderSection)');
  CL.AddTypeS('TSectionTrackEvent', 'Procedure ( HeaderControl : THeaderControl'
   +'; Section : THeaderSection; Width : Integer; State : TSectionTrackState)');
  //CL.AddTypeS('THCCreateSectionClassEvent', 'Procedure ( Sender : THeaderContro'
   //+'l; var SectionClass : THeaderSectionClass)');
  SIRegister_THeaderControl(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomTreeView');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTreeNode');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTreeNodes');
  CL.AddTypeS('TNodeState', '( nsCut, nsDropHilited, nsFocused, nsSelected, nsExpanded )');
  CL.AddTypeS('TNodeAttachMode', '( naAdd, naAddFirst, naAddChild, naAddChildFirst, naInsert )');
  CL.AddTypeS('TAddMode', '( taAddFirst, taAdd, taInsert )');
  //CL.AddTypeS('TTreeNodeClass', 'class of TTreeNode');
  SIRegister_TListItem(CL);
  SIRegister_TListItemsEnumerator(CL);
   SIRegister_TTreeNode(CL);
  SIRegister_TTreeNodesEnumerator(CL);
  //CL.AddTypeS('PNodeCache', '^TNodeCache // will not work');
  CL.AddTypeS('TNodeCache', 'record CacheNode : TTreeNode; CacheIndex : Integer; end');
  //SIRegister_TTreeNodes(CL);
  SIRegister_TListItems(CL);
  SIRegister_TTreeNodes(CL);

  CL.AddTypeS('TSortType', '( stNone, stData, stText, stBoth )');
  CL.AddTypeS('TMultiSelectStyles', '( msControlSelect, msShiftSelect, msVisibleOnly, msSiblingOnly )');
  CL.AddTypeS('TMultiSelectStyle', 'set of TMultiSelectStyles');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ETreeViewError');
  CL.AddTypeS('TTVChangingEvent', 'Procedure ( Sender : TObject; Node : TTreeNode; var AllowChange : Boolean)');
  CL.AddTypeS('TTVChangedEvent', 'Procedure ( Sender : TObject; Node : TTreeNode)');
  //  TTVChangedEvent = procedure(Sender: TObject; Node: TTreeNode) of object;

  CL.AddTypeS('TTVEditingEvent', 'Procedure ( Sender : TObject; Node : TTreeNode; var AllowEdit : Boolean)');
  CL.AddTypeS('TTVEditedEvent', 'Procedure ( Sender : TObject; Node : TTreeNode; var S : string)');
  CL.AddTypeS('TTVExpandingEvent', 'Procedure ( Sender : TObject; Node : TTreeN'
   +'ode; var AllowExpansion : Boolean)');
  CL.AddTypeS('TTVCollapsingEvent', 'Procedure ( Sender : TObject; Node : TTree'
   +'Node; var AllowCollapse : Boolean)');
  CL.AddTypeS('TTVExpandedEvent', 'Procedure ( Sender : TObject; Node : TTreeNode)');
  CL.AddTypeS('TTVCompareEvent', 'Procedure ( Sender : TObject; Node1, Node2 : '
   +'TTreeNode; Data : Integer; var Compare : Integer)');
  CL.AddTypeS('TTVCustomDrawEvent', 'Procedure ( Sender : TCustomTreeView; const ARect : TRect; var DefaultDraw : Boolean)');
  CL.AddTypeS('TTVCustomDrawItemEvent', 'Procedure ( Sender : TCustomTreeView; '
   +'Node : TTreeNode; State : TCustomDrawState; var DefaultDraw : Boolean)');
  CL.AddTypeS('TTVAdvancedCustomDrawEvent', 'Procedure ( Sender : TCustomTreeVi'
   +'ew; const ARect : TRect; Stage : TCustomDrawStage; var DefaultDraw : Boolean)');
  //CL.AddTypeS('TTVAdvancedCustomDrawItemEvent', 'Procedure ( Sender : TCustomTr'
  // +'eeView; Node : TTreeNode; State : TCustomDrawState; Stage : TCustomDrawSta'
   //+'ge; var PaintImages, DefaultDraw : Boolean)');
  //CL.AddTypeS('TTVCreateNodeClassEvent', 'Procedure ( Sender : TCustomTreeView;'
   //+' var NodeClass : TTreeNodeClass)');
  SIRegister_TCustomTreeView(CL);
  SIRegister_TTreeView(CL);  //************************
  CL.AddTypeS('TTrackBarOrientation', '( trHorizontal, trVertical )');
  CL.AddTypeS('TTickMark', '( tmBottomRight, tmTopLeft, tmBoth )');
  CL.AddTypeS('TTickStyle', '( tsNone, tsAuto, tsManual )');
  CL.AddTypeS('TPositionToolTip', '( ptNone, ptTop, ptLeft, ptBottom, ptRight )');
  SIRegister_TTrackBar(CL);
  CL.AddTypeS('TProgressRange', 'Integer');
  CL.AddTypeS('TProgressBarOrientation', '( pbHorizontal, pbVertical )');
  SIRegister_TProgressBar(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomRichEdit');
  CL.AddTypeS('TAttributeType', '( atSelected, atDefaultText )');
  CL.AddTypeS('TConsistentAttribute', '( caBold, caColor, caFace, caItalic, caS'
   +'ize, caStrikeOut, caUnderline, caProtected )');
  CL.AddTypeS('TConsistentAttributes', 'set of TConsistentAttribute');
  SIRegister_TTextAttributes(CL);
  CL.AddTypeS('TNumberingStyle', '( nsNone, nsBullet )');
  SIRegister_TParaAttributes(CL);
  CL.AddTypeS('TRichEditResizeEvent', 'Procedure ( Sender : TObject; Rect : TRect)');
  CL.AddTypeS('TRichEditProtectChange', 'Procedure ( Sender : TObject; StartPos'
   +', EndPos : Integer; var AllowChange : Boolean)');
  CL.AddTypeS('TRichEditSaveClipboard', 'Procedure ( Sender : TObject; NumObjec'
   +'ts, NumChars : Integer; var SaveClipboard : Boolean)');
  CL.AddTypeS('TSearchType', '( stWholeWord, stMatchCase )');
  CL.AddTypeS('TSearchTypes', 'set of TSearchType');
  SIRegister_TConversion(CL);
  //CL.AddTypeS('TConversionClass', 'class of TConversion');
  //CL.AddTypeS('PConversionFormat', '^TConversionFormat // will not work');
 // CL.AddTypeS('TConversionFormat', 'record ConversionClass : TConversionClass; '
   //+'Extension : string; Next : PConversionFormat; end');
  //CL.AddTypeS('PRichEditStreamInfo', '^TRichEditStreamInfo // will not work');
  CL.AddTypeS('TRichEditStreamInfo', 'record Converter : TConversion; Stream: TStream; end');
  SIRegister_TCustomRichEdit(CL);
  SIRegister_TRichEdit(CL);
  CL.AddTypeS('TUDAlignButton', '( udLeft, udRight )');
  CL.AddTypeS('TUDOrientation', '( udHorizontal, udVertical )');
  CL.AddTypeS('TUDBtnType', '( btNext, btPrev )');
  CL.AddTypeS('TUpDownDirection', '( updNone, updUp, updDown )');
  CL.AddTypeS('TUDClickEvent', 'Procedure ( Sender : TObject; Button : TUDBtnType)');
  CL.AddTypeS('TUDChangingEvent', 'Procedure ( Sender : TObject; var AllowChange: Boolean)');
  CL.AddTypeS('TUDChangingEventEx', 'Procedure ( Sender : TObject; var AllowCha'
   +'nge : Boolean; NewValue : SmallInt; Direction : TUpDownDirection)');
  SIRegister_TCustomUpDown(CL);
  SIRegister_TUpDown(CL);
  CL.AddTypeS('THKModifier', '( hkShift, hkCtrl, hkAlt, hkExt )');
  CL.AddTypeS('THKModifiers', 'set of THKModifier');
  CL.AddTypeS('THKInvalidKey', '( hcNone, hcShift, hcCtrl, hcAlt, hcShiftCtrl, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt )');
  CL.AddTypeS('THKInvalidKeys', 'set of THKInvalidKey');
  SIRegister_TCustomHotKey(CL);
  SIRegister_THotKey(CL);
// CL.AddConstantN('ColumnHeaderWidth','').SetString( LVSCW_AUTOSIZE_USEHEADER);
 //CL.AddConstantN('ColumnTextWidth','').SetString( LVSCW_AUTOSIZE);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TListColumns');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TListItem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TListItems');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomListView');
  SIRegister_TListColumn(CL);
  SIRegister_TListColumns(CL);
  CL.AddTypeS('TDisplayCode', '( drBounds, drIcon, drLabel, drSelectBounds )');
  //CL.AddTypeS('TListItemClass', 'class of TListItem');
  SIRegister_TListItem(CL);
  SIRegister_TListItemsEnumerator(CL);
  SIRegister_TListItems(CL);
  SIRegister_TWorkArea(CL);
  SIRegister_TWorkAreas(CL);
  CL.AddTypeS('TIconArrangement', '( iaTop, iaLeft )');
  SIRegister_TIconOptions(CL);
  CL.AddTypeS('TListArrangement', '( arAlignBottom, arAlignLeft, arAlignRight, '
   +'arAlignTop, arDefault, arSnapToGrid )');
  CL.AddTypeS('TViewStyle', '( vsIcon, vsSmallIcon, vsList, vsReport )');
  CL.AddTypeS('TItemState', '( isNone, isCut, isDropHilited, isFocused, isSelected, isActivating )');
  CL.AddTypeS('TItemStates', 'set of TItemState');
  CL.AddTypeS('TItemChange', '( ctText, ctImage, ctState )');
  CL.AddTypeS('TItemFind', '( ifData, ifPartialString, ifExactString, ifNearest)');
  CL.AddTypeS('TSearchDirection', '( sdLeft, sdRight, sdAbove, sdBelow, sdAll )');
  CL.AddTypeS('TListHotTrackStyle', '( htHandPoint, htUnderlineCold, htUnderlineHot )');
  CL.AddTypeS('TListHotTrackStyles', 'set of TListHotTrackStyle');
  CL.AddTypeS('TItemRequests', '( irText, irImage, irParam, irState, irIndent )');
  CL.AddTypeS('TItemRequest', 'set of TItemRequests');
  CL.AddTypeS('TLVDeletedEvent', 'Procedure ( Sender : TObject; Item : TListItem)');
  CL.AddTypeS('TLVEditingEvent', 'Procedure ( Sender : TObject; Item : TListItem; var AllowEdit : Boolean)');
  CL.AddTypeS('TLVEditedEvent', 'Procedure ( Sender : TObject; Item : TListItem; var S : string)');
  CL.AddTypeS('TLVChangeEvent', 'Procedure ( Sender : TObject; Item : TListItem; Change : TItemChange)');
  CL.AddTypeS('TLVChangingEvent', 'Procedure ( Sender : TObject; Item : TListIt'
   +'em; Change : TItemChange; var AllowChange : Boolean)');
  CL.AddTypeS('TLVColumnClickEvent', 'Procedure ( Sender : TObject; Column : TListColumn)');
  CL.AddTypeS('TLVColumnRClickEvent', 'Procedure ( Sender : TObject; Column : TListColumn; Point : TPoint)');
  CL.AddTypeS('TLVCompareEvent', 'Procedure ( Sender : TObject; Item1, Item2 : '
   +'TListItem; Data : Integer; var Compare : Integer)');
  CL.AddTypeS('TLVNotifyEvent', 'Procedure ( Sender : TObject; Item : TListItem)');
  CL.AddTypeS('TLVSelectItemEvent', 'Procedure ( Sender : TObject; Item : TListItem; Selected : Boolean)');
  CL.AddTypeS('TLVDrawItemEvent', 'Procedure ( Sender : TCustomListView; Item :'
   +' TListItem; Rect : TRect; State : TOwnerDrawState)');
  CL.AddTypeS('TLVCustomDrawEvent', 'Procedure ( Sender : TCustomListView; cons'
   +'t ARect : TRect; var DefaultDraw : Boolean)');
  //CL.AddTypeS('TLVCustomDrawItemEvent', 'Procedure ( Sender : TCustomListView; '
   //+'Item : TListItem; State : TCustomDrawState; var DefaultDraw : Boolean)');
  //CL.AddTypeS('TLVCustomDrawSubItemEvent', 'Procedure ( Sender : TCustomListVie'
   //+'w; Item : TListItem; SubItem : Integer; State : TCustomDrawState; var Defa'
   //+'ultDraw : Boolean)');
  CL.AddTypeS('TLVAdvancedCustomDrawEvent', 'Procedure ( Sender : TCustomListVi'
   +'ew; const ARect : TRect; Stage : TCustomDrawStage; var DefaultDraw : Boolean)');
  //CL.AddTypeS('TLVAdvancedCustomDrawItemEvent', 'Procedure ( Sender : TCustomLi'
   //+'stView; Item : TListItem; State : TCustomDrawState; Stage : TCustomDrawSta'
   //+'ge; var DefaultDraw : Boolean)');
  //CL.AddTypeS('TLVAdvancedCustomDrawSubItemEvent', 'Procedure ( Sender : TCusto'
   //+'mListView; Item : TListItem; SubItem : Integer; State : TCustomDrawState; '
   //+'Stage : TCustomDrawStage; var DefaultDraw : Boolean)');
  //CL.AddTypeS('TLVOwnerDataEvent', 'Procedure ( Sender : TObject; Item : TListI'
  // +'tem)');
  {CL.AddTypeS('TLVOwnerDataFindEvent', 'Procedure ( Sender : TObject; Find : TI'
   +'temFind; const FindString : string; const FindPosition : TPoint; FindData '
   +': Pointer; StartIndex : Integer; Direction : TSearchDirection; Wrap : Bool'
   +'ean; var Index : Integer)');
  CL.AddTypeS('TLVOwnerDataHintEvent', 'Procedure ( Sender : TObject; StartInde'
   +'x, EndIndex : Integer)');
  CL.AddTypeS('TLVOwnerDataStateChangeEvent', 'Procedure ( Sender : TObject; St'
   +'artIndex, EndIndex : Integer; OldState, NewState : TItemStates)');
  CL.AddTypeS('TLVSubItemImageEvent', 'Procedure ( Sender : TObject; Item : TLi'
   +'stItem; SubItem : Integer; var ImageIndex : Integer)');
  CL.AddTypeS('TLVInfoTipEvent', 'Procedure ( Sender : TObject; Item : TListIte'
   +'m; var InfoTip : string)');}
  //CL.AddTypeS('TLVCreateItemClassEvent', 'Procedure ( Sender : TCustomListView;'
   //+' var ItemClass : TListItemClass)');
  SIRegister_TCustomListView(CL);
  SIRegister_TListView(CL);
  SIRegister_TListViewActionLink(CL);
  SIRegister_TCustomTreeView(CL);
  SIRegister_TTreeView(CL);  //************************

  CL.AddTypeS('TCommonAVI', '( aviNone, aviFindFolder, aviFindFile, aviFindComp'
   +'uter, aviCopyFiles, aviCopyFile, aviRecycleFile, aviEmptyRecycle, aviDeleteFile )');
  SIRegister_TAnimate(CL);
 CL.AddConstantN('CN_DROPDOWNCLOSED','LongWord').SetUInt( WM_USER + $1000);
  CL.AddTypeS('TToolButtonStyle', '( tbsButton, tbsCheck, tbsDropDown, tbsSepar'
   +'ator, tbsDivider, tbsTextButton )');
  CL.AddTypeS('TToolButtonState', '( tbsChecked, tbsPressed, tbsEnabled, tbsHid'
   +'den, tbsIndeterminate, tbsWrap, tbsEllipses, tbsMarked )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TToolBar');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TToolButton');
  SIRegister_TToolButtonActionLink(CL);
  //CL.AddTypeS('TToolButtonActionLinkClass', 'class of TToolButtonActionLink');
  SIRegister_TToolButton(CL);
 // CL.AddTypeS('TTBCustomDrawFlags', 'set of ( tbNoEdges, tbHiliteHotTrack, tbNo'
  // +'Offset, tbNoMark, tbNoEtchedEffect )');
  //CL.AddTypeS('TTBGradientDrawingOptions', 'set of ( gdoHotTrack, gdoGradient )');
  CL.AddTypeS('TTBDrawingStyle', '( dsNormal, dsGradient )');
  CL.AddTypeS('TTBCustomDrawEvent', 'Procedure ( Sender : TToolBar; const ARect'
   +' : TRect; var DefaultDraw : Boolean)');
  //CL.AddTypeS('TTBCustomDrawBtnEvent', 'Procedure ( Sender : TToolBar; Button :'
  // +' TToolButton; State : TCustomDrawState; var DefaultDraw : Boolean)');
  CL.AddTypeS('TTBAdvancedCustomDrawEvent', 'Procedure ( Sender : TToolBar; con'
   +'st ARect : TRect; Stage : TCustomDrawStage; var DefaultDraw : Boolean)');
  //CL.AddTypeS('TTBAdvancedCustomDrawBtnEvent', 'Procedure ( Sender : TToolBar; '
   //+'Button : TToolButton; State : TCustomDrawState; Stage : TCustomDrawStage; '
   //+'var Flags : TTBCustomDrawFlags; var DefaultDraw : Boolean)');
  CL.AddTypeS('TTBCustomizeQueryEvent', 'Procedure ( Sender : TToolbar; Index :'
   +' Integer; var Allow : Boolean)');
  CL.AddTypeS('TTBNewButtonEvent', 'Procedure ( Sender : TToolbar; Index : Inte'
   +'ger; var Button : TToolButton)');
  CL.AddTypeS('TTBButtonEvent', 'Procedure ( Sender : TToolbar; Button : TToolButton)');
  SIRegister_TToolBarEnumerator(CL);
  SIRegister_TToolBar(CL);
  SIRegister_TToolBarDockObject(CL);
 CL.AddConstantN('CN_BANDCHANGE','LongWord').SetUInt( WM_USER + $1000);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCoolBar');
  SIRegister_TCoolBand(CL);
  SIRegister_TCoolBands(CL);
  CL.AddTypeS('TCoolBandMaximize', '( bmNone, bmClick, bmDblClick )');
  SIRegister_TCoolBar(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCommonCalendar');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ECommonCalendarError');
  SIRegister_TMonthCalColors(CL);
  CL.AddTypeS('TCalDayOfWeek', '( dowMonday, dowTuesday, dowWednesday, dowThurs'
   +'day, dowFriday, dowSaturday, dowSunday, dowLocaleDefault )');
  CL.AddTypeS('TOnGetMonthInfoEvent', 'Procedure ( Sender : TObject; Month : Lo'
   +'ngWord; var MonthBoldInfo : LongWord)');
  SIRegister_TCommonCalendar(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMonthCalError');
  SIRegister_TMonthCalendar(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EDateTimeError');
  CL.AddTypeS('TDateTimeKind', '( dtkDate, dtkTime )');
  CL.AddTypeS('TDTDateMode', '( dmComboBox, dmUpDown )');
  CL.AddTypeS('TDTDateFormat', '( dfShort, dfLong )');
  CL.AddTypeS('TDTCalAlignment', '( dtaLeft, dtaRight )');
  CL.AddTypeS('TDTParseInputEvent', 'Procedure ( Sender : TObject; const UserSt'
   +'ring : string; var DateAndTime : TDateTime; var AllowChange : Boolean)');
  CL.AddTypeS('TDateTimeColors', 'TMonthCalColors');
  SIRegister_TDateTimePicker(CL);
  CL.AddTypeS('TPageScrollerOrientation', '( soHorizontal, soVertical )');
  CL.AddTypeS('TPageScrollerButton', '( sbFirst, sbLast )');
  CL.AddTypeS('TPageScrollerButtonState', '( bsNormal, bsInvisible, bsGrayed, bsDepressed, bsHot )');
  CL.AddTypeS('TPageScrollEvent', 'Procedure ( Sender : TObject; Shift : TShift'
   +'State; X, Y : Integer; Orientation : TPageScrollerOrientation; var Delta : Integer)');
  SIRegister_TPageScroller(CL);
  SIRegister_TComboExItem(CL);
  SIRegister_TComboExItems(CL);
  //CL.AddTypeS('TComboExItemsClass', 'class of TComboExItems');
  //CL.AddTypeS('TComboExItemClass', 'class of TComboExItem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomComboBoxEx');
  SIRegister_TComboBoxExStrings(CL);
  CL.AddTypeS('TComboBoxExStyle', '( csExDropDown, csExSimple, csExDropDownList)');
  CL.AddTypeS('TComboBoxExStyleEx', '( csExCaseSensitive, csExNoEditImage, csEx'
   +'NoEditImageIndent, csExNoSizeLimit, csExPathWordBreak )');
  CL.AddTypeS('TComboBoxExStyles', 'set of TComboBoxExStyleEx');
  CL.AddTypeS('TAutoCompleteOption', '( acoAutoSuggest, acoAutoAppend, acoSearc'
   +'h, acoFilterPrefixes, acoUseTab, acoUpDownKeyDropsList, acoRtlReading )');
  CL.AddTypeS('TAutoCompleteOptions', 'set of TAutoCompleteOption');
  SIRegister_TCustomComboBoxEx(CL);
  SIRegister_TComboBoxEx(CL);
  SIRegister_TComboBoxExActionLink(CL);
  SIRegister_TBytesStream(CL);

 CL.AddDelphiFunction('Function InitCommonControl( CC : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure CheckCommonControl( CC : Integer)');
 CL.AddConstantN('ComCtlVersionIE3','LongWord').SetUInt( $00040046);
 CL.AddConstantN('ComCtlVersionIE4','LongWord').SetUInt( $00040047);
 CL.AddConstantN('ComCtlVersionIE401','LongWord').SetUInt( $00040048);
 CL.AddConstantN('ComCtlVersionIE5','LongWord').SetUInt( $00050050);
 CL.AddConstantN('ComCtlVersionIE501','LongWord').SetUInt( $00050051);
 CL.AddConstantN('ComCtlVersionIE6','LongWord').SetUInt( $00060000);
 CL.AddDelphiFunction('Function GetComCtlVersion : Integer');
 CL.AddDelphiFunction('Procedure CheckToolMenuDropdown( ToolButton : TToolButton)');
end;

(* === run-time registration functions === *)

procedure TITEMONCLICK_W(Self: TToolButton; const T: TNOTIFYEVENT);
begin Self.ONCLICK := T; end;
procedure TITEMONCLICK_R(Self: TToolButton; var T: TNOTIFYEVENT);
begin T := Self.ONCLICK; end;

{procedure TITEMONDBLCLICK_W(Self: TToolButton; const T: TNOTIFYEVENT);
begin Self.ONDBLCLICK := T; end;
procedure TITEMONDBLCLICK_R(Self: TToolButton; var T: TNOTIFYEVENT);
begin T := Self.ONDBLCLICK; end; }
{procedure TITEMONENTER_W(Self: TToolButton; const T: TNOTIFYEVENT);
begin Self.ONENTER:= T; end;
procedure TITEMONENTER_R(Self: TToolButton; var T: TNOTIFYEVENT);
begin T := Self.ONENTER; end;
procedure TITEMONEXIT_W(Self: TToolButton; const T: TNOTIFYEVENT);
begin Self.ONEXIT:= T; end;
procedure TITEMONEXIT_R(Self: TToolButton; var T: TNOTIFYEVENT);
begin T := Self.ONEXIT; end;}




(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExOnEndEdit_W(Self: TCustomComboBoxEx; const T: TNotifyEvent);
begin Self.OnEndEdit := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExOnEndEdit_R(Self: TCustomComboBoxEx; var T: TNotifyEvent);
begin T := Self.OnEndEdit; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExOnBeginEdit_W(Self: TCustomComboBoxEx; const T: TNotifyEvent);
begin Self.OnBeginEdit := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExOnBeginEdit_R(Self: TCustomComboBoxEx; var T: TNotifyEvent);
begin T := Self.OnBeginEdit; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExStyleEx_W(Self: TCustomComboBoxEx; const T: TComboBoxExStyles);
begin Self.StyleEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExStyleEx_R(Self: TCustomComboBoxEx; var T: TComboBoxExStyles);
begin T := Self.StyleEx; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExStyle_W(Self: TCustomComboBoxEx; const T: TComboBoxExStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExStyle_R(Self: TCustomComboBoxEx; var T: TComboBoxExStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExSelText_W(Self: TCustomComboBoxEx; const T: string);
begin Self.SelText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExSelText_R(Self: TCustomComboBoxEx; var T: string);
begin T := Self.SelText; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExItemsEx_W(Self: TCustomComboBoxEx; const T: TComboExItems);
begin Self.ItemsEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExItemsEx_R(Self: TCustomComboBoxEx; var T: TComboExItems);
begin T := Self.ItemsEx; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExImages_W(Self: TCustomComboBoxEx; const T: TCustomImageList);
begin Self.Images := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExImages_R(Self: TCustomComboBoxEx; var T: TCustomImageList);
begin T := Self.Images; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExDropDownCount_W(Self: TCustomComboBoxEx; const T: Integer);
begin Self.DropDownCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExDropDownCount_R(Self: TCustomComboBoxEx; var T: Integer);
begin T := Self.DropDownCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExAutoCompleteOptions_W(Self: TCustomComboBoxEx; const T: TAutoCompleteOptions);
begin Self.AutoCompleteOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComboBoxExAutoCompleteOptions_R(Self: TCustomComboBoxEx; var T: TAutoCompleteOptions);
begin T := Self.AutoCompleteOptions; end;

(*----------------------------------------------------------------------------*)
procedure TComboBoxExStringsItemsEx_W(Self: TComboBoxExStrings; const T: TComboExItems);
begin Self.ItemsEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TComboBoxExStringsItemsEx_R(Self: TComboBoxExStrings; var T: TComboExItems);
begin T := Self.ItemsEx; end;

(*----------------------------------------------------------------------------*)
procedure TComboBoxExStringsSortType_W(Self: TComboBoxExStrings; const T: TListItemsSortType);
begin Self.SortType := T; end;

(*----------------------------------------------------------------------------*)
procedure TComboBoxExStringsSortType_R(Self: TComboBoxExStrings; var T: TListItemsSortType);
begin T := Self.SortType; end;

(*----------------------------------------------------------------------------*)
procedure TComboExItemsComboItems_R(Self: TComboExItems; var T: TComboExItem; const t1: Integer);
begin T := Self.ComboItems[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TComboExItemSelectedImageIndex_W(Self: TComboExItem; const T: TImageIndex);
begin Self.SelectedImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TComboExItemSelectedImageIndex_R(Self: TComboExItem; var T: TImageIndex);
begin T := Self.SelectedImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TComboExItemOverlayImageIndex_W(Self: TComboExItem; const T: TImageIndex);
begin Self.OverlayImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TComboExItemOverlayImageIndex_R(Self: TComboExItem; var T: TImageIndex);
begin T := Self.OverlayImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TComboExItemIndent_W(Self: TComboExItem; const T: Integer);
begin Self.Indent := T; end;

(*----------------------------------------------------------------------------*)
procedure TComboExItemIndent_R(Self: TComboExItem; var T: Integer);
begin T := Self.Indent; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerOnScroll_W(Self: TPageScroller; const T: TPageScrollEvent);
begin Self.OnScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerOnScroll_R(Self: TPageScroller; var T: TPageScrollEvent);
begin T := Self.OnScroll; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerPosition_W(Self: TPageScroller; const T: Integer);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerPosition_R(Self: TPageScroller; var T: Integer);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerOrientation_W(Self: TPageScroller; const T: TPageScrollerOrientation);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerOrientation_R(Self: TPageScroller; var T: TPageScrollerOrientation);
begin T := Self.Orientation; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerMargin_W(Self: TPageScroller; const T: Integer);
begin Self.Margin := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerMargin_R(Self: TPageScroller; var T: Integer);
begin T := Self.Margin; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerDragScroll_W(Self: TPageScroller; const T: Boolean);
begin Self.DragScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerDragScroll_R(Self: TPageScroller; var T: Boolean);
begin T := Self.DragScroll; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerControl_W(Self: TPageScroller; const T: TWinControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerControl_R(Self: TPageScroller; var T: TWinControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerButtonSize_W(Self: TPageScroller; const T: Integer);
begin Self.ButtonSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerButtonSize_R(Self: TPageScroller; var T: Integer);
begin T := Self.ButtonSize; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerAutoScroll_W(Self: TPageScroller; const T: Boolean);
begin Self.AutoScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageScrollerAutoScroll_R(Self: TPageScroller; var T: Boolean);
begin T := Self.AutoScroll; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerOnUserInput_W(Self: TDateTimePicker; const T: TDTParseInputEvent);
begin Self.OnUserInput := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerOnUserInput_R(Self: TDateTimePicker; var T: TDTParseInputEvent);
begin T := Self.OnUserInput; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerOnDropDown_W(Self: TDateTimePicker; const T: TNotifyEvent);
begin Self.OnDropDown := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerOnDropDown_R(Self: TDateTimePicker; var T: TNotifyEvent);
begin T := Self.OnDropDown; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerOnChange_W(Self: TDateTimePicker; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerOnChange_R(Self: TDateTimePicker; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerOnCloseUp_W(Self: TDateTimePicker; const T: TNotifyEvent);
begin Self.OnCloseUp := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerOnCloseUp_R(Self: TDateTimePicker; var T: TNotifyEvent);
begin T := Self.OnCloseUp; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerParseInput_W(Self: TDateTimePicker; const T: Boolean);
begin Self.ParseInput := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerParseInput_R(Self: TDateTimePicker; var T: Boolean);
begin T := Self.ParseInput; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerKind_W(Self: TDateTimePicker; const T: TDateTimeKind);
begin Self.Kind := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerKind_R(Self: TDateTimePicker; var T: TDateTimeKind);
begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerDateMode_W(Self: TDateTimePicker; const T: TDTDateMode);
begin Self.DateMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerDateMode_R(Self: TDateTimePicker; var T: TDTDateMode);
begin T := Self.DateMode; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerDateFormat_W(Self: TDateTimePicker; const T: TDTDateFormat);
begin Self.DateFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerDateFormat_R(Self: TDateTimePicker; var T: TDTDateFormat);
begin T := Self.DateFormat; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerChecked_W(Self: TDateTimePicker; const T: Boolean);
begin Self.Checked := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerChecked_R(Self: TDateTimePicker; var T: Boolean);
begin T := Self.Checked; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerShowCheckbox_W(Self: TDateTimePicker; const T: Boolean);
begin Self.ShowCheckbox := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerShowCheckbox_R(Self: TDateTimePicker; var T: Boolean);
begin T := Self.ShowCheckbox; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerTime_W(Self: TDateTimePicker; const T: TTime);
begin Self.Time := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerTime_R(Self: TDateTimePicker; var T: TTime);
begin T := Self.Time; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerFormat_W(Self: TDateTimePicker; const T: String);
begin Self.Format := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerFormat_R(Self: TDateTimePicker; var T: String);
begin T := Self.Format; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerCalAlignment_W(Self: TDateTimePicker; const T: TDTCalAlignment);
begin Self.CalAlignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerCalAlignment_R(Self: TDateTimePicker; var T: TDTCalAlignment);
begin T := Self.CalAlignment; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerdatetime_W(Self: TDateTimePicker; const T: TDatetime);
begin Self.DateTime:= T; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerdatetime_R(Self: TDateTimePicker; var T: TDatetime);
begin T := Self.DateTime; end;

(*----------------------------------------------------------------------------*)
procedure TDateTimePickerDroppedDown_R(Self: TDateTimePicker; var T: Boolean);
begin T := Self.DroppedDown; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsTrailingTextColor_W(Self: TMonthCalColors; const T: TColor);
begin Self.TrailingTextColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsTrailingTextColor_R(Self: TMonthCalColors; var T: TColor);
begin T := Self.TrailingTextColor; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsMonthBackColor_W(Self: TMonthCalColors; const T: TColor);
begin Self.MonthBackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsMonthBackColor_R(Self: TMonthCalColors; var T: TColor);
begin T := Self.MonthBackColor; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsTitleTextColor_W(Self: TMonthCalColors; const T: TColor);
begin Self.TitleTextColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsTitleTextColor_R(Self: TMonthCalColors; var T: TColor);
begin T := Self.TitleTextColor; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsTitleBackColor_W(Self: TMonthCalColors; const T: TColor);
begin Self.TitleBackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsTitleBackColor_R(Self: TMonthCalColors; var T: TColor);
begin T := Self.TitleBackColor; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsTextColor_W(Self: TMonthCalColors; const T: TColor);
begin Self.TextColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsTextColor_R(Self: TMonthCalColors; var T: TColor);
begin T := Self.TextColor; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsBackColor_W(Self: TMonthCalColors; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TMonthCalColorsBackColor_R(Self: TMonthCalColors; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarOnChange_W(Self: TCoolBar; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarOnChange_R(Self: TCoolBar; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarVertical_W(Self: TCoolBar; const T: Boolean);
begin Self.Vertical := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarVertical_R(Self: TCoolBar; var T: Boolean);
begin T := Self.Vertical; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarShowText_W(Self: TCoolBar; const T: Boolean);
begin Self.ShowText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarShowText_R(Self: TCoolBar; var T: Boolean);
begin T := Self.ShowText; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarBitmap_W(Self: TCoolBar; const T: TBitmap);
begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarBitmap_R(Self: TCoolBar; var T: TBitmap);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarImages_W(Self: TCoolBar; const T: TCustomImageList);
begin Self.Images := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarImages_R(Self: TCoolBar; var T: TCustomImageList);
begin T := Self.Images; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarFixedOrder_W(Self: TCoolBar; const T: Boolean);
begin Self.FixedOrder := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarFixedOrder_R(Self: TCoolBar; var T: Boolean);
begin T := Self.FixedOrder; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarFixedSize_W(Self: TCoolBar; const T: Boolean);
begin Self.FixedSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarFixedSize_R(Self: TCoolBar; var T: Boolean);
begin T := Self.FixedSize; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarBands_W(Self: TCoolBar; const T: TCoolBands);
begin Self.Bands := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarBands_R(Self: TCoolBar; var T: TCoolBands);
begin T := Self.Bands; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarBandMaximize_W(Self: TCoolBar; const T: TCoolBandMaximize);
begin Self.BandMaximize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarBandMaximize_R(Self: TCoolBar; var T: TCoolBandMaximize);
begin T := Self.BandMaximize; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarBandBorderStyle_W(Self: TCoolBar; const T: TBorderStyle);
begin Self.BandBorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBarBandBorderStyle_R(Self: TCoolBar; var T: TBorderStyle);
begin T := Self.BandBorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandsItems_W(Self: TCoolBands; const T: TCoolBand; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandsItems_R(Self: TCoolBands; var T: TCoolBand; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandsCoolBar_R(Self: TCoolBands; var T: TCoolBar);
begin T := Self.CoolBar; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandWidth_W(Self: TCoolBand; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandWidth_R(Self: TCoolBand; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandVisible_W(Self: TCoolBand; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandVisible_R(Self: TCoolBand; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandText_W(Self: TCoolBand; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandText_R(Self: TCoolBand; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandParentBitmap_W(Self: TCoolBand; const T: Boolean);
begin Self.ParentBitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandParentBitmap_R(Self: TCoolBand; var T: Boolean);
begin T := Self.ParentBitmap; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandParentColor_W(Self: TCoolBand; const T: Boolean);
begin Self.ParentColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandParentColor_R(Self: TCoolBand; var T: Boolean);
begin T := Self.ParentColor; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandMinWidth_W(Self: TCoolBand; const T: Integer);
begin Self.MinWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandMinWidth_R(Self: TCoolBand; var T: Integer);
begin T := Self.MinWidth; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandMinHeight_W(Self: TCoolBand; const T: Integer);
begin Self.MinHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandMinHeight_R(Self: TCoolBand; var T: Integer);
begin T := Self.MinHeight; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandImageIndex_W(Self: TCoolBand; const T: TImageIndex);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandImageIndex_R(Self: TCoolBand; var T: TImageIndex);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandHorizontalOnly_W(Self: TCoolBand; const T: Boolean);
begin Self.HorizontalOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandHorizontalOnly_R(Self: TCoolBand; var T: Boolean);
begin T := Self.HorizontalOnly; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandFixedSize_W(Self: TCoolBand; const T: Boolean);
begin Self.FixedSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandFixedSize_R(Self: TCoolBand; var T: Boolean);
begin T := Self.FixedSize; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandFixedBackground_W(Self: TCoolBand; const T: Boolean);
begin Self.FixedBackground := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandFixedBackground_R(Self: TCoolBand; var T: Boolean);
begin T := Self.FixedBackground; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandControl_W(Self: TCoolBand; const T: TWinControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandControl_R(Self: TCoolBand; var T: TWinControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandColor_W(Self: TCoolBand; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandColor_R(Self: TCoolBand; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandBreak_W(Self: TCoolBand; const T: Boolean);
begin Self.Break := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandBreak_R(Self: TCoolBand; var T: Boolean);
begin T := Self.Break; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandBorderStyle_W(Self: TCoolBand; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandBorderStyle_R(Self: TCoolBand; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandBitmap_W(Self: TCoolBand; const T: TBitmap);
begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandBitmap_R(Self: TCoolBand; var T: TBitmap);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure TCoolBandHeight_R(Self: TCoolBand; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeReset_W(Self: TToolBar; const T: TNotifyEvent);
begin Self.OnCustomizeReset := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeReset_R(Self: TToolBar; var T: TNotifyEvent);
begin T := Self.OnCustomizeReset; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeNewButton_W(Self: TToolBar; const T: TTBNewButtonEvent);
begin Self.OnCustomizeNewButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeNewButton_R(Self: TToolBar; var T: TTBNewButtonEvent);
begin T := Self.OnCustomizeNewButton; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizing_W(Self: TToolBar; const T: TNotifyEvent);
begin Self.OnCustomizing := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizing_R(Self: TToolBar; var T: TNotifyEvent);
begin T := Self.OnCustomizing; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeDelete_W(Self: TToolBar; const T: TTBButtonEvent);
begin Self.OnCustomizeDelete := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeDelete_R(Self: TToolBar; var T: TTBButtonEvent);
begin T := Self.OnCustomizeDelete; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomized_W(Self: TToolBar; const T: TNotifyEvent);
begin Self.OnCustomized := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomized_R(Self: TToolBar; var T: TNotifyEvent);
begin T := Self.OnCustomized; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeCanDelete_W(Self: TToolBar; const T: TTBCustomizeQueryEvent);
begin Self.OnCustomizeCanDelete := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeCanDelete_R(Self: TToolBar; var T: TTBCustomizeQueryEvent);
begin T := Self.OnCustomizeCanDelete; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeCanInsert_W(Self: TToolBar; const T: TTBCustomizeQueryEvent);
begin Self.OnCustomizeCanInsert := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeCanInsert_R(Self: TToolBar; var T: TTBCustomizeQueryEvent);
begin T := Self.OnCustomizeCanInsert; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeAdded_W(Self: TToolBar; const T: TTBButtonEvent);
begin Self.OnCustomizeAdded := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomizeAdded_R(Self: TToolBar; var T: TTBButtonEvent);
begin T := Self.OnCustomizeAdded; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomDrawButton_W(Self: TToolBar; const T: TTBCustomDrawBtnEvent);
begin Self.OnCustomDrawButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomDrawButton_R(Self: TToolBar; var T: TTBCustomDrawBtnEvent);
begin T := Self.OnCustomDrawButton; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomDraw_W(Self: TToolBar; const T: TTBCustomDrawEvent);
begin Self.OnCustomDraw := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnCustomDraw_R(Self: TToolBar; var T: TTBCustomDrawEvent);
begin T := Self.OnCustomDraw; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnAdvancedCustomDrawButton_W(Self: TToolBar; const T: TTBAdvancedCustomDrawBtnEvent);
begin Self.OnAdvancedCustomDrawButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnAdvancedCustomDrawButton_R(Self: TToolBar; var T: TTBAdvancedCustomDrawBtnEvent);
begin T := Self.OnAdvancedCustomDrawButton; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnAdvancedCustomDraw_W(Self: TToolBar; const T: TTBAdvancedCustomDrawEvent);
begin Self.OnAdvancedCustomDraw := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarOnAdvancedCustomDraw_R(Self: TToolBar; var T: TTBAdvancedCustomDrawEvent);
begin T := Self.OnAdvancedCustomDraw; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarWrapable_W(Self: TToolBar; const T: Boolean);
begin Self.Wrapable := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarWrapable_R(Self: TToolBar; var T: Boolean);
begin T := Self.Wrapable; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarTransparent_W(Self: TToolBar; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarTransparent_R(Self: TToolBar; var T: Boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarAllowTextButtons_W(Self: TToolBar; const T: Boolean);
begin Self.AllowTextButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarAllowTextButtons_R(Self: TToolBar; var T: Boolean);
begin T := Self.AllowTextButtons; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarShowCaptions_W(Self: TToolBar; const T: Boolean);
begin Self.ShowCaptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarShowCaptions_R(Self: TToolBar; var T: Boolean);
begin T := Self.ShowCaptions; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarGradientDrawingOptions_W(Self: TToolBar; const T: TTBGradientDrawingOptions);
begin Self.GradientDrawingOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarGradientDrawingOptions_R(Self: TToolBar; var T: TTBGradientDrawingOptions);
begin T := Self.GradientDrawingOptions; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarGradientDirection_W(Self: TToolBar; const T: TGradientDirection);
begin Self.GradientDirection := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarGradientDirection_R(Self: TToolBar; var T: TGradientDirection);
begin T := Self.GradientDirection; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarMenu_W(Self: TToolBar; const T: TMainMenu);
begin Self.Menu := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarMenu_R(Self: TToolBar; var T: TMainMenu);
begin T := Self.Menu; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarList_W(Self: TToolBar; const T: Boolean);
begin Self.List := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarList_R(Self: TToolBar; var T: Boolean);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarIndent_W(Self: TToolBar; const T: Integer);
begin Self.Indent := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarIndent_R(Self: TToolBar; var T: Integer);
begin T := Self.Indent; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarImages_W(Self: TToolBar; const T: TCustomImageList);
begin Self.Images := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarImages_R(Self: TToolBar; var T: TCustomImageList);
begin T := Self.Images; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarHotTrackColor_W(Self: TToolBar; const T: TColor);
begin Self.HotTrackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarHotTrackColor_R(Self: TToolBar; var T: TColor);
begin T := Self.HotTrackColor; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarHotImages_W(Self: TToolBar; const T: TCustomImageList);
begin Self.HotImages := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarHotImages_R(Self: TToolBar; var T: TCustomImageList);
begin T := Self.HotImages; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarHideClippedButtons_W(Self: TToolBar; const T: Boolean);
begin Self.HideClippedButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarHideClippedButtons_R(Self: TToolBar; var T: Boolean);
begin T := Self.HideClippedButtons; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarGradientStartColor_W(Self: TToolBar; const T: TColor);
begin Self.GradientStartColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarGradientStartColor_R(Self: TToolBar; var T: TColor);
begin T := Self.GradientStartColor; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarGradientEndColor_W(Self: TToolBar; const T: TColor);
begin Self.GradientEndColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarGradientEndColor_R(Self: TToolBar; var T: TColor);
begin T := Self.GradientEndColor; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarFlat_W(Self: TToolBar; const T: Boolean);
begin Self.Flat := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarFlat_R(Self: TToolBar; var T: Boolean);
begin T := Self.Flat; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarDrawingStyle_W(Self: TToolBar; const T: TTBDrawingStyle);
begin Self.DrawingStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarDrawingStyle_R(Self: TToolBar; var T: TTBDrawingStyle);
begin T := Self.DrawingStyle; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarDisabledImages_W(Self: TToolBar; const T: TCustomImageList);
begin Self.DisabledImages := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarDisabledImages_R(Self: TToolBar; var T: TCustomImageList);
begin T := Self.DisabledImages; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarCustomizable_W(Self: TToolBar; const T: Boolean);
begin Self.Customizable := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarCustomizable_R(Self: TToolBar; var T: Boolean);
begin T := Self.Customizable; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarButtonWidth_W(Self: TToolBar; const T: Integer);
begin Self.ButtonWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarButtonWidth_R(Self: TToolBar; var T: Integer);
begin T := Self.ButtonWidth; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarButtonHeight_W(Self: TToolBar; const T: Integer);
begin Self.ButtonHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarButtonHeight_R(Self: TToolBar; var T: Integer);
begin T := Self.ButtonHeight; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarRowCount_R(Self: TToolBar; var T: Integer);
begin T := Self.RowCount; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarCustomizeValueName_W(Self: TToolBar; const T: string);
begin Self.CustomizeValueName := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarCustomizeValueName_R(Self: TToolBar; var T: string);
begin T := Self.CustomizeValueName; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarCustomizeKeyName_W(Self: TToolBar; const T: string);
begin Self.CustomizeKeyName := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarCustomizeKeyName_R(Self: TToolBar; var T: string);
begin T := Self.CustomizeKeyName; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarCanvas_R(Self: TToolBar; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarButtons_R(Self: TToolBar; var T: TToolButton; const t1: Integer);
begin T := Self.Buttons[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarButtonCount_R(Self: TToolBar; var T: Integer);
begin T := Self.ButtonCount; end;

(*----------------------------------------------------------------------------*)
procedure TToolBarEnumeratorCurrent_R(Self: TToolBarEnumerator; var T: TToolButton);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonStyle_W(Self: TToolButton; const T: TToolButtonStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonStyle_R(Self: TToolButton; var T: TToolButtonStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonWrap_W(Self: TToolButton; const T: Boolean);
begin Self.Wrap := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonWrap_R(Self: TToolButton; var T: Boolean);
begin T := Self.Wrap; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonMenuItem_W(Self: TToolButton; const T: TMenuItem);
begin Self.MenuItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonMenuItem_R(Self: TToolButton; var T: TMenuItem);
begin T := Self.MenuItem; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonMarked_W(Self: TToolButton; const T: Boolean);
begin Self.Marked := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonMarked_R(Self: TToolButton; var T: Boolean);
begin T := Self.Marked; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonIndeterminate_W(Self: TToolButton; const T: Boolean);
begin Self.Indeterminate := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonIndeterminate_R(Self: TToolButton; var T: Boolean);
begin T := Self.Indeterminate; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonImageIndex_W(Self: TToolButton; const T: TImageIndex);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonImageIndex_R(Self: TToolButton; var T: TImageIndex);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonGrouped_W(Self: TToolButton; const T: Boolean);
begin Self.Grouped := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonGrouped_R(Self: TToolButton; var T: Boolean);
begin T := Self.Grouped; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonEnableDropdown_W(Self: TToolButton; const T: Boolean);
begin Self.EnableDropdown := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonEnableDropdown_R(Self: TToolButton; var T: Boolean);
begin T := Self.EnableDropdown; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonDropdownMenu_W(Self: TToolButton; const T: TPopupMenu);
begin Self.DropdownMenu := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonDropdownMenu_R(Self: TToolButton; var T: TPopupMenu);
begin T := Self.DropdownMenu; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonDown_W(Self: TToolButton; const T: Boolean);
begin Self.Down := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonDown_R(Self: TToolButton; var T: Boolean);
begin T := Self.Down; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonAutoSize_W(Self: TToolButton; const T: Boolean);
begin Self.AutoSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonAutoSize_R(Self: TToolButton; var T: Boolean);
begin T := Self.AutoSize; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonAllowAllUp_W(Self: TToolButton; const T: Boolean);
begin Self.AllowAllUp := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonAllowAllUp_R(Self: TToolButton; var T: Boolean);
begin T := Self.AllowAllUp; end;

(*----------------------------------------------------------------------------*)
procedure TToolButtonIndex_R(Self: TToolButton; var T: Integer);
begin T := Self.Index; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateOnStop_W(Self: TAnimate; const T: TNotifyEvent);
begin Self.OnStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateOnStop_R(Self: TAnimate; var T: TNotifyEvent);
begin T := Self.OnStop; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateOnStart_W(Self: TAnimate; const T: TNotifyEvent);
begin Self.OnStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateOnStart_R(Self: TAnimate; var T: TNotifyEvent);
begin T := Self.OnStart; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateOnClose_W(Self: TAnimate; const T: TNotifyEvent);
begin Self.OnClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateOnClose_R(Self: TAnimate; var T: TNotifyEvent);
begin T := Self.OnClose; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateOnOpen_W(Self: TAnimate; const T: TNotifyEvent);
begin Self.OnOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateOnOpen_R(Self: TAnimate; var T: TNotifyEvent);
begin T := Self.OnOpen; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateTransparent_W(Self: TAnimate; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateTransparent_R(Self: TAnimate; var T: Boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateTimers_W(Self: TAnimate; const T: Boolean);
begin Self.Timers := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateTimers_R(Self: TAnimate; var T: Boolean);
begin T := Self.Timers; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateStopFrame_W(Self: TAnimate; const T: Smallint);
begin Self.StopFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateStopFrame_R(Self: TAnimate; var T: Smallint);
begin T := Self.StopFrame; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateStartFrame_W(Self: TAnimate; const T: Smallint);
begin Self.StartFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateStartFrame_R(Self: TAnimate; var T: Smallint);
begin T := Self.StartFrame; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateRepetitions_W(Self: TAnimate; const T: Integer);
begin Self.Repetitions := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateRepetitions_R(Self: TAnimate; var T: Integer);
begin T := Self.Repetitions; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateFileName_W(Self: TAnimate; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateFileName_R(Self: TAnimate; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateCommonAVI_W(Self: TAnimate; const T: TCommonAVI);
begin Self.CommonAVI := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateCommonAVI_R(Self: TAnimate; var T: TCommonAVI);
begin T := Self.CommonAVI; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateCenter_W(Self: TAnimate; const T: Boolean);
begin Self.Center := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateCenter_R(Self: TAnimate; var T: Boolean);
begin T := Self.Center; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateActive_W(Self: TAnimate; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateActive_R(Self: TAnimate; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateResName_W(Self: TAnimate; const T: string);
begin Self.ResName := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateResName_R(Self: TAnimate; var T: string);
begin T := Self.ResName; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateResId_W(Self: TAnimate; const T: Integer);
begin Self.ResId := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateResId_R(Self: TAnimate; var T: Integer);
begin T := Self.ResId; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateResHandle_W(Self: TAnimate; const T: THandle);
begin Self.ResHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateResHandle_R(Self: TAnimate; var T: THandle);
begin T := Self.ResHandle; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateOpen_W(Self: TAnimate; const T: Boolean);
begin Self.Open := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateOpen_R(Self: TAnimate; var T: Boolean);
begin T := Self.Open; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateFrameWidth_R(Self: TAnimate; var T: Integer);
begin T := Self.FrameWidth; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateFrameHeight_R(Self: TAnimate; var T: Integer);
begin T := Self.FrameHeight; end;

(*----------------------------------------------------------------------------*)
procedure TAnimateFrameCount_R(Self: TAnimate; var T: Integer);
begin T := Self.FrameCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewWorkAreas_R(Self: TCustomListView; var T: TWorkAreas);
begin T := Self.WorkAreas; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewBoundingRect_R(Self: TCustomListView; var T: TRect);
begin T := Self.BoundingRect; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewVisibleRowCount_R(Self: TCustomListView; var T: Integer);
begin T := Self.VisibleRowCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewViewOrigin_R(Self: TCustomListView; var T: TPoint);
begin T := Self.ViewOrigin; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewTopItem_R(Self: TCustomListView; var T: TListItem);
begin T := Self.TopItem; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewSelected_W(Self: TCustomListView; const T: TListItem);
begin Self.Selected := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewSelected_R(Self: TCustomListView; var T: TListItem);
begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewSelCount_R(Self: TCustomListView; var T: Integer);
begin T := Self.SelCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewRowSelect_W(Self: TCustomListView; const T: Boolean);
begin Self.RowSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewRowSelect_R(Self: TCustomListView; var T: Boolean);
begin T := Self.RowSelect; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewItemFocused_W(Self: TCustomListView; const T: TListItem);
begin Self.ItemFocused := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewItemFocused_R(Self: TCustomListView; var T: TListItem);
begin T := Self.ItemFocused; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewHotTrackStyles_W(Self: TCustomListView; const T: TListHotTrackStyles);
begin Self.HotTrackStyles := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewHotTrackStyles_R(Self: TCustomListView; var T: TListHotTrackStyles);
begin T := Self.HotTrackStyles; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewHotTrack_W(Self: TCustomListView; const T: Boolean);
begin Self.HotTrack := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewHotTrack_R(Self: TCustomListView; var T: Boolean);
begin T := Self.HotTrack; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewGridLines_W(Self: TCustomListView; const T: Boolean);
begin Self.GridLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewGridLines_R(Self: TCustomListView; var T: Boolean);
begin T := Self.GridLines; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewFullDrag_W(Self: TCustomListView; const T: Boolean);
begin Self.FullDrag := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewFullDrag_R(Self: TCustomListView; var T: Boolean);
begin T := Self.FullDrag; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewFlatScrollBars_W(Self: TCustomListView; const T: Boolean);
begin Self.FlatScrollBars := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewFlatScrollBars_R(Self: TCustomListView; var T: Boolean);
begin T := Self.FlatScrollBars; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewDropTarget_W(Self: TCustomListView; const T: TListItem);
begin Self.DropTarget := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewDropTarget_R(Self: TCustomListView; var T: TListItem);
begin T := Self.DropTarget; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewColumn_R(Self: TCustomListView; var T: TListColumn; const t1: Integer);
begin T := Self.Column[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewCheckboxes_W(Self: TCustomListView; const T: Boolean);
begin Self.Checkboxes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewCheckboxes_R(Self: TCustomListView; var T: Boolean);
begin T := Self.Checkboxes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListViewCanvas_R(Self: TCustomListView; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
Function TCustomListViewGetItemIndex1_P(Self: TCustomListView) : Integer;
Begin //Result := Self.GetItemIndex;
 END;

(*----------------------------------------------------------------------------*)
Function TCustomListViewGetItemIndex_P(Self: TCustomListView;  Value : TListItem) : Integer;
Begin //Result := Self.GetItemIndex(Value);
 END;


(*----------------------------------------------------------------------------*)
procedure TListViewParent_W(Self: TListView; const T: TWinControl);
begin Self.parent:= T; end;

(*----------------------------------------------------------------------------*)
procedure TListViewParent_R(Self: TListView; var T: TWinControl);
begin T:= Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TListViewItemIndex_W(Self: TListView; const T: integer);
begin Self.itemindex:= T; end;

(*----------------------------------------------------------------------------*)
procedure TListViewItemIndex_R(Self: TListView; var T: integer);
begin T:= Self.itemindex; end;

procedure TListViewSortType_W(Self: TListView; const T: TSortType);
begin Self.sorttype:= T; end;

(*----------------------------------------------------------------------------*)
procedure TListViewSorttype_R(Self: TListView; var T: Tsorttype);
begin T:= Self.sorttype; end;

(*----------------------------------------------------------------------------*)
procedure TIconOptionsWrapText_W(Self: TIconOptions; const T: Boolean);
begin Self.WrapText := T; end;

(*----------------------------------------------------------------------------*)
procedure TIconOptionsWrapText_R(Self: TIconOptions; var T: Boolean);
begin T := Self.WrapText; end;

(*----------------------------------------------------------------------------*)
procedure TIconOptionsAutoArrange_W(Self: TIconOptions; const T: Boolean);
begin Self.AutoArrange := T; end;

(*----------------------------------------------------------------------------*)
procedure TIconOptionsAutoArrange_R(Self: TIconOptions; var T: Boolean);
begin T := Self.AutoArrange; end;

(*----------------------------------------------------------------------------*)
procedure TIconOptionsArrangement_W(Self: TIconOptions; const T: TIconArrangement);
begin Self.Arrangement := T; end;

(*----------------------------------------------------------------------------*)
procedure TIconOptionsArrangement_R(Self: TIconOptions; var T: TIconArrangement);
begin T := Self.Arrangement; end;

(*----------------------------------------------------------------------------*)
procedure TWorkAreasItems_W(Self: TWorkAreas; const T: TWorkArea; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TWorkAreasItems_R(Self: TWorkAreas; var T: TWorkArea; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TWorkAreaColor_W(Self: TWorkArea; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TWorkAreaColor_R(Self: TWorkArea; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TWorkAreaRect_W(Self: TWorkArea; const T: TRect);
begin Self.Rect := T; end;

(*----------------------------------------------------------------------------*)
procedure TWorkAreaRect_R(Self: TWorkArea; var T: TRect);
begin T := Self.Rect; end;

(*----------------------------------------------------------------------------*)
procedure TListItemsOwner_R(Self: TListItems; var T: TCustomListView);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TListItemsItem_W(Self: TListItems; const T: TListItem; const t1: Integer);
begin Self.Item[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemsItem_R(Self: TListItems; var T: TListItem; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TListItemsHandle_R(Self: TListItems; var T: HWND);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TListItemsCount_W(Self: TListItems; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemsCount_R(Self: TListItems; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TListItemsEnumeratorCurrent_R(Self: TListItemsEnumerator; var T: TListItem);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TListItemTop_W(Self: TListItem; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemTop_R(Self: TListItem; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TListItemSubItemImages_W(Self: TListItem; const T: Integer; const t1: Integer);
begin Self.SubItemImages[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemSubItemImages_R(Self: TListItem; var T: Integer; const t1: Integer);
begin T := Self.SubItemImages[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TListItemSubItems_W(Self: TListItem; const T: TStrings);
begin Self.SubItems := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemSubItems_R(Self: TListItem; var T: TStrings);
begin T := Self.SubItems; end;

(*----------------------------------------------------------------------------*)
procedure TListItemStateIndex_W(Self: TListItem; const T: TImageIndex);
begin Self.StateIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemStateIndex_R(Self: TListItem; var T: TImageIndex);
begin T := Self.StateIndex; end;

(*----------------------------------------------------------------------------*)
procedure TListItemSelected_W(Self: TListItem; const T: Boolean);
begin Self.Selected := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemSelected_R(Self: TListItem; var T: Boolean);
begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure TListItemPosition_W(Self: TListItem; const T: TPoint);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemPosition_R(Self: TListItem; var T: TPoint);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TListItemOverlayIndex_W(Self: TListItem; const T: TImageIndex);
begin Self.OverlayIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemOverlayIndex_R(Self: TListItem; var T: TImageIndex);
begin T := Self.OverlayIndex; end;

(*----------------------------------------------------------------------------*)
procedure TListItemOwner_R(Self: TListItem; var T: TListItems);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TListItemListView_R(Self: TListItem; var T: TCustomListView);
begin T := Self.ListView; end;

(*----------------------------------------------------------------------------*)
procedure TListItemLeft_W(Self: TListItem; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemLeft_R(Self: TListItem; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TListItemIndex_R(Self: TListItem; var T: Integer);
begin T := Self.Index; end;

(*----------------------------------------------------------------------------*)
procedure TListItemIndent_W(Self: TListItem; const T: Integer);
begin Self.Indent := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemIndent_R(Self: TListItem; var T: Integer);
begin T := Self.Indent; end;

(*----------------------------------------------------------------------------*)
procedure TListItemImageIndex_W(Self: TListItem; const T: TImageIndex);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemImageIndex_R(Self: TListItem; var T: TImageIndex);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TListItemHandle_R(Self: TListItem; var T: HWND);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TListItemFocused_W(Self: TListItem; const T: Boolean);
begin Self.Focused := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemFocused_R(Self: TListItem; var T: Boolean);
begin T := Self.Focused; end;

(*----------------------------------------------------------------------------*)
procedure TListItemDropTarget_W(Self: TListItem; const T: Boolean);
begin Self.DropTarget := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemDropTarget_R(Self: TListItem; var T: Boolean);
begin T := Self.DropTarget; end;

(*----------------------------------------------------------------------------*)
procedure TListItemDeleting_R(Self: TListItem; var T: Boolean);
begin T := Self.Deleting; end;

(*----------------------------------------------------------------------------*)
procedure TListItemData_W(Self: TListItem; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemData_R(Self: TListItem; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TListItemCut_W(Self: TListItem; const T: Boolean);
begin Self.Cut := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemCut_R(Self: TListItem; var T: Boolean);
begin T := Self.Cut; end;

(*----------------------------------------------------------------------------*)
procedure TListItemChecked_W(Self: TListItem; const T: Boolean);
begin Self.Checked := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemChecked_R(Self: TListItem; var T: Boolean);
begin T := Self.Checked; end;

(*----------------------------------------------------------------------------*)
procedure TListItemCaption_W(Self: TListItem; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItemCaption_R(Self: TListItem; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnsItems_W(Self: TListColumns; const T: TListColumn; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnsItems_R(Self: TListColumns; var T: TListColumn; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnWidth_W(Self: TListColumn; const T: TWidth);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnWidth_R(Self: TListColumn; var T: TWidth);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnTag_W(Self: TListColumn; const T: Integer);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnTag_R(Self: TListColumn; var T: Integer);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnMinWidth_W(Self: TListColumn; const T: TWidth);
begin Self.MinWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnMinWidth_R(Self: TListColumn; var T: TWidth);
begin T := Self.MinWidth; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnMaxWidth_W(Self: TListColumn; const T: TWidth);
begin Self.MaxWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnMaxWidth_R(Self: TListColumn; var T: TWidth);
begin T := Self.MaxWidth; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnImageIndex_W(Self: TListColumn; const T: TImageIndex);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnImageIndex_R(Self: TListColumn; var T: TImageIndex);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnCaption_W(Self: TListColumn; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnCaption_R(Self: TListColumn; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnAutoSize_W(Self: TListColumn; const T: Boolean);
begin Self.AutoSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnAutoSize_R(Self: TListColumn; var T: Boolean);
begin T := Self.AutoSize; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnAlignment_W(Self: TListColumn; const T: TAlignment);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnAlignment_R(Self: TListColumn; var T: TAlignment);
begin T := Self.Alignment; end;

(*----------------------------------------------------------------------------*)
procedure TListColumnWidthType_R(Self: TListColumn; var T: TWidth);
begin T := Self.WidthType; end;

(*----------------------------------------------------------------------------*)
procedure TCustomRichEditParagraph_R(Self: TCustomRichEdit; var T: TParaAttributes);
begin T := Self.Paragraph; end;

(*----------------------------------------------------------------------------*)
procedure TCustomRichEditPageRect_W(Self: TCustomRichEdit; const T: TRect);
begin Self.PageRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomRichEditPageRect_R(Self: TCustomRichEdit; var T: TRect);
begin T := Self.PageRect; end;

(*----------------------------------------------------------------------------*)
procedure TCustomRichEditSelAttributes_W(Self: TCustomRichEdit; const T: TTextAttributes);
begin Self.SelAttributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomRichEditSelAttributes_R(Self: TCustomRichEdit; var T: TTextAttributes);
begin T := Self.SelAttributes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomRichEditDefAttributes_W(Self: TCustomRichEdit; const T: TTextAttributes);
begin Self.DefAttributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomRichEditDefAttributes_R(Self: TCustomRichEdit; var T: TTextAttributes);
begin T := Self.DefAttributes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomRichEditDefaultConverter_W(Self: TCustomRichEdit; const T: TConversionClass);
begin Self.DefaultConverter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomRichEditDefaultConverter_R(Self: TCustomRichEdit; var T: TConversionClass);
begin T := Self.DefaultConverter; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesTabCount_W(Self: TParaAttributes; const T: Integer);
begin Self.TabCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesTabCount_R(Self: TParaAttributes; var T: Integer);
begin T := Self.TabCount; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesTab_W(Self: TParaAttributes; const T: Longint; const t1: Byte);
begin Self.Tab[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesTab_R(Self: TParaAttributes; var T: Longint; const t1: Byte);
begin T := Self.Tab[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesRightIndent_W(Self: TParaAttributes; const T: Longint);
begin Self.RightIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesRightIndent_R(Self: TParaAttributes; var T: Longint);
begin T := Self.RightIndent; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesNumbering_W(Self: TParaAttributes; const T: TNumberingStyle);
begin Self.Numbering := T; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesNumbering_R(Self: TParaAttributes; var T: TNumberingStyle);
begin T := Self.Numbering; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesLeftIndent_W(Self: TParaAttributes; const T: Longint);
begin Self.LeftIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesLeftIndent_R(Self: TParaAttributes; var T: Longint);
begin T := Self.LeftIndent; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesFirstIndent_W(Self: TParaAttributes; const T: Longint);
begin Self.FirstIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesFirstIndent_R(Self: TParaAttributes; var T: Longint);
begin T := Self.FirstIndent; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesAlignment_W(Self: TParaAttributes; const T: TAlignment);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TParaAttributesAlignment_R(Self: TParaAttributes; var T: TAlignment);
begin T := Self.Alignment; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesHeight_W(Self: TTextAttributes; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesHeight_R(Self: TTextAttributes; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesStyle_W(Self: TTextAttributes; const T: TFontStyles);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesStyle_R(Self: TTextAttributes; var T: TFontStyles);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesSize_W(Self: TTextAttributes; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesSize_R(Self: TTextAttributes; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesPitch_W(Self: TTextAttributes; const T: TFontPitch);
begin Self.Pitch := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesPitch_R(Self: TTextAttributes; var T: TFontPitch);
begin T := Self.Pitch; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesName_W(Self: TTextAttributes; const T: TFontName);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesName_R(Self: TTextAttributes; var T: TFontName);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesConsistentAttributes_R(Self: TTextAttributes; var T: TConsistentAttributes);
begin T := Self.ConsistentAttributes; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesColor_W(Self: TTextAttributes; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesColor_R(Self: TTextAttributes; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesCharset_W(Self: TTextAttributes; const T: TFontCharset);
begin Self.Charset := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextAttributesCharset_R(Self: TTextAttributes; var T: TFontCharset);
begin T := Self.Charset; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarStep_W(Self: TProgressBar; const T: Integer);
begin Self.Step := T; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarStep_R(Self: TProgressBar; var T: Integer);
begin T := Self.Step; end;

type THackProgressBar = class(TControl);

(*----------------------------------------------------------------------------*)
procedure TProgressBarColor_W(Self: TProgressBar; const T: TColor);
begin THackProgressBar(Self).color:= T; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarColor_R(Self: TProgressBar; var T: TColor);
begin T:= THackProgressBar(Self).Color; end;


(*----------------------------------------------------------------------------*)
procedure TProgressBarSmooth_W(Self: TProgressBar; const T: Boolean);
begin Self.Smooth := T; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarSmooth_R(Self: TProgressBar; var T: Boolean);
begin T := Self.Smooth; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarPosition_W(Self: TProgressBar; const T: Integer);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarPosition_R(Self: TProgressBar; var T: Integer);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarOrientation_W(Self: TProgressBar; const T: TProgressBarOrientation);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarOrientation_R(Self: TProgressBar; var T: TProgressBarOrientation);
begin T := Self.Orientation; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarMax_W(Self: TProgressBar; const T: Integer);
begin Self.Max := T; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarMax_R(Self: TProgressBar; var T: Integer);
begin T := Self.Max; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarMin_W(Self: TProgressBar; const T: Integer);
begin Self.Min := T; end;

(*----------------------------------------------------------------------------*)
procedure TProgressBarMin_R(Self: TProgressBar; var T: Integer);
begin T := Self.Min; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarOnChange_W(Self: TTrackBar; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarOnChange_R(Self: TTrackBar; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarTickStyle_W(Self: TTrackBar; const T: TTickStyle);
begin Self.TickStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarTickStyle_R(Self: TTrackBar; var T: TTickStyle);
begin T := Self.TickStyle; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarTickMarks_W(Self: TTrackBar; const T: TTickMark);
begin Self.TickMarks := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarTickMarks_R(Self: TTrackBar; var T: TTickMark);
begin T := Self.TickMarks; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarThumbLength_W(Self: TTrackBar; const T: Integer);
begin Self.ThumbLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarThumbLength_R(Self: TTrackBar; var T: Integer);
begin T := Self.ThumbLength; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarShowSelRange_W(Self: TTrackBar; const T: Boolean);
begin Self.ShowSelRange := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarShowSelRange_R(Self: TTrackBar; var T: Boolean);
begin T := Self.ShowSelRange; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarSelStart_W(Self: TTrackBar; const T: Integer);
begin Self.SelStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarSelStart_R(Self: TTrackBar; var T: Integer);
begin T := Self.SelStart; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarSelEnd_W(Self: TTrackBar; const T: Integer);
begin Self.SelEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarSelEnd_R(Self: TTrackBar; var T: Integer);
begin T := Self.SelEnd; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarSliderVisible_W(Self: TTrackBar; const T: Boolean);
begin Self.SliderVisible := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarSliderVisible_R(Self: TTrackBar; var T: Boolean);
begin T := Self.SliderVisible; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarPositionToolTip_W(Self: TTrackBar; const T: TPositionToolTip);
begin Self.PositionToolTip := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarPositionToolTip_R(Self: TTrackBar; var T: TPositionToolTip);
begin T := Self.PositionToolTip; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarPosition_W(Self: TTrackBar; const T: Integer);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarPosition_R(Self: TTrackBar; var T: Integer);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarFrequency_W(Self: TTrackBar; const T: Integer);
begin Self.Frequency := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarFrequency_R(Self: TTrackBar; var T: Integer);
begin T := Self.Frequency; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarPageSize_W(Self: TTrackBar; const T: Integer);
begin Self.PageSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarPageSize_R(Self: TTrackBar; var T: Integer);
begin T := Self.PageSize; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarOrientation_W(Self: TTrackBar; const T: TTrackBarOrientation);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarOrientation_R(Self: TTrackBar; var T: TTrackBarOrientation);
begin T := Self.Orientation; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarMin_W(Self: TTrackBar; const T: Integer);
begin Self.Min := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarMin_R(Self: TTrackBar; var T: Integer);
begin T := Self.Min; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarMax_W(Self: TTrackBar; const T: Integer);
begin Self.Max := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarMax_R(Self: TTrackBar; var T: Integer);
begin T := Self.Max; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarLineSize_W(Self: TTrackBar; const T: Integer);
begin Self.LineSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TTrackBarLineSize_R(Self: TTrackBar; var T: Integer);
begin T := Self.LineSize; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewSelections_R(Self: TCustomTreeView; var T: TTreeNode; const t1: Integer);
begin T := Self.Selections[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewSelectionCount_R(Self: TCustomTreeView; var T: Cardinal);
begin T := Self.SelectionCount; end;

(*----------------------------------------------------------------------------*)
Procedure TCustomTreeViewSelect2_P(Self: TCustomTreeView;  Nodes : TList);
Begin Self.Select(Nodes); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTreeViewSelect1_P(Self: TCustomTreeView;  const Nodes : array of TTreeNode);
Begin Self.Select(Nodes); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTreeViewSelect_P(Self: TCustomTreeView;  Node : TTreeNode; ShiftState : TShiftState);
Begin Self.Select(Node, ShiftState); END;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewTopItem_W(Self: TCustomTreeView; const T: TTreeNode);
begin Self.TopItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewTopItem_R(Self: TCustomTreeView; var T: TTreeNode);
begin T := Self.TopItem; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewSelected_W(Self: TCustomTreeView; const T: TTreeNode);
begin Self.Selected := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewSelected_R(Self: TCustomTreeView; var T: TTreeNode);
begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewDropTarget_W(Self: TCustomTreeView; const T: TTreeNode);
begin Self.DropTarget := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewDropTarget_R(Self: TCustomTreeView; var T: TTreeNode);
begin T := Self.DropTarget; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTreeViewCanvas_R(Self: TCustomTreeView; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodesOwner_R(Self: TTreeNodes; var T: TCustomTreeView);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodesItem_R(Self: TTreeNodes; var T: TTreeNode; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodesHandle_R(Self: TTreeNodes; var T: HWND);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodesCount_R(Self: TTreeNodes; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodesEnumeratorCurrent_R(Self: TTreeNodesEnumerator; var T: TTreeNode);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeTreeView_R(Self: TTreeNode; var T: TCustomTreeView);
begin T := Self.TreeView; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeText_W(Self: TTreeNode; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeText_R(Self: TTreeNode; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
//procedure TTreeNodeOnChange_R(Self: TTreeView; var T: TTreeNode);
//begin T := Self.onchange; end;


(*----------------------------------------------------------------------------*)
procedure TTreeNodeStateIndex_W(Self: TTreeNode; const T: Integer);
begin Self.StateIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeStateIndex_R(Self: TTreeNode; var T: Integer);
begin T := Self.StateIndex; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeSelectedIndex_W(Self: TTreeNode; const T: Integer);
begin Self.SelectedIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeSelectedIndex_R(Self: TTreeNode; var T: Integer);
begin T := Self.SelectedIndex; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeParent_R(Self: TTreeNode; var T: TTreeNode);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeOwner_R(Self: TTreeNode; var T: TTreeNodes);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeOverlayIndex_W(Self: TTreeNode; const T: Integer);
begin Self.OverlayIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeOverlayIndex_R(Self: TTreeNode; var T: Integer);
begin T := Self.OverlayIndex; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeLevel_R(Self: TTreeNode; var T: Integer);
begin T := Self.Level; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeItemId_R(Self: TTreeNode; var T: HTreeItem);
begin T := Self.ItemId; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeItem_W(Self: TTreeNode; const T: TTreeNode; const t1: Integer);
begin Self.Item[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeItem_R(Self: TTreeNode; var T: TTreeNode; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeIsVisible_R(Self: TTreeNode; var T: Boolean);
begin T := Self.IsVisible; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeIndex_R(Self: TTreeNode; var T: Integer);
begin T := Self.Index; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeImageIndex_W(Self: TTreeNode; const T: TImageIndex);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeImageIndex_R(Self: TTreeNode; var T: TImageIndex);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeHasChildren_W(Self: TTreeNode; const T: Boolean);
begin Self.HasChildren := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeHasChildren_R(Self: TTreeNode; var T: Boolean);
begin T := Self.HasChildren; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeHandle_R(Self: TTreeNode; var T: HWND);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeExpanded_W(Self: TTreeNode; const T: Boolean);
begin Self.Expanded := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeExpanded_R(Self: TTreeNode; var T: Boolean);
begin T := Self.Expanded; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeSelected_W(Self: TTreeNode; const T: Boolean);
begin Self.Selected := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeSelected_R(Self: TTreeNode; var T: Boolean);
begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeDropTarget_W(Self: TTreeNode; const T: Boolean);
begin Self.DropTarget := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeDropTarget_R(Self: TTreeNode; var T: Boolean);
begin T := Self.DropTarget; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeFocused_W(Self: TTreeNode; const T: Boolean);
begin Self.Focused := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeFocused_R(Self: TTreeNode; var T: Boolean);
begin T := Self.Focused; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeDeleting_R(Self: TTreeNode; var T: Boolean);
begin T := Self.Deleting; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeData_W(Self: TTreeNode; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeData_R(Self: TTreeNode; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeCut_W(Self: TTreeNode; const T: Boolean);
begin Self.Cut := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeCut_R(Self: TTreeNode; var T: Boolean);
begin T := Self.Cut; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeCount_R(Self: TTreeNode; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TTreeNodeAbsoluteIndex_R(Self: TTreeNode; var T: Integer);
begin T := Self.AbsoluteIndex; end;

(*----------------------------------------------------------------------------*)
procedure THeaderControlOnSectionTrack_W(Self: THeaderControl; const T: TSectionTrackEvent);
begin Self.OnSectionTrack := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderControlOnSectionTrack_R(Self: THeaderControl; var T: TSectionTrackEvent);
begin T := Self.OnSectionTrack; end;

(*----------------------------------------------------------------------------*)
procedure THeaderControlOnSectionResize_W(Self: THeaderControl; const T: TSectionNotifyEvent);
begin Self.OnSectionResize := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderControlOnSectionResize_R(Self: THeaderControl; var T: TSectionNotifyEvent);
begin T := Self.OnSectionResize; end;

(*----------------------------------------------------------------------------*)
procedure THeaderControlOnSectionClick_W(Self: THeaderControl; const T: TSectionNotifyEvent);
begin Self.OnSectionClick := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderControlOnSectionClick_R(Self: THeaderControl; var T: TSectionNotifyEvent);
begin T := Self.OnSectionClick; end;

(*----------------------------------------------------------------------------*)
procedure THeaderControlOnDrawSection_W(Self: THeaderControl; const T: TDrawSectionEvent);
begin Self.OnDrawSection := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderControlOnDrawSection_R(Self: THeaderControl; var T: TDrawSectionEvent);
begin T := Self.OnDrawSection; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnSectionTrack_W(Self: TCustomHeaderControl; const T: TCustomSectionTrackEvent);
begin Self.OnSectionTrack := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnSectionTrack_R(Self: TCustomHeaderControl; var T: TCustomSectionTrackEvent);
begin T := Self.OnSectionTrack; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnSectionResize_W(Self: TCustomHeaderControl; const T: TCustomSectionNotifyEvent);
begin Self.OnSectionResize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnSectionResize_R(Self: TCustomHeaderControl; var T: TCustomSectionNotifyEvent);
begin T := Self.OnSectionResize; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnSectionEndDrag_W(Self: TCustomHeaderControl; const T: TNotifyEvent);
begin Self.OnSectionEndDrag := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnSectionEndDrag_R(Self: TCustomHeaderControl; var T: TNotifyEvent);
begin T := Self.OnSectionEndDrag; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnSectionDrag_W(Self: TCustomHeaderControl; const T: TSectionDragEvent);
begin Self.OnSectionDrag := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnSectionDrag_R(Self: TCustomHeaderControl; var T: TSectionDragEvent);
begin T := Self.OnSectionDrag; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnSectionClick_W(Self: TCustomHeaderControl; const T: TCustomSectionNotifyEvent);
begin Self.OnSectionClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnSectionClick_R(Self: TCustomHeaderControl; var T: TCustomSectionNotifyEvent);
begin T := Self.OnSectionClick; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnDrawSection_W(Self: TCustomHeaderControl; const T: TCustomDrawSectionEvent);
begin Self.OnDrawSection := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnDrawSection_R(Self: TCustomHeaderControl; var T: TCustomDrawSectionEvent);
begin T := Self.OnDrawSection; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnCreateSectionClass_W(Self: TCustomHeaderControl; const T: TCustomHCCreateSectionClassEvent);
begin Self.OnCreateSectionClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlOnCreateSectionClass_R(Self: TCustomHeaderControl; var T: TCustomHCCreateSectionClassEvent);
begin T := Self.OnCreateSectionClass; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlStyle_W(Self: TCustomHeaderControl; const T: THeaderStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlStyle_R(Self: TCustomHeaderControl; var T: THeaderStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlSections_W(Self: TCustomHeaderControl; const T: THeaderSections);
begin Self.Sections := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlSections_R(Self: TCustomHeaderControl; var T: THeaderSections);
begin T := Self.Sections; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlImages_W(Self: TCustomHeaderControl; const T: TCustomImageList);
begin Self.Images := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlImages_R(Self: TCustomHeaderControl; var T: TCustomImageList);
begin T := Self.Images; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlHotTrack_W(Self: TCustomHeaderControl; const T: Boolean);
begin Self.HotTrack := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlHotTrack_R(Self: TCustomHeaderControl; var T: Boolean);
begin T := Self.HotTrack; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlFullDrag_W(Self: TCustomHeaderControl; const T: Boolean);
begin Self.FullDrag := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlFullDrag_R(Self: TCustomHeaderControl; var T: Boolean);
begin T := Self.FullDrag; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlDragReorder_W(Self: TCustomHeaderControl; const T: Boolean);
begin Self.DragReorder := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlDragReorder_R(Self: TCustomHeaderControl; var T: Boolean);
begin T := Self.DragReorder; end;

(*----------------------------------------------------------------------------*)
procedure TCustomHeaderControlCanvas_R(Self: TCustomHeaderControl; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionsItems_W(Self: THeaderSections; const T: THeaderSection; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionsItems_R(Self: THeaderSections; var T: THeaderSection; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionWidth_W(Self: THeaderSection; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionWidth_R(Self: THeaderSection; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionText_W(Self: THeaderSection; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionText_R(Self: THeaderSection; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionStyle_W(Self: THeaderSection; const T: THeaderSectionStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionStyle_R(Self: THeaderSection; var T: THeaderSectionStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionParentBiDiMode_W(Self: THeaderSection; const T: Boolean);
begin Self.ParentBiDiMode := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionParentBiDiMode_R(Self: THeaderSection; var T: Boolean);
begin T := Self.ParentBiDiMode; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionMinWidth_W(Self: THeaderSection; const T: Integer);
begin Self.MinWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionMinWidth_R(Self: THeaderSection; var T: Integer);
begin T := Self.MinWidth; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionMaxWidth_W(Self: THeaderSection; const T: Integer);
begin Self.MaxWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionMaxWidth_R(Self: THeaderSection; var T: Integer);
begin T := Self.MaxWidth; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionImageIndex_W(Self: THeaderSection; const T: TImageIndex);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionImageIndex_R(Self: THeaderSection; var T: TImageIndex);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionBiDiMode_W(Self: THeaderSection; const T: TBiDiMode);
begin Self.BiDiMode := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionBiDiMode_R(Self: THeaderSection; var T: TBiDiMode);
begin T := Self.BiDiMode; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionAutoSize_W(Self: THeaderSection; const T: Boolean);
begin Self.AutoSize := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionAutoSize_R(Self: THeaderSection; var T: Boolean);
begin T := Self.AutoSize; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionAllowClick_W(Self: THeaderSection; const T: Boolean);
begin Self.AllowClick := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionAllowClick_R(Self: THeaderSection; var T: Boolean);
begin T := Self.AllowClick; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionAlignment_W(Self: THeaderSection; const T: TAlignment);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionAlignment_R(Self: THeaderSection; var T: TAlignment);
begin T := Self.Alignment; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionRight_R(Self: THeaderSection; var T: Integer);
begin T := Self.Right; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionLeft_R(Self: THeaderSection; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TStatusBarOnDrawPanel_W(Self: TStatusBar; const T: TDrawPanelEvent);
begin Self.OnDrawPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusBarOnDrawPanel_R(Self: TStatusBar; var T: TDrawPanelEvent);
begin T := Self.OnDrawPanel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnDrawPanel_W(Self: TCustomStatusBar; const T: TCustomDrawPanelEvent);
begin Self.OnDrawPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnDrawPanel_R(Self: TCustomStatusBar; var T: TCustomDrawPanelEvent);
begin T := Self.OnDrawPanel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnHint_W(Self: TCustomStatusBar; const T: TNotifyEvent);
begin Self.OnHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnHint_R(Self: TCustomStatusBar; var T: TNotifyEvent);
begin T := Self.OnHint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnCreatePanelClass_W(Self: TCustomStatusBar; const T: TSBCreatePanelClassEvent);
begin Self.OnCreatePanelClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnCreatePanelClass_R(Self: TCustomStatusBar; var T: TSBCreatePanelClassEvent);
begin T := Self.OnCreatePanelClass; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarUseSystemFont_W(Self: TCustomStatusBar; const T: Boolean);
begin Self.UseSystemFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarUseSystemFont_R(Self: TCustomStatusBar; var T: Boolean);
begin T := Self.UseSystemFont; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSizeGrip_W(Self: TCustomStatusBar; const T: Boolean);
begin Self.SizeGrip := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSizeGrip_R(Self: TCustomStatusBar; var T: Boolean);
begin T := Self.SizeGrip; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSimpleText_W(Self: TCustomStatusBar; const T: string);
begin Self.SimpleText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSimpleText_R(Self: TCustomStatusBar; var T: string);
begin T := Self.SimpleText; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSimplePanel_W(Self: TCustomStatusBar; const T: Boolean);
begin Self.SimplePanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSimplePanel_R(Self: TCustomStatusBar; var T: Boolean);
begin T := Self.SimplePanel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarPanels_W(Self: TCustomStatusBar; const T: TStatusPanels);
begin Self.Panels := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarPanels_R(Self: TCustomStatusBar; var T: TStatusPanels);
begin T := Self.Panels; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarAutoHint_W(Self: TCustomStatusBar; const T: Boolean);
begin Self.AutoHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarAutoHint_R(Self: TCustomStatusBar; var T: Boolean);
begin T := Self.AutoHint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarHideS_W(Self: TCustomStatusBar; const T: Boolean);
begin //Self.HideSelection:= T;
end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarHideS_R(Self: TCustomStatusBar; var T: Boolean);
begin //T := Self.HideSelection;
end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarCanvas_R(Self: TCustomStatusBar; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelsItems_W(Self: TStatusPanels; const T: TStatusPanel; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelsItems_R(Self: TStatusPanels; var T: TStatusPanel; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelWidth_W(Self: TStatusPanel; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelWidth_R(Self: TStatusPanel; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelText_W(Self: TStatusPanel; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelText_R(Self: TStatusPanel; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelStyle_W(Self: TStatusPanel; const T: TStatusPanelStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelStyle_R(Self: TStatusPanel; var T: TStatusPanelStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelParentBiDiMode_W(Self: TStatusPanel; const T: Boolean);
begin Self.ParentBiDiMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelParentBiDiMode_R(Self: TStatusPanel; var T: Boolean);
begin T := Self.ParentBiDiMode; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelBiDiMode_W(Self: TStatusPanel; const T: TBiDiMode);
begin Self.BiDiMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelBiDiMode_R(Self: TStatusPanel; var T: TBiDiMode);
begin T := Self.BiDiMode; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelBevel_W(Self: TStatusPanel; const T: TStatusPanelBevel);
begin Self.Bevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelBevel_R(Self: TStatusPanel; var T: TStatusPanelBevel);
begin T := Self.Bevel; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelAlignment_W(Self: TStatusPanel; const T: TAlignment);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelAlignment_R(Self: TStatusPanel; var T: TAlignment);
begin T := Self.Alignment; end;

(*----------------------------------------------------------------------------*)
procedure TPageControlActivePage_W(Self: TPageControl; const T: TTabSheet);
begin Self.ActivePage := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageControlActivePage_R(Self: TPageControl; var T: TTabSheet);
begin T := Self.ActivePage; end;

(*----------------------------------------------------------------------------*)
procedure TPageControlPages_R(Self: TPageControl; var T: TTabSheet; const t1: Integer);
begin T := Self.Pages[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPageControlPageCount_R(Self: TPageControl; var T: Integer);
begin T := Self.PageCount; end;

(*----------------------------------------------------------------------------*)
procedure TPageControlActivePageIndex_W(Self: TPageControl; const T: Integer);
begin Self.ActivePageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageControlActivePageIndex_R(Self: TPageControl; var T: Integer);
begin T := Self.ActivePageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetOnShow_W(Self: TTabSheet; const T: TNotifyEvent);
begin Self.OnShow := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetOnShow_R(Self: TTabSheet; var T: TNotifyEvent);
begin T := Self.OnShow; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetOnHide_W(Self: TTabSheet; const T: TNotifyEvent);
begin Self.OnHide := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetOnHide_R(Self: TTabSheet; var T: TNotifyEvent);
begin T := Self.OnHide; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetTabVisible_W(Self: TTabSheet; const T: Boolean);
begin Self.TabVisible := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetTabVisible_R(Self: TTabSheet; var T: Boolean);
begin T := Self.TabVisible; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetPageIndex_W(Self: TTabSheet; const T: Integer);
begin Self.PageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetPageIndex_R(Self: TTabSheet; var T: Integer);
begin T := Self.PageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetImageIndex_W(Self: TTabSheet; const T: TImageIndex);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetImageIndex_R(Self: TTabSheet; var T: TImageIndex);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetHighlighted_W(Self: TTabSheet; const T: Boolean);
begin Self.Highlighted := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetHighlighted_R(Self: TTabSheet; var T: Boolean);
begin T := Self.Highlighted; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetTabIndex_R(Self: TTabSheet; var T: Integer);
begin T := Self.TabIndex; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetPageControl_W(Self: TTabSheet; const T: TPageControl);
begin Self.PageControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabSheetPageControl_R(Self: TTabSheet; var T: TPageControl);
begin T := Self.PageControl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTabControlCanvas_R(Self: TCustomTabControl; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
{procedure TCustomTabControlTabstop_R(Self: TCustomTabControl; var T: TStrings);
begin T := Self.TabStop; end;}
(*----------------------------------------------------------------------------*)
{procedure TCustomTabControlTabs_R(Self: TCustomTabControl; var T: TStrings);
begin T := Self.TabStop; end;}

//{*----------------------------------------------------------------------------*)
procedure TTabControlTabs_R(Self: TTabControl; var T: TStrings);
begin T := Self.Tabs; end;
(*------------- --------------------------------------------------------------*)
procedure TTabControlTabs_W(Self: TTabControl; var T: TStrings);
begin Self.Tabs:= T; end;

(*----------------------------------------------------------------------------*)
procedure TListViewBorderStyle_W(Self: TListView; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TListViewBorderStyle_R(Self: TListView; var T: TBorderStyle);
begin T := Self.BorderStyle; end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_ComCtrls_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitCommonControl, 'InitCommonControl', cdRegister);
 S.RegisterDelphiFunction(@CheckCommonControl, 'CheckCommonControl', cdRegister);
 S.RegisterDelphiFunction(@GetComCtlVersion, 'GetComCtlVersion', cdRegister);
 S.RegisterDelphiFunction(@CheckToolMenuDropdown, 'CheckToolMenuDropdown', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComboBoxExActionLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComboBoxExActionLink) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComboBoxEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComboBoxEx) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomComboBoxEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomComboBoxEx) do begin
    RegisterConstructor(@TCustomComboBoxEx.Create, 'Create');
    RegisterMethod(@TCustomComboBoxEx.Destroy, 'Free');
    RegisterMethod(@TCustomComboBoxEx.Focused, 'Focused');

    RegisterPropertyHelper(@TCustomComboBoxExAutoCompleteOptions_R,@TCustomComboBoxExAutoCompleteOptions_W,'AutoCompleteOptions');
    RegisterPropertyHelper(@TCustomComboBoxExDropDownCount_R,@TCustomComboBoxExDropDownCount_W,'DropDownCount');
    RegisterPropertyHelper(@TCustomComboBoxExImages_R,@TCustomComboBoxExImages_W,'Images');
    RegisterPropertyHelper(@TCustomComboBoxExItemsEx_R,@TCustomComboBoxExItemsEx_W,'ItemsEx');
    RegisterPropertyHelper(@TCustomComboBoxExSelText_R,@TCustomComboBoxExSelText_W,'SelText');
    RegisterPropertyHelper(@TCustomComboBoxExStyle_R,@TCustomComboBoxExStyle_W,'Style');
    RegisterPropertyHelper(@TCustomComboBoxExStyleEx_R,@TCustomComboBoxExStyleEx_W,'StyleEx');
    RegisterPropertyHelper(@TCustomComboBoxExOnBeginEdit_R,@TCustomComboBoxExOnBeginEdit_W,'OnBeginEdit');
    RegisterPropertyHelper(@TCustomComboBoxExOnEndEdit_R,@TCustomComboBoxExOnEndEdit_W,'OnEndEdit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComboBoxExStrings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComboBoxExStrings) do begin
    RegisterConstructor(@TComboBoxExStrings.Create, 'Create');
    RegisterMethod(@TComboBoxExStrings.Destroy, 'Free');
    RegisterMethod(@TComboBoxExStrings.Add, 'Add');
    RegisterMethod(@TComboBoxExStrings.AddItem, 'AddItem');
    RegisterPropertyHelper(@TComboBoxExStringsSortType_R,@TComboBoxExStringsSortType_W,'SortType');
    RegisterPropertyHelper(@TComboBoxExStringsItemsEx_R,@TComboBoxExStringsItemsEx_W,'ItemsEx');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComboExItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComboExItems) do begin
    RegisterMethod(@TComboExItems.Add, 'Add');
    RegisterMethod(@TComboExItems.AddItem, 'AddItem');
    RegisterMethod(@TComboExItems.Insert, 'Insert');
    RegisterPropertyHelper(@TComboExItemsComboItems_R,nil,'ComboItems');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TBytesStreamBytes_R(Self: TBytesStream; var T: TBytes);
begin T := Self.Bytes; end;

(*----------------------------------------------------------------------------*)
Function TBytesStreamCreate_P(Self: TClass; CreateNewInstance: Boolean;  const ABytes : TBytes):TObject;
Begin Result := TBytesStream.Create(ABytes); END;




(*----------------------------------------------------------------------------*)
procedure RIRegister_TBytesStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBytesStream) do begin
    RegisterConstructor(@TBytesStreamCreate_P, 'Create');
    RegisterPropertyHelper(@TBytesStreamBytes_R,nil,'Bytes');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TComboExItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComboExItem) do begin
     RegisterMethod(@TComboExItem.Assign, 'Assign');
    RegisterPropertyHelper(@TComboExItemIndent_R,@TComboExItemIndent_W,'Indent');
    RegisterPropertyHelper(@TComboExItemOverlayImageIndex_R,@TComboExItemOverlayImageIndex_W,'OverlayImageIndex');
    RegisterPropertyHelper(@TComboExItemSelectedImageIndex_R,@TComboExItemSelectedImageIndex_W,'SelectedImageIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPageScroller(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPageScroller) do begin
    RegisterConstructor(@TPageScroller.Create, 'Create');
    RegisterMethod(@TPageScroller.GetButtonState, 'GetButtonState');
    RegisterPropertyHelper(@TPageScrollerAutoScroll_R,@TPageScrollerAutoScroll_W,'AutoScroll');
    RegisterPropertyHelper(@TPageScrollerButtonSize_R,@TPageScrollerButtonSize_W,'ButtonSize');
    RegisterPropertyHelper(@TPageScrollerControl_R,@TPageScrollerControl_W,'Control');
    RegisterPropertyHelper(@TPageScrollerDragScroll_R,@TPageScrollerDragScroll_W,'DragScroll');
    RegisterPropertyHelper(@TPageScrollerMargin_R,@TPageScrollerMargin_W,'Margin');
    RegisterPropertyHelper(@TPageScrollerOrientation_R,@TPageScrollerOrientation_W,'Orientation');
    RegisterPropertyHelper(@TPageScrollerPosition_R,@TPageScrollerPosition_W,'Position');
    RegisterPropertyHelper(@TPageScrollerOnScroll_R,@TPageScrollerOnScroll_W,'OnScroll');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDateTimePicker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDateTimePicker) do begin
    RegisterConstructor(@TDateTimePicker.Create, 'Create');
    RegisterPropertyHelper(@TDateTimePickerdatetime_R,@TDateTimePickerdatetime_W,'datetime');
    RegisterPropertyHelper(@TDateTimePickerDroppedDown_R,nil,'DroppedDown');
    RegisterPropertyHelper(@TDateTimePickerCalAlignment_R,@TDateTimePickerCalAlignment_W,'CalAlignment');
    RegisterPropertyHelper(@TDateTimePickerFormat_R,@TDateTimePickerFormat_W,'Format');
    RegisterPropertyHelper(@TDateTimePickerTime_R,@TDateTimePickerTime_W,'Time');
    RegisterPropertyHelper(@TDateTimePickerShowCheckbox_R,@TDateTimePickerShowCheckbox_W,'ShowCheckbox');
    RegisterPropertyHelper(@TDateTimePickerChecked_R,@TDateTimePickerChecked_W,'Checked');
    RegisterPropertyHelper(@TDateTimePickerDateFormat_R,@TDateTimePickerDateFormat_W,'DateFormat');
    RegisterPropertyHelper(@TDateTimePickerDateMode_R,@TDateTimePickerDateMode_W,'DateMode');
    RegisterPropertyHelper(@TDateTimePickerKind_R,@TDateTimePickerKind_W,'Kind');
    RegisterPropertyHelper(@TDateTimePickerParseInput_R,@TDateTimePickerParseInput_W,'ParseInput');
    RegisterPropertyHelper(@TDateTimePickerOnCloseUp_R,@TDateTimePickerOnCloseUp_W,'OnCloseUp');
    RegisterPropertyHelper(@TDateTimePickerOnChange_R,@TDateTimePickerOnChange_W,'OnChange');
    RegisterPropertyHelper(@TDateTimePickerOnDropDown_R,@TDateTimePickerOnDropDown_W,'OnDropDown');
    RegisterPropertyHelper(@TDateTimePickerOnUserInput_R,@TDateTimePickerOnUserInput_W,'OnUserInput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMonthCalendar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMonthCalendar) do begin
    RegisterConstructor(@TMonthCalendar.Create, 'Create');
   //RegisterMethod(@TMonthCalendar.Free, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCommonCalendar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommonCalendar) do begin
    RegisterConstructor(@TCommonCalendar.Create, 'Create');
   RegisterMethod(@TCommonCalendar.Destroy, 'Free');
     RegisterMethod(@TCommonCalendar.BoldDays, 'BoldDays');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMonthCalColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMonthCalColors) do begin
    RegisterConstructor(@TMonthCalColors.Create, 'Create');
    RegisterConstructor(@TMonthCalColors.Create, 'Create');
      RegisterPropertyHelper(@TMonthCalColorsBackColor_R,@TMonthCalColorsBackColor_W,'BackColor');
    RegisterPropertyHelper(@TMonthCalColorsTextColor_R,@TMonthCalColorsTextColor_W,'TextColor');
    RegisterPropertyHelper(@TMonthCalColorsTitleBackColor_R,@TMonthCalColorsTitleBackColor_W,'TitleBackColor');
    RegisterPropertyHelper(@TMonthCalColorsTitleTextColor_R,@TMonthCalColorsTitleTextColor_W,'TitleTextColor');
    RegisterPropertyHelper(@TMonthCalColorsMonthBackColor_R,@TMonthCalColorsMonthBackColor_W,'MonthBackColor');
    RegisterPropertyHelper(@TMonthCalColorsTrailingTextColor_R,@TMonthCalColorsTrailingTextColor_W,'TrailingTextColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCoolBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCoolBar) do begin
    RegisterConstructor(@TCoolbar.Create, 'Create');
    RegisterMethod(@TCoolBar.Destroy, 'Free');
    RegisterMethod(@TCoolBar.FlipChildren, 'FlipChildren');
    RegisterPropertyHelper(@TCoolBarBandBorderStyle_R,@TCoolBarBandBorderStyle_W,'BandBorderStyle');
    RegisterPropertyHelper(@TCoolBarBandMaximize_R,@TCoolBarBandMaximize_W,'BandMaximize');
    RegisterPropertyHelper(@TCoolBarBands_R,@TCoolBarBands_W,'Bands');
    RegisterPropertyHelper(@TCoolBarFixedSize_R,@TCoolBarFixedSize_W,'FixedSize');
    RegisterPropertyHelper(@TCoolBarFixedOrder_R,@TCoolBarFixedOrder_W,'FixedOrder');
    RegisterPropertyHelper(@TCoolBarImages_R,@TCoolBarImages_W,'Images');
    RegisterPropertyHelper(@TCoolBarBitmap_R,@TCoolBarBitmap_W,'Bitmap');
    RegisterPropertyHelper(@TCoolBarShowText_R,@TCoolBarShowText_W,'ShowText');
    RegisterPropertyHelper(@TCoolBarVertical_R,@TCoolBarVertical_W,'Vertical');
    RegisterPropertyHelper(@TCoolBarOnChange_R,@TCoolBarOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCoolBands(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCoolBands) do begin
    RegisterConstructor(@TCoolBands.Create, 'Create');
    RegisterMethod(@TCoolBands.Add, 'Add');
    RegisterMethod(@TCoolBands.FindBand, 'FindBand');
    RegisterPropertyHelper(@TCoolBandsCoolBar_R,nil,'CoolBar');
    RegisterPropertyHelper(@TCoolBandsItems_R,@TCoolBandsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCoolBand(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCoolBand) do begin
    RegisterConstructor(@TCoolBand.Create, 'Create');
       RegisterMethod(@TCoolBand.Assign, 'Assign');
     RegisterPropertyHelper(@TCoolBandHeight_R,nil,'Height');
    RegisterPropertyHelper(@TCoolBandBitmap_R,@TCoolBandBitmap_W,'Bitmap');
    RegisterPropertyHelper(@TCoolBandBorderStyle_R,@TCoolBandBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TCoolBandBreak_R,@TCoolBandBreak_W,'Break');
    RegisterPropertyHelper(@TCoolBandColor_R,@TCoolBandColor_W,'Color');
    RegisterPropertyHelper(@TCoolBandControl_R,@TCoolBandControl_W,'Control');
    RegisterPropertyHelper(@TCoolBandFixedBackground_R,@TCoolBandFixedBackground_W,'FixedBackground');
    RegisterPropertyHelper(@TCoolBandFixedSize_R,@TCoolBandFixedSize_W,'FixedSize');
    RegisterPropertyHelper(@TCoolBandHorizontalOnly_R,@TCoolBandHorizontalOnly_W,'HorizontalOnly');
    RegisterPropertyHelper(@TCoolBandImageIndex_R,@TCoolBandImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TCoolBandMinHeight_R,@TCoolBandMinHeight_W,'MinHeight');
    RegisterPropertyHelper(@TCoolBandMinWidth_R,@TCoolBandMinWidth_W,'MinWidth');
    RegisterPropertyHelper(@TCoolBandParentColor_R,@TCoolBandParentColor_W,'ParentColor');
    RegisterPropertyHelper(@TCoolBandParentBitmap_R,@TCoolBandParentBitmap_W,'ParentBitmap');
    RegisterPropertyHelper(@TCoolBandText_R,@TCoolBandText_W,'Text');
    RegisterPropertyHelper(@TCoolBandVisible_R,@TCoolBandVisible_W,'Visible');
    RegisterPropertyHelper(@TCoolBandWidth_R,@TCoolBandWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TToolBarDockObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TToolBarDockObject) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TToolBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TToolBar) do begin
     RegisterConstructor(@TToolbar.Create, 'Create');
    RegisterMethod(@TToolBar.Destroy, 'Free');
    RegisterMethod(@TToolBar.FlipChildren, 'FlipChildren');
     RegisterMethod(@TToolBar.GetEnumerator, 'GetEnumerator');
    RegisterVirtualMethod(@TToolBar.TrackMenu, 'TrackMenu');
    RegisterPropertyHelper(@TToolBarButtonCount_R,nil,'ButtonCount');
    RegisterPropertyHelper(@TToolBarButtons_R,nil,'Buttons');
    RegisterPropertyHelper(@TToolBarCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TToolBarCustomizeKeyName_R,@TToolBarCustomizeKeyName_W,'CustomizeKeyName');
    RegisterPropertyHelper(@TToolBarCustomizeValueName_R,@TToolBarCustomizeValueName_W,'CustomizeValueName');
    RegisterPropertyHelper(@TToolBarRowCount_R,nil,'RowCount');
    RegisterPropertyHelper(@TToolBarButtonHeight_R,@TToolBarButtonHeight_W,'ButtonHeight');
    RegisterPropertyHelper(@TToolBarButtonWidth_R,@TToolBarButtonWidth_W,'ButtonWidth');
    RegisterPropertyHelper(@TToolBarCustomizable_R,@TToolBarCustomizable_W,'Customizable');
    RegisterPropertyHelper(@TToolBarDisabledImages_R,@TToolBarDisabledImages_W,'DisabledImages');
    RegisterPropertyHelper(@TToolBarDrawingStyle_R,@TToolBarDrawingStyle_W,'DrawingStyle');
    RegisterPropertyHelper(@TToolBarFlat_R,@TToolBarFlat_W,'Flat');
    RegisterPropertyHelper(@TToolBarGradientEndColor_R,@TToolBarGradientEndColor_W,'GradientEndColor');
    RegisterPropertyHelper(@TToolBarGradientStartColor_R,@TToolBarGradientStartColor_W,'GradientStartColor');
    RegisterPropertyHelper(@TToolBarHideClippedButtons_R,@TToolBarHideClippedButtons_W,'HideClippedButtons');
    RegisterPropertyHelper(@TToolBarHotImages_R,@TToolBarHotImages_W,'HotImages');
    RegisterPropertyHelper(@TToolBarHotTrackColor_R,@TToolBarHotTrackColor_W,'HotTrackColor');
    RegisterPropertyHelper(@TToolBarImages_R,@TToolBarImages_W,'Images');
    RegisterPropertyHelper(@TToolBarIndent_R,@TToolBarIndent_W,'Indent');
    RegisterPropertyHelper(@TToolBarList_R,@TToolBarList_W,'List');
    RegisterPropertyHelper(@TToolBarMenu_R,@TToolBarMenu_W,'Menu');
    RegisterPropertyHelper(@TToolBarGradientDirection_R,@TToolBarGradientDirection_W,'GradientDirection');
    RegisterPropertyHelper(@TToolBarGradientDrawingOptions_R,@TToolBarGradientDrawingOptions_W,'GradientDrawingOptions');
    RegisterPropertyHelper(@TToolBarShowCaptions_R,@TToolBarShowCaptions_W,'ShowCaptions');
    RegisterPropertyHelper(@TToolBarAllowTextButtons_R,@TToolBarAllowTextButtons_W,'AllowTextButtons');
    RegisterPropertyHelper(@TToolBarTransparent_R,@TToolBarTransparent_W,'Transparent');
    RegisterPropertyHelper(@TToolBarWrapable_R,@TToolBarWrapable_W,'Wrapable');
    RegisterPropertyHelper(@TToolBarOnAdvancedCustomDraw_R,@TToolBarOnAdvancedCustomDraw_W,'OnAdvancedCustomDraw');
    RegisterPropertyHelper(@TToolBarOnAdvancedCustomDrawButton_R,@TToolBarOnAdvancedCustomDrawButton_W,'OnAdvancedCustomDrawButton');
    RegisterPropertyHelper(@TToolBarOnCustomDraw_R,@TToolBarOnCustomDraw_W,'OnCustomDraw');
    RegisterPropertyHelper(@TToolBarOnCustomDrawButton_R,@TToolBarOnCustomDrawButton_W,'OnCustomDrawButton');
    RegisterPropertyHelper(@TToolBarOnCustomizeAdded_R,@TToolBarOnCustomizeAdded_W,'OnCustomizeAdded');
    RegisterPropertyHelper(@TToolBarOnCustomizeCanInsert_R,@TToolBarOnCustomizeCanInsert_W,'OnCustomizeCanInsert');
    RegisterPropertyHelper(@TToolBarOnCustomizeCanDelete_R,@TToolBarOnCustomizeCanDelete_W,'OnCustomizeCanDelete');
    RegisterPropertyHelper(@TToolBarOnCustomized_R,@TToolBarOnCustomized_W,'OnCustomized');
    RegisterPropertyHelper(@TToolBarOnCustomizeDelete_R,@TToolBarOnCustomizeDelete_W,'OnCustomizeDelete');
    RegisterPropertyHelper(@TToolBarOnCustomizing_R,@TToolBarOnCustomizing_W,'OnCustomizing');
    RegisterPropertyHelper(@TToolBarOnCustomizeNewButton_R,@TToolBarOnCustomizeNewButton_W,'OnCustomizeNewButton');
    RegisterPropertyHelper(@TToolBarOnCustomizeReset_R,@TToolBarOnCustomizeReset_W,'OnCustomizeReset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TToolBarEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TToolBarEnumerator) do begin
    RegisterConstructor(@TToolBarEnumerator.Create, 'Create');
    RegisterMethod(@TToolBarEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TToolBarEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TToolBarEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TToolButton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TToolButton) do begin
    RegisterConstructor(@TToolButton.Create, 'Create');
     RegisterMethod(@TToolButton.SetBounds, 'SetBounds');
       RegisterVirtualMethod(@TToolButton.CheckMenuDropdown, 'CheckMenuDropdown');
    RegisterPropertyHelper(@TToolButtonIndex_R,nil,'Index');
    RegisterPropertyHelper(@TToolButtonAllowAllUp_R,@TToolButtonAllowAllUp_W,'AllowAllUp');
    RegisterPropertyHelper(@TToolButtonAutoSize_R,@TToolButtonAutoSize_W,'AutoSize');
    RegisterPropertyHelper(@TToolButtonDown_R,@TToolButtonDown_W,'Down');
    RegisterPropertyHelper(@TToolButtonDropdownMenu_R,@TToolButtonDropdownMenu_W,'DropdownMenu');
    RegisterPropertyHelper(@TToolButtonEnableDropdown_R,@TToolButtonEnableDropdown_W,'EnableDropdown');
    RegisterPropertyHelper(@TToolButtonGrouped_R,@TToolButtonGrouped_W,'Grouped');
    RegisterPropertyHelper(@TToolButtonImageIndex_R,@TToolButtonImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TToolButtonIndeterminate_R,@TToolButtonIndeterminate_W,'Indeterminate');
    RegisterPropertyHelper(@TToolButtonMarked_R,@TToolButtonMarked_W,'Marked');
    RegisterPropertyHelper(@TToolButtonMenuItem_R,@TToolButtonMenuItem_W,'MenuItem');
    RegisterPropertyHelper(@TToolButtonWrap_R,@TToolButtonWrap_W,'Wrap');
    RegisterPropertyHelper(@TToolButtonStyle_R,@TToolButtonStyle_W,'Style');
		RegisterEventPropertyHelper(@TITEMONCLICK_R,@TITEMONCLICK_W,'ONCLICK');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TToolButtonActionLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TToolButtonActionLink) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAnimate(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAnimate) do begin
    RegisterPropertyHelper(@TAnimateFrameCount_R,nil,'FrameCount');
    RegisterPropertyHelper(@TAnimateFrameHeight_R,nil,'FrameHeight');
    RegisterPropertyHelper(@TAnimateFrameWidth_R,nil,'FrameWidth');
    RegisterPropertyHelper(@TAnimateOpen_R,@TAnimateOpen_W,'Open');
    RegisterConstructor(@TAnimate.Create, 'Create');
     RegisterMethod(@TAnimate.Play, 'Play');
    RegisterMethod(@TAnimate.Reset, 'Reset');
    RegisterMethod(@TAnimate.Seek, 'Seek');
    RegisterMethod(@TAnimate.Stop, 'Stop');
    RegisterPropertyHelper(@TAnimateResHandle_R,@TAnimateResHandle_W,'ResHandle');
    RegisterPropertyHelper(@TAnimateResId_R,@TAnimateResId_W,'ResId');
    RegisterPropertyHelper(@TAnimateResName_R,@TAnimateResName_W,'ResName');
    RegisterPropertyHelper(@TAnimateActive_R,@TAnimateActive_W,'Active');
    RegisterPropertyHelper(@TAnimateCenter_R,@TAnimateCenter_W,'Center');
    RegisterPropertyHelper(@TAnimateCommonAVI_R,@TAnimateCommonAVI_W,'CommonAVI');
    RegisterPropertyHelper(@TAnimateFileName_R,@TAnimateFileName_W,'FileName');
    RegisterPropertyHelper(@TAnimateRepetitions_R,@TAnimateRepetitions_W,'Repetitions');
    RegisterPropertyHelper(@TAnimateStartFrame_R,@TAnimateStartFrame_W,'StartFrame');
    RegisterPropertyHelper(@TAnimateStopFrame_R,@TAnimateStopFrame_W,'StopFrame');
    RegisterPropertyHelper(@TAnimateTimers_R,@TAnimateTimers_W,'Timers');
    RegisterPropertyHelper(@TAnimateTransparent_R,@TAnimateTransparent_W,'Transparent');
    RegisterPropertyHelper(@TAnimateOnOpen_R,@TAnimateOnOpen_W,'OnOpen');
    RegisterPropertyHelper(@TAnimateOnClose_R,@TAnimateOnClose_W,'OnClose');
    RegisterPropertyHelper(@TAnimateOnStart_R,@TAnimateOnStart_W,'OnStart');
    RegisterPropertyHelper(@TAnimateOnStop_R,@TAnimateOnStop_W,'OnStop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListViewActionLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListViewActionLink) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListView) do begin
   // RegisterConstructor(@TListView.Create, 'Create');
   // RegisterMethod(@TListView.Free, 'Free');
    //RegisterMethod(@TListView.SetBounds, 'SetBounds');
    RegisterPropertyHelper(@TlistviewBorderStyle_R,@TlistviewBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TListViewSortType_R,@TListViewSortType_W,'SortType');
    RegisterPropertyHelper(@TListViewParent_R,@TListViewParent_W,'Parent');
    RegisterPropertyHelper(@TListViewItemIndex_R,@TListViewItemIndex_W,'ItemIndex');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomListView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomListView) do begin
    RegisterConstructor(@TCustomListView.Create, 'Create');
    RegisterMethod(@TCustomListView.Destroy, 'Free');
    RegisterMethod(@TCustomListView.SetBounds, 'SetBounds');
    RegisterMethod(@TCustomListView.AddItem, 'AddItem');
  RegisterMethod(@TCustomListView.Clear, 'Clear');
  RegisterMethod(@TCustomListView.ClearSelection, 'ClearSelection');
  RegisterMethod(@TCustomListView.CopySelection, 'CopySelection');
  RegisterMethod(@TCustomListView.DeleteSelected, 'DeleteSelected');
   RegisterMethod(@TCustomListView.AlphaSort, 'AlphaSort');
    RegisterMethod(@TCustomListView.Arrange, 'Arrange');
    RegisterMethod(@TCustomListView.FindCaption, 'FindCaption');
    RegisterMethod(@TCustomListView.FindData, 'FindData');
    RegisterMethod(@TCustomListView.GetHitTestInfoAt, 'GetHitTestInfoAt');
    RegisterMethod(@TCustomListView.GetItemAt, 'GetItemAt');
    RegisterMethod(@TCustomListView.GetNearestItem, 'GetNearestItem');
    RegisterMethod(@TCustomListView.GetNextItem, 'GetNextItem');
    RegisterMethod(@TCustomListView.GetSearchString, 'GetSearchString');
    RegisterMethod(@TCustomListView.IsEditing, 'IsEditing');
    RegisterMethod(@TCustomListView.Scroll, 'Scroll');
    RegisterMethod(@TCustomListView.AddItem, 'AddItem');
    RegisterMethod(@TCustomListView.Clear, 'Clear');
    RegisterMethod(@TCustomListView.ClearSelection, 'ClearSelection');
    RegisterMethod(@TCustomListView.CopySelection, 'CopySelection');
    RegisterMethod(@TCustomListView.DeleteSelected, 'DeleteSelected');
    RegisterMethod(@TCustomListView.SelectAll, 'SelectAll');
    RegisterPropertyHelper(@TCustomListViewCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TCustomListViewCheckboxes_R,@TCustomListViewCheckboxes_W,'Checkboxes');
    RegisterPropertyHelper(@TCustomListViewColumn_R,nil,'Column');
    RegisterPropertyHelper(@TCustomListViewDropTarget_R,@TCustomListViewDropTarget_W,'DropTarget');
    RegisterPropertyHelper(@TCustomListViewFlatScrollBars_R,@TCustomListViewFlatScrollBars_W,'FlatScrollBars');
    RegisterPropertyHelper(@TCustomListViewFullDrag_R,@TCustomListViewFullDrag_W,'FullDrag');
    RegisterPropertyHelper(@TCustomListViewGridLines_R,@TCustomListViewGridLines_W,'GridLines');
    RegisterPropertyHelper(@TCustomListViewHotTrack_R,@TCustomListViewHotTrack_W,'HotTrack');
    RegisterPropertyHelper(@TCustomListViewHotTrackStyles_R,@TCustomListViewHotTrackStyles_W,'HotTrackStyles');
    RegisterPropertyHelper(@TCustomListViewItemFocused_R,@TCustomListViewItemFocused_W,'ItemFocused');
    RegisterPropertyHelper(@TCustomListViewRowSelect_R,@TCustomListViewRowSelect_W,'RowSelect');
    RegisterPropertyHelper(@TCustomListViewSelCount_R,nil,'SelCount');
    RegisterPropertyHelper(@TCustomListViewSelected_R,@TCustomListViewSelected_W,'Selected');
    RegisterMethod(@TCustomListView.CustomSort, 'CustomSort');
    RegisterMethod(@TCustomListView.StringWidth, 'StringWidth');
    RegisterMethod(@TCustomListView.UpdateItems, 'UpdateItems');
    RegisterPropertyHelper(@TCustomListViewTopItem_R,nil,'TopItem');
    RegisterPropertyHelper(@TCustomListViewViewOrigin_R,nil,'ViewOrigin');
    RegisterPropertyHelper(@TCustomListViewVisibleRowCount_R,nil,'VisibleRowCount');
    RegisterPropertyHelper(@TCustomListViewBoundingRect_R,nil,'BoundingRect');
    RegisterPropertyHelper(@TCustomListViewWorkAreas_R,nil,'WorkAreas');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIconOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIconOptions) do begin
    RegisterConstructor(@TIconOptions.Create, 'Create');
    RegisterPropertyHelper(@TIconOptionsArrangement_R,@TIconOptionsArrangement_W,'Arrangement');
    RegisterPropertyHelper(@TIconOptionsAutoArrange_R,@TIconOptionsAutoArrange_W,'AutoArrange');
    RegisterPropertyHelper(@TIconOptionsWrapText_R,@TIconOptionsWrapText_W,'WrapText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWorkAreas(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWorkAreas) do begin
    RegisterMethod(@TWorkAreas.Add, 'Add');
    RegisterMethod(@TWorkAreas.Delete, 'Delete');
    RegisterMethod(@TWorkAreas.Insert, 'Insert');
    RegisterPropertyHelper(@TWorkAreasItems_R,@TWorkAreasItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWorkArea(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWorkArea) do begin
    RegisterPropertyHelper(@TWorkAreaRect_R,@TWorkAreaRect_W,'Rect');
    RegisterPropertyHelper(@TWorkAreaColor_R,@TWorkAreaColor_W,'Color');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListItems) do begin
    RegisterConstructor(@TListItems.Create, 'Create');
    RegisterMethod(@TListItems.Destroy, 'Free');
     RegisterMethod(@TListItems.Assign, 'Assign');
    RegisterMethod(@TListItems.Add, 'Add');
    RegisterMethod(@TListItems.AddItem, 'AddItem');
    RegisterMethod(@TListItems.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TListItems.Clear, 'Clear');
    RegisterMethod(@TListItems.Delete, 'Delete');
    RegisterMethod(@TListItems.EndUpdate, 'EndUpdate');
    RegisterMethod(@TListItems.GetEnumerator, 'GetEnumerator');
    RegisterMethod(@TListItems.IndexOf, 'IndexOf');
    RegisterMethod(@TListItems.Insert, 'Insert');
    RegisterPropertyHelper(@TListItemsCount_R,@TListItemsCount_W,'Count');
    RegisterPropertyHelper(@TListItemsHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TListItemsItem_R,@TListItemsItem_W,'Item');
    RegisterPropertyHelper(@TListItemsOwner_R,nil,'Owner');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListItemsEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListItemsEnumerator) do begin
    RegisterConstructor(@TListItemsEnumerator.Create, 'Create');
    RegisterMethod(@TListItemsEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TListItemsEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TListItemsEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListItem) do begin
    RegisterConstructor(@TListItem.Create, 'Create');
    RegisterMethod(@TListItem.Assign, 'Assign');
    RegisterMethod(@TListItem.Destroy, 'Free');
     RegisterMethod(@TListItem.CancelEdit, 'CancelEdit');
    RegisterMethod(@TListItem.Delete, 'Delete');
    RegisterMethod(@TListItem.DisplayRect, 'DisplayRect');
    RegisterMethod(@TListItem.EditCaption, 'EditCaption');
    RegisterMethod(@TListItem.GetPosition, 'GetPosition');
    RegisterMethod(@TListItem.MakeVisible, 'MakeVisible');
    RegisterMethod(@TListItem.Update, 'Update');
    RegisterMethod(@TListItem.SetPosition, 'SetPosition');
    RegisterMethod(@TListItem.WorkArea, 'WorkArea');
    RegisterPropertyHelper(@TListItemCaption_R,@TListItemCaption_W,'Caption');
    RegisterPropertyHelper(@TListItemChecked_R,@TListItemChecked_W,'Checked');
    RegisterPropertyHelper(@TListItemCut_R,@TListItemCut_W,'Cut');
    RegisterPropertyHelper(@TListItemData_R,@TListItemData_W,'Data');
    RegisterPropertyHelper(@TListItemDeleting_R,nil,'Deleting');
    RegisterPropertyHelper(@TListItemDropTarget_R,@TListItemDropTarget_W,'DropTarget');
    RegisterPropertyHelper(@TListItemFocused_R,@TListItemFocused_W,'Focused');
    RegisterPropertyHelper(@TListItemHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TListItemImageIndex_R,@TListItemImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TListItemIndent_R,@TListItemIndent_W,'Indent');
    RegisterPropertyHelper(@TListItemIndex_R,nil,'Index');
    RegisterPropertyHelper(@TListItemLeft_R,@TListItemLeft_W,'Left');
    RegisterPropertyHelper(@TListItemListView_R,nil,'ListView');
    RegisterPropertyHelper(@TListItemOwner_R,nil,'Owner');
    RegisterPropertyHelper(@TListItemOverlayIndex_R,@TListItemOverlayIndex_W,'OverlayIndex');
    RegisterPropertyHelper(@TListItemPosition_R,@TListItemPosition_W,'Position');
    RegisterPropertyHelper(@TListItemSelected_R,@TListItemSelected_W,'Selected');
    RegisterPropertyHelper(@TListItemStateIndex_R,@TListItemStateIndex_W,'StateIndex');
    RegisterPropertyHelper(@TListItemSubItems_R,@TListItemSubItems_W,'SubItems');
    RegisterPropertyHelper(@TListItemSubItemImages_R,@TListItemSubItemImages_W,'SubItemImages');
    RegisterPropertyHelper(@TListItemTop_R,@TListItemTop_W,'Top');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListColumns(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListColumns) do begin
    RegisterConstructor(@TListColumns.Create, 'Create');
       RegisterMethod(@TListColumns.Destroy, 'Free');
    RegisterMethod(@TListColumns.Add, 'Add');
    RegisterMethod(@TListColumns.Owner, 'Owner');
    RegisterPropertyHelper(@TListColumnsItems_R,@TListColumnsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListColumn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListColumn) do begin
     RegisterConstructor(@TListColumn.Create, 'Create');
      RegisterMethod(@TListColumn.Assign, 'Assign');
       RegisterMethod(@TListColumn.Destroy, 'Free');
     RegisterPropertyHelper(@TListColumnWidthType_R,nil,'WidthType');
    RegisterPropertyHelper(@TListColumnAlignment_R,@TListColumnAlignment_W,'Alignment');
    RegisterPropertyHelper(@TListColumnAutoSize_R,@TListColumnAutoSize_W,'AutoSize');
    RegisterPropertyHelper(@TListColumnCaption_R,@TListColumnCaption_W,'Caption');
    RegisterPropertyHelper(@TListColumnImageIndex_R,@TListColumnImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TListColumnMaxWidth_R,@TListColumnMaxWidth_W,'MaxWidth');
    RegisterPropertyHelper(@TListColumnMinWidth_R,@TListColumnMinWidth_W,'MinWidth');
    RegisterPropertyHelper(@TListColumnTag_R,@TListColumnTag_W,'Tag');
    RegisterPropertyHelper(@TListColumnWidth_R,@TListColumnWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THotKey(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THotKey) do begin

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomHotKey(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomHotKey) do begin
    RegisterConstructor(@TCustomHotKey.Create, 'Create');
     //  RegisterMethod(@TCustomHotKey.Free, 'Free');
    end;
end;


(*----------------------------------------------------------------------------*)
procedure TCustomUpDownOnClick_W(Self: TUpDown; const T: TUDClickEvent);
begin Self.OnClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownOnClick_R(Self: TUpDown; var T: TUDClickEvent);
begin T := Self.OnClick; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownOnChangingEx_W(Self: TUpDown; const T: TUDChangingEventEx);
begin Self.OnChangingEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownOnChangingEx_R(Self: TUpDown; var T: TUDChangingEventEx);
begin T := Self.OnChangingEx; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownOnChanging_W(Self: TUpDown; const T: TUDChangingEvent);
begin Self.OnChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownOnChanging_R(Self: TUpDown; var T: TUDChangingEvent);
begin T := Self.OnChanging; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownWrap_W(Self: TUpDown; const T: Boolean);
begin Self.Wrap := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownWrap_R(Self: TUpDown; var T: Boolean);
begin T := Self.Wrap; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownThousands_W(Self: TUpDown; const T: Boolean);
begin Self.Thousands := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownThousands_R(Self: TUpDown; var T: Boolean);
begin T := Self.Thousands; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownPosition_W(Self: TUpDown; const T: SmallInt);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownPosition_R(Self: TUpDown; var T: SmallInt);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownOrientation_W(Self: TUpDown; const T: TUDOrientation);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownOrientation_R(Self: TUpDown; var T: TUDOrientation);
begin T := Self.Orientation; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownIncrement_W(Self: TUpDown; const T: Integer);
begin Self.Increment := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownIncrement_R(Self: TUpDown; var T: Integer);
begin T := Self.Increment; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownMax_W(Self: TUpDown; const T: SmallInt);
begin Self.Max := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownMax_R(Self: TUpDown; var T: SmallInt);
begin T := Self.Max; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownMin_W(Self: TUpDown; const T: SmallInt);
begin Self.Min := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownMin_R(Self: TUpDown; var T: SmallInt);
begin T := Self.Min; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownAssociate_W(Self: TUpDown; const T: TWinControl);
begin Self.Associate := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownAssociate_R(Self: TUpDown; var T: TWinControl);
begin T := Self.Associate; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownArrowKeys_W(Self: TUpDown; const T: Boolean);
begin Self.ArrowKeys := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownArrowKeys_R(Self: TUpDown; var T: Boolean);
begin T := Self.ArrowKeys; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownAlignButton_W(Self: TUpDown; const T: TUDAlignButton);
begin Self.AlignButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomUpDownAlignButton_R(Self: TUpDown; var T: TUDAlignButton);
begin T := Self.AlignButton; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TUpDown(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TUpDown) do  begin
   //RegisterPublishedProperties;
    //   RegisterMethod(@TCustomUpDown.Free, 'Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomUpDown(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomUpDown) do begin
   RegisterConstructor(@TCustomUpDown.Create, 'Create');
    // RegisterMethod(@TUpDown.DoCanChange, 'DoCanChange');
    //RegisterVirtualMethod(@TUpDown.CanChange, 'CanChange');
    //RegisterMethod(@TUpDown.Notification, 'Notification');
    //RegisterVirtualMethod(@TCustomUpDown.Click, 'Click');
    RegisterPropertyHelper(@TCustomUpDownAlignButton_R,@TCustomUpDownAlignButton_W,'AlignButton');
    RegisterPropertyHelper(@TCustomUpDownArrowKeys_R,@TCustomUpDownArrowKeys_W,'ArrowKeys');
    RegisterPropertyHelper(@TCustomUpDownAssociate_R,@TCustomUpDownAssociate_W,'Associate');
    RegisterPropertyHelper(@TCustomUpDownMin_R,@TCustomUpDownMin_W,'Min');
    RegisterPropertyHelper(@TCustomUpDownMax_R,@TCustomUpDownMax_W,'Max');
    RegisterPropertyHelper(@TCustomUpDownIncrement_R,@TCustomUpDownIncrement_W,'Increment');
    RegisterPropertyHelper(@TCustomUpDownOrientation_R,@TCustomUpDownOrientation_W,'Orientation');
    RegisterPropertyHelper(@TCustomUpDownPosition_R,@TCustomUpDownPosition_W,'Position');
    RegisterPropertyHelper(@TCustomUpDownThousands_R,@TCustomUpDownThousands_W,'Thousands');
    RegisterPropertyHelper(@TCustomUpDownWrap_R,@TCustomUpDownWrap_W,'Wrap');
    RegisterPropertyHelper(@TCustomUpDownOnChanging_R,@TCustomUpDownOnChanging_W,'OnChanging');
    RegisterPropertyHelper(@TCustomUpDownOnChangingEx_R,@TCustomUpDownOnChangingEx_W,'OnChangingEx');
    RegisterPropertyHelper(@TCustomUpDownOnClick_R,@TCustomUpDownOnClick_W,'OnClick');
    //RegisterConstructor(@TCustomUpDown.Create, 'Create');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRichEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRichEdit) do begin
     //registerpublishedproperties;
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomRichEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomRichEdit) do begin
    RegisterConstructor(@TCustomRichEdit.Create, 'Create');
   RegisterMethod(@TCustomRichEdit.Destroy, 'Free');
   RegisterMethod(@TCustomRichEdit.Clear, 'Clear');
    RegisterMethod(@TCustomRichEdit.GetSelTextBuf, 'GetSelTextBuf');
    RegisterMethod(@TCustomRichEdit.FindText, 'FindText');
    RegisterVirtualMethod(@TCustomRichEdit.Print, 'Print');
    RegisterMethod(@TCustomRichEdit.RegisterConversionFormat, 'RegisterConversionFormat');
    RegisterPropertyHelper(@TCustomRichEditDefaultConverter_R,@TCustomRichEditDefaultConverter_W,'DefaultConverter');
    RegisterPropertyHelper(@TCustomRichEditDefAttributes_R,@TCustomRichEditDefAttributes_W,'DefAttributes');
    RegisterPropertyHelper(@TCustomRichEditSelAttributes_R,@TCustomRichEditSelAttributes_W,'SelAttributes');
    RegisterPropertyHelper(@TCustomRichEditPageRect_R,@TCustomRichEditPageRect_W,'PageRect');
    RegisterPropertyHelper(@TCustomRichEditParagraph_R,nil,'Paragraph');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConversion(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConversion) do begin
    RegisterVirtualMethod(@TConversion.ConvertReadStream, 'ConvertReadStream');
    RegisterVirtualMethod(@TConversion.ConvertWriteStream, 'ConvertWriteStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParaAttributes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParaAttributes) do begin
    RegisterConstructor(@TParaAttributes.Create, 'Create');
    RegisterMethod(@TParaAttributes.Assign, 'Assign');
    RegisterPropertyHelper(@TParaAttributesAlignment_R,@TParaAttributesAlignment_W,'Alignment');
    RegisterPropertyHelper(@TParaAttributesFirstIndent_R,@TParaAttributesFirstIndent_W,'FirstIndent');
    RegisterPropertyHelper(@TParaAttributesLeftIndent_R,@TParaAttributesLeftIndent_W,'LeftIndent');
    RegisterPropertyHelper(@TParaAttributesNumbering_R,@TParaAttributesNumbering_W,'Numbering');
    RegisterPropertyHelper(@TParaAttributesRightIndent_R,@TParaAttributesRightIndent_W,'RightIndent');
    RegisterPropertyHelper(@TParaAttributesTab_R,@TParaAttributesTab_W,'Tab');
    RegisterPropertyHelper(@TParaAttributesTabCount_R,@TParaAttributesTabCount_W,'TabCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTextAttributes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTextAttributes) do begin
    RegisterConstructor(@TTextAttributes.Create, 'Create');
     RegisterMethod(@TTextAttributes.Assign, 'Assign');
     RegisterPropertyHelper(@TTextAttributesCharset_R,@TTextAttributesCharset_W,'Charset');
    RegisterPropertyHelper(@TTextAttributesColor_R,@TTextAttributesColor_W,'Color');
    RegisterPropertyHelper(@TTextAttributesConsistentAttributes_R,nil,'ConsistentAttributes');
    RegisterPropertyHelper(@TTextAttributesName_R,@TTextAttributesName_W,'Name');
    RegisterPropertyHelper(@TTextAttributesPitch_R,@TTextAttributesPitch_W,'Pitch');
    RegisterPropertyHelper(@TTextAttributesSize_R,@TTextAttributesSize_W,'Size');
    RegisterPropertyHelper(@TTextAttributesStyle_R,@TTextAttributesStyle_W,'Style');
    RegisterPropertyHelper(@TTextAttributesHeight_R,@TTextAttributesHeight_W,'Height');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProgressBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProgressBar) do begin
   RegisterConstructor(@TProgressBar.Create, 'Create');
        RegisterMethod(@TProgressBar.StepIt, 'StepIt');
    RegisterMethod(@TProgressBar.StepBy, 'StepBy');
    RegisterPropertyHelper(@TProgressBarMin_R,@TProgressBarMin_W,'Min');
    RegisterPropertyHelper(@TProgressBarMax_R,@TProgressBarMax_W,'Max');
    RegisterPropertyHelper(@TProgressBarOrientation_R,@TProgressBarOrientation_W,'Orientation');
    RegisterPropertyHelper(@TProgressBarPosition_R,@TProgressBarPosition_W,'Position');
    RegisterPropertyHelper(@TProgressBarSmooth_R,@TProgressBarSmooth_W,'Smooth');
    RegisterPropertyHelper(@TProgressBarStep_R,@TProgressBarStep_W,'Step');
    RegisterPropertyHelper(@TProgressBarColor_R,@TProgressBarColor_W,'Color');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTrackBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTrackBar) do begin
   RegisterConstructor(@TTrackBar.Create, 'Create');
      RegisterMethod(@TTrackBar.SetTick, 'SetTick');
    RegisterPropertyHelper(@TTrackBarLineSize_R,@TTrackBarLineSize_W,'LineSize');
    RegisterPropertyHelper(@TTrackBarMax_R,@TTrackBarMax_W,'Max');
    RegisterPropertyHelper(@TTrackBarMin_R,@TTrackBarMin_W,'Min');
    RegisterPropertyHelper(@TTrackBarOrientation_R,@TTrackBarOrientation_W,'Orientation');
    RegisterPropertyHelper(@TTrackBarPageSize_R,@TTrackBarPageSize_W,'PageSize');
    RegisterPropertyHelper(@TTrackBarFrequency_R,@TTrackBarFrequency_W,'Frequency');
    RegisterPropertyHelper(@TTrackBarPosition_R,@TTrackBarPosition_W,'Position');
    RegisterPropertyHelper(@TTrackBarPositionToolTip_R,@TTrackBarPositionToolTip_W,'PositionToolTip');
    RegisterPropertyHelper(@TTrackBarSliderVisible_R,@TTrackBarSliderVisible_W,'SliderVisible');
    RegisterPropertyHelper(@TTrackBarSelEnd_R,@TTrackBarSelEnd_W,'SelEnd');
    RegisterPropertyHelper(@TTrackBarSelStart_R,@TTrackBarSelStart_W,'SelStart');
    RegisterPropertyHelper(@TTrackBarShowSelRange_R,@TTrackBarShowSelRange_W,'ShowSelRange');
    RegisterPropertyHelper(@TTrackBarThumbLength_R,@TTrackBarThumbLength_W,'ThumbLength');
    RegisterPropertyHelper(@TTrackBarTickMarks_R,@TTrackBarTickMarks_W,'TickMarks');
    RegisterPropertyHelper(@TTrackBarTickStyle_R,@TTrackBarTickStyle_W,'TickStyle');
    RegisterPropertyHelper(@TTrackBarOnChange_R,@TTrackBarOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TTreeViewItems_W(Self: TTreeView; const T: TTreeNodes; const t1: Integer);
begin
  Self.Items:= T;
 end;

(*----------------------------------------------------------------------------*)
procedure TTreeViewItems_R(Self: TTreeView; var T: TTreeNodes; const t1: Integer);
begin T:= Self.Items; end;


//procedure THeaderControlOnDrawSection_R(Self: THeaderControl; var T: TDrawSectionEvent);
//begin T := Self.OnDrawSection; end;



procedure TTreeViewOnChange_R(Self: TTreeView; var T:  TTVChangedEvent; node: TTreeNode);
begin T:= Self.OnChange; end;

procedure TTreeViewOnChange_W(Self: TTreeView; const T: TTVChangedEvent; node: TTreeNode);
begin Self.OnChange:= T; end;


(*----------------------------------------------------------------------------*)
//procedure THeaderControlOnDrawSection_W(Self: THeaderControl; const T: TDrawSectionEvent);
//begin Self.OnDrawSection := T; end;


procedure TTreeViewOnChanging_R(Self: TTreeView; var T:  TTVChangingEvent; node: TTreeNode);
begin T:= Self.OnChanging; end;
procedure TTreeViewOnChanging_W(Self: TTreeView; const T: TTVChangingEvent; node: TTreeNode);
begin Self.OnChanging:= T; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TTreeView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTreeView) do begin
      //RegisterPublishedProperties;
      RegisterPropertyHelper(@TTreeViewItems_R,@TTreeViewItems_W,'Items');


      RegisterPropertyHelper(@TTreeViewOnChange_R,@TTreeViewOnChange_W,'OnChange');
      RegisterPropertyHelper(@TTreeViewOnChanging_R,@TTreeViewOnChanging_W,'OnChanging');

    //RegisterProperty('ONChange', 'TTVChangedEvent', iptr);
    //RegisterProperty('ONChanging', 'TTVChangingEvent', iptr);


  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomTreeView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomTreeView) do begin
     RegisterMethod(@TCustomTreeView.Destroy, 'Free');
   RegisterConstructor(@TCustomTreeView.Create, 'Create');
      RegisterMethod(@TCustomTreeView.AlphaSort, 'AlphaSort');
    RegisterMethod(@TCustomTreeView.CustomSort, 'CustomSort');
    RegisterMethod(@TCustomTreeView.FullCollapse, 'FullCollapse');
    RegisterMethod(@TCustomTreeView.FullExpand, 'FullExpand');
    RegisterMethod(@TCustomTreeView.GetHitTestInfoAt, 'GetHitTestInfoAt');
    RegisterMethod(@TCustomTreeView.GetNodeAt, 'GetNodeAt');
    RegisterMethod(@TCustomTreeView.IsEditing, 'IsEditing');
    RegisterMethod(@TCustomTreeView.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TCustomTreeView.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TCustomTreeView.SaveToFile, 'SaveToFile');
    RegisterMethod(@TCustomTreeView.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TCustomTreeViewCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TCustomTreeViewDropTarget_R,@TCustomTreeViewDropTarget_W,'DropTarget');
    RegisterPropertyHelper(@TCustomTreeViewSelected_R,@TCustomTreeViewSelected_W,'Selected');
    RegisterPropertyHelper(@TCustomTreeViewTopItem_R,@TCustomTreeViewTopItem_W,'TopItem');
    //RegisterProperty('Selected', 'TTreeNode', iptrw);
    //RegisterProperty('TopItem', 'TTreeNode', iptrw);
    RegisterVirtualMethod(@TCustomTreeViewSelect_P, 'Select');
    RegisterVirtualMethod(@TCustomTreeViewSelect1_P, 'Select1');
    RegisterVirtualMethod(@TCustomTreeViewSelect2_P, 'Select2');
    RegisterVirtualMethod(@TCustomTreeView.Deselect, 'Deselect');
    RegisterVirtualMethod(@TCustomTreeView.Subselect, 'Subselect');
    RegisterPropertyHelper(@TCustomTreeViewSelectionCount_R,nil,'SelectionCount');
    RegisterPropertyHelper(@TCustomTreeViewSelections_R,nil,'Selections');
    RegisterVirtualMethod(@TCustomTreeView.ClearSelection, 'ClearSelection');
    RegisterMethod(@TCustomTreeView.GetSelections, 'GetSelections');
    RegisterVirtualMethod(@TCustomTreeView.FindNextToSelect, 'FindNextToSelect');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTreeNodes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTreeNodes) do begin
    RegisterConstructor(@TTreeNodes.Create, 'Create');
       RegisterMethod(@TTreeNodes.Destroy, 'Free');
     //RegisterMethod(@TCustomRadioGroup.Free, 'Free');
    RegisterMethod(@TTreeNodes.Assign, 'Assign');
     RegisterMethod(@TTreeNodes.AddChildFirst, 'AddChildFirst');
    RegisterMethod(@TTreeNodes.AddChild, 'AddChild');
    RegisterMethod(@TTreeNodes.AddChildObjectFirst, 'AddChildObjectFirst');
    RegisterMethod(@TTreeNodes.AddChildObject, 'AddChildObject');
    RegisterMethod(@TTreeNodes.AddFirst, 'AddFirst');
    RegisterMethod(@TTreeNodes.Add, 'Add');
    RegisterMethod(@TTreeNodes.AddObjectFirst, 'AddObjectFirst');
    RegisterMethod(@TTreeNodes.AddObject, 'AddObject');
    RegisterMethod(@TTreeNodes.AddNode, 'AddNode');
    RegisterMethod(@TTreeNodes.AlphaSort, 'AlphaSort');
    RegisterMethod(@TTreeNodes.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TTreeNodes.Clear, 'Clear');
    RegisterMethod(@TTreeNodes.CustomSort, 'CustomSort');
    RegisterMethod(@TTreeNodes.Delete, 'Delete');
    RegisterMethod(@TTreeNodes.EndUpdate, 'EndUpdate');
    RegisterMethod(@TTreeNodes.GetFirstNode, 'GetFirstNode');
    RegisterMethod(@TTreeNodes.GetEnumerator, 'GetEnumerator');
    RegisterMethod(@TTreeNodes.GetNode, 'GetNode');
    RegisterMethod(@TTreeNodes.Insert, 'Insert');
    RegisterMethod(@TTreeNodes.InsertObject, 'InsertObject');
    RegisterMethod(@TTreeNodes.InsertNode, 'InsertNode');
    RegisterPropertyHelper(@TTreeNodesCount_R,nil,'Count');
    RegisterPropertyHelper(@TTreeNodesHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TTreeNodesItem_R,nil,'Item');
    RegisterPropertyHelper(@TTreeNodesOwner_R,nil,'Owner');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTreeNodesEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTreeNodesEnumerator) do begin
    RegisterConstructor(@TTreeNodesEnumerator.Create, 'Create');
    RegisterMethod(@TTreeNodesEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TTreeNodesEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TTreeNodesEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTreeNode) do begin
    RegisterConstructor(@TTreeNode.Create, 'Create');
        RegisterMethod(@TTreeNode.Destroy, 'Free');
       //  RegisterConstructor(@TStNTEventLog.Create, 'Create');
     RegisterMethod(@TTreeNode.Assign, 'Assign');
    RegisterMethod(@TTreeNode.AlphaSort, 'AlphaSort');
    RegisterMethod(@TTreeNode.Collapse, 'Collapse');
    RegisterMethod(@TTreeNode.CustomSort, 'CustomSort');
    RegisterMethod(@TTreeNode.Delete, 'Delete');
    RegisterMethod(@TTreeNode.DeleteChildren, 'DeleteChildren');
    RegisterMethod(@TTreeNode.DisplayRect, 'DisplayRect');
    RegisterMethod(@TTreeNode.EditText, 'EditText');
    RegisterMethod(@TTreeNode.EndEdit, 'EndEdit');
    RegisterMethod(@TTreeNode.Expand, 'Expand');
    RegisterMethod(@TTreeNode.getFirstChild, 'getFirstChild');
    RegisterMethod(@TTreeNode.GetHandle, 'GetHandle');
    RegisterMethod(@TTreeNode.GetLastChild, 'GetLastChild');
    RegisterMethod(@TTreeNode.GetNext, 'GetNext');
    RegisterMethod(@TTreeNode.GetNextChild, 'GetNextChild');
    RegisterMethod(@TTreeNode.getNextSibling, 'getNextSibling');
    RegisterMethod(@TTreeNode.GetNextVisible, 'GetNextVisible');
    RegisterMethod(@TTreeNode.GetPrev, 'GetPrev');
    RegisterMethod(@TTreeNode.GetPrevChild, 'GetPrevChild');
    RegisterMethod(@TTreeNode.getPrevSibling, 'getPrevSibling');
    RegisterMethod(@TTreeNode.GetPrevVisible, 'GetPrevVisible');
    RegisterMethod(@TTreeNode.HasAsParent, 'HasAsParent');
    RegisterMethod(@TTreeNode.IndexOf, 'IndexOf');
    RegisterMethod(@TTreeNode.MakeVisible, 'MakeVisible');
    RegisterVirtualMethod(@TTreeNode.MoveTo, 'MoveTo');
    RegisterPropertyHelper(@TTreeNodeAbsoluteIndex_R,nil,'AbsoluteIndex');
    RegisterMethod(@TTreeNode.IsFirstNode, 'IsFirstNode');
    RegisterPropertyHelper(@TTreeNodeCount_R,nil,'Count');
    RegisterPropertyHelper(@TTreeNodeCut_R,@TTreeNodeCut_W,'Cut');
    RegisterPropertyHelper(@TTreeNodeData_R,@TTreeNodeData_W,'Data');
    RegisterPropertyHelper(@TTreeNodeDeleting_R,nil,'Deleting');
    RegisterPropertyHelper(@TTreeNodeFocused_R,@TTreeNodeFocused_W,'Focused');
    RegisterPropertyHelper(@TTreeNodeDropTarget_R,@TTreeNodeDropTarget_W,'DropTarget');
    RegisterPropertyHelper(@TTreeNodeSelected_R,@TTreeNodeSelected_W,'Selected');
    RegisterPropertyHelper(@TTreeNodeExpanded_R,@TTreeNodeExpanded_W,'Expanded');
    RegisterPropertyHelper(@TTreeNodeHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TTreeNodeHasChildren_R,@TTreeNodeHasChildren_W,'HasChildren');
    RegisterPropertyHelper(@TTreeNodeImageIndex_R,@TTreeNodeImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TTreeNodeIndex_R,nil,'Index');
    RegisterPropertyHelper(@TTreeNodeIsVisible_R,nil,'IsVisible');
    RegisterPropertyHelper(@TTreeNodeItem_R,@TTreeNodeItem_W,'Item');
    RegisterPropertyHelper(@TTreeNodeItemId_R,nil,'ItemId');
    RegisterPropertyHelper(@TTreeNodeLevel_R,nil,'Level');
    RegisterPropertyHelper(@TTreeNodeOverlayIndex_R,@TTreeNodeOverlayIndex_W,'OverlayIndex');
    RegisterPropertyHelper(@TTreeNodeOwner_R,nil,'Owner');
    RegisterPropertyHelper(@TTreeNodeParent_R,nil,'Parent');
    RegisterPropertyHelper(@TTreeNodeSelectedIndex_R,@TTreeNodeSelectedIndex_W,'SelectedIndex');
    RegisterPropertyHelper(@TTreeNodeStateIndex_R,@TTreeNodeStateIndex_W,'StateIndex');
    RegisterPropertyHelper(@TTreeNodeText_R,@TTreeNodeText_W,'Text');
    RegisterPropertyHelper(@TTreeNodeTreeView_R,nil,'TreeView');

   //  RegisterProperty('OnChange', 'TTVChangedEvent', iptr);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THeaderControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THeaderControl) do begin
    RegisterPropertyHelper(@THeaderControlOnDrawSection_R,@THeaderControlOnDrawSection_W,'OnDrawSection');
    RegisterPropertyHelper(@THeaderControlOnSectionClick_R,@THeaderControlOnSectionClick_W,'OnSectionClick');
    RegisterPropertyHelper(@THeaderControlOnSectionResize_R,@THeaderControlOnSectionResize_W,'OnSectionResize');
    RegisterPropertyHelper(@THeaderControlOnSectionTrack_R,@THeaderControlOnSectionTrack_W,'OnSectionTrack');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomHeaderControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomHeaderControl) do begin
    RegisterPropertyHelper(@TCustomHeaderControlCanvas_R,nil,'Canvas');
        RegisterConstructor(@TCustomHeaderControl.Create, 'Create');
         RegisterMethod(@TCustomHeaderControl.Destroy, 'Free');
     RegisterPropertyHelper(@TCustomHeaderControlDragReorder_R,@TCustomHeaderControlDragReorder_W,'DragReorder');
    RegisterPropertyHelper(@TCustomHeaderControlFullDrag_R,@TCustomHeaderControlFullDrag_W,'FullDrag');
    RegisterPropertyHelper(@TCustomHeaderControlHotTrack_R,@TCustomHeaderControlHotTrack_W,'HotTrack');
    RegisterPropertyHelper(@TCustomHeaderControlImages_R,@TCustomHeaderControlImages_W,'Images');
    RegisterPropertyHelper(@TCustomHeaderControlSections_R,@TCustomHeaderControlSections_W,'Sections');
    RegisterPropertyHelper(@TCustomHeaderControlStyle_R,@TCustomHeaderControlStyle_W,'Style');
    RegisterPropertyHelper(@TCustomHeaderControlOnCreateSectionClass_R,@TCustomHeaderControlOnCreateSectionClass_W,'OnCreateSectionClass');
    RegisterPropertyHelper(@TCustomHeaderControlOnDrawSection_R,@TCustomHeaderControlOnDrawSection_W,'OnDrawSection');
    RegisterPropertyHelper(@TCustomHeaderControlOnSectionClick_R,@TCustomHeaderControlOnSectionClick_W,'OnSectionClick');
    RegisterPropertyHelper(@TCustomHeaderControlOnSectionDrag_R,@TCustomHeaderControlOnSectionDrag_W,'OnSectionDrag');
    RegisterPropertyHelper(@TCustomHeaderControlOnSectionEndDrag_R,@TCustomHeaderControlOnSectionEndDrag_W,'OnSectionEndDrag');
    RegisterPropertyHelper(@TCustomHeaderControlOnSectionResize_R,@TCustomHeaderControlOnSectionResize_W,'OnSectionResize');
    RegisterPropertyHelper(@TCustomHeaderControlOnSectionTrack_R,@TCustomHeaderControlOnSectionTrack_W,'OnSectionTrack');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THeaderSections(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THeaderSections) do begin
    RegisterConstructor(@THeaderSections.Create, 'Create');
    RegisterMethod(@THeaderSections.Add, 'Add');
    RegisterMethod(@THeaderSections.AddItem, 'AddItem');
    RegisterMethod(@THeaderSections.Insert, 'Insert');
    RegisterPropertyHelper(@THeaderSectionsItems_R,@THeaderSectionsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THeaderSection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THeaderSection) do begin
   RegisterConstructor(@THeaderSection.Create, 'Create');
   RegisterMethod(@THeaderSection.Assign, 'Assign');
    RegisterMethod(@THeaderSection.ParentBiDiModeChanged, 'ParentBiDiModeChanged');
    RegisterMethod(@THeaderSection.UseRightToLeftAlignment, 'UseRightToLeftAlignment');
    RegisterMethod(@THeaderSection.UseRightToLeftReading, 'UseRightToLeftReading');
    RegisterPropertyHelper(@THeaderSectionLeft_R,nil,'Left');
    RegisterPropertyHelper(@THeaderSectionRight_R,nil,'Right');
    RegisterPropertyHelper(@THeaderSectionAlignment_R,@THeaderSectionAlignment_W,'Alignment');
    RegisterPropertyHelper(@THeaderSectionAllowClick_R,@THeaderSectionAllowClick_W,'AllowClick');
    RegisterPropertyHelper(@THeaderSectionAutoSize_R,@THeaderSectionAutoSize_W,'AutoSize');
    RegisterPropertyHelper(@THeaderSectionBiDiMode_R,@THeaderSectionBiDiMode_W,'BiDiMode');
    RegisterPropertyHelper(@THeaderSectionImageIndex_R,@THeaderSectionImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@THeaderSectionMaxWidth_R,@THeaderSectionMaxWidth_W,'MaxWidth');
    RegisterPropertyHelper(@THeaderSectionMinWidth_R,@THeaderSectionMinWidth_W,'MinWidth');
    RegisterPropertyHelper(@THeaderSectionParentBiDiMode_R,@THeaderSectionParentBiDiMode_W,'ParentBiDiMode');
    RegisterPropertyHelper(@THeaderSectionStyle_R,@THeaderSectionStyle_W,'Style');
    RegisterPropertyHelper(@THeaderSectionText_R,@THeaderSectionText_W,'Text');
    RegisterPropertyHelper(@THeaderSectionWidth_R,@THeaderSectionWidth_W,'Width');
  end;
end;


procedure TStatusBarCOLOR_R(Self: TStatusBar; var T: TCOLOR); begin T := Self.COLOR; end;
procedure TStatusBarCOLOR_W(Self: TStatusBar; T: TCOLOR); begin Self.COLOR := T; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStatusBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStatusBar) do begin
    RegisterPropertyHelper(@TStatusBarCOLOR_R, @TStatusBarCOLOR_W, 'Color');
    RegisterPropertyHelper(@TStatusBarOnDrawPanel_R,@TStatusBarOnDrawPanel_W,'OnDrawPanel');
  end;
end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomStatusBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomStatusBar) do begin
    RegisterPropertyHelper(@TCustomStatusBarCanvas_R,nil,'Canvas');
    RegisterMethod(@TCustomStatusBar.SetBounds,'SetBounds');
    RegisterConstructor(@TCustomStatusBar.Create, 'Create');
   RegisterMethod(@TCustomStatusBar.Destroy, 'Free');
   RegisterMethod(@TCustomStatusBar.ExecuteAction, 'ExecuteAction');
  RegisterMethod(@TCustomStatusBar.FlipChildren, 'FlipChildren');
     //RegisterPropertyHelper(@TCustomStatusBarHideS_R,@TCustomStatusBarHideS_W,'HideSelection');

  //  RegisterPropertyHelper(@TCustomStatusBarCOLOR_R, @TCustomStatusBarCOLOR_W, 'Color');
    RegisterPropertyHelper(@TCustomStatusBarAutoHint_R,@TCustomStatusBarAutoHint_W,'AutoHint');
    RegisterPropertyHelper(@TCustomStatusBarPanels_R,@TCustomStatusBarPanels_W,'Panels');
    RegisterPropertyHelper(@TCustomStatusBarSimplePanel_R,@TCustomStatusBarSimplePanel_W,'SimplePanel');
    RegisterPropertyHelper(@TCustomStatusBarSimpleText_R,@TCustomStatusBarSimpleText_W,'SimpleText');
    RegisterPropertyHelper(@TCustomStatusBarSizeGrip_R,@TCustomStatusBarSizeGrip_W,'SizeGrip');
    RegisterPropertyHelper(@TCustomStatusBarUseSystemFont_R,@TCustomStatusBarUseSystemFont_W,'UseSystemFont');
    RegisterPropertyHelper(@TCustomStatusBarOnCreatePanelClass_R,@TCustomStatusBarOnCreatePanelClass_W,'OnCreatePanelClass');
    RegisterPropertyHelper(@TCustomStatusBarOnHint_R,@TCustomStatusBarOnHint_W,'OnHint');
    RegisterPropertyHelper(@TCustomStatusBarOnDrawPanel_R,@TCustomStatusBarOnDrawPanel_W,'OnDrawPanel');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStatusPanels(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStatusPanels) do begin
    RegisterConstructor(@TStatusPanels.Create, 'Create');
    RegisterMethod(@TStatusPanels.Add, 'Add');
    RegisterMethod(@TStatusPanels.AddItem, 'AddItem');
    RegisterMethod(@TStatusPanels.Insert, 'Insert');
    RegisterPropertyHelper(@TStatusPanelsItems_R,@TStatusPanelsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStatusPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStatusPanel) do begin
    RegisterConstructor(@TStatusPanel.Create, 'Create');
    RegisterMethod(@TStatusPanel.Assign, 'Assign');
     //RegisterMethod(TStatusPanel.SetBounds,'SetBounds');
    RegisterMethod(@TStatusPanel.ParentBiDiModeChanged, 'ParentBiDiModeChanged');
    RegisterMethod(@TStatusPanel.UseRightToLeftAlignment, 'UseRightToLeftAlignment');
    RegisterMethod(@TStatusPanel.UseRightToLeftReading, 'UseRightToLeftReading');
    RegisterPropertyHelper(@TStatusPanelAlignment_R,@TStatusPanelAlignment_W,'Alignment');
    RegisterPropertyHelper(@TStatusPanelBevel_R,@TStatusPanelBevel_W,'Bevel');
    RegisterPropertyHelper(@TStatusPanelBiDiMode_R,@TStatusPanelBiDiMode_W,'BiDiMode');
    RegisterPropertyHelper(@TStatusPanelParentBiDiMode_R,@TStatusPanelParentBiDiMode_W,'ParentBiDiMode');
    RegisterPropertyHelper(@TStatusPanelStyle_R,@TStatusPanelStyle_W,'Style');
    RegisterPropertyHelper(@TStatusPanelText_R,@TStatusPanelText_W,'Text');
    RegisterPropertyHelper(@TStatusPanelWidth_R,@TStatusPanelWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPageControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPageControl) do begin
    RegisterConstructor(@TPageControl.Create, 'Create');
   RegisterMethod(@TPageControl.Destroy, 'Free');
     RegisterMethod(@TPageControl.FindNextPage, 'FindNextPage');
    RegisterMethod(@TPageControl.SelectNextPage, 'SelectNextPage');
    RegisterPropertyHelper(@TPageControlActivePageIndex_R,@TPageControlActivePageIndex_W,'ActivePageIndex');
    RegisterPropertyHelper(@TPageControlPageCount_R,nil,'PageCount');
    RegisterPropertyHelper(@TPageControlPages_R,nil,'Pages');
    RegisterPropertyHelper(@TPageControlActivePage_R,@TPageControlActivePage_W,'ActivePage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTabSheet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTabSheet) do begin
   RegisterConstructor(@TTabSheet.Create, 'Create');
   RegisterMethod(@TTabSheet.Destroy, 'Free');
     RegisterPropertyHelper(@TTabSheetPageControl_R,@TTabSheetPageControl_W,'PageControl');
    RegisterPropertyHelper(@TTabSheetTabIndex_R,nil,'TabIndex');
    RegisterPropertyHelper(@TTabSheetHighlighted_R,@TTabSheetHighlighted_W,'Highlighted');
    RegisterPropertyHelper(@TTabSheetImageIndex_R,@TTabSheetImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TTabSheetPageIndex_R,@TTabSheetPageIndex_W,'PageIndex');
    RegisterPropertyHelper(@TTabSheetTabVisible_R,@TTabSheetTabVisible_W,'TabVisible');
    RegisterPropertyHelper(@TTabSheetOnHide_R,@TTabSheetOnHide_W,'OnHide');
    RegisterPropertyHelper(@TTabSheetOnShow_R,@TTabSheetOnShow_W,'OnShow');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTabControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTabControl) do begin
    RegisterPropertyHelper(@TTabControlTabs_R,@TTabControlTabs_W,'Tabs');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomTabControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomTabControl) do begin
    RegisterConstructor(@TCustomTabControl.Create, 'Create');
     RegisterMethod(@TCustomTabControl.Destroy, 'Free');
      RegisterMethod(@TCustomTabControl.IndexOfTabAt, 'IndexOfTabAt');
    RegisterMethod(@TCustomTabControl.GetHitTestInfoAt, 'GetHitTestInfoAt');
    RegisterMethod(@TCustomTabControl.TabRect, 'TabRect');
    RegisterMethod(@TCustomTabControl.RowCount, 'RowCount');
    RegisterMethod(@TCustomTabControl.ScrollTabs, 'ScrollTabs');
    RegisterPropertyHelper(@TCustomTabControlCanvas_R,nil,'Canvas');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ComCtrls(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomTabControl) do
  RIRegister_TCustomTabControl(CL);
  RIRegister_TTabControl(CL);
  with CL.Add(TPageControl) do
  RIRegister_TTabSheet(CL);
  RIRegister_TPageControl(CL);
  with CL.Add(TCustomStatusBar) do
  with CL.Add(TStatusPanel) do
  with CL.Add(TStatusPanels) do
  RIRegister_TStatusPanel(CL);
  RIRegister_TStatusPanels(CL);
  RIRegister_TCustomStatusBar(CL);
  with CL.Add(TStatusBar) do
  RIRegister_TStatusBar(CL);
  with CL.Add(TCustomHeaderControl) do
  with CL.Add(THeaderControl) do
  with CL.Add(THeaderSection) do
  RIRegister_THeaderSection(CL);
  RIRegister_THeaderSections(CL);
  RIRegister_TCustomHeaderControl(CL);
  RIRegister_THeaderControl(CL);
  with CL.Add(TCustomTreeView) do
  with CL.Add(TTreeNode) do
  with CL.Add(TTreeNodes) do
  RIRegister_TTreeNode(CL);
  RIRegister_TTreeNodesEnumerator(CL);
  RIRegister_TTreeNodes(CL);
  with CL.Add(ETreeViewError) do
  RIRegister_TCustomTreeView(CL);
  RIRegister_TTreeView(CL);
  RIRegister_TTrackBar(CL);
  RIRegister_TProgressBar(CL);
  with CL.Add(TCustomRichEdit) do
  RIRegister_TTextAttributes(CL);
  RIRegister_TParaAttributes(CL);
  RIRegister_TConversion(CL);
  RIRegister_TCustomRichEdit(CL);
  RIRegister_TRichEdit(CL);
  RIRegister_TCustomUpDown(CL);
  RIRegister_TUpDown(CL);
  RIRegister_TCustomHotKey(CL);
  RIRegister_THotKey(CL);
  with CL.Add(TListColumns) do
  with CL.Add(TListItem) do
  with CL.Add(TListItems) do
  with CL.Add(TCustomListView) do
  RIRegister_TListColumn(CL);
  RIRegister_TListColumns(CL);
  RIRegister_TListItem(CL);
  RIRegister_TListItemsEnumerator(CL);
  RIRegister_TListItems(CL);
  RIRegister_TWorkArea(CL);
  RIRegister_TWorkAreas(CL);
  RIRegister_TIconOptions(CL);
  RIRegister_TCustomListView(CL);
  RIRegister_TListView(CL);
  RIRegister_TListViewActionLink(CL);
  RIRegister_TAnimate(CL);
  with CL.Add(TToolBar) do
  with CL.Add(TToolButton) do
  RIRegister_TToolButtonActionLink(CL);
  RIRegister_TToolButton(CL);
  RIRegister_TToolBarEnumerator(CL);
  RIRegister_TToolBar(CL);
  RIRegister_TToolBarDockObject(CL);
  with CL.Add(TCoolBar) do
  RIRegister_TCoolBand(CL);
  RIRegister_TCoolBands(CL);
  RIRegister_TCoolBar(CL);
  with CL.Add(TCommonCalendar) do
  with CL.Add(ECommonCalendarError) do
  RIRegister_TMonthCalColors(CL);
  RIRegister_TCommonCalendar(CL);
  with CL.Add(EMonthCalError) do
  RIRegister_TMonthCalendar(CL);
  with CL.Add(EDateTimeError) do
  RIRegister_TDateTimePicker(CL);
  RIRegister_TPageScroller(CL);
  RIRegister_TComboExItem(CL);
  RIRegister_TComboExItems(CL);
  with CL.Add(TCustomComboBoxEx) do
  RIRegister_TComboBoxExStrings(CL);
  RIRegister_TCustomComboBoxEx(CL);
  RIRegister_TComboBoxEx(CL);
  RIRegister_TComboBoxExActionLink(CL);
  RIRegister_TBytesStream(CL);

end;

 
 
{ TPSImport_ComCtrls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ComCtrls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ComCtrls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ComCtrls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ComCtrls(ri);
  RIRegister_ComCtrls_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
