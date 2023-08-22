
/////////////////////////////////////////////////////////
//                                                     //
//              Bold for Delphi                        //
//    Copyright (c) 1996-2002 Boldsoft AB              //
//              (c) 2002-2005 Borland Software Corp    //
//                                                     //
/////////////////////////////////////////////////////////


unit BoldThread;

interface

uses
  Classes,
  Windows,
  //Forms,
  Syncobjs;

type
  { forward declarations }
  TBoldNotifiableThread = class;

  { TBoldNotifiableThread }
  TBoldNotifiableThread = class(TThread)
  private
    fReadyEvent: TSimpleEvent;
    FQuitWaitTimeOut: integer;
    FQueueWindow: HWnd;
  protected
    procedure SignalReady;
    procedure EnsureMessageQueue;
    function ProcessMessage(var Msg: TMsg): Boolean; virtual;
    class procedure CreateQueueWindow(var ServerWindow: HWnd); virtual;
    procedure InitServerWindow (bInit: boolean);
    procedure DoTerminate; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    procedure Execute; override;
    function WaitUntilReady(dwMilliseconds: Cardinal): Boolean;
    function WaitUntilSignaled(dwMilliseconds: Cardinal): LongWord;
    procedure Notify(const Msg: Cardinal);
    function Quit(Wait: Boolean): Boolean; virtual;
    function WaitForQuit: Boolean;
    property QuitWaitTimeOut: integer read FQuitWaitTimeOut write FQuitWaitTimeOut;
    property QueueWindow: HWnd read FQueueWindow;
  end;

  function WaitForObject(iHandle: THandle; iTimeOut: dWord): TWaitResult;

implementation

uses
  SysUtils,
  Messages,
  BoldPropagatorConstants, { TODO : Move TIMEOUT to BoldDefs }
  //BoldThreadSafeLog,
  BoldCommonConst;

function WaitForObject (iHandle : THandle; iTimeOut : dword) : TWaitResult;
begin
  Assert (iHandle <> 0);
  case WaitForSingleObject (iHandle, iTimeout) of
    WAIT_OBJECT_0 :
      Result := wrSignaled;
    WAIT_TIMEOUT :
      Result := wrTimeout;
    WAIT_ABANDONED :
      Result := wrAbandoned;
    else
      Result := wrError;
  end;
end;

{ TBoldNotifiableThread }

constructor TBoldNotifiableThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(True);
  fReadyEvent := TSimpleEvent.Create;
  QuitWaitTimeOut := TIMEOUT * 5;
  ReturnValue := -10;
  Suspended := CreateSuspended;
end;

procedure TBoldNotifiableThread.SignalReady;
begin
  fReadyEvent.SetEvent;
end;

procedure TBoldNotifiableThread.EnsureMessageQueue;
var
  rMsg:TMsg;
begin
  PeekMessage(rMsg, 0, 0, 0, PM_NOREMOVE);  // force thread message queue!
end;

procedure TBoldNotifiableThread.Notify(const Msg: Cardinal);
begin
  PostThreadMessage(ThreadID, Msg, 0, 0);
end;

function TBoldNotifiableThread.WaitUntilReady(dwMilliseconds: Cardinal): Boolean;
begin
  Result := (fReadyEvent.WaitFor(dwMilliseconds) = wrSignaled);
end;

function TBoldNotifiableThread.WaitUntilSignaled(dwMilliseconds: Cardinal): LongWord;
begin
  Result := WaitForSingleObject(Handle, dwMilliseconds);
end;

function TBoldNotifiableThread.Quit(Wait: Boolean): Boolean;
var
  TimeOut: cardinal;
begin
  InitServerWindow(FALSE);
  Result := false;
  TimeOut := 0;
  if Suspended then
  begin
    Resume;
    WaitUntilReady(TIMEOUT);
    SwitchToThread; //REVIEW ME
  end;
  if not (Terminated) then
  begin
    PostThreadMessage (ThreadId, WM_QUIT, 0, 0);
    if (Wait) then
      Result := WaitForQuit
    else
      Result := (WaitForObject(Handle, Timeout*2) = wrSignaled);
  end;
end;

procedure TBoldNotifiableThread.Execute;
var
  rMsg:TMsg;
  res: integer;
begin
  EnsureMessageQueue;
  SignalReady;
  while not Terminated do
  begin
    res :=  Integer(GetMessage(rMsg, 0, 0, 0));
    if res = -1 then //error
      Terminate
    else if res = 0 then // terminated
      Terminate
      //handle message
    else
      ProcessMessage(rMsg);
  end;
end;

function TBoldNotifiableThread.ProcessMessage(var Msg: TMsg):Boolean;
begin
  Result := false;
end;

procedure TBoldNotifiableThread.DoTerminate;
begin
  FreeAndNil(fReadyEvent);
end;

function TBoldNotifiableThread.WaitForQuit: Boolean;
var
  wr : TWaitResult;
begin
  Result := false;
  try
    Assert(ThreadId <> GetCurrentThreadId,
    'Message queue thread cannot be terminated from within its own thread!!!' // donot localize
    );
    wr := WaitForObject(Handle, timeout*5);

    //if thread is not properly terminated, then force terminate it
    Result := (wr = wrSignaled);
    if (wr <> wrSignaled) then begin
      TerminateThread (Handle, 1);
      MessageBox(0,PChar('BoldLogError'), PChar('ThreadWasForcedTerminatedion'),MB_ICONHAND);
    end;
  except on E:Exception do
   MessageBox(0,PChar('sErrorWaitForQuit'), PChar('BoldLogError'),MB_ICONHAND);
  end;
end;

class procedure TBoldNotifiableThread.CreateQueueWindow(
  var ServerWindow: HWnd);
begin
  //impelement in subsclasses that use queue windows
end;

procedure TBoldNotifiableThread.InitServerWindow(bInit: boolean);
begin
  if (bInit) then
  begin
    if (FQueueWindow = 0) then
      CreateQueueWindow(FQueueWindow);
  end
  else
    if (FQueueWindow <> 0) then
    begin
      SendMessage (QueueWindow, WM_QUIT, 0, 0);
      FQueueWindow := 0;
    end;
end;

destructor TBoldNotifiableThread.Destroy;
begin
  FreeAndNil(fReadyEvent);
  inherited;
end;

end.
