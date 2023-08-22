{------------------------------------------------------------------------------}
{                                                                              }
{  TBackgroundWorker v1.10                                                     }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com   - fix work event                                                }
{                                                                              }
{------------------------------------------------------------------------------}

unit BackgroundWorker;

interface

uses
  SysUtils, Classes, Windows, Messages;

type

  EBackgroundWorker = class(Exception);

  TBackgroundWorker = class;

  TWorkEvent2 = procedure(Worker: TBackgroundWorker) of object;
  TWorkProgressEvent = procedure(Worker: TBackgroundWorker; PercentDone: Integer) of object;
  TWorkCompleteEvent = procedure(Worker: TBackgroundWorker; Cancelled: Boolean) of object;
  TWorkFeedbackEvent = procedure(Worker: TBackgroundWorker; FeedbackID, FeedbackValue: Integer) of object;

  TBackgroundWorker = class(TComponent)
  private
    fThread: TThread;
    fWindow: HWND;
    fSyncSignal: THandle;
    fFeedbackSignal: THandle;
    fProgressSignal: THandle;
    fCancellationPending: Boolean;
    fCancelled: Boolean;
    fPriority: TThreadPriority;
    fOnWork: TWorkEvent2;
    fOnWorkComplete: TWorkCompleteEvent;
    fOnWorkProgress: TWorkProgressEvent;
    fOnWorkFeedback: TWorkFeedbackEvent;
    procedure WindowCallback(var Message: TMessage);
    function GetWorking: Boolean;
    function GetThreadID: DWORD;
  protected
    property Thread: TThread read fThread;
    property Window: HWND read fWindow;
    procedure Cleanup(Forced: Boolean);
    procedure DoWork; virtual;
    procedure DoWorkComplete(Cancelled: Boolean); virtual;
    procedure DoWorkProgress(PercentDone: Integer); virtual;
    procedure DoWorkFeedback(FeedbackID, FeedbackValue: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute;
    procedure Cancel;
    procedure WaitFor;
    procedure ReportProgress(PercentDone: Integer);
    procedure ReportProgressWait(PercentDone: Integer);
    procedure ReportFeedback(FeedbackID, FeedbackValue: Integer);
    procedure ReportFeedbackWait(FeedbackID, FeedbackValue: Integer);
    procedure Synchronize(Method: TThreadMethod);
    procedure AcceptCancellation;
    property CancellationPending: Boolean read fCancellationPending;
    property IsCancelled: Boolean read fCancelled;
    property IsWorking: Boolean read GetWorking;
    property ThreadID: DWORD read GetThreadID;
  published
    property Priority: TThreadPriority read fPriority write fPriority default tpNormal;
    property OnWork: TWorkEvent2 read fOnWork write fOnWork;
    property OnWorkComplete: TWorkCompleteEvent read fOnWorkComplete write fOnWorkComplete;
    property OnWorkProgress: TWorkProgressEvent read fOnWorkProgress write fOnWorkProgress;
    property OnWorkFeedback: TWorkFeedbackEvent read fOnWorkFeedback write fOnWorkFeedback;
  end;

procedure Register;

implementation

{$IFDEF VER130} uses Forms; {$ENDIF}   // Delphi 5 & C++Builder 5
{$IFDEF VER125} uses Forms; {$ENDIF}   // C++Builder 4
{$IFDEF VER120} uses Forms; {$ENDIF}   // Delphi 4
{$IFDEF VER110} uses Forms; {$ENDIF}   // C++Builder 3
{$IFDEF VER100} uses Forms; {$ENDIF}   // Delphi 3
{$IFDEF VER93}  uses Forms; {$ENDIF}   // C++Builder 1
{$IFDEF VER90}  uses Forms; {$ENDIF}   // Delphi 2

procedure Register;
begin
  RegisterComponents('Delphi Area', [TBackgroundWorker]);
end;

const
  SInvalidCall = 'You must call ''%s.%s'' only inside the OnWork event handler';
  SInvalidExit = 'Before closing the application, ''%s'' must be stopped';
  SInvalidRun  = 'The background worker named ''%s'' is already running';

const
  WM_WORK_FEEDBACK      = WM_USER + 1;
  WM_WORK_FEEDBACK_WAIT = WM_USER + 2;
  WM_WORK_PROGRESS      = WM_USER + 3;
  WM_WORK_PROGRESS_WAIT = WM_USER + 4;
  WM_WORK_SYNCHORONIZE  = WM_USER + 5;
  WM_WORK_COMPLETE      = WM_USER + 6;

type
  PSyncRec = ^TSyncRec;
  TSyncRec = record
    Method: TThreadMethod;
  end;

{ TBackgroundWorkerThread }

type
  TBackgroundWorkerThread = class(TThread)
  private
    fOwner: TBackgroundWorker;
  public
    constructor CreateWorker(AOwner: TBackgroundWorker);
    procedure Execute; override;
  end;

constructor TBackgroundWorkerThread.CreateWorker(AOwner: TBackgroundWorker);
begin
  fOwner := AOwner;
  Create(True);
  Priority := fOwner.Priority;
end;

procedure TBackgroundWorkerThread.Execute;
begin
  try
    try
      fOwner.DoWork;
    except
      fOwner.AcceptCancellation;
      ShowException(ExceptObject, ExceptAddr);
    end;
  finally
    PostMessage(fOwner.Window, WM_WORK_COMPLETE, Ord(fOwner.IsCancelled), 0);
  end;
end;

{ TBackgroundWorker }

constructor TBackgroundWorker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fPriority := tpNormal;
end;

destructor TBackgroundWorker.Destroy;
begin
  if IsWorking then
  begin
    TerminateThread(fThread.Handle, 0);
    Cleanup(True);
    raise EBackgroundWorker.CreateFmt(SInvalidExit, [Name]);
  end;
  inherited Destroy;
end;

function TBackgroundWorker.GetWorking: Boolean;
begin
  Result := (fWindow <> 0);
end;

function TBackgroundWorker.GetThreadID: DWORD;
begin
  if Assigned(fThread) then
    Result := fThread.ThreadID
  else
    Result := 0;
end;

procedure TBackgroundWorker.WindowCallback(var Message: TMessage);
var
  SyncRec: PSyncRec;
begin
  case Message.Msg of
    WM_WORK_FEEDBACK:
      DoWorkFeedback(Message.WParam, Message.LParam);
    WM_WORK_FEEDBACK_WAIT:
      try
        DoWorkFeedback(Message.WParam, Message.LParam);
      finally
        SetEvent(fFeedbackSignal);
      end;
    WM_WORK_PROGRESS:
      DoWorkProgress(Message.WParam);
    WM_WORK_PROGRESS_WAIT:
      try
        DoWorkProgress(Message.WParam);
      finally
        SetEvent(fProgressSignal);
      end;
    WM_WORK_SYNCHORONIZE:
      try
        SyncRec := PSyncRec(Message.WParam);
        if Assigned(SyncRec) and Assigned(SyncRec^.Method) then
          SyncRec^.Method;
      finally
        SetEvent(fSyncSignal);
      end;
    WM_WORK_COMPLETE:
    begin
      Cleanup(false);
      DoWorkComplete(LongBool(Message.WParam));
    end;
  else
    with Message do
    begin
      Result := DefWindowProc(fWindow, Msg, WParam, LParam);
      if Msg = WM_DESTROY then
        fWindow := 0;
    end;
  end;
end;

procedure TBackgroundWorker.Execute;
begin
  if not IsWorking then
  begin
    fCancelled := False;
    fCancellationPending := False;
    try
      fWindow := AllocateHWnd(WindowCallback);
      fThread := TBackgroundWorkerThread.CreateWorker(Self);
      fThread.Resume;
    except
      Cleanup(True);
      raise;
    end;
  end
  else
    raise EBackgroundWorker.CreateFmt(SInvalidRun, [Name]);
end;

procedure TBackgroundWorker.Cleanup(Forced: Boolean);
begin
  if fSyncSignal <> 0 then
  begin
    CloseHandle(fSyncSignal);
    fSyncSignal := 0;
  end;
  if fFeedbackSignal <> 0 then
  begin
    CloseHandle(fFeedbackSignal);
    fFeedbackSignal := 0;
  end;
  if fProgressSignal <> 0 then
  begin
    CloseHandle(fProgressSignal);
    fProgressSignal := 0;
  end;
  if Assigned(fThread) then
  begin
    fThread.Free;
    fThread := nil;
  end;
  if fWindow <> 0 then
  begin
    DeallocateHWnd(fWindow);
    if Forced then
      fWindow := 0;
  end;
end;

procedure TBackgroundWorker.DoWork;
begin
  if Assigned(fOnWork) then
    fOnWork(Self);
end;

procedure TBackgroundWorker.DoWorkProgress(PercentDone: Integer);
begin
  if Assigned(fOnWorkProgress) then
    fOnWorkProgress(Self, PercentDone);
end;

procedure TBackgroundWorker.DoWorkComplete(Cancelled: Boolean);
begin
  if Assigned(fOnWorkComplete) then
    fOnWorkComplete(Self, Cancelled);
end;

procedure TBackgroundWorker.DoWorkFeedback(FeedbackID, FeedbackValue: Integer);
begin
  if Assigned(fOnWorkFeedback) then
    fOnWorkFeedback(Self, FeedbackID, FeedbackValue);
end;

procedure TBackgroundWorker.ReportProgress(PercentDone: Integer);
begin
  if ThreadID = GetCurrentThreadId then
    PostMessage(fWindow, WM_WORK_PROGRESS, PercentDone, 0)
  else
    raise EBackgroundWorker.CreateFmt(SInvalidCall, [Name, 'ReportProgress']);
end;

procedure TBackgroundWorker.ReportProgressWait(PercentDone: Integer);
begin
  if ThreadID = GetCurrentThreadId then
  begin
    if fProgressSignal = 0 then
      fProgressSignal := CreateEvent(nil, True, False, nil)
    else
      ResetEvent(fProgressSignal);
    PostMessage(fWindow, WM_WORK_PROGRESS_WAIT, PercentDone, 0);
    WaitForSingleObject(fProgressSignal, INFINITE);
  end
  else
    raise EBackgroundWorker.CreateFmt(SInvalidCall, [Name, 'ReportProgressWait']);
end;

procedure TBackgroundWorker.ReportFeedback(FeedbackID, FeedbackValue: Integer);
begin
  if Assigned(fThread) and (GetCurrentThreadId = fThread.ThreadID) then
    PostMessage(fWindow, WM_WORK_FEEDBACK, FeedbackID, FeedbackValue)
  else
    raise EBackgroundWorker.CreateFmt(SInvalidCall, [Name, 'ReportFeedback']);
end;

procedure TBackgroundWorker.ReportFeedbackWait(FeedbackID, FeedbackValue: Integer);
begin
  if Assigned(fThread) and (GetCurrentThreadId = fThread.ThreadID) then
  begin
    if fFeedbackSignal = 0 then
      fFeedbackSignal := CreateEvent(nil, True, False, nil)
    else
      ResetEvent(fFeedbackSignal);
    PostMessage(fWindow, WM_WORK_FEEDBACK_WAIT, FeedbackID, FeedbackValue);
    WaitForSingleObject(fFeedbackSignal, INFINITE);
  end
  else
    raise EBackgroundWorker.CreateFmt(SInvalidCall, [Name, 'ReportFeedbackWait']);
end;

procedure TBackgroundWorker.Synchronize(Method: TThreadMethod);
var
  SyncRec: TSyncRec;
begin
  if Assigned(fThread) and (GetCurrentThreadId = fThread.ThreadID) then
  begin
    SyncRec.Method := Method;
    if fSyncSignal = 0 then
      fSyncSignal := CreateEvent(nil, True, False, nil)
    else
      ResetEvent(fSyncSignal);
    PostMessage(fWindow, WM_WORK_SYNCHORONIZE, Integer(@SyncRec), 0);
    WaitForSingleObject(fSyncSignal, INFINITE);
  end
  else
    raise EBackgroundWorker.CreateFmt(SInvalidCall, [Name, 'Synchronize']);
end;

procedure TBackgroundWorker.AcceptCancellation;
begin
  if ThreadID = GetCurrentThreadId then
  begin
    fCancelled := True;
    fCancellationPending := False;
  end
  else
    raise EBackgroundWorker.CreateFmt(SInvalidCall, [Name, 'AcceptCancellation']);
end;

procedure TBackgroundWorker.Cancel;
begin
  if IsWorking then
    fCancellationPending := True;
end;

procedure TBackgroundWorker.WaitFor;
var
  Msg: TMSG;
begin
  while IsWorking do
    if PeekMessage(Msg, fWindow, 0, 0, PM_REMOVE) then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
end;

end.
