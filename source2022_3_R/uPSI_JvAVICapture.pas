unit uPSI_JvAVICapture;
{
   to set avi video
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
  TPSImport_JvAVICapture = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvAVICapture(CL: TPSPascalCompiler);
procedure SIRegister_EInvalidDriverIndexError(CL: TPSPascalCompiler);
procedure SIRegister_TJvPalette(CL: TPSPascalCompiler);
procedure SIRegister_TJvCaptureSettings(CL: TPSPascalCompiler);
procedure SIRegister_TJvAudioFormat(CL: TPSPascalCompiler);
procedure SIRegister_TJvVideoFormat(CL: TPSPascalCompiler);
procedure SIRegister_TJvScrollPos(CL: TPSPascalCompiler);
procedure SIRegister_JvAVICapture(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvAVICapture(CL: TPSRuntimeClassImporter);
procedure RIRegister_EInvalidDriverIndexError(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvPalette(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCaptureSettings(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvAudioFormat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvVideoFormat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvScrollPos(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvAVICapture(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,Messages
  ,VFW
  ,MMSystem
  ,Graphics
  ,Controls
  ,JvTypes
  ,JvAVICapture
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvAVICapture]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAVICapture(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TJvAVICapture') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TJvAVICapture') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SetBounds( nLeft, nTop, nWidth, nHeight : Integer)');
    RegisterMethod('Procedure EnumDrivers');
    RegisterMethod('Function Connect( Driver : TJvDriverIndex) : Boolean');
    RegisterMethod('Procedure Free');
      RegisterMethod('Function Disconnect : Boolean');
    RegisterMethod('Function ShowDialog( Dialog : TJvVideoDialog) : Boolean');
    RegisterMethod('Function StartPreview : Boolean');
    RegisterMethod('Function StopPreview : Boolean');
    RegisterMethod('Function StartCapture : Boolean');
    RegisterMethod('Function StartCaptureNoFile : Boolean');
    RegisterMethod('Function StopCapture : Boolean');
    RegisterMethod('Function AbortCapture : Boolean');
    RegisterMethod('Function StartSingleFrameCapture : Boolean');
    RegisterMethod('Function CaptureFrame : Boolean');
    RegisterMethod('Function StopSingleFrameCapture : Boolean');
    RegisterMethod('Function StartOverlay : Boolean');
    RegisterMethod('Function StopOverlay : Boolean');
    RegisterMethod('Function ApplyCaptureSettings : Boolean');
    RegisterMethod('Function ApplyAudioFormat : Boolean');
    RegisterMethod('Function SaveAs( Name : string) : Boolean');
    RegisterMethod('Function SetInfoChunk( const Chunk : TCAPINFOCHUNK) : Boolean');
    RegisterMethod('Function SaveDIB( Name : string) : Boolean');
    RegisterMethod('Function CopyToClipboard : Boolean');
    RegisterMethod('Function GrabFrame( Stop : Boolean) : Boolean');
    RegisterProperty('CaptureStatus', 'TCAPSTATUS', iptr);
    RegisterProperty('Capturing', 'Boolean', iptrw);
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterProperty('DriverCaps', 'TJvDriverCaps', iptr);
    RegisterProperty('DriverName', 'string', iptr);
    RegisterProperty('DriverVersion', 'string', iptr);
    RegisterProperty('Drivers', 'TStrings', iptr);
    RegisterProperty('Handle', 'HWND', iptr);
    RegisterProperty('Palette', 'TJvPalette', iptr);
    RegisterProperty('SingleFrameCapturing', 'Boolean', iptrw);
    RegisterProperty('VideoFormat', 'TJvVideoFormat', iptr);
    RegisterProperty('AudioFormat', 'TJvAudioFormat', iptr);
    RegisterProperty('CaptureSettings', 'TJvCaptureSettings', iptr);
    RegisterProperty('DriverIndex', 'TJvDriverIndex', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('FileSizeAlloc', 'Cardinal', iptrw);
    RegisterProperty('MCIDevice', 'string', iptrw);
    RegisterProperty('NoFile', 'Boolean', iptrw);
    RegisterProperty('Overlaying', 'Boolean', iptrw);
    RegisterProperty('PreviewFrameDelay', 'Cardinal', iptrw);
    RegisterProperty('PreviewFPS', 'Double', iptrw);
    RegisterProperty('Previewing', 'Boolean', iptrw);
    RegisterProperty('ScrollPos', 'TJvScrollPos', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('UsedEvents', 'TJvUsedEvents', iptrw);
    RegisterProperty('VideoLeft', 'Integer', iptrw);
    RegisterProperty('VideoTop', 'Integer', iptrw);
    RegisterProperty('OnError', 'TOnError', iptrw);
    RegisterProperty('OnStatus', 'TOnStatus', iptrw);
    RegisterProperty('OnYield', 'TOnYield', iptrw);
    RegisterProperty('OnFrame', 'TOnFrame', iptrw);
    RegisterProperty('OnVideoStream', 'TOnVideoStream', iptrw);
    RegisterProperty('OnWaveStream', 'TOnWaveStream', iptrw);
    RegisterProperty('OnCapControl', 'TOnCapControl', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EInvalidDriverIndexError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EJVCLException', 'EInvalidDriverIndexError') do
  with CL.AddClassN(CL.FindClass('EJVCLException'),'EInvalidDriverIndexError') do
  begin
    RegisterMethod('Constructor Create( Index : TJvDriverIndex; MaxIndex : TJvDriverIndex)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvPalette(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvPalette') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvPalette') do begin
    RegisterMethod('Constructor Create');
     // RegisterMethod('Procedure Free');
      RegisterMethod('Function Save( FileName : string) : Boolean');
    RegisterMethod('Function Load( FileName : string) : Boolean');
    RegisterMethod('Function PasteFromClipboard : Boolean');
    RegisterMethod('Function AutoCreate( nbFrames : Integer; nbColors : TJvPaletteNbColors) : Boolean');
    RegisterMethod('Function ManuallyCreate( Flag : Boolean; nbColors : TJvPaletteNbColors) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCaptureSettings(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvCaptureSettings') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvCaptureSettings') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Update');
    RegisterMethod('Function Apply : Boolean');
    RegisterProperty('ConfirmCapture', 'Boolean', iptrw);
    RegisterProperty('FrameDelay', 'Cardinal', iptrw);
    RegisterProperty('FPS', 'Double', iptrw);
    RegisterProperty('PercentDropForError', 'TJvPercent', iptrw);
    RegisterProperty('Yield', 'Boolean', iptrw);
    RegisterProperty('NumVideoBuffer', 'Cardinal', iptrw);
    RegisterProperty('NumAudioBuffer', 'TJvNumAudioBuffer', iptrw);
    RegisterProperty('CaptureAudio', 'Boolean', iptrw);
    RegisterProperty('AbortLeftMouse', 'Boolean', iptrw);
    RegisterProperty('AbortRightMouse', 'Boolean', iptrw);
    RegisterProperty('KeyAbort', 'TJvVirtualKey', iptrw);
    RegisterProperty('LimitEnabled', 'Boolean', iptrw);
    RegisterProperty('TimeLimit', 'Cardinal', iptrw);
    RegisterProperty('StepCapture2x', 'Boolean', iptrw);
    RegisterProperty('StepCaptureAverageFrames', 'Cardinal', iptrw);
    RegisterProperty('AudioBufferSize', 'Cardinal', iptrw);
    RegisterProperty('AudioMaster', 'Boolean', iptrw);
    RegisterProperty('MCIControl', 'Boolean', iptrw);
    RegisterProperty('MCIStep', 'Boolean', iptrw);
    RegisterProperty('MCIStartTime', 'Cardinal', iptrw);
    RegisterProperty('MCIStopTime', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAudioFormat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvAudioFormat') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvAudioFormat') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Update');
    RegisterMethod('Function Apply : Boolean');
    RegisterMethod('Procedure FillWaveFormatEx( var wfex : PWaveFormatEx)');
    RegisterProperty('ExtraSize', 'Cardinal', iptrw);
    RegisterProperty('Extra', 'Pointer', iptrw);
    RegisterProperty('FormatTag', 'Cardinal', iptrw);
    RegisterProperty('Channels', 'Cardinal', iptrw);
    RegisterProperty('SamplesPerSec', 'Cardinal', iptrw);
    RegisterProperty('AvgBytesPerSec', 'Cardinal', iptrw);
    RegisterProperty('BlockAlign', 'Cardinal', iptrw);
    RegisterProperty('BitsPerSample', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvVideoFormat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvVideoFormat') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvVideoFormat') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Update');
    RegisterProperty('Width', 'Cardinal', iptr);
    RegisterProperty('Height', 'Cardinal', iptr);
    RegisterProperty('BitDepth', 'Cardinal', iptr);
    RegisterProperty('PixelFormat', 'TPixelFormat', iptr);
    RegisterProperty('Compression', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvScrollPos(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvScrollPos') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvScrollPos') do
  begin
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvAVICapture(CL: TPSPascalCompiler);
begin
  SIRegister_TJvScrollPos(CL);
  SIRegister_TJvVideoFormat(CL);
  SIRegister_TJvAudioFormat(CL);
  CL.AddTypeS('TJvPercent', 'Integer');
  CL.AddTypeS('TJvNumAudioBuffer', 'Integer');
  CL.AddTypeS('TJvVirtualKey', 'Integer');
  SIRegister_TJvCaptureSettings(CL);
  CL.AddTypeS('TJvPaletteNbColors', 'Integer');
  SIRegister_TJvPalette(CL);
  SIRegister_EInvalidDriverIndexError(CL);

  (* wavehdr_tag = record
    lpData: PChar;              { pointer to locked data buffer }
    dwBufferLength: DWORD;      { length of data buffer }
    dwBytesRecorded: DWORD;     { used for input only }
    dwUser: DWORD;              { for client's use }
    dwFlags: DWORD;             { assorted flags (see defines) }
    dwLoops: DWORD;             { loop control counter }
    lpNext: PWaveHdr;           { reserved for driver }
    reserved: DWORD;            { reserved for driver }
  end; *)

   CL.AddTypeS('wavehdr_tag', 'record lpdata: PChar; dwBufferLength : DWORD; dwBytesRecorded'
   +' : DWORD; dwUser : DWORD; dwFlags : DWORD; dwLoops : DWORD; lpNext: TObject; reserved: DWORD; end');
  CL.AddTypeS('TWaveHdr', 'wavehdr_tag');

  CL.AddTypeS('TJvDriverCap', '( dcOverlay, dcDlgVideoSource, dcDlgVide'
   +'oFormat, dcDlgVideoDisplay, dcCaptureInitialized, dcSuppliesPalettes )');
  CL.AddTypeS('TJvDriverCaps', 'set of TJvDriverCap');
 // CL.AddTypeS('TJvUsedEvents', 'set of ( ueCapControl, ueError, ueFrame, ueStat'
   //+'us, ueVideoStream, ueWaveStream, ueYield )');
  CL.AddTypeS('TJvVideoDialog', '( vdSource, vdFormat, vdDisplay, vdCompression)');
  //CL.AddTypeS('PJvVideoHdr', 'PVIDEOHDR');
  CL.AddTypeS('PJvWaveHdr', 'TWaveHdr');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvAVICapture');
  CL.AddTypeS('TOnError', 'Procedure ( Sender : TJvAVICapture; nErr : Integer; Str : string)');
  CL.AddTypeS('TOnStatus', 'Procedure ( Sender : TJvAVICapture; nId : Integer; Str : string)');
  CL.AddTypeS('TOnYield', 'Procedure ( Sender : TJvAVICapture)');
  //CL.AddTypeS('TOnVideoStream', 'Procedure ( Sender : TJvAVICapture; videoHdr : PJvVideoHdr)');
  //CL.AddTypeS('TOnFrame', 'TOnVideoStream');
  //CL.AddTypeS('TOnWaveStream', 'Procedure ( Sender : TJvAVICapture; waveHdr : PJvWaveHdr)');
  CL.AddTypeS('TOnCapControl', 'Procedure ( Sender : TJvAVICapture; nState : Integer; var Result : Boolean)');
  SIRegister_TJvAVICapture(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnCapControl_W(Self: TJvAVICapture; const T: TOnCapControl);
begin Self.OnCapControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnCapControl_R(Self: TJvAVICapture; var T: TOnCapControl);
begin T := Self.OnCapControl; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnWaveStream_W(Self: TJvAVICapture; const T: TOnWaveStream);
begin Self.OnWaveStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnWaveStream_R(Self: TJvAVICapture; var T: TOnWaveStream);
begin T := Self.OnWaveStream; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnVideoStream_W(Self: TJvAVICapture; const T: TOnVideoStream);
begin Self.OnVideoStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnVideoStream_R(Self: TJvAVICapture; var T: TOnVideoStream);
begin T := Self.OnVideoStream; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnFrame_W(Self: TJvAVICapture; const T: TOnFrame);
begin Self.OnFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnFrame_R(Self: TJvAVICapture; var T: TOnFrame);
begin T := Self.OnFrame; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnYield_W(Self: TJvAVICapture; const T: TOnYield);
begin Self.OnYield := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnYield_R(Self: TJvAVICapture; var T: TOnYield);
begin T := Self.OnYield; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnStatus_W(Self: TJvAVICapture; const T: TOnStatus);
begin Self.OnStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnStatus_R(Self: TJvAVICapture; var T: TOnStatus);
begin T := Self.OnStatus; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnError_W(Self: TJvAVICapture; const T: TOnError);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOnError_R(Self: TJvAVICapture; var T: TOnError);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureVideoTop_W(Self: TJvAVICapture; const T: Integer);
begin Self.VideoTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureVideoTop_R(Self: TJvAVICapture; var T: Integer);
begin T := Self.VideoTop; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureVideoLeft_W(Self: TJvAVICapture; const T: Integer);
begin Self.VideoLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureVideoLeft_R(Self: TJvAVICapture; var T: Integer);
begin T := Self.VideoLeft; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureUsedEvents_W(Self: TJvAVICapture; const T: TJvUsedEvents);
begin Self.UsedEvents := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureUsedEvents_R(Self: TJvAVICapture; var T: TJvUsedEvents);
begin T := Self.UsedEvents; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureTitle_W(Self: TJvAVICapture; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureTitle_R(Self: TJvAVICapture; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureScrollPos_W(Self: TJvAVICapture; const T: TJvScrollPos);
begin Self.ScrollPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureScrollPos_R(Self: TJvAVICapture; var T: TJvScrollPos);
begin T := Self.ScrollPos; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICapturePreviewing_W(Self: TJvAVICapture; const T: Boolean);
begin Self.Previewing := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICapturePreviewing_R(Self: TJvAVICapture; var T: Boolean);
begin T := Self.Previewing; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICapturePreviewFPS_W(Self: TJvAVICapture; const T: Double);
begin Self.PreviewFPS := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICapturePreviewFPS_R(Self: TJvAVICapture; var T: Double);
begin T := Self.PreviewFPS; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICapturePreviewFrameDelay_W(Self: TJvAVICapture; const T: Cardinal);
begin Self.PreviewFrameDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICapturePreviewFrameDelay_R(Self: TJvAVICapture; var T: Cardinal);
begin T := Self.PreviewFrameDelay; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOverlaying_W(Self: TJvAVICapture; const T: Boolean);
begin Self.Overlaying := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureOverlaying_R(Self: TJvAVICapture; var T: Boolean);
begin T := Self.Overlaying; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureNoFile_W(Self: TJvAVICapture; const T: Boolean);
begin Self.NoFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureNoFile_R(Self: TJvAVICapture; var T: Boolean);
begin T := Self.NoFile; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureMCIDevice_W(Self: TJvAVICapture; const T: string);
begin Self.MCIDevice := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureMCIDevice_R(Self: TJvAVICapture; var T: string);
begin T := Self.MCIDevice; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureFileSizeAlloc_W(Self: TJvAVICapture; const T: Cardinal);
begin Self.FileSizeAlloc := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureFileSizeAlloc_R(Self: TJvAVICapture; var T: Cardinal);
begin T := Self.FileSizeAlloc; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureFileName_W(Self: TJvAVICapture; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureFileName_R(Self: TJvAVICapture; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureDriverIndex_W(Self: TJvAVICapture; const T: TJvDriverIndex);
begin Self.DriverIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureDriverIndex_R(Self: TJvAVICapture; var T: TJvDriverIndex);
begin T := Self.DriverIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureCaptureSettings_R(Self: TJvAVICapture; var T: TJvCaptureSettings);
begin T := Self.CaptureSettings; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureAudioFormat_R(Self: TJvAVICapture; var T: TJvAudioFormat);
begin T := Self.AudioFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureVideoFormat_R(Self: TJvAVICapture; var T: TJvVideoFormat);
begin T := Self.VideoFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureSingleFrameCapturing_W(Self: TJvAVICapture; const T: Boolean);
begin Self.SingleFrameCapturing := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureSingleFrameCapturing_R(Self: TJvAVICapture; var T: Boolean);
begin T := Self.SingleFrameCapturing; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICapturePalette_R(Self: TJvAVICapture; var T: TJvPalette);
begin T := Self.Palette; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureHandle_R(Self: TJvAVICapture; var T: HWND);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureDrivers_R(Self: TJvAVICapture; var T: TStrings);
begin T := Self.Drivers; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureDriverVersion_R(Self: TJvAVICapture; var T: string);
begin T := Self.DriverVersion; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureDriverName_R(Self: TJvAVICapture; var T: string);
begin T := Self.DriverName; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureDriverCaps_R(Self: TJvAVICapture; var T: TJvDriverCaps);
begin T := Self.DriverCaps; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureConnected_R(Self: TJvAVICapture; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureCapturing_W(Self: TJvAVICapture; const T: Boolean);
begin Self.Capturing := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureCapturing_R(Self: TJvAVICapture; var T: Boolean);
begin T := Self.Capturing; end;

(*----------------------------------------------------------------------------*)
procedure TJvAVICaptureCaptureStatus_R(Self: TJvAVICapture; var T: TCAPSTATUS);
begin T := Self.CaptureStatus; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsMCIStopTime_W(Self: TJvCaptureSettings; const T: Cardinal);
begin Self.MCIStopTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsMCIStopTime_R(Self: TJvCaptureSettings; var T: Cardinal);
begin T := Self.MCIStopTime; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsMCIStartTime_W(Self: TJvCaptureSettings; const T: Cardinal);
begin Self.MCIStartTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsMCIStartTime_R(Self: TJvCaptureSettings; var T: Cardinal);
begin T := Self.MCIStartTime; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsMCIStep_W(Self: TJvCaptureSettings; const T: Boolean);
begin Self.MCIStep := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsMCIStep_R(Self: TJvCaptureSettings; var T: Boolean);
begin T := Self.MCIStep; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsMCIControl_W(Self: TJvCaptureSettings; const T: Boolean);
begin Self.MCIControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsMCIControl_R(Self: TJvCaptureSettings; var T: Boolean);
begin T := Self.MCIControl; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsAudioMaster_W(Self: TJvCaptureSettings; const T: Boolean);
begin Self.AudioMaster := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsAudioMaster_R(Self: TJvCaptureSettings; var T: Boolean);
begin T := Self.AudioMaster; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsAudioBufferSize_W(Self: TJvCaptureSettings; const T: Cardinal);
begin Self.AudioBufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsAudioBufferSize_R(Self: TJvCaptureSettings; var T: Cardinal);
begin T := Self.AudioBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsStepCaptureAverageFrames_W(Self: TJvCaptureSettings; const T: Cardinal);
begin Self.StepCaptureAverageFrames := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsStepCaptureAverageFrames_R(Self: TJvCaptureSettings; var T: Cardinal);
begin T := Self.StepCaptureAverageFrames; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsStepCapture2x_W(Self: TJvCaptureSettings; const T: Boolean);
begin Self.StepCapture2x := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsStepCapture2x_R(Self: TJvCaptureSettings; var T: Boolean);
begin T := Self.StepCapture2x; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsTimeLimit_W(Self: TJvCaptureSettings; const T: Cardinal);
begin Self.TimeLimit := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsTimeLimit_R(Self: TJvCaptureSettings; var T: Cardinal);
begin T := Self.TimeLimit; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsLimitEnabled_W(Self: TJvCaptureSettings; const T: Boolean);
begin Self.LimitEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsLimitEnabled_R(Self: TJvCaptureSettings; var T: Boolean);
begin T := Self.LimitEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsKeyAbort_W(Self: TJvCaptureSettings; const T: TJvVirtualKey);
begin Self.KeyAbort := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsKeyAbort_R(Self: TJvCaptureSettings; var T: TJvVirtualKey);
begin T := Self.KeyAbort; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsAbortRightMouse_W(Self: TJvCaptureSettings; const T: Boolean);
begin Self.AbortRightMouse := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsAbortRightMouse_R(Self: TJvCaptureSettings; var T: Boolean);
begin T := Self.AbortRightMouse; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsAbortLeftMouse_W(Self: TJvCaptureSettings; const T: Boolean);
begin Self.AbortLeftMouse := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsAbortLeftMouse_R(Self: TJvCaptureSettings; var T: Boolean);
begin T := Self.AbortLeftMouse; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsCaptureAudio_W(Self: TJvCaptureSettings; const T: Boolean);
begin Self.CaptureAudio := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsCaptureAudio_R(Self: TJvCaptureSettings; var T: Boolean);
begin T := Self.CaptureAudio; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsNumAudioBuffer_W(Self: TJvCaptureSettings; const T: TJvNumAudioBuffer);
begin Self.NumAudioBuffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsNumAudioBuffer_R(Self: TJvCaptureSettings; var T: TJvNumAudioBuffer);
begin T := Self.NumAudioBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsNumVideoBuffer_W(Self: TJvCaptureSettings; const T: Cardinal);
begin Self.NumVideoBuffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsNumVideoBuffer_R(Self: TJvCaptureSettings; var T: Cardinal);
begin T := Self.NumVideoBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsYield_W(Self: TJvCaptureSettings; const T: Boolean);
begin Self.Yield := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsYield_R(Self: TJvCaptureSettings; var T: Boolean);
begin T := Self.Yield; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsPercentDropForError_W(Self: TJvCaptureSettings; const T: TJvPercent);
begin Self.PercentDropForError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsPercentDropForError_R(Self: TJvCaptureSettings; var T: TJvPercent);
begin T := Self.PercentDropForError; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsFPS_W(Self: TJvCaptureSettings; const T: Double);
begin Self.FPS := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsFPS_R(Self: TJvCaptureSettings; var T: Double);
begin T := Self.FPS; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsFrameDelay_W(Self: TJvCaptureSettings; const T: Cardinal);
begin Self.FrameDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsFrameDelay_R(Self: TJvCaptureSettings; var T: Cardinal);
begin T := Self.FrameDelay; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsConfirmCapture_W(Self: TJvCaptureSettings; const T: Boolean);
begin Self.ConfirmCapture := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCaptureSettingsConfirmCapture_R(Self: TJvCaptureSettings; var T: Boolean);
begin T := Self.ConfirmCapture; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatBitsPerSample_W(Self: TJvAudioFormat; const T: Cardinal);
begin Self.BitsPerSample := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatBitsPerSample_R(Self: TJvAudioFormat; var T: Cardinal);
begin T := Self.BitsPerSample; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatBlockAlign_W(Self: TJvAudioFormat; const T: Cardinal);
begin Self.BlockAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatBlockAlign_R(Self: TJvAudioFormat; var T: Cardinal);
begin T := Self.BlockAlign; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatAvgBytesPerSec_W(Self: TJvAudioFormat; const T: Cardinal);
begin Self.AvgBytesPerSec := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatAvgBytesPerSec_R(Self: TJvAudioFormat; var T: Cardinal);
begin T := Self.AvgBytesPerSec; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatSamplesPerSec_W(Self: TJvAudioFormat; const T: Cardinal);
begin Self.SamplesPerSec := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatSamplesPerSec_R(Self: TJvAudioFormat; var T: Cardinal);
begin T := Self.SamplesPerSec; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatChannels_W(Self: TJvAudioFormat; const T: Cardinal);
begin Self.Channels := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatChannels_R(Self: TJvAudioFormat; var T: Cardinal);
begin T := Self.Channels; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatFormatTag_W(Self: TJvAudioFormat; const T: Cardinal);
begin Self.FormatTag := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatFormatTag_R(Self: TJvAudioFormat; var T: Cardinal);
begin T := Self.FormatTag; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatExtra_W(Self: TJvAudioFormat; const T: Pointer);
begin Self.Extra := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatExtra_R(Self: TJvAudioFormat; var T: Pointer);
begin T := Self.Extra; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatExtraSize_W(Self: TJvAudioFormat; const T: Cardinal);
begin Self.ExtraSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAudioFormatExtraSize_R(Self: TJvAudioFormat; var T: Cardinal);
begin T := Self.ExtraSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvVideoFormatCompression_R(Self: TJvVideoFormat; var T: Integer);
begin T := Self.Compression; end;

(*----------------------------------------------------------------------------*)
procedure TJvVideoFormatPixelFormat_R(Self: TJvVideoFormat; var T: TPixelFormat);
begin T := Self.PixelFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJvVideoFormatBitDepth_R(Self: TJvVideoFormat; var T: Cardinal);
begin T := Self.BitDepth; end;

(*----------------------------------------------------------------------------*)
procedure TJvVideoFormatHeight_R(Self: TJvVideoFormat; var T: Cardinal);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TJvVideoFormatWidth_R(Self: TJvVideoFormat; var T: Cardinal);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TJvScrollPosTop_W(Self: TJvScrollPos; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvScrollPosTop_R(Self: TJvScrollPos; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TJvScrollPosLeft_W(Self: TJvScrollPos; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvScrollPosLeft_R(Self: TJvScrollPos; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAVICapture(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAVICapture) do begin
    RegisterConstructor(@TJvAVICapture.Create, 'Create');
     RegisterMethod(@TJvAVICapture.Destroy, 'Free');
     RegisterMethod(@TJvAVICapture.SetBounds, 'SetBounds');
    RegisterMethod(@TJvAVICapture.EnumDrivers, 'EnumDrivers');
    RegisterMethod(@TJvAVICapture.Connect, 'Connect');
    RegisterMethod(@TJvAVICapture.Disconnect, 'Disconnect');
    RegisterMethod(@TJvAVICapture.ShowDialog, 'ShowDialog');
    RegisterMethod(@TJvAVICapture.StartPreview, 'StartPreview');
    RegisterMethod(@TJvAVICapture.StopPreview, 'StopPreview');
    RegisterMethod(@TJvAVICapture.StartCapture, 'StartCapture');
    RegisterMethod(@TJvAVICapture.StartCaptureNoFile, 'StartCaptureNoFile');
    RegisterMethod(@TJvAVICapture.StopCapture, 'StopCapture');
    RegisterMethod(@TJvAVICapture.AbortCapture, 'AbortCapture');
    RegisterMethod(@TJvAVICapture.StartSingleFrameCapture, 'StartSingleFrameCapture');
    RegisterMethod(@TJvAVICapture.CaptureFrame, 'CaptureFrame');
    RegisterMethod(@TJvAVICapture.StopSingleFrameCapture, 'StopSingleFrameCapture');
    RegisterMethod(@TJvAVICapture.StartOverlay, 'StartOverlay');
    RegisterMethod(@TJvAVICapture.StopOverlay, 'StopOverlay');
    RegisterMethod(@TJvAVICapture.ApplyCaptureSettings, 'ApplyCaptureSettings');
    RegisterMethod(@TJvAVICapture.ApplyAudioFormat, 'ApplyAudioFormat');
    RegisterMethod(@TJvAVICapture.SaveAs, 'SaveAs');
    RegisterMethod(@TJvAVICapture.SetInfoChunk, 'SetInfoChunk');
    RegisterMethod(@TJvAVICapture.SaveDIB, 'SaveDIB');
    RegisterMethod(@TJvAVICapture.CopyToClipboard, 'CopyToClipboard');
    RegisterMethod(@TJvAVICapture.GrabFrame, 'GrabFrame');
    RegisterPropertyHelper(@TJvAVICaptureCaptureStatus_R,nil,'CaptureStatus');
    RegisterPropertyHelper(@TJvAVICaptureCapturing_R,@TJvAVICaptureCapturing_W,'Capturing');
    RegisterPropertyHelper(@TJvAVICaptureConnected_R,nil,'Connected');
    RegisterPropertyHelper(@TJvAVICaptureDriverCaps_R,nil,'DriverCaps');
    RegisterPropertyHelper(@TJvAVICaptureDriverName_R,nil,'DriverName');
    RegisterPropertyHelper(@TJvAVICaptureDriverVersion_R,nil,'DriverVersion');
    RegisterPropertyHelper(@TJvAVICaptureDrivers_R,nil,'Drivers');
    RegisterPropertyHelper(@TJvAVICaptureHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TJvAVICapturePalette_R,nil,'Palette');
    RegisterPropertyHelper(@TJvAVICaptureSingleFrameCapturing_R,@TJvAVICaptureSingleFrameCapturing_W,'SingleFrameCapturing');
    RegisterPropertyHelper(@TJvAVICaptureVideoFormat_R,nil,'VideoFormat');
    RegisterPropertyHelper(@TJvAVICaptureAudioFormat_R,nil,'AudioFormat');
    RegisterPropertyHelper(@TJvAVICaptureCaptureSettings_R,nil,'CaptureSettings');
    RegisterPropertyHelper(@TJvAVICaptureDriverIndex_R,@TJvAVICaptureDriverIndex_W,'DriverIndex');
    RegisterPropertyHelper(@TJvAVICaptureFileName_R,@TJvAVICaptureFileName_W,'FileName');
    RegisterPropertyHelper(@TJvAVICaptureFileSizeAlloc_R,@TJvAVICaptureFileSizeAlloc_W,'FileSizeAlloc');
    RegisterPropertyHelper(@TJvAVICaptureMCIDevice_R,@TJvAVICaptureMCIDevice_W,'MCIDevice');
    RegisterPropertyHelper(@TJvAVICaptureNoFile_R,@TJvAVICaptureNoFile_W,'NoFile');
    RegisterPropertyHelper(@TJvAVICaptureOverlaying_R,@TJvAVICaptureOverlaying_W,'Overlaying');
    RegisterPropertyHelper(@TJvAVICapturePreviewFrameDelay_R,@TJvAVICapturePreviewFrameDelay_W,'PreviewFrameDelay');
    RegisterPropertyHelper(@TJvAVICapturePreviewFPS_R,@TJvAVICapturePreviewFPS_W,'PreviewFPS');
    RegisterPropertyHelper(@TJvAVICapturePreviewing_R,@TJvAVICapturePreviewing_W,'Previewing');
    RegisterPropertyHelper(@TJvAVICaptureScrollPos_R,@TJvAVICaptureScrollPos_W,'ScrollPos');
    RegisterPropertyHelper(@TJvAVICaptureTitle_R,@TJvAVICaptureTitle_W,'Title');
    RegisterPropertyHelper(@TJvAVICaptureUsedEvents_R,@TJvAVICaptureUsedEvents_W,'UsedEvents');
    RegisterPropertyHelper(@TJvAVICaptureVideoLeft_R,@TJvAVICaptureVideoLeft_W,'VideoLeft');
    RegisterPropertyHelper(@TJvAVICaptureVideoTop_R,@TJvAVICaptureVideoTop_W,'VideoTop');
    RegisterPropertyHelper(@TJvAVICaptureOnError_R,@TJvAVICaptureOnError_W,'OnError');
    RegisterPropertyHelper(@TJvAVICaptureOnStatus_R,@TJvAVICaptureOnStatus_W,'OnStatus');
    RegisterPropertyHelper(@TJvAVICaptureOnYield_R,@TJvAVICaptureOnYield_W,'OnYield');
    RegisterPropertyHelper(@TJvAVICaptureOnFrame_R,@TJvAVICaptureOnFrame_W,'OnFrame');
    RegisterPropertyHelper(@TJvAVICaptureOnVideoStream_R,@TJvAVICaptureOnVideoStream_W,'OnVideoStream');
    RegisterPropertyHelper(@TJvAVICaptureOnWaveStream_R,@TJvAVICaptureOnWaveStream_W,'OnWaveStream');
    RegisterPropertyHelper(@TJvAVICaptureOnCapControl_R,@TJvAVICaptureOnCapControl_W,'OnCapControl');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EInvalidDriverIndexError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInvalidDriverIndexError) do
  begin
    RegisterConstructor(@EInvalidDriverIndexError.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvPalette(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvPalette) do
  begin
    RegisterConstructor(@TJvPalette.Create, 'Create');
    RegisterMethod(@TJvPalette.Save, 'Save');
    RegisterMethod(@TJvPalette.Load, 'Load');
    RegisterMethod(@TJvPalette.PasteFromClipboard, 'PasteFromClipboard');
    RegisterMethod(@TJvPalette.AutoCreate, 'AutoCreate');
    RegisterMethod(@TJvPalette.ManuallyCreate, 'ManuallyCreate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCaptureSettings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCaptureSettings) do
  begin
    RegisterConstructor(@TJvCaptureSettings.Create, 'Create');
    RegisterMethod(@TJvCaptureSettings.Update, 'Update');
    RegisterMethod(@TJvCaptureSettings.Apply, 'Apply');
    RegisterPropertyHelper(@TJvCaptureSettingsConfirmCapture_R,@TJvCaptureSettingsConfirmCapture_W,'ConfirmCapture');
    RegisterPropertyHelper(@TJvCaptureSettingsFrameDelay_R,@TJvCaptureSettingsFrameDelay_W,'FrameDelay');
    RegisterPropertyHelper(@TJvCaptureSettingsFPS_R,@TJvCaptureSettingsFPS_W,'FPS');
    RegisterPropertyHelper(@TJvCaptureSettingsPercentDropForError_R,@TJvCaptureSettingsPercentDropForError_W,'PercentDropForError');
    RegisterPropertyHelper(@TJvCaptureSettingsYield_R,@TJvCaptureSettingsYield_W,'Yield');
    RegisterPropertyHelper(@TJvCaptureSettingsNumVideoBuffer_R,@TJvCaptureSettingsNumVideoBuffer_W,'NumVideoBuffer');
    RegisterPropertyHelper(@TJvCaptureSettingsNumAudioBuffer_R,@TJvCaptureSettingsNumAudioBuffer_W,'NumAudioBuffer');
    RegisterPropertyHelper(@TJvCaptureSettingsCaptureAudio_R,@TJvCaptureSettingsCaptureAudio_W,'CaptureAudio');
    RegisterPropertyHelper(@TJvCaptureSettingsAbortLeftMouse_R,@TJvCaptureSettingsAbortLeftMouse_W,'AbortLeftMouse');
    RegisterPropertyHelper(@TJvCaptureSettingsAbortRightMouse_R,@TJvCaptureSettingsAbortRightMouse_W,'AbortRightMouse');
    RegisterPropertyHelper(@TJvCaptureSettingsKeyAbort_R,@TJvCaptureSettingsKeyAbort_W,'KeyAbort');
    RegisterPropertyHelper(@TJvCaptureSettingsLimitEnabled_R,@TJvCaptureSettingsLimitEnabled_W,'LimitEnabled');
    RegisterPropertyHelper(@TJvCaptureSettingsTimeLimit_R,@TJvCaptureSettingsTimeLimit_W,'TimeLimit');
    RegisterPropertyHelper(@TJvCaptureSettingsStepCapture2x_R,@TJvCaptureSettingsStepCapture2x_W,'StepCapture2x');
    RegisterPropertyHelper(@TJvCaptureSettingsStepCaptureAverageFrames_R,@TJvCaptureSettingsStepCaptureAverageFrames_W,'StepCaptureAverageFrames');
    RegisterPropertyHelper(@TJvCaptureSettingsAudioBufferSize_R,@TJvCaptureSettingsAudioBufferSize_W,'AudioBufferSize');
    RegisterPropertyHelper(@TJvCaptureSettingsAudioMaster_R,@TJvCaptureSettingsAudioMaster_W,'AudioMaster');
    RegisterPropertyHelper(@TJvCaptureSettingsMCIControl_R,@TJvCaptureSettingsMCIControl_W,'MCIControl');
    RegisterPropertyHelper(@TJvCaptureSettingsMCIStep_R,@TJvCaptureSettingsMCIStep_W,'MCIStep');
    RegisterPropertyHelper(@TJvCaptureSettingsMCIStartTime_R,@TJvCaptureSettingsMCIStartTime_W,'MCIStartTime');
    RegisterPropertyHelper(@TJvCaptureSettingsMCIStopTime_R,@TJvCaptureSettingsMCIStopTime_W,'MCIStopTime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAudioFormat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAudioFormat) do
  begin
    RegisterConstructor(@TJvAudioFormat.Create, 'Create');
    RegisterMethod(@TJvAudioFormat.Update, 'Update');
    RegisterMethod(@TJvAudioFormat.Apply, 'Apply');
    RegisterMethod(@TJvAudioFormat.FillWaveFormatEx, 'FillWaveFormatEx');
    RegisterPropertyHelper(@TJvAudioFormatExtraSize_R,@TJvAudioFormatExtraSize_W,'ExtraSize');
    RegisterPropertyHelper(@TJvAudioFormatExtra_R,@TJvAudioFormatExtra_W,'Extra');
    RegisterPropertyHelper(@TJvAudioFormatFormatTag_R,@TJvAudioFormatFormatTag_W,'FormatTag');
    RegisterPropertyHelper(@TJvAudioFormatChannels_R,@TJvAudioFormatChannels_W,'Channels');
    RegisterPropertyHelper(@TJvAudioFormatSamplesPerSec_R,@TJvAudioFormatSamplesPerSec_W,'SamplesPerSec');
    RegisterPropertyHelper(@TJvAudioFormatAvgBytesPerSec_R,@TJvAudioFormatAvgBytesPerSec_W,'AvgBytesPerSec');
    RegisterPropertyHelper(@TJvAudioFormatBlockAlign_R,@TJvAudioFormatBlockAlign_W,'BlockAlign');
    RegisterPropertyHelper(@TJvAudioFormatBitsPerSample_R,@TJvAudioFormatBitsPerSample_W,'BitsPerSample');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvVideoFormat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvVideoFormat) do
  begin
    RegisterConstructor(@TJvVideoFormat.Create, 'Create');
    RegisterMethod(@TJvVideoFormat.Update, 'Update');
    RegisterPropertyHelper(@TJvVideoFormatWidth_R,nil,'Width');
    RegisterPropertyHelper(@TJvVideoFormatHeight_R,nil,'Height');
    RegisterPropertyHelper(@TJvVideoFormatBitDepth_R,nil,'BitDepth');
    RegisterPropertyHelper(@TJvVideoFormatPixelFormat_R,nil,'PixelFormat');
    RegisterPropertyHelper(@TJvVideoFormatCompression_R,nil,'Compression');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvScrollPos(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvScrollPos) do
  begin
    RegisterPropertyHelper(@TJvScrollPosLeft_R,@TJvScrollPosLeft_W,'Left');
    RegisterPropertyHelper(@TJvScrollPosTop_R,@TJvScrollPosTop_W,'Top');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvAVICapture(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvScrollPos(CL);
  RIRegister_TJvVideoFormat(CL);
  RIRegister_TJvAudioFormat(CL);
  RIRegister_TJvCaptureSettings(CL);
  RIRegister_TJvPalette(CL);
  RIRegister_EInvalidDriverIndexError(CL);
  with CL.Add(TJvAVICapture) do
  RIRegister_TJvAVICapture(CL);
end;

 
 
{ TPSImport_JvAVICapture }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAVICapture.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvAVICapture(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAVICapture.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvAVICapture(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
