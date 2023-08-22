{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit Generics.Collections;

{$R-,T-,X+,H+,B-}

interface

uses
  SysUtils, Classes, Generics.Defaults;

type
  TArray = class
  private
    class procedure QuickSort<T>(var Values: array of T; const Comparer: IComparer<T>;
      L, R: Integer);
  public
    class procedure Sort<T>(var Values: array of T); overload;
    class procedure Sort<T>(var Values: array of T; 
      const Comparer: IComparer<T>); overload;
    class procedure Sort<T>(var Values: array of T; 
      const Comparer: IComparer<T>; Index, Count: Integer); overload;

    class function BinarySearch<T>(const Values: array of T; const Item: T;
      out FoundIndex: Integer; const Comparer: IComparer<T>; 
      Index, Count: Integer): Boolean; overload;
    class function BinarySearch<T>(const Values: array of T; const Item: T;
      out FoundIndex: Integer; const Comparer: IComparer<T>): Boolean; overload;
    class function BinarySearch<T>(const Values: array of T; const Item: T;
      out FoundIndex: Integer): Boolean; overload;
  end;
  
  TCollectionNotification = (cnAdded, cnRemoved, cnExtracted);
  TCollectionNotifyEvent<T> = procedure(Sender: TObject; const Item: T; 
    Action: TCollectionNotification) of object;
  
  TEnumerator<T> = class abstract
  protected
    function DoGetCurrent: T; virtual; abstract;
    function DoMoveNext: Boolean; virtual; abstract;
  public
    property Current: T read DoGetCurrent;
    function MoveNext: Boolean;
  end;
  
  TEnumerable<T> = class abstract
  protected
    function DoGetEnumerator: TEnumerator<T>; virtual; abstract;
  public
    function GetEnumerator: TEnumerator<T>;
  end;
  
  TList<T> = class(TEnumerable<T>)
  private
    FItems: array of T;
    FCount: Integer;
    FComparer: IComparer<T>;
    FOnNotify: TCollectionNotifyEvent<T>;
    
    function GetCapacity: Integer;
    procedure SetCapacity(Value: Integer);
    procedure SetCount(Value: Integer);
    function GetItem(Index: Integer): T;
    procedure SetItem(Index: Integer; const Value: T);
    procedure Grow(ACount: Integer);
    procedure GrowCheck(ACount: Integer); inline;
    procedure DoDelete(Index: Integer; Notification: TCollectionNotification);
  protected
    function DoGetEnumerator: TEnumerator<T>; override;
    procedure Notify(const Item: T; Action: TCollectionNotification); virtual;
  public
    constructor Create; overload;
    constructor Create(const AComparer: IComparer<T>); overload;
    constructor Create(Collection: TEnumerable<T>); overload;
    destructor Destroy; override;
    
    function Add(const Value: T): Integer;
    
    procedure AddRange(const Values: array of T); overload;
    procedure AddRange(const Collection: IEnumerable<T>); overload;
    procedure AddRange(Collection: TEnumerable<T>); overload;
    
    procedure Insert(Index: Integer; const Value: T);
    
    procedure InsertRange(Index: Integer; const Values: array of T); overload;
    procedure InsertRange(Index: Integer; const Collection: IEnumerable<T>); overload;
    procedure InsertRange(Index: Integer; const Collection: TEnumerable<T>); overload;
    
    function Remove(const Value: T): Integer;
    procedure Delete(Index: Integer);
    procedure DeleteRange(AIndex, ACount: Integer);
    function Extract(const Value: T): T;
    
    procedure Clear;
    
    function Contains(const Value: T): Boolean;
    function IndexOf(const Value: T): Integer;
    function LastIndexOf(const Value: T): Integer;
    
    procedure Reverse;
    
    procedure Sort; overload;
    procedure Sort(const AComparer: IComparer<T>); overload;
    function BinarySearch(const Item: T; out Index: Integer): Boolean; overload;
    function BinarySearch(const Item: T; out Index: Integer; const AComparer: IComparer<T>): Boolean; overload;
    
    procedure TrimExcess;
    
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read FCount write SetCount;
    property Items[Index: Integer]: T read GetItem write SetItem; default;
    property OnNotify: TCollectionNotifyEvent<T> read FOnNotify write FOnNotify;

    type
      TEnumerator = class(TEnumerator<T>)
      private
        FList: TList<T>;
        FIndex: Integer;
        function GetCurrent: T;
      protected
        function DoGetCurrent: T; override;
        function DoMoveNext: Boolean; override;
      public
        constructor Create(AList: TList<T>);
        property Current: T read GetCurrent;
        function MoveNext: Boolean;
      end;
    
    function GetEnumerator: TEnumerator; reintroduce;
  end;
  
  // Queue implemented over array, using wrapping.
  TQueue<T> = class(TEnumerable<T>)
  private
    FHead: Integer;
    FTail: Integer;
    FCount: Integer;
    FItems: array of T;
    FOnNotify: TCollectionNotifyEvent<T>;
    procedure Grow;
    procedure SetCapacity(Value: Integer);
    function DoDequeue(Notification: TCollectionNotification): T;
  protected
    function DoGetEnumerator: TEnumerator<T>; override;
    procedure Notify(const Item: T; Action: TCollectionNotification); virtual;
  public
    constructor Create(Collection: TEnumerable<T>); overload;
    destructor Destroy; override;
    procedure Enqueue(const Value: T);
    function Dequeue: T;
    function Extract: T;
    function Peek: T;
    procedure Clear;
    procedure TrimExcess;
    property Count: Integer read FCount;
    property OnNotify: TCollectionNotifyEvent<T> read FOnNotify write FOnNotify;
    
    type
      TEnumerator = class(TEnumerator<T>)
      private
        FQueue: TQueue<T>;
        FIndex: Integer;
        function GetCurrent: T;
      protected
        function DoGetCurrent: T; override;
        function DoMoveNext: Boolean; override;
      public
        constructor Create(AQueue: TQueue<T>);
        property Current: T read GetCurrent;
        function MoveNext: Boolean;
      end;
    
    function GetEnumerator: TEnumerator; reintroduce;
  end;
  
  TStack<T> = class(TEnumerable<T>)
  private
    FCount: Integer;
    FItems: array of T;
    FOnNotify: TCollectionNotifyEvent<T>;
    procedure Grow;
    function DoPop(Notification: TCollectionNotification): T;
  protected
    function DoGetEnumerator: TEnumerator<T>; override;
    procedure Notify(const Item: T; Action: TCollectionNotification); virtual;
  public
    constructor Create(Collection: TEnumerable<T>); overload;
    destructor Destroy; override;
    procedure Clear;
    procedure Push(const Value: T);
    function Pop: T;
    function Peek: T;
    function Extract: T;
    procedure TrimExcess;
    property Count: Integer read FCount;
    property OnNotify: TCollectionNotifyEvent<T> read FOnNotify write FOnNotify;
    
    type
      TEnumerator = class(TEnumerator<T>)
      private
        FStack: TStack<T>;
        FIndex: Integer;
        function GetCurrent: T;
      protected
        function DoGetCurrent: T; override;
        function DoMoveNext: Boolean; override;
      public
        constructor Create(AStack: TStack<T>);
        property Current: T read GetCurrent;
        function MoveNext: Boolean;
      end;
    
    function GetEnumerator: TEnumerator; reintroduce;
  end;

  TPair<TKey,TValue> = record
    Key: TKey;
    Value: TValue;
  end;
  
  // Hash table using linear probing
  TDictionary<TKey,TValue> = class(TEnumerable<TPair<TKey,TValue>>)
  private
    type
      TItem = record
        HashCode: Integer;
        Key: TKey;
        Value: TValue;
      end;
      TItemArray = array of TItem;
  private
    FItems: TItemArray;
    FCount: Integer;
    FComparer: IEqualityComparer<TKey>;
    FGrowThreshold: Integer;
    
    procedure SetCapacity(ACapacity: Integer);
    procedure Rehash(NewCapPow2: Integer);
    procedure Grow;
    function GetBucketIndex(const Key: TKey; HashCode: Integer): Integer;
    function Hash(const Key: TKey): Integer;
    function GetItem(const Key: TKey): TValue;
    procedure SetItem(const Key: TKey; const Value: TValue);
    procedure RehashAdd(HashCode: Integer; const Key: TKey; const Value: TValue);
    procedure DoAdd(HashCode, Index: Integer; const Key: TKey; const Value: TValue);
    procedure DoSetValue(Index: Integer; const Value: TValue);
  protected
    function DoGetEnumerator: TEnumerator<TPair<TKey,TValue>>; override;
    procedure KeyNotify(const Key: TKey; Action: TCollectionNotification); virtual;
    procedure ValueNotify(const Value: TValue; Action: TCollectionNotification); virtual;
  public
    constructor Create(ACapacity: Integer = 0); overload;
    constructor Create(const AComparer: IEqualityComparer<TKey>); overload;
    constructor Create(ACapacity: Integer; const AComparer: IEqualityComparer<TKey>); overload;
    constructor Create(Collection: TEnumerable<TPair<TKey,TValue>>); overload;
    constructor Create(Collection: TEnumerable<TPair<TKey,TValue>>; const AComparer: IEqualityComparer<TKey>); overload;
    destructor Destroy; override;
    
    procedure Add(const Key: TKey; const Value: TValue);
    procedure Remove(const Key: TKey);
    procedure Clear;
    procedure TrimExcess;
    function TryGetValue(const Key: TKey; out Value: TValue): Boolean;
    procedure AddOrSetValue(const Key: TKey; const Value: TValue);
    function ContainsKey(const Key: TKey): Boolean;
    function ContainsValue(const Value: TValue): Boolean;
    
    property Items[const Key: TKey]: TValue read GetItem write SetItem; default;
    property Count: Integer read FCount;
    
    type
      TPairEnumerator = class(TEnumerator<TPair<TKey,TValue>>)
      private
        FDictionary: TDictionary<TKey,TValue>;
        FIndex: Integer;
        function GetCurrent: TPair<TKey,TValue>;
      protected
        function DoGetCurrent: TPair<TKey,TValue>; override;
        function DoMoveNext: Boolean; override;
      public
        constructor Create(ADictionary: TDictionary<TKey,TValue>);
        property Current: TPair<TKey,TValue> read GetCurrent;
        function MoveNext: Boolean;
      end;
      
      TKeyEnumerator = class(TEnumerator<TKey>)
      private
        FDictionary: TDictionary<TKey,TValue>;
        FIndex: Integer;
        function GetCurrent: TKey;
      protected
        function DoGetCurrent: TKey; override;
        function DoMoveNext: Boolean; override;
      public
        constructor Create(ADictionary: TDictionary<TKey,TValue>);
        property Current: TKey read GetCurrent;
        function MoveNext: Boolean;
      end;
      
      TValueEnumerator = class(TEnumerator<TValue>)
      private
        FDictionary: TDictionary<TKey,TValue>;
        FIndex: Integer;
        function GetCurrent: TValue;
      protected
        function DoGetCurrent: TValue; override;
        function DoMoveNext: Boolean; override;
      public
        constructor Create(ADictionary: TDictionary<TKey,TValue>);
        property Current: TValue read GetCurrent;
        function MoveNext: Boolean;
      end;

      TValueCollection = class(TEnumerable<TValue>)
      private
        FDictionary: TDictionary<TKey,TValue>;
        function GetCount: Integer;
      protected
        function DoGetEnumerator: TEnumerator<TValue>; override;
      public
        constructor Create(ADictionary: TDictionary<TKey,TValue>);
        function GetEnumerator: TValueEnumerator; reintroduce;
        property Count: Integer read GetCount;
      end;

      TKeyCollection = class(TEnumerable<TKey>)
      private
        FDictionary: TDictionary<TKey,TValue>;
        function GetCount: Integer;
      protected
        function DoGetEnumerator: TEnumerator<TKey>; override;
      public
        constructor Create(ADictionary: TDictionary<TKey,TValue>);
        function GetEnumerator: TKeyEnumerator; reintroduce;
        property Count: Integer read GetCount;
      end;
      
  private
    FOnKeyNotify: TCollectionNotifyEvent<TKey>;
    FOnValueNotify: TCollectionNotifyEvent<TValue>;
    FKeyCollection: TKeyCollection;
    FValueCollection: TValueCollection;
    function GetKeys: TKeyCollection;
    function GetValues: TValueCollection;
  public
    function GetEnumerator: TPairEnumerator; reintroduce;
    property Keys: TKeyCollection read GetKeys;
    property Values: TValueCollection read GetValues;
    property OnKeyNotify: TCollectionNotifyEvent<TKey> read FOnKeyNotify write FOnKeyNotify;
    property OnValueNotify: TCollectionNotifyEvent<TValue> read FOnValueNotify write FOnValueNotify;
  end;
  
  TObjectList<T: class> = class(TList<T>)
  private
    FOwnsObjects: Boolean;
  protected
    procedure Notify(const Value: T; Action: TCollectionNotification); override;
  public
    constructor Create(AOwnsObjects: Boolean = True); overload;
    constructor Create(const AComparer: IComparer<T>; AOwnsObjects: Boolean = True); overload;
    constructor Create(Collection: TEnumerable<T>; AOwnsObjects: Boolean = True); overload;
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;
  
  TObjectQueue<T: class> = class(TQueue<T>)
  private
    FOwnsObjects: Boolean;
  protected
    procedure Notify(const Value: T; Action: TCollectionNotification); override;
  public
    constructor Create(AOwnsObjects: Boolean = True); overload;
    constructor Create(Collection: TEnumerable<T>; AOwnsObjects: Boolean = True); overload;
    procedure Dequeue;
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;

  TObjectStack<T: class> = class(TStack<T>)
  private
    FOwnsObjects: Boolean;
  protected
    procedure Notify(const Value: T; Action: TCollectionNotification); override;
  public
    constructor Create(AOwnsObjects: Boolean = True); overload;
    constructor Create(Collection: TEnumerable<T>; AOwnsObjects: Boolean = True); overload;
    procedure Pop;
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
  end;
  
  TDictionaryOwnerships = set of (doOwnsKeys, doOwnsValues);
  
  TObjectDictionary<TKey,TValue> = class(TDictionary<TKey,TValue>)
  private
    FOwnerships: TDictionaryOwnerships;
  protected
    procedure KeyNotify(const Key: TKey; Action: TCollectionNotification); override;
    procedure ValueNotify(const Value: TValue; Action: TCollectionNotification); override;
  public
    constructor Create(Ownerships: TDictionaryOwnerships; ACapacity: Integer = 0); overload;
    constructor Create(Ownerships: TDictionaryOwnerships; 
      const AComparer: IEqualityComparer<TKey>); overload;
    constructor Create(Ownerships: TDictionaryOwnerships; ACapacity: Integer; 
      const AComparer: IEqualityComparer<TKey>); overload;
  end;
  
  PObject = ^TObject;
  ENotSupportedException = class(Exception);

function InCircularRange(Bottom, Item, TopInc: Integer): Boolean;

resourcestring
  sArgumentOutOfRange = 'Argument out of range';
  sErrorCantModifyWhileIterating = 'Cannot modify a collection while iterating';
  sUnbalancedOperation = 'Unbalanced stack or queue operation';
  sGenericItemNotFound = 'Item not found';
  sGenericDuplicateItem = 'Duplicates not allowed';

implementation

uses Windows, SysConst, RTLConsts, TypInfo;

{ TArray }

class function TArray.BinarySearch<T>(const Values: array of T; const Item: T;
  out FoundIndex: Integer; const Comparer: IComparer<T>; Index,
  Count: Integer): Boolean;
var
  L, H: Integer;
  mid, cmp: Integer;
begin
  if (Index < Low(Values)) or (Index > High(Values))
    or (Index + Count - 1 > High(Values)) or (Count < 0)
    or (Index + Count < 0) then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange);
  if Count = 0 then
  begin
    FoundIndex := 0;
    Exit(False);
  end;
  
  L := Index;
  H := Index + Count - 1;
  while L <= H do
  begin
    mid := L + (H - L) shr 1;
    cmp := Comparer.Compare(Values[mid], Item);
    if cmp < 0 then
      L := mid + 1
    else if cmp = 0 then
    begin
      FoundIndex := L;
      Exit(True);
    end;
    H := mid - 1;
  end;
  FoundIndex := L;
  Result := False;
end;

class function TArray.BinarySearch<T>(const Values: array of T; const Item: T;
  out FoundIndex: Integer; const Comparer: IComparer<T>): Boolean;
begin
  Result := BinarySearch<T>(Values, Item, FoundIndex, Comparer,
    Low(Values), Length(Values));
end;

class function TArray.BinarySearch<T>(const Values: array of T; const Item: T;
  out FoundIndex: Integer): Boolean;
begin
  Result := BinarySearch<T>(Values, Item, FoundIndex, TComparer<T>.Default, 
    Low(Values), Length(Values));
end;

class procedure TArray.QuickSort<T>(var Values: array of T; const Comparer: IComparer<T>;
  L, R: Integer);
var
  I, J: Integer;
  pivot, temp: T;
begin
  repeat
    I := L;
    J := R;
    pivot := Values[L + (R - L) shr 1];
    repeat
      while Comparer.Compare(Values[I], pivot) < 0 do
        Inc(I);
      while Comparer.Compare(Values[J], pivot) > 0 do
        Dec(J);
      if I <= J then
      begin
        if I <> J then
        begin
          temp := Values[I];
          Values[I] := Values[J];
          Values[J] := temp;
        end;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort<T>(Values, Comparer, L, J);
    L := I;
  until I >= R;
end;

class procedure TArray.Sort<T>(var Values: array of T);
begin
  QuickSort<T>(Values, TComparer<T>.Default, Low(Values), High(Values));
end;

class procedure TArray.Sort<T>(var Values: array of T; const Comparer: IComparer<T>);
begin
  QuickSort<T>(Values, Comparer, Low(Values), High(Values));
end;

class procedure TArray.Sort<T>(var Values: array of T; const Comparer: IComparer<T>; 
  Index, Count: Integer);
begin
  if (Index < Low(Values)) or (Index > High(Values)) 
    or (Index + Count - 1 > High(Values)) or (Count < 0)
    or (Index + Count < 0) then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange);
  if Count = 0 then
    Exit;
  QuickSort<T>(Values, Comparer, Index, Index + Count - 1);
end;

{ TList<T> }

function TList<T>.GetCapacity: Integer;
begin
  Result := Length(FItems);
end;

procedure TList<T>.SetCapacity(Value: Integer);
begin
  if Value < Count then
    Count := Value;
  SetLength(FItems, Value);
end;

procedure TList<T>.SetCount(Value: Integer);
begin
  if Value < 0 then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange);
  if Value > Capacity then
    SetCapacity(Value);
  if Value < Count then
    DeleteRange(Value, Count - Value);
  FCount := Value;
end;

function TList<T>.GetItem(Index: Integer): T;
begin
  if (Index < 0) or (Index >= Count) then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange);
  Result := FItems[Index];
end;

procedure TList<T>.SetItem(Index: Integer; const Value: T);
var
  oldItem: T;
begin
  if (Index < 0) or (Index >= Count) then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange);
    
  oldItem := FItems[Index];
  FItems[Index] := Value;
  
  Notify(oldItem, cnRemoved);
  Notify(Value, cnAdded);
end;

procedure TList<T>.Grow(ACount: Integer);
var
  newCount: Integer;
begin
  newCount := Length(FItems);
  if newCount = 0 then
    newCount := ACount
  else
    repeat
      newCount := newCount * 2;
      if newCount < 0 then
        OutOfMemoryError;
    until newCount >= ACount;
  Capacity := newCount;
end;

procedure TList<T>.GrowCheck(ACount: Integer);
begin
  if ACount > Length(FItems) then
    Grow(ACount)
  else if ACount < 0 then
    OutOfMemoryError;
end;

procedure TList<T>.Notify(const Item: T; Action: TCollectionNotification);
begin
  if Assigned(FOnNotify) then
    FOnNotify(Self, Item, Action);
end;

constructor TList<T>.Create;
begin
  Create(TComparer<T>.Default);
end;

constructor TList<T>.Create(const AComparer: IComparer<T>);
begin
  inherited Create;
  FComparer := AComparer;
  if FComparer = nil then
    FComparer := TComparer<T>.Default;
end;

constructor TList<T>.Create(Collection: TEnumerable<T>);
begin
  inherited Create;
  FComparer := TComparer<T>.Default;
  InsertRange(0, Collection);
end;

destructor TList<T>.Destroy;
begin
  Capacity := 0;
  inherited;
end;

function TList<T>.DoGetEnumerator: TEnumerator<T>;
begin
  Result := GetEnumerator;
end;

function TList<T>.Add(const Value: T): Integer;
begin
  GrowCheck(Count + 1);
  Result := Count;
  FItems[Count] := Value;
  Inc(FCount);
  Notify(Value, cnAdded);
end;
    
procedure TList<T>.AddRange(const Values: array of T);
begin
  InsertRange(Count, Values);
end;

procedure TList<T>.AddRange(const Collection: IEnumerable<T>);
begin
  InsertRange(Count, Collection);
end;

procedure TList<T>.AddRange(Collection: TEnumerable<T>);
begin
  InsertRange(Count, Collection);
end;

function TList<T>.BinarySearch(const Item: T; out Index: Integer): Boolean;
begin
  Result := TArray.BinarySearch<T>(FItems, Item, Index, FComparer, 0, Count);
end;

function TList<T>.BinarySearch(const Item: T; out Index: Integer;
  const AComparer: IComparer<T>): Boolean;
begin
  Result := TArray.BinarySearch<T>(FItems, Item, Index, AComparer, 0, Count);
end;

procedure TList<T>.Insert(Index: Integer; const Value: T);
begin
  if (Index < 0) or (Index > Count) then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange);
  
  GrowCheck(Count + 1);
  if Index <> Count then
  begin
    Move(FItems[Index], FItems[Index + 1], (Count - Index) * SizeOf(T));
    FillChar(FItems[Index], SizeOf(FItems[Index]), 0);
  end;
  FItems[Index] := Value;
  Inc(FCount);
  Notify(Value, cnAdded);
end;

procedure TList<T>.InsertRange(Index: Integer; const Values: array of T);
var
  i: Integer;
begin
  if (Index < 0) or (Index > Count) then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange);
  
  GrowCheck(Count + Length(Values));
  if Index <> Count then
  begin
    Move(FItems[Index], FItems[Index + Length(Values)], (Count - Index) * SizeOf(T));
    FillChar(FItems[Index], Length(Values) * SizeOf(T), 0);
  end;
  
  for i := 0 to Length(Values) - 1 do
    FItems[Index + i] := Values[i];

  Inc(FCount, Length(Values));
  
  for i := 0 to Length(Values) - 1 do
    Notify(Values[i], cnAdded);
end;

procedure TList<T>.InsertRange(Index: Integer; const Collection: IEnumerable<T>);
var
  item: T;
begin
  for item in Collection do
  begin
    Insert(Index, item);
    Inc(Index);
  end;
end;

procedure TList<T>.InsertRange(Index: Integer; const Collection: TEnumerable<T>);
var
  item: T;
begin
  for item in Collection do
  begin
    Insert(Index, item);
    Inc(Index);
  end;
end;

function TList<T>.Extract(const Value: T): T;
var
  index: Integer;
begin
  index := IndexOf(Value);
  if index < 0 then
    Result := Default(T)
  else
  begin
    Result := FItems[index];
    DoDelete(index, cnExtracted);
  end;
end;

function TList<T>.Remove(const Value: T): Integer;
begin
  Result := IndexOf(Value);
  if Result >= 0 then
    Delete(Result);
end;

procedure TList<T>.DoDelete(Index: Integer; Notification: TCollectionNotification);
var
  oldItem: T;
begin
  if (Index < 0) or (Index >= Count) then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange);
  oldItem := FItems[Index];
  FItems[Index] := Default(T);
  Dec(FCount);
  if Index <> Count then
  begin
    Move(FItems[Index + 1], FItems[Index], (Count - Index) * SizeOf(T));
    FillChar(FItems[Count], SizeOf(T), 0);
  end;
  Notify(oldItem, Notification);
end;

procedure TList<T>.Delete(Index: Integer);
begin
  DoDelete(Index, cnRemoved);
end;

procedure TList<T>.DeleteRange(AIndex, ACount: Integer);
var
  oldItems: array of T;
  tailCount, i: Integer;
begin
  if (AIndex < 0) or (ACount < 0) or (AIndex + ACount > Count)
    or (AIndex + ACount < 0) then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange);
  if ACount = 0 then
    Exit;
  
  SetLength(oldItems, ACount);
  Move(FItems[AIndex], oldItems[0], ACount * SizeOf(T));
  
  tailCount := Count - (AIndex + ACount);
  if tailCount > 0 then
  begin
    Move(FItems[AIndex + ACount], FItems[AIndex], tailCount * SizeOf(T));
    FillChar(FItems[AIndex + ACount], tailCount * SizeOf(T), 0);
  end
  else
  begin
    FillChar(FItems[AIndex], ACount * SizeOf(T), 0);
  end;
  Dec(FCount, ACount);
  
  for i := 0 to Length(oldItems) - 1 do
    Notify(oldItems[i], cnRemoved);
end;

procedure TList<T>.Clear;
begin
  Count := 0;
  Capacity := 0;
end;

function TList<T>.Contains(const Value: T): Boolean;
begin
  Result := IndexOf(Value) >= 0;
end;

function TList<T>.IndexOf(const Value: T): Integer;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if FComparer.Compare(FItems[i], Value) = 0 then
      Exit(i);
  Result := -1;
end;

function TList<T>.LastIndexOf(const Value: T): Integer;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
    if FComparer.Compare(FItems[i], Value) = 0 then
      Exit(i);
  Result := -1;
end;

procedure TList<T>.Reverse;
var
  tmp: T;
  b, e: Integer;
begin
  b := 0;
  e := Count - 1;
  while b < e do
  begin
    tmp := FItems[b];
    FItems[b] := FItems[e];
    FItems[e] := tmp;
    Inc(b);
    Dec(e);
  end;
end;

procedure TList<T>.Sort;
begin
  TArray.Sort<T>(FItems, FComparer, 0, Count);
end;

procedure TList<T>.Sort(const AComparer: IComparer<T>);
begin
  TArray.Sort<T>(FItems, AComparer, 0, Count);
end;

procedure TList<T>.TrimExcess;
begin
  Capacity := Count;
end;

function TList<T>.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

{ TList<T>.TEnumerator }

constructor TList<T>.TEnumerator.Create(AList: TList<T>);
begin
  inherited Create;
  FList := AList;
  FIndex := -1;
end;

function TList<T>.TEnumerator.DoGetCurrent: T;
begin
  Result := GetCurrent;
end;

function TList<T>.TEnumerator.DoMoveNext: Boolean;
begin
  Result := MoveNext;
end;

function TList<T>.TEnumerator.GetCurrent: T;
begin
  Result := FList[FIndex];
end;

function TList<T>.TEnumerator.MoveNext: Boolean;
begin
  if FIndex >= FList.Count then
    Exit(False);
  Inc(FIndex);
  Result := FIndex < FList.Count;
end;
    
{ TQueue<T> }

procedure TQueue<T>.Notify(const Item: T; Action: TCollectionNotification);
begin
  if Assigned(FOnNotify) then
    FOnNotify(Self, Item, Action);
end;

function TQueue<T>.Dequeue: T;
begin
  Result := DoDequeue(cnRemoved);
end;

destructor TQueue<T>.Destroy;
begin
  Clear;
  inherited;
end;

function TQueue<T>.DoGetEnumerator: TEnumerator<T>;
begin
  Result := GetEnumerator;
end;

procedure TQueue<T>.Enqueue(const Value: T);
begin
  if Count = Length(FItems) then
    Grow;
  FItems[FHead] := Value;
  FHead := (FHead + 1) mod Length(FItems);
  Inc(FCount);
  Notify(Value, cnAdded);
end;

function TQueue<T>.Extract: T;
begin
  Result := DoDequeue(cnExtracted);
end;

constructor TQueue<T>.Create(Collection: TEnumerable<T>);
var
  item: T;
begin
  inherited Create;
  for item in Collection do
    Enqueue(item);
end;

function TQueue<T>.DoDequeue(Notification: TCollectionNotification): T;
begin
  if Count = 0 then
    raise EListError.CreateRes(@sUnbalancedOperation);
  Result := FItems[FTail];
  FItems[FTail] := Default(T);
  FTail := (FTail + 1) mod Length(FItems);
  Dec(FCount);
  Notify(Result, Notification);
end;

function TQueue<T>.Peek: T;
begin
  if Count = 0 then
    raise EListError.CreateRes(@sUnbalancedOperation);
  Result := FItems[FTail];
end;

procedure TQueue<T>.Clear;
begin
  while Count > 0 do
    Dequeue;
  FHead := 0;
  FTail := 0;
  FCount := 0;
end;

procedure TQueue<T>.TrimExcess;
begin
  SetCapacity(Count);
end;

procedure TQueue<T>.SetCapacity(Value: Integer);
var
  tailCount, offset: Integer;
begin
  offset := Value - Length(FItems);
  if offset = 0 then
    Exit;
  
  // If head <= tail, then part of the queue wraps around
  // the end of the array; don't introduce a gap in the queue.
  if (FHead < FTail) or ((FHead = FTail) and (Count > 0)) then
    tailCount := Length(FItems) - FTail
  else
    tailCount := 0;
  
  if offset > 0 then
    SetLength(FItems, Value);
  if tailCount > 0 then
  begin
    Move(FItems[FTail], FItems[FTail + offset], tailCount * SizeOf(FItems[0]));
    if offset > 0 then
      FillChar(FItems[FTail], offset * SizeOf(FItems[0]), 0);
    Inc(FTail, offset);
  end;
  if offset < 0 then
    SetLength(FItems, Value);
end;

procedure TQueue<T>.Grow;
var
  newCap: Integer;
begin
  newCap := Length(FItems) * 2;
  if newCap = 0 then
    newCap := 4
  else if newCap < 0 then
    OutOfMemoryError;
  SetCapacity(newCap);
end;

function TQueue<T>.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

{ TQueue<T>.TEnumerator }

constructor TQueue<T>.TEnumerator.Create(AQueue: TQueue<T>);
begin
  inherited Create;
  FQueue := AQueue;
  FIndex := -1;
end;

function TQueue<T>.TEnumerator.DoGetCurrent: T;
begin
  Result := GetCurrent;
end;

function TQueue<T>.TEnumerator.DoMoveNext: Boolean;
begin
  Result := MoveNext;
end;

function TQueue<T>.TEnumerator.GetCurrent: T;
begin
  Result := FQueue.FItems[(FQueue.FTail + FIndex) mod Length(FQueue.FItems)];
end;

function TQueue<T>.TEnumerator.MoveNext: Boolean;
begin
  if FIndex >= FQueue.Count then
    Exit(False);
  Inc(FIndex);
  Result := FIndex < FQueue.Count;
end;

{ TStack<T> }

procedure TStack<T>.Notify(const Item: T; Action: TCollectionNotification);
begin
  if Assigned(FOnNotify) then
    FOnNotify(Self, Item, Action);
end;

constructor TStack<T>.Create(Collection: TEnumerable<T>);
var
  item: T;
begin
  inherited Create;
  for item in Collection do
    Push(item);
end;

destructor TStack<T>.Destroy;
begin
  Clear;
  inherited;
end;

function TStack<T>.DoGetEnumerator: TEnumerator<T>;
begin
  Result := GetEnumerator;
end;

procedure TStack<T>.Grow;
var
  newCap: Integer;
begin
  newCap := Length(FItems) * 2;
  if newCap = 0 then
    newCap := 4
  else if newCap < 0 then
    OutOfMemoryError;
  SetLength(FItems, newCap);
end;

procedure TStack<T>.Push(const Value: T);
begin
  if Count = Length(FItems) then
    Grow;
  FItems[Count] := Value;
  Inc(FCount);
  Notify(Value, cnAdded);
end;

function TStack<T>.DoPop(Notification: TCollectionNotification): T;
begin
  if Count = 0 then
    raise EListError.CreateRes(@sUnbalancedOperation);
  Dec(FCount);
  Result := FItems[Count];
  FItems[Count] := Default(T);
  Notify(Result, Notification);
end;

function TStack<T>.Extract: T;
begin
  Result := DoPop(cnExtracted);
end;

function TStack<T>.Peek: T;
begin
  if Count = 0 then
    raise EListError.CreateRes(@sUnbalancedOperation);
  Result := FItems[Count - 1];
end;

function TStack<T>.Pop: T;
begin
  Result := DoPop(cnRemoved);
end;

procedure TStack<T>.Clear; 
begin
  while Count > 0 do
    Pop;
  SetLength(FItems, 0);
end;

procedure TStack<T>.TrimExcess;
begin
  SetLength(FItems, Count);
end;

function TStack<T>.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

constructor TStack<T>.TEnumerator.Create(AStack: TStack<T>);
begin
  inherited Create;
  FStack := AStack;
  FIndex := -1;
end;

function TStack<T>.TEnumerator.DoGetCurrent: T;
begin
  Result := GetCurrent;
end;

function TStack<T>.TEnumerator.DoMoveNext: Boolean;
begin
  Result := MoveNext;
end;

function TStack<T>.TEnumerator.GetCurrent: T;
begin
  Result := FStack.FItems[FIndex];
end;

function TStack<T>.TEnumerator.MoveNext: Boolean;
begin
  if FIndex >= FStack.Count then
    Exit(False);
  Inc(FIndex);
  Result := FIndex < FStack.Count;
end;

{ TDictionary<TKey,TValue> }

procedure TDictionary<TKey,TValue>.Rehash(NewCapPow2: Integer);
var
  oldItems, newItems: TItemArray;
  i: Integer;
begin
  if NewCapPow2 = Length(FItems) then
    Exit
  else if NewCapPow2 < 0 then
    OutOfMemoryError;
  
  oldItems := FItems;
  SetLength(newItems, NewCapPow2);
  FItems := newItems;
  FGrowThreshold := NewCapPow2 shr 1 + NewCapPow2 shr 2;
  
  for i := 0 to Length(oldItems) - 1 do
    if oldItems[i].HashCode <> 0 then
      RehashAdd(oldItems[i].HashCode, oldItems[i].Key, oldItems[i].Value);
end;

procedure TDictionary<TKey,TValue>.SetCapacity(ACapacity: Integer);
var
  newCap: Integer;
begin
  if ACapacity < Count then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange);
  
  if ACapacity = 0 then
    Rehash(0)
  else
  begin
    newCap := 4;
    while newCap < ACapacity do
      newCap := newCap shl 1;
    Rehash(newCap);
  end
end;

procedure TDictionary<TKey,TValue>.Grow;
var
  newCap: Integer;
begin
  newCap := Length(FItems) * 2;
  if newCap = 0 then
    newCap := 4;
  Rehash(newCap);
end;

function TDictionary<TKey,TValue>.GetBucketIndex(const Key: TKey; HashCode: Integer): Integer;
var
  start, hc: Integer;
begin
  if Length(FItems) = 0 then
    Exit(not High(Integer));
  
  start := HashCode and (Length(FItems) - 1);
  Result := start;
  while True do
  begin
    hc := FItems[Result].HashCode;
    
    // Not found: return complement of insertion point.
    if hc = 0 then
      Exit(not Result);
    
    // Found: return location.
    if (hc = HashCode) and FComparer.Equals(FItems[Result].Key, Key) then
      Exit(Result);
    
    Inc(Result);
    if Result >= Length(FItems) then
      Result := 0;
  end;
end;

function TDictionary<TKey,TValue>.Hash(const Key: TKey): Integer;
const
  PositiveMask = not Integer($80000000);
begin
  // Double-Abs to avoid -MaxInt and MinInt problems.
  // Not using compiler-Abs because we *must* get a positive integer;
  // for compiler, Abs(Low(Integer)) is a null op.
  Result := PositiveMask and ((PositiveMask and FComparer.GetHashCode(Key)) + 1);
end;

function TDictionary<TKey,TValue>.GetItem(const Key: TKey): TValue;
var
  index: Integer;
begin
  index := GetBucketIndex(Key, Hash(Key));
  if index < 0 then
    raise EListError.CreateRes(@sGenericItemNotFound);
  Result := FItems[index].Value;
end;

procedure TDictionary<TKey,TValue>.SetItem(const Key: TKey; const Value: TValue);
var
  index: Integer;
  oldValue: TValue;
begin
  index := GetBucketIndex(Key, Hash(Key));
  if index < 0 then
    raise EListError.CreateRes(@sGenericItemNotFound);
  
  oldValue := FItems[index].Value;
  FItems[index].Value := Value;
  
  ValueNotify(oldValue, cnRemoved);
  ValueNotify(Value, cnAdded);
end;

procedure TDictionary<TKey,TValue>.RehashAdd(HashCode: Integer; const Key: TKey; const Value: TValue);
var
  index: Integer;
begin
  index := not GetBucketIndex(Key, HashCode);
  FItems[index].HashCode := HashCode;
  FItems[index].Key := Key;
  FItems[index].Value := Value;
end;

procedure TDictionary<TKey,TValue>.KeyNotify(const Key: TKey; Action: TCollectionNotification);
begin
  if Assigned(FOnKeyNotify) then
    FOnKeyNotify(Self, Key, Action);
end;

procedure TDictionary<TKey,TValue>.ValueNotify(const Value: TValue; Action: TCollectionNotification);
begin
  if Assigned(FOnValueNotify) then
    FOnValueNotify(Self, Value, Action);
end;

constructor TDictionary<TKey,TValue>.Create(ACapacity: Integer = 0);
begin
  Create(ACapacity, nil);
end;

constructor TDictionary<TKey,TValue>.Create(const AComparer: IEqualityComparer<TKey>);
begin
  Create(0, AComparer);
end;

constructor TDictionary<TKey,TValue>.Create(ACapacity: Integer; const AComparer: IEqualityComparer<TKey>);
var
  cap: Integer;
begin
  inherited Create;
  if ACapacity < 0 then
    raise EArgumentOutOfRangeException.CreateRes(@sArgumentOutOfRange);
  FComparer := AComparer;
  if FComparer = nil then
    FComparer := TEqualityComparer<TKey>.Default;
  SetCapacity(ACapacity);
end;

constructor TDictionary<TKey, TValue>.Create(
  Collection: TEnumerable<TPair<TKey, TValue>>);
var
  item: TPair<TKey,TValue>;
begin
  Create(0, nil);
  for item in Collection do
    AddOrSetValue(item.Key, item.Value);
end;

constructor TDictionary<TKey, TValue>.Create(
  Collection: TEnumerable<TPair<TKey, TValue>>;
  const AComparer: IEqualityComparer<TKey>);
var
  item: TPair<TKey,TValue>;
begin
  Create(0, AComparer);
  for item in Collection do
    AddOrSetValue(item.Key, item.Value);
end;

destructor TDictionary<TKey,TValue>.Destroy;
begin
  Clear;
  inherited;
end;

procedure TDictionary<TKey,TValue>.Add(const Key: TKey; const Value: TValue);
var
  index, hc: Integer;
begin
  if Count >= FGrowThreshold then
    Grow;
  
  hc := Hash(Key);
  index := GetBucketIndex(Key, hc);
  if index >= 0 then
    raise EListError.CreateRes(@sGenericDuplicateItem);
  
  DoAdd(hc, not index, Key, Value);
end;

function InCircularRange(Bottom, Item, TopInc: Integer): Boolean;
begin
  Result := (Bottom < Item) and (Item <= TopInc) // normal
    or (TopInc < Bottom) and (Item > Bottom) // top wrapped
    or (TopInc < Bottom) and (Item <= TopInc) // top and item wrapped
end;

procedure TDictionary<TKey,TValue>.Remove(const Key: TKey);
var
  gap, index, hc, bucket: Integer;
  oldValue: TValue;
begin
  hc := Hash(Key);
  index := GetBucketIndex(Key, hc);
  if index < 0 then
    Exit;
  
  // Removing item from linear probe hash table is moderately
  // tricky. We need to fill in gaps, which will involve moving items
  // which may not even hash to the same location.
  // Knuth covers it well enough in Vol III. 6.4.; but beware, Algorithm R
  // (2nd ed) has a bug: step R4 should go to step R1, not R2 (already errata'd).
  // My version does linear probing forward, not backward, however.
  
  // gap refers to the hole that needs filling-in by shifting items down.
  // index searches for items that have been probed out of their slot,
  // but being careful not to move items if their bucket is between
  // our gap and our index (so that they'd be moved before their bucket).
  // We move the item at index into the gap, whereupon the new gap is
  // at the index. If the index hits a hole, then we're done.
  
  // If our load factor was exactly 1, we'll need to hit this hole
  // in order to terminate. Shouldn't normally be necessary, though.
  FItems[index].HashCode := 0;
  
  gap := index;
  while True do
  begin
    Inc(index);
    if index = Length(FItems) then
      index := 0;
    
    hc := FItems[index].HashCode;
    if hc = 0 then
      Break;
    
    bucket := hc and (Length(FItems) - 1);
    if not InCircularRange(gap, bucket, index) then
    begin
      FItems[gap] := FItems[index];
      gap := index;
      // The gap moved, but we still need to find it to terminate.
      FItems[gap].HashCode := 0;
    end;
  end;
  
  FItems[gap].HashCode := 0;
  FItems[gap].Key := Default(TKey);
  oldValue := FItems[gap].Value;
  FItems[gap].Value := Default(TValue);
  Dec(FCount);
  
  KeyNotify(Key, cnRemoved);
  ValueNotify(oldValue, cnRemoved);
end;

procedure TDictionary<TKey,TValue>.Clear;
var
  i: Integer;
  oldItems: TItemArray;
begin
  oldItems := FItems;
  FCount := 0;
  SetLength(FItems, 0);
  SetCapacity(0);
  
  for i := 0 to Length(oldItems) - 1 do
  begin
    if oldItems[i].HashCode = 0 then
      Continue;
    KeyNotify(oldItems[i].Key, cnRemoved);
    ValueNotify(oldItems[i].Value, cnRemoved);
  end;
end;

procedure TDictionary<TKey,TValue>.TrimExcess;
begin
  SetCapacity(Count);
end;

function TDictionary<TKey,TValue>.TryGetValue(const Key: TKey; out Value: TValue): Boolean;
var
  index: Integer;
begin
  index := GetBucketIndex(Key, Hash(Key));
  Result := index >= 0;
  if Result then
    Value := FItems[index].Value
  else
    Value := Default(TValue);
end;

procedure TDictionary<TKey,TValue>.DoAdd(HashCode, Index: Integer; const Key: TKey; const Value: TValue);
begin
  FItems[Index].HashCode := HashCode;
  FItems[Index].Key := Key;
  FItems[Index].Value := Value;
  Inc(FCount);
  
  KeyNotify(Key, cnAdded);
  ValueNotify(Value, cnAdded);
end;

function TDictionary<TKey, TValue>.DoGetEnumerator: TEnumerator<TPair<TKey, TValue>>;
begin
  Result := GetEnumerator;
end;

procedure TDictionary<TKey,TValue>.DoSetValue(Index: Integer; const Value: TValue);
var
  oldValue: TValue;
begin
  oldValue := FItems[Index].Value;
  FItems[Index].Value := Value;
  
  ValueNotify(oldValue, cnRemoved);
  ValueNotify(Value, cnAdded);
end;

procedure TDictionary<TKey,TValue>.AddOrSetValue(const Key: TKey; const Value: TValue);
var
  hc: Integer;
  index: Integer;
begin
  hc := Hash(Key);
  index := GetBucketIndex(Key, hc);
  if index >= 0 then
    DoSetValue(index, Value)
  else
    DoAdd(hc, not index, Key, Value);
end;

function TDictionary<TKey,TValue>.ContainsKey(const Key: TKey): Boolean;
begin
  Result := GetBucketIndex(Key, Hash(Key)) >= 0;
end;

function TDictionary<TKey,TValue>.ContainsValue(const Value: TValue): Boolean;
var
  i: Integer;
  c: IEqualityComparer<TValue>;
begin
  c := TEqualityComparer<TValue>.Default;
  
  for i := 0 to Length(FItems) - 1 do
    if (FItems[i].HashCode <> 0) and c.Equals(FItems[i].Value, Value) then
      Exit(True);
  Result := False;
end;

function TDictionary<TKey,TValue>.GetEnumerator: TPairEnumerator;
begin
  Result := TPairEnumerator.Create(Self);
end;

function TDictionary<TKey,TValue>.GetKeys: TKeyCollection;
begin
  if FKeyCollection = nil then
    FKeyCollection := TKeyCollection.Create(Self);
  Result := FKeyCollection;
end;

function TDictionary<TKey,TValue>.GetValues: TValueCollection;
begin
  if FValueCollection = nil then
    FValueCollection := TValueCollection.Create(Self);
  Result := FValueCollection;
end;

// Pairs

constructor TDictionary<TKey,TValue>.TPairEnumerator.Create(ADictionary: TDictionary<TKey,TValue>);
begin
  inherited Create;
  FIndex := -1;
  FDictionary := ADictionary;
end;

function TDictionary<TKey, TValue>.TPairEnumerator.DoGetCurrent: TPair<TKey, TValue>;
begin
  Result := GetCurrent;
end;

function TDictionary<TKey, TValue>.TPairEnumerator.DoMoveNext: Boolean;
begin
  Result := MoveNext;
end;

function TDictionary<TKey,TValue>.TPairEnumerator.GetCurrent: TPair<TKey,TValue>;
begin
  Result.Key := FDictionary.FItems[FIndex].Key;
  Result.Value := FDictionary.FItems[FIndex].Value;
end;

function TDictionary<TKey,TValue>.TPairEnumerator.MoveNext: Boolean;
begin
  while FIndex < Length(FDictionary.FItems) do
  begin
    Inc(FIndex);
    if FDictionary.FItems[FIndex].HashCode <> 0 then
      Exit(True);
  end;
  Result := False;
end;

// Keys

constructor TDictionary<TKey,TValue>.TKeyEnumerator.Create(ADictionary: TDictionary<TKey,TValue>);
begin
  inherited Create;
  FIndex := -1;
  FDictionary := ADictionary;
end;

function TDictionary<TKey, TValue>.TKeyEnumerator.DoGetCurrent: TKey;
begin
  Result := GetCurrent;
end;

function TDictionary<TKey, TValue>.TKeyEnumerator.DoMoveNext: Boolean;
begin
  Result := MoveNext;
end;

function TDictionary<TKey,TValue>.TKeyEnumerator.GetCurrent: TKey;
begin
  Result := FDictionary.FItems[FIndex].Key;
end;

function TDictionary<TKey,TValue>.TKeyEnumerator.MoveNext: Boolean;
begin
  while FIndex < Length(FDictionary.FItems) do
  begin
    Inc(FIndex);
    if FDictionary.FItems[FIndex].HashCode <> 0 then
      Exit(True);
  end;
  Result := False;
end;

// Values

constructor TDictionary<TKey,TValue>.TValueEnumerator.Create(ADictionary: TDictionary<TKey,TValue>);
begin
  inherited Create;
  FIndex := -1;
  FDictionary := ADictionary;
end;

function TDictionary<TKey, TValue>.TValueEnumerator.DoGetCurrent: TValue;
begin
  Result := GetCurrent;
end;

function TDictionary<TKey, TValue>.TValueEnumerator.DoMoveNext: Boolean;
begin
  Result := MoveNext;
end;

function TDictionary<TKey,TValue>.TValueEnumerator.GetCurrent: TValue;
begin
  Result := FDictionary.FItems[FIndex].Value;
end;

function TDictionary<TKey,TValue>.TValueEnumerator.MoveNext: Boolean;
begin
  while FIndex < Length(FDictionary.FItems) do
  begin
    Inc(FIndex);
    if FDictionary.FItems[FIndex].HashCode <> 0 then
      Exit(True);
  end;
  Result := False;
end;

{ TObjectList<T> }

constructor TObjectList<T>.Create(AOwnsObjects: Boolean);
begin
  inherited;
  FOwnsObjects := AOwnsObjects;
end;

constructor TObjectList<T>.Create(const AComparer: IComparer<T>; AOwnsObjects: Boolean);
begin
  inherited Create(AComparer);
  FOwnsObjects := AOwnsObjects;
end;

constructor TObjectList<T>.Create(Collection: TEnumerable<T>; AOwnsObjects: Boolean);
begin
  inherited Create(Collection);
  FOwnsObjects := AOwnsObjects;
end;

procedure TObjectList<T>.Notify(const Value: T; Action: TCollectionNotification);
begin
  inherited;
  if OwnsObjects and (Action = cnRemoved) then
    Value.Free;
end;

{ TObjectQueue<T> }

constructor TObjectQueue<T>.Create(AOwnsObjects: Boolean);
begin
  inherited Create;
  FOwnsObjects := AOwnsObjects;
end;

constructor TObjectQueue<T>.Create(Collection: TEnumerable<T>; AOwnsObjects: Boolean);
begin
  inherited Create(Collection);
  FOwnsObjects := AOwnsObjects;
end;

procedure TObjectQueue<T>.Dequeue;
begin
  inherited Dequeue;
end;

procedure TObjectQueue<T>.Notify(const Value: T; Action: TCollectionNotification);
begin
  inherited;
  if OwnsObjects and (Action = cnRemoved) then
    Value.Free;
end;

{ TObjectStack<T> }
  
constructor TObjectStack<T>.Create(AOwnsObjects: Boolean);
begin
  inherited Create;
  FOwnsObjects := AOwnsObjects;
end;

constructor TObjectStack<T>.Create(Collection: TEnumerable<T>; AOwnsObjects: Boolean);
begin
  inherited Create(Collection);
  FOwnsObjects := AOwnsObjects;
end;

procedure TObjectStack<T>.Notify(const Value: T; Action: TCollectionNotification);
begin
  inherited;
  if OwnsObjects and (Action = cnRemoved) then
    Value.Free;
end;
  
procedure TObjectStack<T>.Pop;
begin
  inherited Pop;
end;

{ TObjectDictionary<TKey,TValue> }

procedure TObjectDictionary<TKey,TValue>.KeyNotify(const Key: TKey; Action: TCollectionNotification);
begin
  inherited;
  if (Action = cnRemoved) and (doOwnsKeys in FOwnerships) then
    PObject(@Key)^.Free;
end;

procedure TObjectDictionary<TKey,TValue>.ValueNotify(const Value: TValue; Action: TCollectionNotification);
begin
  inherited;
  if (Action = cnRemoved) and (doOwnsValues in FOwnerships) then
    PObject(@Value)^.Free;
end;

constructor TObjectDictionary<TKey,TValue>.Create(Ownerships: TDictionaryOwnerships; 
  ACapacity: Integer = 0);
begin
  Create(Ownerships, ACapacity, nil);
end;

constructor TObjectDictionary<TKey,TValue>.Create(Ownerships: TDictionaryOwnerships; 
  const AComparer: IEqualityComparer<TKey>);
begin
  Create(Ownerships, 0, AComparer);
end;

constructor TObjectDictionary<TKey,TValue>.Create(Ownerships: TDictionaryOwnerships; 
  ACapacity: Integer; const AComparer: IEqualityComparer<TKey>);
begin
  inherited Create(ACapacity, AComparer);
  
  if doOwnsKeys in Ownerships then
  begin
    if (TypeInfo(TKey) = nil) or (PTypeInfo(TypeInfo(TKey))^.Kind <> tkClass) then
      raise EInvalidCast.CreateRes(@SInvalidCast);
  end;
  
  if doOwnsValues in Ownerships then
  begin
    if (TypeInfo(TValue) = nil) or (PTypeInfo(TypeInfo(TValue))^.Kind <> tkClass) then
      raise EInvalidCast.CreateRes(@SInvalidCast);
  end;
  
  FOwnerships := Ownerships;
end;
    
{ TDictionary<TKey, TValue>.TValueCollection }

constructor TDictionary<TKey, TValue>.TValueCollection.Create(
  ADictionary: TDictionary<TKey, TValue>);
begin
  inherited Create;
  FDictionary := ADictionary;
end;

function TDictionary<TKey, TValue>.TValueCollection.DoGetEnumerator: TEnumerator<TValue>;
begin
  Result := GetEnumerator;
end;

function TDictionary<TKey, TValue>.TValueCollection.GetCount: Integer;
begin
  Result := FDictionary.Count;
end;

function TDictionary<TKey, TValue>.TValueCollection.GetEnumerator: TValueEnumerator;
begin
  Result := TValueEnumerator.Create(FDictionary);
end;

{ TDictionary<TKey, TValue>.TKeyCollection }

constructor TDictionary<TKey, TValue>.TKeyCollection.Create(
  ADictionary: TDictionary<TKey, TValue>);
begin
  inherited Create;
  FDictionary := ADictionary;
end;

function TDictionary<TKey, TValue>.TKeyCollection.DoGetEnumerator: TEnumerator<TKey>;
begin
  Result := GetEnumerator;
end;

function TDictionary<TKey, TValue>.TKeyCollection.GetCount: Integer;
begin
  Result := FDictionary.Count;
end;

function TDictionary<TKey, TValue>.TKeyCollection.GetEnumerator: TKeyEnumerator;
begin
  Result := TKeyEnumerator.Create(FDictionary);
end;

{ TEnumerator<T> }

function TEnumerator<T>.MoveNext: Boolean;
begin
  Result := DoMoveNext;
end;

{ TEnumerable<T> }

function TEnumerable<T>.GetEnumerator: TEnumerator<T>;
begin
  Result := DoGetEnumerator;
end;

end.

