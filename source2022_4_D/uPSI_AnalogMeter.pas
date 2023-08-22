unit uPSI_AnalogMeter;
{
   to be a vu meter
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
  TPSImport_AnalogMeter = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAnalogMeter(CL: TPSPascalCompiler);
procedure SIRegister_AnalogMeter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AnalogMeter_Routines(S: TPSExec);
procedure RIRegister_TAnalogMeter(CL: TPSRuntimeClassImporter);
procedure RIRegister_AnalogMeter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,ExtCtrls
  ,AnalogMeter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AnalogMeter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAnalogMeter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPaintBox', 'TAnalogMeter') do
  with CL.AddClassN(CL.FindClass('TPaintBox'),'TAnalogMeter') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
     RegisterProperty('Caption', 'String', iptrw);
    RegisterProperty('Min', 'LongInt', iptrw);
    RegisterProperty('Max', 'LongInt', iptrw);
    RegisterProperty('Value', 'LongInt', iptrw);
    RegisterProperty('AngularRange', 'LongInt', iptrw);
    RegisterProperty('TickCount', 'LongInt', iptrw);
    RegisterProperty('LowZone', 'Byte', iptrw);
    RegisterProperty('HighZone', 'Byte', iptrw);
    RegisterProperty('ShowValue', 'Boolean', iptrw);
    RegisterProperty('HighZoneColor', 'TColor', iptrw);
    RegisterProperty('LowZoneColor', 'TColor', iptrw);
    RegisterProperty('OKZoneColor', 'TColor', iptrw);
    RegisterProperty('TickColor', 'TColor', iptrw);
    RegisterProperty('ShowTicks', 'Boolean', iptrw);
    RegisterProperty('ShowFrame', 'Boolean', iptrw);
    RegisterProperty('onResize', 'TNotifyEvent', iptrw);
    RegisterProperty('onChange', 'TNotifyEvent', iptrw);
    RegisterProperty('EnableZoneEvents', 'Boolean', iptrw);
    RegisterProperty('onRiseAboveHigh', 'TNotifyEvent', iptrw);
    RegisterProperty('onFallBelowHigh', 'TNotifyEvent', iptrw);
    RegisterProperty('onRiseAboveLow', 'TNotifyEvent', iptrw);
    RegisterProperty('onFallBelowLow', 'TNotifyEvent', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
     RegisterpublishedProperties;
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     //RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);

    //unit uPSI_AnalogMeter;

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AnalogMeter(CL: TPSPascalCompiler);
begin
  SIRegister_TAnalogMeter(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAnalogMeterFont_W(Self: TAnalogMeter; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterFont_R(Self: TAnalogMeter; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronFallBelowLow_W(Self: TAnalogMeter; const T: TNotifyEvent);
begin Self.onFallBelowLow := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronFallBelowLow_R(Self: TAnalogMeter; var T: TNotifyEvent);
begin T := Self.onFallBelowLow; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronRiseAboveLow_W(Self: TAnalogMeter; const T: TNotifyEvent);
begin Self.onRiseAboveLow := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronRiseAboveLow_R(Self: TAnalogMeter; var T: TNotifyEvent);
begin T := Self.onRiseAboveLow; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronFallBelowHigh_W(Self: TAnalogMeter; const T: TNotifyEvent);
begin Self.onFallBelowHigh := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronFallBelowHigh_R(Self: TAnalogMeter; var T: TNotifyEvent);
begin T := Self.onFallBelowHigh; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronRiseAboveHigh_W(Self: TAnalogMeter; const T: TNotifyEvent);
begin Self.onRiseAboveHigh := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronRiseAboveHigh_R(Self: TAnalogMeter; var T: TNotifyEvent);
begin T := Self.onRiseAboveHigh; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterEnableZoneEvents_W(Self: TAnalogMeter; const T: Boolean);
begin Self.EnableZoneEvents := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterEnableZoneEvents_R(Self: TAnalogMeter; var T: Boolean);
begin T := Self.EnableZoneEvents; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronChange_W(Self: TAnalogMeter; const T: TNotifyEvent);
begin Self.onChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronChange_R(Self: TAnalogMeter; var T: TNotifyEvent);
begin T := Self.onChange; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronResize_W(Self: TAnalogMeter; const T: TNotifyEvent);
begin Self.onResize := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeteronResize_R(Self: TAnalogMeter; var T: TNotifyEvent);
begin T := Self.onResize; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterShowFrame_W(Self: TAnalogMeter; const T: Boolean);
begin Self.ShowFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterShowFrame_R(Self: TAnalogMeter; var T: Boolean);
begin T := Self.ShowFrame; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterShowTicks_W(Self: TAnalogMeter; const T: Boolean);
begin Self.ShowTicks := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterShowTicks_R(Self: TAnalogMeter; var T: Boolean);
begin T := Self.ShowTicks; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterTickColor_W(Self: TAnalogMeter; const T: TColor);
begin Self.TickColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterTickColor_R(Self: TAnalogMeter; var T: TColor);
begin T := Self.TickColor; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterOKZoneColor_W(Self: TAnalogMeter; const T: TColor);
begin Self.OKZoneColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterOKZoneColor_R(Self: TAnalogMeter; var T: TColor);
begin T := Self.OKZoneColor; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterLowZoneColor_W(Self: TAnalogMeter; const T: TColor);
begin Self.LowZoneColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterLowZoneColor_R(Self: TAnalogMeter; var T: TColor);
begin T := Self.LowZoneColor; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterHighZoneColor_W(Self: TAnalogMeter; const T: TColor);
begin Self.HighZoneColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterHighZoneColor_R(Self: TAnalogMeter; var T: TColor);
begin T := Self.HighZoneColor; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterShowValue_W(Self: TAnalogMeter; const T: Boolean);
begin Self.ShowValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterShowValue_R(Self: TAnalogMeter; var T: Boolean);
begin T := Self.ShowValue; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterHighZone_W(Self: TAnalogMeter; const T: Byte);
begin Self.HighZone := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterHighZone_R(Self: TAnalogMeter; var T: Byte);
begin T := Self.HighZone; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterLowZone_W(Self: TAnalogMeter; const T: Byte);
begin Self.LowZone := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterLowZone_R(Self: TAnalogMeter; var T: Byte);
begin T := Self.LowZone; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterTickCount_W(Self: TAnalogMeter; const T: LongInt);
begin Self.TickCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterTickCount_R(Self: TAnalogMeter; var T: LongInt);
begin T := Self.TickCount; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterAngularRange_W(Self: TAnalogMeter; const T: LongInt);
begin Self.AngularRange := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterAngularRange_R(Self: TAnalogMeter; var T: LongInt);
begin T := Self.AngularRange; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterValue_W(Self: TAnalogMeter; const T: LongInt);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterValue_R(Self: TAnalogMeter; var T: LongInt);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterMax_W(Self: TAnalogMeter; const T: LongInt);
begin Self.Max := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterMax_R(Self: TAnalogMeter; var T: LongInt);
begin T := Self.Max; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterMin_W(Self: TAnalogMeter; const T: LongInt);
begin Self.Min := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterMin_R(Self: TAnalogMeter; var T: LongInt);
begin T := Self.Min; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterCaption_W(Self: TAnalogMeter; const T: String);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnalogMeterCaption_R(Self: TAnalogMeter; var T: String);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AnalogMeter_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAnalogMeter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAnalogMeter) do begin
    RegisterConstructor(@TAnalogMeter.Create, 'Create');
       RegisterMethod(@TAnalogMeter.Destroy, 'Free');
    RegisterPropertyHelper(@TAnalogMeterCaption_R,@TAnalogMeterCaption_W,'Caption');
    RegisterPropertyHelper(@TAnalogMeterMin_R,@TAnalogMeterMin_W,'Min');
    RegisterPropertyHelper(@TAnalogMeterMax_R,@TAnalogMeterMax_W,'Max');
    RegisterPropertyHelper(@TAnalogMeterValue_R,@TAnalogMeterValue_W,'Value');
    RegisterPropertyHelper(@TAnalogMeterAngularRange_R,@TAnalogMeterAngularRange_W,'AngularRange');
    RegisterPropertyHelper(@TAnalogMeterTickCount_R,@TAnalogMeterTickCount_W,'TickCount');
    RegisterPropertyHelper(@TAnalogMeterLowZone_R,@TAnalogMeterLowZone_W,'LowZone');
    RegisterPropertyHelper(@TAnalogMeterHighZone_R,@TAnalogMeterHighZone_W,'HighZone');
    RegisterPropertyHelper(@TAnalogMeterShowValue_R,@TAnalogMeterShowValue_W,'ShowValue');
    RegisterPropertyHelper(@TAnalogMeterHighZoneColor_R,@TAnalogMeterHighZoneColor_W,'HighZoneColor');
    RegisterPropertyHelper(@TAnalogMeterLowZoneColor_R,@TAnalogMeterLowZoneColor_W,'LowZoneColor');
    RegisterPropertyHelper(@TAnalogMeterOKZoneColor_R,@TAnalogMeterOKZoneColor_W,'OKZoneColor');
    RegisterPropertyHelper(@TAnalogMeterTickColor_R,@TAnalogMeterTickColor_W,'TickColor');
    RegisterPropertyHelper(@TAnalogMeterShowTicks_R,@TAnalogMeterShowTicks_W,'ShowTicks');
    RegisterPropertyHelper(@TAnalogMeterShowFrame_R,@TAnalogMeterShowFrame_W,'ShowFrame');
    RegisterPropertyHelper(@TAnalogMeteronResize_R,@TAnalogMeteronResize_W,'onResize');
    RegisterPropertyHelper(@TAnalogMeteronChange_R,@TAnalogMeteronChange_W,'onChange');
    RegisterPropertyHelper(@TAnalogMeterEnableZoneEvents_R,@TAnalogMeterEnableZoneEvents_W,'EnableZoneEvents');
    RegisterPropertyHelper(@TAnalogMeteronRiseAboveHigh_R,@TAnalogMeteronRiseAboveHigh_W,'onRiseAboveHigh');
    RegisterPropertyHelper(@TAnalogMeteronFallBelowHigh_R,@TAnalogMeteronFallBelowHigh_W,'onFallBelowHigh');
    RegisterPropertyHelper(@TAnalogMeteronRiseAboveLow_R,@TAnalogMeteronRiseAboveLow_W,'onRiseAboveLow');
    RegisterPropertyHelper(@TAnalogMeteronFallBelowLow_R,@TAnalogMeteronFallBelowLow_W,'onFallBelowLow');
    RegisterPropertyHelper(@TAnalogMeterFont_R,@TAnalogMeterFont_W,'Font');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AnalogMeter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAnalogMeter(CL);
end;

 
 
{ TPSImport_AnalogMeter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AnalogMeter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AnalogMeter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AnalogMeter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AnalogMeter(ri);
  RIRegister_AnalogMeter_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
