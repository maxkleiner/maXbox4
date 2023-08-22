unit uPSI_xrtl_math_Integer;
{
  another big integer with a bigmulu function
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
  TPSImport_xrtl_math_Integer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_xrtl_math_Integer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_math_Integer_Routines(S: TPSExec);
procedure RIRegister_xrtl_math_Integer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Math
  ,xrtl_util_Exception
  ,xrtl_math_Integer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_math_Integer]);
end;

function BigMulu(aone, atwo: string): string;
var bigint, bigint1, bigintres: TXRTLInteger;
begin
  XRTLFromString(aone, bigint, 10);
  XRTLFromString(atwo, bigint1, 10);
  XRTLMul(bigint,bigint1,bigintres);
  result:= XRTLToString(bigintres,10,10);
end;

function BigAdd(aone, atwo: string): string;
var bigint, bigint1, bigintres: TXRTLInteger;
begin
  XRTLFromString(aone, bigint, 10);
  XRTLFromString(atwo, bigint1, 10);
  XRTLAdd(bigint,bigint1,bigintres);
  result:= XRTLToString(bigintres,10,10);
end;

function BigSub(aone, atwo: string): string;
var bigint, bigint1, bigintres: TXRTLInteger;
begin
  XRTLFromString(aone, bigint, 10);
  XRTLFromString(atwo, bigint1, 10);
  XRTLSub(bigint,bigint1,bigintres);
  result:= XRTLToString(bigintres,10,10);
end;

function BigDiv(aone, atwo: string): string;
var bigint, bigint1, bigintres, bigintres1: TXRTLInteger;
begin
  XRTLFromString(aone, bigint, 10);
  XRTLFromString(atwo, bigint1, 10);
  XRTLDivMod(bigint,bigint1,bigintres, bigintres1);
  result:= XRTLToString(bigintres,10,10);
end;


function BigExp(aone, atwo: string): string;
var bigint, bigint1, bigintres: TXRTLInteger;
begin
  XRTLFromString(aone, bigint, 10);
  XRTLFromString(atwo, bigint1, 10);
  XRTLExp(bigint,bigint1,bigintres);
  result:= XRTLToString(bigintres,10,10);
end;

function BigFactorial(aone: string): string;
var bigint, bigintres: TXRTLInteger;
begin
  XRTLFromString(aone, bigint, 10);
  XRTLFactorial(bigint,bigintres);
  result:= XRTLToString(bigintres,10,10);
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_math_Integer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TXRTLInteger', 'array of Integer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXRTLMathException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXRTLExtendInvalidArgument');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXRTLDivisionByZero');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXRTLExpInvalidArgument');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXRTLInvalidRadix');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXRTLInvalidRadixDigit');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EXRTLRootInvalidArgument');
 CL.AddConstantN('BitsPerByte','LongInt').SetInt( 8);
 CL.AddConstantN('BitsPerDigit','LongInt').SetInt( 32);
 CL.AddConstantN('SignBitMask','LongWord').SetUInt( $80000000);
 CL.AddDelphiFunction('Function XRTLAdjustBits( const ABits : Integer) : Integer');
 CL.AddDelphiFunction('Function XRTLLength( const AInteger : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Function XRTLDataBits( const AInteger : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Procedure XRTLBitPosition( const BitIndex : Integer; var Index, Mask : Integer)');
 CL.AddDelphiFunction('Procedure XRTLBitSet( var AInteger : TXRTLInteger; const BitIndex : Integer)');
 CL.AddDelphiFunction('Procedure XRTLBitReset( var AInteger : TXRTLInteger; const BitIndex : Integer)');
 CL.AddDelphiFunction('Function XRTLBitGet( const AInteger : TXRTLInteger; const BitIndex : Integer) : Integer');
 CL.AddDelphiFunction('Function XRTLBitGetBool( const AInteger : TXRTLInteger; const BitIndex : Integer) : Boolean');
 CL.AddDelphiFunction('Function XRTLExtend( const AInteger : TXRTLInteger; ADataBits : Integer; Sign : Integer; var AResult : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Function XRTLZeroExtend( const AInteger : TXRTLInteger; ADataBits : Integer; var AResult : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Function XRTLSignExtend( const AInteger : TXRTLInteger; ADataBits : Integer; var AResult : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Function XRTLSignStrip( const AInteger : TXRTLInteger; var AResult : TXRTLInteger; const AMinDataBits : Integer) : Integer');
 CL.AddDelphiFunction('Procedure XRTLNot( const AInteger : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLOr( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLAnd( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLXor( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Function XRTLSign( const AInteger : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Procedure XRTLZero( var AInteger : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLOne( var AInteger : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLMOne( var AInteger : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLTwo( var AInteger : TXRTLInteger)');
 CL.AddDelphiFunction('Function XRTLNeg( const AInteger : TXRTLInteger; var AResult : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Function XRTLAbs( const AInteger : TXRTLInteger; var AResult : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Procedure XRTLFullSum( const A, B, C : Integer; var Sum, Carry : Integer)');
 CL.AddDelphiFunction('Function XRTLAdd( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger) : Integer;');
 CL.AddDelphiFunction('Function XRTLAdd1( const AInteger1 : TXRTLInteger; const AInteger2 : Int64; var AResult : TXRTLInteger) : Integer;');
 CL.AddDelphiFunction('Function XRTLSub( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger) : Integer;');
 CL.AddDelphiFunction('Function XRTLSub1( const AInteger1 : TXRTLInteger; const AInteger2 : Int64; var AResult : TXRTLInteger) : Integer;');
 CL.AddDelphiFunction('Function XRTLCompare( const AInteger1, AInteger2 : TXRTLInteger) : Integer;');
 CL.AddDelphiFunction('Function XRTLCompare1( const AInteger1 : TXRTLInteger; const AInteger2 : Int64) : Integer;');
 CL.AddDelphiFunction('Function XRTLUMul( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Function XRTLMulAdd( const AInteger1, AInteger2, AInteger3 : TXRTLInteger; var AResult : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Function XRTLMul( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Procedure XRTLDivMod( const AInteger1, AInteger2 : TXRTLInteger; var QResult, RResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSqr( const AInteger : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSqrt( const AInteger : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLRoot( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLRootApprox( const AInteger1, AInteger2 : TXRTLInteger; var ALowApproxResult, AHighApproxResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLURootApprox( const AInteger1, AInteger2 : TXRTLInteger; var ALowApproxResult, AHighApproxResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLExp( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLExpMod( const AInteger1, AInteger2, AInteger3 : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSLBL( const AInteger : TXRTLInteger; const BitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSABL( const AInteger : TXRTLInteger; const BitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLRCBL( const AInteger : TXRTLInteger; const BitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSLDL( const AInteger : TXRTLInteger; const DigitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSADL( const AInteger : TXRTLInteger; const DigitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLRCDL( const AInteger : TXRTLInteger; const DigitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSLBR( const AInteger : TXRTLInteger; const BitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSABR( const AInteger : TXRTLInteger; const BitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLRCBR( const AInteger : TXRTLInteger; const BitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSLDR( const AInteger : TXRTLInteger; const DigitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSADR( const AInteger : TXRTLInteger; const DigitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLRCDR( const AInteger : TXRTLInteger; const DigitCount : Integer; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Function XRTLToHex( const AInteger : TXRTLInteger; Digits : Integer) : string');
 CL.AddDelphiFunction('Function XRTLToBin( const AInteger : TXRTLInteger; Digits : Integer) : string');
 CL.AddDelphiFunction('Function XRTLToString( const AInteger : TXRTLInteger; Radix : Integer; Digits : Integer) : string');
 CL.AddDelphiFunction('Procedure XRTLFromHex( const Value : string; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLFromBin( const Value : string; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLFromString( const Value : string; var AResult : TXRTLInteger; Radix : Integer)');
 CL.AddDelphiFunction('Procedure XRTLAssign( const AInteger : TXRTLInteger; var AResult : TXRTLInteger);');
 CL.AddDelphiFunction('Procedure XRTLAssign1( const Value : Integer; var AResult : TXRTLInteger);');
 CL.AddDelphiFunction('Procedure XRTLAssign2( const Value : Int64; var AResult : TXRTLInteger);');
 CL.AddDelphiFunction('Procedure XRTLAppend( const ALow, AHigh : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSplit( const AInteger : TXRTLInteger; var ALow, AHigh : TXRTLInteger; LowDigits : Integer)');
 CL.AddDelphiFunction('Function XRTLGetMSBitIndex( const AInteger : TXRTLInteger) : Integer');
 CL.AddDelphiFunction('Procedure XRTLMinMax( const AInteger1, AInteger2 : TXRTLInteger; var AMinResult, AMaxResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLMin( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger);');
 CL.AddDelphiFunction('Procedure XRTLMin1( const AInteger1 : TXRTLInteger; const AInteger2 : Integer; var AResult : TXRTLInteger);');
 CL.AddDelphiFunction('Procedure XRTLMax( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger);');
 CL.AddDelphiFunction('Procedure XRTLMax1( const AInteger1 : TXRTLInteger; const AInteger2 : Integer; var AResult : TXRTLInteger);');
 CL.AddDelphiFunction('Procedure XRTLGCD( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLSwap( var AInteger1, AInteger2 : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLFactorial( const AInteger : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('Procedure XRTLFactorialMod( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger)');
 CL.AddDelphiFunction('function BigMulu(aone, atwo: string): string;');
 CL.AddDelphiFunction('function BigNumber(aone, atwo: string): string;');
 CL.AddDelphiFunction('function BigExp(aone, atwo: string): string;');
 CL.AddDelphiFunction('function BigMul(aone, atwo: string): string;');
 CL.AddDelphiFunction('function BigAdd(aone, atwo: string): string;');
 CL.AddDelphiFunction('function BigSub(aone, atwo: string): string;');
 CL.AddDelphiFunction('function BigFactorial(aone: string): string;');
 CL.AddDelphiFunction('function BigFact(aone: string): string;');
  CL.AddDelphiFunction('function BigDivMod(aone, atwo: string): string;');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure XRTLMax1_P( const AInteger1 : TXRTLInteger; const AInteger2 : Integer; var AResult : TXRTLInteger);
Begin xrtl_math_Integer.XRTLMax(AInteger1, AInteger2, AResult); END;

(*----------------------------------------------------------------------------*)
Procedure XRTLMax_P( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger);
Begin xrtl_math_Integer.XRTLMax(AInteger1, AInteger2, AResult); END;

(*----------------------------------------------------------------------------*)
Procedure XRTLMin1_P( const AInteger1 : TXRTLInteger; const AInteger2 : Integer; var AResult : TXRTLInteger);
Begin xrtl_math_Integer.XRTLMin(AInteger1, AInteger2, AResult); END;

(*----------------------------------------------------------------------------*)
Procedure XRTLMin_P( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger);
Begin xrtl_math_Integer.XRTLMin(AInteger1, AInteger2, AResult); END;

(*----------------------------------------------------------------------------*)
Procedure XRTLAssign2_P( const Value : Int64; var AResult : TXRTLInteger);
Begin xrtl_math_Integer.XRTLAssign(Value, AResult); END;

(*----------------------------------------------------------------------------*)
Procedure XRTLAssign1_P( const Value : Integer; var AResult : TXRTLInteger);
Begin xrtl_math_Integer.XRTLAssign(Value, AResult); END;

(*----------------------------------------------------------------------------*)
Procedure XRTLAssign_P( const AInteger : TXRTLInteger; var AResult : TXRTLInteger);
Begin xrtl_math_Integer.XRTLAssign(AInteger, AResult); END;

(*----------------------------------------------------------------------------*)
Function XRTLCompare1_P( const AInteger1 : TXRTLInteger; const AInteger2 : Int64) : Integer;
Begin Result := xrtl_math_Integer.XRTLCompare(AInteger1, AInteger2); END;

(*----------------------------------------------------------------------------*)
Function XRTLCompare_P( const AInteger1, AInteger2 : TXRTLInteger) : Integer;
Begin Result := xrtl_math_Integer.XRTLCompare(AInteger1, AInteger2); END;

(*----------------------------------------------------------------------------*)
Function XRTLSub1_P( const AInteger1 : TXRTLInteger; const AInteger2 : Int64; var AResult : TXRTLInteger) : Integer;
Begin Result := xrtl_math_Integer.XRTLSub(AInteger1, AInteger2, AResult); END;

(*----------------------------------------------------------------------------*)
Function XRTLSub_P( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger) : Integer;
Begin Result := xrtl_math_Integer.XRTLSub(AInteger1, AInteger2, AResult); END;

(*----------------------------------------------------------------------------*)
Function XRTLAdd1_P( const AInteger1 : TXRTLInteger; const AInteger2 : Int64; var AResult : TXRTLInteger) : Integer;
Begin Result := xrtl_math_Integer.XRTLAdd(AInteger1, AInteger2, AResult); END;

(*----------------------------------------------------------------------------*)
Function XRTLAdd_P( const AInteger1, AInteger2 : TXRTLInteger; var AResult : TXRTLInteger) : Integer;
Begin Result := xrtl_math_Integer.XRTLAdd(AInteger1, AInteger2, AResult); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_math_Integer_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLAdjustBits, 'XRTLAdjustBits', cdRegister);
 S.RegisterDelphiFunction(@XRTLLength, 'XRTLLength', cdRegister);
 S.RegisterDelphiFunction(@XRTLDataBits, 'XRTLDataBits', cdRegister);
 S.RegisterDelphiFunction(@XRTLBitPosition, 'XRTLBitPosition', cdRegister);
 S.RegisterDelphiFunction(@XRTLBitSet, 'XRTLBitSet', cdRegister);
 S.RegisterDelphiFunction(@XRTLBitReset, 'XRTLBitReset', cdRegister);
 S.RegisterDelphiFunction(@XRTLBitGet, 'XRTLBitGet', cdRegister);
 S.RegisterDelphiFunction(@XRTLBitGetBool, 'XRTLBitGetBool', cdRegister);
 S.RegisterDelphiFunction(@XRTLExtend, 'XRTLExtend', cdRegister);
 S.RegisterDelphiFunction(@XRTLZeroExtend, 'XRTLZeroExtend', cdRegister);
 S.RegisterDelphiFunction(@XRTLSignExtend, 'XRTLSignExtend', cdRegister);
 S.RegisterDelphiFunction(@XRTLSignStrip, 'XRTLSignStrip', cdRegister);
 S.RegisterDelphiFunction(@XRTLNot, 'XRTLNot', cdRegister);
 S.RegisterDelphiFunction(@XRTLOr, 'XRTLOr', cdRegister);
 S.RegisterDelphiFunction(@XRTLAnd, 'XRTLAnd', cdRegister);
 S.RegisterDelphiFunction(@XRTLXor, 'XRTLXor', cdRegister);
 S.RegisterDelphiFunction(@XRTLSign, 'XRTLSign', cdRegister);
 S.RegisterDelphiFunction(@XRTLZero, 'XRTLZero', cdRegister);
 S.RegisterDelphiFunction(@XRTLOne, 'XRTLOne', cdRegister);
 S.RegisterDelphiFunction(@XRTLMOne, 'XRTLMOne', cdRegister);
 S.RegisterDelphiFunction(@XRTLTwo, 'XRTLTwo', cdRegister);
 S.RegisterDelphiFunction(@XRTLNeg, 'XRTLNeg', cdRegister);
 S.RegisterDelphiFunction(@XRTLAbs, 'XRTLAbs', cdRegister);
 S.RegisterDelphiFunction(@XRTLFullSum, 'XRTLFullSum', CdStdCall);
 S.RegisterDelphiFunction(@XRTLAdd, 'XRTLAdd', cdRegister);
 S.RegisterDelphiFunction(@XRTLAdd1_P, 'XRTLAdd1', cdRegister);
 S.RegisterDelphiFunction(@XRTLSub, 'XRTLSub', cdRegister);
 S.RegisterDelphiFunction(@XRTLSub1_P, 'XRTLSub1', cdRegister);
 S.RegisterDelphiFunction(@XRTLCompare, 'XRTLCompare', cdRegister);
 S.RegisterDelphiFunction(@XRTLCompare1_P, 'XRTLCompare1', cdRegister);
 S.RegisterDelphiFunction(@XRTLUMul, 'XRTLUMul', cdRegister);
 S.RegisterDelphiFunction(@XRTLMulAdd, 'XRTLMulAdd', cdRegister);
 S.RegisterDelphiFunction(@XRTLMul, 'XRTLMul', cdRegister);
 S.RegisterDelphiFunction(@XRTLDivMod, 'XRTLDivMod', cdRegister);
 S.RegisterDelphiFunction(@XRTLSqr, 'XRTLSqr', cdRegister);
 S.RegisterDelphiFunction(@XRTLSqrt, 'XRTLSqrt', cdRegister);
 S.RegisterDelphiFunction(@XRTLRoot, 'XRTLRoot', cdRegister);
 S.RegisterDelphiFunction(@XRTLRootApprox, 'XRTLRootApprox', cdRegister);
 S.RegisterDelphiFunction(@XRTLURootApprox, 'XRTLURootApprox', cdRegister);
 S.RegisterDelphiFunction(@XRTLExp, 'XRTLExp', cdRegister);
 S.RegisterDelphiFunction(@XRTLExpMod, 'XRTLExpMod', cdRegister);
 S.RegisterDelphiFunction(@XRTLSLBL, 'XRTLSLBL', cdRegister);
 S.RegisterDelphiFunction(@XRTLSABL, 'XRTLSABL', cdRegister);
 S.RegisterDelphiFunction(@XRTLRCBL, 'XRTLRCBL', cdRegister);
 S.RegisterDelphiFunction(@XRTLSLDL, 'XRTLSLDL', cdRegister);
 S.RegisterDelphiFunction(@XRTLSADL, 'XRTLSADL', cdRegister);
 S.RegisterDelphiFunction(@XRTLRCDL, 'XRTLRCDL', cdRegister);
 S.RegisterDelphiFunction(@XRTLSLBR, 'XRTLSLBR', cdRegister);
 S.RegisterDelphiFunction(@XRTLSABR, 'XRTLSABR', cdRegister);
 S.RegisterDelphiFunction(@XRTLRCBR, 'XRTLRCBR', cdRegister);
 S.RegisterDelphiFunction(@XRTLSLDR, 'XRTLSLDR', cdRegister);
 S.RegisterDelphiFunction(@XRTLSADR, 'XRTLSADR', cdRegister);
 S.RegisterDelphiFunction(@XRTLRCDR, 'XRTLRCDR', cdRegister);
 S.RegisterDelphiFunction(@XRTLToHex, 'XRTLToHex', cdRegister);
 S.RegisterDelphiFunction(@XRTLToBin, 'XRTLToBin', cdRegister);
 S.RegisterDelphiFunction(@XRTLToString, 'XRTLToString', cdRegister);
 S.RegisterDelphiFunction(@XRTLFromHex, 'XRTLFromHex', cdRegister);
 S.RegisterDelphiFunction(@XRTLFromBin, 'XRTLFromBin', cdRegister);
 S.RegisterDelphiFunction(@XRTLFromString, 'XRTLFromString', cdRegister);
 S.RegisterDelphiFunction(@XRTLAssign, 'XRTLAssign', cdRegister);
 S.RegisterDelphiFunction(@XRTLAssign1_P, 'XRTLAssign1', cdRegister);
 S.RegisterDelphiFunction(@XRTLAssign2_P, 'XRTLAssign2', cdRegister);
 S.RegisterDelphiFunction(@XRTLAppend, 'XRTLAppend', cdRegister);
 S.RegisterDelphiFunction(@XRTLSplit, 'XRTLSplit', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetMSBitIndex, 'XRTLGetMSBitIndex', cdRegister);
 S.RegisterDelphiFunction(@XRTLMinMax, 'XRTLMinMax', cdRegister);
 S.RegisterDelphiFunction(@XRTLMin, 'XRTLMin', cdRegister);
 S.RegisterDelphiFunction(@XRTLMin1_P, 'XRTLMin1', cdRegister);
 S.RegisterDelphiFunction(@XRTLMax, 'XRTLMax', cdRegister);
 S.RegisterDelphiFunction(@XRTLMax1_P, 'XRTLMax1', cdRegister);
 S.RegisterDelphiFunction(@XRTLGCD, 'XRTLGCD', cdRegister);
 S.RegisterDelphiFunction(@XRTLSwap, 'XRTLSwap', cdRegister);
 S.RegisterDelphiFunction(@XRTLFactorial, 'XRTLFactorial', cdRegister);
 S.RegisterDelphiFunction(@XRTLFactorialMod, 'XRTLFactorialMod', cdRegister);
 S.RegisterDelphiFunction(@BigMulu, 'BigMulu', cdRegister);
 S.RegisterDelphiFunction(@BigMulu, 'BigNumber', cdRegister);
 S.RegisterDelphiFunction(@BigExp, 'BigExp', cdRegister);
 S.RegisterDelphiFunction(@BigMulu, 'BigMul', cdRegister);
 S.RegisterDelphiFunction(@BigAdd, 'BigAdd', cdRegister);
 S.RegisterDelphiFunction(@BigSub, 'BigSub', cdRegister);
 S.RegisterDelphiFunction(@BigFactorial, 'BigFactorial', cdRegister);
 S.RegisterDelphiFunction(@BigFactorial, 'BigFact', cdRegister);
 S.RegisterDelphiFunction(@BigDiv, 'BigDivMod', cdRegister);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_math_Integer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EXRTLMathException) do
  with CL.Add(EXRTLExtendInvalidArgument) do
  with CL.Add(EXRTLDivisionByZero) do
  with CL.Add(EXRTLExpInvalidArgument) do
  with CL.Add(EXRTLInvalidRadix) do
  with CL.Add(EXRTLInvalidRadixDigit) do
  with CL.Add(EXRTLRootInvalidArgument) do
end;

 
 
{ TPSImport_xrtl_math_Integer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_math_Integer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_math_Integer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_math_Integer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_math_Integer(ri);
  RIRegister_xrtl_math_Integer_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
