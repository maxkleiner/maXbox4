unit xrtl_util_MemoryManager;

{$INCLUDE xrtl.inc}

interface

type
  TXRTLGetMemoryOption  = (gmoZeroMemory);
  TXRTLGetMemoryOptions = set of TXRTLGetMemoryOption;

  IXRTLMemoryManager = interface
    function   GetMemory(ASize: Cardinal; AOptions: TXRTLGetMemoryOptions = []): Pointer;
    procedure  FreeMemory(var APointer: Pointer);
  end;

  TXRTLCustomMemoryManager = class(TInterfacedObject, IXRTLMemoryManager)
  protected
    function   engineGetMemory(ASize: Cardinal): Pointer; virtual; abstract;
    procedure  engineFreeMemory(var APointer: Pointer); virtual; abstract;
  public
    function   GetMemory(ASize: Cardinal; AOptions: TXRTLGetMemoryOptions = []): Pointer;
    procedure  FreeMemory(var APointer: Pointer);
  end;

  TXRTLDelphiMemoryManager = class(TXRTLCustomMemoryManager)
  protected
    function   engineGetMemory(ASize: Cardinal): Pointer; override;
    procedure  engineFreeMemory(var APointer: Pointer); override;
  public
  end;

  TXRTLCOMMemoryManager = class(TXRTLCustomMemoryManager)
  protected
    function   engineGetMemory(ASize: Cardinal): Pointer; override;
    procedure  engineFreeMemory(var APointer: Pointer); override;
  public
  end;

var
  XRTLDefaultMemoryManager: IXRTLMemoryManager = nil;

implementation

uses
  Windows, SysUtils, ActiveX;

{ TXRTLCustomMemoryManager }

function TXRTLCustomMemoryManager.GetMemory(ASize: Cardinal; AOptions: TXRTLGetMemoryOptions = []): Pointer;
begin
  Result:= engineGetMemory(ASize);
  if Assigned(Result) then
  begin
    if gmoZeroMemory in AOptions then
      ZeroMemory(Result, ASize);
  end
  else
  begin
    if ASize > 0 then
      OutOfMemoryError;
  end;
end;

procedure TXRTLCustomMemoryManager.FreeMemory(var APointer: Pointer);
begin
  engineFreeMemory(APointer);
  APointer:= nil;
end;

{ TXRTLDelphiMemoryManager }

function TXRTLDelphiMemoryManager.engineGetMemory(ASize: Cardinal): Pointer;
begin
  GetMem(Result, ASize);
end;

procedure TXRTLDelphiMemoryManager.engineFreeMemory(var APointer: Pointer);
begin
  FreeMem(APointer);
end;

{ TXRTLCOMMemoryManager }

function TXRTLCOMMemoryManager.engineGetMemory(ASize: Cardinal): Pointer;
begin
  Result:= CoTaskMemAlloc(ASize);
end;

procedure TXRTLCOMMemoryManager.engineFreeMemory(var APointer: Pointer);
begin
  CoTaskMemFree(APointer);
end;

initialization
begin
  XRTLDefaultMemoryManager:= TXRTLDelphiMemoryManager.Create;
end;

end.
