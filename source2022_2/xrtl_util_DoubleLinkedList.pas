unit xrtl_util_DoubleLinkedList;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_Compare, xrtl_util_Value,
  xrtl_util_Container, xrtl_util_Compat;

type
  IXRTLDoubleLinkedListNode = interface
  ['{1BDAF2C3-9EB1-48FA-8CAD-FC2F6C40C875}']
    function   GetValue: IXRTLValue;
    function   SetValue(const IValue: IXRTLValue): IXRTLValue;
    function   GetPrev: IXRTLDoubleLinkedListNode;
    procedure  SetPrev(const APrev: IXRTLDoubleLinkedListNode);
    function   GetNext: IXRTLDoubleLinkedListNode;
    procedure  SetNext(const ANext: IXRTLDoubleLinkedListNode);
  end;

  TXRTLDoubleLinkedList = class(TXRTLSequentialContainer)
  private
    FFirst: IXRTLDoubleLinkedListNode;
    FLast: IXRTLDoubleLinkedListNode;
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
  TXRTLDoubleLinkedListNode = class(TInterfacedObject, IXRTLDoubleLinkedListNode)
  private
    FValue: IXRTLValue;
    FPrev: IXRTLDoubleLinkedListNode;
    FNext: IXRTLDoubleLinkedListNode;
  public
    constructor Create(const AValue: IXRTLValue; const APrev, ANext: IXRTLDoubleLinkedListNode);
    function   GetValue: IXRTLValue;
    function   SetValue(const IValue: IXRTLValue): IXRTLValue;
    function   GetPrev: IXRTLDoubleLinkedListNode;
    procedure  SetPrev(const APrev: IXRTLDoubleLinkedListNode);
    function   GetNext: IXRTLDoubleLinkedListNode;
    procedure  SetNext(const ANext: IXRTLDoubleLinkedListNode);
  end;

  IXRTLDoubleLinkedListIterator = interface(IXRTLIterator)
  ['{62700E98-237A-4FC4-A50A-F16B9F77A5AE}']
    function   GetCurrent: IXRTLDoubleLinkedListNode;
    procedure  SetPosition(const ACurrent: IXRTLDoubleLinkedListNode);
  end;

  TXRTLDoubleLinkedListIterator = class(TInterfacedObject, IXRTLIterator, IXRTLDoubleLinkedListIterator)
  private
    FCurrent: IXRTLDoubleLinkedListNode;
  public
    constructor Create(const ACurrent: IXRTLDoubleLinkedListNode);
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
    function   Clone: IXRTLIterator;
    function   Next: IXRTLIterator;
    function   Prev: IXRTLIterator;
    function   GetCurrent: IXRTLDoubleLinkedListNode;
    procedure  SetPosition(const ACurrent: IXRTLDoubleLinkedListNode);
  end;

{ TXRTLDoubleLinkedListNode }

constructor TXRTLDoubleLinkedListNode.Create(const AValue: IXRTLValue;
  const APrev, ANext: IXRTLDoubleLinkedListNode);
begin
  inherited Create;
  FValue:= AValue;
  FPrev:= APrev;
  FNext:= ANext;
end;

function TXRTLDoubleLinkedListNode.GetValue: IXRTLValue;
begin
  Result:= FValue;
end;

function TXRTLDoubleLinkedListNode.SetValue(const IValue: IXRTLValue): IXRTLValue;
begin
  Result:= FValue;
  FValue:= IValue;
end;

function TXRTLDoubleLinkedListNode.GetPrev: IXRTLDoubleLinkedListNode;
begin
  Result:= FPrev;
end;

procedure TXRTLDoubleLinkedListNode.SetPrev(const APrev: IXRTLDoubleLinkedListNode);
begin
  FPrev:= APrev;
end;

function TXRTLDoubleLinkedListNode.GetNext: IXRTLDoubleLinkedListNode;
begin
  Result:= FNext;
end;

procedure TXRTLDoubleLinkedListNode.SetNext(const ANext: IXRTLDoubleLinkedListNode);
begin
  FNext:= ANext;
end;

{ TXRTLDoubleLinkedListIterator }

constructor TXRTLDoubleLinkedListIterator.Create(const ACurrent: IXRTLDoubleLinkedListNode);
begin
  inherited Create;
  FCurrent:= ACurrent;
end;

function TXRTLDoubleLinkedListIterator.Compare(const IValue: IInterface): TXRTLValueRelationship;
var
  LCurrent: IXRTLDoubleLinkedListNode;
begin
  LCurrent:= (IValue as IXRTLDoubleLinkedListIterator).GetCurrent;
  if FCurrent = LCurrent then
    Result:= XRTLEqualsValue
  else
    if Cardinal(FCurrent) < Cardinal(LCurrent) then
      Result:= XRTLLessThanValue
    else
      Result:= XRTLGreaterThanValue;
end;

function TXRTLDoubleLinkedListIterator.Clone: IXRTLIterator;
begin
  Result:= TXRTLDoubleLinkedListIterator.Create(FCurrent);
end;

function TXRTLDoubleLinkedListIterator.Next: IXRTLIterator;
begin
  if not Assigned(FCurrent) then
    raise EXRTLAlreadyAtEndException.Create(SXRTLAlreadyAtEndException);
  FCurrent:= FCurrent.GetNext;
  Result:= Self;
end;

function TXRTLDoubleLinkedListIterator.Prev: IXRTLIterator;
begin
  if not Assigned(FCurrent.GetPrev.GetPrev) then
    raise EXRTLAlreadyAtBeginException.Create(SXRTLAlreadyAtBeginException);
  FCurrent:= FCurrent.GetPrev;
  Result:= Self;
end;

function TXRTLDoubleLinkedListIterator.GetCurrent: IXRTLDoubleLinkedListNode;
begin
  Result:= FCurrent;
end;

procedure TXRTLDoubleLinkedListIterator.SetPosition(const ACurrent: IXRTLDoubleLinkedListNode);
begin
  FCurrent:= ACurrent;
end;

{ TXRTLDoubleLinkedList }

constructor TXRTLDoubleLinkedList.Create;
begin
  inherited Create;
  FFirst:= TXRTLDoubleLinkedListNode.Create(nil, nil, nil);
  FLast:= FFirst;
end;

destructor TXRTLDoubleLinkedList.Destroy;
begin
  Clear;
  inherited;
end;

function TXRTLDoubleLinkedList.IsEmpty: Boolean;
begin
  Result:= FFirst = FLast;
end;

procedure TXRTLDoubleLinkedList.Clear;
begin
  inherited;
end;

function TXRTLDoubleLinkedList.GetValues: TXRTLValueArray;
var
  Node: IXRTLDoubleLinkedListNode;
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

function TXRTLDoubleLinkedList.Find(const IValue: IXRTLValue; out Iterator: IXRTLIterator): Boolean;
var
  LResultIterator, LEndIterator: IXRTLDoubleLinkedListIterator;
  Node: IXRTLDoubleLinkedListNode;
begin
  Result:= False;
  LResultIterator:= AtBegin as IXRTLDoubleLinkedListIterator;
  LEndIterator:= AtEnd as IXRTLDoubleLinkedListIterator;
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

function TXRTLDoubleLinkedList.AtBegin: IXRTLIterator;
begin
  Result:= TXRTLDoubleLinkedListIterator.Create(FFirst.GetNext);
end;

function TXRTLDoubleLinkedList.AtEnd: IXRTLIterator;
begin
  Result:= TXRTLDoubleLinkedListIterator.Create(nil);
end;

function TXRTLDoubleLinkedList.GetValue(const Iterator: IXRTLIterator): IXRTLValue;
begin
  Result:= (Iterator as IXRTLDoubleLinkedListIterator).GetCurrent.GetValue;
end;

function TXRTLDoubleLinkedList.SetValue(const IValue: IXRTLValue;
  const Iterator: IXRTLIterator): IXRTLValue;
begin
  Result:= (Iterator as IXRTLDoubleLinkedListIterator).GetCurrent.SetValue(IValue);
end;

function TXRTLDoubleLinkedList.Insert(const IValue: IXRTLValue;
  const Iterator: IXRTLIterator): Boolean;
var
  Node, PNode, NNode: IXRTLDoubleLinkedListNode;
  LIterator: IXRTLDoubleLinkedListIterator;
begin
  LIterator:= Iterator as IXRTLDoubleLinkedListIterator;
  NNode:= LIterator.GetCurrent;
  if Assigned(NNode) then
  begin
    PNode:= NNode.GetPrev;
  end
  else
  begin
    PNode:= FLast;
  end;
  Node:= TXRTLDoubleLinkedListNode.Create(IValue, PNode, NNode);
  PNode.SetNext(Node);
  if Assigned(NNode) then
    NNode.SetPrev(Node)
  else
    FLast:= Node;
  LIterator.SetPosition(NNode);
  Result:= True;
end;

function TXRTLDoubleLinkedList.Remove(const FromIterator: IXRTLIterator;
  const ToIterator: IXRTLIterator = nil): Boolean;
var
  LFromIterator, LToIterator: IXRTLDoubleLinkedListIterator;
  Node: IXRTLDoubleLinkedListNode;
begin
  Result:= False;
  LFromIterator:= FromIterator as IXRTLDoubleLinkedListIterator;
  if Assigned(ToIterator) then
    LToIterator:= ToIterator as IXRTLDoubleLinkedListIterator
  else
    LToIterator:= TXRTLDoubleLinkedListIterator.Create(LFromIterator.GetCurrent.GetNext);
  LFromIterator.GetCurrent.SetNext(LToIterator.GetCurrent);
  if Assigned(LToIterator.GetCurrent) then
    LToIterator.GetCurrent.SetPrev(LFromIterator.GetCurrent.GetPrev)
  else
    FLast:= LFromIterator.GetCurrent.GetPrev;
  while LFromIterator.Compare(LToIterator) <> XRTLEqualsValue do
  begin
    Node:= LFromIterator.GetCurrent;
    LFromIterator.Next;
    Node.SetNext(nil);
    Node.SetPrev(nil);
  end;
end;

end.
