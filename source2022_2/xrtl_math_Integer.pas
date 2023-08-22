unit xrtl_math_Integer;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils, Math,
  xrtl_util_Exception;

type
  TXRTLInteger = array of Integer;

  EXRTLMathException         = class(EXRTLException);
  EXRTLExtendInvalidArgument = class(EXRTLMathException);
  EXRTLDivisionByZero        = class(EXRTLMathException);
  EXRTLExpInvalidArgument    = class(EXRTLMathException);
  EXRTLInvalidRadix          = class(EXRTLMathException);
  EXRTLInvalidRadixDigit     = class(EXRTLMathException);
  EXRTLRootInvalidArgument   = class(EXRTLMathException);

const
  BitsPerByte  = 8;
  BitsPerDigit = 32;
  SignBitMask  = $80000000;

type
  TXRTLUMulAddProc = function(const AInteger1, AInteger2, AInteger3: TXRTLInteger; var AResult: TXRTLInteger): Integer;
  TXRTLUDivModProc = procedure(const AInteger1, AInteger2: TXRTLInteger; var QResult, RResult: TXRTLInteger);
  TXRTLInitialRootApproxProc = procedure(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);

function  XRTLAdjustBits(const ABits: Integer): Integer;
function  XRTLLength(const AInteger: TXRTLInteger): Integer;
function  XRTLDataBits(const AInteger: TXRTLInteger): Integer;
procedure XRTLBitPosition(const BitIndex: Integer; var Index, Mask: Integer);
procedure XRTLBitSet(var AInteger: TXRTLInteger; const BitIndex: Integer);
procedure XRTLBitReset(var AInteger: TXRTLInteger; const BitIndex: Integer);
function  XRTLBitGet(const AInteger: TXRTLInteger; const BitIndex: Integer): Integer;
function  XRTLBitGetBool(const AInteger: TXRTLInteger; const BitIndex: Integer): Boolean;
function  XRTLExtend(const AInteger: TXRTLInteger; ADataBits: Integer; Sign: Integer; var AResult: TXRTLInteger): Integer;
function  XRTLZeroExtend(const AInteger: TXRTLInteger; ADataBits: Integer; var AResult: TXRTLInteger): Integer;
function  XRTLSignExtend(const AInteger: TXRTLInteger; ADataBits: Integer; var AResult: TXRTLInteger): Integer;
function  XRTLSignStrip(const AInteger: TXRTLInteger; var AResult: TXRTLInteger; const AMinDataBits: Integer = 0): Integer;
procedure XRTLNot(const AInteger: TXRTLInteger; var AResult: TXRTLInteger);
procedure XRTLOr(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
procedure XRTLAnd(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
procedure XRTLXor(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
{signum -1 AInteger < 0
         0 AInteger = 0
         1 AInteger > 0}
function  XRTLSign(const AInteger: TXRTLInteger): Integer;
{ @abstract(Sets argument to zero.)
  @param(AInteger)
}
procedure XRTLZero(var AInteger: TXRTLInteger);
{ @abstract(Sets argument to one.)
  @param(AInteger)
}
procedure XRTLOne(var AInteger: TXRTLInteger);
{ @abstract(Sets argument to -1.)
  @param(AInteger)
}
procedure XRTLMOne(var AInteger: TXRTLInteger);
{ @abstract(Sets argument to two.)
  @param(AInteger)
}
procedure XRTLTwo(var AInteger: TXRTLInteger);
{ @abstract(Negates argument.)
  @param(AInteger)
  @param(AResult = -AInteger)
  @returns(carry from MSB if any)
}
function  XRTLNeg(const AInteger: TXRTLInteger; var AResult: TXRTLInteger): Integer;
{ @abstract(Returns an absolute value of an argument.)
  @param(AInteger)
  @param(AResult = abs(AInteger))
  @returns(carry from MSB if any)
}
function  XRTLAbs(const AInteger: TXRTLInteger; var AResult: TXRTLInteger): Integer;
{ @abstract(Calculates full sum A+B+C (mod 2^32) and carry value.)
}
procedure XRTLFullSum(const A, B, C: Integer; var Sum, Carry: Integer); stdcall;
function  XRTLAdd(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger): Integer; overload;
function  XRTLAdd(const AInteger1: TXRTLInteger; const AInteger2: Int64; var AResult: TXRTLInteger): Integer; overload;
function  XRTLSub(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger): Integer; overload;
function  XRTLSub(const AInteger1: TXRTLInteger; const AInteger2: Int64; var AResult: TXRTLInteger): Integer; overload;
{compare -1 AInteger1 < AInteger2
          0 AInteger1 = AInteger2
          1 AInteger1 > AInteger2}
function  XRTLCompare(const AInteger1, AInteger2: TXRTLInteger): Integer; overload;
function  XRTLCompare(const AInteger1: TXRTLInteger; const AInteger2: Int64): Integer; overload;
{unsigned multiplication, depends on @see(XRTLUMulAdd)}
function  XRTLUMul(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger): Integer;
{signed multiplication with accumulation, depends on @see(XRTLUMul)}
function  XRTLMulAdd(const AInteger1, AInteger2, AInteger3: TXRTLInteger; var AResult: TXRTLInteger): Integer;
{signed multiplication, depends on @see(XRTLMulAdd)}
function  XRTLMul(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger): Integer;
{signed division, depends on @see(XRTLUDivMod)}
procedure XRTLDivMod(const AInteger1, AInteger2: TXRTLInteger; var QResult, RResult: TXRTLInteger);
procedure XRTLSqr(const AInteger: TXRTLInteger; var AResult: TXRTLInteger);
procedure XRTLSqrt(const AInteger: TXRTLInteger; var AResult: TXRTLInteger);
procedure XRTLRoot(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
procedure XRTLRootApprox(const AInteger1, AInteger2: TXRTLInteger; var ALowApproxResult, AHighApproxResult: TXRTLInteger);
procedure XRTLURootApprox(const AInteger1, AInteger2: TXRTLInteger; var ALowApproxResult, AHighApproxResult: TXRTLInteger);
procedure XRTLExp(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
procedure XRTLExpMod(const AInteger1, AInteger2, AInteger3: TXRTLInteger; var AResult: TXRTLInteger);
{Shift Logicaly Bits Left}
procedure XRTLSLBL(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
{Shift Arithmetically Bits Left}
procedure XRTLSABL(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
{Rotate Cyclic Bits Left}
procedure XRTLRCBL(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
{Shift Logicaly Digits Left}
procedure XRTLSLDL(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
{Shift Arithmetically Digits Left}
procedure XRTLSADL(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
{Rotate Cyclic Digits Left}
procedure XRTLRCDL(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
{Shift Logicaly Bits Right}
procedure XRTLSLBR(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
{Shift Arithmetically Bits Right}
procedure XRTLSABR(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
{Rotate Cyclic Bits Right}
procedure XRTLRCBR(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
{Shift Logicaly Digits Right}
procedure XRTLSLDR(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
{Shift Arithmetically Digits Right}
procedure XRTLSADR(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
{Rotate Cyclic Digits Right}
procedure XRTLRCDR(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
function  XRTLToHex(const AInteger: TXRTLInteger; Digits: Integer = 0): string;
function  XRTLToBin(const AInteger: TXRTLInteger; Digits: Integer = 0): string;
function  XRTLToString(const AInteger: TXRTLInteger; Radix: Integer = 10; Digits: Integer = 0): string;
procedure XRTLFromHex(const Value: string; var AResult: TXRTLInteger);
procedure XRTLFromBin(const Value: string; var AResult: TXRTLInteger);
procedure XRTLFromString(const Value: string; var AResult: TXRTLInteger; Radix: Integer = 10);
procedure XRTLAssign(const AInteger: TXRTLInteger; var AResult: TXRTLInteger); overload;
procedure XRTLAssign(const Value: Integer; var AResult: TXRTLInteger); overload;
procedure XRTLAssign(const Value: Int64; var AResult: TXRTLInteger); overload;
procedure XRTLAppend(const ALow, AHigh: TXRTLInteger; var AResult: TXRTLInteger);
procedure XRTLSplit(const AInteger: TXRTLInteger; var ALow, AHigh: TXRTLInteger; LowDigits: Integer);
function  XRTLGetMSBitIndex(const AInteger: TXRTLInteger): Integer;
procedure XRTLMinMax(const AInteger1, AInteger2: TXRTLInteger; var AMinResult, AMaxResult: TXRTLInteger);
procedure XRTLMin(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger); overload;
procedure XRTLMin(const AInteger1: TXRTLInteger; const AInteger2: Integer; var AResult: TXRTLInteger); overload;
procedure XRTLMax(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger); overload;
procedure XRTLMax(const AInteger1: TXRTLInteger; const AInteger2: Integer; var AResult: TXRTLInteger); overload;
procedure XRTLGCD(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
procedure XRTLSwap(var AInteger1, AInteger2: TXRTLInteger);
procedure XRTLFactorial(const AInteger: TXRTLInteger; var AResult: TXRTLInteger);
procedure XRTLFactorialMod(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);

var
{unsigned multiplication with accumulation}
  XRTLUMulAdd: TXRTLUMulAddProc = nil;
{unsigned division}
  XRTLUDivMod: TXRTLUDivModProc = nil;
{initial root approximation}
  XRTLInitialRootApprox: TXRTLInitialRootApproxProc = nil;

implementation

uses
  xrtl_math_ResourceStrings, xrtl_math_Primitives;

function XRTLAdjustBits(const ABits: Integer): Integer;
begin
  Result:= Max(0, ABits);
  if (ABits mod BitsPerDigit) <> 0 then
    Inc(Result, BitsPerDigit - Abs(ABits) mod BitsPerDigit);
end;

function XRTLLength(const AInteger: TXRTLInteger): Integer;
begin
  Result:= High(AInteger) - Low(AInteger) + 1;
end;

function XRTLDataBits(const AInteger: TXRTLInteger): Integer;
begin
  Result:= XRTLLength(AInteger) * BitsPerDigit;
end;

procedure XRTLBitPosition(const BitIndex: Integer; var Index, Mask: Integer);
begin
  Index:= BitIndex div BitsPerDigit;
  Mask:=  1 shl (BitIndex mod BitsPerDigit);
end;

procedure XRTLBitSet(var AInteger: TXRTLInteger; const BitIndex: Integer);
var
  Index, Mask: Integer;
begin
  XRTLBitPosition(BitIndex, Index, Mask);
  if (Index >= XRTLLength(AInteger)) or (Index < 0) then
    Exit;
  AInteger[Index]:= AInteger[Index] or Mask;
end;

procedure XRTLBitReset(var AInteger: TXRTLInteger; const BitIndex: Integer);
var
  Index, Mask: Integer;
begin
  XRTLBitPosition(BitIndex, Index, Mask);
  if (Index >= XRTLLength(AInteger)) or (Index < 0) then
    Exit;
  AInteger[Index]:= AInteger[Index] and not Mask;
end;

function XRTLBitGet(const AInteger: TXRTLInteger; const BitIndex: Integer): Integer;
var
  Index, Mask: Integer;
begin
  XRTLBitPosition(BitIndex, Index, Mask);
  Result:= 0;
  if (Index >= XRTLLength(AInteger)) or (Index < 0) then
    Exit;
  Result:= AInteger[Index] and Mask;
end;

function XRTLBitGetBool(const AInteger: TXRTLInteger; const BitIndex: Integer): Boolean;
begin
  Result:= XRTLBitGet(AInteger, BitIndex) <> 0;
end;

function XRTLExtend(const AInteger: TXRTLInteger; ADataBits: Integer; Sign: Integer; var AResult: TXRTLInteger): Integer;
var
  ALength, ANewLength, DigitsToFill: Integer;
  FillValue: Byte;
begin
  ADataBits:= XRTLAdjustBits(ADataBits);
  ALength:= XRTLLength(AInteger);
  ANewLength:= ADataBits div BitsPerDigit;
  if (ALength > 0) and (ALength > ANewLength) then
    raise EXRTLExtendInvalidArgument.CreateFmt(SXRTLExtendInvalidArgument, [ALength, ANewLength]);
  if Sign < 0 then
    FillValue:= $FF
  else
    FillValue:= 0;
  DigitsToFill:= ANewLength - ALength;
  XRTLAssign(AInteger, AResult);
  SetLength(AResult, ANewLength);
  FillChar(AResult[ALength], DigitsToFill * SizeOf(Integer), FillValue);
  Result:= XRTLDataBits(AResult);
end;

function XRTLZeroExtend(const AInteger: TXRTLInteger; ADataBits: Integer; var AResult: TXRTLInteger): Integer;
begin
  Result:= XRTLExtend(AInteger, ADataBits, 0, AResult);
end;

function XRTLSignExtend(const AInteger: TXRTLInteger; ADataBits: Integer; var AResult: TXRTLInteger): Integer;
begin
  Result:= XRTLExtend(AInteger, ADataBits, XRTLSign(AInteger), AResult);
end;

function XRTLSignStrip(const AInteger: TXRTLInteger; var AResult: TXRTLInteger; const AMinDataBits: Integer = 0): Integer;
var
  Count, HighIndex, MinIndex: Integer;
begin
  Count:= 0;
  XRTLAssign(AInteger, AResult);
  HighIndex:= High(AResult);
  MinIndex:= XRTLAdjustBits(AMinDataBits) div BitsPerDigit;
  while HighIndex > MinIndex do
  begin
    if ((AResult[HighIndex] < 0) and
        ((AResult[HighIndex - 1] and SignBitMask) = SignBitMask)) or
       ((AResult[HighIndex] = 0) and
        ((AResult[HighIndex - 1] and SignBitMask) = 0)) then
    begin
      Inc(Count);
      Dec(HighIndex);
    end
    else
      Break;
  end;
  if Count > 0 then
    SetLength(AResult, XRTLLength(AResult) - Count);
  Result:= XRTLLength(AResult) * BitsPerDigit;
end;

procedure XRTLNot(const AInteger: TXRTLInteger; var AResult: TXRTLInteger);
var
  I: Integer;
begin
  XRTLAssign(AInteger, AResult);
  if XRTLLength(AResult) = 0 then
  begin
    SetLength(AResult, 1);
    AResult[0]:= 0;
  end;
  for I:= Low(AResult) to High(AResult) do
  begin
    AResult[I]:= not AResult[I];
  end;
end;

type
  TXRTLBinOpProc = function(AInteger1, AInteger2: Integer): Integer;

function BinOpOr(AInteger1, AInteger2: Integer): Integer;
begin
  Result:= AInteger1 or AInteger2;
end;

function BinOpAnd(AInteger1, AInteger2: Integer): Integer;
begin
  Result:= AInteger1 and AInteger2;
end;

function BinOpXor(AInteger1, AInteger2: Integer): Integer;
begin
  Result:= AInteger1 xor AInteger2;
end;

procedure XRTLBinOp(const AInteger1, AInteger2: TXRTLInteger; BinOp: TXRTLBinOpProc; var AResult: TXRTLInteger);
var
  ADataBits: Integer;
  AInt1, AInt2: TXRTLInteger;
  I: Integer;
begin
  ADataBits:= Max(XRTLDataBits(AInteger1), XRTLDataBits(AInteger2));
  XRTLZeroExtend(AInteger1, ADataBits, AInt1);
  XRTLZeroExtend(AInteger2, ADataBits, AInt2);
  SetLength(AResult, XRTLLength(AInt1));
  for I:= Low(AResult) to High(AResult) do
  begin
    AResult[I]:= BinOp(AInt1[I], AInt2[I]);
  end;
end;

procedure XRTLOr(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
begin
  XRTLBinOp(AInteger1, AInteger2, BinOpOr, AResult);
end;

procedure XRTLAnd(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
begin
  XRTLBinOp(AInteger1, AInteger2, BinOpAnd, AResult);
end;

procedure XRTLXor(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
begin
  XRTLBinOp(AInteger1, AInteger2, BinOpXor, AResult);
end;

function XRTLSign(const AInteger: TXRTLInteger): Integer;
var
  AInt: TXRTLInteger;
begin
  XRTLSignStrip(AInteger, AInt);
  Result:= 0;
  if (XRTLLength(AInt) = 0) or ((High(AInt) = 0) and (AInt[High(AInt)] = 0)) then
    Exit;
  if AInt[High(AInt)] < 0 then
    Result:= -1
  else
    Result:= 1;
end;

procedure XRTLZero(var AInteger: TXRTLInteger);
begin
  SetLength(AInteger, 0);
end;

procedure XRTLOne(var AInteger: TXRTLInteger);
begin
  XRTLAssign(1, AInteger);
end;

procedure XRTLMOne(var AInteger: TXRTLInteger);
begin
  XRTLAssign(-1, AInteger);
end;

procedure XRTLTwo(var AInteger: TXRTLInteger);
begin
  XRTLAssign(2, AInteger);
end;

function XRTLNeg(const AInteger: TXRTLInteger; var AResult: TXRTLInteger): Integer;
var
  AInt, AInt1: TXRTLInteger;
begin
  XRTLNot(AInteger, AInt);
  XRTLOne(AInt1);
  Result:= XRTLAdd(AInt, AInt1, AResult);
end;

function XRTLAbs(const AInteger: TXRTLInteger; var AResult: TXRTLInteger): Integer;
begin
  Result:= 0;
  if XRTLSign(AInteger) >= 0 then
    XRTLAssign(AInteger, AResult)
  else
    Result:= XRTLNeg(AInteger, AResult);
end;

procedure XRTLFullSum(const A, B, C: Integer; var Sum, Carry: Integer); stdcall;
asm
      PUSH  EBX
      MOV   EBX,0
      MOV   EAX,A
      ADD   EAX,B
      ADC   EBX,0       // get CF
      ADD   EAX,C
      ADC   EBX,0       // get CF
      MOV   ECX,[Sum]
      MOV   [ECX],EAX
      ADC   EBX,0
      MOV   ECX,[Carry]
      MOV   [ECX],EBX
      POP   EBX
end;

function XRTLAdd(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger): Integer;
var
  I, Carry, ADataBits: Integer;
  AInt1, AInt2: TXRTLInteger;
begin
  ADataBits:= Max(XRTLDataBits(AInteger1), XRTLDataBits(AInteger2));
  XRTLSignExtend(AInteger1, ADataBits, AInt1);
  XRTLSignExtend(AInteger2, ADataBits, AInt2);
  SetLength(AResult, XRTLLength(AInt1));
  Carry:= 0;
  for I:= Low(AResult) to High(AResult) do
  begin
    XRTLFullSum(AInt1[I], AInt2[I], Carry, AResult[I], Carry);
  end;
  Result:= Carry;
end;

function XRTLAdd(const AInteger1: TXRTLInteger; const AInteger2: Int64; var AResult: TXRTLInteger): Integer; overload;
var
  AInt2: TXRTLInteger;
begin
  XRTLAssign(AInteger2, AInt2);
  Result:= XRTLAdd(AInteger1, AInt2, AResult);
end;

function XRTLSub(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger): Integer;
var
  AInt: TXRTLInteger;
begin
  XRTLNeg(AInteger2, AInt);
  Result:= XRTLAdd(AInteger1, AInt, AResult);
end;

function XRTLSub(const AInteger1: TXRTLInteger; const AInteger2: Int64; var AResult: TXRTLInteger): Integer; overload;
var
  AInt2: TXRTLInteger;
begin
  XRTLAssign(AInteger2, AInt2);
  Result:= XRTLSub(AInteger1, AInt2, AResult);
end;

function XRTLCompare(const AInteger1, AInteger2: TXRTLInteger): Integer;
var
  AInt1, AInt2, AResult: TXRTLInteger;
begin
  XRTLSignExtend(AInteger1, XRTLDataBits(AInteger1) + 1, AInt1);
  XRTLSignExtend(AInteger2, XRTLDataBits(AInteger2) + 1, AInt2);
  XRTLSub(AInt1, AInt2, AResult);
  Result:= XRTLSign(AResult);
end;

function XRTLCompare(const AInteger1: TXRTLInteger; const AInteger2: Int64): Integer; overload;
var
  AInt2: TXRTLInteger;
begin
  XRTLAssign(AInteger2, AInt2);
  Result:= XRTLCompare(AInteger1, AInt2);
end;

function XRTLUMul(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger): Integer;
var
  ARes: TXRTLInteger;
begin
  XRTLZero(ARes);
  Result:= XRTLUMulAdd(AInteger1, AInteger2, ARes, AResult);
end;

function XRTLMulAdd(const AInteger1, AInteger2, AInteger3: TXRTLInteger; var AResult: TXRTLInteger): Integer;
var
  AResultSign: Integer;
  AInt1, AInt2, AInt3, ARes: TXRTLInteger;
  ADataBits: Integer;
begin
  AResultSign:= XRTLSign(AInteger1) * XRTLSign(AInteger2);
  XRTLSignExtend(AInteger1, XRTLDataBits(AInteger1) + 1, AInt1);
  XRTLSignExtend(AInteger2, XRTLDataBits(AInteger2) + 1, AInt2);
  XRTLAbs(AInt1, AInt1);
  XRTLAbs(AInt2, AInt2);
  XRTLUMul(AInt1, AInt2, ARes);
  ADataBits:= Max(XRTLDataBits(AInt1), XRTLDataBits(AInt2)) - BitsPerDigit * 2;
  XRTLSignStrip(ARes, AResult, ADataBits);
  if AResultSign < 0 then
    XRTLNeg(AResult, AResult);
  XRTLSignExtend(AInteger3, XRTLDataBits(AResult), AInt3);
  Result:= XRTLAdd(AInt3, AResult, AResult);
end;

function XRTLMul(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger): Integer;
var
  ARes: TXRTLInteger;
begin
  XRTLZero(ARes);
  Result:= XRTLMulAdd(AInteger1, AInteger2, ARes, AResult);
end;

procedure XRTLDivMod(const AInteger1, AInteger2: TXRTLInteger; var QResult, RResult: TXRTLInteger);
var
  AInt1Sign, AInt2Sign: Integer;
  AInt1, AInt2: TXRTLInteger;
begin
  AInt1Sign:= XRTLSign(AInteger1);
  AInt2Sign:= XRTLSign(AInteger2);
  if AInt2Sign = 0 then
    raise EXRTLDivisionByZero.Create(SXRTLDivisionByZero);
  if AInt1Sign = 0 then
  begin
    XRTLZero(QResult);
    XRTLZero(RResult);
    Exit;
  end;
  XRTLSignExtend(AInteger1, XRTLDataBits(AInteger1) + 1, AInt1);
  XRTLSignExtend(AInteger2, XRTLDataBits(AInteger2) + 1, AInt2);
  XRTLAbs(AInt1, AInt1);
  XRTLAbs(AInt2, AInt2);
  XRTLUDivMod(AInt1, AInt2, QResult, RResult);
  if AInt1Sign <> AInt2Sign then
  begin
    XRTLNeg(QResult, QResult);
  end;
  if AInt1Sign < 0 then
    XRTLNeg(RResult, RResult);
end;

procedure XRTLSqr(const AInteger: TXRTLInteger; var AResult: TXRTLInteger);
begin
  XRTLMul(AInteger, AInteger, AResult);
end;

procedure CheckSign(const ASign: Integer; const AInteger: TXRTLInteger);
begin
  if (ASign < 0) and not XRTLBitGetBool(AInteger, 0) then
    raise EXRTLRootInvalidArgument.Create(SXRTLRootInvalidArgument);
  if XRTLSign(AInteger) <= 0 then
    raise EXRTLRootInvalidArgument.Create(SXRTLRootInvalidArgument);
end;

procedure XRTLSqrt(const AInteger: TXRTLInteger; var AResult: TXRTLInteger);
var
  ASign: Integer;
  AInt2, AX, AYN, AYNMOne, AQ, AR, AOne: TXRTLInteger;
begin
  ASign:= XRTLSign(AInteger);
  XRTLTwo(AInt2);
  CheckSign(ASign, AInt2);
  if ASign = 0 then
  begin
    XRTLZero(AResult);
    Exit;
  end;
  XRTLInitialRootApprox(AInteger, AInt2, AYN);
  XRTLAssign(AInteger, AX);
  XRTLOne(AOne);
  repeat
    XRTLAssign(AYN, AYNMOne);
    XRTLDivMod(AX, AYNMOne, AQ, AR);
    XRTLAdd(AQ, AYNMOne, AYN);
    XRTLSABR(AYN, 1, AYN);
    XRTLSub(AYN, AYNMOne, AInt2);
  until (XRTLSign(AInt2) >= 0) and (XRTLCompare(AInt2, AYNMOne) <= 0);
  XRTLMinMax(AYN, AYNMOne, AResult, AYN);
  XRTLSignStrip(AResult, AResult);
end;

procedure XRTLRoot(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
var
  AHighResult: TXRTLInteger;
begin
  XRTLRootApprox(AInteger1, AInteger2, AResult, AHighResult);
end;

procedure XRTLRootApprox(const AInteger1, AInteger2: TXRTLInteger; var ALowApproxResult, AHighApproxResult: TXRTLInteger);
var
  AInt1, AInt2: TXRTLInteger;
  ASign: Integer;
begin
  ASign:= XRTLSign(AInteger1);
  CheckSign(ASign, AInteger2);
  if ASign = 0 then
  begin
    XRTLZero(ALowApproxResult);
    XRTLZero(AHighApproxResult);
    Exit;
  end;
  XRTLSignExtend(AInteger1, XRTLDataBits(AInteger1) + 1, AInt1);
  XRTLSignExtend(AInteger2, XRTLDataBits(AInteger1) + 1, AInt2);
  XRTLAbs(AInt1, AInt1);
  XRTLAbs(AInt2, AInt2);
  XRTLURootApprox(AInt1, AInt2, ALowApproxResult, AHighApproxResult);
  if ASign < 0 then
  begin
    XRTLNeg(ALowApproxResult, ALowApproxResult);
    XRTLNeg(AHighApproxResult, AHighApproxResult);
    XRTLSwap(ALowApproxResult, AHighApproxResult);
  end;
end;

procedure XRTLURootApprox(const AInteger1, AInteger2: TXRTLInteger; var ALowApproxResult, AHighApproxResult: TXRTLInteger);
var
  ASign: Integer;
  AInt2, AX, AYN, AYNMOne, AQ, AR, AOne, AZ, AZMOne, AZC: TXRTLInteger;
begin
  ASign:= XRTLSign(AInteger1);
  if ASign = 0 then
  begin
    XRTLZero(ALowApproxResult);
    XRTLZero(AHighApproxResult);
    Exit;
  end;
  XRTLZeroExtend(AInteger1, XRTLDataBits(AInteger1) + 1, AX);
  XRTLZeroExtend(AInteger2, XRTLDataBits(AInteger1) + 1, AZ);
  XRTLOne(AOne);
  XRTLSub(AZ, 1, AZMOne);
{
  XRTLAssign(AX, AYN);
  XRTLSLBR(AZ, 1, AZC);
  while XRTLSign(AZC) > 0 do
  begin
    XRTLSqrt(AYN, AYN);
    XRTLSLBR(AZC, 1, AZC);
  end;
//  if XRTLBitGetBool(AZ, 0) then
//    XRTLSLBR(AYN, 1, AYN);
}
  XRTLInitialRootApprox(AInteger1, AInteger2, AYN);
  XRTLMax(AYN, AOne, AYN);
  repeat
    XRTLAssign(AYN, AYNMOne);
    XRTLAssign(AZMOne, AZC);
    XRTLAssign(AX, AQ);
//  AYN:= AYNMOne^AZMOne;
    XRTLExp(AYNMOne, AZMOne, AYN);
//  AQ:= AX div AYN;
    XRTLUDivMod(AX, AYN, AQ, AR);
//  AYN:= AYNMOne * AZMOne + AQ
    XRTLUMulAdd(AYNMOne, AZMOne, AQ, AYN);
//  AYN:= AYN div AZ
    XRTLUDivMod(AYN, AZ, AYN, AR);
    XRTLSub(AYN, AYNMOne, AInt2);
  until (XRTLSign(AInt2) >= 0) and (XRTLCompare(AInt2, AOne) <= 0);
  XRTLMinMax(AYN, AYNMOne, ALowApproxResult, AHighApproxResult);
  XRTLSignStrip(ALowApproxResult, ALowApproxResult);
  XRTLSignStrip(AHighApproxResult, AHighApproxResult);
end;

procedure XRTLExp(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
var
  Sign: Integer;
  AInt1, AInt2, AInt3, ARes, AQ: TXRTLInteger;
begin
  Sign:= XRTLSign(AInteger2);
  if Sign < 0 then
    raise EXRTLExpInvalidArgument.Create(SXRTLExpInvalidArgument);
  if Sign = 0 then
  begin
    XRTLOne(AResult);
    Exit;
  end;
  XRTLAssign(AInteger1, AInt1);
  XRTLAssign(AInteger2, AInt2);
// if AInt mod 2 = 1
  if XRTLBitGetBool(AInt2, 0) then
  begin
    XRTLOne(AInt3);
    XRTLSub(AInt2, AInt3, AInt3);
    XRTLExp(AInt1, AInt3, ARes);
    XRTLMul(ARes, AInt1, ARes);
  end
  else
  begin
    XRTLTwo(AInt3);
    XRTLDivMod(AInt2, AInt3, AInt3, AQ);
    XRTLExp(AInt1, AInt3, ARes);
    XRTLSqr(ARes, ARes);
  end;
  XRTLAssign(ARes, AResult);
end;

procedure XRTLExpMod(const AInteger1, AInteger2, AInteger3: TXRTLInteger; var AResult: TXRTLInteger);
var
  Sign: Integer;
  AInt2, ARes, AQ, AR: TXRTLInteger;
begin
  Sign:= XRTLSign(AInteger2);
  if Sign < 0 then
    raise EXRTLExpInvalidArgument.Create(SXRTLExpInvalidArgument);
  if Sign = 0 then
  begin
    XRTLOne(AResult);
    Exit;
  end;
// if AInteger2 mod 2 = 1
  if XRTLBitGetBool(AInteger2, 0) then
  begin
    XRTLOne(AInt2);
    XRTLSub(AInteger2, AInt2, AInt2);
    XRTLExp(AInteger1, AInt2, ARes);
    XRTLMul(AInteger1, ARes, ARes);
    XRTLDivMod(ARes, AInteger3, AQ, ARes);
  end
  else
  begin
    XRTLTwo(AInt2);
    XRTLDivMod(AInteger2, AInt2, AInt2, AR);
    XRTLExp(AInteger1, AInt2, ARes);
    XRTLSqr(ARes, ARes);
    XRTLDivMod(ARes, AInteger3, AQ, ARes);
  end;
  XRTLAssign(ARes, AResult);
end;

procedure XRTLGenerateMasksR(Shift: Integer; var LMask, HMask: Cardinal);
begin
  Shift:= Min(BitsPerDigit, Abs(Shift));
  LMask:= (Int64(1) shl Shift) - 1;
  HMask:= $FFFFFFFF xor LMask;
end;

procedure XRTLSSR(Value, Shift: Integer; var L, H: Integer);
var
  LMask, HMask: Cardinal;
begin
  Shift:= Min(BitsPerDigit, Abs(Shift));
  XRTLGenerateMasksR(Shift, LMask, HMask);
  L:= (Value and LMask) shl (BitsPerDigit - Shift);
  H:= (Value and HMask) shr Shift;
end;

procedure XRTLGenerateMasksL(Shift: Integer; var LMask, HMask: Cardinal);
begin
  Shift:= Min(BitsPerDigit, Abs(Shift));
  LMask:= (Int64(1) shl (BitsPerDigit - Shift)) - 1;
  HMask:= $FFFFFFFF xor LMask;
end;

procedure XRTLSSL(Value, Shift: Integer; var L, H: Integer);
var
  LMask, HMask: Cardinal;
begin
  Shift:= Min(BitsPerDigit, Abs(Shift));
  XRTLGenerateMasksL(Shift, LMask, HMask);
  L:= (Value and LMask) shl Shift;
  H:= (Value and HMask) shr (BitsPerDigit - Shift);
end;

{Shift Logicaly Bits Left}
procedure XRTLSLBL(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
var
  ABitCount, ADigitCount: Integer;
  ARes: TXRTLInteger;
  L, H, H1, I: Integer;
begin
  ABitCount:=   Max(BitCount, 0) mod BitsPerDigit;
  ADigitCount:= Max(BitCount, 0) div BitsPerDigit;
  XRTLSLDL(AInteger, ADigitCount, ARes);
  if ABitCount > 0 then
  begin
    H:= 0;
    for I:= Low(ARes) to High(ARes) do
    begin
      XRTLSSL(ARes[I], ABitCount, L, H1);
      ARes[I]:= L + H;
      H:= H1;
    end;
    if H <> 0 then
    begin
      SetLength(ARes, XRTLLength(ARes) + 1);
      ARes[High(ARes)]:= H;
    end;
  end;
  XRTLAssign(ARes, AResult);
end;

{Shift Arithmetically Bits Left}
procedure XRTLSABL(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
var
  ABitCount, ADigitCount: Integer;
  ARes: TXRTLInteger;
  L, H, H1, I: Integer;
begin
  ABitCount:=   Max(BitCount, 0) mod BitsPerDigit;
  ADigitCount:= Max(BitCount, 0) div BitsPerDigit;
  XRTLSLDL(AInteger, ADigitCount, ARes);
  if ABitCount > 0 then
  begin
    XRTLSignExtend(ARes, Max(XRTLGetMSBitIndex(ARes) + ABitCount + 2, XRTLDataBits(ARes)), ARes);
    H:= 0;
    for I:= Low(ARes) to High(ARes) do
    begin
      XRTLSSL(ARes[I], ABitCount, L, H1);
      ARes[I]:= L or H;
      H:= H1;
    end;
  end;
  XRTLAssign(ARes, AResult);
end;

{Rotate Cyclic Bits Left}
procedure XRTLRCBL(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
var
  ABitCount, ADigitCount: Integer;
  ARes: TXRTLInteger;
  L, H, H1, I: Integer;
begin
  ABitCount:=   Max(BitCount, 0) mod BitsPerDigit;
  ADigitCount:= Max(BitCount, 0) div BitsPerDigit;
  XRTLRCDL(AInteger, ADigitCount, ARes);
  if ABitCount > 0 then
  begin
    H:= 0;
    for I:= Low(ARes) to High(ARes) do
    begin
      XRTLSSL(ARes[I], ABitCount, L, H1);
      ARes[I]:= L or H;
      H:= H1;
    end;
    ARes[0]:= ARes[0] or H;
  end;
  XRTLAssign(ARes, AResult);
end;

{Shift Logicaly Digits Left}
procedure XRTLSLDL(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
var
  ARes: TXRTLInteger;
begin
  XRTLZero(ARes);
  XRTLZeroExtend(ARes, Max(DigitCount, 0) * BitsPerDigit, ARes);
  XRTLAppend(ARes, AInteger, AResult);
end;

{Shift Arithmetically Digits Left}
procedure XRTLSADL(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
var
  ARes: TXRTLInteger;
begin
  XRTLZero(ARes);
  XRTLExtend(ARes, Max(DigitCount, 0) * BitsPerDigit, XRTLSign(AInteger), ARes);
  XRTLAppend(ARes, AInteger, AResult);
end;

{Rotate Cyclic Digits Left}
procedure XRTLRCDL(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
var
  ALength, AIndex, I: Integer;
  AI: TXRTLInteger;
begin
  XRTLAssign(AInteger, AI);
  ALength:= XRTLLength(AInteger);
  SetLength(AResult, ALength);
  for I:= 0 to ALength - 1 do
  begin
    AIndex:= (I + DigitCount + ALength) mod ALength;
    AResult[AIndex]:= AI[I];
  end;
end;

{Shift Logicaly Bits Right}
procedure XRTLSLBR(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
var
  ABitCount, ADigitCount: Integer;
  ARes: TXRTLInteger;
  L, H, H1, I: Integer;
begin
  ABitCount:=   Max(BitCount, 0) mod BitsPerDigit;
  ADigitCount:= Max(BitCount, 0) div BitsPerDigit;
  XRTLSLDR(AInteger, ADigitCount, ARes);
  if ABitCount > 0 then
  begin
    H:= 0;
    for I:= High(ARes) downto Low(ARes) do
    begin
      XRTLSSR(ARes[I], ABitCount, L, H1);
      ARes[I]:= H1 or H;
      H:= L;
    end;
  end;
  XRTLAssign(ARes, AResult);
end;

{Shift Arithmetically Bits Right}
procedure XRTLSABR(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
var
  ABitCount, ADigitCount: Integer;
  ARes: TXRTLInteger;
  L, H, H1, I: Integer;
begin
  ABitCount:=   Max(BitCount, 0) mod BitsPerDigit;
  ADigitCount:= Max(BitCount, 0) div BitsPerDigit;
  XRTLSADR(AInteger, ADigitCount, ARes);
  if ABitCount > 0 then
  begin
    XRTLSSR(Min(XRTLSign(ARes), 0), ABitCount, L, H1);
    H:= L;
    for I:= High(ARes) downto Low(ARes) do
    begin
      XRTLSSR(ARes[I], ABitCount, L, H1);
      ARes[I]:= H1 or H;
      H:= L;
    end;
  end;
  XRTLAssign(ARes, AResult);
end;

{Rotate Cyclic Bits Right}
procedure XRTLRCBR(const AInteger: TXRTLInteger; const BitCount: Integer; var AResult: TXRTLInteger);
var
  ABitCount, ADigitCount: Integer;
  ARes: TXRTLInteger;
  L, H, H1, I: Integer;
begin
  ABitCount:=   Max(BitCount, 0) mod BitsPerDigit;
  ADigitCount:= Max(BitCount, 0) div BitsPerDigit;
  XRTLRCDR(AInteger, ADigitCount, ARes);
  if ABitCount > 0 then
  begin
    H:= 0;
    for I:= High(ARes) downto Low(ARes) do
    begin
      XRTLSSR(ARes[I], ABitCount, L, H1);
      ARes[I]:= H1 or H;
      H:= L;
    end;
    ARes[High(ARes)]:= ARes[High(ARes)] or H;
  end;
  XRTLAssign(ARes, AResult);
end;

{Shift Logicaly Digits Right}
procedure XRTLSLDR(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
var
  ALength, ADigits: Integer;
  ARes: TXRTLInteger;
begin
  ALength:= XRTLLength(AInteger);
  ADigits:= Min(Max(DigitCount, 0), ALength);
  XRTLAssign(Copy(AInteger, ADigits, ALength - ADigits), ARes);
  XRTLZeroExtend(ARes, XRTLDataBits(AInteger), AResult);
end;

{Shift Arithmetically Digits Right}
procedure XRTLSADR(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
var
  ALength, ADigits: Integer;
  ARes: TXRTLInteger;
begin
  ALength:= XRTLLength(AInteger);
  ADigits:= Min(Max(DigitCount, 0), ALength);
  XRTLAssign(Copy(AInteger, ADigits, ALength - ADigits), ARes);
  XRTLSignExtend(ARes, XRTLDataBits(AInteger), AResult);
end;

{Rotate Cyclic Digits Right}
procedure XRTLRCDR(const AInteger: TXRTLInteger; const DigitCount: Integer; var AResult: TXRTLInteger);
var
  ALength, AIndex, I: Integer;
  AI: TXRTLInteger;
begin
  XRTLAssign(AInteger, AI);
  ALength:= XRTLLength(AInteger);
  SetLength(AResult, ALength);
  for I:= 0 to ALength - 1 do
  begin
    AIndex:= (I + DigitCount + ALength) mod ALength;
    AResult[I]:= AI[AIndex];
  end;
end;

function XRTLToHex(const AInteger: TXRTLInteger; Digits: Integer = 0): string;
var
  ADigits, I: Integer;
begin
  Result:= '';
// get the number of digits from FDataBits
// every hexadecimal digit occupies 4 bits
  ADigits:= XRTLDataBits(AInteger) div 4;
  Digits:= Max(Max(Digits, 8), ADigits);
  for I:= Low(AInteger) to High(AInteger) do
  begin
    Result:= IntToHex(AInteger[I], 8) + Result;
  end;
  Result:= StringOfChar('0', Digits - ADigits) + Result;
end;

function IntToBin(Value: Cardinal): string;
var
  I: Integer;
begin
  SetLength(Result, 32);
  for I:= 1 to 32 do
  begin
    if ((Value shl (I - 1)) shr 31) = 0 then
      Result[I]:= '0'  {do not localize}
    else
      Result[I]:= '1'; {do not localize}
  end;
end;

function XRTLToBin(const AInteger: TXRTLInteger; Digits: Integer = 0): string;
var
  ADigits, I: Integer;
begin
  Result:= '';
// get the number of digits from FDataBits
  ADigits:= XRTLDataBits(AInteger);
  Digits:= Max(Max(Digits, 32), ADigits);
  for I:= Low(AInteger) to High(AInteger) do
    Result:= IntToBin(AInteger[I]) + Result;
  Result:= StringOfChar('0', Digits - ADigits) + Result;
end;

const
  RadixDigits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

procedure CheckRadix(const Radix: Integer);
begin
  if not (Radix in [2 .. 36]) then
    raise EXRTLInvalidRadix.CreateFmt(SXRTLInvalidRadix, [Radix]);
end;

function XRTLToString(const AInteger: TXRTLInteger; Radix: Integer = 10; Digits: Integer = 0): string;
var
  AD, AQ, AR: TXRTLInteger;
  ASign: Integer;
begin
  CheckRadix(Radix);
  if Radix = 2 then
  begin
    Result:= XRTLToBin(AInteger, Digits);
    Exit;
  end;
  if Radix = 16 then
  begin
    Result:= XRTLToHex(AInteger, Digits);
    Exit;
  end;
  XRTLAssign(Radix, AD);
  ASign:= XRTLSign(AInteger);
  XRTLAbs(AInteger, AQ);
  Result:= '';
  while XRTLSign(AQ) > 0 do
  begin
    XRTLDivMod(AQ, AD, AQ, AR);
    Result:= RadixDigits[AR[0] + 1] + Result;
  end;
  Result:= StringOfChar('0', Max(0, Digits - Length(Result))) + Result;
  if Result = '' then
    Result:= '0';
  if ASign < 0 then
    Result:= '-' + Result;
end;

procedure CheckDigits(const Value: string; const Radix: Integer);
var
  Digit, I: Integer;
  SValue: string;
begin
  SValue:= AnsiUpperCase(Value);
  for I:= 1 to Length(SValue) do
  begin
    Digit:= Pos(SValue[I], RadixDigits) - 1;
    if (Digit < 0) or (Digit >= Radix) then
      raise EXRTLInvalidRadixDigit.CreateFmt(SXRTLInvalidRadixDigit, [SValue[I], Radix]);
  end;
end;

procedure XRTLFromHex(const Value: string; var AResult: TXRTLInteger);
begin
  XRTLFromString(Value, AResult, 16);
end;

procedure XRTLFromBin(const Value: string; var AResult: TXRTLInteger);
begin
  XRTLFromString(Value, AResult, 2);
end;

procedure XRTLFromString(const Value: string; var AResult: TXRTLInteger; Radix: Integer = 10);
var
  ARMul, ADigit: TXRTLInteger;
  SValue: string;
  ASign, Digit: Integer;
begin
  CheckRadix(Radix);
{
  if Radix = 2 then
  begin
    XRTLFromBin(Value, AResult);
    Exit;
  end;
  if Radix = 16 then
  begin
    XRTLFromHex(Value, AResult);
    Exit;
  end;
}
  SValue:= AnsiUpperCase(Value);
  ASign:= 1;
  if (Length(SValue) > 0) and (SValue[1] in ['-', '+']) then
  begin
    if SValue[1] = '-' then
      ASign:= -1;
    Delete(SValue, 1, 1);
  end;
  CheckDigits(SValue, Radix);
  XRTLZero(AResult);
  XRTLAssign(Radix, ARMul);
  while SValue <> '' do
  begin
    Digit:= Pos(SValue[1], RadixDigits) - 1;
    XRTLAssign(Digit, ADigit);
    XRTLMulAdd(AResult, ARMul, ADigit, AResult);
    Delete(SValue, 1, 1);
  end;
  if ASign < 0 then
    XRTLNeg(AResult, AResult);
end;

procedure XRTLAssign(const AInteger: TXRTLInteger; var AResult: TXRTLInteger);
begin
  if XRTLLength(AInteger) = 0 then
    XRTLZero(AResult)
  else
    AResult:= Copy(AInteger);
end;

procedure XRTLAssign(const Value: Integer; var AResult: TXRTLInteger); overload;
begin
  if Value <> 0 then
  begin
    SetLength(AResult, 1);
    AResult[0]:= Value;
  end
  else
    XRTLZero(AResult);
end;

procedure XRTLAssign(const Value: Int64; var AResult: TXRTLInteger); overload;
begin
  if Value <> 0 then
  begin
    SetLength(AResult, 2);
    Move(Value, AResult[0], SizeOf(Value));
  end
  else
    XRTLZero(AResult);
end;

procedure XRTLAppend(const ALow, AHigh: TXRTLInteger; var AResult: TXRTLInteger);
var
  I, ALength, ALowLength: Integer;
  ARes: TXRTLInteger;
begin
  ALength:= XRTLLength(ALow) + XRTLLength(AHigh);
  ALowLength:= XRTLLength(ALow);
  SetLength(ARes, ALength);
  for I:= 0 to ALowLength - 1 do
    ARes[I]:= ALow[I];
  for I:= ALowLength to ALength - 1 do
    ARes[I]:= AHigh[I - ALowLength];
  XRTLAssign(ARes, AResult);
end;

procedure XRTLSplit(const AInteger: TXRTLInteger; var ALow, AHigh: TXRTLInteger; LowDigits: Integer);
var
  ALength: Integer;
  AI: TXRTLInteger;
begin
  ALength:= XRTLLength(AInteger);
  LowDigits:= Min(LowDigits, ALength);
  XRTLAssign(AInteger, AI);
  XRTLAssign(Copy(AI, 0, LowDigits), ALow);
  XRTLAssign(Copy(AI, LowDigits, ALength - LowDigits), AHigh);
end;

function XRTLGetMSBitIndex(const AInteger: TXRTLInteger): Integer;
var
  I: Integer;
  AI: TXRTLInteger;
begin
  XRTLSignExtend(AInteger, XRTLDataBits(AInteger) + 1, AI);
  XRTLAbs(AI, AI);
  I:= XRTLDataBits(AI) - 1;
  Result:= -1;
  while I >= 0 do
  begin
    if XRTLBitGetBool(AI, I) then
    begin
      Result:= I;
      Break;
    end;
    Dec(I);
  end;
end;

procedure XRTLMinMax(const AInteger1, AInteger2: TXRTLInteger; var AMinResult, AMaxResult: TXRTLInteger);
var
  AInt1, AInt2: TXRTLInteger;
begin
  XRTLAssign(AInteger1, AInt1);
  XRTLAssign(AInteger2, AInt2);
  if XRTLCompare(AInt1, AInt2) < 0 then
  begin
    XRTLAssign(AInt1, AMinResult);
    XRTLAssign(AInt2, AMaxResult);
  end
  else
  begin
    XRTLAssign(AInt2, AMinResult);
    XRTLAssign(AInt1, AMaxResult);
  end;
end;

procedure XRTLMin(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
var
  AInt: TXRTLInteger;
begin
  XRTLMinMax(AInteger1, AInteger2, AResult, AInt);
end;

procedure XRTLMin(const AInteger1: TXRTLInteger; const AInteger2: Integer; var AResult: TXRTLInteger);
var
  AInt2: TXRTLInteger;
begin
  XRTLAssign(AInteger2, AInt2);
  XRTLMin(AInteger1, AInt2, AResult);
end;

procedure XRTLMax(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
var
  AInt: TXRTLInteger;
begin
  XRTLMinMax(AInteger1, AInteger2, AInt, AResult);
end;

procedure XRTLMax(const AInteger1: TXRTLInteger; const AInteger2: Integer; var AResult: TXRTLInteger);
var
  AInt2: TXRTLInteger;
begin
  XRTLAssign(AInteger2, AInt2);
  XRTLMax(AInteger1, AInt2, AResult);
end;

procedure XRTLGCD(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
var
  AXInt, AYInt, AGInt, ATInt: TXRTLInteger;
  ASign: Integer;
begin
  XRTLMinMax(AInteger1, AInteger2, AYInt, AXInt);
  if XRTLSign(AYInt) <= 0 then
    raise Exception.Create('Invalid GCD argument');
  XRTLOne(AGInt);
  while (not XRTLBitGetBool(AXInt, 0)) and (not XRTLBitGetBool(AYInt, 0)) do
  begin
    XRTLSABR(AXInt, 1, AXInt);
    XRTLSABR(AYInt, 1, AYInt);
    XRTLSABL(AGInt, 1, AGInt);
  end;
  while XRTLSign(AXInt) > 0 do
  begin
    while not XRTLBitGetBool(AXInt, 0) do
    begin
      XRTLSABR(AXInt, 1, AXInt);
    end;
    while not XRTLBitGetBool(AYInt, 0) do
    begin
      XRTLSABR(AYInt, 1, AYInt);
    end;
    XRTLSub(AXInt, AYInt, ATInt);
    ASign:= XRTLSign(ATInt);
    XRTLAbs(ATInt, ATInt);
    XRTLSABR(ATInt, 1, ATInt);
    if ASign >= 0 then
      XRTLAssign(ATInt, AXInt)
    else
      XRTLAssign(ATInt, AYInt);
  end;
  XRTLMul(AGInt, AYInt, AResult);
end;

procedure XRTLSwap(var AInteger1, AInteger2: TXRTLInteger);
var
  AInt: TXRTLInteger;
begin
  XRTLAssign(AInteger1, AInt);
  XRTLAssign(AInteger2, AInteger1);
  XRTLAssign(AInt, AInteger2);
end;

procedure XRTLFactorial(const AInteger: TXRTLInteger; var AResult: TXRTLInteger);
var
  AInt1, ARes: TXRTLInteger;
begin
  if XRTLSign(AInteger) < 0 then
    raise EXRTLException.Create('Bad argument to Factorial');
  XRTLAssign(AInteger, AInt1);
  XRTLAssign(1, ARes);
  while XRTLSign(AInt1) > 0 do
  begin
    XRTLMul(ARes, AInt1, ARes);
    XRTLSub(AInt1, 1, AInt1)
  end;
  XRTLSignStrip(ARes, AResult);
end;

procedure XRTLFactorialMod(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
var
  AInt1, AQ, ARes: TXRTLInteger;
begin
  if XRTLSign(AInteger1) < 0 then
    raise EXRTLException.Create('Bad argument to FactorialMod');
  XRTLAssign(AInteger1, AInt1);
  XRTLAssign(1, ARes);
  while XRTLSign(AInt1) > 0 do
  begin
    XRTLMul(ARes, AInt1, ARes);
    XRTLUDivMod(ARes, AInteger2, AQ, ARes);
    XRTLMax(ARes, 1, ARes);    
    XRTLSub(AInt1, 1, AInt1)
  end;
  XRTLSignStrip(ARes, AResult);
end;

initialization
begin
  XRTLUMulAdd:= XRTLUMulAdd2;
  XRTLUDivMod:= XRTLUDivMod1;
  XRTLInitialRootApprox:= XRTLInitialRootApprox1;
end;

end.
