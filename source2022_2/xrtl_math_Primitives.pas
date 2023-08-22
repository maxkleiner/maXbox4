{ @abstract(Primitive operations implementation.)
}
unit xrtl_math_Primitives;

{$INCLUDE xrtl.inc}

interface

uses
  xrtl_util_CPUUtils,
  xrtl_math_Integer;

{ @abstract(Unsigned multiplication with accumulation - school (column) multiplication method used.)
  @param(AInteger1 multiplicand)
  @param(AInteger2 multiplier)
  @param(AInteger3 addend)
  @param(AResult = AInteger1 * AInteger2 + AInteger3)
  @returns(carry from MSB if any)
}
function  XRTLUMulAdd1(const AInteger1, AInteger2, AInteger3: TXRTLInteger; var AResult: TXRTLInteger): Integer;
{ @abstract(Unsigned multiplication with accumulation - shift and add method used.)
  @param(AInteger1 multiplicand)
  @param(AInteger2 multiplier)
  @param(AInteger3 addend)
  @param(AResult = AInteger1 * AInteger2 + AInteger3)
  @returns(carry from MSB if any)
}
function  XRTLUMulAdd2(const AInteger1, AInteger2, AInteger3: TXRTLInteger; var AResult: TXRTLInteger): Integer;
{ @abstract(Unsigned division - shift and subtract method used.)
  @param(AInteger1 dividend)
  @param(AInteger2 divisor)
  @param(QResult = Quotient(AInteger1 / AInteger2))
  @param(RResult = Remainder(AInteger1 / AInteger2))
}
procedure XRTLUDivMod1(const AInteger1, AInteger2: TXRTLInteger; var QResult, RResult: TXRTLInteger);
{ @abstract(Initial root approximation.)
  @param(AInteger1)
  @param(AInteger2)
  @param(AResult >= AInteger1 ^ (1 / AInteger2), initial approximation.)
}
procedure XRTLInitialRootApprox1(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);

implementation

uses
  xrtl_math_ResourceStrings;

function XRTLUMulAdd1(const AInteger1, AInteger2, AInteger3: TXRTLInteger; var AResult: TXRTLInteger): Integer;
var
  I, J: Integer;
  L, H, Carry: Integer;
  ARes: TXRTLInteger;
begin
  XRTLZeroExtend(AInteger3, XRTLDataBits(AInteger1) + XRTLDataBits(AInteger2) + BitsPerDigit, ARes);
  for I:= Low(AInteger1) to High(AInteger1) do
  begin
    for J:= Low(AInteger2) to High(AInteger2) do
    begin
      Carry:= 0;
      XRTLUMul64(AInteger1[I], AInteger2[J], L, H);
      XRTLFullSum(ARes[I + J],     L, Carry, ARes[I + J],     Carry);
      XRTLFullSum(ARes[I + J + 1], H, Carry, ARes[I + J + 1], Carry);
      XRTLFullSum(ARes[I + J + 2], 0, Carry, ARes[I + J + 2], Carry);
    end;
  end;
  Result:= Carry;
  XRTLAssign(ARes, AResult);
end;

function XRTLUMulAdd2(const AInteger1, AInteger2, AInteger3: TXRTLInteger; var AResult: TXRTLInteger): Integer;
var
  I, Carry, BitIndex, ResultBits: Integer;
  AInt1, AInt2, ARes: TXRTLInteger;
begin
  ResultBits:= XRTLDataBits(AInteger1) + XRTLDataBits(AInteger2) + BitsPerDigit;
  XRTLZeroExtend(AInteger1, ResultBits, AInt1);
  XRTLZeroExtend(AInteger2, ResultBits, AInt2);
  XRTLZeroExtend(AInteger3, ResultBits, ARes);
  XRTLMinMax(AInt1, AInt2, AInt1, AInt2);
  BitIndex:= XRTLGetMSBitIndex(AInt1);
  Carry:= 0;
  for I:= 0 to BitIndex do
  begin
    if XRTLBitGetBool(AInt1, I) then
      Carry:= XRTLAdd(ARes, AInt2, ARes);
    XRTLSLBL(AInt2, 1, AInt2);
  end;
  Result:= Carry;
  XRTLAssign(ARes, AResult);
end;

procedure XRTLUDivMod1(const AInteger1, AInteger2: TXRTLInteger; var QResult, RResult: TXRTLInteger);
var
  D1, D2, DD: Integer;
  AInt1, AInt2, AInt3: TXRTLInteger;
  QR: TXRTLInteger;
begin
  if XRTLSign(AInteger2) = 0 then
    raise EXRTLDivisionByZero.Create(SXRTLDivisionByZero);
  XRTLZero(QR);
  D1:= XRTLGetMSBitIndex(AInteger1) + 1;
  XRTLZeroExtend(QR, D1, QR);
  D2:= XRTLGetMSBitIndex(AInteger2) + 1;
  DD:= D1 - D2;
  XRTLSLBL(AInteger2, DD, AInt2);
  XRTLZeroExtend(AInteger1, XRTLDataBits(AInteger1) + 1, AInt1);
  XRTLZeroExtend(AInt2, XRTLDataBits(AInt2) + 1, AInt2);
  while DD >= 0 do
  begin
    XRTLSub(AInt1, AInt2, AInt3);
    if XRTLSign(AInt3) >= 0 then
    begin
      XRTLBitSet(QR, DD);
      XRTLAssign(AInt3, AInt1);
    end;
    XRTLSABR(AInt2, 1, AInt2);
    Dec(DD);
  end;
  XRTLAssign(QR, QResult);
  XRTLSignStrip(AInt1, RResult, D2);
end;

procedure XRTLInitialRootApprox1(const AInteger1, AInteger2: TXRTLInteger; var AResult: TXRTLInteger);
var
  N: Cardinal;
  AR: TXRTLInteger;
begin
  N:= XRTLGetMSBitIndex(AInteger1);
  XRTLAssign(N, AResult);
  XRTLDivMod(AResult, AInteger2, AResult, AR);
// a little hack - assuming a bit number can't be larger than 2^32
  if Length(AResult) > 0 then
    N:= AResult[0]
  else
    N:= 0;
  XRTLZero(AResult);
  XRTLZeroExtend(AResult, N + 2, AResult);
  XRTLBitSet(AResult, N + 1);
end;

end.
