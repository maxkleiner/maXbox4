unit uPSI_JvSimLogic;
{
 for simulation of electronic layout 
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
  TPSImport_JvSimLogic = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvSimLogicBox(CL: TPSPascalCompiler);
procedure SIRegister_TJvSimBin(CL: TPSPascalCompiler);
procedure SIRegister_TJvSimLight(CL: TPSPascalCompiler);
procedure SIRegister_TJvSimButton(CL: TPSPascalCompiler);
procedure SIRegister_TJvSimReverse(CL: TPSPascalCompiler);
procedure SIRegister_TJvLogic(CL: TPSPascalCompiler);
procedure SIRegister_TJvSIMConnector(CL: TPSPascalCompiler);
procedure SIRegister_TJvPointX(CL: TPSPascalCompiler);
procedure SIRegister_JvSimLogic(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvSimLogicBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvSimBin(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvSimLight(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvSimButton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvSimReverse(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvLogic(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvSIMConnector(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvPointX(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvSimLogic(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
 //  JclUnitVersioning
  Windows
  //,Messages
  ,Graphics
  //,Controls
  //,Forms
  //,Dialogs
  //,Extctrls
  ,JvTypes
  ,JvSimLogic
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvSimLogic]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSimLogicBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TJvSimLogicBox') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TJvSimLogicBox') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Paint');
    RegisterMethod('Procedure Free');
    RegisterPublishedProperties;
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSimBin(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TJvSimBin') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TJvSimBin') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Paint');
     RegisterMethod('Procedure Free');
       RegisterPublishedProperties;
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSimLight(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TJvSimLight') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TJvSimLight') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Paint');
    RegisterProperty('Lit', 'Boolean', iptrw);
    RegisterProperty('ColorOn', 'TColor', iptrw);
    RegisterProperty('ColorOff', 'TColor', iptrw);
      RegisterMethod('Procedure Free');
        RegisterPublishedProperties;
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSimButton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TJvSimButton') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TJvSimButton') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Paint');
    RegisterProperty('Down', 'Boolean', iptrw);
     RegisterPublishedProperties;
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSimReverse(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TJvSimReverse') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TJvSimReverse') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Paint');
    RegisterProperty('Gates', 'TJvGate Integer', iptr);
    RegisterProperty('Input1', 'Boolean', iptrw);
    RegisterProperty('Output1', 'Boolean', iptrw);
    RegisterProperty('Output2', 'Boolean', iptrw);
    RegisterProperty('Output3', 'Boolean', iptrw);
     RegisterPublishedProperties;
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvLogic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TJvLogic') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TJvLogic') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Paint');
    RegisterProperty('Gates', 'TJvGate Integer', iptr);
    RegisterProperty('Input1', 'Boolean', iptrw);
    RegisterProperty('Input2', 'Boolean', iptrw);
    RegisterProperty('Input3', 'Boolean', iptrw);
    RegisterProperty('Output1', 'Boolean', iptrw);
    RegisterProperty('Output2', 'Boolean', iptrw);
    RegisterProperty('Output3', 'Boolean', iptrw);
    RegisterProperty('LogicFunc', 'TJvLogicFunc', iptrw);
    RegisterMethod('Procedure Free');
     RegisterPublishedProperties;
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSIMConnector(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TJvSIMConnector') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TJvSIMConnector') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Paint');
    RegisterMethod('Procedure Notification( AComponent : TComponent; Operation : TOperation)');
    RegisterMethod('Procedure DoMouseDown( X, Y : Integer)');
    RegisterMethod('Procedure DoMouseMove( dx, dy : Integer)');
    RegisterMethod('Procedure AnchorCorner( LogTL : TPoint; ACorner : TJvConMode)');
    RegisterMethod('Procedure MoveConnector( LogTL : TPoint)');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');
    RegisterProperty('FromLogic', 'TJvLogic', iptrw);
    RegisterProperty('FromGate', 'Integer', iptrw);
    RegisterProperty('FromPoint', 'TJvPointX', iptrw);
    RegisterProperty('ToLogic', 'TJvLogic', iptrw);
    RegisterProperty('ToGate', 'Integer', iptrw);
    RegisterProperty('ToPoint', 'TJvPointX', iptrw);
     RegisterPublishedProperties;
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvPointX(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvPointX') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvPointX') do begin
    RegisterMethod('Function Point : TPoint');
    RegisterMethod('Procedure SetPoint( const Pt : TPoint)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('X', 'Integer', iptrw);
    RegisterProperty('Y', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvSimLogic(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvLogic');
  CL.AddTypeS('TJvGateStyle', '( jgsDI, jgsDO )');
  CL.AddTypeS('TJvLogicFunc', '( jlfAND, jlfOR, jlfNOT )');
  CL.AddTypeS('TJvGate', 'record Style : TJvGateStyle; State : Boolean; Active '
   +': Boolean; Pos : TPoint; end');
  SIRegister_TJvPointX(CL);
  CL.AddTypeS('TJvConMode', '( jcmTL, jcmTR, jcmBR, jcmBL )');
  CL.AddTypeS('TJvConPos', '( jcpTL, jcpTR, jcpBR, jcpBL )');
  CL.AddTypeS('TJvConShape', '( jcsTLBR, jcsTRBL )');
  SIRegister_TJvSIMConnector(CL);
  SIRegister_TJvLogic(CL);
  SIRegister_TJvSimReverse(CL);
  SIRegister_TJvSimButton(CL);
  SIRegister_TJvSimLight(CL);
  SIRegister_TJvSimBin(CL);
  SIRegister_TJvSimLogicBox(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvSimLightColorOff_W(Self: TJvSimLight; const T: TColor);
begin Self.ColorOff := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimLightColorOff_R(Self: TJvSimLight; var T: TColor);
begin T := Self.ColorOff; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimLightColorOn_W(Self: TJvSimLight; const T: TColor);
begin Self.ColorOn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimLightColorOn_R(Self: TJvSimLight; var T: TColor);
begin T := Self.ColorOn; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimLightLit_W(Self: TJvSimLight; const T: Boolean);
begin Self.Lit := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimLightLit_R(Self: TJvSimLight; var T: Boolean);
begin T := Self.Lit; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimButtonDown_W(Self: TJvSimButton; const T: Boolean);
begin Self.Down := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimButtonDown_R(Self: TJvSimButton; var T: Boolean);
begin T := Self.Down; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimReverseOutput3_W(Self: TJvSimReverse; const T: Boolean);
begin Self.Output3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimReverseOutput3_R(Self: TJvSimReverse; var T: Boolean);
begin T := Self.Output3; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimReverseOutput2_W(Self: TJvSimReverse; const T: Boolean);
begin Self.Output2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimReverseOutput2_R(Self: TJvSimReverse; var T: Boolean);
begin T := Self.Output2; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimReverseOutput1_W(Self: TJvSimReverse; const T: Boolean);
begin Self.Output1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimReverseOutput1_R(Self: TJvSimReverse; var T: Boolean);
begin T := Self.Output1; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimReverseInput1_W(Self: TJvSimReverse; const T: Boolean);
begin Self.Input1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimReverseInput1_R(Self: TJvSimReverse; var T: Boolean);
begin T := Self.Input1; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimReverseGates_R(Self: TJvSimReverse; var T: TJvGate; const t1: Integer);
begin T := Self.Gates[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicLogicFunc_W(Self: TJvLogic; const T: TJvLogicFunc);
begin Self.LogicFunc := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicLogicFunc_R(Self: TJvLogic; var T: TJvLogicFunc);
begin T := Self.LogicFunc; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicOutput3_W(Self: TJvLogic; const T: Boolean);
begin Self.Output3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicOutput3_R(Self: TJvLogic; var T: Boolean);
begin T := Self.Output3; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicOutput2_W(Self: TJvLogic; const T: Boolean);
begin Self.Output2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicOutput2_R(Self: TJvLogic; var T: Boolean);
begin T := Self.Output2; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicOutput1_W(Self: TJvLogic; const T: Boolean);
begin Self.Output1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicOutput1_R(Self: TJvLogic; var T: Boolean);
begin T := Self.Output1; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicInput3_W(Self: TJvLogic; const T: Boolean);
begin Self.Input3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicInput3_R(Self: TJvLogic; var T: Boolean);
begin T := Self.Input3; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicInput2_W(Self: TJvLogic; const T: Boolean);
begin Self.Input2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicInput2_R(Self: TJvLogic; var T: Boolean);
begin T := Self.Input2; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicInput1_W(Self: TJvLogic; const T: Boolean);
begin Self.Input1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicInput1_R(Self: TJvLogic; var T: Boolean);
begin T := Self.Input1; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogicGates_R(Self: TJvLogic; var T: TJvGate; const t1: Integer);
begin T := Self.Gates[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorToPoint_W(Self: TJvSIMConnector; const T: TJvPointX);
begin Self.ToPoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorToPoint_R(Self: TJvSIMConnector; var T: TJvPointX);
begin T := Self.ToPoint; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorToGate_W(Self: TJvSIMConnector; const T: Integer);
begin Self.ToGate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorToGate_R(Self: TJvSIMConnector; var T: Integer);
begin T := Self.ToGate; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorToLogic_W(Self: TJvSIMConnector; const T: TJvLogic);
begin Self.ToLogic := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorToLogic_R(Self: TJvSIMConnector; var T: TJvLogic);
begin T := Self.ToLogic; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorFromPoint_W(Self: TJvSIMConnector; const T: TJvPointX);
begin Self.FromPoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorFromPoint_R(Self: TJvSIMConnector; var T: TJvPointX);
begin T := Self.FromPoint; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorFromGate_W(Self: TJvSIMConnector; const T: Integer);
begin Self.FromGate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorFromGate_R(Self: TJvSIMConnector; var T: Integer);
begin T := Self.FromGate; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorFromLogic_W(Self: TJvSIMConnector; const T: TJvLogic);
begin Self.FromLogic := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSIMConnectorFromLogic_R(Self: TJvSIMConnector; var T: TJvLogic);
begin T := Self.FromLogic; end;

(*----------------------------------------------------------------------------*)
procedure TJvPointXY_W(Self: TJvPointX; const T: Integer);
begin Self.Y := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPointXY_R(Self: TJvPointX; var T: Integer);
begin T := Self.Y; end;

(*----------------------------------------------------------------------------*)
procedure TJvPointXX_W(Self: TJvPointX; const T: Integer);
begin Self.X := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPointXX_R(Self: TJvPointX; var T: Integer);
begin T := Self.X; end;


procedure TITEMONCLICK_W(Self: TJvSimLogicBox; const T: TNOTIFYEVENT);
begin //Self.ONCLICK := T;
 end;
procedure TITEMONCLICK_R(Self: TJvSimLogicBox; var T: TNOTIFYEVENT);
begin //T := Self.ONCLICK;
 end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSimLogicBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSimLogicBox) do begin
    RegisterConstructor(@TJvSimLogicBox.Create, 'Create');
    RegisterMethod(@TJvSimLogicBox.Paint, 'Paint');
     RegisterMethod(@TJvSimLogicBox.Destroy, 'Free');
 		RegisterEventPropertyHelper(@TITEMONCLICK_R,@TITEMONCLICK_W,'ONCLICK');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSimBin(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSimBin) do
  begin
    RegisterConstructor(@TJvSimBin.Create, 'Create');
    RegisterMethod(@TJvSimBin.Paint, 'Paint');
    RegisterMethod(@TJvSimBin.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSimLight(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSimLight) do begin
    RegisterConstructor(@TJvSimLight.Create, 'Create');
    RegisterMethod(@TJvSimLight.Paint, 'Paint');
    RegisterPropertyHelper(@TJvSimLightLit_R,@TJvSimLightLit_W,'Lit');
    RegisterPropertyHelper(@TJvSimLightColorOn_R,@TJvSimLightColorOn_W,'ColorOn');
    RegisterPropertyHelper(@TJvSimLightColorOff_R,@TJvSimLightColorOff_W,'ColorOff');
    RegisterMethod(@TJvSimLight.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSimButton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSimButton) do begin
    RegisterConstructor(@TJvSimButton.Create, 'Create');
    RegisterMethod(@TJvSimButton.Paint, 'Paint');
    RegisterPropertyHelper(@TJvSimButtonDown_R,@TJvSimButtonDown_W,'Down');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSimReverse(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSimReverse) do begin
    RegisterConstructor(@TJvSimReverse.Create, 'Create');
    RegisterMethod(@TJvSimReverse.Paint, 'Paint');
    RegisterPropertyHelper(@TJvSimReverseGates_R,nil,'Gates');
    RegisterPropertyHelper(@TJvSimReverseInput1_R,@TJvSimReverseInput1_W,'Input1');
    RegisterPropertyHelper(@TJvSimReverseOutput1_R,@TJvSimReverseOutput1_W,'Output1');
    RegisterPropertyHelper(@TJvSimReverseOutput2_R,@TJvSimReverseOutput2_W,'Output2');
    RegisterPropertyHelper(@TJvSimReverseOutput3_R,@TJvSimReverseOutput3_W,'Output3');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvLogic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvLogic) do begin
    RegisterConstructor(@TJvLogic.Create, 'Create');
    RegisterMethod(@TJvLogic.Paint, 'Paint');
    RegisterPropertyHelper(@TJvLogicGates_R,nil,'Gates');
    RegisterPropertyHelper(@TJvLogicInput1_R,@TJvLogicInput1_W,'Input1');
    RegisterPropertyHelper(@TJvLogicInput2_R,@TJvLogicInput2_W,'Input2');
    RegisterPropertyHelper(@TJvLogicInput3_R,@TJvLogicInput3_W,'Input3');
    RegisterPropertyHelper(@TJvLogicOutput1_R,@TJvLogicOutput1_W,'Output1');
    RegisterPropertyHelper(@TJvLogicOutput2_R,@TJvLogicOutput2_W,'Output2');
    RegisterPropertyHelper(@TJvLogicOutput3_R,@TJvLogicOutput3_W,'Output3');
    RegisterPropertyHelper(@TJvLogicLogicFunc_R,@TJvLogicLogicFunc_W,'LogicFunc');
    RegisterMethod(@TJvLogic.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSIMConnector(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSIMConnector) do begin
    RegisterConstructor(@TJvSIMConnector.Create, 'Create');
    RegisterMethod(@TJvSIMConnector.Paint, 'Paint');
    RegisterMethod(@TJvSIMConnector.Notification, 'Notification');
    RegisterMethod(@TJvSIMConnector.DoMouseDown, 'DoMouseDown');
    RegisterMethod(@TJvSIMConnector.DoMouseMove, 'DoMouseMove');
    RegisterMethod(@TJvSIMConnector.AnchorCorner, 'AnchorCorner');
    RegisterMethod(@TJvSIMConnector.MoveConnector, 'MoveConnector');
    RegisterMethod(@TJvSIMConnector.Connect, 'Connect');
    RegisterMethod(@TJvSIMConnector.Disconnect, 'Disconnect');
    RegisterPropertyHelper(@TJvSIMConnectorFromLogic_R,@TJvSIMConnectorFromLogic_W,'FromLogic');
    RegisterPropertyHelper(@TJvSIMConnectorFromGate_R,@TJvSIMConnectorFromGate_W,'FromGate');
    RegisterPropertyHelper(@TJvSIMConnectorFromPoint_R,@TJvSIMConnectorFromPoint_W,'FromPoint');
    RegisterPropertyHelper(@TJvSIMConnectorToLogic_R,@TJvSIMConnectorToLogic_W,'ToLogic');
    RegisterPropertyHelper(@TJvSIMConnectorToGate_R,@TJvSIMConnectorToGate_W,'ToGate');
    RegisterPropertyHelper(@TJvSIMConnectorToPoint_R,@TJvSIMConnectorToPoint_W,'ToPoint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvPointX(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvPointX) do begin
    RegisterMethod(@TJvPointX.Point, 'Point');
    RegisterMethod(@TJvPointX.SetPoint, 'SetPoint');
    RegisterMethod(@TJvPointX.Assign, 'Assign');
    RegisterPropertyHelper(@TJvPointXX_R,@TJvPointXX_W,'X');
    RegisterPropertyHelper(@TJvPointXY_R,@TJvPointXY_W,'Y');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvSimLogic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvLogic) do
  RIRegister_TJvPointX(CL);
  RIRegister_TJvSIMConnector(CL);
  RIRegister_TJvLogic(CL);
  RIRegister_TJvSimReverse(CL);
  RIRegister_TJvSimButton(CL);
  RIRegister_TJvSimLight(CL);
  RIRegister_TJvSimBin(CL);
  RIRegister_TJvSimLogicBox(CL);
end;

 
 
{ TPSImport_JvSimLogic }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSimLogic.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvSimLogic(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSimLogic.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvSimLogic(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
