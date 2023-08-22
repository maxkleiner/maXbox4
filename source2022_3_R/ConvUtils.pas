{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

{*******************************************************}
{   Conversions engine, no built in conversion types    }
{*******************************************************}

unit ConvUtils;

interface

uses
  SysUtils, Math, Types;

type
  TConvFamily = type Word;
  TConvType = type Word;
  TConversionProc = function(const AValue: Double): Double;
  TConvTypeArray = array of TConvType;
  TConvFamilyArray = array of TConvFamily;

// Simple conversion between two measurement types
function Convert(const AValue: Double;
  const AFrom, ATo: TConvType): Double; overload;

// Complex conversion between two double measurement types.  An example of
//  this would be converting miles per hour to meters per minute (speed) or
//  gallons per minute to liters per hour (flow).  There are lots of
//  combinations but not all of them make much sense.
function Convert(const AValue: Double;
  const AFrom1, AFrom2, ATo1, ATo2: TConvType): Double; overload;

// Convert from and to the base unit type for a particular conversion family
function ConvertFrom(const AFrom: TConvType; const AValue: Double): Double;
function ConvertTo(const AValue: Double; const ATo: TConvType): Double;

// Add/subtract two values together and return the result in a specified type
function ConvUnitAdd(const AValue1: Double; const AType1: TConvType;
  const AValue2: Double; const AType2, AResultType: TConvType): Double;
function ConvUnitDiff(const AValue1: Double; const AType1: TConvType;
  const AValue2: Double; const AType2, AResultType: TConvType): Double;

// Increment/decrement a value by a value of a specified type
function ConvUnitInc(const AValue: Double;
  const AType, AAmountType: TConvType): Double; overload;
function ConvUnitInc(const AValue: Double; const AType: TConvType;
  const AAmount: Double; const AAmountType: TConvType): Double; overload;
function ConvUnitDec(const AValue: Double;
  const AType, AAmountType: TConvType): Double; overload;
function ConvUnitDec(const AValue: Double; const AType: TConvType;
  const AAmount: Double; const AAmountType: TConvType): Double; overload;

// Test to see if a given value is within the previous (or next) given units of
//   of a certian type
function ConvUnitWithinPrevious(const AValue, ATest: Double;
  const AType: TConvType; const AAmount: Double;
  const AAmountType: TConvType): Boolean;
function ConvUnitWithinNext(const AValue, ATest: Double; const AType: TConvType;
  const AAmount: Double; const AAmountType: TConvType): Boolean;

// Comparison and Equality testing
function ConvUnitCompareValue(const AValue1: Double; const AType1: TConvType;
  const AValue2: Double; const AType2: TConvType): TValueRelationship;
function ConvUnitSameValue(const AValue1: Double; const AType1: TConvType;
  const AValue2: Double; const AType2: TConvType): Boolean;

// (un)Registation of conversion types.  You should unregister your conversion
//   types when the unit that registered them is finalized or is no longer used.

function RegisterConversionType(const AFamily: TConvFamily;
  const ADescription: string; const AFactor: Double): TConvType; overload;
function RegisterConversionType(const AFamily: TConvFamily;
  const ADescription: string; const AToCommonProc,
  AFromCommonProc: TConversionProc): TConvType; overload;
procedure UnregisterConversionType(const AType: TConvType);

// (un)Registation of conversion families.  You should unregister your
//   conversion families when the unit that registered them is finalized or is
//   no longer used.

function RegisterConversionFamily(const ADescription: string): TConvFamily;
procedure UnregisterConversionFamily(const AFamily: TConvFamily);

// Compatibility testing

function CompatibleConversionTypes(const AFrom, ATo: TConvType): Boolean;
function CompatibleConversionType(const AType: TConvType;
  const AFamily: TConvFamily): Boolean;

// Discovery support functions

procedure GetConvTypes(const AFamily: TConvFamily; out ATypes: TConvTypeArray);
procedure GetConvFamilies(out AFamilies: TConvFamilyArray);

// String parsing support

function StrToConvUnit(AText: string; out AType: TConvType): Double;
function TryStrToConvUnit(AText: string; out AValue: Double;
  out AType: TConvType): Boolean;
function ConvUnitToStr(const AValue: Double; const AType: TConvType): string;

// Description format/parsing function

function ConvTypeToDescription(const AType: TConvType): string;
function ConvFamilyToDescription(const AFamily: TConvFamily): string;
function DescriptionToConvType(const ADescription: string;
  out AType: TConvType): Boolean; overload;
function DescriptionToConvType(const AFamily: TConvFamily;
  const ADescription: string; out AType: TConvType): Boolean; overload;
function DescriptionToConvFamily(const ADescription: string;
  out AFamily: TConvFamily): Boolean;

// ConvType to Family support

function ConvTypeToFamily(const AType: TConvType): TConvFamily; overload;
function TryConvTypeToFamily(const AType: TConvType;
  out AFamily: TConvFamily): Boolean; overload;

function ConvTypeToFamily(const AFrom, ATo: TConvType): TConvFamily; overload;
function TryConvTypeToFamily(const AFrom, ATo: TConvType;
  out AFamily: TConvFamily): Boolean; overload;

// Error procs

procedure RaiseConversionError(const AText: string); overload;
procedure RaiseConversionError(const AText: string;
  const AArgs: array of const); overload;
procedure RaiseConversionRegError(AFamily: TConvFamily;
  const ADescription: string);

type
  EConversionError = class(Exception);

const
  CIllegalConvFamily: TConvFamily = 0;
  CIllegalConvType: TConvType = 0;

var
  GConvUnitToStrFmt: string = '%f %s';

// Custom conversion type support

type
  TConvTypeInfo = class(TObject)
  private
    FDescription: string;
    FConvFamily: TConvFamily;
    FConvType: TConvType;
  public
    constructor Create(const AConvFamily: TConvFamily; const ADescription: string);
    function ToCommon(const AValue: Double): Double; virtual; abstract;
    function FromCommon(const AValue: Double): Double; virtual; abstract;
    property ConvFamily: TConvFamily read FConvFamily;
    property ConvType: TConvType read FConvType;
    property Description: string read FDescription;
  end;
  TConvTypeList = array of TConvTypeInfo;

  TConvTypeFactor = class(TConvTypeInfo)
  private
    FFactor: Double;
  protected
    property Factor: Double read FFactor; 
  public
    constructor Create(const AConvFamily: TConvFamily; const ADescription: string;
      const AFactor: Double);
    function ToCommon(const AValue: Double): Double; override;
    function FromCommon(const AValue: Double): Double; override;
  end;

  TConvTypeProcs = class(TConvTypeInfo)
  private
    FToCommonProc: TConversionProc;
    FFromCommonProc: TConversionProc;
  public
    constructor Create(const AConvFamily: TConvFamily; const ADescription: string;
      const AToCommonProc, AFromCommonProc: TConversionProc);
    function ToCommon(const AValue: Double): Double; override;
    function FromCommon(const AValue: Double): Double; override;
  end;

function RegisterConversionType(AConvTypeInfo: TConvTypeInfo;
  out AType: TConvType): Boolean; overload;

implementation

uses
  Windows, RTLConsts;

const
  CListGrowthDelta = 16;

// Comprehension of the following types and functions are not required in
//  order to use this unit.  They are provided as a way to iterate through
//  the declared conversion families and types.
type
  TConvFamilyInfo = class(TObject)
  private
    FDescription: string;
    FConvFamily: TConvFamily;
  public
    constructor Create(const AConvFamily: TConvFamily; const ADescription: string);
    property ConvFamily: TConvFamily read FConvFamily;
    property Description: string read FDescription;
  end;
  TConvFamilyList = array of TConvFamilyInfo;

var
  GConvFamilyList: TConvFamilyList;
  GConvTypeList: TConvTypeList;
  GLastConvFamily: TConvFamily;
  GLastConvType: TConvType;
  GConvFamilySync: TMultiReadExclusiveWriteSynchronizer;
  GConvTypeSync: TMultiReadExclusiveWriteSynchronizer;

procedure RaiseConversionError(const AText: string);
begin
  raise EConversionError.Create(AText);
end;

procedure RaiseConversionError(const AText: string; const AArgs: array of const);
begin
  raise EConversionError.CreateFmt(AText, AArgs);
end;

procedure RaiseConversionRegError(AFamily: TConvFamily;
  const ADescription: string);
begin
  RaiseConversionError(SConvDuplicateType,
    [ADescription, ConvFamilyToDescription(AFamily)]);
end;

function GetConvFamilyInfo(const AFamily: TConvFamily;
  out AConvFamilyInfo: TConvFamilyInfo): Boolean;
begin
  GConvFamilySync.BeginRead;
  try
    Result := AFamily < Length(GConvFamilyList);
    if Result then
    begin
      AConvFamilyInfo := GConvFamilyList[AFamily];
      Result := Assigned(AConvFamilyInfo);
    end;
  finally
    GConvFamilySync.EndRead;
  end;
end;

function GetConvInfo(const AType: TConvType;
  out AConvTypeInfo: TConvTypeInfo): Boolean; overload;
begin
  GConvTypeSync.BeginRead;
  try
    Result := AType < Length(GConvTypeList);
    if Result then
    begin
      AConvTypeInfo := GConvTypeList[AType];
      Result := Assigned(AConvTypeInfo);
    end;
  finally
    GConvTypeSync.EndRead;
  end;
end;

function GetConvInfo(const AType: TConvType; out AConvTypeInfo: TConvTypeInfo;
  out AConvFamilyInfo: TConvFamilyInfo): Boolean; overload;
begin
  Result := GetConvInfo(AType, AConvTypeInfo) and
            GetConvFamilyInfo(AConvTypeInfo.ConvFamily, AConvFamilyInfo);
end;

function GetConvInfo(const AType: TConvType;
  out AConvFamilyInfo: TConvFamilyInfo): Boolean; overload;
var
  LConvTypeInfo: TConvTypeInfo;
begin
  Result := GetConvInfo(AType, LConvTypeInfo) and
            GetConvFamilyInfo(LConvTypeInfo.ConvFamily, AConvFamilyInfo);
end;

function GetConvInfo(const AFrom, ATo: TConvType; out AFromTypeInfo,
  AToTypeInfo: TConvTypeInfo;
  out AConvFamilyInfo: TConvFamilyInfo): Boolean; overload;
var
  LFromFamilyInfo: TConvFamilyInfo;
begin
  Result := GetConvInfo(AFrom, AFromTypeInfo, LFromFamilyInfo) and
            GetConvInfo(ATo, AToTypeInfo, AConvFamilyInfo) and
            (AConvFamilyInfo = LFromFamilyInfo);
end;

function GetConvInfo(const AFrom, ATo: TConvType; out AFromTypeInfo,
  AToTypeInfo: TConvTypeInfo): Boolean; overload;
begin
  Result := GetConvInfo(AFrom, AFromTypeInfo) and
            GetConvInfo(ATo, AToTypeInfo) and
            (AFromTypeInfo.ConvFamily = AToTypeInfo.ConvFamily);
end;

function GetConvInfo(const AFrom, ATo, AResult: TConvType; out AFromTypeInfo,
  AToTypeInfo, AResultTypeInfo: TConvTypeInfo): Boolean; overload;
begin
  Result := GetConvInfo(AFrom, AFromTypeInfo) and
            GetConvInfo(ATo, AToTypeInfo) and
            GetConvInfo(AResult, AResultTypeInfo) and
            (AFromTypeInfo.ConvFamily = AToTypeInfo.ConvFamily) and
            (AToTypeInfo.ConvFamily = AResultTypeInfo.ConvFamily);
end;

function GetConvInfo(const AFrom, ATo: TConvType;
  out AConvFamilyInfo: TConvFamilyInfo): Boolean; overload;
var
  LFromFamilyInfo: TConvFamilyInfo;
begin
  Result := GetConvInfo(AFrom, LFromFamilyInfo) and
            GetConvInfo(ATo, AConvFamilyInfo) and
            (AConvFamilyInfo = LFromFamilyInfo);
end;

function ConvTypeToFamily(const AType: TConvType): TConvFamily;
begin
  if not TryConvTypeToFamily(AType, Result) then
    RaiseConversionError(SConvUnknownType,
                         [Format(SConvUnknownDescriptionWithPrefix, [HexDisplayPrefix, AType])]);
end;

function TryConvTypeToFamily(const AType: TConvType; out AFamily: TConvFamily): Boolean;
var
  LTypeInfo: TConvTypeInfo;
begin
  Result := GetConvInfo(AType, LTypeInfo);
  if Result then
    AFamily := LTypeInfo.ConvFamily;
end;

function ConvTypeToFamily(const AFrom, ATo: TConvType): TConvFamily;
begin
  if not TryConvTypeToFamily(AFrom, ATo, Result) then
    RaiseConversionError(SConvIncompatibleTypes2,
      [ConvTypeToDescription(AFrom),
       ConvTypeToDescription(ATo)]);
end;

function TryConvTypeToFamily(const AFrom, ATo: TConvType; out AFamily: TConvFamily): Boolean;
var
  LFromTypeInfo, LToTypeInfo: TConvTypeInfo;
begin
  Result := GetConvInfo(AFrom, LFromTypeInfo) and
            GetConvInfo(ATo, LToTypeInfo) and
            (LFromTypeInfo.ConvFamily = LToTypeInfo.ConvFamily);
  if Result then
    AFamily := LFromTypeInfo.ConvFamily;
end;

function CompatibleConversionTypes(const AFrom, ATo: TConvType): Boolean;
var
  LFamily: TConvFamily;
begin
  Result := TryConvTypeToFamily(AFrom, ATo, LFamily);
end;

function CompatibleConversionType(const AType: TConvType; const AFamily: TConvFamily): Boolean;
var
  LTypeInfo: TConvTypeInfo;
begin
  if not GetConvInfo(AType, LTypeInfo) then
    RaiseConversionError(SConvUnknownType,
                         [Format(SConvUnknownDescriptionWithPrefix, [HexDisplayPrefix, AType])]);
  Result := LTypeInfo.ConvFamily = AFamily;
end;

function Convert(const AValue: Double; const AFrom, ATo: TConvType): Double;
var
  LFromTypeInfo, LToTypeInfo: TConvTypeInfo;
begin
  if not GetConvInfo(AFrom, ATo, LFromTypeInfo, LToTypeInfo) then
    RaiseConversionError(SConvIncompatibleTypes2,
      [ConvTypeToDescription(AFrom),
       ConvTypeToDescription(ATo)]);
  Result := LToTypeInfo.FromCommon(LFromTypeInfo.ToCommon(AValue));
end;

function Convert(const AValue: Double;
  const AFrom1, AFrom2, ATo1, ATo2: TConvType): Double;
begin
  Result := Convert(Convert(AValue, AFrom1, ATo1), ATo2, AFrom2);
end;

function ConvertFrom(const AFrom: TConvType; const AValue: Double): Double;
var
  LFromTypeInfo: TConvTypeInfo;
begin
  if not GetConvInfo(AFrom, LFromTypeInfo) then
    RaiseConversionError(SConvUnknownType,
                         [Format(SConvUnknownDescriptionWithPrefix, [HexDisplayPrefix, AFrom])]);
  Result := LFromTypeInfo.ToCommon(AValue);
end;

function ConvertTo(const AValue: Double; const ATo: TConvType): Double;
var
  LToTypeInfo: TConvTypeInfo;
begin
  if not GetConvInfo(ATo, LToTypeInfo) then
    RaiseConversionError(SConvUnknownType,
                         [Format(SConvUnknownDescriptionWithPrefix, [HexDisplayPrefix, ATo])]);
  Result := LToTypeInfo.FromCommon(AValue);
end;

function ConvUnitAdd(const AValue1: Double; const AType1: TConvType;
  const AValue2: Double; const AType2, AResultType: TConvType): Double;
var
  LType1Info, LType2Info, LResultTypeInfo: TConvTypeInfo;
begin
  if not GetConvInfo(AType1, AType2, AResultType,
                     LType1Info, LType2Info, LResultTypeInfo) then
    RaiseConversionError(SConvIncompatibleTypes3,
      [ConvTypeToDescription(AType1),
       ConvTypeToDescription(AType2),
       ConvTypeToDescription(AResultType)]);
  Result := LResultTypeInfo.FromCommon(LType1Info.ToCommon(AValue1) +
                                       LType2Info.ToCommon(AValue2));
end;

function ConvUnitDiff(const AValue1: Double; const AType1: TConvType;
  const AValue2: Double; const AType2, AResultType: TConvType): Double;
begin
  Result := ConvUnitAdd(AValue1, AType1, -AValue2, AType2, AResultType);
end;

function ConvUnitInc(const AValue: Double;
  const AType, AAmountType: TConvType): Double;
begin
  Result := ConvUnitInc(AValue, AType, 1, AAmountType);
end;

function ConvUnitInc(const AValue: Double; const AType: TConvType;
  const AAmount: Double; const AAmountType: TConvType): Double;
var
  LTypeInfo, LAmountTypeInfo: TConvTypeInfo;
begin
  if not GetConvInfo(AType, AAmountType, LTypeInfo, LAmountTypeInfo) then
    RaiseConversionError(SConvIncompatibleTypes2,
      [ConvTypeToDescription(AType),
       ConvTypeToDescription(AAmountType)]);
  Result := AValue + LTypeInfo.FromCommon(LAmountTypeInfo.ToCommon(AAmount));
end;

function ConvUnitDec(const AValue: Double;
  const AType, AAmountType: TConvType): Double;
begin
  Result := ConvUnitInc(AValue, AType, -1, AAmountType);
end;

function ConvUnitDec(const AValue: Double; const AType: TConvType;
  const AAmount: Double; const AAmountType: TConvType): Double;
begin
  Result := ConvUnitInc(AValue, AType, -AAmount, AAmountType);
end;

function ConvUnitWithinPrevious(const AValue, ATest: Double; const AType: TConvType;
  const AAmount: Double; const AAmountType: TConvType): Boolean;
begin
  Result := (ATest <= AValue) and
            (ATest >= ConvUnitDec(AValue, AType, AAmount, AAmountType));
end;

function ConvUnitWithinNext(const AValue, ATest: Double; const AType: TConvType;
  const AAmount: Double; const AAmountType: TConvType): Boolean;
begin
  Result := (ATest >= AValue) and
            (ATest <= ConvUnitInc(AValue, AType, AAmount, AAmountType));
end;

function ConvUnitCompareValue(const AValue1: Double; const AType1: TConvType;
  const AValue2: Double; const AType2: TConvType): TValueRelationship;
var
  LType1Info, LType2Info: TConvTypeInfo;
begin
  if not GetConvInfo(AType1, AType2, LType1Info, LType2Info) then
    RaiseConversionError(SConvIncompatibleTypes2,
      [ConvTypeToDescription(AType1),
       ConvTypeToDescription(AType2)]);
  Result := CompareValue(LType1Info.ToCommon(AValue1), LType2Info.ToCommon(AValue2));
end;

function ConvUnitSameValue(const AValue1: Double; const AType1: TConvType;
  const AValue2: Double; const AType2: TConvType): Boolean;
var
  LType1Info, LType2Info: TConvTypeInfo;
begin
  if not GetConvInfo(AType1, AType2, LType1Info, LType2Info) then
    RaiseConversionError(SConvIncompatibleTypes2,
      [ConvTypeToDescription(AType1),
       ConvTypeToDescription(AType2)]);
  Result := SameValue(LType1Info.ToCommon(AValue1), LType2Info.ToCommon(AValue2));
end;


function RegisterConversionType(AConvTypeInfo: TConvTypeInfo;
  out AType: TConvType): Boolean;
begin
  GConvTypeSync.BeginWrite;
  try
    Result := not DescriptionToConvType(AConvTypeInfo.ConvFamily,
                                        AConvTypeInfo.Description, AType);
    if Result then
    begin
      Inc(GLastConvType);
      if GLastConvType > Length(GConvTypeList) - 1 then
        SetLength(GConvTypeList, GLastConvType + CListGrowthDelta);
      AType := GLastConvType;
      AConvTypeInfo.FConvType := AType;
      GConvTypeList[AType] := AConvTypeInfo;
    end;
  finally
    GConvTypeSync.EndWrite;
  end;
end;

function RegisterConversionType(const AFamily: TConvFamily;
  const ADescription: string; const AFactor: Double): TConvType;
var
  LInfo: TConvTypeInfo;
begin
  LInfo := TConvTypeFactor.Create(AFamily, ADescription, AFactor);
  if not RegisterConversionType(LInfo, Result) then
  begin
    LInfo.Free;
    RaiseConversionRegError(AFamily, ADescription);
  end;
end;

function RegisterConversionType(const AFamily: TConvFamily;
  const ADescription: string; const AToCommonProc,
  AFromCommonProc: TConversionProc): TConvType;
var
  LInfo: TConvTypeInfo;
begin
  LInfo := TConvTypeProcs.Create(AFamily, ADescription,
                                 AToCommonProc, AFromCommonProc);
  if not RegisterConversionType(LInfo, Result) then
  begin
    LInfo.Free;
    RaiseConversionRegError(AFamily, ADescription);
  end;
end;

procedure FreeConversionType(const AType: TConvType);
var
  LConvTypeInfo: TConvTypeInfo;
begin
  if GetConvInfo(AType, LConvTypeInfo) then
  begin
    GConvTypeList[AType] := nil;
    LConvTypeInfo.Free;
  end;
end;

procedure UnregisterConversionType(const AType: TConvType);
begin
  GConvTypeSync.BeginWrite;
  try
    FreeConversionType(AType);
  finally
    GConvTypeSync.EndWrite;
  end;
end;

function RegisterConversionFamily(const ADescription: string): TConvFamily;
var
  LFamily: TConvFamily;
begin
  GConvFamilySync.BeginWrite;
  try
    if DescriptionToConvFamily(ADescription, LFamily) then
      RaiseConversionError(SConvDuplicateFamily, [ADescription]);

    Inc(GLastConvFamily);
    if GLastConvFamily > Length(GConvFamilyList) - 1 then
      SetLength(GConvFamilyList, GLastConvFamily + CListGrowthDelta);

    Result := GLastConvFamily;
    GConvFamilyList[Result] := TConvFamilyInfo.Create(Result, ADescription);
  finally
    GConvFamilySync.EndWrite;
  end;
end;

procedure UnregisterConversionFamily(const AFamily: TConvFamily);
var
  I: Integer;
  LConvFamilyInfo: TConvFamilyInfo;
begin
  GConvFamilySync.BeginWrite;
  try
    if GetConvFamilyInfo(AFamily, LConvFamilyInfo) then
    begin
      GConvTypeSync.BeginWrite;
      try
        for I := 0 to Length(GConvTypeList) - 1 do
          if Assigned(GConvTypeList[I]) and
             (GConvTypeList[I].FConvFamily = AFamily) then
            FreeConversionType(I);
      finally
        GConvTypeSync.EndWrite;
      end;
      GConvFamilyList[AFamily] := nil;
      LConvFamilyInfo.Free;
    end;
  finally
    GConvFamilySync.EndWrite;
  end;
end;

procedure CleanUpLists;
var
  I: Integer;
  LConvFamilyInfo: TConvFamilyInfo;
  LConvTypeInfo: TConvTypeInfo;
begin
  GConvTypeSync.BeginWrite;
  try
    for I := 0 to Length(GConvTypeList) - 1 do
    begin
      LConvTypeInfo := GConvTypeList[I];
      if Assigned(LConvTypeInfo) then
      begin
        GConvTypeList[I] := nil;
        LConvTypeInfo.Free;
      end;
    end;
    SetLength(GConvTypeList, 0);
  finally
    GConvTypeSync.EndWrite;
  end;

  GConvFamilySync.BeginWrite;
  try
    for I := 0 to Length(GConvFamilyList) - 1 do
    begin
      LConvFamilyInfo := GConvFamilyList[I];
      if Assigned(LConvFamilyInfo) then
      begin
        GConvFamilyList[I] := nil;
        LConvFamilyInfo.Free;
      end;
    end;
    SetLength(GConvFamilyList, 0);
  finally
    GConvFamilySync.EndWrite;
  end;
end;

{ TConvFamilyInfo }

constructor TConvFamilyInfo.Create(const AConvFamily: TConvFamily; const ADescription: string);
begin
  inherited Create;
  FConvFamily := AConvFamily;
  FDescription := ADescription;
end;

{ TConvTypeInfo }

constructor TConvTypeInfo.Create(const AConvFamily: TConvFamily;
  const ADescription: string);
var
  LConvFamilyInfo: TConvFamilyInfo;
begin
  inherited Create;
  if not GetConvFamilyInfo(AConvFamily, LConvFamilyInfo) then
    RaiseConversionError(SConvUnknownFamily,
                         [Format(SConvUnknownDescriptionWithPrefix, [HexDisplayPrefix, AConvFamily])]);

  FConvFamily := AConvFamily;
  FDescription := ADescription;
end;

{ TConvTypeFactor }

constructor TConvTypeFactor.Create(const AConvFamily: TConvFamily;
  const ADescription: string; const AFactor: Double);
begin
  inherited Create(AConvFamily, ADescription);
  if AFactor = 0 then
    raise EZeroDivide.CreateFmt(SConvFactorZero, [ADescription]);
  FFactor := AFactor;
end;

function TConvTypeFactor.FromCommon(const AValue: Double): Double;
begin
  Result := AValue / FFactor;
end;

function TConvTypeFactor.ToCommon(const AValue: Double): Double;
begin
  Result := AValue * FFactor;
end;

{ TConvTypeProcs }

constructor TConvTypeProcs.Create(const AConvFamily: TConvFamily;
  const ADescription: string; const AToCommonProc,
  AFromCommonProc: TConversionProc);
begin
  inherited Create(AConvFamily, ADescription);
  FToCommonProc := AToCommonProc;
  FFromCommonProc := AFromCommonProc;
end;

function TConvTypeProcs.FromCommon(const AValue: Double): Double;
begin
  Result := FFromCommonProc(AValue);
end;

function TConvTypeProcs.ToCommon(const AValue: Double): Double;
begin
  Result := FToCommonProc(AValue);
end;

// Conversion support
function StrToConvUnit(AText: string; out AType: TConvType): Double;
begin
  if not TryStrToConvUnit(AText, Result, AType) then
    RaiseConversionError(SConvStrParseError, [AText]);
end;

function TryStrToConvUnit(AText: string; out AValue: Double; out AType: TConvType): Boolean;
var
  LSpaceAt: Integer;
  LType: string;
  LValue: Extended;
begin
  AText := TrimLeft(AText);
  LSpaceAt := Pos(' ', AText);
  if LSpaceAt > 0 then
  begin
    Result := TryStrToFloat(Copy(AText, 1, LSpaceAt - 1), LValue);
    if Result then
    begin
      LType := Trim(Copy(AText, LSpaceAt + 1, MaxInt));
      Result := (LType <> '') and DescriptionToConvType(LType, AType);
    end;
  end
  else
  begin
    AType := CIllegalConvType;
    Result := TryStrToFloat(AText, LValue);
  end;
  if Result then
    AValue := LValue;
end;

function ConvUnitToStr(const AValue: Double; const AType: TConvType): string;
begin
  Result := Format(GConvUnitToStrFmt, [AValue, ConvTypeToDescription(AType)]);
end;

// Discovery support functions
procedure GetConvTypes(const AFamily: TConvFamily; out ATypes: TConvTypeArray);
var
  I, LCount: Integer;
begin
  GConvTypeSync.BeginRead;
  try
    LCount := 0;
    for I := 0 to Length(GConvTypeList) - 1 do
      if Assigned(GConvTypeList[I]) and
         (GConvTypeList[I].ConvFamily = AFamily) then
        Inc(LCount);
    SetLength(ATypes, LCount);
    LCount := 0;
    for I := 0 to Length(GConvTypeList) - 1 do
      if Assigned(GConvTypeList[I]) and
         (GConvTypeList[I].ConvFamily = AFamily) then
      begin
        ATypes[LCount] := GConvTypeList[I].ConvType;
        Inc(LCount);
      end;
  finally
    GConvTypeSync.EndRead;
  end;
end;

procedure GetConvFamilies(out AFamilies: TConvFamilyArray);
var
  I, LCount: Integer;
begin
  GConvFamilySync.BeginRead;
  try
    LCount := 0;
    for I := 0 to Length(GConvFamilyList) - 1 do
      if Assigned(GConvFamilyList[I]) then
        Inc(LCount);
    SetLength(AFamilies, LCount);
    LCount := 0;
    for I := 0 to Length(GConvFamilyList) - 1 do
      if Assigned(GConvFamilyList[I]) then
      begin
        AFamilies[LCount] := GConvFamilyList[I].ConvFamily;
        Inc(LCount);
      end;
  finally
    GConvFamilySync.EndRead;
  end;
end;

function ConvTypeToDescription(const AType: TConvType): string;
var
  LConvTypeInfo: TConvTypeInfo;
begin
  if AType = CIllegalConvType then
    Result := SConvIllegalType
  else if GetConvInfo(AType, LConvTypeInfo) then
    Result := LConvTypeInfo.Description
  else
    Result := Format(SConvUnknownDescriptionWithPrefix, [HexDisplayPrefix, AType]);
end;

function ConvFamilyToDescription(const AFamily: TConvFamily): string;
var
  LConvFamilyInfo: TConvFamilyInfo;
begin
  if AFamily = CIllegalConvFamily then
    Result := SConvIllegalFamily
  else if GetConvFamilyInfo(AFamily, LConvFamilyInfo) then
    Result := LConvFamilyInfo.Description
  else
    Result := Format(SConvUnknownDescriptionWithPrefix, [HexDisplayPrefix, AFamily]);
end;

function DescriptionToConvType(const ADescription: string;
  out AType: TConvType): Boolean;
var
  I: Integer;
begin
  Result := False;
  GConvTypeSync.BeginRead;
  try
    for I := 0 to Length(GConvTypeList) - 1 do
      if Assigned(GConvTypeList[I]) and
         AnsiSameText(ADescription, GConvTypeList[I].Description) then
      begin
        // if duplicate is found
        if Result then
        begin
          Result := False;
          Exit;
        end;
        AType := I;
        Result := True;
      end;
  finally
    GConvTypeSync.EndRead;
  end;
end;

function DescriptionToConvType(const AFamily: TConvFamily;
  const ADescription: string; out AType: TConvType): Boolean;
var
  I: Integer;
begin
  Result := False;
  GConvTypeSync.BeginRead;
  try
    for I := 0 to Length(GConvTypeList) - 1 do
      if Assigned(GConvTypeList[I]) and
         (GConvTypeList[I].ConvFamily = AFamily) and
         AnsiSameText(ADescription, GConvTypeList[I].Description) then
      begin
        AType := I;
        Result := True;
        Break;
      end;
  finally
    GConvTypeSync.EndRead;
  end;
end;

function DescriptionToConvFamily(const ADescription: string;
  out AFamily: TConvFamily): Boolean;
var
  I: Integer;
begin
  Result := False;
  GConvFamilySync.BeginRead;
  try
    for I := 0 to Length(GConvFamilyList) - 1 do
      if Assigned(GConvFamilyList[I]) and
         AnsiSameText(ADescription, GConvFamilyList[I].Description) then
      begin
        AFamily := I;
        Result := True;
        Break;
      end;
  finally
    GConvFamilySync.EndRead;
  end;
end;

initialization
  GConvFamilySync := TMultiReadExclusiveWriteSynchronizer.Create;
  GConvTypeSync := TMultiReadExclusiveWriteSynchronizer.Create;
finalization
  CleanUpLists;
  FreeAndNil(GConvFamilySync);
  FreeAndNil(GConvTypeSync);
end.
