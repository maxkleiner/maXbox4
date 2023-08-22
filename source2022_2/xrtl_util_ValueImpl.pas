unit xrtl_util_ValueImpl;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils, {$IFDEF HAS_UNIT_VARIANTS}Variants,{$ENDIF}
  xrtl_util_Compare, xrtl_util_Type, xrtl_util_Value, xrtl_util_Compat;

type
  TXRTLValueBase = class(TXRTLImplementationObjectProvider)
  end;

  IXRTLValueCardinal = interface(IXRTLValue)
  ['{D66BB411-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: Cardinal;
    function   SetValue(const AValue: Cardinal): Cardinal;
  end;

  TXRTLValueCardinal = class(TXRTLValueBase, IXRTLValue, IXRTLValueCardinal,
                             IXRTLImplementationObjectProvider)
  private
    FValue: Cardinal;
  public
    constructor Create(const AValue: Cardinal);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: Cardinal;
    function   SetValue(const AValue: Cardinal): Cardinal;
  end;

  IXRTLValueInteger = interface(IXRTLValue)
  ['{D66BB412-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: Integer;
    function   SetValue(const AValue: Integer): Integer;
  end;

  TXRTLValueInteger = class(TXRTLValueBase, IXRTLValue, IXRTLValueInteger,
                            IXRTLImplementationObjectProvider)
  private
    FValue: Integer;
  public
    constructor Create(const AValue: Integer);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: Integer;
    function   SetValue(const AValue: Integer): Integer;
  end;

  IXRTLValueInt64 = interface(IXRTLValue)
  ['{D66BB413-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: Int64;
    function   SetValue(const AValue: Int64): Int64;
  end;

  TXRTLValueInt64 = class(TXRTLValueBase, IXRTLValue, IXRTLValueInt64,
                          IXRTLImplementationObjectProvider)
  private
    FValue: Int64;
  public
    constructor Create(const AValue: Int64);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: Int64;
    function   SetValue(const AValue: Int64): Int64;
  end;

  IXRTLValueSingle = interface(IXRTLValue)
  ['{D66BB414-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: Single;
    function   SetValue(const AValue: Single): Single;
  end;

  TXRTLValueSingle = class(TXRTLValueBase, IXRTLValue, IXRTLValueSingle,
                           IXRTLImplementationObjectProvider)
  private
    FValue: Single;
  public
    constructor Create(const AValue: Single);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: Single;
    function   SetValue(const AValue: Single): Single;
  end;

  IXRTLValueDouble = interface(IXRTLValue)
  ['{D66BB415-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: Double;
    function   SetValue(const AValue: Double): Double;
  end;

  TXRTLValueDouble = class(TXRTLValueBase, IXRTLValue, IXRTLValueDouble,
                           IXRTLImplementationObjectProvider)
  private
    FValue: Double;
  public
    constructor Create(const AValue: Double);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: Double;
    function   SetValue(const AValue: Double): Double;
  end;

  IXRTLValueExtended = interface(IXRTLValue)
  ['{D66BB416-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: Extended;
    function   SetValue(const AValue: Extended): Extended;
  end;

  TXRTLValueExtended = class(TXRTLValueBase, IXRTLValue, IXRTLValueExtended,
                             IXRTLImplementationObjectProvider)
  private
    FValue: Extended;
  public
    constructor Create(const AValue: Extended);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: Extended;
    function   SetValue(const AValue: Extended): Extended;
  end;

  IXRTLValueInterface = interface(IXRTLValue)
  ['{D66BB417-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: IInterface;
    function   SetValue(const AValue: IInterface): IInterface;
  end;

  TXRTLValueInterface = class(TXRTLValueBase, IXRTLValue, IXRTLValueInterface,
                              IXRTLImplementationObjectProvider)
  private
    FValue: IInterface;
  public
    constructor Create(const AValue: IInterface);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: IInterface;
    function   SetValue(const AValue: IInterface): IInterface;
  end;

  IXRTLValueWideString = interface(IXRTLValue)
  ['{D66BB418-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: WideString;
    function   SetValue(const AValue: WideString): WideString;
  end;

  TXRTLValueWideString = class(TXRTLValueBase, IXRTLValue, IXRTLValueWideString,
                               IXRTLImplementationObjectProvider)
  private
    FHashCode: Cardinal;
    FValue: WideString;
  public
    constructor Create(const AValue: WideString);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: WideString;
    function   SetValue(const AValue: WideString): WideString;
  end;

  IXRTLValueObject = interface(IXRTLValue)
  ['{D66BB419-0554-4166-A138-DCECA5A63F83}']
    function   GetValue(const ADetachOwnership: Boolean): TObject;
    function   SetValue(const AValue: TObject): TObject;
  end;

  TXRTLValueObject = class(TXRTLValueBase, IXRTLValue, IXRTLValueObject,
                           IXRTLImplementationObjectProvider)
  private
    FValue: TObject;
    FOwnValue: Boolean;
  public
    constructor Create(const AValue: TObject; const AOwnValue: Boolean);
    destructor Destroy; override;
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue(const ADetachOwnership: Boolean): TObject;
    function   SetValue(const AValue: TObject): TObject;
    property   OwnValue: Boolean read FOwnValue write FOwnValue;
  end;

  IXRTLValuePointer = interface(IXRTLValue)
  ['{D66BB41A-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: Pointer;
    function   SetValue(const AValue: Pointer): Pointer;
  end;

  TXRTLValuePointer = class(TXRTLValueBase, IXRTLValue, IXRTLValuePointer,
                            IXRTLImplementationObjectProvider)
  private
    FValue: Pointer;
  public
    constructor Create(const AValue: Pointer);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: Pointer;
    function   SetValue(const AValue: Pointer): Pointer;
  end;

  IXRTLValueVariant = interface(IXRTLValue)
  ['{D66BB41B-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: Variant;
    function   SetValue(const AValue: Variant): Variant;
  end;

  TXRTLValueVariant = class(TXRTLValueBase, IXRTLValue, IXRTLValueVariant,
                            IXRTLImplementationObjectProvider)
  private
    FValue: Variant;
  public
    constructor Create(const AValue: Variant);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: Variant;
    function   SetValue(const AValue: Variant): Variant;
  end;

  IXRTLValueCurrency = interface(IXRTLValue)
  ['{D66BB41C-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: Currency;
    function   SetValue(const AValue: Currency): Currency;
  end;

  TXRTLValueCurrency = class(TXRTLValueBase, IXRTLValue, IXRTLValueCurrency,
                             IXRTLImplementationObjectProvider)
  private
    FValue: Currency;
  public
    constructor Create(const AValue: Currency);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: Currency;
    function   SetValue(const AValue: Currency): Currency;
  end;

  IXRTLValueComp = interface(IXRTLValue)
  ['{D66BB41D-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: Comp;
    function   SetValue(const AValue: Comp): Comp;
  end;

  TXRTLValueComp = class(TXRTLValueBase, IXRTLValue, IXRTLValueComp,
                         IXRTLImplementationObjectProvider)
  private
    FValue: Comp;
  public
    constructor Create(const AValue: Comp);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: Comp;
    function   SetValue(const AValue: Comp): Comp;
  end;

  IXRTLValueClass = interface(IXRTLValue)
  ['{D66BB41E-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: TClass;
    function   SetValue(const AValue: TClass): TClass;
  end;

  TXRTLValueClass = class(TXRTLValueBase, IXRTLValue, IXRTLValueClass,
                          IXRTLImplementationObjectProvider)
  private
    FValue: TClass;
  public
    constructor Create(const AValue: TClass);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: TClass;
    function   SetValue(const AValue: TClass): TClass;
  end;

  IXRTLValueGUID = interface(IXRTLValue)
  ['{D66BB41F-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: TGUID;
    function   SetValue(const AValue: TGUID): TGUID;
  end;

  TXRTLValueGUID = class(TXRTLValueBase, IXRTLValue, IXRTLValueGUID,
                         IXRTLImplementationObjectProvider)
  private
    FValue: TGUID;
  public
    constructor Create(const AValue: TGUID);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: TGUID;
    function   SetValue(const AValue: TGUID): TGUID;
  end;

  IXRTLValueBoolean = interface(IXRTLValue)
  ['{D66BB420-0554-4166-A138-DCECA5A63F83}']
    function   GetValue: Boolean;
    function   SetValue(const AValue: Boolean): Boolean;
  end;

  TXRTLValueBoolean = class(TXRTLValueBase, IXRTLValue, IXRTLValueBoolean,
                             IXRTLImplementationObjectProvider)
  private
    FValue: Boolean;
  public
    constructor Create(const AValue: Boolean);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   GetHashCode: Cardinal;
    function   GetValue: Boolean;
    function   SetValue(const AValue: Boolean): Boolean;
  end;

implementation

{ TXRTLValueCardinal }

constructor TXRTLValueCardinal.Create(const AValue: Cardinal);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueCardinal.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: Cardinal;
begin
  LValue:= XRTLGetAsCardinal(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FValue < LValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueCardinal.GetHashCode: Cardinal;
begin
  Result:= FValue;
end;

function TXRTLValueCardinal.GetValue: Cardinal;
begin
  Result:= FValue;
end;

function TXRTLValueCardinal.SetValue(const AValue: Cardinal): Cardinal;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueInteger }

constructor TXRTLValueInteger.Create(const AValue: Integer);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueInteger.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: Integer;
begin
  LValue:= XRTLGetAsInteger(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FValue < LValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueInteger.GetHashCode: Cardinal;
begin
  Result:= FValue;
end;

function TXRTLValueInteger.GetValue: Integer;
begin
  Result:= FValue;
end;

function TXRTLValueInteger.SetValue(const AValue: Integer): Integer;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueInt64 }

constructor TXRTLValueInt64.Create(const AValue: Int64);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueInt64.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: Int64;
begin
  LValue:= XRTLGetAsInt64(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FValue < LValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueInt64.GetHashCode: Cardinal;
begin
  Result:= FValue;
end;

function TXRTLValueInt64.GetValue: Int64;
begin
  Result:= FValue;
end;

function TXRTLValueInt64.SetValue(const AValue: Int64): Int64;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueSingle }

constructor TXRTLValueSingle.Create(const AValue: Single);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueSingle.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: Single;
begin
  LValue:= XRTLGetAsSingle(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FValue < LValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueSingle.GetHashCode: Cardinal;
begin
  Result:= Cardinal(Pointer(@FValue)^);
end;

function TXRTLValueSingle.GetValue: Single;
begin
  Result:= FValue;
end;

function TXRTLValueSingle.SetValue(const AValue: Single): Single;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueDouble }

constructor TXRTLValueDouble.Create(const AValue: Double);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueDouble.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: Double;
begin
  LValue:= XRTLGetAsDouble(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FValue < LValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueDouble.GetHashCode: Cardinal;
begin
  Result:= Int64Rec((@FValue)^).Lo xor Int64Rec((@FValue)^).Hi;
end;

function TXRTLValueDouble.GetValue: Double;
begin
  Result:= FValue;
end;

function TXRTLValueDouble.SetValue(const AValue: Double): Double;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueExtended }

constructor TXRTLValueExtended.Create(const AValue: Extended);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueExtended.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: Extended;
begin
  LValue:= XRTLGetAsExtended(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FValue < LValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueExtended.GetHashCode: Cardinal;
begin
  Result:= Int64Rec(Pointer(@FValue)^).Lo xor Int64Rec(Pointer(@FValue)^).Hi;
end;

function TXRTLValueExtended.GetValue: Extended;
begin
  Result:= FValue;
end;

function TXRTLValueExtended.SetValue(const AValue: Extended): Extended;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueInterface }

constructor TXRTLValueInterface.Create(const AValue: IInterface);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueInterface.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: IInterface;
  FCValue, LCValue: Cardinal;
  FIValue, LIValue: IXRTLComparable;
begin
  LValue:= XRTLGetAsInterface(IValue as IXRTLValue);
  if Supports(FValue, IXRTLComparable, FIValue) then
  begin
    Result:= FIValue.Compare(LValue);
    Exit;
  end;
  if Supports(LValue, IXRTLComparable, LIValue) then
  begin
    Result:= XRTLInvertNonEqualRelationship(LIValue.Compare(FValue));
    Exit;
  end;
  FCValue:= Cardinal(FValue);
  LCValue:= Cardinal(LValue);
  if FCValue = LCValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FCValue < LCValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueInterface.GetHashCode: Cardinal;
begin
  Result:= Cardinal(Pointer(FValue));
end;

function TXRTLValueInterface.GetValue: IInterface;
begin
  Result:= FValue;
end;

function TXRTLValueInterface.SetValue(const AValue: IInterface): IInterface;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueWideString }

constructor TXRTLValueWideString.Create(const AValue: WideString);
begin
  inherited Create;
  FHashCode:= 0;
  FValue:= AValue;
end;

function TXRTLValueWideString.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: WideString;
  RValue: Integer;
begin
  LValue:= XRTLGetAsWideString(IValue as IXRTLValue);
  RValue:= WideCompareStr(FValue, LValue);
  if RValue = 0 then
    Result:= XRTLEqualsValue
  else
  begin
    if RValue < 0 then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueWideString.GetHashCode: Cardinal;
var
  I: Integer;
begin
  if FHashCode = 0 then
  begin
    for I:= 1 to Length(FValue) do
    begin
      FHashCode:= 31 * FHashCode + Word(FValue[I]);
    end;
  end;
  Result:= FHashCode;
end;

function TXRTLValueWideString.GetValue: WideString;
begin
  Result:= FValue;
end;

function TXRTLValueWideString.SetValue(const AValue: WideString): WideString;
begin
  FHashCode:= 0;
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueObject }

constructor TXRTLValueObject.Create(const AValue: TObject; const AOwnValue: Boolean);
begin
  inherited Create;
  FValue:= AValue;
  FOwnValue:= AOwnValue;
end;

destructor TXRTLValueObject.Destroy;
begin
  if FOwnValue then
    FreeAndNil(FValue);
  inherited;
end;

function TXRTLValueObject.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: TObject;
  FOValue, LOValue: TXRTLValue;
  FCValue, LCValue: Cardinal;
begin
  XRTLGetAsObject(IValue as IXRTLValue, LValue);
  if XRTLIsAs(FValue, TXRTLValue, FOValue) then
  begin
    Result:= FOValue.Compare(LValue);
    Exit;
  end;
  if XRTLIsAs(LValue, TXRTLValue, LOValue) then
  begin
    Result:= XRTLInvertNonEqualRelationship(LOValue.Compare(FValue));
    Exit;
  end;
  FCValue:= Cardinal(FValue);
  LCValue:= Cardinal(LValue);
  if FCValue = LCValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FCValue < LCValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueObject.GetHashCode: Cardinal;
begin
  if FValue is TXRTLValue then
    Result:= (FValue as TXRTLValue).GetHashCode
  else
    Result:= Cardinal(Pointer(FValue));
end;

function TXRTLValueObject.GetValue(const ADetachOwnership: Boolean): TObject;
begin
  Result:= FValue;
  if ADetachOwnership then
    FOwnValue:= False;
end;

function TXRTLValueObject.SetValue(const AValue: TObject): TObject;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValuePointer }

constructor TXRTLValuePointer.Create(const AValue: Pointer);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValuePointer.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: Pointer;
begin
  LValue:= XRTLGetAsPointer(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if Cardinal(FValue) < Cardinal(LValue) then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValuePointer.GetHashCode: Cardinal;
begin
  Result:= Cardinal(FValue);
end;

function TXRTLValuePointer.GetValue: Pointer;
begin
  Result:= FValue;
end;

function TXRTLValuePointer.SetValue(const AValue: Pointer): Pointer;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueVariant }

constructor TXRTLValueVariant.Create(const AValue: Variant);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueVariant.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: Variant;
begin
  LValue:= XRTLGetAsVariant(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FValue < LValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueVariant.GetHashCode: Cardinal;
begin
  //Result:= VarType(FValue);
end;

function TXRTLValueVariant.GetValue: Variant;
begin
  Result:= FValue;
end;

function TXRTLValueVariant.SetValue(const AValue: Variant): Variant;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueCurrency }

constructor TXRTLValueCurrency.Create(const AValue: Currency);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueCurrency.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: Currency;
begin
  LValue:= XRTLGetAsCurrency(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FValue < LValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueCurrency.GetHashCode: Cardinal;
begin
  Result:= Int64Rec((@FValue)^).Lo xor Int64Rec((@FValue)^).Hi;
end;

function TXRTLValueCurrency.GetValue: Currency;
begin
  Result:= FValue;
end;

function TXRTLValueCurrency.SetValue(const AValue: Currency): Currency;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueComp }

constructor TXRTLValueComp.Create(const AValue: Comp);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueComp.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: Comp;
begin
  LValue:= XRTLGetAsComp(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FValue < LValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueComp.GetHashCode: Cardinal;
begin
  Result:= Int64Rec((@FValue)^).Lo xor Int64Rec((@FValue)^).Hi;
end;

function TXRTLValueComp.GetValue: Comp;
begin
  Result:= FValue;
end;

function TXRTLValueComp.SetValue(const AValue: Comp): Comp;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueClass }

constructor TXRTLValueClass.Create(const AValue: TClass);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueClass.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: TClass;
begin
  LValue:= XRTLGetAsClass(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if Cardinal(FValue) < Cardinal(LValue) then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueClass.GetHashCode: Cardinal;
begin
  Result:= Cardinal(FValue);
end;

function TXRTLValueClass.GetValue: TClass;
begin
  Result:= FValue;
end;

function TXRTLValueClass.SetValue(const AValue: TClass): TClass;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueGUID }

constructor TXRTLValueGUID.Create(const AValue: TGUID);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueGUID.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: TGUID;
  LSValue, FSValue: string;
  RValue: Integer;
begin
  LValue:= XRTLGetAsGUID(IValue as IXRTLValue);
  LSValue:= GUIDToString(LValue);
  FSValue:= GUIDToString(FValue);
  RValue:= CompareStr(FSValue, LSValue);
  if RValue = 0 then
    Result:= XRTLEqualsValue
  else
  begin
    if RValue < 0 then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueGUID.GetHashCode: Cardinal;
begin
  Result:= FValue.D1;
  Result:= Result * 31 + FValue.D2;
  Result:= Result * 31 + FValue.D3;
  Result:= Result * 31 + Word((@FValue.D4[0])^);
  Result:= Result * 31 + Word((@FValue.D4[2])^);
  Result:= Result * 31 + Word((@FValue.D4[4])^);
  Result:= Result * 31 + Word((@FValue.D4[6])^);
end;

function TXRTLValueGUID.GetValue: TGUID;
begin
  Result:= FValue;
end;

function TXRTLValueGUID.SetValue(const AValue: TGUID): TGUID;
begin
  Result:= FValue;
  FValue:= AValue;
end;

{ TXRTLValueBoolean }

constructor TXRTLValueBoolean.Create(const AValue: Boolean);
begin
  inherited Create;
  FValue:= AValue;
end;

function TXRTLValueBoolean.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LValue: Boolean;
begin
  LValue:= XRTLGetAsBoolean(IValue as IXRTLValue);
  if FValue = LValue then
    Result:= XRTLEqualsValue
  else
  begin
    if FValue < LValue then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
  end;
end;

function TXRTLValueBoolean.GetHashCode: Cardinal;
begin
  Result:= Cardinal(FValue);
end;

function TXRTLValueBoolean.GetValue: Boolean;
begin
  Result:= FValue;
end;

function TXRTLValueBoolean.SetValue(const AValue: Boolean): Boolean;
begin
  Result:= FValue;
  FValue:= AValue;
end;

end.

