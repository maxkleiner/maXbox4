unit xrtl_util_Guard;

{$INCLUDE xrtl.inc}

interface

uses
  xrtl_util_MemoryManager, xrtl_util_MemoryUtils;

type
  IXRTLGuard = interface
    function   GetItem: Pointer;
    function   ReleaseItem: Pointer;
    procedure  FreeItem;
    property   Item: Pointer read GetItem;
  end;

function XRTLGuardObject(AObject: TObject; out AGuard: IXRTLGuard): TObject; overload;
function XRTLGuardObject(AObject: TObject; out Obj): IXRTLGuard; overload;
function XRTLGuardGetMemory(ASize: Cardinal; out AGuard: IXRTLGuard;
                            AOptions: TXRTLGetMemoryOptions = [];
                            const AMemoryManager: IXRTLMemoryManager = nil): Pointer;

implementation

type
  TXRTLGuardObject = class(TInterfacedObject, IXRTLGuard)
  private
    FItem: Pointer;
  public
    constructor Create(AObject: TObject);
    destructor Destroy; override;
    function   GetItem: Pointer;
    function   ReleaseItem: Pointer;
    procedure  FreeItem;
  end;

{ TXRTLGuardObject }

constructor TXRTLGuardObject.Create(AObject: TObject);
begin
  inherited Create;
  FItem:= AObject;
end;

destructor TXRTLGuardObject.Destroy;
begin
  FreeItem;
  inherited;
end;

procedure TXRTLGuardObject.FreeItem;
begin
  if Assigned(FItem) then
    TObject(FItem).Free;
  FItem:= nil;
end;

function TXRTLGuardObject.GetItem: Pointer;
begin
  Result:= FItem;
end;

function TXRTLGuardObject.ReleaseItem: Pointer;
begin
  Result:= FItem;
  FItem:= nil;
end;

type
  TXRTLGuardGetMemory = class(TInterfacedObject, IXRTLGuard)
  private
    FItem: Pointer;
    FMemoryManager: IXRTLMemoryManager;
  public
    constructor Create(APointer: Pointer; AMemoryManager: IXRTLMemoryManager);
    destructor Destroy; override;
    function   GetItem: Pointer;
    function   ReleaseItem: Pointer;
    procedure  FreeItem;
  end;

{ TXRTLGuardGetMemory }

constructor TXRTLGuardGetMemory.Create(APointer: Pointer; AMemoryManager: IXRTLMemoryManager);
begin
  inherited Create;
  FItem:= APointer;
  FMemoryManager:= AMemoryManager;
end;

destructor TXRTLGuardGetMemory.Destroy;
begin
  FreeItem;
  inherited;
end;

procedure TXRTLGuardGetMemory.FreeItem;
begin
  FMemoryManager.FreeMemory(FItem);
  FItem:= nil;
end;

function TXRTLGuardGetMemory.GetItem: Pointer;
begin
  Result:= FItem;
end;

function TXRTLGuardGetMemory.ReleaseItem: Pointer;
begin
  Result:= FItem;
  FItem:= nil;
end;

function XRTLGuardObject(AObject: TObject; out AGuard: IXRTLGuard): TObject;
begin
  AGuard:= TXRTLGuardObject.Create(AObject);
  Result:= AObject;
end;

function XRTLGuardObject(AObject: TObject; out Obj): IXRTLGuard;
begin
  Result:= TXRTLGuardObject.Create(AObject);
  TObject(Obj):= AObject;
end;

function XRTLGuardGetMemory(ASize: Cardinal; out AGuard: IXRTLGuard;
  AOptions: TXRTLGetMemoryOptions = []; const AMemoryManager: IXRTLMemoryManager = nil): Pointer;
var
  LMemoryManager: IXRTLMemoryManager;
begin
  LMemoryManager:= AMemoryManager;
  if not Assigned(LMemoryManager) then
    LMemoryManager:= XRTLDefaultMemoryManager;
  Result:= XRTLGetMemory(ASize, AOptions, LMemoryManager);
  AGuard:= TXRTLGuardGetMemory.Create(Result, LMemoryManager);
end;

end.
