unit xrtl_util_Set;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_Value,
  xrtl_util_Array, xrtl_util_Container;

type
  TXRTLSet = class(TXRTLSetContainer)
  private
  public
  end;

  TXRTLArraySet = class(TXRTLSet)
  private
    FValues: TXRTLArray;
    function   GetLoadFactor: Double;
    procedure  SetLoadFactor(const Value: Double);
  public
    constructor Create;
    destructor Destroy; override;
    function   IsEmpty: Boolean; override;
    procedure  Clear; override;
    function   GetValues: TXRTLValueArray; override;
    function   Add(const IValue: IXRTLValue): Boolean; override;
    function   Remove(const IValue: IXRTLValue): Boolean; overload; override;
    function   HasValue(const IValue: IXRTLValue): Boolean; override;
    function   Find(const IValue: IXRTLValue; out Iterator: IXRTLIterator): Boolean;
    function   AtBegin: IXRTLIterator;
    function   AtEnd: IXRTLIterator;
    function   GetValue(const Iterator: IXRTLIterator): IXRTLValue; overload;
    function   GetSize: Integer;
    function   GetCapacity: Integer;
    procedure  TrimToSize;
    procedure  EnsureCapacity(const ACapacity: Integer);
    property   LoadFactor: Double read GetLoadFactor write SetLoadFactor;
  end;

implementation

{ TXRTLArraySet }

constructor TXRTLArraySet.Create;
begin
  inherited Create;
  FValues:= TXRTLArray.Create;
  FValues.Sorted:= True;
  FValues.Duplicates:= dupIgnore;
end;

destructor TXRTLArraySet.Destroy;
begin
  FreeAndNil(FValues);
  inherited;
end;

function TXRTLArraySet.IsEmpty: Boolean;
begin
  Result:= FValues.IsEmpty;
end;

procedure TXRTLArraySet.Clear;
begin
  FValues.Clear;
end;

function TXRTLArraySet.GetValues: TXRTLValueArray;
begin
  Result:= FValues.GetValues;
end;

function TXRTLArraySet.Add(const IValue: IXRTLValue): Boolean;
begin
  Result:= FValues.Add(IValue);
end;

function TXRTLArraySet.Remove(const IValue: IXRTLValue): Boolean;
begin
  Result:= FValues.Remove(IValue);
end;

function TXRTLArraySet.HasValue(const IValue: IXRTLValue): Boolean;
var
  LIterator: IXRTLIterator;
begin
  Result:= Find(IValue, LIterator);
end;

function TXRTLArraySet.Find(const IValue: IXRTLValue; out Iterator: IXRTLIterator): Boolean;
begin
  Result:= FValues.Find(IValue, Iterator);
end;

function TXRTLArraySet.AtBegin: IXRTLIterator;
begin
  Result:= FValues.AtBegin;
end;

function TXRTLArraySet.AtEnd: IXRTLIterator;
begin
  Result:= FValues.AtEnd;
end;

function TXRTLArraySet.GetValue(const Iterator: IXRTLIterator): IXRTLValue;
begin
  Result:= FValues.GetValue(Iterator);
end;

function TXRTLArraySet.GetSize: Integer;
begin
  Result:= FValues.GetSize;
end;

function TXRTLArraySet.GetCapacity: Integer;
begin
  Result:= FValues.GetCapacity;
end;

procedure TXRTLArraySet.TrimToSize;
begin
  FValues.TrimToSize;
end;

function TXRTLArraySet.GetLoadFactor: Double;
begin
  Result:= FValues.LoadFactor;
end;

procedure TXRTLArraySet.SetLoadFactor(const Value: Double);
begin
  FValues.LoadFactor:= Value;
end;

procedure TXRTLArraySet.EnsureCapacity(const ACapacity: Integer);
begin
  FValues.EnsureCapacity(ACapacity);
end;

end.
