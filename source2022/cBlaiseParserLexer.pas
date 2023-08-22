{                                                                              }
{                             Blaise Lexer v0.03                               }
{                                                                              }
{                    This unit is part of Blaise Script.                       }
{              Its original file name is cBlaiseParserLexer.pas                }
{                                                                              }
{     This unit is copyright © 1999-2003 by David J Butler (david@e.co.za)     }
{                             All rights reserved.                             }
{                                                                              }
{                                                                              }
{ Revision history:                                                            }
{   21/05/99  0.01  Initial version.                                           }
{   14/05/02  0.02  Moved Lexer class from cBlaise unit.                       }
{   11/04/03  0.03  Refactored out dependancy on generic lexer base class.     }
{   27/12/2020 0.04 experimental adaption for maXXbox                          }
// change Procedure SetData from pointer to str

//{$INCLUDE cHeader.inc}
unit cBlaiseParserLexer;

interface

uses
  { Delphi }
  SysUtils,

  { Fundamentals }
  cFundamentUtils;


{                                                                              }
{ Token Strings                                                                }
{                                                                              }
const
  { Expressions                                                                }
  c_True           = 'True';
  c_False          = 'False';
  c_Or             = 'or';
  c_Xor            = 'xor';
  c_And            = 'and';
  c_Not            = 'not';
  c_EqualTo        = '=';
  c_NotEqual       = '<>';
  c_LessThan       = '<';
  c_GreaterThan    = '>';
  c_LessOrEqual    = '<=';
  c_GreaterOrEqual = '>=';
  c_RDiv           = 'rdiv';
  c_Div            = 'div';
  c_Mod            = 'mod';
  c_Shl            = 'shl';
  c_Shr            = 'shr';
  c_Plus           = '+';
  c_Minus          = '-';
  c_Multiply       = '*';
  c_Divide         = '/';
  c_Power          = '**';
  c_Concatenate    = '&';
  c_nil            = 'nil';
  c_self           = 'self';
  c_inherited      = 'inherited';
  c_Is             = 'is';

  { Names                                                                      }
  c_Named          = 'named';
  c_Exists         = 'exists';
  c_Delete         = 'delete';
  c_Dir            = 'dir';

  { Statements                                                                 }
  c_SDelim         = ';';
  c_Assign         = ':=';
  c_Begin          = 'begin';
  c_End            = 'end';
  c_If             = 'if';
  c_Then           = 'then';
  c_Else           = 'else';
  c_Write          = 'write';
  c_Writeln        = 'writeln';
  c_Read           = 'read';
  c_While          = 'while';
  c_Do             = 'do';
  c_Repeat         = 'repeat';
  c_Until          = 'until';
  c_For            = 'for';
  c_To             = 'to';
  c_In             = 'in';
  c_Downto         = 'downto';
  c_Step           = 'step';
  c_Where          = 'where';
  c_Case           = 'case';
  c_Of             = 'of';
  c_raise          = 'raise';
  c_Try            = 'try';
  c_Except         = 'except';
  c_Finally        = 'finally';
  c_On             = 'on';
  c_Exit           = 'exit';
  c_Break          = 'break';
  c_Continue       = 'continue';
  c_Return         = 'return';
  c_Import         = 'import';
  c_From           = 'from';

  { Declarations                                                               }
  c_Program        = 'program';
  c_Unit           = 'unit';
  c_Interface      = 'interface';
  c_Implementation = 'implementation';
  c_Initialization = 'initialization';
  c_Finalization   = 'finalization';
  c_Uses           = 'uses';
  c_Const          = 'const';
  c_Var            = 'var';
  c_Type           = 'type';
  c_Function       = 'function';
  c_Procedure      = 'procedure';
  c_Task           = 'task';
  c_Class          = 'class';
  c_Public         = 'public';
  c_Protected      = 'protected';
  c_Private        = 'private';
  c_Constructor    = 'constructor';
  c_Destructor     = 'destructor';
  c_Property       = 'property';
  c_Record         = 'record';
  c_overload       = 'overload';
  c_virtual        = 'virtual';
  c_abstract       = 'abstract';
  c_override       = 'override';
  c_reintroduce    = 'reintroduce';
  c_Array          = 'array';
  c_Dictionary     = 'dictionary';
  c_Stream         = 'stream';
  c_packed         = 'packed';
  c_External       = 'external';
  c_Name           = 'name';
  c_CDecl          = 'cdecl';
  c_StdCall        = 'stdcall';
  c_SafeCall       = 'safecall';
  c_Pascal         = 'pascal';
  c_Register       = 'register';



{                                                                              }
{ Lexical tokens                                                               }
{                                                                              }
const
  ttEOF               = $00;
  ttInvalid           = $01;
  ttIgnore            = $02;
  ttSpace             = $03;
  ttEOL               = $04;
  ttIdentifier        = $05;

  ttNumber            = $10;
  ttHexNumber         = $11;
  ttHexNumber2        = $12;
  ttBinaryNumber      = $13;
  ttRealNumber        = $14;
  ttSciRealNumber     = $15;
  ttComplexNumber     = $16;

  ttStringLiteral     = $20;
  ttRegExLiteral      = $21;

  ttBlockComment1     = $30;
  ttBlockComment2     = $31;
  ttLineComment       = $32;

  ttReservedWord      = $40;
  ttBegin             = ttReservedWord + 0;
  ttEnd               = ttReservedWord + 1;
  ttIf                = ttReservedWord + 2;
  ttThen              = ttReservedWord + 3;
  ttElse              = ttReservedWord + 4;
  ttConst             = ttReservedWord + 5;
  ttType              = ttReservedWord + 6;
  ttVar               = ttReservedWord + 7;
  ttRepeat            = ttReservedWord + 8;
  ttUntil             = ttReservedWord + 9;
  ttFor               = ttReservedWord + 10;
  ttTo                = ttReservedWord + 11;
  ttDownto            = ttReservedWord + 12;
  ttStep              = ttReservedWord + 13;
  ttIn                = ttReservedWord + 14;
  ttWhile             = ttReservedWord + 15;
  ttDo                = ttReservedWord + 16;
  ttCase              = ttReservedWord + 17;
  ttOf                = ttReservedWord + 18;
  ttProcedure         = ttReservedWord + 19;
  ttFunction          = ttReservedWord + 20;
  ttTask              = ttReservedWord + 21;
  ttClass             = ttReservedWord + 22;
  ttConstructor       = ttReservedWord + 23;
  ttProgram           = ttReservedWord + 24;
  ttUses              = ttReservedWord + 25;
  ttPrivate           = ttReservedWord + 26;
  ttProtected         = ttReservedWord + 27;
  ttPublic            = ttReservedWord + 28;
  ttUnit              = ttReservedWord + 29;
  ttInterface         = ttReservedWord + 30;
  ttImplementation    = ttReservedWord + 31;
  ttInitialization    = ttReservedWord + 32;
  ttFinalization      = ttReservedWord + 33;
  ttVirtual           = ttReservedWord + 34;
  ttAbstract          = ttReservedWord + 35;
  ttOverride          = ttReservedWord + 36;
  ttOverload          = ttReservedWord + 37;
  ttReintroduce       = ttReservedWord + 38;
  ttRecord            = ttReservedWord + 39;
  ttTrue              = ttReservedWord + 40;
  ttFalse             = ttReservedWord + 41;
  ttOr                = ttReservedWord + 42;
  ttXor               = ttReservedWord + 43;
  ttDiv               = ttReservedWord + 44;
  ttMod               = ttReservedWord + 45;
  ttShl               = ttReservedWord + 46;
  ttShr               = ttReservedWord + 47;
  ttAnd               = ttReservedWord + 48;
  ttNot               = ttReservedWord + 49;
  ttProperty          = ttReservedWord + 50;
  ttDestructor        = ttReservedWord + 51;
  ttArray             = ttReservedWord + 52;
  ttInherited         = ttReservedWord + 53;
  ttPacked            = ttReservedWord + 54;
  ttRaise             = ttReservedWord + 55;
  ttIs                = ttReservedWord + 56;
  ttTry               = ttReservedWord + 57;
  ttExcept            = ttReservedWord + 58;
  ttFinally           = ttReservedWord + 59;
  ttOn                = ttReservedWord + 60;
  ttSelf              = ttReservedWord + 61;
  ttNil               = ttReservedWord + 62;
  ttRDiv              = ttReservedWord + 63;
  ttExit              = ttReservedWord + 64;
  ttBreak             = ttReservedWord + 65;
  ttContinue          = ttReservedWord + 66;
  ttDictionary        = ttReservedWord + 67;
  ttNamed             = ttReservedWord + 68;
  ttWhere             = ttReservedWord + 69;
  ttStream            = ttReservedWord + 70;
  ttReturn            = ttReservedWord + 71;
  ttImport            = ttReservedWord + 72;
  ttFrom              = ttReservedWord + 73;
  ttExternal          = ttReservedWord + 74;
  ttCDecl             = ttReservedWord + 75;
  ttPascal            = ttReservedWord + 76;
  ttRegister          = ttReservedWord + 77;
  ttStdCall           = ttReservedWord + 78;
  ttSafeCall          = ttReservedWord + 79;

  ttSymbol            = $C0;
  ttStatementDelim    = ttSymbol + 0;
  ttDot               = ttSymbol + 1;
  ttDotDot            = ttSymbol + 2;
  ttDotDotDot         = ttSymbol + 3;
  ttOpenBlockBracket  = ttSymbol + 4;
  ttCloseBlockBracket = ttSymbol + 5;
  ttQuestionMark      = ttSymbol + 6;
  ttComma             = ttSymbol + 7;
  ttOpenBracket       = ttSymbol + 8;
  ttCloseBracket      = ttSymbol + 9;
  ttExclamationMark   = ttSymbol + 10;
  ttCaret             = ttSymbol + 11;
  ttBackSlash         = ttSymbol + 12;
  ttAssignment        = ttSymbol + 13;
  ttLessOrEqual       = ttSymbol + 14;
  ttGreaterOrEqual    = ttSymbol + 15;
  ttNotEqual          = ttSymbol + 16;
  ttLess              = ttSymbol + 17;
  ttGreater           = ttSymbol + 18;
  ttEqual             = ttSymbol + 19;
  ttPlus              = ttSymbol + 20;
  ttMinus             = ttSymbol + 21;
  ttMultiply          = ttSymbol + 22;
  ttDivide            = ttSymbol + 23;
  ttPower             = ttSymbol + 24;
  ttHash              = ttSymbol + 25;
  ttColon             = ttSymbol + 26;

 {$DEFINE LEX_PROFILE}

{                                                                              }
{ TBlaiseLexer                                                                 }
{                                                                              }
{   The lexer accepts CRLF or LF (but not CR alone) as EOL terminators.        }
{                                                                              }
type
  TLexCharProc = procedure (const Ch: Char) of object;
  TBlaiseLexer = class
  //protected
    FData         : PChar;
    FSize         : Integer;
    FText         : String;
    FPos          : Integer;
    FTokenLen     : Integer;
    FTokenPos     : Integer;
    FLastTokenEnd : Integer;
    FTokenType    : Integer;
    FLineNr       : Integer;
    FLastEOL      : Integer;
    CharProc      : Array[#0..#255] of TLexCharProc;

    function  GetColumn: Integer;
    function  GetCurrentLine: String;

    procedure LexError(const Msg: String);
    procedure UnterminatedStringError;
    procedure UnterminatedCommentError;

    function  RunWith(const C: CharSet): Boolean;
    function  RunTo(const C: Char): Boolean; overload;
    function  RunTo(const C: CharSet): Boolean; overload;
    function  RunTo(const Delim: String; const SkipDelim: Boolean): Boolean; overload;
    function  ExtractOne(const C: Char): Boolean; overload;
    function  ExtractOne(const C: CharSet): Boolean; overload;

    procedure Char_Ignore(const Ch: Char);
    procedure Char_IdentifierStart(const Ch: Char);
    procedure Char_LF(const Ch: Char);
    procedure Char_CR(const Ch: Char);
    procedure Char_Quote(const Ch: Char);
    procedure Char_OpenCurly(const Ch: Char);
    procedure Char_OpenRound(const Ch: Char);
    procedure Char_Slash(const Ch: Char);
    procedure Char_Colon(const Ch: Char);
    procedure Char_Dot(const Ch: Char);
    procedure Char_Asterisk(const Ch: Char);
    procedure Char_LessThan(const Ch: Char);
    procedure Char_GreaterThan(const Ch: Char);

    procedure Char_Number(const Ch: Char);
    procedure Char_Dollar(const Ch: Char);
    procedure Char_SingleCharToken(const Ch: Char);
    procedure Char_Unknown(const Ch: Char);

  public
    {$IFDEF LEX_PROFILE}
    TokenCount     : Integer;
    IdenCount      : Integer;
    SymbolCount    : Integer;
    IgnoreCount    : Integer;
    ReservedCount  : Integer;
    {$ENDIF}

    constructor Create;

    procedure Reset;
    procedure SetData(const Data: pchar; const Size: Integer);
    procedure SetText(const S: String; const StartPosition: Integer = 1);

    function  EOF: Boolean;
    procedure GetToken;

    property  TokenLen: Integer read FTokenLen;
    property  TokenType: Integer read FTokenType;
    function  TokenText: String;
    property  TokenPos: Integer read FTokenPos;
    property  LastTokenEnd: Integer read FLastTokenEnd;
    property  Position: Integer read FPos write FPos;
    property  LineNr: Integer read FLineNr;
    property  Column: Integer read GetColumn;
    property  CurrentLine: String read GetCurrentLine;

    function  MatchType(const TokenType: Integer; const Skip: Boolean = False): Boolean;
    function  MatchTokenText(const Token: String; const Skip: Boolean = False;
              const CaseSensitive: Boolean = True): Boolean;
    function  TokenAsInteger: Int64;
  end;

  { EBlaiseLexer                                                               }
  EBlaiseLexer = class(Exception)
    Parser   : TBlaiseLexer;
    LineNr   : Integer;
    Column   : Integer;
    Position : Integer;

    constructor Create(const Parser: TBlaiseLexer; const Msg: String);
  end;



implementation

uses
  { Fundamentals }
  //cStrings,
  cwindows;



{                                                                              }
{ Lex constants                                                                }
{                                                                              }
const
  IdentifierStartChar = ['A'..'Z', 'a'..'z', '_'];
  IdentifierChars     = IdentifierStartChar + ['0'..'9'];

  ReservedWordCount = 80;
  ReservedWords : Array[0..ReservedWordCount - 1] of String = (
     c_begin, c_end, c_if, c_then, c_else, c_const, c_type, c_var, c_repeat,
     c_until, c_for, c_to, c_downto, c_step, c_in, c_while, c_do, c_case,
     c_of, c_procedure, c_function, c_task, c_class, c_constructor, c_program,
     c_uses, c_private, c_protected, c_public, c_unit, c_interface,
     c_implementation, c_initialization, c_finalization, c_virtual, c_abstract,
     c_override, c_overload, c_reintroduce, c_record, c_True, c_False, c_or,
     c_xor, c_div, c_mod, c_shl, c_shr, c_and, c_not, c_property, c_destructor,
     c_array, c_inherited, c_packed, c_raise, c_is, c_try, c_except, c_finally,
     c_on, c_self, c_nil, c_rdiv, c_exit, c_break, c_continue, c_dictionary,
     c_named, c_where, c_stream, c_return, c_import, c_from, c_external,
     c_cdecl, c_pascal, c_register, c_stdcall, c_safecall);



{                                                                              }
{ Reserved word hash table                                                     }
{                                                                              }
var
  ReservedHashInit : Boolean = False;
  ReservedHash     : Array[0..255] of IntegerArray;

procedure InitReservedHash;
var I, J : Integer;
    H    : Byte;
    S    : String;
begin
  For I := 0 to 255 do
    ReservedHash[I] := nil;
  For I := 0 to Length(ReservedWords) - 1 do
    begin
      S := ReservedWords[I];
      if S <> '' then
        begin
          H := 0;
          For J := 1 to Length(S) do
            //H := Byte(H + Byte(AnsiLowCaseLookup[S[J]]));
          //Append(ReservedHash[H], I);
        end;
    end;
  ReservedHashInit := True;
end;





{                                                                              }
{ EBlaiseLexer                                                                 }
{                                                                              }
constructor EBlaiseLexer.Create(const Parser: TBlaiseLexer; const Msg: String);
begin
  inherited Create(Msg);
  self.Parser := Parser;
  LineNr := Parser.LineNr;
  Column := Parser.Column;
  Position := Parser.Position;
end;




{                                                                              }
{ TBlaiseLexer                                                                 }
{                                                                              }
constructor TBlaiseLexer.Create;
var Ch : Char;
begin
  inherited Create;
  For Ch := #0 to #32 do
    CharProc[Ch] := Char_Ignore;
  For Ch := #33 to #255 do
    begin
      if Ch in IdentifierStartChar then
        CharProc[Ch] := Char_IdentifierStart
      else
        CharProc[Ch] := Char_Unknown;
    end;
  For Ch := '0' to '9' do
    CharProc[Ch] := Char_Number;
  CharProc[#10] := Char_LF;
  CharProc[#13] := Char_CR;
  CharProc[''''] := Char_Quote;
  CharProc[':'] := Char_Colon;
  CharProc['.'] := Char_Dot;
  CharProc['$'] := Char_Dollar;
  CharProc['{'] := Char_OpenCurly;
  CharProc['('] := Char_OpenRound;
  CharProc['<'] := Char_LessThan;
  CharProc['>'] := Char_GreaterThan;
  CharProc['/'] := Char_Slash;
  CharProc['*'] := Char_Asterisk;
  CharProc[';'] := Char_SingleCharToken;
  CharProc['['] := Char_SingleCharToken;
  CharProc[']'] := Char_SingleCharToken;
  CharProc['?'] := Char_SingleCharToken;
  CharProc[','] := Char_SingleCharToken;
  CharProc[')'] := Char_SingleCharToken;
  CharProc['!'] := Char_SingleCharToken;
  CharProc['^'] := Char_SingleCharToken;
  CharProc['\'] := Char_SingleCharToken;
  CharProc['='] := Char_SingleCharToken;
  CharProc['+'] := Char_SingleCharToken;
  CharProc['-'] := Char_SingleCharToken;
  CharProc['#'] := Char_SingleCharToken;
  if not ReservedHashInit then
    InitReservedHash;
end;

procedure TBlaiseLexer.Reset;
begin
  FPos := 0;
  FLastEOL := 0;
  FLineNr := 1;
  {$IFDEF LEX_PROFILE}
  TokenCount := 0;
  IdenCount := 0;
  SymbolCount := 0;
  IgnoreCount := 0;
  ReservedCount := 0;
  {$ENDIF}
end;

procedure TBlaiseLexer.SetData(const Data: pchar; const Size: Integer);
begin
  FData := Data;
  FSize := Size;
  Reset;
end;

procedure TBlaiseLexer.SetText(const S: string; const StartPosition: Integer);
begin
  Assert(StartPosition >= 1, 'StartPosition >= 1');
  FText := S; // keep reference
  SetData(pchar(S), Length(S));
  FPos := StartPosition - 1;
end;

procedure TBlaiseLexer.LexError(const Msg: String);
begin
  raise EBlaiseLexer.Create(self, Msg);
end;

procedure TBlaiseLexer.UnterminatedStringError;
begin
  LexError('Unterminated string');
end;

procedure TBlaiseLexer.UnterminatedCommentError;
begin
  LexError('Unterminated comment');
end;

function TBlaiseLexer.GetColumn: Integer;
begin
  Result := FPos - FLastEOL + 1;
end;

function StrZSkipToChar(var P: PChar; const C: CharSet): Integer;
var Q : PChar;
    D : Char;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  repeat
    D := Q^;
    if D = #0 then
      break;
    {$IFDEF StringIsUnicode}
    if Ord(D) >= $100 then
      break;
    if AnsiChar(Ord(D)) in C then
      break;
    {$ELSE}
    if D in C then
      break;
    {$ENDIF}
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrPToStr(const P: PChar; const L: Integer): String;
begin
  Assert(L >= 0);
  SetLength(Result, L);
  if L > 0 then
    MoveMem(P^, Pointer(Result)^, L * SizeOf(Char));
end;

function ExtractTo(var P: PChar; const C: CharSet): String;
var Q : PChar;
    L : Integer;
begin
  Q := P;
  L := StrZSkipToChar(P, C);
  Result := StrPToStr(Q, L);
end;

function TBlaiseLexer.GetCurrentLine: String;
var P : pchar;
begin
  P := FData;
  Inc(P, FLastEOL);
  Result := ExtractTo(P, [#10, #13]);
end;

function TBlaiseLexer.EOF: Boolean;
begin
  Result := FPos >= FSize;
end;

procedure TBlaiseLexer.GetToken;
var I : Integer;
    C : Char;
begin
  I := FPos;
  Repeat
    FLastTokenEnd := I;
    Repeat
      FTokenPos := I;
      if I >= FSize then
        begin
          FTokenLen := 0;
          FTokenType := ttEOF;
          exit;
        end;
      C := FData[I];
      CharProc[C](C);
      I := FPos;
      {$IFDEF LEX_PROFILE}
      Inc(TokenCount);
      Case FTokenType of
        ttIgnore                       : Inc(IgnoreCount);
        ttIdentifier                   : Inc(IdenCount);
        ttSymbol..ttSymbol + $FFFF     : Inc(SymbolCount);
        //ttReservedWord..ttReservedWord + $FFFF : Inc(ReservedCount);
      end;
      {$ENDIF}
    Until (FTokenType <> ttIgnore) and (FTokenType <> ttEOL);
    FTokenLen := I - FTokenPos;
  Until (FTokenType < ttBlockComment1) or (FTokenType > ttLineComment);
end;

function TBlaiseLexer.TokenText: String;
var P : PChar;
    I : Integer;
begin
  I := FTokenLen;
  SetLength(Result, I);
  if I = 0 then
    exit;
  P := FData;
  Inc(P, FPos - FTokenLen);
  MoveMem(P^, Pointer(Result)^, I);
end;

function TBlaiseLexer.RunWith(const C: CharSet): Boolean;
var I, L : Integer;
    P     : PChar;
begin
  I := FPos;
  L := FSize;
  P := @FData[I];
  While (I < L) and (P^ in C) do
    begin
      Inc(I);
      Inc(P);
    end;
  Result := I > FPos;
  FPos := I;
end;

function TBlaiseLexer.RunTo(const C: Char): Boolean;
var I, L : Integer;
    P    : PChar;
begin
  I := FPos;
  L := FSize;
  P := @FData[I];
  While (I < L) and (P^ <> C) do
    begin
      Inc(I);
      Inc(P);
    end;
  Result := I < L;
  FPos := I;
end;

function TBlaiseLexer.RunTo(const C: CharSet): Boolean;
var I, L : Integer;
    P    : PChar;
begin
  I := FPos;
  L := FSize;
  P := @FData[I];
  While (I < L) and not (P^ in C) do
    begin
      Inc(I);
      Inc(P);
    end;
  Result := I < L;
  FPos := I;
end;

function TBlaiseLexer.RunTo(const Delim: String;
    const SkipDelim: Boolean): Boolean;
var I, J, L : Integer;
begin
  I := FPos + 1;
  L := FSize;
  J := PosStr(Delim, FData, I, True);
  Result := J >= 1;
  if not Result then
    FPos := L else
    begin
      Inc(FPos, J - I);
      if SkipDelim then
        Inc(FPos, Length(Delim));
    end;
end;

function TBlaiseLexer.ExtractOne(const C: Char): Boolean;
var I : Integer;
begin
  I := FPos;
  if I >= FSize then
    begin
      Result := False;
      exit;
    end;
  Result := FData[I] = C;
  if Result then
    Inc(FPos);
end;

function TBlaiseLexer.ExtractOne(const C: CharSet): Boolean;
var I : Integer;
begin
  I := FPos;
  if I >= FSize then
    begin
      Result := False;
      exit;
    end;
  Result := FData[I] in C;
  if Result then
    Inc(FPos);
end;

procedure TBlaiseLexer.Char_Ignore(const Ch: Char);
begin
  Assert(Ch in [#0..#32]);
  FTokenType := ttIgnore;
  Inc(FPos);
  RunWith([#0..#9, #11..#12, #14..#32]);
end;

type
  AsciiChar = AnsiChar;

const
 AsciiLowCaseLookup: Array[AsciiChar] of AsciiChar = (
    #$00, #$01, #$02, #$03, #$04, #$05, #$06, #$07,
    #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F,
    #$10, #$11, #$12, #$13, #$14, #$15, #$16, #$17,
    #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F,
    #$20, #$21, #$22, #$23, #$24, #$25, #$26, #$27,
    #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F,
    #$30, #$31, #$32, #$33, #$34, #$35, #$36, #$37,
    #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F,
    #$40, #$61, #$62, #$63, #$64, #$65, #$66, #$67,
    #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
    #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77,
    #$78, #$79, #$7A, #$5B, #$5C, #$5D, #$5E, #$5F,
    #$60, #$61, #$62, #$63, #$64, #$65, #$66, #$67,
    #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
    #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77,
    #$78, #$79, #$7A, #$7B, #$7C, #$7D, #$7E, #$7F,
    #$80, #$81, #$82, #$83, #$84, #$85, #$86, #$87,
    #$88, #$89, #$8A, #$8B, #$8C, #$8D, #$8E, #$8F,
    #$90, #$91, #$92, #$93, #$94, #$95, #$96, #$97,
    #$98, #$99, #$9A, #$9B, #$9C, #$9D, #$9E, #$9F,
    #$A0, #$A1, #$A2, #$A3, #$A4, #$A5, #$A6, #$A7,
    #$A8, #$A9, #$AA, #$AB, #$AC, #$AD, #$AE, #$AF,
    #$B0, #$B1, #$B2, #$B3, #$B4, #$B5, #$B6, #$B7,
    #$B8, #$B9, #$BA, #$BB, #$BC, #$BD, #$BE, #$BF,
    #$C0, #$C1, #$C2, #$C3, #$C4, #$C5, #$C6, #$C7,
    #$C8, #$C9, #$CA, #$CB, #$CC, #$CD, #$CE, #$CF,
    #$D0, #$D1, #$D2, #$D3, #$D4, #$D5, #$D6, #$D7,
    #$D8, #$D9, #$DA, #$DB, #$DC, #$DD, #$DE, #$DF,
    #$E0, #$E1, #$E2, #$E3, #$E4, #$E5, #$E6, #$E7,
    #$E8, #$E9, #$EA, #$EB, #$EC, #$ED, #$EE, #$EF,
    #$F0, #$F1, #$F2, #$F3, #$F4, #$F5, #$F6, #$F7,
    #$F8, #$F9, #$FA, #$FB, #$FC, #$FD, #$FE, #$FF);

procedure TBlaiseLexer.Char_IdentifierStart(const Ch: Char);
var I, J    : Integer;
    P       : PChar;
    D       : Char;
    Hash    : Byte;
    F, G, O : Integer;
    R       : Boolean;
    H       : IntegerArray;
    S       : String;
    V, W    : PChar;
begin
  Assert(Ch in IdentifierStartChar);
  // Calculate hash
  I := FPos;
  P := @FData[I];
  D := P^;
  Hash := 0;
  Repeat
    Hash := Byte(Hash + Ord(AsciiLowCaseLookup[D]));
    Inc(I);
    Inc(P);
    if I > FSize then
      break else
      begin
        D := P^;
        if not (D in IdentifierChars) then
          break;
      end;
  Until False;
  J := I - FPos;
  // Check if reserved word
  H := ReservedHash[Hash];
  For F := 0 to Length(H) - 1 do
    begin
      O := H[F];
      S := ReservedWords[O];
      if Length(S) = J then
        begin
          R := True;
          V := Pointer(S);
          W := @FData[FPos];
          For G := 1 to J do
            if AsciiLowCaseLookup[V^] <> AsciiLowCaseLookup[W^] then
              begin
                R := False;
                break;
              end else begin
                Inc(V);
                Inc(W);
              end;
          if R then
            begin
              // Reserved word
              FTokenType := ttReservedWord + O;
              FPos := I;
              exit;
            end;
        end;
    end;
  // Identifier
  FTokenType := ttIdentifier;
  FPos := I;
end;

procedure TBlaiseLexer.Char_LF(const Ch: Char);
begin
  Assert(Ch = #10);
  Inc(FPos);
  FLastEOL := FPos;
  FTokenType := ttEOL;
  Inc(FLineNr);
end;

procedure TBlaiseLexer.Char_CR(const Ch: Char);
var I : Integer;
begin
  Assert(Ch = #13);
  I := FPos + 1;
  if (I < FSize) and (FData[I] = #10) then
    begin
      Inc(I);
      FPos := I;
      FLastEOL := I;
      FTokenType := ttEOL;
      Inc(FLineNr);
    end
  else
    Char_Ignore(Ch);
end;

procedure TBlaiseLexer.Char_Quote(const Ch: Char);
var P : PChar;
begin
  Assert(Ch = '''');
  FTokenType := ttStringLiteral;
  Inc(FPos);
  Repeat
    if not RunTo([#10, #13, '''']) then
      UnterminatedStringError;
    P := @FData[FPos];
    if P^ <> '''' then
      UnterminatedStringError;
    if (FPos >= FSize - 1) or (P[1] <> Ch) then
      begin
        Inc(FPos);
        exit;
      end else
      Inc(FPos, 2);
  Until False;
end;

procedure TBlaiseLexer.Char_OpenCurly(const Ch: Char);
begin
  Assert(Ch = '{');
  Inc(FPos);
  Repeat
    if not RunTo([#10, #13, '}']) then
      UnterminatedCommentError;
    Case FData[FPos] of
      '}' : begin
              Inc(FPos);
              FTokenType := ttBlockComment1;
              exit;
            end;
      #10 : Char_LF(#10);
      #13 : Char_CR(#13);
    end;
  Until False;
end;

procedure TBlaiseLexer.Char_OpenRound(const Ch: Char);
begin
  Assert(Ch = '(');
  Inc(FPos);
  if not ExtractOne('*') then
    begin
      FTokenType := ttOpenBracket;
      exit;
    end;
  Repeat
    if not RunTo([#10, #13, '*']) then
      UnterminatedCommentError;
    Case FData[FPos] of
      '*' : begin
              Inc(FPos);
              if ExtractOne(')') then
                begin
                  FTokenType := ttBlockComment2;
                  exit;
                end;
            end;
      #10 : Char_LF(#10);
      #13 : Char_CR(#13);
    end;
  Until False;
end;

procedure TBlaiseLexer.Char_Slash(const Ch: Char);
var I : Integer;
    P : PChar;
begin
  Assert(Ch = '/');
  Inc(FPos);
  if not ExtractOne('/') then
    begin
      FTokenType := ttDivide;
      exit;
    end;
  Repeat
    if not RunTo([#10, #13]) then
      break;
    I := FPos;
    P := @FData[I];
    Case P^ of
      #10 : break;
      #13 : if (I + 1 < FSize) and (P[1] = #10) then
              break;
    end;
    Inc(FPos);
  Until False;
  FTokenType := ttLineComment;
end;

procedure TBlaiseLexer.Char_Colon(const Ch: Char);
begin
  Assert(Ch = ':');
  Inc(FPos);
  if ExtractOne('=') then
    FTokenType := ttAssignment
  else
    FTokenType := ttColon;
end;

procedure TBlaiseLexer.Char_Dot(const Ch: Char);
begin
  Assert(Ch = '.');
  Inc(FPos);
  if not ExtractOne('.') then
    FTokenType := ttDot else
  if not ExtractOne('.') then
    FTokenType := ttDotDot
  else
    FTokenType := ttDotDotDot;
end;

procedure TBlaiseLexer.Char_Asterisk(const Ch: Char);
begin
  Assert(Ch = '*');
  Inc(FPos);
  if ExtractOne('*') then
    FTokenType := ttPower
  else
    FTokenType := ttMultiply;
end;

procedure TBlaiseLexer.Char_LessThan(const Ch: Char);
begin
  Assert(Ch = '<');
  Inc(FPos);
  if ExtractOne('>') then
    FTokenType := ttNotEqual else
  if ExtractOne('=') then
    FTokenType := ttLessOrEqual
  else
    FTokenType := ttLess;
end;

procedure TBlaiseLexer.Char_GreaterThan(const Ch: Char);
begin
  Assert(Ch = '>');
  Inc(FPos);
  if ExtractOne('=') then
    FTokenType := ttGreaterOrEqual
  else
    FTokenType := ttGreater;
end;

const csNumeric         = ['0'..'9'];
      csHexDigit        = csNumeric + ['A'..'F', 'a'..'f'];
      csBinaryDigit     = ['0'..'1'];

procedure TBlaiseLexer.Char_Number(const Ch: Char);
begin
  Assert(Ch in csNumeric);
  Inc(FPos);
  // Hex and Binary
  if (Ch = '0') and (FPos < FSize) then
    Case FData[FPos] of
      'x', 'X' :
        begin
          Inc(FPos);
          if not RunWith(csHexDigit) then
            LexError('Hexadecimal value expected');
          FTokenType := ttHexNumber;
          exit;
        end;
      'b', 'B' :
        begin
          Inc(FPos);
          if not RunWith(csBinaryDigit) then
            LexError('Binary value expected');
          FTokenType := ttBinaryNumber;
          exit;
        end;
    end;
  // Number
  FTokenType := ttNumber;
  RunWith(csNumeric);
  // Real
  if ExtractOne('.') then
    if RunWith(csNumeric) then
      FTokenType := ttRealNumber
    else
      Dec(FPos);
  // SciReal
  if ExtractOne(['E', 'e']) then
    begin
      ExtractOne(['+', '-']);
      if RunWith(csNumeric) then
        FTokenType := ttSciRealNumber
      else
        LexError('Numeric value expected');
    end;
  // Complex
  if ExtractOne(['i', 'I']) then
    FTokenType := ttComplexNumber;
end;

procedure TBlaiseLexer.Char_Dollar(const Ch: Char);
begin
  Assert(Ch = '$');
  Inc(FPos);
  if RunWith(csHexDigit) then
    FTokenType := ttHexNumber2
  else
    LexError('Hexadecimal value expected');
end;

procedure TBlaiseLexer.Char_SingleCharToken(const Ch: Char);
begin
  Case Ch of
    ';' : FTokenType := ttStatementDelim;
    '[' : FTokenType := ttOpenBlockBracket;
    ']' : FTokenType := ttCloseBlockBracket;
    '?' : FTokenType := ttQuestionMark;
    ',' : FTokenType := ttComma;
    ')' : FTokenType := ttCloseBracket;
    '!' : FTokenType := ttExclamationMark;
    '^' : FTokenType := ttCaret;
    '\' : FTokenType := ttBackSlash;
    '=' : FTokenType := ttEqual;
    '+' : FTokenType := ttPlus;
    '-' : FTokenType := ttMinus;
    '/' : FTokenType := ttDivide;
    '#' : FTokenType := ttHash;
  end;
  Inc(FPos);
end;

procedure TBlaiseLexer.Char_Unknown(const Ch: Char);
var S: String;
begin
  FTokenType := ttInvalid;
  if Ch in [#33..#127] then
    S := Ch else
    S := '#' + IntToStr(Ord(Ch));
  LexError('Invalid character: ' + S);
end;

function TBlaiseLexer.MatchType(const TokenType: Integer;
    const Skip: Boolean): Boolean;
begin
  Result := TokenType = FTokenType;
  if Result and Skip then
    GetToken;
end;

function StrZMatchStr(const P: PChar; const M: String): Boolean;
var T, Q : PChar;
    I, L : Integer;
    C    : Char;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if (C = #0) or (C <> Q^) then begin
          Result := False;
          exit;
        end else begin
          Inc(T);
          Inc(Q);
        end;
    end;
  Result := True;
end;

function TBlaiseLexer.MatchTokenText(const Token: String; const Skip: Boolean;
    const CaseSensitive: Boolean): Boolean;
var P : PChar;
begin
  if FTokenLen <> Length(Token) then
    Result := False
  else
    begin
      P := Pointer(FData);
      Inc(P, FTokenPos);
      Result := StrZMatchStr(P, Token);
      if Result and Skip then
        GetToken;
    end;
end;

{$WARNINGS OFF}
function TBlaiseLexer.TokenAsInteger: Int64;
var R : Boolean;
begin
  R := True;
  try
    Case FTokenType of
      ttNumber,
      ttHexNumber2   : Result := StrToInt64(TokenText);
      ttHexNumber    : Result := StrToInt64('$' + Copy(TokenText, 3, FTokenLen - 2));
      ttBinaryNumber : Result := BinToLongWord(Copy(TokenText, 3, FTokenLen - 2));
    else
      R := False;
    end;
  except
    LexError('Invalid integer value');
  end;
  if not R then
    LexError('Integer value expected');
end;
{$WARNINGS ON}



end.

