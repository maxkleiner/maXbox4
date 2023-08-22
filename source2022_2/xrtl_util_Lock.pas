unit xrtl_util_Lock;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_Type, xrtl_util_Compat;

type
  IXRTLExclusiveLock = interface
  ['{428F369F-686B-430B-9289-164E74B6CD3B}']
    procedure  Acquire;
    function   TryAcquire: Boolean;
    procedure  Release;
  end;

  IXRTLReadWriteLock = interface
  ['{428F36A0-686B-430B-9289-164E74B6CD3B}']
    procedure  BeginRead;
    procedure  EndRead;
//Returns: True   if protected memory has not be written to by another thread
//         False  if another thread may have modified protected memory.
    function   BeginWrite: Boolean;
    procedure  EndWrite;
  end;

function  XRTLCreateExclusiveLock: IXRTLExclusiveLock;
function  XRTLCreateNullExclusiveLock: IXRTLExclusiveLock;
function  XRTLCreateReadWriteLock: IXRTLReadWriteLock; overload;
function  XRTLCreateReadWriteLock(const ALock: IXRTLExclusiveLock): IXRTLReadWriteLock; overload;
function  XRTLCreateNullReadWriteLock: IXRTLReadWriteLock;
function  XRTLAcquireExclusiveLock(const ALock: IXRTLExclusiveLock): IInterface;
function  XRTLBeginReadLock(const ALock: IXRTLReadWriteLock): IInterface; overload;
function  XRTLBeginWriteLock(const ALock: IXRTLReadWriteLock): IInterface; overload;
function  XRTLBeginReadLock(out ALockGuard: IInterface): IXRTLReadWriteLock; overload;
function  XRTLBeginWriteLock(out ALockGuard: IInterface): IXRTLReadWriteLock; overload;

implementation

uses
  xrtl_util_LockImpl;

function XRTLCreateExclusiveLock: IXRTLExclusiveLock;
begin
  Result:= TXRTLCriticalSectionExclusiveLock.Create;
end;

function XRTLCreateNullExclusiveLock: IXRTLExclusiveLock;
begin
  Result:= TXRTLNullExclusiveLock.Create;
end;

function XRTLCreateReadWriteLock: IXRTLReadWriteLock;
begin
  Result:= TXRTLReadWriteLock.Create;
end;

function XRTLCreateReadWriteLock(const ALock: IXRTLExclusiveLock): IXRTLReadWriteLock;
begin
  Result:= TXRTLReadWriteExclusiveLockAdapter.Create(ALock);
end;

function XRTLCreateNullReadWriteLock: IXRTLReadWriteLock;
begin
  Result:= TXRTLNullReadWriteLock.Create;
end;

function XRTLAcquireExclusiveLock(const ALock: IXRTLExclusiveLock): IInterface;
begin
  Result:= TXRTLExclusiveAutoLock.Create(ALock);
end;

function XRTLBeginReadLock(const ALock: IXRTLReadWriteLock): IInterface;
begin
  Result:= TXRTLReadAutoLock.Create(ALock);
end;

function XRTLBeginWriteLock(const ALock: IXRTLReadWriteLock): IInterface;
begin
  Result:= TXRTLWriteAutoLock.Create(ALock);
end;

function XRTLBeginReadLock(out ALockGuard: IInterface): IXRTLReadWriteLock;
begin
  Result:= XRTLCreateReadWriteLock;
  ALockGuard:= TXRTLReadAutoLock.Create(Result);
end;

function XRTLBeginWriteLock(out ALockGuard: IInterface): IXRTLReadWriteLock;
begin
  Result:= XRTLCreateReadWriteLock;
  ALockGuard:= TXRTLWriteAutoLock.Create(Result);
end;

end.
