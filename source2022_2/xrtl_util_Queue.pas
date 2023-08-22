unit xrtl_util_Queue;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_Value,
  xrtl_util_Container, xrtl_util_Array;

type
  EXRTLQueueException = class(EXRTLContainerException);
  EXRTLQueueEmpty     = class(EXRTLQueueException);

  TXRTLBaseQueue = class(TXRTLValueContainer)
  public
    procedure  Push(const IValue: IXRTLValue); virtual; abstract;
    function   Pop: IXRTLValue; virtual; abstract;
  end;

  TXRTLQueue = class(TXRTLBaseQueue)
  public
    function   GetFirst: IXRTLValue; virtual; abstract;
    function   SetFirst(const IValue: IXRTLValue): IXRTLValue; virtual; abstract;
    function   GetLast: IXRTLValue; virtual; abstract;
    function   SetLast(const IValue: IXRTLValue): IXRTLValue; virtual; abstract;
  end;

  TXRTLArrayQueue = class(TXRTLQueue)
  private
    FValues: TXRTLArray;
    FPushHead: Integer;
    FPopHead: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function   IsEmpty: Boolean; override;
    procedure  Clear; override;
    function   GetValues: TXRTLValueArray; override;
    procedure  Push(const IValue: IXRTLValue); override;
    function   Pop: IXRTLValue; override;
    function   GetFirst: IXRTLValue; override;
    function   SetFirst(const IValue: IXRTLValue): IXRTLValue; override;
    function   GetLast: IXRTLValue; override;
    function   SetLast(const IValue: IXRTLValue): IXRTLValue; override;
    function   GetSize: Integer;
    function   GetCapacity: Integer;
    procedure  TrimToSize;
    procedure  EnsureCapacity(const ACapacity: Integer);
  end;

implementation

uses
  Math,
  xrtl_util_ResourceStrings;

{ TXRTLArrayQueue }

constructor TXRTLArrayQueue.Create;
begin
  inherited Create;
  FValues:= TXRTLArray.Create;
  FPushHead:= 0;
  FPopHead:= 0;
end;

destructor TXRTLArrayQueue.Destroy;
begin
  Clear;
  FreeAndNil(FValues);
  inherited;
end;

function TXRTLArrayQueue.IsEmpty: Boolean;
begin
  Result:= FPopHead = FPushHead;
end;

procedure TXRTLArrayQueue.Clear;
begin
  FValues.Clear;
  FPushHead:= 0;
  FPopHead:= 0;
end;

function TXRTLArrayQueue.GetValues: TXRTLValueArray;
var
  I, Index: Integer;
begin
  SetLength(Result, GetSize);
  if IsEmpty then Exit;
  Index:= 0;
  if FPushHead > FPopHead then
  begin
    for I:= FPopHead to FPushHead - 1 do
    begin
      Result[Index]:= FValues.GetValue(I);
      Inc(Index);
    end;
  end
  else
  begin
    for I:= FPopHead to FValues.GetSize - 1 do
    begin
      Result[Index]:= FValues.GetValue(I);
      Inc(Index);
    end;
    for I:= 0 to FPushHead - 1 do
    begin
      Result[Index]:= FValues.GetValue(I);
      Inc(Index);
    end;
  end;
end;

procedure TXRTLArrayQueue.Push(const IValue: IXRTLValue);
begin
  if (FPushHead + 1) mod FValues.GetCapacity = FPopHead then
  begin
    EnsureCapacity(GetSize + 1);
    FValues.Add(IValue);
    FPushHead:= (FPushHead + 1) mod GetCapacity;
  end
  else
  begin
    FValues.SetValue(IValue, FPushHead);
    FPushHead:= (FPushHead + 1) mod GetCapacity;
  end;
end;

function TXRTLArrayQueue.Pop: IXRTLValue;
const
  NilValue: IXRTLValue = nil;
begin
  if IsEmpty then
    raise EXRTLQueueEmpty.CreateFmt(SXRTLQueueEmpty, ['Pop']);
  Result:= FValues.SetValue(NilValue, FPopHead);
  FPopHead:= (FPopHead + 1) mod GetCapacity;
end;

function TXRTLArrayQueue.GetFirst: IXRTLValue;
begin
  if IsEmpty then
    raise EXRTLQueueEmpty.CreateFmt(SXRTLQueueEmpty, ['GetFirst']);
  Result:= FValues.GetValue(FPopHead);
end;

function TXRTLArrayQueue.SetFirst(const IValue: IXRTLValue): IXRTLValue;
begin
  if IsEmpty then
    raise EXRTLQueueEmpty.CreateFmt(SXRTLQueueEmpty, ['SetFirst']);
  Result:= FValues.SetValue(IValue, FPopHead);
end;

function TXRTLArrayQueue.GetLast: IXRTLValue;
begin
  if IsEmpty then
    raise EXRTLQueueEmpty.CreateFmt(SXRTLQueueEmpty, ['GetLast']);
  if FPushHead > 0 then
    Result:= FValues.GetValue(FPushHead - 1)
  else
    Result:= FValues.GetValue(GetCapacity - 1);
end;

function TXRTLArrayQueue.SetLast(const IValue: IXRTLValue): IXRTLValue;
begin
  if IsEmpty then
    raise EXRTLQueueEmpty.CreateFmt(SXRTLQueueEmpty, ['SetLast']);
  if FPushHead > 0 then
    Result:= FValues.SetValue(IValue, FPushHead - 1)
  else
    Result:= FValues.SetValue(IValue, GetCapacity - 1);
end;

function TXRTLArrayQueue.GetSize: Integer;
begin
  if FPushHead >= FPopHead then
    Result:= FPushHead - FPopHead
  else
    Result:= FValues.GetSize + FPushHead - FPopHead;
end;

function TXRTLArrayQueue.GetCapacity: Integer;
begin
  Result:= FValues.GetCapacity;
end;

procedure TXRTLArrayQueue.TrimToSize;
begin
  FValues.TrimToSize;
end;

procedure TXRTLArrayQueue.EnsureCapacity(const ACapacity: Integer);
var
  Values: TXRTLValueArray;
  LCapacity, Index, Size: Cardinal;
begin
  Size:= GetSize;
  LCapacity:= Max(ACapacity, Size);
  if FPushHead >= FPopHead then
  begin
    FValues.EnsureCapacity(LCapacity);
  end
  else
  begin
    Values:= GetValues;
    FValues.Clear;
    FValues.EnsureCapacity(LCapacity);
    for Index:= 0 to Length(Values) - 1 do
    begin
      FValues.Add(Values[Index]);
      Values[Index]:= nil;
    end;
    SetLength(Values, 0);
    FPopHead:= 0;
    FPushHead:= FValues.GetSize;
  end;
end;

end.
