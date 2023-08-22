unit uPSI_StStrms;
{
  SysTools4  , add free methods  , streamreader  , seek+write
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
  TPSImport_StStrms = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStMemoryMappedFile(CL: TPSPascalCompiler);
procedure SIRegister_TStAnsiTextStream(CL: TPSPascalCompiler);
procedure SIRegister_TStBufferedStream(CL: TPSPascalCompiler);
procedure SIRegister_StStrms(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStMemoryMappedFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStAnsiTextStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStBufferedStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_StStrms(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StBase
  ,StConst
  ,StStrms
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StStrms]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStMemoryMappedFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TStMemoryMappedFile') do
  with CL.AddClassN(CL.FindClass('TStream'),'TStMemoryMappedFile') do begin
    RegisterMethod('Constructor Create( const FileName : string; MaxSize : Cardinal; ReadOnly : Boolean; SharedData : Boolean)');
    RegisterMethod('Procedure Free');
    RegisterMethod('function Read(var Buffer: string; Count : longint) : longint;');
    RegisterMethod('function Seek(Offset : longint; Origin : word) : longint;');
    RegisterMethod('function Write(const Buffer: string; Count : longint) : longint;');
    { function Read(var Buffer; Count : longint) : longint; override;
      function Seek(Offset : longint; Origin : word) : longint; override;
      function Write(const Buffer; Count : longint) : longint; override;
     }
    RegisterProperty('DataSize', 'Cardinal', iptr);
    RegisterProperty('MaxSize', 'Cardinal', iptr);
    RegisterProperty('Position', 'Cardinal', iptr);
    RegisterProperty('ReadOnly', 'Boolean', iptr);
    RegisterProperty('SharedData', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStAnsiTextStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStBufferedStream', 'TStAnsiTextStream') do
  with CL.AddClassN(CL.FindClass('TStBufferedStream'),'TStAnsiTextStream') do begin
    RegisterMethod('Constructor Create( aStream : TStream)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function AtEndOfStream : boolean');
    RegisterMethod('Function ReadLine : string');
    RegisterMethod('Function ReadLineArray( aCharArray : PAnsiChar; aLen : TStMemSize) : TStMemSize');
    RegisterMethod('Function ReadLineZ( aSt : PAnsiChar; aMaxLen : TStMemSize) : PAnsiChar');
    RegisterMethod('Function SeekNearestLine( aOffset : longint) : longint');
    RegisterMethod('Function SeekLine( aLineNum : longint) : longint');
    RegisterMethod('Procedure WriteLine( const aSt : string)');
    RegisterMethod('Procedure WriteLineArray( aCharArray : PAnsiChar; aLen : TStMemSize)');
    RegisterMethod('Procedure WriteLineZ( aSt : PAnsiChar)');
    RegisterProperty('FixedLineLength', 'integer', iptrw);
    RegisterProperty('LineCount', 'longint', iptr);
    RegisterProperty('LineTermChar', 'AnsiChar', iptrw);
    RegisterProperty('LineTerminator', 'TStLineTerminator', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStBufferedStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TStBufferedStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TStBufferedStream') do begin
    RegisterMethod('Constructor Create( aStream : TStream)');
    RegisterMethod('Procedure Free');
   RegisterMethod('function Read(var Buffer: string; Count : longint) : longint;');
    RegisterMethod('function Seek(Offset : longint; Origin : word) : longint;');
    RegisterMethod('function Write(const Buffer: string; Count : longint) : longint;');
    RegisterMethod('Constructor CreateEmpty');
    RegisterMethod('Procedure SetSize( NewSize : longint)');
    RegisterProperty('FastSize', 'longint', iptr);
    RegisterProperty('Stream', 'TStream', iptrw);
    RegisterProperty('OnSetStreamSize', 'TStSetStreamSize', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StStrms(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStMemSize', 'Integer');

  SIRegister_TStBufferedStream(CL);
  SIRegister_TStAnsiTextStream(CL);
  SIRegister_TStMemoryMappedFile(CL);
  CL.AddTypeS('TStreamReader', 'TStAnsiTextStream');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStMemoryMappedFileSharedData_R(Self: TStMemoryMappedFile; var T: Boolean);
begin T := Self.SharedData; end;

(*----------------------------------------------------------------------------*)
procedure TStMemoryMappedFileReadOnly_R(Self: TStMemoryMappedFile; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TStMemoryMappedFilePosition_R(Self: TStMemoryMappedFile; var T: Cardinal);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TStMemoryMappedFileMaxSize_R(Self: TStMemoryMappedFile; var T: Cardinal);
begin T := Self.MaxSize; end;

(*----------------------------------------------------------------------------*)
procedure TStMemoryMappedFileDataSize_R(Self: TStMemoryMappedFile; var T: Cardinal);
begin T := Self.DataSize; end;

(*----------------------------------------------------------------------------*)
procedure TStAnsiTextStreamLineTerminator_W(Self: TStAnsiTextStream; const T: TStLineTerminator);
begin Self.LineTerminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStAnsiTextStreamLineTerminator_R(Self: TStAnsiTextStream; var T: TStLineTerminator);
begin T := Self.LineTerminator; end;

(*----------------------------------------------------------------------------*)
procedure TStAnsiTextStreamLineTermChar_W(Self: TStAnsiTextStream; const T: AnsiChar);
begin Self.LineTermChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStAnsiTextStreamLineTermChar_R(Self: TStAnsiTextStream; var T: AnsiChar);
begin T := Self.LineTermChar; end;

(*----------------------------------------------------------------------------*)
procedure TStAnsiTextStreamLineCount_R(Self: TStAnsiTextStream; var T: longint);
begin T := Self.LineCount; end;

(*----------------------------------------------------------------------------*)
procedure TStAnsiTextStreamFixedLineLength_W(Self: TStAnsiTextStream; const T: integer);
begin Self.FixedLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TStAnsiTextStreamFixedLineLength_R(Self: TStAnsiTextStream; var T: integer);
begin T := Self.FixedLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TStBufferedStreamOnSetStreamSize_W(Self: TStBufferedStream; const T: Longint);
begin //Self.OnSetStreamSize := T;
 end;

(*----------------------------------------------------------------------------*)
procedure TStBufferedStreamOnSetStreamSize_R(Self: TStBufferedStream; var T: Longint);
begin //T := Self.OnSetStreamSize;
 end;

(*----------------------------------------------------------------------------*)
procedure TStBufferedStreamStream_W(Self: TStBufferedStream; const T: TStream);
begin Self.Stream := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBufferedStreamStream_R(Self: TStBufferedStream; var T: TStream);
begin T := Self.Stream; end;

(*----------------------------------------------------------------------------*)
procedure TStBufferedStreamFastSize_R(Self: TStBufferedStream; var T: longint);
begin T := Self.FastSize; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStMemoryMappedFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStMemoryMappedFile) do begin
    RegisterConstructor(@TStMemoryMappedFile.Create, 'Create');
    RegisterMethod(@TStMemoryMappedFile.Destroy, 'Free');
     RegisterMethod(@TStMemoryMappedFile.Read, 'Read');
    RegisterMethod(@TStMemoryMappedFile.Seek, 'Seek');
     RegisterMethod(@TStMemoryMappedFile.Write, 'Write');
      RegisterPropertyHelper(@TStMemoryMappedFileDataSize_R,nil,'DataSize');
    RegisterPropertyHelper(@TStMemoryMappedFileMaxSize_R,nil,'MaxSize');
    RegisterPropertyHelper(@TStMemoryMappedFilePosition_R,nil,'Position');
    RegisterPropertyHelper(@TStMemoryMappedFileReadOnly_R,nil,'ReadOnly');
    RegisterPropertyHelper(@TStMemoryMappedFileSharedData_R,nil,'SharedData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStAnsiTextStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStAnsiTextStream) do begin
    RegisterConstructor(@TStAnsiTextStream.Create, 'Create');
    RegisterMethod(@TStAnsiTextStream.Destroy, 'Free');
    RegisterMethod(@TStAnsiTextStream.AtEndOfStream, 'AtEndOfStream');
    RegisterMethod(@TStAnsiTextStream.ReadLine, 'ReadLine');
    RegisterMethod(@TStAnsiTextStream.ReadLineArray, 'ReadLineArray');
    RegisterMethod(@TStAnsiTextStream.ReadLineZ, 'ReadLineZ');
    RegisterMethod(@TStAnsiTextStream.SeekNearestLine, 'SeekNearestLine');
    RegisterMethod(@TStAnsiTextStream.SeekLine, 'SeekLine');
    RegisterMethod(@TStAnsiTextStream.WriteLine, 'WriteLine');
    RegisterMethod(@TStAnsiTextStream.WriteLineArray, 'WriteLineArray');
    RegisterMethod(@TStAnsiTextStream.WriteLineZ, 'WriteLineZ');
    RegisterPropertyHelper(@TStAnsiTextStreamFixedLineLength_R,@TStAnsiTextStreamFixedLineLength_W,'FixedLineLength');
    RegisterPropertyHelper(@TStAnsiTextStreamLineCount_R,nil,'LineCount');
    RegisterPropertyHelper(@TStAnsiTextStreamLineTermChar_R,@TStAnsiTextStreamLineTermChar_W,'LineTermChar');
    RegisterPropertyHelper(@TStAnsiTextStreamLineTerminator_R,@TStAnsiTextStreamLineTerminator_W,'LineTerminator');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStBufferedStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStBufferedStream) do begin
    RegisterConstructor(@TStBufferedStream.Create, 'Create');
    RegisterConstructor(@TStBufferedStream.CreateEmpty, 'CreateEmpty');
    RegisterMethod(@TStBufferedStream.Destroy, 'Free');
     RegisterMethod(@TStBufferedStream.Read, 'Read');
    RegisterMethod(@TStBufferedStream.Seek, 'Seek');
     RegisterMethod(@TStBufferedStream.Write, 'Write');
      //RegisterMethod(@TStBufferedStream.SetSize, 'SetSize');
    RegisterPropertyHelper(@TStBufferedStreamFastSize_R,nil,'FastSize');
    RegisterPropertyHelper(@TStBufferedStreamStream_R,@TStBufferedStreamStream_W,'Stream');
    RegisterPropertyHelper(@TStBufferedStreamOnSetStreamSize_R,@TStBufferedStreamOnSetStreamSize_W,'OnSetStreamSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StStrms(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStBufferedStream(CL);
  RIRegister_TStAnsiTextStream(CL);
  RIRegister_TStMemoryMappedFile(CL);
end;

 
 
{ TPSImport_StStrms }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StStrms.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StStrms(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StStrms.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StStrms(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
