{-------------------------------------------------------------------------------

  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is DIUtils.pas.

  The Initial Developer of the Original Code is Ralf Junker, Yunqa

  E-Mail:    delphi@yunqa.de
  Internet:  http://www.yunqa.de

  All Rights Reserved.

-------------------------------------------------------------------------------}

unit DIUtils;

//{$I DICompilers.inc}

{$IFDEF Unicode}
{$DEFINE DI_No_Win_9X_Support}
{$ENDIF Unicode}
 {$DEFINE MSWINDOWS}
 {$DEFINE COMPILER_4_UP}
 {$DEFINE SUPPORTS_INT64}
 {$DEFINE SUPPORTS_OVERLOAD}




interface

uses
  //DISystemCompat,
  {$IFDEF HAS_UNITSCOPE}
  System.SysUtils{$IFDEF MSWINDOWS}, Winapi.Windows, Winapi.ShlObj{$ENDIF}
  {$ELSE HAS_UNITSCOPE}
  SysUtils{$IFDEF MSWINDOWS}, Windows, ShlObj{$ENDIF}
  {$ENDIF HAS_UNITSCOPE};

type

  TDITextLineBreakStyle = (tlbsLF, tlbsCRLF, tlbsCR);
  UnicodeString = Widestring;
  PUtf8Char = Pansichar;
  RawByteString = AnsiString;


const

  CRLF = #$0D#$0A;

  NUM_TO_HEX: array[0..$F] of Char = (
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');

  DOS_PATH_DELIMITER = '\';

  UNIX_PATH_DELIMITER = '/';

  PATH_DELIMITER = DOS_PATH_DELIMITER;

  CHAR_NULL = #$00;

  CHAR_TAB = #$09;

  CHAR_LF = #$0A;

  CHAR_CR = #$0D;

  CHAR_SPACE = #$20;

  CHAR_ASTERISK = #$2A;

  CHAR_FULL_STOP = #$2E;

  CHAR_EQUALS_SIGN = #$3D;

  CHAR_QUESTION_MARK = #$3F;

  AC_NULL = AnsiChar(#$00);
  AC_TAB = AnsiChar(#$09);

  AC_LF = AnsiChar(#$000A);

  AC_CR = AnsiChar(#$000D);

  AC_SPACE = AnsiChar(#$20);

  AC_EXCLAMATION_MARK = AnsiChar(#$21);

  AC_QUOTATION_MARK = AnsiChar(#$22);

  AC_NUMBER_SIGN = AnsiChar(#$23);

  AC_DOLLAR_SIGN = AnsiChar(#$24);

  AC_PERCENT_SIGN = AnsiChar(#$25);

  AC_AMPERSAND = AnsiChar(#$26);

  AC_APOSTROPHE = AnsiChar(#$27);

  AC_LEFT_PARENTHESIS = AnsiChar(#$28);

  AC_RIGHT_PARENTHESIS = AnsiChar(#$29);

  AC_ASTERISK = AnsiChar(#$2A);

  AC_PLUS_SIGN = AnsiChar(#$2B);

  AC_COMMA = AnsiChar(#$2C);

  AC_HYPHEN_MINUS = AnsiChar(#$2D);

  AC_FULL_STOP = AnsiChar(#$2E);

  AC_SOLIDUS = AnsiChar(#$2F);

  AC_DIGIT_ZERO = AnsiChar(#$30);

  AC_DIGIT_ONE = AnsiChar(#$31);

  AC_DIGIT_TWO = AnsiChar(#$32);

  AC_DIGIT_THREE = AnsiChar(#$33);

  AC_DIGIT_FOUR = AnsiChar(#$34);

  AC_DIGIT_FIVE = AnsiChar(#$35);

  AC_DIGIT_SIX = AnsiChar(#$36);

  AC_DIGIT_SEVEN = AnsiChar(#$37);

  AC_DIGIT_EIGHT = AnsiChar(#$38);

  AC_DIGIT_NINE = AnsiChar(#$39);

  AC_COLON = AnsiChar(#$3A);

  AC_SEMICOLON = AnsiChar(#$3B);

  AC_LESS_THAN_SIGN = AnsiChar(#$3C);

  AC_EQUALS_SIGN = AnsiChar(#$3D);

  AC_GREATER_THAN_SIGN = AnsiChar(#$3E);

  AC_QUESTION_MARK = AnsiChar(#$3F);

  AC_COMMERCIAL_AT = AnsiChar(#$40);

  AC_REVERSE_SOLIDUS = AnsiChar(#$5C);

  AC_LOW_LINE = AnsiChar(#$5F);

  AC_SOFT_HYPHEN = AnsiChar(#$AD);

  AC_CAPITAL_A = AnsiChar(#$41);
  AC_CAPITAL_B = AnsiChar(#$42);
  AC_CAPITAL_C = AnsiChar(#$43);
  AC_CAPITAL_D = AnsiChar(#$44);
  AC_CAPITAL_E = AnsiChar(#$45);
  AC_CAPITAL_F = AnsiChar(#$46);
  AC_CAPITAL_G = AnsiChar(#$47);
  AC_CAPITAL_H = AnsiChar(#$48);
  AC_CAPITAL_I = AnsiChar(#$49);
  AC_CAPITAL_J = AnsiChar(#$4A);
  AC_CAPITAL_K = AnsiChar(#$4B);
  AC_CAPITAL_L = AnsiChar(#$4C);
  AC_CAPITAL_M = AnsiChar(#$4D);
  AC_CAPITAL_N = AnsiChar(#$4E);
  AC_CAPITAL_O = AnsiChar(#$4F);
  AC_CAPITAL_P = AnsiChar(#$50);
  AC_CAPITAL_Q = AnsiChar(#$51);
  AC_CAPITAL_R = AnsiChar(#$52);
  AC_CAPITAL_S = AnsiChar(#$53);
  AC_CAPITAL_T = AnsiChar(#$54);
  AC_CAPITAL_U = AnsiChar(#$55);
  AC_CAPITAL_V = AnsiChar(#$56);
  AC_CAPITAL_W = AnsiChar(#$57);
  AC_CAPITAL_X = AnsiChar(#$58);
  AC_CAPITAL_Y = AnsiChar(#$59);
  AC_CAPITAL_Z = AnsiChar(#$5A);

  AC_GRAVE_ACCENT = AnsiChar(#$60);

  AC_SMALL_A = AnsiChar(#$61);
  AC_SMALL_B = AnsiChar(#$62);
  AC_SMALL_C = AnsiChar(#$63);
  AC_SMALL_D = AnsiChar(#$64);
  AC_SMALL_E = AnsiChar(#$65);
  AC_SMALL_F = AnsiChar(#$66);
  AC_SMALL_G = AnsiChar(#$67);
  AC_SMALL_H = AnsiChar(#$68);
  AC_SMALL_I = AnsiChar(#$69);
  AC_SMALL_J = AnsiChar(#$6A);
  AC_SMALL_K = AnsiChar(#$6B);
  AC_SMALL_L = AnsiChar(#$6C);
  AC_SMALL_M = AnsiChar(#$6D);
  AC_SMALL_N = AnsiChar(#$6E);
  AC_SMALL_O = AnsiChar(#$6F);
  AC_SMALL_P = AnsiChar(#$70);
  AC_SMALL_Q = AnsiChar(#$71);
  AC_SMALL_R = AnsiChar(#$72);
  AC_SMALL_S = AnsiChar(#$73);
  AC_SMALL_T = AnsiChar(#$74);
  AC_SMALL_U = AnsiChar(#$75);
  AC_SMALL_V = AnsiChar(#$76);
  AC_SMALL_W = AnsiChar(#$77);
  AC_SMALL_X = AnsiChar(#$78);
  AC_SMALL_Y = AnsiChar(#$79);
  AC_SMALL_Z = AnsiChar(#$7A);

  AC_NO_BREAK_SPACE = AnsiChar(#$A0);

  AC_DRIVE_DELIMITER = AC_COLON;

  AC_DOS_PATH_DELIMITER = AC_REVERSE_SOLIDUS;

  AC_UNIX_PATH_DELIMITER = AC_SOLIDUS;

  AC_PATH_DELIMITER =
    {$IFDEF MSWINDOWS}AC_DOS_PATH_DELIMITER{$ENDIF}
  {$IFDEF CLR}AC_DOS_PATH_DELIMITER{$ENDIF}
  {$IFDEF LINUX}AC_UNIX_PATH_DELIMITER{$ENDIF}
  {$IFDEF MACOS}AC_UNIX_PATH_DELIMITER{$ENDIF};

  AA_CRLF: array[0..1] of AnsiChar = (#13, #10);

  AS_CRLF = AnsiString(#$0D#$0A);

  AS_DIGITS = [
    AC_DIGIT_ZERO..AC_DIGIT_NINE];

  AS_HEX_DIGITS = [
    AC_DIGIT_ZERO..AC_DIGIT_NINE,
    AC_CAPITAL_A..AC_CAPITAL_F,
    AC_SMALL_A, AC_SMALL_F];

  AS_WHITE_SPACE = [
    AC_NULL..AC_SPACE];

  AS_WORD_SEPARATORS = [
    AC_NULL..AC_SPACE,
    AC_DIGIT_ZERO..AC_DIGIT_NINE,
    AC_FULL_STOP, AC_COMMA, AC_COLON, AC_SEMICOLON,
    AC_QUOTATION_MARK,
    AC_LEFT_PARENTHESIS, AC_RIGHT_PARENTHESIS,
    AC_HYPHEN_MINUS, AC_SOLIDUS, AC_AMPERSAND];

  AA_NUM_TO_HEX: array[0..$F] of AnsiChar = (
    AC_DIGIT_ZERO,
    AC_DIGIT_ONE,
    AC_DIGIT_TWO,
    AC_DIGIT_THREE,
    AC_DIGIT_FOUR,
    AC_DIGIT_FIVE,
    AC_DIGIT_SIX,
    AC_DIGIT_SEVEN,
    AC_DIGIT_EIGHT,
    AC_DIGIT_NINE,
    AC_CAPITAL_A,
    AC_CAPITAL_B,
    AC_CAPITAL_C,
    AC_CAPITAL_D,
    AC_CAPITAL_E,
    AC_CAPITAL_F);

  WC_NULL = WideChar(#$0000);
  WC_0001 = WideChar(#$0001);
  WC_0008 = WideChar(#$0008);

  WC_TAB = WideChar(#$0009);

  WC_LF = WideChar(#$000A);
  WC_000B = WideChar(#$000B);
  WC_000C = WideChar(#$000C);

  WC_CR = WideChar(#$000D);
  WC_000E = WideChar(#$000E);

  WC_SPACE = WideChar(#$0020);

  WC_EXCLAMATION_MARK = WideChar(#$0021);

  WC_QUOTATION_MARK = WideChar(#$0022);

  WC_NUMBER_SIGN = WideChar(#$0023);

  WC_DOLLAR_SIGN = WideChar(#$0024);

  WC_PERCENT_SIGN = WideChar(#$0025);

  WC_AMPERSAND = WideChar(#$0026);

  WC_APOSTROPHE = WideChar(#$0027);

  WC_LEFT_PARENTHESIS = WideChar(#$0028);

  WC_RIGHT_PARENTHESIS = WideChar(#$0029);

  WC_ASTERISK = WideChar(#$002A);

  WC_PLUS_SIGN = WideChar(#$002B);

  WC_COMMA = WideChar(#$002C);

  WC_HYPHEN_MINUS = WideChar(#$002D);

  WC_FULL_STOP = WideChar(#$002E);

  WC_SOLIDUS = WideChar(#$002F);

  WC_DIGIT_ZERO = WideChar(#$0030);

  WC_DIGIT_ONE = WideChar(#$0031);

  WC_DIGIT_TWO = WideChar(#$0032);

  WC_DIGIT_THREE = WideChar(#$0033);

  WC_DIGIT_FOUR = WideChar(#$0034);

  WC_DIGIT_FIVE = WideChar(#$0035);

  WC_DIGIT_SIX = WideChar(#$0036);

  WC_DIGIT_SEVEN = WideChar(#$0037);

  WC_DIGIT_EIGHT = WideChar(#$0038);

  WC_DIGIT_NINE = WideChar(#$0039);

  WC_COLON = WideChar(#$003A);

  WC_SEMICOLON = WideChar(#$003B);

  WC_LESS_THAN_SIGN = WideChar(#$003C);

  WC_EQUALS_SIGN = WideChar(#$003D);

  WC_COMMERCIAL_AT = WideChar(#$0040);

  WC_GREATER_THAN_SIGN = WideChar(#$003E);

  WC_QUESTION_MARK = WideChar(#$003F);

  WC_CAPITAL_A = WideChar(#$0041);
  WC_CAPITAL_B = WideChar(#$0042);
  WC_CAPITAL_C = WideChar(#$0043);
  WC_CAPITAL_D = WideChar(#$0044);
  WC_CAPITAL_E = WideChar(#$0045);
  WC_CAPITAL_F = WideChar(#$0046);
  WC_CAPITAL_G = WideChar(#$0047);
  WC_CAPITAL_H = WideChar(#$0048);
  WC_CAPITAL_I = WideChar(#$0049);
  WC_CAPITAL_J = WideChar(#$004A);
  WC_CAPITAL_K = WideChar(#$004B);
  WC_CAPITAL_L = WideChar(#$004C);
  WC_CAPITAL_M = WideChar(#$004D);
  WC_CAPITAL_N = WideChar(#$004E);
  WC_CAPITAL_O = WideChar(#$004F);
  WC_CAPITAL_P = WideChar(#$0050);
  WC_CAPITAL_Q = WideChar(#$0051);
  WC_CAPITAL_R = WideChar(#$0052);
  WC_CAPITAL_S = WideChar(#$0053);
  WC_CAPITAL_T = WideChar(#$0054);
  WC_CAPITAL_U = WideChar(#$0055);
  WC_CAPITAL_V = WideChar(#$0056);
  WC_CAPITAL_W = WideChar(#$0057);
  WC_CAPITAL_X = WideChar(#$0058);
  WC_CAPITAL_Y = WideChar(#$0059);
  WC_CAPITAL_Z = WideChar(#$005A);

  WC_LEFT_SQUARE_BRACKET = WideChar(#$005B);

  WC_REVERSE_SOLIDUS = WideChar(#$005C);

  WC_RIGHT_SQUARE_BRACKET = WideChar(#$005D);

  WC_CIRCUMFLEX_ACCENT = WideChar(#$005E);

  WC_LOW_LINE = WideChar(#$005F);

  WC_GRAVE_ACCENT = WideChar(#$0060);

  WC_SMALL_A = WideChar(#$0061);
  WC_SMALL_B = WideChar(#$0062);
  WC_SMALL_C = WideChar(#$0063);
  WC_SMALL_D = WideChar(#$0064);
  WC_SMALL_E = WideChar(#$0065);
  WC_SMALL_F = WideChar(#$0066);
  WC_SMALL_G = WideChar(#$0067);
  WC_SMALL_H = WideChar(#$0068);
  WC_SMALL_I = WideChar(#$0069);
  WC_SMALL_J = WideChar(#$006A);
  WC_SMALL_K = WideChar(#$006B);
  WC_SMALL_L = WideChar(#$006C);
  WC_SMALL_M = WideChar(#$006D);
  WC_SMALL_N = WideChar(#$006E);
  WC_SMALL_O = WideChar(#$006F);
  WC_SMALL_P = WideChar(#$0070);
  WC_SMALL_Q = WideChar(#$0071);
  WC_SMALL_R = WideChar(#$0072);
  WC_SMALL_S = WideChar(#$0073);
  WC_SMALL_T = WideChar(#$0074);
  WC_SMALL_U = WideChar(#$0075);
  WC_SMALL_V = WideChar(#$0076);
  WC_SMALL_W = WideChar(#$0077);
  WC_SMALL_X = WideChar(#$0078);
  WC_SMALL_Y = WideChar(#$0079);
  WC_SMALL_Z = WideChar(#$007A);

  WC_LEFT_CURLY_BRACKET = WideChar(#$007B);

  WC_VERTICAL_LINE = WideChar(#$007C);

  WC_RIGHT_CURLY_BRACKET = WideChar(#$007D);

  WC_TILDE = WideChar(#$007E);

  WC_NO_BREAK_SPACE = WideChar(#$00A0);

  WC_SOFT_HYPHEN = WideChar(#$00AD);
  WC_EN_DASH = WideChar(#$2013);
  WC_LINE_SEPARATOR = WideChar($2028);
  WC_REPLACEMENT_CHARACTER = WideChar(#$FFFD);

  WC_DRIVE_DELIMITER: WideChar = WideChar(WC_COLON);

  WC_DOS_PATH_DELIMITER = WC_REVERSE_SOLIDUS;
  WC_UNIX_PATH_DELIMITER = WC_SOLIDUS;
  WC_PATH_DELIMITER =
    {$IFDEF MSWINDOWS}WC_DOS_PATH_DELIMITER{$ENDIF}
  {$IFDEF CLR}WC_DOS_PATH_DELIMITER{$ENDIF}
  {$IFDEF LINUX}WC_UNIX_PATH_DELIMITER{$ENDIF}
  {$IFDEF MACOS}WC_UNIX_PATH_DELIMITER{$ENDIF};

  WA_CRLF: array[0..1] of WideChar = (#13, #10);

  WS_CRLF = WideString(#$000D#$000A);

  {$IFDEF DI_Use_Wide_Char_Set_Consts}

  WS_DIGITS = [
    WC_DIGIT_ZERO..WC_DIGIT_NINE];

  WS_HEX_DIGITS = [
    WC_DIGIT_ZERO..WC_DIGIT_NINE,
    WC_CAPITAL_A..WC_CAPITAL_F,
    WC_SMALL_A..WC_SMALL_F];

  WS_WHITE_SPACE = [
    WC_NULL..WC_SPACE];
  {$ENDIF}

  WA_NUM_TO_HEX: array[0..$F] of WideChar = (
    WC_DIGIT_ZERO,
    WC_DIGIT_ONE,
    WC_DIGIT_TWO,
    WC_DIGIT_THREE,
    WC_DIGIT_FOUR,
    WC_DIGIT_FIVE,
    WC_DIGIT_SIX,
    WC_DIGIT_SEVEN,
    WC_DIGIT_EIGHT,
    WC_DIGIT_NINE,
    WC_CAPITAL_A,
    WC_CAPITAL_B,
    WC_CAPITAL_C,
    WC_CAPITAL_D,
    WC_CAPITAL_E,
    WC_CAPITAL_F);

  BOM_UTF_8: array[0..2] of AnsiChar = (#$EF, #$BB, #$BF);

  BOM_UTF_16_BE: array[0..1] of AnsiChar = (#$FE, #$FF);

  BOM_UTF_16_LE: array[0..1] of AnsiChar = (#$FF, #$FE);

  BOM_UTF_32_BE: array[0..3] of AnsiChar = (#$00, #$00, #$FE, #$FF);

  BOM_UTF_32_LE: array[0..3] of AnsiChar = (#$FF, #$FE, #$00, #$00);

  REPLACEMENT_CHARACTER = $FFFD;

  HANGUL_SBase = $AC00;

  HANGUL_LBase = $1100;

  HANGUL_VBase = $1161;

  HANGUL_TBase = $11A7;

  HANGUL_LCount = 19;
  HANGUL_VCount = 21;
  HANGUL_TCount = 28;

  HANGUL_nCount = HANGUL_VCount * HANGUL_TCount;

  HANGUL_SCount = HANGUL_LCount * HANGUL_nCount;

  {$IFNDEF COMPILER_2010_UP}

  KEY_WOW64_32KEY = $0200;
  {$EXTERNALSYM KEY_WOW64_32KEY}

  KEY_WOW64_64KEY = $0100;
  {$EXTERNALSYM KEY_WOW64_64KEY}

  KEY_WOW64_RES = $0300;
  {$EXTERNALSYM KEY_WOW64_RES}

  {$ENDIF !COMPILER_2010_UP}

type

  TAnsiCharSet = set of AnsiChar;

  TCrc32 = {$IFDEF SUPPORTS_LONGWORD}Cardinal{$ELSE}Integer{$ENDIF};

  TInt64Rec = packed record
    lo, hi: Cardinal;
  end;

  TIsoDate = Cardinal;

  TJulianDate = Integer;

  PJulianDate = ^TJulianDate;

  TCharDecompositionW = packed record
    Count: Byte;
    Data: array[0..17] of WideChar;
  end;
  PCharDecompositionW = ^TCharDecompositionW;

  TProcedureEvent = procedure of object;

  TValidateCharFunc = function(
    const c: Char): Boolean;

  TValidateCharFuncA = function(
    const c: AnsiChar): Boolean;

  TValidateCharFuncW = function(
    const c: WideChar): Boolean;

const

  MT19937_N = 624;

  MT19937_M = 397;

type

  {$IFDEF COMPILER_4_UP}

  TMT19937 = class(TObject)
  private
    mt: array[0..MT19937_N - 1] of Cardinal;
    mti: Cardinal;
  public

    constructor Create; overload;

    constructor Create(const init_key: Cardinal); overload;

    constructor Create(const init_key: array of Cardinal); overload;

    constructor Create(const init_key: RawByteString); overload;

    procedure init_genrand(const init_key: Cardinal);

    procedure init_by_array(const init_key: array of Cardinal);

    procedure init_by_StrA(const init_key: RawByteString);

    function genrand_int32: Cardinal;

    function genrand_int31: Cardinal;

    function genrand_int64: Int64;

    function genrand_int63: Int64;

    function genrand_real1: Double;

    function genrand_real2: Double;

    function genrand_real3: Double;

    function genrand_res53: Double;
  end;

  {$ENDIF COMPILER_4_UP}

  TWideStrBuf = class
  private
    FBuf, FPos, FEnd: PWideChar;
    procedure GrowBuffer(const Count: Cardinal);
    function GetAsStr: WideString;
    function GetAsStrTrimRight: WideString;
    function GetCount: Cardinal;
  public
    destructor Destroy; override;
    procedure AddBuf(const Buf: PWideChar; const Count: Cardinal);
    procedure AddChar(const c: WideChar);
    procedure AddCrLf;
    procedure AddStr(const s: WideString);
    property AsStr: WideString read GetAsStr;
    property AsStrTrimRight: WideString read GetAsStrTrimRight;
    property Buf: PWideChar read FBuf;
    procedure Clear;
    property Count: Cardinal read GetCount;
    procedure Delete(const Index, Count: Cardinal);
    function IsEmpty: Boolean;
    function IsNotEmpty: Boolean;
    procedure Reset;
  end;



const

  TDITextLineBreakStyleDefault = {$IFDEF MSWINDOWS}tlbsCRLF{$ENDIF}{$IFDEF MACOS}tlbsCR{$ENDIF};

function AdjustLineBreaksW(
  const s: UnicodeString;
  const Style: TDITextLineBreakStyle{$IFDEF SUPPORTS_DEFAULTPARAMS} = TDITextLineBreakStyleDefault{$ENDIF}): UnicodeString;

function BrightenColor(
  const Color: Integer;
  const amount: Byte{$IFDEF SUPPORTS_DEFAULTPARAMS} = 25{$ENDIF}): Integer;

{$IFDEF COMPILER_4_UP}

function BSwap(
  const Value: Cardinal): Cardinal; overload;
{$ENDIF COMPILER_4_UP}

function BSwap(
  const Value: Integer): Integer; {$IFDEF COMPILER_4_UP}overload; {$ENDIF}

function BufCompNumIW(
  p1: PWideChar;
  l1: Integer;
  p2: PWideChar;
  l2: Integer): Integer;

function BufCountUtf8Chars(
  p: PUtf8Char;
  l: Cardinal): Cardinal;

function BufDecodeUtf8(
  const p: PUtf8Char;
  const l: NativeUInt): UnicodeString;

function BufEncodeUtf8(
  const p: PWideChar;
  const l: NativeUInt): Utf8String;

function BufIsCharsW(
  const p: PWideChar;
  const l: NativeUInt;
  const Validate: TValidateCharFuncW): Boolean; overload;

function BufIsCharsW(
  const p: PWideChar;
  const l: NativeUInt;
  const Validate: TValidateCharFuncW;
  const c: WideChar): Boolean; overload;

function BufHasCharsW(
  const Buf: PWideChar;
  const BufCharCount: NativeUInt;
  const Validate: TValidateCharFuncW): Boolean;

function BufPosA(
  const ASearch: RawByteString;
  const ABuf: PAnsiChar;
  const ABufCharCount: Cardinal;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Pointer;

function BufPosW(
  const ASearch: UnicodeString;
  const ABuf: PWideChar;
  const ABufCharCount: Cardinal;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): PWideChar;

function BufPosIA(
  const ASearch: RawByteString;
  const ABuf: PAnsiChar;
  const ABufCharCount: Cardinal;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Pointer;

function BufPosIW(
  const ASearch: UnicodeString;
  const ABuffer: PWideChar;
  const ABufferCharCount: Cardinal;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): PWideChar;

function BufSameA(p1, p2: PAnsiChar; l: Cardinal): Boolean;

function BufSameW(p1, p2: PWideChar; l: Cardinal): Boolean;

function BufSameIA(p1, p2: PAnsiChar; l: Cardinal): Boolean;

function BufSameIW(p1, p2: PWideChar; l: Cardinal): Boolean;

function BufPosCharA(
  const Buf: PAnsiChar;
  l: Cardinal;
  const c: AnsiChar;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Integer;

function BufPosCharsA(
  const Buf: PAnsiChar;
  l: Cardinal;
  const Search: TAnsiCharSet;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Integer;

function BufPosCharsW(
  const Buf: PWideChar;
  l: Cardinal;
  const Validate: TValidateCharFuncW;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Integer;

function BufStrSame(
  const Buf: PChar;
  const BufCharCount: Cardinal;
  const s: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function BufStrSameA(
  const Buf: PAnsiChar;
  const BufCharCount: Cardinal;
  const s: RawByteString): Boolean;

function BufStrSameW(
  const Buf: PWideChar;
  const BufCharCount: Cardinal;
  const s: UnicodeString): Boolean;

function BufStrSameI(
  const Buf: PChar;
  const BufCharCount: Cardinal;
  const s: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function BufStrSameIA(
  const Buf: PAnsiChar;
  const BufCharCount: Cardinal;
  const s: RawByteString): Boolean;

function BufStrSameIW(
  const Buffer: PWideChar;
  const WideCharCount: Cardinal;
  const w: UnicodeString): Boolean;

function ChangeFileExt(
  const FileName, Extension: string): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function ChangeFileExtA(
  const FileName, Extension: AnsiString): AnsiString;

function ChangeFileExtW(
  const FileName, Extension: UnicodeString): UnicodeString;

function CharDecomposeCanonicalW(
  const c: WideChar): PCharDecompositionW;

function CharDecomposeCanonicalStrW(
  const c: WideChar): UnicodeString;

function CharDecomposeCompatibleW(
  const c: WideChar): PCharDecompositionW;

function CharDecomposeCompatibleStrW(
  const c: WideChar): UnicodeString;

function CharIn(
  const c, t1, t2: WideChar): Boolean; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function CharIn(
  const c, t1, t2, t3: WideChar): Boolean; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

procedure ConCatBuf(
  const Buffer: PChar;
  const CharCount: Cardinal;
  var d: string;
  var InUse: Cardinal);

procedure ConCatBufA(
  const Buffer: PAnsiChar;
  const AnsiCharCount: Cardinal;
  var d: RawByteString;
  var InUse: Cardinal);

procedure ConCatBufW(
  const Buffer: PWideChar;
  const WideCharCount: Cardinal;
  var d: UnicodeString;
  var InUse: Cardinal);

procedure ConCatChar(
  const c: Char;
  var d: string;
  var InUse: Cardinal); {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

procedure ConCatCharA(
  const c: AnsiChar;
  var d: RawByteString;
  var InUse: Cardinal);

procedure ConCatCharW(
  const c: WideChar;
  var d: UnicodeString;
  var InUse: Cardinal);

procedure ConCatStr(
  const s: string;
  var d: string;
  var InUse: Cardinal); {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

procedure ConCatStrA(
  const s: RawByteString;
  var d: RawByteString;
  var InUse: Cardinal);

procedure ConCatStrW(
  const w: UnicodeString;
  var d: UnicodeString;
  var InUse: Cardinal);

function CountBitsSet(const Value: Integer): Byte;

function Crc32OfBuf(
  const Buffer;
  const BufferSize: Cardinal): TCrc32; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function Crc32OfBuf(
  const Buffer;
  const BufferSize: UInt64): TCrc32; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function Crc32OfStrA(
  const s: RawByteString): TCrc32;

function Crc32OfStrW(
  const s: UnicodeString): TCrc32;

{$IFDEF MSWINDOWS}

function CurrentDay: Word;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function CurrentJulianDate: TJulianDate;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function CurrentMonth: Word;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function CurrentQuarter: Word;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function CurrentYear: Integer;
{$ENDIF MSWINDOWS}

function DarkenColor(
  const Color: Integer;
  const amount: Byte{$IFDEF SUPPORTS_DEFAULTPARAMS} = 25{$ENDIF}): Integer;

{$IFDEF MSWINDOWS}

function DeleteFile(
  const FileName: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function DeleteFileA(
  const FileName: AnsiString): Boolean;

function DeleteFileW(
  const FileName: UnicodeString): Boolean; {$IFDEF Unicode}inline; {$ENDIF}
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function DirectoryExists(
  const Dir: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function DirectoryExistsA(
  const Dir: AnsiString): Boolean;

function DirectoryExistsW(
  const Dir: UnicodeString): Boolean;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}{$IFDEF SUPPORTS_LONGWORD}

function DiskFree(
  const Dir: string): Int64; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function DiskFreeA(
  const Dir: AnsiString): Int64;

function DiskFreeW(
  const Dir: UnicodeString): Int64;

{$ENDIF SUPPORTS_LONGWORD}{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function ExpandFileName(
  const FileName: string): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function ExpandFileNameA(
  const FileName: AnsiString): AnsiString;

function ExpandFileNameW(
  const FileName: UnicodeString): UnicodeString;
{$ENDIF MSWINDOWS}

procedure ExcludeTrailingPathDelimiter(
  var s: string); {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

procedure ExcludeTrailingPathDelimiterA(
  var s: RawByteString);

procedure ExcludeTrailingPathDelimiterW(
  var s: UnicodeString);

{$IFDEF MSWINDOWS}

function ExtractFileDrive(
  const FileName: string): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function ExtractFileDriveA(
  const FileName: RawByteString): RawByteString;

function ExtractFileDriveW(
  const FileName: UnicodeString): UnicodeString;
{$ENDIF MSWINDOWS}

function ExtractFileExt(
  const FileName: string): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function ExtractFileExtA(
  const FileName: RawByteString): RawByteString;

function ExtractFileExtW(
  const FileName: UnicodeString): UnicodeString;

function ExtractFileName(
  const FileName: string): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function ExtractFileNameA(
  const FileName: AnsiString): AnsiString;

function ExtractFileNameW(
  const FileName: UnicodeString): UnicodeString;

function ExtractFilePath(
  const FileName: string): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function ExtractFilePathA(
  const FileName: RawByteString): RawByteString;

function ExtractFilePathW(
  const FileName: UnicodeString): UnicodeString;

function ExtractNextWord(
  const s: string;
  const ADelimiter: Char;
  var AStartIndex: Integer): string; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function ExtractNextWordA(
  const s: RawByteString;
  const ADelimiter: AnsiChar;
  var AStartIndex: Integer): RawByteString; overload;

function ExtractNextWordW(
  const s: UnicodeString;
  const ADelimiter: WideChar;
  var AStartIndex: Integer): UnicodeString; overload;

function ExtractNextWord(
  const s: string;
  const ADelimiters: {$IFDEF Unicode}TValidateCharFuncW{$ELSE}TAnsiCharSet{$ENDIF};
  var AStartIndex: Integer): string; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function ExtractNextWordA(
  const s: RawByteString;
  const ADelimiters: TAnsiCharSet;
  var AStartIndex: Integer): RawByteString; overload;

function ExtractNextWordW(
  const s: UnicodeString;
  const ADelimiters: TValidateCharFuncW;
  var AStartIndex: Integer): UnicodeString; overload;

function ExtractWordA(
  const Number: Cardinal;
  const s: RawByteString;
  const Delimiters: TAnsiCharSet{$IFDEF SUPPORTS_DEFAULTPARAMS} = AS_WHITE_SPACE{$ENDIF}): RawByteString;

function ExtractWordStartsA(
  const s: RawByteString;
  const MaxCharCount: Cardinal;
  const WordSeparators: TAnsiCharSet{$IFDEF SUPPORTS_DEFAULTPARAMS} = AS_WHITE_SPACE{$ENDIF}): RawByteString;

function ExtractWordStartsW(
  const s: UnicodeString;
  const MaxCharCount: Cardinal;
  const IsWordSep: TValidateCharFuncW): UnicodeString;

{$IFDEF MSWINDOWS}

function FileExists(
  const FileName: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function FileExistsA(
  const FileName: AnsiString): Boolean;

function FileExistsW(
  const FileName: UnicodeString): Boolean;
{$ENDIF MSWINDOWS}

function GCD(x, y: Cardinal): Cardinal;

{$IFDEF MSWINDOWS}

function GetTempFileName(
  const Prefix: string = 'tmp';
  const Unique: {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.uInt = 0): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function GetTempFileNameA(
  const Prefix: AnsiString = 'tmp';
  const Unique: {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.uInt = 0): AnsiString;

function GetTempFileNameW(
  const Prefix: UnicodeString = 'tmp';
  const Unique: {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.uInt = 0): UnicodeString;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetTempFolder: string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function GetTempFolderA: AnsiString;

function GetTempFolderW: UnicodeString;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetUserName(
  out UserName: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function GetUserNameA(
  out UserName: AnsiString): Boolean;

function GetUserNameW(
  out UserName: UnicodeString): Boolean;
{$ENDIF MSWINDOWS}

function HashBuf(
  const Buffer;
  const BufferSize: Cardinal;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};

function HashBufIA(
  const Buffer;
  const AnsiCharCount: Cardinal;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};

function HashBufIW(
  const Buffer;
  const WideCharCount: Cardinal;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};

function HashStrA(
  const s: RawByteString;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};

function HashStrW(
  const s: UnicodeString;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};

function HashStrIA(
  const s: RawByteString;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};

function HashStrIW(
  const w: UnicodeString;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};

function HexCodePointToInt(const c: Cardinal): Integer;

function HexToInt(const s: string): Integer; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function HexToIntA(const s: RawByteString): Integer;

function HexToIntW(const s: UnicodeString): Integer;

function BufHexToInt(p: PChar; l: Cardinal): Integer; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function BufHexToIntA(p: PAnsiChar; l: Cardinal): Integer;

function BufHexToIntW(p: PWideChar; l: Cardinal): Integer;

procedure IncludeTrailingPathDelimiterByRef(var s: string); {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

procedure IncludeTrailingPathDelimiterByRefA(var s: RawByteString);

procedure IncludeTrailingPathDelimiterByRefW(var w: UnicodeString);

{$IFDEF COMPILER_4_UP}

function IntToHex(
  const Value: Integer;
  const Digits: NativeInt): string; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function IntToHex(
  const Value: Int64;
  const Digits: NativeInt): string; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}
{$IFDEF SUPPORTS_UINT64}

function IntToHex(
  const Value: UInt64;
  const Digits: NativeInt): string; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}
{$ENDIF SUPPORTS_UINT64}

function IntToHexA(
  Value: UInt64;
  const Digits: NativeInt): RawByteString;

function IntToHexW(
  Value: UInt64;
  const Digits: NativeInt): UnicodeString;
{$ENDIF COMPILER_4_UP}

function IntToStrA(const i: Integer): RawByteString; {$IFDEF COMPILER_4_UP}overload; {$ENDIF}

function IntToStrW(const i: Integer): UnicodeString; {$IFDEF COMPILER_4_UP}overload; {$ENDIF}

{$IFDEF COMPILER_4_UP}

function IntToStrA(const i: Int64): RawByteString; overload;

function IntToStrW(const i: Int64): UnicodeString; overload;
{$ENDIF COMPILER_4_UP}

function CharDecomposeHangulW(const c: WideChar): UnicodeString;

function IsPathDelimiter(
  const s: string;
  const Index: Cardinal): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function IsPathDelimiterA(
  const s: RawByteString;
  const Index: Cardinal): Boolean;

function IsPathDelimiterW(
  const s: UnicodeString;
  const Index: Cardinal): Boolean;

{$IFDEF MSWINDOWS}

function IsPointInRect(const Point: TPoint; const Rect: TRect): Boolean;
{$ENDIF}

function JulianDateToIsoDateStr(
  const Julian: TJulianDate): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function JulianDateToIsoDateStrA(const Julian: TJulianDate): RawByteString;

function JulianDateToIsoDateStrW(const Julian: TJulianDate): UnicodeString;

function LeftMostBit(
  Value: Cardinal): ShortInt; overload;

function LeftMostBit(
  Value: UInt64): ShortInt; overload;

function MakeMethod(const AData, ACode: Pointer): TMethod;

function StrIsEmpty(const s: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrIsEmptyA(const s: RawByteString): Boolean;

function StrIsEmptyW(const s: UnicodeString): Boolean;

function PadLeftA(const Source: RawByteString; const Count: Cardinal; const c: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_SPACE{$ENDIF}): RawByteString;

function PadLeftW(const Source: UnicodeString; const Count: Cardinal; const c: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_SPACE{$ENDIF}): UnicodeString;

function PadRightA(const Source: RawByteString; const Count: Cardinal; const c: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_SPACE{$ENDIF}): RawByteString;

function PadRightW(const Source: UnicodeString; const Count: Cardinal; const c: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_SPACE{$ENDIF}): UnicodeString;

function ProperCase(const s: string): string;

function ProperCaseA(const s: RawByteString): RawByteString;

function ProperCaseW(const s: UnicodeString): UnicodeString;

procedure ProperCaseByRefA(var s: RawByteString);

procedure ProperCaseByRefW(var s: UnicodeString);

{$IFDEF MSWINDOWS}

function RegReadRegisteredOrganization(
  const Access: REGSAM = 0): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function RegReadRegisteredOrganizationA(
  const Access: REGSAM = 0): AnsiString;

function RegReadRegisteredOrganizationW(
  const Access: REGSAM = 0): UnicodeString;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function RegReadRegisteredOwner(
  const Access: REGSAM = 0): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function RegReadRegisteredOwnerA(
  const Access: REGSAM = 0): AnsiString;

function RegReadRegisteredOwnerW(
  const Access: REGSAM = 0): UnicodeString;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function RegReadStrDef(
  const Key: HKEY;
  const SubKey: string;
  const ValueName: string;
  const Default: string;
  const Access: REGSAM = 0): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function RegReadStrDefA(
  const Key: HKEY;
  const SubKey: AnsiString;
  const ValueName: AnsiString;
  const Default: AnsiString;
  const Access: REGSAM = 0): AnsiString;

function RegReadStrDefW(
  const Key: HKEY;
  const SubKey: UnicodeString;
  const ValueName: UnicodeString;
  const Default: UnicodeString;
  const Access: REGSAM = 0): UnicodeString;
{$ENDIF MSWINDOWS}

function StrDecodeUrlA(
  const Value: RawByteString): RawByteString;

function StrEncodeUrlA(
  const Value: RawByteString): RawByteString;

function StrEnd(
  const s: PChar): PChar; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrEndA(
  const s: PAnsiChar): PAnsiChar;

function StrEndW(
  const s: PWideChar): PWideChar;

procedure StrIncludeTrailingChar(
  var s: string;
  const c: Char); {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

procedure StrIncludeTrailingCharA(
  var s: RawByteString;
  const c: AnsiChar);

procedure StrIncludeTrailingCharW(
  var s: UnicodeString;
  const c: WideChar);

function StrLen(
  const s: PChar): NativeUInt; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrLenA(
  const s: PAnsiChar): NativeUInt;

function StrLenW(
  const s: PWideChar): NativeUInt;

{$IFDEF COMPILER_4_UP}

function StrRandom(
  const ASeed: RawByteString;
  const ACharacters: string;
  const ALength: Cardinal): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrRandomA(
  const ASeed: RawByteString;
  const ACharacters: RawByteString;
  const ALength: Cardinal): RawByteString;

function StrRandomW(
  const ASeed: RawByteString;
  const ACharacters: UnicodeString;
  const ALength: Cardinal): UnicodeString;
{$ENDIF COMPILER_4_UP}

procedure StrRemoveFromToIA(var Source: RawByteString; const FromString, ToString: RawByteString);

procedure StrRemoveFromToIW(var Source: UnicodeString; const FromString, ToString: UnicodeString);

procedure StrRemoveSpacingA(
  var s: RawByteString;
  const SpaceChars: TAnsiCharSet{$IFDEF SUPPORTS_DEFAULTPARAMS} = AS_WHITE_SPACE{$ENDIF};
  const ReplaceChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_SPACE{$ENDIF});

procedure StrRemoveSpacingW(
  var w: UnicodeString;
  IsSpaceChar: TValidateCharFuncW{$IFDEF SUPPORTS_DEFAULTPARAMS} = nil{$ENDIF};
  const ReplaceChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_SPACE{$ENDIF});

procedure StrReplaceChar(
  var Source: string;
  const SearchChar, ReplaceChar: Char); {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

procedure StrReplaceChar8(
  var s: Utf8String;
  const SearchChar, ReplaceChar: AnsiChar);

procedure StrReplaceCharA(
  var s: RawByteString;
  const SearchChar, ReplaceChar: AnsiChar);

procedure StrReplaceCharW(
  var s: UnicodeString;
  const SearchChar, ReplaceChar: WideChar);

function StrReplace(const Source, Search, Replace: string): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrReplaceA(const Source, Search, Replace: RawByteString): RawByteString;

function StrReplaceW(const Source, Search, Replace: UnicodeString): UnicodeString;

function StrReplaceI(const Source, Search, Replace: string): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrReplaceIA(const Source, Search, Replace: RawByteString): RawByteString;

function StrReplaceIW(const Source, Search, Replace: UnicodeString): UnicodeString;

function StrReplaceLoopA(const Source, Search, Replace: RawByteString): RawByteString;

function StrReplaceLoopW(const Source, Search, Replace: UnicodeString): UnicodeString;

function StrReplaceLoopIA(const Source, Search, Replace: RawByteString): RawByteString;

function StrReplaceLoopIW(const Source, Search, Replace: UnicodeString): UnicodeString;

function RightMostBit(
  const Value: Cardinal): ShortInt; overload;

function RightMostBit(
  const Value: UInt64): ShortInt; overload;

{$IFDEF MSWINDOWS}

function LoadStrAFromFile(const FileName: string; var s: RawByteString): Boolean; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function LoadStrAFromFileA(const FileName: AnsiString; var s: RawByteString): Boolean;

function LoadStrAFromFileW(const FileName: UnicodeString; var s: RawByteString): Boolean;

function LoadStrWFromFile(const FileName: string; var s: UnicodeString): Boolean; overload;

function LoadStrWFromFileA(const FileName: AnsiString; var s: UnicodeString): Boolean;

function LoadStrWFromFileW(const FileName: UnicodeString; var s: UnicodeString): Boolean;

{$ENDIF MSWINDOWS}

function QuotedStrW(
  const s: UnicodeString;
  const Quote: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_QUOTATION_MARK{$ENDIF}): UnicodeString;

{$IFDEF MSWINDOWS}

function SaveBufToFile(
  const Buffer;
  const BufferSize: Cardinal;
  const FileHandle: THandle): Boolean; overload;

function SaveBufToFile(
  const Buffer;
  const BufferSize: Cardinal;
  const FileName: string): Boolean; overload;

function SaveBufToFileA(
  const Buffer;
  const BufferSize: Cardinal;
  const FileName: AnsiString): Boolean;

function SaveBufToFileW(
  const Buffer;
  const BufferSize: Cardinal;
  const FileName: UnicodeString): Boolean;

function SaveStrToFile(
  const s: string;
  const FileName: string): Boolean;

function SaveStrAToFile(
  const s: RawByteString;
  const FileName: string): Boolean;

function SaveStrAToFileA(
  const s: RawByteString;
  const FileName: AnsiString): Boolean;

function SaveStrAToFileW(
  const s: RawByteString;
  const FileName: UnicodeString): Boolean;

function SaveStrWToFile(
  const s: UnicodeString;
  const FileName: string): Boolean;

function SaveStrWToFileA(
  const s: UnicodeString;
  const FileName: AnsiString): Boolean;

function SaveStrWToFileW(
  const s: UnicodeString;
  const FileName: UnicodeString): Boolean;

{$ENDIF MSWINDOWS}

function StrPosChar(const Source: string;
  const c: Char;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrPosCharA(
  const Source: RawByteString;
  const c: AnsiChar;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrPosCharW(
  const Source: UnicodeString;
  const c: WideChar;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrPosCharBack(
  const Source: string;
  const c: Char;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrPosCharBackA(
  const Source: RawByteString;
  const c: AnsiChar;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;

function StrPosCharBackW(
  const Source: UnicodeString;
  const c: WideChar;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;

function StrPosCharsA(const Source: RawByteString; const Search: TAnsiCharSet; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrPosCharsW(
  const Source: UnicodeString;
  const Validate: TValidateCharFuncW;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrPosCharsBackA(
  const Source: RawByteString;
  const Search: TAnsiCharSet;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;

function StrPosNotCharsA(
  const Source: RawByteString;
  const Search: TAnsiCharSet;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrPosNotCharsW(
  const Source: UnicodeString;
  const Validate: TValidateCharFuncW;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrPosNotCharsBackA(
  const Source: RawByteString;
  const Search: TAnsiCharSet;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;

{$IFDEF MSWINDOWS}

function SetFileDate(const FileHandle: THandle; const Year: Integer; const Month, Day: Word): Boolean; overload;

function SetFileDate(const FileName: string; const JulianDate: TJulianDate): Boolean; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function SetFileDateA(const FileName: AnsiString; const JulianDate: TJulianDate): Boolean;

function SetFileDateW(const FileName: UnicodeString; const JulianDate: TJulianDate): Boolean;

function SetFileDateYmd(const FileName: string; const Year: Integer; const Month, Day: Word): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function SetFileDateYmdA(const FileName: AnsiString; const Year: Integer; const Month, Day: Word): Boolean;

function SetFileDateYmdW(const FileName: UnicodeString; const Year: Integer; const Month, Day: Word): Boolean;

{$ENDIF MSWINDOWS}

function StrContainsChar(
  const s: string;
  const c: Char;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrContainsCharA(
  const s: RawByteString;
  const c: AnsiChar;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;

function StrContainsCharW(
  const s: UnicodeString;
  const c: WideChar;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;

function StrContainsCharsA(
  const s: RawByteString;
  const Chars: TAnsiCharSet;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;

{function StrHasCharsW(
  const w: UnicodeString;
  const Validate: TValidateCharFuncW;
 }


function StrSame(const s1, s2: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrSameA(const s1, s2: RawByteString): Boolean;

function StrSameW(const s1, s2: UnicodeString): Boolean;

function StrSameI(const s1, s2: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrSameIA(const s1, s2: RawByteString): Boolean;

function StrSameIW(const s1, s2: UnicodeString): Boolean;

function StrSameStart(const s1, s2: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrSameStartA(const s1, s2: RawByteString): Boolean;

function StrSameStartW(const s1, s2: UnicodeString): Boolean;

function StrSameStartI(const s1, s2: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrSameStartIA(const s1, s2: RawByteString): Boolean;

function StrSameStartIW(const s1, s2: UnicodeString): Boolean;

function StrComp(const s1, s2: string): Integer; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrCompA(const s1, s2: RawByteString): Integer;

function StrCompW(const s1, s2: UnicodeString): Integer;

function StrCompI(const s1, s2: string): Integer; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrCompIA(const s1, s2: RawByteString): Integer;

function StrCompIW(const s1, s2: UnicodeString): Integer;

function StrCompNum(const s1, s2: string): Integer; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrCompNumA(const s1, s2: RawByteString): Integer;

function StrCompNumW(const s1, s2: UnicodeString): Integer;

function StrCompNumI(const s1, s2: string): Integer; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrCompNumIA(const s1, s2: RawByteString): Integer;

function StrCompNumIW(const s1, s2: UnicodeString): Integer;

function StrContains(
  const Search, Source: string;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrContainsA(
  const Search, Source: RawByteString;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;

function StrContainsW(
  const ASearch, ASource: UnicodeString;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;

function StrContainsI(
  const Search, Source: string;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrContainsIA(
  const Search, Source: RawByteString;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;

function StrContainsIW(
  const ASearch, ASource: UnicodeString;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;

function StrCountChar(
  const ASource: string;
  const c: Char;
  const AStartIdx: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrCountCharA(
  const ASource: RawByteString;
  const c: AnsiChar;
  const AStartIdx: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrCountCharW(
  const ASource: UnicodeString;
  const c: WideChar;
  const AStartIdx: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrMatchesA(
  const Search, Source: RawByteString;
  const AStartIdx: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;

function StrMatchesIA(
  const Search, Source: RawByteString;
  const AStartIdx: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;

function StrMatchWild(
  const Source, Mask: string;
  const WildChar: Char{$IFDEF SUPPORTS_DEFAULTPARAMS} = CHAR_ASTERISK{$ENDIF};
  const MaskChar: Char{$IFDEF SUPPORTS_DEFAULTPARAMS} = CHAR_QUESTION_MARK{$ENDIF}): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrMatchWildA(
  const Source, Mask: RawByteString;
  const WildChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_ASTERISK{$ENDIF};
  const MaskChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_QUESTION_MARK{$ENDIF}): Boolean;

function StrMatchWildW(
  const Source, Mask: UnicodeString;
  const WildChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_ASTERISK{$ENDIF};
  const MaskChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_QUESTION_MARK{$ENDIF}): Boolean;

function StrMatchWildI(
  const Source, Mask: string;
  const WildChar: Char{$IFDEF SUPPORTS_DEFAULTPARAMS} = CHAR_ASTERISK{$ENDIF};
  const MaskChar: Char{$IFDEF SUPPORTS_DEFAULTPARAMS} = CHAR_QUESTION_MARK{$ENDIF}): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrMatchWildIA(
  const Source, Mask: RawByteString;
  const WildChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_ASTERISK{$ENDIF};
  const MaskChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_QUESTION_MARK{$ENDIF}): Boolean;

function StrMatchWildIW(
  const Source, Mask: UnicodeString;
  const WildChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_ASTERISK{$ENDIF};
  const MaskChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_QUESTION_MARK{$ENDIF}): Boolean;

function StrPos(
  const ASearch, ASource: string;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrPosA(
  const ASearch, ASource: RawByteString;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrPosW(
  const ASearch, ASource: UnicodeString;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrPosI(
  const ASearch, ASource: string;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrPosIA(
  const ASearch, ASource: RawByteString;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrPosIW(
  const ASearch, ASource: UnicodeString;
  const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;

function StrPosBackA(
  const ASearch, ASource: RawByteString;
  AStart: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;

function StrPosBackIA(
  const ASearch, ASource: RawByteString;
  AStart: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;

function StrToIntDefW(const w: UnicodeString; const Default: Integer): Integer;

{$IFDEF COMPILER_4_UP}

function StrToInt64DefW(const w: UnicodeString; const Default: Int64): Int64;
{$ENDIF COMPILER_4_UP}

function StrToUpper(const s: string): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrToUpperA(const s: RawByteString): RawByteString;

function StrToUpperW(const s: UnicodeString): UnicodeString;

procedure StrToUpperInPlace(
  var s: string); {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

procedure StrToUpperInPlaceA(
  var s: AnsiString);

procedure StrToUpperInPlaceW(
  var s: WideString); {$IFDEF SUPPORTS_UNICODE_STRING}overload; {$ENDIF}
{$IFDEF SUPPORTS_UNICODE_STRING}

procedure StrToUpperInPlaceW(
  var s: UnicodeString); overload;
{$ENDIF SUPPORTS_UNICODE_STRING}

function StrToLower(
  const s: string): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrToLowerA(
  const s: RawByteString): RawByteString;

function StrToLowerW(
  const s: UnicodeString): UnicodeString;

procedure StrToLowerInPlace(
  var s: string); {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

procedure StrToLowerInPlaceA(
  var s: AnsiString);

procedure StrToLowerInPlaceW(
  var s: WideString); {$IFDEF SUPPORTS_UNICODE_STRING}overload; {$ENDIF}
{$IFDEF SUPPORTS_UNICODE_STRING}

procedure StrToLowerInPlaceW(
  var s: UnicodeString); overload;
{$ENDIF SUPPORTS_UNICODE_STRING}

procedure StrTimUriFragmentA(
  var Value: RawByteString);

procedure StrTrimUriFragmentW(
  var Value: UnicodeString);

function StrExtractUriFragmentW(
  var Value: UnicodeString): UnicodeString;

function StrCountUtf8Chars(
  const AValue: Utf8String): Cardinal;

function StrDecodeUtf8(
  const AValue: Utf8String): UnicodeString;

function StrEncodeUtf8(
  const AValue: UnicodeString): Utf8String;

{$IFDEF MSWINDOWS}

function SysErrorMessage(
  const MessageID: Cardinal): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function SysErrorMessageA(
  const MessageID: Cardinal): AnsiString;

function SysErrorMessageW(
  const MessageID: Cardinal): UnicodeString;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function TextExtentW(const DC: HDC; const Text: UnicodeString): TSize;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function TextHeightW(const DC: HDC; const Text: UnicodeString): Integer;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function TextWidthW(const DC: HDC; const Text: UnicodeString): Integer;
{$ENDIF}

function StrTrim(const Source: string): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function StrTrimA(const Source: RawByteString): RawByteString;

function StrTrimW(const w: UnicodeString): UnicodeString;

function StrTrimCharA(const Source: RawByteString; const CharToTrim: AnsiChar): RawByteString;

function StrTrimCharsA(const Source: RawByteString; const CharsToTrim: TAnsiCharSet): RawByteString;

function StrTrimCharsW(const s: UnicodeString; const IsCharToTrim: TValidateCharFuncW): UnicodeString;

procedure TrimLeftByRefA(var s: RawByteString; const Chars: TAnsiCharSet);

function TrimRightA(const Source: RawByteString; const s: TAnsiCharSet): RawByteString;

procedure TrimRightByRefA(var Source: RawByteString; const s: TAnsiCharSet);

procedure StrTrimCompressA(
  var s: RawByteString;
  const TrimCompressChars: TAnsiCharSet{$IFDEF SUPPORTS_DEFAULTPARAMS} = AS_WHITE_SPACE{$ENDIF};
  const ReplaceChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_SPACE{$ENDIF});

procedure StrTrimCompressW(
  var w: UnicodeString;
  Validate: TValidateCharFuncW{$IFDEF SUPPORTS_DEFAULTPARAMS} = nil{$ENDIF};
  const ReplaceChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_SPACE{$ENDIF});

procedure TrimRightByRefW(
  var w: UnicodeString;
  Validate: TValidateCharFuncW{$IFDEF SUPPORTS_DEFAULTPARAMS} = nil{$ENDIF});

function TryStrToIntW(const w: UnicodeString; out Value: Integer): Boolean;

{$IFDEF SUPPORTS_INT64}

function TryStrToInt64W(const w: UnicodeString; out Value: Int64): Boolean;
{$ENDIF SUPPORTS_INT64}

function UpdateCrc32OfBuf(
  const Crc32: TCrc32;
  const Buffer;
  const BufferSize: Cardinal): TCrc32; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function UpdateCrc32OfBuf(
  const Crc32: TCrc32;
  const Buffer;
  BufferSize: UInt64): TCrc32; overload;

function UpdateCrc32OfStrA(
  const Crc32: TCrc32;
  const s: RawByteString): TCrc32;

function UpdateCrc32OfStrW(
  const Crc32: TCrc32;
  const s: UnicodeString): TCrc32;

{$IFDEF MSWINDOWS}

function WBufToAStr(
  const Buffer: PWideChar;
  const WideCharCount: Cardinal;
  const CodePage: Word{$IFDEF SUPPORTS_DEFAULTPARAMS} = CP_ACP{$ENDIF}): RawByteString;
{$ENDIF}

{$IFDEF MSWINDOWS}

function WStrToAStr(
  const s: UnicodeString;
  const CodePage: Word{$IFDEF SUPPORTS_DEFAULTPARAMS} = CP_ACP{$ENDIF}): RawByteString;
{$ENDIF}

function ValInt(
  const p: PChar;
  const l: Integer;
  out Code: Integer): Integer; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function ValIntA(
  p: PAnsiChar;
  l: Integer;
  out Code: Integer): Integer; overload;

function ValIntW(
  p: PWideChar;
  l: Integer;
  out Code: Integer): Integer; overload;

function ValInt(
  const s: string;
  out Code: Integer): Integer; overload; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function ValIntA(
  const s: RawByteString;
  out Code: Integer): Integer; overload;

function ValIntW(
  const s: UnicodeString;
  out Code: Integer): Integer; overload;

{$IFDEF SUPPORTS_INT64}

function ValInt64A(
  p: PAnsiChar;
  l: Integer;
  out Code: Integer): Int64; overload;

function ValInt64W(
  p: PWideChar;
  l: Integer;
  out Code: Integer): Int64; overload;
{$ENDIF SUPPORTS_INT64}

{$IFDEF SUPPORTS_INT64}

function ValInt64A(
  const s: RawByteString;
  out Code: Integer): Int64; overload;

function ValInt64W(
  const s: UnicodeString;
  out Code: Integer): Int64; overload;
{$ENDIF SUPPORTS_INT64}

function YmdToIsoDateStr(
  const Year: Integer;
  const Month: Word;
  const Day: Word): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function YmdToIsoDateStrA(
  const Year: Integer;
  const Month: Word;
  const Day: Word): RawByteString;

function YmdToIsoDateStrW(
  const Year: Integer;
  const Month: Word;
  const Day: Word): UnicodeString;

{$IFDEF CPUX86}

procedure ZeroMem(
  const Buffer;
  const Size: Cardinal);

{$ENDIF CPUX86}

function CharIsLetterW(const c: WideChar): Boolean;
function CharIsLetterCommonW(const c: WideChar): Boolean;
function CharIsLetterUpperCaseW(const c: WideChar): Boolean;
function CharIsLetterLowerCaseW(const c: WideChar): Boolean;
function CharIsLetterTitleCaseW(const c: WideChar): Boolean;
function CharIsLetterModifierW(const c: WideChar): Boolean;
function CharIsLetterOtherW(const c: WideChar): Boolean;
function CharIsMarkW(const c: WideChar): Boolean;
function CharIsMarkNon_SpacingW(const c: WideChar): Boolean;
function CharIsMarkSpacing_CombinedW(const c: WideChar): Boolean;
function CharIsMarkEnclosingW(const c: WideChar): Boolean;
function CharIsNumberW(const c: WideChar): Boolean;
function CharIsNumber_DecimalW(const c: WideChar): Boolean;
function CharIsNumber_LetterW(const c: WideChar): Boolean;
function CharIsNumber_OtherW(const c: WideChar): Boolean;
function CharIsPunctuationW(const c: WideChar): Boolean;
function CharIsPunctuation_ConnectorW(const c: WideChar): Boolean;
function CharIsPunctuation_DashW(const c: WideChar): Boolean;
function CharIsPunctuation_OpenW(const c: WideChar): Boolean;
function CharIsPunctuation_CloseW(const c: WideChar): Boolean;
function CharIsPunctuation_InitialQuoteW(const c: WideChar): Boolean;
function CharIsPunctuation_FinalQuoteW(const c: WideChar): Boolean;
function CharIsPunctuation_OtherW(const c: WideChar): Boolean;
function CharIsSymbolW(const c: WideChar): Boolean;
function CharIsSymbolMathW(const c: WideChar): Boolean;
function CharIsSymbolCurrencyW(const c: WideChar): Boolean;
function CharIsSymbolModifierW(const c: WideChar): Boolean;
function CharIsSymbolOtherW(const c: WideChar): Boolean;
function CharIsSeparatorW(const c: WideChar): Boolean;
function CharIsSeparatorSpaceW(const c: WideChar): Boolean;
function CharIsSeparatorLineW(const c: WideChar): Boolean;
function CharIsSeparatorParagraphW(const c: WideChar): Boolean;
function CharIsOtherW(const c: WideChar): Boolean;
function CharIsOtherControlW(const c: WideChar): Boolean;
function CharIsOtherFormatW(const c: WideChar): Boolean;
function CharIsOtherSurrogateW(const c: WideChar): Boolean;
function CharIsOtherPrivateUseW(const c: WideChar): Boolean;

function BitClear(
  const Bits, BitNo: Integer): Integer;

function BitSet(
  const Bits, BitIndex: Integer): Integer;

function BitSetTo(
  const Bits, BitIndex: Integer;
  const Value: Boolean): Integer;

function BitTest(
  const Bits, BitIndex: Integer): Boolean;

function CharCanonicalCombiningClassW(
  const Char: WideChar): Cardinal;

function CharIsAlphaW(
  const c: WideChar): Boolean;

function CharIsAlphaNumW(
  const c: WideChar): Boolean;

function CharIsCrLf(
  const c: Char): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function CharIsCrLfA(
  const c: AnsiChar): Boolean;

function CharIsCrLfW(
  const c: WideChar): Boolean;

function CharIsDigit(
  const c: Char): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function CharIsDigitA(
  const c: AnsiChar): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function CharIsDigitW(
  const c: WideChar): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function CharIsHangulW(const Char: WideChar): Boolean;

function CharIsHexDigitW(const c: WideChar): Boolean;

function CharIsWhiteSpaceW(const c: WideChar): Boolean;

function CharToCaseFoldW(const Char: WideChar): WideChar;

function CharToLowerW(const Char: WideChar): WideChar;

function CharToUpperW(const Char: WideChar): WideChar;

function CharToTitleW(const Char: WideChar): WideChar;

function DayOfJulianDate(const JulianDate: TJulianDate): Word;

function DayOfWeek(const JulianDate: TJulianDate): Word;

function DayOfWeekYmd(const Year: Integer; const Month, Day: Word): Word;

function DaysInMonth(const JulianDate: TJulianDate): Word;

function DaysInMonthYm(const Year: Integer; const Month: Word): Word;

procedure DecDay(var Year: Integer; var Month, Day: Word);

procedure DecDays(var Year: Integer; var Month, Day: Word; const Days: Integer);

{$IFDEF MSWINDOWS}

function DeleteDirectory(
  const Dir: string;
  const DeleteItself: Boolean{$IFDEF SUPPORTS_DEFAULTPARAMS} = True{$ENDIF}): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function DeleteDirectoryA(
  Dir: AnsiString;
  const DeleteItself: Boolean{$IFDEF SUPPORTS_DEFAULTPARAMS} = True{$ENDIF}): Boolean;

function DeleteDirectoryW(
  Dir: UnicodeString;
  const DeleteItself: Boolean{$IFDEF SUPPORTS_DEFAULTPARAMS} = True{$ENDIF}): Boolean;
{$ENDIF MSWINDOWS}

function EasterSunday(const Year: Integer): TJulianDate;

procedure EasterSundayYmd(const Year: Integer; out Month, Day: Word);

function FirstDayOfWeek(const JulianDate: TJulianDate): TJulianDate;

procedure FirstDayOfWeekYmd(var Year: Integer; var Month, Day: Word);

function FirstDayOfMonth(const Julian: TJulianDate): TJulianDate;

procedure FirstDayOfMonthYmd(const Year: Integer; const Month: Word; out Day: Word);

{$IFDEF MSWINDOWS}

function ForceDirectories(const Dir: string): Boolean; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function ForceDirectoriesA(Dir: AnsiString): Boolean;

function ForceDirectoriesW(Dir: UnicodeString): Boolean;
{$ENDIF MSWINDOWS}

procedure FreeMemAndNil(var Ptr);

{$IFDEF MSWINDOWS}

function GetCurrentFolder: string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function GetCurrentFolderA: AnsiString;

function GetCurrentFolderW: UnicodeString;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

procedure SetCurrentFolder(const NewFolder: string); {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

procedure SetCurrentFolderA(const NewFolder: AnsiString);

procedure SetCurrentFolderW(const NewFolder: UnicodeString);
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetDesktopFolder: string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function GetDesktopFolderA: AnsiString;

function GetDesktopFolderW: UnicodeString;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}
{$IFDEF SUPPORTS_INT64}

function GetFileSize(const AFileName: string): Int64; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function GetFileSizeA(const AFileName: AnsiString): Int64;

function GetFileSizeW(const AFileName: UnicodeString): Int64;
{$ENDIF SUPPORTS_INT64}
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetDesktopDirectoryFolder: string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function GetDesktopDirectoryFolderA: AnsiString;

function GetDesktopDirectoryFolderW: UnicodeString;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetFileLastWriteTime(
  const FileName: string;
  out FileTime: TFileTime): Boolean;

function GetFileLastWriteTimeA(
  const FileName: AnsiString;
  out FileTime: TFileTime): Boolean;

function GetFileLastWriteTimeW(
  const FileName: UnicodeString;
  out FileTime: TFileTime): Boolean;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetPersonalFolder(const PersonalFolder: Integer): string;

function GetPersonalFolderA: AnsiString;

function GetPersonalFolderW: UnicodeString;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetSpecialFolder(const SpecialFolder: Integer): string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function GetSpecialFolderA(const SpecialFolder: Integer): AnsiString;

function GetSpecialFolderW(const SpecialFolder: Integer): UnicodeString;
{$ENDIF MSWINDOWS}

procedure IncMonth(var Year: Integer; var Month, Day: Word);

procedure IncMonths(var Year: Integer; var Month, Day: Word; const NumberOfMonths: Integer);

procedure IncDay(var Year: Integer; var Month, Day: Word);

procedure IncDays(var Year: Integer; var Month, Day: Word; const Days: Integer);

function IsDateValid(const Year: Integer; const Month, Day: Word): Boolean;

function IsHolidayInGermany(const Julian: TJulianDate): Boolean;

function IsHolidayInGermanyYmd(const Year: Integer; const Month, Day: Word): Boolean;

function IsLeapYear(const Year: Integer): Boolean;

function ISODateToJulianDate(const ISODate: TIsoDate): TJulianDate;

procedure ISODateToYmd(const ISODate: TIsoDate; out Year: Integer; out Month, Day: Word);

function IsCharLowLineW(const c: WideChar): Boolean;

function IsCharQuoteW(const c: WideChar): Boolean;

{$IFDEF MSWINDOWS}

function IsShiftKeyDown: Boolean;
{$ENDIF}

function IsCharWhiteSpaceOrAmpersandW(
  const c: WideChar): Boolean;

function IsCharWhiteSpaceOrNoBreakSpaceW(
  const c: WideChar): Boolean;

function IsCharWhiteSpaceOrColonW(
  const c: WideChar): Boolean;

function CharIsWhiteSpaceGtW(
  const c: WideChar): Boolean;

function CharIsWhiteSpaceLtW(
  const c: WideChar): Boolean;

function CharIsWhiteSpaceHyphenW(
  const c: WideChar): Boolean;

function CharIsWhiteSpaceHyphenGtW(
  const c: WideChar): Boolean;

function IsCharWordSeparatorW(
  const c: WideChar): Boolean;

function ISOWeekNumber(const JulianDate: TJulianDate): Word;

function ISOWeekNumberYmd(
  const Year: Integer;
  const Month, Day: Word): Word;

function ISOWeekToJulianDate(
  const Year: Integer;
  const WeekOfYear: Word;
  const DayOfWeek: Word): TJulianDate;

function JulianDateIsWeekDay(
  const JulianDate: TJulianDate): Boolean;

function JulianDateToIsoDate(
  const Julian: TJulianDate): TIsoDate;

procedure JulianDateToYmd(
  const JulianDate: TJulianDate;
  out Year: Integer;
  out Month, Day: Word);

function LastDayOfMonth(
  const JulianDate: TJulianDate): TJulianDate;

procedure LastDayOfMonthYmd(
  const Year: Integer;
  const Month: Word;
  out Day: Word);

function LastDayOfWeek(
  const JulianDate: TJulianDate): TJulianDate;

procedure LastDayOfWeekYmd(
  var Year: Integer;
  var Month, Day: Word);

{$IFDEF MSWINDOWS}

function LastSysErrorMessage: string; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function LastSysErrorMessageA: AnsiString;

function LastSysErrorMessageW: UnicodeString;
{$ENDIF MSWINDOWS}

function Max(
  const a: Integer;
  const b: Integer): Integer; {$IFDEF SUPPORTS_OVERLOAD}overload; {$ENDIF}

function Max3(const a, b, c: Integer): Integer;

{$IFDEF SUPPORTS_OVERLOAD}

function Max(
  const a: Cardinal;
  const b: Cardinal): Cardinal; overload;
{$ENDIF SUPPORTS_OVERLOAD}

{$IFDEF SUPPORTS_OVERLOAD}

function Max(
  const a: Cardinal;
  const b: Cardinal;
  const c: Cardinal): Cardinal; overload;
{$ENDIF SUPPORTS_OVERLOAD}

{$IFDEF SUPPORTS_OVERLOAD}

function Max(
  const a: Int64;
  const b: Int64): Int64; overload;
{$ENDIF SUPPORTS_OVERLOAD}

{$IFDEF SUPPORTS_OVERLOAD}

function Max(
  const a: Int64;
  const b: Int64;
  const c: Int64): Int64; overload;
{$ENDIF SUPPORTS_OVERLOAD}

function Min(
  const a, b: Integer): Integer; {$IFDEF SUPPORTS_OVERLOAD}overload; {$ENDIF}

function Min3(
  const a, b, c: Integer): Integer;

{$IFDEF SUPPORTS_OVERLOAD}

function Min(
  const a, b: Cardinal): Cardinal; overload;
{$ENDIF SUPPORTS_OVERLOAD}

{$IFDEF SUPPORTS_OVERLOAD}

function Min(
  const a, b, c: Cardinal): Cardinal; overload;
{$ENDIF SUPPORTS_OVERLOAD}

{$IFDEF SUPPORTS_OVERLOAD}

function Min(
  const a, b: Int64): Int64; overload;
{$ENDIF SUPPORTS_OVERLOAD}

{$IFDEF SUPPORTS_OVERLOAD}

function Min(
  const a, b, c: Int64): Int64; overload;
{$ENDIF SUPPORTS_OVERLOAD}

{$IFDEF SUPPORTS_OVERLOAD}

function Min(
  const a, b: UInt64): UInt64; overload;
{$ENDIF SUPPORTS_OVERLOAD}

{$IFDEF SUPPORTS_OVERLOAD}

function Min(
  const a, b, c: UInt64): UInt64; overload;
{$ENDIF SUPPORTS_OVERLOAD}

function MonthOfJulianDate(
  const JulianDate: TJulianDate): Word;

function YearOfJuilanDate(
  const JulianDate: TJulianDate): Integer;

function YmdToIsoDate(
  const Year: Integer;
  const Month, Day: Word): TIsoDate;

function YmdToJulianDate(
  const Year: Integer;
  const Month, Day: Word): TJulianDate;

type

  PDIDayTable = ^TDIDayTable;
  TDIDayTable = array[1..12] of Word;

  PDIMonthTable = ^TDIMonthTable;
  TDIMonthTable = array[1..12] of Word;

  PDIQuarterTable = ^TDIQuarterTable;
  TDIQuarterTable = array[1..4] of Word;

const
  ISO_MONDAY = 0;
  ISO_TUESDAY = 1;
  ISO_WEDNESDAY = 2;
  ISO_THURSDAY = 3;
  ISO_FRIDAY = 4;
  ISO_SATURDAY = 5;
  ISO_SUNDAY = 6;

  SHORT_DAY_NAMES_GERMAN_A: array[0..6] of AnsiString =
    ('Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So');
  SHORT_DAY_NAMES_GERMAN_W: array[0..6] of UnicodeString =
    ('Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So');

  DAYS_IN_MONTH: array[Boolean] of TDIDayTable = (
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31),
    (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31));

  QUARTER_OF_MONTH: TDIMonthTable =
    (1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4);

  HALF_YEAR_OF_MONTH: TDIMonthTable =
    (1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2);

  HALF_YEAR_OF_QUARTER: TDIQuarterTable =
    (1, 1, 2, 2);


  BitTable: array[Byte] of Byte = (
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8);

  {$IFDEF MSWINDOWS}
  {$IFNDEF DI_No_Win_9X_Support}
var
  IsUnicode: Boolean;
  {$ENDIF}
  {$ENDIF}

implementation

uses
  {$IFDEF HAS_UNITSCOPE}
  {$IFDEF MSWINDOWS}Winapi.ActiveX, Winapi.ShellAPI, {$ENDIF}
  {$ELSE HAS_UNITSCOPE}
  {$IFDEF MSWINDOWS}ActiveX, ShellAPI; {$ENDIF}
  {$ENDIF HAS_UNITSCOPE}
 // YuUtf;

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}

function CharIsLetterW(const c: WideChar): Boolean;
begin
  case c of
    #$0041..#$005A, #$0061..#$007A, #$00AA, #$00B5, #$00BA,
    #$00C0..#$00D6, #$00D8..#$00F6, #$00F8..#$02C1, #$02C6..#$02D1,
    #$02E0..#$02E4, #$02EC, #$02EE, #$0370..#$0374, #$0376..#$0377,
    #$037A..#$037D, #$037F, #$0386, #$0388..#$038A, #$038C,
    #$038E..#$03A1, #$03A3..#$03F5, #$03F7..#$0481, #$048A..#$052F,
    #$0531..#$0556, #$0559, #$0561..#$0587, #$05D0..#$05EA,
    #$05F0..#$05F2, #$0620..#$064A, #$066E..#$066F, #$0671..#$06D3,
    #$06D5, #$06E5..#$06E6, #$06EE..#$06EF, #$06FA..#$06FC,
    #$06FF, #$0710, #$0712..#$072F, #$074D..#$07A5, #$07B1,
    #$07CA..#$07EA, #$07F4..#$07F5, #$07FA, #$0800..#$0815,
    #$081A, #$0824, #$0828, #$0840..#$0858, #$08A0..#$08B2,
    #$0904..#$0939, #$093D, #$0950, #$0958..#$0961, #$0971..#$0980,
    #$0985..#$098C, #$098F..#$0990, #$0993..#$09A8, #$09AA..#$09B0,
    #$09B2, #$09B6..#$09B9, #$09BD, #$09CE, #$09DC..#$09DD,
    #$09DF..#$09E1, #$09F0..#$09F1, #$0A05..#$0A0A, #$0A0F..#$0A10,
    #$0A13..#$0A28, #$0A2A..#$0A30, #$0A32..#$0A33, #$0A35..#$0A36,
    #$0A38..#$0A39, #$0A59..#$0A5C, #$0A5E, #$0A72..#$0A74,
    #$0A85..#$0A8D, #$0A8F..#$0A91, #$0A93..#$0AA8, #$0AAA..#$0AB0,
    #$0AB2..#$0AB3, #$0AB5..#$0AB9, #$0ABD, #$0AD0, #$0AE0..#$0AE1,
    #$0B05..#$0B0C, #$0B0F..#$0B10, #$0B13..#$0B28, #$0B2A..#$0B30,
    #$0B32..#$0B33, #$0B35..#$0B39, #$0B3D, #$0B5C..#$0B5D,
    #$0B5F..#$0B61, #$0B71, #$0B83, #$0B85..#$0B8A, #$0B8E..#$0B90,
    #$0B92..#$0B95, #$0B99..#$0B9A, #$0B9C, #$0B9E..#$0B9F,
    #$0BA3..#$0BA4, #$0BA8..#$0BAA, #$0BAE..#$0BB9, #$0BD0,
    #$0C05..#$0C0C, #$0C0E..#$0C10, #$0C12..#$0C28, #$0C2A..#$0C39,
    #$0C3D, #$0C58..#$0C59, #$0C60..#$0C61, #$0C85..#$0C8C,
    #$0C8E..#$0C90, #$0C92..#$0CA8, #$0CAA..#$0CB3, #$0CB5..#$0CB9,
    #$0CBD, #$0CDE, #$0CE0..#$0CE1, #$0CF1..#$0CF2, #$0D05..#$0D0C,
    #$0D0E..#$0D10, #$0D12..#$0D3A, #$0D3D, #$0D4E, #$0D60..#$0D61,
    #$0D7A..#$0D7F, #$0D85..#$0D96, #$0D9A..#$0DB1, #$0DB3..#$0DBB,
    #$0DBD, #$0DC0..#$0DC6, #$0E01..#$0E30, #$0E32..#$0E33,
    #$0E40..#$0E46, #$0E81..#$0E82, #$0E84, #$0E87..#$0E88,
    #$0E8A, #$0E8D, #$0E94..#$0E97, #$0E99..#$0E9F, #$0EA1..#$0EA3,
    #$0EA5, #$0EA7, #$0EAA..#$0EAB, #$0EAD..#$0EB0, #$0EB2..#$0EB3,
    #$0EBD, #$0EC0..#$0EC4, #$0EC6, #$0EDC..#$0EDF, #$0F00,
    #$0F40..#$0F47, #$0F49..#$0F6C, #$0F88..#$0F8C, #$1000..#$102A,
    #$103F, #$1050..#$1055, #$105A..#$105D, #$1061, #$1065..#$1066,
    #$106E..#$1070, #$1075..#$1081, #$108E, #$10A0..#$10C5,
    #$10C7, #$10CD, #$10D0..#$10FA, #$10FC..#$1248, #$124A..#$124D,
    #$1250..#$1256, #$1258, #$125A..#$125D, #$1260..#$1288,
    #$128A..#$128D, #$1290..#$12B0, #$12B2..#$12B5, #$12B8..#$12BE,
    #$12C0, #$12C2..#$12C5, #$12C8..#$12D6, #$12D8..#$1310,
    #$1312..#$1315, #$1318..#$135A, #$1380..#$138F, #$13A0..#$13F4,
    #$1401..#$166C, #$166F..#$167F, #$1681..#$169A, #$16A0..#$16EA,
    #$16F1..#$16F8, #$1700..#$170C, #$170E..#$1711, #$1720..#$1731,
    #$1740..#$1751, #$1760..#$176C, #$176E..#$1770, #$1780..#$17B3,
    #$17D7, #$17DC, #$1820..#$1877, #$1880..#$18A8, #$18AA,
    #$18B0..#$18F5, #$1900..#$191E, #$1950..#$196D, #$1970..#$1974,
    #$1980..#$19AB, #$19C1..#$19C7, #$1A00..#$1A16, #$1A20..#$1A54,
    #$1AA7, #$1B05..#$1B33, #$1B45..#$1B4B, #$1B83..#$1BA0,
    #$1BAE..#$1BAF, #$1BBA..#$1BE5, #$1C00..#$1C23, #$1C4D..#$1C4F,
    #$1C5A..#$1C7D, #$1CE9..#$1CEC, #$1CEE..#$1CF1, #$1CF5..#$1CF6,
    #$1D00..#$1DBF, #$1E00..#$1F15, #$1F18..#$1F1D, #$1F20..#$1F45,
    #$1F48..#$1F4D, #$1F50..#$1F57, #$1F59, #$1F5B, #$1F5D,
    #$1F5F..#$1F7D, #$1F80..#$1FB4, #$1FB6..#$1FBC, #$1FBE,
    #$1FC2..#$1FC4, #$1FC6..#$1FCC, #$1FD0..#$1FD3, #$1FD6..#$1FDB,
    #$1FE0..#$1FEC, #$1FF2..#$1FF4, #$1FF6..#$1FFC, #$2071,
    #$207F, #$2090..#$209C, #$2102, #$2107, #$210A..#$2113,
    #$2115, #$2119..#$211D, #$2124, #$2126, #$2128, #$212A..#$212D,
    #$212F..#$2139, #$213C..#$213F, #$2145..#$2149, #$214E,
    #$2183..#$2184, #$2C00..#$2C2E, #$2C30..#$2C5E, #$2C60..#$2CE4,
    #$2CEB..#$2CEE, #$2CF2..#$2CF3, #$2D00..#$2D25, #$2D27,
    #$2D2D, #$2D30..#$2D67, #$2D6F, #$2D80..#$2D96, #$2DA0..#$2DA6,
    #$2DA8..#$2DAE, #$2DB0..#$2DB6, #$2DB8..#$2DBE, #$2DC0..#$2DC6,
    #$2DC8..#$2DCE, #$2DD0..#$2DD6, #$2DD8..#$2DDE, #$2E2F,
    #$3005..#$3006, #$3031..#$3035, #$303B..#$303C, #$3041..#$3096,
    #$309D..#$309F, #$30A1..#$30FA, #$30FC..#$30FF, #$3105..#$312D,
    #$3131..#$318E, #$31A0..#$31BA, #$31F0..#$31FF, #$3400..#$4DB5,
    #$4E00..#$9FCC, #$A000..#$A48C, #$A4D0..#$A4FD, #$A500..#$A60C,
    #$A610..#$A61F, #$A62A..#$A62B, #$A640..#$A66E, #$A67F..#$A69D,
    #$A6A0..#$A6E5, #$A717..#$A71F, #$A722..#$A788, #$A78B..#$A78E,
    #$A790..#$A7AD, #$A7B0..#$A7B1, #$A7F7..#$A801, #$A803..#$A805,
    #$A807..#$A80A, #$A80C..#$A822, #$A840..#$A873, #$A882..#$A8B3,
    #$A8F2..#$A8F7, #$A8FB, #$A90A..#$A925, #$A930..#$A946,
    #$A960..#$A97C, #$A984..#$A9B2, #$A9CF, #$A9E0..#$A9E4,
    #$A9E6..#$A9EF, #$A9FA..#$A9FE, #$AA00..#$AA28, #$AA40..#$AA42,
    #$AA44..#$AA4B, #$AA60..#$AA76, #$AA7A, #$AA7E..#$AAAF,
    #$AAB1, #$AAB5..#$AAB6, #$AAB9..#$AABD, #$AAC0, #$AAC2,
    #$AADB..#$AADD, #$AAE0..#$AAEA, #$AAF2..#$AAF4, #$AB01..#$AB06,
    #$AB09..#$AB0E, #$AB11..#$AB16, #$AB20..#$AB26, #$AB28..#$AB2E,
    #$AB30..#$AB5A, #$AB5C..#$AB5F, #$AB64..#$AB65, #$ABC0..#$ABE2,
    #$AC00..#$D7A3, #$D7B0..#$D7C6, #$D7CB..#$D7FB, #$F900..#$FA6D,
    #$FA70..#$FAD9, #$FB00..#$FB06, #$FB13..#$FB17, #$FB1D,
    #$FB1F..#$FB28, #$FB2A..#$FB36, #$FB38..#$FB3C, #$FB3E,
    #$FB40..#$FB41, #$FB43..#$FB44, #$FB46..#$FBB1, #$FBD3..#$FD3D,
    #$FD50..#$FD8F, #$FD92..#$FDC7, #$FDF0..#$FDFB, #$FE70..#$FE74,
    #$FE76..#$FEFC, #$FF21..#$FF3A, #$FF41..#$FF5A, #$FF66..#$FFBE,
    #$FFC2..#$FFC7, #$FFCA..#$FFCF, #$FFD2..#$FFD7, #$FFDA..#$FFDC:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterCommonW(const c: WideChar): Boolean;
begin
  case c of
    #$0041..#$005A, #$0061..#$007A, #$00B5, #$00C0..#$00D6,
    #$00D8..#$00F6, #$00F8..#$01BA, #$01BC..#$01BF, #$01C4..#$0293,
    #$0295..#$02AF, #$0370..#$0373, #$0376..#$0377, #$037B..#$037D,
    #$037F, #$0386, #$0388..#$038A, #$038C, #$038E..#$03A1,
    #$03A3..#$03F5, #$03F7..#$0481, #$048A..#$052F, #$0531..#$0556,
    #$0561..#$0587, #$10A0..#$10C5, #$10C7, #$10CD, #$1D00..#$1D2B,
    #$1D6B..#$1D77, #$1D79..#$1D9A, #$1E00..#$1F15, #$1F18..#$1F1D,
    #$1F20..#$1F45, #$1F48..#$1F4D, #$1F50..#$1F57, #$1F59,
    #$1F5B, #$1F5D, #$1F5F..#$1F7D, #$1F80..#$1FB4, #$1FB6..#$1FBC,
    #$1FBE, #$1FC2..#$1FC4, #$1FC6..#$1FCC, #$1FD0..#$1FD3,
    #$1FD6..#$1FDB, #$1FE0..#$1FEC, #$1FF2..#$1FF4, #$1FF6..#$1FFC,
    #$2102, #$2107, #$210A..#$2113, #$2115, #$2119..#$211D,
    #$2124, #$2126, #$2128, #$212A..#$212D, #$212F..#$2134,
    #$2139, #$213C..#$213F, #$2145..#$2149, #$214E, #$2183..#$2184,
    #$2C00..#$2C2E, #$2C30..#$2C5E, #$2C60..#$2C7B, #$2C7E..#$2CE4,
    #$2CEB..#$2CEE, #$2CF2..#$2CF3, #$2D00..#$2D25, #$2D27,
    #$2D2D, #$A640..#$A66D, #$A680..#$A69B, #$A722..#$A76F,
    #$A771..#$A787, #$A78B..#$A78E, #$A790..#$A7AD, #$A7B0..#$A7B1,
    #$A7FA, #$AB30..#$AB5A, #$AB64..#$AB65, #$FB00..#$FB06,
    #$FB13..#$FB17, #$FF21..#$FF3A, #$FF41..#$FF5A:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterUpperCaseW(const c: WideChar): Boolean;
begin
  case c of
    #$0041..#$005A, #$00C0..#$00D6, #$00D8..#$00DE, #$0100,
    #$0102, #$0104, #$0106, #$0108, #$010A, #$010C, #$010E,
    #$0110, #$0112, #$0114, #$0116, #$0118, #$011A, #$011C,
    #$011E, #$0120, #$0122, #$0124, #$0126, #$0128, #$012A,
    #$012C, #$012E, #$0130, #$0132, #$0134, #$0136, #$0139,
    #$013B, #$013D, #$013F, #$0141, #$0143, #$0145, #$0147,
    #$014A, #$014C, #$014E, #$0150, #$0152, #$0154, #$0156,
    #$0158, #$015A, #$015C, #$015E, #$0160, #$0162, #$0164,
    #$0166, #$0168, #$016A, #$016C, #$016E, #$0170, #$0172,
    #$0174, #$0176, #$0178..#$0179, #$017B, #$017D, #$0181..#$0182,
    #$0184, #$0186..#$0187, #$0189..#$018B, #$018E..#$0191,
    #$0193..#$0194, #$0196..#$0198, #$019C..#$019D, #$019F..#$01A0,
    #$01A2, #$01A4, #$01A6..#$01A7, #$01A9, #$01AC, #$01AE..#$01AF,
    #$01B1..#$01B3, #$01B5, #$01B7..#$01B8, #$01BC, #$01C4,
    #$01C7, #$01CA, #$01CD, #$01CF, #$01D1, #$01D3, #$01D5,
    #$01D7, #$01D9, #$01DB, #$01DE, #$01E0, #$01E2, #$01E4,
    #$01E6, #$01E8, #$01EA, #$01EC, #$01EE, #$01F1, #$01F4,
    #$01F6..#$01F8, #$01FA, #$01FC, #$01FE, #$0200, #$0202,
    #$0204, #$0206, #$0208, #$020A, #$020C, #$020E, #$0210,
    #$0212, #$0214, #$0216, #$0218, #$021A, #$021C, #$021E,
    #$0220, #$0222, #$0224, #$0226, #$0228, #$022A, #$022C,
    #$022E, #$0230, #$0232, #$023A..#$023B, #$023D..#$023E,
    #$0241, #$0243..#$0246, #$0248, #$024A, #$024C, #$024E,
    #$0370, #$0372, #$0376, #$037F, #$0386, #$0388..#$038A,
    #$038C, #$038E..#$038F, #$0391..#$03A1, #$03A3..#$03AB,
    #$03CF, #$03D2..#$03D4, #$03D8, #$03DA, #$03DC, #$03DE,
    #$03E0, #$03E2, #$03E4, #$03E6, #$03E8, #$03EA, #$03EC,
    #$03EE, #$03F4, #$03F7, #$03F9..#$03FA, #$03FD..#$042F,
    #$0460, #$0462, #$0464, #$0466, #$0468, #$046A, #$046C,
    #$046E, #$0470, #$0472, #$0474, #$0476, #$0478, #$047A,
    #$047C, #$047E, #$0480, #$048A, #$048C, #$048E, #$0490,
    #$0492, #$0494, #$0496, #$0498, #$049A, #$049C, #$049E,
    #$04A0, #$04A2, #$04A4, #$04A6, #$04A8, #$04AA, #$04AC,
    #$04AE, #$04B0, #$04B2, #$04B4, #$04B6, #$04B8, #$04BA,
    #$04BC, #$04BE, #$04C0..#$04C1, #$04C3, #$04C5, #$04C7,
    #$04C9, #$04CB, #$04CD, #$04D0, #$04D2, #$04D4, #$04D6,
    #$04D8, #$04DA, #$04DC, #$04DE, #$04E0, #$04E2, #$04E4,
    #$04E6, #$04E8, #$04EA, #$04EC, #$04EE, #$04F0, #$04F2,
    #$04F4, #$04F6, #$04F8, #$04FA, #$04FC, #$04FE, #$0500,
    #$0502, #$0504, #$0506, #$0508, #$050A, #$050C, #$050E,
    #$0510, #$0512, #$0514, #$0516, #$0518, #$051A, #$051C,
    #$051E, #$0520, #$0522, #$0524, #$0526, #$0528, #$052A,
    #$052C, #$052E, #$0531..#$0556, #$10A0..#$10C5, #$10C7,
    #$10CD, #$1E00, #$1E02, #$1E04, #$1E06, #$1E08, #$1E0A,
    #$1E0C, #$1E0E, #$1E10, #$1E12, #$1E14, #$1E16, #$1E18,
    #$1E1A, #$1E1C, #$1E1E, #$1E20, #$1E22, #$1E24, #$1E26,
    #$1E28, #$1E2A, #$1E2C, #$1E2E, #$1E30, #$1E32, #$1E34,
    #$1E36, #$1E38, #$1E3A, #$1E3C, #$1E3E, #$1E40, #$1E42,
    #$1E44, #$1E46, #$1E48, #$1E4A, #$1E4C, #$1E4E, #$1E50,
    #$1E52, #$1E54, #$1E56, #$1E58, #$1E5A, #$1E5C, #$1E5E,
    #$1E60, #$1E62, #$1E64, #$1E66, #$1E68, #$1E6A, #$1E6C,
    #$1E6E, #$1E70, #$1E72, #$1E74, #$1E76, #$1E78, #$1E7A,
    #$1E7C, #$1E7E, #$1E80, #$1E82, #$1E84, #$1E86, #$1E88,
    #$1E8A, #$1E8C, #$1E8E, #$1E90, #$1E92, #$1E94, #$1E9E,
    #$1EA0, #$1EA2, #$1EA4, #$1EA6, #$1EA8, #$1EAA, #$1EAC,
    #$1EAE, #$1EB0, #$1EB2, #$1EB4, #$1EB6, #$1EB8, #$1EBA,
    #$1EBC, #$1EBE, #$1EC0, #$1EC2, #$1EC4, #$1EC6, #$1EC8,
    #$1ECA, #$1ECC, #$1ECE, #$1ED0, #$1ED2, #$1ED4, #$1ED6,
    #$1ED8, #$1EDA, #$1EDC, #$1EDE, #$1EE0, #$1EE2, #$1EE4,
    #$1EE6, #$1EE8, #$1EEA, #$1EEC, #$1EEE, #$1EF0, #$1EF2,
    #$1EF4, #$1EF6, #$1EF8, #$1EFA, #$1EFC, #$1EFE, #$1F08..#$1F0F,
    #$1F18..#$1F1D, #$1F28..#$1F2F, #$1F38..#$1F3F, #$1F48..#$1F4D,
    #$1F59, #$1F5B, #$1F5D, #$1F5F, #$1F68..#$1F6F, #$1FB8..#$1FBB,
    #$1FC8..#$1FCB, #$1FD8..#$1FDB, #$1FE8..#$1FEC, #$1FF8..#$1FFB,
    #$2102, #$2107, #$210B..#$210D, #$2110..#$2112, #$2115,
    #$2119..#$211D, #$2124, #$2126, #$2128, #$212A..#$212D,
    #$2130..#$2133, #$213E..#$213F, #$2145, #$2183, #$2C00..#$2C2E,
    #$2C60, #$2C62..#$2C64, #$2C67, #$2C69, #$2C6B, #$2C6D..#$2C70,
    #$2C72, #$2C75, #$2C7E..#$2C80, #$2C82, #$2C84, #$2C86,
    #$2C88, #$2C8A, #$2C8C, #$2C8E, #$2C90, #$2C92, #$2C94,
    #$2C96, #$2C98, #$2C9A, #$2C9C, #$2C9E, #$2CA0, #$2CA2,
    #$2CA4, #$2CA6, #$2CA8, #$2CAA, #$2CAC, #$2CAE, #$2CB0,
    #$2CB2, #$2CB4, #$2CB6, #$2CB8, #$2CBA, #$2CBC, #$2CBE,
    #$2CC0, #$2CC2, #$2CC4, #$2CC6, #$2CC8, #$2CCA, #$2CCC,
    #$2CCE, #$2CD0, #$2CD2, #$2CD4, #$2CD6, #$2CD8, #$2CDA,
    #$2CDC, #$2CDE, #$2CE0, #$2CE2, #$2CEB, #$2CED, #$2CF2,
    #$A640, #$A642, #$A644, #$A646, #$A648, #$A64A, #$A64C,
    #$A64E, #$A650, #$A652, #$A654, #$A656, #$A658, #$A65A,
    #$A65C, #$A65E, #$A660, #$A662, #$A664, #$A666, #$A668,
    #$A66A, #$A66C, #$A680, #$A682, #$A684, #$A686, #$A688,
    #$A68A, #$A68C, #$A68E, #$A690, #$A692, #$A694, #$A696,
    #$A698, #$A69A, #$A722, #$A724, #$A726, #$A728, #$A72A,
    #$A72C, #$A72E, #$A732, #$A734, #$A736, #$A738, #$A73A,
    #$A73C, #$A73E, #$A740, #$A742, #$A744, #$A746, #$A748,
    #$A74A, #$A74C, #$A74E, #$A750, #$A752, #$A754, #$A756,
    #$A758, #$A75A, #$A75C, #$A75E, #$A760, #$A762, #$A764,
    #$A766, #$A768, #$A76A, #$A76C, #$A76E, #$A779, #$A77B,
    #$A77D..#$A77E, #$A780, #$A782, #$A784, #$A786, #$A78B,
    #$A78D, #$A790, #$A792, #$A796, #$A798, #$A79A, #$A79C,
    #$A79E, #$A7A0, #$A7A2, #$A7A4, #$A7A6, #$A7A8, #$A7AA..#$A7AD,
    #$A7B0..#$A7B1, #$FF21..#$FF3A:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterLowerCaseW(const c: WideChar): Boolean;
begin
  case c of
    #$0061..#$007A, #$00B5, #$00DF..#$00F6, #$00F8..#$00FF,
    #$0101, #$0103, #$0105, #$0107, #$0109, #$010B, #$010D,
    #$010F, #$0111, #$0113, #$0115, #$0117, #$0119, #$011B,
    #$011D, #$011F, #$0121, #$0123, #$0125, #$0127, #$0129,
    #$012B, #$012D, #$012F, #$0131, #$0133, #$0135, #$0137..#$0138,
    #$013A, #$013C, #$013E, #$0140, #$0142, #$0144, #$0146,
    #$0148..#$0149, #$014B, #$014D, #$014F, #$0151, #$0153,
    #$0155, #$0157, #$0159, #$015B, #$015D, #$015F, #$0161,
    #$0163, #$0165, #$0167, #$0169, #$016B, #$016D, #$016F,
    #$0171, #$0173, #$0175, #$0177, #$017A, #$017C, #$017E..#$0180,
    #$0183, #$0185, #$0188, #$018C..#$018D, #$0192, #$0195,
    #$0199..#$019B, #$019E, #$01A1, #$01A3, #$01A5, #$01A8,
    #$01AA..#$01AB, #$01AD, #$01B0, #$01B4, #$01B6, #$01B9..#$01BA,
    #$01BD..#$01BF, #$01C6, #$01C9, #$01CC, #$01CE, #$01D0,
    #$01D2, #$01D4, #$01D6, #$01D8, #$01DA, #$01DC..#$01DD,
    #$01DF, #$01E1, #$01E3, #$01E5, #$01E7, #$01E9, #$01EB,
    #$01ED, #$01EF..#$01F0, #$01F3, #$01F5, #$01F9, #$01FB,
    #$01FD, #$01FF, #$0201, #$0203, #$0205, #$0207, #$0209,
    #$020B, #$020D, #$020F, #$0211, #$0213, #$0215, #$0217,
    #$0219, #$021B, #$021D, #$021F, #$0221, #$0223, #$0225,
    #$0227, #$0229, #$022B, #$022D, #$022F, #$0231, #$0233..#$0239,
    #$023C, #$023F..#$0240, #$0242, #$0247, #$0249, #$024B,
    #$024D, #$024F..#$0293, #$0295..#$02AF, #$0371, #$0373,
    #$0377, #$037B..#$037D, #$0390, #$03AC..#$03CE, #$03D0..#$03D1,
    #$03D5..#$03D7, #$03D9, #$03DB, #$03DD, #$03DF, #$03E1,
    #$03E3, #$03E5, #$03E7, #$03E9, #$03EB, #$03ED, #$03EF..#$03F3,
    #$03F5, #$03F8, #$03FB..#$03FC, #$0430..#$045F, #$0461,
    #$0463, #$0465, #$0467, #$0469, #$046B, #$046D, #$046F,
    #$0471, #$0473, #$0475, #$0477, #$0479, #$047B, #$047D,
    #$047F, #$0481, #$048B, #$048D, #$048F, #$0491, #$0493,
    #$0495, #$0497, #$0499, #$049B, #$049D, #$049F, #$04A1,
    #$04A3, #$04A5, #$04A7, #$04A9, #$04AB, #$04AD, #$04AF,
    #$04B1, #$04B3, #$04B5, #$04B7, #$04B9, #$04BB, #$04BD,
    #$04BF, #$04C2, #$04C4, #$04C6, #$04C8, #$04CA, #$04CC,
    #$04CE..#$04CF, #$04D1, #$04D3, #$04D5, #$04D7, #$04D9,
    #$04DB, #$04DD, #$04DF, #$04E1, #$04E3, #$04E5, #$04E7,
    #$04E9, #$04EB, #$04ED, #$04EF, #$04F1, #$04F3, #$04F5,
    #$04F7, #$04F9, #$04FB, #$04FD, #$04FF, #$0501, #$0503,
    #$0505, #$0507, #$0509, #$050B, #$050D, #$050F, #$0511,
    #$0513, #$0515, #$0517, #$0519, #$051B, #$051D, #$051F,
    #$0521, #$0523, #$0525, #$0527, #$0529, #$052B, #$052D,
    #$052F, #$0561..#$0587, #$1D00..#$1D2B, #$1D6B..#$1D77,
    #$1D79..#$1D9A, #$1E01, #$1E03, #$1E05, #$1E07, #$1E09,
    #$1E0B, #$1E0D, #$1E0F, #$1E11, #$1E13, #$1E15, #$1E17,
    #$1E19, #$1E1B, #$1E1D, #$1E1F, #$1E21, #$1E23, #$1E25,
    #$1E27, #$1E29, #$1E2B, #$1E2D, #$1E2F, #$1E31, #$1E33,
    #$1E35, #$1E37, #$1E39, #$1E3B, #$1E3D, #$1E3F, #$1E41,
    #$1E43, #$1E45, #$1E47, #$1E49, #$1E4B, #$1E4D, #$1E4F,
    #$1E51, #$1E53, #$1E55, #$1E57, #$1E59, #$1E5B, #$1E5D,
    #$1E5F, #$1E61, #$1E63, #$1E65, #$1E67, #$1E69, #$1E6B,
    #$1E6D, #$1E6F, #$1E71, #$1E73, #$1E75, #$1E77, #$1E79,
    #$1E7B, #$1E7D, #$1E7F, #$1E81, #$1E83, #$1E85, #$1E87,
    #$1E89, #$1E8B, #$1E8D, #$1E8F, #$1E91, #$1E93, #$1E95..#$1E9D,
    #$1E9F, #$1EA1, #$1EA3, #$1EA5, #$1EA7, #$1EA9, #$1EAB,
    #$1EAD, #$1EAF, #$1EB1, #$1EB3, #$1EB5, #$1EB7, #$1EB9,
    #$1EBB, #$1EBD, #$1EBF, #$1EC1, #$1EC3, #$1EC5, #$1EC7,
    #$1EC9, #$1ECB, #$1ECD, #$1ECF, #$1ED1, #$1ED3, #$1ED5,
    #$1ED7, #$1ED9, #$1EDB, #$1EDD, #$1EDF, #$1EE1, #$1EE3,
    #$1EE5, #$1EE7, #$1EE9, #$1EEB, #$1EED, #$1EEF, #$1EF1,
    #$1EF3, #$1EF5, #$1EF7, #$1EF9, #$1EFB, #$1EFD, #$1EFF..#$1F07,
    #$1F10..#$1F15, #$1F20..#$1F27, #$1F30..#$1F37, #$1F40..#$1F45,
    #$1F50..#$1F57, #$1F60..#$1F67, #$1F70..#$1F7D, #$1F80..#$1F87,
    #$1F90..#$1F97, #$1FA0..#$1FA7, #$1FB0..#$1FB4, #$1FB6..#$1FB7,
    #$1FBE, #$1FC2..#$1FC4, #$1FC6..#$1FC7, #$1FD0..#$1FD3,
    #$1FD6..#$1FD7, #$1FE0..#$1FE7, #$1FF2..#$1FF4, #$1FF6..#$1FF7,
    #$210A, #$210E..#$210F, #$2113, #$212F, #$2134, #$2139,
    #$213C..#$213D, #$2146..#$2149, #$214E, #$2184, #$2C30..#$2C5E,
    #$2C61, #$2C65..#$2C66, #$2C68, #$2C6A, #$2C6C, #$2C71,
    #$2C73..#$2C74, #$2C76..#$2C7B, #$2C81, #$2C83, #$2C85,
    #$2C87, #$2C89, #$2C8B, #$2C8D, #$2C8F, #$2C91, #$2C93,
    #$2C95, #$2C97, #$2C99, #$2C9B, #$2C9D, #$2C9F, #$2CA1,
    #$2CA3, #$2CA5, #$2CA7, #$2CA9, #$2CAB, #$2CAD, #$2CAF,
    #$2CB1, #$2CB3, #$2CB5, #$2CB7, #$2CB9, #$2CBB, #$2CBD,
    #$2CBF, #$2CC1, #$2CC3, #$2CC5, #$2CC7, #$2CC9, #$2CCB,
    #$2CCD, #$2CCF, #$2CD1, #$2CD3, #$2CD5, #$2CD7, #$2CD9,
    #$2CDB, #$2CDD, #$2CDF, #$2CE1, #$2CE3..#$2CE4, #$2CEC,
    #$2CEE, #$2CF3, #$2D00..#$2D25, #$2D27, #$2D2D, #$A641,
    #$A643, #$A645, #$A647, #$A649, #$A64B, #$A64D, #$A64F,
    #$A651, #$A653, #$A655, #$A657, #$A659, #$A65B, #$A65D,
    #$A65F, #$A661, #$A663, #$A665, #$A667, #$A669, #$A66B,
    #$A66D, #$A681, #$A683, #$A685, #$A687, #$A689, #$A68B,
    #$A68D, #$A68F, #$A691, #$A693, #$A695, #$A697, #$A699,
    #$A69B, #$A723, #$A725, #$A727, #$A729, #$A72B, #$A72D,
    #$A72F..#$A731, #$A733, #$A735, #$A737, #$A739, #$A73B,
    #$A73D, #$A73F, #$A741, #$A743, #$A745, #$A747, #$A749,
    #$A74B, #$A74D, #$A74F, #$A751, #$A753, #$A755, #$A757,
    #$A759, #$A75B, #$A75D, #$A75F, #$A761, #$A763, #$A765,
    #$A767, #$A769, #$A76B, #$A76D, #$A76F, #$A771..#$A778,
    #$A77A, #$A77C, #$A77F, #$A781, #$A783, #$A785, #$A787,
    #$A78C, #$A78E, #$A791, #$A793..#$A795, #$A797, #$A799,
    #$A79B, #$A79D, #$A79F, #$A7A1, #$A7A3, #$A7A5, #$A7A7,
    #$A7A9, #$A7FA, #$AB30..#$AB5A, #$AB64..#$AB65, #$FB00..#$FB06,
    #$FB13..#$FB17, #$FF41..#$FF5A:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterTitleCaseW(const c: WideChar): Boolean;
begin
  case c of
    #$01C5, #$01C8, #$01CB, #$01F2, #$1F88..#$1F8F, #$1F98..#$1F9F,
    #$1FA8..#$1FAF, #$1FBC, #$1FCC, #$1FFC:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterModifierW(const c: WideChar): Boolean;
begin
  case c of
    #$02B0..#$02C1, #$02C6..#$02D1, #$02E0..#$02E4, #$02EC,
    #$02EE, #$0374, #$037A, #$0559, #$0640, #$06E5..#$06E6,
    #$07F4..#$07F5, #$07FA, #$081A, #$0824, #$0828, #$0971,
    #$0E46, #$0EC6, #$10FC, #$17D7, #$1843, #$1AA7, #$1C78..#$1C7D,
    #$1D2C..#$1D6A, #$1D78, #$1D9B..#$1DBF, #$2071, #$207F,
    #$2090..#$209C, #$2C7C..#$2C7D, #$2D6F, #$2E2F, #$3005,
    #$3031..#$3035, #$303B, #$309D..#$309E, #$30FC..#$30FE,
    #$A015, #$A4F8..#$A4FD, #$A60C, #$A67F, #$A69C..#$A69D,
    #$A717..#$A71F, #$A770, #$A788, #$A7F8..#$A7F9, #$A9CF,
    #$A9E6, #$AA70, #$AADD, #$AAF3..#$AAF4, #$AB5C..#$AB5F,
    #$FF70, #$FF9E..#$FF9F:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterOtherW(const c: WideChar): Boolean;
begin
  case c of
    #$00AA, #$00BA, #$01BB, #$01C0..#$01C3, #$0294, #$05D0..#$05EA,
    #$05F0..#$05F2, #$0620..#$063F, #$0641..#$064A, #$066E..#$066F,
    #$0671..#$06D3, #$06D5, #$06EE..#$06EF, #$06FA..#$06FC,
    #$06FF, #$0710, #$0712..#$072F, #$074D..#$07A5, #$07B1,
    #$07CA..#$07EA, #$0800..#$0815, #$0840..#$0858, #$08A0..#$08B2,
    #$0904..#$0939, #$093D, #$0950, #$0958..#$0961, #$0972..#$0980,
    #$0985..#$098C, #$098F..#$0990, #$0993..#$09A8, #$09AA..#$09B0,
    #$09B2, #$09B6..#$09B9, #$09BD, #$09CE, #$09DC..#$09DD,
    #$09DF..#$09E1, #$09F0..#$09F1, #$0A05..#$0A0A, #$0A0F..#$0A10,
    #$0A13..#$0A28, #$0A2A..#$0A30, #$0A32..#$0A33, #$0A35..#$0A36,
    #$0A38..#$0A39, #$0A59..#$0A5C, #$0A5E, #$0A72..#$0A74,
    #$0A85..#$0A8D, #$0A8F..#$0A91, #$0A93..#$0AA8, #$0AAA..#$0AB0,
    #$0AB2..#$0AB3, #$0AB5..#$0AB9, #$0ABD, #$0AD0, #$0AE0..#$0AE1,
    #$0B05..#$0B0C, #$0B0F..#$0B10, #$0B13..#$0B28, #$0B2A..#$0B30,
    #$0B32..#$0B33, #$0B35..#$0B39, #$0B3D, #$0B5C..#$0B5D,
    #$0B5F..#$0B61, #$0B71, #$0B83, #$0B85..#$0B8A, #$0B8E..#$0B90,
    #$0B92..#$0B95, #$0B99..#$0B9A, #$0B9C, #$0B9E..#$0B9F,
    #$0BA3..#$0BA4, #$0BA8..#$0BAA, #$0BAE..#$0BB9, #$0BD0,
    #$0C05..#$0C0C, #$0C0E..#$0C10, #$0C12..#$0C28, #$0C2A..#$0C39,
    #$0C3D, #$0C58..#$0C59, #$0C60..#$0C61, #$0C85..#$0C8C,
    #$0C8E..#$0C90, #$0C92..#$0CA8, #$0CAA..#$0CB3, #$0CB5..#$0CB9,
    #$0CBD, #$0CDE, #$0CE0..#$0CE1, #$0CF1..#$0CF2, #$0D05..#$0D0C,
    #$0D0E..#$0D10, #$0D12..#$0D3A, #$0D3D, #$0D4E, #$0D60..#$0D61,
    #$0D7A..#$0D7F, #$0D85..#$0D96, #$0D9A..#$0DB1, #$0DB3..#$0DBB,
    #$0DBD, #$0DC0..#$0DC6, #$0E01..#$0E30, #$0E32..#$0E33,
    #$0E40..#$0E45, #$0E81..#$0E82, #$0E84, #$0E87..#$0E88,
    #$0E8A, #$0E8D, #$0E94..#$0E97, #$0E99..#$0E9F, #$0EA1..#$0EA3,
    #$0EA5, #$0EA7, #$0EAA..#$0EAB, #$0EAD..#$0EB0, #$0EB2..#$0EB3,
    #$0EBD, #$0EC0..#$0EC4, #$0EDC..#$0EDF, #$0F00, #$0F40..#$0F47,
    #$0F49..#$0F6C, #$0F88..#$0F8C, #$1000..#$102A, #$103F,
    #$1050..#$1055, #$105A..#$105D, #$1061, #$1065..#$1066,
    #$106E..#$1070, #$1075..#$1081, #$108E, #$10D0..#$10FA,
    #$10FD..#$1248, #$124A..#$124D, #$1250..#$1256, #$1258,
    #$125A..#$125D, #$1260..#$1288, #$128A..#$128D, #$1290..#$12B0,
    #$12B2..#$12B5, #$12B8..#$12BE, #$12C0, #$12C2..#$12C5,
    #$12C8..#$12D6, #$12D8..#$1310, #$1312..#$1315, #$1318..#$135A,
    #$1380..#$138F, #$13A0..#$13F4, #$1401..#$166C, #$166F..#$167F,
    #$1681..#$169A, #$16A0..#$16EA, #$16F1..#$16F8, #$1700..#$170C,
    #$170E..#$1711, #$1720..#$1731, #$1740..#$1751, #$1760..#$176C,
    #$176E..#$1770, #$1780..#$17B3, #$17DC, #$1820..#$1842,
    #$1844..#$1877, #$1880..#$18A8, #$18AA, #$18B0..#$18F5,
    #$1900..#$191E, #$1950..#$196D, #$1970..#$1974, #$1980..#$19AB,
    #$19C1..#$19C7, #$1A00..#$1A16, #$1A20..#$1A54, #$1B05..#$1B33,
    #$1B45..#$1B4B, #$1B83..#$1BA0, #$1BAE..#$1BAF, #$1BBA..#$1BE5,
    #$1C00..#$1C23, #$1C4D..#$1C4F, #$1C5A..#$1C77, #$1CE9..#$1CEC,
    #$1CEE..#$1CF1, #$1CF5..#$1CF6, #$2135..#$2138, #$2D30..#$2D67,
    #$2D80..#$2D96, #$2DA0..#$2DA6, #$2DA8..#$2DAE, #$2DB0..#$2DB6,
    #$2DB8..#$2DBE, #$2DC0..#$2DC6, #$2DC8..#$2DCE, #$2DD0..#$2DD6,
    #$2DD8..#$2DDE, #$3006, #$303C, #$3041..#$3096, #$309F,
    #$30A1..#$30FA, #$30FF, #$3105..#$312D, #$3131..#$318E,
    #$31A0..#$31BA, #$31F0..#$31FF, #$3400..#$4DB5, #$4E00..#$9FCC,
    #$A000..#$A014, #$A016..#$A48C, #$A4D0..#$A4F7, #$A500..#$A60B,
    #$A610..#$A61F, #$A62A..#$A62B, #$A66E, #$A6A0..#$A6E5,
    #$A7F7, #$A7FB..#$A801, #$A803..#$A805, #$A807..#$A80A,
    #$A80C..#$A822, #$A840..#$A873, #$A882..#$A8B3, #$A8F2..#$A8F7,
    #$A8FB, #$A90A..#$A925, #$A930..#$A946, #$A960..#$A97C,
    #$A984..#$A9B2, #$A9E0..#$A9E4, #$A9E7..#$A9EF, #$A9FA..#$A9FE,
    #$AA00..#$AA28, #$AA40..#$AA42, #$AA44..#$AA4B, #$AA60..#$AA6F,
    #$AA71..#$AA76, #$AA7A, #$AA7E..#$AAAF, #$AAB1, #$AAB5..#$AAB6,
    #$AAB9..#$AABD, #$AAC0, #$AAC2, #$AADB..#$AADC, #$AAE0..#$AAEA,
    #$AAF2, #$AB01..#$AB06, #$AB09..#$AB0E, #$AB11..#$AB16,
    #$AB20..#$AB26, #$AB28..#$AB2E, #$ABC0..#$ABE2, #$AC00..#$D7A3,
    #$D7B0..#$D7C6, #$D7CB..#$D7FB, #$F900..#$FA6D, #$FA70..#$FAD9,
    #$FB1D, #$FB1F..#$FB28, #$FB2A..#$FB36, #$FB38..#$FB3C,
    #$FB3E, #$FB40..#$FB41, #$FB43..#$FB44, #$FB46..#$FBB1,
    #$FBD3..#$FD3D, #$FD50..#$FD8F, #$FD92..#$FDC7, #$FDF0..#$FDFB,
    #$FE70..#$FE74, #$FE76..#$FEFC, #$FF66..#$FF6F, #$FF71..#$FF9D,
    #$FFA0..#$FFBE, #$FFC2..#$FFC7, #$FFCA..#$FFCF, #$FFD2..#$FFD7,
    #$FFDA..#$FFDC:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsMarkW(const c: WideChar): Boolean;
begin
  case c of
    #$0300..#$036F, #$0483..#$0489, #$0591..#$05BD, #$05BF,
    #$05C1..#$05C2, #$05C4..#$05C5, #$05C7, #$0610..#$061A,
    #$064B..#$065F, #$0670, #$06D6..#$06DC, #$06DF..#$06E4,
    #$06E7..#$06E8, #$06EA..#$06ED, #$0711, #$0730..#$074A,
    #$07A6..#$07B0, #$07EB..#$07F3, #$0816..#$0819, #$081B..#$0823,
    #$0825..#$0827, #$0829..#$082D, #$0859..#$085B, #$08E4..#$0903,
    #$093A..#$093C, #$093E..#$094F, #$0951..#$0957, #$0962..#$0963,
    #$0981..#$0983, #$09BC, #$09BE..#$09C4, #$09C7..#$09C8,
    #$09CB..#$09CD, #$09D7, #$09E2..#$09E3, #$0A01..#$0A03,
    #$0A3C, #$0A3E..#$0A42, #$0A47..#$0A48, #$0A4B..#$0A4D,
    #$0A51, #$0A70..#$0A71, #$0A75, #$0A81..#$0A83, #$0ABC,
    #$0ABE..#$0AC5, #$0AC7..#$0AC9, #$0ACB..#$0ACD, #$0AE2..#$0AE3,
    #$0B01..#$0B03, #$0B3C, #$0B3E..#$0B44, #$0B47..#$0B48,
    #$0B4B..#$0B4D, #$0B56..#$0B57, #$0B62..#$0B63, #$0B82,
    #$0BBE..#$0BC2, #$0BC6..#$0BC8, #$0BCA..#$0BCD, #$0BD7,
    #$0C00..#$0C03, #$0C3E..#$0C44, #$0C46..#$0C48, #$0C4A..#$0C4D,
    #$0C55..#$0C56, #$0C62..#$0C63, #$0C81..#$0C83, #$0CBC,
    #$0CBE..#$0CC4, #$0CC6..#$0CC8, #$0CCA..#$0CCD, #$0CD5..#$0CD6,
    #$0CE2..#$0CE3, #$0D01..#$0D03, #$0D3E..#$0D44, #$0D46..#$0D48,
    #$0D4A..#$0D4D, #$0D57, #$0D62..#$0D63, #$0D82..#$0D83,
    #$0DCA, #$0DCF..#$0DD4, #$0DD6, #$0DD8..#$0DDF, #$0DF2..#$0DF3,
    #$0E31, #$0E34..#$0E3A, #$0E47..#$0E4E, #$0EB1, #$0EB4..#$0EB9,
    #$0EBB..#$0EBC, #$0EC8..#$0ECD, #$0F18..#$0F19, #$0F35,
    #$0F37, #$0F39, #$0F3E..#$0F3F, #$0F71..#$0F84, #$0F86..#$0F87,
    #$0F8D..#$0F97, #$0F99..#$0FBC, #$0FC6, #$102B..#$103E,
    #$1056..#$1059, #$105E..#$1060, #$1062..#$1064, #$1067..#$106D,
    #$1071..#$1074, #$1082..#$108D, #$108F, #$109A..#$109D,
    #$135D..#$135F, #$1712..#$1714, #$1732..#$1734, #$1752..#$1753,
    #$1772..#$1773, #$17B4..#$17D3, #$17DD, #$180B..#$180D,
    #$18A9, #$1920..#$192B, #$1930..#$193B, #$19B0..#$19C0,
    #$19C8..#$19C9, #$1A17..#$1A1B, #$1A55..#$1A5E, #$1A60..#$1A7C,
    #$1A7F, #$1AB0..#$1ABE, #$1B00..#$1B04, #$1B34..#$1B44,
    #$1B6B..#$1B73, #$1B80..#$1B82, #$1BA1..#$1BAD, #$1BE6..#$1BF3,
    #$1C24..#$1C37, #$1CD0..#$1CD2, #$1CD4..#$1CE8, #$1CED,
    #$1CF2..#$1CF4, #$1CF8..#$1CF9, #$1DC0..#$1DF5, #$1DFC..#$1DFF,
    #$20D0..#$20F0, #$2CEF..#$2CF1, #$2D7F, #$2DE0..#$2DFF,
    #$302A..#$302F, #$3099..#$309A, #$A66F..#$A672, #$A674..#$A67D,
    #$A69F, #$A6F0..#$A6F1, #$A802, #$A806, #$A80B, #$A823..#$A827,
    #$A880..#$A881, #$A8B4..#$A8C4, #$A8E0..#$A8F1, #$A926..#$A92D,
    #$A947..#$A953, #$A980..#$A983, #$A9B3..#$A9C0, #$A9E5,
    #$AA29..#$AA36, #$AA43, #$AA4C..#$AA4D, #$AA7B..#$AA7D,
    #$AAB0, #$AAB2..#$AAB4, #$AAB7..#$AAB8, #$AABE..#$AABF,
    #$AAC1, #$AAEB..#$AAEF, #$AAF5..#$AAF6, #$ABE3..#$ABEA,
    #$ABEC..#$ABED, #$FB1E, #$FE00..#$FE0F, #$FE20..#$FE2D:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsMarkNon_SpacingW(const c: WideChar): Boolean;
begin
  case c of
    #$0300..#$036F, #$0483..#$0487, #$0591..#$05BD, #$05BF,
    #$05C1..#$05C2, #$05C4..#$05C5, #$05C7, #$0610..#$061A,
    #$064B..#$065F, #$0670, #$06D6..#$06DC, #$06DF..#$06E4,
    #$06E7..#$06E8, #$06EA..#$06ED, #$0711, #$0730..#$074A,
    #$07A6..#$07B0, #$07EB..#$07F3, #$0816..#$0819, #$081B..#$0823,
    #$0825..#$0827, #$0829..#$082D, #$0859..#$085B, #$08E4..#$0902,
    #$093A, #$093C, #$0941..#$0948, #$094D, #$0951..#$0957,
    #$0962..#$0963, #$0981, #$09BC, #$09C1..#$09C4, #$09CD,
    #$09E2..#$09E3, #$0A01..#$0A02, #$0A3C, #$0A41..#$0A42,
    #$0A47..#$0A48, #$0A4B..#$0A4D, #$0A51, #$0A70..#$0A71,
    #$0A75, #$0A81..#$0A82, #$0ABC, #$0AC1..#$0AC5, #$0AC7..#$0AC8,
    #$0ACD, #$0AE2..#$0AE3, #$0B01, #$0B3C, #$0B3F, #$0B41..#$0B44,
    #$0B4D, #$0B56, #$0B62..#$0B63, #$0B82, #$0BC0, #$0BCD,
    #$0C00, #$0C3E..#$0C40, #$0C46..#$0C48, #$0C4A..#$0C4D,
    #$0C55..#$0C56, #$0C62..#$0C63, #$0C81, #$0CBC, #$0CBF,
    #$0CC6, #$0CCC..#$0CCD, #$0CE2..#$0CE3, #$0D01, #$0D41..#$0D44,
    #$0D4D, #$0D62..#$0D63, #$0DCA, #$0DD2..#$0DD4, #$0DD6,
    #$0E31, #$0E34..#$0E3A, #$0E47..#$0E4E, #$0EB1, #$0EB4..#$0EB9,
    #$0EBB..#$0EBC, #$0EC8..#$0ECD, #$0F18..#$0F19, #$0F35,
    #$0F37, #$0F39, #$0F71..#$0F7E, #$0F80..#$0F84, #$0F86..#$0F87,
    #$0F8D..#$0F97, #$0F99..#$0FBC, #$0FC6, #$102D..#$1030,
    #$1032..#$1037, #$1039..#$103A, #$103D..#$103E, #$1058..#$1059,
    #$105E..#$1060, #$1071..#$1074, #$1082, #$1085..#$1086,
    #$108D, #$109D, #$135D..#$135F, #$1712..#$1714, #$1732..#$1734,
    #$1752..#$1753, #$1772..#$1773, #$17B4..#$17B5, #$17B7..#$17BD,
    #$17C6, #$17C9..#$17D3, #$17DD, #$180B..#$180D, #$18A9,
    #$1920..#$1922, #$1927..#$1928, #$1932, #$1939..#$193B,
    #$1A17..#$1A18, #$1A1B, #$1A56, #$1A58..#$1A5E, #$1A60,
    #$1A62, #$1A65..#$1A6C, #$1A73..#$1A7C, #$1A7F, #$1AB0..#$1ABD,
    #$1B00..#$1B03, #$1B34, #$1B36..#$1B3A, #$1B3C, #$1B42,
    #$1B6B..#$1B73, #$1B80..#$1B81, #$1BA2..#$1BA5, #$1BA8..#$1BA9,
    #$1BAB..#$1BAD, #$1BE6, #$1BE8..#$1BE9, #$1BED, #$1BEF..#$1BF1,
    #$1C2C..#$1C33, #$1C36..#$1C37, #$1CD0..#$1CD2, #$1CD4..#$1CE0,
    #$1CE2..#$1CE8, #$1CED, #$1CF4, #$1CF8..#$1CF9, #$1DC0..#$1DF5,
    #$1DFC..#$1DFF, #$20D0..#$20DC, #$20E1, #$20E5..#$20F0,
    #$2CEF..#$2CF1, #$2D7F, #$2DE0..#$2DFF, #$302A..#$302D,
    #$3099..#$309A, #$A66F, #$A674..#$A67D, #$A69F, #$A6F0..#$A6F1,
    #$A802, #$A806, #$A80B, #$A825..#$A826, #$A8C4, #$A8E0..#$A8F1,
    #$A926..#$A92D, #$A947..#$A951, #$A980..#$A982, #$A9B3,
    #$A9B6..#$A9B9, #$A9BC, #$A9E5, #$AA29..#$AA2E, #$AA31..#$AA32,
    #$AA35..#$AA36, #$AA43, #$AA4C, #$AA7C, #$AAB0, #$AAB2..#$AAB4,
    #$AAB7..#$AAB8, #$AABE..#$AABF, #$AAC1, #$AAEC..#$AAED,
    #$AAF6, #$ABE5, #$ABE8, #$ABED, #$FB1E, #$FE00..#$FE0F,
    #$FE20..#$FE2D:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsMarkSpacing_CombinedW(const c: WideChar): Boolean;
begin
  case c of
    #$0903, #$093B, #$093E..#$0940, #$0949..#$094C, #$094E..#$094F,
    #$0982..#$0983, #$09BE..#$09C0, #$09C7..#$09C8, #$09CB..#$09CC,
    #$09D7, #$0A03, #$0A3E..#$0A40, #$0A83, #$0ABE..#$0AC0,
    #$0AC9, #$0ACB..#$0ACC, #$0B02..#$0B03, #$0B3E, #$0B40,
    #$0B47..#$0B48, #$0B4B..#$0B4C, #$0B57, #$0BBE..#$0BBF,
    #$0BC1..#$0BC2, #$0BC6..#$0BC8, #$0BCA..#$0BCC, #$0BD7,
    #$0C01..#$0C03, #$0C41..#$0C44, #$0C82..#$0C83, #$0CBE,
    #$0CC0..#$0CC4, #$0CC7..#$0CC8, #$0CCA..#$0CCB, #$0CD5..#$0CD6,
    #$0D02..#$0D03, #$0D3E..#$0D40, #$0D46..#$0D48, #$0D4A..#$0D4C,
    #$0D57, #$0D82..#$0D83, #$0DCF..#$0DD1, #$0DD8..#$0DDF,
    #$0DF2..#$0DF3, #$0F3E..#$0F3F, #$0F7F, #$102B..#$102C,
    #$1031, #$1038, #$103B..#$103C, #$1056..#$1057, #$1062..#$1064,
    #$1067..#$106D, #$1083..#$1084, #$1087..#$108C, #$108F,
    #$109A..#$109C, #$17B6, #$17BE..#$17C5, #$17C7..#$17C8,
    #$1923..#$1926, #$1929..#$192B, #$1930..#$1931, #$1933..#$1938,
    #$19B0..#$19C0, #$19C8..#$19C9, #$1A19..#$1A1A, #$1A55,
    #$1A57, #$1A61, #$1A63..#$1A64, #$1A6D..#$1A72, #$1B04,
    #$1B35, #$1B3B, #$1B3D..#$1B41, #$1B43..#$1B44, #$1B82,
    #$1BA1, #$1BA6..#$1BA7, #$1BAA, #$1BE7, #$1BEA..#$1BEC,
    #$1BEE, #$1BF2..#$1BF3, #$1C24..#$1C2B, #$1C34..#$1C35,
    #$1CE1, #$1CF2..#$1CF3, #$302E..#$302F, #$A823..#$A824,
    #$A827, #$A880..#$A881, #$A8B4..#$A8C3, #$A952..#$A953,
    #$A983, #$A9B4..#$A9B5, #$A9BA..#$A9BB, #$A9BD..#$A9C0,
    #$AA2F..#$AA30, #$AA33..#$AA34, #$AA4D, #$AA7B, #$AA7D,
    #$AAEB, #$AAEE..#$AAEF, #$AAF5, #$ABE3..#$ABE4, #$ABE6..#$ABE7,
    #$ABE9..#$ABEA, #$ABEC:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsMarkEnclosingW(const c: WideChar): Boolean;
begin
  case c of
    #$0488..#$0489, #$1ABE, #$20DD..#$20E0, #$20E2..#$20E4,
    #$A670..#$A672:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsNumberW(const c: WideChar): Boolean;
begin
  case c of
    #$0030..#$0039, #$00B2..#$00B3, #$00B9, #$00BC..#$00BE,
    #$0660..#$0669, #$06F0..#$06F9, #$07C0..#$07C9, #$0966..#$096F,
    #$09E6..#$09EF, #$09F4..#$09F9, #$0A66..#$0A6F, #$0AE6..#$0AEF,
    #$0B66..#$0B6F, #$0B72..#$0B77, #$0BE6..#$0BF2, #$0C66..#$0C6F,
    #$0C78..#$0C7E, #$0CE6..#$0CEF, #$0D66..#$0D75, #$0DE6..#$0DEF,
    #$0E50..#$0E59, #$0ED0..#$0ED9, #$0F20..#$0F33, #$1040..#$1049,
    #$1090..#$1099, #$1369..#$137C, #$16EE..#$16F0, #$17E0..#$17E9,
    #$17F0..#$17F9, #$1810..#$1819, #$1946..#$194F, #$19D0..#$19DA,
    #$1A80..#$1A89, #$1A90..#$1A99, #$1B50..#$1B59, #$1BB0..#$1BB9,
    #$1C40..#$1C49, #$1C50..#$1C59, #$2070, #$2074..#$2079,
    #$2080..#$2089, #$2150..#$2182, #$2185..#$2189, #$2460..#$249B,
    #$24EA..#$24FF, #$2776..#$2793, #$2CFD, #$3007, #$3021..#$3029,
    #$3038..#$303A, #$3192..#$3195, #$3220..#$3229, #$3248..#$324F,
    #$3251..#$325F, #$3280..#$3289, #$32B1..#$32BF, #$A620..#$A629,
    #$A6E6..#$A6EF, #$A830..#$A835, #$A8D0..#$A8D9, #$A900..#$A909,
    #$A9D0..#$A9D9, #$A9F0..#$A9F9, #$AA50..#$AA59, #$ABF0..#$ABF9,
    #$FF10..#$FF19:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsNumber_DecimalW(const c: WideChar): Boolean;
begin
  case c of
    #$0030..#$0039, #$0660..#$0669, #$06F0..#$06F9, #$07C0..#$07C9,
    #$0966..#$096F, #$09E6..#$09EF, #$0A66..#$0A6F, #$0AE6..#$0AEF,
    #$0B66..#$0B6F, #$0BE6..#$0BEF, #$0C66..#$0C6F, #$0CE6..#$0CEF,
    #$0D66..#$0D6F, #$0DE6..#$0DEF, #$0E50..#$0E59, #$0ED0..#$0ED9,
    #$0F20..#$0F29, #$1040..#$1049, #$1090..#$1099, #$17E0..#$17E9,
    #$1810..#$1819, #$1946..#$194F, #$19D0..#$19D9, #$1A80..#$1A89,
    #$1A90..#$1A99, #$1B50..#$1B59, #$1BB0..#$1BB9, #$1C40..#$1C49,
    #$1C50..#$1C59, #$A620..#$A629, #$A8D0..#$A8D9, #$A900..#$A909,
    #$A9D0..#$A9D9, #$A9F0..#$A9F9, #$AA50..#$AA59, #$ABF0..#$ABF9,
    #$FF10..#$FF19:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsNumber_LetterW(const c: WideChar): Boolean;
begin
  case c of
    #$16EE..#$16F0, #$2160..#$2182, #$2185..#$2188, #$3007,
    #$3021..#$3029, #$3038..#$303A, #$A6E6..#$A6EF:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsNumber_OtherW(const c: WideChar): Boolean;
begin
  case c of
    #$00B2..#$00B3, #$00B9, #$00BC..#$00BE, #$09F4..#$09F9,
    #$0B72..#$0B77, #$0BF0..#$0BF2, #$0C78..#$0C7E, #$0D70..#$0D75,
    #$0F2A..#$0F33, #$1369..#$137C, #$17F0..#$17F9, #$19DA,
    #$2070, #$2074..#$2079, #$2080..#$2089, #$2150..#$215F,
    #$2189, #$2460..#$249B, #$24EA..#$24FF, #$2776..#$2793,
    #$2CFD, #$3192..#$3195, #$3220..#$3229, #$3248..#$324F,
    #$3251..#$325F, #$3280..#$3289, #$32B1..#$32BF, #$A830..#$A835:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuationW(const c: WideChar): Boolean;
begin
  case c of
    #$0021..#$0023, #$0025..#$002A, #$002C..#$002F, #$003A..#$003B,
    #$003F..#$0040, #$005B..#$005D, #$005F, #$007B, #$007D,
    #$00A1, #$00A7, #$00AB, #$00B6..#$00B7, #$00BB, #$00BF,
    #$037E, #$0387, #$055A..#$055F, #$0589..#$058A, #$05BE,
    #$05C0, #$05C3, #$05C6, #$05F3..#$05F4, #$0609..#$060A,
    #$060C..#$060D, #$061B, #$061E..#$061F, #$066A..#$066D,
    #$06D4, #$0700..#$070D, #$07F7..#$07F9, #$0830..#$083E,
    #$085E, #$0964..#$0965, #$0970, #$0AF0, #$0DF4, #$0E4F,
    #$0E5A..#$0E5B, #$0F04..#$0F12, #$0F14, #$0F3A..#$0F3D,
    #$0F85, #$0FD0..#$0FD4, #$0FD9..#$0FDA, #$104A..#$104F,
    #$10FB, #$1360..#$1368, #$1400, #$166D..#$166E, #$169B..#$169C,
    #$16EB..#$16ED, #$1735..#$1736, #$17D4..#$17D6, #$17D8..#$17DA,
    #$1800..#$180A, #$1944..#$1945, #$1A1E..#$1A1F, #$1AA0..#$1AA6,
    #$1AA8..#$1AAD, #$1B5A..#$1B60, #$1BFC..#$1BFF, #$1C3B..#$1C3F,
    #$1C7E..#$1C7F, #$1CC0..#$1CC7, #$1CD3, #$2010..#$2027,
    #$2030..#$2043, #$2045..#$2051, #$2053..#$205E, #$207D..#$207E,
    #$208D..#$208E, #$2308..#$230B, #$2329..#$232A, #$2768..#$2775,
    #$27C5..#$27C6, #$27E6..#$27EF, #$2983..#$2998, #$29D8..#$29DB,
    #$29FC..#$29FD, #$2CF9..#$2CFC, #$2CFE..#$2CFF, #$2D70,
    #$2E00..#$2E2E, #$2E30..#$2E42, #$3001..#$3003, #$3008..#$3011,
    #$3014..#$301F, #$3030, #$303D, #$30A0, #$30FB, #$A4FE..#$A4FF,
    #$A60D..#$A60F, #$A673, #$A67E, #$A6F2..#$A6F7, #$A874..#$A877,
    #$A8CE..#$A8CF, #$A8F8..#$A8FA, #$A92E..#$A92F, #$A95F,
    #$A9C1..#$A9CD, #$A9DE..#$A9DF, #$AA5C..#$AA5F, #$AADE..#$AADF,
    #$AAF0..#$AAF1, #$ABEB, #$FD3E..#$FD3F, #$FE10..#$FE19,
    #$FE30..#$FE52, #$FE54..#$FE61, #$FE63, #$FE68, #$FE6A..#$FE6B,
    #$FF01..#$FF03, #$FF05..#$FF0A, #$FF0C..#$FF0F, #$FF1A..#$FF1B,
    #$FF1F..#$FF20, #$FF3B..#$FF3D, #$FF3F, #$FF5B, #$FF5D,
    #$FF5F..#$FF65:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_ConnectorW(const c: WideChar): Boolean;
begin
  case c of
    #$005F, #$203F..#$2040, #$2054, #$FE33..#$FE34, #$FE4D..#$FE4F,
    #$FF3F:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_DashW(const c: WideChar): Boolean;
begin
  case c of
    #$002D, #$058A, #$05BE, #$1400, #$1806, #$2010..#$2015,
    #$2E17, #$2E1A, #$2E3A..#$2E3B, #$2E40, #$301C, #$3030,
    #$30A0, #$FE31..#$FE32, #$FE58, #$FE63, #$FF0D:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_OpenW(const c: WideChar): Boolean;
begin
  case c of
    #$0028, #$005B, #$007B, #$0F3A, #$0F3C, #$169B, #$201A,
    #$201E, #$2045, #$207D, #$208D, #$2308, #$230A, #$2329,
    #$2768, #$276A, #$276C, #$276E, #$2770, #$2772, #$2774,
    #$27C5, #$27E6, #$27E8, #$27EA, #$27EC, #$27EE, #$2983,
    #$2985, #$2987, #$2989, #$298B, #$298D, #$298F, #$2991,
    #$2993, #$2995, #$2997, #$29D8, #$29DA, #$29FC, #$2E22,
    #$2E24, #$2E26, #$2E28, #$2E42, #$3008, #$300A, #$300C,
    #$300E, #$3010, #$3014, #$3016, #$3018, #$301A, #$301D,
    #$FD3F, #$FE17, #$FE35, #$FE37, #$FE39, #$FE3B, #$FE3D,
    #$FE3F, #$FE41, #$FE43, #$FE47, #$FE59, #$FE5B, #$FE5D,
    #$FF08, #$FF3B, #$FF5B, #$FF5F, #$FF62:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_CloseW(const c: WideChar): Boolean;
begin
  case c of
    #$0029, #$005D, #$007D, #$0F3B, #$0F3D, #$169C, #$2046,
    #$207E, #$208E, #$2309, #$230B, #$232A, #$2769, #$276B,
    #$276D, #$276F, #$2771, #$2773, #$2775, #$27C6, #$27E7,
    #$27E9, #$27EB, #$27ED, #$27EF, #$2984, #$2986, #$2988,
    #$298A, #$298C, #$298E, #$2990, #$2992, #$2994, #$2996,
    #$2998, #$29D9, #$29DB, #$29FD, #$2E23, #$2E25, #$2E27,
    #$2E29, #$3009, #$300B, #$300D, #$300F, #$3011, #$3015,
    #$3017, #$3019, #$301B, #$301E..#$301F, #$FD3E, #$FE18,
    #$FE36, #$FE38, #$FE3A, #$FE3C, #$FE3E, #$FE40, #$FE42,
    #$FE44, #$FE48, #$FE5A, #$FE5C, #$FE5E, #$FF09, #$FF3D,
    #$FF5D, #$FF60, #$FF63:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_InitialQuoteW(const c: WideChar): Boolean;
begin
  case c of
    #$00AB, #$2018, #$201B..#$201C, #$201F, #$2039, #$2E02,
    #$2E04, #$2E09, #$2E0C, #$2E1C, #$2E20:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_FinalQuoteW(const c: WideChar): Boolean;
begin
  case c of
    #$00BB, #$2019, #$201D, #$203A, #$2E03, #$2E05, #$2E0A,
    #$2E0D, #$2E1D, #$2E21:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_OtherW(const c: WideChar): Boolean;
begin
  case c of
    #$0021..#$0023, #$0025..#$0027, #$002A, #$002C, #$002E..#$002F,
    #$003A..#$003B, #$003F..#$0040, #$005C, #$00A1, #$00A7,
    #$00B6..#$00B7, #$00BF, #$037E, #$0387, #$055A..#$055F,
    #$0589, #$05C0, #$05C3, #$05C6, #$05F3..#$05F4, #$0609..#$060A,
    #$060C..#$060D, #$061B, #$061E..#$061F, #$066A..#$066D,
    #$06D4, #$0700..#$070D, #$07F7..#$07F9, #$0830..#$083E,
    #$085E, #$0964..#$0965, #$0970, #$0AF0, #$0DF4, #$0E4F,
    #$0E5A..#$0E5B, #$0F04..#$0F12, #$0F14, #$0F85, #$0FD0..#$0FD4,
    #$0FD9..#$0FDA, #$104A..#$104F, #$10FB, #$1360..#$1368,
    #$166D..#$166E, #$16EB..#$16ED, #$1735..#$1736, #$17D4..#$17D6,
    #$17D8..#$17DA, #$1800..#$1805, #$1807..#$180A, #$1944..#$1945,
    #$1A1E..#$1A1F, #$1AA0..#$1AA6, #$1AA8..#$1AAD, #$1B5A..#$1B60,
    #$1BFC..#$1BFF, #$1C3B..#$1C3F, #$1C7E..#$1C7F, #$1CC0..#$1CC7,
    #$1CD3, #$2016..#$2017, #$2020..#$2027, #$2030..#$2038,
    #$203B..#$203E, #$2041..#$2043, #$2047..#$2051, #$2053,
    #$2055..#$205E, #$2CF9..#$2CFC, #$2CFE..#$2CFF, #$2D70,
    #$2E00..#$2E01, #$2E06..#$2E08, #$2E0B, #$2E0E..#$2E16,
    #$2E18..#$2E19, #$2E1B, #$2E1E..#$2E1F, #$2E2A..#$2E2E,
    #$2E30..#$2E39, #$2E3C..#$2E3F, #$2E41, #$3001..#$3003,
    #$303D, #$30FB, #$A4FE..#$A4FF, #$A60D..#$A60F, #$A673,
    #$A67E, #$A6F2..#$A6F7, #$A874..#$A877, #$A8CE..#$A8CF,
    #$A8F8..#$A8FA, #$A92E..#$A92F, #$A95F, #$A9C1..#$A9CD,
    #$A9DE..#$A9DF, #$AA5C..#$AA5F, #$AADE..#$AADF, #$AAF0..#$AAF1,
    #$ABEB, #$FE10..#$FE16, #$FE19, #$FE30, #$FE45..#$FE46,
    #$FE49..#$FE4C, #$FE50..#$FE52, #$FE54..#$FE57, #$FE5F..#$FE61,
    #$FE68, #$FE6A..#$FE6B, #$FF01..#$FF03, #$FF05..#$FF07,
    #$FF0A, #$FF0C, #$FF0E..#$FF0F, #$FF1A..#$FF1B, #$FF1F..#$FF20,
    #$FF3C, #$FF61, #$FF64..#$FF65:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSymbolW(const c: WideChar): Boolean;
begin
  case c of
    #$0024, #$002B, #$003C..#$003E, #$005E, #$0060, #$007C,
    #$007E, #$00A2..#$00A6, #$00A8..#$00A9, #$00AC, #$00AE..#$00B1,
    #$00B4, #$00B8, #$00D7, #$00F7, #$02C2..#$02C5, #$02D2..#$02DF,
    #$02E5..#$02EB, #$02ED, #$02EF..#$02FF, #$0375, #$0384..#$0385,
    #$03F6, #$0482, #$058D..#$058F, #$0606..#$0608, #$060B,
    #$060E..#$060F, #$06DE, #$06E9, #$06FD..#$06FE, #$07F6,
    #$09F2..#$09F3, #$09FA..#$09FB, #$0AF1, #$0B70, #$0BF3..#$0BFA,
    #$0C7F, #$0D79, #$0E3F, #$0F01..#$0F03, #$0F13, #$0F15..#$0F17,
    #$0F1A..#$0F1F, #$0F34, #$0F36, #$0F38, #$0FBE..#$0FC5,
    #$0FC7..#$0FCC, #$0FCE..#$0FCF, #$0FD5..#$0FD8, #$109E..#$109F,
    #$1390..#$1399, #$17DB, #$1940, #$19DE..#$19FF, #$1B61..#$1B6A,
    #$1B74..#$1B7C, #$1FBD, #$1FBF..#$1FC1, #$1FCD..#$1FCF,
    #$1FDD..#$1FDF, #$1FED..#$1FEF, #$1FFD..#$1FFE, #$2044,
    #$2052, #$207A..#$207C, #$208A..#$208C, #$20A0..#$20BD,
    #$2100..#$2101, #$2103..#$2106, #$2108..#$2109, #$2114,
    #$2116..#$2118, #$211E..#$2123, #$2125, #$2127, #$2129,
    #$212E, #$213A..#$213B, #$2140..#$2144, #$214A..#$214D,
    #$214F, #$2190..#$2307, #$230C..#$2328, #$232B..#$23FA,
    #$2400..#$2426, #$2440..#$244A, #$249C..#$24E9, #$2500..#$2767,
    #$2794..#$27C4, #$27C7..#$27E5, #$27F0..#$2982, #$2999..#$29D7,
    #$29DC..#$29FB, #$29FE..#$2B73, #$2B76..#$2B95, #$2B98..#$2BB9,
    #$2BBD..#$2BC8, #$2BCA..#$2BD1, #$2CE5..#$2CEA, #$2E80..#$2E99,
    #$2E9B..#$2EF3, #$2F00..#$2FD5, #$2FF0..#$2FFB, #$3004,
    #$3012..#$3013, #$3020, #$3036..#$3037, #$303E..#$303F,
    #$309B..#$309C, #$3190..#$3191, #$3196..#$319F, #$31C0..#$31E3,
    #$3200..#$321E, #$322A..#$3247, #$3250, #$3260..#$327F,
    #$328A..#$32B0, #$32C0..#$32FE, #$3300..#$33FF, #$4DC0..#$4DFF,
    #$A490..#$A4C6, #$A700..#$A716, #$A720..#$A721, #$A789..#$A78A,
    #$A828..#$A82B, #$A836..#$A839, #$AA77..#$AA79, #$AB5B,
    #$FB29, #$FBB2..#$FBC1, #$FDFC..#$FDFD, #$FE62, #$FE64..#$FE66,
    #$FE69, #$FF04, #$FF0B, #$FF1C..#$FF1E, #$FF3E, #$FF40,
    #$FF5C, #$FF5E, #$FFE0..#$FFE6, #$FFE8..#$FFEE, #$FFFC..#$FFFD:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSymbolMathW(const c: WideChar): Boolean;
begin
  case c of
    #$002B, #$003C..#$003E, #$007C, #$007E, #$00AC, #$00B1,
    #$00D7, #$00F7, #$03F6, #$0606..#$0608, #$2044, #$2052,
    #$207A..#$207C, #$208A..#$208C, #$2118, #$2140..#$2144,
    #$214B, #$2190..#$2194, #$219A..#$219B, #$21A0, #$21A3,
    #$21A6, #$21AE, #$21CE..#$21CF, #$21D2, #$21D4, #$21F4..#$22FF,
    #$2320..#$2321, #$237C, #$239B..#$23B3, #$23DC..#$23E1,
    #$25B7, #$25C1, #$25F8..#$25FF, #$266F, #$27C0..#$27C4,
    #$27C7..#$27E5, #$27F0..#$27FF, #$2900..#$2982, #$2999..#$29D7,
    #$29DC..#$29FB, #$29FE..#$2AFF, #$2B30..#$2B44, #$2B47..#$2B4C,
    #$FB29, #$FE62, #$FE64..#$FE66, #$FF0B, #$FF1C..#$FF1E,
    #$FF5C, #$FF5E, #$FFE2, #$FFE9..#$FFEC:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSymbolCurrencyW(const c: WideChar): Boolean;
begin
  case c of
    #$0024, #$00A2..#$00A5, #$058F, #$060B, #$09F2..#$09F3,
    #$09FB, #$0AF1, #$0BF9, #$0E3F, #$17DB, #$20A0..#$20BD,
    #$A838, #$FDFC, #$FE69, #$FF04, #$FFE0..#$FFE1, #$FFE5..#$FFE6:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSymbolModifierW(const c: WideChar): Boolean;
begin
  case c of
    #$005E, #$0060, #$00A8, #$00AF, #$00B4, #$00B8, #$02C2..#$02C5,
    #$02D2..#$02DF, #$02E5..#$02EB, #$02ED, #$02EF..#$02FF,
    #$0375, #$0384..#$0385, #$1FBD, #$1FBF..#$1FC1, #$1FCD..#$1FCF,
    #$1FDD..#$1FDF, #$1FED..#$1FEF, #$1FFD..#$1FFE, #$309B..#$309C,
    #$A700..#$A716, #$A720..#$A721, #$A789..#$A78A, #$AB5B,
    #$FBB2..#$FBC1, #$FF3E, #$FF40, #$FFE3:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSymbolOtherW(const c: WideChar): Boolean;
begin
  case c of
    #$00A6, #$00A9, #$00AE, #$00B0, #$0482, #$058D..#$058E,
    #$060E..#$060F, #$06DE, #$06E9, #$06FD..#$06FE, #$07F6,
    #$09FA, #$0B70, #$0BF3..#$0BF8, #$0BFA, #$0C7F, #$0D79,
    #$0F01..#$0F03, #$0F13, #$0F15..#$0F17, #$0F1A..#$0F1F,
    #$0F34, #$0F36, #$0F38, #$0FBE..#$0FC5, #$0FC7..#$0FCC,
    #$0FCE..#$0FCF, #$0FD5..#$0FD8, #$109E..#$109F, #$1390..#$1399,
    #$1940, #$19DE..#$19FF, #$1B61..#$1B6A, #$1B74..#$1B7C,
    #$2100..#$2101, #$2103..#$2106, #$2108..#$2109, #$2114,
    #$2116..#$2117, #$211E..#$2123, #$2125, #$2127, #$2129,
    #$212E, #$213A..#$213B, #$214A, #$214C..#$214D, #$214F,
    #$2195..#$2199, #$219C..#$219F, #$21A1..#$21A2, #$21A4..#$21A5,
    #$21A7..#$21AD, #$21AF..#$21CD, #$21D0..#$21D1, #$21D3,
    #$21D5..#$21F3, #$2300..#$2307, #$230C..#$231F, #$2322..#$2328,
    #$232B..#$237B, #$237D..#$239A, #$23B4..#$23DB, #$23E2..#$23FA,
    #$2400..#$2426, #$2440..#$244A, #$249C..#$24E9, #$2500..#$25B6,
    #$25B8..#$25C0, #$25C2..#$25F7, #$2600..#$266E, #$2670..#$2767,
    #$2794..#$27BF, #$2800..#$28FF, #$2B00..#$2B2F, #$2B45..#$2B46,
    #$2B4D..#$2B73, #$2B76..#$2B95, #$2B98..#$2BB9, #$2BBD..#$2BC8,
    #$2BCA..#$2BD1, #$2CE5..#$2CEA, #$2E80..#$2E99, #$2E9B..#$2EF3,
    #$2F00..#$2FD5, #$2FF0..#$2FFB, #$3004, #$3012..#$3013,
    #$3020, #$3036..#$3037, #$303E..#$303F, #$3190..#$3191,
    #$3196..#$319F, #$31C0..#$31E3, #$3200..#$321E, #$322A..#$3247,
    #$3250, #$3260..#$327F, #$328A..#$32B0, #$32C0..#$32FE,
    #$3300..#$33FF, #$4DC0..#$4DFF, #$A490..#$A4C6, #$A828..#$A82B,
    #$A836..#$A837, #$A839, #$AA77..#$AA79, #$FDFD, #$FFE4,
    #$FFE8, #$FFED..#$FFEE, #$FFFC..#$FFFD:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSeparatorW(const c: WideChar): Boolean;
begin
  case c of
    #$0020, #$00A0, #$1680, #$2000..#$200A, #$2028..#$2029,
    #$202F, #$205F, #$3000:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSeparatorSpaceW(const c: WideChar): Boolean;
begin
  case c of
    #$0020, #$00A0, #$1680, #$2000..#$200A, #$202F, #$205F,
    #$3000:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSeparatorLineW(const c: WideChar): Boolean;
begin
  case c of
    #$2028:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSeparatorParagraphW(const c: WideChar): Boolean;
begin
  case c of
    #$2029:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsOtherW(const c: WideChar): Boolean;
begin
  case c of
    #$0000..#$001F, #$007F..#$009F, #$00AD, #$0600..#$0605,
    #$061C, #$06DD, #$070F, #$180E, #$200B..#$200F, #$202A..#$202E,
    #$2060..#$2064, #$2066..#$206F, #$D800..#$F8FF, #$FEFF,
    #$FFF9..#$FFFB:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsOtherControlW(const c: WideChar): Boolean;
begin
  case c of
    #$0000..#$001F, #$007F..#$009F:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsOtherFormatW(const c: WideChar): Boolean;
begin
  case c of
    #$00AD, #$0600..#$0605, #$061C, #$06DD, #$070F, #$180E,
    #$200B..#$200F, #$202A..#$202E, #$2060..#$2064, #$2066..#$206F,
    #$FEFF, #$FFF9..#$FFFB:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsOtherSurrogateW(const c: WideChar): Boolean;
begin
  case c of
    #$D800..#$DFFF:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsOtherPrivateUseW(const c: WideChar): Boolean;
begin
  case c of
    #$E000..#$F8FF:
      Result := True;
  else
    Result := False;
  end;
end;

function CharCanonicalCombiningClassW(const Char: WideChar): Cardinal;
const
  CHAR_CANONICAL_COMBINING_CLASS_1: array[$0000..$07D9] of Byte = (
    $01, $02, $03, $04, $00, $00, $00, $00,
    $00, $00, $00, $00, $05, $00, $00, $00,
    $00, $00, $00, $00, $06, $07, $08, $00,
    $09, $00, $0A, $0B, $00, $00, $0C, $0D,
    $0E, $0F, $10, $00, $00, $00, $00, $11,
    $12, $13, $14, $00, $00, $00, $00, $15,
    $00, $16, $17, $00, $00, $18, $19, $00,
    $00, $1A, $1B, $00, $00, $1C, $1D, $00,

    $00, $1E, $1F, $00, $00, $00, $20, $00,
    $00, $00, $21, $00, $00, $22, $23, $00,
    $00, $00, $24, $00, $00, $00, $25, $00,
    $00, $26, $27, $00, $00, $28, $29, $00,
    $2A, $2B, $00, $2C, $2D, $00, $2E, $00,
    $00, $2F, $00, $00, $30, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $31, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $32, $33, $00, $00, $00, $00, $34, $00,
    $00, $00, $00, $00, $00, $35, $00, $00,
    $00, $36, $00, $00, $00, $00, $00, $00,
    $37, $00, $00, $38, $00, $39, $00, $00,

    $00, $3A, $3B, $3C, $00, $3D, $00, $3E,
    $00, $3F, $00, $00, $00, $00, $40, $41,
    $00, $00, $00, $00, $00, $00, $42, $43,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $44, $45,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $46,
    $00, $00, $00, $47, $00, $00, $00, $48,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $49, $00, $00, $4A, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $4B, $4C, $00, $00, $4D,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $4E, $00, $00, $00, $00, $00, $4F, $50,
    $00, $51, $52, $00, $00, $53, $54, $00,
    $00, $00, $00, $00, $00, $55, $56, $57,

    $00, $00, $00, $00, $00, $00, $00, $58,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $59, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $5A);
  CHAR_CANONICAL_COMBINING_CLASS_2: array[$0000..$0059, $0000..$001F] of Byte = (

    ($E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E8, $DC, $DC,
    $DC, $DC, $E8, $D8, $DC, $DC, $DC, $DC),

    ($DC, $CA, $CA, $DC, $DC, $DC, $DC, $CA,
    $CA, $DC, $DC, $DC, $DC, $DC, $DC, $DC,
    $DC, $DC, $DC, $DC, $01, $01, $01, $01,
    $01, $DC, $DC, $DC, $DC, $E6, $E6, $E6),

    ($E6, $E6, $E6, $E6, $E6, $F0, $E6, $DC,
    $DC, $DC, $E6, $E6, $E6, $DC, $DC, $00,
    $E6, $E6, $E6, $DC, $DC, $DC, $DC, $E6,
    $E8, $DC, $DC, $E6, $E9, $EA, $EA, $E9),

    ($EA, $EA, $E9, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $E6, $E6, $E6, $E6, $E6,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $DC, $E6, $E6, $E6, $E6, $DC, $E6,
    $E6, $E6, $DE, $DC, $E6, $E6, $E6, $E6),

    ($E6, $E6, $DC, $DC, $DC, $DC, $DC, $DC,
    $E6, $E6, $DC, $E6, $E6, $DE, $E4, $E6,
    $0A, $0B, $0C, $0D, $0E, $0F, $10, $11,
    $12, $13, $13, $14, $15, $16, $00, $17),

    ($00, $18, $19, $00, $E6, $DC, $00, $12,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $1E, $1F, $20, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $1B, $1C, $1D, $1E, $1F,
    $20, $21, $22, $E6, $E6, $DC, $DC, $E6,
    $E6, $E6, $E6, $E6, $DC, $E6, $E6, $DC),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $23, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $00, $00, $E6),

    ($E6, $E6, $E6, $DC, $E6, $00, $00, $E6,
    $E6, $00, $DC, $E6, $E6, $DC, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $24, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $E6, $DC, $E6, $E6, $DC, $E6, $E6, $DC,
    $DC, $DC, $E6, $DC, $DC, $E6, $DC, $E6),

    ($E6, $E6, $DC, $E6, $DC, $E6, $DC, $E6,
    $DC, $E6, $E6, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $DC, $E6, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $E6, $E6,
    $E6, $E6, $00, $E6, $E6, $E6, $E6, $E6),

    ($E6, $E6, $E6, $E6, $00, $E6, $E6, $E6,
    $00, $E6, $E6, $E6, $E6, $E6, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $DC, $DC, $DC, $00, $00, $00, $00),

    ($00, $00, $00, $00, $E6, $E6, $DC, $E6,
    $E6, $DC, $E6, $E6, $E6, $DC, $DC, $DC,
    $1B, $1C, $1D, $E6, $E6, $E6, $DC, $E6,
    $E6, $DC, $DC, $E6, $E6, $E6, $E6, $E6),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $E6, $DC, $E6, $E6, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $54, $5B, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $09, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $67, $67, $09, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $6B, $6B, $6B, $6B, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $76, $76, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $7A, $7A, $7A, $7A, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $DC, $DC, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $DC, $00, $DC,
    $00, $D8, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $81, $82, $00, $84, $00, $00, $00,
    $00, $00, $82, $82, $82, $82, $00, $00),

    ($82, $00, $E6, $E6, $09, $00, $E6, $E6,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $DC, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $07,
    $00, $09, $09, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $DC, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $E6, $E6, $E6),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $09, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $09, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $09, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $E6, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $E4, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $DE, $E6, $DC, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $E6,
    $DC, $00, $00, $00, $00, $00, $00, $00),

    ($09, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $00, $00, $DC),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $E6, $E6, $E6, $E6, $E6, $DC, $DC, $DC,
    $DC, $DC, $DC, $E6, $E6, $DC, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $09, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $E6, $DC, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $09, $09, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $07, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $09, $09, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $07,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $E6, $E6, $E6, $00, $01, $DC, $DC, $DC,
    $DC, $DC, $E6, $E6, $DC, $DC, $DC, $DC),

    ($E6, $00, $01, $01, $01, $01, $01, $01,
    $01, $00, $00, $00, $00, $DC, $00, $00,
    $00, $00, $00, $00, $E6, $00, $00, $00,
    $E6, $E6, $00, $00, $00, $00, $00, $00),

    ($E6, $E6, $DC, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $DC, $E6, $E6, $EA, $D6, $DC,
    $CA, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6),

    ($E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $00, $00,
    $00, $00, $00, $00, $E9, $DC, $E6, $DC),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $E6, $E6, $01, $01, $E6, $E6, $E6, $E6,
    $01, $01, $01, $E6, $E6, $00, $00, $00),

    ($00, $E6, $00, $00, $00, $01, $01, $E6,
    $DC, $E6, $01, $01, $DC, $DC, $DC, $DC,
    $E6, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $E6,
    $E6, $E6, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $09),

    ($E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $DA, $E4, $E8, $DE, $E0, $E0,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $08, $08, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $E6,
    $00, $00, $00, $00, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $E6),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $E6, $E6, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $09, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $09, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $DC, $DC, $DC, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $09, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $07, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($09, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $E6, $00, $E6, $E6, $DC, $00, $00, $E6,
    $E6, $00, $00, $00, $00, $00, $E6, $E6),

    ($00, $E6, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $09, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $1A, $00),

    ($E6, $E6, $E6, $E6, $E6, $E6, $E6, $DC,
    $DC, $DC, $DC, $DC, $DC, $DC, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00));
  CHAR_CANONICAL_COMBINING_CLASS_SIZE = 32;
begin
  if (Char >= #$300) and (Char <= #$FE2D) then
    begin
      Result := CHAR_CANONICAL_COMBINING_CLASS_1[(Ord(Char) - $300) div CHAR_CANONICAL_COMBINING_CLASS_SIZE];
      if Result <> 0 then
        begin
          Dec(Result);
          Result := CHAR_CANONICAL_COMBINING_CLASS_2[Result, Ord(Char) and (CHAR_CANONICAL_COMBINING_CLASS_SIZE - 1)];
          Exit;
        end;
    end;
  Result := 0;
end;

function CharToCaseFoldW(const Char: WideChar): WideChar;
const
  CHAR_TO_CASE_FOLD_1: array[$0000..$07F7] of Byte = (
    $01, $00, $00, $02, $03, $00, $04, $05,
    $06, $07, $08, $09, $0A, $0B, $0C, $0D,
    $0E, $00, $00, $00, $00, $00, $00, $00,
    $0F, $10, $11, $12, $13, $14, $15, $16,
    $00, $17, $18, $19, $1A, $1B, $1C, $1D,
    $1E, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $1F, $20, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $21, $22,
    $23, $24, $25, $26, $27, $28, $29, $2A,
    $2B, $2C, $2D, $2E, $2F, $30, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $31,
    $00, $32, $33, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $34, $35, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $36, $37,
    $00, $38, $39, $3A, $3B, $3C, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $3D, $3E, $3F, $00, $00, $00, $00, $40,
    $41, $42, $43, $44, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $45);
  CHAR_TO_CASE_FOLD_2: array[$0000..$0044, $0000..$001F] of WideChar = (

    (#$0040, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067,
    #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
    #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077,
    #$0078, #$0079, #$007A, #$005B, #$005C, #$005D, #$005E, #$005F),

    (#$00A0, #$00A1, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7,
    #$00A8, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
    #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$03BC, #$00B6, #$00B7,
    #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF),

    (#$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7,
    #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
    #$00F0, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00D7,
    #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$00DF),

    (#$0101, #$0101, #$0103, #$0103, #$0105, #$0105, #$0107, #$0107,
    #$0109, #$0109, #$010B, #$010B, #$010D, #$010D, #$010F, #$010F,
    #$0111, #$0111, #$0113, #$0113, #$0115, #$0115, #$0117, #$0117,
    #$0119, #$0119, #$011B, #$011B, #$011D, #$011D, #$011F, #$011F),

    (#$0121, #$0121, #$0123, #$0123, #$0125, #$0125, #$0127, #$0127,
    #$0129, #$0129, #$012B, #$012B, #$012D, #$012D, #$012F, #$012F,
    #$0130, #$0131, #$0133, #$0133, #$0135, #$0135, #$0137, #$0137,
    #$0138, #$013A, #$013A, #$013C, #$013C, #$013E, #$013E, #$0140),

    (#$0140, #$0142, #$0142, #$0144, #$0144, #$0146, #$0146, #$0148,
    #$0148, #$0149, #$014B, #$014B, #$014D, #$014D, #$014F, #$014F,
    #$0151, #$0151, #$0153, #$0153, #$0155, #$0155, #$0157, #$0157,
    #$0159, #$0159, #$015B, #$015B, #$015D, #$015D, #$015F, #$015F),

    (#$0161, #$0161, #$0163, #$0163, #$0165, #$0165, #$0167, #$0167,
    #$0169, #$0169, #$016B, #$016B, #$016D, #$016D, #$016F, #$016F,
    #$0171, #$0171, #$0173, #$0173, #$0175, #$0175, #$0177, #$0177,
    #$00FF, #$017A, #$017A, #$017C, #$017C, #$017E, #$017E, #$0073),

    (#$0180, #$0253, #$0183, #$0183, #$0185, #$0185, #$0254, #$0188,
    #$0188, #$0256, #$0257, #$018C, #$018C, #$018D, #$01DD, #$0259,
    #$025B, #$0192, #$0192, #$0260, #$0263, #$0195, #$0269, #$0268,
    #$0199, #$0199, #$019A, #$019B, #$026F, #$0272, #$019E, #$0275),

    (#$01A1, #$01A1, #$01A3, #$01A3, #$01A5, #$01A5, #$0280, #$01A8,
    #$01A8, #$0283, #$01AA, #$01AB, #$01AD, #$01AD, #$0288, #$01B0,
    #$01B0, #$028A, #$028B, #$01B4, #$01B4, #$01B6, #$01B6, #$0292,
    #$01B9, #$01B9, #$01BA, #$01BB, #$01BD, #$01BD, #$01BE, #$01BF),

    (#$01C0, #$01C1, #$01C2, #$01C3, #$01C6, #$01C6, #$01C6, #$01C9,
    #$01C9, #$01C9, #$01CC, #$01CC, #$01CC, #$01CE, #$01CE, #$01D0,
    #$01D0, #$01D2, #$01D2, #$01D4, #$01D4, #$01D6, #$01D6, #$01D8,
    #$01D8, #$01DA, #$01DA, #$01DC, #$01DC, #$01DD, #$01DF, #$01DF),

    (#$01E1, #$01E1, #$01E3, #$01E3, #$01E5, #$01E5, #$01E7, #$01E7,
    #$01E9, #$01E9, #$01EB, #$01EB, #$01ED, #$01ED, #$01EF, #$01EF,
    #$01F0, #$01F3, #$01F3, #$01F3, #$01F5, #$01F5, #$0195, #$01BF,
    #$01F9, #$01F9, #$01FB, #$01FB, #$01FD, #$01FD, #$01FF, #$01FF),

    (#$0201, #$0201, #$0203, #$0203, #$0205, #$0205, #$0207, #$0207,
    #$0209, #$0209, #$020B, #$020B, #$020D, #$020D, #$020F, #$020F,
    #$0211, #$0211, #$0213, #$0213, #$0215, #$0215, #$0217, #$0217,
    #$0219, #$0219, #$021B, #$021B, #$021D, #$021D, #$021F, #$021F),

    (#$019E, #$0221, #$0223, #$0223, #$0225, #$0225, #$0227, #$0227,
    #$0229, #$0229, #$022B, #$022B, #$022D, #$022D, #$022F, #$022F,
    #$0231, #$0231, #$0233, #$0233, #$0234, #$0235, #$0236, #$0237,
    #$0238, #$0239, #$2C65, #$023C, #$023C, #$019A, #$2C66, #$023F),

    (#$0240, #$0242, #$0242, #$0180, #$0289, #$028C, #$0247, #$0247,
    #$0249, #$0249, #$024B, #$024B, #$024D, #$024D, #$024F, #$024F,
    #$0250, #$0251, #$0252, #$0253, #$0254, #$0255, #$0256, #$0257,
    #$0258, #$0259, #$025A, #$025B, #$025C, #$025D, #$025E, #$025F),

    (#$0340, #$0341, #$0342, #$0343, #$0344, #$03B9, #$0346, #$0347,
    #$0348, #$0349, #$034A, #$034B, #$034C, #$034D, #$034E, #$034F,
    #$0350, #$0351, #$0352, #$0353, #$0354, #$0355, #$0356, #$0357,
    #$0358, #$0359, #$035A, #$035B, #$035C, #$035D, #$035E, #$035F),

    (#$0360, #$0361, #$0362, #$0363, #$0364, #$0365, #$0366, #$0367,
    #$0368, #$0369, #$036A, #$036B, #$036C, #$036D, #$036E, #$036F,
    #$0371, #$0371, #$0373, #$0373, #$0374, #$0375, #$0377, #$0377,
    #$0378, #$0379, #$037A, #$037B, #$037C, #$037D, #$037E, #$03F3),

    (#$0380, #$0381, #$0382, #$0383, #$0384, #$0385, #$03AC, #$0387,
    #$03AD, #$03AE, #$03AF, #$038B, #$03CC, #$038D, #$03CD, #$03CE,
    #$0390, #$03B1, #$03B2, #$03B3, #$03B4, #$03B5, #$03B6, #$03B7,
    #$03B8, #$03B9, #$03BA, #$03BB, #$03BC, #$03BD, #$03BE, #$03BF),

    (#$03C0, #$03C1, #$03A2, #$03C3, #$03C4, #$03C5, #$03C6, #$03C7,
    #$03C8, #$03C9, #$03CA, #$03CB, #$03AC, #$03AD, #$03AE, #$03AF,
    #$03B0, #$03B1, #$03B2, #$03B3, #$03B4, #$03B5, #$03B6, #$03B7,
    #$03B8, #$03B9, #$03BA, #$03BB, #$03BC, #$03BD, #$03BE, #$03BF),

    (#$03C0, #$03C1, #$03C3, #$03C3, #$03C4, #$03C5, #$03C6, #$03C7,
    #$03C8, #$03C9, #$03CA, #$03CB, #$03CC, #$03CD, #$03CE, #$03D7,
    #$03B2, #$03B8, #$03D2, #$03D3, #$03D4, #$03C6, #$03C0, #$03D7,
    #$03D9, #$03D9, #$03DB, #$03DB, #$03DD, #$03DD, #$03DF, #$03DF),

    (#$03E1, #$03E1, #$03E3, #$03E3, #$03E5, #$03E5, #$03E7, #$03E7,
    #$03E9, #$03E9, #$03EB, #$03EB, #$03ED, #$03ED, #$03EF, #$03EF,
    #$03BA, #$03C1, #$03F2, #$03F3, #$03B8, #$03B5, #$03F6, #$03F8,
    #$03F8, #$03F2, #$03FB, #$03FB, #$03FC, #$037B, #$037C, #$037D),

    (#$0450, #$0451, #$0452, #$0453, #$0454, #$0455, #$0456, #$0457,
    #$0458, #$0459, #$045A, #$045B, #$045C, #$045D, #$045E, #$045F,
    #$0430, #$0431, #$0432, #$0433, #$0434, #$0435, #$0436, #$0437,
    #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E, #$043F),

    (#$0440, #$0441, #$0442, #$0443, #$0444, #$0445, #$0446, #$0447,
    #$0448, #$0449, #$044A, #$044B, #$044C, #$044D, #$044E, #$044F,
    #$0430, #$0431, #$0432, #$0433, #$0434, #$0435, #$0436, #$0437,
    #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E, #$043F),

    (#$0461, #$0461, #$0463, #$0463, #$0465, #$0465, #$0467, #$0467,
    #$0469, #$0469, #$046B, #$046B, #$046D, #$046D, #$046F, #$046F,
    #$0471, #$0471, #$0473, #$0473, #$0475, #$0475, #$0477, #$0477,
    #$0479, #$0479, #$047B, #$047B, #$047D, #$047D, #$047F, #$047F),

    (#$0481, #$0481, #$0482, #$0483, #$0484, #$0485, #$0486, #$0487,
    #$0488, #$0489, #$048B, #$048B, #$048D, #$048D, #$048F, #$048F,
    #$0491, #$0491, #$0493, #$0493, #$0495, #$0495, #$0497, #$0497,
    #$0499, #$0499, #$049B, #$049B, #$049D, #$049D, #$049F, #$049F),

    (#$04A1, #$04A1, #$04A3, #$04A3, #$04A5, #$04A5, #$04A7, #$04A7,
    #$04A9, #$04A9, #$04AB, #$04AB, #$04AD, #$04AD, #$04AF, #$04AF,
    #$04B1, #$04B1, #$04B3, #$04B3, #$04B5, #$04B5, #$04B7, #$04B7,
    #$04B9, #$04B9, #$04BB, #$04BB, #$04BD, #$04BD, #$04BF, #$04BF),

    (#$04CF, #$04C2, #$04C2, #$04C4, #$04C4, #$04C6, #$04C6, #$04C8,
    #$04C8, #$04CA, #$04CA, #$04CC, #$04CC, #$04CE, #$04CE, #$04CF,
    #$04D1, #$04D1, #$04D3, #$04D3, #$04D5, #$04D5, #$04D7, #$04D7,
    #$04D9, #$04D9, #$04DB, #$04DB, #$04DD, #$04DD, #$04DF, #$04DF),

    (#$04E1, #$04E1, #$04E3, #$04E3, #$04E5, #$04E5, #$04E7, #$04E7,
    #$04E9, #$04E9, #$04EB, #$04EB, #$04ED, #$04ED, #$04EF, #$04EF,
    #$04F1, #$04F1, #$04F3, #$04F3, #$04F5, #$04F5, #$04F7, #$04F7,
    #$04F9, #$04F9, #$04FB, #$04FB, #$04FD, #$04FD, #$04FF, #$04FF),

    (#$0501, #$0501, #$0503, #$0503, #$0505, #$0505, #$0507, #$0507,
    #$0509, #$0509, #$050B, #$050B, #$050D, #$050D, #$050F, #$050F,
    #$0511, #$0511, #$0513, #$0513, #$0515, #$0515, #$0517, #$0517,
    #$0519, #$0519, #$051B, #$051B, #$051D, #$051D, #$051F, #$051F),

    (#$0521, #$0521, #$0523, #$0523, #$0525, #$0525, #$0527, #$0527,
    #$0529, #$0529, #$052B, #$052B, #$052D, #$052D, #$052F, #$052F,
    #$0530, #$0561, #$0562, #$0563, #$0564, #$0565, #$0566, #$0567,
    #$0568, #$0569, #$056A, #$056B, #$056C, #$056D, #$056E, #$056F),

    (#$0570, #$0571, #$0572, #$0573, #$0574, #$0575, #$0576, #$0577,
    #$0578, #$0579, #$057A, #$057B, #$057C, #$057D, #$057E, #$057F,
    #$0580, #$0581, #$0582, #$0583, #$0584, #$0585, #$0586, #$0557,
    #$0558, #$0559, #$055A, #$055B, #$055C, #$055D, #$055E, #$055F),

    (#$2D00, #$2D01, #$2D02, #$2D03, #$2D04, #$2D05, #$2D06, #$2D07,
    #$2D08, #$2D09, #$2D0A, #$2D0B, #$2D0C, #$2D0D, #$2D0E, #$2D0F,
    #$2D10, #$2D11, #$2D12, #$2D13, #$2D14, #$2D15, #$2D16, #$2D17,
    #$2D18, #$2D19, #$2D1A, #$2D1B, #$2D1C, #$2D1D, #$2D1E, #$2D1F),

    (#$2D20, #$2D21, #$2D22, #$2D23, #$2D24, #$2D25, #$10C6, #$2D27,
    #$10C8, #$10C9, #$10CA, #$10CB, #$10CC, #$2D2D, #$10CE, #$10CF,
    #$10D0, #$10D1, #$10D2, #$10D3, #$10D4, #$10D5, #$10D6, #$10D7,
    #$10D8, #$10D9, #$10DA, #$10DB, #$10DC, #$10DD, #$10DE, #$10DF),

    (#$1E01, #$1E01, #$1E03, #$1E03, #$1E05, #$1E05, #$1E07, #$1E07,
    #$1E09, #$1E09, #$1E0B, #$1E0B, #$1E0D, #$1E0D, #$1E0F, #$1E0F,
    #$1E11, #$1E11, #$1E13, #$1E13, #$1E15, #$1E15, #$1E17, #$1E17,
    #$1E19, #$1E19, #$1E1B, #$1E1B, #$1E1D, #$1E1D, #$1E1F, #$1E1F),

    (#$1E21, #$1E21, #$1E23, #$1E23, #$1E25, #$1E25, #$1E27, #$1E27,
    #$1E29, #$1E29, #$1E2B, #$1E2B, #$1E2D, #$1E2D, #$1E2F, #$1E2F,
    #$1E31, #$1E31, #$1E33, #$1E33, #$1E35, #$1E35, #$1E37, #$1E37,
    #$1E39, #$1E39, #$1E3B, #$1E3B, #$1E3D, #$1E3D, #$1E3F, #$1E3F),

    (#$1E41, #$1E41, #$1E43, #$1E43, #$1E45, #$1E45, #$1E47, #$1E47,
    #$1E49, #$1E49, #$1E4B, #$1E4B, #$1E4D, #$1E4D, #$1E4F, #$1E4F,
    #$1E51, #$1E51, #$1E53, #$1E53, #$1E55, #$1E55, #$1E57, #$1E57,
    #$1E59, #$1E59, #$1E5B, #$1E5B, #$1E5D, #$1E5D, #$1E5F, #$1E5F),

    (#$1E61, #$1E61, #$1E63, #$1E63, #$1E65, #$1E65, #$1E67, #$1E67,
    #$1E69, #$1E69, #$1E6B, #$1E6B, #$1E6D, #$1E6D, #$1E6F, #$1E6F,
    #$1E71, #$1E71, #$1E73, #$1E73, #$1E75, #$1E75, #$1E77, #$1E77,
    #$1E79, #$1E79, #$1E7B, #$1E7B, #$1E7D, #$1E7D, #$1E7F, #$1E7F),

    (#$1E81, #$1E81, #$1E83, #$1E83, #$1E85, #$1E85, #$1E87, #$1E87,
    #$1E89, #$1E89, #$1E8B, #$1E8B, #$1E8D, #$1E8D, #$1E8F, #$1E8F,
    #$1E91, #$1E91, #$1E93, #$1E93, #$1E95, #$1E95, #$1E96, #$1E97,
    #$1E98, #$1E99, #$1E9A, #$1E61, #$1E9C, #$1E9D, #$00DF, #$1E9F),

    (#$1EA1, #$1EA1, #$1EA3, #$1EA3, #$1EA5, #$1EA5, #$1EA7, #$1EA7,
    #$1EA9, #$1EA9, #$1EAB, #$1EAB, #$1EAD, #$1EAD, #$1EAF, #$1EAF,
    #$1EB1, #$1EB1, #$1EB3, #$1EB3, #$1EB5, #$1EB5, #$1EB7, #$1EB7,
    #$1EB9, #$1EB9, #$1EBB, #$1EBB, #$1EBD, #$1EBD, #$1EBF, #$1EBF),

    (#$1EC1, #$1EC1, #$1EC3, #$1EC3, #$1EC5, #$1EC5, #$1EC7, #$1EC7,
    #$1EC9, #$1EC9, #$1ECB, #$1ECB, #$1ECD, #$1ECD, #$1ECF, #$1ECF,
    #$1ED1, #$1ED1, #$1ED3, #$1ED3, #$1ED5, #$1ED5, #$1ED7, #$1ED7,
    #$1ED9, #$1ED9, #$1EDB, #$1EDB, #$1EDD, #$1EDD, #$1EDF, #$1EDF),

    (#$1EE1, #$1EE1, #$1EE3, #$1EE3, #$1EE5, #$1EE5, #$1EE7, #$1EE7,
    #$1EE9, #$1EE9, #$1EEB, #$1EEB, #$1EED, #$1EED, #$1EEF, #$1EEF,
    #$1EF1, #$1EF1, #$1EF3, #$1EF3, #$1EF5, #$1EF5, #$1EF7, #$1EF7,
    #$1EF9, #$1EF9, #$1EFB, #$1EFB, #$1EFD, #$1EFD, #$1EFF, #$1EFF),

    (#$1F00, #$1F01, #$1F02, #$1F03, #$1F04, #$1F05, #$1F06, #$1F07,
    #$1F00, #$1F01, #$1F02, #$1F03, #$1F04, #$1F05, #$1F06, #$1F07,
    #$1F10, #$1F11, #$1F12, #$1F13, #$1F14, #$1F15, #$1F16, #$1F17,
    #$1F10, #$1F11, #$1F12, #$1F13, #$1F14, #$1F15, #$1F1E, #$1F1F),

    (#$1F20, #$1F21, #$1F22, #$1F23, #$1F24, #$1F25, #$1F26, #$1F27,
    #$1F20, #$1F21, #$1F22, #$1F23, #$1F24, #$1F25, #$1F26, #$1F27,
    #$1F30, #$1F31, #$1F32, #$1F33, #$1F34, #$1F35, #$1F36, #$1F37,
    #$1F30, #$1F31, #$1F32, #$1F33, #$1F34, #$1F35, #$1F36, #$1F37),

    (#$1F40, #$1F41, #$1F42, #$1F43, #$1F44, #$1F45, #$1F46, #$1F47,
    #$1F40, #$1F41, #$1F42, #$1F43, #$1F44, #$1F45, #$1F4E, #$1F4F,
    #$1F50, #$1F51, #$1F52, #$1F53, #$1F54, #$1F55, #$1F56, #$1F57,
    #$1F58, #$1F51, #$1F5A, #$1F53, #$1F5C, #$1F55, #$1F5E, #$1F57),

    (#$1F60, #$1F61, #$1F62, #$1F63, #$1F64, #$1F65, #$1F66, #$1F67,
    #$1F60, #$1F61, #$1F62, #$1F63, #$1F64, #$1F65, #$1F66, #$1F67,
    #$1F70, #$1F71, #$1F72, #$1F73, #$1F74, #$1F75, #$1F76, #$1F77,
    #$1F78, #$1F79, #$1F7A, #$1F7B, #$1F7C, #$1F7D, #$1F7E, #$1F7F),

    (#$1F80, #$1F81, #$1F82, #$1F83, #$1F84, #$1F85, #$1F86, #$1F87,
    #$1F80, #$1F81, #$1F82, #$1F83, #$1F84, #$1F85, #$1F86, #$1F87,
    #$1F90, #$1F91, #$1F92, #$1F93, #$1F94, #$1F95, #$1F96, #$1F97,
    #$1F90, #$1F91, #$1F92, #$1F93, #$1F94, #$1F95, #$1F96, #$1F97),

    (#$1FA0, #$1FA1, #$1FA2, #$1FA3, #$1FA4, #$1FA5, #$1FA6, #$1FA7,
    #$1FA0, #$1FA1, #$1FA2, #$1FA3, #$1FA4, #$1FA5, #$1FA6, #$1FA7,
    #$1FB0, #$1FB1, #$1FB2, #$1FB3, #$1FB4, #$1FB5, #$1FB6, #$1FB7,
    #$1FB0, #$1FB1, #$1F70, #$1F71, #$1FB3, #$1FBD, #$03B9, #$1FBF),

    (#$1FC0, #$1FC1, #$1FC2, #$1FC3, #$1FC4, #$1FC5, #$1FC6, #$1FC7,
    #$1F72, #$1F73, #$1F74, #$1F75, #$1FC3, #$1FCD, #$1FCE, #$1FCF,
    #$1FD0, #$1FD1, #$1FD2, #$1FD3, #$1FD4, #$1FD5, #$1FD6, #$1FD7,
    #$1FD0, #$1FD1, #$1F76, #$1F77, #$1FDC, #$1FDD, #$1FDE, #$1FDF),

    (#$1FE0, #$1FE1, #$1FE2, #$1FE3, #$1FE4, #$1FE5, #$1FE6, #$1FE7,
    #$1FE0, #$1FE1, #$1F7A, #$1F7B, #$1FE5, #$1FED, #$1FEE, #$1FEF,
    #$1FF0, #$1FF1, #$1FF2, #$1FF3, #$1FF4, #$1FF5, #$1FF6, #$1FF7,
    #$1F78, #$1F79, #$1F7C, #$1F7D, #$1FF3, #$1FFD, #$1FFE, #$1FFF),

    (#$2120, #$2121, #$2122, #$2123, #$2124, #$2125, #$03C9, #$2127,
    #$2128, #$2129, #$006B, #$00E5, #$212C, #$212D, #$212E, #$212F,
    #$2130, #$2131, #$214E, #$2133, #$2134, #$2135, #$2136, #$2137,
    #$2138, #$2139, #$213A, #$213B, #$213C, #$213D, #$213E, #$213F),

    (#$2170, #$2171, #$2172, #$2173, #$2174, #$2175, #$2176, #$2177,
    #$2178, #$2179, #$217A, #$217B, #$217C, #$217D, #$217E, #$217F,
    #$2170, #$2171, #$2172, #$2173, #$2174, #$2175, #$2176, #$2177,
    #$2178, #$2179, #$217A, #$217B, #$217C, #$217D, #$217E, #$217F),

    (#$2180, #$2181, #$2182, #$2184, #$2184, #$2185, #$2186, #$2187,
    #$2188, #$2189, #$218A, #$218B, #$218C, #$218D, #$218E, #$218F,
    #$2190, #$2191, #$2192, #$2193, #$2194, #$2195, #$2196, #$2197,
    #$2198, #$2199, #$219A, #$219B, #$219C, #$219D, #$219E, #$219F),

    (#$24A0, #$24A1, #$24A2, #$24A3, #$24A4, #$24A5, #$24A6, #$24A7,
    #$24A8, #$24A9, #$24AA, #$24AB, #$24AC, #$24AD, #$24AE, #$24AF,
    #$24B0, #$24B1, #$24B2, #$24B3, #$24B4, #$24B5, #$24D0, #$24D1,
    #$24D2, #$24D3, #$24D4, #$24D5, #$24D6, #$24D7, #$24D8, #$24D9),

    (#$24DA, #$24DB, #$24DC, #$24DD, #$24DE, #$24DF, #$24E0, #$24E1,
    #$24E2, #$24E3, #$24E4, #$24E5, #$24E6, #$24E7, #$24E8, #$24E9,
    #$24D0, #$24D1, #$24D2, #$24D3, #$24D4, #$24D5, #$24D6, #$24D7,
    #$24D8, #$24D9, #$24DA, #$24DB, #$24DC, #$24DD, #$24DE, #$24DF),

    (#$2C30, #$2C31, #$2C32, #$2C33, #$2C34, #$2C35, #$2C36, #$2C37,
    #$2C38, #$2C39, #$2C3A, #$2C3B, #$2C3C, #$2C3D, #$2C3E, #$2C3F,
    #$2C40, #$2C41, #$2C42, #$2C43, #$2C44, #$2C45, #$2C46, #$2C47,
    #$2C48, #$2C49, #$2C4A, #$2C4B, #$2C4C, #$2C4D, #$2C4E, #$2C4F),

    (#$2C50, #$2C51, #$2C52, #$2C53, #$2C54, #$2C55, #$2C56, #$2C57,
    #$2C58, #$2C59, #$2C5A, #$2C5B, #$2C5C, #$2C5D, #$2C5E, #$2C2F,
    #$2C30, #$2C31, #$2C32, #$2C33, #$2C34, #$2C35, #$2C36, #$2C37,
    #$2C38, #$2C39, #$2C3A, #$2C3B, #$2C3C, #$2C3D, #$2C3E, #$2C3F),

    (#$2C61, #$2C61, #$026B, #$1D7D, #$027D, #$2C65, #$2C66, #$2C68,
    #$2C68, #$2C6A, #$2C6A, #$2C6C, #$2C6C, #$0251, #$0271, #$0250,
    #$0252, #$2C71, #$2C73, #$2C73, #$2C74, #$2C76, #$2C76, #$2C77,
    #$2C78, #$2C79, #$2C7A, #$2C7B, #$2C7C, #$2C7D, #$023F, #$0240),

    (#$2C81, #$2C81, #$2C83, #$2C83, #$2C85, #$2C85, #$2C87, #$2C87,
    #$2C89, #$2C89, #$2C8B, #$2C8B, #$2C8D, #$2C8D, #$2C8F, #$2C8F,
    #$2C91, #$2C91, #$2C93, #$2C93, #$2C95, #$2C95, #$2C97, #$2C97,
    #$2C99, #$2C99, #$2C9B, #$2C9B, #$2C9D, #$2C9D, #$2C9F, #$2C9F),

    (#$2CA1, #$2CA1, #$2CA3, #$2CA3, #$2CA5, #$2CA5, #$2CA7, #$2CA7,
    #$2CA9, #$2CA9, #$2CAB, #$2CAB, #$2CAD, #$2CAD, #$2CAF, #$2CAF,
    #$2CB1, #$2CB1, #$2CB3, #$2CB3, #$2CB5, #$2CB5, #$2CB7, #$2CB7,
    #$2CB9, #$2CB9, #$2CBB, #$2CBB, #$2CBD, #$2CBD, #$2CBF, #$2CBF),

    (#$2CC1, #$2CC1, #$2CC3, #$2CC3, #$2CC5, #$2CC5, #$2CC7, #$2CC7,
    #$2CC9, #$2CC9, #$2CCB, #$2CCB, #$2CCD, #$2CCD, #$2CCF, #$2CCF,
    #$2CD1, #$2CD1, #$2CD3, #$2CD3, #$2CD5, #$2CD5, #$2CD7, #$2CD7,
    #$2CD9, #$2CD9, #$2CDB, #$2CDB, #$2CDD, #$2CDD, #$2CDF, #$2CDF),

    (#$2CE1, #$2CE1, #$2CE3, #$2CE3, #$2CE4, #$2CE5, #$2CE6, #$2CE7,
    #$2CE8, #$2CE9, #$2CEA, #$2CEC, #$2CEC, #$2CEE, #$2CEE, #$2CEF,
    #$2CF0, #$2CF1, #$2CF3, #$2CF3, #$2CF4, #$2CF5, #$2CF6, #$2CF7,
    #$2CF8, #$2CF9, #$2CFA, #$2CFB, #$2CFC, #$2CFD, #$2CFE, #$2CFF),

    (#$A641, #$A641, #$A643, #$A643, #$A645, #$A645, #$A647, #$A647,
    #$A649, #$A649, #$A64B, #$A64B, #$A64D, #$A64D, #$A64F, #$A64F,
    #$A651, #$A651, #$A653, #$A653, #$A655, #$A655, #$A657, #$A657,
    #$A659, #$A659, #$A65B, #$A65B, #$A65D, #$A65D, #$A65F, #$A65F),

    (#$A661, #$A661, #$A663, #$A663, #$A665, #$A665, #$A667, #$A667,
    #$A669, #$A669, #$A66B, #$A66B, #$A66D, #$A66D, #$A66E, #$A66F,
    #$A670, #$A671, #$A672, #$A673, #$A674, #$A675, #$A676, #$A677,
    #$A678, #$A679, #$A67A, #$A67B, #$A67C, #$A67D, #$A67E, #$A67F),

    (#$A681, #$A681, #$A683, #$A683, #$A685, #$A685, #$A687, #$A687,
    #$A689, #$A689, #$A68B, #$A68B, #$A68D, #$A68D, #$A68F, #$A68F,
    #$A691, #$A691, #$A693, #$A693, #$A695, #$A695, #$A697, #$A697,
    #$A699, #$A699, #$A69B, #$A69B, #$A69C, #$A69D, #$A69E, #$A69F),

    (#$A720, #$A721, #$A723, #$A723, #$A725, #$A725, #$A727, #$A727,
    #$A729, #$A729, #$A72B, #$A72B, #$A72D, #$A72D, #$A72F, #$A72F,
    #$A730, #$A731, #$A733, #$A733, #$A735, #$A735, #$A737, #$A737,
    #$A739, #$A739, #$A73B, #$A73B, #$A73D, #$A73D, #$A73F, #$A73F),

    (#$A741, #$A741, #$A743, #$A743, #$A745, #$A745, #$A747, #$A747,
    #$A749, #$A749, #$A74B, #$A74B, #$A74D, #$A74D, #$A74F, #$A74F,
    #$A751, #$A751, #$A753, #$A753, #$A755, #$A755, #$A757, #$A757,
    #$A759, #$A759, #$A75B, #$A75B, #$A75D, #$A75D, #$A75F, #$A75F),

    (#$A761, #$A761, #$A763, #$A763, #$A765, #$A765, #$A767, #$A767,
    #$A769, #$A769, #$A76B, #$A76B, #$A76D, #$A76D, #$A76F, #$A76F,
    #$A770, #$A771, #$A772, #$A773, #$A774, #$A775, #$A776, #$A777,
    #$A778, #$A77A, #$A77A, #$A77C, #$A77C, #$1D79, #$A77F, #$A77F),

    (#$A781, #$A781, #$A783, #$A783, #$A785, #$A785, #$A787, #$A787,
    #$A788, #$A789, #$A78A, #$A78C, #$A78C, #$0265, #$A78E, #$A78F,
    #$A791, #$A791, #$A793, #$A793, #$A794, #$A795, #$A797, #$A797,
    #$A799, #$A799, #$A79B, #$A79B, #$A79D, #$A79D, #$A79F, #$A79F),

    (#$A7A1, #$A7A1, #$A7A3, #$A7A3, #$A7A5, #$A7A5, #$A7A7, #$A7A7,
    #$A7A9, #$A7A9, #$0266, #$025C, #$0261, #$026C, #$A7AE, #$A7AF,
    #$029E, #$0287, #$A7B2, #$A7B3, #$A7B4, #$A7B5, #$A7B6, #$A7B7,
    #$A7B8, #$A7B9, #$A7BA, #$A7BB, #$A7BC, #$A7BD, #$A7BE, #$A7BF),

    (#$FF20, #$FF41, #$FF42, #$FF43, #$FF44, #$FF45, #$FF46, #$FF47,
    #$FF48, #$FF49, #$FF4A, #$FF4B, #$FF4C, #$FF4D, #$FF4E, #$FF4F,
    #$FF50, #$FF51, #$FF52, #$FF53, #$FF54, #$FF55, #$FF56, #$FF57,
    #$FF58, #$FF59, #$FF5A, #$FF3B, #$FF3C, #$FF3D, #$FF3E, #$FF3F));
  CHAR_TO_CASE_FOLD_SIZE = 32;
var
  i: Integer;
begin
  Result := Char;
  if Result < #$41 then Exit;
  if Result > #$FF3A then Exit;
  i := CHAR_TO_CASE_FOLD_1[(Ord(Result) - $40) div CHAR_TO_CASE_FOLD_SIZE];
  if i <> 0 then
    begin
      Dec(i);
      Result := CHAR_TO_CASE_FOLD_2[i, Ord(Result) and (CHAR_TO_CASE_FOLD_SIZE - 1)];
    end;
end;

function CharToUpperW(const Char: WideChar): WideChar;
const
  CHAR_TO_UPPER_1: array[$0000..$03FC] of Byte = (
    $01, $02, $03, $04, $05, $06, $07, $08,
    $09, $0A, $00, $00, $0B, $0C, $0D, $0E,
    $0F, $10, $11, $12, $13, $14, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $15, $00, $00, $16,
    $17, $18, $19, $1A, $1B, $1C, $1D, $00,

    $00, $00, $00, $00, $1E, $1F, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $20, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $21,
    $22, $23, $24, $25, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $26, $27, $00, $28, $29, $2A, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $2B);
  CHAR_TO_UPPER_2: array[$0000..$002A, $0000..$003F] of WideChar = (

    (#$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047,
    #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
    #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057,
    #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
    #$0060, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047,
    #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
    #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057,
    #$0058, #$0059, #$005A, #$007B, #$007C, #$007D, #$007E, #$007F),

    (#$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087,
    #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
    #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097,
    #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
    #$00A0, #$00A1, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7,
    #$00A8, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
    #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$039C, #$00B6, #$00B7,
    #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF),

    (#$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7,
    #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
    #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00D7,
    #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$00DF,
    #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7,
    #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
    #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00F7,
    #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$0178),

    (#$0100, #$0100, #$0102, #$0102, #$0104, #$0104, #$0106, #$0106,
    #$0108, #$0108, #$010A, #$010A, #$010C, #$010C, #$010E, #$010E,
    #$0110, #$0110, #$0112, #$0112, #$0114, #$0114, #$0116, #$0116,
    #$0118, #$0118, #$011A, #$011A, #$011C, #$011C, #$011E, #$011E,
    #$0120, #$0120, #$0122, #$0122, #$0124, #$0124, #$0126, #$0126,
    #$0128, #$0128, #$012A, #$012A, #$012C, #$012C, #$012E, #$012E,
    #$0130, #$0049, #$0132, #$0132, #$0134, #$0134, #$0136, #$0136,
    #$0138, #$0139, #$0139, #$013B, #$013B, #$013D, #$013D, #$013F),

    (#$013F, #$0141, #$0141, #$0143, #$0143, #$0145, #$0145, #$0147,
    #$0147, #$0149, #$014A, #$014A, #$014C, #$014C, #$014E, #$014E,
    #$0150, #$0150, #$0152, #$0152, #$0154, #$0154, #$0156, #$0156,
    #$0158, #$0158, #$015A, #$015A, #$015C, #$015C, #$015E, #$015E,
    #$0160, #$0160, #$0162, #$0162, #$0164, #$0164, #$0166, #$0166,
    #$0168, #$0168, #$016A, #$016A, #$016C, #$016C, #$016E, #$016E,
    #$0170, #$0170, #$0172, #$0172, #$0174, #$0174, #$0176, #$0176,
    #$0178, #$0179, #$0179, #$017B, #$017B, #$017D, #$017D, #$0053),

    (#$0243, #$0181, #$0182, #$0182, #$0184, #$0184, #$0186, #$0187,
    #$0187, #$0189, #$018A, #$018B, #$018B, #$018D, #$018E, #$018F,
    #$0190, #$0191, #$0191, #$0193, #$0194, #$01F6, #$0196, #$0197,
    #$0198, #$0198, #$023D, #$019B, #$019C, #$019D, #$0220, #$019F,
    #$01A0, #$01A0, #$01A2, #$01A2, #$01A4, #$01A4, #$01A6, #$01A7,
    #$01A7, #$01A9, #$01AA, #$01AB, #$01AC, #$01AC, #$01AE, #$01AF,
    #$01AF, #$01B1, #$01B2, #$01B3, #$01B3, #$01B5, #$01B5, #$01B7,
    #$01B8, #$01B8, #$01BA, #$01BB, #$01BC, #$01BC, #$01BE, #$01F7),

    (#$01C0, #$01C1, #$01C2, #$01C3, #$01C4, #$01C4, #$01C4, #$01C7,
    #$01C7, #$01C7, #$01CA, #$01CA, #$01CA, #$01CD, #$01CD, #$01CF,
    #$01CF, #$01D1, #$01D1, #$01D3, #$01D3, #$01D5, #$01D5, #$01D7,
    #$01D7, #$01D9, #$01D9, #$01DB, #$01DB, #$018E, #$01DE, #$01DE,
    #$01E0, #$01E0, #$01E2, #$01E2, #$01E4, #$01E4, #$01E6, #$01E6,
    #$01E8, #$01E8, #$01EA, #$01EA, #$01EC, #$01EC, #$01EE, #$01EE,
    #$01F0, #$01F1, #$01F1, #$01F1, #$01F4, #$01F4, #$01F6, #$01F7,
    #$01F8, #$01F8, #$01FA, #$01FA, #$01FC, #$01FC, #$01FE, #$01FE),

    (#$0200, #$0200, #$0202, #$0202, #$0204, #$0204, #$0206, #$0206,
    #$0208, #$0208, #$020A, #$020A, #$020C, #$020C, #$020E, #$020E,
    #$0210, #$0210, #$0212, #$0212, #$0214, #$0214, #$0216, #$0216,
    #$0218, #$0218, #$021A, #$021A, #$021C, #$021C, #$021E, #$021E,
    #$0220, #$0221, #$0222, #$0222, #$0224, #$0224, #$0226, #$0226,
    #$0228, #$0228, #$022A, #$022A, #$022C, #$022C, #$022E, #$022E,
    #$0230, #$0230, #$0232, #$0232, #$0234, #$0235, #$0236, #$0237,
    #$0238, #$0239, #$023A, #$023B, #$023B, #$023D, #$023E, #$2C7E),

    (#$2C7F, #$0241, #$0241, #$0243, #$0244, #$0245, #$0246, #$0246,
    #$0248, #$0248, #$024A, #$024A, #$024C, #$024C, #$024E, #$024E,
    #$2C6F, #$2C6D, #$2C70, #$0181, #$0186, #$0255, #$0189, #$018A,
    #$0258, #$018F, #$025A, #$0190, #$A7AB, #$025D, #$025E, #$025F,
    #$0193, #$A7AC, #$0262, #$0194, #$0264, #$A78D, #$A7AA, #$0267,
    #$0197, #$0196, #$026A, #$2C62, #$A7AD, #$026D, #$026E, #$019C,
    #$0270, #$2C6E, #$019D, #$0273, #$0274, #$019F, #$0276, #$0277,
    #$0278, #$0279, #$027A, #$027B, #$027C, #$2C64, #$027E, #$027F),

    (#$01A6, #$0281, #$0282, #$01A9, #$0284, #$0285, #$0286, #$A7B1,
    #$01AE, #$0244, #$01B1, #$01B2, #$0245, #$028D, #$028E, #$028F,
    #$0290, #$0291, #$01B7, #$0293, #$0294, #$0295, #$0296, #$0297,
    #$0298, #$0299, #$029A, #$029B, #$029C, #$029D, #$A7B0, #$029F,
    #$02A0, #$02A1, #$02A2, #$02A3, #$02A4, #$02A5, #$02A6, #$02A7,
    #$02A8, #$02A9, #$02AA, #$02AB, #$02AC, #$02AD, #$02AE, #$02AF,
    #$02B0, #$02B1, #$02B2, #$02B3, #$02B4, #$02B5, #$02B6, #$02B7,
    #$02B8, #$02B9, #$02BA, #$02BB, #$02BC, #$02BD, #$02BE, #$02BF),

    (#$0340, #$0341, #$0342, #$0343, #$0344, #$0399, #$0346, #$0347,
    #$0348, #$0349, #$034A, #$034B, #$034C, #$034D, #$034E, #$034F,
    #$0350, #$0351, #$0352, #$0353, #$0354, #$0355, #$0356, #$0357,
    #$0358, #$0359, #$035A, #$035B, #$035C, #$035D, #$035E, #$035F,
    #$0360, #$0361, #$0362, #$0363, #$0364, #$0365, #$0366, #$0367,
    #$0368, #$0369, #$036A, #$036B, #$036C, #$036D, #$036E, #$036F,
    #$0370, #$0370, #$0372, #$0372, #$0374, #$0375, #$0376, #$0376,
    #$0378, #$0379, #$037A, #$03FD, #$03FE, #$03FF, #$037E, #$037F),

    (#$0380, #$0381, #$0382, #$0383, #$0384, #$0385, #$0386, #$0387,
    #$0388, #$0389, #$038A, #$038B, #$038C, #$038D, #$038E, #$038F,
    #$0390, #$0391, #$0392, #$0393, #$0394, #$0395, #$0396, #$0397,
    #$0398, #$0399, #$039A, #$039B, #$039C, #$039D, #$039E, #$039F,
    #$03A0, #$03A1, #$03A2, #$03A3, #$03A4, #$03A5, #$03A6, #$03A7,
    #$03A8, #$03A9, #$03AA, #$03AB, #$0386, #$0388, #$0389, #$038A,
    #$03B0, #$0391, #$0392, #$0393, #$0394, #$0395, #$0396, #$0397,
    #$0398, #$0399, #$039A, #$039B, #$039C, #$039D, #$039E, #$039F),

    (#$03A0, #$03A1, #$03A3, #$03A3, #$03A4, #$03A5, #$03A6, #$03A7,
    #$03A8, #$03A9, #$03AA, #$03AB, #$038C, #$038E, #$038F, #$03CF,
    #$0392, #$0398, #$03D2, #$03D3, #$03D4, #$03A6, #$03A0, #$03CF,
    #$03D8, #$03D8, #$03DA, #$03DA, #$03DC, #$03DC, #$03DE, #$03DE,
    #$03E0, #$03E0, #$03E2, #$03E2, #$03E4, #$03E4, #$03E6, #$03E6,
    #$03E8, #$03E8, #$03EA, #$03EA, #$03EC, #$03EC, #$03EE, #$03EE,
    #$039A, #$03A1, #$03F9, #$037F, #$03F4, #$0395, #$03F6, #$03F7,
    #$03F7, #$03F9, #$03FA, #$03FA, #$03FC, #$03FD, #$03FE, #$03FF),

    (#$0400, #$0401, #$0402, #$0403, #$0404, #$0405, #$0406, #$0407,
    #$0408, #$0409, #$040A, #$040B, #$040C, #$040D, #$040E, #$040F,
    #$0410, #$0411, #$0412, #$0413, #$0414, #$0415, #$0416, #$0417,
    #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E, #$041F,
    #$0420, #$0421, #$0422, #$0423, #$0424, #$0425, #$0426, #$0427,
    #$0428, #$0429, #$042A, #$042B, #$042C, #$042D, #$042E, #$042F,
    #$0410, #$0411, #$0412, #$0413, #$0414, #$0415, #$0416, #$0417,
    #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E, #$041F),

    (#$0420, #$0421, #$0422, #$0423, #$0424, #$0425, #$0426, #$0427,
    #$0428, #$0429, #$042A, #$042B, #$042C, #$042D, #$042E, #$042F,
    #$0400, #$0401, #$0402, #$0403, #$0404, #$0405, #$0406, #$0407,
    #$0408, #$0409, #$040A, #$040B, #$040C, #$040D, #$040E, #$040F,
    #$0460, #$0460, #$0462, #$0462, #$0464, #$0464, #$0466, #$0466,
    #$0468, #$0468, #$046A, #$046A, #$046C, #$046C, #$046E, #$046E,
    #$0470, #$0470, #$0472, #$0472, #$0474, #$0474, #$0476, #$0476,
    #$0478, #$0478, #$047A, #$047A, #$047C, #$047C, #$047E, #$047E),

    (#$0480, #$0480, #$0482, #$0483, #$0484, #$0485, #$0486, #$0487,
    #$0488, #$0489, #$048A, #$048A, #$048C, #$048C, #$048E, #$048E,
    #$0490, #$0490, #$0492, #$0492, #$0494, #$0494, #$0496, #$0496,
    #$0498, #$0498, #$049A, #$049A, #$049C, #$049C, #$049E, #$049E,
    #$04A0, #$04A0, #$04A2, #$04A2, #$04A4, #$04A4, #$04A6, #$04A6,
    #$04A8, #$04A8, #$04AA, #$04AA, #$04AC, #$04AC, #$04AE, #$04AE,
    #$04B0, #$04B0, #$04B2, #$04B2, #$04B4, #$04B4, #$04B6, #$04B6,
    #$04B8, #$04B8, #$04BA, #$04BA, #$04BC, #$04BC, #$04BE, #$04BE),

    (#$04C0, #$04C1, #$04C1, #$04C3, #$04C3, #$04C5, #$04C5, #$04C7,
    #$04C7, #$04C9, #$04C9, #$04CB, #$04CB, #$04CD, #$04CD, #$04C0,
    #$04D0, #$04D0, #$04D2, #$04D2, #$04D4, #$04D4, #$04D6, #$04D6,
    #$04D8, #$04D8, #$04DA, #$04DA, #$04DC, #$04DC, #$04DE, #$04DE,
    #$04E0, #$04E0, #$04E2, #$04E2, #$04E4, #$04E4, #$04E6, #$04E6,
    #$04E8, #$04E8, #$04EA, #$04EA, #$04EC, #$04EC, #$04EE, #$04EE,
    #$04F0, #$04F0, #$04F2, #$04F2, #$04F4, #$04F4, #$04F6, #$04F6,
    #$04F8, #$04F8, #$04FA, #$04FA, #$04FC, #$04FC, #$04FE, #$04FE),

    (#$0500, #$0500, #$0502, #$0502, #$0504, #$0504, #$0506, #$0506,
    #$0508, #$0508, #$050A, #$050A, #$050C, #$050C, #$050E, #$050E,
    #$0510, #$0510, #$0512, #$0512, #$0514, #$0514, #$0516, #$0516,
    #$0518, #$0518, #$051A, #$051A, #$051C, #$051C, #$051E, #$051E,
    #$0520, #$0520, #$0522, #$0522, #$0524, #$0524, #$0526, #$0526,
    #$0528, #$0528, #$052A, #$052A, #$052C, #$052C, #$052E, #$052E,
    #$0530, #$0531, #$0532, #$0533, #$0534, #$0535, #$0536, #$0537,
    #$0538, #$0539, #$053A, #$053B, #$053C, #$053D, #$053E, #$053F),

    (#$0540, #$0541, #$0542, #$0543, #$0544, #$0545, #$0546, #$0547,
    #$0548, #$0549, #$054A, #$054B, #$054C, #$054D, #$054E, #$054F,
    #$0550, #$0551, #$0552, #$0553, #$0554, #$0555, #$0556, #$0557,
    #$0558, #$0559, #$055A, #$055B, #$055C, #$055D, #$055E, #$055F,
    #$0560, #$0531, #$0532, #$0533, #$0534, #$0535, #$0536, #$0537,
    #$0538, #$0539, #$053A, #$053B, #$053C, #$053D, #$053E, #$053F,
    #$0540, #$0541, #$0542, #$0543, #$0544, #$0545, #$0546, #$0547,
    #$0548, #$0549, #$054A, #$054B, #$054C, #$054D, #$054E, #$054F),

    (#$0550, #$0551, #$0552, #$0553, #$0554, #$0555, #$0556, #$0587,
    #$0588, #$0589, #$058A, #$058B, #$058C, #$058D, #$058E, #$058F,
    #$0590, #$0591, #$0592, #$0593, #$0594, #$0595, #$0596, #$0597,
    #$0598, #$0599, #$059A, #$059B, #$059C, #$059D, #$059E, #$059F,
    #$05A0, #$05A1, #$05A2, #$05A3, #$05A4, #$05A5, #$05A6, #$05A7,
    #$05A8, #$05A9, #$05AA, #$05AB, #$05AC, #$05AD, #$05AE, #$05AF,
    #$05B0, #$05B1, #$05B2, #$05B3, #$05B4, #$05B5, #$05B6, #$05B7,
    #$05B8, #$05B9, #$05BA, #$05BB, #$05BC, #$05BD, #$05BE, #$05BF),

    (#$1D40, #$1D41, #$1D42, #$1D43, #$1D44, #$1D45, #$1D46, #$1D47,
    #$1D48, #$1D49, #$1D4A, #$1D4B, #$1D4C, #$1D4D, #$1D4E, #$1D4F,
    #$1D50, #$1D51, #$1D52, #$1D53, #$1D54, #$1D55, #$1D56, #$1D57,
    #$1D58, #$1D59, #$1D5A, #$1D5B, #$1D5C, #$1D5D, #$1D5E, #$1D5F,
    #$1D60, #$1D61, #$1D62, #$1D63, #$1D64, #$1D65, #$1D66, #$1D67,
    #$1D68, #$1D69, #$1D6A, #$1D6B, #$1D6C, #$1D6D, #$1D6E, #$1D6F,
    #$1D70, #$1D71, #$1D72, #$1D73, #$1D74, #$1D75, #$1D76, #$1D77,
    #$1D78, #$A77D, #$1D7A, #$1D7B, #$1D7C, #$2C63, #$1D7E, #$1D7F),

    (#$1E00, #$1E00, #$1E02, #$1E02, #$1E04, #$1E04, #$1E06, #$1E06,
    #$1E08, #$1E08, #$1E0A, #$1E0A, #$1E0C, #$1E0C, #$1E0E, #$1E0E,
    #$1E10, #$1E10, #$1E12, #$1E12, #$1E14, #$1E14, #$1E16, #$1E16,
    #$1E18, #$1E18, #$1E1A, #$1E1A, #$1E1C, #$1E1C, #$1E1E, #$1E1E,
    #$1E20, #$1E20, #$1E22, #$1E22, #$1E24, #$1E24, #$1E26, #$1E26,
    #$1E28, #$1E28, #$1E2A, #$1E2A, #$1E2C, #$1E2C, #$1E2E, #$1E2E,
    #$1E30, #$1E30, #$1E32, #$1E32, #$1E34, #$1E34, #$1E36, #$1E36,
    #$1E38, #$1E38, #$1E3A, #$1E3A, #$1E3C, #$1E3C, #$1E3E, #$1E3E),

    (#$1E40, #$1E40, #$1E42, #$1E42, #$1E44, #$1E44, #$1E46, #$1E46,
    #$1E48, #$1E48, #$1E4A, #$1E4A, #$1E4C, #$1E4C, #$1E4E, #$1E4E,
    #$1E50, #$1E50, #$1E52, #$1E52, #$1E54, #$1E54, #$1E56, #$1E56,
    #$1E58, #$1E58, #$1E5A, #$1E5A, #$1E5C, #$1E5C, #$1E5E, #$1E5E,
    #$1E60, #$1E60, #$1E62, #$1E62, #$1E64, #$1E64, #$1E66, #$1E66,
    #$1E68, #$1E68, #$1E6A, #$1E6A, #$1E6C, #$1E6C, #$1E6E, #$1E6E,
    #$1E70, #$1E70, #$1E72, #$1E72, #$1E74, #$1E74, #$1E76, #$1E76,
    #$1E78, #$1E78, #$1E7A, #$1E7A, #$1E7C, #$1E7C, #$1E7E, #$1E7E),

    (#$1E80, #$1E80, #$1E82, #$1E82, #$1E84, #$1E84, #$1E86, #$1E86,
    #$1E88, #$1E88, #$1E8A, #$1E8A, #$1E8C, #$1E8C, #$1E8E, #$1E8E,
    #$1E90, #$1E90, #$1E92, #$1E92, #$1E94, #$1E94, #$1E96, #$1E97,
    #$1E98, #$1E99, #$1E9A, #$1E60, #$1E9C, #$1E9D, #$1E9E, #$1E9F,
    #$1EA0, #$1EA0, #$1EA2, #$1EA2, #$1EA4, #$1EA4, #$1EA6, #$1EA6,
    #$1EA8, #$1EA8, #$1EAA, #$1EAA, #$1EAC, #$1EAC, #$1EAE, #$1EAE,
    #$1EB0, #$1EB0, #$1EB2, #$1EB2, #$1EB4, #$1EB4, #$1EB6, #$1EB6,
    #$1EB8, #$1EB8, #$1EBA, #$1EBA, #$1EBC, #$1EBC, #$1EBE, #$1EBE),

    (#$1EC0, #$1EC0, #$1EC2, #$1EC2, #$1EC4, #$1EC4, #$1EC6, #$1EC6,
    #$1EC8, #$1EC8, #$1ECA, #$1ECA, #$1ECC, #$1ECC, #$1ECE, #$1ECE,
    #$1ED0, #$1ED0, #$1ED2, #$1ED2, #$1ED4, #$1ED4, #$1ED6, #$1ED6,
    #$1ED8, #$1ED8, #$1EDA, #$1EDA, #$1EDC, #$1EDC, #$1EDE, #$1EDE,
    #$1EE0, #$1EE0, #$1EE2, #$1EE2, #$1EE4, #$1EE4, #$1EE6, #$1EE6,
    #$1EE8, #$1EE8, #$1EEA, #$1EEA, #$1EEC, #$1EEC, #$1EEE, #$1EEE,
    #$1EF0, #$1EF0, #$1EF2, #$1EF2, #$1EF4, #$1EF4, #$1EF6, #$1EF6,
    #$1EF8, #$1EF8, #$1EFA, #$1EFA, #$1EFC, #$1EFC, #$1EFE, #$1EFE),

    (#$1F08, #$1F09, #$1F0A, #$1F0B, #$1F0C, #$1F0D, #$1F0E, #$1F0F,
    #$1F08, #$1F09, #$1F0A, #$1F0B, #$1F0C, #$1F0D, #$1F0E, #$1F0F,
    #$1F18, #$1F19, #$1F1A, #$1F1B, #$1F1C, #$1F1D, #$1F16, #$1F17,
    #$1F18, #$1F19, #$1F1A, #$1F1B, #$1F1C, #$1F1D, #$1F1E, #$1F1F,
    #$1F28, #$1F29, #$1F2A, #$1F2B, #$1F2C, #$1F2D, #$1F2E, #$1F2F,
    #$1F28, #$1F29, #$1F2A, #$1F2B, #$1F2C, #$1F2D, #$1F2E, #$1F2F,
    #$1F38, #$1F39, #$1F3A, #$1F3B, #$1F3C, #$1F3D, #$1F3E, #$1F3F,
    #$1F38, #$1F39, #$1F3A, #$1F3B, #$1F3C, #$1F3D, #$1F3E, #$1F3F),

    (#$1F48, #$1F49, #$1F4A, #$1F4B, #$1F4C, #$1F4D, #$1F46, #$1F47,
    #$1F48, #$1F49, #$1F4A, #$1F4B, #$1F4C, #$1F4D, #$1F4E, #$1F4F,
    #$1F50, #$1F59, #$1F52, #$1F5B, #$1F54, #$1F5D, #$1F56, #$1F5F,
    #$1F58, #$1F59, #$1F5A, #$1F5B, #$1F5C, #$1F5D, #$1F5E, #$1F5F,
    #$1F68, #$1F69, #$1F6A, #$1F6B, #$1F6C, #$1F6D, #$1F6E, #$1F6F,
    #$1F68, #$1F69, #$1F6A, #$1F6B, #$1F6C, #$1F6D, #$1F6E, #$1F6F,
    #$1FBA, #$1FBB, #$1FC8, #$1FC9, #$1FCA, #$1FCB, #$1FDA, #$1FDB,
    #$1FF8, #$1FF9, #$1FEA, #$1FEB, #$1FFA, #$1FFB, #$1F7E, #$1F7F),

    (#$1F88, #$1F89, #$1F8A, #$1F8B, #$1F8C, #$1F8D, #$1F8E, #$1F8F,
    #$1F88, #$1F89, #$1F8A, #$1F8B, #$1F8C, #$1F8D, #$1F8E, #$1F8F,
    #$1F98, #$1F99, #$1F9A, #$1F9B, #$1F9C, #$1F9D, #$1F9E, #$1F9F,
    #$1F98, #$1F99, #$1F9A, #$1F9B, #$1F9C, #$1F9D, #$1F9E, #$1F9F,
    #$1FA8, #$1FA9, #$1FAA, #$1FAB, #$1FAC, #$1FAD, #$1FAE, #$1FAF,
    #$1FA8, #$1FA9, #$1FAA, #$1FAB, #$1FAC, #$1FAD, #$1FAE, #$1FAF,
    #$1FB8, #$1FB9, #$1FB2, #$1FBC, #$1FB4, #$1FB5, #$1FB6, #$1FB7,
    #$1FB8, #$1FB9, #$1FBA, #$1FBB, #$1FBC, #$1FBD, #$0399, #$1FBF),

    (#$1FC0, #$1FC1, #$1FC2, #$1FCC, #$1FC4, #$1FC5, #$1FC6, #$1FC7,
    #$1FC8, #$1FC9, #$1FCA, #$1FCB, #$1FCC, #$1FCD, #$1FCE, #$1FCF,
    #$1FD8, #$1FD9, #$1FD2, #$1FD3, #$1FD4, #$1FD5, #$1FD6, #$1FD7,
    #$1FD8, #$1FD9, #$1FDA, #$1FDB, #$1FDC, #$1FDD, #$1FDE, #$1FDF,
    #$1FE8, #$1FE9, #$1FE2, #$1FE3, #$1FE4, #$1FEC, #$1FE6, #$1FE7,
    #$1FE8, #$1FE9, #$1FEA, #$1FEB, #$1FEC, #$1FED, #$1FEE, #$1FEF,
    #$1FF0, #$1FF1, #$1FF2, #$1FFC, #$1FF4, #$1FF5, #$1FF6, #$1FF7,
    #$1FF8, #$1FF9, #$1FFA, #$1FFB, #$1FFC, #$1FFD, #$1FFE, #$1FFF),

    (#$2140, #$2141, #$2142, #$2143, #$2144, #$2145, #$2146, #$2147,
    #$2148, #$2149, #$214A, #$214B, #$214C, #$214D, #$2132, #$214F,
    #$2150, #$2151, #$2152, #$2153, #$2154, #$2155, #$2156, #$2157,
    #$2158, #$2159, #$215A, #$215B, #$215C, #$215D, #$215E, #$215F,
    #$2160, #$2161, #$2162, #$2163, #$2164, #$2165, #$2166, #$2167,
    #$2168, #$2169, #$216A, #$216B, #$216C, #$216D, #$216E, #$216F,
    #$2160, #$2161, #$2162, #$2163, #$2164, #$2165, #$2166, #$2167,
    #$2168, #$2169, #$216A, #$216B, #$216C, #$216D, #$216E, #$216F),

    (#$2180, #$2181, #$2182, #$2183, #$2183, #$2185, #$2186, #$2187,
    #$2188, #$2189, #$218A, #$218B, #$218C, #$218D, #$218E, #$218F,
    #$2190, #$2191, #$2192, #$2193, #$2194, #$2195, #$2196, #$2197,
    #$2198, #$2199, #$219A, #$219B, #$219C, #$219D, #$219E, #$219F,
    #$21A0, #$21A1, #$21A2, #$21A3, #$21A4, #$21A5, #$21A6, #$21A7,
    #$21A8, #$21A9, #$21AA, #$21AB, #$21AC, #$21AD, #$21AE, #$21AF,
    #$21B0, #$21B1, #$21B2, #$21B3, #$21B4, #$21B5, #$21B6, #$21B7,
    #$21B8, #$21B9, #$21BA, #$21BB, #$21BC, #$21BD, #$21BE, #$21BF),

    (#$24C0, #$24C1, #$24C2, #$24C3, #$24C4, #$24C5, #$24C6, #$24C7,
    #$24C8, #$24C9, #$24CA, #$24CB, #$24CC, #$24CD, #$24CE, #$24CF,
    #$24B6, #$24B7, #$24B8, #$24B9, #$24BA, #$24BB, #$24BC, #$24BD,
    #$24BE, #$24BF, #$24C0, #$24C1, #$24C2, #$24C3, #$24C4, #$24C5,
    #$24C6, #$24C7, #$24C8, #$24C9, #$24CA, #$24CB, #$24CC, #$24CD,
    #$24CE, #$24CF, #$24EA, #$24EB, #$24EC, #$24ED, #$24EE, #$24EF,
    #$24F0, #$24F1, #$24F2, #$24F3, #$24F4, #$24F5, #$24F6, #$24F7,
    #$24F8, #$24F9, #$24FA, #$24FB, #$24FC, #$24FD, #$24FE, #$24FF),

    (#$2C00, #$2C01, #$2C02, #$2C03, #$2C04, #$2C05, #$2C06, #$2C07,
    #$2C08, #$2C09, #$2C0A, #$2C0B, #$2C0C, #$2C0D, #$2C0E, #$2C0F,
    #$2C10, #$2C11, #$2C12, #$2C13, #$2C14, #$2C15, #$2C16, #$2C17,
    #$2C18, #$2C19, #$2C1A, #$2C1B, #$2C1C, #$2C1D, #$2C1E, #$2C1F,
    #$2C20, #$2C21, #$2C22, #$2C23, #$2C24, #$2C25, #$2C26, #$2C27,
    #$2C28, #$2C29, #$2C2A, #$2C2B, #$2C2C, #$2C2D, #$2C2E, #$2C2F,
    #$2C00, #$2C01, #$2C02, #$2C03, #$2C04, #$2C05, #$2C06, #$2C07,
    #$2C08, #$2C09, #$2C0A, #$2C0B, #$2C0C, #$2C0D, #$2C0E, #$2C0F),

    (#$2C10, #$2C11, #$2C12, #$2C13, #$2C14, #$2C15, #$2C16, #$2C17,
    #$2C18, #$2C19, #$2C1A, #$2C1B, #$2C1C, #$2C1D, #$2C1E, #$2C1F,
    #$2C20, #$2C21, #$2C22, #$2C23, #$2C24, #$2C25, #$2C26, #$2C27,
    #$2C28, #$2C29, #$2C2A, #$2C2B, #$2C2C, #$2C2D, #$2C2E, #$2C5F,
    #$2C60, #$2C60, #$2C62, #$2C63, #$2C64, #$023A, #$023E, #$2C67,
    #$2C67, #$2C69, #$2C69, #$2C6B, #$2C6B, #$2C6D, #$2C6E, #$2C6F,
    #$2C70, #$2C71, #$2C72, #$2C72, #$2C74, #$2C75, #$2C75, #$2C77,
    #$2C78, #$2C79, #$2C7A, #$2C7B, #$2C7C, #$2C7D, #$2C7E, #$2C7F),

    (#$2C80, #$2C80, #$2C82, #$2C82, #$2C84, #$2C84, #$2C86, #$2C86,
    #$2C88, #$2C88, #$2C8A, #$2C8A, #$2C8C, #$2C8C, #$2C8E, #$2C8E,
    #$2C90, #$2C90, #$2C92, #$2C92, #$2C94, #$2C94, #$2C96, #$2C96,
    #$2C98, #$2C98, #$2C9A, #$2C9A, #$2C9C, #$2C9C, #$2C9E, #$2C9E,
    #$2CA0, #$2CA0, #$2CA2, #$2CA2, #$2CA4, #$2CA4, #$2CA6, #$2CA6,
    #$2CA8, #$2CA8, #$2CAA, #$2CAA, #$2CAC, #$2CAC, #$2CAE, #$2CAE,
    #$2CB0, #$2CB0, #$2CB2, #$2CB2, #$2CB4, #$2CB4, #$2CB6, #$2CB6,
    #$2CB8, #$2CB8, #$2CBA, #$2CBA, #$2CBC, #$2CBC, #$2CBE, #$2CBE),

    (#$2CC0, #$2CC0, #$2CC2, #$2CC2, #$2CC4, #$2CC4, #$2CC6, #$2CC6,
    #$2CC8, #$2CC8, #$2CCA, #$2CCA, #$2CCC, #$2CCC, #$2CCE, #$2CCE,
    #$2CD0, #$2CD0, #$2CD2, #$2CD2, #$2CD4, #$2CD4, #$2CD6, #$2CD6,
    #$2CD8, #$2CD8, #$2CDA, #$2CDA, #$2CDC, #$2CDC, #$2CDE, #$2CDE,
    #$2CE0, #$2CE0, #$2CE2, #$2CE2, #$2CE4, #$2CE5, #$2CE6, #$2CE7,
    #$2CE8, #$2CE9, #$2CEA, #$2CEB, #$2CEB, #$2CED, #$2CED, #$2CEF,
    #$2CF0, #$2CF1, #$2CF2, #$2CF2, #$2CF4, #$2CF5, #$2CF6, #$2CF7,
    #$2CF8, #$2CF9, #$2CFA, #$2CFB, #$2CFC, #$2CFD, #$2CFE, #$2CFF),

    (#$10A0, #$10A1, #$10A2, #$10A3, #$10A4, #$10A5, #$10A6, #$10A7,
    #$10A8, #$10A9, #$10AA, #$10AB, #$10AC, #$10AD, #$10AE, #$10AF,
    #$10B0, #$10B1, #$10B2, #$10B3, #$10B4, #$10B5, #$10B6, #$10B7,
    #$10B8, #$10B9, #$10BA, #$10BB, #$10BC, #$10BD, #$10BE, #$10BF,
    #$10C0, #$10C1, #$10C2, #$10C3, #$10C4, #$10C5, #$2D26, #$10C7,
    #$2D28, #$2D29, #$2D2A, #$2D2B, #$2D2C, #$10CD, #$2D2E, #$2D2F,
    #$2D30, #$2D31, #$2D32, #$2D33, #$2D34, #$2D35, #$2D36, #$2D37,
    #$2D38, #$2D39, #$2D3A, #$2D3B, #$2D3C, #$2D3D, #$2D3E, #$2D3F),

    (#$A640, #$A640, #$A642, #$A642, #$A644, #$A644, #$A646, #$A646,
    #$A648, #$A648, #$A64A, #$A64A, #$A64C, #$A64C, #$A64E, #$A64E,
    #$A650, #$A650, #$A652, #$A652, #$A654, #$A654, #$A656, #$A656,
    #$A658, #$A658, #$A65A, #$A65A, #$A65C, #$A65C, #$A65E, #$A65E,
    #$A660, #$A660, #$A662, #$A662, #$A664, #$A664, #$A666, #$A666,
    #$A668, #$A668, #$A66A, #$A66A, #$A66C, #$A66C, #$A66E, #$A66F,
    #$A670, #$A671, #$A672, #$A673, #$A674, #$A675, #$A676, #$A677,
    #$A678, #$A679, #$A67A, #$A67B, #$A67C, #$A67D, #$A67E, #$A67F),

    (#$A680, #$A680, #$A682, #$A682, #$A684, #$A684, #$A686, #$A686,
    #$A688, #$A688, #$A68A, #$A68A, #$A68C, #$A68C, #$A68E, #$A68E,
    #$A690, #$A690, #$A692, #$A692, #$A694, #$A694, #$A696, #$A696,
    #$A698, #$A698, #$A69A, #$A69A, #$A69C, #$A69D, #$A69E, #$A69F,
    #$A6A0, #$A6A1, #$A6A2, #$A6A3, #$A6A4, #$A6A5, #$A6A6, #$A6A7,
    #$A6A8, #$A6A9, #$A6AA, #$A6AB, #$A6AC, #$A6AD, #$A6AE, #$A6AF,
    #$A6B0, #$A6B1, #$A6B2, #$A6B3, #$A6B4, #$A6B5, #$A6B6, #$A6B7,
    #$A6B8, #$A6B9, #$A6BA, #$A6BB, #$A6BC, #$A6BD, #$A6BE, #$A6BF),

    (#$A700, #$A701, #$A702, #$A703, #$A704, #$A705, #$A706, #$A707,
    #$A708, #$A709, #$A70A, #$A70B, #$A70C, #$A70D, #$A70E, #$A70F,
    #$A710, #$A711, #$A712, #$A713, #$A714, #$A715, #$A716, #$A717,
    #$A718, #$A719, #$A71A, #$A71B, #$A71C, #$A71D, #$A71E, #$A71F,
    #$A720, #$A721, #$A722, #$A722, #$A724, #$A724, #$A726, #$A726,
    #$A728, #$A728, #$A72A, #$A72A, #$A72C, #$A72C, #$A72E, #$A72E,
    #$A730, #$A731, #$A732, #$A732, #$A734, #$A734, #$A736, #$A736,
    #$A738, #$A738, #$A73A, #$A73A, #$A73C, #$A73C, #$A73E, #$A73E),

    (#$A740, #$A740, #$A742, #$A742, #$A744, #$A744, #$A746, #$A746,
    #$A748, #$A748, #$A74A, #$A74A, #$A74C, #$A74C, #$A74E, #$A74E,
    #$A750, #$A750, #$A752, #$A752, #$A754, #$A754, #$A756, #$A756,
    #$A758, #$A758, #$A75A, #$A75A, #$A75C, #$A75C, #$A75E, #$A75E,
    #$A760, #$A760, #$A762, #$A762, #$A764, #$A764, #$A766, #$A766,
    #$A768, #$A768, #$A76A, #$A76A, #$A76C, #$A76C, #$A76E, #$A76E,
    #$A770, #$A771, #$A772, #$A773, #$A774, #$A775, #$A776, #$A777,
    #$A778, #$A779, #$A779, #$A77B, #$A77B, #$A77D, #$A77E, #$A77E),

    (#$A780, #$A780, #$A782, #$A782, #$A784, #$A784, #$A786, #$A786,
    #$A788, #$A789, #$A78A, #$A78B, #$A78B, #$A78D, #$A78E, #$A78F,
    #$A790, #$A790, #$A792, #$A792, #$A794, #$A795, #$A796, #$A796,
    #$A798, #$A798, #$A79A, #$A79A, #$A79C, #$A79C, #$A79E, #$A79E,
    #$A7A0, #$A7A0, #$A7A2, #$A7A2, #$A7A4, #$A7A4, #$A7A6, #$A7A6,
    #$A7A8, #$A7A8, #$A7AA, #$A7AB, #$A7AC, #$A7AD, #$A7AE, #$A7AF,
    #$A7B0, #$A7B1, #$A7B2, #$A7B3, #$A7B4, #$A7B5, #$A7B6, #$A7B7,
    #$A7B8, #$A7B9, #$A7BA, #$A7BB, #$A7BC, #$A7BD, #$A7BE, #$A7BF),

    (#$FF40, #$FF21, #$FF22, #$FF23, #$FF24, #$FF25, #$FF26, #$FF27,
    #$FF28, #$FF29, #$FF2A, #$FF2B, #$FF2C, #$FF2D, #$FF2E, #$FF2F,
    #$FF30, #$FF31, #$FF32, #$FF33, #$FF34, #$FF35, #$FF36, #$FF37,
    #$FF38, #$FF39, #$FF3A, #$FF5B, #$FF5C, #$FF5D, #$FF5E, #$FF5F,
    #$FF60, #$FF61, #$FF62, #$FF63, #$FF64, #$FF65, #$FF66, #$FF67,
    #$FF68, #$FF69, #$FF6A, #$FF6B, #$FF6C, #$FF6D, #$FF6E, #$FF6F,
    #$FF70, #$FF71, #$FF72, #$FF73, #$FF74, #$FF75, #$FF76, #$FF77,
    #$FF78, #$FF79, #$FF7A, #$FF7B, #$FF7C, #$FF7D, #$FF7E, #$FF7F));
  CHAR_TO_UPPER_SIZE = 64;
var
  i: Integer;
begin
  Result := Char;
  if Result < #$61 then Exit;
  if Result > #$FF5A then Exit;
  i := CHAR_TO_UPPER_1[(Ord(Result) - $40) div CHAR_TO_UPPER_SIZE];
  if i <> 0 then
    begin
      Dec(i);
      Result := CHAR_TO_UPPER_2[i, Ord(Result) and (CHAR_TO_UPPER_SIZE - 1)];
    end;
end;

function CharToLowerW(const Char: WideChar): WideChar;
const
  CHAR_TO_LOWER_1: array[$0000..$07F7] of Byte = (
    $01, $00, $00, $00, $02, $00, $03, $04,
    $05, $06, $07, $08, $09, $0A, $0B, $0C,
    $0D, $00, $00, $00, $00, $00, $00, $00,
    $00, $0E, $0F, $10, $11, $12, $13, $14,
    $00, $15, $16, $17, $18, $19, $1A, $1B,
    $1C, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $1D, $1E, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $1F, $20,
    $21, $22, $23, $24, $25, $26, $27, $28,
    $29, $2A, $2B, $2C, $2D, $2E, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $2F,
    $00, $30, $31, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $32, $33, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $34, $35,
    $00, $36, $37, $38, $39, $3A, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $3B, $3C, $3D, $00, $00, $00, $00, $3E,
    $3F, $40, $41, $42, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $43);
  CHAR_TO_LOWER_2: array[$0000..$0042, $0000..$001F] of WideChar = (

    (#$0040, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067,
    #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
    #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077,
    #$0078, #$0079, #$007A, #$005B, #$005C, #$005D, #$005E, #$005F),

    (#$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7,
    #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
    #$00F0, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00D7,
    #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$00DF),

    (#$0101, #$0101, #$0103, #$0103, #$0105, #$0105, #$0107, #$0107,
    #$0109, #$0109, #$010B, #$010B, #$010D, #$010D, #$010F, #$010F,
    #$0111, #$0111, #$0113, #$0113, #$0115, #$0115, #$0117, #$0117,
    #$0119, #$0119, #$011B, #$011B, #$011D, #$011D, #$011F, #$011F),

    (#$0121, #$0121, #$0123, #$0123, #$0125, #$0125, #$0127, #$0127,
    #$0129, #$0129, #$012B, #$012B, #$012D, #$012D, #$012F, #$012F,
    #$0069, #$0131, #$0133, #$0133, #$0135, #$0135, #$0137, #$0137,
    #$0138, #$013A, #$013A, #$013C, #$013C, #$013E, #$013E, #$0140),

    (#$0140, #$0142, #$0142, #$0144, #$0144, #$0146, #$0146, #$0148,
    #$0148, #$0149, #$014B, #$014B, #$014D, #$014D, #$014F, #$014F,
    #$0151, #$0151, #$0153, #$0153, #$0155, #$0155, #$0157, #$0157,
    #$0159, #$0159, #$015B, #$015B, #$015D, #$015D, #$015F, #$015F),

    (#$0161, #$0161, #$0163, #$0163, #$0165, #$0165, #$0167, #$0167,
    #$0169, #$0169, #$016B, #$016B, #$016D, #$016D, #$016F, #$016F,
    #$0171, #$0171, #$0173, #$0173, #$0175, #$0175, #$0177, #$0177,
    #$00FF, #$017A, #$017A, #$017C, #$017C, #$017E, #$017E, #$017F),

    (#$0180, #$0253, #$0183, #$0183, #$0185, #$0185, #$0254, #$0188,
    #$0188, #$0256, #$0257, #$018C, #$018C, #$018D, #$01DD, #$0259,
    #$025B, #$0192, #$0192, #$0260, #$0263, #$0195, #$0269, #$0268,
    #$0199, #$0199, #$019A, #$019B, #$026F, #$0272, #$019E, #$0275),

    (#$01A1, #$01A1, #$01A3, #$01A3, #$01A5, #$01A5, #$0280, #$01A8,
    #$01A8, #$0283, #$01AA, #$01AB, #$01AD, #$01AD, #$0288, #$01B0,
    #$01B0, #$028A, #$028B, #$01B4, #$01B4, #$01B6, #$01B6, #$0292,
    #$01B9, #$01B9, #$01BA, #$01BB, #$01BD, #$01BD, #$01BE, #$01BF),

    (#$01C0, #$01C1, #$01C2, #$01C3, #$01C6, #$01C6, #$01C6, #$01C9,
    #$01C9, #$01C9, #$01CC, #$01CC, #$01CC, #$01CE, #$01CE, #$01D0,
    #$01D0, #$01D2, #$01D2, #$01D4, #$01D4, #$01D6, #$01D6, #$01D8,
    #$01D8, #$01DA, #$01DA, #$01DC, #$01DC, #$01DD, #$01DF, #$01DF),

    (#$01E1, #$01E1, #$01E3, #$01E3, #$01E5, #$01E5, #$01E7, #$01E7,
    #$01E9, #$01E9, #$01EB, #$01EB, #$01ED, #$01ED, #$01EF, #$01EF,
    #$01F0, #$01F3, #$01F3, #$01F3, #$01F5, #$01F5, #$0195, #$01BF,
    #$01F9, #$01F9, #$01FB, #$01FB, #$01FD, #$01FD, #$01FF, #$01FF),

    (#$0201, #$0201, #$0203, #$0203, #$0205, #$0205, #$0207, #$0207,
    #$0209, #$0209, #$020B, #$020B, #$020D, #$020D, #$020F, #$020F,
    #$0211, #$0211, #$0213, #$0213, #$0215, #$0215, #$0217, #$0217,
    #$0219, #$0219, #$021B, #$021B, #$021D, #$021D, #$021F, #$021F),

    (#$019E, #$0221, #$0223, #$0223, #$0225, #$0225, #$0227, #$0227,
    #$0229, #$0229, #$022B, #$022B, #$022D, #$022D, #$022F, #$022F,
    #$0231, #$0231, #$0233, #$0233, #$0234, #$0235, #$0236, #$0237,
    #$0238, #$0239, #$2C65, #$023C, #$023C, #$019A, #$2C66, #$023F),

    (#$0240, #$0242, #$0242, #$0180, #$0289, #$028C, #$0247, #$0247,
    #$0249, #$0249, #$024B, #$024B, #$024D, #$024D, #$024F, #$024F,
    #$0250, #$0251, #$0252, #$0253, #$0254, #$0255, #$0256, #$0257,
    #$0258, #$0259, #$025A, #$025B, #$025C, #$025D, #$025E, #$025F),

    (#$0360, #$0361, #$0362, #$0363, #$0364, #$0365, #$0366, #$0367,
    #$0368, #$0369, #$036A, #$036B, #$036C, #$036D, #$036E, #$036F,
    #$0371, #$0371, #$0373, #$0373, #$0374, #$0375, #$0377, #$0377,
    #$0378, #$0379, #$037A, #$037B, #$037C, #$037D, #$037E, #$03F3),

    (#$0380, #$0381, #$0382, #$0383, #$0384, #$0385, #$03AC, #$0387,
    #$03AD, #$03AE, #$03AF, #$038B, #$03CC, #$038D, #$03CD, #$03CE,
    #$0390, #$03B1, #$03B2, #$03B3, #$03B4, #$03B5, #$03B6, #$03B7,
    #$03B8, #$03B9, #$03BA, #$03BB, #$03BC, #$03BD, #$03BE, #$03BF),

    (#$03C0, #$03C1, #$03A2, #$03C3, #$03C4, #$03C5, #$03C6, #$03C7,
    #$03C8, #$03C9, #$03CA, #$03CB, #$03AC, #$03AD, #$03AE, #$03AF,
    #$03B0, #$03B1, #$03B2, #$03B3, #$03B4, #$03B5, #$03B6, #$03B7,
    #$03B8, #$03B9, #$03BA, #$03BB, #$03BC, #$03BD, #$03BE, #$03BF),

    (#$03C0, #$03C1, #$03C2, #$03C3, #$03C4, #$03C5, #$03C6, #$03C7,
    #$03C8, #$03C9, #$03CA, #$03CB, #$03CC, #$03CD, #$03CE, #$03D7,
    #$03D0, #$03D1, #$03D2, #$03D3, #$03D4, #$03D5, #$03D6, #$03D7,
    #$03D9, #$03D9, #$03DB, #$03DB, #$03DD, #$03DD, #$03DF, #$03DF),

    (#$03E1, #$03E1, #$03E3, #$03E3, #$03E5, #$03E5, #$03E7, #$03E7,
    #$03E9, #$03E9, #$03EB, #$03EB, #$03ED, #$03ED, #$03EF, #$03EF,
    #$03F0, #$03F1, #$03F2, #$03F3, #$03B8, #$03F5, #$03F6, #$03F8,
    #$03F8, #$03F2, #$03FB, #$03FB, #$03FC, #$037B, #$037C, #$037D),

    (#$0450, #$0451, #$0452, #$0453, #$0454, #$0455, #$0456, #$0457,
    #$0458, #$0459, #$045A, #$045B, #$045C, #$045D, #$045E, #$045F,
    #$0430, #$0431, #$0432, #$0433, #$0434, #$0435, #$0436, #$0437,
    #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E, #$043F),

    (#$0440, #$0441, #$0442, #$0443, #$0444, #$0445, #$0446, #$0447,
    #$0448, #$0449, #$044A, #$044B, #$044C, #$044D, #$044E, #$044F,
    #$0430, #$0431, #$0432, #$0433, #$0434, #$0435, #$0436, #$0437,
    #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E, #$043F),

    (#$0461, #$0461, #$0463, #$0463, #$0465, #$0465, #$0467, #$0467,
    #$0469, #$0469, #$046B, #$046B, #$046D, #$046D, #$046F, #$046F,
    #$0471, #$0471, #$0473, #$0473, #$0475, #$0475, #$0477, #$0477,
    #$0479, #$0479, #$047B, #$047B, #$047D, #$047D, #$047F, #$047F),

    (#$0481, #$0481, #$0482, #$0483, #$0484, #$0485, #$0486, #$0487,
    #$0488, #$0489, #$048B, #$048B, #$048D, #$048D, #$048F, #$048F,
    #$0491, #$0491, #$0493, #$0493, #$0495, #$0495, #$0497, #$0497,
    #$0499, #$0499, #$049B, #$049B, #$049D, #$049D, #$049F, #$049F),

    (#$04A1, #$04A1, #$04A3, #$04A3, #$04A5, #$04A5, #$04A7, #$04A7,
    #$04A9, #$04A9, #$04AB, #$04AB, #$04AD, #$04AD, #$04AF, #$04AF,
    #$04B1, #$04B1, #$04B3, #$04B3, #$04B5, #$04B5, #$04B7, #$04B7,
    #$04B9, #$04B9, #$04BB, #$04BB, #$04BD, #$04BD, #$04BF, #$04BF),

    (#$04CF, #$04C2, #$04C2, #$04C4, #$04C4, #$04C6, #$04C6, #$04C8,
    #$04C8, #$04CA, #$04CA, #$04CC, #$04CC, #$04CE, #$04CE, #$04CF,
    #$04D1, #$04D1, #$04D3, #$04D3, #$04D5, #$04D5, #$04D7, #$04D7,
    #$04D9, #$04D9, #$04DB, #$04DB, #$04DD, #$04DD, #$04DF, #$04DF),

    (#$04E1, #$04E1, #$04E3, #$04E3, #$04E5, #$04E5, #$04E7, #$04E7,
    #$04E9, #$04E9, #$04EB, #$04EB, #$04ED, #$04ED, #$04EF, #$04EF,
    #$04F1, #$04F1, #$04F3, #$04F3, #$04F5, #$04F5, #$04F7, #$04F7,
    #$04F9, #$04F9, #$04FB, #$04FB, #$04FD, #$04FD, #$04FF, #$04FF),

    (#$0501, #$0501, #$0503, #$0503, #$0505, #$0505, #$0507, #$0507,
    #$0509, #$0509, #$050B, #$050B, #$050D, #$050D, #$050F, #$050F,
    #$0511, #$0511, #$0513, #$0513, #$0515, #$0515, #$0517, #$0517,
    #$0519, #$0519, #$051B, #$051B, #$051D, #$051D, #$051F, #$051F),

    (#$0521, #$0521, #$0523, #$0523, #$0525, #$0525, #$0527, #$0527,
    #$0529, #$0529, #$052B, #$052B, #$052D, #$052D, #$052F, #$052F,
    #$0530, #$0561, #$0562, #$0563, #$0564, #$0565, #$0566, #$0567,
    #$0568, #$0569, #$056A, #$056B, #$056C, #$056D, #$056E, #$056F),

    (#$0570, #$0571, #$0572, #$0573, #$0574, #$0575, #$0576, #$0577,
    #$0578, #$0579, #$057A, #$057B, #$057C, #$057D, #$057E, #$057F,
    #$0580, #$0581, #$0582, #$0583, #$0584, #$0585, #$0586, #$0557,
    #$0558, #$0559, #$055A, #$055B, #$055C, #$055D, #$055E, #$055F),

    (#$2D00, #$2D01, #$2D02, #$2D03, #$2D04, #$2D05, #$2D06, #$2D07,
    #$2D08, #$2D09, #$2D0A, #$2D0B, #$2D0C, #$2D0D, #$2D0E, #$2D0F,
    #$2D10, #$2D11, #$2D12, #$2D13, #$2D14, #$2D15, #$2D16, #$2D17,
    #$2D18, #$2D19, #$2D1A, #$2D1B, #$2D1C, #$2D1D, #$2D1E, #$2D1F),

    (#$2D20, #$2D21, #$2D22, #$2D23, #$2D24, #$2D25, #$10C6, #$2D27,
    #$10C8, #$10C9, #$10CA, #$10CB, #$10CC, #$2D2D, #$10CE, #$10CF,
    #$10D0, #$10D1, #$10D2, #$10D3, #$10D4, #$10D5, #$10D6, #$10D7,
    #$10D8, #$10D9, #$10DA, #$10DB, #$10DC, #$10DD, #$10DE, #$10DF),

    (#$1E01, #$1E01, #$1E03, #$1E03, #$1E05, #$1E05, #$1E07, #$1E07,
    #$1E09, #$1E09, #$1E0B, #$1E0B, #$1E0D, #$1E0D, #$1E0F, #$1E0F,
    #$1E11, #$1E11, #$1E13, #$1E13, #$1E15, #$1E15, #$1E17, #$1E17,
    #$1E19, #$1E19, #$1E1B, #$1E1B, #$1E1D, #$1E1D, #$1E1F, #$1E1F),

    (#$1E21, #$1E21, #$1E23, #$1E23, #$1E25, #$1E25, #$1E27, #$1E27,
    #$1E29, #$1E29, #$1E2B, #$1E2B, #$1E2D, #$1E2D, #$1E2F, #$1E2F,
    #$1E31, #$1E31, #$1E33, #$1E33, #$1E35, #$1E35, #$1E37, #$1E37,
    #$1E39, #$1E39, #$1E3B, #$1E3B, #$1E3D, #$1E3D, #$1E3F, #$1E3F),

    (#$1E41, #$1E41, #$1E43, #$1E43, #$1E45, #$1E45, #$1E47, #$1E47,
    #$1E49, #$1E49, #$1E4B, #$1E4B, #$1E4D, #$1E4D, #$1E4F, #$1E4F,
    #$1E51, #$1E51, #$1E53, #$1E53, #$1E55, #$1E55, #$1E57, #$1E57,
    #$1E59, #$1E59, #$1E5B, #$1E5B, #$1E5D, #$1E5D, #$1E5F, #$1E5F),

    (#$1E61, #$1E61, #$1E63, #$1E63, #$1E65, #$1E65, #$1E67, #$1E67,
    #$1E69, #$1E69, #$1E6B, #$1E6B, #$1E6D, #$1E6D, #$1E6F, #$1E6F,
    #$1E71, #$1E71, #$1E73, #$1E73, #$1E75, #$1E75, #$1E77, #$1E77,
    #$1E79, #$1E79, #$1E7B, #$1E7B, #$1E7D, #$1E7D, #$1E7F, #$1E7F),

    (#$1E81, #$1E81, #$1E83, #$1E83, #$1E85, #$1E85, #$1E87, #$1E87,
    #$1E89, #$1E89, #$1E8B, #$1E8B, #$1E8D, #$1E8D, #$1E8F, #$1E8F,
    #$1E91, #$1E91, #$1E93, #$1E93, #$1E95, #$1E95, #$1E96, #$1E97,
    #$1E98, #$1E99, #$1E9A, #$1E9B, #$1E9C, #$1E9D, #$00DF, #$1E9F),

    (#$1EA1, #$1EA1, #$1EA3, #$1EA3, #$1EA5, #$1EA5, #$1EA7, #$1EA7,
    #$1EA9, #$1EA9, #$1EAB, #$1EAB, #$1EAD, #$1EAD, #$1EAF, #$1EAF,
    #$1EB1, #$1EB1, #$1EB3, #$1EB3, #$1EB5, #$1EB5, #$1EB7, #$1EB7,
    #$1EB9, #$1EB9, #$1EBB, #$1EBB, #$1EBD, #$1EBD, #$1EBF, #$1EBF),

    (#$1EC1, #$1EC1, #$1EC3, #$1EC3, #$1EC5, #$1EC5, #$1EC7, #$1EC7,
    #$1EC9, #$1EC9, #$1ECB, #$1ECB, #$1ECD, #$1ECD, #$1ECF, #$1ECF,
    #$1ED1, #$1ED1, #$1ED3, #$1ED3, #$1ED5, #$1ED5, #$1ED7, #$1ED7,
    #$1ED9, #$1ED9, #$1EDB, #$1EDB, #$1EDD, #$1EDD, #$1EDF, #$1EDF),

    (#$1EE1, #$1EE1, #$1EE3, #$1EE3, #$1EE5, #$1EE5, #$1EE7, #$1EE7,
    #$1EE9, #$1EE9, #$1EEB, #$1EEB, #$1EED, #$1EED, #$1EEF, #$1EEF,
    #$1EF1, #$1EF1, #$1EF3, #$1EF3, #$1EF5, #$1EF5, #$1EF7, #$1EF7,
    #$1EF9, #$1EF9, #$1EFB, #$1EFB, #$1EFD, #$1EFD, #$1EFF, #$1EFF),

    (#$1F00, #$1F01, #$1F02, #$1F03, #$1F04, #$1F05, #$1F06, #$1F07,
    #$1F00, #$1F01, #$1F02, #$1F03, #$1F04, #$1F05, #$1F06, #$1F07,
    #$1F10, #$1F11, #$1F12, #$1F13, #$1F14, #$1F15, #$1F16, #$1F17,
    #$1F10, #$1F11, #$1F12, #$1F13, #$1F14, #$1F15, #$1F1E, #$1F1F),

    (#$1F20, #$1F21, #$1F22, #$1F23, #$1F24, #$1F25, #$1F26, #$1F27,
    #$1F20, #$1F21, #$1F22, #$1F23, #$1F24, #$1F25, #$1F26, #$1F27,
    #$1F30, #$1F31, #$1F32, #$1F33, #$1F34, #$1F35, #$1F36, #$1F37,
    #$1F30, #$1F31, #$1F32, #$1F33, #$1F34, #$1F35, #$1F36, #$1F37),

    (#$1F40, #$1F41, #$1F42, #$1F43, #$1F44, #$1F45, #$1F46, #$1F47,
    #$1F40, #$1F41, #$1F42, #$1F43, #$1F44, #$1F45, #$1F4E, #$1F4F,
    #$1F50, #$1F51, #$1F52, #$1F53, #$1F54, #$1F55, #$1F56, #$1F57,
    #$1F58, #$1F51, #$1F5A, #$1F53, #$1F5C, #$1F55, #$1F5E, #$1F57),

    (#$1F60, #$1F61, #$1F62, #$1F63, #$1F64, #$1F65, #$1F66, #$1F67,
    #$1F60, #$1F61, #$1F62, #$1F63, #$1F64, #$1F65, #$1F66, #$1F67,
    #$1F70, #$1F71, #$1F72, #$1F73, #$1F74, #$1F75, #$1F76, #$1F77,
    #$1F78, #$1F79, #$1F7A, #$1F7B, #$1F7C, #$1F7D, #$1F7E, #$1F7F),

    (#$1F80, #$1F81, #$1F82, #$1F83, #$1F84, #$1F85, #$1F86, #$1F87,
    #$1F80, #$1F81, #$1F82, #$1F83, #$1F84, #$1F85, #$1F86, #$1F87,
    #$1F90, #$1F91, #$1F92, #$1F93, #$1F94, #$1F95, #$1F96, #$1F97,
    #$1F90, #$1F91, #$1F92, #$1F93, #$1F94, #$1F95, #$1F96, #$1F97),

    (#$1FA0, #$1FA1, #$1FA2, #$1FA3, #$1FA4, #$1FA5, #$1FA6, #$1FA7,
    #$1FA0, #$1FA1, #$1FA2, #$1FA3, #$1FA4, #$1FA5, #$1FA6, #$1FA7,
    #$1FB0, #$1FB1, #$1FB2, #$1FB3, #$1FB4, #$1FB5, #$1FB6, #$1FB7,
    #$1FB0, #$1FB1, #$1F70, #$1F71, #$1FB3, #$1FBD, #$1FBE, #$1FBF),

    (#$1FC0, #$1FC1, #$1FC2, #$1FC3, #$1FC4, #$1FC5, #$1FC6, #$1FC7,
    #$1F72, #$1F73, #$1F74, #$1F75, #$1FC3, #$1FCD, #$1FCE, #$1FCF,
    #$1FD0, #$1FD1, #$1FD2, #$1FD3, #$1FD4, #$1FD5, #$1FD6, #$1FD7,
    #$1FD0, #$1FD1, #$1F76, #$1F77, #$1FDC, #$1FDD, #$1FDE, #$1FDF),

    (#$1FE0, #$1FE1, #$1FE2, #$1FE3, #$1FE4, #$1FE5, #$1FE6, #$1FE7,
    #$1FE0, #$1FE1, #$1F7A, #$1F7B, #$1FE5, #$1FED, #$1FEE, #$1FEF,
    #$1FF0, #$1FF1, #$1FF2, #$1FF3, #$1FF4, #$1FF5, #$1FF6, #$1FF7,
    #$1F78, #$1F79, #$1F7C, #$1F7D, #$1FF3, #$1FFD, #$1FFE, #$1FFF),

    (#$2120, #$2121, #$2122, #$2123, #$2124, #$2125, #$03C9, #$2127,
    #$2128, #$2129, #$006B, #$00E5, #$212C, #$212D, #$212E, #$212F,
    #$2130, #$2131, #$214E, #$2133, #$2134, #$2135, #$2136, #$2137,
    #$2138, #$2139, #$213A, #$213B, #$213C, #$213D, #$213E, #$213F),

    (#$2170, #$2171, #$2172, #$2173, #$2174, #$2175, #$2176, #$2177,
    #$2178, #$2179, #$217A, #$217B, #$217C, #$217D, #$217E, #$217F,
    #$2170, #$2171, #$2172, #$2173, #$2174, #$2175, #$2176, #$2177,
    #$2178, #$2179, #$217A, #$217B, #$217C, #$217D, #$217E, #$217F),

    (#$2180, #$2181, #$2182, #$2184, #$2184, #$2185, #$2186, #$2187,
    #$2188, #$2189, #$218A, #$218B, #$218C, #$218D, #$218E, #$218F,
    #$2190, #$2191, #$2192, #$2193, #$2194, #$2195, #$2196, #$2197,
    #$2198, #$2199, #$219A, #$219B, #$219C, #$219D, #$219E, #$219F),

    (#$24A0, #$24A1, #$24A2, #$24A3, #$24A4, #$24A5, #$24A6, #$24A7,
    #$24A8, #$24A9, #$24AA, #$24AB, #$24AC, #$24AD, #$24AE, #$24AF,
    #$24B0, #$24B1, #$24B2, #$24B3, #$24B4, #$24B5, #$24D0, #$24D1,
    #$24D2, #$24D3, #$24D4, #$24D5, #$24D6, #$24D7, #$24D8, #$24D9),

    (#$24DA, #$24DB, #$24DC, #$24DD, #$24DE, #$24DF, #$24E0, #$24E1,
    #$24E2, #$24E3, #$24E4, #$24E5, #$24E6, #$24E7, #$24E8, #$24E9,
    #$24D0, #$24D1, #$24D2, #$24D3, #$24D4, #$24D5, #$24D6, #$24D7,
    #$24D8, #$24D9, #$24DA, #$24DB, #$24DC, #$24DD, #$24DE, #$24DF),

    (#$2C30, #$2C31, #$2C32, #$2C33, #$2C34, #$2C35, #$2C36, #$2C37,
    #$2C38, #$2C39, #$2C3A, #$2C3B, #$2C3C, #$2C3D, #$2C3E, #$2C3F,
    #$2C40, #$2C41, #$2C42, #$2C43, #$2C44, #$2C45, #$2C46, #$2C47,
    #$2C48, #$2C49, #$2C4A, #$2C4B, #$2C4C, #$2C4D, #$2C4E, #$2C4F),

    (#$2C50, #$2C51, #$2C52, #$2C53, #$2C54, #$2C55, #$2C56, #$2C57,
    #$2C58, #$2C59, #$2C5A, #$2C5B, #$2C5C, #$2C5D, #$2C5E, #$2C2F,
    #$2C30, #$2C31, #$2C32, #$2C33, #$2C34, #$2C35, #$2C36, #$2C37,
    #$2C38, #$2C39, #$2C3A, #$2C3B, #$2C3C, #$2C3D, #$2C3E, #$2C3F),

    (#$2C61, #$2C61, #$026B, #$1D7D, #$027D, #$2C65, #$2C66, #$2C68,
    #$2C68, #$2C6A, #$2C6A, #$2C6C, #$2C6C, #$0251, #$0271, #$0250,
    #$0252, #$2C71, #$2C73, #$2C73, #$2C74, #$2C76, #$2C76, #$2C77,
    #$2C78, #$2C79, #$2C7A, #$2C7B, #$2C7C, #$2C7D, #$023F, #$0240),

    (#$2C81, #$2C81, #$2C83, #$2C83, #$2C85, #$2C85, #$2C87, #$2C87,
    #$2C89, #$2C89, #$2C8B, #$2C8B, #$2C8D, #$2C8D, #$2C8F, #$2C8F,
    #$2C91, #$2C91, #$2C93, #$2C93, #$2C95, #$2C95, #$2C97, #$2C97,
    #$2C99, #$2C99, #$2C9B, #$2C9B, #$2C9D, #$2C9D, #$2C9F, #$2C9F),

    (#$2CA1, #$2CA1, #$2CA3, #$2CA3, #$2CA5, #$2CA5, #$2CA7, #$2CA7,
    #$2CA9, #$2CA9, #$2CAB, #$2CAB, #$2CAD, #$2CAD, #$2CAF, #$2CAF,
    #$2CB1, #$2CB1, #$2CB3, #$2CB3, #$2CB5, #$2CB5, #$2CB7, #$2CB7,
    #$2CB9, #$2CB9, #$2CBB, #$2CBB, #$2CBD, #$2CBD, #$2CBF, #$2CBF),

    (#$2CC1, #$2CC1, #$2CC3, #$2CC3, #$2CC5, #$2CC5, #$2CC7, #$2CC7,
    #$2CC9, #$2CC9, #$2CCB, #$2CCB, #$2CCD, #$2CCD, #$2CCF, #$2CCF,
    #$2CD1, #$2CD1, #$2CD3, #$2CD3, #$2CD5, #$2CD5, #$2CD7, #$2CD7,
    #$2CD9, #$2CD9, #$2CDB, #$2CDB, #$2CDD, #$2CDD, #$2CDF, #$2CDF),

    (#$2CE1, #$2CE1, #$2CE3, #$2CE3, #$2CE4, #$2CE5, #$2CE6, #$2CE7,
    #$2CE8, #$2CE9, #$2CEA, #$2CEC, #$2CEC, #$2CEE, #$2CEE, #$2CEF,
    #$2CF0, #$2CF1, #$2CF3, #$2CF3, #$2CF4, #$2CF5, #$2CF6, #$2CF7,
    #$2CF8, #$2CF9, #$2CFA, #$2CFB, #$2CFC, #$2CFD, #$2CFE, #$2CFF),

    (#$A641, #$A641, #$A643, #$A643, #$A645, #$A645, #$A647, #$A647,
    #$A649, #$A649, #$A64B, #$A64B, #$A64D, #$A64D, #$A64F, #$A64F,
    #$A651, #$A651, #$A653, #$A653, #$A655, #$A655, #$A657, #$A657,
    #$A659, #$A659, #$A65B, #$A65B, #$A65D, #$A65D, #$A65F, #$A65F),

    (#$A661, #$A661, #$A663, #$A663, #$A665, #$A665, #$A667, #$A667,
    #$A669, #$A669, #$A66B, #$A66B, #$A66D, #$A66D, #$A66E, #$A66F,
    #$A670, #$A671, #$A672, #$A673, #$A674, #$A675, #$A676, #$A677,
    #$A678, #$A679, #$A67A, #$A67B, #$A67C, #$A67D, #$A67E, #$A67F),

    (#$A681, #$A681, #$A683, #$A683, #$A685, #$A685, #$A687, #$A687,
    #$A689, #$A689, #$A68B, #$A68B, #$A68D, #$A68D, #$A68F, #$A68F,
    #$A691, #$A691, #$A693, #$A693, #$A695, #$A695, #$A697, #$A697,
    #$A699, #$A699, #$A69B, #$A69B, #$A69C, #$A69D, #$A69E, #$A69F),

    (#$A720, #$A721, #$A723, #$A723, #$A725, #$A725, #$A727, #$A727,
    #$A729, #$A729, #$A72B, #$A72B, #$A72D, #$A72D, #$A72F, #$A72F,
    #$A730, #$A731, #$A733, #$A733, #$A735, #$A735, #$A737, #$A737,
    #$A739, #$A739, #$A73B, #$A73B, #$A73D, #$A73D, #$A73F, #$A73F),

    (#$A741, #$A741, #$A743, #$A743, #$A745, #$A745, #$A747, #$A747,
    #$A749, #$A749, #$A74B, #$A74B, #$A74D, #$A74D, #$A74F, #$A74F,
    #$A751, #$A751, #$A753, #$A753, #$A755, #$A755, #$A757, #$A757,
    #$A759, #$A759, #$A75B, #$A75B, #$A75D, #$A75D, #$A75F, #$A75F),

    (#$A761, #$A761, #$A763, #$A763, #$A765, #$A765, #$A767, #$A767,
    #$A769, #$A769, #$A76B, #$A76B, #$A76D, #$A76D, #$A76F, #$A76F,
    #$A770, #$A771, #$A772, #$A773, #$A774, #$A775, #$A776, #$A777,
    #$A778, #$A77A, #$A77A, #$A77C, #$A77C, #$1D79, #$A77F, #$A77F),

    (#$A781, #$A781, #$A783, #$A783, #$A785, #$A785, #$A787, #$A787,
    #$A788, #$A789, #$A78A, #$A78C, #$A78C, #$0265, #$A78E, #$A78F,
    #$A791, #$A791, #$A793, #$A793, #$A794, #$A795, #$A797, #$A797,
    #$A799, #$A799, #$A79B, #$A79B, #$A79D, #$A79D, #$A79F, #$A79F),

    (#$A7A1, #$A7A1, #$A7A3, #$A7A3, #$A7A5, #$A7A5, #$A7A7, #$A7A7,
    #$A7A9, #$A7A9, #$0266, #$025C, #$0261, #$026C, #$A7AE, #$A7AF,
    #$029E, #$0287, #$A7B2, #$A7B3, #$A7B4, #$A7B5, #$A7B6, #$A7B7,
    #$A7B8, #$A7B9, #$A7BA, #$A7BB, #$A7BC, #$A7BD, #$A7BE, #$A7BF),

    (#$FF20, #$FF41, #$FF42, #$FF43, #$FF44, #$FF45, #$FF46, #$FF47,
    #$FF48, #$FF49, #$FF4A, #$FF4B, #$FF4C, #$FF4D, #$FF4E, #$FF4F,
    #$FF50, #$FF51, #$FF52, #$FF53, #$FF54, #$FF55, #$FF56, #$FF57,
    #$FF58, #$FF59, #$FF5A, #$FF3B, #$FF3C, #$FF3D, #$FF3E, #$FF3F));
  CHAR_TO_LOWER_SIZE = 32;
var
  i: Integer;
begin
  Result := Char;
  if Result < #$41 then Exit;
  if Result > #$FF3A then Exit;
  i := CHAR_TO_LOWER_1[(Ord(Result) - $40) div CHAR_TO_LOWER_SIZE];
  if i <> 0 then
    begin
      Dec(i);
      Result := CHAR_TO_LOWER_2[i, Ord(Result) and (CHAR_TO_LOWER_SIZE - 1)];
    end;
end;

function CharToTitleW(const Char: WideChar): WideChar;
const
  CHAR_TO_TITLE_1: array[$0000..$03FC] of Byte = (
    $01, $02, $03, $04, $05, $06, $07, $08,
    $09, $0A, $00, $00, $0B, $0C, $0D, $0E,
    $0F, $10, $11, $12, $13, $14, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $15, $00, $00, $16,
    $17, $18, $19, $1A, $1B, $1C, $1D, $00,

    $00, $00, $00, $00, $1E, $1F, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $20, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $21,
    $22, $23, $24, $25, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $26, $27, $00, $28, $29, $2A, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $2B);
  CHAR_TO_TITLE_2: array[$0000..$002A, $0000..$003F] of WideChar = (

    (#$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047,
    #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
    #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057,
    #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
    #$0060, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047,
    #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
    #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057,
    #$0058, #$0059, #$005A, #$007B, #$007C, #$007D, #$007E, #$007F),

    (#$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087,
    #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
    #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097,
    #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
    #$00A0, #$00A1, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7,
    #$00A8, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
    #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$039C, #$00B6, #$00B7,
    #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF),

    (#$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7,
    #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
    #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00D7,
    #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$00DF,
    #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7,
    #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
    #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00F7,
    #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$0178),

    (#$0100, #$0100, #$0102, #$0102, #$0104, #$0104, #$0106, #$0106,
    #$0108, #$0108, #$010A, #$010A, #$010C, #$010C, #$010E, #$010E,
    #$0110, #$0110, #$0112, #$0112, #$0114, #$0114, #$0116, #$0116,
    #$0118, #$0118, #$011A, #$011A, #$011C, #$011C, #$011E, #$011E,
    #$0120, #$0120, #$0122, #$0122, #$0124, #$0124, #$0126, #$0126,
    #$0128, #$0128, #$012A, #$012A, #$012C, #$012C, #$012E, #$012E,
    #$0130, #$0049, #$0132, #$0132, #$0134, #$0134, #$0136, #$0136,
    #$0138, #$0139, #$0139, #$013B, #$013B, #$013D, #$013D, #$013F),

    (#$013F, #$0141, #$0141, #$0143, #$0143, #$0145, #$0145, #$0147,
    #$0147, #$0149, #$014A, #$014A, #$014C, #$014C, #$014E, #$014E,
    #$0150, #$0150, #$0152, #$0152, #$0154, #$0154, #$0156, #$0156,
    #$0158, #$0158, #$015A, #$015A, #$015C, #$015C, #$015E, #$015E,
    #$0160, #$0160, #$0162, #$0162, #$0164, #$0164, #$0166, #$0166,
    #$0168, #$0168, #$016A, #$016A, #$016C, #$016C, #$016E, #$016E,
    #$0170, #$0170, #$0172, #$0172, #$0174, #$0174, #$0176, #$0176,
    #$0178, #$0179, #$0179, #$017B, #$017B, #$017D, #$017D, #$0053),

    (#$0243, #$0181, #$0182, #$0182, #$0184, #$0184, #$0186, #$0187,
    #$0187, #$0189, #$018A, #$018B, #$018B, #$018D, #$018E, #$018F,
    #$0190, #$0191, #$0191, #$0193, #$0194, #$01F6, #$0196, #$0197,
    #$0198, #$0198, #$023D, #$019B, #$019C, #$019D, #$0220, #$019F,
    #$01A0, #$01A0, #$01A2, #$01A2, #$01A4, #$01A4, #$01A6, #$01A7,
    #$01A7, #$01A9, #$01AA, #$01AB, #$01AC, #$01AC, #$01AE, #$01AF,
    #$01AF, #$01B1, #$01B2, #$01B3, #$01B3, #$01B5, #$01B5, #$01B7,
    #$01B8, #$01B8, #$01BA, #$01BB, #$01BC, #$01BC, #$01BE, #$01F7),

    (#$01C0, #$01C1, #$01C2, #$01C3, #$01C5, #$01C5, #$01C5, #$01C8,
    #$01C8, #$01C8, #$01CB, #$01CB, #$01CB, #$01CD, #$01CD, #$01CF,
    #$01CF, #$01D1, #$01D1, #$01D3, #$01D3, #$01D5, #$01D5, #$01D7,
    #$01D7, #$01D9, #$01D9, #$01DB, #$01DB, #$018E, #$01DE, #$01DE,
    #$01E0, #$01E0, #$01E2, #$01E2, #$01E4, #$01E4, #$01E6, #$01E6,
    #$01E8, #$01E8, #$01EA, #$01EA, #$01EC, #$01EC, #$01EE, #$01EE,
    #$01F0, #$01F2, #$01F2, #$01F2, #$01F4, #$01F4, #$01F6, #$01F7,
    #$01F8, #$01F8, #$01FA, #$01FA, #$01FC, #$01FC, #$01FE, #$01FE),

    (#$0200, #$0200, #$0202, #$0202, #$0204, #$0204, #$0206, #$0206,
    #$0208, #$0208, #$020A, #$020A, #$020C, #$020C, #$020E, #$020E,
    #$0210, #$0210, #$0212, #$0212, #$0214, #$0214, #$0216, #$0216,
    #$0218, #$0218, #$021A, #$021A, #$021C, #$021C, #$021E, #$021E,
    #$0220, #$0221, #$0222, #$0222, #$0224, #$0224, #$0226, #$0226,
    #$0228, #$0228, #$022A, #$022A, #$022C, #$022C, #$022E, #$022E,
    #$0230, #$0230, #$0232, #$0232, #$0234, #$0235, #$0236, #$0237,
    #$0238, #$0239, #$023A, #$023B, #$023B, #$023D, #$023E, #$2C7E),

    (#$2C7F, #$0241, #$0241, #$0243, #$0244, #$0245, #$0246, #$0246,
    #$0248, #$0248, #$024A, #$024A, #$024C, #$024C, #$024E, #$024E,
    #$2C6F, #$2C6D, #$2C70, #$0181, #$0186, #$0255, #$0189, #$018A,
    #$0258, #$018F, #$025A, #$0190, #$A7AB, #$025D, #$025E, #$025F,
    #$0193, #$A7AC, #$0262, #$0194, #$0264, #$A78D, #$A7AA, #$0267,
    #$0197, #$0196, #$026A, #$2C62, #$A7AD, #$026D, #$026E, #$019C,
    #$0270, #$2C6E, #$019D, #$0273, #$0274, #$019F, #$0276, #$0277,
    #$0278, #$0279, #$027A, #$027B, #$027C, #$2C64, #$027E, #$027F),

    (#$01A6, #$0281, #$0282, #$01A9, #$0284, #$0285, #$0286, #$A7B1,
    #$01AE, #$0244, #$01B1, #$01B2, #$0245, #$028D, #$028E, #$028F,
    #$0290, #$0291, #$01B7, #$0293, #$0294, #$0295, #$0296, #$0297,
    #$0298, #$0299, #$029A, #$029B, #$029C, #$029D, #$A7B0, #$029F,
    #$02A0, #$02A1, #$02A2, #$02A3, #$02A4, #$02A5, #$02A6, #$02A7,
    #$02A8, #$02A9, #$02AA, #$02AB, #$02AC, #$02AD, #$02AE, #$02AF,
    #$02B0, #$02B1, #$02B2, #$02B3, #$02B4, #$02B5, #$02B6, #$02B7,
    #$02B8, #$02B9, #$02BA, #$02BB, #$02BC, #$02BD, #$02BE, #$02BF),

    (#$0340, #$0341, #$0342, #$0343, #$0344, #$0399, #$0346, #$0347,
    #$0348, #$0349, #$034A, #$034B, #$034C, #$034D, #$034E, #$034F,
    #$0350, #$0351, #$0352, #$0353, #$0354, #$0355, #$0356, #$0357,
    #$0358, #$0359, #$035A, #$035B, #$035C, #$035D, #$035E, #$035F,
    #$0360, #$0361, #$0362, #$0363, #$0364, #$0365, #$0366, #$0367,
    #$0368, #$0369, #$036A, #$036B, #$036C, #$036D, #$036E, #$036F,
    #$0370, #$0370, #$0372, #$0372, #$0374, #$0375, #$0376, #$0376,
    #$0378, #$0379, #$037A, #$03FD, #$03FE, #$03FF, #$037E, #$037F),

    (#$0380, #$0381, #$0382, #$0383, #$0384, #$0385, #$0386, #$0387,
    #$0388, #$0389, #$038A, #$038B, #$038C, #$038D, #$038E, #$038F,
    #$0390, #$0391, #$0392, #$0393, #$0394, #$0395, #$0396, #$0397,
    #$0398, #$0399, #$039A, #$039B, #$039C, #$039D, #$039E, #$039F,
    #$03A0, #$03A1, #$03A2, #$03A3, #$03A4, #$03A5, #$03A6, #$03A7,
    #$03A8, #$03A9, #$03AA, #$03AB, #$0386, #$0388, #$0389, #$038A,
    #$03B0, #$0391, #$0392, #$0393, #$0394, #$0395, #$0396, #$0397,
    #$0398, #$0399, #$039A, #$039B, #$039C, #$039D, #$039E, #$039F),

    (#$03A0, #$03A1, #$03A3, #$03A3, #$03A4, #$03A5, #$03A6, #$03A7,
    #$03A8, #$03A9, #$03AA, #$03AB, #$038C, #$038E, #$038F, #$03CF,
    #$0392, #$0398, #$03D2, #$03D3, #$03D4, #$03A6, #$03A0, #$03CF,
    #$03D8, #$03D8, #$03DA, #$03DA, #$03DC, #$03DC, #$03DE, #$03DE,
    #$03E0, #$03E0, #$03E2, #$03E2, #$03E4, #$03E4, #$03E6, #$03E6,
    #$03E8, #$03E8, #$03EA, #$03EA, #$03EC, #$03EC, #$03EE, #$03EE,
    #$039A, #$03A1, #$03F9, #$037F, #$03F4, #$0395, #$03F6, #$03F7,
    #$03F7, #$03F9, #$03FA, #$03FA, #$03FC, #$03FD, #$03FE, #$03FF),

    (#$0400, #$0401, #$0402, #$0403, #$0404, #$0405, #$0406, #$0407,
    #$0408, #$0409, #$040A, #$040B, #$040C, #$040D, #$040E, #$040F,
    #$0410, #$0411, #$0412, #$0413, #$0414, #$0415, #$0416, #$0417,
    #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E, #$041F,
    #$0420, #$0421, #$0422, #$0423, #$0424, #$0425, #$0426, #$0427,
    #$0428, #$0429, #$042A, #$042B, #$042C, #$042D, #$042E, #$042F,
    #$0410, #$0411, #$0412, #$0413, #$0414, #$0415, #$0416, #$0417,
    #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E, #$041F),

    (#$0420, #$0421, #$0422, #$0423, #$0424, #$0425, #$0426, #$0427,
    #$0428, #$0429, #$042A, #$042B, #$042C, #$042D, #$042E, #$042F,
    #$0400, #$0401, #$0402, #$0403, #$0404, #$0405, #$0406, #$0407,
    #$0408, #$0409, #$040A, #$040B, #$040C, #$040D, #$040E, #$040F,
    #$0460, #$0460, #$0462, #$0462, #$0464, #$0464, #$0466, #$0466,
    #$0468, #$0468, #$046A, #$046A, #$046C, #$046C, #$046E, #$046E,
    #$0470, #$0470, #$0472, #$0472, #$0474, #$0474, #$0476, #$0476,
    #$0478, #$0478, #$047A, #$047A, #$047C, #$047C, #$047E, #$047E),

    (#$0480, #$0480, #$0482, #$0483, #$0484, #$0485, #$0486, #$0487,
    #$0488, #$0489, #$048A, #$048A, #$048C, #$048C, #$048E, #$048E,
    #$0490, #$0490, #$0492, #$0492, #$0494, #$0494, #$0496, #$0496,
    #$0498, #$0498, #$049A, #$049A, #$049C, #$049C, #$049E, #$049E,
    #$04A0, #$04A0, #$04A2, #$04A2, #$04A4, #$04A4, #$04A6, #$04A6,
    #$04A8, #$04A8, #$04AA, #$04AA, #$04AC, #$04AC, #$04AE, #$04AE,
    #$04B0, #$04B0, #$04B2, #$04B2, #$04B4, #$04B4, #$04B6, #$04B6,
    #$04B8, #$04B8, #$04BA, #$04BA, #$04BC, #$04BC, #$04BE, #$04BE),

    (#$04C0, #$04C1, #$04C1, #$04C3, #$04C3, #$04C5, #$04C5, #$04C7,
    #$04C7, #$04C9, #$04C9, #$04CB, #$04CB, #$04CD, #$04CD, #$04C0,
    #$04D0, #$04D0, #$04D2, #$04D2, #$04D4, #$04D4, #$04D6, #$04D6,
    #$04D8, #$04D8, #$04DA, #$04DA, #$04DC, #$04DC, #$04DE, #$04DE,
    #$04E0, #$04E0, #$04E2, #$04E2, #$04E4, #$04E4, #$04E6, #$04E6,
    #$04E8, #$04E8, #$04EA, #$04EA, #$04EC, #$04EC, #$04EE, #$04EE,
    #$04F0, #$04F0, #$04F2, #$04F2, #$04F4, #$04F4, #$04F6, #$04F6,
    #$04F8, #$04F8, #$04FA, #$04FA, #$04FC, #$04FC, #$04FE, #$04FE),

    (#$0500, #$0500, #$0502, #$0502, #$0504, #$0504, #$0506, #$0506,
    #$0508, #$0508, #$050A, #$050A, #$050C, #$050C, #$050E, #$050E,
    #$0510, #$0510, #$0512, #$0512, #$0514, #$0514, #$0516, #$0516,
    #$0518, #$0518, #$051A, #$051A, #$051C, #$051C, #$051E, #$051E,
    #$0520, #$0520, #$0522, #$0522, #$0524, #$0524, #$0526, #$0526,
    #$0528, #$0528, #$052A, #$052A, #$052C, #$052C, #$052E, #$052E,
    #$0530, #$0531, #$0532, #$0533, #$0534, #$0535, #$0536, #$0537,
    #$0538, #$0539, #$053A, #$053B, #$053C, #$053D, #$053E, #$053F),

    (#$0540, #$0541, #$0542, #$0543, #$0544, #$0545, #$0546, #$0547,
    #$0548, #$0549, #$054A, #$054B, #$054C, #$054D, #$054E, #$054F,
    #$0550, #$0551, #$0552, #$0553, #$0554, #$0555, #$0556, #$0557,
    #$0558, #$0559, #$055A, #$055B, #$055C, #$055D, #$055E, #$055F,
    #$0560, #$0531, #$0532, #$0533, #$0534, #$0535, #$0536, #$0537,
    #$0538, #$0539, #$053A, #$053B, #$053C, #$053D, #$053E, #$053F,
    #$0540, #$0541, #$0542, #$0543, #$0544, #$0545, #$0546, #$0547,
    #$0548, #$0549, #$054A, #$054B, #$054C, #$054D, #$054E, #$054F),

    (#$0550, #$0551, #$0552, #$0553, #$0554, #$0555, #$0556, #$0587,
    #$0588, #$0589, #$058A, #$058B, #$058C, #$058D, #$058E, #$058F,
    #$0590, #$0591, #$0592, #$0593, #$0594, #$0595, #$0596, #$0597,
    #$0598, #$0599, #$059A, #$059B, #$059C, #$059D, #$059E, #$059F,
    #$05A0, #$05A1, #$05A2, #$05A3, #$05A4, #$05A5, #$05A6, #$05A7,
    #$05A8, #$05A9, #$05AA, #$05AB, #$05AC, #$05AD, #$05AE, #$05AF,
    #$05B0, #$05B1, #$05B2, #$05B3, #$05B4, #$05B5, #$05B6, #$05B7,
    #$05B8, #$05B9, #$05BA, #$05BB, #$05BC, #$05BD, #$05BE, #$05BF),

    (#$1D40, #$1D41, #$1D42, #$1D43, #$1D44, #$1D45, #$1D46, #$1D47,
    #$1D48, #$1D49, #$1D4A, #$1D4B, #$1D4C, #$1D4D, #$1D4E, #$1D4F,
    #$1D50, #$1D51, #$1D52, #$1D53, #$1D54, #$1D55, #$1D56, #$1D57,
    #$1D58, #$1D59, #$1D5A, #$1D5B, #$1D5C, #$1D5D, #$1D5E, #$1D5F,
    #$1D60, #$1D61, #$1D62, #$1D63, #$1D64, #$1D65, #$1D66, #$1D67,
    #$1D68, #$1D69, #$1D6A, #$1D6B, #$1D6C, #$1D6D, #$1D6E, #$1D6F,
    #$1D70, #$1D71, #$1D72, #$1D73, #$1D74, #$1D75, #$1D76, #$1D77,
    #$1D78, #$A77D, #$1D7A, #$1D7B, #$1D7C, #$2C63, #$1D7E, #$1D7F),

    (#$1E00, #$1E00, #$1E02, #$1E02, #$1E04, #$1E04, #$1E06, #$1E06,
    #$1E08, #$1E08, #$1E0A, #$1E0A, #$1E0C, #$1E0C, #$1E0E, #$1E0E,
    #$1E10, #$1E10, #$1E12, #$1E12, #$1E14, #$1E14, #$1E16, #$1E16,
    #$1E18, #$1E18, #$1E1A, #$1E1A, #$1E1C, #$1E1C, #$1E1E, #$1E1E,
    #$1E20, #$1E20, #$1E22, #$1E22, #$1E24, #$1E24, #$1E26, #$1E26,
    #$1E28, #$1E28, #$1E2A, #$1E2A, #$1E2C, #$1E2C, #$1E2E, #$1E2E,
    #$1E30, #$1E30, #$1E32, #$1E32, #$1E34, #$1E34, #$1E36, #$1E36,
    #$1E38, #$1E38, #$1E3A, #$1E3A, #$1E3C, #$1E3C, #$1E3E, #$1E3E),

    (#$1E40, #$1E40, #$1E42, #$1E42, #$1E44, #$1E44, #$1E46, #$1E46,
    #$1E48, #$1E48, #$1E4A, #$1E4A, #$1E4C, #$1E4C, #$1E4E, #$1E4E,
    #$1E50, #$1E50, #$1E52, #$1E52, #$1E54, #$1E54, #$1E56, #$1E56,
    #$1E58, #$1E58, #$1E5A, #$1E5A, #$1E5C, #$1E5C, #$1E5E, #$1E5E,
    #$1E60, #$1E60, #$1E62, #$1E62, #$1E64, #$1E64, #$1E66, #$1E66,
    #$1E68, #$1E68, #$1E6A, #$1E6A, #$1E6C, #$1E6C, #$1E6E, #$1E6E,
    #$1E70, #$1E70, #$1E72, #$1E72, #$1E74, #$1E74, #$1E76, #$1E76,
    #$1E78, #$1E78, #$1E7A, #$1E7A, #$1E7C, #$1E7C, #$1E7E, #$1E7E),

    (#$1E80, #$1E80, #$1E82, #$1E82, #$1E84, #$1E84, #$1E86, #$1E86,
    #$1E88, #$1E88, #$1E8A, #$1E8A, #$1E8C, #$1E8C, #$1E8E, #$1E8E,
    #$1E90, #$1E90, #$1E92, #$1E92, #$1E94, #$1E94, #$1E96, #$1E97,
    #$1E98, #$1E99, #$1E9A, #$1E60, #$1E9C, #$1E9D, #$1E9E, #$1E9F,
    #$1EA0, #$1EA0, #$1EA2, #$1EA2, #$1EA4, #$1EA4, #$1EA6, #$1EA6,
    #$1EA8, #$1EA8, #$1EAA, #$1EAA, #$1EAC, #$1EAC, #$1EAE, #$1EAE,
    #$1EB0, #$1EB0, #$1EB2, #$1EB2, #$1EB4, #$1EB4, #$1EB6, #$1EB6,
    #$1EB8, #$1EB8, #$1EBA, #$1EBA, #$1EBC, #$1EBC, #$1EBE, #$1EBE),

    (#$1EC0, #$1EC0, #$1EC2, #$1EC2, #$1EC4, #$1EC4, #$1EC6, #$1EC6,
    #$1EC8, #$1EC8, #$1ECA, #$1ECA, #$1ECC, #$1ECC, #$1ECE, #$1ECE,
    #$1ED0, #$1ED0, #$1ED2, #$1ED2, #$1ED4, #$1ED4, #$1ED6, #$1ED6,
    #$1ED8, #$1ED8, #$1EDA, #$1EDA, #$1EDC, #$1EDC, #$1EDE, #$1EDE,
    #$1EE0, #$1EE0, #$1EE2, #$1EE2, #$1EE4, #$1EE4, #$1EE6, #$1EE6,
    #$1EE8, #$1EE8, #$1EEA, #$1EEA, #$1EEC, #$1EEC, #$1EEE, #$1EEE,
    #$1EF0, #$1EF0, #$1EF2, #$1EF2, #$1EF4, #$1EF4, #$1EF6, #$1EF6,
    #$1EF8, #$1EF8, #$1EFA, #$1EFA, #$1EFC, #$1EFC, #$1EFE, #$1EFE),

    (#$1F08, #$1F09, #$1F0A, #$1F0B, #$1F0C, #$1F0D, #$1F0E, #$1F0F,
    #$1F08, #$1F09, #$1F0A, #$1F0B, #$1F0C, #$1F0D, #$1F0E, #$1F0F,
    #$1F18, #$1F19, #$1F1A, #$1F1B, #$1F1C, #$1F1D, #$1F16, #$1F17,
    #$1F18, #$1F19, #$1F1A, #$1F1B, #$1F1C, #$1F1D, #$1F1E, #$1F1F,
    #$1F28, #$1F29, #$1F2A, #$1F2B, #$1F2C, #$1F2D, #$1F2E, #$1F2F,
    #$1F28, #$1F29, #$1F2A, #$1F2B, #$1F2C, #$1F2D, #$1F2E, #$1F2F,
    #$1F38, #$1F39, #$1F3A, #$1F3B, #$1F3C, #$1F3D, #$1F3E, #$1F3F,
    #$1F38, #$1F39, #$1F3A, #$1F3B, #$1F3C, #$1F3D, #$1F3E, #$1F3F),

    (#$1F48, #$1F49, #$1F4A, #$1F4B, #$1F4C, #$1F4D, #$1F46, #$1F47,
    #$1F48, #$1F49, #$1F4A, #$1F4B, #$1F4C, #$1F4D, #$1F4E, #$1F4F,
    #$1F50, #$1F59, #$1F52, #$1F5B, #$1F54, #$1F5D, #$1F56, #$1F5F,
    #$1F58, #$1F59, #$1F5A, #$1F5B, #$1F5C, #$1F5D, #$1F5E, #$1F5F,
    #$1F68, #$1F69, #$1F6A, #$1F6B, #$1F6C, #$1F6D, #$1F6E, #$1F6F,
    #$1F68, #$1F69, #$1F6A, #$1F6B, #$1F6C, #$1F6D, #$1F6E, #$1F6F,
    #$1FBA, #$1FBB, #$1FC8, #$1FC9, #$1FCA, #$1FCB, #$1FDA, #$1FDB,
    #$1FF8, #$1FF9, #$1FEA, #$1FEB, #$1FFA, #$1FFB, #$1F7E, #$1F7F),

    (#$1F88, #$1F89, #$1F8A, #$1F8B, #$1F8C, #$1F8D, #$1F8E, #$1F8F,
    #$1F88, #$1F89, #$1F8A, #$1F8B, #$1F8C, #$1F8D, #$1F8E, #$1F8F,
    #$1F98, #$1F99, #$1F9A, #$1F9B, #$1F9C, #$1F9D, #$1F9E, #$1F9F,
    #$1F98, #$1F99, #$1F9A, #$1F9B, #$1F9C, #$1F9D, #$1F9E, #$1F9F,
    #$1FA8, #$1FA9, #$1FAA, #$1FAB, #$1FAC, #$1FAD, #$1FAE, #$1FAF,
    #$1FA8, #$1FA9, #$1FAA, #$1FAB, #$1FAC, #$1FAD, #$1FAE, #$1FAF,
    #$1FB8, #$1FB9, #$1FB2, #$1FBC, #$1FB4, #$1FB5, #$1FB6, #$1FB7,
    #$1FB8, #$1FB9, #$1FBA, #$1FBB, #$1FBC, #$1FBD, #$0399, #$1FBF),

    (#$1FC0, #$1FC1, #$1FC2, #$1FCC, #$1FC4, #$1FC5, #$1FC6, #$1FC7,
    #$1FC8, #$1FC9, #$1FCA, #$1FCB, #$1FCC, #$1FCD, #$1FCE, #$1FCF,
    #$1FD8, #$1FD9, #$1FD2, #$1FD3, #$1FD4, #$1FD5, #$1FD6, #$1FD7,
    #$1FD8, #$1FD9, #$1FDA, #$1FDB, #$1FDC, #$1FDD, #$1FDE, #$1FDF,
    #$1FE8, #$1FE9, #$1FE2, #$1FE3, #$1FE4, #$1FEC, #$1FE6, #$1FE7,
    #$1FE8, #$1FE9, #$1FEA, #$1FEB, #$1FEC, #$1FED, #$1FEE, #$1FEF,
    #$1FF0, #$1FF1, #$1FF2, #$1FFC, #$1FF4, #$1FF5, #$1FF6, #$1FF7,
    #$1FF8, #$1FF9, #$1FFA, #$1FFB, #$1FFC, #$1FFD, #$1FFE, #$1FFF),

    (#$2140, #$2141, #$2142, #$2143, #$2144, #$2145, #$2146, #$2147,
    #$2148, #$2149, #$214A, #$214B, #$214C, #$214D, #$2132, #$214F,
    #$2150, #$2151, #$2152, #$2153, #$2154, #$2155, #$2156, #$2157,
    #$2158, #$2159, #$215A, #$215B, #$215C, #$215D, #$215E, #$215F,
    #$2160, #$2161, #$2162, #$2163, #$2164, #$2165, #$2166, #$2167,
    #$2168, #$2169, #$216A, #$216B, #$216C, #$216D, #$216E, #$216F,
    #$2160, #$2161, #$2162, #$2163, #$2164, #$2165, #$2166, #$2167,
    #$2168, #$2169, #$216A, #$216B, #$216C, #$216D, #$216E, #$216F),

    (#$2180, #$2181, #$2182, #$2183, #$2183, #$2185, #$2186, #$2187,
    #$2188, #$2189, #$218A, #$218B, #$218C, #$218D, #$218E, #$218F,
    #$2190, #$2191, #$2192, #$2193, #$2194, #$2195, #$2196, #$2197,
    #$2198, #$2199, #$219A, #$219B, #$219C, #$219D, #$219E, #$219F,
    #$21A0, #$21A1, #$21A2, #$21A3, #$21A4, #$21A5, #$21A6, #$21A7,
    #$21A8, #$21A9, #$21AA, #$21AB, #$21AC, #$21AD, #$21AE, #$21AF,
    #$21B0, #$21B1, #$21B2, #$21B3, #$21B4, #$21B5, #$21B6, #$21B7,
    #$21B8, #$21B9, #$21BA, #$21BB, #$21BC, #$21BD, #$21BE, #$21BF),

    (#$24C0, #$24C1, #$24C2, #$24C3, #$24C4, #$24C5, #$24C6, #$24C7,
    #$24C8, #$24C9, #$24CA, #$24CB, #$24CC, #$24CD, #$24CE, #$24CF,
    #$24B6, #$24B7, #$24B8, #$24B9, #$24BA, #$24BB, #$24BC, #$24BD,
    #$24BE, #$24BF, #$24C0, #$24C1, #$24C2, #$24C3, #$24C4, #$24C5,
    #$24C6, #$24C7, #$24C8, #$24C9, #$24CA, #$24CB, #$24CC, #$24CD,
    #$24CE, #$24CF, #$24EA, #$24EB, #$24EC, #$24ED, #$24EE, #$24EF,
    #$24F0, #$24F1, #$24F2, #$24F3, #$24F4, #$24F5, #$24F6, #$24F7,
    #$24F8, #$24F9, #$24FA, #$24FB, #$24FC, #$24FD, #$24FE, #$24FF),

    (#$2C00, #$2C01, #$2C02, #$2C03, #$2C04, #$2C05, #$2C06, #$2C07,
    #$2C08, #$2C09, #$2C0A, #$2C0B, #$2C0C, #$2C0D, #$2C0E, #$2C0F,
    #$2C10, #$2C11, #$2C12, #$2C13, #$2C14, #$2C15, #$2C16, #$2C17,
    #$2C18, #$2C19, #$2C1A, #$2C1B, #$2C1C, #$2C1D, #$2C1E, #$2C1F,
    #$2C20, #$2C21, #$2C22, #$2C23, #$2C24, #$2C25, #$2C26, #$2C27,
    #$2C28, #$2C29, #$2C2A, #$2C2B, #$2C2C, #$2C2D, #$2C2E, #$2C2F,
    #$2C00, #$2C01, #$2C02, #$2C03, #$2C04, #$2C05, #$2C06, #$2C07,
    #$2C08, #$2C09, #$2C0A, #$2C0B, #$2C0C, #$2C0D, #$2C0E, #$2C0F),

    (#$2C10, #$2C11, #$2C12, #$2C13, #$2C14, #$2C15, #$2C16, #$2C17,
    #$2C18, #$2C19, #$2C1A, #$2C1B, #$2C1C, #$2C1D, #$2C1E, #$2C1F,
    #$2C20, #$2C21, #$2C22, #$2C23, #$2C24, #$2C25, #$2C26, #$2C27,
    #$2C28, #$2C29, #$2C2A, #$2C2B, #$2C2C, #$2C2D, #$2C2E, #$2C5F,
    #$2C60, #$2C60, #$2C62, #$2C63, #$2C64, #$023A, #$023E, #$2C67,
    #$2C67, #$2C69, #$2C69, #$2C6B, #$2C6B, #$2C6D, #$2C6E, #$2C6F,
    #$2C70, #$2C71, #$2C72, #$2C72, #$2C74, #$2C75, #$2C75, #$2C77,
    #$2C78, #$2C79, #$2C7A, #$2C7B, #$2C7C, #$2C7D, #$2C7E, #$2C7F),

    (#$2C80, #$2C80, #$2C82, #$2C82, #$2C84, #$2C84, #$2C86, #$2C86,
    #$2C88, #$2C88, #$2C8A, #$2C8A, #$2C8C, #$2C8C, #$2C8E, #$2C8E,
    #$2C90, #$2C90, #$2C92, #$2C92, #$2C94, #$2C94, #$2C96, #$2C96,
    #$2C98, #$2C98, #$2C9A, #$2C9A, #$2C9C, #$2C9C, #$2C9E, #$2C9E,
    #$2CA0, #$2CA0, #$2CA2, #$2CA2, #$2CA4, #$2CA4, #$2CA6, #$2CA6,
    #$2CA8, #$2CA8, #$2CAA, #$2CAA, #$2CAC, #$2CAC, #$2CAE, #$2CAE,
    #$2CB0, #$2CB0, #$2CB2, #$2CB2, #$2CB4, #$2CB4, #$2CB6, #$2CB6,
    #$2CB8, #$2CB8, #$2CBA, #$2CBA, #$2CBC, #$2CBC, #$2CBE, #$2CBE),

    (#$2CC0, #$2CC0, #$2CC2, #$2CC2, #$2CC4, #$2CC4, #$2CC6, #$2CC6,
    #$2CC8, #$2CC8, #$2CCA, #$2CCA, #$2CCC, #$2CCC, #$2CCE, #$2CCE,
    #$2CD0, #$2CD0, #$2CD2, #$2CD2, #$2CD4, #$2CD4, #$2CD6, #$2CD6,
    #$2CD8, #$2CD8, #$2CDA, #$2CDA, #$2CDC, #$2CDC, #$2CDE, #$2CDE,
    #$2CE0, #$2CE0, #$2CE2, #$2CE2, #$2CE4, #$2CE5, #$2CE6, #$2CE7,
    #$2CE8, #$2CE9, #$2CEA, #$2CEB, #$2CEB, #$2CED, #$2CED, #$2CEF,
    #$2CF0, #$2CF1, #$2CF2, #$2CF2, #$2CF4, #$2CF5, #$2CF6, #$2CF7,
    #$2CF8, #$2CF9, #$2CFA, #$2CFB, #$2CFC, #$2CFD, #$2CFE, #$2CFF),

    (#$10A0, #$10A1, #$10A2, #$10A3, #$10A4, #$10A5, #$10A6, #$10A7,
    #$10A8, #$10A9, #$10AA, #$10AB, #$10AC, #$10AD, #$10AE, #$10AF,
    #$10B0, #$10B1, #$10B2, #$10B3, #$10B4, #$10B5, #$10B6, #$10B7,
    #$10B8, #$10B9, #$10BA, #$10BB, #$10BC, #$10BD, #$10BE, #$10BF,
    #$10C0, #$10C1, #$10C2, #$10C3, #$10C4, #$10C5, #$2D26, #$10C7,
    #$2D28, #$2D29, #$2D2A, #$2D2B, #$2D2C, #$10CD, #$2D2E, #$2D2F,
    #$2D30, #$2D31, #$2D32, #$2D33, #$2D34, #$2D35, #$2D36, #$2D37,
    #$2D38, #$2D39, #$2D3A, #$2D3B, #$2D3C, #$2D3D, #$2D3E, #$2D3F),

    (#$A640, #$A640, #$A642, #$A642, #$A644, #$A644, #$A646, #$A646,
    #$A648, #$A648, #$A64A, #$A64A, #$A64C, #$A64C, #$A64E, #$A64E,
    #$A650, #$A650, #$A652, #$A652, #$A654, #$A654, #$A656, #$A656,
    #$A658, #$A658, #$A65A, #$A65A, #$A65C, #$A65C, #$A65E, #$A65E,
    #$A660, #$A660, #$A662, #$A662, #$A664, #$A664, #$A666, #$A666,
    #$A668, #$A668, #$A66A, #$A66A, #$A66C, #$A66C, #$A66E, #$A66F,
    #$A670, #$A671, #$A672, #$A673, #$A674, #$A675, #$A676, #$A677,
    #$A678, #$A679, #$A67A, #$A67B, #$A67C, #$A67D, #$A67E, #$A67F),

    (#$A680, #$A680, #$A682, #$A682, #$A684, #$A684, #$A686, #$A686,
    #$A688, #$A688, #$A68A, #$A68A, #$A68C, #$A68C, #$A68E, #$A68E,
    #$A690, #$A690, #$A692, #$A692, #$A694, #$A694, #$A696, #$A696,
    #$A698, #$A698, #$A69A, #$A69A, #$A69C, #$A69D, #$A69E, #$A69F,
    #$A6A0, #$A6A1, #$A6A2, #$A6A3, #$A6A4, #$A6A5, #$A6A6, #$A6A7,
    #$A6A8, #$A6A9, #$A6AA, #$A6AB, #$A6AC, #$A6AD, #$A6AE, #$A6AF,
    #$A6B0, #$A6B1, #$A6B2, #$A6B3, #$A6B4, #$A6B5, #$A6B6, #$A6B7,
    #$A6B8, #$A6B9, #$A6BA, #$A6BB, #$A6BC, #$A6BD, #$A6BE, #$A6BF),

    (#$A700, #$A701, #$A702, #$A703, #$A704, #$A705, #$A706, #$A707,
    #$A708, #$A709, #$A70A, #$A70B, #$A70C, #$A70D, #$A70E, #$A70F,
    #$A710, #$A711, #$A712, #$A713, #$A714, #$A715, #$A716, #$A717,
    #$A718, #$A719, #$A71A, #$A71B, #$A71C, #$A71D, #$A71E, #$A71F,
    #$A720, #$A721, #$A722, #$A722, #$A724, #$A724, #$A726, #$A726,
    #$A728, #$A728, #$A72A, #$A72A, #$A72C, #$A72C, #$A72E, #$A72E,
    #$A730, #$A731, #$A732, #$A732, #$A734, #$A734, #$A736, #$A736,
    #$A738, #$A738, #$A73A, #$A73A, #$A73C, #$A73C, #$A73E, #$A73E),

    (#$A740, #$A740, #$A742, #$A742, #$A744, #$A744, #$A746, #$A746,
    #$A748, #$A748, #$A74A, #$A74A, #$A74C, #$A74C, #$A74E, #$A74E,
    #$A750, #$A750, #$A752, #$A752, #$A754, #$A754, #$A756, #$A756,
    #$A758, #$A758, #$A75A, #$A75A, #$A75C, #$A75C, #$A75E, #$A75E,
    #$A760, #$A760, #$A762, #$A762, #$A764, #$A764, #$A766, #$A766,
    #$A768, #$A768, #$A76A, #$A76A, #$A76C, #$A76C, #$A76E, #$A76E,
    #$A770, #$A771, #$A772, #$A773, #$A774, #$A775, #$A776, #$A777,
    #$A778, #$A779, #$A779, #$A77B, #$A77B, #$A77D, #$A77E, #$A77E),

    (#$A780, #$A780, #$A782, #$A782, #$A784, #$A784, #$A786, #$A786,
    #$A788, #$A789, #$A78A, #$A78B, #$A78B, #$A78D, #$A78E, #$A78F,
    #$A790, #$A790, #$A792, #$A792, #$A794, #$A795, #$A796, #$A796,
    #$A798, #$A798, #$A79A, #$A79A, #$A79C, #$A79C, #$A79E, #$A79E,
    #$A7A0, #$A7A0, #$A7A2, #$A7A2, #$A7A4, #$A7A4, #$A7A6, #$A7A6,
    #$A7A8, #$A7A8, #$A7AA, #$A7AB, #$A7AC, #$A7AD, #$A7AE, #$A7AF,
    #$A7B0, #$A7B1, #$A7B2, #$A7B3, #$A7B4, #$A7B5, #$A7B6, #$A7B7,
    #$A7B8, #$A7B9, #$A7BA, #$A7BB, #$A7BC, #$A7BD, #$A7BE, #$A7BF),

    (#$FF40, #$FF21, #$FF22, #$FF23, #$FF24, #$FF25, #$FF26, #$FF27,
    #$FF28, #$FF29, #$FF2A, #$FF2B, #$FF2C, #$FF2D, #$FF2E, #$FF2F,
    #$FF30, #$FF31, #$FF32, #$FF33, #$FF34, #$FF35, #$FF36, #$FF37,
    #$FF38, #$FF39, #$FF3A, #$FF5B, #$FF5C, #$FF5D, #$FF5E, #$FF5F,
    #$FF60, #$FF61, #$FF62, #$FF63, #$FF64, #$FF65, #$FF66, #$FF67,
    #$FF68, #$FF69, #$FF6A, #$FF6B, #$FF6C, #$FF6D, #$FF6E, #$FF6F,
    #$FF70, #$FF71, #$FF72, #$FF73, #$FF74, #$FF75, #$FF76, #$FF77,
    #$FF78, #$FF79, #$FF7A, #$FF7B, #$FF7C, #$FF7D, #$FF7E, #$FF7F));
  CHAR_TO_TITLE_SIZE = 64;
var
  i: Integer;
begin
  Result := Char;
  if Result < #$61 then Exit;
  if Result > #$FF5A then Exit;
  i := CHAR_TO_TITLE_1[(Ord(Result) - $40) div CHAR_TO_TITLE_SIZE];
  if i <> 0 then
    begin
      Dec(i);
      Result := CHAR_TO_TITLE_2[i, Ord(Result) and (CHAR_TO_TITLE_SIZE - 1)];
    end;
end;

{$IFDEF CLR}

{$ELSE CLR}

function CharDecomposeCanonicalW(const c: WideChar): PCharDecompositionW;
const
  CHAR_CANONICAL_DECOMPOSITION_1: array[$0000..$07D4] of Byte = (
    $01, $02, $03, $04, $05, $06, $00, $07,
    $08, $09, $0A, $0B, $00, $00, $00, $00,
    $00, $00, $00, $00, $0C, $0D, $0E, $0F,
    $10, $00, $11, $12, $13, $14, $00, $00,
    $15, $16, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $17, $00, $00, $00, $00,
    $18, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $19, $1A, $00, $00, $00,
    $1B, $00, $00, $1C, $1D, $00, $00, $00,
    $00, $00, $00, $00, $1E, $00, $1F, $00,
    $20, $00, $00, $00, $21, $00, $00, $00,
    $22, $00, $00, $00, $23, $00, $00, $00,
    $24, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $25, $26, $27, $28,
    $00, $00, $00, $29, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $2A, $2B, $2C, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $2D, $2E, $2F, $30, $31, $32,
    $33, $34, $35, $36, $37, $38, $39, $3A,
    $3B, $3C, $3D, $00, $00, $00, $00, $00,

    $00, $00, $00, $3E, $00, $00, $3F, $40,
    $41, $00, $42, $43, $44, $45, $46, $47,
    $00, $48, $00, $49, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $4A, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $4B, $4C, $4D, $4E,

    $4F, $50, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $51, $52, $53, $54, $55, $56,
    $57, $58, $59, $5A, $5B, $5C, $5D, $5E,
    $5F, $00, $60, $61, $62);
  CHAR_CANONICAL_DECOMPOSITION_2: array[$0000..$0061, $0000..$001F] of Word = (

    ($0001, $0006, $000B, $0010, $0015, $001A, $0000, $001F,
    $0024, $0029, $002E, $0033, $0038, $003D, $0042, $0047,
    $0000, $004C, $0051, $0056, $005B, $0060, $0065, $0000,
    $0000, $006A, $006F, $0074, $0079, $007E, $0000, $0000),

    ($0083, $0088, $008D, $0092, $0097, $009C, $0000, $00A1,
    $00A6, $00AB, $00B0, $00B5, $00BA, $00BF, $00C4, $00C9,
    $0000, $00CE, $00D3, $00D8, $00DD, $00E2, $00E7, $0000,
    $0000, $00EC, $00F1, $00F6, $00FB, $0100, $0000, $0105),

    ($010A, $010F, $0114, $0119, $011E, $0123, $0128, $012D,
    $0132, $0137, $013C, $0141, $0146, $014B, $0150, $0155,
    $0000, $0000, $015A, $015F, $0164, $0169, $016E, $0173,
    $0178, $017D, $0182, $0187, $018C, $0191, $0196, $019B),

    ($01A0, $01A5, $01AA, $01AF, $01B4, $01B9, $0000, $0000,
    $01BE, $01C3, $01C8, $01CD, $01D2, $01D7, $01DC, $01E1,
    $01E6, $0000, $0000, $0000, $01EB, $01F0, $01F5, $01FA,
    $0000, $01FF, $0204, $0209, $020E, $0213, $0218, $0000),

    ($0000, $0000, $0000, $021D, $0222, $0227, $022C, $0231,
    $0236, $0000, $0000, $0000, $023B, $0240, $0245, $024A,
    $024F, $0254, $0000, $0000, $0259, $025E, $0263, $0268,
    $026D, $0272, $0277, $027C, $0281, $0286, $028B, $0290),

    ($0295, $029A, $029F, $02A4, $02A9, $02AE, $0000, $0000,
    $02B3, $02B8, $02BD, $02C2, $02C7, $02CC, $02D1, $02D6,
    $02DB, $02E0, $02E5, $02EA, $02EF, $02F4, $02F9, $02FE,
    $0303, $0308, $030D, $0312, $0317, $031C, $0321, $0000),

    ($0326, $032B, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0330,
    $0335, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $033A, $033F, $0344,
    $0349, $034E, $0353, $0358, $035D, $0362, $0369, $0370,
    $0377, $037E, $0385, $038C, $0393, $0000, $039A, $03A1),

    ($03A8, $03AF, $03B6, $03BB, $0000, $0000, $03C0, $03C5,
    $03CA, $03CF, $03D4, $03D9, $03DE, $03E5, $03EC, $03F1,
    $03F6, $0000, $0000, $0000, $03FB, $0400, $0000, $0000,
    $0405, $040A, $040F, $0416, $041D, $0422, $0427, $042C),

    ($0431, $0436, $043B, $0440, $0445, $044A, $044F, $0454,
    $0459, $045E, $0463, $0468, $046D, $0472, $0477, $047C,
    $0481, $0486, $048B, $0490, $0495, $049A, $049F, $04A4,
    $04A9, $04AE, $04B3, $04B8, $0000, $0000, $04BD, $04C2),

    ($0000, $0000, $0000, $0000, $0000, $0000, $04C7, $04CC,
    $04D1, $04D6, $04DB, $04E2, $04E9, $04F0, $04F7, $04FC,
    $0501, $0508, $050F, $0514, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0519, $051C, $0000, $051F, $0522, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0527, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $052A, $0000),

    ($0000, $0000, $0000, $0000, $0000, $052D, $0532, $0537,
    $053A, $053F, $0544, $0000, $0549, $0000, $054E, $0553,
    $0558, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $055F, $0564, $0569, $056E, $0573, $0578,
    $057D, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0584, $0589, $058E, $0593, $0598, $0000,
    $0000, $0000, $0000, $059D, $05A2, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($05A7, $05AC, $0000, $05B1, $0000, $0000, $0000, $05B6,
    $0000, $0000, $0000, $0000, $05BB, $05C0, $05C5, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $05CA, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $05CF, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $05D4, $05D9, $0000, $05DE, $0000, $0000, $0000, $05E3,
    $0000, $0000, $0000, $0000, $05E8, $05ED, $05F2, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $05F7, $05FC,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0601, $0606, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $060B, $0610, $0615, $061A, $0000, $0000, $061F, $0624,
    $0000, $0000, $0629, $062E, $0633, $0638, $063D, $0642),

    ($0000, $0000, $0647, $064C, $0651, $0656, $065B, $0660,
    $0000, $0000, $0665, $066A, $066F, $0674, $0679, $067E,
    $0683, $0688, $068D, $0692, $0697, $069C, $0000, $0000,
    $06A1, $06A6, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $06AB, $06B0, $06B5, $06BA, $06BF, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($06C4, $0000, $06C9, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $06CE, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $06D3, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $06D8, $0000, $0000, $06DD, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $06E2, $06E7, $06EC, $06F1, $06F6, $06FB, $0700, $0705),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $070A, $070F, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0714, $0719, $0000, $071E),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0723, $0000, $0000, $0728, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $072D, $0732, $0737, $0000, $0000, $073C, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0741, $0000, $0000, $0746, $074B, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0750, $0755, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $075A, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $075F, $0764, $0769, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $076E, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0773, $0000, $0000, $0000, $0000, $0000, $0000, $0778,
    $077D, $0000, $0782, $0787, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $078E, $0793, $0798, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $079D, $0000, $07A2, $07A7, $07AE, $0000),

    ($0000, $0000, $0000, $07B3, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $07B8, $0000, $0000,
    $0000, $0000, $07BD, $0000, $0000, $0000, $0000, $07C2,
    $0000, $0000, $0000, $0000, $07C7, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $07CC, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $07D1, $0000, $07D6, $07DB, $0000,
    $07E0, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $07E5, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $07EA, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $07EF, $0000, $0000),

    ($0000, $0000, $07F4, $0000, $0000, $0000, $0000, $07F9,
    $0000, $0000, $0000, $0000, $07FE, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0803, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0808, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $080D, $0000,
    $0812, $0000, $0817, $0000, $081C, $0000, $0821, $0000,
    $0000, $0000, $0826, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $082B, $0000, $0830, $0000, $0000),

    ($0835, $083A, $0000, $083F, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0844, $0849, $084E, $0853, $0858, $085D, $0862, $0867,
    $086C, $0873, $087A, $087F, $0884, $0889, $088E, $0893,
    $0898, $089D, $08A2, $08A7, $08AC, $08B3, $08BA, $08C1,
    $08C8, $08CD, $08D2, $08D7, $08DC, $08E3, $08EA, $08EF),

    ($08F4, $08F9, $08FE, $0903, $0908, $090D, $0912, $0917,
    $091C, $0921, $0926, $092B, $0930, $0935, $093A, $0941,
    $0948, $094D, $0952, $0957, $095C, $0961, $0966, $096B,
    $0970, $0977, $097E, $0983, $0988, $098D, $0992, $0997),

    ($099C, $09A1, $09A6, $09AB, $09B0, $09B5, $09BA, $09BF,
    $09C4, $09C9, $09CE, $09D3, $09D8, $09DF, $09E6, $09ED,
    $09F4, $09FB, $0A02, $0A09, $0A10, $0A15, $0A1A, $0A1F,
    $0A24, $0A29, $0A2E, $0A33, $0A38, $0A3F, $0A46, $0A4B),

    ($0A50, $0A55, $0A5A, $0A5F, $0A64, $0A6B, $0A72, $0A79,
    $0A80, $0A87, $0A8E, $0A93, $0A98, $0A9D, $0AA2, $0AA7,
    $0AAC, $0AB1, $0AB6, $0ABB, $0AC0, $0AC5, $0ACA, $0ACF,
    $0AD4, $0ADB, $0AE2, $0AE9, $0AF0, $0AF5, $0AFA, $0AFF),

    ($0B04, $0B09, $0B0E, $0B13, $0B18, $0B1D, $0B22, $0B27,
    $0B2C, $0B31, $0B36, $0B3B, $0B40, $0B45, $0B4A, $0B4F,
    $0B54, $0B59, $0B5E, $0B63, $0B68, $0B6D, $0B72, $0B77,
    $0B7C, $0B81, $0000, $0B86, $0000, $0000, $0000, $0000),

    ($0B8B, $0B90, $0B95, $0B9A, $0B9F, $0BA6, $0BAD, $0BB4,
    $0BBB, $0BC2, $0BC9, $0BD0, $0BD7, $0BDE, $0BE5, $0BEC,
    $0BF3, $0BFA, $0C01, $0C08, $0C0F, $0C16, $0C1D, $0C24,
    $0C2B, $0C30, $0C35, $0C3A, $0C3F, $0C44, $0C49, $0C50),

    ($0C57, $0C5E, $0C65, $0C6C, $0C73, $0C7A, $0C81, $0C88,
    $0C8F, $0C94, $0C99, $0C9E, $0CA3, $0CA8, $0CAD, $0CB2,
    $0CB7, $0CBE, $0CC5, $0CCC, $0CD3, $0CDA, $0CE1, $0CE8,
    $0CEF, $0CF6, $0CFD, $0D04, $0D0B, $0D12, $0D19, $0D20),

    ($0D27, $0D2E, $0D35, $0D3C, $0D43, $0D48, $0D4D, $0D52,
    $0D57, $0D5E, $0D65, $0D6C, $0D73, $0D7A, $0D81, $0D88,
    $0D8F, $0D96, $0D9D, $0DA2, $0DA7, $0DAC, $0DB1, $0DB6,
    $0DBB, $0DC0, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0DC5, $0DCA, $0DCF, $0DD6, $0DDD, $0DE4, $0DEB, $0DF2,
    $0DF9, $0DFE, $0E03, $0E0A, $0E11, $0E18, $0E1F, $0E26,
    $0E2D, $0E32, $0E37, $0E3E, $0E45, $0E4C, $0000, $0000,
    $0E53, $0E58, $0E5D, $0E64, $0E6B, $0E72, $0000, $0000),

    ($0E79, $0E7E, $0E83, $0E8A, $0E91, $0E98, $0E9F, $0EA6,
    $0EAD, $0EB2, $0EB7, $0EBE, $0EC5, $0ECC, $0ED3, $0EDA,
    $0EE1, $0EE6, $0EEB, $0EF2, $0EF9, $0F00, $0F07, $0F0E,
    $0F15, $0F1A, $0F1F, $0F26, $0F2D, $0F34, $0F3B, $0F42),

    ($0F49, $0F4E, $0F53, $0F5A, $0F61, $0F68, $0000, $0000,
    $0F6F, $0F74, $0F79, $0F80, $0F87, $0F8E, $0000, $0000,
    $0F95, $0F9A, $0F9F, $0FA6, $0FAD, $0FB4, $0FBB, $0FC2,
    $0000, $0FC9, $0000, $0FCE, $0000, $0FD5, $0000, $0FDC),

    ($0FE3, $0FE8, $0FED, $0FF4, $0FFB, $1002, $1009, $1010,
    $1017, $101C, $1021, $1028, $102F, $1036, $103D, $1044,
    $104B, $0569, $1050, $056E, $1055, $0573, $105A, $0578,
    $105F, $058E, $1064, $0593, $1069, $0598, $0000, $0000),

    ($106E, $1075, $107C, $1085, $108E, $1097, $10A0, $10A9,
    $10B2, $10B9, $10C0, $10C9, $10D2, $10DB, $10E4, $10ED,
    $10F6, $10FD, $1104, $110D, $1116, $111F, $1128, $1131,
    $113A, $1141, $1148, $1151, $115A, $1163, $116C, $1175),

    ($117E, $1185, $118C, $1195, $119E, $11A7, $11B0, $11B9,
    $11C2, $11C9, $11D0, $11D9, $11E2, $11EB, $11F4, $11FD,
    $1206, $120B, $1210, $1217, $121C, $0000, $1223, $1228,
    $122F, $1234, $1239, $0532, $123E, $0000, $1243, $0000),

    ($0000, $1246, $124B, $1252, $1257, $0000, $125E, $1263,
    $126A, $053A, $126F, $053F, $1274, $1279, $127E, $1283,
    $1288, $128D, $1292, $0558, $0000, $0000, $1299, $129E,
    $12A5, $12AA, $12AF, $0544, $0000, $12B4, $12B9, $12BE),

    ($12C3, $12C8, $12CD, $057D, $12D4, $12D9, $12DE, $12E3,
    $12EA, $12EF, $12F4, $054E, $12F9, $12FE, $052D, $1303,
    $0000, $0000, $1306, $130D, $1312, $0000, $1319, $131E,
    $1325, $0549, $132A, $0553, $132F, $1334, $0000, $0000),

    ($1337, $133A, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $133D, $0000,
    $0000, $0000, $1340, $001A, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $1343, $1348, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $134D, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $1352, $1357, $135C,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $1361, $0000, $0000, $0000,
    $0000, $1366, $0000, $0000, $136B, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $1370, $0000, $1375, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $137A, $0000, $0000, $137F, $0000, $0000, $1384,
    $0000, $1389, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($138E, $0000, $1393, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $1398, $139D, $13A2,
    $13A7, $13AC, $0000, $0000, $13B1, $13B6, $0000, $0000,
    $13BB, $13C0, $0000, $0000, $0000, $0000, $0000, $0000),

    ($13C5, $13CA, $0000, $0000, $13CF, $13D4, $0000, $0000,
    $13D9, $13DE, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $13E3, $13E8, $13ED, $13F2,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($13F7, $13FC, $1401, $1406, $0000, $0000, $0000, $0000,
    $0000, $0000, $140B, $1410, $1415, $141A, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $141F, $1422, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $1425, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $142A, $0000, $142F, $0000,
    $1434, $0000, $1439, $0000, $143E, $0000, $1443, $0000,
    $1448, $0000, $144D, $0000, $1452, $0000, $1457, $0000),

    ($145C, $0000, $1461, $0000, $0000, $1466, $0000, $146B,
    $0000, $1470, $0000, $0000, $0000, $0000, $0000, $0000,
    $1475, $147A, $0000, $147F, $1484, $0000, $1489, $148E,
    $0000, $1493, $1498, $0000, $149D, $14A2, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $14A7, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $14AC, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $14B1, $0000, $14B6, $0000,
    $14BB, $0000, $14C0, $0000, $14C5, $0000, $14CA, $0000,
    $14CF, $0000, $14D4, $0000, $14D9, $0000, $14DE, $0000),

    ($14E3, $0000, $14E8, $0000, $0000, $14ED, $0000, $14F2,
    $0000, $14F7, $0000, $0000, $0000, $0000, $0000, $0000,
    $14FC, $1501, $0000, $1506, $150B, $0000, $1510, $1515,
    $0000, $151A, $151F, $0000, $1524, $1529, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $152E, $0000, $0000, $1533,
    $1538, $153D, $1542, $0000, $0000, $0000, $1547, $0000),

    ($154C, $154F, $1552, $1555, $1558, $155B, $155E, $1561,
    $1561, $1564, $1567, $156A, $156D, $1570, $1573, $1576,
    $1579, $157C, $157F, $1582, $1585, $1588, $158B, $158E,
    $1591, $1594, $1597, $159A, $159D, $15A0, $15A3, $15A6),

    ($15A9, $15AC, $15AF, $15B2, $15B5, $15B8, $15BB, $15BE,
    $15C1, $15C4, $15C7, $15CA, $15CD, $15D0, $15D3, $15D6,
    $15D9, $15DC, $15DF, $15E2, $15E5, $15E8, $15EB, $15EE,
    $15F1, $15F4, $15F7, $15FA, $15FD, $1600, $1603, $1606),

    ($1609, $160C, $160F, $1612, $1615, $1618, $161B, $161E,
    $1621, $1624, $1627, $162A, $162D, $1630, $1633, $1636,
    $1639, $163C, $163F, $1642, $1645, $1648, $164B, $164E,
    $1651, $1654, $1657, $165A, $1585, $165D, $1660, $1663),

    ($1666, $1669, $166C, $166F, $1672, $1675, $1678, $167B,
    $167E, $1681, $1684, $1687, $168A, $168D, $1690, $1693,
    $1696, $1699, $169C, $169F, $16A2, $16A5, $16A8, $16AB,
    $16AE, $16B1, $16B4, $16B7, $16BA, $16BD, $16C0, $16C3),

    ($16C6, $16C9, $16CC, $16CF, $16D2, $16D5, $16D8, $16DB,
    $16DE, $16E1, $16E4, $16E7, $16EA, $16ED, $16F0, $16F3,
    $16F6, $16F9, $16FC, $16FF, $1702, $1705, $1708, $170B,
    $170E, $1711, $1714, $1717, $171A, $171D, $1720, $1723),

    ($1726, $1693, $1729, $172C, $172F, $1732, $1735, $1738,
    $173B, $173E, $1663, $1741, $1744, $1747, $174A, $174D,
    $1750, $1753, $1756, $1759, $175C, $175F, $1762, $1765,
    $1768, $176B, $176E, $1771, $1774, $1777, $177A, $1585),

    ($177D, $1780, $1783, $1786, $1789, $178C, $178F, $1792,
    $1795, $1798, $179B, $179E, $17A1, $17A4, $17A7, $17AA,
    $17AD, $17B0, $17B3, $17B6, $17B9, $17BC, $17BF, $17C2,
    $17C5, $17C8, $17CB, $1669, $17CE, $17D1, $17D4, $17D7),

    ($17DA, $17DD, $17E0, $17E3, $17E6, $17E9, $17EC, $17EF,
    $17F2, $17F5, $17F8, $17FB, $17FE, $1801, $1804, $1807,
    $180A, $180D, $1810, $1813, $1816, $1819, $181C, $181F,
    $1822, $1825, $1828, $182B, $182E, $1831, $1834, $1837),

    ($183A, $183D, $1840, $1843, $1846, $1849, $184C, $184F,
    $1852, $1855, $1858, $185B, $185E, $1861, $0000, $0000,
    $1864, $0000, $1867, $0000, $0000, $186A, $186D, $1870,
    $1873, $1876, $1879, $187C, $187F, $1882, $1885, $0000),

    ($1888, $0000, $188B, $0000, $0000, $188E, $1891, $0000,
    $0000, $0000, $1894, $1897, $189A, $189D, $18A0, $18A3,
    $18A6, $18A9, $18AC, $18AF, $18B2, $18B5, $18B8, $18BB,
    $18BE, $18C1, $18C4, $18C7, $18CA, $18CD, $18D0, $18D3),

    ($18D6, $18D9, $18DC, $18DF, $18E2, $18E5, $18E8, $18EB,
    $18EE, $18F1, $18F4, $18F7, $18FA, $18FD, $1900, $1903,
    $1906, $1909, $190C, $190F, $1912, $1915, $1918, $1708,
    $191B, $191E, $1921, $1924, $1927, $192A, $192A, $192D),

    ($1930, $1933, $1936, $1939, $193C, $193F, $1942, $188E,
    $1945, $1948, $194B, $194E, $1951, $1954, $0000, $0000,
    $1957, $195A, $195D, $1960, $1963, $1966, $1969, $196C,
    $18B8, $196F, $1972, $1975, $1864, $1978, $197B, $197E),

    ($1981, $1984, $1987, $198A, $198D, $1990, $1993, $1996,
    $1999, $18D3, $199C, $18D6, $199F, $19A2, $19A5, $19A8,
    $19AB, $1867, $15C4, $19AE, $19B1, $19B4, $1696, $179B,
    $19B7, $19BA, $18EB, $19BD, $18EE, $19C0, $19C3, $19C6),

    ($186D, $19C9, $19CC, $19CF, $19D2, $19D5, $1870, $19D8,
    $19DB, $19DE, $19E1, $19E4, $19E7, $1918, $19EA, $19ED,
    $1708, $19F0, $1924, $19F3, $19F6, $19F9, $19FC, $19FF,
    $1933, $1A02, $188B, $1A05, $1936, $165D, $1A08, $1939),

    ($1A0B, $193F, $1A0E, $1A11, $1A14, $1A17, $1A1A, $1945,
    $187F, $1A1D, $1948, $1A20, $194B, $1A23, $1561, $1A26,
    $1A29, $1A2C, $1A2F, $1A32, $1A35, $1A38, $1A3B, $1A3E,
    $1A41, $1A44, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $1A47, $0000, $1A4C),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $1A51, $1A56, $1A5B, $1A62, $1A69, $1A6E,
    $1A73, $1A78, $1A7D, $1A82, $1A87, $1A8C, $1A91, $0000,
    $1A96, $1A9B, $1AA0, $1AA5, $1AAA, $0000, $1AAF, $0000),

    ($1AB4, $1AB9, $0000, $1ABE, $1AC3, $0000, $1AC8, $1ACD,
    $1AD2, $1AD7, $1ADC, $1AE1, $1AE6, $1AEB, $1AF0, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000));
  CHAR_CANONICAL_DECOMPOSITION_SIZE = 32;
  CHAR_CANONICAL_DECOMPOSITION_DATA: array[$0000..$1AF4] of Byte = (
    $00, $02, $41, $00, $00, $03, $02, $41,
    $00, $01, $03, $02, $41, $00, $02, $03,
    $02, $41, $00, $03, $03, $02, $41, $00,
    $08, $03, $02, $41, $00, $0A, $03, $02,
    $43, $00, $27, $03, $02, $45, $00, $00,
    $03, $02, $45, $00, $01, $03, $02, $45,
    $00, $02, $03, $02, $45, $00, $08, $03,
    $02, $49, $00, $00, $03, $02, $49, $00,

    $01, $03, $02, $49, $00, $02, $03, $02,
    $49, $00, $08, $03, $02, $4E, $00, $03,
    $03, $02, $4F, $00, $00, $03, $02, $4F,
    $00, $01, $03, $02, $4F, $00, $02, $03,
    $02, $4F, $00, $03, $03, $02, $4F, $00,
    $08, $03, $02, $55, $00, $00, $03, $02,
    $55, $00, $01, $03, $02, $55, $00, $02,
    $03, $02, $55, $00, $08, $03, $02, $59,

    $00, $01, $03, $02, $61, $00, $00, $03,
    $02, $61, $00, $01, $03, $02, $61, $00,
    $02, $03, $02, $61, $00, $03, $03, $02,
    $61, $00, $08, $03, $02, $61, $00, $0A,
    $03, $02, $63, $00, $27, $03, $02, $65,
    $00, $00, $03, $02, $65, $00, $01, $03,
    $02, $65, $00, $02, $03, $02, $65, $00,
    $08, $03, $02, $69, $00, $00, $03, $02,

    $69, $00, $01, $03, $02, $69, $00, $02,
    $03, $02, $69, $00, $08, $03, $02, $6E,
    $00, $03, $03, $02, $6F, $00, $00, $03,
    $02, $6F, $00, $01, $03, $02, $6F, $00,
    $02, $03, $02, $6F, $00, $03, $03, $02,
    $6F, $00, $08, $03, $02, $75, $00, $00,
    $03, $02, $75, $00, $01, $03, $02, $75,
    $00, $02, $03, $02, $75, $00, $08, $03,

    $02, $79, $00, $01, $03, $02, $79, $00,
    $08, $03, $02, $41, $00, $04, $03, $02,
    $61, $00, $04, $03, $02, $41, $00, $06,
    $03, $02, $61, $00, $06, $03, $02, $41,
    $00, $28, $03, $02, $61, $00, $28, $03,
    $02, $43, $00, $01, $03, $02, $63, $00,
    $01, $03, $02, $43, $00, $02, $03, $02,
    $63, $00, $02, $03, $02, $43, $00, $07,

    $03, $02, $63, $00, $07, $03, $02, $43,
    $00, $0C, $03, $02, $63, $00, $0C, $03,
    $02, $44, $00, $0C, $03, $02, $64, $00,
    $0C, $03, $02, $45, $00, $04, $03, $02,
    $65, $00, $04, $03, $02, $45, $00, $06,
    $03, $02, $65, $00, $06, $03, $02, $45,
    $00, $07, $03, $02, $65, $00, $07, $03,
    $02, $45, $00, $28, $03, $02, $65, $00,

    $28, $03, $02, $45, $00, $0C, $03, $02,
    $65, $00, $0C, $03, $02, $47, $00, $02,
    $03, $02, $67, $00, $02, $03, $02, $47,
    $00, $06, $03, $02, $67, $00, $06, $03,
    $02, $47, $00, $07, $03, $02, $67, $00,
    $07, $03, $02, $47, $00, $27, $03, $02,
    $67, $00, $27, $03, $02, $48, $00, $02,
    $03, $02, $68, $00, $02, $03, $02, $49,

    $00, $03, $03, $02, $69, $00, $03, $03,
    $02, $49, $00, $04, $03, $02, $69, $00,
    $04, $03, $02, $49, $00, $06, $03, $02,
    $69, $00, $06, $03, $02, $49, $00, $28,
    $03, $02, $69, $00, $28, $03, $02, $49,
    $00, $07, $03, $02, $4A, $00, $02, $03,
    $02, $6A, $00, $02, $03, $02, $4B, $00,
    $27, $03, $02, $6B, $00, $27, $03, $02,

    $4C, $00, $01, $03, $02, $6C, $00, $01,
    $03, $02, $4C, $00, $27, $03, $02, $6C,
    $00, $27, $03, $02, $4C, $00, $0C, $03,
    $02, $6C, $00, $0C, $03, $02, $4E, $00,
    $01, $03, $02, $6E, $00, $01, $03, $02,
    $4E, $00, $27, $03, $02, $6E, $00, $27,
    $03, $02, $4E, $00, $0C, $03, $02, $6E,
    $00, $0C, $03, $02, $4F, $00, $04, $03,

    $02, $6F, $00, $04, $03, $02, $4F, $00,
    $06, $03, $02, $6F, $00, $06, $03, $02,
    $4F, $00, $0B, $03, $02, $6F, $00, $0B,
    $03, $02, $52, $00, $01, $03, $02, $72,
    $00, $01, $03, $02, $52, $00, $27, $03,
    $02, $72, $00, $27, $03, $02, $52, $00,
    $0C, $03, $02, $72, $00, $0C, $03, $02,
    $53, $00, $01, $03, $02, $73, $00, $01,

    $03, $02, $53, $00, $02, $03, $02, $73,
    $00, $02, $03, $02, $53, $00, $27, $03,
    $02, $73, $00, $27, $03, $02, $53, $00,
    $0C, $03, $02, $73, $00, $0C, $03, $02,
    $54, $00, $27, $03, $02, $74, $00, $27,
    $03, $02, $54, $00, $0C, $03, $02, $74,
    $00, $0C, $03, $02, $55, $00, $03, $03,
    $02, $75, $00, $03, $03, $02, $55, $00,

    $04, $03, $02, $75, $00, $04, $03, $02,
    $55, $00, $06, $03, $02, $75, $00, $06,
    $03, $02, $55, $00, $0A, $03, $02, $75,
    $00, $0A, $03, $02, $55, $00, $0B, $03,
    $02, $75, $00, $0B, $03, $02, $55, $00,
    $28, $03, $02, $75, $00, $28, $03, $02,
    $57, $00, $02, $03, $02, $77, $00, $02,
    $03, $02, $59, $00, $02, $03, $02, $79,

    $00, $02, $03, $02, $59, $00, $08, $03,
    $02, $5A, $00, $01, $03, $02, $7A, $00,
    $01, $03, $02, $5A, $00, $07, $03, $02,
    $7A, $00, $07, $03, $02, $5A, $00, $0C,
    $03, $02, $7A, $00, $0C, $03, $02, $4F,
    $00, $1B, $03, $02, $6F, $00, $1B, $03,
    $02, $55, $00, $1B, $03, $02, $75, $00,
    $1B, $03, $02, $41, $00, $0C, $03, $02,

    $61, $00, $0C, $03, $02, $49, $00, $0C,
    $03, $02, $69, $00, $0C, $03, $02, $4F,
    $00, $0C, $03, $02, $6F, $00, $0C, $03,
    $02, $55, $00, $0C, $03, $02, $75, $00,
    $0C, $03, $03, $55, $00, $08, $03, $04,
    $03, $03, $75, $00, $08, $03, $04, $03,
    $03, $55, $00, $08, $03, $01, $03, $03,
    $75, $00, $08, $03, $01, $03, $03, $55,

    $00, $08, $03, $0C, $03, $03, $75, $00,
    $08, $03, $0C, $03, $03, $55, $00, $08,
    $03, $00, $03, $03, $75, $00, $08, $03,
    $00, $03, $03, $41, $00, $08, $03, $04,
    $03, $03, $61, $00, $08, $03, $04, $03,
    $03, $41, $00, $07, $03, $04, $03, $03,
    $61, $00, $07, $03, $04, $03, $02, $C6,
    $00, $04, $03, $02, $E6, $00, $04, $03,

    $02, $47, $00, $0C, $03, $02, $67, $00,
    $0C, $03, $02, $4B, $00, $0C, $03, $02,
    $6B, $00, $0C, $03, $02, $4F, $00, $28,
    $03, $02, $6F, $00, $28, $03, $03, $4F,
    $00, $28, $03, $04, $03, $03, $6F, $00,
    $28, $03, $04, $03, $02, $B7, $01, $0C,
    $03, $02, $92, $02, $0C, $03, $02, $6A,
    $00, $0C, $03, $02, $47, $00, $01, $03,

    $02, $67, $00, $01, $03, $02, $4E, $00,
    $00, $03, $02, $6E, $00, $00, $03, $03,
    $41, $00, $0A, $03, $01, $03, $03, $61,
    $00, $0A, $03, $01, $03, $02, $C6, $00,
    $01, $03, $02, $E6, $00, $01, $03, $02,
    $D8, $00, $01, $03, $02, $F8, $00, $01,
    $03, $02, $41, $00, $0F, $03, $02, $61,
    $00, $0F, $03, $02, $41, $00, $11, $03,

    $02, $61, $00, $11, $03, $02, $45, $00,
    $0F, $03, $02, $65, $00, $0F, $03, $02,
    $45, $00, $11, $03, $02, $65, $00, $11,
    $03, $02, $49, $00, $0F, $03, $02, $69,
    $00, $0F, $03, $02, $49, $00, $11, $03,
    $02, $69, $00, $11, $03, $02, $4F, $00,
    $0F, $03, $02, $6F, $00, $0F, $03, $02,
    $4F, $00, $11, $03, $02, $6F, $00, $11,

    $03, $02, $52, $00, $0F, $03, $02, $72,
    $00, $0F, $03, $02, $52, $00, $11, $03,
    $02, $72, $00, $11, $03, $02, $55, $00,
    $0F, $03, $02, $75, $00, $0F, $03, $02,
    $55, $00, $11, $03, $02, $75, $00, $11,
    $03, $02, $53, $00, $26, $03, $02, $73,
    $00, $26, $03, $02, $54, $00, $26, $03,
    $02, $74, $00, $26, $03, $02, $48, $00,

    $0C, $03, $02, $68, $00, $0C, $03, $02,
    $41, $00, $07, $03, $02, $61, $00, $07,
    $03, $02, $45, $00, $27, $03, $02, $65,
    $00, $27, $03, $03, $4F, $00, $08, $03,
    $04, $03, $03, $6F, $00, $08, $03, $04,
    $03, $03, $4F, $00, $03, $03, $04, $03,
    $03, $6F, $00, $03, $03, $04, $03, $02,
    $4F, $00, $07, $03, $02, $6F, $00, $07,

    $03, $03, $4F, $00, $07, $03, $04, $03,
    $03, $6F, $00, $07, $03, $04, $03, $02,
    $59, $00, $04, $03, $02, $79, $00, $04,
    $03, $01, $00, $03, $01, $01, $03, $01,
    $13, $03, $02, $08, $03, $01, $03, $01,
    $B9, $02, $01, $3B, $00, $02, $A8, $00,
    $01, $03, $02, $91, $03, $01, $03, $01,
    $B7, $00, $02, $95, $03, $01, $03, $02,

    $97, $03, $01, $03, $02, $99, $03, $01,
    $03, $02, $9F, $03, $01, $03, $02, $A5,
    $03, $01, $03, $02, $A9, $03, $01, $03,
    $03, $B9, $03, $08, $03, $01, $03, $02,
    $99, $03, $08, $03, $02, $A5, $03, $08,
    $03, $02, $B1, $03, $01, $03, $02, $B5,
    $03, $01, $03, $02, $B7, $03, $01, $03,
    $02, $B9, $03, $01, $03, $03, $C5, $03,

    $08, $03, $01, $03, $02, $B9, $03, $08,
    $03, $02, $C5, $03, $08, $03, $02, $BF,
    $03, $01, $03, $02, $C5, $03, $01, $03,
    $02, $C9, $03, $01, $03, $02, $D2, $03,
    $01, $03, $02, $D2, $03, $08, $03, $02,
    $15, $04, $00, $03, $02, $15, $04, $08,
    $03, $02, $13, $04, $01, $03, $02, $06,
    $04, $08, $03, $02, $1A, $04, $01, $03,

    $02, $18, $04, $00, $03, $02, $23, $04,
    $06, $03, $02, $18, $04, $06, $03, $02,
    $38, $04, $06, $03, $02, $35, $04, $00,
    $03, $02, $35, $04, $08, $03, $02, $33,
    $04, $01, $03, $02, $56, $04, $08, $03,
    $02, $3A, $04, $01, $03, $02, $38, $04,
    $00, $03, $02, $43, $04, $06, $03, $02,
    $74, $04, $0F, $03, $02, $75, $04, $0F,

    $03, $02, $16, $04, $06, $03, $02, $36,
    $04, $06, $03, $02, $10, $04, $06, $03,
    $02, $30, $04, $06, $03, $02, $10, $04,
    $08, $03, $02, $30, $04, $08, $03, $02,
    $15, $04, $06, $03, $02, $35, $04, $06,
    $03, $02, $D8, $04, $08, $03, $02, $D9,
    $04, $08, $03, $02, $16, $04, $08, $03,
    $02, $36, $04, $08, $03, $02, $17, $04,

    $08, $03, $02, $37, $04, $08, $03, $02,
    $18, $04, $04, $03, $02, $38, $04, $04,
    $03, $02, $18, $04, $08, $03, $02, $38,
    $04, $08, $03, $02, $1E, $04, $08, $03,
    $02, $3E, $04, $08, $03, $02, $E8, $04,
    $08, $03, $02, $E9, $04, $08, $03, $02,
    $2D, $04, $08, $03, $02, $4D, $04, $08,
    $03, $02, $23, $04, $04, $03, $02, $43,

    $04, $04, $03, $02, $23, $04, $08, $03,
    $02, $43, $04, $08, $03, $02, $23, $04,
    $0B, $03, $02, $43, $04, $0B, $03, $02,
    $27, $04, $08, $03, $02, $47, $04, $08,
    $03, $02, $2B, $04, $08, $03, $02, $4B,
    $04, $08, $03, $02, $27, $06, $53, $06,
    $02, $27, $06, $54, $06, $02, $48, $06,
    $54, $06, $02, $27, $06, $55, $06, $02,

    $4A, $06, $54, $06, $02, $D5, $06, $54,
    $06, $02, $C1, $06, $54, $06, $02, $D2,
    $06, $54, $06, $02, $28, $09, $3C, $09,
    $02, $30, $09, $3C, $09, $02, $33, $09,
    $3C, $09, $02, $15, $09, $3C, $09, $02,
    $16, $09, $3C, $09, $02, $17, $09, $3C,
    $09, $02, $1C, $09, $3C, $09, $02, $21,
    $09, $3C, $09, $02, $22, $09, $3C, $09,

    $02, $2B, $09, $3C, $09, $02, $2F, $09,
    $3C, $09, $02, $C7, $09, $BE, $09, $02,
    $C7, $09, $D7, $09, $02, $A1, $09, $BC,
    $09, $02, $A2, $09, $BC, $09, $02, $AF,
    $09, $BC, $09, $02, $32, $0A, $3C, $0A,
    $02, $38, $0A, $3C, $0A, $02, $16, $0A,
    $3C, $0A, $02, $17, $0A, $3C, $0A, $02,
    $1C, $0A, $3C, $0A, $02, $2B, $0A, $3C,

    $0A, $02, $47, $0B, $56, $0B, $02, $47,
    $0B, $3E, $0B, $02, $47, $0B, $57, $0B,
    $02, $21, $0B, $3C, $0B, $02, $22, $0B,
    $3C, $0B, $02, $92, $0B, $D7, $0B, $02,
    $C6, $0B, $BE, $0B, $02, $C7, $0B, $BE,
    $0B, $02, $C6, $0B, $D7, $0B, $02, $46,
    $0C, $56, $0C, $02, $BF, $0C, $D5, $0C,
    $02, $C6, $0C, $D5, $0C, $02, $C6, $0C,

    $D6, $0C, $02, $C6, $0C, $C2, $0C, $03,
    $C6, $0C, $C2, $0C, $D5, $0C, $02, $46,
    $0D, $3E, $0D, $02, $47, $0D, $3E, $0D,
    $02, $46, $0D, $57, $0D, $02, $D9, $0D,
    $CA, $0D, $02, $D9, $0D, $CF, $0D, $03,
    $D9, $0D, $CF, $0D, $CA, $0D, $02, $D9,
    $0D, $DF, $0D, $02, $42, $0F, $B7, $0F,
    $02, $4C, $0F, $B7, $0F, $02, $51, $0F,

    $B7, $0F, $02, $56, $0F, $B7, $0F, $02,
    $5B, $0F, $B7, $0F, $02, $40, $0F, $B5,
    $0F, $02, $71, $0F, $72, $0F, $02, $71,
    $0F, $74, $0F, $02, $B2, $0F, $80, $0F,
    $02, $B3, $0F, $80, $0F, $02, $71, $0F,
    $80, $0F, $02, $92, $0F, $B7, $0F, $02,
    $9C, $0F, $B7, $0F, $02, $A1, $0F, $B7,
    $0F, $02, $A6, $0F, $B7, $0F, $02, $AB,

    $0F, $B7, $0F, $02, $90, $0F, $B5, $0F,
    $02, $25, $10, $2E, $10, $02, $05, $1B,
    $35, $1B, $02, $07, $1B, $35, $1B, $02,
    $09, $1B, $35, $1B, $02, $0B, $1B, $35,
    $1B, $02, $0D, $1B, $35, $1B, $02, $11,
    $1B, $35, $1B, $02, $3A, $1B, $35, $1B,
    $02, $3C, $1B, $35, $1B, $02, $3E, $1B,
    $35, $1B, $02, $3F, $1B, $35, $1B, $02,

    $42, $1B, $35, $1B, $02, $41, $00, $25,
    $03, $02, $61, $00, $25, $03, $02, $42,
    $00, $07, $03, $02, $62, $00, $07, $03,
    $02, $42, $00, $23, $03, $02, $62, $00,
    $23, $03, $02, $42, $00, $31, $03, $02,
    $62, $00, $31, $03, $03, $43, $00, $27,
    $03, $01, $03, $03, $63, $00, $27, $03,
    $01, $03, $02, $44, $00, $07, $03, $02,

    $64, $00, $07, $03, $02, $44, $00, $23,
    $03, $02, $64, $00, $23, $03, $02, $44,
    $00, $31, $03, $02, $64, $00, $31, $03,
    $02, $44, $00, $27, $03, $02, $64, $00,
    $27, $03, $02, $44, $00, $2D, $03, $02,
    $64, $00, $2D, $03, $03, $45, $00, $04,
    $03, $00, $03, $03, $65, $00, $04, $03,
    $00, $03, $03, $45, $00, $04, $03, $01,

    $03, $03, $65, $00, $04, $03, $01, $03,
    $02, $45, $00, $2D, $03, $02, $65, $00,
    $2D, $03, $02, $45, $00, $30, $03, $02,
    $65, $00, $30, $03, $03, $45, $00, $27,
    $03, $06, $03, $03, $65, $00, $27, $03,
    $06, $03, $02, $46, $00, $07, $03, $02,
    $66, $00, $07, $03, $02, $47, $00, $04,
    $03, $02, $67, $00, $04, $03, $02, $48,

    $00, $07, $03, $02, $68, $00, $07, $03,
    $02, $48, $00, $23, $03, $02, $68, $00,
    $23, $03, $02, $48, $00, $08, $03, $02,
    $68, $00, $08, $03, $02, $48, $00, $27,
    $03, $02, $68, $00, $27, $03, $02, $48,
    $00, $2E, $03, $02, $68, $00, $2E, $03,
    $02, $49, $00, $30, $03, $02, $69, $00,
    $30, $03, $03, $49, $00, $08, $03, $01,

    $03, $03, $69, $00, $08, $03, $01, $03,
    $02, $4B, $00, $01, $03, $02, $6B, $00,
    $01, $03, $02, $4B, $00, $23, $03, $02,
    $6B, $00, $23, $03, $02, $4B, $00, $31,
    $03, $02, $6B, $00, $31, $03, $02, $4C,
    $00, $23, $03, $02, $6C, $00, $23, $03,
    $03, $4C, $00, $23, $03, $04, $03, $03,
    $6C, $00, $23, $03, $04, $03, $02, $4C,

    $00, $31, $03, $02, $6C, $00, $31, $03,
    $02, $4C, $00, $2D, $03, $02, $6C, $00,
    $2D, $03, $02, $4D, $00, $01, $03, $02,
    $6D, $00, $01, $03, $02, $4D, $00, $07,
    $03, $02, $6D, $00, $07, $03, $02, $4D,
    $00, $23, $03, $02, $6D, $00, $23, $03,
    $02, $4E, $00, $07, $03, $02, $6E, $00,
    $07, $03, $02, $4E, $00, $23, $03, $02,

    $6E, $00, $23, $03, $02, $4E, $00, $31,
    $03, $02, $6E, $00, $31, $03, $02, $4E,
    $00, $2D, $03, $02, $6E, $00, $2D, $03,
    $03, $4F, $00, $03, $03, $01, $03, $03,
    $6F, $00, $03, $03, $01, $03, $03, $4F,
    $00, $03, $03, $08, $03, $03, $6F, $00,
    $03, $03, $08, $03, $03, $4F, $00, $04,
    $03, $00, $03, $03, $6F, $00, $04, $03,

    $00, $03, $03, $4F, $00, $04, $03, $01,
    $03, $03, $6F, $00, $04, $03, $01, $03,
    $02, $50, $00, $01, $03, $02, $70, $00,
    $01, $03, $02, $50, $00, $07, $03, $02,
    $70, $00, $07, $03, $02, $52, $00, $07,
    $03, $02, $72, $00, $07, $03, $02, $52,
    $00, $23, $03, $02, $72, $00, $23, $03,
    $03, $52, $00, $23, $03, $04, $03, $03,

    $72, $00, $23, $03, $04, $03, $02, $52,
    $00, $31, $03, $02, $72, $00, $31, $03,
    $02, $53, $00, $07, $03, $02, $73, $00,
    $07, $03, $02, $53, $00, $23, $03, $02,
    $73, $00, $23, $03, $03, $53, $00, $01,
    $03, $07, $03, $03, $73, $00, $01, $03,
    $07, $03, $03, $53, $00, $0C, $03, $07,
    $03, $03, $73, $00, $0C, $03, $07, $03,

    $03, $53, $00, $23, $03, $07, $03, $03,
    $73, $00, $23, $03, $07, $03, $02, $54,
    $00, $07, $03, $02, $74, $00, $07, $03,
    $02, $54, $00, $23, $03, $02, $74, $00,
    $23, $03, $02, $54, $00, $31, $03, $02,
    $74, $00, $31, $03, $02, $54, $00, $2D,
    $03, $02, $74, $00, $2D, $03, $02, $55,
    $00, $24, $03, $02, $75, $00, $24, $03,

    $02, $55, $00, $30, $03, $02, $75, $00,
    $30, $03, $02, $55, $00, $2D, $03, $02,
    $75, $00, $2D, $03, $03, $55, $00, $03,
    $03, $01, $03, $03, $75, $00, $03, $03,
    $01, $03, $03, $55, $00, $04, $03, $08,
    $03, $03, $75, $00, $04, $03, $08, $03,
    $02, $56, $00, $03, $03, $02, $76, $00,
    $03, $03, $02, $56, $00, $23, $03, $02,

    $76, $00, $23, $03, $02, $57, $00, $00,
    $03, $02, $77, $00, $00, $03, $02, $57,
    $00, $01, $03, $02, $77, $00, $01, $03,
    $02, $57, $00, $08, $03, $02, $77, $00,
    $08, $03, $02, $57, $00, $07, $03, $02,
    $77, $00, $07, $03, $02, $57, $00, $23,
    $03, $02, $77, $00, $23, $03, $02, $58,
    $00, $07, $03, $02, $78, $00, $07, $03,

    $02, $58, $00, $08, $03, $02, $78, $00,
    $08, $03, $02, $59, $00, $07, $03, $02,
    $79, $00, $07, $03, $02, $5A, $00, $02,
    $03, $02, $7A, $00, $02, $03, $02, $5A,
    $00, $23, $03, $02, $7A, $00, $23, $03,
    $02, $5A, $00, $31, $03, $02, $7A, $00,
    $31, $03, $02, $68, $00, $31, $03, $02,
    $74, $00, $08, $03, $02, $77, $00, $0A,

    $03, $02, $79, $00, $0A, $03, $02, $7F,
    $01, $07, $03, $02, $41, $00, $23, $03,
    $02, $61, $00, $23, $03, $02, $41, $00,
    $09, $03, $02, $61, $00, $09, $03, $03,
    $41, $00, $02, $03, $01, $03, $03, $61,
    $00, $02, $03, $01, $03, $03, $41, $00,
    $02, $03, $00, $03, $03, $61, $00, $02,
    $03, $00, $03, $03, $41, $00, $02, $03,

    $09, $03, $03, $61, $00, $02, $03, $09,
    $03, $03, $41, $00, $02, $03, $03, $03,
    $03, $61, $00, $02, $03, $03, $03, $03,
    $41, $00, $23, $03, $02, $03, $03, $61,
    $00, $23, $03, $02, $03, $03, $41, $00,
    $06, $03, $01, $03, $03, $61, $00, $06,
    $03, $01, $03, $03, $41, $00, $06, $03,
    $00, $03, $03, $61, $00, $06, $03, $00,

    $03, $03, $41, $00, $06, $03, $09, $03,
    $03, $61, $00, $06, $03, $09, $03, $03,
    $41, $00, $06, $03, $03, $03, $03, $61,
    $00, $06, $03, $03, $03, $03, $41, $00,
    $23, $03, $06, $03, $03, $61, $00, $23,
    $03, $06, $03, $02, $45, $00, $23, $03,
    $02, $65, $00, $23, $03, $02, $45, $00,
    $09, $03, $02, $65, $00, $09, $03, $02,

    $45, $00, $03, $03, $02, $65, $00, $03,
    $03, $03, $45, $00, $02, $03, $01, $03,
    $03, $65, $00, $02, $03, $01, $03, $03,
    $45, $00, $02, $03, $00, $03, $03, $65,
    $00, $02, $03, $00, $03, $03, $45, $00,
    $02, $03, $09, $03, $03, $65, $00, $02,
    $03, $09, $03, $03, $45, $00, $02, $03,
    $03, $03, $03, $65, $00, $02, $03, $03,

    $03, $03, $45, $00, $23, $03, $02, $03,
    $03, $65, $00, $23, $03, $02, $03, $02,
    $49, $00, $09, $03, $02, $69, $00, $09,
    $03, $02, $49, $00, $23, $03, $02, $69,
    $00, $23, $03, $02, $4F, $00, $23, $03,
    $02, $6F, $00, $23, $03, $02, $4F, $00,
    $09, $03, $02, $6F, $00, $09, $03, $03,
    $4F, $00, $02, $03, $01, $03, $03, $6F,

    $00, $02, $03, $01, $03, $03, $4F, $00,
    $02, $03, $00, $03, $03, $6F, $00, $02,
    $03, $00, $03, $03, $4F, $00, $02, $03,
    $09, $03, $03, $6F, $00, $02, $03, $09,
    $03, $03, $4F, $00, $02, $03, $03, $03,
    $03, $6F, $00, $02, $03, $03, $03, $03,
    $4F, $00, $23, $03, $02, $03, $03, $6F,
    $00, $23, $03, $02, $03, $03, $4F, $00,

    $1B, $03, $01, $03, $03, $6F, $00, $1B,
    $03, $01, $03, $03, $4F, $00, $1B, $03,
    $00, $03, $03, $6F, $00, $1B, $03, $00,
    $03, $03, $4F, $00, $1B, $03, $09, $03,
    $03, $6F, $00, $1B, $03, $09, $03, $03,
    $4F, $00, $1B, $03, $03, $03, $03, $6F,
    $00, $1B, $03, $03, $03, $03, $4F, $00,
    $1B, $03, $23, $03, $03, $6F, $00, $1B,

    $03, $23, $03, $02, $55, $00, $23, $03,
    $02, $75, $00, $23, $03, $02, $55, $00,
    $09, $03, $02, $75, $00, $09, $03, $03,
    $55, $00, $1B, $03, $01, $03, $03, $75,
    $00, $1B, $03, $01, $03, $03, $55, $00,
    $1B, $03, $00, $03, $03, $75, $00, $1B,
    $03, $00, $03, $03, $55, $00, $1B, $03,
    $09, $03, $03, $75, $00, $1B, $03, $09,

    $03, $03, $55, $00, $1B, $03, $03, $03,
    $03, $75, $00, $1B, $03, $03, $03, $03,
    $55, $00, $1B, $03, $23, $03, $03, $75,
    $00, $1B, $03, $23, $03, $02, $59, $00,
    $00, $03, $02, $79, $00, $00, $03, $02,
    $59, $00, $23, $03, $02, $79, $00, $23,
    $03, $02, $59, $00, $09, $03, $02, $79,
    $00, $09, $03, $02, $59, $00, $03, $03,

    $02, $79, $00, $03, $03, $02, $B1, $03,
    $13, $03, $02, $B1, $03, $14, $03, $03,
    $B1, $03, $13, $03, $00, $03, $03, $B1,
    $03, $14, $03, $00, $03, $03, $B1, $03,
    $13, $03, $01, $03, $03, $B1, $03, $14,
    $03, $01, $03, $03, $B1, $03, $13, $03,
    $42, $03, $03, $B1, $03, $14, $03, $42,
    $03, $02, $91, $03, $13, $03, $02, $91,

    $03, $14, $03, $03, $91, $03, $13, $03,
    $00, $03, $03, $91, $03, $14, $03, $00,
    $03, $03, $91, $03, $13, $03, $01, $03,
    $03, $91, $03, $14, $03, $01, $03, $03,
    $91, $03, $13, $03, $42, $03, $03, $91,
    $03, $14, $03, $42, $03, $02, $B5, $03,
    $13, $03, $02, $B5, $03, $14, $03, $03,
    $B5, $03, $13, $03, $00, $03, $03, $B5,

    $03, $14, $03, $00, $03, $03, $B5, $03,
    $13, $03, $01, $03, $03, $B5, $03, $14,
    $03, $01, $03, $02, $95, $03, $13, $03,
    $02, $95, $03, $14, $03, $03, $95, $03,
    $13, $03, $00, $03, $03, $95, $03, $14,
    $03, $00, $03, $03, $95, $03, $13, $03,
    $01, $03, $03, $95, $03, $14, $03, $01,
    $03, $02, $B7, $03, $13, $03, $02, $B7,

    $03, $14, $03, $03, $B7, $03, $13, $03,
    $00, $03, $03, $B7, $03, $14, $03, $00,
    $03, $03, $B7, $03, $13, $03, $01, $03,
    $03, $B7, $03, $14, $03, $01, $03, $03,
    $B7, $03, $13, $03, $42, $03, $03, $B7,
    $03, $14, $03, $42, $03, $02, $97, $03,
    $13, $03, $02, $97, $03, $14, $03, $03,
    $97, $03, $13, $03, $00, $03, $03, $97,

    $03, $14, $03, $00, $03, $03, $97, $03,
    $13, $03, $01, $03, $03, $97, $03, $14,
    $03, $01, $03, $03, $97, $03, $13, $03,
    $42, $03, $03, $97, $03, $14, $03, $42,
    $03, $02, $B9, $03, $13, $03, $02, $B9,
    $03, $14, $03, $03, $B9, $03, $13, $03,
    $00, $03, $03, $B9, $03, $14, $03, $00,
    $03, $03, $B9, $03, $13, $03, $01, $03,

    $03, $B9, $03, $14, $03, $01, $03, $03,
    $B9, $03, $13, $03, $42, $03, $03, $B9,
    $03, $14, $03, $42, $03, $02, $99, $03,
    $13, $03, $02, $99, $03, $14, $03, $03,
    $99, $03, $13, $03, $00, $03, $03, $99,
    $03, $14, $03, $00, $03, $03, $99, $03,
    $13, $03, $01, $03, $03, $99, $03, $14,
    $03, $01, $03, $03, $99, $03, $13, $03,

    $42, $03, $03, $99, $03, $14, $03, $42,
    $03, $02, $BF, $03, $13, $03, $02, $BF,
    $03, $14, $03, $03, $BF, $03, $13, $03,
    $00, $03, $03, $BF, $03, $14, $03, $00,
    $03, $03, $BF, $03, $13, $03, $01, $03,
    $03, $BF, $03, $14, $03, $01, $03, $02,
    $9F, $03, $13, $03, $02, $9F, $03, $14,
    $03, $03, $9F, $03, $13, $03, $00, $03,

    $03, $9F, $03, $14, $03, $00, $03, $03,
    $9F, $03, $13, $03, $01, $03, $03, $9F,
    $03, $14, $03, $01, $03, $02, $C5, $03,
    $13, $03, $02, $C5, $03, $14, $03, $03,
    $C5, $03, $13, $03, $00, $03, $03, $C5,
    $03, $14, $03, $00, $03, $03, $C5, $03,
    $13, $03, $01, $03, $03, $C5, $03, $14,
    $03, $01, $03, $03, $C5, $03, $13, $03,

    $42, $03, $03, $C5, $03, $14, $03, $42,
    $03, $02, $A5, $03, $14, $03, $03, $A5,
    $03, $14, $03, $00, $03, $03, $A5, $03,
    $14, $03, $01, $03, $03, $A5, $03, $14,
    $03, $42, $03, $02, $C9, $03, $13, $03,
    $02, $C9, $03, $14, $03, $03, $C9, $03,
    $13, $03, $00, $03, $03, $C9, $03, $14,
    $03, $00, $03, $03, $C9, $03, $13, $03,

    $01, $03, $03, $C9, $03, $14, $03, $01,
    $03, $03, $C9, $03, $13, $03, $42, $03,
    $03, $C9, $03, $14, $03, $42, $03, $02,
    $A9, $03, $13, $03, $02, $A9, $03, $14,
    $03, $03, $A9, $03, $13, $03, $00, $03,
    $03, $A9, $03, $14, $03, $00, $03, $03,
    $A9, $03, $13, $03, $01, $03, $03, $A9,
    $03, $14, $03, $01, $03, $03, $A9, $03,

    $13, $03, $42, $03, $03, $A9, $03, $14,
    $03, $42, $03, $02, $B1, $03, $00, $03,
    $02, $B5, $03, $00, $03, $02, $B7, $03,
    $00, $03, $02, $B9, $03, $00, $03, $02,
    $BF, $03, $00, $03, $02, $C5, $03, $00,
    $03, $02, $C9, $03, $00, $03, $03, $B1,
    $03, $13, $03, $45, $03, $03, $B1, $03,
    $14, $03, $45, $03, $04, $B1, $03, $13,

    $03, $00, $03, $45, $03, $04, $B1, $03,
    $14, $03, $00, $03, $45, $03, $04, $B1,
    $03, $13, $03, $01, $03, $45, $03, $04,
    $B1, $03, $14, $03, $01, $03, $45, $03,
    $04, $B1, $03, $13, $03, $42, $03, $45,
    $03, $04, $B1, $03, $14, $03, $42, $03,
    $45, $03, $03, $91, $03, $13, $03, $45,
    $03, $03, $91, $03, $14, $03, $45, $03,

    $04, $91, $03, $13, $03, $00, $03, $45,
    $03, $04, $91, $03, $14, $03, $00, $03,
    $45, $03, $04, $91, $03, $13, $03, $01,
    $03, $45, $03, $04, $91, $03, $14, $03,
    $01, $03, $45, $03, $04, $91, $03, $13,
    $03, $42, $03, $45, $03, $04, $91, $03,
    $14, $03, $42, $03, $45, $03, $03, $B7,
    $03, $13, $03, $45, $03, $03, $B7, $03,

    $14, $03, $45, $03, $04, $B7, $03, $13,
    $03, $00, $03, $45, $03, $04, $B7, $03,
    $14, $03, $00, $03, $45, $03, $04, $B7,
    $03, $13, $03, $01, $03, $45, $03, $04,
    $B7, $03, $14, $03, $01, $03, $45, $03,
    $04, $B7, $03, $13, $03, $42, $03, $45,
    $03, $04, $B7, $03, $14, $03, $42, $03,
    $45, $03, $03, $97, $03, $13, $03, $45,

    $03, $03, $97, $03, $14, $03, $45, $03,
    $04, $97, $03, $13, $03, $00, $03, $45,
    $03, $04, $97, $03, $14, $03, $00, $03,
    $45, $03, $04, $97, $03, $13, $03, $01,
    $03, $45, $03, $04, $97, $03, $14, $03,
    $01, $03, $45, $03, $04, $97, $03, $13,
    $03, $42, $03, $45, $03, $04, $97, $03,
    $14, $03, $42, $03, $45, $03, $03, $C9,

    $03, $13, $03, $45, $03, $03, $C9, $03,
    $14, $03, $45, $03, $04, $C9, $03, $13,
    $03, $00, $03, $45, $03, $04, $C9, $03,
    $14, $03, $00, $03, $45, $03, $04, $C9,
    $03, $13, $03, $01, $03, $45, $03, $04,
    $C9, $03, $14, $03, $01, $03, $45, $03,
    $04, $C9, $03, $13, $03, $42, $03, $45,
    $03, $04, $C9, $03, $14, $03, $42, $03,

    $45, $03, $03, $A9, $03, $13, $03, $45,
    $03, $03, $A9, $03, $14, $03, $45, $03,
    $04, $A9, $03, $13, $03, $00, $03, $45,
    $03, $04, $A9, $03, $14, $03, $00, $03,
    $45, $03, $04, $A9, $03, $13, $03, $01,
    $03, $45, $03, $04, $A9, $03, $14, $03,
    $01, $03, $45, $03, $04, $A9, $03, $13,
    $03, $42, $03, $45, $03, $04, $A9, $03,

    $14, $03, $42, $03, $45, $03, $02, $B1,
    $03, $06, $03, $02, $B1, $03, $04, $03,
    $03, $B1, $03, $00, $03, $45, $03, $02,
    $B1, $03, $45, $03, $03, $B1, $03, $01,
    $03, $45, $03, $02, $B1, $03, $42, $03,
    $03, $B1, $03, $42, $03, $45, $03, $02,
    $91, $03, $06, $03, $02, $91, $03, $04,
    $03, $02, $91, $03, $00, $03, $02, $91,

    $03, $45, $03, $01, $B9, $03, $02, $A8,
    $00, $42, $03, $03, $B7, $03, $00, $03,
    $45, $03, $02, $B7, $03, $45, $03, $03,
    $B7, $03, $01, $03, $45, $03, $02, $B7,
    $03, $42, $03, $03, $B7, $03, $42, $03,
    $45, $03, $02, $95, $03, $00, $03, $02,
    $97, $03, $00, $03, $02, $97, $03, $45,
    $03, $02, $BF, $1F, $00, $03, $02, $BF,

    $1F, $01, $03, $02, $BF, $1F, $42, $03,
    $02, $B9, $03, $06, $03, $02, $B9, $03,
    $04, $03, $03, $B9, $03, $08, $03, $00,
    $03, $02, $B9, $03, $42, $03, $03, $B9,
    $03, $08, $03, $42, $03, $02, $99, $03,
    $06, $03, $02, $99, $03, $04, $03, $02,
    $99, $03, $00, $03, $02, $FE, $1F, $00,
    $03, $02, $FE, $1F, $01, $03, $02, $FE,

    $1F, $42, $03, $02, $C5, $03, $06, $03,
    $02, $C5, $03, $04, $03, $03, $C5, $03,
    $08, $03, $00, $03, $02, $C1, $03, $13,
    $03, $02, $C1, $03, $14, $03, $02, $C5,
    $03, $42, $03, $03, $C5, $03, $08, $03,
    $42, $03, $02, $A5, $03, $06, $03, $02,
    $A5, $03, $04, $03, $02, $A5, $03, $00,
    $03, $02, $A1, $03, $14, $03, $02, $A8,

    $00, $00, $03, $01, $60, $00, $03, $C9,
    $03, $00, $03, $45, $03, $02, $C9, $03,
    $45, $03, $03, $C9, $03, $01, $03, $45,
    $03, $02, $C9, $03, $42, $03, $03, $C9,
    $03, $42, $03, $45, $03, $02, $9F, $03,
    $00, $03, $02, $A9, $03, $00, $03, $02,
    $A9, $03, $45, $03, $01, $B4, $00, $01,
    $02, $20, $01, $03, $20, $01, $A9, $03,

    $01, $4B, $00, $02, $90, $21, $38, $03,
    $02, $92, $21, $38, $03, $02, $94, $21,
    $38, $03, $02, $D0, $21, $38, $03, $02,
    $D4, $21, $38, $03, $02, $D2, $21, $38,
    $03, $02, $03, $22, $38, $03, $02, $08,
    $22, $38, $03, $02, $0B, $22, $38, $03,
    $02, $23, $22, $38, $03, $02, $25, $22,
    $38, $03, $02, $3C, $22, $38, $03, $02,

    $43, $22, $38, $03, $02, $45, $22, $38,
    $03, $02, $48, $22, $38, $03, $02, $3D,
    $00, $38, $03, $02, $61, $22, $38, $03,
    $02, $4D, $22, $38, $03, $02, $3C, $00,
    $38, $03, $02, $3E, $00, $38, $03, $02,
    $64, $22, $38, $03, $02, $65, $22, $38,
    $03, $02, $72, $22, $38, $03, $02, $73,
    $22, $38, $03, $02, $76, $22, $38, $03,

    $02, $77, $22, $38, $03, $02, $7A, $22,
    $38, $03, $02, $7B, $22, $38, $03, $02,
    $82, $22, $38, $03, $02, $83, $22, $38,
    $03, $02, $86, $22, $38, $03, $02, $87,
    $22, $38, $03, $02, $A2, $22, $38, $03,
    $02, $A8, $22, $38, $03, $02, $A9, $22,
    $38, $03, $02, $AB, $22, $38, $03, $02,
    $7C, $22, $38, $03, $02, $7D, $22, $38,

    $03, $02, $91, $22, $38, $03, $02, $92,
    $22, $38, $03, $02, $B2, $22, $38, $03,
    $02, $B3, $22, $38, $03, $02, $B4, $22,
    $38, $03, $02, $B5, $22, $38, $03, $01,
    $08, $30, $01, $09, $30, $02, $DD, $2A,
    $38, $03, $02, $4B, $30, $99, $30, $02,
    $4D, $30, $99, $30, $02, $4F, $30, $99,
    $30, $02, $51, $30, $99, $30, $02, $53,

    $30, $99, $30, $02, $55, $30, $99, $30,
    $02, $57, $30, $99, $30, $02, $59, $30,
    $99, $30, $02, $5B, $30, $99, $30, $02,
    $5D, $30, $99, $30, $02, $5F, $30, $99,
    $30, $02, $61, $30, $99, $30, $02, $64,
    $30, $99, $30, $02, $66, $30, $99, $30,
    $02, $68, $30, $99, $30, $02, $6F, $30,
    $99, $30, $02, $6F, $30, $9A, $30, $02,

    $72, $30, $99, $30, $02, $72, $30, $9A,
    $30, $02, $75, $30, $99, $30, $02, $75,
    $30, $9A, $30, $02, $78, $30, $99, $30,
    $02, $78, $30, $9A, $30, $02, $7B, $30,
    $99, $30, $02, $7B, $30, $9A, $30, $02,
    $46, $30, $99, $30, $02, $9D, $30, $99,
    $30, $02, $AB, $30, $99, $30, $02, $AD,
    $30, $99, $30, $02, $AF, $30, $99, $30,

    $02, $B1, $30, $99, $30, $02, $B3, $30,
    $99, $30, $02, $B5, $30, $99, $30, $02,
    $B7, $30, $99, $30, $02, $B9, $30, $99,
    $30, $02, $BB, $30, $99, $30, $02, $BD,
    $30, $99, $30, $02, $BF, $30, $99, $30,
    $02, $C1, $30, $99, $30, $02, $C4, $30,
    $99, $30, $02, $C6, $30, $99, $30, $02,
    $C8, $30, $99, $30, $02, $CF, $30, $99,

    $30, $02, $CF, $30, $9A, $30, $02, $D2,
    $30, $99, $30, $02, $D2, $30, $9A, $30,
    $02, $D5, $30, $99, $30, $02, $D5, $30,
    $9A, $30, $02, $D8, $30, $99, $30, $02,
    $D8, $30, $9A, $30, $02, $DB, $30, $99,
    $30, $02, $DB, $30, $9A, $30, $02, $A6,
    $30, $99, $30, $02, $EF, $30, $99, $30,
    $02, $F0, $30, $99, $30, $02, $F1, $30,

    $99, $30, $02, $F2, $30, $99, $30, $02,
    $FD, $30, $99, $30, $01, $48, $8C, $01,
    $F4, $66, $01, $CA, $8E, $01, $C8, $8C,
    $01, $D1, $6E, $01, $32, $4E, $01, $E5,
    $53, $01, $9C, $9F, $01, $51, $59, $01,
    $D1, $91, $01, $87, $55, $01, $48, $59,
    $01, $F6, $61, $01, $69, $76, $01, $85,
    $7F, $01, $3F, $86, $01, $BA, $87, $01,

    $F8, $88, $01, $8F, $90, $01, $02, $6A,
    $01, $1B, $6D, $01, $D9, $70, $01, $DE,
    $73, $01, $3D, $84, $01, $6A, $91, $01,
    $F1, $99, $01, $82, $4E, $01, $75, $53,
    $01, $04, $6B, $01, $1B, $72, $01, $2D,
    $86, $01, $1E, $9E, $01, $50, $5D, $01,
    $EB, $6F, $01, $CD, $85, $01, $64, $89,
    $01, $C9, $62, $01, $D8, $81, $01, $1F,

    $88, $01, $CA, $5E, $01, $17, $67, $01,
    $6A, $6D, $01, $FC, $72, $01, $CE, $90,
    $01, $86, $4F, $01, $B7, $51, $01, $DE,
    $52, $01, $C4, $64, $01, $D3, $6A, $01,
    $10, $72, $01, $E7, $76, $01, $01, $80,
    $01, $06, $86, $01, $5C, $86, $01, $EF,
    $8D, $01, $32, $97, $01, $6F, $9B, $01,
    $FA, $9D, $01, $8C, $78, $01, $7F, $79,

    $01, $A0, $7D, $01, $C9, $83, $01, $04,
    $93, $01, $7F, $9E, $01, $D6, $8A, $01,
    $DF, $58, $01, $04, $5F, $01, $60, $7C,
    $01, $7E, $80, $01, $62, $72, $01, $CA,
    $78, $01, $C2, $8C, $01, $F7, $96, $01,
    $D8, $58, $01, $62, $5C, $01, $13, $6A,
    $01, $DA, $6D, $01, $0F, $6F, $01, $2F,
    $7D, $01, $37, $7E, $01, $4B, $96, $01,

    $D2, $52, $01, $8B, $80, $01, $DC, $51,
    $01, $CC, $51, $01, $1C, $7A, $01, $BE,
    $7D, $01, $F1, $83, $01, $75, $96, $01,
    $80, $8B, $01, $CF, $62, $01, $FE, $8A,
    $01, $39, $4E, $01, $E7, $5B, $01, $12,
    $60, $01, $87, $73, $01, $70, $75, $01,
    $17, $53, $01, $FB, $78, $01, $BF, $4F,
    $01, $A9, $5F, $01, $0D, $4E, $01, $CC,

    $6C, $01, $78, $65, $01, $22, $7D, $01,
    $C3, $53, $01, $5E, $58, $01, $01, $77,
    $01, $49, $84, $01, $AA, $8A, $01, $BA,
    $6B, $01, $B0, $8F, $01, $88, $6C, $01,
    $FE, $62, $01, $E5, $82, $01, $A0, $63,
    $01, $65, $75, $01, $AE, $4E, $01, $69,
    $51, $01, $C9, $51, $01, $81, $68, $01,
    $E7, $7C, $01, $6F, $82, $01, $D2, $8A,

    $01, $CF, $91, $01, $F5, $52, $01, $42,
    $54, $01, $73, $59, $01, $EC, $5E, $01,
    $C5, $65, $01, $FE, $6F, $01, $2A, $79,
    $01, $AD, $95, $01, $6A, $9A, $01, $97,
    $9E, $01, $CE, $9E, $01, $9B, $52, $01,
    $C6, $66, $01, $77, $6B, $01, $62, $8F,
    $01, $74, $5E, $01, $90, $61, $01, $00,
    $62, $01, $9A, $64, $01, $23, $6F, $01,

    $49, $71, $01, $89, $74, $01, $CA, $79,
    $01, $F4, $7D, $01, $6F, $80, $01, $26,
    $8F, $01, $EE, $84, $01, $23, $90, $01,
    $4A, $93, $01, $17, $52, $01, $A3, $52,
    $01, $BD, $54, $01, $C8, $70, $01, $C2,
    $88, $01, $C9, $5E, $01, $F5, $5F, $01,
    $7B, $63, $01, $AE, $6B, $01, $3E, $7C,
    $01, $75, $73, $01, $E4, $4E, $01, $F9,

    $56, $01, $BA, $5D, $01, $1C, $60, $01,
    $B2, $73, $01, $69, $74, $01, $9A, $7F,
    $01, $46, $80, $01, $34, $92, $01, $F6,
    $96, $01, $48, $97, $01, $18, $98, $01,
    $8B, $4F, $01, $AE, $79, $01, $B4, $91,
    $01, $B8, $96, $01, $E1, $60, $01, $86,
    $4E, $01, $DA, $50, $01, $EE, $5B, $01,
    $3F, $5C, $01, $99, $65, $01, $CE, $71,

    $01, $42, $76, $01, $FC, $84, $01, $7C,
    $90, $01, $8D, $9F, $01, $88, $66, $01,
    $2E, $96, $01, $89, $52, $01, $7B, $67,
    $01, $F3, $67, $01, $41, $6D, $01, $9C,
    $6E, $01, $09, $74, $01, $59, $75, $01,
    $6B, $78, $01, $10, $7D, $01, $5E, $98,
    $01, $6D, $51, $01, $2E, $62, $01, $78,
    $96, $01, $2B, $50, $01, $19, $5D, $01,

    $EA, $6D, $01, $2A, $8F, $01, $8B, $5F,
    $01, $44, $61, $01, $17, $68, $01, $86,
    $96, $01, $29, $52, $01, $0F, $54, $01,
    $65, $5C, $01, $13, $66, $01, $4E, $67,
    $01, $A8, $68, $01, $E5, $6C, $01, $06,
    $74, $01, $E2, $75, $01, $79, $7F, $01,
    $CF, $88, $01, $E1, $88, $01, $CC, $91,
    $01, $E2, $96, $01, $3F, $53, $01, $BA,

    $6E, $01, $1D, $54, $01, $D0, $71, $01,
    $98, $74, $01, $FA, $85, $01, $A3, $96,
    $01, $57, $9C, $01, $9F, $9E, $01, $97,
    $67, $01, $CB, $6D, $01, $E8, $81, $01,
    $CB, $7A, $01, $20, $7B, $01, $92, $7C,
    $01, $C0, $72, $01, $99, $70, $01, $58,
    $8B, $01, $C0, $4E, $01, $36, $83, $01,
    $3A, $52, $01, $07, $52, $01, $A6, $5E,

    $01, $D3, $62, $01, $D6, $7C, $01, $85,
    $5B, $01, $1E, $6D, $01, $B4, $66, $01,
    $3B, $8F, $01, $4C, $88, $01, $4D, $96,
    $01, $8B, $89, $01, $D3, $5E, $01, $40,
    $51, $01, $C0, $55, $01, $5A, $58, $01,
    $74, $66, $01, $DE, $51, $01, $2A, $73,
    $01, $CA, $76, $01, $3C, $79, $01, $5E,
    $79, $01, $65, $79, $01, $8F, $79, $01,

    $56, $97, $01, $BE, $7C, $01, $BD, $7F,
    $01, $12, $86, $01, $F8, $8A, $01, $38,
    $90, $01, $FD, $90, $01, $EF, $98, $01,
    $FC, $98, $01, $28, $99, $01, $B4, $9D,
    $01, $DE, $90, $01, $B7, $96, $01, $AE,
    $4F, $01, $E7, $50, $01, $4D, $51, $01,
    $C9, $52, $01, $E4, $52, $01, $51, $53,
    $01, $9D, $55, $01, $06, $56, $01, $68,

    $56, $01, $40, $58, $01, $A8, $58, $01,
    $64, $5C, $01, $6E, $5C, $01, $94, $60,
    $01, $68, $61, $01, $8E, $61, $01, $F2,
    $61, $01, $4F, $65, $01, $E2, $65, $01,
    $91, $66, $01, $85, $68, $01, $77, $6D,
    $01, $1A, $6E, $01, $22, $6F, $01, $6E,
    $71, $01, $2B, $72, $01, $22, $74, $01,
    $91, $78, $01, $3E, $79, $01, $49, $79,

    $01, $48, $79, $01, $50, $79, $01, $56,
    $79, $01, $5D, $79, $01, $8D, $79, $01,
    $8E, $79, $01, $40, $7A, $01, $81, $7A,
    $01, $C0, $7B, $01, $09, $7E, $01, $41,
    $7E, $01, $72, $7F, $01, $05, $80, $01,
    $ED, $81, $01, $79, $82, $01, $57, $84,
    $01, $10, $89, $01, $96, $89, $01, $01,
    $8B, $01, $39, $8B, $01, $D3, $8C, $01,

    $08, $8D, $01, $B6, $8F, $01, $E3, $96,
    $01, $FF, $97, $01, $3B, $98, $01, $75,
    $60, $01, $EE, $42, $01, $18, $82, $01,
    $26, $4E, $01, $B5, $51, $01, $68, $51,
    $01, $80, $4F, $01, $45, $51, $01, $80,
    $51, $01, $C7, $52, $01, $FA, $52, $01,
    $55, $55, $01, $99, $55, $01, $E2, $55,
    $01, $B3, $58, $01, $44, $59, $01, $54,

    $59, $01, $62, $5A, $01, $28, $5B, $01,
    $D2, $5E, $01, $D9, $5E, $01, $69, $5F,
    $01, $AD, $5F, $01, $D8, $60, $01, $4E,
    $61, $01, $08, $61, $01, $60, $61, $01,
    $34, $62, $01, $C4, $63, $01, $1C, $64,
    $01, $52, $64, $01, $56, $65, $01, $1B,
    $67, $01, $56, $67, $01, $79, $6B, $01,
    $DB, $6E, $01, $CB, $6E, $01, $1E, $70,

    $01, $A7, $77, $01, $35, $72, $01, $AF,
    $72, $01, $71, $74, $01, $06, $75, $01,
    $3B, $75, $01, $1D, $76, $01, $1F, $76,
    $01, $DB, $76, $01, $F4, $76, $01, $4A,
    $77, $01, $40, $77, $01, $CC, $78, $01,
    $B1, $7A, $01, $7B, $7C, $01, $5B, $7D,
    $01, $3E, $7F, $01, $52, $83, $01, $EF,
    $83, $01, $79, $87, $01, $41, $89, $01,

    $86, $89, $01, $BF, $8A, $01, $CB, $8A,
    $01, $ED, $8A, $01, $8A, $8B, $01, $38,
    $8F, $01, $72, $90, $01, $99, $91, $01,
    $76, $92, $01, $7C, $96, $01, $DB, $97,
    $01, $0B, $98, $01, $12, $9B, $01, $4A,
    $28, $01, $44, $28, $01, $D5, $33, $01,
    $9D, $3B, $01, $18, $40, $01, $39, $40,
    $01, $49, $52, $01, $D0, $5C, $01, $D3,

    $7E, $01, $43, $9F, $01, $8E, $9F, $02,
    $D9, $05, $B4, $05, $02, $F2, $05, $B7,
    $05, $02, $E9, $05, $C1, $05, $02, $E9,
    $05, $C2, $05, $03, $E9, $05, $BC, $05,
    $C1, $05, $03, $E9, $05, $BC, $05, $C2,
    $05, $02, $D0, $05, $B7, $05, $02, $D0,
    $05, $B8, $05, $02, $D0, $05, $BC, $05,
    $02, $D1, $05, $BC, $05, $02, $D2, $05,

    $BC, $05, $02, $D3, $05, $BC, $05, $02,
    $D4, $05, $BC, $05, $02, $D5, $05, $BC,
    $05, $02, $D6, $05, $BC, $05, $02, $D8,
    $05, $BC, $05, $02, $D9, $05, $BC, $05,
    $02, $DA, $05, $BC, $05, $02, $DB, $05,
    $BC, $05, $02, $DC, $05, $BC, $05, $02,
    $DE, $05, $BC, $05, $02, $E0, $05, $BC,
    $05, $02, $E1, $05, $BC, $05, $02, $E3,

    $05, $BC, $05, $02, $E4, $05, $BC, $05,
    $02, $E6, $05, $BC, $05, $02, $E7, $05,
    $BC, $05, $02, $E8, $05, $BC, $05, $02,
    $E9, $05, $BC, $05, $02, $EA, $05, $BC,
    $05, $02, $D5, $05, $B9, $05, $02, $D1,
    $05, $BF, $05, $02, $DB, $05, $BF, $05,
    $02, $E4, $05, $BF, $05);
var
  i: Cardinal;
begin
  if (c >= #$C0) and (c <= #$FB4E) then
    begin
      i := CHAR_CANONICAL_DECOMPOSITION_1[(Ord(c) - $C0) div CHAR_CANONICAL_DECOMPOSITION_SIZE];
      if i <> 0 then
        begin
          Dec(i);
          i := CHAR_CANONICAL_DECOMPOSITION_2[i, Ord(c) and (CHAR_CANONICAL_DECOMPOSITION_SIZE - 1)];
          if i <> 0 then
            begin
              Result := Pointer(@CHAR_CANONICAL_DECOMPOSITION_DATA[i]);
              Exit;
            end;
        end;
  end;
  Result := nil;
end;

function CharDecomposeCompatibleW(const c: WideChar): PCharDecompositionW;
const
  CHAR_COMPATIBLE_DECOMPOSITION_1: array[$0000..$07FA] of Byte = (
    $01, $00, $00, $00, $02, $03, $04, $00,
    $00, $05, $06, $00, $00, $00, $00, $00,
    $07, $08, $09, $00, $00, $00, $0A, $0B,
    $00, $0C, $0D, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $0E,
    $00, $00, $00, $00, $00, $00, $0F, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $10, $00, $00, $00,
    $11, $12, $00, $13, $00, $00, $14, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $15, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $16, $17, $18, $19,
    $1A, $00, $00, $00, $00, $00, $00, $1B,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $1C, $1D, $1E, $1F, $20, $21, $22, $23,

    $24, $00, $00, $25, $26, $27, $28, $29,
    $00, $00, $00, $00, $2A, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $2B, $2C,
    $2D, $2E, $2F, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $30, $00, $00, $31, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $32, $00,
    $00, $00, $00, $00, $00, $00, $33, $00,
    $00, $00, $00, $00, $00, $00, $00, $34,
    $00, $00, $35, $36, $37, $38, $39, $3A,
    $3B, $3C, $00, $3D, $3E, $00, $00, $3F,

    $00, $00, $40, $00, $41, $42, $43, $44,
    $00, $00, $00, $45, $46, $47, $48, $49,
    $4A, $4B, $4C, $4D, $4E, $4F, $50, $51,
    $52, $53, $54, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $55,
    $00, $00, $00, $00, $00, $00, $56, $00,
    $00, $00, $57, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $58, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $59, $5A, $5B, $5C, $5D,
    $5E, $5F, $60, $61, $62, $63, $64, $65,
    $66, $67, $68, $69, $6A, $6B, $6C, $6D,
    $6E, $6F, $70, $71, $72, $73, $74, $75,
    $76, $77, $78, $79, $7A, $7B, $7C, $7D,
    $7E, $7F, $80);
  CHAR_COMPATIBLE_DECOMPOSITION_2: array[$0000..$007F, $0000..$001F] of Word = (

    ($0001, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0004, $0000, $0009, $0000, $0000, $0000, $0000, $000C,
    $0000, $0000, $0011, $0014, $0017, $001C, $0000, $0000,
    $001F, $0024, $0027, $0000, $002A, $0031, $0038, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $003F, $0044, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0049),

    ($004E, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0053, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0058),

    ($0000, $0000, $0000, $0000, $005B, $0062, $0069, $0070,
    $0075, $007A, $007F, $0084, $0089, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $008E, $0093, $0098, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $009D, $00A0, $00A3, $00A6, $00A9, $00AC, $00AF, $00B2,
    $00B5, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $00B8, $00BD, $00C2, $00C7, $00CC, $00D1, $0000, $0000),

    ($00D6, $00D9, $0058, $00DC, $00DF, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $00E2, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0017, $00E7, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $00EE, $00F1, $00F4, $00F7, $00FC, $0101, $0104, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0107, $010A, $010D, $0000, $0110, $0113, $0000, $0000,
    $0000, $0116, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0119,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $011E, $0123, $0128,
    $012D, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0132, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0137, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $013C, $0141, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0146, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0149,
    $0000, $0150, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0157, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $015A, $015D, $0160, $0000,
    $0163, $0166, $0169, $016C, $016F, $0172, $0175, $0178,
    $017B, $017E, $0181, $0000, $0184, $0187, $018A, $018D),

    ($0190, $0193, $0196, $0009, $0199, $019C, $019F, $01A2,
    $01A5, $01A8, $01AB, $01AE, $01B1, $01B4, $0000, $01B7,
    $01BA, $01BD, $0027, $01C0, $01C3, $01C6, $01C9, $01CC,
    $01CF, $01D2, $01D5, $01D8, $01DB, $00EE, $01DE, $01E1),

    ($0101, $01E4, $01E7, $00A6, $01CF, $01D8, $00EE, $01DE,
    $010A, $0101, $01E4, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $01EA, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $01ED, $01F0, $01F3, $01F6, $01B1),

    ($01F9, $01FC, $01FF, $0202, $0205, $0208, $020B, $020E,
    $0211, $0214, $0217, $021A, $021D, $0220, $0223, $0226,
    $0229, $022C, $022F, $0232, $0235, $0238, $023B, $023E,
    $0241, $0244, $0247, $024A, $024D, $0250, $0253, $00F1),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0256, $025B, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0260, $0000, $0260),

    ($0265, $026A, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0271, $0278, $027F,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0286, $028D, $0294),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $029B, $00E7, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0017, $02A2, $0000),

    ($0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001,
    $0001, $0001, $0001, $0000, $0000, $0000, $0000, $0000,
    $0000, $02A7, $0000, $0000, $0000, $0000, $0000, $02AA,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $02AF, $02B2, $02B7, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0001,
    $0000, $0000, $0000, $02BE, $02C3, $0000, $02CA, $02CF,
    $0000, $0000, $0000, $0000, $02D6, $0000, $02DB, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $02E0,
    $02E5, $02EA, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $02EF,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0001),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $02F8, $01E7, $0000, $0000, $02FB, $02FE, $0301, $0304,
    $0307, $030A, $030D, $0310, $0313, $0316, $0319, $031C),

    ($02F8, $0024, $0011, $0014, $02FB, $02FE, $0301, $0304,
    $0307, $030A, $030D, $0310, $0313, $0316, $0319, $0000,
    $0009, $01A8, $0027, $00DC, $01AB, $009D, $01B7, $00D9,
    $01BA, $031C, $01C9, $0058, $01CC, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $031F, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0324, $032B, $0332, $0335, $0000, $033A, $0341, $0348,
    $0000, $034B, $01B4, $016F, $016F, $016F, $009D, $0350,
    $0172, $0172, $017B, $00D9, $0000, $0181, $0353, $0000,
    $0000, $018A, $0358, $018D, $018D, $018D, $0000, $0000),

    ($035B, $0360, $0367, $0000, $036C, $0000, $0000, $0000,
    $036C, $0000, $0000, $0000, $0160, $0332, $0000, $01A8,
    $0166, $036F, $0000, $017E, $0027, $0372, $0375, $0378,
    $037B, $01E7, $0000, $037E, $0104, $01DE, $0385, $0388),

    ($038B, $0000, $0000, $0000, $0000, $0163, $01A5, $01A8,
    $01E7, $00A3, $0000, $0000, $0000, $0000, $0000, $0000,
    $038E, $0395, $039C, $03A5, $03AC, $03B3, $03BA, $03C1,
    $03C8, $03CF, $03D6, $03DD, $03E4, $03EB, $03F2, $03F9),

    ($0172, $03FE, $0403, $040A, $040F, $0412, $0417, $041E,
    $0427, $042C, $042F, $0434, $017B, $0332, $0163, $017E,
    $01E7, $043B, $0440, $0447, $01D8, $044C, $0451, $0458,
    $0461, $00DC, $0466, $046B, $00D9, $01F0, $01A5, $01BA),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0472, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0479, $047E, $0000, $0485,
    $048A, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0024, $0011, $0014, $02FB, $02FE, $0301, $0304, $0307,
    $030A, $0491, $0496, $049B, $04A0, $04A5, $04AA, $04AF,
    $04B4, $04B9, $04BE, $04C3, $04C8, $04CF, $04D6, $04DD,
    $04E4, $04EB, $04F2, $04F9, $0500, $0507, $0510, $0519),

    ($0522, $052B, $0534, $053D, $0546, $054F, $0558, $0561,
    $056A, $056F, $0574, $0579, $057E, $0583, $0588, $058D,
    $0592, $0597, $059E, $05A5, $05AC, $05B3, $05BA, $05C1,
    $05C8, $05CF, $05D6, $05DD, $05E4, $05EB, $05F2, $05F9),

    ($0600, $0607, $060E, $0615, $061C, $0623, $062A, $0631,
    $0638, $063F, $0646, $064D, $0654, $065B, $0662, $0669,
    $0670, $0677, $067E, $0685, $068C, $0693, $015A, $0160,
    $0332, $0163, $0166, $036F, $016C, $016F, $0172, $0175),

    ($0178, $017B, $017E, $0181, $0184, $018A, $0358, $018D,
    $069A, $0190, $0193, $040F, $0196, $042C, $069D, $036C,
    $0009, $01A2, $01F0, $01A5, $01A8, $01F9, $01B4, $009D,
    $01E7, $00A3, $01B7, $00D9, $01BA, $031C, $0027, $01C9),

    ($06A0, $00A6, $0058, $01CC, $01CF, $01D8, $00B2, $00DC,
    $00B5, $024A, $02F8, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $06A3, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $06AC, $06B3, $06B8, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $00A3, $040F, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $06BF,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $06C2),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $06C5, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($06C8, $06CB, $06CE, $06D1, $06D4, $06D7, $06DA, $06DD,
    $06E0, $06E3, $06E6, $06E9, $06EC, $06EF, $06F2, $06F5,
    $06F8, $06FB, $06FE, $0701, $0704, $0707, $070A, $070D,
    $0710, $0713, $0716, $0719, $071C, $071F, $0722, $0725),

    ($0728, $072B, $072E, $0731, $0734, $0737, $073A, $073D,
    $0740, $0743, $0746, $0749, $074C, $074F, $0752, $0755,
    $0758, $075B, $075E, $0761, $0764, $0767, $076A, $076D,
    $0770, $0773, $0776, $0779, $077C, $077F, $0782, $0785),

    ($0788, $078B, $078E, $0791, $0794, $0797, $079A, $079D,
    $07A0, $07A3, $07A6, $07A9, $07AC, $07AF, $07B2, $07B5,
    $07B8, $07BB, $07BE, $07C1, $07C4, $07C7, $07CA, $07CD,
    $07D0, $07D3, $07D6, $07D9, $07DC, $07DF, $07E2, $07E5),

    ($07E8, $07EB, $07EE, $07F1, $07F4, $07F7, $07FA, $07FD,
    $0800, $0803, $0806, $0809, $080C, $080F, $0812, $0815,
    $0818, $081B, $081E, $0821, $0824, $0827, $082A, $082D,
    $0830, $0833, $0836, $0839, $083C, $083F, $0842, $0845),

    ($0848, $084B, $084E, $0851, $0854, $0857, $085A, $085D,
    $0860, $0863, $0866, $0869, $086C, $086F, $0872, $0875,
    $0878, $087B, $087E, $0881, $0884, $0887, $088A, $088D,
    $0890, $0893, $0896, $0899, $089C, $089F, $08A2, $08A5),

    ($08A8, $08AB, $08AE, $08B1, $08B4, $08B7, $08BA, $08BD,
    $08C0, $08C3, $08C6, $08C9, $08CC, $08CF, $08D2, $08D5,
    $08D8, $08DB, $08DE, $08E1, $08E4, $08E7, $08EA, $08ED,
    $08F0, $08F3, $08F6, $08F9, $08FC, $08FF, $0902, $0905),

    ($0908, $090B, $090E, $0911, $0914, $0917, $091A, $091D,
    $0920, $0923, $0926, $0929, $092C, $092F, $0932, $0935,
    $0938, $093B, $093E, $0941, $0944, $0947, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0001, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $094A, $0000,
    $070D, $094D, $0950, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0953, $0958, $0000, $0000, $095D),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0962),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0967, $096A, $096D, $0970, $0973, $0976, $0979,
    $097C, $097F, $0982, $0985, $0988, $098B, $098E, $0991),

    ($0994, $0997, $099A, $099D, $09A0, $09A3, $09A6, $09A9,
    $09AC, $09AF, $09B2, $09B5, $09B8, $09BB, $09BE, $09C1,
    $09C4, $09C7, $09CA, $09CD, $09D0, $09D3, $09D6, $09D9,
    $09DC, $09DF, $09E2, $09E5, $09E8, $09EB, $09EE, $09F1),

    ($09F4, $09F7, $09FA, $09FD, $0A00, $0A03, $0A06, $0A09,
    $0A0C, $0A0F, $0A12, $0A15, $0A18, $0A1B, $0A1E, $0A21,
    $0A24, $0A27, $0A2A, $0A2D, $0A30, $0A33, $0A36, $0A39,
    $0A3C, $0A3F, $0A42, $0A45, $0A48, $0A4B, $0A4E, $0A51),

    ($0A54, $0A57, $0A5A, $0A5D, $0A60, $0A63, $0A66, $0A69,
    $0A6C, $0A6F, $0A72, $0A75, $0A78, $0A7B, $0A7E, $0000,
    $0000, $0000, $06C8, $06DA, $0A81, $0A84, $0A87, $0A8A,
    $0A8D, $0A90, $06D4, $0A93, $0A96, $0A99, $0A9C, $06E0),

    ($0A9F, $0AA6, $0AAD, $0AB4, $0ABB, $0AC2, $0AC9, $0AD0,
    $0AD7, $0ADE, $0AE5, $0AEC, $0AF3, $0AFA, $0B01, $0B0A,
    $0B13, $0B1C, $0B25, $0B2E, $0B37, $0B40, $0B49, $0B52,
    $0B5B, $0B64, $0B6D, $0B76, $0B7F, $0B88, $0B97, $0000),

    ($0BA4, $0BAB, $0BB2, $0BB9, $0BC0, $0BC7, $0BCE, $0BD5,
    $0BDC, $0BE3, $0BEA, $0BF1, $0BF8, $0BFF, $0C06, $0C0D,
    $0C14, $0C1B, $0C22, $0C29, $0C30, $0C37, $0C3E, $0C45,
    $0C4C, $0C53, $0C5A, $0C61, $0C68, $0C6F, $0C76, $0C7D),

    ($0C84, $0C8B, $0C92, $0C99, $0CA0, $0CA3, $078E, $0CA6,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0CA9, $0CB0, $0CB5, $0CBA, $0CBF, $0CC4, $0CC9, $0CCE,
    $0CD3, $0CD8, $0CDD, $0CE2, $0CE7, $0CEC, $0CF1, $0CF6),

    ($0967, $0970, $0979, $097F, $0997, $099A, $09A3, $09A9,
    $09AC, $09B2, $09B5, $09B8, $09BB, $09BE, $0CFB, $0D00,
    $0D05, $0D0A, $0D0F, $0D14, $0D19, $0D1E, $0D23, $0D28,
    $0D2D, $0D32, $0D37, $0D3C, $0D41, $0D4C, $0D55, $0000),

    ($06C8, $06DA, $0A81, $0A84, $0D5A, $0D5D, $0D60, $06E9,
    $0D63, $070D, $07A3, $07C7, $07C4, $07A6, $08BA, $0725,
    $079D, $0D66, $0D69, $0D6C, $0D6F, $0D72, $0D75, $0D78,
    $0D7B, $0D7E, $0D81, $0737, $0D84, $0D87, $0D8A, $0D8D),

    ($0D90, $0D93, $0D96, $0D99, $0A87, $0A8A, $0A8D, $0D9C,
    $0D9F, $0DA2, $0DA5, $0DA8, $0DAB, $0DAE, $0DB1, $0DB4,
    $0DB7, $0DBA, $0DBF, $0DC4, $0DC9, $0DCE, $0DD3, $0DD8,
    $0DDD, $0DE2, $0DE7, $0DEC, $0DF1, $0DF6, $0DFB, $0E00),

    ($0E05, $0E0A, $0E0F, $0E14, $0E19, $0E1E, $0E23, $0E28,
    $0E2D, $0E32, $0E39, $0E40, $0E47, $0E4C, $0E53, $0E58,
    $0E5F, $0E62, $0E65, $0E68, $0E6B, $0E6E, $0E71, $0E74,
    $0E77, $0E7A, $0E7D, $0E80, $0E83, $0E86, $0E89, $0E8C),

    ($0E8F, $0E92, $0E95, $0E98, $0E9B, $0E9E, $0EA1, $0EA4,
    $0EA7, $0EAA, $0EAD, $0EB0, $0EB3, $0EB6, $0EB9, $0EBC,
    $0EBF, $0EC2, $0EC5, $0EC8, $0ECB, $0ECE, $0ED1, $0ED4,
    $0ED7, $0EDA, $0EDD, $0EE0, $0EE3, $0EE6, $0EE9, $0000),

    ($0EEC, $0EF7, $0F00, $0F0B, $0F12, $0F1D, $0F24, $0F2B,
    $0F38, $0F41, $0F48, $0F4F, $0F56, $0F5F, $0F68, $0F71,
    $0F7A, $0F83, $0F8C, $0F95, $0FA2, $0FA7, $0FB4, $0FC1,
    $0FCC, $0FD5, $0FE2, $0FEF, $0FF8, $0FFF, $1006, $100F),

    ($1018, $1023, $102E, $1035, $103C, $1045, $104C, $1053,
    $1058, $105D, $1064, $106B, $1078, $1081, $108C, $1099,
    $10A2, $10A9, $10B0, $10BD, $10C6, $10D3, $10DA, $10E5,
    $10EC, $10F5, $10FC, $1105, $1110, $1119, $1124, $112D),

    ($1132, $113D, $1144, $114B, $1154, $115B, $1162, $1169,
    $1174, $117D, $1182, $118F, $1196, $11A1, $11AA, $11B3,
    $11BA, $11C1, $11CA, $11CF, $11D8, $11E3, $11E8, $11F5,
    $11FC, $1201, $1206, $120B, $1210, $1215, $121A, $121F),

    ($1224, $1229, $122E, $1235, $123C, $1243, $124A, $1251,
    $1258, $125F, $1266, $126D, $1274, $127B, $1282, $1289,
    $1290, $1297, $129E, $12A3, $12A8, $12AF, $12B4, $12B9,
    $12BE, $12C5, $12CC, $12D1, $12D6, $12DB, $12E0, $12E5),

    ($12EE, $12F3, $12F8, $12FD, $1302, $1307, $130C, $1311,
    $1316, $131D, $1326, $132B, $1330, $1335, $133A, $133F,
    $1344, $1349, $1350, $1357, $135E, $1365, $136A, $136F,
    $1374, $1379, $137E, $1383, $1388, $138D, $1392, $1397),

    ($139E, $13A5, $13AA, $13B1, $13B8, $13BF, $13C4, $13CB,
    $13D2, $13DB, $13E0, $13E7, $13EE, $13F5, $13FC, $1407,
    $1414, $1419, $141E, $1423, $1428, $142D, $1432, $1437,
    $143C, $1441, $1446, $144B, $1450, $1455, $145A, $145F),

    ($1464, $1469, $146E, $1477, $147C, $1481, $1486, $148F,
    $1496, $149B, $14A0, $14A5, $14AA, $14AF, $14B4, $14B9,
    $14BE, $14C3, $14C8, $14CF, $14D4, $14D9, $14E0, $14E7,
    $14EC, $14F5, $14FC, $1501, $1506, $150B, $1510, $1517),

    ($151E, $1523, $1528, $152D, $1532, $1537, $153C, $1541,
    $1546, $154B, $1552, $1559, $1560, $1567, $156E, $1575,
    $157C, $1583, $158A, $1591, $1598, $159F, $15A6, $15AD,
    $15B4, $15BB, $15C2, $15C9, $15D0, $15D7, $15DE, $15E5),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $15EC, $15EF, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $15F2, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $15F5, $15F8, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $15FB, $15FE, $1601, $1604),

    ($1607, $160C, $1611, $1616, $161D, $1624, $1624, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $1629, $162E, $1633, $1638, $163D,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($1642, $0372, $037B, $1645, $1648, $164B, $164E, $1651,
    $1654, $030D, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $1657,
    $165C, $165C, $165F, $165F, $165F, $165F, $1662, $1662,
    $1662, $1662, $1665, $1665, $1665, $1665, $1668, $1668),

    ($1668, $1668, $166B, $166B, $166B, $166B, $166E, $166E,
    $166E, $166E, $1671, $1671, $1671, $1671, $1674, $1674,
    $1674, $1674, $1677, $1677, $1677, $1677, $167A, $167A,
    $167A, $167A, $167D, $167D, $167D, $167D, $1680, $1680),

    ($1680, $1680, $1683, $1683, $1686, $1686, $1689, $1689,
    $168C, $168C, $168F, $168F, $1692, $1692, $1695, $1695,
    $1695, $1695, $1698, $1698, $1698, $1698, $169B, $169B,
    $169B, $169B, $169E, $169E, $169E, $169E, $16A1, $16A1),

    ($16A4, $16A4, $16A4, $16A4, $16A7, $16A7, $16AC, $16AC,
    $16AC, $16AC, $16AF, $16AF, $16AF, $16AF, $16B2, $16B2,
    $16B5, $16B5, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $16BA, $16BA, $16BA, $16BA, $16BD,
    $16BD, $16C0, $16C0, $16C3, $16C3, $0128, $16C6, $16C6),

    ($16C9, $16C9, $16CC, $16CC, $16CF, $16CF, $16CF, $16CF,
    $16D2, $16D2, $16D5, $16D5, $16DC, $16DC, $16E3, $16E3,
    $16EA, $16EA, $16F1, $16F1, $16F8, $16F8, $16FF, $16FF,
    $16FF, $1706, $1706, $1706, $170D, $170D, $170D, $170D),

    ($1710, $1717, $171E, $1706, $1725, $172C, $1731, $1736,
    $173B, $1740, $1745, $174A, $174F, $1754, $1759, $175E,
    $1763, $1768, $176D, $1772, $1777, $177C, $1781, $1786,
    $178B, $1790, $1795, $179A, $179F, $17A4, $17A9, $17AE),

    ($17B3, $17B8, $17BD, $17C2, $17C7, $17CC, $17D1, $17D6,
    $17DB, $17E0, $17E5, $17EA, $17EF, $17F4, $17F9, $17FE,
    $1803, $1808, $180D, $1812, $1817, $181C, $1821, $1826,
    $182B, $1830, $1835, $183A, $183F, $1844, $1849, $184E),

    ($1853, $1858, $185D, $1862, $1867, $186C, $1871, $1876,
    $187B, $1880, $1885, $188A, $188F, $1894, $1899, $189E,
    $18A3, $18A8, $18AD, $18B2, $18B7, $18BC, $18C1, $18C6,
    $18CB, $18D0, $18D5, $18DA, $18DF, $18E4, $18E9, $18F0),

    ($18F7, $18FE, $1905, $190C, $1913, $191A, $171E, $1921,
    $1706, $1725, $1928, $192D, $173B, $1932, $1740, $1745,
    $1937, $193C, $1759, $1941, $175E, $1763, $1946, $194B,
    $176D, $1950, $1772, $1777, $1808, $180D, $181C, $1821),

    ($1826, $183A, $183F, $1844, $1849, $185D, $1862, $1867,
    $1955, $187B, $195A, $195F, $1899, $1964, $189E, $18A3,
    $18E4, $1969, $196E, $18CB, $1973, $18D0, $18D5, $1710,
    $1717, $1978, $171E, $197F, $172C, $1731, $1736, $173B),

    ($1986, $174A, $174F, $1754, $1759, $198B, $176D, $177C,
    $1781, $1786, $178B, $1790, $179A, $179F, $17A4, $17A9,
    $17AE, $17B3, $1990, $17B8, $17BD, $17C2, $17C7, $17CC,
    $17D1, $17DB, $17E0, $17E5, $17EA, $17EF, $17F4, $17F9),

    ($17FE, $1803, $1812, $1817, $182B, $1830, $1835, $183A,
    $183F, $184E, $1853, $1858, $185D, $1995, $186C, $1871,
    $1876, $187B, $188A, $188F, $1894, $1899, $199A, $18A8,
    $18AD, $199F, $18BC, $18C1, $18C6, $18CB, $19A4, $171E),

    ($197F, $173B, $1986, $1759, $198B, $176D, $19A9, $17AE,
    $19AE, $19B3, $19B8, $183A, $183F, $185D, $1899, $199A,
    $18CB, $19A4, $19BD, $19C4, $19CB, $19D2, $19D7, $19DC,
    $19E1, $19E6, $19EB, $19F0, $19F5, $19FA, $19FF, $1A04),

    ($1A09, $1A0E, $1A13, $1A18, $1A1D, $1A22, $1A27, $1A2C,
    $1A31, $1A36, $1A3B, $1A40, $19B3, $1A45, $1A4A, $1A4F,
    $1A54, $19D2, $19D7, $19DC, $19E1, $19E6, $19EB, $19F0,
    $19F5, $19FA, $19FF, $1A04, $1A09, $1A0E, $1A13, $1A18),

    ($1A1D, $1A22, $1A27, $1A2C, $1A31, $1A36, $1A3B, $1A40,
    $19B3, $1A45, $1A4A, $1A4F, $1A54, $1A36, $1A3B, $1A40,
    $19B3, $19AE, $19B8, $17D6, $179F, $17A4, $17A9, $1A36,
    $1A3B, $1A40, $17D6, $17DB, $1A59, $1A59, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $1A5E, $1A65, $1A65, $1A6C, $1A73, $1A7A, $1A81, $1A88,
    $1A8F, $1A8F, $1A96, $1A9D, $1AA4, $1AAB, $1AB2, $1AB9),

    ($1AB9, $1AC0, $1AC7, $1AC7, $1ACE, $1ACE, $1AD5, $1ADC,
    $1ADC, $1AE3, $1AEA, $1AEA, $1AF1, $1AF1, $1AF8, $1AFF,
    $1AFF, $1B06, $1B06, $1B0D, $1B14, $1B1B, $1B22, $1B22,
    $1B29, $1B30, $1B37, $1B3E, $1B45, $1B45, $1B4C, $1B53),

    ($1B5A, $1B61, $1B68, $1B6F, $1B6F, $1B76, $1B76, $1B7D,
    $1B7D, $1B84, $1B8B, $1B92, $1B99, $1BA0, $1BA7, $1BAE,
    $0000, $0000, $1BB5, $1BBC, $1BC3, $1BCA, $1BD1, $1BD8,
    $1BD8, $1BDF, $1BE6, $1BED, $1BF4, $1BF4, $1BFB, $1C02),

    ($1C09, $1C10, $1C17, $1C1E, $1C25, $1C2C, $1C33, $1C3A,
    $1C41, $1C48, $1C4F, $1C56, $1C5D, $1C64, $1C6B, $1C72,
    $1C79, $1C80, $1C87, $1C8E, $1B4C, $1B5A, $1C95, $1C9C,
    $1CA3, $1CAA, $1CB1, $1CB8, $1CB1, $1CA3, $1CBF, $1CC6),

    ($1CCD, $1CD4, $1CDB, $1CB8, $1B1B, $1AD5, $1CE2, $1CE9,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $1CF0, $1CF7, $1CFE, $1D07, $1D10, $1D19, $1D22, $1D2B,
    $1D34, $1D3D, $1D44, $1D69, $1D7A, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $1D83, $1D86, $1D89, $1D8C, $1D8F, $1D92, $1D95, $1D98,
    $1D9B, $02B7, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $02B2, $1D9E, $1DA1, $1DA4, $1DA4, $0316, $0319, $1DA7,
    $1DAA, $1DAD, $1DB0, $1DB3, $1DB6, $1DB9, $1DBC, $1DBF),

    ($1DC2, $1DC5, $1DC8, $1DCB, $1DCE, $0000, $0000, $1DD1,
    $1DD4, $02DB, $02DB, $02DB, $02DB, $1DA4, $1DA4, $1DA4,
    $1D83, $1D86, $02AF, $0000, $1D8F, $1D8C, $1D95, $1D92,
    $1D9E, $0316, $0319, $1DA7, $1DAA, $1DAD, $1DB0, $1DD7),

    ($1DDA, $1DDD, $030D, $1DE0, $1DE3, $1DE6, $0313, $0000,
    $1DE9, $1DEC, $1DEF, $1DF2, $0000, $0000, $0000, $0000,
    $1DF5, $1DFA, $1DFF, $0000, $1E04, $0000, $1E09, $1E0E,
    $1E13, $1E18, $1E1D, $1E22, $1E27, $1E2C, $1E31, $1E36),

    ($1E3B, $1E3E, $1E3E, $1E43, $1E43, $1E48, $1E48, $1E4D,
    $1E4D, $1E52, $1E52, $1E52, $1E52, $1E57, $1E57, $1E5A,
    $1E5A, $1E5A, $1E5A, $1E5D, $1E5D, $1E60, $1E60, $1E60,
    $1E60, $1E63, $1E63, $1E63, $1E63, $1E66, $1E66, $1E66),

    ($1E66, $1E69, $1E69, $1E69, $1E69, $1E6C, $1E6C, $1E6C,
    $1E6C, $1E6F, $1E6F, $1E72, $1E72, $1E75, $1E75, $1E78,
    $1E78, $1E7B, $1E7B, $1E7B, $1E7B, $1E7E, $1E7E, $1E7E,
    $1E7E, $1E81, $1E81, $1E81, $1E81, $1E84, $1E84, $1E84),

    ($1E84, $1E87, $1E87, $1E87, $1E87, $1E8A, $1E8A, $1E8A,
    $1E8A, $1E8D, $1E8D, $1E8D, $1E8D, $1E90, $1E90, $1E90,
    $1E90, $1E93, $1E93, $1E93, $1E93, $1E96, $1E96, $1E96,
    $1E96, $1E99, $1E99, $1E99, $1E99, $1E9C, $1E9C, $1E9C),

    ($1E9C, $1E9F, $1E9F, $1E9F, $1E9F, $1EA2, $1EA2, $1EA2,
    $1EA2, $1EA5, $1EA5, $1EA5, $1EA5, $1EA8, $1EA8, $16D2,
    $16D2, $1EAB, $1EAB, $1EAB, $1EAB, $1EAE, $1EAE, $1EB5,
    $1EB5, $1EBC, $1EBC, $1EC3, $1EC3, $0000, $0000, $0000),

    ($0000, $1D92, $1EC8, $1DD7, $1DEC, $1DEF, $1DDA, $1ECB,
    $0316, $0319, $1DDD, $030D, $1D83, $1DE0, $02AF, $1ECE,
    $02F8, $0024, $0011, $0014, $02FB, $02FE, $0301, $0304,
    $0307, $030A, $1D8C, $1D8F, $1DE3, $0313, $1DE6, $1D95),

    ($1DF2, $015A, $0160, $0332, $0163, $0166, $036F, $016C,
    $016F, $0172, $0175, $0178, $017B, $017E, $0181, $0184,
    $018A, $0358, $018D, $069A, $0190, $0193, $040F, $0196,
    $042C, $069D, $036C, $1DD1, $1DE9, $1DD4, $1ED1, $1DA4),

    ($1ED4, $0009, $01A2, $01F0, $01A5, $01A8, $01F9, $01B4,
    $009D, $01E7, $00A3, $01B7, $00D9, $01BA, $031C, $0027,
    $01C9, $06A0, $00A6, $0058, $01CC, $01CF, $01D8, $00B2,
    $00DC, $00B5, $024A, $1DA7, $1ED7, $1DAA, $1EDA, $1EDD),

    ($1EE0, $1D89, $1DC5, $1DC8, $1D86, $1EE3, $0EE9, $1EE6,
    $1EE9, $1EEC, $1EEF, $1EF2, $1EF5, $1EF8, $1EFB, $1EFE,
    $1F01, $0E5F, $0E62, $0E65, $0E68, $0E6B, $0E6E, $0E71,
    $0E74, $0E77, $0E7A, $0E7D, $0E80, $0E83, $0E86, $0E89),

    ($0E8C, $0E8F, $0E92, $0E95, $0E98, $0E9B, $0E9E, $0EA1,
    $0EA4, $0EA7, $0EAA, $0EAD, $0EB0, $0EB3, $0EB6, $0EB9,
    $0EBC, $0EBF, $0EC2, $0EC5, $0EC8, $0ECB, $0ECE, $0ED1,
    $0ED4, $0ED7, $0EDA, $0EDD, $0EE0, $1F04, $1F07, $1F0A),

    ($0A00, $0967, $096A, $096D, $0970, $0973, $0976, $0979,
    $097C, $097F, $0982, $0985, $0988, $098B, $098E, $0991,
    $0994, $0997, $099A, $099D, $09A0, $09A3, $09A6, $09A9,
    $09AC, $09AF, $09B2, $09B5, $09B8, $09BB, $09BE, $0000),

    ($0000, $0000, $09C1, $09C4, $09C7, $09CA, $09CD, $09D0,
    $0000, $0000, $09D3, $09D6, $09D9, $09DC, $09DF, $09E2,
    $0000, $0000, $09E5, $09E8, $09EB, $09EE, $09F1, $09F4,
    $0000, $0000, $09F7, $09FA, $09FD, $0000, $0000, $0000),

    ($1F0D, $1F10, $1F13, $000C, $1F16, $1F19, $1F1C, $0000,
    $1F1F, $1F22, $1F25, $1F28, $1F2B, $1F2E, $1F31, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000));
  CHAR_COMPATIBLE_DECOMPOSITION_SIZE = 32;
  CHAR_COMPATIBLE_DECOMPOSITION_DATA: array[$0000..$1F33] of Byte = (
    $00, $01, $20, $00, $02, $20, $00, $08,
    $03, $01, $61, $00, $02, $20, $00, $04,
    $03, $01, $32, $00, $01, $33, $00, $02,
    $20, $00, $01, $03, $01, $BC, $03, $02,
    $20, $00, $27, $03, $01, $31, $00, $01,
    $6F, $00, $03, $31, $00, $44, $20, $34,
    $00, $03, $31, $00, $44, $20, $32, $00,
    $03, $33, $00, $44, $20, $34, $00, $02,

    $49, $00, $4A, $00, $02, $69, $00, $6A,
    $00, $02, $4C, $00, $B7, $00, $02, $6C,
    $00, $B7, $00, $02, $BC, $02, $6E, $00,
    $01, $73, $00, $03, $44, $00, $5A, $00,
    $0C, $03, $03, $44, $00, $7A, $00, $0C,
    $03, $03, $64, $00, $7A, $00, $0C, $03,
    $02, $4C, $00, $4A, $00, $02, $4C, $00,
    $6A, $00, $02, $6C, $00, $6A, $00, $02,

    $4E, $00, $4A, $00, $02, $4E, $00, $6A,
    $00, $02, $6E, $00, $6A, $00, $02, $44,
    $00, $5A, $00, $02, $44, $00, $7A, $00,
    $02, $64, $00, $7A, $00, $01, $68, $00,
    $01, $66, $02, $01, $6A, $00, $01, $72,
    $00, $01, $79, $02, $01, $7B, $02, $01,
    $81, $02, $01, $77, $00, $01, $79, $00,
    $02, $20, $00, $06, $03, $02, $20, $00,

    $07, $03, $02, $20, $00, $0A, $03, $02,
    $20, $00, $28, $03, $02, $20, $00, $03,
    $03, $02, $20, $00, $0B, $03, $01, $63,
    $02, $01, $6C, $00, $01, $78, $00, $01,
    $95, $02, $02, $20, $00, $45, $03, $03,
    $20, $00, $08, $03, $01, $03, $01, $B2,
    $03, $01, $B8, $03, $01, $A5, $03, $02,
    $A5, $03, $01, $03, $02, $A5, $03, $08,

    $03, $01, $C6, $03, $01, $C0, $03, $01,
    $BA, $03, $01, $C1, $03, $01, $C2, $03,
    $01, $98, $03, $01, $B5, $03, $01, $A3,
    $03, $02, $65, $05, $82, $05, $02, $27,
    $06, $74, $06, $02, $48, $06, $74, $06,
    $02, $C7, $06, $74, $06, $02, $4A, $06,
    $74, $06, $02, $4D, $0E, $32, $0E, $02,
    $CD, $0E, $B2, $0E, $02, $AB, $0E, $99,

    $0E, $02, $AB, $0E, $A1, $0E, $01, $0B,
    $0F, $03, $B2, $0F, $71, $0F, $80, $0F,
    $03, $B3, $0F, $71, $0F, $80, $0F, $01,
    $DC, $10, $01, $41, $00, $01, $C6, $00,
    $01, $42, $00, $01, $44, $00, $01, $45,
    $00, $01, $8E, $01, $01, $47, $00, $01,
    $48, $00, $01, $49, $00, $01, $4A, $00,
    $01, $4B, $00, $01, $4C, $00, $01, $4D,

    $00, $01, $4E, $00, $01, $4F, $00, $01,
    $22, $02, $01, $50, $00, $01, $52, $00,
    $01, $54, $00, $01, $55, $00, $01, $57,
    $00, $01, $50, $02, $01, $51, $02, $01,
    $02, $1D, $01, $62, $00, $01, $64, $00,
    $01, $65, $00, $01, $59, $02, $01, $5B,
    $02, $01, $5C, $02, $01, $67, $00, $01,
    $6B, $00, $01, $6D, $00, $01, $4B, $01,

    $01, $54, $02, $01, $16, $1D, $01, $17,
    $1D, $01, $70, $00, $01, $74, $00, $01,
    $75, $00, $01, $1D, $1D, $01, $6F, $02,
    $01, $76, $00, $01, $25, $1D, $01, $B3,
    $03, $01, $B4, $03, $01, $C7, $03, $01,
    $69, $00, $01, $3D, $04, $01, $52, $02,
    $01, $63, $00, $01, $55, $02, $01, $F0,
    $00, $01, $66, $00, $01, $5F, $02, $01,

    $61, $02, $01, $65, $02, $01, $68, $02,
    $01, $69, $02, $01, $6A, $02, $01, $7B,
    $1D, $01, $9D, $02, $01, $6D, $02, $01,
    $85, $1D, $01, $9F, $02, $01, $71, $02,
    $01, $70, $02, $01, $72, $02, $01, $73,
    $02, $01, $74, $02, $01, $75, $02, $01,
    $78, $02, $01, $82, $02, $01, $83, $02,
    $01, $AB, $01, $01, $89, $02, $01, $8A,

    $02, $01, $1C, $1D, $01, $8B, $02, $01,
    $8C, $02, $01, $7A, $00, $01, $90, $02,
    $01, $91, $02, $01, $92, $02, $02, $61,
    $00, $BE, $02, $02, $73, $00, $07, $03,
    $02, $20, $00, $13, $03, $02, $20, $00,
    $42, $03, $03, $20, $00, $08, $03, $42,
    $03, $03, $20, $00, $13, $03, $00, $03,
    $03, $20, $00, $13, $03, $01, $03, $03,

    $20, $00, $13, $03, $42, $03, $03, $20,
    $00, $14, $03, $00, $03, $03, $20, $00,
    $14, $03, $01, $03, $03, $20, $00, $14,
    $03, $42, $03, $03, $20, $00, $08, $03,
    $00, $03, $02, $20, $00, $14, $03, $01,
    $10, $20, $02, $20, $00, $33, $03, $01,
    $2E, $00, $02, $2E, $00, $2E, $00, $03,
    $2E, $00, $2E, $00, $2E, $00, $02, $32,

    $20, $32, $20, $03, $32, $20, $32, $20,
    $32, $20, $02, $35, $20, $35, $20, $03,
    $35, $20, $35, $20, $35, $20, $02, $21,
    $00, $21, $00, $02, $20, $00, $05, $03,
    $02, $3F, $00, $3F, $00, $02, $3F, $00,
    $21, $00, $02, $21, $00, $3F, $00, $04,
    $32, $20, $32, $20, $32, $20, $32, $20,
    $01, $30, $00, $01, $34, $00, $01, $35,

    $00, $01, $36, $00, $01, $37, $00, $01,
    $38, $00, $01, $39, $00, $01, $2B, $00,
    $01, $12, $22, $01, $3D, $00, $01, $28,
    $00, $01, $29, $00, $01, $6E, $00, $02,
    $52, $00, $73, $00, $03, $61, $00, $2F,
    $00, $63, $00, $03, $61, $00, $2F, $00,
    $73, $00, $01, $43, $00, $02, $B0, $00,
    $43, $00, $03, $63, $00, $2F, $00, $6F,

    $00, $03, $63, $00, $2F, $00, $75, $00,
    $01, $90, $01, $02, $B0, $00, $46, $00,
    $01, $27, $01, $02, $4E, $00, $6F, $00,
    $01, $51, $00, $02, $53, $00, $4D, $00,
    $03, $54, $00, $45, $00, $4C, $00, $02,
    $54, $00, $4D, $00, $01, $5A, $00, $01,
    $46, $00, $01, $D0, $05, $01, $D1, $05,
    $01, $D2, $05, $01, $D3, $05, $03, $46,

    $00, $41, $00, $58, $00, $01, $93, $03,
    $01, $A0, $03, $01, $11, $22, $03, $31,
    $00, $44, $20, $37, $00, $03, $31, $00,
    $44, $20, $39, $00, $04, $31, $00, $44,
    $20, $31, $00, $30, $00, $03, $31, $00,
    $44, $20, $33, $00, $03, $32, $00, $44,
    $20, $33, $00, $03, $31, $00, $44, $20,
    $35, $00, $03, $32, $00, $44, $20, $35,

    $00, $03, $33, $00, $44, $20, $35, $00,
    $03, $34, $00, $44, $20, $35, $00, $03,
    $31, $00, $44, $20, $36, $00, $03, $35,
    $00, $44, $20, $36, $00, $03, $31, $00,
    $44, $20, $38, $00, $03, $33, $00, $44,
    $20, $38, $00, $03, $35, $00, $44, $20,
    $38, $00, $03, $37, $00, $44, $20, $38,
    $00, $02, $31, $00, $44, $20, $02, $49,

    $00, $49, $00, $03, $49, $00, $49, $00,
    $49, $00, $02, $49, $00, $56, $00, $01,
    $56, $00, $02, $56, $00, $49, $00, $03,
    $56, $00, $49, $00, $49, $00, $04, $56,
    $00, $49, $00, $49, $00, $49, $00, $02,
    $49, $00, $58, $00, $01, $58, $00, $02,
    $58, $00, $49, $00, $03, $58, $00, $49,
    $00, $49, $00, $02, $69, $00, $69, $00,

    $03, $69, $00, $69, $00, $69, $00, $02,
    $69, $00, $76, $00, $02, $76, $00, $69,
    $00, $03, $76, $00, $69, $00, $69, $00,
    $04, $76, $00, $69, $00, $69, $00, $69,
    $00, $02, $69, $00, $78, $00, $02, $78,
    $00, $69, $00, $03, $78, $00, $69, $00,
    $69, $00, $03, $30, $00, $44, $20, $33,
    $00, $02, $2B, $22, $2B, $22, $03, $2B,

    $22, $2B, $22, $2B, $22, $02, $2E, $22,
    $2E, $22, $03, $2E, $22, $2E, $22, $2E,
    $22, $02, $31, $00, $30, $00, $02, $31,
    $00, $31, $00, $02, $31, $00, $32, $00,
    $02, $31, $00, $33, $00, $02, $31, $00,
    $34, $00, $02, $31, $00, $35, $00, $02,
    $31, $00, $36, $00, $02, $31, $00, $37,
    $00, $02, $31, $00, $38, $00, $02, $31,

    $00, $39, $00, $02, $32, $00, $30, $00,
    $03, $28, $00, $31, $00, $29, $00, $03,
    $28, $00, $32, $00, $29, $00, $03, $28,
    $00, $33, $00, $29, $00, $03, $28, $00,
    $34, $00, $29, $00, $03, $28, $00, $35,
    $00, $29, $00, $03, $28, $00, $36, $00,
    $29, $00, $03, $28, $00, $37, $00, $29,
    $00, $03, $28, $00, $38, $00, $29, $00,

    $03, $28, $00, $39, $00, $29, $00, $04,
    $28, $00, $31, $00, $30, $00, $29, $00,
    $04, $28, $00, $31, $00, $31, $00, $29,
    $00, $04, $28, $00, $31, $00, $32, $00,
    $29, $00, $04, $28, $00, $31, $00, $33,
    $00, $29, $00, $04, $28, $00, $31, $00,
    $34, $00, $29, $00, $04, $28, $00, $31,
    $00, $35, $00, $29, $00, $04, $28, $00,

    $31, $00, $36, $00, $29, $00, $04, $28,
    $00, $31, $00, $37, $00, $29, $00, $04,
    $28, $00, $31, $00, $38, $00, $29, $00,
    $04, $28, $00, $31, $00, $39, $00, $29,
    $00, $04, $28, $00, $32, $00, $30, $00,
    $29, $00, $02, $31, $00, $2E, $00, $02,
    $32, $00, $2E, $00, $02, $33, $00, $2E,
    $00, $02, $34, $00, $2E, $00, $02, $35,

    $00, $2E, $00, $02, $36, $00, $2E, $00,
    $02, $37, $00, $2E, $00, $02, $38, $00,
    $2E, $00, $02, $39, $00, $2E, $00, $03,
    $31, $00, $30, $00, $2E, $00, $03, $31,
    $00, $31, $00, $2E, $00, $03, $31, $00,
    $32, $00, $2E, $00, $03, $31, $00, $33,
    $00, $2E, $00, $03, $31, $00, $34, $00,
    $2E, $00, $03, $31, $00, $35, $00, $2E,

    $00, $03, $31, $00, $36, $00, $2E, $00,
    $03, $31, $00, $37, $00, $2E, $00, $03,
    $31, $00, $38, $00, $2E, $00, $03, $31,
    $00, $39, $00, $2E, $00, $03, $32, $00,
    $30, $00, $2E, $00, $03, $28, $00, $61,
    $00, $29, $00, $03, $28, $00, $62, $00,
    $29, $00, $03, $28, $00, $63, $00, $29,
    $00, $03, $28, $00, $64, $00, $29, $00,

    $03, $28, $00, $65, $00, $29, $00, $03,
    $28, $00, $66, $00, $29, $00, $03, $28,
    $00, $67, $00, $29, $00, $03, $28, $00,
    $68, $00, $29, $00, $03, $28, $00, $69,
    $00, $29, $00, $03, $28, $00, $6A, $00,
    $29, $00, $03, $28, $00, $6B, $00, $29,
    $00, $03, $28, $00, $6C, $00, $29, $00,
    $03, $28, $00, $6D, $00, $29, $00, $03,

    $28, $00, $6E, $00, $29, $00, $03, $28,
    $00, $6F, $00, $29, $00, $03, $28, $00,
    $70, $00, $29, $00, $03, $28, $00, $71,
    $00, $29, $00, $03, $28, $00, $72, $00,
    $29, $00, $03, $28, $00, $73, $00, $29,
    $00, $03, $28, $00, $74, $00, $29, $00,
    $03, $28, $00, $75, $00, $29, $00, $03,
    $28, $00, $76, $00, $29, $00, $03, $28,

    $00, $77, $00, $29, $00, $03, $28, $00,
    $78, $00, $29, $00, $03, $28, $00, $79,
    $00, $29, $00, $03, $28, $00, $7A, $00,
    $29, $00, $01, $53, $00, $01, $59, $00,
    $01, $71, $00, $04, $2B, $22, $2B, $22,
    $2B, $22, $2B, $22, $03, $3A, $00, $3A,
    $00, $3D, $00, $02, $3D, $00, $3D, $00,
    $03, $3D, $00, $3D, $00, $3D, $00, $01,

    $61, $2D, $01, $CD, $6B, $01, $9F, $9F,
    $01, $00, $4E, $01, $28, $4E, $01, $36,
    $4E, $01, $3F, $4E, $01, $59, $4E, $01,
    $85, $4E, $01, $8C, $4E, $01, $A0, $4E,
    $01, $BA, $4E, $01, $3F, $51, $01, $65,
    $51, $01, $6B, $51, $01, $82, $51, $01,
    $96, $51, $01, $AB, $51, $01, $E0, $51,
    $01, $F5, $51, $01, $00, $52, $01, $9B,

    $52, $01, $F9, $52, $01, $15, $53, $01,
    $1A, $53, $01, $38, $53, $01, $41, $53,
    $01, $5C, $53, $01, $69, $53, $01, $82,
    $53, $01, $B6, $53, $01, $C8, $53, $01,
    $E3, $53, $01, $D7, $56, $01, $1F, $57,
    $01, $EB, $58, $01, $02, $59, $01, $0A,
    $59, $01, $15, $59, $01, $27, $59, $01,
    $73, $59, $01, $50, $5B, $01, $80, $5B,

    $01, $F8, $5B, $01, $0F, $5C, $01, $22,
    $5C, $01, $38, $5C, $01, $6E, $5C, $01,
    $71, $5C, $01, $DB, $5D, $01, $E5, $5D,
    $01, $F1, $5D, $01, $FE, $5D, $01, $72,
    $5E, $01, $7A, $5E, $01, $7F, $5E, $01,
    $F4, $5E, $01, $FE, $5E, $01, $0B, $5F,
    $01, $13, $5F, $01, $50, $5F, $01, $61,
    $5F, $01, $73, $5F, $01, $C3, $5F, $01,

    $08, $62, $01, $36, $62, $01, $4B, $62,
    $01, $2F, $65, $01, $34, $65, $01, $87,
    $65, $01, $97, $65, $01, $A4, $65, $01,
    $B9, $65, $01, $E0, $65, $01, $E5, $65,
    $01, $F0, $66, $01, $08, $67, $01, $28,
    $67, $01, $20, $6B, $01, $62, $6B, $01,
    $79, $6B, $01, $B3, $6B, $01, $CB, $6B,
    $01, $D4, $6B, $01, $DB, $6B, $01, $0F,

    $6C, $01, $14, $6C, $01, $34, $6C, $01,
    $6B, $70, $01, $2A, $72, $01, $36, $72,
    $01, $3B, $72, $01, $3F, $72, $01, $47,
    $72, $01, $59, $72, $01, $5B, $72, $01,
    $AC, $72, $01, $84, $73, $01, $89, $73,
    $01, $DC, $74, $01, $E6, $74, $01, $18,
    $75, $01, $1F, $75, $01, $28, $75, $01,
    $30, $75, $01, $8B, $75, $01, $92, $75,

    $01, $76, $76, $01, $7D, $76, $01, $AE,
    $76, $01, $BF, $76, $01, $EE, $76, $01,
    $DB, $77, $01, $E2, $77, $01, $F3, $77,
    $01, $3A, $79, $01, $B8, $79, $01, $BE,
    $79, $01, $74, $7A, $01, $CB, $7A, $01,
    $F9, $7A, $01, $73, $7C, $01, $F8, $7C,
    $01, $36, $7F, $01, $51, $7F, $01, $8A,
    $7F, $01, $BD, $7F, $01, $01, $80, $01,

    $0C, $80, $01, $12, $80, $01, $33, $80,
    $01, $7F, $80, $01, $89, $80, $01, $E3,
    $81, $01, $EA, $81, $01, $F3, $81, $01,
    $FC, $81, $01, $0C, $82, $01, $1B, $82,
    $01, $1F, $82, $01, $6E, $82, $01, $72,
    $82, $01, $78, $82, $01, $4D, $86, $01,
    $6B, $86, $01, $40, $88, $01, $4C, $88,
    $01, $63, $88, $01, $7E, $89, $01, $8B,

    $89, $01, $D2, $89, $01, $00, $8A, $01,
    $37, $8C, $01, $46, $8C, $01, $55, $8C,
    $01, $78, $8C, $01, $9D, $8C, $01, $64,
    $8D, $01, $70, $8D, $01, $B3, $8D, $01,
    $AB, $8E, $01, $CA, $8E, $01, $9B, $8F,
    $01, $B0, $8F, $01, $B5, $8F, $01, $91,
    $90, $01, $49, $91, $01, $C6, $91, $01,
    $CC, $91, $01, $D1, $91, $01, $77, $95,

    $01, $80, $95, $01, $1C, $96, $01, $B6,
    $96, $01, $B9, $96, $01, $E8, $96, $01,
    $51, $97, $01, $5E, $97, $01, $62, $97,
    $01, $69, $97, $01, $CB, $97, $01, $ED,
    $97, $01, $F3, $97, $01, $01, $98, $01,
    $A8, $98, $01, $DB, $98, $01, $DF, $98,
    $01, $96, $99, $01, $99, $99, $01, $AC,
    $99, $01, $A8, $9A, $01, $D8, $9A, $01,

    $DF, $9A, $01, $25, $9B, $01, $2F, $9B,
    $01, $32, $9B, $01, $3C, $9B, $01, $5A,
    $9B, $01, $E5, $9C, $01, $75, $9E, $01,
    $7F, $9E, $01, $A5, $9E, $01, $BB, $9E,
    $01, $C3, $9E, $01, $CD, $9E, $01, $D1,
    $9E, $01, $F9, $9E, $01, $FD, $9E, $01,
    $0E, $9F, $01, $13, $9F, $01, $20, $9F,
    $01, $3B, $9F, $01, $4A, $9F, $01, $52,

    $9F, $01, $8D, $9F, $01, $9C, $9F, $01,
    $A0, $9F, $01, $12, $30, $01, $44, $53,
    $01, $45, $53, $02, $20, $00, $99, $30,
    $02, $20, $00, $9A, $30, $02, $88, $30,
    $8A, $30, $02, $B3, $30, $C8, $30, $01,
    $00, $11, $01, $01, $11, $01, $AA, $11,
    $01, $02, $11, $01, $AC, $11, $01, $AD,
    $11, $01, $03, $11, $01, $04, $11, $01,

    $05, $11, $01, $B0, $11, $01, $B1, $11,
    $01, $B2, $11, $01, $B3, $11, $01, $B4,
    $11, $01, $B5, $11, $01, $1A, $11, $01,
    $06, $11, $01, $07, $11, $01, $08, $11,
    $01, $21, $11, $01, $09, $11, $01, $0A,
    $11, $01, $0B, $11, $01, $0C, $11, $01,
    $0D, $11, $01, $0E, $11, $01, $0F, $11,
    $01, $10, $11, $01, $11, $11, $01, $12,

    $11, $01, $61, $11, $01, $62, $11, $01,
    $63, $11, $01, $64, $11, $01, $65, $11,
    $01, $66, $11, $01, $67, $11, $01, $68,
    $11, $01, $69, $11, $01, $6A, $11, $01,
    $6B, $11, $01, $6C, $11, $01, $6D, $11,
    $01, $6E, $11, $01, $6F, $11, $01, $70,
    $11, $01, $71, $11, $01, $72, $11, $01,
    $73, $11, $01, $74, $11, $01, $75, $11,

    $01, $60, $11, $01, $14, $11, $01, $15,
    $11, $01, $C7, $11, $01, $C8, $11, $01,
    $CC, $11, $01, $CE, $11, $01, $D3, $11,
    $01, $D7, $11, $01, $D9, $11, $01, $1C,
    $11, $01, $DD, $11, $01, $DF, $11, $01,
    $1D, $11, $01, $1E, $11, $01, $20, $11,
    $01, $22, $11, $01, $23, $11, $01, $27,
    $11, $01, $29, $11, $01, $2B, $11, $01,

    $2C, $11, $01, $2D, $11, $01, $2E, $11,
    $01, $2F, $11, $01, $32, $11, $01, $36,
    $11, $01, $40, $11, $01, $47, $11, $01,
    $4C, $11, $01, $F1, $11, $01, $F2, $11,
    $01, $57, $11, $01, $58, $11, $01, $59,
    $11, $01, $84, $11, $01, $85, $11, $01,
    $88, $11, $01, $91, $11, $01, $92, $11,
    $01, $94, $11, $01, $9E, $11, $01, $A1,

    $11, $01, $09, $4E, $01, $DB, $56, $01,
    $0A, $4E, $01, $2D, $4E, $01, $0B, $4E,
    $01, $32, $75, $01, $19, $4E, $01, $01,
    $4E, $01, $29, $59, $01, $30, $57, $03,
    $28, $00, $00, $11, $29, $00, $03, $28,
    $00, $02, $11, $29, $00, $03, $28, $00,
    $03, $11, $29, $00, $03, $28, $00, $05,
    $11, $29, $00, $03, $28, $00, $06, $11,

    $29, $00, $03, $28, $00, $07, $11, $29,
    $00, $03, $28, $00, $09, $11, $29, $00,
    $03, $28, $00, $0B, $11, $29, $00, $03,
    $28, $00, $0C, $11, $29, $00, $03, $28,
    $00, $0E, $11, $29, $00, $03, $28, $00,
    $0F, $11, $29, $00, $03, $28, $00, $10,
    $11, $29, $00, $03, $28, $00, $11, $11,
    $29, $00, $03, $28, $00, $12, $11, $29,

    $00, $04, $28, $00, $00, $11, $61, $11,
    $29, $00, $04, $28, $00, $02, $11, $61,
    $11, $29, $00, $04, $28, $00, $03, $11,
    $61, $11, $29, $00, $04, $28, $00, $05,
    $11, $61, $11, $29, $00, $04, $28, $00,
    $06, $11, $61, $11, $29, $00, $04, $28,
    $00, $07, $11, $61, $11, $29, $00, $04,
    $28, $00, $09, $11, $61, $11, $29, $00,

    $04, $28, $00, $0B, $11, $61, $11, $29,
    $00, $04, $28, $00, $0C, $11, $61, $11,
    $29, $00, $04, $28, $00, $0E, $11, $61,
    $11, $29, $00, $04, $28, $00, $0F, $11,
    $61, $11, $29, $00, $04, $28, $00, $10,
    $11, $61, $11, $29, $00, $04, $28, $00,
    $11, $11, $61, $11, $29, $00, $04, $28,
    $00, $12, $11, $61, $11, $29, $00, $04,

    $28, $00, $0C, $11, $6E, $11, $29, $00,
    $07, $28, $00, $0B, $11, $69, $11, $0C,
    $11, $65, $11, $AB, $11, $29, $00, $06,
    $28, $00, $0B, $11, $69, $11, $12, $11,
    $6E, $11, $29, $00, $03, $28, $00, $00,
    $4E, $29, $00, $03, $28, $00, $8C, $4E,
    $29, $00, $03, $28, $00, $09, $4E, $29,
    $00, $03, $28, $00, $DB, $56, $29, $00,

    $03, $28, $00, $94, $4E, $29, $00, $03,
    $28, $00, $6D, $51, $29, $00, $03, $28,
    $00, $03, $4E, $29, $00, $03, $28, $00,
    $6B, $51, $29, $00, $03, $28, $00, $5D,
    $4E, $29, $00, $03, $28, $00, $41, $53,
    $29, $00, $03, $28, $00, $08, $67, $29,
    $00, $03, $28, $00, $6B, $70, $29, $00,
    $03, $28, $00, $34, $6C, $29, $00, $03,

    $28, $00, $28, $67, $29, $00, $03, $28,
    $00, $D1, $91, $29, $00, $03, $28, $00,
    $1F, $57, $29, $00, $03, $28, $00, $E5,
    $65, $29, $00, $03, $28, $00, $2A, $68,
    $29, $00, $03, $28, $00, $09, $67, $29,
    $00, $03, $28, $00, $3E, $79, $29, $00,
    $03, $28, $00, $0D, $54, $29, $00, $03,
    $28, $00, $79, $72, $29, $00, $03, $28,

    $00, $A1, $8C, $29, $00, $03, $28, $00,
    $5D, $79, $29, $00, $03, $28, $00, $B4,
    $52, $29, $00, $03, $28, $00, $E3, $4E,
    $29, $00, $03, $28, $00, $7C, $54, $29,
    $00, $03, $28, $00, $66, $5B, $29, $00,
    $03, $28, $00, $E3, $76, $29, $00, $03,
    $28, $00, $01, $4F, $29, $00, $03, $28,
    $00, $C7, $8C, $29, $00, $03, $28, $00,

    $54, $53, $29, $00, $03, $28, $00, $6D,
    $79, $29, $00, $03, $28, $00, $11, $4F,
    $29, $00, $03, $28, $00, $EA, $81, $29,
    $00, $03, $28, $00, $F3, $81, $29, $00,
    $01, $4F, $55, $01, $7C, $5E, $01, $8F,
    $7B, $03, $50, $00, $54, $00, $45, $00,
    $02, $32, $00, $31, $00, $02, $32, $00,
    $32, $00, $02, $32, $00, $33, $00, $02,

    $32, $00, $34, $00, $02, $32, $00, $35,
    $00, $02, $32, $00, $36, $00, $02, $32,
    $00, $37, $00, $02, $32, $00, $38, $00,
    $02, $32, $00, $39, $00, $02, $33, $00,
    $30, $00, $02, $33, $00, $31, $00, $02,
    $33, $00, $32, $00, $02, $33, $00, $33,
    $00, $02, $33, $00, $34, $00, $02, $33,
    $00, $35, $00, $02, $00, $11, $61, $11,

    $02, $02, $11, $61, $11, $02, $03, $11,
    $61, $11, $02, $05, $11, $61, $11, $02,
    $06, $11, $61, $11, $02, $07, $11, $61,
    $11, $02, $09, $11, $61, $11, $02, $0B,
    $11, $61, $11, $02, $0C, $11, $61, $11,
    $02, $0E, $11, $61, $11, $02, $0F, $11,
    $61, $11, $02, $10, $11, $61, $11, $02,
    $11, $11, $61, $11, $02, $12, $11, $61,

    $11, $05, $0E, $11, $61, $11, $B7, $11,
    $00, $11, $69, $11, $04, $0C, $11, $6E,
    $11, $0B, $11, $74, $11, $02, $0B, $11,
    $6E, $11, $01, $94, $4E, $01, $6D, $51,
    $01, $03, $4E, $01, $5D, $4E, $01, $2A,
    $68, $01, $09, $67, $01, $3E, $79, $01,
    $0D, $54, $01, $79, $72, $01, $A1, $8C,
    $01, $5D, $79, $01, $B4, $52, $01, $D8,

    $79, $01, $37, $75, $01, $69, $90, $01,
    $2A, $51, $01, $70, $53, $01, $E8, $6C,
    $01, $05, $98, $01, $11, $4F, $01, $99,
    $51, $01, $63, $6B, $01, $E6, $5D, $01,
    $F3, $53, $01, $3B, $53, $01, $97, $5B,
    $01, $66, $5B, $01, $E3, $76, $01, $01,
    $4F, $01, $C7, $8C, $01, $54, $53, $01,
    $1C, $59, $02, $33, $00, $36, $00, $02,

    $33, $00, $37, $00, $02, $33, $00, $38,
    $00, $02, $33, $00, $39, $00, $02, $34,
    $00, $30, $00, $02, $34, $00, $31, $00,
    $02, $34, $00, $32, $00, $02, $34, $00,
    $33, $00, $02, $34, $00, $34, $00, $02,
    $34, $00, $35, $00, $02, $34, $00, $36,
    $00, $02, $34, $00, $37, $00, $02, $34,
    $00, $38, $00, $02, $34, $00, $39, $00,

    $02, $35, $00, $30, $00, $02, $31, $00,
    $08, $67, $02, $32, $00, $08, $67, $02,
    $33, $00, $08, $67, $02, $34, $00, $08,
    $67, $02, $35, $00, $08, $67, $02, $36,
    $00, $08, $67, $02, $37, $00, $08, $67,
    $02, $38, $00, $08, $67, $02, $39, $00,
    $08, $67, $03, $31, $00, $30, $00, $08,
    $67, $03, $31, $00, $31, $00, $08, $67,

    $03, $31, $00, $32, $00, $08, $67, $02,
    $48, $00, $67, $00, $03, $65, $00, $72,
    $00, $67, $00, $02, $65, $00, $56, $00,
    $03, $4C, $00, $54, $00, $44, $00, $01,
    $A2, $30, $01, $A4, $30, $01, $A6, $30,
    $01, $A8, $30, $01, $AA, $30, $01, $AB,
    $30, $01, $AD, $30, $01, $AF, $30, $01,
    $B1, $30, $01, $B3, $30, $01, $B5, $30,

    $01, $B7, $30, $01, $B9, $30, $01, $BB,
    $30, $01, $BD, $30, $01, $BF, $30, $01,
    $C1, $30, $01, $C4, $30, $01, $C6, $30,
    $01, $C8, $30, $01, $CA, $30, $01, $CB,
    $30, $01, $CC, $30, $01, $CD, $30, $01,
    $CE, $30, $01, $CF, $30, $01, $D2, $30,
    $01, $D5, $30, $01, $D8, $30, $01, $DB,
    $30, $01, $DE, $30, $01, $DF, $30, $01,

    $E0, $30, $01, $E1, $30, $01, $E2, $30,
    $01, $E4, $30, $01, $E6, $30, $01, $E8,
    $30, $01, $E9, $30, $01, $EA, $30, $01,
    $EB, $30, $01, $EC, $30, $01, $ED, $30,
    $01, $EF, $30, $01, $F0, $30, $01, $F1,
    $30, $01, $F2, $30, $05, $A2, $30, $CF,
    $30, $9A, $30, $FC, $30, $C8, $30, $04,
    $A2, $30, $EB, $30, $D5, $30, $A1, $30,

    $05, $A2, $30, $F3, $30, $D8, $30, $9A,
    $30, $A2, $30, $03, $A2, $30, $FC, $30,
    $EB, $30, $05, $A4, $30, $CB, $30, $F3,
    $30, $AF, $30, $99, $30, $03, $A4, $30,
    $F3, $30, $C1, $30, $03, $A6, $30, $A9,
    $30, $F3, $30, $06, $A8, $30, $B9, $30,
    $AF, $30, $FC, $30, $C8, $30, $99, $30,
    $04, $A8, $30, $FC, $30, $AB, $30, $FC,

    $30, $03, $AA, $30, $F3, $30, $B9, $30,
    $03, $AA, $30, $FC, $30, $E0, $30, $03,
    $AB, $30, $A4, $30, $EA, $30, $04, $AB,
    $30, $E9, $30, $C3, $30, $C8, $30, $04,
    $AB, $30, $ED, $30, $EA, $30, $FC, $30,
    $04, $AB, $30, $99, $30, $ED, $30, $F3,
    $30, $04, $AB, $30, $99, $30, $F3, $30,
    $DE, $30, $04, $AD, $30, $99, $30, $AB,

    $30, $99, $30, $04, $AD, $30, $99, $30,
    $CB, $30, $FC, $30, $04, $AD, $30, $E5,
    $30, $EA, $30, $FC, $30, $06, $AD, $30,
    $99, $30, $EB, $30, $BF, $30, $99, $30,
    $FC, $30, $02, $AD, $30, $ED, $30, $06,
    $AD, $30, $ED, $30, $AF, $30, $99, $30,
    $E9, $30, $E0, $30, $06, $AD, $30, $ED,
    $30, $E1, $30, $FC, $30, $C8, $30, $EB,

    $30, $05, $AD, $30, $ED, $30, $EF, $30,
    $C3, $30, $C8, $30, $04, $AF, $30, $99,
    $30, $E9, $30, $E0, $30, $06, $AF, $30,
    $99, $30, $E9, $30, $E0, $30, $C8, $30,
    $F3, $30, $06, $AF, $30, $EB, $30, $BB,
    $30, $99, $30, $A4, $30, $ED, $30, $04,
    $AF, $30, $ED, $30, $FC, $30, $CD, $30,
    $03, $B1, $30, $FC, $30, $B9, $30, $03,

    $B3, $30, $EB, $30, $CA, $30, $04, $B3,
    $30, $FC, $30, $DB, $30, $9A, $30, $04,
    $B5, $30, $A4, $30, $AF, $30, $EB, $30,
    $05, $B5, $30, $F3, $30, $C1, $30, $FC,
    $30, $E0, $30, $05, $B7, $30, $EA, $30,
    $F3, $30, $AF, $30, $99, $30, $03, $BB,
    $30, $F3, $30, $C1, $30, $03, $BB, $30,
    $F3, $30, $C8, $30, $04, $BF, $30, $99,

    $30, $FC, $30, $B9, $30, $03, $C6, $30,
    $99, $30, $B7, $30, $03, $C8, $30, $99,
    $30, $EB, $30, $02, $C8, $30, $F3, $30,
    $02, $CA, $30, $CE, $30, $03, $CE, $30,
    $C3, $30, $C8, $30, $03, $CF, $30, $A4,
    $30, $C4, $30, $06, $CF, $30, $9A, $30,
    $FC, $30, $BB, $30, $F3, $30, $C8, $30,
    $04, $CF, $30, $9A, $30, $FC, $30, $C4,

    $30, $05, $CF, $30, $99, $30, $FC, $30,
    $EC, $30, $EB, $30, $06, $D2, $30, $9A,
    $30, $A2, $30, $B9, $30, $C8, $30, $EB,
    $30, $04, $D2, $30, $9A, $30, $AF, $30,
    $EB, $30, $03, $D2, $30, $9A, $30, $B3,
    $30, $03, $D2, $30, $99, $30, $EB, $30,
    $06, $D5, $30, $A1, $30, $E9, $30, $C3,
    $30, $C8, $30, $99, $30, $04, $D5, $30,

    $A3, $30, $FC, $30, $C8, $30, $06, $D5,
    $30, $99, $30, $C3, $30, $B7, $30, $A7,
    $30, $EB, $30, $03, $D5, $30, $E9, $30,
    $F3, $30, $05, $D8, $30, $AF, $30, $BF,
    $30, $FC, $30, $EB, $30, $03, $D8, $30,
    $9A, $30, $BD, $30, $04, $D8, $30, $9A,
    $30, $CB, $30, $D2, $30, $03, $D8, $30,
    $EB, $30, $C4, $30, $04, $D8, $30, $9A,

    $30, $F3, $30, $B9, $30, $05, $D8, $30,
    $9A, $30, $FC, $30, $B7, $30, $99, $30,
    $04, $D8, $30, $99, $30, $FC, $30, $BF,
    $30, $05, $DB, $30, $9A, $30, $A4, $30,
    $F3, $30, $C8, $30, $04, $DB, $30, $99,
    $30, $EB, $30, $C8, $30, $02, $DB, $30,
    $F3, $30, $05, $DB, $30, $9A, $30, $F3,
    $30, $C8, $30, $99, $30, $03, $DB, $30,

    $FC, $30, $EB, $30, $03, $DB, $30, $FC,
    $30, $F3, $30, $04, $DE, $30, $A4, $30,
    $AF, $30, $ED, $30, $03, $DE, $30, $A4,
    $30, $EB, $30, $03, $DE, $30, $C3, $30,
    $CF, $30, $03, $DE, $30, $EB, $30, $AF,
    $30, $05, $DE, $30, $F3, $30, $B7, $30,
    $E7, $30, $F3, $30, $04, $DF, $30, $AF,
    $30, $ED, $30, $F3, $30, $02, $DF, $30,

    $EA, $30, $06, $DF, $30, $EA, $30, $CF,
    $30, $99, $30, $FC, $30, $EB, $30, $03,
    $E1, $30, $AB, $30, $99, $30, $05, $E1,
    $30, $AB, $30, $99, $30, $C8, $30, $F3,
    $30, $04, $E1, $30, $FC, $30, $C8, $30,
    $EB, $30, $04, $E4, $30, $FC, $30, $C8,
    $30, $99, $30, $03, $E4, $30, $FC, $30,
    $EB, $30, $03, $E6, $30, $A2, $30, $F3,

    $30, $04, $EA, $30, $C3, $30, $C8, $30,
    $EB, $30, $02, $EA, $30, $E9, $30, $04,
    $EB, $30, $D2, $30, $9A, $30, $FC, $30,
    $05, $EB, $30, $FC, $30, $D5, $30, $99,
    $30, $EB, $30, $02, $EC, $30, $E0, $30,
    $06, $EC, $30, $F3, $30, $C8, $30, $B1,
    $30, $99, $30, $F3, $30, $03, $EF, $30,
    $C3, $30, $C8, $30, $02, $30, $00, $B9,

    $70, $02, $31, $00, $B9, $70, $02, $32,
    $00, $B9, $70, $02, $33, $00, $B9, $70,
    $02, $34, $00, $B9, $70, $02, $35, $00,
    $B9, $70, $02, $36, $00, $B9, $70, $02,
    $37, $00, $B9, $70, $02, $38, $00, $B9,
    $70, $02, $39, $00, $B9, $70, $03, $31,
    $00, $30, $00, $B9, $70, $03, $31, $00,
    $31, $00, $B9, $70, $03, $31, $00, $32,

    $00, $B9, $70, $03, $31, $00, $33, $00,
    $B9, $70, $03, $31, $00, $34, $00, $B9,
    $70, $03, $31, $00, $35, $00, $B9, $70,
    $03, $31, $00, $36, $00, $B9, $70, $03,
    $31, $00, $37, $00, $B9, $70, $03, $31,
    $00, $38, $00, $B9, $70, $03, $31, $00,
    $39, $00, $B9, $70, $03, $32, $00, $30,
    $00, $B9, $70, $03, $32, $00, $31, $00,

    $B9, $70, $03, $32, $00, $32, $00, $B9,
    $70, $03, $32, $00, $33, $00, $B9, $70,
    $03, $32, $00, $34, $00, $B9, $70, $03,
    $68, $00, $50, $00, $61, $00, $02, $64,
    $00, $61, $00, $02, $41, $00, $55, $00,
    $03, $62, $00, $61, $00, $72, $00, $02,
    $6F, $00, $56, $00, $02, $70, $00, $63,
    $00, $02, $64, $00, $6D, $00, $03, $64,

    $00, $6D, $00, $32, $00, $03, $64, $00,
    $6D, $00, $33, $00, $02, $49, $00, $55,
    $00, $02, $73, $5E, $10, $62, $02, $2D,
    $66, $8C, $54, $02, $27, $59, $63, $6B,
    $02, $0E, $66, $BB, $6C, $04, $2A, $68,
    $0F, $5F, $1A, $4F, $3E, $79, $02, $70,
    $00, $41, $00, $02, $6E, $00, $41, $00,
    $02, $BC, $03, $41, $00, $02, $6D, $00,

    $41, $00, $02, $6B, $00, $41, $00, $02,
    $4B, $00, $42, $00, $02, $4D, $00, $42,
    $00, $02, $47, $00, $42, $00, $03, $63,
    $00, $61, $00, $6C, $00, $04, $6B, $00,
    $63, $00, $61, $00, $6C, $00, $02, $70,
    $00, $46, $00, $02, $6E, $00, $46, $00,
    $02, $BC, $03, $46, $00, $02, $BC, $03,
    $67, $00, $02, $6D, $00, $67, $00, $02,

    $6B, $00, $67, $00, $02, $48, $00, $7A,
    $00, $03, $6B, $00, $48, $00, $7A, $00,
    $03, $4D, $00, $48, $00, $7A, $00, $03,
    $47, $00, $48, $00, $7A, $00, $03, $54,
    $00, $48, $00, $7A, $00, $02, $BC, $03,
    $6C, $00, $02, $6D, $00, $6C, $00, $02,
    $64, $00, $6C, $00, $02, $6B, $00, $6C,
    $00, $02, $66, $00, $6D, $00, $02, $6E,

    $00, $6D, $00, $02, $BC, $03, $6D, $00,
    $02, $6D, $00, $6D, $00, $02, $63, $00,
    $6D, $00, $02, $6B, $00, $6D, $00, $03,
    $6D, $00, $6D, $00, $32, $00, $03, $63,
    $00, $6D, $00, $32, $00, $02, $6D, $00,
    $32, $00, $03, $6B, $00, $6D, $00, $32,
    $00, $03, $6D, $00, $6D, $00, $33, $00,
    $03, $63, $00, $6D, $00, $33, $00, $02,

    $6D, $00, $33, $00, $03, $6B, $00, $6D,
    $00, $33, $00, $03, $6D, $00, $15, $22,
    $73, $00, $04, $6D, $00, $15, $22, $73,
    $00, $32, $00, $02, $50, $00, $61, $00,
    $03, $6B, $00, $50, $00, $61, $00, $03,
    $4D, $00, $50, $00, $61, $00, $03, $47,
    $00, $50, $00, $61, $00, $03, $72, $00,
    $61, $00, $64, $00, $05, $72, $00, $61,

    $00, $64, $00, $15, $22, $73, $00, $06,
    $72, $00, $61, $00, $64, $00, $15, $22,
    $73, $00, $32, $00, $02, $70, $00, $73,
    $00, $02, $6E, $00, $73, $00, $02, $BC,
    $03, $73, $00, $02, $6D, $00, $73, $00,
    $02, $70, $00, $56, $00, $02, $6E, $00,
    $56, $00, $02, $BC, $03, $56, $00, $02,
    $6D, $00, $56, $00, $02, $6B, $00, $56,

    $00, $02, $4D, $00, $56, $00, $02, $70,
    $00, $57, $00, $02, $6E, $00, $57, $00,
    $02, $BC, $03, $57, $00, $02, $6D, $00,
    $57, $00, $02, $6B, $00, $57, $00, $02,
    $4D, $00, $57, $00, $02, $6B, $00, $A9,
    $03, $02, $4D, $00, $A9, $03, $04, $61,
    $00, $2E, $00, $6D, $00, $2E, $00, $02,
    $42, $00, $71, $00, $02, $63, $00, $63,

    $00, $02, $63, $00, $64, $00, $04, $43,
    $00, $15, $22, $6B, $00, $67, $00, $03,
    $43, $00, $6F, $00, $2E, $00, $02, $64,
    $00, $42, $00, $02, $47, $00, $79, $00,
    $02, $68, $00, $61, $00, $02, $48, $00,
    $50, $00, $02, $69, $00, $6E, $00, $02,
    $4B, $00, $4B, $00, $02, $4B, $00, $4D,
    $00, $02, $6B, $00, $74, $00, $02, $6C,

    $00, $6D, $00, $02, $6C, $00, $6E, $00,
    $03, $6C, $00, $6F, $00, $67, $00, $02,
    $6C, $00, $78, $00, $02, $6D, $00, $62,
    $00, $03, $6D, $00, $69, $00, $6C, $00,
    $03, $6D, $00, $6F, $00, $6C, $00, $02,
    $50, $00, $48, $00, $04, $70, $00, $2E,
    $00, $6D, $00, $2E, $00, $03, $50, $00,
    $50, $00, $4D, $00, $02, $50, $00, $52,

    $00, $02, $73, $00, $72, $00, $02, $53,
    $00, $76, $00, $02, $57, $00, $62, $00,
    $03, $56, $00, $15, $22, $6D, $00, $03,
    $41, $00, $15, $22, $6D, $00, $02, $31,
    $00, $E5, $65, $02, $32, $00, $E5, $65,
    $02, $33, $00, $E5, $65, $02, $34, $00,
    $E5, $65, $02, $35, $00, $E5, $65, $02,
    $36, $00, $E5, $65, $02, $37, $00, $E5,

    $65, $02, $38, $00, $E5, $65, $02, $39,
    $00, $E5, $65, $03, $31, $00, $30, $00,
    $E5, $65, $03, $31, $00, $31, $00, $E5,
    $65, $03, $31, $00, $32, $00, $E5, $65,
    $03, $31, $00, $33, $00, $E5, $65, $03,
    $31, $00, $34, $00, $E5, $65, $03, $31,
    $00, $35, $00, $E5, $65, $03, $31, $00,
    $36, $00, $E5, $65, $03, $31, $00, $37,

    $00, $E5, $65, $03, $31, $00, $38, $00,
    $E5, $65, $03, $31, $00, $39, $00, $E5,
    $65, $03, $32, $00, $30, $00, $E5, $65,
    $03, $32, $00, $31, $00, $E5, $65, $03,
    $32, $00, $32, $00, $E5, $65, $03, $32,
    $00, $33, $00, $E5, $65, $03, $32, $00,
    $34, $00, $E5, $65, $03, $32, $00, $35,
    $00, $E5, $65, $03, $32, $00, $36, $00,

    $E5, $65, $03, $32, $00, $37, $00, $E5,
    $65, $03, $32, $00, $38, $00, $E5, $65,
    $03, $32, $00, $39, $00, $E5, $65, $03,
    $33, $00, $30, $00, $E5, $65, $03, $33,
    $00, $31, $00, $E5, $65, $03, $67, $00,
    $61, $00, $6C, $00, $01, $4A, $04, $01,
    $4C, $04, $01, $6F, $A7, $01, $26, $01,
    $01, $53, $01, $01, $27, $A7, $01, $37,

    $AB, $01, $6B, $02, $01, $52, $AB, $02,
    $66, $00, $66, $00, $02, $66, $00, $69,
    $00, $02, $66, $00, $6C, $00, $03, $66,
    $00, $66, $00, $69, $00, $03, $66, $00,
    $66, $00, $6C, $00, $02, $73, $00, $74,
    $00, $02, $74, $05, $76, $05, $02, $74,
    $05, $65, $05, $02, $74, $05, $6B, $05,
    $02, $7E, $05, $76, $05, $02, $74, $05,

    $6D, $05, $01, $E2, $05, $01, $D4, $05,
    $01, $DB, $05, $01, $DC, $05, $01, $DD,
    $05, $01, $E8, $05, $01, $EA, $05, $02,
    $D0, $05, $DC, $05, $01, $71, $06, $01,
    $7B, $06, $01, $7E, $06, $01, $80, $06,
    $01, $7A, $06, $01, $7F, $06, $01, $79,
    $06, $01, $A4, $06, $01, $A6, $06, $01,
    $84, $06, $01, $83, $06, $01, $86, $06,

    $01, $87, $06, $01, $8D, $06, $01, $8C,
    $06, $01, $8E, $06, $01, $88, $06, $01,
    $98, $06, $01, $91, $06, $01, $A9, $06,
    $01, $AF, $06, $01, $B3, $06, $01, $B1,
    $06, $01, $BA, $06, $01, $BB, $06, $02,
    $D5, $06, $54, $06, $01, $C1, $06, $01,
    $BE, $06, $01, $D2, $06, $02, $D2, $06,
    $54, $06, $01, $AD, $06, $01, $C7, $06,

    $01, $C6, $06, $01, $C8, $06, $01, $CB,
    $06, $01, $C5, $06, $01, $C9, $06, $01,
    $D0, $06, $01, $49, $06, $03, $4A, $06,
    $54, $06, $27, $06, $03, $4A, $06, $54,
    $06, $D5, $06, $03, $4A, $06, $54, $06,
    $48, $06, $03, $4A, $06, $54, $06, $C7,
    $06, $03, $4A, $06, $54, $06, $C6, $06,
    $03, $4A, $06, $54, $06, $C8, $06, $03,

    $4A, $06, $54, $06, $D0, $06, $03, $4A,
    $06, $54, $06, $49, $06, $01, $CC, $06,
    $03, $4A, $06, $54, $06, $2C, $06, $03,
    $4A, $06, $54, $06, $2D, $06, $03, $4A,
    $06, $54, $06, $45, $06, $03, $4A, $06,
    $54, $06, $4A, $06, $02, $28, $06, $2C,
    $06, $02, $28, $06, $2D, $06, $02, $28,
    $06, $2E, $06, $02, $28, $06, $45, $06,

    $02, $28, $06, $49, $06, $02, $28, $06,
    $4A, $06, $02, $2A, $06, $2C, $06, $02,
    $2A, $06, $2D, $06, $02, $2A, $06, $2E,
    $06, $02, $2A, $06, $45, $06, $02, $2A,
    $06, $49, $06, $02, $2A, $06, $4A, $06,
    $02, $2B, $06, $2C, $06, $02, $2B, $06,
    $45, $06, $02, $2B, $06, $49, $06, $02,
    $2B, $06, $4A, $06, $02, $2C, $06, $2D,

    $06, $02, $2C, $06, $45, $06, $02, $2D,
    $06, $2C, $06, $02, $2D, $06, $45, $06,
    $02, $2E, $06, $2C, $06, $02, $2E, $06,
    $2D, $06, $02, $2E, $06, $45, $06, $02,
    $33, $06, $2C, $06, $02, $33, $06, $2D,
    $06, $02, $33, $06, $2E, $06, $02, $33,
    $06, $45, $06, $02, $35, $06, $2D, $06,
    $02, $35, $06, $45, $06, $02, $36, $06,

    $2C, $06, $02, $36, $06, $2D, $06, $02,
    $36, $06, $2E, $06, $02, $36, $06, $45,
    $06, $02, $37, $06, $2D, $06, $02, $37,
    $06, $45, $06, $02, $38, $06, $45, $06,
    $02, $39, $06, $2C, $06, $02, $39, $06,
    $45, $06, $02, $3A, $06, $2C, $06, $02,
    $3A, $06, $45, $06, $02, $41, $06, $2C,
    $06, $02, $41, $06, $2D, $06, $02, $41,

    $06, $2E, $06, $02, $41, $06, $45, $06,
    $02, $41, $06, $49, $06, $02, $41, $06,
    $4A, $06, $02, $42, $06, $2D, $06, $02,
    $42, $06, $45, $06, $02, $42, $06, $49,
    $06, $02, $42, $06, $4A, $06, $02, $43,
    $06, $27, $06, $02, $43, $06, $2C, $06,
    $02, $43, $06, $2D, $06, $02, $43, $06,
    $2E, $06, $02, $43, $06, $44, $06, $02,

    $43, $06, $45, $06, $02, $43, $06, $49,
    $06, $02, $43, $06, $4A, $06, $02, $44,
    $06, $2C, $06, $02, $44, $06, $2D, $06,
    $02, $44, $06, $2E, $06, $02, $44, $06,
    $45, $06, $02, $44, $06, $49, $06, $02,
    $44, $06, $4A, $06, $02, $45, $06, $2C,
    $06, $02, $45, $06, $2D, $06, $02, $45,
    $06, $2E, $06, $02, $45, $06, $45, $06,

    $02, $45, $06, $49, $06, $02, $45, $06,
    $4A, $06, $02, $46, $06, $2C, $06, $02,
    $46, $06, $2D, $06, $02, $46, $06, $2E,
    $06, $02, $46, $06, $45, $06, $02, $46,
    $06, $49, $06, $02, $46, $06, $4A, $06,
    $02, $47, $06, $2C, $06, $02, $47, $06,
    $45, $06, $02, $47, $06, $49, $06, $02,
    $47, $06, $4A, $06, $02, $4A, $06, $2C,

    $06, $02, $4A, $06, $2D, $06, $02, $4A,
    $06, $2E, $06, $02, $4A, $06, $45, $06,
    $02, $4A, $06, $49, $06, $02, $4A, $06,
    $4A, $06, $02, $30, $06, $70, $06, $02,
    $31, $06, $70, $06, $02, $49, $06, $70,
    $06, $03, $20, $00, $4C, $06, $51, $06,
    $03, $20, $00, $4D, $06, $51, $06, $03,
    $20, $00, $4E, $06, $51, $06, $03, $20,

    $00, $4F, $06, $51, $06, $03, $20, $00,
    $50, $06, $51, $06, $03, $20, $00, $51,
    $06, $70, $06, $03, $4A, $06, $54, $06,
    $31, $06, $03, $4A, $06, $54, $06, $32,
    $06, $03, $4A, $06, $54, $06, $46, $06,
    $02, $28, $06, $31, $06, $02, $28, $06,
    $32, $06, $02, $28, $06, $46, $06, $02,
    $2A, $06, $31, $06, $02, $2A, $06, $32,

    $06, $02, $2A, $06, $46, $06, $02, $2B,
    $06, $31, $06, $02, $2B, $06, $32, $06,
    $02, $2B, $06, $46, $06, $02, $45, $06,
    $27, $06, $02, $46, $06, $31, $06, $02,
    $46, $06, $32, $06, $02, $46, $06, $46,
    $06, $02, $4A, $06, $31, $06, $02, $4A,
    $06, $32, $06, $02, $4A, $06, $46, $06,
    $03, $4A, $06, $54, $06, $2E, $06, $03,

    $4A, $06, $54, $06, $47, $06, $02, $28,
    $06, $47, $06, $02, $2A, $06, $47, $06,
    $02, $35, $06, $2E, $06, $02, $44, $06,
    $47, $06, $02, $46, $06, $47, $06, $02,
    $47, $06, $70, $06, $02, $4A, $06, $47,
    $06, $02, $2B, $06, $47, $06, $02, $33,
    $06, $47, $06, $02, $34, $06, $45, $06,
    $02, $34, $06, $47, $06, $03, $40, $06,

    $4E, $06, $51, $06, $03, $40, $06, $4F,
    $06, $51, $06, $03, $40, $06, $50, $06,
    $51, $06, $02, $37, $06, $49, $06, $02,
    $37, $06, $4A, $06, $02, $39, $06, $49,
    $06, $02, $39, $06, $4A, $06, $02, $3A,
    $06, $49, $06, $02, $3A, $06, $4A, $06,
    $02, $33, $06, $49, $06, $02, $33, $06,
    $4A, $06, $02, $34, $06, $49, $06, $02,

    $34, $06, $4A, $06, $02, $2D, $06, $49,
    $06, $02, $2D, $06, $4A, $06, $02, $2C,
    $06, $49, $06, $02, $2C, $06, $4A, $06,
    $02, $2E, $06, $49, $06, $02, $2E, $06,
    $4A, $06, $02, $35, $06, $49, $06, $02,
    $35, $06, $4A, $06, $02, $36, $06, $49,
    $06, $02, $36, $06, $4A, $06, $02, $34,
    $06, $2C, $06, $02, $34, $06, $2D, $06,

    $02, $34, $06, $2E, $06, $02, $34, $06,
    $31, $06, $02, $33, $06, $31, $06, $02,
    $35, $06, $31, $06, $02, $36, $06, $31,
    $06, $02, $27, $06, $4B, $06, $03, $2A,
    $06, $2C, $06, $45, $06, $03, $2A, $06,
    $2D, $06, $2C, $06, $03, $2A, $06, $2D,
    $06, $45, $06, $03, $2A, $06, $2E, $06,
    $45, $06, $03, $2A, $06, $45, $06, $2C,

    $06, $03, $2A, $06, $45, $06, $2D, $06,
    $03, $2A, $06, $45, $06, $2E, $06, $03,
    $2C, $06, $45, $06, $2D, $06, $03, $2D,
    $06, $45, $06, $4A, $06, $03, $2D, $06,
    $45, $06, $49, $06, $03, $33, $06, $2D,
    $06, $2C, $06, $03, $33, $06, $2C, $06,
    $2D, $06, $03, $33, $06, $2C, $06, $49,
    $06, $03, $33, $06, $45, $06, $2D, $06,

    $03, $33, $06, $45, $06, $2C, $06, $03,
    $33, $06, $45, $06, $45, $06, $03, $35,
    $06, $2D, $06, $2D, $06, $03, $35, $06,
    $45, $06, $45, $06, $03, $34, $06, $2D,
    $06, $45, $06, $03, $34, $06, $2C, $06,
    $4A, $06, $03, $34, $06, $45, $06, $2E,
    $06, $03, $34, $06, $45, $06, $45, $06,
    $03, $36, $06, $2D, $06, $49, $06, $03,

    $36, $06, $2E, $06, $45, $06, $03, $37,
    $06, $45, $06, $2D, $06, $03, $37, $06,
    $45, $06, $45, $06, $03, $37, $06, $45,
    $06, $4A, $06, $03, $39, $06, $2C, $06,
    $45, $06, $03, $39, $06, $45, $06, $45,
    $06, $03, $39, $06, $45, $06, $49, $06,
    $03, $3A, $06, $45, $06, $45, $06, $03,
    $3A, $06, $45, $06, $4A, $06, $03, $3A,

    $06, $45, $06, $49, $06, $03, $41, $06,
    $2E, $06, $45, $06, $03, $42, $06, $45,
    $06, $2D, $06, $03, $42, $06, $45, $06,
    $45, $06, $03, $44, $06, $2D, $06, $45,
    $06, $03, $44, $06, $2D, $06, $4A, $06,
    $03, $44, $06, $2D, $06, $49, $06, $03,
    $44, $06, $2C, $06, $2C, $06, $03, $44,
    $06, $2E, $06, $45, $06, $03, $44, $06,

    $45, $06, $2D, $06, $03, $45, $06, $2D,
    $06, $2C, $06, $03, $45, $06, $2D, $06,
    $45, $06, $03, $45, $06, $2D, $06, $4A,
    $06, $03, $45, $06, $2C, $06, $2D, $06,
    $03, $45, $06, $2C, $06, $45, $06, $03,
    $45, $06, $2E, $06, $2C, $06, $03, $45,
    $06, $2E, $06, $45, $06, $03, $45, $06,
    $2C, $06, $2E, $06, $03, $47, $06, $45,

    $06, $2C, $06, $03, $47, $06, $45, $06,
    $45, $06, $03, $46, $06, $2D, $06, $45,
    $06, $03, $46, $06, $2D, $06, $49, $06,
    $03, $46, $06, $2C, $06, $45, $06, $03,
    $46, $06, $2C, $06, $49, $06, $03, $46,
    $06, $45, $06, $4A, $06, $03, $46, $06,
    $45, $06, $49, $06, $03, $4A, $06, $45,
    $06, $45, $06, $03, $28, $06, $2E, $06,

    $4A, $06, $03, $2A, $06, $2C, $06, $4A,
    $06, $03, $2A, $06, $2C, $06, $49, $06,
    $03, $2A, $06, $2E, $06, $4A, $06, $03,
    $2A, $06, $2E, $06, $49, $06, $03, $2A,
    $06, $45, $06, $4A, $06, $03, $2A, $06,
    $45, $06, $49, $06, $03, $2C, $06, $45,
    $06, $4A, $06, $03, $2C, $06, $2D, $06,
    $49, $06, $03, $2C, $06, $45, $06, $49,

    $06, $03, $33, $06, $2E, $06, $49, $06,
    $03, $35, $06, $2D, $06, $4A, $06, $03,
    $34, $06, $2D, $06, $4A, $06, $03, $36,
    $06, $2D, $06, $4A, $06, $03, $44, $06,
    $2C, $06, $4A, $06, $03, $44, $06, $45,
    $06, $4A, $06, $03, $4A, $06, $2D, $06,
    $4A, $06, $03, $4A, $06, $2C, $06, $4A,
    $06, $03, $4A, $06, $45, $06, $4A, $06,

    $03, $45, $06, $45, $06, $4A, $06, $03,
    $42, $06, $45, $06, $4A, $06, $03, $46,
    $06, $2D, $06, $4A, $06, $03, $39, $06,
    $45, $06, $4A, $06, $03, $43, $06, $45,
    $06, $4A, $06, $03, $46, $06, $2C, $06,
    $2D, $06, $03, $45, $06, $2E, $06, $4A,
    $06, $03, $44, $06, $2C, $06, $45, $06,
    $03, $43, $06, $45, $06, $45, $06, $03,

    $2C, $06, $2D, $06, $4A, $06, $03, $2D,
    $06, $2C, $06, $4A, $06, $03, $45, $06,
    $2C, $06, $4A, $06, $03, $41, $06, $45,
    $06, $4A, $06, $03, $28, $06, $2D, $06,
    $4A, $06, $03, $33, $06, $2E, $06, $4A,
    $06, $03, $46, $06, $2C, $06, $4A, $06,
    $03, $35, $06, $44, $06, $D2, $06, $03,
    $42, $06, $44, $06, $D2, $06, $04, $27,

    $06, $44, $06, $44, $06, $47, $06, $04,
    $27, $06, $43, $06, $28, $06, $31, $06,
    $04, $45, $06, $2D, $06, $45, $06, $2F,
    $06, $04, $35, $06, $44, $06, $39, $06,
    $45, $06, $04, $31, $06, $33, $06, $48,
    $06, $44, $06, $04, $39, $06, $44, $06,
    $4A, $06, $47, $06, $04, $48, $06, $33,
    $06, $44, $06, $45, $06, $03, $35, $06,

    $44, $06, $49, $06, $12, $35, $06, $44,
    $06, $49, $06, $20, $00, $27, $06, $44,
    $06, $44, $06, $47, $06, $20, $00, $39,
    $06, $44, $06, $4A, $06, $47, $06, $20,
    $00, $48, $06, $33, $06, $44, $06, $45,
    $06, $08, $2C, $06, $44, $06, $20, $00,
    $2C, $06, $44, $06, $27, $06, $44, $06,
    $47, $06, $04, $31, $06, $CC, $06, $27,

    $06, $44, $06, $01, $2C, $00, $01, $01,
    $30, $01, $02, $30, $01, $3A, $00, $01,
    $3B, $00, $01, $21, $00, $01, $3F, $00,
    $01, $16, $30, $01, $17, $30, $01, $14,
    $20, $01, $13, $20, $01, $5F, $00, $01,
    $7B, $00, $01, $7D, $00, $01, $14, $30,
    $01, $15, $30, $01, $10, $30, $01, $11,
    $30, $01, $0A, $30, $01, $0B, $30, $01,

    $08, $30, $01, $09, $30, $01, $0C, $30,
    $01, $0D, $30, $01, $0E, $30, $01, $0F,
    $30, $01, $5B, $00, $01, $5D, $00, $01,
    $23, $00, $01, $26, $00, $01, $2A, $00,
    $01, $2D, $00, $01, $3C, $00, $01, $3E,
    $00, $01, $5C, $00, $01, $24, $00, $01,
    $25, $00, $01, $40, $00, $02, $20, $00,
    $4B, $06, $02, $40, $06, $4B, $06, $02,

    $20, $00, $4C, $06, $02, $20, $00, $4D,
    $06, $02, $20, $00, $4E, $06, $02, $40,
    $06, $4E, $06, $02, $20, $00, $4F, $06,
    $02, $40, $06, $4F, $06, $02, $20, $00,
    $50, $06, $02, $40, $06, $50, $06, $02,
    $20, $00, $51, $06, $02, $40, $06, $51,
    $06, $02, $20, $00, $52, $06, $02, $40,
    $06, $52, $06, $01, $21, $06, $02, $27,

    $06, $53, $06, $02, $27, $06, $54, $06,
    $02, $48, $06, $54, $06, $02, $27, $06,
    $55, $06, $02, $4A, $06, $54, $06, $01,
    $27, $06, $01, $28, $06, $01, $29, $06,
    $01, $2A, $06, $01, $2B, $06, $01, $2C,
    $06, $01, $2D, $06, $01, $2E, $06, $01,
    $2F, $06, $01, $30, $06, $01, $31, $06,
    $01, $32, $06, $01, $33, $06, $01, $34,

    $06, $01, $35, $06, $01, $36, $06, $01,
    $37, $06, $01, $38, $06, $01, $39, $06,
    $01, $3A, $06, $01, $41, $06, $01, $42,
    $06, $01, $43, $06, $01, $44, $06, $01,
    $45, $06, $01, $46, $06, $01, $47, $06,
    $01, $48, $06, $01, $4A, $06, $03, $44,
    $06, $27, $06, $53, $06, $03, $44, $06,
    $27, $06, $54, $06, $03, $44, $06, $27,

    $06, $55, $06, $02, $44, $06, $27, $06,
    $01, $22, $00, $01, $27, $00, $01, $2F,
    $00, $01, $5E, $00, $01, $60, $00, $01,
    $7C, $00, $01, $7E, $00, $01, $85, $29,
    $01, $86, $29, $01, $FB, $30, $01, $A1,
    $30, $01, $A3, $30, $01, $A5, $30, $01,
    $A7, $30, $01, $A9, $30, $01, $E3, $30,
    $01, $E5, $30, $01, $E7, $30, $01, $C3,

    $30, $01, $FC, $30, $01, $F3, $30, $01,
    $99, $30, $01, $9A, $30, $01, $A2, $00,
    $01, $A3, $00, $01, $AC, $00, $01, $A6,
    $00, $01, $A5, $00, $01, $A9, $20, $01,
    $02, $25, $01, $90, $21, $01, $91, $21,
    $01, $92, $21, $01, $93, $21, $01, $A0,
    $25, $01, $CB, $25);
var
  i: Cardinal;
begin
  if (c >= #$A0) and (c <= #$FFEE) then
    begin
      i := CHAR_COMPATIBLE_DECOMPOSITION_1[(Ord(c) - $A0) div CHAR_COMPATIBLE_DECOMPOSITION_SIZE];
      if i <> 0 then
        begin
          Dec(i);
          i := CHAR_COMPATIBLE_DECOMPOSITION_2[i, Ord(c) and (CHAR_COMPATIBLE_DECOMPOSITION_SIZE - 1)];
          if i <> 0 then
            begin
              Result := Pointer(@CHAR_COMPATIBLE_DECOMPOSITION_DATA[i]);
              Exit;
            end;
        end;
  end;
  Result := CharDecomposeCanonicalW(c);
end;

{$IFDEF COMPILER_4_UP}

constructor TMT19937.Create;
begin
  inherited;
  mti := MT19937_N + 1;
end;

constructor TMT19937.Create(const init_key: Cardinal);
begin
  inherited Create;
  init_genrand(init_key);
end;

constructor TMT19937.Create(const init_key: array of Cardinal);
begin
  inherited Create;
  init_by_array(init_key);
end;

constructor TMT19937.Create(const init_key: RawByteString);
begin
  inherited Create;
  init_by_StrA(init_key);
end;

{$UNDEF Q_Temp}{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}

procedure TMT19937.init_genrand(const init_key: Cardinal);
begin
  mt[0] := init_key;
  mti := 1;
  repeat
    mt[mti] := (1812433253 * (mt[mti - 1] xor (mt[mti - 1] shr 30)) + mti);
    Inc(mti);
  until mti >= MT19937_N;
end;

{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{$UNDEF Q_Temp}{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}

procedure TMT19937.init_by_array(const init_key: array of Cardinal);
var
  i, j, k, m: Cardinal;
begin
  init_genrand(19650218);

  m := High(init_key);
  j := 0;

  k := m + 1;
  if k < MT19937_N then
    k := MT19937_N;

  i := 1;
  repeat
    mt[i] := (mt[i] xor ((mt[i - 1] xor (mt[i - 1] shr 30)) * 1664525)) + init_key[j] + j;

    Inc(i);
    if i >= MT19937_N then
      begin
        mt[0] := mt[MT19937_N - 1];
        i := 1;
      end;

    Inc(j);
    if j > m then
      j := 0;

    Dec(k);
  until k = 0;

  k := MT19937_N - 1;
  repeat
    mt[i] := (mt[i] xor ((mt[i - 1] xor (mt[i - 1] shr 30)) * 1566083941)) - i;

    Inc(i);
    if i >= MT19937_N then
      begin
        mt[0] := mt[MT19937_N - 1];
        i := 1;
      end;

    Dec(k);
  until k = 0;

  mt[0] := $80000000;
end;

{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{$UNDEF Q_Temp}{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}

procedure TMT19937.init_by_StrA(const init_key: RawByteString);
var
  i, j, k, m: Cardinal;
begin
  init_genrand(19650218);

  m := Length(init_key);
  j := 0;

  k := m + 1;
  if k < MT19937_N then
    k := MT19937_N;

  i := 1;
  repeat
    mt[i] := (mt[i] xor ((mt[i - 1] xor (mt[i - 1] shr 30)) * 1664525)) + Ord(init_key[j + 1]) + j;

    Inc(i);
    if i >= MT19937_N then
      begin
        mt[0] := mt[MT19937_N - 1];
        i := 1;
      end;

    Inc(j);
    if j >= m then
      j := 0;

    Dec(k);
  until k = 0;

  k := MT19937_N - 1;
  repeat
    mt[i] := (mt[i] xor ((mt[i - 1] xor (mt[i - 1] shr 30)) * 1566083941)) - i;

    Inc(i);
    if i >= MT19937_N then
      begin
        mt[0] := mt[MT19937_N - 1];
        i := 1;
      end;

    Dec(k);
  until k = 0;

  mt[0] := $80000000;
end;

{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{$UNDEF Q_Temp}{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}

function TMT19937.genrand_int32: Cardinal;
const
  MATRIX_A = $9908B0DF;
  mag01: array[0..1] of Cardinal = (0, MATRIX_A);
  UPPER_MASK = $80000000;
  LOWER_MASK = $7FFFFFFF;
var
  kk, y: Cardinal;
begin
  if mti >= MT19937_N then
    begin
      if mti = MT19937_N + 1 then
        init_genrand(5489);

      kk := 0;
      repeat
        y := (mt[kk] and UPPER_MASK) or (mt[kk + 1] and LOWER_MASK);
        mt[kk] := mt[kk + MT19937_M] xor (y shr 1) xor mag01[y and 1];
        Inc(kk);
      until kk >= MT19937_N - MT19937_M;

      repeat
        y := (mt[kk] and UPPER_MASK) or (mt[kk + 1] and LOWER_MASK);
        mt[kk] := mt[kk - (MT19937_N - MT19937_M)] xor (y shr 1) xor mag01[y and 1];
        Inc(kk);
      until kk >= MT19937_N - 1;

      y := (mt[MT19937_N - 1] and UPPER_MASK) or (mt[0] and LOWER_MASK);
      mt[MT19937_N - 1] := mt[MT19937_M - 1] xor (y shr 1) xor mag01[y and 1];

      mti := 0;
    end;

  Result := mt[mti]; Inc(mti);

  Result := Result xor (Result shr 11);
  Result := Result xor ((Result shl 7) and Integer($9D2C5680));
  Result := Result xor ((Result shl 15) and Integer($EFC60000));
  Result := Result xor (Result shr 18);
end;

{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

function TMT19937.genrand_int31: Cardinal;
begin
  Result := genrand_int32 shr 1;
end;

function TMT19937.genrand_int64: Int64;
begin
  with TInt64Rec(Result) do
    begin
      lo := genrand_int32;
      hi := genrand_int32;
    end;
end;

function TMT19937.genrand_int63: Int64;
begin
  with TInt64Rec(Result) do
    begin
      lo := genrand_int32;
      hi := genrand_int32 shr 1;
    end;
end;

function TMT19937.genrand_real1: Double;
begin
  Result := genrand_int32 / 4294967295.0;
end;

function TMT19937.genrand_real2: Double;
begin
  Result := genrand_int32 / 4294967296.0;
end;

function TMT19937.genrand_real3: Double;
begin
  Result := (genrand_int32 + 0.5) / 4294967296.0;
end;

function TMT19937.genrand_res53: Double;
var
  a, b: Cardinal;
begin
  a := genrand_int32 shr 5;
  b := genrand_int32 shr 6;
  Result := (a * 67108864 + b) / 9007199254740992.0;
end;

{$ENDIF COMPILER_4_UP}

const
  ALLOC_INCREMENT = 4096;

destructor TWideStrBuf.Destroy;
begin
  FreeMem(FBuf);
  inherited;
end;

procedure TWideStrBuf.AddBuf(const Buf: PWideChar; const Count: Cardinal);
begin
  if Assigned(Buf) then
    begin
      if FEnd - FPos <= Count then
        GrowBuffer(Count);
      Move(Buf^, FPos^, Count * 2);
      Inc(FPos, Count);
    end;
end;

procedure TWideStrBuf.AddChar(const c: WideChar);
begin
  if FPos >= FEnd then
    GrowBuffer(1);
  FPos^ := c;
  Inc(FPos, 1);
end;

procedure TWideStrBuf.AddCrLf;
begin
  if FEnd - FPos <= 2 then
    GrowBuffer(2);
  FPos^ := WC_CR;
  FPos[1] := WC_LF;
  Inc(FPos, 2);
end;

procedure TWideStrBuf.AddStr(const s: WideString);
var
  l: Cardinal;
begin
  l := Length(s);
  if FEnd - FPos <= l then
    GrowBuffer(l);
  Move(Pointer(s)^, FPos^, l * 2);
  Inc(FPos, l);
end;

procedure TWideStrBuf.Clear;
begin
  FreeMem(FBuf);
  FBuf := nil;
  FEnd := nil;
  FPos := nil;
end;

procedure TWideStrBuf.Delete(const Index, Count: Cardinal);
var
  l: Cardinal;
  p: PWideChar;
begin
  l := FPos - FBuf;
  if l > Index then
    begin
      p := FBuf + Index;
      Dec(l, Index);
      if l > Count then
        begin
          Move(p[Count], p^, (l - Count) shl 1);
          Dec(FPos, Count);
        end
      else
        FPos := p;
    end;
end;

function TWideStrBuf.GetAsStr: WideString;
begin
  SetString(Result, FBuf, FPos - FBuf);
end;

function TWideStrBuf.GetAsStrTrimRight: WideString;
var
  p: PWideChar;
begin
  p := FPos;
  while (p > FBuf) and (p[-1] <= WC_SPACE) do
    Dec(p);
  SetString(Result, FBuf, p - FBuf);
end;

function TWideStrBuf.GetCount: Cardinal;
begin
  Result := FPos - FBuf;
end;

procedure TWideStrBuf.GrowBuffer(const Count: Cardinal);
var
  PosOffset, Size, NewSize: Cardinal;
begin
  PosOffset := FPos - FBuf;
  Size := FEnd - FBuf;
  NewSize := Size + Count + ALLOC_INCREMENT;
  ReallocMem(FBuf, NewSize);
  FPos := FBuf + PosOffset;
  FEnd := FBuf + NewSize;
end;

function TWideStrBuf.IsEmpty: Boolean;
begin
  Result := FPos = FBuf;
end;

function TWideStrBuf.IsNotEmpty: Boolean;
begin
  Result := FPos > FBuf;
end;

procedure TWideStrBuf.Reset;
begin
  FPos := FBuf;
  FEnd := FBuf;
end;

function AdjustLineBreaksLengthW(
  const s: UnicodeString;
  const Style: TDITextLineBreakStyle{$IFDEF SUPPORTS_DEFAULTPARAMS} = tlbsCRLF{$ENDIF}): NativeInt;
var
  l: NativeInt;
  Source: PWideChar;
begin
  Source := Pointer(s);
  Result := Length(s);
  l := Result;
  while l > 0 do
    begin
      case Source^ of
        #10, WC_LINE_SEPARATOR:
          if Style = tlbsCRLF then
            Inc(Result);
        #13:
          if (l > 1) and (Source[1] = #10) then
            begin
              Inc(Source); Dec(l);
              if Style <> tlbsCRLF then
                Dec(Result)
            end
          else
            if Style = tlbsCRLF then
              Inc(Result);
      end;
      Inc(Source); Dec(l);
    end;
end;

function AdjustLineBreaksW(
  const s: UnicodeString;
  const Style: TDITextLineBreakStyle{$IFDEF SUPPORTS_DEFAULTPARAMS} = TDITextLineBreakStyleDefault{$ENDIF}): UnicodeString;
label
  OutputLineBreak;
var
  l: Integer;
  Source, Dest: PWideChar;
begin
  SetString(Result, nil, AdjustLineBreaksLengthW(s, Style));
  Dest := Pointer(Result);

  Source := Pointer(s);
  l := Length(s);
  while l > 0 do
    begin
      case Source^ of
        #10, WC_LINE_SEPARATOR:
          begin
            goto OutputLineBreak;
          end;
        #13:
          begin
            if (l > 1) and (Source[1] = #10) then
              begin
                Inc(Source); Dec(l);
              end;
            OutputLineBreak:
            if Style in [tlbsCRLF, tlbsCR] then
              begin
                Dest^ := #13;
                Inc(Dest);
              end;
            if Style in [tlbsCRLF, tlbsLF] then
              begin
                Dest^ := #10;
                Inc(Dest);
              end;
          end;
      else
        Dest^ := Source^;
        Inc(Dest);
      end;
      Inc(Source); Dec(l);
    end;
end;

function InternalPosA(
  Search: PAnsiChar; lSearch: Cardinal;
  const Source: PAnsiChar; lSource: Cardinal;
  const StartPos: Cardinal): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSource, pSearchTemp, PSourceTemp: PAnsiChar;
  lSearchTemp: Cardinal;
  c: AnsiChar;
begin
  Assert(Assigned(Search) or (lSearch = 0));
  Assert(Assigned(Source) or (lSource = 0));

  if (lSearch = 0) or (lSearch > lSource) then goto Fail;

  Dec(lSearch);
  Dec(lSource, lSearch);

  if StartPos > lSource then goto Fail;
  Dec(lSource, StartPos);

  pSource := Source;
  Inc(pSource, StartPos);

  c := Search^;
  Inc(Search);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if pSource^ = c then goto Zero;
          if pSource[1] = c then goto One;
          if pSource[2] = c then goto Two;
          if pSource[3] = c then goto Three;
          Inc(pSource, 4); Dec(lSource, 4);
        end;

      if lSource = 0 then Break;
      if pSource^ = c then goto Zero;
      if lSource = 1 then Break;
      if pSource[1] = c then goto One;
      if lSource = 2 then Break;
      if pSource[2] = c then goto Two;
      Break;

      Three:
      Inc(pSource, 4);
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(pSource, 3);
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(pSource, 2);
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(pSource);

      Match:

      PSourceTemp := pSource;
      pSearchTemp := Search;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (PCardinal(PSourceTemp)^ = PCardinal(pSearchTemp)^) do
        begin
          Inc(PSourceTemp, 4); Inc(pSearchTemp, 4); Dec(lSearchTemp, 4);
        end;

      repeat
        if lSearchTemp = 0 then goto Success;
        if PSourceTemp^ <> pSearchTemp^ then Break;
        Inc(PSourceTemp); Inc(pSearchTemp); Dec(lSearchTemp);
      until False;

      Dec(lSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := pSource - Source;
end;


const

    ANSI_UPPER_CHAR_TABLE: array[AnsiChar] of AnsiChar = (
    #000, #001, #002, #003, #004, #005, #006, #007, #008, #009, #010, #011, #012, #013, #014, #015,
    #016, #017, #018, #019, #020, #021, #022, #023, #024, #025, #026, #027, #028, #029, #030, #031,
    #032, #033, #034, #035, #036, #037, #038, #039, #040, #041, #042, #043, #044, #045, #046, #047,
    #048, #049, #050, #051, #052, #053, #054, #055, #056, #057, #058, #059, #060, #061, #062, #063,
    #064, #065, #066, #067, #068, #069, #070, #071, #072, #073, #074, #075, #076, #077, #078, #079,
    #080, #081, #082, #083, #084, #085, #086, #087, #088, #089, #090, #091, #092, #093, #094, #095,
    #096, #065, #066, #067, #068, #069, #070, #071, #072, #073, #074, #075, #076, #077, #078, #079,
    #080, #081, #082, #083, #084, #085, #086, #087, #088, #089, #090, #123, #124, #125, #126, #127,
    #128, #129, #130, #131, #132, #133, #134, #135, #136, #137, #138, #139, #140, #141, #142, #143,
    #144, #145, #146, #147, #148, #149, #150, #151, #152, #153, #138, #155, #140, #157, #142, #159,
    #160, #161, #162, #163, #164, #165, #166, #167, #168, #169, #170, #171, #172, #173, #174, #175,
    #176, #177, #178, #179, #180, #181, #182, #183, #184, #185, #186, #187, #188, #189, #190, #191,
    #192, #193, #194, #195, #196, #197, #198, #199, #200, #201, #202, #203, #204, #205, #206, #207,
    #208, #209, #210, #211, #212, #213, #214, #215, #216, #217, #218, #219, #220, #221, #222, #223,
    #192, #193, #194, #195, #196, #197, #198, #199, #200, #201, #202, #203, #204, #205, #206, #207,
    #208, #209, #210, #211, #212, #213, #214, #247, #216, #217, #218, #219, #220, #221, #222, #159);

function InternalPosIA(Search: PAnsiChar; lSearch: Cardinal; const Source: PAnsiChar; lSource: Cardinal; const StartPos: Cardinal): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSource, pSearchTemp, PSourceTemp: PAnsiChar;
  lSearchTemp: Cardinal;
  c: AnsiChar;
begin
  Assert(Assigned(Search) or (lSearch = 0));
  Assert(Assigned(Source) or (lSource = 0));

  if (lSearch = 0) or (lSearch > lSource) then goto Fail;

  Dec(lSearch);
  Dec(lSource, lSearch);

  if StartPos > lSource then goto Fail;
  Dec(lSource, StartPos);

  pSource := Source;
  Inc(pSource, StartPos);

  c := ANSI_UPPER_CHAR_TABLE[Search^];
  Inc(Search);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if (ANSI_UPPER_CHAR_TABLE[pSource^] = c) then goto Zero;
          if (ANSI_UPPER_CHAR_TABLE[pSource[1]] = c) then goto One;
          if (ANSI_UPPER_CHAR_TABLE[pSource[2]] = c) then goto Two;
          if (ANSI_UPPER_CHAR_TABLE[pSource[3]] = c) then goto Three;
          Inc(pSource, 4); Dec(lSource, 4);
        end;

      if lSource = 0 then Break;
      if (ANSI_UPPER_CHAR_TABLE[pSource^] = c) then goto Zero;
      if lSource = 1 then Break;
      if (ANSI_UPPER_CHAR_TABLE[pSource[1]] = c) then goto One;
      if lSource = 2 then Break;
      if (ANSI_UPPER_CHAR_TABLE[pSource[2]] = c) then goto Two;
      Break;

      Three:
      Inc(pSource, 4);
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(pSource, 3);
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(pSource, 2);
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(pSource);

      Match:

      PSourceTemp := pSource;
      pSearchTemp := Search;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[2]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[2]]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[3]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[3]]) do
        begin
          Inc(PSourceTemp, 4); Inc(pSearchTemp, 4); Dec(lSearchTemp, 4);
        end;

      repeat
        if lSearchTemp = 0 then goto Success;
        if ANSI_UPPER_CHAR_TABLE[PSourceTemp^] <> ANSI_UPPER_CHAR_TABLE[pSearchTemp^] then Break;
        Inc(PSourceTemp); Inc(pSearchTemp); Dec(lSearchTemp);
      until False;

      Dec(lSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := pSource - Source;
end;

function InternalPosW(Search: PWideChar; lSearch: Cardinal; const Source: PWideChar; lSource: Cardinal; const StartPos: Cardinal): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSource, pSearchTemp, PSourceTemp: PWideChar;
  lSearchTemp: Cardinal;
  c: WideChar;
begin
  Assert(Assigned(Search) or (lSearch = 0));
  Assert(Assigned(Source) or (lSource = 0));

  if (lSearch = 0) or (lSearch > lSource) then goto Fail;

  Dec(lSearch);
  Dec(lSource, lSearch);

  if StartPos > lSource then goto Fail;
  Dec(lSource, StartPos);

  pSource := Source;
  Inc(pSource, StartPos);

  c := Search^;
  Inc(Search);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if pSource^ = c then goto Zero;
          if pSource[1] = c then goto One;
          if pSource[2] = c then goto Two;
          if pSource[3] = c then goto Three;
          Inc(pSource, 4); Dec(lSource, 4);
        end;

      if lSource = 0 then Break;
      if pSource^ = c then goto Zero;
      if lSource = 1 then Break;
      if pSource[1] = c then goto One;
      if lSource = 2 then Break;
      if pSource[2] = c then goto Two;
      Break;

      Three:
      Inc(pSource, 4);
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(pSource, 3);
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(pSource, 2);
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(pSource);

      Match:

      PSourceTemp := pSource;
      pSearchTemp := Search;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (PCardinal(PSourceTemp)^ = PCardinal(pSearchTemp)^) and
        (PCardinal(@PSourceTemp[2])^ = PCardinal(@pSearchTemp[2])^) do
        begin
          Inc(PSourceTemp, 4); Inc(pSearchTemp, 4); Dec(lSearchTemp, 4);
        end;

      repeat
        if lSearchTemp = 0 then goto Success;
        if PSourceTemp^ <> pSearchTemp^ then Break;
        Inc(PSourceTemp); Inc(pSearchTemp); Dec(lSearchTemp);
      until False;

      Dec(lSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := pSource - Source;
end;

function InternalPosIW(Search: PWideChar; lSearch: Cardinal; const Source: PWideChar; lSource: Cardinal; const StartPos: Cardinal): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSource, pSearchTemp, PSourceTemp: PWideChar;
  lSearchTemp: Cardinal;
  c: WideChar;
begin
  Assert(Assigned(Search) or (lSearch = 0));
  Assert(Assigned(Source) or (lSource = 0));

  if (lSearch = 0) or (lSearch > lSource) then goto Fail;

  Dec(lSearch);
  Dec(lSource, lSearch);

  if StartPos > lSource then goto Fail;
  Dec(lSource, StartPos);

  pSource := Source;
  Inc(pSource, StartPos);

  c := CharToCaseFoldW(Search^);
  Inc(Search);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if CharToCaseFoldW(pSource^) = c then goto Zero;
          if CharToCaseFoldW(pSource[1]) = c then goto One;
          if CharToCaseFoldW(pSource[2]) = c then goto Two;
          if CharToCaseFoldW(pSource[3]) = c then goto Three;
          Inc(pSource, 4); Dec(lSource, 4);
        end;

      if lSource = 0 then Break;
      if CharToCaseFoldW(pSource^) = c then goto Zero;
      if lSource = 1 then Break;
      if CharToCaseFoldW(pSource[1]) = c then goto One;
      if lSource = 2 then Break;
      if CharToCaseFoldW(pSource[2]) = c then goto Two;
      Break;

      Three:
      Inc(pSource, 4);
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(pSource, 3);
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(pSource, 2);
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(pSource);

      Match:

      PSourceTemp := pSource;
      pSearchTemp := Search;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (CharToCaseFoldW(PSourceTemp^) = CharToCaseFoldW(pSearchTemp^)) and
        (CharToCaseFoldW(PSourceTemp[1]) = CharToCaseFoldW(pSearchTemp[1])) and
        (CharToCaseFoldW(PSourceTemp[2]) = CharToCaseFoldW(pSearchTemp[2])) and
        (CharToCaseFoldW(PSourceTemp[3]) = CharToCaseFoldW(pSearchTemp[3])) do
        begin
          Inc(PSourceTemp, 4); Inc(pSearchTemp, 4); Dec(lSearchTemp, 4);
        end;

      repeat
        if lSearchTemp = 0 then goto Success;
        if CharToCaseFoldW(PSourceTemp^) <> CharToCaseFoldW(pSearchTemp^) then Break;
        Inc(PSourceTemp); Inc(pSearchTemp); Dec(lSearchTemp);
      until False;

      Dec(lSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := pSource - Source;
end;

{$IFDEF COMPILER_4_UP}

function BSwap(const Value: Cardinal): Cardinal;
type
  t4 = packed record b1, b2, b3, b4: Byte; end;
begin
  Assert(SizeOf(t4) = SizeOf(Value));

  t4(Result).b1 := t4(Value).b4;
  t4(Result).b2 := t4(Value).b3;
  t4(Result).b3 := t4(Value).b2;
  t4(Result).b4 := t4(Value).b1;
end;

{$ENDIF COMPILER_4_UP}

function BSwap(const Value: Integer): Integer;
type
  t4 = packed record b1, b2, b3, b4: Byte; end;
begin
  Assert(SizeOf(t4) = SizeOf(Value));

  t4(Result).b1 := t4(Value).b4;
  t4(Result).b2 := t4(Value).b3;
  t4(Result).b3 := t4(Value).b2;
  t4(Result).b4 := t4(Value).b1;
end;

function BufCompNumA(p1: PAnsiChar; l1: Integer; p2: PAnsiChar; l2: Integer): Integer;

var
  c1, c2: AnsiChar;
  Zeros: Integer;
begin
  Zeros := 0;

  while (l1 > 0) and (l2 > 0) do
    begin

      if CharIsDigitA(p1^) and
      CharIsDigitA(p2^) then
        begin

          Result := 0;
          while (l1 > 0) and (p1^ = '0') do
            begin
              Dec(Result); Inc(p1); Dec(l1);
            end;
          while (l2 > 0) and (p2^ = '0') do
            begin
              Inc(Result); Inc(p2); Dec(l2);
            end;
          if Zeros = 0 then
            Zeros := Result;

          Result := 0;
          while (l1 > 0) and (l2 > 0) and
            CharIsDigitA(p1^) and
          CharIsDigitA(p2^) do
            begin
              if (Result = 0) and (p1^ <> p2^) then
                Result := Ord(p1^) - Ord(p2^);
              Inc(p1); Inc(p2); Dec(l1); Dec(l2);
            end;

          if (l1 > 0) and CharIsDigitA(p1^) then
            begin
              Result := 1; Exit;
            end
          else
            if (l2 > 0) and CharIsDigitA(p2^) then
              begin
                Result := -1; Exit;
              end
            else
              if Result <> 0 then
                Exit;
        end;

      c1 := p1^; c2 := p2^;
      if c1 <> c2 then

            begin
              Result := Ord(c1) - Ord(c2);
              Exit;
            end;

      Inc(p1); Inc(p2); Dec(l1); Dec(l2);
    end;

  Result := l1 - l2;
  if Result = 0 then
    Result := Zeros;

end;

function BufCompNumIA(p1: PAnsiChar; l1: Integer; p2: PAnsiChar; l2: Integer): Integer;

var
  c1, c2: AnsiChar;
  Zeros: Integer;
begin
  Zeros := 0;

  while (l1 > 0) and (l2 > 0) do
    begin

      if CharIsDigitA(p1^) and
      CharIsDigitA(p2^) then
        begin

          Result := 0;
          while (l1 > 0) and (p1^ = '0') do
            begin
              Dec(Result); Inc(p1); Dec(l1);
            end;
          while (l2 > 0) and (p2^ = '0') do
            begin
              Inc(Result); Inc(p2); Dec(l2);
            end;
          if Zeros = 0 then
            Zeros := Result;

          Result := 0;
          while (l1 > 0) and (l2 > 0) and
            CharIsDigitA(p1^) and
          CharIsDigitA(p2^) do
            begin
              if (Result = 0) and (p1^ <> p2^) then
                Result := Ord(p1^) - Ord(p2^);
              Inc(p1); Inc(p2); Dec(l1); Dec(l2);
            end;

          if (l1 > 0) and CharIsDigitA(p1^) then
            begin
              Result := 1; Exit;
            end
          else
            if (l2 > 0) and CharIsDigitA(p2^) then
              begin
                Result := -1; Exit;
              end
            else
              if Result <> 0 then
                Exit;
        end;

      c1 := p1^; c2 := p2^;
      if c1 <> c2 then

        begin
          c1 := ANSI_UPPER_CHAR_TABLE[c1];
          c2 := ANSI_UPPER_CHAR_TABLE[c2];
          if c1 <> c2 then

            begin
              Result := Ord(c1) - Ord(c2);
              Exit;
            end;

        end;

      Inc(p1); Inc(p2); Dec(l1); Dec(l2);
    end;

  Result := l1 - l2;
  if Result = 0 then
    Result := Zeros;

end;

function BufCompNumW(p1: PWideChar; l1: Integer; p2: PWideChar; l2: Integer): Integer;

var
  c1, c2: WideChar;
  Zeros: Integer;
begin
  Zeros := 0;

  while (l1 > 0) and (l2 > 0) do
    begin

      if CharIsDigitW(p1^) and
      CharIsDigitW(p2^) then
        begin

          Result := 0;
          while (l1 > 0) and (p1^ = '0') do
            begin
              Dec(Result); Inc(p1); Dec(l1);
            end;
          while (l2 > 0) and (p2^ = '0') do
            begin
              Inc(Result); Inc(p2); Dec(l2);
            end;
          if Zeros = 0 then
            Zeros := Result;

          Result := 0;
          while (l1 > 0) and (l2 > 0) and
            CharIsDigitW(p1^) and
          CharIsDigitW(p2^) do
            begin
              if (Result = 0) and (p1^ <> p2^) then
                Result := Ord(p1^) - Ord(p2^);
              Inc(p1); Inc(p2); Dec(l1); Dec(l2);
            end;

          if (l1 > 0) and CharIsDigitW(p1^) then
            begin
              Result := 1; Exit;
            end
          else
            if (l2 > 0) and CharIsDigitW(p2^) then
              begin
                Result := -1; Exit;
              end
            else
              if Result <> 0 then
                Exit;
        end;

      c1 := p1^; c2 := p2^;
      if c1 <> c2 then

            begin
              Result := Ord(c1) - Ord(c2);
              Exit;
            end;

      Inc(p1); Inc(p2); Dec(l1); Dec(l2);
    end;

  Result := l1 - l2;
  if Result = 0 then
    Result := Zeros;

end;

function BufCompNumIW(p1: PWideChar; l1: Integer; p2: PWideChar; l2: Integer): Integer;

var
  c1, c2: WideChar;
  Zeros: Integer;
begin
  Zeros := 0;

  while (l1 > 0) and (l2 > 0) do
    begin

      if CharIsDigitW(p1^) and
      CharIsDigitW(p2^) then
        begin

          Result := 0;
          while (l1 > 0) and (p1^ = '0') do
            begin
              Dec(Result); Inc(p1); Dec(l1);
            end;
          while (l2 > 0) and (p2^ = '0') do
            begin
              Inc(Result); Inc(p2); Dec(l2);
            end;
          if Zeros = 0 then
            Zeros := Result;

          Result := 0;
          while (l1 > 0) and (l2 > 0) and
            CharIsDigitW(p1^) and
          CharIsDigitW(p2^) do
            begin
              if (Result = 0) and (p1^ <> p2^) then
                Result := Ord(p1^) - Ord(p2^);
              Inc(p1); Inc(p2); Dec(l1); Dec(l2);
            end;

          if (l1 > 0) and CharIsDigitW(p1^) then
            begin
              Result := 1; Exit;
            end
          else
            if (l2 > 0) and CharIsDigitW(p2^) then
              begin
                Result := -1; Exit;
              end
            else
              if Result <> 0 then
                Exit;
        end;

      c1 := p1^; c2 := p2^;
      if c1 <> c2 then

        begin
          c1 := CharToCaseFoldW(c1);
          c2 := CharToCaseFoldW(c2);
          if c1 <> c2 then

            begin
              Result := Ord(c1) - Ord(c2);
              Exit;
            end;

        end;

      Inc(p1); Inc(p2); Dec(l1); Dec(l2);
    end;

  Result := l1 - l2;
  if Result = 0 then
    Result := Zeros;

end;

function BufPosA(const ASearch: RawByteString; const ABuf: PAnsiChar; const ABufCharCount: Cardinal; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Pointer;
var
  r: Cardinal;
begin
  r := InternalPosA(Pointer(ASearch), Length(ASearch), ABuf, ABufCharCount, AStartPos);
  if r > 0 then
    Result := ABuf + r - 1
  else
    Result := nil;
end;

function BufPosIA(const ASearch: RawByteString; const ABuf: PAnsiChar; const ABufCharCount: Cardinal; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Pointer;
var
  r: Cardinal;
begin
  r := InternalPosIA(Pointer(ASearch), Length(ASearch), ABuf, ABufCharCount, AStartPos);
  if r > 0 then
    Result := ABuf + r - 1
  else
    Result := nil;
end;

function BufPosW(const ASearch: UnicodeString; const ABuf: PWideChar; const ABufCharCount: Cardinal; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): PWideChar;
var
  r: Cardinal;
begin
  r := InternalPosW(Pointer(ASearch), Length(ASearch), ABuf, ABufCharCount, AStartPos);
  if r > 0 then
    Result := ABuf + r - 1
  else
    Result := nil;
end;

function BufPosIW(const ASearch: UnicodeString; const ABuffer: PWideChar; const ABufferCharCount: Cardinal; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): PWideChar;
var
  r: Cardinal;
begin
  r := InternalPosIW(Pointer(ASearch), Length(ASearch), ABuffer, ABufferCharCount, AStartPos);
  if r > 0 then
    Result := ABuffer + r - 1
  else
    Result := nil;
end;

function BufSameA(p1, p2: PAnsiChar; l: Cardinal): Boolean;
begin
  Result := (p1 = p2) or (l = 0) or
    (Assigned(p1) and Assigned(p2) and CompareMem(p1, p2, l));
end;

function BufSameW(p1, p2: PWideChar; l: Cardinal): Boolean;
begin
  Result := (p1 = p2) or (l = 0) or
    (Assigned(p1) and Assigned(p2) and CompareMem(p1, p2, l * SizeOf(p1^)));
end;

function BufSameIA(p1, p2: PAnsiChar; l: Cardinal): Boolean;
label
  Fail, Match;
begin
  if (p1 = p2) or (l = 0) then goto Match;
  if not Assigned(p1) or not Assigned(p2) then goto Fail;

  while l >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
        (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[3]] <> ANSI_UPPER_CHAR_TABLE[p2[3]]) then goto Fail;

      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Break;
    if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Fail;
    Inc(p1); Inc(p2); Dec(l);
  until False;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function BufSameIW(p1, p2: PWideChar; l: Cardinal): Boolean;
label
  Fail, Match;
begin
  if (p1 = p2) or (l = 0) then goto Match;
  if not Assigned(p1) or not Assigned(p2) then goto Fail;

  while l >= 4 do
    begin
      if (CharToCaseFoldW(p1[0]) <> CharToCaseFoldW(p2[0])) or
        (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) or
        (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) or
        (CharToCaseFoldW(p1[3]) <> CharToCaseFoldW(p2[3])) then goto Fail;
      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Break;
    if CharToCaseFoldW(p1[0]) <> CharToCaseFoldW(p2[0]) then goto Fail;
    Inc(p1); Inc(p2); Dec(l);
  until False;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function BufPosCharA(
  const Buf: PAnsiChar;
  l: Cardinal;
  const c: AnsiChar;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Integer;
label
  Zero, One, Two, Three, Fail;
var
  p: PAnsiChar;
begin
  if not Assigned(Buf) or (Start > l) then goto Fail;

  p := Buf;
  Inc(p, Start);
  Dec(l, Start);

  while l >= 4 do
    begin
      if p^ = c then goto Zero;
      if p[1] = c then goto One;
      if p[2] = c then goto Two;
      if p[3] = c then goto Three;
      Inc(p, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ = c) then goto Zero;
        if (p[1] = c) then goto One;
        if (p[2] = c) then goto Two;
      end;
    2:
      begin
        if (p^ = c) then goto Zero;
        if (p[1] = c) then goto One;
      end;
    1:
      if (p^ = c) then goto Zero;
  end;

  Fail:
  Result := -1;
  Exit;

  Zero:
  Result := p - Buf;
  Exit;

  One:
  Result := p - Buf + 1;
  Exit;

  Two:
  Result := p - Buf + 2;
  Exit;

  Three:
  Result := p - Buf + 3;
end;

function BufPosCharsA(
  const Buf: PAnsiChar;
  l: Cardinal;
  const Search: TAnsiCharSet;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Integer;
label
  Zero, One, Two, Three, Fail;
var
  p: PAnsiChar;
begin
  if not Assigned(Buf) or (Start > l) then goto Fail;

  p := Buf;
  Inc(p, Start);
  Dec(l, Start);

  while l >= 4 do
    begin
      if p^ in Search then goto Zero;
      if p[1] in Search then goto One;
      if p[2] in Search then goto Two;
      if p[3] in Search then goto Three;
      Inc(p, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
        if (p[2] in Search) then goto Two;
      end;
    2:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
      end;
    1:
      if (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := -1;
  Exit;

  Zero:
  Result := p - Buf;
  Exit;

  One:
  Result := p - Buf + 1;
  Exit;

  Two:
  Result := p - Buf + 2;
  Exit;

  Three:
  Result := p - Buf + 3;
end;

function BufPosCharsW(
  const Buf: PWideChar;
  l: Cardinal;
  const Validate: TValidateCharFuncW;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Integer;
label
  Zero, One, Two, Three, Fail;
var
  p: PWideChar;
begin
  if not Assigned(Buf) or (Start > l) then goto Fail;

  p := Buf;
  Inc(p, Start);
  Dec(l, Start);

  while l >= 4 do
    begin
      if Validate(p[0]) then goto Zero;
      if Validate(p[1]) then goto One;
      if Validate(p[2]) then goto Two;
      if Validate(p[3]) then goto Three;
      Inc(p, 4); Dec(l, 4);
    end;

  if l = 0 then goto Fail;
  if Validate(p[0]) then goto Zero;
  if l = 1 then goto Fail;
  if Validate(p[1]) then goto One;
  if l = 2 then goto Fail;
  if Validate(p[2]) then goto Two;

  Fail:
  Result := -1;
  Exit;

  Zero:
  Result := p - Buf;
  Exit;

  One:
  Result := p - Buf + 1;
  Exit;

  Two:
  Result := p - Buf + 2;
  Exit;

  Three:
  Result := p - Buf + 3;
end;

function BufStrSame(const Buf: PChar; const BufCharCount: Cardinal; const s: string): Boolean;
begin
  Result := {$IFDEF UNICODE}BufStrSameW{$ELSE}BufStrSameA{$ENDIF}(Buf, BufCharCount, s);
end;

function BufStrSameA(const Buf: PAnsiChar; const BufCharCount: Cardinal; const s: RawByteString): Boolean;
begin
  Result := (BufCharCount = Cardinal(Length(s))) and BufSameA(Buf, Pointer(s), BufCharCount);
end;

function BufStrSameW(const Buf: PWideChar; const BufCharCount: Cardinal; const s: UnicodeString): Boolean;
begin
  Result := (BufCharCount = Cardinal(Length(s))) and BufSameW(Buf, Pointer(s), BufCharCount);
end;

function BufStrSameI(const Buf: PChar; const BufCharCount: Cardinal; const s: string): Boolean;
begin
  Result := {$IFDEF UNICODE}BufStrSameIW{$ELSE}BufStrSameIA{$ENDIF}(Buf, BufCharCount, s);
end;

function BufStrSameIA(const Buf: PAnsiChar; const BufCharCount: Cardinal; const s: RawByteString): Boolean;
begin
  Result := (BufCharCount = Cardinal(Length(s))) and BufSameIA(Buf, Pointer(s), BufCharCount);
end;

function BufStrSameIW(const Buffer: PWideChar; const WideCharCount: Cardinal; const w: UnicodeString): Boolean;
label
  Fail;
var
  p1, p2: PWideChar;
  l: Cardinal;
begin
  Assert(Assigned(Buffer) or (WideCharCount = 0));

  l := WideCharCount;
  if l = Cardinal(Length(w)) then
    begin
      if l > 0 then
        begin
          p1 := Buffer; p2 := Pointer(w);
          while l >= 4 do
            begin
              if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
              if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
              if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
              if (p1[3] <> p2[3]) and (CharToCaseFoldW(p1[3]) <> CharToCaseFoldW(p2[3])) then goto Fail;
              Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
            end;
          while l > 0 do
            begin
              if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
              Inc(p1); Inc(p2); Dec(l);
            end;
        end;
      Result := True;
      Exit;
    end;

  Fail:
  Result := False;
end;

function ChangeFileExt(const FileName, Extension: string): string;
begin
  Result := {$IFDEF UNICODE}ChangeFileExtW{$ELSE}ChangeFileExtA{$ENDIF}(FileName, Extension);
end;

function ChangeFileExtA(const FileName, Extension: AnsiString): AnsiString;
label
  NoExtension;
var
  p: PAnsiChar;
  l: NativeInt;
begin
  l := Length(FileName);
  if l > 0 then
    begin
      p := Pointer(FileName);
      Inc(p, l);
      repeat
        Dec(l);
        Dec(p);
        if p^ = AC_FULL_STOP then Break;
        if l = 0 then goto NoExtension;
        if p^ = AC_PATH_DELIMITER then goto NoExtension;
        if p^ = AC_DRIVE_DELIMITER then goto NoExtension;
      until False;
      Result := Copy(FileName, 1, l) + Extension;
      Exit;
    end;

  NoExtension:
  Result := FileName + Extension;
end;

function ChangeFileExtW(const FileName, Extension: UnicodeString): UnicodeString;
label
  NoExtension;
var
  p: PWideChar;
  l: NativeInt;
begin
  l := Length(FileName);
  if l > 0 then
    begin
      p := Pointer(FileName);
      Inc(p, l);
      repeat
        Dec(l);
        Dec(p);
        if p^ = WC_FULL_STOP then Break;
        if l = 0 then goto NoExtension;
        if p^ = WC_PATH_DELIMITER then goto NoExtension;
        if p^ = WC_DRIVE_DELIMITER then goto NoExtension;
      until False;
      Result := Copy(FileName, 1, l) + Extension;
      Exit;
    end;

  NoExtension:
  Result := FileName + Extension;
end;

function CharDecomposeCanonicalStrW(const c: WideChar): UnicodeString;
var
  p: PCharDecompositionW;
begin
  if CharIsHangulW(c) then
    Result := CharDecomposeHangulW(c)
  else
    begin
      p := CharDecomposeCanonicalW(c);
      if Assigned(p) then
        SetString(Result, PWideChar(@p^.Data), p^.Count)
      else
        Result := c;
    end;
end;

function CharDecomposeCompatibleStrW(const c: WideChar): UnicodeString;
var
  p: PCharDecompositionW;
begin
  if CharIsHangulW(c) then
    Result := CharDecomposeHangulW(c)
  else
    begin
      p := CharDecomposeCompatibleW(c);
      if p <> nil then
        SetString(Result, PWideChar(@p^.Data), p^.Count)
      else
        Result := c;
    end;
end;

function CharIn(const c, t1, t2: WideChar): Boolean;
begin
  Result := (c = t1) or (c = t2);
end;

function CharIn(const c, t1, t2, t3: WideChar): Boolean;
begin
  Result := (c = t1) or (c = t2) or (c = t3);
end;

procedure ConCatBuf(const Buffer: PChar; const CharCount: Cardinal; var d: string; var InUse: Cardinal);
begin
  {$IFDEF UNICODE}ConCatBufW{$ELSE}ConCatBufA{$ENDIF}(Buffer, CharCount, d, InUse);
end;

procedure ConCatBufA(const Buffer: PAnsiChar; const AnsiCharCount: Cardinal; var d: RawByteString; var InUse: Cardinal);
var
  pSource, pDest: PAnsiChar;
  lSource, lDest, NewInUse: Cardinal;
begin
  pSource := Buffer;
  if pSource = nil then Exit;

  lSource := AnsiCharCount;
  if lSource = 0 then Exit;

  lDest := Length(d);
  NewInUse := InUse + lSource;
  if NewInUse > lDest then
    SetLength(d, (NewInUse + (NewInUse shr 1) + 3) and $FFFFFFFC);
  pDest := Pointer(d);

  Inc(pDest, InUse);

  while lSource >= 4 do
    begin
      Cardinal(Pointer(pDest)^) := Cardinal(Pointer(pSource)^);
      Inc(pDest, 4); Inc(pSource, 4); Dec(lSource, 4);
    end;

  repeat
    if lSource = 0 then Break;
    pDest^ := pSource^;
    Inc(pDest); Inc(pSource); Dec(lSource);
  until False;

  InUse := NewInUse;
end;

procedure ConCatBufW(const Buffer: PWideChar; const WideCharCount: Cardinal; var d: UnicodeString; var InUse: Cardinal);
var
  pSource, pDest: PWideChar;
  lSource, lDest, NewInUse: Cardinal;
begin
  pSource := Buffer;
  if pSource = nil then Exit;

  lSource := WideCharCount;
  if lSource = 0 then Exit;

  lDest := Length(d);
  NewInUse := InUse + lSource;
  if NewInUse > lDest then
    SetLength(d, (NewInUse + (NewInUse shr 1) + 3) and $FFFFFFFC);
  pDest := Pointer(d);

  Inc(pDest, InUse);
  while lSource >= 4 do
    begin
      {$IFDEF COMPILER_4_UP}
      PInt64(pDest)^ := PInt64(pSource)^;
      {$ELSE COMPILER_4_UP}
      pDest[0] := pSource[0];
      pDest[1] := pSource[1];
      pDest[2] := pSource[2];
      pDest[3] := pSource[3];
      {$ENDIF COMPILER_4_UP}
      Inc(pDest, 4); Inc(pSource, 4); Dec(lSource, 4);
    end;

  repeat
    if lSource = 0 then Break;
    pDest^ := pSource^;
    Inc(pDest); Inc(pSource); Dec(lSource);
  until False;

  InUse := NewInUse;
end;

procedure ConCatChar(const c: Char; var d: string; var InUse: Cardinal);
begin
  {$IFDEF UNICODE}ConCatCharW{$ELSE}ConCatCharA{$ENDIF}(c, d, InUse);
end;

procedure ConCatCharA(const c: AnsiChar; var d: RawByteString; var InUse: Cardinal);
var
  pDest: PAnsiChar;
  lDest: Cardinal;
begin
  lDest := Length(d);
  if InUse >= lDest then
    SetLength(d, (InUse + 1 + (InUse + 1 shr 1) + 3) and $FFFFFFFC);
  pDest := Pointer(d);
  pDest[InUse] := c;
  Inc(InUse);
end;

procedure ConCatCharW(const c: WideChar; var d: UnicodeString; var InUse: Cardinal);
var
  Dest: PWideChar;
  lDest: Cardinal;
begin
  lDest := Length(d);
  if InUse >= lDest then
    SetLength(d, (InUse + 1 + (InUse + 1 shr 1) + 3) and $FFFFFFFC);
  Dest := Pointer(d);
  Dest[InUse] := c;
  Inc(InUse);
end;

procedure ConCatStr(const s: string; var d: string; var InUse: Cardinal);
begin
  {$IFDEF UNICODE}ConCatStrW{$ELSE}ConCatStrA{$ENDIF}(s, d, InUse);
end;

procedure ConCatStrA(const s: RawByteString; var d: RawByteString; var InUse: Cardinal);
begin
  ConCatBufA(Pointer(s), Length(s), d, InUse);
end;

procedure ConCatStrW(const w: UnicodeString; var d: UnicodeString; var InUse: Cardinal);
begin
  ConCatBufW(Pointer(w), Length(w), d, InUse);
end;

function CountBitsSet(const Value: Integer): Byte;
type
  TByte4 = packed record b1, b2, b3, b4: Byte; end;
begin
  Assert(SizeOf(TByte4) = SizeOf(Value));
  Result :=
    BitTable[TByte4(Value).b4] +
    BitTable[TByte4(Value).b3] +
    BitTable[TByte4(Value).b2] +
    BitTable[TByte4(Value).b1];
end;

function Crc32OfBuf(const Buffer; const BufferSize: Cardinal): TCrc32;
begin
  //Result := not UpdateCrc32OfBuf(CRC_32_INIT, Buffer, UInt64(BufferSize))
end;

function Crc32OfBuf(const Buffer; const BufferSize: UInt64): TCrc32;
begin
  //Result := not UpdateCrc32OfBuf(CRC_32_INIT, Buffer, BufferSize);
end;

function Crc32OfStrA(const s: RawByteString): TCrc32;
begin
  //Result := not UpdateCrc32OfBuf(CRC_32_INIT, Pointer(s)^, UInt64(Length(s) * SizeOf(s[1])));
end;

function Crc32OfStrW(const s: UnicodeString): TCrc32;
begin
  //Result := not UpdateCrc32OfBuf(CRC_32_INIT, Pointer(s)^, UInt64(Length(s) * SizeOf(s[1])));
end;

{$IFDEF MSWINDOWS}
function CurrentDay: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.{$IFDEF FPC}Day{$ELSE}wDay{$ENDIF};
end;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}
function CurrentMonth: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.{$IFDEF FPC}Month{$ELSE}wMonth{$ENDIF};
end;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}
function CurrentQuarter: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := QUARTER_OF_MONTH[SystemTime.{$IFDEF FPC}Month{$ELSE}wMonth{$ENDIF}]
end;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}
function CurrentYear: Integer;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.{$IFDEF FPC}Year{$ELSE}wYear{$ENDIF};
end;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}
function CurrentJulianDate: TJulianDate;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  with SystemTime do
    Result := YmdToJulianDate(
      {$IFDEF FPC}Year{$ELSE}wYear{$ENDIF},
      {$IFDEF FPC}Month{$ELSE}wMonth{$ENDIF},
      {$IFDEF FPC}Day{$ELSE}wDay{$ENDIF});
end;
{$ENDIF MSWINDOWS}

function BrightenColor(
  const Color: Integer;
  const amount: Byte{$IFDEF SUPPORTS_DEFAULTPARAMS} = 25{$ENDIF}): Integer;
var
  r, g, b, m, over: Integer;
begin
  r := Color and $FF;
  g := (Color shr 8) and $FF;
  b := (Color shr 16) and $FF;

  Inc(r, amount);
  Inc(g, amount);
  Inc(b, amount);

  m := Max3(r, g, b);

  if m > 255 then
    begin
      over := m - 255;
      if m = r then
        begin
          Inc(g, over);
          Inc(b, over);
        end
      else
        if m = g then
          begin
            Inc(r, over);
            Inc(b, over);
          end
        else
          begin
            Inc(r, over);
            Inc(g, over);
          end;
    end;

  if r > 255 then
    r := 255;
  if g > 255 then
    g := 255;
  if b > 255 then
    b := 255;

  Result := (b shl 16) or (g shl 8) or r;
end;

function DarkenColor(
  const Color: Integer;
  const amount: Byte{$IFDEF SUPPORTS_DEFAULTPARAMS} = 25{$ENDIF}): Integer;
var
  r, g, b, m: Integer;
begin
  r := Color and $FF;
  g := (Color shr 8) and $FF;
  b := (Color shr 16) and $FF;

  Dec(r, amount);
  Dec(g, amount);
  Dec(b, amount);

  m := Max3(r, g, b);

  if m < 0 then
    if m = r then
      begin
        Inc(g, m);
        Inc(b, m);
      end
    else
      if m = g then
        begin
          Inc(r, m);
          Inc(b, m);
        end
      else
        begin
          Inc(r, m);
          Inc(g, m);
        end;

  if r < 0 then
    r := 0;
  if g < 0 then
    g := 0;
  if b < 0 then
    b := 0;

  Result := (b shl 16) or (g shl 8) or r;
end;

{$IFDEF MSWINDOWS}

function DeleteFile(const FileName: string): Boolean;
begin
  {$IFDEF UNICODE}
  Result := {$IFDEF HAS_UNITSCOPE}System.{$ENDIF}SysUtils.DeleteFile((FileName));
  {$ELSE UNICODE}
  Result := DeleteFileA(FileName);
  {$ENDIF UNICODE}
end;


const
  INVALID_FILE_ATTRIBUTES = Cardinal($FFFFFFFF);


function DeleteFileA(const FileName: AnsiString): Boolean;
var
  Flags, LastError: Cardinal;
begin
  Result := {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.DeleteFileA(PAnsiChar(FileName));
  if not Result then
    begin
      LastError := GetLastError;
      Flags := GetFileAttributesA(PAnsiChar(FileName));

      if (Flags <> INVALID_FILE_ATTRIBUTES) and
        (Flags and (faDirectory or faSymLink) <> (faDirectory or faSymLink)) then
        begin
          Result := RemoveDirectoryA(PAnsiChar(FileName));
          Exit;
        end;
      SetLastError(LastError);
    end;
end;

function DeleteFileW(const FileName: UnicodeString): Boolean;
{$IFNDEF Unicode}
var
  Flags, LastError: Cardinal;
  {$ENDIF UNICODE}
begin
  {$IFDEF UNICODE}
  Result := {$IFDEF HAS_UNITSCOPE}System.{$ENDIF}SysUtils.DeleteFile((FileName));
  {$ELSE Unicode}
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Result := {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.DeleteFileW(PWideChar(FileName));
      if not Result then
        begin
          LastError := GetLastError;
          Flags := GetFileAttributesW(PWideChar(FileName));
          if (Flags <> INVALID_FILE_ATTRIBUTES) and
            (Flags and (faDirectory or faSymLink) <> (faDirectory or faSymLink)) then
            begin
              Result := RemoveDirectoryW(PWideChar(FileName));
              Exit;
            end;
          SetLastError(LastError);
        end;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := DeleteFileA(FileName);
  {$ENDIF DI_No_Win_9X_Support}
  {$ENDIF Unicode}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function DirectoryExists(const Dir: string): Boolean;
begin
  Result := {$IFDEF UNICODE}DirectoryExistsW{$ELSE}DirectoryExistsA{$ENDIF}(Dir);
end;

function DirectoryExistsA(const Dir: AnsiString): Boolean;
var
  Code: Cardinal;
begin
  Code := GetFileAttributesA(Pointer(Dir));
  Result :=
    (Code <> INVALID_FILE_ATTRIBUTES) and
    (Code and FILE_ATTRIBUTE_DIRECTORY <> 0);
end;

function DirectoryExistsW(const Dir: UnicodeString): Boolean;
var
  Code: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Code := GetFileAttributesW(Pointer(Dir));
      Result :=
        (Code <> INVALID_FILE_ATTRIBUTES) and
        (Code and FILE_ATTRIBUTE_DIRECTORY <> 0);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := DirectoryExistsA(Dir);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}{$IFDEF SUPPORTS_LONGWORD}

function DiskFree(const Dir: string): Int64;
begin
  Result := {$IFDEF UNICODE}DiskFreeW{$ELSE}DiskFreeA{$ENDIF}(Dir);
end;

function DiskFreeA(const Dir: AnsiString): Int64;
var
  Kernel: THandle;
  GetDFSExA: function(
    const lpDirectoryName: PAnsiChar;
    out lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes: TLargeInteger;
    const lpTotalNumberOfFreeBytes: PLargeInteger): BOOL; stdcall;
  SpC, BpS, NoFC, TNoC: Cardinal;
  Temp: Int64;
begin

  Kernel := GetModuleHandle({$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.kernel32);
  if Kernel <> 0 then
    begin
      @GetDFSExA := GetProcAddress(Kernel, 'GetDiskFreeSpaceExA');
      if Assigned(GetDFSExA) then
        begin
          if not GetDFSExA(PAnsiChar(Dir), Result, Temp, nil) then
            Result := -1;
          Exit;
        end;
    end;

  if GetDiskFreeSpaceA(PAnsiChar(Dir), SpC, BpS, NoFC, TNoC) then
    begin
      Temp := SpC * BpS;
      Result := Temp * NoFC;
    end
  else
    Result := -1;
end;

function DiskFreeW(const Dir: UnicodeString): Int64;
var
  Temp: Int64;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      if not GetDiskFreeSpaceExW(PWideChar(Dir), Result, Temp, nil) then
        Result := -1;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := DiskFreeA(Dir);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}{$ENDIF COMPILER_4_UP}

procedure ExcludeTrailingPathDelimiter(var s: string);
begin
  {$IFDEF UNICODE}ExcludeTrailingPathDelimiterW{$ELSE}ExcludeTrailingPathDelimiterA{$ENDIF}(s);
end;

procedure ExcludeTrailingPathDelimiterA(var s: RawByteString);
var
  l: Cardinal;
begin
  l := Length(s);
  if (l > 0) and (s[l] = PATH_DELIMITER) then
    SetLength(s, l - 1);
end;

procedure ExcludeTrailingPathDelimiterW(var s: UnicodeString);
var
  l: Cardinal;
begin
  l := Length(s);
  if (l > 0) and (s[l] = PATH_DELIMITER) then
    SetLength(s, l - 1);
end;

{$IFDEF MSWINDOWS}

function ExpandFileName(const FileName: string): string;
begin
  Result := {$IFDEF Unicode}ExpandFileNameW{$ELSE}ExpandFileNameA{$ENDIF}(FileName);
end;

function ExpandFileNameA(const FileName: AnsiString): AnsiString;
var
  Required: Cardinal;
begin
  Required := GetFullPathNameA(PAnsiChar(FileName), 0, nil, PAnsiChar(nil^));
  if Required > 0 then
    begin
      SetString(Result, nil, Required - 1);
      GetFullPathNameA(PAnsiChar(FileName), Required, PAnsiChar(Result), PAnsiChar(nil^));
      SetLength(Result, StrLenA(PAnsiChar(Result)));
    end
  else
    Result := '';
end;

function ExpandFileNameW(const FileName: UnicodeString): UnicodeString;
var
  Required: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Required := GetFullPathNameW(PWideChar(FileName), 0, nil, PWideChar(nil^));
      if Required > 0 then
        begin
          SetString(Result, nil, Required - 1);
          GetFullPathNameW(PWideChar(FileName), Required, PWideChar(Result), PWideChar(nil^));
          SetLength(Result, StrLenW(PWideChar(Result)));
        end
      else
        Result := '';
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := ExpandFileNameA(FileName);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function ExtractFileDrive(const FileName: string): string;
begin
  Result := {$IFDEF Unicode}ExtractFileDriveW{$ELSE}ExtractFileDriveA{$ENDIF}(FileName);
end;

function ExtractFileDriveA(const FileName: RawByteString): RawByteString;
var
  i, j, l: Integer;
begin
  l := Length(FileName);
  if (l >= 2) and (FileName[2] = AC_DRIVE_DELIMITER) then
    Result := FileName[1] + AC_DRIVE_DELIMITER + AC_PATH_DELIMITER
  else
    if (l >= 2) and (FileName[1] = AC_PATH_DELIMITER) and (FileName[2] = AC_PATH_DELIMITER) then
      begin
        j := 2;
        i := 3;
        while i <= l do
          begin
            if FileName[i] = AC_PATH_DELIMITER then
              begin
                Dec(j);
                if j = 0 then Break;
              end;
            Inc(i);
          end;
        if i > l then i := l;
        SetString(Result, PAnsiChar(FileName), i);
        if Result[i] <> AC_PATH_DELIMITER then Result := Result + AC_PATH_DELIMITER;
      end
    else
      Result := '';
end;

function ExtractFileDriveW(const FileName: UnicodeString): UnicodeString;
var
  i, j, l: Integer;
  p: PWideChar;
begin
  l := Length(FileName);
  if (l >= 2) and (FileName[2] = WC_DRIVE_DELIMITER) then
    begin

      SetString(Result, nil, 3);
      p := Pointer(Result);
      p[0] := FileName[1];
      p[1] := WC_DRIVE_DELIMITER;
      p[2] := WC_PATH_DELIMITER;
    end
  else
    if (l >= 2) and (FileName[1] = WC_PATH_DELIMITER) and (FileName[2] = WC_PATH_DELIMITER) then
      begin
        j := 2;
        i := 3;
        while i <= l do
          begin
            if FileName[i] = WC_PATH_DELIMITER then
              begin
                Dec(j);
                if j = 0 then Break;
              end;
            Inc(i);
          end;
        if i > l then i := l;
        SetString(Result, PWideChar(FileName), i);
        if Result[i] <> WC_PATH_DELIMITER then Result := Result + UnicodeString(WC_PATH_DELIMITER);
      end
    else
      Result := '';
end;

{$ENDIF MSWINDOWS}

function ExtractFileExt(const FileName: string): string;
begin
  Result := {$IFDEF UNICODE}ExtractFileExtW{$ELSE}ExtractFileExtA{$ENDIF}(FileName);
end;

const

ANSI_LOWER_CHAR_TABLE: array[AnsiChar] of AnsiChar = (
    #000, #001, #002, #003, #004, #005, #006, #007, #008, #009, #010, #011, #012, #013, #014, #015,
    #016, #017, #018, #019, #020, #021, #022, #023, #024, #025, #026, #027, #028, #029, #030, #031,
    #032, #033, #034, #035, #036, #037, #038, #039, #040, #041, #042, #043, #044, #045, #046, #047,
    #048, #049, #050, #051, #052, #053, #054, #055, #056, #057, #058, #059, #060, #061, #062, #063,
    #064, #097, #098, #099, #100, #101, #102, #103, #104, #105, #106, #107, #108, #109, #110, #111,
    #112, #113, #114, #115, #116, #117, #118, #119, #120, #121, #122, #091, #092, #093, #094, #095,
    #096, #097, #098, #099, #100, #101, #102, #103, #104, #105, #106, #107, #108, #109, #110, #111,
    #112, #113, #114, #115, #116, #117, #118, #119, #120, #121, #122, #123, #124, #125, #126, #127,
    #128, #129, #130, #131, #132, #133, #134, #135, #136, #137, #154, #139, #156, #141, #158, #143,
    #144, #145, #146, #147, #148, #149, #150, #151, #152, #153, #154, #155, #156, #157, #158, #255,
    #160, #161, #162, #163, #164, #165, #166, #167, #168, #169, #170, #171, #172, #173, #174, #175,
    #176, #177, #178, #179, #180, #181, #182, #183, #184, #185, #186, #187, #188, #189, #190, #191,
    #224, #225, #226, #227, #228, #229, #230, #231, #232, #233, #234, #235, #236, #237, #238, #239,
    #240, #241, #242, #243, #244, #245, #246, #215, #248, #249, #250, #251, #252, #253, #254, #223,
    #224, #225, #226, #227, #228, #229, #230, #231, #232, #233, #234, #235, #236, #237, #238, #239,
    #240, #241, #242, #243, #244, #245, #246, #247, #248, #249, #250, #251, #252, #253, #254, #255);





function ExtractFileExtA(const FileName: RawByteString): RawByteString;
label
  0;
var
  p: PAnsiChar;
  i, l: NativeUInt;
begin
  l := Length(FileName);
  if l > 0 then
    begin
      i := l - 1;
      p := Pointer(FileName);
      Inc(p, i);
      repeat
        if p^ = AC_FULL_STOP then Break;
        if i = 0 then goto 0;
        if (p^ = AC_PATH_DELIMITER) then goto 0;
        if (p^ = AC_DRIVE_DELIMITER) then goto 0;
        Dec(i); Dec(p);
      until False;
      SetString(Result, p, l - i);
    end
  else
    0: Result := '';
end;

function ExtractFileExtW(const FileName: UnicodeString): UnicodeString;
label
  0;
var
  p: PWideChar;
  i, l: NativeUInt;
begin
  l := Length(FileName);
  if l > 0 then
    begin

      i := l - 1;
      p := Pointer(FileName);
      Inc(p, i);
      repeat
        if p^ = WC_FULL_STOP then Break;
        if i = 0 then goto 0;
        if (p^ = WC_PATH_DELIMITER) then goto 0;
        if (p^ = WC_DRIVE_DELIMITER) then goto 0;
        Dec(i); Dec(p);
      until False;
      SetString(Result, p, l - i);
    end
  else
    0: Result := '';
end;

function ExtractFileName(const FileName: string): string;
begin
  Result := {$IFDEF UNICODE}ExtractFileNameW{$ELSE}ExtractFileNameA{$ENDIF}(FileName);
end;

function ExtractFileNameA(const FileName: AnsiString): AnsiString;
var
  l, Start: NativeUInt;
begin
  l := Length(FileName);
  if l > 0 then
    begin
      Start := l;
      while (Start > 0) and (FileName[Start] <> AC_PATH_DELIMITER) and (FileName[Start] <> AC_COLON) do
        Dec(Start);
      SetString(Result, PAnsiChar(FileName) + Start, l - Start);
    end
  else
    Result := '';
end;

function ExtractFileNameW(const FileName: UnicodeString): UnicodeString;
var
  l, Start: NativeUInt;
begin
  l := Length(FileName);
  if l > 0 then
    begin
      Start := l;
      while (Start > 0) and (FileName[Start] <> WC_PATH_DELIMITER) and (FileName[Start] <> WC_COLON) do
        Dec(Start);
      SetString(Result, PWideChar(FileName) + Start, l - Start);
    end
  else
    Result := '';
end;

function ExtractFilePath(const FileName: string): string;
begin
  Result := {$IFDEF UNICODE}ExtractFilePathW{$ELSE}ExtractFilePathA{$ENDIF}(FileName);
end;

function ExtractFilePathA(const FileName: RawByteString): RawByteString;
var
  l: Cardinal;
begin
  l := Length(FileName);
  if l > 0 then
    begin
      while (l > 0) and (FileName[l] <> AC_PATH_DELIMITER) and (FileName[l] <> AC_COLON) do
        Dec(l);
      SetString(Result, PAnsiChar(FileName), l);
    end
  else
    Result := '';
end;

function ExtractFilePathW(const FileName: UnicodeString): UnicodeString;
var
  l: Cardinal;
begin
  l := Length(FileName);
  if l > 0 then
    begin
      while (l > 0) and (FileName[l] <> WC_PATH_DELIMITER) and (FileName[l] <> WC_COLON) do
        Dec(l);
      SetString(Result, PWideChar(FileName), l);
    end
  else
    Result := '';
end;

function ExtractNextWord(const s: string; const ADelimiter: Char; var AStartIndex: Integer): string;
begin
  Result := {$IFDEF UNICODE}ExtractNextWordW{$ELSE}ExtractNextWordA{$ENDIF}(s, ADelimiter, AStartIndex);
end;

function ExtractNextWordA(const s: RawByteString; const ADelimiter: AnsiChar; var AStartIndex: Integer): RawByteString;
label
  Fail;
var
  p, pStart: PAnsiChar;
  l: Integer;
begin
  l := Length(s);
  if l = 0 then goto Fail;
  if (AStartIndex < 1) or (AStartIndex > l) then goto Fail;

  p := Pointer(s);
  Dec(l, AStartIndex - 1);
  Inc(p, AStartIndex - 1);
  pStart := p;

  while (l > 0) and (p^ <> ADelimiter) do
    begin
      Inc(p);
      Dec(l);
    end;

  SetString(Result, pStart, p - pStart);
  if l = 0 then
    AStartIndex := 0
  else
    Inc(AStartIndex, p - pStart + 1);

  Exit;

  Fail:
  Result := '';
  AStartIndex := -1;
end;

function ExtractNextWordW(
  const s: UnicodeString;
  const ADelimiter: WideChar;
  var AStartIndex: Integer): UnicodeString;
label
  Fail;
var
  p, pStart: PWideChar;
  l: Integer;
begin
  l := Length(s);
  if l = 0 then goto Fail;
  if (AStartIndex < 1) or (AStartIndex > l) then goto Fail;

  p := Pointer(s);
  Dec(l, AStartIndex - 1);
  Inc(p, AStartIndex - 1);
  pStart := p;

  while (l > 0) and (p^ <> ADelimiter) do
    begin
      Inc(p);
      Dec(l);
    end;

  SetString(Result, pStart, p - pStart);
  if l = 0 then
    AStartIndex := 0
  else
    Inc(AStartIndex, p - pStart + 1);

  Exit;

  Fail:
  Result := '';
  AStartIndex := -1;
end;

function ExtractNextWord(
  const s: string;
  const ADelimiters: {$IFDEF Unicode}TValidateCharFuncW{$ELSE}TAnsiCharSet{$ENDIF};
  var AStartIndex: Integer): string;
begin
  Result := {$IFDEF Unicode}ExtractNextWordW{$ELSE}ExtractNextWordA{$ENDIF}(s, ADelimiters, AStartIndex);
end;

function ExtractNextWordA(const s: RawByteString; const ADelimiters: TAnsiCharSet; var AStartIndex: Integer): RawByteString;
label
  Fail;
var
  p, pStart: PAnsiChar;
  l: Integer;
begin
  l := Length(s);
  if l = 0 then goto Fail;
  if (AStartIndex < 1) or (AStartIndex > l) then goto Fail;

  p := Pointer(s);
  Dec(l, AStartIndex - 1);
  Inc(p, AStartIndex - 1);
  pStart := p;

  while (l > 0) and not (p^ in ADelimiters) do
    begin
      Inc(p);
      Dec(l);
    end;

  SetString(Result, pStart, p - pStart);
  if l = 0 then
    AStartIndex := 0
  else
    Inc(AStartIndex, p - pStart + 1);

  Exit;

  Fail:
  Result := '';
  AStartIndex := -1;
end;

function ExtractNextWordW(const s: UnicodeString; const ADelimiters: TValidateCharFuncW; var AStartIndex: Integer): UnicodeString;
label
  Fail;
var
  p, pStart: PWideChar;
  l: Integer;
begin
  l := Length(s);
  if l = 0 then goto Fail;
  if (AStartIndex < 1) or (AStartIndex > l) then goto Fail;

  p := Pointer(s);
  Dec(l, AStartIndex - 1);
  Inc(p, AStartIndex - 1);
  pStart := p;

  while (l > 0) and not ADelimiters(p^) do
    begin
      Inc(p);
      Dec(l);
    end;

  SetString(Result, pStart, p - pStart);
  if l = 0 then
    AStartIndex := 0
  else
    Inc(AStartIndex, p - pStart + 1);

  Exit;

  Fail:
  Result := '';
  AStartIndex := -1;
end;

function ExtractWordA(
  const Number: Cardinal;
  const s: RawByteString;
  const Delimiters: TAnsiCharSet{$IFDEF SUPPORTS_DEFAULTPARAMS} = AS_WHITE_SPACE{$ENDIF}): RawByteString;
label
  ReturnEmptyString, Success;
var
  l, n: Cardinal;
  p, PWordStart: PAnsiChar;
begin
  n := Number;
  if n = 0 then goto ReturnEmptyString;

  l := Length(s);
  if l = 0 then goto ReturnEmptyString;

  p := Pointer(s);
  repeat
    Dec(n);
    if n = 0 then goto Success;

    while (l > 0) and not (p^ in Delimiters) do
      begin
        Inc(p); Dec(l);
      end;

    if l < 1 then goto ReturnEmptyString;
    Inc(p); Dec(l);
  until False;

  ReturnEmptyString:
  Result := '';
  Exit;

  Success:
  PWordStart := p;
  while (l > 0) and not (p^ in Delimiters) do
    begin
      Inc(p); Dec(l);
    end;
  SetString(Result, PWordStart, p - PWordStart);
end;

function ExtractWordStartsA(const s: RawByteString; const MaxCharCount: Cardinal; const WordSeparators: TAnsiCharSet{$IFDEF SUPPORTS_DEFAULTPARAMS} = AS_WHITE_SPACE{$ENDIF}): RawByteString;
var
  i, l, LengthResult: Cardinal;
  p: PAnsiChar;
begin
  Result := '';
  if MaxCharCount = 0 then Exit;

  l := Length(s);
  if l = 0 then Exit;

  LengthResult := 0;
  p := Pointer(s);
  repeat
    while (l > 0) and (p^ in WordSeparators) do
      begin
        Inc(p); Dec(l);
      end;

    i := MaxCharCount;
    while (l > 0) and (i > 0) and not (p^ in WordSeparators) do
      begin
        ConCatCharA(p^, Result, LengthResult);
        Inc(p); Dec(i); Dec(l);
      end;

    while (l > 0) and not (p^ in WordSeparators) do
      begin
        Inc(p); Dec(l);
      end;
  until l = 0;

  SetLength(Result, LengthResult);
end;

function ExtractWordStartsW(const s: UnicodeString; const MaxCharCount: Cardinal; const IsWordSep: TValidateCharFuncW): UnicodeString;
var
  i, l, LengthResult: Cardinal;
  p: PWideChar;
begin
  Assert(Assigned(IsWordSep));

  Result := '';
  if MaxCharCount = 0 then Exit;

  l := Length(s);
  if l = 0 then Exit;

  LengthResult := 0;
  p := Pointer(s);
  repeat
    while (l > 0) and IsWordSep(p^) do
      begin
        Inc(p); Dec(l);
      end;

    i := MaxCharCount;
    while (l > 0) and (i > 0) and not IsWordSep(p^) do
      begin
        ConCatCharW(p^, Result, LengthResult);
        Inc(p); Dec(i); Dec(l);
      end;

    while (l > 0) and not IsWordSep(p^) do
      begin
        Inc(p); Dec(l);
      end;
  until l = 0;

  SetLength(Result, LengthResult);
end;

{$IFDEF MSWINDOWS}

function FileExists(const FileName: string): Boolean;
begin
  Result := {$IFDEF UNICODE}FileExistsW{$ELSE}FileExistsA{$ENDIF}(FileName);
end;

function FileExistsA(const FileName: AnsiString): Boolean;
var
  Code: Cardinal;
begin
  Code := GetFileAttributesA(Pointer(FileName));
  Result :=
    (Code <> INVALID_FILE_ATTRIBUTES) and
    (Code and FILE_ATTRIBUTE_DIRECTORY = 0);
end;

function FileExistsW(const FileName: UnicodeString): Boolean;
var
  Code: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Code := GetFileAttributesW(Pointer(FileName));
      Result :=
        (Code <> INVALID_FILE_ATTRIBUTES) and
        (Code and FILE_ATTRIBUTE_DIRECTORY = 0);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := FileExistsA(FileName);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

function GCD(x, y: Cardinal): Cardinal;
begin
  Result := x;
  while y <> 0 do
    begin
      x := Result;
      Result := y;
      y := x mod y;
    end;
end;

{$IFDEF MSWINDOWS}

function GetCurrentFolder: string;
begin
  Result := {$IFDEF UNICODE}GetCurrentFolderW{$ELSE}GetCurrentFolderA{$ENDIF};
end;

function GetCurrentFolderA: AnsiString;
var
  Required: Cardinal;
begin
  Required := GetCurrentDirectoryA(0, nil);
  if Required > 0 then
    begin
      SetString(Result, nil, Required - 1);
      GetCurrentDirectoryA(Required, Pointer(Result));
    end
  else
    Result := '';
end;

function GetCurrentFolderW: UnicodeString;
var
  Required: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Required := GetCurrentDirectoryW(0, nil);
      if Required > 0 then
        begin
          SetString(Result, nil, Required - 1);
          GetCurrentDirectoryW(Required, Pointer(Result));
        end
      else
        Result := '';
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := GetCurrentFolderA;
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

procedure SetCurrentFolder(const NewFolder: string); {$IFDEF SUPPORTS_INLINE} inline; {$ENDIF}
begin
  {$IFDEF UNICODE}SetCurrentFolderW{$ELSE}SetCurrentFolderA{$ENDIF}(NewFolder);
end;

procedure SetCurrentFolderA(const NewFolder: AnsiString);
begin
  SetCurrentDirectoryA(PAnsiChar(NewFolder));
end;

procedure SetCurrentFolderW(const NewFolder: UnicodeString);
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    {$ENDIF}
    SetCurrentDirectoryW(PWideChar(NewFolder))
      {$IFNDEF DI_No_Win_9X_Support}
  else
    SetCurrentFolderA(NewFolder);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetDesktopFolder: string;
begin
  Result := {$IFDEF UNICODE}GetDesktopFolderW{$ELSE}GetDesktopFolderA{$ENDIF};
end;

function GetDesktopFolderA: AnsiString;
begin
  Result := GetSpecialFolderA(CSIDL_Desktop);
end;

function GetDesktopFolderW: UnicodeString;
begin
  Result := GetSpecialFolderW(CSIDL_Desktop);
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetDesktopDirectoryFolder: string;
begin
  Result := {$IFDEF UNICODE}GetDesktopDirectoryFolderW{$ELSE}GetDesktopDirectoryFolderA{$ENDIF};
end;

function GetDesktopDirectoryFolderA: AnsiString;
begin
  Result := GetSpecialFolderA(CSIDL_DESKTOPDIRECTORY);
end;

function GetDesktopDirectoryFolderW: UnicodeString;
begin
  Result := GetSpecialFolderW(CSIDL_DESKTOPDIRECTORY);
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}
{$IFDEF SUPPORTS_INT64}

function GetFileSize(const AFileName: string): Int64;
begin
  Result := {$IFDEF UNICODE}GetFileSizeW{$ELSE}GetFileSizeA{$ENDIF}(AFileName);
end;

function GetFileSizeA(const AFileName: AnsiString): Int64;
var
  Handle: THandle;
  FindData: TWin32FindDataA;
begin
  Handle := FindFirstFileA(PAnsiChar(AFileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
    begin
      {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.FindClose(Handle);
      TInt64Rec(Result).lo := FindData.nFileSizeLow;
      TInt64Rec(Result).hi := FindData.nFileSizeHigh;
    end
  else
    Result := -1;
end;

function GetFileSizeW(const AFileName: UnicodeString): Int64;
var
  Handle: THandle;
  FindData: TWin32FindDataW;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Handle := FindFirstFileW(PWideChar(AFileName), FindData);
      if Handle <> INVALID_HANDLE_VALUE then
        begin
          {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.FindClose(Handle);
          TInt64Rec(Result).lo := FindData.nFileSizeLow;
          TInt64Rec(Result).hi := FindData.nFileSizeHigh;
        end
      else
        Result := -1;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := GetFileSizeA(AFileName);
  {$ENDIF}
end;

{$ENDIF SUPPORTS_INT64}
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetFileLastWriteTime(const FileName: string; out FileTime: TFileTime): Boolean;
begin
  Result := {$IFDEF Unicode}GetFileLastWriteTimeW{$ELSE}GetFileLastWriteTimeA{$ENDIF}(FileName, FileTime);
end;

function GetFileLastWriteTimeA(const FileName: AnsiString; out FileTime: TFileTime): Boolean;
var
  FindData: TWin32FindDataA;
  Handle: THandle;
begin
  Handle := FindFirstFileA(PAnsiChar(FileName), FindData);
  Result := Handle <> INVALID_HANDLE_VALUE;
  if Result then
    begin
      {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.FindClose(Handle);
      FileTime := FindData.ftLastWriteTime;
    end;
end;

function GetFileLastWriteTimeW(const FileName: UnicodeString; out FileTime: TFileTime): Boolean;
var
  FindData: TWin32FindDataW;
  Handle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if DIUtils.IsUnicode then
    begin
      {$ENDIF}
      Handle := FindFirstFileW(PWideChar(FileName), FindData);
      Result := Handle <> INVALID_HANDLE_VALUE;
      if Result then
        begin
          {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.FindClose(Handle);
          FileTime := FindData.ftLastWriteTime;
        end;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := GetFileLastWriteTimeA(FileName, FileTime);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetPersonalFolder(const PersonalFolder: Integer): string;
begin
  Result := {$IFDEF Unicode}GetPersonalFolderW{$ELSE}GetPersonalFolderW{$ENDIF};
end;

function GetPersonalFolderA: AnsiString;
begin
  Result := GetSpecialFolderA(CSIDL_PERSONAL);
end;

function GetPersonalFolderW: UnicodeString;
begin
  Result := GetSpecialFolderW(CSIDL_PERSONAL);
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}
function GetSpecialFolder(const SpecialFolder: Integer): string;
begin
  Result := {$IFDEF Unicode}GetSpecialFolderW{$ELSE}GetSpecialFolderW{$ENDIF}(SpecialFolder);
end;

function GetSpecialFolderA(const SpecialFolder: Integer): AnsiString;
var
  ItemIDList: PItemIDList;
  Buffer: array[0..MAX_PATH - 1] of AnsiChar;
  malloc: IMalloc;
begin
  if SHGetSpecialFolderLocation(0, SpecialFolder, ItemIDList) = NOERROR then
    begin
      if SHGetPathFromIDListA(ItemIDList, Buffer) then
        begin
          Result := Buffer;
          IncludeTrailingPathDelimiterByRefA(RawByteString(Result));
        end
      else
        Result := '';
      if (SHGetMalloc(malloc) = NOERROR) and (malloc.DidAlloc(ItemIDList) > 0) then
        malloc.Free(ItemIDList);
    end
  else
    Result := '';
end;

function GetSpecialFolderW(const SpecialFolder: Integer): UnicodeString;
var
  ItemIDList: PItemIDList;
  Buffer: array[0..MAX_PATH - 1] of WideChar;
  malloc: IMalloc;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      if SHGetSpecialFolderLocation(0, SpecialFolder, ItemIDList) = NOERROR then
        begin
          if SHGetPathFromIDListW(ItemIDList, Buffer) then
            begin
              Result := Buffer;
              IncludeTrailingPathDelimiterByRefW(Result);
            end
          else
            Result := '';
          if (SHGetMalloc(malloc) = NOERROR) and (malloc.DidAlloc(ItemIDList) > 0) then
            malloc.Free(ItemIDList);
        end
      else
        Result := '';
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := GetSpecialFolderA(SpecialFolder);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetTempFileName(
  const Prefix: string = 'tmp';
  const Unique: {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.uInt = 0): string;
begin
  Result := {$IFDEF UNICODE}GetTempFileNameW{$ELSE}GetTempFileNameA{$ENDIF}(
    Prefix, Unique);
end;

function GetTempFileNameA(
  const Prefix: AnsiString = 'tmp';
  const Unique: {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.uInt = 0): AnsiString;
var
  TempPath: AnsiString;
  r: {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.uInt;
begin
  TempPath := GetTempFolderA;
  if TempPath <> '' then
    begin
      SetString(Result, nil, MAX_PATH);
      r := {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.GetTempFileNameA(
        Pointer(TempPath), Pointer(Prefix), Unique, Pointer(Result));
      if r <> 0 then
        begin
          SetLength(Result, StrLenA(PAnsiChar(Result)));
          Exit;
        end;
    end;
  Result := '';
end;

function GetTempFileNameW(
  const Prefix: UnicodeString = 'tmp';
  const Unique: {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.uInt = 0): UnicodeString;
var
  TempPath: UnicodeString;
  r: {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.uInt;
begin
  TempPath := GetTempFolderW;
  if TempPath <> '' then
    begin
      SetString(Result, nil, MAX_PATH);
      r := {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.GetTempFileNameW(
        Pointer(TempPath), Pointer(Prefix), Unique, Pointer(Result));
      if r <> 0 then
        begin
          SetLength(Result, StrLenW(Pointer(Result)));
          Exit;
        end;
    end;
  Result := '';
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetTempFolder: string;
begin
  Result := {$IFDEF UNICODE}GetTempFolderW{$ELSE}GetTempFolderA{$ENDIF};
end;

function GetTempFolderA: AnsiString;
var
  Required: DWORD;
begin
  Required := GetTempPathA(0, nil);
  if Required > 0 then
    begin
      SetString(Result, nil, Required - 1);
      GetTempPathA(Required, Pointer(Result));
    end
  else
    Result := '';
end;

function GetTempFolderW: UnicodeString;
var
  Required: DWORD;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Required := GetTempPathW(0, nil);
      if Required > 0 then
        begin
          SetString(Result, nil, Required - 1);
          GetTempPathW(Required, Pointer(Result));
        end
      else
        Result := '';
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := GetTempFolderA;
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function GetUserName(out UserName: string): Boolean;
begin
  Result := {$IFDEF UNICODE}GetUserName{$ELSE}GetUserName{$ENDIF}(UserName);
end;

function GetUserNameA(out UserName: AnsiString): Boolean;
var
  Size: DWORD;
begin
  Size := 256 + 1;
  SetString(UserName, nil, Size);
  Result := {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.GetUserNameA(
    Pointer(UserName), Size);
  if Result then
    SetLength(UserName, Size - 1)
  else
    UserName := '';
end;

function GetUserNameW(out UserName: UnicodeString): Boolean;
var
  Size: DWORD;
  {$IFNDEF DI_No_Win_9X_Support}
  s: AnsiString;
  {$ENDIF}
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Size := 256 + 1;
      SetString(UserName, nil, Size);
      Result := {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.GetUserNameW(
        Pointer(UserName), Size);
      if Result then
        SetLength(UserName, Size - 1)
      else
        UserName := '';
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    begin
      Result := GetUserNameA(s);
      UserName := s;
    end;
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

function JulianDateToIsoDateStr(const Julian: TJulianDate): string;
begin
  Result := {$IFDEF Unicode}JulianDateToIsoDateStrW{$ELSE}JulianDateToIsoDateStrA{$ENDIF}(Julian);
end;

function JulianDateToIsoDateStrA(const Julian: TJulianDate): RawByteString;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToIsoDateStrA(Year, Month, Day);
end;

function JulianDateToIsoDateStrW(const Julian: TJulianDate): UnicodeString;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToIsoDateStrW(Year, Month, Day);
end;

function StrContainsChar(const s: string; const c: Char; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
begin
  Result := {$IFDEF Unicode}StrContainsCharW{$ELSE}StrContainsCharA{$ENDIF}(s, c, Start);
end;

function StrContainsCharA(const s: RawByteString; const c: AnsiChar; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  if Start = 0 then goto Fail;
  l := Length(s);
  if (l = 0) or (Start > l) then goto Fail;

  p := Pointer(s);
  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if (p^ = c) or (p[1] = c) or (p[2] = c) or (p[3] = c) then goto Match;
      Inc(p, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Break;
    if p^ = c then goto Match;
    Inc(p); Dec(l);
  until False;

  Fail:
  Result := False;
  Exit;

  Match:
  Result := True;
end;

function StrContainsCharW(const s: UnicodeString; const c: WideChar; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PWideChar;
begin
  if Start = 0 then goto Fail;
  l := Length(s);
  if (l = 0) or (Start > l) then goto Fail;

  p := Pointer(s);
  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if (p^ = c) or (p[1] = c) or (p[2] = c) or (p[3] = c) then goto Match;
      Inc(p, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Break;
    if p^ = c then goto Match;
    Inc(p); Dec(l);
  until False;

  Fail:
  Result := False;
  Exit;

  Match:
  Result := True;
end;

function StrContainsCharsA(const s: RawByteString; const Chars: TAnsiCharSet; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  if Start = 0 then goto Fail;
  l := Length(s);
  if (l = 0) or (Start > l) then goto Fail;

  p := Pointer(s);
  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if (p^ in Chars) or (p[1] in Chars) or (p[2] in Chars) or (p[3] in Chars) then goto Match;
      Inc(p, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Break;
    if p^ in Chars then goto Match;
    Inc(p); Dec(l);
  until False;

  Fail:
  Result := False;
  Exit;

  Match:
  Result := True;
end;

function InternalBufIsCharsW(
  p: PWideChar; l: NativeUInt;
  const Validate: TValidateCharFuncW): Boolean; overload;
label
  Fail;
begin
  Assert(Assigned(p) or (l = 0));
  Assert(Assigned(Validate));

  while l >= 4 do
    begin
      if not Validate(p^) or not Validate(p[1]) or not Validate(p[2]) or not Validate(p[3]) then goto Fail;
      Inc(p, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Break;
    if not Validate(p^) then goto Fail;
    Inc(p); Dec(l);
  until False;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function InternalBufIsCharsW(
  p: PWideChar; l: NativeUInt;
  const Validate: TValidateCharFuncW;
  const c: WideChar): Boolean; overload;
label
  Fail;
begin
  Assert(Assigned(p) or (l = 0));
  Assert(Assigned(Validate));

  while l >= 4 do
    begin
      if not Validate(p[0]) and (p[0] <> c) then goto Fail;
      if not Validate(p[1]) and (p[1] <> c) then goto Fail;
      if not Validate(p[2]) and (p[2] <> c) then goto Fail;
      if not Validate(p[3]) and (p[3] <> c) then goto Fail;
      Inc(p, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Break;
    if not Validate(p[0]) and (p[0] <> c) then goto Fail;
    Inc(p); Dec(l);
  until False;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function BufIsCharsW(
  const p: PWideChar; const l: NativeUInt;
  const Validate: TValidateCharFuncW): Boolean;
begin
  Result := not Assigned(p) or InternalBufIsCharsW(p, l, Validate)
end;

function BufIsCharsW(
  const p: PWideChar; const l: NativeUInt;
  const Validate: TValidateCharFuncW;
  const c: WideChar): Boolean;
begin
  Result := not Assigned(p) or InternalBufIsCharsW(p, l, Validate, c)
end;

function InternalBufHasCharsW(p: PWideChar; l: NativeUInt; const Validate: TValidateCharFuncW): Boolean;
label
  Match;
begin
  Assert(Assigned(p) or (l = 0));
  Assert(Assigned(Validate));

  while l >= 4 do
    begin
      if Validate(p^) or Validate(p[1]) or Validate(p[2]) or Validate(p[3]) then goto Match;
      Inc(p, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Break;
    if Validate(p^) then goto Match;
    Inc(p); Dec(l);
  until False;

  Result := False;
  Exit;

  Match:
  Result := True;
end;

function BufHasCharsW(const Buf: PWideChar; const BufCharCount: NativeUInt; const Validate: TValidateCharFuncW): Boolean;
begin
  Result := Assigned(Buf) and InternalBufHasCharsW(Buf, BufCharCount, Validate);
end;



function HashBuf(
  const Buffer;
  const BufferSize: Cardinal;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};
type
  TCardinal3 = packed record
    c1, c2, c3: Cardinal;
  end;
  PCardinal3 = ^TCardinal3;
var
  p: PCardinal3;
  a, b, l: {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};
begin
  a := $9E3779B9;
  b := a;
  Result := PreviousHash;

  p := @Buffer;
  l := BufferSize;

  while l >= 12 do
    begin
      Inc(a, p^.c1);
      Inc(b, p^.c2);
      Inc(Result, p^.c3);

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

      Inc(p);
      Dec(l, 12);
    end;

  Inc(Result, BufferSize);
  case l of
    11:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);

        Inc(Result, p^.c3 and $FFFFFF shl 8);
      end;
    10:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);

        Inc(Result, p^.c3 and $FFFF shl 8);
      end;
    9:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);

        Inc(Result, p^.c3 and $FF shl 8);
      end;
    8:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);
      end;
    7:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2 and $FFFFFF);
      end;
    6:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2 and $FFFF);
      end;
    5:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2 and $FF);
      end;
    4:
      begin
        Inc(a, p^.c1);
      end;
    3:
      begin
        Inc(a, p^.c1 and $FFFFFF);
      end;
    2:
      begin
        Inc(a, p^.c1 and $FFFF);
      end;
    1:
      begin
        Inc(a, p^.c1 and $FF);
      end;
  end;

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

end;

{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{$UNDEF Q_Temp}{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}

function HashBufIA(
  const Buffer;
  const AnsiCharCount: Cardinal;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};
label
  l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11;
type
  TAnsiChar4 = packed record
    case Boolean of
      True: (n: Cardinal);
      False: (c1, c2, c3, c4: AnsiChar);
  end;
  TAnsiChar12 = packed record
    c1, c2, c3, c4, C5, C6, c7, c8, c9, c10, c11, c12: AnsiChar;
  end;
  PAnsiChar12 = ^TAnsiChar12;
var
  p: PAnsiChar12;
  x: TAnsiChar4;
  a, b, l: {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};
begin
  a := $9E3779B9;
  b := a;
  Result := PreviousHash;

  p := @Buffer;
  l := AnsiCharCount;

  while l >= 12 do
    begin
      x.c1 := ANSI_UPPER_CHAR_TABLE[p^.c1];
      x.c2 := ANSI_UPPER_CHAR_TABLE[p^.c2];
      x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c3];
      x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c4];
      Inc(a, x.n);

      x.c1 := ANSI_UPPER_CHAR_TABLE[p^.C5];
      x.c2 := ANSI_UPPER_CHAR_TABLE[p^.C6];
      x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c7];
      x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c8];
      Inc(b, x.n);

      x.c1 := ANSI_UPPER_CHAR_TABLE[p^.c9];
      x.c2 := ANSI_UPPER_CHAR_TABLE[p^.c10];
      x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c11];
      x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c12];
      Inc(Result, x.n);

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

      Inc(p);
      Dec(l, 12);
    end;

  Inc(Result, AnsiCharCount);

  x.n := 0;
  case l of
    11: goto l11;
    10: goto l10;
    9: goto l9;
    8: goto l8;
    7: goto l7;
    6: goto l6;
    5: goto l5;
    4: goto l4;
    3: goto l3;
    2: goto l2;
    1: goto l1;
  else
    goto l0;
  end;

  l11:
  x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c11];
  l10:
  x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c10];
  l9:
  x.c2 := ANSI_UPPER_CHAR_TABLE[p^.c9];

  Inc(Result, x.n);

  l8:
  x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c8];
  l7:
  x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c7];
  l6:
  x.c2 := ANSI_UPPER_CHAR_TABLE[p^.C6];
  l5:
  x.c1 := ANSI_UPPER_CHAR_TABLE[p^.C5];
  Inc(b, x.n);

  l4:
  x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c4];
  l3:
  x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c3];
  l2:
  x.c2 := ANSI_UPPER_CHAR_TABLE[p^.c2];
  l1:
  x.c1 := ANSI_UPPER_CHAR_TABLE[p^.c1];
  Inc(a, x.n);

  l0:

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

end;


{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{$UNDEF Q_Temp}{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}

function HashBufIW(
  const Buffer;
  const WideCharCount: Cardinal;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};
label
  l0, l1, l2, l3, l4, l5;
type
  TWideChar2 = packed record
    case Boolean of
      True: (n: Cardinal);
      False: (c1, c2: WideChar);
  end;
  TWideChar6 = packed record
    c1, c2, c3, c4, C5, C6: WideChar;
  end;
  PWideChar6 = ^TWideChar6;
var
  p: PWideChar6;
  x: TWideChar2;
  a, b, l: {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};
begin
  a := $9E3779B9;
  b := a;
  Result := PreviousHash;

  p := @Buffer;
  l := WideCharCount;

  while l >= 6 do
    begin
      x.c1 := CharToCaseFoldW(p^.c1);
      x.c2 := CharToCaseFoldW(p^.c2);
      Inc(a, x.n);

      x.c1 := CharToCaseFoldW(p^.c3);
      x.c2 := CharToCaseFoldW(p^.c4);
      Inc(b, x.n);

      x.c1 := CharToCaseFoldW(p^.C5);
      x.c2 := CharToCaseFoldW(p^.C6);
      Inc(Result, x.n);

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

      Inc(p);
      Dec(l, 6);
    end;

  Inc(Result, WideCharCount);

  x.n := 0;
  case l of
    5: goto l5;
    4: goto l4;
    3: goto l3;
    2: goto l2;
    1: goto l1;
  else
    goto l0;
  end;

  l5:
  x.c2 := CharToCaseFoldW(p^.C5);

  Inc(b, x.n);

  l4:
  x.c2 := CharToCaseFoldW(p^.c4);
  l3:
  x.c1 := CharToCaseFoldW(p^.c3);
  l2:
  x.c2 := CharToCaseFoldW(p^.c2);
  l1:
  x.c1 := CharToCaseFoldW(p^.c1);
  Inc(a, x.n);

  l0:

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

end;

{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

function HashStrA(
  const s: RawByteString;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};
begin
  Result := HashBuf(Pointer(s)^, Length(s) * SizeOf(s[1]), PreviousHash);
end;

function HashStrW(
  const s: UnicodeString;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};
begin
  Result := HashBuf(Pointer(s)^, Length(s) * SizeOf(s[1]), PreviousHash);
end;

function HashStrIA(
  const s: RawByteString;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal = 0{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};
begin
  Result := HashBufIA(Pointer(s)^, Length(s), PreviousHash);
end;

function HashStrIW(
  const w: UnicodeString;
  const PreviousHash: {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF}): {$IFDEF COMPILER_4_UP}Cardinal{$ELSE}Integer{$ENDIF};
begin
  Result := HashBufIW(Pointer(w)^, Length(w), PreviousHash);
end;

{$UNDEF Q_Temp}{$IFOPT R+}{$DEFINE R_Temp}{$R-}{$ENDIF}

function HexCodePointToInt(const c: Cardinal): Integer;
label
  Error;
begin
  Result := c;
  Dec(Result, $30);
  if Result > $09 then
    begin
      Dec(Result, $07);
      if Result > $0F then
        begin
          Dec(Result, $20);
          if Result > $0F then
            goto Error;
        end;
      if Result < $0A then
        Error:
        Result := -1;
    end;
end;

{$IFDEF R_Temp}{$UNDEF R_Temp}{$R+}{$ENDIF}

function HexToInt(const s: string): Integer;
begin
  Result := {$IFDEF UNICODE}HexToIntW{$ELSE}HexToIntA{$ENDIF}(s);
end;

function HexToIntA(const s: RawByteString): Integer;
begin
  Result := BufHexToIntA(Pointer(s), Length(s));
end;

function HexToIntW(const s: UnicodeString): Integer;
begin
  Result := BufHexToIntW(Pointer(s), Length(s));
end;

function BufHexToInt(p: PChar; l: Cardinal): Integer;
begin
  Result := {$IFDEF UNICODE}BufHexToIntW{$ELSE}BufHexToIntA{$ENDIF}(p, l);
end;

function BufHexToIntA(p: PAnsiChar; l: Cardinal): Integer;
var
  c: Integer;
begin
  Assert(Assigned(p) or (l = 0));

  Result := 0;
  while l > 0 do
    begin
      c := HexCodePointToInt(Ord(p^));
      if c < 0 then Break;
      Result := Result shl 4 or c;
      Inc(p); Dec(l);
    end;
end;

function BufHexToIntW(p: PWideChar; l: Cardinal): Integer;
var
  c: Integer;
begin
  Assert(Assigned(p) or (l = 0));

  Result := 0;
  while l > 0 do
    begin
      c := HexCodePointToInt(Ord(p^));
      if c < 0 then Break;
      Result := Result shl 4 or c;
      Inc(p); Dec(l);
    end;
end;

procedure IncludeTrailingPathDelimiterByRef(var s: string);
begin
  {$IFDEF Unicode}StrIncludeTrailingCharW{$ELSE}StrIncludeTrailingCharA{$ENDIF}(s, PATH_DELIMITER);
end;

procedure IncludeTrailingPathDelimiterByRefA(var s: RawByteString);
begin
  StrIncludeTrailingCharA(s, AC_PATH_DELIMITER);
end;

procedure IncludeTrailingPathDelimiterByRefW(var w: UnicodeString);
begin
  StrIncludeTrailingCharW(w, WC_PATH_DELIMITER);
end;

procedure StrIncludeTrailingChar(var s: string; const c: Char);
begin
  {$IFDEF UNICODE}StrIncludeTrailingCharW{$ELSE}StrIncludeTrailingCharA{$ENDIF}(s, c);
end;

procedure StrIncludeTrailingCharA(var s: RawByteString; const c: AnsiChar);
var
  l: Cardinal;
begin
  l := Length(s);
  if (l = 0) or (s[l] <> c) then
    s := s + c;
end;

procedure StrIncludeTrailingCharW(var s: UnicodeString; const c: WideChar);
var
  l: Cardinal;
begin
  l := Length(s);
  if (l = 0) or (s[l] <> c) then
    s := s + c;
end;

function CharDecomposeHangulW(const c: WideChar): UnicodeString;
var
  SIndex, Rest: Cardinal;
begin
  SIndex := Ord(c) - HANGUL_SBase;
  Rest := SIndex mod HANGUL_TCount;
  if Rest = 0 then
    begin
      SetString(Result, nil, 2);
      PWideChar(Pointer(Result))^ := WideChar(HANGUL_LBase + SIndex div HANGUL_nCount);
      PWideChar(Pointer(Result))[1] := WideChar(HANGUL_VBase + SIndex mod HANGUL_nCount div HANGUL_TCount);
    end
  else
    begin
      SetString(Result, nil, 3);
      PWideChar(Pointer(Result))^ := WideChar(HANGUL_LBase + SIndex div HANGUL_nCount);
      PWideChar(Pointer(Result))[1] := WideChar(HANGUL_VBase + SIndex mod HANGUL_nCount div HANGUL_TCount);
      PWideChar(Pointer(Result))[2] := WideChar(HANGUL_TBase + Rest);
    end;
end;

{$IFDEF COMPILER_4_UP}

function IntToHex(const Value: Integer; const Digits: NativeInt): string;
begin
  Result := {$IFDEF UNICODE}IntToHexW{$ELSE}IntToHexA{$ENDIF}(Cardinal(Value), Digits);
end;

function IntToHex(const Value: Int64; const Digits: NativeInt): string;
begin
  Result := {$IFDEF UNICODE}IntToHexW{$ELSE}IntToHexA{$ENDIF}(UInt64(Value), Digits);
end;

{$IFDEF SUPPORTS_UINT64}
function IntToHex(const Value: UInt64; const Digits: NativeInt): string;
begin
  Result := {$IFDEF UNICODE}IntToHexW{$ELSE}IntToHexA{$ENDIF}(Value, Digits);
end;
{$ENDIF SUPPORTS_UINT64}

function IntToHexA(Value: UInt64; const Digits: NativeInt): RawByteString;
var
  l: NativeUInt;
  v: UInt64;
  p: PAnsiChar;
begin
  v := Value;
  l := 0;
  repeat
    Inc(l);
    v := v shr 4;
  until v = 0;

  if Digits > l then
    l := Digits;

  SetString(Result, nil, l);
  p := Pointer(Result);

  while Value > 0 do
    begin
      Dec(l);
      p[l] := AA_NUM_TO_HEX[Value and $000F];
      Value := Value shr 4;
    end;

  while l > 0 do
    begin
      Dec(l);
      p[l] := AC_DIGIT_ZERO;
    end;
end;

function IntToHexW(Value: UInt64; const Digits: NativeInt): UnicodeString;
var
  l: NativeUInt;
  v: UInt64;
  p: PWideChar;
begin
  v := Value;
  l := 0;
  repeat
    Inc(l);
    v := v shr 4;
  until v = 0;

  if Digits > l then
    l := Digits;

  SetString(Result, nil, l);
  p := Pointer(Result);

  while Value > 0 do
    begin
      Dec(l);
      p[l] := WA_NUM_TO_HEX[Value and $000F];
      Value := Value shr 4;
    end;

  while l > 0 do
    begin
      Dec(l);
      p[l] := WC_DIGIT_ZERO;
    end;
end;

{$ENDIF COMPILER_4_UP}

function IntToStrA(const i: Integer): RawByteString;
begin
  Str(i, Result);
end;

function IntToStrW(const i: Integer): UnicodeString;
var
  s: RawByteString;
begin
  Str(i, s);
  Result := s;
end;

{$IFDEF COMPILER_4_UP}

function IntToStrA(const i: Int64): RawByteString;
begin
  Str(i, Result);
end;

function IntToStrW(const i: Int64): UnicodeString;
var
  s: RawByteString;
begin
  Str(i, s);
  Result := s;
end;

{$ENDIF COMPILER_4_UP}

function StrIsEmpty(const s: string): Boolean;
begin
  Result := {$IFDEF UNICODE}StrIsEmptyW{$ELSE}StrIsEmptyA{$ENDIF}(s);
end;

function StrIsEmptyA(const s: RawByteString): Boolean;
label
  Fail, Success;
var
  p: PAnsiChar;
  l: Cardinal;
begin
  l := Length(s);
if l = 0 then goto Success;
p := Pointer(s);

while l >= 4 do
  begin
    if (p^ > #$20) or (p[1] > #$20) or (p[2] > #$20) or (p[3] > #$20) then goto Fail;
    Inc(p, 4); Dec(l, 4);
  end;

repeat
  if l = 0 then Break;
  if p^ > #$20 then goto Fail;
  Inc(p); Dec(l);
until False;

Success:
Result := True;
Exit;

Fail:
Result := False;

end;

function StrIsEmptyW(const s: UnicodeString): Boolean;
label
  Fail, Success;
var
  p: PWideChar;
  l: Cardinal;
begin
  l := Length(s);
if l = 0 then goto Success;
p := Pointer(s);

while l >= 4 do
  begin
    if (p^ > #$20) or (p[1] > #$20) or (p[2] > #$20) or (p[3] > #$20) then goto Fail;
    Inc(p, 4); Dec(l, 4);
  end;

repeat
  if l = 0 then Break;
  if p^ > #$20 then goto Fail;
  Inc(p); Dec(l);
until False;

Success:
Result := True;
Exit;

Fail:
Result := False;

end;

function IsPathDelimiter(const s: string; const Index: Cardinal): Boolean;
begin
  Result := {$IFDEF UNICODE}IsPathDelimiterW{$ELSE}IsPathDelimiterA{$ENDIF}(s, Index);
end;

function IsPathDelimiterA(const s: RawByteString; const Index: Cardinal): Boolean;
begin
  Result := (Index > 0) and (Index <= Cardinal(Length(s))) and (s[Index] = PATH_DELIMITER)
end;

function IsPathDelimiterW(const s: UnicodeString; const Index: Cardinal): Boolean;
begin
  Result := (Index > 0) and (Index <= Cardinal(Length(s))) and (s[Index] = PATH_DELIMITER)
end;

{$UNDEF Q_Temp}{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
{$UNDEF R_Temp}{$IFOPT R+}{$DEFINE R_Temp}{$R-}{$ENDIF}

function LeftMostBit(Value: Cardinal): ShortInt;
const
  MultiplyDeBruijnBitPosition: array[0..31] of ShortInt = (
    0, 9, 1, 10, 13, 21, 2, 29, 11, 14, 16, 18, 22, 25, 3, 30,
    8, 12, 20, 28, 15, 17, 24, 7, 19, 27, 23, 6, 26, 5, 4, 31);
begin
  if Value > 0 then
    begin
      Value := Value or Value shr 1;
      Value := Value or Value shr 2;
      Value := Value or Value shr 4;
      Value := Value or Value shr 8;
      Value := Value or Value shr 16;
      Result := MultiplyDeBruijnBitPosition[Value * $07C4ACDD shr 27];
    end
  else
    Result := -1;
end;

function LeftMostBit(Value: UInt64): ShortInt;
const
  MultiplyDeBruijnBitPosition: array[0..63] of ShortInt = (
    0, 47, 1, 56, 48, 27, 2, 60, 57, 49, 41, 37, 28, 16, 3, 61,
    54, 58, 35, 52, 50, 42, 21, 44, 38, 32, 29, 23, 17, 11, 4, 62,
    46, 55, 26, 59, 40, 36, 15, 53, 34, 51, 20, 43, 31, 22, 10, 45,
    25, 39, 14, 33, 19, 30, 9, 24, 13, 18, 8, 12, 7, 6, 5, 63);
begin
  if Value > 0 then
    begin
      Value := Value or Value shr 1;
      Value := Value or Value shr 2;
      Value := Value or Value shr 4;
      Value := Value or Value shr 8;
      Value := Value or Value shr 16;
      Value := Value or Value shr 32;
      Result := MultiplyDeBruijnBitPosition[Value * $03F79D71B4CB0A89 shr 58];
    end
  else
    Result := -1;
end;

{$IFDEF R_Temp}{$UNDEF R_Temp}{$R+}{$ENDIF}
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

function MakeMethod(const AData, ACode: Pointer): TMethod;
begin
  with Result do begin Data := AData; Code := ACode; end;
end;

function PadLeftA(const Source: RawByteString; const Count: Cardinal; const c: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_SPACE{$ENDIF}): RawByteString;
var
  i, l: Cardinal;
  p1, p2: PAnsiChar;
begin
  l := Length(Source);

  if Count > l then
    begin

      SetString(Result, nil, Count);
      p2 := Pointer(Result);
      i := Count - l;
      repeat
        Dec(i);
        p2[i] := c;
      until i = 0;

      if l > 0 then
        begin

          p1 := Pointer(Source);
          Inc(p2, Count - l);
          repeat
            Dec(l);
            p2[l] := p1[l];
          until l = 0;
        end;
    end
  else

    Result := Source;
end;

function PadLeftW(const Source: UnicodeString; const Count: Cardinal; const c: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_SPACE{$ENDIF}): UnicodeString;
var
  i, l: Cardinal;
  p1, p2: PWideChar;
begin
  l := Length(Source);

  if Count > l then
    begin

      SetString(Result, nil, Count);
      p2 := Pointer(Result);
      i := Count - l;
      repeat
        Dec(i);
        p2[i] := c;
      until i = 0;

      if l > 0 then
        begin

          p1 := Pointer(Source);
          Inc(p2, Count - l);
          repeat
            Dec(l);
            p2[l] := p1[l];
          until l = 0;
        end;
    end
  else

    Result := Source;
end;

function PadRightA(const Source: RawByteString; const Count: Cardinal; const c: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_SPACE{$ENDIF}): RawByteString;
var
  i, l: Cardinal;
  p1, p2: PAnsiChar;
begin
  l := Length(Source);

  if Count > l then
    begin
      SetString(Result, nil, Count);
      p2 := Pointer(Result);

      if l > 0 then
        begin

          p1 := Pointer(Source);
          i := l;
          repeat
            Dec(i);
            p2[i] := p1[i];
          until i = 0;

          Inc(p2, l);
        end;

      i := Count - l;
      repeat
        Dec(i);
        p2[i] := c;
      until i = 0;
    end
  else

    Result := Source;
end;

function PadRightW(const Source: UnicodeString; const Count: Cardinal; const c: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_SPACE{$ENDIF}): UnicodeString;
var
  i, l: Cardinal;
  p1, p2: PWideChar;
begin
  l := Length(Source);

  if Count > l then
    begin
      SetString(Result, nil, Count);
      p2 := Pointer(Result);

      if l > 0 then
        begin

          p1 := Pointer(Source);
          i := l;
          repeat
            Dec(i);
            p2[i] := p1[i];
          until i = 0;

          Inc(p2, l);
        end;

      i := Count - l;
      repeat
        Dec(i);
        p2[i] := c;
      until i = 0;
    end
  else

    Result := Source;
end;

function ProperCase(const s: string): string;
begin
  Result := {$IFDEF UNICODE}ProperCaseW{$ELSE}ProperCaseA{$ENDIF}(s);
end;

function ProperCaseA(const s: RawByteString): RawByteString;
begin
  Result := s;
  ProperCaseByRefA(Result);
end;

function ProperCaseW(const s: UnicodeString): UnicodeString;
begin
  Result := s;
  ProperCaseByRefW(Result);
end;

procedure ProperCaseByRefA(var s: RawByteString);
var
  l: Cardinal;
  p: PAnsiChar;
  LastWasSeparator: Boolean;
begin
  l := Length(s);
  if l = 0 then Exit;

  LastWasSeparator := True;
  UniqueString(AnsiString(s));
  p := Pointer(s);
  repeat

    if p^ = AC_APOSTROPHE then

    else
      if p^ in AS_WORD_SEPARATORS then
        LastWasSeparator := True
      else
        if LastWasSeparator then
          begin
            p^ := ANSI_UPPER_CHAR_TABLE[p^];
            LastWasSeparator := False;
          end
        else
          p^ := ANSI_LOWER_CHAR_TABLE[p^];
    Inc(p);
    Dec(l);
  until l = 0;
end;

procedure ProperCaseByRefW(var s: UnicodeString);
var
  l: Cardinal;
  p: PWideChar;
  LastWasSeparator: Boolean;
begin
  l := Length(s);
  if l = 0 then Exit;

  LastWasSeparator := True;
  {$IFDEF Unicode}UniqueString(s); {$ENDIF}
  p := Pointer(s);
  repeat

    if p^ = WC_APOSTROPHE then

    else
      if IsCharWordSeparatorW(p^) then
        LastWasSeparator := True
      else
        if LastWasSeparator then
          begin
            p^ := CharToTitleW(p^);
            LastWasSeparator := False;
          end
        else
          p^ := CharToLowerW(p^);
    Inc(p);
    Dec(l);
  until l = 0;
end;

function QuotedStrW(const s: UnicodeString; const Quote: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_QUOTATION_MARK{$ENDIF}): UnicodeString;
var
  lSrc, l, i: Cardinal;
  pSrc, p: PWideChar;
begin
  pSrc := Pointer(s);
  lSrc := Length(s);

  i := 0;
  p := pSrc;
  l := lSrc;
  while l > 0 do
    begin
      if p^ = Quote then Inc(i);
      Inc(p); Dec(l);
    end;

  SetString(Result, nil, lSrc + i + 2);
  p := Pointer(Result);
  p^ := Quote; Inc(p);

  while lSrc > 0 do
    begin
      p^ := pSrc^;
      if p^ = Quote then
        begin
          Inc(p); p^ := Quote;
        end;
      Inc(p); Inc(pSrc); Dec(lSrc);
    end;
  p^ := Quote;
end;

{$IFDEF MSWINDOWS}

function RegReadStrDef(const Key: HKEY; const SubKey, ValueName, Default: string; const Access: REGSAM = 0): string;
begin
  Result := {$IFDEF UNICODE}RegReadStrDefW{$ELSE}RegReadStrDefA{$ENDIF}(Key, SubKey, ValueName, Default, Access);
end;

function RegReadStrDefA(const Key: HKEY; const SubKey, ValueName, Default: AnsiString; const Access: REGSAM = 0): AnsiString;
label
  Fail;
var
  ResultKey: HKEY;
  ValueType: DWORD;
  DataSize: DWORD;
begin
  if RegOpenKeyExA(Key, Pointer(SubKey), 0, KEY_READ or (Access and KEY_WOW64_RES), ResultKey) <> ERROR_SUCCESS then goto Fail;
  if (RegQueryValueExA(ResultKey, Pointer(ValueName), nil, PDWord(@ValueType), nil, PDWord(@DataSize)) = ERROR_SUCCESS) and
    (ValueType in [REG_EXPAND_SZ, REG_SZ]) then
    begin
      SetString(Result, nil, DataSize - 1);
      if RegQueryValueExA(ResultKey, Pointer(ValueName), nil, nil, Pointer(Result), PDWord(@DataSize)) = ERROR_SUCCESS then
        begin
          RegCloseKey(ResultKey);
          Exit;
        end;
    end;
  RegCloseKey(ResultKey);
  Fail:
  Result := Default;
end;

function RegReadStrDefW(const Key: HKEY; const SubKey, ValueName, Default: UnicodeString; const Access: REGSAM = 0): UnicodeString;
label
  Fail;
var
  ResultKey: HKEY;
  ValueType: DWORD;
  DataSize: DWORD;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      if RegOpenKeyExW(Key, Pointer(SubKey), 0, KEY_READ or (Access and KEY_WOW64_RES), ResultKey) <> ERROR_SUCCESS then goto Fail;
      if (RegQueryValueExW(ResultKey, Pointer(ValueName), nil, PDWord(@ValueType), nil, PDWord(@DataSize)) = ERROR_SUCCESS) and
        (ValueType in [REG_EXPAND_SZ, REG_SZ]) then
        begin
          SetString(Result, nil, (DataSize div SizeOf(Result[1])) - 1);
          if RegQueryValueExW(ResultKey, Pointer(ValueName), nil, nil, Pointer(Result), PDWord(@DataSize)) = ERROR_SUCCESS then
            begin
              RegCloseKey(ResultKey);
              Exit;
            end;
        end;
      RegCloseKey(ResultKey);
      Fail:
      Result := Default;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    RegReadStrDefA(Key, SubKey, ValueName, Default);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

const
  HKLM_CURRENT_VERSION_NT = 'Software\Microsoft\Windows NT\CurrentVersion';
  HKLM_CURRENT_VERSION_WINDOWS = 'Software\Microsoft\Windows\CurrentVersion';

function RegReadRegisteredOrganization(const Access: REGSAM = 0): string;
begin
  Result := {$IFDEF UNICODE}RegReadRegisteredOrganizationW{$ELSE}RegReadRegisteredOrganizationA{$ENDIF}(Access);
end;

function RegReadRegisteredOrganizationA(const Access: REGSAM = 0): AnsiString;
begin
  Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOrganization', '', Access);
  if Result = '' then
    Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_WINDOWS, 'RegisteredOrganization', '', Access);
end;

function RegReadRegisteredOrganizationW(const Access: REGSAM = 0): UnicodeString;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    {$ENDIF}
    Result := RegReadStrDefW(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOrganization', '', Access)
      {$IFNDEF DI_No_Win_9X_Support}
  else
    Result := RegReadRegisteredOrganizationA;
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function RegReadRegisteredOwner(const Access: REGSAM = 0): string;
begin
  Result := {$IFDEF UNICODE}RegReadRegisteredOwnerW{$ELSE}RegReadRegisteredOwnerA{$ENDIF}(Access);
end;

function RegReadRegisteredOwnerA(const Access: REGSAM = 0): AnsiString;
begin
  Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOwner', '', Access);
  if Result = '' then
    Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_WINDOWS, 'RegisteredOwner', '', Access);
end;

function RegReadRegisteredOwnerW(const Access: REGSAM = 0): UnicodeString;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    {$ENDIF}
    Result := RegReadStrDefW(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOwner', '', Access)
      {$IFNDEF DI_No_Win_9X_Support}
  else
    Result := RegReadRegisteredOwnerA;
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

function StrDecodeUrlA(const Value: RawByteString): RawByteString;
var
  pSrc: PAnsiChar;
  lSrc: Cardinal;
  pDest: PAnsiChar;
  i1, i2: Integer;
begin
  lSrc := Length(Value);
  if lSrc = 0 then Exit;

  pSrc := Pointer(Value);

  SetString(Result, nil, lSrc);
  pDest := Pointer(Result);

  repeat
    case pSrc^ of
      AC_PERCENT_SIGN:
        begin
          if lSrc > 1 then
            begin
              i1 := HexCodePointToInt(Ord(pSrc[1]));
              if (i1 >= 0) and (lSrc > 2) then
                begin
                  i2 := HexCodePointToInt(Ord(pSrc[2]));
                  if i2 >= 0 then
                    begin
                      pDest^ := AnsiChar((i1 shl 4) or i2);
                      Inc(pDest);
                      Inc(pSrc, 3); Dec(lSrc, 3);
                      Continue;
                    end;
                end;
            end;

          pDest^ := AC_PERCENT_SIGN;
        end;
      AC_PLUS_SIGN:
        pDest^ := AC_SPACE;
    else
      pDest^ := pSrc^;
    end;

    Inc(pDest);
    Inc(pSrc); Dec(lSrc);
  until lSrc = 0;

  SetLength(Result, pDest - PAnsiChar(Result));
end;

function StrEncodeUrlA(const Value: RawByteString): RawByteString;

var
  pSrc: PAnsiChar;
  lSrc: Cardinal;
  pDest: PAnsiChar;
begin
  lSrc := Length(Value);
  if lSrc = 0 then Exit;

  pSrc := Pointer(Value);

  SetString(Result, nil, lSrc * 3);
  pDest := Pointer(Result);

  repeat
    case pSrc^ of
      AC_ASTERISK,
        AC_HYPHEN_MINUS,
        AC_FULL_STOP,
        AC_DIGIT_ZERO..AC_DIGIT_NINE,
        AC_COMMERCIAL_AT,
        AC_CAPITAL_A..AC_CAPITAL_Z,
        AC_LOW_LINE,
        AC_SMALL_A..AC_SMALL_Z:
        begin
          pDest^ := pSrc^;
          Inc(pDest);
        end;
      AC_SPACE:
        begin
          pDest^ := AC_PLUS_SIGN;
          Inc(pDest);
        end;
    else
      pDest^ := AC_PERCENT_SIGN;
      pDest[1] := AA_NUM_TO_HEX[Byte(pSrc^) shr 4];
      pDest[2] := AA_NUM_TO_HEX[Byte(pSrc^) and $0F];
      Inc(pDest, 3);
    end;

    Inc(pSrc); Dec(lSrc);
  until lSrc = 0;

  SetLength(Result, pDest - PAnsiChar(Result));
end;

function StrEnd(const s: PChar): PChar;
begin
  Result := {$IFDEF Unicode}StrEndW{$ELSE}StrEndA{$ENDIF}(s);
end;

function StrEndA(const s: PAnsiChar): PAnsiChar;
label
  0, 1, 2, 3;
begin
  Result := s;
  if Assigned(Result) then
    begin
      repeat
        if Result[0] = #0 then goto 0;
        if Result[1] = #0 then goto 1;
        if Result[2] = #0 then goto 2;
        if Result[3] = #0 then goto 3;
        Inc(Result, 4);
      until False;

      3: Inc(Result);
      2: Inc(Result);
      1: Inc(Result);
      0:
    end;
end;

function StrEndW(const s: PWideChar): PWideChar;
label
  0, 1, 2, 3;
begin
  Result := s;
  if Assigned(Result) then
    begin
      repeat
        if Result[0] = #0 then goto 0;
        if Result[1] = #0 then goto 1;
        if Result[2] = #0 then goto 2;
        if Result[3] = #0 then goto 3;
        Inc(Result, 4);
      until False;

      3: Inc(Result);
      2: Inc(Result);
      1: Inc(Result);
      0:
    end;
end;

function StrLen(const s: PChar): NativeUInt;
begin
  Result := {$IFDEF Unicode}StrLenW{$ELSE}StrLenA{$ENDIF}(s);
end;

function StrLenA(const s: PAnsiChar): NativeUInt;
begin
  Result := StrEndA(s) - s;
end;

function StrLenW(const s: PWideChar): NativeUInt;
begin
  Result := StrEndW(s) - s;
end;

{$IFDEF COMPILER_4_UP}

function StrRandom(const ASeed: RawByteString; const ACharacters: string; const ALength: Cardinal): string;
begin
  Result := {$IFDEF Unicode}StrRandomW{$ELSE}StrRandomA{$ENDIF}(ASeed, ACharacters, ALength);
end;

function StrRandomA(const ASeed: RawByteString; const ACharacters: RawByteString; const ALength: Cardinal): RawByteString;
var
  c, l: Cardinal;
  p: PAnsiChar;
begin
  l := ALength;
  SetString(Result, nil, l);
  if l > 0 then
    begin
      c := Length(ACharacters);
      p := Pointer(Result);
      with TMT19937.Create(ASeed) do
        try
          repeat
            p^ := ACharacters[genrand_int32 mod c + 1];
            Inc(p); Dec(l);
          until l = 0;
        finally
          Free;
        end;
    end;
end;

function StrRandomW(const ASeed: RawByteString; const ACharacters: UnicodeString; const ALength: Cardinal): UnicodeString;
var
  c, l: Cardinal;
  p: PWideChar;
begin
  l := ALength;
  SetString(Result, nil, l);
  if l > 0 then
    begin
      c := Length(ACharacters);
      p := Pointer(Result);
      with TMT19937.Create(ASeed) do
        try
          repeat
            p^ := ACharacters[genrand_int32 mod c + 1];
            Inc(p); Dec(l);
          until l = 0;
        finally
          Free;
        end;
    end;
end;

{$ENDIF COMPILER_4_UP}

procedure StrRemoveFromToIA(var Source: RawByteString; const FromString, ToString: RawByteString);
var
  l, lFromString, lToString: Integer;
  Dest, a2, b1, b2: Integer;
begin
  Dest := StrPosIA(FromString, Source, 1);
  if Dest = 0 then Exit;

  lFromString := Length(FromString);

  b1 := StrPosIA(ToString, Source, Dest + lFromString);
  if b1 = 0 then Exit;

  lToString := Length(ToString);
  Inc(b1, lToString);

  UniqueString(AnsiString(Source));

  while True do
    begin
      a2 := StrPosIA(FromString, Source, b1);
      if a2 = 0 then Break;

      b2 := StrPosIA(ToString, Source, a2 + lFromString);
      if b2 = 0 then Break;
      Inc(b2, lToString);

      System.Move(Source[b1], Source[Dest], (a2 - b1) * SizeOf(Source[1]));
      Inc(Dest, a2 - b1);
      b1 := b2;
    end;

  l := Length(Source) - b1;
  if l >= 0 then
    System.Move(Source[b1], Source[Dest], (l + 1) * SizeOf(Source[1]));
  SetLength(Source, Dest + l);
end;

procedure StrRemoveFromToIW(var Source: UnicodeString; const FromString, ToString: UnicodeString);
var
  l, lFromString, lToString: Integer;
  Dest, a2, b1, b2: Integer;
begin
  Dest := StrPosIW(FromString, Source, 1);
  if Dest = 0 then Exit;

  lFromString := Length(FromString);

  b1 := StrPosIW(ToString, Source, Dest + lFromString);
  if b1 = 0 then Exit;

  lToString := Length(ToString);
  Inc(b1, lToString);

  {$IFDEF Unicode}UniqueString(Source); {$ENDIF}

  while True do
    begin
      a2 := StrPosIW(FromString, Source, b1);
      if a2 = 0 then Break;

      b2 := StrPosIW(ToString, Source, a2 + lFromString);
      if b2 = 0 then Break;
      Inc(b2, lToString);

      System.Move(Source[b1], Source[Dest], (a2 - b1) * SizeOf(Source[1]));
      Inc(Dest, a2 - b1);
      b1 := b2;
    end;

  l := Length(Source) - b1;
  if l >= 0 then
    System.Move(Source[b1], Source[Dest], (l + 1) * SizeOf(Source[1]));
  SetLength(Source, Dest + l);
end;

procedure StrRemoveSpacingA(var s: RawByteString; const SpaceChars: TAnsiCharSet{$IFDEF SUPPORTS_DEFAULTPARAMS} = AS_WHITE_SPACE{$ENDIF}; const ReplaceChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_SPACE{$ENDIF});
label
  lblCopyUntilSpace;
var
  i, l: Cardinal;
  pRead, pWrite: PAnsiChar;
begin
  l := Length(s);
  if l = 0 then Exit;

  i := l;
  pRead := Pointer(s);

  if pRead^ in SpaceChars then
    begin
      repeat
        Inc(pRead); Dec(i);
      until (i = 0) or not (pRead^ in SpaceChars);
      if i = 0 then
        begin
          s := '';
          Exit;
        end
      else
        begin

          UniqueString(AnsiString(s));
          pWrite := Pointer(s);
          pRead := pWrite + l - i;
          goto lblCopyUntilSpace;
        end;
    end
  else
    begin

      repeat
        Dec(i); if i = 0 then Exit;
        Inc(pRead);
      until pRead^ in SpaceChars;
    end;

  UniqueString(AnsiString(s));
  pWrite := Pointer(s);
  pRead := pWrite + l - i;

  while i > 0 do
    begin
      Inc(pRead);
      Dec(i);

      if pRead^ in SpaceChars then
        begin

          while (i > 0) and (pRead^ in SpaceChars) do
            begin
              Inc(pRead);
              Dec(i);
            end;
          if i = 0 then Break;

          pWrite^ := ReplaceChar;
          Inc(pWrite);
        end;

      while (i > 0) and not (pRead^ in SpaceChars) do
        begin
          lblCopyUntilSpace:
          pWrite^ := pRead^;
          Inc(pWrite);
          Inc(pRead);
          Dec(i);
        end;

    end;

  SetLength(s, pWrite - PAnsiChar(s));
end;

procedure StrRemoveSpacingW(
  var w: UnicodeString;
  IsSpaceChar: TValidateCharFuncW{$IFDEF SUPPORTS_DEFAULTPARAMS} = nil{$ENDIF};
  const ReplaceChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_SPACE{$ENDIF});
var
  i, l: Cardinal;
  pRead, pWrite: PWideChar;
begin
  l := Length(w);

  if not Assigned(IsSpaceChar) then
    IsSpaceChar := CharIsWhiteSpaceW;

  pRead := Pointer(w);
  i := l;

  while (i > 0) and not IsSpaceChar(pRead^) do
    begin
      Inc(pRead);
      Dec(i);
    end;

  if i = 0 then Exit;

  {$IFDEF Unicode}UniqueString(w); {$ENDIF}
  pRead := PWideChar(w) + (l - i) * SizeOf(w[1]);
  pWrite := pRead;

  while i > 0 do
    begin

      Inc(pRead);
      Dec(i);

      if IsSpaceChar(pRead^) then
        begin

          pWrite^ := ReplaceChar;
          Inc(pWrite);

          while (i > 0) and IsSpaceChar(pRead^) do
            begin
              Inc(pRead);
              Dec(i);
            end;
        end;

      while (i > 0) and not IsSpaceChar(pRead^) do
        begin
          pWrite^ := pRead^;
          Inc(pWrite);
          Inc(pRead);
          Dec(i);
        end;

    end;

  SetLength(w, pWrite - PWideChar(w));
end;

procedure StrReplaceChar(var Source: string; const SearchChar, ReplaceChar: Char);
begin
  {$IFDEF Unicode}StrReplaceCharW{$ELSE}StrReplaceCharA{$ENDIF}(Source, SearchChar, ReplaceChar);
end;

procedure StrReplaceChar8(var s: Utf8String; const SearchChar, ReplaceChar: AnsiChar);
var
  p: PAnsiChar;
  l, i: Cardinal;
label
  Zero, One, Two, Three;
begin

  l := Length(s);
if l = 0 then Exit;

p := Pointer(s);
i := l;
while i >= 4 do
  begin
    if p[0] = SearchChar then goto Zero;
    if p[1] = SearchChar then goto One;
    if p[2] = SearchChar then goto Two;
    if p[3] = SearchChar then goto Three;
    Inc(p, 4); Dec(i, 4);
  end;

if i = 0 then Exit; if p^ = SearchChar then goto Zero;
if i = 1 then Exit; if p[1] = SearchChar then goto One;
if i = 2 then Exit; if p[2] = SearchChar then goto Two;
Exit;

Three: Dec(i);
Two: Dec(i);
One: Dec(i);
Zero:

UniqueString(AnsiString(s));

p := Pointer(s);
Inc(p, l - i);

p^ := ReplaceChar;
Inc(p); Dec(i);

while i >= 4 do
  begin
    if p^ = SearchChar then p^ := ReplaceChar;
    if p[1] = SearchChar then p[1] := ReplaceChar;
    if p[2] = SearchChar then p[2] := ReplaceChar;
    if p[3] = SearchChar then p[3] := ReplaceChar;
    Inc(p, 4); Dec(i, 4);
  end;

repeat
  if i = 0 then Break;
  if p^ = SearchChar then p^ := ReplaceChar;
  Inc(p); Dec(i);
until False;

end;

procedure StrReplaceCharA(var s: RawByteString; const SearchChar, ReplaceChar: AnsiChar);
var
  p: PAnsiChar;
  l, i: Cardinal;
label
  Zero, One, Two, Three;
begin

  l := Length(s);
if l = 0 then Exit;

p := Pointer(s);
i := l;
while i >= 4 do
  begin
    if p[0] = SearchChar then goto Zero;
    if p[1] = SearchChar then goto One;
    if p[2] = SearchChar then goto Two;
    if p[3] = SearchChar then goto Three;
    Inc(p, 4); Dec(i, 4);
  end;

if i = 0 then Exit; if p^ = SearchChar then goto Zero;
if i = 1 then Exit; if p[1] = SearchChar then goto One;
if i = 2 then Exit; if p[2] = SearchChar then goto Two;
Exit;

Three: Dec(i);
Two: Dec(i);
One: Dec(i);
Zero:

UniqueString(AnsiString(s));

p := Pointer(s);
Inc(p, l - i);

p^ := ReplaceChar;
Inc(p); Dec(i);

while i >= 4 do
  begin
    if p^ = SearchChar then p^ := ReplaceChar;
    if p[1] = SearchChar then p[1] := ReplaceChar;
    if p[2] = SearchChar then p[2] := ReplaceChar;
    if p[3] = SearchChar then p[3] := ReplaceChar;
    Inc(p, 4); Dec(i, 4);
  end;

repeat
  if i = 0 then Break;
  if p^ = SearchChar then p^ := ReplaceChar;
  Inc(p); Dec(i);
until False;

end;

procedure StrReplaceCharW(var s: UnicodeString; const SearchChar, ReplaceChar: WideChar);
var
  p: PWideChar;
  l, i: Cardinal;
label
  Zero, One, Two, Three;
begin

  l := Length(s);
if l = 0 then Exit;

p := Pointer(s);
i := l;
while i >= 4 do
  begin
    if p[0] = SearchChar then goto Zero;
    if p[1] = SearchChar then goto One;
    if p[2] = SearchChar then goto Two;
    if p[3] = SearchChar then goto Three;
    Inc(p, 4); Dec(i, 4);
  end;

if i = 0 then Exit; if p^ = SearchChar then goto Zero;
if i = 1 then Exit; if p[1] = SearchChar then goto One;
if i = 2 then Exit; if p[2] = SearchChar then goto Two;
Exit;

Three: Dec(i);
Two: Dec(i);
One: Dec(i);
Zero:

{$IFDEF Unicode}UniqueString(s); {$ENDIF}

p := Pointer(s);
Inc(p, l - i);

p^ := ReplaceChar;
Inc(p); Dec(i);

while i >= 4 do
  begin
    if p^ = SearchChar then p^ := ReplaceChar;
    if p[1] = SearchChar then p[1] := ReplaceChar;
    if p[2] = SearchChar then p[2] := ReplaceChar;
    if p[3] = SearchChar then p[3] := ReplaceChar;
    Inc(p, 4); Dec(i, 4);
  end;

repeat
  if i = 0 then Break;
  if p^ = SearchChar then p^ := ReplaceChar;
  Inc(p); Dec(i);
until False;

end;

function StrReplace(const Source, Search, Replace: string): string;
begin
  Result := {$IFDEF Unicode}StrReplaceW{$ELSE}StrReplaceA{$ENDIF}(Source, Search, Replace);
end;

function StrReplaceA(const Source, Search, Replace: RawByteString): RawByteString;
label
  Zero, One, Two, Three, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: AnsiChar;
  pSource, pSearch, pResult, pTemp, pTempSource: PAnsiChar;
  lSearch, lSource, lReplace, lTemp: Cardinal;
begin

  lSource := Length(Source);
  if lSource = 0 then goto ReturnEmptyString;

  lSearch := Length(Search);
  if lSearch = 0 then goto ReturnEmptyString;

  if lSearch > lSource then goto ReturnSourceString;

  pSource := Pointer(Source);
  pSearch := Pointer(Search);

  lReplace := Length(Replace);
  if lSearch > lReplace then
    SetLength(Result, lSource)
  else
    SetLength(Result, (lSource div lSearch) * lReplace + lSource mod lSearch);
  pResult := Pointer(Result);

  Dec(lSearch);

  while lSource > lSearch do
    begin

      c := pSearch^;
      while lSource >= 4 do
        begin
          if pSource^ = c then goto Zero;
          if pSource[1] = c then goto One;
          if pSource[2] = c then goto Two;
          if pSource[3] = c then goto Three;
          Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
          Inc(pSource, 4);
          Inc(pResult, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if pSource^ = c then goto Zero;
            if pSource[1] = c then goto One;
            if pSource[2] = c then goto Two;
            Word(Pointer(pResult)^) := Word(Pointer(pSource)^); pResult[2] := pSource[2];
            Inc(pResult, 3);
            Dec(lSource, 3);
          end;
        2:
          begin
            if pSource^ = c then goto Zero;
            if pSource[1] = c then goto One;
            Word(Pointer(pResult)^) := Word(Pointer(pSource)^);
            Inc(pResult, 2);
            Dec(lSource, 2);
          end;
        1:
          begin
            if pSource^ = c then goto Zero;
            pResult^ := pSource^;
            Inc(pResult);
            Dec(lSource);
          end;
      end;

      Break;

      Three:
      Word(Pointer(pResult)^) := Word(Pointer(pSource)^); pResult[2] := pSource[2];
      Inc(pSource, 4);
      Inc(pResult, 3);
      Dec(lSource, 4);
      goto Match;

      Two:
      Word(Pointer(pResult)^) := Word(Pointer(pSource)^);
      Inc(pSource, 3);
      Inc(pResult, 2);
      Dec(lSource, 3);
      goto Match;

      One:
      pResult^ := pSource^;
      Inc(pSource, 2);
      Inc(pResult);
      Dec(lSource, 2);
      goto Match;

      Zero:
      Inc(pSource);
      Dec(lSource);

      Match:

      pTempSource := pSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        (pTempSource^ = pTemp^) and
        (pTempSource[1] = pTemp[1]) and
        (pTempSource[2] = pTemp[2]) and
        (pTempSource[3] = pTemp[3]) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if ((lTemp = 1) and (pTempSource^ = pTemp^)) then goto Copy;
      if ((lTemp = 2) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1])) then goto Copy;
      if ((lTemp = 3) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1]) and (pTempSource[2] = pTemp[2])) then goto Copy;

      pResult^ := pSearch^;
      Inc(pResult);

      Continue;

      Copy:

      lTemp := lReplace;
      pTemp := Pointer(Replace);
      while lTemp >= 4 do
        begin
          Integer(Pointer(pResult)^) := Integer(Pointer(pTemp)^);
          Inc(pResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Word(Pointer(pResult)^) := Word(Pointer(pTemp)^);
            pResult[2] := pTemp[2];
            Inc(pResult, 3)
          end;
        2:
          begin
            Word(Pointer(pResult)^) := Word(Pointer(pTemp)^);
            Inc(pResult, 2);
          end;
        1:
          begin
            pResult^ := pTemp^;
            Inc(pResult);
          end;
      end;

      Inc(pSource, lSearch);
      Dec(lSource, lSearch);
    end;

  while lSource >= 4 do
    begin
      Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
      Inc(pResult, 4);
      Inc(pSource, 4);
      Dec(lSource, 4);
    end;
  case lSource of
    3:
      begin
        Word(Pointer(pResult)^) := Word(Pointer(pSource)^);
        pResult[2] := pSource[2];
        Inc(pResult, 3)
      end;
    2:
      begin
        Word(Pointer(pResult)^) := Word(Pointer(pSource)^);
        Inc(pResult, 2);
      end;
    1:
      begin
        pResult^ := pSource^;
        Inc(pResult);
      end;
  end;

  SetLength(Result, pResult - PAnsiChar(Result));
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function StrReplaceW(const Source, Search, Replace: UnicodeString): UnicodeString;
label
  Zero, One, Two, Three, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: WideChar;
  pSource, pSearch, pResult, pTemp, pTempSource: PWideChar;
  lSearch, lSource, lReplace, lTemp: Cardinal;
begin

  lSource := Length(Source);
  if lSource = 0 then goto ReturnEmptyString;

  lSearch := Length(Search);
  if lSearch = 0 then goto ReturnSourceString;

  if lSearch > lSource then goto ReturnSourceString;

  pSource := Pointer(Source);
  pSearch := Pointer(Search);

  lReplace := Length(Replace);
  if lSearch >= lReplace then
    SetString(Result, nil, lSource)
  else
    SetLength(Result, (lSource div lSearch) * lReplace + lSource mod lSearch);
  pResult := Pointer(Result);

  Dec(lSearch);

  while lSource > lSearch do
    begin

      c := pSearch^;
      while lSource >= 4 do
        begin
          if pSource^ = c then goto Zero;
          if pSource[1] = c then goto One;
          if pSource[2] = c then goto Two;
          if pSource[3] = c then goto Three;
          {$IFDEF COMPILER_4_UP}
          Int64(Pointer(pResult)^) := Int64(Pointer(pSource)^);
          {$ELSE COMPILER_4_UP}
          pResult[0] := pSource[0];
          pResult[1] := pSource[1];
          pResult[2] := pSource[2];
          pResult[3] := pSource[3];
          {$ENDIF COMPILER_4_UP}
          Inc(pSource, 4);
          Inc(pResult, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if pSource^ = c then goto Zero;
            if pSource[1] = c then goto One;
            if pSource[2] = c then goto Two;
            Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
            pResult[2] := pSource[2];
            Inc(pResult, 3);
            Dec(lSource, 3);
          end;
        2:
          begin
            if pSource^ = c then goto Zero;
            if pSource[1] = c then goto One;
            Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
            Inc(pResult, 2);
            Dec(lSource, 2);
          end;
        1:
          begin
            if pSource^ = c then goto Zero;
            pResult^ := pSource^;
            Inc(pResult);
            Dec(lSource);
          end;
      end;

      Break;

      Three:
      Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
      pResult[2] := pSource[2];
      Inc(pSource, 4);
      Inc(pResult, 3);
      Dec(lSource, 4);
      goto Match;

      Two:
      Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
      Inc(pSource, 3);
      Inc(pResult, 2);
      Dec(lSource, 3);
      goto Match;

      One:
      pResult^ := pSource^;
      Inc(pSource, 2);
      Inc(pResult);
      Dec(lSource, 2);
      goto Match;

      Zero:
      Inc(pSource);
      Dec(lSource);

      Match:

      pTempSource := pSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        (pTempSource^ = pTemp^) and
        (pTempSource[1] = pTemp[1]) and
        (pTempSource[2] = pTemp[2]) and
        (pTempSource[3] = pTemp[3]) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if (lTemp = 1) and (pTempSource^ = pTemp^) then goto Copy;
      if (lTemp = 2) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1]) then goto Copy;
      if (lTemp = 3) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1]) and (pTempSource[2] = pTemp[2]) then goto Copy;

      pResult^ := pSource[-1];
      Inc(pResult);

      Continue;

      Copy:

      lTemp := lReplace;
      pTemp := Pointer(Replace);
      while lTemp >= 4 do
        begin
          {$IFDEF COMPILER_4_UP}
          Int64(Pointer(pResult)^) := Int64(Pointer(pTemp)^);
          {$ELSE COMPILER_4_UP}
          pResult[0] := pTemp[0];
          pResult[1] := pTemp[1];
          pResult[2] := pTemp[2];
          pResult[3] := pTemp[3];
          {$ENDIF COMPILER_4_UP}
          Inc(pResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Integer(Pointer(pResult)^) := Integer(Pointer(pTemp)^);
            pResult[2] := pTemp[2];
            Inc(pResult, 3)
          end;
        2:
          begin
            Integer(Pointer(pResult)^) := Integer(Pointer(pTemp)^);
            Inc(pResult, 2);
          end;
        1:
          begin
            pResult^ := pTemp^;
            Inc(pResult);
          end;
      end;

      Inc(pSource, lSearch);
      Dec(lSource, lSearch);
    end;

  while lSource >= 4 do
    begin
      {$IFDEF COMPILER_4_UP}
      Int64(Pointer(pResult)^) := Int64(Pointer(pSource)^);
      {$ELSE COMPILER_4_UP}
      pResult[0] := pSource[0];
      pResult[1] := pSource[1];
      pResult[2] := pSource[2];
      pResult[3] := pSource[3];
      {$ENDIF COMPILER_4_UP}
      Inc(pResult, 4);
      Inc(pSource, 4);
      Dec(lSource, 4);
    end;
  case lSource of
    3:
      begin
        Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
        pResult[2] := pSource[2];
        Inc(pResult, 3)
      end;
    2:
      begin
        Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
        Inc(pResult, 2);
      end;
    1:
      begin
        pResult^ := pSource^;
        Inc(pResult);
      end;
  end;

  SetLength(Result, pResult - PWideChar(Result));
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;


const
  ANSI_REVERSE_CHAR_TABLE: array[AnsiChar] of AnsiChar = (
    #000, #001, #002, #003, #004, #005, #006, #007, #008, #009, #010, #011, #012, #013, #014, #015,
    #016, #017, #018, #019, #020, #021, #022, #023, #024, #025, #026, #027, #028, #029, #030, #031,
    #032, #033, #034, #035, #036, #037, #038, #039, #040, #041, #042, #043, #044, #045, #046, #047,
    #048, #049, #050, #051, #052, #053, #054, #055, #056, #057, #058, #059, #060, #061, #062, #063,
    #064, #097, #098, #099, #100, #101, #102, #103, #104, #105, #106, #107, #108, #109, #110, #111,
    #112, #113, #114, #115, #116, #117, #118, #119, #120, #121, #122, #091, #092, #093, #094, #095,
    #096, #065, #066, #067, #068, #069, #070, #071, #072, #073, #074, #075, #076, #077, #078, #079,
    #080, #081, #082, #083, #084, #085, #086, #087, #088, #089, #090, #123, #124, #125, #126, #127,
    #128, #129, #130, #131, #132, #133, #134, #135, #136, #137, #154, #139, #156, #141, #158, #143,
    #144, #145, #146, #147, #148, #149, #150, #151, #152, #153, #138, #155, #140, #157, #142, #255,
    #160, #161, #162, #163, #164, #165, #166, #167, #168, #169, #170, #171, #172, #173, #174, #175,
    #176, #177, #178, #179, #180, #181, #182, #183, #184, #185, #186, #187, #188, #189, #190, #191,
    #224, #225, #226, #227, #228, #229, #230, #231, #232, #233, #234, #235, #236, #237, #238, #239,
    #240, #241, #242, #243, #244, #245, #246, #215, #248, #249, #250, #251, #252, #253, #254, #223,
    #192, #193, #194, #195, #196, #197, #198, #199, #200, #201, #202, #203, #204, #205, #206, #207,
    #208, #209, #210, #211, #212, #213, #214, #247, #216, #217, #218, #219, #220, #221, #222, #159);


function StrReplaceI(const Source, Search, Replace: string): string;
begin
  Result := {$IFDEF Unicode}StrReplaceIW{$ELSE}StrReplaceIA{$ENDIF}(Source, Search, Replace);
end;

function StrReplaceIA(const Source, Search, Replace: RawByteString): RawByteString;
label
  Zero, One, Two, Three, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: AnsiChar;
  pSource, pSearch, pResult, pTemp, pTempSource: PAnsiChar;
  lSearch, lSource, lReplace, lTemp: Cardinal;
begin

  lSource := Length(Source);
  if lSource = 0 then goto ReturnEmptyString;

  lSearch := Length(Search);
  if lSearch = 0 then goto ReturnSourceString;

  if lSearch > lSource then goto ReturnSourceString;

  pSource := Pointer(Source);
  pSearch := Pointer(Search);

  lReplace := Length(Replace);
  if lSearch > lReplace then
    SetLength(Result, lSource)
  else
    SetLength(Result, (lSource div lSearch) * lReplace + lSource mod lSearch);
  pResult := Pointer(Result);

  Dec(lSearch);

  while lSource > lSearch do
    begin

      c := ANSI_UPPER_CHAR_TABLE[pSearch^];
      while lSource >= 4 do
        begin
          if ANSI_UPPER_CHAR_TABLE[pSource^] = c then goto Zero;
          if ANSI_UPPER_CHAR_TABLE[pSource[1]] = c then goto One;
          if ANSI_UPPER_CHAR_TABLE[pSource[2]] = c then goto Two;
          if ANSI_UPPER_CHAR_TABLE[pSource[3]] = c then goto Three;
          Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
          Inc(pSource, 4);
          Inc(pResult, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if ANSI_UPPER_CHAR_TABLE[pSource^] = c then goto Zero;
            if ANSI_UPPER_CHAR_TABLE[pSource[1]] = c then goto One;
            if ANSI_UPPER_CHAR_TABLE[pSource[2]] = c then goto Two;
            Word(Pointer(pResult)^) := Word(Pointer(pSource)^); pResult[2] := pSource[2];
            Inc(pResult, 3);
            Dec(lSource, 3);
          end;
        2:
          begin
            if ANSI_UPPER_CHAR_TABLE[pSource^] = c then goto Zero;
            if ANSI_UPPER_CHAR_TABLE[pSource[1]] = c then goto One;
            Word(Pointer(pResult)^) := Word(Pointer(pSource)^);
            Inc(pResult, 2);
            Dec(lSource, 2);
          end;
        1:
          begin
            if ANSI_UPPER_CHAR_TABLE[pSource^] = c then goto Zero;
            pResult^ := pSource^;
            Inc(pResult);
            Dec(lSource);
          end;
      end;

      Break;

      Three:
      Word(Pointer(pResult)^) := Word(Pointer(pSource)^);
      pResult[2] := pSource[2];
      Inc(pSource, 4);
      Inc(pResult, 3);
      Dec(lSource, 4);
      goto Match;

      Two:
      Word(Pointer(pResult)^) := Word(Pointer(pSource)^);
      Inc(pSource, 3);
      Inc(pResult, 2);
      Dec(lSource, 3);
      goto Match;

      One:
      pResult^ := pSource^;
      Inc(pSource, 2);
      Inc(pResult);
      Dec(lSource, 2);
      goto Match;

      Zero:
      Inc(pSource);
      Dec(lSource);

      Match:

      pTempSource := pSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^])) and
        ((pTempSource[1] = pTemp[1]) or (pTempSource[1] = ANSI_REVERSE_CHAR_TABLE[pTemp[1]])) and
        ((pTempSource[2] = pTemp[2]) or (pTempSource[2] = ANSI_REVERSE_CHAR_TABLE[pTemp[2]])) and
        ((pTempSource[3] = pTemp[3]) or (pTempSource[3] = ANSI_REVERSE_CHAR_TABLE[pTemp[3]])) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if ((lTemp = 1) and ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^]))) then goto Copy;
      if ((lTemp = 2) and ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^])) and ((pTempSource[1] = pTemp[1]) or (pTempSource[1] = ANSI_REVERSE_CHAR_TABLE[pTemp[1]]))) then goto Copy;
      if ((lTemp = 3) and ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^])) and ((pTempSource[1] = pTemp[1]) or (pTempSource[1] = ANSI_REVERSE_CHAR_TABLE[pTemp[1]])) and ((pTempSource[2] = pTemp[2]) or (pTempSource[2] = ANSI_REVERSE_CHAR_TABLE[pTemp[2]]))) then goto Copy;

      pResult^ := pSource[-1];
      Inc(pResult);

      Continue;

      Copy:

      lTemp := lReplace;
      pTemp := Pointer(Replace);
      while lTemp >= 4 do
        begin
          Integer(Pointer(pResult)^) := Integer(Pointer(pTemp)^);
          Inc(pResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Word(Pointer(pResult)^) := Word(Pointer(pTemp)^);
            pResult[2] := pTemp[2];
            Inc(pResult, 3)
          end;
        2:
          begin
            Word(Pointer(pResult)^) := Word(Pointer(pTemp)^);
            Inc(pResult, 2);
          end;
        1:
          begin
            pResult^ := pTemp^;
            Inc(pResult);
          end;
      end;

      Inc(pSource, lSearch);
      Dec(lSource, lSearch);
    end;

  while lSource >= 4 do
    begin
      Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
      Inc(pResult, 4);
      Inc(pSource, 4);
      Dec(lSource, 4);
    end;
  case lSource of
    3:
      begin
        Word(Pointer(pResult)^) := Word(Pointer(pSource)^);
        pResult[2] := pSource[2];
        Inc(pResult, 3)
      end;
    2:
      begin
        Word(Pointer(pResult)^) := Word(Pointer(pSource)^);
        Inc(pResult, 2);
      end;
    1:
      begin
        pResult^ := pSource^;
        Inc(pResult);
      end;
  end;

  SetLength(Result, pResult - PAnsiChar(Result));
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function StrReplaceIW(const Source, Search, Replace: UnicodeString): UnicodeString;
label
  Zero, One, Two, Three, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: WideChar;
  pSource, pSearch, pResult, pTemp, pTempSource: PWideChar;
  lSearch, lSource, lReplace, lTemp: Cardinal;
begin

  lSource := Length(Source);
  if lSource = 0 then goto ReturnEmptyString;

  lSearch := Length(Search);
  if lSearch = 0 then goto ReturnEmptyString;

  if lSearch > lSource then goto ReturnSourceString;

  pSource := Pointer(Source);
  pSearch := Pointer(Search);

  lReplace := Length(Replace);
  if lSearch >= lReplace then
    SetString(Result, nil, lSource)
  else
    SetLength(Result, (lSource div lSearch) * lReplace + lSource mod lSearch);
  pResult := Pointer(Result);

  Dec(lSearch);

  while lSource > lSearch do
    begin

      c := CharToCaseFoldW(pSearch^);
      while lSource >= 4 do
        begin
          if CharToCaseFoldW(pSource^) = c then goto Zero;
          if CharToCaseFoldW(pSource[1]) = c then goto One;
          if CharToCaseFoldW(pSource[2]) = c then goto Two;
          if CharToCaseFoldW(pSource[3]) = c then goto Three;
          {$IFDEF COMPILER_4_UP}
          Int64(Pointer(pResult)^) := Int64(Pointer(pSource)^);
          {$ELSE COMPILER_4_UP}
          pResult[0] := pSource[0];
          pResult[1] := pSource[1];
          pResult[2] := pSource[2];
          pResult[3] := pSource[3];
          {$ENDIF COMPILER_4_UP}
          Inc(pSource, 4);
          Inc(pResult, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if CharToCaseFoldW(pSource^) = c then goto Zero;
            if CharToCaseFoldW(pSource[1]) = c then goto One;
            if CharToCaseFoldW(pSource[2]) = c then goto Two;
            Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
            pResult[2] := pSource[2];
            Inc(pResult, 3);
            Dec(lSource, 3);
          end;
        2:
          begin
            if CharToCaseFoldW(pSource^) = c then goto Zero;
            if CharToCaseFoldW(pSource[1]) = c then goto One;
            Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
            Inc(pResult, 2);
            Dec(lSource, 2);
          end;
        1:
          begin
            if CharToCaseFoldW(pSource^) = c then goto Zero;
            pResult^ := pSource^;
            Inc(pResult);
            Dec(lSource);
          end;
      end;

      Break;

      Three:
      Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
      pResult[2] := pSource[2];
      Inc(pSource, 4);
      Inc(pResult, 3);
      Dec(lSource, 4);
      goto Match;

      Two:
      Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
      Inc(pSource, 3);
      Inc(pResult, 2);
      Dec(lSource, 3);
      goto Match;

      One:
      pResult^ := pSource^;
      Inc(pSource, 2);
      Inc(pResult);
      Dec(lSource, 2);
      goto Match;

      Zero:
      Inc(pSource);
      Dec(lSource);

      Match:

      pTempSource := pSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) and
        (CharToCaseFoldW(pTempSource[1]) = CharToCaseFoldW(pTemp[1])) and
        (CharToCaseFoldW(pTempSource[2]) = CharToCaseFoldW(pTemp[2])) and
        (CharToCaseFoldW(pTempSource[3]) = CharToCaseFoldW(pTemp[3])) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if (lTemp = 1) and (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) then goto Copy;
      if (lTemp = 2) and (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) and (CharToCaseFoldW(pTempSource[1]) = CharToCaseFoldW(pTemp[1])) then goto Copy;
      if (lTemp = 3) and (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) and (CharToCaseFoldW(pTempSource[1]) = CharToCaseFoldW(pTemp[1])) and (CharToCaseFoldW(pTempSource[2]) = CharToCaseFoldW(pTemp[2])) then goto Copy;

      pResult^ := pSource[-1];
      Inc(pResult);

      Continue;

      Copy:

      lTemp := lReplace;
      pTemp := Pointer(Replace);
      while lTemp >= 4 do
        begin
          {$IFDEF COMPILER_4_UP}
          Int64(Pointer(pResult)^) := Int64(Pointer(pTemp)^);
          {$ELSE COMPILER_4_UP}
          pResult[0] := pTemp[0];
          pResult[1] := pTemp[1];
          pResult[2] := pTemp[2];
          pResult[3] := pTemp[3];
          {$ENDIF COMPILER_4_UP}
          Inc(pResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Integer(Pointer(pResult)^) := Integer(Pointer(pTemp)^);
            pResult[2] := pTemp[2];
            Inc(pResult, 3)
          end;
        2:
          begin
            Integer(Pointer(pResult)^) := Integer(Pointer(pTemp)^);
            Inc(pResult, 2);
          end;
        1:
          begin
            pResult^ := pTemp^;
            Inc(pResult);
          end;
      end;

      Inc(pSource, lSearch);
      Dec(lSource, lSearch);
    end;

  while lSource >= 4 do
    begin
      {$IFDEF COMPILER_4_UP}
      Int64(Pointer(pResult)^) := Int64(Pointer(pSource)^);
      {$ELSE COMPILER_4_UP}
      pResult[0] := pSource[0];
      pResult[1] := pSource[1];
      pResult[2] := pSource[2];
      pResult[3] := pSource[3];
      {$ENDIF COMPILER_4_UP}
      Inc(pResult, 4);
      Inc(pSource, 4);
      Dec(lSource, 4);
    end;
  case lSource of
    3:
      begin
        Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
        pResult[2] := pSource[2];
        Inc(pResult, 3)
      end;
    2:
      begin
        Integer(Pointer(pResult)^) := Integer(Pointer(pSource)^);
        Inc(pResult, 2);
      end;
    1:
      begin
        pResult^ := pSource^;
        Inc(pResult);
      end;
  end;

  SetLength(Result, pResult - PWideChar(Result));
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function StrReplaceLoopA(const Source, Search, Replace: RawByteString): RawByteString;
begin
  Result := Source;
  while StrPosA(Search, Result, 1) > 0 do
    Result := StrReplaceA(Result, Search, Replace);
end;

function StrReplaceLoopW(const Source, Search, Replace: UnicodeString): UnicodeString;
begin
  Result := Source;
  while StrPosW(Search, Result, 1) > 0 do
    Result := StrReplaceW(Result, Search, Replace);
end;

function StrReplaceLoopIA(const Source, Search, Replace: RawByteString): RawByteString;
begin
  Result := Source;
  while StrPosIA(Search, Result, 1) > 0 do
    Result := StrReplaceIA(Result, Search, Replace);
end;

function StrReplaceLoopIW(const Source, Search, Replace: UnicodeString): UnicodeString;
begin
  Result := Source;
  while StrPosIW(Search, Result, 1) > 0 do
    Result := StrReplaceIW(Result, Search, Replace);
end;

{$UNDEF Q_Temp}{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
{$UNDEF R_Temp}{$IFOPT R+}{$DEFINE R_Temp}{$R-}{$ENDIF}

function RightMostBit(const Value: Cardinal): ShortInt;
const
  MultiplyDeBruijnBitPosition: array[0..31] of ShortInt = (
    0, 1, 28, 2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17, 4, 8,
    31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18, 6, 11, 5, 10, 9);
begin
  if Value > 0 then
    Result := MultiplyDeBruijnBitPosition[Cardinal(Value and -Value) * $077CB531 shr 27]
  else
    Result := -1;
end;

function RightMostBit(const Value: UInt64): ShortInt;
const
  MultiplyDeBruijnBitPosition: array[0..63] of ShortInt = (
    0, 47, 1, 56, 48, 27, 2, 60, 57, 49, 41, 37, 28, 16, 3, 61,
    54, 58, 35, 52, 50, 42, 21, 44, 38, 32, 29, 23, 17, 11, 4, 62,
    46, 55, 26, 59, 40, 36, 15, 53, 34, 51, 20, 43, 31, 22, 10, 45,
    25, 39, 14, 33, 19, 30, 9, 24, 13, 18, 8, 12, 7, 6, 5, 63);
begin
  if Value > 0 then
    Result := MultiplyDeBruijnBitPosition[(Value xor (Value - 1)) * $03F79D71B4CB0A89 shr 58]
  else
    Result := -1;
end;

{$IFDEF R_Temp}{$UNDEF R_Temp}{$R+}{$ENDIF}
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

function StrSame(const s1, s2: string): Boolean;
begin
  Result := {$IFDEF Unicode}StrSameW{$ELSE}StrSameA{$ENDIF}(s1, s2);
end;

function StrSameA(const s1, s2: RawByteString): Boolean;
var
  l1, l2: Cardinal;
begin
  l1 := Length(s1); l2 := Length(s2);
  Result := (l1 = l2) and ((l1 = 0) or CompareMem(Pointer(s1), Pointer(s2), l1 * SizeOf(s1[1])));
end;

function StrSameW(const s1, s2: UnicodeString): Boolean;
var
  l1, l2: Cardinal;
begin
  l1 := Length(s1); l2 := Length(s2);
  Result := (l1 = l2) and ((l1 = 0) or CompareMem(Pointer(s1), Pointer(s2), l1 * SizeOf(s1[1])));
end;

function StrSameI(const s1, s2: string): Boolean;
begin
  Result := {$IFDEF Unicode}StrSameIW{$ELSE}StrSameIA{$ENDIF}(s1, s2);
end;

function StrSameIA(const s1, s2: RawByteString): Boolean;
var
  l1, l2: Cardinal;
begin
  l1 := Length(s1); l2 := Length(s2);
  Result := (l1 = l2) and BufSameIA(Pointer(s1), Pointer(s2), l1);
end;

function StrSameIW(const s1, s2: UnicodeString): Boolean;
var
  l1, l2: Cardinal;
begin
  l1 := Length(s1); l2 := Length(s2);
  Result := (l1 = l2) and BufSameIW(Pointer(s1), Pointer(s2), l1);
end;

function StrSameStart(const s1, s2: string): Boolean;
begin
  Result := {$IFDEF Unicode}StrSameStartW{$ELSE}StrSameStartA{$ENDIF}(s1, s2);
end;

function StrSameStartA(const s1, s2: RawByteString): Boolean;
var
  l1, l2: Cardinal;
begin
  l1 := Length(s1); l2 := Length(s2);
  if l1 > l2 then l1 := l2;
  Result := (l1 = 0) or CompareMem(Pointer(s1), Pointer(s2), l1 * SizeOf(s1[1]));
end;

function StrSameStartW(const s1, s2: UnicodeString): Boolean;
var
  l1, l2: Cardinal;
begin
  l1 := Length(s1); l2 := Length(s2);
  if l1 > l2 then l1 := l2;
  Result := (l1 = 0) or CompareMem(Pointer(s1), Pointer(s2), l1 * SizeOf(s1[1]));
end;

function StrSameStartI(const s1, s2: string): Boolean;
begin
  Result := {$IFDEF Unicode}StrSameStartIW{$ELSE}StrSameStartIA{$ENDIF}(s1, s2);
end;

function StrSameStartIA(const s1, s2: RawByteString): Boolean;
var
  l1, l2: Cardinal;
begin
  l1 := Length(s1); l2 := Length(s2);
  if l1 > l2 then
    l1 := l2;
  Result := BufSameIA(Pointer(s1), Pointer(s2), l1);
end;

function StrSameStartIW(const s1, s2: UnicodeString): Boolean;
var
  l1, l2: Cardinal;
begin
  l1 := Length(s1); l2 := Length(s2);
  if l1 > l2 then
    l1 := l2;
  Result := BufSameIW(Pointer(s1), Pointer(s2), l1);
end;

{$IFDEF MSWINDOWS}

function LoadStrAFromFile(const FileHandle: THandle; var s: RawByteString): Boolean; overload;
var
  FileSize, NumberOfBytesRead: DWORD;
begin
  FileSize := {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.GetFileSize(FileHandle, nil);
  Result := FileSize <> INVALID_FILE_SIZE;
  if Result then
    begin
      SetString(s, nil, FileSize);
      Result := ReadFile(FileHandle, Pointer(s)^, FileSize, NumberOfBytesRead, nil) and
        (FileSize = NumberOfBytesRead);
      if not Result then SetLength(s, NumberOfBytesRead);
    end;
end;

function LoadStrAFromFile(const FileName: string; var s: RawByteString): Boolean; overload;
begin
  Result := {$IFDEF Unicode}LoadStrAFromFileW{$ELSE}LoadStrAFromFileA{$ENDIF}(FileName, s);
end;

function LoadStrAFromFileA(const FileName: AnsiString; var s: RawByteString): Boolean;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
    begin
      Result := LoadStrAFromFile(FileHandle, s);
      Result := CloseHandle(FileHandle) and Result;
    end
  else
    Result := False;
end;

function LoadStrAFromFileW(const FileName: UnicodeString; var s: RawByteString): Boolean;
var
  FileHandle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
      if FileHandle <> INVALID_HANDLE_VALUE then
        begin
          Result := LoadStrAFromFile(FileHandle, s);
          Result := CloseHandle(FileHandle) and Result;
        end
      else
        Result := False;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := LoadStrAFromFileA(FileName, s);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function LoadStrWFromFile(const FileHandle: THandle; var s: UnicodeString): Boolean; overload;
var
  FileSize, NumberOfBytesRead: DWORD;
begin
  FileSize := {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.GetFileSize(FileHandle, nil);
  if FileSize <> INVALID_FILE_SIZE then
    begin
      FileSize := FileSize and not 1;
      SetLength(s, FileSize shr 1);
      Result := ReadFile(FileHandle, Pointer(s)^, FileSize, NumberOfBytesRead, nil) and
        (FileSize = NumberOfBytesRead);
      if not Result then SetLength(s, NumberOfBytesRead shr 1);
    end
  else
    Result := False;
end;

function LoadStrWFromFile(const FileName: string; var s: UnicodeString): Boolean; overload;
begin
  Result := {$IFDEF Unicode}LoadStrWFromFileW{$ELSE}LoadStrWFromFileA{$ENDIF}(FileName, s);
end;

function LoadStrWFromFileA(const FileName: AnsiString; var s: UnicodeString): Boolean; overload;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
    begin
      Result := LoadStrWFromFile(FileHandle, s);
      Result := CloseHandle(FileHandle) and Result;
    end
  else
    Result := False;
end;

function LoadStrWFromFileW(const FileName: UnicodeString; var s: UnicodeString): Boolean;
var
  FileHandle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
      if FileHandle <> INVALID_HANDLE_VALUE then
        begin
          Result := LoadStrWFromFile(FileHandle, s);
          Result := CloseHandle(FileHandle) and Result;
        end
      else
        Result := False;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := LoadStrWFromFileA(FileName, s);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function SaveBufToFile(const Buffer; const BufferSize: Cardinal; const FileHandle: THandle): Boolean;
var
  NumberOfBytesWritten: DWORD;
begin
  Result := WriteFile(FileHandle, Buffer, BufferSize, NumberOfBytesWritten, nil)
    and (BufferSize = NumberOfBytesWritten);
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function SaveBufToFile(const Buffer; const BufferSize: Cardinal; const FileName: string): Boolean;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFile(PChar(FileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  Result := FileHandle <> INVALID_HANDLE_VALUE;
  if Result then
    begin
      Result := SaveBufToFile(Buffer, BufferSize, FileHandle);
      Result := CloseHandle(FileHandle) and Result;
    end;
end;

function SaveBufToFileA(const Buffer; const BufferSize: Cardinal; const FileName: AnsiString): Boolean;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
    begin
      Result := SaveBufToFile(Buffer, BufferSize, FileHandle);
      Result := CloseHandle(FileHandle) and Result;
    end
  else
    Result := False;
end;

function SaveBufToFileW(const Buffer; const BufferSize: Cardinal; const FileName: UnicodeString): Boolean;
var
  FileHandle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
      if FileHandle <> INVALID_HANDLE_VALUE then
        begin
          Result := SaveBufToFile(Buffer, BufferSize, FileHandle);
          Result := CloseHandle(FileHandle) and Result;
        end
      else
        Result := False;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := SaveBufToFileA(Buffer, BufferSize, FileName);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function SaveStrToFile(const s: string; const FileName: string): Boolean;
begin
  Result := SaveBufToFile(Pointer(s)^, Length(s) * SizeOf(s[1]), FileName);
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function SaveStrAToFile(const s: RawByteString; const FileName: string): Boolean;
begin
  Result := SaveBufToFile(Pointer(s)^, Length(s) * SizeOf(s[1]), FileName);
end;

function SaveStrAToFileA(const s: RawByteString; const FileName: AnsiString): Boolean;
begin
  Result := SaveBufToFileA(Pointer(s)^, Length(s) * SizeOf(s[1]), FileName);
end;

function SaveStrAToFileW(const s: RawByteString; const FileName: UnicodeString): Boolean;
begin
  Result := SaveBufToFileW(Pointer(s)^, Length(s) * SizeOf(s[1]), FileName);
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function SaveStrWToFile(const s: UnicodeString; const FileName: string): Boolean;
begin
  Result := SaveBufToFile(Pointer(s)^, Length(s) * SizeOf(s[1]), FileName);
end;

function SaveStrWToFileA(const s: UnicodeString; const FileName: AnsiString): Boolean;
begin
  Result := SaveBufToFileA(Pointer(s)^, Length(s) * SizeOf(s[1]), FileName);
end;

function SaveStrWToFileW(const s: UnicodeString; const FileName: UnicodeString): Boolean;
begin
  Result := SaveBufToFileW(Pointer(s)^, Length(s) * SizeOf(s[1]), FileName);
end;

{$ENDIF MSWINDOWS}

function StrPosChar(const Source: string; const c: Char; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
begin
  Result := {$IFDEF Unicode}StrPosCharW{$ELSE}StrPosCharA{$ENDIF}(Source, c, Start);
end;

function StrPosCharA(const Source: RawByteString; const c: AnsiChar; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  if Start = 0 then goto Fail;
  l := Length(Source);
  if Start > l then goto Fail;

  p := Pointer(Source);
  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if p^ = c then goto Zero;
      if p[1] = c then goto One;
      if p[2] = c then goto Two;
      if p[3] = c then goto Three;
      Inc(p, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ = c) then goto Zero;
        if (p[1] = c) then goto One;
        if (p[2] = c) then goto Two;
      end;
    2:
      begin
        if (p^ = c) then goto Zero;
        if (p[1] = c) then goto One;
      end;
    1:
      if (p^ = c) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := p - PAnsiChar(Source) + 1;
  Exit;

  One:
  Result := p - PAnsiChar(Source) + 2;
  Exit;

  Two:
  Result := p - PAnsiChar(Source) + 3;
  Exit;

  Three:
  Result := p - PAnsiChar(Source) + 4;
end;

function StrPosCharW(const Source: UnicodeString; const c: WideChar; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PWideChar;
begin
  l := Length(Source);
  if (Start = 0) or (Start > l) then goto Fail;

  p := Pointer(Source);
  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if p^ = c then goto Zero;
      if p[1] = c then goto One;
      if p[2] = c then goto Two;
      if p[3] = c then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p^ = c then goto Zero;
        if p[1] = c then goto One;
        if p[2] = c then goto Two;
      end;
    2:
      begin
        if p^ = c then goto Zero;
        if p[1] = c then goto One;
      end;
    1:
      if p^ = c then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := p - PWideChar(Source) + 1;
  Exit;

  One:
  Result := p - PWideChar(Source) + 2;
  Exit;

  Two:
  Result := p - PWideChar(Source) + 3;
  Exit;

  Three:
  Result := p - PWideChar(Source) + 4;
end;

function StrPosCharBack(
  const Source: string;
  const c: Char;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;
begin
  Result := {$IFDEF Unicode}StrPosCharBackW{$ELSE}StrPosCharBackA{$ENDIF}(Source, c, Start);
end;

function StrPosCharBackA(
  const Source: RawByteString;
  const c: AnsiChar;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  l := Length(Source);
  if (l = 0) or (Start > l) then goto Fail;
  if Start <> 0 then l := Start;

  p := Pointer(Source);
  Inc(p, l - 1);

  while l >= 4 do
    begin
      if p^ = c then goto Zero;
      if p[-1] = c then goto One;
      if p[-2] = c then goto Two;
      if p[-3] = c then goto Three;
      Dec(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ = c) then goto Zero;
        if (p[-1] = c) then goto One;
        if (p[-2] = c) then goto Two;
      end;
    2:
      begin
        if (p^ = c) then goto Zero;
        if (p[-1] = c) then goto One;
      end;
    1:
      if (p^ = c) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := p - PAnsiChar(Source) + 1;
  Exit;

  One:
  Result := p - PAnsiChar(Source);
  Exit;

  Two:
  Result := p - PAnsiChar(Source) - 1;
  Exit;

  Three:
  Result := p - PAnsiChar(Source) - 2;
end;

function StrPosCharBackW(
  const Source: UnicodeString;
  const c: WideChar;
  const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PWideChar;
begin
  l := Length(Source);
  if (l = 0) or (Start > l) then goto Fail;
  if Start <> 0 then l := Start;

  p := Pointer(Source);
  Inc(p, l - 1);

  while l >= 4 do
    begin
      if p^ = c then goto Zero;
      if p[-1] = c then goto One;
      if p[-2] = c then goto Two;
      if p[-3] = c then goto Three;
      Dec(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ = c) then goto Zero;
        if (p[-1] = c) then goto One;
        if (p[-2] = c) then goto Two;
      end;
    2:
      begin
        if (p^ = c) then goto Zero;
        if (p[-1] = c) then goto One;
      end;
    1:
      if (p^ = c) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := p - PWideChar(Source) + 1;
  Exit;

  One:
  Result := p - PWideChar(Source);
  Exit;

  Two:
  Result := p - PWideChar(Source) - 1;
  Exit;

  Three:
  Result := p - PWideChar(Source) - 2;
end;

function StrPosCharsA(const Source: RawByteString; const Search: TAnsiCharSet; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  l := Length(Source);
  if (Start = 0) or (Start > l) then goto Fail;

  p := Pointer(Source);
  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if p^ in Search then goto Zero;
      if p[1] in Search then goto One;
      if p[2] in Search then goto Two;
      if p[3] in Search then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
        if (p[2] in Search) then goto Two;
      end;
    2:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
      end;
    1:
      if (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := p - PAnsiChar(Source) + 1;
  Exit;

  One:
  Result := p - PAnsiChar(Source) + 2;
  Exit;

  Two:
  Result := p - PAnsiChar(Source) + 3;
  Exit;

  Three:
  Result := p - PAnsiChar(Source) + 4;
end;

function StrPosCharsW(const Source: UnicodeString; const Validate: TValidateCharFuncW; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PWideChar;
begin
  l := Length(Source);
  if (Start = 0) or (Start > l) then goto Fail;

  p := Pointer(Source);
  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if Validate(p^) then goto Zero;
      if Validate(p[1]) then goto One;
      if Validate(p[2]) then goto Two;
      if Validate(p[3]) then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if Validate(p^) then goto Zero;
        if Validate(p[1]) then goto One;
        if Validate(p[2]) then goto Two;
      end;
    2:
      begin
        if Validate(p^) then goto Zero;
        if Validate(p[1]) then goto One;
      end;
    1:
      if Validate(p^) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := p - PWideChar(Source) + 1;
  Exit;

  One:
  Result := p - PWideChar(Source) + 2;
  Exit;

  Two:
  Result := p - PWideChar(Source) + 3;
  Exit;

  Three:
  Result := p - PWideChar(Source) + 4;
end;

function StrPosCharsBackA(const Source: RawByteString; const Search: TAnsiCharSet; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  l := Length(Source);
  if (l = 0) or (Start > l) then goto Fail;
  if Start <> 0 then l := Start;

  p := Pointer(Source);
  Inc(p, l - 1);

  while l >= 4 do
    begin
      if p^ in Search then goto Zero;
      if p[-1] in Search then goto One;
      if p[-2] in Search then goto Two;
      if p[-3] in Search then goto Three;
      Dec(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ in Search) then goto Zero;
        if (p[-1] in Search) then goto One;
        if (p[-2] in Search) then goto Two;
      end;
    2:
      begin
        if (p^ in Search) then goto Zero;
        if (p[-1] in Search) then goto One;
      end;
    1:
      if (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := p - PAnsiChar(Source) + 1;
  Exit;

  One:
  Result := p - PAnsiChar(Source);
  Exit;

  Two:
  Result := p - PAnsiChar(Source) - 1;
  Exit;

  Three:
  Result := p - PAnsiChar(Source) - 2;
end;

function StrPosNotCharsA(const Source: RawByteString; const Search: TAnsiCharSet; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  l := Length(Source);
  if (Start = 0) or (Start > l) then goto Fail;

  p := Pointer(Source);
  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if not (p^ in Search) then goto Zero;
      if not (p[1] in Search) then goto One;
      if not (p[2] in Search) then goto Two;
      if not (p[3] in Search) then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[1] in Search) then goto One;
        if not (p[2] in Search) then goto Two;
      end;
    2:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[1] in Search) then goto One;
      end;
    1:
      if not (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := p - PAnsiChar(Source) + 1;
  Exit;

  One:
  Result := p - PAnsiChar(Source) + 2;
  Exit;

  Two:
  Result := p - PAnsiChar(Source) + 3;
  Exit;

  Three:
  Result := p - PAnsiChar(Source) + 4;
end;

function StrPosNotCharsW(const Source: UnicodeString; const Validate: TValidateCharFuncW; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PWideChar;
begin
  l := Length(Source);
  if (Start = 0) or (Start > l) then goto Fail;

  p := Pointer(Source);
  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if not Validate(p^) then goto Zero;
      if not Validate(p[1]) then goto One;
      if not Validate(p[2]) then goto Two;
      if not Validate(p[3]) then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not Validate(p^) then goto Zero;
        if not Validate(p[1]) then goto One;
        if not Validate(p[2]) then goto Two;
      end;
    2:
      begin
        if not Validate(p^) then goto Zero;
        if not Validate(p[1]) then goto One;
      end;
    1:
      if not Validate(p^) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := p - PWideChar(Source) + 1;
  Exit;

  One:
  Result := p - PWideChar(Source) + 2;
  Exit;

  Two:
  Result := p - PWideChar(Source) + 3;
  Exit;

  Three:
  Result := p - PWideChar(Source) + 4;
end;

function StrPosNotCharsBackA(const Source: RawByteString; const Search: TAnsiCharSet; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  l := Length(Source);
  if (l = 0) or (Start > l) then goto Fail;
  if Start <> 0 then l := Start;

  p := Pointer(Source);
  Inc(p, l - 1);

  while l >= 4 do
    begin
      if not (p^ in Search) then goto Zero;
      if not (p[-1] in Search) then goto One;
      if not (p[-2] in Search) then goto Two;
      if not (p[-3] in Search) then goto Three;
      Dec(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[-1] in Search) then goto One;
        if not (p[-2] in Search) then goto Two;
      end;
    2:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[-1] in Search) then goto One;
      end;
    1:
      if not (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := p - PAnsiChar(Source) + 1;
  Exit;

  One:
  Result := p - PAnsiChar(Source);
  Exit;

  Two:
  Result := p - PAnsiChar(Source) - 1;
  Exit;

  Three:
  Result := p - PAnsiChar(Source) - 2;
end;

{$IFDEF MSWINDOWS}

function SetFileDate(const FileHandle: THandle; const Year: Integer; const Month, Day: Word): Boolean;
var
  SystemTime: TSystemTime;
  FileTime: TFileTime;
begin
  with SystemTime do
    begin
      wYear := Year;
      wMonth := Month;
      wDay := Day;
      wHour := 0;
      wMinute := 0;
      wSecond := 0;
      wMilliSeconds := 0;
    end;
  Result :=
    SystemTimeToFileTime(SystemTime, FileTime) and
    SetFileTime(FileHandle, @FileTime, @FileTime, @FileTime);
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function SetFileDate(const FileName: string; const JulianDate: TJulianDate): Boolean;
begin
  Result := {$IFDEF Unicode}SetFileDateW{$ELSE}SetFileDateA{$ENDIF}(FileName, JulianDate);
end;

function SetFileDateA(const FileName: AnsiString; const JulianDate: TJulianDate): Boolean;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := SetFileDateYmdA(FileName, Year, Month, Day);
end;

function SetFileDateW(const FileName: UnicodeString; const JulianDate: TJulianDate): Boolean;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := SetFileDateYmdW(FileName, Year, Month, Day);
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

const
  FLAGS_AND_ATTRIBUTES: array[Boolean] of Cardinal = (0, FILE_FLAG_BACKUP_SEMANTICS);

function SetFileDateYmd(const FileName: string; const Year: Integer; const Month, Day: Word): Boolean;
begin
  Result := {$IFDEF Unicode}SetFileDateYmdW{$ELSE}SetFileDateYmdA{$ENDIF}(FileName, Year, Month, Day);
end;

function SetFileDateYmdA(const FileName: AnsiString; const Year: Integer; const Month, Day: Word): Boolean;
var
  FileHandle: THandle;
  FlagsAndAttributes: Cardinal;
begin
  FlagsAndAttributes := FLAGS_AND_ATTRIBUTES[DirectoryExistsA(FileName)];
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_EXISTING, FlagsAndAttributes, 0);
  Result := (FileHandle <> INVALID_HANDLE_VALUE) and
    SetFileDate(FileHandle, Year, Month, Day) and
    CloseHandle(FileHandle);
end;

function SetFileDateYmdW(const FileName: UnicodeString; const Year: Integer; const Month, Day: Word): Boolean;
var
  FileHandle: THandle;
  FlagsAndAttributes: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FlagsAndAttributes := FLAGS_AND_ATTRIBUTES[DirectoryExistsW(FileName)];
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_EXISTING, FlagsAndAttributes, 0);
      Result := (FileHandle <> INVALID_HANDLE_VALUE) and
        SetFileDate(FileHandle, Year, Month, Day) and
        CloseHandle(FileHandle);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := SetFileDateYmdA(FileName, Year, Month, Day);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

function StrComp(const s1, s2: string): Integer;
begin
  Result := {$IFDEF Unicode}StrCompW{$ELSE}StrCompA{$ENDIF}(s1, s2);
end;

function StrCompA(const s1, s2: RawByteString): Integer;
label
  0, 1, 2, 3;
var
  p1, p2: PAnsiChar;
  l, l1, l2: Integer;
begin
  p1 := Pointer(s1); p2 := Pointer(s2);

  l1 := Length(s1); l2 := Length(s2);
  if l1 > l2 then
    l := l2
  else
    l := l1;

  while l >= 4 do
    begin
      if p1^ <> p2^ then goto 0;
      if p1[1] <> p2[1] then goto 1;
      if p1[2] <> p2[2] then goto 2;
      if p1[3] <> p2[3] then goto 3;
      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
        if p1[2] <> p2[2] then goto 2;
      end;
    2:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
      end;
    1:
      begin
        if p1^ <> p2^ then goto 0;
      end;
  end;

  Result := l1 - l2;
  Exit;

  0:
  Result := Ord(p1^) - Ord(p2^);
  Exit;

  1:
  Result := Ord(p1[1]) - Ord(p2[1]);
  Exit;

  2:
  Result := Ord(p1[2]) - Ord(p2[2]);
  Exit;

  3:
  Result := Ord(p1[3]) - Ord(p2[3]);
end;

function StrCompI(const s1, s2: string): Integer;
begin
  Result := {$IFDEF Unicode}StrCompIW{$ELSE}StrCompIA{$ENDIF}(s1, s2);
end;

function StrCompIA(const s1, s2: RawByteString): Integer;
label
  Zero, One, Two, Three, Match;
var
  p1, p2: PAnsiChar;
  l, l1, l2: Integer;
begin
  p1 := Pointer(s1); p2 := Pointer(s2);

  l1 := Length(s1); l2 := Length(s2);
  if l1 > l2 then
    l := l2
  else
    l := l1;

  while l >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
      if (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto One;
      if (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Two;
      if (ANSI_UPPER_CHAR_TABLE[p1[3]] <> ANSI_UPPER_CHAR_TABLE[p2[3]]) then goto Three;
      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
        if (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto One;
        if (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Two;
      end;
    2:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
        if (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto One;
      end;
    1:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
      end;
  end;

  Result := l1 - l2;
  Exit;

  Match:
  Result := 0;
  Exit;

  Zero:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1^]) - Ord(ANSI_UPPER_CHAR_TABLE[p2^]);
  Exit;

  One:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1[1]]) - Ord(ANSI_UPPER_CHAR_TABLE[p2[1]]);
  Exit;

  Two:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1[2]]) - Ord(ANSI_UPPER_CHAR_TABLE[p2[2]]);
  Exit;

  Three:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1[3]]) - Ord(ANSI_UPPER_CHAR_TABLE[p2[3]]);
end;

function StrCompW(const s1, s2: UnicodeString): Integer;
label
  0, 1, 2, 3;
var
  p1, p2: PWideChar;
  l, l1, l2: NativeInt;
begin
  p1 := Pointer(s1); p2 := Pointer(s2);

  l1 := Length(s1); l2 := Length(s2);
  if l1 > l2 then
    l := l2
  else
    l := l1;

  while l >= 4 do
    begin
      if p1^ <> p2^ then goto 0;
      if p1[1] <> p2[1] then goto 1;
      if p1[2] <> p2[2] then goto 2;
      if p1[3] <> p2[3] then goto 3;
      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
        if p1[2] <> p2[2] then goto 2;
      end;
    2:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
      end;
    1:
      begin
        if p1^ <> p2^ then goto 0;
      end;
  end;

  Result := l1 - l2;
  Exit;

  0:
  Result := Ord(p1^) - Ord(p2^);
  Exit;

  1:
  Result := Ord(p1[1]) - Ord(p2[1]);
  Exit;

  2:
  Result := Ord(p1[2]) - Ord(p2[2]);
  Exit;

  3:
  Result := Ord(p1[3]) - Ord(p2[3]);
end;

function StrCompIW(const s1, s2: UnicodeString): Integer;
label
  0, 1, 2, 3;
var
  p1, p2: PWideChar;
  l, l1, l2: Integer;
begin
  p1 := Pointer(s1); p2 := Pointer(s2);

  l1 := Length(s1); l2 := Length(s2);
  if l1 > l2 then
    l := l2
  else
    l := l1;

  while l >= 4 do
    begin
      if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
      if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto 1;
      if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto 2;
      if (p1[3] <> p2[3]) and (CharToCaseFoldW(p1[3]) <> CharToCaseFoldW(p2[3])) then goto 3;
      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto 1;
        if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto 2;
      end;
    2:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto 1;
      end;
    1:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
      end;
  end;

  Result := l1 - l2;
  Exit;

  0:
  Result := Ord(CharToCaseFoldW(p1^)) - Ord(CharToCaseFoldW(p2^));
  Exit;

  1:
  Result := Ord(CharToCaseFoldW(p1[1])) - Ord(CharToCaseFoldW(p2[1]));
  Exit;

  2:
  Result := Ord(CharToCaseFoldW(p1[2])) - Ord(CharToCaseFoldW(p2[2]));
  Exit;

  3:
  Result := Ord(CharToCaseFoldW(p1[3])) - Ord(CharToCaseFoldW(p2[3]));
end;

function StrCompNum(const s1, s2: string): Integer;
begin
  Result := {$IFDEF Unicode}StrCompNumW{$ELSE}StrCompNumA{$ENDIF}(s1, s2);
end;

function StrCompNumA(const s1, s2: RawByteString): Integer;
begin
  Result := BufCompNumA(Pointer(s1), Length(s1), Pointer(s2), Length(s2));
end;

function StrCompNumW(const s1, s2: UnicodeString): Integer;
begin
  Result := BufCompNumW(Pointer(s1), Length(s1), Pointer(s2), Length(s2));
end;

function StrCompNumI(const s1, s2: string): Integer;
begin
  Result := {$IFDEF Unicode}StrCompNumIW{$ELSE}StrCompNumIA{$ENDIF}(s1, s2);
end;

function StrCompNumIA(const s1, s2: RawByteString): Integer;
begin
  Result := BufCompNumIA(Pointer(s1), Length(s1), Pointer(s2), Length(s2));
end;

function StrCompNumIW(const s1, s2: UnicodeString): Integer;
begin
  Result := BufCompNumIW(Pointer(s1), Length(s1), Pointer(s2), Length(s2));
end;

function StrContains(const Search, Source: string; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
begin
  Result := {$IFDEF Unicode}StrContainsW{$ELSE}StrContainsA{$ENDIF}(Search, Source, Start);
end;

function StrContainsA(const Search, Source: RawByteString; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
begin
  Result := StrPosA(Search, Source, Start) > 0;
end;

function StrContainsW(const ASearch, ASource: UnicodeString; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
begin
  Result := StrPosW(ASearch, ASource, AStartPos) > 0;
end;

function StrContainsI(const Search, Source: string; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
begin
  Result := {$IFDEF Unicode}StrContainsIW{$ELSE}StrContainsIA{$ENDIF}(Search, Source, Start);
end;

function StrContainsIA(const Search, Source: RawByteString; const Start: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
begin
  Result := StrPosIA(Search, Source, Start) > 0;
end;

function StrContainsIW(const ASearch, ASource: UnicodeString; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
begin
  Result := StrPosIW(ASearch, ASource, AStartPos) > 0;
end;

function StrCountChar(
  const ASource: string;
  const c: Char;
  const AStartIdx: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
begin
  Result := {$IFDEF Unicode}StrCountCharW{$ELSE}StrCountCharA{$ENDIF}(ASource, c, AStartIdx);
end;

function StrCountCharA(const ASource: RawByteString; const c: AnsiChar; const AStartIdx: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  Result := 0;
  if AStartIdx = 0 then Exit;

  l := Length(ASource);
  if AStartIdx > l then Exit;

  p := Pointer(ASource);
  Inc(p, AStartIdx - 1);
  Dec(l, AStartIdx - 1);

  while l >= 4 do
    begin
      if p^ = c then Inc(Result);
      if p[1] = c then Inc(Result);
      if p[2] = c then Inc(Result);
      if p[3] = c then Inc(Result);
      Inc(p, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Break;
    if p^ = c then Inc(Result);
    Inc(p); Dec(l);
  until False;
end;

function StrCountCharW(const ASource: UnicodeString; const c: WideChar; const AStartIdx: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
var
  l: Cardinal;
  p: PWideChar;
begin
  Result := 0;
  if AStartIdx = 0 then Exit;

  l := Length(ASource);
  if AStartIdx > l then Exit;

  p := Pointer(ASource);
  Inc(p, AStartIdx - 1);
  Dec(l, AStartIdx - 1);

  while l >= 4 do
    begin
      if p^ = c then Inc(Result);
      if p[1] = c then Inc(Result);
      if p[2] = c then Inc(Result);
      if p[3] = c then Inc(Result);
      Inc(p, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Break;
    if p^ = c then Inc(Result);
    Inc(p); Dec(l);
  until False;
end;

function StrMatchesA(const Search, Source: RawByteString; const AStartIdx: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
label
  Fail, Match;
var
  pSearch, pSource: PAnsiChar;
  lSearch, lSource: Cardinal;
begin
  if AStartIdx = 0 then goto Fail;

  lSearch := Length(Search);
  if lSearch = 0 then goto Match;

  lSource := Length(Source);
  if lSearch > lSource then goto Fail;
  if AStartIdx > lSource then goto Fail;

  pSource := Pointer(Source);
  Inc(pSource, AStartIdx - 1);

  pSearch := Pointer(Search);

  while lSearch >= 4 do
    begin
      if PCardinal(pSearch)^ <> PCardinal(pSource)^ then goto Fail;
      Inc(pSearch, 4); Inc(pSource, 4); Dec(lSearch, 4);
    end;

  repeat
    if lSearch = 0 then Break;
    if pSearch^ <> pSource^ then goto Fail;
    Inc(pSearch); Inc(pSource); Dec(lSearch);
  until False;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrMatchesIA(const Search, Source: RawByteString; const AStartIdx: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Boolean;
label
  Fail, Match;
var
  pSearch, pSource: PAnsiChar;
  lSearch, lSource: Cardinal;
begin
  if AStartIdx = 0 then goto Fail;

  lSearch := Length(Search);
  if lSearch = 0 then goto Match;

  lSource := Length(Source);
  if lSearch > lSource then goto Fail;
  if AStartIdx > lSource then goto Fail;

  pSource := Pointer(Source);
  Inc(pSource, AStartIdx - 1);

  pSearch := Pointer(Search);

  while lSearch >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[pSearch^] <> ANSI_UPPER_CHAR_TABLE[pSource^]) or
        (ANSI_UPPER_CHAR_TABLE[pSearch[1]] <> ANSI_UPPER_CHAR_TABLE[pSource[1]]) or
        (ANSI_UPPER_CHAR_TABLE[pSearch[2]] <> ANSI_UPPER_CHAR_TABLE[pSource[2]]) or
        (ANSI_UPPER_CHAR_TABLE[pSearch[3]] <> ANSI_UPPER_CHAR_TABLE[pSource[3]]) then goto Fail;
      Inc(pSearch, 4); Inc(pSource, 4); Dec(lSearch, 4);
    end;

  repeat
    if lSearch = 0 then Break;
    if ANSI_UPPER_CHAR_TABLE[pSearch^] <> ANSI_UPPER_CHAR_TABLE[pSource^] then goto Fail;
    Inc(pSearch); Inc(pSource); Dec(lSearch);
  until False;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrMatchWild(
  const Source, Mask: string;
  const WildChar: Char{$IFDEF SUPPORTS_DEFAULTPARAMS} = CHAR_ASTERISK{$ENDIF};
  const MaskChar: Char{$IFDEF SUPPORTS_DEFAULTPARAMS} = CHAR_QUESTION_MARK{$ENDIF}): Boolean;
begin
  Result := {$IFDEF Unicode}StrMatchWildW{$ELSE}StrMatchWildA{$ENDIF}(Source, Mask, WildChar, MaskChar);
end;

function StrMatchWildA(
  const Source, Mask: RawByteString;
  const WildChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_ASTERISK{$ENDIF};
  const MaskChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_QUESTION_MARK{$ENDIF}): Boolean;
label
  Failure, Success, BackTrack;
var
  c: AnsiChar;
  SourcePtr, MaskPtr, LastWild, LastSource: PAnsiChar;
  SourceLength, MaskLength: Cardinal;
begin
  SourcePtr := Pointer(Source); SourceLength := Length(Source);
  MaskPtr := Pointer(Mask); MaskLength := Length(Mask);

  while (SourceLength > 0) and (MaskLength > 0) do
    begin
      c := MaskPtr^;
      if (c = WildChar) or ((c <> MaskChar) and (c <> SourcePtr^)) then Break;
      Inc(MaskPtr); Inc(SourcePtr);
      Dec(MaskLength); Dec(SourceLength);
    end;

  if MaskLength > 0 then
    begin
      if MaskPtr^ = WildChar then
        begin

          repeat

            while (MaskLength > 0) and (MaskPtr^ = WildChar) do
              begin
                Inc(MaskPtr); Dec(MaskLength);
              end;

            if MaskLength = 0 then goto Success;

            LastWild := MaskPtr;

            BackTrack:

            c := MaskPtr^;
            while (SourceLength > 0) and (c <> MaskChar) and (c <> SourcePtr^) do
              begin
                Inc(SourcePtr); Dec(SourceLength);
              end;

            if SourceLength = 0 then goto Failure;

            Inc(SourcePtr); Dec(SourceLength);

            LastSource := SourcePtr;

            Inc(MaskPtr); Dec(MaskLength);

            while (SourceLength > 0) and (MaskLength > 0) do
              begin
                c := MaskPtr^;
                if (c = WildChar) or ((c <> MaskChar) and (c <> SourcePtr^)) then Break;
                Inc(MaskPtr); Inc(SourcePtr);
                Dec(MaskLength); Dec(SourceLength);
              end;

            if (MaskLength > 0) and (MaskPtr^ <> WildChar) then
              begin
                Inc(MaskLength, MaskPtr - LastWild);
                MaskPtr := LastWild;

                Inc(SourceLength, SourcePtr - LastSource);
                SourcePtr := LastSource;

                goto BackTrack;
              end;

          until MaskLength = 0;

          if SourceLength = 0 then goto Success;

          MaskLength := MaskPtr - LastWild;

          MaskPtr := LastWild;

          Inc(SourcePtr, SourceLength); Dec(SourcePtr, MaskLength);

          while (MaskLength > 0) do
            begin
              c := MaskPtr^;
              if (c <> MaskChar) and (c <> SourcePtr^) then Break;
              Inc(MaskPtr); Inc(SourcePtr);
              Dec(MaskLength);
            end;

          if MaskLength = 0 then goto Success;
        end;
    end
  else
    if SourceLength = 0 then
      goto Success;

  Failure:
  Result := False;
  Exit;

  Success:
  Result := True;
end;

function StrMatchWildW(
  const Source, Mask: UnicodeString;
  const WildChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_ASTERISK{$ENDIF};
  const MaskChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_QUESTION_MARK{$ENDIF}): Boolean;
label
  Failure, Success, BackTrack;
var
  c: WideChar;
  SourcePtr, MaskPtr, LastWild, LastSource: PWideChar;
  SourceLength, MaskLength: Cardinal;
begin
  SourcePtr := Pointer(Source); SourceLength := Length(Source);
  MaskPtr := Pointer(Mask); MaskLength := Length(Mask);

  while (SourceLength > 0) and (MaskLength > 0) do
    begin
      c := MaskPtr^;
      if (c = WildChar) or ((c <> MaskChar) and (c <> SourcePtr^)) then Break;
      Inc(MaskPtr); Inc(SourcePtr);
      Dec(MaskLength); Dec(SourceLength);
    end;

  if MaskLength > 0 then
    begin
      if MaskPtr^ = WildChar then
        begin

          repeat

            while (MaskLength > 0) and (MaskPtr^ = WildChar) do
              begin
                Inc(MaskPtr); Dec(MaskLength);
              end;

            if MaskLength = 0 then goto Success;

            LastWild := MaskPtr;

            BackTrack:

            c := MaskPtr^;
            while (SourceLength > 0) and (c <> MaskChar) and (c <> SourcePtr^) do
              begin
                Inc(SourcePtr); Dec(SourceLength);
              end;

            if SourceLength = 0 then goto Failure;

            Inc(SourcePtr); Dec(SourceLength);

            LastSource := SourcePtr;

            Inc(MaskPtr); Dec(MaskLength);

            while (SourceLength > 0) and (MaskLength > 0) do
              begin
                c := MaskPtr^;
                if (c = WildChar) or ((c <> MaskChar) and (c <> SourcePtr^)) then Break;
                Inc(MaskPtr); Inc(SourcePtr);
                Dec(MaskLength); Dec(SourceLength);
              end;

            if (MaskLength > 0) and (MaskPtr^ <> WildChar) then
              begin
                Inc(MaskLength, MaskPtr - LastWild);
                MaskPtr := LastWild;

                Inc(SourceLength, SourcePtr - LastSource);
                SourcePtr := LastSource;

                goto BackTrack;
              end;

          until MaskLength = 0;

          if SourceLength = 0 then goto Success;

          MaskLength := MaskPtr - LastWild;

          MaskPtr := LastWild;

          Inc(SourcePtr, SourceLength); Dec(SourcePtr, MaskLength);

          while (MaskLength > 0) do
            begin
              c := MaskPtr^;
              if (c <> MaskChar) and (c <> SourcePtr^) then Break;
              Inc(MaskPtr); Inc(SourcePtr);
              Dec(MaskLength);
            end;

          if MaskLength = 0 then goto Success;
        end;
    end
  else
    if SourceLength = 0 then
      goto Success;

  Failure:
  Result := False;
  Exit;

  Success:
  Result := True;
end;

function StrMatchWildI(
  const Source, Mask: string;
  const WildChar: Char{$IFDEF SUPPORTS_DEFAULTPARAMS} = CHAR_ASTERISK{$ENDIF};
  const MaskChar: Char{$IFDEF SUPPORTS_DEFAULTPARAMS} = CHAR_QUESTION_MARK{$ENDIF}): Boolean;
begin
  Result := {$IFDEF Unicode}StrMatchWildIW{$ELSE}StrMatchWildIA{$ENDIF}(Source, Mask, WildChar, MaskChar);
end;

function StrMatchWildIA(
  const Source, Mask: RawByteString;
  const WildChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_ASTERISK{$ENDIF};
  const MaskChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_QUESTION_MARK{$ENDIF}): Boolean;
label
  Failure, Success, BackTrack;
var
  c: AnsiChar;
  SourcePtr, MaskPtr, LastWild, LastSource: PAnsiChar;
  SourceLength, MaskLength: Cardinal;
begin
  SourcePtr := Pointer(Source); SourceLength := Length(Source);
  MaskPtr := Pointer(Mask); MaskLength := Length(Mask);

  while (SourceLength > 0) and (MaskLength > 0) do
    begin
      c := MaskPtr^;
      if (c = WildChar) or ((c <> MaskChar) and (ANSI_UPPER_CHAR_TABLE[c] <> ANSI_UPPER_CHAR_TABLE[SourcePtr^])) then Break;
      Inc(MaskPtr); Inc(SourcePtr);
      Dec(MaskLength); Dec(SourceLength);
    end;

  if MaskLength > 0 then
    begin
      if MaskPtr^ = WildChar then
        begin

          repeat

            while (MaskLength > 0) and (MaskPtr^ = WildChar) do
              begin
                Inc(MaskPtr); Dec(MaskLength);
              end;

            if MaskLength = 0 then goto Success;

            LastWild := MaskPtr;

            BackTrack:

            c := ANSI_UPPER_CHAR_TABLE[MaskPtr^];
            while (SourceLength > 0) and (c <> MaskChar) and (c <> ANSI_UPPER_CHAR_TABLE[SourcePtr^]) do
              begin
                Inc(SourcePtr); Dec(SourceLength);
              end;

            if SourceLength = 0 then goto Failure;

            Inc(SourcePtr); Dec(SourceLength);

            LastSource := SourcePtr;

            Inc(MaskPtr); Dec(MaskLength);

            while (SourceLength > 0) and (MaskLength > 0) do
              begin
                c := MaskPtr^;
                if (c = WildChar) or ((c <> MaskChar) and (ANSI_UPPER_CHAR_TABLE[c] <> ANSI_UPPER_CHAR_TABLE[SourcePtr^])) then Break;
                Inc(MaskPtr); Inc(SourcePtr);
                Dec(MaskLength); Dec(SourceLength);
              end;

            if (MaskLength > 0) and (MaskPtr^ <> WildChar) then
              begin
                Inc(MaskLength, MaskPtr - LastWild);
                MaskPtr := LastWild;

                Inc(SourceLength, SourcePtr - LastSource);
                SourcePtr := LastSource;

                goto BackTrack;
              end;

          until MaskLength = 0;

          if SourceLength = 0 then goto Success;

          MaskLength := MaskPtr - LastWild;

          MaskPtr := LastWild;

          Inc(SourcePtr, SourceLength); Dec(SourcePtr, MaskLength);

          while (MaskLength > 0) do
            begin
              c := MaskPtr^;
              if (c <> MaskChar) and (ANSI_UPPER_CHAR_TABLE[c] <> ANSI_UPPER_CHAR_TABLE[SourcePtr^]) then Break;
              Inc(MaskPtr); Inc(SourcePtr);
              Dec(MaskLength);
            end;

          if MaskLength = 0 then goto Success;
        end;
    end
  else
    if SourceLength = 0 then
      goto Success;

  Failure:
  Result := False;
  Exit;

  Success:
  Result := True;
end;

function StrMatchWildIW(
  const Source, Mask: UnicodeString;
  const WildChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_ASTERISK{$ENDIF};
  const MaskChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_QUESTION_MARK{$ENDIF}): Boolean;
label
  Failure, Success, BackTrack;
var
  c: WideChar;
  SourcePtr, MaskPtr, LastWild, LastSource: PWideChar;
  SourceLength, MaskLength: Cardinal;
begin
  SourcePtr := Pointer(Source); SourceLength := Length(Source);
  MaskPtr := Pointer(Mask); MaskLength := Length(Mask);

  while (SourceLength > 0) and (MaskLength > 0) do
    begin
      c := MaskPtr^;
      if (c = WildChar) or ((c <> MaskChar) and (CharToCaseFoldW(c) <> CharToCaseFoldW(SourcePtr^))) then Break;
      Inc(MaskPtr); Inc(SourcePtr);
      Dec(MaskLength); Dec(SourceLength);
    end;

  if MaskLength > 0 then
    begin
      if MaskPtr^ = WildChar then
        begin

          repeat

            while (MaskLength > 0) and (MaskPtr^ = WildChar) do
              begin
                Inc(MaskPtr); Dec(MaskLength);
              end;

            if MaskLength = 0 then goto Success;

            LastWild := MaskPtr;

            BackTrack:

            c := CharToCaseFoldW(MaskPtr^);
            while (SourceLength > 0) and (c <> MaskChar) and (c <> CharToCaseFoldW(SourcePtr^)) do
              begin
                Inc(SourcePtr); Dec(SourceLength);
              end;

            if SourceLength = 0 then goto Failure;

            Inc(SourcePtr); Dec(SourceLength);

            LastSource := SourcePtr;

            Inc(MaskPtr); Dec(MaskLength);

            while (SourceLength > 0) and (MaskLength > 0) do
              begin
                c := MaskPtr^;
                if (c = WildChar) or ((c <> MaskChar) and (CharToCaseFoldW(c) <> CharToCaseFoldW(SourcePtr^))) then Break;
                Inc(MaskPtr); Inc(SourcePtr);
                Dec(MaskLength); Dec(SourceLength);
              end;

            if (MaskLength > 0) and (MaskPtr^ <> WildChar) then
              begin
                Inc(MaskLength, MaskPtr - LastWild);
                MaskPtr := LastWild;

                Inc(SourceLength, SourcePtr - LastSource);
                SourcePtr := LastSource;

                goto BackTrack;
              end;

          until MaskLength = 0;

          if SourceLength = 0 then goto Success;

          MaskLength := MaskPtr - LastWild;

          MaskPtr := LastWild;

          Inc(SourcePtr, SourceLength); Dec(SourcePtr, MaskLength);

          while (MaskLength > 0) do
            begin
              c := MaskPtr^;
              if (c <> MaskChar) and (CharToCaseFoldW(c) <> CharToCaseFoldW(SourcePtr^)) then Break;
              Inc(MaskPtr); Inc(SourcePtr);
              Dec(MaskLength);
            end;

          if MaskLength = 0 then goto Success;
        end;
    end
  else
    if SourceLength = 0 then
      goto Success;

  Failure:
  Result := False;
  Exit;

  Success:
  Result := True;
end;

function StrPos(const ASearch, ASource: string; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
begin
  Result := {$IFDEF Unicode}StrPosW{$ELSE}StrPosA{$ENDIF}(ASearch, ASource, AStartPos);
end;

function StrPosA(const ASearch, ASource: RawByteString; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
begin
  Result := AStartPos;
  if Result > 0 then
    Result := InternalPosA(Pointer(ASearch), Length(ASearch), Pointer(ASource), Length(ASource), Result - 1);
end;

function StrPosW(const ASearch, ASource: UnicodeString; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
begin
  Result := AStartPos;
  if Result > 0 then
    Result := InternalPosW(Pointer(ASearch), Length(ASearch), Pointer(ASource), Length(ASource), Result - 1);
end;

function StrPosI(const ASearch, ASource: string; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
begin
  Result := {$IFDEF Unicode}StrPosIW{$ELSE}StrPosIA{$ENDIF}(ASearch, ASource, AStartPos);
end;

function StrPosIA(const ASearch, ASource: RawByteString; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
begin
  Result := AStartPos;
  if Result > 0 then
    Result := InternalPosIA(Pointer(ASearch), Length(ASearch), Pointer(ASource), Length(ASource), Result - 1);
end;

function StrPosIW(const ASearch, ASource: UnicodeString; const AStartPos: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 1{$ENDIF}): Cardinal;
begin
  Result := AStartPos;
  if Result > 0 then
    Result := InternalPosIW(Pointer(ASearch), Length(ASearch), Pointer(ASource), Length(ASource), Result - 1);
end;

function StrPosBackA(const ASearch, ASource: RawByteString; AStart: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  SearchPtr, SearchPtrTemp, SourcePtr, SourcePtrTemp: PAnsiChar;
  SearchLen, SearchLenTemp, SourceLen: Cardinal;
  c: AnsiChar;
begin
  SourceLen := Length(ASource);
  if (SourceLen = 0) or (AStart > SourceLen) then goto Fail;
  if AStart > 0 then SourceLen := AStart;

  SearchLen := Length(ASearch);
  if SourceLen < SearchLen then goto Fail;

  SourcePtr := Pointer(ASource);
  Inc(SourcePtr, SourceLen - 1);

  SearchPtr := Pointer(ASearch);
  Dec(SearchLen);
  Inc(SearchPtr, SearchLen);
  c := SearchPtr^;
  Dec(SearchPtr);

  Dec(SourceLen, SearchLen);
  while SourceLen > 0 do
    begin

      while SourceLen >= 4 do
        begin
          if SourcePtr^ = c then goto Zero;
          if SourcePtr[-1] = c then goto One;
          if SourcePtr[-2] = c then goto Two;
          if SourcePtr[-3] = c then goto Three;
          Dec(SourcePtr, 4);
          Dec(SourceLen, 4);
        end;

      case SourceLen of
        3:
          begin
            if SourcePtr^ = c then goto Zero;
            if SourcePtr[-1] = c then goto One;
            if SourcePtr[-2] = c then goto Two;
          end;
        2:
          begin
            if SourcePtr^ = c then goto Zero;
            if SourcePtr[-1] = c then goto One;
          end;
        1:
          begin
            if SourcePtr^ = c then goto Zero;
          end;
      end;

      Break;

      Three:
      Dec(SourcePtr, 4); Dec(SourceLen, 3); goto Match;

      Two:
      Dec(SourcePtr, 3); Dec(SourceLen, 2); goto Match;

      One:
      Dec(SourcePtr, 2); Dec(SourceLen, 1); goto Match;

      Zero:
      Dec(SourcePtr);

      Match:

      SourcePtrTemp := SourcePtr;
      SearchPtrTemp := SearchPtr;
      SearchLenTemp := SearchLen;

      while (SearchLenTemp >= 4) and
        (SourcePtrTemp^ = SearchPtrTemp^) and
        (SourcePtrTemp[-1] = SearchPtrTemp[-1]) and
        (SourcePtrTemp[-2] = SearchPtrTemp[-2]) and
        (SourcePtrTemp[-3] = SearchPtrTemp[-3]) do
        begin
          Dec(SourcePtrTemp, 4);
          Dec(SearchPtrTemp, 4);
          Dec(SearchLenTemp, 4);
        end;

      case SearchLenTemp of
        0:
          goto Success;
        1:
          if SourcePtrTemp^ = SearchPtrTemp^ then goto Success;
        2:
          if (SourcePtrTemp^ = SearchPtrTemp^) and
            (SourcePtrTemp[-1] = SearchPtrTemp[-1]) then goto Success;
        3:
          if (SourcePtrTemp^ = SearchPtrTemp^) and
            (SourcePtrTemp[-1] = SearchPtrTemp[-1]) and
            (SourcePtrTemp[-2] = SearchPtrTemp[-2]) then goto Success;
      end;

      Dec(SourceLen);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := SourcePtr + 2 - PAnsiChar(ASource) - SearchLen;
end;

function StrPosBackIA(const ASearch, ASource: RawByteString; AStart: Cardinal{$IFDEF SUPPORTS_DEFAULTPARAMS} = 0{$ENDIF}): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  SearchPtr, SearchPtrTemp, SourcePtr, SourcePtrTemp: PAnsiChar;
  SearchLen, SearchLenTemp, SourceLen: Cardinal;
  c: AnsiChar;
begin
  SourceLen := Length(ASource);
  if (SourceLen = 0) or (AStart > SourceLen) then goto Fail;
  if AStart > 0 then SourceLen := AStart;

  SearchLen := Length(ASearch);
  if SourceLen < SearchLen then goto Fail;

  SourcePtr := Pointer(ASource);
  Inc(SourcePtr, SourceLen - 1);

  SearchPtr := Pointer(ASearch);
  Dec(SearchLen);
  Inc(SearchPtr, SearchLen);
  c := SearchPtr^;
  Dec(SearchPtr);

  Dec(SourceLen, SearchLen);
  while SourceLen > 0 do
    begin

      while SourceLen >= 4 do
        begin
          if (SourcePtr^ = c) or (ANSI_REVERSE_CHAR_TABLE[SourcePtr^] = c) then goto Zero;
          if (SourcePtr[-1] = c) or (ANSI_REVERSE_CHAR_TABLE[SourcePtr[-1]] = c) then goto One;
          if (SourcePtr[-2] = c) or (ANSI_REVERSE_CHAR_TABLE[SourcePtr[-2]] = c) then goto Two;
          if (SourcePtr[-3] = c) or (ANSI_REVERSE_CHAR_TABLE[SourcePtr[-3]] = c) then goto Three;
          Dec(SourcePtr, 4);
          Dec(SourceLen, 4);
        end;

      case SourceLen of
        3:
          begin
            if (SourcePtr^ = c) or (ANSI_REVERSE_CHAR_TABLE[SourcePtr^] = c) then goto Zero;
            if (SourcePtr[-1] = c) or (ANSI_REVERSE_CHAR_TABLE[SourcePtr[-1]] = c) then goto One;
            if (SourcePtr[-2] = c) or (ANSI_REVERSE_CHAR_TABLE[SourcePtr[-2]] = c) then goto Two;
          end;
        2:
          begin
            if (SourcePtr^ = c) or (ANSI_REVERSE_CHAR_TABLE[SourcePtr^] = c) then goto Zero;
            if (SourcePtr[-1] = c) or (ANSI_REVERSE_CHAR_TABLE[SourcePtr[-1]] = c) then goto One;
          end;
        1:
          begin
            if (SourcePtr^ = c) or (ANSI_REVERSE_CHAR_TABLE[SourcePtr^] = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Dec(SourcePtr, 4);
      Dec(SourceLen, 3);
      goto Match;

      Two:
      Dec(SourcePtr, 3);
      Dec(SourceLen, 2);
      goto Match;

      One:
      Dec(SourcePtr, 2);
      Dec(SourceLen, 1);
      goto Match;

      Zero:
      Dec(SourcePtr);

      Match:

      SourcePtrTemp := SourcePtr;
      SearchPtrTemp := SearchPtr;
      SearchLenTemp := SearchLen;

      while (SearchLenTemp >= 4) and
        ((SourcePtrTemp^ = SearchPtrTemp^) or (ANSI_REVERSE_CHAR_TABLE[SourcePtrTemp^] = SearchPtrTemp^)) and
        ((SourcePtrTemp[-1] = SearchPtrTemp[-1]) or (ANSI_REVERSE_CHAR_TABLE[SourcePtrTemp[-1]] = SearchPtrTemp[-1])) and
        ((SourcePtrTemp[-2] = SearchPtrTemp[-2]) or (ANSI_REVERSE_CHAR_TABLE[SourcePtrTemp[-2]] = SearchPtrTemp[-2])) and
        ((SourcePtrTemp[-3] = SearchPtrTemp[-3]) or (ANSI_REVERSE_CHAR_TABLE[SourcePtrTemp[-3]] = SearchPtrTemp[-3])) do
        begin
          Dec(SourcePtrTemp, 4);
          Dec(SearchPtrTemp, 4);
          Dec(SearchLenTemp, 4);
        end;

      case SearchLenTemp of
        0:
          goto Success;
        1:
          if (SourcePtrTemp^ = SearchPtrTemp^) or (ANSI_REVERSE_CHAR_TABLE[SourcePtrTemp^] = SearchPtrTemp^) then goto Success;
        2:
          if ((SourcePtrTemp^ = SearchPtrTemp^) or (ANSI_REVERSE_CHAR_TABLE[SourcePtrTemp^] = SearchPtrTemp^)) and
            ((SourcePtrTemp[-1] = SearchPtrTemp[-1]) or (ANSI_REVERSE_CHAR_TABLE[SourcePtrTemp[-1]] = SearchPtrTemp[-1])) then goto Success;
        3:
          if ((SourcePtrTemp^ = SearchPtrTemp^) or (ANSI_REVERSE_CHAR_TABLE[SourcePtrTemp^] = SearchPtrTemp^)) and
            ((SourcePtrTemp[-1] = SearchPtrTemp[-1]) or (ANSI_REVERSE_CHAR_TABLE[SourcePtrTemp[-1]] = SearchPtrTemp[-1])) and
            ((SourcePtrTemp[-2] = SearchPtrTemp[-2]) or (ANSI_REVERSE_CHAR_TABLE[SourcePtrTemp[-2]] = SearchPtrTemp[-2])) then goto Success;
      end;

      Dec(SourceLen);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := SourcePtr + 2 - PAnsiChar(ASource) - SearchLen;
end;

function StrToIntDefW(const w: UnicodeString; const Default: Integer): Integer;
var
  e: Integer;
begin
  Result := ValIntW(w, e);
  if e <> 0 then Result := Default;
end;

{$IFDEF COMPILER_4_UP}
function StrToInt64DefW(const w: UnicodeString; const Default: Int64): Int64;
var
  e: Integer;
begin
  Result := ValInt64W(w, e);
  if e <> 0 then Result := Default;
end;
{$ENDIF COMPILER_4_UP}

procedure BufToUpperA(p1, p2: PAnsiChar; l: Cardinal);
begin
  Assert((Assigned(p1) and Assigned(p2)) or (l = 0));

  while l >= 4 do
    begin
      p2[0] := ANSI_UPPER_CHAR_TABLE[p1[0]];
      p2[1] := ANSI_UPPER_CHAR_TABLE[p1[1]];
      p2[2] := ANSI_UPPER_CHAR_TABLE[p1[2]];
      p2[3] := ANSI_UPPER_CHAR_TABLE[p1[3]];
      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Exit;
    p2[0] := ANSI_UPPER_CHAR_TABLE[p1^];
    Inc(p1); Inc(p2); Dec(l);
  until False;
end;

procedure BufToUpperW(p1, p2: PWideChar; l: Cardinal);
begin
  Assert((Assigned(p1) and Assigned(p2)) or (l = 0));

  while l >= 4 do
    begin
      p2[0] := CharToUpperW(p1[0]);
      p2[1] := CharToUpperW(p1[1]);
      p2[2] := CharToUpperW(p1[2]);
      p2[3] := CharToUpperW(p1[3]);
      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Exit;
    p2[0] := CharToUpperW(p1[0]);
    Inc(p1); Inc(p2); Dec(l);
  until False;
end;

procedure BufToLowerA(p1, p2: PAnsiChar; l: Cardinal);
begin
  Assert((Assigned(p1) and Assigned(p2)) or (l = 0));

  while l >= 4 do
    begin
      p2[0] := ANSI_LOWER_CHAR_TABLE[p1[0]];
      p2[1] := ANSI_LOWER_CHAR_TABLE[p1[1]];
      p2[2] := ANSI_LOWER_CHAR_TABLE[p1[2]];
      p2[3] := ANSI_LOWER_CHAR_TABLE[p1[3]];
      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Exit;
    p2[0] := ANSI_LOWER_CHAR_TABLE[p1[0]];
    Inc(p1); Inc(p2); Dec(l);
  until False;
end;

procedure BufToLowerW(p1, p2: PWideChar; l: Cardinal);
begin
  Assert((Assigned(p1) and Assigned(p2)) or (l = 0));

  while l >= 4 do
    begin
      p2[0] := CharToLowerW(p1^);
      p2[1] := CharToLowerW(p1[1]);
      p2[2] := CharToLowerW(p1[2]);
      p2[3] := CharToLowerW(p1[3]);
      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  repeat
    if l = 0 then Exit;
    p2[0] := CharToLowerW(p1[0]);
    Inc(p1); Inc(p2); Dec(l);
  until False;
end;

function StrToUpper(const s: string): string;
begin
  Result := {$IFDEF Unicode}StrToUpperW{$ELSE}StrToUpperA{$ENDIF}(s);
end;

function StrToUpperA(const s: RawByteString): RawByteString;
var
  l: Cardinal;
begin
  l := Length(s);
  SetString(Result, nil, l);
  BufToUpperA(Pointer(s), Pointer(Result), l);
end;

function StrToUpperW(const s: UnicodeString): UnicodeString;
var
  l: Cardinal;
begin
  l := Length(s);
  SetString(Result, nil, l);
  BufToUpperW(Pointer(s), Pointer(Result), l);
end;

procedure StrToUpperInPlace(var s: string);
begin
  {$IFDEF Unicode}StrToUpperInPlaceW{$ELSE}StrToUpperInPlaceA{$ENDIF}(s);
end;

procedure StrToUpperInPlaceA(var s: AnsiString);
begin
  UniqueString(s);
  BufToUpperA(Pointer(s), Pointer(s), Length(s));
end;

procedure StrToUpperInPlaceW(var s: WideString);
begin
  BufToUpperW(Pointer(s), Pointer(s), Length(s));
end;

{$IFDEF SUPPORTS_UNICODE_STRING}
procedure StrToUpperInPlaceW(var s: UnicodeString);
begin
  UniqueString(s);
  BufToUpperW(Pointer(s), Pointer(s), Length(s));
end;
{$ENDIF SUPPORTS_UNICODE_STRING}

function StrToLower(const s: string): string;
begin
  Result := {$IFDEF Unicode}StrToLowerW{$ELSE}StrToLowerA{$ENDIF}(s);
end;

function StrToLowerA(const s: RawByteString): RawByteString;
var
  l: Cardinal;
begin
  l := Length(s);
  SetString(Result, nil, l);
  BufToLowerA(Pointer(s), Pointer(Result), l);
end;

function StrToLowerW(const s: UnicodeString): UnicodeString;
var
  l: Cardinal;
begin
  l := Length(s);
  SetString(Result, nil, l);
  BufToLowerW(Pointer(s), Pointer(Result), l);
end;

procedure StrToLowerInPlace(var s: string);
begin
  {$IFDEF Unicode}StrToLowerInPlaceW{$ELSE}StrToLowerInPlaceA{$ENDIF}(s);
end;

procedure StrToLowerInPlaceA(var s: AnsiString);
begin
  UniqueString(s);
  BufToLowerA(Pointer(s), Pointer(s), Length(s));
end;

procedure StrToLowerInPlaceW(var s: WideString);
begin
  BufToLowerW(Pointer(s), Pointer(s), Length(s));
end;

{$IFDEF SUPPORTS_UNICODE_STRING}
procedure StrToLowerInPlaceW(var s: UnicodeString);
begin
  UniqueString(s);
  BufToLowerW(Pointer(s), Pointer(s), Length(s));
end;
{$ENDIF SUPPORTS_UNICODE_STRING}

procedure StrTimUriFragmentA(var Value: RawByteString);
var
  i: Cardinal;
begin
  i := StrPosCharA(Value, AC_NUMBER_SIGN, 1);
  if i > 0 then
    SetLength(Value, i - 1);
end;

procedure StrTrimUriFragmentW(var Value: UnicodeString);
var
  i: Cardinal;
begin
  i := StrPosCharW(Value, WC_NUMBER_SIGN, 1);
  if i > 0 then
    SetLength(Value, i - 1);
end;

function StrExtractUriFragmentW(var Value: UnicodeString): UnicodeString;
var
  i: Cardinal;
begin
  i := StrPosCharW(Value, WC_NUMBER_SIGN, 1);
  if i > 0 then
    Result := Copy(Value, i, MaxInt)
  else
    Result := '';
end;

function BufCountUtf8Chars(p: PUtf8Char; l: Cardinal): Cardinal;
label
  Success;
var
  b, b1, b2, b3: Byte;
begin
  Result := 0;
  if Assigned(p) then
    while l > 0 do
      begin
        b := Byte(p^);
        Inc(p); Dec(l);

        if b < $80 then
          goto Success
        else
          if b < $C0 then
            goto Success
          else
            if l > 0 then
              begin
                b1 := Byte(p^);
                if b1 and $C0 <> $80 then
                  goto Success;
                Inc(p); Dec(l);

                if b and $E0 <> $E0 then
                  goto Success
                else
                  if l > 0 then
                    begin
                      b2 := Byte(p^);
                      if b2 and $C0 <> $80 then
                        goto Success;
                      Inc(p); Dec(l);

                      if b and $F0 <> $F0 then
                        goto Success
                      else
                        if l > 0 then
                          begin
                            b3 := Byte(p^);
                            if b3 and $C0 <> $80 then
                              goto Success;
                            Inc(p); Dec(l);

                            if b and $F8 <> $F8 then
                              goto Success
                            else
                              if l > 0 then
                                begin
                                  b3 := Byte(p^);
                                  if b3 and $C0 <> $80 then
                                    goto Success;
                                  Inc(p); Dec(l);

                                  if b and $FC <> $FC then
                                    goto Success
                                  else
                                    if l > 0 then
                                      begin
                                        b3 := Byte(p^);
                                        if b3 and $C0 <> $80 then
                                          goto Success;
                                        Inc(p); Dec(l);

                                        goto Success;
                                      end;
                                end;
                          end;
                    end;
              end;

        Break;

        Success:
        Inc(Result);
      end;
end;

function StrCountUtf8Chars(const AValue: Utf8String): Cardinal;
begin
  Result := BufCountUtf8Chars(Pointer(AValue), Length(AValue));
end;

function WriteUcs4_utf16(c: UCS4Char; const p: PWideChar; const l: NativeInt): NativeInt;
var
  c1, c2: UCS4Char;
begin
  Assert(Assigned(p) or (l = 0));

  if (c < $D800) or (c >= $E000) then
    if c < $10000 then
      if l >= 1 then
        begin
          p[0] := WideChar(c);
          Result := 1; Exit;
        end
      else
        begin Result := -1; Exit; end
    else
      if c < $110000 then
        if l >= 2 then
          begin
            c1 := $D800 + ((c - $10000) shr 10);
            c2 := $DC00 + ((c - $10000) and $3FF);
            p[0] := WideChar(c1);
            p[1] := WideChar(c2);
            Result := 2; Exit;
          end
        else
          begin Result := -2; Exit; end;
  Result := 0;
end;

function BufDecodeUtf8(const p: PUtf8Char; const l: NativeUInt): UnicodeString;
var
  c: UCS4Char;
  lChar, lIn, lResult: NativeInt;
  pIn: PUtf8Char;
  pResult: PWideChar;
begin
  if Assigned(p) and (l > 0) then
    begin

      lResult := 0;
      pIn := p; lIn := l;
      repeat
        //lChar := ReadUCS4_utf8(pIn, lIn, c);
        if lChar <= 0 then
          begin

            c := Ord(WC_REPLACEMENT_CHARACTER);
            lChar := -lChar;
            if lChar > lIn then
              lChar := lIn;
          end;
        Inc(pIn, lChar); Dec(lIn, lChar);

        lChar := WriteUcs4_utf16(c, nil, 0);
        if lChar = 0 then
          begin

            lChar := -1;
          end;
        Dec(lResult, lChar);
      until lIn = 0;

      SetString(Result, nil, lResult);
      pResult := PWideChar(Result);

      pIn := p; lIn := l;
      repeat
       // lChar := ReadUCS4_utf8(pIn, lIn, c);
        if lChar <= 0 then
          begin

            c := Ord(WC_REPLACEMENT_CHARACTER);
            lChar := -lChar;
            if lChar > lIn then
              lChar := lIn;
          end;
        Inc(pIn, lChar); Dec(lIn, lChar);

        lChar := WriteUcs4_utf16(c, pResult, $F);
        if lChar = 0 then
          begin

            pResult^ := WC_REPLACEMENT_CHARACTER;
            lChar := 1;
          end;
        Inc(pResult, lChar);
      until lIn = 0;
    end
  else
    Result := '';
end;

function StrDecodeUtf8(const AValue: Utf8String): UnicodeString;
begin
  Result := BufDecodeUtf8(Pointer(AValue), Length(AValue));
end;

function ReadUCS4_utf16(const p: PWideChar; const l: NativeInt; out c: UCS4Char): NativeInt;
const
  Strict = True;
label
  0;
var
  c1, c2: UCS4Char;
begin
  if l > 0 then
    begin
      c1 := Ord(p[0]);
      case c1 of
        $D800..$DBFF:
          if l > 1 then
            begin
              c2 := Ord(p[1]);
              case c2 of
                $DC00..$DFFF:
                  begin
                    c := $10000 + (c1 - $D800) shl 10 + (c2 - $DC00);
                    Result := 2; Exit;
                  end;
              else
                if Strict then goto 0;
              end;
            end
          else
            if Strict then
              begin Result := -2; Exit; end;
        $DC00..$DFFF:
          if Strict then
            begin 0: Result := 0; Exit; end;
      end;
      c := c1;
      Result := 1; Exit;
    end;

  Result := -1;
end;

function WriteUCS4_utf8(c: UCS4Char; const p: PUtf8Char; const l: NativeInt): NativeInt;
label
  1, 2, 3, 4, 5, 6;
type
  TByte6 = packed record b1, b2, b3, b4, b5, b6: Byte; end;
  PByte6 = ^TByte6;
const
  FIRST_BYTE_MARK: array[1..6] of Byte = ($00, $C0, $E0, $F0, $F8, $FC);
begin
  Assert(Assigned(p) or (l = 0));

  if c < $80 then
    Result := 1
  else if c < $800 then
    Result := 2
  else if c < $10000 then
    Result := 3
  else if c < $200000 then
    Result := 4
  else if c < $4000000 then
    Result := 5
  else if c <= $7FFFFFFF then
    Result := 6
  else begin Result := 0; Exit; end;

  if Result > l then
    begin Result := -Result; Exit; end;

  case Result of 1: goto 1; 2: goto 2; 3: goto 3; 4: goto 4; 5: goto 5; end;
  6: PByte6(p)^.b6 := (c or $80) and $BF; c := c shr 6; goto 5;
  5: PByte6(p)^.b5 := (c or $80) and $BF; c := c shr 6; goto 4;
  4: PByte6(p)^.b4 := (c or $80) and $BF; c := c shr 6; goto 3;
  3: PByte6(p)^.b3 := (c or $80) and $BF; c := c shr 6; goto 2;
  2: PByte6(p)^.b2 := (c or $80) and $BF; c := c shr 6; goto 1;
  1: PByte6(p)^.b1 := c or FIRST_BYTE_MARK[Result];
end;

function BufEncodeUtf8(const p: PWideChar; const l: NativeUInt): Utf8String;
var
  c: UCS4Char;
  lChar: NativeInt;
  lIn, lResult: NativeInt;
  pIn: PWideChar;
  pResult: PUtf8Char;
begin
  if Assigned(p) and (l > 0) then
    begin

      lResult := 0;
      pIn := p; lIn := l;
      repeat
        lChar := ReadUCS4_utf16(pIn, lIn, c);
        if lChar <= 0 then
          begin

            c := Ord(WC_REPLACEMENT_CHARACTER);
            lChar := -lChar;
            if lChar > lIn then
              lChar := lIn;
          end;
        Inc(pIn, lChar); Dec(lIn, lChar);

        lChar := WriteUCS4_utf8(c, nil, 0);
        if lChar = 0 then
          begin

            lChar := -1;
          end;
        Dec(lResult, lChar);
      until lIn = 0;

      SetString(Result, nil, lResult);
      pResult := PAnsiChar(Result);

      pIn := p; lIn := l;
      repeat
        lChar := ReadUCS4_utf16(pIn, lIn, c);
        if lChar <= 0 then
          begin

            c := Ord(WC_REPLACEMENT_CHARACTER);
            lChar := -lChar;
            if lChar > lIn then
              lChar := lIn;
          end;
        Inc(pIn, lChar); Dec(lIn, lChar);
        lChar := WriteUCS4_utf8(c, pResult, $F);
        Inc(pResult, lChar);
      until lIn = 0;
    end
  else
    Result := '';
end;

function StrEncodeUtf8(const AValue: UnicodeString): Utf8String;
begin
  Result := BufEncodeUtf8(Pointer(AValue), Length(AValue))
end;

{$IFDEF MSWINDOWS}

function SysErrorMessage(const MessageID: Cardinal): string;
begin
  Result := {$IFDEF UNICODE}SysErrorMessageW{$ELSE}SysErrorMessageA{$ENDIF}(MessageID);
end;

function SysErrorMessageA(const MessageID: Cardinal): AnsiString;
const
  BUFFER_SIZE = $0100;
var
  l: Cardinal;
begin
  SetString(Result, nil, BUFFER_SIZE);
  l := FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM, nil, MessageID, 0, Pointer(Result), BUFFER_SIZE, nil);
  while (l > 0) and (Result[l] in [AC_NULL..AC_SPACE, AC_FULL_STOP]) do
    Dec(l);
  SetLength(Result, l);
end;

function SysErrorMessageW(const MessageID: Cardinal): UnicodeString;
const
  BUFFER_SIZE = $0100;
var
  l: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      SetString(Result, nil, BUFFER_SIZE);
      l := FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM, nil, MessageID, 0, Pointer(Result), BUFFER_SIZE, nil);
      while (l > 0) and (Result[l] <= WC_SPACE) and (Result[l] <> WC_FULL_STOP) do
        Dec(l);
      SetLength(Result, l);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := SysErrorMessageA(MessageID);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function TextExtentW(const DC: HDC; const Text: UnicodeString): TSize;
begin
  GetTextExtentPoint32W(DC, Pointer(Text), Length(Text), Result);
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function TextHeightW(const DC: HDC; const Text: UnicodeString): Integer;
var
  Size: TSize;
begin
  GetTextExtentPoint32W(DC, Pointer(Text), Length(Text), {$IFDEF FPC}@{$ENDIF}Size);
  Result := Size.cy;
end;

{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}

function TextWidthW(const DC: HDC; const Text: UnicodeString): Integer;
var
  Size: TSize;
begin
  GetTextExtentPoint32W(DC, Pointer(Text), Length(Text), Size);
  Result := Size.cx;
end;

{$ENDIF MSWINDOWS}

function StrTrim(const Source: string): string;
begin
  Result := {$IFDEF UNICODE}StrTrimW{$ELSE}StrTrimA{$ENDIF}(Source);
end;

function StrTrimA(const Source: RawByteString): RawByteString;
begin
  Result := StrTrimCharsA(Source, AS_WHITE_SPACE);
end;

function StrTrimW(const w: UnicodeString): UnicodeString;
begin
  Result := StrTrimCharsW(w, CharIsWhiteSpaceW);
end;

function StrTrimCharA(const Source: RawByteString; const CharToTrim: AnsiChar): RawByteString;
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree,
    ReturnEmptyString;
var
  l, Len: Cardinal;
  p, e: PAnsiChar;
begin
  Len := Length(Source);
  if Len = 0 then goto ReturnEmptyString;

  l := Len;

  p := Pointer(Source);
  e := p + l - 1;

  while l >= 4 do
    begin
      if p^ <> CharToTrim then goto BeginZero;
      if p[1] <> CharToTrim then goto BeginOne;
      if p[2] <> CharToTrim then goto BeginTwo;
      if p[3] <> CharToTrim then goto BeginThree;
      Inc(p, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p^ <> CharToTrim then goto BeginZero;
        if p[1] <> CharToTrim then goto BeginOne;
        if p[2] <> CharToTrim then goto BeginTwo;
        BeginThree:
        Inc(p, 3);
      end;
    2:
      begin
        if p^ <> CharToTrim then goto BeginZero;
        if p[1] <> CharToTrim then goto BeginOne;
        BeginTwo:
        Inc(p, 2);
      end;
    1:
      begin
        BeginOne:
        if p^ <> CharToTrim then goto BeginZero;
        Inc(p);
      end;
  end;

  BeginZero:

  l := e - p + 1;
  if l = 0 then goto ReturnEmptyString;

  while l >= 4 do
    begin
      if e^ <> CharToTrim then goto EndZero;
      if e[-1] <> CharToTrim then goto EndOne;
      if e[-2] <> CharToTrim then goto EndTwo;
      if e[-3] <> CharToTrim then goto EndThree;
      Dec(e, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if e^ <> CharToTrim then goto EndZero;
        if e[-1] <> CharToTrim then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if e^ <> CharToTrim then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(l, 3);
  goto EndZero;

  EndTwo:
  Dec(l, 2);
  goto EndZero;

  EndOne:
  Dec(l);

  EndZero:

  if l = Len then
    Result := Source
  else
    SetString(Result, p, l);
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function StrTrimCharsA(const Source: RawByteString; const CharsToTrim: TAnsiCharSet): RawByteString;
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree,
    ReturnEmptyString;
var
  l, Len: Cardinal;
  p, e: PAnsiChar;
begin
  Len := Length(Source);
  if Len = 0 then goto ReturnEmptyString;

  p := Pointer(Source);
  l := Len;
  e := p + l - 1;

  while l >= 4 do
    begin
      if not (p^ in CharsToTrim) then goto BeginZero;
      if not (p[1] in CharsToTrim) then goto BeginOne;
      if not (p[2] in CharsToTrim) then goto BeginTwo;
      if not (p[3] in CharsToTrim) then goto BeginThree;
      Inc(p, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (p^ in CharsToTrim) then goto BeginZero;
        if not (p[1] in CharsToTrim) then goto BeginOne;
        if not (p[2] in CharsToTrim) then goto BeginTwo;
        BeginThree:
        Inc(p, 3);
      end;
    2:
      begin
        if not (p^ in CharsToTrim) then goto BeginZero;
        if not (p[1] in CharsToTrim) then goto BeginOne;
        BeginTwo:
        Inc(p, 2);
      end;
    1:
      begin
        if not (p^ in CharsToTrim) then goto BeginZero;
        BeginOne:
        Inc(p);
      end;
  end;

  BeginZero:

  l := e - p + 1;
  if l = 0 then goto ReturnEmptyString;

  while l >= 4 do
    begin
      if not (e^ in CharsToTrim) then goto EndZero;
      if not (e[-1] in CharsToTrim) then goto EndOne;
      if not (e[-2] in CharsToTrim) then goto EndTwo;
      if not (e[-3] in CharsToTrim) then goto EndThree;
      Dec(e, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (e^ in CharsToTrim) then goto EndZero;
        if not (e[-1] in CharsToTrim) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not (e^ in CharsToTrim) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(l, 3);
  goto EndZero;

  EndTwo:
  Dec(l, 2);
  goto EndZero;

  EndOne:
  Dec(l);

  EndZero:

  if l = Len then
    Result := Source
  else
    SetString(Result, p, l);
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function StrTrimCharsW(const s: UnicodeString; const IsCharToTrim: TValidateCharFuncW): UnicodeString;
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree,
    ReturnEmptyString;
var
  l, Len: Cardinal;
  p, e: PWideChar;
begin
  Len := Length(s);
  if Len = 0 then goto ReturnEmptyString;

  l := Len;
  p := Pointer(s);
  e := p + l - 1;

  while l >= 4 do
    begin
      if not IsCharToTrim(p^) then goto BeginZero;
      if not IsCharToTrim(p[1]) then goto BeginOne;
      if not IsCharToTrim(p[2]) then goto BeginTwo;
      if not IsCharToTrim(p[3]) then goto BeginThree;
      Inc(p, 4); Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not IsCharToTrim(p^) then goto BeginZero;
        if not IsCharToTrim(p[1]) then goto BeginOne;
        if not IsCharToTrim(p[2]) then goto BeginTwo;
        BeginThree:
        Inc(p, 3);
      end;
    2:
      begin
        if not IsCharToTrim(p^) then goto BeginZero;
        if not IsCharToTrim(p[1]) then goto BeginOne;
        BeginTwo:
        Inc(p, 2);
      end;
    1:
      begin
        if not IsCharToTrim(p^) then goto BeginZero;
        BeginOne:
        Inc(p);
      end;
  end;

  BeginZero:

  l := e - p + 1;
  if l = 0 then goto ReturnEmptyString;

  while l >= 4 do
    begin
      if not IsCharToTrim(e^) then goto EndZero;
      if not IsCharToTrim(e[-1]) then goto EndOne;
      if not IsCharToTrim(e[-2]) then goto EndTwo;
      if not IsCharToTrim(e[-3]) then goto EndThree;
      Dec(e, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not IsCharToTrim(e^) then goto EndZero;
        if not IsCharToTrim(e[-1]) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not IsCharToTrim(e^) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(l, 3);
  goto EndZero;

  EndTwo:
  Dec(l, 2);
  goto EndZero;

  EndOne:
  Dec(l);

  EndZero:

  if l = Len then
    Result := s
  else
    SetString(Result, p, l);
  Exit;

  ReturnEmptyString:
  Result := '';
end;

procedure TrimLeftByRefA(var s: RawByteString; const Chars: TAnsiCharSet);
label
  BeginZero, BeginOne, BeginTwo, BeginThree, ReturnEmptyString;
var
  i, l: Cardinal;
  pRead, pWrite: PAnsiChar;
begin
  l := Length(s);
  if l = 0 then Exit;

  pRead := Pointer(s);

  if pRead^ in Chars then Exit;

  Inc(pRead);
  i := l - 1;

  while i >= 4 do
    begin
      if not (pRead^ in Chars) then goto BeginZero;
      if not (pRead[1] in Chars) then goto BeginOne;
      if not (pRead[2] in Chars) then goto BeginTwo;
      if not (pRead[3] in Chars) then goto BeginThree;
      Inc(pRead, 4); Dec(i, 4);
    end;

  case l of
    3:
      begin
        if not (pRead^ in Chars) then goto BeginZero;
        if not (pRead[1] in Chars) then goto BeginOne;
        if not (pRead[2] in Chars) then goto BeginTwo;
        BeginThree:
        Dec(i, 3);
      end;
    2:
      begin
        if not (pRead^ in Chars) then goto BeginZero;
        if not (pRead[1] in Chars) then goto BeginOne;
        BeginTwo:
        Dec(i, 2);
      end;
    1:
      begin
        if not (pRead^ in Chars) then goto BeginZero;
        BeginOne:
        Dec(i);
      end;
  end;

  BeginZero:

  if i = 0 then goto ReturnEmptyString;

  UniqueString(AnsiString(s));
  pWrite := Pointer(s);
  pRead := pWrite + l - i;
  l := i;

  while i >= 4 do
    begin
      PCardinal(pWrite)^ := PCardinal(pRead)^;
      Inc(pWrite, 4); Inc(pRead, 4); Dec(i, 4);
    end;

  case i of
    3:
      begin
        PWord(pWrite)^ := PWord(pRead)^;
        pWrite[2] := pRead[2];
      end;
    2:
      PWord(pWrite)^ := PWord(pRead)^;
    1:
      pWrite^ := pRead^;
  end;

  SetLength(s, l);
  Exit;

  ReturnEmptyString:
  s := '';
end;

function TrimRightA(const Source: RawByteString; const s: TAnsiCharSet): RawByteString;
label
  EndZero, EndOne, EndTwo, EndThree, ReturnEmptyString;
var
  l, lNew: Cardinal;
  p: PAnsiChar;
begin
  l := Length(Source);
  if l = 0 then Exit;

  p := Pointer(Source);

  lNew := l;
  Inc(p, lNew - 1);

  while lNew >= 4 do
    begin
      if not (p^ in s) then goto EndZero;
      if not (p[-1] in s) then goto EndOne;
      if not (p[-2] in s) then goto EndTwo;
      if not (p[-3] in s) then goto EndThree;
      Dec(p, 4);
      Dec(lNew, 4);
    end;

  case lNew of
    3:
      begin
        if not (p^ in s) then goto EndZero;
        if not (p[-1] in s) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not (p^ in s) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(lNew, 3);
  goto EndZero;

  EndTwo:
  Dec(lNew, 2);
  goto EndZero;

  EndOne:
  Dec(lNew);

  EndZero:

  Result := Source;
  if lNew <> l then SetLength(Result, lNew);
  Exit;

  ReturnEmptyString:
  Result := '';
end;

procedure StrTrimCompressA(var s: RawByteString; const TrimCompressChars: TAnsiCharSet{$IFDEF SUPPORTS_DEFAULTPARAMS} = AS_WHITE_SPACE{$ENDIF}; const ReplaceChar: AnsiChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = AC_SPACE{$ENDIF});
label
  ReturnEmptyString, SetLengthWrite;
var
  i, j, l: Cardinal;
  pRead, pWrite: PAnsiChar;
begin
  l := Length(s);
  if l = 0 then Exit;
  i := l;

  pRead := Pointer(s);
  if pRead^ in TrimCompressChars then
    begin

      repeat
        Dec(i);
        if i = 0 then goto ReturnEmptyString;
        Inc(pRead);
      until not (pRead^ in TrimCompressChars);

      UniqueString(AnsiString(s));
      pWrite := Pointer(s);
      pRead := pWrite + l - i;
    end
  else
    begin

      repeat

        repeat
          Dec(i);
          if i = 0 then Exit;
          Inc(pRead);
        until pRead^ in TrimCompressChars;

        pWrite := pRead;

        repeat
          Dec(i);
          if i = 0 then goto SetLengthWrite;
          Inc(pRead);
        until not (pRead^ in TrimCompressChars);

        j := pRead - pWrite;
      until (j > 1) or (pRead[-1] <> ReplaceChar); ;

      UniqueString(AnsiString(s));
      pRead := PAnsiChar(s) + l - i;
      pWrite := pRead - j;
      pWrite^ := ReplaceChar;

      if j = 1 then
        repeat

          repeat
            Dec(i);
            if i = 0 then Exit;
            Inc(pRead);
          until pRead^ in TrimCompressChars;

          pWrite := pRead;

          repeat
            Dec(i);
            if i = 0 then goto SetLengthWrite;
            Inc(pRead);
          until not (pRead^ in TrimCompressChars);

          pWrite^ := ReplaceChar;

          j := pRead - pWrite;
        until (j > 1) or (pRead[-1] <> ReplaceChar); ;

      Inc(pWrite);
    end;

  repeat

    repeat
      pWrite^ := pRead^;
      Inc(pWrite);
      Dec(i);
      if i = 0 then goto SetLengthWrite;
      Inc(pRead);
    until pRead^ in TrimCompressChars;

    repeat
      Dec(i);
      if i = 0 then goto SetLengthWrite;
      Inc(pRead);
    until not (pRead^ in TrimCompressChars);

    pWrite^ := ReplaceChar;
    Inc(pWrite);

  until False;

  SetLengthWrite:
  SetLength(s, pWrite - PAnsiChar(s));
  Exit;

  ReturnEmptyString:
  s := '';
end;

procedure StrTrimCompressW(
  var w: UnicodeString;
  Validate: TValidateCharFuncW{$IFDEF SUPPORTS_DEFAULTPARAMS} = nil{$ENDIF};
  const ReplaceChar: WideChar{$IFDEF SUPPORTS_DEFAULTPARAMS} = WC_SPACE{$ENDIF});
label
  ReturnEmptyString, SetLengthWrite;
var
  i, j, l: Cardinal;
  pRead, pWrite: PWideChar;
begin
  l := Length(w);
  if l = 0 then Exit;
  i := l;

  if not Assigned(Validate) then
    Validate := CharIsWhiteSpaceW;

  pRead := Pointer(w);
  if Validate(pRead^) then
    begin

      repeat
        Dec(i);
        if i = 0 then goto ReturnEmptyString;
        Inc(pRead);
      until not Validate(pRead^);

      {$IFDEF Unicode}UniqueString(w); {$ENDIF}
      pWrite := Pointer(w);
      pRead := pWrite + l - i;
    end
  else
    begin

      repeat

        repeat
          Dec(i);
          if i = 0 then Exit;
          Inc(pRead);
        until Validate(pRead^);

        pWrite := pRead;

        repeat
          Dec(i);
          if i = 0 then goto SetLengthWrite;
          Inc(pRead);
        until not Validate(pRead^);

        j := pRead - pWrite;
      until (j > 1) or (pRead[-1] <> ReplaceChar); ;

      {$IFDEF Unicode}UniqueString(w); {$ENDIF}
      pRead := Pointer(w);
      Inc(pRead, l - i);
      pWrite := pRead - j;
      pWrite^ := ReplaceChar;

      if j = 1 then
        repeat

          repeat
            Dec(i);
            if i = 0 then Exit;
            Inc(pRead);
          until Validate(pRead^);

          pWrite := pRead;

          repeat
            Dec(i);
            if i = 0 then goto SetLengthWrite;
            Inc(pRead);
          until not Validate(pRead^);

          pWrite^ := ReplaceChar;

          j := pRead - pWrite;
        until (j > 1) or (pRead[-1] <> ReplaceChar); ;

      Inc(pWrite);
    end;

  repeat

    repeat
      pWrite^ := pRead^;
      Inc(pWrite);
      Dec(i);
      if i = 0 then goto SetLengthWrite;
      Inc(pRead);
    until Validate(pRead^);

    repeat
      Dec(i);
      if i = 0 then goto SetLengthWrite;
      Inc(pRead);
    until not Validate(pRead^);

    pWrite^ := ReplaceChar;
    Inc(pWrite);

  until False;

  SetLengthWrite:
  SetLength(w, pWrite - PWideChar(w));
  Exit;

  ReturnEmptyString:
  w := '';
end;

procedure TrimRightByRefA(var Source: RawByteString; const s: TAnsiCharSet);
label
  EndZero, EndOne, EndTwo, EndThree;
var
  l, lNew: Cardinal;
  p: PAnsiChar;
begin
  l := Length(Source);
  if l = 0 then Exit;
  lNew := l;

  p := Pointer(Source);
  Inc(p, lNew - 1);

  while lNew >= 4 do
    begin
      if not (p^ in s) then goto EndZero;
      if not (p[-1] in s) then goto EndOne;
      if not (p[-2] in s) then goto EndTwo;
      if not (p[-3] in s) then goto EndThree;
      Dec(p, 4);
      Dec(lNew, 4);
    end;

  case lNew of
    3:
      begin
        if not (p^ in s) then goto EndZero;
        if not (p[-1] in s) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not (p^ in s) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(lNew, 3);
  goto EndZero;

  EndTwo:
  Dec(lNew, 2);
  goto EndZero;

  EndOne:
  Dec(lNew);

  EndZero:
  if lNew <> l then SetLength(Source, lNew);
end;

procedure TrimRightByRefW(var w: UnicodeString; Validate: TValidateCharFuncW{$IFDEF SUPPORTS_DEFAULTPARAMS} = nil{$ENDIF});
label
  EndZero, EndOne, EndTwo, EndThree;
var
  l, lNew: Cardinal;
  p: PWideChar;
begin
  l := Length(w);
  if l = 0 then Exit;
  lNew := l;

  p := Pointer(w);
  Inc(p, lNew - 1);

  if not Assigned(Validate) then
    Validate := CharIsWhiteSpaceW;

  while lNew >= 4 do
    begin
      if not Validate(p^) then goto EndZero;
      if not Validate(p[-1]) then goto EndOne;
      if not Validate(p[-2]) then goto EndTwo;
      if not Validate(p[-3]) then goto EndThree;
      Dec(p, 4);
      Dec(lNew, 4);
    end;

  case lNew of
    3:
      begin
        if not Validate(p^) then goto EndZero;
        if not Validate(p[-1]) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not Validate(p^) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(lNew, 3);
  goto EndZero;

  EndTwo:
  Dec(lNew, 2);
  goto EndZero;

  EndOne:
  Dec(lNew);

  EndZero:
  if lNew <> l then
    SetLength(w, lNew);
end;

function TryStrToIntW(const w: UnicodeString; out Value: Integer): Boolean;
var
  e: Integer;
begin
  Value := ValIntW(w, e);
  Result := e = 0;
end;

{$IFDEF SUPPORTS_INT64}
function TryStrToInt64W(const w: UnicodeString; out Value: Int64): Boolean;
var
  e: Integer;
begin
  Value := ValInt64W(w, e);
  Result := e = 0;
end;
{$ENDIF SUPPORTS_INT64}

function UpdateCrc32OfBuf(const Crc32: TCrc32; const Buffer; const BufferSize: Cardinal): TCrc32;
begin
  Result := UpdateCrc32OfBuf(Crc32, Buffer, UInt64(BufferSize));
end;

function UpdateCrc32OfBuf(const Crc32: TCrc32; const Buffer; BufferSize: UInt64): TCrc32;
var
  b: NativeUInt;
  p: PAnsiChar;
begin
  {Result := Crc32;
  p := @Buffer;

  while BufferSize >= 4 do
    begin
      b := Result xor Ord(p[0]);
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[Byte(b)];

      b := Result xor Ord(p[1]);
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[Byte(b)];

      b := Result xor Ord(p[2]);
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[Byte(b)];

      b := Result xor Ord(p[3]);
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[Byte(b)];

      Inc(p, 4); Dec(BufferSize, 4);
    end;

  while BufferSize > 0 do
    begin
      b := Result xor Ord(p[0]); ;
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[Byte(b)];

      Inc(p); Dec(BufferSize);
    end;    }
end;

function UpdateCrc32OfStrA(const Crc32: TCrc32; const s: RawByteString): TCrc32;
begin
  Result := UpdateCrc32OfBuf(Crc32, Pointer(s)^, UInt64(Length(s) * SizeOf(s[1])));
end;

function UpdateCrc32OfStrW(const Crc32: TCrc32; const s: UnicodeString): TCrc32;
begin
  Result := UpdateCrc32OfBuf(Crc32, Pointer(s)^, UInt64(Length(s) * SizeOf(s[1])));
end;

{$IFDEF MSWINDOWS}

function WBufToAStr(const Buffer: PWideChar; const WideCharCount: Cardinal; const CodePage: Word{$IFDEF SUPPORTS_DEFAULTPARAMS} = CP_ACP{$ENDIF}): RawByteString;
label
  Fail;
var
  OutputLength: Cardinal;
begin
  if (Buffer = nil) or (WideCharCount = 0) then goto Fail;
  OutputLength := WideCharToMultiByte(CodePage, 0, Buffer, WideCharCount, nil, 0, nil, nil);
  SetString(Result, nil, OutputLength);
  WideCharToMultiByte(CodePage, 0, Buffer, WideCharCount, PAnsiChar(Result), OutputLength, nil, nil);
  Exit;

  Fail:
  Result := '';
end;

function WStrToAStr(const s: UnicodeString; const CodePage: Word{$IFDEF SUPPORTS_DEFAULTPARAMS} = CP_ACP{$ENDIF}): RawByteString;
var
  InputLength, OutputLength: Integer;
begin
  InputLength := Length(s);
  OutputLength := WideCharToMultiByte(CodePage, 0, PWideChar(s), InputLength, nil, 0, nil, nil);
  SetLength(Result, OutputLength);
  WideCharToMultiByte(CodePage, 0, PWideChar(s), InputLength, PAnsiChar(Result), OutputLength, nil, nil);
end;

{$ENDIF MSWINDOWS}

function ValInt(const p: PChar; const l: Integer; out Code: Integer): Integer;
begin
  Result := {$IFDEF Unicode}ValIntW{$ELSE}ValIntA{$ENDIF}(p, l, Code);
end;

{$UNDEF Q_Temp}{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}

function ValIntA(p: PAnsiChar; l: Integer; out Code: Integer): Integer;

label
  Error, Fail, Hex;
var
  Negative: Boolean;
  c: Integer;
begin
  if not Assigned(p) then goto Fail;
  Code := l;

  while (l > 0) and (p^ <= AC_SPACE) do
    begin
      Inc(p); Dec(l);
    end;

  if l = 0 then goto Fail;

  Negative := p^ = AC_HYPHEN_MINUS;
  if Negative then
    begin
      Inc(p); Dec(l);
    end
  else
    if p^ = AC_PLUS_SIGN then
      begin
        Inc(p); Dec(l);
      end;

  if l = 0 then goto Fail;

  case p^ of
    AC_DOLLAR_SIGN,
    AC_CAPITAL_X,
    AC_SMALL_X:
      goto Hex;
    AC_DIGIT_ZERO:
      begin
        Inc(p); Dec(l);
        if (l > 0) and
          ((p^ = AC_CAPITAL_X) or
          (p^ = AC_SMALL_X)) then goto Hex;
      end;
  end;

  Result := 0;

  if Negative then
    while l > 0 do
      begin
        c := Ord(p^);
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 - c;
        if Result > 0 then goto Error;
        Inc(p); Dec(l);
      end
  else
    while l > 0 do
      begin
        c := Ord(p^);
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 + c;
        if Result < 0 then goto Error;
        Inc(p); Dec(l);
      end;

  Code := 0;
  Exit;

  Hex:
  Inc(p); Dec(l);
  if l = 0 then goto Fail;

  Result := 0;

  repeat
    c := HexCodePointToInt(Ord(p^));
    if c < 0 then goto Error;

    if Result and $F0000000 <> 0 then goto Error;

    Result := Result shl 4 or c;

    Inc(p);
    Dec(l);
  until l = 0;

  if Negative then Result := -Result;
  Code := 0;
  Exit;

  Error:
  Dec(Code, l - 1);
  Exit;

  Fail:
  Code := -1;

end;

function ValIntW(p: PWideChar; l: Integer; out Code: Integer): Integer;

label
  Error, Fail, Hex;
var
  Negative: Boolean;
  c: Integer;
begin
  if not Assigned(p) then goto Fail;
  Code := l;

  while (l > 0) and (p^ <= WC_SPACE) do
    begin
      Inc(p); Dec(l);
    end;

  if l = 0 then goto Fail;

  Negative := p^ = WC_HYPHEN_MINUS;
  if Negative then
    begin
      Inc(p); Dec(l);
    end
  else
    if p^ = WC_PLUS_SIGN then
      begin
        Inc(p); Dec(l);
      end;

  if l = 0 then goto Fail;

  case p^ of
    WC_DOLLAR_SIGN,
    WC_CAPITAL_X,
    WC_SMALL_X:
      goto Hex;
    WC_DIGIT_ZERO:
      begin
        Inc(p); Dec(l);
        if (l > 0) and
          ((p^ = WC_CAPITAL_X) or
          (p^ = WC_SMALL_X)) then goto Hex;
      end;
  end;

  Result := 0;

  if Negative then
    while l > 0 do
      begin
        c := Ord(p^);
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 - c;
        if Result > 0 then goto Error;
        Inc(p); Dec(l);
      end
  else
    while l > 0 do
      begin
        c := Ord(p^);
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 + c;
        if Result < 0 then goto Error;
        Inc(p); Dec(l);
      end;

  Code := 0;
  Exit;

  Hex:
  Inc(p); Dec(l);
  if l = 0 then goto Fail;

  Result := 0;

  repeat
    c := HexCodePointToInt(Ord(p^));
    if c < 0 then goto Error;

    if Result and $F0000000 <> 0 then goto Error;

    Result := Result shl 4 or c;

    Inc(p);
    Dec(l);
  until l = 0;

  if Negative then Result := -Result;
  Code := 0;
  Exit;

  Error:
  Dec(Code, l - 1);
  Exit;

  Fail:
  Code := -1;

end;

{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

function ValInt(const s: string; out Code: Integer): Integer;
begin
  Result := ValInt(Pointer(s), Length(s), Code);
end;

function ValIntA(const s: RawByteString; out Code: Integer): Integer;
begin
  Result := ValIntA(Pointer(s), Length(s), Code);
end;

function ValIntW(const s: UnicodeString; out Code: Integer): Integer;
begin
  Result := ValIntW(Pointer(s), Length(s), Code);
end;

{$IFDEF SUPPORTS_INT64}
{$UNDEF Q_Temp}{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}

function ValInt64A(p: PAnsiChar; l: Integer; out Code: Integer): Int64;

label
  Error, Fail, Hex;
var
  Negative: Boolean;
  c: Integer;
begin
  if not Assigned(p) then goto Fail;
  Code := l;

  while (l > 0) and (p^ <= AC_SPACE) do
    begin
      Inc(p); Dec(l);
    end;

  if l = 0 then goto Fail;

  Negative := p^ = AC_HYPHEN_MINUS;
  if Negative then
    begin
      Inc(p); Dec(l);
    end
  else
    if p^ = AC_PLUS_SIGN then
      begin
        Inc(p); Dec(l);
      end;

  if l = 0 then goto Fail;

  case p^ of
    AC_DOLLAR_SIGN,
    AC_CAPITAL_X,
    AC_SMALL_X:
      goto Hex;
    AC_DIGIT_ZERO:
      begin
        Inc(p); Dec(l);
        if (l > 0) and
          ((p^ = AC_CAPITAL_X) or
          (p^ = AC_SMALL_X)) then goto Hex;
      end;
  end;

  Result := 0;

  if Negative then
    while l > 0 do
      begin
        c := Ord(p^);
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 - c;
        if Result > 0 then goto Error;
        Inc(p); Dec(l);
      end
  else
    while l > 0 do
      begin
        c := Ord(p^);
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 + c;
        if Result < 0 then goto Error;
        Inc(p); Dec(l);
      end;

  Code := 0;
  Exit;

  Hex:
  Inc(p); Dec(l);
  if l = 0 then goto Fail;

  Result := 0;

  repeat
    c := HexCodePointToInt(Ord(p^));
    if c < 0 then goto Error;

    if Result and $F000000000000000 <> 0 then goto Error;

    Result := Result shl 4 or c;

    Inc(p);
    Dec(l);
  until l = 0;

  if Negative then Result := -Result;
  Code := 0;
  Exit;

  Error:
  Dec(Code, l - 1);
  Exit;

  Fail:
  Code := -1;

end;

function ValInt64W(p: PWideChar; l: Integer; out Code: Integer): Int64;

label
  Error, Fail, Hex;
var
  Negative: Boolean;
  c: Integer;
begin
  if not Assigned(p) then goto Fail;
  Code := l;

  while (l > 0) and (p^ <= WC_SPACE) do
    begin
      Inc(p); Dec(l);
    end;

  if l = 0 then goto Fail;

  Negative := p^ = WC_HYPHEN_MINUS;
  if Negative then
    begin
      Inc(p); Dec(l);
    end
  else
    if p^ = WC_PLUS_SIGN then
      begin
        Inc(p); Dec(l);
      end;

  if l = 0 then goto Fail;

  case p^ of
    WC_DOLLAR_SIGN,
    WC_CAPITAL_X,
    WC_SMALL_X:
      goto Hex;
    WC_DIGIT_ZERO:
      begin
        Inc(p); Dec(l);
        if (l > 0) and
          ((p^ = WC_CAPITAL_X) or
          (p^ = WC_SMALL_X)) then goto Hex;
      end;
  end;

  Result := 0;

  if Negative then
    while l > 0 do
      begin
        c := Ord(p^);
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 - c;
        if Result > 0 then goto Error;
        Inc(p); Dec(l);
      end
  else
    while l > 0 do
      begin
        c := Ord(p^);
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 + c;
        if Result < 0 then goto Error;
        Inc(p); Dec(l);
      end;

  Code := 0;
  Exit;

  Hex:
  Inc(p); Dec(l);
  if l = 0 then goto Fail;

  Result := 0;

  repeat
    c := HexCodePointToInt(Ord(p^));
    if c < 0 then goto Error;

    if Result and $F000000000000000 <> 0 then goto Error;

    Result := Result shl 4 or c;

    Inc(p);
    Dec(l);
  until l = 0;

  if Negative then Result := -Result;
  Code := 0;
  Exit;

  Error:
  Dec(Code, l - 1);
  Exit;

  Fail:
  Code := -1;

end;

{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}
{$ENDIF SUPPORTS_INT64}

function ValInt64A(const s: RawByteString; out Code: Integer): Int64;
begin
  //Result := ValInt64A(Pointer(s), Length(s), Code);
end;

function ValInt64W(const s: UnicodeString; out Code: Integer): Int64;
begin
  //Result := ValInt64W(Pointer(s), Length(s), Code);
end;

function YmdToIsoDateStr(const Year: Integer; const Month, Day: Word): string;
begin
  Result := {$IFDEF UNICODE}YmdToIsoDateStrW{$ELSE}YmdToIsoDateStrA{$ENDIF}(Year, Month, Day);
end;

function YmdToIsoDateStrA(const Year: Integer; const Month, Day: Word): RawByteString;
begin
  Result := PadLeftA(IntToStrA(Year * 10000 + Month * 100 + Day), 8, AC_DIGIT_ZERO);
end;

function YmdToIsoDateStrW(const Year: Integer; const Month, Day: Word): UnicodeString;
begin
  Result := PadLeftW(IntToStrW(Year * 10000 + Month * 100 + Day), 8, WC_DIGIT_ZERO);
end;

{$IFDEF CPUX86}

procedure ZeroMem(const Buffer; const Size: Cardinal);

asm
        PUSH    EDI
        MOV     ECX,EAX
        XOR     EAX,EAX
        MOV     EDI,ECX
        NEG     ECX
        AND     ECX,7
        SUB     EDX,ECX
        JMP     DWORD PTR @@bV[ECX*4]
@@bV:   DD      @@bu00, @@bu01, @@bu02, @@bu03
        DD      @@bu04, @@bu05, @@bu06, @@bu07
@@bu07: MOV     [EDI+06],AL
@@bu06: MOV     [EDI+05],AL
@@bu05: MOV     [EDI+04],AL
@@bu04: MOV     [EDI+03],AL
@@bu03: MOV     [EDI+02],AL
@@bu02: MOV     [EDI+01],AL
@@bu01: MOV     [EDI],AL
        ADD     EDI,ECX
@@bu00: MOV     ECX,EDX
        AND     EDX,3
        SHR     ECX,2
        REP     STOSD
        JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@tu00, @@tu01, @@tu02, @@tu03
@@tu03: MOV     [EDI+02],AL
@@tu02: MOV     [EDI+01],AL
@@tu01: MOV     [EDI],AL
@@tu00: POP     EDI
end;

{$ENDIF CPUX86}

{$ENDIF CLR}

function BitClear(const Bits, BitNo: Integer): Integer;
begin
  Result := Bits and not (1 shl BitNo);
end;

function BitSet(const Bits, BitIndex: Integer): Integer;
begin
  Result := Bits or (1 shl BitIndex);
end;

function BitSetTo(const Bits, BitIndex: Integer; const Value: Boolean): Integer;
begin
  if Value then
    Result := Bits or (1 shl BitIndex)
  else
    Result := Bits and not (1 shl BitIndex);
end;

function BitTest(const Bits, BitIndex: Integer): Boolean;
begin
  Result := (Bits and (1 shl BitIndex)) <> 0;
end;

function DayOfJulianDate(const JulianDate: TJulianDate): Word;
var
  Year: Integer;
  Month: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Result);
end;

function DayOfWeek(const JulianDate: TJulianDate): Word;

begin
  Result := JulianDate mod 7;
end;

function DayOfWeekYmd(const Year: Integer; const Month, Day: Word): Word;

begin
  Result := YmdToJulianDate(Year, Month, Day) mod 7;
end;

function DaysInMonthYm(const Year: Integer; const Month: Word): Word;
begin
  Result := DAYS_IN_MONTH[IsLeapYear(Year)][Month];
end;

function DaysInMonth(const JulianDate: TJulianDate): Word;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := DAYS_IN_MONTH[IsLeapYear(Year)][Month];
end;

procedure DecDay(var Year: Integer; var Month, Day: Word);
begin
  Dec(Day);
  if Day < 1 then
    begin
      Dec(Month);
      if Month < 1 then
        begin
          Month := 12;
          Dec(Year);
        end;
      Day := DaysInMonthYm(Year, Month);
    end;
end;

procedure DecDays(var Year: Integer; var Month, Day: Word; const Days: Integer);
var
  JulianDate: TJulianDate;
begin
  JulianDate := YmdToJulianDate(Year, Month, Day);
  Dec(JulianDate, Days);
  JulianDateToYmd(JulianDate, Year, Month, Day);
end;

{$IFDEF MSWINDOWS}

function DeleteDirectory(
  const Dir: string;
  const DeleteItself: Boolean{$IFDEF SUPPORTS_DEFAULTPARAMS} = True{$ENDIF}): Boolean;
begin
  Result := {$IFDEF Unicode}DeleteDirectoryW{$ELSE}DeleteDirectoryA{$ENDIF}(Dir, DeleteItself);
end;

function DeleteDirectoryA(
  Dir: AnsiString;
  const DeleteItself: Boolean{$IFDEF SUPPORTS_DEFAULTPARAMS} = True{$ENDIF}): Boolean;
var
  FileOpStruct: SHFILEOPSTRUCTA;
begin
  if DeleteItself then
    ExcludeTrailingPathDelimiterA(RawByteString(Dir))
  else
    begin
      IncludeTrailingPathDelimiterByRefA(RawByteString(Dir));
      Dir := Dir + AC_ASTERISK;
    end;

  Dir := Dir + WC_NULL;

  FillChar(FileOpStruct, SizeOf(FileOpStruct), 0);

  FileOpStruct.wFunc := FO_DELETE;
  FileOpStruct.pFrom := Pointer(Dir);
  FileOpStruct.FFlags := FOF_SILENT or FOF_NOCONFIRMATION;

  Result := SHFileOperationA({$IFDEF FPC}@{$ENDIF}FileOpStruct) = 0;
end;

function DeleteDirectoryW(
  Dir: UnicodeString;
  const DeleteItself: Boolean{$IFDEF SUPPORTS_DEFAULTPARAMS} = True{$ENDIF}): Boolean;
var
  FileOpStruct: SHFILEOPSTRUCTW;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      if DeleteItself then
        ExcludeTrailingPathDelimiterW(Dir)
      else
        begin
          IncludeTrailingPathDelimiterByRefW(Dir);
          Dir := Dir + UnicodeString(WC_ASTERISK);
        end;

      Dir := Dir + UnicodeString(WC_NULL);

      FillChar(FileOpStruct, SizeOf(FileOpStruct), 0);

      FileOpStruct.wFunc := FO_DELETE;
      FileOpStruct.pFrom := Pointer(Dir);
      FileOpStruct.FFlags := FOF_SILENT or FOF_NOCONFIRMATION;

      Result := SHFileOperationW({$IFDEF FPC}@{$ENDIF}FileOpStruct) = 0;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := DeleteDirectoryA(Dir, DeleteItself);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

function EasterSunday(const Year: Integer): TJulianDate;
var
  d, x: Integer;
begin
  d := (234 - 11 * (Year mod 19)) mod 30 + 21;
  if d > 48 then
    x := 1
  else
    x := 0;
  Result := YmdToJulianDate(Year, 3, 1);
  Inc(Result, d - x + 6 - ((Year + (Year div 4) + d - x + 1) mod 7));
end;

procedure EasterSundayYmd(const Year: Integer; out Month, Day: Word);
var
  DummyYear: Integer;
begin
  JulianDateToYmd(EasterSunday(Year), DummyYear, Month, Day);
end;

function FirstDayOfMonth(const Julian: TJulianDate): TJulianDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToJulianDate(Year, Month, 1);
end;

procedure FirstDayOfMonthYmd(const Year: Integer; const Month: Word; out Day: Word);
begin
  Day := 1;
end;

function FirstDayOfWeek(const JulianDate: TJulianDate): TJulianDate;
begin
  Result := JulianDate;
  Dec(Result, Result mod 7);
end;

procedure FirstDayOfWeekYmd(var Year: Integer; var Month, Day: Word);
var
  Julian: TJulianDate;
begin
  Julian := YmdToJulianDate(Year, Month, Day);
  Dec(Julian, Julian mod 7);
  JulianDateToYmd(Julian, Year, Month, Day);
end;

{$IFDEF MSWINDOWS}

function ForceDirectories(const Dir: string): Boolean;
begin
  Result := {$IFDEF UNICODE}ForceDirectoriesW{$ELSE}ForceDirectoriesA{$ENDIF}(Dir);
end;

function ForceDirectoriesA(Dir: AnsiString): Boolean;
var
  l: Integer;
  UpDir: AnsiString;
begin
  Result := True;
  if DirectoryExistsA(Dir) then Exit;
  ExcludeTrailingPathDelimiterA(RawByteString(Dir));
  l := Length(Dir);
  if l < 3 then Exit;
  UpDir := ExtractFilePathA(Dir);
  if l = Length(UpDir) then Exit;
  Result := ForceDirectoriesA(UpDir) and CreateDirectoryA(Pointer(Dir), nil);
end;

function ForceDirectoriesW(Dir: UnicodeString): Boolean;
var
  l: Integer;
  UpDir: UnicodeString;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Result := True;
      if DirectoryExistsW(Dir) then Exit;
      ExcludeTrailingPathDelimiterW(Dir);
      l := Length(Dir);
      if l < 3 then Exit;
      UpDir := ExtractFilePathW(Dir);
      if l = Length(UpDir) then Exit;
      Result := ForceDirectoriesW(UpDir) and CreateDirectoryW(Pointer(Dir), nil);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := ForceDirectoriesA(Dir);
  {$ENDIF}
end;

{$ENDIF MSWINDOWS}

function IsLeapYear(const Year: Integer): Boolean;
begin
  Result := (Year and 3 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
end;

function ISODateToJulianDate(const ISODate: TIsoDate): TJulianDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  ISODateToYmd(ISODate, Year, Month, Day);
  Result := YmdToJulianDate(Year, Month, Day);
end;

procedure ISODateToYmd(const ISODate: TIsoDate; out Year: Integer; out Month, Day: Word);
var
  i: TIsoDate;
begin
  i := ISODate;
  Year := i div 10000;
  Dec(i, Year * 10000);
  Month := i div 100;
  Day := i - Month * 100;
end;

function IsCharLowLineW(const c: WideChar): Boolean;
begin
  Result := c = WC_LOW_LINE;
end;

function IsCharQuoteW(const c: WideChar): Boolean;
begin
  case c of
    WC_APOSTROPHE,
      WC_QUOTATION_MARK:
      Result := True
  else
    Result := False;
  end;
end;

{$IFDEF MSWINDOWS}
function IsShiftKeyDown: Boolean;
begin
  Result := (GetAsyncKeyState(VK_LSHIFT) < 0) or (GetAsyncKeyState(VK_RSHIFT) < 0);
end;
{$ENDIF}

function IsCharWhiteSpaceOrAmpersandW(const c: WideChar): Boolean;
begin
  case c of
    WC_NULL..WC_SPACE,
      WC_AMPERSAND:
      Result := True
  else
    Result := False;
  end;
end;

function IsCharWhiteSpaceOrColonW(const c: WideChar): Boolean;
begin
  case c of
    WC_NULL..WC_SPACE,
      WC_COLON:
      Result := True
  else
    Result := False;
  end;
end;

function CharIsWhiteSpaceGtW(const c: WideChar): Boolean;
begin
  case c of
    WC_NULL..WC_SPACE,
      WC_GREATER_THAN_SIGN:
      Result := True
  else
    Result := False;
  end;
end;

function CharIsWhiteSpaceLtW(const c: WideChar): Boolean;
begin
  case c of
    WC_NULL..WC_SPACE,
      WC_LESS_THAN_SIGN:
      Result := True
  else
    Result := False;
  end;
end;

function CharIsWhiteSpaceHyphenW(const c: WideChar): Boolean;
begin
  case c of
    WC_NULL..WC_SPACE,
      WC_GREATER_THAN_SIGN,
      WC_HYPHEN_MINUS:
      Result := True
  else
    Result := False;
  end;
end;

function CharIsWhiteSpaceHyphenGtW(const c: WideChar): Boolean;
begin
  case c of
    WC_NULL..WC_SPACE,
      WC_GREATER_THAN_SIGN,
      WC_HYPHEN_MINUS:
      Result := True
  else
    Result := False;
  end;
end;

function IsCharWhiteSpaceOrNoBreakSpaceW(const c: WideChar): Boolean;
begin
  case c of
    WC_NULL..WC_SPACE,
      WC_NO_BREAK_SPACE:
      Result := True
  else
    Result := False;
  end;
end;

function CharIsAlphaW(const c: WideChar): Boolean;
begin
  case c of
    WC_CAPITAL_A..WC_CAPITAL_Z,
      WC_SMALL_A..WC_SMALL_Z:
      Result := True
  else
    Result := False;
  end;

end;

function CharIsAlphaNumW(const c: WideChar): Boolean;
begin
  case c of
    WC_DIGIT_ZERO..WC_DIGIT_NINE,
      WC_CAPITAL_A..WC_CAPITAL_Z,
      WC_SMALL_A..WC_SMALL_Z:
      Result := True
  else
    Result := False;
  end;
end;

function CharIsCrLf(const c: Char): Boolean;
begin
  Result := {$IFDEF UNICODE}CharIsCrLfW{$ELSE}CharIsCrLfA{$ENDIF}(c);
end;

function CharIsCrLfA(const c: AnsiChar): Boolean;
begin
  case c of
    AC_LF, AC_CR:
      Result := True
  else
    Result := False;
  end;
end;

function CharIsCrLfW(const c: WideChar): Boolean;
begin
  case c of
    WC_LF, WC_CR:
      Result := True
  else
    Result := False;
  end;
end;

function CharIsDigit(const c: Char): Boolean;
begin
  Result := {$IFDEF UNICODE}CharIsDigitW{$ELSE}CharIsDigitA{$ENDIF}(c);
end;

function CharIsDigitA(const c: AnsiChar): Boolean;
begin
  Assert(SizeOf(c) = SizeOf(Byte));
  Result := Byte(Ord(c) - Ord('0')) <= Ord('9') - Ord('0');
end;

function CharIsDigitW(const c: WideChar): Boolean;
begin
  Assert(SizeOf(c) = SizeOf(Word));
  Result := Word(Ord(c) - Ord('0')) <= Ord('9') - Ord('0');
end;

function CharIsHangulW(const Char: WideChar): Boolean;
begin
  Result := (Char >= #$AC00) and (Char <= #$D7FF);
end;

function CharIsHexDigitW(const c: WideChar): Boolean;
begin
  case c of
    WC_DIGIT_ZERO..WC_DIGIT_NINE,
      WC_CAPITAL_A..WC_CAPITAL_F,
      WC_SMALL_A..WC_SMALL_F:
      Result := True
  else
    Result := False;
  end;
end;

function CharIsWhiteSpaceW(const c: WideChar): Boolean;
begin
  Result := c <= WC_SPACE;
end;

procedure IncDay(var Year: Integer; var Month, Day: Word);
begin
  Inc(Day);
  if Day > DaysInMonthYm(Year, Month) then
    begin
      Day := 1;
      Inc(Month);
      if Month > 12 then
        begin
          Month := 1;
          Inc(Year);
        end;
    end;
end;

procedure IncDays(var Year: Integer; var Month, Day: Word; const Days: Integer);
var
  JulianDate: TJulianDate;
begin
  JulianDate := YmdToJulianDate(Year, Month, Day);
  Inc(JulianDate, Days);
  JulianDateToYmd(JulianDate, Year, Month, Day);
end;

procedure IncMonth(var Year: Integer; var Month, Day: Word);
var
  d: Word;
begin
  Inc(Month);
  if Month > 12 then
    begin
      Month := 1;
      Inc(Year);
    end;
  d := DaysInMonthYm(Year, Month);
  if Day > d then
    Day := d;
end;

procedure IncMonths(var Year: Integer; var Month, Day: Word; const NumberOfMonths: Integer);
var
  IMonth: Integer;
begin
  IMonth := Month + NumberOfMonths;
  if IMonth > 12 then
    begin
      Inc(Year, (IMonth - 1) div 12);
      IMonth := IMonth mod 12;
      if IMonth = 0 then
        IMonth := 12;
    end
  else
    if IMonth < 1 then
      begin
        Inc(Year, (IMonth div 12) - 1);
        IMonth := 12 + IMonth mod 12;
      end;
  Month := IMonth;
  IMonth := DaysInMonthYm(Year, Month);
  if Day > IMonth then
    Day := IMonth;
end;

procedure FreeMemAndNil(var Ptr);
var
  Temp: Pointer;
begin
  Temp := Pointer(Ptr);
  Pointer(Ptr) := nil;
  FreeMem(Temp);
end;

function IsDateValid(const Year: Integer; const Month, Day: Word): Boolean;
begin
  Result := (Month in [1..12]) and (Day > 0) and (Day <= DaysInMonthYm(Year, Month));
end;

function InternalIsHolidayInGermany(const Julian: TJulianDate; const Year: Integer; const Month, Day: Word): Boolean;
label
  Success;
var
  ES: TJulianDate;
begin
  if DayOfWeek(Julian) = ISO_SUNDAY then goto Success;

  case Month of
    1:
      begin
        case Day of
          1: goto Success;
        end;
      end;
    2:
      begin
      end;
    3:
      begin
      end;
    5:
      begin
        case Day of
          1: goto Success;
        end;
      end;
    6:
      begin
      end;
    8:
      begin
      end;
    9:
      begin
      end;
    10:
      begin
        case Day of
          3: goto Success;
        end;
      end;
    11:
      begin
      end;
    12:
      begin
        case Day of
          24: goto Success;
          25: goto Success;
          26: goto Success;
          31: goto Success;
        end;
      end;
  end;

  ES := EasterSunday(Year);

  if Julian = ES - 2 then goto Success;
  if Julian = ES + 1 then goto Success;
  if Julian = ES + 39 then goto Success;
  if Julian = ES + 50 then goto Success;

  Result := False;
  Exit;

  Success:
  Result := True;
end;

function IsHolidayInGermany(const Julian: TJulianDate): Boolean;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := InternalIsHolidayInGermany(Julian, Year, Month, Day);
end;

function IsHolidayInGermanyYmd(const Year: Integer; const Month, Day: Word): Boolean;
begin
  Result := InternalIsHolidayInGermany(YmdToJulianDate(Year, Month, Day), Year, Month, Day);
end;

{$IFDEF MSWINDOWS}
function IsPointInRect(const Point: TPoint; const Rect: TRect): Boolean;
begin
  with Point, Rect do
    Result := (x >= Left) and (x <= Right) and (y >= Top) and (y <= Bottom);
end;
{$ENDIF}

function IsCharWordSeparatorW(const c: WideChar): Boolean;
begin
  case c of
    WC_NULL..WC_SPACE,
    WC_DIGIT_ZERO..WC_DIGIT_NINE,
    WC_FULL_STOP, WC_COMMA, WC_COLON, WC_SEMICOLON,
    WC_QUOTATION_MARK,
      WC_LEFT_PARENTHESIS, WC_RIGHT_PARENTHESIS,
      WC_HYPHEN_MINUS, WC_SOLIDUS, WC_AMPERSAND:
      Result := True
  else
    Result := False;
  end;
end;

function ISOWeekNumber(const JulianDate: TJulianDate): Word;
var
  D4, l: TJulianDate;
begin

  D4 := (JulianDate + 31741 - JulianDate mod 7) mod 146097 mod 36524 mod 1461;
  l := D4 div 1460;
  Result := ((D4 - l) mod 365 + l) div 7 + 1
end;

function ISOWeekNumberYmd(const Year: Integer; const Month, Day: Word): Word;
begin
  Result := ISOWeekNumber(YmdToJulianDate(Year, Month, Day));
end;

function ISOWeekToJulianDate(const Year: Integer; const WeekOfYear, DayOfWeek: Word): TJulianDate;
begin
  Result := YmdToJulianDate(Year, 1, 4);
  Inc(Result, (WeekOfYear - 1) * 7 - Result mod 7 + DayOfWeek);
end;

function JulianDateIsWeekDay(const JulianDate: TJulianDate): Boolean;
begin
  Result := JulianDate mod 7 < ISO_SATURDAY;
end;

function JulianDateToIsoDate(const Julian: TJulianDate): TIsoDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToIsoDate(Year, Month, Day);
end;

procedure JulianDateToYmd(const JulianDate: TJulianDate; out Year: Integer; out Month, Day: Word);
{$IFDEF Calender_FAQ}
var
  a, b, c, d, e, m: Integer;
begin
  a := JulianDate + 32044;
  b := (4 * a + 3) div 146097;
  c := a - (b * 146097) div 4;
  d := (4 * c + 3) div 1461;
  e := c - (1461 * d) div 4;
  m := (5 * e + 2) div 153;
  Day := e - (153 * m + 2) div 5 + 1;
  Month := m + 3 - 12 * (m div 10);
  Year := b * 100 + d - 4800 + m div 10;
end;
{$ELSE}
var
  l, n, i, j: Integer;
begin
  l := JulianDate + 68569;
  n := 4 * l div 146097;
  l := l - (146097 * n + 3) div 4;
  i := 4000 * (l + 1) div 1461001;
  l := l - 1461 * i div 4 + 31;
  j := 80 * l div 2447;
  Day := l - 2447 * j div 80;
  l := j div 11;
  Month := j + 2 - 12 * l;
  Year := 100 * (n - 49) + i + l;
end;
{$ENDIF}

function LastDayOfMonth(const JulianDate: TJulianDate): TJulianDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := YmdToJulianDate(Year, Month, DaysInMonthYm(Year, Month));
end;

procedure LastDayOfMonthYmd(const Year: Integer; const Month: Word; out Day: Word);
begin
  Day := DaysInMonthYm(Year, Month);
end;

function LastDayOfWeek(const JulianDate: TJulianDate): TJulianDate;
begin
  Result := JulianDate;
  Inc(Result, 6 - (Result mod 7));
end;

procedure LastDayOfWeekYmd(var Year: Integer; var Month, Day: Word);
var
  Julian: TJulianDate;
begin
  Julian := YmdToJulianDate(Year, Month, Day);
  Inc(Julian, 6 - (Julian mod 7));
  JulianDateToYmd(Julian, Year, Month, Day);
end;

{$IFDEF MSWINDOWS}

function LastSysErrorMessage: string;
begin
  Result := {$IFDEF UNICODE}SysErrorMessageW{$ELSE}SysErrorMessageA{$ENDIF}(GetLastError);
end;

function LastSysErrorMessageA: AnsiString;
begin
  Result := SysErrorMessageA(GetLastError);
end;

function LastSysErrorMessageW: UnicodeString;
begin
  Result := SysErrorMessageW(GetLastError);
end;

{$ENDIF MSWINDOWS}

function Max(const a, b: Integer): Integer;
begin
  Result := a;
  if b > Result then
    Result := b;
end;

function Max3(const a, b, c: Integer): Integer;
begin
  Result := a;
  if b > Result then
    Result := b;
  if c > Result then
    Result := c;
end;

{$IFDEF SUPPORTS_OVERLOAD}
function Max(const a, b: Cardinal): Cardinal; overload;
begin
  Result := a;
  if b > Result then
    Result := b;
end;
{$ENDIF COMPILER_4_UP}

{$IFDEF SUPPORTS_OVERLOAD}
function Max(const a, b, c: Cardinal): Cardinal; overload;
begin
  Result := a;
  if b > Result then
    Result := b;
  if c > Result then
    Result := c;
end;
{$ENDIF SUPPORTS_OVERLOAD}

{$IFDEF SUPPORTS_OVERLOAD}
function Max(const a, b: Int64): Int64; overload;
begin
  Result := a;
  if b > Result then
    Result := b;
end;

function Max(const a, b, c: Int64): Int64; overload;
begin
  Result := a;
  if b > Result then
    Result := b;
  if c > Result then
    Result := c;
end;
{$ENDIF SUPPORTS_OVERLOAD}

function Min(const a, b: Integer): Integer;
begin
  Result := a;
  if b < Result then
    Result := b;
end;

function Min3(const a, b, c: Integer): Integer;
begin
  Result := a;
  if b < Result then
    Result := b;
  if c < Result then
    Result := c;
end;

{$IFDEF SUPPORTS_OVERLOAD}

function Min(const a, b: Cardinal): Cardinal; overload;
begin
  Result := a;
  if b < Result then
    Result := b;
end;

function Min(const a, b, c: Cardinal): Cardinal; overload;
begin
  Result := a;
  if b < Result then
    Result := b;
  if c < Result then
    Result := c;
end;

{$ENDIF SUPPORTS_OVERLOAD}

{$IFDEF SUPPORTS_OVERLOAD}

function Min(const a, b: Int64): Int64; overload;
begin
  Result := a;
  if b < Result then
    Result := b;
end;

function Min(const a, b, c: Int64): Int64; overload;
begin
  Result := a;
  if b < Result then
    Result := b;
  if c < Result then
    Result := c;
end;

{$ENDIF SUPPORTS_OVERLOAD}

{$IFDEF SUPPORTS_OVERLOAD}

function Min(const a, b: UInt64): UInt64; overload;
begin
  Result := a;
  if b < Result then
    Result := b;
end;

function Min(const a, b, c: UInt64): UInt64; overload;
begin
  Result := a;
  if b < Result then
    Result := b;
  if c < Result then
    Result := c;
end;

{$ENDIF SUPPORTS_OVERLOAD}

function MonthOfJulianDate(const JulianDate: TJulianDate): Word;
var
  Year: Integer;
  Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Result, Day);
end;

function YearOfJuilanDate(const JulianDate: TJulianDate): Integer;
var
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Result, Month, Day);
end;

function YmdToIsoDate(const Year: Integer; const Month, Day: Word): TIsoDate;
begin
  Result := Year * 10000 + Month * 100 + Day;
end;

function YmdToJulianDate(const Year: Integer; const Month, Day: Word): TJulianDate;
{$IFDEF Calender_FAQ}
var
  a, y, m: Integer;
begin
  a := (14 - Month) div 12;
  y := Year + 4800 - a;
  m := Month + 12 * a - 3;
  Result := Day + (153 * m + 2) div 5 + y * 365 + y div 4 - y div 100 + y div 400 - 32045;
end;
{$ELSE}
begin
  Result := (1461 * (Year + 4800 + (Month - 14) div 12)) div 4 +
    (367 * (Month - 2 - 12 * ((Month - 14) div 12))) div 12 -
    (3 * ((Year + 4900 + (Month - 14) div 12) div 100)) div 4 +
    Day - 32075;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
{$IFNDEF DI_No_Win_9X_Support}
procedure Init;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  IsUnicode := GetVersionEx(OSVersionInfo) and
    (OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF MSWINDOWS}
{$IFNDEF DI_No_Win_9X_Support}
initialization
  Init;
  {$ENDIF}
  {$ENDIF}

end.

