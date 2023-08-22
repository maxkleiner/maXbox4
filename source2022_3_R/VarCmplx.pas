{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit VarCmplx;

{ This unit contains complex number handling via a custom variant type.
  The native format for complex numbers in this is rectangular [x + yi] but
  limited conversion support for polar format [r*CIS(theta)] is provided.

  Some of the functions, concepts or constants in this unit were provided by
  Earl F. Glynn (www.efg2.com), who in turn, made the following acknowledgments..

    Some ideas in this UNIT were borrowed from "A Pascal Tool for Complex
    Numbers", Journal of Pascal, Ada, & Modula-2, May/June 1985, pp. 23-29.
    Many complex formulas were taken from Chapter 4, "Handbook of Mathematical
    Functions" (Ninth Printing), Abramowitz and Stegun (editors), Dover, 1972.

  Some of the functions and concepts in this unit have been cross checked
  against: Wolfram Research's mathematical functions site (functions.wolfram.com).

  Additional help and concepts were provided by Matthias Thoma.
}

interface

uses
  Variants;

{ Complex variant creation utils }

function VarComplexCreate: Variant; overload;
function VarComplexCreate(const AReal: Double): Variant; overload;
function VarComplexCreate(const AReal, AImaginary: Double): Variant; overload;
function VarComplexCreate(const AText: string): Variant; overload;

function VarComplex: TVarType;
function VarIsComplex(const AValue: Variant): Boolean;
function VarAsComplex(const AValue: Variant): Variant;
function VarComplexSimplify(const AValue: Variant): Variant;

{ Complex variant support }

function VarComplexAbsSqr(const AValue: Variant): Double;
function VarComplexAbs(const AValue: Variant): Double;
function VarComplexAngle(const AValue: Variant): Double;
function VarComplexSign(const AValue: Variant): Variant;
function VarComplexConjugate(const AValue: Variant): Variant;
function VarComplexInverse(const AValue: Variant): Variant;
function VarComplexExp(const AValue: Variant): Variant;
function VarComplexLn(const AValue: Variant): Variant;
function VarComplexLog2(const AValue: Variant): Variant;
function VarComplexLog10(const AValue: Variant): Variant;
function VarComplexLogN(const AValue: Variant; const X: Double): Variant;
function VarComplexSqr(const AValue: Variant): Variant;
function VarComplexSqrt(const AValue: Variant): Variant;
function VarComplexPower(const AValue, APower: Variant): Variant;
function VarComplexTimesPosI(const AValue: Variant): Variant;
function VarComplexTimesNegI(const AValue: Variant): Variant;
function VarComplexTimesImaginary(const AValue: Variant; const AFactor: Double): Variant;
function VarComplexTimesReal(const AValue: Variant; const AFactor: Double): Variant;

{ Complex variant trig support }

function VarComplexCos(const AValue: Variant): Variant;
function VarComplexSin(const AValue: Variant): Variant;
function VarComplexTan(const AValue: Variant): Variant;
function VarComplexCot(const AValue: Variant): Variant;
function VarComplexSec(const AValue: Variant): Variant;
function VarComplexCsc(const AValue: Variant): Variant;
function VarComplexArcCos(const AValue: Variant): Variant;
function VarComplexArcSin(const AValue: Variant): Variant;
function VarComplexArcTan(const AValue: Variant): Variant;
function VarComplexArcCot(const AValue: Variant): Variant;
function VarComplexArcSec(const AValue: Variant): Variant;
function VarComplexArcCsc(const AValue: Variant): Variant;
function VarComplexCosH(const AValue: Variant): Variant;
function VarComplexSinH(const AValue: Variant): Variant;
function VarComplexTanH(const AValue: Variant): Variant;
function VarComplexCotH(const AValue: Variant): Variant;
function VarComplexSecH(const AValue: Variant): Variant;
function VarComplexCscH(const AValue: Variant): Variant;
function VarComplexArcCosH(const AValue: Variant): Variant;
function VarComplexArcSinH(const AValue: Variant): Variant;
function VarComplexArcTanH(const AValue: Variant): Variant;
function VarComplexArcCotH(const AValue: Variant): Variant;
function VarComplexArcSecH(const AValue: Variant): Variant;
function VarComplexArcCscH(const AValue: Variant): Variant;

procedure VarComplexToPolar(const AValue: Variant; var ARadius, ATheta: Double;
  AFixTheta: Boolean = True);
function VarComplexFromPolar(const ARadius, ATheta: Double): Variant;

var
  ComplexNumberSymbol: string = 'i';
  ComplexNumberSymbolBeforeImaginary: Boolean = False;
  ComplexNumberDefuzzAtZero: Boolean = True;

implementation

uses
  Windows, VarUtils, SysUtils, Math, SysConst, RTLConsts, TypInfo, Classes;

type
  { Complex variant type handler }
  TComplexVariantType = class(TPublishableVariantType, IVarStreamable)
  protected
    function LeftPromotion(const V: TVarData; const Operator: TVarOp;
      out RequiredVarType: TVarType): Boolean; override;
    function GetInstance(const V: TVarData): TObject; override;
  public
    procedure Clear(var V: TVarData); override;
    function IsClear(const V: TVarData): Boolean; override;
    procedure Copy(var Dest: TVarData; const Source: TVarData;
      const Indirect: Boolean); override;
    procedure Cast(var Dest: TVarData; const Source: TVarData); override;
    procedure CastTo(var Dest: TVarData; const Source: TVarData;
      const AVarType: TVarType); override;

    procedure BinaryOp(var Left: TVarData; const Right: TVarData;
      const Operator: TVarOp); override;
    procedure UnaryOp(var Right: TVarData; const Operator: TVarOp); override;
    function CompareOp(const Left: TVarData; const Right: TVarData;
      const Operator: Integer): Boolean; override;

    procedure StreamIn(var Dest: TVarData; const Stream: TStream);
    procedure StreamOut(const Source: TVarData; const Stream: TStream);
  end;

var
  { Complex variant type handler instance }
  ComplexVariantType: TComplexVariantType = nil;

type
  { Complex data that the complex variant points to }
  TComplexData = class(TPersistent)
  private
    FReal, FImaginary: Double;
    function GetAsString: String;
    procedure SetAsString(const Value: String);
    function GetRadius: Double;
    function GetTheta: Double;
    function GetFixedTheta: Double;
    procedure SetReal(const AValue: Double);
    procedure SetImaginary(const AValue: Double);
  protected
    procedure SetValueToComplexInfinity;
    procedure SetValue(const AReal: Double; const AImaginary: Double = 0); overload;
    procedure SetValue(const AData: TComplexData); overload;
  public

    // the many ways to create
    constructor Create(const AReal: Double); overload;
    constructor Create(const AReal, AImaginary: Double); overload;
    constructor Create(const AText: string); overload;
    constructor Create(const AData: TComplexData); overload;

    // non-destructive operations
    function GetAbsSqr: Double;
    function GetAbs: Double;
    function GetAngle: Double;
    function Equals(const Right: TComplexData): Boolean; reintroduce; overload;
    function Equals(const AText: string): Boolean; reintroduce; overload;
    function Equals(const AReal, AImaginary: Double): Boolean; reintroduce; overload;
    function IsZero: Boolean;

    // conversion operations
    procedure GetAsPolar(var ARadius, ATheta: Double; AFixTheta: Boolean = True);
    procedure SetAsPolar(const ARadius, ATheta: Double);

    // destructive operations
    procedure DoAdd(const Right: TComplexData); overload;
    procedure DoAdd(const AReal, AImaginary: Double); overload;
    procedure DoSubtract(const Right: TComplexData); overload;
    procedure DoSubtract(const AReal, AImaginary: Double); overload;
    procedure DoMultiply(const Right: TComplexData); overload;
    procedure DoMultiply(const AReal, AImaginary: Double); overload;
    procedure DoDivide(const Right: TComplexData); overload;
    procedure DoDivide(const AReal, AImaginary: Double); overload;

    // inverted versions of the above (ie. value - self instead of self - value)
    procedure DoInvAdd(const AReal, AImaginary: Double);
    procedure DoInvSubtract(const AReal, AImaginary: Double);
    procedure DoInvMultiply(const AReal, AImaginary: Double);
    procedure DoInvDivide(const AReal, AImaginary: Double);

    procedure DoNegate;
    procedure DoSign;
    procedure DoConjugate;
    procedure DoInverse;
    procedure DoExp;
    procedure DoLn;
    procedure DoLog10;
    procedure DoLog2;
    procedure DoLogN(const X: Double);
    procedure DoSqr;
    procedure DoSqrt;
    procedure DoTimesImaginary(const AValue: Double);
    procedure DoTimesReal(const AValue: Double);
    procedure DoPower(const APower: TComplexData);

    procedure DoCos;
    procedure DoSin;
    procedure DoTan;
    procedure DoCot;
    procedure DoCsc;
    procedure DoSec;

    procedure DoArcCos;
    procedure DoArcSin;
    procedure DoArcTan;
    procedure DoArcCot;
    procedure DoArcCsc;
    procedure DoArcSec;

    procedure DoCosH;
    procedure DoSinH;
    procedure DoTanH;
    procedure DoCotH;
    procedure DoCscH;
    procedure DoSecH;

    procedure DoArcCosH;
    procedure DoArcSinH;
    procedure DoArcTanH;
    procedure DoArcCotH;
    procedure DoArcCscH;
    procedure DoArcSecH;

    // conversion
    property AsString: String read GetAsString write SetAsString;
  published
    property Real: Double read FReal write SetReal;
    property Imaginary: Double read FImaginary write SetImaginary;
    property Radius: Double read GetRadius;
    property Theta: Double read GetTheta;
    property FixedTheta: Double read GetFixedTheta;
  end;

  { Helper record that helps crack open TVarData }
  TComplexVarData = packed record
    VType: TVarType;
    Reserved1, Reserved2, Reserved3: Word;
    VComplex: TComplexData;
    Reserved4: LongInt;
  end;

{ TComplexData }

constructor TComplexData.Create(const AReal: Double);
begin
  inherited Create;
  SetValue(AReal);
end;

constructor TComplexData.Create(const AReal, AImaginary: Double);
begin
  inherited Create;
  SetValue(AReal, AImaginary);
end;

constructor TComplexData.Create(const AText: string);
begin
  inherited Create;
  AsString := AText;
end;

constructor TComplexData.Create(const AData: TComplexData);
begin
  inherited Create;
  SetValue(AData.Real, AData.Imaginary);
end;

function TComplexData.GetAsString: String;
const
  cFormats: array [Boolean] of string = ('%2:g %1:s %3:g%0:s',
                                         '%2:g %1:s %0:s%3:g'); { do not localize }
  cSign: array [Boolean] of string = ('-', '+');
begin
  Result := Format(cFormats[ComplexNumberSymbolBeforeImaginary],
    [ComplexNumberSymbol, cSign[Imaginary >= 0], Real, Abs(Imaginary)]);
end;

procedure TComplexData.DoNegate;
begin
  SetValue(-Real, -Imaginary);
end;

procedure TComplexData.DoSign;
var
  LTemp: TComplexData;
begin
  if not IsZero then
  begin
    LTemp := TComplexData.Create(Real * Real + Imaginary * Imaginary);
    try
      LTemp.DoSqrt;
      DoDivide(LTemp);
    finally
      LTemp.Free;
    end;
  end;
end;

procedure TComplexData.SetAsString(const Value: String);
var
  LPart, LLeftover: string;
  LReal, LImaginary: Double;
  LSign: Integer;

  function ParseNumber(const AText: string; out ARest: string;
    out ANumber: Double): Boolean;
  var
    LAt: Integer;
    LFirstPart: string;
  begin
    Result := True;
    Val(AText, ANumber, LAt);
    if LAt <> 0 then
    begin
      ARest := Copy(AText, LAt, MaxInt);
      LFirstPart := Copy(AText, 1, LAt - 1);
      Val(LFirstPart, ANumber, LAt);
      if LAt <> 0 then
        Result := False;
    end;
  end;

  function ParseWhiteSpace(const AText: string; out ARest: string): Boolean;
  var
    LAt: Integer;
  begin
    LAt := 1;
    if AText <> '' then
    begin
      while AText[LAt] = ' ' do
        Inc(LAt);
      ARest := Copy(AText, LAt, MaxInt);
    end;
    Result := ARest <> '';
  end;

  procedure ParseError(const AMessage: string);
  begin
    raise EConvertError.CreateFmt(SCmplxErrorSuffix, [AMessage,
      Copy(Value, 1, Length(Value) - Length(LLeftOver)),
      Copy(Value, Length(Value) - Length(LLeftOver) + 1, MaxInt)]);
  end;

  procedure ParseErrorEOS;
  begin
    raise EConvertError.CreateFmt(SCmplxUnexpectedEOS, [Value]);
  end;
begin
  // where to start?
  LLeftover := Value;

  // first get the real portion
  if not ParseNumber(LLeftover, LPart, LReal) then
    ParseError(SCmplxCouldNotParseReal);

  // is that it?
  if not ParseWhiteSpace(LPart, LLeftover) then
    SetValue(LReal)

  // if there is more then parse the complex part
  else
  begin

    // look for the concat symbol
    LSign := 1;
    if LLeftover[1] = '-' then
      LSign := -1
    else if LLeftover[1] <> '+' then
      ParseError(SCmplxCouldNotParsePlus);
    LPart := Copy(LLeftover, 2, MaxInt);

    // skip any whitespace
    ParseWhiteSpace(LPart, LLeftover);

    // symbol before?
    if ComplexNumberSymbolBeforeImaginary then
    begin
      if not AnsiSameText(Copy(LLeftOver, 1, Length(ComplexNumberSymbol)),
                          ComplexNumberSymbol) then
        ParseError(Format(SCmplxCouldNotParseSymbol, [ComplexNumberSymbol]));
      LPart := Copy(LLeftover, Length(ComplexNumberSymbol) + 1, MaxInt);

      // skip any whitespace
      ParseWhiteSpace(LPart, LLeftover);
    end;

    // imaginary part
    if not ParseNumber(LLeftover, LPart, LImaginary) then
      ParseError(SCmplxCouldNotParseImaginary);

    // correct for sign
    LImaginary := LImaginary * LSign;

    // symbol after?
    if not ComplexNumberSymbolBeforeImaginary then
    begin
      // skip any whitespace
      ParseWhiteSpace(LPart, LLeftover);

      // make sure there is symbol!
      if not AnsiSameText(Copy(LLeftOver, 1, Length(ComplexNumberSymbol)),
                          ComplexNumberSymbol) then
        ParseError(Format(SCmplxCouldNotParseSymbol, [ComplexNumberSymbol]));
      LPart := Copy(LLeftover, Length(ComplexNumberSymbol) + 1, MaxInt);
    end;

    // make sure the rest of the string is whitespaces
    ParseWhiteSpace(LPart, LLeftover);
    if LLeftover <> '' then
      ParseError(SCmplxUnexpectedChars);

    // make it then
    SetValue(LReal, LImaginary);
  end;
end;

procedure TComplexData.DoAdd(const Right: TComplexData);
begin
  SetValue(Real + Right.Real, Imaginary + Right.Imaginary);
end;

procedure TComplexData.DoAdd(const AReal, AImaginary: Double);
begin
  SetValue(Real + AReal, Imaginary + AImaginary);
end;

procedure TComplexData.DoInvAdd(const AReal, AImaginary: Double);
begin
  SetValue(AReal + Real, AImaginary + Imaginary);
end;

procedure TComplexData.DoSubtract(const Right: TComplexData);
begin
  SetValue(Real - Right.Real, Imaginary - Right.Imaginary);
end;

procedure TComplexData.DoSubtract(const AReal, AImaginary: Double);
begin
  SetValue(Real - AReal, Imaginary - AImaginary);
end;

procedure TComplexData.DoInvSubtract(const AReal, AImaginary: Double);
begin
  SetValue(AReal - Real, AImaginary - Imaginary);
end;

procedure TComplexData.DoMultiply(const Right: TComplexData);
begin
  DoMultiply(Right.Real, Right.Imaginary);
end;

procedure TComplexData.DoMultiply(const AReal, AImaginary: Double);
begin
  SetValue((Real * AReal) - (Imaginary * AImaginary),
          (Real * AImaginary) + (Imaginary * AReal));
end;

procedure TComplexData.DoInvMultiply(const AReal, AImaginary: Double);
begin
  SetValue((AReal * Real) - (AImaginary * Imaginary),
          (AReal * Imaginary) + (AImaginary * Real));
end;

procedure TComplexData.DoDivide(const Right: TComplexData);
begin
  DoDivide(Right.Real, Right.Imaginary);
end;

procedure TComplexData.DoDivide(const AReal, AImaginary: Double);
var
  LDenominator: Double;
begin
  LDenominator := (AReal * AReal) + (AImaginary * AImaginary);
  if Math.IsZero(LDenominator) then
    raise EZeroDivide.Create(SDivByZero);
  SetValue(((Real * AReal) + (Imaginary * AImaginary)) / LDenominator,
          ((Imaginary * AReal) - (Real * AImaginary)) / LDenominator);
end;

procedure TComplexData.DoInvDivide(const AReal, AImaginary: Double);
var
  LDenominator: Double;
begin
  LDenominator := GetAbsSqr;
  if Math.IsZero(LDenominator) then
    raise EZeroDivide.Create(SDivByZero);
  SetValue(((AReal * Real) + (AImaginary * Imaginary)) / LDenominator,
          ((AImaginary * Real) - (AReal * Imaginary)) / LDenominator);
end;

procedure TComplexData.SetValueToComplexInfinity;
begin
  FReal := NaN;
  FImaginary := NaN;
end;

procedure TComplexData.SetReal(const AValue: Double);
begin
  FReal := AValue;
  if ComplexNumberDefuzzAtZero and Math.IsZero(FReal) then
    FReal := 0;
end;

procedure TComplexData.SetImaginary(const AValue: Double);
begin
  FImaginary := AValue;
  if ComplexNumberDefuzzAtZero and Math.IsZero(FImaginary) then
    FImaginary := 0;
end;

procedure TComplexData.SetValue(const AReal, AImaginary: Double);
begin
  Real := AReal;
  Imaginary := AImaginary;
end;

procedure TComplexData.SetValue(const AData: TComplexData);
begin
  Real := AData.Real;
  Imaginary := AData.Imaginary;
end;

function TComplexData.GetAbs: Double;
begin
  Result := Sqrt(GetAbsSqr);
end;

function TComplexData.GetAbsSqr: Double;
begin
  Result := Real * Real + Imaginary * Imaginary;
end;

function TComplexData.GetAngle: Double;
begin
  Result := ArcTan2(Imaginary, Real);
end;

procedure TComplexData.DoCos;
begin
  SetValue(Cos(Real) * CosH(Imaginary), -Sin(Real) * SinH(Imaginary));
end;

procedure TComplexData.DoSin;
begin
  SetValue(Sin(Real) * CosH(Imaginary), Cos(Real) * SinH(Imaginary));
end;

procedure TComplexData.DoTan;
var
  LDenominator: Double;
begin
  if Equals(PI / 2, 0) then
    SetValueToComplexInfinity
  else
  begin
    LDenominator := Cos(2.0 * Real) + CosH(2.0 * Imaginary);
    if Math.IsZero(LDenominator) then
      raise EZeroDivide.Create(SDivByZero);
    SetValue(Sin(2.0 * Real) / LDenominator, SinH(2.0 * Imaginary) / LDenominator);
  end;
end;

procedure TComplexData.DoCot;
var
  LTemp: TComplexData;
begin
  if IsZero then
    SetValueToComplexInfinity
  else
  begin
    LTemp := TComplexData.Create(Self);
    try
      LTemp.DoSin;
      DoCos;
      DoDivide(LTemp);
    finally
      LTemp.Free;
    end;
  end;
end;

procedure TComplexData.DoCsc;
begin
  if IsZero then
    SetValueToComplexInfinity
  else
  begin
    DoSin;
    DoInvDivide(1, 0);
  end;
end;

procedure TComplexData.DoSec;
begin
  if Equals(PI / 2, 0) then
    SetValueToComplexInfinity
  else
  begin
    DoCos;
    DoInvDivide(1, 0);
  end;
end;

procedure TComplexData.DoArcCos;
var
  LTemp: TComplexData;
begin
  LTemp := TComplexData.Create(Self);
  try
    LTemp.DoSqr;
    LTemp.DoInvSubtract(1, 0);
    LTemp.DoSqrt;
    DoTimesImaginary(1);
    DoAdd(LTemp);
    DoLn;
    DoTimesImaginary(1);
    DoInvAdd(PI / 2, 0);
  finally
    LTemp.Free;
  end;
end;

procedure TComplexData.DoArcSin;
var
  LTemp: TComplexData;
begin
  LTemp := TComplexData.Create(Self);
  try
    LTemp.DoSqr;
    LTemp.DoInvSubtract(1, 0);
    LTemp.DoSqrt;
    DoTimesImaginary(1);
    DoAdd(LTemp);
    DoLn;
    DoTimesImaginary(-1);
  finally
    LTemp.Free;
  end;
end;

procedure TComplexData.DoArcTan;
var
  LTemp1, LTemp2: TComplexData;
begin
  if Equals(0, 1) then
    SetValue(0, Infinity)
  else if Equals(0, -1) then
    SetValue(0, -Infinity)
  else
  begin
    LTemp1 := nil;
    LTemp2 := nil;
    try
      LTemp1 := TComplexData.Create(Self);
      LTemp1.DoTimesImaginary(1);
      LTemp2 := TComplexData.Create(LTemp1);
      LTemp1.DoInvSubtract(1, 0);
      LTemp1.DoLn;
      LTemp2.DoInvAdd(1, 0);
      LTemp2.DoLn;
      LTemp1.DoSubtract(LTemp2);
      SetValue(0, 1);
      DoDivide(2, 0);
      DoMultiply(LTemp1);
    finally
      LTemp2.Free;
      LTemp1.Free;
    end;
  end;
end;

procedure TComplexData.DoArcCot;
begin
  DoInverse;
  DoArcTan;
end;

procedure TComplexData.DoArcCsc;
begin
  if IsZero then
    SetValueToComplexInfinity
  else
  begin
    DoInverse;
    DoArcSin;
  end;
end;

procedure TComplexData.DoArcSec;
begin
  if IsZero then
    SetValueToComplexInfinity
  else
  begin
    DoInverse;
    DoArcCos;
  end;
end;


procedure TComplexData.DoCosH;
begin
  SetValue(CosH(Real) * Cos(Imaginary), SinH(Real) * Sin(Imaginary));
end;

procedure TComplexData.DoSinH;
begin
  SetValue(SinH(Real) * Cos(Imaginary), CosH(Real) * Sin(Imaginary));
end;

procedure TComplexData.DoTanH;
var
  LTemp: TComplexData;
begin
  if IsZero then
    SetValue(0)
  else
  begin
    LTemp := TComplexData.Create(Self);
    try
      LTemp.DoCosH;
      DoSinH;
      DoDivide(LTemp);
    finally
      LTemp.Free;
    end;
  end;
end;

procedure TComplexData.DoCotH;
begin
  if IsZero then
    SetValueToComplexInfinity
  else
  begin
    DoTanH;
    DoInverse;
  end;
end;

procedure TComplexData.DoCscH;
begin
  if IsZero then
    SetValueToComplexInfinity
  else
  begin
    DoSinH;
    DoInverse;
  end;
end;

procedure TComplexData.DoSecH;
begin
  DoCosH;
  DoInverse;
end;

procedure TComplexData.DoArcCosH;
var
  LTemp1, LTemp2: TComplexData;
begin
  LTemp1 := nil;
  LTemp2 := nil;
  try
    LTemp1 := TComplexData.Create(Self);
    LTemp1.DoAdd(1, 0);
    LTemp1.DoSqrt;
    LTemp2 := TComplexData.Create(Self);
    LTemp2.DoSubtract(1, 0);
    LTemp2.DoSqrt;
    LTemp2.DoMultiply(LTemp1);
    DoAdd(LTemp2);
    DoLn;
  finally
    LTemp2.Free;
    LTemp1.Free;
  end;
end;

procedure TComplexData.DoArcSinH;
begin
  DoTimesImaginary(1.0);
  DoArcSin;
  DoTimesImaginary(-1.0);
end;

procedure TComplexData.DoArcTanH;
begin
  if Equals(1, 0) then
    SetValue(Infinity)
  else if Equals(-1, 0) then
    SetValue(-Infinity)
  else
  begin
    DoTimesImaginary(1.0);
    DoArcTan;
    DoTimesImaginary(-1.0);
  end;
end;

procedure TComplexData.DoArcCotH;
begin
  if Equals(1, 0) then
    SetValue(Infinity)
  else if Equals(-1, 0) then
    SetValue(-Infinity)
  else
  begin
    DoInverse;
    DoArcTanH;
  end;
end;

procedure TComplexData.DoArcCscH;
begin
  if IsZero then
    SetValueToComplexInfinity
  else
  begin
    DoInverse;
    DoArcSinH;
  end;
end;

procedure TComplexData.DoArcSecH;
begin
  if IsZero then
    SetValue(Infinity)
  else
  begin
    DoInverse;
    DoArcCosH;
  end;
end;

procedure TComplexData.DoConjugate;
begin
  Imaginary := -Imaginary;
end;

procedure TComplexData.DoExp;
var
  LExp: Double;
begin
  LExp := Exp(Real);
  SetValue(LExp * Cos(Imaginary), LExp * Sin(Imaginary));
end;

procedure TComplexData.DoInverse;
var
  LDenominator: Double;
begin
  LDenominator := GetAbsSqr;
  if Math.IsZero(LDenominator) then
    raise EZeroDivide.Create(SDivByZero);
  SetValue(Real / LDenominator, -(Imaginary / LDenominator));
end;

procedure TComplexData.DoLn;
var
  LRadius, LTheta: Double;
begin
  if IsZero then
    SetValue(-Infinity)
  else
  begin
    GetAsPolar(LRadius, LTheta);
    SetValue(Ln(LRadius), LTheta);
  end;
end;

procedure TComplexData.DoLog10;
var
  LRadius, LTheta: Double;
begin
  if IsZero then
    SetValue(-Infinity)
  else
  begin
    GetAsPolar(LRadius, LTheta);
    SetValue(Ln(LRadius), LTheta);
    DoDivide(Ln(10), 0);
  end;
end;

procedure TComplexData.DoLog2;
var
  LRadius, LTheta: Double;
begin
  if IsZero then
    SetValue(-Infinity)
  else
  begin
    GetAsPolar(LRadius, LTheta);
    SetValue(Ln(LRadius), LTheta);
    DoDivide(Ln(2), 0);
  end;
end;

procedure TComplexData.DoLogN(const X: Double);
var
  LRadius, LTheta: Double;
  LTemp: TComplexData;
begin
  if IsZero and (X > 0) and (X <> 1) then
    SetValue(-Infinity)
  else
  begin
    LTemp := TComplexData.Create(X);
    try
      LTemp.DoLn;
      GetAsPolar(LRadius, LTheta);
      SetValue(Ln(LRadius), LTheta);
      DoDivide(LTemp);
    finally
      LTemp.Free;
    end;
  end;
end;

procedure TComplexData.DoSqr;
begin
  SetValue((Real * Real) - (Imaginary * Imaginary),
          (Real * Imaginary) + (Imaginary * Real));
end;

procedure TComplexData.DoSqrt;
var
  LValue: Double;
begin
  if not IsZero then
    if Real > 0 then
    begin
      LValue := GetAbs + Real;
      SetValue(Sqrt(LValue / 2), Imaginary / Sqrt(LValue * 2));
    end
    else
    begin
      LValue := GetAbs - Real;
      if Imaginary < 0 then
        SetValue(Abs(Imaginary) / Sqrt(LValue * 2),
                -Sqrt(LValue / 2))
      else
        SetValue(Abs(Imaginary) / Sqrt(LValue * 2),
                Sqrt(LValue / 2));
    end;
end;

procedure TComplexData.DoTimesImaginary(const AValue: Double);
begin
  SetValue(-AValue * Imaginary, AValue * Real);
end;

procedure TComplexData.DoTimesReal(const AValue: Double);
begin
  SetValue(AValue * Real, AValue * Imaginary);
end;

function TComplexData.IsZero: Boolean;
begin
  Result := Math.IsZero(Real) and Math.IsZero(Imaginary);
end;

function TComplexData.Equals(const Right: TComplexData): Boolean;
begin
  Result := Math.SameValue(Real, Right.Real) and
            Math.SameValue(Imaginary, Right.Imaginary);
end;

function TComplexData.Equals(const AReal, AImaginary: Double): Boolean;
begin
  Result := Math.SameValue(Real, AReal) and Math.SameValue(Imaginary, AImaginary);
end;

function TComplexData.Equals(const AText: string): Boolean;
begin
  Result := AnsiSameText(AsString, AText);
end;

procedure TComplexData.DoPower(const APower: TComplexData);
begin
  if Math.IsZero(GetAbsSqr) then
    if Math.IsZero(APower.GetAbsSqr) then
      SetValue(1)
    else
      SetValue(0)
  else
  begin
    DoLn;
    DoMultiply(APower);
    DoExp;
  end;
end;

procedure TComplexData.GetAsPolar(var ARadius, ATheta: Double; AFixTheta: Boolean);
begin
  ATheta := ArcTan2(Imaginary, Real);
  ARadius := Sqrt(Real * Real + Imaginary * Imaginary);
  if AFixTheta then
  begin
    while ATheta > Pi do
      ATheta := ATheta - 2.0 * Pi;
    while ATheta <= -Pi do
      ATheta := ATheta + 2.0 * Pi;
  end;
end;

procedure TComplexData.SetAsPolar(const ARadius, ATheta: Double);
begin
  SetValue(ARadius * Cos(ATheta), ARadius * Sin(ATheta));
end;

function TComplexData.GetRadius: Double;
var
  Temp: Double;
begin
  GetAsPolar(Result, Temp);
end;

function TComplexData.GetTheta: Double;
var
  Temp: Double;
begin
  GetAsPolar(Temp, Result, False);
end;

function TComplexData.GetFixedTheta: Double;
var
  Temp: Double;
begin
  GetAsPolar(Temp, Result, True);
end;

{ TComplexVariantType }

procedure TComplexVariantType.BinaryOp(var Left: TVarData;
  const Right: TVarData; const Operator: TVarOp);
begin
  if Right.VType = VarType then
    case Left.VType of
      varString:
        case Operator of
          opAdd:
            Variant(Left) := Variant(Left) + TComplexVarData(Right).VComplex.AsString;
        else
          RaiseInvalidOp;
        end;
    else
      if Left.VType = VarType then
        case Operator of
          opAdd:
            TComplexVarData(Left).VComplex.DoAdd(TComplexVarData(Right).VComplex);
          opSubtract:
            TComplexVarData(Left).VComplex.DoSubtract(TComplexVarData(Right).VComplex);
          opMultiply:
            TComplexVarData(Left).VComplex.DoMultiply(TComplexVarData(Right).VComplex);
          opDivide:
            TComplexVarData(Left).VComplex.DoDivide(TComplexVarData(Right).VComplex);
        else
          RaiseInvalidOp;
        end
      else
        RaiseInvalidOp;
    end
  else
    RaiseInvalidOp;
end;

procedure TComplexVariantType.Cast(var Dest: TVarData; const Source: TVarData);
var
  LSource, LTemp: TVarData;
begin
  VarDataInit(LSource);
  try
    VarDataCopyNoInd(LSource, Source);
    VarDataClear(Dest);
    if VarDataIsStr(LSource) then
      TComplexVarData(Dest).VComplex := TComplexData.Create(VarDataToStr(LSource))
    else
    begin
      VarDataInit(LTemp);
      try
        VarDataCastTo(LTemp, LSource, varDouble);
        TComplexVarData(Dest).VComplex := TComplexData.Create(LTemp.VDouble);
      finally
        VarDataClear(LTemp);
      end;
    end;
    Dest.VType := VarType;
  finally
    VarDataClear(LSource);
  end;
end;

procedure TComplexVariantType.CastTo(var Dest: TVarData; const Source: TVarData;
  const AVarType: TVarType);
var
  LTemp: TVarData;
begin
  if Source.VType = VarType then
    case AVarType of
      varOleStr:
        VarDataFromOleStr(Dest, TComplexVarData(Source).VComplex.AsString);
      varString:
        VarDataFromStr(Dest, TComplexVarData(Source).VComplex.AsString);
    else
      VarDataInit(LTemp);
      try
        LTemp.VType := varDouble;
        LTemp.VDouble := TComplexVarData(Source).VComplex.Real;
        VarDataCastTo(Dest, LTemp, AVarType);
      finally
        VarDataClear(LTemp);
      end;
    end
  else
    inherited;
end;

procedure TComplexVariantType.Clear(var V: TVarData);
begin
  V.VType := varEmpty;
  FreeAndNil(TComplexVarData(V).VComplex);
end;

function TComplexVariantType.CompareOp(const Left, Right: TVarData;
  const Operator: Integer): Boolean;
begin
  Result := False;
  if (Left.VType = VarType) and (Right.VType = VarType) then
    case Operator of
      opCmpEQ:
        Result := TComplexVarData(Left).VComplex.Equals(TComplexVarData(Right).VComplex);
      opCmpNE:
        Result := not TComplexVarData(Left).VComplex.Equals(TComplexVarData(Right).VComplex);
    else
      RaiseInvalidOp;
    end
  else
    RaiseInvalidOp;
end;

procedure TComplexVariantType.Copy(var Dest: TVarData; const Source: TVarData;
  const Indirect: Boolean);
begin
  if Indirect and VarDataIsByRef(Source) then
    VarDataCopyNoInd(Dest, Source)
  else
    with TComplexVarData(Dest) do
    begin
      VType := VarType;
      VComplex := TComplexData.Create(TComplexVarData(Source).VComplex);
    end;
end;

function TComplexVariantType.GetInstance(const V: TVarData): TObject;
begin
  Result := TComplexVarData(V).VComplex;
end;

function TComplexVariantType.IsClear(const V: TVarData): Boolean;
begin
  Result := (TComplexVarData(V).VComplex = nil) or
            TComplexVarData(V).VComplex.IsZero;
end;

function TComplexVariantType.LeftPromotion(const V: TVarData;
  const Operator: TVarOp; out RequiredVarType: TVarType): Boolean;
begin
  { TypeX Op Complex }
  if (Operator = opAdd) and VarDataIsStr(V) then
    RequiredVarType := varString
  else
    RequiredVarType := VarType;

  Result := True;
end;

procedure TComplexVariantType.StreamIn(var Dest: TVarData;
  const Stream: TStream);
begin
  with TReader.Create(Stream, 1024) do
  try
    with TComplexVarData(Dest) do
    begin
      // Order of execution of the ReadFloat is important.  If we executed
      // VComplex := TComplexData.Create(ReadFloat, ReadFloat) then, depending
      // on the mood of the compiler, the two calls to readfloats might
      // execute backwards (21 instead of 12).
      VComplex := TComplexData.Create;
      VComplex.Real := ReadFloat;
      VComplex.Imaginary := ReadFloat;
    end;
  finally
    Free;
  end;
end;

procedure TComplexVariantType.StreamOut(const Source: TVarData;
  const Stream: TStream);
begin
  with TWriter.Create(Stream, 1024) do
  try
    with TComplexVarData(Source).VComplex do
    begin
      WriteFloat(Real);
      WriteFloat(Imaginary);
    end;
  finally
    Free;
  end;
end;

procedure TComplexVariantType.UnaryOp(var Right: TVarData;
  const Operator: TVarOp);
begin
  if Right.VType = VarType then
    case Operator of
      opNegate:
        TComplexVarData(Right).VComplex.DoNegate;
    else
      RaiseInvalidOp;
    end
  else
    RaiseInvalidOp;
end;

{ Complex variant creation utils }

procedure VarComplexCreateInto(var ADest: Variant; const AComplex: TComplexData);
begin
  VarClear(ADest);
  TComplexVarData(ADest).VType := VarComplex;
  TComplexVarData(ADest).VComplex := AComplex;
end;

function VarComplexCreate: Variant;
begin
  VarComplexCreateInto(Result, TComplexData.Create(0));
end;

function VarComplexCreate(const AReal: Double): Variant;
begin
  VarComplexCreateInto(Result, TComplexData.Create(AReal));
end;

function VarComplexCreate(const AReal, AImaginary: Double): Variant;
begin
  VarComplexCreateInto(Result, TComplexData.Create(AReal, AImaginary));
end;

function VarComplexCreate(const AText: string): Variant;
begin
  VarComplexCreateInto(Result, TComplexData.Create(AText));
end;

function VarComplex: TVarType;
begin
  Result := ComplexVariantType.VarType;
end;

function VarIsComplex(const AValue: Variant): Boolean;
begin
  Result := (TVarData(AValue).VType and varTypeMask) = VarComplex;
end;

function VarAsComplex(const AValue: Variant): Variant;
begin
  if not VarIsComplex(AValue) then
    VarCast(Result, AValue, VarComplex)
  else
    Result := AValue;
end;

function VarComplexSimplify(const AValue: Variant): Variant;
begin
  if VarIsComplex(AValue) and
     Math.IsZero(TComplexVarData(AValue).VComplex.Imaginary) then
    Result := TComplexVarData(AValue).VComplex.Real
  else
    Result := AValue;
end;

{ Complex variant support }

function VarComplexAbsSqr(const AValue: Variant): Double;
var
  LTemp: Variant;
begin
  VarCast(LTemp, AValue, VarComplex);
  Result := TComplexVarData(LTemp).VComplex.GetAbsSqr;
end;

function VarComplexAbs(const AValue: Variant): Double;
var
  LTemp: Variant;
begin
  VarCast(LTemp, AValue, VarComplex);
  Result := TComplexVarData(LTemp).VComplex.GetAbs;
end;

function VarComplexAngle(const AValue: Variant): Double;
var
  LTemp: Variant;
begin
  VarCast(LTemp, AValue, VarComplex);
  Result := TComplexVarData(LTemp).VComplex.GetAngle;
end;

function VarComplexSign(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoSign;
end;

function VarComplexConjugate(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoConjugate;
end;

function VarComplexInverse(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoInverse;
end;

function VarComplexExp(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoExp;
end;

function VarComplexLn(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoLn;
end;

function VarComplexLog10(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoLog10;
end;

function VarComplexLog2(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoLog2;
end;

function VarComplexLogN(const AValue: Variant; const X: Double): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoLogN(X);
end;

function VarComplexSqr(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoSqr;
end;

function VarComplexSqrt(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoSqrt;
end;

function VarComplexTimesPosI(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoTimesImaginary(1.0);
end;

function VarComplexTimesNegI(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoTimesImaginary(-1.0);
end;

function VarComplexTimesImaginary(const AValue: Variant; const AFactor: Double): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoTimesImaginary(AFactor);
end;

function VarComplexTimesReal(const AValue: Variant; const AFactor: Double): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoTimesReal(AFactor);
end;

function VarComplexPower(const AValue, APower: Variant): Variant;
var
  LTemp: Variant;
begin
  VarCast(Result, AValue, VarComplex);
  VarCast(LTemp, APower, VarComplex);
  TComplexVarData(Result).VComplex.DoPower(TComplexVarData(LTemp).VComplex);
end;

{ Complex variant trig support }

function VarComplexCos(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoCos;
end;

function VarComplexSin(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoSin;
end;

function VarComplexTan(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoTan;
end;

function VarComplexCot(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoCot;
end;

function VarComplexSec(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoSec;
end;

function VarComplexCsc(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoCsc;
end;

function VarComplexArcCos(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcCos;
end;

function VarComplexArcSin(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcSin;
end;

function VarComplexArcTan(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcTan;
end;

function VarComplexArcCot(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcCot;
end;

function VarComplexArcSec(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcSec;
end;

function VarComplexArcCsc(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcCsc;
end;

function VarComplexCosH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoCosH;
end;

function VarComplexSinH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoSinH;
end;

function VarComplexTanH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoTanH;
end;

function VarComplexCotH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoCotH;
end;

function VarComplexSecH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoSecH;
end;

function VarComplexCscH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoCscH;
end;

function VarComplexArcCosH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcCosH;
end;

function VarComplexArcSinH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcSinH;
end;

function VarComplexArcTanH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcTanH;
end;

function VarComplexArcCotH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcCotH;
end;

function VarComplexArcSecH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcSecH;
end;

function VarComplexArcCscH(const AValue: Variant): Variant;
begin
  VarCast(Result, AValue, VarComplex);
  TComplexVarData(Result).VComplex.DoArcCscH;
end;

procedure VarComplexToPolar(const AValue: Variant; var ARadius, ATheta: Double;
  AFixTheta: Boolean);
var
  Temp: Variant;
begin
  VarCast(Temp, AValue, VarComplex);
  TComplexVarData(Temp).VComplex.GetAsPolar(ARadius, ATheta, AFixTheta);
end;

function VarComplexFromPolar(const ARadius, ATheta: Double): Variant;
begin
  Result := VarComplexCreate;
  TComplexVarData(Result).VComplex.SetAsPolar(ARadius, ATheta);
end;

initialization
  ComplexVariantType := TComplexVariantType.Create;
finalization
  FreeAndNil(ComplexVariantType);
end.
