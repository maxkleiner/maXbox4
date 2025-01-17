unit uPSI_SynEdit;
{
  to configure memo1 direct and provide some macros like #date
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
  TPSImport_SynEdit = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynEdit(CL: TPSPascalCompiler);
procedure SIRegister_TCustomSynEdit(CL: TPSPascalCompiler);
procedure SIRegister_TSynEditPlugin(CL: TPSPascalCompiler);
procedure SIRegister_SynEdit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomSynEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynEditPlugin(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynEdit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  { Xlib
  ,Qt
  ,Types
  ,QControls
  ,QGraphics
  ,QForms
  ,QStdCtrls
  ,QExtCtrls}
  Controls
  ,Graphics
  ,Forms
  ,StdCtrls
  ,ExtCtrls
 // ,Windows
  //,Messages
  //,Themes
  //,Imm
  //,kTextDrawer
  {,QSynEditTypes
  ,QSynEditKeyConst
  ,QSynEditMiscProcs
  ,QSynEditMiscClasses
  ,QSynEditTextBuffer
  ,QSynEditKeyCmds
  ,QSynEditHighlighter
  ,QSynEditKbdHandler }
  ,SynTextDrawer
  ,SynEditTypes
  ,SynEditKeyConst
  ,SynEditMiscProcs
  ,SynEditMiscClasses
  ,SynEditTextBuffer
  ,SynEditKeyCmds
  ,SynEditHighlighter
  ,SynEditKbdHandler
  ,Math
  ,SynEdit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEdit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSynEdit', 'TSynEdit') do
  with CL.AddClassN(CL.FindClass('TCustomSynEdit'),'TSynEdit') do
  begin
  end;
end;

//helper method
procedure ExecuteCommand2(Command: TSynEditorCommand; AChar:char);
begin
  //TCustomSynEdit(self).ExecuteCommand(Command, AChar, NIL);
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomSynEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TCustomSynEdit') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TCustomSynEdit') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('SelStart', 'Integer', iptrw);
    RegisterProperty('SelEnd', 'Integer', iptrw);
    RegisterProperty('AlwaysShowCaret', 'Boolean', iptrw);
    RegisterMethod('Procedure UpdateCaret');
    RegisterMethod('Procedure AddKey( Command : TSynEditorCommand; Key1 : word; SS1 : TShiftState; Key2 : word; SS2 : TShiftState)');
    RegisterMethod('Procedure AddKey( Command : TSynEditorCommand; Key1 : word; SS1 : TShiftState; Key2 : word; SS2 : TShiftState)');
    RegisterMethod('Procedure BeginUndoBlock');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Function CaretInView : Boolean');
    RegisterMethod('Function CharIndexToRowCol( Index : integer) : TBufferCoord');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure ClearAll');
    RegisterMethod('Procedure ClearBookMark( BookMark : Integer)');
    RegisterMethod('Procedure ClearSelection');
    RegisterMethod('Procedure CommandProcessor( Command : TSynEditorCommand; AChar : char; Data : integer)');
    RegisterMethod('Procedure CommandProcessor2( Command : TSynEditorCommand; AChar : char)');
    RegisterMethod('Procedure ClearUndo');
    RegisterMethod('Procedure CopyToClipboard');
    RegisterMethod('Procedure CutToClipboard');
    RegisterMethod('Procedure DoCopyToClipboard( const SText : string)');
    RegisterMethod('Procedure EndUndoBlock');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Procedure EnsureCursorPosVisible');
    RegisterMethod('Procedure EnsureCursorPosVisibleEx( ForceToMiddle : Boolean)');
    RegisterMethod('Procedure FindMatchingBracket');
    RegisterMethod('Function GetMatchingBracket : TBufferCoord');
    RegisterMethod('Function GetMatchingBracketEx( const APoint : TBufferCoord) : TBufferCoord');
    RegisterMethod('Procedure ExecuteCommand( Command : TSynEditorCommand; AChar : char; Data : integer)');
    RegisterMethod('Procedure ExecuteCommand2( Command : TSynEditorCommand; AChar : char)');
    RegisterMethod('Function GetBookMark( BookMark : integer; var X, Y : integer) : boolean');
    RegisterMethod('Function GetHighlighterAttriAtRowCol( const XY : TBufferCoord; var Token : string; var Attri : TSynHighlighterAttributes) : boolean');
    RegisterMethod('Function GetHighlighterAttriAtRowColEx( const XY : TBufferCoord; var Token : string; var TokenType, Start : Integer; var Attri : TSynHighlighterAttributes) : boolean');
    RegisterMethod('Function GetPositionOfMouse( out aPos : TBufferCoord) : Boolean');
    RegisterMethod('Function GetWordAtRowCol( const XY : TBufferCoord) : string');
    RegisterMethod('Procedure GotoBookMark( BookMark : Integer)');
    RegisterMethod('Procedure GotoLineAndCenter( ALine : Integer)');
    RegisterMethod('Function IdentChars : TSynIdentChars');
    RegisterMethod('Procedure InvalidateGutter');
    RegisterMethod('Procedure InvalidateGutterLine( aLine : integer)');
    RegisterMethod('Procedure InvalidateGutterLines( FirstLine, LastLine : integer)');
    RegisterMethod('Procedure InvalidateLine( Line : integer)');
    RegisterMethod('Procedure InvalidateLines( FirstLine, LastLine : integer)');
    RegisterMethod('Procedure InvalidateSelection');
    RegisterMethod('Function IsBookmark( BookMark : integer) : boolean');
    RegisterMethod('Function IsPointInSelection( const Value : TBufferCoord) : boolean');
    RegisterMethod('Procedure LockUndo');
    RegisterMethod('Function BufferToDisplayPos( const p : TBufferCoord) : TDisplayCoord');
    RegisterMethod('Function DisplayToBufferPos( const p : TDisplayCoord) : TBufferCoord');
    RegisterMethod('Function LineToRow( aLine : integer) : integer');
    RegisterMethod('Function RowToLine( aRow : integer) : integer');
    RegisterMethod('Function NextWordPos : TBufferCoord');
    RegisterMethod('Function NextWordPosEx( const XY : TBufferCoord) : TBufferCoord');
    RegisterMethod('Procedure PasteFromClipboard');
    RegisterMethod('Function WordStart : TBufferCoord');
    RegisterMethod('Function WordStartEx( const XY : TBufferCoord) : TBufferCoord');
    RegisterMethod('Function WordEnd : TBufferCoord');
    RegisterMethod('Function WordEndEx( const XY : TBufferCoord) : TBufferCoord');
    RegisterMethod('Function PrevWordPos : TBufferCoord');
    RegisterMethod('Function PrevWordPosEx( const XY : TBufferCoord) : TBufferCoord');
    RegisterMethod('Function PixelsToRowColumn( aX, aY : integer) : TDisplayCoord');
    RegisterMethod('Function PixelsToNearestRowColumn( aX, aY : integer) : TDisplayCoord');
    RegisterMethod('Procedure Redo');
    //RegisterMethod('Procedure RegisterCommandHandler( const AHandlerProc : THookedCommandEvent; AHandlerData : pointer)');
    RegisterMethod('Function RowColumnToPixels( const RowCol : TDisplayCoord) : TPoint');
    RegisterMethod('Function RowColToCharIndex( RowCol : TBufferCoord) : integer');
    RegisterMethod('Function SearchReplace( const ASearch, AReplace : string; AOptions : TSynSearchOptions) : integer');
    RegisterMethod('Procedure SelectAll');
    RegisterMethod('Procedure SetBookMark( BookMark : Integer; X : Integer; Y : Integer)');
    RegisterMethod('Procedure SetCaretAndSelection( const ptCaret, ptBefore, ptAfter : TBufferCoord)');
    RegisterMethod('Procedure SetDefaultKeystrokes');
    RegisterMethod('Procedure SetSelWord');
    RegisterMethod('Procedure SetWordBlock( Value : TBufferCoord)');
    RegisterMethod('Procedure Undo');
    RegisterMethod('Procedure UnlockUndo');
    //RegisterMethod('Procedure UnregisterCommandHandler( AHandlerProc : THookedCommandEvent)');
    RegisterMethod('Procedure AddKeyUpHandler( aHandler : TKeyEvent)');
    RegisterMethod('Procedure RemoveKeyUpHandler( aHandler : TKeyEvent)');
    RegisterMethod('Procedure AddKeyDownHandler( aHandler : TKeyEvent)');
    RegisterMethod('Procedure RemoveKeyDownHandler( aHandler : TKeyEvent)');
    RegisterMethod('Procedure AddKeyPressHandler( aHandler : TKeyPressEvent)');
    RegisterMethod('Procedure RemoveKeyPressHandler( aHandler : TKeyPressEvent)');
    RegisterMethod('Procedure AddFocusControl( aControl : TWinControl)');
    RegisterMethod('Procedure RemoveFocusControl( aControl : TWinControl)');
    RegisterMethod('Procedure AddMouseDownHandler( aHandler : TMouseEvent)');
    RegisterMethod('Procedure RemoveMouseDownHandler( aHandler : TMouseEvent)');
    RegisterMethod('Procedure AddMouseUpHandler( aHandler : TMouseEvent)');
    RegisterMethod('Procedure RemoveMouseUpHandler( aHandler : TMouseEvent)');
    RegisterMethod('Procedure AddMouseCursorHandler( aHandler : TMouseCursorEvent)');
    RegisterMethod('Procedure RemoveMouseCursorHandler( aHandler : TMouseCursorEvent)');
    RegisterMethod('Procedure SetLinesPointer( ASynEdit : TCustomSynEdit)');
    RegisterMethod('Procedure RemoveLinesPointer');
    RegisterMethod('Procedure HookTextBuffer( aBuffer : TSynEditStringList; aUndo, aRedo : TSynEditUndoList)');
    RegisterMethod('Procedure UnHookTextBuffer');
    RegisterProperty('BlockBegin', 'TBufferCoord', iptrw);
    RegisterProperty('BlockEnd', 'TBufferCoord', iptrw);
    RegisterProperty('CanPaste', 'Boolean', iptr);
    RegisterProperty('CanRedo', 'boolean', iptr);
    RegisterProperty('CanUndo', 'boolean', iptr);
    RegisterProperty('CaretX', 'Integer', iptrw);
    RegisterProperty('CaretY', 'Integer', iptrw);
    RegisterProperty('CaretXY', 'TBufferCoord', iptrw);
    RegisterProperty('ActiveLineColor', 'TColor', iptrw);
    RegisterProperty('DisplayX', 'Integer', iptr);
    RegisterProperty('DisplayY', 'Integer', iptr);
    RegisterProperty('DisplayXY', 'TDisplayCoord', iptr);
    RegisterProperty('DisplayLineCount', 'integer', iptr);
    RegisterProperty('CharsInWindow', 'Integer', iptr);
    RegisterProperty('CharWidth', 'integer', iptr);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('GutterWidth', 'Integer', iptr);
    RegisterProperty('Highlighter', 'TSynCustomHighlighter', iptrw);
    RegisterProperty('LeftChar', 'Integer', iptrw);
    RegisterProperty('LineHeight', 'integer', iptr);
    RegisterProperty('LinesInWindow', 'Integer', iptr);
    RegisterProperty('LineText', 'string', iptrw);
    RegisterProperty('Lines', 'TStrings', iptrw);
    RegisterProperty('Marks', 'TSynEditMarkList', iptr);
    RegisterProperty('MaxScrollWidth', 'integer', iptrw);
    RegisterProperty('Modified', 'Boolean', iptrw);
    RegisterProperty('PaintLock', 'Integer', iptr);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
    RegisterProperty('SearchEngine', 'TSynEditSearchCustom', iptrw);
    RegisterProperty('SelAvail', 'Boolean', iptr);
    RegisterProperty('SelLength', 'integer', iptrw);
    RegisterProperty('SelTabBlock', 'Boolean', iptr);
    RegisterProperty('SelTabLine', 'Boolean', iptr);
    RegisterProperty('SelText', 'string', iptrw);
    RegisterProperty('StateFlags', 'TSynStateFlags', iptr);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('TopLine', 'Integer', iptrw);
    RegisterProperty('WordAtCursor', 'string', iptr);
    RegisterProperty('WordAtMouse', 'string', iptr);
    RegisterProperty('UndoList', 'TSynEditUndoList', iptr);
    RegisterProperty('RedoList', 'TSynEditUndoList', iptr);
    RegisterProperty('OnProcessCommand', 'TProcessCommandEvent', iptrw);
    RegisterProperty('BookMarkOptions', 'TSynBookMarkOpt', iptrw);
    RegisterProperty('BorderStyle', 'TSynBorderStyle', iptrw);
    RegisterProperty('ExtraLineSpacing', 'integer', iptrw);
    RegisterProperty('Gutter', 'TSynGutter', iptrw);
    RegisterProperty('HideSelection', 'boolean', iptrw);
    RegisterProperty('InsertCaret', 'TSynEditCaretType', iptrw);
    RegisterProperty('InsertMode', 'boolean', iptrw);
    RegisterProperty('IsScrolling', 'Boolean', iptr);
    RegisterProperty('Keystrokes', 'TSynEditKeyStrokes', iptrw);
    RegisterProperty('MaxUndo', 'Integer', iptrw);
    RegisterProperty('Options', 'TSynEditorOptions', iptrw);
    RegisterProperty('OverwriteCaret', 'TSynEditCaretType', iptrw);
    RegisterProperty('RightEdge', 'Integer', iptrw);
    RegisterProperty('RightEdgeColor', 'TColor', iptrw);
    RegisterProperty('ScrollHintColor', 'TColor', iptrw);
    RegisterProperty('ScrollHintFormat', 'TScrollHintFormat', iptrw);
    RegisterProperty('ScrollBars', 'TScrollStyle', iptrw);
    RegisterProperty('SelectedColor', 'TSynSelectedColor', iptrw);
    RegisterProperty('SelectionMode', 'TSynSelectionMode', iptrw);
    RegisterProperty('ActiveSelectionMode', 'TSynSelectionMode', iptrw);
    RegisterProperty('TabWidth', 'integer', iptrw);
    RegisterProperty('WantReturns', 'boolean', iptrw);
    RegisterProperty('WantTabs', 'boolean', iptrw);
    RegisterProperty('WordWrap', 'boolean', iptrw);
    RegisterProperty('WordWrapGlyph', 'TSynGlyph', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnClearBookmark', 'TPlaceMarkEvent', iptrw);
    RegisterProperty('OnCommandProcessed', 'TProcessCommandEvent', iptrw);
    RegisterProperty('OnContextHelp', 'TContextHelpEvent', iptrw);
    RegisterProperty('OnDropFiles', 'TDropFilesEvent', iptrw);
    RegisterProperty('OnGutterClick', 'TGutterClickEvent', iptrw);
    RegisterProperty('OnGutterGetText', 'TGutterGetTextEvent', iptrw);
    RegisterProperty('OnGutterPaint', 'TGutterPaintEvent', iptrw);
    RegisterProperty('OnMouseCursor', 'TMouseCursorEvent', iptrw);
    RegisterProperty('OnPaint', 'TPaintEvent', iptrw);
    RegisterProperty('OnPlaceBookmark', 'TPlaceMarkEvent', iptrw);
    RegisterProperty('OnProcessUserCommand', 'TProcessCommandEvent', iptrw);
    RegisterProperty('OnReplaceText', 'TReplaceTextEvent', iptrw);
    RegisterProperty('OnSpecialLineColors', 'TSpecialLineColorsEvent', iptrw);
    RegisterProperty('OnStatusChange', 'TStatusChangeEvent', iptrw);
    RegisterProperty('OnPaintTransient', 'TPaintTransient', iptrw);
    RegisterProperty('OnScroll', 'TScrollEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditPlugin(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSynEditPlugin') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSynEditPlugin') do
  begin
    RegisterMethod('Constructor Create( AOwner : TCustomSynEdit)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEdit(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('WM_MOUSEWHEEL','LongWord').SetUInt( $020A);
 CL.AddConstantN('MAX_SCROLL','LongInt').SetInt( 32767);
 CL.AddConstantN('MAX_MARKS','LongInt').SetInt( 16);
 CL.AddConstantN('SYNEDIT_CLIPBOARD_FORMAT','String').SetString( 'SynEdit Control Block Type');
  CL.AddTypeS('TSynBorderStyle', 'TBorderStyle');
  CL.AddTypeS('TSynReplaceAction', '( raCancel, raSkip, raReplace, raReplaceAll)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ESynEditError');
  CL.AddTypeS('TDropFilesEvent', 'Procedure ( Sender : TObject; X, Y : integer;'
   +' AFiles : TStrings)');
  CL.AddTypeS('TSynEditMarks', 'array[1..16] of TSynEditMark');

   // TSynEditMarks = array[1..MAX_MARKS] of TSynEditMark;

  //CL.AddTypeS('THookedCommandEvent', 'Procedure ( Sender : TObject; AfterProces'
  // +'sing : boolean; var Handled : boolean; var Command : TSynEditorCommand; va'
   //+'r AChar : char; Data : pointer; HandlerData : pointer)');
  CL.AddTypeS('TPaintEvent', 'Procedure ( Sender : TObject; ACanvas : TCanvas)');
  //CL.AddTypeS('TProcessCommandEvent', 'Procedure ( Sender : TObject; var Comman'
   //+'d : TSynEditorCommand; var AChar : char; Data : pointer)');
  CL.AddTypeS('TReplaceTextEvent', 'Procedure ( Sender : TObject; const ASearch'
   +', AReplace : string; Line, Column : integer; var Action : TSynReplaceAction)');
  CL.AddTypeS('TSpecialLineColorsEvent', 'Procedure ( Sender : TObject; Line : '
   +'integer; var Special : boolean; var FG, BG : TColor)');
  CL.AddTypeS('TTransientType', '( ttBefore, ttAfter )');
  CL.AddTypeS('TPaintTransient', 'Procedure ( Sender : TObject; Canvas : TCanva'
   +'s; TransientType : TTransientType)');
  CL.AddTypeS('TScrollEvent', 'Procedure ( Sender : TObject; ScrollBar : TScrollBarKind)');
  CL.AddTypeS('TGutterGetTextEvent', 'Procedure ( Sender : TObject; aLine : int'
   +'eger; var aText : string)');
  CL.AddTypeS('TGutterPaintEvent', 'Procedure ( Sender : TObject; aLine : integer; X, Y : integer)');
  CL.AddTypeS('TSynEditCaretType', '( ctVerticalLine, ctHorizontalLine, ctHalfBlock, ctBlock )');
  CL.AddTypeS('TSynStateFlag', '( sfCaretChanged, sfScrollbarChanged, sfLinesCh'
   +'anging, sfIgnoreNextChar, sfCaretVisible, sfDblClicked, sfPossibleGutterCl'
   +'ick, sfWaitForDragging, sfGutterDragging )');
  CL.AddTypeS('TSynStateFlags', 'set of TSynStateFlag');
  CL.AddTypeS('TScrollHintFormat', '( shfTopLineOnly, shfTopToBottom )');
  CL.AddTypeS('TSynEditorOption', '( eoAltSetsColumnMode, eoAutoIndent, eoAutoS'
   +'izeMaxScrollWidth, eoDisableScrollArrows, eoDragDropEditing, eoDropFiles, '
   +'eoEnhanceHomeKey, eoEnhanceEndKey, eoGroupUndo, eoHalfPageScroll, eoHideSh'
   +'owScrollbars, eoKeepCaretX, eoNoCaret, eoNoSelection, eoRightMouseMovesCur'
   +'sor, eoScrollByOneLess, eoScrollHintFollows, eoScrollPastEof, eoScrollPast'
   +'Eol, eoShowScrollHint, eoShowSpecialChars, eoSmartTabDelete, eoSmartTabs, '
   +'eoSpecialLineDefaultFg, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces)');
  CL.AddTypeS('TSynEditorOptions', 'set of TSynEditorOption');
 CL.AddConstantN('SYNEDIT_DEFAULT_OPTIONS','LongInt').Value.ts32 := ord(eoAutoIndent) or ord(eoDragDropEditing) or ord(eoEnhanceEndKey) or ord(eoScrollPastEol) or ord(eoShowScrollHint) or ord(eoSmartTabs) or ord(eoTabsToSpaces) or ord(eoSmartTabDelete) or ord(eoGroupUndo);
  CL.AddTypeS('TSynStatusChange', '( scAll, scCaretX, scCaretY, scLeftChar, scT'
   +'opLine, scInsertMode, scModified, scSelection, scReadOnly )');
  CL.AddTypeS('TSynStatusChanges', 'set of TSynStatusChange');
  CL.AddTypeS('TContextHelpEvent', 'Procedure ( Sender : TObject; word : string)');
  CL.AddTypeS('TStatusChangeEvent', 'Procedure ( Sender : TObject; Changes : TS'
   +'ynStatusChanges)');
  //CL.AddTypeS('TMouseCursorEvent', 'Procedure ( Sender : TObject; const aLineCh'
   //+'arPos : TBufferCoord; var aCursor : TCursor)');
  //CL.AddTypeS('TPlaceMarkEvent', 'Procedure ( Sender : TObject; var Mark : TSynEditMark)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomSynEdit');
  //CL.AddTypeS('TGutterClickEvent', 'Procedure ( Sender : TObject; Button : TMou'
   //+'seButton; X, Y, Line : integer; Mark : TSynEditMark)');
  SIRegister_TSynEditPlugin(CL);
  SIRegister_TCustomSynEdit(CL);
  SIRegister_TSynEdit(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnScroll_W(Self: TCustomSynEdit; const T: TScrollEvent);
begin Self.OnScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnScroll_R(Self: TCustomSynEdit; var T: TScrollEvent);
begin T := Self.OnScroll; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnPaintTransient_W(Self: TCustomSynEdit; const T: TPaintTransient);
begin Self.OnPaintTransient := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnPaintTransient_R(Self: TCustomSynEdit; var T: TPaintTransient);
begin T := Self.OnPaintTransient; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnStatusChange_W(Self: TCustomSynEdit; const T: TStatusChangeEvent);
begin Self.OnStatusChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnStatusChange_R(Self: TCustomSynEdit; var T: TStatusChangeEvent);
begin T := Self.OnStatusChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnSpecialLineColors_W(Self: TCustomSynEdit; const T: TSpecialLineColorsEvent);
begin Self.OnSpecialLineColors := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnSpecialLineColors_R(Self: TCustomSynEdit; var T: TSpecialLineColorsEvent);
begin T := Self.OnSpecialLineColors; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnReplaceText_W(Self: TCustomSynEdit; const T: TReplaceTextEvent);
begin Self.OnReplaceText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnReplaceText_R(Self: TCustomSynEdit; var T: TReplaceTextEvent);
begin T := Self.OnReplaceText; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnProcessUserCommand_W(Self: TCustomSynEdit; const T: TProcessCommandEvent);
begin Self.OnProcessUserCommand := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnProcessUserCommand_R(Self: TCustomSynEdit; var T: TProcessCommandEvent);
begin T := Self.OnProcessUserCommand; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnPlaceBookmark_W(Self: TCustomSynEdit; const T: TPlaceMarkEvent);
begin Self.OnPlaceBookmark := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnPlaceBookmark_R(Self: TCustomSynEdit; var T: TPlaceMarkEvent);
begin T := Self.OnPlaceBookmark; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnPaint_W(Self: TCustomSynEdit; const T: TPaintEvent);
begin Self.OnPaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnPaint_R(Self: TCustomSynEdit; var T: TPaintEvent);
begin T := Self.OnPaint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnMouseCursor_W(Self: TCustomSynEdit; const T: TMouseCursorEvent);
begin Self.OnMouseCursor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnMouseCursor_R(Self: TCustomSynEdit; var T: TMouseCursorEvent);
begin T := Self.OnMouseCursor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnGutterPaint_W(Self: TCustomSynEdit; const T: TGutterPaintEvent);
begin Self.OnGutterPaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnGutterPaint_R(Self: TCustomSynEdit; var T: TGutterPaintEvent);
begin T := Self.OnGutterPaint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnGutterGetText_W(Self: TCustomSynEdit; const T: TGutterGetTextEvent);
begin Self.OnGutterGetText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnGutterGetText_R(Self: TCustomSynEdit; var T: TGutterGetTextEvent);
begin T := Self.OnGutterGetText; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnGutterClick_W(Self: TCustomSynEdit; const T: TGutterClickEvent);
begin Self.OnGutterClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnGutterClick_R(Self: TCustomSynEdit; var T: TGutterClickEvent);
begin T := Self.OnGutterClick; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnDropFiles_W(Self: TCustomSynEdit; const T: TDropFilesEvent);
begin Self.OnDropFiles := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnDropFiles_R(Self: TCustomSynEdit; var T: TDropFilesEvent);
begin T := Self.OnDropFiles; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnContextHelp_W(Self: TCustomSynEdit; const T: TContextHelpEvent);
begin Self.OnContextHelp := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnContextHelp_R(Self: TCustomSynEdit; var T: TContextHelpEvent);
begin T := Self.OnContextHelp; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnCommandProcessed_W(Self: TCustomSynEdit; const T: TProcessCommandEvent);
begin Self.OnCommandProcessed := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnCommandProcessed_R(Self: TCustomSynEdit; var T: TProcessCommandEvent);
begin T := Self.OnCommandProcessed; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnClearBookmark_W(Self: TCustomSynEdit; const T: TPlaceMarkEvent);
begin Self.OnClearBookmark := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnClearBookmark_R(Self: TCustomSynEdit; var T: TPlaceMarkEvent);
begin T := Self.OnClearBookmark; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnChange_W(Self: TCustomSynEdit; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnChange_R(Self: TCustomSynEdit; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditWordWrapGlyph_W(Self: TCustomSynEdit; const T: TSynGlyph);
begin Self.WordWrapGlyph := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditWordWrapGlyph_R(Self: TCustomSynEdit; var T: TSynGlyph);
begin T := Self.WordWrapGlyph; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditWordWrap_W(Self: TCustomSynEdit; const T: boolean);
begin Self.WordWrap := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditWordWrap_R(Self: TCustomSynEdit; var T: boolean);
begin T := Self.WordWrap; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditWantTabs_W(Self: TCustomSynEdit; const T: boolean);
begin Self.WantTabs := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditWantTabs_R(Self: TCustomSynEdit; var T: boolean);
begin T := Self.WantTabs; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditWantReturns_W(Self: TCustomSynEdit; const T: boolean);
begin Self.WantReturns := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditWantReturns_R(Self: TCustomSynEdit; var T: boolean);
begin T := Self.WantReturns; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditTabWidth_W(Self: TCustomSynEdit; const T: integer);
begin Self.TabWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditTabWidth_R(Self: TCustomSynEdit; var T: integer);
begin T := Self.TabWidth; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditActiveSelectionMode_W(Self: TCustomSynEdit; const T: TSynSelectionMode);
begin Self.ActiveSelectionMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditActiveSelectionMode_R(Self: TCustomSynEdit; var T: TSynSelectionMode);
begin T := Self.ActiveSelectionMode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelectionMode_W(Self: TCustomSynEdit; const T: TSynSelectionMode);
begin Self.SelectionMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelectionMode_R(Self: TCustomSynEdit; var T: TSynSelectionMode);
begin T := Self.SelectionMode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelectedColor_W(Self: TCustomSynEdit; const T: TSynSelectedColor);
begin Self.SelectedColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelectedColor_R(Self: TCustomSynEdit; var T: TSynSelectedColor);
begin T := Self.SelectedColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditScrollBars_W(Self: TCustomSynEdit; const T: TScrollStyle);
begin Self.ScrollBars := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditScrollBars_R(Self: TCustomSynEdit; var T: TScrollStyle);
begin T := Self.ScrollBars; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditScrollHintFormat_W(Self: TCustomSynEdit; const T: TScrollHintFormat);
begin Self.ScrollHintFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditScrollHintFormat_R(Self: TCustomSynEdit; var T: TScrollHintFormat);
begin T := Self.ScrollHintFormat; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditScrollHintColor_W(Self: TCustomSynEdit; const T: TColor);
begin Self.ScrollHintColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditScrollHintColor_R(Self: TCustomSynEdit; var T: TColor);
begin T := Self.ScrollHintColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditRightEdgeColor_W(Self: TCustomSynEdit; const T: TColor);
begin Self.RightEdgeColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditRightEdgeColor_R(Self: TCustomSynEdit; var T: TColor);
begin T := Self.RightEdgeColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditRightEdge_W(Self: TCustomSynEdit; const T: Integer);
begin Self.RightEdge := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditRightEdge_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.RightEdge; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOverwriteCaret_W(Self: TCustomSynEdit; const T: TSynEditCaretType);
begin Self.OverwriteCaret := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOverwriteCaret_R(Self: TCustomSynEdit; var T: TSynEditCaretType);
begin T := Self.OverwriteCaret; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOptions_W(Self: TCustomSynEdit; const T: TSynEditorOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOptions_R(Self: TCustomSynEdit; var T: TSynEditorOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditMaxUndo_W(Self: TCustomSynEdit; const T: Integer);
begin Self.MaxUndo := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditMaxUndo_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.MaxUndo; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditKeystrokes_W(Self: TCustomSynEdit; const T: TSynEditKeyStrokes);
begin Self.Keystrokes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditKeystrokes_R(Self: TCustomSynEdit; var T: TSynEditKeyStrokes);
begin T := Self.Keystrokes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditIsScrolling_R(Self: TCustomSynEdit; var T: Boolean);
begin T := Self.IsScrolling; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditInsertMode_W(Self: TCustomSynEdit; const T: boolean);
begin Self.InsertMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditInsertMode_R(Self: TCustomSynEdit; var T: boolean);
begin T := Self.InsertMode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditInsertCaret_W(Self: TCustomSynEdit; const T: TSynEditCaretType);
begin Self.InsertCaret := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditInsertCaret_R(Self: TCustomSynEdit; var T: TSynEditCaretType);
begin T := Self.InsertCaret; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditHideSelection_W(Self: TCustomSynEdit; const T: boolean);
begin Self.HideSelection := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditHideSelection_R(Self: TCustomSynEdit; var T: boolean);
begin T := Self.HideSelection; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditGutter_W(Self: TCustomSynEdit; const T: TSynGutter);
begin Self.Gutter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditGutter_R(Self: TCustomSynEdit; var T: TSynGutter);
begin T := Self.Gutter; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditExtraLineSpacing_W(Self: TCustomSynEdit; const T: integer);
begin Self.ExtraLineSpacing := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditExtraLineSpacing_R(Self: TCustomSynEdit; var T: integer);
begin T := Self.ExtraLineSpacing; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditBorderStyle_W(Self: TCustomSynEdit; const T: TSynBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditBorderStyle_R(Self: TCustomSynEdit; var T: TSynBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditBookMarkOptions_W(Self: TCustomSynEdit; const T: TSynBookMarkOpt);
begin Self.BookMarkOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditBookMarkOptions_R(Self: TCustomSynEdit; var T: TSynBookMarkOpt);
begin T := Self.BookMarkOptions; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnProcessCommand_W(Self: TCustomSynEdit; const T: TProcessCommandEvent);
begin Self.OnProcessCommand := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditOnProcessCommand_R(Self: TCustomSynEdit; var T: TProcessCommandEvent);
begin T := Self.OnProcessCommand; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditRedoList_R(Self: TCustomSynEdit; var T: TSynEditUndoList);
begin T := Self.RedoList; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditUndoList_R(Self: TCustomSynEdit; var T: TSynEditUndoList);
begin T := Self.UndoList; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditWordAtMouse_R(Self: TCustomSynEdit; var T: string);
begin T := Self.WordAtMouse; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditWordAtCursor_R(Self: TCustomSynEdit; var T: string);
begin T := Self.WordAtCursor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditTopLine_W(Self: TCustomSynEdit; const T: Integer);
begin Self.TopLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditTopLine_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.TopLine; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditText_W(Self: TCustomSynEdit; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditText_R(Self: TCustomSynEdit; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditStateFlags_R(Self: TCustomSynEdit; var T: TSynStateFlags);
begin T := Self.StateFlags; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelText_W(Self: TCustomSynEdit; const T: string);
begin Self.SelText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelText_R(Self: TCustomSynEdit; var T: string);
begin T := Self.SelText; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelTabLine_R(Self: TCustomSynEdit; var T: Boolean);
begin T := Self.SelTabLine; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelTabBlock_R(Self: TCustomSynEdit; var T: Boolean);
begin T := Self.SelTabBlock; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelLength_W(Self: TCustomSynEdit; const T: integer);
begin Self.SelLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelLength_R(Self: TCustomSynEdit; var T: integer);
begin T := Self.SelLength; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelAvail_R(Self: TCustomSynEdit; var T: Boolean);
begin T := Self.SelAvail; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSearchEngine_W(Self: TCustomSynEdit; const T: TSynEditSearchCustom);
begin Self.SearchEngine := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSearchEngine_R(Self: TCustomSynEdit; var T: TSynEditSearchCustom);
begin T := Self.SearchEngine; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditReadOnly_W(Self: TCustomSynEdit; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditReadOnly_R(Self: TCustomSynEdit; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditPaintLock_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.PaintLock; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditModified_W(Self: TCustomSynEdit; const T: Boolean);
begin Self.Modified := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditModified_R(Self: TCustomSynEdit; var T: Boolean);
begin T := Self.Modified; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditMaxScrollWidth_W(Self: TCustomSynEdit; const T: integer);
begin Self.MaxScrollWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditMaxScrollWidth_R(Self: TCustomSynEdit; var T: integer);
begin T := Self.MaxScrollWidth; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditMarks_R(Self: TCustomSynEdit; var T: TSynEditMarkList);
begin T := Self.Marks; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditLines_W(Self: TCustomSynEdit; const T: TStrings);
begin Self.Lines := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditLines_R(Self: TCustomSynEdit; var T: TStrings);
begin T := Self.Lines; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditLineText_W(Self: TCustomSynEdit; const T: string);
begin Self.LineText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditLineText_R(Self: TCustomSynEdit; var T: string);
begin T := Self.LineText; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditLinesInWindow_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.LinesInWindow; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditLineHeight_R(Self: TCustomSynEdit; var T: integer);
begin T := Self.LineHeight; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditLeftChar_W(Self: TCustomSynEdit; const T: Integer);
begin Self.LeftChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditLeftChar_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.LeftChar; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditHighlighter_W(Self: TCustomSynEdit; const T: TSynCustomHighlighter);
begin Self.Highlighter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditHighlighter_R(Self: TCustomSynEdit; var T: TSynCustomHighlighter);
begin T := Self.Highlighter; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditGutterWidth_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.GutterWidth; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditFont_W(Self: TCustomSynEdit; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditFont_R(Self: TCustomSynEdit; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditCharWidth_R(Self: TCustomSynEdit; var T: integer);
begin T := Self.CharWidth; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditCharsInWindow_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.CharsInWindow; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditDisplayLineCount_R(Self: TCustomSynEdit; var T: integer);
begin T := Self.DisplayLineCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditDisplayXY_R(Self: TCustomSynEdit; var T: TDisplayCoord);
begin T := Self.DisplayXY; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditDisplayY_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.DisplayY; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditDisplayX_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.DisplayX; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditActiveLineColor_W(Self: TCustomSynEdit; const T: TColor);
begin Self.ActiveLineColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditActiveLineColor_R(Self: TCustomSynEdit; var T: TColor);
begin T := Self.ActiveLineColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditCaretXY_W(Self: TCustomSynEdit; const T: TBufferCoord);
begin Self.CaretXY := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditCaretXY_R(Self: TCustomSynEdit; var T: TBufferCoord);
begin T := Self.CaretXY; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditCaretY_W(Self: TCustomSynEdit; const T: Integer);
begin Self.CaretY := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditCaretY_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.CaretY; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditCaretX_W(Self: TCustomSynEdit; const T: Integer);
begin Self.CaretX := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditCaretX_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.CaretX; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditCanUndo_R(Self: TCustomSynEdit; var T: boolean);
begin T := Self.CanUndo; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditCanRedo_R(Self: TCustomSynEdit; var T: boolean);
begin T := Self.CanRedo; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditCanPaste_R(Self: TCustomSynEdit; var T: Boolean);
begin T := Self.CanPaste; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditBlockEnd_W(Self: TCustomSynEdit; const T: TBufferCoord);
begin Self.BlockEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditBlockEnd_R(Self: TCustomSynEdit; var T: TBufferCoord);
begin T := Self.BlockEnd; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditBlockBegin_W(Self: TCustomSynEdit; const T: TBufferCoord);
begin Self.BlockBegin := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditBlockBegin_R(Self: TCustomSynEdit; var T: TBufferCoord);
begin T := Self.BlockBegin; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditAlwaysShowCaret_W(Self: TCustomSynEdit; const T: Boolean);
begin Self.AlwaysShowCaret := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditAlwaysShowCaret_R(Self: TCustomSynEdit; var T: Boolean);
begin T := Self.AlwaysShowCaret; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelEnd_W(Self: TCustomSynEdit; const T: Integer);
begin Self.SelEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelEnd_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.SelEnd; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelStart_W(Self: TCustomSynEdit; const T: Integer);
begin Self.SelStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynEditSelStart_R(Self: TCustomSynEdit; var T: Integer);
begin T := Self.SelStart; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEdit) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomSynEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomSynEdit) do begin
    RegisterConstructor(@TCustomSynEdit.Create, 'Create');
    RegisterMethod(@TCustomSynEdit.Destroy, 'Free');
    RegisterPropertyHelper(@TCustomSynEditSelStart_R,@TCustomSynEditSelStart_W,'SelStart');
    RegisterPropertyHelper(@TCustomSynEditSelEnd_R,@TCustomSynEditSelEnd_W,'SelEnd');
    RegisterPropertyHelper(@TCustomSynEditAlwaysShowCaret_R,@TCustomSynEditAlwaysShowCaret_W,'AlwaysShowCaret');
    RegisterMethod(@TCustomSynEdit.UpdateCaret, 'UpdateCaret');
    RegisterMethod(@TCustomSynEdit.AddKey, 'AddKey');
    RegisterMethod(@TCustomSynEdit.AddKey, 'AddKey');
    RegisterMethod(@TCustomSynEdit.BeginUndoBlock, 'BeginUndoBlock');
    RegisterMethod(@TCustomSynEdit.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TCustomSynEdit.CaretInView, 'CaretInView');
    RegisterMethod(@TCustomSynEdit.CharIndexToRowCol, 'CharIndexToRowCol');
    RegisterMethod(@TCustomSynEdit.Clear, 'Clear');
    RegisterMethod(@TCustomSynEdit.ClearAll, 'ClearAll');
    RegisterMethod(@TCustomSynEdit.ClearBookMark, 'ClearBookMark');
    RegisterMethod(@TCustomSynEdit.ClearSelection, 'ClearSelection');
    RegisterVirtualMethod(@TCustomSynEdit.CommandProcessor, 'CommandProcessor');
    RegisterVirtualMethod(@TCustomSynEdit.CommandProcessor2, 'CommandProcessor2');
    RegisterMethod(@TCustomSynEdit.ClearUndo, 'ClearUndo');
    RegisterMethod(@TCustomSynEdit.CopyToClipboard, 'CopyToClipboard');
    RegisterMethod(@TCustomSynEdit.CutToClipboard, 'CutToClipboard');
    RegisterMethod(@TCustomSynEdit.DoCopyToClipboard, 'DoCopyToClipboard');
    RegisterMethod(@TCustomSynEdit.EndUndoBlock, 'EndUndoBlock');
    RegisterMethod(@TCustomSynEdit.EndUpdate, 'EndUpdate');
    RegisterMethod(@TCustomSynEdit.EnsureCursorPosVisible, 'EnsureCursorPosVisible');
    RegisterMethod(@TCustomSynEdit.EnsureCursorPosVisibleEx, 'EnsureCursorPosVisibleEx');
    RegisterVirtualMethod(@TCustomSynEdit.FindMatchingBracket, 'FindMatchingBracket');
    RegisterVirtualMethod(@TCustomSynEdit.GetMatchingBracket, 'GetMatchingBracket');
    RegisterVirtualMethod(@TCustomSynEdit.GetMatchingBracketEx, 'GetMatchingBracketEx');
    RegisterVirtualMethod(@TCustomSynEdit.ExecuteCommand, 'ExecuteCommand');
    RegisterVirtualMethod(@TCustomSynEdit.ExecuteCommand2, 'ExecuteCommand2');
    RegisterMethod(@TCustomSynEdit.GetBookMark, 'GetBookMark');
    RegisterMethod(@TCustomSynEdit.GetHighlighterAttriAtRowCol, 'GetHighlighterAttriAtRowCol');
    RegisterMethod(@TCustomSynEdit.GetHighlighterAttriAtRowColEx, 'GetHighlighterAttriAtRowColEx');
    RegisterMethod(@TCustomSynEdit.GetPositionOfMouse, 'GetPositionOfMouse');
    RegisterMethod(@TCustomSynEdit.GetWordAtRowCol, 'GetWordAtRowCol');
    RegisterMethod(@TCustomSynEdit.GotoBookMark, 'GotoBookMark');
    RegisterMethod(@TCustomSynEdit.GotoLineAndCenter, 'GotoLineAndCenter');
    RegisterMethod(@TCustomSynEdit.IdentChars, 'IdentChars');
    RegisterMethod(@TCustomSynEdit.InvalidateGutter, 'InvalidateGutter');
    RegisterMethod(@TCustomSynEdit.InvalidateGutterLine, 'InvalidateGutterLine');
    RegisterMethod(@TCustomSynEdit.InvalidateGutterLines, 'InvalidateGutterLines');
    RegisterMethod(@TCustomSynEdit.InvalidateLine, 'InvalidateLine');
    RegisterMethod(@TCustomSynEdit.InvalidateLines, 'InvalidateLines');
    RegisterMethod(@TCustomSynEdit.InvalidateSelection, 'InvalidateSelection');
    RegisterMethod(@TCustomSynEdit.IsBookmark, 'IsBookmark');
    RegisterMethod(@TCustomSynEdit.IsPointInSelection, 'IsPointInSelection');
    RegisterMethod(@TCustomSynEdit.LockUndo, 'LockUndo');
    RegisterMethod(@TCustomSynEdit.BufferToDisplayPos, 'BufferToDisplayPos');
    RegisterMethod(@TCustomSynEdit.DisplayToBufferPos, 'DisplayToBufferPos');
    RegisterMethod(@TCustomSynEdit.LineToRow, 'LineToRow');
    RegisterMethod(@TCustomSynEdit.RowToLine, 'RowToLine');
    RegisterVirtualMethod(@TCustomSynEdit.NextWordPos, 'NextWordPos');
    RegisterVirtualMethod(@TCustomSynEdit.NextWordPosEx, 'NextWordPosEx');
    RegisterMethod(@TCustomSynEdit.PasteFromClipboard, 'PasteFromClipboard');
    RegisterVirtualMethod(@TCustomSynEdit.WordStart, 'WordStart');
    RegisterVirtualMethod(@TCustomSynEdit.WordStartEx, 'WordStartEx');
    RegisterVirtualMethod(@TCustomSynEdit.WordEnd, 'WordEnd');
    RegisterVirtualMethod(@TCustomSynEdit.WordEndEx, 'WordEndEx');
    RegisterVirtualMethod(@TCustomSynEdit.PrevWordPos, 'PrevWordPos');
    RegisterVirtualMethod(@TCustomSynEdit.PrevWordPosEx, 'PrevWordPosEx');
    RegisterMethod(@TCustomSynEdit.PixelsToRowColumn, 'PixelsToRowColumn');
    RegisterMethod(@TCustomSynEdit.PixelsToNearestRowColumn, 'PixelsToNearestRowColumn');
    RegisterMethod(@TCustomSynEdit.Redo, 'Redo');
    RegisterMethod(@TCustomSynEdit.RegisterCommandHandler, 'RegisterCommandHandler');
    RegisterMethod(@TCustomSynEdit.RowColumnToPixels, 'RowColumnToPixels');
    RegisterMethod(@TCustomSynEdit.RowColToCharIndex, 'RowColToCharIndex');
    RegisterMethod(@TCustomSynEdit.SearchReplace, 'SearchReplace');
    RegisterMethod(@TCustomSynEdit.SelectAll, 'SelectAll');
    RegisterMethod(@TCustomSynEdit.SetBookMark, 'SetBookMark');
    RegisterMethod(@TCustomSynEdit.SetCaretAndSelection, 'SetCaretAndSelection');
    RegisterVirtualMethod(@TCustomSynEdit.SetDefaultKeystrokes, 'SetDefaultKeystrokes');
    RegisterMethod(@TCustomSynEdit.SetSelWord, 'SetSelWord');
    RegisterMethod(@TCustomSynEdit.SetWordBlock, 'SetWordBlock');
    RegisterMethod(@TCustomSynEdit.Undo, 'Undo');
    RegisterMethod(@TCustomSynEdit.UnlockUndo, 'UnlockUndo');
    RegisterMethod(@TCustomSynEdit.UnregisterCommandHandler, 'UnregisterCommandHandler');
    RegisterMethod(@TCustomSynEdit.AddKeyUpHandler, 'AddKeyUpHandler');
    RegisterMethod(@TCustomSynEdit.RemoveKeyUpHandler, 'RemoveKeyUpHandler');
    RegisterMethod(@TCustomSynEdit.AddKeyDownHandler, 'AddKeyDownHandler');
    RegisterMethod(@TCustomSynEdit.RemoveKeyDownHandler, 'RemoveKeyDownHandler');
    RegisterMethod(@TCustomSynEdit.AddKeyPressHandler, 'AddKeyPressHandler');
    RegisterMethod(@TCustomSynEdit.RemoveKeyPressHandler, 'RemoveKeyPressHandler');
    RegisterMethod(@TCustomSynEdit.AddFocusControl, 'AddFocusControl');
    RegisterMethod(@TCustomSynEdit.RemoveFocusControl, 'RemoveFocusControl');
    RegisterMethod(@TCustomSynEdit.AddMouseDownHandler, 'AddMouseDownHandler');
    RegisterMethod(@TCustomSynEdit.RemoveMouseDownHandler, 'RemoveMouseDownHandler');
    RegisterMethod(@TCustomSynEdit.AddMouseUpHandler, 'AddMouseUpHandler');
    RegisterMethod(@TCustomSynEdit.RemoveMouseUpHandler, 'RemoveMouseUpHandler');
    RegisterMethod(@TCustomSynEdit.AddMouseCursorHandler, 'AddMouseCursorHandler');
    RegisterMethod(@TCustomSynEdit.RemoveMouseCursorHandler, 'RemoveMouseCursorHandler');
    RegisterMethod(@TCustomSynEdit.SetLinesPointer, 'SetLinesPointer');
    RegisterMethod(@TCustomSynEdit.RemoveLinesPointer, 'RemoveLinesPointer');
    RegisterMethod(@TCustomSynEdit.HookTextBuffer, 'HookTextBuffer');
    RegisterMethod(@TCustomSynEdit.UnHookTextBuffer, 'UnHookTextBuffer');
    RegisterPropertyHelper(@TCustomSynEditBlockBegin_R,@TCustomSynEditBlockBegin_W,'BlockBegin');
    RegisterPropertyHelper(@TCustomSynEditBlockEnd_R,@TCustomSynEditBlockEnd_W,'BlockEnd');
    RegisterPropertyHelper(@TCustomSynEditCanPaste_R,nil,'CanPaste');
    RegisterPropertyHelper(@TCustomSynEditCanRedo_R,nil,'CanRedo');
    RegisterPropertyHelper(@TCustomSynEditCanUndo_R,nil,'CanUndo');
    RegisterPropertyHelper(@TCustomSynEditCaretX_R,@TCustomSynEditCaretX_W,'CaretX');
    RegisterPropertyHelper(@TCustomSynEditCaretY_R,@TCustomSynEditCaretY_W,'CaretY');
    RegisterPropertyHelper(@TCustomSynEditCaretXY_R,@TCustomSynEditCaretXY_W,'CaretXY');
    RegisterPropertyHelper(@TCustomSynEditActiveLineColor_R,@TCustomSynEditActiveLineColor_W,'ActiveLineColor');
    RegisterPropertyHelper(@TCustomSynEditDisplayX_R,nil,'DisplayX');
    RegisterPropertyHelper(@TCustomSynEditDisplayY_R,nil,'DisplayY');
    RegisterPropertyHelper(@TCustomSynEditDisplayXY_R,nil,'DisplayXY');
    RegisterPropertyHelper(@TCustomSynEditDisplayLineCount_R,nil,'DisplayLineCount');
    RegisterPropertyHelper(@TCustomSynEditCharsInWindow_R,nil,'CharsInWindow');
    RegisterPropertyHelper(@TCustomSynEditCharWidth_R,nil,'CharWidth');
    RegisterPropertyHelper(@TCustomSynEditFont_R,@TCustomSynEditFont_W,'Font');
    RegisterPropertyHelper(@TCustomSynEditGutterWidth_R,nil,'GutterWidth');
    RegisterPropertyHelper(@TCustomSynEditHighlighter_R,@TCustomSynEditHighlighter_W,'Highlighter');
    RegisterPropertyHelper(@TCustomSynEditLeftChar_R,@TCustomSynEditLeftChar_W,'LeftChar');
    RegisterPropertyHelper(@TCustomSynEditLineHeight_R,nil,'LineHeight');
    RegisterPropertyHelper(@TCustomSynEditLinesInWindow_R,nil,'LinesInWindow');
    RegisterPropertyHelper(@TCustomSynEditLineText_R,@TCustomSynEditLineText_W,'LineText');
    RegisterPropertyHelper(@TCustomSynEditLines_R,@TCustomSynEditLines_W,'Lines');
    RegisterPropertyHelper(@TCustomSynEditMarks_R,nil,'Marks');
    RegisterPropertyHelper(@TCustomSynEditMaxScrollWidth_R,@TCustomSynEditMaxScrollWidth_W,'MaxScrollWidth');
    RegisterPropertyHelper(@TCustomSynEditModified_R,@TCustomSynEditModified_W,'Modified');
    RegisterPropertyHelper(@TCustomSynEditPaintLock_R,nil,'PaintLock');
    RegisterPropertyHelper(@TCustomSynEditReadOnly_R,@TCustomSynEditReadOnly_W,'ReadOnly');
    RegisterPropertyHelper(@TCustomSynEditSearchEngine_R,@TCustomSynEditSearchEngine_W,'SearchEngine');
    RegisterPropertyHelper(@TCustomSynEditSelAvail_R,nil,'SelAvail');
    RegisterPropertyHelper(@TCustomSynEditSelLength_R,@TCustomSynEditSelLength_W,'SelLength');
    RegisterPropertyHelper(@TCustomSynEditSelTabBlock_R,nil,'SelTabBlock');
    RegisterPropertyHelper(@TCustomSynEditSelTabLine_R,nil,'SelTabLine');
    RegisterPropertyHelper(@TCustomSynEditSelText_R,@TCustomSynEditSelText_W,'SelText');
    RegisterPropertyHelper(@TCustomSynEditStateFlags_R,nil,'StateFlags');
    RegisterPropertyHelper(@TCustomSynEditText_R,@TCustomSynEditText_W,'Text');
    RegisterPropertyHelper(@TCustomSynEditTopLine_R,@TCustomSynEditTopLine_W,'TopLine');
    RegisterPropertyHelper(@TCustomSynEditWordAtCursor_R,nil,'WordAtCursor');
    RegisterPropertyHelper(@TCustomSynEditWordAtMouse_R,nil,'WordAtMouse');
    RegisterPropertyHelper(@TCustomSynEditUndoList_R,nil,'UndoList');
    RegisterPropertyHelper(@TCustomSynEditRedoList_R,nil,'RedoList');
    RegisterPropertyHelper(@TCustomSynEditOnProcessCommand_R,@TCustomSynEditOnProcessCommand_W,'OnProcessCommand');
    RegisterPropertyHelper(@TCustomSynEditBookMarkOptions_R,@TCustomSynEditBookMarkOptions_W,'BookMarkOptions');
    RegisterPropertyHelper(@TCustomSynEditBorderStyle_R,@TCustomSynEditBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TCustomSynEditExtraLineSpacing_R,@TCustomSynEditExtraLineSpacing_W,'ExtraLineSpacing');
    RegisterPropertyHelper(@TCustomSynEditGutter_R,@TCustomSynEditGutter_W,'Gutter');
    RegisterPropertyHelper(@TCustomSynEditHideSelection_R,@TCustomSynEditHideSelection_W,'HideSelection');
    RegisterPropertyHelper(@TCustomSynEditInsertCaret_R,@TCustomSynEditInsertCaret_W,'InsertCaret');
    RegisterPropertyHelper(@TCustomSynEditInsertMode_R,@TCustomSynEditInsertMode_W,'InsertMode');
    RegisterPropertyHelper(@TCustomSynEditIsScrolling_R,nil,'IsScrolling');
    RegisterPropertyHelper(@TCustomSynEditKeystrokes_R,@TCustomSynEditKeystrokes_W,'Keystrokes');
    RegisterPropertyHelper(@TCustomSynEditMaxUndo_R,@TCustomSynEditMaxUndo_W,'MaxUndo');
    RegisterPropertyHelper(@TCustomSynEditOptions_R,@TCustomSynEditOptions_W,'Options');
    RegisterPropertyHelper(@TCustomSynEditOverwriteCaret_R,@TCustomSynEditOverwriteCaret_W,'OverwriteCaret');
    RegisterPropertyHelper(@TCustomSynEditRightEdge_R,@TCustomSynEditRightEdge_W,'RightEdge');
    RegisterPropertyHelper(@TCustomSynEditRightEdgeColor_R,@TCustomSynEditRightEdgeColor_W,'RightEdgeColor');
    RegisterPropertyHelper(@TCustomSynEditScrollHintColor_R,@TCustomSynEditScrollHintColor_W,'ScrollHintColor');
    RegisterPropertyHelper(@TCustomSynEditScrollHintFormat_R,@TCustomSynEditScrollHintFormat_W,'ScrollHintFormat');
    RegisterPropertyHelper(@TCustomSynEditScrollBars_R,@TCustomSynEditScrollBars_W,'ScrollBars');
    RegisterPropertyHelper(@TCustomSynEditSelectedColor_R,@TCustomSynEditSelectedColor_W,'SelectedColor');
    RegisterPropertyHelper(@TCustomSynEditSelectionMode_R,@TCustomSynEditSelectionMode_W,'SelectionMode');
    RegisterPropertyHelper(@TCustomSynEditActiveSelectionMode_R,@TCustomSynEditActiveSelectionMode_W,'ActiveSelectionMode');
    RegisterPropertyHelper(@TCustomSynEditTabWidth_R,@TCustomSynEditTabWidth_W,'TabWidth');
    RegisterPropertyHelper(@TCustomSynEditWantReturns_R,@TCustomSynEditWantReturns_W,'WantReturns');
    RegisterPropertyHelper(@TCustomSynEditWantTabs_R,@TCustomSynEditWantTabs_W,'WantTabs');
    RegisterPropertyHelper(@TCustomSynEditWordWrap_R,@TCustomSynEditWordWrap_W,'WordWrap');
    RegisterPropertyHelper(@TCustomSynEditWordWrapGlyph_R,@TCustomSynEditWordWrapGlyph_W,'WordWrapGlyph');
    RegisterPropertyHelper(@TCustomSynEditOnChange_R,@TCustomSynEditOnChange_W,'OnChange');
    RegisterPropertyHelper(@TCustomSynEditOnClearBookmark_R,@TCustomSynEditOnClearBookmark_W,'OnClearBookmark');
    RegisterPropertyHelper(@TCustomSynEditOnCommandProcessed_R,@TCustomSynEditOnCommandProcessed_W,'OnCommandProcessed');
    RegisterPropertyHelper(@TCustomSynEditOnContextHelp_R,@TCustomSynEditOnContextHelp_W,'OnContextHelp');
    RegisterPropertyHelper(@TCustomSynEditOnDropFiles_R,@TCustomSynEditOnDropFiles_W,'OnDropFiles');
    RegisterPropertyHelper(@TCustomSynEditOnGutterClick_R,@TCustomSynEditOnGutterClick_W,'OnGutterClick');
    RegisterPropertyHelper(@TCustomSynEditOnGutterGetText_R,@TCustomSynEditOnGutterGetText_W,'OnGutterGetText');
    RegisterPropertyHelper(@TCustomSynEditOnGutterPaint_R,@TCustomSynEditOnGutterPaint_W,'OnGutterPaint');
    RegisterPropertyHelper(@TCustomSynEditOnMouseCursor_R,@TCustomSynEditOnMouseCursor_W,'OnMouseCursor');
    RegisterPropertyHelper(@TCustomSynEditOnPaint_R,@TCustomSynEditOnPaint_W,'OnPaint');
    RegisterPropertyHelper(@TCustomSynEditOnPlaceBookmark_R,@TCustomSynEditOnPlaceBookmark_W,'OnPlaceBookmark');
    RegisterPropertyHelper(@TCustomSynEditOnProcessUserCommand_R,@TCustomSynEditOnProcessUserCommand_W,'OnProcessUserCommand');
    RegisterPropertyHelper(@TCustomSynEditOnReplaceText_R,@TCustomSynEditOnReplaceText_W,'OnReplaceText');
    RegisterPropertyHelper(@TCustomSynEditOnSpecialLineColors_R,@TCustomSynEditOnSpecialLineColors_W,'OnSpecialLineColors');
    RegisterPropertyHelper(@TCustomSynEditOnStatusChange_R,@TCustomSynEditOnStatusChange_W,'OnStatusChange');
    RegisterPropertyHelper(@TCustomSynEditOnPaintTransient_R,@TCustomSynEditOnPaintTransient_W,'OnPaintTransient');
    RegisterPropertyHelper(@TCustomSynEditOnScroll_R,@TCustomSynEditOnScroll_W,'OnScroll');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditPlugin(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditPlugin) do
  begin
    RegisterConstructor(@TSynEditPlugin.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ESynEditError) do
  with CL.Add(TCustomSynEdit) do
  RIRegister_TSynEditPlugin(CL);
  RIRegister_TCustomSynEdit(CL);
  RIRegister_TSynEdit(CL);
end;

 
 
{ TPSImport_SynEdit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEdit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEdit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEdit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynEdit(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
