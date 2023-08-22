{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit VarConv;

interface

uses
  SysUtils, Variants, ConvUtils;

function VarConvertCreate(const AValue: Double; const AType: TConvType): Variant; overload;
function VarConvertCreate(const AValue: string): Variant; overload;

function VarConvert: TVarType;
function VarIsConvert(const AValue: Variant): Boolean;
function VarAsConvert(const AValue: Variant): Variant; overload;
function VarAsConvert(const AValue: Variant; const AType: TConvType): Variant; overload;

implementation

uses
  Math, Types;

type
  TConvertVariantType = class(TInvokeableVariantType)
  protected
    function RightPromotion(const V: TVarData; const Operator: TVarOp;
      out RequiredVarType: TVarType): Boolean; override;
  public
    procedure Clear(var V: TVarData); override;
    function IsClear(const V: TVarData): Boolean; override;
    procedure Copy(var Dest: TVarData; const Source: TVarData;
      const Indirect: Boolean); override;

    procedure UnaryOp(var Right: TVarData; const Operator: TVarOp);
      override;
    procedure BinaryOp(var Left: TVarData; const Right: TVarData;
      const Operator: TVarOp); override;
    procedure Compare(const Left: TVarData; const Right: TVarData;
      var Relationship: TVarCompareResult); override;

    procedure Cast(var Dest: TVarData; const Source: TVarData); override;
    procedure CastTo(var Dest: TVarData; const Source: TVarData;
      const AVarType: Word); override;

    function GetProperty(var Dest: TVarData; const V: TVarData;
      const Name: String): Boolean; override;
    function SetProperty(const V: TVarData; const Name: String;
      const Value: TVarData): Boolean; override;
  end;

  TConvertVarData = packed record
    VType: TVarType;
    VConvType: TConvType;
    Reserved1, Reserved2: Word;
    VValue: Double;
  end;

var
  ConvertVariantType: TConvertVariantType;

procedure VarConvertCreateInto(var ADest: Variant; const AValue: Double; const AType: TConvType);
begin
  VarClear(ADest);
  TConvertVarData(ADest).VType := VarConvert;
  TConvertVarData(ADest).VConvType := AType;
  TConvertVarData(ADest).VValue := AValue;
end;

function VarConvertCreate(const AValue: Double; const AType: TConvType): Variant;
begin
  VarConvertCreateInto(Result, AValue, AType);
end;

function VarConvertCreate(const AValue: string): Variant;
var
  LValue: Double;
  LType: TConvType;
begin
  if not TryStrToConvUnit(AValue, LValue, LType) then
    ConvertVariantType.RaiseCastError;
  VarConvertCreateInto(Result, LValue, LType);
end;

function VarConvert: TVarType;
begin
  Result := ConvertVariantType.VarType;
end;

function VarIsConvert(const AValue: Variant): Boolean;
begin
  Result := (TVarData(AValue).VType and varTypeMask) = VarConvert;
end;

function VarAsConvert(const AValue: Variant): Variant; overload;
begin
  if not VarIsConvert(AValue) then
    VarCast(Result, AValue, VarConvert)
  else
    Result := AValue;
end;

function VarAsConvert(const AValue: Variant; const AType: TConvType): Variant;
begin
  if not VarIsConvert(AValue) then
    Result := VarConvertCreate(AValue, AType)
  else
    Result := AValue;
end;


{ TConvertVariantType }

procedure TConvertVariantType.BinaryOp(var Left: TVarData;
  const Right: TVarData; const Operator: TVarOp);
var
  LValue: Double;
  LType: TConvType;
begin
  // supports...
  //   convvar + number      = convvar
  //   convvar - number      = convvar
  //   convvar * number      = convvar
  //   convvar / number      = convvar
  //   convvar div number    = convvar
  //     Add (subtract, etc) the number to the value contained in convvar
  //     convvar's type does not change

  //   convvar1 + convvar2   = convvar1
  //   convvar1 - convvar2   = convvar1
  //   convvar1 * convvar2   = !ERROR!
  //   convvar1 / convvar2   = double
  //   convvar1 div convvar2 = integer
  //     Add (subtract, etc) convvar2 and convvar1 after converting convvar2
  //     to convvar1's unit type.  Result's unit type will equal convvar1's type
  //     Please note that you currently cannot multiply two varConvert variants

  //  the right can also be a string, if it has unit info then it is treated
  //   like a varConvert else it is treated as a double
  {$RANGECHECKS ON}
  case Right.VType of
    varString:
      case Operator of
        opAdd:
          if TryStrToConvUnit(Variant(Right), LValue, LType) then
            if LType = CIllegalConvType then
              TConvertVarData(Left).VValue := TConvertVarData(Left).VValue + LValue
            else
              Variant(Left) := Variant(Left) + VarConvertCreate(LValue, LType)
          else
            RaiseCastError;
        opSubtract:
          if TryStrToConvUnit(Variant(Right), LValue, LType) then
            if LType = CIllegalConvType then
              TConvertVarData(Left).VValue := TConvertVarData(Left).VValue + LValue
            else
              Variant(Left) := Variant(Left) - VarConvertCreate(LValue, LType)
          else
            RaiseCastError;
        opMultiply:
          if TryStrToConvUnit(Variant(Right), LValue, LType) then
            if LType = CIllegalConvType then
              TConvertVarData(Left).VValue := TConvertVarData(Left).VValue * LValue
            else
              RaiseInvalidOp
          else
            RaiseCastError;
        opDivide:
          if TryStrToConvUnit(Variant(Right), LValue, LType) then
            if LType = CIllegalConvType then
              TConvertVarData(Left).VValue := TConvertVarData(Left).VValue / LValue
            else
              Variant(Left) := Variant(Left) / VarConvertCreate(LValue, LType)
          else
            RaiseCastError;
        opIntDivide:
          if TryStrToConvUnit(Variant(Right), LValue, LType) then
            if LType = CIllegalConvType then
              TConvertVarData(Left).VValue := Int(TConvertVarData(Left).VValue / LValue)
            else
              Variant(Left) := Variant(Left) div VarConvertCreate(LValue, LType)
          else
            RaiseCastError;
      else
        RaiseInvalidOp;
      end;
    varDouble:
      case Operator of
        opAdd:
          TConvertVarData(Left).VValue := TConvertVarData(Left).VValue +
                                          TVarData(Right).VDouble;
        opSubtract:
          TConvertVarData(Left).VValue := TConvertVarData(Left).VValue -
                                          TVarData(Right).VDouble;
        opMultiply:
          TConvertVarData(Left).VValue := TConvertVarData(Left).VValue *
                                          TVarData(Right).VDouble;
        opDivide:
          TConvertVarData(Left).VValue := TConvertVarData(Left).VValue /
                                          TVarData(Right).VDouble;
        opIntDivide:
          TConvertVarData(Left).VValue := Int(TConvertVarData(Left).VValue /
                                              TVarData(Right).VDouble);
      else
        RaiseInvalidOp;
      end;
  else
    if Left.VType = VarType then
      case Operator of
        opAdd:
          TConvertVarData(Left).VValue := ConvUnitInc(TConvertVarData(Left).VValue,
                                                      TConvertVarData(Left).VConvType,
                                                      TConvertVarData(Right).VValue,
                                                      TConvertVarData(Right).VConvType);
        opSubtract:
          TConvertVarData(Left).VValue := ConvUnitDec(TConvertVarData(Left).VValue,
                                                      TConvertVarData(Left).VConvType,
                                                      TConvertVarData(Right).VValue,
                                                      TConvertVarData(Right).VConvType);
        opDivide:
          Variant(Left) := TConvertVarData(Left).VValue /
                           Convert(TConvertVarData(Right).VValue,
                                   TConvertVarData(Right).VConvType,
                                   TConvertVarData(Left).VConvType);
        opIntDivide:
          Variant(Left) := Int(TConvertVarData(Left).VValue /
                               Convert(TConvertVarData(Right).VValue,
                                       TConvertVarData(Right).VConvType,
                                       TConvertVarData(Left).VConvType));
      else
        RaiseInvalidOp;
      end
    else
      RaiseInvalidOp;
  end;
  {$RANGECHECKS OFF}
end;

procedure TConvertVariantType.Cast(var Dest: TVarData; const Source: TVarData);
var
  LValue: Double;
  LType: TConvType;
begin
  if TryStrToConvUnit(VarDataToStr(Source), LValue, LType) then
  begin
    VarDataClear(Dest);
    TConvertVarData(Dest).VValue := LValue;
    TConvertVarData(Dest).VConvType := LType;
    Dest.VType := VarType;
  end
  else
    RaiseCastError;
end;

procedure TConvertVariantType.CastTo(var Dest: TVarData;
  const Source: TVarData; const AVarType: Word);
var
  LTemp: TVarData;
begin
  if Source.VType = VarType then
    case AVarType of
      varOleStr:
        VarDataFromOleStr(Dest, ConvUnitToStr(TConvertVarData(Source).VValue,
                                              TConvertVarData(Source).VConvType));
      varString:
        VarDataFromStr(Dest, ConvUnitToStr(TConvertVarData(Source).VValue,
                                           TConvertVarData(Source).VConvType));
    else
      VarDataInit(LTemp);
      try
        LTemp.VType := varDouble;
        LTemp.VDouble := TConvertVarData(Source).VValue;
        VarDataCastTo(Dest, LTemp, AVarType);
      finally
        VarDataClear(LTemp);
      end;
    end
  else
    RaiseCastError;
end;

procedure TConvertVariantType.Clear(var V: TVarData);
begin
  SimplisticClear(V);
end;

procedure TConvertVariantType.Compare(const Left, Right: TVarData;
  var Relationship: TVarCompareResult);
const
  CRelationshipToRelationship: array [TValueRelationship] of TVarCompareResult =
    (crLessThan, crEqual, crGreaterThan);
var
  LValue: Double;
  LType: TConvType;
  LRelationship: TValueRelationship;
begin
  // supports...
  //   convvar cmp number
  //     Compare the value of convvar and the given number

  //   convvar1 cmp convvar2
  //     Compare after converting convvar2 to convvar1's unit type

  //  The right can also be a string.  If the string has unit info then it is
  //    treated like a varConvert else it is treated as a double
  LRelationship := EqualsValue;
  case Right.VType of
    varString:
      if TryStrToConvUnit(Variant(Right), LValue, LType) then
        if LType = CIllegalConvType then
          LRelationship := CompareValue(TConvertVarData(Left).VValue, LValue)
        else
          LRelationship := ConvUnitCompareValue(TConvertVarData(Left).VValue,
                                                TConvertVarData(Left).VConvType,
                                                LValue, LType)
      else
        RaiseCastError;
    varDouble:
      LRelationship := CompareValue(TConvertVarData(Left).VValue,
                                    TVarData(Right).VDouble);
  else
    if Left.VType = VarType then
      LRelationship := ConvUnitCompareValue(TConvertVarData(Left).VValue,
                                            TConvertVarData(Left).VConvType,
                                            TConvertVarData(Right).VValue,
                                            TConvertVarData(Right).VConvType)
    else
      RaiseInvalidOp;
  end;
  Relationship := CRelationshipToRelationship[LRelationship];
end;

procedure TConvertVariantType.Copy(var Dest: TVarData;
  const Source: TVarData; const Indirect: Boolean);
begin
  SimplisticCopy(Dest, Source, Indirect);
end;

function TConvertVariantType.GetProperty(var Dest: TVarData;
  const V: TVarData; const Name: String): Boolean;
var
  LType: TConvType;
begin
  // supports...
  //   'Value'
  //   'Type'
  //   'TypeName'
  //   'Family'
  //   'FamilyName'
  //   'As[Type]'
  Result := True;
  if Name = 'VALUE' then
    Variant(Dest) := TConvertVarData(V).VValue
  else if Name = 'TYPE' then
    Variant(Dest) := TConvertVarData(V).VConvType
  else if Name = 'TYPENAME' then
    Variant(Dest) := ConvTypeToDescription(TConvertVarData(V).VConvType)
  else if Name = 'FAMILY' then
    Variant(Dest) := ConvTypeToFamily(TConvertVarData(V).VConvType)
  else if Name = 'FAMILYNAME' then
    Variant(Dest) := ConvFamilyToDescription(ConvTypeToFamily(TConvertVarData(V).VConvType))
  else if System.Copy(Name, 1, 2) = 'AS' then
  begin
    if DescriptionToConvType(ConvTypeToFamily(TConvertVarData(V).VConvType),
                             System.Copy(Name, 3, MaxInt), LType) then
      VarConvertCreateInto(Variant(Dest),
                           Convert(TConvertVarData(V).VValue,
                                   TConvertVarData(V).VConvType, LType),
                           LType)
    else
      Result := False;
  end
  else
    Result := False;
end;

function TConvertVariantType.IsClear(const V: TVarData): Boolean;
begin
  Result := TConvertVarData(V).VConvType = CIllegalConvType;
end;

function TConvertVariantType.RightPromotion(const V: TVarData;
  const Operator: TVarOp; out RequiredVarType: TVarType): Boolean;
begin
  // supports...
  //   Add, Subtract, Divide, IntDivide and Compare
  //     Ordinals (used as is), strings (converted to either an ordinal or
  //     another varConvert) and other varConvert (used as is) variants.
  //   Multiply
  //     Ordinals (used as is) and strings (converted to an ordinal).
  Result := True;
  case Operator of
    opAdd, opSubtract, opDivide, opIntDivide, opCompare:
      if VarDataIsNumeric(V) then
        RequiredVarType := varDouble
      else if VarDataIsStr(V) then
        RequiredVarType := varString
      else
        RequiredVarType := VarType;
    opMultiply:
      if VarDataIsNumeric(V) or VarDataIsStr(V) then
        RequiredVarType := varDouble
      else
        RaiseCastError;
  else
    RaiseInvalidOp;
  end;
end;

function TConvertVariantType.SetProperty(const V: TVarData;
  const Name: String; const Value: TVarData): Boolean;
begin
  // supports...
  //   'Value'
  Result := True;
  if Name = 'VALUE' then
    TConvertVarData(PVarData(@V)^).VValue := Variant(Value)
  else
    Result := False;
end;

procedure TConvertVariantType.UnaryOp(var Right: TVarData;
  const Operator: TVarOp);
begin
  // supports...
  //   '-'
  case Operator of
    opNegate:
      TConvertVarData(Right).VValue := -TConvertVarData(Right).VValue;
  else
    RaiseInvalidOp;
  end;
end;

initialization
  ConvertVariantType := TConvertVariantType.Create;
finalization
  FreeAndNil(ConvertVariantType);
end.

