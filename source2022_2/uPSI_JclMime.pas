unit uPSI_JclMime;
{
  another base64
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
  TPSImport_JclMime = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclMime(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclMime_Routines(S: TPSExec);

procedure Register;

implementation


uses
   JclMime
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclMime]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclMime(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function MimeEncodeString( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function MimeDecodeString( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure MimeEncodeStream( const InputStream : TStream; const OutputStream : TStream)');
 CL.AddDelphiFunction('Procedure MimeDecodeStream( const InputStream : TStream; const OutputStream : TStream)');
 CL.AddDelphiFunction('Function MimeEncodedSize( const I : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function MimeDecodedSize( const I : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Procedure MimeEncode( var InputBuffer : string; const InputByteCount : Cardinal; var OutputBuffer: string)');
 CL.AddDelphiFunction('Function MimeDecode( var InputBuffer : string; const InputBytesCount : Cardinal; var OutputBuffer: string) : Cardinal');
 CL.AddDelphiFunction('Function MimeDecodePartial( var InputBuffer : string; const InputBytesCount : Cardinal; var OutputBuffer : string; var ByteBuffer : Cardinal; var ByteBufferSpace : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function MimeDecodePartialEnd( var OutputBuffer : string; const ByteBuffer : Cardinal; const ByteBufferSpace : Cardinal) : Cardinal');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JclMime_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MimeEncodeString, 'MimeEncodeString', cdRegister);
 S.RegisterDelphiFunction(@MimeDecodeString, 'MimeDecodeString', cdRegister);
 S.RegisterDelphiFunction(@MimeEncodeStream, 'MimeEncodeStream', cdRegister);
 S.RegisterDelphiFunction(@MimeDecodeStream, 'MimeDecodeStream', cdRegister);
 S.RegisterDelphiFunction(@MimeEncodedSize, 'MimeEncodedSize', cdRegister);
 S.RegisterDelphiFunction(@MimeDecodedSize, 'MimeDecodedSize', cdRegister);
 S.RegisterDelphiFunction(@MimeEncode, 'MimeEncode', cdRegister);
 S.RegisterDelphiFunction(@MimeDecode, 'MimeDecode', cdRegister);
 S.RegisterDelphiFunction(@MimeDecodePartial, 'MimeDecodePartial', cdRegister);
 S.RegisterDelphiFunction(@MimeDecodePartialEnd, 'MimeDecodePartialEnd', cdRegister);
end;

 
 
{ TPSImport_JclMime }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMime.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclMime(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMime.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclMime(ri);
  RIRegister_JclMime_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
