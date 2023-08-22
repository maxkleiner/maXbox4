{------------------------------------------------------------------------------}
{                                                                              }
{  TProfiler v1.02                                                             }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{------------------------------------------------------------------------------}

{$I DELPHIAREA.INC}

unit Profiler;

interface

uses
  Windows, Messages, Classes;

type

  TTimeUnit = (
    tuNanosecond,       { 1/1000000000 s }
    tuMicrosecond,      { 1/1000000 s    }
    tuMillisecond,      { 1/1000 s       }
    tuSecond,           { 1 s            }
    tuMinute,           { 60 s           }
    tuHour              { 3600 s         }
  );

  TTimeInfo = (
    tiAll,              { all timing information        }
    tiTotal,            { total elapsed time            }
    tiAvg,              { average elapsed time per hit  }
    tiFirst,            { elapsed time on the first hit }
    tiLast,             { elapsed time on the last hit  }
    tiMin,              { minimum elapsed time of hits  }
    tiMax               { maximum elapsed time of hits  }
  );

  TProfiler = class;

  TProfilerTimer = class(TCollectionItem)
  private
    fName: String;
    fFirstTime: Int64;
    fLastTime: Int64;
    fMinTime: Int64;
    fMinHit: DWORD;
    fMaxTime: Int64;
    fMaxHit: DWORD;
    fTotalHits: DWORD;
    fTotalTime: Int64;
    fTimeUnit: TTimeUnit;
    fDisplayFormat: String;
    procedure SetName(const Value: String);
    function GetFirstTime: Extended;
    function GetLastTime: Extended;
    function GetAvgTime: Extended;
    function GetMinTime: Extended;
    function GetMaxTime: Extended;
    function GetTotalTime: Extended;
    function GetAsText(TimeInfo: TTimeInfo): String;
    function GetAllText: String;
    function GetProfiler: TProfiler;
    function IsDisplayFormatStored: Boolean;
  protected
    function GetDisplayName: String; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    procedure Start;
    procedure Stop;
    procedure Reset;
    property Profiler: TProfiler read GetProfiler;
    property FirstTime: Extended read GetFirstTime;
    property LastTime: Extended read GetLastTime;
    property AvgTime: Extended read GetAvgTime;
    property MinHit: DWORD read fMinHit;
    property MinTime: Extended read GetMinTime;
    property MaxHit: DWORD read fMaxHit;
    property MaxTime: Extended read GetMaxTime;
    property TotalHits: DWORD read fTotalHits;
    property TotalTime: Extended read GetTotalTime;
    property AsText[TimeInfo: TTimeInfo]: String read GetAsText;
  published
    property Name: String read fName write SetName;
    property DisplayFormat: String read fDisplayFormat write fDisplayFormat stored IsDisplayFormatStored;
    property TimeUnit: TTimeUnit read fTimeUnit write fTimeUnit default tuMillisecond;
  end;

  {$IFDEF COMPILER4_UP}
  TProfilerTimers = class(TOwnedCollection)
  {$ELSE}
  TProfilerTimers = class(TCollection)
  {$ENDIF}
  private
    {$IFNDEF COMPILER4_UP}
    fOwner: TProfiler;
    {$ENDIF}
    function GetProfiler: TProfiler;
    function GetItem(Index: Integer): TProfilerTimer;
    procedure SetItem(Index: Integer; Value: TProfilerTimer);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TProfiler);
    property Profiler: TProfiler read GetProfiler; 
    function Add: TProfilerTimer;
    {$IFDEF COMPILER4_UP}
    function Insert(Index: Integer): TProfilerTimer;
    {$ENDIF}
    property Items[Index: Integer]: TProfilerTimer read GetItem write SetItem; default;
  end;

  TProfilerNotifyEvent = procedure(Sender: TObject; Timer: TProfilerTimer) of object;

  TProfiler = class(TComponent)
  private
    fTimers: TProfilerTimers;
    fFastLookup: TStringList;
    fAutoOutputDebug: Boolean;
    fOnTimerStart: TProfilerNotifyEvent;
    fOnTimerStop: TProfilerNotifyEvent;
    procedure SetTimers(Value: TProfilerTimers);
    function GetTimerByName(const TimerName: String): TProfilerTimer;
    function GetResolution: Extended;
  protected
    procedure Renamed(ATimer: TProfilerTimer);
    procedure DoTimerStart(Timer: TProfilerTimer); virtual;
    procedure DoTimerStop(Timer: TProfilerTimer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OutputDebugTimers;
    property Resolution: Extended read GetResolution;
    property TimerByName[const TimerName: String]: TProfilerTimer read GetTimerByName; default;
  published
    property AutoOutputDebug: Boolean read fAutoOutputDebug write fAutoOutputDebug default True;
    property Timers: TProfilerTimers read fTimers write SetTimers;
    property OnTimerStart: TProfilerNotifyEvent read fOnTimerStart write fOnTimerStart;
    property OnTimerStop: TProfilerNotifyEvent read fOnTimerStop write fOnTimerStop;
  end;

procedure Register;

implementation

uses
  SysUtils;

procedure Register;
begin
  RegisterComponents('Delphi Area', [TProfiler]);
end;

{ Constants }

const
  DefaultDisplayFormat = '#,##0.0';
  TimeUnitName: array[TTimeUnit] of String =
    ('ns', 'us', 'ms', 's', 'm', 'h');
  TimeUnitCoefficient: array[TTimeUnit] of Extended =
    (1000000000, 1000000, 1000, 1, 1/60, 1/3600);

{ Helper Stuffs }

var
  TickResType: (trUnknown, trHigh, trLow) = trUnknown;
  TickResolution: Extended = 0;
  TickStart: Int64 = 0;

procedure InitTickTimer;
var
  Frequency: Int64;
begin
  if TickResType = trUnknown then
  begin
    QueryPerformanceFrequency(Frequency);
    if Frequency <> 0 then
    begin
      TickResolution := 1 / Frequency;
      TickResType := trHigh;
      QueryPerformanceCounter(TickStart);
    end
    else
    begin
      TickResolution := 1 / 1000;
      TickResType := trLow;
      TickStart := GetTickCount;
    end;
  end;
end;

function GetCurrentTick: Int64;
var
  TickCurrent: Int64;
begin
  if TickResType = trHigh then
    QueryPerformanceCounter(TickCurrent)
  else
    TickCurrent := GetTickCount;
  Result := TickCurrent - TickStart;
end;

function TickToTimeUnit(const ATick: Int64; AUnit: TTimeUnit): Extended;
begin
  Result := ATick * TickResolution * TimeUnitCoefficient[AUnit];
end;

{ TProfilerTimer }

constructor TProfilerTimer.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  fTimeUnit := tuMillisecond;
  fDisplayFormat := DefaultDisplayFormat;
  Name := 'Timer #' + IntToStr(Index + 1);
end;

function TProfilerTimer.GetDisplayName: String;
begin
  Result := fName;
end;

function TProfilerTimer.GetFirstTime: Extended;
begin
  Result := TickToTimeUnit(fFirstTime, TimeUnit);
end;

function TProfilerTimer.GetLastTime: Extended;
begin
  Result := TickToTimeUnit(fLastTime, TimeUnit);
end;

function TProfilerTimer.GetAvgTime: Extended;
begin
  if TotalHits <> 0 then
    Result := TotalTime / TotalHits
  else
    Result := 0;
end;

function TProfilerTimer.GetMinTime: Extended;
begin
  Result := TickToTimeUnit(fMinTime, TimeUnit);
end;

function TProfilerTimer.GetMaxTime: Extended;
begin
  Result := TickToTimeUnit(fMaxTime, TimeUnit);
end;

function TProfilerTimer.GetTotalTime: Extended;
begin
  Result := TickToTimeUnit(fTotalTime, TimeUnit);
end;

function TProfilerTimer.GetAsText(TimeInfo: TTimeInfo): String;
var
  Value: Extended;
begin
  case TimeInfo of
    tiTotal: Value := TotalTime;
    tiAvg:   Value := AvgTime;
    tiFirst: Value := FirstTime;
    tiLast:  Value := LastTime;
    tiMin:   Value := MinTime;
    tiMax:   Value := MaxTime;
  else
    Result := GetAllText;
    Exit;
  end;
  Result := FormatFloat(DisplayFormat, Value) + ' ' + TimeUnitName[TimeUnit];
end;

function TProfilerTimer.GetAllText: String;
const
  NoHit    = '[%s.%s] No hits';
  OneHit   = '[%s.%s] 1 hit total %s';
  ManyHits = '[%s.%s] %u hits total %s, Avg: %s, '
           + 'First: %s, Last: %s, Min@%u: %s, Max@%u: %s';
begin
  if TotalHits = 0 then
    Result := Format(NoHit, [Profiler.Name, Name])
  else if TotalHits = 1 then
    Result := Format(OneHit, [Profiler.Name, Name, AsText[tiTotal]])
  else
    Result := Format(ManyHits, [Profiler.Name, Name, TotalHits,
      AsText[tiTotal], AsText[tiAvg], AsText[tiFirst], AsText[tiLast],
      MinHit, AsText[tiMin], MaxHit, AsText[tiMax]]);
end;

procedure TProfilerTimer.SetName(const Value: String);
begin
  if fName <> Value then
  begin
    fName := Value;
    Changed(False);
  end;
end;

function TProfilerTimer.GetProfiler: TProfiler;
begin
  Result := TProfilerTimers(Collection).Profiler;
end;

function TProfilerTimer.IsDisplayFormatStored: Boolean;
begin
  Result := (DisplayFormat <> DefaultDisplayFormat);
end;

procedure TProfilerTimer.Assign(Source: TPersistent);
begin
  if Source is TProfilerTimer then
    with TProfilerTimer(Source) do
    begin
      Self.Name := fName;
      Self.DisplayFormat := fDisplayFormat;
      Self.fFirstTime := fFirstTime;
      Self.fLastTime := fLastTime;
      Self.fMinHit := fMinHit;
      Self.fMinTime := fMinTime;
      Self.fMaxHit := fMaxHit;
      Self.fMaxTime := fMaxTime;
      Self.fTotalHits := fTotalHits;
      Self.fTotalTime := fTotalTime;
    end
  else
    inherited Assign(Source);
end;

procedure TProfilerTimer.Start;
begin
  Profiler.DoTimerStart(Self);
  fLastTime := GetCurrentTick;
end;

procedure TProfilerTimer.Stop;
begin
  fLastTime := GetCurrentTick - fLastTime;
  Inc(fTotalHits);
  fTotalTime := fTotalTime + fLastTime;
  if fTotalHits = 1 then
  begin
    fFirstTime := fLastTime;
    fMinTime := fLastTime;
    fMinHit := 1;
    fMaxTime := fLastTime;
    fMaxHit := 1;
  end
  else
  begin
    if fLastTime < fMinTime then
    begin
      fMinTime := fLastTime;
      fMinHit := fTotalHits;
    end;
    if fLastTime > fMaxTime then
    begin
      fMaxTime := fLastTime;
      fMaxHit := fTotalHits;
    end;
  end;
  Profiler.DoTimerStop(Self);
end;

procedure TProfilerTimer.Reset;
begin
  fFirstTime := 0;
  fLastTime := 0;
  fMinTime := 0;
  fMinHit := 0;
  fMaxTime := 0;
  fMaxHit := 0;
  fTotalHits := 0;
  fTotalTime := 0;
end;

{ TProfilerTimers }

constructor TProfilerTimers.Create(AOwner: TProfiler);
begin
  {$IFDEF COMPILER4_UP}
  inherited Create(AOwner, TProfilerTimer);
  {$ELSE}
  inherited Create(TProfilerTimer);
  fOwner := AOwner;
  {$ENDIF}
end;

function TProfilerTimers.GetProfiler: TProfiler;
begin
  {$IFDEF COMPILER4_UP}
  Result := TProfiler(GetOwner);
  {$ELSE}
  Result := fOwner;
  {$ENDIF}
end;

function TProfilerTimers.GetItem(Index: Integer): TProfilerTimer;
begin
  Result := TProfilerTimer(inherited Items[Index]);
end;

procedure TProfilerTimers.SetItem(Index: Integer; Value: TProfilerTimer);
begin
  inherited Items[Index].Assign(Value);
end;

function TProfilerTimers.Add: TProfilerTimer;
begin
  Result := TProfilerTimer(inherited Add);
end;

{$IFDEF COMPILER4_UP}
function TProfilerTimers.Insert(Index: Integer): TProfilerTimer;
begin
  Result := TProfilerTimer(inherited Insert(Index));
end;
{$ENDIF}

procedure TProfilerTimers.Update(Item: TCollectionItem);
begin
  Profiler.Renamed(TProfilerTimer(Item));
end;

{ TProfiler }

constructor TProfiler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fFastLookup := TStringList.Create;
  fFastLookup.Duplicates := dupIgnore;
  {$IFDEF COMPILER6_UP}
  fFastLookup.CaseSensitive := False;
  {$ENDIF}
  fFastLookup.Sorted := True;
  fTimers := TProfilerTimers.Create(Self);
  fAutoOutputDebug := True;
end;

destructor TProfiler.Destroy;
begin
  if fAutoOutputDebug then
    OutputDebugTimers;
  fTimers.Free;
  fFastLookup.Free;
  inherited Destroy;
end;

procedure TProfiler.Renamed(ATimer: TProfilerTimer);
var
  I: Integer;
begin
  if ATimer = nil then
  begin
    fFastLookup.Clear;
    for I := 0 to Timers.Count - 1 do
    begin
      ATimer := Timers[I];
      fFastLookup.AddObject(ATimer.Name, ATimer);
    end;
  end
  else
  begin
    for I := 0 to fFastLookup.Count - 1 do
    begin
      if fFastLookup.Objects[I] = ATimer then
      begin
        fFastLookup.Delete(I);
        fFastLookup.AddObject(ATimer.Name, ATimer);
        Break;
      end;
    end;
  end;
end;

procedure TProfiler.DoTimerStart(Timer: TProfilerTimer);
begin
  if Assigned(fOnTimerStart) then
    fOnTimerStart(Self, Timer);
end;

procedure TProfiler.DoTimerStop(Timer: TProfilerTimer);
begin
  if Assigned(fOnTimerStop) then
    fOnTimerStop(Self, Timer);
end;

function TProfiler.GetTimerByName(const TimerName: String): TProfilerTimer;
var
  Index: Integer;
begin
  Index := fFastLookup.IndexOf(TimerName);
  if Index < 0 then
  begin
    fTimers.BeginUpdate;
    try
      Result := fTimers.Add;
      Result.Name := TimerName;
    finally
      fTimers.EndUpdate;
    end;
  end
  else
    Result := TProfilerTimer(fFastLookup.Objects[Index]);
end;

procedure TProfiler.SetTimers(Value: TProfilerTimers);
begin
  fTimers.Assign(Value);
end;

function TProfiler.GetResolution: Extended;
begin
  Result := TickResolution;
end;

procedure TProfiler.OutputDebugTimers;
var
  I: Integer;
begin
  for I := 0 to fTimers.Count - 1 do
    OutputDebugString(PChar(Timers[I].AsText[tiAll]));
end;

initialization
  InitTickTimer;
end.
