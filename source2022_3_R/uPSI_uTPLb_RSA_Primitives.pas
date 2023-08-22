unit uPSI_uTPLb_RSA_Primitives;
{
mX extension August 2018

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
  TPSImport_uTPLb_RSA_Primitives = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uTPLb_RSA_Primitives(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uTPLb_RSA_Primitives_Routines(S: TPSExec);

procedure Register;

implementation


uses
   uTPLB_HugeCardinal
  ,uTPLb_MemoryStreamPool
  ,uTPLb_StreamCipher
  ,uTPLb_BlockCipher
  ,uTPLb_Hash
  ,uTPLb_RSA_Primitives
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_RSA_Primitives]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_RSA_Primitives(CL: TPSPascalCompiler);
begin
 //CL.AddDelphiFunction('Function I2OSP( x : THugeCardinal; xLen : integer; XStream : TStream; Pool : TMemoryStreamPool) : boolean');
 //CL.AddDelphiFunction('Function OS2IP( XStream : TStream; xLen : integer; var x : THugeCardinal; Pool : TMemoryStreamPool; MaxBits : integer) : boolean');
 CL.AddDelphiFunction('Procedure MGF1( mgfSeed : TStream; maskLen : cardinal; mask : TStream)');
  CL.AddTypeS('TLongOpResult', '( opPass, opFail, opAbort )');
 CL.AddDelphiFunction('Function RSAES_OAEP_ENCRYPT( n, e : THugeCardinal; M, C : TMemoryStream) : boolean');
 CL.AddDelphiFunction('Function RSAES_OAEP_ENCRYPT_MaxByteLen( n : THugeCardinal) : integer');
 CL.AddDelphiFunction('Function RSAES_OAEP_DECRYPT( d, n : THugeCardinal; C, M : TStream) : boolean');
 CL.AddDelphiFunction('Function EMSA_PSS_ENCODE( M : TStream; emBits, sLen : integer; EM : TStream; CheckAbortFunc : TOnHashProgress) : TLongOpResult');
 CL.AddDelphiFunction('Function RSASSA_PSS_SIGN( d, n : THugeCardinal; M, S : TStream; CheckAbortFunc : TOnHashProgress) : TLongOpResult');
 CL.AddDelphiFunction('Function EMSA_PSS_VERIFY( M : TStream; emBits, sLen : integer; EM : TStream; CheckAbortFunc : TOnHashProgress) : TLongOpResult');
 CL.AddDelphiFunction('Function RSASSA_PSS_VERIFY( n, e : THugeCardinal; M, S : TStream; CheckAbortFunc : TOnHashProgress) : TLongOpResult');
 CL.AddDelphiFunction('Function Generate_RSA_SymetricKey( n, e : THugeCardinal; CipherStream : TStream; const SymetricCipher : IBlockCipher) : TSymetricKey');
 CL.AddDelphiFunction('Function Extract_RSA_SymetricKey( d, n : THugeCardinal; CipherStream : TStream; const SymetricCipher : IBlockCipher) : TSymetricKey');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_RSA_Primitives_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@I2OSP, 'I2OSP', cdRegister);
 //S.RegisterDelphiFunction(@OS2IP, 'OS2IP', cdRegister);
 S.RegisterDelphiFunction(@MGF1, 'MGF1', cdRegister);
 S.RegisterDelphiFunction(@RSAES_OAEP_ENCRYPT, 'RSAES_OAEP_ENCRYPT', cdRegister);
 S.RegisterDelphiFunction(@RSAES_OAEP_ENCRYPT_MaxByteLen, 'RSAES_OAEP_ENCRYPT_MaxByteLen', cdRegister);
 S.RegisterDelphiFunction(@RSAES_OAEP_DECRYPT, 'RSAES_OAEP_DECRYPT', cdRegister);
 S.RegisterDelphiFunction(@EMSA_PSS_ENCODE, 'EMSA_PSS_ENCODE', cdRegister);
 S.RegisterDelphiFunction(@RSASSA_PSS_SIGN, 'RSASSA_PSS_SIGN', cdRegister);
 S.RegisterDelphiFunction(@EMSA_PSS_VERIFY, 'EMSA_PSS_VERIFY', cdRegister);
 S.RegisterDelphiFunction(@RSASSA_PSS_VERIFY, 'RSASSA_PSS_VERIFY', cdRegister);
 S.RegisterDelphiFunction(@Generate_RSA_SymetricKey, 'Generate_RSA_SymetricKey', cdRegister);
 S.RegisterDelphiFunction(@Extract_RSA_SymetricKey, 'Extract_RSA_SymetricKey', cdRegister);
end;

 
 
{ TPSImport_uTPLb_RSA_Primitives }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_RSA_Primitives.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_RSA_Primitives(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_RSA_Primitives.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_RSA_Primitives_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
