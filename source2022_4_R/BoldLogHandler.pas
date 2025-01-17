
/////////////////////////////////////////////////////////
//                                                     //
//              Bold for Delphi                        //
//    Copyright (c) 1996-2002 Boldsoft AB              //
//              (c) 2002-2005 Borland Software Corp    //
//                                                     //
/////////////////////////////////////////////////////////


unit BoldLogHandler;

interface

uses
  Classes,
  BoldDefs,
  BoldMath,
  BoldSubscription,
  BoldLogReceiverInterface;

type
  { forward declaration }
  TBoldLogHandler = class;
  TBoldLogHandlerClass = class of TBoldLogHandler;

  { TBoldLogHandler }
  TBoldLogHandler = class(TBoldSubscribableObject)
  private
    fIndent: integer;
    fInterrupted: Boolean;
    fInterruptHandled: Boolean;
    procedure SetProgress(const Value: integer);
    procedure SetLogHeader(const Value: string);
    procedure SetProgressMax(const Value: integer);
  protected
    function IndentSpaces: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Log(const s: string; LogType: TBoldLogType = ltInfo); virtual;
    procedure LogFmt(const s: string; const Args: array of const; LogType: TBoldLogType = ltInfo);
    procedure LogIndent(const s: string; LogType: TBoldLogType = ltInfo);
    procedure LogDedent(const s: string; LogType: TBoldLogType = ltInfo);
    procedure LogFmtIndent(const s: string; const Args: array of const; LogType: TBoldLogType = ltInfo);
    procedure LogFmtDedent(const s: string; const Args: array of const; LogType: TBoldLogType = ltInfo);
    procedure Clear; virtual;
    procedure Hide; virtual;
    procedure Show; virtual;
    procedure StartLog(const SessionName: String); virtual;
    procedure EndLog;
    procedure Indent;
    procedure Dedent;
    procedure Separator;
    procedure ProgressStep; virtual;
    procedure Sync; virtual;
    procedure RegisterLogReceiver(LogReceiver: IBoldLogReceiver);
    procedure UnregisterLogReceiver(LogReceiver: IBoldLogReceiver);
    procedure InterruptProcess;
    function ProcessInterruption: Boolean;
    property ProgressMax: integer write SetProgressMax;
    property Progress: integer write SetProgress;
    property LogHeader: string write SetLogHeader;

  end;

  TBoldLogReceiverSubscriber = class(TBoldSubscriber)
  private
    fReceiver: IBoldLogReceiver;
  protected
    procedure Receive(Originator: TObject; OriginalEvent: TBoldEvent; RequestedEvent: TBoldRequestedEvent); override;
    procedure ReceiveExtended(Originator: TObject; OriginalEvent: TBoldEvent; RequestedEvent: TBoldRequestedEvent; const Args: array of const); override;
    function GetHandlesExtendedEvents: Boolean; override;
  public
    constructor Create(Receiver: IBoldLogreceiver);
  end;

function BoldLog: TBoldLogHandler;

implementation

uses
  SysUtils,
  BoldUtils,
  BoldCommonConst;

const
  bleFirst = 1;
  bleSetProgress = 1; // Value: integer
  bleSetLogHeader = 2; // Value: string
  bleSetProgressMax = 3; // Value: integer
  bleClear = 4;
  bleHide = 5;
  bleLog = 6; // s: string; LogType: TBoldLogType
  bleProgressStep = 7;
  bleShow = 8;
  bleStartLog = 9; //SessionName: String
  bleEndLog = 10;
  bleProcessInterruption = 11;
  bleRemoveReceiver = 12; // LogReceiver;
  bleSync = 13;
  bleLast = 13;

var
  G_BoldLog: TBoldLogHandler = nil;
  G_BoldLogHandlerClass: TBoldLogHandlerClass = TBoldLogHandler;

function BoldLog: TBoldLogHandler;
begin
  if not Assigned(G_BoldLog) then
    G_BoldLog := G_BoldLogHandlerClass.Create;
  Result := G_BoldLog;
end;

constructor TBoldLogHandler.Create;
begin
  inherited;
end;

destructor TBoldLogHandler.Destroy;
begin
  inherited;
end;

function TBoldLogHandler.IndentSpaces: string;
begin
  Result := StringOfChar(' ', fIndent shl 1);
end;

procedure TBoldLogHandler.Separator;
begin
  Log('', ltSeparator);
  Log('-={++++}=-', ltSeparator);
  Log('', ltSeparator);
end;

procedure TBoldLogHandler.Clear;
begin
  SendEvent(bleClear);
end;

procedure TBoldLogHandler.Show;
begin
  SendEvent(bleShow);
end;

procedure TBoldLogHandler.Hide;
begin
  SendEvent(bleHide);
end;

procedure TBoldLogHandler.StartLog(const SessionName: String);
begin
  fIndent := 0;
  fInterrupted := false;
  fInterruptHandled := false;
  Separator;
  SendExtendedEvent(bleStartLog, [SessionName]);
end;

procedure TBoldLogHandler.EndLog;
begin
  SendEvent(bleEndLog);
  Separator;
end;

procedure TBoldLogHandler.Log(const s: string; LogType: TBoldLogType = ltInfo);
begin
  SendExtendedEvent(bleLog, [IndentSpaces + s, Integer(LogType)]);
end;

procedure TBoldLogHandler.LogFmt(const s: string; const Args: array of const; LogType: TBoldLogType = ltInfo);
begin
  Log(Format(s, Args), LogType);
end;

procedure TBoldLogHandler.LogIndent(const s: string; LogType: TBoldLogType = ltInfo);
begin
  Log(s, LogType);
  Indent;
end;

procedure TBoldLogHandler.LogDedent(const s: string; LogType: TBoldLogType = ltInfo);
begin
  Dedent;
  Log(s, LogType);
end;

procedure TBoldLogHandler.LogFmtIndent(const s: string; const Args: array of const; LogType: TBoldLogType = ltInfo);
begin
  LogFmt(s, Args, LogType);
  Indent;
end;

procedure TBoldLogHandler.LogFmtDedent(const s: string; const Args: array of const; LogType: TBoldLogType = ltInfo);
begin
  Dedent;
  LogFmt(s, Args, LogType);
end;

procedure TBoldLogHandler.Indent;
begin
  Inc(fIndent);
end;

procedure TBoldLogHandler.Dedent;
begin
  Dec(fIndent);
  if fIndent < 0 then
    fIndent := 0;
end;

procedure TBoldLogHandler.SetProgressMax(const Value: integer);
begin
  SendExtendedEvent(bleSetProgressMax, [MaxIntValue([0, Value])]);
end;

procedure TBoldLogHandler.SetProgress(const Value: integer);
begin
  SendExtendedEvent(bleSetProgress, [value]);
end;

procedure TBoldLogHandler.SetLogHeader(const Value: String);
begin
  SendExtendedEvent(bleSetLogHeader, [Value]);
end;

procedure TBoldLoghandler.ProgressStep;
begin
  SendEvent(bleProgressStep);
end;

procedure TBoldLogHandler.RegisterLogReceiver(LogReceiver: IBoldLogReceiver);
begin
  TBoldLogReceiverSubscriber.Create(LogReceiver);
end;

procedure TBoldLogHandler.UnregisterLogReceiver(LogReceiver: IBoldLogReceiver);
begin
  SendExtendedEvent(bleRemoveReceiver, [LogReceiver]);
end;


procedure TBoldLogHandler.InterruptProcess;
begin
  Log(sTryingToAbort);
  fInterrupted := true;
  fInterruptHandled := false;
end;

function TBoldLogHandler.ProcessInterruption: Boolean;
begin
  SendEvent(bleProcessInterruption);
  result := fInterrupted;
  if result then
  begin
    if not fInterruptHandled then
      Log(sProcessStopped);
    fInterruptHandled := true;
  end;
end;

{ TBoldLogReceiverSubscriber }

constructor TBoldLogReceiverSubscriber.Create(Receiver: IBoldLogreceiver);
begin
  inherited Create;
  fReceiver := Receiver;
  BoldLog.AddSmallSubscription(self, [beDestroying], 0);
  BoldLog.AddSmallSubscription(self, [bleFirst..bleLast], 0);
end;

function TBoldLogReceiverSubscriber.GetHandlesExtendedEvents: Boolean;
begin
  result := true;
end;

procedure TBoldLogReceiverSubscriber.Receive(Originator: TObject;
  OriginalEvent: TBoldEvent; RequestedEvent: TBoldRequestedEvent);
begin
  // Do nothing... Handled by Extended
end;

procedure TBoldLogReceiverSubscriber.ReceiveExtended(Originator: TObject;
  OriginalEvent: TBoldEvent; RequestedEvent: TBoldRequestedEvent;
  const Args: array of const);

  function GetString(const VR: TVarRec): String;
  begin
    case VR.VType of
      vtString: result := VR.VString^;
      vtAnsiString: result := PChar(VR.VAnsiString);
      else
        raise Exception.Create(sUnknownTypeInGetString);
    end;
  end;

begin
  case OriginalEvent of
    bleSetProgress: fReceiver.SetProgress(args[0].VInteger); // Value: integer
    bleSetLogHeader: fReceiver.SetLogHeader(GetString(Args[0])); // Value: string
    bleSetProgressMax: fReceiver.SetProgressMax(args[0].VInteger); // Value: integer
    bleLog: fReceiver.Log(GetString(Args[0]), TBoldLogType(args[1].vInteger)) ;// s: string; LogType: TBoldLogType
    bleStartLog: fReceiver.StartLog(GetString(Args[0]));//SessionName: String
    // commit suicide
    bleRemoveReceiver: if IUnknown(Args[0].VInterface) = freceiver then free;
    beDestroying: Free;
    bleClear: fReceiver.Clear;
    bleHide: fReceiver.Hide;
    bleProgressStep: fReceiver.ProgressStep;
    bleShow: fReceiver.Show;
    bleSync: fReceiver.Sync;
    bleEndLog: fReceiver.EndLog;
    bleProcessInterruption: fReceiver.ProcessInterruption;
    else
      ;
  end;
end;

procedure TBoldLogHandler.Sync;
begin
  SendEvent(bleSync);
end;

initialization

finalization
  FreeAndNil(G_BoldLog);

end.
