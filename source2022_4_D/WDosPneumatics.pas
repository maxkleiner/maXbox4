unit WDosPneumatics;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms,
  WDosPlcUtils, WDosPlcs, WDosTimers;

const
  DPulseTime =2000;
  DSwitchTime =20000;
  DIdleTime =5000;

  { state constants }
  cylInit = 0;
  cylClose = 1;
  cylOpening = 2;
  cylOpen = 3;
  cylCloseing = 4;
  cylError = 5;

type
  TwdxCylinder = class(TCustomPetriNet)
  private
    FEOpen: Boolean;
    FEClose: Boolean;
    FAOpen: Boolean;
    FAClose: Boolean;
    FIdleTime: Integer;
    FPulseTime: Integer;
    FSwitchTime: Integer;
    FDummy: Boolean;
    FTiSwitch: TDateTime;
    FTiPulse: TDateTime;
    FTiIdle: TDateTime;
    FErrorCode: Integer;
    FMReset: Boolean;
    FMOpen: Boolean;
    FMClose: Boolean;
    FPosition: Integer;
    FInpClose: TBitAddr;
    FOutClose: TBitAddr;
    FInpOpen: TBitAddr;
    FOutOpen: TBitAddr;
    FOpened: Boolean;
    FClosed: Boolean;
    FError: Boolean;
    FOnClose: TNotifyEvent;
    FOnOpen: TNotifyEvent;
    FOnError: TErrorEvent;
  protected
    procedure CalculatePosition;
    procedure AtState; override;
    procedure BeginState; override;
    procedure ReadInputs; override;
    procedure WriteOutputs; override;
    procedure ClearValues; override;
    procedure AtProcess; override;
    procedure StateCtrl(var aState: Integer); override;
    function StartTimer(Delay: Integer): TDateTime;
    function TimeOut(Timer: TDateTime): Boolean;
    property MReset: Boolean read FMReset;
    property MOpen: Boolean read FMOpen;
    property MClose: Boolean read FMClose;
    property EOpen: Boolean read FEOpen;
    property EClose: Boolean read FEClose;
    property AOpen: Boolean read FDummy write FAOpen;
    property AClose: Boolean read FDummy write FAClose;
  public
    constructor Create(aOwner: TComponent); override;
    procedure Reset; override;
    procedure Open;
    procedure Close;
    property Position: Integer read FPosition;
  published
    property OnProcess;
    property OnStateChanged;
    property InpOpen: TBitAddr read FInpOpen write FInpOpen;
    property InpClose: TBitAddr read FInpClose write FInpClose;
    property OutOpen: TBitAddr read FOutOpen write FOutOpen;
    property OutClose: TBitAddr read FOutClose write FOutClose;
    property PulseTime: Integer read FPulseTime write FPulseTime
        default DPulseTime;
    property SwitchTime: Integer read FSwitchTime write FSwitchTime
        default DSwitchTime;
    property IdleTime: Integer read FIdleTime write FIdleTime
        default DIdleTime;
    property ErrorCode: Integer read FErrorCode;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnError: TErrorEvent read FOnError write FOnError;
  end;

implementation

{ TwdxCylinder }

procedure TwdxCylinder.AtProcess;
begin
  if FError then
    if Assigned(FOnError) then OnError(Self, ErrorCode);
  if FOpened then
    if Assigned(FOnOpen) then OnOpen(Self);
  if FClosed then
    if Assigned(FOnClose) then OnClose(Self);
  { reset event flags }
  FError :=False;
  FOpened :=False;
  FClosed :=False;
end;

procedure TwdxCylinder.AtState;
begin
  AOpen :=(State =cylOpening) and not TimeOut(FTiPulse);
  AClose :=(State =cylCloseing) and not TimeOut(FTiPulse);
  CalculatePosition;
end;

procedure TwdxCylinder.BeginState;
begin
  case State of
    cylOpen:
    begin
      FTiIdle :=StartTimer(IdleTime);
      FOpened :=True;
    end;
    cylClose:
    begin
      FTiIdle :=StartTimer(IdleTime);
      FClosed :=True;
    end;
    cylOpening, cylCloseing:
    begin
      FTiSwitch :=StartTimer(SwitchTime);
      FTiPulse :=StartTimer(PulseTime);
      FTiIdle :=StartTimer(IdleTime);
    end;
    cylError:
    begin
      FError :=True;
    end;
  end; { case }
end;

procedure TwdxCylinder.CalculatePosition;

  function StatePosition: Integer;
  begin
    Result :=DateTimeToMs(FTiSwitch -StartTimer(0)) *100 div FSwitchTime;
  end;

begin
  case State of
    cylOpen: FPosition :=100;
    cylClose: FPosition :=0;
    cylOpening: FPosition :=100 -StatePosition;
    cylCloseing:FPosition :=StatePosition;
  end; { case }
end;

procedure TwdxCylinder.ClearValues;
begin
  FMReset :=False;
  FMOpen :=False;
  FMClose :=False;
end;

procedure TwdxCylinder.Close;
begin
  FMClose :=True;
end;

constructor TwdxCylinder.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FPulseTime :=DPulseTime;
  FSwitchTime :=DSwitchTime;
  FIdleTime :=DIdleTime;
end;

procedure TwdxCylinder.Open;
begin
  FMOpen :=True;
end;

procedure TwdxCylinder.ReadInputs;
begin
  with Plc do
  begin
    FEOpen :=IO[InpOpen];
    FEClose :=IO[InpClose];
  end;
end;

procedure TwdxCylinder.Reset;
begin
  FMReset :=True;
end;

function TwdxCylinder.StartTimer(Delay: Integer): TDateTime;
begin
  Result :=Plc.StartTimer(Delay);
end;

procedure TwdxCylinder.StateCtrl(var aState: Integer);

  procedure Error(aErrorCode: Integer);
  begin
    aState :=cylError;
    FErrorCode :=aErrorCode;
  end;

begin
  case aState of
    cylInit:
    begin
      if EOpen =EClose then Error(1)
      else if EClose then aState :=cylClose
      else if EOpen then aState :=cylOpen;
    end;
    cylClose:
    begin
      if not EClose and TimeOut(FTiIdle) then Error(2)
      else if EOpen then Error(3)
      else if MOpen then aState :=cylOpening;
    end;
    cylOpening:
    begin
      if TimeOut(FTiSwitch) then Error(4)
      else if EClose and TimeOut(FTiIdle) then Error(5)
      else if EOpen then aState :=cylOpen;
    end;
    cylOpen:
    begin
      if not EOpen and TimeOut(FTiIdle) then Error(6)
      else if EClose then Error(7)
      else if MClose then aState :=cylCloseing;
    end;
    cylCloseing:
    begin
      if TimeOut(FTiSwitch) then Error(8)
      else if EOpen and TimeOut(FTiIdle) then Error(9)
      else if EClose then aState :=cylClose;
    end;
    cylError:
    begin
      if MReset then aState :=cylInit;
    end;
  end; { case }
end;

function TwdxCylinder.TimeOut(Timer: TDateTime): Boolean;
begin
  Result :=Plc.TimeOut(Timer);
end;

procedure TwdxCylinder.WriteOutputs;
begin
  with Plc do
  begin
    IO[OutOpen] :=FAOpen;
    IO[OutClose] :=FAClose;
  end;
end;

end.
