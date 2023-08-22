{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{ Copyright and license exceptions noted in source      }
{                                                       }
{*******************************************************}

unit Math;

{ This unit contains high-performance arithmetic, trigonometric, logarithmic,
  statistical, financial calculation and FPU routines which supplement the math
  routines that are part of the Delphi language or System unit.

  References:
  1) P.J. Plauger, "The Standard C Library", Prentice-Hall, 1992, Ch. 7.
  2) W.J. Cody, Jr., and W. Waite, "Software Manual For the Elementary
     Functions", Prentice-Hall, 1980.
  3) Namir Shammas, "C/C++ Mathematical Algorithms for Scientists and Engineers",
     McGraw-Hill, 1995, Ch 8.
  4) H.T. Lau, "A Numerical Library in C for Scientists and Engineers",
     CRC Press, 1994, Ch. 6.
  5) "Pentium(tm) Processor User's Manual, Volume 3: Architecture
     and Programming Manual", Intel, 1994

  Some of the functions, concepts or constants in this unit were provided by
  Earl F. Glynn (www.efg2.com) and Ray Lischner (www.tempest-sw.com)

  All angle parameters and results of trig functions are in radians.

  Most of the following trig and log routines map directly to Intel 80387 FPU
  floating point machine instructions.  Input domains, output ranges, and
  error handling are determined largely by the FPU hardware.

  Routines coded in assembler favor the Pentium FPU pipeline architecture.
}

{$N+,S-}

interface

uses SysUtils, Types;

{ To handle 'Conversion may lose significant digits' on default parameters }
(*$HPPEMIT '#pragma option -w-8071'*)


const   { Ranges of the IEEE floating point types, including denormals }

(*$HPPEMIT 'namespace Math {'*)

  MinSingle   =  1.5e-45;
  (*$EXTERNALSYM MinSingle*)
  (*$HPPEMIT 'extern const Extended MinSingle /*= 1.500000E-45*/;'*)
  MaxSingle   =  3.4e+38;
  (*$EXTERNALSYM MaxSingle*)
  (*$HPPEMIT 'extern const Extended MaxSingle /*= 3.400000E+38*/;'*)
  MinDouble   =  5.0e-324;
  (*$EXTERNALSYM MinDouble*)
  (*$HPPEMIT 'extern const Extended MinDouble /*= 5.000000E-324*/;'*)
  MaxDouble   =  1.7e+308;
  (*$EXTERNALSYM MaxDouble*)
  (*$HPPEMIT 'extern const Extended MaxDouble /*= 1.700000E+308*/;'*)
  MinExtended =  3.4e-4932;
  (*$EXTERNALSYM MinExtended*)
  (*$HPPEMIT 'extern const Extended MinExtended /*= 3.400000E-4932*/;'*)
  MaxExtended =  1.1e+4932;
  (*$EXTERNALSYM MaxExtended*)
  (*$HPPEMIT 'extern const Extended MaxExtended /*= 1.100000E+4932*/;'*)
  MinComp     = -9.223372036854775807e+18;
  (*$EXTERNALSYM MinComp*)
  (*$HPPEMIT 'extern const Extended MinComp /*= -9.223372E+18*/;'*)
  MaxComp     =  9.223372036854775807e+18;
  (*$EXTERNALSYM MaxComp*)
  (*$HPPEMIT 'extern const Extended MaxComp /*= 9.223372E+18*/;'*)

  { The following constants should not be used for comparison, only
    assignments. For comparison please use the IsNan and IsInfinity functions
    provided below. }
  NaN         =  0.0 / 0.0;
  (*$EXTERNALSYM NaN*)
  (*$HPPEMIT 'extern const Extended NaN /*= 0.0 / 0.0*/;'*)
  Infinity    =  1.0 / 0.0;
  (*$EXTERNALSYM Infinity*)
  (*$HPPEMIT 'extern const Extended Infinity /*= 1.0 / 0.0*/;'*)
  NegInfinity = -1.0 / 0.0;
  (*$EXTERNALSYM NegInfinity*)
  (*$HPPEMIT 'extern const Extended NegInfinity /*= -1.0 / 0.0*/;'*)

(*$HPPEMIT '} // namespace Math '*)

{ Trigonometric functions }
{ IN: |X| <= 1  OUT: [0..PI] radians }
function ArcCos(const X : Extended) : Extended; overload;
function ArcCos(const X : Double) : Double; overload;
function ArcCos(const X : Single) : Single; overload;
{ IN: |X| <= 1  OUT: [-PI/2..PI/2] radians }
function ArcSin(const X : Extended) : Extended; overload;
function ArcSin(const X : Double) : Double; overload;
function ArcSin(const X : Single) : Single; overload;

{ ArcTan2 calculates ArcTan(Y/X), and returns an angle in the correct quadrant.
  IN: |Y| < 2^64, |X| < 2^64, X <> 0   OUT: [-PI..PI] radians }
function ArcTan2(const Y, X: Extended): Extended;

{ SinCos is 2x faster than calling Sin and Cos separately for the same angle }
procedure SinCos(const Theta: Extended; var Sin, Cos: Extended) register;
function Tan(const X: Extended): Extended;
function Cotan(const X: Extended): Extended;           { 1 / tan(X), X <> 0 }
function Secant(const X: Extended): Extended;          { 1 / cos(X) }
function Cosecant(const X: Extended): Extended;        { 1 / sin(X) }
function Hypot(const X, Y: Extended): Extended;        { Sqrt(X**2 + Y**2) }

{ Angle unit conversion routines }
function RadToDeg(const Radians: Extended): Extended; inline;   { Degrees := Radians * 180 / PI }
function RadToGrad(const Radians: Extended): Extended; inline;  { Grads := Radians * 200 / PI }
function RadToCycle(const Radians: Extended): Extended; inline; { Cycles := Radians / 2PI }

function DegToRad(const Degrees: Extended): Extended; inline;   { Radians := Degrees * PI / 180}
function DegToGrad(const Degrees: Extended): Extended;
function DegToCycle(const Degrees: Extended): Extended;

function GradToRad(const Grads: Extended): Extended; inline;    { Radians := Grads * PI / 200 }
function GradToDeg(const Grads: Extended): Extended;
function GradToCycle(const Grads: Extended): Extended;

function CycleToRad(const Cycles: Extended): Extended; inline;  { Radians := Cycles * 2PI }
function CycleToDeg(const Cycles: Extended): Extended;
function CycleToGrad(const Cycles: Extended): Extended;

{ Hyperbolic functions and inverses }
function Cot(const X: Extended): Extended; inline;     { alias for Cotan }
function Sec(const X: Extended): Extended; inline;     { alias for Secant }
function Csc(const X: Extended): Extended; inline;     { alias for Cosecant }
function Cosh(const X: Extended): Extended;
function Sinh(const X: Extended): Extended;
function Tanh(const X: Extended): Extended;
function CotH(const X: Extended): Extended; inline;
function SecH(const X: Extended): Extended; inline;
function CscH(const X: Extended): Extended; inline;
function ArcCot(const X: Extended): Extended;          { IN: X <> 0 }
function ArcSec(const X: Extended): Extended;          { IN: X <> 0 }
function ArcCsc(const X: Extended): Extended;          { IN: X <> 0 }
function ArcCosh(const X: Extended): Extended;         { IN: X >= 1 }
function ArcSinh(const X: Extended): Extended;
function ArcTanh(const X: Extended): Extended;         { IN: |X| <= 1 }
function ArcCotH(const X: Extended): Extended;         { IN: X <> 0 }
function ArcSecH(const X: Extended): Extended;         { IN: X <> 0 }
function ArcCscH(const X: Extended): Extended;         { IN: X <> 0 }

{ Logarithmic functions }
function LnXP1(const X: Extended): Extended; { Ln(X + 1), accurate for X near zero }
function Log10(const X: Extended): Extended;                    { Log base 10 of X }
function Log2(const X: Extended): Extended;                      { Log base 2 of X }
function LogN(const Base, X: Extended): Extended;                { Log base N of X }

{ Exponential functions }

{ IntPower: Raise base to an integral power.  Fast. }
function IntPower(const Base: Extended; const Exponent: Integer): Extended register;

{ Power: Raise base to any power.
  For fractional exponents, or |exponents| > MaxInt, base must be > 0. }
function Power(const Base, Exponent: Extended): Extended; overload;
function Power(const Base, Exponent: Double): Double; overload;
function Power(const Base, Exponent: Single): Single; overload;

{ Miscellaneous Routines }

{ Frexp:  Separates the mantissa and exponent of X. }
procedure Frexp(const X: Extended; var Mantissa: Extended; var Exponent: Integer) register;

{ Ldexp: returns X*2**P }
function Ldexp(const X: Extended; const P: Integer): Extended register;

{ Ceil: Smallest integer >= X, |X| < MaxInt }
function Ceil(const X: Extended):Integer;

{ Floor: Largest integer <= X,  |X| < MaxInt }
function Floor(const X: Extended): Integer;

{ Poly: Evaluates a uniform polynomial of one variable at value X.
    The coefficients are ordered in increasing powers of X:
    Coefficients[0] + Coefficients[1]*X + ... + Coefficients[N]*(X**N) }
function Poly(const X: Extended; const Coefficients: array of Double): Extended;

{-----------------------------------------------------------------------
Statistical functions.

Common commercial spreadsheet macro names for these statistical and
financial functions are given in the comments preceding each function.
-----------------------------------------------------------------------}

{ Mean:  Arithmetic average of values.  (AVG):  SUM / N }
function Mean(const Data: array of Double): Extended;

{ Sum: Sum of values.  (SUM) }
function Sum(const Data: array of Double): Extended register;
function SumInt(const Data: array of Integer): Integer register;
function SumOfSquares(const Data: array of Double): Extended;
procedure SumsAndSquares(const Data: array of Double;
  var Sum, SumOfSquares: Extended) register;

{ MinValue: Returns the smallest signed value in the data array (MIN) }
function MinValue(const Data: array of Double): Double;
function MinIntValue(const Data: array of Integer): Integer;

function Min(const A, B: Integer): Integer; overload; inline;
function Min(const A, B: Int64): Int64; overload; inline;
function Min(const A, B: Single): Single; overload; inline;
function Min(const A, B: Double): Double; overload; inline;
function Min(const A, B: Extended): Extended; overload; inline;

{ MaxValue: Returns the largest signed value in the data array (MAX) }
function MaxValue(const Data: array of Double): Double;
function MaxIntValue(const Data: array of Integer): Integer;

function Max(const A, B: Integer): Integer; overload; inline;
function Max(const A, B: Int64): Int64; overload; inline;
function Max(const A, B: Single): Single; overload; inline;
function Max(const A, B: Double): Double; overload; inline;
function Max(const A, B: Extended): Extended; overload; inline;

{ Standard Deviation (STD): Sqrt(Variance). aka Sample Standard Deviation }
function StdDev(const Data: array of Double): Extended;

{ MeanAndStdDev calculates Mean and StdDev in one call. }
procedure MeanAndStdDev(const Data: array of Double; var Mean, StdDev: Extended);

{ Population Standard Deviation (STDP): Sqrt(PopnVariance).
  Used in some business and financial calculations. }
function PopnStdDev(const Data: array of Double): Extended;

{ Variance (VARS): TotalVariance / (N-1). aka Sample Variance }
function Variance(const Data: array of Double): Extended;

{ Population Variance (VAR or VARP): TotalVariance/ N }
function PopnVariance(const Data: array of Double): Extended;

{ Total Variance: SUM(i=1,N)[(X(i) - Mean)**2] }
function TotalVariance(const Data: array of Double): Extended;

{ Norm:  The Euclidean L2-norm.  Sqrt(SumOfSquares) }
function Norm(const Data: array of Double): Extended;

{ MomentSkewKurtosis: Calculates the core factors of statistical analysis:
  the first four moments plus the coefficients of skewness and kurtosis.
  M1 is the Mean.  M2 is the Variance.
  Skew reflects symmetry of distribution: M3 / (M2**(3/2))
  Kurtosis reflects flatness of distribution: M4 / Sqr(M2) }
procedure MomentSkewKurtosis(const Data: array of Double;
  var M1, M2, M3, M4, Skew, Kurtosis: Extended);

{ RandG produces random numbers with Gaussian distribution about the mean.
  Useful for simulating data with sampling errors. }
function RandG(Mean, StdDev: Extended): Extended;

{-----------------------------------------------------------------------
General/Misc use functions
-----------------------------------------------------------------------}

{ Extreme testing }

// Like an infinity, a NaN double value has an exponent of 7FF, but the NaN
// values have a fraction field that is not 0.
function IsNan(const AValue: Double): Boolean; overload;
function IsNan(const AValue: Single): Boolean; overload;
function IsNan(const AValue: Extended): Boolean; overload;

// Like a NaN, an infinity double value has an exponent of 7FF, but the
// infinity values have a fraction field of 0. Infinity values can be positive
// or negative, which is specified in the high-order, sign bit.
function IsInfinite(const AValue: Double): Boolean;

{ Simple sign testing }

type
  TValueSign = -1..1;

const
  NegativeValue = Low(TValueSign);
  ZeroValue = 0;
  PositiveValue = High(TValueSign);

function Sign(const AValue: Integer): TValueSign; overload;
function Sign(const AValue: Int64): TValueSign; overload;
function Sign(const AValue: Double): TValueSign; overload;

{ CompareFloat & SameFloat: If epsilon is not given (or is zero) we will
  attempt to compute a reasonable one based on the precision of the floating
  point type used. }

function CompareValue(const A, B: Extended; Epsilon: Extended = 0): TValueRelationship; overload;
function CompareValue(const A, B: Double; Epsilon: Double = 0): TValueRelationship; overload;
function CompareValue(const A, B: Single; Epsilon: Single = 0): TValueRelationship; overload;
function CompareValue(const A, B: Integer): TValueRelationship; overload;
function CompareValue(const A, B: Int64): TValueRelationship; overload;

function SameValue(const A, B: Extended; Epsilon: Extended = 0): Boolean; overload;
function SameValue(const A, B: Double; Epsilon: Double = 0): Boolean; overload;
function SameValue(const A, B: Single; Epsilon: Single = 0): Boolean; overload;

{ IsZero: These will return true if the given value is zero (or very very very
  close to it). }

function IsZero(const A: Extended; Epsilon: Extended = 0): Boolean; overload;
function IsZero(const A: Double; Epsilon: Double = 0): Boolean; overload;
function IsZero(const A: Single; Epsilon: Single = 0): Boolean; overload;

{ Easy to use conditional functions }

function IfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer = 0): Integer; overload;
function IfThen(AValue: Boolean; const ATrue: Int64; const AFalse: Int64 = 0): Int64; overload;
function IfThen(AValue: Boolean; const ATrue: Double; const AFalse: Double = 0.0): Double; overload;

{ Various random functions }

function RandomRange(const AFrom, ATo: Integer): Integer;
function RandomFrom(const AValues: array of Integer): Integer; overload;
function RandomFrom(const AValues: array of Int64): Int64; overload;
function RandomFrom(const AValues: array of Double): Double; overload;

{ Range testing functions }

function InRange(const AValue, AMin, AMax: Integer): Boolean; overload; inline;
function InRange(const AValue, AMin, AMax: Int64): Boolean; overload; inline;
function InRange(const AValue, AMin, AMax: Double): Boolean; overload; inline;

{ Range truncation functions }

function EnsureRange(const AValue, AMin, AMax: Integer): Integer; overload;
function EnsureRange(const AValue, AMin, AMax: Int64): Int64; overload;
function EnsureRange(const AValue, AMin, AMax: Double): Double; overload;

{ 16 bit unsigned integer division and remainder in one operation }

procedure DivMod(Dividend: Cardinal; Divisor: Word;
  var Result, Remainder: Word);


{ Round to a specific digit or power of ten }
{ ADigit has a valid range of 37 to -37.  Here are some valid examples
  of ADigit values...
   3 = 10^3  = 1000   = thousand's place
   2 = 10^2  =  100   = hundred's place
   1 = 10^1  =   10   = ten's place
  -1 = 10^-1 = 1/10   = tenth's place
  -2 = 10^-2 = 1/100  = hundredth's place
  -3 = 10^-3 = 1/1000 = thousandth's place }

type
  TRoundToRange = -37..37;

type
 TRoundToEXRangeExtended = -20..20;

function RoundTo(const AValue: Extended;
                 const ADigit: TRoundToEXRangeExtended): Extended;

{ This variation of the RoundTo function follows the asymmetric arithmetic
  rounding algorithm (if Frac(X) < .5 then return X else return X + 1).  This
  function defaults to rounding to the hundredth's place (cents). }

function SimpleRoundTo(const AValue: Extended; const ADigit: TRoundToRange = -2): Extended;

{-----------------------------------------------------------------------
Financial functions.  Standard set from Quattro Pro.

Parameter conventions:

From the point of view of A, amounts received by A are positive and
amounts disbursed by A are negative (e.g. a borrower's loan repayments
are regarded by the borrower as negative).

Interest rates are per payment period.  11% annual percentage rate on a
loan with 12 payments per year would be (11 / 100) / 12 = 0.00916667

-----------------------------------------------------------------------}

type
  TPaymentTime = (ptEndOfPeriod, ptStartOfPeriod);

{ Double Declining Balance (DDB) }
function DoubleDecliningBalance(const Cost, Salvage: Extended;
  Life, Period: Integer): Extended;

{ Future Value (FVAL) }
function FutureValue(const Rate: Extended; NPeriods: Integer; const Payment,
  PresentValue: Extended; PaymentTime: TPaymentTime): Extended;

{ Interest Payment (IPAYMT)  }
function InterestPayment(const Rate: Extended; Period, NPeriods: Integer;
  const PresentValue, FutureValue: Extended; PaymentTime: TPaymentTime): Extended;

{ Interest Rate (IRATE) }
function InterestRate(NPeriods: Integer; const Payment, PresentValue,
  FutureValue: Extended; PaymentTime: TPaymentTime): Extended;

{ Internal Rate of Return. (IRR) Needs array of cash flows. }
function InternalRateOfReturn(const Guess: Extended;
  const CashFlows: array of Double): Extended;

{ Number of Periods (NPER) }
function NumberOfPeriods(const Rate: Extended; Payment: Extended;
  const PresentValue, FutureValue: Extended; PaymentTime: TPaymentTime): Extended;

{ Net Present Value. (NPV) Needs array of cash flows. }
function NetPresentValue(const Rate: Extended; const CashFlows: array of Double;
  PaymentTime: TPaymentTime): Extended;

{ Payment (PAYMT) }
function Payment(Rate: Extended; NPeriods: Integer; const PresentValue,
  FutureValue: Extended; PaymentTime: TPaymentTime): Extended;

{ Period Payment (PPAYMT) }
function PeriodPayment(const Rate: Extended; Period, NPeriods: Integer;
  const PresentValue, FutureValue: Extended; PaymentTime: TPaymentTime): Extended;

{ Present Value (PVAL) }
function PresentValue(const Rate: Extended; NPeriods: Integer;
  const Payment, FutureValue: Extended; PaymentTime: TPaymentTime): Extended;

{ Straight Line depreciation (SLN) }
function SLNDepreciation(const Cost, Salvage: Extended; Life: Integer): Extended;

{ Sum-of-Years-Digits depreciation (SYD) }
function SYDDepreciation(const Cost, Salvage: Extended; Life, Period: Integer): Extended;

type
  EInvalidArgument = class(EMathError) end;

{-----------------------------------------------------------------------
FPU exception/precision/rounding management

The following functions allow you to control the behavior of the FPU.  With
them you can control what constutes an FPU exception, what the default
precision is used and finally how rounding is handled by the FPU.

-----------------------------------------------------------------------}

type
  TFPURoundingMode = (rmNearest, rmDown, rmUp, rmTruncate);

{ Return the current rounding mode }
function GetRoundMode: TFPURoundingMode;

{ Set the rounding mode and return the old mode }
function SetRoundMode(const RoundMode: TFPURoundingMode): TFPURoundingMode;

type
  TFPUPrecisionMode = (pmSingle, pmReserved, pmDouble, pmExtended);

{ Return the current precision control mode }
function GetPrecisionMode: TFPUPrecisionMode;

{ Set the precision control mode and return the old one }
function SetPrecisionMode(const Precision: TFPUPrecisionMode): TFPUPrecisionMode;

type
  TFPUException = (exInvalidOp, exDenormalized, exZeroDivide,
                   exOverflow, exUnderflow, exPrecision);
  TFPUExceptionMask = set of TFPUException;

{ Return the exception mask from the control word.
  Any element set in the mask prevents the FPU from raising that kind of
  exception.  Instead, it returns its best attempt at a value, often NaN or an
  infinity. The value depends on the operation and the current rounding mode. }
function GetExceptionMask: TFPUExceptionMask;

{ Set a new exception mask and return the old one }
function SetExceptionMask(const Mask: TFPUExceptionMask): TFPUExceptionMask;

{ Clear any pending exception bits in the status word }
procedure ClearExceptions(RaisePending: Boolean = True);

implementation

uses SysConst;

procedure DivMod(Dividend: Cardinal; Divisor: Word;
  var Result, Remainder: Word);
asm
        PUSH    EBX
        MOV     EBX,EDX
        MOV     EDX,EAX
        SHR     EDX,16
        DIV     BX
        MOV     EBX,Remainder
        MOV     [ECX],AX
        MOV     [EBX],DX
        POP     EBX
end;

procedure RoundExError;
begin
  raise Exception.Create(SVarInvalid);
end;

(* ***** BEGIN LICENSE BLOCK *****
 *
 * The function CompareText is licensed under the CodeGear license terms.
 *
 * The initial developer of the original code is Fastcode
 *
 * Portions created by the initial developer are Copyright (C) 2002-2004
 * the initial developer. All Rights Reserved.
 *
 * Contributor(s): John O'Harrow
 *
 * ***** END LICENSE BLOCK ***** *)

function RoundTo(const AValue: Extended;
                 const ADigit: TRoundToEXRangeExtended): Extended;
type
  TFactors = array[1..2] of Extended;
const
  CW8087X : Word = 4978;
  LFactorArray : array[-20..20] of TFactors = (
    (1E-20, 1E20), (1E-19, 1E19), (1E-18, 1E18), (1E-17, 1E17), (1E-16, 1E16),
    (1E-15, 1E15), (1E-14, 1E14), (1E-13, 1E13), (1E-12, 1E12), (1E-11, 1E11),
    (1E-10, 1E10), (1E-09, 1E09), (1E-08, 1E08), (1E-07, 1E07), (1E-06, 1E06),
    (1E-05, 1E05), (1E-04, 1E04), (1E-03, 1E03), (1E-02, 1E02), (1E-01, 1E01),
    (1, 1),
    (1E01, 1E-01), (1E02, 1E-02), (1E03, 1E-03), (1E04, 1E-04), (1E05, 1E-05),
    (1E06, 1E-06), (1E07, 1E-07), (1E08, 1E-08), (1E09, 1E-09), (1E10, 1E-10),
    (1E11, 1E-11), (1E12, 1E-12), (1E13, 1E-13), (1E14, 1E-14), (1E15, 1E-15),
    (1E16, 1E-16), (1E17, 1E-17), (1E18, 1E-18), (1E19, 1E-19), (1E20, 1E-20));
asm
  movsx   eax,al
  cmp     eax, 20
  jg      RoundExError
  cmp     eax, -20
  jl      RoundExError
  sub     esp, 4
  fstcw   word ptr [esp]
  fldcw   word ptr [CW8087X]
  lea     eax, [eax+eax*4]
  lea     eax, [eax*4 + LFactorArray + 20*20]
  fld     tbyte ptr [eax]
  fld     tbyte ptr [eax+10]
  fld     AValue
  fmulp
  frndint
  fmulp
  fldcw   word ptr [esp]
  wait
  pop     eax {Restore Stack}
end;

function SimpleRoundTo(const AValue: Extended; const ADigit: TRoundToRange = -2): Extended;
var
  LFactor: Extended;
begin
  LFactor := IntPower(10, ADigit);
  if AValue < 0 then
    Result := Trunc((AValue / LFactor) - 0.5) * LFactor
  else
    Result := Trunc((AValue / LFactor) + 0.5) * LFactor;
end;

function Annuity2(const R: Extended; N: Integer; PaymentTime: TPaymentTime;
  var CompoundRN: Extended): Extended; Forward;
function Compound(const R: Extended; N: Integer): Extended; Forward;
function RelSmall(const X, Y: Extended): Boolean; Forward;

type
  TPoly = record
    Neg, Pos, DNeg, DPos: Extended
  end;

const
  MaxIterations = 15;

procedure ArgError(const Msg: string);
begin
  raise EInvalidArgument.Create(Msg);
end;

function DegToRad(const Degrees: Extended): Extended;  { Radians := Degrees * PI / 180 }
begin
  Result := Degrees * (PI / 180);
end;

function RadToDeg(const Radians: Extended): Extended;  { Degrees := Radians * 180 / PI }
begin
  Result := Radians * (180 / PI);
end;

function GradToRad(const Grads: Extended): Extended;   { Radians := Grads * PI / 200 }
begin
  Result := Grads * (PI / 200);
end;

function RadToGrad(const Radians: Extended): Extended; { Grads := Radians * 200 / PI}
begin
  Result := Radians * (200 / PI);
end;

function CycleToRad(const Cycles: Extended): Extended; { Radians := Cycles * 2PI }
begin
  Result := Cycles * (2 * PI);
end;

function RadToCycle(const Radians: Extended): Extended;{ Cycles := Radians / 2PI }
begin
  Result := Radians / (2 * PI);
end;

function DegToGrad(const Degrees: Extended): Extended;
begin
  Result := RadToGrad(DegToRad(Degrees));
end;

function DegToCycle(const Degrees: Extended): Extended;
begin
  Result := RadToCycle(DegToRad(Degrees));
end;

function GradToDeg(const Grads: Extended): Extended;
begin
  Result := RadToDeg(GradToRad(Grads));
end;

function GradToCycle(const Grads: Extended): Extended;
begin
  Result := RadToCycle(GradToRad(Grads));
end;

function CycleToDeg(const Cycles: Extended): Extended;
begin
  Result := RadToDeg(CycleToRad(Cycles));
end;

function CycleToGrad(const Cycles: Extended): Extended;
begin
  Result := RadToGrad(CycleToRad(Cycles));
end;

function LnXP1(const X: Extended): Extended;
{ Return ln(1 + X).  Accurate for X near 0. }
asm
        FLDLN2
        MOV     AX,WORD PTR X+8               { exponent }
        FLD     X
        CMP     AX,$3FFD                      { .4225 }
        JB      @@1
        FLD1
        FADD
        FYL2X
        JMP     @@2
@@1:
        FYL2XP1
@@2:
        FWAIT
end;

{ Invariant: Y >= 0 & Result*X**Y = X**I.  Init Y = I and Result = 1. }
{function IntPower(X: Extended; I: Integer): Extended;
var
  Y: Integer;
begin
  Y := Abs(I);
  Result := 1.0;
  while Y > 0 do begin
    while not Odd(Y) do
    begin
      Y := Y shr 1;
      X := X * X
    end;
    Dec(Y);
    Result := Result * X
  end;
  if I < 0 then Result := 1.0 / Result
end;
}
function IntPower(const Base: Extended; const Exponent: Integer): Extended;
asm
        mov     ecx, eax
        cdq
        fld1                      { Result := 1 }
        xor     eax, edx
        sub     eax, edx          { eax := Abs(Exponent) }
        jz      @@3
        fld     Base
        jmp     @@2
@@1:    fmul    ST, ST            { X := Base * Base }
@@2:    shr     eax,1
        jnc     @@1
        fmul    ST(1),ST          { Result := Result * X }
        jnz     @@1
        fstp    st                { pop X from FPU stack }
        cmp     ecx, 0
        jge     @@3
        fld1
        fdivrp                    { Result := 1 / Result }
@@3:
        fwait
end;

function Compound(const R: Extended; N: Integer): Extended;
{ Return (1 + R)**N. }
begin
  Result := IntPower(1.0 + R, N)
end;

function Annuity2(const R: Extended; N: Integer; PaymentTime: TPaymentTime;
  var CompoundRN: Extended): Extended;
{ Set CompoundRN to Compound(R, N),
  return (1+Rate*PaymentTime)*(Compound(R,N)-1)/R;
}
begin
  if R = 0.0 then
  begin
    CompoundRN := 1.0;
    Result := N;
  end
  else
  begin
    { 6.1E-5 approx= 2**-14 }
    if Abs(R) < 6.1E-5 then
    begin
      CompoundRN := Exp(N * LnXP1(R));
      Result := N*(1+(N-1)*R/2);
    end
    else
    begin
      CompoundRN := Compound(R, N);
      Result := (CompoundRN-1) / R
    end;
    if PaymentTime = ptStartOfPeriod then
      Result := Result * (1 + R);
  end;
end; {Annuity2}


procedure PolyX(const A: array of Double; X: Extended; var Poly: TPoly);
{ Compute A[0] + A[1]*X + ... + A[N]*X**N and X * its derivative.
  Accumulate positive and negative terms separately. }
var
  I: Integer;
  Neg, Pos, DNeg, DPos: Extended;
begin
  Neg := 0.0;
  Pos := 0.0;
  DNeg := 0.0;
  DPos := 0.0;
  for I := High(A) downto Low(A) do
  begin
    DNeg := X * DNeg + Neg;
    Neg := Neg * X;
    DPos := X * DPos + Pos;
    Pos := Pos * X;
    if A[I] >= 0.0 then
      Pos := Pos + A[I]
    else
      Neg := Neg + A[I]
  end;
  Poly.Neg := Neg;
  Poly.Pos := Pos;
  Poly.DNeg := DNeg * X;
  Poly.DPos := DPos * X;
end; {PolyX}


function RelSmall(const X, Y: Extended): Boolean;
{ Returns True if X is small relative to Y }
const
  C1: Double = 1E-15;
  C2: Double = 1E-12;
begin
  Result := Abs(X) < (C1 + C2 * Abs(Y))
end;

{ Math functions. }

(* ***** BEGIN LICENSE BLOCK *****
 *
 * The function ArcCos is licensed under the CodeGear license terms.
 *
 * The initial developer of the original code is Fastcode
 *
 * Portions created by the initial developer are Copyright (C) 2002-2004
 * the initial developer. All Rights Reserved.
 *
 * Contributor(s): John O'Harrow and Norbert Juffa
 *
 * ***** END LICENSE BLOCK ***** *)
function ArcCos(const X : Extended) : Extended; overload;
asm
  //Result := ArcTan2(Sqrt((1+X) * (1-X)), X)
  FLD   X
  FLD1
  FADD  ST(0), ST(1)
  FLD1
  FSUB  ST(0), ST(2)
  FMULP ST(1), ST(0)
  FSQRT
  FXCH
  FPATAN
end;

function ArcCos(const X : Double) : Double; overload;
asm
  //Result := ArcTan2(Sqrt((1+X) * (1-X)), X)
  FLD   X
  FLD1
  FADD  ST(0), ST(1)
  FLD1
  FSUB  ST(0), ST(2)
  FMULP ST(1), ST(0)
  FSQRT
  FXCH
  FPATAN
end;

function ArcCos(const X : Single) : Single; overload;
asm
  //Result := ArcTan2(Sqrt((1+X) * (1-X)), X)
  fld1
  fld    X
  fst    st(2)
  fmul   st(0), st(0)
  fsubp
  fsqrt
  fxch
  fpatan
end;

(* ***** BEGIN LICENSE BLOCK *****
 *
 * The function ArcSin is licensed under the CodeGear license terms.
 *
 * The initial developer of the original code is Fastcode
 *
 * Portions created by the initial developer are Copyright (C) 2002-2004
 * the initial developer. All Rights Reserved.
 *
 * Contributor(s): John O'Harrow and Norbert Juffa
 *
 * ***** END LICENSE BLOCK ***** *)
function ArcSin(const X : Extended) : Extended; overload;
asm
  //Result := ArcTan2(X, Sqrt((1+X) * (1-X)))
  fld1
  fld    X
  fst    st(2)
  fmul   st(0), st(0)
  fsubp
  fsqrt
  fpatan
end;

function ArcSin(const X : Double) : Double; overload;
asm
  //Result := ArcTan2(X, Sqrt((1+X) * (1-X)))
  FLD   X
  FLD1
  FADD  ST(0), ST(1)
  FLD1
  FSUB  ST(0), ST(2)
  FMULP ST(1), ST(0)
  FSQRT
  FPATAN
end;

function ArcSin(const X : Single) : Single; overload;
asm
  //Result := ArcTan2(X, Sqrt((1+X) * (1-X)))
  fld1
  fld    X
  fst    st(2)
  fmul   st(0), st(0)
  fsubp
  fsqrt
  fpatan
end;

function ArcTan2(const Y, X: Extended): Extended;
asm
        FLD     Y
        FLD     X
        FPATAN
        FWAIT
end;

function Tan(const X: Extended): Extended;
{  Tan := Sin(X) / Cos(X) }
asm
        FLD    X
        FPTAN
        FSTP   ST(0)      { FPTAN pushes 1.0 after result }
        FWAIT
end;

function CoTan(const X: Extended): Extended;
{ CoTan := Cos(X) / Sin(X) = 1 / Tan(X) }
asm
        FLD   X
        FPTAN
        FDIVRP
        FWAIT
end;

function Secant(const X: Extended): Extended;
{ Secant := 1 / Cos(X) }
asm
        FLD   X
        FCOS
        FLD1
        FDIVRP
        FWAIT
end;

function Cosecant(const X: Extended): Extended;
{ Cosecant := 1 / Sin(X) }
asm
        FLD   X
        FSIN
        FLD1
        FDIVRP
        FWAIT
end;

function Hypot(const X, Y: Extended): Extended;
{ formula: Sqrt(X*X + Y*Y)
  implemented as:  |Y|*Sqrt(1+Sqr(X/Y)), |X| < |Y| for greater precision
var
  Temp: Extended;
begin
  X := Abs(X);
  Y := Abs(Y);
  if X > Y then
  begin
    Temp := X;
    X := Y;
    Y := Temp;
  end;
  if X = 0 then
    Result := Y
  else         // Y > X, X <> 0, so Y > 0
    Result := Y * Sqrt(1 + Sqr(X/Y));
end;
}
asm
        FLD     Y
        FABS
        FLD     X
        FABS
        FCOM
        FNSTSW  AX
        TEST    AH,$45
        JNZ      @@1        // if ST > ST(1) then swap
        FXCH    ST(1)      // put larger number in ST(1)
@@1:    FLDZ
        FCOMP
        FNSTSW  AX
        TEST    AH,$40     // if ST = 0, return ST(1)
        JZ      @@2
        FSTP    ST         // eat ST(0)
        JMP     @@3
@@2:    FDIV    ST,ST(1)   // ST := ST / ST(1)
        FMUL    ST,ST      // ST := ST * ST
        FLD1
        FADD               // ST := ST + 1
        FSQRT              // ST := Sqrt(ST)
        FMUL               // ST(1) := ST * ST(1); Pop ST
@@3:    FWAIT
end;


procedure SinCos(const Theta: Extended; var Sin, Cos: Extended);
asm
        FLD     Theta
        FSINCOS
        FSTP    tbyte ptr [edx]    // Cos
        FSTP    tbyte ptr [eax]    // Sin
        FWAIT
end;

{ Extract exponent and mantissa from X }
procedure Frexp(const X: Extended; var Mantissa: Extended; var Exponent: Integer);
{ Mantissa ptr in EAX, Exponent ptr in EDX }
asm
        FLD     X
        PUSH    EAX
        MOV     dword ptr [edx], 0    { if X = 0, return 0 }

        FTST
        FSTSW   AX
        FWAIT
        SAHF
        JZ      @@Done

        FXTRACT                 // ST(1) = exponent, (pushed) ST = fraction
        FXCH

// The FXTRACT instruction normalizes the fraction 1 bit higher than
// wanted for the definition of frexp() so we need to tweak the result
// by scaling the fraction down and incrementing the exponent.

        FISTP   dword ptr [edx]
        FLD1
        FCHS
        FXCH
        FSCALE                  // scale fraction
        INC     dword ptr [edx] // exponent biased to match
        FSTP ST(1)              // discard -1, leave fraction as TOS

@@Done:
        POP     EAX
        FSTP    tbyte ptr [eax]
        FWAIT
end;

function Ldexp(const X: Extended; const P: Integer): Extended;
  { Result := X * (2^P) }
asm
        PUSH    EAX
        FILD    dword ptr [ESP]
        FLD     X
        FSCALE
        POP     EAX
        FSTP    ST(1)
        FWAIT
end;

function Ceil(const X: Extended): Integer;
begin
  Result := Integer(Trunc(X));
  if Frac(X) > 0 then
    Inc(Result);
end;

function Floor(const X: Extended): Integer;
begin
  Result := Integer(Trunc(X));
  if Frac(X) < 0 then
    Dec(Result);
end;

{ Conversion of bases:  Log.b(X) = Log.a(X) / Log.a(b)  }

function Log10(const X: Extended): Extended;
  { Log.10(X) := Log.2(X) * Log.10(2) }
asm
        FLDLG2     { Log base ten of 2 }
        FLD     X
        FYL2X
        FWAIT
end;

function Log2(const X: Extended): Extended;
asm
        FLD1
        FLD     X
        FYL2X
        FWAIT
end;

function LogN(const Base, X: Extended): Extended;
{ Log.N(X) := Log.2(X) / Log.2(N) }
asm
        FLD1
        FLD     X
        FYL2X
        FLD1
        FLD     Base
        FYL2X
        FDIV
        FWAIT
end;

function Poly(const X: Extended; const Coefficients: array of Double): Extended;
{ Horner's method }
var
  I: Integer;
begin
  Result := Coefficients[High(Coefficients)];
  for I := High(Coefficients)-1 downto Low(Coefficients) do
    Result := Result * X + Coefficients[I];
end;

(* ***** BEGIN LICENSE BLOCK *****
 *
 * The function Power is licensed under the CodeGear license terms.
 *
 * The initial developer of the original code is Fastcode
 *
 * Portions created by the initial developer are Copyright (C) 2002-2004
 * the initial developer. All Rights Reserved.
 *
 * Contributor(s): John O'Harrow
 *
 * ***** END LICENSE BLOCK ***** *)
function Power(const Base, Exponent: Extended): Extended;
const
  Max  : Double = MaxInt;
var
  IntExp : Integer;
asm
  fld     Exponent
  fld     st             {copy to st(1)}
  fabs                   {abs(exp)}
  fld     Max
  fcompp                 {leave exp in st(0)}
  fstsw   ax
  sahf
  jb      @@RealPower    {exp > MaxInt}
  fld     st             {exp in st(0) and st(1)}
  frndint                {round(exp)}
  fcomp                  {compare exp and round(exp)}
  fstsw   ax
  sahf
  jne     @@RealPower
  fistp   IntExp
  mov     eax, IntExp    {eax=Trunc(Exponent)}
  mov     ecx, eax
  cdq
  fld1                   {Result=1}
  xor     eax, edx
  sub     eax, edx       {abs(exp)}
  jz      @@Exit
  fld     Base
  jmp     @@Entry
@@Loop:
  fmul    st, st         {Base * Base}
@@Entry:
  shr     eax, 1
  jnc     @@Loop
  fmul    st(1), st      {Result * X}
  jnz     @@Loop
  fstp    st
  cmp     ecx, 0
  jge     @@Exit
  fld1
  fdivrp                 {1/Result}
  jmp     @@Exit
@@RealPower:
  fld     Base
  ftst
  fstsw   ax
  sahf
  jz      @@Done
  fldln2
  fxch
  fyl2x
  fxch
  fmulp   st(1), st
  fldl2e
  fmulp   st(1), st
  fld     st(0)
  frndint
  fsub    st(1), st
  fxch    st(1)
  f2xm1
  fld1
  faddp   st(1), st
  fscale
@@Done:
  fstp    st(1)
@@Exit:
end;

function Power(const Base, Exponent: Double): Double; overload;
const
  Max  : Double = MaxInt;
var
  IntExp : Integer;
asm
  fld     Exponent
  fld     st             {copy to st(1)}
  fabs                   {abs(exp)}
  fld     Max
  fcompp                 {leave exp in st(0)}
  fstsw   ax
  sahf
  jb      @@RealPower    {exp > MaxInt}
  fld     st             {exp in st(0) and st(1)}
  frndint                {round(exp)}
  fcomp                  {compare exp and round(exp)}
  fstsw   ax
  sahf
  jne     @@RealPower
  fistp   IntExp
  mov     eax, IntExp    {eax=Trunc(Exponent)}
  mov     ecx, eax
  cdq
  fld1                   {Result=1}
  xor     eax, edx
  sub     eax, edx       {abs(exp)}
  jz      @@Exit
  fld     Base
  jmp     @@Entry
@@Loop:
  fmul    st, st         {Base * Base}
@@Entry:
  shr     eax, 1
  jnc     @@Loop
  fmul    st(1), st      {Result * X}
  jnz     @@Loop
  fstp    st
  cmp     ecx, 0
  jge     @@Exit
  fld1
  fdivrp                 {1/Result}
  jmp     @@Exit
@@RealPower:
  fld     Base
  ftst
  fstsw   ax
  sahf
  jz      @@Done
  fldln2
  fxch
  fyl2x
  fxch
  fmulp   st(1), st
  fldl2e
  fmulp   st(1), st
  fld     st(0)
  frndint
  fsub    st(1), st
  fxch    st(1)
  f2xm1
  fld1
  faddp   st(1), st
  fscale
@@Done:
  fstp    st(1)
@@Exit:
end;

function Power(const Base, Exponent: Single): Single; overload;
const
  Max : Double = MaxInt;
var
  IntExp : Integer;
asm
  fld     Exponent
  fld     st             {copy to st(1)}
  fabs                   {abs(exp)}
  fld     Max
  fcompp                 {leave exp in st(0)}
  fstsw   ax
  sahf
  jb      @@RealPower    {exp > MaxInt}
  fld     st             {exp in st(0) and st(1)}
  frndint                {round(exp)}
  fcomp                  {compare exp and round(exp)}
  fstsw   ax
  sahf
  jne     @@RealPower
  fistp   IntExp
  mov     eax, IntExp    {eax=Integer(Exponent)}
  mov     ecx, eax
  cdq
  fld1                   {Result=1}
  xor     eax, edx
  sub     eax, edx       {abs(exp)}
  jz      @@Exit
  fld     Base
  jmp     @@Entry
@@Loop:
  fmul    st, st         {Base * Base}
@@Entry:
  shr     eax, 1
  jnc     @@Loop
  fmul    st(1), st      {Result * X}
  jnz     @@Loop
  fstp    st
  cmp     ecx, 0
  jge     @@Exit
  fld1
  fdivrp                 {1/Result}
  jmp     @@Exit
@@RealPower:
  fld     Base
  ftst
  fstsw   ax
  sahf
  jz      @@Done
  fldln2
  fxch
  fyl2x
  fxch
  fmulp   st(1), st
  fldl2e
  fmulp   st(1), st
  fld     st(0)
  frndint
  fsub    st(1), st
  fxch    st(1)
  f2xm1
  fld1
  faddp   st(1), st
  fscale
@@Done:
  fstp    st(1)
@@Exit:
end;

{ Hyperbolic functions }

function Cosh(const X: Extended): Extended;
begin
  if IsZero(X) then
    Result := 1
  else
    Result := (Exp(X) + Exp(-X)) / 2;
end;

function Sinh(const X: Extended): Extended;
begin
  if IsZero(X) then
    Result := 0
  else
    Result := (Exp(X) - Exp(-X)) / 2;
end;

function Tanh(const X: Extended): Extended;
begin
  if IsZero(X) then
    Result := 0
  else
    Result := SinH(X) / CosH(X);
end;

function ArcCosh(const X: Extended): Extended;
begin
  Result := Ln(X + Sqrt((X - 1) / (X + 1)) * (X + 1));
end;

function ArcSinh(const X: Extended): Extended;
begin
  Result := Ln(X + Sqrt((X * X) + 1));
end;

function ArcTanh(const X: Extended): Extended;
begin
  if SameValue(X, 1) then
    Result := Infinity
  else if SameValue(X, -1) then
    Result := NegInfinity
  else
    Result := 0.5 * Ln((1 + X) / (1 - X));
end;

function Cot(const X: Extended): Extended;
begin
  Result := CoTan(X);
end;

function Sec(const X: Extended): Extended;
begin
  Result := Secant(X);
end;

function Csc(const X: Extended): Extended;
begin
  Result := Cosecant(X);
end;

function CotH(const X: Extended): Extended;
begin
  Result := 1 / TanH(X);
end;

function SecH(const X: Extended): Extended;
begin
  Result := 1 / CosH(X);
end;

function CscH(const X: Extended): Extended;
begin
  Result := 1 / SinH(X);
end;

function ArcCot(const X: Extended): Extended;
begin
  if IsZero(X) then
    Result := PI / 2
  else
    Result := ArcTan(1 / X);
end;

function ArcSec(const X: Extended): Extended;
begin
  if IsZero(X) then
    Result := Infinity
  else
    Result := ArcCos(1 / X);
end;

function ArcCsc(const X: Extended): Extended;
begin
  if IsZero(X) then
    Result := Infinity
  else
    Result := ArcSin(1 / X);
end;

function ArcCotH(const X: Extended): Extended;
begin
  if SameValue(X, 1) then
    Result := Infinity
  else if SameValue(X, -1) then
    Result := NegInfinity
  else
    Result := 0.5 * Ln((X + 1) / (X - 1));
end;

function ArcSecH(const X: Extended): Extended;
begin
  if IsZero(X) then
    Result := Infinity
  else if SameValue(X, 1) then
    Result := 0
  else
    Result := Ln((Sqrt(1 - X * X) + 1) / X);
end;

function ArcCscH(const X: Extended): Extended;
begin
  Result := Ln(Sqrt(1 + (1 / (X * X)) + (1 / X)));
end;

function IsNan(const AValue: Single): Boolean;
begin
  Result := ((PLongWord(@AValue)^ and $7F800000)  = $7F800000) and
            ((PLongWord(@AValue)^ and $007FFFFF) <> $00000000);
end;

function IsNan(const AValue: Double): Boolean;
begin
  Result := ((PInt64(@AValue)^ and $7FF0000000000000)  = $7FF0000000000000) and
            ((PInt64(@AValue)^ and $000FFFFFFFFFFFFF) <> $0000000000000000);
end;

function IsNan(const AValue: Extended): Boolean;
type
  TExtented = packed record
    Mantissa: Int64;
    Exponent: Word;
  end;
  PExtended = ^TExtented;
begin
  Result := ((PExtended(@AValue)^.Exponent and $7FFF)  = $7FFF) and
            ((PExtended(@AValue)^.Mantissa and $7FFFFFFFFFFFFFFF) <> 0);
end;

function IsInfinite(const AValue: Double): Boolean;
begin
  Result := ((PInt64(@AValue)^ and $7FF0000000000000) = $7FF0000000000000) and
            ((PInt64(@AValue)^ and $000FFFFFFFFFFFFF) = $0000000000000000);
end;

{ Statistical functions }

function Mean(const Data: array of Double): Extended;
begin
  Result := SUM(Data) / (High(Data) - Low(Data) + 1);
end;

function MinValue(const Data: array of Double): Double;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result > Data[I] then
      Result := Data[I];
end;

function MinIntValue(const Data: array of Integer): Integer;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result > Data[I] then
      Result := Data[I];
end;

function Min(const A, B: Integer): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Int64): Int64;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Single): Single;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Double): Double;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Extended): Extended;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function MaxValue(const Data: array of Double): Double;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result < Data[I] then
      Result := Data[I];
end;

function MaxIntValue(const Data: array of Integer): Integer;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result < Data[I] then
      Result := Data[I];
end;

function Max(const A, B: Integer): Integer;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Int64): Int64;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Single): Single;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Double): Double;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Extended): Extended;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Sign(const AValue: Integer): TValueSign;
begin
  Result := ZeroValue;
  if AValue < 0 then
    Result := NegativeValue
  else if AValue > 0 then
    Result := PositiveValue;
end;

function Sign(const AValue: Int64): TValueSign;
begin
  Result := ZeroValue;
  if AValue < 0 then
    Result := NegativeValue
  else if AValue > 0 then
    Result := PositiveValue;
end;

function Sign(const AValue: Double): TValueSign;
begin
  if ((PInt64(@AValue)^ and $7FFFFFFFFFFFFFFF) = $0000000000000000) then
    Result := ZeroValue
  else if ((PInt64(@AValue)^ and $8000000000000000) = $8000000000000000) then
    Result := NegativeValue
  else
    Result := PositiveValue;
end;

const
  FuzzFactor = 1000;
  ExtendedResolution = 1E-19 * FuzzFactor;
  DoubleResolution   = 1E-15 * FuzzFactor;
  SingleResolution   = 1E-7 * FuzzFactor;

function CompareValue(const A, B: Extended; Epsilon: Extended): TValueRelationship;
begin
  if SameValue(A, B, Epsilon) then
    Result := EqualsValue
  else if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function CompareValue(const A, B: Double; Epsilon: Double): TValueRelationship;
begin
  if SameValue(A, B, Epsilon) then
    Result := EqualsValue
  else if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function CompareValue(const A, B: Single; Epsilon: Single): TValueRelationship;
begin
  if SameValue(A, B, Epsilon) then
    Result := EqualsValue
  else if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function CompareValue(const A, B: Integer): TValueRelationship;
begin
  if A = B then
    Result := EqualsValue
  else if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function CompareValue(const A, B: Int64): TValueRelationship;
begin
  if A = B then
    Result := EqualsValue
  else if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function SameValue(const A, B: Extended; Epsilon: Extended): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := Max(Min(Abs(A), Abs(B)) * ExtendedResolution, ExtendedResolution);
  if A > B then
    Result := (A - B) <= Epsilon
  else
    Result := (B - A) <= Epsilon;
end;

function SameValue(const A, B: Double; Epsilon: Double): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := Max(Min(Abs(A), Abs(B)) * DoubleResolution, DoubleResolution);
  if A > B then
    Result := (A - B) <= Epsilon
  else
    Result := (B - A) <= Epsilon;
end;

function SameValue(const A, B: Single; Epsilon: Single): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := Max(Min(Abs(A), Abs(B)) * SingleResolution, SingleResolution);
  if A > B then
    Result := (A - B) <= Epsilon
  else
    Result := (B - A) <= Epsilon;
end;

function IsZero(const A: Extended; Epsilon: Extended): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := ExtendedResolution;
  Result := Abs(A) <= Epsilon;
end;

function IsZero(const A: Double; Epsilon: Double): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := DoubleResolution;
  Result := Abs(A) <= Epsilon;
end;

function IsZero(const A: Single; Epsilon: Single): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := SingleResolution;
  Result := Abs(A) <= Epsilon;
end;

function IfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer): Integer;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Int64; const AFalse: Int64): Int64;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Double; const AFalse: Double): Double;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function RandomRange(const AFrom, ATo: Integer): Integer;
begin
  if AFrom > ATo then
    Result := Random(AFrom - ATo) + ATo
  else
    Result := Random(ATo - AFrom) + AFrom;
end;

function RandomFrom(const AValues: array of Integer): Integer;
begin
  Result := AValues[Random(High(AValues) + 1)];
end;

function RandomFrom(const AValues: array of Int64): Int64;
begin
  Result := AValues[Random(High(AValues) + 1)];
end;

function RandomFrom(const AValues: array of Double): Double;
begin
  Result := AValues[Random(High(AValues) + 1)];
end;

{ Range testing functions }

function InRange(const AValue, AMin, AMax: Integer): Boolean;
var
  A,B: Boolean;
begin
  A := (AValue >= AMin);
  B := (AValue <= AMax);
  Result := B and A;
end;

function InRange(const AValue, AMin, AMax: Int64): Boolean;
var
  A,B: Boolean;
begin
  A := (AValue >= AMin);
  B := (AValue <= AMax);
  Result := B and A;
end;

function InRange(const AValue, AMin, AMax: Double): Boolean;
var
  A,B: Boolean;
begin
  A := (AValue >= AMin);
  B := (AValue <= AMax);
  Result := B and A;
end;

{ Range truncation functions }

function EnsureRange(const AValue, AMin, AMax: Integer): Integer;
begin
  Result := AValue;
  assert(AMin <= AMax);
  if Result < AMin then
    Result := AMin;
  if Result > AMax then
    Result := AMax;
end;

function EnsureRange(const AValue, AMin, AMax: Int64): Int64;
begin
  Result := AValue;
  assert(AMin <= AMax);
  if Result < AMin then
    Result := AMin;
  if Result > AMax then
    Result := AMax;
end;

function EnsureRange(const AValue, AMin, AMax: Double): Double;
begin
  Result := AValue;
  assert(AMin <= AMax);
  if Result < AMin then
    Result := AMin;
  if Result > AMax then
    Result := AMax;
end;

procedure MeanAndStdDev(const Data: array of Double; var Mean, StdDev: Extended);
var
  S: Extended;
  N,I: Integer;
begin
  N := High(Data)- Low(Data) + 1;
  if N = 1 then
  begin
    Mean := Data[0];
    StdDev := Data[0];
    Exit;
  end;
  Mean := Sum(Data) / N;
  S := 0;               // sum differences from the mean, for greater accuracy
  for I := Low(Data) to High(Data) do
    S := S + Sqr(Mean - Data[I]);
  StdDev := Sqrt(S / (N - 1));
end;

procedure MomentSkewKurtosis(const Data: array of Double;
  var M1, M2, M3, M4, Skew, Kurtosis: Extended);
var
  Sum, SumSquares, SumCubes, SumQuads, OverN, Accum, M1Sqr, S2N, S3N: Extended;
  I: Integer;
begin
  OverN := 1 / (High(Data) - Low(Data) + 1);
  Sum := 0;
  SumSquares := 0;
  SumCubes := 0;
  SumQuads := 0;
  for I := Low(Data) to High(Data) do
  begin
    Sum := Sum + Data[I];
    Accum := Sqr(Data[I]);
    SumSquares := SumSquares + Accum;
    Accum := Accum*Data[I];
    SumCubes := SumCubes + Accum;
    SumQuads := SumQuads + Accum*Data[I];
  end;
  M1 := Sum * OverN;
  M1Sqr := Sqr(M1);
  S2N := SumSquares * OverN;
  S3N := SumCubes * OverN;
  M2 := S2N - M1Sqr;
  M3 := S3N - (M1 * 3 * S2N) + 2*M1Sqr*M1;
  M4 := (SumQuads * OverN) - (M1 * 4 * S3N) + (M1Sqr*6*S2N - 3*Sqr(M1Sqr));
  Skew := M3 * Power(M2, -3/2);   // = M3 / Power(M2, 3/2)
  Kurtosis := M4 / Sqr(M2);
end;

function Norm(const Data: array of Double): Extended;
begin
  Result := Sqrt(SumOfSquares(Data));
end;

function PopnStdDev(const Data: array of Double): Extended;
begin
  Result := Sqrt(PopnVariance(Data))
end;

function PopnVariance(const Data: array of Double): Extended;
begin
  Result := TotalVariance(Data) / (High(Data) - Low(Data) + 1)
end;

function RandG(Mean, StdDev: Extended): Extended;
{ Marsaglia-Bray algorithm }
var
  U1, S2: Extended;
begin
  repeat
    U1 := 2*Random - 1;
    S2 := Sqr(U1) + Sqr(2*Random-1);
  until S2 < 1;
  Result := Sqrt(-2*Ln(S2)/S2) * U1 * StdDev + Mean;
end;

function StdDev(const Data: array of Double): Extended;
begin
  Result := Sqrt(Variance(Data))
end;

procedure RaiseOverflowError; forward;

function SumInt(const Data: array of Integer): Integer;









asm  // IN: EAX = ptr to Data, EDX = High(Data) = Count - 1
     // loop unrolled 4 times, 5 clocks per loop, 1.2 clocks per datum
      PUSH EBX
      MOV  ECX, EAX         // ecx = ptr to data
      MOV  EBX, EDX
      XOR  EAX, EAX
      AND  EDX, not 3
      AND  EBX, 3
      SHL  EDX, 2
      JMP  @Vector.Pointer[EBX*4]
@Vector:
      DD @@1
      DD @@2
      DD @@3
      DD @@4
@@4:
      ADD  EAX, [ECX+12+EDX]
      JO   RaiseOverflowError
@@3:
      ADD  EAX, [ECX+8+EDX]
      JO   RaiseOverflowError
@@2:
      ADD  EAX, [ECX+4+EDX]
      JO   RaiseOverflowError
@@1:
      ADD  EAX, [ECX+EDX]
      JO   RaiseOverflowError
      SUB  EDX,16
      JNS  @@4
      POP  EBX
end;


procedure RaiseOverflowError;
begin
  raise EIntOverflow.Create(SIntOverflow);
end;

function SUM(const Data: array of Double): Extended;









asm  // IN: EAX = ptr to Data, EDX = High(Data) = Count - 1
     // Uses 4 accumulators to minimize read-after-write delays and loop overhead
     // 5 clocks per loop, 4 items per loop = 1.2 clocks per item
       FLDZ
       MOV      ECX, EDX
       FLD      ST(0)
       AND      EDX, not 3
       FLD      ST(0)
       AND      ECX, 3
       FLD      ST(0)
       SHL      EDX, 3      // count * sizeof(Double) = count * 8
       JMP      @Vector.Pointer[ECX*4]
@Vector:
       DD @@1
       DD @@2
       DD @@3
       DD @@4
@@4:   FADD     qword ptr [EAX+EDX+24]    // 1
       FXCH     ST(3)                     // 0
@@3:   FADD     qword ptr [EAX+EDX+16]    // 1
       FXCH     ST(2)                     // 0
@@2:   FADD     qword ptr [EAX+EDX+8]     // 1
       FXCH     ST(1)                     // 0
@@1:   FADD     qword ptr [EAX+EDX]       // 1
       FXCH     ST(2)                     // 0
       SUB      EDX, 32
       JNS      @@4
       FADDP    ST(3),ST                  // ST(3) := ST + ST(3); Pop ST
       FADD                               // ST(1) := ST + ST(1); Pop ST
       FADD                               // ST(1) := ST + ST(1); Pop ST
       FWAIT
end;


function SumOfSquares(const Data: array of Double): Extended;
var
  I: Integer;
begin
  Result := 0.0;
  for I := Low(Data) to High(Data) do
    Result := Result + Sqr(Data[I]);
end;

procedure SumsAndSquares(const Data: array of Double; var Sum, SumOfSquares: Extended);













asm  // IN:  EAX = ptr to Data
     //      EDX = High(Data) = Count - 1
     //      ECX = ptr to Sum
     // Est. 17 clocks per loop, 4 items per loop = 4.5 clocks per data item
       FLDZ                 // init Sum accumulator
       PUSH     ECX
       MOV      ECX, EDX
       FLD      ST(0)       // init Sqr1 accum.
       AND      EDX, not 3
       FLD      ST(0)       // init Sqr2 accum.
       AND      ECX, 3
       FLD      ST(0)       // init/simulate last data item left in ST
       SHL      EDX, 3      // count * sizeof(Double) = count * 8
       JMP      @Vector.Pointer[ECX*4]
@Vector:
       DD @@1
       DD @@2
       DD @@3
       DD @@4
@@4:   FADD                            // Sqr2 := Sqr2 + Sqr(Data4); Pop Data4
       FLD     qword ptr [EAX+EDX+24]  // Load Data1
       FADD    ST(3),ST                // Sum := Sum + Data1
       FMUL    ST,ST                   // Data1 := Sqr(Data1)
@@3:   FLD     qword ptr [EAX+EDX+16]  // Load Data2
       FADD    ST(4),ST                // Sum := Sum + Data2
       FMUL    ST,ST                   // Data2 := Sqr(Data2)
       FXCH                            // Move Sqr(Data1) into ST(0)
       FADDP   ST(3),ST                // Sqr1 := Sqr1 + Sqr(Data1); Pop Data1
@@2:   FLD     qword ptr [EAX+EDX+8]   // Load Data3
       FADD    ST(4),ST                // Sum := Sum + Data3
       FMUL    ST,ST                   // Data3 := Sqr(Data3)
       FXCH                            // Move Sqr(Data2) into ST(0)
       FADDP   ST(3),ST                // Sqr1 := Sqr1 + Sqr(Data2); Pop Data2
@@1:   FLD     qword ptr [EAX+EDX]     // Load Data4
       FADD    ST(4),ST                // Sum := Sum + Data4
       FMUL    ST,ST                   // Sqr(Data4)
       FXCH                            // Move Sqr(Data3) into ST(0)
       FADDP   ST(3),ST                // Sqr1 := Sqr1 + Sqr(Data3); Pop Data3
       SUB     EDX,32
       JNS     @@4
       FADD                         // Sqr2 := Sqr2 + Sqr(Data4); Pop Data4
       POP     ECX
       FADD                         // Sqr1 := Sqr2 + Sqr1; Pop Sqr2
       FXCH                         // Move Sum1 into ST(0)
       MOV     EAX, SumOfSquares
       FSTP    tbyte ptr [ECX]      // Sum := Sum1; Pop Sum1
       FSTP    tbyte ptr [EAX]      // SumOfSquares := Sum1; Pop Sum1
       FWAIT
end;


function TotalVariance(const Data: array of Double): Extended;
var
  Sum, SumSquares: Extended;
begin
  SumsAndSquares(Data, Sum, SumSquares);
  Result := SumSquares - Sqr(Sum)/(High(Data) - Low(Data) + 1);
end;

function Variance(const Data: array of Double): Extended;
begin
  Result := TotalVariance(Data) / (High(Data) - Low(Data))
end;


{ Depreciation functions. }

function DoubleDecliningBalance(const Cost, Salvage: Extended; Life, Period: Integer): Extended;
{ dv := cost * (1 - 2/life)**(period - 1)
  DDB = (2/life) * dv
  if DDB > dv - salvage then DDB := dv - salvage
  if DDB < 0 then DDB := 0
}
var
  DepreciatedVal, Factor: Extended;
begin
  Result := 0;
  if (Period < 1) or (Life < Period) or (Life < 1) or (Cost <= Salvage) then
    Exit;

  {depreciate everything in period 1 if life is only one or two periods}
  if ( Life <= 2 ) then
  begin
    if ( Period = 1 ) then
      DoubleDecliningBalance:=Cost-Salvage
    else
      DoubleDecliningBalance:=0; {all depreciation occurred in first period}
    exit;
  end;
  Factor := 2.0 / Life;

  DepreciatedVal := Cost * IntPower((1.0 - Factor), Period - 1);
  {DepreciatedVal is Cost-(sum of previous depreciation results)}

  Result := Factor * DepreciatedVal;
  {Nominal computed depreciation for this period.  The rest of the
   function applies limits to this nominal value. }

  {Only depreciate until total depreciation equals cost-salvage.}
  if Result > DepreciatedVal - Salvage then
    Result := DepreciatedVal - Salvage;

  {No more depreciation after salvage value is reached.  This is mostly a nit.
   If Result is negative at this point, it's very close to zero.}
  if Result < 0.0 then
    Result := 0.0;
end;

function SLNDepreciation(const Cost, Salvage: Extended; Life: Integer): Extended;
{ Spreads depreciation linearly over life. }
begin
  if Life < 1 then ArgError('SLNDepreciation');
  Result := (Cost - Salvage) / Life
end;

function SYDDepreciation(const Cost, Salvage: Extended; Life, Period: Integer): Extended;
{ SYD = (cost - salvage) * (life - period + 1) / (life*(life + 1)/2) }
{ Note: life*(life+1)/2 = 1+2+3+...+life "sum of years"
        The depreciation factor varies from life/sum_of_years in first period = 1
                                       downto  1/sum_of_years in last period = life.
        Total depreciation over life is cost-salvage.}
var
  X1, X2: Extended;
begin
  Result := 0;
  if (Period < 1) or (Life < Period) or (Cost <= Salvage) then Exit;
  X1 := 2 * (Life - Period + 1);
  X2 := Life * (Life + 1);
  Result := (Cost - Salvage) * X1 / X2
end;

{ Discounted cash flow functions. }

function InternalRateOfReturn(const Guess: Extended; const CashFlows: array of Double): Extended;
{
Use Newton's method to solve NPV = 0, where NPV is a polynomial in
x = 1/(1+rate).  Split the coefficients into negative and postive sets:
  neg + pos = 0, so pos = -neg, so  -neg/pos = 1
Then solve:
  log(-neg/pos) = 0

  Let  t = log(1/(1+r) = -LnXP1(r)
  then r = exp(-t) - 1
Iterate on t, then use the last equation to compute r.
}
var
  T, Y: Extended;
  Poly: TPoly;
  K, Count: Integer;

  function ConditionP(const CashFlows: array of Double): Integer;
  { Guarantees existence and uniqueness of root.  The sign of payments
    must change exactly once, the net payout must be always > 0 for
    first portion, then each payment must be >= 0.
    Returns: 0 if condition not satisfied, > 0 if condition satisfied
    and this is the index of the first value considered a payback. }
  var
    X: Double;
    I, K: Integer;
  begin
    K := High(CashFlows);
    while (K >= 0) and (CashFlows[K] >= 0.0) do Dec(K);
    Inc(K);
    if K > 0 then
    begin
      X := 0.0;
      I := 0;
      while I < K do
      begin
        X := X + CashFlows[I];
        if X >= 0.0 then
        begin
          K := 0;
          Break;
        end;
        Inc(I)
      end
    end;
    ConditionP := K
  end;

begin
  InternalRateOfReturn := 0;
  K := ConditionP(CashFlows);
  if K < 0 then ArgError('InternalRateOfReturn');
  if K = 0 then
  begin
    if Guess <= -1.0 then ArgError('InternalRateOfReturn');
    T := -LnXP1(Guess)
  end else
    T := 0.0;
  for Count := 1 to MaxIterations do
  begin
    PolyX(CashFlows, Exp(T), Poly);
    if Poly.Pos <= Poly.Neg then ArgError('InternalRateOfReturn');
    if (Poly.Neg >= 0.0) or (Poly.Pos <= 0.0) then
    begin
      InternalRateOfReturn := -1.0;
      Exit;
    end;
    with Poly do
      Y := Ln(-Neg / Pos) / (DNeg / Neg - DPos / Pos);
    T := T - Y;
    if RelSmall(Y, T) then
    begin
      InternalRateOfReturn := Exp(-T) - 1.0;
      Exit;
    end
  end;
  ArgError('InternalRateOfReturn');
end;

function NetPresentValue(const Rate: Extended; const CashFlows: array of Double;
  PaymentTime: TPaymentTime): Extended;
{ Caution: The sign of NPV is reversed from what would be expected for standard
   cash flows!}
var
  rr: Extended;
  I: Integer;
begin
  if Rate <= -1.0 then ArgError('NetPresentValue');
  rr := 1/(1+Rate);
  result := 0;
  for I := High(CashFlows) downto Low(CashFlows) do
    result := rr * result + CashFlows[I];
  if PaymentTime = ptEndOfPeriod then result := rr * result;
end;

{ Annuity functions. }

{---------------
From the point of view of A, amounts received by A are positive and
amounts disbursed by A are negative (e.g. a borrower's loan repayments
are regarded by the borrower as negative).

Given interest rate r, number of periods n:
  compound(r, n) = (1 + r)**n               "Compounding growth factor"
  annuity(r, n) = (compound(r, n)-1) / r   "Annuity growth factor"

Given future value fv, periodic payment pmt, present value pv and type
of payment (start, 1 , or end of period, 0) pmtTime, financial variables satisfy:

  fv = -pmt*(1 + r*pmtTime)*annuity(r, n) - pv*compound(r, n)

For fv, pv, pmt:

  C := compound(r, n)
  A := (1 + r*pmtTime)*annuity(r, n)
  Compute both at once in Annuity2.

  if C > 1E16 then A = C/r, so:
    fv := meaningless
    pv := -pmt*(pmtTime+1/r)
    pmt := -pv*r/(1 + r*pmtTime)
  else
    fv := -pmt(1+r*pmtTime)*A - pv*C
    pv := (-pmt(1+r*pmtTime)*A - fv)/C
    pmt := (-pv*C-fv)/((1+r*pmtTime)*A)
---------------}

function PaymentParts(Period, NPeriods: Integer; Rate, PresentValue,
  FutureValue: Extended; PaymentTime: TPaymentTime; var IntPmt: Extended):
  Extended;
var
  Crn:extended; { =Compound(Rate,NPeriods) }
  Crp:extended; { =Compound(Rate,Period-1) }
  Arn:extended; { =Annuity2(...) }

begin
  if Rate <= -1.0 then ArgError('PaymentParts');
  Crp:=Compound(Rate,Period-1);
  Arn:=Annuity2(Rate,NPeriods,PaymentTime,Crn);
  IntPmt:=(FutureValue*(Crp-1)-PresentValue*(Crn-Crp))/Arn;
  PaymentParts:=(-FutureValue-PresentValue)*Crp/Arn;
end;

function FutureValue(const Rate: Extended; NPeriods: Integer; const Payment,
  PresentValue: Extended; PaymentTime: TPaymentTime): Extended;
var
  Annuity, CompoundRN: Extended;
begin
  if Rate <= -1.0 then ArgError('FutureValue');
  Annuity := Annuity2(Rate, NPeriods, PaymentTime, CompoundRN);
  if CompoundRN > 1.0E16 then ArgError('FutureValue');
  FutureValue := -Payment * Annuity - PresentValue * CompoundRN
end;

function InterestPayment(const Rate: Extended; Period, NPeriods: Integer;
  const PresentValue, FutureValue: Extended; PaymentTime: TPaymentTime): Extended;
var
  Crp:extended; { compound(rate,period-1)}
  Crn:extended; { compound(rate,nperiods)}
  Arn:extended; { annuityf(rate,nperiods)}
begin
  if (Rate <= -1.0)
    or (Period < 1) or (Period > NPeriods) then ArgError('InterestPayment');
  Crp:=Compound(Rate,Period-1);
  Arn:=Annuity2(Rate,Nperiods,PaymentTime,Crn);
  InterestPayment:=(FutureValue*(Crp-1)-PresentValue*(Crn-Crp))/Arn;
end;

function InterestRate(NPeriods: Integer; const Payment, PresentValue,
  FutureValue: Extended; PaymentTime: TPaymentTime): Extended;
{
Given:
  First and last payments are non-zero and of opposite signs.
  Number of periods N >= 2.
Convert data into cash flow of first, N-1 payments, last with
first < 0, payment > 0, last > 0.
Compute the IRR of this cash flow:
  0 = first + pmt*x + pmt*x**2 + ... + pmt*x**(N-1) + last*x**N
where x = 1/(1 + rate).
Substitute x = exp(t) and apply Newton's method to
  f(t) = log(pmt*x + ... + last*x**N) / -first
which has a unique root given the above hypotheses.
}
var
  X, Y, Z, First, Pmt, Last, T, ET, EnT, ET1: Extended;
  Count: Integer;
  Reverse: Boolean;

  function LostPrecision(X: Extended): Boolean;
  asm
        XOR     EAX, EAX
        MOV     BX,WORD PTR X+8
        INC     EAX
        AND     EBX, $7FF0
        JZ      @@1
        CMP     EBX, $7FF0
        JE      @@1
        XOR     EAX,EAX
  @@1:
  end;

begin
  Result := 0;
  if NPeriods <= 0 then ArgError('InterestRate');
  Pmt := Payment;
  if PaymentTime = ptEndOfPeriod then
  begin
    X := PresentValue;
    Y := FutureValue + Payment
  end
  else
  begin
    X := PresentValue + Payment;
    Y := FutureValue
  end;
  First := X;
  Last := Y;
  Reverse := False;
  if First * Payment > 0.0 then
  begin
    Reverse := True;
    T := First;
    First := Last;
    Last := T
  end;
  if first > 0.0 then
  begin
    First := -First;
    Pmt := -Pmt;
    Last := -Last
  end;
  if (First = 0.0) or (Last < 0.0) then ArgError('InterestRate');
  T := 0.0;                     { Guess at solution }
  for Count := 1 to MaxIterations do
  begin
    EnT := Exp(NPeriods * T);
    if {LostPrecision(EnT)} ent=(ent+1) then
    begin
      Result := -Pmt / First;
      if Reverse then
        Result := Exp(-LnXP1(Result)) - 1.0;
      Exit;
    end;
    ET := Exp(T);
    ET1 := ET - 1.0;
    if ET1 = 0.0 then
    begin
      X := NPeriods;
      Y := X * (X - 1.0) / 2.0
    end
    else
    begin
      X := ET * (Exp((NPeriods - 1) * T)-1.0) / ET1;
      Y := (NPeriods * EnT - ET - X * ET) / ET1
    end;
    Z := Pmt * X + Last * EnT;
    Y := Ln(Z / -First) / ((Pmt * Y + Last * NPeriods *EnT) / Z);
    T := T - Y;
    if RelSmall(Y, T) then
    begin
      if not Reverse then T := -T;
      InterestRate := Exp(T)-1.0;
      Exit;
    end
  end;
  ArgError('InterestRate');
end;

function NumberOfPeriods(const Rate: Extended; Payment: Extended;
  const PresentValue, FutureValue: Extended; PaymentTime: TPaymentTime): Extended;

{ If Rate = 0 then nper := -(pv + fv) / pmt
  else cf := pv + pmt * (1 + rate*pmtTime) / rate
       nper := LnXP1(-(pv + fv) / cf) / LnXP1(rate) }

var
  PVRPP: Extended; { =PV*Rate+Payment } {"initial cash flow"}
  T:     Extended;

begin

  if Rate <= -1.0 then ArgError('NumberOfPeriods');

{whenever both Payment and PaymentTime are given together, the PaymentTime has the effect
 of modifying the effective Payment by the interest accrued on the Payment}

  if ( PaymentTime=ptStartOfPeriod ) then
    Payment:=Payment*(1+Rate);

{if the payment exactly matches the interest accrued periodically on the
 presentvalue, then an infinite number of payments are going to be
 required to effect a change from presentvalue to futurevalue.  The
 following catches that specific error where payment is exactly equal,
 but opposite in sign to the interest on the present value.  If PVRPP
 ("initial cash flow") is simply close to zero, the computation will
 be numerically unstable, but not as likely to cause an error.}

  PVRPP:=PresentValue*Rate+Payment;
  if PVRPP=0 then ArgError('NumberOfPeriods');

  { 6.1E-5 approx= 2**-14 }
  if ( ABS(Rate)<6.1E-5 ) then
    Result:=-(PresentValue+FutureValue)/PVRPP
  else
  begin

{starting with the initial cash flow, each compounding period cash flow
 should result in the current value approaching the final value.  The
 following test combines a number of simultaneous conditions to ensure
 reasonableness of the cashflow before computing the NPER.}

    T:= -(PresentValue+FutureValue)*Rate/PVRPP;
    if  T<=-1.0  then ArgError('NumberOfPeriods');
    Result := LnXP1(T) / LnXP1(Rate)
  end;
  NumberOfPeriods:=Result;
end;

function Payment(Rate: Extended; NPeriods: Integer; const PresentValue,
  FutureValue: Extended; PaymentTime: TPaymentTime): Extended;
var
  Annuity, CompoundRN: Extended;
begin
  if Rate <= -1.0 then ArgError('Payment');
  Annuity := Annuity2(Rate, NPeriods, PaymentTime, CompoundRN);
  if CompoundRN > 1.0E16 then
    Payment := -PresentValue * Rate / (1 + Integer(PaymentTime) * Rate)
  else
    Payment := (-PresentValue * CompoundRN - FutureValue) / Annuity
end;

function PeriodPayment(const Rate: Extended; Period, NPeriods: Integer;
  const PresentValue, FutureValue: Extended; PaymentTime: TPaymentTime): Extended;
var
  Junk: Extended;
begin
  if (Rate <= -1.0) or (Period < 1) or (Period > NPeriods) then ArgError('PeriodPayment');
  PeriodPayment := PaymentParts(Period, NPeriods, Rate, PresentValue,
       FutureValue, PaymentTime, Junk);
end;

function PresentValue(const Rate: Extended; NPeriods: Integer; const Payment,
  FutureValue: Extended; PaymentTime: TPaymentTime): Extended;
var
  Annuity, CompoundRN: Extended;
begin
  if Rate <= -1.0 then ArgError('PresentValue');
  Annuity := Annuity2(Rate, NPeriods, PaymentTime, CompoundRN);
  if CompoundRN > 1.0E16 then
    PresentValue := -(Payment / Rate * Integer(PaymentTime) * Payment)
  else
    PresentValue := (-Payment * Annuity - FutureValue) / CompoundRN
end;

function GetRoundMode: TFPURoundingMode;
begin
  Result := TFPURoundingMode((Get8087CW shr 10) and 3);
end;

function SetRoundMode(const RoundMode: TFPURoundingMode): TFPURoundingMode;
var
  CtlWord: Word;
begin
  CtlWord := Get8087CW;
  Set8087CW((CtlWord and $F3FF) or (Ord(RoundMode) shl 10));
  Result := TFPURoundingMode((CtlWord shr 10) and 3);
end;

function GetPrecisionMode: TFPUPrecisionMode;
begin
  Result := TFPUPrecisionMode((Get8087CW shr 8) and 3);
end;

function SetPrecisionMode(const Precision: TFPUPrecisionMode): TFPUPrecisionMode;
var
  CtlWord: Word;
begin
  CtlWord := Get8087CW;
  Set8087CW((CtlWord and $FCFF) or (Ord(Precision) shl 8));
  Result := TFPUPrecisionMode((CtlWord shr 8) and 3);
end;

function GetExceptionMask: TFPUExceptionMask;
begin
  Byte(Result) := Get8087CW and $3F;
end;

function SetExceptionMask(const Mask: TFPUExceptionMask): TFPUExceptionMask;
var
  CtlWord: Word;
begin
  CtlWord := Get8087CW;
  Set8087CW( (CtlWord and $FFC0) or Byte(Mask) );
  Byte(Result) := CtlWord and $3F;
end;

procedure ClearExceptions(RaisePending: Boolean);
asm
  cmp al, 0
  jz @@clear
  fwait
@@clear:
  fnclex
end;

end.
