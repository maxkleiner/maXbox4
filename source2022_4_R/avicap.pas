unit AviCap;
 
interface
 
uses
  Windows, MMSystem, Messages;
 
const
        // ------------------------------------------------------------------
        //  Window Messages  WM_CAP... which can be sent to an AVICAP window
        // ------------------------------------------------------------------
 
        // Defines start of the message range
        WM_CAP_START                    = WM_USER;
 
        WM_CAP_GET_CAPSTREAMPTR         = (WM_CAP_START+  1);
        WM_CAP_SET_CALLBACK_ERROR       = (WM_CAP_START+  2);
        WM_CAP_SET_CALLBACK_STATUS      = (WM_CAP_START+  3);
        WM_CAP_SET_CALLBACK_YIELD       = (WM_CAP_START+  4);
        WM_CAP_SET_CALLBACK_FRAME       = (WM_CAP_START+  5);
        WM_CAP_SET_CALLBACK_VIDEOSTREAM = (WM_CAP_START+  6);
        WM_CAP_SET_CALLBACK_WAVESTREAM  = (WM_CAP_START+  7);
        WM_CAP_GET_USER_DATA            = (WM_CAP_START+  8);
        WM_CAP_SET_USER_DATA            = (WM_CAP_START+  9);
 
        WM_CAP_DRIVER_CONNECT           = (WM_CAP_START+  10);
        WM_CAP_DRIVER_DISCONNECT        = (WM_CAP_START+  11);
        WM_CAP_DRIVER_GET_NAME          = (WM_CAP_START+  12);
        WM_CAP_DRIVER_GET_VERSION       = (WM_CAP_START+  13);
        WM_CAP_DRIVER_GET_CAPS          = (WM_CAP_START+  14);
 
        WM_CAP_FILE_SET_CAPTURE_FILE    = (WM_CAP_START+  20);
        WM_CAP_FILE_GET_CAPTURE_FILE    = (WM_CAP_START+  21);
        WM_CAP_FILE_ALLOCATE            = (WM_CAP_START+  22);
        WM_CAP_FILE_SAVEAS              = (WM_CAP_START+  23);
        WM_CAP_FILE_SET_INFOCHUNK       = (WM_CAP_START+  24);
        WM_CAP_FILE_SAVEDIB             = (WM_CAP_START+  25);
 
        WM_CAP_EDIT_COPY                = (WM_CAP_START+  30);
 
        WM_CAP_SET_AUDIOFORMAT          = (WM_CAP_START+  35);
        WM_CAP_GET_AUDIOFORMAT          = (WM_CAP_START+  36);
 
        WM_CAP_DLG_VIDEOFORMAT          = (WM_CAP_START+  41);
        WM_CAP_DLG_VIDEOSOURCE          = (WM_CAP_START+  42);
        WM_CAP_DLG_VIDEODISPLAY         = (WM_CAP_START+  43);
        WM_CAP_GET_VIDEOFORMAT          = (WM_CAP_START+  44);
        WM_CAP_SET_VIDEOFORMAT          = (WM_CAP_START+  45);
        WM_CAP_DLG_VIDEOCOMPRESSION     = (WM_CAP_START+  46);
 
        WM_CAP_SET_PREVIEW              = (WM_CAP_START+  50);
        WM_CAP_SET_OVERLAY              = (WM_CAP_START+  51);
        WM_CAP_SET_PREVIEWRATE          = (WM_CAP_START+  52);
        WM_CAP_SET_SCALE                = (WM_CAP_START+  53);
        WM_CAP_GET_STATUS               = (WM_CAP_START+  54);
        WM_CAP_SET_SCROLL               = (WM_CAP_START+  55);
 
        WM_CAP_GRAB_FRAME               = (WM_CAP_START+  60);
        WM_CAP_GRAB_FRAME_NOSTOP        = (WM_CAP_START+  61);
 
        WM_CAP_SEQUENCE                 = (WM_CAP_START+  62);
        WM_CAP_SEQUENCE_NOFILE          = (WM_CAP_START+  63);
        WM_CAP_SET_SEQUENCE_SETUP       = (WM_CAP_START+  64);
        WM_CAP_GET_SEQUENCE_SETUP       = (WM_CAP_START+  65);
        WM_CAP_SET_MCI_DEVICE           = (WM_CAP_START+  66);
        WM_CAP_GET_MCI_DEVICE           = (WM_CAP_START+  67);
        WM_CAP_STOP                     = (WM_CAP_START+  68);
        WM_CAP_ABORT                    = (WM_CAP_START+  69);
 
        WM_CAP_SINGLE_FRAME_OPEN        = (WM_CAP_START+  70);
        WM_CAP_SINGLE_FRAME_CLOSE       = (WM_CAP_START+  71);
        WM_CAP_SINGLE_FRAME             = (WM_CAP_START+  72);
 
        WM_CAP_PAL_OPEN                 = (WM_CAP_START+  80);
        WM_CAP_PAL_SAVE                 = (WM_CAP_START+  81);
        WM_CAP_PAL_PASTE                = (WM_CAP_START+  82);
        WM_CAP_PAL_AUTOCREATE           = (WM_CAP_START+  83);
        WM_CAP_PAL_MANUALCREATE         = (WM_CAP_START+  84);
 
                // Following added post VFW 1.1
        WM_CAP_SET_CALLBACK_CAPCONTROL  = (WM_CAP_START+  85);
 
        // Defines end of the message range
        WM_CAP_END                      = WM_CAP_SET_CALLBACK_CAPCONTROL;
 
        // ------------------------------------------------------------------
        //  Message crackers for above
        // ------------------------------------------------------------------
function capSetCallbackOnError (hwnd : THandle; fpProc:LongInt):LongInt;
function capSetCallbackOnStatus(hwnd : THandle; fpProc:LongInt):LongInt;
function capSetCallbackOnYield (hwnd : THandle; fpProc:LongInt):LongInt;
function capSetCallbackOnFrame (hwnd : THandle; fpProc:LongInt):LongInt;
 
function capSetCallbackOnVideoStream(hwnd:THandle; fpProc:LongInt):LongInt;
function capSetCallbackOnWaveStream (hwnd:THandle; fpProc:LongInt):LongInt;
function capSetCallbackOnCapControl (hwnd:THandle; fpProc:LongInt):LongInt;
function capSetUserData(hwnd:THandle; lUser:LongInt):LongInt;
function capGetUserData(hwnd:THandle):LongInt;
function capDriverConnect(hwnd:THandle; I: Word) : LongInt;
 
function capDriverDisconnect(hwnd:THandle):LongInt;
function capDriverGetName(hwnd:THandle; szName:LongInt; wSize:Word):LongInt;
function capDriverGetVersion(hwnd:THandle; szVer:LongInt; wSize:Word):LongInt;
function capDriverGetCaps(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
 
function capFileSetCaptureFile(hwnd:THandle; szName:LongInt):LongInt;
function capFileGetCaptureFile(hwnd:THandle; szName:LongInt; wSize:Word):LongInt;
function capFileAlloc(hwnd:THandle; dwSize:LongInt):LongInt;
function capFileSaveAs(hwnd:THandle; szName:LongInt):LongInt;
function capFileSetInfoChunk(hwnd:THandle; lpInfoChunk:LongInt):LongInt;
function capFileSaveDIB(hwnd:THandle; szName:LongInt):LongInt;
 
function capEditCopy(hwnd : THandle):LongInt;
 
function capSetAudioFormat(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
function capGetAudioFormat(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
function capGetAudioFormatSize(hwnd:THandle):LongInt;
 
function capDlgVideoFormat(hwnd:THandle):LongInt;
function capDlgVideoSource(hwnd:THandle):LongInt;
function capDlgVideoDisplay(hwnd:THandle):LongInt;
function capDlgVideoCompression(hwnd:THandle):LongInt;
 
function capGetVideoFormat(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
function capGetVideoFormatSize(hwnd:THandle):LongInt;
function capSetVideoFormat(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
 
function capPreview(hwnd:THandle; f:Word):LongInt;
function capPreviewRate(hwnd:THandle; wMS:Word):LongInt;
function capOverlay(hwnd:THandle; f:Word):LongInt;
function capPreviewScale(hwnd:THandle; f:Word):LongInt;
function capGetStatus(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
function capSetScrollPos(hwnd:THandle; lpP:LongInt):LongInt;
 
function capGrabFrame(hwnd:THandle):LongInt;
function capGrabFrameNoStop(hwnd:THandle):LongInt;
 
function capCaptureSequence(hwnd:THandle):LongInt;
function capCaptureSequenceNoFile(hwnd:THandle):LongInt;
function capCaptureStop(hwnd:THandle):LongInt;
function capCaptureAbort(hwnd:THandle):LongInt;
 
function capCaptureSingleFrameOpen(hwnd:THandle):LongInt;
function capCaptureSingleFrameClose(hwnd:THandle):LongInt;
function capCaptureSingleFrame(hwnd:THandle):LongInt;
 
function capCaptureGetSetup(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
function capCaptureSetSetup(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
 
function capSetMCIDeviceName(hwnd:THandle; szName:LongInt):LongInt;
function capGetMCIDeviceName(hwnd:THandle; szName:LongInt; wSize:Word):LongInt;
 
function capPaletteOpen(hwnd:THandle; szName:LongInt):LongInt;
function capPaletteSave(hwnd:THandle; szName:LongInt):LongInt;
function capPalettePaste(hwnd:THandle):LongInt;
function capPaletteAuto(hwnd:THandle; iFrames:Word; iColors:LongInt):LongInt;
function capPaletteManual(hwnd:THandle; fGrab:Word; iColors:LongInt):LongInt;
 
        // ------------------------------------------------------------------
        //  Structures
        // ------------------------------------------------------------------
type
        PCapDriverCaps = ^TCapDriverCaps;
        TCapDriverCaps = record
    wDeviceIndex            :WORD;           // Driver index in system.ini
    fHasOverlay             :BOOL;           // Can device overlay?
    fHasDlgVideoSource      :BOOL;           // Has Video source dlg?
    fHasDlgVideoFormat      :BOOL;           // Has Format dlg?
    fHasDlgVideoDisplay     :BOOL;           // Has External out dlg?
    fCaptureInitialized     :BOOL;           // Driver ready to capture?
    fDriverSuppliesPalettes :BOOL;           // Can driver make palettes?
    hVideoIn                :THANDLE;        // Driver In channel
    hVideoOut               :THANDLE;        // Driver Out channel
    hVideoExtIn             :THANDLE;        // Driver Ext In channel
    hVideoExtOut            :THANDLE;        // Driver Ext Out channel
        end;
 
        PCapStatus = ^TCapStatus;
        TCapStatus = packed record
    uiImageWidth                :UINT;      // Width of the image
                uiImageHeight               :UINT;      // Height of the image
    fLiveWindow                 :BOOL;      // Now Previewing video?
    fOverlayWindow              :BOOL;      // Now Overlaying video?
    fScale                      :BOOL;      // Scale image to client?
    ptScroll                    :TPOINT;    // Scroll position
    fUsingDefaultPalette        :BOOL;      // Using default driver palette?
    fAudioHardware              :BOOL;      // Audio hardware present?
    fCapFileExists              :BOOL;      // Does capture file exist?
    dwCurrentVideoFrame         :DWORD;     // # of video frames cap'td
    dwCurrentVideoFramesDropped :DWORD;     // # of video frames dropped
    dwCurrentWaveSamples        :DWORD;     // # of wave samples cap'td
    dwCurrentTimeElapsedMS      :DWORD;     // Elapsed capture duration
    hPalCurrent                 :HPALETTE;  // Current palette in use
    fCapturingNow               :BOOL;      // Capture in progress?
    dwReturn                    :DWORD;     // Error value after any operation
    wNumVideoAllocated          :WORD;      // Actual number of video buffers
    wNumAudioAllocated          :WORD;      // Actual number of audio buffers
        end;
 
        PCaptureParms = ^TCaptureParms;
        TCaptureParms = record                    // Default values in parenthesis
        dwRequestMicroSecPerFrame :DWORD;    // Requested capture rate
    fMakeUserHitOKToCapture   :BOOL;     // Show "Hit OK to cap" dlg?
    wPercentDropForError      :WORD;     // Give error msg if > (10%)
    fYield                    :BOOL;     // Capture via background task?
    dwIndexSize               :DWORD;    // Max index size in frames (32K)
    wChunkGranularity         :WORD;     // Junk chunk granularity (2K)
    fUsingDOSMemory           :BOOL;     // Use DOS buffers?
    wNumVideoRequested        :WORD;     // # video buffers, If 0, autocalc
    fCaptureAudio             :BOOL;     // Capture audio?
    wNumAudioRequested        :WORD;     // # audio buffers, If 0, autocalc
    vKeyAbort                 :WORD;     // Virtual key causing abort
    fAbortLeftMouse           :BOOL;     // Abort on left mouse?
    fAbortRightMouse          :BOOL;     // Abort on right mouse?
    fLimitEnabled             :BOOL;     // Use wTimeLimit?
    wTimeLimit                :WORD;     // Seconds to capture
    fMCIControl               :BOOL;     // Use MCI video source?
    fStepMCIDevice            :BOOL;     // Step MCI device?
    dwMCIStartTime            :DWORD;    // Time to start in MS
    dwMCIStopTime             :DWORD;    // Time to stop in MS
    fStepCaptureAt2x          :BOOL;     // Perform spatial averaging 2x
    wStepCaptureAverageFrames :WORD;     // Temporal average n Frames
    dwAudioBufferSize         :DWORD;    // Size of audio bufs (0 = default)
    fDisableWriteCache        :BOOL;     // Attempt to disable write cache
                AVStreamMaster            :WORD;     // Indicates whether the audio stream
                                         //     controls the clock when writing an AVI file.
        end;
 
        PCapInfoChunk = ^TCapInfoChunk;
        TCapInfoChunk = record
    fccInfoID :FOURCC;          // Chunk ID, "ICOP" for copyright
    lpData    :LongInt;         // pointer to data
    cbData    :LongInt;   // size of lpData
        end;
 
        // ------------------------------------------------------------------
        //  Callback Definitions
        // ------------------------------------------------------------------
type
        TCAPSTATUSCALLBACK  = function(hWnd:HWND; nID:Integer; lpsz:LongInt):LongInt; stdcall;
        TCAPYIELDCALLBACK   = function(hWnd:HWND):LongInt; stdcall;
        TCAPERRORCALLBACK   = function(hWnd:HWND; nID:Integer; lpsz:LongInt):LongInt; stdcall;
        TCAPVIDEOCALLBACK   = function(hWnd:HWND; lpVHdr:LongInt):LongInt; stdcall;
        TCAPWAVECALLBACK    = function(hWnd:HWND; lpWHdr:LongInt):LongInt; stdcall;
        TCAPCONTROLCALLBACK = function(hWnd:HWND; nState:Integer):LongInt; stdcall;
 
        // ------------------------------------------------------------------
        //  CapControlCallback states
        // ------------------------------------------------------------------
Const
        CONTROLCALLBACK_PREROLL         = 1;    // Waiting to start capture
        CONTROLCALLBACK_CAPTURING       = 2;    // Now capturing
 
        // ------------------------------------------------------------------
        //  The only exported functions from AVICAP.DLL
        // ------------------------------------------------------------------
  function capCreateCaptureWindow (
                              lpszWindowName  : PChar;
                            dwStyle         : DWord;
                          x, y            : Integer;
                          nWidth, nHeight : Integer;
                        hwndParent      : THandle;
                          nID             : Integer ) : THandle; stdcall;
 
        function capGetDriverDescription (
                                                wDriverIndex : DWord;
                              lpszName     : PChar;
                          cbName       : Integer;
                            lpszVer      : PChar;
                          cbVer        : Integer ) : Boolean; stdcall;
 
        // ------------------------------------------------------------------
        // New Information chunk IDs
        // ------------------------------------------------------------------
(*
        infotypeDIGITIZATION_TIME  = mmioStringToFOURCC(PChar('IDIT'), MMIO_TOUPPER);
        infotypeSMPTE_TIME         = mmioStringToFOURCC(PChar('ISMP'), MMIO_TOUPPER);
*)
 
        // ------------------------------------------------------------------
        // String IDs from status and error callbacks
        // ------------------------------------------------------------------
Const
        IDS_CAP_BEGIN               = 300; (* "Capture Start" *)
        IDS_CAP_END                 = 301; (* "Capture End" *)
 
        IDS_CAP_INFO                = 401; (* "%s" *)
        IDS_CAP_OUTOFMEM            = 402; (* "Out of memory" *)
        IDS_CAP_FILEEXISTS          = 403; (* "File '%s' exists -- overwrite it?" *)
        IDS_CAP_ERRORPALOPEN        = 404; (* "Error opening palette '%s'" *)
        IDS_CAP_ERRORPALSAVE        = 405; (* "Error saving palette '%s'" *)
        IDS_CAP_ERRORDIBSAVE        = 406; (* "Error saving frame '%s'" *)
        IDS_CAP_DEFAVIEXT           = 407; (* "avi" *)
        IDS_CAP_DEFPALEXT           = 408; (* "pal" *)
        IDS_CAP_CANTOPEN            = 409; (* "Cannot open '%s'" *)
        IDS_CAP_SEQ_MSGSTART        = 410; (* "Select OK to start capture\nof video sequence\nto %s." *)
        IDS_CAP_SEQ_MSGSTOP         = 411; (* "Hit ESCAPE or click to end capture" *)
 
        IDS_CAP_VIDEDITERR          = 412; (* "An error occurred while trying to run VidEdit." *)
        IDS_CAP_READONLYFILE        = 413; (* "The file '%s' is a read-only file." *)
        IDS_CAP_WRITEERROR          = 414; (* "Unable to write to file '%s'.\nDisk may be full." *)
        IDS_CAP_NODISKSPACE         = 415; (* "There is no space to create a capture file on the specified device." *)
        IDS_CAP_SETFILESIZE         = 416; (* "Set File Size" *)
        IDS_CAP_SAVEASPERCENT       = 417; (* "SaveAs: %2ld%%  Hit Escape to abort." *)
 
        IDS_CAP_DRIVER_ERROR        = 418; (* Driver specific error message *)
 
        IDS_CAP_WAVE_OPEN_ERROR     = 419; (* "Error: Cannot open the wave input device.\nCheck sample size, frequency, and channels." *)
        IDS_CAP_WAVE_ALLOC_ERROR    = 420; (* "Error: Out of memory for wave buffers." *)
        IDS_CAP_WAVE_PREPARE_ERROR  = 421; (* "Error: Cannot prepare wave buffers." *)
        IDS_CAP_WAVE_ADD_ERROR      = 422; (* "Error: Cannot add wave buffers." *)
        IDS_CAP_WAVE_SIZE_ERROR     = 423; (* "Error: Bad wave size." *)
 
        IDS_CAP_VIDEO_OPEN_ERROR    = 424; (* "Error: Cannot open the video input device." *)
        IDS_CAP_VIDEO_ALLOC_ERROR   = 425; (* "Error: Out of memory for video buffers." *)
        IDS_CAP_VIDEO_PREPARE_ERROR = 426; (* "Error: Cannot prepare video buffers." *)
        IDS_CAP_VIDEO_ADD_ERROR     = 427; (* "Error: Cannot add video buffers." *)
        IDS_CAP_VIDEO_SIZE_ERROR    = 428; (* "Error: Bad video size." *)
 
        IDS_CAP_FILE_OPEN_ERROR     = 429; (* "Error: Cannot open capture file." *)
        IDS_CAP_FILE_WRITE_ERROR    = 430; (* "Error: Cannot write to capture file.  Disk may be full." *)
        IDS_CAP_RECORDING_ERROR     = 431; (* "Error: Cannot write to capture file.  Data rate too high or disk full." *)
        IDS_CAP_RECORDING_ERROR2    = 432; (* "Error while recording" *)
        IDS_CAP_AVI_INIT_ERROR      = 433; (* "Error: Unable to initialize for capture." *)
        IDS_CAP_NO_FRAME_CAP_ERROR  = 434; (* "Warning: No frames captured.\nConfirm that vertical sync interrupts\nare configured and enabled." *)
        IDS_CAP_NO_PALETTE_WARN     = 435; (* "Warning: Using default palette." *)
        IDS_CAP_MCI_CONTROL_ERROR   = 436; (* "Error: Unable to access MCI device." *)
        IDS_CAP_MCI_CANT_STEP_ERROR = 437; (* "Error: Unable to step MCI device." *)
        IDS_CAP_NO_AUDIO_CAP_ERROR  = 438; (* "Error: No audio data captured.\nCheck audio card settings." *)
        IDS_CAP_AVI_DRAWDIB_ERROR   = 439; (* "Error: Unable to draw this data format." *)
        IDS_CAP_COMPRESSOR_ERROR    = 440; (* "Error: Unable to initialize compressor." *)
        IDS_CAP_AUDIO_DROP_ERROR    = 441; (* "Error: Audio data was lost during capture, reduce capture rate." *)
 
  (* status string IDs *)
        IDS_CAP_STAT_LIVE_MODE      = 500; (* "Live window" *)
        IDS_CAP_STAT_OVERLAY_MODE   = 501; (* "Overlay window" *)
        IDS_CAP_STAT_CAP_INIT       = 502; (* "Setting up for capture - Please wait" *)
        IDS_CAP_STAT_CAP_FINI       = 503; (* "Finished capture, now writing frame %ld" *)
        IDS_CAP_STAT_PALETTE_BUILD  = 504; (* "Building palette map" *)
        IDS_CAP_STAT_OPTPAL_BUILD   = 505; (* "Computing optimal palette" *)
        IDS_CAP_STAT_I_FRAMES       = 506; (* "%d frames" *)
        IDS_CAP_STAT_L_FRAMES       = 507; (* "%ld frames" *)
        IDS_CAP_STAT_CAP_L_FRAMES   = 508; (* "Captured %ld frames" *)
        IDS_CAP_STAT_CAP_AUDIO      = 509; (* "Capturing audio" *)
        IDS_CAP_STAT_VIDEOCURRENT   = 510; (* "Captured %ld frames (%ld dropped) %d.%03d sec." *)
        IDS_CAP_STAT_VIDEOAUDIO     = 511; (* "Captured %d.%03d sec.  %ld frames (%ld dropped) (%d.%03d fps).  %ld audio bytes (%d,%03d sps)" *)
        IDS_CAP_STAT_VIDEOONLY      = 512; (* "Captured %d.%03d sec.  %ld frames (%ld dropped) (%d.%03d fps)" *)
        IDS_CAP_STAT_FRAMESDROPPED  = 513; (* "Dropped %ld of %ld frames (%d.%02d%%) during capture." *)
 
const
  AVICAP32 = 'AVICAP32.dll';
 
implementation
 
(* Externals from AVICAP.DLL *)
function capGetDriverDescription; external AVICAP32 name 'capGetDriverDescriptionA';
function capCreateCaptureWindow;  external AVICAP32 name 'capCreateCaptureWindowA';
 
 
(* Message crackers for above *)
function capSetCallbackOnError(hwnd : THandle; fpProc:LongInt) : LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_CALLBACK_ERROR, 0, fpProc);
end;
 
function capSetCallbackOnStatus(hwnd : THandle; fpProc:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_CALLBACK_STATUS, 0, fpProc);
end;
 
function capSetCallbackOnYield (hwnd : THandle; fpProc:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_CALLBACK_YIELD, 0, fpProc);
end;
 
function capSetCallbackOnFrame (hwnd : THandle; fpProc:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_CALLBACK_FRAME, 0, fpProc);
end;
 
function capSetCallbackOnVideoStream(hwnd:THandle; fpProc:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_CALLBACK_VIDEOSTREAM, 0, fpProc);
end;
 
function capSetCallbackOnWaveStream (hwnd:THandle; fpProc:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_CALLBACK_WAVESTREAM, 0, fpProc);
end;
 
function capSetCallbackOnCapControl (hwnd:THandle; fpProc:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_CALLBACK_CAPCONTROL, 0, fpProc);
end;
 
function capSetUserData(hwnd:THandle; lUser:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_USER_DATA, 0, lUser);
end;
 
function capGetUserData(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_GET_USER_DATA, 0, 0);
end;
 
function capDriverConnect(hwnd:THandle; I: Word) : LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_DRIVER_CONNECT, I, 0);
end;
 
function capDriverDisconnect(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_DRIVER_DISCONNECT, 0, 0);
end;
 
function capDriverGetName(hwnd:THandle; szName:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_DRIVER_GET_NAME, wSize, szName);
end;
 
function capDriverGetVersion(hwnd:THandle; szVer:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_DRIVER_GET_VERSION, wSize, szVer);
end;
 
function capDriverGetCaps(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_DRIVER_GET_CAPS, wSize, s);
end;
 
function capFileSetCaptureFile(hwnd:THandle; szName:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_FILE_SET_CAPTURE_FILE, 0, szName);
end;
 
function capFileGetCaptureFile(hwnd:THandle; szName:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_FILE_GET_CAPTURE_FILE, wSize, szName);
end;
 
function capFileAlloc(hwnd:THandle; dwSize:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_FILE_ALLOCATE, 0, dwSize);
end;
 
function capFileSaveAs(hwnd:THandle; szName:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_FILE_SAVEAS, 0, szName);
end;
 
function capFileSetInfoChunk(hwnd:THandle; lpInfoChunk:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_FILE_SET_INFOCHUNK, 0, lpInfoChunk);
end;
 
function capFileSaveDIB(hwnd:THandle; szName:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_FILE_SAVEDIB, 0, szName);
end;
 
function capEditCopy(hwnd : THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_EDIT_COPY, 0, 0);
end;
 
function capSetAudioFormat(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_AUDIOFORMAT, wSize, s);
end;
 
function capGetAudioFormat(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_GET_AUDIOFORMAT, wSize, s);
end;
 
function capGetAudioFormatSize(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_GET_AUDIOFORMAT, 0, 0);
end;
 
function capDlgVideoFormat(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_DLG_VIDEOFORMAT, 0, 0);
end;
 
function capDlgVideoSource(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_DLG_VIDEOSOURCE, 0, 0);
end;
 
function capDlgVideoDisplay(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_DLG_VIDEODISPLAY, 0, 0);
end;
 
function capDlgVideoCompression(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_DLG_VIDEOCOMPRESSION, 0, 0);
end;
 
function capGetVideoFormat(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_GET_VIDEOFORMAT, wSize, s);
end;
 
function capGetVideoFormatSize(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_GET_VIDEOFORMAT, 0, 0);
end;
 
function capSetVideoFormat(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_VIDEOFORMAT, wSize, s);
end;
 
function capPreview(hwnd:THandle; f:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_PREVIEW, f, 0);
end;
 
function capPreviewRate(hwnd:THandle; wMS:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_PREVIEWRATE, wMS, 0);
end;
 
function capOverlay(hwnd:THandle; f:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_OVERLAY, f, 0);
end;
 
function capPreviewScale(hwnd:THandle; f:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_SCALE, f, 0);
end;
 
function capGetStatus(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_GET_STATUS, wSize, s);
end;
 
function capSetScrollPos(hwnd:THandle; lpP:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_SCROLL, 0, lpP);
end;
 
function capGrabFrame(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_GRAB_FRAME, 0, 0);
end;
 
function capGrabFrameNoStop(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_GRAB_FRAME_NOSTOP, 0, 0);
end;
 
function capCaptureSequence(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SEQUENCE, 0, 0);
end;
 
function capCaptureSequenceNoFile(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SEQUENCE_NOFILE, 0, 0);
end;
 
function capCaptureStop(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_STOP, 0, 0);
end;
 
function capCaptureAbort(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_ABORT, 0, 0);
end;
 
function capCaptureSingleFrameOpen(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SINGLE_FRAME_OPEN, 0, 0);
end;
 
function capCaptureSingleFrameClose(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SINGLE_FRAME_CLOSE, 0, 0);
end;
 
function capCaptureSingleFrame(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SINGLE_FRAME, 0, 0);
end;
 
function capCaptureGetSetup(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_GET_SEQUENCE_SETUP, wSize, s);
end;
 
function capCaptureSetSetup(hwnd:THandle; s:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_SEQUENCE_SETUP, wSize, s);
end;
 
function capSetMCIDeviceName(hwnd:THandle; szName:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_SET_MCI_DEVICE, 0, szName);
end;
 
function capGetMCIDeviceName(hwnd:THandle; szName:LongInt; wSize:Word):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_GET_MCI_DEVICE, wSize, szName);
end;
 
function capPaletteOpen(hwnd:THandle; szName:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_PAL_OPEN, 0, szName);
end;
 
function capPaletteSave(hwnd:THandle; szName:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_PAL_SAVE, 0, szName);
end;
 
function capPalettePaste(hwnd:THandle):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_PAL_PASTE, 0, 0);
end;
 
function capPaletteAuto(hwnd:THandle; iFrames:Word; iColors:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_PAL_AUTOCREATE, iFrames, iColors);
end;
 
function capPaletteManual(hwnd:THandle; fGrab:Word; iColors:LongInt):LongInt;
begin
        Result := SendMessage(hwnd, WM_CAP_PAL_MANUALCREATE, fGrab, iColors);
end;
 
 
end.
 

----code_cleared_checked_clean----