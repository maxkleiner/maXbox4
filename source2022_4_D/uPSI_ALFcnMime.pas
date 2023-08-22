unit uPSI_ALFcnMime;
{
   mime to shine
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
  TPSImport_ALFcnMime = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ALFcnMime(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALFcnMime_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Types
  ,ALStringList
  ,ALFcnMime
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFcnMime]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFcnMime(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('NativeInt', 'Integer');
  CL.AddTypeS('NativeUInt', 'Cardinal');
 CL.AddDelphiFunction('Function ALMimeBase64EncodeString( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALMimeBase64EncodeStringNoCRLF( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALMimeBase64DecodeString( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALMimeBase64EncodedSize( const InputSize : NativeInt) : NativeInt');
 CL.AddDelphiFunction('Function ALMimeBase64EncodedSizeNoCRLF( const InputSize : NativeInt) : NativeInt');
 CL.AddDelphiFunction('Function ALMimeBase64DecodedSize( const InputSize : NativeInt) : NativeInt');
 CL.AddDelphiFunction('Procedure ALMimeBase64Encode( const InputBuffer : TByteDynArray; InputOffset : NativeInt; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray; OutputOffset : NativeInt)');
 CL.AddDelphiFunction('Procedure ALMimeBase64EncodeNoCRLF( const InputBuffer : TByteDynArray; InputOffset : NativeInt; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray; OutputOffset : NativeInt)');
 CL.AddDelphiFunction('Procedure ALMimeBase64EncodeFullLines( const InputBuffer : TByteDynArray; InputOffset : NativeInt; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray; OutputOffset : NativeInt)');
 CL.AddDelphiFunction('Function ALMimeBase64Decode( const InputBuffer : TByteDynArray; InputOffset : NativeInt; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray; OutputOffset : NativeInt) : NativeInt;');
 CL.AddDelphiFunction('Function ALMimeBase64DecodePartial( const InputBuffer : TByteDynArray; InputOffset : NativeInt; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray; OutputOffset : NativeInt;'
 + 'var ByteBuffer : Cardinal; var ByteBufferSpace : Cardinal) : NativeInt;');
 CL.AddDelphiFunction('Function ALMimeBase64DecodePartialEnd( out OutputBuffer : TByteDynArray; OutputOffset : NativeInt; const ByteBuffer : Cardinal; const ByteBufferSpace : Cardinal) : NativeInt;');
 CL.AddDelphiFunction('Procedure ALMimeBase64Encode( const InputBuffer : TByteDynArray; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray);');
 CL.AddDelphiFunction('Procedure ALMimeBase64EncodeNoCRLF( const InputBuffer : TByteDynArray; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray);');
 CL.AddDelphiFunction('Procedure ALMimeBase64EncodeFullLines( const InputBuffer : TByteDynArray; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray);');
 CL.AddDelphiFunction('Function ALMimeBase64Decode1( const InputBuffer : TByteDynArray; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray) : NativeInt;');
 CL.AddDelphiFunction('Function ALMimeBase64DecodePartial1( const InputBuffer : TByteDynArray; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray; var ByteBuffer : Cardinal; var ByteBufferSpace : Cardinal) : NativeInt;');
 CL.AddDelphiFunction('Function ALMimeBase64DecodePartialEnd1( out OutputBuffer : TByteDynArray; const ByteBuffer : Cardinal; const ByteBufferSpace : Cardinal) : NativeInt;');
 CL.AddDelphiFunction('Procedure ALMimeBase64EncodeFile( const InputFileName, OutputFileName : TFileName)');
 CL.AddDelphiFunction('Procedure ALMimeBase64EncodeFileNoCRLF( const InputFileName, OutputFileName : TFileName)');
 CL.AddDelphiFunction('Procedure ALMimeBase64DecodeFile( const InputFileName, OutputFileName : TFileName)');
 CL.AddDelphiFunction('Procedure ALMimeBase64EncodeStream( const InputStream : TStream; const OutputStream : TStream)');
 CL.AddDelphiFunction('Procedure ALMimeBase64EncodeStreamNoCRLF( const InputStream : TStream; const OutputStream : TStream)');
 CL.AddDelphiFunction('Procedure ALMimeBase64DecodeStream( const InputStream : TStream; const OutputStream : TStream)');
 CL.AddConstantN('cALMimeBase64_ENCODED_LINE_BREAK','LongInt').SetInt( 76);
 CL.AddConstantN('cALMimeBase64_DECODED_LINE_BREAK','LongInt').SetInt( cALMimeBase64_ENCODED_LINE_BREAK div 4 * 3);
 CL.AddConstantN('cALMimeBase64_BUFFER_SIZE','LongInt').SetInt( cALMimeBase64_DECODED_LINE_BREAK * 3 * 4 * 4);
 CL.AddDelphiFunction('Procedure ALFillMimeContentTypeByExtList( AMIMEList : TALStrings)');
 CL.AddDelphiFunction('Procedure ALFillExtByMimeContentTypeList( AMIMEList : TALStrings)');
 CL.AddDelphiFunction('Function ALGetDefaultFileExtFromMimeContentType( aContentType : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALGetDefaultMIMEContentTypeFromExt( aExt : AnsiString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ALMimeBase64DecodePartialEnd1_P( out OutputBuffer : TByteDynArray; const ByteBuffer : Cardinal; const ByteBufferSpace : Cardinal) : NativeInt;
Begin Result := ALFcnMime.ALMimeBase64DecodePartialEnd(OutputBuffer, ByteBuffer, ByteBufferSpace); END;

(*----------------------------------------------------------------------------*)
Function ALMimeBase64DecodePartial1_P( const InputBuffer : TByteDynArray; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray; var ByteBuffer : Cardinal; var ByteBufferSpace : Cardinal) : NativeInt;
Begin Result := ALFcnMime.ALMimeBase64DecodePartial(InputBuffer, InputByteCount, OutputBuffer, ByteBuffer, ByteBufferSpace); END;

(*----------------------------------------------------------------------------*)
Function ALMimeBase64Decode1_P( const InputBuffer : TByteDynArray; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray) : NativeInt;
Begin Result := ALFcnMime.ALMimeBase64Decode(InputBuffer, InputByteCount, OutputBuffer); END;

(*----------------------------------------------------------------------------*)
Procedure ALMimeBase64EncodeFullLines_P( const InputBuffer : TByteDynArray; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray);
Begin ALFcnMime.ALMimeBase64EncodeFullLines(InputBuffer, InputByteCount, OutputBuffer); END;

(*----------------------------------------------------------------------------*)
Procedure ALMimeBase64EncodeNoCRLF_P( const InputBuffer : TByteDynArray; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray);
Begin ALFcnMime.ALMimeBase64EncodeNoCRLF(InputBuffer, InputByteCount, OutputBuffer); END;

(*----------------------------------------------------------------------------*)
Procedure ALMimeBase64Encode_P( const InputBuffer : TByteDynArray; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray);
Begin ALFcnMime.ALMimeBase64Encode(InputBuffer, InputByteCount, OutputBuffer); END;

(*----------------------------------------------------------------------------*)
Function ALMimeBase64DecodePartialEnd_P( out OutputBuffer : TByteDynArray; OutputOffset : NativeInt; const ByteBuffer : Cardinal; const ByteBufferSpace : Cardinal) : NativeInt;
Begin Result := ALFcnMime.ALMimeBase64DecodePartialEnd(OutputBuffer, OutputOffset, ByteBuffer, ByteBufferSpace); END;

(*----------------------------------------------------------------------------*)
Function ALMimeBase64DecodePartial_P( const InputBuffer : TByteDynArray; InputOffset : NativeInt; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray; OutputOffset : NativeInt; var ByteBuffer : Cardinal; var ByteBufferSpace : Cardinal) : NativeInt;
Begin Result := ALFcnMime.ALMimeBase64DecodePartial(InputBuffer, InputOffset, InputByteCount, OutputBuffer, OutputOffset, ByteBuffer, ByteBufferSpace); END;

(*----------------------------------------------------------------------------*)
Function ALMimeBase64Decode_P( const InputBuffer : TByteDynArray; InputOffset : NativeInt; const InputByteCount : NativeInt; out OutputBuffer : TByteDynArray; OutputOffset : NativeInt) : NativeInt;
Begin Result := ALFcnMime.ALMimeBase64Decode(InputBuffer, InputOffset, InputByteCount, OutputBuffer, OutputOffset); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFcnMime_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ALMimeBase64EncodeString, 'ALMimeBase64EncodeString', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64EncodeStringNoCRLF, 'ALMimeBase64EncodeStringNoCRLF', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64DecodeString, 'ALMimeBase64DecodeString', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64EncodedSize, 'ALMimeBase64EncodedSize', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64EncodedSizeNoCRLF, 'ALMimeBase64EncodedSizeNoCRLF', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64DecodedSize, 'ALMimeBase64DecodedSize', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64Encode, 'ALMimeBase64Encode', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64EncodeNoCRLF, 'ALMimeBase64EncodeNoCRLF', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64EncodeFullLines, 'ALMimeBase64EncodeFullLines', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64Decode, 'ALMimeBase64Decode', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64DecodePartial, 'ALMimeBase64DecodePartial', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64DecodePartialEnd, 'ALMimeBase64DecodePartialEnd', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64Encode, 'ALMimeBase64Encode', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64EncodeNoCRLF, 'ALMimeBase64EncodeNoCRLF', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64EncodeFullLines, 'ALMimeBase64EncodeFullLines', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64Decode1_P, 'ALMimeBase64Decode1', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64DecodePartial1_P, 'ALMimeBase64DecodePartial1', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64DecodePartialEnd1_P, 'ALMimeBase64DecodePartialEnd1', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64EncodeFile, 'ALMimeBase64EncodeFile', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64EncodeFileNoCRLF, 'ALMimeBase64EncodeFileNoCRLF', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64DecodeFile, 'ALMimeBase64DecodeFile', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64EncodeStream, 'ALMimeBase64EncodeStream', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64EncodeStreamNoCRLF, 'ALMimeBase64EncodeStreamNoCRLF', cdRegister);
 S.RegisterDelphiFunction(@ALMimeBase64DecodeStream, 'ALMimeBase64DecodeStream', cdRegister);
 S.RegisterDelphiFunction(@ALFillMimeContentTypeByExtList, 'ALFillMimeContentTypeByExtList', cdRegister);
 S.RegisterDelphiFunction(@ALFillExtByMimeContentTypeList, 'ALFillExtByMimeContentTypeList', cdRegister);
 S.RegisterDelphiFunction(@ALGetDefaultFileExtFromMimeContentType, 'ALGetDefaultFileExtFromMimeContentType', cdRegister);
 S.RegisterDelphiFunction(@ALGetDefaultMIMEContentTypeFromExt, 'ALGetDefaultMIMEContentTypeFromExt', cdRegister);
end;

 
 
{ TPSImport_ALFcnMime }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnMime.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFcnMime(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnMime.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ALFcnMime(ri);
  RIRegister_ALFcnMime_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
