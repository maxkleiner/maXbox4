unit statmach;
// -----------------------------------------------------------------------------
// Project:     State Machine
// Module:      statmach
// Description: Visual Finite State Machine.
// Version:     2.2
// Release:     6
// Date:        4-APR-2006
// Target:      Delphi 5-2007, Win32.
// Author(s):   anme: Anders Melander, anders@melander.dk
// Copyright:   (c) 1997-2008 Anders Melander.
//              All rights reserved.
// -----------------------------------------------------------------------------
// This work is licensed under the "Creative Commons Attribution-Share Alike
// 3.0 Unported" license.
// http://creativecommons.org/licenses/by-sa/3.0/
// -----------------------------------------------------------------------------
// Revision history:
//
// 0001 130298  anme    - Released for public beta.
//
// 0100 280398  anme    - Implemented TStateConnector persistence.
//                      - Many small design time bugs fixed.
//                      - Implemented soSingleStep option.
//                      - Released as version 1.0
//
// 0101 090598  anme    - Fixed design time TStateConnector editor with help
//                        from Filip Larsen.
//
// 0200 120199  anme    - Implemented threaded scheduler and soThreaded option.
//                      - Added OnStart and OnStop events.
//                      - Removed obsolete methods.
//
// 0201 060899  anme    - Added OnSingleStep event.
//                      - Verified Delphi 5 compatibility.
//                      - TStateControl.Click functionality has been deprecated.
//                      - Improved start/stop operation.
//                      - Improved thread shutdown logic.
//
// 0202 040406  anme    - Complete rewrite of threaded scheduler.
//                      - The message based scheduler has now been deprecated.
// -----------------------------------------------------------------------------
interface

uses
  ExtCtrls,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

// Windows message used to initiate state transitions
const
  SM_STATE_TRANSITION = WM_USER;

type
  TStateThread = class;
  TStateMachine = class;
  TStateControl = class;
  TStateConnector = class;

  // Type of the OnChangeState event
  TChangeStateEvent = procedure(Sender: TStateMachine; FromState, ToState: TStateControl) of object;

  // Type of the OnException event
  TStateExceptionEvent = procedure(Sender: TStateMachine; Node: TStateControl) of object;

  // Run-time options:
  //
  //   soInteractive
  //                    If set, the TStateMachine will be visible at run-time.
  //                    The current state will be painted in red and bold.
  //
  //   soSingleStep
  //                    If set, the execution will stop after each transition.
  //                    Use the Execute method to resume execution.
  //
  //   soSynchronize
  //                    If set, all events are fired in the context of the main thread via the
  //                    TThread.Synchronize method. Otherwise, the events are fired in the context
  //                    of the scheduler thread.
  //
  TStateMachineOption = (soInteractive, soSingleStep, soSynchronize);
  TStateMachineOptions = set of TStateMachineOption;

  TDesignMove = (dmSource, dmFirstHandle, dmOffset, dmLastHandle, dmDestination, dmNone);
  TConnectorLines = array[dmSource..dmDestination] of TPoint;

  TStateMachine = class(TCustomPanel)
  private
    FState: TStateControl;
    FOnChangeState: TChangeStateEvent;
    FOnException: TStateExceptionEvent;
    FActive: boolean;
    FConnector: TStateConnector;
    FDesignMoving: TDesignMove;
    Lines: TConnectorLines;
    FOptions: TStateMachineOptions;
    FThread: TStateThread;
    FOnStart: TNotifyEvent;
    FOnStop: TNotifyEvent;
    FOnSingleStep: TNotifyEvent;
    FOnThreadStart: TNotifyEvent;
    FOnThreadStop: TNotifyEvent;
    procedure StartThread;
    procedure StopThread;
    function GetState: TStateControl;
  protected
    procedure SetActive(const Value: boolean);
    procedure SetState(Value :TStateControl);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoTransition; virtual;
    procedure DoException(Node: TStateControl); virtual;
    procedure DoStart; virtual;
    procedure DoStop; virtual;
    procedure DoOnSingleStep; virtual;
    function HandlesTransitionEvent: boolean;
    procedure CMDesignHitTest(var Msg: TWMMouse); message cm_DesignHitTest;
  public
    procedure Execute(Wait: boolean = False);
    procedure Stop;
  published
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Active: boolean read FActive write SetActive default False;
    property State: TStateControl read GetState write SetState;
    property Options: TStateMachineOptions read FOptions write FOptions default [soSynchronize];
    property OnChangeState: TChangeStateEvent read FOnChangeState write FOnChangeState;
    property OnException: TStateExceptionEvent read FOnException write FOnException;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnStop: TNotifyEvent read FOnStop write FOnStop;
    property OnThreadStart: TNotifyEvent read FOnThreadStart write FOnThreadStart;
    property OnThreadStop: TNotifyEvent read FOnThreadStop write FOnThreadStop;
    property OnSingleStep: TNotifyEvent read FOnSingleStep write FOnSingleStep;
    property Align;
    property Color;
    property Font;
  end;

  TStateThread = class(TThread)
  private
    FStateMachine: TStateMachine;
    FState: TStateControl;
    FNextState: TStateControl;
    FStartEvent: THandle;
    procedure DoEnterState;
    procedure DoExitState;
    procedure DoTransition;
    procedure DoStart;
    procedure DoStop;
    procedure FireEvent(Method: TThreadMethod);
  protected
    // procedure DoTerminate; virtual;
    procedure Execute; override;
    procedure SetState(const Value: TStateControl);
  public
    constructor Create(AStateMachine: TStateMachine);
    destructor Destroy; override;
    procedure Terminate;
    property StateMachine: TStateMachine read FStateMachine;
    property State: TStateControl read FState write SetState;
    property NextState: TStateControl read FNextState;
  end;

  TTransitionDirection = (tdFrom, tdTo);
  TVisualElement = (veShadow, veFrame, vePanel, veText, veConnector);
  TStatePathOwner = (poOwnedBySource, poOwnedByDestination);

  TStateControl = class(TGraphicControl)
  private
    { Private declarations }
    FStateMachine: TStateMachine;
    FConnectors: TList;
    FPainting: Boolean;
    FSynchronize: boolean;
    FOnEnterState: TNotifyEvent;
    FOnExitState: TNotifyEvent;
    procedure ReadConnectors(Reader: TReader);
    procedure WriteConnectors(Writer: TWriter);
  protected
    { Protected declarations }
    procedure DefineProperties(Filer: TFiler); override;
    procedure SetHint(Value: string);
    function GetHint: string;
    procedure SetActive(Value: boolean); virtual;
    function GetActive: boolean; virtual;
    procedure SetParent(AParent: TWinControl); override;
    function GetCheckStateMachine: TStateMachine;
    property CheckStateMachine: TStateMachine read GetCheckStateMachine;
    procedure Paint; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure DoEnter; virtual;
    procedure DoExit; virtual;
    procedure DoException;
    function Default: TStateControl; virtual;
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); virtual;
    procedure DrawText(Rect: TRect); virtual;
    procedure DoPaint; virtual;
    function AddConnector(OwnerRole: TStatePathOwner): TStateConnector;
    function HandlesEnterEvent: boolean; virtual;
    function HandlesExitEvent: boolean; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure PaintConnector; virtual;
    function HitTest(Mouse: TPoint): TStateConnector; virtual;
    property StateMachine: TStateMachine read FStateMachine;
    property Active: boolean read GetActive write SetActive default False;
    property Connectors: TList read FConnectors;
    property OnEnterState: TNotifyEvent read FOnEnterState write FOnEnterState;
    property OnExitState: TNotifyEvent read FOnExitState write FOnExitState;
  published
    property Hint: string read GetHint write SetHint;
    property Synchronize: boolean read FSynchronize write FSynchronize;
  end;

  TStateNodeBase = class(TStateControl)
  protected
    procedure SetParent(AParent: TWinControl); override;
  end;

  TStatePath = (spAuto, spDirect, spLeftRight, spTopBottom, spTopLeft, spRightBottom);

  TStateConnector = class(TObject)
  private
    FSelected: Boolean;
    FOffset: integer;
    FPath: TStatePath;
    FActualPath: TStatePath;
    FOwner: TStatePathOwner;
    FSource: TStateControl;
    FDestination: TStateControl;
    BoundsRect: TRect;
  protected
    procedure SetPeer(Index: integer; Value: TStateControl);
    function GetPeer(Index: integer): TStateControl;
  public
    constructor Create(AOwner: TStateControl; OwnerRole: TStatePathOwner);
    procedure Paint;
    procedure PaintFlipLine;
    function HitTest(Mouse: TPoint): Boolean;
    function GetLines(var Lines: TConnectorLines): Boolean;
    class function MakeRect(pa, pb: TPoint): TRect;
    class function RectCenter(r: TRect): TPoint;
    property Source: TStateControl index 1 read FSource write SetPeer;
    property Destination: TStateControl index 2 read FDestination write SetPeer;
    property PeerNode: TStateControl index 0 read GetPeer write SetPeer;
    property ActualPath: TStatePath read FActualPath;
    property Selected: Boolean read FSelected write FSelected;
  published
    property Path: TStatePath read FPath write FPath;
    property Offset: integer read FOffset write FOffset;
  end;

  TStateBoolean = class;
  TBooleanStateEvent = procedure(Sender: TStateBoolean; var Result: Boolean) of Object;

  TStateBoolean = class(TStateNodeBase)
  private
    { Private declarations }
    FOnEnterState: TBooleanStateEvent;
    FTrueState: TStateControl;
    FFalseState: TStateControl;
    FTrueConnector: TStateConnector;
    FFalseConnector: TStateConnector;
    FResult: Boolean;
    FDefault: Boolean;
  protected
    { Protected declarations }
    procedure DoPaint; override;
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
    procedure SetTrueState(Value :TStateControl);
    procedure SetFalseState(Value :TStateControl);
    procedure SetDefault(Value :Boolean);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure DoEnter; override;
    function HandlesEnterEvent: boolean; override;
    function Default: TStateControl; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure PaintConnector; override;
    function HitTest(Mouse: TPoint): TStateConnector; override;
  published
    { Published declarations }
    property OnEnterState: TBooleanStateEvent read FOnEnterState write FOnEnterState;
    property OnExitState;
    property TrueState: TStateControl read FTrueState write SetTrueState;
    property FalseState: TStateControl read FFalseState write SetFalseState;
    property DefaultState: Boolean read FDefault write SetDefault default True;
  end;

  TStateNode = class(TStateNodeBase)
  private
    FDefaultTransition: TStateControl;
    FToConnector: TStateConnector;
  protected
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
    procedure SetDefaultTransition(Value: TStateControl);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function Default: TStateControl; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure PaintConnector; override;
    function HitTest(Mouse: TPoint): TStateConnector; override;
  published
    property OnEnterState;
    property OnExitState;
    property DefaultTransition: TStateControl read FDefaultTransition write SetDefaultTransition;
  end;

  TStateStart = class(TStateNode)
  protected
    { Protected declarations }
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
  end;

  TStateStop = class(TStateControl)
  protected
    { Protected declarations }
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
  end;

  TStateTransition = class(TStateControl)
  private
    { Private declarations }
    FFromState: TStateControl;
    FToState: TStateControl;
    FOnTransition: TNotifyEvent;
    FToConnector: TStateConnector;
    FFromConnector: TStateConnector;
  protected
    { Protected declarations }
    procedure DoPaint; override;
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetFromState(Value :TStateControl);
    procedure SetToState(Value :TStateControl);
    function HandlesEnterEvent: boolean; override;
    procedure DoEnter; override;
    function Default: TStateControl; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure PaintConnector; override;
    function HitTest(Mouse: TPoint): TStateConnector; override;
  published
    { Published declarations }
    property FromState: TStateControl read FFromState write SetFromState;
    property ToState: TStateControl read FToState write SetToState;
    property OnTransition: TNotifyEvent read FOnTransition write FOnTransition;
  end;

  TLinkDirection = (ldIncoming, ldOutgoing);

  TStateLinkBase = class(TStateControl)
  end;

  TStateLink = class(TStateLinkBase)
  private
    { Private declarations }
    FDestination: TStateControl;
    FConnector: TStateConnector;
    FDirection: TLinkDirection;
  protected
    { Protected declarations }
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
    procedure DoPaint; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetDestination(Value :TStateControl);
    procedure SetDirection(Value :TLinkDirection);
    function Default: TStateControl; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure PaintConnector; override;
    function HitTest(Mouse: TPoint): TStateConnector; override;
  published
    { Published declarations }
    property Destination: TStateControl read FDestination write SetDestination;
    property Direction: TLinkDirection read FDirection write SetDirection;
  end;

procedure Register;

implementation

{$DEBUGINFO ON}

uses
{$IFDEF DEBUG}
  debugit,
{$ENDIF}
  TypInfo;

{$IFNDEF DEBUG}
procedure DebugStr(s: string);
begin
end;
{$ENDIF}

const
  ShadowHeight = 2;
  OverlapXMargin = 10;
  OverlapYMargin = 10;
  SelectMarginX = 4;
  SelectMarginY = 4;

//******************************************************************************
//**
//**                    Component Registration
//**
//******************************************************************************
(*
type
  TConnectorProperty = class(TClassProperty)
  protected
    Connector: TStateConnector;
  public
    procedure GetProperties(Proc: TGetPropEditProc); override;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

function TConnectorProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paSubProperties, paValueList, paSortList];
end;

procedure TConnectorProperty.GetProperties(Proc: TGetPropEditProc);
var
  I: Integer;
  Components: TComponentList;
  StateControl: TStateControl;
begin
  Components := TComponentList.Create;
  try
    StateControl := TStateControl(GetOrdValue);
    // Find all properties of type
function GetPropList(TypeInfo: PTypeInfo; TypeKinds: TTypeKinds;
  PropList: PPropList): Integer;
    Components.Add(TComponent(GetOrdValueAt(I)));
    GetComponentProperties(Components, tkProperties, Designer, Proc);
  finally
    Components.Free;
  end;
end;

procedure TConnectorProperty.GetValues(Proc: TGetStrProc);
begin
  Designer.GetComponentNames(GetTypeData(TypeInfo(TStateControl)), Proc);
end;

function TConnectorProperty.GetValue: string;
begin
  if (TStateConnector(GetOrdValue).PeerNode <> nil) then
    FmtStr(Result, '(%s)', [TStateControl(GetOrdValue).Name])
  else
    Result := '';
end;

procedure TConnectorProperty.SetValue(const Value: string);
var
  Component: TComponent;
begin
  if Value = '' then Component := nil else
  begin
    Component := Designer.GetComponent(Value);
    if not (Component is TStateControl) then
      raise EPropertyError.Create(SInvalidPropertyValue);
  end;
  SetOrdValue(LongInt(Component));
end;
*)
procedure Register;
begin
  RegisterComponents('Logic',
    [TStateMachine, TStateNode, TStateTransition, TStateBoolean, TStateLink,
     TStateStart, TStateStop]);
//  RegisterPropertyEditor(TypeInfo(TStateControl), TStateControl, '', TConnectorProperty);
end;

//******************************************************************************
//**
//**                    Scheduling
//**
//******************************************************************************
constructor TStateThread.Create(AStateMachine: TStateMachine);
begin
  inherited Create(True); // Suspended
  FreeOnTerminate := False;
  FStateMachine := AStateMachine;
  FStartEvent := CreateEvent(nil, False, False, nil);
  Resume;
end;

destructor TStateThread.Destroy;
begin
  CloseHandle(FStartEvent);
  inherited Destroy;
end;

procedure TStateThread.FireEvent(Method: TThreadMethod);
begin
  if (State.Synchronize) then
    Synchronize(Method)
  else
    Method;
end;          

procedure TStateThread.DoEnterState;
begin
  if (not Terminated) and (State.HandlesEnterEvent) then
    FireEvent(State.DoEnter);
end;

procedure TStateThread.DoExitState;
begin
  if (not Terminated) and (State.HandlesExitEvent) then
    FireEvent(State.DoExit);
end;

procedure TStateThread.DoStart;
begin
  Synchronize(StateMachine.DoStart);
end;

procedure TStateThread.DoStop;
begin
  Synchronize(StateMachine.DoStop);
  StateMachine.Stop;
end;

procedure TStateThread.DoTransition;
begin
  if (not Terminated) and (StateMachine.HandlesTransitionEvent) then
    FireEvent(StateMachine.DoTransition);
end;

procedure TStateThread.Execute;
begin
  if (Assigned(StateMachine.OnThreadStart)) then
    StateMachine.OnThreadStart(Self);
  try
    DoStart;
    // Wait for start
    WaitForSingleObject(FStartEvent, INFINITE);

    FState := FNextState;

    // Execute state transitions
    while (not Terminated) and (FState <> nil) do
    begin
      DoEnterState;
      if (FNextState = State) then
        FNextState := State.Default;
      if (Terminated) then
        break;
      DoExitState;
      if (Terminated) then
        break;
      DoTransition;
      FState := FNextState;
    end;
    DoStop;
  finally
    if (Assigned(StateMachine.OnThreadStop)) then
      StateMachine.OnThreadStop(Self);
  end;
end;

procedure TStateThread.SetState(const Value: TStateControl);
begin
  FNextState := Value;
  if (Value = nil) then
    Terminate;
  if (State = nil) then
    SetEvent(FStartEvent);
end;

procedure TStateThread.Terminate;
begin
  inherited Terminate;
  SetEvent(FStartEvent);
end;

//******************************************************************************
//**
//**                    TStateMachine
//**
//******************************************************************************
constructor TStateMachine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle-[csSetCaption, csReplicatable]+[csDesignInteractive];
  FDesignMoving := dmNone;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BorderStyle := bsSingle;
  FOptions := [soSynchronize];
  Visible := (soInteractive in FOptions);
  FActive := False;
end;

destructor TStateMachine.Destroy;
begin
  Stop;
  StopThread;
  inherited Destroy;
end;

procedure TStateMachine.StopThread;
begin
  if (FThread <> nil) then
  begin
    FThread.Terminate;
    if (GetCurrentThreadID = MainThreadID) then
      FThread.WaitFor;
    FreeAndNil(FThread);
  end;
end;

procedure TStateMachine.StartThread;
begin
  if (FThread = nil) then
    FThread := TStateThread.Create(Self);
end;

procedure TStateMachine.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FState) and (Operation = opRemove) then
    FState := nil;

  if (AComponent is TStateControl) and (TStateControl(AComponent).StateMachine = self) then
    case Operation of
      opRemove:
        begin
          Invalidate;
//        FConnector: TStateConnector;
        end;
    end;
end;

procedure TStateMachine.Loaded;
begin
  inherited Loaded;
  if (FActive) then
  begin
    FActive := False;
    Execute;
  end;
end;

procedure TStateMachine.Execute;
var
  InitialState: TStateControl;
begin
  if (State = nil) then
    raise Exception.Create('No initial state specified');
  if (Active) then
    raise Exception.Create('Already executing');
  InitialState := FState;
  FState := nil;

  StartThread;
  FActive := True;

  State := InitialState;

  if (Wait) then
    while (Active) do
      Application.ProcessMessages;
end;

procedure TStateMachine.Stop;
begin
  if (not FActive) then
    exit;

  State := nil;
  FActive := False;
//  StopThread;
end;

procedure TStateMachine.SetActive(const Value: boolean);
begin
  if ([csLoading, csDesigning] * ComponentState = []) then
  begin
    if (Value = FActive) then
      exit;
    if (Value) then
      Execute
    else
      Stop;
  end else
    FActive := Value;
end;

function TStateMachine.GetState: TStateControl;
begin
  if (csDesigning in ComponentState) or (not Active) then
    Result := FState
  else
    Result := FThread.State;
end;

procedure TStateMachine.SetState(Value :TStateControl);
begin
  if (Value <> nil) and (Value.FStateMachine <> Self) then
    raise Exception.Create('Cannot change to state in another state machine');

  // Just set value at design and load time
  if ([csLoading, csDesigning] * ComponentState = []) or (Active) then
  begin
    ASSERT(FThread <> nil);
    FThread.State := Value
  end else
    FState := Value;
end;

function TStateMachine.HandlesTransitionEvent: boolean;
begin
  Result := Assigned(FOnChangeState);
end;

procedure TStateMachine.DoTransition;
begin
  if (Assigned(FOnChangeState)) then
    try
      FOnChangeState(Self, FThread.State, FThread.NextState);
    except
      DoException(nil);
    end;
end;

procedure TStateMachine.DoException(Node: TStateControl);
begin
  if (Assigned(FOnException)) then
    FOnException(Self, Node);
end;

procedure TStateMachine.DoStart;
begin
  if (Assigned(FOnStart)) then
    try
      FOnStart(Self);
    except
      DoException(nil);
    end;
end;

procedure TStateMachine.DoStop;
begin
  if (Assigned(FOnStop)) then
    try
      FOnStop(Self);
    except
      DoException(nil);
    end;
end;

procedure TStateMachine.DoOnSingleStep;
begin
  if (Assigned(FOnSingleStep)) then
    try
      FOnSingleStep(Self);
    except
      DoException(nil);
    end;
end;

procedure TStateMachine.Paint;
begin
  if (soInteractive in FOptions) or (csDesigning in ComponentState) then
  begin
    inherited Paint;
    if (FDesignMoving in [dmFirstHandle, dmLastHandle]) then
      FConnector.PaintFlipLine;
  end;
end;

procedure TStateMachine.CMDesignHitTest(var Msg: TWMMouse);
var
  NewPnt                : TPoint;
  i                     : integer;
  Connector             : TStateConnector;

  function TestConnector(Connector: TStateConnector; p: TPoint): boolean;
  var
    HandleRect          : TRect;
    j                   : TDesignMove;
  begin
    Result := False;
    if (Connector = nil) or not(Connector.GetLines(Lines)) then
      exit;

    for j := Low(Lines) to Pred(High(Lines)) do
    begin
      HandleRect := TStateConnector.MakeRect(Lines[j], Lines[Succ(j)]);
      InflateRect(HandleRect, SelectMarginX, SelectMarginY);
      if (PtInRect(HandleRect, p)) then
      begin
        Result := True;
        exit;
      end;
    end;
  end;

begin
{$IFDEF WIN32}
  NewPnt := SmallPointToPoint(Msg.Pos);
{$ELSE}
  NewPnt := Msg.Pos;
{$ENDIF}
  if (FDesignMoving <> dmNone) then
  begin
    Msg.Result := 1;
    exit;
  end;

  Msg.Result := 0;

  if not(ssLeft in KeysToShiftState(Msg.Keys)) then
    exit;

  if (TestConnector(FConnector, NewPnt)) then
  begin
    Msg.Result := 1;
    exit;
  end;

  for i := 0 to ControlCount-1 do
    if (Controls[i] is TStateControl) then
    begin
      Connector := (TStateControl(Controls[i]).HitTest(NewPnt));

      if not(TestConnector(Connector, NewPnt)) then
        continue;

      if (FConnector <> nil) and (FConnector <> Connector) then
      begin
        FConnector.Selected := False;
        Invalidate;
      end;

      FConnector := Connector;
      Connector.Selected := True;
      Connector.Paint;
      Msg.Result := 1;
      exit;
    end;

  if (FConnector <> nil) then
  begin
    FConnector.Selected := False;
    FConnector := nil;
    invalidate;
  end;
end;

procedure TStateMachine.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i                     : TDesignMove;
  HandleRect            : TRect;
  r                     : TRect;
begin
  if (csDesigning in ComponentState) and (FConnector <> nil) and
    (FConnector.GetLines(Lines)) then
    for i := dmFirstHandle to dmLastHandle do
    begin
      if (i = dmOffset) and (FConnector.ActualPath in [spTopLeft, spRightBottom]) then
        continue;
      HandleRect.TopLeft := Lines[i];
      HandleRect.BottomRight := HandleRect.TopLeft;
      InflateRect(HandleRect, SelectMarginX, SelectMarginY);
      if (PtInRect(HandleRect, Point(X,Y))) then
      begin
        FDesignMoving := i;
        MouseCapture := True;
        Canvas.Pen.Width := 3;
        Canvas.Pen.Mode := pmNotXor;
        FConnector.Paint;
        if (FDesignMoving in [dmFirstHandle, dmLastHandle]) then
        begin
          if (Lines[dmDestination].y > Lines[dmSource].y) then
          begin
            if (Lines[dmDestination].x > Lines[dmSource].x) then
              Screen.Cursor := crSizeNESW
            else
              Screen.Cursor := crSizeNWSE;
          end else
          begin
            if (Lines[dmDestination].x > Lines[dmSource].x) then
              Screen.Cursor := crSizeNWSE
            else
              Screen.Cursor := crSizeNESW;
          end;
          FConnector.PaintFlipLine;
        end else
        begin
          { Confine cursor }
          r := FConnector.MakeRect(ClientToScreen(Lines[dmSource]),
            ClientToScreen(Lines[dmDestination]));
          ClipCursor(@r);

          if (FConnector.ActualPath = spLeftRight) then
            Screen.Cursor := crHSplit
          else if (FConnector.ActualPath = spTopBottom) then
            Screen.Cursor := crVSplit;
        end;
        Canvas.Pen.Width := 1;
        Canvas.Pen.Mode := pmCopy;
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := clBlack;
        exit;
      end;
    end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TStateMachine.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Vector                        : TRect;
  NewOffset                     : integer;
  NewPath                       : TStatePath;
  DoPaint                       : Boolean;

  // Function to determine on which side of the vector c1->c2 the point a lies
  function cross(a: TPoint; c: TRect): integer;
  var
    b                   : TPoint;
  begin
    a := Point(a.x-c.Left, a.y-c.Top);
    b := Point(c.Right-c.Left, c.Bottom-c.Top);
    Result := (a.x*b.y)-(a.y*b.x);
  end;

  function NewState(OldState: TStatePath; Handle: TDesignMove; Diagonal: TRect;
    OldHandle, NewHandle: TPoint): TStatePath;
  const
    Paths: array[dmFirstHandle..dmLastHandle, spLeftRight..spRightBottom] of TStatePath =
      ((spTopLeft,spRightBottom,spLeftRight,spTopBottom),
       (spTopLeft,spRightBottom,spLeftRight,spTopBottom),//Dummy not used
       (spRightBottom, spTopLeft, spTopBottom, spLeftRight));
  begin
    if (cross(NewHandle, Diagonal)*cross(OldHandle, Diagonal) < 0) then
      Result := Paths[Handle, OldState]
    else
      Result := OldState;
  end;

begin
  if  (csDesigning in ComponentState) and (FDesignMoving <> dmNone) and
    (FConnector <> nil) then
  begin
    DoPaint := False;
    NewOffset := FConnector.Offset;
    NewPath := FConnector.Path;
    if (FDesignMoving in [dmFirstHandle, dmLastHandle]) then
    begin
      Vector.TopLeft :=  TStateConnector.RectCenter(FConnector.Source.BoundsRect);
      Vector.BottomRight :=  TStateConnector.RectCenter(FConnector.Destination.BoundsRect);
      NewPath := NewState(FConnector.ActualPath, FDesignMoving, Vector,
        Lines[FDesignMoving], Point(X,Y));
      if (NewPath <> FConnector.ActualPath) then
      begin
        DebugStr('Flip:'+IntToStr(Ord(NewPath)));
        DoPaint := True;
      end else
        DebugStr('Back:'+IntToStr(Ord(FConnector.ActualPath)));
    end else
    begin
      case (FConnector.ActualPath) of
        spLeftRight:
          NewOffset := FConnector.Offset+X-Lines[dmOffset].x;
        spTopBottom:
          NewOffset := FConnector.Offset+Y-Lines[dmOffset].y;
      end;
      DebugStr('Change offset:'+IntToStr(NewOffset));
      if (NewOffset <> FConnector.Offset) then
      begin
        DoPaint := True;
      end;
    end;
    if (DoPaint) then
    begin
      Canvas.Pen.Width := 3;
      Canvas.Pen.Mode := pmNotXor;
      FConnector.Paint;  // Erase previous

      FConnector.Offset := NewOffset;
      FConnector.Path := NewPath;
      FConnector.GetLines(Lines);

      FConnector.Paint; // Paint new
      Canvas.Pen.Width := 1;
      Canvas.Pen.Mode := pmCopy;
    end;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TStateMachine.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
{$IFNDEF VER90}
  Form                  : TCustomForm;
{$ELSE}
  Form                  : TForm;
{$ENDIF}
begin
  if (csDesigning in ComponentState) and (FDesignMoving <> dmNone) then
  begin
    DebugStr('StateMachine.MouseUp');
    Canvas.Pen.Mode := pmCopy;
    Form := GetParentForm(self);
    if (Form <> nil) and (Form.Designer <> nil) then
      Form.Designer.Modified;
    FDesignMoving := dmNone;
    Screen.Cursor := crDefault;
    ClipCursor(nil);
    MouseCapture := false;
    Invalidate;
  end;
  inherited MouseUp(Button, Shift, X, Y);
  Repaint;
end;

//******************************************************************************
//**
//**                    TStateConnector
//**
//******************************************************************************
constructor TStateConnector.Create(AOwner: TStateControl; OwnerRole: TStatePathOwner);
begin
  inherited Create;
  FOwner := OwnerRole;
  if (FOwner = poOwnedBySource) then
    FSource := AOwner
  else
    FDestination := AOwner;
  FPath := spAuto;
  FActualPath := FPath;
end;

procedure TStateConnector.SetPeer(Index: integer; Value: TStateControl);
begin
  if ((Index = 1) and (FOwner = poOwnedBySource)) or
    ((Index = 2) and (FOwner = poOwnedByDestination)) then
    raise Exception.Create('Cannot modify owner of connector');
  case (Index) of
    0: if (FOwner = poOwnedBySource) then
         FDestination := Value
       else
         FSource := Value;
    1: FSource := Value;
    2: FDestination := Value;
  end;
end;

function TStateConnector.GetPeer(Index: integer): TStateControl;
begin
  if (FOwner = poOwnedBySource) then
    Result := FDestination
  else
    Result := FSource;
end;

function TStateConnector.GetLines(var Lines: TConnectorLines): Boolean;
var
//  OverlapX            ,
  OverlapY              : Boolean;
  p1                    ,
  p2                    : TPoint;
  r1                    ,
  r2                    : TRect;
  dx                    ,
  dy                    : integer;
  d2x                   ,
  d2y                   : integer;
  DirectionX            ,
  DirectionY            : integer;
//                   +--------+
//                   |  Dest  |
//                d1 |   p2   | ^
//                   |        | |
//                   +--------+ |
//          ^            d2     |
//          |                   |
//         d2y                  |
//          |                   dy
//     s2   v                   |
// +--------+<--d2x->           |
// | Source |                   |
// |   p1   | s1                v
// |        |
// +--------+
//      <------- dx ----->

begin
  if (Source = nil) or (Destination = nil) then
  begin
    Result := False;
    exit;
  end;
  Result := True;


  r1 := Source.BoundsRect;
  r2 := Destination.BoundsRect;
  p1 := Point(r1.Left+Source.Width DIV 2,
    r1.Top+(Source.Height) DIV 2);
  p2 := Point(r2.Left+Destination.Width DIV 2,
    r2.Top+Destination.Height DIV 2);

  dx := p2.x-p1.x;
  dy := p2.y-p1.y;
  if (dx = 0) then
    DirectionX := 0
  else
    DirectionX := dx DIV ABS(dx);
  if (dy = 0) then
    DirectionY := 0
  else
    DirectionY := dy DIV ABS(dy);
  d2x := ABS(dx)-(Source.Width+Destination.Width) DIV 2;
  d2y := ABS(dy)-(Source.Height+Destination.Height) DIV 2;

//  OverlapX := (d2x <= OverlapXMargin);
  OverlapY := (d2y <= OverlapYMargin);

  FActualPath := Path;
  // Switch to auto if position makes path impossible
  if ((ActualPath = spRightBottom) and
      ((ABS(dx) - (Source.Width DIV 2) < OverlapXMargin) or
       (d2y + (Source.Height DIV 2) < OverlapYMargin)) or
     ((ActualPath = spTopLeft) and
      ((ABS(dy) - (Source.Height DIV 2) < OverlapYMargin) or
       (d2x + (Source.Width DIV 2) < OverlapXMargin)))) then
    FActualPath := spAuto;

  if (ActualPath in [spAuto, spDirect]) then
  begin
    if (OverlapY) or (d2x > d2y) then
      FActualPath := spLeftRight
    else
      FActualPath := spTopBottom;
  end else
    FActualPath := Path;

  case ActualPath of
    spLeftRight,
    spRightBottom:
      if (DirectionX > 0) then
        Lines[dmSource] := Point(r1.Right+1, p1.y)
      else if (DirectionX < 0) then
        Lines[dmSource] := Point(r1.Left-1, p1.y)
      else
        Lines[dmSource] := p1;
    spTopBottom,
    spTopLeft:
      if (DirectionY > 0) then
        Lines[dmSource] := Point(p1.x, r1.Bottom+1)
      else if (DirectionY < 0) then
        Lines[dmSource] := Point(p1.x, r1.Top-1)
      else
        Lines[dmSource] := p1;
  end;
  case ActualPath of
    spLeftRight,
    spTopLeft:
      if (DirectionX > 0) then
        Lines[dmDestination] := Point(r2.Left-1, p2.y)
      else if (DirectionX < 0) then
        Lines[dmDestination] := Point(r2.Right+1, p2.y)
      else
        Lines[dmDestination] := p2;
    spTopBottom,
    spRightBottom:
      if (DirectionY > 0) then
        Lines[dmDestination] := Point(p2.x, r2.Top-1)
      else if (DirectionY < 0) then
        Lines[dmDestination] := Point(p2.x, r2.Bottom+1)
      else
        Lines[dmDestination] := p2;
  end;
  if (Path = spDirect) then
    FActualPath := spDirect;

  case ActualPath of
    spDirect:
      begin
        dx := (Lines[dmDestination].x-Lines[dmSource].x) DIV 4;
        dy := (Lines[dmDestination].y-Lines[dmSource].y) DIV 4;
        Lines[dmFirstHandle] := Point(Lines[dmSource].x + dx, Lines[dmSource].y + dy);
        Lines[dmOffset] := Point(Lines[dmSource].x + dx*2, Lines[dmSource].y + dy*2);
        Lines[dmLastHandle] := Point(Lines[dmSource].x + dx*3, Lines[dmSource].y + dy*3);
      end;
    spLeftRight:
      begin
        Lines[dmFirstHandle] := Point(Lines[dmSource].x + DirectionX * d2x DIV 2, p1.y);
        Lines[dmLastHandle] := Point(Lines[dmSource].x + DirectionX * d2x DIV 2, p2.y);
      end;
    spTopBottom:
      begin
        Lines[dmFirstHandle] := Point(p1.x, Lines[dmSource].y + DirectionY * d2y DIV 2);
        Lines[dmLastHandle] := Point(p2.x, Lines[dmSource].y + DirectionY * d2y DIV 2);
      end;
    spRightBottom:
      begin
        Lines[dmFirstHandle] := Point(Lines[dmSource].x + (p2.x-Lines[dmSource].x) DIV 2, p1.y);
        Lines[dmLastHandle] := Point(p2.x, Lines[dmDestination].y - (Lines[dmDestination].y - p1.y) DIV 2);
      end;
    spTopLeft:
      begin
        Lines[dmFirstHandle] := Point(p1.x, Lines[dmSource].y + (p2.y-Lines[dmSource].y) DIV 2);
        Lines[dmLastHandle] := Point(Lines[dmDestination].x - (Lines[dmDestination].x - p1.x) DIV 2, p2.y);
      end;
  end;
  case ActualPath of
    spLeftRight:
      begin
        Lines[dmFirstHandle].x := Lines[dmFirstHandle].x + Offset;
        Lines[dmLastHandle].x := Lines[dmFirstHandle].x;
        Lines[dmOffset] := Point(Lines[dmFirstHandle].x,
          Lines[dmFirstHandle].y+(Lines[dmLastHandle].y-Lines[dmFirstHandle].y) DIV 2);
      end;
    spTopLeft:
      Lines[dmOffset] := Point(Lines[dmFirstHandle].x, Lines[dmLastHandle].y);
    spTopBottom:
      begin
        Lines[dmFirstHandle].y := Lines[dmFirstHandle].y + Offset;
        Lines[dmLastHandle].y := Lines[dmFirstHandle].y;
        Lines[dmOffset] := Point(Lines[dmFirstHandle].x+(Lines[dmLastHandle].x-Lines[dmFirstHandle].x) DIV 2,
          Lines[dmFirstHandle].y);
      end;
    spRightBottom:
      Lines[dmOffset] := Point(Lines[dmLastHandle].x, Lines[dmFirstHandle].y);
  end;
end;

class function TStateConnector.MakeRect(pa, pb: TPoint): TRect;
  function Min(a,b: integer): integer;
  begin
    if (a <= b) then
      Result := a
    else
      Result := b;
  end;

  function Max(a,b: integer): integer;
  begin
    if (a >= b) then
      Result := a
    else
      Result := b;
  end;
begin
  Result.TopLeft := Point(Min(pa.x, pb.x), Min(pa.y, pb.y));
  Result.BottomRight := Point(Max(pa.x, pb.x), Max(pa.y, pb.y));
end;

class function TStateConnector.RectCenter(r: TRect): TPoint;
begin
  Result.x := r.Left+(r.Right-r.Left) DIV 2;
  Result.y := r.Top+(r.Bottom-r.Top) DIV 2;
end;

procedure TStateConnector.Paint;
var
  Lines                 : TConnectorLines;
  Arrow                 : array[0..2] of TPoint;
  i                     : TDesignMove;
  Direction             : integer;
  Size                  : integer;
  SaveWidth             : integer;
  WorkPath              : TStatePath;
//  LogBrush            : TLogBrush;

begin
  if not(GetLines(Lines)) then
    exit;

  Source.StateMachine.Canvas.Pen.Style := psSolid;
//  Source.StateMachine.Canvas.Pen.Color := clBlack;

  Source.StateMachine.Canvas.Brush.Style := bsSolid;
  Source.StateMachine.Canvas.Brush.Color := Source.StateMachine.Canvas.Pen.Color;

  Size := Source.StateMachine.Canvas.Pen.Width DIV 2;
  Arrow[0] := Lines[dmDestination];
  if (ActualPath = spDirect) then
  begin
    if (ABS(Lines[dmDestination].x-Lines[dmSource].x) >
      ABS(Lines[dmDestination].y-Lines[dmSource].y)) then
      WorkPath := spLeftRight
    else
      WorkPath := spTopBottom;
  end else
    WorkPath := ActualPath;

  case WorkPath of
    spLeftRight,
    spTopLeft:
      begin
        Direction := Lines[dmDestination].x-Lines[dmLastHandle].x;
        if (Direction <> 0) then
          Direction := Direction DIV ABS(Direction);

        Lines[dmDestination].x :=
          Lines[dmDestination].x-Source.StateMachine.Canvas.Pen.Width*Direction;
        Arrow[1] := Point(Arrow[0].x-(3+Size)*Direction, Arrow[0].y-(3+Size));
        Arrow[2] := Point(Arrow[0].x-(3+Size)*Direction, Arrow[0].y+(3+Size));
      end;
    spTopBottom,
    spRightBottom:
      begin
        Direction := Lines[dmDestination].y-Lines[dmLastHandle].y;
        if (Direction <> 0) then
          Direction := Direction DIV ABS(Direction);

        Lines[dmDestination].y :=
          Lines[dmDestination].y-Source.StateMachine.Canvas.Pen.Width*Direction;
        Arrow[1] := Point(Arrow[0].x-(3+Size), Arrow[0].y-(3+Size)*Direction);
        Arrow[2] := Point(Arrow[0].x+(3+Size), Arrow[0].y-(3+Size)*Direction);
      end;
  end;

{
  LogBrush.lbStyle := BS_SOLID;
  LogBrush.lbColor := clGreen;

  Source.StateMachine.Canvas.Pen.Handle := ExtCreatePen(
    PS_GEOMETRIC or PS_SOLID or PS_ENDCAP_FLAT or PS_JOIN_ROUND, // PS_JOIN_BEVEL,
    Source.StateMachine.Canvas.Pen.Width,
    LogBrush, // CONST LOGBRUSH *  lplb,        // address of structure for brush attributes
    0, nil);
}
  Source.StateMachine.Canvas.PolyLine(Lines);

  SaveWidth := Source.StateMachine.Canvas.Pen.Width;
  Source.StateMachine.Canvas.Pen.Width := 1;
  Source.StateMachine.Canvas.Polygon(Arrow);
  Source.StateMachine.Canvas.Pen.Width := SaveWidth;

  if (csDesigning in Source.StateMachine.ComponentState) then
  begin
    if (Selected) and (Source.StateMachine.FConnector = self) then
      for i := dmFirstHandle to dmLastHandle do
      begin
        if (i <> dmOffset) or not(ActualPath in [spTopLeft, spRightBottom]) then
          Source.StateMachine.Canvas.Rectangle(Lines[i].x-2, Lines[i].y-2, Lines[i].x+2, Lines[i].y+2);
      end;

    BoundsRect := MakeRect(Lines[dmSource], Lines[dmDestination]);
    InflateRect(BoundsRect, SelectMarginX, SelectMarginY);
  end;
end;

procedure TStateConnector.PaintFlipLine;
var
  p                     : TPoint;
begin
  if (Source <> nil) and (Destination <> nil) then
  begin
    Source.StateMachine.Canvas.Pen.Width := 1;
    Source.StateMachine.Canvas.Pen.Mode := pmXor;
    Source.StateMachine.Canvas.Pen.Style := psDot;
    Source.StateMachine.Canvas.Pen.Color := clWhite;
    p := TStateConnector.RectCenter(Source.BoundsRect);
    Source.StateMachine.Canvas.MoveTo(p.x, p.y);
    p := TStateConnector.RectCenter(Destination.BoundsRect);
    Source.StateMachine.Canvas.LineTo(p.x, p.y);
    Source.StateMachine.Canvas.Pen.Width := 1;
    Source.StateMachine.Canvas.Pen.Mode := pmCopy;
    Source.StateMachine.Canvas.Pen.Style := psSolid;
    Source.StateMachine.Canvas.Pen.Color := clBlack;
  end;
end;

function TStateConnector.HitTest(Mouse: TPoint): Boolean;
begin
  Result := PtInRect(BoundsRect, Mouse);
end;

//******************************************************************************
//**
//**                    TStateControl
//**
//******************************************************************************
constructor TStateControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited SetBounds(0, 0, 69, 41);
  FConnectors := TList.Create;
  ShowHint := True;
end;

destructor TStateControl.Destroy;
begin
  FConnectors.Free;
  inherited Destroy;
end;

function TStateControl.AddConnector(OwnerRole: TStatePathOwner): TStateConnector;
begin
  Result := TStateConnector.Create(self, OwnerRole);
  Connectors.Add(Result);
end;

procedure TStateControl.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Connectors', ReadConnectors, WriteConnectors,
    (Connectors.Count > 0));
end;

procedure TStateControl.WriteConnectors(Writer: TWriter);
var
  i                     : integer;
begin
  Writer.WriteListBegin;
  try
    for i := 0 to Connectors.Count-1 do
    begin
      Writer.WriteInteger(ord(TStateConnector(Connectors[i]).Path));
      Writer.WriteInteger(TStateConnector(Connectors[i]).Offset);
    end;
  finally
    Writer.WriteListEnd;
  end;
end;

procedure TStateControl.ReadConnectors(Reader: TReader);
var
  i                     : integer;
begin
  Reader.ReadListBegin;
  try
    i := 0;
    while not(Reader.EndOfList) do
    begin
      if (i < Connectors.Count) then
      begin
        TStateConnector(Connectors[i]).Path := TStatePath(Reader.ReadInteger);
        TStateConnector(Connectors[i]).Offset := Reader.ReadInteger;
      end else
        Reader.ReadInteger;
      inc(i);
    end;
  finally
    Reader.ReadListEnd;
  end;
end;

procedure TStateControl.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if (AParent <> nil) and not(AParent is TStateMachine) then
    raise Exception.Create(ClassName+' must have a TStateMachine as parent');
  FStateMachine := TStateMachine(AParent);
end;

procedure TStateControl.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if (FStateMachine <> nil) then
    FStateMachine.Invalidate;
end;

function TStateControl.GetCheckStateMachine: TStateMachine;
begin
  if (FStateMachine = nil) then
    raise Exception.Create('Orphan '+ClassName);
  Result := FStateMachine;
end;

procedure TStateControl.SetHint(Value: string);
begin
  inherited Hint := Value;
  invalidate;
end;

function TStateControl.GetHint: string;
begin
  Result := inherited Hint;
end;

procedure TStateControl.SetActive(Value: boolean);
begin
  if not(Value) then
    CheckStateMachine.State := nil
  else
    CheckStateMachine.State := self;
end;

function TStateControl.GetActive: boolean;
begin
  Result := (CheckStateMachine.State = self);
end;

procedure TStateControl.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  case (Element) of
    veShadow:
      begin
        Canvas.Pen.Width := 1;
        Canvas.Pen.Color := clGray;
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Mode := pmCopy;
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := clGray;
      end;
    veFrame:
      begin
        Canvas.Pen.Color := clBlack;
        Canvas.Pen.Style := psInsideFrame;
        Canvas.Pen.Mode := pmCopy;
        if (Active) then
          Canvas.Pen.Width := 2
        else
          Canvas.Pen.Width := 1;
      end;
    vePanel:
      begin
        Canvas.Brush.Style := bsSolid;
        if (Active) then
          Canvas.Brush.Color := clRed
        else
          Canvas.Brush.Color := clWhite;
      end;
    veText:
      begin
        Canvas.Brush.Style := bsClear;
        if (Active) then
          Canvas.Font.Color := clWhite
        else
          Canvas.Font.Color := clBlack;
      end;
    veConnector:
      begin
        Canvas.Pen.Width := 1;
        Canvas.Pen.Color := clBlack;
      end;
  end;
end;

procedure TStateControl.DrawText(Rect: TRect);
var
  Opt: integer;
  r: TRect;
begin
  if (Hint <> '') then
    Caption := Hint
  else
    Caption := Name;
  Opt := DT_CENTER or DT_NOPREFIX or DT_WORDBREAK;
  r := Rect;
  windows.DrawText(Canvas.Handle, PChar(Caption), Length(Caption), r, Opt or DT_CALCRECT);
  OffsetRect(r, ((Rect.Right-Rect.Left)-(r.Right-r.Left)) div 2, ((Rect.Bottom-Rect.Top)-(r.Bottom-r.Top)) div 2);
  windows.DrawText(Canvas.Handle, PChar(Caption), Length(Caption), r, Opt);
(*
  if (Canvas.TextWidth(Caption) >= TextRect.Right-TextRect.Left) then
    Opt := Opt DT_VCENTER or
  else
    Opt := Opt or DT_SINGLELINE;
  windows.DrawText(Canvas.Handle, PChar(Caption), -1, Rect, Opt);
*)
end;

procedure TStateControl.DoPaint;
var
  r                     : TRect;
begin
  // Draw shadow
  PrepareCanvas(veShadow, Canvas);
  r.TopLeft :=  Point(ShadowHeight,ShadowHeight);
  r.BottomRight := Point(Width, Height);
  Canvas.FillRect(r);
  // Draw rectangle
  PrepareCanvas(veFrame, Canvas);
  PrepareCanvas(vePanel, Canvas);
  OffsetRect(r, -ShadowHeight, -ShadowHeight);
  Canvas.Rectangle(r.Left, r.Top, r.Right, r.Bottom);
  // Draw name
  PrepareCanvas(veText, Canvas);
  // Margin for text
  InflateRect(r, -Canvas.Pen.Width, -Canvas.Pen.Width);
  DrawText(r);
end;

procedure TStateControl.PaintConnector;
begin
  PrepareCanvas(veConnector, StateMachine.Canvas);
end;

procedure TStateControl.Paint;
begin
  if (FPainting) then
    raise Exception.Create('Recursion detected in TStateControl.Paint');
  FPainting := True;
  try
    inherited Paint;
    DoPaint;
    PaintConnector;
    // StateMachine.Canvas.Pen.Width := 1;
  finally
    FPainting := False;
  end;
end;

procedure TStateControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = self) and (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

procedure TStateControl.DoEnter;
begin
  try
    if (Assigned(FOnEnterState)) then
      FOnEnterState(Self);
  except
    DoException;
  end;
end;

procedure TStateControl.DoExit;
begin
  try
    if (Assigned(FOnExitState)) then
      FOnExitState(Self);
  except
    DoException;
  end;
end;

procedure TStateControl.DoException;
begin
  StateMachine.DoException(Self);
end;

function TStateControl.HandlesEnterEvent: boolean;
begin
  Result := Assigned(FOnEnterState);
end;

function TStateControl.HandlesExitEvent: boolean;
begin
  Result := Assigned(FOnExitState);
end;

function TStateControl.Default: TStateControl;
begin
  Result := nil;
end;

function TStateControl.HitTest(Mouse: TPoint): TStateConnector;
begin
  Result := nil;
end;

//******************************************************************************
//**
//**                    TStateNodeBase
//**
//******************************************************************************
procedure TStateNodeBase.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);

  // First state will be used as default
  if (StateMachine <> nil) and (StateMachine.State = nil) then
    StateMachine.State := self;
end;

//******************************************************************************
//**
//**                    TStateNode
//**
//******************************************************************************
constructor TStateNode.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FToConnector := AddConnector(poOwnedBySource);
//  ControlStyle := [csCaptureMouse, { csOpaque, } csDoubleClicks];
end;

destructor TStateNode.Destroy;
begin
  FToConnector.Free;
  inherited Destroy;
end;

procedure TStateNode.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  FToConnector.Offset := 0;
end;

procedure TStateNode.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FDefaultTransition) then
    begin
      FDefaultTransition := nil;
      FToConnector.Destination := nil;
    end;
  end;
end;

procedure TStateNode.PaintConnector;
begin
  inherited PaintConnector;
  StateMachine.Canvas.Pen.Width := 2;
  FToConnector.Paint;
end;

function TStateNode.HitTest(Mouse: TPoint): TStateConnector;
begin
  Result := nil;
  if (FToConnector.HitTest(Mouse)) then
    Result := FToConnector;
end;

procedure TStateNode.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  if (Element = veText) and
    not(Assigned(OnEnterState) or (csDesigning in ComponentState)) then
    Canvas.Font.Color := clGray;
end;

procedure TStateNode.SetDefaultTransition(Value: TStateControl);
begin
  FDefaultTransition := Value;
  FToConnector.Destination := Value;
  if (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

function TStateNode.Default: TStateControl;
begin
  Result := DefaultTransition;
end;

//******************************************************************************
//**
//**                    TStateStart
//**
//******************************************************************************
procedure TStateStart.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  case (Element) of
    veText:
      Canvas.Font.Style := [fsBold];
    veFrame:
      Canvas.Pen.Color := clGreen;
  end;
end;

//******************************************************************************
//**
//**                    TStateStop
//**
//******************************************************************************
procedure TStateStop.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  case (Element) of
    veText:
      Canvas.Font.Style := [fsBold];
    veFrame:
      Canvas.Pen.Color := clRed;
  end;
end;

//******************************************************************************
//**
//**                    TStateBoolean
//**
//******************************************************************************
constructor TStateBoolean.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDefault := True;
  FTrueConnector := AddConnector(poOwnedBySource);
  FFalseConnector := AddConnector(poOwnedBySource);
end;

destructor TStateBoolean.Destroy;
begin
  FTrueConnector.Free;
  FFalseConnector.Free;

  inherited Destroy;
end;

procedure TStateBoolean.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  FTrueConnector.Offset := 0;
  FFalseConnector.Offset := 0;
end;

procedure TStateBoolean.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FTrueState) then
    begin
      FTrueState := nil;
      FTrueConnector.Destination := nil;
    end;
    if (AComponent = FFalseState) then
    begin
      FFalseState := nil;
      FFalseConnector.Destination := nil;
    end;
  end;
end;

procedure TStateBoolean.PaintConnector;
begin
  inherited PaintConnector;
  if (DefaultState) then
    StateMachine.Canvas.Pen.Width := 2
  else
    StateMachine.Canvas.Pen.Width := 1;
  StateMachine.Canvas.Pen.Color := clGreen;
  FTrueConnector.Paint;

  if not(DefaultState) then
    StateMachine.Canvas.Pen.Width := 2
  else
    StateMachine.Canvas.Pen.Width := 1;
  StateMachine.Canvas.Pen.Color := clRed;
  FFalseConnector.Paint;
end;

function TStateBoolean.HitTest(Mouse: TPoint): TStateConnector;
begin
  Result := nil;
  if (FTrueConnector.HitTest(Mouse)) then
    Result := FTrueConnector
  else if (FFalseConnector.HitTest(Mouse)) then
    Result := FFalseConnector;
end;

procedure TStateBoolean.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  case (Element) of
    veText:
      if not(Assigned(OnEnterState) or (csDesigning in ComponentState)) then
        Canvas.Font.Color := clGray;
    veShadow:
      Canvas.Pen.Color := clBlack;
  end;
end;

procedure TStateBoolean.DoPaint;
var
  r                     : TRect;
  Diamond               : array[0..3] of TPoint;
begin
  // Draw shadow
  PrepareCanvas(veShadow, Canvas);
  Diamond[0] := Point(0, Height DIV 2);
  Diamond[1] := Point(Width DIV 2, 0);
  Diamond[2] := Point(Width-1, Height DIV 2);
  Diamond[3] := Point(Width DIV 2, Height-1);
  Canvas.Polygon(Diamond);
  // Draw rectangle
  PrepareCanvas(veFrame, Canvas);
  PrepareCanvas(vePanel, Canvas);
  r := Rect(Width DIV 7, Height DIV 7,Width-(Width DIV 7), Height-(Height DIV 7));
  Canvas.Rectangle(r.left, r.top, r.right, r.bottom);
  // Draw name
  PrepareCanvas(veText, Canvas);
  InflateRect(r, -Canvas.Pen.Width, -Canvas.Pen.Width);
  DrawText(r);
end;

procedure TStateBoolean.SetTrueState(Value :TStateControl);
begin
  FTrueState := Value;
  FTrueConnector.Destination := Value;
  // True and False should not be the same
  if (Value <> nil) and (FFalseState = Value) then
    FFalseState := nil;
  if (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

procedure TStateBoolean.SetFalseState(Value :TStateControl);
begin
  FFalseState := Value;
  FFalseConnector.Destination := Value;
  // True and False should not be the same
  if (Value <> nil) and (FtrueState = Value) then
    FTrueState := nil;
  if (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

procedure TStateBoolean.SetDefault(Value :Boolean);
begin
  if (Value <> FDefault) then
  begin
    FDefault := Value;
    StateMachine.Invalidate; // To erase previous fat line
    // Invalidate;
  end;
end;

function TStateBoolean.HandlesEnterEvent: boolean;
begin
  Result := inherited HandlesEnterEvent or Assigned(FOnEnterState);
end;

procedure TStateBoolean.DoEnter;
begin
  inherited DoEnter;
  FResult := DefaultState;
  if (Assigned(FOnEnterState)) then
  begin
    try
      FOnEnterState(Self, FResult);
    except
      DoException;
    end;
    if (StateMachine.State = Self) then
    begin
      if (FResult) then
      begin
        if (Assigned(FTrueState)) then
          StateMachine.State := FTrueState;
      end else
      begin
        if (Assigned(FFalseState)) then
          StateMachine.State := FFalseState;
      end;
    end;
  end;
end;

function TStateBoolean.Default: TStateControl;
begin
  if (DefaultState) then
    Result := TrueState
  else
    Result := FalseState;
end;

//******************************************************************************
//**
//**                    TStateTransition
//**
//******************************************************************************
constructor TStateTransition.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FToConnector := AddConnector(poOwnedBySource);
  FFromConnector := AddConnector(poOwnedByDestination);
  SetBounds(0, 0, 89, 41);
end;

destructor TStateTransition.Destroy;
begin
  FFromState := nil;
  FFromConnector.Free;
  FToState := nil;
  FToConnector.Free;
  inherited Destroy;
end;

procedure TStateTransition.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
end;

procedure TStateTransition.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  FToConnector.Offset := 0;
  FFromConnector.Offset := 0;
end;

procedure TStateTransition.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (FFromState = AComponent) then
    begin
      FFromState := nil;
      FFromConnector.Source := nil;
    end;
    if (FToState = AComponent) then
    begin
      FToState := nil;
      FToConnector.Destination := nil;
    end;
  end;
end;

procedure TStateTransition.PaintConnector;
begin
  inherited PaintConnector;
  StateMachine.Canvas.Pen.Width := 1;
  FFromConnector.Paint;
  FToConnector.Paint;
end;

function TStateTransition.HitTest(Mouse: TPoint): TStateConnector;
begin
  Result := nil;
  if (FToConnector.HitTest(Mouse)) then
    Result := FToConnector
  else
    if (FFromConnector.HitTest(Mouse)) then
      Result := FFromConnector;
end;

procedure TStateTransition.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  case (Element) of
    veText:
      if not((Assigned(FFromState)) and (Assigned(FToState)) or
        (csDesigning in ComponentState)) then
        Canvas.Font.Color := clGray;
  end;
end;

procedure TStateTransition.DoPaint;
var
  RoundSize             : integer;
  r                     : TRect;
begin
  RoundSize := 16;
  if (Height < RoundSize) then
    RoundSize := Height;
  if (Width < RoundSize) then
    RoundSize := Width;

  // Draw shadow
  PrepareCanvas(veShadow, Canvas);
  Canvas.RoundRect(ShadowHeight,ShadowHeight, Width, Height, RoundSize,RoundSize);
  // Draw rectangle
  PrepareCanvas(veFrame, Canvas);
  PrepareCanvas(vePanel, Canvas);
  Canvas.RoundRect(0,0, Width-ShadowHeight,Height-ShadowHeight, RoundSize,RoundSize);
  // Draw name
  PrepareCanvas(veText, Canvas);
  r := Rect(ShadowHeight+1,ShadowHeight+1,Width-(Canvas.Pen.Width+1), Height-(Canvas.Pen.Width+1));
  DrawText(r);
end;

procedure TStateTransition.SetFromState(Value :TStateControl);
begin
  if (Value <>  nil) and (Value.StateMachine <> CheckStateMachine) then
    raise Exception.Create('Cannot link to state in other state machine');
  FFromState := Value;
  FFromConnector.Source := Value;
  if (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

procedure TStateTransition.SetToState(Value :TStateControl);
begin
  if (Value <>  nil) and (Value.StateMachine <> CheckStateMachine) then
    raise Exception.Create('Cannot link to state in other state machine');
  FToState := Value;
  FToConnector.Destination := Value;
  if (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

function TStateTransition.HandlesEnterEvent: boolean;
begin
  Result := inherited HandlesEnterEvent or Assigned(FOnTransition);
end;

procedure TStateTransition.DoEnter;
begin
  inherited DoEnter;
  try
    if (Assigned(FOnTransition)) then
      FOnTransition(self);
  except
    DoException;
  end;
end;

function TStateTransition.Default: TStateControl;
begin
  Result := ToState;
end;

//******************************************************************************
//**
//**                    TStateLink
//**
//******************************************************************************
constructor TStateLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDirection := ldOutgoing;
  FConnector := AddConnector(poOwnedBySource);
  SetBounds(0, 0, 41, 41);
end;

destructor TStateLink.Destroy;
begin
  FConnector.Free;
  FDestination := nil;
  inherited Destroy;
end;

procedure TStateLink.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
end;

procedure TStateLink.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (AWidth <> Width) then
    AHeight := AWidth
  else if (AHeight <> Height) then
    AWidth := AHeight;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  FConnector.Offset := 0;
end;

procedure TStateLink.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (FDestination = AComponent) then
    begin
      if (Direction = ldOutgoing) then
        FConnector.Destination := nil;
      FDestination := nil;
    end;
  end;
end;

procedure TStateLink.PaintConnector;
begin
  inherited PaintConnector;
  FConnector.Paint;
end;

function TStateLink.HitTest(Mouse: TPoint): TStateConnector;
begin
  Result := nil;
  if (FConnector.HitTest(Mouse)) then
    Result := FConnector;
end;

procedure TStateLink.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  case (Element) of
    veText:
      if not(Assigned(FDestination) or (csDesigning in ComponentState)) then
        Canvas.Font.Color := clGray;
  end;
end;

procedure TStateLink.DoPaint;
var
  r                     : TRect;
begin
  // Draw shadow
  PrepareCanvas(veShadow, Canvas);
  r.TopLeft :=  Point(ShadowHeight,ShadowHeight);
  r.BottomRight := Point(Width, Height);
  Canvas.Ellipse(r.Left, r.Top, r.Right, r.Bottom);
  // Draw rectangle
  PrepareCanvas(veFrame, Canvas);
  PrepareCanvas(vePanel, Canvas);
  OffsetRect(r, -r.Left, -r.Top);
  Canvas.Ellipse(r.Left, r.Top, r.Right, r.Bottom);
  // Draw name
  PrepareCanvas(veText, Canvas);
  // Margin for text
  InflateRect(r, -Canvas.Pen.Width, -Canvas.Pen.Width);
  DrawText(r);
end;

procedure TStateLink.SetDestination(Value :TStateControl);
begin
  if (Value <>  nil) and (Value.StateMachine <> CheckStateMachine) then
    raise Exception.Create('Cannot connect to node in other state machine');

  if (Value = Self) then
    raise Exception.Create('Cannot connect link to self');

  FDestination := Value;

  if (Value <>  nil) then
  begin
    if (Value is TStateLink) then
    begin
      FDirection := ldOutgoing;
      FConnector.Destination := nil;
    end else
    begin
      FDirection := ldIncoming;
      FConnector.Destination := Value;
    end;

    FConnector.Paint;
  end;
  StateMachine.Invalidate;
end;

procedure TStateLink.SetDirection(Value :TLinkDirection);
begin
  if (Value <> FDirection) then
  begin
    FDirection := Value;
    Destination := nil;
    StateMachine.Invalidate;
  end;
end;

function TStateLink.Default: TStateControl;
begin
  Result := Destination;
end;

end.
