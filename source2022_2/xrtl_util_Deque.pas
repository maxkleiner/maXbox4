unit xrtl_util_Deque;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_Value,
  xrtl_util_Container, xrtl_util_Queue;

type
  TXRTLDeque = class(TXRTLQueue)
  public
    procedure  Push(const IValue: IXRTLValue); override;
    function   Pop: IXRTLValue; override;
    procedure  PushFirst(const IValue: IXRTLValue); virtual; abstract;
    function   PopFirst: IXRTLValue; virtual; abstract;
    procedure  PushLast(const IValue: IXRTLValue); virtual; abstract;
    function   PopLast: IXRTLValue; virtual; abstract;
  end;

  TXRTLSequentialValueContainerDeque = class(TXRTLDeque)
  private
  protected
    FCoreContainer: TXRTLSequentialContainer;
    constructor Create(const ACoreContainer: TXRTLSequentialContainer);
  public
    destructor Destroy; override;
    procedure  BeforeDestruction; override;
    function   IsEmpty: Boolean; override;
    procedure  Clear; override;
    function   GetValues: TXRTLValueArray; override;
    function   GetFirst: IXRTLValue; override;
    function   SetFirst(const IValue: IXRTLValue): IXRTLValue; override;
    function   GetLast: IXRTLValue; override;
    function   SetLast(const IValue: IXRTLValue): IXRTLValue; override;
    procedure  PushFirst(const IValue: IXRTLValue); override;
    function   PopFirst: IXRTLValue; override;
    procedure  PushLast(const IValue: IXRTLValue); override;
    function   PopLast: IXRTLValue; override;
  end;

  TXRTLArrayDeque = class(TXRTLSequentialValueContainerDeque)
  private
    function   GetLoadFactor: Double;
    procedure  SetLoadFactor(const Value: Double);
  public
    constructor Create;
    function   GetSize: Integer;
    function   GetCapacity: Integer;
    procedure  TrimToSize;
    procedure  EnsureCapacity(const ACapacity: Integer);
    property   LoadFactor: Double read GetLoadFactor write SetLoadFactor;
  end;

  TXRTLDoubleLinkedListDeque = class(TXRTLSequentialValueContainerDeque)
  public
    constructor Create;
  end;

implementation

uses
  xrtl_util_Array, xrtl_util_DoubleLinkedList;

{ TXRTLDeque }

procedure TXRTLDeque.Push(const IValue: IXRTLValue);
begin
  PushLast(IValue);
end;

function TXRTLDeque.Pop: IXRTLValue;
begin
  Result:= PopFirst;
end;

{ TXRTLSequentialValueContainerDeque }

constructor TXRTLSequentialValueContainerDeque.Create(const ACoreContainer: TXRTLSequentialContainer);
begin
  inherited Create;
  FCoreContainer:= ACoreContainer;
end;

destructor TXRTLSequentialValueContainerDeque.Destroy;
begin
  FreeAndNil(FCoreContainer);
  inherited;
end;

procedure TXRTLSequentialValueContainerDeque.BeforeDestruction;
begin
  FCoreContainer.Clear;
  inherited;
end;

function TXRTLSequentialValueContainerDeque.IsEmpty: Boolean;
begin
  Result:= FCoreContainer.IsEmpty;
end;

procedure TXRTLSequentialValueContainerDeque.Clear;
begin
  FCoreContainer.Clear;
end;

function TXRTLSequentialValueContainerDeque.GetValues: TXRTLValueArray;
begin
  Result:= FCoreContainer.GetValues;
end;

function TXRTLSequentialValueContainerDeque.GetFirst: IXRTLValue;
begin
  Result:= FCoreContainer.GetValue(FCoreContainer.AtBegin);
end;

function TXRTLSequentialValueContainerDeque.SetFirst(const IValue: IXRTLValue): IXRTLValue;
begin
  Result:= FCoreContainer.SetValue(IValue, FCoreContainer.AtBegin);
end;

function TXRTLSequentialValueContainerDeque.GetLast: IXRTLValue;
begin
  Result:= FCoreContainer.GetValue(FCoreContainer.AtEnd.Prev);
end;

function TXRTLSequentialValueContainerDeque.SetLast(const IValue: IXRTLValue): IXRTLValue;
begin
  Result:= FCoreContainer.SetValue(IValue, FCoreContainer.AtEnd.Prev);
end;

procedure TXRTLSequentialValueContainerDeque.PushFirst(const IValue: IXRTLValue);
begin
  FCoreContainer.Insert(IValue, FCoreContainer.AtBegin);
end;

function TXRTLSequentialValueContainerDeque.PopFirst: IXRTLValue;
begin
  Result:= FCoreContainer.GetValue(FCoreContainer.AtBegin);
  FCoreContainer.Remove(FCoreContainer.AtBegin);
end;

procedure TXRTLSequentialValueContainerDeque.PushLast(const IValue: IXRTLValue);
begin
  FCoreContainer.Insert(IValue, FCoreContainer.AtEnd);
end;

function TXRTLSequentialValueContainerDeque.PopLast: IXRTLValue;
var
  LIterator: IXRTLIterator;
begin
  LIterator:= FCoreContainer.AtBegin.Prev;
  Result:= FCoreContainer.GetValue(LIterator);
  FCoreContainer.Remove(LIterator);
end;

{ TXRTLArrayDeque }

constructor TXRTLArrayDeque.Create;
begin
  inherited Create(TXRTLArray.Create);
end;

function TXRTLArrayDeque.GetSize: Integer;
begin
  Result:= (FCoreContainer as TXRTLArray).GetSize;
end;

function TXRTLArrayDeque.GetCapacity: Integer;
begin
  Result:= (FCoreContainer as TXRTLArray).GetCapacity;
end;

procedure TXRTLArrayDeque.TrimToSize;
begin
  (FCoreContainer as TXRTLArray).TrimToSize;
end;

procedure TXRTLArrayDeque.EnsureCapacity(const ACapacity: Integer);
begin
  (FCoreContainer as TXRTLArray).EnsureCapacity(ACapacity);
end;

function TXRTLArrayDeque.GetLoadFactor: Double;
begin
  Result:= (FCoreContainer as TXRTLArray).LoadFactor;
end;

procedure TXRTLArrayDeque.SetLoadFactor(const Value: Double);
begin
  (FCoreContainer as TXRTLArray).LoadFactor:= Value;
end;

{ TXRTLDoubleLinkedListDeque }

constructor TXRTLDoubleLinkedListDeque.Create;
begin
  inherited Create(TXRTLDoubleLinkedList.Create);
end;

end.
