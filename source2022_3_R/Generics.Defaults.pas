{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit Generics.Defaults;

{$R-,T-,X+,H+,B-}

interface

uses SysUtils, TypInfo;

type
  IComparer<T> = interface
    function Compare(const Left, Right: T): Integer;
  end;
  
  IEqualityComparer<T> = interface
    function Equals(const Left, Right: T): Boolean;
    function GetHashCode(const Value: T): Integer;
  end;
  
  TComparison<T> = reference to function(const Left, Right: T): Integer;
  
  // Abstract base class for IComparer<T> implementations, and a provider
  // of default IComparer<T> implementations.
  TComparer<T> = class(TInterfacedObject, IComparer<T>)
  public
    class function Default: IComparer<T>;
    class function Construct(const Comparison: TComparison<T>): IComparer<T>;
    function Compare(const Left, Right: T): Integer; virtual; abstract;
  end;

  TEqualityComparison<T> = reference to function(const Left, Right: T): Boolean;
  THasher<T> = reference to function(const Value: T): Integer;
  
  // Abstract base class for IEqualityComparer<T> implementations, and a provider
  // of default IEqualityComparer<T> implementations.
  TEqualityComparer<T> = class(TInterfacedObject, IEqualityComparer<T>)
  public
    class function Default: IEqualityComparer<T>; static;
    
    class function Construct(const EqualityComparison: TEqualityComparison<T>;
      const Hasher: THasher<T>): IEqualityComparer<T>;
    
    function Equals(const Left, Right: T): Boolean; 
      reintroduce; overload; virtual; abstract;
    function GetHashCode(const Value: T): Integer;
      reintroduce; overload; virtual; abstract;
  end;
  
  // A non-reference-counted IInterface implementation.
  TSingletonImplementation = class(TObject, IInterface)
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;
  
  TDelegatedEqualityComparer<T> = class(TEqualityComparer<T>)
  private
    FEquals: TEqualityComparison<T>;
    FGetHashCode: THasher<T>;
  public
    constructor Create(const AEquals: TEqualityComparison<T>;
      const AGetHashCode: THasher<T>);
    function Equals(const Left, Right: T): Boolean; overload; override;
    function GetHashCode(const Value: T): Integer; overload; override;
  end;
  
  TDelegatedComparer<T> = class(TComparer<T>)
  private
    FCompare: TComparison<T>;
  public
    constructor Create(const ACompare: TComparison<T>);
    function Compare(const Left, Right: T): Integer; override;
  end;
  
  TCustomComparer<T> = class(TSingletonImplementation, IComparer<T>, IEqualityComparer<T>)
  protected
    function Compare(const Left, Right: T): Integer; virtual; abstract;
    function Equals(const Left, Right: T): Boolean; 
      reintroduce; overload; virtual; abstract;
    function GetHashCode(const Value: T): Integer;
      reintroduce; overload; virtual; abstract;
  end;
  
  TStringComparer = class(TCustomComparer<string>)
  private
    class var
      FOrdinal: TCustomComparer<string>;
  public
    class function Ordinal: TStringComparer;
  end;
  
function BobJenkinsHash(const Data; Len, InitData: Integer): Integer;
function BinaryCompare(const Left, Right: Pointer; Size: Integer): Integer;

// Must be in interface section to be used by generic method. For internal use only.
type
  TDefaultGenericInterface = (giComparer, giEqualityComparer);

function _LookupVtableInfo(intf: TDefaultGenericInterface; info: PTypeInfo; size: Integer): Pointer;

implementation

uses Windows, Math, Generics.Collections;

type
  PSimpleInstance = ^TSimpleInstance;
  TSimpleInstance = record
    Vtable: Pointer;
    RefCount: Integer;
    Size: Integer;
  end;

  TInfoFlags = set of (ifVariableSize, ifSelector);
  PVtableInfo = ^TVtableInfo;
  TVtableInfo = record
    Flags: TInfoFlags;
    Data: Pointer;
  end;
  
  TTypeInfoSelector = function(info: PTypeInfo; size: Integer): Pointer;

function MakeInstance(vtable: Pointer; sizeField: Integer): Pointer;
var
  inst: PSimpleInstance;
begin
  GetMem(inst, SizeOf(inst^));
  inst^.Vtable := vtable;
  inst^.RefCount := 0;
  inst^.Size := sizeField;
  Result := inst;
end;

function NopAddref(inst: Pointer): Integer; stdcall;
begin
  Result := -1;
end;

function NopRelease(inst: Pointer): Integer; stdcall;
begin
  Result := -1;
end;

function NopQueryInterface(inst: Pointer; const IID: TGUID; out Obj): HResult; stdcall;
begin
  Result := E_NOINTERFACE;
end;

function MemAddref(inst: PSimpleInstance): Integer; stdcall;
begin
  Result := InterlockedIncrement(inst^.RefCount);
end;

function MemRelease(inst: PSimpleInstance): Integer; stdcall;
begin
  Result := InterlockedDecrement(inst^.RefCount);
  if Result = 0 then
    FreeMem(inst);
end;

// I/U 1-4

function Compare_I1(Inst: Pointer; const Left, Right: Shortint): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_I1(Inst: Pointer; const Left, Right: Shortint): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_I1(Inst: Pointer; const Value: Shortint): Integer;
begin
  Result := BobJenkinsHash(Value, SizeOf(Value), 0);
end;

function Compare_I2(Inst: Pointer; const Left, Right: Smallint): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_I2(Inst: Pointer; const Left, Right: Smallint): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_I2(Inst: Pointer; const Value: Smallint): Integer;
begin
  Result := BobJenkinsHash(Value, SizeOf(Value), 0);
end;

function Compare_I4(Inst: Pointer; const Left, Right: Integer): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_I4(Inst: Pointer; const Left, Right: Integer): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_I4(Inst: Pointer; const Value: Integer): Integer;
begin
  Result := BobJenkinsHash(Value, SizeOf(Value), 0);
end;

function Compare_U1(Inst: Pointer; const Left, Right: Byte): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Compare_U2(Inst: Pointer; const Left, Right: Word): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Compare_U4(Inst: Pointer; const Left, Right: LongWord): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

const
  Comparer_Vtable_I1: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_I1
  );
  
  Comparer_Vtable_U1: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_U1
  );
  
  Comparer_Vtable_I2: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_I2
  );
  
  Comparer_Vtable_U2: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_U2
  );
  
  Comparer_Vtable_I4: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_I4
  );
  
  Comparer_Vtable_U4: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_U4
  );
  
  Comparer_Instance_I1: Pointer = @Comparer_Vtable_I1;
  Comparer_Instance_U1: Pointer = @Comparer_Vtable_U1;
  Comparer_Instance_I2: Pointer = @Comparer_Vtable_I2;
  Comparer_Instance_U2: Pointer = @Comparer_Vtable_U2;
  Comparer_Instance_I4: Pointer = @Comparer_Vtable_I4;
  Comparer_Instance_U4: Pointer = @Comparer_Vtable_U4;
  
  EqualityComparer_Vtable_I1: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_I1,
    @GetHashCode_I1
  );
  
  EqualityComparer_Vtable_I2: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_I2,
    @GetHashCode_I2
  );
  
  EqualityComparer_Vtable_I4: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_I4,
    @GetHashCode_I4
  );
  
  EqualityComparer_Instance_I1: Pointer = @EqualityComparer_VTable_I1;
  EqualityComparer_Instance_I2: Pointer = @EqualityComparer_VTable_I2;
  EqualityComparer_Instance_I4: Pointer = @EqualityComparer_VTable_I4;

function Comparer_Selector_Integer(info: PTypeInfo; size: Integer): Pointer;
begin
  case GetTypeData(info)^.OrdType of
    otSByte: Result := @Comparer_Instance_I1;
    otUByte: Result := @Comparer_Instance_U1;
    otSWord: Result := @Comparer_Instance_I2;
    otUWord: Result := @Comparer_Instance_U2;
    otSLong: Result := @Comparer_Instance_I4;
    otULong: Result := @Comparer_Instance_U4;
  else
    System.Error(reRangeError);
    Exit(nil);
  end;
end;

function EqualityComparer_Selector_Integer(info: PTypeInfo; size: Integer): Pointer;
begin
  case GetTypeData(info)^.OrdType of
    otSByte, otUByte: Result := @EqualityComparer_Instance_I1;
    otSWord, otUWord: Result := @EqualityComparer_Instance_I2;
    otSLong, otULong: Result := @EqualityComparer_Instance_I4;
  else
    System.Error(reRangeError);
    Exit(nil);
  end;
end;

// I8 & U8

function Equals_I8(Inst: Pointer; const Left, Right: Int64): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_I8(Inst: Pointer; const Value: Int64): Integer;
begin
  Result := BobJenkinsHash(Value, SizeOf(Value), 0);
end;

function Compare_I8(Inst: Pointer; const Left, Right: Int64): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Compare_U8(Inst: Pointer; const Left, Right: UInt64): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

const
  Comparer_Vtable_I8: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_I8
  );
  Comparer_Instance_I8: Pointer = @Comparer_Vtable_I8;

  Comparer_Vtable_U8: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_U8
  );
  Comparer_Instance_U8: Pointer = @Comparer_Vtable_U8;
  
  EqualityComparer_Vtable_I8: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_I8,
    @GetHashCode_I8
  );
  EqualityComparer_Instance_I8: Pointer = @EqualityComparer_Vtable_I8;

function Comparer_Selector_Int64(info: PTypeInfo; size: Integer): Pointer;
begin
  if GetTypeData(info)^.MaxInt64Value > GetTypeData(info)^.MinInt64Value then
    Result := @Comparer_Instance_I8
  else
    Result := @Comparer_Instance_U8;
end;

// Float

function Compare_R4(Inst: Pointer; const Left, Right: Single): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_R4(Inst: Pointer; const Left, Right: Single): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_R4(Inst: Pointer; const Value: Single): Integer;
var
  m: Extended;
  e: Integer;
begin
  // Denormalized floats and positive/negative 0.0 complicate things.
  Frexp(Value, m, e);
  if m = 0 then
    m := Abs(m);
  Result := BobJenkinsHash(m, SizeOf(m), 0);
  Result := BobJenkinsHash(e, SizeOf(e), Result);
end;

const
  Comparer_Vtable_R4: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_R4
  );
  Comparer_Instance_R4: Pointer = @Comparer_Vtable_R4;
  
  EqualityComparer_Vtable_R4: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_R4,
    @GetHashCode_R4
  );
  EqualityComparer_Instance_R4: Pointer = @EqualityComparer_Vtable_R4;

function Compare_R8(Inst: Pointer; const Left, Right: Double): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_R8(Inst: Pointer; const Left, Right: Double): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_R8(Inst: Pointer; const Value: Double): Integer;
var
  m: Extended;
  e: Integer;
begin
  // Denormalized floats and positive/negative 0.0 complicate things.
  Frexp(Value, m, e);
  if m = 0 then
    m := Abs(m);
  Result := BobJenkinsHash(m, SizeOf(m), 0);
  Result := BobJenkinsHash(e, SizeOf(e), Result);
end;

const
  Comparer_Vtable_R8: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_R8
  );
  Comparer_Instance_R8: Pointer = @Comparer_Vtable_R8;
  
  EqualityComparer_Vtable_R8: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_R8,
    @GetHashCode_R8
  );
  EqualityComparer_Instance_R8: Pointer = @EqualityComparer_Vtable_R8;

function Compare_R10(Inst: Pointer; const Left, Right: Extended): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_R10(Inst: Pointer; const Left, Right: Extended): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_R10(Inst: Pointer; const Value: Extended): Integer;
var
  m: Extended;
  e: Integer;
begin
  // Denormalized floats and positive/negative 0.0 complicate things.
  Frexp(Value, m, e);
  if m = 0 then
    m := Abs(m);
  Result := BobJenkinsHash(m, SizeOf(m), 0);
  Result := BobJenkinsHash(e, SizeOf(e), Result);
end;

const
  Comparer_Vtable_R10: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_R10
  );
  Comparer_Instance_R10: Pointer = @Comparer_Vtable_R10;
  
  EqualityComparer_Vtable_R10: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_R10,
    @GetHashCode_R10
  );
  EqualityComparer_Instance_R10: Pointer = @EqualityComparer_Vtable_R10;

function Compare_RI8(Inst: Pointer; const Left, Right: Comp): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_RI8(Inst: Pointer; const Left, Right: Comp): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_RI8(Inst: Pointer; const Value: Comp): Integer;
begin
  Result := BobJenkinsHash(Value, SizeOf(Value), 0);
end;

const
  Comparer_Vtable_RI8: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_RI8
  );
  Comparer_Instance_RI8: Pointer = @Comparer_Vtable_RI8;
  
  EqualityComparer_Vtable_RI8: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_RI8,
    @GetHashCode_RI8
  );
  EqualityComparer_Instance_RI8: Pointer = @EqualityComparer_Vtable_RI8;

function Compare_RC8(Inst: Pointer; const Left, Right: Currency): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_RC8(Inst: Pointer; const Left, Right: Currency): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_RC8(Inst: Pointer; const Value: Currency): Integer;
begin
  Result := BobJenkinsHash(Value, SizeOf(Value), 0);
end;

const
  Comparer_Vtable_RC8: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_RC8
  );
  Comparer_Instance_RC8: Pointer = @Comparer_Vtable_RC8;
  
  EqualityComparer_Vtable_RC8: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_RC8,
    @GetHashCode_RC8
  );
  EqualityComparer_Instance_RC8: Pointer = @EqualityComparer_Vtable_RC8;

function Comparer_Selector_Float(info: PTypeInfo; size: Integer): Pointer;
begin
  case GetTypeData(info)^.FloatType of
    ftSingle: Result := @Comparer_Instance_R4;
    ftDouble: Result := @Comparer_Instance_R8;
    ftExtended: Result := @Comparer_Instance_R10;
    ftComp: Result := @Comparer_Instance_RI8;
    ftCurr: Result := @Comparer_Instance_RC8;
  else
    System.Error(reRangeError);
    Exit(nil);
  end;
end;

function EqualityComparer_Selector_Float(info: PTypeInfo; size: Integer): Pointer;
begin
  case GetTypeData(info)^.FloatType of
    ftSingle: Result := @EqualityComparer_Instance_R4;
    ftDouble: Result := @EqualityComparer_Instance_R8;
    ftExtended: Result := @EqualityComparer_Instance_R10;
    ftComp: Result := @EqualityComparer_Instance_RI8;
    ftCurr: Result := @EqualityComparer_Instance_RC8;
  else
    System.Error(reRangeError);
    Exit(nil);
  end;
end;

// Binary

function BinaryCompare(const Left, Right: Pointer; Size: Integer): Integer;
var
  pl, pr: PByte;
  len: Integer;
begin
  pl := Left;
  pr := Right;
  len := Size;
  while len > 0 do
  begin
    Result := pl^ - pr^;
    if Result <> 0 then
      Exit;
    Dec(len);
    Inc(pl);
    Inc(pr);
  end;
  Result := 0;
end;

function Compare_Binary(Inst: PSimpleInstance; const Left, Right): Integer;
begin
  Result := BinaryCompare(@Left, @Right, Inst^.Size);
end;

function Equals_Binary(Inst: PSimpleInstance; const Left, Right): Boolean;
begin
  Result := CompareMem(@Left, @Right, Inst^.Size);
end;

function GetHashCode_Binary(Inst: PSimpleInstance; const Value): Integer;
begin
  Result := BobJenkinsHash(Value, Inst^.Size, 0);
end;

const
  Comparer_Vtable_Binary: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @MemAddref,
    @MemRelease,
    @Compare_Binary
  );
  
  EqualityComparer_Vtable_Binary: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @MemAddref,
    @MemRelease,
    @Equals_Binary,
    @GetHashCode_Binary
  );

function Comparer_Selector_Binary(info: PTypeInfo; size: Integer): Pointer;
begin
  case size of
    // NOTE: Little-endianness may cause counterintuitive results,
    // but the results will at least be consistent.
    1: Result := @Comparer_Instance_U1;
    2: Result := @Comparer_Instance_U2;
    4: Result := @Comparer_Instance_U4;
  else
    Result := MakeInstance(@Comparer_Vtable_Binary, size);
  end;
end;

function EqualityComparer_Selector_Binary(info: PTypeInfo; size: Integer): Pointer;
begin
  case size of
    1: Result := @EqualityComparer_Instance_I1;
    2: Result := @EqualityComparer_Instance_I2;
    4: Result := @EqualityComparer_Instance_I4;
  else
    Result := MakeInstance(@EqualityComparer_Vtable_Binary, size);
  end;
end;

// Class (i.e. instances)

function Equals_Class(Inst: PSimpleInstance; Left, Right: TObject): Boolean;
begin
  if Left = nil then
    Result := Right = nil
  else
    Result := Left.Equals(Right);
end;

function GetHashCode_Class(Inst: PSimpleInstance; Value: TObject): Integer;
begin
  Result := Value.GetHashCode;
end;

// DynArray

function DynLen(Arr: Pointer): Longint; inline;
begin
  if Arr = nil then
    Exit(0);
  Result := PLongint(PByte(Arr) - SizeOf(Longint))^;
end;

function Compare_DynArray(Inst: PSimpleInstance; Left, Right: Pointer): Integer;
var
  len, lenDiff: Integer;
begin
  len := DynLen(Left);
  lenDiff := len - DynLen(Right);
  if lenDiff < 0 then
    Inc(len, lenDiff);
  Result := BinaryCompare(Left, Right, Inst^.Size * len);
  if Result = 0 then
    Result := lenDiff;
end;

function Equals_DynArray(Inst: PSimpleInstance; Left, Right: Pointer): Boolean;
var
  lenL, lenR: Longint;
begin
  lenL := DynLen(Left);
  lenR := DynLen(Right);
  if lenL <> lenR then
    Exit(False);
  Result := CompareMem(Left, Right, Inst^.Size * lenL);
end;

function GetHashCode_DynArray(Inst: PSimpleInstance; Value: Pointer): Integer;
begin
  Result := BobJenkinsHash(Value^, Inst^.Size * DynLen(Value), 0);
end;

const
  Comparer_Vtable_DynArray: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @MemAddref,
    @MemRelease,
    @Compare_DynArray
  );
  
  EqualityComparer_Vtable_DynArray: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @MemAddref,
    @MemRelease,
    @Equals_DynArray,
    @GetHashCode_DynArray
  );

function Comparer_Selector_DynArray(info: PTypeInfo; size: Integer): Pointer;
begin
  Result := MakeInstance(@Comparer_Vtable_DynArray, GetTypeData(info)^.elSize);
end;

function EqualityComparer_Selector_DynArray(info: PTypeInfo; size: Integer): Pointer;
begin
  Result := MakeInstance(@EqualityComparer_Vtable_DynArray, GetTypeData(info)^.elSize);
end;

// PStrings

type
  TPS1 = string[1];
  TPS2 = string[2];
  TPS3 = string[3];

function Compare_PS1(Inst: PSimpleInstance; const Left, Right: TPS1): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Compare_PS2(Inst: PSimpleInstance; const Left, Right: TPS2): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Compare_PS3(Inst: PSimpleInstance; const Left, Right: TPS3): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Compare_PSn(Inst: PSimpleInstance; const Left, Right: OpenString): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_PS1(Inst: PSimpleInstance; const Left, Right: TPS1): Boolean;
begin
  Result := Left = Right;
end;

function Equals_PS2(Inst: PSimpleInstance; const Left, Right: TPS2): Boolean;
begin
  Result := Left = Right;
end;

function Equals_PS3(Inst: PSimpleInstance; const Left, Right: TPS3): Boolean;
begin
  Result := Left = Right;
end;

function Equals_PSn(Inst: PSimpleInstance; const Left, Right: OpenString): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_PS1(Inst: PSimpleInstance; const Value: TPS1): Integer;
begin
  Result := BobJenkinsHash(Value[1], Length(Value), 0);
end;

function GetHashCode_PS2(Inst: PSimpleInstance; const Value: TPS2): Integer;
begin
  Result := BobJenkinsHash(Value[1], Length(Value), 0);
end;

function GetHashCode_PS3(Inst: PSimpleInstance; const Value: TPS3): Integer;
begin
  Result := BobJenkinsHash(Value[1], Length(Value), 0);
end;

function GetHashCode_PSn(Inst: PSimpleInstance; const Value: OpenString): Integer;
begin
  Result := BobJenkinsHash(Value[1], Length(Value), 0);
end;

const
  Comparer_Vtable_PS1: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_PS1
  );
  Comparer_Instance_PS1: Pointer = @Comparer_Vtable_PS1;
  
  Comparer_Vtable_PS2: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_PS2
  );
  Comparer_Instance_PS2: Pointer = @Comparer_Vtable_PS2;
  
  Comparer_Vtable_PS3: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_PS3
  );
  Comparer_Instance_PS3: Pointer = @Comparer_Vtable_PS3;
  
  Comparer_Vtable_PSn: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_PSn
  );
  Comparer_Instance_PSn: Pointer = @Comparer_Vtable_PSn;
  
  EqualityComparer_Vtable_PS1: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_PS1,
    @GetHashCode_PS1
  );
  EqualityComparer_Instance_PS1: Pointer = @EqualityComparer_Vtable_PS1;
  
  EqualityComparer_Vtable_PS2: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_PS2,
    @GetHashCode_PS2
  );
  EqualityComparer_Instance_PS2: Pointer = @EqualityComparer_Vtable_PS2;
  
  EqualityComparer_Vtable_PS3: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_PS3,
    @GetHashCode_PS3
  );
  EqualityComparer_Instance_PS3: Pointer = @EqualityComparer_Vtable_PS3;
  
  EqualityComparer_Vtable_PSn: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_PSn,
    @GetHashCode_PSn
  );
  EqualityComparer_Instance_PSn: Pointer = @EqualityComparer_Vtable_PSn;
  
function Comparer_Selector_String(info: PTypeInfo; size: Integer): Pointer;
begin
  case size of
    2: Result := @Comparer_Instance_PS1;
    3: Result := @Comparer_Instance_PS2;
    4: Result := @Comparer_Instance_PS3;
  else
    Result := @Comparer_Instance_PSn;
  end;
end;

function EqualityComparer_Selector_String(info: PTypeInfo; size: Integer): Pointer;
begin
  case size of
    2: Result := @EqualityComparer_Instance_PS1;
    3: Result := @EqualityComparer_Instance_PS2;
    4: Result := @EqualityComparer_Instance_PS3;
  else
    Result := @EqualityComparer_Instance_PSn;
  end;
end;

// LStrings

function Compare_LString(Inst: PSimpleInstance; const Left, Right: AnsiString): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_LString(Inst: PSimpleInstance; const Left, Right: AnsiString): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_LString(Inst: PSimpleInstance; const Value: AnsiString): Integer;
begin
  Result := BobJenkinsHash(Value[1], Length(Value) * SizeOf(Value[1]), 0);
end;

// UStrings

function Compare_UString(Inst: PSimpleInstance; const Left, Right: UnicodeString): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_UString(Inst: PSimpleInstance; const Left, Right: UnicodeString): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_UString(Inst: PSimpleInstance; const Value: UnicodeString): Integer;
begin
  Result := BobJenkinsHash(Value[1], Length(Value) * SizeOf(Value[1]), 0);
end;

// WStrings

function Compare_WString(Inst: PSimpleInstance; const Left, Right: WideString): Integer;
begin
  if Left < Right then
    Result := -1
  else if Left > Right then
    Result := 1
  else
    Result := 0;
end;

function Equals_WString(Inst: PSimpleInstance; const Left, Right: WideString): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_WString(Inst: PSimpleInstance; const Value: WideString): Integer;
begin
  Result := BobJenkinsHash(Value[1], Length(Value) * SizeOf(Value[1]), 0);
end;

// Variants

function Compare_Variant(Inst: PSimpleInstance; Left, Right: Pointer): Integer;
begin
  // No canonical ordering here.
  Result := 0;
end;

function Equals_Variant(Inst: PSimpleInstance; Left, Right: Pointer): Boolean;
begin
  Result := Left = Right;
end;

function GetHashCode_Variant(Inst: PSimpleInstance; Value: Pointer): Integer;
begin
  // There is no good, simple answer to this question. '1' = 1 => normalization required.
  // Don't rely on hash codes for variants.
  Result := 42;
end;

const
  Comparer_Vtable_Class: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_I4
  );
  
  Comparer_Vtable_LString: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_LString
  );
  
  Comparer_Vtable_WString: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_WString
  );
  
  Comparer_Vtable_Variant: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_Variant
  );
  
  Comparer_Vtable_UString: array[0..3] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Compare_UString
  );
  
  Comparer_Instance_Class: Pointer = @Comparer_Vtable_Class;
  Comparer_Instance_LString: Pointer = @Comparer_Vtable_LString;
  Comparer_Instance_WString: Pointer = @Comparer_Vtable_WString;
  Comparer_Instance_Variant: Pointer = @Comparer_Vtable_Variant;
  Comparer_Instance_UString: Pointer = @Comparer_Vtable_UString;
  
  EqualityComparer_Vtable_Class: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_Class,
    @GetHashCode_Class
  );
  
  EqualityComparer_Vtable_LString: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_LString,
    @GetHashCode_LString
  );
  
  EqualityComparer_Vtable_WString: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_WString,
    @GetHashCode_WString
  );
  
  EqualityComparer_Vtable_Variant: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_Variant,
    @GetHashCode_Variant
  );
  
  EqualityComparer_Vtable_UString: array[0..4] of Pointer =
  (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease,
    @Equals_UString,
    @GetHashCode_UString
  );
  
  EqualityComparer_Instance_Class: Pointer = @EqualityComparer_Vtable_Class;
  EqualityComparer_Instance_LString: Pointer = @EqualityComparer_Vtable_LString;
  EqualityComparer_Instance_WString: Pointer = @EqualityComparer_Vtable_WString;
  EqualityComparer_Instance_Variant: Pointer = @EqualityComparer_Vtable_Variant;
  EqualityComparer_Instance_UString: Pointer = @EqualityComparer_Vtable_UString;
  
  VtableInfo: array[TDefaultGenericInterface, TTypeKind] of TVtableInfo =
  (
    // IComparer
    (
      // tkUnknown
      (Flags: [ifSelector]; Data: @Comparer_Selector_Binary),
      // tkInteger
      (Flags: [ifSelector]; Data: @Comparer_Selector_Integer),
      // tkChar
      (Flags: [ifSelector]; Data: @Comparer_Selector_Binary),
      // tkEnumeration
      (Flags: [ifSelector]; Data: @Comparer_Selector_Integer),
      // tkFloat
      (Flags: [ifSelector]; Data: @Comparer_Selector_Float),
      // tkString
      (Flags: [ifSelector]; Data: @Comparer_Selector_String),
      // tkSet
      (Flags: [ifSelector]; Data: @Comparer_Selector_Binary),
      // tkClass
      (Flags: []; Data: @Comparer_Instance_Class),
      // tkMethod
      (Flags: [ifSelector]; Data: @Comparer_Selector_Binary),
      // tkWChar
      (Flags: [ifSelector]; Data: @Comparer_Selector_Binary),
      // tkLString
      (Flags: []; Data: @Comparer_Instance_LString),
      // tkWString
      (Flags: []; Data: @Comparer_Instance_WString),
      // tkVariant
      (Flags: []; Data: @Comparer_Instance_Variant),
      // tkArray
      (Flags: [ifSelector]; Data: @Comparer_Selector_Binary),
      // tkRecord
      (Flags: [ifSelector]; Data: @Comparer_Selector_Binary),
      // tkInterface
      (Flags: []; Data: @Comparer_Instance_I4),
      // tkInt64
      (Flags: [ifSelector]; Data: @Comparer_Selector_Int64),
      // tkDynArray
      (Flags: [ifSelector]; Data: @Comparer_Selector_DynArray),
      // tkUString
      (Flags: []; Data: @Comparer_Instance_UString)
    ),
    // IEqualityComparer
    (
      // tkUnknown
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_Binary),
      // tkInteger
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_Integer),
      // tkChar
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_Binary),
      // tkEnumeration
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_Integer),
      // tkFloat
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_Float),
      // tkString
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_String),
      // tkSet
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_Binary),
      // tkClass
      (Flags: []; Data: @EqualityComparer_Instance_Class),
      // tkMethod
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_Binary),
      // tkWChar
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_Binary),
      // tkLString
      (Flags: []; Data: @EqualityComparer_Instance_LString),
      // tkWString
      (Flags: []; Data: @EqualityComparer_Instance_WString),
      // tkVariant
      (Flags: []; Data: @EqualityComparer_Instance_Variant),
      // tkArray
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_Binary),
      // tkRecord
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_Binary),
      // tkInterface
      (Flags: []; Data: @EqualityComparer_Instance_I4),
      // tkInt64
      (Flags: []; Data: @EqualityComparer_Instance_I8),
      // tkDynArray
      (Flags: [ifSelector]; Data: @EqualityComparer_Selector_DynArray),
      // tkUString
      (Flags: []; Data: @EqualityComparer_Instance_UString)
    )
  );

function _LookupVtableInfo(intf: TDefaultGenericInterface; info: PTypeInfo; size: Integer): Pointer;
var
  pinfo: PVtableInfo;
begin
  if info <> nil then
  begin
    pinfo := @VtableInfo[intf, info^.Kind];
    Result := pinfo^.Data;
    if ifSelector in pinfo^.Flags then
      Result := TTypeInfoSelector(Result)(info, size);
    if ifVariableSize in pinfo^.Flags then
      Result := MakeInstance(Result, size);
  end
  else
  begin
    case intf of
      giComparer: Result := Comparer_Selector_Binary(info, size);
      giEqualityComparer: Result := EqualityComparer_Selector_Binary(info, size);
    else
      System.Error(reRangeError);
      Result := nil;
    end;
  end;
end;

{ TSingletonImplementation }

function TSingletonImplementation.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TSingletonImplementation._AddRef: Integer;
begin
  Result := -1;
end;

function TSingletonImplementation._Release: Integer;
begin
  Result := -1;
end;

{ Delegated Comparers }

constructor TDelegatedEqualityComparer<T>.Create(const AEquals: TEqualityComparison<T>; 
  const AGetHashCode: THasher<T>);
begin
  FEquals := AEquals;
  FGetHashCode := AGetHashCode;
end;

function TDelegatedEqualityComparer<T>.Equals(const Left, Right: T): Boolean;
begin
  Result := FEquals(Left, Right);
end;

function TDelegatedEqualityComparer<T>.GetHashCode(const Value: T): Integer;
begin
  Result := FGetHashCode(Value);
end;

constructor TDelegatedComparer<T>.Create(const ACompare: TComparison<T>);
begin
  FCompare := ACompare;
end;

function TDelegatedComparer<T>.Compare(const Left, Right: T): Integer;
begin
  Result := FCompare(Left, Right);
end;

{ TOrdinalStringComparer }

type
  TOrdinalStringComparer = class(TStringComparer)
  public
    function Compare(const Left, Right: string): Integer; override;
    function Equals(const Left, Right: string): Boolean; 
      reintroduce; overload; override;
    function GetHashCode(const Value: string): Integer;
      reintroduce; overload; override;
  end;

function TOrdinalStringComparer.Compare(const Left, Right: string): Integer;
var
  len, lenDiff: Integer;
begin
  len := Length(Left);
  lenDiff := len - Length(Right);
  if lenDiff < 0 then
    Inc(len, lenDiff);
  Result := BinaryCompare(PChar(Left), PChar(Right), len * SizeOf(Char));
  if Result = 0 then
    Exit(lenDiff);
end;

function TOrdinalStringComparer.Equals(const Left, Right: string): Boolean;
var
  len: Integer;
begin
  len := Length(Left);
  
  Result := (len - Length(Right) = 0) and CompareMem(PChar(Left), PChar(Right), len * SizeOf(Char));
end;

function TOrdinalStringComparer.GetHashCode(const Value: string): Integer;
begin
  Result := BobJenkinsHash(PChar(Value)^, SizeOf(Char) * Length(Value), 0);
end;

{ TStringComparer }

class function TStringComparer.Ordinal: TStringComparer;
begin
  if FOrdinal = nil then
    FOrdinal := TOrdinalStringComparer.Create;
  Result := TStringComparer(FOrdinal);
end;

function ExtendedHashImpl(Value: Extended): Integer;
var
  m: Extended;
  e: Integer;
begin
  // Denormalized floats and positive/negative 0.0 complicate things.
  Frexp(Value, m, e);
  if m = 0 then
    m := Abs(m);
  Result := BobJenkinsHash(m, SizeOf(m), 0);
  Result := BobJenkinsHash(e, SizeOf(e), Result);
end;

function ExtendedHash(Value: Pointer; Size: Integer): Integer;
begin
  Result := ExtendedHashImpl(PExtended(Value)^);
end;

function DoubleHash(Value: Pointer; Size: Integer): Integer;
begin
  Result := ExtendedHashImpl(PDouble(Value)^);
end;

function SingleHash(Value: Pointer; Size: Integer): Integer;
begin
  Result := ExtendedHashImpl(PSingle(Value)^);
end;

{ TComparer<T> }

class function TComparer<T>.Default: IComparer<T>;
begin
  Result := IComparer<T>(_LookupVtableInfo(giComparer, TypeInfo(T), SizeOf(T)));
end;

class function TComparer<T>.Construct(const Comparison: TComparison<T>): IComparer<T>;
begin
  Result := TDelegatedComparer<T>.Create(Comparison);
end;

{ TEqualityComparer<T> }

class function TEqualityComparer<T>.Default: IEqualityComparer<T>;
begin
  Result := IEqualityComparer<T>(_LookupVtableInfo(giEqualityComparer, TypeInfo(T), SizeOf(T)));
end;

class function TEqualityComparer<T>.Construct(
  const EqualityComparison: TEqualityComparison<T>;
  const Hasher: THasher<T>): IEqualityComparer<T>;
begin
  Result := TDelegatedEqualityComparer<T>.Create(
    EqualityComparison, Hasher);
end;

{ BobJenkinsHash }

function Rot(x, k: Cardinal): Cardinal; inline;
begin
  Result := (x shl k) or (x shr (32 - k));
end;

procedure Mix(var a, b, c: Cardinal); inline;
begin
  Dec(a, c); a := a xor Rot(c, 4); Inc(c, b);
  Dec(b, a); b := b xor Rot(a, 6); Inc(a, c);
  Dec(c, b); c := c xor Rot(b, 8); Inc(b, a);
  Dec(a, c); a := a xor Rot(c,16); Inc(c, b);
  Dec(b, a); b := b xor Rot(a,19); Inc(a, c);
  Dec(c, b); c := c xor Rot(b, 4); Inc(b, a);
end;

procedure Final(var a, b, c: Cardinal); inline;
begin
  c := c xor b; Dec(c, Rot(b,14));
  a := a xor c; Dec(a, Rot(c,11));
  b := b xor a; Dec(b, Rot(a,25));
  c := c xor b; Dec(c, Rot(b,16));
  a := a xor c; Dec(a, Rot(c, 4));
  b := b xor a; Dec(b, Rot(a,14));
  c := c xor b; Dec(c, Rot(b,24));
end;

{$POINTERMATH ON}

// http://burtleburtle.net/bob/c/lookup3.c
function HashLittle(const Data; Len, InitVal: Integer): Integer;
var
  pb: PByte;
  pd: PCardinal absolute pb;
  a, b, c: Cardinal;
label
  case_1, case_2, case_3, case_4, case_5, case_6, 
  case_7, case_8, case_9, case_10, case_11, case_12;
begin
  a := Cardinal($DEADBEEF) + Cardinal(Len shl 2) + Cardinal(InitVal);
  b := a;
  c := a;
  
  pb := @Data;
  
  // 4-byte aligned data
  if (Cardinal(pb) and 3) = 0 then
  begin
    while Len > 12 do
    begin
      Inc(a, pd[0]);
      Inc(b, pd[1]);
      Inc(c, pd[2]);
      Mix(a, b, c);
      Dec(Len, 12);
      Inc(pd, 3);
    end;
    
    case Len of
      0: Exit(Integer(c));
      1: Inc(a, pd[0] and $FF);
      2: Inc(a, pd[0] and $FFFF);
      3: Inc(a, pd[0] and $FFFFFF);
      4: Inc(a, pd[0]);
      5:
      begin
        Inc(a, pd[0]);
        Inc(b, pd[1] and $FF);
      end;
      6:
      begin
        Inc(a, pd[0]);
        Inc(b, pd[1] and $FFFF);
      end;
      7:
      begin
        Inc(a, pd[0]);
        Inc(b, pd[1] and $FFFFFF);
      end;
      8:
      begin
        Inc(a, pd[0]);
        Inc(b, pd[1]);
      end;
      9:
      begin
        Inc(a, pd[0]);
        Inc(b, pd[1]);
        Inc(c, pd[2] and $FF);
      end;
      10:
      begin
        Inc(a, pd[0]);
        Inc(b, pd[1]);
        Inc(c, pd[2] and $FFFF);
      end;
      11:
      begin
        Inc(a, pd[0]);
        Inc(b, pd[1]);
        Inc(c, pd[2] and $FFFFFF);
      end;
      12:
      begin
        Inc(a, pd[0]);
        Inc(b, pd[1]);
        Inc(c, pd[2]);
      end;
    end;
  end
  else
  begin
    // Ignoring rare case of 2-byte aligned data. This handles all other cases.
    while Len > 12 do
    begin
      Inc(a, pb[0] + pb[1] shl 8 + pb[2] shl 16 + pb[3] shl 24);
      Inc(b, pb[4] + pb[5] shl 8 + pb[6] shl 16 + pb[7] shl 24);
      Inc(c, pb[8] + pb[9] shl 8 + pb[10] shl 16 + pb[11] shl 24);
      Mix(a, b, c);
      Dec(Len, 12);
      Inc(pb, 12);
    end;
    
    case Len of
      0: Exit(c);
      1: goto case_1;
      2: goto case_2;
      3: goto case_3;
      4: goto case_4;
      5: goto case_5;
      6: goto case_6;
      7: goto case_7;
      8: goto case_8;
      9: goto case_9;
      10: goto case_10;
      11: goto case_11;
      12: goto case_12;
    end;
    
case_12:
    Inc(c, pb[11] shl 24);
case_11:
    Inc(c, pb[10] shl 16);
case_10:
    Inc(c, pb[9] shl 8);
case_9:
    Inc(c, pb[8]);
case_8:
    Inc(b, pb[7] shl 24);
case_7:
    Inc(b, pb[6] shl 16);
case_6:
    Inc(b, pb[5] shl 8);
case_5:
    Inc(b, pb[4]);
case_4:
    Inc(a, pb[3] shl 24);
case_3:
    Inc(a, pb[2] shl 16);
case_2:
    Inc(a, pb[1] shl 8);
case_1:
    Inc(a, pb[0]);
  end;
  
  Final(a, b, c);
  Result := Integer(c);
end;

function BobJenkinsHash(const Data; Len, InitData: Integer): Integer;
begin
  Result := HashLittle(Data, Len, InitData);
end;

end.


