unit xrtl_util_LinkedList;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_Compare, xrtl_util_Value,
  xrtl_util_Container, xrtl_util_Compat;

type
  IXRTLLinkedListNode = interface
  ['{8013511C-E0B5-419C-973C-91044A676BE9}']
    function   GetValue: IXRTLValue;
    function   SetValue(const IValue: IXRTLValue): IXRTLValue;
    function   GetNext: IXRTLLinkedListNode;
    procedure  SetNext(const ANext: IXRTLLinkedListNode);
  end;

  TXRTLLinkedList = class(TXRTLSequentialContainer)
  private
    FFirst: IXRTLLinkedListNode;
    FLast: IXRTLLinkedListNode;
  public
    constructor Create;
    destructor Destroy; override;
    function   IsEmpty: Boolean; override;
    procedure  Clear; override;
    function   GetValues: TXRTLValueArray; override;
    function   Find(const IValue: IXRTLValue; out Iterator: IXRTLIterator): Boolean; override;
    function   AtBegin: IXRTLIterator; override;
    function   AtEnd: IXRTLIterator; override;
    function   GetValue(const Iterator: IXRTLIterator): IXRTLValue; overload; override;
    function   SetValue(const IValue: IXRTLValue; const Iterator: IXRTLIterator): IXRTLValue; overload; override;
    function   Insert(const IValue: IXRTLValue; const Iterator: IXRTLIterator = nil): Boolean; overload; override;
    function   Remove(const FromIterator: IXRTLIterator; const ToIterator: IXRTLIterator = nil): Boolean; overload; override;
  end;

implementation

uses
  xrtl_util_Type,
  xrtl_util_ResourceStrings, xrtl_util_Array;

type
  TXRTLLinkedListNode = class(TInterfacedObject, IXRTLLinkedListNode)
  private
    FValue: IXRTLValue;
    FNext: IXRTLLinkedListNode;
  public
    constructor Create(const AValue: IXRTLValue = nil; const ANext: IXRTLLinkedListNode = nil);
    function   GetValue: IXRTLValue;
    function   SetValue(const IValue: IXRTLValue): IXRTLValue;
    function   GetNext: IXRTLLinkedListNode;
    procedure  SetNext(const ANext: IXRTLLinkedListNode);
  end;

  IXRTLLinkedListIterator = interface(IXRTLIterator)
  ['{BEA83284-0946-477D-ACA1-890FF103CE7E}']
    function   GetPrevious: IXRTLLinkedListNode;
    function   GetCurrent: IXRTLLinkedListNode;
    procedure  SetPosition(const APrevious, ACurrent: IXRTLLinkedListNode);
  end;

  TXRTLLinkedListIterator = class(TInterfacedObject, IXRTLIterator, IXRTLLinkedListIterator)
  private
    FPrevious: IXRTLLinkedListNode;
    FCurrent: IXRTLLinkedListNode;
  public
    constructor Create(const APrevious, ACurrent: IXRTLLinkedListNode);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   Clone: IXRTLIterator;
    function   Next: IXRTLIterator;
    function   Prev: IXRTLIterator;
    function   GetPrevious: IXRTLLinkedListNode;
    function   GetCurrent: IXRTLLinkedListNode;
    procedure  SetPosition(const APrevious, ACurrent: IXRTLLinkedListNode);
  end;

{ TXRTLLinkedListNode }

constructor TXRTLLinkedListNode.Create(const AValue: IXRTLValue = nil;
  const ANext: IXRTLLinkedListNode = nil);
begin
  inherited Create;
  FValue:= AValue;
  FNext:= ANext;
end;

function TXRTLLinkedListNode.GetValue: IXRTLValue;
begin
  Result:= FValue;
end;

function TXRTLLinkedListNode.SetValue(const IValue: IXRTLValue): IXRTLValue;
begin
  Result:= FValue;
  FValue:= IValue;
end;

function TXRTLLinkedListNode.GetNext: IXRTLLinkedListNode;
begin
  Result:= FNext;
end;

procedure TXRTLLinkedListNode.SetNext(const ANext: IXRTLLinkedListNode);
begin
  FNext:= ANext;
end;

{ TXRTLLinkedListIterator }

constructor TXRTLLinkedListIterator.Create(const APrevious, ACurrent: IXRTLLinkedListNode);
begin
  inherited Create;
  FPrevious:= APrevious;
  FCurrent:= ACurrent;
end;

function TXRTLLinkedListIterator.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LCurrent: IXRTLLinkedListNode;
begin
  LCurrent:= (IValue as IXRTLLinkedListIterator).GetCurrent;
  if FCurrent = LCurrent then
    Result:= XRTLEqualsValue
  else
    if Cardinal(FCurrent) < Cardinal(LCurrent) then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
end;

function TXRTLLinkedListIterator.Clone: IXRTLIterator;
begin
  Result:= TXRTLLinkedListIterator.Create(FPrevious, FCurrent);
end;

function TXRTLLinkedListIterator.Next: IXRTLIterator;
begin
  FPrevious:= FCurrent;
  FCurrent:= FCurrent.GetNext;
  Result:= Self;
end;

function TXRTLLinkedListIterator.Prev: IXRTLIterator;
begin
  raise EXRTLForwardOnlyIteratorException.Create(SXRTLForwardOnlyIteratorException);
end;

function TXRTLLinkedListIterator.GetPrevious: IXRTLLinkedListNode;
begin
  Result:= FPrevious;
end;

function TXRTLLinkedListIterator.GetCurrent: IXRTLLinkedListNode;
begin
  Result:= FCurrent;
end;

procedure TXRTLLinkedListIterator.SetPosition(const APrevious, ACurrent: IXRTLLinkedListNode);
begin
  FPrevious:= APrevious;
  FCurrent:= ACurrent;
end;

{ TXRTLLinkedList }

constructor TXRTLLinkedList.Create;
begin
  inherited Create;
  FFirst:= TXRTLLinkedListNode.Create(nil, nil);
  FLast:= FFirst;
end;

destructor TXRTLLinkedList.Destroy;
begin
  Clear;
  inherited;
end;

function TXRTLLinkedList.IsEmpty: Boolean;
begin
  Result:= FFirst = FLast;
end;

procedure TXRTLLinkedList.Clear;
begin
  inherited;
end;

function TXRTLLinkedList.GetValues: TXRTLValueArray;
var
  Node: IXRTLLinkedListNode;
  LValues: TXRTLArray;
begin
  SetLength(Result, 0);
  LValues:= nil;
  try
    LValues:= TXRTLArray.Create;
    Node:= FFirst.GetNext;
    while Assigned(Node) do
    begin
      LValues.Add(Node.GetValue);
      Node:= Node.GetNext;
    end;
    Result:= LValues.GetValues;
  finally
    FreeAndNil(LValues);
  end;
end;

function TXRTLLinkedList.Find(const IValue: IXRTLValue; out Iterator: IXRTLIterator): Boolean;
var
  LResultIterator, LEndIterator: IXRTLLinkedListIterator;
  Node: IXRTLLinkedListNode;
begin
  Result:= False;
  LResultIterator:= AtBegin as IXRTLLinkedListIterator;
  LEndIterator:= AtEnd as IXRTLLinkedListIterator;
  while LResultIterator.Compare(LEndIterator) = XRTLLessThanValue do
  begin
    Node:= LResultIterator.GetCurrent;
    Result:= Node.GetValue.Compare(IValue) = XRTLEqualsValue;
    if Result then
      Break;
    LResultIterator.Next;
  end;
  Iterator:= LResultIterator;
end;

function TXRTLLinkedList.AtBegin: IXRTLIterator;
begin
  Result:= TXRTLLinkedListIterator.Create(FFirst, FFirst.GetNext);
end;

function TXRTLLinkedList.AtEnd: IXRTLIterator;
begin
  Result:= TXRTLLinkedListIterator.Create(FLast, nil);
end;

function TXRTLLinkedList.GetValue(const Iterator: IXRTLIterator): IXRTLValue;
begin
  Result:= (Iterator as IXRTLLinkedListIterator).GetCurrent.GetValue;
end;

function TXRTLLinkedList.SetValue(const IValue: IXRTLValue;
  const Iterator: IXRTLIterator): IXRTLValue;
begin
  Result:= (Iterator as IXRTLLinkedListIterator).GetCurrent.SetValue(IValue);
end;

function TXRTLLinkedList.Insert(const IValue: IXRTLValue;
  const Iterator: IXRTLIterator): Boolean;
var
  Node: IXRTLLinkedListNode;
  LIterator: IXRTLLinkedListIterator;
begin
  LIterator:= Iterator as IXRTLLinkedListIterator;
  Node:= TXRTLLinkedListNode.Create(IValue, LIterator.GetCurrent);
  LIterator.GetPrevious.SetNext(Node);
  if not Assigned(LIterator.GetCurrent) then
    FLast:= Node;
  LIterator.SetPosition(Node, Node.GetNext);
  Result:= True;
end;

function TXRTLLinkedList.Remove(const FromIterator: IXRTLIterator;
  const ToIterator: IXRTLIterator = nil): Boolean;
var
  LFromIterator, LToIterator: IXRTLLinkedListIterator;
  Node: IXRTLLinkedListNode;
begin
  Result:= False;
  LFromIterator:= FromIterator as IXRTLLinkedListIterator;
  if Assigned(ToIterator) then
    LToIterator:= ToIterator as IXRTLLinkedListIterator
  else
    LToIterator:= TXRTLLinkedListIterator.Create(LFromIterator.GetCurrent, LFromIterator.GetCurrent.GetNext);
  if not Assigned(LToIterator.GetCurrent) then
    FLast:= LFromIterator.GetPrevious;
  LFromIterator.GetPrevious.SetNext(LToIterator.GetCurrent);
  while LFromIterator.Compare(LToIterator) <> XRTLEqualsValue do
  begin
    Node:= LFromIterator.GetCurrent;
    LFromIterator.Next;
    Node.SetNext(nil);
  end;
end;

end.
