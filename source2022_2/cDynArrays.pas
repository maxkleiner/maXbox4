{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 4.00                                        }
{   File name:        cDynArrays.pas                                           }
{   File version:     4.26                                                     }
{   Description:      Utility functions for dynamic arrays                     }
{                                                                              }
{   Copyright:        Copyright � 2000-2012, David J Butler                    }
{                     All rights reserved.                                     }
{                     Redistribution and use in source and binary forms, with  }
{                     or without modification, are permitted provided that     }
{                     the following conditions are met:                        }
{                     Redistributions of source code must retain the above     }
{                     copyright notice, this list of conditions and the        }
{                     following disclaimer.                                    }
{                     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND   }
{                     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED          }
{                     WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED   }
{                     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A          }
{                     PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL     }
{                     THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,    }
{                     INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR             }
{                     CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,    }
{                     PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF     }
{                     USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)         }
{                     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER   }
{                     IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING        }
{                     NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE   }
{                     USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE             }
{                     POSSIBILITY OF SUCH DAMAGE.                              }
{                                                                              }
{   Home page:        http://fundementals.sourceforge.net                      }
{   Forum:            http://sourceforge.net/forum/forum.php?forum_id=2117     }
{   E-mail:           fundamentalslib at gmail.com                             }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{   2000/03/08  1.01  Initial verison: array functions.                        }
{   2000/04/10  1.02  Added Append, Renamed Delete to Remove and added         }
{                     StringArrays.                                            }
{   2000/06/01  1.03  Added Range and Dup constructors for dynamic arrays.     }
{   2000/06/03  1.04  Added ArrayInsert functions.                             }
{   2000/06/14  1.05  Unit now generated from a template using a source        }
{                     pre-processor.                                           }
{   2000/07/04  1.06  Revision for first Fundamentals release.                 }
{   2000/07/24  1.07  Added TrimArray functions.                               }
{   2000/07/26  1.08  Added Difference functions.                              }
{   2000/09/02  1.09  Added RemoveDuplicates functions.                        }
{                     Added Count functions.                                   }
{                     Fixed bug in Sort.                                       }
{   2000/09/27  1.10  Fixed bug in ArrayInsert.                                }
{   2001/11/11  2.11  Revision.                                                }
{   2002/05/31  3.12  Refactored for Fundamentals 3.                           }
{   2003/09/11  3.13  Added InterfaceArray functions.                          }
{   2004/01/18  3.14  Added WideStringArray functions.                         }
{   2004/07/24  3.15  Optimizations of Sort functions.                         }
{   2004/08/22  3.16  Compilable with Delphi 8.                                }
{   2005/06/10  4.17  Compilable with FreePascal 2 Win32 i386.                 }
{   2005/08/19  4.18  Compilable with FreePascal 2 Linux i386.                 }
{   2005/09/21  4.19  Revised for Fundamentals 4.                              }
{   2006/03/04  4.20  Compilable with Delphi 2006 Win32/.NET.                  }
{   2007/06/08  4.21  Compilable with FreePascal 2.04 Win32 i386               }
{   2009/10/09  4.22  Compilable with Delphi 2009 Win32/.NET.                  }
{   2010/06/27  4.23  Compilable with FreePascal 2.4.0 OSX x86-64.             }
{   2011/04/03  4.24  Support for Delphi XE string and integer types.          }
{   2011/04/04  4.25  Split dynamic array functions from Utils unit.           }
{   2012/08/26  4.26  UnicodeString functions.                                 }
{                                                                              }
{******************************************************************************}

{$INCLUDE cDefines.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

{$IFDEF DEBUG}
{$IFDEF SELFTEST}
  {$DEFINE DYNARRAYS_SELFTEST}
{$ENDIF}
{$ENDIF}

unit cDynArrays;

interface

uses
  { System }
  SysUtils,

  { Fundamentals }
  cUtils;



{                                                                              }
{ Dynamic arrays                                                               }
{                                                                              }
function  DynArrayAppend(var V: ByteArray; const R: Byte): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: WordArray; const R: Word): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: LongWordArray; const R: LongWord): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: NativeUIntArray; const R: NativeUInt): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: ShortIntArray; const R: ShortInt): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: SmallIntArray; const R: SmallInt): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: LongIntArray; const R: LongInt): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: Int64Array; const R: Int64): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: NativeIntArray; const R: NativeInt): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: SingleArray; const R: Single): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: DoubleArray; const R: Double): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: ExtendedArray; const R: Extended): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: CurrencyArray; const R: Currency): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: BooleanArray; const R: Boolean): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppendA(var V: AnsiStringArray; const R: AnsiString): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppendW(var V: WideStringArray; const R: WideString): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppendU(var V: UnicodeStringArray; const R: UnicodeString): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: StringArray; const R: String): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
{$IFNDEF ManagedCode}
function  DynArrayAppend(var V: PointerArray; const R: Pointer): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
{$ENDIF}
function  DynArrayAppend(var V: ObjectArray; const R: TObject): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: InterfaceArray; const R: IInterface): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: ByteSetArray; const R: ByteSet): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  DynArrayAppend(var V: CharSetArray; const R: CharSet): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}

function  DynArrayAppendByteArray(var V: ByteArray; const R: array of Byte): Integer; overload;
function  DynArrayAppendWordArray(var V: WordArray; const R: array of Word): Integer; overload;
function  DynArrayAppendCardinalArray(var V: CardinalArray; const R: array of LongWord): Integer; overload;
function  DynArrayAppendNativeUIntArray(var V: NativeUIntArray; const R: array of NativeUInt): Integer; overload;
function  DynArrayAppendShortIntArray(var V: ShortIntArray; const R: array of ShortInt): Integer; overload;
function  DynArrayAppendSmallIntArray(var V: SmallIntArray; const R: array of SmallInt): Integer; overload;
function  DynArrayAppendIntegerArray(var V: IntegerArray; const R: array of LongInt): Integer; overload;
function  DynArrayAppendInt64Array(var V: Int64Array; const R: array of Int64): Integer; overload;
function  DynArrayAppendNativeIntArray(var V: NativeIntArray; const R: array of NativeInt): Integer; overload;
function  DynArrayAppendSingleArray(var V: SingleArray; const R: array of Single): Integer; overload;
function  DynArrayAppendDoubleArray(var V: DoubleArray; const R: array of Double): Integer; overload;
function  DynArrayAppendExtendedArray(var V: ExtendedArray; const R: array of Extended): Integer; overload;
function  DynArrayAppendAnsiStringArray(var V: AnsiStringArray; const R: array of AnsiString): Integer; overload;
function  DynArrayAppendWideStringArray(var V: WideStringArray; const R: array of WideString): Integer; overload;
function  DynArrayAppendUnicodeStringArray(var V: UnicodeStringArray; const R: array of UnicodeString): Integer; overload;
function  DynArrayAppendStringArray(var V: StringArray; const R: array of String): Integer; overload;
{$IFNDEF CLR}
function  DynArrayAppendCurrencyArray(var V: CurrencyArray; const R: array of Currency): Integer; overload;
function  DynArrayAppendPointerArray(var V: PointerArray; const R: array of Pointer): Integer; overload;
function  DynArrayAppendCharSetArray(var V: CharSetArray; const R: array of CharSet): Integer; overload;
function  DynArrayAppendByteSetArray(var V: ByteSetArray; const R: array of ByteSet): Integer; overload;
{$ENDIF}
function  DynArrayAppendObjectArray(var V: ObjectArray; const R: ObjectArray): Integer; overload;

function  DynArrayRemove(var V: ByteArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: WordArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: LongWordArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: NativeUIntArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: ShortIntArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: SmallIntArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: LongIntArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: Int64Array; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: NativeIntArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: SingleArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: DoubleArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: ExtendedArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemoveA(var V: AnsiStringArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemoveW(var V: WideStringArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemoveU(var V: UnicodeStringArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
function  DynArrayRemove(var V: StringArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
{$IFNDEF ManagedCode}
function  DynArrayRemove(var V: PointerArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
{$ENDIF}
{$IFNDEF CLR}
function  DynArrayRemove(var V: CurrencyArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;
{$ENDIF}
function  DynArrayRemove(var V: ObjectArray; const Idx: Integer; const Count: Integer = 1;
          const FreeObjects: Boolean = False): Integer; overload;
function  DynArrayRemove(var V: InterfaceArray; const Idx: Integer; const Count: Integer = 1): Integer; overload;

procedure DynArrayRemoveDuplicates(var V: ByteArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicates(var V: WordArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicates(var V: LongWordArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicates(var V: ShortIntArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicates(var V: SmallIntArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicates(var V: LongIntArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicates(var V: Int64Array; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicates(var V: SingleArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicates(var V: DoubleArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicates(var V: ExtendedArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicatesA(var V: AnsiStringArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicatesW(var V: WideStringArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicatesU(var V: UnicodeStringArray; const IsSorted: Boolean); overload;
procedure DynArrayRemoveDuplicates(var V: StringArray; const IsSorted: Boolean); overload;
{$IFNDEF ManagedCode}
procedure DynArrayRemoveDuplicates(var V: PointerArray; const IsSorted: Boolean); overload;
{$ENDIF}

procedure DynArrayTrimLeft(var S: ByteArray; const TrimList: array of Byte); overload;
procedure DynArrayTrimLeft(var S: WordArray; const TrimList: array of Word); overload;
procedure DynArrayTrimLeft(var S: LongWordArray; const TrimList: array of LongWord); overload;
procedure DynArrayTrimLeft(var S: ShortIntArray; const TrimList: array of ShortInt); overload;
procedure DynArrayTrimLeft(var S: SmallIntArray; const TrimList: array of SmallInt); overload;
procedure DynArrayTrimLeft(var S: LongIntArray; const TrimList: array of LongInt); overload;
procedure DynArrayTrimLeft(var S: Int64Array; const TrimList: array of Int64); overload;
procedure DynArrayTrimLeft(var S: SingleArray; const TrimList: array of Single); overload;
procedure DynArrayTrimLeft(var S: DoubleArray; const TrimList: array of Double); overload;
procedure DynArrayTrimLeft(var S: ExtendedArray; const TrimList: array of Extended); overload;
procedure DynArrayTrimLeftA(var S: AnsiStringArray; const TrimList: array of AnsiString); overload;
procedure DynArrayTrimLeftW(var S: WideStringArray; const TrimList: array of WideString); overload;
procedure DynArrayTrimLeftU(var S: UnicodeStringArray; const TrimList: array of UnicodeString); overload;
{$IFNDEF ManagedCode}
procedure DynArrayTrimLeft(var S: PointerArray; const TrimList: array of Pointer); overload;
{$ENDIF}

procedure DynArrayTrimRight(var S: ByteArray; const TrimList: array of Byte); overload;
procedure DynArrayTrimRight(var S: WordArray; const TrimList: array of Word); overload;
procedure DynArrayTrimRight(var S: LongWordArray; const TrimList: array of LongWord); overload;
procedure DynArrayTrimRight(var S: ShortIntArray; const TrimList: array of ShortInt); overload;
procedure DynArrayTrimRight(var S: SmallIntArray; const TrimList: array of SmallInt); overload;
procedure DynArrayTrimRight(var S: LongIntArray; const TrimList: array of LongInt); overload;
procedure DynArrayTrimRight(var S: Int64Array; const TrimList: array of Int64); overload;
procedure DynArrayTrimRight(var S: SingleArray; const TrimList: array of Single); overload;
procedure DynArrayTrimRight(var S: DoubleArray; const TrimList: array of Double); overload;
procedure DynArrayTrimRight(var S: ExtendedArray; const TrimList: array of Extended); overload;
procedure DynArrayTrimRightA(var S: AnsiStringArray; const TrimList: array of AnsiString); overload;
procedure DynArrayTrimRightW(var S: WideStringArray; const TrimList: array of WideString); overload;
procedure DynArrayTrimRightU(var S: UnicodeStringArray; const TrimList: array of UnicodeString); overload;
procedure DynArrayTrimRight(var S: StringArray; const TrimList: array of String); overload;
{$IFNDEF ManagedCode}
procedure DynArrayTrimRight(var S: PointerArray; const TrimList: array of Pointer); overload;
{$ENDIF}

function  DynArrayInsert(var V: ByteArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: WordArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: LongWordArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: NativeUIntArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: ShortIntArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: SmallIntArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: LongIntArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: Int64Array; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: NativeIntArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: SingleArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: DoubleArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: ExtendedArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: CurrencyArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsertA(var V: AnsiStringArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsertW(var V: WideStringArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsertU(var V: UnicodeStringArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: StringArray; const Idx: Integer; const Count: Integer): Integer; overload;
{$IFNDEF ManagedCode}
function  DynArrayInsert(var V: PointerArray; const Idx: Integer; const Count: Integer): Integer; overload;
function  DynArrayInsert(var V: ObjectArray; const Idx: Integer; const Count: Integer): Integer; overload;
{$ENDIF}
function  DynArrayInsert(var V: InterfaceArray; const Idx: Integer; const Count: Integer): Integer; overload;

function  DynArrayPosNext(const Find: Byte; const V: ByteArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: Word; const V: WordArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: LongWord; const V: LongWordArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: NativeUInt; const V: NativeUIntArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: ShortInt; const V: ShortIntArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: SmallInt; const V: SmallIntArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: LongInt; const V: LongIntArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: Int64; const V: Int64Array; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: NativeInt; const V: NativeIntArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: Single; const V: SingleArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: Double; const V: DoubleArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: Extended; const V: ExtendedArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: Boolean; const V: BooleanArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNextA(const Find: AnsiString; const V: AnsiStringArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNextW(const Find:   WideString; const V: WideStringArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNextU(const Find: UnicodeString; const V: UnicodeStringArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayPosNext(const Find: String; const V: StringArray; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;
{$IFNDEF ManagedCode}
function  DynArrayPosNext(const Find: Pointer; const V: PointerArray;
          const PrevPos: Integer = -1): Integer; overload;
{$ENDIF}
function  DynArrayPosNext(const Find: TObject; const V: ObjectArray;
          const PrevPos: Integer = -1): Integer; overload;
function  DynArrayPosNext(const ClassType: TClass; const V: ObjectArray;
          const PrevPos: Integer = -1): Integer; overload;
function  DynArrayPosNext(const ClassName: String; const V: ObjectArray;
          const PrevPos: Integer = -1): Integer; overload;

function  DynArrayCount(const Find: Byte; const V: ByteArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCount(const Find: Word; const V: WordArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCount(const Find: LongWord; const V: LongWordArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCount(const Find: ShortInt; const V: ShortIntArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCount(const Find: SmallInt; const V: SmallIntArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCount(const Find: LongInt; const V: LongIntArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCount(const Find: Int64; const V: Int64Array;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCount(const Find: Single; const V: SingleArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCount(const Find: Double; const V: DoubleArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCount(const Find: Extended; const V: ExtendedArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCountA(const Find: AnsiString; const V: AnsiStringArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCountW(const Find: WideString; const V: WideStringArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCountU(const Find: UnicodeString; const V: UnicodeStringArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCount(const Find: String; const V: StringArray;
          const IsSortedAscending: Boolean = False): Integer; overload;
function  DynArrayCount(const Find: Boolean; const V: BooleanArray;
          const IsSortedAscending: Boolean = False): Integer; overload;

procedure DynArrayRemoveAll(const Find: Byte; var V: ByteArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAll(const Find: Word; var V: WordArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAll(const Find: LongWord; var V: LongWordArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAll(const Find: ShortInt; var V: ShortIntArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAll(const Find: SmallInt; var V: SmallIntArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAll(const Find: LongInt; var V: LongIntArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAll(const Find: Int64; var V: Int64Array;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAll(const Find: Single; var V: SingleArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAll(const Find: Double; var V: DoubleArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAll(const Find: Extended; var V: ExtendedArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAllA(const Find: AnsiString; var V: AnsiStringArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAllW(const Find: WideString; var V: WideStringArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAllU(const Find: UnicodeString; var V: UnicodeStringArray;
          const IsSortedAscending: Boolean = False); overload; 
procedure DynArrayRemoveAll(const Find: String; var V: StringArray;
          const IsSortedAscending: Boolean = False); overload; 

function  DynArrayIntersection(const V1, V2: ByteArray;
          const IsSortedAscending: Boolean = False): ByteArray; overload;
function  DynArrayIntersection(const V1, V2: WordArray;
          const IsSortedAscending: Boolean = False): WordArray; overload;
function  DynArrayIntersection(const V1, V2: LongWordArray;
          const IsSortedAscending: Boolean = False): LongWordArray; overload;
function  DynArrayIntersection(const V1, V2: ShortIntArray;
          const IsSortedAscending: Boolean = False): ShortIntArray; overload;
function  DynArrayIntersection(const V1, V2: SmallIntArray;
          const IsSortedAscending: Boolean = False): SmallIntArray; overload;
function  DynArrayIntersection(const V1, V2: LongIntArray;
          const IsSortedAscending: Boolean = False): LongIntArray; overload;
function  DynArrayIntersection(const V1, V2: Int64Array;
          const IsSortedAscending: Boolean = False): Int64Array; overload;
function  DynArrayIntersection(const V1, V2: SingleArray;
          const IsSortedAscending: Boolean = False): SingleArray; overload;
function  DynArrayIntersection(const V1, V2: DoubleArray;
          const IsSortedAscending: Boolean = False): DoubleArray; overload;
function  DynArrayIntersection(const V1, V2: ExtendedArray;
          const IsSortedAscending: Boolean = False): ExtendedArray; overload;
function  DynArrayIntersectionA(const V1, V2: AnsiStringArray;
          const IsSortedAscending: Boolean = False): AnsiStringArray; overload;
function  DynArrayIntersectionW(const V1, V2: WideStringArray;
          const IsSortedAscending: Boolean = False): WideStringArray; overload;
function  DynArrayIntersectionU(const V1, V2: UnicodeStringArray;
          const IsSortedAscending: Boolean = False): UnicodeStringArray; overload;
function  DynArrayIntersection(const V1, V2: StringArray;
          const IsSortedAscending: Boolean = False): StringArray; overload;

function  DynArrayDifference(const V1, V2: ByteArray;
          const IsSortedAscending: Boolean = False): ByteArray; overload;
function  DynArrayDifference(const V1, V2: WordArray;
          const IsSortedAscending: Boolean = False): WordArray; overload;
function  DynArrayDifference(const V1, V2: LongWordArray;
          const IsSortedAscending: Boolean = False): LongWordArray; overload;
function  DynArrayDifference(const V1, V2: ShortIntArray;
          const IsSortedAscending: Boolean = False): ShortIntArray; overload;
function  DynArrayDifference(const V1, V2: SmallIntArray;
          const IsSortedAscending: Boolean = False): SmallIntArray; overload;
function  DynArrayDifference(const V1, V2: LongIntArray;
          const IsSortedAscending: Boolean = False): LongIntArray; overload;
function  DynArrayDifference(const V1, V2: Int64Array;
          const IsSortedAscending: Boolean = False): Int64Array; overload;
function  DynArrayDifference(const V1, V2: SingleArray;
          const IsSortedAscending: Boolean = False): SingleArray; overload;
function  DynArrayDifference(const V1, V2: DoubleArray;
          const IsSortedAscending: Boolean = False): DoubleArray; overload;
function  DynArrayDifference(const V1, V2: ExtendedArray;
          const IsSortedAscending: Boolean = False): ExtendedArray; overload;
function  DynArrayDifferenceA(const V1, V2: AnsiStringArray;
          const IsSortedAscending: Boolean = False): AnsiStringArray; overload;
function  DynArrayDifferenceW(const V1, V2: WideStringArray;
          const IsSortedAscending: Boolean = False): WideStringArray; overload;
function  DynArrayDifferenceU(const V1, V2: UnicodeStringArray;
          const IsSortedAscending: Boolean = False): UnicodeStringArray; overload;
function  DynArrayDifference(const V1, V2: StringArray;
          const IsSortedAscending: Boolean = False): StringArray; overload;

procedure DynArrayReverse(var V: ByteArray); overload;
procedure DynArrayReverse(var V: WordArray); overload;
procedure DynArrayReverse(var V: LongWordArray); overload;
procedure DynArrayReverse(var V: ShortIntArray); overload;
procedure DynArrayReverse(var V: SmallIntArray); overload;
procedure DynArrayReverse(var V: LongIntArray); overload;
procedure DynArrayReverse(var V: Int64Array); overload;
procedure DynArrayReverse(var V: SingleArray); overload;
procedure DynArrayReverse(var V: DoubleArray); overload;
procedure DynArrayReverse(var V: ExtendedArray); overload;
procedure DynArrayReverseA(var V: AnsiStringArray); overload;
procedure DynArrayReverseW(var V: WideStringArray); overload;
procedure DynArrayReverseU(var V: UnicodeStringArray); overload;
procedure DynArrayReverse(var V: StringArray); overload;
{$IFNDEF ManagedCode}
procedure DynArrayReverse(var V: PointerArray); overload;
{$ENDIF}
procedure DynArrayReverse(var V: ObjectArray); overload;

function  AsBooleanArray(const V: array of Boolean): BooleanArray; overload;
function  AsByteArray(const V: array of Byte): ByteArray; overload;
function  AsWordArray(const V: array of Word): WordArray; overload;
function  AsLongWordArray(const V: array of LongWord): LongWordArray; overload;
function  AsCardinalArray(const V: array of Cardinal): CardinalArray; overload;
function  AsNativeUIntArray(const V: array of NativeUInt): NativeUIntArray; overload;
function  AsShortIntArray(const V: array of ShortInt): ShortIntArray; overload;
function  AsSmallIntArray(const V: array of SmallInt): SmallIntArray; overload;
function  AsLongIntArray(const V: array of LongInt): LongIntArray; overload;
function  AsIntegerArray(const V: array of Integer): IntegerArray; overload;
function  AsInt64Array(const V: array of Int64): Int64Array; overload;
function  AsNativeIntArray(const V: array of NativeInt): NativeIntArray; overload;
function  AsSingleArray(const V: array of Single): SingleArray; overload;
function  AsDoubleArray(const V: array of Double): DoubleArray; overload;
function  AsExtendedArray(const V: array of Extended): ExtendedArray; overload;
function  AsCurrencyArray(const V: array of Currency): CurrencyArray; overload;
function  AsAnsiStringArray(const V: array of AnsiString): AnsiStringArray; overload;
function  AsWideStringArray(const V: array of WideString): WideStringArray; overload;
function  AsUnicodeStringArray(const V: array of UnicodeString): UnicodeStringArray; overload;
function  AsStringArray(const V: array of String): StringArray; overload;
{$IFNDEF ManagedCode}
function  AsPointerArray(const V: array of Pointer): PointerArray; overload;
{$ENDIF}
function  AsCharSetArray(const V: array of CharSet): CharSetArray; overload;
function  AsObjectArray(const V: array of TObject): ObjectArray; overload;
function  AsInterfaceArray(const V: array of IInterface): InterfaceArray; overload;

function  DynArrayRangeByte(const First: Byte; const Count: Integer;
          const Increment: Byte = 1): ByteArray;
function  DynArrayRangeWord(const First: Word; const Count: Integer;
          const Increment: Word = 1): WordArray;
function  DynArrayRangeLongWord(const First: LongWord; const Count: Integer;
          const Increment: LongWord = 1): LongWordArray;
function  DynArrayRangeCardinal(const First: Cardinal; const Count: Integer;
          const Increment: Cardinal = 1): CardinalArray;
function  DynArrayRangeShortInt(const First: ShortInt; const Count: Integer;
          const Increment: ShortInt = 1): ShortIntArray;
function  DynArrayRangeSmallInt(const First: SmallInt; const Count: Integer;
          const Increment: SmallInt = 1): SmallIntArray;
function  DynArrayRangeLongInt(const First: LongInt; const Count: Integer;
          const Increment: LongInt = 1): LongIntArray;
function  DynArrayRangeInteger(const First: Integer; const Count: Integer;
          const Increment: Integer = 1): IntegerArray;
function  DynArrayRangeInt64(const First: Int64; const Count: Integer;
          const Increment: Int64 = 1): Int64Array;
function  DynArrayRangeSingle(const First: Single; const Count: Integer;
          const Increment: Single = 1): SingleArray;
function  DynArrayRangeDouble(const First: Double; const Count: Integer;
          const Increment: Double = 1): DoubleArray;
function  DynArrayRangeExtended(const First: Extended; const Count: Integer;
          const Increment: Extended = 1): ExtendedArray;

function  DynArrayDupByte(const V: Byte; const Count: Integer): ByteArray;
function  DynArrayDupWord(const V: Word; const Count: Integer): WordArray;
function  DynArrayDupLongWord(const V: LongWord; const Count: Integer): LongWordArray;
function  DynArrayDupCardinal(const V: Cardinal; const Count: Integer): CardinalArray;
function  DynArrayDupNativeUInt(const V: NativeUInt; const Count: Integer): NativeUIntArray;
function  DynArrayDupShortInt(const V: ShortInt; const Count: Integer): ShortIntArray;
function  DynArrayDupSmallInt(const V: SmallInt; const Count: Integer): SmallIntArray;
function  DynArrayDupLongInt(const V: LongInt; const Count: Integer): LongIntArray;
function  DynArrayDupInteger(const V: Integer; const Count: Integer): IntegerArray;
function  DynArrayDupInt64(const V: Int64; const Count: Integer): Int64Array;
function  DynArrayDupNativeInt(const V: NativeInt; const Count: Integer): NativeIntArray;
function  DynArrayDupSingle(const V: Single; const Count: Integer): SingleArray;
function  DynArrayDupDouble(const V: Double; const Count: Integer): DoubleArray;
function  DynArrayDupExtended(const V: Extended; const Count: Integer): ExtendedArray;
function  DynArrayDupCurrency(const V: Currency; const Count: Integer): CurrencyArray;
function  DynArrayDupAnsiString(const V: AnsiString; const Count: Integer): AnsiStringArray;
function  DynArrayDupWideString(const V: WideString; const Count: Integer): WideStringArray;
function  DynArrayDupUnicodeString(const V: UnicodeString; const Count: Integer): UnicodeStringArray;
function  DynArrayDupString(const V: String; const Count: Integer): StringArray;
function  DynArrayDupCharSet(const V: CharSet; const Count: Integer): CharSetArray;
function  DynArrayDupObject(const V: TObject; const Count: Integer): ObjectArray;

procedure SetLengthAndZero(var V: ByteArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: WordArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: LongWordArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: NativeUIntArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: ShortIntArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: SmallIntArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: LongIntArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: Int64Array; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: NativeIntArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: SingleArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: DoubleArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: ExtendedArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: CurrencyArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: CharSetArray; const NewLength: Integer); overload;
procedure SetLengthAndZero(var V: BooleanArray; const NewLength: Integer); overload;
{$IFNDEF ManagedCode}
procedure SetLengthAndZero(var V: PointerArray; const NewLength: Integer); overload;
{$ENDIF}
procedure SetLengthAndZero(var V: ObjectArray; const NewLength: Integer;
          const FreeObjects: Boolean = False); overload;

function  DynArrayIsEqual(const V1, V2: ByteArray): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: WordArray): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: LongWordArray): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: ShortIntArray): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: SmallIntArray): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: LongIntArray): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: Int64Array): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: SingleArray): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: DoubleArray): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: ExtendedArray): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: CurrencyArray): Boolean; overload;
function  DynArrayIsEqualA(const V1, V2: AnsiStringArray): Boolean; overload;
function  DynArrayIsEqualW(const V1, V2: WideStringArray): Boolean; overload;
function  DynArrayIsEqualU(const V1, V2: UnicodeStringArray): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: StringArray): Boolean; overload;
function  DynArrayIsEqual(const V1, V2: CharSetArray): Boolean; overload;

function  ByteArrayToLongIntArray(const V: ByteArray): LongIntArray;
function  WordArrayToLongIntArray(const V: WordArray): LongIntArray;
function  ShortIntArrayToLongIntArray(const V: ShortIntArray): LongIntArray;
function  SmallIntArrayToLongIntArray(const V: SmallIntArray): LongIntArray;
function  LongIntArrayToInt64Array(const V: LongIntArray): Int64Array;
function  LongIntArrayToSingleArray(const V: LongIntArray): SingleArray;
function  LongIntArrayToDoubleArray(const V: LongIntArray): DoubleArray;
function  LongIntArrayToExtendedArray(const V: LongIntArray): ExtendedArray;
function  SingleArrayToDoubleArray(const V: SingleArray): DoubleArray;
function  SingleArrayToExtendedArray(const V: SingleArray): ExtendedArray;
function  SingleArrayToCurrencyArray(const V: SingleArray): CurrencyArray;
function  SingleArrayToLongIntArray(const V: SingleArray): LongIntArray;
function  SingleArrayToInt64Array(const V: SingleArray): Int64Array;
function  DoubleArrayToExtendedArray(const V: DoubleArray): ExtendedArray;
function  DoubleArrayToCurrencyArray(const V: DoubleArray): CurrencyArray;
function  DoubleArrayToLongIntArray(const V: DoubleArray): LongIntArray;
function  DoubleArrayToInt64Array(const V: DoubleArray): Int64Array;
function  ExtendedArrayToCurrencyArray(const V: ExtendedArray): CurrencyArray;
function  ExtendedArrayToLongIntArray(const V: ExtendedArray): LongIntArray;
function  ExtendedArrayToInt64Array(const V: ExtendedArray): Int64Array;

function  ByteArrayFromIndexes(const V: ByteArray;
          const Indexes: IntegerArray): ByteArray;
function  WordArrayFromIndexes(const V: WordArray;
          const Indexes: IntegerArray): WordArray;
function  LongWordArrayFromIndexes(const V: LongWordArray;
          const Indexes: IntegerArray): LongWordArray;
function  CardinalArrayFromIndexes(const V: CardinalArray;
          const Indexes: IntegerArray): CardinalArray;
function  ShortIntArrayFromIndexes(const V: ShortIntArray;
          const Indexes: IntegerArray): ShortIntArray;
function  SmallIntArrayFromIndexes(const V: SmallIntArray;
          const Indexes: IntegerArray): SmallIntArray;
function  LongIntArrayFromIndexes(const V: LongIntArray;
          const Indexes: IntegerArray): LongIntArray;
function  IntegerArrayFromIndexes(const V: IntegerArray;
          const Indexes: IntegerArray): IntegerArray;
function  Int64ArrayFromIndexes(const V: Int64Array;
          const Indexes: IntegerArray): Int64Array;
function  SingleArrayFromIndexes(const V: SingleArray;
          const Indexes: IntegerArray): SingleArray;
function  DoubleArrayFromIndexes(const V: DoubleArray;
          const Indexes: IntegerArray): DoubleArray;
function  ExtendedArrayFromIndexes(const V: ExtendedArray;
          const Indexes: IntegerArray): ExtendedArray;
function  StringArrayFromIndexes(const V: StringArray;
          const Indexes: IntegerArray): StringArray;

procedure DynArraySort(const V: ByteArray); overload;
procedure DynArraySort(const V: WordArray); overload;
procedure DynArraySort(const V: LongWordArray); overload;
procedure DynArraySort(const V: NativeUIntArray); overload;
procedure DynArraySort(const V: ShortIntArray); overload;
procedure DynArraySort(const V: SmallIntArray); overload;
procedure DynArraySort(const V: LongIntArray); overload;
procedure DynArraySort(const V: Int64Array); overload;
procedure DynArraySort(const V: NativeIntArray); overload;
procedure DynArraySort(const V: SingleArray); overload;
procedure DynArraySort(const V: DoubleArray); overload;
procedure DynArraySort(const V: ExtendedArray); overload;
procedure DynArraySortA(const V: AnsiStringArray); overload;
procedure DynArraySortW(const V: WideStringArray); overload;
procedure DynArraySortU(const V: UnicodeStringArray); overload;
procedure DynArraySort(const V: StringArray); overload;

procedure DynArraySort(const Key: IntegerArray; const Data: IntegerArray); overload;
procedure DynArraySort(const Key: IntegerArray; const Data: Int64Array); overload;
procedure DynArraySort(const Key: IntegerArray; const Data: AnsiStringArray); overload;
procedure DynArraySort(const Key: IntegerArray; const Data: ExtendedArray); overload;
{$IFNDEF ManagedCode}
procedure DynArraySort(const Key: IntegerArray; const Data: PointerArray); overload;
{$ENDIF}
procedure DynArraySort(const Key: AnsiStringArray; const Data: IntegerArray); overload;
procedure DynArraySort(const Key: AnsiStringArray; const Data: Int64Array); overload;
procedure DynArraySort(const Key: AnsiStringArray; const Data: AnsiStringArray); overload;
procedure DynArraySort(const Key: AnsiStringArray; const Data: ExtendedArray); overload;
{$IFNDEF ManagedCode}
procedure DynArraySort(const Key: AnsiStringArray; const Data: PointerArray); overload;
{$ENDIF}
procedure DynArraySort(const Key: ExtendedArray; const Data: IntegerArray); overload;
procedure DynArraySort(const Key: ExtendedArray; const Data: Int64Array); overload;
procedure DynArraySort(const Key: ExtendedArray; const Data: AnsiStringArray); overload;
procedure DynArraySort(const Key: ExtendedArray; const Data: ExtendedArray); overload;
{$IFNDEF ManagedCode}
procedure DynArraySort(const Key: ExtendedArray; const Data: PointerArray); overload;
{$ENDIF}



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF DYNARRAYS_SELFTEST}
procedure SelfTest;
{$ENDIF}



implementation



{                                                                              }
{ DynArrayAppend                                                               }
{                                                                              }
function DynArrayAppend(var V: ByteArray; const R: Byte): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: WordArray; const R: Word): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: LongWordArray; const R: LongWord): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: NativeUIntArray; const R: NativeUInt): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: ShortIntArray; const R: ShortInt): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: SmallIntArray; const R: SmallInt): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: LongIntArray; const R: LongInt): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: Int64Array; const R: Int64): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: NativeIntArray; const R: NativeInt): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: SingleArray; const R: Single): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: DoubleArray; const R: Double): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: ExtendedArray; const R: Extended): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: CurrencyArray; const R: Currency): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: BooleanArray; const R: Boolean): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppendA(var V: AnsiStringArray; const R: AnsiString): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppendW(var V: WideStringArray; const R: WideString): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppendU(var V: UnicodeStringArray; const R: UnicodeString): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: StringArray; const R: String): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

{$IFNDEF ManagedCode}
function DynArrayAppend(var V: PointerArray; const R: Pointer): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

{$ENDIF}
function DynArrayAppend(var V: ObjectArray; const R: TObject): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: InterfaceArray; const R: IInterface): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: ByteSetArray; const R: ByteSet): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function DynArrayAppend(var V: CharSetArray; const R: CharSet): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;



{$IFDEF ManagedCode}
function DynArrayAppendByteArray(var V: ByteArray; const R: array of Byte): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendByteArray(var V: ByteArray; const R: array of Byte): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(Byte) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendWordArray(var V: WordArray; const R: array of Word): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendWordArray(var V: WordArray; const R: array of Word): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(Word) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendCardinalArray(var V: CardinalArray; const R: array of LongWord): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendCardinalArray(var V: CardinalArray; const R: array of LongWord): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(LongWord) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendNativeUIntArray(var V: NativeUIntArray; const R: array of NativeUInt): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendNativeUIntArray(var V: NativeUIntArray; const R: array of NativeUInt): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(NativeUInt) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendShortIntArray(var V: ShortIntArray; const R: array of ShortInt): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendShortIntArray(var V: ShortIntArray; const R: array of ShortInt): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(ShortInt) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendSmallIntArray(var V: SmallIntArray; const R: array of SmallInt): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendSmallIntArray(var V: SmallIntArray; const R: array of SmallInt): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(SmallInt) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendIntegerArray(var V: IntegerArray; const R: array of LongInt): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendIntegerArray(var V: IntegerArray; const R: array of LongInt): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(LongInt) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendInt64Array(var V: Int64Array; const R: array of Int64): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendInt64Array(var V: Int64Array; const R: array of Int64): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(Int64) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendNativeIntArray(var V: NativeIntArray; const R: array of NativeInt): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendNativeIntArray(var V: NativeIntArray; const R: array of NativeInt): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(NativeInt) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendSingleArray(var V: SingleArray; const R: array of Single): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendSingleArray(var V: SingleArray; const R: array of Single): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(Single) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendDoubleArray(var V: DoubleArray; const R: array of Double): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendDoubleArray(var V: DoubleArray; const R: array of Double): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(Double) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendExtendedArray(var V: ExtendedArray; const R: array of Extended): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendExtendedArray(var V: ExtendedArray; const R: array of Extended): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(Extended) * L);
    end;
end;
{$ENDIF}

{$IFNDEF CLR}
{$IFDEF ManagedCode}
function DynArrayAppendCurrencyArray(var V: CurrencyArray; const R: array of Currency): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendCurrencyArray(var V: CurrencyArray; const R: array of Currency): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(Currency) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendPointerArray(var V: PointerArray; const R: array of Pointer): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendPointerArray(var V: PointerArray; const R: array of Pointer): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(Pointer) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendCharSetArray(var V: CharSetArray; const R: array of CharSet): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendCharSetArray(var V: CharSetArray; const R: array of CharSet): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(CharSet) * L);
    end;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayAppendByteSetArray(var V: ByteSetArray; const R: array of ByteSet): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppendByteSetArray(var V: ByteSetArray; const R: array of ByteSet): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(ByteSet) * L);
    end;
end;
{$ENDIF}

{$ENDIF}

function DynArrayAppendObjectArray(var V: ObjectArray; const R: ObjectArray): Integer;
var I, LR : Integer;
begin
  Result := Length(V);
  LR := Length(R);
  if LR > 0 then
    begin
      SetLength(V, Result + LR);
      for I := 0 to LR - 1 do
        V[Result + I] := R[I];
    end;
end;

function DynArrayAppendAnsiStringArray(var V: AnsiStringArray; const R: array of AnsiString): Integer;
var I, LR : Integer;
begin
  Result := Length(V);
  LR := Length(R);
  if LR > 0 then
    begin
      SetLength(V, Result + LR);
      for I := 0 to LR - 1 do
        V[Result + I] := R[I];
    end;
end;

function DynArrayAppendWideStringArray(var V: WideStringArray; const R: array of WideString): Integer;
var I, LR : Integer;
begin
  Result := Length(V);
  LR := Length(R);
  if LR > 0 then
    begin
      SetLength(V, Result + LR);
      for I := 0 to LR - 1 do
        V[Result + I] := R[I];
    end;
end;

function DynArrayAppendUnicodeStringArray(var V: UnicodeStringArray; const R: array of UnicodeString): Integer;
var I, LR : Integer;
begin
  Result := Length(V);
  LR := Length(R);
  if LR > 0 then
    begin
      SetLength(V, Result + LR);
      for I := 0 to LR - 1 do
        V[Result + I] := R[I];
    end;
end;

function DynArrayAppendStringArray(var V: StringArray; const R: array of String): Integer;
var I, LR : Integer;
begin
  Result := Length(V);
  LR := Length(R);
  if LR > 0 then
    begin
      SetLength(V, Result + LR);
      for I := 0 to LR - 1 do
        V[Result + I] := R[I];
    end;
end;



{                                                                              }
{ DynArrayRemove                                                               }
{                                                                              }
function DynArrayRemove(var V: ByteArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(Byte));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: WordArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(Word));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: LongWordArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(LongWord));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: NativeUIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(NativeUInt));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: ShortIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(ShortInt));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: SmallIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(SmallInt));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: LongIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(LongInt));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: Int64Array; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(Int64));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: NativeIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(NativeInt));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: SingleArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(Single));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: DoubleArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(Double));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: ExtendedArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(Extended));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

{$IFNDEF CLR}
function DynArrayRemove(var V: CurrencyArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(Currency));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: PointerArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(Pointer));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;

{$ENDIF}

function DynArrayRemove(var V: ObjectArray; const Idx: Integer; const Count: Integer;
    const FreeObjects: Boolean): Integer;
var I, J, K, L, M, F : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  if FreeObjects then
    for K := I to I + J - 1 do
      FreeAndNil(V[K]);
  M := L - J - I;
  for F := I to I + M - 1 do
    V[F] := V[F + J];
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemoveA(var V: AnsiStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  for K := I to L - J - 1 do
    V[K] := V[K + J];
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemoveW(var V: WideStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  for K := I to L - J - 1 do
    V[K] := V[K + J];
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemoveU(var V: UnicodeStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  for K := I to L - J - 1 do
    V[K] := V[K + J];
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: StringArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  for K := I to L - J - 1 do
    V[K] := V[K + J];
  SetLength(V, L - J);
  Result := J;
end;

{$IFDEF ManagedCode}
function DynArrayRemove(var V: InterfaceArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L, M, F : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  for K := I to I + J - 1 do
    V[K] := nil;
  M := L - J - I;
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  for F := 0 to J - 1 do
    V[L - J + F] := nil;
  SetLength(V, L - J);
  Result := J;
end;
{$ELSE}
function DynArrayRemove(var V: InterfaceArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L, M : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  for K := I to I + J - 1 do
    V[K] := nil;
  M := L - J - I;
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(IInterface));
  FillChar(V[L - J], J * SizeOf(IInterface), #0);
  SetLength(V, L - J);
  Result := J;
end;
{$ENDIF}



{                                                                              }
{ DynArrayRemoveDuplicates                                                     }
{                                                                              }
procedure DynArrayRemoveDuplicates(var V: ByteArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : Byte;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicates(var V: WordArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : Word;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicates(var V: LongWordArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : LongWord;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicates(var V: ShortIntArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : ShortInt;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicates(var V: SmallIntArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : SmallInt;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicates(var V: LongIntArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : LongInt;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicates(var V: Int64Array; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : Int64;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicates(var V: SingleArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : Single;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicates(var V: DoubleArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : Double;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicates(var V: ExtendedArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : Extended;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicatesA(var V: AnsiStringArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : AnsiString;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemoveA(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNextA(V[J], V, J);
          if I >= 0 then
            DynArrayRemoveA(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicatesW(var V: WideStringArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : WideString;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemoveW(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNextW(V[J], V, J);
          if I >= 0 then
            DynArrayRemoveW(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicatesU(var V: UnicodeStringArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : UnicodeString;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemoveU(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNextU(V[J], V, J);
          if I >= 0 then
            DynArrayRemoveU(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

procedure DynArrayRemoveDuplicates(var V: StringArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : String;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

{$IFNDEF ManagedCode}
procedure DynArrayRemoveDuplicates(var V: PointerArray; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : Pointer;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext(V[J], V, J);
          if I >= 0 then
            DynArrayRemove(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;

{$ENDIF}


procedure DynArrayTrimLeft(var S: ByteArray; const TrimList: array of Byte); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

procedure DynArrayTrimLeft(var S: WordArray; const TrimList: array of Word); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

procedure DynArrayTrimLeft(var S: LongWordArray; const TrimList: array of LongWord); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

procedure DynArrayTrimLeft(var S: ShortIntArray; const TrimList: array of ShortInt); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

procedure DynArrayTrimLeft(var S: SmallIntArray; const TrimList: array of SmallInt); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

procedure DynArrayTrimLeft(var S: LongIntArray; const TrimList: array of LongInt); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

procedure DynArrayTrimLeft(var S: Int64Array; const TrimList: array of Int64); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

procedure DynArrayTrimLeft(var S: SingleArray; const TrimList: array of Single); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

procedure DynArrayTrimLeft(var S: DoubleArray; const TrimList: array of Double); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

procedure DynArrayTrimLeft(var S: ExtendedArray; const TrimList: array of Extended); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

procedure DynArrayTrimLeftA(var S: AnsiStringArray; const TrimList: array of AnsiString); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemoveA(S, 0, I - 1);
end;

procedure DynArrayTrimLeftW(var S: WideStringArray; const TrimList: array of WideString); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemoveW(S, 0, I - 1);
end;

procedure DynArrayTrimLeftU(var S: UnicodeStringArray; const TrimList: array of UnicodeString); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemoveU(S, 0, I - 1);
end;

procedure DynArrayTrimLeft(var S: StringArray; const TrimList: array of String); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

{$IFNDEF ManagedCode}
procedure DynArrayTrimLeft(var S: PointerArray; const TrimList: array of Pointer); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove(S, 0, I - 1);
end;

{$ENDIF}

procedure DynArrayTrimRight(var S: ByteArray; const TrimList: array of Byte); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRight(var S: WordArray; const TrimList: array of Word); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRight(var S: LongWordArray; const TrimList: array of LongWord); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRight(var S: ShortIntArray; const TrimList: array of ShortInt); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRight(var S: SmallIntArray; const TrimList: array of SmallInt); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRight(var S: LongIntArray; const TrimList: array of LongInt); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRight(var S: Int64Array; const TrimList: array of Int64); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRight(var S: SingleArray; const TrimList: array of Single); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRight(var S: DoubleArray; const TrimList: array of Double); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRight(var S: ExtendedArray; const TrimList: array of Extended); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRightA(var S: AnsiStringArray; const TrimList: array of AnsiString); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRightW(var S: WideStringArray; const TrimList: array of WideString); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRightU(var S: UnicodeStringArray; const TrimList: array of UnicodeString); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

procedure DynArrayTrimRight(var S: StringArray; const TrimList: array of String); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

{$IFNDEF ManagedCode}
procedure DynArrayTrimRight(var S: PointerArray; const TrimList: array of Pointer); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;

{$ENDIF}

{                                                                              }
{ DynArrayInsert                                                               }
{                                                                              }
{$IFDEF ManagedCode}
function DynArrayInsert(var V: ByteArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: ByteArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(Byte));
  FillChar(P^, Count * Sizeof(Byte), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: WordArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: WordArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(Word));
  FillChar(P^, Count * Sizeof(Word), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: LongWordArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: LongWordArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(LongWord));
  FillChar(P^, Count * Sizeof(LongWord), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: NativeUIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: NativeUIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(NativeUInt));
  FillChar(P^, Count * Sizeof(NativeUInt), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: ShortIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: ShortIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(ShortInt));
  FillChar(P^, Count * Sizeof(ShortInt), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: SmallIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: SmallIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(SmallInt));
  FillChar(P^, Count * Sizeof(SmallInt), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: LongIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: LongIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(LongInt));
  FillChar(P^, Count * Sizeof(LongInt), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: Int64Array; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: Int64Array; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(Int64));
  FillChar(P^, Count * Sizeof(Int64), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: NativeIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: NativeIntArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(NativeInt));
  FillChar(P^, Count * Sizeof(NativeInt), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: SingleArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0.0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: SingleArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(Single));
  FillChar(P^, Count * Sizeof(Single), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: DoubleArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0.0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: DoubleArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(Double));
  FillChar(P^, Count * Sizeof(Double), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: ExtendedArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0.0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: ExtendedArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(Extended));
  FillChar(P^, Count * Sizeof(Extended), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: CurrencyArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := 0.0;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: CurrencyArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(Currency));
  FillChar(P^, Count * Sizeof(Currency), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsertA(var V: AnsiStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := '';
  Result := I;
end;
{$ELSE}
function DynArrayInsertA(var V: AnsiStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(AnsiString));
  FillChar(P^, Count * Sizeof(AnsiString), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsertW(var V: WideStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := '';
  Result := I;
end;
{$ELSE}
function DynArrayInsertW(var V: WideStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(WideString));
  FillChar(P^, Count * Sizeof(WideString), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsertU(var V: UnicodeStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := '';
  Result := I;
end;
{$ELSE}
function DynArrayInsertU(var V: UnicodeStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(UnicodeString));
  FillChar(P^, Count * Sizeof(UnicodeString), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: StringArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := '';
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: StringArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(String));
  FillChar(P^, Count * Sizeof(String), #0);
  Result := I;
end;
{$ENDIF}

{$IFNDEF ManagedCode}
{$IFDEF ManagedCode}
function DynArrayInsert(var V: PointerArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := nil;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: PointerArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(Pointer));
  FillChar(P^, Count * Sizeof(Pointer), #0);
  Result := I;
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayInsert(var V: ObjectArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := nil;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: ObjectArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(Pointer));
  FillChar(P^, Count * Sizeof(Pointer), #0);
  Result := I;
end;
{$ENDIF}

{$ENDIF}
{$IFDEF ManagedCode}
function DynArrayInsert(var V: InterfaceArray; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := nil;
  Result := I;
end;
{$ELSE}
function DynArrayInsert(var V: InterfaceArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(IInterface));
  FillChar(P^, Count * Sizeof(IInterface), #0);
  Result := I;
end;
{$ENDIF}



{                                                                              }
{ DynArrayPosNext                                                              }
{   PosNext finds the next occurance of Find in V, -1 if it was not found.     }
{     Searches from Item[PrevPos + 1], ie PrevPos = -1 to find first           }
{     occurance.                                                               }
{                                                                              }
function DynArrayPosNext(const Find: Byte; const V: ByteArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : Byte;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: Word; const V: WordArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : Word;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: LongWord; const V: LongWordArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : LongWord;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: NativeUInt; const V: NativeUIntArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : NativeUInt;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: ShortInt; const V: ShortIntArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : ShortInt;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: SmallInt; const V: SmallIntArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : SmallInt;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: LongInt; const V: LongIntArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : LongInt;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: Int64; const V: Int64Array; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : Int64;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: NativeInt; const V: NativeIntArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : NativeInt;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: Single; const V: SingleArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : Single;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: Double; const V: DoubleArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : Double;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: Extended; const V: ExtendedArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : Extended;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: Boolean; const V: BooleanArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : Boolean;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNextA(const Find: AnsiString; const V: AnsiStringArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : AnsiString;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNextW(const Find: WideString; const V: WideStringArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : WideString;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNextU(const Find: UnicodeString; const V: UnicodeStringArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : UnicodeString;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: String; const V: StringArray; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : String;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxI(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := V[I];
              if Find = D then
                begin
                  while (I > 0) and (V[I - 1] = Find) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if V[PrevPos + 1] = Find then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
        if V[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function DynArrayPosNext(const Find: TObject; const V: ObjectArray; const PrevPos: Integer): Integer;
var I : Integer;
begin
  for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
    if V[I] = Find then
      begin
        Result := I;
        exit;
       end;
  Result := -1;
end;

function DynArrayPosNext(const ClassType: TClass; const V: ObjectArray; const PrevPos: Integer): Integer;
var I : Integer;
begin
  for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
    if V[I] is ClassType then
      begin
        Result := I;
        exit;
       end;
  Result := -1;
end;

function DynArrayPosNext(const ClassName: String; const V: ObjectArray; const PrevPos: Integer): Integer;
var I : Integer;
    T : TObject;
begin
  for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
    begin
      T := V[I];
      if Assigned(T) and (T.ClassName = ClassName) then
        begin
          Result := I;
          exit;
         end;
    end;
  Result := -1;
end;

{$IFNDEF ManagedCode}
function DynArrayPosNext(const Find: Pointer; const V: PointerArray; const PrevPos: Integer): Integer;
var I : Integer;
begin
  for I := MaxI(PrevPos + 1, 0) to Length(V) - 1 do
    if V[I] = Find then
      begin
        Result := I;
        exit;
       end;
  Result := -1;
end;
{$ENDIF}



{                                                                              }
{ DynArrayCount                                                                }
{                                                                              }
function DynArrayCount(const Find: Byte; const V: ByteArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCount(const Find: Word; const V: WordArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCount(const Find: LongWord; const V: LongWordArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCount(const Find: ShortInt; const V: ShortIntArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCount(const Find: SmallInt; const V: SmallIntArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCount(const Find: LongInt; const V: LongIntArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCount(const Find: Int64; const V: Int64Array; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCount(const Find: Single; const V: SingleArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCount(const Find: Double; const V: DoubleArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCount(const Find: Extended; const V: ExtendedArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCountA(const Find: AnsiString; const V: AnsiStringArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNextA(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNextA(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCountW(const Find: WideString; const V: WideStringArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNextW(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNextW(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCountU(const Find: UnicodeString; const V: UnicodeStringArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNextU(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNextU(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCount(const Find: String; const V: StringArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;

function DynArrayCount(const Find: Boolean; const V: BooleanArray; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;



{                                                                              }
{ DynArrayRemoveAll                                                            }
{                                                                              }
procedure DynArrayRemoveAll(const Find: Byte; var V: ByteArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove(V, I, J);
      I := DynArrayPosNext(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAll(const Find: Word; var V: WordArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove(V, I, J);
      I := DynArrayPosNext(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAll(const Find: LongWord; var V: LongWordArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove(V, I, J);
      I := DynArrayPosNext(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAll(const Find: ShortInt; var V: ShortIntArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove(V, I, J);
      I := DynArrayPosNext(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAll(const Find: SmallInt; var V: SmallIntArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove(V, I, J);
      I := DynArrayPosNext(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAll(const Find: LongInt; var V: LongIntArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove(V, I, J);
      I := DynArrayPosNext(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAll(const Find: Int64; var V: Int64Array; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove(V, I, J);
      I := DynArrayPosNext(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAll(const Find: Single; var V: SingleArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove(V, I, J);
      I := DynArrayPosNext(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAll(const Find: Double; var V: DoubleArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove(V, I, J);
      I := DynArrayPosNext(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAll(const Find: Extended; var V: ExtendedArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove(V, I, J);
      I := DynArrayPosNext(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAllA(const Find: AnsiString; var V: AnsiStringArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNextA(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemoveA(V, I, J);
      I := DynArrayPosNextA(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAllW(const Find: WideString; var V: WideStringArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNextW(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemoveW(V, I, J);
      I := DynArrayPosNextW(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAllU(const Find: UnicodeString; var V: UnicodeStringArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNextU(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemoveU(V, I, J);
      I := DynArrayPosNextU(Find, V, I, IsSortedAscending);
    end;
end;

procedure DynArrayRemoveAll(const Find: String; var V: StringArray; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove(V, I, J);
      I := DynArrayPosNext(Find, V, I, IsSortedAscending);
    end;
end;



{                                                                              }
{ DynArrayIntersection                                                         }
{   If both arrays are sorted ascending then time is o(n) instead of o(n^2).   }
{                                                                              }
function DynArrayIntersection(const V1, V2: SingleArray; const IsSortedAscending: Boolean): SingleArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayIntersection(const V1, V2: DoubleArray; const IsSortedAscending: Boolean): DoubleArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayIntersection(const V1, V2: ExtendedArray; const IsSortedAscending: Boolean): ExtendedArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayIntersection(const V1, V2: ByteArray; const IsSortedAscending: Boolean): ByteArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayIntersection(const V1, V2: WordArray; const IsSortedAscending: Boolean): WordArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayIntersection(const V1, V2: LongWordArray; const IsSortedAscending: Boolean): LongWordArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayIntersection(const V1, V2: ShortIntArray; const IsSortedAscending: Boolean): ShortIntArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayIntersection(const V1, V2: SmallIntArray; const IsSortedAscending: Boolean): SmallIntArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayIntersection(const V1, V2: LongIntArray; const IsSortedAscending: Boolean): LongIntArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayIntersection(const V1, V2: Int64Array; const IsSortedAscending: Boolean): Int64Array;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayIntersectionA(const V1, V2: AnsiStringArray; const IsSortedAscending: Boolean): AnsiStringArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppendA(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNextA(V1[I], V2) >= 0) and (DynArrayPosNextA(V1[I], Result) = -1) then
        DynArrayAppendA(Result, V1[I]);
end;

function DynArrayIntersectionW(const V1, V2: WideStringArray; const IsSortedAscending: Boolean): WideStringArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppendW(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNextW(V1[I], V2) >= 0) and (DynArrayPosNextW(V1[I], Result) = -1) then
        DynArrayAppendW(Result, V1[I]);
end;

function DynArrayIntersectionU(const V1, V2: UnicodeStringArray; const IsSortedAscending: Boolean): UnicodeStringArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppendU(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNextU(V1[I], V2) >= 0) and (DynArrayPosNextU(V1[I], Result) = -1) then
        DynArrayAppendU(Result, V1[I]);
end;

function DynArrayIntersection(const V1, V2: StringArray; const IsSortedAscending: Boolean): StringArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;



{                                                                              }
{ DynArrayDifference                                                           }
{   Returns elements in V1 but not in V2.                                      }
{   If both arrays are sorted ascending then time is o(n) instead of o(n^2).   }
{                                                                              }
function DynArrayDifference(const V1, V2: SingleArray; const IsSortedAscending: Boolean): SingleArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayDifference(const V1, V2: DoubleArray; const IsSortedAscending: Boolean): DoubleArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayDifference(const V1, V2: ExtendedArray; const IsSortedAscending: Boolean): ExtendedArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayDifference(const V1, V2: ByteArray; const IsSortedAscending: Boolean): ByteArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayDifference(const V1, V2: WordArray; const IsSortedAscending: Boolean): WordArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayDifference(const V1, V2: LongWordArray; const IsSortedAscending: Boolean): LongWordArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayDifference(const V1, V2: ShortIntArray; const IsSortedAscending: Boolean): ShortIntArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayDifference(const V1, V2: SmallIntArray; const IsSortedAscending: Boolean): SmallIntArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayDifference(const V1, V2: LongIntArray; const IsSortedAscending: Boolean): LongIntArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayDifference(const V1, V2: Int64Array; const IsSortedAscending: Boolean): Int64Array;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;

function DynArrayDifferenceA(const V1, V2: AnsiStringArray; const IsSortedAscending: Boolean): AnsiStringArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppendA(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNextA(V1[I], V2) = -1) and (DynArrayPosNextA(V1[I], Result) = -1) then
        DynArrayAppendA(Result, V1[I]);
end;

function DynArrayDifferenceW(const V1, V2: WideStringArray; const IsSortedAscending: Boolean): WideStringArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppendW(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNextW(V1[I], V2) = -1) and (DynArrayPosNextW(V1[I], Result) = -1) then
        DynArrayAppendW(Result, V1[I]);
end;

function DynArrayDifferenceU(const V1, V2: UnicodeStringArray; const IsSortedAscending: Boolean): UnicodeStringArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppendU(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNextU(V1[I], V2) = -1) and (DynArrayPosNextU(V1[I], Result) = -1) then
        DynArrayAppendU(Result, V1[I]);
end;

function DynArrayDifference(const V1, V2: StringArray; const IsSortedAscending: Boolean): StringArray;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;



{                                                                              }
{ DynArrayReverse                                                              }
{                                                                              }
procedure DynArrayReverse(var V: ByteArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

procedure DynArrayReverse(var V: WordArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

procedure DynArrayReverse(var V: LongWordArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

procedure DynArrayReverse(var V: ShortIntArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

procedure DynArrayReverse(var V: SmallIntArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

procedure DynArrayReverse(var V: LongIntArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

procedure DynArrayReverse(var V: Int64Array);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

procedure DynArrayReverseA(var V: AnsiStringArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    SwapA(V[I - 1], V[L - I]);
end;

procedure DynArrayReverseW(var V: WideStringArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    SwapW(V[I - 1], V[L - I]);
end;

procedure DynArrayReverseU(var V: UnicodeStringArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    SwapU(V[I - 1], V[L - I]);
end;

procedure DynArrayReverse(var V: StringArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

{$IFNDEF ManagedCode}
procedure DynArrayReverse(var V: PointerArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

{$ENDIF}
procedure DynArrayReverse(var V: ObjectArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

procedure DynArrayReverse(var V: SingleArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

procedure DynArrayReverse(var V: DoubleArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;

procedure DynArrayReverse(var V: ExtendedArray);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap(V[I - 1], V[L - I]);
end;



{                                                                              }
{ Returns an open array (V) as a dynamic array.                                }
{                                                                              }
function AsBooleanArray(const V: array of Boolean): BooleanArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsByteArray(const V: array of Byte): ByteArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsWordArray(const V: array of Word): WordArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsLongWordArray(const V: array of LongWord): LongWordArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsCardinalArray(const V: array of Cardinal): CardinalArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsNativeUIntArray(const V: array of NativeUInt): NativeUIntArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsShortIntArray(const V: array of ShortInt): ShortIntArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsSmallIntArray(const V: array of SmallInt): SmallIntArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsLongIntArray(const V: array of LongInt): LongIntArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsIntegerArray(const V: array of Integer): IntegerArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsInt64Array(const V: array of Int64): Int64Array;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsNativeIntArray(const V: array of NativeInt): NativeIntArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsSingleArray(const V: array of Single): SingleArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsDoubleArray(const V: array of Double): DoubleArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsExtendedArray(const V: array of Extended): ExtendedArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsCurrencyArray(const V: array of Currency): CurrencyArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsAnsiStringArray(const V: array of AnsiString): AnsiStringArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsWideStringArray(const V: array of WideString): WideStringArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsUnicodeStringArray(const V: array of UnicodeString): UnicodeStringArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsStringArray(const V: array of String): StringArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

{$IFNDEF ManagedCode}
function AsPointerArray(const V: array of Pointer): PointerArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

{$ENDIF}
function AsCharSetArray(const V: array of CharSet): CharSetArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsObjectArray(const V: array of TObject): ObjectArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsInterfaceArray(const V: array of IInterface): InterfaceArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;



function DynArrayRangeByte(const First: Byte; const Count: Integer; const Increment: Byte): ByteArray;
var I : Integer;
    J : Byte;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;

function DynArrayRangeWord(const First: Word; const Count: Integer; const Increment: Word): WordArray;
var I : Integer;
    J : Word;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;

function DynArrayRangeLongWord(const First: LongWord; const Count: Integer; const Increment: LongWord): LongWordArray;
var I : Integer;
    J : LongWord;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;

function DynArrayRangeCardinal(const First: Cardinal; const Count: Integer; const Increment: Cardinal): CardinalArray;
var I : Integer;
    J : Cardinal;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;

function DynArrayRangeShortInt(const First: ShortInt; const Count: Integer; const Increment: ShortInt): ShortIntArray;
var I : Integer;
    J : ShortInt;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;

function DynArrayRangeSmallInt(const First: SmallInt; const Count: Integer; const Increment: SmallInt): SmallIntArray;
var I : Integer;
    J : SmallInt;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;

function DynArrayRangeLongInt(const First: LongInt; const Count: Integer; const Increment: LongInt): LongIntArray;
var I : Integer;
    J : LongInt;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;

function DynArrayRangeInteger(const First: Integer; const Count: Integer; const Increment: Integer): IntegerArray;
var I : Integer;
    J : Integer;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;

function DynArrayRangeInt64(const First: Int64; const Count: Integer; const Increment: Int64): Int64Array;
var I : Integer;
    J : Int64;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;

function DynArrayRangeSingle(const First: Single; const Count: Integer; const Increment: Single): SingleArray;
var I : Integer;
    J : Single;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;

function DynArrayRangeDouble(const First: Double; const Count: Integer; const Increment: Double): DoubleArray;
var I : Integer;
    J : Double;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;

function DynArrayRangeExtended(const First: Extended; const Count: Integer; const Increment: Extended): ExtendedArray;
var I : Integer;
    J : Extended;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;



{                                                                              }
{ DynArrayDup                                                                  }
{                                                                              }
{$IFDEF ManagedCode}
function DynArrayDupByte(const V: Byte; const Count: Integer): ByteArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := 0;
end;
{$ELSE}
function DynArrayDupByte(const V: Byte; const Count: Integer): ByteArray;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  FillChar(Result[0], Count, V);
end;
{$ENDIF}

function DynArrayDupWord(const V: Word; const Count: Integer): WordArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupLongWord(const V: LongWord; const Count: Integer): LongWordArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupCardinal(const V: Cardinal; const Count: Integer): CardinalArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupNativeUInt(const V: NativeUInt; const Count: Integer): NativeUIntArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupShortInt(const V: ShortInt; const Count: Integer): ShortIntArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupSmallInt(const V: SmallInt; const Count: Integer): SmallIntArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupLongInt(const V: LongInt; const Count: Integer): LongIntArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupInteger(const V: Integer; const Count: Integer): IntegerArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupInt64(const V: Int64; const Count: Integer): Int64Array;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupNativeInt(const V: NativeInt; const Count: Integer): NativeIntArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupSingle(const V: Single; const Count: Integer): SingleArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupDouble(const V: Double; const Count: Integer): DoubleArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupExtended(const V: Extended; const Count: Integer): ExtendedArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupCurrency(const V: Currency; const Count: Integer): CurrencyArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupAnsiString(const V: AnsiString; const Count: Integer): AnsiStringArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupWideString(const V: WideString; const Count: Integer): WideStringArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupUnicodeString(const V: UnicodeString; const Count: Integer): UnicodeStringArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupString(const V: String; const Count: Integer): StringArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupCharSet(const V: CharSet; const Count: Integer): CharSetArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;

function DynArrayDupObject(const V: TObject; const Count: Integer): ObjectArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;



{                                                                              }
{ SetLengthAndZero                                                             }
{                                                                              }
{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: ByteArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: ByteArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(Byte) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: WordArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: WordArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(Word) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: LongWordArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: LongWordArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(LongWord) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: NativeUIntArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: NativeUIntArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(NativeUInt) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: ShortIntArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: ShortIntArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(ShortInt) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: SmallIntArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: SmallIntArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(SmallInt) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: LongIntArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: LongIntArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(LongInt) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: Int64Array; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: Int64Array; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(Int64) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: NativeIntArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: NativeIntArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(NativeInt) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: SingleArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0.0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: SingleArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(Single) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: DoubleArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0.0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: DoubleArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(Double) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: ExtendedArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0.0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: ExtendedArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(Extended) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: CurrencyArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := 0.0;
end;
{$ELSE}
procedure SetLengthAndZero(var V: CurrencyArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(Currency) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: CharSetArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := [];
end;
{$ELSE}
procedure SetLengthAndZero(var V: CharSetArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(CharSet) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: BooleanArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := False;
end;
{$ELSE}
procedure SetLengthAndZero(var V: BooleanArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(Boolean) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$IFNDEF Managedcode}
{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: PointerArray; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := nil;
end;
{$ELSE}
procedure SetLengthAndZero(var V: PointerArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(Pointer) * (NewLen - OldLen), #0);
end;
{$ENDIF}

{$ENDIF}
procedure SetLengthAndZero(var V: ObjectArray; const NewLength: Integer;
    const FreeObjects: Boolean);
var I, L : Integer;
begin
  L := Length(V);
  if L = NewLength then
    exit;
  if (L > NewLength) and FreeObjects then
    for I := NewLength to L - 1 do
      FreeAndNil(V[I]);
  SetLength(V, NewLength);
  if L > NewLength then
    exit;
  {$IFDEF ManagedCode}
  for I := 0 to NewLength - L - 1 do
    V[L + I] := nil;
  {$ELSE}
  FillChar(V[L], Sizeof(Pointer) * (NewLength - L), #0);
  {$ENDIF}
end;



{                                                                              }
{ DynArrayIsEqual                                                              }
{                                                                              }
{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: ByteArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: ByteArray): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Byte) * L);
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: WordArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: WordArray): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Word) * L);
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: LongWordArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: LongWordArray): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(LongWord) * L);
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: ShortIntArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: ShortIntArray): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(ShortInt) * L);
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: SmallIntArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: SmallIntArray): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(SmallInt) * L);
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: LongIntArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: LongIntArray): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(LongInt) * L);
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: Int64Array): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: Int64Array): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Int64) * L);
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: SingleArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: SingleArray): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Single) * L);
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: DoubleArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: DoubleArray): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Double) * L);
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: ExtendedArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: ExtendedArray): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Extended) * L);
end;
{$ENDIF}

{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: CurrencyArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: CurrencyArray): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Currency) * L);
end;
{$ENDIF}

function DynArrayIsEqualA(const V1, V2: AnsiStringArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function DynArrayIsEqualW(const V1, V2: WideStringArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function DynArrayIsEqualU(const V1, V2: UnicodeStringArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function DynArrayIsEqual(const V1, V2: StringArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function DynArrayIsEqual(const V1, V2: CharSetArray): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;



{                                                                              }
{ Dynamic array to Dynamic array                                               }
{                                                                              }
function ByteArrayToLongIntArray(const V: ByteArray): LongIntArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function WordArrayToLongIntArray(const V: WordArray): LongIntArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function ShortIntArrayToLongIntArray(const V: ShortIntArray): LongIntArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function SmallIntArrayToLongIntArray(const V: SmallIntArray): LongIntArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function LongIntArrayToInt64Array(const V: LongIntArray): Int64Array;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function LongIntArrayToSingleArray(const V: LongIntArray): SingleArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function LongIntArrayToDoubleArray(const V: LongIntArray): DoubleArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function LongIntArrayToExtendedArray(const V: LongIntArray): ExtendedArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function SingleArrayToDoubleArray(const V: SingleArray): DoubleArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function SingleArrayToExtendedArray(const V: SingleArray): ExtendedArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function SingleArrayToCurrencyArray(const V: SingleArray): CurrencyArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function SingleArrayToLongIntArray(const V: SingleArray): LongIntArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := LongInt(Trunc(V[I]));
end;

function SingleArrayToInt64Array(const V: SingleArray): Int64Array;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := Trunc(V[I]);
end;

function DoubleArrayToExtendedArray(const V: DoubleArray): ExtendedArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function DoubleArrayToCurrencyArray(const V: DoubleArray): CurrencyArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function DoubleArrayToLongIntArray(const V: DoubleArray): LongIntArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := LongInt(Trunc(V[I]));
end;

function DoubleArrayToInt64Array(const V: DoubleArray): Int64Array;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := Trunc(V[I]);
end;

function ExtendedArrayToCurrencyArray(const V: ExtendedArray): CurrencyArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[I];
end;

function ExtendedArrayToLongIntArray(const V: ExtendedArray): LongIntArray;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := LongInt(Trunc(V[I]));
end;

function ExtendedArrayToInt64Array(const V: ExtendedArray): Int64Array;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := Trunc(V[I]);
end;



{                                                                              }
{ Array from indexes                                                           }
{                                                                              }
function ByteArrayFromIndexes(const V: ByteArray; const Indexes: IntegerArray): ByteArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function WordArrayFromIndexes(const V: WordArray; const Indexes: IntegerArray): WordArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function LongWordArrayFromIndexes(const V: LongWordArray; const Indexes: IntegerArray): LongWordArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function CardinalArrayFromIndexes(const V: CardinalArray; const Indexes: IntegerArray): CardinalArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function ShortIntArrayFromIndexes(const V: ShortIntArray; const Indexes: IntegerArray): ShortIntArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function SmallIntArrayFromIndexes(const V: SmallIntArray; const Indexes: IntegerArray): SmallIntArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function LongIntArrayFromIndexes(const V: LongIntArray; const Indexes: IntegerArray): LongIntArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function IntegerArrayFromIndexes(const V: IntegerArray; const Indexes: IntegerArray): IntegerArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function Int64ArrayFromIndexes(const V: Int64Array; const Indexes: IntegerArray): Int64Array;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function SingleArrayFromIndexes(const V: SingleArray; const Indexes: IntegerArray): SingleArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function DoubleArrayFromIndexes(const V: DoubleArray; const Indexes: IntegerArray): DoubleArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function ExtendedArrayFromIndexes(const V: ExtendedArray; const Indexes: IntegerArray): ExtendedArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

function StringArrayFromIndexes(const V: StringArray; const Indexes: IntegerArray): StringArray;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;



{                                                                              }
{ Dynamic array sort                                                           }
{                                                                              }
{$IFDEF ManagedCode}
procedure DynArraySort(const V: ByteArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Byte;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: ByteArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Byte;
      P, Q    : PByte;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: WordArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Word;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: WordArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Word;
      P, Q    : PWord;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: LongWordArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : LongWord;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: LongWordArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : LongWord;
      P, Q    : PLongWord;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: NativeUIntArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : NativeUInt;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: NativeUIntArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : NativeUInt;
      P, Q    : PNativeUInt;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: ShortIntArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : ShortInt;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: ShortIntArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : ShortInt;
      P, Q    : PShortInt;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: SmallIntArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : SmallInt;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: SmallIntArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : SmallInt;
      P, Q    : PSmallInt;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: LongIntArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : LongInt;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: LongIntArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : LongInt;
      P, Q    : PLongInt;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: Int64Array);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Int64;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: Int64Array);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Int64;
      P, Q    : PInt64;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: NativeIntArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : NativeInt;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: NativeIntArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : NativeInt;
      P, Q    : PNativeInt;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: SingleArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Single;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: SingleArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Single;
      P, Q    : PSingle;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: DoubleArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Double;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: DoubleArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Double;
      P, Q    : PDouble;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: ExtendedArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: ExtendedArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
      P, Q    : PExtended;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySortA(const V: AnsiStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySortA(const V: AnsiStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
      P, Q    : PAnsiString;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySortW(const V: WideStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : WideString;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySortW(const V: WideStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : WideString;
      P, Q    : PWideString;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySortU(const V: UnicodeStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : UnicodeString;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySortU(const V: UnicodeStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : UnicodeString;
      P, Q    : PUnicodeString;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const V: StringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : String;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const V: StringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : String;
      P, Q    : PString;
  begin
    repeat
      I := L;
      P := @V[I];
      J := R;
      Q := @V[J];
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}



{$IFDEF ManagedCode}
procedure DynArraySort(const Key: IntegerArray; const Data: IntegerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Integer;
      A       : Integer;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: IntegerArray; const Data: IntegerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Integer;
      P, Q    : PInteger;
      A       : Integer;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const Key: IntegerArray; const Data: Int64Array);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Integer;
      A       : Int64;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: IntegerArray; const Data: Int64Array);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Integer;
      P, Q    : PInteger;
      A       : Int64;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const Key: IntegerArray; const Data: AnsiStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Integer;
      A       : AnsiString;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: IntegerArray; const Data: AnsiStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Integer;
      P, Q    : PInteger;
      A       : AnsiString;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const Key: IntegerArray; const Data: ExtendedArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Integer;
      A       : Extended;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: IntegerArray; const Data: ExtendedArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Integer;
      P, Q    : PInteger;
      A       : Extended;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFNDEF ManagedCode}
{$IFDEF ManagedCode}
procedure DynArraySort(const Key: IntegerArray; const Data: PointerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Integer;
      A       : Pointer;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: IntegerArray; const Data: PointerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Integer;
      P, Q    : PInteger;
      A       : Pointer;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$ENDIF}
{$IFDEF ManagedCode}
procedure DynArraySort(const Key: AnsiStringArray; const Data: IntegerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
      A       : Integer;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: AnsiStringArray; const Data: IntegerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
      P, Q    : PAnsiString;
      A       : Integer;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const Key: AnsiStringArray; const Data: Int64Array);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
      A       : Int64;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: AnsiStringArray; const Data: Int64Array);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
      P, Q    : PAnsiString;
      A       : Int64;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const Key: AnsiStringArray; const Data: AnsiStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
      A       : AnsiString;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: AnsiStringArray; const Data: AnsiStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
      P, Q    : PAnsiString;
      A       : AnsiString;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const Key: AnsiStringArray; const Data: ExtendedArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
      A       : Extended;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: AnsiStringArray; const Data: ExtendedArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
      P, Q    : PAnsiString;
      A       : Extended;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFNDEF Managedcode}
{$IFDEF ManagedCode}
procedure DynArraySort(const Key: AnsiStringArray; const Data: PointerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
      A       : Pointer;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: AnsiStringArray; const Data: PointerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : AnsiString;
      P, Q    : PAnsiString;
      A       : Pointer;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$ENDIF}
{$IFDEF ManagedCode}
procedure DynArraySort(const Key: ExtendedArray; const Data: IntegerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
      A       : Integer;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: ExtendedArray; const Data: IntegerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
      P, Q    : PExtended;
      A       : Integer;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const Key: ExtendedArray; const Data: Int64Array);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
      A       : Int64;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: ExtendedArray; const Data: Int64Array);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
      P, Q    : PExtended;
      A       : Int64;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const Key: ExtendedArray; const Data: AnsiStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
      A       : AnsiString;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: ExtendedArray; const Data: AnsiStringArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
      P, Q    : PExtended;
      A       : AnsiString;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure DynArraySort(const Key: ExtendedArray; const Data: ExtendedArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
      A       : Extended;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: ExtendedArray; const Data: ExtendedArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
      P, Q    : PExtended;
      A       : Extended;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$IFNDEF ManagedCode}
{$IFDEF ManagedCode}
procedure DynArraySort(const Key: ExtendedArray; const Data: PointerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
      A       : Pointer;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: ExtendedArray; const Data: PointerArray);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : Extended;
      P, Q    : PExtended;
      A       : Pointer;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}

{$ENDIF}



{$IFNDEF CLR}
{                                                                              }
{ Generic quick sort algorithm                                                 }
{                                                                              }
procedure GenericQuickSort(const Data: Pointer; const Count: Integer;
          const CompareFunc: TQuickSortCompareFunction;
          const SwapFunc: TQuickSortSwapFunction);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      repeat
        while CompareFunc(Data, I, M) = crLess do
          Inc(I);
        while CompareFunc(Data, J, M) = crGreater do
          Dec(J);
        if I <= J then
          begin
            SwapFunc(Data, I, J);
            if M = I then
              M := J
            else
              if M = J then
                M := I;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

begin
  if Count > 0 then
    QuickSort(0, Count - 1);
end;



{                                                                              }
{ Generic binary search algorithm                                              }
{                                                                              }
function GenericBinarySearch(const Data: Pointer; const Count: Integer;
         const Item: Pointer;
         const CompareFunc: TBinarySearchCompareFunction): Integer;
var L, H, I : Integer;
begin
  L := 0;
  H := Count - 1;
  while L <= H do
    begin
      I := (L + H) div 2;
      case CompareFunc(Data, I, Item) of
        crEqual :
          begin
            while (I > 0) and (CompareFunc(Data, I - 1, Item) = crEqual) do
              Dec(I);
            Result := I;
            exit;
          end;
        crGreater : H := I - 1;
        crLess    : L := I + 1;
      end;
    end;
  Result := -1;
end;
{$ENDIF}



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF DYNARRAYS_SELFTEST}
{$ASSERTIONS ON}
procedure Test_IntegerArray;
var S, T : IntegerArray;
    F    : Integer;
begin
  S := nil;
  for F := 1 to 100 do
    begin
      DynArrayAppend(S, F);
      Assert(Length(S) = F,                 'Append');
      Assert(S[F - 1] = F,                  'Append');
    end;

  T := Copy(S);
  DynArrayAppendIntegerArray(S, T);
  for F := 1 to 100 do
    Assert(S[F + 99] = F,                   'Append');
  Assert(DynArrayPosNext(60, S) = 59,               'PosNext');
  Assert(DynArrayPosNext(60, T) = 59,               'PosNext');
  Assert(DynArrayPosNext(60, S, 59) = 159,          'PosNext');
  Assert(DynArrayPosNext(60, T, 59) = -1,           'PosNext');
  Assert(DynArrayPosNext(60, T, -1, True) = 59,     'PosNext');
  Assert(DynArrayPosNext(60, T, 59, True) = -1,     'PosNext');

  for F := 1 to 100 do
    begin
      DynArrayRemove(S, DynArrayPosNext(F, S), 1);
      Assert(Length(S) = 200 - F,           'Remove');
    end;
  for F := 99 downto 0 do
    begin
      DynArrayRemove(S, DynArrayPosNext(F xor 3 + 1, S), 1);
      Assert(Length(S) = F,                 'Remove');
    end;

  S := AsIntegerArray([3, 1, 2, 5, 4]);
  DynArraySort(S);
  Assert(S[0] = 1, 'Sort');
  Assert(S[1] = 2, 'Sort');
  Assert(S[2] = 3, 'Sort');
  Assert(S[3] = 4, 'Sort');
  Assert(S[4] = 5, 'Sort');

  S := AsIntegerArray([3, 5, 5, 2, 5, 5, 1]);
  DynArraySort(S);
  Assert(S[0] = 1, 'Sort');
  Assert(S[1] = 2, 'Sort');
  Assert(S[2] = 3, 'Sort');
  Assert(S[3] = 5, 'Sort');
  Assert(S[4] = 5, 'Sort');
  Assert(S[5] = 5, 'Sort');
  Assert(S[6] = 5, 'Sort');

  SetLength(S, 1000);
  for F := 0 to 999 do
    S[F] := F mod 5;
  DynArraySort(S);
  for F := 0 to 999 do
    Assert(S[F] = F div 200, 'Sort');

  S := AsIntegerArray([6, 3, 5, 1]);
  T := AsIntegerArray([1, 2, 3, 4]);
  DynArraySort(S, T);
  Assert(S[0] = 1, 'Sort');
  Assert(S[1] = 3, 'Sort');
  Assert(S[2] = 5, 'Sort');
  Assert(S[3] = 6, 'Sort');
  Assert(T[0] = 4, 'Sort');
  Assert(T[1] = 2, 'Sort');
  Assert(T[2] = 3, 'Sort');
  Assert(T[3] = 1, 'Sort');
end;

procedure Test_ObjectArray;
var S, T : ObjectArray;
    F    : Integer;
    V    : TObject;
begin
  S := nil;
  V := TObject.Create;
  try
    for F := 1 to 100 do
      begin
        DynArrayAppend(S, V);
        Assert(Length(S) = F,            'Append');
        Assert(S[F - 1] = V,             'Append');
      end;
    T := Copy(S);
    for F := 1 to 10 do
      begin
        DynArrayRemove(S, F - 1, 1, False);
        Assert(Length(S) = 100 - F,      'Remove');
      end;
    DynArrayRemove(S, 89, 1, False);
    Assert(Length(S) = 89,               'Remove');
    DynArrayRemove(S, 87, 1, False);
    Assert(Length(S) = 88,               'Remove');
    DynArrayAppendObjectArray(S, T);
    Assert(Length(S) = 188,              'AppendObjectArray');
    DynArrayRemove(S, 10, 88, False);
    Assert(Length(S) = 100,              'Remove');
    DynArrayRemove(S, 0, 100, False);
    Assert(Length(S) = 0,                'Remove');
  finally
    V.Free;
  end;
end;

procedure Test_StringArray;
var S, T : StringArray;
    U    : String;
    F    : Integer;
begin
  S := nil;
  for F := 1 to 100 do
    begin
      U := IntToStr(F);
      DynArrayAppend(S, U);
      Assert(Length(S) = F,                 'Append');
      Assert(S[F - 1] = U,                  'Append');
    end;

  T := Copy(S);
  DynArrayAppendStringArray(S, T);
  for F := 1 to 100 do
    Assert(S[F + 99] = IntToStr(F),         'Append');
  Assert(DynArrayPosNext('60', S) = 59,               'PosNext');
  Assert(DynArrayPosNext('60', T) = 59,               'PosNext');
  Assert(DynArrayPosNext('60', S, 59) = 159,          'PosNext');
  Assert(DynArrayPosNext('60', T, 59) = -1,           'PosNext');
  Assert(DynArrayPosNext('60', T, -1, True) = 59,     'PosNext');
  Assert(DynArrayPosNext('60', T, 59, True) = -1,     'PosNext');

  for F := 1 to 100 do
    begin
      DynArrayRemove(S, DynArrayPosNext(IntToStr(F), S), 1);
      Assert(Length(S) = 200 - F,           'Remove');
    end;
  for F := 99 downto 0 do
    begin
      DynArrayRemove(S, DynArrayPosNext(IntToStr(F xor 3 + 1), S), 1);
      Assert(Length(S) = F,                 'Remove');
    end;

  S := AsStringArray(['3', '1', '2', '5', '4']);
  DynArraySort(S);
  Assert(S[0] = '1', 'Sort');
  Assert(S[1] = '2', 'Sort');
  Assert(S[2] = '3', 'Sort');
  Assert(S[3] = '4', 'Sort');
  Assert(S[4] = '5', 'Sort');

  S := AsStringArray(['3', '5', '5', '2', '5', '5', '1']);
  DynArraySort(S);
  Assert(S[0] = '1', 'Sort');
  Assert(S[1] = '2', 'Sort');
  Assert(S[2] = '3', 'Sort');
  Assert(S[3] = '5', 'Sort');
  Assert(S[4] = '5', 'Sort');
  Assert(S[5] = '5', 'Sort');
  Assert(S[6] = '5', 'Sort');

  SetLength(S, 1000);
  for F := 0 to 999 do
    S[F] := IntToStr(F mod 5);
  DynArraySort(S);
  for F := 0 to 999 do
    Assert(S[F] = IntToStr(F div 200), 'Sort');
end;

procedure SelfTest;
begin
  Test_IntegerArray;
  Test_ObjectArray;
  Test_StringArray;
end;
{$ENDIF}



end.

