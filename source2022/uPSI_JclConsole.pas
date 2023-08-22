unit uPSI_JclConsole;
{

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
  TPSImport_JclConsole = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclInputBuffer(CL: TPSPascalCompiler);
procedure SIRegister_TJclScreenWindow(CL: TPSPascalCompiler);
procedure SIRegister_TJclScreenCursor(CL: TPSPascalCompiler);
procedure SIRegister_TJclScreenCharacter(CL: TPSPascalCompiler);
procedure SIRegister_TJclScreenTextAttribute(CL: TPSPascalCompiler);
procedure SIRegister_TJclScreenFont(CL: TPSPascalCompiler);
procedure SIRegister_TJclScreenCustomTextAttribute(CL: TPSPascalCompiler);
procedure SIRegister_IJclScreenTextAttribute(CL: TPSPascalCompiler);
procedure SIRegister_TJclScreenBuffer(CL: TPSPascalCompiler);
procedure SIRegister_TJclConsole(CL: TPSPascalCompiler);
procedure SIRegister_JclConsole(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJclInputBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclScreenWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclScreenCursor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclScreenCharacter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclScreenTextAttribute(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclScreenFont(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclScreenCustomTextAttribute(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclScreenBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclConsole(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclConsole(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Contnrs
  ,JclBase
  ,JclConsole
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclConsole]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclInputBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TJclInputBuffer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TJclInputBuffer') do
  begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure RaiseCtrlEvent( const AEvent : TJclInputCtrlEvent; const ProcessGroupId : DWORD)');
    RegisterMethod('Function WaitEvent( const TimeOut : DWORD) : Boolean');
    RegisterMethod('Function GetEvents( var Events : TJclInputRecordArray) : DWORD;');
    RegisterMethod('Function PeekEvents( var Events : TJclInputRecordArray) : DWORD;');
    RegisterMethod('Function PutEvents( const Events : TJclInputRecordArray) : DWORD;');
    RegisterMethod('Function GetEvents1( const Count : Integer) : TJclInputRecordArray;');
    RegisterMethod('Function PeekEvents1( const Count : Integer) : TJclInputRecordArray;');
    RegisterMethod('Function GetEvent : TInputRecord');
    RegisterMethod('Function PeekEvent : TInputRecord');
    RegisterMethod('Function PutEvent( const Event : TInputRecord) : Boolean');
    RegisterProperty('Console', 'TJclConsole', iptr);
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('Mode', 'TJclConsoleInputModes', iptrw);
    RegisterProperty('EventCount', 'DWORD', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclScreenWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TJclScreenWindow') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TJclScreenWindow') do
  begin
    RegisterMethod('Procedure Scroll( const cx, cy : Smallint)');
    RegisterProperty('ScreenBuffer', 'TJclScreenBuffer', iptr);
    RegisterProperty('MaxConsoleWindowSize', 'TCoord', iptr);
    RegisterProperty('MaxWindow', 'TCoord', iptr);
    RegisterProperty('Position', 'TCoord', iptrw);
    RegisterProperty('Size', 'TCoord', iptrw);
    RegisterProperty('Left', 'Smallint', iptrw);
    RegisterProperty('Right', 'Smallint', iptrw);
    RegisterProperty('Top', 'Smallint', iptrw);
    RegisterProperty('Bottom', 'Smallint', iptrw);
    RegisterProperty('Width', 'Smallint', iptrw);
    RegisterProperty('Height', 'Smallint', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclScreenCursor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TJclScreenCursor') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TJclScreenCursor') do
  begin
    RegisterProperty('ScreenBuffer', 'TJclScreenBuffer', iptr);
    RegisterMethod('Procedure MoveTo( const DestPos : TCoord);');
    RegisterMethod('Procedure MoveTo1( const x, y : Smallint);');
    RegisterMethod('Procedure MoveBy( const Delta : TCoord);');
    RegisterMethod('Procedure MoveBy1( const cx, cy : Smallint);');
    RegisterProperty('Position', 'TCoord', iptrw);
    RegisterProperty('Size', 'TJclScreenCursorSize', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclScreenCharacter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclScreenCustomTextAttribute', 'TJclScreenCharacter') do
  with CL.AddClassN(CL.FindClass('TJclScreenCustomTextAttribute'),'TJclScreenCharacter') do
  begin
    RegisterProperty('Info', 'TCharInfo', iptrw);
    RegisterProperty('Character', 'Char', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclScreenTextAttribute(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclScreenCustomTextAttribute', 'TJclScreenTextAttribute') do
  with CL.AddClassN(CL.FindClass('TJclScreenCustomTextAttribute'),'TJclScreenTextAttribute') do
  begin
    RegisterMethod('Constructor Create1( const Attribute : Word);');
    RegisterMethod('Constructor Create2( const AColor : TJclScreenFontColor; const ABgColor : TJclScreenBackColor; const AHighLight : Boolean; const ABgHighLight : Boolean; const AStyle : TJclScreenFontStyles);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclScreenFont(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclScreenCustomTextAttribute', 'TJclScreenFont') do
  with CL.AddClassN(CL.FindClass('TJclScreenCustomTextAttribute'),'TJclScreenFont') do
  begin
    RegisterProperty('ScreenBuffer', 'TJclScreenBuffer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclScreenCustomTextAttribute(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TJclScreenCustomTextAttribute') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TJclScreenCustomTextAttribute') do
  begin
    RegisterMethod('Constructor Create( const attr : TJclScreenCustomTextAttribute);');
    RegisterMethod('Procedure Clear');
    RegisterProperty('TextAttribute', 'Word', iptrw);
    RegisterProperty('Color', 'TJclScreenFontColor', iptrw);
    RegisterProperty('BgColor', 'TJclScreenBackColor', iptrw);
    RegisterProperty('Highlight', 'Boolean', iptrw);
    RegisterProperty('BgHighlight', 'Boolean', iptrw);
    RegisterProperty('Style', 'TJclScreenFontStyles', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclScreenTextAttribute(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IJclScreenTextAttribute') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclScreenTextAttribute, 'IJclScreenTextAttribute') do
  begin
    RegisterMethod('Function GetTextAttribute : Word', cdRegister);
    RegisterMethod('Procedure SetTextAttribute( const Value : Word)', cdRegister);
    RegisterMethod('Function GetColor : TJclScreenFontColor', cdRegister);
    RegisterMethod('Procedure SetColor( const Value : TJclScreenFontColor)', cdRegister);
    RegisterMethod('Function GetBgColor : TJclScreenBackColor', cdRegister);
    RegisterMethod('Procedure SetBgColor( const Value : TJclScreenBackColor)', cdRegister);
    RegisterMethod('Function GetHighlight : Boolean', cdRegister);
    RegisterMethod('Procedure SetHighlight( const Value : Boolean)', cdRegister);
    RegisterMethod('Function GetBgHighlight : Boolean', cdRegister);
    RegisterMethod('Procedure SetBgHighlight( const Value : Boolean)', cdRegister);
    RegisterMethod('Function GetStyle : TJclScreenFontStyles', cdRegister);
    RegisterMethod('Procedure SetStyle( const Value : TJclScreenFontStyles)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclScreenBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TJclScreenBuffer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TJclScreenBuffer') do
  begin
    RegisterMethod('Function Write( const Text : string; const ATextAttribute : IJclScreenTextAttribute) : DWORD;');
    RegisterMethod('Function WriteLn( const Text : string; const ATextAttribute : IJclScreenTextAttribute) : DWORD;');
    RegisterMethod('Function Write1( const Text : string; const X : Smallint; const Y : Smallint; const ATextAttribute : IJclScreenTextAttribute) : DWORD;');
    RegisterMethod('Function Write2( const Text : string; const X : Smallint; const Y : Smallint; const pAttrs : PWORD) : DWORD;');
    RegisterMethod('Function Write3( const Text : string; const HorizontalAlign : TJclScreenBufferTextHorizontalAlign; const VerticalAlign : TJclScreenBufferTextVerticalAlign; const ATextAttribute : IJclScreenTextAttribute) : DWORD;');
    RegisterMethod('Function Read( const Count : Integer) : string;');
    RegisterMethod('Function Read1( X : Smallint; Y : Smallint; const Count : Integer) : string;');
    RegisterMethod('Function ReadLn : string;');
    RegisterMethod('Function ReadLn1( X : Smallint; Y : Smallint) : string;');
    RegisterMethod('Procedure Fill( const ch : Char; const ATextAttribute : IJclScreenTextAttribute)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('Font', 'TJclScreenFont', iptr);
    RegisterProperty('Cursor', 'TJclScreenCursor', iptr);
    RegisterProperty('Window', 'TJclScreenWindow', iptr);
    RegisterProperty('Size', 'TCoord', iptrw);
    RegisterProperty('Width', 'Smallint', iptrw);
    RegisterProperty('Height', 'Smallint', iptrw);
    RegisterProperty('Mode', 'TJclConsoleOutputModes', iptrw);
    RegisterProperty('OnBeforeResize', 'TJclScreenBufferBeforeResizeEvent', iptrw);
    RegisterProperty('OnAfterResize', 'TJclScreenBufferAfterResizeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclConsole(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TJclConsole') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TJclConsole') do
  begin
    RegisterMethod('Function Default : TJclConsole');
    RegisterMethod('Procedure Shutdown');
    RegisterMethod('Function IsConsole( const Module : HMODULE) : Boolean;');
    RegisterMethod('Function IsConsole1( const FileName : TFileName) : Boolean;');
    RegisterMethod('Function MouseButtonCount : DWORD');
    RegisterMethod('Procedure Alloc');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Add( AWidth : Smallint; AHeight : Smallint) : TJclScreenBuffer');
    RegisterMethod('Function Remove( const ScrBuf : TJclScreenBuffer) : Longword');
    RegisterMethod('Procedure Delete( const Idx : Longword)');
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('InputCodePage', 'DWORD', iptrw);
    RegisterProperty('OutputCodePage', 'DWORD', iptrw);
    RegisterProperty('Input', 'TJclInputBuffer', iptr);
    RegisterProperty('Screens', 'TJclScreenBuffer Longword', iptr);
    RegisterProperty('ScreenCount', 'Longword', iptr);
    RegisterProperty('ActiveScreenIndex', 'Longword', iptrw);
    RegisterProperty('ActiveScreen', 'TJclScreenBuffer', iptrw);
    RegisterProperty('OnCtrlC', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCtrlBreak', 'TNotifyEvent', iptrw);
    RegisterProperty('OnClose', 'TNotifyEvent', iptrw);
    RegisterProperty('OnLogOff', 'TNotifyEvent', iptrw);
    RegisterProperty('OnShutdown', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclConsole(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclScreenBuffer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclInputBuffer');
  SIRegister_TJclConsole(CL);
  CL.AddTypeS('TJclConsoleInputMode', '( imLine, imEcho, imProcessed, imWindow,imMouse )');
  CL.AddTypeS('TJclConsoleInputModes', 'set of TJclConsoleInputMode');
  CL.AddTypeS('TJclConsoleOutputMode', '( omProcessed, omWrapAtEol )');
  CL.AddTypeS('TJclConsoleOutputModes', 'set of TJclConsoleOutputMode');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclScreenTextAttribute, 'IJclScreenTextAttribute');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclScreenFont');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclScreenCharacter');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclScreenCursor');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclScreenWindow');
  //CL.AddTypeS('TJclScreenBufferBeforeResizeEvent', 'Procedure ( Sender : TObjec'
  // +'t; const NewSize : TCoord; var CanResize : Boolean)');
  CL.AddTypeS('TJclScreenBufferAfterResizeEvent', 'Procedure ( Sender : TObject)');
  CL.AddTypeS('TJclScreenBufferTextHorizontalAlign', '( thaCurrent, thaLeft, thaCenter, thaRight )');
  CL.AddTypeS('TJclScreenBufferTextVerticalAlign', '( tvaCurrent, tvaTop, tvaCenter, tvaBottom )');
  SIRegister_TJclScreenBuffer(CL);
  CL.AddTypeS('TJclScreenFontColor', '( fclBlack, fclBlue, fclGreen, fclRed, fc'
   +'lCyan, fclMagenta, fclYellow, fclWhite )');
  CL.AddTypeS('TJclScreenBackColor', '( bclBlack, bclBlue, bclGreen, bclRed, bc'
   +'lCyan, bclMagenta, bclYellow, bclWhite )');
  CL.AddTypeS('TJclScreenFontStyle', '( fsLeadingByte, fsTrailingByte, fsGridHo'
   +'rizontal, fsGridLeftVertical, fsGridRightVertical, fsReverseVideo, fsUnderscore, fsSbcsDbcs )');
  CL.AddTypeS('TJclScreenFontStyles', 'set of TJclScreenFontStyle');
  SIRegister_IJclScreenTextAttribute(CL);
  SIRegister_TJclScreenCustomTextAttribute(CL);
  SIRegister_TJclScreenFont(CL);
  SIRegister_TJclScreenTextAttribute(CL);
  SIRegister_TJclScreenCharacter(CL);
  CL.AddTypeS('TJclScreenCursorSize', 'Integer');
  SIRegister_TJclScreenCursor(CL);
  SIRegister_TJclScreenWindow(CL);
  CL.AddTypeS('TJclInputCtrlEvent', '( ceCtrlC, ceCtrlBreak, ceCtrlClose, ceCtr'
   +'lLogOff, ceCtrlShutdown )');
  //CL.AddTypeS('TJclInputRecordArray', 'array of TInputRecord');
  SIRegister_TJclInputBuffer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclInputBufferEventCount_R(Self: TJclInputBuffer; var T: DWORD);
begin T := Self.EventCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclInputBufferMode_W(Self: TJclInputBuffer; const T: TJclConsoleInputModes);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclInputBufferMode_R(Self: TJclInputBuffer; var T: TJclConsoleInputModes);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TJclInputBufferHandle_R(Self: TJclInputBuffer; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TJclInputBufferConsole_R(Self: TJclInputBuffer; var T: TJclConsole);
begin T := Self.Console; end;

(*----------------------------------------------------------------------------*)
Function TJclInputBufferPeekEvents1_P(Self: TJclInputBuffer;  const Count : Integer) : TJclInputRecordArray;
Begin Result := Self.PeekEvents(Count); END;

(*----------------------------------------------------------------------------*)
Function TJclInputBufferGetEvents1_P(Self: TJclInputBuffer;  const Count : Integer) : TJclInputRecordArray;
Begin Result := Self.GetEvents(Count); END;

(*----------------------------------------------------------------------------*)
Function TJclInputBufferPutEvents_P(Self: TJclInputBuffer;  const Events : TJclInputRecordArray) : DWORD;
Begin Result := Self.PutEvents(Events); END;

(*----------------------------------------------------------------------------*)
Function TJclInputBufferPeekEvents_P(Self: TJclInputBuffer;  var Events : TJclInputRecordArray) : DWORD;
Begin Result := Self.PeekEvents(Events); END;

(*----------------------------------------------------------------------------*)
Function TJclInputBufferGetEvents_P(Self: TJclInputBuffer;  var Events : TJclInputRecordArray) : DWORD;
Begin Result := Self.GetEvents(Events); END;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowHeight_W(Self: TJclScreenWindow; const T: Smallint);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowHeight_R(Self: TJclScreenWindow; var T: Smallint);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowWidth_W(Self: TJclScreenWindow; const T: Smallint);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowWidth_R(Self: TJclScreenWindow; var T: Smallint);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowBottom_W(Self: TJclScreenWindow; const T: Smallint);
begin Self.Bottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowBottom_R(Self: TJclScreenWindow; var T: Smallint);
begin T := Self.Bottom; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowTop_W(Self: TJclScreenWindow; const T: Smallint);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowTop_R(Self: TJclScreenWindow; var T: Smallint);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowRight_W(Self: TJclScreenWindow; const T: Smallint);
begin Self.Right := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowRight_R(Self: TJclScreenWindow; var T: Smallint);
begin T := Self.Right; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowLeft_W(Self: TJclScreenWindow; const T: Smallint);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowLeft_R(Self: TJclScreenWindow; var T: Smallint);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowSize_W(Self: TJclScreenWindow; const T: TCoord);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowSize_R(Self: TJclScreenWindow; var T: TCoord);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowPosition_W(Self: TJclScreenWindow; const T: TCoord);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowPosition_R(Self: TJclScreenWindow; var T: TCoord);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowMaxWindow_R(Self: TJclScreenWindow; var T: TCoord);
begin T := Self.MaxWindow; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowMaxConsoleWindowSize_R(Self: TJclScreenWindow; var T: TCoord);
begin T := Self.MaxConsoleWindowSize; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenWindowScreenBuffer_R(Self: TJclScreenWindow; var T: TJclScreenBuffer);
begin T := Self.ScreenBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCursorVisible_W(Self: TJclScreenCursor; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCursorVisible_R(Self: TJclScreenCursor; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCursorSize_W(Self: TJclScreenCursor; const T: TJclScreenCursorSize);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCursorSize_R(Self: TJclScreenCursor; var T: TJclScreenCursorSize);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCursorPosition_W(Self: TJclScreenCursor; const T: TCoord);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCursorPosition_R(Self: TJclScreenCursor; var T: TCoord);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
Procedure TJclScreenCursorMoveBy1_P(Self: TJclScreenCursor;  const cx, cy : Smallint);
Begin Self.MoveBy(cx, cy); END;

(*----------------------------------------------------------------------------*)
Procedure TJclScreenCursorMoveBy_P(Self: TJclScreenCursor;  const Delta : TCoord);
Begin Self.MoveBy(Delta); END;

(*----------------------------------------------------------------------------*)
Procedure TJclScreenCursorMoveTo1_P(Self: TJclScreenCursor;  const x, y : Smallint);
Begin Self.MoveTo(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure TJclScreenCursorMoveTo_P(Self: TJclScreenCursor;  const DestPos : TCoord);
Begin Self.MoveTo(DestPos); END;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCursorScreenBuffer_R(Self: TJclScreenCursor; var T: TJclScreenBuffer);
begin T := Self.ScreenBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCharacterCharacter_W(Self: TJclScreenCharacter; const T: Char);
begin Self.Character := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCharacterCharacter_R(Self: TJclScreenCharacter; var T: Char);
begin T := Self.Character; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCharacterInfo_W(Self: TJclScreenCharacter; const T: TCharInfo);
begin Self.Info := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCharacterInfo_R(Self: TJclScreenCharacter; var T: TCharInfo);
begin T := Self.Info; end;

(*----------------------------------------------------------------------------*)
Function TJclScreenTextAttributeCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const AColor : TJclScreenFontColor; const ABgColor : TJclScreenBackColor; const AHighLight : Boolean; const ABgHighLight : Boolean; const AStyle : TJclScreenFontStyles):TObject;
Begin Result := TJclScreenTextAttribute.Create(AColor, ABgColor, AHighLight, ABgHighLight, AStyle); END;

(*----------------------------------------------------------------------------*)
Function TJclScreenTextAttributeCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const Attribute : Word):TObject;
Begin Result := TJclScreenTextAttribute.Create(Attribute); END;

(*----------------------------------------------------------------------------*)
procedure TJclScreenFontScreenBuffer_R(Self: TJclScreenFont; var T: TJclScreenBuffer);
begin T := Self.ScreenBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeStyle_W(Self: TJclScreenCustomTextAttribute; const T: TJclScreenFontStyles);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeStyle_R(Self: TJclScreenCustomTextAttribute; var T: TJclScreenFontStyles);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeBgHighlight_W(Self: TJclScreenCustomTextAttribute; const T: Boolean);
begin Self.BgHighlight := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeBgHighlight_R(Self: TJclScreenCustomTextAttribute; var T: Boolean);
begin T := Self.BgHighlight; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeHighlight_W(Self: TJclScreenCustomTextAttribute; const T: Boolean);
begin Self.Highlight := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeHighlight_R(Self: TJclScreenCustomTextAttribute; var T: Boolean);
begin T := Self.Highlight; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeBgColor_W(Self: TJclScreenCustomTextAttribute; const T: TJclScreenBackColor);
begin Self.BgColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeBgColor_R(Self: TJclScreenCustomTextAttribute; var T: TJclScreenBackColor);
begin T := Self.BgColor; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeColor_W(Self: TJclScreenCustomTextAttribute; const T: TJclScreenFontColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeColor_R(Self: TJclScreenCustomTextAttribute; var T: TJclScreenFontColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeTextAttribute_W(Self: TJclScreenCustomTextAttribute; const T: Word);
begin Self.TextAttribute := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenCustomTextAttributeTextAttribute_R(Self: TJclScreenCustomTextAttribute; var T: Word);
begin T := Self.TextAttribute; end;

(*----------------------------------------------------------------------------*)
Function TJclScreenCustomTextAttributeCreate_P(Self: TClass; CreateNewInstance: Boolean;  const attr : TJclScreenCustomTextAttribute):TObject;
Begin Result := TJclScreenCustomTextAttribute.Create(attr); END;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferOnAfterResize_W(Self: TJclScreenBuffer; const T: TJclScreenBufferAfterResizeEvent);
begin Self.OnAfterResize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferOnAfterResize_R(Self: TJclScreenBuffer; var T: TJclScreenBufferAfterResizeEvent);
begin T := Self.OnAfterResize; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferOnBeforeResize_W(Self: TJclScreenBuffer; const T: TJclScreenBufferBeforeResizeEvent);
begin Self.OnBeforeResize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferOnBeforeResize_R(Self: TJclScreenBuffer; var T: TJclScreenBufferBeforeResizeEvent);
begin T := Self.OnBeforeResize; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferMode_W(Self: TJclScreenBuffer; const T: TJclConsoleOutputModes);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferMode_R(Self: TJclScreenBuffer; var T: TJclConsoleOutputModes);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferHeight_W(Self: TJclScreenBuffer; const T: Smallint);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferHeight_R(Self: TJclScreenBuffer; var T: Smallint);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferWidth_W(Self: TJclScreenBuffer; const T: Smallint);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferWidth_R(Self: TJclScreenBuffer; var T: Smallint);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferSize_W(Self: TJclScreenBuffer; const T: TCoord);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferSize_R(Self: TJclScreenBuffer; var T: TCoord);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferWindow_R(Self: TJclScreenBuffer; var T: TJclScreenWindow);
begin T := Self.Window; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferCursor_R(Self: TJclScreenBuffer; var T: TJclScreenCursor);
begin T := Self.Cursor; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferFont_R(Self: TJclScreenBuffer; var T: TJclScreenFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TJclScreenBufferHandle_R(Self: TJclScreenBuffer; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferReadLn1_P(Self: TJclScreenBuffer;  X : Smallint; Y : Smallint) : string;
Begin Result := Self.ReadLn(X, Y); END;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferReadLn_P(Self: TJclScreenBuffer) : string;
Begin Result := Self.ReadLn; END;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferRead1_P(Self: TJclScreenBuffer;  X : Smallint; Y : Smallint; const Count : Integer) : string;
Begin Result := Self.Read(X, Y, Count); END;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferRead_P(Self: TJclScreenBuffer;  const Count : Integer) : string;
Begin Result := Self.Read(Count); END;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferWrite3_P(Self: TJclScreenBuffer;  const Text : string; const HorizontalAlign : TJclScreenBufferTextHorizontalAlign; const VerticalAlign : TJclScreenBufferTextVerticalAlign; const ATextAttribute : IJclScreenTextAttribute) : DWORD;
Begin Result := Self.Write(Text, HorizontalAlign, VerticalAlign, ATextAttribute); END;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferWrite2_P(Self: TJclScreenBuffer;  const Text : string; const X : Smallint; const Y : Smallint; const pAttrs : PWORD) : DWORD;
Begin Result := Self.Write(Text, X, Y, pAttrs); END;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferWrite1_P(Self: TJclScreenBuffer;  const Text : string; const X : Smallint; const Y : Smallint; const ATextAttribute : IJclScreenTextAttribute) : DWORD;
Begin Result := Self.Write(Text, X, Y, ATextAttribute); END;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferWriteLn_P(Self: TJclScreenBuffer;  const Text : string; const ATextAttribute : IJclScreenTextAttribute) : DWORD;
Begin Result := Self.WriteLn(Text, ATextAttribute); END;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferWrite_P(Self: TJclScreenBuffer;  const Text : string; const ATextAttribute : IJclScreenTextAttribute) : DWORD;
Begin Result := Self.Write(Text, ATextAttribute); END;

(*----------------------------------------------------------------------------*)
Procedure TJclScreenBufferDoResize1_P(Self: TJclScreenBuffer;  const NewWidth, NewHeight : Smallint);
Begin //Self.DoResize(NewWidth, NewHeight);
 END;

(*----------------------------------------------------------------------------*)
Procedure TJclScreenBufferDoResize_P(Self: TJclScreenBuffer;  const NewSize : TCoord);
Begin //Self.DoResize(NewSize);
 END;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const AWidth, AHeight : Smallint):TObject;
Begin //Result := TJclScreenBuffer.Create(AWidth, AHeight);
 END;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const AHandle : THandle):TObject;
Begin //Result := TJclScreenBuffer.Create(AHandle);
END;

(*----------------------------------------------------------------------------*)
Function TJclScreenBufferCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TJclScreenBuffer.Create; END;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOnShutdown_W(Self: TJclConsole; const T: TNotifyEvent);
begin Self.OnShutdown := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOnShutdown_R(Self: TJclConsole; var T: TNotifyEvent);
begin T := Self.OnShutdown; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOnLogOff_W(Self: TJclConsole; const T: TNotifyEvent);
begin Self.OnLogOff := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOnLogOff_R(Self: TJclConsole; var T: TNotifyEvent);
begin T := Self.OnLogOff; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOnClose_W(Self: TJclConsole; const T: TNotifyEvent);
begin Self.OnClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOnClose_R(Self: TJclConsole; var T: TNotifyEvent);
begin T := Self.OnClose; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOnCtrlBreak_W(Self: TJclConsole; const T: TNotifyEvent);
begin Self.OnCtrlBreak := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOnCtrlBreak_R(Self: TJclConsole; var T: TNotifyEvent);
begin T := Self.OnCtrlBreak; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOnCtrlC_W(Self: TJclConsole; const T: TNotifyEvent);
begin Self.OnCtrlC := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOnCtrlC_R(Self: TJclConsole; var T: TNotifyEvent);
begin T := Self.OnCtrlC; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleActiveScreen_W(Self: TJclConsole; const T: TJclScreenBuffer);
begin Self.ActiveScreen := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleActiveScreen_R(Self: TJclConsole; var T: TJclScreenBuffer);
begin T := Self.ActiveScreen; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleActiveScreenIndex_W(Self: TJclConsole; const T: Longword);
begin Self.ActiveScreenIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleActiveScreenIndex_R(Self: TJclConsole; var T: Longword);
begin T := Self.ActiveScreenIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleScreenCount_R(Self: TJclConsole; var T: Longword);
begin T := Self.ScreenCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleScreens_R(Self: TJclConsole; var T: TJclScreenBuffer; const t1: Longword);
begin T := Self.Screens[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleInput_R(Self: TJclConsole; var T: TJclInputBuffer);
begin T := Self.Input; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOutputCodePage_W(Self: TJclConsole; const T: DWORD);
begin Self.OutputCodePage := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleOutputCodePage_R(Self: TJclConsole; var T: DWORD);
begin T := Self.OutputCodePage; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleInputCodePage_W(Self: TJclConsole; const T: DWORD);
begin Self.InputCodePage := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleInputCodePage_R(Self: TJclConsole; var T: DWORD);
begin T := Self.InputCodePage; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleTitle_W(Self: TJclConsole; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclConsoleTitle_R(Self: TJclConsole; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
Function TJclConsoleIsConsole1_P(Self: TJclConsole;  const FileName : TFileName) : Boolean;
Begin Result := Self.IsConsole(FileName); END;

(*----------------------------------------------------------------------------*)
Function TJclConsoleIsConsole_P(Self: TJclConsole;  const Module : HMODULE) : Boolean;
Begin Result := Self.IsConsole(Module); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclInputBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclInputBuffer) do
  begin
    RegisterMethod(@TJclInputBuffer.Clear, 'Clear');
    RegisterMethod(@TJclInputBuffer.RaiseCtrlEvent, 'RaiseCtrlEvent');
    RegisterMethod(@TJclInputBuffer.WaitEvent, 'WaitEvent');
    RegisterMethod(@TJclInputBufferGetEvents_P, 'GetEvents');
    RegisterMethod(@TJclInputBufferPeekEvents_P, 'PeekEvents');
    RegisterMethod(@TJclInputBufferPutEvents_P, 'PutEvents');
    RegisterMethod(@TJclInputBufferGetEvents1_P, 'GetEvents1');
    RegisterMethod(@TJclInputBufferPeekEvents1_P, 'PeekEvents1');
    RegisterMethod(@TJclInputBuffer.GetEvent, 'GetEvent');
    RegisterMethod(@TJclInputBuffer.PeekEvent, 'PeekEvent');
    RegisterMethod(@TJclInputBuffer.PutEvent, 'PutEvent');
    RegisterPropertyHelper(@TJclInputBufferConsole_R,nil,'Console');
    RegisterPropertyHelper(@TJclInputBufferHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TJclInputBufferMode_R,@TJclInputBufferMode_W,'Mode');
    RegisterPropertyHelper(@TJclInputBufferEventCount_R,nil,'EventCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclScreenWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclScreenWindow) do
  begin
    RegisterMethod(@TJclScreenWindow.Scroll, 'Scroll');
    RegisterPropertyHelper(@TJclScreenWindowScreenBuffer_R,nil,'ScreenBuffer');
    RegisterPropertyHelper(@TJclScreenWindowMaxConsoleWindowSize_R,nil,'MaxConsoleWindowSize');
    RegisterPropertyHelper(@TJclScreenWindowMaxWindow_R,nil,'MaxWindow');
    RegisterPropertyHelper(@TJclScreenWindowPosition_R,@TJclScreenWindowPosition_W,'Position');
    RegisterPropertyHelper(@TJclScreenWindowSize_R,@TJclScreenWindowSize_W,'Size');
    RegisterPropertyHelper(@TJclScreenWindowLeft_R,@TJclScreenWindowLeft_W,'Left');
    RegisterPropertyHelper(@TJclScreenWindowRight_R,@TJclScreenWindowRight_W,'Right');
    RegisterPropertyHelper(@TJclScreenWindowTop_R,@TJclScreenWindowTop_W,'Top');
    RegisterPropertyHelper(@TJclScreenWindowBottom_R,@TJclScreenWindowBottom_W,'Bottom');
    RegisterPropertyHelper(@TJclScreenWindowWidth_R,@TJclScreenWindowWidth_W,'Width');
    RegisterPropertyHelper(@TJclScreenWindowHeight_R,@TJclScreenWindowHeight_W,'Height');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclScreenCursor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclScreenCursor) do
  begin
    RegisterPropertyHelper(@TJclScreenCursorScreenBuffer_R,nil,'ScreenBuffer');
    RegisterMethod(@TJclScreenCursorMoveTo_P, 'MoveTo');
    RegisterMethod(@TJclScreenCursorMoveTo1_P, 'MoveTo1');
    RegisterMethod(@TJclScreenCursorMoveBy_P, 'MoveBy');
    RegisterMethod(@TJclScreenCursorMoveBy1_P, 'MoveBy1');
    RegisterPropertyHelper(@TJclScreenCursorPosition_R,@TJclScreenCursorPosition_W,'Position');
    RegisterPropertyHelper(@TJclScreenCursorSize_R,@TJclScreenCursorSize_W,'Size');
    RegisterPropertyHelper(@TJclScreenCursorVisible_R,@TJclScreenCursorVisible_W,'Visible');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclScreenCharacter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclScreenCharacter) do
  begin
    RegisterPropertyHelper(@TJclScreenCharacterInfo_R,@TJclScreenCharacterInfo_W,'Info');
    RegisterPropertyHelper(@TJclScreenCharacterCharacter_R,@TJclScreenCharacterCharacter_W,'Character');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclScreenTextAttribute(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclScreenTextAttribute) do
  begin
    RegisterConstructor(@TJclScreenTextAttributeCreate1_P, 'Create1');
    RegisterConstructor(@TJclScreenTextAttributeCreate2_P, 'Create2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclScreenFont(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclScreenFont) do
  begin
    RegisterPropertyHelper(@TJclScreenFontScreenBuffer_R,nil,'ScreenBuffer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclScreenCustomTextAttribute(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclScreenCustomTextAttribute) do
  begin
    RegisterConstructor(@TJclScreenCustomTextAttributeCreate_P, 'Create');
    RegisterMethod(@TJclScreenCustomTextAttribute.Clear, 'Clear');
    RegisterPropertyHelper(@TJclScreenCustomTextAttributeTextAttribute_R,@TJclScreenCustomTextAttributeTextAttribute_W,'TextAttribute');
    RegisterPropertyHelper(@TJclScreenCustomTextAttributeColor_R,@TJclScreenCustomTextAttributeColor_W,'Color');
    RegisterPropertyHelper(@TJclScreenCustomTextAttributeBgColor_R,@TJclScreenCustomTextAttributeBgColor_W,'BgColor');
    RegisterPropertyHelper(@TJclScreenCustomTextAttributeHighlight_R,@TJclScreenCustomTextAttributeHighlight_W,'Highlight');
    RegisterPropertyHelper(@TJclScreenCustomTextAttributeBgHighlight_R,@TJclScreenCustomTextAttributeBgHighlight_W,'BgHighlight');
    RegisterPropertyHelper(@TJclScreenCustomTextAttributeStyle_R,@TJclScreenCustomTextAttributeStyle_W,'Style');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclScreenBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclScreenBuffer) do
  begin
    RegisterMethod(@TJclScreenBufferWrite_P, 'Write');
    RegisterMethod(@TJclScreenBufferWriteLn_P, 'WriteLn');
    RegisterMethod(@TJclScreenBufferWrite1_P, 'Write1');
    RegisterMethod(@TJclScreenBufferWrite2_P, 'Write2');
    RegisterMethod(@TJclScreenBufferWrite3_P, 'Write3');
    RegisterMethod(@TJclScreenBufferRead_P, 'Read');
    RegisterMethod(@TJclScreenBufferRead1_P, 'Read1');
    RegisterMethod(@TJclScreenBufferReadLn_P, 'ReadLn');
    RegisterMethod(@TJclScreenBufferReadLn1_P, 'ReadLn1');
    RegisterMethod(@TJclScreenBuffer.Fill, 'Fill');
    RegisterMethod(@TJclScreenBuffer.Clear, 'Clear');
    RegisterPropertyHelper(@TJclScreenBufferHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TJclScreenBufferFont_R,nil,'Font');
    RegisterPropertyHelper(@TJclScreenBufferCursor_R,nil,'Cursor');
    RegisterPropertyHelper(@TJclScreenBufferWindow_R,nil,'Window');
    RegisterPropertyHelper(@TJclScreenBufferSize_R,@TJclScreenBufferSize_W,'Size');
    RegisterPropertyHelper(@TJclScreenBufferWidth_R,@TJclScreenBufferWidth_W,'Width');
    RegisterPropertyHelper(@TJclScreenBufferHeight_R,@TJclScreenBufferHeight_W,'Height');
    RegisterPropertyHelper(@TJclScreenBufferMode_R,@TJclScreenBufferMode_W,'Mode');
    RegisterPropertyHelper(@TJclScreenBufferOnBeforeResize_R,@TJclScreenBufferOnBeforeResize_W,'OnBeforeResize');
    RegisterPropertyHelper(@TJclScreenBufferOnAfterResize_R,@TJclScreenBufferOnAfterResize_W,'OnAfterResize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclConsole(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclConsole) do
  begin
    RegisterMethod(@TJclConsole.Default, 'Default');
    RegisterMethod(@TJclConsole.Shutdown, 'Shutdown');
    RegisterMethod(@TJclConsoleIsConsole_P, 'IsConsole');
    RegisterMethod(@TJclConsoleIsConsole1_P, 'IsConsole1');
    RegisterMethod(@TJclConsole.MouseButtonCount, 'MouseButtonCount');
    RegisterMethod(@TJclConsole.Alloc, 'Alloc');
    RegisterMethod(@TJclConsole.Free, 'Free');
    RegisterMethod(@TJclConsole.Add, 'Add');
    RegisterMethod(@TJclConsole.Remove, 'Remove');
    RegisterMethod(@TJclConsole.Delete, 'Delete');
    RegisterPropertyHelper(@TJclConsoleTitle_R,@TJclConsoleTitle_W,'Title');
    RegisterPropertyHelper(@TJclConsoleInputCodePage_R,@TJclConsoleInputCodePage_W,'InputCodePage');
    RegisterPropertyHelper(@TJclConsoleOutputCodePage_R,@TJclConsoleOutputCodePage_W,'OutputCodePage');
    RegisterPropertyHelper(@TJclConsoleInput_R,nil,'Input');
    RegisterPropertyHelper(@TJclConsoleScreens_R,nil,'Screens');
    RegisterPropertyHelper(@TJclConsoleScreenCount_R,nil,'ScreenCount');
    RegisterPropertyHelper(@TJclConsoleActiveScreenIndex_R,@TJclConsoleActiveScreenIndex_W,'ActiveScreenIndex');
    RegisterPropertyHelper(@TJclConsoleActiveScreen_R,@TJclConsoleActiveScreen_W,'ActiveScreen');
    RegisterPropertyHelper(@TJclConsoleOnCtrlC_R,@TJclConsoleOnCtrlC_W,'OnCtrlC');
    RegisterPropertyHelper(@TJclConsoleOnCtrlBreak_R,@TJclConsoleOnCtrlBreak_W,'OnCtrlBreak');
    RegisterPropertyHelper(@TJclConsoleOnClose_R,@TJclConsoleOnClose_W,'OnClose');
    RegisterPropertyHelper(@TJclConsoleOnLogOff_R,@TJclConsoleOnLogOff_W,'OnLogOff');
    RegisterPropertyHelper(@TJclConsoleOnShutdown_R,@TJclConsoleOnShutdown_W,'OnShutdown');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclConsole(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclScreenBuffer) do
  with CL.Add(TJclInputBuffer) do
  RIRegister_TJclConsole(CL);
  with CL.Add(TJclScreenFont) do
  with CL.Add(TJclScreenCharacter) do
  with CL.Add(TJclScreenCursor) do
  with CL.Add(TJclScreenWindow) do
  RIRegister_TJclScreenBuffer(CL);
  RIRegister_TJclScreenCustomTextAttribute(CL);
  RIRegister_TJclScreenFont(CL);
  RIRegister_TJclScreenTextAttribute(CL);
  RIRegister_TJclScreenCharacter(CL);
  RIRegister_TJclScreenCursor(CL);
  RIRegister_TJclScreenWindow(CL);
  RIRegister_TJclInputBuffer(CL);
end;

 
 
{ TPSImport_JclConsole }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclConsole.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclConsole(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclConsole.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
