{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit SyncObjs;

{$H+,X+}

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
  Messages,
{$ENDIF}
{$IFDEF LINUX}
  Libc,
{$ENDIF}
  SysUtils,
  Classes;

type
{$IFNDEF MSWINDOWS}
  PSecurityAttributes = Pointer;
{$ENDIF}
{$IFDEF MSWINDOWS}
  TCriticalSectionHelper = record helper for TRTLCriticalSection
    procedure Initialize; inline;
    procedure Destroy; inline;
    procedure Free; inline;
    procedure Enter; inline;
    procedure Leave; inline;
    function TryEnter: Boolean; inline;
  end;

  TConditionVariableHelper = record helper for TRTLConditionVariable
  public
    class function Create: TRTLConditionVariable; static;
    procedure Free; inline;
    function SleepCS(var CriticalSection: TRTLCriticalSection; dwMilliseconds: DWORD): Boolean;
    procedure Wake;
    procedure WakeAll;
  end;
{$ENDIF}

  TSynchroObject = class(TObject)
  public
    procedure Acquire; virtual;
    procedure Release; virtual;
  end;

  TWaitResult = (wrSignaled, wrTimeout, wrAbandoned, wrError, wrIOCompletion);
  THandleObject = class;
  THandleObjectArray = array of THandleObject;

  THandleObject = class(TSynchroObject)
{$IFDEF MSWINDOWS}
  protected
    FHandle: THandle;
    FLastError: Integer;
    FUseCOMWait: Boolean;
  public
    { Specify UseCOMWait to ensure that when blocked waiting for the object
      any STA COM calls back into this thread can be made. }
    constructor Create(UseCOMWait: Boolean = False);
    destructor Destroy; override;
{$ENDIF}
  public
    function WaitFor(Timeout: LongWord): TWaitResult; virtual;
{$IFDEF MSWINDOWS}
    class function WaitForMultiple(const HandleObjs: THandleObjectArray;
      Timeout: LongWord; AAll: Boolean; out SignaledObj: THandleObject;
      UseCOMWait: Boolean = False; Len: Integer = 0): TWaitResult;
    property LastError: Integer read FLastError;
    property Handle: THandle read FHandle;
{$ENDIF}
  end;

  TEvent = class(THandleObject)
{$IFDEF LINUX}
  private
    FEvent: TSemaphore;
    FManualReset: Boolean;
{$ENDIF}
  public
    constructor Create(EventAttributes: PSecurityAttributes; ManualReset,
      InitialState: Boolean; const Name: string; UseCOMWait: Boolean = False); overload;
    constructor Create(UseCOMWait: Boolean = False); overload;
{$IFDEF LINUX}
    function WaitFor(Timeout: LongWord): TWaitResult; overload;
{$ENDIF}
    procedure SetEvent;
    procedure ResetEvent;
  end;

  TSimpleEvent = class(TEvent);

  TMutex = class(THandleObject)
  public
    constructor Create(UseCOMWait: Boolean = False); overload;
    constructor Create(MutexAttributes: PSecurityAttributes; InitialOwner: Boolean; const Name: string; UseCOMWait: Boolean = False); overload;
    constructor Create(DesiredAccess: LongWord; InheritHandle: Boolean; const Name: string; UseCOMWait: Boolean = False); overload;
    procedure Acquire; override;
    procedure Release; override;
  end;

  TSemaphore = class(THandleObject)
  public
    constructor Create(UseCOMWait: Boolean = False); overload;
    constructor Create(SemaphoreAttributes: PSecurityAttributes; AInitialCount, AMaximumCount: Integer; const Name: string; UseCOMWait: Boolean = False); overload;
    constructor Create(DesiredAccess: LongWord; InheritHandle: Boolean; const Name: string; UseCOMWait: Boolean = False); overload;
    procedure Acquire; override;
    procedure Release; overload; override;
    function Release(AReleaseCount: Integer): Integer; reintroduce; overload;
  end;

  TCriticalSection = class(TSynchroObject)
  protected
    FSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Acquire; override;
    procedure Release; override;
    function TryEnter: Boolean;
    procedure Enter; inline;
    procedure Leave; inline;
  end;

  TConditionVariableMutex = class(TSynchroObject)
  private
    FWaiterCount: Integer;
    FCountLock: TCriticalSection;
    FWaitSemaphore: TSemaphore;
    FWaitersDoneEvent: TEvent;
    FBroadcasting: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Acquire; override;
    procedure Release; override;
    procedure ReleaseAll;
    function WaitFor(AExternalMutex: TMutex; TimeOut: LongWord = INFINITE): TWaitResult;
  end;

  TConditionVariableCS = class(TSynchroObject)
  protected
    FConditionVariable: TRTLConditionVariable;
  public
    constructor Create;
    procedure Acquire; override;
    procedure Release; override;
    procedure ReleaseAll;
    function WaitFor(CriticalSection: TCriticalSection; TimeOut: LongWord = INFINITE): TWaitResult; overload;
    function WaitFor(var CriticalSection: TRTLCriticalSection; TimeOut: LongWord = INFINITE): TWaitResult; overload;
  end;

implementation

uses RTLConsts, Math;

type
  PInternalConditionVariable = ^TInternalConditionVariable;
  TInternalConditionVariable = record
  strict private
    type
      PWaitingThread = ^TWaitingThread;
      TWaitingThread = record
        Next: PWaitingThread;
        Thread: Cardinal;
        WaitEvent: THandle;
      end;
    var
      FWaitQueue: PWaitingThread;
    function LockQueue: PWaitingThread;
    procedure UnlockQueue(WaitQueue: PWaitingThread);
    procedure QueueWaiter(var WaitingThread: TWaitingThread);
    function DequeueWaiterNoLock(var WaitQueue: PWaitingThread): PWaitingThread;
    function DequeueWaiter: PWaitingThread;
    procedure RemoveWaiter(var WaitingThread: TWaitingThread);
  public
    class function Create: TInternalConditionVariable; static;
    function SleepCriticalSection(var CriticalSection: TRTLCriticalSection; Timeout: DWORD): Boolean;
    procedure Wake;
    procedure WakeAll;
  end;

  TCoWaitForMultipleHandlesProc = function (dwFlags: DWORD; dwTimeOut: DWORD;
    cHandles: LongWord; var Handles; var lpdwIndex: DWORD): HRESULT; stdcall;
  TInitializeConditionVariableProc = procedure (out ConditionVariable: TRTLConditionVariable); stdcall;
  TSleepConditionVariableCSProc = function (var ConditionVariable: TRTLConditionVariable; var CriticalSection: TRTLCriticalSection; dwMilliseconds: DWORD): BOOL; stdcall;
  TWakeConditionVariableProc = procedure (var ConditionVariable: TRTLConditionVariable); stdcall;
  TWakeAllConditionVariableProc = procedure (var ConditionVariable: TRTLConditionVariable); stdcall;

var
  CoWaitForMultipleHandlesProc: TCoWaitFormultipleHandlesProc;
  InitializeConditionVariableProc: TInitializeConditionVariableProc;
  SleepConditionVariableCSProc: TSleepConditionVariableCSProc;
  WakeConditionVariableProc: TWakeConditionVariableProc;
  WakeAllConditionVariableProc: TWakeAllConditionVariableProc;

threadvar
  OleThreadWnd: HWND;

const
  OleThreadWndClassName = 'OleMainThreadWndClass'; //do not localize
  COWAIT_WAITALL = $00000001;
  COWAIT_ALERTABLE = $00000002;

function GetOleThreadWindow: HWND;
var
  ChildWnd: HWND;
  ParentWnd: HWND;
begin
  if (OleThreadWnd = 0) or not IsWindow(OleThreadWnd) then
  begin
    if (Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion >= 5) then
      ParentWnd := HWND_MESSAGE
    else
      ParentWnd := 0;
    ChildWnd := 0;
    repeat
      OleThreadWnd := FindWindowEx(ParentWnd, ChildWnd, OleThreadWndClassName, nil);
      ChildWnd := OleThreadWnd;
    until (OleThreadWnd = 0) or (GetWindowThreadProcessId(OleThreadWnd, nil) = GetCurrentThreadId);
  end;
  Result := OleThreadWnd;
end;

function InternalCoWaitForMultipleHandles(dwFlags: DWORD; dwTimeOut: DWORD;
  cHandles: LongWord; var Handles; var lpdwIndex: DWORD): HRESULT; stdcall;
var
  WaitResult: DWORD;
  OleThreadWnd: HWnd;
  Msg: TMsg;
begin
  WaitResult := 0; // supress warning
  OleThreadWnd := GetOleThreadWindow;
  if OleThreadWnd <> 0 then
    while True do
    begin
      WaitResult := MsgWaitForMultipleObjectsEx(cHandles, Handles, dwTimeOut, QS_ALLEVENTS, dwFlags);
      if WaitResult = WAIT_OBJECT_0 + cHandles then
      begin
        if PeekMessage(Msg, OleThreadWnd, 0, 0, PM_REMOVE) then
        begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        end;
      end else
        Break;
    end
  else
    WaitResult := WaitForMultipleObjectsEx(cHandles, @Handles,
      dwFlags and COWAIT_WAITALL <> 0, dwTimeOut, dwFlags and COWAIT_ALERTABLE <> 0);
  if WaitResult = WAIT_TIMEOUT then
    Result := RPC_E_TIMEOUT
  else if WaitResult = WAIT_IO_COMPLETION then
    Result := RPC_S_CALLPENDING
  else
  begin
    Result := S_OK;
    if (WaitResult >= WAIT_ABANDONED_0) and (WaitResult < WAIT_ABANDONED_0 + cHandles) then
      lpdwIndex := WaitResult - WAIT_ABANDONED_0
    else
      lpdwIndex := WaitResult - WAIT_OBJECT_0;
  end;
end;

function CoWaitForMultipleHandles(dwFlags: DWORD; dwTimeOut: DWORD;
  cHandles: LongWord; var Handles; var lpdwIndex: DWORD): HRESULT;

  procedure LookupProc;
  var
    Ole32Handle: HMODULE;
  begin
    Ole32Handle := GetModuleHandle('ole32.dll'); //do not localize
    if Ole32Handle <> 0 then
      CoWaitForMultipleHandlesProc := GetProcAddress(Ole32Handle, 'CoWaitForMultipleHandles'); //do not localize
    if not Assigned(CoWaitForMultipleHandlesProc) then
      CoWaitForMultipleHandlesProc := InternalCoWaitForMultipleHandles;
  end;

begin
  if not Assigned(CoWaitForMultipleHandlesProc) then
    LookupProc;
  Result := CoWaitForMultipleHandlesProc(dwFlags, dwTimeOut, cHandles, Handles, lpdwIndex)
end;

{ TSynchroObject }

procedure TSynchroObject.Acquire;
begin
end;

procedure TSynchroObject.Release;
begin
end;

{ THandleObject }

{$IFDEF MSWINDOWS}
constructor THandleObject.Create(UseComWait: Boolean);
begin
  inherited Create;
  FUseCOMWait := UseCOMWait;
end;

destructor THandleObject.Destroy;
begin
  CloseHandle(FHandle);
  inherited Destroy;
end;
{$ENDIF}

function THandleObject.WaitFor(Timeout: LongWord): TWaitResult;
var
  Index: DWORD;
begin
{$IFDEF MSWINDOWS}
  if FUseCOMWait then
  begin
    case CoWaitForMultipleHandles(0, TimeOut, 1, FHandle, Index) of
      S_OK: Result := wrSignaled;
      RPC_S_CALLPENDING: Result := wrIOCompletion;
      RPC_E_TIMEOUT: Result := wrTimeout;
    else
      Result := wrError;
      FLastError := GetLastError;
    end;
  end else
  begin
    case WaitForMultipleObjectsEx(1, @FHandle, True, Timeout, False) of
      WAIT_ABANDONED: Result := wrAbandoned;
      WAIT_OBJECT_0: Result := wrSignaled;
      WAIT_TIMEOUT: Result := wrTimeout;
      WAIT_FAILED:
        begin
          Result := wrError;
          FLastError := GetLastError;
        end;
    else
      Result := wrError;
    end;
  end;
{$ENDIF}
{$IFDEF LINUX}
  Result := wrError;
{$ENDIF}
end;

{$IFDEF MSWINDOWS}
class function THandleObject.WaitForMultiple(
  const HandleObjs: THandleObjectArray; Timeout: LongWord; AAll: Boolean;
  out SignaledObj: THandleObject; UseCOMWait: Boolean; Len: Integer): TWaitResult;
var
  I: Integer;
  Index: DWORD;
  Handles: array of THandle;
  CoWaitFlags: Integer;
  WaitResult: DWORD;
begin
  if Len > 0 then
    Len := Min(Len, Length(HandleObjs))
  else
    Len := Length(HandleObjs);
  SetLength(Handles, Len);
  for I := Low(Handles) to High(Handles) do
    Handles[I] := HandleObjs[I].Handle;
  if UseCOMWait then
  begin
    if AAll then
      CoWaitFlags := COWAIT_WAITALL
    else
      CoWaitFlags := 0;
    case CoWaitForMultipleHandles(CoWaitFlags, Timeout, Length(Handles), Handles[0], Index) of
      S_OK: Result := wrSignaled;
      RPC_S_CALLPENDING: Result := wrIOCompletion;
      RPC_E_TIMEOUT: Result := wrTimeout;
    else
      Result := wrError;
    end;
    if not AAll and (Result = wrSignaled) then
      SignaledObj := HandleObjs[Index]
    else
      SignaledObj := nil;
  end else
  begin
    WaitResult := WaitForMultipleObjectsEx(Length(Handles), @Handles[0], AAll, Timeout, False);
    case WaitResult of
      WAIT_ABANDONED_0..WAIT_ABANDONED_0 + MAXIMUM_WAIT_OBJECTS - 1:
        begin
          Result := wrAbandoned;
          SignaledObj := HandleObjs[WaitResult - WAIT_ABANDONED_0];
        end;
      WAIT_TIMEOUT: Result := wrTimeout;
      WAIT_FAILED: Result := wrError;
      WAIT_IO_COMPLETION: Result := wrIOCompletion;
      WAIT_OBJECT_0..WAIT_OBJECT_0 + MAXIMUM_WAIT_OBJECTS - 1:
        begin
          Result := wrSignaled;
          SignaledObj := HandleObjs[WaitResult - WAIT_OBJECT_0];
        end;
      else
        Result := wrError;  
    end;
  end;
end;
{$ENDIF}

{ TEvent }

constructor TEvent.Create(EventAttributes: PSecurityAttributes; ManualReset,
  InitialState: Boolean; const Name: string; UseCOMWait: Boolean);
{$IFDEF MSWINDOWS}
begin
  inherited Create(UseCOMWait);
  FHandle := CreateEvent(EventAttributes, ManualReset, InitialState, PChar(Name));
end;
{$ENDIF}
{$IFDEF LINUX}
var
   Value: Integer;
begin
  if InitialState then
    Value := 1
  else
    Value := 0;

  FManualReset := ManualReset;

  sem_init(FEvent, False, Value);
end;
{$ENDIF}

constructor TEvent.Create(UseCOMWait: Boolean);
begin
  Create(nil, True, False, '', UseCOMWait);
end;

{$IFDEF LINUX}
function TEvent.WaitFor(Timeout: LongWord): TWaitResult;
begin
  if Timeout = LongWord($FFFFFFFF) then
  begin
    sem_wait(FEvent);
    Result := wrSignaled;
  end
  else if FManualReset then
    sem_post(FEvent)
  else
    Result := wrError;
end;
{$ENDIF}

procedure TEvent.SetEvent;
{$IFDEF MSWINDOWS}
begin
  Windows.SetEvent(Handle);
end;
{$ENDIF}
{$IFDEF LINUX}
var
  I: Integer;
begin
  sem_getvalue(FEvent, I);
  if I = 0 then
    sem_post(FEvent);
end;
{$ENDIF}

procedure TEvent.ResetEvent;
begin
{$IFDEF MSWINDOWS}
  Windows.ResetEvent(Handle);
{$ENDIF}
{$IFDEF LINUX}
  while sem_trywait(FEvent) = 0 do { nothing };
{$ENDIF}
end;

{ TCriticalSectionHelper }

procedure TCriticalSectionHelper.Initialize;
begin
  InitializeCriticalSection(Self);
end;

procedure TCriticalSectionHelper.Destroy;
begin
  DeleteCriticalSection(Self);
end;

procedure TCriticalSectionHelper.Enter;
begin
  EnterCriticalSection(Self);
end;

procedure TCriticalSectionHelper.Free;
begin
  Destroy;
end;

procedure TCriticalSectionHelper.Leave;
begin
  LeaveCriticalSection(Self);
end;

function TCriticalSectionHelper.TryEnter: Boolean;
begin
  Result := TryEnterCriticalSection(Self);
end;

{ TCriticalSection }

constructor TCriticalSection.Create;
begin
  inherited Create;
  FSection.Initialize;
end;

destructor TCriticalSection.Destroy;
begin
  FSection.Free;
  inherited Destroy;
end;

procedure TCriticalSection.Acquire;
begin
  FSection.Enter;
end;

procedure TCriticalSection.Release;
begin
  FSection.Leave;
end;

function TCriticalSection.TryEnter: Boolean;
begin
  Result := FSection.TryEnter;
end;

procedure TCriticalSection.Enter;
begin
  Acquire;
end;

procedure TCriticalSection.Leave;
begin
  Release;
end;

{ TMutex }

procedure TMutex.Acquire;
begin
  if WaitFor(INFINITE) = wrError then
    RaiseLastOSError;
end;

constructor TMutex.Create(UseCOMWait: Boolean);
begin
  Create(nil, False, '', UseCOMWait);
end;

constructor TMutex.Create(MutexAttributes: PSecurityAttributes;
  InitialOwner: Boolean; const Name: string; UseCOMWait: Boolean);
var
  lpName: PChar;
begin
  inherited Create(UseCOMWait);
  if Name <> '' then
    lpName := PChar(Name)
  else
    lpName := nil;
  FHandle := CreateMutex(MutexAttributes, InitialOwner, lpName);
  if FHandle = 0 then
    RaiseLastOSError;
end;

constructor TMutex.Create(DesiredAccess: LongWord; InheritHandle: Boolean;
  const Name: string; UseCOMWait: Boolean);
var
  lpName: PChar;
begin
  inherited Create(UseCOMWait);
  if Name <> '' then
    lpName := PChar(Name)
  else
    lpName := nil;
  FHandle := OpenMutex(DesiredAccess, InheritHandle, lpName);
  if FHandle = 0 then
    RaiseLastOSError;
end;

procedure TMutex.Release;
begin
  if not ReleaseMutex(FHandle) then
    RaiseLastOSError;
end;

{ TSemaphore }

procedure TSemaphore.Acquire;
begin
  if WaitFor(INFINITE) = wrError then
    RaiseLastOSError;
end;

constructor TSemaphore.Create(UseCOMWait: Boolean);
begin
  Create(nil, 1, 1, '', UseCOMWait);
end;

constructor TSemaphore.Create(DesiredAccess: LongWord; InheritHandle: Boolean;
  const Name: string; UseCOMWait: Boolean);
var
  lpName: PChar;
begin
  inherited Create(UseCOMWait);
  if Name <> '' then
    lpName := PChar(Name)
  else
    lpName := nil;
  FHandle := OpenSemaphore(DesiredAccess, InheritHandle, lpName);
  if FHandle = 0 then
    RaiseLastOSError;
end;

function TSemaphore.Release(AReleaseCount: Integer): Integer;
begin
  if not ReleaseSemaphore(FHandle, AReleaseCount, @Result) then
    RaiseLastOSError;
end;

constructor TSemaphore.Create(SemaphoreAttributes: PSecurityAttributes;
  AInitialCount, AMaximumCount: Integer; const Name: string; UseCOMWait: Boolean);
var
  lpName: PChar;
begin
  inherited Create(UseCOMWait);
  if Name <> '' then
    lpName := PChar(Name)
  else
    lpName := nil;
  FHandle := CreateSemaphore(SemaphoreAttributes, AInitialCount, AMaximumCount, lpName);
  if FHandle = 0 then
    RaiseLastOSError;
end;

procedure TSemaphore.Release;
begin
  if not ReleaseSemaphore(FHandle, 1, nil) then
    RaiseLastOSError;
end;

{ TConditionVariableMutex }

procedure TConditionVariableMutex.Acquire;
begin
  raise Exception.Create(sCannotCallAcquireOnConditionVar);
end;

constructor TConditionVariableMutex.Create;
begin
  inherited Create;
  FCountLock := TCriticalSection.Create;
  FWaitSemaphore := TSemaphore.Create(nil, 0, MaxInt, '');
  FWaitersDoneEvent := TEvent.Create(nil, False, False, '');
end;

destructor TConditionVariableMutex.Destroy;
begin
  FWaitersDoneEvent.Free;
  FWaitSemaphore.Free;
  FCountLock.Free;
  inherited;
end;

procedure TConditionVariableMutex.Release;
var
  AnyWaiters: Boolean;
begin
  FCountLock.Enter;
  try
    AnyWaiters := FWaiterCount > 0;
  finally
    FCountLock.Leave;
  end;
  if AnyWaiters then
    FWaitSemaphore.Release;
end;

procedure TConditionVariableMutex.ReleaseAll;
var
  AnyWaiters: Boolean;
begin
  AnyWaiters := False;
  FCountLock.Enter;
  try
    if FWaiterCount > 0 then
    begin
      FBroadcasting := True;
      FWaitSemaphore.Release(FWaiterCount);
      AnyWaiters := True;
      FCountLock.Leave;
      FWaitersDoneEvent.WaitFor(INFINITE);
      FBroadcasting := False;
    end;
  finally
    if not AnyWaiters then
      FCountLock.Leave;
  end;
end;

function TConditionVariableMutex.WaitFor(AExternalMutex: TMutex; TimeOut: LongWord): TWaitResult;
var
  LastWaiter: Boolean;
begin
  FCountLock.Enter;
  try
    Inc(FWaiterCount);
  finally
    FCountLock.Leave;
  end;
  case SignalObjectAndWait(AExternalMutex.Handle, FWaitSemaphore.Handle, TimeOut, False) of
    WAIT_FAILED, WAIT_IO_COMPLETION: Result := wrError;
    WAIT_ABANDONED: Result := wrAbandoned;
    WAIT_TIMEOUT: Result := wrTimeout;
  else
    Result := wrSignaled;
  end;
  FCountLock.Enter;
  try
    Dec(FWaiterCount);
    LastWaiter := FBroadcasting and (FWaiterCount = 0);
  finally
    FCountLock.Leave;
  end;
  if Result <> wrSignaled then
  begin
    if Result = wrTimeout then
      AExternalMutex.WaitFor(INFINITE);
    Exit;
  end;
  if LastWaiter then
    case SignalObjectAndWait(FWaitersDoneEvent.Handle, AExternalMutex.Handle, INFINITE, False) of
      WAIT_FAILED, WAIT_IO_COMPLETION: Result := wrError;
      WAIT_ABANDONED: Result := wrAbandoned;
      WAIT_TIMEOUT: Result := wrTimeout;
    else
      Result := wrSignaled;
    end
  else
    Result := AExternalMutex.WaitFor(INFINITE);
end;

{ TConditionVariableHelper }

class function TConditionVariableHelper.Create: TRTLConditionVariable;
begin
  InitializeConditionVariableProc(Result);
end;

procedure TConditionVariableHelper.Free;
begin
  // do nothing here;
end;

function TConditionVariableHelper.SleepCS(var CriticalSection: TRTLCriticalSection; dwMilliseconds: DWORD): Boolean;
begin
  Result := SleepConditionVariableCSProc(Self, CriticalSection, dwMilliseconds);
end;

procedure TConditionVariableHelper.Wake;
begin
  WakeConditionVariableProc(Self);
end;

procedure TConditionVariableHelper.WakeAll;
begin
  WakeAllConditionVariableProc(Self);
end;

procedure InternalInitConditionVariable(out ConditionVariable: TRTLConditionVariable); stdcall;
begin
  ConditionVariable.Ptr := nil;
end;

procedure InternalWakeConditionVariable(var ConditionVariable: TRTLConditionVariable); stdcall;
begin
  PInternalConditionVariable(@ConditionVariable).Wake;
end;

procedure InternalWakeAllConditionVariable(var ConditionVariable: TRTLConditionVariable); stdcall;
begin
  PInternalConditionVariable(@ConditionVariable).WakeAll;
end;

function InternalSleepConditionVariableCS(var ConditionVariable: TRTLConditionVariable; var CriticalSection: TRTLCriticalSection; dwMilliseconds: DWORD): BOOL; stdcall;
begin
  Result := PInternalConditionVariable(@ConditionVariable).SleepCriticalSection(CriticalSection, dwMilliseconds);
end;

{ TConditionVariableCS }

procedure TConditionVariableCS.Acquire;
begin
  raise Exception.Create(sCannotCallAcquireOnConditionVar);
end;

constructor TConditionVariableCS.Create;
begin

end;

procedure TConditionVariableCS.Release;
begin
  WakeConditionVariableProc(FConditionVariable);
end;

procedure TConditionVariableCS.ReleaseAll;
begin
  WakeAllConditionVariableProc(FConditionVariable);
end;

function TConditionVariableCS.WaitFor(var CriticalSection: TRTLCriticalSection;
  TimeOut: LongWord): TWaitResult;
begin
  if SleepConditionVariableCSProc(FConditionVariable, CriticalSection, Timeout) then
    Result := wrSignaled
  else
    case GetLastError of
      ERROR_TIMEOUT: Result := wrTimeout;
      WAIT_ABANDONED: Result := wrAbandoned;
    else
      Result := wrError;
    end;
end;

function TConditionVariableCS.WaitFor(CriticalSection: TCriticalSection;
  TimeOut: LongWord): TWaitResult;
begin
  Result := WaitFor(CriticalSection.FSection, TimeOut);
end;

{ TInternalConditionVariable }

class function TInternalConditionVariable.Create: TInternalConditionVariable;
begin
  Result.FWaitQueue := nil;
end;

function TInternalConditionVariable.DequeueWaiter: PWaitingThread;
var
  WaitQueue: PWaitingThread;
begin
  WaitQueue := LockQueue;
  try
    Result := DequeueWaiterNoLock(WaitQueue);
  finally
    UnlockQueue(WaitQueue);
  end;
end;

function TInternalConditionVariable.DequeueWaiterNoLock(var WaitQueue: PWaitingThread): PWaitingThread;
begin
  Result := WaitQueue;
  if (Result = nil) or (Result.Next = Result) then
  begin
    WaitQueue := nil;
    System.Exit;
  end else
  begin
    Result := WaitQueue.Next;
    WaitQueue.Next := WaitQueue.Next.Next;
  end;
end;

function TInternalConditionVariable.LockQueue: PWaitingThread;
var
  SpinLock: Boolean;
  SpinCount: Integer;
begin
  SpinLock := CPUCount > 1;
  if SpinLock then
    SpinCount := 4000
  else
    SpinCount := -1;
  repeat
    Result := PWaitingThread(Integer(FWaitQueue) and not 1);
    if InterlockedCompareExchange(Integer(FWaitQueue), Integer(Result) or 1, Integer(Result)) = Integer(Result) then
      Break;
    if SpinCount < 0 then
    begin
      SwitchToThread;
      if SpinLock then
        SpinCount := 4000
      else
        SpinCount := 0;
    end else
    asm
      PAUSE
    end;
    Dec(SpinCount);
  until False;
end;

procedure TInternalConditionVariable.QueueWaiter(var WaitingThread: TWaitingThread);
var
  WaitQueue: PWaitingThread;
begin
  // Lock the list
  Assert(Integer(@WaitingThread) and 1 = 0);
  WaitQueue := LockQueue;
  try
    if WaitQueue = nil then
    begin
      WaitQueue := @WaitingThread;
      WaitingThread.Next := @WaitingThread
    end else
    begin
      WaitingThread.Next := WaitQueue.Next;
      WaitQueue.Next := @WaitingThread;
      WaitQueue := @WaitingThread;
    end;
  finally
    UnlockQueue(WaitQueue);
  end;
end;

procedure TInternalConditionVariable.RemoveWaiter(var WaitingThread: TWaitingThread);
var
  WaitQueue, Last, Walker: PWaitingThread;
begin
  if Pointer(Integer(FWaitQueue) and not 1) <> nil then
  begin
    WaitQueue := LockQueue;
    try
      Last := WaitQueue.Next;
      Walker := Last.Next;
      while Walker <> WaitQueue do
      begin
        if Walker = @WaitingThread then
        begin
          Last.Next := Walker.Next;
          Break;
        end;
        Last := Walker;
        Walker := Walker.Next;
      end;
      if (Walker = WaitQueue) and (Walker = @WaitingThread) then
        if Walker.Next = Walker then
          WaitQueue := nil
        else
          WaitQueue := Last;
    finally
      UnlockQueue(WaitQueue);
    end;
  end;
end;

function TInternalConditionVariable.SleepCriticalSection(
  var CriticalSection: TRTLCriticalSection; Timeout: DWORD): Boolean;
var
  WaitingThread: TWaitingThread;
  RecursionCount: Integer;
begin
  if CriticalSection.OwningThread = GetCurrentThreadId then
  begin
    WaitingThread.Next := nil;
    WaitingThread.Thread := CriticalSection.OwningThread;
    WaitingThread.WaitEvent := CreateEvent(nil, False, False, nil);
    try
      // Save the current recursion count
      RecursionCount := CriticalSection.RecursionCount;
      // Add the current thread to the waiting queue
      QueueWaiter(WaitingThread);
      // Set it back to almost released
      CriticalSection.RecursionCount := 1;
      InterlockedExchangeAdd(CriticalSection.LockCount, -(RecursionCount - 1));
      // Release and get in line for someone to do a Pulse or PulseAll
      CriticalSection.Leave;
      // This is, admitedly, a potential race condition
      case WaitForSingleObject(WaitingThread.WaitEvent, Timeout) of
        WAIT_TIMEOUT:
          begin
            Result := False;
            SetLastError(ERROR_TIMEOUT);
          end;
        WAIT_OBJECT_0: Result := True;
      else
        Result := False;
        SetLastError(ERROR);
      end;
      // Got to get the lock back and block waiting for it.
      CriticalSection.Enter;
      // Remove any dangling waiters from the list
      RemoveWaiter(WaitingThread);
      // Lets restore all the recursion and lock counts
      InterlockedExchangeAdd(Integer(CriticalSection.LockCount), RecursionCount - 1);
      CriticalSection.RecursionCount := RecursionCount;
    finally
      CloseHandle(WaitingThread.WaitEvent);
    end;
  end else
    Result := False;
end;

procedure TInternalConditionVariable.UnlockQueue(WaitQueue: PWaitingThread);
begin
  FWaitQueue := PWaitingThread(Integer(WaitQueue) and not 1);
end;

procedure TInternalConditionVariable.Wake;
var
  WaitingThread: PWaitingThread;
begin
  WaitingThread := DequeueWaiter;
  if WaitingThread <> nil then
    SetEvent(WaitingThread.WaitEvent);
end;

procedure TInternalConditionVariable.WakeAll;
var
  WaitQueue, WaitingThread: PWaitingThread;
begin
  WaitQueue := LockQueue;
  try
    WaitingThread := DequeueWaiterNoLock(WaitQueue);
    while WaitingThread <> nil do
    begin
      SetEvent(WaitingThread.WaitEvent);
      WaitingThread := DequeueWaiterNoLock(WaitQueue);
    end;
  finally
    UnlockQueue(WaitQueue);
  end;
end;

procedure InitConditionVariableProcs;
var
  Module: HMODULE;
begin
  Module := GetModuleHandle('kernel32.dll'); // do not localize
  InitializeConditionVariableProc := GetProcAddress(Module, 'InitializeConditionVariable'); // do not localize
  if @InitializeConditionVariableProc = nil then
  begin
    InitializeConditionVariableProc := InternalInitConditionVariable;
    WakeConditionVariableProc := InternalWakeConditionVariable;
    WakeAllConditionVariableProc := InternalWakeAllConditionVariable;
    SleepConditionVariableCSProc := InternalSleepConditionVariableCS;
  end else
  begin
    WakeConditionVariableProc := GetProcAddress(Module, 'WakeConditionVariable'); // do not localize
    WakeAllConditionVariableProc := GetProcAddress(Module, 'WakeAllConditionVariable'); // do not localize
    SleepConditionVariableCSProc := GetProcAddress(Module, 'SleepConditionVariableCS'); // do not localize
  end;
end;

initialization
  InitConditionVariableProcs;
end.
