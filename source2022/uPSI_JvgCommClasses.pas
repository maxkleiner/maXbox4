unit uPSI_JvgCommClasses;
{
  to base the new JVCL 4.5 for mX4 preparations

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
  TPSImport_JvgCommClasses = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvgBevelLines(CL: TPSPascalCompiler);
procedure SIRegister_TJvgTextBoxStyle(CL: TPSPascalCompiler);
procedure SIRegister_TJvgCustomTextBoxStyle(CL: TPSPascalCompiler);
procedure SIRegister_TJvgCustomBoxStyle(CL: TPSPascalCompiler);
procedure SIRegister_TJvgAskListBoxItemStyle(CL: TPSPascalCompiler);
procedure SIRegister_TJvgSpeedButtonStyle(CL: TPSPascalCompiler);
procedure SIRegister_TJvgListBoxItemStyle(CL: TPSPascalCompiler);
procedure SIRegister_TJvgCustomListBoxItemStyle(CL: TPSPascalCompiler);
procedure SIRegister_TJvgGroupBoxColors(CL: TPSPascalCompiler);
procedure SIRegister_TJvgLabelColors(CL: TPSPascalCompiler);
procedure SIRegister_TJvgCustomLabelColors(CL: TPSPascalCompiler);
procedure SIRegister_TJvgSimleLabelColors(CL: TPSPascalCompiler);
procedure SIRegister_TJvgCustomTextColors(CL: TPSPascalCompiler);
procedure SIRegister_TJvgLabelTextStyles(CL: TPSPascalCompiler);
procedure SIRegister_TJvgIllumination(CL: TPSPascalCompiler);
procedure SIRegister_TJvgExtBevelOptions(CL: TPSPascalCompiler);
procedure SIRegister_TJvgBevelOptions(CL: TPSPascalCompiler);
procedure SIRegister_TJvgPointClass(CL: TPSPascalCompiler);
procedure SIRegister_TJvg2DAlign(CL: TPSPascalCompiler);
procedure SIRegister_TJvg3DGradient(CL: TPSPascalCompiler);
procedure SIRegister_TJvgGradient(CL: TPSPascalCompiler);
procedure SIRegister_TJvgCustomGradient(CL: TPSPascalCompiler);
procedure SIRegister_TJvgTwainColors(CL: TPSPascalCompiler);
procedure SIRegister_JvgCommClasses(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvgBevelLines(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgTextBoxStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgCustomTextBoxStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgCustomBoxStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgAskListBoxItemStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgSpeedButtonStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgListBoxItemStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgCustomListBoxItemStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgGroupBoxColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgLabelColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgCustomLabelColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgSimleLabelColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgCustomTextColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgLabelTextStyles(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgIllumination(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgExtBevelOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgBevelOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgPointClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvg2DAlign(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvg3DGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgCustomGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgTwainColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvgCommClasses(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Graphics
  ,Controls
  ,ExtCtrls
  ,JvgTypes
  ,JvgCommClasses
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvgCommClasses]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgBevelLines(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvgBevelLines') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvgBevelLines') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('Count', 'Cardinal', iptrw);
    RegisterProperty('Step', 'Cardinal', iptrw);
    RegisterProperty('Origin', 'TglOrigin', iptrw);
    RegisterProperty('Style', 'TPanelBevel', iptrw);
    RegisterProperty('Bold', 'Boolean', iptrw);
    RegisterProperty('Thickness', 'Byte', iptrw);
    RegisterProperty('IgnoreBorder', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgTextBoxStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgCustomTextBoxStyle', 'TJvgTextBoxStyle') do
  with CL.AddClassN(CL.FindClass('TJvgCustomTextBoxStyle'),'TJvgTextBoxStyle') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgCustomTextBoxStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgCustomBoxStyle', 'TJvgCustomTextBoxStyle') do
  with CL.AddClassN(CL.FindClass('TJvgCustomBoxStyle'),'TJvgCustomTextBoxStyle') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgCustomBoxStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgBevelOptions', 'TJvgCustomBoxStyle') do
  with CL.AddClassN(CL.FindClass('TJvgBevelOptions'),'TJvgCustomBoxStyle') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgAskListBoxItemStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgCustomListBoxItemStyle', 'TJvgAskListBoxItemStyle') do
  with CL.AddClassN(CL.FindClass('TJvgCustomListBoxItemStyle'),'TJvgAskListBoxItemStyle') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('BtnColor', 'TColor', iptrw);
    RegisterProperty('BtnFont', 'TFont', iptrw);
    RegisterProperty('BtnTextStyle', 'TglTextStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgSpeedButtonStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgListBoxItemStyle', 'TJvgSpeedButtonStyle') do
  with CL.AddClassN(CL.FindClass('TJvgListBoxItemStyle'),'TJvgSpeedButtonStyle') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgListBoxItemStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgCustomListBoxItemStyle', 'TJvgListBoxItemStyle') do
  with CL.AddClassN(CL.FindClass('TJvgCustomListBoxItemStyle'),'TJvgListBoxItemStyle') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Gradient', 'TJvgGradient', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgCustomListBoxItemStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvgCustomListBoxItemStyle') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvgCustomListBoxItemStyle') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function HighlightColor : TColor');
    RegisterMethod('Function ShadowColor : TColor');
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('DelineateColor', 'TColor', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('Bevel', 'TJvgBevelOptions', iptrw);
    RegisterProperty('TextStyle', 'TglTextStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgGroupBoxColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgCustomLabelColors', 'TJvgGroupBoxColors') do
  with CL.AddClassN(CL.FindClass('TJvgCustomLabelColors'),'TJvgGroupBoxColors') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Caption', 'TColor', iptrw);
    RegisterProperty('CaptionActive', 'TColor', iptrw);
    RegisterProperty('Client', 'TColor', iptrw);
    RegisterProperty('ClientActive', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgLabelColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgCustomLabelColors', 'TJvgLabelColors') do
  with CL.AddClassN(CL.FindClass('TJvgCustomLabelColors'),'TJvgLabelColors') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgCustomLabelColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgCustomTextColors', 'TJvgCustomLabelColors') do
  with CL.AddClassN(CL.FindClass('TJvgCustomTextColors'),'TJvgCustomLabelColors') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgSimleLabelColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgCustomTextColors', 'TJvgSimleLabelColors') do
  with CL.AddClassN(CL.FindClass('TJvgCustomTextColors'),'TJvgSimleLabelColors') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgCustomTextColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvgCustomTextColors') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvgCustomTextColors') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgLabelTextStyles(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvgLabelTextStyles') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvgLabelTextStyles') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('Passive', 'TglTextStyle', iptrw);
    RegisterProperty('Active', 'TglTextStyle', iptrw);
    RegisterProperty('Disabled', 'TglTextStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgIllumination(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvg2DAlign', 'TJvgIllumination') do
  with CL.AddClassN(CL.FindClass('TJvg2DAlign'),'TJvgIllumination') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('ShadowDepth', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgExtBevelOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgBevelOptions', 'TJvgExtBevelOptions') do
  with CL.AddClassN(CL.FindClass('TJvgBevelOptions'),'TJvgExtBevelOptions') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('BevelPenStyle', 'TPenStyle', iptrw);
    RegisterProperty('BevelPenWidth', 'Word', iptrw);
    RegisterProperty('InteriorOffset', 'Word', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgBevelOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvgBevelOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvgBevelOptions') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function BordersHeight : Integer');
    RegisterMethod('Function BordersWidth : Integer');
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('Inner', 'TPanelBevel', iptrw);
    RegisterProperty('Outer', 'TPanelBevel', iptrw);
    RegisterProperty('Sides', 'TglSides', iptrw);
    RegisterProperty('Bold', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgPointClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvgPointClass') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvgPointClass') do begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('X', 'Integer', iptrw);
    RegisterProperty('Y', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvg2DAlign(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvg2DAlign') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvg2DAlign') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('Horizontal', 'TglHorAlign', iptrw);
    RegisterProperty('Vertical', 'TglVertAlign', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvg3DGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgCustomGradient', 'TJvg3DGradient') do
  with CL.AddClassN(CL.FindClass('TJvgCustomGradient'),'TJvg3DGradient') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Depth', 'Word', iptrw);
    RegisterProperty('GType', 'TThreeDGradientType', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgCustomGradient', 'TJvgGradient') do
  with CL.AddClassN(CL.FindClass('TJvgCustomGradient'),'TJvgGradient') do begin
    RegisterMethod('Procedure Draw( DC : HDC; r : TRect; PenStyle, PenWidth : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgCustomGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvgTwainColors', 'TJvgCustomGradient') do
  with CL.AddClassN(CL.FindClass('TJvgTwainColors'),'TJvgCustomGradient') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure TextOut( DC : HDC; const Str : string; TextR : TRect; X, Y : Integer)');
    RegisterMethod('Function GetColorFromGradientLine( GradientLineWidth, Position : Word) : COLORREF');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgTwainColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvgTwainColors') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvgTwainColors') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('RGBFromColor', 'Longint', iptrw);
    RegisterProperty('RGBToColor', 'Longint', iptrw);
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('FromColor', 'TColor', iptrw);
    RegisterProperty('ToColor', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvgCommClasses(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgTwainColors');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgCustomGradient');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgGradient');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvg3DGradient');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvg2DAlign');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgPointClass');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgBevelOptions');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgExtBevelOptions');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgIllumination');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgLabelTextStyles');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgCustomTextColors');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgSimleLabelColors');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgCustomLabelColors');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgLabelColors');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgGroupBoxColors');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgListBoxItemStyle');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgAskListBoxItemStyle');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgCustomBoxStyle');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgCustomTextBoxStyle');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgTextBoxStyle');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgBevelLines');
  SIRegister_TJvgTwainColors(CL);
  SIRegister_TJvgCustomGradient(CL);
  SIRegister_TJvgGradient(CL);
  SIRegister_TJvg3DGradient(CL);
  SIRegister_TJvg2DAlign(CL);
  SIRegister_TJvgPointClass(CL);
  SIRegister_TJvgBevelOptions(CL);
  SIRegister_TJvgExtBevelOptions(CL);
  SIRegister_TJvgIllumination(CL);
  SIRegister_TJvgLabelTextStyles(CL);
  SIRegister_TJvgCustomTextColors(CL);
  SIRegister_TJvgSimleLabelColors(CL);
  SIRegister_TJvgCustomLabelColors(CL);
  SIRegister_TJvgLabelColors(CL);
  SIRegister_TJvgGroupBoxColors(CL);
  SIRegister_TJvgCustomListBoxItemStyle(CL);
  SIRegister_TJvgListBoxItemStyle(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgHintStyle');
  SIRegister_TJvgSpeedButtonStyle(CL);
  SIRegister_TJvgAskListBoxItemStyle(CL);
  SIRegister_TJvgCustomBoxStyle(CL);
  SIRegister_TJvgCustomTextBoxStyle(CL);
  SIRegister_TJvgTextBoxStyle(CL);
  SIRegister_TJvgBevelLines(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesIgnoreBorder_W(Self: TJvgBevelLines; const T: Boolean);
begin Self.IgnoreBorder := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesIgnoreBorder_R(Self: TJvgBevelLines; var T: Boolean);
begin T := Self.IgnoreBorder; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesThickness_W(Self: TJvgBevelLines; const T: Byte);
begin Self.Thickness := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesThickness_R(Self: TJvgBevelLines; var T: Byte);
begin T := Self.Thickness; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesBold_W(Self: TJvgBevelLines; const T: Boolean);
begin Self.Bold := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesBold_R(Self: TJvgBevelLines; var T: Boolean);
begin T := Self.Bold; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesStyle_W(Self: TJvgBevelLines; const T: TPanelBevel);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesStyle_R(Self: TJvgBevelLines; var T: TPanelBevel);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesOrigin_W(Self: TJvgBevelLines; const T: TglOrigin);
begin Self.Origin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesOrigin_R(Self: TJvgBevelLines; var T: TglOrigin);
begin T := Self.Origin; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesStep_W(Self: TJvgBevelLines; const T: Cardinal);
begin Self.Step := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesStep_R(Self: TJvgBevelLines; var T: Cardinal);
begin T := Self.Step; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesCount_W(Self: TJvgBevelLines; const T: Cardinal);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesCount_R(Self: TJvgBevelLines; var T: Cardinal);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesOnChanged_W(Self: TJvgBevelLines; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelLinesOnChanged_R(Self: TJvgBevelLines; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvgAskListBoxItemStyleBtnTextStyle_W(Self: TJvgAskListBoxItemStyle; const T: TglTextStyle);
begin Self.BtnTextStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgAskListBoxItemStyleBtnTextStyle_R(Self: TJvgAskListBoxItemStyle; var T: TglTextStyle);
begin T := Self.BtnTextStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvgAskListBoxItemStyleBtnFont_W(Self: TJvgAskListBoxItemStyle; const T: TFont);
begin Self.BtnFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgAskListBoxItemStyleBtnFont_R(Self: TJvgAskListBoxItemStyle; var T: TFont);
begin T := Self.BtnFont; end;

(*----------------------------------------------------------------------------*)
procedure TJvgAskListBoxItemStyleBtnColor_W(Self: TJvgAskListBoxItemStyle; const T: TColor);
begin Self.BtnColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgAskListBoxItemStyleBtnColor_R(Self: TJvgAskListBoxItemStyle; var T: TColor);
begin T := Self.BtnColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvgListBoxItemStyleGradient_W(Self: TJvgListBoxItemStyle; const T: TJvgGradient);
begin Self.Gradient := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgListBoxItemStyleGradient_R(Self: TJvgListBoxItemStyle; var T: TJvgGradient);
begin T := Self.Gradient; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleTextStyle_W(Self: TJvgCustomListBoxItemStyle; const T: TglTextStyle);
begin Self.TextStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleTextStyle_R(Self: TJvgCustomListBoxItemStyle; var T: TglTextStyle);
begin T := Self.TextStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleBevel_W(Self: TJvgCustomListBoxItemStyle; const T: TJvgBevelOptions);
begin Self.Bevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleBevel_R(Self: TJvgCustomListBoxItemStyle; var T: TJvgBevelOptions);
begin T := Self.Bevel; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleFont_W(Self: TJvgCustomListBoxItemStyle; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleFont_R(Self: TJvgCustomListBoxItemStyle; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleDelineateColor_W(Self: TJvgCustomListBoxItemStyle; const T: TColor);
begin Self.DelineateColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleDelineateColor_R(Self: TJvgCustomListBoxItemStyle; var T: TColor);
begin T := Self.DelineateColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleColor_W(Self: TJvgCustomListBoxItemStyle; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleColor_R(Self: TJvgCustomListBoxItemStyle; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleOnChanged_W(Self: TJvgCustomListBoxItemStyle; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomListBoxItemStyleOnChanged_R(Self: TJvgCustomListBoxItemStyle; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvgGroupBoxColorsClientActive_W(Self: TJvgGroupBoxColors; const T: TColor);
begin Self.ClientActive := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgGroupBoxColorsClientActive_R(Self: TJvgGroupBoxColors; var T: TColor);
begin T := Self.ClientActive; end;

(*----------------------------------------------------------------------------*)
procedure TJvgGroupBoxColorsClient_W(Self: TJvgGroupBoxColors; const T: TColor);
begin Self.Client := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgGroupBoxColorsClient_R(Self: TJvgGroupBoxColors; var T: TColor);
begin T := Self.Client; end;

(*----------------------------------------------------------------------------*)
procedure TJvgGroupBoxColorsCaptionActive_W(Self: TJvgGroupBoxColors; const T: TColor);
begin Self.CaptionActive := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgGroupBoxColorsCaptionActive_R(Self: TJvgGroupBoxColors; var T: TColor);
begin T := Self.CaptionActive; end;

(*----------------------------------------------------------------------------*)
procedure TJvgGroupBoxColorsCaption_W(Self: TJvgGroupBoxColors; const T: TColor);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgGroupBoxColorsCaption_R(Self: TJvgGroupBoxColors; var T: TColor);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomTextColorsOnChanged_W(Self: TJvgCustomTextColors; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgCustomTextColorsOnChanged_R(Self: TJvgCustomTextColors; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvgLabelTextStylesDisabled_W(Self: TJvgLabelTextStyles; const T: TglTextStyle);
begin Self.Disabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgLabelTextStylesDisabled_R(Self: TJvgLabelTextStyles; var T: TglTextStyle);
begin T := Self.Disabled; end;

(*----------------------------------------------------------------------------*)
procedure TJvgLabelTextStylesActive_W(Self: TJvgLabelTextStyles; const T: TglTextStyle);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgLabelTextStylesActive_R(Self: TJvgLabelTextStyles; var T: TglTextStyle);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TJvgLabelTextStylesPassive_W(Self: TJvgLabelTextStyles; const T: TglTextStyle);
begin Self.Passive := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgLabelTextStylesPassive_R(Self: TJvgLabelTextStyles; var T: TglTextStyle);
begin T := Self.Passive; end;

(*----------------------------------------------------------------------------*)
procedure TJvgLabelTextStylesOnChanged_W(Self: TJvgLabelTextStyles; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgLabelTextStylesOnChanged_R(Self: TJvgLabelTextStyles; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvgIlluminationShadowDepth_W(Self: TJvgIllumination; const T: Integer);
begin Self.ShadowDepth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgIlluminationShadowDepth_R(Self: TJvgIllumination; var T: Integer);
begin T := Self.ShadowDepth; end;

(*----------------------------------------------------------------------------*)
procedure TJvgExtBevelOptionsInteriorOffset_W(Self: TJvgExtBevelOptions; const T: Word);
begin Self.InteriorOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgExtBevelOptionsInteriorOffset_R(Self: TJvgExtBevelOptions; var T: Word);
begin T := Self.InteriorOffset; end;

(*----------------------------------------------------------------------------*)
procedure TJvgExtBevelOptionsBevelPenWidth_W(Self: TJvgExtBevelOptions; const T: Word);
begin Self.BevelPenWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgExtBevelOptionsBevelPenWidth_R(Self: TJvgExtBevelOptions; var T: Word);
begin T := Self.BevelPenWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvgExtBevelOptionsBevelPenStyle_W(Self: TJvgExtBevelOptions; const T: TPenStyle);
begin Self.BevelPenStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgExtBevelOptionsBevelPenStyle_R(Self: TJvgExtBevelOptions; var T: TPenStyle);
begin T := Self.BevelPenStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvgExtBevelOptionsActive_W(Self: TJvgExtBevelOptions; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgExtBevelOptionsActive_R(Self: TJvgExtBevelOptions; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelOptionsBold_W(Self: TJvgBevelOptions; const T: Boolean);
begin Self.Bold := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelOptionsBold_R(Self: TJvgBevelOptions; var T: Boolean);
begin T := Self.Bold; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelOptionsSides_W(Self: TJvgBevelOptions; const T: TglSides);
begin Self.Sides := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelOptionsSides_R(Self: TJvgBevelOptions; var T: TglSides);
begin T := Self.Sides; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelOptionsOuter_W(Self: TJvgBevelOptions; const T: TPanelBevel);
begin Self.Outer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelOptionsOuter_R(Self: TJvgBevelOptions; var T: TPanelBevel);
begin T := Self.Outer; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelOptionsInner_W(Self: TJvgBevelOptions; const T: TPanelBevel);
begin Self.Inner := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelOptionsInner_R(Self: TJvgBevelOptions; var T: TPanelBevel);
begin T := Self.Inner; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelOptionsOnChanged_W(Self: TJvgBevelOptions; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgBevelOptionsOnChanged_R(Self: TJvgBevelOptions; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPointClassY_W(Self: TJvgPointClass; const T: Integer);
begin Self.Y := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPointClassY_R(Self: TJvgPointClass; var T: Integer);
begin T := Self.Y; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPointClassX_W(Self: TJvgPointClass; const T: Integer);
begin Self.X := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPointClassX_R(Self: TJvgPointClass; var T: Integer);
begin T := Self.X; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPointClassOnChanged_W(Self: TJvgPointClass; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPointClassOnChanged_R(Self: TJvgPointClass; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvg2DAlignVertical_W(Self: TJvg2DAlign; const T: TglVertAlign);
begin Self.Vertical := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvg2DAlignVertical_R(Self: TJvg2DAlign; var T: TglVertAlign);
begin T := Self.Vertical; end;

(*----------------------------------------------------------------------------*)
procedure TJvg2DAlignHorizontal_W(Self: TJvg2DAlign; const T: TglHorAlign);
begin Self.Horizontal := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvg2DAlignHorizontal_R(Self: TJvg2DAlign; var T: TglHorAlign);
begin T := Self.Horizontal; end;

(*----------------------------------------------------------------------------*)
procedure TJvg2DAlignOnChanged_W(Self: TJvg2DAlign; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvg2DAlignOnChanged_R(Self: TJvg2DAlign; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvg3DGradientGType_W(Self: TJvg3DGradient; const T: TThreeDGradientType);
begin Self.GType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvg3DGradientGType_R(Self: TJvg3DGradient; var T: TThreeDGradientType);
begin T := Self.GType; end;

(*----------------------------------------------------------------------------*)
procedure TJvg3DGradientDepth_W(Self: TJvg3DGradient; const T: Word);
begin Self.Depth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvg3DGradientDepth_R(Self: TJvg3DGradient; var T: Word);
begin T := Self.Depth; end;

(*----------------------------------------------------------------------------*)
procedure TJvgTwainColorsToColor_W(Self: TJvgTwainColors; const T: TColor);
begin Self.ToColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgTwainColorsToColor_R(Self: TJvgTwainColors; var T: TColor);
begin T := Self.ToColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvgTwainColorsFromColor_W(Self: TJvgTwainColors; const T: TColor);
begin Self.FromColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgTwainColorsFromColor_R(Self: TJvgTwainColors; var T: TColor);
begin T := Self.FromColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvgTwainColorsOnChanged_W(Self: TJvgTwainColors; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgTwainColorsOnChanged_R(Self: TJvgTwainColors; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvgTwainColorsRGBToColor_W(Self: TJvgTwainColors; const T: Longint);
begin Self.RGBToColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgTwainColorsRGBToColor_R(Self: TJvgTwainColors; var T: Longint);
begin T := Self.RGBToColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvgTwainColorsRGBFromColor_W(Self: TJvgTwainColors; const T: Longint);
begin Self.RGBFromColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgTwainColorsRGBFromColor_R(Self: TJvgTwainColors; var T: Longint);
begin T := Self.RGBFromColor; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgBevelLines(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgBevelLines) do
  begin
    RegisterConstructor(@TJvgBevelLines.Create, 'Create');
    RegisterMethod(@TJvgBevelLines.Assign, 'Assign');
    RegisterPropertyHelper(@TJvgBevelLinesOnChanged_R,@TJvgBevelLinesOnChanged_W,'OnChanged');
    RegisterPropertyHelper(@TJvgBevelLinesCount_R,@TJvgBevelLinesCount_W,'Count');
    RegisterPropertyHelper(@TJvgBevelLinesStep_R,@TJvgBevelLinesStep_W,'Step');
    RegisterPropertyHelper(@TJvgBevelLinesOrigin_R,@TJvgBevelLinesOrigin_W,'Origin');
    RegisterPropertyHelper(@TJvgBevelLinesStyle_R,@TJvgBevelLinesStyle_W,'Style');
    RegisterPropertyHelper(@TJvgBevelLinesBold_R,@TJvgBevelLinesBold_W,'Bold');
    RegisterPropertyHelper(@TJvgBevelLinesThickness_R,@TJvgBevelLinesThickness_W,'Thickness');
    RegisterPropertyHelper(@TJvgBevelLinesIgnoreBorder_R,@TJvgBevelLinesIgnoreBorder_W,'IgnoreBorder');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgTextBoxStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgTextBoxStyle) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgCustomTextBoxStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgCustomTextBoxStyle) do
  begin
    RegisterConstructor(@TJvgCustomTextBoxStyle.Create, 'Create');
    RegisterMethod(@TJvgCustomTextBoxStyle.Assign, 'Assign');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgCustomBoxStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgCustomBoxStyle) do
  begin
    RegisterConstructor(@TJvgCustomBoxStyle.Create, 'Create');
    RegisterMethod(@TJvgCustomBoxStyle.Assign, 'Assign');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgAskListBoxItemStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgAskListBoxItemStyle) do
  begin
    RegisterConstructor(@TJvgAskListBoxItemStyle.Create, 'Create');
    RegisterMethod(@TJvgAskListBoxItemStyle.Assign, 'Assign');
    RegisterPropertyHelper(@TJvgAskListBoxItemStyleBtnColor_R,@TJvgAskListBoxItemStyleBtnColor_W,'BtnColor');
    RegisterPropertyHelper(@TJvgAskListBoxItemStyleBtnFont_R,@TJvgAskListBoxItemStyleBtnFont_W,'BtnFont');
    RegisterPropertyHelper(@TJvgAskListBoxItemStyleBtnTextStyle_R,@TJvgAskListBoxItemStyleBtnTextStyle_W,'BtnTextStyle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgSpeedButtonStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgSpeedButtonStyle) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgListBoxItemStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgListBoxItemStyle) do
  begin
    RegisterConstructor(@TJvgListBoxItemStyle.Create, 'Create');
    RegisterMethod(@TJvgListBoxItemStyle.Assign, 'Assign');
    RegisterPropertyHelper(@TJvgListBoxItemStyleGradient_R,@TJvgListBoxItemStyleGradient_W,'Gradient');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgCustomListBoxItemStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgCustomListBoxItemStyle) do
  begin
    RegisterVirtualConstructor(@TJvgCustomListBoxItemStyle.Create, 'Create');
    RegisterMethod(@TJvgCustomListBoxItemStyle.Assign, 'Assign');
    RegisterMethod(@TJvgCustomListBoxItemStyle.HighlightColor, 'HighlightColor');
    RegisterMethod(@TJvgCustomListBoxItemStyle.ShadowColor, 'ShadowColor');
    RegisterPropertyHelper(@TJvgCustomListBoxItemStyleOnChanged_R,@TJvgCustomListBoxItemStyleOnChanged_W,'OnChanged');
    RegisterPropertyHelper(@TJvgCustomListBoxItemStyleColor_R,@TJvgCustomListBoxItemStyleColor_W,'Color');
    RegisterPropertyHelper(@TJvgCustomListBoxItemStyleDelineateColor_R,@TJvgCustomListBoxItemStyleDelineateColor_W,'DelineateColor');
    RegisterPropertyHelper(@TJvgCustomListBoxItemStyleFont_R,@TJvgCustomListBoxItemStyleFont_W,'Font');
    RegisterPropertyHelper(@TJvgCustomListBoxItemStyleBevel_R,@TJvgCustomListBoxItemStyleBevel_W,'Bevel');
    RegisterPropertyHelper(@TJvgCustomListBoxItemStyleTextStyle_R,@TJvgCustomListBoxItemStyleTextStyle_W,'TextStyle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgGroupBoxColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgGroupBoxColors) do
  begin
    RegisterConstructor(@TJvgGroupBoxColors.Create, 'Create');
    RegisterMethod(@TJvgGroupBoxColors.Assign, 'Assign');
    RegisterPropertyHelper(@TJvgGroupBoxColorsCaption_R,@TJvgGroupBoxColorsCaption_W,'Caption');
    RegisterPropertyHelper(@TJvgGroupBoxColorsCaptionActive_R,@TJvgGroupBoxColorsCaptionActive_W,'CaptionActive');
    RegisterPropertyHelper(@TJvgGroupBoxColorsClient_R,@TJvgGroupBoxColorsClient_W,'Client');
    RegisterPropertyHelper(@TJvgGroupBoxColorsClientActive_R,@TJvgGroupBoxColorsClientActive_W,'ClientActive');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgLabelColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgLabelColors) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgCustomLabelColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgCustomLabelColors) do
  begin
    RegisterConstructor(@TJvgCustomLabelColors.Create, 'Create');
    RegisterMethod(@TJvgCustomLabelColors.Assign, 'Assign');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgSimleLabelColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgSimleLabelColors) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgCustomTextColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgCustomTextColors) do
  begin
    RegisterVirtualConstructor(@TJvgCustomTextColors.Create, 'Create');
    RegisterMethod(@TJvgCustomTextColors.Assign, 'Assign');
    RegisterPropertyHelper(@TJvgCustomTextColorsOnChanged_R,@TJvgCustomTextColorsOnChanged_W,'OnChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgLabelTextStyles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgLabelTextStyles) do
  begin
    RegisterConstructor(@TJvgLabelTextStyles.Create, 'Create');
    RegisterMethod(@TJvgLabelTextStyles.Assign, 'Assign');
    RegisterPropertyHelper(@TJvgLabelTextStylesOnChanged_R,@TJvgLabelTextStylesOnChanged_W,'OnChanged');
    RegisterPropertyHelper(@TJvgLabelTextStylesPassive_R,@TJvgLabelTextStylesPassive_W,'Passive');
    RegisterPropertyHelper(@TJvgLabelTextStylesActive_R,@TJvgLabelTextStylesActive_W,'Active');
    RegisterPropertyHelper(@TJvgLabelTextStylesDisabled_R,@TJvgLabelTextStylesDisabled_W,'Disabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgIllumination(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgIllumination) do
  begin
    RegisterConstructor(@TJvgIllumination.Create, 'Create');
    RegisterMethod(@TJvgIllumination.Assign, 'Assign');
    RegisterPropertyHelper(@TJvgIlluminationShadowDepth_R,@TJvgIlluminationShadowDepth_W,'ShadowDepth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgExtBevelOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgExtBevelOptions) do
  begin
    RegisterConstructor(@TJvgExtBevelOptions.Create, 'Create');
    RegisterMethod(@TJvgExtBevelOptions.Assign, 'Assign');
    RegisterPropertyHelper(@TJvgExtBevelOptionsActive_R,@TJvgExtBevelOptionsActive_W,'Active');
    RegisterPropertyHelper(@TJvgExtBevelOptionsBevelPenStyle_R,@TJvgExtBevelOptionsBevelPenStyle_W,'BevelPenStyle');
    RegisterPropertyHelper(@TJvgExtBevelOptionsBevelPenWidth_R,@TJvgExtBevelOptionsBevelPenWidth_W,'BevelPenWidth');
    RegisterPropertyHelper(@TJvgExtBevelOptionsInteriorOffset_R,@TJvgExtBevelOptionsInteriorOffset_W,'InteriorOffset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgBevelOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgBevelOptions) do
  begin
    RegisterVirtualConstructor(@TJvgBevelOptions.Create, 'Create');
    RegisterMethod(@TJvgBevelOptions.Assign, 'Assign');
    RegisterMethod(@TJvgBevelOptions.BordersHeight, 'BordersHeight');
    RegisterMethod(@TJvgBevelOptions.BordersWidth, 'BordersWidth');
    RegisterPropertyHelper(@TJvgBevelOptionsOnChanged_R,@TJvgBevelOptionsOnChanged_W,'OnChanged');
    RegisterPropertyHelper(@TJvgBevelOptionsInner_R,@TJvgBevelOptionsInner_W,'Inner');
    RegisterPropertyHelper(@TJvgBevelOptionsOuter_R,@TJvgBevelOptionsOuter_W,'Outer');
    RegisterPropertyHelper(@TJvgBevelOptionsSides_R,@TJvgBevelOptionsSides_W,'Sides');
    RegisterPropertyHelper(@TJvgBevelOptionsBold_R,@TJvgBevelOptionsBold_W,'Bold');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgPointClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgPointClass) do
  begin
    RegisterMethod(@TJvgPointClass.Assign, 'Assign');
    RegisterPropertyHelper(@TJvgPointClassOnChanged_R,@TJvgPointClassOnChanged_W,'OnChanged');
    RegisterPropertyHelper(@TJvgPointClassX_R,@TJvgPointClassX_W,'X');
    RegisterPropertyHelper(@TJvgPointClassY_R,@TJvgPointClassY_W,'Y');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvg2DAlign(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvg2DAlign) do
  begin
    RegisterConstructor(@TJvg2DAlign.Create, 'Create');
    RegisterMethod(@TJvg2DAlign.Assign, 'Assign');
    RegisterPropertyHelper(@TJvg2DAlignOnChanged_R,@TJvg2DAlignOnChanged_W,'OnChanged');
    RegisterPropertyHelper(@TJvg2DAlignHorizontal_R,@TJvg2DAlignHorizontal_W,'Horizontal');
    RegisterPropertyHelper(@TJvg2DAlignVertical_R,@TJvg2DAlignVertical_W,'Vertical');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvg3DGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvg3DGradient) do
  begin
    RegisterConstructor(@TJvg3DGradient.Create, 'Create');
    RegisterMethod(@TJvg3DGradient.Assign, 'Assign');
    RegisterPropertyHelper(@TJvg3DGradientDepth_R,@TJvg3DGradientDepth_W,'Depth');
    RegisterPropertyHelper(@TJvg3DGradientGType_R,@TJvg3DGradientGType_W,'GType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgGradient) do
  begin
    RegisterMethod(@TJvgGradient.Draw, 'Draw');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgCustomGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgCustomGradient) do
  begin
    RegisterConstructor(@TJvgCustomGradient.Create, 'Create');
    RegisterMethod(@TJvgCustomGradient.Assign, 'Assign');
    RegisterMethod(@TJvgCustomGradient.TextOut, 'TextOut');
    RegisterMethod(@TJvgCustomGradient.GetColorFromGradientLine, 'GetColorFromGradientLine');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgTwainColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgTwainColors) do
  begin
    RegisterVirtualConstructor(@TJvgTwainColors.Create, 'Create');
    RegisterMethod(@TJvgTwainColors.Assign, 'Assign');
    RegisterPropertyHelper(@TJvgTwainColorsRGBFromColor_R,@TJvgTwainColorsRGBFromColor_W,'RGBFromColor');
    RegisterPropertyHelper(@TJvgTwainColorsRGBToColor_R,@TJvgTwainColorsRGBToColor_W,'RGBToColor');
    RegisterPropertyHelper(@TJvgTwainColorsOnChanged_R,@TJvgTwainColorsOnChanged_W,'OnChanged');
    RegisterPropertyHelper(@TJvgTwainColorsFromColor_R,@TJvgTwainColorsFromColor_W,'FromColor');
    RegisterPropertyHelper(@TJvgTwainColorsToColor_R,@TJvgTwainColorsToColor_W,'ToColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvgCommClasses(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgTwainColors) do
  with CL.Add(TJvgCustomGradient) do
  with CL.Add(TJvgGradient) do
  with CL.Add(TJvg3DGradient) do
  with CL.Add(TJvg2DAlign) do
  with CL.Add(TJvgPointClass) do
  with CL.Add(TJvgBevelOptions) do
  with CL.Add(TJvgExtBevelOptions) do
  with CL.Add(TJvgIllumination) do
  with CL.Add(TJvgLabelTextStyles) do
  with CL.Add(TJvgCustomTextColors) do
  with CL.Add(TJvgSimleLabelColors) do
  with CL.Add(TJvgCustomLabelColors) do
  with CL.Add(TJvgLabelColors) do
  with CL.Add(TJvgGroupBoxColors) do
  with CL.Add(TJvgListBoxItemStyle) do
  with CL.Add(TJvgAskListBoxItemStyle) do
  with CL.Add(TJvgCustomBoxStyle) do
  with CL.Add(TJvgCustomTextBoxStyle) do
  with CL.Add(TJvgTextBoxStyle) do
  with CL.Add(TJvgBevelLines) do
  RIRegister_TJvgTwainColors(CL);
  RIRegister_TJvgCustomGradient(CL);
  RIRegister_TJvgGradient(CL);
  RIRegister_TJvg3DGradient(CL);
  RIRegister_TJvg2DAlign(CL);
  RIRegister_TJvgPointClass(CL);
  RIRegister_TJvgBevelOptions(CL);
  RIRegister_TJvgExtBevelOptions(CL);
  RIRegister_TJvgIllumination(CL);
  RIRegister_TJvgLabelTextStyles(CL);
  RIRegister_TJvgCustomTextColors(CL);
  RIRegister_TJvgSimleLabelColors(CL);
  RIRegister_TJvgCustomLabelColors(CL);
  RIRegister_TJvgLabelColors(CL);
  RIRegister_TJvgGroupBoxColors(CL);
  RIRegister_TJvgCustomListBoxItemStyle(CL);
  RIRegister_TJvgListBoxItemStyle(CL);
  with CL.Add(TJvgHintStyle) do
  RIRegister_TJvgSpeedButtonStyle(CL);
  RIRegister_TJvgAskListBoxItemStyle(CL);
  RIRegister_TJvgCustomBoxStyle(CL);
  RIRegister_TJvgCustomTextBoxStyle(CL);
  RIRegister_TJvgTextBoxStyle(CL);
  RIRegister_TJvgBevelLines(CL);
end;

 
 
{ TPSImport_JvgCommClasses }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgCommClasses.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvgCommClasses(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgCommClasses.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvgCommClasses(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
