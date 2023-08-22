unit uPSI_KFunctions;
{
last function pac

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
  TPSImport_KFunctions = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_KFunctions(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_KFunctions_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  //,UnixCP
  {,LCLType
  ,LCLIntf
  ,LMessages
  ,LCLProc
  ,LCLVersion
  ,Interfaces
  ,InterfaceBase }
  ,Messages
  ,ClipBrd
  ,Controls
  ,ComCtrls
  ,Graphics
  ,StdCtrls
  ,Forms
  ,KFunctions
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_KFunctions]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_KFunctions(CL: TPSPascalCompiler);
begin
 {CL.AddConstantN('KM_MOUSELEAVE','').SetString( WM_MOUSELEAVE);
 CL.AddConstantN('LM_USER','').SetString( WM_USER);
 CL.AddConstantN('LM_CANCELMODE','').SetString( WM_CANCELMODE);
 CL.AddConstantN('LM_CHAR','').SetString( WM_CHAR);
 CL.AddConstantN('LM_CLEAR','').SetString( WM_CLEAR);
 CL.AddConstantN('LM_CLOSEQUERY','').SetString( WM_CLOSE);
 CL.AddConstantN('LM_COPY','').SetString( WM_COPY);
 CL.AddConstantN('LM_CUT','').SetString( WM_CUT);
 CL.AddConstantN('LM_DROPFILES','').SetString( WM_DROPFILES);
 CL.AddConstantN('LM_ERASEBKGND','').SetString( WM_ERASEBKGND);
 CL.AddConstantN('LM_GETDLGCODE','').SetString( WM_GETDLGCODE);
 CL.AddConstantN('LM_HSCROLL','').SetString( WM_HSCROLL);
 CL.AddConstantN('LM_KEYDOWN','').SetString( WM_KEYDOWN);
 CL.AddConstantN('LM_KILLFOCUS','').SetString( WM_KILLFOCUS);
 CL.AddConstantN('LM_LBUTTONDOWN','').SetString( WM_LBUTTONDOWN);
 CL.AddConstantN('LM_LBUTTONUP','').SetString( WM_LBUTTONUP);
 CL.AddConstantN('LM_MOUSEMOVE','').SetString( WM_MOUSEMOVE);
 CL.AddConstantN('LM_MOVE','').SetString( WM_MOVE);
 CL.AddConstantN('LM_PASTE','').SetString( WM_PASTE);
 CL.AddConstantN('LM_SETFOCUS','').SetString( WM_SETFOCUS);
 CL.AddConstantN('LM_SIZE','').SetString( WM_SIZE);
 CL.AddConstantN('LM_VSCROLL','').SetString( WM_VSCROLL);
 CL.AddConstantN('LCL_MAJOR','LongInt').SetInt( 0);
 CL.AddConstantN('LCL_MINOR','LongInt').SetInt( 0);
 CL.AddConstantN('LCL_RELEASE','LongInt').SetInt( 0);
 CL.AddConstantN('KM_MOUSELEAVE','').SetString( LM_LEAVE);
 CL.AddConstantN('KM_MOUSELEAVE','').SetString( LM_MOUSELEAVE);
 CL.AddConstantN('KM_MOUSELEAVE','').SetString( LM_LEAVE);
 CL.AddConstantN('KM_MOUSELEAVE','').SetString( LM_MOUSELEAVE);  }
 CL.AddConstantN('SHFolderDll','String').SetString( 'SHFolder.dll');
 CL.AddConstantN('KM_BASE','LongInt').SetInt( LM_USER + 1024);
 CL.AddConstantN('KM_LATEUPDATE','LongInt').SetInt( KM_BASE + 1);
 CL.AddConstantN('crHResize','LongInt').SetInt( TCursor ( 101 ));
 CL.AddConstantN('crVResize','LongInt').SetInt( TCursor ( 102 ));
 CL.AddConstantN('crDragHandFree','LongInt').SetInt( TCursor ( 103 ));
 CL.AddConstantN('crDragHandGrip','LongInt').SetInt( TCursor ( 104 ));
 CL.AddConstantN('cCheckBoxFrameSize','LongInt').SetInt( 13);
 CL.AddConstantN('cCR','Char').SetString( #13);
 CL.AddConstantN('cLF','Char').SetString( #10);
 CL.AddConstantN('cTAB','Char').SetString( #9);
 CL.AddConstantN('cSPACE','Char').SetString( #32);
 CL.AddConstantN('cNULL','Char').SetString( #0);
 {CL.AddConstantN('cWordBreaks','LongInt').Value.ts32 := ord(cNULL) or ord(cTAB) or ord(cSPACE);
 CL.AddConstantN('cLineBreaks','LongInt').Value.ts32 := ord(cCR) or ord(cLF);
 CL.AddConstantN('cEllipsis','String').SetString( '...');
 CL.AddConstantN('cEOL','').SetString( cLF);
 CL.AddConstantN('cFirstEOL','').SetString( cLF);
 CL.AddConstantN('cFirstEOL','').SetString( cCR); }
  CL.AddTypeS('TLMessage', 'TMessage');
  CL.AddTypeS('TKkString', 'Widestring');
  CL.AddTypeS('TKkChar', 'char');

  //TKChar = TUTF8Char;

  {CL.AddTypeS('TLMCopy', 'TWMCopy');
  CL.AddTypeS('TLMMouse', 'TWMMouse');
  CL.AddTypeS('TLMNoParams', 'TWMNoParams');
  CL.AddTypeS('TLMKey', 'TWMKey');
  CL.AddTypeS('TLMChar', 'TWMChar');
  CL.AddTypeS('TLMEraseBkGnd', 'TWMEraseBkGnd');
  CL.AddTypeS('TLMHScroll', 'TWMHScroll');
  CL.AddTypeS('TLMKillFocus', 'TWMKillFocus');
  CL.AddTypeS('TLMMove', 'TWMMove');
  CL.AddTypeS('TLMPaste', 'TWMPaste');
  CL.AddTypeS('TLMSetFocus', 'TWMSetFocus');
  CL.AddTypeS('TLMSize', 'TWMSize');
  CL.AddTypeS('TLMVScroll', 'TWMVScroll'); }
  CL.AddTypeS('LONG_PTR2', 'Longint');
  CL.AddTypeS('TKSysCharSet', 'set of AnsiChar');
  CL.AddTypeS('TKCurrencyFormat', 'record CurrencyFormat : Byte; CurrencyDecima'
   +'ls : Byte; CurrencyString : TKkString; DecimalSep : Char; ThousandSep : Cha'
   +'r; UseThousandSep : Boolean; end');
  {CL.AddTypeS('TKAppContext', 'record Application : TApplication; Screen : TScr'
   +'een; GlobalNameSpace : IReadWriteSync; MainThreadID : LongWord; IntConstLi'
   +'st : TThreadList; WidgetSet : TWidgetSet; DragManager : TDragManager; end');  }
 // CL.AddTypeS('PKAppContext', '^TKAppContext // will not work');
  //CL.AddTypeS('TKClipboardFormat', 'TClipboardFormat');
  CL.AddTypeS('TKClipboardFormat', 'Word');
  CL.AddTypeS('TKCellSpan', 'record ColSpan : Integer; RowSpan : Integer; end');
 CL.AddDelphiFunction('Function AdjustDecimalSeparator( const S : string) : string');
 CL.AddDelphiFunction('Function AnsiStringToString( const Text : AnsiString; CodePage : Cardinal) : TKkString');
 //CL.AddDelphiFunction('Function BinarySearch( AData : string; ACount : Integer; KeyPtr : string; ACompareProc : TBSCompareProc; ASortedDown : Boolean) : Integer');
 CL.AddDelphiFunction('Procedure CallTrackMouseEvent( Control : TWinControl; var Status : Boolean)');
 CL.AddDelphiFunction('Procedure CenterWindowInWindow( CenteredWnd, BoundWnd : HWnd)');
 CL.AddDelphiFunction('Procedure CenterWindowOnScreen( CenteredWnd : HWnd)');
 CL.AddDelphiFunction('Function CharInSetEx( AChar : AnsiChar; const ASet : TKSysCharSet) : Boolean;');
 CL.AddDelphiFunction('Function CharInSetEx1( AChar : WideChar; const ASet : TKSysCharSet) : Boolean;');
 CL.AddDelphiFunction('Function ClipboardLoadStreamAs( const AFormat : string; AStream : TStream; var AText : TKkString) : Boolean');
 CL.AddDelphiFunction('Function ClipboardSaveStreamAs( const AFormat : string; AStream : TStream; const AText : TKkString) : Boolean');
 CL.AddDelphiFunction('Function CompareIntegers( I1, I2 : Integer) : Integer');
 //CL.AddDelphiFunction('Function CompareWideChars( W1, W2 : PWideChar; Locale : Cardinal) : Integer');
// CL.AddDelphiFunction('Function CompareChars( S1, S2 : PChar; Locale : Cardinal) : Integer');
 CL.AddDelphiFunction('Function CompareWideStrings( W1, W2 : WideString; Locale : Cardinal) : Integer');
// CL.AddDelphiFunction('Function CompareStrings( S1, S2 : string; Locale : Cardinal) : Integer');
 CL.AddDelphiFunction('Procedure ConvertTabsToSpaces( var AText : TKkString; ASpacesForTab : Integer)');
 CL.AddDelphiFunction('Function CreateMultipleDir( const Dir : string) : Boolean');
 CL.AddDelphiFunction('Function DigitToNibble( Digit : AnsiChar; var Nibble : Byte) : Boolean');
 CL.AddDelphiFunction('Function DivUp( Dividend, Divisor : Integer) : Integer');
 CL.AddDelphiFunction('Function DivDown( Dividend, Divisor : Integer) : Integer');
 CL.AddDelphiFunction('Function EditIsFocused( AMustAllowWrite : Boolean) : Boolean');
 CL.AddDelphiFunction('Function EditFocusedTextCanCopy : Boolean');
 CL.AddDelphiFunction('Function EditFocusedTextCanCut : Boolean');
 CL.AddDelphiFunction('Function EditFocusedTextCanDelete : Boolean');
 CL.AddDelphiFunction('Function EditFocusedTextCanPaste : Boolean');
 CL.AddDelphiFunction('Function EditFocusedTextCanUndo : Boolean');
 CL.AddDelphiFunction('Procedure EditUndoFocused');
 CL.AddDelphiFunction('Procedure EditDeleteFocused');
 CL.AddDelphiFunction('Procedure EditCutFocused');
 CL.AddDelphiFunction('Procedure EditCopyFocused');
 CL.AddDelphiFunction('Procedure EditPasteFocused');
 CL.AddDelphiFunction('Procedure EditSelectAllFocused');
 CL.AddDelphiFunction('Procedure EnableControls2( AParent : TWinControl; AEnabled, ARecursive : Boolean)');
 CL.AddDelphiFunction('Procedure EnsureLastPathSlash( var APath : string)');
 CL.AddDelphiFunction('Procedure Error2( const Msg : string)');
 CL.AddDelphiFunction('Function FillMessage( Msg : Cardinal; WParam : WPARAM; LParam : LPARAM) : TLMessage');
 CL.AddDelphiFunction('Function FormatCurrency( Value : Currency; const AFormat : TKCurrencyFormat) : TKkString');
 //CL.AddDelphiFunction('Function GetAppContext( var Ctx : TKAppContext) : Boolean');
 CL.AddDelphiFunction('Function GetAppVersion( const ALibName : string; var MajorVersion, MinorVersion, BuildNumber, RevisionNumber : Word) : Boolean');
 CL.AddDelphiFunction('Function GetCharCount( const AText : TKkString; AChar : TKkChar) : Integer');
 CL.AddDelphiFunction('Function GetControlText( Value : TWinControl) : TKkString');
 CL.AddDelphiFunction('Function GetFormatSettings2 : TFormatSettings');
 CL.AddDelphiFunction('Function GetShiftState : TShiftState');
 CL.AddDelphiFunction('Function IntToAscii( Value : Int64; Digits : Integer) : string');
 CL.AddDelphiFunction('Function IntToBinStr( Value : Int64; Digits : Byte; const Suffix : string) : string');
 CL.AddDelphiFunction('Function IntToBCD( Value : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function IntToDecStr( Value : Int64) : string');
 CL.AddDelphiFunction('Function IntToHexStr( Value : Int64; Digits : Byte; const Prefix, Suffix : string; UseLowerCase : Boolean) : string');
 CL.AddDelphiFunction('Function IntToOctStr( Value : Int64) : string');
 CL.AddDelphiFunction('Function IntToRoman2( Value : Integer; AUpperCase : Boolean) : string');
 CL.AddDelphiFunction('Function IntToLatin( Value : Integer; AUpperCase : Boolean) : string');
 CL.AddDelphiFunction('Function IntPowerInt( Value : Int64; Exponent : Integer) : Int64');
 CL.AddDelphiFunction('Function AsciiToInt( S : string; Digits : Integer) : Int64');
 CL.AddDelphiFunction('Function BCDToInt( Value : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function BinStrToInt2( S : string; Digits : Byte; Signed : Boolean; var Code : Integer) : Int64');
 CL.AddDelphiFunction('Function DecStrToInt( S : string; var Code : Integer) : Int64');
 CL.AddDelphiFunction('Function HexStrToInt( S : string; Digits : Byte; Signed : Boolean; var Code : Integer) : Int64');
 CL.AddDelphiFunction('Function OctStrToInt( S : string; var Code : Integer) : Int64');
 CL.AddDelphiFunction('Function KFormat14( const Format : string; const Args : array of const; const AFormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function KFormat15( const Format : WideString; const Args : array of const; const AFormatSettings : TFormatSettings) : WideString;');
 CL.AddDelphiFunction('Function MakeCellSpan( AColumns, ARows : Integer) : TKCellSpan');
 CL.AddDelphiFunction('Function MinMax16( Value, Min, Max : ShortInt) : ShortInt;');
 CL.AddDelphiFunction('Function MinMax17( Value, Min, Max : SmallInt) : SmallInt;');
 CL.AddDelphiFunction('Function MinMax18( Value, Min, Max : Integer) : Integer;');
 CL.AddDelphiFunction('Function MinMax19( Value, Min, Max : Int64) : Int64;');
 CL.AddDelphiFunction('Function MinMax20( Value, Min, Max : Single) : Single;');
 CL.AddDelphiFunction('Function MinMax21( Value, Min, Max : Double) : Double;');
 CL.AddDelphiFunction('Function MinMax22( Value, Min, Max : Extended) : Extended;');
 CL.AddDelphiFunction('Function NibbleToDigit( Nibble : Byte; UpperCase : Boolean) : AnsiChar');
 CL.AddDelphiFunction('Procedure OpenURLWithShell( const AText : TKkString)');
 CL.AddDelphiFunction('Procedure OpenURL( const AText : TKkString)');
 CL.AddDelphiFunction('Procedure OpenWeb( const AText : TKkString)');
 CL.AddDelphiFunction('Procedure OpenBrowser( const AText : TKkString)');

 //CL.AddDelphiFunction('Procedure QuickSortNR( AData : Pointer; ACount : Integer; ACompareProc : TQsCompareProc; AExchangeProc : TQsExchangeProc; ASortedDown : Boolean)');
 //CL.AddDelphiFunction('Procedure QuickSort( AData : Pointer; ACount : Integer; ACompareProc : TQsCompareProc; AExchangeProc : TQsExchangeProc; ASortedDown : Boolean)');
 CL.AddDelphiFunction('Procedure OffsetPoint23( var APoint : TPoint; AX, AY : Integer);');
 CL.AddDelphiFunction('Procedure OffsetPoint24( var APoint : TPoint; const AOffset : TPoint);');
 CL.AddDelphiFunction('Function RectInRect( Bounds, Rect : TRect) : Boolean');
 CL.AddDelphiFunction('Procedure OffsetRect25( var ARect : TRect; AX, AY : Integer);');
 CL.AddDelphiFunction('Procedure OffsetRect26( var ARect : TRect; const AOffset : TPoint);');
 //CL.AddDelphiFunction('Function SetAppContext( const Ctx : TKAppContext) : Boolean');
 CL.AddDelphiFunction('Procedure SetControlClipRect( AControl : TWinControl; const ARect : TRect)');
 CL.AddDelphiFunction('Procedure SetControlText( Value : TWinControl; const Text : TKkString)');
 CL.AddDelphiFunction('Procedure StripLastPathSlash( var APath : string)');
 CL.AddDelphiFunction('Function StrNextCharIndex( const AText : TKkString; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function StrPreviousCharIndex( const AText : TKkString; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function StringCharBegin( const AText : TKkString; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function StringLength( const AText : TKkString) : Integer');
 CL.AddDelphiFunction('Function StringCopy( const ASource : TKkString; At, Count : Integer) : TKkString');
 CL.AddDelphiFunction('Procedure StringDelete( var ASource : TKkString; At, Count : Integer)');
 CL.AddDelphiFunction('Procedure TrimWhiteSpaces27( const AText : TKkString; var AStart, ALen : Integer; const ASet : TKSysCharSet);');
 CL.AddDelphiFunction('Procedure TrimWhiteSpaces28( var AText : TKkString; const ASet : TKSysCharSet);');
 CL.AddDelphiFunction('Procedure TrimWhiteSpaces29( var AText : AnsiString; const ASet : TKSysCharSet);');
 CL.AddDelphiFunction('Function StringToAnsiString( const AText : TKkString; CodePage : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function StringToChar( const AText : TKkString; AIndex : Integer) : TKkChar');
 CL.AddDelphiFunction('Function GetWindowsFolder2( CSIDL : Cardinal; var APath : string) : Boolean');
 CL.AddDelphiFunction('Function RunExecutable( const AFileName : string; AWaitForIt : Boolean) : DWORD');
 CL.AddDelphiFunction('Function SystemCodePage : Integer');
 CL.AddDelphiFunction('Function NativeUTFToUnicode( const AText : TKkString) : WideChar');
 CL.AddDelphiFunction('Function UnicodeUpperCase2( const AText : TKkString) : TKkString');
 CL.AddDelphiFunction('Function UnicodeLowerCase2( const AText : TKkString) : TKkString');
 CL.AddDelphiFunction('Function UnicodeToNativeUTF( const AParam : WideChar) : TKkString');
 CL.AddDelphiFunction('Function UnicodeStringReplace( const AText, AOldPattern, ANewPattern : TKkString; AFlags : TReplaceFlags) : TKkString');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TrimWhiteSpaces29_P( var AText : AnsiString; const ASet : TKSysCharSet);
Begin KFunctions.TrimWhiteSpaces(AText, ASet); END;

(*----------------------------------------------------------------------------*)
Procedure TrimWhiteSpaces28_P( var AText : TKString; const ASet : TKSysCharSet);
Begin KFunctions.TrimWhiteSpaces(AText, ASet); END;

(*----------------------------------------------------------------------------*)
Procedure TrimWhiteSpaces27_P( const AText : TKString; var AStart, ALen : Integer; const ASet : TKSysCharSet);
Begin KFunctions.TrimWhiteSpaces(AText, AStart, ALen, ASet); END;

(*----------------------------------------------------------------------------*)
Procedure OffsetRect26_P( var ARect : TRect; const AOffset : TPoint);
Begin KFunctions.OffsetRect(ARect, AOffset); END;

(*----------------------------------------------------------------------------*)
Procedure OffsetRect25_P( var ARect : TRect; AX, AY : Integer);
Begin KFunctions.OffsetRect(ARect, AX, AY); END;

(*----------------------------------------------------------------------------*)
Procedure OffsetPoint24_P( var APoint : TPoint; const AOffset : TPoint);
Begin KFunctions.OffsetPoint(APoint, AOffset); END;

(*----------------------------------------------------------------------------*)
Procedure OffsetPoint23_P( var APoint : TPoint; AX, AY : Integer);
Begin KFunctions.OffsetPoint(APoint, AX, AY); END;

(*----------------------------------------------------------------------------*)
Function MinMax22_P( Value, Min, Max : Extended) : Extended;
Begin Result := KFunctions.MinMax(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function MinMax21_P( Value, Min, Max : Double) : Double;
Begin Result := KFunctions.MinMax(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function MinMax20_P( Value, Min, Max : Single) : Single;
Begin Result := KFunctions.MinMax(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function MinMax19_P( Value, Min, Max : Int64) : Int64;
Begin Result := KFunctions.MinMax(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function MinMax18_P( Value, Min, Max : Integer) : Integer;
Begin Result := KFunctions.MinMax(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function MinMax17_P( Value, Min, Max : SmallInt) : SmallInt;
Begin Result := KFunctions.MinMax(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function MinMax16_P( Value, Min, Max : ShortInt) : ShortInt;
Begin Result := KFunctions.MinMax(Value, Min, Max); END;

(*----------------------------------------------------------------------------*)
Function KFormat15_P( const Format : WideString; const Args : array of const; const AFormatSettings : TFormatSettings) : WideString;
Begin Result := KFunctions.KFormat(Format, Args, AFormatSettings); END;

(*----------------------------------------------------------------------------*)
Function KFormat14_P( const Format : string; const Args : array of const; const AFormatSettings : TFormatSettings) : string;
Begin Result := KFunctions.KFormat(Format, Args, AFormatSettings); END;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
Function CharInSetEx1_P( AChar : WideChar; const ASet : TKSysCharSet) : Boolean;
Begin Result := KFunctions.CharInSetEx(AChar, ASet); END;

(*----------------------------------------------------------------------------*)
Function CharInSetEx0_P( AChar : AnsiChar; const ASet : TKSysCharSet) : Boolean;
Begin Result := KFunctions.CharInSetEx(AChar, ASet); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KFunctions_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AdjustDecimalSeparator, 'AdjustDecimalSeparator', cdRegister);
 S.RegisterDelphiFunction(@AnsiStringToString, 'AnsiStringToString', cdRegister);
 //S.RegisterDelphiFunction(@BinarySearch, 'BinarySearch', cdRegister);
 S.RegisterDelphiFunction(@CallTrackMouseEvent, 'CallTrackMouseEvent', cdRegister);
 S.RegisterDelphiFunction(@CenterWindowInWindow, 'CenterWindowInWindow', cdRegister);
 S.RegisterDelphiFunction(@CenterWindowOnScreen, 'CenterWindowOnScreen', cdRegister);
 S.RegisterDelphiFunction(@CharInSetEx0_P, 'CharInSetEx', cdRegister);
 S.RegisterDelphiFunction(@CharInSetEx1_P, 'CharInSetEx1', cdRegister);
 S.RegisterDelphiFunction(@ClipboardLoadStreamAs, 'ClipboardLoadStreamAs', cdRegister);
 S.RegisterDelphiFunction(@ClipboardSaveStreamAs, 'ClipboardSaveStreamAs', cdRegister);
 S.RegisterDelphiFunction(@CompareIntegers, 'CompareIntegers', cdRegister);
 //S.RegisterDelphiFunction(@CompareWideChars, 'CompareWideChars', cdRegister);
 //S.RegisterDelphiFunction(@CompareChars, 'CompareChars', cdRegister);
 S.RegisterDelphiFunction(@CompareWideStrings, 'CompareWideStrings', cdRegister);
 //S.RegisterDelphiFunction(@CompareStrings, 'CompareStrings', cdRegister);
 S.RegisterDelphiFunction(@ConvertTabsToSpaces, 'ConvertTabsToSpaces', cdRegister);
 S.RegisterDelphiFunction(@CreateMultipleDir, 'CreateMultipleDir', cdRegister);
 S.RegisterDelphiFunction(@DigitToNibble, 'DigitToNibble', cdRegister);
 S.RegisterDelphiFunction(@DivUp, 'DivUp', cdRegister);
 S.RegisterDelphiFunction(@DivDown, 'DivDown', cdRegister);
 S.RegisterDelphiFunction(@EditIsFocused, 'EditIsFocused', cdRegister);
 S.RegisterDelphiFunction(@EditFocusedTextCanCopy, 'EditFocusedTextCanCopy', cdRegister);
 S.RegisterDelphiFunction(@EditFocusedTextCanCut, 'EditFocusedTextCanCut', cdRegister);
 S.RegisterDelphiFunction(@EditFocusedTextCanDelete, 'EditFocusedTextCanDelete', cdRegister);
 S.RegisterDelphiFunction(@EditFocusedTextCanPaste, 'EditFocusedTextCanPaste', cdRegister);
 S.RegisterDelphiFunction(@EditFocusedTextCanUndo, 'EditFocusedTextCanUndo', cdRegister);
 S.RegisterDelphiFunction(@EditUndoFocused, 'EditUndoFocused', cdRegister);
 S.RegisterDelphiFunction(@EditDeleteFocused, 'EditDeleteFocused', cdRegister);
 S.RegisterDelphiFunction(@EditCutFocused, 'EditCutFocused', cdRegister);
 S.RegisterDelphiFunction(@EditCopyFocused, 'EditCopyFocused', cdRegister);
 S.RegisterDelphiFunction(@EditPasteFocused, 'EditPasteFocused', cdRegister);
 S.RegisterDelphiFunction(@EditSelectAllFocused, 'EditSelectAllFocused', cdRegister);
 S.RegisterDelphiFunction(@EnableControls, 'EnableControls2', cdRegister);
 S.RegisterDelphiFunction(@EnsureLastPathSlash, 'EnsureLastPathSlash', cdRegister);
 S.RegisterDelphiFunction(@Error, 'Error2', cdRegister);
 S.RegisterDelphiFunction(@FillMessage, 'FillMessage', cdRegister);
 S.RegisterDelphiFunction(@FormatCurrency, 'FormatCurrency', cdRegister);
 //S.RegisterDelphiFunction(@GetAppContext, 'GetAppContext', cdRegister);
 S.RegisterDelphiFunction(@GetAppVersion, 'GetAppVersion', cdRegister);
 S.RegisterDelphiFunction(@GetCharCount, 'GetCharCount', cdRegister);
 S.RegisterDelphiFunction(@GetControlText, 'GetControlText', cdRegister);
 S.RegisterDelphiFunction(@GetFormatSettings, 'GetFormatSettings2', cdRegister);
 S.RegisterDelphiFunction(@GetShiftState, 'GetShiftState', cdRegister);
 S.RegisterDelphiFunction(@IntToAscii, 'IntToAscii', cdRegister);
 S.RegisterDelphiFunction(@IntToBinStr, 'IntToBinStr', cdRegister);
 S.RegisterDelphiFunction(@IntToBCD, 'IntToBCD', cdRegister);
 S.RegisterDelphiFunction(@IntToDecStr, 'IntToDecStr', cdRegister);
 S.RegisterDelphiFunction(@IntToHexStr, 'IntToHexStr', cdRegister);
 S.RegisterDelphiFunction(@IntToOctStr, 'IntToOctStr', cdRegister);
 S.RegisterDelphiFunction(@IntToRoman, 'IntToRoman2', cdRegister);
 S.RegisterDelphiFunction(@IntToLatin, 'IntToLatin', cdRegister);
 S.RegisterDelphiFunction(@IntPowerInt, 'IntPowerInt', cdRegister);
 S.RegisterDelphiFunction(@AsciiToInt, 'AsciiToInt', cdRegister);
 S.RegisterDelphiFunction(@BCDToInt, 'BCDToInt', cdRegister);
 S.RegisterDelphiFunction(@BinStrToInt, 'BinStrToInt2', cdRegister);
 S.RegisterDelphiFunction(@DecStrToInt, 'DecStrToInt', cdRegister);
 S.RegisterDelphiFunction(@HexStrToInt, 'HexStrToInt', cdRegister);
 S.RegisterDelphiFunction(@OctStrToInt, 'OctStrToInt', cdRegister);
 S.RegisterDelphiFunction(@KFormat14_P, 'KFormat14', cdRegister);
 S.RegisterDelphiFunction(@KFormat15_P, 'KFormat15', cdRegister);
 S.RegisterDelphiFunction(@MakeCellSpan, 'MakeCellSpan', cdRegister);
 S.RegisterDelphiFunction(@MinMax16_P, 'MinMax16', cdRegister);
 S.RegisterDelphiFunction(@MinMax17_P, 'MinMax17', cdRegister);
 S.RegisterDelphiFunction(@MinMax18_P, 'MinMax18', cdRegister);
 S.RegisterDelphiFunction(@MinMax19_P, 'MinMax19', cdRegister);
 S.RegisterDelphiFunction(@MinMax20_P, 'MinMax20', cdRegister);
 S.RegisterDelphiFunction(@MinMax21_P, 'MinMax21', cdRegister);
 S.RegisterDelphiFunction(@MinMax22_P, 'MinMax22', cdRegister);
 S.RegisterDelphiFunction(@NibbleToDigit, 'NibbleToDigit', cdRegister);
 S.RegisterDelphiFunction(@OpenURLWithShell, 'OpenURLWithShell', cdRegister);
 S.RegisterDelphiFunction(@OpenURLWithShell, 'OpenURL', cdRegister);
 S.RegisterDelphiFunction(@OpenURLWithShell, 'OpenWeb', cdRegister);
 S.RegisterDelphiFunction(@OpenURLWithShell, 'OpenBrowser', cdRegister);

 //S.RegisterDelphiFunction(@QuickSortNR, 'QuickSortNR', cdRegister);
 //S.RegisterDelphiFunction(@QuickSort, 'QuickSort', cdRegister);
 S.RegisterDelphiFunction(@OffsetPoint23_P, 'OffsetPoint23', cdRegister);
 S.RegisterDelphiFunction(@OffsetPoint24_P, 'OffsetPoint24', cdRegister);
 S.RegisterDelphiFunction(@RectInRect, 'RectInRect', cdRegister);
 S.RegisterDelphiFunction(@OffsetRect25_P, 'OffsetRect25', cdRegister);
 S.RegisterDelphiFunction(@OffsetRect26_P, 'OffsetRect26', cdRegister);
 //S.RegisterDelphiFunction(@SetAppContext, 'SetAppContext', cdRegister);
 S.RegisterDelphiFunction(@SetControlClipRect, 'SetControlClipRect', cdRegister);
 S.RegisterDelphiFunction(@SetControlText, 'SetControlText', cdRegister);
 S.RegisterDelphiFunction(@StripLastPathSlash, 'StripLastPathSlash', cdRegister);
 S.RegisterDelphiFunction(@StrNextCharIndex, 'StrNextCharIndex', cdRegister);
 S.RegisterDelphiFunction(@StrPreviousCharIndex, 'StrPreviousCharIndex', cdRegister);
 S.RegisterDelphiFunction(@StringCharBegin, 'StringCharBegin', cdRegister);
 S.RegisterDelphiFunction(@StringLength, 'StringLength', cdRegister);
 S.RegisterDelphiFunction(@StringCopy, 'StringCopy', cdRegister);
 S.RegisterDelphiFunction(@StringDelete, 'StringDelete', cdRegister);
 S.RegisterDelphiFunction(@TrimWhiteSpaces27_P, 'TrimWhiteSpaces27', cdRegister);
 S.RegisterDelphiFunction(@TrimWhiteSpaces28_P, 'TrimWhiteSpaces28', cdRegister);
 S.RegisterDelphiFunction(@TrimWhiteSpaces29_P, 'TrimWhiteSpaces29', cdRegister);
 S.RegisterDelphiFunction(@StringToAnsiString, 'StringToAnsiString', cdRegister);
 S.RegisterDelphiFunction(@StringToChar, 'StringToChar', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsFolder, 'GetWindowsFolder2', cdRegister);
 S.RegisterDelphiFunction(@RunExecutable, 'RunExecutable', cdRegister);
 S.RegisterDelphiFunction(@SystemCodePage, 'SystemCodePage', cdRegister);
 S.RegisterDelphiFunction(@NativeUTFToUnicode, 'NativeUTFToUnicode', cdRegister);
 S.RegisterDelphiFunction(@UnicodeUpperCase, 'UnicodeUpperCase2', cdRegister);
 S.RegisterDelphiFunction(@UnicodeLowerCase, 'UnicodeLowerCase2', cdRegister);
 S.RegisterDelphiFunction(@UnicodeToNativeUTF, 'UnicodeToNativeUTF', cdRegister);
 S.RegisterDelphiFunction(@UnicodeStringReplace, 'UnicodeStringReplace', cdRegister);
end;



{ TPSImport_KFunctions }
(*----------------------------------------------------------------------------*)
procedure TPSImport_KFunctions.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_KFunctions(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_KFunctions.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_KFunctions_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
