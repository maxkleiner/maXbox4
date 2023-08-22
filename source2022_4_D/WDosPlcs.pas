unit WDosPlcs;

interface

  {$DEFINE DESIGNPACKAGE}

uses
  SysUtils, Classes, WDosPlcUtils;

const
  DWatchdogTime =100; { default value for TwdxPlc.WatchdogTime }

type
  TPlcMode =(pmoInit, pmoHalt, pmoRun, pmoError);

  TCustomInOut =class;
  TCustomPetriNet =class;
  TInOuts =array[TInOutNo] of TCustomInOut;
  TInOutData =array[TInOutNo] of TIoData;
  TInOutStates =array[TInOutNo] of TInOutState;
  TInOutErrorCodes =array[TInOutNo] of TErrorCode;

  TPetriNetEvent = procedure (Sender: TObject; aState: Integer) of object;
  TPetriNetStateCtrl = procedure (Sender: TObject; var aState: Integer) of object;
  TErrorEvent = procedure (Sender: TObject; aErrorCode: TErrorCode) of object;

  TwdxPlc = class (TComponent)
  private
    FAfterInput: TNotifyEvent;
    FBeforeOutput: TNotifyEvent;
    FDebug: Boolean;
    FErrorCode: TErrorCode;
    FInOutData: TInOutData;
    FInOutErrorCodes: TInOutErrorCodes;
    FInOuts: TInOuts;
    FInOutStates: TInOutStates;
    FLastTime: TDateTime;
    FMaxCycleTime: TDateTime;
    FMinCycleTime: TDateTime;
    FMode: TPlcMode;
    FOnDebug: TNotifyEvent;
    FOnInOutReset: TNotifyEvent;
    FOnWatchdog: TNotifyEvent;
    FPetriNetList: TList;
    FWatchdog: Boolean;
    FWatchdogFlag: Boolean;
    FWatchdogTime: TDateTime;
    function GetBit(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; aBitNo: TBitNo): Boolean;
    function GetBusBit(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: Byte; 
        aBitNo: TBitNo): Boolean;
    function GetBusByt(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: 
        Byte): Byte;
    function GetByt(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte): Byte;
    function GetIo(Index: TBitAddr): Boolean;
    function GetIoByt(Index: TByteAddr): Byte;
    function GetWatchdogTime: LongInt;
    procedure SetBit(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; aBitNo: TBitNo; Value:
        Boolean);
    procedure SetBusBit(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: Byte;
        aBitNo: TBitNo; Value: Boolean);
    procedure SetBusByt(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: Byte;
        Value: Byte);
    procedure SetByt(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; Value: Byte);
    procedure SetIo(Index: TBitAddr; Value: Boolean);
    procedure SetIoByt(Index: TByteAddr; Value: Byte);
    procedure SetRBit(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; aBitNo: TBitNo; Value: 
        Boolean);
    procedure SetRBusBit(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: 
        Byte; aBitNo: TBitNo; Value: Boolean);
    procedure SetSBit(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; aBitNo: TBitNo; Value: 
        Boolean);
    procedure SetSBusBit(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: 
        Byte; aBitNo: TBitNo; Value: Boolean);
    procedure SetWatchdogTime(Value: LongInt);
  protected
    procedure CheckCycleTime;
    procedure DoAfterInput;
    procedure DoBeforeOutput;
    procedure DoDebug; virtual;
    procedure DoInOutReset;
    procedure DoWatchdog;
    function InOutAvailable(aInOutNo: TInOutNo): Boolean;
    function InOutInErrorMode: Boolean;
    procedure RegisterInOut(aInOut: TCustomInOut);
    procedure RegisterPetriNet(aPetriNet: TCustomPetriNet);
    procedure UnregisterInOut(aInOut: TCustomInOut);
    procedure UnRegisterPetriNet(aPetriNet: TCustomPetriNet);
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearInOutData;
    procedure Error(aErrorCode: TErrorCode);
    procedure Halt;
    procedure Process;
    procedure Reset;
    procedure ResetCycleTimes;
    procedure ResumeTimer(var Timer: TDateTime);
    procedure Run;
    function StartTimer(Delay: LongInt): TDateTime;
    function StartTimerDateTime(Delay: TDateTime): TDateTime;
    procedure StopTimer(var Timer: TDateTime);
    function TimeOut(Timer: TDateTime): Boolean;
    procedure TimerProcess;
    function InOutState(InOutNo: TInOutNo): TInOutState;
    function InOutErrorCode(InOutNo: TInOutNo):TErrorCode;
    property Bit[aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; aBitNo: TBitNo]: Boolean
        read GetBit write SetBit;
    property BusBit[aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: Byte; 
        aBitNo: TBitNo]: Boolean read GetBusBit write SetBusBit;
    property BusByt[aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: Byte]: 
        Byte read GetBusByt write SetBusByt;
    property Byt[aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte]: Byte read GetByt write 
        SetByt;
    property ErrorCode: TErrorCode read FErrorCode;
{
    property InOutErrorCodes: TInOutErrorCodes read FInOutErrorCodes write
        FInOutErrorCodes;
    property InOutStates: TInOutStates read FInOutStates write FInOutStates;
}
    property Io[Index: TBitAddr]: Boolean read GetIo write SetIo; default;
    property IoByt[Index: TByteAddr]: Byte read GetIoByt write SetIoByt;
    property MaxCycleTime: TDateTime read FMaxCycleTime;
    property MinCycleTime: TDateTime read FMinCycleTime;
    property Mode: TPlcMode read FMode;
    property RBit[aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; aBitNo: TBitNo]: Boolean
        write SetRBit;
    property RBusBit[aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: Byte;
        aBitNo: TBitNo]: Boolean write SetRBusBit;
    property SBit[aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; aBitNo: TBitNo]: Boolean
        write SetSBit;
    property SBusBit[aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: Byte;
        aBitNo: TBitNo]: Boolean write SetSBusBit;
  published
    property AfterInput: TNotifyEvent read FAfterInput write FAfterInput;
    property BeforeOutput: TNotifyEvent read FBeforeOutput write FBeforeOutput;
    property Debug: Boolean read FDebug write FDebug;
    property OnDebug: TNotifyEvent read FOnDebug write FOnDebug;
    property OnInOutReset: TNotifyEvent read FOnInOutReset write FOnInOutReset;
    property OnWatchdog: TNotifyEvent read FOnWatchdog write FOnWatchdog;
    property Watchdog: Boolean read FWatchdog write FWatchdog;
    property WatchdogTime: LongInt read GetWatchdogTime write SetWatchdogTime default 
        DWatchdogTime;
  end;
  
  TCustomInOut = class (TComponent)
  private
    FActive: Boolean;
    FAfterClose: TNotifyEvent;
    FBeforeOpen: TNotifyEvent;
    FError: Boolean;
    FErrorCode: TErrorCode;
    FInOutNo: TInOutNo;
    FOnError: TErrorEvent;
    FOnErrorTimer: TErrorEvent;
    FOnReset: TNotifyEvent;
    FPlc: TwdxPlc;
    FState: TInOutState;
    FStreamedActive: Boolean;
    procedure Halt;
    procedure Reset;
    procedure Run;
    procedure SetActive(Value: Boolean);
    procedure SetInOutNo(Value: TInOutNo);
    procedure SetPlc(Value: TwdxPlc);
  protected
    procedure BeforeDestroy; virtual;
    procedure DoAfterClose;
    procedure DoBeforeOpen;
    procedure DoClose; virtual; abstract;
    procedure DoError;
    procedure DoErrorTimer;
    procedure DoOpen; virtual; abstract;
    procedure DoReset;
    procedure Error(aErrorCode: TErrorCode);
    procedure Loaded; override;
    procedure Notification(aComponent: TComponent; Operation: TOperation); override;
    procedure Process; virtual;
    procedure ProcessInput(var IoData: TIoData); virtual; abstract;
    procedure ProcessOutput(var IoData: TIoData); virtual; abstract;
    procedure ResetOutput; virtual; abstract;
    procedure SetState(Value: TInOutState); virtual;
    procedure UpdateState(aState: TInOutState); virtual;
  public
    destructor Destroy; override;
    procedure Close;
    procedure Open;
    property ErrorCode: TErrorCode read FErrorCode;
    property State: TInOutState read FState;
  published
    property Active: Boolean read FActive write SetActive;
    property AfterClose: TNotifyEvent read FAfterClose write FAfterClose;
    property BeforeOpen: TNotifyEvent read FBeforeOpen write FBeforeOpen;
    property InOutNo: TInOutNo read FInOutNo write SetInOutNo;
    property OnError: TErrorEvent read FOnError write FOnError;
    property OnErrorTimer: TErrorEvent read FOnErrorTimer write FOnErrorTimer;
    property OnReset: TNotifyEvent read FOnReset write FOnReset;
    property Plc: TwdxPlc read FPlc write SetPlc;
  end;
  
  TCustomPetriNet = class (TComponent)
  private
    FOnProcess: TNotifyEvent;
    FOnStateChanged: TPetriNetEvent;
    FPlc: TwdxPlc;
    FState: Integer;
    FStateChanged: Boolean;
  protected
    procedure AtState; virtual;
    procedure BeginState; virtual;
    procedure AtProcess; virtual;
    procedure DoProcess;
    procedure DoStateChanged(Sender: TObject; aState: Integer);
    procedure EndState; virtual;
    procedure Notification(aComponent: TComponent; Operation: TOperation); override;
    procedure Process; virtual;
    procedure Reset; virtual;
    procedure ReadInputs; virtual;
    procedure WriteOutputs; virtual;
    procedure ClearValues; virtual;
    procedure SetPlc(Value: TwdxPlc);
    procedure SetState(Value: Integer);
    procedure StateCtrl(var aState: Integer); virtual; abstract;
    procedure TimerProcess;
    property OnProcess: TNotifyEvent read FOnProcess write FOnProcess;
    property OnStateChanged: TPetriNetEvent read FOnStateChanged write FOnStateChanged;
  public
    destructor Destroy; override;
    property State: Integer read FState write SetState;
  published
    property Plc: TwdxPlc read FPlc write SetPlc;
  end;
  
  TwdxPetriNet = class (TCustomPetriNet)
  private
    FInp01: TBitAddr;
    FInp02: TBitAddr;
    FInp03: TBitAddr;
    FInp04: TBitAddr;
    FInp05: TBitAddr;
    FInp06: TBitAddr;
    FInp07: TBitAddr;
    FInp08: TBitAddr;
    FInp09: TBitAddr;
    FInp10: TBitAddr;
    FInp11: TBitAddr;
    FInp12: TBitAddr;
    FInp13: TBitAddr;
    FInp14: TBitAddr;
    FInp15: TBitAddr;
    FInp16: TBitAddr;
    FOnAtState: TPetriNetEvent;
    FOnBeginState: TPetriNetEvent;
    FOnEndState: TPetriNetEvent;
    FOnStateCtrl: TPetriNetStateCtrl;
    FOut01: TBitAddr;
    FOut02: TBitAddr;
    FOut03: TBitAddr;
    FOut04: TBitAddr;
    FOut05: TBitAddr;
    FOut06: TBitAddr;
    FOut07: TBitAddr;
    FOut08: TBitAddr;
    FOnReadInputs: TPetriNetEvent;
    FOnWriteOutputs: TPetriNetEvent;
    FOnClearValues: TPetriNetEvent;
  protected
    procedure AtState; override;
    procedure BeginState; override;
    procedure EndState; override;
    procedure ReadInputs; override;
    procedure WriteOutputs; override;
    procedure ClearValues; override;
    procedure StateCtrl(var aState: Integer); override;
  published
    property Inp01: TBitAddr read FInp01 write FInp01;
    property Inp02: TBitAddr read FInp02 write FInp02;
    property Inp03: TBitAddr read FInp03 write FInp03;
    property Inp04: TBitAddr read FInp04 write FInp04;
    property Inp05: TBitAddr read FInp05 write FInp05;
    property Inp06: TBitAddr read FInp06 write FInp06;
    property Inp07: TBitAddr read FInp07 write FInp07;
    property Inp08: TBitAddr read FInp08 write FInp08;
    property Inp09: TBitAddr read FInp09 write FInp09;
    property Inp10: TBitAddr read FInp10 write FInp10;
    property Inp11: TBitAddr read FInp11 write FInp11;
    property Inp12: TBitAddr read FInp12 write FInp12;
    property Inp13: TBitAddr read FInp13 write FInp13;
    property Inp14: TBitAddr read FInp14 write FInp14;
    property Inp15: TBitAddr read FInp15 write FInp15;
    property Inp16: TBitAddr read FInp16 write FInp16;
    property OnAtState: TPetriNetEvent read FOnAtState write FOnAtState;
    property OnBeginState: TPetriNetEvent read FOnBeginState
        write FOnBeginState;
    property OnEndState: TPetriNetEvent read FOnEndState write FOnEndState;
    property OnClearValues: TPetriNetEvent read FOnClearValues
        write FOnClearValues;
    property OnReadInputs: TPetriNetEvent read FOnReadInputs
        write FOnReadInputs;
    property OnWriteOutputs: TPetriNetEvent read FOnWriteOutputs
        write FOnWriteOutputs;
    property OnProcess;
    property OnStateChanged;
    property OnStateCtrl: TPetriNetStateCtrl read FOnStateCtrl
        write FOnStateCtrl;
    property Out01: TBitAddr read FOut01 write FOut01;
    property Out02: TBitAddr read FOut02 write FOut02;
    property Out03: TBitAddr read FOut03 write FOut03;
    property Out04: TBitAddr read FOut04 write FOut04;
    property Out05: TBitAddr read FOut05 write FOut05;
    property Out06: TBitAddr read FOut06 write FOut06;
    property Out07: TBitAddr read FOut07 write FOut07;
    property Out08: TBitAddr read FOut08 write FOut08;
  end;
  
implementation

uses
  WDosTimers;

{
**************************************** TwdxPlc *****************************************
}
constructor TwdxPlc.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  {create list of Petri nets }
  FPetriNetList :=TList.Create;
  { default values }
  FWatchdogTime :=MsToDateTime(DWatchdogTime);
  { initialize cycle time measurement }
  ResetCycleTimes;
end;

destructor TwdxPlc.Destroy;
begin
  {Liste der Petri-Netze freigeben}
  FPetriNetList.Free;
  inherited Destroy;
end;

function TwdxPlc.InOutState(InOutNo: TInOutNo): TInOutState;
begin
  Result :=FInOutStates[InOutNo];
end;

function TwdxPlc.InOutErrorCode(InOutNo: TInOutNo):TErrorCode;
begin
  Result :=FInOutErrorCodes[InOutNo];
end;

procedure TwdxPlc.CheckCycleTime;
var
  ThisTime: TDateTime;
  CycleTime: TDateTime;
begin
  {$IFDEF DESIGNPACKAGE}
  ThisTime :=Now;
  {$ELSE}
  ThisTime :=RealNow;
  {$ENDIF}
  { im ersten Zyklus keinen Vergleich durchführen }
  if FLastTime <>0.0 then
  begin
    { aktuelle Zykluszeit ermitteln }
    CycleTime :=ThisTime -FLastTime;
    { minimale und maximale Zykluszeit aktualisieren }
    if CycleTime >FMaxCycleTime then
      FMaxCycleTime :=CycleTime;
    if CycleTime <FMinCycleTime then
      FMinCycleTime :=CycleTime;
    { Prüfung, ob Zyklus-Überwachung aktiv ist }
    if FWatchdog then
    begin
      { Prüfung, ob maximale Zykluszeit überschritten wurde }
      if CycleTime >FWatchdogTime then
      begin
        FWatchdogFlag :=True;
        { Plc in Fehler-Zustand Zykluszeitüberschreitung setzen }
        Error(ecmWatchdogTime);
      end;
    end;
  end;
  { aktuelle Zeit für nächsten Zyklusvergleich speichern }
  FLastTime :=ThisTime;
end;

procedure TwdxPlc.ClearInOutData;
begin
  FillChar(FInOutData, SizeOf(FInOutData), 0);
end;

procedure TwdxPlc.DoAfterInput;
begin
  if Assigned(FAfterInput) then FAfterInput(Self);
end;

procedure TwdxPlc.DoBeforeOutput;
begin
  if Assigned(FBeforeOutput) then FBeforeOutput(Self);
end;

procedure TwdxPlc.DoDebug;
begin
  if Assigned(FOnDebug) then FOnDebug(Self);
end;

procedure TwdxPlc.DoInOutReset;
begin
  if Assigned(FOnInOutReset) then FOnInOutReset(Self);
end;

procedure TwdxPlc.DoWatchdog;
begin
  if Assigned(FOnWatchdog) then FOnWatchdog(Self);
end;

procedure TwdxPlc.Error(aErrorCode: TErrorCode);
var
  I: Integer;
begin
  FErrorCode :=aErrorCode;
  { set all input/output devices to halt }
  for I := 0 to InOutNum -1 do
    if Assigned(FInOuts[I]) then
      FInOuts[I].Halt;
  { set mode }
  FMode :=pmoError;
end;

procedure TwdxPlc.Halt;
var
  I: Integer;
begin
  { Halt-Mode setzen }
  if FMode =pmoRun then
  begin
    {alle angeschlossenen Bus-Module in den Halt-Mode setzen}
    for I := 0 to InOutNum -1 do
      if Assigned(FInOuts[I]) then
        FInOuts[I].Halt;
    { Mode setzen }
    FMode :=pmoHalt;
  end;
end;

function TwdxPlc.InOutAvailable(aInOutNo: TInOutNo): Boolean;
begin
  { check for input/output device available
    True = input/output device number is available
    False = input/output device number exists }
  Result :=FInOuts[aInOutNo] =nil;
end;

function TwdxPlc.InOutInErrorMode: Boolean;
var
  I: Integer;
begin
  Result :=True;
  for I := 0 to InOutNum -1 do
    if Assigned(FInOuts[I]) then
      if FInOuts[I].State =iosError then Exit;
  Result :=False;
end;

procedure TwdxPlc.Process;
var
  I: Integer;
begin
  { Test, ob maximale Zykluszeit überschritten wurde }
  if FWatchdogFlag then
  begin
    DoWatchdog;
    FWatchdogFlag :=False;
  end;
  { update all input/output devices }
  for I := 0 to InOutNum -1 do
    if Assigned(FInOuts[I]) then
      with FInOuts[I] do
        if Active then Process;
  { update all Petri nets }
  for I := 0 to FPetriNetList.Count -1 do
    TCustomPetriNet(FPetriNetList[I]).Process;
end;

procedure TwdxPlc.RegisterInOut(aInOut: TCustomInOut);
var
  aInOutNo: TInOutNo;
begin
  aInOutNo :=aInOut.InOutNo;
  {prüfen, ob Plc-Nr. bereits belegt ist}
  if (aInOut =nil) or (FInOuts[aInOutNo] =nil) then
    FInOuts[aInOutNo] :=aInOut
  else
    raise Exception.Create(Format('E/A-Gerätenummer %d ist schon belegt',
        [aInOutNo]));
end;

procedure TwdxPlc.RegisterPetriNet(aPetriNet: TCustomPetriNet);
begin
  FPetriNetList.Add(aPetriNet);
end;

procedure TwdxPlc.Reset;
var
  I: Integer;
begin
  { Error-Mode verlassen }
  if FMode =pmoError then
  begin
    { reset all input/output devices }
    for I := 0 to InOutNum -1 do
      if Assigned(FInOuts[I]) then
        FInOuts[I].Reset;
    { reset all Petri nets }
    for I := 0 to FPetriNetList.Count -1 do
      TCustomPetriNet(FPetriNetList[I]).Reset;
    { init mode and error code }
    FMode :=pmoInit;
    FErrorCode :=ecmNoError;
    { initialize cycle time measurement }
    ResetCycleTimes;
    { clear all input/output data }
    ClearInOutData;
  end;
end;

procedure TwdxPlc.ResetCycleTimes;
begin
  FMaxCycleTime :=0.0;
  FMinCycleTime :=1.7E308; { maximum value of double }
  FWatchdogFlag :=False;
end;

procedure TwdxPlc.ResumeTimer(var Timer: TDateTime);
begin
  Timer :=Timer +FLastTime;
end;

procedure TwdxPlc.Run;
var
  I: Integer;
begin
  {Run-Mode setzen}
  if FMode in[pmoInit, pmoHalt] then
  begin
    { kontrollieren, daß keine Plc im Fehler-Mode ist}
    if not InOutInErrorMode then
    begin
      {alle angeschlossenen Bus-Module in den Run-Mode setzen}
      for I := 0 to InOutNum -1 do
        if Assigned(FInOuts[I]) then FInOuts[I].Run;
    end;
    { Mode setzen }
    FMode :=pmoRun;
  end;
end;

function TwdxPlc.StartTimer(Delay: LongInt): TDateTime;
begin
  Result :=FLastTime +MsToDateTime(Delay);
end;

function TwdxPlc.StartTimerDateTime(Delay: TDateTime): TDateTime;
begin
  Result :=FLastTime +Delay;
end;

procedure TwdxPlc.StopTimer(var Timer: TDateTime);
begin
  Timer :=Timer -FLastTime;
end;

function TwdxPlc.TimeOut(Timer: TDateTime): Boolean;
  
  { Das Ergebnis der Funktion TimeOut ist wahr, wenn der angegebene Timer
    abgelauften ist, andernfalls ist das Ergebnis falsch }
  
begin
  Result :=FLastTime >Timer;
end;

procedure TwdxPlc.TimerProcess;
var
  I: Integer;
begin
  { process cycle time measurement }
  CheckCycleTime;
  { get values from all input devices }
  for I := 0 to InOutNum -1 do
    if Assigned(FInOuts[I]) then
      with FInOuts[I] do
      begin
        if Active then ProcessInput(FInOutData[I]);
        { Zustand und Status der Plc abfragen }
        FInOutStates[I] :=State;
        FInOutErrorCodes[I] :=ErrorCode;
      end;
  { Ereignis AfterInput }
  DoAfterInput;
  if FDebug then
    { call OnDebug to read and write input/output data }
    DoDebug
  else
    { alle Petri-Netze aktualisieren }
    for I := 0 to FPetriNetList.Count -1 do
      TCustomPetriNet(FPetriNetList[I]).TimerProcess;
  { Ereignis BeforeOutput }
  DoBeforeOutput;
  { send values to all output devices }
  for I := 0 to InOutNum -1 do
    if Assigned(FInOuts[I]) then
      with FInOuts[I] do
        if Active then ProcessOutput(FInOutData[I]);
end;

procedure TwdxPlc.UnregisterInOut(aInOut: TCustomInOut);
begin
  FInOuts[aInOut.InOutNo] :=nil;
end;

procedure TwdxPlc.UnRegisterPetriNet(aPetriNet: TCustomPetriNet);
begin
  FPetriNetList.Remove(aPetriNet);
end;

function TwdxPlc.GetBit(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; aBitNo: TBitNo): 
    Boolean;
begin
  Result :=(aIo in [NE, NA]) xor
      (aBitNo in FInOutData[aInOutNo, aByteNo, aIo in [A, NA]]);
end;

procedure TwdxPlc.SetBit(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; aBitNo: TBitNo; 
    Value: Boolean);
begin
  if (aIo in [NE, NA]) xor Value then
    Include(FInOutData[aInOutNo, aByteNo, aIo in [A, NA]], aBitNo)
  else
    Exclude(FInOutData[aInOutNo, aByteNo, aIo in [A, NA]], aBitNo);
end;

function TwdxPlc.GetBusBit(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: 
    Byte; aBitNo: TBitNo): Boolean;
begin
  aByteNo :=aByteNo and $07 or aStation shl 3;
  Result :=Bit[aIo, aInOutNo, aByteNo, aBitNo];
end;

procedure TwdxPlc.SetBusBit(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo:
    Byte; aBitNo: TBitNo; Value: Boolean);
begin
  aByteNo :=aByteNo and $07 or aStation shl 3;
  Bit[aIo, aInOutNo, aByteNo, aBitNo] :=Value;
end;

function TwdxPlc.GetBusByt(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: 
    Byte): Byte;
begin
  aByteNo :=aByteNo and $07 or aStation shl 3;
  Result :=Byt[aIo, aInOutNo, aByteNo];
end;

procedure TwdxPlc.SetBusByt(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: 
    Byte; Value: Byte);
begin
  aByteNo :=aByteNo and $07 or aStation shl 3;
  Byt[aIo, aInOutNo, aByteNo] :=Value;
end;

function TwdxPlc.GetByt(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte): Byte;
begin
  {Liefert das Eingangs- bzw. Ausgangs-Byte zurück.
   aInOut bestimmt, ob Ein- oder Ausgang gelesen wird.}
  Result :=Byte(FInOutData[aInOutNo, aByteNo, aIo in [A, NA]]);
  if aIo in [NE, NA] then Result :=not Result;
end;

procedure TwdxPlc.SetByt(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; Value: Byte);
begin
  {Setzt das Eingangs- bzw. Ausgangs-Byte.
   aInOut bestimmt, ob Ein- oder Ausgang beschrieben wird.}
  if aIo in [NE, NA] then Value :=not Value;
  Byte(FInOutData[aInOutNo, aByteNo, aIo in [A, NA]]) :=Value;
end;

function TwdxPlc.GetIo(Index: TBitAddr): Boolean;
var
  IndexAddr: TBitAddrRec absolute Index;
begin
  with IndexAddr do
    Result :=(akNot in Kind) xor
        (Byte(Kind) and $07 in FInOutData[InOutNo, ByteNo, akOut in Kind]);
end;

procedure TwdxPlc.SetIo(Index: TBitAddr; Value: Boolean);
var
  IndexAddr: TBitAddrRec absolute Index;
begin
  with IndexAddr do
    if (akNot in Kind) xor Value then
      Include(FInOutData[InOutNo, ByteNo, akOut in Kind], Byte(Kind) and $07)
    else
      Exclude(FInOutData[InOutNo, ByteNo, akOut in Kind], Byte(Kind) and $07);
end;

function TwdxPlc.GetIoByt(Index: TByteAddr): Byte;
var
  IndexAddr: TByteAddrRec absolute Index;
begin
  with IndexAddr do
  begin
    Result :=Byte(FInOutData[TInOutNo(Byte(Kind) and $07), ByteNo,
        akOut in Kind]);
    if akNot in Kind then Result :=not Result;
  end;
end;

procedure TwdxPlc.SetIoByt(Index: TByteAddr; Value: Byte);
var
  IndexAddr: TByteAddrRec absolute Index;
begin
  with IndexAddr do
  begin
    if (akNot in Kind) then Value :=not Value;
    Byte(FInOutData[TInOutNo(Byte(Kind) and $07), ByteNo, akOut in Kind])
        :=Value;
  end;
end;

procedure TwdxPlc.SetRBit(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; aBitNo: TBitNo; 
    Value: Boolean);
begin
  if Value then
    Bit[aIo, aInOutNo, aByteNo, aBitNo] :=False;
end;

procedure TwdxPlc.SetRBusBit(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: 
    Byte; aBitNo: TBitNo; Value: Boolean);
begin
  if Value then
    BusBit[aIo, aInOutNo, aStation, aByteNo, aBitNo] :=False;
end;

procedure TwdxPlc.SetSBit(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte; aBitNo: TBitNo; 
    Value: Boolean);
begin
  if Value then
    Bit[aIo, aInOutNo, aByteNo, aBitNo] :=True;
end;

procedure TwdxPlc.SetSBusBit(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo; aByteNo: 
    Byte; aBitNo: TBitNo; Value: Boolean);
begin
  if Value then
    BusBit[aIo, aInOutNo, aStation, aByteNo, aBitNo] :=True;
end;

function TwdxPlc.GetWatchdogTime: LongInt;
begin
  Result :=DateTimeToMs(FWatchdogTime);
end;

procedure TwdxPlc.SetWatchdogTime(Value: LongInt);
begin
  FWatchdogTime :=MsToDateTime(Value);
end;

{
************************************** TCustomInOut **************************************
}
destructor TCustomInOut.Destroy;
begin
  { bei übergeordneter Plc abmelden }
  Plc :=nil;
  { Plc schließen und alle Ausgänge löschen }
  Close;
  { adaptierte Komponenten zerstören }
  BeforeDestroy;
  inherited Destroy;
end;

procedure TCustomInOut.BeforeDestroy;
begin
  { do nothing }
end;

procedure TCustomInOut.Close;
begin
  if FActive then
  begin
    { alle Ausgänge löschen }
    ResetOutput;
    { PLC schließen }
    DoClose;
    { set input/output device into init state }
    SetState(iosInit);
    { Feld Active aktualisieren }
    FActive :=False;
    {Ereignis AfterClose auslösen}
    DoAfterClose;
  end;
end;

procedure TCustomInOut.DoAfterClose;
begin
  if Assigned(FAfterClose) then FAfterClose(Self);
end;

procedure TCustomInOut.DoBeforeOpen;
begin
  if Assigned(FBeforeOpen) then FBeforeOpen(Self);
end;

procedure TCustomInOut.DoError;
begin
  { Ereignis signalisiert Übergang in den Error-Mode beim Process
    der Komponente }
  if Assigned(FOnError) then FOnError(Self, ErrorCode);
end;

procedure TCustomInOut.DoErrorTimer;
begin
  { Ereignis signalisiert unmittelbar den Übergang in den Error-Mode }
  if Assigned(FOnErrorTimer) then FOnErrorTimer(Self, ErrorCode);
  { Merker für Ereignis außerhalb der TimerProcess-Routine setzen }
  FError :=True;
end;

procedure TCustomInOut.DoReset;
begin
  { Ereignis signalisiert Übergang in den Halt-Mode nach Reset }
  if Assigned(FOnReset) then FOnReset(Self);
end;

procedure TCustomInOut.Error(aErrorCode: TErrorCode);
begin
  { Methode ist Protected, da die Plc nur von sich aus in den Error-Mode
    wechseln darf }
  FErrorCode :=aErrorCode;
  { Error-Mode setzen }
  SetState(iosError);
end;

procedure TCustomInOut.Halt;
begin
  { Halt-Mode setzen }
  if FState =iosRun then
    SetState(iosHalt);
end;

procedure TCustomInOut.Loaded;
begin
  inherited Loaded;
  Active :=FStreamedActive;
end;

procedure TCustomInOut.Notification(aComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(aComponent, Operation);
  if (Operation =opRemove) and (aComponent =FPlc) then
    Plc :=nil;
end;

procedure TCustomInOut.Open;
begin
  if not FActive then
  begin
    { Ereignis BeforeOpen auslösen }
    DoBeforeOpen;
    { Plc öffnen }
    DoOpen;
    { Feld Active aktualisieren }
    FActive :=True;
    { set input/output device into halt state }
    SetState(iosHalt);
  end;
end;

procedure TCustomInOut.Process;
begin
  if FError then
  begin
    FError :=False;
    DoError;
  end;
end;

procedure TCustomInOut.Reset;
begin
  { leave error state }
  if FState =iosError then
  begin
    SetState(iosHalt);
    { Fehlermeldung löschen }
    FErrorCode :=ecsNoError;
    { Ereignis: 'Reset durchgeführt' auslösen }
    DoReset;
  end;
end;

procedure TCustomInOut.Run;
begin
  {set run state }
  if FState =iosHalt then
    SetState(iosRun);
end;

procedure TCustomInOut.SetState(Value: TInOutState);
begin
  if FState <> Value then
  begin
    FState :=Value;
    UpdateState(Value);
    { fire event if device comes into error state }
    if Value =iosError then
    begin
      {ACHTUNG: keine API-Funtionen im Ereignisbehandler verwenden }
      DoErrorTimer;
      {sämtliche anderen PLC in den Halt-Mode setzen }
      if Assigned(FPlc) then FPlc.Error(ecmInOutBase +FInOutNo);
    end;
  end;
end;

procedure TCustomInOut.UpdateState(aState: TInOutState);
begin
  { Methode, die bei Änderung von Mode mit dem neuen Wert aufgerufen wird }
end;

procedure TCustomInOut.SetActive(Value: Boolean);
begin
  if csLoading in ComponentState then
    FStreamedActive :=Value
  else
    if Value then Open else Close;
end;

procedure TCustomInOut.SetInOutNo(Value: TInOutNo);
var
  aPlc: TwdxPlc;
begin
  if FInOutNo <> Value then
  begin
    if Assigned(FPlc) then
    begin
      if not FPlc.InOutAvailable(Value) then
        raise Exception.Create(
            Format('E/A-Gerätenummer %d bei %s ist schon belegt', [FInOutNo,
                FPlc.Name]));
      aPlc :=Plc;
      Plc :=nil;
      FInOutNo :=Value;
      Plc :=aPlc;
    end
    else FInOutNo :=Value;
  end;
end;

procedure TCustomInOut.SetPlc(Value: TwdxPlc);
begin
  if FPlc <> Value then
  begin
    {prüfen, ob InOut bei neuer Plc noch frei ist}
    if Assigned(Value) then
      if not Value.InOutAvailable(FInOutNo) then
        raise Exception.Create(
            Format('E/A-Gerätenummer %d bei %s ist schon belegt', [FInOutNo,
                Value.Name]));
    {bei alter PLC abmelden}
    if Assigned(FPlc) then
      FPlc.UnregisterInOut(Self);
    FPlc := Value;
    {bei neuer PLC anmelden}
    if Assigned(FPlc) then
    begin
      FPlc.RegisterInOut(Self);
      FPlc.FreeNotification(Self);
    end;
  end;
end;

{
************************************ TCustomPetriNet *************************************
}
destructor TCustomPetriNet.Destroy;
begin
  { bei zugeordneter Plc abmelden }
  Plc :=nil;
  inherited Destroy;
end;

procedure TCustomPetriNet.AtState;
begin
  { do nothing }
end;

procedure TCustomPetriNet.BeginState;
begin
  { do nothing }
end;

procedure TCustomPetriNet.DoProcess;
begin
  AtProcess;
  if Assigned(FOnProcess) then FOnProcess(Self);
end;

procedure TCustomPetriNet.DoStateChanged(Sender: TObject; aState: Integer);
begin
  if Assigned(FOnStateChanged) then FOnStateChanged(Sender, aState);
end;

procedure TCustomPetriNet.EndState;
begin
  { do nothing }
end;

procedure TCustomPetriNet.Notification(aComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(aComponent, Operation);
  if (Operation =opRemove) and (aComponent =FPlc) then
    Plc :=nil;
end;

procedure TCustomPetriNet.Process;
begin
  {Netzwerk regelmäßig aktualisieren}
  DoProcess;
  {wenn State gewechselt wurde, Ereignis aufrufen}
  if FStateChanged then
  begin
    DoStateChanged(Self, FState);
    {State-Changed Flag löschen}
    FStateChanged :=False;
  end;
end;

procedure TCustomPetriNet.Reset;
begin
  { Netz in den Grundzustand setzen }
  State :=0;
end;

procedure TCustomPetriNet.TimerProcess;
var
  aState: Integer;
begin
  { Eingänge lesen }
  ReadInputs;
  { Zustandsänderungen durchführen }
  aState :=FState;
  StateCtrl(aState);
  { Netzzustand aktualisieren }
  if FState <>aState then SetState(aState);
  { Zustandsabhängige Aktionen durchführen }
  AtState;
  { Ausgänge schreiben }
  WriteOutputs;
  { Koppelsignale löschen }
  ClearValues;
end;

procedure TCustomPetriNet.SetPlc(Value: TwdxPlc);
begin
  if FPlc <> Value then
  begin
    { bei alter SPS abmelden }
    if Assigned(FPlc) then
      FPlc.UnregisterPetriNet(Self);
    FPlc := Value;
    { bei neuer SPS anmelden }
    if Assigned(FPlc) then
    begin
      FPlc.RegisterPetriNet(Self);
      FPlc.FreeNotification(Self);
    end;
  end;
end;

procedure TCustomPetriNet.SetState(Value: Integer);
begin
  if FState <>Value then
  begin
    EndState;
    FState :=Value;
    BeginState;
    { State-Changed Flag setzen, löst Ereignis StateChanged
      beim nächsten Process aus }
    FStateChanged :=True;
  end;
end;

{
************************************** TwdxPetriNet **************************************
}
procedure TwdxPetriNet.AtState;
begin
  if Assigned(FOnAtState) then FOnAtState(Self, State);
end;

procedure TwdxPetriNet.BeginState;
begin
  if Assigned(FOnBeginState) then FOnBeginState(Self, State);
end;

procedure TwdxPetriNet.ClearValues;
begin
  if Assigned(FOnClearValues) then FOnClearValues(Self, State);
end;

procedure TwdxPetriNet.EndState;
begin
  if Assigned(FOnEndState) then FOnEndState(Self, State);
end;

procedure TwdxPetriNet.ReadInputs;
begin
  if Assigned(FOnReadInputs) then FOnReadInputs(Self, State);
end;

procedure TwdxPetriNet.WriteOutputs;
begin
  if Assigned(FOnWriteOutputs) then FOnWriteOutputs(Self, State);
end;

procedure TwdxPetriNet.StateCtrl(var aState: Integer);
begin
  if Assigned(FOnStateCtrl) then FOnStateCtrl(Self, aState);
end;

procedure TCustomPetriNet.ClearValues;begin
  { do nothing }
end;

procedure TCustomPetriNet.ReadInputs;begin
  { do nothing }
end;

procedure TCustomPetriNet.WriteOutputs;begin
  { do nothing }
end;

procedure TCustomPetriNet.AtProcess;begin
  { do nothing }
end;

end.