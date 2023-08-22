unit xrtl_util_Hashtable;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_Value,
  xrtl_util_Array, xrtl_util_Container;

const
  XRTLHashtableMinCapacity = 16;

type
  TXRTLHashtable = class(TXRTLSetContainer)
  end;

  TXRTLBaseHashtable = class(TXRTLHashtable)
  private
    procedure  SetLoadFactor(const Value: Double);
    procedure  Rehash(CapacityDelta: Integer);
  protected
    FCount: Integer;
    FData: TXRTLValueArray;
    FLoadFactor: Double;
    function   InternalHash(const IValue: IXRTLValue): Cardinal; virtual;
    function   IndexOf(const IValue: IXRTLValue): Integer;
    function   CreateEntriesContainer: TXRTLSequentialContainer; virtual; abstract;
  public
    constructor Create(const InitialCapacity: Cardinal = XRTLHashtableMinCapacity);
    destructor Destroy; override;
    function   IsEmpty: Boolean; override;
    procedure  Clear; override;
    function   GetValues: TXRTLValueArray; override;
    function   Add(const IValue: IXRTLValue): Boolean; overload; override;
    function   Remove(const IValue: IXRTLValue): Boolean; overload; override;
    function   HasValue(const IValue: IXRTLValue): Boolean; override;
    function   GetCapacity: Integer;
    procedure  EnsureCapacity(const ACapacity: Integer);
    property   LoadFactor: Double read FLoadFactor write SetLoadFactor;
  end;

  TXRTLArrayHashtable = class(TXRTLBaseHashtable)
  protected
    function   CreateEntriesContainer: TXRTLSequentialContainer; override;
  end;

  TXRTLLinkedListHashtable = class(TXRTLBaseHashtable)
  protected
    function   CreateEntriesContainer: TXRTLSequentialContainer; override;
  end;

implementation

uses
  Windows,
  Math,
  xrtl_util_Algorithm, xrtl_util_LinkedList;

{ TXRTLBaseHashtable }

constructor TXRTLBaseHashtable.Create(
  const InitialCapacity: Cardinal = XRTLHashtableMinCapacity);
begin
  inherited Create;
  SetLength(FData, Max(InitialCapacity, XRTLHashtableMinCapacity));
  ZeroMemory(@FData[0], Length(FData) * SizeOf(IXRTLValue));
  FLoadFactor:= 0.75;
  FCount:= 0;
end;

destructor TXRTLBaseHashtable.Destroy;
begin
  Clear;
  inherited;
end;

function TXRTLBaseHashtable.InternalHash(const IValue: IXRTLValue): Cardinal;
begin
  Result:= 0;
  if not Assigned(IValue) then
    Exit;
  Result:= IValue.GetHashCode;
  Result:= Result + not(Result shl 9);
  Result:= Result xor  (Result shr 14);
  Result:= Result +    (Result shl 4);
  Result:= Result xor  (Result shr 10);
end;

function TXRTLBaseHashtable.IndexOf(const IValue: IXRTLValue): Integer;
begin
  Result:= InternalHash(IValue) mod Cardinal(GetCapacity);
end;

function TXRTLBaseHashtable.IsEmpty: Boolean;
begin
  Result:= FCount = 0;
end;

procedure TXRTLBaseHashtable.Clear;
var
  I: Integer;
begin
  for I:= 0 to GetCapacity - 1 do
  begin
    FData[I]:= nil;
  end;
  FCount:= 0;
end;

function TXRTLBaseHashtable.GetValues: TXRTLValueArray;
var
  I: Integer;
  LValue: IXRTLValue;
  RValues: TXRTLArray;
  LValues: TXRTLSequentialContainer;
begin
  RValues:= nil;
  try
    RValues:= TXRTLArray.Create(GetCapacity);
    for I:= 0 to GetCapacity - 1 do
    begin
      LValue:= FData[I];
      if Assigned(LValue) then
      begin
        XRTLGetAsObject(LValue, LValues);
        XRTLCopy(LValues, RValues);
      end;
    end;
    Result:= RValues.GetValues;
  finally
    FreeAndNil(RValues);
  end;
end;

function TXRTLBaseHashtable.Add(const IValue: IXRTLValue): Boolean;
var
  LIndex: Integer;
  LValue: IXRTLValue;
  LEntriesContainer: TXRTLSequentialContainer;
begin
  LIndex:= IndexOf(IValue);
  LValue:= FData[LIndex];
  if not Assigned(LValue) then
  begin
    LEntriesContainer:= CreateEntriesContainer;
    LValue:= XRTLValue(LEntriesContainer, True);
    FData[LIndex]:= LValue;
  end
  else
  begin
    XRTLGetAsObject(LValue, LEntriesContainer);
  end;
  Result:= LEntriesContainer.Insert(IValue);
  if Result then
    Inc(FCount);
  if FCount > GetCapacity * FLoadFactor then
    Rehash(GetCapacity);
end;

function TXRTLBaseHashtable.Remove(const IValue: IXRTLValue): Boolean;
var
  LIndex: Integer;
  LValue: IXRTLValue;
  LEntriesContainer: TXRTLSequentialContainer;
  LIterator: IXRTLIterator;
begin
  Result:= False;
  LIndex:= IndexOf(IValue);
  LValue:= FData[LIndex];
  if Assigned(LValue) then
  begin
    XRTLGetAsObject(LValue, LEntriesContainer);
    if LEntriesContainer.Find(IValue, LIterator) then
      Result:= LEntriesContainer.Remove(LIterator);
    if LEntriesContainer.IsEmpty then
      FData[LIndex]:= nil;
  end;
  if Result then
    Dec(FCount);
end;

function TXRTLBaseHashtable.HasValue(const IValue: IXRTLValue): Boolean;
var
  LIndex: Integer;
  LValue: IXRTLValue;
  LEntriesContainer: TXRTLSequentialContainer;
begin
  Result:= False;
  LIndex:= IndexOf(IValue);
  LValue:= FData[LIndex];
  if Assigned(LValue) then
  begin
    LEntriesContainer:= XRTLGetAsObject(LValue) as TXRTLSequentialContainer;
    Result:= LEntriesContainer.HasValue(IValue);
  end;
end;

function TXRTLBaseHashtable.GetCapacity: Integer;
begin
  Result:= Length(FData);
end;

procedure TXRTLBaseHashtable.EnsureCapacity(const ACapacity: Integer);
begin
  Rehash(Max(0, ACapacity - GetCapacity));
end;

procedure TXRTLBaseHashtable.SetLoadFactor(const Value: Double);
begin
  FLoadFactor:= Max(0.01, Min(Value, 1.0));
  Rehash(0);
end;

procedure TXRTLBaseHashtable.Rehash(CapacityDelta: Integer);
var
  LValues: TXRTLValueArray;
begin
  LValues:= GetValues;
  Clear;
  SetLength(FData, Max(XRTLHashtableMinCapacity, GetCapacity + CapacityDelta));
  XRTLCopy(LValues, Self);
end;

{ TXRTLArrayHashtable }

function TXRTLArrayHashtable.CreateEntriesContainer: TXRTLSequentialContainer;
begin
  Result:= TXRTLArray.Create(True, dupIgnore);
end;

{ TXRTLLinkedListHashtable }

function TXRTLLinkedListHashtable.CreateEntriesContainer: TXRTLSequentialContainer;
begin
  Result:= TXRTLLinkedList.Create;
end;

end.
