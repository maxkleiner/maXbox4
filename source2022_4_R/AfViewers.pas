{==============================================================================|
| Project : Delphree - AsyncFree                                 | 001.004.000 |
|==============================================================================|
| Content:  Line Viewer and Terminal component                                 |
|==============================================================================|
| The contents of this file are subject to the Mozilla Public License Ver. 1.0 |
| (the "License"); you may not use this file except in compliance with the     |
| License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ |
|                                                                              |
| Software distributed under the License is distributed on an "AS IS" basis,   |
| WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for |
| the specific language governing rights and limitations under the License.    |
|==============================================================================|
| The Original Code is AsyncFree Library.                                      |
|==============================================================================|
| The Initial Developer of the Original Code is Petr Vones (Czech Republic).   |
| Portions created by Petr Vones are Copyright (C) 1998, 1999.                 |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| History:                                                                     |
|   see AfRegister.pas                                                         |
|==============================================================================}

unit AfViewers;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Clipbrd;

const
  AfCLVMaxLineLength = 1024;
  UM_UPDATELINECOUNT = WM_USER + $100;

type
  TAfFontStyleCache = class(TObject)
  private
    FFonts: array[0..15] of HFont;
  public
    destructor Destroy; override;
    procedure Clear;
    function GetFont(Style: TFontStyles): HFont;
    function Recreate(Font: TFont): Boolean;
  end;

  EAfCLVException = class(Exception);

  TAfCLVCaretType = (ctVertical, ctHorizontal, ctBlock);
  TAfCLVCharAttr = packed record
    BColor, FColor: TColor;
    Style: TFontStyles;
  end;
  TAfCLVCharColors = array[0..AfCLVMaxLineLength] of TAfCLVCharAttr;
  PAfCLVCharColors = ^TAfCLVCharColors;
  TAfCLVColorMode = (cmDefault, cmLine, cmChars, cmCheckLength);
  TAfCLVFocusSource = (fsKey, fsMouse, fsHScroll, fsVScroll);
  TAfCLVLineState = (lsNormal, lsFocused, lsSelected);
  TAfCLVOptions = set of (
    loCanSelect,
    loSelectByShift,
    loDrawFocusSelect,
    loThumbTracking,
    loScrollToRowCursor, loScrollToColCursor,
    loShowLineCursor, loShowCaretCursor, 
    loTabs);
  TAfCLVLeftSpace = 0..MaxInt;
  TAfCLVMaxLineLength = 1..AfCLVMaxLineLength;
  TAfCLVCaretBlinkTime = 1..MaxInt;

  TAfCLVCursorEvent = procedure (Sender: TObject; CursorPos: TPoint) of object;

  TAfCLVDrawLeftSpEvent = procedure (Sender: TObject; const Line, LeftCharPos: Integer;
    Rect: TRect; State: TAfCLVLineState) of object;

  TAfCLVGetTextEvent = procedure (Sender: TObject; Line: Integer; var Text: String;
    var ColorMode: TAfCLVColorMode; var CharColors: TAfCLVCharColors) of object;

  TAfCustomLineViewer = class(TCustomControl)
  private
    FBorderStyle: TBorderStyle;
    FCaretBlinkTime: TAfCLVCaretBlinkTime;
    FCaretCreated, FCaretShown: Boolean;
    FCaretType: TAfCLVCaretType;
    FCaretOffset: TPoint;
    FCharWidth, FCharHeight: Integer;
    FFocusedPoint: TPoint;
    FNeedUpdate: Boolean;
    FInternalFocused: Boolean;
    FInternalUseFontCache: Boolean;
    FLeftSpace: TAfCLVLeftSpace;
    FLineCount: Integer;
    FLockCursorChange, FNotifyCursorChange: Boolean;
    FMaxLineLength: TAfCLVMaxLineLength;
    FOnBof, FOnEof: TNotifyEvent;
    FSelStart, FSelEnd, FSelAnchor: TPoint;
    FSelectedColor, FSelectedTextColor: TColor;
    FSelectedStyle: TFontStyles;
    FTimerScrolling: Boolean;
    FTopLeft: TPoint;
    FUseFontCache: Boolean;
    FUseScroll: Boolean;
    FUsedFontStyles: TFontStyles;
    FVisibleArea, FVisibleNonIntegralArea: TPoint;
    FMouseDown: Boolean;
    FOptions: TAfCLVOptions;
    FOnCursorChange: TAfCLVCursorEvent;
    FOnDrawLeftSpace: TAfCLVDrawLeftSpEvent;
    FOnFontChanged: TNotifyEvent;
    FOnGetText: TAfCLVGetTextEvent;
    FOnLeftSpaceMouseDown: TMouseEvent;
    FOnSelectionChange: TNotifyEvent;
    SaveCaretBlinkTime: Integer;
    procedure AdjustScrollBarsSize;
    procedure CalcSizeParam;
    procedure DestroyCaret;
    procedure FocusByMouse(X, Y: Integer; Select: Boolean);
    procedure FocusControlRequest;
    procedure FreeColorArray;
    function GetSelectedText: String;
    function IsLeftOut(var Value: Longint): Boolean;
    function IsTopOut(var Value: Longint): Boolean;
    procedure MakeCaret;
    procedure RecreateCaret;
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetCaretBlinkTime(Value: TAfCLVCaretBlinkTime);
    procedure SetCaretType(Value: TAfCLVCaretType);
    procedure SetFocusedPoint(Value: TPoint);
    procedure SetFocusedPointX(Value: Longint);
    procedure SetFocusedPointY(Value: Longint);
    procedure SetFocusedAndSelect(NewFocus: TPoint; Select: Boolean);
    procedure SetLeftSpace(Value: TAfCLVLeftSpace);
    procedure SetLineCount(Value: Integer);
    procedure SetMaxLineLength(Value: TAfCLVMaxLineLength);
    procedure SetNeedUpdate(Value: Boolean);
    procedure SetOptions(Value: TAfCLVOptions);
    procedure SetSelectedColor(Value: TColor);
    procedure SetSelectedTextColor(Value: TColor);
    procedure SetSelectedStyle(const Value: TFontStyles);
    procedure SetTimerScrolling(const Value: Boolean);
    procedure SetTopLeft(Value: TPoint);
    procedure SetTopLeftX(Value: Longint);
    procedure SetTopLeftY(Value: Longint);
    procedure SetUseFontCache(const Value: Boolean);
    procedure SetUsedFontStyles(const Value: TFontStyles);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMDestroy(var Message: TWMDestroy); message WM_DESTROY;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  protected
    FCharColors: PAfCLVCharColors;
    FFontCache: TAfFontStyleCache;
    FTextMetric: TTextMetric;
    function CalcCharPointPos(P: TPoint; CharsOffset: Integer): TPoint;
    function CreateCaret: Boolean; virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DoBof; dynamic;
    procedure DoCursorChange;
    procedure DoEnter; override;
    procedure DoEof; dynamic;
    procedure DoExit; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DoSelectionChange; dynamic;
    procedure DrawLeftSpace(LineNumber: Integer; Rect: TRect; State: TAfCLVLineState); virtual;
    procedure DrawLine(LineNumber: Integer; Rect: TRect; State: TAfCLVLineState); virtual;
    function FocusRequest(FocusSource: TAfCLVFocusSource): Boolean; virtual;
    function GetText(LineNumber: Integer; var ColorMode: TAfCLVColorMode;
      var CharColors: TAfCLVCharColors): String; virtual;
    procedure HideCaret;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function LineLength(LineNumber: Integer): Integer;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure ReallocColorArray;
    procedure SetName(const NewName: TComponentName); override;
    procedure ShowCaret;
    procedure ScrollByX(ColumnsMoved: Integer);
    procedure ScrollByY(LinesMoved: Integer);
    function ScrollIntoViewX: Boolean; virtual;
    function ScrollIntoViewY: Boolean; virtual;
    function SetCaretPos(Position: TPoint): Boolean;
    procedure SetCaret;
    procedure UpdateLineViewer; dynamic;
    procedure UpdateScrollPos; dynamic;
    function ValidTextRect: TRect;
    function VertScrollBarSize: Integer; dynamic;
    function VertScrollBarFromThumb(ThumbPos: Integer): Integer; dynamic;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property CaretBlinkTime: TAfCLVCaretBlinkTime read FCaretBlinkTime write SetCaretBlinkTime;
    property CaretCreated: Boolean read FCaretCreated;
    property CaretType: TAfCLVCaretType read FCaretType write SetCaretType default ctVertical;
    property FocusedPoint: TPoint read FFocusedPoint write SetFocusedPoint;
    property FocusedPointX: Longint read FFocusedPoint.X write SetFocusedPointX;
    property FocusedPointY: Longint read FFocusedPoint.Y write SetFocusedPointY;
    property LeftSpace: TAfCLVLeftSpace read FLeftSpace write SetLeftSpace default 0;
    property LineCount: Integer read FLineCount write SetLineCount default 1;
    property MaxLineLength: TAfCLVMaxLineLength read FMaxLineLength write SetMaxLineLength default 80;
    property NeedUpdate: Boolean read FNeedUpdate write SetNeedUpdate;
    property Options: TAfCLVOptions read FOptions write SetOptions;
    property SelectedText: String read GetSelectedText;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clHighlight;
    property SelectedTextColor: TColor read FSelectedTextColor write SetSelectedTextColor default clHighlightText;
    property SelectedStyle: TFontStyles read FSelectedStyle write SetSelectedStyle default [];
    property SelStart: TPoint read FSelStart;
    property SelEnd: TPoint read FSelEnd;
    property TimerScrolling: Boolean read FTimerScrolling write SetTimerScrolling;
    property TopLeft: TPoint read FTopLeft write SetTopLeft;
    property TopLeftX: Longint read FTopLeft.X write SetTopLeftX;
    property TopLeftY: Longint read FTopLeft.Y write SetTopLeftY;
    property UseScroll: Boolean read FUseScroll write FUseScroll default True;
    property UseFontCache: Boolean read FUseFontCache write SetUseFontCache default False;
    property UsedFontStyles: TFontStyles read FUsedFontStyles write SetUsedFontStyles default [];
    property OnBof: TNotifyEvent read FOnBof write FOnBof;
    property OnCursorChange: TAfCLVCursorEvent read FOnCursorChange write FOnCursorChange;
    property OnDrawLeftSpace: TAfCLVDrawLeftSpEvent read FOnDrawLeftSpace write FOnDrawLeftSpace;
    property OnEof: TNotifyEvent read FOnEof write FOnEof;
    property OnFontChanged: TNotifyEvent read FOnFontChanged write FOnFontChanged;
    property OnGetText: TAfCLVGetTextEvent read FOnGetText write FOnGetText;
    property OnLeftSpaceMouseDown: TMouseEvent read FOnLeftSpaceMouseDown write FOnLeftSpaceMouseDown;
    property OnSelectionChange: TNotifyEvent read FOnSelectionChange write FOnSelectionChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearSelection;
    procedure CopyToClipboard;
    procedure DrawToCanvas(DrawCanvas: TCanvas; StartLine, EndLine: Integer; Rect: TRect);
    procedure DrawLineToCanvas(DrawCanvas: TCanvas; LineNumber: Integer; Rect: TRect; TextMetric: TTextMetric);
    procedure InvalidateDataRect(R: TRect; FullLine: Boolean);
    procedure InvalidateFocusedLine;
    procedure InvalidateLeftSpace(StartLine, EndLine: Integer);
    function IsSelectionEmpty: Boolean;
    function MouseToPoint(X, Y: Integer): TPoint;
    procedure ScrollIntoView;
    procedure SelectAll;
    procedure SelectArea(Old, New: TPoint);
    function TextFromRange(const ASelStart, ASelEnd: TPoint): string;
    procedure UnselectArea;
    property CharHeight: Integer read FCharHeight;
    property CharWidth: Integer read FCharWidth;
  published
    property TabStop default True;
  end;

  TAfLineViewer = class(TAfCustomLineViewer)
  public
    property Canvas;
    property FocusedPoint;
    property SelectedText;
    property SelStart;
    property SelEnd;
    property TopLeft;
    property UseScroll;
  published
    property Align;
    property BorderStyle;
    property CaretBlinkTime;
    property CaretType;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property LeftSpace;
    property LineCount;
    property MaxLineLength;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property SelectedStyle;
    property SelectedColor;
    property SelectedTextColor;
    property ShowHint;
    property TabOrder;
    property UseFontCache;
    property UsedFontStyles;
    property Visible;
    property OnBof;
    property OnCursorChange;
    property OnDblClick;
    property OnDrawLeftSpace;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnEof;
    property OnExit;
    property OnFontChanged;
    property OnGetText;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnLeftSpaceMouseDown;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnSelectionChange;
    property OnStartDrag;
  end;

  TAfTRMCharColor = 0..15;
  TAfTRMCharAttr = packed record  // barva znaku z tabulky - 16barev
    FColor, BColor: TAfTRMCharColor;
  end;
  PAfTRMCharAttrs = ^TAfTRMCharAttrs;
  TAfTRMCharAttrs = array[0..AfCLVMaxLineLength] of TAfTRMCharAttr;
  TAfTRMColorMode = (cmLDefault, cmL16_16, cmC16_16);
  TAfTRMColorTable = array[TAfTRMCharColor] of TColor; // Tabulka prevodu 16ti barev na RGB
  TAfTRMLogging = (lgOff, lgCreate, lgAppend);
  TAfTRMBkSpcMode = (bmBack, bmBackDel);
  TAfTRMLogSize = 1..MaxInt;
  TAfTRMLogFlushTime = 1..MaxInt;

  TAfTRMGetColorsEvent = procedure (Sender: TObject; Line: Integer; var Colors: TAfTRMCharAttrs) of object;

  TAfTRMLineEvent = procedure (Sender:TObject; Line: Integer) of object;

  TAfTRMProcessCharEvent = procedure (Sender: TObject; var C: Char) of object; // #0 -> nezapise znak

  TAfTRMScrBckBufChange = procedure (Sender: TObject; BufferSize: Integer) of object;

  TAfCustomTerminal = class;

  TAfFileStream = class(THandleStream)
  public
    constructor Create(const FileName: string; Mode: Word);
    destructor Destroy; override;
    procedure FlushBuffers;
  end;

  TAfTerminalBuffer = class(TObject)
  private
    BufHead, BufTail: Integer;
    FBuffer: TMemoryStream;
    FCols, FRows: Integer;
    FColorDataSize: Integer; // Velikost radku bufferu pro informaci o barvach
    FColorMode: TAfTRMColorMode;
    FDefaultTermColor: TAfTRMCharAttr;
    FLastCharPtr: PChar;
    FTerminal: TAfCustomTerminal;
    FUserDataSize: Integer;
    LinesAdded: Integer;
    NeedDraw: Boolean;
    NeedGetColors: Boolean;
    function CalcLinePos(Line: Integer): Integer;
    procedure ClearBufferLines(FromLine, ToLine: Integer);
    procedure FindDefaultTermColors;
    function FindTermColor(Color: TColor): Integer;
    procedure FreeBuffer;
    procedure IncBufVar(var Value: Integer);
    function LastCharPtr: PChar;
    procedure NextChar;
    procedure NextLine;
    function Ptr_Colors(LineNumber: Integer): Pointer;
    function Ptr_Text(LineNumber: Integer): Pointer;
    function Ptr_UserData(LineNumber: Integer): Pointer;
  public
    FCharColorsArray: PAfTRMCharAttrs;
    FColorTable: TAfTRMColorTable;
    FTopestLineForUpdateColor: Integer;
    EndBufPos, LastBufPos, MaxInvalidate: TPoint;
    constructor Create(ATerminal: TAfCustomTerminal);
    destructor Destroy; override;
    procedure ClearBuffer;
    procedure DrawChangedBuffer;
    function GetBuffColorsForDraw(LineNumber: Integer): PAfCLVCharColors;
    function GetBuffLine(LineNumber: Integer): String;
    procedure GetLineColors(LineNumber: Integer; var Colors: TAfTRMCharAttrs);
    procedure ReallocBuffer(Rows: Integer; Cols: Byte; ColorMode: TAfTRMColorMode;
      UserDataSize: Integer);
    procedure SetLineColors(LineNumber: Integer; var Colors: TAfTRMCharAttrs);
    procedure WriteChar(C: Char);
    procedure WriteColorChar(C: Char; TermColor: TAfTRMCharAttr);
    procedure WriteStr(const S: String);
  end;

  TAfCustomTerminal = class(TAfCustomLineViewer)
  private
    FAutoScrollBack: Boolean;
    FBkSpcMode: TAfTRMBkSpcMode;
    FCanScrollX: Boolean;
    FDisplayCols: Byte;
    FLogging: TAfTRMLogging;
    FLogFlushTime: TAfTRMLogFlushTime;
    FLogName: String;
    FLogSize: TAfTRMLogSize;
    FScrollBackCaret, FTerminalCaret: TAfCLVCaretType;
    FScrollBackKey: TShortCut;
    FScrollBackRows: Integer;
    FScrollBackMode: Boolean;
    FTermBuffer: TAfTerminalBuffer;
    FTermColorMode: TAfTRMColorMode;
    FUserDataSize: Integer;
    FOnBeepChar: TNotifyEvent;
    FOnDrawBuffer: TNotifyEvent;
    FOnFlushLog: TNotifyEvent;
    FOnGetColors: TAfTRMGetColorsEvent;
    FOnLoggingChange: TNotifyEvent;
    FOptions: TAfCLVOptions;
    FOnNewLine: TAfTRMLineEvent;
    FOnProcessChar: TAfTRMProcessCharEvent;
    FOnScrBckBufChange: TAfTRMScrBckBufChange;
    FOnScrBckModeChange: TNotifyEvent;
    FOnSendChar: TKeyPressEvent;
    FOnUserDataChange: TAfTRMLineEvent;
    LogFileStream: TAfFileStream;
    LogMemStream: TMemoryStream;
    ScrollBackString: String;
    procedure InternalWriteChar(C: Char);
    procedure InternalWriteColorChar(C: Char; TermColor: TAfTRMCharAttr);
    function GetBufferLine(Index: Integer): String;
    function GetBufferLineNumber: Integer;
    function GetColorTable: TAfTRMColorTable;
    function GetRelLineColors(Index: Integer): TAfTRMCharAttrs;
    function GetTermColor(Color: TColor): Integer;
    function GetUserData(Index: Integer): Pointer;
    procedure SetColorTable(Value: TAfTRMColorTable);
    procedure SetDisplayCols(Value: Byte);
    procedure SetLogging(Value: TAfTRMLogging);
    procedure SetLogName(const Value: String);
    procedure SetOptions(Value: TAfCLVOptions);
    procedure SetRelLineColors(Index: Integer; Value: TAfTRMCharAttrs);
    procedure SetScrollBackCaret(Value: TAfCLVCaretType);
    procedure SetScrollBackMode(Value: Boolean);
    procedure SetScrollBackRows(Value: Integer);
    procedure SetTerminalCaret(Value: TAfCLVCaretType);
    procedure SetTermColorMode(Value: TAfTRMColorMode);
    procedure SetTermModeCaret;
    procedure SetUserData(Index: Integer; Value: Pointer);
    procedure SetUserDataSize(Value: Integer);
    procedure StartLogging;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMDestroy(var Message: TWMDestroy); message WM_DESTROY;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  protected
   { procedure CloseLogFile;
    procedure DoBeepChar;
    procedure DoDrawBuffer;
    procedure DoEof; override;
    procedure DoLoggingChange; dynamic;
    procedure DoScrBckBufChange;
    procedure FlushLogBuffer;
    procedure FocusEndOfBuffer(ScrollToCursor: Boolean);
    function FocusRequest(FocusSource: TAfCLVFocusSource): Boolean; override;
    procedure GetColorsForThisLine; }
    function GetText(LineNumber: Integer; var ColorMode: TAfCLVColorMode;
      var CharColors: TAfCLVCharColors): String; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
   // procedure OpenLogFile;
    //procedure WriteToLog(const S: String);
    function ScrollIntoViewX: Boolean; override;
    property AutoScrollBack: Boolean read FAutoScrollBack write FAutoScrollBack default True;
    property BkSpcMode: TAfTRMBkSpcMode read FBkSpcMode write FBkSpcMode default bmBackDel;
    property BufferLine[Index: Integer]: String read GetBufferLine;
    property BufferLineNumber: Integer read GetBufferLineNumber;
    property ColorTable: TAfTRMColorTable read GetColorTable write SetColorTable stored False;
    property DisplayCols: Byte read FDisplayCols write SetDisplayCols default 80;
    property Logging: TAfTRMLogging read FLogging write SetLogging default lgOff;
    property LogFlushTime: TAfTRMLogFlushTime read FLogFlushTime write FLogFlushTime default 5000;
    property LogName: String read FLogName write SetLogName;
    property LogSize: TAfTRMLogSize read FLogSize write FLogSize default 16384;
    property Options: TAfCLVOptions read FOptions write SetOptions;
    property RelLineColors[Index: Integer]: TAfTRMCharAttrs read GetRelLineColors write SetRelLineColors;
    property ScrollBackCaret: TAfCLVCaretType read FScrollBackCaret write SetScrollBackCaret default ctBlock;
    property ScrollBackKey: TShortCut read FScrollBackKey write FScrollBackKey default scNone;
    property ScrollBackRows: Integer read FScrollBackRows write SetScrollBackRows default 500;
    property ScrollBackMode: Boolean read FScrollBackMode write SetScrollBackMode stored False;
    property TerminalCaret: TAfCLVCaretType read FTerminalCaret write SetTerminalCaret default ctHorizontal;
    property TermColor[Color: TColor]: Integer read GetTermColor;
    property TermColorMode: TAfTRMColorMode read FTermColorMode write SetTermColorMode default cmLDefault;
    property UserData[Index: Integer]: Pointer read GetUserData write SetUserData;
    property UserDataSize: Integer read FUserDataSize write SetUserDataSize default 0;
    property OnBeepChar: TNotifyEvent read FOnBeepChar write FOnBeepChar;
    property OnDrawBuffer: TNotifyEvent read FOnDrawBuffer write FOnDrawBuffer;
    property OnFlushLog: TNotifyEvent read FOnFlushLog write FOnFlushLog;
    property OnGetColors: TAfTRMGetColorsEvent read FOnGetColors write FOnGetColors;
    property OnLoggingChange: TNotifyEvent read FOnLoggingChange write FOnLoggingChange;
    property OnNewLine: TAfTRMLineEvent read FOnNewLine write FOnNewLine;
    property OnProcessChar: TAfTRMProcessCharEvent read FOnProcessChar write FOnProcessChar;
    property OnScrBckBufChange: TAfTRMScrBckBufChange read FOnScrBckBufChange write FOnScrBckBufChange;
    property OnScrBckModeChange: TNotifyEvent read FOnScrBckModeChange write FOnScrBckModeChange;
    property OnSendChar: TKeyPressEvent read FOnSendChar write FOnSendChar;
    property OnUserDataChange: TAfTRMLineEvent read FOnUserDataChange write FOnUserDataChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearBuffer;
    function DefaultTermColor: TAfTRMCharAttr;
    procedure DrawChangedBuffer;
    procedure WriteChar(C: Char); // musi by ukoncen volanim DrawChangedBuffer !
    procedure WriteColorChar(C: Char; BColor, FColor: TAfTRMCharColor); // musi by ukoncen volanim DrawChangedBuffer !
    procedure WriteColorStringAndData(const S: String; BColor, FColor: TAfTRMCharColor;
      UserDataItem: Pointer);
    procedure WriteString(const S: String);
      procedure CloseLogFile;
    procedure DoBeepChar;
    procedure DoDrawBuffer;
    procedure DoEof; override;
    procedure DoLoggingChange; dynamic;
    procedure DoScrBckBufChange;
    procedure FlushLogBuffer;
    procedure FocusEndOfBuffer(ScrollToCursor: Boolean);
    function FocusRequest(FocusSource: TAfCLVFocusSource): Boolean; override;
    procedure GetColorsForThisLine;
     procedure OpenLogFile;
    procedure WriteToLog(const S: String);
  end;

  TAfTerminal = class(TAfCustomTerminal)
  public
    property BufferLine;
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
    property UseScroll;
  published
    property Align;
    property DisplayCols;
    property AutoScrollBack;
    property BkSpcMode;
    property BorderStyle;
    property CaretBlinkTime;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property LeftSpace;
    property Logging;
    property LogFlushTime;
    property LogName;
    property LogSize;
    property MaxLineLength;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property SelectedColor;
    property SelectedStyle;
    property SelectedTextColor;
    property ScrollBackCaret;
    property ScrollBackKey;
    property ScrollBackRows;
    property ShowHint;
    property TabOrder;
    property TerminalCaret;
    property TermColorMode;
    property UserDataSize;
    property Visible;
    property OnBeepChar;
    property OnBof;
    property OnCursorChange;
    property OnDblClick;
    property OnDrawBuffer;
    property OnDrawLeftSpace;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnEof;
    property OnExit;
    property OnFlushLog;
    property OnFontChanged;
    property OnGetColors;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnLeftSpaceMouseDown;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnNewLine;
    property OnProcessChar;
    property OnScrBckBufChange;
    property OnScrBckModeChange;
    property OnSelectionChange;
    property OnSendChar;
    property OnStartDrag;
    property OnUserDataChange;
  end;

  TAfCVFScanStep = 1..MaxInt;

  TAfCustomFileViewer = class(TAfCustomLineViewer)
  private
    FFileBase, FFileEnd, FFileMapView: PChar;
    FFileName: String;
    FFileSize: DWORD;
    FFileHandle: THandle;
    FFileMapping: THandle;
    FScanBlockStep: TAfCVFScanStep;
    FScanPosition: Integer;
    FUseThreadScan: Boolean;
    FOnScanBlock: TNotifyEvent;
    CountThreadID: DWORD;
    CountThreadHandle: THandle;
    LastLine: Integer;
    LastPtr: PChar;
    ThreadParam: Pointer;
    procedure CloseFileMapping;
    procedure CountLines;
    procedure SetFileName(const Value: String);
    procedure StartCountThread;
    procedure StopCountThread;
    procedure UpdateLineCount(ALineCount, AScanPos: Integer);
    procedure UMUpdateLineCount(var Message: TMessage); message UM_UPDATELINECOUNT;
  protected
    function GetText(LineNumber: Integer; var ColorMode: TAfCLVColorMode;
      var CharColors: TAfCLVCharColors): String; override;
    property FileName: String read FFileName write SetFileName;
    property ScanBlockStep: TAfCVFScanStep read FScanBlockStep write FScanBlockStep default 2000;
    property UseThreadScan: Boolean read FUseThreadScan write FUseThreadScan default True;
    property OnScanBlock: TNotifyEvent read FOnScanBlock write FOnScanBlock;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CloseFile;
    function FilePtrFromLine(Line: Integer): PChar;
    procedure OpenFile;
    procedure OpenData(const TextBuf: PChar; const TextSize: Integer);
    property FileSize: DWORD read FFileSize;
    property ScanPosition: Integer read FScanPosition;
  end;

  TAfFileViewer = class(TAfCustomFileViewer)
  public
    property Canvas;
    property FileName;
    property FocusedPoint;
    property LineCount;
    property SelectedText;
    property SelStart;
    property SelEnd;
    property TopLeft;
    property UseScroll;
  published
    property Align;
    property BorderStyle;
    property CaretBlinkTime;
    property CaretType;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property LeftSpace;
    property MaxLineLength;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ScanBlockStep;
    property SelectedStyle;
    property SelectedColor;
    property SelectedTextColor;
    property ShowHint;
    property TabOrder;
    property UseFontCache;
    property UseThreadScan;
    property UsedFontStyles;
    property Visible;
    property OnBof;
    property OnCursorChange;
    property OnDblClick;
    property OnDrawLeftSpace;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnEof;
    property OnExit;
    property OnFontChanged;
    property OnGetText;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnLeftSpaceMouseDown;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnScanBlock;
    property OnSelectionChange;
    property OnStartDrag;
  end;


const
  PvTRMDefaultColorTable: TAfTRMColorTable =
  (clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal,
   clGray, clSilver, clRed, clLime, clYellow, clBlue, clFuchsia,
   clAqua, clWhite);

var
  PvLineViewerScrollTime: Integer = 50;

procedure Register;

implementation

uses
  AfUtils;

procedure Register;
begin
  RegisterComponents('AsyncFree', [TAfLineViewer, TAfFileViewer, TAfTerminal]);
end;

{$IFDEF VER90}
const
{$ELSE}
resourcestring
{$ENDIF}
  sErrorTermColor = 'TermColorMode must be set to cmC16_16';
  sColorNotFound = 'Color not found in color table';
  sCantOpenLogFile = 'Unable to open log file';
  sFSCreateError = 'Can''t create/open log file';
  sCantOpenFile = 'Can''t open file "%s"';
  sMappingFailed = 'File mapping failed';

type
  TBytesArray = packed array[0..0] of Byte;

const
  MaxSmallInt = High(SmallInt);
  fmAfCreate = $1002;
  TimerIDScroll = 1;
  TimerIDFlush  = 2;

  DefaultViewerOptions =
    [loShowLineCursor, loSelectByShift, loThumbTracking, loDrawFocusSelect,
    loScrollToRowCursor, loScrollToColCursor];

  DefaultTerminalOptions =
    [loThumbTracking, loSelectByShift, loShowCaretCursor, loCanSelect,
    loScrollToRowCursor];

function ComparePoint(P1, P2: TPoint): Integer;
begin
  if P1.Y < P2.Y then Result := -1 else
    if P1.Y > P2.Y then Result := 1 else
      if P1.X < P2.X then Result := -1 else
        if P1.X > P2.X then Result := 1 else
          Result := 0;
end;

{ TAfFontStyleCache }

procedure TAfFontStyleCache.Clear;
var
  I: Integer;
begin
  for I := Low(FFonts) to High(FFonts) do
    if FFonts[I] <> 0 then DeleteObject(FFonts[I]);
  FillChar(FFonts, Sizeof(FFonts), 0);   
end;

destructor TAfFontStyleCache.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TAfFontStyleCache.GetFont(Style: TFontStyles): HFont;
begin
  Result := FFonts[Byte(Style) and $0F];
end;

function TAfFontStyleCache.Recreate(Font: TFont): Boolean;
var
  I: Byte;
  LogFont: TLogFont;
  Style: TFontStyles;
begin
  Clear;
  Result := True;
  GetObject(Font.Handle, Sizeof(LogFont), @LogFont);
  for I := Low(FFonts) to High(FFonts) do
  begin
    Style := TFontStyles(I);
    with LogFont do
    begin
      if fsBold in Style then
        lfWeight := FW_BOLD
      else
        lfWeight := FW_NORMAL;
      lfItalic := Byte(fsItalic in Style);
      lfUnderline := Byte(fsUnderline in Style);
      lfStrikeOut := Byte(fsStrikeOut in Style);
    end;
    FFonts[I] := CreateFontIndirect(LogFont);
    if FFonts[I] = 0 then
    begin
      Result := False;
      Break;
    end;  
  end;
end;

{ TAfCustomLineViewer }

constructor TAfCustomLineViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFontCache := TAfFontStyleCache.Create;
  FBorderStyle := bsSingle;
  FCaretCreated := False;
  FCaretBlinkTime := Windows.GetCaretBlinkTime;
  FCaretOffset := Point(0, 0);
  FCaretShown := False;
  FCaretType := ctVertical;
  FFocusedPoint := Point(0, 0);
  ClearSelection;
  FSelectedColor := clHighlight;
  FSelectedStyle := [];
  FSelectedTextColor := clHighlightText;
  FInternalFocused := False;
  FLeftSpace := 0;
  FLineCount := 1;
  FMaxLineLength := 80;
  FOptions := DefaultViewerOptions;
  FUseFontCache := False;
  FInternalUseFontCache := False;
  FUseScroll := True;
  FUsedFontStyles := [];
  Color := clWindow;
  ParentColor := False;
  Font.Name := 'Courier';
  Font.Size := 10;
  Font.Pitch := fpFixed;
  ParentFont := False;
  ControlStyle := [csCaptureMouse, csDoubleClicks, csOpaque];
  TabStop := True;
  SetBounds(Left, Top, 300, 200);
  ReallocColorArray;
end;

destructor TAfCustomLineViewer.Destroy;
begin
  FreeColorArray;
  FFontCache.Free;
  inherited Destroy;
end;

procedure TAfCustomLineViewer.AdjustScrollBarsSize;
var
  SI: TScrollInfo;
begin
  if not HandleAllocated then Exit;
  with SI do
  begin
    cbSize := Sizeof(SI);
    fMask := SIF_DISABLENOSCROLL or SIF_RANGE or SIF_PAGE;
    nMin := 0;
    nMax := MaxSmallInt;
    nPage := LongMulDiv(FVisibleArea.Y, MaxSmallInt, VertScrollBarSize);
    SetScrollInfo(Handle, SB_VERT, SI, True);
    nMax := FMaxLineLength - 1;
    nPage := FVisibleArea.X;
    SetScrollInfo(Handle, SB_HORZ, SI, True);
  end;
end;

function TAfCustomLineViewer.CalcCharPointPos(P: TPoint; CharsOffset: Integer): TPoint;
var
  I, L: Integer;
begin
  Result := P;
  L := FMaxLineLength - 1;
  if CharsOffset > 0 then
  begin
    for I := 1 to CharsOffset do
    begin
      Inc(Result.X);
      if Result.X > L - 1 then
      begin
        if Result.Y < LineCount - 1 then
        begin
          Inc(Result.Y);
          L := LineLength(Result.Y);
          Result.X := 0;
        end else
        begin
          Dec(Result.X);
          Break;
        end;
      end;
    end;
  end else
  if CharsOffset < 0 then
  begin
    for I := CharsOffset to -1 do
    begin
      Dec(Result.X);
      if Result.X < 0 then
      begin
        if Result.Y > 0 then
        begin
          Dec(Result.Y);
          Result.X := L;
        end else
        begin
          Result.X := 0;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TAfCustomLineViewer.CalcSizeParam;
var
  MeasureStyle: TFontStyles;
begin
  if (not HandleAllocated) or (csLoading in ComponentState) then Exit;
  Canvas.Font.Assign(Font);
  MeasureStyle := TFontStyles(Byte(Byte(Font.Style) or Byte(FUsedFontStyles)));
  Canvas.Font.Style := MeasureStyle;
  GetTextMetrics(Canvas.Handle, FTextMetric);
  FCharHeight := FTextMetric.tmHeight + FTextMetric.tmExternalLeading;
  FCharWidth := FTextMetric.tmAveCharWidth;
  Canvas.Font.Style := Font.Style;
  FVisibleArea.X := (ClientWidth - FLeftSpace) div FCharWidth;
  FVisibleArea.Y := ClientHeight div FCharHeight;
  FVisibleNonIntegralArea.X := FVisibleArea.X;
  FVisibleNonIntegralArea.Y := FVisibleArea.Y;
  if (ClientWidth - FLeftSpace) mod FCharWidth > 0 then
    Inc(FVisibleNonIntegralArea.X);
  if ClientHeight mod FCharHeight > 0 then
    Inc(FVisibleNonIntegralArea.Y);
end;

procedure TAfCustomLineViewer.ClearSelection;
begin
  FSelStart.X := -1;
  FSelStart.Y := -1;
  FSelEnd.X := -1;
  FSelEnd.Y := -1;
  FSelAnchor.X := -1;
  FSelAnchor.Y := -1;
end;

procedure TAfCustomLineViewer.CopyToClipboard;
begin
  Screen.Cursor := crHourGlass;
  try
    Clipboard.AsText := SelectedText;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TAfCustomLineViewer.CreateCaret: Boolean;
begin
  SaveCaretBlinkTime := Windows.GetCaretBlinkTime;
  Windows.SetCaretBlinkTime(FCaretBlinkTime);
  case FCaretType of
    ctVertical:
      begin
        Result := Windows.CreateCaret(Handle, 0, 2, FCharHeight);
        FCaretOffset := Point(0, 0);
      end;
    ctHorizontal:
      begin
        Result := Windows.CreateCaret(Handle, 0, FCharWidth, 2);
        FCaretOffset := Point(0, FCharHeight - 2);
      end;
    ctBlock:
      begin
        Result := Windows.CreateCaret(Handle, 0, FCharWidth, FCharHeight);
        FCaretOffset := Point(0, 0);
      end;
  else
    Result := False;
  end;
end;

procedure TAfCustomLineViewer.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
    Style := Style or WS_VSCROLL or WS_HSCROLL;
    if FBorderStyle = bsSingle then
      if NewStyleControls and Ctl3D then
      begin
        Style := Style and not WS_BORDER;
        ExStyle := ExStyle or WS_EX_CLIENTEDGE;
      end
      else
        Style := Style or WS_BORDER;
  end;
end;

procedure TAfCustomLineViewer.CreateWnd;
begin
  inherited;
  CalcSizeParam;
end;

procedure TAfCustomLineViewer.DestroyCaret;
begin
  if FCaretCreated then
  begin
    HideCaret;
    Windows.SetCaretBlinkTime(SaveCaretBlinkTime);
    Windows.DestroyCaret;
    FCaretCreated := False;
  end;
end;

procedure TAfCustomLineViewer.DoBof;
begin
  if Assigned(FOnBof) then FOnBof(Self);
end;

procedure TAfCustomLineViewer.DoCursorChange;
begin
  if FLockCursorChange then
    FNotifyCursorChange := True
  else
  begin
    FNotifyCursorChange := False;
    if Assigned(FOnCursorChange) then FOnCursorChange(Self, FFocusedPoint);
  end;
end;

procedure TAfCustomLineViewer.DoEnter;
begin
  inherited DoEnter;
  FInternalFocused := True;
  InvalidateFocusedLine;
end;

procedure TAfCustomLineViewer.DoEof;
begin
  if Assigned(FOnEof) then FOnEof(Self);
end;

procedure TAfCustomLineViewer.DoExit;
begin
  inherited DoExit;
  FInternalFocused := False;
  InvalidateFocusedLine;
end;

procedure TAfCustomLineViewer.DoSelectionChange;
begin
  if Assigned(FOnSelectionChange) then FOnSelectionChange(Self);
end;

procedure TAfCustomLineViewer.DrawLeftSpace(LineNumber: Integer; Rect: TRect; State: TAfCLVLineState);
begin
  if Assigned(FOnDrawLeftSpace) then
    FOnDrawLeftSpace(Self, LineNumber, FFocusedPoint.X, Rect, State)
  else
  with Canvas do
  begin
    Brush.Color := Self.Color;
    FillRect(Rect);
  end;
end;

procedure TAfCustomLineViewer.DrawLine(LineNumber: Integer; Rect: TRect; State: TAfCLVLineState);
var
  S: String;
  ColorMode: TAfCLVColorMode;
  DC: HDC;
  SaveDCIndex: Integer;
  WhiteSpaceRect, CharsRect: TRect;
  RightEndText: Integer;
  LastFontStyle: TFontStyles;
  Spacing: Pointer;

  procedure ChangeDCFontStyle(ST: TFontStyles);
begin
  if FInternalUseFontCache then
    SelectObject(DC, FFontCache.GetFont(ST))
  else
  begin
    if ST <> LastFontStyle then
    begin
      LastFontStyle := ST;
      Canvas.Font.Style := ST;
      DC := Canvas.Handle;
    end;
  end;
end;

  procedure DrawWholeLine(FC, BC: TColor; ST: TFontStyles);
begin
  ChangeDCFontStyle(ST);
  SetBkColor(DC, ColorToRGB(BC));
  SetTextColor(DC, ColorToRGB(FC));
  ExtTextOut(DC, CharsRect.Left, CharsRect.Bottom - FTextMetric.tmDescent,
    ETO_CLIPPED or ETO_OPAQUE, @CharsRect, PChar(S), Length(S), Spacing);
end;

  procedure DrawCharsLine;
var
  CharPos, EndCharPos, StartSel, EndSel, BlockNumChars: Integer;
  LastColor, CharColor: TAfCLVCharAttr;
  P: PChar;
  LS: String;

    function ColorForCharPos: TAfCLVCharAttr;
begin
  if (CharPos >= StartSel) and (CharPos <= EndSel) then
  begin
    Result.FColor := Self.FSelectedTextColor;
    Result.BColor := Self.FSelectedColor;
    Result.Style := Self.FSelectedStyle;
  end else
  case ColorMode of
    cmDefault:
      begin
        Result.FColor := Self.Font.Color;
        Result.BColor := Self.Color;
        Result.Style := Self.Font.Style;
      end;
    cmLine:
      Result := FCharColors^[0];
    cmChars:
      Result := FCharColors^[CharPos];
  end;
end;

begin
  if State = lsSelected then
  begin
    if FSelStart.Y = LineNumber then StartSel := FSelStart.X else
      StartSel := 0;
    if FSelEnd.Y = LineNumber then EndSel := FSelEnd.X else
      EndSel := MaxLineLength - 1;
  end else
  begin
    StartSel := -1;
    EndSel := -1;
  end;
  BlockNumChars := 0;
  CharPos := FTopLeft.X;
  EndCharPos := FTopLeft.X + FVisibleArea.X;
  if EndCharPos > FMaxLineLength - 1 then EndCharPos := FMaxLineLength - 1;
  LastColor := ColorForCharPos;
  CharsRect.Right := CharsRect.Left;
  SetLength(LS, FMaxLineLength);
  FillChar(Pointer(LS)^, FMaxLineLength, #32);
  if Length(S) > 0 then Move(S[1], LS[1], Length(S));
  P := PChar(LS);
  repeat
    Inc(CharPos);
    Inc(BlockNumChars);
    Inc(CharsRect.Right, FCharWidth);
    CharColor := ColorForCharPos;
    if (CharColor.FColor <> LastColor.FColor) or (CharColor.BColor <> LastColor.BColor) or
      (CharColor.Style <> LastColor.Style) or (CharPos > EndCharPos) then
    begin
      ChangeDCFontStyle(LastColor.Style);
      SetBkColor(DC, ColorToRGB(LastColor.BColor));
      SetTextColor(DC, ColorToRGB(LastColor.FColor));
      ExtTextOut(DC, CharsRect.Left, CharsRect.Bottom - FTextMetric.tmDescent,
        ETO_CLIPPED or ETO_OPAQUE, @CharsRect, P, BlockNumChars, Spacing);
      Inc(P, BlockNumChars);
      BlockNumChars := 0;
      LastColor := CharColor;
      CharsRect.Left := CharsRect.Right;
    end;
  until CharPos > EndCharPos;
end;

begin
  with Canvas do
  begin
    GetMem(Spacing, FVisibleNonIntegralArea.X * Sizeof(Integer));
    FillInteger(Spacing^, FVisibleNonIntegralArea.X, FCharWidth);
    SetLength(S, MaxLineLength);
    S := Copy(GetText(LineNumber, ColorMode, FCharColors^), FTopLeft.X + 1, FVisibleNonIntegralArea.X);
    Font := Self.Font;
    LastFontStyle := Canvas.Font.Style;
    DC := Canvas.Handle;
    SaveDCIndex := SaveDC(DC);
    SetTextAlign(DC, TA_LEFT or TA_BASELINE or TA_NOUPDATECP);
    CharsRect := Rect;
    WhiteSpaceRect := Rect;
    RightEndText := CharsRect.Left + FCharWidth * (FMaxLineLength - FTopLeft.X);
    if RightEndText < ClientWidth then
    begin
      CharsRect.Right := RightEndText;
      WhiteSpaceRect.Left := RightEndText;
    end else WhiteSpaceRect.Right := 0;
    case State of
      lsNormal:
        begin
          case ColorMode of
            cmDefault:
              DrawWholeLine(Font.Color, Color, Font.Style);
            cmLine:
              DrawWholeLine(FCharColors[0].FColor, FCharColors[0].BColor, FCharColors[0].Style);
            cmChars:
              DrawCharsLine;
          end;
          if WhiteSpaceRect.Right > 0 then
          begin
            Brush.Color := Self.Color;
            FillRect(WhiteSpaceRect);
          end;
        end;
      lsFocused:
        begin
          DrawWholeLine(FSelectedTextColor, FSelectedColor, Font.Style);
          if WhiteSpaceRect.Right > 0 then
          begin
            Brush.Color := FSelectedColor;
            FillRect(WhiteSpaceRect);
          end;
          if FInternalFocused and (loDrawFocusSelect in FOptions) then
            DrawFocusRect(Rect);
        end;
      lsSelected:
        begin
          if (loDrawFocusSelect in FOptions) then
          begin
            DrawWholeLine(FSelectedTextColor, FSelectedColor, FSelectedStyle);
            Brush.Color := FSelectedColor;
          end else
          begin
            DrawCharsLine;
            Brush.Color := Self.Color;
          end;
          if WhiteSpaceRect.Right > 0 then FillRect(WhiteSpaceRect);
        end;
    end;
    RestoreDC(DC, SaveDCIndex);
    FreeMem(Spacing);
  end;
end;

procedure TAfCustomLineViewer.DrawToCanvas(DrawCanvas: TCanvas; StartLine, EndLine: Integer; Rect: TRect);
var
  I: Integer;
  LineRect: TRect;
  TextMetric: TTextMetric;
begin
  GetTextMetrics(Canvas.Handle, TextMetric);
  LineRect := Rect;
  LineRect.Bottom := LineRect.Top + TextMetric.tmHeight;
  for I := StartLine to EndLine do
  begin
    DrawLineToCanvas(DrawCanvas, I, LineRect, TextMetric);
    OffsetRect(LineRect, 0, TextMetric.tmHeight);
    if LineRect.Bottom > Rect.Bottom then Break;
  end;
end;

procedure TAfCustomLineViewer.DrawLineToCanvas(DrawCanvas: TCanvas;
  LineNumber: Integer; Rect: TRect; TextMetric: TTextMetric);
var
  S: String;
  ColorMode: TAfCLVColorMode;
  DC: HDC;
  CharsRect: TRect;
  Spacing: Pointer;
  VisibleChars: Integer;

  procedure DrawWholeLine(FC, BC: TColor);
begin
  SetTextAlign(DC, TA_LEFT or TA_BASELINE or TA_NOUPDATECP);
  SetBkColor(DC, ColorToRGB(BC));
  SetTextColor(DC, ColorToRGB(FC));
  ExtTextOut(DC, CharsRect.Left, CharsRect.Bottom - TextMetric.tmDescent,
    ETO_CLIPPED or ETO_OPAQUE, @CharsRect, PChar(S), Length(S), Spacing);
end;

  procedure DrawCharsLine;
var
  CharPos, EndCharPos, BlockNumChars: Integer;
  LastColor, CharColor: TAfCLVCharAttr;
  P: PChar;
  LS: String;
begin
  BlockNumChars := 0;
  CharPos := 0;
  EndCharPos := FMaxLineLength - 1;
  LastColor := FCharColors^[CharPos];
  CharsRect.Right := CharsRect.Left;
  SetLength(LS, FMaxLineLength);
  FillChar(Pointer(LS)^, FMaxLineLength, #32);
  Move(S[1], LS[1], Length(S));
  P := PChar(LS);
  SetTextAlign(DC, TA_LEFT or TA_BASELINE or TA_NOUPDATECP);
  repeat
    Inc(CharPos);
    Inc(BlockNumChars);
    Inc(CharsRect.Right, TextMetric.tmAveCharWidth);
    CharColor := FCharColors^[CharPos];
    if (CharColor.FColor <> LastColor.FColor) or (CharColor.BColor <> LastColor.BColor) or
      (CharColor.Style <> LastColor.Style) or (CharPos > EndCharPos) then
    begin
      SetBkColor(DC, ColorToRGB(LastColor.BColor));
      SetTextColor(DC, ColorToRGB(LastColor.FColor));
      ExtTextOut(DC, CharsRect.Left, CharsRect.Bottom - TextMetric.tmDescent,
        ETO_CLIPPED or ETO_OPAQUE, @CharsRect, P, BlockNumChars, Spacing);
      Inc(P, BlockNumChars);
      BlockNumChars := 0;
      LastColor := CharColor;
      CharsRect.Left := CharsRect.Right;
    end;
  until (CharPos > EndCharPos) or (CharsRect.Right > Rect.Right);
end;

begin
  VisibleChars := (Rect.Right - Rect.Left) div TextMetric.tmAveCharWidth;
  GetMem(Spacing, VisibleChars * Sizeof(Integer));
  try
    FillInteger(Spacing^, VisibleChars, TextMetric.tmAveCharWidth);
    DC := DrawCanvas.Handle;
    GetTextMetrics(DC, TextMetric);
    S := GetText(LineNumber, ColorMode, FCharColors^);
    CharsRect := Rect;
    case ColorMode of
      cmDefault:
        DrawWholeLine(Font.Color, Color);
      cmLine:
        DrawWholeLine(FCharColors[0].Fcolor, FCharColors[0].Bcolor);
      cmChars:
        DrawCharsLine;
     end;
   finally
     FreeMem(Spacing);
   end;  
end;

procedure TAfCustomLineViewer.FocusByMouse(X, Y: Integer; Select: Boolean);
begin
  if FMouseDown then
    SetFocusedAndSelect(MouseToPoint(X, Y), Select);
end;

procedure TAfCustomLineViewer.FocusControlRequest;
begin
  if Visible and CanFocus and TabStop and not (csDesigning in ComponentState) then
    SetFocus;
end;

function TAfCustomLineViewer.FocusRequest(FocusSource: TAfCLVFocusSource): Boolean;
begin
  Result := True;
end;

procedure TAfCustomLineViewer.FreeColorArray;
begin
  if FCharColors <> nil then FreeMem(FCharColors, FMaxLineLength * Sizeof(TAfCLVCharAttr));
end;

function TAfCustomLineViewer.GetSelectedText: String;
var
  ColorMode: TAfCLVColorMode;
begin
  Result := '';
  if IsSelectionEmpty then
  begin
    if loShowLineCursor in FOptions then
      Result := GetText(FFocusedPoint.Y, ColorMode, FCharColors^);
  end
  else
    Result := TextFromRange(FSelStart, FSelEnd);
end;

function TAfCustomLineViewer.GetText(LineNumber: Integer;
  var ColorMode: TAfCLVColorMode; var CharColors: TAfCLVCharColors): String;
begin
  ColorMode := cmDefault;
  if Assigned(FOnGetText) then
  begin
    FillChar(CharColors, FMaxLineLength * Sizeof(TAfCLVCharAttr), 0);
    FOnGetText(Self, LineNumber, Result, ColorMode, CharColors);
  end else
    Result := Format('%s - Line %d', [Self.Name, LineNumber]);
end;

procedure TAfCustomLineViewer.HideCaret;
begin
  if FCaretCreated and FCaretShown then
  begin
    Windows.HideCaret(Handle);
    FCaretShown := False;
  end;
end;

function TAfCustomLineViewer.IsLeftOut(var Value: Longint): Boolean;
begin
  Result := True;
  if Value < 0 then Value := 0 else
    if Value + FVisibleArea.X >= FMaxLineLength then
    begin
      Value := FMaxLineLength - FVisibleArea.X;
      if Value < 0 then Value := 0;
    end else
      Result := False;
end;

function TAfCustomLineViewer.IsSelectionEmpty: Boolean;
begin
  Result := FSelStart.X = -1;
end;

function TAfCustomLineViewer.IsTopOut(var Value: Longint): Boolean;
begin
  Result := True;
  if Value < 0 then Value := 0 else
    if Value + FVisibleArea.Y >= FLineCount then
    begin
      Value := FLineCount - FVisibleArea.Y;
      if Value < 0 then Value := 0;
    end else
      Result := False;
end;

procedure TAfCustomLineViewer.InvalidateDataRect(R: TRect; FullLine: Boolean);
var
  VisibleDataRect, X: TRect;
begin
  if not HandleAllocated then Exit;
  if FullLine then
  begin
    R.Left := 0;
    R.Right := FMaxLineLength - 1;
  end;
  Inc(R.Right);
  Inc(R.Bottom);
  VisibleDataRect := Bounds(FTopLeft.X, FTopLeft.Y, FVisibleArea.X, FVisibleArea.Y);
  if IntersectRect(X, R, VisibleDataRect) then
  begin
    OffsetRect(R, -FTopLeft.X, -FTopLeft.Y);
    if FullLine then
    begin
      R.Left := FLeftSpace;
      R.Right := ClientWidth;
    end else
    begin
      R.Left := R.Left * FCharWidth + FLeftSpace;
      R.Right := R.Right * FCharWidth + FLeftSpace;
    end;
    R.Top := R.Top * FCharHeight;
    R.Bottom := R.Bottom * FCharHeight;
//    if R.Bottom > ClientHeight then R.Bottom := ClientHeight;
    IntersectRect(R, R, ClientRect);
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TAfCustomLineViewer.InvalidateFocusedLine;
begin
  if not (HandleAllocated and (loShowLineCursor in FOptions)) then Exit;
  InvalidateDataRect(Rect(0, FFocusedPoint.Y, 0, FFocusedPoint.Y), True);
end;

procedure TAfCustomLineViewer.InvalidateLeftSpace(StartLine, EndLine: Integer);
var
  R: TRect;
begin
  if (FLeftSpace > 0) and HandleAllocated then
  begin
    Dec(StartLine, FTopLeft.Y);
    Dec(EndLine, FTopLeft.Y);
    Inc(EndLine);
    R := Rect(0, StartLine * FCharHeight, FLeftSpace, EndLine * FCharHeight);
    IntersectRect(R, R, ClientRect);
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TAfCustomLineViewer.KeyDown(var Key: Word; Shift: TShiftState);
const
  FocusKeys = [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME, VK_END, VK_PRIOR, VK_NEXT];
var
  NewFocus: TPoint;
begin
  inherited KeyDown(Key, Shift);
  if (not (Key in FocusKeys)) or (not FocusRequest(fsKey)) then Exit;
  NewFocus := FFocusedPoint;
  if ssCtrl in Shift then
  begin
    case Key of
      VK_HOME:
        if loShowLineCursor in FOptions then
          NewFocus.Y := 0 else
            NewFocus := Point(0, 0);
      VK_END:
        if loShowLineCursor in FOptions then
          NewFocus.Y := (FLineCount - 1) else
            NewFocus := (Point(LineLength(FLineCount - 1), FLineCount - 1));
    end;
  end else
  begin
    case Key of
      VK_HOME:
        NewFocus.X := 0;
      VK_END:
        NewFocus.X := (LineLength(FFocusedPoint.Y));
      VK_DOWN:
        if (FFocusedPoint.Y = FLineCount - 1) and not (ssShift in Shift) then
        begin
          DoEof;
          Exit;
        end else
          NewFocus.Y := (FFocusedPoint.Y + 1);
      VK_UP:
        if (FFocusedPoint.Y = 0) and not (ssShift in Shift) then
        begin
          DoBof;
          Exit;
        end else
          NewFocus.Y := (FFocusedPoint.Y - 1);
      VK_NEXT:
        NewFocus.Y := (FFocusedPoint.Y + FVisibleArea.Y);
      VK_PRIOR:
        NewFocus.Y := (FFocusedPoint.Y - FVisibleArea.Y);
      VK_LEFT:
        if loShowLineCursor in FOptions then
          SetTopLeftX(FTopLeft.X - 1) else
            NewFocus.X := (FFocusedPoint.X - 1);
      VK_RIGHT:
        if loShowLineCursor in FOptions then
          SetTopLeftX(FTopLeft.X + 1) else
            NewFocus.X := (FFocusedPoint.X + 1);
    end;
  end;
  SetFocusedAndSelect(NewFocus, ssShift in Shift);
  UpdateLineViewer;
end;

function TAfCustomLineViewer.LineLength(LineNumber: Integer): Integer;
var
  ColorMode: TAfCLVColorMode;
begin
  ColorMode := cmCheckLength;
  Result := Length(TrimRight(GetText(LineNumber, ColorMode, FCharColors^)));
end;

procedure TAfCustomLineViewer.Loaded;
begin
  inherited Loaded;
  CalcSizeParam;
end;

procedure TAfCustomLineViewer.MakeCaret;
begin
  if Focused and (not FCaretCreated) and not (csDesigning in ComponentState) then FCaretCreated := CreateCaret;
  SetCaret;
end;

procedure TAfCustomLineViewer.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not (csDesigning in ComponentState) and CanFocus then
  begin
    SetFocus;
    if (Button = mbLeft) and (X >= FLeftSpace) and FocusRequest(fsMouse) then
    begin
      FMouseDown := True;
      FocusByMouse(X, Y, ((loSelectByShift in FOptions) and (ssShift in Shift)));
    end;
    if Assigned(FOnLeftSpaceMouseDown) and (X >= 0) and (X < FLeftSpace) then
      FOnLeftSpaceMouseDown(Self, Button, Shift, X, Y);
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TAfCustomLineViewer.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FMouseDown then
  begin
    if not PtInRect(ValidTextRect, Point(X, Y)) then
    begin
      TimerScrolling := True;
    end else
    begin
      TimerScrolling := False;
      FocusByMouse(X, Y, ((loSelectByShift in FOptions) and (ssShift in Shift))
        or (not (loSelectByShift in FOptions)) );
    end;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TAfCustomLineViewer.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KillTimer(Handle, TimerIDScroll);
  FMouseDown := False;
  inherited MouseUp(Button, Shift, X, Y);
end;

function TAfCustomLineViewer.MouseToPoint(X, Y: Integer): TPoint;
begin
  if X < FLeftSpace then Result.X := -1 else
    Result.X := FTopLeft.X + (X - FLeftSpace) div FCharWidth;
  Result.Y := FTopLeft.Y + Y div FCharHeight;
end;

procedure TAfCustomLineViewer.Paint;
var
  UpdateRect: TRect;
  LineRect, SpaceRect, R: TRect;
  I, LineNumber: Integer;
  State: TAfCLVLineState;
begin
  UpdateRect := Canvas.ClipRect;
  LineRect := Rect(FLeftSpace, 0, ClientWidth, FCharHeight);
  SpaceRect := Rect(0, 0, FLeftSpace, FCharHeight);
  Canvas.Brush.Color := Self.Color;
  Canvas.Font := Self.Font;
  for I := 0 to FVisibleNonIntegralArea.Y - 1 do
  begin
    LineNumber := I + FTopLeft.Y;
    if LineNumber < FLineCount then
    begin
      if (LineNumber = FFocusedPoint.Y) and (loShowLineCursor in FOptions) then State := lsFocused else
        if (LineNumber >= FSelStart.Y) and (LineNumber <= FSelEnd.Y) then
          State := lsSelected else
            State := lsNormal;
      if IntersectRect(R, LineRect, UpdateRect) then
        DrawLine(LineNumber, LineRect, State);
      if (FLeftSpace > 0) and IntersectRect(R, SpaceRect, UpdateRect) then
        DrawLeftSpace(LineNumber, SpaceRect, State);
    end else
    with Canvas do
    begin
      Brush.Color := Self.Color;
      FillRect(LineRect);
      DrawLeftSpace(-1, SpaceRect, lsNormal);
    end;
    OffsetRect(LineRect, 0, FCharHeight);
    OffsetRect(SpaceRect, 0, FCharHeight);
  end;
end;

procedure TAfCustomLineViewer.ReallocColorArray;
begin
  GetMem(FCharColors, FMaxLineLength * Sizeof(TAfCLVCharAttr));
end;

procedure TAfCustomLineViewer.RecreateCaret;
begin
  DestroyCaret;
  MakeCaret;
end;

procedure TAfCustomLineViewer.ScrollByX(ColumnsMoved: Integer);
var
  R: TRect;
begin
  if FUseScroll and (Abs(ColumnsMoved) < FVisibleArea.X div 2) then
  begin
    R := Rect(FLeftSpace, 0, ClientWidth - FCharWidth * Abs(ColumnsMoved), ClientHeight);
    if ColumnsMoved < 1 then OffsetRect(R, FCharWidth * Abs(ColumnsMoved), 0);
    ScrollWindowEx(Handle, FCharWidth * ColumnsMoved, 0, @R, nil, 0, nil, SW_INVALIDATE);
    InvalidateFocusedLine;
  end else InvalidateRect(Handle, nil, False);
end;

procedure TAfCustomLineViewer.ScrollByY(LinesMoved: Integer);
var
  R: TRect;
begin
  if FUseScroll and (Abs(LinesMoved) < FVisibleArea.Y div 2) then
  begin
    R := Rect(0, 0, ClientWidth, ClientHeight - FCharHeight * Abs(LinesMoved));
    if LinesMoved < 1 then OffsetRect(R, 0, FCharHeight * Abs(LinesMoved));
    ScrollWindowEx(Handle, 0, FCharHeight * LinesMoved, @R, nil, 0, nil, SW_INVALIDATE);
  end else InvalidateRect(Handle, nil, False);
end;

procedure TAfCustomLineViewer.ScrollIntoView;
begin
  ScrollIntoViewX;
  ScrollIntoViewY;
end;

function TAfCustomLineViewer.ScrollIntoViewX: Boolean;
begin
  Result := True;
  if FFocusedPoint.X < FTopLeft.X then
    SetTopLeftX(FFocusedPoint.X) else
    if FFocusedPoint.X >= (FTopLeft.X + FVisibleArea.X) then
      SetTopLeftX(FFocusedPoint.X - (FVisibleArea.X - 1)) else
        Result := False;
end;

function TAfCustomLineViewer.ScrollIntoViewY: Boolean;
begin
  Result := True;
  if FFocusedPoint.Y < FTopLeft.Y then
    SetTopLeftY(FFocusedPoint.Y) else
    if FFocusedPoint.Y >= (FTopLeft.Y + FVisibleArea.Y) then
      SetTopLeftY(FFocusedPoint.Y - (FVisibleArea.Y - 1)) else
        Result := False;
end;

procedure TAfCustomLineViewer.SelectArea(Old, New: TPoint);

  procedure InvalidateChange(NewV, OldV: TPoint);
var
  D: Integer;
  UpdateRect: TRect;
begin
  D := ComparePoint(OldV, NewV);
  if D < 0 then
  begin
    UpdateRect.TopLeft := OldV;
    UpdateRect.BottomRight := NewV;
  end else if D > 0 then
  begin
    UpdateRect.TopLeft := NewV;
    UpdateRect.BottomRight := OldV;
  end;
  if D <> 0 then InvalidateDataRect(UpdateRect, UpdateRect.Top <> UpdateRect.Bottom);
end;

  procedure SetSelStart(Value: TPoint);
begin
  if (loShowLineCursor in FOptions) then Value.X := 0;
  InvalidateChange(Value, FSelStart);
  FSelStart := Value;
end;

  procedure SetSelEnd(Value: TPoint);
var
  Temp: TPoint;
begin
  if (loShowLineCursor in FOptions) then Value.X := FMaxLineLength - 1;
  if (ComparePoint(Value, Point(FMaxLineLength - 1, FLineCount - 1)) = 0) or
    (loShowLineCursor in FOptions) then
    Temp := Value else
      Temp := CalcCharPointPos(Value, -1);
  InvalidateChange(Temp, FSelEnd);
  FSelEnd := Temp;
end;

begin
  if not (loCanSelect in FOptions) or CompareMem(@Old, @New, Sizeof(TPoint)) then Exit;
//  HideCaret;
  if New.X < 0 then New.X := 0 else
    if New.X >= FMaxLineLength then New.X := FMaxLineLength - 1;
  if New.Y < 0 then New.Y := 0 else
    if New.Y >= FLineCount then New.Y := FLineCount - 1;
  if IsSelectionEmpty then
  begin
    FSelStart := Old;
    FSelEnd := New;
    FSelAnchor := Old;
    InvalidateChange(New, Old);
  end;
  begin
    case ComparePoint(New, FSelAnchor) of
      1: begin
           SetSelEnd(New);
           SetSelStart(FSelAnchor);
         end;
      0: begin
           InvalidateChange(FSelStart, FSelEnd);
           ClearSelection;
         end;
     -1: begin
           SetSelStart(New);
           SetSelEnd(FSelAnchor);
         end;
     end;
  end;
//  ShowCaret;
  DoSelectionChange;
end;

procedure TAfCustomLineViewer.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TAfCustomLineViewer.SetCaret;
begin
  if SetCaretPos(FFocusedPoint) then ShowCaret else HideCaret;
end;

procedure TAfCustomLineViewer.SetCaretBlinkTime(Value: TAfCLVCaretBlinkTime);
begin
  if FCaretBlinkTime <> Value then
  begin
    FCaretBlinkTime := Value;
    if FCaretCreated then Windows.SetCaretBlinkTime(FCaretBlinkTime);
  end;
end;

function TAfCustomLineViewer.SetCaretPos(Position: TPoint): Boolean;
var
  CursorPos: TPoint;
  R: TRect;
begin
  Result := False;
  if FCaretCreated and (loShowCaretCursor in FOptions) then
  begin
    R := Bounds(FLeftSpace, 0, FVisibleArea.X * FCharWidth, FVisibleArea.Y * FCharHeight);
    with CursorPos do
    begin
      X := FLeftSpace + (Position.X - FTopLeft.X) * FCharWidth;
      Y := (Position.Y - FTopLeft.Y) * FCharHeight;
      Inc(X, FCaretOffset.X);
      Inc(Y, FCaretOffset.Y);
    end;
    if PtInRect(R, CursorPos) then
    begin
      Result := True;
      with CursorPos do Windows.SetCaretPos(X, Y);
    end;
  end;
end;

procedure TAfCustomLineViewer.SetCaretType(Value: TAfCLVCaretType);
begin
  if FCaretType <> Value then
  begin
    FCaretType := Value;
    RecreateCaret;
  end;
end;

procedure TAfCustomLineViewer.SetFocusedAndSelect(NewFocus: TPoint;
  Select: Boolean);
begin
  if Select then SelectArea(FFocusedPoint, NewFocus) else UnselectArea;
  SetFocusedPoint(NewFocus);
end;

procedure TAfCustomLineViewer.SetFocusedPoint(Value: TPoint);
begin
  FLockCursorChange := True;
  try
    SetFocusedPointX(Value.X);
    SetFocusedPointY(Value.Y);
    UpdateLineViewer;
  finally
    FLockCursorChange := False;
    if FNotifyCursorChange then
      DoCursorChange;
  end;
end;

procedure TAfCustomLineViewer.SetFocusedPointX(Value: Longint);
begin
  if loShowLineCursor in FOptions then Value := 0;
  if FFocusedPoint.X <> Value then
  begin
    if Value < 0 then Value := 0 else
      if Value >= FMaxLineLength then Value := FMaxLineLength - 1;
    FFocusedPoint.X := Value;
    if not ScrollIntoViewX then
    begin
      InvalidateFocusedLine;
      NeedUpdate := True;
    end;
    SetCaret;
    DoCursorChange;
  end;
end;

procedure TAfCustomLineViewer.SetFocusedPointY(Value: Longint);
begin
  if FFocusedPoint.Y <> Value then 
  begin
    if Value < 0 then Value := 0 else
      if Value >= FLineCount then Value := FLineCount - 1;
    InvalidateFocusedLine;
    FFocusedPoint.Y := Value;
    if not ScrollIntoViewY then
    begin
      InvalidateFocusedLine;
      NeedUpdate := True;
    end;
    SetCaret;
    DoCursorChange;
  end;
end;

procedure TAfCustomLineViewer.SetLeftSpace(Value: TAfCLVLeftSpace);
begin
  if Value <> FLeftSpace then
  begin
    FLeftSpace := Value;
    HideCaret;
    CalcSizeParam;
    AdjustScrollBarsSize;
    Invalidate;
  end;
end;

procedure TAfCustomLineViewer.SetLineCount(Value: Integer);
var
  T, B: Integer;
begin
  if Value <> FLineCount then
  begin
    if Value > FLineCount then
    begin
      T := FLineCount;
      B := Value;
    end else
    begin
      B := FLineCount;
      T := Value;
    end;
    FLineCount := Value;
    CalcSizeParam;
    AdjustScrollBarsSize;
    if FLineCount < FFocusedPoint.Y then SetFocusedPointY(FLineCount);
    if FLineCount < FTopLeft.Y then SetTopLeftY(FLineCount);
    UpdateScrollPos;
    InvalidateDataRect(Rect(0, T, 0, B), True);
    InvalidateLeftSpace(T, B);
  end;
end;

procedure TAfCustomLineViewer.SetMaxLineLength(Value: TAfCLVMaxLineLength);
begin
  if FMaxLineLength <> Value then
  begin
    FreeColorArray;
    FMaxLineLength := Value;
    ReallocColorArray;
    AdjustScrollBarsSize;
    CalcSizeParam;
    Invalidate;
  end;
end;

procedure TAfCustomLineViewer.SetName(const NewName: TComponentName);
begin
  inherited SetName(NewName);
  if csDesigning in ComponentState then Invalidate;
end;

procedure TAfCustomLineViewer.SetNeedUpdate(Value: Boolean);
begin
  if FNeedUpdate <> Value then
  begin
    FNeedUpdate := Value;
  end;
end;

procedure TAfCustomLineViewer.SetOptions(Value: TAfCLVOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    Invalidate;
  end;
end;

procedure TAfCustomLineViewer.SetSelectedColor(Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    Invalidate;
  end;
end;

procedure TAfCustomLineViewer.SetSelectedTextColor(Value: TColor);
begin
  if FSelectedTextColor <> Value then
  begin
    FSelectedTextColor := Value;
    Invalidate;
  end;
end;

procedure TAfCustomLineViewer.SetSelectedStyle(const Value: TFontStyles);
begin
  if FSelectedStyle <> Value then
  begin
    FSelectedStyle := Value;
    Invalidate;
  end;
end;

procedure TAfCustomLineViewer.SetTimerScrolling(const Value: Boolean);
begin
  if FTimerScrolling <> Value then
  begin
    FTimerScrolling := Value;
    if Value then
      SetTimer(Handle, TimerIDScroll, PvLineViewerScrollTime, nil)
    else
      KillTimer(Handle, TimerIDScroll);
  end;
end;

procedure TAfCustomLineViewer.SetTopLeft(Value: TPoint);
begin
  SetTopLeftX(Value.X);
  SetTopLeftY(Value.Y);
  UpdateLineViewer;
end;

procedure TAfCustomLineViewer.SetTopLeftX(Value: Longint);
var
  CharsMoved: Integer;
begin
  if FTopLeft.X <> Value then
  begin
    IsLeftOut(Value);
    CharsMoved := FTopLeft.X - Value;
    FTopLeft.X := Value;
    UpdateScrollPos;
    ScrollByX(CharsMoved);
    NeedUpdate := True;
    SetCaret;
  end;
end;

procedure TAfCustomLineViewer.SetTopLeftY(Value: Longint);
var
  LinesMoved: Integer;
begin
  if FTopLeft.Y <> Value then
  begin
    IsTopOut(Value);
    LinesMoved := FTopLeft.Y - Value;
    FTopLeft.Y := Value;
    UpdateScrollPos;
    ScrollByY(LinesMoved);
    InvalidateFocusedLine;
    NeedUpdate := True;
    SetCaret;
  end;
end;

procedure TAfCustomLineViewer.SetUseFontCache(const Value: Boolean);
begin
  if FUseFontCache <> Value then
  begin
    FUseFontCache := Value;
    FInternalUseFontCache := FUseFontCache and not (csDesigning in ComponentState);
    if FInternalUseFontCache then
      FInternalUseFontCache := FFontCache.Recreate(Font)
    else
      FFontCache.Clear;
  end;
end;

procedure TAfCustomLineViewer.SetUsedFontStyles(const Value: TFontStyles);
begin
  if FUsedFontStyles <> Value then
  begin
    FUsedFontStyles := Value;
    CalcSizeParam;
    AdjustScrollBarsSize;
    RecreateCaret;
    Invalidate;
  end;
end;

procedure TAfCustomLineViewer.ShowCaret;
begin
  if FCaretCreated and (not FCaretShown) and
    (loShowCaretCursor in FOptions) then
  begin
    Windows.ShowCaret(Handle);
    FCaretShown := True;
  end;
end;

procedure TAfCustomLineViewer.UnselectArea;
var
  SelectedRect: TRect;
begin
  if not IsSelectionEmpty then
  begin
    SelectedRect.TopLeft := FSelStart;
    SelectedRect.BottomRight := FSelEnd;
    ClearSelection;
    InvalidateDataRect(SelectedRect, True);
    InvalidateRect(Handle, nil, False);
    DoSelectionChange;
  end;
end;

procedure TAfCustomLineViewer.UpdateLineViewer;
begin
  if FNeedUpdate then
  begin
    FNeedUpdate := False;
    UpdateWindow(Handle);
  end;
end;

procedure TAfCustomLineViewer.UpdateScrollPos;
begin
  SetScrollPos(Handle, SB_HORZ, FTopLeft.X, True);
  SetScrollPos(Handle, SB_VERT, LongMulDiv(FTopLeft.Y, MaxSmallInt, VertScrollBarSize), True);
end;

function TAfCustomLineViewer.ValidTextRect: TRect;
begin
  Result.Left := FLeftSpace;
  Result.Top := 0;
  Result.Right := FLeftSpace + FVisibleArea.X * FCharWidth;
  Result.Bottom := FVisibleArea.Y * FCharHeight;
end;

function TAfCustomLineViewer.VertScrollBarSize: Integer;
begin
  Result := FLineCount;
end;

function TAfCustomLineViewer.VertScrollBarFromThumb(ThumbPos: Integer): Integer;
begin
  Result := ThumbPos;
end;

procedure TAfCustomLineViewer.CMFontChanged(var Message: TMessage);
begin
  inherited;
  CalcSizeParam;
  AdjustScrollBarsSize;
  RecreateCaret;
  if FInternalUseFontCache then FInternalUseFontCache := FFontCache.Recreate(Font);
  if Assigned(FOnFontChanged) then FOnFontChanged(Self);
  Invalidate;
end;

procedure TAfCustomLineViewer.WMDestroy(var Message: TWMDestroy);
begin
  DestroyCaret;
  TimerScrolling := False;
  inherited;
end;

procedure TAfCustomLineViewer.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
  if loTabs in FOptions then Message.Result := Message.Result or DLGC_WANTTAB;
end;

procedure TAfCustomLineViewer.WMHScroll(var Message: TWMHScroll);
begin
  inherited;
  FocusControlRequest;
  if not FocusRequest(fsHScroll) then Exit;
  case Message.ScrollCode of
    SB_LINELEFT: SetTopLeftX(FTopLeft.X - 1);
    SB_LINERIGHT: SetTopLeftX(FTopLeft.X + 1);
    SB_THUMBPOSITION: SetTopLeftX(Message.Pos);
    SB_THUMBTRACK:
      if loThumbTracking in FOptions then SetTopLeftX(Message.Pos);
  end;
  UpdateLineViewer;
end;

procedure TAfCustomLineViewer.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  DestroyCaret;
  FMouseDown := False;
end;

procedure TAfCustomLineViewer.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  MakeCaret;
end;

procedure TAfCustomLineViewer.WMWindowPosChanged(var Message: TWMWindowPosChanged);
var
  P: TPoint;
begin
  inherited;
  if (csLoading in ComponentState) or (csDestroying in ComponentState) then Exit;
  CalcSizeParam;
  AdjustScrollBarsSize;
  P := FTopLeft;
  if IsTopOut(P.Y) then SetTopLeftY(P.Y);
  if IsLeftOut(P.X) then SetTopLeftX(P.X);
  if loScrollToRowCursor in FOptions then ScrollIntoViewY;
  if loScrollToColCursor in FOptions then ScrollIntoViewX;
  if not FNeedUpdate then InvalidateFocusedLine;
  UpdateLineViewer;
end;

procedure TAfCustomLineViewer.WMVScroll(var Message: TWMVScroll);
var
  NewTopLine: Integer;

  procedure SetFromThumb;
begin
  NewTopLine :=
    VertScrollBarFromThumb(LongMulDiv(Message.Pos, VertScrollBarSize, MaxSmallInt));
end;

begin
  inherited;
  FocusControlRequest;
  if not FocusRequest(fsVScroll) then Exit;
  NewTopLine := FTopLeft.Y;
  case Message.ScrollCode of
    SB_LINEDOWN: Inc(NewTopLine);
    SB_LINEUP: Dec(NewTopLine);
    SB_PAGEDOWN: Inc(NewTopLine, FVisibleArea.Y);
    SB_PAGEUP: Dec(NewTopLine, FVisibleArea.Y);
    SB_THUMBPOSITION: SetFromThumb;
    SB_THUMBTRACK:
      if loThumbTracking in FOptions then SetFromThumb;
  end;
  SetTopLeftY(NewTopLine);
  UpdateLineViewer;
end;

procedure TAfCustomLineViewer.WMTimer(var Message: TWMTimer);
var
  P, NewFocus: TPoint;
  V: TRect;
begin
  if Message.TimerID = TimerIDScroll then
  begin
    Windows.GetCursorPos(P);
    P := ScreenToClient(P);
    NewFocus := MouseToPoint(P.X, P.Y);
    V := ValidTextRect;
    if P.Y < V.Top then NewFocus.Y := FFocusedPoint.Y - 1;
    if P.Y > V.Bottom then NewFocus.Y := FFocusedPoint.Y + 1;
    if P.X < V.Left then NewFocus.X := FFocusedPoint.X - 1;
    if P.X > V.Right then NewFocus.X := FFocusedPoint.X + 1;
    SetFocusedAndSelect(NewFocus, ((loSelectByShift in FOptions) and
      (GetKeyState(VK_SHIFT) and $80 <> 0)) or (not (loSelectByShift in FOptions)));
    Message.Result := 0;
  end else inherited;
end;

procedure TAfCustomLineViewer.SelectAll;
begin
  ClearSelection;
  SelectArea(Point(0, 0), Point(FMaxLineLength, FLineCount));
end;

function TAfCustomLineViewer.TextFromRange(const ASelStart, ASelEnd: TPoint): string;
const
  CRLF = #13#10;
var
  I: Integer;
  ColorMode: TAfCLVColorMode;
  SelLines: Integer;
  MemStream: TMemoryStream;
  LS: String;
begin
  Result := '';
  SelLines := ASelEnd.Y - ASelStart.Y;
  SetLength(LS, FMaxLineLength + 2);
  Result := '';
  if SelLines = 0 then
    Result := Copy(GetText(ASelStart.Y, ColorMode, FCharColors^),
      ASelStart.X + 1, ASelEnd.X - ASelStart.X + 1) else
  begin
    MemStream := TMemoryStream.Create;
    try
      for I := ASelStart.Y to ASelEnd.Y do
      begin
        LS := GetText(I, ColorMode, FCharColors^);
        if I = ASelStart.Y then LS := Copy(LS, ASelStart.X + 1, FMaxLineLength) else
          if I = ASelEnd.Y then LS := Copy(LS, 1, ASelEnd.X + 1) else
            LS := TrimRight(LS);
        LS := LS + CRLF;
        MemStream.WriteBuffer(LS[1], Length(LS));
      end;
      SetString(Result, PChar(MemStream.Memory), MemStream.Size);
    finally
      MemStream.Free;
    end;
  end;
end;

function TAfCustomLineViewer.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := True;
  if FocusRequest(fsVScroll) then
  begin
    SetTopLeftY(FTopLeft.Y + 3);
    UpdateLineViewer;
  end;
end;

function TAfCustomLineViewer.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := True;
  if FocusRequest(fsVScroll) then
  begin
    SetTopLeftY(FTopLeft.Y - 3);
    UpdateLineViewer;
  end; 
end;

{ TAfFileStream }

function AfFileCreate(const FileName: String; Mode: Word): THandle;
const
  AccessMode: array[0..2] of DWORD = (
    GENERIC_READ,
    GENERIC_WRITE,
    GENERIC_READ or GENERIC_WRITE);
  ShareMode: array[0..4] of DWORD = (
    0,
    0,
    FILE_SHARE_READ,
    FILE_SHARE_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE);
  CreateMode: array[Boolean] of DWORD = (
    OPEN_EXISTING,
    CREATE_ALWAYS);
begin
  if Mode = fmCreate then
    Result := INVALID_HANDLE_VALUE
  else
    Result := CreateFile(PChar(FileName), AccessMode[Mode and 3],
      ShareMode[(Mode and $F0) shr 4], nil, CreateMode[Mode and fmAfCreate <> 0],
      FILE_ATTRIBUTE_NORMAL, 0);
end;

constructor TAfFileStream.Create(const FileName: string; Mode: Word);
var
  Handle: THandle;
begin
  Handle := AfFileCreate(FileName, Mode);
  if Handle = INVALID_HANDLE_VALUE then
    raise EFCreateError.CreateFmt(sFSCreateError, [FileName]);
  inherited Create(Handle);
end;

destructor TAfFileStream.Destroy;
begin
  if THandle(Handle) <> INVALID_HANDLE_VALUE then FileClose(Handle);
  inherited Destroy;
end;

procedure TAfFileStream.FlushBuffers;
begin
  if THandle(Handle) <> INVALID_HANDLE_VALUE then FlushFileBuffers(Handle);
end;

{ TAfTerminalBuffer }

constructor TAfTerminalBuffer.Create(ATerminal: TAfCustomTerminal);
begin
  FBuffer := nil;
  FTerminal := ATerminal;
  FColorTable := PvTRMDefaultColorTable;
  FindDefaultTermColors;
end;

destructor TAfTerminalBuffer.Destroy;
begin
  FreeBuffer;
  inherited Destroy;
end;

function TAfTerminalBuffer.CalcLinePos(Line: Integer): Integer;
begin
  if Line + BufTail < FRows then Result := Line + BufTail else
    Result := Line - (FRows - BufTail);
end;

procedure TAfTerminalBuffer.ClearBuffer;
begin
  BufHead := 0;
  BufTail := 0;
  EndBufPos.Y := 0; // 0 .. FRows - 1
  EndBufPos.X := 0; // 0 .. FCols - 1
  LastBufPos := EndBufPos;
  MaxInvalidate := LastBufPos;
  LinesAdded := 0;
  ClearBufferLines(0, FRows);
  FLastCharPtr := LastCharPtr;
  FTopestLineForUpdateColor := -1;
  NeedDraw := False;
end;

procedure TAfTerminalBuffer.ClearBufferLines(FromLine, ToLine: Integer);
var
  ByteColor: Byte;
  I: Integer;
  BufPtr: PChar;
begin
  with FDefaultTermColor do ByteColor := FColor or (BColor shl 4);
  for I := FromLine to ToLine do
  begin
    BufPtr := Pointer(PChar(FBuffer.Memory) + (CalcLinePos(I) * (FCols + FColorDataSize + FUserDataSize)));
    FillChar(BufPtr^, FCols, #32);
    Inc(BufPtr, FCols);
    FillChar(BufPtr^, FColorDataSize, ByteColor);
    Inc(BufPtr, FColorDataSize);
    FillChar(BufPtr^, FUserDataSize, 0);
  end;
end;

procedure TAfTerminalBuffer.DrawChangedBuffer;
var
  UpdateRect: TRect;
  NeedScroll, NewLineCount, UY: Integer;
begin
  with FTerminal do
  if NeedDraw then // !Ver1.10
  begin
    if NeedGetColors then GetColorsForThisLine;
    NeedGetColors := False;
    FocusedPointY := LastBufPos.Y;
    NewLineCount :=  LastBufPos.Y + 1 + LinesAdded;
    if NewLineCount > FRows then
    begin
      NeedScroll := NewLineCount - FRows;
      NewLineCount := FRows;
    end else NeedScroll := 0;
    LineCount := NewLineCount;
    if NeedScroll > 0 then
    begin
      ScrollByY(-NeedScroll);
      NeedUpdate := True;
      if FTopestLineForUpdateColor <> -1 then
        Dec(FTopestLineForUpdateColor, NeedScroll);
    end;
    if LinesAdded = 0 then
    begin
      UY := EndBufPos.Y;
      UpdateRect := Rect(LastBufPos.X, UY, MaxInvalidate.X, EndBufPos.Y);
    end else
    begin
      UY := EndBufPos.Y - LinesAdded;
      UpdateRect := Rect(0, UY, FCols - 1, EndBufPos.Y);
    end;
    DoDrawBuffer;
    InvalidateDataRect(UpdateRect, False);
    if FTopestLineForUpdateColor <> -1 then
      InvalidateDataRect(Rect(0, FTopestLineForUpdateColor, 0, UY), True);
    if NeedScroll > 0 then
      InvalidateLeftSpace(UpdateRect.Top, UpdateRect.Bottom); // Mozna upravit na reakci UserDataChange
    FocusEndOfBuffer(False);
  end;
  FTopestLineForUpdateColor := -1;
  NeedDraw := False;
end;

procedure TAfTerminalBuffer.FindDefaultTermColors;
var
  I: Integer;
begin
  with FTerminal do
  begin
    I := FindTermColor(Color);
    if I = -1 then I := High(TAfTRMCharColor);
    FDefaultTermColor.BColor := I;
    I := FindTermColor(Font.Color);
    if I = -1 then I := 0;
    FDefaultTermColor.FColor := I;
  end;
end;

function TAfTerminalBuffer.FindTermColor(Color: TColor): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(TAfTRMCharColor) do if FColorTable[I] = Color then
  begin
    Result := I;
    Break;
  end;
end;

procedure TAfTerminalBuffer.FreeBuffer;
begin
  FBuffer.Free;
  FBuffer := nil;
  if FCharColorsArray <> nil then
  begin
    FreeMem(FCharColorsArray, FCols * Sizeof(TAfTRMCharAttr));
    FCharColorsArray := nil;
  end;
end;

function TAfTerminalBuffer.GetBuffColorsForDraw(LineNumber: Integer): PAfCLVCharColors;
var
  ColorPtr: PByteArray;
  I: Integer;
  FontStyle: TFontStyles;
begin
  ColorPtr := Ptr_Colors(LineNumber);
  with FTerminal do
  begin
    FontStyle := Font.Style;
    case FColorMode of
      cmL16_16:
        begin
          FCharColors^[0].FColor := FColorTable[ColorPtr^[0] and $0F];
          FCharColors^[0].BColor := FColorTable[(ColorPtr^[0] shr 4) and $0F];
          FCharColors^[0].Style := FontStyle;
        end;
      cmC16_16:
        for I := 0 to FCols - 1 do
        begin
          FCharColors^[I].FColor := FColorTable[ColorPtr^[I] and $0F];
          FCharColors^[I].BColor := FColorTable[(ColorPtr^[I] shr 4) and $0F];
          FCharColors^[I].Style := FontStyle;
        end;
    end;
  end;
  Result := FTerminal.FCharColors;
end;

function TAfTerminalBuffer.GetBuffLine(LineNumber: Integer): String;
var
  P: PChar;
begin
  P := Ptr_Text(LineNumber);
  SetString(Result, P, FCols);
  Result := TrimRight(Result);
end;

procedure TAfTerminalBuffer.GetLineColors(LineNumber: Integer; var Colors: TAfTRMCharAttrs);
var
  ColorPtr: PByteArray;
  I: Integer;
begin
  ColorPtr := Ptr_Colors(LineNumber);
  case FColorMode of
    cmL16_16:
      begin
        Colors[0].FColor := ColorPtr^[0] and $0F;
        Colors[0].BColor := (ColorPtr^[0] shr 4) and $0F;
      end;
    cmC16_16:
      for I := 0 to FCols - 1 do
      begin
        Colors[I].FColor := ColorPtr^[I] and $0F;
        Colors[I].BColor := (ColorPtr^[I] shr 4) and $0F;
      end;
  end;
end;

procedure TAfTerminalBuffer.IncBufVar(var Value: Integer);
begin
  Inc(Value);
  if Value >= FRows then Value := 0;
end;

function TAfTerminalBuffer.LastCharPtr: PChar; // vraci vzdy pozici pro prvni znak
begin
  Result := PChar(Ptr_Text(EndBufPos.Y));
end;

procedure TAfTerminalBuffer.NextChar;
begin
  Inc(EndBufPos.X);
  if EndBufPos.X > MaxInvalidate.X then MaxInvalidate.X := EndBufPos.X;
  Inc(FLastCharPtr);
  if EndBufPos.X >= FCols then
  begin 
    EndBufPos.X := 0;
    MaxInvalidate.X := 0;
    NextLine;
  end;
end;

procedure TAfTerminalBuffer.NextLine;
begin
  if NeedGetColors then FTerminal.GetColorsForThisLine;
  NeedGetColors := False;
  if Assigned(FTerminal.FOnNewLine) then FTerminal.FOnNewLine(FTerminal, EndBufPos.Y);
  Inc(LinesAdded);
  if EndBufPos.Y < FRows - 1 then Inc(EndBufPos.Y);
  IncBufVar(BufHead);
  if BufHead = BufTail then IncBufVar(BufTail);
  FLastCharPtr := LastCharPtr + EndBufPos.X;
  ClearBufferLines(EndBufPos.Y, EndBufPos.Y);
end;

function TAfTerminalBuffer.Ptr_Colors(LineNumber: Integer): Pointer;
begin
  Result := PChar(FBuffer.Memory) +
    (CalcLinePos(LineNumber) * (FCols + FColorDataSize + FUserDataSize)) +
    FCols;
end;

function TAfTerminalBuffer.Ptr_Text(LineNumber: Integer): Pointer;
begin
  Result := PChar(FBuffer.Memory) +
    (CalcLinePos(LineNumber) * (FCols + FColorDataSize + FUserDataSize));
end;

function TAfTerminalBuffer.Ptr_UserData(LineNumber: Integer): Pointer;
begin
  Result := PChar(FBuffer.Memory) +
    (CalcLinePos(LineNumber) * (FCols + FColorDataSize + FUserDataSize)) +
    FCols + FColorDataSize;
end;

procedure TAfTerminalBuffer.ReallocBuffer(Rows: Integer; Cols: Byte;
  ColorMode: TAfTRMColorMode; UserDataSize: Integer);
begin
  FreeBuffer;
  FBuffer := TMemoryStream.Create;
  FRows := Rows; // pocet
  FCols := Cols; // pocet
  FColorMode := ColorMode;
  case FColorMode of
    cmLDefault:
      FColorDataSize := 0;
    cmL16_16:
      FColorDataSize := 1;
    cmC16_16:
      FColorDataSize := FCols;
  end;
  FUserDataSize := UserDataSize;
  FBuffer.SetSize(FRows * (FCols + FColorDataSize + FUserDataSize));
  GetMem(FCharColorsArray, FCols * Sizeof(TAfTRMCharAttr));
  ClearBuffer;
end;

procedure TAfTerminalBuffer.SetLineColors(LineNumber: Integer; var Colors: TAfTRMCharAttrs);
var
  ColorPtr: PByteArray;
  LocalColors: PByteArray;
  I: Integer;

  procedure SetTopestLine;
begin
  if (FTopestLineForUpdateColor = -1) or (LineNumber < FTopestLineForUpdateColor) then
    FTopestLineForUpdateColor := LineNumber;
end;

begin
  ColorPtr := Ptr_Colors(LineNumber);
  GetMem(LocalColors, FColorDataSize);
  try
    case FColorMode of
      cmL16_16:
        begin
          LocalColors^[0] := Colors[0].Fcolor or (Colors[0].Bcolor shl 4);
          if ColorPtr^[0] <> LocalColors^[0] then SetTopestLine;
          ColorPtr^[0] := LocalColors^[0];
        end;
      cmC16_16:
        begin
          for I := 0 to FCols - 1 do
            LocalColors^[I] := Colors[I].Fcolor or (Colors[I].Bcolor shl 4);
          if not CompareMem(LocalColors, ColorPtr, FCols) then SetTopestLine;
          Move(LocalColors^, ColorPtr^, FCols);
        end;
    end;
  finally
    FreeMem(LocalColors, FColorDataSize);
  end;
end;

procedure TAfTerminalBuffer.WriteChar(C: Char);
begin
  if not NeedDraw then
  begin
    LastBufPos := EndBufPos;
    MaxInvalidate := EndBufPos;
    LinesAdded := 0;
    NeedDraw := True;
  end;
  case C of
    #07:
      FTerminal.DoBeepChar;
    #08:
      if EndBufPos.X > 0 then
      begin
        Dec(EndBufPos.X);
        case FTerminal.FBkSpcMode of
          bmBack:
            begin
//              FLastCharPtr^ := ' ';
              Dec(FLastCharPtr);
            end;
          bmBackDel:
            begin
              Dec(FLastCharPtr);
              FLastCharPtr^ := ' ';
            end;
        end;
        FTerminal.InvalidateDataRect(Rect(EndBufPos.X, EndBufPos.Y, EndBufPos.X + 1, EndBufPos.Y), False);
        NeedGetColors := True;
      end;
    #10:
      begin
        NextLine;
        NeedGetColors := True; 
      end;
    #13:
      begin
        EndBufPos.X := 0; // MaxInvalidate.X ukazuje na posledni znak
        FLastCharPtr := LastCharPtr;
      end;
    #32..#255:
      begin
        FLastCharPtr^ := C;
        NextChar;
        NeedGetColors := True;
      end;
  end;
end;

procedure TAfTerminalBuffer.WriteColorChar(C: Char; TermColor: TAfTRMCharAttr);
var
  ColorPtr: PByteArray;
begin
  if FColorMode <> cmC16_16 then
    raise EAfCLVException.Create(sErrorTermColor);
  if C in [#08, #32..#255] then
  begin
    ColorPtr := Ptr_Colors(EndBufPos.Y);
    if C = #08 then TermColor := FDefaultTermColor;
    with TermColor do ColorPtr^[EndBufPos.X] := FColor or (BColor shl 4);
    if (FTopestLineForUpdateColor = -1) or (EndBufPos.Y < FTopestLineForUpdateColor) then
      FTopestLineForUpdateColor := EndBufPos.Y;
  end;
  WriteChar(C);
  NeedGetColors := False;
end;

procedure TAfTerminalBuffer.WriteStr(const S: String);
var
  I: Integer;
begin
  if Length(S) > 0 then
  begin
    for I := 1 to Length(S) do WriteChar(S[I]);
    DrawChangedBuffer;
  end;
end;

{ TAfCustomTerminal }

constructor TAfCustomTerminal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoScrollBack := True;
  FBkSpcMode := bmBackDel;
  FCanScrollX := True;
  FDisplayCols := 80;
  FLogging := lgOff;
  FLogFlushTime := 5000;
  FLogName := 'LOG.TXT';
  FLogSize := 16384;
  FScrollBackCaret := ctBlock;
  FScrollBackKey := scNone;
  FScrollBackRows := 500;
  FTerminalCaret := ctHorizontal;
  FTermColorMode := cmLDefault;
  FUserDataSize := 0;
  LineCount := 1;
  Options := DefaultTerminalOptions;
  if not (csDesigning in ComponentState) then
  begin
    FTermBuffer := TAfTerminalBuffer.Create(Self);
    FTermBuffer.ReallocBuffer(FScrollBackRows, FDisplayCols, FTermColorMode, FUserDataSize);
    SetTermModeCaret;
  end;
end;

destructor TAfCustomTerminal.Destroy;
begin
  CloseLogFile;
  FOnDrawLeftSpace := nil;
  FTermBuffer.Free;
  inherited Destroy;
end;

procedure TAfCustomTerminal.ClearBuffer;
begin
  FTermBuffer.ClearBuffer;
  LineCount := 1;
  Invalidate;
  FocusEndOfBuffer(True);
end;

procedure TAfCustomTerminal.CloseLogFile;
begin
  FlushLogBuffer;
  LogFileStream.Free;
  LogFileStream := nil;
  LogMemStream.Free;
  LogMemStream := nil;
end;

procedure TAfCustomTerminal.CMColorChanged(var Message: TMessage);
begin
  inherited;
  if FTermBuffer <> nil then
  begin
    FTermBuffer.FindDefaultTermColors;
    ClearBuffer;
  end;
  Invalidate;
end;

procedure TAfCustomTerminal.CMFontChanged(var Message: TMessage);
begin
  inherited;
  if FTermBuffer <> nil then
    FTermBuffer.FindDefaultTermColors;
end;

function TAfCustomTerminal.DefaultTermColor: TAfTRMCharAttr;
begin
  if FTermBuffer <> nil then Result := FTermBuffer.FDefaultTermColor;
end;

procedure TAfCustomTerminal.DoBeepChar;
begin
  if Assigned(FOnBeepChar) then FOnBeepChar(Self);
end;

procedure TAfCustomTerminal.DoDrawBuffer;
begin
  if Assigned(FOnDrawBuffer) then FOnDrawBuffer(Self);
end;

procedure TAfCustomTerminal.DoEof;
begin
  inherited;
  if FAutoScrollBack then ScrollBackMode := False;
end;

procedure TAfCustomTerminal.DoLoggingChange;
begin
  if Assigned(FOnLoggingChange) then FOnLoggingChange(Self);
end;

procedure TAfCustomTerminal.DoScrBckBufChange;
begin
  if Assigned(FOnScrBckBufChange) then FOnScrBckBufChange(Self, Length(ScrollBackString));
end;

procedure TAfCustomTerminal.DrawChangedBuffer;
begin
  if (not FScrollBackMode) then FTermBuffer.DrawChangedBuffer;
end;

procedure TAfCustomTerminal.FlushLogBuffer;
begin
  if (LogMemStream <> nil) and (LogMemStream.Size > 0) then
  begin
    LogMemStream.Position := 0;
    LogFileStream.CopyFrom(LogMemStream, LogMemStream.Size);
    LogFileStream.FlushBuffers;
    LogMemStream.Clear;
    if Assigned(FOnFlushLog) then FOnFlushLog(Self);
  end;
end;

procedure TAfCustomTerminal.FocusEndOfBuffer(ScrollToCursor: Boolean);
begin
  try
    FCanScrollX := ScrollToCursor;
    with FTermBuffer do FocusedPoint := Point(EndBufPos.X, EndBufPos.Y);
  finally
    FCanScrollX := True;
  end;
end;

function TAfCustomTerminal.FocusRequest(FocusSource: TAfCLVFocusSource): Boolean;
begin
  if FocusSource = fsHScroll then Result := True else
  begin
    if FAutoScrollBack then ScrollBackMode := True;
    Result := FScrollBackMode;
  end;
end;

function TAfCustomTerminal.GetBufferLine(Index: Integer): String;
begin
  Result := FTermBuffer.GetBuffLine(Index);
end;

function TAfCustomTerminal.GetBufferLineNumber: Integer;
begin
  Result := FTermBuffer.EndBufPos.Y;
end;

function TAfCustomTerminal.GetColorTable: TAfTRMColorTable;
begin
  if FTermBuffer <> nil then Result := FTermBuffer.FColorTable;
end;

procedure TAfCustomTerminal.GetColorsForThisLine;
begin
  if Assigned(FOnGetColors) then
  begin
    FTermBuffer.GetLineColors(FTermBuffer.EndBufPos.Y, FTermBuffer.FCharColorsArray^);
    FOnGetColors(Self, FTermBuffer.EndBufPos.Y, FTermBuffer.FCharColorsArray^);
    FTermBuffer.SetLineColors(FTermBuffer.EndBufPos.Y, FTermBuffer.FCharColorsArray^);
  end;
end;

function TAfCustomTerminal.GetRelLineColors(Index: Integer): TAfTRMCharAttrs;
begin
  with FTermBuffer do if (Index <= 0) and (EndBufPos.Y + Index >= 0) then
    GetLineColors(EndBufPos.Y + Index, Result);
end;

function TAfCustomTerminal.GetTermColor(Color: TColor): Integer;
begin
  if FTermBuffer <> nil then
  begin
    Result := FTermBuffer.FindTermColor(ColorToRGB(Color));
    if Result = -1 then
      raise EAfCLVException.Create(sColorNotFound);
  end else Result := 0;
end;

function TAfCustomTerminal.GetText(LineNumber: Integer;
  var ColorMode: TAfCLVColorMode; var CharColors: TAfCLVCharColors): String;
begin
  if FTermBuffer <> nil then
  begin
    case FTermColorMode of
      cmLDefault:
        ColorMode := cmDefault;
      cmL16_16:
        ColorMode := cmLine;
      cmC16_16:
        ColorMode := cmChars;
    end;
    FTermBuffer.GetBuffColorsForDraw(LineNumber);
    Result := FTermBuffer.GetBuffLine(LineNumber);
  end else
  begin
    ColorMode := cmDefault;
    Result := Name;
  end;
end;

function TAfCustomTerminal.GetUserData(Index: Integer): Pointer;
begin
  Result := FTermBuffer.Ptr_UserData(Index);
end;

procedure TAfCustomTerminal.InternalWriteChar(C: Char);
begin
  if Assigned(FOnProcessChar) then FOnProcessChar(Self, C);
  if C <> #0 then
  begin
    if FScrollBackMode then ScrollBackString := ScrollBackString + C else
      FTermBuffer.WriteChar(C);
    WriteToLog(C);
  end;
end;

procedure TAfCustomTerminal.InternalWriteColorChar(C: Char; TermColor: TAfTRMCharAttr);
begin
  if Assigned(FOnProcessChar) then FOnProcessChar(Self, C);
  if C <> #0 then
  begin
    if FScrollBackMode then ScrollBackString := ScrollBackString + C else
      FTermBuffer.WriteColorChar(C, TermColor);
    WriteToLog(C);
  end;
end;

procedure TAfCustomTerminal.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if ShortCut(Key, Shift) = FScrollBackKey then
    ScrollBackMode := not ScrollBackMode else
      inherited KeyDown(Key, Shift);
end;

procedure TAfCustomTerminal.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FAutoScrollBack then ScrollBackMode := False;
  if not FScrollBackMode and Assigned(FOnSendChar) then FOnSendChar(Self, Key);
end;

procedure TAfCustomTerminal.Loaded;
begin
  inherited Loaded;
  SetTermModeCaret;
  StartLogging;
end;

procedure TAfCustomTerminal.OpenLogFile;
var
  OpenMode: Word;
begin
  if (csDesigning in ComponentState) or (Logging = lgOff) then Exit;
  try
    if (FLogging = lgAppend) and FileExists(FLogName) then
      OpenMode := fmOpenWrite else OpenMode := fmAfCreate;
    LogFileStream := TAfFileStream.Create(FLogName, OpenMode or fmShareDenyWrite);
    LogFileStream.Seek(0, soFromEnd);
    LogMemStream := TMemoryStream.Create;
  except
    begin
      Flogging := lgOff;
      with Application do MessageBox(PChar(sCantOpenLogFile), PChar(Title), MB_ICONERROR);
    end;
  end;
  if FLogFlushTime = 0 then
    KillTimer(Handle, TimerIDFlush)
  else
    SetTimer(Handle, TimerIDFlush, FLogFlushTime, nil);
end;

function TAfCustomTerminal.ScrollIntoViewX: Boolean;
begin
  if FCanScrollX then Result := inherited ScrollIntoViewX else
    Result := False;
end;

procedure TAfCustomTerminal.SetColorTable(Value: TAfTRMColorTable);
begin
  if FTermBuffer <> nil then
  begin
    FTermBuffer.FColorTable := Value;
    Self.Invalidate;
  end;
end;

procedure TAfCustomTerminal.SetDisplayCols(Value: Byte);
begin
  if FDisplayCols <> Value then
  begin
    FDisplayCols := Value;
    if FTermBuffer <> nil then
      FTermBuffer.ReallocBuffer(FScrollBackRows, FDisplayCols, FTermColorMode, FUserDataSize);
  end;
end;

procedure TAfCustomTerminal.SetLogName(const Value: String);
begin
  if FLogName <> Value then
  begin
    CloseLogFile;
    FLogName := Value;
    OpenLogFile;
    DoLoggingChange;
  end;
end;

procedure TAfCustomTerminal.SetLogging(Value: TAfTRMLogging);
begin
  if FLogging <> Value then
  begin
    FLogging := Value;
    if not (csLoading in ComponentState) then StartLogging;
    DoLoggingChange;
  end;
end;

procedure TAfCustomTerminal.SetOptions(Value: TAfCLVOptions);
begin
  if loTabs in Value then Value := DefaultTerminalOptions + [loTabs] else
    Value := DefaultTerminalOptions;
  inherited SetOptions(Value);
end;

procedure TAfCustomTerminal.SetRelLineColors(Index: Integer; Value: TAfTRMCharAttrs);
begin
  with FTermBuffer do if (Index <= 0) and (EndBufPos.Y + Index >= 0) then
    SetLineColors(EndBufPos.Y + Index, Value);
end;

procedure TAfCustomTerminal.SetScrollBackCaret(Value: TAfCLVCaretType);
begin
  if FScrollBackCaret <> Value then
  begin
    FScrollBackCaret := Value;
    SetTermModeCaret;
  end;
end;

procedure TAfCustomTerminal.SetScrollBackMode(Value: Boolean);
begin
  if FScrollBackMode <> Value then
  begin
    FScrollBackMode := Value;
    SetTermModeCaret;
    if FScrollBackMode then
    begin
      SetLength(ScrollBackString, 16384);
      ScrollBackString := '';
      ScrollIntoViewX;
    end else
    begin
      UnselectArea;
      if Length(ScrollBackString) > 0 then
        WriteString(ScrollBackString)
      else
        FocusEndOfBuffer(False);
      SetLength(ScrollBackString, 0);
    end;
    if Assigned(FOnScrBckModeChange) then FOnScrBckModeChange(Self);
    DoScrBckBufChange;
  end;
end;

procedure TAfCustomTerminal.SetScrollBackRows(Value: Integer);
begin
  if FScrollBackRows <> Value then
  begin
    if Value < FVisibleArea.Y * 2 then Value := FVisibleArea.Y * 2; 
    FScrollBackRows := Value;
    if FTermBuffer <> nil then
      FTermBuffer.ReallocBuffer(FScrollBackRows, FDisplayCols, FTermColorMode, FUserDataSize);
    LineCount := 1;
  end;
end;

procedure TAfCustomTerminal.SetTerminalCaret(Value: TAfCLVCaretType);
begin
  if FTerminalCaret <> Value then
  begin
    FTerminalCaret := Value;
    SetTermModeCaret;
  end;
end;

procedure TAfCustomTerminal.SetTermColorMode(Value: TAfTRMColorMode);
begin
  if FTermColorMode <> Value then
  begin
    FTermColorMode := Value;
    if FTermBuffer <> nil then
      FTermBuffer.ReallocBuffer(FScrollBackRows, FDisplayCols, FTermColorMode, FUserDataSize);
  end;
end;

procedure TAfCustomTerminal.SetTermModeCaret;
begin
  if FScrollBackMode then CaretType := FScrollBackCaret else
    CaretType := FTerminalCaret;
end;

procedure TAfCustomTerminal.SetUserData(Index: Integer; Value: Pointer);
var
  P: Pointer;
  Changed: Boolean;
begin
  P := FTermBuffer.Ptr_UserData(Index);
  Changed := not CompareMem(Value, P, FUserDataSize);
  Move(Value^, P^, FUserDataSize);
  if Changed then
  begin
    if Assigned(FOnUserDataChange) then FOnUserDataChange(Self, Index);
    InvalidateLeftSpace(Index, Index);
  end;
end;

procedure TAfCustomTerminal.SetUserDataSize(Value: Integer);
begin
  if FUserDataSize <> Value then
  begin
    FUserDataSize := Value;
    if FTermBuffer <> nil then
      FTermBuffer.ReallocBuffer(FScrollBackRows, FDisplayCols, FTermColorMode, FUserDataSize);
  end;
end;

procedure TAfCustomTerminal.StartLogging;
begin
  case FLogging of
    lgOff:
      CloseLogFile;
    lgCreate, lgAppend:
      begin
        CloseLogFile;
        OpenLogFile;
      end;
  end;
end;

procedure TAfCustomTerminal.WriteChar(C: Char);
begin
  InternalWriteChar(C);
  if FScrollBackMode then DoScrBckBufChange;
end;

procedure TAfCustomTerminal.WriteColorChar(C: Char; BColor, FColor: TAfTRMCharColor);
var
  TermColor: TAfTRMCharAttr;
begin
  ScrollBackMode := False; // Docasny buffer pri ScrollBackMode = True neuchovava atributy textu
  TermColor.BColor := BColor;
  TermColor.FColor := FColor;
  InternalWriteColorChar(C, TermColor);
  if FScrollBackMode then DoScrBckBufChange;
end;

procedure TAfCustomTerminal.WriteColorStringAndData(const S: String;
  BColor, FColor: TAfTRMCharColor; UserDataItem: Pointer);
var
  TermColor: TAfTRMCharAttr;
  I: Integer;
begin
  ScrollBackMode := False; // Docasny buffer pri ScrollBackMode = True neuchovava atributy textu
  TermColor.BColor := BColor;
  TermColor.FColor := FColor;
  if UserDataItem <> nil then UserData[FTermBuffer.EndBufPos.Y] := UserDataItem;
  for I := 1 to Length(S) do InternalWriteColorChar(S[I], TermColor);
  if FScrollBackMode then DoScrBckBufChange else DrawChangedBuffer;
end;

procedure TAfCustomTerminal.WriteString(const S: String);
var
  I: Integer;
begin
  for I := 1 to Length(S) do InternalWriteChar(S[I]);
  if FScrollBackMode then DoScrBckBufChange else DrawChangedBuffer;
end;

procedure TAfCustomTerminal.WriteToLog(const S: String);
begin
  if FLogging in [lgCreate, lgAppend] then with LogMemStream do
  begin
    WriteBuffer(S[1], Length(S));
    if Position >= FLogSize then FlushLogBuffer;
  end;
end;

procedure TAfCustomTerminal.WMDestroy(var Message: TWMDestroy);
begin
  KillTimer(Handle, TimerIDFlush);
  inherited;
end;

procedure TAfCustomTerminal.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result + DLGC_WANTCHARS;
end;

procedure TAfCustomTerminal.WMTimer(var Message: TWMTimer);
begin
  if Message.TimerID = TimerIDFlush then
  begin
    FlushLogBuffer;
    Message.Result := 0;
  end else inherited;
end;

{ TAfCustomFileViewer }

type
  PAfCFVCountParam = ^TAfCFVCountParam;
  TAfCFVCountParam = record
    Terminated: Boolean;
    Wnd: HWnd;
    Text: PChar;
    Size: DWORD;
    ScanBlockStep: Integer;
  end;

function AfCFVCountThread(Param: Pointer): Integer;
var
  Count, L: DWORD;
  P: PChar;
  UnfinishedLine: Boolean;

  procedure NotifyCount;
var
  Res: DWORD;
begin
  with PAfCFVCountParam(Param)^ do
    SendMessageTimeout(Wnd, UM_UPDATELINECOUNT, Count, Size - L, SMTO_ABORTIFHUNG, 2000, Res);
end;

begin
  Result := 0;
  with PAfCFVCountParam(Param)^ do
  try
    Count := 0;
    P := Text;
    L := Size;
    UnfinishedLine := False;
    while (not Terminated) and (L > 0) and (P^ <> #0) do
    begin
      if P^ = #10 then
      begin
        Inc(Count);
        UnfinishedLine := False;
        if Count mod DWORD(ScanBlockStep) = 0 then NotifyCount;
      end else UnfinishedLine := True;
      Inc(P);
      Dec(L);
    end;
    if UnfinishedLine then Inc(Count);
    if not Terminated then NotifyCount;
    Text := nil;
    EndThread(Result);
  except;
    EndThread(1);
    Text := nil;
  end;
end;

procedure TAfCustomFileViewer.CloseFile;
begin
  OpenData(nil, 0);
  CloseFileMapping;
end;

procedure TAfCustomFileViewer.CloseFileMapping;
begin
  if FFileHandle <> INVALID_HANDLE_VALUE then
  begin
    if FFileMapView <> nil then UnmapViewOfFile(FFileMapView);
    if FFileMapping <> 0 then CloseHandle(FFileMapping);
    CloseHandle(FFileHandle);
    FFileHandle := INVALID_HANDLE_VALUE;
  end;
end;

procedure TAfCustomFileViewer.CountLines;
var
  Count, L: DWORD;
  P: PChar;
  UnfinishedLine: Boolean;

  procedure NotifyCount;
begin
  UpdateLineCount(Count, FFileSize - L);
end;

begin
  Screen.Cursor := crHourGlass;
  try
    Count := 0;
    P := FFileBase;
    L := FFileSize;
    UnfinishedLine := False;
    while (L > 0) and (P^ <> #0) do
    begin
      if P^ = #10 then
      begin
        Inc(Count);
        UnfinishedLine := False;
        if Count mod DWORD(FScanBlockStep) = 0 then NotifyCount;
      end else UnfinishedLine := True;
      Inc(P);
      Dec(L);
    end;
    if UnfinishedLine then Inc(Count);
    NotifyCount;
  finally
    Screen.Cursor := crDefault;
  end;
end;

constructor TAfCustomFileViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFileHandle := INVALID_HANDLE_VALUE;
  FScanBlockStep := 2000;
  FUseThreadScan := True;
  Options := Options - [loDrawFocusSelect, loShowLineCursor] + [loShowCaretCursor];
  if not (csDesigning in ComponentState) then
  begin
    New(PAfCFVCountParam(ThreadParam));
    ZeroMemory(ThreadParam, Sizeof(TAfCFVCountParam));
  end;
end;

destructor TAfCustomFileViewer.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    StopCountThread;
    CloseFileMapping;
    Dispose(PAfCFVCountParam(ThreadParam));
  end;
  inherited Destroy;
end;

function TAfCustomFileViewer.FilePtrFromLine(Line: Integer): PChar;
var
  Ofs: Integer;
begin
  Result := nil;
  if FFileBase <> nil then
  begin
    Ofs := Line - LastLine;
    if Line = 0 then Result := FFileBase else
    begin
      if Ofs = 0 then Result := LastPtr else
      if Ofs > 0 then
      begin
        Result := LastPtr;
        while Ofs > 0 do
        begin
          if Result^ = #10 then Dec(Ofs);
          Inc(Result);
          if Result >= FFileEnd then
          begin
            Result := FFileEnd;
            Break;
          end;
        end;
      end else
      if Ofs < 0 then
      begin
        Result := LastPtr;
        while Ofs < 1 do
        begin
          if Result^ = #10 then Inc(Ofs);
          Dec(Result);
        end;
        Inc(Result, 2);
      end;
    end;
    LastPtr := Result;
    LastLine := Line;
  end;
end;

function TAfCustomFileViewer.GetText(LineNumber: Integer;
  var ColorMode: TAfCLVColorMode; var CharColors: TAfCLVCharColors): String;
var
  P, E: PChar;
begin
  ColorMode := cmDefault;
  if (csDesigning in ComponentState) then
    Result := Format('%s - Line %d', [Self.Name, LineNumber])
  else
  begin
    P := FilePtrFromLine(LineNumber);
    if P = nil then Result := '' else
    begin
      E := P;
      while not (E^ in [#10, #13]) and (E <= FFileEnd) do Inc(E);
      SetString(Result, P, E - P);
    end;
    if Assigned(FOnGetText) then
    begin
      FillChar(CharColors, FMaxLineLength * Sizeof(TAfCLVCharAttr), 0);
      FOnGetText(Self, LineNumber, Result, ColorMode, CharColors);
    end;
  end;
end;

procedure TAfCustomFileViewer.OpenData(const TextBuf: PChar; const TextSize: Integer);
begin
  StopCountThread;
  FocusedPoint := Point(0, 0);
  UnselectArea;
  FFileBase := TextBuf;
  FFileSize := TextSize;
  FFileEnd := FFileBase + FFileSize - 1;
  LastLine := 0;
  LastPtr := FFileBase;
  LineCount := 0;
  UpdateScrollPos;
  Invalidate;
  if FUseThreadScan then StartCountThread else CountLines;
end;

procedure TAfCustomFileViewer.OpenFile;
begin
  CloseFile;
  FFileHandle := CreateFile(PChar(FFileName), GENERIC_READ, FILE_SHARE_READ,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  try
    if FFileHandle = INVALID_HANDLE_VALUE then
      raise EAfCLVException.CreateFmt(sCantOpenFile, [FFileName]);
    FFileMapping := CreateFileMapping(FFileHandle, nil, PAGE_READONLY, 0, 0, nil);
    if FFileMapping = 0 then
      FFileMapView := nil
    else
      FFileMapView := MapViewOfFile(FFileMapping, FILE_MAP_READ, 0, 0, 0);
    if FFileMapView = nil then
      raise EAfCLVException.Create(sMappingFailed);
    OpenData(FFileMapView, GetFileSize(FFileHandle, nil));
  except
    CloseFile;
    raise;
  end;
end;

procedure TAfCustomFileViewer.SetFileName(const Value: String);
begin
  FFileName := Value;
end;

procedure TAfCustomFileViewer.StartCountThread;
begin
  if FFileBase = nil then Exit;
  with PAfCFVCountParam(ThreadParam)^ do
  begin
    Terminated := False;
    Wnd := Handle;
    Text := FFileBase;
    Size := FFileSize;
    ScanBlockStep := FScanBlockStep;
  end;
  CountThreadHandle := BeginThread(nil, 0, AfCFVCountThread, ThreadParam, 0, CountThreadID);
end;

procedure TAfCustomFileViewer.StopCountThread;
var
  Msg: TMsg;
begin
  with PAfCFVCountParam(ThreadParam)^ do
  begin
    Terminated := True;
    if Text <> nil then
      while MsgWaitForMultipleObjects(1, CountThreadHandle, False, INFINITE,
        QS_SENDMESSAGE) = WAIT_OBJECT_0 + 1 do PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
//    if Text <> nil then WaitForSingleObject(CountThreadHandle, INFINITE);
    CountThreadHandle := 0;
  end;
end;

procedure TAfCustomFileViewer.UMUpdateLineCount(var Message: TMessage);
begin
  with Message do
  begin
    UpdateLineCount(WParam, LParam);
    Result := 1;
  end;  
end;

procedure TAfCustomFileViewer.UpdateLineCount(ALineCount, AScanPos: Integer);
begin
  LineCount := ALineCount;
  FScanPosition := AScanPos;
  if Assigned(FOnScanBlock) then FOnScanBlock(Self);
end;

end.
