unit xrtl_util_Container;

{$INCLUDE xrtl.inc}

interface

uses
  xrtl_util_Exception, xrtl_util_Value, xrtl_util_Compare;

type
  EXRTLContainerException               = class(EXRTLException);
  EXRTLInvalidPosition                  = class(EXRTLContainerException);
  EXRTLSequentialValueContainerPosition = class(EXRTLContainerException);
  EXRTLForwardOnlyIteratorException     = class(EXRTLSequentialValueContainerPosition);
  EXRTLAlreadyAtBeginException          = class(EXRTLSequentialValueContainerPosition);
  EXRTLAlreadyAtEndException            = class(EXRTLSequentialValueContainerPosition);

  TXRTLContainerDuplicates = (dupAllow, dupIgnore, dupError);

  IXRTLIterator = interface(IXRTLComparable)
  ['{47647238-3E51-4994-8517-91AA0C310D78}']
    function   Clone: IXRTLIterator;
    function   Next: IXRTLIterator;
    function   Prev: IXRTLIterator;
  end;

  TXRTLBaseContainer = class
  public
    function   IsEmpty: Boolean; virtual; abstract;
    procedure  Clear; virtual; abstract;
  end;

  TXRTLValueContainer = class(TXRTLBaseContainer)
    function   GetValues: TXRTLValueArray; virtual; abstract;
  end;

  TXRTLSequentialContainer = class(TXRTLValueContainer)
  public
    function   Find(const IValue: IXRTLValue; out Iterator: IXRTLIterator): Boolean; virtual; abstract;
    function   AtBegin: IXRTLIterator; virtual; abstract;
    function   AtEnd: IXRTLIterator; virtual; abstract;
    function   GetValue(const Iterator: IXRTLIterator): IXRTLValue; overload; virtual; abstract;
    function   SetValue(const IValue: IXRTLValue; const Iterator: IXRTLIterator): IXRTLValue; overload; virtual; abstract;
    function   HasValue(const IValue: IXRTLValue): Boolean; virtual;
    function   Insert(const IValue: IXRTLValue; const Iterator: IXRTLIterator = nil): Boolean; overload; virtual; abstract;
    function   Remove(const FromIterator: IXRTLIterator; const ToIterator: IXRTLIterator = nil): Boolean; overload; virtual; abstract;
    procedure  Clear; override;
  end;

  TXRTLSetContainer = class(TXRTLValueContainer)
  public
    function   Add(const IValue: IXRTLValue): Boolean; overload; virtual; abstract;
    function   Remove(const IValue: IXRTLValue): Boolean; overload; virtual; abstract;
    function   HasValue(const IValue: IXRTLValue): Boolean; virtual; abstract;
  end;

  TXRTLKeyValueContainer = class(TXRTLBaseContainer)
  public
    function   GetKeys: TXRTLValueArray; virtual; abstract;
    function   GetValues: TXRTLValueArray; virtual; abstract;
    function   GetValue(const IKey: IXRTLValue): IXRTLValue; overload; virtual; abstract;
    function   SetValue(const IKey, IValue: IXRTLValue): IXRTLValue; overload; virtual; abstract;
    function   HasKey(const IKey: IXRTLValue): Boolean; virtual; abstract;
    function   Remove(const IKey: IXRTLValue): IXRTLValue; overload; virtual; abstract;
  end;

  TXRTLKeyValuePair = class(TXRTLValue)
  private
    FKey: IXRTLValue;
    FValue: IXRTLValue;
  public
    constructor Create(const AKey: IXRTLValue; const AValue: IXRTLValue = nil);
    function   Compare(const IValue: TObject): TXRTLValueRelationship; override;
    function   GetHashCode: Cardinal; override;
    property   Key: IXRTLValue read FKey;
    property   Value: IXRTLValue read FValue write FValue;
  end;

implementation

{ TXRTLSequentialContainer }

procedure TXRTLSequentialContainer.Clear;
begin
  Remove(AtBegin, AtEnd);
end;

function TXRTLSequentialContainer.HasValue(const IValue: IXRTLValue): Boolean;
var
  Iterator: IXRTLIterator;
begin
  Result:= Find(IValue, Iterator);
end;

{ TXRTLKeyValuePair }

constructor TXRTLKeyValuePair.Create(const AKey: IXRTLValue; const AValue: IXRTLValue = nil);
begin
  inherited Create;
  FKey:= AKey;
  FValue:= AValue;
end;

function TXRTLKeyValuePair.Compare(const IValue: TObject): TXRTLValueRelationship;
begin
  Result:= Key.Compare((IValue as TXRTLKeyValuePair).Key);
end;

function TXRTLKeyValuePair.GetHashCode: Cardinal;
begin
  Result:= Key.GetHashCode;
end;

end.
