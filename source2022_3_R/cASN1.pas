{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 4.00                                        }
{   File name:        cASN1.pas                                                }
{   File version:     0.03                                                     }
{   Description:      Abstract Syntax Notation One (ASN.1)                     }
{                     BER (Basic Encoding Routines)                            }
{                                                                              }
{   Copyright:        Copyright (c) 2010-2012, David J Butler                  }
{                     All rights reserved.                                     }
{   E-mail:           fundamentals.tls@gmail.com                               }
{                                                                              }
{   DUAL LICENSE                                                               }
{                                                                              }
{   This source code is released under a dual license:                         }
{                                                                              }
{       1.  The GNU General Public License (GPL)                               }
{       2.  Commercial license                                                 }
{                                                                              }
{   By using this source code in your application (directly or indirectly,     }
{   statically or dynamically linked) your application is subject to this      }
{   dual license.                                                              }
{                                                                              }
{   If you choose the GPL, your application is also subject to the GPL.        }
{   You are required to release the source code of your application            }
{   publicly when you distribute it. Distribution includes giving it away      }
{   or using it in a commercial environment. To distribute an application      }
{   under the GPL it must not use any non open-source components.              }
{                                                                              }
{   If you do not wish your application to be bound by the GPL, you can        }
{   acquire a commercial license from the author.                              }
{                                                                              }
{   GPL LICENSE                                                                }
{                                                                              }
{   This program is free software: you can redistribute it and/or modify       }
{   it under the terms of the GNU General Public License as published by       }
{   the Free Software Foundation, either version 3 of the License, or          }
{   (at your option) any later version.                                        }
{                                                                              }
{   This program is distributed in the hope that it will be useful,            }
{   but WITHOUT ANY WARRANTY; without even the implied warranty of             }
{   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              }
{   GNU General Public License for more details.                               }
{                                                                              }
{   For the full terms of the GPL, see:                                        }
{                                                                              }
{         http://www.gnu.org/licenses/                                         }
{     or  http://opensource.org/licenses/GPL-3.0                               }
{                                                                              }
{   COMMERCIAL LICENSE                                                         }
{                                                                              }
{   To use this component for commercial purposes, please visit:               }
{                                                                              }
{         http://www.eternallines.com/fndtls/                                  }
{                                                                              }
{ References:                                                                  }
{                                                                              }
{   ITU-T Rec. X.690 (07/2002)                                                 }
{   http://www.itu.int/ITU-T/studygroups/com17/languages/X.690-0207.pdf        }
{   http://en.wikipedia.org/wiki/Abstract_Syntax_Notation_One                  }
{   http://en.wikipedia.org/wiki/Basic_Encoding_Rules                          }
{   http://luca.ntop.org/Teaching/Appunti/asn1.html                            }
{   http://www.obj-sys.com/asn1tutorial/node10.html                            }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{   2010/11/08  0.01  Initial development: encoding routines.                  }
{   2010/11/23  0.02  Initial development: decoding routines.                  }
{   2011/04/02  0.03  Compilable with Delphi 5.                                }
{                                                                              }
{******************************************************************************}

{$INCLUDE cDefines.inc}
unit cASN1;

interface

uses
  { System }
  SysUtils;



{ ASN.1 errors                                                                 }
type
  EASN1 = class(Exception);



{ Type identifier octet                    }
{                                          }
{   Class	            Bit 8   Bit 7        }
{   universal	            0	    0          }
{   application	          0	    1          }
{   context-specific	    1	    0          }
{   private	              1	    1          }
{                                          }
{   Bit 6 = P/C (Primitive/Constructed)    }
const
  ASN1_ID_END_OF_CONTENT    = $00;
  ASN1_ID_BOOLEAN           = $01;
  ASN1_ID_INTEGER           = $02;
  ASN1_ID_BIT_STRING        = $03;
  ASN1_ID_OCTET_STRING      = $04;
  ASN1_ID_NULL              = $05;
  ASN1_ID_OBJECT_IDENTIFIER = $06;
  ASN1_ID_OBJECT_DESCRIPTOR = $07;
  ASN1_ID_EXTERNAL          = $08;
  ASN1_ID_REAL              = $09;
  ASN1_ID_ENUMERATED        = $0A;
  ASN1_ID_EMBEDDED_PDV      = $0B;
  ASN1_ID_UTF8STRING        = $0C; // ISO10646-1 (Unicode, UTF8)
  ASN1_ID_RELATIVE_OID      = $0D;
  ASN1_ID_NUMERICSTRING     = $12; // ASCII
  ASN1_ID_PRINTABLESTRING   = $13; // ASCII (A..Z, a..z, 0..9, ' = ( ) + , - . / : ?) (Excludes @ & _)
  ASN1_ID_T61STRING         = $14; // CCITT T.61 (Teletex) (ASCII, 8 bit, escape sequences)
  ASN1_ID_VIDEOTEXSTRING    = $15; // CCITT T.100/T.101
  ASN1_ID_IA5STRING         = $16; // International Alphabet 5 (ASCII)
  ASN1_ID_UTCTIME           = $17;
  ASN1_ID_GENERALIZEDTIME   = $18;
  ASN1_ID_GRAPHICSTRING     = $19;
  ASN1_ID_VISIBLESTRING     = $1A; // ISO646 (ASCII)
  ASN1_ID_GENERALSTRING     = $1B;
  ASN1_ID_UNIVERSALSTRING   = $1C; // ISO10646-1 (Unicode, UCS4)
  ASN1_ID_CHARACTERSTRING   = $1D;
  ASN1_ID_BMPSTRING         = $1E; // ISO10646-1 (Unicode, UCS2)
  ASN1_ID_SEQUENCE          = $30;
  ASN1_ID_SET               = $31;

  ASN1_ID_CONSTRUCTED       = $20;
  ASN1_ID_APPLICATION       = $40;
  ASN1_ID_CONTEXT_SPECIFIC  = $80;
  ASN1_ID_PRIVATE           = $C0;

  ASN1_ID_CONSTR_APPLICATION      = ASN1_ID_CONSTRUCTED or ASN1_ID_APPLICATION;
  ASN1_ID_CONSTR_CONTEXT_SPECIFIC = ASN1_ID_CONSTRUCTED or ASN1_ID_CONTEXT_SPECIFIC;
  ASN1_ID_CONSTR_PRIVATE          = ASN1_ID_CONSTRUCTED or ASN1_ID_PRIVATE;



{ Object identifiers  }

type
  TASN1ObjectIdentifier = array of Integer;

procedure ASN1OIDInit(var A: TASN1ObjectIdentifier; const B: array of Integer);
function  ASN1OIDToStr(const A: TASN1ObjectIdentifier): AnsiString;
function  ASN1OIDEqual(const A: TASN1ObjectIdentifier; const B: array of Integer): Boolean;



{ OIDs for common hash and cipher algorithms }

const
  OID_PKCS_1         : array[0..5] of Integer = (1, 2,  840, 113549, 1,   1);
  OID_RSA            : array[0..6] of Integer = (1, 2,  840, 113549, 1,   1,  1);
  OID_RSA_PKCS1_MD2  : array[0..6] of Integer = (1, 2,  840, 113549, 1,   1,  2);
  OID_RSA_PKCS1_MD5  : array[0..6] of Integer = (1, 2,  840, 113549, 1,   1,  4);
  OID_RSA_PKCS1_SHA1 : array[0..6] of Integer = (1, 2,  840, 113549, 1,   1,  5);
  OID_RSA_OAEP       : array[0..6] of Integer = (1, 2,  840, 15245,  1,   1,  7);
  OID_RSA_MGF1       : array[0..6] of Integer = (1, 2,  840, 113549, 1,   1,  8);
  OID_DSA            : array[0..5] of Integer = (1, 2,  840, 10040,  4,   1);
  OID_DSA_SHA1       : array[0..5] of Integer = (1, 2,  840, 10040,  4,   3);
  OID_3DESWrap       : array[0..8] of Integer = (1, 2,  840, 113549, 1,   9,  16, 3, 6);
  OID_RC2Wrap        : array[0..8] of Integer = (1, 2,  840, 113549, 1,   9,  16, 3, 7);
  OID_AES128KeyWrap  : array[0..8] of Integer = (2, 16, 840, 1,      101, 3,  4,  1, 5);
  OID_MD5            : array[0..5] of Integer = (1, 2,  840, 113549, 2,   5);
  OID_SHA1           : array[0..5] of Integer = (1, 3,  14,  3,      2,   26);



{ Encode }

function ASN1EncodeLength(const Len: Integer): AnsiString;
function ASN1EncodeObj(const TypeID: Byte; const Data: AnsiString): AnsiString;

function ANS1EncodeEndOfContent: AnsiString;
function ASN1EncodeNull: AnsiString;
function ASN1EncodeBoolean(const A: Boolean): AnsiString;
function ASN1EncodeDataInteger8(const A: ShortInt): AnsiString;
function ASN1EncodeDataInteger16(const A: SmallInt): AnsiString;
function ASN1EncodeDataInteger24(const A: LongInt): AnsiString;
function ASN1EncodeDataInteger32(const A: LongInt): AnsiString;
function ASN1EncodeDataInteger64(const A: Int64): AnsiString;
function ASN1EncodeInteger8(const A: ShortInt): AnsiString;
function ASN1EncodeInteger16(const A: SmallInt): AnsiString;
function ASN1EncodeInteger24(const A: LongInt): AnsiString;
function ASN1EncodeInteger32(const A: LongInt): AnsiString;
function ASN1EncodeInteger64(const A: Int64): AnsiString;
function ASN1EncodeIntegerBuf(const A; const Size: Integer): AnsiString;
function ASN1EncodeIntegerBufStr(const A: AnsiString): AnsiString;
function ASN1EncodeEnumerated(const A: Int64): AnsiString;
function ASN1EncodeBitString(const A: AnsiString; const UnusedBits: Byte): AnsiString;
function ASN1EncodeOctetString(const A: AnsiString): AnsiString;
function ASN1EncodeInt32AsOctetString(const A: LongInt): AnsiString;
function ASN1EncodeUTF8String(const A: AnsiString): AnsiString;
function ASN1EncodeIA5String(const A: AnsiString): AnsiString;
function ASN1EncodeVisibleString(const A: AnsiString): AnsiString;
function ASN1EncodeNumericString(const A: AnsiString): AnsiString;
function ASN1EncodePrintableString(const A: AnsiString): AnsiString;
function ASN1EncodeTeletexString(const A: AnsiString): AnsiString;
function ASN1EncodeUniversalString(const A: WideString): AnsiString;
function ASN1EncodeBMPString(const A: WideString): AnsiString;
function ASN1EncodeUTCTime(const A: TDateTime): AnsiString;
function ASN1EncodeGeneralizedTime(const A: TDateTime): AnsiString;
function ASN1EncodeOID(const OID: array of Integer): AnsiString;
function ASN1EncodeSequence(const A: AnsiString): AnsiString;
function ASN1EncodeSet(const A: AnsiString): AnsiString;
function ASN1EncodeContextSpecific(const I: Integer; const A: AnsiString): AnsiString;



{ Decode }

function ASN1DecodeLength(const Buf; const Size: Integer; var Len: Integer): Integer;
function ASN1DecodeObjHeader(const Buf; const Size: Integer;
         var TypeID: Byte; var Len: Integer; var Data: Pointer): Integer;
function ASN1TypeIsConstructedType(const TypeID: Byte): Boolean;
function ASN1TypeIsContextSpecific(const TypeID: Byte; var Idx: Integer): Boolean;

function ASN1DecodeDataBoolean(const Buf; const Size: Integer; var A: Boolean): Integer;
function ASN1DecodeDataInteger32(const Buf; const Size: Integer; var A: LongInt): Integer;
function ASN1DecodeDataInteger64(const Buf; const Size: Integer; var A: Int64): Integer;
function ASN1DecodeDataIntegerBuf(const Buf; const Size: Integer; var A: AnsiString): Integer;
function ASN1DecodeDataBitString(const Buf; const Size: Integer; var A: AnsiString; var UnusedBits: Byte): Integer;
function ASN1DecodeDataRawAnsiString(const Buf; const Size: Integer; var A: AnsiString): Integer;
function ASN1DecodeDataOctetString(const Buf; const Size: Integer; var A: AnsiString): Integer;
function ASN1DecodeDataIA5String(const Buf; const Size: Integer; var A: AnsiString): Integer;
function ASN1DecodeDataVisibleString(const Buf; const Size: Integer; var A: AnsiString): Integer;
function ASN1DecodeDataNumericString(const Buf; const Size: Integer; var A: AnsiString): Integer;
function ASN1DecodeDataPrintableString(const Buf; const Size: Integer; var A: AnsiString): Integer;
function ASN1DecodeDataTeletexString(const Buf; const Size: Integer; var A: AnsiString): Integer;
function ASN1DecodeDataUTF8String(const Buf; const Size: Integer; var A: AnsiString): Integer;
function ASN1DecodeDataUniversalString(const Buf; const Size: Integer; var A: AnsiString): Integer;
function ASN1DecodeDataBMPString(const Buf; const Size: Integer; var A: AnsiString): Integer;
function ASN1DecodeDataOID(const Buf; const Size: Integer; var A: TASN1ObjectIdentifier): Integer;
function ASN1DecodeDataUTCTime(const Buf; const Size: Integer; var A: TDateTime): Integer;
function ASN1DecodeDataGeneralizedTime(const Buf; const Size: Integer; var A: TDateTime): Integer;

type
  TASN1ParseProc =
      procedure (const TypeID: Byte; const DataBuf; const DataSize: Integer;
                 const ObjectIdx: Integer; const CallerData: Integer);

function ASN1Parse(
         const Buf; const Size: Integer;
         const ParseProc: TASN1ParseProc;
         const CallerData: Integer): Integer;

function ASN1DecodeBoolean(const TypeID: Byte; const DataBuf; const DataSize: Integer; var A: Boolean): Integer;
function ASN1DecodeInteger32(const TypeID: Byte; const DataBuf; const DataSize: Integer; var A: LongInt): Integer;
function ASN1DecodeInteger64(const TypeID: Byte; const DataBuf; const DataSize: Integer; var A: Int64): Integer;
function ASN1DecodeIntegerBuf(const TypeID: Byte; const DataBuf; const DataSize: Integer; var A: AnsiString): Integer;
function ASN1DecodeBitString(const TypeID: Byte; const DataBuf; const DataSize: Integer; var A: AnsiString; var UnusedBits: Byte): Integer;
function ASN1DecodeString(const TypeID: Byte; const DataBuf; const DataSize: Integer; var A: AnsiString): Integer;
function ASN1DecodeOID(const TypeID: Byte; const DataBuf; const DataSize: Integer; var A: TASN1ObjectIdentifier): Integer;
function ASN1DecodeTime(const TypeID: Byte; const DataBuf; const DataSize: Integer; var A: TDateTime): Integer;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF DEBUG}{$IFDEF SELFTEST}
procedure SelfTest;
{$ENDIF}{$ENDIF}



implementation

uses
  { Fundamentals }
  cUtils,
  cUnicodeCodecs;



{ Errors }

const
  SErr_EncodeError = 'Encode error';

  SErr_DecodeError           = 'Decode error';
  SErr_DecodeInvalidType     = 'Decode error: Invalid type';
  SErr_DecodeConversionError = 'Decode error: Invalid type conversion';



{ Constants }

const
  MinInt8  = -128;
  MaxInt8  = 127;
  MinInt16 = -32768;
  MaxInt16 = 32767;
  MinInt24 = -8388608;
  MaxInt24 = 8388607;
  MinInt32 = Low(LongInt); // -2147483648;
  MaxInt32 = 2147483647;



{ Types }

{$IFDEF DELPHI5}
type
  PByte = ^Byte;
{$ENDIF}



{ Utilities }

{$IFDEF DELPHI5}
function TryStrToInt(const S: AnsiString; var I: Integer): Boolean;
var Error : Integer;
begin
  Val(S, I, Error);
  Result := Error = 0;
end;

function TryStrToInt64(const S: AnsiString; var I: Int64): Boolean;
var Error : Integer;
begin
  Val(S, I, Error);
  Result := Error = 0;
end;
{$ENDIF}



{ Object identifiers  }

procedure ASN1OIDInit(var A: TASN1ObjectIdentifier; const B: array of Integer);
var L, I : Integer;
begin
  L := Length(B);
  SetLength(A, L);
  for I := 0 to L - 1 do
    A[I] := B[I];
end;

function ASN1OIDToStr(const A: TASN1ObjectIdentifier): AnsiString;
var I : Integer;
    S : AnsiString;
begin
  S := '';
  for I := 0 to Length(A) - 1 do
    begin
      if I > 0 then
        S := S + '.';
      S := S + IntToStringA(A[I]);
    end;
  Result := S;
end;

function ASN1OIDEqual(const A: TASN1ObjectIdentifier; const B: array of Integer): Boolean;
var L, M, I : Integer;
begin
  L := Length(A);
  M := Length(B);
  Result := False;
  if L <> M then
    exit;
  for I := 0 to L - 1 do
    if A[I] <> B[I] then
      exit;
  Result := True;
end;



{ Encode }

function ASN1EncodeLength_Short(const Len: Integer): AnsiString;
begin
  Assert(Len >= 0);
  Assert(Len <= 127);

  SetLength(Result, 1);
  Result := AnsiChar(Len);
end;

function ASN1EncodeLength_Long(const Len: Integer): AnsiString;
var N, I : Integer;
    B : array[0..3] of Byte;
begin
  Assert(Len >= 0);

  // count bytes required to represent Len
  N := 0;
  I := Len;
  repeat
    B[N] := I mod $100;
    I := I div $100;
    Inc(N);
  until I = 0;
  // set result
  SetLength(Result, N + 1);
  Result[1] := AnsiChar(N or $80);
  for I := 0 to N - 1 do
    Result[2 + I] := AnsiChar(B[N - I - 1]);
end;

function ASN1EncodeLength(const Len: Integer): AnsiString;
begin
  if Len < $80 then
    Result := ASN1EncodeLength_Short(Len)
  else
    Result := ASN1EncodeLength_Long(Len);
end;

function ASN1EncodeObj(const TypeID: Byte; const Data: AnsiString): AnsiString;
begin
  Result :=
      AnsiChar(TypeID) +
      ASN1EncodeLength(Length(Data)) +
      Data;
end;

function ANS1EncodeEndOfContent: AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_END_OF_CONTENT, '');
end;

function ASN1EncodeNull: AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_NULL, '');
end;

function ASN1EncodeBoolean(const A: Boolean): AnsiString;
begin
  if A then
    Result := ASN1EncodeObj(ASN1_ID_BOOLEAN, #$FF)
  else
    Result := ASN1EncodeObj(ASN1_ID_BOOLEAN, #$00);
end;

function ASN1EncodeDataInteger8(const A: ShortInt): AnsiString;
begin
  Result := AnsiChar(Byte(A));
end;

function ASN1EncodeDataInteger16(const A: SmallInt): AnsiString;
var D : AnsiString;
begin
  if (A >= MinInt8) and (A <= MaxInt8) then
    Result := ASN1EncodeDataInteger8(A)
  else
    begin
      SetLength(D, 2);
      Move(A, D[1], 2);
      Result := D;
    end;
end;

function ASN1EncodeDataInteger24(const A: LongInt): AnsiString;
var D : AnsiString;
begin
  if (A >= MinInt16) and (A <= MaxInt16) then
    Result := ASN1EncodeDataInteger16(A)
  else
    begin
      SetLength(D, 3);
      Move(A, D[1], 3);
      Result := D;
    end;
end;

function ASN1EncodeDataInteger32(const A: LongInt): AnsiString;
var D : AnsiString;
begin
  if (A >= MinInt24) and (A <= MaxInt24) then
    Result := ASN1EncodeDataInteger24(A)
  else
    begin
      SetLength(D, 4);
      Move(A, D[1], 4);
      Result := D;
    end;
end;

function ASN1EncodeDataInteger64(const A: Int64): AnsiString;
var D : AnsiString;
    F : Byte;
    B : array[0..7] of Byte;
    I, L : Integer;
begin
  Move(A, B[0], 8);
  if B[7] and $80 <> 0 then
    F := $FF
  else
    F := $00;
  L := 0;
  for I := 7 downto 1 do
    if B[I] <> F then
      begin
        L := I;
        break;
      end;
  if ((F = $00) and (B[L] and $80 <> 0)) or
     ((F = $FF) and (B[L] and $80 = 0)) then
    Inc(L);
  Inc(L);
  SetLength(D, L);
  Move(B[0], D[1], L);
  Result := D;
end;

function ASN1EncodeInteger8(const A: ShortInt): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_INTEGER, ASN1EncodeDataInteger8(A));
end;

function ASN1EncodeInteger16(const A: SmallInt): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_INTEGER, ASN1EncodeDataInteger16(A));
end;

function ASN1EncodeInteger24(const A: LongInt): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_INTEGER, ASN1EncodeDataInteger24(A));
end;

function ASN1EncodeInteger32(const A: LongInt): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_INTEGER, ASN1EncodeDataInteger32(A));
end;

function ASN1EncodeInteger64(const A: Int64): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_INTEGER, ASN1EncodeDataInteger64(A));
end;

function ASN1EncodeIntegerBuf(const A; const Size: Integer): AnsiString;
var D : AnsiString;
begin
  Assert(Size > 0);

  SetLength(D, Size);
  Move(A, D[1], Size);
  Result := ASN1EncodeObj(ASN1_ID_INTEGER, D);
end;

function ASN1EncodeIntegerBufStr(const A: AnsiString): AnsiString;
begin
  Assert(A <> '');
  
  Result := ASN1EncodeObj(ASN1_ID_INTEGER, A);
end;

function ASN1EncodeEnumerated(const A: Int64): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_ENUMERATED, ASN1EncodeDataInteger64(A));
end;

function ASN1EncodeBitString(const A: AnsiString; const UnusedBits: Byte): AnsiString;
begin
  if A = '' then
    Result := ASN1EncodeObj(ASN1_ID_BIT_STRING, AnsiChar(#0))
  else
    Result := ASN1EncodeObj(ASN1_ID_BIT_STRING, AnsiChar(UnusedBits) + A);
end;

function ASN1EncodeOctetString(const A: AnsiString): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_OCTET_STRING, A);
end;

function ASN1EncodeInt32AsOctetString(const A: LongInt): AnsiString;
var S : AnsiString;
    I : Integer;
    F : LongInt;
begin
  SetLength(S, 4);
  F := A;
  for I := 0 to 3 do
    begin
      S[4 - I] := AnsiChar(F mod 256);
      F := F div 256;
    end;
  Result := ASN1EncodeOctetString(S);
end;

function ASN1EncodeUTF8String(const A: AnsiString): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_UTF8STRING, A);
end;

function ASN1EncodeIA5String(const A: AnsiString): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_IA5STRING, A);
end;

function ASN1EncodeVisibleString(const A: AnsiString): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_VISIBLESTRING, A);
end;

function ASN1EncodeNumericString(const A: AnsiString): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_NUMERICSTRING, A);
end;

function ASN1EncodePrintableString(const A: AnsiString): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_PRINTABLESTRING, A);
end;

function ASN1EncodeTeletexString(const A: AnsiString): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_T61STRING, A);
end;

function ASN1EncodeUniversalString(const A: WideString): AnsiString;
var S : AnsiString;
begin
  S := UTF16ToEncoding(TUCS4LECodec, A);
  Result := ASN1EncodeObj(ASN1_ID_UNIVERSALSTRING, S);
end;

function ASN1EncodeBMPString(const A: WideString): AnsiString;
var S : AnsiString;
begin
  S := UTF16ToEncoding(TUCS2Codec, A);
  Result := ASN1EncodeObj(ASN1_ID_UNIVERSALSTRING, S);
end;

function ASN1EncodeUTCTime(const A: TDateTime): AnsiString;
begin
  {$IFDEF StringIsUnicode}
  Result := ASN1EncodeObj(ASN1_ID_UTCTIME, AnsiString(FormatDateTime('YYMMDDHHNNSS', A)) + 'Z');
  {$ELSE}
  Result := ASN1EncodeObj(ASN1_ID_UTCTIME, FormatDateTime('YYMMDDHHNNSS', A) + 'Z');
  {$ENDIF}
end;

function ASN1EncodeGeneralizedTime(const A: TDateTime): AnsiString;
begin
  {$IFDEF StringIsUnicode}
  Result := ASN1EncodeObj(ASN1_ID_GENERALIZEDTIME, AnsiString(FormatDateTime('YYYYMMDDHHNNSS', A)) + 'Z');
  {$ELSE}
  Result := ASN1EncodeObj(ASN1_ID_GENERALIZEDTIME, FormatDateTime('YYYYMMDDHHNNSS', A) + 'Z');
  {$ENDIF}
end;

// OID implementation limits
const
  MAX_BER_OIDPart_Len = 6;   // 6 = max 42-bit part, 10 = max 70-bit part
  MAX_BER_OID_Length  = 512;
  MAX_OID_Parts       = 64;

type
  TOIDPartEnc = record
    Len : Byte;
    Enc : array[0..MAX_BER_OIDPart_Len - 1] of Byte;
  end;

procedure ASN1BEREncodeOIDPart(const OIDPart: Integer; var Enc: TOIDPartEnc);
var N, A, B, C : Integer;
begin
  N := 0;
  A := OIDPart;
  repeat
    B := A div 128;
    C := A mod 128;
    if N > 0 then
      C := C or 128;
    if N >= MAX_BER_OIDPart_Len then
      raise EASN1.Create(SErr_EncodeError);
    Enc.Enc[N] := Byte(C);
    Inc(N);
    A := B;
  until A = 0;
  Enc.Len := N;
end;

// BER Encode OID
function ASN1EncodeOID(const OID: array of Integer): AnsiString;
var L, I, N, J, K : Integer;
    A, B, C : Integer;
    E : TOIDPartEnc;
    Buf : array[0..MAX_BER_OID_Length - 1] of Byte;
    S : AnsiString;
begin
  Result := '';
  L := Length(OID);
  if L < 2 then
    raise EASN1.Create(SErr_EncodeError);
  A := OID[0];
  B := OID[1];
  C := A * 40 + B;
  if C > $FF then
    raise EASN1.Create(SErr_EncodeError);
  N := 1;
  Buf[0] := C;
  for I := 2 to L - 1 do
    begin
      A := OID[I];
      ASN1BEREncodeOIDPart(A, E);
      K := E.Len;
      if N + K - 1 >= MAX_BER_OID_Length then
        raise EASN1.Create(SErr_EncodeError);
      for J := 0 to K - 1 do
        Buf[N + J] := E.Enc[K - J - 1];
      Inc(N, K);
    end;
  SetLength(S, N);
  Move(Buf[0], S[1], N);
  Result := ASN1EncodeObj(ASN1_ID_OBJECT_IDENTIFIER, S);
end;

function ASN1EncodeSequence(const A: AnsiString): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_SEQUENCE, A);
end;

function ASN1EncodeSet(const A: AnsiString): AnsiString;
begin
  Result := ASN1EncodeObj(ASN1_ID_SET, A);
end;

function ASN1EncodeContextSpecific(const I: Integer; const A: AnsiString): AnsiString;
begin
  Assert(I >= 0);
  Assert(I <= 31);
  Result := ASN1EncodeObj(ASN1_ID_CONSTR_CONTEXT_SPECIFIC + I, A);
end;



{ Decode }

function ASN1DecodeLength(const Buf; const Size: Integer; var Len: Integer): Integer;
var P : PByte;
    L, I : Byte;
begin
  if Size <= 0 then
    raise EASN1.Create(SErr_DecodeError); // buffer too small
  P := @Buf;
  L := P^;
  if L < $80 then
    begin
      Len := L;
      Result := 1;
      exit;
    end;
  L := L and $7F;
  if Size < L + 1 then
    raise EASN1.Create(SErr_DecodeError); // buffer too small
  if L > 3 then
    raise EASN1.Create(SErr_DecodeError); // size too big
  Len := 0;
  for I := 0 to L - 1 do
    begin
      Inc(P);
      Len := (Len shl 8) or P^;
    end;
  Result := L + 1;
end;

function ASN1DecodeObjHeader(const Buf; const Size: Integer;
         var TypeID: Byte; var Len: Integer; var Data: Pointer): Integer;
var P : PByte;
    L : Integer;
begin
  Assert(Assigned(@Buf));
  if Size < 2 then
    raise EASN1.Create(SErr_DecodeError); // buffer too small
  P := @Buf;
  TypeID := P^;
  Inc(P);
  L := ASN1DecodeLength(P^, Size - 1, Len);
  Inc(P, L);
  Data := P;
  Result := L + 1;
end;

function ASN1TypeIsConstructedType(const TypeID: Byte): Boolean;
begin
  Result := TypeID and ASN1_ID_CONSTRUCTED <> 0;
end;

function ASN1TypeIsContextSpecific(const TypeID: Byte; var Idx: Integer): Boolean;
begin
  if TypeID and ASN1_ID_CONTEXT_SPECIFIC <> 0 then
    begin
      Idx := TypeID and $1F;
      Result := True;
    end
  else
    begin
      Idx := -1;
      Result := False;
    end;
end;

function ASN1DecodeDataBoolean(const Buf; const Size: Integer; var A: Boolean): Integer;
begin
  if Size <> 1 then
    raise EASN1.Create(SErr_DecodeError);
  A := PByte(@Buf)^ <> 0;
  Result := 1;
end;

function ASN1DecodeDataInteger32(const Buf; const Size: Integer; var A: LongInt): Integer;
var P : PByte;
    L, I : Integer;
    B : array[0..3] of Byte;
    E : Byte;
begin
  P := @Buf;
  L := Size;
  if (L <= 0) or (L > 4) then
    raise EASN1.Create(SErr_DecodeError); // integer too big for LongInt
  Move(P^, B[0], L);
  if L < 4 then
    begin
      // extend sign
      if B[L - 1] >= $80 then
        E := $FF
      else
        E := $00;
      for I := L to 3 do
        B[I] := E;
    end;
  Move(B[0], A, 4);
  Result := L;
end;

function ASN1DecodeDataInteger64(const Buf; const Size: Integer; var A: Int64): Integer;
var P : PByte;
    L, I : Integer;
    B : array[0..7] of Byte;
    E : Byte;
begin
  P := @Buf;
  L := Size;
  if (L <= 0) or (L > 8) then
    raise EASN1.Create(SErr_DecodeError); // integer too big for Int64
  Move(P^, B[0], L);
  if L < 8 then
    begin
      // extend sign
      if B[L - 1] >= $80 then
        E := $FF
      else
        E := $00;
      for I := L to 7 do
        B[I] := E;
    end;
  Move(B[0], A, 8);
  Result := L;
end;

function ASN1DecodeDataIntegerBuf(const Buf; const Size: Integer; var A: AnsiString): Integer;
var L : Integer;
begin
  L := Size;
  SetLength(A, L);
  if L > 0 then
    Move(Buf, A[1], L);
  Result := L;
end;

function ASN1DecodeDataBitString(const Buf; const Size: Integer; var A: AnsiString; var UnusedBits: Byte): Integer;
var P : PByte;
    L : Integer;
    F : Byte;
begin
  P := @Buf;
  L := Size;
  if L <= 0 then
    raise EASN1.Create(SErr_DecodeError); // invalid size
  F := P^;
  if F > 7 then
    raise EASN1.Create(SErr_DecodeError); // invalid UnusedBits
  if L = 1 then
    begin
      if F <> 0 then
        raise EASN1.Create(SErr_DecodeError); // invalid size
      A := '';
      UnusedBits := 0;
      Result := 1;
      exit;
    end;
  Inc(P);
  Dec(L);
  SetLength(A, L);
  if L > 0 then
    Move(P^, A[1], L);
  UnusedBits := F;
  Result := L + 1;
end;

function ASN1DecodeDataRawAnsiString(const Buf; const Size: Integer; var A: AnsiString): Integer;
var L : Integer;
begin
  L := Size;
  SetLength(A, L);
  if L > 0 then
    Move(Buf, A[1], L);
  Result := L;
end;

function ASN1DecodeDataOctetString(const Buf; const Size: Integer; var A: AnsiString): Integer;
begin
  Result := ASN1DecodeDataRawAnsiString(Buf, Size, A);
end;

function ASN1DecodeDataIA5String(const Buf; const Size: Integer; var A: AnsiString): Integer;
begin
  Result := ASN1DecodeDataRawAnsiString(Buf, Size, A);
end;

function ASN1DecodeDataVisibleString(const Buf; const Size: Integer; var A: AnsiString): Integer;
begin
  Result := ASN1DecodeDataRawAnsiString(Buf, Size, A);
end;

function ASN1DecodeDataNumericString(const Buf; const Size: Integer; var A: AnsiString): Integer;
begin
  Result := ASN1DecodeDataRawAnsiString(Buf, Size, A);
end;

function ASN1DecodeDataPrintableString(const Buf; const Size: Integer; var A: AnsiString): Integer;
begin
  Result := ASN1DecodeDataRawAnsiString(Buf, Size, A);
end;

function ASN1DecodeDataTeletexString(const Buf; const Size: Integer; var A: AnsiString): Integer;
begin
  Result := ASN1DecodeDataRawAnsiString(Buf, Size, A);
end;

function ASN1DecodeDataUTF8String(const Buf; const Size: Integer; var A: AnsiString): Integer;
begin
  Result := ASN1DecodeDataRawAnsiString(Buf, Size, A);
end;

function ASN1DecodeDataUniversalString(const Buf; const Size: Integer; var A: AnsiString): Integer;
begin
  A := WideStringToUTF8String(EncodingToUTF16(TUCS4LECodec, @Buf, Size));
  Result := Size;
end;

function ASN1DecodeDataBMPString(const Buf; const Size: Integer; var A: AnsiString): Integer;
begin
  A := WideStringToUTF8String(EncodingToUTF16(TUCS2Codec, @Buf, Size));
  Result := Size;
end;

function ASN1DecodeOIDPart(const Buf; const Size: Integer; var Part: Integer): Integer;
var P : PByte;
    L, C : Integer;
    A : Byte;
    R : Boolean;
    V : Int64;
begin
  P := @Buf;
  L := Size;
  C := 1;
  V := 0;
  repeat
    if L < 0 then
      raise EASN1.Create(SErr_DecodeError);
    if C > MAX_BER_OIDPart_Len then
      raise EASN1.Create(SErr_DecodeError); // too many bytes in this OID part
    A := P^;
    R := A and 128 = 0;
    V := (V shl 7) or (A and 127);
    Inc(P);
    Dec(L);
    Inc(C);
  until R;
  if V > MaxLongint then
    raise EASN1.Create(SErr_DecodeError); // value too large
  Part := V;
  Result := Size - L;
end;

function ASN1DecodeDataOID(const Buf; const Size: Integer; var A: TASN1ObjectIdentifier): Integer;
var P : PByte;
    L, N, C, I : Integer;
    F : Byte;
    Parts : array[0..MAX_OID_Parts - 1] of Integer;
begin
  P := @Buf;
  L := Size;
  if L < 1 then
    raise EASN1.Create(SErr_DecodeError);
  F := P^;
  Parts[0] := F div 40;
  Parts[1] := F mod 40;
  Inc(P);
  Dec(L);
  N := 2;
  while L > 0 do
    begin
      if N >= MAX_OID_Parts then
        raise EASN1.Create(SErr_DecodeError);
      C := ASN1DecodeOIDPart(P^, L, Parts[N]);
      Inc(P, C);
      Dec(L, C);
      Inc(N);
    end;
  SetLength(A, N);
  for I := 0 to N - 1 do
    A[I] := Parts[I];
  Result := Size - L;
end;

function ASN1DecodeDataUTCTime(const Buf; const Size: Integer; var A: TDateTime): Integer;
var D : AnsiString;
    YYYY, YY, MM, DD, HH, NN, SS : Integer;
begin
  if Size < 6 then
    raise EASN1.Create(SErr_DecodeError);
  SetLength(D, Size);
  Move(Buf, D[1], Size);
  if not TryStringToIntA(Copy(D, 1, 2), YY) then
    raise EASN1.Create(SErr_DecodeError);
  if not TryStringToIntA(Copy(D, 3, 2), MM) then
    raise EASN1.Create(SErr_DecodeError);
  if not TryStringToIntA(Copy(D, 5, 2), DD) then
    raise EASN1.Create(SErr_DecodeError);
  HH := 0;
  NN := 0;
  SS := 0;
  if Size >= 10 then
    begin
      if not TryStringToIntA(Copy(D, 7, 2), HH) then
        raise EASN1.Create(SErr_DecodeError);
      if not TryStringToIntA(Copy(D, 9, 2), NN) then
        raise EASN1.Create(SErr_DecodeError);
      if Size >= 12 then
        if not TryStringToIntA(Copy(D, 11, 2), SS) then
          raise EASN1.Create(SErr_DecodeError);
    end;
  if YY <= 49 then
    YYYY := 2000 + YY
  else
    YYYY := 1900 + YY;
  A := EncodeDate(YYYY, MM, DD) +
       EncodeTime(HH, NN, SS, 0);
  Result := Size;
end;

function ASN1DecodeDataGeneralizedTime(const Buf; const Size: Integer; var A: TDateTime): Integer;
var D : AnsiString;
    YYYY, MM, DD, HH, NN, SS : Integer;
begin
  if Size < 8 then
    raise EASN1.Create(SErr_DecodeError);
  SetLength(D, Size);
  Move(Buf, D[1], Size);
  if not TryStringToIntA(Copy(D, 1, 4), YYYY) then
    raise EASN1.Create(SErr_DecodeError);
  if not TryStringToIntA(Copy(D, 5, 2), MM) then
    raise EASN1.Create(SErr_DecodeError);
  if not TryStringToIntA(Copy(D, 7, 2), DD) then
    raise EASN1.Create(SErr_DecodeError);
  HH := 0;
  NN := 0;
  SS := 0;
  if Size >= 12 then
    begin
      if not TryStringToIntA(Copy(D, 9, 2), HH) then
        raise EASN1.Create(SErr_DecodeError);
      if not TryStringToIntA(Copy(D, 11, 2), NN) then
        raise EASN1.Create(SErr_DecodeError);
      if Size >= 14 then
        if not TryStringToIntA(Copy(D, 13, 2), SS) then
          raise EASN1.Create(SErr_DecodeError);
    end;
  A := EncodeDate(YYYY, MM, DD) +
       EncodeTime(HH, NN, SS, 0);
  Result := Size;
end;

function ASN1Parse(const Buf; const Size: Integer; const ParseProc: TASN1ParseProc; const CallerData: Integer): Integer;
var P : PByte;
    L, N, T : Integer;
    ObjIdx : Integer;
    TypeID : Byte;
    Len : Integer;
    Data : Pointer;
begin
  P := @Buf;
  L := Size;
  if (L < 0) or not Assigned(P) then
    raise EASN1.Create(SErr_DecodeError); // invalid buffer
  if L = 0 then
    begin
      // nothing to parse
      Result := 0;
      exit;
    end;
  // iterate top level ASN.1 objects in buffer
  ObjIdx := 0;
  while L > 0 do
    begin
      N := ASN1DecodeObjHeader(P^, L, TypeID, Len, Data);
      T := N + Len;
      if T > L then
        raise EASN1.Create(SErr_DecodeError); // invalid length encoded in header
      ParseProc(TypeID, Data^, Len, ObjIdx, CallerData);
      Inc(P, T);
      Dec(L, T);
      Inc(ObjIdx);
    end;
  Result := Size - L;
end;

function ASN1DecodeBoolean(const TypeID: Byte; const DataBuf; const DataSize: Integer; var A: Boolean): Integer;
var I : Int64;
begin
  case TypeID of
    ASN1_ID_BOOLEAN : Result := ASN1DecodeDataBoolean(DataBuf, DataSize, A);
    ASN1_ID_INTEGER :
      begin
        Result := ASN1DecodeDataInteger64(DataBuf, DataSize, I);
        A := I <> 0;
      end;
  else
    raise EASN1.Create(SErr_DecodeInvalidType);
  end;
end;

function ASN1DecodeInteger32(const TypeID: Byte; const DataBuf; const DataSize: Integer;
         var A: LongInt): Integer;
var I : Int64;
begin
  Result := ASN1DecodeInteger64(TypeID, DataBuf, DataSize, I);
  if (I > High(LongInt)) or (I < Low(LongInt)) then
    raise EASN1.Create(SErr_DecodeError);
  A := I;
end;

function ASN1DecodeInteger64(const TypeID: Byte; const DataBuf; const DataSize: Integer;
         var A: Int64): Integer;
var S : AnsiString;
begin
  case TypeID of
    ASN1_ID_INTEGER      : Result := ASN1DecodeDataInteger64(DataBuf, DataSize, A);
    ASN1_ID_OCTET_STRING,
    ASN1_ID_UTF8STRING,
    ASN1_ID_NUMERICSTRING,
    ASN1_ID_PRINTABLESTRING,
    ASN1_ID_VISIBLESTRING,
    ASN1_ID_T61STRING,
    ASN1_ID_UNIVERSALSTRING,
    ASN1_ID_BMPSTRING :
      begin
        Result := ASN1DecodeString(TypeID, DataBuf, DataSize, S);
        if not TryStringToInt64A(S, A) then
          raise EASN1.Create(SErr_DecodeConversionError);
      end;
  else
    raise EASN1.Create(SErr_DecodeInvalidType);
  end;
end;

function ASN1DecodeIntegerBuf(const TypeID: Byte; const DataBuf; const DataSize: Integer;
         var A: AnsiString): Integer;
begin
  case TypeID of
    ASN1_ID_INTEGER : Result := ASN1DecodeDataIntegerBuf(DataBuf, DataSize, A);
  else
    raise EASN1.Create(SErr_DecodeInvalidType);
  end;
end;

function ASN1DecodeBitString(const TypeID: Byte; const DataBuf; const DataSize: Integer; var A: AnsiString; var UnusedBits: Byte): Integer;
begin
  case TypeID of
    ASN1_ID_BIT_STRING : Result := ASN1DecodeDataBitString(DataBuf, DataSize, A, UnusedBits);
  else
    raise EASN1.Create(SErr_DecodeInvalidType);
  end;
end;

type
  TStringParseData = record
    Delim : AnsiString;
    Str   : AnsiString;
  end;
  PStringParseData = ^TStringParseData;

procedure StringParseProc(const TypeID: Byte; const DataBuf; const DataSize: Integer;
          const ObjectIdx: Integer; const CallerData: Integer);
var S : AnsiString;
    D : PStringParseData;
begin
  ASN1DecodeString(TypeID, DataBuf, DataSize, S);
  D := Pointer(CallerData);
  if (ObjectIdx > 0) and (D^.Delim <> '') then
    D^.Str := D^.Str + D^.Delim;
  D^.Str := D^.Str + S;
end;

function ASN1DecodeString(const TypeID: Byte; const DataBuf; const DataSize: Integer;
         var A: AnsiString): Integer;
var I : Int64;
    B : TASN1ObjectIdentifier;
    D : TStringParseData;
    K : Byte;
begin
  if ASN1TypeIsConstructedType(TypeID) then
    begin
      D.Delim := ' ';
      Result := ASN1Parse(DataBuf, DataSize, StringParseProc, Integer(@D));
      A := D.Str;
    end
  else
    case TypeID of
      ASN1_ID_OCTET_STRING    : Result := ASN1DecodeDataOctetString(DataBuf, DataSize, A);
      ASN1_ID_UTF8STRING      : Result := ASN1DecodeDataUTF8String(DataBuf, DataSize, A);
      ASN1_ID_NUMERICSTRING   : Result := ASN1DecodeDataNumericString(DataBuf, DataSize, A);
      ASN1_ID_PRINTABLESTRING : Result := ASN1DecodeDataPrintableString(DataBuf, DataSize, A);
      ASN1_ID_VISIBLESTRING   : Result := ASN1DecodeDataVisibleString(DataBuf, DataSize, A);
      ASN1_ID_T61STRING       : Result := ASN1DecodeDataTeletexString(DataBuf, DataSize, A);
      ASN1_ID_UNIVERSALSTRING : Result := ASN1DecodeDataUniversalString(DataBuf, DataSize, A);
      ASN1_ID_BMPSTRING       : Result := ASN1DecodeDataBMPString(DataBuf, DataSize, A);
      ASN1_ID_BIT_STRING      : Result := ASN1DecodeDataBitString(DataBuf, DataSize, A, K);
      ASN1_ID_IA5STRING       : Result := ASN1DecodeDataIA5String(DataBuf, DataSize, A);
      ASN1_ID_INTEGER :
        begin
          Result := ASN1DecodeDataInteger64(DataBuf, DataSize, I);
          A := IntToStringA(I);
        end;
      ASN1_ID_OBJECT_IDENTIFIER :
        begin
          Result := ASN1DecodeDataOID(DataBuf, DataSize, B);
          A := ASN1OIDToStr(B);
        end;
    else
      raise EASN1.Create(SErr_DecodeInvalidType);
    end;
end;

function ASN1DecodeOID(const TypeID: Byte; const DataBuf; const DataSize: Integer;
         var A: TASN1ObjectIdentifier): Integer;
begin
  case TypeID of
    ASN1_ID_OBJECT_IDENTIFIER : Result := ASN1DecodeDataOID(DataBuf, DataSize, A);
  else
    raise EASN1.Create(SErr_DecodeInvalidType);
  end;
end;

function ASN1DecodeTime(const TypeID: Byte; const DataBuf; const DataSize: Integer; var A: TDateTime): Integer;
begin
  case TypeID of
    ASN1_ID_UTCTIME         : Result := ASN1DecodeDataUTCTime(DataBuf, DataSize, A);
    ASN1_ID_GENERALIZEDTIME : Result := ASN1DecodeDataGeneralizedTime(DataBuf, DataSize, A);
  else
    raise EASN1.Create(SErr_DecodeInvalidType);
  end;
end;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF DEBUG}{$IFDEF SELFTEST}
{$ASSERTIONS ON}
procedure SelfTestParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: Integer;
          const ObjectIdx: Integer; const CallerData: Integer);
var I : Int64;
    S : AnsiString;
begin
  case CallerData of
    0 : case ObjectIdx of
          0 : begin
                Assert(TypeID = ASN1_ID_SEQUENCE);
                Assert(ASN1Parse(DataBuf, DataSize, SelfTestParseProc, 1) = DataSize);
              end;
        else
          Assert(False);
        end;
    1 : case ObjectIdx of
          0 : begin
                Assert(TypeID = ASN1_ID_INTEGER);
                ASN1DecodeInteger64(TypeID, DataBuf, DataSize, I);
                Assert(I = 123);
              end;
          1 : begin
                Assert(TypeID = ASN1_ID_PRINTABLESTRING);
                ASN1DecodeString(TypeID, DataBuf, DataSize, S);
                Assert(S = 'ABC');
              end;
        else
          Assert(False);
        end;
  else
    Assert(False);
  end;
end;

procedure SelfTest;
var S : AnsiString;
    L, I, J : Integer;
    D : TASN1ObjectIdentifier;
begin
  Assert(ASN1EncodeLength(0) = #$00);
  Assert(ASN1EncodeLength(1) = #$01);
  Assert(ASN1EncodeLength($7F) = #$7F);
  Assert(ASN1EncodeLength($80) = #$81#$80);
  Assert(ASN1EncodeLength($FF) = #$81#$FF);
  Assert(ASN1EncodeLength($100) = #$82#$01#$00);

  Assert(ASN1EncodeOID(OID_3DESWrap) = #$06#$0b#$2a#$86#$48#$86#$f7#$0d#$01#$09#$10#$03#$06);
  Assert(ASN1EncodeOID(OID_RC2Wrap)  = #$06#$0b#$2a#$86#$48#$86#$f7#$0d#$01#$09#$10#$03#$07);

  S := #$2a#$86#$48#$86#$f7#$0d#$01#$09#$10#$03#$06;
  L := Length(S);
  Assert(ASN1DecodeDataOID(S[1], L, D) = L);
  Assert(Length(D) = 9);
  Assert((D[0] = 1) and (D[1] = 2) and (D[2] = 840) and (D[3] = 113549) and
         (D[4] = 1) and (D[5] = 9) and (D[6] = 16) and (D[7] = 3) and (D[8] = 6));
  Assert(ASN1OIDToStr(D) = '1.2.840.113549.1.9.16.3.6');

  Assert(ASN1EncodeInteger32(0) = #$02#$01#$00);
  Assert(ASN1EncodeInteger32(1) = #$02#$01#$01);
  Assert(ASN1EncodeInteger32(-1) = #$02#$01#$FF);
  Assert(ASN1EncodeInteger32(-$80) = #$02#$01#$80);
  Assert(ASN1EncodeInteger32(-$81) = #$02#$02#$7F#$FF);
  Assert(ASN1EncodeInteger32(-$FF) = #$02#$02#$01#$FF);
  Assert(ASN1EncodeInteger32($7F) = #$02#$01#$7F);
  Assert(ASN1EncodeInteger32($80) = #$02#$02#$80#$00);
  Assert(ASN1EncodeInteger32($FF) = #$02#$02#$FF#$00);
  
  for I := -512 to 512 do
    begin
      S := ASN1EncodeInteger32(I);
      Assert(S = ASN1EncodeInteger64(I));
      L := Length(S);
      Assert(ASN1DecodeDataInteger32(S[3], L - 2, J) = L - 2);
      Assert(J = I);
    end;

  S :=
    ASN1EncodeSequence(
        ASN1EncodeInteger32(123) +
        ASN1EncodePrintableString('ABC')
        );
  L := Length(S);
  Assert(L > 0);
  Assert(ASN1Parse(S[1], L, SelfTestParseProc, 0) = L);
end;
{$ENDIF}{$ENDIF}



end.

