{==============================================================================|
| Project : Delphree - AsyncFree                                 | 001.004.000 |
|==============================================================================|
| Content:  Serial Communication Core Objects                                  |
|==============================================================================|
| The contents of this file are subject to the Mozilla Public License Ver. 1.0 |
| (the "License"); you may not use this file except in compliance with the     |
| License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ |
|                                                                              |
| Software distributed under the License is distributed on an "AS IS" basis,   |
| WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for |
| the specific language governing rights and limitations under the License.    |
|==============================================================================|
| The Original Code is AsyncFree Library.                                      |
|==============================================================================|
| The Initial Developer of the Original Code is Petr Vones (Czech Republic).   |
| Portions created by Petr Vones are Copyright (C) 1998, 1999.                 |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| History:                                                                     |
|   see AfRegister.pas                                                         |
|==============================================================================}

unit AfComPortCore;

{$I PVDEFINE.INC}

{$DEFINE Af_WaitForThreads}

interface

uses
  Windows, Messages, Classes, SysUtils, AfUtils, AfCircularBuffer;

const
  fBinary              = $00000001;
  fParity              = $00000002;
  fOutxCtsFlow         = $00000004;
  fOutxDsrFlow         = $00000008;
  fDtrControl          = $00000030;
  fDtrControlDisable   = $00000000;
  fDtrControlEnable    = $00000010;
  fDtrControlHandshake = $00000020;
  fDsrSensitivity      = $00000040;
  fTXContinueOnXoff    = $00000080;
  fOutX                = $00000100;
  fInX                 = $00000200;
  fErrorChar           = $00000400;
  fNull                = $00000800;
  fRtsControl          = $00003000;
  fRtsControlDisable   = $00000000;
  fRtsControlEnable    = $00001000;
  fRtsControlHandshake = $00002000;
  fRtsControlToggle    = $00003000;
  fAbortOnError        = $00004000;
  fDummy2              = $FFFF8000;

type
  TAfCoreEvent =
    (ceOutFree, // output buffer is free
     ceLineEvent, // line event returned by WaitCommEvent
     ceNeedReadData, // there's remaining data in input buffer - each 100ms generated
     ceException);

  EAfComPortCoreError = class(Exception);

  TAfComPortCore = class;

  TAfComPortCoreEvent = procedure(Sender: TAfComPortCore; EventKind: TAfCoreEvent; Data: DWORD) of object;

  TAfComPortCoreThread = class(TThread)
  private
    FException: TObject;
    FExceptAddr: Pointer;
  protected
    CloseEvent: THandle;
    ComPortCore: TAfComPortCore;
    DeviceHandle: THandle;
    procedure DoHandleException;
    procedure HandleException; dynamic;
  public
    constructor Create(AComPortCore: TAfComPortCore);
    destructor Destroy; override;
    procedure StopThread; dynamic;
  end;

  TAfComPortEventThread = class(TAfComPortCoreThread)
  private
    Event: DWORD;
    WaitPending: Boolean;
    EventOL, ReadOL: TOverlapped;
    FOnPortEvent: TAfComPortCoreEvent;
  protected
    procedure Execute; override;
    procedure HandleException; override;
    procedure SendEvent(EventKind: TAfCoreEvent; Data: DWORD);
  public
    constructor Create(AComPortCore: TAfComPortCore);
    destructor Destroy; override;
    function ReadData(var Buf; Size: Integer): DWORD;
    procedure StopThread; override;
  end;

  TAfComPortWriteThread = class(TAfComPortCoreThread)
  private
    FlushDoneEvent, FlushEvent, WriteEvent: THandle;
    WriteOL: TOverlapped;
    WriteBuffer: TAfCircularBuffer;
  protected
    procedure Execute; override;
  public
    constructor Create(AComPortCore: TAfComPortCore);
    destructor Destroy; override;
    function PurgeTX: Boolean;
    procedure StopThread; override;
    function WriteData(const Data; Size: Integer): Boolean;
  end;

  TAfComPortCore = class(TObject)
  private
    FCanPerformCall: Boolean;
    FComNumber: Integer; // 0 = ExternalHandle
    FDCB: TDCB;
    FEventMask: DWORD;
    FHandle: THandle;
    FIsOpen: Boolean;
    FLastError: DWORD;
    FInBuffSize: Integer;
    FOutBuffSize: Integer;
    FOnPortEvent: TAfComPortCoreEvent;
    CritSection: TRTLCriticalSection;
    WriteSection: TRTLCriticalSection;
    EventThread: TAfComPortEventThread;
    GlobalSignalEvent: THandle;
    OutBuffFreeEvent: THandle;
    WriteThread: TAfComPortWriteThread;
    FWriteThreadPriority: TThreadPriority;
    FEventThreadPriority: TThreadPriority;
    FDirectWrite: Boolean;
    procedure CreateDevHandle;
    function  DirectWriteData(const Data; Size: Integer): Boolean;
    function DeviceName: String;
    procedure DoPortEvent(EventKind: TAfCoreEvent; Data: DWORD);
    procedure InternalClose;
    procedure InternalOpen;
    procedure InternalSetBuffers;
    procedure InternalSetDCB;
    procedure InternalSetEventMask;
    procedure InternalSetTimeouts;
    procedure SetDCB(const Value: TDCB);
    procedure SetInBuffSize(const Value: Integer);
    procedure SetOutBuffSize(const Value: Integer);
    procedure SetEventMask(const Value: DWORD);
    procedure SetEventThreadPriority(const Value: TThreadPriority);
    procedure SetWriteThreadPriority(const Value: TThreadPriority);
    procedure SetDirectWrite(const Value: Boolean);
    procedure ThreadTerminated(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure CloseComPort;
    function ComError: DWORD;
    function ComStatus: TComStat;
    function EscapeComm(const Func: DWORD): Boolean;
    function ModemStatus: DWORD;
    function OpenComPort(ComNumber: Integer): Boolean;
    function OpenExternalHandle(ExternalHandle: THandle): Boolean; // ready for TAPI ...
    function OutBuffFree: Integer;
    function OutBuffUsed: Integer;
    function PurgeRX: Boolean;
    function PurgeTX: Boolean;
    function ReadData(var Data; Count: Integer): Integer;
    function WriteData(const Data; Size: Integer): Boolean;
    property ComNumber: Integer read FComNumber;
    property DCB: TDCB read FDCB write SetDCB;
    property DirectWrite: Boolean read FDirectWrite write SetDirectWrite;
    property EventMask: DWORD read FEventMask write SetEventMask;
    property EventThreadPriority: TThreadPriority read FEventThreadPriority write SetEventThreadPriority;
    property Handle: THandle read FHandle;
    property IsOpen: Boolean read FIsOpen;
    property InBuffSize: Integer read FInBuffSize write SetInBuffSize;
    property OutBuffSize: Integer read FOutBuffSize write SetOutBuffSize;
    property OnPortEvent: TAfComPortCoreEvent read FOnPortEvent write FOnPortEvent;
    property WriteThreadPriority: TThreadPriority read FWriteThreadPriority write SetWriteThreadPriority;
  end;

function FormatDeviceName(PortNumber: Integer): string;

implementation

const
  PortEventMask =
    EV_CTS or EV_DSR or EV_ERR or EV_RING or EV_RLSD or EV_RXCHAR;

resourcestring
  sCantPerform = 'Can''t perform this operation when port is open';
  sErrorCreatingThreads = 'Error creating threads';
  sErrorOpen = 'Can''t open device COM%d';
  sErrorSetCommMask = ' Error setting EventMask';
  sErrorSetDCB = 'Error setting parameters from DCB';
  sErrorSetTimeouts = 'Error setting timeouts';
  sErrorSetupComm = 'Error initializing buffers';
  sInvalidPortNumber = 'Invalid port number (COM%d)';

type
  TFixBugThread = class(TThread)
  protected
    procedure Execute; override;
  end;

function FormatDeviceName(PortNumber: Integer): string;
begin
  if (Win32Platform = VER_PLATFORM_WIN32_NT) and (PortNumber > 9) then
    Result := Format('\\.\COM%d', [PortNumber])
  else
    Result := Format('COM%d', [PortNumber]);
end;

var
  FixSyncWndBugThread: TFixBugThread = nil;

{ TFixBugThread }

procedure TFixBugThread.Execute;
begin // TThread instance prevents from destroying and creating TThread
end;  // synchronize window when ThreadCount is zero. This bug is fixed in D5.

procedure InitFixBugThread;
begin
{$IFNDEF PV_D5UP}
  if FixSyncWndBugThread = nil then
    FixSyncWndBugThread := TFixBugThread.Create(False);
{$ENDIF}
end;

{ TAfComPortCoreThread }

constructor TAfComPortCoreThread.Create(AComPortCore: TAfComPortCore);
begin
  CloseEvent := CreateEvent(nil, True, False, nil);
{$IFNDEF Af_WaitForThreads}
  FreeOnTerminate := True;
{$ENDIF}
  inherited Create(True);
  ComPortCore := AComPortCore;
  DeviceHandle := AComPortCore.FHandle;
end;

destructor TAfComPortCoreThread.Destroy;
begin
  inherited Destroy;
{$IFNDEF Af_WaitForThreads}
  ComPortCore.ThreadTerminated(Self);
{$ENDIF}
  SafeCloseHandle(CloseEvent);
end;

procedure TAfComPortCoreThread.DoHandleException;
begin
  if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
  SysUtils.ShowException(FException, FExceptAddr);
end;

procedure TAfComPortCoreThread.HandleException;
begin
  FException := Exception(ExceptObject);
  FExceptAddr := ExceptAddr;
  try
    if not (FException is EAbort) then
      Synchronize(DoHandleException);
  finally
    FException := nil;
    FExceptAddr := nil;
  end;
end;

procedure TAfComPortCoreThread.StopThread;
begin
  Terminate;
  SetEvent(CloseEvent);
{$IFDEF Af_WaitForThreads}
  WaitFor;
  Free;
{$ENDIF}
end;

{ TAfComPortEventThread }

constructor TAfComPortEventThread.Create(AComPortCore: TAfComPortCore);
begin
  inherited Create(AComPortCore);
  FOnPortEvent := AComPortCore.FOnPortEvent;
  Resume;
end;

destructor TAfComPortEventThread.Destroy;
begin
  inherited Destroy;
end;

procedure TAfComPortEventThread.Execute;
var
  Dummy: DWORD;
  EventHandles: array[0..3] of THandle;

  procedure HandleEvent;
begin
  ResetEvent(EventOL.hEvent);
  if Event = 0 then
  begin
    WaitPending := True;
  end else
  begin
    SendEvent(ceLineEvent, Event);
{    if WaitForSingleObject(EventHandles[2], 0) = WAIT_OBJECT_0 then
      SendEvent(ceOutFree, 0);}
  end;
end;

begin
  try
    ZeroMemory(@EventOL, Sizeof(EventOL));
    ZeroMemory(@ReadOL, Sizeof(ReadOL));
    EventOL.hEvent := CreateEvent(nil, True, False, nil);
    ReadOL.hEvent := CreateEvent(nil, True, False, nil);
    ResetEvent(ComPortCore.OutBuffFreeEvent);
    EventHandles[0] := CloseEvent;
    EventHandles[1] := EventOL.hEvent;
    EventHandles[2] := ComPortCore.OutBuffFreeEvent;
    WaitPending := False;
    SetEvent(ComPortCore.GlobalSignalEvent);
    repeat
      if {not Terminated and} not WaitPending then
      begin
        if WaitCommEvent(DeviceHandle, Event, @EventOL) then
          HandleEvent
        else
          if GetLastError = ERROR_IO_PENDING then WaitPending := True;
      end;
      if {not Terminated and} WaitPending then case WaitForMultipleObjects(3, @EventHandles, False, 200) of
        WAIT_OBJECT_0: // ReleaseThread
          Terminate;
        WAIT_OBJECT_0 + 1: // CommEvent
          if {not Terminated and} GetOverlappedResult(DeviceHandle, EventOL, Dummy, False) then
          begin
            WaitPending := False;
            HandleEvent;
          end;
        WAIT_OBJECT_0 + 2: // OutBufFree
          SendEvent(ceOutFree, 0);
        WAIT_TIMEOUT:
          if Assigned(ComPortCore) then
          begin
            WaitPending := True;
            Dummy := ComPortCore.ComStatus.cbInQue;
            if (Dummy > 0) then SendEvent(ceNeedReadData, Dummy);
          end;
      end;
    until Terminated;
    SafeCloseHandle(EventOL.hEvent);
    SafeCloseHandle(ReadOL.hEvent);
  except
    HandleException;
  end;
end;

procedure TAfComPortEventThread.HandleException;
begin
  if RaiseList <> nil then
  try
    FException := PRaiseFrame(RaiseList)^.ExceptObject;
    if not (FException is EAbort) then
    begin
      if Assigned(FOnPortEvent) then
      begin // Let the application to handle the exception
        PRaiseFrame(RaiseList)^.ExceptObject := nil;
        FOnPortEvent(ComPortCore, ceException, DWORD(FException));
      end else
        Synchronize(DoHandleException);
    end;   
  finally
    FException := nil;
  end;
{  FException := Exception(ExceptObject);
  try
    if not (FException is EAbort) then
    begin
      if Assigned(FOnPortEvent) and (RaiseList <> nil) then
      begin // Let the application to handle the exception
        FException := PRaiseFrame(RaiseList)^.ExceptObject;
        PRaiseFrame(RaiseList)^.ExceptObject := nil;
        FOnPortEvent(ComPortCore, ceException, DWORD(FException))
      end else
        Synchronize(DoHandleException);
    end;
  finally
    FException := nil;
  end;}
end;

function TAfComPortEventThread.ReadData(var Buf; Size: Integer): DWORD;
begin
  Result := 0;
//  if not Terminated then
  begin
    if not ReadFile(DeviceHandle, Buf, Size, Result, @ReadOL) then
      if GetLastError = ERROR_IO_PENDING then
        if GetOverlappedResult(DeviceHandle, ReadOL, Result, True) then
          ResetEvent(ReadOL.hEvent);
  end;
end;

procedure TAfComPortEventThread.SendEvent(EventKind: TAfCoreEvent; Data: DWORD);
begin
  try
    FException := nil;
    if Assigned(FOnPortEvent) then FOnPortEvent(ComPortCore, EventKind, Data);
  except
    HandleException; // Silent EAbort exception is expected here, see
                     // TAfCustomDataDispatcher.NotifyLinks or
                     // TAfCustomSerialPort.SynchronizeEvent 
  end;
end;

procedure TAfComPortEventThread.StopThread;
begin
  FOnPortEvent := nil;
  Terminate;
  SetCommMask(DeviceHandle, 0);
  PurgeComm(DeviceHandle, PURGE_RXABORT or PURGE_RXCLEAR);
  inherited StopThread;
end;

{ TAfComPortWriteThread }

constructor TAfComPortWriteThread.Create(AComPortCore: TAfComPortCore);
begin
  inherited Create(AComPortCore);
  FlushDoneEvent := CreateEvent(nil, False, False, nil);
  FlushEvent := CreateEvent(nil, False, False, nil);
  WriteEvent := CreateEvent(nil, False, False, nil);
  WriteBuffer := TAfCircularBuffer.Create(AComPortCore.FOutBuffSize);
  Resume;
end;

destructor TAfComPortWriteThread.Destroy;
begin
  SafeCloseHandle(FlushDoneEvent);
  SafeCloseHandle(FlushEvent);
  SafeCloseHandle(WriteEvent);
  WriteBuffer.Free;
  inherited Destroy;
end;

procedure TAfComPortWriteThread.Execute;
var
  BytesToWrite, BytesWritten: DWORD;
  WaitHandles: array[0..2] of THandle;
  WriteHandles: array[0..2] of THandle;
  Buf: PChar;

  procedure WriteError;
begin
  //OutputDebugString('!!! WRITE ERROR');
end;

  procedure WriteCompleted;
begin
  ResetEvent(WriteOL.hEvent);
  if BytesWritten <> BytesToWrite then
    WriteError
  else
  begin
    EnterCriticalSection(ComPortCore.WriteSection);
    WriteBuffer.Remove(BytesWritten);
    if WriteBuffer.BufUsed > 0 then
    begin
      SetEvent(WriteEvent);
      LeaveCriticalSection(ComPortCore.WriteSection);
    end else
    begin
      LeaveCriticalSection(ComPortCore.WriteSection);
      SetEvent(ComPortCore.OutBuffFreeEvent);
    end;
  end;
end;

begin
  try
    ZeroMemory(@WriteOL, Sizeof(WriteOL));
    WriteOL.hEvent := CreateEvent(nil, True, False, nil);
    WaitHandles[0] := CloseEvent;
    WaitHandles[1] := FlushEvent;
    WaitHandles[2] := WriteEvent;
    WriteHandles[0] := CloseEvent;
    WriteHandles[1] := FlushEvent;
    WriteHandles[2] := WriteOL.hEvent;
    BytesToWrite := 0;
    SetEvent(ComPortCore.GlobalSignalEvent);
    repeat
      case WaitForMultipleObjects(3, @WaitHandles, False, INFINITE) of
        WAIT_OBJECT_0:
          Terminate;
        WAIT_OBJECT_0 + 1:
          SetEvent(FlushDoneEvent);
        WAIT_OBJECT_0 + 2:
  //        if not Terminated then
          begin
            EnterCriticalSection(ComPortCore.WriteSection);
            BytesToWrite := WriteBuffer.BufLinearUsed;
            Buf := WriteBuffer.StartPtr;
            LeaveCriticalSection(ComPortCore.WriteSection);
            if WriteFile(DeviceHandle, Buf^, BytesToWrite, BytesWritten, @WriteOL) then
              WriteCompleted
            else
              if GetLastError = ERROR_IO_PENDING then
              begin
                case WaitForMultipleObjects(3, @WriteHandles, False, INFINITE) of
                  WAIT_OBJECT_0:
                    Terminate;
                  WAIT_OBJECT_0 + 1:
                    SetEvent(FlushDoneEvent);
                  WAIT_OBJECT_0 + 2:
                    if GetOverlappedResult(DeviceHandle, WriteOL, BytesWritten, True) then
                      WriteCompleted
                    else
                      WriteError;
                end;
              end else
                WriteError;
          end;
      end;
    until Terminated;
    SafeCloseHandle(WriteOL.hEvent);
  except
    HandleException;
  end;
end;

function TAfComPortWriteThread.PurgeTX: Boolean;
begin
  Result := False;
  SetEvent(FlushEvent);
  if WaitForSingleObject(FlushDoneEvent, 2000) = WAIT_OBJECT_0 then
  begin
    EnterCriticalSection(ComPortCore.WriteSection);
    ResetEvent(WriteEvent);
    WriteBuffer.Clear;
    Result := PurgeComm(DeviceHandle, PURGE_TXABORT or PURGE_TXCLEAR);
    LeaveCriticalSection(ComPortCore.WriteSection);
  end;
end;

procedure TAfComPortWriteThread.StopThread;
begin
  PurgeTX;
  inherited StopThread;
end;

function TAfComPortWriteThread.WriteData(const Data; Size: Integer): Boolean;
begin
//  if not Terminated then
    begin
      EnterCriticalSection(ComPortCore.WriteSection);
      Result := WriteBuffer.Write(Data, Size);
      if Result then SetEvent(WriteEvent);
      LeaveCriticalSection(ComPortCore.WriteSection);
    end;
end;

{ TAfComPortCore }

procedure TAfComPortCore.CloseComPort;
begin
  if FIsOpen then
  begin
    InternalClose;
    FIsOpen := False;
  end;
end;

function TAfComPortCore.ComError: DWORD;
begin
  if FCanPerformCall then
  begin
    EnterCriticalSection(CritSection);
    Result := FLastError;
    FLastError := 0; // Clear LastError after reading
    LeaveCriticalSection(CritSection);
  end else
    Result := 0;
end;

function TAfComPortCore.ComStatus: TComStat;
var
  Errors: DWORD;
begin
  if FCanPerformCall then
  begin
    EnterCriticalSection(CritSection);
    if ClearCommError(FHandle, Errors, @Result) then
      FLastError := FLastError or Errors;  // "add" LastError
    LeaveCriticalSection(CritSection);
  end else
    ZeroMemory(@Result, Sizeof(Result));
end;

constructor TAfComPortCore.Create;
begin
  InitFixBugThread;
  inherited Create;
  FEventMask := PortEventMask;
  FEventThreadPriority := tpNormal;
  FInBuffSize := 8192;
  FOutBuffSize := 4096;
  FWriteThreadPriority := tpHigher;
  ZeroMemory(@CritSection, Sizeof(CritSection));
  ZeroMemory(@WriteSection, Sizeof(WriteSection));
  InitializeCriticalSection(CritSection);
  InitializeCriticalSection(WriteSection);
  GlobalSignalEvent := CreateEvent(nil, False, False, nil);
  OutBuffFreeEvent := CreateEvent(nil, False, False, nil);
end;

procedure TAfComPortCore.CreateDevHandle;
begin
  FHandle := CreateFile(PChar(DeviceName), GENERIC_READ or GENERIC_WRITE, 0,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OVERLAPPED, 0);
  if FHandle = INVALID_HANDLE_VALUE then
  begin
    if GetLastError = ERROR_FILE_NOT_FOUND then
      raise EAfComPortCoreError.CreateFmt(sInvalidPortNumber, [FComNumber])
    else
      raise EAfComPortCoreError.CreateFmt(sErrorOpen, [FComNumber]);
  end;
end;

destructor TAfComPortCore.Destroy;
begin
  CloseComPort;
  SafeCloseHandle(GlobalSignalEvent);
  SafeCloseHandle(OutBuffFreeEvent);
  DeleteCriticalSection(CritSection);
  DeleteCriticalSection(WriteSection);
  inherited Destroy;
end;

function TAfComPortCore.DeviceName: String;
begin
  Result := FormatDeviceName(FComNumber);
end;

function TAfComPortCore.DirectWriteData(const Data; Size: Integer): Boolean;
var
  BytesWritten: DWORD;
  WriteOL: TOverlapped;
begin
  Result := False;
  EnterCriticalSection(WriteSection);
  ZeroMemory(@WriteOL, Sizeof(WriteOL));
  WriteOL.hEvent := CreateEvent(nil, True, False, nil);
  if not WriteFile(FHandle, Data, Size, BytesWritten, @WriteOL) then
  begin
    if GetLastError = ERROR_IO_PENDING then
    begin
      WaitForSingleObject(WriteOL.hEvent, INFINITE);
      if GetOverlappedResult(FHandle, WriteOL, BytesWritten, False) and
        (BytesWritten = DWORD(Size)) then Result := True;
    end else
      Result := False;
  end else
    Result := (BytesWritten = DWORD(Size));
  if Result then SetEvent(OutBuffFreeEvent);  
  CloseHandle(WriteOL.hEvent);
  LeaveCriticalSection(WriteSection);
end;

procedure TAfComPortCore.DoPortEvent(EventKind: TAfCoreEvent; Data: DWORD);
begin
  if Assigned(FOnPortEvent) then FOnPortEvent(Self, EventKind, Data);
end;

function TAfComPortCore.EscapeComm(const Func: DWORD): Boolean;
begin
  if FCanPerformCall then
    Result := EscapeCommFunction(FHandle, Func)
  else
    Result := False;
end;

procedure TAfComPortCore.InternalClose;
{$IFNDEF Af_WaitForThreads}
var
  Msg: TMsg;
{$ENDIF}
begin
  if FHandle <> INVALID_HANDLE_VALUE then
  begin
    FCanPerformCall := False;
    EnterCriticalSection(CritSection);
    PurgeComm(FHandle, PURGE_RXABORT or PURGE_RXCLEAR or PURGE_TXABORT or PURGE_TXCLEAR);
    if WriteThread <> nil then WriteThread.StopThread;
    if EventThread <> nil then EventThread.StopThread;
    LeaveCriticalSection(CritSection);
    SafeCloseHandle(FHandle);
{$IFNDEF Af_WaitForThreads}
    while (WriteThread <> nil) or (EventThread <> nil) do
      PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
{$ENDIF}
  end;
end;

procedure TAfComPortCore.InternalOpen;

  procedure WaitForThreadStart;
begin
  if WaitForSingleObject(GlobalSignalEvent, 3000) <> WAIT_OBJECT_0 then
    raise EAfComPortCoreError.Create(sErrorCreatingThreads);
end;

begin
  if FComNumber <> 0 then CreateDevHandle;
  try
    EventThread := nil;
    WriteThread := nil;
    InternalSetTimeouts;
    InternalSetBuffers;
    InternalSetEventMask;
    InternalSetDCB;
    FLastError := 0;
    if not FDirectWrite then
    begin
      WriteThread := TAfComPortWriteThread.Create(Self);
      WaitForThreadStart;
      WriteThread.Priority := FWriteThreadPriority;
    end;
    FCanPerformCall := True;
    EventThread := TAfComPortEventThread.Create(Self);
    WaitForThreadStart;
    EventThread.Priority := FEventThreadPriority;
    FIsOpen := True;
  except
    InternalClose;
    raise;
  end;
end;

procedure TAfComPortCore.InternalSetBuffers;
begin
  if not SetupComm(FHandle, FInBuffSize, FOutBuffSize) then
    raise EAfComPortCoreError.Create(sErrorSetupComm);
end;

procedure TAfComPortCore.InternalSetDCB;
begin
  if not SetCommState(FHandle, FDCB) then
  begin
    GetCommState(FHandle, FDCB);
    raise EAfComPortCoreError.Create(sErrorSetDCB);
  end;
end;

procedure TAfComPortCore.InternalSetEventMask;
begin
  if not SetCommMask(FHandle, FEventMask) then
    raise EAfComPortCoreError.Create(sErrorSetCommMask);
end;

procedure TAfComPortCore.InternalSetTimeouts;
var
  Timeouts: TCommTimeouts;
begin
  ZeroMemory(@Timeouts, Sizeof(Timeouts));
  Timeouts.ReadIntervalTimeout := MAXDWORD;
  if not SetCommTimeouts(FHandle, Timeouts) then
    raise EAfComPortCoreError.Create(sErrorSetTimeouts);
end;

function TAfComPortCore.ModemStatus: DWORD;
begin
  if FCanPerformCall then
    GetCommModemStatus(FHandle, Result)
  else
    Result := 0;
end;

function TAfComPortCore.OpenComPort(ComNumber: Integer): Boolean;
begin
  if not FIsOpen then
  begin
    if ComNumber <= 0 then
      raise EAfComPortCoreError.CreateFmt(sInvalidPortNumber, [ComNumber]);
    FComNumber := ComNumber;
    FHandle := INVALID_HANDLE_VALUE;
    InternalOpen;
    Result := True;
  end else
    Result := False;
end;

function TAfComPortCore.OpenExternalHandle(ExternalHandle: THandle): Boolean;
begin
  if not FIsOpen then
  begin
    FComNumber := 0;
    FHandle := ExternalHandle;
    InternalOpen;
    Result := True;
  end else
    Result := False;
end;

function TAfComPortCore.OutBuffFree: Integer;
begin
  if FCanPerformCall then
  begin
    if FDirectWrite then
      Result := ComStatus.cbOutQue
    else
    begin
      EnterCriticalSection(WriteSection);
      Result := WriteThread.WriteBuffer.BufFree;
      LeaveCriticalSection(WriteSection);
    end;
  end else
    Result := 0
end;

function TAfComPortCore.OutBuffUsed: Integer;
begin
  if FCanPerformCall then
  begin
    if FDirectWrite then
      Result := DWORD(FOutBuffSize) - ComStatus.cbOutQue
    else
    begin
      EnterCriticalSection(WriteSection);
      Result := WriteThread.WriteBuffer.BufUsed;
      LeaveCriticalSection(WriteSection);
    end;
  end else
    Result := 0
end;

function TAfComPortCore.PurgeRX: Boolean;
begin
  if FCanPerformCall then
  begin
    EnterCriticalSection(CritSection);
    Result := PurgeComm(FHandle, PURGE_RXABORT or PURGE_RXCLEAR);
    LeaveCriticalSection(CritSection);
  end else
    Result := False;
end;

function TAfComPortCore.PurgeTX: Boolean;
begin
  if FCanPerformCall then
  begin
    if FDirectWrite then
      Result := PurgeComm(FHandle, PURGE_TXABORT or PURGE_TXCLEAR)
    else
      Result := WriteThread.PurgeTX
  end else
    Result := False;
end;

function TAfComPortCore.ReadData(var Data; Count: Integer): Integer;
begin
  if FCanPerformCall then
  begin
    EnterCriticalSection(CritSection);
    Result := EventThread.ReadData(Data, Count);
    LeaveCriticalSection(CritSection);
  end else
    Result := -1;
end;

procedure TAfComPortCore.SetDCB(const Value: TDCB);
begin
  FDCB := Value;
  if FCanPerformCall then
  begin
    InternalSetDCB;
//    DoPortEvent(ceDCBChanged, 0);
  end;
end;

procedure TAfComPortCore.SetDirectWrite(const Value: Boolean);
begin
  if FIsOpen then
    raise EAfComPortCoreError.Create(sCantPerform);
  FDirectWrite := Value;
end;

procedure TAfComPortCore.SetEventMask(const Value: DWORD);
begin
  if FEventMask <> Value then
  begin
    FEventMask := Value;
    if FCanPerformCall then InternalSetEventMask;
  end;
end;

procedure TAfComPortCore.SetEventThreadPriority(const Value: TThreadPriority);
begin
  if FEventThreadPriority <> Value then
  begin
    FEventThreadPriority := Value;
    if FCanPerformCall then EventThread.Priority := FEventThreadPriority;
  end;
end;

procedure TAfComPortCore.SetInBuffSize(const Value: Integer);
begin
  if FInBuffSize <> Value then
  begin
    FInBuffSize := Value;
  end;
end;

procedure TAfComPortCore.SetOutBuffSize(const Value: Integer);
begin
  if FOutBuffSize <> Value then
  begin
    FOutBuffSize := Value;
  end;
end;

procedure TAfComPortCore.SetWriteThreadPriority(const Value: TThreadPriority);
begin
  if FWriteThreadPriority <> Value then
  begin
    FWriteThreadPriority := Value;
    if FCanPerformCall and not FDirectWrite then WriteThread.Priority := WriteThreadPriority;
  end;
end;

procedure TAfComPortCore.ThreadTerminated(Sender: TObject);
begin
  EnterCriticalSection(CritSection);
  if Sender = EventThread then
    EventThread := nil;
  if Sender = WriteThread then
    WriteThread := nil;
  LeaveCriticalSection(CritSection);
end;

function TAfComPortCore.WriteData(const Data; Size: Integer): Boolean;
begin
  if FCanPerformCall then
  begin
    if FDirectWrite then
      Result := DirectWriteData(Data, Size)
    else
      Result := WriteThread.WriteData(Data, Size)
  end else
    Result := False;
end;

initialization

finalization
  FixSyncWndBugThread.Free;

end.

