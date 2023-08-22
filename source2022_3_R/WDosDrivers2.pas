
{*******************************************************}
{                                                       }
{       Borland Delphi WDosX Component Library          }
{                                                       }
{       for Delphi 4, 5 WDosX DOS-Extender              }
{       Copyright (c) 2000 by Immo Wache                }
{       e-mail: immo.wache@t-online.de
{       Extensions to maXbox4  max@kleiner.ch           }
{                                                       }
{*******************************************************}

{
  Version history:
    IWA 11/20/00 Version 1.1
      new feature:
      - TKeyboard works on NT, W2K, Win9x and DOS   - keyscan windows
}

{ TODO : missing features in TKeyboard
         - handling Ctrl+Alt+Del
             property BreakAction (braColdBoot, braWarmBoot, braEvent)
             property OnBreakAction: TNotifyEvent }

unit WDosDrivers2;

interface

uses
  {WDosWindows, WDosMessages, WDosSysUtils, WDosClasses, WDosForms,
  WDosInterrupts, WDosDriverConst }{WDosDriverConst,}  SysUtils, Windows, Classes, Messages;

const
  AuxMsgBuffSize =8;
  InpMsgBuffSize =32;

 const
  DCapitalShift =False;
  DNonEnglish =False;
  VK_NULL = 0;
  VK_UNKNOWN  = 0;

  type
  TCharSet = set of Char;

  const
    Diacritics: TCharSet =[];

 (* VirtualKey: array[1..93] of Byte =(
    VK_ESCAPE, VK_Numpad1, VK_Numpad2, VK_Numpad3, VK_Numpad4, VK_Numpad5, VK_Numpad6, VK_Numpad7, VK_Numpad8, VK_Numpad9, VK_Numpad0,
    VK_OEM_4, VK_OEM_6, VK_BACK, VK_TAB, ord('Q'), ord('W'), VK_E, ord('R'), VK_T, VK_Y,
    VK_U, VK_I, VK_O, VK_P, VK_OEM_1, VK_OEM_PLUS, VK_RETURN, VK_LCONTROL,
    VK_A, VK_S, VK_D, VK_F, VK_G, VK_H, VK_J, VK_K, VK_L, VK_OEM_3, VK_OEM_7,
    VK_OEM_5, VK_LSHIFT, VK_OEM_2, VK_Z, VK_X, VK_C, VK_V, VK_B, VK_N, VK_M,
    VK_OEM_COMMA, VK_OEM_PERIOD, VK_OEM_MINUS, VK_RSHIFT, VK_MULTIPLY,
    VK_LMENU, VK_SPACE, VK_CAPITAL, VK_F1, VK_F2, VK_F3, VK_F4, VK_F5, VK_F6,
    VK_F7, VK_F8, VK_F9, VK_F10, VK_NUMLOCK, VK_SCROLL, VK_HOME, VK_UP,
    VK_PRIOR, VK_SUBTRACT, VK_LEFT, VK_CLEAR, VK_RIGHT, VK_ADD, VK_END,
    VK_DOWN, VK_NEXT, VK_INSERT, VK_DELETE, VK_SNAPSHOT, VK_NULL, VK_OEM_102,
    VK_F11, VK_F12, VK_NULL, VK_NULL, VK_LWIN, VK_RWIN, VK_APPS);

    //  *)


     KeyMap: array[0..255] of Char =(
      #00, #00, #00, #03, #00, #00, #00, #00,
      #08, #09, #00, #00, #00, #13, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #27, #00, #00, #00, #00,
      ' ', #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      '0', '1', '2', '3', '4', '5', '6', '7',
      '8', '9', #00, #00, #00, #00, #00, #00,
      #00, 'a', 'b', 'c', 'd', 'e', 'f', 'g',
      'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
      'p', 'q', 'r', 's', 't', 'u', 'v', 'w',
      'x', 'y', 'z', #00, #00, #00, #00, #00,
      '0', '1', '2', '3', '4', '5', '6', '7',
      '8', '9', '*', '+', #00, '-', '.', '/',
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, ';', '=', ',', '-', '.', '/',
      '`', #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, '[', '\', ']','''', #00,
      #00, #00, '\', #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00);

  ShiftKeyMap: array[0..255] of Char =(
      #00, #00, #00, #03, #00, #00, #00, #00,
      #08, #09, #00, #00, #00, #13, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #27, #00, #00, #00, #00,
      ' ', #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      ')', '!', '@', '#', '$', '%', '^', '&',
      '*', '(', #00, #00, #00, #00, #00, #00,
      #00, 'A', 'B', 'C', 'D', 'E', 'F', 'G',
      'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
      'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
      'X', 'Y', 'Z', #00, #00, #00, #00, #00,
      '0', '1', '2', '3', '4', '5', '6', '7',
      '8', '9', '*', '+', #00, '-', '.', '/',
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, '{', '}', '<', '?', '>', '|',
      ':', #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, '_', '~', '+', '"', #00,
      #00, #00, '|', #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00);

  CtrlKeyMap: array[0..255] of Char =(
      #00, #00, #00, #03, #00, #00, #00, #00,
      #127,#09, #00, #00, #00, #10, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #27, #00, #00, #00, #00,
      ' ', #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #01, #02, #03, #04, #05, #06, #07,
      #08, #09, #10, #11, #12, #13, #14, #15,
      #16, #17, #18, #19, #20, #21, #22, #23,
      #24, #25, #26, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #27, #29, #00, #00, #00, #28,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00);

  AltGrKeyMap: array[0..255] of Char =(
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00,
      #00, #00, #00, #00, #00, #00, #00, #00);



type
  TAuxMsgBuffRange = 0..Pred(AuxMsgBuffSize);
  TInpMsgBuffRange = 0..Pred(InpMsgBuffSize);

  TInpMsg = record
    Msg: TMessage;
    AuxData: Integer;
  end;

  TKeyAuxData = packed record
    VirtualKeyEx: SmallInt;
    IsKeyboardKey: Boolean;
    Dummy: Byte;
  end;

{ TwdxInputDeviceQueue }

  TInputQueue = class (TObject)
  private
    FAuxMsgBuff: array[TAuxMsgBuffRange] of TInpMsg;
    FAuxMsgBuffCount: Integer;
    FAuxMsgBuffHead: Integer;
    FAuxMsgBuffTail: Integer;
    FInpMsgBuff: array[TInpMsgBuffRange] of TInpMsg;
    FInpMsgBuffCount: Integer;
    FInpMsgBuffHead: Integer;
    FInpMsgBuffTail: Integer;
    FInpMsgLast: Integer;
    procedure AllocAuxMsgBuff;
    procedure AllocInpMsgBuff;
    procedure FreeAuxMsgBuff;
    procedure FreeInpMsgBuff;
    function PeekAuxMsgBuff(var AElement: TInpMsg): Boolean;
    function PeekInpMsgBuff(var AElement: TInpMsg): Boolean;
    function PokeAuxMsgBuff(const AElement: TInpMsg): Boolean;
    function PokeInpMsgBuff(const AElement: TInpMsg): Boolean;
  public
    procedure PeekAuxMsg(var AMsg: TMessage; var Handled: Boolean);
    procedure PeekInpMsg(var AMsg: TMessage; var Handled: Boolean);
    procedure TranslateMessage(Sender, Dest: TObject; var Msg: TMessage);
  end;

  { KeyFlags, refer for help to WM_KEYDOWN, WM_SYSKEYDOWN }
  TKeyFlag =(kfExtendedKey, kf1, kf2, kf3, kf4, kfContextCode,
    kfPreviousKeyState, kfTransitionState);
  TKeyFlags = set of TKeyFlag;

  { KeyEventFlags for KeyEvent; similar to windows keybd_event function }
  TKeyEvent =(keExtendedKey, keKeyUp);
  TKeyEvents = set of TKeyEvent;

  TKeyData = packed record
    RepeatCount: Word;
    ScanCode: Byte;
    KeyFlags: TKeyFlags;
  end;

  TKeyboardDelay = 0..3;
  TKeyboardSpeed = 0..31;

  TMapType = (mtVirtualToScan, mtScanToVirtual, mtVirtualToChar,
      mtScanToVirtualEx);

   DpmiPmVector = Int64;


{ TKeyboard }

  TKeyboard = class (TObject)
  private
    FAltGrLocked: Boolean;
    FAsyncKeyboardState: TKeyboardState;
    FCapitalShift: Boolean;
    FNonEnglish: Boolean;
    FCapsLock: Boolean;
    FContextCode: Boolean;
    FDelay: TKeyboardDelay;
    FDiacriticsChar: Integer;
    FExtendedKey: Boolean;
    FKeyboardState: TKeyboardState;
    FKeyStatus: Byte;
    FNumber: string;
    FNumLock: Boolean;
    FOldKeyboardHandler: DpmiPmVector;
    FPauseKey: Boolean;
    FPostedCharCode: Integer;
    FPreviousKeyState: Boolean;
    FScanCode: Byte;
    FScanCodeMap: TKeyboardState;
    FScrollLock: Boolean;
    FShiftLocked: Boolean;
    FSpeed: TKeyboardSpeed;
    FTransitionState: Boolean;
    FVirtualControl: Boolean;
    FEnabled: Boolean;
    procedure GenerateKeyMessage(VirtualKeyEx: Integer; AKeyBoardKey: Boolean);
    procedure HandleInterrupt(ScanCode: Integer);
    procedure InitScanCodeMap;
    procedure PokeAuxMsg(AMsg: Cardinal; AVirtualKeyEx: Word; AKeyData:
        Integer);
    procedure PostMessage(AVirtualKey, AVirtualKeyEx, AKeyData: Integer;
        TransitionState, AKeyBoardKey: Boolean);
    function ScanCodeToVirtualKeyEx(ScanCode: Integer): Integer;
    function ScanToKeyData(AScanCode: Integer; ExtendedKey, ContextCode,
        PreviousKeyState, TransitionState: Boolean): Integer;
    function SendKeyboard(Data: Byte): Boolean;
    procedure SetAsyncKeyState(VirtualKeyEx: Integer);
    procedure SetAsyncMouseState(AMsg: Cardinal);
    procedure SetCapsLock(Value: Boolean);
    procedure SetDelay(const Value: TKeyboardDelay);
    function SetLockState(Index: Integer; Value: Boolean): Boolean;
    procedure SetNumLock(Value: Boolean);
    procedure SetScrollLock(Value: Boolean);
    procedure SetSpeed(const Value: TKeyboardSpeed);
    function UpdateIndicator: Boolean;
    function VirtualKeyExToCharCode(VirtualKeyEx: Integer): Integer;
    function VirtualKeyExToScanCode(VirtualKeyEx: Integer): Integer;
    function VirtualKeyExToVirtualKey(VirtualKeyEx: Integer): Integer;
    procedure SetMouseState(AMsg: Cardinal);
    procedure SetEnabled(const Value: Boolean);
  protected
    function HandleKeyMsg(var InpMsg: TInpMsg): Boolean;
    procedure TranslateMessage(var Msg: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    procedure Done;
    function AsyncKeyChecked(VirtualKeyEx: Integer): Boolean;
    function AsyncKeyPressed(VirtualKeyEx: Integer): Boolean;
    function GetAsyncKeyState(VirtualKeyEx: Integer): SmallInt;
    function GetKeyboardState: TKeyboardState;
    function GetKeyState(VirtualKeyEx: Integer): SmallInt;
    function KeyChecked(VirtualKeyEx: Integer): Boolean;
    procedure KeyEvent(VirtualKeyEx: Integer; ScanCode: Byte; Flags:
        TKeyEvents);
    function KeyPressed(VirtualKeyEx: Integer): Boolean;
    function MapVirtualKey(Code: Integer; MapType: TMapType): Integer;
    function SetIndicators(const AScrollLock, ANumLock, ACapsLock: Boolean):
        Boolean;
    procedure SetKeyboardState(const KeyboardState: TKeyboardState);
    function SetTypematic(Delay: TKeyboardDelay; Speed: TKeyboardSpeed):
        Boolean;
    { property CapitalShift: how to release capital mode
        false: release with caps lock
        true:  release with shift (e.g. like german dos keyboard driver)
    }
    property CapitalShift: Boolean read FCapitalShift write FCapitalShift
        default DCapitalShift;
    property CapsLock: Boolean read FCapsLock write SetCapsLock;
    property Delay: TKeyboardDelay read FDelay write SetDelay;
    property NumLock: Boolean read FNumLock write SetNumLock;
    property ScrollLock: Boolean read FScrollLock write SetScrollLock;
    property Speed: TKeyboardSpeed read FSpeed write SetSpeed;
    property Enabled: Boolean read FEnabled write SetEnabled;
  end;

{ TMouse }

  TMouse2 = class (TObject)
  private
    FButtons: Byte;
    FTicks: Word;
    FWhere: TPoint;
    FLastButtons: Byte;
    FDownTicks: array[0..2] of Integer;
    FLastWhere: TPoint;
    FLastDouble: array[0..2] of Boolean;
    FReverse: Boolean;
    FButtonCount: Integer;
    FDoubleDelay: Integer;
    FVisible: Boolean;
    FEnabled: Boolean;
    procedure PokeMessage(AMsg: Cardinal; AKeys: Integer; APos: TPoint);
    procedure HandleCallback;
    procedure SetEnabled(const Value: Boolean);
  protected
    function DetectMouse: Byte;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    procedure Done;
    procedure Show;
    procedure Hide;
    procedure SetScreenSize(Width, Height: Byte);
    property ButtonCount: Integer read FButtonCount;
    property Reverse: Boolean read FReverse write FReverse;
    property DoubleDelay: Integer read FDoubleDelay write FDoubleDelay;
    property Visible: Boolean read FVisible;
    property Enabled: Boolean read FEnabled write SetEnabled;
  end;

var
  InputQueue: TInputQueue;
  Keyboard: TKeyboard;
  Mouse: TMouse2;

implementation

uses
  WDosPorts, Forms;

const
  IntControl  = $21;

  StatusPort = $64;
  DataPort = $60;

  ACK_SIGNAL = $FA;
  SET_TYPEMATIC = $F3;
  SET_INDICATOR = $ED;

  OB_FULL = $01;
  IB_FULL = $02;

  SCROLL_LOCK = $10;
  NUM_LOCK = $20;
  CAPS_LOCK = $40;

  VirtualNumKey: array[0..13] of Byte =(
    VK_MULTIPLY, VK_NUMPAD7, VK_NUMPAD8, VK_NUMPAD9, VK_SUBTRACT, VK_NUMPAD4,
    VK_NUMPAD5, VK_NUMPAD6, VK_ADD, VK_NUMPAD1, VK_NUMPAD2, VK_NUMPAD3,
    VK_NUMPAD0, VK_DECIMAL);

  { diacritics chars }
  Diac_UpA: array[0..2] of Char =('Á', 'À', 'Â');
  Diac_UpE: array[0..2] of Char =('É', 'È', 'Ê');
  Diac_UpI: array[0..2] of Char =('Í', 'Ì', 'Î');
  Diac_UpO: array[0..2] of Char =('Ó', 'Ò', 'Ô');
  Diac_UpU: array[0..2] of Char =('Ú', 'Ù', 'Û');
  Diac_LoA: array[0..2] of Char =('á', 'à', 'â');
  Diac_LoE: array[0..2] of Char =('é', 'è', 'ê');
  Diac_LoI: array[0..2] of Char =('í', 'ì', 'î');
  Diac_LoO: array[0..2] of Char =('ó', 'ò', 'ô');
  Diac_LoU: array[0..2] of Char =('ú', 'ù', 'û');

var
  BiosKeyStatus: Byte; // absolute $417;
  WinNT: Boolean;  { True if OS is NT4 }

procedure KeyboardHandler;
begin
  Keyboard.HandleInterrupt(Port[DataPort]);
  port[$20]:=$20;
end;

{
********************************* TInputQueue **********************************
}
procedure TInputQueue.AllocAuxMsgBuff;
begin
  { shift AuxMsgBuff head pointer to next free element }
  Inc(FAuxMsgBuffHead);
  if FAuxMsgBuffHead >High(TAuxMsgBuffRange) then
    FAuxMsgBuffHead :=Low(TAuxMsgBuffRange);
  { increment AuxMsgBuff counter }
  Inc(FAuxMsgBuffCount);
end;

procedure TInputQueue.AllocInpMsgBuff;
begin
  { set pointer to buffer end }
  FInpMsgLast :=FInpMsgBuffHead;
  { shift InpMsgBuff head pointer to next free element }
  Inc(FInpMsgBuffHead);
  if FInpMsgBuffHead >High(TInpMsgBuffRange) then
    FInpMsgBuffHead :=Low(TInpMsgBuffRange);
  { increment InpMsgBuff counter }
  Inc(FInpMsgBuffCount);
end;

procedure TInputQueue.FreeAuxMsgBuff;
begin
  { shift AuxMsgBuff tail pointer to next allocated element }
  Inc(FAuxMsgBuffTail);
  if FAuxMsgBuffTail >High(TAuxMsgBuffRange) then
    FAuxMsgBuffTail :=Low(TAuxMsgBuffRange);
  { decrement AuxMsgBuff counter }
  Dec(FAuxMsgBuffCount);
end;

procedure TInputQueue.FreeInpMsgBuff;
begin
  { only necessary for interrupt safe access }
  asm
        PUSHF
        CLI
  end;
  { shift InpMsgBuff tail pointer to next allocated element }
  Inc(FInpMsgBuffTail);
  if FInpMsgBuffTail >High(TInpMsgBuffRange) then
    FInpMsgBuffTail :=Low(TInpMsgBuffRange);
  { decrement InpMsgBuff counter }
  Dec(FInpMsgBuffCount);
  asm
        POPF
  end;
end;

procedure TInputQueue.PeekAuxMsg(var AMsg: TMessage; var Handled: Boolean);
var
  InpMsg: TInpMsg;
begin
  if PeekAuxMsgBuff(InpMsg) then
  begin
    with InpMsg.Msg do
      if (Msg = WM_KEYDOWN) or (Msg = WM_KEYUP)
          or (Msg = WM_SYSKEYDOWN) or (Msg = WM_SYSKEYUP) then
        if Keyboard.HandleKeyMsg(InpMsg) then
        begin
          AMsg :=InpMsg.Msg;
          Handled :=True;
        end;
  end;
end;

function TInputQueue.PeekAuxMsgBuff(var AElement: TInpMsg): Boolean;
begin
  { hack for Windows NT }
  if WinNT then
    asm
        MOV     AH,1
        INT     16H
    end;

  Result :=FAuxMsgBuffCount >0;
  { check for a element in AuxMsgBuff }
  if Result then
  begin
    { peek next element from AuxMsgBuff }
    AElement :=FAuxMsgBuff[FAuxMsgBuffTail];
    { free element in AuxMsgBuff }
    FreeAuxMsgBuff;
  end;
end;

procedure TInputQueue.PeekInpMsg(var AMsg: TMessage; var Handled: Boolean);
var
  InpMsg: TInpMsg;
begin
  if PeekInpMsgBuff(InpMsg) then
  begin
    with InpMsg.Msg do
      if (Msg = WM_KEYDOWN) or (Msg = WM_KEYUP)
          or (Msg = WM_SYSKEYDOWN) or (Msg = WM_SYSKEYUP) then
      begin
        if Keyboard.HandleKeyMsg(InpMsg) then
        begin
          AMsg :=InpMsg.Msg;
          Handled :=True;
        end;
      end else if (Msg >= WM_MOUSEFIRST) and (Msg <= WM_MOUSELAST) then
      begin
        Keyboard.SetMouseState(Msg);
        AMsg :=InpMsg.Msg;
        Handled :=True;
      end;
  end;
end;

function TInputQueue.PeekInpMsgBuff(var AElement: TInpMsg): Boolean;
begin
  Result :=FInpMsgBuffCount >0;
  { check for a element in InpMsgBuff }
  if Result then
  begin
    { only necessary for interrupt safe access }
    asm
        PUSHF
        CLI
    end;
    { peek next element from InpMsgBuff }
    AElement :=FInpMsgBuff[FInpMsgBuffTail];
    { free element in InpMsgBuff }
    FreeInpMsgBuff;
    asm
        POPF
    end;
  end;
end;

function TInputQueue.PokeAuxMsgBuff(const AElement: TInpMsg): Boolean;
begin
  { check for AuxMsgBuff is full }
  Result :=FAuxMsgBuffCount <AuxMsgBuffSize;
  if Result then
  begin
    { poke next element into AuxMsgBuff }
    FAuxMsgBuff[FAuxMsgBuffHead] :=AElement;
    { Position im Msg-Puffer belegen }
    AllocAuxMsgBuff;
  end;
end;

function TInputQueue.PokeInpMsgBuff(const AElement: TInpMsg): Boolean;
var
  LastElement: TInpMsg;
  Increment: Boolean;
begin
  { only necessary for interrupt safe access }
  asm
        PUSHF
        CLI
  end;
  { check for InpMsgBuff is full }
  Result :=FInpMsgBuffCount <InpMsgBuffSize;
  if Result then
  begin
    Increment :=False;

    { check for increment repeatcount in last message }
    if FInpMsgBuffCount >0 then
    begin
      LastElement :=FInpMsgBuff[FInpMsgLast];
      { TODO : Wozu ist das denn gut? }
//      TKeyData(TWMKey(LastElement.Msg).KeyData).RepeatCount :=1;
      if CompareMem(Addr(LastElement), Addr(AElement), SizeOf(TInpMsg)) then
      begin
        Inc(TKeyData(TWMKey(FInpMsgBuff[FInpMsgLast].Msg).KeyData).RepeatCount);
        Increment :=True;
      end;
    end;

    { default behaviour }
    if not Increment then
    begin
      { poke next element into InpMsgBuff }
      FInpMsgBuff[FInpMsgBuffHead] :=AElement;
      { Position im Msg-Puffer belegen }
      AllocInpMsgBuff;
    end;
  end;
  asm
        POPF
  end;
end;

procedure TInputQueue.TranslateMessage(Sender, Dest: TObject; var Msg:
    TMessage);
begin
  if (Msg.Msg = WM_KEYDOWN) or (Msg.Msg = WM_SYSKEYDOWN)
      or (Msg.Msg = WM_SYSKEYUP) then
    Keyboard.TranslateMessage(Msg);
end;

{
********************************** TKeyboard ***********************************
}
constructor TKeyboard.Create;
begin
  inherited Create;
  FAltGrLocked :=False;
  FCapitalShift :=DCapitalShift;
  FNonEnglish :=DNonEnglish;
  InitScanCodeMap;
end;

destructor TKeyboard.Destroy;
begin
  Done;
  inherited Destroy;
end;

procedure TKeyboard.Init;
var
  OldReg: Byte;
  Reg: Byte;
begin
  if not FEnabled then
  begin
    { disable keyboard interrupt }
    OldReg :=Port[IntControl];
    Reg :=OldReg or $02;
    Port[IntControl] :=Reg;
    try
      FKeyStatus :=BiosKeyStatus;
      if (FKeyStatus and SCROLL_LOCK) <>0 then
      begin
        FAsyncKeyboardState[VK_SCROLL] :=$01;
        FKeyboardState[VK_SCROLL] :=$01;
        FScrollLock :=True;
      end;
      if (FKeyStatus and NUM_LOCK) <>0 then
      begin
        FAsyncKeyboardState[VK_NUMLOCK] :=$01;
        FKeyboardState[VK_NUMLOCK] :=$01;
        FNumLock :=True;
      end;
      if (FKeyStatus and CAPS_LOCK) <>0 then
      begin
        FAsyncKeyboardState[VK_CAPITAL] :=$01;
        FKeyboardState[VK_CAPITAL] :=$01;
        FCapsLock :=True;
      end;
      //GetIntVec($9, FOldKeyboardHandler);
      //SetIntProc($9, KeyboardHandler);
    finally
      { restore keyboard interrupt }
      Port[IntControl] :=OldReg;
    end;
    FEnabled :=True;
  end;
end;

procedure TKeyboard.Done;
var
  OldReg: Byte;
  Reg: Byte;
begin
  if FEnabled then
  begin
    FEnabled :=False;
    { disable keyboard interrupt }
    OldReg :=Port[IntControl];
    Reg :=OldReg or $02;
    Port[IntControl] :=Reg;
    try
      //SetIntVec($9, FOldKeyboardHandler);
      BiosKeyStatus :=FKeyStatus;
      asm
          MOV     AH,1
          INT     16H
      end;
    finally
      { restore keyboard interrupt }
      Port[IntControl] :=OldReg;
    end;
  end;
end;

procedure TKeyboard.SetEnabled(const Value: Boolean);
begin
  if Value then Init else Done;
end;

function TKeyboard.AsyncKeyChecked(VirtualKeyEx: Integer): Boolean;
begin
  Result :=(FAsyncKeyboardState[VirtualKeyEx] and $01) <>0;
end;

function TKeyboard.AsyncKeyPressed(VirtualKeyEx: Integer): Boolean;
begin
  Result :=(FAsyncKeyboardState[VirtualKeyEx] and $80) <>0;
end;

procedure TKeyboard.GenerateKeyMessage(VirtualKeyEx: Integer; AKeyBoardKey: 
    Boolean);
var
  KeyData: Integer;
  VirtualKey: Integer;
begin
  if FPauseKey then
  begin
    { handle strange pause key }
    if FScanCode =$1D then
      Exit
    else if FScanCode =$45 then
      VirtualKeyEx :=VK_PAUSE
  end
  else
  begin
    { drop some old compatibility codes }
    if FExtendedKey and (FScanCode in [$2A, $36]) then
    begin
      FExtendedKey :=False;
      Exit;
    end;
  end;
  
  { update async keyboard state }
  SetAsyncKeyState(VirtualKeyEx);
  VirtualKey :=VirtualKeyExToVirtualKey(VirtualKeyEx);
  
  KeyData :=ScanToKeyData(FScanCode, FExtendedKey, FContextCode,
      FPreviousKeyState, FTransitionState);
  PostMessage(VirtualKey, VirtualKeyEx, KeyData, FTransitionState,
      AKeyBoardKey);
  FExtendedKey :=False;
  FPauseKey :=False;
end;

function TKeyboard.GetAsyncKeyState(VirtualKeyEx: Integer): SmallInt;
var
  KeyState: Byte;
begin
  KeyState :=FAsyncKeyboardState[VirtualKeyEx];
  Result :=(KeyState shl 8 or KeyState shr 1) and $8001;
  FAsyncKeyboardState[VirtualKeyEx] :=KeyState and $FD;
end;

function TKeyboard.GetKeyboardState: TKeyboardState;
begin
  Result :=FKeyboardState;
end;

function TKeyboard.GetKeyState(VirtualKeyEx: Integer): SmallInt;
var
  KeyState: ShortInt;
begin
  KeyState :=FKeyboardState[VirtualKeyEx];
  Result :=KeyState and $0001;
  if KeyState <0 then Result :=Word(Result) or $FF80;
end;

procedure TKeyboard.HandleInterrupt(ScanCode: Integer);
var
  VirtualKeyEx: Integer;
begin
  if ScanCode =$E0 then
    FExtendedKey :=True
  else if ScanCode =$E1 then
    { mark strange pause key }
    FPauseKey :=True
  else
  begin
    FTransitionState :=ScanCode >=$80;
    FScanCode :=ScanCode and $7F;
    { check keyboard error; e.g. too many keys }
    if not FScanCode in [$01..$5F] then Exit;
  
    VirtualKeyEx :=ScanCodeToVirtualKeyEx(FScanCode);
    GenerateKeyMessage(VirtualKeyEx, True);
  end;
end;

procedure TKeyboard.SetMouseState(AMsg: Cardinal);
var
  MouseKey: Integer;
  Transition: Boolean;
  KeyState: Byte;
  PreviousKeyState: Boolean;
begin
  case AMsg of
    WM_LBUTTONDOWN..WM_LBUTTONDBLCLK: MouseKey :=VK_LBUTTON;
    WM_RBUTTONDOWN..WM_RBUTTONDBLCLK: MouseKey :=VK_RBUTTON;
    WM_MBUTTONDOWN..WM_MBUTTONDBLCLK: MouseKey :=VK_MBUTTON;
  else
    Exit;
  end;
  Transition :=(AMsg =WM_LBUTTONUP) or (AMsg =WM_RBUTTONUP)
      or (AMsg =WM_MBUTTONUP);

  KeyState :=FKeyboardState[MouseKey];
  PreviousKeyState :=(KeyState and $80) <>0;
  if not Transition then
  begin
    if not PreviousKeyState then KeyState :=KeyState xor $01;
    KeyState :=KeyState or $80;
  end else KeyState :=KeyState and $7F;
  FKeyboardState[MouseKey] :=KeyState;
end;

function TKeyboard.HandleKeyMsg(var InpMsg: TInpMsg): Boolean;
var
  PreviousKeyState: Boolean;
  TransitionState: Boolean;
  ContextCode: Boolean;
  ExtendedKey: Boolean;
  SysState: Boolean;
  AVirtualKeyEx: Integer;
  ACharCode: Byte;
  KeyboardKey: Boolean;
  SetVirtualControl: Boolean;

  const
    MsgKind: array [Boolean, Boolean] of Integer =(
        (WM_KEYDOWN, WM_SYSKEYDOWN),
        (WM_KEYUP, WM_SYSKEYUP));

  procedure SetKeyState(VirtualKeyEx: Integer);
  var
    KeyState: Byte;
  begin
    KeyState :=FKeyboardState[VirtualKeyEx];
    if not TransitionState then
    begin
      if not PreviousKeyState then KeyState :=KeyState xor $01;
      KeyState :=KeyState or $80;
    end else KeyState :=KeyState and $7F;
    FKeyboardState[VirtualKeyEx] :=KeyState;
  end;

  procedure PostCapitalUp;
  var
    ScanCode: Integer;
    KeyData: LongInt;
  begin
    ScanCode :=MapVirtualKey(VK_CAPITAL, mtVirtualToScan);
    KeyData :=ScanToKeyData(ScanCode, False, ContextCode, True, True);
    PokeAuxMsg(WM_KEYUP, VK_CAPITAL, KeyData);
  end;
  
  procedure PostShiftDown;
  begin
    with InpMsg do
      with TWMKey(Msg), TKeyAuxData(AuxData) do
        PokeAuxMsg(Msg, VirtualKeyEx, KeyData);
  end;
  
  procedure CreateCapitalDown;
  var
    ScanCode: Integer;
  begin
    AVirtualKeyEx :=VK_CAPITAL;
    ACharCode :=AVirtualKeyEx;
    ExtendedKey :=False;
    TransitionState :=False;
    PreviousKeyState :=False;
    with TWMKey(InpMsg.Msg) do
    begin
      CharCode :=AVirtualKeyEx;
      ScanCode :=MapVirtualKey(AVirtualKeyEx, mtVirtualToScan);
      KeyData :=ScanToKeyData(ScanCode, False, ContextCode, False, False);
    end;
  end;
  
  procedure PostMenu;
  const
    MsgKind: array [Boolean] of Integer =(WM_KEYDOWN, WM_KEYUP);
  begin
    with InpMsg do
      with TWMKey(Msg), TKeyAuxData(AuxData) do
        PokeAuxMsg(MsgKind[TransitionState], VirtualKeyEx, KeyData);
  end;
  
  procedure CreateControl;
  var
    ScanCode: Integer;
  begin
    AVirtualKeyEx :=VK_CONTROL;
    ACharCode :=AVirtualKeyEx;
    ExtendedKey :=False;
    PreviousKeyState :=TransitionState;
    with TWMKey(InpMsg.Msg) do
    begin
      CharCode :=VK_CONTROL;
      ScanCode :=MapVirtualKey(CharCode, mtVirtualToScan);
      KeyData :=ScanToKeyData(ScanCode, ExtendedKey, KeyPressed(VK_MENU),
          PreviousKeyState, TransitionState);
    end;
  end;
  
  procedure HandleNumLockKeys;
  
    procedure CreateShiftUp;
    var
      ScanCode: Integer;
    begin
      AVirtualKeyEx :=VK_SHIFT;
      ACharCode :=AVirtualKeyEx;
      ExtendedKey :=False;
      TransitionState :=True;
      PreviousKeyState :=True;
      KeyboardKey :=False;
      with TWMKey(InpMsg.Msg) do
      begin
        CharCode :=VK_SHIFT;
        ScanCode :=MapVirtualKey(CharCode, mtVirtualToScan);
        KeyData :=ScanToKeyData(ScanCode, False, ContextCode, True, True);
      end;
    end;
  
    procedure CreateShiftDown;
    var
      ScanCode: Integer;
    begin
      AVirtualKeyEx :=VK_SHIFT;
      ACharCode :=AVirtualKeyEx;
      ExtendedKey :=False;
      TransitionState :=False;
      PreviousKeyState :=False;
      with TWMKey(InpMsg.Msg) do
      begin
        CharCode :=VK_SHIFT;
        ScanCode :=MapVirtualKey(CharCode, mtVirtualToScan);
        KeyData :=ScanToKeyData(ScanCode, False, ContextCode, False, False);
      end;
    end;
  
    procedure PostShiftDown;
    var
      ScanCode: Integer;
      KeyData: LongInt;
    begin
      ScanCode :=MapVirtualKey(VK_SHIFT, mtVirtualToScan);
      KeyData :=ScanToKeyData(ScanCode, False, ContextCode, False, False);
      PokeAuxMsg(WM_KEYDOWN, VK_SHIFT, KeyData);
    end;
  
    function NumToControlCode(CharCode: Integer): Integer;
    const
      MapNum: array[0..10] of Integer =(
          VK_INSERT, VK_END, VK_DOWN, VK_NEXT,
          VK_LEFT, VK_CLEAR, VK_RIGHT, VK_HOME,
          VK_UP, VK_PRIOR, VK_DELETE);
  
    var
      LCharCode: Integer;
    begin
      if CharCode =VK_DECIMAL then LCharCode :=10
      else
        LCharCode :=CharCode -VK_NUMPAD0;
      if LCharCode in [0..10] then
        Result :=MapNum[LCharCode]
      else
        Result :=CharCode;
    end;

    procedure CreateControl(CharCode: Integer);
    var
      ScanCode: Integer;
    begin
      AVirtualKeyEx :=NumToControlCode(CharCode);
      ACharCode :=AVirtualKeyEx;
      ExtendedKey :=False;
      with TWMKey(InpMsg.Msg) do
      begin
        CharCode :=AVirtualKeyEx;
        ScanCode :=MapVirtualKey(CharCode, mtVirtualToScan);
        KeyData :=ScanToKeyData(ScanCode, False, ContextCode,
            PreviousKeyState, TransitionState);
      end;
    end;
  
    procedure PostControl(ACharCode: Integer);
    const
      MsgMap: array[Boolean] of Integer =(WM_KEYDOWN, WM_KEYUP);
    var
      ScanCode: Integer;
      KeyData: LongInt;
    begin
      ACharCode :=NumToControlCode(ACharCode);
      ScanCode :=MapVirtualKey(ACharCode, mtVirtualToScan);
      KeyData :=ScanToKeyData(ScanCode, False, ContextCode, PreviousKeyState,
          TransitionState);
      PokeAuxMsg(MsgMap[TransitionState], ACharCode, KeyData);
      if not TransitionState then FPostedCharCode :=ACharCode;
    end;
  
    procedure PostKey;
    var
      ScanCode: Integer;
      KeyData: LongInt;
    begin
      ScanCode :=MapVirtualKey(AVirtualKeyEx, mtVirtualToScan);
      KeyData :=ScanToKeyData(ScanCode, ExtendedKey, ContextCode,
          PreviousKeyState, TransitionState);
      PokeAuxMsg(WM_KEYDOWN, ACharCode, KeyData);
    end;
  
  begin
    if FShiftLocked then
    begin
      if TransitionState then
      begin
        CreateControl(ACharCode);
        PostShiftDown;
        FShiftLocked :=False;
      end
      else
      begin
        if PreviousKeyState then
          CreateControl(ACharCode)
        else
        begin
          if ACharCode =FPostedCharCode then FPostedCharCode :=0
          else
          begin
            PostKey;
            CreateShiftDown;
            FShiftLocked :=False; // ???
          end;
        end;
      end;
    end
    else
    begin
      if KeyPressed(VK_SHIFT)
          and (ACharCode in [VK_NUMPAD0..VK_NUMPAD9, VK_DECIMAL]) then
      begin
        if TransitionState then
        begin
          PostControl(ACharCode);
          PostShiftDown;
          CreateShiftUp;
        end
        else
        begin
          PostControl(ACharCode);
          CreateShiftUp;
          FShiftLocked :=True;
        end;
      end;
    end;
  end;
  
begin
  Result :=False;
  SetVirtualControl :=False;
  with InpMsg do
  begin
    with TKeyAuxData(AuxData) do
    begin
      AVirtualKeyEx :=VirtualKeyEx;
      KeyboardKey :=IsKeyboardKey;
    end;
    with TWMKey(Msg) do
    begin
      with TKeyData(KeyData) do
      begin
        PreviousKeyState :=kfPreviousKeyState in KeyFlags;
        TransitionState :=kfTransitionState in KeyFlags;
        ContextCode :=kfContextCode in KeyFlags;
        ExtendedKey :=kfExtendedKey in KeyFlags;
      end;
      ACharCode :=CharCode;
    end;

    HandleNumLockKeys;

    { handle alt-gr special keys like @, µ, { etc. at }
    if FNonEnglish then
    begin
      if (AVirtualKeyEx =VK_RMENU) and KeyboardKey
          and (not KeyPressed(VK_CONTROL) or FAltGrLocked) then
      begin
        if FAltGrLocked then
        begin
          if TransitionState then FAltGrLocked :=False
          else Exit;
        end
        else FAltGrLocked :=True;
        if not KeyPressed(VK_CONTROL) or FVirtualControl then
        begin
          PostMenu;
          CreateControl;
          ACharCode :=VK_CONTROL;
          AVirtualKeyEx :=ACharCode;
          SetVirtualControl :=not TransitionState;
          if SetVirtualControl then FAltGrLocked :=True;
        end;
      end;
    end;

    if FCapitalShift and KeyboardKey then
    begin
      case ACharCode of
        VK_CAPITAL:
        begin
          if CapsLock or TransitionState then Exit;
          PostCapitalUp;
        end;
        VK_SHIFT:
        if CapsLock and not TransitionState then
        begin
          PostCapitalUp;
          PostShiftDown;
          CreateCapitalDown;
          ACharCode :=VK_CAPITAL;
          AVirtualKeyEx :=ACharCode;
        end;
      end;
    end;
  
    SetKeyState(ACharCode);
    if ACharCode in [VK_SHIFT, VK_CONTROL, VK_MENU] then
    begin
      if AVirtualKeyEx <>VK_NULL then
        SetKeyState(AVirtualKeyEx);
      if ACharCode =VK_CONTROL then
        FVirtualControl :=False;
    end;
  
    SysState :=(ACharCode =VK_F10) or (((ACharCode =VK_MENU)
        or KeyPressed(VK_MENU)) and not KeyPressed(VK_CONTROL)
        and (ACharCode <>VK_CONTROL));
  
    with TWMKey(InpMsg.Msg) do
      Msg :=MsgKind[TransitionState, SysState];
  
    if SetVirtualControl then
      FVirtualControl :=True;
  
    { no keyup while any shift key pressed }
    Result := not TransitionState or not KeyboardKey or (ACharCode <>VK_SHIFT)
        or not (KeyPressed(VK_LSHIFT) or KeyPressed(VK_RSHIFT))
  end;
end;

procedure TKeyboard.InitScanCodeMap;
var
  I: Integer;
begin
  for I :=1 to 93 do
    FScanCodeMap[windows.mapVirtualKey(I,0)] :=I;
  for I :=1 to 13 do
    FScanCodeMap[VirtualNumKey[I]] :=I +70;
  FScanCodeMap[VK_MULTIPLY] :=55;
  FScanCodeMap[VK_CANCEL] :=FScanCodeMap[VK_SCROLL];
  FScanCodeMap[VK_SHIFT] :=FScanCodeMap[VK_LSHIFT];
  FScanCodeMap[VK_CONTROL] :=FScanCodeMap[VK_LCONTROL];
  FScanCodeMap[VK_MENU] :=FScanCodeMap[VK_LMENU];
end;

function TKeyboard.KeyChecked(VirtualKeyEx: Integer): Boolean;
begin
  Result :=(FKeyboardState[VirtualKeyEx] and $01) <>0;
end;

procedure TKeyboard.KeyEvent(VirtualKeyEx: Integer; ScanCode: Byte; Flags: 
    TKeyEvents);
var
  OldReg: Byte;
  Reg: Byte;
  OldExtendedKey: Boolean;
  OldPauseKey: Boolean;
begin
  { disable keyboard interrupt }
  OldReg :=Port[IntControl];
  Reg :=OldReg or $02;
  Port[IntControl] :=Reg;
  OldExtendedKey :=FExtendedKey;
  OldPauseKey :=FPauseKey;
  try
    FExtendedKey :=keExtendedKey in Flags;
    FTransitionState :=keKeyUp in Flags;
    FScanCode :=ScanCode;
    GenerateKeyMessage(VirtualKeyEx, False);
  finally
    FExtendedKey :=OldExtendedKey;
    FPauseKey :=OldPauseKey;
    Port[IntControl] :=OldReg;
  end;
end;

function TKeyboard.KeyPressed(VirtualKeyEx: Integer): Boolean;
begin
  Result :=(FKeyboardState[VirtualKeyEx] and $80) <>0;
end;

function TKeyboard.MapVirtualKey(Code: Integer; MapType: TMapType): Integer;
begin
  case MapType of
    mtVirtualToScan:
      Result :=VirtualKeyExToScanCode(Code);
    mtScanToVirtual:
    begin
      Code :=ScanCodeToVirtualKeyEx(Code);
      Result :=VirtualKeyExToVirtualKey(Code);
    end;
    mtVirtualToChar:
      Result :=VirtualKeyExToCharCode(Code);
    mtScanToVirtualEx:
      Result :=ScanCodeToVirtualKeyEx(Code);
  else
    Result :=0;
  end;
end;

procedure TKeyboard.PokeAuxMsg(AMsg: Cardinal; AVirtualKeyEx: Word; AKeyData: 
    Integer);
var
  InpMsg: TInpMsg;
begin
  with InpMsg do
  begin
    with TWMKey(Msg) do
    begin
      Msg :=AMsg;
      CharCode :=VirtualKeyExToVirtualKey(AVirtualKeyEx);
      Unused :=0;
      KeyData :=AKeyData;
      Result :=0;
    end;
    with TKeyAuxData(AuxData) do
    begin
      VirtualKeyEx :=AVirtualKeyEx;
      IsKeyboardKey :=False;
    end;
  end;
  InputQueue.PokeAuxMsgBuff(InpMsg);
end;

procedure TKeyboard.PostMessage(AVirtualKey, AVirtualKeyEx, AKeyData: Integer; 
    TransitionState, AKeyBoardKey: Boolean);
  
  const
    MessageType: array[Boolean] of Integer =
        (WM_KEYDOWN, WM_KEYUP);
  var
    MsgKind: Cardinal;
    InpMsg: TInpMsg;
  
begin
  MsgKind :=MessageType[TransitionState];
  with InpMsg do
  begin
    with TWMKey(Msg) do
    begin
      Msg :=MsgKind;
      CharCode :=AVirtualKey;
      Unused :=0;
      KeyData :=AKeyData;
      Result :=0;
    end;
    with TKeyAuxData(AuxData) do
    begin
      VirtualKeyEx :=AVirtualKeyEx;
      IsKeyboardKey :=AKeyBoardKey;
    end;
  end;
  InputQueue.PokeInpMsgBuff(InpMsg);
end;

function TKeyboard.ScanCodeToVirtualKeyEx(ScanCode: Integer): Integer;
var
  FNumCode: Integer;
begin
  if ScanCode in [1..93] then
    if AsyncKeyChecked(VK_NUMLOCK) and not FExtendedKey
        and (ScanCode in [55, 71..83]) then
    begin
      if ScanCode =55 then FNumCode :=0
      else FNumCode :=ScanCode -70;
      Result :=VirtualNumKey[FNumCode];
    end
    else Result :=windows.mapVirtualKey(ScanCode,0)
  else
    Result :=VK_UNKNOWN;
    if FExtendedKey then
    begin
      if Result =VK_SCROLL then
        Result :=VK_CANCEL { handle ctrl-break }
      else if Result =VK_MULTIPLY then
        Result :=VK_PRINT { handle prntscr }
      else if Result =VK_OEM_MINUS then
        Result :=VK_DIVIDE { handle gray divide }
      else if Result =VK_LMENU then
        Result :=VK_RMENU { handle altgr }
      else if Result =VK_LCONTROL then
        Result :=VK_RCONTROL { handle right ctrl }
    end;
    if Result =VK_NUMLOCK then
      FExtendedKey :=True; { VK_NUMLOCK is an extended key }
end;

function TKeyboard.ScanToKeyData(AScanCode: Integer; ExtendedKey, ContextCode, 
    PreviousKeyState, TransitionState: Boolean): Integer;
var
  KeyData: TKeyData absolute Result;
begin
  with KeyData do
  begin
    KeyFlags :=[];
    if ExtendedKey then Include(KeyFlags, kfExtendedKey);
    if ContextCode then Include(KeyFlags, kfContextCode);
    if PreviousKeyState then Include(KeyFlags, kfPreviousKeyState);
    if TransitionState then Include(KeyFlags, kfTransitionState);
    ScanCode :=AScanCode;
    RepeatCount :=1;
  end;
end;

function TKeyboard.SendKeyboard(Data: Byte): Boolean;
var
  I: Integer;
begin
  Result :=True;
  for I :=0 to 2 do
  begin
    while (Port[StatusPort] and IB_FULL) <>0 do;
    Port[DataPort] :=Data;
    while (Port[StatusPort] and OB_FULL) =0 do;
    if Port[DataPort] = ACK_SIGNAL then Exit;
  end;
  Result :=False;
end;

procedure TKeyboard.SetAsyncMouseState(AMsg: Cardinal);
var
  MouseKey: Integer;
  Transition: Boolean;
  KeyState: Byte;
  PreviousKeyState: Boolean;
begin
  case AMsg of
    WM_LBUTTONDOWN..WM_LBUTTONDBLCLK: MouseKey :=VK_LBUTTON;
    WM_RBUTTONDOWN..WM_RBUTTONDBLCLK: MouseKey :=VK_RBUTTON;
    WM_MBUTTONDOWN..WM_MBUTTONDBLCLK: MouseKey :=VK_MBUTTON;
  else
    Exit;
  end;
  Transition :=(AMsg =WM_LBUTTONUP) or (AMsg =WM_RBUTTONUP)
      or (AMsg =WM_MBUTTONUP);

  KeyState :=FAsyncKeyboardState[MouseKey];
  PreviousKeyState :=(KeyState and $80) <>0;
  if not Transition then
  begin
    if not PreviousKeyState then KeyState :=KeyState xor $01;
    KeyState :=KeyState or $80;
  end else KeyState :=KeyState and $7F;
  FAsyncKeyboardState[MouseKey] :=KeyState or $02;  { mark changed key }
end;

procedure TKeyboard.SetAsyncKeyState(VirtualKeyEx: Integer);
var
  KeyState: Byte;
begin
  KeyState :=FAsyncKeyboardState[VirtualKeyEx];
  FPreviousKeyState :=(KeyState and $80) <>0;
  if not FTransitionState then
  begin
    if not FPreviousKeyState then KeyState :=KeyState xor $01;
    KeyState :=KeyState or $80;
  end else KeyState :=KeyState and $7F;
  FAsyncKeyboardState[VirtualKeyEx] :=KeyState or $02;  { mark changed key }

  case VirtualKeyEx of
    VK_LSHIFT, VK_RSHIFT:
      if not (FTransitionState
          and (AsyncKeyPressed(VK_LSHIFT) or AsyncKeyPressed(VK_RSHIFT))) then
        SetAsyncKeyState(VK_SHIFT);
    VK_LCONTROL, VK_RCONTROL:
        SetAsyncKeyState(VK_CONTROL);
    VK_LMENU, VK_RMENU:
        SetAsyncKeyState(VK_MENU);
  end;

  FContextCode :=AsyncKeyPressed(VK_MENU);
end;

function TKeyboard.SetIndicators(const AScrollLock, ANumLock, ACapsLock: 
    Boolean): Boolean;
var
  OldKeyStatus: Byte;
begin
  OldKeyStatus :=FKeyStatus;
  FKeyStatus :=FKeyStatus and not(SCROLL_LOCK or NUM_LOCK or CAPS_LOCK);
  if AScrollLock then FKeyStatus :=FKeyStatus or SCROLL_LOCK;
  if ANumLock then FKeyStatus :=FKeyStatus or NUM_LOCK;
  if ACapsLock then FKeyStatus :=FKeyStatus or CAPS_LOCK;
  Result :=UpdateIndicator;
  if not Result then
    FKeyStatus :=OldKeyStatus
  else
  begin
    FScrollLock :=AScrollLock;
    FNumLock :=ANumLock;
    FCapsLock :=ACapsLock;
  end;
end;

procedure TKeyboard.SetKeyboardState(const KeyboardState: TKeyboardState);
begin
  FKeyboardState :=KeyboardState;
end;

function TKeyboard.SetLockState(Index: Integer; Value: Boolean): Boolean;
var
  Key: Byte;
  OldKeyStatus: Byte;
begin
  Result :=True;
  OldKeyStatus :=FKeyStatus;
  Key :=$10 shl Index;
  if Value then FKeyStatus :=FKeyStatus or Key
  else FKeyStatus :=FKeyStatus and not Key;
  if UpdateIndicator then Exit;
  FKeyStatus :=OldKeyStatus;
  Result :=False;
end;

function TKeyboard.SetTypematic(Delay: TKeyboardDelay; Speed: TKeyboardSpeed): 
    Boolean;
var
  TypeMatic: Byte;
  OldReg: Byte;
  Reg: Byte;
begin
  Result :=False;
  TypeMatic :=Delay shl 5 or Speed;
  { disable keyboard interrupt }
  OldReg :=Port[IntControl];
  Reg :=OldReg or $02;
  Port[IntControl] :=Reg;
  try
    if not SendKeyboard(SET_TYPEMATIC) then Exit;
    if not SendKeyboard(TypeMatic) then Exit;
    FDelay :=Delay;
    FSpeed :=Speed;
    Result :=True;
  finally
    Port[IntControl] :=OldReg;
  end;
end;

procedure TKeyboard.TranslateMessage(var Msg: TMessage);

  const
    MsgKind: array[Boolean, Boolean] of Integer =(
        (WM_CHAR, WM_DEADCHAR), (WM_SYSCHAR, WM_SYSDEADCHAR));
  type
    TShiftKeyState =(sksNone, sksShift, sksCtrl, sksAltGr);
  var
    ShiftKeyState: TShiftKeyState;
    LCharCode: Integer;
    LKeyData: Integer;
    LSysState: Boolean;
    LDeadChar: Boolean;
    LMsg: Integer;
    LDiacNum: Integer;
    Ch: Integer;
  
    procedure HandleNumBlockChar;
    var
      Ch: Byte;
      Code: Integer;
      CharCode: Integer;
    begin
      if Length(FNumber) >0 then
      begin
        Val(FNumber, Ch, Code);
        if (Code <>0) or (Ch =0) then Exit;
        if FNumber[1] ='0' then
          CharCode :=Ch
        else
         // CharCode :=Ord(OemCharToChar(Chr(Ch)));
          CharCode :=Ord(OemKeyScan((Ch)));

        windows.PostMessage(application.handle, WM_CHAR, CharCode, TWMKey(Msg).KeyData);
      end;
    end;
  
begin
  { initialize }
  LDeadChar :=False;

  if Msg.Msg =WM_SYSKEYUP then
  begin
    if Msg.WParam =VK_MENU then
    begin
      HandleNumBlockChar;
      FNumber :='';
    end;
    Exit;
  end;

  if KeyPressed(VK_CONTROL) then
  begin
    if KeyPressed(VK_MENU) then
      ShiftKeyState :=sksAltGr
    else
      ShiftKeyState :=sksCtrl
  end
  else if FNonEnglish and
      (KeyChecked(VK_CAPITAL) or KeyPressed(VK_SHIFT)) then
    ShiftKeyState :=sksShift
  else if not FNonEnglish and KeyPressed(VK_SHIFT) then
    ShiftKeyState :=sksShift
  else
    ShiftKeyState :=sksNone;

  with TWMKey(Msg) do
  begin
    LSysState :=(Msg =WM_SYSKEYDOWN);
    LCharCode :=CharCode and $FF;
    LKeyData :=KeyData;
  end;
  
  if not FNonEnglish then
  begin
    if KeyChecked(VK_CAPITAL) and (Chr(LCharCode) in ['A'..'Z']) then
      case ShiftKeyState of
        sksShift:
          ShiftKeyState :=sksNone;
        sksNone:
          ShiftKeyState :=sksShift;
      end;
  end;

  if (ShiftKeyState in [sksNone, sksShift]) and LSysState then
  begin
    Ch :=-1;
    if LCharCode in [VK_NUMPAD0..VK_NUMPAD9] then
      Ch :=LCharCode -VK_NUMPAD0
    else
    begin
      case LCharCode of
        VK_INSERT: Ch :=0;
        VK_END:    Ch :=1;
        VK_DOWN:   Ch :=2;
        VK_NEXT:   Ch :=3;
        VK_LEFT:   Ch :=4;
        VK_CLEAR:  Ch :=5;
        VK_RIGHT:  Ch :=6;
        VK_HOME:   Ch :=7;
        VK_UP:     Ch :=8;
        VK_PRIOR:  Ch :=9;
      end;
    end;
  
    if Ch >=0 then
    begin
      FNumber :=FNumber +Chr(Ch +Ord('0'));
      Exit;
    end;
  end;
  
  FNumber :='';
  
  case ShiftKeyState of
    sksNone:
      LCharCode :=Ord(KeyMap[LCharCode]);
    sksShift:
      LCharCode :=Ord(ShiftKeyMap[LCharCode]);
    sksCtrl:
      LCharCode :=Ord(CtrlKeyMap[LCharCode]);
    sksAltGr:
    begin
      if FNonEnglish then
        LCharCode :=Ord(AltGrKeyMap[LCharCode])
      else
        LCharCode :=0;
    end;
  end;
  
  if (LCharCode <>0) and (FDiacriticsChar <>0)
      and (ShiftKeyState <>sksCtrl) then
  begin
    { determine message kind }
    LMsg :=MsgKind[LSysState, False];

    { map diacritic char to ordinal number }
    case Chr(FDiacriticsChar) of
      '´': LDiacNum :=0;
      '`': LDiacNum :=1;
      '^': LDiacNum :=2;
    else
      LDiacNum :=0;
    end;

    { transform diacritic character }
    case Chr(LCharCode) of
      ' ': LCharCode :=FDiacriticsChar;
      'A': LCharCode :=Ord(Diac_UpA[LDiacNum]);
      'E': LCharCode :=Ord(Diac_UpE[LDiacNum]);
      'I': LCharCode :=Ord(Diac_UpI[LDiacNum]);
      'O': LCharCode :=Ord(Diac_UpO[LDiacNum]);
      'U': LCharCode :=Ord(Diac_UpU[LDiacNum]);
      'a': LCharCode :=Ord(Diac_LoA[LDiacNum]);
      'e': LCharCode :=Ord(Diac_LoE[LDiacNum]);
      'i': LCharCode :=Ord(Diac_LoI[LDiacNum]);
      'o': LCharCode :=Ord(Diac_LoO[LDiacNum]);
      'u': LCharCode :=Ord(Diac_LoU[LDiacNum]);
    else
      windows.PostMessage(Application.Handle, LMsg, FDiacriticsChar, LKeyData);
    end;
    windows.PostMessage(Application.Handle, LMsg, LCharCode, LKeyData);
    FDiacriticsChar :=0;
    LCharCode :=0;
  end;

  if LCharCode <>0 then
  begin
    if Chr(LCharCode) in Diacritics then
    begin
      FDiacriticsChar :=LCharCode;
      LDeadChar :=True;
    end;
    LMsg :=MsgKind[LSysState, LDeadChar];
    Windows.PostMessage(Application.handle, LMsg, LCharCode, LKeyData);
  end;

  { hack for Windows NT }
  if not WinNT then
  begin
    { update keyboard LED display }
    ScrollLock :=KeyChecked(VK_SCROLL);
    NumLock :=KeyChecked(VK_NUMLOCK);
    CapsLock :=KeyChecked(VK_CAPITAL);
  end;
end;

function TKeyboard.UpdateIndicator: Boolean;
var
  Indicator: Byte;
  OldReg: Byte;
  Reg: Byte;
begin
  Result :=False;
  Indicator :=FKeyStatus shr 4 and $07;
  { disable keyboard interrupt }
  OldReg :=Port[IntControl];
  Reg :=OldReg or $02;
  Port[IntControl] :=Reg;
  try
    if not SendKeyboard(SET_INDICATOR) then Exit;
    if not SendKeyboard(Indicator) then Exit;
    Result :=True;
  finally
    Port[IntControl] :=OldReg;
  end;
end;

function TKeyboard.VirtualKeyExToCharCode(VirtualKeyEx: Integer): Integer;
var
  AChar: Char;
begin
  AChar :=ShiftKeyMap[VirtualKeyEx and $FF];
  Result :=Ord(AChar);
  if AChar in Diacritics then
    Result :=Result or $8000;
end;

function TKeyboard.VirtualKeyExToScanCode(VirtualKeyEx: Integer): Integer;
begin
  Result :=FScanCodeMap[VirtualKeyEx and $FF];
end;

function TKeyboard.VirtualKeyExToVirtualKey(VirtualKeyEx: Integer): Integer;
begin
  case VirtualKeyEx of
    VK_LSHIFT: Result :=VK_SHIFT;
    VK_RSHIFT: Result :=VK_SHIFT;
    VK_LCONTROL: Result :=VK_CONTROL;
    VK_RCONTROL: Result :=VK_CONTROL;
    VK_LMENU: Result :=VK_MENU;
    VK_RMENU: Result :=VK_MENU;
  else
    Result :=VirtualKeyEx;
  end;
  if AsyncKeyPressed(VK_CONTROL) then
    case VirtualKeyEx of
      VK_SCROLL:
        Result :=VK_CANCEL;
      VK_NUMLOCK:
        Result :=VK_PAUSE;
    end;
end;

procedure TKeyboard.SetCapsLock(Value: Boolean);
begin
  if Value <>FCapsLock then
  begin
    SetLockState(2, Value);
    FCapsLock :=Value;
  end;
end;

procedure TKeyboard.SetDelay(const Value: TKeyboardDelay);
begin
  if Value <>FDelay then
    SetTypematic(Value, FSpeed);
end;

procedure TKeyboard.SetNumLock(Value: Boolean);
begin
  if Value <>FNumLock then
  begin
    SetLockState(1, Value);
    FNumLock :=Value;
  end;
end;

procedure TKeyboard.SetScrollLock(Value: Boolean);
begin
  if Value <>FScrollLock then
  begin
    SetLockState(0, Value);
    FScrollLock :=Value;
  end;
end;

procedure TKeyboard.SetSpeed(const Value: TKeyboardSpeed);
begin
  if Value <>FSpeed then
    SetTypematic(FDelay, Value);
end;

function TrueDosVersion: Word; register; assembler;
asm
        PUSH    EBX
        MOV     EAX,3306H
	INT     21H
        MOV     EAX,EBX
	POP     EBX
end;

{
******************************************** TMouse ****************************
}

const
  MouseStackSize = $1000;

var
  DataSelector: Word;
  Ticks: Word; // absolute $46C;
  MouseStack: array [0..MouseStackSize -1] of Byte;

procedure MouseInt; assembler;
asm
        PUSH    DS
	MOV	DS,CS:DataSelector
	MOVZX	ESI,CX
        MOVZX   EDX,DX
	MOV	CL,3
	SHR	ESI,CL
	SHR	EDX,CL
      	MOV	DI,Ticks
        MOV     EAX,Mouse
	MOV	TMouse2[EAX].FButtons,BL
	MOV	TMouse2[EAX].FWhere.X,ESI
	MOV	TMouse2[EAX].FWhere.Y,EDX
        MOV     TMouse2[EAX].FTicks,DI
	PUSH	GS
	PUSH	FS
	PUSH	ES
	MOV	EDX,SS
	MOV	EAX,ESP
	PUSH	DS
	POP	SS
	MOV	ECX,OFFSET MouseStack
        ADD     ECX,MouseStackSize
	MOV	ESP,ECX
	PUSH	EDX
	MOV	EDX,DS
	MOV	FS,EDX
	MOV	ES,EDX
	PUSH	EAX
        MOV     EAX,Mouse
        CALL    TMouse2.HandleCallback
	DB	0FH,0B2H,24H,24H // LSS ESP,[ESP]
	POP	ES
	POP	FS
	POP	GS
	POP     DS
        RETF
end;

constructor TMouse2.Create;
begin
  inherited Create;
  FDoubleDelay :=8;
  FButtonCount :=DetectMouse;
end;

destructor TMouse2.Destroy;
begin
  Done;
  inherited Destroy;
end;

procedure TMouse2.Done;
begin
  if FEnabled then
  begin
    FEnabled :=False;
    if FButtonCount =0 then Exit;
    asm
        PUSH    EAX
        MOV     AX,2
        INT     33H
	MOV	AX,12
	XOR	CX,CX
	XOR	EDX,EDX
        PUSH    ES
	MOV	ES,CX
	INT	33H
        POP     ES
        MOV     AX,0
        INT     33H
        POP     EAX
    end;
  end;
end;

procedure TMouse2.PokeMessage(AMsg: Cardinal; AKeys: Integer; APos: TPoint);
var
  InpMsg: TInpMsg;
begin
  { generate MS mouse key flags }
  if AKeys and MK_SHIFT <>0 then
    AKeys :=AKeys or MK_MBUTTON;
  AKeys :=AKeys and (MK_LBUTTON or MK_RBUTTON or MK_MBUTTON);
  { add keyboard key flags }
  if Keyboard.AsyncKeyPressed(VK_SHIFT) then
    AKeys :=AKeys or MK_SHIFT;
  if Keyboard.AsyncKeyPressed(VK_CONTROL) then
    AKeys :=AKeys or MK_CONTROL;
  { syncronize keyboard state }
  Keyboard.SetAsyncMouseState(AMsg);

  with InpMsg do
  begin
    AuxData :=0;
    with TWMMouse(Msg) do
    begin
      Msg :=AMsg;
      Keys :=AKeys;
      XPos :=APos.X;
      YPos :=APos.Y;
    end;
  end;
  if Assigned(InputQueue) then
    InputQueue.PokeInpMsgBuff(InpMsg);
end;

procedure TMouse2.HandleCallback;
var
  ChangedButtons: Integer;
  MouseMask: Integer;
  I: Integer;

  const
    DownMessage: array[0..2] of Cardinal
        =(WM_LBUTTONDOWN, WM_RBUTTONDOWN, WM_MBUTTONDOWN);
    UpMessage: array[0..2] of Cardinal
        =(WM_LBUTTONUP, WM_RBUTTONUP, WM_MBUTTONUP);
    DoubleMessage: array[0..2] of Cardinal
        =(WM_LBUTTONDBLCLK, WM_RBUTTONDBLCLK, WM_MBUTTONDBLCLK);
    ButtonMask: array[Boolean, 0..2] of Byte
        =((1, 2, 4), (2, 1, 4));

begin
  if not FEnabled then Exit;
  if FButtons <> FLastButtons then
  begin
    ChangedButtons :=FButtons xor FLastButtons;
    for I :=0 to 2 do
    begin
      MouseMask :=ButtonMask[FReverse, I];
      if (ChangedButtons and MouseMask) <>0 then
        if FButtons and MouseMask <>0 then
        begin
          if not FLastDouble[I]
              and (FTicks < (FDownTicks[I] +FDoubleDelay)) then
          begin
            PokeMessage(DoubleMessage[I], FButtons, FWhere);
            FLastDouble[I] :=True;
          end
          else
          begin
            PokeMessage(DownMessage[I], FButtons, FWhere);
            FLastDouble[I] :=False;
          end;
          FDownTicks[I] :=FTicks;
        end
        else
          PokeMessage(UpMessage[I], FButtons, FWhere);
    end;
  end
  else
    if (FWhere.X <> FLastWhere.X) or (FWhere.Y <> FLastWhere.Y) then
      PokeMessage(WM_MOUSEMOVE, FButtons, FWhere);

  { store values for next test }
  FLastButtons :=FButtons;
  FLastWhere :=FWhere;
end;

procedure TMouse2.Init;
begin
  if not Enabled then
  begin
    if ButtonCount =0 then Exit;
    FEnabled :=True;
    FVisible :=True;
    asm
        PUSH    EBX
        MOV	AX,3
        INT	33H
        MOVZX   EAX,CX
        MOVZX   EDX,DX
        MOV	CL,3
        SHR	EAX,CL
        SHR	EDX,CL
        MOV     ECX,EAX
        MOV     EAX,Self
        MOV	TMouse2[EAX].FButtons,BL
        MOV	TMouse2[EAX].FWhere.X,ECX
        MOV	TMouse2[EAX].FWhere.Y,EDX
        MOV	AX,12
        MOV	CX,0FFFFH
        MOV	EDX, OFFSET MouseInt
        PUSH    ES
        PUSH	CS
        POP	ES
        INT	33H
        POP     ES
        MOV     AX,1
        INT     33H
        POP     EBX
    end;
  end;
end;

procedure TMouse2.Show;
begin
  if ButtonCount =0 then Exit;
  if not FEnabled or FVisible then Exit;
  FVisible :=True;
  asm
        PUSH    EAX
	MOV	AX,1
	INT	33H
        POP     EAX
  end;
end;

procedure TMouse2.Hide;
begin
  if ButtonCount =0 then Exit;
  if not FEnabled or not FVisible then Exit;
  FVisible :=False;
  asm
        PUSH    EAX
	MOV	AX,2
	INT	33H
        POP     EAX
  end;
end;

function TMouse2.DetectMouse: Byte; assembler;
asm
        MOV     DataSelector,DS
        PUSH    EBX
        PUSH    ES
	MOV	AX,3533H
	INT	21H
	MOV	AX,ES
	OR	AX,BX
	JE	@@1
	XOR	AX,AX
	INT	33H
	OR	AX,AX
	JE	@@1
	PUSH	BX
	MOV	AX,4
	XOR	CX,CX
	XOR	DX,DX
	INT	33H
	POP	AX
@@1:    POP     ES
        POP     EBX
end;

procedure TMouse2.SetScreenSize(Width, Height: Byte); register; assembler;
asm
	CMP	[EAX].FButtonCount,0
	JE	@@2
	CMP	[EAX].FEnabled,0
	JE	@@2
	MOV	AX,7
        PUSH    ECX
	CALL	@@1
        POP     EDX
	MOV	AX,8
@@1:	XOR	DH,DH
	SHL	DX,3
	DEC	DX
	XOR	CX,CX
	INT	33H
@@2:
end;

procedure TMouse2.SetEnabled(const Value: Boolean);
begin
  if Value then Init else Done;
end;

(*initialization
  WinNT :=TrueDosVersion =$3205; { check for OS Windows NT DOS Ver. 5.50 }

finalization
  FreeAndNil(Mouse);
  *)
end.

