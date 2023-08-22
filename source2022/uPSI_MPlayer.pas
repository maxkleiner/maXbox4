unit uPSI_MPlayer;
{
   maxplay
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
  TPSImport_MPlayer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMediaPlayer(CL: TPSPascalCompiler);
procedure SIRegister_MPlayer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMediaPlayer(CL: TPSRuntimeClassImporter);
procedure RIRegister_MPlayer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  //,Forms
  //,Graphics
  //,Messages
  ,MMSystem
  //,Dialogs
  ,MPlayer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MPlayer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMediaPlayer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TMediaPlayer') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TMediaPlayer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure Play');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure Pause');
    RegisterMethod('Procedure Step');
    RegisterMethod('Procedure Back');
    RegisterMethod('Procedure Previous');
    RegisterMethod('Procedure Next');
    RegisterMethod('Procedure StartRecording');
    RegisterMethod('Procedure Eject');
    RegisterMethod('Procedure Save');
    RegisterMethod('Procedure PauseOnly');
    RegisterMethod('Procedure Resume');
    RegisterMethod('Procedure Rewind');
    RegisterProperty('TrackLength', 'Longint Integer', iptr);
    RegisterProperty('TrackPosition', 'Longint Integer', iptr);
    RegisterProperty('Capabilities', 'TMPDevCapsSet', iptr);
    RegisterProperty('Error', 'Longint', iptr);
    RegisterProperty('ErrorMessage', 'string', iptr);
    RegisterProperty('Start', 'Longint', iptr);
    RegisterProperty('Length', 'Longint', iptr);
    RegisterProperty('Tracks', 'Longint', iptr);
    RegisterProperty('Frames', 'Longint', iptrw);
    RegisterProperty('Mode', 'TMPModes', iptr);
    RegisterProperty('Position', 'Longint', iptrw);
    RegisterProperty('Wait', 'Boolean', iptrw);
    RegisterProperty('Notify', 'Boolean', iptrw);
    RegisterProperty('NotifyValue', 'TMPNotifyValues', iptr);
    RegisterProperty('StartPos', 'Longint', iptrw);
    RegisterProperty('EndPos', 'Longint', iptrw);
    RegisterProperty('DeviceID', 'Word', iptr);
    RegisterProperty('TimeFormat', 'TMPTimeFormats', iptrw);
    RegisterProperty('DisplayRect', 'TRect', iptrw);
    RegisterProperty('ColoredButtons', 'TButtonSet', iptrw);
    RegisterProperty('EnabledButtons', 'TButtonSet', iptrw);
    RegisterProperty('VisibleButtons', 'TButtonSet', iptrw);
    RegisterProperty('AutoEnable', 'Boolean', iptrw);
    RegisterProperty('AutoOpen', 'Boolean', iptrw);
    RegisterProperty('AutoRewind', 'Boolean', iptrw);
    RegisterProperty('DeviceType', 'TMPDeviceTypes', iptrw);
    RegisterProperty('Display', 'TWinControl', iptrw);     //paintto!
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('Shareable', 'Boolean', iptrw);
    RegisterProperty('OnClick', 'EMPNotify', iptrw);
    RegisterProperty('OnPostClick', 'EMPPostNotify', iptrw);
    RegisterProperty('OnNotify', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MPlayer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMPBtnType', '( btPlay, btPause, btStop, btNext, btPrev, btStep,'
   +' btBack, btRecord, btEject )');
  CL.AddTypeS('TButtonSet', 'set of TMPBtnType');
  CL.AddTypeS('TMPGlyph', '( mgEnabled, mgDisabled, mgColored )');
  CL.AddTypeS('TMPDeviceTypes', '( dtAutoSelect, dtAVIVideo, dtCDAudio, dtDAT, '
   +'dtDigitalVideo, dtMMMovie, dtOther, dtOverlay, dtScanner, dtSequencer, dtV'
   +'CR, dtVideodisc, dtWaveAudio )');
  CL.AddTypeS('TMPTimeFormats', '( tfMilliseconds, tfHMS, tfMSF, tfFrames, tfSM'
   +'PTE24, tfSMPTE25, tfSMPTE30, tfSMPTE30Drop, tfBytes, tfSamples, tfTMSF )');
  CL.AddTypeS('TMPModes', '( mpNotReady, mpStopped, mpPlaying, mpRecording, mpS'
   +'eeking, mpPaused, mpOpen )');
  CL.AddTypeS('TMPNotifyValues', '( nvSuccessful, nvSuperseded, nvAborted, nvFa'
   +'ilure )');
  CL.AddTypeS('TMPDevCaps', '( mpCanStep, mpCanEject, mpCanPlay, mpCanRecord, m'
   +'pUsesWindow )');
  CL.AddTypeS('TMPDevCapsSet', 'set of TMPDevCaps');
  CL.AddTypeS('EMPNotify', 'Procedure ( Sender : TObject; Button : TMPBtnType; '
   +'var DoDefault : Boolean)');
  CL.AddTypeS('EMPPostNotify', 'Procedure ( Sender : TObject; Button : TMPBtnTy'
   +'pe)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMCIDeviceError');
  SIRegister_TMediaPlayer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMediaPlayerOnNotify_W(Self: TMediaPlayer; const T: TNotifyEvent);
begin Self.OnNotify := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerOnNotify_R(Self: TMediaPlayer; var T: TNotifyEvent);
begin T := Self.OnNotify; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerOnPostClick_W(Self: TMediaPlayer; const T: EMPPostNotify);
begin Self.OnPostClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerOnPostClick_R(Self: TMediaPlayer; var T: EMPPostNotify);
begin T := Self.OnPostClick; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerOnClick_W(Self: TMediaPlayer; const T: EMPNotify);
begin Self.OnClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerOnClick_R(Self: TMediaPlayer; var T: EMPNotify);
begin T := Self.OnClick; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerShareable_W(Self: TMediaPlayer; const T: Boolean);
begin Self.Shareable := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerShareable_R(Self: TMediaPlayer; var T: Boolean);
begin T := Self.Shareable; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerFileName_W(Self: TMediaPlayer; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerFileName_R(Self: TMediaPlayer; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerDisplay_W(Self: TMediaPlayer; const T: TWinControl);
begin Self.Display := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerDisplay_R(Self: TMediaPlayer; var T: TWinControl);
begin T := Self.Display; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerDeviceType_W(Self: TMediaPlayer; const T: TMPDeviceTypes);
begin Self.DeviceType := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerDeviceType_R(Self: TMediaPlayer; var T: TMPDeviceTypes);
begin T := Self.DeviceType; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerAutoRewind_W(Self: TMediaPlayer; const T: Boolean);
begin Self.AutoRewind := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerAutoRewind_R(Self: TMediaPlayer; var T: Boolean);
begin T := Self.AutoRewind; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerAutoOpen_W(Self: TMediaPlayer; const T: Boolean);
begin Self.AutoOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerAutoOpen_R(Self: TMediaPlayer; var T: Boolean);
begin T := Self.AutoOpen; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerAutoEnable_W(Self: TMediaPlayer; const T: Boolean);
begin Self.AutoEnable := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerAutoEnable_R(Self: TMediaPlayer; var T: Boolean);
begin T := Self.AutoEnable; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerVisibleButtons_W(Self: TMediaPlayer; const T: TButtonSet);
begin Self.VisibleButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerVisibleButtons_R(Self: TMediaPlayer; var T: TButtonSet);
begin T := Self.VisibleButtons; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerEnabledButtons_W(Self: TMediaPlayer; const T: TButtonSet);
begin Self.EnabledButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerEnabledButtons_R(Self: TMediaPlayer; var T: TButtonSet);
begin T := Self.EnabledButtons; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerColoredButtons_W(Self: TMediaPlayer; const T: TButtonSet);
begin Self.ColoredButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerColoredButtons_R(Self: TMediaPlayer; var T: TButtonSet);
begin T := Self.ColoredButtons; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerDisplayRect_W(Self: TMediaPlayer; const T: TRect);
begin Self.DisplayRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerDisplayRect_R(Self: TMediaPlayer; var T: TRect);
begin T := Self.DisplayRect; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerTimeFormat_W(Self: TMediaPlayer; const T: TMPTimeFormats);
begin Self.TimeFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerTimeFormat_R(Self: TMediaPlayer; var T: TMPTimeFormats);
begin T := Self.TimeFormat; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerDeviceID_R(Self: TMediaPlayer; var T: Word);
begin T := Self.DeviceID; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerEndPos_W(Self: TMediaPlayer; const T: Longint);
begin Self.EndPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerEndPos_R(Self: TMediaPlayer; var T: Longint);
begin T := Self.EndPos; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerStartPos_W(Self: TMediaPlayer; const T: Longint);
begin Self.StartPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerStartPos_R(Self: TMediaPlayer; var T: Longint);
begin T := Self.StartPos; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerNotifyValue_R(Self: TMediaPlayer; var T: TMPNotifyValues);
begin T := Self.NotifyValue; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerNotify_W(Self: TMediaPlayer; const T: Boolean);
begin Self.Notify := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerNotify_R(Self: TMediaPlayer; var T: Boolean);
begin T := Self.Notify; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerWait_W(Self: TMediaPlayer; const T: Boolean);
begin Self.Wait := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerWait_R(Self: TMediaPlayer; var T: Boolean);
begin T := Self.Wait; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerPosition_W(Self: TMediaPlayer; const T: Longint);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerPosition_R(Self: TMediaPlayer; var T: Longint);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerMode_R(Self: TMediaPlayer; var T: TMPModes);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerFrames_W(Self: TMediaPlayer; const T: Longint);
begin Self.Frames := T; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerFrames_R(Self: TMediaPlayer; var T: Longint);
begin T := Self.Frames; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerTracks_R(Self: TMediaPlayer; var T: Longint);
begin T := Self.Tracks; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerLength_R(Self: TMediaPlayer; var T: Longint);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerStart_R(Self: TMediaPlayer; var T: Longint);
begin T := Self.Start; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerErrorMessage_R(Self: TMediaPlayer; var T: string);
begin T := Self.ErrorMessage; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerError_R(Self: TMediaPlayer; var T: Longint);
begin T := Self.Error; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerCapabilities_R(Self: TMediaPlayer; var T: TMPDevCapsSet);
begin T := Self.Capabilities; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerTrackPosition_R(Self: TMediaPlayer; var T: Longint; const t1: Integer);
begin T := Self.TrackPosition[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMediaPlayerTrackLength_R(Self: TMediaPlayer; var T: Longint; const t1: Integer);
begin T := Self.TrackLength[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMediaPlayer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMediaPlayer) do
  begin
    RegisterConstructor(@TMediaPlayer.Create, 'Create');
    RegisterMethod(@TMediaPlayer.Open, 'Open');
    RegisterMethod(@TMediaPlayer.Close, 'Close');
    RegisterMethod(@TMediaPlayer.Play, 'Play');
    RegisterMethod(@TMediaPlayer.Stop, 'Stop');
    RegisterMethod(@TMediaPlayer.Pause, 'Pause');
    RegisterMethod(@TMediaPlayer.Step, 'Step');
    RegisterMethod(@TMediaPlayer.Back, 'Back');
    RegisterMethod(@TMediaPlayer.Previous, 'Previous');
    RegisterMethod(@TMediaPlayer.Next, 'Next');
    RegisterMethod(@TMediaPlayer.StartRecording, 'StartRecording');
    RegisterMethod(@TMediaPlayer.Eject, 'Eject');
    RegisterMethod(@TMediaPlayer.Save, 'Save');
    RegisterMethod(@TMediaPlayer.PauseOnly, 'PauseOnly');
    RegisterMethod(@TMediaPlayer.Resume, 'Resume');
    RegisterMethod(@TMediaPlayer.Rewind, 'Rewind');
    RegisterPropertyHelper(@TMediaPlayerTrackLength_R,nil,'TrackLength');
    RegisterPropertyHelper(@TMediaPlayerTrackPosition_R,nil,'TrackPosition');
    RegisterPropertyHelper(@TMediaPlayerCapabilities_R,nil,'Capabilities');
    RegisterPropertyHelper(@TMediaPlayerError_R,nil,'Error');
    RegisterPropertyHelper(@TMediaPlayerErrorMessage_R,nil,'ErrorMessage');
    RegisterPropertyHelper(@TMediaPlayerStart_R,nil,'Start');
    RegisterPropertyHelper(@TMediaPlayerLength_R,nil,'Length');
    RegisterPropertyHelper(@TMediaPlayerTracks_R,nil,'Tracks');
    RegisterPropertyHelper(@TMediaPlayerFrames_R,@TMediaPlayerFrames_W,'Frames');
    RegisterPropertyHelper(@TMediaPlayerMode_R,nil,'Mode');
    RegisterPropertyHelper(@TMediaPlayerPosition_R,@TMediaPlayerPosition_W,'Position');
    RegisterPropertyHelper(@TMediaPlayerWait_R,@TMediaPlayerWait_W,'Wait');
    RegisterPropertyHelper(@TMediaPlayerNotify_R,@TMediaPlayerNotify_W,'Notify');
    RegisterPropertyHelper(@TMediaPlayerNotifyValue_R,nil,'NotifyValue');
    RegisterPropertyHelper(@TMediaPlayerStartPos_R,@TMediaPlayerStartPos_W,'StartPos');
    RegisterPropertyHelper(@TMediaPlayerEndPos_R,@TMediaPlayerEndPos_W,'EndPos');
    RegisterPropertyHelper(@TMediaPlayerDeviceID_R,nil,'DeviceID');
    RegisterPropertyHelper(@TMediaPlayerTimeFormat_R,@TMediaPlayerTimeFormat_W,'TimeFormat');
    RegisterPropertyHelper(@TMediaPlayerDisplayRect_R,@TMediaPlayerDisplayRect_W,'DisplayRect');
    RegisterPropertyHelper(@TMediaPlayerColoredButtons_R,@TMediaPlayerColoredButtons_W,'ColoredButtons');
    RegisterPropertyHelper(@TMediaPlayerEnabledButtons_R,@TMediaPlayerEnabledButtons_W,'EnabledButtons');
    RegisterPropertyHelper(@TMediaPlayerVisibleButtons_R,@TMediaPlayerVisibleButtons_W,'VisibleButtons');
    RegisterPropertyHelper(@TMediaPlayerAutoEnable_R,@TMediaPlayerAutoEnable_W,'AutoEnable');
    RegisterPropertyHelper(@TMediaPlayerAutoOpen_R,@TMediaPlayerAutoOpen_W,'AutoOpen');
    RegisterPropertyHelper(@TMediaPlayerAutoRewind_R,@TMediaPlayerAutoRewind_W,'AutoRewind');
    RegisterPropertyHelper(@TMediaPlayerDeviceType_R,@TMediaPlayerDeviceType_W,'DeviceType');
    RegisterPropertyHelper(@TMediaPlayerDisplay_R,@TMediaPlayerDisplay_W,'Display');
    RegisterPropertyHelper(@TMediaPlayerFileName_R,@TMediaPlayerFileName_W,'FileName');
    RegisterPropertyHelper(@TMediaPlayerShareable_R,@TMediaPlayerShareable_W,'Shareable');
    RegisterPropertyHelper(@TMediaPlayerOnClick_R,@TMediaPlayerOnClick_W,'OnClick');
    RegisterPropertyHelper(@TMediaPlayerOnPostClick_R,@TMediaPlayerOnPostClick_W,'OnPostClick');
    RegisterPropertyHelper(@TMediaPlayerOnNotify_R,@TMediaPlayerOnNotify_W,'OnNotify');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MPlayer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EMCIDeviceError) do
  RIRegister_TMediaPlayer(CL);
end;

 
 
{ TPSImport_MPlayer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MPlayer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MPlayer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MPlayer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MPlayer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
