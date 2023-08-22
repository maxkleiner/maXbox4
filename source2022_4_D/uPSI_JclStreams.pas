unit uPSI_JclStreams;
{
   stream for dream
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
  TPSImport_JclStreams = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclStaticSplitStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclDynamicSplitStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclSplitStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclCRC32Stream(CL: TPSPascalCompiler);
procedure SIRegister_TJclCRC16Stream(CL: TPSPascalCompiler);
procedure SIRegister_TJclSectoredStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclDelegatedStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclScopedStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclEasyStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclEventStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclBufferedStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclStreamDecorator(CL: TPSPascalCompiler);
procedure SIRegister_TJclMultiplexStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclRandomStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclNullStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclEmptyStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclFileStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclHandleStream(CL: TPSPascalCompiler);
procedure SIRegister_TJclStream(CL: TPSPascalCompiler);
procedure SIRegister_JclStreams(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclStreams_Routines(S: TPSExec);
procedure RIRegister_TJclStaticSplitStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclDynamicSplitStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSplitStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclCRC32Stream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclCRC16Stream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSectoredStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclDelegatedStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclScopedStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclEasyStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclEventStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBufferedStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclStreamDecorator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMultiplexStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclRandomStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclNullStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclEmptyStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclFileStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclHandleStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclStreams(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  //,Libc
  ,JclBase
  ,JclStreams
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclStreams]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclStaticSplitStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSplitStream', 'TJclStaticSplitStream') do
  with CL.AddClassN(CL.FindClass('TJclSplitStream'),'TJclStaticSplitStream') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function AddVolume( AStream : TStream; AMaxSize : Int64; AOwnStream : Boolean) : Integer');
    RegisterProperty('VolumeCount', 'Integer', iptr);
    RegisterProperty('Volumes', 'TStream Integer', iptr);
    RegisterProperty('VolumeMaxSizes', 'Int64 Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclDynamicSplitStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSplitStream', 'TJclDynamicSplitStream') do
  with CL.AddClassN(CL.FindClass('TJclSplitStream'),'TJclDynamicSplitStream') do begin
    RegisterProperty('OnVolume', 'TJclVolumeEvent', iptrw);
    RegisterProperty('OnVolumeMaxSize', 'TJclVolumeMaxSizeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSplitStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclStream', 'TJclSplitStream') do
  with CL.AddClassN(CL.FindClass('TJclStream'),'TJclSplitStream') do begin
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclCRC32Stream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSectoredStream', 'TJclCRC32Stream') do
  with CL.AddClassN(CL.FindClass('TJclSectoredStream'),'TJclCRC32Stream') do begin
    RegisterMethod('Constructor Create( AStorageStream : TStream; AOwnsStream : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclCRC16Stream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSectoredStream', 'TJclCRC16Stream') do
  with CL.AddClassN(CL.FindClass('TJclSectoredStream'),'TJclCRC16Stream') do begin
    RegisterMethod('Constructor Create( AStorageStream : TStream; AOwnsStream : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSectoredStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclBufferedStream', 'TJclSectoredStream') do
  with CL.AddClassN(CL.FindClass('TJclBufferedStream'),'TJclSectoredStream') do begin
    RegisterMethod('Constructor Create( AStorageStream : TStream; AOwnsStream : Boolean; ASectorOverHead : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclDelegatedStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclStream', 'TJclDelegatedStream') do
  with CL.AddClassN(CL.FindClass('TJclStream'),'TJclDelegatedStream') do begin
    RegisterProperty('OnSeek', 'TJclStreamSeekEvent', iptrw);
    RegisterProperty('OnRead', 'TJclStreamReadEvent', iptrw);
    RegisterProperty('OnWrite', 'TJclStreamWriteEvent', iptrw);
    RegisterProperty('OnSize', 'TJclStreamSizeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclScopedStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclStream', 'TJclScopedStream') do
  with CL.AddClassN(CL.FindClass('TJclStream'),'TJclScopedStream') do begin
    RegisterMethod('Constructor Create( AParentStream : TStream; AMaxSize : Int64)');
    RegisterProperty('ParentStream', 'TStream', iptr);
    RegisterProperty('StartPos', 'Int64', iptr);
    RegisterProperty('MaxSize', 'Int64', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclEasyStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclStreamDecorator', 'TJclEasyStream') do
  with CL.AddClassN(CL.FindClass('TJclStreamDecorator'),'TJclEasyStream') do begin
    RegisterMethod('Function IsEqual( Stream : TStream) : Boolean');
    RegisterMethod('Function ReadBoolean : Boolean');
    RegisterMethod('Function ReadChar : Char');
    RegisterMethod('Function ReadCurrency : Currency');
    RegisterMethod('Function ReadDateTime : TDateTime');
    RegisterMethod('Function ReadDouble : Double');
    RegisterMethod('Function ReadExtended : Extended');
    RegisterMethod('Function ReadInt64 : Int64');
    RegisterMethod('Function ReadInteger : Integer');
    RegisterMethod('Function ReadCString : string');
    RegisterMethod('Function ReadShortString : string');
    RegisterMethod('Function ReadSingle : Single');
    RegisterMethod('Function ReadSizedString : string');
    RegisterMethod('Procedure WriteBoolean( Value : Boolean)');
    RegisterMethod('Procedure WriteChar( Value : Char)');
    RegisterMethod('Procedure WriteCurrency( const Value : Currency)');
    RegisterMethod('Procedure WriteDateTime( const Value : TDateTime)');
    RegisterMethod('Procedure WriteDouble( const Value : Double)');
    RegisterMethod('Procedure WriteExtended( const Value : Extended)');
    RegisterMethod('Procedure WriteInt64( Value : Int64);');
    RegisterMethod('Procedure WriteInteger( Value : Integer);');
    RegisterMethod('Procedure WriteCString( const Value : string)');
    RegisterMethod('Procedure WriteStringDelimitedByNull( const Value : string)');
    RegisterMethod('Procedure WriteShortString( const Value : ShortString)');
    RegisterMethod('Procedure WriteSingle( const Value : Single)');
    RegisterMethod('Procedure WriteSizedString( const Value : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclEventStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclStreamDecorator', 'TJclEventStream') do
  with CL.AddClassN(CL.FindClass('TJclStreamDecorator'),'TJclEventStream') do begin
    RegisterMethod('Constructor Create( AStream : TStream; ANotification : TStreamNotifyEvent; AOwnsStream : Boolean)');
    RegisterProperty('OnNotification', 'TStreamNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBufferedStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclStreamDecorator', 'TJclBufferedStream') do
  with CL.AddClassN(CL.FindClass('TJclStreamDecorator'),'TJclBufferedStream') do begin
    RegisterMethod('Constructor Create( AStream : TStream; AOwnsStream : Boolean)');
    RegisterMethod('Procedure Flush');
    RegisterProperty('BufferSize', 'Longint', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclStreamDecorator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclStream', 'TJclStreamDecorator') do
  with CL.AddClassN(CL.FindClass('TJclStream'),'TJclStreamDecorator') do begin
    RegisterMethod('Constructor Create( AStream : TStream; AOwnsStream : Boolean)');
    RegisterProperty('AfterStreamChange', 'TNotifyEvent', iptrw);
    RegisterProperty('BeforeStreamChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OwnsStream', 'Boolean', iptrw);
    RegisterProperty('Stream', 'TStream', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMultiplexStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclStream', 'TJclMultiplexStream') do
  with CL.AddClassN(CL.FindClass('TJclStream'),'TJclMultiplexStream') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Add( NewStream : TStream) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Remove( AStream : TStream) : Integer');
    RegisterMethod('Procedure Delete( const Index : Integer)');
    RegisterProperty('Streams', 'TStream Integer', iptrw);
    RegisterProperty('ReadStreamIndex', 'Integer', iptrw);
    RegisterProperty('ReadStream', 'TStream', iptrw);
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclRandomStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclNullStream', 'TJclRandomStream') do
  with CL.AddClassN(CL.FindClass('TJclNullStream'),'TJclRandomStream') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function RandomData : Byte');
    RegisterMethod('Procedure Randomize');
    RegisterProperty('RandSeed', 'Longint', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclNullStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclStream', 'TJclNullStream') do
  with CL.AddClassN(CL.FindClass('TJclStream'),'TJclNullStream') do begin
    RegisterMethod('Function Read( var Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Write( const Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Seek( const Offset : Int64; Origin : TSeekOrigin) : Int64');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclEmptyStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclStream', 'TJclEmptyStream') do
  with CL.AddClassN(CL.FindClass('TJclStream'),'TJclEmptyStream') do begin
    RegisterMethod('Function Read( var Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Write( const Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Seek( const Offset : Int64; Origin : TSeekOrigin) : Int64');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclHandleStream', 'TJclFileStream') do
  with CL.AddClassN(CL.FindClass('TJclHandleStream'),'TJclFileStream2') do begin
    RegisterMethod('Constructor Create( const FileName : string; Mode : Word; Rights : Cardinal)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclHandleStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclStream', 'TJclHandleStream') do
  with CL.AddClassN(CL.FindClass('TJclStream'),'TJclHandleStream') do
  begin
    RegisterMethod('Constructor Create( AHandle : THandle)');
    RegisterMethod('Function Read( var Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Write( const Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Seek( const Offset : Int64; Origin : TSeekOrigin) : Int64');
    RegisterProperty('Handle', 'THandle', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TJclStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TJclStream') do begin
    RegisterMethod('Function Seek( Offset : Longint; Origin : Word) : Longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclStreams(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TSeekOrigin', '( soBeginning, soCurrent, soEnd )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclStreamError');
  SIRegister_TJclStream(CL);
  SIRegister_TJclHandleStream(CL);
  SIRegister_TJclFileStream(CL);
  SIRegister_TJclEmptyStream(CL);
  SIRegister_TJclNullStream(CL);
  SIRegister_TJclRandomStream(CL);
  SIRegister_TJclMultiplexStream(CL);
  SIRegister_TJclStreamDecorator(CL);
  SIRegister_TJclBufferedStream(CL);
  CL.AddTypeS('TStreamNotifyEvent', 'Procedure ( Sender : TObject; Position : Int64; Size : Int64)');
  SIRegister_TJclEventStream(CL);
  SIRegister_TJclEasyStream(CL);
  SIRegister_TJclScopedStream(CL);
  CL.AddTypeS('TJclStreamSeekEvent', 'Function ( Sender : TObject; const Offset'
   +' : Int64; Origin : TSeekOrigin) : Int64');
  CL.AddTypeS('TJclStreamReadEvent', 'Function ( Sender : TObject; var Buffer, '
   +'Offset, Count : Longint) : Longint');
  CL.AddTypeS('TJclStreamWriteEvent', 'Function ( Sender : TObject; const Buffe'
   +'r, Offset, Count : Longint) : Longint');
  CL.AddTypeS('TJclStreamSizeEvent', 'Procedure ( Sender : TObject; const NewSize : Int64)');
  SIRegister_TJclDelegatedStream(CL);
  SIRegister_TJclSectoredStream(CL);
  SIRegister_TJclCRC16Stream(CL);
  SIRegister_TJclCRC32Stream(CL);
  SIRegister_TJclSplitStream(CL);
  CL.AddTypeS('TJclVolumeEvent', 'Function ( Index : Integer) : TStream');
  CL.AddTypeS('TJclVolumeMaxSizeEvent', 'Function ( Index : Integer) : Int64');
  SIRegister_TJclDynamicSplitStream(CL);
  CL.AddTypeS('TJclSplitVolume', 'record MaxSize : Int64; Stream : TStream; OwnStream : Boolean; end');
  //CL.AddTypeS('PJclSplitVolume', '^TJclSplitVolume // will not work');
  SIRegister_TJclStaticSplitStream(CL);
 CL.AddDelphiFunction('Function StreamSeek( Stream : TStream; const Offset : Int64; const Origin : TSeekOrigin) : Int64');
 CL.AddDelphiFunction('Function StreamCopy( Source : TStream; Dest : TStream; BufferSize : Integer) : Int64');
 CL.AddDelphiFunction('Function CompareStreams( A, B : TStream; BufferSize : Integer) : Boolean');
 CL.AddDelphiFunction('Function JCompareFiles( const FileA, FileB : TFileName; BufferSize : Integer) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclStaticSplitStreamVolumeMaxSizes_R(Self: TJclStaticSplitStream; var T: Int64; const t1: Integer);
begin T := Self.VolumeMaxSizes[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStaticSplitStreamVolumes_R(Self: TJclStaticSplitStream; var T: TStream; const t1: Integer);
begin T := Self.Volumes[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStaticSplitStreamVolumeCount_R(Self: TJclStaticSplitStream; var T: Integer);
begin T := Self.VolumeCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclDynamicSplitStreamOnVolumeMaxSize_W(Self: TJclDynamicSplitStream; const T: TJclVolumeMaxSizeEvent);
begin Self.OnVolumeMaxSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDynamicSplitStreamOnVolumeMaxSize_R(Self: TJclDynamicSplitStream; var T: TJclVolumeMaxSizeEvent);
begin T := Self.OnVolumeMaxSize; end;

(*----------------------------------------------------------------------------*)
procedure TJclDynamicSplitStreamOnVolume_W(Self: TJclDynamicSplitStream; const T: TJclVolumeEvent);
begin Self.OnVolume := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDynamicSplitStreamOnVolume_R(Self: TJclDynamicSplitStream; var T: TJclVolumeEvent);
begin T := Self.OnVolume; end;

(*----------------------------------------------------------------------------*)
procedure TJclDelegatedStreamOnSize_W(Self: TJclDelegatedStream; const T: TJclStreamSizeEvent);
begin Self.OnSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDelegatedStreamOnSize_R(Self: TJclDelegatedStream; var T: TJclStreamSizeEvent);
begin T := Self.OnSize; end;

(*----------------------------------------------------------------------------*)
procedure TJclDelegatedStreamOnWrite_W(Self: TJclDelegatedStream; const T: TJclStreamWriteEvent);
begin Self.OnWrite := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDelegatedStreamOnWrite_R(Self: TJclDelegatedStream; var T: TJclStreamWriteEvent);
begin T := Self.OnWrite; end;

(*----------------------------------------------------------------------------*)
procedure TJclDelegatedStreamOnRead_W(Self: TJclDelegatedStream; const T: TJclStreamReadEvent);
begin Self.OnRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDelegatedStreamOnRead_R(Self: TJclDelegatedStream; var T: TJclStreamReadEvent);
begin T := Self.OnRead; end;

(*----------------------------------------------------------------------------*)
procedure TJclDelegatedStreamOnSeek_W(Self: TJclDelegatedStream; const T: TJclStreamSeekEvent);
begin Self.OnSeek := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDelegatedStreamOnSeek_R(Self: TJclDelegatedStream; var T: TJclStreamSeekEvent);
begin T := Self.OnSeek; end;

(*----------------------------------------------------------------------------*)
procedure TJclScopedStreamMaxSize_W(Self: TJclScopedStream; const T: Int64);
begin Self.MaxSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclScopedStreamMaxSize_R(Self: TJclScopedStream; var T: Int64);
begin T := Self.MaxSize; end;

(*----------------------------------------------------------------------------*)
procedure TJclScopedStreamStartPos_R(Self: TJclScopedStream; var T: Int64);
begin T := Self.StartPos; end;

(*----------------------------------------------------------------------------*)
procedure TJclScopedStreamParentStream_R(Self: TJclScopedStream; var T: TStream);
begin T := Self.ParentStream; end;

(*----------------------------------------------------------------------------*)
Procedure TJclEasyStreamWriteInteger_P(Self: TJclEasyStream;  Value : Integer);
Begin Self.WriteInteger(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TJclEasyStreamWriteInt64_P(Self: TJclEasyStream;  Value : Int64);
Begin Self.WriteInt64(Value); END;

(*----------------------------------------------------------------------------*)
procedure TJclEventStreamOnNotification_W(Self: TJclEventStream; const T: TStreamNotifyEvent);
begin Self.OnNotification := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclEventStreamOnNotification_R(Self: TJclEventStream; var T: TStreamNotifyEvent);
begin T := Self.OnNotification; end;

(*----------------------------------------------------------------------------*)
procedure TJclBufferedStreamBufferSize_W(Self: TJclBufferedStream; const T: Longint);
begin Self.BufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBufferedStreamBufferSize_R(Self: TJclBufferedStream; var T: Longint);
begin T := Self.BufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TJclStreamDecoratorStream_W(Self: TJclStreamDecorator; const T: TStream);
begin Self.Stream := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStreamDecoratorStream_R(Self: TJclStreamDecorator; var T: TStream);
begin T := Self.Stream; end;

(*----------------------------------------------------------------------------*)
procedure TJclStreamDecoratorOwnsStream_W(Self: TJclStreamDecorator; const T: Boolean);
begin Self.OwnsStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStreamDecoratorOwnsStream_R(Self: TJclStreamDecorator; var T: Boolean);
begin T := Self.OwnsStream; end;

(*----------------------------------------------------------------------------*)
procedure TJclStreamDecoratorBeforeStreamChange_W(Self: TJclStreamDecorator; const T: TNotifyEvent);
begin Self.BeforeStreamChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStreamDecoratorBeforeStreamChange_R(Self: TJclStreamDecorator; var T: TNotifyEvent);
begin T := Self.BeforeStreamChange; end;

(*----------------------------------------------------------------------------*)
procedure TJclStreamDecoratorAfterStreamChange_W(Self: TJclStreamDecorator; const T: TNotifyEvent);
begin Self.AfterStreamChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStreamDecoratorAfterStreamChange_R(Self: TJclStreamDecorator; var T: TNotifyEvent);
begin T := Self.AfterStreamChange; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultiplexStreamCount_R(Self: TJclMultiplexStream; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultiplexStreamReadStream_W(Self: TJclMultiplexStream; const T: TStream);
begin Self.ReadStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultiplexStreamReadStream_R(Self: TJclMultiplexStream; var T: TStream);
begin T := Self.ReadStream; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultiplexStreamReadStreamIndex_W(Self: TJclMultiplexStream; const T: Integer);
begin Self.ReadStreamIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultiplexStreamReadStreamIndex_R(Self: TJclMultiplexStream; var T: Integer);
begin T := Self.ReadStreamIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultiplexStreamStreams_W(Self: TJclMultiplexStream; const T: TStream; const t1: Integer);
begin Self.Streams[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultiplexStreamStreams_R(Self: TJclMultiplexStream; var T: TStream; const t1: Integer);
begin T := Self.Streams[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclRandomStreamRandSeed_W(Self: TJclRandomStream; const T: Longint);
begin Self.RandSeed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclRandomStreamRandSeed_R(Self: TJclRandomStream; var T: Longint);
begin T := Self.RandSeed; end;

(*----------------------------------------------------------------------------*)
procedure TJclHandleStreamHandle_R(Self: TJclHandleStream; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
Procedure TJclStreamSetSize12_P(Self: TJclStream;  const NewSize : Int64);
Begin //Self.SetSize(NewSize);
 END;

(*----------------------------------------------------------------------------*)
Procedure TJclStreamSetSize1_P(Self: TJclStream;  const NewSize : Int64);
Begin //Self.SetSize(NewSize);
 END;

(*----------------------------------------------------------------------------*)
Procedure TJclStreamSetSize_P(Self: TJclStream;  NewSize : Longint);
Begin //Self.SetSize(NewSize);
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclStreams_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StreamSeek, 'StreamSeek', cdRegister);
 S.RegisterDelphiFunction(@StreamCopy, 'StreamCopy', cdRegister);
 S.RegisterDelphiFunction(@CompareStreams, 'CompareStreams', cdRegister);
 S.RegisterDelphiFunction(@CompareFiles, 'JCompareFiles', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclStaticSplitStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclStaticSplitStream) do begin
    RegisterConstructor(@TJclStaticSplitStream.Create, 'Create');
    RegisterMethod(@TJclStaticSplitStream.AddVolume, 'AddVolume');
    RegisterPropertyHelper(@TJclStaticSplitStreamVolumeCount_R,nil,'VolumeCount');
    RegisterPropertyHelper(@TJclStaticSplitStreamVolumes_R,nil,'Volumes');
    RegisterPropertyHelper(@TJclStaticSplitStreamVolumeMaxSizes_R,nil,'VolumeMaxSizes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclDynamicSplitStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclDynamicSplitStream) do
  begin
    RegisterPropertyHelper(@TJclDynamicSplitStreamOnVolume_R,@TJclDynamicSplitStreamOnVolume_W,'OnVolume');
    RegisterPropertyHelper(@TJclDynamicSplitStreamOnVolumeMaxSize_R,@TJclDynamicSplitStreamOnVolumeMaxSize_W,'OnVolumeMaxSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSplitStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSplitStream) do
  begin
    RegisterConstructor(@TJclSplitStream.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclCRC32Stream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclCRC32Stream) do
  begin
    RegisterConstructor(@TJclCRC32Stream.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclCRC16Stream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclCRC16Stream) do
  begin
    RegisterConstructor(@TJclCRC16Stream.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSectoredStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSectoredStream) do
  begin
    RegisterConstructor(@TJclSectoredStream.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclDelegatedStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclDelegatedStream) do
  begin
    RegisterPropertyHelper(@TJclDelegatedStreamOnSeek_R,@TJclDelegatedStreamOnSeek_W,'OnSeek');
    RegisterPropertyHelper(@TJclDelegatedStreamOnRead_R,@TJclDelegatedStreamOnRead_W,'OnRead');
    RegisterPropertyHelper(@TJclDelegatedStreamOnWrite_R,@TJclDelegatedStreamOnWrite_W,'OnWrite');
    RegisterPropertyHelper(@TJclDelegatedStreamOnSize_R,@TJclDelegatedStreamOnSize_W,'OnSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclScopedStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclScopedStream) do
  begin
    RegisterConstructor(@TJclScopedStream.Create, 'Create');
    RegisterPropertyHelper(@TJclScopedStreamParentStream_R,nil,'ParentStream');
    RegisterPropertyHelper(@TJclScopedStreamStartPos_R,nil,'StartPos');
    RegisterPropertyHelper(@TJclScopedStreamMaxSize_R,@TJclScopedStreamMaxSize_W,'MaxSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclEasyStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclEasyStream) do
  begin
    RegisterMethod(@TJclEasyStream.IsEqual, 'IsEqual');
    RegisterMethod(@TJclEasyStream.ReadBoolean, 'ReadBoolean');
    RegisterMethod(@TJclEasyStream.ReadChar, 'ReadChar');
    RegisterMethod(@TJclEasyStream.ReadCurrency, 'ReadCurrency');
    RegisterMethod(@TJclEasyStream.ReadDateTime, 'ReadDateTime');
    RegisterMethod(@TJclEasyStream.ReadDouble, 'ReadDouble');
    RegisterMethod(@TJclEasyStream.ReadExtended, 'ReadExtended');
    RegisterMethod(@TJclEasyStream.ReadInt64, 'ReadInt64');
    RegisterMethod(@TJclEasyStream.ReadInteger, 'ReadInteger');
    RegisterMethod(@TJclEasyStream.ReadCString, 'ReadCString');
    RegisterMethod(@TJclEasyStream.ReadShortString, 'ReadShortString');
    RegisterMethod(@TJclEasyStream.ReadSingle, 'ReadSingle');
    RegisterMethod(@TJclEasyStream.ReadSizedString, 'ReadSizedString');
    RegisterMethod(@TJclEasyStream.WriteBoolean, 'WriteBoolean');
    RegisterMethod(@TJclEasyStream.WriteChar, 'WriteChar');
    RegisterMethod(@TJclEasyStream.WriteCurrency, 'WriteCurrency');
    RegisterMethod(@TJclEasyStream.WriteDateTime, 'WriteDateTime');
    RegisterMethod(@TJclEasyStream.WriteDouble, 'WriteDouble');
    RegisterMethod(@TJclEasyStream.WriteExtended, 'WriteExtended');
    RegisterMethod(@TJclEasyStreamWriteInt64_P, 'WriteInt64');
    RegisterMethod(@TJclEasyStreamWriteInteger_P, 'WriteInteger');
    RegisterMethod(@TJclEasyStream.WriteCString, 'WriteCString');
    RegisterMethod(@TJclEasyStream.WriteStringDelimitedByNull, 'WriteStringDelimitedByNull');
    RegisterMethod(@TJclEasyStream.WriteShortString, 'WriteShortString');
    RegisterMethod(@TJclEasyStream.WriteSingle, 'WriteSingle');
    RegisterMethod(@TJclEasyStream.WriteSizedString, 'WriteSizedString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclEventStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclEventStream) do
  begin
    RegisterConstructor(@TJclEventStream.Create, 'Create');
    RegisterPropertyHelper(@TJclEventStreamOnNotification_R,@TJclEventStreamOnNotification_W,'OnNotification');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBufferedStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBufferedStream) do
  begin
    RegisterConstructor(@TJclBufferedStream.Create, 'Create');
    RegisterVirtualMethod(@TJclBufferedStream.Flush, 'Flush');
    RegisterPropertyHelper(@TJclBufferedStreamBufferSize_R,@TJclBufferedStreamBufferSize_W,'BufferSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclStreamDecorator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclStreamDecorator) do
  begin
    RegisterConstructor(@TJclStreamDecorator.Create, 'Create');
    RegisterPropertyHelper(@TJclStreamDecoratorAfterStreamChange_R,@TJclStreamDecoratorAfterStreamChange_W,'AfterStreamChange');
    RegisterPropertyHelper(@TJclStreamDecoratorBeforeStreamChange_R,@TJclStreamDecoratorBeforeStreamChange_W,'BeforeStreamChange');
    RegisterPropertyHelper(@TJclStreamDecoratorOwnsStream_R,@TJclStreamDecoratorOwnsStream_W,'OwnsStream');
    RegisterPropertyHelper(@TJclStreamDecoratorStream_R,@TJclStreamDecoratorStream_W,'Stream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMultiplexStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMultiplexStream) do
  begin
    RegisterConstructor(@TJclMultiplexStream.Create, 'Create');
    RegisterMethod(@TJclMultiplexStream.Add, 'Add');
    RegisterMethod(@TJclMultiplexStream.Clear, 'Clear');
    RegisterMethod(@TJclMultiplexStream.Remove, 'Remove');
    RegisterMethod(@TJclMultiplexStream.Delete, 'Delete');
    RegisterPropertyHelper(@TJclMultiplexStreamStreams_R,@TJclMultiplexStreamStreams_W,'Streams');
    RegisterPropertyHelper(@TJclMultiplexStreamReadStreamIndex_R,@TJclMultiplexStreamReadStreamIndex_W,'ReadStreamIndex');
    RegisterPropertyHelper(@TJclMultiplexStreamReadStream_R,@TJclMultiplexStreamReadStream_W,'ReadStream');
    RegisterPropertyHelper(@TJclMultiplexStreamCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclRandomStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclRandomStream) do
  begin
    RegisterConstructor(@TJclRandomStream.Create, 'Create');
    RegisterVirtualMethod(@TJclRandomStream.RandomData, 'RandomData');
    RegisterVirtualMethod(@TJclRandomStream.Randomize, 'Randomize');
    RegisterPropertyHelper(@TJclRandomStreamRandSeed_R,@TJclRandomStreamRandSeed_W,'RandSeed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclNullStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclNullStream) do
  begin
    RegisterMethod(@TJclNullStream.Read, 'Read');
    RegisterMethod(@TJclNullStream.Write, 'Write');
    RegisterMethod(@TJclNullStream.Seek, 'Seek');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclEmptyStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclEmptyStream) do
  begin
    RegisterMethod(@TJclEmptyStream.Read, 'Read');
    RegisterMethod(@TJclEmptyStream.Write, 'Write');
    RegisterMethod(@TJclEmptyStream.Seek, 'Seek');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileStream) do
  begin
    RegisterConstructor(@TJclFileStream.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclHandleStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclHandleStream) do
  begin
    RegisterConstructor(@TJclHandleStream.Create, 'Create');
    RegisterMethod(@TJclHandleStream.Read, 'Read');
    RegisterMethod(@TJclHandleStream.Write, 'Write');
    RegisterMethod(@TJclHandleStream.Seek, 'Seek');
    RegisterPropertyHelper(@TJclHandleStreamHandle_R,nil,'Handle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclStream) do
  begin
    RegisterMethod(@TJclStream.Seek, 'Seek');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclStreams(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclStreamError) do
  RIRegister_TJclStream(CL);
  RIRegister_TJclHandleStream(CL);
  RIRegister_TJclFileStream(CL);
  RIRegister_TJclEmptyStream(CL);
  RIRegister_TJclNullStream(CL);
  RIRegister_TJclRandomStream(CL);
  RIRegister_TJclMultiplexStream(CL);
  RIRegister_TJclStreamDecorator(CL);
  RIRegister_TJclBufferedStream(CL);
  RIRegister_TJclEventStream(CL);
  RIRegister_TJclEasyStream(CL);
  RIRegister_TJclScopedStream(CL);
  RIRegister_TJclDelegatedStream(CL);
  RIRegister_TJclSectoredStream(CL);
  RIRegister_TJclCRC16Stream(CL);
  RIRegister_TJclCRC32Stream(CL);
  RIRegister_TJclSplitStream(CL);
  RIRegister_TJclDynamicSplitStream(CL);
  RIRegister_TJclStaticSplitStream(CL);
end;

 
 
{ TPSImport_JclStreams }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclStreams.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclStreams(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclStreams.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclStreams(ri);
  RIRegister_JclStreams_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
