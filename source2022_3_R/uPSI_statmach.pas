unit uPSI_statmach;
{
maXbox463   add statecontrol

}
interface
 

 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_statmach = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStateLink(CL: TPSPascalCompiler);
procedure SIRegister_TStateLinkBase(CL: TPSPascalCompiler);
procedure SIRegister_TStateTransition(CL: TPSPascalCompiler);
procedure SIRegister_TStateStop(CL: TPSPascalCompiler);
procedure SIRegister_TStateStart(CL: TPSPascalCompiler);
procedure SIRegister_TStateNode(CL: TPSPascalCompiler);
procedure SIRegister_TStateBoolean(CL: TPSPascalCompiler);
procedure SIRegister_TStateConnector(CL: TPSPascalCompiler);
procedure SIRegister_TStateNodeBase(CL: TPSPascalCompiler);
procedure SIRegister_TStateControl(CL: TPSPascalCompiler);
procedure SIRegister_TStateThread(CL: TPSPascalCompiler);
procedure SIRegister_TStateMachine(CL: TPSPascalCompiler);
procedure SIRegister_statmach(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_statmach_Routines(S: TPSExec);
procedure RIRegister_TStateLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStateLinkBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStateTransition(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStateStop(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStateStart(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStateNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStateBoolean(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStateConnector(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStateNodeBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStateControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStateThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStateMachine(CL: TPSRuntimeClassImporter);
procedure RIRegister_statmach(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ExtCtrls
  ,Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,statmach
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_statmach]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStateLinkBase', 'TStateLink') do
  with CL.AddClassN(CL.FindClass('TStateLinkBase'),'TStateLink') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SetBounds( ALeft, ATop, AWidth, AHeight : Integer)');
    RegisterMethod('Procedure PaintConnector');
    RegisterMethod('Function HitTest( Mouse : TPoint) : TStateConnector');
    RegisterMethod('Procedure Free');
     RegisterProperty('Destination', 'TStateControl', iptrw);
    RegisterProperty('Direction', 'TLinkDirection', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateLinkBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStateControl', 'TStateLinkBase') do
  with CL.AddClassN(CL.FindClass('TStateControl'),'TStateLinkBase') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateTransition(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStateControl', 'TStateTransition') do
  with CL.AddClassN(CL.FindClass('TStateControl'),'TStateTransition') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SetBounds( ALeft, ATop, AWidth, AHeight : Integer)');
    RegisterMethod('Procedure PaintConnector');
    RegisterMethod('Function HitTest( Mouse : TPoint) : TStateConnector');
    RegisterMethod('Procedure Free');
     RegisterProperty('FromState', 'TStateControl', iptrw);
    RegisterProperty('ToState', 'TStateControl', iptrw);
    RegisterProperty('OnTransition', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateStop(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStateControl', 'TStateStop') do
  with CL.AddClassN(CL.FindClass('TStateControl'),'TStateStop') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateStart(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStateNode', 'TStateStart') do
  with CL.AddClassN(CL.FindClass('TStateNode'),'TStateStart') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStateNodeBase', 'TStateNode') do
  with CL.AddClassN(CL.FindClass('TStateNodeBase'),'TStateNode') do begin
  RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SetBounds( ALeft, ATop, AWidth, AHeight : Integer)');
    RegisterMethod('Procedure PaintConnector');
    RegisterMethod('Function HitTest( Mouse : TPoint) : TStateConnector');
    RegisterProperty('DefaultTransition', 'TStateControl', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateBoolean(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStateNodeBase', 'TStateBoolean') do
  with CL.AddClassN(CL.FindClass('TStateNodeBase'),'TStateBoolean') do begin
     RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SetBounds( ALeft, ATop, AWidth, AHeight : Integer)');
    RegisterMethod('Procedure PaintConnector');
    RegisterMethod('Function HitTest( Mouse : TPoint) : TStateConnector');
    RegisterMethod('Procedure Free');
     RegisterProperty('OnEnterState', 'TBooleanStateEvent', iptrw);
    RegisterProperty('TrueState', 'TStateControl', iptrw);
    RegisterProperty('FalseState', 'TStateControl', iptrw);
    RegisterProperty('DefaultState', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateConnector(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStateConnector') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStateConnector') do begin
    RegisterMethod('Constructor Create( AOwner : TStateControl; OwnerRole : TStatePathOwner)');
    RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Paint');
    RegisterMethod('Procedure PaintFlipLine');
    RegisterMethod('Function HitTest( Mouse : TPoint) : Boolean');
    RegisterMethod('Function GetLines( var Lines : TConnectorLines) : Boolean');
    RegisterMethod('Function MakeRect( pa, pb : TPoint) : TRect');
    RegisterMethod('Function RectCenter( r : TRect) : TPoint');
    RegisterProperty('Source', 'TStateControl', iptrw);
    RegisterProperty('Destination', 'TStateControl', iptrw);
    RegisterProperty('PeerNode', 'TStateControl', iptrw);
    RegisterProperty('ActualPath', 'TStatePath', iptr);
    RegisterProperty('Selected', 'Boolean', iptrw);
    RegisterProperty('Path', 'TStatePath', iptrw);
    RegisterProperty('Offset', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateNodeBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStateControl', 'TStateNodeBase') do
  with CL.AddClassN(CL.FindClass('TStateControl'),'TStateNodeBase') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TStateControl') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TStateControl') do begin
     RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SetBounds( ALeft, ATop, AWidth, AHeight : Integer)');
    RegisterMethod('Procedure Free');
     RegisterMethod('Procedure PaintConnector');
    RegisterMethod('Function HitTest( Mouse : TPoint) : TStateConnector');
    RegisterProperty('StateMachine', 'TStateMachine', iptr);
    RegisterProperty('Active', 'boolean', iptrw);
    RegisterProperty('Connectors', 'TObjectList', iptr);
    RegisterProperty('OnEnterState', 'TNotifyEvent', iptrw);
    RegisterProperty('OnExitState', 'TNotifyEvent', iptrw);
    RegisterProperty('Hint', 'string', iptrw);
    RegisterProperty('Synchronize', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TStateThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TStateThread') do
  begin
    RegisterMethod('Constructor Create( AStateMachine : TStateMachine)');
    RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Terminate');
    RegisterProperty('StateMachine', 'TStateMachine', iptr);
    RegisterProperty('State', 'TStateControl', iptrw);
    RegisterProperty('NextState', 'TStateControl', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStateMachine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPanel', 'TStateMachine') do
  with CL.AddClassN(CL.FindClass('TCustomPanel'),'TStateMachine') do begin
   RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Execute( Wait : boolean)');
    RegisterMethod('Procedure Stop');
    RegisterProperty('Active', 'boolean', iptrw);
    RegisterProperty('State', 'TStateControl', iptrw);
    RegisterProperty('Options', 'TStateMachineOptions', iptrw);
    RegisterProperty('OnChangeState', 'TChangeStateEvent', iptrw);
    RegisterProperty('OnException', 'TStateExceptionEvent', iptrw);
    RegisterProperty('OnStart', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStop', 'TNotifyEvent', iptrw);
    RegisterProperty('OnThreadStart', 'TNotifyEvent', iptrw);
    RegisterProperty('OnThreadStop', 'TNotifyEvent', iptrw);
    RegisterProperty('OnSingleStep', 'TNotifyEvent', iptrw);
       RegisterProperty('ALIGN', 'TALIGN', iptrw);
      //RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_statmach(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('SM_STATE_TRANSITION','400').SetString( WM_USER);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStateThread');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStateMachine');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStateControl');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStateConnector');
  CL.AddTypeS('TChangeStateEvent', 'Procedure ( Sender : TStateMachine; FromState, ToState : TStateControl)');
  CL.AddTypeS('TStateExceptionEvent', 'Procedure ( Sender : TStateMachine; Node : TStateControl)');
  CL.AddTypeS('TStateMachineOption', '( soInteractive, soSingleStep, soSynchronize )');
  CL.AddTypeS('TStateMachineOptions', 'set of TStateMachineOption');
  CL.AddTypeS('TDesignMove', '( dmSource, dmFirstHandle, dmOffset, dmLastHandle, dmDestination, dmNone )');
  SIRegister_TStateMachine(CL);
  SIRegister_TStateThread(CL);
  CL.AddTypeS('TTransitionDirection', '( tdFrom, tdTo )');
  CL.AddTypeS('TVisualElement', '( veShadow, veFrame, vePanel, veText, veConnector )');
  CL.AddTypeS('TStatePathOwner', '( poOwnedBySource, poOwnedByDestination )');
  SIRegister_TStateControl(CL);
  SIRegister_TStateNodeBase(CL);
  CL.AddTypeS('TStatePath', '( spAuto, spDirect, spLeftRight, spTopBottom, spTopLeft, spRightBottom )');
  SIRegister_TStateConnector(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStateBoolean');
  CL.AddTypeS('TBooleanStateEvent', 'Procedure ( Sender : TStateBoolean; var Result : Boolean)');
  SIRegister_TStateBoolean(CL);
  SIRegister_TStateNode(CL);
  SIRegister_TStateStart(CL);
  SIRegister_TStateStop(CL);
  SIRegister_TStateTransition(CL);
  CL.AddTypeS('TLinkDirection', '( ldIncoming, ldOutgoing )');
  SIRegister_TStateLinkBase(CL);
  SIRegister_TStateLink(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStateLinkDirection_W(Self: TStateLink; const T: TLinkDirection);
begin Self.Direction := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateLinkDirection_R(Self: TStateLink; var T: TLinkDirection);
begin T := Self.Direction; end;

(*----------------------------------------------------------------------------*)
procedure TStateLinkDestination_W(Self: TStateLink; const T: TStateControl);
begin Self.Destination := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateLinkDestination_R(Self: TStateLink; var T: TStateControl);
begin T := Self.Destination; end;

(*----------------------------------------------------------------------------*)
procedure TStateTransitionOnTransition_W(Self: TStateTransition; const T: TNotifyEvent);
begin Self.OnTransition := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateTransitionOnTransition_R(Self: TStateTransition; var T: TNotifyEvent);
begin T := Self.OnTransition; end;

(*----------------------------------------------------------------------------*)
procedure TStateTransitionToState_W(Self: TStateTransition; const T: TStateControl);
begin Self.ToState := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateTransitionToState_R(Self: TStateTransition; var T: TStateControl);
begin T := Self.ToState; end;

(*----------------------------------------------------------------------------*)
procedure TStateTransitionFromState_W(Self: TStateTransition; const T: TStateControl);
begin Self.FromState := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateTransitionFromState_R(Self: TStateTransition; var T: TStateControl);
begin T := Self.FromState; end;

(*----------------------------------------------------------------------------*)
procedure TStateNodeDefaultTransition_W(Self: TStateNode; const T: TStateControl);
begin Self.DefaultTransition := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateNodeDefaultTransition_R(Self: TStateNode; var T: TStateControl);
begin T := Self.DefaultTransition; end;

(*----------------------------------------------------------------------------*)
procedure TStateBooleanDefaultState_W(Self: TStateBoolean; const T: Boolean);
begin Self.DefaultState := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateBooleanDefaultState_R(Self: TStateBoolean; var T: Boolean);
begin T := Self.DefaultState; end;

(*----------------------------------------------------------------------------*)
procedure TStateBooleanFalseState_W(Self: TStateBoolean; const T: TStateControl);
begin Self.FalseState := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateBooleanFalseState_R(Self: TStateBoolean; var T: TStateControl);
begin T := Self.FalseState; end;

(*----------------------------------------------------------------------------*)
procedure TStateBooleanTrueState_W(Self: TStateBoolean; const T: TStateControl);
begin Self.TrueState := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateBooleanTrueState_R(Self: TStateBoolean; var T: TStateControl);
begin T := Self.TrueState; end;

(*----------------------------------------------------------------------------*)
procedure TStateBooleanOnEnterState_W(Self: TStateBoolean; const T: TBooleanStateEvent);
begin Self.OnEnterState := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateBooleanOnEnterState_R(Self: TStateBoolean; var T: TBooleanStateEvent);
begin T := Self.OnEnterState; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorOffset_W(Self: TStateConnector; const T: integer);
begin Self.Offset := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorOffset_R(Self: TStateConnector; var T: integer);
begin T := Self.Offset; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorPath_W(Self: TStateConnector; const T: TStatePath);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorPath_R(Self: TStateConnector; var T: TStatePath);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorSelected_W(Self: TStateConnector; const T: Boolean);
begin Self.Selected := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorSelected_R(Self: TStateConnector; var T: Boolean);
begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorActualPath_R(Self: TStateConnector; var T: TStatePath);
begin T := Self.ActualPath; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorPeerNode_W(Self: TStateConnector; const T: TStateControl);
begin Self.PeerNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorPeerNode_R(Self: TStateConnector; var T: TStateControl);
begin T := Self.PeerNode; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorDestination_W(Self: TStateConnector; const T: TStateControl);
begin Self.Destination := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorDestination_R(Self: TStateConnector; var T: TStateControl);
begin T := Self.Destination; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorSource_W(Self: TStateConnector; const T: TStateControl);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateConnectorSource_R(Self: TStateConnector; var T: TStateControl);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlSynchronize_W(Self: TStateControl; const T: boolean);
begin Self.Synchronize := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlSynchronize_R(Self: TStateControl; var T: boolean);
begin T := Self.Synchronize; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlHint_W(Self: TStateControl; const T: string);
begin Self.Hint := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlHint_R(Self: TStateControl; var T: string);
begin T := Self.Hint; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlOnExitState_W(Self: TStateControl; const T: TNotifyEvent);
begin Self.OnExitState := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlOnExitState_R(Self: TStateControl; var T: TNotifyEvent);
begin T := Self.OnExitState; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlOnEnterState_W(Self: TStateControl; const T: TNotifyEvent);
begin Self.OnEnterState := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlOnEnterState_R(Self: TStateControl; var T: TNotifyEvent);
begin T := Self.OnEnterState; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlConnectors_R(Self: TStateControl; var T: TList);
begin T := Self.Connectors; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlActive_W(Self: TStateControl; const T: boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlActive_R(Self: TStateControl; var T: boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TStateControlStateMachine_R(Self: TStateControl; var T: TStateMachine);
begin T := Self.StateMachine; end;

(*----------------------------------------------------------------------------*)
procedure TStateThreadNextState_R(Self: TStateThread; var T: TStateControl);
begin T := Self.NextState; end;

(*----------------------------------------------------------------------------*)
procedure TStateThreadState_W(Self: TStateThread; const T: TStateControl);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateThreadState_R(Self: TStateThread; var T: TStateControl);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TStateThreadStateMachine_R(Self: TStateThread; var T: TStateMachine);
begin T := Self.StateMachine; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnSingleStep_W(Self: TStateMachine; const T: TNotifyEvent);
begin Self.OnSingleStep := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnSingleStep_R(Self: TStateMachine; var T: TNotifyEvent);
begin T := Self.OnSingleStep; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnThreadStop_W(Self: TStateMachine; const T: TNotifyEvent);
begin Self.OnThreadStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnThreadStop_R(Self: TStateMachine; var T: TNotifyEvent);
begin T := Self.OnThreadStop; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnThreadStart_W(Self: TStateMachine; const T: TNotifyEvent);
begin Self.OnThreadStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnThreadStart_R(Self: TStateMachine; var T: TNotifyEvent);
begin T := Self.OnThreadStart; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnStop_W(Self: TStateMachine; const T: TNotifyEvent);
begin Self.OnStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnStop_R(Self: TStateMachine; var T: TNotifyEvent);
begin T := Self.OnStop; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnStart_W(Self: TStateMachine; const T: TNotifyEvent);
begin Self.OnStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnStart_R(Self: TStateMachine; var T: TNotifyEvent);
begin T := Self.OnStart; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnException_W(Self: TStateMachine; const T: TStateExceptionEvent);
begin Self.OnException := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnException_R(Self: TStateMachine; var T: TStateExceptionEvent);
begin T := Self.OnException; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnChangeState_W(Self: TStateMachine; const T: TChangeStateEvent);
begin Self.OnChangeState := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOnChangeState_R(Self: TStateMachine; var T: TChangeStateEvent);
begin T := Self.OnChangeState; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOptions_W(Self: TStateMachine; const T: TStateMachineOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineOptions_R(Self: TStateMachine; var T: TStateMachineOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineState_W(Self: TStateMachine; const T: TStateControl);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineState_R(Self: TStateMachine; var T: TStateControl);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineActive_W(Self: TStateMachine; const T: boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineActive_R(Self: TStateMachine; var T: boolean);
begin T := Self.Active; end;

procedure TStateMachineFont_W(Self: TStateMachine; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineFont_R(Self: TStateMachine; var T: TFont);
begin T := Self.Font; end;

procedure TStateMachineColor_W(Self: TStateMachine; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TStateMachineColor_R(Self: TStateMachine; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_statmach_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateLink) do begin
    RegisterConstructor(@TStateLink.Create, 'Create');
    RegisterMethod(@TStateLink.Destroy, 'Free');
     RegisterMethod(@TStateLink.SetBounds, 'SetBounds');
    RegisterMethod(@TStateLink.PaintConnector, 'PaintConnector');
    RegisterMethod(@TStateLink.HitTest, 'HitTest');
    RegisterPropertyHelper(@TStateLinkDestination_R,@TStateLinkDestination_W,'Destination');
    RegisterPropertyHelper(@TStateLinkDirection_R,@TStateLinkDirection_W,'Direction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateLinkBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateLinkBase) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateTransition(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateTransition) do begin
    RegisterConstructor(@TStateTransition.Create, 'Create');
    RegisterMethod(@TStateTransition.Destroy, 'Free');
    RegisterMethod(@TStateTransition.SetBounds, 'SetBounds');
    RegisterMethod(@TStateTransition.PaintConnector, 'PaintConnector');
    RegisterMethod(@TStateTransition.HitTest, 'HitTest');
    RegisterPropertyHelper(@TStateTransitionFromState_R,@TStateTransitionFromState_W,'FromState');
    RegisterPropertyHelper(@TStateTransitionToState_R,@TStateTransitionToState_W,'ToState');
    RegisterPropertyHelper(@TStateTransitionOnTransition_R,@TStateTransitionOnTransition_W,'OnTransition');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateStop(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateStop) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateStart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateStart) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateNode) do begin
  RegisterConstructor(@TStateNode.Create, 'Create');
    RegisterMethod(@TStateNode.SetBounds, 'SetBounds');
    RegisterMethod(@TStateNode.PaintConnector, 'PaintConnector');
    RegisterMethod(@TStateNode.HitTest, 'HitTest');
    RegisterPropertyHelper(@TStateNodeDefaultTransition_R,@TStateNodeDefaultTransition_W,'DefaultTransition');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateBoolean(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateBoolean) do begin
  RegisterConstructor(@TStateBoolean.Create, 'Create');
    RegisterMethod(@TStateBoolean.Destroy, 'Free');
    RegisterMethod(@TStateBoolean.PaintConnector, 'PaintConnector');
    RegisterMethod(@TStateBoolean.HitTest, 'HitTest');
    RegisterPropertyHelper(@TStateBooleanOnEnterState_R,@TStateBooleanOnEnterState_W,'OnEnterState');
    RegisterPropertyHelper(@TStateBooleanTrueState_R,@TStateBooleanTrueState_W,'TrueState');
    RegisterPropertyHelper(@TStateBooleanFalseState_R,@TStateBooleanFalseState_W,'FalseState');
    RegisterPropertyHelper(@TStateBooleanDefaultState_R,@TStateBooleanDefaultState_W,'DefaultState');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateConnector(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateConnector) do
  begin
    RegisterConstructor(@TStateConnector.Create, 'Create');
    RegisterMethod(@TStateConnector.Paint, 'Paint');
    RegisterMethod(@TStateConnector.PaintFlipLine, 'PaintFlipLine');
    RegisterMethod(@TStateConnector.HitTest, 'HitTest');
    RegisterMethod(@TStateConnector.GetLines, 'GetLines');
    RegisterMethod(@TStateConnector.MakeRect, 'MakeRect');
    RegisterMethod(@TStateConnector.RectCenter, 'RectCenter');
    RegisterPropertyHelper(@TStateConnectorSource_R,@TStateConnectorSource_W,'Source');
    RegisterPropertyHelper(@TStateConnectorDestination_R,@TStateConnectorDestination_W,'Destination');
    RegisterPropertyHelper(@TStateConnectorPeerNode_R,@TStateConnectorPeerNode_W,'PeerNode');
    RegisterPropertyHelper(@TStateConnectorActualPath_R,nil,'ActualPath');
    RegisterPropertyHelper(@TStateConnectorSelected_R,@TStateConnectorSelected_W,'Selected');
    RegisterPropertyHelper(@TStateConnectorPath_R,@TStateConnectorPath_W,'Path');
    RegisterPropertyHelper(@TStateConnectorOffset_R,@TStateConnectorOffset_W,'Offset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateNodeBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateNodeBase) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateControl) do begin
    RegisterConstructor(@TStateControl.Create, 'Create');
    RegisterMethod(@TStateControl.Destroy, 'Free');
    RegisterMethod(@TStateControl.SetBounds, 'SetBounds');
    RegisterVirtualMethod(@TStateControl.PaintConnector, 'PaintConnector');
    RegisterVirtualMethod(@TStateControl.HitTest, 'HitTest');
    RegisterPropertyHelper(@TStateControlStateMachine_R,nil,'StateMachine');
    RegisterPropertyHelper(@TStateControlActive_R,@TStateControlActive_W,'Active');
    RegisterPropertyHelper(@TStateControlConnectors_R,nil,'Connectors');
    RegisterPropertyHelper(@TStateControlOnEnterState_R,@TStateControlOnEnterState_W,'OnEnterState');
    RegisterPropertyHelper(@TStateControlOnExitState_R,@TStateControlOnExitState_W,'OnExitState');
    RegisterPropertyHelper(@TStateControlHint_R,@TStateControlHint_W,'Hint');
    RegisterPropertyHelper(@TStateControlSynchronize_R,@TStateControlSynchronize_W,'Synchronize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateThread) do
  begin
    RegisterConstructor(@TStateThread.Create, 'Create');
    RegisterMethod(@TStateThread.Destroy, 'Free');
    RegisterMethod(@TStateThread.Terminate, 'Terminate');
    RegisterPropertyHelper(@TStateThreadStateMachine_R,nil,'StateMachine');
    RegisterPropertyHelper(@TStateThreadState_R,@TStateThreadState_W,'State');
    RegisterPropertyHelper(@TStateThreadNextState_R,nil,'NextState');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStateMachine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateMachine) do begin
    RegisterConstructor(@TStateMachine.Create, 'Create');
      RegisterMethod(@TStateMachine.Destroy, 'Free');
    RegisterMethod(@TStateMachine.Execute, 'Execute');
    RegisterMethod(@TStateMachine.Stop, 'Stop');
    RegisterPropertyHelper(@TStateMachineActive_R,@TStateMachineActive_W,'Active');
    RegisterPropertyHelper(@TStateMachineState_R,@TStateMachineState_W,'State');
    RegisterPropertyHelper(@TStateMachineOptions_R,@TStateMachineOptions_W,'Options');
    RegisterPropertyHelper(@TStateMachineOnChangeState_R,@TStateMachineOnChangeState_W,'OnChangeState');
    RegisterPropertyHelper(@TStateMachineOnException_R,@TStateMachineOnException_W,'OnException');
    RegisterPropertyHelper(@TStateMachineOnStart_R,@TStateMachineOnStart_W,'OnStart');
    RegisterPropertyHelper(@TStateMachineOnStop_R,@TStateMachineOnStop_W,'OnStop');
    RegisterPropertyHelper(@TStateMachineOnThreadStart_R,@TStateMachineOnThreadStart_W,'OnThreadStart');
    RegisterPropertyHelper(@TStateMachineOnThreadStop_R,@TStateMachineOnThreadStop_W,'OnThreadStop');
    RegisterPropertyHelper(@TStateMachineOnSingleStep_R,@TStateMachineOnSingleStep_W,'OnSingleStep');
    RegisterPropertyHelper(@TStateMachineColor_R,@TStateMachineColor_W,'Color');
    RegisterPropertyHelper(@TStateMachineFont_R,@TStateMachineFont_W,'Font');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_statmach(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStateThread) do
  with CL.Add(TStateMachine) do
  with CL.Add(TStateControl) do
  with CL.Add(TStateConnector) do
  RIRegister_TStateMachine(CL);
  RIRegister_TStateThread(CL);
  RIRegister_TStateControl(CL);
  RIRegister_TStateNodeBase(CL);
  RIRegister_TStateConnector(CL);
  with CL.Add(TStateBoolean) do
  RIRegister_TStateBoolean(CL);
  RIRegister_TStateNode(CL);
  RIRegister_TStateStart(CL);
  RIRegister_TStateStop(CL);
  RIRegister_TStateTransition(CL);
  RIRegister_TStateLinkBase(CL);
  RIRegister_TStateLink(CL);
end;

 
 
{ TPSImport_statmach }
(*----------------------------------------------------------------------------*)
procedure TPSImport_statmach.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_statmach(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_statmach.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_statmach(ri);
  //RIRegister_statmach_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
