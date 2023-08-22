unit uPSI_uTPLb_BlockCipher;
{
block chaine @#65

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
  TPSImport_uTPLb_BlockCipher = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IBlockCipherSelector(CL: TPSPascalCompiler);
procedure SIRegister_IBlockChainingModel(CL: TPSPascalCompiler);
procedure SIRegister_TBlockChainLink(CL: TPSPascalCompiler);
procedure SIRegister_IBlockCipher(CL: TPSPascalCompiler);
procedure SIRegister_IBlockCodec(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_BlockCipher(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBlockChainLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_BlockCipher(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uTPLb_StreamCipher
  ,uTPLb_BlockCipher
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_BlockCipher]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IBlockCipherSelector(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IBlockCipherSelector') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IBlockCipherSelector, 'IBlockCipherSelector') do
  begin
    RegisterMethod('Function GetBlockCipher : IBlockCipher', cdRegister);
    RegisterMethod('Function GetChainMode : IBlockChainingModel', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBlockChainingModel(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'ICryptoGraphicAlgorithm', 'IBlockChainingModel') do
  with CL.AddInterface(CL.FindInterface('ICryptoGraphicAlgorithm'),IBlockChainingModel, 'IBlockChainingModel') do
  begin
    RegisterMethod('Function Chain_EncryptBlock( Key : TSymetricKey; InitializationVector : TMemoryStream; const Cipher : IBlockCodec) : TBlockChainLink', cdRegister);
    RegisterMethod('Function Chain_DecryptBlock( Key : TSymetricKey; InitializationVector : TMemoryStream; const Cipher : IBlockCodec) : TBlockChainLink', cdRegister);
    RegisterMethod('Function ChainingFeatures : TChainingFeatureSet', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlockChainLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBlockChainLink') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBlockChainLink') do
  begin
    RegisterMethod('Procedure Burn');
    RegisterMethod('Procedure Reset( IV : TMemoryStream)');
    RegisterMethod('Function Clone : TBlockChainLink');
    RegisterMethod('Procedure Encrypt_Block( Plaintext, Ciphertext : TMemoryStream)');
    RegisterMethod('Procedure Decrypt_Block( Plaintext, Ciphertext : TMemoryStream)');
    RegisterMethod('Procedure Encrypt_8bit( Plaintext : byte; var Ciphertext : byte)');
    RegisterMethod('Procedure Decrypt_8bit( var Plaintext : byte; Ciphertext : byte)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBlockCipher(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'ICryptoGraphicAlgorithm', 'IBlockCipher') do
  with CL.AddInterface(CL.FindInterface('ICryptoGraphicAlgorithm'),IBlockCipher, 'IBlockCipher') do
  begin
    RegisterMethod('Function GenerateKey( Seed : TStream) : TSymetricKey', cdRegister);
    RegisterMethod('Function LoadKeyFromStream( Store : TStream) : TSymetricKey', cdRegister);
    RegisterMethod('Function BlockSize : integer', cdRegister);
    RegisterMethod('Function KeySize : integer', cdRegister);
    RegisterMethod('Function SeedByteSize : integer', cdRegister);
    RegisterMethod('Function MakeBlockCodec( Key : TSymetricKey) : IBlockCodec', cdRegister);
    RegisterMethod('Function SelfTest_Key : ansistring', cdRegister);
    RegisterMethod('Function SelfTest_Plaintext : ansistring', cdRegister);
    RegisterMethod('Function SelfTest_Ciphertext : ansistring', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBlockCodec(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IBlockCodec') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IBlockCodec, 'IBlockCodec') do
  begin
    RegisterMethod('Procedure Encrypt_Block( Plaintext, Ciphertext : TMemoryStream)', cdRegister);
    RegisterMethod('Procedure Decrypt_Block( Plaintext, Ciphertext : TMemoryStream)', cdRegister);
    RegisterMethod('Procedure Reset', cdRegister);
    RegisterMethod('Procedure Burn', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_BlockCipher(CL: TPSPascalCompiler);
begin
  SIRegister_IBlockCodec(CL);
  SIRegister_IBlockCipher(CL);
  SIRegister_TBlockChainLink(CL);
  CL.AddTypeS('TChainingFeature', '( cfNoNounce, cfKeyStream, cfAutoXOR, cf8bit)');
  CL.AddTypeS('TChainingFeatureSet', 'set of TChainingFeature');
  SIRegister_IBlockChainingModel(CL);
  SIRegister_IBlockCipherSelector(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlockChainLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlockChainLink) do
  begin
    RegisterVirtualMethod(@TBlockChainLink.Burn, 'Burn');
    RegisterVirtualMethod(@TBlockChainLink.Reset, 'Reset');
    RegisterVirtualMethod(@TBlockChainLink.Clone, 'Clone');
    //RegisterVirtualAbstractMethod(@TBlockChainLink, @!.Encrypt_Block, 'Encrypt_Block');
    //RegisterVirtualAbstractMethod(@TBlockChainLink, @!.Decrypt_Block, 'Decrypt_Block');
    RegisterVirtualMethod(@TBlockChainLink.Encrypt_8bit, 'Encrypt_8bit');
    RegisterVirtualMethod(@TBlockChainLink.Decrypt_8bit, 'Decrypt_8bit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_BlockCipher(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBlockChainLink(CL);
end;

 
 
{ TPSImport_uTPLb_BlockCipher }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_BlockCipher.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_BlockCipher(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_BlockCipher.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_BlockCipher(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
