{-------------------------------------------------------------------------------

  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is DITypes.pas.

  The Initial Developer of the Original Code is Ralf Junker, Yunqa

  E-Mail:    delphi@yunqa.de
  Internet:  http://www.yunqa.de

  All Rights Reserved.

-------------------------------------------------------------------------------}

unit DITypes;

{$I DI.inc}

interface

{$IFNDEF FPC}
uses
  DISystemCompat;
{$ENDIF !FPC}

type
  {$IFDEF FLOAT_EXTENDED_PRECISION}

  Float = Extended; {$ENDIF}
  {$IFDEF FLOAT_DOUBLE_PRECISION}

  Float = Double; {$ENDIF}
  {$IFDEF FLOAT_SINGLE_PRECISION}

  Float = Single; {$ENDIF}

  TBase01 = Byte;

  PBase01 = ^TBase01;

  TBase02 = Word;

  PBase02 = ^TBase02;

  TBase04 = Cardinal;

  PBase04 = ^TBase04;

  TBase08 = packed record
    One: TBase04;
    Two: TBase04;
  end;

  PBase08 = ^TBase08;

  TBase12 = packed record
    One: TBase04;
    Two: TBase04;
    Three: TBase04;
  end;

  PBase12 = ^TBase12;

  TBase16 = packed record
    One: TBase04;
    Two: TBase04;
    Three: TBase04;
    Four: TBase04;
  end;

  PBase16 = ^TBase16;

  TBase20 = packed record
    One: TBase04;
    Two: TBase04;
    Three: TBase04;
    Four: TBase04;
    Five: TBase04;
  end;

  PBase20 = ^TBase20;

  TBase24 = packed record
    One: TBase04;
    Two: TBase04;
    Three: TBase04;
    Four: TBase04;
    Five: TBase04;
    Six: TBase04;
  end;

  PBase24 = ^TBase24;

  TDIByteArray = packed array[0..MaxInt div SizeOf(Byte) - 1] of Byte;

  PDIByteArray = ^TDIByteArray;

  TWordArray = packed array[0..MaxInt div SizeOf(Word) - 1] of Word;

  PWordArray = ^TWordArray;

  TWordRec = packed record
    lo, hi: Byte;
  end;
  PWordRec = ^TWordRec;

  TIntegerArray = packed array[0..MaxInt div SizeOf(Integer) - 1] of Integer;
  PIntegerArray = ^TIntegerArray;

  TIntegerBase01 = packed record
    Number: Integer;
    Base01: TBase01;
  end;
  PIntegerBase01 = ^TIntegerBase01;

  TIntegerBase04 = packed record
    Number: Integer;
    Base04: TBase04;
  end;
  PIntegerBase04 = ^TIntegerBase04;

  TInteger2 = packed record
    Number: Integer;
    Number2: Integer;
  end;
  PInteger2 = ^TInteger2;

  TInteger2Base01 = packed record
    Number: Integer;
    Number2: Integer;
    Base01: TBase01;
  end;
  PInteger2Base01 = ^TInteger2Base01;

  TInteger3 = packed record
    Number: Integer;
    Number2: Integer;
    Number3: Integer;
  end;
  PInteger3 = ^TInteger3;

  TInteger3Base01 = packed record
    Number: Integer;
    Number2: Integer;
    Number3: Integer;
    Base01: TBase01;
  end;
  PInteger3Base01 = ^TInteger3Base01;

  TIntegerPointer = packed record
    Number: Integer;
    Ptr: Pointer;
  end;
  PIntegerPointer = ^TIntegerPointer;

  TCardinalArray = packed array[0..MaxInt div SizeOf(Cardinal) - 1] of Cardinal;
  PCardinalArray = ^TCardinalArray;

  TCardinalRec = packed record
    lo, hi: Word;
  end;
  PCardinalRec = ^TCardinalRec;

  TCardinalBase01 = packed record
    Number: Cardinal;
    Base01: TBase01;
  end;
  PCardinalBase01 = ^TCardinalBase01;

  TCardinalBase04 = packed record
    Number: Cardinal;
    Base04: TBase04;
  end;
  PCardinalBase04 = ^TCardinalBase04;

  TCardinal2 = packed record
    Number: Cardinal;
    Number2: Cardinal;
  end;
  PCardinal2 = ^TCardinal2;

  TCardinal2Array = packed array[0..MaxInt div SizeOf(TCardinal2) - 1] of TCardinal2;
  PCardinal2Array = ^TCardinal2Array;

  TCardinal2Base01 = packed record
    Number: Cardinal;
    Number2: Cardinal;
    Base01: TBase01;
  end;
  PCardinal2Base01 = ^TCardinal2Base01;

  TCardinal2Base01Array = packed array[0..MaxInt div SizeOf(TCardinal2Base01) - 1] of TCardinal2Base01;
  PCardinal2Base01Array = ^TCardinal2Base01Array;

  TNativeIntArray = packed array[0..MaxInt div SizeOf(NativeInt) - 1] of NativeInt;
  PNativeIntArray = ^TNativeIntArray;

  TNativeIntRec = packed record
    lo, hi: Word;
  end;
  PNativeIntRec = ^TNativeIntRec;

  TNativeIntBase01 = packed record
    Number: NativeInt;
    Base01: TBase01;
  end;
  PNativeIntBase01 = ^TNativeIntBase01;

  TNativeIntBase04 = packed record
    Number: NativeInt;
    Base04: TBase04;
  end;
  PNativeIntBase04 = ^TNativeIntBase04;

  TNativeInt2 = packed record
    Number: NativeInt;
    Number2: NativeInt;
  end;
  PNativeInt2 = ^TNativeInt2;

  TNativeInt2Array = packed array[0..MaxInt div SizeOf(TNativeInt2) - 1] of TNativeInt2;
  PNativeInt2Array = ^TNativeInt2Array;

  TNativeInt2Base01 = packed record
    Number: NativeInt;
    Number2: NativeInt;
    Base01: TBase01;
  end;
  PNativeInt2Base01 = ^TNativeInt2Base01;

  TNativeInt2Base01Array = packed array[0..MaxInt div SizeOf(TNativeInt2Base01) - 1] of TNativeInt2Base01;
  PNativeInt2Base01Array = ^TNativeInt2Base01Array;

  TNativeUIntArray = packed array[0..MaxInt div SizeOf(NativeUInt) - 1] of NativeUInt;
  PNativeUIntArray = ^TNativeUIntArray;

  TNativeUIntRec = packed record
    lo, hi: Word;
  end;
  PNativeUIntRec = ^TNativeUIntRec;

  TNativeUIntBase01 = packed record
    Number: NativeUInt;
    Base01: TBase01;
  end;
  PNativeUIntBase01 = ^TNativeUIntBase01;

  TNativeUIntBase04 = packed record
    Number: NativeUInt;
    Base04: TBase04;
  end;
  PNativeUIntBase04 = ^TNativeUIntBase04;

  TNativeUInt2 = packed record
    Number: NativeUInt;
    Number2: NativeUInt;
  end;
  PNativeUInt2 = ^TNativeUInt2;

  TNativeUInt2Array = packed array[0..MaxInt div SizeOf(TNativeUInt2) - 1] of TNativeUInt2;
  PNativeUInt2Array = ^TNativeUInt2Array;

  TNativeUInt2Base01 = packed record
    Number: NativeUInt;
    Number2: NativeUInt;
    Base01: TBase01;
  end;
  PNativeUInt2Base01 = ^TNativeUInt2Base01;

  TNativeUInt2Base01Array = packed array[0..MaxInt div SizeOf(TNativeUInt2Base01) - 1] of TNativeUInt2Base01;
  PNativeUInt2Base01Array = ^TNativeUInt2Base01Array;

  TSingleArray = packed array[0..MaxInt div SizeOf(Single) - 1] of Single;

  PSingleArray = ^TSingleArray;

  TDoubleArray = packed array[0..MaxInt div SizeOf(Double) - 1] of Double;

  PDoubleArray = ^TDoubleArray;

  PObject = ^TObject;

  TObject2 = packed record
    Obj: TObject;
    Obj2: TObject;
  end;

  PObject2 = ^TObject2;

  TAnsiCharArray = packed array[0..MaxInt div SizeOf(AnsiChar) - 1] of AnsiChar;

  PAnsiCharArray = ^TAnsiCharArray;

  TStringBase01 = packed record
    Name: string;
    Base01: TBase01;
  end;

  PStringBase01 = ^TStringBase01;

  TStringBase04 = packed record
    Name: string;
    Base04: TBase04;
  end;

  PStringBase04 = ^TStringBase04;

  TStringCardinal = packed record
    Name: string;
    Number: Cardinal;
  end;

  PStringCardinal = ^TStringCardinal;

  TStringCardinalBase01 = packed record
    Name: string;
    Number: Cardinal;
    Base01: TBase01;
  end;

  PStringCardinalBase01 = ^TStringCardinalBase01;

  TStringInteger = packed record
    Name: string;
    Number: Integer;
  end;

  PStringInteger = ^TStringInteger;

  TStringInteger2 = packed record
    Name: string;
    Number: Integer;
    Number2: Integer;
  end;

  PStringInteger2 = ^TStringInteger2;

  TStringObject = packed record
    Name: string;
    Obj: TObject;
  end;

  PStringObject = ^TStringObject;

  TStringPointer = packed record
    Name: string;
    Ptr: Pointer;
  end;

  PStringPointer = ^TStringPointer;

  TString2 = packed record
    Name: string;
    Value: string;
  end;
  PString2 = ^TString2;

  TString2Base01 = packed record
    Name: string;
    Value: string;
    Base01: TBase01;
  end;

  PString2Base01 = ^TString2Base01;

  TString2Base04 = packed record
    Name: string;
    Value: string;
    Base04: TBase04;
  end;

  PString2Base04 = ^TString2Base04;

  TString2Cardinal = packed record
    Name: string;
    Value: string;
    Number: Cardinal;
  end;

  PString2Cardinal = ^TString2Cardinal;

  TString2CardinalBase01 = packed record
    Name: string;
    Value: string;
    Number: Cardinal;
    Base01: TBase01;
  end;

  PString2CardinalBase01 = ^TString2CardinalBase01;

  TAnsiStringBase01 = packed record
    Name: AnsiString;
    Base01: TBase01;
  end;

  PAnsiStringBase01 = ^TAnsiStringBase01;

  TAnsiStringBase04 = packed record
    Name: AnsiString;
    Base04: TBase04;
  end;

  PAnsiStringBase04 = ^TAnsiStringBase04;

  TAnsiStringBase08 = packed record
    Name: AnsiString;
    d: packed record case Boolean of
        True: (Base04_1: TBase04; Base04_2: TBase04);
        False: (Base08: Int64; )
    end;
  end;

  PAnsiStringBase08 = ^TAnsiStringBase08;

  TAnsiStringInteger = packed record
    Name: AnsiString;
    Number: Integer;
  end;

  PAnsiStringInteger = ^TAnsiStringInteger;

  TAnsiStringIntegerBase01 = packed record
    Name: AnsiString;
    Number: Integer;
    Base01: TBase01;
  end;

  PAnsiStringIntegerBase01 = ^TAnsiStringIntegerBase01;

  TAnsiStringInteger2 = packed record
    Name: AnsiString;
    Number: Integer;
    Number2: Integer;
  end;

  PAnsiStringInteger2 = ^TAnsiStringInteger2;

  TAnsiStringInteger2Base01 = packed record
    Name: AnsiString;
    Number: Integer;
    Number2: Integer;
    Base01: TBase01;
  end;

  PAnsiStringInteger2Base01 = ^TAnsiStringInteger2Base01;

  TAnsiStringCardinal = packed record
    Name: AnsiString;
    Number: Cardinal;
  end;

  PAnsiStringCardinal = ^TAnsiStringCardinal;

  TAnsiStringCardinalBase01 = packed record
    Name: AnsiString;
    Number: Cardinal;
    Base01: TBase01;
  end;

  PAnsiStringCardinalBase01 = ^TAnsiStringCardinalBase01;

  TAnsiStringCardinal2 = packed record
    Name: AnsiString;
    Number: Cardinal;
    Number2: Cardinal;
  end;

  PAnsiStringCardinal2 = ^TAnsiStringCardinal2;

  TAnsiStringObject = packed record
    Name: AnsiString;
    Obj: TObject;
  end;

  PAnsiStringObject = ^TAnsiStringObject;

  TAnsiStringPointer = packed record
    Name: AnsiString;
    Ptr: Pointer;
  end;

  PAnsiStringPointer = ^TAnsiStringPointer;

  TAnsiString2 = packed record
    Name: AnsiString;
    Value: AnsiString;
  end;

  PAnsiString2 = ^TAnsiString2;

  TAnsiString2Base01 = packed record
    Name: AnsiString;
    Value: AnsiString;
    Base01: TBase01;
  end;

  PAnsiString2Base01 = ^TAnsiString2Base01;

  TAnsiString2Base04 = packed record
    Name: AnsiString;
    Value: AnsiString;
    Base04: TBase04;
  end;

  PAnsiString2Base04 = ^TAnsiString2Base04;

  TAnsiString2Cardinal = packed record
    Name: AnsiString;
    Value: AnsiString;
    Number: Cardinal;
  end;

  PAnsiString2Cardinal = ^TAnsiString2Cardinal;

  TAnsiString2CardinalBase01 = packed record
    Name: AnsiString;
    Value: AnsiString;
    Number: Cardinal;
    Base01: TBase01;
  end;

  PAnsiString2CardinalBase01 = ^TAnsiString2CardinalBase01;

  TWideStringBase01 = packed record
    Name: WideString;
    Base01: TBase01;
  end;

  PWideStringBase01 = ^TWideStringBase01;

  TWideStringBase04 = packed record
    Name: WideString;
    Base04: TBase04;
  end;

  PWideStringBase04 = ^TWideStringBase04;

  TWideStringInteger = packed record
    Name: WideString;
    Number: Integer;
  end;

  PWideStringInteger = ^TWideStringInteger;

  TWideStringInteger2 = packed record
    Name: WideString;
    Number: Integer;
    Number2: Integer;
  end;

  PWideStringInteger2 = ^TWideStringInteger2;

  TWideStringIntegerBase01 = packed record
    Name: WideString;
    Number: Integer;
    Base01: TBase01;
  end;

  PWideStringIntegerBase01 = ^TWideStringIntegerBase01;

  TWideStringCardinal = packed record
    Name: WideString;
    Number: Cardinal;
  end;

  PWideStringCardinal = ^TWideStringCardinal;

  TWideStringCardinalBase01 = packed record
    Name: WideString;
    Number: Cardinal;
    Base01: TBase01;
  end;

  PWideStringCardinalBase01 = ^TWideStringCardinalBase01;

  TWideStringObject = packed record
    Name: WideString;
    Obj: TObject;
  end;

  PWideStringObject = ^TWideStringObject;

  TWideStringPointer = packed record
    Name: WideString;
    Ptr: Pointer;
  end;

  PWideStringPointer = ^TWideStringPointer;

  TWideString2 = packed record
    Name: WideString;
    Value: WideString;
  end;

  PWideString2 = ^TWideString2;

  TWideString2Base01 = packed record
    Name: WideString;
    Value: WideString;
    Base01: TBase01;
  end;

  PWideString2Base01 = ^TWideString2Base01;

  TWideString2Base04 = packed record
    Name: WideString;
    Value: WideString;
    Base04: TBase04;
  end;

  PWideString2Base04 = ^TWideString2Base04;

  TWideString2Cardinal = packed record
    Name: WideString;
    Value: WideString;
    Number: Cardinal;
  end;

  PWideString2Cardinal = ^TWideString2Cardinal;

  TWideString2CardinalBase01 = packed record
    Name: WideString;
    Value: WideString;
    Number: Cardinal;
    Base01: TBase01;
  end;

  PWideString2CardinalBase01 = ^TWideString2CardinalBase01;

  TUnicodeStringBase01 = packed record
    Name: UnicodeString;
    Base01: TBase01;
  end;

  PUnicodeStringBase01 = ^TUnicodeStringBase01;

  TUnicodeStringBase04 = packed record
    Name: UnicodeString;
    Base04: TBase04;
  end;

  PUnicodeStringBase04 = ^TUnicodeStringBase04;

  TUnicodeStringInteger = packed record
    Name: UnicodeString;
    Number: Integer;
  end;

  PUnicodeStringInteger = ^TUnicodeStringInteger;

  TUnicodeStringInteger2 = packed record
    Name: UnicodeString;
    Number: Integer;
    Number2: Integer;
  end;

  PUnicodeStringInteger2 = ^TUnicodeStringInteger2;

  TUnicodeStringIntegerBase01 = packed record
    Name: UnicodeString;
    Number: Integer;
    Base01: TBase01;
  end;

  PUnicodeStringIntegerBase01 = ^TUnicodeStringIntegerBase01;

  TUnicodeStringCardinal = packed record
    Name: UnicodeString;
    Number: Cardinal;
  end;

  PUnicodeStringCardinal = ^TUnicodeStringCardinal;

  TUnicodeStringCardinalBase01 = packed record
    Name: UnicodeString;
    Number: Cardinal;
    Base01: TBase01;
  end;

  PUnicodeStringCardinalBase01 = ^TUnicodeStringCardinalBase01;

  TUnicodeStringObject = packed record
    Name: UnicodeString;
    Obj: TObject;
  end;

  PUnicodeStringObject = ^TUnicodeStringObject;

  TUnicodeStringPointer = packed record
    Name: UnicodeString;
    Ptr: Pointer;
  end;

  PUnicodeStringPointer = ^TUnicodeStringPointer;

  TUnicodeString2 = packed record
    Name: UnicodeString;
    Value: UnicodeString;
  end;

  PUnicodeString2 = ^TUnicodeString2;

  TUnicodeString2Base01 = packed record
    Name: UnicodeString;
    Value: UnicodeString;
    Base01: TBase01;
  end;

  PUnicodeString2Base01 = ^TUnicodeString2Base01;

  TUnicodeString2Base04 = packed record
    Name: UnicodeString;
    Value: UnicodeString;
    Base04: TBase04;
  end;

  PUnicodeString2Base04 = ^TUnicodeString2Base04;

  TUnicodeString2Cardinal = packed record
    Name: UnicodeString;
    Value: UnicodeString;
    Number: Cardinal;
  end;

  PUnicodeString2Cardinal = ^TUnicodeString2Cardinal;

  TUnicodeString2CardinalBase01 = packed record
    Name: UnicodeString;
    Value: UnicodeString;
    Number: Cardinal;
    Base01: TBase01;
  end;

  PUnicodeString2CardinalBase01 = ^TUnicodeString2CardinalBase01;

  TUnicodeString2NativeUInt = packed record
    Name: UnicodeString;
    Value: UnicodeString;
    Number: NativeUInt;
  end;

  PUnicodeString2NativeUInt = ^TUnicodeString2NativeUInt;

  TUnicodeString2NativeUIntBase01 = packed record
    Name: UnicodeString;
    Value: UnicodeString;
    Number: NativeUInt;
    Base01: TBase01;
  end;

  PUnicodeString2NativeUIntBase01 = ^TUnicodeString2NativeUIntBase01;

  TAnsiStringArray = packed array[0..MaxInt div SizeOf(AnsiString) - 1] of AnsiString;

  PAnsiStringArray = ^TAnsiStringArray;

  TWideStringArray = packed array[0..MaxInt div SizeOf(WideString) - 1] of WideString;

  PWideStringArray = ^TWideStringArray;

  TUnicodeStringArray = packed array[0..MaxInt div SizeOf(UnicodeString) - 1] of UnicodeString;

  PUnicodeStringArray = ^TUnicodeStringArray;

  TPointer2 = packed record
    Ptr: Pointer;
    Ptr2: Pointer;
  end;

  PPointer2 = ^TPointer2;

  TPointer2Array = packed array[0..MaxInt div SizeOf(TPointer2) - 1] of TPointer2;
  PPointer2Array = ^TPointer2Array;

implementation

end.

