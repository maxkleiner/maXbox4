unit xrtl_util_Array;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_Compare, xrtl_util_Exception, xrtl_util_Value, xrtl_util_Container,
  xrtl_util_Compat;

const
  XRTLArrayMinCapacity = 16;

type
  TXRTLArray = class(TXRTLSequentialContainer)
  private
    FValues: TXRTLValueArray;
    FSorted: Boolean;
    FDuplicates: TXRTLContainerDuplicates;
    FSize: Integer;
    FLoadFactor: Double;
    procedure  SetSorted(const Value: Boolean);
    procedure  SetLoadFactor(const Value: Double);
    procedure  CheckLoad(CapacityDelta: Integer);
    function   InternalInsert(const IValue: IXRTLValue; const Index: Integer): Boolean;
    function   InternalRemove(const FromIndex, ToIndex: Integer): Boolean;
  public
    constructor Create(const InitialCapacity: Integer = XRTLArrayMinCapacity); overload;
    constructor Create(const ASorted: Boolean; const ADuplicates: TXRTLContainerDuplicates;
                       const InitialCapacity: Integer = XRTLArrayMinCapacity); overload;
    destructor Destroy; override;
    function   IsEmpty: Boolean; override;
    function   Add(const IValue: IXRTLValue): Boolean;
    function   Remove(const IValue: IXRTLValue): Boolean; overload;
    function   Find(const IValue: IXRTLValue; out Iterator: IXRTLIterator): Boolean; override;
    function   AtBegin: IXRTLIterator; override;
    function   AtEnd: IXRTLIterator; override;
    function   GetValues: TXRTLValueArray; override;
    function   GetValue(const Iterator: IXRTLIterator): IXRTLValue; overload; override;
    function   SetValue(const IValue: IXRTLValue; const Iterator: IXRTLIterator): IXRTLValue; overload; override;
    function   Insert(const IValue: IXRTLValue; const Iterator: IXRTLIterator = nil): Boolean; overload; override;
    function   Remove(const FromIterator: IXRTLIterator; const ToIterator: IXRTLIterator = nil): Boolean; overload; override;
    function   GetValue(const Index: Integer): IXRTLValue; overload;
    function   SetValue(const IValue: IXRTLValue; const Index: Integer): IXRTLValue; overload;
    function   Insert(const IValue: IXRTLValue; const Index: Integer): Boolean; overload;
    function   Remove(const Index: Integer): Boolean; overload;
    procedure  Sort;
    function   GetSize: Integer;
    function   GetCapacity: Integer;
    procedure  TrimToSize;
    procedure  EnsureCapacity(const ACapacity: Integer);
    property   Sorted: Boolean read FSorted write SetSorted;
    property   Duplicates: TXRTLContainerDuplicates read FDuplicates write FDuplicates;
    property   LoadFactor: Double read FLoadFactor write SetLoadFactor;
  end;

implementation

uses
  Windows, Math,
  xrtl_util_Type,
//  xrtl_util_MemoryUtils,
  xrtl_util_ResourceStrings;

type
  IXRTLArrayIterator = interface(IXRTLIterator)
  ['{191400B6-A56C-4AEF-B89A-38AB1CE81D14}']
    function   GetIndex: Integer;
  end;

  TXRTLArrayIterator = class(TInterfacedObject, IXRTLIterator, IXRTLArrayIterator)
  private
    FIndex: Integer;
  public
    constructor Create(const AIndex: Integer);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   Clone: IXRTLIterator;
    function   Next: IXRTLIterator;
    function   Prev: IXRTLIterator;
    function   GetIndex: Integer;
  end;

{ TXRTLArrayIterator }

constructor TXRTLArrayIterator.Create(const AIndex: Integer);
begin
  inherited Create;
  FIndex:= AIndex;
end;

function TXRTLArrayIterator.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LIndex: Integer;
begin
  LIndex:= (IValue as IXRTLArrayIterator).GetIndex;
  if FIndex = LIndex then
    Result:= XRTLEqualsValue
  else
    if FIndex < LIndex then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
end;

function TXRTLArrayIterator.Clone: IXRTLIterator;
begin
  Result:= TXRTLArrayIterator.Create(FIndex);
end;

function TXRTLArrayIterator.Next: IXRTLIterator;
begin
  Inc(FIndex);
  Result:= Self;
end;

function TXRTLArrayIterator.Prev: IXRTLIterator;
begin
  if FIndex = 0 then
    raise EXRTLAlreadyAtBeginException.Create(SXRTLAlreadyAtBeginException);
  Dec(FIndex);
  Result:= Self;
end;

function TXRTLArrayIterator.GetIndex: Integer;
begin
  Result:= FIndex;
end;

{ TXRTLArray }

constructor TXRTLArray.Create(const InitialCapacity: Integer = XRTLArrayMinCapacity);
begin
  Create(False, dupAllow, InitialCapacity);
end;

constructor TXRTLArray.Create(const ASorted: Boolean; const ADuplicates: TXRTLContainerDuplicates;
  const InitialCapacity: Integer = XRTLArrayMinCapacity);
begin
  inherited Create;
  SetLength(FValues, Max(XRTLArrayMinCapacity, InitialCapacity));
  ZeroMemory(@FValues[0], Length(FValues) * SizeOf(IXRTLValue));
  FSorted:= ASorted;
  FDuplicates:= ADuplicates;
  FSize:= 0;
  FLoadFactor:= 0.75;
end;

destructor TXRTLArray.Destroy;
begin
  Clear;
  TrimToSize;
  inherited;
end;

function TXRTLArray.InternalInsert(const IValue: IXRTLValue; const Index: Integer): Boolean;
begin
  if (Index < 0) or (Index > GetSize) then
    raise EXRTLInvalidPosition.CreateFmt(SXRTLArrayInvalidPosition, [Index, 'Insert']);
  CheckLoad(1);
  Result:= True;
  Move(FValues[Index], FValues[Index + 1], (FSize - Index) * SizeOf(IXRTLValue));
  Pointer(FValues[Index]):= nil;
  FValues[Index]:= IValue;
  Inc(FSize, 1);
end;

function TXRTLArray.InternalRemove(const FromIndex, ToIndex: Integer): Boolean;
var
  I, RemoveCount: Integer;
  LValues: TXRTLValueArray;
begin
  if (FromIndex < 0) or (FromIndex > GetSize) then
    raise EXRTLInvalidPosition.CreateFmt(SXRTLArrayInvalidPosition, [FromIndex, 'Remove']);
  if (ToIndex < 0) or (ToIndex > GetSize) then
    raise EXRTLInvalidPosition.CreateFmt(SXRTLArrayInvalidPosition, [ToIndex, 'Remove']);
  RemoveCount:= Min(FSize, Abs(ToIndex - FromIndex));
  Result:= RemoveCount > 0;
  if Result then
  begin
    SetLength(LValues, RemoveCount);
    for I:= FromIndex to ToIndex - 1 do
    begin
      LValues[I - FromIndex]:= FValues[I];
      FValues[I]:= nil;
    end;
    Move(FValues[ToIndex], FValues[FromIndex], (FSize - ToIndex) * SizeOf(IXRTLValue));
    for I:= FSize - RemoveCount to FSize - 1 do
    begin
      Pointer(FValues[I]):= nil;
    end;
    Dec(FSize, RemoveCount);
    CheckLoad(- RemoveCount);
    for I:= 0 to Length(LValues) - 1 do
    begin
      LValues[I]:= nil;
    end;
  end;
end;

function TXRTLArray.IsEmpty: Boolean;
begin
  Result:= GetSize = 0;
end;

function TXRTLArray.Add(const IValue: IXRTLValue): Boolean;
begin
  Result:= Insert(IValue);
end;

function TXRTLArray.Remove(const IValue: IXRTLValue): Boolean;
var
  ValuePosition: IXRTLIterator;
begin
  Result:= Find(IValue, ValuePosition);
  if Result then
    Result:= Remove(ValuePosition);
end;

function TXRTLArray.Find(const IValue: IXRTLValue; out Iterator: IXRTLIterator): Boolean;

  function BinarySearch(const IValue: IXRTLValue; var Index: Integer): Boolean;
  var
    L, H, I: Integer;
    C: TXRTLValueRelationship;
  begin
    Result:= False;
    L:= 0;
    H:= GetSize - 1;
    while L <= H do
    begin
      I:= (L + H) shr 1;
      C:= FValues[I].Compare(IValue);
      if C = XRTLLessThanValue then
      begin
        L:= I + 1;
      end
      else
      begin
        H:= I - 1;
        if C = XRTLEqualsValue then
        begin
          Result:= True;
          L:= I;
        end;
      end;
    end;
    Index:= L;
  end;

  function SimpleSearch(const IValue: IXRTLValue; var Index: Integer): Boolean;
  var
    I: Integer;
  begin
    Result:= False;
    for I:= 0 to GetSize - 1 do
    begin
      if FValues[I].Compare(IValue) = XRTLEqualsValue then
      begin
        Index:= I;
        Result:= True;
        Break;
      end;
    end;
    Index:= GetSize;
  end;

var
  Index: Integer;
begin
  Iterator:= nil;
  if FSorted then
    Result:= BinarySearch(IValue, Index)
  else
    Result:= SimpleSearch(IValue, Index);
  Iterator:= TXRTLArrayIterator.Create(Index);
end;

function TXRTLArray.AtBegin: IXRTLIterator;
begin
  Result:= TXRTLArrayIterator.Create(0);
end;

function TXRTLArray.AtEnd: IXRTLIterator;
begin
  Result:= TXRTLArrayIterator.Create(GetSize);
end;

function TXRTLArray.GetValues: TXRTLValueArray;
var
  I: Integer;
begin
  SetLength(Result, GetSize);
  for I:= 0 to FSize - 1 do
    Result[I]:= FValues[I];
end;

function TXRTLArray.GetValue(const Iterator: IXRTLIterator): IXRTLValue;
begin
  Result:= GetValue((Iterator as IXRTLArrayIterator).GetIndex);
end;

function TXRTLArray.SetValue(const IValue: IXRTLValue; const Iterator: IXRTLIterator): IXRTLValue;
begin
  Result:= SetValue(IValue, (Iterator as IXRTLArrayIterator).GetIndex);
end;

function TXRTLArray.Insert(const IValue: IXRTLValue; const Iterator: IXRTLIterator = nil): Boolean;
var
  InsertPosition: IXRTLIterator;
begin
  Result:= False;
  InsertPosition:= Iterator;
  if FSorted then
  begin
    if Find(IValue, InsertPosition) then
    begin
      case FDuplicates of
        dupAllow:
        begin
        end;
        dupIgnore:
        begin
          Exit;
        end;
        dupError:
        begin
          XRTLInvalidOperation(ClassName, 'Insert', SXRTLArrayInvalidDuplicate);
        end;
      end;
    end;
  end
  else
  begin
    if not Assigned(InsertPosition) then
      InsertPosition:= AtEnd;
  end;
  Result:= InternalInsert(IValue, (InsertPosition as IXRTLArrayIterator).GetIndex);
  InsertPosition.Next;
end;

function TXRTLArray.Remove(const FromIterator: IXRTLIterator; const ToIterator: IXRTLIterator = nil): Boolean;
var
  FromIndex, ToIndex: Integer;
begin
  FromIndex:= (FromIterator as IXRTLArrayIterator).GetIndex;
  if Assigned(ToIterator) then
    ToIndex:= (ToIterator as IXRTLArrayIterator).GetIndex
  else
    ToIndex:= FromIndex + 1;
  Result:= InternalRemove(FromIndex, ToIndex);
end;

function TXRTLArray.GetValue(const Index: Integer): IXRTLValue;
begin
  if (Index < 0) or (Index >= GetSize) then
    raise EXRTLInvalidPosition.CreateFmt(SXRTLArrayInvalidPosition, [Index, 'GetValue']);
  Result:= FValues[Index];
end;

function TXRTLArray.SetValue(const IValue: IXRTLValue; const Index: Integer): IXRTLValue;
begin
  if (Index < 0) or (Index >= GetSize) then
    raise EXRTLInvalidPosition.CreateFmt(SXRTLArrayInvalidPosition, [Index, 'GetValue']);
  Result:= FValues[Index];
  FValues[Index]:= IValue;
end;

function TXRTLArray.Insert(const IValue: IXRTLValue; const Index: Integer): Boolean;
begin
  Result:= InternalInsert(IValue, Index);
end;

function TXRTLArray.Remove(const Index: Integer): Boolean;
begin
  Result:= InternalRemove(Index, Index + 1);
end;

procedure TXRTLArray.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted:= Value;
    if FSorted then
      Sort;
  end;
end;

procedure TXRTLArray.Sort;
var
  Values: TXRTLValueArray;
  I: Integer;
begin
  SetLength(Values, 0);
  Values:= GetValues;
  Clear;
  for I:= 0 to Length(Values) - 1 do
  begin
    Add(Values[I]);
    Values[I]:= nil;
  end;
  SetLength(Values, 0);
end;

function TXRTLArray.GetSize: Integer;
begin
  Result:= FSize;
end;

function TXRTLArray.GetCapacity: Integer;
begin
  Result:= Length(FValues);
end;

procedure TXRTLArray.TrimToSize;
begin
  SetLength(FValues, Max(XRTLArrayMinCapacity, FSize));
end;

procedure TXRTLArray.EnsureCapacity(const ACapacity: Integer);
begin
  CheckLoad(Max(0, ACapacity - GetSize));
end;

procedure TXRTLArray.SetLoadFactor(const Value: Double);
begin
  FLoadFactor:= Max(0.01, Min(Value, 1.0));
  CheckLoad(0);
end;

procedure TXRTLArray.CheckLoad(CapacityDelta: Integer);
begin
  if CapacityDelta > 0 then
  begin
    if (Int64(GetSize) + CapacityDelta) > GetCapacity * LoadFactor then
    begin
      SetLength(FValues, GetCapacity * 2);
      ZeroMemory(@FValues[FSize], (GetCapacity - GetSize) * SizeOf(IXRTLValue));
    end;
  end
  else
  begin
    TrimToSize;
  end;
end;

end.
