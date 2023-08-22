unit uPSI_DBXClient;
{
   DBXConnect
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
  TPSImport_DBXClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDBXClientWideCharsValue(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientParameterRow(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientRow(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientReader(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientByteReader(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientCommand(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientBytesStream(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientBlobStream(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientExtendedStream(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientConnection(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientTransaction(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientDriver(CL: TPSPascalCompiler);
procedure SIRegister_TDBXClientDriverLoader(CL: TPSPascalCompiler);
procedure SIRegister_DBXClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDBXClientWideCharsValue(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientParameterRow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientRow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientReader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientByteReader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientCommand(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientBytesStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientBlobStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientExtendedStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientTransaction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientDriver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXClientDriverLoader(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBXClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DBXCommon
  ,DBXDelegate
  ,DBXChannel
  ,DBXDataStoreReadOnlyMetaData
  ,DBXRowBuffer
  ,DbxJSonStreamWriter
  ,DbxErrorHandler
  ,DbxTraceHandler
  ,DbxJSonStreamReader
  ,DbxTokens
  ,DbxStringCodes
  ,DBXSocketChannelNative
  ,DBXPlatform
  ,DBPlatform
  ,DBCommonTypes
  ,FMTBcd
  ,SqlTimSt
  ,ClassRegistry
  ,Contnrs
  ,WideStrings
  ,DBXClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBXClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientWideCharsValue(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXWideCharsValueEx', 'TDBXClientWideCharsValue') do
  with CL.AddClassN(CL.FindClass('TDBXWideCharsValueEx'),'TDBXClientWideCharsValue') do
  begin
    RegisterMethod('Constructor Create( ValueType : TDBXValueType)');
    RegisterMethod('Function GetValueSize : Int64');
    RegisterMethod('Function GetBytes( Offset : Int64; const Value : TBytes; BufferOffset, Length : Int64) : Int64;');
    RegisterMethod('Function GetAnsiString : String');
    RegisterMethod('Procedure SetAnsiString( const Value : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientParameterRow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXClientRow', 'TDBXClientParameterRow') do
  with CL.AddClassN(CL.FindClass('TDBXClientRow'),'TDBXClientParameterRow') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientRow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXRowEx', 'TDBXClientRow') do
  with CL.AddClassN(CL.FindClass('TDBXRowEx'),'TDBXClientRow') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientReader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXReader', 'TDBXClientReader') do
  with CL.AddClassN(CL.FindClass('TDBXReader'),'TDBXClientReader') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientByteReader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXReaderByteReader', 'TDBXClientByteReader') do
  with CL.AddClassN(CL.FindClass('TDBXReaderByteReader'),'TDBXClientByteReader') do
  begin
    RegisterMethod('Procedure GetAnsiString( Ordinal : TInt32; const Value : TBytes; Offset : TInt32; var IsNull : LongBool)');
    RegisterMethod('Procedure GetWideString( Ordinal : TInt32; const Value : TBytes; Offset : TInt32; var IsNull : LongBool)');
    RegisterMethod('Procedure GetInt16( Ordinal : TInt32; const Value : TBytes; Offset : TInt32; var IsNull : LongBool)');
    RegisterMethod('Procedure GetInt32( Ordinal : TInt32; const Value : TBytes; Offset : TInt32; var IsNull : LongBool)');
    RegisterMethod('Procedure GetInt64( Ordinal : TInt32; const Value : TBytes; Offset : TInt32; var IsNull : LongBool)');
    RegisterMethod('Procedure GetDouble( Ordinal : TInt32; const Value : TBytes; Offset : TInt32; var IsNull : LongBool)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientCommand(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXCommandEx', 'TDBXClientCommand') do
  with CL.AddClassN(CL.FindClass('TDBXCommandEx'),'TDBXClientCommand') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientBytesStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXClientExtendedStream', 'TDBXClientBytesStream') do
  with CL.AddClassN(CL.FindClass('TDBXClientExtendedStream'),'TDBXClientBytesStream') do
  begin
    RegisterMethod('Function Read( var Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Write( const Buffer, Count : Longint) : Longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientBlobStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXClientExtendedStream', 'TDBXClientBlobStream') do
  with CL.AddClassN(CL.FindClass('TDBXClientExtendedStream'),'TDBXClientBlobStream') do
  begin
    RegisterMethod('Function Read( var Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Write( const Buffer, Count : Longint) : Longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientExtendedStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TDBXClientExtendedStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TDBXClientExtendedStream') do
  begin
    RegisterMethod('Function ReadBytes( const Buffer : TBytes; Offset, Count : Longint) : Longint');
    RegisterMethod('Function Seek( Offset : Longint; Origin : Word) : Longint;');
    RegisterMethod('Function Seek1( const Offset : Int64; Origin : TSeekOrigin) : Int64;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXConnectionEx', 'TDBXClientConnection') do
  with CL.AddClassN(CL.FindClass('TDBXConnectionEx'),'TDBXClientConnection') do
  begin
    RegisterMethod('Constructor Create( ConnectionBuilder : TDBXConnectionBuilder)');
    RegisterMethod('Function GetVendorProperty( const Name : WideString) : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientTransaction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXTransaction', 'TDBXClientTransaction') do
  with CL.AddClassN(CL.FindClass('TDBXTransaction'),'TDBXClientTransaction') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientDriver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDriverEx', 'TDBXClientDriver') do
  with CL.AddClassN(CL.FindClass('TDBXDriverEx'),'TDBXClientDriver') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function GetDriverVersion : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXClientDriverLoader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDriverLoader', 'TDBXClientDriverLoader') do
  with CL.AddClassN(CL.FindClass('TDBXDriverLoader'),'TDBXClientDriverLoader') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBXClient(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TDBXClientDriverLoaderClass', 'class of TObject');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDBXClientConnection');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDBXClientCommand');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDBXClientRow');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDBXClientReader');
  SIRegister_TDBXClientDriverLoader(CL);
  SIRegister_TDBXClientDriver(CL);
  SIRegister_TDBXClientTransaction(CL);
  SIRegister_TDBXClientConnection(CL);
  SIRegister_TDBXClientExtendedStream(CL);
  SIRegister_TDBXClientBlobStream(CL);
  SIRegister_TDBXClientBytesStream(CL);
  SIRegister_TDBXClientCommand(CL);
  SIRegister_TDBXClientByteReader(CL);
  SIRegister_TDBXClientReader(CL);
  SIRegister_TDBXClientRow(CL);
  SIRegister_TDBXClientParameterRow(CL);
  SIRegister_TDBXClientWideCharsValue(CL);
 CL.AddConstantN('SCLIENT_LOADER_NAME','String').SetString( 'Borland.Data.' + 'TDBXClientDriverLoader');
 CL.AddConstantN('SCLIENT_LOADER_NAME','String').SetString( 'TDBXClientDriverLoader');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TDBXClientWideCharsValueGetBytes_P(Self: TDBXClientWideCharsValue;  Offset : Int64; const Value : TBytes; BufferOffset, Length : Int64) : Int64;
Begin Result := Self.GetBytes(Offset, Value, BufferOffset, Length); END;

(*----------------------------------------------------------------------------*)
Procedure TDBXClientParameterRowGetStream1_P(Self: TDBXClientParameterRow;  DbxValue : TDBXWideStringValue; var Stream : TStream; var IsNull : LongBool);
Begin //Self.GetStream(DbxValue, Stream, IsNull);
 END;

(*----------------------------------------------------------------------------*)
Procedure TDBXClientParameterRowGetStream_P(Self: TDBXClientParameterRow;  DbxValue : TDBXStreamValue; var Stream : TStream; var IsNull : LongBool);
Begin //Self.GetStream(DbxValue, Stream, IsNull);
END;

(*----------------------------------------------------------------------------*)
Procedure TDBXClientRowSetStream_P(Self: TDBXClientRow;  DbxValue : TDBXStreamValue; StreamReader : TDBXStreamReader);
Begin //Self.SetStream(DbxValue, StreamReader);
END;

(*----------------------------------------------------------------------------*)
Procedure TDBXClientRowGetStream1_P(Self: TDBXClientRow;  DbxValue : TDBXWideStringValue; var Stream : TStream; var IsNull : LongBool);
Begin //Self.GetStream(DbxValue, Stream, IsNull);
END;

(*----------------------------------------------------------------------------*)
Procedure TDBXClientRowGetStream_P(Self: TDBXClientRow;  DbxValue : TDBXStreamValue; var Stream : TStream; var IsNull : LongBool);
Begin //Self.GetStream(DbxValue, Stream, IsNull);
END;

(*----------------------------------------------------------------------------*)
Function TDBXClientExtendedStreamSeek1_P(Self: TDBXClientExtendedStream;  const Offset : Int64; Origin : TSeekOrigin) : Int64;
Begin Result := Self.Seek(Offset, Origin); END;

(*----------------------------------------------------------------------------*)
Function TDBXClientExtendedStreamSeek_P(Self: TDBXClientExtendedStream;  Offset : Longint; Origin : Word) : Longint;
Begin Result := Self.Seek(Offset, Origin); END;

(*----------------------------------------------------------------------------*)
Function TDBXClientConnectionDerivedCreateCommand_P(Self: TDBXClientConnection) : TDBXCommand;
Begin //Result := Self.DerivedCreateCommand;
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientWideCharsValue(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientWideCharsValue) do begin
    RegisterConstructor(@TDBXClientWideCharsValue.Create, 'Create');
    RegisterMethod(@TDBXClientWideCharsValue.GetValueSize, 'GetValueSize');
    RegisterMethod(@TDBXClientWideCharsValueGetBytes_P, 'GetBytes');
    RegisterMethod(@TDBXClientWideCharsValue.GetAnsiString, 'GetAnsiString');
    RegisterMethod(@TDBXClientWideCharsValue.SetAnsiString, 'SetAnsiString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientParameterRow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientParameterRow) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientRow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientRow) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientReader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientReader) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientByteReader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientByteReader) do
  begin
    RegisterMethod(@TDBXClientByteReader.GetAnsiString, 'GetAnsiString');
    RegisterMethod(@TDBXClientByteReader.GetWideString, 'GetWideString');
    RegisterMethod(@TDBXClientByteReader.GetInt16, 'GetInt16');
    RegisterMethod(@TDBXClientByteReader.GetInt32, 'GetInt32');
    RegisterMethod(@TDBXClientByteReader.GetInt64, 'GetInt64');
    RegisterMethod(@TDBXClientByteReader.GetDouble, 'GetDouble');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientCommand(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientCommand) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientBytesStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientBytesStream) do
  begin
    RegisterMethod(@TDBXClientBytesStream.Read, 'Read');
    RegisterMethod(@TDBXClientBytesStream.Write, 'Write');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientBlobStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientBlobStream) do
  begin
    RegisterMethod(@TDBXClientBlobStream.Read, 'Read');
    RegisterMethod(@TDBXClientBlobStream.Write, 'Write');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientExtendedStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientExtendedStream) do begin
    //RegisterVirtualAbstractMethod(@TDBXClientExtendedStream, @!.ReadBytes, 'ReadBytes');
    RegisterMethod(@TDBXClientExtendedStreamSeek_P, 'Seek');
    RegisterMethod(@TDBXClientExtendedStreamSeek1_P, 'Seek1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientConnection) do
  begin
    RegisterConstructor(@TDBXClientConnection.Create, 'Create');
    RegisterMethod(@TDBXClientConnection.GetVendorProperty, 'GetVendorProperty');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientTransaction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientTransaction) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientDriver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientDriver) do
  begin
    RegisterConstructor(@TDBXClientDriver.Create, 'Create');
    RegisterMethod(@TDBXClientDriver.GetDriverVersion, 'GetDriverVersion');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXClientDriverLoader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientDriverLoader) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBXClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXClientConnection) do
  with CL.Add(TDBXClientCommand) do
  with CL.Add(TDBXClientRow) do
  with CL.Add(TDBXClientReader) do
  RIRegister_TDBXClientDriverLoader(CL);
  RIRegister_TDBXClientDriver(CL);
  RIRegister_TDBXClientTransaction(CL);
  RIRegister_TDBXClientConnection(CL);
  RIRegister_TDBXClientExtendedStream(CL);
  RIRegister_TDBXClientBlobStream(CL);
  RIRegister_TDBXClientBytesStream(CL);
  RIRegister_TDBXClientCommand(CL);
  RIRegister_TDBXClientByteReader(CL);
  RIRegister_TDBXClientReader(CL);
  RIRegister_TDBXClientRow(CL);
  RIRegister_TDBXClientParameterRow(CL);
  RIRegister_TDBXClientWideCharsValue(CL);
end;

 
 
{ TPSImport_DBXClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBXClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBXClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBXClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBXClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
