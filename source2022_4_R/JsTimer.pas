unit JsTimer;

interface

uses Windows, Messages, SysUtils, Classes;

type
  TJsTimer = class(TComponent)
  private
    FEnabled: Boolean;
    FInterval: Cardinal;
    FOnTimer: TNotifyEvent;
    FSyncEvent: Boolean;
    FThreaded: Boolean;
    FTimerThread: TThread;
    FThreadPriority: TThreadPriority;
    procedure SetThreadPriority(Value: TThreadPriority);
    procedure SetThreaded(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnTimer(Value: TNotifyEvent);
    procedure UpdateTimer;
  protected
    procedure Timer; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Synchronize(Method: TThreadMethod);
  published
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
    property SyncEvent: Boolean read FSyncEvent write FSyncEvent default True;
    property Threaded: Boolean read FThreaded write SetThreaded default True;
    property ThreadPriority: TThreadPriority read FThreadPriority write SetThreadPriority default tpNormal;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
  end;

procedure Register;

implementation

uses Forms, Consts;

procedure Register;
begin
  RegisterComponents('Beispiele', [TJsTimer]);
end;

//=== { TJsTimerThread } =====================================================

type
  TJsTimerThread = class(TThread)
  private
    FOwner: TJsTimer;
    FInterval: Cardinal;
    FException: Exception;
    procedure HandleException;
  protected
    procedure Execute; override;
  public
    constructor Create(Timer: TJsTimer; Enabled: Boolean);
  end;

constructor TJsTimerThread.Create(Timer: TJsTimer; Enabled: Boolean);
begin
  FOwner := Timer;
  inherited Create(not Enabled);
  FInterval := 1000;
  FreeOnTerminate := True;
end;

procedure TJsTimerThread.HandleException;
begin
  if not (FException is EAbort) then
    Application.HandleException(Self);
end;

procedure TJsTimerThread.Execute;

  function ThreadClosed: Boolean;
  begin
    Result := Terminated or Application.Terminated or (FOwner = nil);
  end;

begin
  repeat
    if (not ThreadClosed) and (SleepEx(FInterval, False) = 0) and
       (not ThreadClosed) and FOwner.FEnabled then
       with FOwner do
            if SyncEvent
            then Synchronize(Timer)
            else try
                   Timer;
                 except
                   on E: Exception do begin
                      FException := E;
                      HandleException;
                   end;
                 end;
  until Terminated;
end;

//=== { TJsTimer } ===========================================================

constructor TJsTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  FInterval := 1000;
  FSyncEvent := True;
  FThreaded := True;
  FThreadPriority := tpNormal;
  FTimerThread := TJsTimerThread.Create(Self, False);
end;

destructor TJsTimer.Destroy;
begin
  Destroying;
  FEnabled := False;
  FOnTimer := nil;
  {TTimerThread(FTimerThread).FOwner := nil;}
  while FTimerThread.Suspended do FTimerThread.Resume;
  FTimerThread.Terminate;
  inherited Destroy;
end;

procedure TJsTimer.UpdateTimer;
begin
  if FThreaded
  then begin
         if not FTimerThread.Suspended then FTimerThread.Suspend;
         TJsTimerThread(FTimerThread).FInterval := FInterval;
         if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then begin
            FTimerThread.Priority := FThreadPriority;
            while FTimerThread.Suspended do FTimerThread.Resume;
         end;
  end
  else begin
         if not FTimerThread.Suspended then FTimerThread.Suspend;
  end;
end;

procedure TJsTimer.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TJsTimer.SetInterval(Value: Cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure TJsTimer.SetThreaded(Value: Boolean);
begin
  if Value <> FThreaded then
  begin
    FThreaded := Value;
    UpdateTimer;
  end;
end;

procedure TJsTimer.SetThreadPriority(Value: TThreadPriority);
begin
  if Value <> FThreadPriority then
  begin
    FThreadPriority := Value;
    if FThreaded then
      UpdateTimer;
  end;
end;

procedure TJsTimer.Synchronize(Method: TThreadMethod);
begin
  if FTimerThread <> nil then
  begin
    with TJsTimerThread(FTimerThread) do
    begin
      if Suspended or Terminated then
        Method
      else
        TJsTimerThread(FTimerThread).Synchronize(Method);
    end;
  end
  else
    Method;
end;

procedure TJsTimer.SetOnTimer(Value: TNotifyEvent);
begin
  if Assigned(FOnTimer) <> Assigned(Value) then
  begin
    FOnTimer := Value;
    UpdateTimer;
  end
  else
    FOnTimer := Value;
end;

procedure TJsTimer.Timer;
begin
  if FEnabled and not (csDestroying in ComponentState) and
    Assigned(FOnTimer) then
    FOnTimer(Self);
end;

end.
