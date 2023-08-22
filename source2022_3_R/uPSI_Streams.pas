unit uPSI_Streams;
{
for bitstream add //CL.AddTypeS('TFileAttributes2', 'set of ( sfaArchive, sfaHidden, sfaSystem, sf'
   //+'aReadOnly, sfaTemporary, sfaCompressed, sfaDirectory )');


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
  TPSImport_Streams = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDummyStream(CL: TPSPascalCompiler);
procedure SIRegister_TFileStream2(CL: TPSPascalCompiler);
procedure SIRegister_TSeekableStream(CL: TPSPascalCompiler);
procedure SIRegister_TFilterStream(CL: TPSPascalCompiler);
procedure SIRegister_TBaseStream(CL: TPSPascalCompiler);
procedure SIRegister_Streams(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Streams_Routines(S: TPSExec);
procedure RIRegister_TDummyStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFileStream2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSeekableStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFilterStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBaseStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_Streams(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Monitor
  ,Windows
  ,Streams
  ;

 // type tfilestream2 = Streams.TFileStream;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Streams]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDummyStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseStream', 'TDummyStream') do
  with CL.AddClassN(CL.FindClass('TBaseStream'),'TDummyStream') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Write( var Buf, Count : integer) : integer');
    RegisterMethod('Function Read( var Buf, Count : integer) : integer');
    RegisterMethod('Function Available : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileStream2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSeekableStream', 'TFileStream2') do
  with CL.AddClassN(CL.FindClass('TSeekableStream'),'TFileStream2') do
  begin
    RegisterMethod('Constructor Create( filename : string; mode : TfsModes)');
    RegisterMethod('Constructor Create1( FileHandle : THandle)');
     RegisterMethod('Procedure Free;');

    RegisterMethod('Procedure Delete');
    RegisterMethod('Function Write( var Buf : string; Count : integer) : integer');
    RegisterMethod('Function Read( var Buf : string; Count : integer) : integer');
    RegisterMethod('Function Write2(Buf : string; Count : integer) : integer');
    RegisterMethod('Function Read2(Buf : string; Count : integer) : integer');
    RegisterMethod('Function Available : integer');
    RegisterMethod('procedure Flush'); //override;
    RegisterMethod('Procedure Seek( loc : integer)');
    RegisterMethod('Procedure Truncate');
    RegisterProperty('Attributes', 'TFileAttributes2', iptrw);
    RegisterProperty('LastWriteTime', 'TFileTime', iptrw);
    RegisterProperty('FileName', 'string', iptr);
    RegisterProperty('FileHandle', 'THandle', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSeekableStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseStream', 'TSeekableStream') do
  with CL.AddClassN(CL.FindClass('TBaseStream'),'TSeekableStream') do
  begin
    RegisterMethod('Procedure Seek( loc : integer)');
    RegisterProperty('Position', 'integer', iptrw);
    RegisterProperty('Size', 'integer', iptr);
    RegisterMethod('Procedure Truncate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFilterStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseStream', 'TFilterStream') do
  with CL.AddClassN(CL.FindClass('TBaseStream'),'TFilterStream') do begin
    RegisterMethod('Constructor Create( InOutStream : TBaseStream)');
    RegisterMethod('Function Write( var Buf : string; Count : integer) : integer');
    RegisterMethod('Function Read( var Buf : string; Count : integer) : integer');
    RegisterMethod('Function Available : Integer');
    RegisterMethod('Procedure FreeAll');
     RegisterMethod('Procedure Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBaseStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMonitorObject', 'TBaseStream') do
  with CL.AddClassN(CL.FindClass('TMonitorObject'),'TBaseStream') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Write( var Buf, Count : integer) : integer');
    RegisterMethod('Function Read( var Buf : string; Count : integer) : integer');
    RegisterMethod('Function EOS : boolean');
    RegisterMethod('Function Available : integer');
    RegisterMethod('Procedure Flush');
    RegisterMethod('Procedure CopyFrom( Source : TBaseStream)');
    RegisterProperty('CanRead', 'boolean', iptr);
    RegisterProperty('CanWrite', 'boolean', iptr);
    RegisterProperty('NoDataExcept', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Streams(CL: TPSPascalCompiler);
begin
  SIRegister_TBaseStream(CL);
  SIRegister_TFilterStream(CL);
  SIRegister_TSeekableStream(CL);
  //CL.AddTypeS('TFileAttributes2', 'set of ( sfaArchive, sfaHidden, sfaSystem, sf'
   //+'aReadOnly, sfaTemporary, sfaCompressed, sfaDirectory )');

 CL.AddTypeS('TFileAttribute2', '(sfaArchive, sfaHidden, sfaSystem,sfaReadOnly,sfaTemporary,sfaCompressed, sfaDirectory)');
   CL.AddTypeS('TFileAttributes2', 'set of TFileAttribute2');
  CL.AddTypeS('TfsMode','(sfsRead, sfsWrite, sfsCreate, sfsShareRead, sfsShareWrite)');
  CL.AddTypeS('TfsModes', 'set of TfsMode');

 // CL.AddTypeS('TfsModes', 'set of ( fsRead, fsWrite, fsCreate, fsShareRead, fsShareWrite )');
 CL.AddConstantN('fsReset','LongInt').Value.ts32 := ord(fsRead) or ord(fsWrite);
 CL.AddConstantN('fsShared','LongInt').Value.ts32 := ord(fsShareRead) or ord(fsShareWrite);
  SIRegister_TFileStream2(CL);
  SIRegister_TDummyStream(CL);
 CL.AddDelphiFunction('Procedure CopyStream( Source, Dest : TBaseStream; const Size : Integer)');
 CL.AddDelphiFunction('Function GetLastErrorText : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TFileStream2FileHandle_R(Self: TFileStream2; var T: THandle);
begin T := Self.FileHandle; end;

(*----------------------------------------------------------------------------*)
procedure TFileStream2FileName_R(Self: TFileStream2; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TFileStream2LastWriteTime_W(Self: TFileStream2; const T: TFileTime);
begin Self.LastWriteTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileStream2LastWriteTime_R(Self: TFileStream2; var T: TFileTime);
begin T := Self.LastWriteTime; end;

(*----------------------------------------------------------------------------*)
procedure TFileStream2Attributes_W(Self: TFileStream2; const T: TFileAttributes);
begin Self.Attributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileStream2Attributes_R(Self: TFileStream2; var T: TFileAttributes);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure TSeekableStreamSize_R(Self: TSeekableStream; var T: integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TSeekableStreamPosition_W(Self: TSeekableStream; const T: integer);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeekableStreamPosition_R(Self: TSeekableStream; var T: integer);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TBaseStreamNoDataExcept_W(Self: TBaseStream; const T: boolean);
begin Self.NoDataExcept := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseStreamNoDataExcept_R(Self: TBaseStream; var T: boolean);
begin T := Self.NoDataExcept; end;

(*----------------------------------------------------------------------------*)
procedure TBaseStreamCanWrite_R(Self: TBaseStream; var T: boolean);
begin T := Self.CanWrite; end;

(*----------------------------------------------------------------------------*)
procedure TBaseStreamCanRead_R(Self: TBaseStream; var T: boolean);
begin T := Self.CanRead; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Streams_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CopyStream, 'CopyStream', cdRegister);
 S.RegisterDelphiFunction(@GetLastErrorText, 'GetLastErrorText', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDummyStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDummyStream) do
  begin
    RegisterConstructor(@TDummyStream.Create, 'Create');
    RegisterMethod(@TDummyStream.Write, 'Write');
    RegisterMethod(@TDummyStream.Read, 'Read');
    RegisterMethod(@TDummyStream.Available, 'Available');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileStream2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileStream2) do begin
    RegisterConstructor(@TFileStream2.Create, 'Create');
    RegisterConstructor(@TFileStream2.Create1, 'Create1');
     RegisterMethod(@TFileStream2.Destroy, 'Free');

    RegisterVirtualMethod(@TFileStream2.Delete, 'Delete');
    RegisterMethod(@TFileStream2.Write, 'Write');
    RegisterMethod(@TFileStream2.Read, 'Read');
    RegisterMethod(@TFileStream2.Write2, 'Write2');
    RegisterMethod(@TFileStream2.Read2, 'Read2');

    RegisterMethod(@TFileStream2.Available, 'Available');
    RegisterMethod(@TFileStream2.Seek, 'Seek');
    RegisterMethod(@TFileStream2.Flush, 'Flush');

    RegisterMethod(@TFileStream2.Truncate, 'Truncate');
    RegisterPropertyHelper(@TFileStream2Attributes_R,@TFileStream2Attributes_W,'Attributes');
    RegisterPropertyHelper(@TFileStream2LastWriteTime_R,@TFileStream2LastWriteTime_W,'LastWriteTime');
    RegisterPropertyHelper(@TFileStream2FileName_R,nil,'FileName');
    RegisterPropertyHelper(@TFileStream2FileHandle_R,nil,'FileHandle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSeekableStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSeekableStream) do
  begin
    //RegisterVirtualAbstractMethod(@TSeekableStream, @!.Seek, 'Seek');
    RegisterPropertyHelper(@TSeekableStreamPosition_R,@TSeekableStreamPosition_W,'Position');
    RegisterPropertyHelper(@TSeekableStreamSize_R,nil,'Size');
    //RegisterVirtualAbstractMethod(@TSeekableStream, @!.Truncate, 'Truncate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFilterStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFilterStream) do begin
    RegisterConstructor(@TFilterStream.Create, 'Create');
    RegisterMethod(@TFilterStream.Write, 'Write');
    RegisterMethod(@TFilterStream.Read, 'Read');
    RegisterMethod(@TFilterStream.Available, 'Available');
    RegisterMethod(@TFilterStream.FreeAll, 'FreeAll');
    RegisterMethod(@TFilterStream.FreeAll, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBaseStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseStream) do
  begin
    RegisterConstructor(@TBaseStream.Create, 'Create');
    //RegisterVirtualAbstractMethod(@TBaseStream, @!.Write, 'Write');
    //RegisterVirtualAbstractMethod(@TBaseStream, @!.Read, 'Read');
    RegisterVirtualMethod(@TBaseStream.EOS, 'EOS');
    //RegisterVirtualAbstractMethod(@TBaseStream, @!.Available, 'Available');
    RegisterVirtualMethod(@TBaseStream.Flush, 'Flush');
    RegisterVirtualMethod(@TBaseStream.CopyFrom, 'CopyFrom');
    RegisterPropertyHelper(@TBaseStreamCanRead_R,nil,'CanRead');
    RegisterPropertyHelper(@TBaseStreamCanWrite_R,nil,'CanWrite');
    RegisterPropertyHelper(@TBaseStreamNoDataExcept_R,@TBaseStreamNoDataExcept_W,'NoDataExcept');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Streams(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBaseStream(CL);
  RIRegister_TFilterStream(CL);
  RIRegister_TSeekableStream(CL);
  RIRegister_TFileStream2(CL);
  RIRegister_TDummyStream(CL);
end;

 
 
{ TPSImport_Streams }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Streams.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Streams(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Streams.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Streams(ri);
  RIRegister_Streams_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
