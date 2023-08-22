unit uPSI_UWavein4;
{
     for oscilloscope

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
  TPSImport_UWavein4 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TWaveIn(CL: TPSPascalCompiler);
procedure SIRegister_UWavein4(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TWaveIn(CL: TPSRuntimeClassImporter);
procedure RIRegister_UWavein4(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,MMSystem
  ,UWavein4
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UWavein4]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TWaveIn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TWaveIn') do
  with CL.AddClassN(CL.FindClass('TObject'),'TWaveIn') do begin
    RegisterMethod('Constructor Create( newFormHandle : HWnd; BfSize, newTotalBuffers : Integer)');
      RegisterMethod('Procedure Free');
    RegisterProperty('RecordActive', 'Boolean', iptrw);
    RegisterProperty('ptrWaveFmtEx', 'PWaveFormatEx', iptrw);
    RegisterProperty('WaveBufSize', 'Integer', iptrw);
    RegisterProperty('IniTWavein', 'Boolean', iptrw);
    RegisterProperty('RecErrorMessage', 'String', iptrw);
    RegisterProperty('QueuedBuffers', 'Integer', iptrw);
    RegisterProperty('ProcessedBuffers', 'Integer', iptrw);
    RegisterProperty('pWaveBuffer', '', iptrw);
    RegisterProperty('WaveIn', 'HWAVEIN', iptrw);
    RegisterProperty('OnError', 'TErrorEvent', iptrw);
    RegisterProperty('TotalBuffers', 'Integer', iptrw);
    RegisterMethod('Function AddNextBuffer : Boolean');
    RegisterMethod('Procedure StopInput');
    RegisterMethod('Function StartInput : Boolean');
    RegisterMethod('Function SetupInput : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UWavein4(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MAX_BUFFERS','LongInt').SetInt( 8);

  // HWAVEIN = Integer;
  CL.AddTypeS('HWAVEIN', 'Integer');

  CL.AddTypeS('TBufferFullEvent', 'Procedure ( Sender : TObject; Data : TObject; Size : longint)');
  CL.AddTypeS('TErrorEvent', 'Procedure ( s : string)');
  SIRegister_TWaveIn(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TWaveInTotalBuffers_W(Self: TWaveIn; const T: Integer);
Begin Self.TotalBuffers := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInTotalBuffers_R(Self: TWaveIn; var T: Integer);
Begin T := Self.TotalBuffers; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInOnError_W(Self: TWaveIn; const T: TErrorEvent);
Begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInOnError_R(Self: TWaveIn; var T: TErrorEvent);
Begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInWaveIn_W(Self: TWaveIn; const T: HWAVEIN);
Begin Self.WaveIn := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInWaveIn_R(Self: TWaveIn; var T: HWAVEIN);
Begin T := Self.WaveIn; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInpWaveBuffer_W(Self: TWaveIn; const T: TObject);
Begin //Self.pWaveBuffer := T;
end;

(*----------------------------------------------------------------------------*)
procedure TWaveInpWaveBuffer_R(Self: TWaveIn; var T: TObject);
Begin //T := Self.pWaveBuffer;
end;

(*----------------------------------------------------------------------------*)
procedure TWaveInProcessedBuffers_W(Self: TWaveIn; const T: Integer);
Begin Self.ProcessedBuffers := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInProcessedBuffers_R(Self: TWaveIn; var T: Integer);
Begin T := Self.ProcessedBuffers; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInQueuedBuffers_W(Self: TWaveIn; const T: Integer);
Begin Self.QueuedBuffers := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInQueuedBuffers_R(Self: TWaveIn; var T: Integer);
Begin T := Self.QueuedBuffers; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInRecErrorMessage_W(Self: TWaveIn; const T: String);
Begin Self.RecErrorMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInRecErrorMessage_R(Self: TWaveIn; var T: String);
Begin T := Self.RecErrorMessage; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInIniTWavein_W(Self: TWaveIn; const T: Boolean);
Begin Self.IniTWavein := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInIniTWavein_R(Self: TWaveIn; var T: Boolean);
Begin T := Self.IniTWavein; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInWaveBufSize_W(Self: TWaveIn; const T: Integer);
Begin Self.WaveBufSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInWaveBufSize_R(Self: TWaveIn; var T: Integer);
Begin T := Self.WaveBufSize; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInptrWaveFmtEx_W(Self: TWaveIn; const T: PWaveFormatEx);
Begin Self.ptrWaveFmtEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInptrWaveFmtEx_R(Self: TWaveIn; var T: PWaveFormatEx);
Begin T := Self.ptrWaveFmtEx; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInRecordActive_W(Self: TWaveIn; const T: Boolean);
Begin Self.RecordActive := T; end;

(*----------------------------------------------------------------------------*)
procedure TWaveInRecordActive_R(Self: TWaveIn; var T: Boolean);
Begin T := Self.RecordActive; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWaveIn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWaveIn) do begin
    RegisterConstructor(@TWaveIn.Create, 'Create');
      RegisterMethod(@TWaveIn.Destroy, 'Free');
      RegisterPropertyHelper(@TWaveInRecordActive_R,@TWaveInRecordActive_W,'RecordActive');
    RegisterPropertyHelper(@TWaveInptrWaveFmtEx_R,@TWaveInptrWaveFmtEx_W,'ptrWaveFmtEx');
    RegisterPropertyHelper(@TWaveInWaveBufSize_R,@TWaveInWaveBufSize_W,'WaveBufSize');
    RegisterPropertyHelper(@TWaveInIniTWavein_R,@TWaveInIniTWavein_W,'IniTWavein');
    RegisterPropertyHelper(@TWaveInRecErrorMessage_R,@TWaveInRecErrorMessage_W,'RecErrorMessage');
    RegisterPropertyHelper(@TWaveInQueuedBuffers_R,@TWaveInQueuedBuffers_W,'QueuedBuffers');
    RegisterPropertyHelper(@TWaveInProcessedBuffers_R,@TWaveInProcessedBuffers_W,'ProcessedBuffers');
    RegisterPropertyHelper(@TWaveInpWaveBuffer_R,@TWaveInpWaveBuffer_W,'pWaveBuffer');
    RegisterPropertyHelper(@TWaveInWaveIn_R,@TWaveInWaveIn_W,'WaveIn');
    RegisterPropertyHelper(@TWaveInOnError_R,@TWaveInOnError_W,'OnError');
    RegisterPropertyHelper(@TWaveInTotalBuffers_R,@TWaveInTotalBuffers_W,'TotalBuffers');
    RegisterMethod(@TWaveIn.AddNextBuffer, 'AddNextBuffer');
    RegisterMethod(@TWaveIn.StopInput, 'StopInput');
    RegisterMethod(@TWaveIn.StartInput, 'StartInput');
    RegisterMethod(@TWaveIn.SetupInput, 'SetupInput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UWavein4(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TWaveIn(CL);
end;

 
 
{ TPSImport_UWavein4 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UWavein4.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UWavein4(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UWavein4.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UWavein4(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
