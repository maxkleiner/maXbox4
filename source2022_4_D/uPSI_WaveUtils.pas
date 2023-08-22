unit uPSI_WaveUtils;
{
  instead of mmsystem
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
  TPSImport_WaveUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_WaveUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_WaveUtils_Routines(S: TPSExec);
procedure RIRegister_WaveUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,mmSystem
  ,WaveUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WaveUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_WaveUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMS2StrFormat', '( msHMSh, msHMS, msMSh, msMS, msSh, msS, msAh,msA )');
  CL.AddTypeS('TPCMChannel', '( cMono, cStereo )');
  CL.AddTypeS('TPCMSamplesPerSec', '( ss8000Hz, ss11025Hz, ss22050Hz, ss44100Hz, ss48000Hz )');
  CL.AddTypeS('TPCMBitsPerSample', '( bs8Bit, bs16Bit )');
  CL.AddTypeS('TPCMFormat', '( nonePCM, Mono8Bit8000Hz, Stereo8bit8000Hz, Mono1'
   +'6bit8000Hz, Stereo16bit8000Hz, Mono8bit11025Hz, Stereo8bit11025Hz, Mono16b'
   +'it11025Hz, Stereo16bit11025Hz, Mono8bit22050Hz, Stereo8bit22050Hz, Mono16b'
   +'it22050Hz, Stereo16bit22050Hz, Mono8bit44100Hz, Stereo8bit44100Hz, Mono16b'
   +'it44100Hz, Stereo16bit44100Hz, Mono8bit48000Hz, Stereo8bit48000Hz, Mono16b'
   +'it48000Hz, Stereo16bit48000Hz )');

 CL.AddTypeS('PWaveFormatEx', 'record wFormatTag : word; nChannels: word; nSamplesPerSec: DWORD; '
   +'nAvgBytesPerSec: DWORD; nBlockAlign: Word; wBitsPerSample: Word;  ecbSiz: Word; end');

   CL.AddTypeS('tWaveFormatEx', 'PWaveFormatEx');
   CL.AddTypeS('HMMIO', 'Integer');

 CL.AddTypeS('TWaveFormat', 'record wFormatTag : word; nChannels: word; nSamplesPerSec: DWORD; '
   +'nAvgBytesPerSec: DWORD; nBlockAlign: Word; end');

(*    waveformat_tag = packed record
    wFormatTag: Word;         { format type }
    nChannels: Word;          { number of channels (i.e. mono, stereo, etc.) }
    nSamplesPerSec: DWORD;  { sample rate }
    nAvgBytesPerSec: DWORD; { for buffer estimation }
    nBlockAlign: Word;      { block size of data }
  end;
  TWaveFormat = waveformat_tag;
  *)

   //  HMMIO = Integer;      { a handle to an open file }


 (*    PWaveFormatEx = ^TWaveFormatEx;
  tWAVEFORMATEX = packed record
     //{$EXTERNALSYM tWAVEFORMATEX}
     wFormatTag: Word;         { format type }
    nChannels: Word;          { number of channels (i.e. mono, stereo, etc.) }
    nSamplesPerSec: DWORD;  { sample rate }
    nAvgBytesPerSec: DWORD; { for buffer estimation }
    nBlockAlign: Word;      { block size of data }
    wBitsPerSample: Word;   { number of bits per sample of mono data }
    ecbSiz: Word;           { the count in bytes of the size of }
  end;*)

  CL.AddTypeS('TMMCKInfo', 'record ckid: dword; chksize: dword; fcctype: DWORD; '
   +'dwDataOffset: DWORD; dwFlags: DWord; end');

  (* _MMCKINFO = record
    ckid: DWord;           { chunk ID }
    cksize: DWORD;         { chunk size }
    fccType: Dword;        { form type or list type }
    dwDataOffset: DWORD;   { offset of data portion of chunk }
    dwFlags: DWORD;        { flags used by MMIO functions }
  end; *)


  CL.AddTypeS('TWaveDeviceFormats', 'set of TPCMFormat');
  CL.AddTypeS('TWaveOutDeviceSupport', '( dsVolume, dsStereoVolume, dsPitch, ds'
   +'PlaybackRate, dsPosition, dsAsynchronize, dsDirectSound )');
  CL.AddTypeS('TWaveOutDeviceSupports', 'set of TWaveOutDeviceSupport');
  CL.AddTypeS('TWaveOutOption', '( woSetVolume, woSetPitch, woSetPlaybackRate )');
  CL.AddTypeS('TWaveOutOptions', 'set of TWaveOutOption');
  CL.AddTypeS('TStreamOwnership2', '( soReference, soOwned )');
  CL.AddTypeS('TWaveStreamState', '( wssReady, wssReading, wssWriting, wssWritingEx )');
 // CL.AddTypeS('PRawWave', '^TRawWave // will not work');
  CL.AddTypeS('TRawWave', 'record pData : TObject; dwSize : DWORD; end');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EWaveAudioError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EWaveAudioSysError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EWaveAudioInvalidOperation');
  CL.AddTypeS('TWaveAudioEvent', 'Procedure ( Sender : TObject)');
  CL.AddTypeS('TWaveAudioGetFormatEvent', 'Procedure ( Sender : TObject; var pW'
   +'aveFormat : PWaveFormatEx; var FreeIt : Boolean)');
  CL.AddTypeS('TWaveAudioGetDataEvent', 'Function ( Sender : TObject; const Buf'
   +'fer : TObject; BufferSize : DWORD; var NumLoops : DWORD) : DWORD');
  CL.AddTypeS('TWaveAudioGetDataPtrEvent', 'Function ( Sender : TObject; var Bu'
   +'ffer : TObject; var NumLoops : DWORD; var FreeIt : Boolean) : DWORD');
  CL.AddTypeS('TWaveAudioDataReadyEvent', 'Procedure ( Sender : TObject; const '
   +'Buffer : TObject; BufferSize : DWORD; var FreeIt : Boolean)');
  CL.AddTypeS('TWaveAudioLevelEvent', 'Procedure ( Sender : TObject; Level : Integer)');
  CL.AddTypeS('TWaveAudioFilterEvent', 'Procedure ( Sender : TObject; const Buf'
   +'fer : TObject; BufferSize : DWORD)');
 CL.AddDelphiFunction('Function GetWaveAudioInfo( mmIO : HMMIO; var pWaveFormat : PWaveFormatEx; var DataSize, DataOffset : DWORD) : Boolean');
 CL.AddDelphiFunction('Function CreateWaveAudio( mmIO : HMMIO; const pWaveFormat : PWaveFormatEx; var ckRIFF, ckData : TMMCKInfo) : Boolean');
 CL.AddDelphiFunction('Procedure CloseWaveAudio( mmIO : HMMIO; var ckRIFF, ckData : TMMCKInfo)');
 CL.AddDelphiFunction('Function GetStreamWaveAudioInfo( Stream : TStream; var pWaveFormat : PWaveFormatEx; var DataSize, DataOffset : DWORD) : Boolean');
 CL.AddDelphiFunction('Function CreateStreamWaveAudio( Stream : TStream; const pWaveFormat : PWaveFormatEx; var ckRIFF, ckData : TMMCKInfo) : HMMIO');
 CL.AddDelphiFunction('Function OpenStreamWaveAudio( Stream : TStream) : HMMIO');
 CL.AddDelphiFunction('Function CalcWaveBufferSize( const pWaveFormat : PWaveFormatEx; Duration : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GetAudioFormat( FormatTag : Word) : String');
 CL.AddDelphiFunction('Function GetWaveAudioFormat( const pWaveFormat : PWaveFormatEx) : String');
 CL.AddDelphiFunction('Function GetWaveAudioLength( const pWaveFormat : PWaveFormatEx; DataSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GetWaveAudioBitRate( const pWaveFormat : PWaveFormatEx) : DWORD');
 CL.AddDelphiFunction('Function GetWaveAudioPeakLevel( const Data : TObject; DataSize : DWORD; const pWaveFormat : PWaveFormatEx) : Integer');
 CL.AddDelphiFunction('Function InvertWaveAudio( const Data : TObject; DataSize : DWORD; const pWaveFormat : PWaveFormatEx) : Boolean');
 CL.AddDelphiFunction('Function SilenceWaveAudio( const Data : TObject; DataSize : DWORD; const pWaveFormat : PWaveFormatEx) : Boolean');
 CL.AddDelphiFunction('Function ChangeWaveAudioVolume( const Data : TObject; DataSize : DWORD; const pWaveFormat : PWaveFormatEx; Percent : Integer) : Boolean');
 CL.AddDelphiFunction('Function MixWaveAudio( const RawWaves : TRawWave; Count : Integer; const pWaveFormat : PWaveFormatEx; Buffer : TObject; BufferSize : DWORD) : Boolean');
 CL.AddDelphiFunction('Function ConvertWaveFormat( const srcFormat : PWaveFormatEx; srcData : TObject; srcDataSize : DWORD; const dstFormat : PWaveFormatEx; var dstData : TObject; var dstDataSize : DWORD) : Boolean');
 CL.AddDelphiFunction('Procedure SetPCMAudioFormat( const pWaveFormat : PWaveFormatEx; Channels : TPCMChannel; SamplesPerSec : TPCMSamplesPerSec; BitsPerSample : TPCMBitsPerSample)');
 CL.AddDelphiFunction('Procedure SetPCMAudioFormatS( const pWaveFormat : PWaveFormatEx; PCMFormat : TPCMFormat)');
 CL.AddDelphiFunction('Function GetPCMAudioFormat( const pWaveFormat : PWaveFormatEx) : TPCMFormat');
 CL.AddDelphiFunction('Function GetWaveDataPositionOffset( const pWaveFormat : PWaveFormatEx; Position : DWORD) : DWORD');
 CL.AddDelphiFunction('Function MS2Str( Milliseconds : DWORD; Fmt : TMS2StrFormat) : String');
 CL.AddDelphiFunction('Function WaitForSyncObject( SyncObject : THandle; Timeout : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function mmioStreamProc( lpmmIOInfo : PMMIOInfo; uMsg, lParam1, lParam2 : DWORD) : LRESULT');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_WaveUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetWaveAudioInfo, 'GetWaveAudioInfo', cdRegister);
 S.RegisterDelphiFunction(@CreateWaveAudio, 'CreateWaveAudio', cdRegister);
 S.RegisterDelphiFunction(@CloseWaveAudio, 'CloseWaveAudio', cdRegister);
 S.RegisterDelphiFunction(@GetStreamWaveAudioInfo, 'GetStreamWaveAudioInfo', cdRegister);
 S.RegisterDelphiFunction(@CreateStreamWaveAudio, 'CreateStreamWaveAudio', cdRegister);
 S.RegisterDelphiFunction(@OpenStreamWaveAudio, 'OpenStreamWaveAudio', cdRegister);
 S.RegisterDelphiFunction(@CalcWaveBufferSize, 'CalcWaveBufferSize', cdRegister);
 S.RegisterDelphiFunction(@GetAudioFormat, 'GetAudioFormat', cdRegister);
 S.RegisterDelphiFunction(@GetWaveAudioFormat, 'GetWaveAudioFormat', cdRegister);
 S.RegisterDelphiFunction(@GetWaveAudioLength, 'GetWaveAudioLength', cdRegister);
 S.RegisterDelphiFunction(@GetWaveAudioBitRate, 'GetWaveAudioBitRate', cdRegister);
 S.RegisterDelphiFunction(@GetWaveAudioPeakLevel, 'GetWaveAudioPeakLevel', cdRegister);
 S.RegisterDelphiFunction(@InvertWaveAudio, 'InvertWaveAudio', cdRegister);
 S.RegisterDelphiFunction(@SilenceWaveAudio, 'SilenceWaveAudio', cdRegister);
 S.RegisterDelphiFunction(@ChangeWaveAudioVolume, 'ChangeWaveAudioVolume', cdRegister);
 S.RegisterDelphiFunction(@MixWaveAudio, 'MixWaveAudio', cdRegister);
 S.RegisterDelphiFunction(@ConvertWaveFormat, 'ConvertWaveFormat', cdRegister);
 S.RegisterDelphiFunction(@SetPCMAudioFormat, 'SetPCMAudioFormat', cdRegister);
 S.RegisterDelphiFunction(@SetPCMAudioFormatS, 'SetPCMAudioFormatS', cdRegister);
 S.RegisterDelphiFunction(@GetPCMAudioFormat, 'GetPCMAudioFormat', cdRegister);
 S.RegisterDelphiFunction(@GetWaveDataPositionOffset, 'GetWaveDataPositionOffset', cdRegister);
 S.RegisterDelphiFunction(@MS2Str, 'MS2Str', cdRegister);
 S.RegisterDelphiFunction(@WaitForSyncObject, 'WaitForSyncObject', cdRegister);
 //S.RegisterDelphiFunction(@mmioStreamProc, 'mmioStreamProc', CdStdCall);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WaveUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EWaveAudioError) do
  with CL.Add(EWaveAudioSysError) do
  with CL.Add(EWaveAudioInvalidOperation) do
end;

 
 
{ TPSImport_WaveUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WaveUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WaveUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WaveUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WaveUtils(ri);
  RIRegister_WaveUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
