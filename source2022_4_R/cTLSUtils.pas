{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals TLS                                         }
{   File name:        cTLSUtils.pas                                            }
{   File version:     0.03                                                     }
{   Description:      TLS utilities                                            }
{                                                                              }
{   Copyright:        Copyright (c) 2008-2012, David J Butler                  }
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
{ Revision history:                                                            }
{                                                                              }
{   2008/01/18  0.01  Initial version.                                         }
{   2010/11/30  0.02  Revision.                                                }
{   2011/10/13  0.03  Fix SSL3 keyblock.                                       }
{                                                                              }
{******************************************************************************}

//{$INCLUDE cTLS.inc}

{$DEFINE TLS_SELFTEST}


unit cTLSUtils;

interface

uses
  { System }
  SysUtils;



{                                                                              }
{ TLS library                                                                  }
{                                                                              }
const
  TLSLibraryVersion = '1.00';



{                                                                              }
{ Errors                                                                       }
{                                                                              }
const
  TLSError_None               = 0;
  TLSError_InvalidBuffer      = 1;
  TLSError_InvalidParameter   = 2;
  TLSError_InvalidCertificate = 3;
  TLSError_InvalidState       = 4;
  TLSError_DecodeError        = 5;
  TLSError_BadProtocol        = 6;

function TLSErrorMessage(const TLSError: Integer): String;

type
  ETLSError = class(Exception)
  private
    FTLSError : Integer;
  public
    constructor Create(const TLSError: Integer; const Msg: String = '');
    property TLSError: Integer read FTLSError;
  end;



{                                                                              }
{ ProtocolVersion                                                              }
{                                                                              }
type
  TTLSProtocolVersion = packed record
    major, minor : Byte;
  end;
  PTLSProtocolVersion = ^TTLSProtocolVersion;

const
  TLSProtocolVersionSize = Sizeof(TTLSProtocolVersion);

  SSLProtocolVersion20 : TTLSProtocolVersion = (major: 0; minor: 2);
  SSLProtocolVersion30 : TTLSProtocolVersion = (major: 3; minor: 0);
  TLSProtocolVersion10 : TTLSProtocolVersion = (major: 3; minor: 1);
  TLSProtocolVersion11 : TTLSProtocolVersion = (major: 3; minor: 2);
  TLSProtocolVersion12 : TTLSProtocolVersion = (major: 3; minor: 3);

procedure InitSSLProtocolVersion30(var A: TTLSProtocolVersion);
procedure InitTLSProtocolVersion10(var A: TTLSProtocolVersion);
procedure InitTLSProtocolVersion11(var A: TTLSProtocolVersion);
procedure InitTLSProtocolVersion12(var A: TTLSProtocolVersion);
function  IsTLSProtocolVersion(const A, B: TTLSProtocolVersion): Boolean;
function  IsSSL2(const A: TTLSProtocolVersion): Boolean;
function  IsSSL3(const A: TTLSProtocolVersion): Boolean;
function  IsTLS10(const A: TTLSProtocolVersion): Boolean;
function  IsTLS11(const A: TTLSProtocolVersion): Boolean;
function  IsTLS12(const A: TTLSProtocolVersion): Boolean;
function  IsTLS10OrLater(const A: TTLSProtocolVersion): Boolean;
function  IsTLS11OrLater(const A: TTLSProtocolVersion): Boolean;
function  IsTLS12OrLater(const A: TTLSProtocolVersion): Boolean;
function  IsFutureTLSVersion(const A: TTLSProtocolVersion): Boolean;
function  IsKnownTLSVersion(const A: TTLSProtocolVersion): Boolean;
function  TLSProtocolVersionToStr(const A: TTLSProtocolVersion): String;
function  TLSProtocolVersionName(const A: TTLSProtocolVersion): String;



{                                                                              }
{ CompressionMethod                                                            }
{                                                                              }
type
  TTLSCompressionMethod = (
    tlscmNull    = 0,
    tlscmDeflate = 1,
    tlscmMax     = 255);
  PTLSCompressionMethod = ^TTLSCompressionMethod;

  TTLSCompressionMethods = set of TTLSCompressionMethod;

const
  TLSCompressionMethodSize = Sizeof(TTLSCompressionMethod);



{                                                                              }
{ Random                                                                       }
{                                                                              }
type
  TTLSRandom = packed record
    gmt_unix_time : LongWord;
    random_bytes  : array[0..27] of Byte;
  end;
  PTLSRandom = ^TTLSRandom;

const
  TLSRandomSize = Sizeof(TTLSRandom);

procedure InitTLSRandom(var Random: TTLSRandom);
function  TLSRandomToStr(const Random: TTLSRandom): AnsiString;



{                                                                              }
{ SessionID                                                                    }
{                                                                              }
const
  TLSSessionIDMaxLen = 32;

type
  TTLSSessionID = String[TLSSessionIDMaxLen];

procedure InitTLSSessionID(var SessionID: TTLSSessionID; const A: AnsiString);
function  EncodeTLSSessionID(var Buffer; const Size: Integer; const SessionID: TTLSSessionID): Integer;
function  DecodeTLSSessionID(const Buffer; const Size: Integer; var SessionID: TTLSSessionID): Integer;



{                                                                              }
{ HashAlgorithm                                                                }
{                                                                              }
type
  TTLSHashAlgorithm = (
    tlshaNone   = 0,
    tlshaMD5    = 1,
    tlshaSHA1   = 2,
    tlshaSHA224 = 3,
    tlshaSHA256 = 4,
    tlshaSHA384 = 5,
    tlshaSHA512 = 6,
    tlshaMax    = 255);
  TTLSHashAlgorithms = set of TTLSHashAlgorithm;



{                                                                              }
{ SignatureAlgorithm                                                           }
{                                                                              }
type
  TTLSSignatureAlgorithm = (
    tlssaAnonymous = 0,
    tlssaRSA       = 1,
    tlssaDSA       = 2,
    tlssaECDSA     = 3,
    tlssaMax       = 255);
  TTLSSignatureAlgorithms = set of TTLSSignatureAlgorithm;



{                                                                              }
{ SignatureAndHashAlgorithm                                                    }
{                                                                              }
type
  TTLSSignatureAndHashAlgorithm = packed record
    Hash      : TTLSHashAlgorithm;
    Signature : TTLSSignatureAlgorithm;
  end;
  PTLSSignatureAndHashAlgorithm = ^TTLSSignatureAndHashAlgorithm;
  TTLSSignatureAndHashAlgorithmArray = array of TTLSSignatureAndHashAlgorithm;

const
  TLSSignatureAndHashAlgorithmSize = SizeOf(TTLSSignatureAndHashAlgorithm);



{                                                                              }
{ KeyExchangeAlgorithm                                                         }
{                                                                              }
type
  TTLSKeyExchangeAlgorithm = (
    tlskeaNone,
    tlskeaNULL,
    tlskeaDHE_DSS,
    tlskeaDHE_RSA,
    tlskeaDH_Anon,
    tlskeaRSA,
    tlskeaDH_DSS,
    tlskeaDH_RSA);



{                                                                              }
{ MACAlgorithm                                                                 }
{                                                                              }
type
  TTLSMACAlgorithm = (
    tlsmaNone,
    tlsmaNULL,
    tlsmaHMAC_MD5,
    tlsmaHMAC_SHA1,
    tlsmaHMAC_SHA256,
    tlsmaHMAC_SHA384,
    tlsmaHMAC_SHA512);

  TTLSMacAlgorithmInfo = record
    Name       : AnsiString;
    DigestSize : Integer;
    Supported  : Boolean;
  end;
  PTLSMacAlgorithmInfo = ^TTLSMacAlgorithmInfo;

const
  TLSMACAlgorithmInfo : array[TTLSMACAlgorithm] of TTLSMacAlgorithmInfo = (
    ( // None
     Name       : '';
     DigestSize : 0;
     Supported  : False;
    ),
    ( // NULL
     Name       : 'NULL';
     DigestSize : 0;
     Supported  : True;
    ),
    ( // HMAC_MD5
     Name       : 'HMAC-MD5';
     DigestSize : 16;
     Supported  : True;
    ),
    ( // HMAC_SHA1
     Name       : 'HMAC-SHA1';
     DigestSize : 20;
     Supported  : True;
    ),
    ( // HMAC_SHA256
     Name       : 'HMAC-SHA256';
     DigestSize : 32;
     Supported  : True;
    ),
    ( // HMAC_SHA384
     Name       : 'HMAC-SHA384';
     DigestSize : 48;
     Supported  : False;
    ),
    ( // HMAC_SHA512
     Name       : 'HMAC-SHA512';
     DigestSize : 64;
     Supported  : True;
    )
    );

const
  TLS_MAC_MAXDIGESTSIZE = 64;



{                                                                              }
{ PRFAlgorithm                                                                 }
{                                                                              }
type
  TTLSPRFAlgorithm = (
    tlspaSHA256);



{                                                                              }
{ PRF (Pseudo-Random Function)                                                 }
{                                                                              }
function  tlsP_MD5(const Secret, Seed: AnsiString; const Size: Integer): AnsiString;
function  tlsP_SHA1(const Secret, Seed: AnsiString; const Size: Integer): AnsiString;
function  tlsP_SHA256(const Secret, Seed: AnsiString; const Size: Integer): AnsiString;
function  tlsP_SHA512(const Secret, Seed: AnsiString; const Size: Integer): AnsiString;

function  tls10PRF(const Secret, ALabel, Seed: AnsiString; const Size: Integer): AnsiString;
function  tls12PRF_SHA256(const Secret, ALabel, Seed: AnsiString; const Size: Integer): AnsiString;
function  tls12PRF_SHA512(const Secret, ALabel, Seed: AnsiString; const Size: Integer): AnsiString;

function  TLSPRF(const ProtocolVersion: TTLSProtocolVersion;
          const Secret, ALabel, Seed: AnsiString; const Size: Integer): AnsiString;



{                                                                              }
{ Key block                                                                    }
{                                                                              }
function  tls10KeyBlock(const MasterSecret, ServerRandom, ClientRandom: AnsiString; const Size: Integer): AnsiString;
function  tls12SHA256KeyBlock(const MasterSecret, ServerRandom, ClientRandom: AnsiString; const Size: Integer): AnsiString;
function  tls12SHA512KeyBlock(const MasterSecret, ServerRandom, ClientRandom: AnsiString; const Size: Integer): AnsiString;

function  TLSKeyBlock(const ProtocolVersion: TTLSProtocolVersion;
          const MasterSecret, ServerRandom, ClientRandom: AnsiString; const Size: Integer): AnsiString;



{                                                                              }
{ Master secret                                                                }
{                                                                              }
function  tls10MasterSecret(const PreMasterSecret, ClientRandom, ServerRandom: AnsiString): AnsiString;
function  tls12SHA256MasterSecret(const PreMasterSecret, ClientRandom, ServerRandom: AnsiString): AnsiString;
function  tls12SHA512MasterSecret(const PreMasterSecret, ClientRandom, ServerRandom: AnsiString): AnsiString;

function  TLSMasterSecret(const ProtocolVersion: TTLSProtocolVersion;
          const PreMasterSecret, ClientRandom, ServerRandom: AnsiString): AnsiString;



{                                                                              }
{ TLS Keys                                                                     }
{                                                                              }
type
  TTLSKeys = record
    KeyBlock     : AnsiString; 
    ClientMACKey : AnsiString;
    ServerMACKey : AnsiString;
    ClientEncKey : AnsiString;
    ServerEncKey : AnsiString;
    ClientIV     : AnsiString;
    ServerIV     : AnsiString;
  end;

procedure GenerateTLSKeys(
          const ProtocolVersion: TTLSProtocolVersion;
          const MACKeyBits, CipherKeyBits, IVBits: Integer;
          const MasterSecret, ServerRandom, ClientRandom: AnsiString;
          var TLSKeys: TTLSKeys);

procedure GenerateFinalTLSKeys(
          const ProtocolVersion: TTLSProtocolVersion;
          const IsExportable: Boolean;
          const ExpandedKeyBits: Integer;
          const ServerRandom, ClientRandom: AnsiString;
          var TLSKeys: TTLSKeys);



{                                                                              }
{ TLS Limits                                                                   }
{                                                                              }
const
  TLS_PLAINTEXT_FRAGMENT_MAXSIZE  = 16384 - 1;    // 2^14 - 1
  TLS_COMPRESSED_FRAGMENT_MAXSIZE = 16384 + 1024; // 2^14 + 1024



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF TLS_SELFTEST}
procedure SelfTest;
{$ENDIF}



implementation

uses
  { Fundamentals }
  //cStrings,
  cHash,
  cCipherRandom, StrUtils;



{                                                                              }
{ Errors                                                                       }
{                                                                              }
const
  SErr_InvalidBuffer      = 'Invalid buffer';
  SErr_InvalidCertificate = 'Invalid certificate';
  SErr_InvalidParameter   = 'Invalid parameter';
  SErr_InvalidState       = 'Invalid state';
  SErr_DecodeError        = 'Decode error';
  SErr_BadProtocol        = 'Bad protocol';

function TLSErrorMessage(const TLSError: Integer): String;
begin
  case TLSError of
    TLSError_None               : Result := '';
    TLSError_InvalidBuffer      : Result := SErr_InvalidBuffer;
    TLSError_InvalidParameter   : Result := SErr_InvalidParameter;
    TLSError_InvalidCertificate : Result := SErr_InvalidCertificate;
    TLSError_InvalidState       : Result := SErr_InvalidState;
    TLSError_DecodeError        : Result := SErr_DecodeError;
    TLSError_BadProtocol        : Result := SErr_BadProtocol;
  else
    Result := '[TLSError#' + IntToStr(TLSError) + ']';
  end;
end;

constructor ETLSError.Create(const TLSError: Integer; const Msg: String);
var S : String;
begin
  FTLSError := TLSError;
  if Msg = '' then
    S := TLSErrorMessage(TLSError)
  else
    S := Msg;
  inherited Create(S);
end;



{                                                                              }
{ ProtocolVersion                                                              }
{                                                                              }
procedure InitSSLProtocolVersion30(var A: TTLSProtocolVersion);
begin
  A := SSLProtocolVersion30;
end;

procedure InitTLSProtocolVersion10(var A: TTLSProtocolVersion);
begin
  A := TLSProtocolVersion10;
end;

procedure InitTLSProtocolVersion11(var A: TTLSProtocolVersion);
begin
  A := TLSProtocolVersion11;
end;

procedure InitTLSProtocolVersion12(var A: TTLSProtocolVersion);
begin
  A := TLSProtocolVersion12;
end;

function IsTLSProtocolVersion(const A, B: TTLSProtocolVersion): Boolean;
begin
  Result :=
      (A.major = B.major) and
      (A.minor = B.minor);
end;

function IsSSL2(const A: TTLSProtocolVersion): Boolean;
begin
  Result := IsTLSProtocolVersion(A, SSLProtocolVersion20);
end;

function IsSSL3(const A: TTLSProtocolVersion): Boolean;
begin
  Result := IsTLSProtocolVersion(A, SSLProtocolVersion30);
end;

function IsTLS10(const A: TTLSProtocolVersion): Boolean;
begin
  Result := IsTLSProtocolVersion(A, TLSProtocolVersion10);
end;

function IsTLS11(const A: TTLSProtocolVersion): Boolean;
begin
  Result := IsTLSProtocolVersion(A, TLSProtocolVersion11);
end;

function IsTLS12(const A: TTLSProtocolVersion): Boolean;
begin
  Result := IsTLSProtocolVersion(A, TLSProtocolVersion12);
end;

function IsTLS10OrLater(const A: TTLSProtocolVersion): Boolean;
begin
  Result :=
      ((A.major =  TLSProtocolVersion10.major) and
       (A.minor >= TLSProtocolVersion10.minor))
      or
       (A.major >  TLSProtocolVersion10.major);
end;

function IsTLS11OrLater(const A: TTLSProtocolVersion): Boolean;
begin
  Result :=
      ((A.major =  TLSProtocolVersion11.major) and
       (A.minor >= TLSProtocolVersion11.minor))
      or
       (A.major >  TLSProtocolVersion11.major);
end;

function IsTLS12OrLater(const A: TTLSProtocolVersion): Boolean;
begin
  Result :=
      ((A.major =  TLSProtocolVersion12.major) and
       (A.minor >= TLSProtocolVersion12.minor))
      or
       (A.major >  TLSProtocolVersion12.major);
end;

function IsFutureTLSVersion(const A: TTLSProtocolVersion): Boolean;
begin
  Result :=
      ((A.major = TLSProtocolVersion12.major) and
       (A.minor > TLSProtocolVersion12.minor))
      or
       (A.major > TLSProtocolVersion12.major);
end;

function IsKnownTLSVersion(const A: TTLSProtocolVersion): Boolean;
begin
  Result :=
      (A.major = 3) and
      (A.minor <= 3);
end;

function TLSProtocolVersionToStr(const A: TTLSProtocolVersion): String;
begin
  Result := IntToStr(A.major) + '.' + IntToStr(A.minor);
end;

function TLSProtocolVersionName(const A: TTLSProtocolVersion): String;
begin
  if IsSSL2(A) then
    Result := 'SSL2' else
  if IsSSL3(A) then
    Result := 'SSL3' else
  if IsTLS10(A) then
    Result := 'TLS1.0' else
  if IsTLS11(A) then
    Result := 'TLS1.1' else
  if IsTLS12(A) then
    Result := 'TLS1.2'
  else
    Result := '[TLS' + TLSProtocolVersionToStr(A) + ']';
end;



{                                                                              }
{ Random                                                                       }
{   gmt_unix_time     The current time and date in standard UNIX               }
{                     32-bit format according to the sender's                  }
{                     internal clock.  Clocks are not required to be           }
{                     set correctly by the basic SSL Protocol; higher          }
{                     level or application protocols may define                }
{                     additional requirements.                                 }
{   random_bytes      28 bytes generated by a secure random number             }
{                     generator.                                               }
{                                                                              }
procedure InitTLSRandom(var Random: TTLSRandom);
begin
  Random.gmt_unix_time := LongWord(DateTimeToFileDate(Now));
  SecureRandomBuf(Random.random_bytes, 28);
end;

function TLSRandomToStr(const Random: TTLSRandom): AnsiString;
begin
  SetLength(Result, TLSRandomSize);
  Move(Random, Result[1], TLSRandomSize);
end;



{                                                                              }
{ SessionID                                                                    }
{   length    : Byte;                                                          }
{   SessionID : <0..32>;                                                       }
{                                                                              }
procedure InitTLSSessionID(var SessionID: TTLSSessionID; const A: AnsiString);
begin
  if Length(A) > TLSSessionIDMaxLen then
    raise ETLSError.Create(TLSError_InvalidParameter, 'Invalid SessionID length');
  FillChar(SessionID[1], TLSSessionIDMaxLen, 0);
  SessionID := A;
end;

function EncodeTLSSessionID(var Buffer; const Size: Integer; const SessionID: TTLSSessionID): Integer;
var L : Byte;
    N : Integer;
    P : PByte;
begin
  L := Length(SessionID);
  N := L + 1;
  if Size < N then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  P := @Buffer;
  P^ := L;
  Inc(P);
  if L > 0 then
    Move(SessionID[1], P^, L);
  Result := N;
end;

function DecodeTLSSessionID(const Buffer; const Size: Integer; var SessionID: TTLSSessionID): Integer;
var L : Byte;
    P : PByte;
begin
  if Size < 1 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  P := @Buffer;
  L := P^;
  if L = 0 then
    begin
      SessionID := '';
      Result := 1;
    end
  else
    begin
      if Size < 1 + L then
        raise ETLSError.Create(TLSError_InvalidBuffer);
      if L > TLSSessionIDMaxLen then
        raise ETLSError.Create(TLSError_DecodeError); // invalid length
      SetLength(SessionID, L);
      Inc(P);
      Move(P^, SessionID[1], L);
      Result := 1 + L;
    end;
end;



{                                                                              }
{ P_hash                                                                       }
{ P_hash(secret, seed) = HMAC_hash(secret, A(1) + seed) +                      }
{                        HMAC_hash(secret, A(2) + seed) +                      }
{                        HMAC_hash(secret, A(3) + seed) + ...                  }
{ Where + indicates concatenation.                                             }
{ A() is defined as:                                                           }
{     A(0) = seed                                                              }
{     A(i) = HMAC_hash(secret, A(i-1))                                         }
{                                                                              }
function tlsP_MD5(const Secret, Seed: AnsiString; const Size: Integer): AnsiString;
var A, P : AnsiString;
    L : Integer;
begin
  P := '';
  L := 0;
  A := Seed;
  repeat
    A := MD5DigestToStrA(CalcHMAC_MD5(Secret, A));
    P := P + MD5DigestToStrA(CalcHMAC_MD5(Secret, A + Seed));
    Inc(L, 16);
  until L >= Size;
  if L > Size then
    SetLength(P, Size);
  Result := P;
end;

function tlsP_SHA1(const Secret, Seed: AnsiString; const Size: Integer): AnsiString;
var A, P : AnsiString;
    L : Integer;
begin
  P := '';
  L := 0;
  A := Seed;
  repeat
    A := SHA1DigestToStrA(CalcHMAC_SHA1(Secret, A));
    P := P + SHA1DigestToStrA(CalcHMAC_SHA1(Secret, A + Seed));
    Inc(L, 20);
  until L >= Size;
  if L > Size then
    SetLength(P, Size);
  Result := P;
end;

function tlsP_SHA256(const Secret, Seed: AnsiString; const Size: Integer): AnsiString;
var A, P : AnsiString;
    L : Integer;
begin
  P := '';
  L := 0;
  A := Seed;
  repeat
    A := SHA256DigestToStrA(CalcHMAC_SHA256(Secret, A));
    P := P + SHA256DigestToStrA(CalcHMAC_SHA256(Secret, A + Seed));
    Inc(L, 32);
  until L >= Size;
  if L > Size then
    SetLength(P, Size);
  Result := P;
end;

function tlsP_SHA512(const Secret, Seed: AnsiString; const Size: Integer): AnsiString;
var A, P : AnsiString;
    L : Integer;
begin
  P := '';
  L := 0;
  A := Seed;
  repeat
    A := SHA512DigestToStrA(CalcHMAC_SHA512(Secret, A));
    P := P + SHA512DigestToStrA(CalcHMAC_SHA512(Secret, A + Seed));
    Inc(L, 64);
  until L >= Size;
  if L > Size then
    SetLength(P, Size);
  Result := P;
end;



{                                                                              }
{ PRF                                                                          }
{ TLS 1.0:                                                                     }
{ PRF(secret, label, seed) = P_MD5(S1, label + seed) XOR                       }
{                            P_SHA-1(S2, label + seed);                        }
{ S1 and S2 are the two halves of the secret and each is the same length.      }
{ S1 is taken from the first half of the secret, S2 from the second half.      }
{ Their length is created by rounding up the length of the overall secret      }
{ divided by two; thus, if the original secret is an odd number of bytes       }
{ long, the last byte of S1 will be the same as the first byte of S2.          }
{                                                                              }
{ TLS 1.2:                                                                     }
{ PRF(secret, label, seed) = P_<hash>(secret, label + seed)                    }
{ P_SHA-256                                                                    }
{                                                                              }
procedure tls10PRFSplitSecret(const Secret: AnsiString; var S1, S2: AnsiString);
var L, N : Integer;
begin
  N := Length(Secret);
  L := N;
  if L mod 2 = 1 then
    Inc(L);
  L := L div 2;
  S1 := Copy(Secret, 1, L);
  S2 := Copy(Secret, N - L + 1, L);
end;

function tls10PRF(const Secret, ALabel, Seed: AnsiString; const Size: Integer): AnsiString;
var S1, S2 : AnsiString;
    P1, P2 : AnsiString;
    R      : AnsiString;
    I      : Integer;
begin
  tls10PRFSplitSecret(Secret, S1, S2);
  P1 := tlsP_MD5(S1, ALabel + Seed, Size);
  P2 := tlsP_SHA1(S2, ALabel + Seed, Size);
  SetLength(R, Size);
  for I := 1 to Size do
    R[I] := AnsiChar(Byte(P1[I]) xor Byte(P2[I]));
  Result := R;
end;

function tls12PRF_SHA256(const Secret, ALabel, Seed: AnsiString; const Size: Integer): AnsiString;
begin
  Result := tlsP_SHA256(Secret, ALabel + Seed, Size);
end;

function tls12PRF_SHA512(const Secret, ALabel, Seed: AnsiString; const Size: Integer): AnsiString;
begin
  Result := tlsP_SHA512(Secret, ALabel + Seed, Size);
end;

function TLSPRF(const ProtocolVersion: TTLSProtocolVersion;
         const Secret, ALabel, Seed: AnsiString; const Size: Integer): AnsiString;
begin
  if IsTLS12OrLater(ProtocolVersion) then
    Result := tls12PRF_SHA256(Secret, ALabel, Seed, Size) else
  if IsTLS10OrLater(ProtocolVersion) then
    Result := tls10PRF(Secret, ALabel, Seed, Size)
  else
    raise ETLSError.Create(TLSError_InvalidParameter);
end;



{                                                                              }
{ Key block                                                                    }
{                                                                              }
{ SSL 3.0:                                                                     }
{ key_block =                                                                  }
{      MD5(master_secret + SHA('A' + master_secret +                           }
{                              ServerHello.random + ClientHello.random)) +     }
{      MD5(master_secret + SHA('BB' + master_secret +                          }
{                              ServerHello.random + ClientHello.random)) +     }
{      MD5(master_secret + SHA('CCC' + master_secret +                         }
{                              ServerHello.random + ClientHello.random)) +     }
{                              [...];                                          }
{                                                                              }
{ TLS 1.0 / 1.1 / 1.2:                                                         }
{ key_block = PRF(SecurityParameters.master_secret,                            }
{                 "key expansion",                                             }
{                 SecurityParameters.server_random +                           }
{                 SecurityParameters.client_random);                           }
{                                                                              }
function ssl30KeyBlockP(const Prefix, MasterSecret, ServerRandom, ClientRandom: AnsiString): AnsiString;
begin
  Result :=
      MD5DigestToStrA(
          CalcMD5(MasterSecret +
              SHA1DigestToStrA(
                  CalcSHA1(Prefix + MasterSecret + ServerRandom + ClientRandom))));
end;

function DupCharA(const Ch: AnsiChar; const Count: Integer): AnsiString;
begin
  if Count <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, Count);
  FillChar(Pointer(Result)^, Count, Ord(Ch));    //fillmem
end;


function ssl30KeyBlockPF(const MasterSecret, ServerRandom, ClientRandom: AnsiString; const Size: Integer): AnsiString;
var Salt : AnsiString;
    I : Integer;
begin
  Result := '';
  I := 1;
  while Length(Result) < Size do
    begin
      if I > 26 then
        raise ETLSError.Create(TLSError_InvalidParameter);
      Salt := DupCharA(AnsiChar(Ord('A') + I - 1), I);
      Result := Result +
          ssl30KeyBlockP(Salt, MasterSecret, ServerRandom, ClientRandom);
      Inc(I);
    end;
  SetLength(Result, Size);
end;

function ssl30KeyBlock(const MasterSecret, ServerRandom, ClientRandom: AnsiString; const Size: Integer): AnsiString;
begin
  Result := ssl30KeyBlockPF(MasterSecret, ServerRandom, ClientRandom, Size);
end;

const
  LabelKeyExpansion = 'key expansion';
  
function tls10KeyBlock(const MasterSecret, ServerRandom, ClientRandom: AnsiString; const Size: Integer): AnsiString;
var S : AnsiString;
begin
  S := ServerRandom + ClientRandom;
  Result := tls10PRF(MasterSecret, LabelKeyExpansion, S, Size);
end;

function tls12SHA256KeyBlock(const MasterSecret, ServerRandom, ClientRandom: AnsiString; const Size: Integer): AnsiString;
var S : AnsiString;
begin
  S := ServerRandom + ClientRandom;
  Result := tls12PRF_SHA256(MasterSecret, LabelKeyExpansion, S, Size);
end;

function tls12SHA512KeyBlock(const MasterSecret, ServerRandom, ClientRandom: AnsiString; const Size: Integer): AnsiString;
var S : AnsiString;
begin
  S := ServerRandom + ClientRandom;
  Result := tls12PRF_SHA512(MasterSecret, LabelKeyExpansion, S, Size);
end;

function TLSKeyBlock(const ProtocolVersion: TTLSProtocolVersion;
         const MasterSecret, ServerRandom, ClientRandom: AnsiString; const Size: Integer): AnsiString;
begin
  if IsTLS12OrLater(ProtocolVersion) then
    Result := tls12SHA256KeyBlock(MasterSecret, ServerRandom, ClientRandom, Size) else
  if IsTLS10OrLater(ProtocolVersion) then
    Result := tls10KeyBlock(MasterSecret, ServerRandom, ClientRandom, Size) else
  if IsSSL3(ProtocolVersion) then
    Result := ssl30KeyBlock(MasterSecret, ServerRandom, ClientRandom, Size) 
  else
    raise ETLSError.Create(TLSError_InvalidParameter);
end;



{                                                                              }
{ Master secret                                                                }
{                                                                              }
{ SSL 3:                                                                       }
{ master_secret =                                                              }
{      MD5(pre_master_secret + SHA('A' + pre_master_secret +                   }
{          ClientHello.random + ServerHello.random)) +                         }
{      MD5(pre_master_secret + SHA('BB' + pre_master_secret +                  }
{          ClientHello.random + ServerHello.random)) +                         }
{      MD5(pre_master_secret + SHA('CCC' + pre_master_secret +                 }
{          ClientHello.random + ServerHello.random));                          }
{                                                                              }
{ TLS 1.0 1.1 1.2:                                                             }
{ master_secret = PRF(pre_master_secret,                                       }
{                     "master secret",                                         }
{                     ClientHello.random + ServerHello.random)                 }
{                                                                              }
{ The master secret is always exactly 48 bytes in length. The length of        }
{ the premaster secret will vary depending on key exchange method.             }
{                                                                              }
const
  LabelMasterSecret = 'master secret';
  MasterSecretSize = 48;

function ssl30MasterSecretP(const Prefix, PreMasterSecret, ClientRandom, ServerRandom: AnsiString): AnsiString;
begin
  Result :=
      MD5DigestToStrA(
          CalcMD5(PreMasterSecret +
              SHA1DigestToStrA(
                  CalcSHA1(Prefix + PreMasterSecret + ClientRandom + ServerRandom))));
end;

function ssl30MasterSecret(const PreMasterSecret, ClientRandom, ServerRandom: AnsiString): AnsiString;
begin
  Result :=
      ssl30MasterSecretP('A', PreMasterSecret, ClientRandom, ServerRandom) +
      ssl30MasterSecretP('BB', PreMasterSecret, ClientRandom, ServerRandom) +
      ssl30MasterSecretP('CCC', PreMasterSecret, ClientRandom, ServerRandom);
end;

function tls10MasterSecret(const PreMasterSecret, ClientRandom, ServerRandom: AnsiString): AnsiString;
var S : AnsiString;
begin
  S := ClientRandom + ServerRandom;
  Result := tls10PRF(PreMasterSecret, LabelMasterSecret, S, MasterSecretSize);
end;

function tls12SHA256MasterSecret(const PreMasterSecret, ClientRandom, ServerRandom: AnsiString): AnsiString;
var S : AnsiString;
begin
  S := ClientRandom + ServerRandom;
  Result := tls12PRF_SHA256(PreMasterSecret, LabelMasterSecret, S, MasterSecretSize);
end;

function tls12SHA512MasterSecret(const PreMasterSecret, ClientRandom, ServerRandom: AnsiString): AnsiString;
var S : AnsiString;
begin
  S := ClientRandom + ServerRandom;
  Result := tls12PRF_SHA512(PreMasterSecret, LabelMasterSecret, S, MasterSecretSize);
end;

function TLSMasterSecret(const ProtocolVersion: TTLSProtocolVersion;
         const PreMasterSecret, ClientRandom, ServerRandom: AnsiString): AnsiString;
begin
  if IsTLS12OrLater(ProtocolVersion) then
    Result := tls12SHA256MasterSecret(PreMasterSecret, ClientRandom, ServerRandom) else
  if IsTLS10OrLater(ProtocolVersion) then
    Result := tls10MasterSecret(PreMasterSecret, ClientRandom, ServerRandom) else
  if IsSSL3(ProtocolVersion) then
    Result := ssl30MasterSecret(PreMasterSecret, ClientRandom, ServerRandom)
  else
    raise ETLSError.Create(TLSError_InvalidParameter);
end;



{                                                                              }
{ TLS Keys                                                                     }
{                                                                              }
procedure GenerateTLSKeys(
          const ProtocolVersion: TTLSProtocolVersion;
          const MACKeyBits, CipherKeyBits, IVBits: Integer;
          const MasterSecret, ServerRandom, ClientRandom: AnsiString;
          var TLSKeys: TTLSKeys);
var L, I, N : Integer;
    S : AnsiString;
begin
  Assert(MACKeyBits mod 8 = 0);
  Assert(CipherKeyBits mod 8 = 0);
  Assert(IVBits mod 8 = 0);

  L := MACKeyBits * 2 + CipherKeyBits * 2 + IVBits * 2;
  L := L div 8;
  S := TLSKeyBlock(ProtocolVersion, MasterSecret, ServerRandom, ClientRandom, L);
  TLSKeys.KeyBlock := S;
  I := 1;
  N := MACKeyBits div 8;
  TLSKeys.ClientMACKey := Copy(S, I, N);
  TLSKeys.ServerMACKey := Copy(S, I + N, N);
  Inc(I, N * 2);
  N := CipherKeyBits div 8;
  TLSKeys.ClientEncKey := Copy(S, I, N);
  TLSKeys.ServerEncKey := Copy(S, I + N, N);
  Inc(I, N * 2);
  N := IVBits div 8;
  TLSKeys.ClientIV := Copy(S, I, N);
  TLSKeys.ServerIV := Copy(S, I + N, N);
end;

{ TLS 1.0:                                                                     }
{ final_client_write_key = PRF(SecurityParameters.client_write_key,            }
{   "client write key",                                                        }
{   SecurityParameters.client_random + SecurityParameters.server_random);      }
{ final_server_write_key = PRF(SecurityParameters.server_write_key,            }
{   "server write key",                                                        }
{   SecurityParameters.client_random + SecurityParameters.server_random);      }
{ iv_block = PRF("", "IV block",                                               }
{   SecurityParameters.client_random + SecurityParameters.server_random);      }
const
  LabelClientWriteKey = 'client write key';
  LabelServerWriteKey = 'server write key';
  LabelIVBlock        = 'IV block';

procedure GenerateFinalTLSKeys(
          const ProtocolVersion: TTLSProtocolVersion;
          const IsExportable: Boolean;
          const ExpandedKeyBits: Integer;
          const ServerRandom, ClientRandom: AnsiString;
          var TLSKeys: TTLSKeys);
var S : AnsiString;
    L : Integer;
    V : AnsiString;
begin
  if IsTLS11OrLater(ProtocolVersion) then 
    exit;
  if not IsExportable then
    exit;
  if IsSSL2(ProtocolVersion) or IsSSL3(ProtocolVersion) then
    raise ETLSError.Create(TLSError_InvalidParameter, 'Unsupported version');
  S := ClientRandom + ServerRandom;
  Assert(ExpandedKeyBits mod 8 = 0);
  L := ExpandedKeyBits div 8;
  TLSKeys.ClientEncKey := tls10PRF(TLSKeys.ClientEncKey, LabelClientWriteKey, S, L);
  TLSKeys.ServerEncKey := tls10PRF(TLSKeys.ServerEncKey, LabelServerWriteKey, S, L);
  L := Length(TLSKeys.ClientIV);
  if L > 0 then
    begin
      V := tls10PRF('', LabelIVBlock, S, L * 2);
      TLSKeys.ClientIV := Copy(V, 1, L);
      TLSKeys.ServerIV := Copy(V, L + 1, L);
    end;
end;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF TLS_SELFTEST}
{$ASSERTIONS ON}
procedure SelfTestProtocolVersion;
begin
  Assert(TLSProtocolVersionSize = 2);
  Assert(IsTLS12OrLater(TLSProtocolVersion12));
  Assert(not IsTLS12OrLater(TLSProtocolVersion10));
  Assert(TLSProtocolVersionToStr(TLSProtocolVersion12) = '3.3');
  Assert(TLSProtocolVersionName(SSLProtocolVersion20) = 'SSL2');
  Assert(TLSProtocolVersionName(TLSProtocolVersion12) = 'TLS1.2');
end;

procedure SelfTestPRF;
begin
  //                                                                                   //
  // Test vectors from http://www6.ietf.org/mail-archive/web/tls/current/msg03416.html //
  //                                                                                   //
  Assert(tls12PRF_SHA256(
      #$9b#$be#$43#$6b#$a9#$40#$f0#$17#$b1#$76#$52#$84#$9a#$71#$db#$35,
      'test label',
      #$a0#$ba#$9f#$93#$6c#$da#$31#$18#$27#$a6#$f7#$96#$ff#$d5#$19#$8c, 100) =
      #$e3#$f2#$29#$ba#$72#$7b#$e1#$7b +
      #$8d#$12#$26#$20#$55#$7c#$d4#$53 +
      #$c2#$aa#$b2#$1d#$07#$c3#$d4#$95 +
      #$32#$9b#$52#$d4#$e6#$1e#$db#$5a +
      #$6b#$30#$17#$91#$e9#$0d#$35#$c9 +
      #$c9#$a4#$6b#$4e#$14#$ba#$f9#$af +
      #$0f#$a0#$22#$f7#$07#$7d#$ef#$17 +
      #$ab#$fd#$37#$97#$c0#$56#$4b#$ab +
      #$4f#$bc#$91#$66#$6e#$9d#$ef#$9b +
      #$97#$fc#$e3#$4f#$79#$67#$89#$ba +
      #$a4#$80#$82#$d1#$22#$ee#$42#$c5 +
      #$a7#$2e#$5a#$51#$10#$ff#$f7#$01 +
      #$87#$34#$7b#$66);
  Assert(tls12PRF_SHA512(
      #$b0#$32#$35#$23#$c1#$85#$35#$99#$58#$4d#$88#$56#$8b#$bb#$05#$eb,
      'test label',
      #$d4#$64#$0e#$12#$e4#$bc#$db#$fb#$43#$7f#$03#$e6#$ae#$41#$8e#$e5, 196) =
      #$12#$61#$f5#$88#$c7#$98#$c5#$c2 +
      #$01#$ff#$03#$6e#$7a#$9c#$b5#$ed +
      #$cd#$7f#$e3#$f9#$4c#$66#$9a#$12 +
      #$2a#$46#$38#$d7#$d5#$08#$b2#$83 +
      #$04#$2d#$f6#$78#$98#$75#$c7#$14 +
      #$7e#$90#$6d#$86#$8b#$c7#$5c#$45 +
      #$e2#$0e#$b4#$0c#$1c#$f4#$a1#$71 +
      #$3b#$27#$37#$1f#$68#$43#$25#$92 +
      #$f7#$dc#$8e#$a8#$ef#$22#$3e#$12 +
      #$ea#$85#$07#$84#$13#$11#$bf#$68 +
      #$65#$3d#$0c#$fc#$40#$56#$d8#$11 +
      #$f0#$25#$c4#$5d#$df#$a6#$e6#$fe +
      #$c7#$02#$f0#$54#$b4#$09#$d6#$f2 +
      #$8d#$d0#$a3#$23#$3e#$49#$8d#$a4 +
      #$1a#$3e#$75#$c5#$63#$0e#$ed#$be +
      #$22#$fe#$25#$4e#$33#$a1#$b0#$e9 +
      #$f6#$b9#$82#$66#$75#$be#$c7#$d0 +
      #$1a#$84#$56#$58#$dc#$9c#$39#$75 +
      #$45#$40#$1d#$40#$b9#$f4#$6c#$7a +
      #$40#$0e#$e1#$b8#$f8#$1c#$a0#$a6 +
      #$0d#$1a#$39#$7a#$10#$28#$bf#$f5 +
      #$d2#$ef#$50#$66#$12#$68#$42#$fb +
      #$8d#$a4#$19#$76#$32#$bd#$b5#$4f +
      #$f6#$63#$3f#$86#$bb#$c8#$36#$e6 +
      #$40#$d4#$d8#$98);
end;

const
  PreMasterSecret =
      #$03#$01#$84#$54#$F5#$D6#$EB#$F5#$A8#$08#$BA#$FA#$7A#$22#$61#$2D +
      #$75#$DC#$40#$E8#$98#$F9#$0E#$B2#$87#$80#$B8#$1A#$8F#$68#$25#$B8 +
      #$51#$D0#$54#$45#$61#$8A#$50#$C9#$BB#$0E#$39#$53#$45#$78#$BE#$79;
  ClientRandom =
      #$40#$FC#$30#$AE#$2D#$63#$84#$BB#$C5#$4B#$27#$FD#$58#$21#$CA#$90 +
      #$05#$F6#$A7#$7B#$37#$BB#$72#$E1#$FC#$1D#$1B#$6A#$F5#$1C#$C8#$9F;
  ServerRandom =
      #$40#$FC#$31#$10#$79#$AB#$17#$66#$FA#$8B#$3F#$AA#$FD#$5E#$48#$23 +
      #$FA#$90#$31#$D8#$3C#$B9#$A3#$2C#$8C#$F5#$E9#$81#$9B#$A2#$63#$6C;
  MasterSecret =
      #$B0#$00#$22#$34#$59#$03#$16#$B7#$7A#$6C#$56#$9B#$89#$D2#$7A#$CC +
      #$F3#$85#$55#$59#$3A#$14#$76#$3D#$54#$BF#$EB#$3F#$E0#$2F#$B1#$4B +
      #$79#$8C#$75#$A9#$78#$55#$6C#$8E#$A2#$14#$60#$B7#$45#$EB#$77#$B2;
  MACWriteKey =
      #$85#$F0#$56#$F8#$07#$1D#$B1#$89#$89#$D0#$E1#$33#$3C#$CA#$63#$F9;

procedure SelfTestKeyBlock;
var S : AnsiString;
begin
  //                                                                                              //
  // Example from http://download.oracle.com/javase/1.5.0/docs/guide/security/jsse/ReadDebug.html //
  //                                                                                              //
  Assert(tls10MasterSecret(PreMasterSecret, ClientRandom, ServerRandom) = MasterSecret);
  S := tls10KeyBlock(MasterSecret, ServerRandom, ClientRandom, 64);
  Assert(Copy(S, 1, 48) =
      MACWriteKey +
      #$1E#$4D#$D1#$D3#$0A#$78#$EE#$B7#$4F#$EC#$15#$79#$B2#$59#$18#$40 +
      #$10#$D0#$D6#$C2#$D9#$B7#$62#$CB#$2C#$74#$BF#$5F#$85#$3C#$6F#$E7);
end;

procedure SelfTest;
begin
  Assert(TLSCompressionMethodSize = 1);
  Assert(TLSRandomSize = 32);
  SelfTestProtocolVersion;
  SelfTestPRF;
  SelfTestKeyBlock;
end;
{$ENDIF}



end.

