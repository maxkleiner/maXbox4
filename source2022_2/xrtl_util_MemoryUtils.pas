unit xrtl_util_MemoryUtils;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_MemoryManager;

function  XRTLGetMemory(ASize: Cardinal; AOptions: TXRTLGetMemoryOptions = [];
                        AMemoryManager: IXRTLMemoryManager = nil): Pointer; overload;
function  XRTLGetMemory(var APointer: Pointer; ASize: Cardinal;
                        AOptions: TXRTLGetMemoryOptions = [];
                        AMemoryManager: IXRTLMemoryManager = nil): Pointer; overload;
procedure XRTLFreeMemory(var APointer: Pointer; AMemoryManager: IXRTLMemoryManager = nil);
procedure XRTLMoveMemory(const Src, Dst: Pointer; const Count: Integer); overload;
procedure XRTLMoveMemory(const Src: Pointer; SrcOffset: Integer;
                         const Dst: Pointer; DstOffset: Integer;
                         const Count: Integer); overload;

implementation

uses
  xrtl_util_CPUUtils;

function  XRTLGetMemory(ASize: Cardinal; AOptions: TXRTLGetMemoryOptions = [];
  AMemoryManager: IXRTLMemoryManager = nil): Pointer; overload;
begin
  if not Assigned(AMemoryManager) then
    AMemoryManager:= XRTLDefaultMemoryManager;
  Result:= AMemoryManager.GetMemory(ASize, AOptions);
  if not Assigned(Result) and (ASize > 0) then
    OutOfMemoryError;
end;

function  XRTLGetMemory(var APointer: Pointer; ASize: Cardinal;
  AOptions: TXRTLGetMemoryOptions = []; AMemoryManager: IXRTLMemoryManager = nil): Pointer; overload;
begin
  if not Assigned(AMemoryManager) then
    AMemoryManager:= XRTLDefaultMemoryManager;
  if Assigned(APointer) then
    AMemoryManager.FreeMemory(APointer);
  APointer:= AMemoryManager.GetMemory(ASize, AOptions);
  Result:= APointer;
  if not Assigned(Result) and (ASize > 0) then
    OutOfMemoryError;
end;

procedure XRTLFreeMemory(var APointer: Pointer; AMemoryManager: IXRTLMemoryManager = nil);
begin
  if not Assigned(APointer) then
    Exit;
  if not Assigned(AMemoryManager) then
    AMemoryManager:= XRTLDefaultMemoryManager;
  AMemoryManager.FreeMemory(APointer);
  APointer:= nil;
end;

procedure XRTLMoveMemory(const Src, Dst: Pointer; const Count: Integer);
begin
  Move(Src^, Dst^, Count);
end;

procedure XRTLMoveMemory(const Src: Pointer; SrcOffset: Integer;
                         const Dst: Pointer; DstOffset: Integer;
                         const Count: Integer);
var
  LSrc, LDst: Pointer;
begin
  LSrc:= XRTLPointerAdd(Src, SrcOffset);
  LDst:= XRTLPointerAdd(Dst, DstOffset);
  XRTLMoveMemory(LSrc, LDst, Count);
end;

end.
