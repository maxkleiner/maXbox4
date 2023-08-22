unit uPSI_cTLSUtils;
{
  test suite
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
  TPSImport_cTLSUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_ETLSError(CL: TPSPascalCompiler);
procedure SIRegister_cTLSUtils(CL: TPSPascalCompiler);
//procedure SIRegister_TAnsiStringBuilder(CL: TPSPascalCompiler);


{ run-time registration functions }
procedure RIRegister_ETLSError(CL: TPSRuntimeClassImporter);
procedure RIRegister_cTLSUtils_Routines(S: TPSExec);
//procedure RIRegister_TAnsiStringBuilder(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cTLSUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cTLSUtils]);
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ETLSError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ETLSError') do
  with CL.AddClassN(CL.FindClass('Exception'),'ETLSError') do begin
    RegisterMethod('Constructor Create( const TLSError : Integer; const Msg : String)');
    RegisterProperty('TLSError', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cTLSUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('TLSLibraryVersion','String').SetString( '1.00');
 CL.AddConstantN('TLSError_None','LongInt').SetInt( 0);
 CL.AddConstantN('TLSError_InvalidBuffer','LongInt').SetInt( 1);
 CL.AddConstantN('TLSError_InvalidParameter','LongInt').SetInt( 2);
 CL.AddConstantN('TLSError_InvalidCertificate','LongInt').SetInt( 3);
 CL.AddConstantN('TLSError_InvalidState','LongInt').SetInt( 4);
 CL.AddConstantN('TLSError_DecodeError','LongInt').SetInt( 5);
 CL.AddConstantN('TLSError_BadProtocol','LongInt').SetInt( 6);
 CL.AddDelphiFunction('Function TLSErrorMessage( const TLSError : Integer) : String');
  SIRegister_ETLSError(CL);
  CL.AddTypeS('TTLSProtocolVersion', 'record major : Byte; minor : Byte; end');
  CL.AddTypeS('TTLSRandom', 'record gmt_unix_time : LongWord;random_bytes  : array[0..27] of Byte; end');

  {  TTLSRandom = packed record
    gmt_unix_time : LongWord;
    random_bytes  : array[0..27] of Byte;
  end;}
  //type
  //TTLSSessionID = String[TLSSessionIDMaxLen];
 CL.AddTypeS('TTLSSessionID','shortstring');

 // CL.AddTypeS('PTLSProtocolVersion', '^TTLSProtocolVersion // will not work');
 CL.AddDelphiFunction('Procedure InitSSLProtocolVersion30( var A : TTLSProtocolVersion)');
 CL.AddDelphiFunction('Procedure InitTLSProtocolVersion10( var A : TTLSProtocolVersion)');
 CL.AddDelphiFunction('Procedure InitTLSProtocolVersion11( var A : TTLSProtocolVersion)');
 CL.AddDelphiFunction('Procedure InitTLSProtocolVersion12( var A : TTLSProtocolVersion)');
 CL.AddDelphiFunction('Function IsTLSProtocolVersion( const A, B : TTLSProtocolVersion) : Boolean');
 CL.AddDelphiFunction('Function IsSSL2( const A : TTLSProtocolVersion) : Boolean');
 CL.AddDelphiFunction('Function IsSSL3( const A : TTLSProtocolVersion) : Boolean');
 CL.AddDelphiFunction('Function IsTLS10( const A : TTLSProtocolVersion) : Boolean');
 CL.AddDelphiFunction('Function IsTLS11( const A : TTLSProtocolVersion) : Boolean');
 CL.AddDelphiFunction('Function IsTLS12( const A : TTLSProtocolVersion) : Boolean');
 CL.AddDelphiFunction('Function IsTLS10OrLater( const A : TTLSProtocolVersion) : Boolean');
 CL.AddDelphiFunction('Function IsTLS11OrLater( const A : TTLSProtocolVersion) : Boolean');
 CL.AddDelphiFunction('Function IsTLS12OrLater( const A : TTLSProtocolVersion) : Boolean');
 CL.AddDelphiFunction('Function IsFutureTLSVersion( const A : TTLSProtocolVersion) : Boolean');
 CL.AddDelphiFunction('Function IsKnownTLSVersion( const A : TTLSProtocolVersion) : Boolean');
 CL.AddDelphiFunction('Function TLSProtocolVersionToStr( const A : TTLSProtocolVersion) : String');
 CL.AddDelphiFunction('Function TLSProtocolVersionName( const A : TTLSProtocolVersion) : String');
 // CL.AddTypeS('PTLSRandom', '^TTLSRandom // will not work');
 CL.AddDelphiFunction('Procedure InitTLSRandom( var Random : TTLSRandom)');
 CL.AddDelphiFunction('Function TLSRandomToStr( const Random : TTLSRandom) : AnsiString');
 CL.AddConstantN('TLSSessionIDMaxLen','LongInt').SetInt( 32);
 CL.AddDelphiFunction('Procedure InitTLSSessionID( var SessionID : TTLSSessionID; const A : AnsiString)');
 CL.AddDelphiFunction('Function EncodeTLSSessionID( var Buffer : string; const Size : Integer; const SessionID : TTLSSessionID) : Integer');
 CL.AddDelphiFunction('Function DecodeTLSSessionID( const Buffer : string; const Size : Integer; var SessionID : TTLSSessionID) : Integer');
  //CL.AddTypeS('TTLSSignatureAndHashAlgorithm', 'record Hash : TTLSHashAlgorithm'
  // +'; Signature : TTLSSignatureAlgorithm; end');
 // CL.AddTypeS('PTLSSignatureAndHashAlgorithm', '^TTLSSignatureAndHashAlgorithm '
  // +'// will not work');
  //CL.AddTypeS('TTLSSignatureAndHashAlgorithmArray', 'array of TTLSSignatureAndHashAlgorithm');
  CL.AddTypeS('TTLSKeyExchangeAlgorithm', '( tlskeaNone, tlskeaNULL, tlskeaDHE_'
   +'DSS, tlskeaDHE_RSA, tlskeaDH_Anon, tlskeaRSA, tlskeaDH_DSS, tlskeaDH_RSA )');
  CL.AddTypeS('TTLSMACAlgorithm', '( tlsmaNone, tlsmaNULL, tlsmaHMAC_MD5, tlsma'
   +'HMAC_SHA1, tlsmaHMAC_SHA256, tlsmaHMAC_SHA384, tlsmaHMAC_SHA512 )');
  CL.AddTypeS('TTLSMacAlgorithmInfo', 'record Name : AnsiString; DigestSize : I'
   +'nteger; Supported : Boolean; end');
 // CL.AddTypeS('PTLSMacAlgorithmInfo', '^TTLSMacAlgorithmInfo // will not work');
 CL.AddConstantN('TLS_MAC_MAXDIGESTSIZE','LongInt').SetInt( 64);
  CL.AddTypeS('TTLSPRFAlgorithm', '( tlspaSHA256 )');
 CL.AddDelphiFunction('Function tlsP_MD5( const Secret, Seed : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function tlsP_SHA1( const Secret, Seed : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function tlsP_SHA256( const Secret, Seed : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function tlsP_SHA512( const Secret, Seed : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function tls10PRF( const Secret, ALabel, Seed : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function tls12PRF_SHA256( const Secret, ALabel, Seed : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function tls12PRF_SHA512( const Secret, ALabel, Seed : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function TLSPRF( const ProtocolVersion : TTLSProtocolVersion; const Secret, ALabel, Seed : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function tls10KeyBlock( const MasterSecret, ServerRandom, ClientRandom : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function tls12SHA256KeyBlock( const MasterSecret, ServerRandom, ClientRandom : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function tls12SHA512KeyBlock( const MasterSecret, ServerRandom, ClientRandom : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function TLSKeyBlock( const ProtocolVersion : TTLSProtocolVersion; const MasterSecret, ServerRandom, ClientRandom : AnsiString; const Size : Integer) : AnsiString');
 CL.AddDelphiFunction('Function tls10MasterSecret( const PreMasterSecret, ClientRandom, ServerRandom : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function tls12SHA256MasterSecret( const PreMasterSecret, ClientRandom, ServerRandom : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function tls12SHA512MasterSecret( const PreMasterSecret, ClientRandom, ServerRandom : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function TLSMasterSecret( const ProtocolVersion : TTLSProtocolVersion; const PreMasterSecret, ClientRandom, ServerRandom : AnsiString) : AnsiString');
  CL.AddTypeS('TTLSKeys', 'record KeyBlock : AnsiString; ClientMACKey : AnsiStr'
   +'ing; ServerMACKey : AnsiString; ClientEncKey : AnsiString; ServerEncKey : '
   +'AnsiString; ClientIV : AnsiString; ServerIV : AnsiString; end');
 CL.AddDelphiFunction('Procedure GenerateTLSKeys( const ProtocolVersion : TTLSProtocolVersion; const MACKeyBits, CipherKeyBits, IVBits : Integer; const MasterSecret, ServerRandom, ClientRandom : AnsiString; var TLSKeys : TTLSKeys)');
 CL.AddDelphiFunction('Procedure GenerateFinalTLSKeys( const ProtocolVersion : TTLSProtocolVersion; const IsExportable : Boolean; const ExpandedKeyBits : Integer; const ServerRandom, ClientRandom : AnsiString; var TLSKeys : TTLSKeys)');
 CL.AddConstantN('TLS_PLAINTEXT_FRAGMENT_MAXSIZE','LongInt').SetInt( 16384 - 1);
 CL.AddConstantN('TLS_COMPRESSED_FRAGMENT_MAXSIZE','LongInt').SetInt( 16384 + 1024);
 CL.AddDelphiFunction('Procedure SelfTestcTLSUtils');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure ETLSErrorTLSError_R(Self: ETLSError; var T: Integer);
begin T := Self.TLSError; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ETLSError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ETLSError) do begin
    RegisterConstructor(@ETLSError.Create, 'Create');
    RegisterPropertyHelper(@ETLSErrorTLSError_R,nil,'TLSError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cTLSUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TLSErrorMessage, 'TLSErrorMessage', cdRegister);
 // RIRegister_ETLSError(CL);
 S.RegisterDelphiFunction(@InitSSLProtocolVersion30, 'InitSSLProtocolVersion30', cdRegister);
 S.RegisterDelphiFunction(@InitTLSProtocolVersion10, 'InitTLSProtocolVersion10', cdRegister);
 S.RegisterDelphiFunction(@InitTLSProtocolVersion11, 'InitTLSProtocolVersion11', cdRegister);
 S.RegisterDelphiFunction(@InitTLSProtocolVersion12, 'InitTLSProtocolVersion12', cdRegister);
 S.RegisterDelphiFunction(@IsTLSProtocolVersion, 'IsTLSProtocolVersion', cdRegister);
 S.RegisterDelphiFunction(@IsSSL2, 'IsSSL2', cdRegister);
 S.RegisterDelphiFunction(@IsSSL3, 'IsSSL3', cdRegister);
 S.RegisterDelphiFunction(@IsTLS10, 'IsTLS10', cdRegister);
 S.RegisterDelphiFunction(@IsTLS11, 'IsTLS11', cdRegister);
 S.RegisterDelphiFunction(@IsTLS12, 'IsTLS12', cdRegister);
 S.RegisterDelphiFunction(@IsTLS10OrLater, 'IsTLS10OrLater', cdRegister);
 S.RegisterDelphiFunction(@IsTLS11OrLater, 'IsTLS11OrLater', cdRegister);
 S.RegisterDelphiFunction(@IsTLS12OrLater, 'IsTLS12OrLater', cdRegister);
 S.RegisterDelphiFunction(@IsFutureTLSVersion, 'IsFutureTLSVersion', cdRegister);
 S.RegisterDelphiFunction(@IsKnownTLSVersion, 'IsKnownTLSVersion', cdRegister);
 S.RegisterDelphiFunction(@TLSProtocolVersionToStr, 'TLSProtocolVersionToStr', cdRegister);
 S.RegisterDelphiFunction(@TLSProtocolVersionName, 'TLSProtocolVersionName', cdRegister);
 S.RegisterDelphiFunction(@InitTLSRandom, 'InitTLSRandom', cdRegister);
 S.RegisterDelphiFunction(@TLSRandomToStr, 'TLSRandomToStr', cdRegister);
 S.RegisterDelphiFunction(@InitTLSSessionID, 'InitTLSSessionID', cdRegister);
 S.RegisterDelphiFunction(@EncodeTLSSessionID, 'EncodeTLSSessionID', cdRegister);
 S.RegisterDelphiFunction(@DecodeTLSSessionID, 'DecodeTLSSessionID', cdRegister);
 S.RegisterDelphiFunction(@tlsP_MD5, 'tlsP_MD5', cdRegister);
 S.RegisterDelphiFunction(@tlsP_SHA1, 'tlsP_SHA1', cdRegister);
 S.RegisterDelphiFunction(@tlsP_SHA256, 'tlsP_SHA256', cdRegister);
 S.RegisterDelphiFunction(@tlsP_SHA512, 'tlsP_SHA512', cdRegister);
 S.RegisterDelphiFunction(@tls10PRF, 'tls10PRF', cdRegister);
 S.RegisterDelphiFunction(@tls12PRF_SHA256, 'tls12PRF_SHA256', cdRegister);
 S.RegisterDelphiFunction(@tls12PRF_SHA512, 'tls12PRF_SHA512', cdRegister);
 S.RegisterDelphiFunction(@TLSPRF, 'TLSPRF', cdRegister);
 S.RegisterDelphiFunction(@tls10KeyBlock, 'tls10KeyBlock', cdRegister);
 S.RegisterDelphiFunction(@tls12SHA256KeyBlock, 'tls12SHA256KeyBlock', cdRegister);
 S.RegisterDelphiFunction(@tls12SHA512KeyBlock, 'tls12SHA512KeyBlock', cdRegister);
 S.RegisterDelphiFunction(@TLSKeyBlock, 'TLSKeyBlock', cdRegister);
 S.RegisterDelphiFunction(@tls10MasterSecret, 'tls10MasterSecret', cdRegister);
 S.RegisterDelphiFunction(@tls12SHA256MasterSecret, 'tls12SHA256MasterSecret', cdRegister);
 S.RegisterDelphiFunction(@tls12SHA512MasterSecret, 'tls12SHA512MasterSecret', cdRegister);
 S.RegisterDelphiFunction(@TLSMasterSecret, 'TLSMasterSecret', cdRegister);
 S.RegisterDelphiFunction(@GenerateTLSKeys, 'GenerateTLSKeys', cdRegister);
 S.RegisterDelphiFunction(@GenerateFinalTLSKeys, 'GenerateFinalTLSKeys', cdRegister);
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestcTLSUtils', cdRegister);
end;

 
 
{ TPSImport_cTLSUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cTLSUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cTLSUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cTLSUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cTLSUtils(ri);
  RIRegister_cTLSUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
