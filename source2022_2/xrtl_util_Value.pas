unit xrtl_util_Value;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils, {$IFDEF HAS_UNIT_VARIANTS}Variants,{$ENDIF}
  xrtl_util_Compare, xrtl_util_Type, xrtl_util_Compat;

type
  IXRTLValue = interface(IXRTLComparable)
  ['{D66BB410-0554-4166-A138-DCECA5A63F83}']
    function   GetHashCode: Cardinal;
  end;

  TXRTLValue = class
    function   Compare(const IValue: TObject): TXRTLValueRelationship; virtual; abstract;
    function   GetHashCode: Cardinal; virtual; abstract;
  end;

  PXRTLValueArray = ^TXRTLValueArray;
  TXRTLValueArray = array of IXRTLValue;

function  XRTLValue(const AValue: Cardinal): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: Cardinal): Cardinal; overload;
function  XRTLGetAsCardinal(const IValue: IXRTLValue): Cardinal;
function  XRTLGetAsCardinalDef(const IValue: IXRTLValue; const DefValue: Cardinal = 0): Cardinal;

function  XRTLValue(const AValue: Integer): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: Integer): Integer; overload;
function  XRTLGetAsInteger(const IValue: IXRTLValue): Integer;
function  XRTLGetAsIntegerDef(const IValue: IXRTLValue; const DefValue: Integer = 0): Integer;

function  XRTLValue(const AValue: Int64): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: Int64): Int64; overload;
function  XRTLGetAsInt64(const IValue: IXRTLValue): Int64;
function  XRTLGetAsInt64Def(const IValue: IXRTLValue; const DefValue: Int64 = 0): Int64;

function  XRTLValue(const AValue: Single): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: Single): Single; overload;
function  XRTLGetAsSingle(const IValue: IXRTLValue): Single;
function  XRTLGetAsSingleDef(const IValue: IXRTLValue; const DefValue: Single = 0): Single;

function  XRTLValue(const AValue: Double): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: Double): Double; overload;
function  XRTLGetAsDouble(const IValue: IXRTLValue): Double;
function  XRTLGetAsDoubleDef(const IValue: IXRTLValue; const DefValue: Double = 0): Double;

function  XRTLValue(const AValue: Extended): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: Extended): Extended; overload;
function  XRTLGetAsExtended(const IValue: IXRTLValue): Extended;
function  XRTLGetAsExtendedDef(const IValue: IXRTLValue; const DefValue: Extended = 0): Extended;

function  XRTLValue(const AValue: IInterface): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: IInterface): IInterface; overload;
function  XRTLGetAsInterface(const IValue: IXRTLValue): IInterface; overload;
function  XRTLGetAsInterface(const IValue: IXRTLValue; out Obj): IInterface; overload;
function  XRTLGetAsInterfaceDef(const IValue: IXRTLValue; const DefValue: IInterface): IInterface; overload;
function  XRTLGetAsInterfaceDef(const IValue: IXRTLValue; out Obj; const DefValue: IInterface): IInterface; overload;

function  XRTLValue(const AValue: WideString): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: WideString): WideString; overload;
function  XRTLGetAsWideString(const IValue: IXRTLValue): WideString;
function  XRTLGetAsWideStringDef(const IValue: IXRTLValue; const DefValue: WideString = ''): WideString;

function  XRTLValue(const AValue: TObject; const AOwnValue: Boolean = False): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: TObject): TObject; overload;
function  XRTLGetAsObject(const IValue: IXRTLValue; const ADetachOwnership: Boolean = False): TObject; overload;
function  XRTLGetAsObject(const IValue: IXRTLValue; out Obj; const ADetachOwnership: Boolean = False): TObject; overload;
function  XRTLGetAsObjectDef(const IValue: IXRTLValue; const DefValue: TObject; const ADetachOwnership: Boolean = False): TObject; overload;
function  XRTLGetAsObjectDef(const IValue: IXRTLValue; out Obj; const DefValue: TObject; const ADetachOwnership: Boolean = False): TObject; overload;

function  XRTLValue(const AValue: Pointer): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: Pointer): Pointer; overload;
function  XRTLGetAsPointer(const IValue: IXRTLValue): Pointer;
function  XRTLGetAsPointerDef(const IValue: IXRTLValue; const DefValue: Pointer = nil): Pointer;

function  XRTLValueV(const AValue: Variant): IXRTLValue; overload;
function  XRTLSetValueV(const IValue: IXRTLValue; const AValue: Variant): Variant; overload;
function  XRTLGetAsVariant(const IValue: IXRTLValue): Variant;
function  XRTLGetAsVariantDef(const IValue: IXRTLValue; const DefValue: Variant): Variant;

function  XRTLValue(const AValue: Currency): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: Currency): Currency; overload;
function  XRTLGetAsCurrency(const IValue: IXRTLValue): Currency;
function  XRTLGetAsCurrencyDef(const IValue: IXRTLValue; const DefValue: Currency): Currency;

function  XRTLValue(const AValue: Comp): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: Comp): Comp; overload;
function  XRTLGetAsComp(const IValue: IXRTLValue): Comp;
function  XRTLGetAsCompDef(const IValue: IXRTLValue; const DefValue: Comp = 0): Comp;

function  XRTLValue(const AValue: TClass): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: TClass): TClass; overload;
function  XRTLGetAsClass(const IValue: IXRTLValue): TClass;
function  XRTLGetAsClassDef(const IValue: IXRTLValue; const DefValue: TClass = nil): TClass;

function  XRTLValue(const AValue: TGUID): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: TGUID): TGUID; overload;
function  XRTLGetAsGUID(const IValue: IXRTLValue): TGUID;
function  XRTLGetAsGUIDDef(const IValue: IXRTLValue; const DefValue: TGUID): TGUID;

function  XRTLValue(const AValue: Boolean): IXRTLValue; overload;
function  XRTLSetValue(const IValue: IXRTLValue; const AValue: Boolean): Boolean; overload;
function  XRTLGetAsBoolean(const IValue: IXRTLValue): Boolean;
function  XRTLGetAsBooleanDef(const IValue: IXRTLValue; const DefValue: Boolean = False): Boolean;

implementation

uses
  xrtl_util_ValueImpl;

function XRTLValue(const AValue: Cardinal): IXRTLValue;
begin
  Result:= TXRTLValueCardinal.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: Cardinal): Cardinal;
begin
  Result:= (IValue as IXRTLValueCardinal).SetValue(AValue);
end;

function XRTLGetAsCardinal(const IValue: IXRTLValue): Cardinal;
begin
  Result:= (IValue as IXRTLValueCardinal).GetValue;
end;

function XRTLGetAsCardinalDef(const IValue: IXRTLValue; const DefValue: Cardinal = 0): Cardinal;
var
  LValue: IXRTLValueCardinal;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueCardinal, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: Integer): IXRTLValue;
begin
  Result:= TXRTLValueInteger.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: Integer): Integer;
begin
  Result:= (IValue as IXRTLValueInteger).SetValue(AValue);
end;

function XRTLGetAsInteger(const IValue: IXRTLValue): Integer;
begin
  Result:= (IValue as IXRTLValueInteger).GetValue;
end;

function XRTLGetAsIntegerDef(const IValue: IXRTLValue; const DefValue: Integer = 0): Integer;
var
  LValue: IXRTLValueInteger;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueInteger, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: Int64): IXRTLValue;
begin
  Result:= TXRTLValueInt64.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: Int64): Int64;
begin
  Result:= (IValue as IXRTLValueInt64).SetValue(AValue);
end;

function XRTLGetAsInt64(const IValue: IXRTLValue): Int64;
begin
  Result:= (IValue as IXRTLValueInt64).GetValue;
end;

function XRTLGetAsInt64Def(const IValue: IXRTLValue; const DefValue: Int64 = 0): Int64;
var
  LValue: IXRTLValueInt64;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueInt64, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: Single): IXRTLValue;
begin
  Result:= TXRTLValueSingle.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: Single): Single;
begin
  Result:= (IValue as IXRTLValueSingle).SetValue(AValue);
end;

function XRTLGetAsSingle(const IValue: IXRTLValue): Single;
begin
  Result:= (IValue as IXRTLValueSingle).GetValue;
end;

function XRTLGetAsSingleDef(const IValue: IXRTLValue; const DefValue: Single = 0.0): Single;
var
  LValue: IXRTLValueSingle;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueSingle, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: Double): IXRTLValue;
begin
  Result:= TXRTLValueDouble.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: Double): Double;
begin
  Result:= (IValue as IXRTLValueDouble).SetValue(AValue);
end;

function XRTLGetAsDouble(const IValue: IXRTLValue): Double;
begin
  Result:= (IValue as IXRTLValueDouble).GetValue;
end;

function XRTLGetAsDoubleDef(const IValue: IXRTLValue; const DefValue: Double = 0.0): Double;
var
  LValue: IXRTLValueDouble;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueDouble, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: Extended): IXRTLValue;
begin
  Result:= TXRTLValueExtended.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: Extended): Extended;
begin
  Result:= (IValue as IXRTLValueExtended).SetValue(AValue);
end;

function XRTLGetAsExtended(const IValue: IXRTLValue): Extended;
begin
  Result:= (IValue as IXRTLValueExtended).GetValue;
end;

function XRTLGetAsExtendedDef(const IValue: IXRTLValue; const DefValue: Extended = 0.0): Extended;
var
  LValue: IXRTLValueExtended;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueExtended, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: IInterface): IXRTLValue;
begin
  Result:= TXRTLValueInterface.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: IInterface): IInterface;
begin
  (IValue as IXRTLValueInterface).SetValue(AValue);
end;

function XRTLGetAsInterface(const IValue: IXRTLValue): IInterface;
begin
  Result:= (IValue as IXRTLValueInterface).GetValue;
end;

function XRTLGetAsInterface(const IValue: IXRTLValue; out Obj): IInterface;
begin
  Result:= XRTLGetAsInterface(IValue);
  IInterface(Obj):= Result;
end;

function XRTLGetAsInterfaceDef(const IValue: IXRTLValue; const DefValue: IInterface): IInterface;
var
  LValue: IXRTLValueInterface;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueInterface, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLGetAsInterfaceDef(const IValue: IXRTLValue; out Obj; const DefValue: IInterface): IInterface;
begin
  Result:= XRTLGetAsInterfaceDef(IValue, DefValue);
  IInterface(Obj):= Result;
end;

function XRTLValue(const AValue: WideString): IXRTLValue;
begin
  Result:= TXRTLValueWideString.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: WideString): WideString;
begin
  Result:= (IValue as IXRTLValueWideString).SetValue(AValue);
end;

function XRTLGetAsWideString(const IValue: IXRTLValue): WideString;
begin
  Result:= (IValue as IXRTLValueWideString).GetValue;
end;

function XRTLGetAsWideStringDef(const IValue: IXRTLValue; const DefValue: WideString = ''): WideString;
var
  LValue: IXRTLValueWideString;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueWideString, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: TObject; const AOwnValue: Boolean = False): IXRTLValue;
begin
  Result:= TXRTLValueObject.Create(AValue, AOwnValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: TObject): TObject;
begin
  Result:= (IValue as IXRTLValueObject).SetValue(AValue);
end;

function XRTLGetAsObject(const IValue: IXRTLValue; const ADetachOwnership: Boolean = False): TObject;
begin
  Result:= (IValue as IXRTLValueObject).GetValue(ADetachOwnership);
end;

function XRTLGetAsObject(const IValue: IXRTLValue; out Obj; const ADetachOwnership: Boolean = False): TObject;
begin
  Result:= XRTLGetAsObject(IValue, ADetachOwnership);
  TObject(Obj):= Result;
end;

function XRTLGetAsObjectDef(const IValue: IXRTLValue; const DefValue: TObject; const ADetachOwnership: Boolean = False): TObject;
var
  LValue: IXRTLValueObject;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueObject, LValue) then
    Result:= LValue.GetValue(ADetachOwnership);
end;

function XRTLGetAsObjectDef(const IValue: IXRTLValue; out Obj;
  const DefValue: TObject; const ADetachOwnership: Boolean = False): TObject;
begin
  Result:= XRTLGetAsObjectDef(IValue, DefValue, ADetachOwnership);
  TObject(Obj):= Result;
end;

function XRTLValue(const AValue: Pointer): IXRTLValue;
begin
  Result:= TXRTLValuePointer.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: Pointer): Pointer;
begin
  Result:= (IValue as IXRTLValuePointer).SetValue(AValue);
end;

function XRTLGetAsPointer(const IValue: IXRTLValue): Pointer;
begin
  Result:= (IValue as IXRTLValuePointer).GetValue;
end;

function XRTLGetAsPointerDef(const IValue: IXRTLValue; const DefValue: Pointer = nil): Pointer;
var
  LValue: IXRTLValuePointer;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValuePointer, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValueV(const AValue: Variant): IXRTLValue;
begin
  Result:= TXRTLValueVariant.Create(AValue);
end;

function XRTLSetValueV(const IValue: IXRTLValue; const AValue: Variant): Variant;
begin
  Result:= (IValue as IXRTLValueVariant).SetValue(AValue);
end;

function XRTLGetAsVariant(const IValue: IXRTLValue): Variant;
begin
  Result:= (IValue as IXRTLValueVariant).GetValue;
end;

function XRTLGetAsVariantDef(const IValue: IXRTLValue; const DefValue: Variant): Variant;
var
  LValue: IXRTLValueVariant;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueVariant, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: Currency): IXRTLValue;
begin
  Result:= TXRTLValueCurrency.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: Currency): Currency;
begin
  Result:= (IValue as IXRTLValueCurrency).SetValue(AValue);
end;

function XRTLGetAsCurrency(const IValue: IXRTLValue): Currency;
begin
  Result:= (IValue as IXRTLValueCurrency).GetValue;
end;

function XRTLGetAsCurrencyDef(const IValue: IXRTLValue; const DefValue: Currency): Currency;
var
  LValue: IXRTLValueCurrency;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueCurrency, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: Comp): IXRTLValue;
begin
  Result:= TXRTLValueComp.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: Comp): Comp;
begin
  Result:= (IValue as IXRTLValueComp).SetValue(AValue);
end;

function XRTLGetAsComp(const IValue: IXRTLValue): Comp;
begin
  Result:= (IValue as IXRTLValueComp).GetValue;
end;

function XRTLGetAsCompDef(const IValue: IXRTLValue; const DefValue: Comp = 0): Comp;
var
  LValue: IXRTLValueComp;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueComp, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: TClass): IXRTLValue;
begin
  Result:= TXRTLValueClass.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: TClass): TClass;
begin
  Result:= (IValue as IXRTLValueClass).SetValue(AValue);
end;

function XRTLGetAsClass(const IValue: IXRTLValue): TClass;
begin
  Result:= (IValue as IXRTLValueClass).GetValue;
end;

function XRTLGetAsClassDef(const IValue: IXRTLValue; const DefValue: TClass = nil): TClass;
var
  LValue: IXRTLValueClass;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueClass, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: TGUID): IXRTLValue;
begin
  Result:= TXRTLValueGUID.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: TGUID): TGUID;
begin
  Result:= (IValue as IXRTLValueGUID).SetValue(AValue);
end;

function XRTLGetAsGUID(const IValue: IXRTLValue): TGUID;
begin
  Result:= (IValue as IXRTLValueGUID).GetValue;
end;

function XRTLGetAsGUIDDef(const IValue: IXRTLValue; const DefValue: TGUID): TGUID;
var
  LValue: IXRTLValueGUID;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueGUID, LValue) then
    Result:= LValue.GetValue;
end;

function XRTLValue(const AValue: Boolean): IXRTLValue;
begin
  Result:= TXRTLValueBoolean.Create(AValue);
end;

function XRTLSetValue(const IValue: IXRTLValue; const AValue: Boolean): Boolean;
begin
  Result:= (IValue as IXRTLValueBoolean).SetValue(AValue);
end;

function XRTLGetAsBoolean(const IValue: IXRTLValue): Boolean;
begin
  Result:= (IValue as IXRTLValueBoolean).GetValue;
end;

function XRTLGetAsBooleanDef(const IValue: IXRTLValue; const DefValue: Boolean = False): Boolean;
var
  LValue: IXRTLValueBoolean;
begin
  Result:= DefValue;
  if Supports(IValue, IXRTLValueBoolean, LValue) then
    Result:= LValue.GetValue;
end;

end.

