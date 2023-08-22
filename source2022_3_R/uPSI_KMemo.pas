unit uPSI_KMemo;
{
to build maXtex   with RTF and HEX   for maXlab  - options  - function WordMouseAction

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
  TPSImport_KMemo = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TKMemoEditSelectAllAction(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoEditPasteAction(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoEditCutAction(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoEditCopyAction(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoEditAction(CL: TPSPascalCompiler);
procedure SIRegister_TKMemo(CL: TPSPascalCompiler);
procedure SIRegister_TKCustomMemo(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoChangeList(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoColors(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoBlocks(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoTable(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoTableRow(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoTableCell(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoContainer(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoImageBlock(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoParagraph(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoHyperlink(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoTextBlock(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoSingleton(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoBlock(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoWordList(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoWord(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoLines(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoLine(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoParaStyle(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoBlockStyle(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoTextStyle(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoListTable(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoList(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoListLevels(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoListLevel(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoNumberingFormat(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoNumberingFormatItem(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoDictionary(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoDictionaryItem(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoSparseStack(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoSparseList(CL: TPSPascalCompiler);
procedure SIRegister_TKMemoSparseItem(CL: TPSPascalCompiler);
procedure SIRegister_KMemo(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_KMemo_Routines(S: TPSExec);
procedure RIRegister_TKMemoEditSelectAllAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoEditPasteAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoEditCutAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoEditCopyAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoEditAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKCustomMemo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoChangeList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoBlocks(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoTableRow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoTableCell(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoImageBlock(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoParagraph(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoHyperlink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoTextBlock(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoSingleton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoBlock(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoWordList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoWord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoLines(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoLine(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoParaStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoBlockStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoTextStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoListTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoListLevels(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoListLevel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoNumberingFormat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoNumberingFormatItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoDictionary(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoDictionaryItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoSparseStack(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoSparseList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMemoSparseItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_KMemo(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   {LCLType
  ,LCLIntf
  ,LMessages
  ,LCLProc
  ,LResources}
  Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Contnrs
  ,Types
  ,ActnList
  ,ExtCtrls
  ,StdCtrls, OleCtrls
  ,Forms
  ,KFunctions
  ,KControls
  ,KGraphics
  ,KEditCommon
  ,KMemo
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_KMemo]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoEditSelectAllAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoEditAction', 'TKMemoEditSelectAllAction') do
  with CL.AddClassN(CL.FindClass('TKMemoEditAction'),'TKMemoEditSelectAllAction') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoEditPasteAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoEditAction', 'TKMemoEditPasteAction') do
  with CL.AddClassN(CL.FindClass('TKMemoEditAction'),'TKMemoEditPasteAction') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoEditCutAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoEditAction', 'TKMemoEditCutAction') do
  with CL.AddClassN(CL.FindClass('TKMemoEditAction'),'TKMemoEditCutAction') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoEditCopyAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoEditAction', 'TKMemoEditCopyAction') do
  with CL.AddClassN(CL.FindClass('TKMemoEditAction'),'TKMemoEditCopyAction') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoEditAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAction', 'TKMemoEditAction') do
  with CL.AddClassN(CL.FindClass('TAction'),'TKMemoEditAction') do
  begin
    RegisterMethod('Function HandlesTarget( Target : TObject) : Boolean');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKCustomMemo', 'TKMemo') do
  with CL.AddClassN(CL.FindClass('TKCustomMemo'),'TKMemo') do begin
  RegisterPublishedProperties;
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
       RegisterProperty('ALIGN', 'TALIGN', iptrw);
      RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
    RegisterProperty('SCROLLBARS', 'TScrollStyle', iptrw);
    RegisterProperty('WANTRETURNS', 'Boolean', iptrw);
    RegisterProperty('WANTTABS', 'Boolean', iptrw);
    RegisterProperty('WORDWRAP', 'Boolean', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('OEMConvert', 'Boolean', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);

    //RegisterProperty('COLOR', 'TColor', iptrw);
    //RegisterProperty('FONT', 'TFont', iptrw);
    //RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    //RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     //RegisterProperty('FONT', 'TFont', iptrw);
     //RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     //RegisterProperty('TEXT', 'String', iptrw);
    //RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);

    //RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
    RegisterProperty('PARENTCTL3D', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKCustomMemo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKCustomControl', 'TKCustomMemo') do
  with CL.AddClassN(CL.FindClass('TKCustomControl'),'TKCustomMemo') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
        RegisterMethod('Procedure Free');

    RegisterMethod('Function CaretInView : Boolean');
    RegisterMethod('Function ClampInView( AMousePos : PPoint; ACallScrollWindow : Boolean) : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure ClearSelection( ATextOnly : Boolean)');
    RegisterMethod('Procedure ClearUndo');
    RegisterMethod('Function CommandEnabled( Command : TKEditCommand) : Boolean');
    RegisterMethod('Procedure DeleteBOL( At : Integer)');
    RegisterMethod('Procedure DeleteChar( At : Integer)');
    RegisterMethod('Procedure DeleteEOL( At : Integer)');
    RegisterMethod('Procedure DeleteLastChar( At : Integer)');
    RegisterMethod('Procedure DeleteLine( At : Integer)');
    RegisterMethod('Function ExecuteCommand( Command : TKEditCommand; Data : integer) : Boolean');
    RegisterMethod('Function GetMaxLeftPos : Integer');
    RegisterMethod('Function GetMaxTopPos : Integer');
    RegisterMethod('Function IndexToRect( AValue : Integer; ACaret : Boolean) : TRect');
    RegisterMethod('Procedure InsertChar( At : Integer; const AValue : TKChar)');
    RegisterMethod('Procedure InsertNewLine( At : Integer)');
    RegisterMethod('Procedure InsertString( At : Integer; const AValue : TkkString)');
    RegisterMethod('Procedure LoadFromFile( const AFileName : TkkString)');
    RegisterMethod('Procedure LoadFromRTF( const AFileName : TkkString)');
    RegisterMethod('Procedure LoadFromRTFStream( AStream : TStream; AtIndex : Integer)');
    RegisterMethod('Procedure LoadFromTXT( const AFileName : TkkString)');
    RegisterMethod('Procedure MoveCaretToMouseCursor( AIfOutsideOfSelection : Boolean)');
    RegisterMethod('Function PointToIndex( APoint : TPoint; AOutOfArea, ASelectionExpanding : Boolean; out ALinePos : TKMemoLinePosition) : Integer');
    RegisterMethod('Procedure SaveToFile( const AFileName : TkkString; ASelectedOnly : Boolean)');
    RegisterMethod('Procedure SaveToRTF( const AFileName : TkkString; ASelectedOnly : Boolean)');
    RegisterMethod('Procedure SaveToRTFStream( AStream : TStream; ASelectedOnly : Boolean)');
    RegisterMethod('Procedure SaveToTXT( const AFileName : TkkString; ASelectedOnly : Boolean)');
    RegisterMethod('Procedure Select( ASelStart, ASelLength : Integer; ADoScroll : Boolean)');
    RegisterMethod('Function SplitAt( AIndex : Integer) : Integer');
    RegisterProperty('ActiveBlock', 'TKMemoBlock', iptr);
    RegisterProperty('ActiveInnerBlock', 'TKMemoBlock', iptr);
    RegisterProperty('ActiveBlocks', 'TKMemoBlocks', iptr);
    RegisterProperty('ActiveInnerBlocks', 'TKMemoBlocks', iptr);
    RegisterProperty('Blocks', 'TKMemoBlocks', iptr);
    RegisterProperty('BackgroundImage', 'TPicture', iptr);
    RegisterProperty('CaretPos', 'Integer', iptr);
    RegisterProperty('CaretVisible', 'Boolean', iptr);
    RegisterProperty('Colors', 'TKMemoColors', iptrw);
    RegisterProperty('ContentPadding', 'TKRect', iptr);
    RegisterProperty('ContentHeight', 'Integer', iptr);
    RegisterProperty('ContentLeft', 'Integer', iptr);
    RegisterProperty('ContentRect', 'TRect', iptr);
    RegisterProperty('ContentTop', 'Integer', iptr);
    RegisterProperty('ContentWidth', 'Integer', iptr);
    RegisterProperty('DisabledDrawStyle', 'TKEditDisabledDrawStyle', iptrw);
    RegisterProperty('Empty', 'Boolean', iptr);
    RegisterProperty('HorzScrollPadding', 'Integer', iptr);
    RegisterProperty('InsertMode', 'Boolean', iptr);
    RegisterProperty('KeyMapping', 'TKEditKeyMapping', iptr);
    RegisterProperty('LeftPos', 'Integer', iptrw);
    RegisterProperty('ListTable', 'TKMemoListTable', iptr);
    RegisterProperty('Modified', 'Boolean', iptrw);
    RegisterProperty('NearestParagraph', 'TKMemoParagraph', iptr);
    RegisterProperty('Options', 'TKEditOptions', iptrw);
    RegisterProperty('ParaStyle', 'TKMemoParaStyle', iptr);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
    RegisterProperty('RealSelEnd', 'Integer', iptr);
    RegisterProperty('RealSelStart', 'Integer', iptr);
    RegisterProperty('RequiredContentWidth', 'Integer', iptrw);
    RegisterProperty('RTF', 'TKMemoRTFString', iptrw);
    RegisterProperty('ScrollBars', 'TScrollStyle', iptrw);
    RegisterProperty('ScrollSpeed', 'Cardinal', iptrw);
    RegisterProperty('ScrollPadding', 'Integer', iptrw);
    RegisterProperty('SelAvail', 'Boolean', iptr);
    RegisterProperty('SelectableLength', 'Integer', iptr);
    RegisterProperty('SelectionHasPara', 'Boolean', iptr);
    RegisterProperty('SelectionParaStyle', 'TKMemoParaStyle', iptrw);
    RegisterProperty('SelectionTextStyle', 'TKMemoTextStyle', iptrw);
    RegisterProperty('SelEnd', 'Integer', iptrw);
    RegisterProperty('SelLength', 'Integer', iptrw);
    RegisterProperty('SelStart', 'Integer', iptrw);
    RegisterProperty('SelText', 'TkkString', iptr);
    RegisterProperty('Text', 'TkkString', iptrw);
    RegisterProperty('TextStyle', 'TKMemoTextStyle', iptr);
    RegisterProperty('TopPos', 'Integer', iptrw);
    RegisterProperty('UndoLimit', 'Integer', iptrw);
    RegisterProperty('VertScrollPadding', 'Integer', iptr);
    RegisterProperty('WordBreaks', 'TKSysCharSet', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDropFiles', 'TKEditDropFilesEvent', iptrw);
    RegisterProperty('OnReplaceText', 'TKEditReplaceTextEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoChangeList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TKMemoChangeList') do
  with CL.AddClassN(CL.FindClass('TList'),'TKMemoChangeList') do
  begin
    RegisterMethod('Constructor Create( AEditor : TKCustomMemo; RedoList : TKMemoChangeList)');
    RegisterMethod('Procedure AddChange( ItemKind : TKMemoChangeKind; Inserted : Boolean)');
    RegisterMethod('Procedure BeginGroup( GroupKind : TKMemoChangeKind)');
    RegisterMethod('Function CanPeek : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure EndGroup');
    RegisterMethod('Function PeekItem : PKMemoChangeItem');
    RegisterMethod('Procedure PokeItem');
    RegisterMethod('Procedure SetGroupData( Group : Integer; GroupKind : TKMemoChangeKind)');
    RegisterProperty('Limit', 'Integer', iptrw);
    RegisterProperty('Modified', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TKMemoUndoChangeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKCustomColors', 'TKMemoColors') do
  with CL.AddClassN(CL.FindClass('TKCustomColors'),'TKMemoColors') do
  begin
    RegisterProperty('BkGnd', 'TColor', iptrw);
    RegisterProperty('InactiveCaretBkGnd', 'TColor', iptrw);
    RegisterProperty('InactiveCaretSelBkGnd', 'TColor', iptrw);
    RegisterProperty('InactiveCaretSelText', 'TColor', iptrw);
    RegisterProperty('InactiveCaretText', 'TColor', iptrw);
    RegisterProperty('SelBkGnd', 'TColor', iptrw);
    RegisterProperty('SelBkGndFocused', 'TColor', iptrw);
    RegisterProperty('SelText', 'TColor', iptrw);
    RegisterProperty('SelTextFocused', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoBlocks(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObjectList', 'TKMemoBlocks') do
  with CL.AddClassN(CL.FindClass('TKObjectList'),'TKMemoBlocks') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Function AddAt( AObject : TKMemoBlock; At : Integer) : Integer');
    RegisterMethod('Function AddContainer( At : Integer) : TKMemoContainer');
    RegisterMethod('Function AddHyperlink( const AText, AURL : TkkString; At : Integer) : TKMemoHyperlink;');
    RegisterMethod('Function AddHyperlink1( AItem : TKMemoHyperlink; At : Integer) : TKMemoHyperlink;');
    RegisterMethod('Function AddImageBlock( const APath : TkkString; At : Integer) : TKMemoImageBlock');
    RegisterMethod('Function AddParagraph( At : Integer) : TKMemoParagraph');
    RegisterMethod('Function AddTable( At : Integer) : TKMemoTable');
    RegisterMethod('Function AddTextBlock( const AText : TkkString; At : Integer) : TKMemoTextBlock');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure ClearSelection( ATextOnly : Boolean)');
    RegisterMethod('Procedure ConcatEqualBlocks');
    RegisterMethod('Procedure DeleteBOL( At : Integer)');
    RegisterMethod('Procedure DeleteChar( At : Integer)');
    RegisterMethod('Procedure DeleteEOL( At : Integer)');
    RegisterMethod('Procedure DeleteLastChar( At : Integer)');
    RegisterMethod('Procedure DeleteLine( At : Integer)');
    RegisterMethod('Procedure FixEmptyBlocks');
    RegisterMethod('Procedure FixEOL( AIndex : Integer; AAdjust : Boolean; var ALinePos : TKMemoLinePosition)');
    RegisterMethod('Function GetNearestAnchorIndex( AIndex : Integer) : Integer');
    RegisterMethod('Function GetNearestParagraph( AIndex : Integer) : TKMemoParagraph');
    RegisterMethod('Function GetLastItemByClass( AIndex : Integer; AClass : TKMemoBlockClass) : TKMemoBlock');
    RegisterMethod('Function GetNextItemByClass( AIndex : Integer; AClass : TKMemoBlockClass) : TKMemoBlock');
    RegisterMethod('Procedure GetSelColors( out TextColor, Background : TColor)');
    RegisterMethod('Function IndexAboveLastLine( AIndex : Integer; AAdjust : Boolean) : Boolean');
    RegisterMethod('Function IndexAtBeginningOfContainer( AIndex : Integer; AAdjust : Boolean) : Boolean');
    RegisterMethod('Function IndexAtEndOfContainer( AIndex : Integer; AAdjust : Boolean) : Boolean');
    RegisterMethod('Function IndexBelowFirstLine( AIndex : Integer; AAdjust : Boolean) : Boolean');
    RegisterMethod('Function IndexToBlock( AIndex : Integer; out ALocalIndex : Integer) : Integer');
    RegisterMethod('Function IndexToBlocks( AIndex : Integer; out ALocalIndex : Integer) : TKMemoBlocks');
    RegisterMethod('Function IndexToItem( AIndex : Integer; out ALocalIndex : Integer) : TKMemoBlock');
    RegisterMethod('Function IndexToLine( AIndex : Integer) : Integer');
    RegisterMethod('Function IndexToRect( ACanvas : TCanvas; AIndex : Integer; ACaret, AAdjust : Boolean) : TRect');
    RegisterMethod('Function InsideOfTable : Boolean');
    RegisterMethod('Procedure InsertChar( At : Integer; const AValue : TKChar; AOverWrite : Boolean)');
    RegisterMethod('Procedure InsertNewLine( At : Integer)');
    RegisterMethod('Procedure InsertPlainText( AIndex : Integer; const AValue : TkkString)');
    RegisterMethod('Function InsertParagraph( AIndex : Integer; AAdjust : Boolean) : Boolean');
    RegisterMethod('Function InsertString( AIndex : Integer; AAdjust : Boolean; const AValue : TkkString) : Boolean');
    RegisterMethod('Function LastTextStyle( AIndex : Integer) : TKMemoTextStyle');
    RegisterMethod('Function LineEndIndexByIndex( AIndex : Integer; AAdjust, ASelectionExpanding : Boolean; out ALinePos : TKMemoLinePosition) : Integer');
    RegisterMethod('Function LineStartIndexByIndex( AIndex : Integer; AAdjust : Boolean; out ALinePos : TKMemoLinePosition) : Integer');
    RegisterMethod('Procedure ListChanged( AList : TKMemoList; ALevel : TKMemoListLevel)');
    RegisterMethod('Procedure MeasureExtent( ACanvas : TCanvas; ARequiredWidth : Integer)');
    RegisterMethod('Function MouseAction( AAction : TKMemoMouseAction; const APoint : TPoint; AShift : TShiftState) : Boolean');
    RegisterMethod('Procedure NotifyDefaultParaChange');
    RegisterMethod('Procedure NotifyDefaultTextChange');
    RegisterMethod('Function NextIndexByCharCount( AIndex, ACharCount : Integer) : Integer');
    RegisterMethod('Function NextIndexByHorzExtent( ACanvas : TCanvas; AIndex, AWidth : Integer; out ALinePos : TKMemoLinePosition) : Integer');
    RegisterMethod('Function NextIndexByRowDelta( ACanvas : TCanvas; AIndex, ARowDelta, ALeftPos : Integer; out ALinePos : TKMemoLinePosition) : Integer');
    RegisterMethod('Function NextIndexByVertExtent( ACanvas : TCanvas; AIndex, AHeight, ALeftPos : Integer; out ALinePos : TKMemoLinePosition) : Integer');
    RegisterMethod('Function NextIndexByVertValue( ACanvas : TCanvas; AValue, ALeftPos : Integer; ADirection : Boolean; out ALinePos : TKMemoLinePosition) : Integer');
    RegisterMethod('Function PointToBlocks( ACanvas : TCanvas; const APoint : TPoint) : TKMemoBlocks');
    RegisterMethod('Procedure PaintToCanvas( ACanvas : TCanvas; ALeft, ATop : Integer; const ARect : TRect)');
    RegisterMethod('Function PointToIndex( ACanvas : TCanvas; const APoint : TPoint; AOutOfArea, ASelectionExpanding : Boolean; out ALinePos : TKMemoLinePosition) : Integer');
    RegisterMethod('Function PointToIndexOnLine( ACanvas : TCanvas; ALineIndex : Integer; const APoint : TPoint; AOutOfArea, ASelectionExpanding : Boolean; out ALinePos : TKMemoLinePosition) : Integer');
    RegisterMethod('Procedure SetExtent( AWidth, AHeight : Integer)');
    RegisterMethod('Procedure UpdateAttributes');
    RegisterProperty('BoundsRect', 'TRect', iptr);
    RegisterProperty('DefaultTextStyle', 'TKMemoTextStyle', iptr);
    RegisterProperty('DefaultParaStyle', 'TKMemoParaStyle', iptr);
    RegisterProperty('Empty', 'Boolean', iptr);
    RegisterProperty('Height', 'Integer', iptr);
    RegisterProperty('IgnoreParaMark', 'Boolean', iptrw);
    RegisterProperty('Items', 'TKMemoBlock Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('LineBottom', 'Integer Integer', iptr);
    RegisterProperty('LineCount', 'Integer', iptr);
    RegisterProperty('LineEndIndex', 'Integer Integer', iptr);
    RegisterProperty('LineFloat', 'Boolean Integer', iptr);
    RegisterProperty('LineInfo', 'TKMemoLine Integer', iptr);
    RegisterProperty('LineHeight', 'Integer Integer', iptr);
    RegisterProperty('LineLeft', 'Integer Integer', iptr);
    RegisterProperty('LineRight', 'Integer Integer', iptr);
    RegisterProperty('LineTop', 'Integer Integer', iptr);
    RegisterProperty('LineRect', 'TRect Integer', iptr);
    RegisterProperty('LineText', 'TkkString Integer', iptrw);
    RegisterProperty('Lines', 'TKMemoLines', iptr);
    RegisterProperty('LineSize', 'Integer Integer', iptr);
    RegisterProperty('LineStartIndex', 'Integer Integer', iptr);
    RegisterProperty('LineWidth', 'Integer Integer', iptr);
    RegisterProperty('MemoNotifier', 'IKMemoNotifier', iptrw);
    RegisterProperty('Parent', 'TKMemoBlock', iptrw);
    RegisterProperty('ParentBlocks', 'TKMemoBlocks', iptr);
    RegisterProperty('RealSelEnd', 'Integer', iptr);
    RegisterProperty('RealSelStart', 'Integer', iptr);
    RegisterProperty('SelectableLength', 'Integer', iptr);
    RegisterProperty('SelectionHasPara', 'Boolean', iptr);
    RegisterProperty('SelectionParaStyle', 'TKMemoParaStyle', iptrw);
    RegisterProperty('SelectionTextStyle', 'TKMemoTextStyle', iptrw);
    RegisterProperty('SelEnd', 'Integer', iptr);
    RegisterProperty('SelLength', 'Integer', iptr);
    RegisterProperty('SelStart', 'Integer', iptr);
    RegisterProperty('SelText', 'TkkString', iptr);
    RegisterProperty('ShowFormatting', 'Boolean', iptr);
    RegisterProperty('Text', 'TkkString', iptrw);
    RegisterProperty('TotalLeftOffset', 'Integer', iptr);
    RegisterProperty('TotalTopOffset', 'Integer', iptr);
    RegisterProperty('Width', 'Integer', iptr);
    RegisterProperty('OnUpdate', 'TKMemoUpdateEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoContainer', 'TKMemoTable') do
  with CL.AddClassN(CL.FindClass('TKMemoContainer'),'TKMemoTable') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Procedure ApplyDefaultCellStyle');
    RegisterMethod('Function CanAdd( AItem : TKMemoBlock) : Boolean');
    RegisterMethod('Function CalcTotalCellWidth( ACol, ARow : Integer) : Integer');
    RegisterMethod('Function CellValid( ACol, ARow : Integer) : Boolean');
    RegisterMethod('Function CellVisible( ACol, ARow : Integer) : Boolean');
    RegisterMethod('Function ColValid( ACol : Integer) : Boolean');
    RegisterMethod('Procedure FindBaseCell( ACol, ARow : Integer; out BaseCol, BaseRow : Integer)');
    RegisterMethod('Function FindCell( ACell : TKMemoTableCell; out ACol, ARow : Integer) : Boolean');
    RegisterMethod('Procedure FixupBorders');
    RegisterMethod('Procedure FixupCellSpan');
    RegisterMethod('Procedure FixupCellSpanFromRTF');
    RegisterMethod('Function RowValid( ARow : Integer) : Boolean');
    RegisterMethod('Function WordMeasureExtent( ACanvas : TCanvas; AIndex, ARequiredWidth : Integer) : TPoint');
    RegisterMethod('Function WordMouseAction( AIndex : Integer; AAction : TKMemoMouseAction; const APoint : TPoint; AShift : TShiftState) : Boolean');
    RegisterMethod('Function WordPointToIndex( ACanvas : TCanvas; const APoint : TPoint; AWordIndex : Integer; AOutOfArea, ASelectionExpanding : Boolean; out APosition : TKMemoLinePosition) : Integer');
    RegisterProperty('Cells', 'TKMemoTableCell Integer Integer', iptr);
    RegisterProperty('CellSpan', 'TKCellSpan Integer Integer', iptrw);
    RegisterProperty('CellStyle', 'TKMemoBlockStyle', iptr);
    RegisterProperty('ColCount', 'Integer', iptrw);
    RegisterProperty('ColWidths', 'Integer Integer', iptrw);
    RegisterProperty('RowCount', 'Integer', iptrw);
    RegisterProperty('RowHeights', 'Integer Integer', iptrw);
    RegisterProperty('Rows', 'TKMemoTableRow Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoTableRow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoContainer', 'TKMemoTableRow') do
  with CL.AddClassN(CL.FindClass('TKMemoContainer'),'TKMemoTableRow') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Function CanAdd( AItem : TKMemoBlock) : Boolean');
    RegisterMethod('Procedure UpdateRequiredWidth');
    RegisterProperty('CellCount', 'Integer', iptrw);
    RegisterProperty('Cells', 'TKMemoTableCell Integer', iptr);
    RegisterProperty('ParentTable', 'TKMemoTable', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoTableCell(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoContainer', 'TKMemoTableCell') do
  with CL.AddClassN(CL.FindClass('TKMemoContainer'),'TKMemoTableCell') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Function PointToIndex( ACanvas : TCanvas; const APoint : TPoint; AFirstRow, ALastRow, AOutOfArea, ASelectionExpanding : Boolean; out APosition : TKMemoLinePosition) : Integer');
    RegisterMethod('Function WordMeasureExtent( ACanvas : TCanvas; AIndex, ARequiredWidth : Integer) : TPoint');
    RegisterMethod('Procedure WordPaintToCanvas( ACanvas : TCanvas; AIndex, ALeft, ATop : Integer)');
    RegisterProperty('ParentRow', 'TKMemoTableRow', iptr);
    RegisterProperty('ParentTable', 'TKMemoTable', iptr);
    RegisterProperty('RequiredBorderWidths', 'TKRect', iptr);
    RegisterProperty('Span', 'TKCellSpan', iptrw);
    RegisterProperty('ColSpan', 'Integer', iptrw);
    RegisterProperty('RowSpan', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoBlock', 'TKMemoContainer') do
  with CL.AddClassN(CL.FindClass('TKMemoBlock'),'TKMemoContainer') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Function CalcAscent( ACanvas : TCanvas) : Integer');
    RegisterMethod('Function CanAdd( AItem : TKMemoBlock) : Boolean');
    RegisterMethod('Procedure ClearSelection( ATextOnly : Boolean)');
    RegisterMethod('Function InsertParagraph( AIndex : Integer) : Boolean');
    RegisterMethod('Function InsertString( const AText : TkkString; At : Integer) : Boolean');
    RegisterMethod('Procedure NotifyDefaultParaChange');
    RegisterMethod('Procedure NotifyDefaultTextChange');
    RegisterMethod('Function Select( ASelStart, ASelLength : Integer) : Boolean');
    RegisterMethod('Procedure SetBlockExtent( AWidth, AHeight : Integer)');
    RegisterMethod('Procedure UpdateAttributes');
    RegisterMethod('Function WordIndexToRect( ACanvas : TCanvas; AWordIndex : Integer; AIndex : Integer; ACaret : Boolean) : TRect');
    RegisterMethod('Function WordMeasureExtent( ACanvas : TCanvas; AIndex, ARequiredWidth : Integer) : TPoint');
    RegisterMethod('Function WordPointToIndex( ACanvas : TCanvas; const APoint : TPoint; AWordIndex : Integer; AOutOfArea, ASelectionExpanding : Boolean; out APosition : TKMemoLinePosition) : Integer');
    RegisterMethod('Procedure WordPaintToCanvas( ACanvas : TCanvas; AIndex, ALeft, ATop : Integer)');
    RegisterProperty('Blocks', 'TKMemoBlocks', iptr);
    RegisterProperty('BlockStyle', 'TKMemoBlockStyle', iptr);
    RegisterProperty('Clip', 'Boolean', iptrw);
    RegisterProperty('CurrentRequiredHeight', 'Integer', iptr);
    RegisterProperty('CurrentRequiredWidth', 'Integer', iptr);
    RegisterProperty('FixedHeight', 'Boolean', iptrw);
    RegisterProperty('FixedWidth', 'Boolean', iptrw);
    RegisterProperty('RequiredHeight', 'Integer', iptrw);
    RegisterProperty('RequiredWidth', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoImageBlock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoSingleton', 'TKMemoImageBlock') do
  with CL.AddClassN(CL.FindClass('TKMemoSingleton'),'TKMemoImageBlock') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Procedure Assign( ASource : TKObject)');
    RegisterMethod('Function CalcAscent( ACanvas : TCanvas) : Integer');
    RegisterMethod('Function OuterRect( ACaret : Boolean) : TRect');
    RegisterMethod('Function WordIndexToRect( ACanvas : TCanvas; AWordIndex : Integer; AIndex : Integer; ACaret : Boolean) : TRect');
    RegisterMethod('Function WordMeasureExtent( ACanvas : TCanvas; AIndex, ARequiredWidth : Integer) : TPoint');
    RegisterMethod('Function WordPointToIndex( ACanvas : TCanvas; const APoint : TPoint; AWordIndex : Integer; AOutOfArea, ASelectionExpanding : Boolean; out APosition : TKMemoLinePosition) : Integer');
    RegisterMethod('Procedure WordPaintToCanvas( ACanvas : TCanvas; AIndex, ALeft, ATop : Integer)');
    RegisterProperty('Crop', 'TKRect', iptrw);
    RegisterProperty('Image', 'TPicture', iptrw);
    RegisterProperty('ImageStyle', 'TKMemoBlockStyle', iptr);
    RegisterProperty('ImageHeight', 'Integer', iptr);
    RegisterProperty('ImageWidth', 'Integer', iptr);
    RegisterProperty('OriginalHeight', 'Integer', iptrw);
    RegisterProperty('OriginalWidth', 'Integer', iptrw);
    RegisterProperty('Path', 'TkkString', iptw);
    RegisterProperty('ScaleHeight', 'Integer', iptrw);
    RegisterProperty('ScaleWidth', 'Integer', iptrw);
    RegisterProperty('ScaleX', 'Integer', iptrw);
    RegisterProperty('ScaleY', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoParagraph(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoTextBlock', 'TKMemoParagraph') do
  with CL.AddClassN(CL.FindClass('TKMemoTextBlock'),'TKMemoParagraph') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Procedure AssignAttributes( AItem : TKMemoBlock)');
    RegisterMethod('Function Concat( AItem : TKMemoBlock) : Boolean');
    RegisterMethod('Procedure NotifyDefaultParaChange');
    RegisterMethod('Function Split( At : Integer; AllowEmpty : Boolean) : TKMemoBlock');
    RegisterMethod('Procedure WordPaintToCanvas( ACanvas : TCanvas; AWordIndex, ALeft, ATop : Integer)');
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Numbering', 'TKMemoParaNumbering', iptrw);
    RegisterProperty('NumberingList', 'TKMemoList', iptr);
    RegisterProperty('NumberingListLevel', 'TKMemoListLevel', iptr);
    RegisterProperty('NumberBlock', 'TKMemoTextBlock', iptr);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoHyperlink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoTextBlock', 'TKMemoHyperlink') do
  with CL.AddClassN(CL.FindClass('TKMemoTextBlock'),'TKMemoHyperlink') do begin
    RegisterMethod('Procedure Assign( ASource : TKObject)');
     RegisterMethod('Constructor Create');
       RegisterMethod('Procedure DefaultStyle');
     RegisterMethod('function WordMouseAction(AWordIndex:Integer; AAction:TKMemoMouseAction;const APoint:TPoint; AShift:TShiftState):Boolean;');
    RegisterProperty('URL', 'TkkString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoTextBlock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoSingleton', 'TKMemoTextBlock') do
  with CL.AddClassN(CL.FindClass('TKMemoSingleton'),'TKMemoTextBlock') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Procedure Assign( ASource : TKObject)');
    RegisterMethod('Procedure AssignAttributes( AItem : TKMemoBlock)');
    RegisterMethod('Function CalcAscent( ACanvas : TCanvas) : Integer');
    RegisterMethod('Function CalcDescent( ACanvas : TCanvas) : Integer');
    RegisterMethod('Procedure ClearSelection( ATextOnly : Boolean)');
    RegisterMethod('Function Concat( AItem : TKMemoBlock) : Boolean');
    RegisterMethod('Function EqualProperties( ASource : TKObject) : Boolean');
    RegisterMethod('Procedure GetWordIndexes( AIndex : Integer; out ASt, AEn : Integer)');
    RegisterMethod('Function InsertString( const AText : TkkString; At : Integer) : Boolean');
    RegisterMethod('Procedure NotifyDefaultTextChange');
    RegisterMethod('Function Split( At : Integer; AllowEmpty : Boolean) : TKMemoBlock');
    RegisterMethod('Function WordIndexToRect( ACanvas : TCanvas; AWordIndex : Integer; AIndex : Integer; ACaret : Boolean) : TRect');
    RegisterMethod('Function WordMeasureExtent( ACanvas : TCanvas; AIndex, ARequiredWidth : Integer) : TPoint');
    RegisterMethod('Procedure WordPaintToCanvas( ACanvas : TCanvas; AWordIndex, ALeft, ATop : Integer)');
    RegisterProperty('Text', 'TkkString', iptrw);
    RegisterProperty('TextStyle', 'TKMemoTextStyle', iptr);
    RegisterProperty('WordBreaks', 'TKSysCharSet', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoSingleton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoBlock', 'TKMemoSingleton') do
  with CL.AddClassN(CL.FindClass('TKMemoBlock'),'TKMemoSingleton') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Select( ASelStart, ASelLength : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoBlock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObject', 'TKMemoBlock') do
  with CL.AddClassN(CL.FindClass('TKObject'),'TKMemoBlock') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( ASource : TKObject)');
    RegisterMethod('Procedure AssignAttributes( AItem : TKMemoBlock)');
    RegisterMethod('Function CalcAscent( ACanvas : TCanvas) : Integer');
    RegisterMethod('Function CanAdd( AItem : TKMemoBlock) : Boolean');
    RegisterMethod('Procedure ClearSelection( ATextOnly : Boolean)');
    RegisterMethod('Function Concat( AItem : TKMemoBlock) : Boolean');
    RegisterMethod('Procedure GetWordIndexes( AIndex : Integer; out ASt, AEn : Integer)');
    RegisterMethod('Function IndexToRect( ACanvas : TCanvas; AIndex : Integer; ACaret : Boolean) : TRect');
    RegisterMethod('Function InsertParagraph( AIndex : Integer) : Boolean');
    RegisterMethod('Function InsertString( const AText : TkkString; At : Integer) : Boolean');
    RegisterMethod('Function MeasureExtent( ACanvas : TCanvas; ARequiredWidth : Integer) : TPoint');
    RegisterMethod('Procedure NotifyDefaultTextChange');
    RegisterMethod('Procedure NotifyDefaultParaChange');
    RegisterMethod('Procedure PaintToCanvas( ACanvas : TCanvas; ALeft, ATop : Integer)');
    RegisterMethod('Function PointToIndex( ACanvas : TCanvas; const APoint : TPoint; AOutOfArea, ASelectionExpanding : Boolean; out APosition : TKMemoLinePosition) : Integer');
    RegisterMethod('Procedure SelectAll');
    RegisterMethod('Function Select( ASelStart, ASelLength : Integer) : Boolean');
    RegisterMethod('Function SelectableLength( ALocalCalc : Boolean) : Integer');
    RegisterMethod('Function Split( At : Integer; AllowEmpty : Boolean) : TKMemoBlock');
    RegisterMethod('Function WordIndexToRect( ACanvas : TCanvas; AWordIndex : Integer; AIndex : Integer; ACaret : Boolean) : TRect');
    RegisterMethod('Function WordMeasureExtent( ACanvas : TCanvas; AWordIndex, ARequiredWidth : Integer) : TPoint');
    RegisterMethod('Function WordMouseAction( AWordIndex : Integer; AAction : TKMemoMouseAction; const APoint : TPoint; AShift : TShiftState) : Boolean');
    RegisterMethod('Procedure WordPaintToCanvas( ACanvas : TCanvas; AWordIndex, ALeft, ATop : Integer)');
    RegisterMethod('Function WordPointToIndex( ACanvas : TCanvas; const APoint : TPoint; AWordIndex : Integer; AOutOfArea, ASelectionExpanding : Boolean; out APosition : TKMemoLinePosition) : Integer');
    RegisterProperty('BoundsRect', 'TRect', iptr);
    RegisterProperty('BottomPadding', 'Integer', iptr);
    RegisterProperty('CanAddText', 'Boolean', iptr);
    RegisterProperty('DefaultTextStyle', 'TKMemoTextStyle', iptr);
    RegisterProperty('DefaultParaStyle', 'TKMemoParaStyle', iptr);
    RegisterProperty('Height', 'Integer', iptr);
    RegisterProperty('Left', 'Integer', iptr);
    RegisterProperty('LeftOffset', 'Integer', iptrw);
    RegisterProperty('MemoNotifier', 'IKMemoNotifier', iptr);
    RegisterProperty('PaintSelection', 'Boolean', iptr);
    RegisterProperty('ParaStyle', 'TKMemoParaStyle', iptr);
    RegisterProperty('ParentBlocks', 'TKMemoBlocks', iptr);
    RegisterProperty('Position', 'TKMemoBlockPosition', iptrw);
    RegisterProperty('Printing', 'Boolean', iptr);
    RegisterProperty('SelLength', 'Integer', iptr);
    RegisterProperty('SelStart', 'Integer', iptr);
    RegisterProperty('SelText', 'TkkString', iptr);
    RegisterProperty('ShowFormatting', 'Boolean', iptr);
    RegisterProperty('Text', 'TkkString', iptr);
    RegisterProperty('Top', 'Integer', iptr);
    RegisterProperty('TopOffset', 'Integer', iptrw);
    RegisterProperty('TopPadding', 'Integer', iptr);
    RegisterProperty('Width', 'Integer', iptr);
    RegisterProperty('WordCount', 'Integer', iptr);
    RegisterProperty('WordBaseLine', 'Integer Integer', iptrw);
    RegisterProperty('WordBreakable', 'Boolean Integer', iptr);
    RegisterProperty('WordBottomPadding', 'Integer Integer', iptrw);
    RegisterProperty('WordBoundsRect', 'TRect Integer', iptr);
    RegisterProperty('WordClipped', 'Boolean Integer', iptrw);
    RegisterProperty('WordHeight', 'Integer Integer', iptrw);
    RegisterProperty('WordLeft', 'Integer Integer', iptrw);
    RegisterProperty('WordLength', 'Integer Integer', iptr);
    RegisterProperty('Words', 'TkkString Integer', iptr);
    RegisterProperty('WordTop', 'Integer Integer', iptrw);
    RegisterProperty('WordTopPadding', 'Integer Integer', iptrw);
    RegisterProperty('WordWidth', 'Integer Integer', iptrw);
    RegisterProperty('WrapMode', 'TKMemoBlockWrapMode', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoWordList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TKMemoWordList') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TKMemoWordList') do
  begin
    RegisterProperty('Items', 'TKMemoWord Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoWord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TKMemoWord') do
  with CL.AddClassN(CL.FindClass('TObject'),'TKMemoWord') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('BaseLine', 'Integer', iptrw);
    RegisterProperty('BottomPadding', 'Integer', iptrw);
    RegisterProperty('Clipped', 'Boolean', iptrw);
    RegisterProperty('EndIndex', 'Integer', iptrw);
    RegisterProperty('Extent', 'TPoint', iptrw);
    RegisterProperty('Position', 'TPoint', iptrw);
    RegisterProperty('StartIndex', 'Integer', iptrw);
    RegisterProperty('TopPadding', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoLines(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TKMemoLines') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TKMemoLines') do
  begin
    RegisterProperty('Items', 'TKMemoLine Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoLine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TKMemoLine') do
  with CL.AddClassN(CL.FindClass('TObject'),'TKMemoLine') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('EndBlock', 'Integer', iptrw);
    RegisterProperty('EndIndex', 'Integer', iptrw);
    RegisterProperty('EndWord', 'Integer', iptrw);
    RegisterProperty('Extent', 'TPoint', iptrw);
    RegisterProperty('Position', 'TPoint', iptrw);
    RegisterProperty('StartBlock', 'Integer', iptrw);
    RegisterProperty('StartIndex', 'Integer', iptrw);
    RegisterProperty('StartWord', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoParaStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKMemoBlockStyle', 'TKMemoParaStyle') do
  with CL.AddClassN(CL.FindClass('TKMemoBlockStyle'),'TKMemoParaStyle') do
  begin
    RegisterMethod('Procedure Assign( ASource : TPersistent)');
    RegisterMethod('Procedure Defaults');
    RegisterMethod('Procedure SetNumberingListAndLevel( AListID, ALevelIndex : Integer)');
    RegisterProperty('FirstIndent', 'Integer', iptrw);
    RegisterProperty('LineSpacingFactor', 'Double', iptrw);
    RegisterProperty('LineSpacingMode', 'TKMemoLineSpacingMode', iptrw);
    RegisterProperty('LineSpacingValue', 'Integer', iptrw);
    RegisterProperty('NumberingList', 'Integer', iptrw);
    RegisterProperty('NumberingListLevel', 'Integer', iptrw);
    RegisterProperty('NumberStartAt', 'Integer', iptrw);
    RegisterProperty('WordWrap', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoBlockStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TKMemoBlockStyle') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TKMemoBlockStyle') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Procedure Assign( ASource : TPersistent)');
    RegisterMethod('Function BorderRect( const ARect : TRect) : TRect');
    RegisterMethod('Function InteriorRect( const ARect : TRect) : TRect');
    RegisterMethod('Procedure Defaults');
    RegisterMethod('Function MarginRect( const ARect : TRect) : TRect');
    RegisterMethod('Procedure NotifyChange( AValue : TKMemoBlockStyle)');
    RegisterMethod('Procedure PaintBox( ACanvas : TCanvas; const ARect : TRect)');
    RegisterProperty('AllPaddingsBottom', 'Integer', iptr);
    RegisterProperty('AllPaddingsLeft', 'Integer', iptr);
    RegisterProperty('AllPaddingsRight', 'Integer', iptr);
    RegisterProperty('AllPaddingsTop', 'Integer', iptr);
    RegisterProperty('BottomBorderWidth', 'Integer', iptr);
    RegisterProperty('BottomMargin', 'Integer', iptrw);
    RegisterProperty('BottomPadding', 'Integer', iptrw);
    RegisterProperty('BorderRadius', 'Integer', iptrw);
    RegisterProperty('BorderColor', 'TColor', iptrw);
    RegisterProperty('BorderWidth', 'Integer', iptrw);
    RegisterProperty('BorderWidths', 'TKRect', iptrw);
    RegisterProperty('Brush', 'TBrush', iptrw);
    RegisterProperty('ContentMargin', 'TKRect', iptrw);
    RegisterProperty('ContentPadding', 'TKRect', iptrw);
    RegisterProperty('FillBlip', 'TGraphic', iptrw);
    RegisterProperty('HAlign', 'TKHAlign', iptrw);
    RegisterProperty('LeftBorderWidth', 'Integer', iptr);
    RegisterProperty('LeftMargin', 'Integer', iptrw);
    RegisterProperty('LeftPadding', 'Integer', iptrw);
    RegisterProperty('RightBorderWidth', 'Integer', iptr);
    RegisterProperty('RightMargin', 'Integer', iptrw);
    RegisterProperty('RightPadding', 'Integer', iptrw);
    RegisterProperty('StyleChanged', 'Boolean', iptrw);
    RegisterProperty('TopBorderWidth', 'Integer', iptr);
    RegisterProperty('TopMargin', 'Integer', iptrw);
    RegisterProperty('TopPadding', 'Integer', iptrw);
    RegisterProperty('WrapMode', 'TKMemoBlockWrapMode', iptrw);
    RegisterProperty('OnChanged', 'TKMemoBlockStyleChangedEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoTextStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TKMemoTextStyle') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TKMemoTextStyle') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Procedure Assign( ASource : TPersistent)');
    RegisterMethod('Procedure Defaults');
    RegisterMethod('Function EqualProperties( ASource : TKMemoTextStyle) : Boolean');
    RegisterMethod('Procedure NotifyChange( AValue : TKMemoTextStyle)');
    RegisterProperty('AllowBrush', 'Boolean', iptrw);
    RegisterProperty('Capitals', 'TKMemoScriptCapitals', iptrw);
    RegisterProperty('Brush', 'TBrush', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('ScriptPosition', 'TKMemoScriptPosition', iptrw);
    RegisterProperty('StyleChanged', 'Boolean', iptrw);
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoListTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObjectList', 'TKMemoListTable') do
  with CL.AddClassN(CL.FindClass('TKObjectList'),'TKMemoListTable') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure ClearLevelCounters');
    RegisterMethod('Function FindByID( AListID : Integer) : TKMemoList');
    RegisterMethod('Procedure ListChanged( AList : TKMemoList; ALevel : TKMemoListLevel)');
    RegisterMethod('Function ListByNumbering( AListID, ALevelIndex : Integer; ANumbering : TKMemoParaNumbering) : TKMemoList');
    RegisterMethod('Function NextID : Integer');
    RegisterProperty('Items', 'TKMemoList Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('OnChanged', 'TKMemoListChangedEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObject', 'TKMemoList') do
  with CL.AddClassN(CL.FindClass('TKObject'),'TKMemoList') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Procedure Assign( ASource : TKObject)');
    RegisterMethod('Procedure LevelChanged( ALevel : TKMemoListLevel)');
    RegisterProperty('ID', 'Integer', iptrw);
    RegisterProperty('Levels', 'TKMemoListLevels', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoListLevels(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObjectList', 'TKMemoListLevels') do
  with CL.AddClassN(CL.FindClass('TKObjectList'),'TKMemoListLevels') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Changed( ALevel : TKMemoListLevel)');
    RegisterMethod('Procedure ClearLevelCounters( AFromLevel : Integer)');
    RegisterProperty('Items', 'TKMemoListLevel Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('Parent', 'TKMemoList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoListLevel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObject', 'TKMemoListLevel') do
  with CL.AddClassN(CL.FindClass('TKObject'),'TKMemoListLevel') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');

    RegisterMethod('Procedure Assign( ASource : TKObject)');
    RegisterProperty('LevelCounter', 'Integer', iptrw);
    RegisterProperty('FirstIndent', 'Integer', iptrw);
    RegisterProperty('LeftIndent', 'Integer', iptrw);
    RegisterProperty('Numbering', 'TKMemoParaNumbering', iptrw);
    RegisterProperty('NumberingFont', 'TFont', iptr);
    RegisterProperty('NumberingFontChanged', 'Boolean', iptr);
    RegisterProperty('NumberingFormat', 'TKMemoNumberingFormat', iptr);
    RegisterProperty('NumberStartAt', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoNumberingFormat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObjectList', 'TKMemoNumberingFormat') do
  with CL.AddClassN(CL.FindClass('TKObjectList'),'TKMemoNumberingFormat') do
  begin
    RegisterMethod('Procedure AddItem( ALevel : Integer; const AText : TkkString)');
    RegisterMethod('Procedure Defaults( ANumbering : TKMemoParaNumbering; ALevelIndex : Integer)');
    RegisterMethod('Procedure InsertItem( AAt, ALevel : Integer; const AText : TkkString)');
    RegisterProperty('Items', 'TKMemoNumberingFormatItem Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('LevelCount', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoNumberingFormatItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObject', 'TKMemoNumberingFormatItem') do
  with CL.AddClassN(CL.FindClass('TKObject'),'TKMemoNumberingFormatItem') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( ASource : TKObject)');
    RegisterProperty('Level', 'Integer', iptrw);
    RegisterProperty('Text', 'TkkString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoDictionary(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObjectList', 'TKMemoDictionary') do
  with CL.AddClassN(CL.FindClass('TKObjectList'),'TKMemoDictionary') do
  begin
    RegisterMethod('Procedure AddItem( AIndex, AValue : Integer)');
    RegisterMethod('Function FindItem( AIndex : Integer) : TKMemoDictionaryItem');
    RegisterMethod('Function GetValue( AIndex, ADefault : Integer) : Integer');
    RegisterMethod('Procedure SetValue( AIndex, AValue : Integer)');
    RegisterProperty('Items', 'TKMemoDictionaryItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoDictionaryItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObject', 'TKMemoDictionaryItem') do
  with CL.AddClassN(CL.FindClass('TKObject'),'TKMemoDictionaryItem') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( ASource : TKObject)');
    RegisterMethod('Function EqualProperties( ASource : TKObject) : Boolean');
    RegisterProperty('Index', 'Integer', iptrw);
    RegisterProperty('Value', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoSparseStack(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStack', 'TKMemoSparseStack') do
  with CL.AddClassN(CL.FindClass('TStack'),'TKMemoSparseStack') do
  begin
    RegisterMethod('Function Push( AObject : TKMemoSparseItem) : TKMemoSparseItem');
    RegisterMethod('Function Pop : TKMemoSparseItem');
    RegisterMethod('Function Peek : TKMemoSparseItem');
    RegisterMethod('Procedure PushValue( Value : Integer)');
    RegisterMethod('Function PopValue : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoSparseList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObjectList', 'TKMemoSparseList') do
  with CL.AddClassN(CL.FindClass('TKObjectList'),'TKMemoSparseList') do
  begin
    RegisterMethod('Procedure AddItem( AValue : Integer)');
    RegisterMethod('Procedure SetSize( ACount : Integer)');
    RegisterProperty('Items', 'TKMemoSparseItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoSparseItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKObject', 'TKMemoSparseItem') do
  with CL.AddClassN(CL.FindClass('TKObject'),'TKMemoSparseItem') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( ASource : TKObject)');
    RegisterMethod('Function EqualProperties( ASource : TKObject) : Boolean');
    RegisterProperty('Index', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_KMemo(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cUndoLimitMin','LongInt').SetInt( 100);
 CL.AddConstantN('cUndoLimitMax','LongInt').SetInt( 10000);
 CL.AddConstantN('cUndoLimitDef','LongInt').SetInt( 1000);
 CL.AddConstantN('cScrollPaddingMin','LongInt').SetInt( 0);
 CL.AddConstantN('cScrollPaddingMax','LongInt').SetInt( 1000);
 CL.AddConstantN('cScrollPaddingDef','LongInt').SetInt( 30);
 CL.AddConstantN('cScrollSpeedMin','LongInt').SetInt( 50);
 CL.AddConstantN('cScrollSpeedMax','LongInt').SetInt( 1000);
 CL.AddConstantN('cScrollSpeedDef','LongInt').SetInt( 100);
 //CL.AddConstantN('cBkGndDef','').SetString( clWindow);
 //CL.AddConstantN('cInactiveCaretBkGndDef','').SetString( clBlack);
 //CL.AddConstantN('cInactiveCaretSelBkGndDef','').SetString( clBlack);
 //CL.AddConstantN('cInactiveCaretSelTextDef','').SetString( clYellow);
 //CL.AddConstantN('cInactiveCaretTextDef','').SetString( clYellow);
 //CL.AddConstantN('cSelBkGndDef','').SetString( clGrayText);
 //CL.AddConstantN('cSelBkGndFocusedDef','').SetString( clHighlight);
 //CL.AddConstantN('cSelTextDef','').SetString( clHighlightText);
 //CL.AddConstantN('cSelTextFocusedDef','').SetString( clHighlightText);
 CL.AddConstantN('ciBkGnd','LongInt').SetInt( TKColorIndex ( 0 ));
 CL.AddConstantN('ciInactiveCaretBkGnd','LongInt').SetInt( TKColorIndex ( 1 ));
 CL.AddConstantN('ciInactiveCaretSelBkGnd','LongInt').SetInt( TKColorIndex ( 2 ));
 CL.AddConstantN('ciInactiveCaretSelText','LongInt').SetInt( TKColorIndex ( 3 ));
 CL.AddConstantN('ciInactiveCaretText','LongInt').SetInt( TKColorIndex ( 4 ));
 CL.AddConstantN('ciSelBkGnd','LongInt').SetInt( TKColorIndex ( 5 ));
 CL.AddConstantN('ciSelBkGndFocused','LongInt').SetInt( TKColorIndex ( 6 ));
 CL.AddConstantN('ciSelText','LongInt').SetInt( TKColorIndex ( 7 ));
 CL.AddConstantN('ciSelTextFocused','LongInt').SetInt( TKColorIndex ( 8 ));
 //CL.AddConstantN('ciMemoColorsMax','').SetString( ciSelTextFocused);
 CL.AddConstantN('cInvalidListID','LongInt').SetInt( - 1);
 CL.AddConstantN('cHorzScrollStepDef','LongInt').SetInt( 4);
 CL.AddConstantN('cVertScrollStepDef','LongInt').SetInt( 10);
 //CL.AddConstantN('cHeight','LongInt').SetInt( 200);
 //CL.AddConstantN('cWidth','LongInt').SetInt( 300);
 CL.AddConstantN('cNewLineChar','Char').SetString( #$B6);
 CL.AddConstantN('cSpaceChar','Char').SetString( #$B7);
 CL.AddConstantN('cTabChar','Char').SetString( #$2192);
 CL.AddConstantN('cBullet','Char').SetString( #$2022);
 CL.AddConstantN('cSquareBullet','Char').SetString( #$25AB);
 CL.AddConstantN('cArrowBullet','Char').SetString( #$25BA);
 //CL.AddConstantN('cDefaultWordBreaks','String').SetString(' ' or  '/' or  '\' or  ';' or  ':' or  '?' or  '!');
 CL.AddConstantN('cRichText','String').SetString( 'Rich Text Format');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKCustomMemo');
  CL.AddTypeS('TKMemoLinePosition', '( eolInside, eolEnd )');
  CL.AddTypeS('TKMemoBlockPosition', '( mbpText, mbpRelative, mbpAbsolute )');
  CL.AddTypeS('TKMemoState', '( elCaretCreated, elCaretVisible, elCaretUpdate, '
   +'elIgnoreNextChar, elModified, elMouseCapture, elOverwrite, elReadOnly )');
  CL.AddTypeS('TKMemoStates', 'set of TKMemoState');
  CL.AddTypeS('TKMemoUpdateReason', '( muContent, muExtent, muSelection, muSelectionScroll )');
  CL.AddTypeS('TKMemoUpdateReasons', 'set of TKMemoUpdateReason');
  SIRegister_TKMemoSparseItem(CL);
  SIRegister_TKMemoSparseList(CL);
  SIRegister_TKMemoSparseStack(CL);
  SIRegister_TKMemoDictionaryItem(CL);
  SIRegister_TKMemoDictionary(CL);
  CL.AddTypeS('TKMemoParaNumbering', '( pnuNone, pnuBullets, pnuArabic, pnuLett'
   +'erLo, pnuLetterHi, pnuRomanLo, pnuRomanHi )');
  SIRegister_TKMemoNumberingFormatItem(CL);
  SIRegister_TKMemoNumberingFormat(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKMemoListLevels');
  SIRegister_TKMemoListLevel(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKMemoList');
  SIRegister_TKMemoListLevels(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKMemoListTable');
  SIRegister_TKMemoList(CL);
  CL.AddTypeS('TKMemoListChangedEvent', 'Procedure ( AList : TKMemoList; ALevel: TKMemoListLevel)');
  CL.AddTypeS('TKEditDropFilesEvent', 'procedure(Sender: TObject; X, Y: integer; Files: TStrings)');

   //TKEditReplaceTextEvent = procedure(Sender: TObject; const TextToFind, TextToReplace:
   // string; var Action: TKEditReplaceAction) of object;

   // TKEditDropFilesEvent = procedure(Sender: TObject; X, Y: integer;  Files: TStrings) of object;
   CL.AddTypeS('TKEditOption', '( eoDropFiles1, eoGroupUndo, eoUndoAfterSave, eoShowFormatting, eoWantTab)');
  CL.AddTypeS('TKEditOptions', 'set of TKEditOption');

  {TKEditKey = record
    Key: Word;
    Shift: TShiftState;
  end;}
  CL.AddTypeS('TKEditKey', 'record key:word; shift: TShiftState; end;');

  (*  CL.AddTypeS('TKEditCommand','(ecNonek, ecLeftk, ecRightk, ecUpk, ecDownk, ecLineStartk, ecLineEndk, ecPageUpk,'+
    'ecPageDownk,  ecPageLeftk,  ecPageRightk, ecPageTopk,  ecPageBottomk,  ecEditorTopk,  ecEditorBottomk,'+
    { Move caret to specific coordinates, Data = ^TPoint }
    'ecGotoXYk,  ecSelLeftk, ecSelRightk, ecSelUpk, ecSelDownk, ecSelLineStartk, ecSelLineEndk, ecSelPageUpk,'+
    { Move caret down one page, affecting selection }
    'ecSelPageDownk, ecSelPageLeftk, ecSelPageRightk, ecSelPageTopk, ecSelPageBottomk, ecSelEditorTopk, ecSelEditorBottomk,'+
    'ecSelGotoXYk, ecScrollUpk, ecScrollDownk,  ecScrollLeftk,  ecScrollRightk, ecScrollCenterk, ecUndok,'+
    'ecRedok, ecCopyk, ecCutk, ecPastek,ecInsertChark,ecInsertDigitsk,ecInsertStringk,ecInsertNewLinek,ecDeleteLastChark,'+
    'ecDeleteChark,ecDeleteBOLk,ecDeleteEOLk,ecDeleteLinek,ecSelectAllk,ecClearAllk,ecClearIndexSelectionk,'+
    'ecClearSelectionk,ecSearchk,ecReplacek,ecInsertModek,ecOverwriteModek,ecToggleModek,ecGotFocusk,ecLostFocusk)');
   CL.AddTypeS('TKEditDisabledDrawStyle', '( eddBright, eddGrayed, eddNormal )');
  CL.AddTypeS('TKEditKey', 'record Key : Word; Shift : TShiftState; end');
  CL.AddTypeS('TKEditCommandAssignment', 'record Key : TKEditKey; Command : TKEditCommand; end');
  CL.AddTypeS('TKEditCommandMap', 'array of TKEditCommandAssignment');
    *)

  (*  { Declares options - possible values for the edit control's Options property }
  TKEditOption = (
    { The editor will receive dropped files }
    eoDropFiles,
    { All undo/redo operations of the same kind will be grouped together }
    eoGroupUndo,
    { The editor allows undo/redo operations after the edit control's Modified property
      has been set to False }
    eoUndoAfterSave,
    { TKMemo only: show formatting markers. }
    eoShowFormatting,
    { TKMemo only: acquire TAB characters. }
    eoWantTab
  ); *)

  { Options can be arbitrary combined }
  //TKEditOptions = set of TKEditOption;


  SIRegister_TKMemoListTable(CL);
  CL.AddTypeS('TKMemoScriptCapitals', '( tcaNone, tcaNormal, tcaSmall )');
  CL.AddTypeS('TKMemoScriptPosition', '( tpoNormal, tpoSuperscript, tpoSubscript )');
  SIRegister_TKMemoTextStyle(CL);
  CL.AddTypeS('TKMemoBlockWrapMode', '( wrAround, wrAroundLeft, wrAroundRight, '
   +'wrTight, wrTightLeft, wrTightRight, wrTopBottom, wrNone, wrUnknown )');
  CL.AddTypeS('TKMemoBlockStyleChangedEvent', 'Procedure ( Sender : TObject; AR'
   +'easons : TKMemoUpdateReasons)');
  SIRegister_TKMemoBlockStyle(CL);
  CL.AddTypeS('TKMemoLineSpacingMode', '( lsmFactor, lsmValue )');
  SIRegister_TKMemoParaStyle(CL);
  SIRegister_TKMemoLine(CL);
  SIRegister_TKMemoLines(CL);
  SIRegister_TKMemoWord(CL);
  SIRegister_TKMemoWordList(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKMemoBlocks');
  CL.AddTypeS('TKMemoMouseAction', '( maMove, maLeftDown, maLeftUp, maRightDown'
   +', maRightUp, maMidDown, maMidUp )');
  //CL.AddTypeS('TKMemoBlockClass', 'class of TKMemoBlock');
  SIRegister_TKMemoBlock(CL);
  SIRegister_TKMemoSingleton(CL);
  SIRegister_TKMemoTextBlock(CL);
  SIRegister_TKMemoHyperlink(CL);
  SIRegister_TKMemoParagraph(CL);
  SIRegister_TKMemoImageBlock(CL);
  SIRegister_TKMemoContainer(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKMemoTable');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKMemoTableRow');
  SIRegister_TKMemoTableCell(CL);
  SIRegister_TKMemoTableRow(CL);
  SIRegister_TKMemoTable(CL);
  CL.AddTypeS('TKMemoUpdateEvent', 'Procedure ( Reasons : TKMemoUpdateReasons)');
  SIRegister_TKMemoBlocks(CL);
  SIRegister_TKMemoColors(CL);
  CL.AddTypeS('TKMemoChangeKind', '( ckCaretPos, ckDelete, ckInsert )');
  CL.AddTypeS('TKMemoUndoChangeEvent', 'Procedure ( Sender : TObject; ItemReason : TKMemoChangeKind)');
  CL.AddTypeS('TKMemoChangeItem', 'record Blocks : TKMemoBlocks; Group : Cardin'
   +'al; GroupKind : TKMemoChangeKind; Inserted : Boolean; ItemKind : TKMemoCha'
   +'ngeKind; Position : Integer; end');
  //CL.AddTypeS('PKMemoChangeItem', '^TKMemoChangeItem // will not work');
  SIRegister_TKMemoChangeList(CL);
  CL.AddTypeS('TKMemoRTFString', 'string');
  SIRegister_TKCustomMemo(CL);
  SIRegister_TKMemo(CL);
  SIRegister_TKMemoEditAction(CL);
  SIRegister_TKMemoEditCopyAction(CL);
  SIRegister_TKMemoEditCutAction(CL);
  SIRegister_TKMemoEditPasteAction(CL);
  SIRegister_TKMemoEditSelectAllAction(CL);
 CL.AddDelphiFunction('Function NewLineChar : TKkString');
 CL.AddDelphiFunction('Function SpaceChar : TKkString');
 CL.AddDelphiFunction('Function TabChar : TKkString');
  CL.AddDelphiFunction('Function FindRootDesigner( Obj : TPersistent) : IDesignerNotify');
  CL.AddDelphiFunction('function FontToOleFont(Font: TFont): Variant;');
 CL.AddDelphiFunction('procedure OleFontToFont(const OleFont: Variant; Font: TFont)');

  //function FontToOleFont(Font: TFont): Variant;
 //procedure OleFontToFont(const OleFont: Variant; Font: TFont);


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TKCustomMemoOnReplaceText_W(Self: TKCustomMemo; const T: TKEditReplaceTextEvent);
begin Self.OnReplaceText := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoOnReplaceText_R(Self: TKCustomMemo; var T: TKEditReplaceTextEvent);
begin T := Self.OnReplaceText; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoOnDropFiles_W(Self: TKCustomMemo; const T: TKEditDropFilesEvent);
begin Self.OnDropFiles := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoOnDropFiles_R(Self: TKCustomMemo; var T: TKEditDropFilesEvent);
begin T := Self.OnDropFiles; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoOnChange_W(Self: TKCustomMemo; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoOnChange_R(Self: TKCustomMemo; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoWordBreaks_W(Self: TKCustomMemo; const T: TKSysCharSet);
begin Self.WordBreaks := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoWordBreaks_R(Self: TKCustomMemo; var T: TKSysCharSet);
begin T := Self.WordBreaks; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoVertScrollPadding_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.VertScrollPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoUndoLimit_W(Self: TKCustomMemo; const T: Integer);
begin Self.UndoLimit := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoUndoLimit_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.UndoLimit; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoTopPos_W(Self: TKCustomMemo; const T: Integer);
begin Self.TopPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoTopPos_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.TopPos; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoTextStyle_R(Self: TKCustomMemo; var T: TKMemoTextStyle);
begin T := Self.TextStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoText_W(Self: TKCustomMemo; const T: TKString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoText_R(Self: TKCustomMemo; var T: TKString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelText_R(Self: TKCustomMemo; var T: TKString);
begin T := Self.SelText; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelStart_W(Self: TKCustomMemo; const T: Integer);
begin Self.SelStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelStart_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.SelStart; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelLength_W(Self: TKCustomMemo; const T: Integer);
begin Self.SelLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelLength_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.SelLength; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelEnd_W(Self: TKCustomMemo; const T: Integer);
begin Self.SelEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelEnd_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.SelEnd; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelectionTextStyle_W(Self: TKCustomMemo; const T: TKMemoTextStyle);
begin Self.SelectionTextStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelectionTextStyle_R(Self: TKCustomMemo; var T: TKMemoTextStyle);
begin T := Self.SelectionTextStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelectionParaStyle_W(Self: TKCustomMemo; const T: TKMemoParaStyle);
begin Self.SelectionParaStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelectionParaStyle_R(Self: TKCustomMemo; var T: TKMemoParaStyle);
begin T := Self.SelectionParaStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelectionHasPara_R(Self: TKCustomMemo; var T: Boolean);
begin T := Self.SelectionHasPara; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelectableLength_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.SelectableLength; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoSelAvail_R(Self: TKCustomMemo; var T: Boolean);
begin T := Self.SelAvail; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoScrollPadding_W(Self: TKCustomMemo; const T: Integer);
begin Self.ScrollPadding := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoScrollPadding_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.ScrollPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoScrollSpeed_W(Self: TKCustomMemo; const T: Cardinal);
begin Self.ScrollSpeed := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoScrollSpeed_R(Self: TKCustomMemo; var T: Cardinal);
begin T := Self.ScrollSpeed; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoScrollBars_W(Self: TKCustomMemo; const T: TScrollStyle);
begin Self.ScrollBars := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoScrollBars_R(Self: TKCustomMemo; var T: TScrollStyle);
begin T := Self.ScrollBars; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoRTF_W(Self: TKCustomMemo; const T: TKMemoRTFString);
begin Self.RTF := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoRTF_R(Self: TKCustomMemo; var T: TKMemoRTFString);
begin T := Self.RTF; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoRequiredContentWidth_W(Self: TKCustomMemo; const T: Integer);
begin Self.RequiredContentWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoRequiredContentWidth_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.RequiredContentWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoRealSelStart_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.RealSelStart; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoRealSelEnd_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.RealSelEnd; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoReadOnly_W(Self: TKCustomMemo; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoReadOnly_R(Self: TKCustomMemo; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoParaStyle_R(Self: TKCustomMemo; var T: TKMemoParaStyle);
begin T := Self.ParaStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoOptions_W(Self: TKCustomMemo; const T: TKEditOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoOptions_R(Self: TKCustomMemo; var T: TKEditOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoNearestParagraph_R(Self: TKCustomMemo; var T: TKMemoParagraph);
begin T := Self.NearestParagraph; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoModified_W(Self: TKCustomMemo; const T: Boolean);
begin Self.Modified := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoModified_R(Self: TKCustomMemo; var T: Boolean);
begin T := Self.Modified; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoListTable_R(Self: TKCustomMemo; var T: TKMemoListTable);
begin T := Self.ListTable; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoLeftPos_W(Self: TKCustomMemo; const T: Integer);
begin Self.LeftPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoLeftPos_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.LeftPos; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoKeyMapping_R(Self: TKCustomMemo; var T: TKEditKeyMapping);
begin T := Self.KeyMapping; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoInsertMode_R(Self: TKCustomMemo; var T: Boolean);
begin T := Self.InsertMode; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoHorzScrollPadding_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.HorzScrollPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoEmpty_R(Self: TKCustomMemo; var T: Boolean);
begin T := Self.Empty; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoDisabledDrawStyle_W(Self: TKCustomMemo; const T: TKEditDisabledDrawStyle);
begin Self.DisabledDrawStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoDisabledDrawStyle_R(Self: TKCustomMemo; var T: TKEditDisabledDrawStyle);
begin T := Self.DisabledDrawStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoContentWidth_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.ContentWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoContentTop_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.ContentTop; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoContentRect_R(Self: TKCustomMemo; var T: TRect);
begin T := Self.ContentRect; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoContentLeft_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.ContentLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoContentHeight_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.ContentHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoContentPadding_R(Self: TKCustomMemo; var T: TKRect);
begin T := Self.ContentPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoColors_W(Self: TKCustomMemo; const T: TKMemoColors);
begin Self.Colors := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoColors_R(Self: TKCustomMemo; var T: TKMemoColors);
begin T := Self.Colors; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoCaretVisible_R(Self: TKCustomMemo; var T: Boolean);
begin T := Self.CaretVisible; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoCaretPos_R(Self: TKCustomMemo; var T: Integer);
begin T := Self.CaretPos; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoBackgroundImage_R(Self: TKCustomMemo; var T: TPicture);
begin T := Self.BackgroundImage; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoBlocks_R(Self: TKCustomMemo; var T: TKMemoBlocks);
begin T := Self.Blocks; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoActiveInnerBlocks_R(Self: TKCustomMemo; var T: TKMemoBlocks);
begin T := Self.ActiveInnerBlocks; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoActiveBlocks_R(Self: TKCustomMemo; var T: TKMemoBlocks);
begin T := Self.ActiveBlocks; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoActiveInnerBlock_R(Self: TKCustomMemo; var T: TKMemoBlock);
begin T := Self.ActiveInnerBlock; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomMemoActiveBlock_R(Self: TKCustomMemo; var T: TKMemoBlock);
begin T := Self.ActiveBlock; end;

(*----------------------------------------------------------------------------*)
Procedure TKCustomMemoSelectionInit1_P(Self: TKCustomMemo;  const APoint : TPoint; ADoScroll : Boolean);
Begin //Self.SelectionInit(APoint, ADoScroll);
END;

(*----------------------------------------------------------------------------*)
Procedure TKCustomMemoSelectionInit_P(Self: TKCustomMemo;  ASelStart : Integer; ADoScroll : Boolean; APosition : TKMemoLinePosition);
Begin //Self.SelectionInit(ASelStart, ADoScroll, APosition);
END;

(*----------------------------------------------------------------------------*)
Procedure TKCustomMemoSelectionExpand2_P(Self: TKCustomMemo;  const APoint : TPoint; ADoScroll : Boolean);
Begin //Self.SelectionExpand(APoint, ADoScroll);
END;

(*----------------------------------------------------------------------------*)
Procedure TKCustomMemoSelectionExpand_P(Self: TKCustomMemo;  ASelEnd : Integer; ADoScroll : Boolean; APosition : TKMemoLinePosition);
Begin //Self.SelectionExpand(ASelEnd, ADoScroll, APosition);
END;

(*----------------------------------------------------------------------------*)
procedure TKMemoChangeListOnChange_W(Self: TKMemoChangeList; const T: TKMemoUndoChangeEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoChangeListOnChange_R(Self: TKMemoChangeList; var T: TKMemoUndoChangeEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoChangeListModified_W(Self: TKMemoChangeList; const T: Boolean);
begin Self.Modified := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoChangeListModified_R(Self: TKMemoChangeList; var T: Boolean);
begin T := Self.Modified; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoChangeListLimit_W(Self: TKMemoChangeList; const T: Integer);
begin Self.Limit := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoChangeListLimit_R(Self: TKMemoChangeList; var T: Integer);
begin T := Self.Limit; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsSelTextFocused_W(Self: TKMemoColors; const T: TColor);
begin Self.SelTextFocused := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsSelTextFocused_R(Self: TKMemoColors; var T: TColor);
begin T := Self.SelTextFocused; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsSelText_W(Self: TKMemoColors; const T: TColor);
begin Self.SelText := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsSelText_R(Self: TKMemoColors; var T: TColor);
begin T := Self.SelText; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsSelBkGndFocused_W(Self: TKMemoColors; const T: TColor);
begin Self.SelBkGndFocused := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsSelBkGndFocused_R(Self: TKMemoColors; var T: TColor);
begin T := Self.SelBkGndFocused; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsSelBkGnd_W(Self: TKMemoColors; const T: TColor);
begin Self.SelBkGnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsSelBkGnd_R(Self: TKMemoColors; var T: TColor);
begin T := Self.SelBkGnd; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsInactiveCaretText_W(Self: TKMemoColors; const T: TColor);
begin Self.InactiveCaretText := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsInactiveCaretText_R(Self: TKMemoColors; var T: TColor);
begin T := Self.InactiveCaretText; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsInactiveCaretSelText_W(Self: TKMemoColors; const T: TColor);
begin Self.InactiveCaretSelText := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsInactiveCaretSelText_R(Self: TKMemoColors; var T: TColor);
begin T := Self.InactiveCaretSelText; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsInactiveCaretSelBkGnd_W(Self: TKMemoColors; const T: TColor);
begin Self.InactiveCaretSelBkGnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsInactiveCaretSelBkGnd_R(Self: TKMemoColors; var T: TColor);
begin T := Self.InactiveCaretSelBkGnd; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsInactiveCaretBkGnd_W(Self: TKMemoColors; const T: TColor);
begin Self.InactiveCaretBkGnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsInactiveCaretBkGnd_R(Self: TKMemoColors; var T: TColor);
begin T := Self.InactiveCaretBkGnd; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsBkGnd_W(Self: TKMemoColors; const T: TColor);
begin Self.BkGnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoColorsBkGnd_R(Self: TKMemoColors; var T: TColor);
begin T := Self.BkGnd; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksOnUpdate_W(Self: TKMemoBlocks; const T: TKMemoUpdateEvent);
begin Self.OnUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksOnUpdate_R(Self: TKMemoBlocks; var T: TKMemoUpdateEvent);
begin T := Self.OnUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksWidth_R(Self: TKMemoBlocks; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksTotalTopOffset_R(Self: TKMemoBlocks; var T: Integer);
begin T := Self.TotalTopOffset; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksTotalLeftOffset_R(Self: TKMemoBlocks; var T: Integer);
begin T := Self.TotalLeftOffset; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksText_W(Self: TKMemoBlocks; const T: TKString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksText_R(Self: TKMemoBlocks; var T: TKString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksShowFormatting_R(Self: TKMemoBlocks; var T: Boolean);
begin T := Self.ShowFormatting; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksSelText_R(Self: TKMemoBlocks; var T: TKString);
begin T := Self.SelText; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksSelStart_R(Self: TKMemoBlocks; var T: Integer);
begin T := Self.SelStart; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksSelLength_R(Self: TKMemoBlocks; var T: Integer);
begin T := Self.SelLength; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksSelEnd_R(Self: TKMemoBlocks; var T: Integer);
begin T := Self.SelEnd; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksSelectionTextStyle_W(Self: TKMemoBlocks; const T: TKMemoTextStyle);
begin Self.SelectionTextStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksSelectionTextStyle_R(Self: TKMemoBlocks; var T: TKMemoTextStyle);
begin T := Self.SelectionTextStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksSelectionParaStyle_W(Self: TKMemoBlocks; const T: TKMemoParaStyle);
begin Self.SelectionParaStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksSelectionParaStyle_R(Self: TKMemoBlocks; var T: TKMemoParaStyle);
begin T := Self.SelectionParaStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksSelectionHasPara_R(Self: TKMemoBlocks; var T: Boolean);
begin T := Self.SelectionHasPara; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksSelectableLength_R(Self: TKMemoBlocks; var T: Integer);
begin T := Self.SelectableLength; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksRealSelStart_R(Self: TKMemoBlocks; var T: Integer);
begin T := Self.RealSelStart; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksRealSelEnd_R(Self: TKMemoBlocks; var T: Integer);
begin T := Self.RealSelEnd; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksParentBlocks_R(Self: TKMemoBlocks; var T: TKMemoBlocks);
begin T := Self.ParentBlocks; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksParent_W(Self: TKMemoBlocks; const T: TKMemoBlock);
begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksParent_R(Self: TKMemoBlocks; var T: TKMemoBlock);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksMemoNotifier_W(Self: TKMemoBlocks; const T: IKMemoNotifier);
begin Self.MemoNotifier := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksMemoNotifier_R(Self: TKMemoBlocks; var T: IKMemoNotifier);
begin T := Self.MemoNotifier; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineWidth_R(Self: TKMemoBlocks; var T: Integer; const t1: Integer);
begin T := Self.LineWidth[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineStartIndex_R(Self: TKMemoBlocks; var T: Integer; const t1: Integer);
begin T := Self.LineStartIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineSize_R(Self: TKMemoBlocks; var T: Integer; const t1: Integer);
begin T := Self.LineSize[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLines_R(Self: TKMemoBlocks; var T: TKMemoLines);
begin T := Self.Lines; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineText_W(Self: TKMemoBlocks; const T: TKString; const t1: Integer);
begin Self.LineText[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineText_R(Self: TKMemoBlocks; var T: TKString; const t1: Integer);
begin T := Self.LineText[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineRect_R(Self: TKMemoBlocks; var T: TRect; const t1: Integer);
begin T := Self.LineRect[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineTop_R(Self: TKMemoBlocks; var T: Integer; const t1: Integer);
begin T := Self.LineTop[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineRight_R(Self: TKMemoBlocks; var T: Integer; const t1: Integer);
begin T := Self.LineRight[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineLeft_R(Self: TKMemoBlocks; var T: Integer; const t1: Integer);
begin T := Self.LineLeft[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineHeight_R(Self: TKMemoBlocks; var T: Integer; const t1: Integer);
begin T := Self.LineHeight[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineInfo_R(Self: TKMemoBlocks; var T: TKMemoLine; const t1: Integer);
begin T := Self.LineInfo[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineFloat_R(Self: TKMemoBlocks; var T: Boolean; const t1: Integer);
begin T := Self.LineFloat[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineEndIndex_R(Self: TKMemoBlocks; var T: Integer; const t1: Integer);
begin T := Self.LineEndIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineCount_R(Self: TKMemoBlocks; var T: Integer);
begin T := Self.LineCount; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksLineBottom_R(Self: TKMemoBlocks; var T: Integer; const t1: Integer);
begin T := Self.LineBottom[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksItems_W(Self: TKMemoBlocks; const T: TKMemoBlock; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksItems_R(Self: TKMemoBlocks; var T: TKMemoBlock; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksIgnoreParaMark_W(Self: TKMemoBlocks; const T: Boolean);
begin Self.IgnoreParaMark := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksIgnoreParaMark_R(Self: TKMemoBlocks; var T: Boolean);
begin T := Self.IgnoreParaMark; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksHeight_R(Self: TKMemoBlocks; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksEmpty_R(Self: TKMemoBlocks; var T: Boolean);
begin T := Self.Empty; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksDefaultParaStyle_R(Self: TKMemoBlocks; var T: TKMemoParaStyle);
begin T := Self.DefaultParaStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksDefaultTextStyle_R(Self: TKMemoBlocks; var T: TKMemoTextStyle);
begin T := Self.DefaultTextStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlocksBoundsRect_R(Self: TKMemoBlocks; var T: TRect);
begin T := Self.BoundsRect; end;

(*----------------------------------------------------------------------------*)
Function TKMemoBlocksAddHyperlink1_P(Self: TKMemoBlocks;  AItem : TKMemoHyperlink; At : Integer) : TKMemoHyperlink;
Begin Result := Self.AddHyperlink(AItem, At); END;

(*----------------------------------------------------------------------------*)
Function TKMemoBlocksAddHyperlink_P(Self: TKMemoBlocks;  const AText, AURL : TKString; At : Integer) : TKMemoHyperlink;
Begin Result := Self.AddHyperlink(AText, AURL, At); END;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableRows_R(Self: TKMemoTable; var T: TKMemoTableRow; const t1: Integer);
begin T := Self.Rows[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableRowHeights_W(Self: TKMemoTable; const T: Integer; const t1: Integer);
begin Self.RowHeights[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableRowHeights_R(Self: TKMemoTable; var T: Integer; const t1: Integer);
begin T := Self.RowHeights[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableRowCount_W(Self: TKMemoTable; const T: Integer);
begin Self.RowCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableRowCount_R(Self: TKMemoTable; var T: Integer);
begin T := Self.RowCount; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableColWidths_W(Self: TKMemoTable; const T: Integer; const t1: Integer);
begin Self.ColWidths[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableColWidths_R(Self: TKMemoTable; var T: Integer; const t1: Integer);
begin T := Self.ColWidths[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableColCount_W(Self: TKMemoTable; const T: Integer);
begin Self.ColCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableColCount_R(Self: TKMemoTable; var T: Integer);
begin T := Self.ColCount; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableCellStyle_R(Self: TKMemoTable; var T: TKMemoBlockStyle);
begin T := Self.CellStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableCellSpan_W(Self: TKMemoTable; const T: TKCellSpan; const t1: Integer; const t2: Integer);
begin Self.CellSpan[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableCellSpan_R(Self: TKMemoTable; var T: TKCellSpan; const t1: Integer; const t2: Integer);
begin T := Self.CellSpan[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableCells_R(Self: TKMemoTable; var T: TKMemoTableCell; const t1: Integer; const t2: Integer);
begin T := Self.Cells[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableRowParentTable_R(Self: TKMemoTableRow; var T: TKMemoTable);
begin T := Self.ParentTable; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableRowCells_R(Self: TKMemoTableRow; var T: TKMemoTableCell; const t1: Integer);
begin T := Self.Cells[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableRowCellCount_W(Self: TKMemoTableRow; const T: Integer);
begin Self.CellCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableRowCellCount_R(Self: TKMemoTableRow; var T: Integer);
begin T := Self.CellCount; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableCellRowSpan_W(Self: TKMemoTableCell; const T: Integer);
begin Self.RowSpan := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableCellRowSpan_R(Self: TKMemoTableCell; var T: Integer);
begin T := Self.RowSpan; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableCellColSpan_W(Self: TKMemoTableCell; const T: Integer);
begin Self.ColSpan := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableCellColSpan_R(Self: TKMemoTableCell; var T: Integer);
begin T := Self.ColSpan; end;

(*----------------------------------------------------------------------------*)
(*procedure TKMemoTableCellSpan_W(Self: TKMemoTableCell; const T: TKCellSpan);
begin Self.Span := T; end;

(*----------------------------------------------------------------------------*)
//procedure TKMemoTableCellSpan_R(Self: TKMemoTableCell; var T: TKCellSpan);
//begin T := Self.Span; end;
//*)

(*----------------------------------------------------------------------------*)
procedure TKMemoTableCellRequiredBorderWidths_R(Self: TKMemoTableCell; var T: TKRect);
begin T := Self.RequiredBorderWidths; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableCellParentTable_R(Self: TKMemoTableCell; var T: TKMemoTable);
begin T := Self.ParentTable; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTableCellParentRow_R(Self: TKMemoTableCell; var T: TKMemoTableRow);
begin T := Self.ParentRow; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerRequiredWidth_W(Self: TKMemoContainer; const T: Integer);
begin Self.RequiredWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerRequiredWidth_R(Self: TKMemoContainer; var T: Integer);
begin T := Self.RequiredWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerRequiredHeight_W(Self: TKMemoContainer; const T: Integer);
begin Self.RequiredHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerRequiredHeight_R(Self: TKMemoContainer; var T: Integer);
begin T := Self.RequiredHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerFixedWidth_W(Self: TKMemoContainer; const T: Boolean);
begin Self.FixedWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerFixedWidth_R(Self: TKMemoContainer; var T: Boolean);
begin T := Self.FixedWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerFixedHeight_W(Self: TKMemoContainer; const T: Boolean);
begin Self.FixedHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerFixedHeight_R(Self: TKMemoContainer; var T: Boolean);
begin T := Self.FixedHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerCurrentRequiredWidth_R(Self: TKMemoContainer; var T: Integer);
begin T := Self.CurrentRequiredWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerCurrentRequiredHeight_R(Self: TKMemoContainer; var T: Integer);
begin T := Self.CurrentRequiredHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerClip_W(Self: TKMemoContainer; const T: Boolean);
begin Self.Clip := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerClip_R(Self: TKMemoContainer; var T: Boolean);
begin T := Self.Clip; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerBlockStyle_R(Self: TKMemoContainer; var T: TKMemoBlockStyle);
begin T := Self.BlockStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoContainerBlocks_R(Self: TKMemoContainer; var T: TKMemoBlocks);
begin T := Self.Blocks; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockScaleY_W(Self: TKMemoImageBlock; const T: Integer);
begin Self.ScaleY := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockScaleY_R(Self: TKMemoImageBlock; var T: Integer);
begin T := Self.ScaleY; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockScaleX_W(Self: TKMemoImageBlock; const T: Integer);
begin Self.ScaleX := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockScaleX_R(Self: TKMemoImageBlock; var T: Integer);
begin T := Self.ScaleX; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockScaleWidth_W(Self: TKMemoImageBlock; const T: Integer);
begin Self.ScaleWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockScaleWidth_R(Self: TKMemoImageBlock; var T: Integer);
begin T := Self.ScaleWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockScaleHeight_W(Self: TKMemoImageBlock; const T: Integer);
begin Self.ScaleHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockScaleHeight_R(Self: TKMemoImageBlock; var T: Integer);
begin T := Self.ScaleHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockPath_W(Self: TKMemoImageBlock; const T: TKString);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockOriginalWidth_W(Self: TKMemoImageBlock; const T: Integer);
begin Self.OriginalWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockOriginalWidth_R(Self: TKMemoImageBlock; var T: Integer);
begin T := Self.OriginalWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockOriginalHeight_W(Self: TKMemoImageBlock; const T: Integer);
begin Self.OriginalHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockOriginalHeight_R(Self: TKMemoImageBlock; var T: Integer);
begin T := Self.OriginalHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockImageWidth_R(Self: TKMemoImageBlock; var T: Integer);
begin T := Self.ImageWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockImageHeight_R(Self: TKMemoImageBlock; var T: Integer);
begin T := Self.ImageHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockImageStyle_R(Self: TKMemoImageBlock; var T: TKMemoBlockStyle);
begin T := Self.ImageStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockImage_W(Self: TKMemoImageBlock; const T: TPicture);
begin Self.Image := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockImage_R(Self: TKMemoImageBlock; var T: TPicture);
begin T := Self.Image; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockCrop_W(Self: TKMemoImageBlock; const T: TKRect);
begin Self.Crop := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoImageBlockCrop_R(Self: TKMemoImageBlock; var T: TKRect);
begin T := Self.Crop; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphWidth_W(Self: TKMemoParagraph; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphWidth_R(Self: TKMemoParagraph; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphTop_W(Self: TKMemoParagraph; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphTop_R(Self: TKMemoParagraph; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphNumberBlock_R(Self: TKMemoParagraph; var T: TKMemoTextBlock);
begin T := Self.NumberBlock; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphNumberingListLevel_R(Self: TKMemoParagraph; var T: TKMemoListLevel);
begin T := Self.NumberingListLevel; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphNumberingList_R(Self: TKMemoParagraph; var T: TKMemoList);
begin T := Self.NumberingList; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphNumbering_W(Self: TKMemoParagraph; const T: TKMemoParaNumbering);
begin Self.Numbering := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphNumbering_R(Self: TKMemoParagraph; var T: TKMemoParaNumbering);
begin T := Self.Numbering; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphLeft_W(Self: TKMemoParagraph; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphLeft_R(Self: TKMemoParagraph; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphHeight_W(Self: TKMemoParagraph; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParagraphHeight_R(Self: TKMemoParagraph; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoHyperlinkURL_W(Self: TKMemoHyperlink; const T: TKString);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoHyperlinkURL_R(Self: TKMemoHyperlink; var T: TKString);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextBlockWordBreaks_R(Self: TKMemoTextBlock; var T: TKSysCharSet);
begin T := Self.WordBreaks; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextBlockTextStyle_R(Self: TKMemoTextBlock; var T: TKMemoTextStyle);
begin T := Self.TextStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextBlockText_W(Self: TKMemoTextBlock; const T: TKString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextBlockText_R(Self: TKMemoTextBlock; var T: TKString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWrapMode_R(Self: TKMemoBlock; var T: TKMemoBlockWrapMode);
begin T := Self.WrapMode; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordWidth_W(Self: TKMemoBlock; const T: Integer; const t1: Integer);
begin Self.WordWidth[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordWidth_R(Self: TKMemoBlock; var T: Integer; const t1: Integer);
begin T := Self.WordWidth[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordTopPadding_W(Self: TKMemoBlock; const T: Integer; const t1: Integer);
begin Self.WordTopPadding[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordTopPadding_R(Self: TKMemoBlock; var T: Integer; const t1: Integer);
begin T := Self.WordTopPadding[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordTop_W(Self: TKMemoBlock; const T: Integer; const t1: Integer);
begin Self.WordTop[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordTop_R(Self: TKMemoBlock; var T: Integer; const t1: Integer);
begin T := Self.WordTop[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWords_R(Self: TKMemoBlock; var T: TKString; const t1: Integer);
begin T := Self.Words[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordLength_R(Self: TKMemoBlock; var T: Integer; const t1: Integer);
begin T := Self.WordLength[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordLeft_W(Self: TKMemoBlock; const T: Integer; const t1: Integer);
begin Self.WordLeft[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordLeft_R(Self: TKMemoBlock; var T: Integer; const t1: Integer);
begin T := Self.WordLeft[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordHeight_W(Self: TKMemoBlock; const T: Integer; const t1: Integer);
begin Self.WordHeight[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordHeight_R(Self: TKMemoBlock; var T: Integer; const t1: Integer);
begin T := Self.WordHeight[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordClipped_W(Self: TKMemoBlock; const T: Boolean; const t1: Integer);
begin Self.WordClipped[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordClipped_R(Self: TKMemoBlock; var T: Boolean; const t1: Integer);
begin T := Self.WordClipped[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordBoundsRect_R(Self: TKMemoBlock; var T: TRect; const t1: Integer);
begin T := Self.WordBoundsRect[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordBottomPadding_W(Self: TKMemoBlock; const T: Integer; const t1: Integer);
begin Self.WordBottomPadding[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordBottomPadding_R(Self: TKMemoBlock; var T: Integer; const t1: Integer);
begin T := Self.WordBottomPadding[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordBreakable_R(Self: TKMemoBlock; var T: Boolean; const t1: Integer);
begin T := Self.WordBreakable[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordBaseLine_W(Self: TKMemoBlock; const T: Integer; const t1: Integer);
begin Self.WordBaseLine[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordBaseLine_R(Self: TKMemoBlock; var T: Integer; const t1: Integer);
begin T := Self.WordBaseLine[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWordCount_R(Self: TKMemoBlock; var T: Integer);
begin T := Self.WordCount; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockWidth_R(Self: TKMemoBlock; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockTopPadding_R(Self: TKMemoBlock; var T: Integer);
begin T := Self.TopPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockTopOffset_W(Self: TKMemoBlock; const T: Integer);
begin Self.TopOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockTopOffset_R(Self: TKMemoBlock; var T: Integer);
begin T := Self.TopOffset; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockTop_R(Self: TKMemoBlock; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockText_R(Self: TKMemoBlock; var T: TKString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockShowFormatting_R(Self: TKMemoBlock; var T: Boolean);
begin T := Self.ShowFormatting; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockSelText_R(Self: TKMemoBlock; var T: TKString);
begin T := Self.SelText; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockSelStart_R(Self: TKMemoBlock; var T: Integer);
begin T := Self.SelStart; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockSelLength_R(Self: TKMemoBlock; var T: Integer);
begin T := Self.SelLength; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockPrinting_R(Self: TKMemoBlock; var T: Boolean);
begin T := Self.Printing; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockPosition_W(Self: TKMemoBlock; const T: TKMemoBlockPosition);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockPosition_R(Self: TKMemoBlock; var T: TKMemoBlockPosition);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockParentBlocks_R(Self: TKMemoBlock; var T: TKMemoBlocks);
begin T := Self.ParentBlocks; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockParaStyle_R(Self: TKMemoBlock; var T: TKMemoParaStyle);
begin T := Self.ParaStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockPaintSelection_R(Self: TKMemoBlock; var T: Boolean);
begin T := Self.PaintSelection; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockMemoNotifier_R(Self: TKMemoBlock; var T: IKMemoNotifier);
begin T := Self.MemoNotifier; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockLeftOffset_W(Self: TKMemoBlock; const T: Integer);
begin Self.LeftOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockLeftOffset_R(Self: TKMemoBlock; var T: Integer);
begin T := Self.LeftOffset; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockLeft_R(Self: TKMemoBlock; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockHeight_R(Self: TKMemoBlock; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockDefaultParaStyle_R(Self: TKMemoBlock; var T: TKMemoParaStyle);
begin T := Self.DefaultParaStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockDefaultTextStyle_R(Self: TKMemoBlock; var T: TKMemoTextStyle);
begin T := Self.DefaultTextStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockCanAddText_R(Self: TKMemoBlock; var T: Boolean);
begin T := Self.CanAddText; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockBottomPadding_R(Self: TKMemoBlock; var T: Integer);
begin T := Self.BottomPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockBoundsRect_R(Self: TKMemoBlock; var T: TRect);
begin T := Self.BoundsRect; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordListItems_W(Self: TKMemoWordList; const T: TKMemoWord; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordListItems_R(Self: TKMemoWordList; var T: TKMemoWord; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordTopPadding_W(Self: TKMemoWord; const T: Integer);
begin Self.TopPadding := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordTopPadding_R(Self: TKMemoWord; var T: Integer);
begin T := Self.TopPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordStartIndex_W(Self: TKMemoWord; const T: Integer);
begin Self.StartIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordStartIndex_R(Self: TKMemoWord; var T: Integer);
begin T := Self.StartIndex; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordPosition_W(Self: TKMemoWord; const T: TPoint);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordPosition_R(Self: TKMemoWord; var T: TPoint);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordExtent_W(Self: TKMemoWord; const T: TPoint);
begin Self.Extent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordExtent_R(Self: TKMemoWord; var T: TPoint);
begin T := Self.Extent; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordEndIndex_W(Self: TKMemoWord; const T: Integer);
begin Self.EndIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordEndIndex_R(Self: TKMemoWord; var T: Integer);
begin T := Self.EndIndex; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordClipped_W(Self: TKMemoWord; const T: Boolean);
begin Self.Clipped := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordClipped_R(Self: TKMemoWord; var T: Boolean);
begin T := Self.Clipped; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordBottomPadding_W(Self: TKMemoWord; const T: Integer);
begin Self.BottomPadding := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordBottomPadding_R(Self: TKMemoWord; var T: Integer);
begin T := Self.BottomPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordBaseLine_W(Self: TKMemoWord; const T: Integer);
begin Self.BaseLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoWordBaseLine_R(Self: TKMemoWord; var T: Integer);
begin T := Self.BaseLine; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLinesItems_W(Self: TKMemoLines; const T: TKMemoLine; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLinesItems_R(Self: TKMemoLines; var T: TKMemoLine; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineStartWord_W(Self: TKMemoLine; const T: Integer);
begin Self.StartWord := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineStartWord_R(Self: TKMemoLine; var T: Integer);
begin T := Self.StartWord; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineStartIndex_W(Self: TKMemoLine; const T: Integer);
begin Self.StartIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineStartIndex_R(Self: TKMemoLine; var T: Integer);
begin T := Self.StartIndex; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineStartBlock_W(Self: TKMemoLine; const T: Integer);
begin Self.StartBlock := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineStartBlock_R(Self: TKMemoLine; var T: Integer);
begin T := Self.StartBlock; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLinePosition_W(Self: TKMemoLine; const T: TPoint);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLinePosition_R(Self: TKMemoLine; var T: TPoint);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineExtent_W(Self: TKMemoLine; const T: TPoint);
begin Self.Extent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineExtent_R(Self: TKMemoLine; var T: TPoint);
begin T := Self.Extent; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineEndWord_W(Self: TKMemoLine; const T: Integer);
begin Self.EndWord := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineEndWord_R(Self: TKMemoLine; var T: Integer);
begin T := Self.EndWord; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineEndIndex_W(Self: TKMemoLine; const T: Integer);
begin Self.EndIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineEndIndex_R(Self: TKMemoLine; var T: Integer);
begin T := Self.EndIndex; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineEndBlock_W(Self: TKMemoLine; const T: Integer);
begin Self.EndBlock := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoLineEndBlock_R(Self: TKMemoLine; var T: Integer);
begin T := Self.EndBlock; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleWordWrap_W(Self: TKMemoParaStyle; const T: Boolean);
begin Self.WordWrap := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleWordWrap_R(Self: TKMemoParaStyle; var T: Boolean);
begin T := Self.WordWrap; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleNumberStartAt_W(Self: TKMemoParaStyle; const T: Integer);
begin Self.NumberStartAt := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleNumberStartAt_R(Self: TKMemoParaStyle; var T: Integer);
begin T := Self.NumberStartAt; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleNumberingListLevel_W(Self: TKMemoParaStyle; const T: Integer);
begin Self.NumberingListLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleNumberingListLevel_R(Self: TKMemoParaStyle; var T: Integer);
begin T := Self.NumberingListLevel; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleNumberingList_W(Self: TKMemoParaStyle; const T: Integer);
begin Self.NumberingList := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleNumberingList_R(Self: TKMemoParaStyle; var T: Integer);
begin T := Self.NumberingList; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleLineSpacingValue_W(Self: TKMemoParaStyle; const T: Integer);
begin Self.LineSpacingValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleLineSpacingValue_R(Self: TKMemoParaStyle; var T: Integer);
begin T := Self.LineSpacingValue; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleLineSpacingMode_W(Self: TKMemoParaStyle; const T: TKMemoLineSpacingMode);
begin Self.LineSpacingMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleLineSpacingMode_R(Self: TKMemoParaStyle; var T: TKMemoLineSpacingMode);
begin T := Self.LineSpacingMode; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleLineSpacingFactor_W(Self: TKMemoParaStyle; const T: Double);
begin Self.LineSpacingFactor := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleLineSpacingFactor_R(Self: TKMemoParaStyle; var T: Double);
begin T := Self.LineSpacingFactor; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleFirstIndent_W(Self: TKMemoParaStyle; const T: Integer);
begin Self.FirstIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoParaStyleFirstIndent_R(Self: TKMemoParaStyle; var T: Integer);
begin T := Self.FirstIndent; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleOnChanged_W(Self: TKMemoBlockStyle; const T: TKMemoBlockStyleChangedEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleOnChanged_R(Self: TKMemoBlockStyle; var T: TKMemoBlockStyleChangedEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleWrapMode_W(Self: TKMemoBlockStyle; const T: TKMemoBlockWrapMode);
begin Self.WrapMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleWrapMode_R(Self: TKMemoBlockStyle; var T: TKMemoBlockWrapMode);
begin T := Self.WrapMode; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleTopPadding_W(Self: TKMemoBlockStyle; const T: Integer);
begin Self.TopPadding := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleTopPadding_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.TopPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleTopMargin_W(Self: TKMemoBlockStyle; const T: Integer);
begin Self.TopMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleTopMargin_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.TopMargin; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleTopBorderWidth_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.TopBorderWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleStyleChanged_W(Self: TKMemoBlockStyle; const T: Boolean);
begin Self.StyleChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleStyleChanged_R(Self: TKMemoBlockStyle; var T: Boolean);
begin T := Self.StyleChanged; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleRightPadding_W(Self: TKMemoBlockStyle; const T: Integer);
begin Self.RightPadding := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleRightPadding_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.RightPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleRightMargin_W(Self: TKMemoBlockStyle; const T: Integer);
begin Self.RightMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleRightMargin_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.RightMargin; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleRightBorderWidth_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.RightBorderWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleLeftPadding_W(Self: TKMemoBlockStyle; const T: Integer);
begin Self.LeftPadding := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleLeftPadding_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.LeftPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleLeftMargin_W(Self: TKMemoBlockStyle; const T: Integer);
begin Self.LeftMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleLeftMargin_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.LeftMargin; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleLeftBorderWidth_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.LeftBorderWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleHAlign_W(Self: TKMemoBlockStyle; const T: TKHAlign);
begin Self.HAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleHAlign_R(Self: TKMemoBlockStyle; var T: TKHAlign);
begin T := Self.HAlign; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleFillBlip_W(Self: TKMemoBlockStyle; const T: TGraphic);
begin Self.FillBlip := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleFillBlip_R(Self: TKMemoBlockStyle; var T: TGraphic);
begin T := Self.FillBlip; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleContentPadding_W(Self: TKMemoBlockStyle; const T: TKRect);
begin Self.ContentPadding := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleContentPadding_R(Self: TKMemoBlockStyle; var T: TKRect);
begin T := Self.ContentPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleContentMargin_W(Self: TKMemoBlockStyle; const T: TKRect);
begin Self.ContentMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleContentMargin_R(Self: TKMemoBlockStyle; var T: TKRect);
begin T := Self.ContentMargin; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBrush_W(Self: TKMemoBlockStyle; const T: TBrush);
begin Self.Brush := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBrush_R(Self: TKMemoBlockStyle; var T: TBrush);
begin T := Self.Brush; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBorderWidths_W(Self: TKMemoBlockStyle; const T: TKRect);
begin Self.BorderWidths := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBorderWidths_R(Self: TKMemoBlockStyle; var T: TKRect);
begin T := Self.BorderWidths; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBorderWidth_W(Self: TKMemoBlockStyle; const T: Integer);
begin Self.BorderWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBorderWidth_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.BorderWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBorderColor_W(Self: TKMemoBlockStyle; const T: TColor);
begin Self.BorderColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBorderColor_R(Self: TKMemoBlockStyle; var T: TColor);
begin T := Self.BorderColor; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBorderRadius_W(Self: TKMemoBlockStyle; const T: Integer);
begin Self.BorderRadius := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBorderRadius_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.BorderRadius; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBottomPadding_W(Self: TKMemoBlockStyle; const T: Integer);
begin Self.BottomPadding := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBottomPadding_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.BottomPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBottomMargin_W(Self: TKMemoBlockStyle; const T: Integer);
begin Self.BottomMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBottomMargin_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.BottomMargin; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleBottomBorderWidth_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.BottomBorderWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleAllPaddingsTop_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.AllPaddingsTop; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleAllPaddingsRight_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.AllPaddingsRight; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleAllPaddingsLeft_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.AllPaddingsLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoBlockStyleAllPaddingsBottom_R(Self: TKMemoBlockStyle; var T: Integer);
begin T := Self.AllPaddingsBottom; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleOnChanged_W(Self: TKMemoTextStyle; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleOnChanged_R(Self: TKMemoTextStyle; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleStyleChanged_W(Self: TKMemoTextStyle; const T: Boolean);
begin Self.StyleChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleStyleChanged_R(Self: TKMemoTextStyle; var T: Boolean);
begin T := Self.StyleChanged; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleScriptPosition_W(Self: TKMemoTextStyle; const T: TKMemoScriptPosition);
begin Self.ScriptPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleScriptPosition_R(Self: TKMemoTextStyle; var T: TKMemoScriptPosition);
begin T := Self.ScriptPosition; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleFont_W(Self: TKMemoTextStyle; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleFont_R(Self: TKMemoTextStyle; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleBrush_W(Self: TKMemoTextStyle; const T: TBrush);
begin Self.Brush := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleBrush_R(Self: TKMemoTextStyle; var T: TBrush);
begin T := Self.Brush; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleCapitals_W(Self: TKMemoTextStyle; const T: TKMemoScriptCapitals);
begin Self.Capitals := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleCapitals_R(Self: TKMemoTextStyle; var T: TKMemoScriptCapitals);
begin T := Self.Capitals; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleAllowBrush_W(Self: TKMemoTextStyle; const T: Boolean);
begin Self.AllowBrush := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoTextStyleAllowBrush_R(Self: TKMemoTextStyle; var T: Boolean);
begin T := Self.AllowBrush; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListTableOnChanged_W(Self: TKMemoListTable; const T: TKMemoListChangedEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListTableOnChanged_R(Self: TKMemoListTable; var T: TKMemoListChangedEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListTableItems_W(Self: TKMemoListTable; const T: TKMemoList; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListTableItems_R(Self: TKMemoListTable; var T: TKMemoList; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevels_R(Self: TKMemoList; var T: TKMemoListLevels);
begin T := Self.Levels; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListID_W(Self: TKMemoList; const T: Integer);
begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListID_R(Self: TKMemoList; var T: Integer);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelsParent_W(Self: TKMemoListLevels; const T: TKMemoList);
begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelsParent_R(Self: TKMemoListLevels; var T: TKMemoList);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelsItems_W(Self: TKMemoListLevels; const T: TKMemoListLevel; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelsItems_R(Self: TKMemoListLevels; var T: TKMemoListLevel; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelNumberStartAt_W(Self: TKMemoListLevel; const T: Integer);
begin Self.NumberStartAt := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelNumberStartAt_R(Self: TKMemoListLevel; var T: Integer);
begin T := Self.NumberStartAt; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelNumberingFormat_R(Self: TKMemoListLevel; var T: TKMemoNumberingFormat);
begin T := Self.NumberingFormat; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelNumberingFontChanged_R(Self: TKMemoListLevel; var T: Boolean);
begin T := Self.NumberingFontChanged; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelNumberingFont_R(Self: TKMemoListLevel; var T: TFont);
begin T := Self.NumberingFont; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelNumbering_W(Self: TKMemoListLevel; const T: TKMemoParaNumbering);
begin Self.Numbering := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelNumbering_R(Self: TKMemoListLevel; var T: TKMemoParaNumbering);
begin T := Self.Numbering; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelLeftIndent_W(Self: TKMemoListLevel; const T: Integer);
begin Self.LeftIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelLeftIndent_R(Self: TKMemoListLevel; var T: Integer);
begin T := Self.LeftIndent; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelFirstIndent_W(Self: TKMemoListLevel; const T: Integer);
begin Self.FirstIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelFirstIndent_R(Self: TKMemoListLevel; var T: Integer);
begin T := Self.FirstIndent; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelLevelCounter_W(Self: TKMemoListLevel; const T: Integer);
begin Self.LevelCounter := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoListLevelLevelCounter_R(Self: TKMemoListLevel; var T: Integer);
begin T := Self.LevelCounter; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoNumberingFormatLevelCount_R(Self: TKMemoNumberingFormat; var T: Integer);
begin T := Self.LevelCount; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoNumberingFormatItems_W(Self: TKMemoNumberingFormat; const T: TKMemoNumberingFormatItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoNumberingFormatItems_R(Self: TKMemoNumberingFormat; var T: TKMemoNumberingFormatItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoNumberingFormatItemText_W(Self: TKMemoNumberingFormatItem; const T: TKString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoNumberingFormatItemText_R(Self: TKMemoNumberingFormatItem; var T: TKString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoNumberingFormatItemLevel_W(Self: TKMemoNumberingFormatItem; const T: Integer);
begin Self.Level := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoNumberingFormatItemLevel_R(Self: TKMemoNumberingFormatItem; var T: Integer);
begin T := Self.Level; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoDictionaryItems_W(Self: TKMemoDictionary; const T: TKMemoDictionaryItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoDictionaryItems_R(Self: TKMemoDictionary; var T: TKMemoDictionaryItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoDictionaryItemValue_W(Self: TKMemoDictionaryItem; const T: Integer);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoDictionaryItemValue_R(Self: TKMemoDictionaryItem; var T: Integer);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoDictionaryItemIndex_W(Self: TKMemoDictionaryItem; const T: Integer);
begin Self.Index := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoDictionaryItemIndex_R(Self: TKMemoDictionaryItem; var T: Integer);
begin T := Self.Index; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoSparseListItems_W(Self: TKMemoSparseList; const T: TKMemoSparseItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoSparseListItems_R(Self: TKMemoSparseList; var T: TKMemoSparseItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoSparseItemIndex_W(Self: TKMemoSparseItem; const T: Integer);
begin Self.Index := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoSparseItemIndex_R(Self: TKMemoSparseItem; var T: Integer);
begin T := Self.Index; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KMemo_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@NewLineChar, 'NewLineChar', cdRegister);
 S.RegisterDelphiFunction(@SpaceChar, 'SpaceChar', cdRegister);
 S.RegisterDelphiFunction(@TabChar, 'TabChar', cdRegister);
 S.RegisterDelphiFunction(@FindRootDesigner, 'FindRootDesigner', cdRegister);
 S.RegisterDelphiFunction(@FontToOleFont, 'FontToOleFont', cdRegister);
 S.RegisterDelphiFunction(@OleFontToFont, 'OleFontToFont', cdRegister);

 //function FontToOleFont(Font: TFont): Variant;
 //procedure OleFontToFont(const OleFont: Variant; Font: TFont);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoEditSelectAllAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoEditSelectAllAction) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoEditPasteAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoEditPasteAction) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoEditCutAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoEditCutAction) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoEditCopyAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoEditCopyAction) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoEditAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoEditAction) do
  begin
    RegisterMethod(@TKMemoEditAction.HandlesTarget, 'HandlesTarget');
    RegisterMethod(@TKMemoEditAction.UpdateTarget, 'UpdateTarget');
    RegisterMethod(@TKMemoEditAction.ExecuteTarget, 'ExecuteTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemo) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKCustomMemo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKCustomMemo) do begin
    RegisterConstructor(@TKCustomMemo.Create, 'Create');
             RegisterMethod(@TKCustomMemo.Destroy, 'Free');

    RegisterVirtualMethod(@TKCustomMemo.CaretInView, 'CaretInView');
    RegisterVirtualMethod(@TKCustomMemo.ClampInView, 'ClampInView');
    RegisterMethod(@TKCustomMemo.Clear, 'Clear');
    RegisterVirtualMethod(@TKCustomMemo.ClearSelection, 'ClearSelection');
    RegisterMethod(@TKCustomMemo.ClearUndo, 'ClearUndo');
    RegisterVirtualMethod(@TKCustomMemo.CommandEnabled, 'CommandEnabled');
    RegisterMethod(@TKCustomMemo.DeleteBOL, 'DeleteBOL');
    RegisterVirtualMethod(@TKCustomMemo.DeleteChar, 'DeleteChar');
    RegisterMethod(@TKCustomMemo.DeleteEOL, 'DeleteEOL');
    RegisterVirtualMethod(@TKCustomMemo.DeleteLastChar, 'DeleteLastChar');
    RegisterMethod(@TKCustomMemo.DeleteLine, 'DeleteLine');
    RegisterVirtualMethod(@TKCustomMemo.ExecuteCommand, 'ExecuteCommand');
    RegisterVirtualMethod(@TKCustomMemo.GetMaxLeftPos, 'GetMaxLeftPos');
    RegisterVirtualMethod(@TKCustomMemo.GetMaxTopPos, 'GetMaxTopPos');
    RegisterVirtualMethod(@TKCustomMemo.IndexToRect, 'IndexToRect');
    RegisterVirtualMethod(@TKCustomMemo.InsertChar, 'InsertChar');
    RegisterVirtualMethod(@TKCustomMemo.InsertNewLine, 'InsertNewLine');
    RegisterVirtualMethod(@TKCustomMemo.InsertString, 'InsertString');
    RegisterVirtualMethod(@TKCustomMemo.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TKCustomMemo.LoadFromRTF, 'LoadFromRTF');
    RegisterVirtualMethod(@TKCustomMemo.LoadFromRTFStream, 'LoadFromRTFStream');
    RegisterVirtualMethod(@TKCustomMemo.LoadFromTXT, 'LoadFromTXT');
    RegisterMethod(@TKCustomMemo.MoveCaretToMouseCursor, 'MoveCaretToMouseCursor');
    RegisterVirtualMethod(@TKCustomMemo.PointToIndex, 'PointToIndex');
    RegisterVirtualMethod(@TKCustomMemo.SaveToFile, 'SaveToFile');
    RegisterVirtualMethod(@TKCustomMemo.SaveToRTF, 'SaveToRTF');
    RegisterVirtualMethod(@TKCustomMemo.SaveToRTFStream, 'SaveToRTFStream');
    RegisterVirtualMethod(@TKCustomMemo.SaveToTXT, 'SaveToTXT');
    RegisterVirtualMethod(@TKCustomMemo.Select, 'Select');
    RegisterVirtualMethod(@TKCustomMemo.SplitAt, 'SplitAt');
    RegisterPropertyHelper(@TKCustomMemoActiveBlock_R,nil,'ActiveBlock');
    RegisterPropertyHelper(@TKCustomMemoActiveInnerBlock_R,nil,'ActiveInnerBlock');
    RegisterPropertyHelper(@TKCustomMemoActiveBlocks_R,nil,'ActiveBlocks');
    RegisterPropertyHelper(@TKCustomMemoActiveInnerBlocks_R,nil,'ActiveInnerBlocks');
    RegisterPropertyHelper(@TKCustomMemoBlocks_R,nil,'Blocks');
    RegisterPropertyHelper(@TKCustomMemoBackgroundImage_R,nil,'BackgroundImage');
    RegisterPropertyHelper(@TKCustomMemoCaretPos_R,nil,'CaretPos');
    RegisterPropertyHelper(@TKCustomMemoCaretVisible_R,nil,'CaretVisible');
    RegisterPropertyHelper(@TKCustomMemoColors_R,@TKCustomMemoColors_W,'Colors');
    RegisterPropertyHelper(@TKCustomMemoContentPadding_R,nil,'ContentPadding');
    RegisterPropertyHelper(@TKCustomMemoContentHeight_R,nil,'ContentHeight');
    RegisterPropertyHelper(@TKCustomMemoContentLeft_R,nil,'ContentLeft');
    RegisterPropertyHelper(@TKCustomMemoContentRect_R,nil,'ContentRect');
    RegisterPropertyHelper(@TKCustomMemoContentTop_R,nil,'ContentTop');
    RegisterPropertyHelper(@TKCustomMemoContentWidth_R,nil,'ContentWidth');
    RegisterPropertyHelper(@TKCustomMemoDisabledDrawStyle_R,@TKCustomMemoDisabledDrawStyle_W,'DisabledDrawStyle');
    RegisterPropertyHelper(@TKCustomMemoEmpty_R,nil,'Empty');
    RegisterPropertyHelper(@TKCustomMemoHorzScrollPadding_R,nil,'HorzScrollPadding');
    RegisterPropertyHelper(@TKCustomMemoInsertMode_R,nil,'InsertMode');
    RegisterPropertyHelper(@TKCustomMemoKeyMapping_R,nil,'KeyMapping');
    RegisterPropertyHelper(@TKCustomMemoLeftPos_R,@TKCustomMemoLeftPos_W,'LeftPos');
    RegisterPropertyHelper(@TKCustomMemoListTable_R,nil,'ListTable');
    RegisterPropertyHelper(@TKCustomMemoModified_R,@TKCustomMemoModified_W,'Modified');
    RegisterPropertyHelper(@TKCustomMemoNearestParagraph_R,nil,'NearestParagraph');
    RegisterPropertyHelper(@TKCustomMemoOptions_R,@TKCustomMemoOptions_W,'Options');
    RegisterPropertyHelper(@TKCustomMemoParaStyle_R,nil,'ParaStyle');
    RegisterPropertyHelper(@TKCustomMemoReadOnly_R,@TKCustomMemoReadOnly_W,'ReadOnly');
    RegisterPropertyHelper(@TKCustomMemoRealSelEnd_R,nil,'RealSelEnd');
    RegisterPropertyHelper(@TKCustomMemoRealSelStart_R,nil,'RealSelStart');
    RegisterPropertyHelper(@TKCustomMemoRequiredContentWidth_R,@TKCustomMemoRequiredContentWidth_W,'RequiredContentWidth');
    RegisterPropertyHelper(@TKCustomMemoRTF_R,@TKCustomMemoRTF_W,'RTF');
    RegisterPropertyHelper(@TKCustomMemoScrollBars_R,@TKCustomMemoScrollBars_W,'ScrollBars');
    RegisterPropertyHelper(@TKCustomMemoScrollSpeed_R,@TKCustomMemoScrollSpeed_W,'ScrollSpeed');
    RegisterPropertyHelper(@TKCustomMemoScrollPadding_R,@TKCustomMemoScrollPadding_W,'ScrollPadding');
    RegisterPropertyHelper(@TKCustomMemoSelAvail_R,nil,'SelAvail');
    RegisterPropertyHelper(@TKCustomMemoSelectableLength_R,nil,'SelectableLength');
    RegisterPropertyHelper(@TKCustomMemoSelectionHasPara_R,nil,'SelectionHasPara');
    RegisterPropertyHelper(@TKCustomMemoSelectionParaStyle_R,@TKCustomMemoSelectionParaStyle_W,'SelectionParaStyle');
    RegisterPropertyHelper(@TKCustomMemoSelectionTextStyle_R,@TKCustomMemoSelectionTextStyle_W,'SelectionTextStyle');
    RegisterPropertyHelper(@TKCustomMemoSelEnd_R,@TKCustomMemoSelEnd_W,'SelEnd');
    RegisterPropertyHelper(@TKCustomMemoSelLength_R,@TKCustomMemoSelLength_W,'SelLength');
    RegisterPropertyHelper(@TKCustomMemoSelStart_R,@TKCustomMemoSelStart_W,'SelStart');
    RegisterPropertyHelper(@TKCustomMemoSelText_R,nil,'SelText');
    RegisterPropertyHelper(@TKCustomMemoText_R,@TKCustomMemoText_W,'Text');
    RegisterPropertyHelper(@TKCustomMemoTextStyle_R,nil,'TextStyle');
    RegisterPropertyHelper(@TKCustomMemoTopPos_R,@TKCustomMemoTopPos_W,'TopPos');
    RegisterPropertyHelper(@TKCustomMemoUndoLimit_R,@TKCustomMemoUndoLimit_W,'UndoLimit');
    RegisterPropertyHelper(@TKCustomMemoVertScrollPadding_R,nil,'VertScrollPadding');
    RegisterPropertyHelper(@TKCustomMemoWordBreaks_R,@TKCustomMemoWordBreaks_W,'WordBreaks');
    RegisterPropertyHelper(@TKCustomMemoOnChange_R,@TKCustomMemoOnChange_W,'OnChange');
    RegisterPropertyHelper(@TKCustomMemoOnDropFiles_R,@TKCustomMemoOnDropFiles_W,'OnDropFiles');
    RegisterPropertyHelper(@TKCustomMemoOnReplaceText_R,@TKCustomMemoOnReplaceText_W,'OnReplaceText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoChangeList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoChangeList) do
  begin
    RegisterConstructor(@TKMemoChangeList.Create, 'Create');
    RegisterVirtualMethod(@TKMemoChangeList.AddChange, 'AddChange');
    RegisterVirtualMethod(@TKMemoChangeList.BeginGroup, 'BeginGroup');
    RegisterMethod(@TKMemoChangeList.CanPeek, 'CanPeek');
    RegisterMethod(@TKMemoChangeList.Clear, 'Clear');
    RegisterVirtualMethod(@TKMemoChangeList.EndGroup, 'EndGroup');
    RegisterMethod(@TKMemoChangeList.PeekItem, 'PeekItem');
    RegisterMethod(@TKMemoChangeList.PokeItem, 'PokeItem');
    RegisterMethod(@TKMemoChangeList.SetGroupData, 'SetGroupData');
    RegisterPropertyHelper(@TKMemoChangeListLimit_R,@TKMemoChangeListLimit_W,'Limit');
    RegisterPropertyHelper(@TKMemoChangeListModified_R,@TKMemoChangeListModified_W,'Modified');
    RegisterPropertyHelper(@TKMemoChangeListOnChange_R,@TKMemoChangeListOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoColors) do
  begin
    RegisterPropertyHelper(@TKMemoColorsBkGnd_R,@TKMemoColorsBkGnd_W,'BkGnd');
    RegisterPropertyHelper(@TKMemoColorsInactiveCaretBkGnd_R,@TKMemoColorsInactiveCaretBkGnd_W,'InactiveCaretBkGnd');
    RegisterPropertyHelper(@TKMemoColorsInactiveCaretSelBkGnd_R,@TKMemoColorsInactiveCaretSelBkGnd_W,'InactiveCaretSelBkGnd');
    RegisterPropertyHelper(@TKMemoColorsInactiveCaretSelText_R,@TKMemoColorsInactiveCaretSelText_W,'InactiveCaretSelText');
    RegisterPropertyHelper(@TKMemoColorsInactiveCaretText_R,@TKMemoColorsInactiveCaretText_W,'InactiveCaretText');
    RegisterPropertyHelper(@TKMemoColorsSelBkGnd_R,@TKMemoColorsSelBkGnd_W,'SelBkGnd');
    RegisterPropertyHelper(@TKMemoColorsSelBkGndFocused_R,@TKMemoColorsSelBkGndFocused_W,'SelBkGndFocused');
    RegisterPropertyHelper(@TKMemoColorsSelText_R,@TKMemoColorsSelText_W,'SelText');
    RegisterPropertyHelper(@TKMemoColorsSelTextFocused_R,@TKMemoColorsSelTextFocused_W,'SelTextFocused');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoBlocks(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoBlocks) do begin
    RegisterConstructor(@TKMemoBlocks.Create, 'Create');
             RegisterMethod(@TKMemoBlocks.Destroy, 'Free');

    RegisterVirtualMethod(@TKMemoBlocks.AddAt, 'AddAt');
    RegisterMethod(@TKMemoBlocks.AddContainer, 'AddContainer');
    RegisterMethod(@TKMemoBlocksAddHyperlink_P, 'AddHyperlink');
    RegisterMethod(@TKMemoBlocksAddHyperlink1_P, 'AddHyperlink1');
    RegisterMethod(@TKMemoBlocks.AddImageBlock, 'AddImageBlock');
    RegisterMethod(@TKMemoBlocks.AddParagraph, 'AddParagraph');
    RegisterMethod(@TKMemoBlocks.AddTable, 'AddTable');
    RegisterMethod(@TKMemoBlocks.AddTextBlock, 'AddTextBlock');
    RegisterMethod(@TKMemoBlocks.Clear, 'Clear');
    RegisterVirtualMethod(@TKMemoBlocks.ClearSelection, 'ClearSelection');
    RegisterVirtualMethod(@TKMemoBlocks.ConcatEqualBlocks, 'ConcatEqualBlocks');
    RegisterVirtualMethod(@TKMemoBlocks.DeleteBOL, 'DeleteBOL');
    RegisterVirtualMethod(@TKMemoBlocks.DeleteChar, 'DeleteChar');
    RegisterVirtualMethod(@TKMemoBlocks.DeleteEOL, 'DeleteEOL');
    RegisterVirtualMethod(@TKMemoBlocks.DeleteLastChar, 'DeleteLastChar');
    RegisterVirtualMethod(@TKMemoBlocks.DeleteLine, 'DeleteLine');
    RegisterVirtualMethod(@TKMemoBlocks.FixEmptyBlocks, 'FixEmptyBlocks');
    RegisterVirtualMethod(@TKMemoBlocks.FixEOL, 'FixEOL');
    RegisterVirtualMethod(@TKMemoBlocks.GetNearestAnchorIndex, 'GetNearestAnchorIndex');
    RegisterVirtualMethod(@TKMemoBlocks.GetNearestParagraph, 'GetNearestParagraph');
    RegisterVirtualMethod(@TKMemoBlocks.GetLastItemByClass, 'GetLastItemByClass');
    RegisterVirtualMethod(@TKMemoBlocks.GetNextItemByClass, 'GetNextItemByClass');
    RegisterVirtualMethod(@TKMemoBlocks.GetSelColors, 'GetSelColors');
    RegisterVirtualMethod(@TKMemoBlocks.IndexAboveLastLine, 'IndexAboveLastLine');
    RegisterVirtualMethod(@TKMemoBlocks.IndexAtBeginningOfContainer, 'IndexAtBeginningOfContainer');
    RegisterVirtualMethod(@TKMemoBlocks.IndexAtEndOfContainer, 'IndexAtEndOfContainer');
    RegisterVirtualMethod(@TKMemoBlocks.IndexBelowFirstLine, 'IndexBelowFirstLine');
    RegisterVirtualMethod(@TKMemoBlocks.IndexToBlock, 'IndexToBlock');
    RegisterVirtualMethod(@TKMemoBlocks.IndexToBlocks, 'IndexToBlocks');
    RegisterVirtualMethod(@TKMemoBlocks.IndexToItem, 'IndexToItem');
    RegisterVirtualMethod(@TKMemoBlocks.IndexToLine, 'IndexToLine');
    RegisterVirtualMethod(@TKMemoBlocks.IndexToRect, 'IndexToRect');
    RegisterVirtualMethod(@TKMemoBlocks.InsideOfTable, 'InsideOfTable');
    RegisterVirtualMethod(@TKMemoBlocks.InsertChar, 'InsertChar');
    RegisterVirtualMethod(@TKMemoBlocks.InsertNewLine, 'InsertNewLine');
    RegisterVirtualMethod(@TKMemoBlocks.InsertPlainText, 'InsertPlainText');
    RegisterVirtualMethod(@TKMemoBlocks.InsertParagraph, 'InsertParagraph');
    RegisterVirtualMethod(@TKMemoBlocks.InsertString, 'InsertString');
    RegisterVirtualMethod(@TKMemoBlocks.LastTextStyle, 'LastTextStyle');
    RegisterVirtualMethod(@TKMemoBlocks.LineEndIndexByIndex, 'LineEndIndexByIndex');
    RegisterVirtualMethod(@TKMemoBlocks.LineStartIndexByIndex, 'LineStartIndexByIndex');
    RegisterVirtualMethod(@TKMemoBlocks.ListChanged, 'ListChanged');
    RegisterVirtualMethod(@TKMemoBlocks.MeasureExtent, 'MeasureExtent');
    RegisterVirtualMethod(@TKMemoBlocks.MouseAction, 'MouseAction');
    RegisterVirtualMethod(@TKMemoBlocks.NotifyDefaultParaChange, 'NotifyDefaultParaChange');
    RegisterVirtualMethod(@TKMemoBlocks.NotifyDefaultTextChange, 'NotifyDefaultTextChange');
    RegisterMethod(@TKMemoBlocks.NextIndexByCharCount, 'NextIndexByCharCount');
    RegisterVirtualMethod(@TKMemoBlocks.NextIndexByHorzExtent, 'NextIndexByHorzExtent');
    RegisterVirtualMethod(@TKMemoBlocks.NextIndexByRowDelta, 'NextIndexByRowDelta');
    RegisterVirtualMethod(@TKMemoBlocks.NextIndexByVertExtent, 'NextIndexByVertExtent');
    RegisterVirtualMethod(@TKMemoBlocks.NextIndexByVertValue, 'NextIndexByVertValue');
    RegisterVirtualMethod(@TKMemoBlocks.PointToBlocks, 'PointToBlocks');
    RegisterVirtualMethod(@TKMemoBlocks.PaintToCanvas, 'PaintToCanvas');
    RegisterVirtualMethod(@TKMemoBlocks.PointToIndex, 'PointToIndex');
    RegisterVirtualMethod(@TKMemoBlocks.PointToIndexOnLine, 'PointToIndexOnLine');
    RegisterVirtualMethod(@TKMemoBlocks.SetExtent, 'SetExtent');
    RegisterVirtualMethod(@TKMemoBlocks.UpdateAttributes, 'UpdateAttributes');
    RegisterPropertyHelper(@TKMemoBlocksBoundsRect_R,nil,'BoundsRect');
    RegisterPropertyHelper(@TKMemoBlocksDefaultTextStyle_R,nil,'DefaultTextStyle');
    RegisterPropertyHelper(@TKMemoBlocksDefaultParaStyle_R,nil,'DefaultParaStyle');
    RegisterPropertyHelper(@TKMemoBlocksEmpty_R,nil,'Empty');
    RegisterPropertyHelper(@TKMemoBlocksHeight_R,nil,'Height');
    RegisterPropertyHelper(@TKMemoBlocksIgnoreParaMark_R,@TKMemoBlocksIgnoreParaMark_W,'IgnoreParaMark');
    RegisterPropertyHelper(@TKMemoBlocksItems_R,@TKMemoBlocksItems_W,'Items');
    RegisterPropertyHelper(@TKMemoBlocksLineBottom_R,nil,'LineBottom');
    RegisterPropertyHelper(@TKMemoBlocksLineCount_R,nil,'LineCount');
    RegisterPropertyHelper(@TKMemoBlocksLineEndIndex_R,nil,'LineEndIndex');
    RegisterPropertyHelper(@TKMemoBlocksLineFloat_R,nil,'LineFloat');
    RegisterPropertyHelper(@TKMemoBlocksLineInfo_R,nil,'LineInfo');
    RegisterPropertyHelper(@TKMemoBlocksLineHeight_R,nil,'LineHeight');
    RegisterPropertyHelper(@TKMemoBlocksLineLeft_R,nil,'LineLeft');
    RegisterPropertyHelper(@TKMemoBlocksLineRight_R,nil,'LineRight');
    RegisterPropertyHelper(@TKMemoBlocksLineTop_R,nil,'LineTop');
    RegisterPropertyHelper(@TKMemoBlocksLineRect_R,nil,'LineRect');
    RegisterPropertyHelper(@TKMemoBlocksLineText_R,@TKMemoBlocksLineText_W,'LineText');
    RegisterPropertyHelper(@TKMemoBlocksLines_R,nil,'Lines');
    RegisterPropertyHelper(@TKMemoBlocksLineSize_R,nil,'LineSize');
    RegisterPropertyHelper(@TKMemoBlocksLineStartIndex_R,nil,'LineStartIndex');
    RegisterPropertyHelper(@TKMemoBlocksLineWidth_R,nil,'LineWidth');
    RegisterPropertyHelper(@TKMemoBlocksMemoNotifier_R,@TKMemoBlocksMemoNotifier_W,'MemoNotifier');
    RegisterPropertyHelper(@TKMemoBlocksParent_R,@TKMemoBlocksParent_W,'Parent');
    RegisterPropertyHelper(@TKMemoBlocksParentBlocks_R,nil,'ParentBlocks');
    RegisterPropertyHelper(@TKMemoBlocksRealSelEnd_R,nil,'RealSelEnd');
    RegisterPropertyHelper(@TKMemoBlocksRealSelStart_R,nil,'RealSelStart');
    RegisterPropertyHelper(@TKMemoBlocksSelectableLength_R,nil,'SelectableLength');
    RegisterPropertyHelper(@TKMemoBlocksSelectionHasPara_R,nil,'SelectionHasPara');
    RegisterPropertyHelper(@TKMemoBlocksSelectionParaStyle_R,@TKMemoBlocksSelectionParaStyle_W,'SelectionParaStyle');
    RegisterPropertyHelper(@TKMemoBlocksSelectionTextStyle_R,@TKMemoBlocksSelectionTextStyle_W,'SelectionTextStyle');
    RegisterPropertyHelper(@TKMemoBlocksSelEnd_R,nil,'SelEnd');
    RegisterPropertyHelper(@TKMemoBlocksSelLength_R,nil,'SelLength');
    RegisterPropertyHelper(@TKMemoBlocksSelStart_R,nil,'SelStart');
    RegisterPropertyHelper(@TKMemoBlocksSelText_R,nil,'SelText');
    RegisterPropertyHelper(@TKMemoBlocksShowFormatting_R,nil,'ShowFormatting');
    RegisterPropertyHelper(@TKMemoBlocksText_R,@TKMemoBlocksText_W,'Text');
    RegisterPropertyHelper(@TKMemoBlocksTotalLeftOffset_R,nil,'TotalLeftOffset');
    RegisterPropertyHelper(@TKMemoBlocksTotalTopOffset_R,nil,'TotalTopOffset');
    RegisterPropertyHelper(@TKMemoBlocksWidth_R,nil,'Width');
    RegisterPropertyHelper(@TKMemoBlocksOnUpdate_R,@TKMemoBlocksOnUpdate_W,'OnUpdate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoTable) do begin
    RegisterConstructor(@TKMemoTable.Create, 'Create');
             RegisterMethod(@TKMemoTable.Destroy, 'Free');

    RegisterVirtualMethod(@TKMemoTable.ApplyDefaultCellStyle, 'ApplyDefaultCellStyle');
    RegisterMethod(@TKMemoTable.CanAdd, 'CanAdd');
    RegisterVirtualMethod(@TKMemoTable.CalcTotalCellWidth, 'CalcTotalCellWidth');
    RegisterVirtualMethod(@TKMemoTable.CellValid, 'CellValid');
    RegisterVirtualMethod(@TKMemoTable.CellVisible, 'CellVisible');
    RegisterVirtualMethod(@TKMemoTable.ColValid, 'ColValid');
    RegisterVirtualMethod(@TKMemoTable.FindBaseCell, 'FindBaseCell');
    RegisterVirtualMethod(@TKMemoTable.FindCell, 'FindCell');
    RegisterVirtualMethod(@TKMemoTable.FixupBorders, 'FixupBorders');
    RegisterVirtualMethod(@TKMemoTable.FixupCellSpan, 'FixupCellSpan');
    RegisterVirtualMethod(@TKMemoTable.FixupCellSpanFromRTF, 'FixupCellSpanFromRTF');
    RegisterVirtualMethod(@TKMemoTable.RowValid, 'RowValid');
    RegisterMethod(@TKMemoTable.WordMeasureExtent, 'WordMeasureExtent');
    RegisterMethod(@TKMemoTable.WordMouseAction, 'WordMouseAction');
    RegisterMethod(@TKMemoTable.WordPointToIndex, 'WordPointToIndex');
    RegisterPropertyHelper(@TKMemoTableCells_R,nil,'Cells');
    RegisterPropertyHelper(@TKMemoTableCellSpan_R,@TKMemoTableCellSpan_W,'CellSpan');
    RegisterPropertyHelper(@TKMemoTableCellStyle_R,nil,'CellStyle');
    RegisterPropertyHelper(@TKMemoTableColCount_R,@TKMemoTableColCount_W,'ColCount');
    RegisterPropertyHelper(@TKMemoTableColWidths_R,@TKMemoTableColWidths_W,'ColWidths');
    RegisterPropertyHelper(@TKMemoTableRowCount_R,@TKMemoTableRowCount_W,'RowCount');
    RegisterPropertyHelper(@TKMemoTableRowHeights_R,@TKMemoTableRowHeights_W,'RowHeights');
    RegisterPropertyHelper(@TKMemoTableRows_R,nil,'Rows');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoTableRow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoTableRow) do begin
    RegisterConstructor(@TKMemoTableRow.Create, 'Create');
             RegisterMethod(@TKMemoTableRow.Destroy, 'Free');

    RegisterMethod(@TKMemoTableRow.CanAdd, 'CanAdd');
    RegisterVirtualMethod(@TKMemoTableRow.UpdateRequiredWidth, 'UpdateRequiredWidth');
    RegisterPropertyHelper(@TKMemoTableRowCellCount_R,@TKMemoTableRowCellCount_W,'CellCount');
    RegisterPropertyHelper(@TKMemoTableRowCells_R,nil,'Cells');
    RegisterPropertyHelper(@TKMemoTableRowParentTable_R,nil,'ParentTable');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoTableCell(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoTableCell) do begin
    RegisterConstructor(@TKMemoTableCell.Create, 'Create');
             RegisterMethod(@TKMemoTableCell.Destroy, 'Free');

    RegisterVirtualMethod(@TKMemoTableCell.PointToIndex, 'PointToIndex');
    RegisterMethod(@TKMemoTableCell.WordMeasureExtent, 'WordMeasureExtent');
    RegisterMethod(@TKMemoTableCell.WordPaintToCanvas, 'WordPaintToCanvas');
    RegisterPropertyHelper(@TKMemoTableCellParentRow_R,nil,'ParentRow');
    RegisterPropertyHelper(@TKMemoTableCellParentTable_R,nil,'ParentTable');
    RegisterPropertyHelper(@TKMemoTableCellRequiredBorderWidths_R,nil,'RequiredBorderWidths');
    RegisterPropertyHelper(@TKMemoTableCellSpan_R,@TKMemoTableCellSpan_W,'Span');
    RegisterPropertyHelper(@TKMemoTableCellColSpan_R,@TKMemoTableCellColSpan_W,'ColSpan');
    RegisterPropertyHelper(@TKMemoTableCellRowSpan_R,@TKMemoTableCellRowSpan_W,'RowSpan');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoContainer) do begin
    RegisterConstructor(@TKMemoContainer.Create, 'Create');
             RegisterMethod(@TKMemoContainer.Destroy, 'Free');

    RegisterMethod(@TKMemoContainer.CalcAscent, 'CalcAscent');
    RegisterMethod(@TKMemoContainer.CanAdd, 'CanAdd');
    RegisterMethod(@TKMemoContainer.ClearSelection, 'ClearSelection');
    RegisterMethod(@TKMemoContainer.InsertParagraph, 'InsertParagraph');
    RegisterMethod(@TKMemoContainer.InsertString, 'InsertString');
    RegisterMethod(@TKMemoContainer.NotifyDefaultParaChange, 'NotifyDefaultParaChange');
    RegisterMethod(@TKMemoContainer.NotifyDefaultTextChange, 'NotifyDefaultTextChange');
    RegisterMethod(@TKMemoContainer.Select, 'Select');
    RegisterVirtualMethod(@TKMemoContainer.SetBlockExtent, 'SetBlockExtent');
    RegisterVirtualMethod(@TKMemoContainer.UpdateAttributes, 'UpdateAttributes');
    RegisterMethod(@TKMemoContainer.WordIndexToRect, 'WordIndexToRect');
    RegisterMethod(@TKMemoContainer.WordMeasureExtent, 'WordMeasureExtent');
    RegisterMethod(@TKMemoContainer.WordPointToIndex, 'WordPointToIndex');
    RegisterMethod(@TKMemoContainer.WordPaintToCanvas, 'WordPaintToCanvas');
    RegisterPropertyHelper(@TKMemoContainerBlocks_R,nil,'Blocks');
    RegisterPropertyHelper(@TKMemoContainerBlockStyle_R,nil,'BlockStyle');
    RegisterPropertyHelper(@TKMemoContainerClip_R,@TKMemoContainerClip_W,'Clip');
    RegisterPropertyHelper(@TKMemoContainerCurrentRequiredHeight_R,nil,'CurrentRequiredHeight');
    RegisterPropertyHelper(@TKMemoContainerCurrentRequiredWidth_R,nil,'CurrentRequiredWidth');
    RegisterPropertyHelper(@TKMemoContainerFixedHeight_R,@TKMemoContainerFixedHeight_W,'FixedHeight');
    RegisterPropertyHelper(@TKMemoContainerFixedWidth_R,@TKMemoContainerFixedWidth_W,'FixedWidth');
    RegisterPropertyHelper(@TKMemoContainerRequiredHeight_R,@TKMemoContainerRequiredHeight_W,'RequiredHeight');
    RegisterPropertyHelper(@TKMemoContainerRequiredWidth_R,@TKMemoContainerRequiredWidth_W,'RequiredWidth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoImageBlock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoImageBlock) do begin
    RegisterConstructor(@TKMemoImageBlock.Create, 'Create');
             RegisterMethod(@TKMemoImageBlock.Destroy, 'Free');

    RegisterMethod(@TKMemoImageBlock.Assign, 'Assign');
    RegisterMethod(@TKMemoImageBlock.CalcAscent, 'CalcAscent');
    RegisterVirtualMethod(@TKMemoImageBlock.OuterRect, 'OuterRect');
    RegisterMethod(@TKMemoImageBlock.WordIndexToRect, 'WordIndexToRect');
    RegisterMethod(@TKMemoImageBlock.WordMeasureExtent, 'WordMeasureExtent');
    RegisterMethod(@TKMemoImageBlock.WordPointToIndex, 'WordPointToIndex');
    RegisterMethod(@TKMemoImageBlock.WordPaintToCanvas, 'WordPaintToCanvas');
    RegisterPropertyHelper(@TKMemoImageBlockCrop_R,@TKMemoImageBlockCrop_W,'Crop');
    RegisterPropertyHelper(@TKMemoImageBlockImage_R,@TKMemoImageBlockImage_W,'Image');
    RegisterPropertyHelper(@TKMemoImageBlockImageStyle_R,nil,'ImageStyle');
    RegisterPropertyHelper(@TKMemoImageBlockImageHeight_R,nil,'ImageHeight');
    RegisterPropertyHelper(@TKMemoImageBlockImageWidth_R,nil,'ImageWidth');
    RegisterPropertyHelper(@TKMemoImageBlockOriginalHeight_R,@TKMemoImageBlockOriginalHeight_W,'OriginalHeight');
    RegisterPropertyHelper(@TKMemoImageBlockOriginalWidth_R,@TKMemoImageBlockOriginalWidth_W,'OriginalWidth');
    RegisterPropertyHelper(nil,@TKMemoImageBlockPath_W,'Path');
    RegisterPropertyHelper(@TKMemoImageBlockScaleHeight_R,@TKMemoImageBlockScaleHeight_W,'ScaleHeight');
    RegisterPropertyHelper(@TKMemoImageBlockScaleWidth_R,@TKMemoImageBlockScaleWidth_W,'ScaleWidth');
    RegisterPropertyHelper(@TKMemoImageBlockScaleX_R,@TKMemoImageBlockScaleX_W,'ScaleX');
    RegisterPropertyHelper(@TKMemoImageBlockScaleY_R,@TKMemoImageBlockScaleY_W,'ScaleY');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoParagraph(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoParagraph) do begin
    RegisterConstructor(@TKMemoParagraph.Create, 'Create');
             RegisterMethod(@TKMemoParagraph.Destroy, 'Free');

    RegisterMethod(@TKMemoParagraph.AssignAttributes, 'AssignAttributes');
    RegisterMethod(@TKMemoParagraph.Concat, 'Concat');
    RegisterMethod(@TKMemoParagraph.NotifyDefaultParaChange, 'NotifyDefaultParaChange');
    RegisterMethod(@TKMemoParagraph.Split, 'Split');
    RegisterMethod(@TKMemoParagraph.WordPaintToCanvas, 'WordPaintToCanvas');
    RegisterPropertyHelper(@TKMemoParagraphHeight_R,@TKMemoParagraphHeight_W,'Height');
    RegisterPropertyHelper(@TKMemoParagraphLeft_R,@TKMemoParagraphLeft_W,'Left');
    RegisterPropertyHelper(@TKMemoParagraphNumbering_R,@TKMemoParagraphNumbering_W,'Numbering');
    RegisterPropertyHelper(@TKMemoParagraphNumberingList_R,nil,'NumberingList');
    RegisterPropertyHelper(@TKMemoParagraphNumberingListLevel_R,nil,'NumberingListLevel');
    RegisterPropertyHelper(@TKMemoParagraphNumberBlock_R,nil,'NumberBlock');
    RegisterPropertyHelper(@TKMemoParagraphTop_R,@TKMemoParagraphTop_W,'Top');
    RegisterPropertyHelper(@TKMemoParagraphWidth_R,@TKMemoParagraphWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoHyperlink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoHyperlink) do begin
           RegisterMethod(@TKMemoHyperlink.Destroy, 'Free');
      RegisterMethod(@TKMemoHyperlink.WordMouseAction, 'WordMouseAction');
    RegisterMethod(@TKMemoHyperlink.Assign, 'Assign');
    RegisterVirtualMethod(@TKMemoHyperlink.DefaultStyle, 'DefaultStyle');
    RegisterPropertyHelper(@TKMemoHyperlinkURL_R,@TKMemoHyperlinkURL_W,'URL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoTextBlock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoTextBlock) do begin
    RegisterConstructor(@TKMemoTextBlock.Create, 'Create');
             RegisterMethod(@TKMemoTextBlock.Destroy, 'Free');

    RegisterMethod(@TKMemoTextBlock.Assign, 'Assign');
    RegisterMethod(@TKMemoTextBlock.AssignAttributes, 'AssignAttributes');
    RegisterMethod(@TKMemoTextBlock.CalcAscent, 'CalcAscent');
    RegisterVirtualMethod(@TKMemoTextBlock.CalcDescent, 'CalcDescent');
    RegisterMethod(@TKMemoTextBlock.ClearSelection, 'ClearSelection');
    RegisterMethod(@TKMemoTextBlock.Concat, 'Concat');
    RegisterMethod(@TKMemoTextBlock.EqualProperties, 'EqualProperties');
    RegisterMethod(@TKMemoTextBlock.GetWordIndexes, 'GetWordIndexes');
    RegisterMethod(@TKMemoTextBlock.InsertString, 'InsertString');
    RegisterMethod(@TKMemoTextBlock.NotifyDefaultTextChange, 'NotifyDefaultTextChange');
    RegisterMethod(@TKMemoTextBlock.Split, 'Split');
    RegisterMethod(@TKMemoTextBlock.WordIndexToRect, 'WordIndexToRect');
    RegisterMethod(@TKMemoTextBlock.WordMeasureExtent, 'WordMeasureExtent');
    RegisterMethod(@TKMemoTextBlock.WordPaintToCanvas, 'WordPaintToCanvas');
    RegisterPropertyHelper(@TKMemoTextBlockText_R,@TKMemoTextBlockText_W,'Text');
    RegisterPropertyHelper(@TKMemoTextBlockTextStyle_R,nil,'TextStyle');
    RegisterPropertyHelper(@TKMemoTextBlockWordBreaks_R,nil,'WordBreaks');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoSingleton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoSingleton) do
  begin
    RegisterConstructor(@TKMemoSingleton.Create, 'Create');
    RegisterMethod(@TKMemoSingleton.Select, 'Select');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoBlock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoBlock) do
  begin
    RegisterConstructor(@TKMemoBlock.Create, 'Create');
    RegisterMethod(@TKMemoBlock.Assign, 'Assign');
    RegisterVirtualMethod(@TKMemoBlock.AssignAttributes, 'AssignAttributes');
    RegisterVirtualMethod(@TKMemoBlock.CalcAscent, 'CalcAscent');
    RegisterVirtualMethod(@TKMemoBlock.CanAdd, 'CanAdd');
    RegisterVirtualMethod(@TKMemoBlock.ClearSelection, 'ClearSelection');
    RegisterVirtualMethod(@TKMemoBlock.Concat, 'Concat');
    RegisterVirtualMethod(@TKMemoBlock.GetWordIndexes, 'GetWordIndexes');
    RegisterVirtualMethod(@TKMemoBlock.IndexToRect, 'IndexToRect');
    RegisterVirtualMethod(@TKMemoBlock.InsertParagraph, 'InsertParagraph');
    RegisterVirtualMethod(@TKMemoBlock.InsertString, 'InsertString');
    RegisterVirtualMethod(@TKMemoBlock.MeasureExtent, 'MeasureExtent');
    RegisterVirtualMethod(@TKMemoBlock.NotifyDefaultTextChange, 'NotifyDefaultTextChange');
    RegisterVirtualMethod(@TKMemoBlock.NotifyDefaultParaChange, 'NotifyDefaultParaChange');
    RegisterVirtualMethod(@TKMemoBlock.PaintToCanvas, 'PaintToCanvas');
    RegisterVirtualMethod(@TKMemoBlock.PointToIndex, 'PointToIndex');
    RegisterVirtualMethod(@TKMemoBlock.SelectAll, 'SelectAll');
    RegisterVirtualMethod(@TKMemoBlock.Select, 'Select');
    RegisterVirtualMethod(@TKMemoBlock.SelectableLength, 'SelectableLength');
    RegisterVirtualMethod(@TKMemoBlock.Split, 'Split');
    RegisterVirtualMethod(@TKMemoBlock.WordIndexToRect, 'WordIndexToRect');
    RegisterVirtualMethod(@TKMemoBlock.WordMeasureExtent, 'WordMeasureExtent');
    RegisterVirtualMethod(@TKMemoBlock.WordMouseAction, 'WordMouseAction');
    RegisterVirtualMethod(@TKMemoBlock.WordPaintToCanvas, 'WordPaintToCanvas');
    RegisterVirtualMethod(@TKMemoBlock.WordPointToIndex, 'WordPointToIndex');
    RegisterPropertyHelper(@TKMemoBlockBoundsRect_R,nil,'BoundsRect');
    RegisterPropertyHelper(@TKMemoBlockBottomPadding_R,nil,'BottomPadding');
    RegisterPropertyHelper(@TKMemoBlockCanAddText_R,nil,'CanAddText');
    RegisterPropertyHelper(@TKMemoBlockDefaultTextStyle_R,nil,'DefaultTextStyle');
    RegisterPropertyHelper(@TKMemoBlockDefaultParaStyle_R,nil,'DefaultParaStyle');
    RegisterPropertyHelper(@TKMemoBlockHeight_R,nil,'Height');
    RegisterPropertyHelper(@TKMemoBlockLeft_R,nil,'Left');
    RegisterPropertyHelper(@TKMemoBlockLeftOffset_R,@TKMemoBlockLeftOffset_W,'LeftOffset');
    RegisterPropertyHelper(@TKMemoBlockMemoNotifier_R,nil,'MemoNotifier');
    RegisterPropertyHelper(@TKMemoBlockPaintSelection_R,nil,'PaintSelection');
    RegisterPropertyHelper(@TKMemoBlockParaStyle_R,nil,'ParaStyle');
    RegisterPropertyHelper(@TKMemoBlockParentBlocks_R,nil,'ParentBlocks');
    RegisterPropertyHelper(@TKMemoBlockPosition_R,@TKMemoBlockPosition_W,'Position');
    RegisterPropertyHelper(@TKMemoBlockPrinting_R,nil,'Printing');
    RegisterPropertyHelper(@TKMemoBlockSelLength_R,nil,'SelLength');
    RegisterPropertyHelper(@TKMemoBlockSelStart_R,nil,'SelStart');
    RegisterPropertyHelper(@TKMemoBlockSelText_R,nil,'SelText');
    RegisterPropertyHelper(@TKMemoBlockShowFormatting_R,nil,'ShowFormatting');
    RegisterPropertyHelper(@TKMemoBlockText_R,nil,'Text');
    RegisterPropertyHelper(@TKMemoBlockTop_R,nil,'Top');
    RegisterPropertyHelper(@TKMemoBlockTopOffset_R,@TKMemoBlockTopOffset_W,'TopOffset');
    RegisterPropertyHelper(@TKMemoBlockTopPadding_R,nil,'TopPadding');
    RegisterPropertyHelper(@TKMemoBlockWidth_R,nil,'Width');
    RegisterPropertyHelper(@TKMemoBlockWordCount_R,nil,'WordCount');
    RegisterPropertyHelper(@TKMemoBlockWordBaseLine_R,@TKMemoBlockWordBaseLine_W,'WordBaseLine');
    RegisterPropertyHelper(@TKMemoBlockWordBreakable_R,nil,'WordBreakable');
    RegisterPropertyHelper(@TKMemoBlockWordBottomPadding_R,@TKMemoBlockWordBottomPadding_W,'WordBottomPadding');
    RegisterPropertyHelper(@TKMemoBlockWordBoundsRect_R,nil,'WordBoundsRect');
    RegisterPropertyHelper(@TKMemoBlockWordClipped_R,@TKMemoBlockWordClipped_W,'WordClipped');
    RegisterPropertyHelper(@TKMemoBlockWordHeight_R,@TKMemoBlockWordHeight_W,'WordHeight');
    RegisterPropertyHelper(@TKMemoBlockWordLeft_R,@TKMemoBlockWordLeft_W,'WordLeft');
    RegisterPropertyHelper(@TKMemoBlockWordLength_R,nil,'WordLength');
    RegisterPropertyHelper(@TKMemoBlockWords_R,nil,'Words');
    RegisterPropertyHelper(@TKMemoBlockWordTop_R,@TKMemoBlockWordTop_W,'WordTop');
    RegisterPropertyHelper(@TKMemoBlockWordTopPadding_R,@TKMemoBlockWordTopPadding_W,'WordTopPadding');
    RegisterPropertyHelper(@TKMemoBlockWordWidth_R,@TKMemoBlockWordWidth_W,'WordWidth');
    RegisterPropertyHelper(@TKMemoBlockWrapMode_R,nil,'WrapMode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoWordList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoWordList) do
  begin
    RegisterPropertyHelper(@TKMemoWordListItems_R,@TKMemoWordListItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoWord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoWord) do
  begin
    RegisterConstructor(@TKMemoWord.Create, 'Create');
    RegisterPropertyHelper(@TKMemoWordBaseLine_R,@TKMemoWordBaseLine_W,'BaseLine');
    RegisterPropertyHelper(@TKMemoWordBottomPadding_R,@TKMemoWordBottomPadding_W,'BottomPadding');
    RegisterPropertyHelper(@TKMemoWordClipped_R,@TKMemoWordClipped_W,'Clipped');
    RegisterPropertyHelper(@TKMemoWordEndIndex_R,@TKMemoWordEndIndex_W,'EndIndex');
    RegisterPropertyHelper(@TKMemoWordExtent_R,@TKMemoWordExtent_W,'Extent');
    RegisterPropertyHelper(@TKMemoWordPosition_R,@TKMemoWordPosition_W,'Position');
    RegisterPropertyHelper(@TKMemoWordStartIndex_R,@TKMemoWordStartIndex_W,'StartIndex');
    RegisterPropertyHelper(@TKMemoWordTopPadding_R,@TKMemoWordTopPadding_W,'TopPadding');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoLines(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoLines) do
  begin
    RegisterPropertyHelper(@TKMemoLinesItems_R,@TKMemoLinesItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoLine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoLine) do
  begin
    RegisterConstructor(@TKMemoLine.Create, 'Create');
    RegisterPropertyHelper(@TKMemoLineEndBlock_R,@TKMemoLineEndBlock_W,'EndBlock');
    RegisterPropertyHelper(@TKMemoLineEndIndex_R,@TKMemoLineEndIndex_W,'EndIndex');
    RegisterPropertyHelper(@TKMemoLineEndWord_R,@TKMemoLineEndWord_W,'EndWord');
    RegisterPropertyHelper(@TKMemoLineExtent_R,@TKMemoLineExtent_W,'Extent');
    RegisterPropertyHelper(@TKMemoLinePosition_R,@TKMemoLinePosition_W,'Position');
    RegisterPropertyHelper(@TKMemoLineStartBlock_R,@TKMemoLineStartBlock_W,'StartBlock');
    RegisterPropertyHelper(@TKMemoLineStartIndex_R,@TKMemoLineStartIndex_W,'StartIndex');
    RegisterPropertyHelper(@TKMemoLineStartWord_R,@TKMemoLineStartWord_W,'StartWord');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoParaStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoParaStyle) do
  begin
    RegisterMethod(@TKMemoParaStyle.Assign, 'Assign');
    RegisterMethod(@TKMemoParaStyle.Defaults, 'Defaults');
    RegisterVirtualMethod(@TKMemoParaStyle.SetNumberingListAndLevel, 'SetNumberingListAndLevel');
    RegisterPropertyHelper(@TKMemoParaStyleFirstIndent_R,@TKMemoParaStyleFirstIndent_W,'FirstIndent');
    RegisterPropertyHelper(@TKMemoParaStyleLineSpacingFactor_R,@TKMemoParaStyleLineSpacingFactor_W,'LineSpacingFactor');
    RegisterPropertyHelper(@TKMemoParaStyleLineSpacingMode_R,@TKMemoParaStyleLineSpacingMode_W,'LineSpacingMode');
    RegisterPropertyHelper(@TKMemoParaStyleLineSpacingValue_R,@TKMemoParaStyleLineSpacingValue_W,'LineSpacingValue');
    RegisterPropertyHelper(@TKMemoParaStyleNumberingList_R,@TKMemoParaStyleNumberingList_W,'NumberingList');
    RegisterPropertyHelper(@TKMemoParaStyleNumberingListLevel_R,@TKMemoParaStyleNumberingListLevel_W,'NumberingListLevel');
    RegisterPropertyHelper(@TKMemoParaStyleNumberStartAt_R,@TKMemoParaStyleNumberStartAt_W,'NumberStartAt');
    RegisterPropertyHelper(@TKMemoParaStyleWordWrap_R,@TKMemoParaStyleWordWrap_W,'WordWrap');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoBlockStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoBlockStyle) do begin
    RegisterConstructor(@TKMemoBlockStyle.Create, 'Create');
             RegisterMethod(@TKMemoBlockStyle.Destroy, 'Free');

    RegisterMethod(@TKMemoBlockStyle.Assign, 'Assign');
    RegisterVirtualMethod(@TKMemoBlockStyle.BorderRect, 'BorderRect');
    RegisterVirtualMethod(@TKMemoBlockStyle.InteriorRect, 'InteriorRect');
    RegisterVirtualMethod(@TKMemoBlockStyle.Defaults, 'Defaults');
    RegisterVirtualMethod(@TKMemoBlockStyle.MarginRect, 'MarginRect');
    RegisterVirtualMethod(@TKMemoBlockStyle.NotifyChange, 'NotifyChange');
    RegisterVirtualMethod(@TKMemoBlockStyle.PaintBox, 'PaintBox');
    RegisterPropertyHelper(@TKMemoBlockStyleAllPaddingsBottom_R,nil,'AllPaddingsBottom');
    RegisterPropertyHelper(@TKMemoBlockStyleAllPaddingsLeft_R,nil,'AllPaddingsLeft');
    RegisterPropertyHelper(@TKMemoBlockStyleAllPaddingsRight_R,nil,'AllPaddingsRight');
    RegisterPropertyHelper(@TKMemoBlockStyleAllPaddingsTop_R,nil,'AllPaddingsTop');
    RegisterPropertyHelper(@TKMemoBlockStyleBottomBorderWidth_R,nil,'BottomBorderWidth');
    RegisterPropertyHelper(@TKMemoBlockStyleBottomMargin_R,@TKMemoBlockStyleBottomMargin_W,'BottomMargin');
    RegisterPropertyHelper(@TKMemoBlockStyleBottomPadding_R,@TKMemoBlockStyleBottomPadding_W,'BottomPadding');
    RegisterPropertyHelper(@TKMemoBlockStyleBorderRadius_R,@TKMemoBlockStyleBorderRadius_W,'BorderRadius');
    RegisterPropertyHelper(@TKMemoBlockStyleBorderColor_R,@TKMemoBlockStyleBorderColor_W,'BorderColor');
    RegisterPropertyHelper(@TKMemoBlockStyleBorderWidth_R,@TKMemoBlockStyleBorderWidth_W,'BorderWidth');
    RegisterPropertyHelper(@TKMemoBlockStyleBorderWidths_R,@TKMemoBlockStyleBorderWidths_W,'BorderWidths');
    RegisterPropertyHelper(@TKMemoBlockStyleBrush_R,@TKMemoBlockStyleBrush_W,'Brush');
    RegisterPropertyHelper(@TKMemoBlockStyleContentMargin_R,@TKMemoBlockStyleContentMargin_W,'ContentMargin');
    RegisterPropertyHelper(@TKMemoBlockStyleContentPadding_R,@TKMemoBlockStyleContentPadding_W,'ContentPadding');
    RegisterPropertyHelper(@TKMemoBlockStyleFillBlip_R,@TKMemoBlockStyleFillBlip_W,'FillBlip');
    RegisterPropertyHelper(@TKMemoBlockStyleHAlign_R,@TKMemoBlockStyleHAlign_W,'HAlign');
    RegisterPropertyHelper(@TKMemoBlockStyleLeftBorderWidth_R,nil,'LeftBorderWidth');
    RegisterPropertyHelper(@TKMemoBlockStyleLeftMargin_R,@TKMemoBlockStyleLeftMargin_W,'LeftMargin');
    RegisterPropertyHelper(@TKMemoBlockStyleLeftPadding_R,@TKMemoBlockStyleLeftPadding_W,'LeftPadding');
    RegisterPropertyHelper(@TKMemoBlockStyleRightBorderWidth_R,nil,'RightBorderWidth');
    RegisterPropertyHelper(@TKMemoBlockStyleRightMargin_R,@TKMemoBlockStyleRightMargin_W,'RightMargin');
    RegisterPropertyHelper(@TKMemoBlockStyleRightPadding_R,@TKMemoBlockStyleRightPadding_W,'RightPadding');
    RegisterPropertyHelper(@TKMemoBlockStyleStyleChanged_R,@TKMemoBlockStyleStyleChanged_W,'StyleChanged');
    RegisterPropertyHelper(@TKMemoBlockStyleTopBorderWidth_R,nil,'TopBorderWidth');
    RegisterPropertyHelper(@TKMemoBlockStyleTopMargin_R,@TKMemoBlockStyleTopMargin_W,'TopMargin');
    RegisterPropertyHelper(@TKMemoBlockStyleTopPadding_R,@TKMemoBlockStyleTopPadding_W,'TopPadding');
    RegisterPropertyHelper(@TKMemoBlockStyleWrapMode_R,@TKMemoBlockStyleWrapMode_W,'WrapMode');
    RegisterPropertyHelper(@TKMemoBlockStyleOnChanged_R,@TKMemoBlockStyleOnChanged_W,'OnChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoTextStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoTextStyle) do begin
    RegisterVirtualConstructor(@TKMemoTextStyle.Create, 'Create');
             RegisterMethod(@TKMemoTextStyle.Destroy, 'Free');

    RegisterMethod(@TKMemoTextStyle.Assign, 'Assign');
    RegisterVirtualMethod(@TKMemoTextStyle.Defaults, 'Defaults');
    RegisterVirtualMethod(@TKMemoTextStyle.EqualProperties, 'EqualProperties');
    RegisterVirtualMethod(@TKMemoTextStyle.NotifyChange, 'NotifyChange');
    RegisterPropertyHelper(@TKMemoTextStyleAllowBrush_R,@TKMemoTextStyleAllowBrush_W,'AllowBrush');
    RegisterPropertyHelper(@TKMemoTextStyleCapitals_R,@TKMemoTextStyleCapitals_W,'Capitals');
    RegisterPropertyHelper(@TKMemoTextStyleBrush_R,@TKMemoTextStyleBrush_W,'Brush');
    RegisterPropertyHelper(@TKMemoTextStyleFont_R,@TKMemoTextStyleFont_W,'Font');
    RegisterPropertyHelper(@TKMemoTextStyleScriptPosition_R,@TKMemoTextStyleScriptPosition_W,'ScriptPosition');
    RegisterPropertyHelper(@TKMemoTextStyleStyleChanged_R,@TKMemoTextStyleStyleChanged_W,'StyleChanged');
    RegisterPropertyHelper(@TKMemoTextStyleOnChanged_R,@TKMemoTextStyleOnChanged_W,'OnChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoListTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoListTable) do
  begin
    RegisterConstructor(@TKMemoListTable.Create, 'Create');
    RegisterMethod(@TKMemoListTable.ClearLevelCounters, 'ClearLevelCounters');
    RegisterMethod(@TKMemoListTable.FindByID, 'FindByID');
    RegisterVirtualMethod(@TKMemoListTable.ListChanged, 'ListChanged');
    RegisterVirtualMethod(@TKMemoListTable.ListByNumbering, 'ListByNumbering');
    RegisterMethod(@TKMemoListTable.NextID, 'NextID');
    RegisterPropertyHelper(@TKMemoListTableItems_R,@TKMemoListTableItems_W,'Items');
    RegisterPropertyHelper(@TKMemoListTableOnChanged_R,@TKMemoListTableOnChanged_W,'OnChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoList) do begin
    RegisterConstructor(@TKMemoList.Create, 'Create');
             RegisterMethod(@TKMemoList.Destroy, 'Free');

    RegisterMethod(@TKMemoList.Assign, 'Assign');
    RegisterVirtualMethod(@TKMemoList.LevelChanged, 'LevelChanged');
    RegisterPropertyHelper(@TKMemoListID_R,@TKMemoListID_W,'ID');
    RegisterPropertyHelper(@TKMemoListLevels_R,nil,'Levels');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoListLevels(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoListLevels) do
  begin
    RegisterConstructor(@TKMemoListLevels.Create, 'Create');
    RegisterVirtualMethod(@TKMemoListLevels.Changed, 'Changed');
    RegisterVirtualMethod(@TKMemoListLevels.ClearLevelCounters, 'ClearLevelCounters');
    RegisterPropertyHelper(@TKMemoListLevelsItems_R,@TKMemoListLevelsItems_W,'Items');
    RegisterPropertyHelper(@TKMemoListLevelsParent_R,@TKMemoListLevelsParent_W,'Parent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoListLevel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoListLevel) do begin
    RegisterConstructor(@TKMemoListLevel.Create, 'Create');
             RegisterMethod(@TKMemoListLevel.Destroy, 'Free');

    RegisterMethod(@TKMemoListLevel.Assign, 'Assign');
    RegisterPropertyHelper(@TKMemoListLevelLevelCounter_R,@TKMemoListLevelLevelCounter_W,'LevelCounter');
    RegisterPropertyHelper(@TKMemoListLevelFirstIndent_R,@TKMemoListLevelFirstIndent_W,'FirstIndent');
    RegisterPropertyHelper(@TKMemoListLevelLeftIndent_R,@TKMemoListLevelLeftIndent_W,'LeftIndent');
    RegisterPropertyHelper(@TKMemoListLevelNumbering_R,@TKMemoListLevelNumbering_W,'Numbering');
    RegisterPropertyHelper(@TKMemoListLevelNumberingFont_R,nil,'NumberingFont');
    RegisterPropertyHelper(@TKMemoListLevelNumberingFontChanged_R,nil,'NumberingFontChanged');
    RegisterPropertyHelper(@TKMemoListLevelNumberingFormat_R,nil,'NumberingFormat');
    RegisterPropertyHelper(@TKMemoListLevelNumberStartAt_R,@TKMemoListLevelNumberStartAt_W,'NumberStartAt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoNumberingFormat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoNumberingFormat) do
  begin
    RegisterMethod(@TKMemoNumberingFormat.AddItem, 'AddItem');
    RegisterMethod(@TKMemoNumberingFormat.Defaults, 'Defaults');
    RegisterMethod(@TKMemoNumberingFormat.InsertItem, 'InsertItem');
    RegisterPropertyHelper(@TKMemoNumberingFormatItems_R,@TKMemoNumberingFormatItems_W,'Items');
    RegisterPropertyHelper(@TKMemoNumberingFormatLevelCount_R,nil,'LevelCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoNumberingFormatItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoNumberingFormatItem) do
  begin
    RegisterConstructor(@TKMemoNumberingFormatItem.Create, 'Create');
    RegisterMethod(@TKMemoNumberingFormatItem.Assign, 'Assign');
    RegisterPropertyHelper(@TKMemoNumberingFormatItemLevel_R,@TKMemoNumberingFormatItemLevel_W,'Level');
    RegisterPropertyHelper(@TKMemoNumberingFormatItemText_R,@TKMemoNumberingFormatItemText_W,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoDictionary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoDictionary) do
  begin
    RegisterMethod(@TKMemoDictionary.AddItem, 'AddItem');
    RegisterMethod(@TKMemoDictionary.FindItem, 'FindItem');
    RegisterMethod(@TKMemoDictionary.GetValue, 'GetValue');
    RegisterMethod(@TKMemoDictionary.SetValue, 'SetValue');
    RegisterPropertyHelper(@TKMemoDictionaryItems_R,@TKMemoDictionaryItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoDictionaryItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoDictionaryItem) do
  begin
    RegisterConstructor(@TKMemoDictionaryItem.Create, 'Create');
    RegisterMethod(@TKMemoDictionaryItem.Assign, 'Assign');
    RegisterMethod(@TKMemoDictionaryItem.EqualProperties, 'EqualProperties');
    RegisterPropertyHelper(@TKMemoDictionaryItemIndex_R,@TKMemoDictionaryItemIndex_W,'Index');
    RegisterPropertyHelper(@TKMemoDictionaryItemValue_R,@TKMemoDictionaryItemValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoSparseStack(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoSparseStack) do
  begin
    RegisterMethod(@TKMemoSparseStack.Push, 'Push');
    RegisterMethod(@TKMemoSparseStack.Pop, 'Pop');
    RegisterMethod(@TKMemoSparseStack.Peek, 'Peek');
    RegisterMethod(@TKMemoSparseStack.PushValue, 'PushValue');
    RegisterMethod(@TKMemoSparseStack.PopValue, 'PopValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoSparseList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoSparseList) do
  begin
    RegisterMethod(@TKMemoSparseList.AddItem, 'AddItem');
    RegisterVirtualMethod(@TKMemoSparseList.SetSize, 'SetSize');
    RegisterPropertyHelper(@TKMemoSparseListItems_R,@TKMemoSparseListItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoSparseItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoSparseItem) do
  begin
    RegisterConstructor(@TKMemoSparseItem.Create, 'Create');
    RegisterMethod(@TKMemoSparseItem.Assign, 'Assign');
    RegisterMethod(@TKMemoSparseItem.EqualProperties, 'EqualProperties');
    RegisterPropertyHelper(@TKMemoSparseItemIndex_R,@TKMemoSparseItemIndex_W,'Index');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KMemo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKCustomMemo) do
  RIRegister_TKMemoSparseItem(CL);
  RIRegister_TKMemoSparseList(CL);
  RIRegister_TKMemoSparseStack(CL);
  RIRegister_TKMemoDictionaryItem(CL);
  RIRegister_TKMemoDictionary(CL);
  RIRegister_TKMemoNumberingFormatItem(CL);
  RIRegister_TKMemoNumberingFormat(CL);
  with CL.Add(TKMemoListLevels) do
  RIRegister_TKMemoListLevel(CL);
  with CL.Add(TKMemoList) do
  RIRegister_TKMemoListLevels(CL);
  with CL.Add(TKMemoListTable) do
  RIRegister_TKMemoList(CL);
  RIRegister_TKMemoListTable(CL);
  RIRegister_TKMemoTextStyle(CL);
  RIRegister_TKMemoBlockStyle(CL);
  RIRegister_TKMemoParaStyle(CL);
  RIRegister_TKMemoLine(CL);
  RIRegister_TKMemoLines(CL);
  RIRegister_TKMemoWord(CL);
  RIRegister_TKMemoWordList(CL);
  with CL.Add(TKMemoBlocks) do
  RIRegister_TKMemoBlock(CL);
  RIRegister_TKMemoSingleton(CL);
  RIRegister_TKMemoTextBlock(CL);
  RIRegister_TKMemoHyperlink(CL);
  RIRegister_TKMemoParagraph(CL);
  RIRegister_TKMemoImageBlock(CL);
  RIRegister_TKMemoContainer(CL);
  with CL.Add(TKMemoTable) do
  with CL.Add(TKMemoTableRow) do
  RIRegister_TKMemoTableCell(CL);
  RIRegister_TKMemoTableRow(CL);
  RIRegister_TKMemoTable(CL);
  RIRegister_TKMemoBlocks(CL);
  RIRegister_TKMemoColors(CL);
  RIRegister_TKMemoChangeList(CL);
  RIRegister_TKCustomMemo(CL);
  RIRegister_TKMemo(CL);
  RIRegister_TKMemoEditAction(CL);
  RIRegister_TKMemoEditCopyAction(CL);
  RIRegister_TKMemoEditCutAction(CL);
  RIRegister_TKMemoEditPasteAction(CL);
  RIRegister_TKMemoEditSelectAllAction(CL);
end;

 
 
{ TPSImport_KMemo }
(*----------------------------------------------------------------------------*)
procedure TPSImport_KMemo.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_KMemo(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_KMemo.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_KMemo(ri);
  RIRegister_KMemo_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
