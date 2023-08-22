{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit Character;

interface

uses RTLConsts, SysUtils;

{$SCOPEDENUMS ON}

type
  TUnicodeCategory = (
    ucControl,
    ucFormat,
    ucUnassigned,
    ucPrivateUse,
    ucSurrogate,
    ucLowercaseLetter,
    ucModifierLetter,
    ucOtherLetter,
    ucTitlecaseLetter,
    ucUppercaseLetter,
    ucCombiningMark,
    ucEnclosingMark,
    ucNonSpacingMark,
    ucDecimalNumber,
    ucLetterNumber,
    ucOtherNumber,
    ucConnectPunctuation,
    ucDashPunctuation,
    ucClosePunctuation,
    ucFinalPunctuation,
    ucInitialPunctuation,
    ucOtherPunctuation,
    ucOpenPunctuation,
    ucCurrencySymbol,
    ucModifierSymbol,
    ucMathSymbol,
    ucOtherSymbol,
    ucLineSeparator,
    ucParagraphSeparator,
    ucSpaceSeparator
  );

  TUnicodeBreak = (
    ubMandatory,
    ubCarriageReturn,
    ubLineFeed,
    ubCombiningMark,
    ubSurrogate,
    ubZeroWidthSpace,
    ubInseparable,
    ubNonBreakingGlue,
    ubContingent,
    ubSpace,
    ubAfter,
    ubBefore,
    ubBeforeAndAfter,
    ubHyphen,
    ubNonStarter,
    ubOpenPunctuation,
    ubClosePunctuation,
    ubQuotation,
    ubExclamation,
    ubIdeographic,
    ubNumeric,
    ubInfixSeparator,
    ubSymbol,
    ubAlphabetic,
    ubPrefix,
    ubPostfix,
    ubComplexContext,
    ubAmbiguous,
    ubUnknown,
    ubNextLine,
    ubWordJoiner,
    ubHangulLJamo,
    ubHangulVJamo,
    ubHangulTJamo,
    ubHangulLvSyllable,
    ubHangulLvtSyllable
  );

type
  TCharacter = class sealed
  private
    class procedure Initialize; static;
    class function IsLatin1(C: Char): Boolean; inline; static;
    class function IsAscii(C: Char): Boolean; inline; static;
    class function CheckLetter(uc: TUnicodeCategory): Boolean; inline; static;
    class function CheckLetterOrDigit(uc: TUnicodeCategory): Boolean; inline; static;
    class function CheckNumber(uc: TUnicodeCategory): Boolean; inline; static;
    class function CheckPunctuation(uc: TUnicodeCategory): Boolean; inline; static;
    class function CheckSymbol(uc: TUnicodeCategory): Boolean; inline; static;
    class function CheckSeparator(uc: TUnicodeCategory): Boolean; inline; static;
  public
    constructor Create;
    class function ConvertFromUtf32(C: UCS4Char): string; static;
    class function ConvertToUtf32(const S: string; Index: Integer): UCS4Char; overload; inline; static;
    class function ConvertToUtf32(const S: string; Index: Integer; out CharLength: Integer): UCS4Char; overload; static;
    class function ConvertToUtf32(const HighSurrogate, LowSurrogate: Char): UCS4Char; overload; static;
    class function GetNumericValue(C: Char): Double; overload; static;
    class function GetNumericValue(const S: string; Index: Integer): Double; overload; static;
    class function GetUnicodeCategory(C: Char): TUnicodeCategory; overload; static;
    class function GetUnicodeCategory(const S: string; Index: Integer): TUnicodeCategory; overload; static;
    class function IsControl(C: Char): Boolean; overload; static;
    class function IsControl(const S: string; Index: Integer): Boolean; overload; static;
    class function IsDigit(C: Char): Boolean; overload; static;
    class function IsDigit(const S: string; Index: Integer): Boolean; overload; static;
    class function IsHighSurrogate(C: Char): Boolean; overload; inline; static;
    class function IsHighSurrogate(const S: string; Index: Integer): Boolean; overload; inline; static;
    class function IsLetter(C: Char): Boolean; overload; static;
    class function IsLetter(const S: string; Index: Integer): Boolean; overload; static;
    class function IsLetterOrDigit(C: Char): Boolean; overload; static;
    class function IsLetterOrDigit(const S: string; Index: Integer): Boolean; overload; static;
    class function IsLower(C: Char): Boolean; overload; static;
    class function IsLower(const S: string; Index: Integer): Boolean; overload; static;
    class function IsLowSurrogate(C: Char): Boolean; overload; inline; static;
    class function IsLowSurrogate(const S: string; Index: Integer): Boolean; overload; inline; static;
    class function IsNumber(C: Char): Boolean; overload; static;
    class function IsNumber(const S: string; Index: Integer): Boolean; overload; static;
    class function IsPunctuation(C: Char): Boolean; overload; static;
    class function IsPunctuation(const S: string; Index: Integer): Boolean; overload; static;
    class function IsSeparator(C: Char): Boolean; overload; static;
    class function IsSeparator(const S: string; Index: Integer): Boolean; overload; static;
    class function IsSurrogate(Surrogate: Char): Boolean; overload; inline; static;
    class function IsSurrogate(const S: string; Index: Integer): Boolean; overload; static;
    class function IsSurrogatePair(const HighSurrogate, LowSurrogate: Char): Boolean; overload; inline; static;
    class function IsSurrogatePair(const S: string; Index: Integer): Boolean; overload; static;
    class function IsSymbol(C: Char): Boolean; overload; static;
    class function IsSymbol(const S: string; Index: Integer): Boolean; overload; static;
    class function IsUpper(C: Char): Boolean; overload; static;
    class function IsUpper(const S: string; Index: Integer): Boolean; overload; static;
    class function IsWhiteSpace(C: Char): Boolean; overload; static;
    class function IsWhiteSpace(const S: string; Index: Integer): Boolean; overload; static;
    class function ToLower(C: Char): Char; overload; static;
    class function ToLower(const S: string): string; overload; static;
    class function ToUpper(C: Char): Char; overload; static;
    class function ToUpper(const S: string): string; overload; static;
  end;

function ConvertFromUtf32(C: UCS4Char): string; inline;
function ConvertToUtf32(const S: string; Index: Integer): UCS4Char; overload; inline;
function ConvertToUtf32(const S: string; Index: Integer; out CharLength: Integer): UCS4Char; overload; inline;
function ConvertToUtf32(const HighSurrogate, LowSurrogate: Char): UCS4Char; overload; inline;
function GetNumericValue(C: Char): Double; overload; inline;
function GetNumericValue(const S: string; Index: Integer): Double; overload; inline;
function GetUnicodeCategory(C: Char): TUnicodeCategory; overload; inline;
function GetUnicodeCategory(const S: string; Index: Integer): TUnicodeCategory; overload; inline;
function IsControl(C: Char): Boolean; overload; inline;
function IsControl(const S: string; Index: Integer): Boolean; overload; inline;
function IsDigit(C: Char): Boolean; overload; inline;
function IsDigit(const S: string; Index: Integer): Boolean; overload; inline;
function IsHighSurrogate(C: Char): Boolean; overload; inline;
function IsHighSurrogate(const S: string; Index: Integer): Boolean; overload; inline;
function IsLetter(C: Char): Boolean; overload; inline;
function IsLetter(const S: string; Index: Integer): Boolean; overload; inline;
function IsLetterOrDigit(C: Char): Boolean; overload; inline;
function IsLetterOrDigit(const S: string; Index: Integer): Boolean; overload; inline;
function IsLower(C: Char): Boolean; overload; inline;
function IsLower(const S: string; Index: Integer): Boolean; overload; inline;
function IsLowSurrogate(C: Char): Boolean; overload; inline;
function IsLowSurrogate(const S: string; Index: Integer): Boolean; overload; inline;
function IsNumber(C: Char): Boolean; overload; inline;
function IsNumber(const S: string; Index: Integer): Boolean; overload; inline;
function IsPunctuation(C: Char): Boolean; overload; inline;
function IsPunctuation(const S: string; Index: Integer): Boolean; overload; inline;
function IsSeparator(C: Char): Boolean; overload; inline;
function IsSeparator(const S: string; Index: Integer): Boolean; overload; inline;
function IsSurrogate(Surrogate: Char): Boolean; overload; inline;
function IsSurrogate(const S: string; Index: Integer): Boolean; overload; inline;
function IsSurrogatePair(const HighSurrogate, LowSurrogate: Char): Boolean; overload; inline;
function IsSurrogatePair(const S: string; Index: Integer): Boolean; overload; inline;
function IsSymbol(C: Char): Boolean; overload; inline;
function IsSymbol(const S: string; Index: Integer): Boolean; overload; inline;
function IsUpper(C: Char): Boolean; overload; inline;
function IsUpper(const S: string; Index: Integer): Boolean; overload; inline;
function IsWhiteSpace(C: Char): Boolean; overload; inline;
function IsWhiteSpace(const S: string; Index: Integer): Boolean; overload; inline;
function ToLower(C: Char): Char; overload; inline;
function ToLower(const S: string): string; overload; inline;
function ToUpper(C: Char): Char; overload; inline;
function ToUpper(const S: string): string; overload; inline;

implementation

uses Windows;

{$RESOURCE 'character.res'}

type
  TIndexArray = array[0..32767] of Word;
  PIndexArray = ^TIndexArray;
  TCategoryArray = array[0..65535] of TUnicodeCategory;
  PCategoryArray = ^TCategoryArray;
  TNumberArray = array[0..4095] of Double;
  PNumberArray = ^TNumberArray;
  PDataTableOffsets = ^TDataTableOffsets;
  TDataTableOffsets = record
    IndexTable1Offset: Integer;
    IndexTable2Offset: Integer;
    DataTableOffset: Integer;
    NumberIndex1Offset: Integer;
    NumberIndex2Offset: Integer;
    NumberDataOffset: Integer;
  end;

var
  DataTable: Pointer;
  CatIndexPrimary: PIndexArray;
  CatIndexSecondary: PIndexArray;
  CategoryTable: PCategoryArray;
  NumIndexPrimary: PIndexArray;
  NumIndexSecondary: PIndexArray;
  NumericValueTable: PNumberArray;

{ TCharacter }

function InternalGetUnicodeCategory(C: UCS4Char): TUnicodeCategory; inline;
begin
  if CategoryTable = nil then
    TCharacter.Initialize;
  Result := CategoryTable[CatIndexSecondary[CatIndexPrimary[C shr 8] + ((C shr 4) and $F)] + C and $F];
end;

function NumberValue(C: UCS4Char): Double; inline;
begin
  if NumericValueTable = nil then
    TCharacter.Initialize;
  Result := NumericValueTable[NumIndexSecondary[NumIndexPrimary[C shr 8] + ((C shr 4) and $F)] + C and $F];
end;

const
  Latin1Categories: array[0..255] of TUnicodeCategory =
    ( { page 0 }
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucSpaceSeparator, TUnicodeCategory.ucOtherPunctuation,
      TUnicodeCategory.ucOtherPunctuation,
      TUnicodeCategory.ucOtherPunctuation, TUnicodeCategory.ucCurrencySymbol,
      TUnicodeCategory.ucOtherPunctuation,
      TUnicodeCategory.ucOtherPunctuation,
      TUnicodeCategory.ucOtherPunctuation,
      TUnicodeCategory.ucOpenPunctuation,
      TUnicodeCategory.ucClosePunctuation,
      TUnicodeCategory.ucOtherPunctuation, TUnicodeCategory.ucMathSymbol,
      TUnicodeCategory.ucOtherPunctuation,
      TUnicodeCategory.ucDashPunctuation,
      TUnicodeCategory.ucOtherPunctuation,
      TUnicodeCategory.ucOtherPunctuation, TUnicodeCategory.ucDecimalNumber,
      TUnicodeCategory.ucDecimalNumber, TUnicodeCategory.ucDecimalNumber, 
      TUnicodeCategory.ucDecimalNumber, TUnicodeCategory.ucDecimalNumber, 
      TUnicodeCategory.ucDecimalNumber, TUnicodeCategory.ucDecimalNumber, 
      TUnicodeCategory.ucDecimalNumber, TUnicodeCategory.ucDecimalNumber, 
      TUnicodeCategory.ucDecimalNumber, TUnicodeCategory.ucOtherPunctuation, 
      TUnicodeCategory.ucOtherPunctuation, TUnicodeCategory.ucMathSymbol, 
      TUnicodeCategory.ucMathSymbol, TUnicodeCategory.ucMathSymbol, 
      TUnicodeCategory.ucOtherPunctuation, 
      TUnicodeCategory.ucOtherPunctuation, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter, 
      TUnicodeCategory.ucOpenPunctuation, 
      TUnicodeCategory.ucOtherPunctuation, 
      TUnicodeCategory.ucClosePunctuation, TUnicodeCategory.ucModifierSymbol,
      TUnicodeCategory.ucConnectPunctuation, 
      TUnicodeCategory.ucModifierSymbol, TUnicodeCategory.ucLowercaseLetter, 
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter, 
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter, 
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter, 
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter, 
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter, 
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter, 
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter, 
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter, 
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter, 
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucOpenPunctuation,
      TUnicodeCategory.ucMathSymbol, TUnicodeCategory.ucClosePunctuation,
      TUnicodeCategory.ucMathSymbol, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucControl, TUnicodeCategory.ucControl,
      TUnicodeCategory.ucSpaceSeparator, TUnicodeCategory.ucOtherPunctuation,
      TUnicodeCategory.ucCurrencySymbol, TUnicodeCategory.ucCurrencySymbol,
      TUnicodeCategory.ucCurrencySymbol, TUnicodeCategory.ucCurrencySymbol,
      TUnicodeCategory.ucOtherSymbol, TUnicodeCategory.ucOtherSymbol,
      TUnicodeCategory.ucModifierSymbol, TUnicodeCategory.ucOtherSymbol,
      TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucInitialPunctuation, TUnicodeCategory.ucMathSymbol,
      TUnicodeCategory.ucDashPunctuation, TUnicodeCategory.ucOtherSymbol,
      TUnicodeCategory.ucModifierSymbol, TUnicodeCategory.ucOtherSymbol,
      TUnicodeCategory.ucMathSymbol, TUnicodeCategory.ucOtherNumber,
      TUnicodeCategory.ucOtherNumber, TUnicodeCategory.ucModifierSymbol,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucOtherSymbol,
      TUnicodeCategory.ucOtherPunctuation, TUnicodeCategory.ucModifierSymbol,
      TUnicodeCategory.ucOtherNumber, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucFinalPunctuation, TUnicodeCategory.ucOtherNumber,
      TUnicodeCategory.ucOtherNumber, TUnicodeCategory.ucOtherNumber,
      TUnicodeCategory.ucOtherPunctuation,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucMathSymbol,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucUppercaseLetter,
      TUnicodeCategory.ucUppercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucMathSymbol,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter,
      TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucLowercaseLetter
    );

function InternalGetLatin1Category(C: Char): TUnicodeCategory; inline;
begin
  Result := Latin1Categories[Byte(C)];
end;

procedure CheckStringRange(const S: string; Index: Integer); inline;
begin
  if (Index > Length(S)) or (Index < 1) then
    raise EArgumentOutOfRangeException.CreateResFmt(@sArgumentOutOfRange_StringIndex, [Index, Length(S)]);
end;

class function TCharacter.CheckLetter(uc: TUnicodeCategory): Boolean;
begin
  case uc of
    TUnicodeCategory.ucUppercaseLetter,
    TUnicodeCategory.ucLowercaseLetter,
    TUnicodeCategory.ucTitlecaseLetter,
    TUnicodeCategory.ucModifierLetter,
    TUnicodeCategory.ucOtherLetter: Result := True;
  else
    Result := False;
  end;
end;

class function TCharacter.CheckLetterOrDigit(uc: TUnicodeCategory): Boolean;
begin
  case uc of
    TUnicodeCategory.ucUppercaseLetter,
    TUnicodeCategory.ucLowercaseLetter,
    TUnicodeCategory.ucTitlecaseLetter,
    TUnicodeCategory.ucModifierLetter,
    TUnicodeCategory.ucOtherLetter,
    TUnicodeCategory.ucDecimalNumber: Result := True;
  else
    Result := False;
  end;
end;

class function TCharacter.CheckNumber(uc: TUnicodeCategory): Boolean;
begin
  case uc of
    TUnicodeCategory.ucOtherNumber,
    TUnicodeCategory.ucLetterNumber,
    TUnicodeCategory.ucDecimalNumber: Result := True;
  else
    Result := False;
  end;
end;

class function TCharacter.CheckPunctuation(uc: TUnicodeCategory): Boolean;
begin
  case uc of
    TUnicodeCategory.ucConnectPunctuation,
    TUnicodeCategory.ucDashPunctuation,
    TUnicodeCategory.ucClosePunctuation,
    TUnicodeCategory.ucFinalPunctuation,
    TUnicodeCategory.ucInitialPunctuation,
    TUnicodeCategory.ucOtherPunctuation,
    TUnicodeCategory.ucOpenPunctuation: Result := True;
  else
    Result := False;
  end;
end;

class function TCharacter.CheckSeparator(uc: TUnicodeCategory): Boolean;
begin
  case uc of
    TUnicodeCategory.ucLineSeparator,
    TUnicodeCategory.ucParagraphSeparator,
    TUnicodeCategory.ucSpaceSeparator: Result := True;
  else
    Result := False;
  end;
end;

class function TCharacter.CheckSymbol(uc: TUnicodeCategory): Boolean;
begin
  case uc of
    TUnicodeCategory.ucCurrencySymbol,
    TUnicodeCategory.ucModifierSymbol,
    TUnicodeCategory.ucMathSymbol,
    TUnicodeCategory.ucOtherSymbol: Result := True;
  else
    Result := False;
  end;
end;

class function TCharacter.IsLatin1(C: Char): Boolean;
begin
  Result := Integer(C) <= $FF;
end;

class function TCharacter.IsLetter(C: Char): Boolean;
begin
  if not IsLatin1(C) then
    Result := CheckLetter(InternalGetUnicodeCategory(UCS4Char(C)))
  else if not IsAscii(C) then
    Result := CheckLetter(InternalGetLatin1Category(C))
  else
  begin
    C := Char(Integer(C) or Ord(' '));
    Result := (C >= 'a') and (C <= 'z');
  end;
end;

class function TCharacter.IsLetter(const S: string; Index: Integer): Boolean;
begin
  CheckStringRange(S, Index);
  Result := IsLetter(S[Index]);
end;

class function TCharacter.IsLetterOrDigit(const S: string; Index: Integer): Boolean;
var
  C: Char;
begin
  CheckStringRange(S, Index);
  C := S[Index];
  if IsLatin1(C) then
    Result := CheckLetterOrDigit(InternalGetLatin1Category(C))
  else
    Result := CheckLetterOrDigit(GetUnicodeCategory(S, Index));
end;

class function TCharacter.IsLetterOrDigit(C: Char): Boolean;
begin
  if IsLatin1(C) then
    Result := CheckLetterOrDigit(InternalGetLatin1Category(C))
  else
    Result := CheckLetterOrDigit(InternalGetUnicodeCategory(UCS4Char(C)));
end;

class function TCharacter.IsAscii(C: Char): Boolean;
begin
  Result := Integer(C) <= $7F;
end;

class function TCharacter.IsControl(const S: string; Index: Integer): Boolean;
var
  C: Char;
begin
  CheckStringRange(S, Index);
  C := S[Index];
  if IsLatin1(C) then
    Result := InternalGetLatin1Category(C) = TUnicodeCategory.ucControl
  else
    Result := GetUnicodeCategory(S, Index) = TUnicodeCategory.ucControl;
end;

class function TCharacter.IsControl(C: Char): Boolean;
begin
  if IsLatin1(C) then
    Result := InternalGetLatin1Category(C) = TUnicodeCategory.ucControl
  else
    Result := InternalGetUnicodeCategory(UCS4Char(C)) = TUnicodeCategory.ucControl;
end;

class function TCharacter.IsDigit(C: Char): Boolean;
begin
  if not IsLatin1(C) then
    Result := InternalGetUnicodeCategory(UCS4Char(C)) = TUnicodeCategory.ucDecimalNumber
  else
    Result := (C >= '0') and (C <= '9');
end;

class function TCharacter.IsDigit(const S: string; Index: Integer): Boolean;
var
  C: Char;
begin
  CheckStringRange(S, Index);
  C := S[Index];
  if not IsLatin1(C) then
    Result := GetUnicodeCategory(S, Index) = TUnicodeCategory.ucDecimalNumber
  else
    Result := (C >= '0') and (C <= '9');
end;

class function TCharacter.IsHighSurrogate(C: Char): Boolean;
begin
  Result := (Integer(C) >= $D800) and (Integer(C) <= $DBFF);
end;

class function TCharacter.IsLowSurrogate(C: Char): Boolean;
begin
  Result := (Integer(C) >= $DC00) and (Integer(C) <= $DFFF);
end;

class function TCharacter.IsSurrogate(Surrogate: Char): Boolean;
begin
  Result := (Integer(Surrogate) >= $D800) and (Integer(Surrogate) <= $DFFF);
end;

class function TCharacter.IsSurrogatePair(const HighSurrogate, LowSurrogate: Char): Boolean;
begin
  Result := (Integer(HighSurrogate) >= $D800) and (Integer(HighSurrogate) <= $DBFF) and
    (Integer(LowSurrogate) >= $DC00) and (Integer(LowSurrogate) <= $DFFF);
end;

class function TCharacter.GetUnicodeCategory(C: Char): TUnicodeCategory;
begin
  if IsLatin1(C) then
    Result := InternalGetLatin1Category(C)
  else
    Result := InternalGetUnicodeCategory(UCS4Char(C));
end;

class function TCharacter.ConvertToUtf32(const S: string; Index: Integer; out CharLength: Integer): UCS4Char;
var
  LowSurrogate, HighSurrogate: Integer;
begin
  CheckStringRange(S, Index);
  CharLength := 1;
  HighSurrogate := Integer(S[Index]) - $D800;
  if (HighSurrogate < 0) or (HighSurrogate > $7FF) then
    Result := UCS4Char(S[Index])
  else
  begin
    if HighSurrogate > $3FF then
      raise EArgumentException.CreateResFmt(@sArgument_InvalidLowSurrogate, [Index]);
    if Index > Length(S) - 1 then
      raise EArgumentException.CreateResFmt(@sArgument_InvalidHighSurrogate, [Index]);
    LowSurrogate := Integer(S[Index + 1]) - $DC00;
    if (LowSurrogate < 0) or (LowSurrogate > $3FF) then
      raise EArgumentException.CreateResFmt(@sArgument_InvalidHighSurrogate, [Index]);
    Inc(CharLength);
    Result := (HighSurrogate * $400) + LowSurrogate + $10000;
  end;
end;

class function TCharacter.ConvertToUtf32(const S: string; Index: Integer): UCS4Char;
var
  CharLength: Integer;
begin
  Result := ConvertToUtf32(S, Index, CharLength);
end;

class function TCharacter.ConvertFromUtf32(C: UCS4Char): string;
begin
  if (C > $10FFFF) or ((C >= $D800) and (C <= $DFFF)) then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange_InvalidUTF32);
  if C < $10000 then
    Result := Char(C)
  else
  begin
    Dec(C, $10000);
    Result := Char(C div $400 + $D800) + Char(C mod $400 + $DC00);
  end;
end;

class function TCharacter.ConvertToUtf32(const HighSurrogate, LowSurrogate: Char): UCS4Char;
begin
  if not IsHighSurrogate(HighSurrogate) then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange_InvalidHighSurrogate);
  if not IsLowSurrogate(LowSurrogate) then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange_InvalidLowSurrogate);
  Result := ((Integer(HighSurrogate) - $D800) * $400) + (Integer(LowSurrogate) - $DC00) + $10000;
end;

constructor TCharacter.Create;
begin
  raise ENoConstructException.CreateResFmt(@sNoConstruct, [ClassName]);
end;

class procedure TCharacter.Initialize;
var
  Res: HRSRC;
  ResData: HGLOBAL;
  Offsets: PDataTableOffsets;
begin
  Res := FindResource(HInstance, PChar('CHARTABLE'), RT_RCDATA);
  if Res = 0 then
    RaiseLastOSError;
  ResData := LoadResource(HInstance, Res);
  if ResData = 0 then
    RaiseLastOSError;
  DataTable := LockResource(ResData);
  if DataTable = nil then
    RaiseLastOSError;
  Offsets := DataTable;
  CatIndexPrimary := Pointer(Integer(DataTable) + Offsets.IndexTable1Offset);
  CatIndexSecondary := Pointer(Integer(DataTable) + Offsets.IndexTable2Offset);
  CategoryTable := Pointer(Integer(DataTable) + Offsets.DataTableOffset);
  NumIndexPrimary := Pointer(Integer(DataTable) + Offsets.NumberIndex1Offset);
  NumIndexSecondary := Pointer(Integer(DataTable) + Offsets.NumberIndex2Offset);
  NumericValueTable := Pointer(Integer(DataTable) + Offsets.NumberDataOffset);
end;

class function TCharacter.GetNumericValue(C: Char): Double;
begin
  Result := NumberValue(UCS4Char(C)); 
end;

class function TCharacter.GetNumericValue(const S: string; Index: Integer): Double;
begin
  Result := NumberValue(ConvertToUTF32(S, Index));
end;

class function TCharacter.GetUnicodeCategory(const S: string; Index: Integer): TUnicodeCategory;
begin
  CheckStringRange(S, Index);
  if IsLatin1(S[Index]) then
    Result := InternalGetLatin1Category(S[Index])
  else
    Result := InternalGetUnicodeCategory(ConvertToUtf32(S, Index));
end;

class function TCharacter.IsHighSurrogate(const S: string; Index: Integer): Boolean;
begin
  CheckStringRange(S, Index);
  Result := IsHighSurrogate(S[Index]);
end;

class function TCharacter.IsLower(C: Char): Boolean;
begin
  if not IsLatin1(C) then
    Result := InternalGetUnicodeCategory(UCS4Char(C)) = TUnicodeCategory.ucLowercaseLetter
  else if not IsAscii(C) then
    Result := InternalGetLatin1Category(C) = TUnicodeCategory.ucLowercaseLetter
  else
    Result := (C >= 'a') and (C <= 'z');
end;

class function TCharacter.IsLower(const S: string; Index: Integer): Boolean;
var
  C: Char;
begin
  CheckStringRange(S, Index);
  C := S[Index];
  if not IsLatin1(C) then
    Result := GetUnicodeCategory(S, Index) = TUnicodeCategory.ucLowercaseLetter
  else if not IsAscii(C) then
    Result := InternalGetLatin1Category(C) = TUnicodeCategory.ucLowercaseLetter
  else
    Result := (C >= 'a') and (C <= 'z');
end;

class function TCharacter.IsLowSurrogate(const S: string; Index: Integer): Boolean;
begin
  CheckStringRange(S, Index);
  Result := IsLowSurrogate(S[Index]);
end;

class function TCharacter.IsNumber(C: Char): Boolean;
begin
  if not IsLatin1(C) then
    Result := CheckNumber(InternalGetUnicodeCategory(UCS4Char(C)))
  else if not IsAscii(C) then
    Result := CheckNumber(InternalGetLatin1Category(C))
  else
    Result := (C >= '0') and (C <= '9');
end;

class function TCharacter.IsNumber(const S: string; Index: Integer): Boolean;
var
  C: Char;
begin
  CheckStringRange(S, Index);
  C := S[Index];
  if not IsLatin1(C) then
    Result := CheckNumber(GetUnicodeCategory(S, Index))
  else if not IsAscii(C) then
    Result := CheckNumber(InternalGetLatin1Category(C))
  else
    Result := (C >= '0') and (C <= '9');
end;

class function TCharacter.IsPunctuation(const S: string; Index: Integer): Boolean;
var
  C: Char;
begin
  CheckStringRange(S, Index);
  C := S[Index];
  if IsLatin1(C) then
    Result := CheckPunctuation(InternalGetLatin1Category(C))
  else
    Result := CheckPunctuation(GetUnicodeCategory(S, Index));
end;

class function TCharacter.IsPunctuation(C: Char): Boolean;
begin
  if IsLatin1(C) then
    Result := CheckPunctuation(InternalGetLatin1Category(C))
  else
    Result := CheckPunctuation(InternalGetUnicodeCategory(UCS4Char(C)));
end;

class function TCharacter.IsSeparator(C: Char): Boolean;
begin
  if not IsLatin1(C) then
    Result := CheckSeparator(InternalGetUnicodeCategory(UCS4Char(C)))
  else
    {$IFDEF UNICODE}
    Result := (C = ' ') or (C = Char($A0));
    {$ELSE}
    Result := (C = ' ');
    {$ENDIF}
end;

class function TCharacter.IsSeparator(const S: string; Index: Integer): Boolean;
var
  C: Char;
begin
  CheckStringRange(S, Index);
  C := S[Index];
  if not IsLatin1(C) then
    Result := CheckSeparator(GetUnicodeCategory(S, Index))
  else
    {$IFDEF UNICODE}
    Result := (C = ' ') or (C = Char($A0));
    {$ELSE}
    Result := (C = ' ');
    {$ENDIF}
end;

class function TCharacter.IsSurrogate(const S: string; Index: Integer): Boolean;
begin
  CheckStringRange(S, Index);
  Result := IsSurrogate(S[Index]);
end;

class function TCharacter.IsSurrogatePair(const S: string; Index: Integer): Boolean;
begin
  CheckStringRange(S, Index);
  Result := (Index < Length(S)) and IsSurrogatePair(S[Index], S[Index + 1]);
end;

class function TCharacter.IsSymbol(C: Char): Boolean;
begin
  if IsLatin1(C) then
    Result := CheckSymbol(InternalGetLatin1Category(C))
  else
    Result := CheckSymbol(InternalGetUnicodeCategory(UCS4Char(C)));
end;

class function TCharacter.IsSymbol(const S: string; Index: Integer): Boolean;
var
  C: Char;
begin
  CheckStringRange(S, Index);
  C := S[Index];
  if IsLatin1(C) then
    Result := CheckSymbol(InternalGetLatin1Category(C))
  else
    Result := CheckSymbol(GetUnicodeCategory(S, Index));
end;

class function TCharacter.IsUpper(const S: string; Index: Integer): Boolean;
var
  C: Char;
begin
  CheckStringRange(S, Index);
  C := S[Index];
  if not IsLatin1(C) then
    Result := GetUnicodeCategory(S, Index) = TUnicodeCategory.ucUppercaseLetter
  else if not IsAscii(C) then
    Result := InternalGetLatin1Category(C) = TUnicodeCategory.ucUppercaseLetter
  else
    Result := (C >= 'A') and (C <= 'Z');
end;

class function TCharacter.IsUpper(C: Char): Boolean;
begin
  if not IsLatin1(C) then
    Result := InternalGetUnicodeCategory(UCS4Char(C)) = TUnicodeCategory.ucUppercaseLetter
  else if not IsAscii(C) then
    Result := InternalGetLatin1Category(C) = TUnicodeCategory.ucUppercaseLetter
  else
    Result := (C >= 'A') and (C <= 'Z');
end;

class function TCharacter.IsWhiteSpace(const S: string; Index: Integer): Boolean;
var
  C: Char;
begin
  CheckStringRange(S, Index);
  C := S[Index];
  if IsLatin1(C) then
    {$IFDEF UNICODE}
    Result := (C = ' ') or ((C >= #$0009) and (C <= #$000D)) or (C = #$00A0) or (C = #$0085)
    {$ELSE}
    Result := (C = ' ') or ((C >= #$09) and (C <= #$0D))
    {$ENDIF}
  else
    Result := CheckSeparator(GetUnicodeCategory(S, Index));
end;

class function TCharacter.ToLower(C: Char): Char;
begin
  Result := Char(CharLower(PChar(C)));
end;

class function TCharacter.ToLower(const S: string): string;
begin
  Result := S;
  if LCMapString(GetThreadLocale, LCMAP_LOWERCASE, PChar(S), Length(S), PChar(Result), Length(Result)) = 0 then
    RaiseLastOSError;
end;

class function TCharacter.ToUpper(C: Char): Char;
begin
  Result := Char(CharUpper(PChar(C)));
end;

class function TCharacter.ToUpper(const S: string): string;
begin
  Result := S;
  if LCMapString(GetThreadLocale, LCMAP_UPPERCASE, PChar(S), Length(S), PChar(Result), Length(Result)) = 0 then
    RaiseLastOSError;
end;

class function TCharacter.IsWhiteSpace(C: Char): Boolean;
begin
  if IsLatin1(C) then
    {$IFDEF UNICODE}
    Result := (C = ' ') or ((C >= #$0009) and (C <= #$000D)) or (C = #$00A0) or (C = #$0085)
    {$ELSE}
    Result := (C = ' ') or ((C >= #$09) and (C <= #$0D))
    {$ENDIF}
  else
    Result := CheckSeparator(InternalGetUnicodeCategory(UCS4Char(C)));
end;

function ConvertFromUtf32(C: UCS4Char): string;
begin
  Result := TCharacter.ConvertFromUtf32(C);
end;

function ConvertToUtf32(const S: string; Index: Integer): UCS4Char;
begin
  Result := TCharacter.ConvertToUtf32(S, Index);
end;

function ConvertToUtf32(const S: string; Index: Integer; out CharLength: Integer): UCS4Char;
begin
  Result := TCharacter.ConvertToUtf32(S, Index, CharLength);
end;

function ConvertToUtf32(const HighSurrogate, LowSurrogate: Char): UCS4Char;
begin
  Result := TCharacter.ConvertToUtf32(HighSurrogate, LowSurrogate);
end;

function GetNumericValue(C: Char): Double;
begin
  Result := TCharacter.GetNumericValue(C);
end;

function GetNumericValue(const S: string; Index: Integer): Double;
begin
  Result := TCharacter.GetNumericValue(S, Index);
end;

function GetUnicodeCategory(C: Char): TUnicodeCategory;
begin
  Result := TCharacter.GetUnicodeCategory(C);
end;

function GetUnicodeCategory(const S: string; Index: Integer): TUnicodeCategory;
begin
  Result := TCharacter.GetUnicodeCategory(S, Index);
end;

function IsControl(C: Char): Boolean;
begin
  Result := TCharacter.IsControl(C);
end;

function IsControl(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsControl(S, Index);
end;

function IsDigit(C: Char): Boolean;
begin
  Result := TCharacter.IsDigit(C);
end;

function IsDigit(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsDigit(S, Index);
end;

function IsHighSurrogate(C: Char): Boolean;
begin
  Result := TCharacter.IsHighSurrogate(C);
end;

function IsHighSurrogate(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsHighSurrogate(S, Index);
end;

function IsLetter(C: Char): Boolean;
begin
  Result := TCharacter.IsLetter(C);
end;

function IsLetter(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsLetter(S, Index);
end;

function IsLetterOrDigit(C: Char): Boolean;
begin
  Result := TCharacter.IsLetterOrDigit(C);
end;

function IsLetterOrDigit(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsLetterOrDigit(S, Index);
end;

function IsLower(C: Char): Boolean;
begin
  Result := TCharacter.IsLower(C);
end;

function IsLower(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsLower(S, Index);
end;

function IsLowSurrogate(C: Char): Boolean;
begin
  Result := TCharacter.IsLowSurrogate(C);
end;

function IsLowSurrogate(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsLowSurrogate(S, Index);
end;

function IsNumber(C: Char): Boolean;
begin
  Result := TCharacter.IsNumber(C);
end;

function IsNumber(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsNumber(S, Index);
end;

function IsPunctuation(C: Char): Boolean;
begin
  Result := TCharacter.IsPunctuation(C);
end;

function IsPunctuation(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsPunctuation(S, Index);
end;

function IsSeparator(C: Char): Boolean;
begin
  Result := TCharacter.IsSeparator(C);
end;

function IsSeparator(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsSeparator(S, Index);
end;

function IsSurrogate(Surrogate: Char): Boolean;
begin
  Result := TCharacter.IsSurrogate(Surrogate);
end;

function IsSurrogate(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsSurrogate(S, Index);
end;

function IsSurrogatePair(const HighSurrogate, LowSurrogate: Char): Boolean;
begin
  Result := TCharacter.IsSurrogatePair(HighSurrogate, LowSurrogate);
end;

function IsSurrogatePair(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsSurrogatePair(S, Index);
end;

function IsSymbol(C: Char): Boolean;
begin
  Result := TCharacter.IsSymbol(C);
end;

function IsSymbol(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsSymbol(S, Index);
end;

function IsUpper(C: Char): Boolean;
begin
  Result := TCharacter.IsUpper(C);
end;

function IsUpper(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsUpper(S, Index);
end;

function IsWhiteSpace(C: Char): Boolean;
begin
  Result := TCharacter.IsWhiteSpace(C);
end;

function IsWhiteSpace(const S: string; Index: Integer): Boolean;
begin
  Result := TCharacter.IsWhiteSpace(S, Index);
end;

function ToLower(C: Char): Char;
begin
  Result := TCharacter.ToLower(C);
end;

function ToLower(const S: string): string;
begin
  Result := TCharacter.ToLower(S);
end;

function ToUpper(C: Char): Char;
begin
  Result := TCharacter.ToUpper(C);
end;

function ToUpper(const S: string): string;
begin
  Result := TCharacter.ToUpper(S);
end;

end.
