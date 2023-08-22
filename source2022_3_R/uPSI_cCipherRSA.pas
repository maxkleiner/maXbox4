unit uPSI_cCipherRSA;
{
Tthe last BIG with BIGBITBOX ty

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
  TPSImport_cCipherRSA = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cCipherRSA(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cCipherRSA_Routines(S: TPSExec);
procedure RIRegister_cCipherRSA(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cHugeInt
  ,cCipherRSA
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cCipherRSA]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cCipherRSA(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'ERSA');
  CL.AddTypeS('TRSAPublicKey', 'record KeySize : Integer; Modulus : HugeWord; Exponent : HugeWord; end');
  CL.AddTypeS('TRSAPrivateKey', 'record KeySize : Integer; Modulus : HugeWord; '
   +'Exponent : HugeWord; PublicExponent : HugeWord; Prime1 : HugeWord; Prime2 '
   +': HugeWord; Phi : HugeWord; Exponent1 : HugeWord; Exponent2 : HugeWord; Coefficient : HugeWord; end');
  CL.AddTypeS('TRSAMessage', 'HugeWord');
  CL.AddTypeS('TRSAEncryptionType', '( rsaetPKCS1, rsaetOAEP )');
 CL.AddDelphiFunction('Procedure RSAPublicKeyInit( var Key : TRSAPublicKey)');
 CL.AddDelphiFunction('Procedure RSAPublicKeyFinalise( var Key : TRSAPublicKey)');
 CL.AddDelphiFunction('Procedure RSAPublicKeyAssign( var KeyD : TRSAPublicKey; const KeyS : TRSAPublicKey)');
 CL.AddDelphiFunction('Procedure RSAPublicKeyAssignHex( var Key : TRSAPublicKey; const KeySize : Integer; const HexMod, HexExp : String)');
 CL.AddDelphiFunction('Procedure RSAPublicKeyAssignBuf( var Key : TRSAPublicKey; const KeySize : Integer; const ModBuf : string; const ModBufSize : Integer; const ExpBuf : string; const ExpBufSize : Integer; const ReverseByteOrder : Boolean)');
 CL.AddDelphiFunction('Procedure RSAPublicKeyAssignBufStr( var Key : TRSAPublicKey; const KeySize : Integer; const ModBuf, ExpBuf : AnsiString)');
 CL.AddDelphiFunction('Procedure RSAPrivateKeyInit( var Key : TRSAPrivateKey)');
 CL.AddDelphiFunction('Procedure RSAPrivateKeyFinalise( var Key : TRSAPrivateKey)');
 CL.AddDelphiFunction('Procedure RSAPrivateKeyAssign( var KeyD : TRSAPrivateKey; const KeyS : TRSAPrivateKey)');
 CL.AddDelphiFunction('Procedure RSAPrivateKeyAssignHex( var Key : TRSAPrivateKey; const KeySize : Integer; const HexMod, HexExp : AnsiString)');
 CL.AddDelphiFunction('Procedure RSAPrivateKeyAssignBuf( var Key : TRSAPrivateKey; const KeySize : Integer; const ModBuf : string; const ModBufSize : Integer; const ExpBuf : string; const ExpBufSize : Integer; const ReverseByteOrder : Boolean)');
 CL.AddDelphiFunction('Procedure RSAPrivateKeyAssignBufStr( var Key : TRSAPrivateKey; const KeySize : Integer; const ModBuf, ExpBuf : AnsiString)');
 CL.AddDelphiFunction('Procedure RSAGenerateKeys( const KeySize : Integer; var PrivateKey : TRSAPrivateKey; var PublicKey : TRSAPublicKey)');
 CL.AddDelphiFunction('Function RSACipherMessageBufSize( const KeySize : Integer) : Integer');
 CL.AddDelphiFunction('Procedure RSAEncodeMessagePKCS1( const KeySize : Integer; const Buf : string; const BufSize : Integer; var EncodedMessage : TRSAMessage)');
 CL.AddDelphiFunction('Procedure RSAEncodeMessageOAEP( const KeySize : Integer; const Buf : string; const BufSize : Integer; var EncodedMessage : TRSAMessage)');
 CL.AddDelphiFunction('Procedure RSAEncryptMessage( const PublicKey : TRSAPublicKey; const PlainMessage : TRSAMessage; var CipherMessage : TRSAMessage)');
 CL.AddDelphiFunction('Function RSACipherMessageToBuf( const KeySize : Integer; const CipherMessage : TRSAMessage; var CipherBuf : string; const CipherBufSize : Integer) : Integer');
 CL.AddDelphiFunction('Function RSAEncryptC( const EncryptionType : TRSAEncryptionType; const PublicKey : TRSAPublicKey; const PlainBuf : string; const PlainBufSize : Integer; var CipherBuf : string; const CipherBufSize : Integer) : Integer');
 CL.AddDelphiFunction('Function RSAEncryptStr( const EncryptionType : TRSAEncryptionType; const PublicKey : TRSAPublicKey; const Plain : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure RSACipherBufToMessage( const KeySize : Integer; const CipherBuf : string; const CipherBufSize : Integer; var CipherMessage : TRSAMessage)');
 CL.AddDelphiFunction('Procedure RSADecryptMessage( const PrivateKey : TRSAPrivateKey; const CipherMessage : TRSAMessage; var EncodedMessage : TRSAMessage)');
 CL.AddDelphiFunction('Function RSADecodeMessagePKCS1( const KeySize : Integer; const EncodedMessage : HugeWord; var Buf : string; const BufSize : Integer) : Integer');
 CL.AddDelphiFunction('Function RSADecodeMessageOAEP( const KeySize : Integer; const EncodedMessage : HugeWord; var Buf : string; const BufSize : Integer) : Integer');
 CL.AddDelphiFunction('Function RSADecryptC( const EncryptionType : TRSAEncryptionType; const PrivateKey : TRSAPrivateKey; const CipherBuf : string; const CipherBufSize : Integer; var PlainBuf : string; const PlainBufSize : Integer) : Integer');
 CL.AddDelphiFunction('Function RSADecryptStr( const EncryptionType : TRSAEncryptionType; const PrivateKey : TRSAPrivateKey; const Cipher : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure SelfTestRSA');
 //CL.AddDelphiFunction('Procedure Profile');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_cCipherRSA_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RSAPublicKeyInit, 'RSAPublicKeyInit', cdRegister);
 S.RegisterDelphiFunction(@RSAPublicKeyFinalise, 'RSAPublicKeyFinalise', cdRegister);
 S.RegisterDelphiFunction(@RSAPublicKeyAssign, 'RSAPublicKeyAssign', cdRegister);
 S.RegisterDelphiFunction(@RSAPublicKeyAssignHex, 'RSAPublicKeyAssignHex', cdRegister);
 S.RegisterDelphiFunction(@RSAPublicKeyAssignBuf, 'RSAPublicKeyAssignBuf', cdRegister);
 S.RegisterDelphiFunction(@RSAPublicKeyAssignBufStr, 'RSAPublicKeyAssignBufStr', cdRegister);
 S.RegisterDelphiFunction(@RSAPrivateKeyInit, 'RSAPrivateKeyInit', cdRegister);
 S.RegisterDelphiFunction(@RSAPrivateKeyFinalise, 'RSAPrivateKeyFinalise', cdRegister);
 S.RegisterDelphiFunction(@RSAPrivateKeyAssign, 'RSAPrivateKeyAssign', cdRegister);
 S.RegisterDelphiFunction(@RSAPrivateKeyAssignHex, 'RSAPrivateKeyAssignHex', cdRegister);
 S.RegisterDelphiFunction(@RSAPrivateKeyAssignBuf, 'RSAPrivateKeyAssignBuf', cdRegister);
 S.RegisterDelphiFunction(@RSAPrivateKeyAssignBufStr, 'RSAPrivateKeyAssignBufStr', cdRegister);
 S.RegisterDelphiFunction(@RSAGenerateKeys, 'RSAGenerateKeys', cdRegister);
 S.RegisterDelphiFunction(@RSACipherMessageBufSize, 'RSACipherMessageBufSize', cdRegister);
 S.RegisterDelphiFunction(@RSAEncodeMessagePKCS1, 'RSAEncodeMessagePKCS1', cdRegister);
 S.RegisterDelphiFunction(@RSAEncodeMessageOAEP, 'RSAEncodeMessageOAEP', cdRegister);
 S.RegisterDelphiFunction(@RSAEncryptMessage, 'RSAEncryptMessage', cdRegister);
 S.RegisterDelphiFunction(@RSACipherMessageToBuf, 'RSACipherMessageToBuf', cdRegister);
 S.RegisterDelphiFunction(@RSAEncrypt, 'RSAEncryptC', cdRegister);
 S.RegisterDelphiFunction(@RSAEncryptStr, 'RSAEncryptStr', cdRegister);
 S.RegisterDelphiFunction(@RSACipherBufToMessage, 'RSACipherBufToMessage', cdRegister);
 S.RegisterDelphiFunction(@RSADecryptMessage, 'RSADecryptMessage', cdRegister);
 S.RegisterDelphiFunction(@RSADecodeMessagePKCS1, 'RSADecodeMessagePKCS1', cdRegister);
 S.RegisterDelphiFunction(@RSADecodeMessageOAEP, 'RSADecodeMessageOAEP', cdRegister);
 S.RegisterDelphiFunction(@RSADecrypt, 'RSADecryptC', cdRegister);
 S.RegisterDelphiFunction(@RSADecryptStr, 'RSADecryptStr', cdRegister);
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestRSA', cdRegister);
// S.RegisterDelphiFunction(@Profile, 'Profile', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cCipherRSA(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ERSA) do
end;

 
 
{ TPSImport_cCipherRSA }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cCipherRSA.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cCipherRSA(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cCipherRSA.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cCipherRSA(ri);
  RIRegister_cCipherRSA_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
