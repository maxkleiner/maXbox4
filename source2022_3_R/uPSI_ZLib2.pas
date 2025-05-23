unit uPSI_ZLib;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_ZLib = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TZDecompressionStream(CL: TPSPascalCompiler);
procedure SIRegister_TZCompressionStream(CL: TPSPascalCompiler);
procedure SIRegister_TCustomZStream(CL: TPSPascalCompiler);
procedure SIRegister_ZLib(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ZLib_Routines(S: TPSExec);
procedure RIRegister_TZDecompressionStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TZCompressionStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomZStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_ZLib(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ZLib
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZLib]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TZDecompressionStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomZStream', 'TZDecompressionStream') do
  with CL.AddClassN(CL.FindClass('TCustomZStream'),'TZDecompressionStream') do
  begin
    RegisterMethod('Constructor Create( source : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TZCompressionStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomZStream', 'TZCompressionStream') do
  with CL.AddClassN(CL.FindClass('TCustomZStream'),'TZCompressionStream') do
  begin
    RegisterMethod('Constructor Create( dest : TStream; compressionLevel : TZCompressionLevel);');
    RegisterMethod('Constructor Create1( compressionLevel : TCompressionLevel; dest : TStream);');
    RegisterProperty('CompressionRate', 'Single', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomZStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TCustomZStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TCustomZStream') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ZLib(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ZLIB_VERSION','String').SetString( '1.2.3');
  CL.AddTypeS('TZCompressionLevel', '( zcNone, zcFastest, zcDefault, zcMax )');
  CL.AddTypeS('TCompressionLevel', '( clNone, clFastest, clDefault, clMax )');
  CL.AddTypeS('TZStreamRec', 'record next_in : PAnsiChar; avail_in : Longint; t'
   +'otal_in : Longint; next_out : PAnsiChar; avail_out : Longint; total_out : '
   +'Longint; msg : PAnsiChar; state : Pointer; zalloc : TZAlloc; zfree : TZFre'
   +'e; opaque : Pointer; data_type : Integer; adler : Longint; reserved : Long'
   +'int; end');
  SIRegister_TCustomZStream(CL);
  CL.AddTypeS('TCustomZLibStream', 'TCustomZStream');
  SIRegister_TZCompressionStream(CL);
  CL.AddTypeS('TCompressionStream', 'TZCompressionStream');
  SIRegister_TZDecompressionStream(CL);
  CL.AddTypeS('TDecompressionStream', 'TZDecompressionStream');
 CL.AddDelphiFunction('Procedure ZCompress( const inBuffer : Pointer; inSize : Integer; out outBuffer : Pointer; out outSize : Integer; level : TZCompressionLevel);');
 CL.AddDelphiFunction('Procedure ZCompress1( const inBuffer : Pointer; inSize : Integer; out outBuffer : Pointer; out outSize : Integer; level : TCompressionLevel);');
 CL.AddDelphiFunction('Procedure ZDecompress( const inBuffer : Pointer; inSize : Integer; out outBuffer : Pointer; out outSize : Integer; outEstimate : Integer)');
 CL.AddDelphiFunction('Function ZCompressStr( const s : string; level : TZCompressionLevel) : TBytes;');
 CL.AddDelphiFunction('Function ZCompressStr1( const s : string; level : TCompressionLevel) : TBytes;');
 CL.AddDelphiFunction('Function ZDecompressStr( const s : TBytes) : string');
 CL.AddDelphiFunction('Procedure ZCompressStream( inStream, outStream : TStream; level : TZCompressionLevel);');
 CL.AddDelphiFunction('Procedure ZCompressStream1( inStream, outStream : TStream; level : TCompressionLevel);');
 CL.AddDelphiFunction('Procedure ZDecompressStream( inStream, outStream : TStream)');
 CL.AddDelphiFunction('Function zlibAllocMem( AppData : Pointer; Items, Size : Integer) : Pointer');
 CL.AddDelphiFunction('Procedure zlibFreeMem( AppData, Block : Pointer)');
 CL.AddDelphiFunction('Function adler32( adler : LongInt; const buf : PChar; len : Integer) : LongInt');
 CL.AddDelphiFunction('Procedure MoveI32( const Source : string; var Dest, Count : Integer)');
 CL.AddDelphiFunction('Procedure ZSendToBrowser( var s : string)');
 CL.AddDelphiFunction('Function deflateInit_( var strm : TZStreamRec; level : Integer; version : PChar; recsize : Integer) : Integer');
 CL.AddDelphiFunction('Function DeflateInit2_( var strm : TZStreamRec; level : integer; method : integer; windowBits : integer; memLevel : integer; strategy : integer; version : PChar; recsize : integer) : integer');
 CL.AddDelphiFunction('Function deflate( var strm : TZStreamRec; flush : Integer) : Integer');
 CL.AddDelphiFunction('Function deflateEnd( var strm : TZStreamRec) : Integer');
 CL.AddDelphiFunction('Function inflateInit_( var strm : TZStreamRec; version : PChar; recsize : Integer) : Integer');
 CL.AddDelphiFunction('Function inflateInit2_( var strm : TZStreamRec; windowBits : integer; version : PChar; recsize : integer) : integer');
 CL.AddDelphiFunction('Function inflate( var strm : TZStreamRec; flush : Integer) : Integer');
 CL.AddDelphiFunction('Function inflateEnd( var strm : TZStreamRec) : Integer');
 CL.AddDelphiFunction('Function inflateReset( var strm : TZStreamRec) : Integer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EZLibError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EZCompressionError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EZDecompressionError');
 CL.AddConstantN('Z_NO_FLUSH','LongInt').SetInt( 0);
 CL.AddConstantN('Z_PARTIAL_FLUSH','LongInt').SetInt( 1);
 CL.AddConstantN('Z_SYNC_FLUSH','LongInt').SetInt( 2);
 CL.AddConstantN('Z_FULL_FLUSH','LongInt').SetInt( 3);
 CL.AddConstantN('Z_FINISH','LongInt').SetInt( 4);
 CL.AddConstantN('Z_OK','LongInt').SetInt( 0);
 CL.AddConstantN('Z_STREAM_END','LongInt').SetInt( 1);
 CL.AddConstantN('Z_NEED_DICT','LongInt').SetInt( 2);
 CL.AddConstantN('Z_ERRNO','LongInt').SetInt( ( - 1 ));
 CL.AddConstantN('Z_STREAM_ERROR','LongInt').SetInt( ( - 2 ));
 CL.AddConstantN('Z_DATA_ERROR','LongInt').SetInt( ( - 3 ));
 CL.AddConstantN('Z_MEM_ERROR','LongInt').SetInt( ( - 4 ));
 CL.AddConstantN('Z_BUF_ERROR','LongInt').SetInt( ( - 5 ));
 CL.AddConstantN('Z_VERSION_ERROR','LongInt').SetInt( ( - 6 ));
 CL.AddConstantN('Z_NO_COMPRESSION','LongInt').SetInt( 0);
 CL.AddConstantN('Z_BEST_SPEED','LongInt').SetInt( 1);
 CL.AddConstantN('Z_BEST_COMPRESSION','LongInt').SetInt( 9);
 CL.AddConstantN('Z_DEFAULT_COMPRESSION','LongInt').SetInt( ( - 1 ));
 CL.AddConstantN('Z_FILTERED','LongInt').SetInt( 1);
 CL.AddConstantN('Z_HUFFMAN_ONLY','LongInt').SetInt( 2);
 CL.AddConstantN('Z_DEFAULT_STRATEGY','LongInt').SetInt( 0);
 CL.AddConstantN('Z_BINARY','LongInt').SetInt( 0);
 CL.AddConstantN('Z_ASCII','LongInt').SetInt( 1);
 CL.AddConstantN('Z_UNKNOWN','LongInt').SetInt( 2);
 CL.AddConstantN('Z_DEFLATED','LongInt').SetInt( 8);
 CL.AddConstantN('SZInvalid','String').SetString( 'Invalid ZStream operation!');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure ZCompressStream1_P( inStream, outStream : TStream; level : TCompressionLevel);
Begin ZLib.ZCompressStream(inStream, outStream, level); END;

(*----------------------------------------------------------------------------*)
Procedure ZCompressStream_P( inStream, outStream : TStream; level : TZCompressionLevel);
Begin ZLib.ZCompressStream(inStream, outStream, level); END;

(*----------------------------------------------------------------------------*)
Function ZCompressStr1_P( const s : string; level : TCompressionLevel) : TBytes;
Begin Result := ZLib.ZCompressStr(s, level); END;

(*----------------------------------------------------------------------------*)
Function ZCompressStr_P( const s : string; level : TZCompressionLevel) : TBytes;
Begin Result := ZLib.ZCompressStr(s, level); END;

(*----------------------------------------------------------------------------*)
Procedure ZCompress1_P( const inBuffer : Pointer; inSize : Integer; out outBuffer : Pointer; out outSize : Integer; level : TCompressionLevel);
Begin ZLib.ZCompress(inBuffer, inSize, outBuffer, outSize, level); END;

(*----------------------------------------------------------------------------*)
Procedure ZCompress_P( const inBuffer : Pointer; inSize : Integer; out outBuffer : Pointer; out outSize : Integer; level : TZCompressionLevel);
Begin ZLib.ZCompress(inBuffer, inSize, outBuffer, outSize, level); END;

(*----------------------------------------------------------------------------*)
procedure TZCompressionStreamCompressionRate_R(Self: TZCompressionStream; var T: Single);
begin T := Self.CompressionRate; end;

(*----------------------------------------------------------------------------*)
Function TZCompressionStreamCreate1_P(Self: TClass; CreateNewInstance: Boolean;  compressionLevel : TCompressionLevel; dest : TStream):TObject;
Begin Result := TZCompressionStream.Create(compressionLevel, dest); END;

(*----------------------------------------------------------------------------*)
Function TZCompressionStreamCreate_P(Self: TClass; CreateNewInstance: Boolean;  dest : TStream; compressionLevel : TZCompressionLevel):TObject;
Begin Result := TZCompressionStream.Create(dest, compressionLevel); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZLib_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ZCompress, 'ZCompress', cdRegister);
 S.RegisterDelphiFunction(@ZCompress1, 'ZCompress1', cdRegister);
 S.RegisterDelphiFunction(@ZDecompress, 'ZDecompress', cdRegister);
 S.RegisterDelphiFunction(@ZCompressStr, 'ZCompressStr', cdRegister);
 S.RegisterDelphiFunction(@ZCompressStr1, 'ZCompressStr1', cdRegister);
 S.RegisterDelphiFunction(@ZDecompressStr, 'ZDecompressStr', cdRegister);
 S.RegisterDelphiFunction(@ZCompressStream, 'ZCompressStream', cdRegister);
 S.RegisterDelphiFunction(@ZCompressStream1, 'ZCompressStream1', cdRegister);
 S.RegisterDelphiFunction(@ZDecompressStream, 'ZDecompressStream', cdRegister);
 S.RegisterDelphiFunction(@zlibAllocMem, 'zlibAllocMem', cdRegister);
 S.RegisterDelphiFunction(@zlibFreeMem, 'zlibFreeMem', cdRegister);
 S.RegisterDelphiFunction(@adler32, 'adler32', cdRegister);
 S.RegisterDelphiFunction(@MoveI32, 'MoveI32', cdRegister);
 S.RegisterDelphiFunction(@ZSendToBrowser, 'ZSendToBrowser', cdRegister);
 S.RegisterDelphiFunction(@deflateInit_, 'deflateInit_', cdRegister);
 S.RegisterDelphiFunction(@DeflateInit2_, 'DeflateInit2_', cdRegister);
 S.RegisterDelphiFunction(@deflate, 'deflate', cdRegister);
 S.RegisterDelphiFunction(@deflateEnd, 'deflateEnd', cdRegister);
 S.RegisterDelphiFunction(@inflateInit_, 'inflateInit_', cdRegister);
 S.RegisterDelphiFunction(@inflateInit2_, 'inflateInit2_', cdRegister);
 S.RegisterDelphiFunction(@inflate, 'inflate', cdRegister);
 S.RegisterDelphiFunction(@inflateEnd, 'inflateEnd', cdRegister);
 S.RegisterDelphiFunction(@inflateReset, 'inflateReset', cdRegister);
  with CL.Add(EZLibError) do
  with CL.Add(EZCompressionError) do
  with CL.Add(EZDecompressionError) do
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZDecompressionStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZDecompressionStream) do
  begin
    RegisterConstructor(@TZDecompressionStream.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZCompressionStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZCompressionStream) do
  begin
    RegisterConstructor(@TZCompressionStreamCreate_P, 'Create');
    RegisterConstructor(@TZCompressionStreamCreate1_P, 'Create1');
    RegisterPropertyHelper(@TZCompressionStreamCompressionRate_R,nil,'CompressionRate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomZStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomZStream) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZLib(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomZStream(CL);
  RIRegister_TZCompressionStream(CL);
  RIRegister_TZDecompressionStream(CL);
end;

 
 
{ TPSImport_ZLib }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZLib.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZLib(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZLib.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ZLib(ri);
  RIRegister_ZLib_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
