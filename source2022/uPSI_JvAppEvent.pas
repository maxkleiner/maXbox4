unit uPSI_JvAppEvent;
{
  apps or a
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
  TPSImport_JvAppEvent = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvAppEvents(CL: TPSPascalCompiler);
procedure SIRegister_JvAppEvent(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvAppEvents(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvAppEvent(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Messages
  ,Controls
  ,Graphics
  ,Forms
  ,ActnList
  ,JvTypes
  ,JvComponentBase
  ,JvAppEvent
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvAppEvent]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAppEvents(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvAppEvents') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvAppEvents') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure CancelDispatch');
    RegisterProperty('Chained', 'Boolean', iptrw);
    RegisterProperty('HintColor', 'TColor', iptrw);
    RegisterProperty('HintPause', 'Integer', iptrw);
    RegisterProperty('ShowHint', 'Boolean', iptrw);
    RegisterProperty('UpdateFormatSettings', 'Boolean', iptrw);
    RegisterProperty('HintShortPause', 'Integer', iptrw);
    RegisterProperty('HintHidePause', 'Integer', iptrw);
    RegisterProperty('ShowMainForm', 'Boolean', iptrw);
    RegisterProperty('HintShortCuts', 'Boolean', iptrw);
    RegisterProperty('UpdateMetricSettings', 'Boolean', iptrw);
    RegisterProperty('BiDiMode', 'TBiDiMode', iptrw);
    RegisterProperty('BiDiKeyboard', 'string', iptrw);
    RegisterProperty('NonBiDiKeyboard', 'string', iptrw);
    RegisterProperty('MouseDragImmediate', 'Boolean', iptrw);
    RegisterProperty('MouseDragThreshold', 'Integer', iptrw);
    RegisterProperty('OnActionExecute', 'TActionEvent', iptrw);
    RegisterProperty('OnActionUpdate', 'TActionEvent', iptrw);
    RegisterProperty('OnShortCut', 'TShortCutEvent', iptrw);
    RegisterProperty('OnActivate', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDeactivate', 'TNotifyEvent', iptrw);
    RegisterProperty('OnException', 'TExceptionEvent', iptrw);
    RegisterProperty('OnIdle', 'TIdleEvent', iptrw);
    RegisterProperty('OnHelp', 'THelpEvent', iptrw);
    RegisterProperty('OnHint', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMinimize', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPaintIcon', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRestore', 'TNotifyEvent', iptrw);
    RegisterProperty('OnShowHint', 'TShowHintEvent', iptrw);
    RegisterProperty('OnModalBegin', 'TNotifyEvent', iptrw);
    RegisterProperty('OnModalEnd', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMessage', 'TMessageEvent', iptrw);
    RegisterProperty('OnSettingsChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnActiveControlChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnActiveFormChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvAppEvent(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('DefHintColor','').SetString( clInfoBk);
 CL.AddConstantN('DefHintPause','LongInt').SetInt( 500);
 CL.AddConstantN('DefHintShortPause','LongInt').SetInt( DefHintPause div 10);
 CL.AddConstantN('DefHintHidePause','LongInt').SetInt( DefHintPause * 5);
  SIRegister_TJvAppEvents(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnActiveFormChange_W(Self: TJvAppEvents; const T: TNotifyEvent);
begin Self.OnActiveFormChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnActiveFormChange_R(Self: TJvAppEvents; var T: TNotifyEvent);
begin T := Self.OnActiveFormChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnActiveControlChange_W(Self: TJvAppEvents; const T: TNotifyEvent);
begin Self.OnActiveControlChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnActiveControlChange_R(Self: TJvAppEvents; var T: TNotifyEvent);
begin T := Self.OnActiveControlChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnSettingsChanged_W(Self: TJvAppEvents; const T: TNotifyEvent);
begin Self.OnSettingsChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnSettingsChanged_R(Self: TJvAppEvents; var T: TNotifyEvent);
begin T := Self.OnSettingsChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnMessage_W(Self: TJvAppEvents; const T: TMessageEvent);
begin Self.OnMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnMessage_R(Self: TJvAppEvents; var T: TMessageEvent);
begin T := Self.OnMessage; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnModalEnd_W(Self: TJvAppEvents; const T: TNotifyEvent);
begin Self.OnModalEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnModalEnd_R(Self: TJvAppEvents; var T: TNotifyEvent);
begin T := Self.OnModalEnd; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnModalBegin_W(Self: TJvAppEvents; const T: TNotifyEvent);
begin Self.OnModalBegin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnModalBegin_R(Self: TJvAppEvents; var T: TNotifyEvent);
begin T := Self.OnModalBegin; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnShowHint_W(Self: TJvAppEvents; const T: TShowHintEvent);
begin Self.OnShowHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnShowHint_R(Self: TJvAppEvents; var T: TShowHintEvent);
begin T := Self.OnShowHint; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnRestore_W(Self: TJvAppEvents; const T: TNotifyEvent);
begin Self.OnRestore := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnRestore_R(Self: TJvAppEvents; var T: TNotifyEvent);
begin T := Self.OnRestore; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnPaintIcon_W(Self: TJvAppEvents; const T: TNotifyEvent);
begin Self.OnPaintIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnPaintIcon_R(Self: TJvAppEvents; var T: TNotifyEvent);
begin T := Self.OnPaintIcon; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnMinimize_W(Self: TJvAppEvents; const T: TNotifyEvent);
begin Self.OnMinimize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnMinimize_R(Self: TJvAppEvents; var T: TNotifyEvent);
begin T := Self.OnMinimize; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnHint_W(Self: TJvAppEvents; const T: TNotifyEvent);
begin Self.OnHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnHint_R(Self: TJvAppEvents; var T: TNotifyEvent);
begin T := Self.OnHint; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnHelp_W(Self: TJvAppEvents; const T: THelpEvent);
begin Self.OnHelp := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnHelp_R(Self: TJvAppEvents; var T: THelpEvent);
begin T := Self.OnHelp; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnIdle_W(Self: TJvAppEvents; const T: TIdleEvent);
begin Self.OnIdle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnIdle_R(Self: TJvAppEvents; var T: TIdleEvent);
begin T := Self.OnIdle; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnException_W(Self: TJvAppEvents; const T: TExceptionEvent);
begin Self.OnException := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnException_R(Self: TJvAppEvents; var T: TExceptionEvent);
begin T := Self.OnException; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnDeactivate_W(Self: TJvAppEvents; const T: TNotifyEvent);
begin Self.OnDeactivate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnDeactivate_R(Self: TJvAppEvents; var T: TNotifyEvent);
begin T := Self.OnDeactivate; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnActivate_W(Self: TJvAppEvents; const T: TNotifyEvent);
begin Self.OnActivate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnActivate_R(Self: TJvAppEvents; var T: TNotifyEvent);
begin T := Self.OnActivate; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnShortCut_W(Self: TJvAppEvents; const T: TShortCutEvent);
begin Self.OnShortCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnShortCut_R(Self: TJvAppEvents; var T: TShortCutEvent);
begin T := Self.OnShortCut; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnActionUpdate_W(Self: TJvAppEvents; const T: TActionEvent);
begin Self.OnActionUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnActionUpdate_R(Self: TJvAppEvents; var T: TActionEvent);
begin T := Self.OnActionUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnActionExecute_W(Self: TJvAppEvents; const T: TActionEvent);
begin Self.OnActionExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsOnActionExecute_R(Self: TJvAppEvents; var T: TActionEvent);
begin T := Self.OnActionExecute; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsMouseDragThreshold_W(Self: TJvAppEvents; const T: Integer);
begin Self.MouseDragThreshold := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsMouseDragThreshold_R(Self: TJvAppEvents; var T: Integer);
begin T := Self.MouseDragThreshold; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsMouseDragImmediate_W(Self: TJvAppEvents; const T: Boolean);
begin Self.MouseDragImmediate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsMouseDragImmediate_R(Self: TJvAppEvents; var T: Boolean);
begin T := Self.MouseDragImmediate; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsNonBiDiKeyboard_W(Self: TJvAppEvents; const T: string);
begin Self.NonBiDiKeyboard := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsNonBiDiKeyboard_R(Self: TJvAppEvents; var T: string);
begin T := Self.NonBiDiKeyboard; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsBiDiKeyboard_W(Self: TJvAppEvents; const T: string);
begin Self.BiDiKeyboard := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsBiDiKeyboard_R(Self: TJvAppEvents; var T: string);
begin T := Self.BiDiKeyboard; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsBiDiMode_W(Self: TJvAppEvents; const T: TBiDiMode);
begin Self.BiDiMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsBiDiMode_R(Self: TJvAppEvents; var T: TBiDiMode);
begin T := Self.BiDiMode; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsUpdateMetricSettings_W(Self: TJvAppEvents; const T: Boolean);
begin Self.UpdateMetricSettings := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsUpdateMetricSettings_R(Self: TJvAppEvents; var T: Boolean);
begin T := Self.UpdateMetricSettings; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsHintShortCuts_W(Self: TJvAppEvents; const T: Boolean);
begin Self.HintShortCuts := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsHintShortCuts_R(Self: TJvAppEvents; var T: Boolean);
begin T := Self.HintShortCuts; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsShowMainForm_W(Self: TJvAppEvents; const T: Boolean);
begin Self.ShowMainForm := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsShowMainForm_R(Self: TJvAppEvents; var T: Boolean);
begin T := Self.ShowMainForm; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsHintHidePause_W(Self: TJvAppEvents; const T: Integer);
begin Self.HintHidePause := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsHintHidePause_R(Self: TJvAppEvents; var T: Integer);
begin T := Self.HintHidePause; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsHintShortPause_W(Self: TJvAppEvents; const T: Integer);
begin Self.HintShortPause := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsHintShortPause_R(Self: TJvAppEvents; var T: Integer);
begin T := Self.HintShortPause; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsUpdateFormatSettings_W(Self: TJvAppEvents; const T: Boolean);
begin Self.UpdateFormatSettings := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsUpdateFormatSettings_R(Self: TJvAppEvents; var T: Boolean);
begin T := Self.UpdateFormatSettings; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsShowHint_W(Self: TJvAppEvents; const T: Boolean);
begin Self.ShowHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsShowHint_R(Self: TJvAppEvents; var T: Boolean);
begin T := Self.ShowHint; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsHintPause_W(Self: TJvAppEvents; const T: Integer);
begin Self.HintPause := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsHintPause_R(Self: TJvAppEvents; var T: Integer);
begin T := Self.HintPause; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsHintColor_W(Self: TJvAppEvents; const T: TColor);
begin Self.HintColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsHintColor_R(Self: TJvAppEvents; var T: TColor);
begin T := Self.HintColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsChained_W(Self: TJvAppEvents; const T: Boolean);
begin Self.Chained := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppEventsChained_R(Self: TJvAppEvents; var T: Boolean);
begin T := Self.Chained; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAppEvents(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAppEvents) do begin
    RegisterConstructor(@TJvAppEvents.Create, 'Create');
    RegisterMethod(@TJvAppEvents.Destroy, 'Free');
    RegisterMethod(@TJvAppEvents.CancelDispatch, 'CancelDispatch');
    RegisterPropertyHelper(@TJvAppEventsChained_R,@TJvAppEventsChained_W,'Chained');
    RegisterPropertyHelper(@TJvAppEventsHintColor_R,@TJvAppEventsHintColor_W,'HintColor');
    RegisterPropertyHelper(@TJvAppEventsHintPause_R,@TJvAppEventsHintPause_W,'HintPause');
    RegisterPropertyHelper(@TJvAppEventsShowHint_R,@TJvAppEventsShowHint_W,'ShowHint');
    RegisterPropertyHelper(@TJvAppEventsUpdateFormatSettings_R,@TJvAppEventsUpdateFormatSettings_W,'UpdateFormatSettings');
    RegisterPropertyHelper(@TJvAppEventsHintShortPause_R,@TJvAppEventsHintShortPause_W,'HintShortPause');
    RegisterPropertyHelper(@TJvAppEventsHintHidePause_R,@TJvAppEventsHintHidePause_W,'HintHidePause');
    RegisterPropertyHelper(@TJvAppEventsShowMainForm_R,@TJvAppEventsShowMainForm_W,'ShowMainForm');
    RegisterPropertyHelper(@TJvAppEventsHintShortCuts_R,@TJvAppEventsHintShortCuts_W,'HintShortCuts');
    RegisterPropertyHelper(@TJvAppEventsUpdateMetricSettings_R,@TJvAppEventsUpdateMetricSettings_W,'UpdateMetricSettings');
    RegisterPropertyHelper(@TJvAppEventsBiDiMode_R,@TJvAppEventsBiDiMode_W,'BiDiMode');
    RegisterPropertyHelper(@TJvAppEventsBiDiKeyboard_R,@TJvAppEventsBiDiKeyboard_W,'BiDiKeyboard');
    RegisterPropertyHelper(@TJvAppEventsNonBiDiKeyboard_R,@TJvAppEventsNonBiDiKeyboard_W,'NonBiDiKeyboard');
    RegisterPropertyHelper(@TJvAppEventsMouseDragImmediate_R,@TJvAppEventsMouseDragImmediate_W,'MouseDragImmediate');
    RegisterPropertyHelper(@TJvAppEventsMouseDragThreshold_R,@TJvAppEventsMouseDragThreshold_W,'MouseDragThreshold');
    RegisterPropertyHelper(@TJvAppEventsOnActionExecute_R,@TJvAppEventsOnActionExecute_W,'OnActionExecute');
    RegisterPropertyHelper(@TJvAppEventsOnActionUpdate_R,@TJvAppEventsOnActionUpdate_W,'OnActionUpdate');
    RegisterPropertyHelper(@TJvAppEventsOnShortCut_R,@TJvAppEventsOnShortCut_W,'OnShortCut');
    RegisterPropertyHelper(@TJvAppEventsOnActivate_R,@TJvAppEventsOnActivate_W,'OnActivate');
    RegisterPropertyHelper(@TJvAppEventsOnDeactivate_R,@TJvAppEventsOnDeactivate_W,'OnDeactivate');
    RegisterPropertyHelper(@TJvAppEventsOnException_R,@TJvAppEventsOnException_W,'OnException');
    RegisterPropertyHelper(@TJvAppEventsOnIdle_R,@TJvAppEventsOnIdle_W,'OnIdle');
    RegisterPropertyHelper(@TJvAppEventsOnHelp_R,@TJvAppEventsOnHelp_W,'OnHelp');
    RegisterPropertyHelper(@TJvAppEventsOnHint_R,@TJvAppEventsOnHint_W,'OnHint');
    RegisterPropertyHelper(@TJvAppEventsOnMinimize_R,@TJvAppEventsOnMinimize_W,'OnMinimize');
    RegisterPropertyHelper(@TJvAppEventsOnPaintIcon_R,@TJvAppEventsOnPaintIcon_W,'OnPaintIcon');
    RegisterPropertyHelper(@TJvAppEventsOnRestore_R,@TJvAppEventsOnRestore_W,'OnRestore');
    RegisterPropertyHelper(@TJvAppEventsOnShowHint_R,@TJvAppEventsOnShowHint_W,'OnShowHint');
    RegisterPropertyHelper(@TJvAppEventsOnModalBegin_R,@TJvAppEventsOnModalBegin_W,'OnModalBegin');
    RegisterPropertyHelper(@TJvAppEventsOnModalEnd_R,@TJvAppEventsOnModalEnd_W,'OnModalEnd');
    RegisterPropertyHelper(@TJvAppEventsOnMessage_R,@TJvAppEventsOnMessage_W,'OnMessage');
    RegisterPropertyHelper(@TJvAppEventsOnSettingsChanged_R,@TJvAppEventsOnSettingsChanged_W,'OnSettingsChanged');
    RegisterPropertyHelper(@TJvAppEventsOnActiveControlChange_R,@TJvAppEventsOnActiveControlChange_W,'OnActiveControlChange');
    RegisterPropertyHelper(@TJvAppEventsOnActiveFormChange_R,@TJvAppEventsOnActiveFormChange_W,'OnActiveFormChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvAppEvent(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvAppEvents(CL);
end;

 
 
{ TPSImport_JvAppEvent }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAppEvent.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvAppEvent(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAppEvent.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvAppEvent(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
