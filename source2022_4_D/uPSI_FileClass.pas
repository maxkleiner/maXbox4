unit uPSI_FileClass;
{
     another file manager
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
  TPSImport_FileClass = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_EFileError(CL: TPSPascalCompiler);
procedure SIRegister_TFileMapping(CL: TPSPascalCompiler);
procedure SIRegister_TTextFileWriter(CL: TPSPascalCompiler);
procedure SIRegister_TTextFileReader(CL: TPSPascalCompiler);
procedure SIRegister_TMemoryFile(CL: TPSPascalCompiler);
procedure SIRegister_TIFile(CL: TPSPascalCompiler);
procedure SIRegister_TCustomFile(CL: TPSPascalCompiler);
procedure SIRegister_FileClass(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_EFileError(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFileMapping(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTextFileWriter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTextFileReader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMemoryFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_FileClass(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Int64Em
  ,FileClass2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FileClass]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EFileError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EFileError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EFileError') do
  begin
    RegisterProperty('ErrorCode', 'DWORD', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileMapping(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TFileMapping') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TFileMapping') do
  begin
    RegisterMethod('Constructor Create( AFile : TFile; AWritable : Boolean)');
    RegisterMethod('Procedure Commit');
    RegisterMethod('Procedure ReraiseInPageErrorAsFileException');
    RegisterProperty('MapSize', 'Cardinal', iptr);
    RegisterProperty('Memory', 'Pointer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTextFileWriter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIFile', 'TTextFileWriter') do
  with CL.AddClassN(CL.FindClass('TIFile'),'TTextFileWriter') do
  begin
    RegisterMethod('Procedure Write( const S : String)');
    RegisterMethod('Procedure WriteLine( const S : String)');
    RegisterMethod('Procedure WriteAnsi( const S : AnsiString)');
    RegisterMethod('Procedure WriteAnsiLine( const S : AnsiString)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTextFileReader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIFile', 'TTextFileReader') do
  with CL.AddClassN(CL.FindClass('TIFile'),'TTextFileReader') do
  begin
    RegisterMethod('Function ReadLine : String');
    RegisterMethod('Function ReadAnsiLine : AnsiString');
    RegisterProperty('Eof', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMemoryFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomFile', 'TMemoryFile') do
  with CL.AddClassN(CL.FindClass('TCustomFile'),'TMemoryFile') do
  begin
    RegisterMethod('Constructor Create( const AFilename : String)');
    RegisterMethod('Constructor CreateFromMemory( const ASource : string; const ASize : Cardinal)');
    RegisterMethod('Constructor CreateFromZero( const ASize : Cardinal)');
    RegisterProperty('Memory', 'Pointer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomFile', 'TIFile') do
  with CL.AddClassN(CL.FindClass('TCustomFile'),'TIFile') do
  begin
    RegisterMethod('Constructor Create( const AFilename : String; ACreateDisposition : TFileCreateDisposition; AAccess : TFileAccess; ASharing : TFileSharing)');
    RegisterMethod('Constructor CreateWithExistingHandle( const AHandle : THandle)');
    RegisterMethod('Procedure SeekToEnd');
    RegisterMethod('Procedure Truncate');
    RegisterProperty('Handle', 'THandle', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCustomFile') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomFile') do
  begin
    RegisterMethod('Procedure RaiseError( ErrorCode : DWORD)');
    RegisterMethod('Procedure RaiseLastError');
    RegisterMethod('Function Read( var Buffer, Count : Cardinal) : Cardinal');
    RegisterMethod('Procedure ReadBuffer( var Buffer, Count : Cardinal)');
    RegisterMethod('Procedure Seek( Offset : Cardinal)');
    RegisterMethod('Procedure Seek64( Offset : Integer64)');
    RegisterMethod('Procedure WriteAnsiString( const S : AnsiString)');
    RegisterMethod('Procedure WriteBuffer( const Buffer, Count : Cardinal)');
    RegisterProperty('CappedSize', 'Cardinal', iptr);
    RegisterProperty('Position', 'Integer64', iptr);
    RegisterProperty('Size', 'Integer64', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_FileClass(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TFileCreateDisposition', '( fdCreateAlways, fdCreateNew, fdOpenE'
   +'xisting, fdOpenAlways, fdTruncateExisting )');
  CL.AddTypeS('TIFileAccess', '( faRead, faWrite, faReadWrite )');
  CL.AddTypeS('TIFileSharing', '( fsNone, fsRead, fsWrite, fsReadWrite )');
  SIRegister_TCustomFile(CL);
  SIRegister_TIFile(CL);
  SIRegister_TMemoryFile(CL);
  SIRegister_TTextFileReader(CL);
  SIRegister_TTextFileWriter(CL);
  SIRegister_TFileMapping(CL);
  SIRegister_EFileError(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure EFileErrorErrorCode_R(Self: EFileError; var T: DWORD);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TFileMappingMemory_R(Self: TFileMapping; var T: Pointer);
begin T := Self.Memory; end;

(*----------------------------------------------------------------------------*)
procedure TFileMappingMapSize_R(Self: TFileMapping; var T: Cardinal);
begin T := Self.MapSize; end;

(*----------------------------------------------------------------------------*)
procedure TTextFileReaderEof_R(Self: TTextFileReader; var T: Boolean);
begin T := Self.Eof; end;

(*----------------------------------------------------------------------------*)
procedure TMemoryFileMemory_R(Self: TMemoryFile; var T: string);
begin T := Self.Memory; end;

(*----------------------------------------------------------------------------*)
procedure TIFileHandle_R(Self: TIFile; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileSize_R(Self: TCustomFile; var T: Integer64);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFilePosition_R(Self: TCustomFile; var T: Integer64);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileCappedSize_R(Self: TCustomFile; var T: Cardinal);
begin T := Self.CappedSize; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EFileError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EFileError) do
  begin
    RegisterPropertyHelper(@EFileErrorErrorCode_R,nil,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileMapping(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileMapping) do
  begin
    RegisterConstructor(@TFileMapping.Create, 'Create');
    RegisterMethod(@TFileMapping.Commit, 'Commit');
    RegisterMethod(@TFileMapping.ReraiseInPageErrorAsFileException, 'ReraiseInPageErrorAsFileException');
    RegisterPropertyHelper(@TFileMappingMapSize_R,nil,'MapSize');
    RegisterPropertyHelper(@TFileMappingMemory_R,nil,'Memory');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTextFileWriter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTextFileWriter) do
  begin
    RegisterMethod(@TTextFileWriter.Write, 'Write');
    RegisterMethod(@TTextFileWriter.WriteLine, 'WriteLine');
    //RegisterMethod(@TTextFileWriter.WriteAnsi, 'WriteAnsi');
    //RegisterMethod(@TTextFileWriter.WriteAnsiLine, 'WriteAnsiLine');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTextFileReader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTextFileReader) do
  begin
    RegisterMethod(@TTextFileReader.ReadLine, 'ReadLine');
    //RegisterMethod(@TTextFileReader.ReadAnsiLine, 'ReadAnsiLine');
    RegisterPropertyHelper(@TTextFileReaderEof_R,nil,'Eof');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMemoryFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMemoryFile) do
  begin
    RegisterConstructor(@TMemoryFile.Create, 'Create');
    RegisterConstructor(@TMemoryFile.CreateFromMemory, 'CreateFromMemory');
    RegisterConstructor(@TMemoryFile.CreateFromZero, 'CreateFromZero');
    RegisterPropertyHelper(@TMemoryFileMemory_R,nil,'Memory');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIFile) do
  begin
    RegisterConstructor(@TIFile.Create, 'Create');
    RegisterConstructor(@TIFile.CreateWithExistingHandle, 'CreateWithExistingHandle');
    RegisterMethod(@TIFile.SeekToEnd, 'SeekToEnd');
    RegisterMethod(@TIFile.Truncate, 'Truncate');
    RegisterPropertyHelper(@TIFileHandle_R,nil,'Handle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomFile) do
  begin
    RegisterMethod(@TCustomFile.RaiseError, 'RaiseError');
    RegisterMethod(@TCustomFile.RaiseLastError, 'RaiseLastError');
    //RegisterVirtualAbstractMethod(@TCustomFile, @!.Read, 'Read');
    RegisterMethod(@TCustomFile.ReadBuffer, 'ReadBuffer');
    RegisterMethod(@TCustomFile.Seek, 'Seek');
    //RegisterVirtualAbstractMethod(@TCustomFile, @!.Seek64, 'Seek64');
    RegisterMethod(@TCustomFile.WriteAnsiString, 'WriteAnsiString');
   // RegisterVirtualAbstractMethod(@TCustomFile, @!.WriteBuffer, 'WriteBuffer');
    RegisterPropertyHelper(@TCustomFileCappedSize_R,nil,'CappedSize');
    RegisterPropertyHelper(@TCustomFilePosition_R,nil,'Position');
    RegisterPropertyHelper(@TCustomFileSize_R,nil,'Size');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FileClass(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomFile(CL);
  RIRegister_TIFile(CL);
  RIRegister_TMemoryFile(CL);
  RIRegister_TTextFileReader(CL);
  RIRegister_TTextFileWriter(CL);
  RIRegister_TFileMapping(CL);
  RIRegister_EFileError(CL);
end;

 
 
{ TPSImport_FileClass }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileClass.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FileClass(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileClass.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FileClass(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
