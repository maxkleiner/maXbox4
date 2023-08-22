unit uPSI_Sensors;
{
  for industrial 4
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
  TPSImport_Sensors = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStopLightSensor(CL: TPSPascalCompiler);
procedure SIRegister_TAnalogSensor(CL: TPSPascalCompiler);
procedure SIRegister_TSensorPanel(CL: TPSPascalCompiler);
procedure SIRegister_Sensors(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStopLightSensor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAnalogSensor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSensorPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_Sensors(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  { LCLIntf
  ,LCLType
  ,LResources }
  Controls
  ,Graphics
  ,Stdctrls
  ,Extctrls
  ,Sensors
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Sensors]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStopLightSensor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TImage', 'TStopLightSensor') do
  with CL.AddClassN(CL.FindClass('TImage'),'TStopLightSensor') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('State', 'TStopLights', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAnalogSensor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSensorPanel', 'TAnalogSensor') do
  with CL.AddClassN(CL.FindClass('TSensorPanel'),'TAnalogSensor') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('AnalogKind', 'TAnalogKind', iptrw);
    Registerpublishedproperties;
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('CANVAS', 'TCanvas', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSensorPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPanel', 'TSensorPanel') do
  with CL.AddClassN(CL.FindClass('TPanel'),'TSensorPanel') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Function GetStatus : TStopLights');
    RegisterMethod('Procedure SetColorState( slStopLight : TStopLights)');
    RegisterProperty('Caption', 'TCaption', iptrw);
    RegisterProperty('ShowText', 'Boolean', iptrw);
    RegisterProperty('ShowLevel', 'Boolean', iptrw);
    RegisterProperty('ColorFore', 'TColor', iptrw);
    RegisterProperty('ColorBack', 'TColor', iptrw);
    RegisterProperty('ColorRed', 'TColor', iptrw);
    RegisterProperty('ColorYellow', 'TColor', iptrw);
    RegisterProperty('Value', 'Double', iptrw);
    RegisterProperty('ValueMin', 'Double', iptrw);
    RegisterProperty('ValueMax', 'Double', iptrw);
    RegisterProperty('ValueRed', 'Double', iptrw);
    RegisterProperty('ValueYellow', 'Double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Sensors(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStopLights', '( slUNKNOWN, slRED, slYELLOW, slGREEN )');
  SIRegister_TSensorPanel(CL);
  CL.AddTypeS('TAnalogKind', '( akAnalog, akHorizontal, akVertical )');
  SIRegister_TAnalogSensor(CL);
  SIRegister_TStopLightSensor(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStopLightSensorState_W(Self: TStopLightSensor; const T: TStopLights);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure TStopLightSensorState_R(Self: TStopLightSensor; var T: TStopLights);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogSensorAnalogKind_W(Self: TAnalogSensor; const T: TAnalogKind);
begin Self.AnalogKind := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogSensorAnalogKind_R(Self: TAnalogSensor; var T: TAnalogKind);
begin T := Self.AnalogKind; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelValueYellow_W(Self: TSensorPanel; const T: Double);
begin Self.ValueYellow := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelValueYellow_R(Self: TSensorPanel; var T: Double);
begin T := Self.ValueYellow; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelValueRed_W(Self: TSensorPanel; const T: Double);
begin Self.ValueRed := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelValueRed_R(Self: TSensorPanel; var T: Double);
begin T := Self.ValueRed; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelValueMax_W(Self: TSensorPanel; const T: Double);
begin Self.ValueMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelValueMax_R(Self: TSensorPanel; var T: Double);
begin T := Self.ValueMax; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelValueMin_W(Self: TSensorPanel; const T: Double);
begin Self.ValueMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelValueMin_R(Self: TSensorPanel; var T: Double);
begin T := Self.ValueMin; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelValue_W(Self: TSensorPanel; const T: Double);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelValue_R(Self: TSensorPanel; var T: Double);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelColorYellow_W(Self: TSensorPanel; const T: TColor);
begin Self.ColorYellow := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelColorYellow_R(Self: TSensorPanel; var T: TColor);
begin T := Self.ColorYellow; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelColorRed_W(Self: TSensorPanel; const T: TColor);
begin Self.ColorRed := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelColorRed_R(Self: TSensorPanel; var T: TColor);
begin T := Self.ColorRed; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelColorBack_W(Self: TSensorPanel; const T: TColor);
begin Self.ColorBack := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelColorBack_R(Self: TSensorPanel; var T: TColor);
begin T := Self.ColorBack; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelColorFore_W(Self: TSensorPanel; const T: TColor);
begin Self.ColorFore := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelColorFore_R(Self: TSensorPanel; var T: TColor);
begin T := Self.ColorFore; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelShowLevel_W(Self: TSensorPanel; const T: Boolean);
begin Self.ShowLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelShowLevel_R(Self: TSensorPanel; var T: Boolean);
begin T := Self.ShowLevel; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelShowText_W(Self: TSensorPanel; const T: Boolean);
begin Self.ShowText := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelShowText_R(Self: TSensorPanel; var T: Boolean);
begin T := Self.ShowText; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelCaption_W(Self: TSensorPanel; const T: TCaption);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TSensorPanelCaption_R(Self: TSensorPanel; var T: TCaption);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStopLightSensor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStopLightSensor) do
  begin
    RegisterConstructor(@TStopLightSensor.Create, 'Create');
    RegisterPropertyHelper(@TStopLightSensorState_R,@TStopLightSensorState_W,'State');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAnalogSensor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAnalogSensor) do
  begin
    RegisterConstructor(@TAnalogSensor.Create, 'Create');
    RegisterPropertyHelper(@TAnalogSensorAnalogKind_R,@TAnalogSensorAnalogKind_W,'AnalogKind');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSensorPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSensorPanel) do begin
    RegisterConstructor(@TSensorPanel.Create, 'Create');
    RegisterMethod(@TSensorPanel.Destroy, 'Free');
    RegisterMethod(@TSensorPanel.GetStatus, 'GetStatus');
    RegisterVirtualMethod(@TSensorPanel.SetColorState, 'SetColorState');
    RegisterPropertyHelper(@TSensorPanelCaption_R,@TSensorPanelCaption_W,'Caption');
    RegisterPropertyHelper(@TSensorPanelShowText_R,@TSensorPanelShowText_W,'ShowText');
    RegisterPropertyHelper(@TSensorPanelShowLevel_R,@TSensorPanelShowLevel_W,'ShowLevel');
    RegisterPropertyHelper(@TSensorPanelColorFore_R,@TSensorPanelColorFore_W,'ColorFore');
    RegisterPropertyHelper(@TSensorPanelColorBack_R,@TSensorPanelColorBack_W,'ColorBack');
    RegisterPropertyHelper(@TSensorPanelColorRed_R,@TSensorPanelColorRed_W,'ColorRed');
    RegisterPropertyHelper(@TSensorPanelColorYellow_R,@TSensorPanelColorYellow_W,'ColorYellow');
    RegisterPropertyHelper(@TSensorPanelValue_R,@TSensorPanelValue_W,'Value');
    RegisterPropertyHelper(@TSensorPanelValueMin_R,@TSensorPanelValueMin_W,'ValueMin');
    RegisterPropertyHelper(@TSensorPanelValueMax_R,@TSensorPanelValueMax_W,'ValueMax');
    RegisterPropertyHelper(@TSensorPanelValueRed_R,@TSensorPanelValueRed_W,'ValueRed');
    RegisterPropertyHelper(@TSensorPanelValueYellow_R,@TSensorPanelValueYellow_W,'ValueYellow');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Sensors(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSensorPanel(CL);
  RIRegister_TAnalogSensor(CL);
  RIRegister_TStopLightSensor(CL);
end;

 
 
{ TPSImport_Sensors }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Sensors.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Sensors(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Sensors.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Sensors(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
