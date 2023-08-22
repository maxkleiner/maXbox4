unit uPSI_JvWinampApi;
{
  an API for more internet radio stream machine 
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
  TPSImport_JvWinampApi = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvWinampApi(CL: TPSPascalCompiler);
procedure SIRegister_JvWinampApi(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvWinampApi(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvWinampApi(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Controls
  ,Winamp
  ,JvTypes
  ,JvComponent
  ,JvWinampApi
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvWinampApi]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvWinampApi(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvWinampApi') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvWinampApi') do begin
    RegisterMethod('Procedure ClearPlaylist');
    RegisterMethod('Procedure SavePlaylist');
    RegisterMethod('Procedure Play');
    RegisterMethod('Procedure SetVolume( Value : Byte)');
    RegisterMethod('Procedure SetPanning( Value : Byte)');
    RegisterMethod('Procedure ShowOptions');
    RegisterMethod('Procedure ShowAbout');
    RegisterMethod('Procedure OpenFiles');
    RegisterMethod('Procedure ToggleAlwaysOnTop');
    RegisterMethod('Procedure ToggleEqualizer');
    RegisterMethod('Procedure TogglePlaylist');
    RegisterMethod('Procedure OpenFile( FileName : string)');
    RegisterMethod('Procedure SetDirectory( Directory : string)');
    RegisterMethod('Procedure VolumeInc');
    RegisterMethod('Procedure VolumeDec');
    RegisterMethod('Procedure FastForward');
    RegisterMethod('Procedure FastRewind');
    RegisterMethod('Procedure OpenLocation');
    RegisterMethod('Procedure PreviousTrack');
    RegisterMethod('Procedure NextTrack');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure Pause');
    RegisterMethod('Procedure StartOfList');
    RegisterMethod('Procedure EndOfList');
    RegisterMethod('Procedure StopWithFadeout');
    RegisterProperty('WinampHandle', 'THandle', iptr);
    RegisterProperty('Equalizer', 'TWinampEqualizer', iptrw);
    RegisterProperty('WinampPresent', 'Boolean', iptrw);
    RegisterProperty('WinampMajorVersion', 'Integer', iptrw);
    RegisterProperty('WinampMinorVersion', 'Integer', iptrw);
    RegisterProperty('WinampStatus', 'TWStatus', iptrw);
    RegisterProperty('SongPosition', 'TTime', iptrw);
    RegisterProperty('SongLength', 'TTime', iptrw);
    RegisterProperty('PlaylistPos', 'Integer', iptrw);
    RegisterProperty('SampleRate', 'Integer', iptrw);
    RegisterProperty('BitRate', 'Integer', iptrw);
    RegisterProperty('Channels', 'Integer', iptrw);
    RegisterProperty('ListLength', 'Integer', iptrw);
    RegisterProperty('PlayOptions', 'TJvPlayOptions', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvWinampApi(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TWStatus', '( wsNotAvailable, wsStopped, wsPlaying, wsPaused )');
  CL.AddTypeS('TJvPlayOption', '( poRepeat, poShuffle )');
  CL.AddTypeS('TJvPlayOptions', 'set of TJvPlayOption');
  SIRegister_TJvWinampApi(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EWinampError');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvWinampApiPlayOptions_W(Self: TJvWinampApi; const T: TJvPlayOptions);
begin Self.PlayOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiPlayOptions_R(Self: TJvWinampApi; var T: TJvPlayOptions);
begin T := Self.PlayOptions; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiListLength_W(Self: TJvWinampApi; const T: Integer);
begin Self.ListLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiListLength_R(Self: TJvWinampApi; var T: Integer);
begin T := Self.ListLength; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiChannels_W(Self: TJvWinampApi; const T: Integer);
begin Self.Channels := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiChannels_R(Self: TJvWinampApi; var T: Integer);
begin T := Self.Channels; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiBitRate_W(Self: TJvWinampApi; const T: Integer);
begin Self.BitRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiBitRate_R(Self: TJvWinampApi; var T: Integer);
begin T := Self.BitRate; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiSampleRate_W(Self: TJvWinampApi; const T: Integer);
begin Self.SampleRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiSampleRate_R(Self: TJvWinampApi; var T: Integer);
begin T := Self.SampleRate; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiPlaylistPos_W(Self: TJvWinampApi; const T: Integer);
begin Self.PlaylistPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiPlaylistPos_R(Self: TJvWinampApi; var T: Integer);
begin T := Self.PlaylistPos; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiSongLength_W(Self: TJvWinampApi; const T: TTime);
begin Self.SongLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiSongLength_R(Self: TJvWinampApi; var T: TTime);
begin T := Self.SongLength; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiSongPosition_W(Self: TJvWinampApi; const T: TTime);
begin Self.SongPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiSongPosition_R(Self: TJvWinampApi; var T: TTime);
begin T := Self.SongPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiWinampStatus_W(Self: TJvWinampApi; const T: TWStatus);
begin Self.WinampStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiWinampStatus_R(Self: TJvWinampApi; var T: TWStatus);
begin T := Self.WinampStatus; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiWinampMinorVersion_W(Self: TJvWinampApi; const T: Integer);
begin Self.WinampMinorVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiWinampMinorVersion_R(Self: TJvWinampApi; var T: Integer);
begin T := Self.WinampMinorVersion; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiWinampMajorVersion_W(Self: TJvWinampApi; const T: Integer);
begin Self.WinampMajorVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiWinampMajorVersion_R(Self: TJvWinampApi; var T: Integer);
begin T := Self.WinampMajorVersion; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiWinampPresent_W(Self: TJvWinampApi; const T: Boolean);
begin Self.WinampPresent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiWinampPresent_R(Self: TJvWinampApi; var T: Boolean);
begin T := Self.WinampPresent; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiEqualizer_W(Self: TJvWinampApi; const T: TWinampEqualizer);
begin Self.Equalizer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiEqualizer_R(Self: TJvWinampApi; var T: TWinampEqualizer);
begin T := Self.Equalizer; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinampApiWinampHandle_R(Self: TJvWinampApi; var T: THandle);
begin T := Self.WinampHandle; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvWinampApi(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvWinampApi) do
  begin
    RegisterMethod(@TJvWinampApi.ClearPlaylist, 'ClearPlaylist');
    RegisterMethod(@TJvWinampApi.SavePlaylist, 'SavePlaylist');
    RegisterMethod(@TJvWinampApi.Play, 'Play');
    RegisterMethod(@TJvWinampApi.SetVolume, 'SetVolume');
    RegisterMethod(@TJvWinampApi.SetPanning, 'SetPanning');
    RegisterMethod(@TJvWinampApi.ShowOptions, 'ShowOptions');
    RegisterMethod(@TJvWinampApi.ShowAbout, 'ShowAbout');
    RegisterMethod(@TJvWinampApi.OpenFiles, 'OpenFiles');
    RegisterMethod(@TJvWinampApi.ToggleAlwaysOnTop, 'ToggleAlwaysOnTop');
    RegisterMethod(@TJvWinampApi.ToggleEqualizer, 'ToggleEqualizer');
    RegisterMethod(@TJvWinampApi.TogglePlaylist, 'TogglePlaylist');
    RegisterMethod(@TJvWinampApi.OpenFile, 'OpenFile');
    RegisterMethod(@TJvWinampApi.SetDirectory, 'SetDirectory');
    RegisterMethod(@TJvWinampApi.VolumeInc, 'VolumeInc');
    RegisterMethod(@TJvWinampApi.VolumeDec, 'VolumeDec');
    RegisterMethod(@TJvWinampApi.FastForward, 'FastForward');
    RegisterMethod(@TJvWinampApi.FastRewind, 'FastRewind');
    RegisterMethod(@TJvWinampApi.OpenLocation, 'OpenLocation');
    RegisterMethod(@TJvWinampApi.PreviousTrack, 'PreviousTrack');
    RegisterMethod(@TJvWinampApi.NextTrack, 'NextTrack');
    RegisterMethod(@TJvWinampApi.Stop, 'Stop');
    RegisterMethod(@TJvWinampApi.Pause, 'Pause');
    RegisterMethod(@TJvWinampApi.StartOfList, 'StartOfList');
    RegisterMethod(@TJvWinampApi.EndOfList, 'EndOfList');
    RegisterMethod(@TJvWinampApi.StopWithFadeout, 'StopWithFadeout');
    RegisterPropertyHelper(@TJvWinampApiWinampHandle_R,nil,'WinampHandle');
    RegisterPropertyHelper(@TJvWinampApiEqualizer_R,@TJvWinampApiEqualizer_W,'Equalizer');
    RegisterPropertyHelper(@TJvWinampApiWinampPresent_R,@TJvWinampApiWinampPresent_W,'WinampPresent');
    RegisterPropertyHelper(@TJvWinampApiWinampMajorVersion_R,@TJvWinampApiWinampMajorVersion_W,'WinampMajorVersion');
    RegisterPropertyHelper(@TJvWinampApiWinampMinorVersion_R,@TJvWinampApiWinampMinorVersion_W,'WinampMinorVersion');
    RegisterPropertyHelper(@TJvWinampApiWinampStatus_R,@TJvWinampApiWinampStatus_W,'WinampStatus');
    RegisterPropertyHelper(@TJvWinampApiSongPosition_R,@TJvWinampApiSongPosition_W,'SongPosition');
    RegisterPropertyHelper(@TJvWinampApiSongLength_R,@TJvWinampApiSongLength_W,'SongLength');
    RegisterPropertyHelper(@TJvWinampApiPlaylistPos_R,@TJvWinampApiPlaylistPos_W,'PlaylistPos');
    RegisterPropertyHelper(@TJvWinampApiSampleRate_R,@TJvWinampApiSampleRate_W,'SampleRate');
    RegisterPropertyHelper(@TJvWinampApiBitRate_R,@TJvWinampApiBitRate_W,'BitRate');
    RegisterPropertyHelper(@TJvWinampApiChannels_R,@TJvWinampApiChannels_W,'Channels');
    RegisterPropertyHelper(@TJvWinampApiListLength_R,@TJvWinampApiListLength_W,'ListLength');
    RegisterPropertyHelper(@TJvWinampApiPlayOptions_R,@TJvWinampApiPlayOptions_W,'PlayOptions');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvWinampApi(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvWinampApi(CL);
  with CL.Add(EWinampError) do
end;

 
 
{ TPSImport_JvWinampApi }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvWinampApi.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvWinampApi(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvWinampApi.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvWinampApi(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
