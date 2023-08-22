{------------------------------------------------------------------------------}
{                                                                              }
{  WaveTimer - A component wrapper to Windows Multimedia Timer                 }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{------------------------------------------------------------------------------}

{$I DELPHIAREA.INC}

unit WaveTimer;

interface

uses
  Windows, Messages, Classes, SysUtils, mmSystem;

type
  TMultimediaTimer = class(TComponent)
  private
    fTimerID: Integer;
    fEnabled: Boolean;
    fInterval: WORD;
    fResolution: WORD;
    fOnTimer: TNotifyEvent;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: WORD);
    procedure SetResolution(Value: WORD);
    procedure StartTimer;
    procedure StopTimer;
  protected
    procedure Loaded; override;
    procedure DoTimer; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function TimerCaps: TTimeCaps;
    property TimerID: Integer read fTimerID;
  published
    property Enabled: Boolean read fEnabled write SetEnabled default False;
    property Interval: WORD read fInterval write SetInterval default 1000; // Milliseconds
    property Resolution: WORD read fResolution write SetResolution default 100; // Milliseconds
    property OnTimer: TNotifyEvent read fOnTimer write fOnTimer;
  end;

implementation

{ Multimedia Timer Callback Function }

procedure TimerProc(uTimerID, uMessage, dwUser, dw1, dw2: DWORD); stdcall;
begin
  TMultimediaTimer(dwUser).DoTimer;
end;

{ TMultimediaTimer }

constructor TMultimediaTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fEnabled := False;
  fInterval := 1000;
  fResolution := 100;
end;

destructor TMultimediaTimer.Destroy;
begin
  Enabled := False;
  inherited Destroy;
end;

procedure TMultimediaTimer.Loaded;
begin
  inherited Loaded;
  if Enabled then StartTimer;
end;

procedure TMultimediaTimer.DoTimer;
begin
  if Assigned(fOnTimer) then
    fOnTimer(Self);
end;

procedure TMultimediaTimer.SetEnabled(Value: Boolean);
begin
  if Enabled <> Value then
  begin
    fEnabled := Value;
    if Enabled then
      StartTimer
    else
      StopTimer;
  end;
end;

procedure TMultimediaTimer.SetInterval(Value: WORD);
begin
  if Interval <> Value then
  begin
    if Enabled then
      StopTimer;
    fInterval := Value;
    if Enabled then
      StartTimer;
  end;
end;

procedure TMultimediaTimer.SetResolution(Value: WORD);
begin
  if Resolution <> Value then
  begin
    if Enabled then
      StopTimer;
    fResolution := Value;
    if Enabled then
      StartTimer;
  end;
end;

procedure TMultimediaTimer.StartTimer;
begin
  if not ((csLoading in ComponentState) or (csDesigning in ComponentState)) and (TimerID = 0) then
  begin
    with TimerCaps do
    begin
      if Resolution < wPeriodMin then
        fResolution := wPeriodMin;
      if Resolution > wPeriodMax then
        fResolution := wPeriodMax;
    end;
    if Interval < Resolution then
      fInterval := Resolution;
    if Interval > 0 then
    begin
      timeBeginPeriod(Resolution);
      fTimerID := timeSetEvent(Interval, Resolution, @TimerProc, DWORD(Self), TIME_PERIODIC);
      fEnabled := (TimerID <> 0);
    end;
  end;
end;

procedure TMultimediaTimer.StopTimer;
begin
  if TimerID <> 0 then
  begin
    timeKillEvent(TimerID);
    fTimerID := 0;
    timeEndPeriod(Resolution);
  end;
end;

class function TMultimediaTimer.TimerCaps: TTimeCaps;
begin
  if timeGetDevCaps(@Result, SizeOf(TTimeCaps)) <> TIMERR_NOERROR then
    FillChar(Result, SizeOf(TTimeCaps), 0);
end;

end.
