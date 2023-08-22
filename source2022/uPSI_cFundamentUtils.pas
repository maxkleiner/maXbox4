unit uPSI_cFundamentUtils;
{
  a long time to convert , with a group of selftest
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
  TPSImport_cUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IInterface(CL: TPSPascalCompiler);
procedure SIRegister_cFundamentUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cFundamentUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   cFundamentUtils;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IInterface(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInterface') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInterface, 'IInterface') do begin
    RegisterMethod('Function QueryInterface( const IID : TGUID; out Obj) : HResult', CdStdCall);
    RegisterMethod('Function _AddRef : Integer', CdStdCall);
    RegisterMethod('Function _Release : Integer', CdStdCall);
  end;
end;

procedure myinclude(var aset:charset; achar:char);
begin
   include(aset, achar) ;
end;

procedure myexclude(var aset:charset; achar:char);
begin
   exclude(aset, achar);
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_cFundamentUtils(CL: TPSPascalCompiler);
var cardb: cardinal;
  MinByte, MaxByte: Byte;
  MinWord, MaxWord: Word;
  MinShortInt, MaxShortInt: ShortInt;
  MinSmallInt, MaxSmallInt: SmallInt;
  MinLongWord, MaxLongWord: LongWord;
  MinLongInt, MaxLongInt: LongInt;
  MinInt64, MaxInt64: Int64;
  MinInteger, MaxInteger: Integer;
  MinCardinal, MaxCardinal: Cardinal;
  MinNativeUInt, MaxNativeUInt: NativeUInt;
  MinNativeInt, MaxNativeInt: NativeInt;
begin
  cardb:= sizeOF(Cardinal);
  MinByte:= Low(Byte);
  MaxByte:= High(Byte);
  MinWord:= Low(Word);
  MaxWord:= High(Word);
  MinShortInt:= Low(ShortInt);
  MaxShortInt:= High(ShortInt);
  MinSmallInt:= Low(SmallInt);
  MaxSmallInt:= High(SmallInt);
  MinLongWord:= LongWord(Low(LongWord));
  MaxLongWord:= LongWord(High(LongWord));
  MinLongInt:= LongInt(Low(LongInt));
  MaxLongInt:= LongInt(High(LongInt));
  MinInt64:= Int64(Low(Int64));
  MaxInt64:= Int64(High(Int64));
  MinInteger:= Integer(Low(Integer));
  MaxInteger:= Integer(High(Integer));
  MinCardinal:= Cardinal(Low(Cardinal));
  MaxCardinal:= Cardinal(High(Cardinal));
  MinNativeUInt:= NativeUInt(Low(NativeUInt));
  MaxNativeUInt:= NativeUInt(High(NativeUInt));
  MinNativeInt:= NativeInt(Low(NativeInt));
  MaxNativeInt:= NativeInt(High(NativeInt));
  CL.AddTypeS('Int8', 'ShortInt');
  CL.AddTypeS('Int16', 'SmallInt');
  CL.AddTypeS('Int32', 'LongInt');
  CL.AddTypeS('UInt8', 'Byte');
  CL.AddTypeS('UInt16', 'Word');
  CL.AddTypeS('UInt32', 'LongWord');
  CL.AddTypeS('UInt64', 'Int64');
  CL.AddTypeS('Word8', 'UInt8');
  CL.AddTypeS('Word16', 'UInt16');
  CL.AddTypeS('Word32', 'UInt32');
  CL.AddTypeS('Word64', 'UInt64');
  CL.AddTypeS('LargeInt', 'Int64');
  CL.AddTypeS('NativeInt', 'Integer');
  CL.AddTypeS('NativeUInt', 'Cardinal');
 CL.AddConstantN('BitsPerByte','LongInt').SetInt( 8);
 CL.AddConstantN('BitsPerWord','LongInt').SetInt( 16);
 CL.AddConstantN('BitsPerLongWord','LongInt').SetInt( 32);
 CL.AddConstantN('BytesPerCardinal','LongInt').SetInt(Cardb);
 CL.AddConstantN('BytesPerNativeWord','LongInt').SetInt(MaxNativeInt);

 CL.AddConstantN('MinByte','Byte').setInt(minbyte);
 CL.AddConstantN('MaxByte','Byte').SetInt(maxbyte);
 CL.AddConstantN('MinWord','Word').SetInt(minword);
 CL.AddConstantN('MaxWord','Word').SetInt(maxword);
 CL.AddConstantN('MinShortInt','ShortInt').SetInt(minshortint);
 CL.AddConstantN('MaxShortInt','ShortInt').SetInt(maxshortint);
 CL.AddConstantN('MinSmallInt','SmallInt').SetInt(minsmallint);
 CL.AddConstantN('MaxSmallInt','SmallInt').SetInt(maxsmallint);
 CL.AddConstantN('MinLongWord','LongWord').SetInt(minlongword);
 CL.AddConstantN('MaxLongWord','LongWord').SetInt(maxlongword);
 CL.AddConstantN('MinLongInt','LongInt').SetInt(minshortint);
 CL.AddConstantN('MaxLongInt','LongInt').SetInt(maxshortint);
 CL.AddConstantN('MinInt64','Int64').SetInt64(minint64);
 CL.AddConstantN('MaxInt64','Int64').SetInt64(maxint64);
 CL.AddConstantN('MinInteger','Integer').SetInt(mininteger);
 CL.AddConstantN('MaxInteger','Integer').SetInt(maxinteger);
 CL.AddConstantN('MinCardinal','Cardinal').SetUInt(mincardinal);
 CL.AddConstantN('MaxCardinal','Cardinal').SetUInt(maxcardinal);
 CL.AddConstantN('MinNativeUInt','NativeUInt').SetUInt(minnativeuint);
 CL.AddConstantN('MaxNativeUInt','NativeUInt').SetUInt(maxnativeuint);
 CL.AddConstantN('MinNativeInt','NativeInt').SetInt(minnativeint);
 CL.AddConstantN('MaxNativeInt','NativeInt').SetInt(maxnativeint);

 //CL.AddConstantN('BitsPerCardinal','LongInt').SetInt( BytesPerCardinal * 8);
 //CL.AddConstantN('BitsPerNativeWord','LongInt').SetInt( BytesPerNativeWord * 8);
 CL.AddDelphiFunction('Function MinI( const A, B : Integer) : Integer');
 CL.AddDelphiFunction('Function MaxI( const A, B : Integer) : Integer');
 CL.AddDelphiFunction('Function MinC( const A, B : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function MaxC( const A, B : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function SumClipI( const A, I : Integer) : Integer');
 CL.AddDelphiFunction('Function SumClipC( const A : Cardinal; const I : Integer) : Cardinal');
 CL.AddDelphiFunction('Function InByteRange( const A : Int64) : Boolean');
 CL.AddDelphiFunction('Function InWordRange( const A : Int64) : Boolean');
 CL.AddDelphiFunction('Function InLongWordRange( const A : Int64) : Boolean');
 CL.AddDelphiFunction('Function InShortIntRange( const A : Int64) : Boolean');
 CL.AddDelphiFunction('Function InSmallIntRange( const A : Int64) : Boolean');
 CL.AddDelphiFunction('Function InLongIntRange( const A : Int64) : Boolean');
  CL.AddTypeS('Bool8', 'ByteBool');
  CL.AddTypeS('Bool16', 'WordBool');
  CL.AddTypeS('Bool32', 'LongBool');
  CL.AddTypeS('TCompareResult', '( crLess, crEqual, crGreater, crUndefined )');
  CL.AddTypeS('TCompareResultSet', 'set of TCompareResult');
 CL.AddDelphiFunction('Function ReverseCompareResult( const C : TCompareResult) : TCompareResult');
 CL.AddConstantN('MinSingle','Single').setExtended( 1.5E-45);
 CL.AddConstantN('MaxSingle','Single').setExtended( 3.4E+38);
 CL.AddConstantN('MinDouble','Double').setExtended( 5.0E-324);
 CL.AddConstantN('MaxDouble','Double').setExtended( 1.7E+308);
 //CL.AddConstantN('MinExtended','Extended').setExtended(3.4E-4932);
 //CL.AddConstantN('MaxExtended','Extended').setExtended(1.1E+4932);
 //CL.AddConstantN('MinCurrency','Currency').SetExtended( - 922337203685477.5807);
 //CL.AddConstantN('MaxCurrency','Currency').SetExtended( 922337203685477.5807);
 CL.AddDelphiFunction('Function MinF( const A, B : Float) : Float');
 CL.AddDelphiFunction('Function MaxF( const A, B : Float) : Float');
 CL.AddDelphiFunction('Function ClipF( const Value : Float; const Low, High : Float) : Float');
 CL.AddDelphiFunction('Function InSingleRange( const A : Float) : Boolean');
 CL.AddDelphiFunction('Function InDoubleRange( const A : Float) : Boolean');
 CL.AddDelphiFunction('Function InCurrencyRange( const A : Float) : Boolean;');
 CL.AddDelphiFunction('Function InCurrencyRange1( const A : Int64) : Boolean;');
 CL.AddDelphiFunction('Function FloatExponentBase2( const A : Extended; var Exponent : Integer) : Boolean');
 CL.AddDelphiFunction('Function FloatExponentBase10( const A : Extended; var Exponent : Integer) : Boolean');
 CL.AddDelphiFunction('Function FloatIsInfinity( const A : Extended) : Boolean');
 CL.AddDelphiFunction('Function FloatIsNaN( const A : Extended) : Boolean');
 CL.AddConstantN('SingleCompareDelta','Extended').setExtended( 1.0E-34);
 CL.AddConstantN('DoubleCompareDelta','Extended').setExtended( 1.0E-280);
 CL.AddConstantN('ExtendedCompareDelta','Extended').setExtended( 1.0E-4400);
 CL.AddConstantN('DefaultCompareDelta','Extended').SetExtended( 1.0E-34);
 CL.AddDelphiFunction('Function FloatZero( const A : Float; const CompareDelta : Float) : Boolean');
 CL.AddDelphiFunction('Function FloatOne( const A : Float; const CompareDelta : Float) : Boolean');
 CL.AddDelphiFunction('Function FloatsEqual( const A, B : Float; const CompareDelta : Float) : Boolean');
 CL.AddDelphiFunction('Function FloatsCompare( const A, B : Float; const CompareDelta : Float) : TCompareResult');
 CL.AddConstantN('SingleCompareEpsilon','Extended').setExtended( 1.0E-5);
 CL.AddConstantN('DoubleCompareEpsilon','Extended').setExtended( 1.0E-13);
 CL.AddConstantN('ExtendedCompareEpsilon','Extended').setExtended( 1.0E-17);
 CL.AddConstantN('DefaultCompareEpsilon','Extended').setExtended( 1.0E-10);
 CL.AddDelphiFunction('Function ApproxEqual( const A, B : Extended; const CompareEpsilon : Double) : Boolean');
 CL.AddDelphiFunction('Function ApproxCompare( const A, B : Extended; const CompareEpsilon : Double) : TCompareResult');
 CL.AddDelphiFunction('Function cClearBit( const Value, BitIndex : LongWord) : LongWord');
 CL.AddDelphiFunction('Function cSetBit( const Value, BitIndex : LongWord) : LongWord');
 CL.AddDelphiFunction('Function cIsBitSet( const Value, BitIndex : LongWord) : Boolean');
 CL.AddDelphiFunction('Function cToggleBit( const Value, BitIndex : LongWord) : LongWord');
 CL.AddDelphiFunction('Function cIsHighBitSet( const Value : LongWord) : Boolean');
 CL.AddDelphiFunction('Function SetBitScanForward( const Value : LongWord) : Integer;');
 CL.AddDelphiFunction('Function SetBitScanForward1( const Value, BitIndex : LongWord) : Integer;');
 CL.AddDelphiFunction('Function SetBitScanReverse( const Value : LongWord) : Integer;');
 CL.AddDelphiFunction('Function SetBitScanReverse1( const Value, BitIndex : LongWord) : Integer;');
 CL.AddDelphiFunction('Function ClearBitScanForward( const Value : LongWord) : Integer;');
 CL.AddDelphiFunction('Function ClearBitScanForward1( const Value, BitIndex : LongWord) : Integer;');
 CL.AddDelphiFunction('Function ClearBitScanReverse( const Value : LongWord) : Integer;');
 CL.AddDelphiFunction('Function ClearBitScanReverse1( const Value, BitIndex : LongWord) : Integer;');
 CL.AddDelphiFunction('Function cReverseBits( const Value : LongWord) : LongWord;');
 CL.AddDelphiFunction('Function cReverseBits1( const Value : LongWord; const BitCount : Integer) : LongWord;');
 CL.AddDelphiFunction('Function cSwapEndian( const Value : LongWord) : LongWord');
 CL.AddDelphiFunction('Function cTwosComplement( const Value : LongWord) : LongWord');
 CL.AddDelphiFunction('Function RotateLeftBits16( const Value : Word; const Bits : Byte) : Word');
 CL.AddDelphiFunction('Function RotateLeftBits32( const Value : LongWord; const Bits : Byte) : LongWord');
 CL.AddDelphiFunction('Function RotateRightBits16( const Value : Word; const Bits : Byte) : Word');
 CL.AddDelphiFunction('Function RotateRightBits32( const Value : LongWord; const Bits : Byte) : LongWord');
 CL.AddDelphiFunction('Function cBitCount( const Value : LongWord) : LongWord');
 CL.AddDelphiFunction('Function cIsPowerOfTwo( const Value : LongWord) : Boolean');
 CL.AddDelphiFunction('Function LowBitMask( const HighBitIndex : LongWord) : LongWord');
 CL.AddDelphiFunction('Function HighBitMask( const LowBitIndex : LongWord) : LongWord');
 CL.AddDelphiFunction('Function RangeBitMask( const LowBitIndex, HighBitIndex : LongWord) : LongWord');
 CL.AddDelphiFunction('Function SetBitRange( const Value : LongWord; const LowBitIndex, HighBitIndex : LongWord) : LongWord');
 CL.AddDelphiFunction('Function ClearBitRange( const Value : LongWord; const LowBitIndex, HighBitIndex : LongWord) : LongWord');
 CL.AddDelphiFunction('Function ToggleBitRange( const Value : LongWord; const LowBitIndex, HighBitIndex : LongWord) : LongWord');
 CL.AddDelphiFunction('Function IsBitRangeSet( const Value : LongWord; const LowBitIndex, HighBitIndex : LongWord) : Boolean');
 CL.AddDelphiFunction('Function IsBitRangeClear( const Value : LongWord; const LowBitIndex, HighBitIndex : LongWord) : Boolean');
//  CL.AddTypeS('CharSet', 'set of AnsiChar');
  CL.AddTypeS('CharSet', 'set of Char');       //!!!
  CL.AddTypeS('AnsiCharSet', 'TCharSet');
  CL.AddTypeS('ByteSet', 'set of Byte');
  CL.AddTypeS('AnsiChar', 'Char');
  CL.AddDelphiFunction('Function AsCharSet( const C : array of Char) : CharSet');
 CL.AddDelphiFunction('Function AsByteSet( const C : array of Byte) : ByteSet');
 CL.AddDelphiFunction('Procedure ComplementChar( var C : CharSet; const Ch : Char)');
 CL.AddDelphiFunction('Procedure ClearCharSet( var C : CharSet)');
 CL.AddDelphiFunction('Procedure FillCharSet( var C : CharSet)');
 CL.AddDelphiFunction('Procedure ComplementCharSet( var C : CharSet)');
 CL.AddDelphiFunction('Procedure AssignCharSet( var DestSet : CharSet; const SourceSet : CharSet)');
 CL.AddDelphiFunction('Procedure Union( var DestSet : CharSet; const SourceSet : CharSet)');
 CL.AddDelphiFunction('Procedure Difference( var DestSet : CharSet; const SourceSet : CharSet)');
 CL.AddDelphiFunction('Procedure Intersection( var DestSet : CharSet; const SourceSet : CharSet)');
 CL.AddDelphiFunction('Procedure XORCharSet( var DestSet : CharSet; const SourceSet : CharSet)');
 CL.AddDelphiFunction('Function IsSubSet( const A, B : CharSet) : Boolean');
 CL.AddDelphiFunction('Function IsEqualCharSet( const A, B : CharSet) : Boolean');
 CL.AddDelphiFunction('Function IsEmpty( const C : CharSet) : Boolean');
 CL.AddDelphiFunction('Function IsEmptyCharset( const C : CharSet) : Boolean');
 CL.AddDelphiFunction('Function IsComplete( const C : CharSet) : Boolean');
 CL.AddDelphiFunction('Function cCharCount( const C : CharSet) : Integer');
 CL.AddDelphiFunction('Procedure ConvertCaseInsensitive( var C : CharSet)');
 CL.AddDelphiFunction('Function CaseInsensitiveCharSet( const C : CharSet) : CharSet');
 CL.AddDelphiFunction('Function IntRangeLength( const Low, High : Integer) : Int64');
 CL.AddDelphiFunction('Function IntRangeAdjacent( const Low1, High1, Low2, High2 : Integer) : Boolean');
 CL.AddDelphiFunction('Function IntRangeOverlap( const Low1, High1, Low2, High2 : Integer) : Boolean');
 CL.AddDelphiFunction('Function IntRangeHasElement( const Low, High, Element : Integer) : Boolean');
 CL.AddDelphiFunction('Function IntRangeIncludeElement( var Low, High : Integer; const Element : Integer) : Boolean');
 CL.AddDelphiFunction('Function IntRangeIncludeElementRange( var Low, High : Integer; const LowElement, HighElement : Integer) : Boolean');
 CL.AddDelphiFunction('Function CardRangeLength( const Low, High : Cardinal) : Int64');
 CL.AddDelphiFunction('Function CardRangeAdjacent( const Low1, High1, Low2, High2 : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function CardRangeOverlap( const Low1, High1, Low2, High2 : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function CardRangeHasElement( const Low, High, Element : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function CardRangeIncludeElement( var Low, High : Cardinal; const Element : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function CardRangeIncludeElementRange( var Low, High : Cardinal; const LowElement, HighElement : Cardinal) : Boolean');
  CL.AddTypeS('UnicodeChar', 'WideChar');
 CL.AddDelphiFunction('Function Compare( const I1, I2 : Boolean) : TCompareResult;');
 CL.AddDelphiFunction('Function Compare1( const I1, I2 : Integer) : TCompareResult;');
 CL.AddDelphiFunction('Function Compare2( const I1, I2 : Int64) : TCompareResult;');
 CL.AddDelphiFunction('Function Compare3( const I1, I2 : Extended) : TCompareResult;');
 CL.AddDelphiFunction('Function CompareA( const I1, I2 : AnsiString) : TCompareResult');
 CL.AddDelphiFunction('Function CompareW( const I1, I2 : WideString) : TCompareResult');
 CL.AddDelphiFunction('Function cSgn( const A : LongInt) : Integer;');
 CL.AddDelphiFunction('Function cSgn1( const A : Int64) : Integer;');
 CL.AddDelphiFunction('Function cSgn2( const A : Extended) : Integer;');
  CL.AddTypeS('TConvertResult', '( convertOK, convertFormatError, convertOverflow )');
 CL.AddDelphiFunction('Function AnsiCharToInt( const A : AnsiChar) : Integer');
 CL.AddDelphiFunction('Function WideCharToInt( const A : WideChar) : Integer');
 CL.AddDelphiFunction('Function CharToInt( const A : Char) : Integer');
 CL.AddDelphiFunction('Function IntToAnsiChar( const A : Integer) : AnsiChar');
 CL.AddDelphiFunction('Function IntToWideChar( const A : Integer) : WideChar');
 CL.AddDelphiFunction('Function IntToChar( const A : Integer) : Char');
 CL.AddDelphiFunction('Function IsHexAnsiChar( const Ch : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function IsHexWideChar( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function IsHexChar( const Ch : Char) : Boolean');
 CL.AddDelphiFunction('Function HexAnsiCharToInt( const A : AnsiChar) : Integer');
 CL.AddDelphiFunction('Function HexWideCharToInt( const A : WideChar) : Integer');
 CL.AddDelphiFunction('Function HexCharToInt( const A : Char) : Integer');
 CL.AddDelphiFunction('Function IntToUpperHexAnsiChar( const A : Integer) : AnsiChar');
 CL.AddDelphiFunction('Function IntToUpperHexWideChar( const A : Integer) : WideChar');
 CL.AddDelphiFunction('Function IntToUpperHexChar( const A : Integer) : Char');
 CL.AddDelphiFunction('Function IntToLowerHexAnsiChar( const A : Integer) : AnsiChar');
 CL.AddDelphiFunction('Function IntToLowerHexWideChar( const A : Integer) : WideChar');
 CL.AddDelphiFunction('Function IntToLowerHexChar( const A : Integer) : Char');
 CL.AddDelphiFunction('Function IntToStringA( const A : Int64) : AnsiString');
 CL.AddDelphiFunction('Function IntToStringW( const A : Int64) : WideString');
 CL.AddDelphiFunction('Function IntToString( const A : Int64) : String');
 CL.AddDelphiFunction('Function UIntToStringA( const A : NativeUInt) : AnsiString');
 CL.AddDelphiFunction('Function UIntToStringW( const A : NativeUInt) : WideString');
 CL.AddDelphiFunction('Function UIntToString( const A : NativeUInt) : String');
 CL.AddDelphiFunction('Function LongWordToStrA( const A : LongWord; const Digits : Integer) : AnsiString');
 CL.AddDelphiFunction('Function LongWordToStrW( const A : LongWord; const Digits : Integer) : WideString');
 CL.AddDelphiFunction('Function LongWordToStrU( const A : LongWord; const Digits : Integer) : UnicodeString');
 CL.AddDelphiFunction('Function LongWordToStr( const A : LongWord; const Digits : Integer) : String');
 CL.AddDelphiFunction('Function LongWordToHexA( const A : LongWord; const Digits : Integer; const UpperCase : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function LongWordToHexW( const A : LongWord; const Digits : Integer; const UpperCase : Boolean) : WideString');
 CL.AddDelphiFunction('Function LongWordToHex( const A : LongWord; const Digits : Integer; const UpperCase : Boolean) : String');
 CL.AddDelphiFunction('Function LongWordToOctA( const A : LongWord; const Digits : Integer) : AnsiString');
 CL.AddDelphiFunction('Function LongWordToOctW( const A : LongWord; const Digits : Integer) : WideString');
 CL.AddDelphiFunction('Function LongWordToOct( const A : LongWord; const Digits : Integer) : String');
 CL.AddDelphiFunction('Function LongWordToBinA( const A : LongWord; const Digits : Integer) : AnsiString');
 CL.AddDelphiFunction('Function LongWordToBinW( const A : LongWord; const Digits : Integer) : WideString');
 CL.AddDelphiFunction('Function LongWordToBin( const A : LongWord; const Digits : Integer) : String');
 CL.AddDelphiFunction('Function TryStringToInt64A( const S : AnsiString; out A : Int64) : Boolean');
 CL.AddDelphiFunction('Function TryStringToInt64W( const S : WideString; out A : Int64) : Boolean');
 CL.AddDelphiFunction('Function TryStringToInt64( const S : String; out A : Int64) : Boolean');
 CL.AddDelphiFunction('Function StringToInt64DefA( const S : AnsiString; const Default : Int64) : Int64');
 CL.AddDelphiFunction('Function StringToInt64DefW( const S : WideString; const Default : Int64) : Int64');
 CL.AddDelphiFunction('Function StringToInt64Def( const S : String; const Default : Int64) : Int64');
 CL.AddDelphiFunction('Function StringToInt64A( const S : AnsiString) : Int64');
 CL.AddDelphiFunction('Function StringToInt64W( const S : WideString) : Int64');
 CL.AddDelphiFunction('Function StringToInt64( const S : String) : Int64');
 CL.AddDelphiFunction('Function TryStringToIntA( const S : AnsiString; out A : Integer) : Boolean');
 CL.AddDelphiFunction('Function TryStringToIntW( const S : WideString; out A : Integer) : Boolean');
 CL.AddDelphiFunction('Function TryStringToInt( const S : String; out A : Integer) : Boolean');
 CL.AddDelphiFunction('Function StringToIntDefA( const S : AnsiString; const Default : Integer) : Integer');
 CL.AddDelphiFunction('Function StringToIntDefW( const S : WideString; const Default : Integer) : Integer');
 CL.AddDelphiFunction('Function StringToIntDef( const S : String; const Default : Integer) : Integer');
 CL.AddDelphiFunction('Function StringToIntA( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function StringToIntW( const S : WideString) : Integer');
 CL.AddDelphiFunction('Function StringToInt( const S : String) : Integer');
 CL.AddDelphiFunction('Function TryStringToLongWordA( const S : AnsiString; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function TryStringToLongWordW( const S : WideString; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function TryStringToLongWord( const S : String; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function StringToLongWordA( const S : AnsiString) : LongWord');
 CL.AddDelphiFunction('Function StringToLongWordW( const S : WideString) : LongWord');
 CL.AddDelphiFunction('Function StringToLongWord( const S : String) : LongWord');
 CL.AddDelphiFunction('Function HexToUIntA( const S : AnsiString) : NativeUInt');
 CL.AddDelphiFunction('Function HexToUIntW( const S : WideString) : NativeUInt');
 CL.AddDelphiFunction('Function HexToUInt( const S : String) : NativeUInt');
 CL.AddDelphiFunction('Function TryHexToLongWordA( const S : AnsiString; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function TryHexToLongWordW( const S : WideString; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function TryHexToLongWord( const S : String; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function HexToLongWordA( const S : AnsiString) : LongWord');
 CL.AddDelphiFunction('Function HexToLongWordW( const S : WideString) : LongWord');
 CL.AddDelphiFunction('Function HexToLongWord( const S : String) : LongWord');
 CL.AddDelphiFunction('Function TryOctToLongWordA( const S : AnsiString; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function TryOctToLongWordW( const S : WideString; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function TryOctToLongWord( const S : String; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function OctToLongWordA( const S : AnsiString) : LongWord');
 CL.AddDelphiFunction('Function OctToLongWordW( const S : WideString) : LongWord');
 CL.AddDelphiFunction('Function OctToLongWord( const S : String) : LongWord');
 CL.AddDelphiFunction('Function TryBinToLongWordA( const S : AnsiString; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function TryBinToLongWordW( const S : WideString; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function TryBinToLongWord( const S : String; out A : LongWord) : Boolean');
 CL.AddDelphiFunction('Function BinToLongWordA( const S : AnsiString) : LongWord');
 CL.AddDelphiFunction('Function BinToLongWordW( const S : WideString) : LongWord');
 CL.AddDelphiFunction('Function BinToLongWord( const S : String) : LongWord');
 CL.AddDelphiFunction('Function FloatToStringA( const A : Extended) : AnsiString');
 CL.AddDelphiFunction('Function FloatToStringW( const A : Extended) : WideString');
 CL.AddDelphiFunction('Function FloatToString( const A : Extended) : String');
 CL.AddDelphiFunction('Function TryStringToFloatA( const A : AnsiString; out B : Extended) : Boolean');
 CL.AddDelphiFunction('Function TryStringToFloatW( const A : WideString; out B : Extended) : Boolean');
 CL.AddDelphiFunction('Function TryStringToFloat( const A : String; out B : Extended) : Boolean');
 CL.AddDelphiFunction('Function StringToFloatA( const A : AnsiString) : Extended');
 CL.AddDelphiFunction('Function StringToFloatW( const A : WideString) : Extended');
 CL.AddDelphiFunction('Function StringToFloat( const A : String) : Extended');
 CL.AddDelphiFunction('Function StringToFloatDefA( const A : AnsiString; const Default : Extended) : Extended');
 CL.AddDelphiFunction('Function StringToFloatDefW( const A : WideString; const Default : Extended) : Extended');
 CL.AddDelphiFunction('Function StringToFloatDef( const A : String; const Default : Extended) : Extended');
 CL.AddDelphiFunction('Function EncodeBase64( const S, Alphabet : AnsiString; const Pad : Boolean; const PadMultiple : Integer; const PadChar : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function DecodeBase64( const S, Alphabet : AnsiString; const PadSet : CharSet) : AnsiString');
 CL.AddConstantN('b64_MIMEBase64','String').SetString('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/');
 CL.AddConstantN('b64_UUEncode','String').SetString(' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_');
 CL.AddConstantN('b64_XXEncode','String').SetString('+-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz');
 //CL.AddConstantN('CCHARSET','String').SetString( '+-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz');
 CL.AddConstantN('CCHARSET','String').SetString(b64_XXEncode);
 CL.AddConstantN('ACHARSET','String').SetString(b64_XXEncode);
 CL.AddConstantN('CHEXSET','String').SetString('0123456789ABCDEF');
 CL.AddConstantN('HEXDIGITS','String').SetString('0123456789ABCDEF');
//StHexDigits  : array[0..$F] of Char = '0123456789ABCDEF';
 //CL.AddConstantN('CHEXSET','String').SetString('0123456789ABCDEF');
 //CL.add  AddVariable('digiset',set);
 CL.AddConstantN('DIGISET','String').SetString('0123456789');
 CL.AddConstantN('LETTERSET','String').SetString('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
 CL.AddConstantN('DIGISET2','TCharset').SetSet('0123456789');
 CL.AddConstantN('LETTERSET2','TCharset').SetSet('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
 CL.AddConstantN('HEXSET2','TCharset').SetSET('0123456789ABCDEF');
 CL.AddConstantN('NUMBERSET','TCharset').SetSet('0123456789');
 CL.AddConstantN('NUMBERS','String').SetString('0123456789');
 CL.AddConstantN('LETTERS','String').SetString('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
 CL.AddConstantN('NUMBLETTS','String').SetString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
 CL.AddConstantN('NUMBLETTSET','TCharset').SetSet('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
 //CL.AddConstantN('XXEncodeSet','Set').SetSet(b64_XXEncode);
 CL.AddDelphiFunction('Function MIMEBase64Decode( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function MIMEBase64Encode( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function UUDecode( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function XXDecode( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function BytesToHex( const P : array of Byte; const UpperCase : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function InterfaceToStrA( const I : IInterface) : AnsiString');
 CL.AddDelphiFunction('Function InterfaceToStrW( const I : IInterface) : WideString');
 CL.AddDelphiFunction('Function InterfaceToStr( const I : IInterface) : String');
 CL.AddDelphiFunction('Function InterfaceToString( const I : IInterface) : String');
 CL.AddDelphiFunction('Function ObjectClassName( const O : TObject) : String');
 CL.AddDelphiFunction('Function ClassClassName( const C : TClass) : String');
 CL.AddDelphiFunction('Function ObjectToStr( const O : TObject) : String');
 CL.AddDelphiFunction('Function ObjectToString( const O : TObject) : String');
 CL.AddDelphiFunction('Function ObjToStr( const O : TObject) : String');

 CL.AddDelphiFunction('Function CharSetToStr( const C : CharSet) : AnsiString');
 CL.AddDelphiFunction('Function StrToCharSet( const S : AnsiString) : CharSet');
 CL.AddDelphiFunction('Function StrToChars( const S : AnsiString) : CharSet');

 CL.AddDelphiFunction('function  SysCharSetToStr(const C: TSysCharSet): AnsiString;');
 CL.AddDelphiFunction('function  StrToSysCharSet(const S: AnsiString): TSysCharSet;');

 //Type TSysCharSet = set of Char;

 CL.AddDelphiFunction('Function HashStrA( const S : AnsiString; const Index : Integer; const Count : Integer; const AsciiCaseSensitive : Boolean; const Slots : LongWord) : LongWord');
 CL.AddDelphiFunction('Function HashStrW( const S : WideString; const Index : Integer; const Count : Integer; const AsciiCaseSensitive : Boolean; const Slots : LongWord) : LongWord');
 CL.AddDelphiFunction('Function HashStr( const S : String; const Index : Integer; const Count : Integer; const AsciiCaseSensitive : Boolean; const Slots : LongWord) : LongWord');
 CL.AddDelphiFunction('Function HashInteger( const I : Integer; const Slots : LongWord) : LongWord');
 CL.AddDelphiFunction('Function HashLongWord( const I : LongWord; const Slots : LongWord) : LongWord');
 CL.AddConstantN('Bytes1KB','LongInt').SetInt(1024);
  SIRegister_IInterface(CL);
 CL.AddDelphiFunction('Procedure SelfTestCFundamentUtils');
 CL.AddDelphiFunction('procedure Include(var aset:charset; achar:char)');
CL.AddDelphiFunction('procedure Exclude(var aset:charset; achar:char)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function cSgn2_P( const A : Extended) : Integer;
Begin Result := cFundamentUtils.Sgn(A); END;

(*----------------------------------------------------------------------------*)
Function cSgn1_P( const A : Int64) : Integer;
Begin Result := cFundamentUtils.Sgn(A); END;

(*----------------------------------------------------------------------------*)
Function cSgn_P( const A : LongInt) : Integer;
Begin Result := cFundamentUtils.Sgn(A); END;

(*----------------------------------------------------------------------------*)
Function Compare3_P( const I1, I2 : Extended) : TCompareResult;
Begin Result := cFundamentUtils.Compare(I1, I2); END;

(*----------------------------------------------------------------------------*)
Function Compare2_P( const I1, I2 : Int64) : TCompareResult;
Begin Result := cFundamentUtils.Compare(I1, I2); END;

(*----------------------------------------------------------------------------*)
Function Compare1_P( const I1, I2 : Integer) : TCompareResult;
Begin Result := cFundamentUtils.Compare(I1, I2); END;

(*----------------------------------------------------------------------------*)
Function Compare_P( const I1, I2 : Boolean) : TCompareResult;
Begin Result := cFundamentUtils.Compare(I1, I2); END;

(*----------------------------------------------------------------------------*)
Function cReverseBits1_P( const Value : LongWord; const BitCount : Integer) : LongWord;
Begin Result := cFundamentUtils.ReverseBits(Value, BitCount); END;

(*----------------------------------------------------------------------------*)
Function cReverseBits_P( const Value : LongWord) : LongWord;
Begin Result := cFundamentUtils.ReverseBits(Value); END;

(*----------------------------------------------------------------------------*)
Function ClearBitScanReverse1_P( const Value, BitIndex : LongWord) : Integer;
Begin Result := cFundamentUtils.ClearBitScanReverse(Value, BitIndex); END;

(*----------------------------------------------------------------------------*)
Function ClearBitScanReverse_P( const Value : LongWord) : Integer;
Begin Result := cFundamentUtils.ClearBitScanReverse(Value); END;

(*----------------------------------------------------------------------------*)
Function ClearBitScanForward1_P( const Value, BitIndex : LongWord) : Integer;
Begin Result := cFundamentUtils.ClearBitScanForward(Value, BitIndex); END;

(*----------------------------------------------------------------------------*)
Function ClearBitScanForward_P( const Value : LongWord) : Integer;
Begin Result := cFundamentUtils.ClearBitScanForward(Value); END;

(*----------------------------------------------------------------------------*)
Function SetBitScanReverse1_P( const Value, BitIndex : LongWord) : Integer;
Begin Result := cFundamentUtils.SetBitScanReverse(Value, BitIndex); END;

(*----------------------------------------------------------------------------*)
Function SetBitScanReverse_P( const Value : LongWord) : Integer;
Begin Result := cFundamentUtils.SetBitScanReverse(Value); END;

(*----------------------------------------------------------------------------*)
Function SetBitScanForward1_P( const Value, BitIndex : LongWord) : Integer;
Begin Result := cFundamentUtils.SetBitScanForward(Value, BitIndex); END;

(*----------------------------------------------------------------------------*)
Function SetBitScanForward_P( const Value : LongWord) : Integer;
Begin Result := cFundamentUtils.SetBitScanForward(Value); END;

(*----------------------------------------------------------------------------*)
Function InCurrencyRange1_P( const A : Int64) : Boolean;
Begin Result := cFundamentUtils.InCurrencyRange(A); END;

(*----------------------------------------------------------------------------*)
Function InCurrencyRange_P( const A : Float) : Boolean;
Begin Result := cFundamentUtils.InCurrencyRange(A); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cFundamentUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MinI, 'MinI', cdRegister);
 S.RegisterDelphiFunction(@MaxI, 'MaxI', cdRegister);
 S.RegisterDelphiFunction(@MinC, 'MinC', cdRegister);
 S.RegisterDelphiFunction(@MaxC, 'MaxC', cdRegister);
 S.RegisterDelphiFunction(@SumClipI, 'SumClipI', cdRegister);
 S.RegisterDelphiFunction(@SumClipC, 'SumClipC', cdRegister);
 S.RegisterDelphiFunction(@InByteRange, 'InByteRange', cdRegister);
 S.RegisterDelphiFunction(@InWordRange, 'InWordRange', cdRegister);
 S.RegisterDelphiFunction(@InLongWordRange, 'InLongWordRange', cdRegister);
 S.RegisterDelphiFunction(@InShortIntRange, 'InShortIntRange', cdRegister);
 S.RegisterDelphiFunction(@InSmallIntRange, 'InSmallIntRange', cdRegister);
 S.RegisterDelphiFunction(@InLongIntRange, 'InLongIntRange', cdRegister);
 S.RegisterDelphiFunction(@ReverseCompareResult, 'ReverseCompareResult', cdRegister);
 S.RegisterDelphiFunction(@MinF, 'MinF', cdRegister);
 S.RegisterDelphiFunction(@MaxF, 'MaxF', cdRegister);
 S.RegisterDelphiFunction(@ClipF, 'ClipF', cdRegister);
 S.RegisterDelphiFunction(@InSingleRange, 'InSingleRange', cdRegister);
 S.RegisterDelphiFunction(@InDoubleRange, 'InDoubleRange', cdRegister);
 S.RegisterDelphiFunction(@InCurrencyRange, 'InCurrencyRange', cdRegister);
 S.RegisterDelphiFunction(@InCurrencyRange1_P, 'InCurrencyRange1', cdRegister);
 S.RegisterDelphiFunction(@FloatExponentBase2, 'FloatExponentBase2', cdRegister);
 S.RegisterDelphiFunction(@FloatExponentBase10, 'FloatExponentBase10', cdRegister);
 S.RegisterDelphiFunction(@FloatIsInfinity, 'FloatIsInfinity', cdRegister);
 S.RegisterDelphiFunction(@FloatIsNaN, 'FloatIsNaN', cdRegister);
 S.RegisterDelphiFunction(@FloatZero, 'FloatZero', cdRegister);
 S.RegisterDelphiFunction(@FloatOne, 'FloatOne', cdRegister);
 S.RegisterDelphiFunction(@FloatsEqual, 'FloatsEqual', cdRegister);
 S.RegisterDelphiFunction(@FloatsCompare, 'FloatsCompare', cdRegister);
 S.RegisterDelphiFunction(@ApproxEqual, 'ApproxEqual', cdRegister);
 S.RegisterDelphiFunction(@ApproxCompare, 'ApproxCompare', cdRegister);
 S.RegisterDelphiFunction(@ClearBit, 'cClearBit', cdRegister);
 S.RegisterDelphiFunction(@SetBit, 'cSetBit', cdRegister);
 S.RegisterDelphiFunction(@IsBitSet, 'cIsBitSet', cdRegister);
 S.RegisterDelphiFunction(@ToggleBit, 'cToggleBit', cdRegister);
 S.RegisterDelphiFunction(@IsHighBitSet, 'cIsHighBitSet', cdRegister);
 S.RegisterDelphiFunction(@SetBitScanForward_P, 'SetBitScanForward', cdRegister);
 S.RegisterDelphiFunction(@SetBitScanForward1_P, 'SetBitScanForward1', cdRegister);
 S.RegisterDelphiFunction(@SetBitScanReverse_P, 'SetBitScanReverse', cdRegister);
 S.RegisterDelphiFunction(@SetBitScanReverse1_P, 'SetBitScanReverse1', cdRegister);
 S.RegisterDelphiFunction(@ClearBitScanForward_P, 'ClearBitScanForward', cdRegister);
 S.RegisterDelphiFunction(@ClearBitScanForward1_P, 'ClearBitScanForward1', cdRegister);
 S.RegisterDelphiFunction(@ClearBitScanReverse_P, 'ClearBitScanReverse', cdRegister);
 S.RegisterDelphiFunction(@ClearBitScanReverse1_P, 'ClearBitScanReverse1', cdRegister);
 S.RegisterDelphiFunction(@cReverseBits_P, 'cReverseBits', cdRegister);
 S.RegisterDelphiFunction(@cReverseBits1_P, 'cReverseBits1', cdRegister);
 S.RegisterDelphiFunction(@SwapEndian, 'cSwapEndian', cdRegister);
 S.RegisterDelphiFunction(@TwosComplement, 'cTwosComplement', cdRegister);
 S.RegisterDelphiFunction(@RotateLeftBits16, 'RotateLeftBits16', cdRegister);
 S.RegisterDelphiFunction(@RotateLeftBits32, 'RotateLeftBits32', cdRegister);
 S.RegisterDelphiFunction(@RotateRightBits16, 'RotateRightBits16', cdRegister);
 S.RegisterDelphiFunction(@RotateRightBits32, 'RotateRightBits32', cdRegister);
 S.RegisterDelphiFunction(@BitCount, 'cBitCount', cdRegister);
 S.RegisterDelphiFunction(@IsPowerOfTwo, 'cIsPowerOfTwo', cdRegister);
 S.RegisterDelphiFunction(@LowBitMask, 'LowBitMask', cdRegister);
 S.RegisterDelphiFunction(@HighBitMask, 'HighBitMask', cdRegister);
 S.RegisterDelphiFunction(@RangeBitMask, 'RangeBitMask', cdRegister);
 S.RegisterDelphiFunction(@SetBitRange, 'SetBitRange', cdRegister);
 S.RegisterDelphiFunction(@ClearBitRange, 'ClearBitRange', cdRegister);
 S.RegisterDelphiFunction(@ToggleBitRange, 'ToggleBitRange', cdRegister);
 S.RegisterDelphiFunction(@IsBitRangeSet, 'IsBitRangeSet', cdRegister);
 S.RegisterDelphiFunction(@IsBitRangeClear, 'IsBitRangeClear', cdRegister);
 S.RegisterDelphiFunction(@AsCharSet, 'AsCharSet', cdRegister);
 S.RegisterDelphiFunction(@AsByteSet, 'AsByteSet', cdRegister);
 S.RegisterDelphiFunction(@ComplementChar, 'ComplementChar', cdRegister);
 S.RegisterDelphiFunction(@ClearCharSet, 'ClearCharSet', cdRegister);
 S.RegisterDelphiFunction(@FillCharSet, 'FillCharSet', cdRegister);
 S.RegisterDelphiFunction(@ComplementCharSet, 'ComplementCharSet', cdRegister);
 S.RegisterDelphiFunction(@AssignCharSet, 'AssignCharSet', cdRegister);
 S.RegisterDelphiFunction(@Union, 'Union', cdRegister);
 S.RegisterDelphiFunction(@Difference, 'Difference', cdRegister);
 S.RegisterDelphiFunction(@Intersection, 'Intersection', cdRegister);
 S.RegisterDelphiFunction(@XORCharSet, 'XORCharSet', cdRegister);
 S.RegisterDelphiFunction(@IsSubSet, 'IsSubSet', cdRegister);
 S.RegisterDelphiFunction(@IsEqual, 'IsEqualCharset', cdRegister);
 S.RegisterDelphiFunction(@IsEmpty, 'IsEmpty', cdRegister);
 S.RegisterDelphiFunction(@IsEmpty, 'IsEmptyCharset', cdRegister);

 S.RegisterDelphiFunction(@IsComplete, 'IsComplete', cdRegister);
 S.RegisterDelphiFunction(@CharCount, 'cCharCount', cdRegister);
 S.RegisterDelphiFunction(@ConvertCaseInsensitive, 'ConvertCaseInsensitive', cdRegister);
 S.RegisterDelphiFunction(@CaseInsensitiveCharSet, 'CaseInsensitiveCharSet', cdRegister);
 S.RegisterDelphiFunction(@IntRangeLength, 'IntRangeLength', cdRegister);
 S.RegisterDelphiFunction(@IntRangeAdjacent, 'IntRangeAdjacent', cdRegister);
 S.RegisterDelphiFunction(@IntRangeOverlap, 'IntRangeOverlap', cdRegister);
 S.RegisterDelphiFunction(@IntRangeHasElement, 'IntRangeHasElement', cdRegister);
 S.RegisterDelphiFunction(@IntRangeIncludeElement, 'IntRangeIncludeElement', cdRegister);
 S.RegisterDelphiFunction(@IntRangeIncludeElementRange, 'IntRangeIncludeElementRange', cdRegister);
 S.RegisterDelphiFunction(@CardRangeLength, 'CardRangeLength', cdRegister);
 S.RegisterDelphiFunction(@CardRangeAdjacent, 'CardRangeAdjacent', cdRegister);
 S.RegisterDelphiFunction(@CardRangeOverlap, 'CardRangeOverlap', cdRegister);
 S.RegisterDelphiFunction(@CardRangeHasElement, 'CardRangeHasElement', cdRegister);
 S.RegisterDelphiFunction(@CardRangeIncludeElement, 'CardRangeIncludeElement', cdRegister);
 S.RegisterDelphiFunction(@CardRangeIncludeElementRange, 'CardRangeIncludeElementRange', cdRegister);
 S.RegisterDelphiFunction(@Compare_P, 'Compare', cdRegister);
 S.RegisterDelphiFunction(@Compare1_P, 'Compare1', cdRegister);
 S.RegisterDelphiFunction(@Compare2_P, 'Compare2', cdRegister);
 S.RegisterDelphiFunction(@Compare3_P, 'Compare3', cdRegister);
 S.RegisterDelphiFunction(@CompareA, 'CompareA', cdRegister);
 S.RegisterDelphiFunction(@CompareW, 'CompareW', cdRegister);
 S.RegisterDelphiFunction(@cSgn_P, 'cSgn', cdRegister);
 S.RegisterDelphiFunction(@cSgn1_P, 'cSgn1', cdRegister);
 S.RegisterDelphiFunction(@cSgn2_P, 'cSgn2', cdRegister);
 S.RegisterDelphiFunction(@AnsiCharToInt, 'AnsiCharToInt', cdRegister);
 S.RegisterDelphiFunction(@WideCharToInt, 'WideCharToInt', cdRegister);
 S.RegisterDelphiFunction(@CharToInt, 'CharToInt', cdRegister);
 S.RegisterDelphiFunction(@IntToAnsiChar, 'IntToAnsiChar', cdRegister);
 S.RegisterDelphiFunction(@IntToWideChar, 'IntToWideChar', cdRegister);
 S.RegisterDelphiFunction(@IntToChar, 'IntToChar', cdRegister);
 S.RegisterDelphiFunction(@IsHexAnsiChar, 'IsHexAnsiChar', cdRegister);
 S.RegisterDelphiFunction(@IsHexWideChar, 'IsHexWideChar', cdRegister);
 S.RegisterDelphiFunction(@IsHexChar, 'IsHexChar', cdRegister);
 S.RegisterDelphiFunction(@HexAnsiCharToInt, 'HexAnsiCharToInt', cdRegister);
 S.RegisterDelphiFunction(@HexWideCharToInt, 'HexWideCharToInt', cdRegister);
 S.RegisterDelphiFunction(@HexCharToInt, 'HexCharToInt', cdRegister);
 S.RegisterDelphiFunction(@IntToUpperHexAnsiChar, 'IntToUpperHexAnsiChar', cdRegister);
 S.RegisterDelphiFunction(@IntToUpperHexWideChar, 'IntToUpperHexWideChar', cdRegister);
 S.RegisterDelphiFunction(@IntToUpperHexChar, 'IntToUpperHexChar', cdRegister);
 S.RegisterDelphiFunction(@IntToLowerHexAnsiChar, 'IntToLowerHexAnsiChar', cdRegister);
 S.RegisterDelphiFunction(@IntToLowerHexWideChar, 'IntToLowerHexWideChar', cdRegister);
 S.RegisterDelphiFunction(@IntToLowerHexChar, 'IntToLowerHexChar', cdRegister);
 S.RegisterDelphiFunction(@IntToStringA, 'IntToStringA', cdRegister);
 S.RegisterDelphiFunction(@IntToStringW, 'IntToStringW', cdRegister);
 S.RegisterDelphiFunction(@IntToString, 'IntToString', cdRegister);
 S.RegisterDelphiFunction(@UIntToStringA, 'UIntToStringA', cdRegister);
 S.RegisterDelphiFunction(@UIntToStringW, 'UIntToStringW', cdRegister);
 S.RegisterDelphiFunction(@UIntToString, 'UIntToString', cdRegister);
 S.RegisterDelphiFunction(@LongWordToStrA, 'LongWordToStrA', cdRegister);
 S.RegisterDelphiFunction(@LongWordToStrW, 'LongWordToStrW', cdRegister);
 S.RegisterDelphiFunction(@LongWordToStrU, 'LongWordToStrU', cdRegister);
 S.RegisterDelphiFunction(@LongWordToStr, 'LongWordToStr', cdRegister);
 S.RegisterDelphiFunction(@LongWordToHexA, 'LongWordToHexA', cdRegister);
 S.RegisterDelphiFunction(@LongWordToHexW, 'LongWordToHexW', cdRegister);
 S.RegisterDelphiFunction(@LongWordToHex, 'LongWordToHex', cdRegister);
 S.RegisterDelphiFunction(@LongWordToOctA, 'LongWordToOctA', cdRegister);
 S.RegisterDelphiFunction(@LongWordToOctW, 'LongWordToOctW', cdRegister);
 S.RegisterDelphiFunction(@LongWordToOct, 'LongWordToOct', cdRegister);
 S.RegisterDelphiFunction(@LongWordToBinA, 'LongWordToBinA', cdRegister);
 S.RegisterDelphiFunction(@LongWordToBinW, 'LongWordToBinW', cdRegister);
 S.RegisterDelphiFunction(@LongWordToBin, 'LongWordToBin', cdRegister);
 S.RegisterDelphiFunction(@TryStringToInt64A, 'TryStringToInt64A', cdRegister);
 S.RegisterDelphiFunction(@TryStringToInt64W, 'TryStringToInt64W', cdRegister);
 S.RegisterDelphiFunction(@TryStringToInt64, 'TryStringToInt64', cdRegister);
 S.RegisterDelphiFunction(@StringToInt64DefA, 'StringToInt64DefA', cdRegister);
 S.RegisterDelphiFunction(@StringToInt64DefW, 'StringToInt64DefW', cdRegister);
 S.RegisterDelphiFunction(@StringToInt64Def, 'StringToInt64Def', cdRegister);
 S.RegisterDelphiFunction(@StringToInt64A, 'StringToInt64A', cdRegister);
 S.RegisterDelphiFunction(@StringToInt64W, 'StringToInt64W', cdRegister);
 S.RegisterDelphiFunction(@StringToInt64, 'StringToInt64', cdRegister);
 S.RegisterDelphiFunction(@TryStringToIntA, 'TryStringToIntA', cdRegister);
 S.RegisterDelphiFunction(@TryStringToIntW, 'TryStringToIntW', cdRegister);
 S.RegisterDelphiFunction(@TryStringToInt, 'TryStringToInt', cdRegister);
 S.RegisterDelphiFunction(@StringToIntDefA, 'StringToIntDefA', cdRegister);
 S.RegisterDelphiFunction(@StringToIntDefW, 'StringToIntDefW', cdRegister);
 S.RegisterDelphiFunction(@StringToIntDef, 'StringToIntDef', cdRegister);
 S.RegisterDelphiFunction(@StringToIntA, 'StringToIntA', cdRegister);
 S.RegisterDelphiFunction(@StringToIntW, 'StringToIntW', cdRegister);
 S.RegisterDelphiFunction(@StringToInt, 'StringToInt', cdRegister);
 S.RegisterDelphiFunction(@TryStringToLongWordA, 'TryStringToLongWordA', cdRegister);
 S.RegisterDelphiFunction(@TryStringToLongWordW, 'TryStringToLongWordW', cdRegister);
 S.RegisterDelphiFunction(@TryStringToLongWord, 'TryStringToLongWord', cdRegister);
 S.RegisterDelphiFunction(@StringToLongWordA, 'StringToLongWordA', cdRegister);
 S.RegisterDelphiFunction(@StringToLongWordW, 'StringToLongWordW', cdRegister);
 S.RegisterDelphiFunction(@StringToLongWord, 'StringToLongWord', cdRegister);
 S.RegisterDelphiFunction(@HexToUIntA, 'HexToUIntA', cdRegister);
 S.RegisterDelphiFunction(@HexToUIntW, 'HexToUIntW', cdRegister);
 S.RegisterDelphiFunction(@HexToUInt, 'HexToUInt', cdRegister);
 S.RegisterDelphiFunction(@TryHexToLongWordA, 'TryHexToLongWordA', cdRegister);
 S.RegisterDelphiFunction(@TryHexToLongWordW, 'TryHexToLongWordW', cdRegister);
 S.RegisterDelphiFunction(@TryHexToLongWord, 'TryHexToLongWord', cdRegister);
 S.RegisterDelphiFunction(@HexToLongWordA, 'HexToLongWordA', cdRegister);
 S.RegisterDelphiFunction(@HexToLongWordW, 'HexToLongWordW', cdRegister);
 S.RegisterDelphiFunction(@HexToLongWord, 'HexToLongWord', cdRegister);
 S.RegisterDelphiFunction(@TryOctToLongWordA, 'TryOctToLongWordA', cdRegister);
 S.RegisterDelphiFunction(@TryOctToLongWordW, 'TryOctToLongWordW', cdRegister);
 S.RegisterDelphiFunction(@TryOctToLongWord, 'TryOctToLongWord', cdRegister);
 S.RegisterDelphiFunction(@OctToLongWordA, 'OctToLongWordA', cdRegister);
 S.RegisterDelphiFunction(@OctToLongWordW, 'OctToLongWordW', cdRegister);
 S.RegisterDelphiFunction(@OctToLongWord, 'OctToLongWord', cdRegister);
 S.RegisterDelphiFunction(@TryBinToLongWordA, 'TryBinToLongWordA', cdRegister);
 S.RegisterDelphiFunction(@TryBinToLongWordW, 'TryBinToLongWordW', cdRegister);
 S.RegisterDelphiFunction(@TryBinToLongWord, 'TryBinToLongWord', cdRegister);
 S.RegisterDelphiFunction(@BinToLongWordA, 'BinToLongWordA', cdRegister);
 S.RegisterDelphiFunction(@BinToLongWordW, 'BinToLongWordW', cdRegister);
 S.RegisterDelphiFunction(@BinToLongWord, 'BinToLongWord', cdRegister);
 S.RegisterDelphiFunction(@FloatToStringA, 'FloatToStringA', cdRegister);
 S.RegisterDelphiFunction(@FloatToStringW, 'FloatToStringW', cdRegister);
 S.RegisterDelphiFunction(@FloatToString, 'FloatToString', cdRegister);
 S.RegisterDelphiFunction(@TryStringToFloatA, 'TryStringToFloatA', cdRegister);
 S.RegisterDelphiFunction(@TryStringToFloatW, 'TryStringToFloatW', cdRegister);
 S.RegisterDelphiFunction(@TryStringToFloat, 'TryStringToFloat', cdRegister);
 S.RegisterDelphiFunction(@StringToFloatA, 'StringToFloatA', cdRegister);
 S.RegisterDelphiFunction(@StringToFloatW, 'StringToFloatW', cdRegister);
 S.RegisterDelphiFunction(@StringToFloat, 'StringToFloat', cdRegister);
 S.RegisterDelphiFunction(@StringToFloatDefA, 'StringToFloatDefA', cdRegister);
 S.RegisterDelphiFunction(@StringToFloatDefW, 'StringToFloatDefW', cdRegister);
 S.RegisterDelphiFunction(@StringToFloatDef, 'StringToFloatDef', cdRegister);
 S.RegisterDelphiFunction(@EncodeBase64, 'EncodeBase64', cdRegister);
 S.RegisterDelphiFunction(@DecodeBase64, 'DecodeBase64', cdRegister);
 S.RegisterDelphiFunction(@MIMEBase64Decode, 'MIMEBase64Decode', cdRegister);
 S.RegisterDelphiFunction(@MIMEBase64Encode, 'MIMEBase64Encode', cdRegister);
 S.RegisterDelphiFunction(@UUDecode, 'UUDecode', cdRegister);
 S.RegisterDelphiFunction(@XXDecode, 'XXDecode', cdRegister);
 S.RegisterDelphiFunction(@BytesToHex, 'BytesToHex', cdRegister);
 S.RegisterDelphiFunction(@InterfaceToStrA, 'InterfaceToStrA', cdRegister);
 S.RegisterDelphiFunction(@InterfaceToStrW, 'InterfaceToStrW', cdRegister);
 S.RegisterDelphiFunction(@InterfaceToStr, 'InterfaceToStr', cdRegister);
 S.RegisterDelphiFunction(@InterfaceToStr, 'InterfaceToString', cdRegister);
 S.RegisterDelphiFunction(@ObjectClassName, 'ObjectClassName', cdRegister);
 S.RegisterDelphiFunction(@ClassClassName, 'ClassClassName', cdRegister);
 S.RegisterDelphiFunction(@ObjectToStr, 'ObjectToStr', cdRegister);
 S.RegisterDelphiFunction(@ObjectToStr, 'ObjToStr', cdRegister);
 S.RegisterDelphiFunction(@SysCharSetToStr, 'SysCharSetToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToSysCharSet, 'StrToSysCharSet', cdRegister);

  //function  SysCharSetToStr(const C: TSysCharSet): AnsiString;
//function  StrToSysCharSet(const S: AnsiString): TSysCharSet;
 
 S.RegisterDelphiFunction(@ObjectToStr, 'ObjectToString', cdRegister);
 S.RegisterDelphiFunction(@CharSetToStr, 'CharSetToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToCharSet, 'StrToCharSet', cdRegister);
 S.RegisterDelphiFunction(@StrToCharSet, 'StrToCharS', cdRegister);
 S.RegisterDelphiFunction(@HashStrA, 'HashStrA', cdRegister);
 S.RegisterDelphiFunction(@HashStrW, 'HashStrW', cdRegister);
 S.RegisterDelphiFunction(@HashStr, 'HashStr', cdRegister);
 S.RegisterDelphiFunction(@HashInteger, 'HashInteger', cdRegister);
 S.RegisterDelphiFunction(@HashLongWord, 'HashLongWord', cdRegister);
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestCFundamentUtils', cdRegister);
  S.RegisterDelphiFunction(@myinclude, 'Include', cdRegister);
 S.RegisterDelphiFunction(@myexclude, 'Exclude', cdRegister);

end;


 
{ TPSImport_cUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cFundamentUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cFundamentUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
