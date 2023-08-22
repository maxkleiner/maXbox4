unit uPSI_uTPLb_CodecIntf;
{
Tfo code box lity

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
  TPSImport_uTPLb_CodecIntf = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ICodec(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_CodecIntf(CL: TPSPascalCompiler);

{ run-time registration functions }

procedure Register;

implementation


uses
   uTPLb_StreamCipher
  ,uTPLb_BlockCipher
  ,uTPLb_CryptographicLibrary
  ,uTPLb_CodecIntf
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_CodecIntf]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ICodec(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ICodec') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ICodec, 'ICodec') do
  begin
    RegisterMethod('Procedure SetStreamCipher( const Value : IStreamCipher)', cdRegister);
    RegisterMethod('Procedure SetBlockCipher( const Value : IBlockCipher)', cdRegister);
    RegisterMethod('Procedure SetChainMode( const Value : IBlockChainingModel)', cdRegister);
    RegisterMethod('Function GetMode : TCodecMode', cdRegister);
    RegisterMethod('Function GetStreamCipher : IStreamCipher', cdRegister);
    RegisterMethod('Function GetBlockCipher : IBlockCipher', cdRegister);
    RegisterMethod('Function GetChainMode : IBlockChainingModel', cdRegister);
    RegisterMethod('Function GetOnProgress : TOnEncDecProgress', cdRegister);
    RegisterMethod('Procedure SetOnProgress( Value : TOnEncDecProgress)', cdRegister);
    RegisterMethod('Function GetAsymetricKeySizeInBits : cardinal', cdRegister);
    RegisterMethod('Procedure SetAsymetricKeySizeInBits( value : cardinal)', cdRegister);
    RegisterMethod('Function GetAsymGenProgressEvent : TGenerateAsymetricKeyPairProgress', cdRegister);
    RegisterMethod('Procedure SetAsymGenProgressEvent( Value : TGenerateAsymetricKeyPairProgress)', cdRegister);
    RegisterMethod('Function GetKey : TSymetricKey', cdRegister);
    RegisterMethod('Function GetCipherDisplayName( Lib : TCryptographicLibrary) : string', cdRegister);
    RegisterMethod('Procedure Init( const Key : string)', cdRegister);
    RegisterMethod('Procedure InitA( const Key : utf8string)', cdRegister);
    RegisterMethod('Procedure SaveKeyToStream( Store : TStream)', cdRegister);
    RegisterMethod('Procedure InitFromStream( Store : TStream)', cdRegister);
    RegisterMethod('Procedure InitFromKey( Key : TSymetricKey)', cdRegister);
    RegisterMethod('Procedure Reset', cdRegister);
    RegisterMethod('Procedure Burn( doIncludeBurnKey : boolean)', cdRegister);
    RegisterMethod('Function isAsymetric : boolean', cdRegister);
    RegisterMethod('Procedure InitFromGeneratedAsymetricKeyPair', cdRegister);
    RegisterMethod('Procedure Sign( Document, Signature : TStream; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; SigningKeys_PrivatePart : TObject; var wasAborted : boolean)', cdRegister);
    RegisterMethod('Function VerifySignature( Document, Signature : TStream; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; SigningKeys_PublicPart : TObject; var wasAborted : boolean) : boolean', cdRegister);
    RegisterMethod('Procedure Begin_EncryptMemory( CipherText : TStream)', cdRegister);
    RegisterMethod('Procedure EncryptMemory( const Plaintext, PlaintextLen : integer)', cdRegister);
    RegisterMethod('Procedure End_EncryptMemory', cdRegister);
    RegisterMethod('Procedure Begin_DecryptMemory( PlainText : TStream)', cdRegister);
    RegisterMethod('Procedure DecryptMemory( const CipherText, CiphertextLen : integer)', cdRegister);
    RegisterMethod('Procedure End_DecryptMemory', cdRegister);
    RegisterMethod('Procedure EncryptStream( Plaintext, CipherText : TStream)', cdRegister);
    RegisterMethod('Procedure DecryptStream( Plaintext, CipherText : TStream)', cdRegister);
    RegisterMethod('Procedure EncryptFile( const Plaintext_FileName, CipherText_FileName : string)', cdRegister);
    RegisterMethod('Procedure DecryptFile( const Plaintext_FileName, CipherText_FileName : string)', cdRegister);
    RegisterMethod('Procedure EncryptString( const Plaintext : string; var CipherText_Base64 : ansistring)', cdRegister);
    RegisterMethod('Procedure DecryptString( var Plaintext : string; const CipherText_Base64 : ansistring)', cdRegister);
    RegisterMethod('Procedure EncryptAnsiString( const Plaintext : ansistring; var CipherText_Base64 : ansistring)', cdRegister);
    RegisterMethod('Procedure DecryptAnsiString( var Plaintext : ansistring; const CipherText_Base64 : ansistring)', cdRegister);
    RegisterMethod('Function GetAborted : boolean', cdRegister);
    RegisterMethod('Procedure SetAborted( Value : boolean)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_CodecIntf(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCodecMode', '( cmUnitialized, cmIdle, cmEncrypting, cmDecrypting )');
  CL.AddTypeS('TOnEncDecProgress', 'Function ( Sender : TObject; CountBytesProcessed : int64) : boolean');
  CL.AddTypeS('TGenerateAsymetricKeyPairProgress', 'Procedure ( Sender : TObjec'
   +'t; CountPrimalityTests : integer; var doAbort : boolean)');
  SIRegister_ICodec(CL);
end;

(* === run-time registration functions === *)
 
 
{ TPSImport_uTPLb_CodecIntf }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_CodecIntf.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_CodecIntf(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_CodecIntf.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
