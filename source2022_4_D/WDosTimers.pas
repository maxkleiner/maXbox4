
{*******************************************************}
{                                                       }
{       WDosX Delphi WDosX Component Library            }
{       WDOSX CTC and RTC Timer Control Unit            }
{                                                       }
{       for Delphi 4, 5 WDosX DOS-Extender              }
{       Copyright (c) 2000 by Immo Wache                }
{       e-mail: immo.wache@t-online.de                  }
{                                                       }
{*******************************************************}

{
  Version history:
    IWA 11/20/00 Version 1.1
    - TwdxCustomTimer
      New Property Messages: Boolean default True;
        When True, OnTimer events are generated.
        Set False to inhibit messages for fast
        interrupt timers (<10 ms) so the message queue
        will not overrun. Only OnTimerInterrupt events
        are generated.
}

unit WDosTimers;

interface

{$DEFINE DESIGNPACKAGE}

{$IFDEF DESIGNPACKAGE}
uses
  Messages, SysUtils, Classes, WDosResStrings;
{$ELSE}
uses
  WDosMessages, WDosSysUtils, WDosClasses, WDosInterrupts,
  WDosForms, WDosResStrings;
{$ENDIF}

type
  TIntFreq =(ifNone, if32768, if16384, if8192,
             if4096, if2048,  if1024,  if512,
             if256,  if128,   if64,    if32,
             if16,   if8,     if4,     if2);

  {$IFDEF DESIGNPACKAGE}
  DpmiPmVector = Int64;
  {$ENDIF}

const
  DInterval =1000;
  DEnabled =True;
  DIntFreq =if64;
  DMessages =True;

type
  TwdxCustomTimer = class (TComponent)
  private
    FElapsed: Cardinal;
    FEnabled: Boolean;
    FInterval: Cardinal;
    FMessages: Boolean;
    FOnTimer: TNotifyEvent;
    FOnTimerInterrupt: TNotifyEvent;
    function GetBaseInterval: LongInt; virtual; abstract;
    procedure SetEnabled(const Value: Boolean);
    procedure WMTimer(var Msg: TMessage); message WM_TIMER;
  protected
    procedure DoTimer;
    procedure DoTimerInterrupt;
    procedure LockIntTimer; virtual; abstract;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure Process(aInterval: LongInt);
    property BaseInterval: LongInt read GetBaseInterval;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default DEnabled;
    property Interval: Cardinal read FInterval write FInterval
        default DInterval;
    property Messages: Boolean read FMessages write FMessages default DMessages;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
    property OnTimerInterrupt: TNotifyEvent read FOnTimerInterrupt write
        FOnTimerInterrupt;
  end;

  TwdxTimer = class (TwdxCustomTimer)
  private
    function GetBaseInterval: LongInt; override;
  protected
    procedure LockIntTimer; override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TwdxRtcTimer = class (TwdxCustomTimer)
  private
    function GetBaseInterval: LongInt; override;
    function GetIntFreq: TIntFreq;
    procedure SetIntFreq(Value: TIntFreq);
  protected
    procedure LockIntTimer; override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  published
    property IntFreq: TIntFreq read GetIntFreq write SetIntFreq
        default DIntFreq;
  end;

  TCustomIntTimer = class (TObject)
  private
    FEnableCnt: Integer;
    FInterval: LongInt;
    FOverrun: Boolean;
    FRecursion: Boolean;
    FTimerList: TList;
  protected
    procedure BeforeDestroy; virtual; abstract;
    procedure DoClose; virtual; abstract;
    procedure DoOpen; virtual; abstract;
    procedure DoTimer;
    procedure RegisterTimer(aTimer: TwdxCustomTimer);
    procedure ResetOutput; virtual; abstract;
    procedure SetDisabled(Updating: Boolean);
    procedure UnRegisterTimer(aTimer: TwdxCustomTimer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Disable;
    procedure Enable;
    function Enabled: Boolean;
    property Interval: LongInt read FInterval write FInterval;
    property Overrun: Boolean read FOverrun write FOverrun;
  end;

  TIntTimer = class (TCustomIntTimer)
  private
    FInt28: DpmiPmVector;
  protected
    constructor CreateInstance(Dummy: Integer =0);
    class function AccessInstance(Request: Integer): TIntTimer;
    procedure DoClose; override;
    procedure DoOpen; override;
  public
    constructor Create;
    destructor Destroy; override;
    class function Instance: TIntTimer;
    class procedure ReleaseInstance;
  end;

  TRtcIntTimer = class (TCustomIntTimer)
  private
    FInt70: DpmiPmVector;
    FIntFreq: TIntFreq;
    FStatA: Byte;
    FStatB: Byte;
    procedure SetIntFreq(const Value: TIntFreq);
  protected
    constructor CreateInstance(Dummy: Integer = 0);
    class function AccessInstance(Request: Integer): TRtcIntTimer;
    procedure DoClose; override;
    procedure DoOpen; override;
  public
    constructor Create;
    destructor Destroy; override;
    class function Instance: TRtcIntTimer;
    class procedure ReleaseInstance;
    property IntFreq: TIntFreq read FIntFreq write SetIntFreq default DIntFreq;
  end;

{$IFNDEF DESIGNPACKAGE}
function RealNow: TDateTime;
{ RealNow find out actual date and time similar to Now but with higher
  precisition <1ms }
{$ENDIF}

function MsToDateTime(MilliSecond: LongInt): TDateTime;
{ MsToDateTime transforms an Integer value in milliseconds into TDateTime }

function DateTimeToMs(Time: TDateTime): LongInt;
{ DateTimeToMs transforms a time-content (the fraction) of an TDateTime value
  into an Integer value in milliseconds }

implementation

{$IFNDEF DESIGNPACKAGE}
uses
  WDosPorts;

const
  RTCAdrPort  =$70;
  RTCDataPort =$71;
  IntControl  =$A1;
  StatusA     =$0A;
  StatusB     =$0B;
  StatusC     =$0C;

function RTCRead(Adresse: Integer): Integer;
begin
  if (Adresse <0) or (Adresse >63) then
    RTCRead :=-1
  else
  begin
    Port[RTCAdrPort] :=Adresse;
    RTCRead :=Port[RTCDataPort];
  end;
end;

procedure RTCWrite(Adresse: Integer; Inhalt: Byte);
begin
  if (Adresse <0) or (Adresse >63) then
    Exit
  else
  begin
    Port[RTCAdrPort] :=Adresse;
    Port[RTCDataPort] :=Inhalt;
  end;
end;

procedure IntTime;
begin
  { enable interrupts }
  Port[$20]:=$20;
  asm
        PUSHF
        STI
  end;
  TIntTimer.Instance.DoTimer;
  asm
        POPF
  end;
end;

procedure RtcTime;
begin
  { enable interrupts }
  Port[$A0]:=$20;
  Port[$20]:=$20;
  RtcRead(StatusC);
  asm
        PUSHF
        STI
  end;
  TRtcIntTimer.Instance.DoTimer;
  asm
        POPF
  end;
end;

type
  TTimerMode =(tmTwo, tmTree);

var
  TimerMode: TTimerMode;

function GetTimeMode2: Word; assembler;
asm
        PUSH    EBX
        PUSHF
        CLI
        MOV     AL,0
        OUT     $43,AL
        IN      AL,$40
        MOV     BL,AL
        IN      AL,$40
        MOV     AH,AL
        MOV     AL,BL
        NOT     AX
        POPF
        POP     EBX
end;

function GetTimeMode3: Word; assembler;
asm
        PUSHF
        CLI
        MOV     AL,11100010B
        OUT     $43,AL
        JMP     @@1
@@1:    IN      AL,$40
        MOV     AH,AL
        JMP     @@2
@@2:    MOV     AL,00000000B
        OUT     $43,AL
        JMP     @@3
@@3:    IN      AL,$40
        MOV     DL,AL
        JMP     @@4
@@4:    IN      AL,$40
        MOV     DH,AL
        JMP     @@5
@@5:    MOV     AL,11100010B
        OUT     $43,AL
        JMP     @@6
@@6:    IN      AL,$40
        POPF
        NEG     DX
        XOR     AL,AH
        JNS     @@7
        TEST    DH,DH
        JS      @@7
        NOT     AH
@@7:    SHL     AH,1
        CMC
        RCR     DX,1
        MOV     AX,DX
end;

var
  LastTick: LongInt;
  RealDate: TDateTime;

function TickCount: LongInt; assembler;
asm
        PUSHF
        STI
        MOV     EAX,DWORD PTR[046CH]
        POPF
end;

procedure InitRealNow;
begin
  asm
        PUSHF
        STI
  end;
  LastTick :=TickCount;
  RealDate :=Date;
  asm
        POPF
  end;
end;

function RealNow: TDateTime;
var
  FirstTick: LongInt;
  SecondTick: LongInt;
  ATick: LongInt;
  CtcTimer: Word;
begin
  { determine date, BIOS tick count and CTC counter value }
  FirstTick :=TickCount;
  if TimerMode =tmTwo then
    CtcTimer :=GetTimeMode2
  else
    CtcTimer :=GetTimeMode3;
  SecondTick :=TickCount;
  { determine, wich BIOS tick count belongs to CTC count when tick count
    is changed; a high CTC count belongs to the first BIOS tick,
    a low count to the second one }
  if (SecondTick <>FirstTick) and (CtcTimer <$8000) then
    ATick :=SecondTick
  else
    ATick :=FirstTick;

  { check for date change. This line is the reason for, to call this function
    once (or more) in 24 hours, so it's save for a correct update of date
    within the function RealNow.
    The reason why for this behaivour is to avoid a DOS function call
    (via Date) so this function can save be used inside a interrupt routine. }
  if LastTick >ATick then
    RealDate :=RealDate +1;
  LastTick :=ATick;

  { transform value into TDateTime }
  Result :=6.357117428673142E-7 *(ATick +CtcTimer/$10000) +RealDate;
end;

procedure CheckTimerMode;
var
  Mode: Byte;
begin
  asm
        PUSHF
        MOV     AL,11100010B
        CLI
        OUT     $43,AL
        JMP     @@1
@@1:    IN      AL,$40
        AND     AL,$0E
        SHR     AL,1
        MOV     MODE,AL
        POPF
  end;
  if Mode =3 then
    TimerMode :=tmTree
  else if Mode =2 then
    TimerMode :=tmTwo
  else
  begin
    Writeln(STimerModeError);
    Halt(1);
  end;
end;
{$ENDIF}

const
  MSec =1.157407407407407E-8;

function MsToDateTime(MilliSecond: LongInt): TDateTime;
begin
  Result :=MilliSecond *MSec;
end;

function DateTimeToMs(Time: TDateTime): LongInt;
begin
  Result :=Round(Frac(Time) /MSec);
end;

{
************************************ TwdxCustomTimer ***************************
}
constructor TwdxCustomTimer.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FInterval :=DInterval;
  FMessages :=DMessages;
  {$IFNDEF DESIGNPACKAGE}
  if Assigned(Application) then
    Application.RegisterMessageObject(Self);
  {$ENDIF}
  Enabled :=DEnabled;
end;

destructor TwdxCustomTimer.Destroy;
begin
  Enabled :=False;
  {$IFNDEF DESIGNPACKAGE}
  if Assigned(Application) then
    Application.UnregisterMessageObject(Self);
  {$ENDIF}
  inherited Destroy;
end;

procedure TwdxCustomTimer.DoTimer;
begin
  if Assigned(FOnTimer) then FOnTimer(Self);
end;

procedure TwdxCustomTimer.DoTimerInterrupt;
begin
  if Assigned(FOnTimerInterrupt) then FOnTimerInterrupt(Self);
  {$IFNDEF DESIGNPACKAGE}
  if FMessages and Assigned(Application) then
    Application.PostMessage(Self, WM_TIMER, 0, 0);
  {$ENDIF}
end;

procedure TwdxCustomTimer.Process(aInterval: LongInt);
begin
  if not Enabled then Exit;
  Inc(FElapsed, aInterval);
  if FElapsed >Interval *1000 then
  begin
    DoTimerInterrupt;
    FElapsed :=FElapsed -Interval *1000;
    if FElapsed >Interval *1000 then FElapsed :=0;
  end;
end;

procedure TwdxCustomTimer.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    FElapsed :=0;
    LockIntTimer;
  end;
end;

procedure TwdxCustomTimer.WMTimer(var Msg: TMessage);
begin
  DoTimer;
end;

{
*************************************** TwdxTimer ******************************
}
constructor TwdxTimer.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  TIntTimer.Instance.RegisterTimer(Self);
end;

destructor TwdxTimer.Destroy;
begin
  TIntTimer.Instance.UnRegisterTimer(Self);
  inherited Destroy;
end;

function TwdxTimer.GetBaseInterval: LongInt;
begin
  Result :=TIntTimer.Instance.Interval;
end;

procedure TwdxTimer.LockIntTimer;
begin
  if Enabled then
    TIntTimer.Instance.Enable
  else
    TIntTimer.Instance.Disable;
end;

{
************************************** TwdxRtcTimer ****************************
}
constructor TwdxRtcTimer.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  TRtcIntTimer.Instance.RegisterTimer(Self);
end;

destructor TwdxRtcTimer.Destroy;
begin
  TRtcIntTimer.Instance.UnRegisterTimer(Self);
  inherited Destroy;
end;

function TwdxRtcTimer.GetBaseInterval: LongInt;
begin
  Result :=TRtcIntTimer.Instance.Interval;
end;

procedure TwdxRtcTimer.LockIntTimer;
begin
  if Enabled then
    TRtcIntTimer.Instance.Enable
  else
    TRtcIntTimer.Instance.Disable;
end;

function TwdxRtcTimer.GetIntFreq: TIntFreq;
begin
  Result :=TRtcIntTimer.Instance.IntFreq;
end;

procedure TwdxRtcTimer.SetIntFreq(Value: TIntFreq);
begin
  TRtcIntTimer.Instance.IntFreq :=Value;
end;

{
************************************ TCustomIntTimer ***************************
}
constructor TCustomIntTimer.Create;
begin
  inherited Create;
  FTimerList :=TList.Create;
end;

destructor TCustomIntTimer.Destroy;
begin
  FTimerList.Free;
  inherited Destroy;
end;

procedure TCustomIntTimer.Disable;
begin
  Dec(FEnableCnt);
  if FEnableCnt = 0 then SetDisabled(True);
end;

procedure TCustomIntTimer.DoTimer;
var
  I: Integer;
begin
  if FRecursion then
  begin
    FOverrun :=True;
    Exit;
  end;
  FRecursion :=True;
  { update all timers }
  for I :=0 to FTimerList.Count -1 do
    TwdxCustomTimer(FTimerList[I]).Process(Interval);
  FRecursion :=False;
end;

procedure TCustomIntTimer.Enable;
begin
  Inc(FEnableCnt);
  if FEnableCnt = 1 then SetDisabled(False);
end;

function TCustomIntTimer.Enabled: Boolean;
begin
  Result := (FEnableCnt <> 0);
end;

procedure TCustomIntTimer.RegisterTimer(aTimer: TwdxCustomTimer);
begin
  {$IFNDEF DESIGNPACKAGE}
  asm
        PUSHF
        STI
  end;
  {$ENDIF}
  FTimerList.Add(aTimer);
  {$IFNDEF DESIGNPACKAGE}
  asm
        POPF
  end;
  {$ENDIF}
end;

procedure TCustomIntTimer.SetDisabled(Updating: Boolean);
begin
  if Updating then DoClose else DoOpen;
end;

procedure TCustomIntTimer.UnRegisterTimer(aTimer: TwdxCustomTimer);
begin
  {$IFNDEF DESIGNPACKAGE}
  asm
        PUSHF
        STI
  end;
  {$ENDIF}
  FTimerList.Remove(aTimer);
  {$IFNDEF DESIGNPACKAGE}
  asm
        POPF
  end;
  {$ENDIF}
end;

{
*************************************** TIntTimer ******************************
}
constructor TIntTimer.Create;
begin
  inherited Create;
  raise Exception.CreateFmt(SAccessThroughInstanceOnlyError, [ClassName]);
end;

constructor TIntTimer.CreateInstance(Dummy: Integer =0);
begin
  inherited Create;
  Interval :=54925; { timer tick x 1000 }
end;

destructor TIntTimer.Destroy;
begin
  if Enabled then DoClose;
  if AccessInstance(0) = Self then AccessInstance(2);
  inherited Destroy;
end;

class function TIntTimer.AccessInstance(Request: Integer): TIntTimer;

  var FInstance: TIntTimer; // = nil;

begin
FInstance:= NIL;
  case Request of
    0 : ;
    1 : if not Assigned(FInstance) then FInstance := CreateInstance;
    2 : FInstance := nil;
  else
    raise Exception.CreateFmt(SRequestAccessInstanceError, [Request]);
  end;
  Result := FInstance;
end;

procedure TIntTimer.DoClose;
begin
  {$IFDEF DESIGNPACKAGE}
  FInt28 :=0;
  {$ELSE}
  SetIntVec(28, FInt28);
  {$ENDIF}
end;

procedure TIntTimer.DoOpen;
begin
  {$IFNDEF DESIGNPACKAGE}
  GetIntVec(28, FInt28);
  SetIntProc(28, @IntTime);
  {$ENDIF}
end;

class function TIntTimer.Instance: TIntTimer;
begin
  Result := AccessInstance(1);
end;

class procedure TIntTimer.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;

{
************************************** TRtcIntTimer ****************************
}
constructor TRtcIntTimer.Create;
begin
  inherited Create;
  raise Exception.CreateFmt(SAccessThroughInstanceOnlyError, [ClassName]);
end;

constructor TRtcIntTimer.CreateInstance(Dummy: Integer = 0);
begin
  inherited Create;
  IntFreq :=DIntFreq;
end;

destructor TRtcIntTimer.Destroy;
begin
  if Enabled then DoClose;
  if AccessInstance(0) = Self then AccessInstance(2);
  inherited Destroy;
end;

class function TRtcIntTimer.AccessInstance(Request: Integer): TRtcIntTimer;

  //const FInstance: TRtcIntTimer = nil;
    var FInstance: TRTCIntTimer; // = nil;


begin
  FInstance:= NIL;

  case Request of
    0 : ;
    1 : if not Assigned(FInstance) then FInstance := CreateInstance;
    2 : FInstance := nil;
  else
    raise Exception.CreateFmt(SRequestAccessInstanceError, [Request]);
  end;
  Result := FInstance;
end;

procedure TRtcIntTimer.DoClose;
  
  {$IFNDEF DESIGNPACKAGE}
  var
    Reg: Byte;
  {$ENDIF}
  
begin
  {$IFNDEF DESIGNPACKAGE}
  { disable RTC interrupt on interrupt controller }
  Reg :=Port[IntControl];
  Reg :=Reg or $01;
  Port[IntControl] :=Reg;

  { restore old RTC status }
  RtcWrite(StatusA, FStatA);
  RtcWrite(StatusB, FStatB);

  { restore old interrupt vector }
  SetIntVec($70, FInt70);
  {$ENDIF}
end;

procedure TRtcIntTimer.DoOpen;

  {$IFNDEF DESIGNPACKAGE}
  var
    Reg: Byte;
  {$ENDIF}

begin
  {$IFDEF DESIGNPACKAGE}
  FInt70 :=0;
  FStatA :=0;
  FStatB :=0;
  {$ELSE}
  { store old RTC status }
  FStatA :=RtcRead(StatusA);
  FStatB :=RtcRead(StatusB);

  { set interrupt frequence to new value }
  Reg :=FStatA and $F0;
  Reg :=Reg or Byte(FIntFreq);
  RtcWrite(StatusA, Reg);

  { enable cyclic interrupts }
  RtcWrite(StatusB, FStatB or $40);

  { redirect interrupt vector on own procedure }
  GetIntVec($70, FInt70);
  SetIntProc($70, @RtcTime);

  { enable RTC interrupt at interrupt controller }
  Reg :=Port[IntControl];
  Reg :=Reg and $FE;
  Port[IntControl] :=Reg;
  {$ENDIF}
end;

class function TRtcIntTimer.Instance: TRtcIntTimer;
begin
  Result := AccessInstance(1);
end;

class procedure TRtcIntTimer.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;

procedure TRtcIntTimer.SetIntFreq(const Value: TIntFreq);
  
  const
    IntervalVal: array[TIntFreq] of LongInt =
      (   0,     31,     61,    122,
        244,    488,    977,   1953,
       3906,   7812,  15625,  31250,
      62500, 125000, 250000, 500000);
  
begin
  if FIntFreq <> Value then
  begin
    if Enabled then DoClose;
    FIntFreq := Value;
    Interval :=IntervalVal[FIntFreq];
    if Enabled then DoOpen;
  end;
end;

initialization
  {$IFNDEF DESIGNPACKAGE}
  { determine actual CTC-Timer 0 mode }
  CheckTimerMode;
  { initialize real time calculation }
  InitRealNow;
  {$ENDIF}
  //TIntTimer.Instance;
  //TRtcIntTimer.Instance;

finalization
  //TIntTimer.ReleaseInstance;
  //TRtcIntTimer.ReleaseInstance;
end.
