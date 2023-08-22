unit xrtl_util_Stack;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_Value,
  xrtl_util_Container, xrtl_util_Array;

type
  TXRTLStack = class(TXRTLValueContainer)
  public
    procedure  Push(const IValue: IXRTLValue); virtual; abstract;
    function   Pop: IXRTLValue; virtual; abstract;
    function   GetTop: IXRTLValue; virtual; abstract;
    function   SetTop(const IValue: IXRTLValue): IXRTLValue; virtual; abstract;
  end;

  TXRTLArrayStack = class(TXRTLStack)
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
    procedure  Push(const IValue: IXRTLValue); override;
    function   Pop: IXRTLValue; override;
    function   GetTop: IXRTLValue; override;
    function   SetTop(const IValue: IXRTLValue): IXRTLValue; override;
    function   GetSize: Integer;
    function   GetCapacity: Integer;
    procedure  TrimToSize;
    procedure  EnsureCapacity(const ACapacity: Integer);
    property   LoadFactor: Double read GetLoadFactor write SetLoadFactor;
  end;

implementation

{ TXRTLArrayStack }

constructor TXRTLArrayStack.Create;
begin
  inherited Create;
  FValues:= TXRTLArray.Create;
end;

destructor TXRTLArrayStack.Destroy;
begin
  FreeAndNil(FValues);
  inherited;
end;

function TXRTLArrayStack.IsEmpty: Boolean;
begin
  Result:= FValues.IsEmpty;
end;

procedure TXRTLArrayStack.Clear;
begin
  FValues.Clear;
end;

function TXRTLArrayStack.GetValues: TXRTLValueArray;
begin
  Result:= FValues.GetValues;
end;

procedure TXRTLArrayStack.Push(const IValue: IXRTLValue);
begin
  FValues.Add(IValue);
end;

function TXRTLArrayStack.Pop: IXRTLValue;
begin
  Result:= FValues.GetValue(FValues.GetSize - 1);
  FValues.Remove(FValues.GetSize - 1);
end;

function TXRTLArrayStack.GetTop: IXRTLValue;
begin
  Result:= FValues.GetValue(FValues.GetSize - 1);
end;

function TXRTLArrayStack.SetTop(const IValue: IXRTLValue): IXRTLValue;
begin
  Result:= FValues.SetValue(IValue, FValues.GetSize - 1);
end;

function TXRTLArrayStack.GetSize: Integer;
begin
  Result:= FValues.GetSize;
end;

function TXRTLArrayStack.GetCapacity: Integer;
begin
  Result:= FValues.GetCapacity;
end;

procedure TXRTLArrayStack.TrimToSize;
begin
  FValues.TrimToSize;
end;

procedure TXRTLArrayStack.EnsureCapacity(const ACapacity: Integer);
begin
  FValues.EnsureCapacity(ACapacity);
end;

function TXRTLArrayStack.GetLoadFactor: Double;
begin
  Result:= FValues.LoadFactor;
end;

procedure TXRTLArrayStack.SetLoadFactor(const Value: Double);
begin
  FValues.LoadFactor:= Value;
end;

end.
