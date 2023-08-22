unit uPSI_AviCap;
{
   video vodoo capture
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
  TPSImport_AviCap = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_AviCap(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AviCap_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,MMSystem
  ,Messages
  ,AviCap
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AviCap]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_AviCap(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('WM_USER','LongWord').SetUInt( $0400);
 CL.AddConstantN('WM_CAP_START','LongWord').SetUint($0400);
 CL.AddConstantN('WM_CAP_END','longword').SetUint($0400+85);

 CL.AddConstantN('WM_CAP_DRIVER_CONNECT','longword').setint($0400+10);
 CL.AddConstantN('WM_CAP_DRIVER_DISCONNECT','longword').setint($0400+11);
 CL.AddConstantN('WM_CAP_SET_CALLBACK_FRAME','longword').setint($0400+5);

       //WM_CAP_DRIVER_DISCONNECT = WM_CAP_START + 11;
       //WM_CAP_SET_CALLBACK_FRAME = (WM_CAP_START+  5);

 //WM_CAP_START+  85
 //    WM_CAP_SET_CALLBACK_CAPCONTROL  = (WM_CAP_START+  85);

 CL.AddDelphiFunction('Function capSetCallbackOnError( hwnd : THandle; fpProc : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capSetCallbackOnStatus( hwnd : THandle; fpProc : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capSetCallbackOnYield( hwnd : THandle; fpProc : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capSetCallbackOnFrame( hwnd : THandle; fpProc : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capSetCallbackOnVideoStream( hwnd : THandle; fpProc : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capSetCallbackOnWaveStream( hwnd : THandle; fpProc : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capSetCallbackOnCapControl( hwnd : THandle; fpProc : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capSetUserData( hwnd : THandle; lUser : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capGetUserData( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capDriverConnect( hwnd : THandle; I : Word) : LongInt');
 CL.AddDelphiFunction('Function capDriverDisconnect( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capDriverGetName( hwnd : THandle; szName : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capDriverGetVersion( hwnd : THandle; szVer : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capDriverGetCaps( hwnd : THandle; s : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capFileSetCaptureFile( hwnd : THandle; szName : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capFileGetCaptureFile( hwnd : THandle; szName : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capFileAlloc( hwnd : THandle; dwSize : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capFileSaveAs( hwnd : THandle; szName : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capFileSetInfoChunk( hwnd : THandle; lpInfoChunk : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capFileSaveDIB( hwnd : THandle; szName : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capEditCopy( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capSetAudioFormat( hwnd : THandle; s : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capGetAudioFormat( hwnd : THandle; s : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capGetAudioFormatSize( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capDlgVideoFormat( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capDlgVideoSource( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capDlgVideoDisplay( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capDlgVideoCompression( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capGetVideoFormat( hwnd : THandle; s : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capGetVideoFormatSize( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capSetVideoFormat( hwnd : THandle; s : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capPreview( hwnd : THandle; f : Word) : LongInt');
 CL.AddDelphiFunction('Function capPreviewRate( hwnd : THandle; wMS : Word) : LongInt');
 CL.AddDelphiFunction('Function capOverlay( hwnd : THandle; f : Word) : LongInt');
 CL.AddDelphiFunction('Function capPreviewScale( hwnd : THandle; f : Word) : LongInt');
 CL.AddDelphiFunction('Function capGetStatus( hwnd : THandle; s : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capSetScrollPos( hwnd : THandle; lpP : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capGrabFrame( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capGrabFrameNoStop( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capCaptureSequence( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capCaptureSequenceNoFile( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capCaptureStop( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capCaptureAbort( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capCaptureSingleFrameOpen( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capCaptureSingleFrameClose( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capCaptureSingleFrame( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capCaptureGetSetup( hwnd : THandle; s : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capCaptureSetSetup( hwnd : THandle; s : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capSetMCIDeviceName( hwnd : THandle; szName : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capGetMCIDeviceName( hwnd : THandle; szName : LongInt; wSize : Word) : LongInt');
 CL.AddDelphiFunction('Function capPaletteOpen( hwnd : THandle; szName : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capPaletteSave( hwnd : THandle; szName : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capPalettePaste( hwnd : THandle) : LongInt');
 CL.AddDelphiFunction('Function capPaletteAuto( hwnd : THandle; iFrames : Word; iColors : LongInt) : LongInt');
 CL.AddDelphiFunction('Function capPaletteManual( hwnd : THandle; fGrab : Word; iColors : LongInt) : LongInt');
  //CL.AddTypeS('PCapDriverCaps', '^TCapDriverCaps // will not work');
  CL.AddTypeS('TCapDriverCaps', 'record wDeviceIndex : WORD; fHasOverlay : BOOL'
   +'; fHasDlgVideoSource : BOOL; fHasDlgVideoFormat : BOOL; fHasDlgVideoDispla'
   +'y : BOOL; fCaptureInitialized : BOOL; fDriverSuppliesPalettes : BOOL; hVid'
   +'eoIn : THANDLE; hVideoOut : THANDLE; hVideoExtIn : THANDLE; hVideoExtOut : THANDLE; end');
  //CL.AddTypeS('PCapStatus', '^TCapStatus // will not work');
  CL.AddTypeS('TCapStatus', 'record uiImageWidth : UINT; uiImageHeight : UINT; '
   +'fLiveWindow : BOOL; fOverlayWindow : BOOL; fScale : BOOL; ptScroll : TPOIN'
   +'T; fUsingDefaultPalette : BOOL; fAudioHardware : BOOL; fCapFileExists : BO'
   +'OL; dwCurrentVideoFrame : DWORD; dwCurrentVideoFramesDropped : DWORD; dwCu'
   +'rrentWaveSamples : DWORD; dwCurrentTimeElapsedMS : DWORD; hPalCurrent : HP'
   +'ALETTE; fCapturingNow : BOOL; dwReturn : DWORD; wNumVideoAllocated : WORD;'
   +' wNumAudioAllocated : WORD; end');
  //CL.AddTypeS('PCaptureParms', '^TCaptureParms // will not work');
  CL.AddTypeS('TCaptureParms', 'record dwRequestMicroSecPerFrame : DWORD; fMake'
   +'UserHitOKToCapture : BOOL; wPercentDropForError : WORD; fYield : BOOL; dwI'
   +'ndexSize : DWORD; wChunkGranularity : WORD; fUsingDOSMemory : BOOL; wNumVi'
   +'deoRequested : WORD; fCaptureAudio : BOOL; wNumAudioRequested : WORD; vKey'
   +'Abort : WORD; fAbortLeftMouse : BOOL; fAbortRightMouse : BOOL; fLimitEnabl'
   +'ed : BOOL; wTimeLimit : WORD; fMCIControl : BOOL; fStepMCIDevice : BOOL; d'
   +'wMCIStartTime : DWORD; dwMCIStopTime : DWORD; fStepCaptureAt2x : BOOL; wSt'
   +'epCaptureAverageFrames : WORD; dwAudioBufferSize : DWORD; fDisableWriteCac'
   +'he : BOOL; AVStreamMaster : WORD; end');
 // CL.AddTypeS('PCapInfoChunk', '^TCapInfoChunk // will not work');
  //CL.AddTypeS('TCapInfoChunk', 'record fccInfoID : FOURCC; lpData : LongInt; cbData : LongInt; end');
 CL.AddConstantN('CONTROLCALLBACK_PREROLL','LongInt').SetInt( 1);
 CL.AddConstantN('CONTROLCALLBACK_CAPTURING','LongInt').SetInt( 2);
 CL.AddDelphiFunction('Function capCreateCaptureWindow( lpszWindowName : PChar; dwStyle : DWord; x, y : Integer; nWidth, nHeight : Integer; hwndParent : THandle; nID : Integer) : THandle');
 CL.AddDelphiFunction('Function capGetDriverDescription( wDriverIndex : DWord; lpszName : PChar; cbName : Integer; lpszVer : PChar; cbVer : Integer) : Boolean');
 CL.AddConstantN('IDS_CAP_BEGIN','LongInt').SetInt( 300);
 CL.AddConstantN('IDS_CAP_END','LongInt').SetInt( 301);
 CL.AddConstantN('IDS_CAP_INFO','LongInt').SetInt( 401);
 CL.AddConstantN('IDS_CAP_OUTOFMEM','LongInt').SetInt( 402);
 CL.AddConstantN('IDS_CAP_FILEEXISTS','LongInt').SetInt( 403);
 CL.AddConstantN('IDS_CAP_ERRORPALOPEN','LongInt').SetInt( 404);
 CL.AddConstantN('IDS_CAP_ERRORPALSAVE','LongInt').SetInt( 405);
 CL.AddConstantN('IDS_CAP_ERRORDIBSAVE','LongInt').SetInt( 406);
 CL.AddConstantN('IDS_CAP_DEFAVIEXT','LongInt').SetInt( 407);
 CL.AddConstantN('IDS_CAP_DEFPALEXT','LongInt').SetInt( 408);
 CL.AddConstantN('IDS_CAP_CANTOPEN','LongInt').SetInt( 409);
 CL.AddConstantN('IDS_CAP_SEQ_MSGSTART','LongInt').SetInt( 410);
 CL.AddConstantN('IDS_CAP_SEQ_MSGSTOP','LongInt').SetInt( 411);
 CL.AddConstantN('IDS_CAP_VIDEDITERR','LongInt').SetInt( 412);
 CL.AddConstantN('IDS_CAP_READONLYFILE','LongInt').SetInt( 413);
 CL.AddConstantN('IDS_CAP_WRITEERROR','LongInt').SetInt( 414);
 CL.AddConstantN('IDS_CAP_NODISKSPACE','LongInt').SetInt( 415);
 CL.AddConstantN('IDS_CAP_SETFILESIZE','LongInt').SetInt( 416);
 CL.AddConstantN('IDS_CAP_SAVEASPERCENT','LongInt').SetInt( 417);
 CL.AddConstantN('IDS_CAP_DRIVER_ERROR','LongInt').SetInt( 418);
 CL.AddConstantN('IDS_CAP_WAVE_OPEN_ERROR','LongInt').SetInt( 419);
 CL.AddConstantN('IDS_CAP_WAVE_ALLOC_ERROR','LongInt').SetInt( 420);
 CL.AddConstantN('IDS_CAP_WAVE_PREPARE_ERROR','LongInt').SetInt( 421);
 CL.AddConstantN('IDS_CAP_WAVE_ADD_ERROR','LongInt').SetInt( 422);
 CL.AddConstantN('IDS_CAP_WAVE_SIZE_ERROR','LongInt').SetInt( 423);
 CL.AddConstantN('IDS_CAP_VIDEO_OPEN_ERROR','LongInt').SetInt( 424);
 CL.AddConstantN('IDS_CAP_VIDEO_ALLOC_ERROR','LongInt').SetInt( 425);
 CL.AddConstantN('IDS_CAP_VIDEO_PREPARE_ERROR','LongInt').SetInt( 426);
 CL.AddConstantN('IDS_CAP_VIDEO_ADD_ERROR','LongInt').SetInt( 427);
 CL.AddConstantN('IDS_CAP_VIDEO_SIZE_ERROR','LongInt').SetInt( 428);
 CL.AddConstantN('IDS_CAP_FILE_OPEN_ERROR','LongInt').SetInt( 429);
 CL.AddConstantN('IDS_CAP_FILE_WRITE_ERROR','LongInt').SetInt( 430);
 CL.AddConstantN('IDS_CAP_RECORDING_ERROR','LongInt').SetInt( 431);
 CL.AddConstantN('IDS_CAP_RECORDING_ERROR2','LongInt').SetInt( 432);
 CL.AddConstantN('IDS_CAP_AVI_INIT_ERROR','LongInt').SetInt( 433);
 CL.AddConstantN('IDS_CAP_NO_FRAME_CAP_ERROR','LongInt').SetInt( 434);
 CL.AddConstantN('IDS_CAP_NO_PALETTE_WARN','LongInt').SetInt( 435);
 CL.AddConstantN('IDS_CAP_MCI_CONTROL_ERROR','LongInt').SetInt( 436);
 CL.AddConstantN('IDS_CAP_MCI_CANT_STEP_ERROR','LongInt').SetInt( 437);
 CL.AddConstantN('IDS_CAP_NO_AUDIO_CAP_ERROR','LongInt').SetInt( 438);
 CL.AddConstantN('IDS_CAP_AVI_DRAWDIB_ERROR','LongInt').SetInt( 439);
 CL.AddConstantN('IDS_CAP_COMPRESSOR_ERROR','LongInt').SetInt( 440);
 CL.AddConstantN('IDS_CAP_AUDIO_DROP_ERROR','LongInt').SetInt( 441);
 CL.AddConstantN('IDS_CAP_STAT_LIVE_MODE','LongInt').SetInt( 500);
 CL.AddConstantN('IDS_CAP_STAT_OVERLAY_MODE','LongInt').SetInt( 501);
 CL.AddConstantN('IDS_CAP_STAT_CAP_INIT','LongInt').SetInt( 502);
 CL.AddConstantN('IDS_CAP_STAT_CAP_FINI','LongInt').SetInt( 503);
 CL.AddConstantN('IDS_CAP_STAT_PALETTE_BUILD','LongInt').SetInt( 504);
 CL.AddConstantN('IDS_CAP_STAT_OPTPAL_BUILD','LongInt').SetInt( 505);
 CL.AddConstantN('IDS_CAP_STAT_I_FRAMES','LongInt').SetInt( 506);
 CL.AddConstantN('IDS_CAP_STAT_L_FRAMES','LongInt').SetInt( 507);
 CL.AddConstantN('IDS_CAP_STAT_CAP_L_FRAMES','LongInt').SetInt( 508);
 CL.AddConstantN('IDS_CAP_STAT_CAP_AUDIO','LongInt').SetInt( 509);
 CL.AddConstantN('IDS_CAP_STAT_VIDEOCURRENT','LongInt').SetInt( 510);
 CL.AddConstantN('IDS_CAP_STAT_VIDEOAUDIO','LongInt').SetInt( 511);
 CL.AddConstantN('IDS_CAP_STAT_VIDEOONLY','LongInt').SetInt( 512);
 CL.AddConstantN('IDS_CAP_STAT_FRAMESDROPPED','LongInt').SetInt( 513);
 CL.AddConstantN('AVICAP32','String').SetString( 'AVICAP32.dll');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_AviCap_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@capSetCallbackOnError, 'capSetCallbackOnError', cdRegister);
 S.RegisterDelphiFunction(@capSetCallbackOnStatus, 'capSetCallbackOnStatus', cdRegister);
 S.RegisterDelphiFunction(@capSetCallbackOnYield, 'capSetCallbackOnYield', cdRegister);
 S.RegisterDelphiFunction(@capSetCallbackOnFrame, 'capSetCallbackOnFrame', cdRegister);
 S.RegisterDelphiFunction(@capSetCallbackOnVideoStream, 'capSetCallbackOnVideoStream', cdRegister);
 S.RegisterDelphiFunction(@capSetCallbackOnWaveStream, 'capSetCallbackOnWaveStream', cdRegister);
 S.RegisterDelphiFunction(@capSetCallbackOnCapControl, 'capSetCallbackOnCapControl', cdRegister);
 S.RegisterDelphiFunction(@capSetUserData, 'capSetUserData', cdRegister);
 S.RegisterDelphiFunction(@capGetUserData, 'capGetUserData', cdRegister);
 S.RegisterDelphiFunction(@capDriverConnect, 'capDriverConnect', cdRegister);
 S.RegisterDelphiFunction(@capDriverDisconnect, 'capDriverDisconnect', cdRegister);
 S.RegisterDelphiFunction(@capDriverGetName, 'capDriverGetName', cdRegister);
 S.RegisterDelphiFunction(@capDriverGetVersion, 'capDriverGetVersion', cdRegister);
 S.RegisterDelphiFunction(@capDriverGetCaps, 'capDriverGetCaps', cdRegister);
 S.RegisterDelphiFunction(@capFileSetCaptureFile, 'capFileSetCaptureFile', cdRegister);
 S.RegisterDelphiFunction(@capFileGetCaptureFile, 'capFileGetCaptureFile', cdRegister);
 S.RegisterDelphiFunction(@capFileAlloc, 'capFileAlloc', cdRegister);
 S.RegisterDelphiFunction(@capFileSaveAs, 'capFileSaveAs', cdRegister);
 S.RegisterDelphiFunction(@capFileSetInfoChunk, 'capFileSetInfoChunk', cdRegister);
 S.RegisterDelphiFunction(@capFileSaveDIB, 'capFileSaveDIB', cdRegister);
 S.RegisterDelphiFunction(@capEditCopy, 'capEditCopy', cdRegister);
 S.RegisterDelphiFunction(@capSetAudioFormat, 'capSetAudioFormat', cdRegister);
 S.RegisterDelphiFunction(@capGetAudioFormat, 'capGetAudioFormat', cdRegister);
 S.RegisterDelphiFunction(@capGetAudioFormatSize, 'capGetAudioFormatSize', cdRegister);
 S.RegisterDelphiFunction(@capDlgVideoFormat, 'capDlgVideoFormat', cdRegister);
 S.RegisterDelphiFunction(@capDlgVideoSource, 'capDlgVideoSource', cdRegister);
 S.RegisterDelphiFunction(@capDlgVideoDisplay, 'capDlgVideoDisplay', cdRegister);
 S.RegisterDelphiFunction(@capDlgVideoCompression, 'capDlgVideoCompression', cdRegister);
 S.RegisterDelphiFunction(@capGetVideoFormat, 'capGetVideoFormat', cdRegister);
 S.RegisterDelphiFunction(@capGetVideoFormatSize, 'capGetVideoFormatSize', cdRegister);
 S.RegisterDelphiFunction(@capSetVideoFormat, 'capSetVideoFormat', cdRegister);
 S.RegisterDelphiFunction(@capPreview, 'capPreview', cdRegister);
 S.RegisterDelphiFunction(@capPreviewRate, 'capPreviewRate', cdRegister);
 S.RegisterDelphiFunction(@capOverlay, 'capOverlay', cdRegister);
 S.RegisterDelphiFunction(@capPreviewScale, 'capPreviewScale', cdRegister);
 S.RegisterDelphiFunction(@capGetStatus, 'capGetStatus', cdRegister);
 S.RegisterDelphiFunction(@capSetScrollPos, 'capSetScrollPos', cdRegister);
 S.RegisterDelphiFunction(@capGrabFrame, 'capGrabFrame', cdRegister);
 S.RegisterDelphiFunction(@capGrabFrameNoStop, 'capGrabFrameNoStop', cdRegister);
 S.RegisterDelphiFunction(@capCaptureSequence, 'capCaptureSequence', cdRegister);
 S.RegisterDelphiFunction(@capCaptureSequenceNoFile, 'capCaptureSequenceNoFile', cdRegister);
 S.RegisterDelphiFunction(@capCaptureStop, 'capCaptureStop', cdRegister);
 S.RegisterDelphiFunction(@capCaptureAbort, 'capCaptureAbort', cdRegister);
 S.RegisterDelphiFunction(@capCaptureSingleFrameOpen, 'capCaptureSingleFrameOpen', cdRegister);
 S.RegisterDelphiFunction(@capCaptureSingleFrameClose, 'capCaptureSingleFrameClose', cdRegister);
 S.RegisterDelphiFunction(@capCaptureSingleFrame, 'capCaptureSingleFrame', cdRegister);
 S.RegisterDelphiFunction(@capCaptureGetSetup, 'capCaptureGetSetup', cdRegister);
 S.RegisterDelphiFunction(@capCaptureSetSetup, 'capCaptureSetSetup', cdRegister);
 S.RegisterDelphiFunction(@capSetMCIDeviceName, 'capSetMCIDeviceName', cdRegister);
 S.RegisterDelphiFunction(@capGetMCIDeviceName, 'capGetMCIDeviceName', cdRegister);
 S.RegisterDelphiFunction(@capPaletteOpen, 'capPaletteOpen', cdRegister);
 S.RegisterDelphiFunction(@capPaletteSave, 'capPaletteSave', cdRegister);
 S.RegisterDelphiFunction(@capPalettePaste, 'capPalettePaste', cdRegister);
 S.RegisterDelphiFunction(@capPaletteAuto, 'capPaletteAuto', cdRegister);
 S.RegisterDelphiFunction(@capPaletteManual, 'capPaletteManual', cdRegister);
 S.RegisterDelphiFunction(@capCreateCaptureWindow, 'capCreateCaptureWindow', CdStdCall);
 S.RegisterDelphiFunction(@capGetDriverDescription, 'capGetDriverDescription', CdStdCall);
end;

 
 
{ TPSImport_AviCap }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AviCap.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AviCap(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AviCap.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_AviCap(ri);
  RIRegister_AviCap_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
