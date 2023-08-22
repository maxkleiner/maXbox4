unit uPSI_cHugeInt;
{
 needs a pointer to solve - we work on it
 integer instead pointer! to func

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
  TPSImport_cHugeInt = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THugeInt(CL: TPSPascalCompiler);
procedure SIRegister_cHugeInt(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_THugeInt(CL: TPSRuntimeClassImporter);
procedure RIRegister_cHugeInt_Routines(S: TPSExec);
//RIRegister_THugeInt(CL);

procedure Register;

implementation


uses
   cHugeInt
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cHugeInt]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THugeInt(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THugeInt') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THugeInt') do begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( const A : Int64);');
    RegisterMethod('Constructor Create2( const A : THugeInt);');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AssignZero');
    RegisterMethod('Procedure AssignOne');
    RegisterMethod('Procedure AssignMinusOne');
    RegisterMethod('Procedure Assign( const A : Int64);');
    RegisterMethod('Procedure Assign2( const A : THugeInt);');
    RegisterMethod('Function IsZero : Boolean');
    RegisterMethod('Function IsNegative : Boolean');
    RegisterMethod('Function IsPositive : Boolean');
    RegisterMethod('Function IsOne : Boolean');
    RegisterMethod('Function IsMinusOne : Boolean');
    RegisterMethod('Function IsOdd : Boolean');
    RegisterMethod('Function IsEven : Boolean');
    RegisterMethod('Function Sign : Integer');
    RegisterMethod('Procedure Negate');
    RegisterMethod('Procedure Abs');
    RegisterMethod('Function ToWord32 : LongWord');
    RegisterMethod('Function ToInt32 : LongInt');
    RegisterMethod('Function ToInt64 : Int64');
    RegisterMethod('Function Equals( const A : LongWord) : Boolean;');
    RegisterMethod('Function Equals1( const A : LongInt) : Boolean;');
    RegisterMethod('Function Equals2( const A : Int64) : Boolean;');
    RegisterMethod('Function Equals3( const A : THugeInt) : Boolean;');
    RegisterMethod('Function Compare( const A : LongWord) : Integer;');
    RegisterMethod('Function Compare1( const A : LongInt) : Integer;');
    RegisterMethod('Function Compare2( const A : Int64) : Integer;');
    RegisterMethod('Function Compare3( const A : THugeInt) : Integer;');
    RegisterMethod('Procedure Add( const A : LongInt);');
    RegisterMethod('Procedure Add2( const A : THugeInt);');
    RegisterMethod('Procedure Inc');
    RegisterMethod('Procedure Subtract( const A : LongInt);');
    RegisterMethod('Procedure Subtract2( const A : THugeInt);');
    RegisterMethod('Procedure Dec');
    RegisterMethod('Procedure Multiply( const A : LongInt);');
    RegisterMethod('Procedure Multiply2( const A : THugeInt);');
    RegisterMethod('Procedure Sqr');
    RegisterMethod('Procedure Divide( const B : LongInt; out R : LongInt);');
    RegisterMethod('Procedure Divide2( const B : THugeInt; var R : THugeInt);');
    RegisterMethod('Procedure Power( const B : LongWord)');
    RegisterMethod('Function ToStr : AnsiString');
    RegisterMethod('Function ToHex : AnsiString');
    RegisterMethod('Procedure AssignStr( const A : AnsiString)');
    RegisterMethod('Procedure AssignHex( const A : AnsiString)');
    RegisterMethod('Procedure ISqrt');
    RegisterMethod('Procedure Random( const Size : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cHugeInt(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('HugeWord', 'record Used : Integer; Alloc : Integer; Data : Integer; end');
  //CL.AddTypeS('PHugeWord', '^HugeWord // will not work');
  CL.AddTypeS('HugeWordElement', 'LongWord');
 // CL.AddTypeS('PHugeWordElement', '^HugeWordElement // will not work');
 CL.AddConstantN('HugeWordElementBits','LongInt').SetInt( HugeWordElementSize * 8);
  CL.AddTypeS('HugeInt', 'record Sign : ShortInt; Value : HugeWord; end');
 // CL.AddTypeS('PHugeInt', '^HugeInt // will not work');
 //type
  //THugeWordCallbackProc = function (const Data: Integer): Boolean;
  CL.AddTypeS('THugeWordCallbackProc', 'function (const Data: Integer): Boolean;');

 CL.AddDelphiFunction('Procedure HugeWordInit( out A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordFinalise( var A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordFinaliseTo( var A, B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordAlloc( var A : HugeWord; const Size : Integer)');
 CL.AddDelphiFunction('Procedure HugeWordAllocZero( var A : HugeWord; const Size : Integer)');
 CL.AddDelphiFunction('Procedure HugeWordFree( var A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordRealloc( var A : HugeWord; const Size : Integer)');
 CL.AddDelphiFunction('Function HugeWordGetSize( const A : HugeWord) : Integer');
 CL.AddDelphiFunction('Procedure HugeWordSetSize( var A : HugeWord; const Size : Integer)');
 CL.AddDelphiFunction('Function HugeWordGetElement( const A : HugeWord; const I : Integer) : LongWord');
 CL.AddDelphiFunction('Procedure HugeWordSetElement( const A : HugeWord; const I : Integer; const B : LongWord)');
 //CL.AddDelphiFunction('Function HugeWordGetFirstElementPtr( const A : HugeWord) : PHugeWordElement');
 //CL.AddDelphiFunction('Function HugeWordGetLastElementPtr( const A : HugeWord) : PHugeWordElement');
 CL.AddDelphiFunction('Procedure HugeWordNormalise( var A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordInitZero( out A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordInitOne( out A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordInitWord32( out A : HugeWord; const B : LongWord)');
 CL.AddDelphiFunction('Procedure HugeWordInitInt32( out A : HugeWord; const B : LongInt)');
 CL.AddDelphiFunction('Procedure HugeWordInitInt64( out A : HugeWord; const B : Int64)');
 CL.AddDelphiFunction('Procedure HugeWordInitHugeWord( out A : HugeWord; const B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordAssignZero( var A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordAssignOne( var A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordAssignWord32( var A : HugeWord; const B : LongWord)');
 CL.AddDelphiFunction('Procedure HugeWordAssignInt32( var A : HugeWord; const B : LongInt)');
 CL.AddDelphiFunction('Procedure HugeWordAssignInt64( var A : HugeWord; const B : Int64)');
 CL.AddDelphiFunction('Procedure HugeWordAssign( var A : HugeWord; const B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordAssignHugeIntAbs( var A : HugeWord; const B : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeWordAssignBuf( var A : HugeWord; const Buf : string; const BufSize : Integer; const ReverseByteOrder : Boolean)');
 CL.AddDelphiFunction('Procedure HugeWordAssignBufStr( var A : HugeWord; const Buf : AnsiString; const ReverseByteOrder : Boolean)');
 CL.AddDelphiFunction('Procedure HugeWordSwap( var A, B : HugeWord)');
 CL.AddDelphiFunction('Function HugeWordIsZero( const A : HugeWord) : Boolean');
 CL.AddDelphiFunction('Function HugeWordIsOne( const A : HugeWord) : Boolean');
 CL.AddDelphiFunction('Function HugeWordIsOdd( const A : HugeWord) : Boolean');
 CL.AddDelphiFunction('Function HugeWordIsEven( const A : HugeWord) : Boolean');
 CL.AddDelphiFunction('Function HugeWordIsWord32Range( const A : HugeWord) : Boolean');
 CL.AddDelphiFunction('Function HugeWordIsWord64Range( const A : HugeWord) : Boolean');
 CL.AddDelphiFunction('Function HugeWordIsWord128Range( const A : HugeWord) : Boolean');
 CL.AddDelphiFunction('Function HugeWordIsInt32Range( const A : HugeWord) : Boolean');
 CL.AddDelphiFunction('Function HugeWordIsInt64Range( const A : HugeWord) : Boolean');
 CL.AddDelphiFunction('Function HugeWordToWord32( const A : HugeWord) : LongWord');
 CL.AddDelphiFunction('Function HugeWordToInt32( const A : HugeWord) : LongInt');
 CL.AddDelphiFunction('Function HugeWordToInt64( const A : HugeWord) : Int64');
 CL.AddDelphiFunction('Function HugeWordEqualsWord32( const A : HugeWord; const B : LongWord) : Boolean');
 CL.AddDelphiFunction('Function HugeWordEqualsInt32( const A : HugeWord; const B : LongInt) : Boolean');
 CL.AddDelphiFunction('Function HugeWordEqualsInt64( const A : HugeWord; const B : Int64) : Boolean');
 CL.AddDelphiFunction('Function HugeWordEquals( const A, B : HugeWord) : Boolean');
 CL.AddDelphiFunction('Function HugeWordCompareWord32( const A : HugeWord; const B : LongWord) : Integer');
 CL.AddDelphiFunction('Function HugeWordCompareInt32( const A : HugeWord; const B : LongInt) : Integer');
 CL.AddDelphiFunction('Function HugeWordCompareInt64( const A : HugeWord; const B : Int64) : Integer');
 CL.AddDelphiFunction('Function HugeWordCompare( const A, B : HugeWord) : Integer');
 CL.AddDelphiFunction('Procedure HugeWordMin( var A : HugeWord; const B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordMax( var A : HugeWord; const B : HugeWord)');
 CL.AddDelphiFunction('Function HugeWordGetBitCount( const A : HugeWord) : Integer');
 CL.AddDelphiFunction('Procedure HugeWordSetBitCount( var A : HugeWord; const Bits : Integer)');
 CL.AddDelphiFunction('Function HugeWordIsBitSet( const A : HugeWord; const B : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure HugeWordSetBit( var A : HugeWord; const B : Integer)');
 CL.AddDelphiFunction('Procedure HugeWordClearBit( var A : HugeWord; const B : Integer)');
 CL.AddDelphiFunction('Procedure HugeWordToggleBit( var A : HugeWord; const B : Integer)');
 CL.AddDelphiFunction('Function HugeWordSetBitScanForward( const A : HugeWord) : Integer');
 CL.AddDelphiFunction('Function HugeWordSetBitScanReverse( const A : HugeWord) : Integer');
 CL.AddDelphiFunction('Function HugeWordClearBitScanForward( const A : HugeWord) : Integer');
 CL.AddDelphiFunction('Function HugeWordClearBitScanReverse( const A : HugeWord) : Integer');
 CL.AddDelphiFunction('Procedure HugeWordShl( var A : HugeWord; const B : Integer)');
 CL.AddDelphiFunction('Procedure HugeWordShl1( var A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordShr( var A : HugeWord; const B : Integer)');
 CL.AddDelphiFunction('Procedure HugeWordShr1( var A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordNot( var A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordOrHugeWord( var A : HugeWord; const B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordAndHugeWord( var A : HugeWord; const B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordXorHugeWord( var A : HugeWord; const B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordAddWord32( var A : HugeWord; const B : LongWord)');
 CL.AddDelphiFunction('Procedure HugeWordAdd( var A : HugeWord; const B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordInc( var A : HugeWord)');
 CL.AddDelphiFunction('Function HugeWordSubtractWord32( var A : HugeWord; const B : LongWord) : Integer');
 CL.AddDelphiFunction('Function HugeWordSubtract( var A : HugeWord; const B : HugeWord) : Integer');
 CL.AddDelphiFunction('Procedure HugeWordDec( var A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordMultiplyWord8( var A : HugeWord; const B : Byte)');
 CL.AddDelphiFunction('Procedure HugeWordMultiplyWord16( var A : HugeWord; const B : Word)');
 CL.AddDelphiFunction('Procedure HugeWordMultiplyWord32( var A : HugeWord; const B : LongWord)');
 CL.AddDelphiFunction('Procedure HugeWordMultiply_Long_NN( var Res : HugeWord; const A, B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordMultiply_Long_NN_Unsafe( var Res : HugeWord; const A, B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordMultiply_Long( var Res : HugeWord; const A, B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordMultiply_ShiftAdd( var Res : HugeWord; const A, B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordMultiply( var Res : HugeWord; const A, B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordSqr( var Res : HugeWord; const A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordDivideWord32( const A : HugeWord; const B : LongWord; var Q : HugeWord; out R : LongWord)');
 CL.AddDelphiFunction('Procedure HugeWordDivide_RR( const A, B : HugeWord; var Q, R : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordDivide_RR_Unsafe( const A, B : HugeWord; var Q, R : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordDivide( const A, B : HugeWord; var Q, R : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordMod( const A, B : HugeWord; var R : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordGCD( const A, B : HugeWord; var R : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordPower( var A : HugeWord; const B : LongWord)');
 CL.AddDelphiFunction('Procedure HugeWordPowerAndMod( var Res : HugeWord; const A, E, M : HugeWord)');
 CL.AddDelphiFunction('Function HugeWordToStr( const A : HugeWord) : AnsiString');
 CL.AddDelphiFunction('Procedure StrToHugeWord( const A : AnsiString; var R : HugeWord)');
 CL.AddDelphiFunction('Function HugeWordToHex( const A : HugeWord) : AnsiString');
 CL.AddDelphiFunction('Procedure HexToHugeWord( const A : AnsiString; var R : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordISqrt( var A : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeWordExtendedEuclid( const A, B : HugeWord; var R : HugeWord; var X, Y : HugeInt)');
 CL.AddDelphiFunction('Function HugeWordModInv( const E, M : HugeWord; var R : HugeWord) : Boolean');
 CL.AddDelphiFunction('Procedure HugeWordRandom( var A : HugeWord; const Size : Integer)');
  CL.AddTypeS('TPrimality', '( pPotentialPrime, pNotPrime, pPrime )');
 CL.AddDelphiFunction('Function HugeWordIsPrime_QuickTrial( const A : HugeWord) : TPrimality');
 CL.AddDelphiFunction('Function HugeWordIsPrime_MillerRabin( const A : HugeWord) : TPrimality');
 CL.AddDelphiFunction('Function HugeWordIsPrime( const A : HugeWord) : TPrimality');
 CL.AddDelphiFunction('Procedure HugeWordNextPotentialPrime( var A : HugeWord; const CallbackProc : THugeWordCallbackProc; const CallbackData : Integer)');
 CL.AddDelphiFunction('Procedure HugeIntInit( out A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntFinalise( var A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntNormalise( var A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntInitZero( out A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntInitOne( out A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntInitMinusOne( out A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntInitWord32( out A : HugeInt; const B : LongWord)');
 CL.AddDelphiFunction('Procedure HugeIntInitInt32( out A : HugeInt; const B : LongInt)');
 CL.AddDelphiFunction('Procedure HugeIntInitInt64( out A : HugeInt; const B : Int64)');
 CL.AddDelphiFunction('Procedure HugeIntInitHugeWord( out A : HugeInt; const B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeIntInitHugeInt( out A : HugeInt; const B : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntAssignZero( var A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntAssignOne( var A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntAssignMinusOne( var A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntAssignWord32( var A : HugeInt; const B : LongWord)');
 CL.AddDelphiFunction('Procedure HugeIntAssignInt32( var A : HugeInt; const B : LongInt)');
 CL.AddDelphiFunction('Procedure HugeIntAssignInt64( var A : HugeInt; const B : Int64)');
 CL.AddDelphiFunction('Procedure HugeIntAssignHugeWord( var A : HugeInt; const B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeIntAssignHugeWordNegated( var A : HugeInt; const B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeIntAssignHugeInt( var A : HugeInt; const B : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntSwap( var A, B : HugeInt)');
 CL.AddDelphiFunction('Function HugeIntIsZero( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntIsNegative( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntIsNegativeOrZero( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntIsPositive( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntIsPositiveOrZero( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntIsOne( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntIsMinusOne( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntIsOdd( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntIsEven( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntIsWord32Range( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntIsInt32Range( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntIsInt64Range( const A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntSign( const A : HugeInt) : Integer');
 CL.AddDelphiFunction('Procedure HugeIntNegate( var A : HugeInt)');
 CL.AddDelphiFunction('Function HugeIntAbsInPlace( var A : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntAbs( const A : HugeInt; var B : HugeWord) : Boolean');
 CL.AddDelphiFunction('Function HugeIntToWord32( const A : HugeInt) : LongWord');
 CL.AddDelphiFunction('Function HugeIntToInt32( const A : HugeInt) : LongInt');
 CL.AddDelphiFunction('Function HugeIntToInt64( const A : HugeInt) : Int64');
 CL.AddDelphiFunction('Function HugeIntEqualsWord32( const A : HugeInt; const B : LongWord) : Boolean');
 CL.AddDelphiFunction('Function HugeIntEqualsInt32( const A : HugeInt; const B : LongInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntEqualsInt64( const A : HugeInt; const B : Int64) : Boolean');
 CL.AddDelphiFunction('Function HugeIntEqualsHugeInt( const A, B : HugeInt) : Boolean');
 CL.AddDelphiFunction('Function HugeIntCompareWord32( const A : HugeInt; const B : LongWord) : Integer');
 CL.AddDelphiFunction('Function HugeIntCompareInt32( const A : HugeInt; const B : LongInt) : Integer');
 CL.AddDelphiFunction('Function HugeIntCompareInt64( const A : HugeInt; const B : Int64) : Integer');
 CL.AddDelphiFunction('Function HugeIntCompareHugeInt( const A, B : HugeInt) : Integer');
 CL.AddDelphiFunction('Function HugeIntCompareHugeIntAbs( const A, B : HugeInt) : Integer');
 CL.AddDelphiFunction('Procedure HugeIntMin( var A : HugeInt; const B : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntMax( var A : HugeInt; const B : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntAddWord32( var A : HugeInt; const B : LongWord)');
 CL.AddDelphiFunction('Procedure HugeIntAddInt32( var A : HugeInt; const B : LongInt)');
 CL.AddDelphiFunction('Procedure HugeIntAddHugeInt( var A : HugeInt; const B : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntInc( var A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntSubtractWord32( var A : HugeInt; const B : LongWord)');
 CL.AddDelphiFunction('Procedure HugeIntSubtractInt32( var A : HugeInt; const B : LongInt)');
 CL.AddDelphiFunction('Procedure HugeIntSubtractHugeInt( var A : HugeInt; const B : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntDec( var A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntMultiplyWord8( var A : HugeInt; const B : Byte)');
 CL.AddDelphiFunction('Procedure HugeIntMultiplyWord16( var A : HugeInt; const B : Word)');
 CL.AddDelphiFunction('Procedure HugeIntMultiplyWord32( var A : HugeInt; const B : LongWord)');
 CL.AddDelphiFunction('Procedure HugeIntMultiplyInt8( var A : HugeInt; const B : ShortInt)');
 CL.AddDelphiFunction('Procedure HugeIntMultiplyInt16( var A : HugeInt; const B : SmallInt)');
 CL.AddDelphiFunction('Procedure HugeIntMultiplyInt32( var A : HugeInt; const B : LongInt)');
 CL.AddDelphiFunction('Procedure HugeIntMultiplyHugeWord( var A : HugeInt; const B : HugeWord)');
 CL.AddDelphiFunction('Procedure HugeIntMultiplyHugeInt( var A : HugeInt; const B : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntSqr( var A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntDivideWord32( const A : HugeInt; const B : LongWord; var Q : HugeInt; out R : LongWord)');
 CL.AddDelphiFunction('Procedure HugeIntDivideInt32( const A : HugeInt; const B : LongInt; var Q : HugeInt; out R : LongInt)');
 CL.AddDelphiFunction('Procedure HugeIntDivideHugeInt( const A, B : HugeInt; var Q, R : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntMod( const A, B : HugeInt; var R : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntPower( var A : HugeInt; const B : LongWord)');
 CL.AddDelphiFunction('Function HugeIntToStr( const A : HugeInt) : AnsiString');
 CL.AddDelphiFunction('Procedure StrToHugeInt( const A : AnsiString; var R : HugeInt)');
 CL.AddDelphiFunction('Function HugeIntToHex( const A : HugeInt) : AnsiString');
 CL.AddDelphiFunction('Procedure HexToHugeInt( const A : AnsiString; var R : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntISqrt( var A : HugeInt)');
 CL.AddDelphiFunction('Procedure HugeIntRandom( var A : HugeInt; const Size : Integer)');
  SIRegister_THugeInt(CL);
 CL.AddDelphiFunction('Procedure SelfTestHugeWord');
 //CL.AddDelphiFunction('Procedure Profile');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure THugeIntDivide20_P(Self: THugeInt;  const B : THugeInt; var R : THugeInt);
Begin Self.Divide(B, R); END;

(*----------------------------------------------------------------------------*)
Procedure THugeIntDivide_P(Self: THugeInt;  const B : LongInt; out R : LongInt);
Begin Self.Divide(B, R); END;

(*----------------------------------------------------------------------------*)
Procedure THugeIntMultiply18_P(Self: THugeInt;  const A : THugeInt);
Begin Self.Multiply(A); END;

(*----------------------------------------------------------------------------*)
Procedure THugeIntMultiply_P(Self: THugeInt;  const A : LongInt);
Begin Self.Multiply(A); END;

(*----------------------------------------------------------------------------*)
Procedure THugeIntSubtract16_P(Self: THugeInt;  const A : THugeInt);
Begin Self.Subtract(A); END;

(*----------------------------------------------------------------------------*)
Procedure THugeIntSubtract_P(Self: THugeInt;  const A : LongInt);
Begin Self.Subtract(A); END;

(*----------------------------------------------------------------------------*)
Procedure THugeIntAdd14_P(Self: THugeInt;  const A : THugeInt);
Begin Self.Add(A); END;

(*----------------------------------------------------------------------------*)
Procedure THugeIntAdd_P(Self: THugeInt;  const A : LongInt);
Begin Self.Add(A); END;

(*----------------------------------------------------------------------------*)
Function THugeIntCompare12_P(Self: THugeInt;  const A : THugeInt) : Integer;
Begin Result := Self.Compare(A); END;

(*----------------------------------------------------------------------------*)
Function THugeIntCompare11_P(Self: THugeInt;  const A : Int64) : Integer;
Begin Result := Self.Compare(A); END;

(*----------------------------------------------------------------------------*)
Function THugeIntCompare10_P(Self: THugeInt;  const A : LongInt) : Integer;
Begin Result := Self.Compare(A); END;

(*----------------------------------------------------------------------------*)
Function THugeIntCompare_P(Self: THugeInt;  const A : LongWord) : Integer;
Begin Result := Self.Compare(A); END;

(*----------------------------------------------------------------------------*)
Function THugeIntEquals8_P(Self: THugeInt;  const A : THugeInt) : Boolean;
Begin Result := Self.Equalto(A);
END;

(*----------------------------------------------------------------------------*)
Function THugeIntEquals7_P(Self: THugeInt;  const A : Int64) : Boolean;
Begin Result := Self.Equalto(A);
END;

(*----------------------------------------------------------------------------*)
Function THugeIntEquals6_P(Self: THugeInt;  const A : LongInt) : Boolean;
Begin Result := Self.Equalto(A);
END;

(*----------------------------------------------------------------------------*)
Function THugeIntEquals5_P(Self: THugeInt;  const A : LongWord) : Boolean;
Begin Result := Self.Equalto(A);
END;

(*----------------------------------------------------------------------------*)
Procedure THugeIntAssign4_P(Self: THugeInt;  const A : THugeInt);
Begin Self.Assign(A); END;

(*----------------------------------------------------------------------------*)
Procedure THugeIntAssign_P(Self: THugeInt;  const A : Int64);
Begin Self.Assign(A); END;

(*----------------------------------------------------------------------------*)
Function THugeIntCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const A : THugeInt):TObject;
Begin Result := THugeInt.Create(A); END;

(*----------------------------------------------------------------------------*)
Function THugeIntCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const A : Int64):TObject;
Begin Result := THugeInt.Create(A); END;

(*----------------------------------------------------------------------------*)
Function THugeIntCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := THugeInt.Create; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THugeInt(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THugeInt) do begin
    RegisterConstructor(@THugeIntCreate_P, 'Create');
    RegisterConstructor(@THugeIntCreate1_P, 'Create1');
    RegisterConstructor(@THugeIntCreate2_P, 'Create2');
    RegisterMethod(@THugeInt.Destroy, 'Free');
    RegisterMethod(@THugeInt.AssignZero, 'AssignZero');
    RegisterMethod(@THugeInt.AssignOne, 'AssignOne');
    RegisterMethod(@THugeInt.AssignMinusOne, 'AssignMinusOne');
    RegisterMethod(@THugeIntAssign_P, 'Assign');
    RegisterMethod(@THugeIntAssign4_P, 'Assign2');
    RegisterMethod(@THugeInt.IsZero, 'IsZero');
    RegisterMethod(@THugeInt.IsNegative, 'IsNegative');
    RegisterMethod(@THugeInt.IsPositive, 'IsPositive');
    RegisterMethod(@THugeInt.IsOne, 'IsOne');
    RegisterMethod(@THugeInt.IsMinusOne, 'IsMinusOne');
    RegisterMethod(@THugeInt.IsOdd, 'IsOdd');
    RegisterMethod(@THugeInt.IsEven, 'IsEven');
    RegisterMethod(@THugeInt.Sign, 'Sign');
    RegisterMethod(@THugeInt.Negate, 'Negate');
    RegisterMethod(@THugeInt.Abs, 'Abs');
    RegisterMethod(@THugeInt.ToWord32, 'ToWord32');
    RegisterMethod(@THugeInt.ToInt32, 'ToInt32');
    RegisterMethod(@THugeInt.ToInt64, 'ToInt64');
    RegisterMethod(@THugeIntEquals5_P, 'Equals');
    RegisterMethod(@THugeIntEquals6_P, 'Equals1');
    RegisterMethod(@THugeIntEquals7_P, 'Equals2');
    RegisterMethod(@THugeIntEquals8_P, 'Equals3');
    RegisterMethod(@THugeIntCompare_P, 'Compare');
    RegisterMethod(@THugeIntCompare10_P, 'Compare1');
    RegisterMethod(@THugeIntCompare11_P, 'Compare2');
    RegisterMethod(@THugeIntCompare12_P, 'Compare3');
    RegisterMethod(@THugeIntAdd_P, 'Add');
    RegisterMethod(@THugeIntAdd14_P, 'Add2');
    RegisterMethod(@THugeInt.Inc, 'Inc');
    RegisterMethod(@THugeIntSubtract_P, 'Subtract');
    RegisterMethod(@THugeIntSubtract16_P, 'Subtract2');
    RegisterMethod(@THugeInt.Dec, 'Dec');
    RegisterMethod(@THugeIntMultiply_P, 'Multiply');
    RegisterMethod(@THugeIntMultiply18_P, 'Multiply2');
    RegisterMethod(@THugeInt.Sqr, 'Sqr');
    RegisterMethod(@THugeIntDivide_P, 'Divide');
    RegisterMethod(@THugeIntDivide20_P, 'Divide2');
    RegisterMethod(@THugeInt.Power, 'Power');
    RegisterMethod(@THugeInt.ToStr, 'ToStr');
    RegisterMethod(@THugeInt.ToHex, 'ToHex');
    RegisterMethod(@THugeInt.AssignStr, 'AssignStr');
    RegisterMethod(@THugeInt.AssignHex, 'AssignHex');
    RegisterMethod(@THugeInt.ISqrt, 'ISqrt');
    RegisterMethod(@THugeInt.Random, 'Random');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cHugeInt_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HugeWordInit, 'HugeWordInit', cdRegister);
 S.RegisterDelphiFunction(@HugeWordFinalise, 'HugeWordFinalise', cdRegister);
 S.RegisterDelphiFunction(@HugeWordFinaliseTo, 'HugeWordFinaliseTo', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAlloc, 'HugeWordAlloc', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAllocZero, 'HugeWordAllocZero', cdRegister);
 S.RegisterDelphiFunction(@HugeWordFree, 'HugeWordFree', cdRegister);
 S.RegisterDelphiFunction(@HugeWordRealloc, 'HugeWordRealloc', cdRegister);
 S.RegisterDelphiFunction(@HugeWordGetSize, 'HugeWordGetSize', cdRegister);
 S.RegisterDelphiFunction(@HugeWordSetSize, 'HugeWordSetSize', cdRegister);
 S.RegisterDelphiFunction(@HugeWordGetElement, 'HugeWordGetElement', cdRegister);
 S.RegisterDelphiFunction(@HugeWordSetElement, 'HugeWordSetElement', cdRegister);
 S.RegisterDelphiFunction(@HugeWordGetFirstElementPtr, 'HugeWordGetFirstElementPtr', cdRegister);
 S.RegisterDelphiFunction(@HugeWordGetLastElementPtr, 'HugeWordGetLastElementPtr', cdRegister);
 S.RegisterDelphiFunction(@HugeWordNormalise, 'HugeWordNormalise', cdRegister);
 S.RegisterDelphiFunction(@HugeWordInitZero, 'HugeWordInitZero', cdRegister);
 S.RegisterDelphiFunction(@HugeWordInitOne, 'HugeWordInitOne', cdRegister);
 S.RegisterDelphiFunction(@HugeWordInitWord32, 'HugeWordInitWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordInitInt32, 'HugeWordInitInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordInitInt64, 'HugeWordInitInt64', cdRegister);
 S.RegisterDelphiFunction(@HugeWordInitHugeWord, 'HugeWordInitHugeWord', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAssignZero, 'HugeWordAssignZero', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAssignOne, 'HugeWordAssignOne', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAssignWord32, 'HugeWordAssignWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAssignInt32, 'HugeWordAssignInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAssignInt64, 'HugeWordAssignInt64', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAssign, 'HugeWordAssign', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAssignHugeIntAbs, 'HugeWordAssignHugeIntAbs', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAssignBuf, 'HugeWordAssignBuf', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAssignBufStr, 'HugeWordAssignBufStr', cdRegister);
 S.RegisterDelphiFunction(@HugeWordSwap, 'HugeWordSwap', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsZero, 'HugeWordIsZero', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsOne, 'HugeWordIsOne', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsOdd, 'HugeWordIsOdd', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsEven, 'HugeWordIsEven', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsWord32Range, 'HugeWordIsWord32Range', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsWord64Range, 'HugeWordIsWord64Range', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsWord128Range, 'HugeWordIsWord128Range', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsInt32Range, 'HugeWordIsInt32Range', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsInt64Range, 'HugeWordIsInt64Range', cdRegister);
 S.RegisterDelphiFunction(@HugeWordToWord32, 'HugeWordToWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordToInt32, 'HugeWordToInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordToInt64, 'HugeWordToInt64', cdRegister);
 S.RegisterDelphiFunction(@HugeWordEqualsWord32, 'HugeWordEqualsWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordEqualsInt32, 'HugeWordEqualsInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordEqualsInt64, 'HugeWordEqualsInt64', cdRegister);
 S.RegisterDelphiFunction(@HugeWordEquals, 'HugeWordEquals', cdRegister);
 S.RegisterDelphiFunction(@HugeWordCompareWord32, 'HugeWordCompareWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordCompareInt32, 'HugeWordCompareInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordCompareInt64, 'HugeWordCompareInt64', cdRegister);
 S.RegisterDelphiFunction(@HugeWordCompare, 'HugeWordCompare', cdRegister);
 S.RegisterDelphiFunction(@HugeWordMin, 'HugeWordMin', cdRegister);
 S.RegisterDelphiFunction(@HugeWordMax, 'HugeWordMax', cdRegister);
 S.RegisterDelphiFunction(@HugeWordGetBitCount, 'HugeWordGetBitCount', cdRegister);
 S.RegisterDelphiFunction(@HugeWordSetBitCount, 'HugeWordSetBitCount', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsBitSet, 'HugeWordIsBitSet', cdRegister);
 S.RegisterDelphiFunction(@HugeWordSetBit, 'HugeWordSetBit', cdRegister);
 S.RegisterDelphiFunction(@HugeWordClearBit, 'HugeWordClearBit', cdRegister);
 S.RegisterDelphiFunction(@HugeWordToggleBit, 'HugeWordToggleBit', cdRegister);
 S.RegisterDelphiFunction(@HugeWordSetBitScanForward, 'HugeWordSetBitScanForward', cdRegister);
 S.RegisterDelphiFunction(@HugeWordSetBitScanReverse, 'HugeWordSetBitScanReverse', cdRegister);
 S.RegisterDelphiFunction(@HugeWordClearBitScanForward, 'HugeWordClearBitScanForward', cdRegister);
 S.RegisterDelphiFunction(@HugeWordClearBitScanReverse, 'HugeWordClearBitScanReverse', cdRegister);
 S.RegisterDelphiFunction(@HugeWordShl, 'HugeWordShl', cdRegister);
 S.RegisterDelphiFunction(@HugeWordShl1, 'HugeWordShl1', cdRegister);
 S.RegisterDelphiFunction(@HugeWordShr, 'HugeWordShr', cdRegister);
 S.RegisterDelphiFunction(@HugeWordShr1, 'HugeWordShr1', cdRegister);
 S.RegisterDelphiFunction(@HugeWordNot, 'HugeWordNot', cdRegister);
 S.RegisterDelphiFunction(@HugeWordOrHugeWord, 'HugeWordOrHugeWord', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAndHugeWord, 'HugeWordAndHugeWord', cdRegister);
 S.RegisterDelphiFunction(@HugeWordXorHugeWord, 'HugeWordXorHugeWord', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAddWord32, 'HugeWordAddWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordAdd, 'HugeWordAdd', cdRegister);
 S.RegisterDelphiFunction(@HugeWordInc, 'HugeWordInc', cdRegister);
 S.RegisterDelphiFunction(@HugeWordSubtractWord32, 'HugeWordSubtractWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordSubtract, 'HugeWordSubtract', cdRegister);
 S.RegisterDelphiFunction(@HugeWordDec, 'HugeWordDec', cdRegister);
 S.RegisterDelphiFunction(@HugeWordMultiplyWord8, 'HugeWordMultiplyWord8', cdRegister);
 S.RegisterDelphiFunction(@HugeWordMultiplyWord16, 'HugeWordMultiplyWord16', cdRegister);
 S.RegisterDelphiFunction(@HugeWordMultiplyWord32, 'HugeWordMultiplyWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordMultiply_Long_NN, 'HugeWordMultiply_Long_NN', cdRegister);
 S.RegisterDelphiFunction(@HugeWordMultiply_Long_NN_Unsafe, 'HugeWordMultiply_Long_NN_Unsafe', cdRegister);
 S.RegisterDelphiFunction(@HugeWordMultiply_Long, 'HugeWordMultiply_Long', cdRegister);
 S.RegisterDelphiFunction(@HugeWordMultiply_ShiftAdd, 'HugeWordMultiply_ShiftAdd', cdRegister);
 S.RegisterDelphiFunction(@HugeWordMultiply, 'HugeWordMultiply', cdRegister);
 S.RegisterDelphiFunction(@HugeWordSqr, 'HugeWordSqr', cdRegister);
 S.RegisterDelphiFunction(@HugeWordDivideWord32, 'HugeWordDivideWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeWordDivide_RR, 'HugeWordDivide_RR', cdRegister);
 S.RegisterDelphiFunction(@HugeWordDivide_RR_Unsafe, 'HugeWordDivide_RR_Unsafe', cdRegister);
 S.RegisterDelphiFunction(@HugeWordDivide, 'HugeWordDivide', cdRegister);
 S.RegisterDelphiFunction(@HugeWordMod, 'HugeWordMod', cdRegister);
 S.RegisterDelphiFunction(@HugeWordGCD, 'HugeWordGCD', cdRegister);
 S.RegisterDelphiFunction(@HugeWordPower, 'HugeWordPower', cdRegister);
 S.RegisterDelphiFunction(@HugeWordPowerAndMod, 'HugeWordPowerAndMod', cdRegister);
 S.RegisterDelphiFunction(@HugeWordToStr, 'HugeWordToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToHugeWord, 'StrToHugeWord', cdRegister);
 S.RegisterDelphiFunction(@HugeWordToHex, 'HugeWordToHex', cdRegister);
 S.RegisterDelphiFunction(@HexToHugeWord, 'HexToHugeWord', cdRegister);
 S.RegisterDelphiFunction(@HugeWordISqrt, 'HugeWordISqrt', cdRegister);
 S.RegisterDelphiFunction(@HugeWordExtendedEuclid, 'HugeWordExtendedEuclid', cdRegister);
 S.RegisterDelphiFunction(@HugeWordModInv, 'HugeWordModInv', cdRegister);
 S.RegisterDelphiFunction(@HugeWordRandom, 'HugeWordRandom', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsPrime_QuickTrial, 'HugeWordIsPrime_QuickTrial', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsPrime_MillerRabin, 'HugeWordIsPrime_MillerRabin', cdRegister);
 S.RegisterDelphiFunction(@HugeWordIsPrime, 'HugeWordIsPrime', cdRegister);
 S.RegisterDelphiFunction(@HugeWordNextPotentialPrime, 'HugeWordNextPotentialPrime', cdRegister);
 S.RegisterDelphiFunction(@HugeIntInit, 'HugeIntInit', cdRegister);
 S.RegisterDelphiFunction(@HugeIntFinalise, 'HugeIntFinalise', cdRegister);
 S.RegisterDelphiFunction(@HugeIntNormalise, 'HugeIntNormalise', cdRegister);
 S.RegisterDelphiFunction(@HugeIntInitZero, 'HugeIntInitZero', cdRegister);
 S.RegisterDelphiFunction(@HugeIntInitOne, 'HugeIntInitOne', cdRegister);
 S.RegisterDelphiFunction(@HugeIntInitMinusOne, 'HugeIntInitMinusOne', cdRegister);
 S.RegisterDelphiFunction(@HugeIntInitWord32, 'HugeIntInitWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntInitInt32, 'HugeIntInitInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntInitInt64, 'HugeIntInitInt64', cdRegister);
 S.RegisterDelphiFunction(@HugeIntInitHugeWord, 'HugeIntInitHugeWord', cdRegister);
 S.RegisterDelphiFunction(@HugeIntInitHugeInt, 'HugeIntInitHugeInt', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAssignZero, 'HugeIntAssignZero', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAssignOne, 'HugeIntAssignOne', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAssignMinusOne, 'HugeIntAssignMinusOne', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAssignWord32, 'HugeIntAssignWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAssignInt32, 'HugeIntAssignInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAssignInt64, 'HugeIntAssignInt64', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAssignHugeWord, 'HugeIntAssignHugeWord', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAssignHugeWordNegated, 'HugeIntAssignHugeWordNegated', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAssignHugeInt, 'HugeIntAssignHugeInt', cdRegister);
 S.RegisterDelphiFunction(@HugeIntSwap, 'HugeIntSwap', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsZero, 'HugeIntIsZero', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsNegative, 'HugeIntIsNegative', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsNegativeOrZero, 'HugeIntIsNegativeOrZero', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsPositive, 'HugeIntIsPositive', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsPositiveOrZero, 'HugeIntIsPositiveOrZero', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsOne, 'HugeIntIsOne', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsMinusOne, 'HugeIntIsMinusOne', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsOdd, 'HugeIntIsOdd', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsEven, 'HugeIntIsEven', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsWord32Range, 'HugeIntIsWord32Range', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsInt32Range, 'HugeIntIsInt32Range', cdRegister);
 S.RegisterDelphiFunction(@HugeIntIsInt64Range, 'HugeIntIsInt64Range', cdRegister);
 S.RegisterDelphiFunction(@HugeIntSign, 'HugeIntSign', cdRegister);
 S.RegisterDelphiFunction(@HugeIntNegate, 'HugeIntNegate', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAbsInPlace, 'HugeIntAbsInPlace', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAbs, 'HugeIntAbs', cdRegister);
 S.RegisterDelphiFunction(@HugeIntToWord32, 'HugeIntToWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntToInt32, 'HugeIntToInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntToInt64, 'HugeIntToInt64', cdRegister);
 S.RegisterDelphiFunction(@HugeIntEqualsWord32, 'HugeIntEqualsWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntEqualsInt32, 'HugeIntEqualsInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntEqualsInt64, 'HugeIntEqualsInt64', cdRegister);
 S.RegisterDelphiFunction(@HugeIntEqualsHugeInt, 'HugeIntEqualsHugeInt', cdRegister);
 S.RegisterDelphiFunction(@HugeIntCompareWord32, 'HugeIntCompareWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntCompareInt32, 'HugeIntCompareInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntCompareInt64, 'HugeIntCompareInt64', cdRegister);
 S.RegisterDelphiFunction(@HugeIntCompareHugeInt, 'HugeIntCompareHugeInt', cdRegister);
 S.RegisterDelphiFunction(@HugeIntCompareHugeIntAbs, 'HugeIntCompareHugeIntAbs', cdRegister);
 S.RegisterDelphiFunction(@HugeIntMin, 'HugeIntMin', cdRegister);
 S.RegisterDelphiFunction(@HugeIntMax, 'HugeIntMax', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAddWord32, 'HugeIntAddWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAddInt32, 'HugeIntAddInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntAddHugeInt, 'HugeIntAddHugeInt', cdRegister);
 S.RegisterDelphiFunction(@HugeIntInc, 'HugeIntInc', cdRegister);
 S.RegisterDelphiFunction(@HugeIntSubtractWord32, 'HugeIntSubtractWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntSubtractInt32, 'HugeIntSubtractInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntSubtractHugeInt, 'HugeIntSubtractHugeInt', cdRegister);
 S.RegisterDelphiFunction(@HugeIntDec, 'HugeIntDec', cdRegister);
 S.RegisterDelphiFunction(@HugeIntMultiplyWord8, 'HugeIntMultiplyWord8', cdRegister);
 S.RegisterDelphiFunction(@HugeIntMultiplyWord16, 'HugeIntMultiplyWord16', cdRegister);
 S.RegisterDelphiFunction(@HugeIntMultiplyWord32, 'HugeIntMultiplyWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntMultiplyInt8, 'HugeIntMultiplyInt8', cdRegister);
 S.RegisterDelphiFunction(@HugeIntMultiplyInt16, 'HugeIntMultiplyInt16', cdRegister);
 S.RegisterDelphiFunction(@HugeIntMultiplyInt32, 'HugeIntMultiplyInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntMultiplyHugeWord, 'HugeIntMultiplyHugeWord', cdRegister);
 S.RegisterDelphiFunction(@HugeIntMultiplyHugeInt, 'HugeIntMultiplyHugeInt', cdRegister);
 S.RegisterDelphiFunction(@HugeIntSqr, 'HugeIntSqr', cdRegister);
 S.RegisterDelphiFunction(@HugeIntDivideWord32, 'HugeIntDivideWord32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntDivideInt32, 'HugeIntDivideInt32', cdRegister);
 S.RegisterDelphiFunction(@HugeIntDivideHugeInt, 'HugeIntDivideHugeInt', cdRegister);
 S.RegisterDelphiFunction(@HugeIntMod, 'HugeIntMod', cdRegister);
 S.RegisterDelphiFunction(@HugeIntPower, 'HugeIntPower', cdRegister);
 S.RegisterDelphiFunction(@HugeIntToStr, 'HugeIntToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToHugeInt, 'StrToHugeInt', cdRegister);
 S.RegisterDelphiFunction(@HugeIntToHex, 'HugeIntToHex', cdRegister);
 S.RegisterDelphiFunction(@HexToHugeInt, 'HexToHugeInt', cdRegister);
 S.RegisterDelphiFunction(@HugeIntISqrt, 'HugeIntISqrt', cdRegister);
 S.RegisterDelphiFunction(@HugeIntRandom, 'HugeIntRandom', cdRegister);
//  RIRegister_THugeInt(CL);
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestHugeWord', cdRegister);
 //S.RegisterDelphiFunction(@Profile, 'Profile', cdRegister);
end;

 
 
{ TPSImport_cHugeInt }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cHugeInt.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cHugeInt(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cHugeInt.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cHugeInt_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
