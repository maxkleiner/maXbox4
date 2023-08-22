unit xrtl_util_Map;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_Value, xrtl_util_Lock, xrtl_util_Type,
  xrtl_util_Array, xrtl_util_Container, xrtl_util_Compat;

type
  TXRTLMap = class(TXRTLKeyValueContainer)
  private
  public
  end;

  TXRTLSynchronizedMap = class(TXRTLMap)
  private
    FCoreMap: TXRTLMap;
    FOwnCoreMap: Boolean;
    FLock: IXRTLReadWriteLock;
  public
    constructor Create(const ACoreMap: TXRTLMap; AOwnCoreMap: Boolean = True;
                       const ALock: IXRTLReadWriteLock = nil);
    destructor Destroy; override;
    property   CoreMap: TXRTLMap read FCoreMap;
    property   OwnCoreMap: Boolean read FOwnCoreMap write FOwnCoreMap;
    property   Lock: IXRTLReadWriteLock read FLock;
    function   IsEmpty: Boolean; override;
    procedure  Clear; override;
    function   GetKeys: TXRTLValueArray; override;
    function   GetValues: TXRTLValueArray; override;
    function   GetValue(const IKey: IXRTLValue): IXRTLValue; overload; override;
    function   SetValue(const IKey, IValue: IXRTLValue): IXRTLValue; overload; override;
    function   HasKey(const IKey: IXRTLValue): Boolean; override;
    function   Remove(const IKey: IXRTLValue): IXRTLValue; overload; override;
    procedure  BeginRead;
    procedure  EndRead;
    procedure  BeginWrite;
    procedure  EndWrite;
  end;

  TXRTLArrayMap = class(TXRTLMap)
  private
    FValues: TXRTLArray;
    function   GetLoadFactor: Double;
    procedure  SetLoadFactor(const Value: Double);
  public
    constructor Create;
    destructor Destroy; override;
    function   IsEmpty: Boolean; override;
    procedure  Clear; override;
    function   GetKeys: TXRTLValueArray; override;
    function   GetValues: TXRTLValueArray; override;
    function   GetValue(const IKey: IXRTLValue): IXRTLValue; overload; override;
    function   SetValue(const IKey, IValue: IXRTLValue): IXRTLValue; overload; override;
    function   HasKey(const IKey: IXRTLValue): Boolean; override;
    function   Remove(const IKey: IXRTLValue): IXRTLValue; overload; override;
    function   GetSize: Integer;
    function   GetCapacity: Integer;
    procedure  TrimToSize;
    procedure  EnsureCapacity(const ACapacity: Integer);
    property   LoadFactor: Double read GetLoadFactor write SetLoadFactor;
  end;

implementation

{ TXRTLSynchronizedMap }

constructor TXRTLSynchronizedMap.Create(const ACoreMap: TXRTLMap;
  AOwnCoreMap: Boolean = True; const ALock: IXRTLReadWriteLock = nil);
begin
  inherited Create;
  FCoreMap:= ACoreMap;
  FOwnCoreMap:= AOwnCoreMap;
  FLock:= ALock;
  if not Assigned(FLock) then
    FLock:= XRTLCreateReadWriteLock;;
end;

destructor TXRTLSynchronizedMap.Destroy;
begin
  if FOwnCoreMap then
    FreeAndNil(FCoreMap);
  inherited;
end;

function TXRTLSynchronizedMap.IsEmpty: Boolean;
var
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginReadLock(FLock);
  Result:= FCoreMap.IsEmpty;
end;

procedure TXRTLSynchronizedMap.Clear;
var
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginWriteLock(FLock);
  FCoreMap.Clear;
end;

function TXRTLSynchronizedMap.GetKeys: TXRTLValueArray;
var
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginReadLock(FLock);
  Result:= FCoreMap.GetKeys;
end;

function TXRTLSynchronizedMap.GetValues: TXRTLValueArray;
var
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginReadLock(FLock);
  Result:= FCoreMap.GetValues;
end;

function TXRTLSynchronizedMap.GetValue(const IKey: IXRTLValue): IXRTLValue;
var
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginReadLock(FLock);
  Result:= FCoreMap.GetValue(IKey);
end;

function TXRTLSynchronizedMap.SetValue(const IKey, IValue: IXRTLValue): IXRTLValue;
var
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginWriteLock(FLock);
  Result:= FCoreMap.SetValue(IKey, IValue);
end;

function TXRTLSynchronizedMap.HasKey(const IKey: IXRTLValue): Boolean;
var
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginReadLock(FLock);
  Result:= FCoreMap.HasKey(IKey);
end;

function TXRTLSynchronizedMap.Remove(const IKey: IXRTLValue): IXRTLValue;
var
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginWriteLock(FLock);
  Result:= FCoreMap.Remove(IKey);
end;

procedure TXRTLSynchronizedMap.BeginRead;
begin
  FLock.BeginRead;
end;

procedure TXRTLSynchronizedMap.EndRead;
begin
  FLock.EndRead;
end;

procedure TXRTLSynchronizedMap.BeginWrite;
begin
  FLock.BeginWrite;
end;

procedure TXRTLSynchronizedMap.EndWrite;
begin
  FLock.EndWrite;
end;

{ TXRTLArrayMap }

constructor TXRTLArrayMap.Create;
begin
  inherited Create;
  FValues:= TXRTLArray.Create;
  FValues.Sorted:= True;
  FValues.Duplicates:= dupError;
end;

destructor TXRTLArrayMap.Destroy;
begin
  FreeAndNil(FValues);
  inherited;
end;

function TXRTLArrayMap.IsEmpty: Boolean;
begin
  Result:= FValues.IsEmpty;
end;

procedure TXRTLArrayMap.Clear;
begin
  FValues.Clear;
end;

function TXRTLArrayMap.GetKeys: TXRTLValueArray;
var
  LValues: TXRTLArray;
  Item: TXRTLKeyValuePair;
  Index: Integer;
begin
  SetLength(Result, 0);
  LValues:= nil;
  try
    LValues:= TXRTLArray.Create;
    for Index:= 0 to FValues.GetSize - 1 do
    begin
      XRTLGetAsObject(FValues.GetValue(Index), Item);
      LValues.Add(Item.Key);
    end;
    Result:= LValues.GetValues;
  finally
    FreeAndNil(LValues);
  end;
end;

function TXRTLArrayMap.GetValues: TXRTLValueArray;
var
  LValues: TXRTLArray;
  Item: TXRTLKeyValuePair;
  Index: Integer;
begin
  SetLength(Result, 0);
  LValues:= nil;
  try
    LValues:= TXRTLArray.Create;
    for Index:= 0 to FValues.GetSize - 1 do
    begin
      XRTLGetAsObject(FValues.GetValue(Index), Item);
      LValues.Add(Item.Value);
    end;
    Result:= LValues.GetValues;
  finally
    FreeAndNil(LValues);
  end;
end;

function TXRTLArrayMap.GetValue(const IKey: IXRTLValue): IXRTLValue;
var
  Item: TXRTLKeyValuePair;
  Iterator: IXRTLIterator;
begin
  Item:= nil;
  Result:= nil;
  try
    Item:= TXRTLKeyValuePair.Create(IKey);
    if FValues.Find(XRTLValue(Item), Iterator) then
      Result:= (XRTLGetAsObject(FValues.GetValue(Iterator)) as TXRTLKeyValuePair).Value;
  finally
    FreeAndNil(Item);
  end;
end;

function TXRTLArrayMap.SetValue(const IKey, IValue: IXRTLValue): IXRTLValue;
var
  Item, FItem: TXRTLKeyValuePair;
  Iterator: IXRTLIterator;
begin
  Item:= nil;
  Result:= nil;
  try
    Item:= TXRTLKeyValuePair.Create(IKey, IValue);
    if FValues.Find(XRTLValue(Item), Iterator) then
    begin
      XRTLGetAsObject(FValues.GetValue(Iterator), FItem);
      Result:= FItem.Value;
      FItem.Value:= IValue;
    end
    else
    begin
      FValues.Add(XRTLValue(Item, True));
      Item:= nil;
    end;
  finally
    FreeAndNil(Item);
  end;
end;

function TXRTLArrayMap.HasKey(const IKey: IXRTLValue): Boolean;
var
  Item: TXRTLKeyValuePair;
  Iterator: IXRTLIterator;
begin
  Item:= nil;
  try
    Item:= TXRTLKeyValuePair.Create(IKey);
    Result:= FValues.Find(XRTLValue(Item), Iterator);
  finally
    FreeAndNil(Item);
  end;
end;

function TXRTLArrayMap.Remove(const IKey: IXRTLValue): IXRTLValue;
var
  Item: TXRTLKeyValuePair;
  Iterator: IXRTLIterator;
begin
  Item:= nil;
  Result:= nil;
  try
    Item:= TXRTLKeyValuePair.Create(IKey);
    if FValues.Find(XRTLValue(Item), Iterator) then
    begin
      Result:= (XRTLGetAsObject(FValues.GetValue(Iterator)) as TXRTLKeyValuePair).Value;
      FValues.Remove(Iterator);
    end;
  finally
    FreeAndNil(Item);
  end;
end;

function TXRTLArrayMap.GetSize: Integer;
begin
  Result:= FValues.GetSize;
end;

function TXRTLArrayMap.GetCapacity: Integer;
begin
  Result:= FValues.GetCapacity;
end;

procedure TXRTLArrayMap.TrimToSize;
begin
  FValues.TrimToSize;
end;

procedure TXRTLArrayMap.EnsureCapacity(const ACapacity: Integer);
begin
  FValues.EnsureCapacity(ACapacity);
end;

function TXRTLArrayMap.GetLoadFactor: Double;
begin
  Result:= FValues.LoadFactor;
end;

procedure TXRTLArrayMap.SetLoadFactor(const Value: Double);
begin
  FValues.LoadFactor:= Value;
end;

end.
