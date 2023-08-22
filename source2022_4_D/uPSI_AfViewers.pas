unit uPSI_AfViewers;
{
   a view to a fill   with helper
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
  TPSImport_AfViewers = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TAfFileViewer(CL: TPSPascalCompiler);
procedure SIRegister_TAfCustomFileViewer(CL: TPSPascalCompiler);
procedure SIRegister_TAfTerminal(CL: TPSPascalCompiler);
procedure SIRegister_TAfCustomTerminal(CL: TPSPascalCompiler);
procedure SIRegister_TAfTerminalBuffer(CL: TPSPascalCompiler);
procedure SIRegister_TAfFileStream(CL: TPSPascalCompiler);
procedure SIRegister_TAfLineViewer(CL: TPSPascalCompiler);
procedure SIRegister_TAfCustomLineViewer(CL: TPSPascalCompiler);
procedure SIRegister_TAfFontStyleCache(CL: TPSPascalCompiler);
procedure SIRegister_AfViewers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AfViewers_Routines(S: TPSExec);
procedure RIRegister_TAfFileViewer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfCustomFileViewer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfTerminal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfCustomTerminal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfTerminalBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfFileStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfLineViewer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfCustomLineViewer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfFontStyleCache(CL: TPSRuntimeClassImporter);
procedure RIRegister_AfViewers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,Menus
  ,StdCtrls
  ,Clipbrd
  ,AfViewers
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AfViewers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfFileViewer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomFileViewer', 'TAfFileViewer') do
  with CL.AddClassN(CL.FindClass('TAfCustomFileViewer'),'TAfFileViewer') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfCustomFileViewer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomLineViewer', 'TAfCustomFileViewer') do
  with CL.AddClassN(CL.FindClass('TAfCustomLineViewer'),'TAfCustomFileViewer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure CloseFile');
    RegisterMethod('Function FilePtrFromLine( Line : Integer) : PChar');
    RegisterMethod('Procedure OpenFile');
    RegisterMethod('Procedure OpenData( const TextBuf : PChar; const TextSize : Integer)');
    RegisterProperty('FileSize', 'DWORD', iptr);
    RegisterProperty('ScanPosition', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfTerminal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomTerminal', 'TAfTerminal') do
  with CL.AddClassN(CL.FindClass('TAfCustomTerminal'),'TAfTerminal') do begin
   REgisterPublishedProperties;
   RegisterProperty('caption', 'string', iptrW);
  RegisterProperty('LogName', 'string', iptrw);
  RegisterProperty('OnSendChar', 'TKeyPressEvent', iptrw);
  RegisterProperty('CaretBlinkTime', 'TAfCLVCaretBlinkTime', iptrw);
  RegisterProperty('LogFileStream', 'TAfFileStream', iptrw);
  RegisterProperty('LogMemStream', 'TMemoryStream', iptrw);
  RegisterProperty('OnBeepChar', 'TNotifyEvent', iptrw);
  RegisterProperty('OnDrawBuffer', 'TNotifyEvent', iptrw);
  RegisterProperty('OnFlushLog', 'TNotifyEvent', iptrw);
  RegisterProperty('OnUserDataChange', 'TAfTRMLineEvent', iptrw);
   RegisterProperty('Options', 'TAfCLVOptions', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('Canvas', 'TCanvas', iptrw);
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
      RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
     RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfCustomTerminal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomLineViewer', 'TAfCustomTerminal') do
  with CL.AddClassN(CL.FindClass('TAfCustomLineViewer'),'TAfCustomTerminal') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure ClearBuffer');
    RegisterMethod('Function DefaultTermColor : TAfTRMCharAttr');
    RegisterMethod('Procedure DrawChangedBuffer');
    RegisterMethod('Procedure WriteChar( C : Char)');
    RegisterMethod('Procedure WriteColorChar( C : Char; BColor, FColor : TAfTRMCharColor)');
    RegisterMethod('Procedure WriteColorStringAndData( const S : String; BColor, FColor : TAfTRMCharColor; UserDataItem : Pointer)');
    RegisterMethod('Procedure WriteString( const S : String)');
    RegisterMethod('Procedure CloseLogFile');
    RegisterMethod('Procedure DoBeepChar');
    RegisterMethod('Procedure DoDrawBuffer');
    RegisterMethod('Procedure DoLoggingChange');
    RegisterMethod('Procedure DoScrBckBufChange');
    RegisterMethod('Procedure FlushLogBuffer');
    RegisterMethod('Procedure FocusEndOfBuffer( ScrollToCursor : Boolean)');
    RegisterMethod('Procedure GetColorsForThisLine');
    RegisterMethod('Procedure OpenLogFile');
    RegisterMethod('Procedure WriteToLog( const S : String)');
     RegisterPublishedProperties;
     RegisterProperty('caption', 'string', iptrW);
  RegisterProperty('LogName', 'string', iptrw);
  RegisterProperty('OnSendChar', 'TKeyPressEvent', iptrw);
  RegisterProperty('CaretBlinkTime', 'TAfCLVCaretBlinkTime', iptrw);
  RegisterProperty('CaretType', 'TAfCLVCaretType', iptrw);
    RegisterProperty('LogFileStream', 'TAfFileStream', iptrw);
  RegisterProperty('LogMemStream', 'TMemoryStream', iptrw);
  RegisterProperty('OnBeepChar', 'TNotifyEvent', iptrw);
  RegisterProperty('OnDrawBuffer', 'TNotifyEvent', iptrw);
  RegisterProperty('OnFlushLog', 'TNotifyEvent', iptrw);
   RegisterProperty('Options', 'TAfCLVOptions', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
     RegisterProperty('AutoScrollBack', 'Boolean', iptrw);
    RegisterProperty('BkSpcMode', 'TAfTRMBkSpcMode', iptrw);
    RegisterProperty('BufferLine', 'String Integer', iptr);
    RegisterProperty('BufferLineNumber', 'Integer', iptr);
    RegisterProperty('ColorTable', 'TAfTRMColorTable', iptrw);
   // RegisterProperty('DisplayCols', 'Byte', iptrw);
    RegisterProperty('Logging', 'TAfTRMLogging', iptrw);
    RegisterProperty('LogFlushTime', 'TAfTRMLogFlushTime', iptrw);
    RegisterProperty('LogName', 'String', iptrw);
    RegisterProperty('LogSize', 'TAfTRMLogSize', iptrw);
    RegisterProperty('DisplayCols', 'Byte', iptrw);
    RegisterProperty('Canvas', 'TCanvas', iptrw);

    //   property DisplayCols: Byte read FDisplayCols write SetDisplayCols default 80;
     // RegisterProperty('Options', 'TAfCLVOptions', iptrw);
    RegisterProperty('RelLineColors', 'TAfTRMCharAttrs Integer', iptrw);
    RegisterProperty('ScrollBackCaret', 'TAfCLVCaretType', iptrw);
    RegisterProperty('ScrollBackKey', 'TShortCut', iptrw);
    RegisterProperty('ScrollBackRows', 'Integer', iptrw);
    RegisterProperty('ScrollBackMode', 'Boolean', iptrw);
    RegisterProperty('TerminalCaret', 'TAfCLVCaretType', iptrw);
    RegisterProperty('TermColor', 'Integer TColor', iptr);
    RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('UserData', 'Pointer Integer', iptrw);
    RegisterProperty('UserDataSize', 'Integer', iptrw);
    RegisterProperty('OnBeepChar', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDrawBuffer', 'TNotifyEvent', iptrw);
    RegisterProperty('OnFlushLog', 'TNotifyEvent', iptrw);
    RegisterProperty('OnGetColors', 'TAfTRMGetColorsEvent', iptrw);
    RegisterProperty('OnLoggingChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnNewLine', 'TAfTRMLineEvent', iptrw);
    RegisterProperty('OnProcessChar', 'TAfTRMProcessCharEvent', iptrw);
    RegisterProperty('OnScrBckBufChange', 'TAfTRMScrBckBufChange', iptrw);
    RegisterProperty('OnScrBckModeChange', 'TNotifyEvent', iptrw);
   // RegisterProperty('OnSendChar', 'TKeyPressEvent', iptrw);
    RegisterProperty('OnUserDataChange', 'TAfTRMLineEvent', iptrw);
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


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfTerminalBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAfTerminalBuffer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAfTerminalBuffer') do begin
    RegisterProperty('FCharColorsArray', 'PAfTRMCharAttrs', iptrw);
    RegisterProperty('FColorTable', 'TAfTRMColorTable', iptrw);
    RegisterProperty('FTopestLineForUpdateColor', 'Integer', iptrw);
    RegisterProperty('EndBufPos', 'TPoint', iptrw);
    RegisterProperty('LastBufPos', 'TPoint', iptrw);
    RegisterProperty('MaxInvalidate', 'TPoint', iptrw);
    RegisterMethod('Constructor Create( ATerminal : TAfCustomTerminal)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure ClearBuffer');
    RegisterMethod('Procedure DrawChangedBuffer');
    RegisterMethod('Function GetBuffColorsForDraw( LineNumber : Integer) : PAfCLVCharColors');
    RegisterMethod('Function GetBuffLine( LineNumber : Integer) : String');
    RegisterMethod('Procedure GetLineColors( LineNumber : Integer; var Colors : TAfTRMCharAttrs)');
    RegisterMethod('Procedure ReallocBuffer( Rows : Integer; Cols : Byte; ColorMode : TAfTRMColorMode; UserDataSize : Integer)');
    RegisterMethod('Procedure SetLineColors( LineNumber : Integer; var Colors : TAfTRMCharAttrs)');
    RegisterMethod('Procedure WriteChar( C : Char)');
    RegisterMethod('Procedure WriteColorChar( C : Char; TermColor : TAfTRMCharAttr)');
    RegisterMethod('Procedure WriteStr( const S : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfFileStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THandleStream', 'TAfFileStream') do
  with CL.AddClassN(CL.FindClass('THandleStream'),'TAfFileStream') do begin
    RegisterMethod('Constructor Create( const FileName : string; Mode : Word)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure FlushBuffers');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfLineViewer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomLineViewer', 'TAfLineViewer') do
  with CL.AddClassN(CL.FindClass('TAfCustomLineViewer'),'TAfLineViewer') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfCustomLineViewer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TAfCustomLineViewer') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TAfCustomLineViewer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure ClearSelection');
    RegisterMethod('Procedure CopyToClipboard');
    RegisterMethod('Procedure DrawToCanvas( DrawCanvas : TCanvas; StartLine, EndLine : Integer; Rect : TRect)');
    RegisterMethod('Procedure DrawLineToCanvas( DrawCanvas : TCanvas; LineNumber : Integer; Rect : TRect; TextMetric : TTextMetric)');
    RegisterMethod('Procedure InvalidateDataRect( R : TRect; FullLine : Boolean)');
    RegisterMethod('Procedure InvalidateFocusedLine');
    RegisterMethod('Procedure InvalidateLeftSpace( StartLine, EndLine : Integer)');
    RegisterMethod('Function IsSelectionEmpty : Boolean');
    RegisterMethod('Function MouseToPoint( X, Y : Integer) : TPoint');
    RegisterMethod('Procedure ScrollIntoView');
    RegisterMethod('Procedure SelectAll');
    RegisterMethod('Procedure SelectArea( Old, New : TPoint)');
    RegisterMethod('Function TextFromRange( const ASelStart, ASelEnd : TPoint) : string');
    RegisterMethod('Procedure UnselectArea');
    RegisterProperty('CharHeight', 'Integer', iptr);
    RegisterProperty('CharWidth', 'Integer', iptr);
    RegisterProperty('FCharColors', 'PAfCLVCharColors', iptrw);
    RegisterProperty('FFontCache', 'TAfFontStyleCache', iptrw);
    RegisterProperty('FTextMetric', 'TTextMetric', iptrw);
    RegisterMethod('Function CalcCharPointPos( P : TPoint; CharsOffset : Integer) : TPoint');
    RegisterMethod('Function CreateCaret : Boolean');
    RegisterMethod('Procedure DoBof');
    RegisterMethod('Procedure DoCursorChange');
    RegisterMethod('Procedure DoEof');
    RegisterMethod('Procedure DoSelectionChange');
    RegisterMethod('Procedure DrawLeftSpace( LineNumber : Integer; Rect : TRect; State : TAfCLVLineState)');
    RegisterMethod('Procedure DrawLine( LineNumber : Integer; Rect : TRect; State : TAfCLVLineState)');
    RegisterMethod('Function FocusRequest( FocusSource : TAfCLVFocusSource) : Boolean');
    RegisterMethod('Function GetText( LineNumber : Integer; var ColorMode : TAfCLVColorMode; var CharColors : TAfCLVCharColors) : String');
    RegisterMethod('Procedure HideCaret');
    RegisterMethod('Function LineLength( LineNumber : Integer) : Integer');
    RegisterMethod('Procedure ReallocColorArray');
    RegisterMethod('Procedure ShowCaret');
    RegisterMethod('Procedure ScrollByX( ColumnsMoved : Integer)');
    RegisterMethod('Procedure ScrollByY( LinesMoved : Integer)');
    RegisterMethod('Function ScrollIntoViewX : Boolean');
    RegisterMethod('Function ScrollIntoViewY : Boolean');
    RegisterMethod('Function SetCaretPos( Position : TPoint) : Boolean');
    RegisterMethod('Procedure SetCaret');
    RegisterMethod('Procedure UpdateLineViewer');
    RegisterMethod('Procedure UpdateScrollPos');
    RegisterMethod('Function ValidTextRect : TRect');
    RegisterMethod('Function VertScrollBarSize : Integer');
    RegisterMethod('Function VertScrollBarFromThumb( ThumbPos : Integer) : Integer');
    RegisterPublishedProperties;
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('CaretBlinkTime', 'TAfCLVCaretBlinkTime', iptrw);
    RegisterProperty('CaretCreated', 'Boolean', iptr);
    RegisterProperty('CaretType', 'TAfCLVCaretType', iptrw);
    RegisterProperty('FocusedPoint', 'TPoint', iptrw);
    RegisterProperty('FocusedPointX', 'Longint', iptrw);
    RegisterProperty('FocusedPointY', 'Longint', iptrw);
    RegisterProperty('LeftSpace', 'TAfCLVLeftSpace', iptrw);
    RegisterProperty('LineCount', 'Integer', iptrw);
    RegisterProperty('MaxLineLength', 'TAfCLVMaxLineLength', iptrw);
    RegisterProperty('NeedUpdate', 'Boolean', iptrw);
    RegisterProperty('Options', 'TAfCLVOptions', iptrw);
    RegisterProperty('SelectedText', 'String', iptr);
    RegisterProperty('SelectedColor', 'TColor', iptrw);
    RegisterProperty('SelectedTextColor', 'TColor', iptrw);
    RegisterProperty('SelectedStyle', 'TFontStyles', iptrw);
    RegisterProperty('SelStart', 'TPoint', iptr);
    RegisterProperty('SelEnd', 'TPoint', iptr);
    RegisterProperty('TimerScrolling', 'Boolean', iptrw);
    RegisterProperty('TopLeft', 'TPoint', iptrw);
    RegisterProperty('TopLeftX', 'Longint', iptrw);
    RegisterProperty('TopLeftY', 'Longint', iptrw);
    RegisterProperty('UseScroll', 'Boolean', iptrw);
    RegisterProperty('UseFontCache', 'Boolean', iptrw);
    RegisterProperty('UsedFontStyles', 'TFontStyles', iptrw);
    RegisterProperty('OnBof', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCursorChange', 'TAfCLVCursorEvent', iptrw);
    RegisterProperty('OnDrawLeftSpace', 'TAfCLVDrawLeftSpEvent', iptrw);
    RegisterProperty('OnEof', 'TNotifyEvent', iptrw);
    RegisterProperty('OnFontChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnGetText', 'TAfCLVGetTextEvent', iptrw);
    RegisterProperty('OnLeftSpaceMouseDown', 'TMouseEvent', iptrw);
    RegisterProperty('OnSelectionChange', 'TNotifyEvent', iptrw);
   { RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure ClearSelection');
    RegisterMethod('Procedure CopyToClipboard');
    RegisterMethod('Procedure DrawToCanvas( DrawCanvas : TCanvas; StartLine, EndLine : Integer; Rect : TRect)');
    RegisterMethod('Procedure DrawLineToCanvas( DrawCanvas : TCanvas; LineNumber : Integer; Rect : TRect; TextMetric : TTextMetric)');
    RegisterMethod('Procedure InvalidateDataRect( R : TRect; FullLine : Boolean)');
    RegisterMethod('Procedure InvalidateFocusedLine');
    RegisterMethod('Procedure InvalidateLeftSpace( StartLine, EndLine : Integer)');
    RegisterMethod('Function IsSelectionEmpty : Boolean');
    RegisterMethod('Function MouseToPoint( X, Y : Integer) : TPoint');
    RegisterMethod('Procedure ScrollIntoView');
    RegisterMethod('Procedure SelectAll');
    RegisterMethod('Procedure SelectArea( Old, New : TPoint)');
    RegisterMethod('Function TextFromRange( const ASelStart, ASelEnd : TPoint) : string');
    RegisterMethod('Procedure UnselectArea');}
    //RegisterProperty('CharHeight', 'Integer', iptr);
    //RegisterProperty('CharWidth', 'Integer', iptr);


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfFontStyleCache(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAfFontStyleCache') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAfFontStyleCache') do begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function GetFont( Style : TFontStyles) : HFont');
    RegisterMethod('Function Recreate( Font : TFont) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AfViewers(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('AfCLVMaxLineLength','LongInt').SetInt( 1024);
 CL.AddConstantN('UM_UPDATELINECOUNT','LongWord').SetUInt( WM_USER + $100);
  SIRegister_TAfFontStyleCache(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAfCLVException');
  CL.AddTypeS('TAfCLVCaretType', '( ctVertical, ctHorizontal, ctBlock )');
  CL.AddTypeS('TAfCLVCharAttr', 'record BColor: TColor; FColor: TColor; Style: TFontStyles; end');
  //CL.AddTypeS('PAfCLVCharColors', '^TAfCLVCharColors // will not work');
  CL.AddTypeS('TAfCLVColorMode', '( cmDefault, cmLine, cmChars, cmCheckLength )');
  CL.AddTypeS('TAfCLVFocusSource', '( fsKey, fsMouse, fsHScroll, fsVScroll )');
  CL.AddTypeS('TAfCLVLineState', '( lsNormal, lsFocused, lsSelected )');
  CL.AddTypeS('TAfCLVOption', '(loCanSelect, loSelectByShift, loDrawFocusSelect, loThumbTracking, loScrollToRowCursor, loScrollToColCursor, loShowLineCursor, loShowCaretCursor, loTabs) ');
  CL.AddTypeS('TAfCLVOptions', 'set of TAfCLVOption');
  CL.AddTypeS('TAfCLVLeftSpace', 'Integer');
  CL.AddTypeS('TAfCLVMaxLineLength', 'Integer');
  CL.AddTypeS('TAfCLVCaretBlinkTime', 'Integer');
  CL.AddTypeS('TAfCLVCursorEvent', 'Procedure ( Sender : TObject; CursorPos : TPoint)');
  CL.AddTypeS('TAfCLVDrawLeftSpEvent', 'Procedure ( Sender : TObject; const Lin'
   +'e, LeftCharPos : Integer; Rect : TRect; State : TAfCLVLineState)');
  //CL.AddTypeS('TAfCLVGetTextEvent', 'Procedure ( Sender : TObject; Line : Integ'
  // +'er; var Text: String; var ColorMode: TAfCLVColorMode; var CharColors: TAfCLVCharColors)');
  SIRegister_TAfCustomLineViewer(CL);
  SIRegister_TAfLineViewer(CL);
  CL.AddTypeS('TAfTRMCharColor', 'Integer');
  CL.AddTypeS('TAfTRMCharAttr', 'record FColor: TAfTRMCharColor; BColor: TAfTRMCharColor; end');
  //CL.AddTypeS('PAfTRMCharAttrs', '^TAfTRMCharAttrs // will not work');
  CL.AddTypeS('TAfTRMColorMode', '( cmLDefault, cmL16_16, cmC16_16 )');
  CL.AddTypeS('TAfTRMLogging', '( lgOff, lgCreate, lgAppend )');
  CL.AddTypeS('TAfTRMBkSpcMode', '( bmBack, bmBackDel )');
  CL.AddTypeS('TAfTRMLogSize', 'Integer');
  CL.AddTypeS('TAfTRMLogFlushTime', 'Integer');
  //CL.AddTypeS('TAfTRMGetColorsEvent', 'Procedure ( Sender : TObject; Line : Int'
   //+'eger; var Colors : TAfTRMCharAttrs)');
  CL.AddTypeS('TAfTRMLineEvent', 'Procedure ( Sender : TObject; Line : Integer)');
  CL.AddTypeS('TAfTRMProcessCharEvent', 'Procedure (Sender: TObject; var C: Char)');
  CL.AddTypeS('TAfTRMScrBckBufChange', 'Procedure ( Sender : TObject; BufferSize: Integer)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAfCustomTerminal');
  SIRegister_TAfFileStream(CL);
  SIRegister_TAfTerminalBuffer(CL);
  SIRegister_TAfCustomTerminal(CL);
  SIRegister_TAfTerminal(CL);
  CL.AddTypeS('TAfCVFScanStep', 'Integer');
  SIRegister_TAfCustomFileViewer(CL);
  SIRegister_TAfFileViewer(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAfCustomFileViewerScanPosition_R(Self: TAfCustomFileViewer; var T: Integer);
begin T := Self.ScanPosition; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomFileViewerFileSize_R(Self: TAfCustomFileViewer; var T: DWORD);
begin T := Self.FileSize; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferMaxInvalidate_W(Self: TAfTerminalBuffer; const T: TPoint);
Begin Self.MaxInvalidate := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferMaxInvalidate_R(Self: TAfTerminalBuffer; var T: TPoint);
Begin T := Self.MaxInvalidate; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferLastBufPos_W(Self: TAfTerminalBuffer; const T: TPoint);
Begin Self.LastBufPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferLastBufPos_R(Self: TAfTerminalBuffer; var T: TPoint);
Begin T := Self.LastBufPos; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferEndBufPos_W(Self: TAfTerminalBuffer; const T: TPoint);
Begin Self.EndBufPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferEndBufPos_R(Self: TAfTerminalBuffer; var T: TPoint);
Begin T := Self.EndBufPos; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFTopestLineForUpdateColor_W(Self: TAfTerminalBuffer; const T: Integer);
Begin Self.FTopestLineForUpdateColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFTopestLineForUpdateColor_R(Self: TAfTerminalBuffer; var T: Integer);
Begin T := Self.FTopestLineForUpdateColor; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFColorTable_W(Self: TAfTerminalBuffer; const T: TAfTRMColorTable);
Begin Self.FColorTable := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFColorTable_R(Self: TAfTerminalBuffer; var T: TAfTRMColorTable);
Begin T := Self.FColorTable; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFCharColorsArray_W(Self: TAfTerminalBuffer; const T: PAfTRMCharAttrs);
Begin Self.FCharColorsArray := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalBufferFCharColorsArray_R(Self: TAfTerminalBuffer; var T: PAfTRMCharAttrs);
Begin T := Self.FCharColorsArray; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerCharWidth_R(Self: TAfCustomLineViewer; var T: Integer);
begin T := Self.CharWidth; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerCharHeight_R(Self: TAfCustomLineViewer; var T: Integer);
begin T := Self.CharHeight; end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalColor_R(Self: TAfTerminal; var T: TColor);
Begin T := Self.Color;
end;

(*----------------------------------------------------------------------------*)
procedure TAfTerminalColor_W(Self: TAfTerminal; const T: TColor);
Begin Self.Color:= T; end;

(*----------------------------------------------------------------------------*)
//procedure TAfTerminalColor_R(Self: TAfTerminal; var T: TColor);
//Begin T := Self.Color;
//end;


(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnUserDataChange_W(Self: TAfTerminal; const T: TAfTRMLineEvent);
begin Self.OnUserDataChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnUserDataChange_R(Self: TAfTerminal; var T: TAfTRMLineEvent);
begin T := Self.OnUserDataChange; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnSendChar_W(Self: TAfTerminal; const T: TKeyPressEvent);
begin Self.OnSendChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnSendChar_R(Self: TAfTerminal; var T: TKeyPressEvent);
begin T := Self.OnSendChar; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnScrBckModeChange_W(Self: TAfTerminal; const T: TNotifyEvent);
begin Self.OnScrBckModeChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnScrBckModeChange_R(Self: TAfTerminal; var T: TNotifyEvent);
begin T := Self.OnScrBckModeChange; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnScrBckBufChange_W(Self: TAfTerminal; const T: TAfTRMScrBckBufChange);
begin Self.OnScrBckBufChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnScrBckBufChange_R(Self: TAfTerminal; var T: TAfTRMScrBckBufChange);
begin T := Self.OnScrBckBufChange; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnProcessChar_W(Self: TAfTerminal; const T: TAfTRMProcessCharEvent);
begin Self.OnProcessChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnProcessChar_R(Self: TAfTerminal; var T: TAfTRMProcessCharEvent);
begin T := Self.OnProcessChar; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnNewLine_W(Self: TAfTerminal; const T: TAfTRMLineEvent);
begin Self.OnNewLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnNewLine_R(Self: TAfTerminal; var T: TAfTRMLineEvent);
begin T := Self.OnNewLine; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomTerminalOnLoggingChange_W(Self: TAfCustomTerminal; const T: TNotifyEvent);
//7/begin Self.OnLoggingChange := T; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomTerminalOnLoggingChange_R(Self: TAfTerminal; var T: TNotifyEvent);
//begin T := Self.OnLoggingChange; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnGetColors_W(Self: TAfTerminal; const T: TAfTRMGetColorsEvent);
begin Self.OnGetColors := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnGetColors_R(Self: TAfTerminal; var T: TAfTRMGetColorsEvent);
begin T := Self.OnGetColors; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnFlushLog_W(Self: TAfTerminal; const T: TNotifyEvent);
begin Self.OnFlushLog := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnFlushLog_R(Self: TAfTerminal; var T: TNotifyEvent);
begin T := Self.OnFlushLog; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnDrawBuffer_W(Self: TAfTerminal; const T: TNotifyEvent);
begin Self.OnDrawBuffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnDrawBuffer_R(Self: TAfTerminal; var T: TNotifyEvent);
begin T := Self.OnDrawBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnBeepChar_W(Self: TAfTerminal; const T: TNotifyEvent);
begin Self.OnBeepChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOnBeepChar_R(Self: TAfTerminal; var T: TNotifyEvent);
begin T := Self.OnBeepChar; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalUserDataSize_W(Self: TAfTerminal; const T: Integer);
begin Self.UserDataSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalUserDataSize_R(Self: TAfTerminal; var T: Integer);
begin T := Self.UserDataSize; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalUserData_W(Self: TAfTerminal; const T: Pointer; const t1: Integer);
begin Self.UserData[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalUserData_R(Self: TAfTerminal; var T: Pointer; const t1: Integer);
begin T := Self.UserData[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalTermColorMode_W(Self: TAfTerminal; const T: TAfTRMColorMode);
begin Self.TermColorMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalTermColorMode_R(Self: TAfTerminal; var T: TAfTRMColorMode);
begin T := Self.TermColorMode; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalTermColor_R(Self: TAfTerminal; var T: Integer; const t1: TColor);
begin T := Self.TermColor[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalTerminalCaret_W(Self: TAfTerminal; const T: TAfCLVCaretType);
begin Self.TerminalCaret := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalTerminalCaret_R(Self: TAfTerminal; var T: TAfCLVCaretType);
begin T := Self.TerminalCaret; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalScrollBackMode_W(Self: TAfTerminal; const T: Boolean);
begin Self.ScrollBackMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalScrollBackMode_R(Self: TAfTerminal; var T: Boolean);
begin T := Self.ScrollBackMode; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalScrollBackRows_W(Self: TAfTerminal; const T: Integer);
begin Self.ScrollBackRows := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalScrollBackRows_R(Self: TAfTerminal; var T: Integer);
begin T := Self.ScrollBackRows; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalScrollBackKey_W(Self: TAfTerminal; const T: TShortCut);
begin Self.ScrollBackKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalScrollBackKey_R(Self: TAfTerminal; var T: TShortCut);
begin T := Self.ScrollBackKey; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalScrollBackCaret_W(Self: TAfTerminal; const T: TAfCLVCaretType);
begin Self.ScrollBackCaret := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalScrollBackCaret_R(Self: TAfTerminal; var T: TAfCLVCaretType);
begin T := Self.ScrollBackCaret; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalRelLineColors_W(Self: TAfTerminal; const T: TAfTRMCharAttrs; const t1: Integer);
begin Self.RelLineColors[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalRelLineColors_R(Self: TAfTerminal; var T: TAfTRMCharAttrs; const t1: Integer);
begin T := Self.RelLineColors[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOptions_W(Self: TAfTerminal; const T: TAfCLVOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalOptions_R(Self: TAfTerminal; var T: TAfCLVOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalLogSize_W(Self: TAfTerminal; const T: TAfTRMLogSize);
begin Self.LogSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalLogSize_R(Self: TAfTerminal; var T: TAfTRMLogSize);
begin T := Self.LogSize; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalLogName_W(Self: TAfTerminal; const T: String);
begin Self.LogName := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalLogName_R(Self: TAfTerminal; var T: String);
begin T := Self.LogName; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalLogFlushTime_W(Self: TAfTerminal; const T: TAfTRMLogFlushTime);
begin Self.LogFlushTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalLogFlushTime_R(Self: TAfTerminal; var T: TAfTRMLogFlushTime);
begin T := Self.LogFlushTime; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalLogging_W(Self: TAfTerminal; const T: TAfTRMLogging);
begin Self.Logging := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalLogging_R(Self: TAfTerminal; var T: TAfTRMLogging);
begin T := Self.Logging; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalDisplayCols_W(Self: TAfTerminal; const T: Byte);
begin Self.DisplayCols := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalDisplayCols_R(Self: TAfTerminal; var T: Byte);
begin T := Self.DisplayCols; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalColorTable_W(Self: TAfTerminal; const T: TAfTRMColorTable);
begin Self.ColorTable := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalColorTable_R(Self: TAfTerminal; var T: TAfTRMColorTable);
begin T := Self.ColorTable; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalBufferLineNumber_R(Self: TAfTerminal; var T: Integer);
begin T := Self.BufferLineNumber; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalBufferLine_R(Self: TAfTerminal; var T: String; const t1: Integer);
begin T := Self.BufferLine[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalBkSpcMode_W(Self: TAfTerminal; const T: TAfTRMBkSpcMode);
begin Self.BkSpcMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalBkSpcMode_R(Self: TAfTerminal; var T: TAfTRMBkSpcMode);
begin T := Self.BkSpcMode; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalAutoScrollBack_W(Self: TAfTerminal; const T: Boolean);
begin Self.AutoScrollBack := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomTerminalAutoScrollBack_R(Self: TAfTerminal; var T: Boolean);
begin T := Self.AutoScrollBack; end;

procedure TAfCustomTerminalSeltext_R(Self: TAfTerminal; var T: String);
begin T := Self.SelectedText; end;



(*----------------------------------------------------------------------------*)
procedure TAfTerminalFont_W(Self: TAfTerminal; const T: TFont);
Begin Self.Font:= T; end;


(*----------------------------------------------------------------------------*)
//procedure TAfCustomTerminalColor_W(Self: TAfTerminalBuffer; const T: PAfTRMCharAttrs);
//Begin Self.FCharColorsArray := T; end;

procedure TAfTerminalFont_R(Self: TAfTerminal; var T: TFont);
Begin T := Self.Font;
end;

procedure TAfTerminalCanvas_R(Self: TafTerminal; var T: TCanvas);
begin T := Self.Canvas; end;

procedure TAfTerminalCanvas_W(Self: TafTerminal; var T: TCanvas);
begin //Self.Canvas:= T;
end;


(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerCharWidth_R(Self: TAfCustomLineViewer; var T: Integer);
//begin T := Self.CharWidth; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerCharHeight_R(Self: TAfCustomLineViewer; var T: Integer);
//begin T := Self.CharHeight; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnSelectionChange_W(Self: TAfLineViewer; const T: TNotifyEvent);
begin Self.OnSelectionChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnSelectionChange_R(Self: TAfLineViewer; var T: TNotifyEvent);
begin T := Self.OnSelectionChange; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnLeftSpaceMouseDown_W(Self: TAfLineViewer; const T: TMouseEvent);
begin Self.OnLeftSpaceMouseDown := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnLeftSpaceMouseDown_R(Self: TAfLineViewer; var T: TMouseEvent);
begin T := Self.OnLeftSpaceMouseDown; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnGetText_W(Self: TAfLineViewer; const T: TAfCLVGetTextEvent);
begin Self.OnGetText := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnGetText_R(Self: TAfLineViewer; var T: TAfCLVGetTextEvent);
begin T := Self.OnGetText; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnFontChanged_W(Self: TAfLineViewer; const T: TNotifyEvent);
begin Self.OnFontChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnFontChanged_R(Self: TAfLineViewer; var T: TNotifyEvent);
begin T := Self.OnFontChanged; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnEof_W(Self: TAfLineViewer; const T: TNotifyEvent);
begin Self.OnEof := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnEof_R(Self: TAfLineViewer; var T: TNotifyEvent);
begin T := Self.OnEof; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnDrawLeftSpace_W(Self: TAfLineViewer; const T: TAfCLVDrawLeftSpEvent);
begin Self.OnDrawLeftSpace := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnDrawLeftSpace_R(Self: TAfLineViewer; var T: TAfCLVDrawLeftSpEvent);
begin T := Self.OnDrawLeftSpace; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnCursorChange_W(Self: TAfLineViewer; const T: TAfCLVCursorEvent);
begin Self.OnCursorChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnCursorChange_R(Self: TAfLineViewer; var T: TAfCLVCursorEvent);
begin T := Self.OnCursorChange; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnBof_W(Self: TAfLineViewer; const T: TNotifyEvent);
begin Self.OnBof := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOnBof_R(Self: TAfLineViewer; var T: TNotifyEvent);
begin T := Self.OnBof; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerUsedFontStyles_W(Self: TAfLineViewer; const T: TFontStyles);
begin Self.UsedFontStyles := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerUsedFontStyles_R(Self: TAfLineViewer; var T: TFontStyles);
begin T := Self.UsedFontStyles; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerUseFontCache_W(Self: TAfLineViewer; const T: Boolean);
begin Self.UseFontCache := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerUseFontCache_R(Self: TAfLineViewer; var T: Boolean);
begin T := Self.UseFontCache; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerUseScroll_W(Self: TAfLineViewer; const T: Boolean);
begin Self.UseScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerUseScroll_R(Self: TAfLineViewer; var T: Boolean);
begin T := Self.UseScroll; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerTopLeftY_W(Self: TAfLineViewer; const T: Longint);
//begin Self.TopLeftY := T; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerTopLeftY_R(Self: TAfLineViewer; var T: Longint);
//begin T := Self.TopLeftY; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerTopLeftX_W(Self: TAfLineViewer; const T: Longint);
//begin Self.TopLeftX := T; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerTopLeftX_R(Self: TAfCustomLineViewer; var T: Longint);
//begin T := Self.TopLeftX; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerTopLeft_W(Self: TAfLineViewer; const T: TPoint);
begin Self.TopLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerTopLeft_R(Self: TAfLineViewer; var T: TPoint);
begin T := Self.TopLeft; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerTimerScrolling_W(Self: TAfLineViewer; const T: Boolean);
//begin Self.TimerScrolling := T; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerTimerScrolling_R(Self: TAfLineViewer; var T: Boolean);
//begin T := Self.TimerScrolling; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerSelEnd_R(Self: TAfLineViewer; var T: TPoint);
begin T := Self.SelEnd; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerSelStart_R(Self: TAfLineViewer; var T: TPoint);
begin T := Self.SelStart; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerSelectedStyle_W(Self: TAfLineViewer; const T: TFontStyles);
begin Self.SelectedStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerSelectedStyle_R(Self: TAfLineViewer; var T: TFontStyles);
begin T := Self.SelectedStyle; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerSelectedTextColor_W(Self: TAfLineViewer; const T: TColor);
begin Self.SelectedTextColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerSelectedTextColor_R(Self: TAfLineViewer; var T: TColor);
begin T := Self.SelectedTextColor; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerSelectedColor_W(Self: TAfLineViewer; const T: TColor);
begin Self.SelectedColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerSelectedColor_R(Self: TAfLineViewer; var T: TColor);
begin T := Self.SelectedColor; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerSelectedText_R(Self: TAfLineViewer; var T: String);
begin T := Self.SelectedText; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOptions_W(Self: TAfLineViewer; const T: TAfCLVOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerOptions_R(Self: TAfLineViewer; var T: TAfCLVOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerNeedUpdate_W(Self: TAfLineViewer; const T: Boolean);
//begin Self.NeedUpdate := T; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerNeedUpdate_R(Self: TAfLineViewer; var T: Boolean);
//begin T := Self.NeedUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerMaxLineLength_W(Self: TAfLineViewer; const T: TAfCLVMaxLineLength);
begin Self.MaxLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerMaxLineLength_R(Self: TAfLineViewer; var T: TAfCLVMaxLineLength);
begin T := Self.MaxLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerLineCount_W(Self: TAfLineViewer; const T: Integer);
begin Self.LineCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerLineCount_R(Self: TAfLineViewer; var T: Integer);
begin T := Self.LineCount; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerLeftSpace_W(Self: TAfLineViewer; const T: TAfCLVLeftSpace);
begin Self.LeftSpace := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerLeftSpace_R(Self: TAfLineViewer; var T: TAfCLVLeftSpace);
begin T := Self.LeftSpace; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerFocusedPointY_W(Self: TAfLineViewer; const T: Longint);
//begin Self.FocusedPointY := T; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerFocusedPointY_R(Self: TAfCustomLineViewer; var T: Longint);
//begin T := Self.FocusedPointY; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerFocusedPointX_W(Self: TAfCustomLineViewer; const T: Longint);
//begin Self.FocusedPointX := T; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerFocusedPointX_R(Self: TAfCustomLineViewer; var T: Longint);
//begin T := Self.FocusedPointX; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerFocusedPoint_W(Self: TAfLineViewer; const T: TPoint);
begin Self.FocusedPoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerFocusedPoint_R(Self: TAfLineViewer; var T: TPoint);
begin T := Self.FocusedPoint; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerCaretType_W(Self: TAfLineViewer; const T: TAfCLVCaretType);
begin Self.CaretType := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerCaretType_R(Self: TAfLineViewer; var T: TAfCLVCaretType);
begin T := Self.CaretType; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerCaretCreated_R(Self: TAfLineViewer; var T: Boolean);
//begin T := Self.CaretCreated; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerCaretBlinkTime_W(Self: TAfLineViewer; const T: TAfCLVCaretBlinkTime);
begin Self.CaretBlinkTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerCaretBlinkTime_R(Self: TAfLineViewer; var T: TAfCLVCaretBlinkTime);
begin T := Self.CaretBlinkTime; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerBorderStyle_W(Self: TAfLineViewer; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomLineViewerBorderStyle_R(Self: TAfLineViewer; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerFTextMetric_W(Self: TAfLineViewer; const T: TTextMetric);
//Begin Self.FTextMetric := T; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerFTextMetric_R(Self: TAfLineViewer; var T: TTextMetric);
//Begin T := Self.FTextMetric; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerFFontCache_W(Self: TAfLineViewer; const T: TAfFontStyleCache);
//Begin Self.FFontCache := T; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerFFontCache_R(Self: TAfLineViewer; var T: TAfFontStyleCache);
//Begin T := Self.FFontCache; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerFCharColors_W(Self: TAfLineViewer; const T: PAfCLVCharColors);
//Begin Self.FCharColors := T; end;

(*----------------------------------------------------------------------------*)
//procedure TAfCustomLineViewerFCharColors_R(Self: TAfCustomLineViewer; var T: PAfCLVCharColors);
//Begin T := Self.FCharColors; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_AfViewers_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfFileViewer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfFileViewer) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfCustomFileViewer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfCustomFileViewer) do begin
    RegisterConstructor(@TAfCustomFileViewer.Create, 'Create');
    RegisterMethod(@TAfCustomFileViewer.Destroy, 'Free');
    RegisterMethod(@TAfCustomFileViewer.CloseFile, 'CloseFile');
    RegisterMethod(@TAfCustomFileViewer.FilePtrFromLine, 'FilePtrFromLine');
    RegisterMethod(@TAfCustomFileViewer.OpenFile, 'OpenFile');
    RegisterMethod(@TAfCustomFileViewer.OpenData, 'OpenData');
    RegisterPropertyHelper(@TAfCustomFileViewerFileSize_R,nil,'FileSize');
    RegisterPropertyHelper(@TAfCustomFileViewerScanPosition_R,nil,'ScanPosition');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfTerminal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfTerminal) do begin
    RegisterPropertyHelper(@TAfTerminalColor_R,@TAfTerminalColor_W,'Color');
    RegisterPropertyHelper(@TAfTerminalFont_R,@TAfTerminalFont_W,'Font');
    RegisterPropertyHelper(@TAfTerminalCanvas_R,@TAfTerminalCanvas_W,'Canvas');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfCustomTerminal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfCustomTerminal) do begin
    RegisterConstructor(@TAfCustomTerminal.Create, 'Create');
    RegisterMethod(@TAfCustomTerminal.Destroy, 'Free');
    RegisterMethod(@TAfCustomTerminal.ClearBuffer, 'ClearBuffer');
    RegisterMethod(@TAfCustomTerminal.DefaultTermColor, 'DefaultTermColor');
    RegisterMethod(@TAfCustomTerminal.DrawChangedBuffer, 'DrawChangedBuffer');
    RegisterMethod(@TAfCustomTerminal.WriteChar, 'WriteChar');
    RegisterMethod(@TAfCustomTerminal.WriteColorChar, 'WriteColorChar');
    RegisterMethod(@TAfCustomTerminal.WriteColorStringAndData, 'WriteColorStringAndData');
    RegisterMethod(@TAfCustomTerminal.WriteString, 'WriteString');

    // RegisterMethod('Procedure Free');
     //RegisterMethod('Procedure ClearBuffer');
    //RegisterMethod('Function DefaultTermColor : TAfTRMCharAttr');
    //RegisterMethod('Procedure DrawChangedBuffer');
    //RegisterMethod('Procedure WriteChar( C : Char)');
    //RegisterMethod('Procedure WriteColorChar( C : Char; BColor, FColor : TAfTRMCharColor)');
    //RegisterMethod('Procedure WriteColorStringAndData( const S : String; BColor, FColor : TAfTRMCharColor; UserDataItem : Pointer)');
    //RegisterMethod('Procedure WriteString( const S : String)');
    RegisterMethod(@TAfCustomTerminal.CloseLogFile, 'CloseLogFile');
   RegisterMethod(@TAfCustomTerminal.DoBeepChar, 'DoBeepChar');
   RegisterMethod(@TAfCustomTerminal.DoDrawBuffer, 'DoDrawBuffer');
    RegisterMethod(@TAfCustomTerminal.DoLoggingChange, 'DoLoggingChange');
    RegisterMethod(@TAfCustomTerminal.DoScrBckBufChange, 'DoScrBckBufChange');
   RegisterMethod(@TAfCustomTerminal.FlushLogBuffer, 'FlushLogBuffer');
   RegisterMethod(@TAfCustomTerminal.FocusEndOfBuffer, 'FocusEndOfBuffer');
    RegisterMethod(@TAfCustomTerminal.GetColorsForThisLine, 'GetColorsForThisLine');
    RegisterMethod(@TAfCustomTerminal.OpenLogFile, 'OpenLogFile');
   RegisterMethod(@TAfCustomTerminal.WriteToLog, 'WriteToLog');
   //RegisterMethod(@TAfCustomTerminal.DoDrawBuffer, 'DoDrawBuffer');
   // RegisterMethod(@TAfCustomTerminal.DoLoggingChange, 'DoLoggingChange');

     // RegisterPropertyHelper(@TAfCustomTerminalColor_R,@TAfCustomTerminalColor_W,'Color');
    //RegisterPropertyHelper(@TAfCustomTerminalFont_R,@TAfCustomTerminalFont_W,'Font');
    // RegisterMethod(@TAfCustomTerminal.CloseLogFile, 'CloseLogFile');
    //RegisterMethod(@TAfCustomTerminal.DoBeepChar, 'DoBeepChar');
    //RegisterMethod(@TAfCustomTerminal.DoDrawBuffer, 'DoDrawBuffer');
    //RegisterVirtualMethod(@TAfCustomTerminal.DoLoggingChange, 'DoLoggingChange');
    //RegisterMethod(@TAfCustomTerminal.DoScrBckBufChange, 'DoScrBckBufChange');
    //RegisterMethod(@TAfCustomTerminal.FlushLogBuffer, 'FlushLogBuffer');
    //RegisterMethod(@TAfCustomTerminal.FocusEndOfBuffer, 'FocusEndOfBuffer');
    //RegisterMethod(@TAfCustomTerminal.GetColorsForThisLine, 'GetColorsForThisLine');
    //RegisterMethod(@TAfCustomTerminal.OpenLogFile, 'OpenLogFile');
    //RegisterMethod(@TAfCustomTerminal.WriteToLog, 'WriteToLog');
 {      property BufferLine;
    property BufferLineNumber;
    property Canvas;
    property ColorTable;
    property FocusedPoint;
    property RelLineColors;
    property SelectedText;
    property SelStart;
    property SelEnd;
    property ScrollBackMode;
    property TermColor;
    property TopLeft;
    property UserData;
    property UseScroll; }

    RegisterPropertyHelper(@TAfCustomTerminalSeltext_R,nil,'SelectedText');
    //RegisterPropertyHelper(@TAfCustomTerminalRelinecolorstext_R,nil,'SelectedText');

    RegisterPropertyHelper(@TAfCustomTerminalAutoScrollBack_R,@TAfCustomTerminalAutoScrollBack_W,'AutoScrollBack');
    RegisterPropertyHelper(@TAfCustomTerminalBkSpcMode_R,@TAfCustomTerminalBkSpcMode_W,'BkSpcMode');
    RegisterPropertyHelper(@TAfCustomTerminalBufferLine_R,nil,'BufferLine');
    RegisterPropertyHelper(@TAfCustomTerminalBufferLineNumber_R,nil,'BufferLineNumber');
    RegisterPropertyHelper(@TAfCustomTerminalColorTable_R,@TAfCustomTerminalColorTable_W,'ColorTable');
    RegisterPropertyHelper(@TAfCustomTerminalDisplayCols_R,@TAfCustomTerminalDisplayCols_W,'DisplayCols');
    RegisterPropertyHelper(@TAfCustomTerminalLogging_R,@TAfCustomTerminalLogging_W,'Logging');
    RegisterPropertyHelper(@TAfCustomTerminalLogFlushTime_R,@TAfCustomTerminalLogFlushTime_W,'LogFlushTime');
    RegisterPropertyHelper(@TAfCustomTerminalLogName_R,@TAfCustomTerminalLogName_W,'LogName');
    RegisterPropertyHelper(@TAfCustomTerminalLogSize_R,@TAfCustomTerminalLogSize_W,'LogSize');
    RegisterPropertyHelper(@TAfCustomTerminalOptions_R,@TAfCustomTerminalOptions_W,'Options');
    RegisterPropertyHelper(@TAfCustomTerminalRelLineColors_R,@TAfCustomTerminalRelLineColors_W,'RelLineColors');
    RegisterPropertyHelper(@TAfCustomTerminalScrollBackCaret_R,@TAfCustomTerminalScrollBackCaret_W,'ScrollBackCaret');
    RegisterPropertyHelper(@TAfCustomTerminalScrollBackKey_R,@TAfCustomTerminalScrollBackKey_W,'ScrollBackKey');
    RegisterPropertyHelper(@TAfCustomTerminalScrollBackRows_R,@TAfCustomTerminalScrollBackRows_W,'ScrollBackRows');
    RegisterPropertyHelper(@TAfCustomTerminalScrollBackMode_R,@TAfCustomTerminalScrollBackMode_W,'ScrollBackMode');
    RegisterPropertyHelper(@TAfCustomTerminalTerminalCaret_R,@TAfCustomTerminalTerminalCaret_W,'TerminalCaret');
    RegisterPropertyHelper(@TAfCustomTerminalTermColor_R,nil,'TermColor');
    RegisterPropertyHelper(@TAfCustomTerminalTermColorMode_R,@TAfCustomTerminalTermColorMode_W,'TermColorMode');
    RegisterPropertyHelper(@TAfCustomTerminalUserData_R,@TAfCustomTerminalUserData_W,'UserData');
    RegisterPropertyHelper(@TAfCustomTerminalUserDataSize_R,@TAfCustomTerminalUserDataSize_W,'UserDataSize');
    RegisterPropertyHelper(@TAfCustomTerminalOnBeepChar_R,@TAfCustomTerminalOnBeepChar_W,'OnBeepChar');
    RegisterPropertyHelper(@TAfCustomTerminalOnDrawBuffer_R,@TAfCustomTerminalOnDrawBuffer_W,'OnDrawBuffer');
    RegisterPropertyHelper(@TAfCustomTerminalOnFlushLog_R,@TAfCustomTerminalOnFlushLog_W,'OnFlushLog');
    RegisterPropertyHelper(@TAfCustomTerminalOnGetColors_R,@TAfCustomTerminalOnGetColors_W,'OnGetColors');
    //RegisterPropertyHelper(@TAfCustomTerminalOnLoggingChange_R,@TAfCustomTerminalOnLoggingChange_W,'OnLoggingChange');
    RegisterPropertyHelper(@TAfCustomTerminalOnNewLine_R,@TAfCustomTerminalOnNewLine_W,'OnNewLine');
    RegisterPropertyHelper(@TAfCustomTerminalOnProcessChar_R,@TAfCustomTerminalOnProcessChar_W,'OnProcessChar');
    RegisterPropertyHelper(@TAfCustomTerminalOnScrBckBufChange_R,@TAfCustomTerminalOnScrBckBufChange_W,'OnScrBckBufChange');
    RegisterPropertyHelper(@TAfCustomTerminalOnScrBckModeChange_R,@TAfCustomTerminalOnScrBckModeChange_W,'OnScrBckModeChange');
    RegisterPropertyHelper(@TAfCustomTerminalOnSendChar_R,@TAfCustomTerminalOnSendChar_W,'OnSendChar');
    RegisterPropertyHelper(@TAfCustomTerminalOnUserDataChange_R,@TAfCustomTerminalOnUserDataChange_W,'OnUserDataChange');

    //RegisterProperty('COLOR', 'TColor', iptrw);
    //RegisterProperty('FONT', 'TFont', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfTerminalBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfTerminalBuffer) do begin
    RegisterPropertyHelper(@TAfTerminalBufferFCharColorsArray_R,@TAfTerminalBufferFCharColorsArray_W,'FCharColorsArray');
    RegisterPropertyHelper(@TAfTerminalBufferFColorTable_R,@TAfTerminalBufferFColorTable_W,'FColorTable');
    RegisterPropertyHelper(@TAfTerminalBufferFTopestLineForUpdateColor_R,@TAfTerminalBufferFTopestLineForUpdateColor_W,'FTopestLineForUpdateColor');
    RegisterPropertyHelper(@TAfTerminalBufferEndBufPos_R,@TAfTerminalBufferEndBufPos_W,'EndBufPos');
    RegisterPropertyHelper(@TAfTerminalBufferLastBufPos_R,@TAfTerminalBufferLastBufPos_W,'LastBufPos');
    RegisterPropertyHelper(@TAfTerminalBufferMaxInvalidate_R,@TAfTerminalBufferMaxInvalidate_W,'MaxInvalidate');
    RegisterConstructor(@TAfTerminalBuffer.Create, 'Create');
      RegisterMethod(@TAfTerminalBuffer.Destroy, 'Free');
    RegisterMethod(@TAfTerminalBuffer.ClearBuffer, 'ClearBuffer');
    RegisterMethod(@TAfTerminalBuffer.DrawChangedBuffer, 'DrawChangedBuffer');
    RegisterMethod(@TAfTerminalBuffer.GetBuffColorsForDraw, 'GetBuffColorsForDraw');
    RegisterMethod(@TAfTerminalBuffer.GetBuffLine, 'GetBuffLine');
    RegisterMethod(@TAfTerminalBuffer.GetLineColors, 'GetLineColors');
    RegisterMethod(@TAfTerminalBuffer.ReallocBuffer, 'ReallocBuffer');
    RegisterMethod(@TAfTerminalBuffer.SetLineColors, 'SetLineColors');
    RegisterMethod(@TAfTerminalBuffer.WriteChar, 'WriteChar');
    RegisterMethod(@TAfTerminalBuffer.WriteColorChar, 'WriteColorChar');
    RegisterMethod(@TAfTerminalBuffer.WriteStr, 'WriteStr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfFileStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfFileStream) do begin
    RegisterConstructor(@TAfFileStream.Create, 'Create');
     RegisterMethod(@TAfFileStream.Destroy, 'Free');
    RegisterMethod(@TAfFileStream.FlushBuffers, 'FlushBuffers');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfLineViewer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfLineViewer) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfCustomLineViewer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfCustomLineViewer) do begin
    RegisterConstructor(@TAfCustomLineViewer.Create, 'Create');
        RegisterMethod(@TAfCustomLineViewer.Destroy, 'Free');
    RegisterMethod(@TAfCustomLineViewer.ClearSelection, 'ClearSelection');
    RegisterMethod(@TAfCustomLineViewer.CopyToClipboard, 'CopyToClipboard');
    RegisterMethod(@TAfCustomLineViewer.DrawToCanvas, 'DrawToCanvas');
    RegisterMethod(@TAfCustomLineViewer.DrawLineToCanvas, 'DrawLineToCanvas');
    RegisterMethod(@TAfCustomLineViewer.InvalidateDataRect, 'InvalidateDataRect');
    RegisterMethod(@TAfCustomLineViewer.InvalidateFocusedLine, 'InvalidateFocusedLine');
    RegisterMethod(@TAfCustomLineViewer.InvalidateLeftSpace, 'InvalidateLeftSpace');
    RegisterMethod(@TAfCustomLineViewer.IsSelectionEmpty, 'IsSelectionEmpty');
    RegisterMethod(@TAfCustomLineViewer.MouseToPoint, 'MouseToPoint');
    RegisterMethod(@TAfCustomLineViewer.ScrollIntoView, 'ScrollIntoView');
    RegisterMethod(@TAfCustomLineViewer.SelectAll, 'SelectAll');
    RegisterMethod(@TAfCustomLineViewer.SelectArea, 'SelectArea');
    RegisterMethod(@TAfCustomLineViewer.TextFromRange, 'TextFromRange');
    RegisterMethod(@TAfCustomLineViewer.UnselectArea, 'UnselectArea');
    RegisterPropertyHelper(@TAfCustomLineViewerCharHeight_R,nil,'CharHeight');
    RegisterPropertyHelper(@TAfCustomLineViewerCharWidth_R,nil,'CharWidth');

  //     RegisterPropertyHelper(@TAfCustomLineViewerFCharColors_R,@TAfCustomLineViewerFCharColors_W,'FCharColors');
    //RegisterPropertyHelper(@TAfCustomLineViewerFFontCache_R,@TAfCustomLineViewerFFontCache_W,'FFontCache');
    //RegisterPropertyHelper(@TAfCustomLineViewerFTextMetric_R,@TAfCustomLineViewerFTextMetric_W,'FTextMetric');
    //RegisterMethod(@TAfCustomLineViewer.CalcCharPointPos, 'CalcCharPointPos');
    //RegisterVirtualMethod(@TAfCustomLineViewer.CreateCaret, 'CreateCaret');
    //RegisterVirtualMethod(@TAfCustomLineViewer.DoBof, 'DoBof');
    //RegisterMethod(@TAfCustomLineViewer.DoCursorChange, 'DoCursorChange');
    //RegisterVirtualMethod(@TAfCustomLineViewer.DoEof, 'DoEof');
   // RegisterVirtualMethod(@TAfCustomLineViewer.DoSelectionChange, 'DoSelectionChange');
   // RegisterVirtualMethod(@TAfCustomLineViewer.DrawLeftSpace, 'DrawLeftSpace');
    //RegisterVirtualMethod(@TAfLineViewer.DrawLine, 'DrawLine');
    //RegisterVirtualMethod(@TAfCustomLineViewer.FocusRequest, 'FocusRequest');
    //RegisterVirtualMethod(@TAfCustomLineViewer.GetText, 'GetText');
    //RegisterMethod(@TAfCustomLineViewer.HideCaret, 'HideCaret');
    //RegisterMethod(@TAfCustomLineViewer.LineLength, 'LineLength');
    //RegisterMethod(@TAfCustomLineViewer.ReallocColorArray, 'ReallocColorArray');
//    RegisterMethod(@TAfCustomLineViewer.ShowCaret, 'ShowCaret');
 //   RegisterMethod(@TAfCustomLineViewer.ScrollByX, 'ScrollByX');
   // RegisterMethod(@TAfCustomLineViewer.ScrollByY, 'ScrollByY');
    //R//egisterVirtualMethod(@TAfCustomLineViewer.ScrollIntoViewX, 'ScrollIntoViewX');
    //RegisterVirtualMethod(@TAfCustomLineViewer.ScrollIntoViewY, 'ScrollIntoViewY');
//    RegisterMethod(@TAfCustomLineViewer.SetCaretPos, 'SetCaretPos');
  //  RegisterMethod(@TAfCustomLineViewer.SetCaret, 'SetCaret');
    //RegisterVirtualMethod(@TAfCustomLineViewer.UpdateLineViewer, 'UpdateLineViewer');
//    RegisterVirtualMethod(@TAfCustomLineViewer.UpdateScrollPos, 'UpdateScrollPos');
  //  RegisterMethod(@TAfCustomLineViewer.ValidTextRect, 'ValidTextRect');
  //  RegisterVirtualMethod(@TAfCustomLineViewer.VertScrollBarSize, 'VertScrollBarSize');
  //  RegisterVirtualMethod(@TAfCustomLineViewer.VertScrollBarFromThumb, 'VertScrollBarFromThumb');
    RegisterPropertyHelper(@TAfCustomLineViewerBorderStyle_R,@TAfCustomLineViewerBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TAfCustomLineViewerCaretBlinkTime_R,@TAfCustomLineViewerCaretBlinkTime_W,'CaretBlinkTime');
    //RegisterPropertyHelper(@TAfCustomLineViewerCaretCreated_R,nil,'CaretCreated');
    RegisterPropertyHelper(@TAfCustomLineViewerCaretType_R,@TAfCustomLineViewerCaretType_W,'CaretType');
    RegisterPropertyHelper(@TAfCustomLineViewerFocusedPoint_R,@TAfCustomLineViewerFocusedPoint_W,'FocusedPoint');
//    RegisterPropertyHelper(@TAfCustomLineViewerFocusedPointX_R,@TAfCustomLineViewerFocusedPointX_W,'FocusedPointX');
//    RegisterPropertyHelper(@TAfCustomLineViewerFocusedPointY_R,@TAfCustomLineViewerFocusedPointY_W,'FocusedPointY');
    RegisterPropertyHelper(@TAfCustomLineViewerLeftSpace_R,@TAfCustomLineViewerLeftSpace_W,'LeftSpace');
    RegisterPropertyHelper(@TAfCustomLineViewerLineCount_R,@TAfCustomLineViewerLineCount_W,'LineCount');
    RegisterPropertyHelper(@TAfCustomLineViewerMaxLineLength_R,@TAfCustomLineViewerMaxLineLength_W,'MaxLineLength');
//    RegisterPropertyHelper(@TAfCustomLineViewerNeedUpdate_R,@TAfCustomLineViewerNeedUpdate_W,'NeedUpdate');
    RegisterPropertyHelper(@TAfCustomLineViewerOptions_R,@TAfCustomLineViewerOptions_W,'Options');
    RegisterPropertyHelper(@TAfCustomLineViewerSelectedText_R,nil,'SelectedText');
    RegisterPropertyHelper(@TAfCustomLineViewerSelectedColor_R,@TAfCustomLineViewerSelectedColor_W,'SelectedColor');
    RegisterPropertyHelper(@TAfCustomLineViewerSelectedTextColor_R,@TAfCustomLineViewerSelectedTextColor_W,'SelectedTextColor');
    RegisterPropertyHelper(@TAfCustomLineViewerSelectedStyle_R,@TAfCustomLineViewerSelectedStyle_W,'SelectedStyle');
    RegisterPropertyHelper(@TAfCustomLineViewerSelStart_R,nil,'SelStart');
    RegisterPropertyHelper(@TAfCustomLineViewerSelEnd_R,nil,'SelEnd');
    //RegisterPropertyHelper(@TAfCustomLineViewerTimerScrolling_R,@TAfCustomLineViewerTimerScrolling_W,'TimerScrolling');
    RegisterPropertyHelper(@TAfCustomLineViewerTopLeft_R,@TAfCustomLineViewerTopLeft_W,'TopLeft');
//    RegisterPropertyHelper(@TAfCustomLineViewerTopLeftX_R,@TAfCustomLineViewerTopLeftX_W,'TopLeftX');
//    RegisterPropertyHelper(@TAfCustomLineViewerTopLeftY_R,@TAfCustomLineViewerTopLeftY_W,'TopLeftY');
    RegisterPropertyHelper(@TAfCustomLineViewerUseScroll_R,@TAfCustomLineViewerUseScroll_W,'UseScroll');
    RegisterPropertyHelper(@TAfCustomLineViewerUseFontCache_R,@TAfCustomLineViewerUseFontCache_W,'UseFontCache');
    RegisterPropertyHelper(@TAfCustomLineViewerUsedFontStyles_R,@TAfCustomLineViewerUsedFontStyles_W,'UsedFontStyles');
    RegisterPropertyHelper(@TAfCustomLineViewerOnBof_R,@TAfCustomLineViewerOnBof_W,'OnBof');
    RegisterPropertyHelper(@TAfCustomLineViewerOnCursorChange_R,@TAfCustomLineViewerOnCursorChange_W,'OnCursorChange');
    RegisterPropertyHelper(@TAfCustomLineViewerOnDrawLeftSpace_R,@TAfCustomLineViewerOnDrawLeftSpace_W,'OnDrawLeftSpace');
    RegisterPropertyHelper(@TAfCustomLineViewerOnEof_R,@TAfCustomLineViewerOnEof_W,'OnEof');
    RegisterPropertyHelper(@TAfCustomLineViewerOnFontChanged_R,@TAfCustomLineViewerOnFontChanged_W,'OnFontChanged');
    RegisterPropertyHelper(@TAfCustomLineViewerOnGetText_R,@TAfCustomLineViewerOnGetText_W,'OnGetText');
    RegisterPropertyHelper(@TAfCustomLineViewerOnLeftSpaceMouseDown_R,@TAfCustomLineViewerOnLeftSpaceMouseDown_W,'OnLeftSpaceMouseDown');
    RegisterPropertyHelper(@TAfCustomLineViewerOnSelectionChange_R,@TAfCustomLineViewerOnSelectionChange_W,'OnSelectionChange');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfFontStyleCache(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfFontStyleCache) do begin
    RegisterMethod(@TAfFontStyleCache.Clear, 'Clear');
    RegisterMethod(@TAfFontStyleCache.GetFont, 'GetFont');
    RegisterMethod(@TAfFontStyleCache.Recreate, 'Recreate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfViewers(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAfFontStyleCache(CL);
  with CL.Add(EAfCLVException) do
  RIRegister_TAfCustomLineViewer(CL);
  RIRegister_TAfLineViewer(CL);
  with CL.Add(TAfCustomTerminal) do
  RIRegister_TAfFileStream(CL);
  RIRegister_TAfTerminalBuffer(CL);
  RIRegister_TAfCustomTerminal(CL);
  RIRegister_TAfTerminal(CL);
  RIRegister_TAfCustomFileViewer(CL);
  RIRegister_TAfFileViewer(CL);
end;

 
 
{ TPSImport_AfViewers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfViewers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AfViewers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfViewers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AfViewers(ri);
  RIRegister_AfViewers_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
