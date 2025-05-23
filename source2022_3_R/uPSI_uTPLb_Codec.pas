unit uPSI_uTPLb_Codec;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

 mX4 

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
  TPSImport_uTPLb_Codec = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCodec(CL: TPSPascalCompiler);
procedure SIRegister_ICodec_TestAccess(CL: TPSPascalCompiler);
procedure SIRegister_TSimpleCodec(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_Codec(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCodec(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpleCodec(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_Codec(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uTPLb_StreamCipher
  ,uTPLb_BlockCipher
  ,uTPLb_Asymetric
  ,uTPLb_BaseNonVisualComponent
  ,uTPLb_CryptographicLibrary
  ,uTPLb_CodecIntf
  ,uTPLb_HashDsc
  ,uTPLb_Hash
  ,uTPLb_StreamUtils
  ,uTPLb_Codec
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_Codec]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCodec(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTPLb_BaseNonVisualComponent', 'TCodec') do
  with CL.AddClassN(CL.FindClass('TTPLb_BaseNonVisualComponent'),'TCodec') do
  begin
    RegisterProperty('FGenerateAsymetricKeyPairProgress_CountPrimalityTests', 'integer', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free;');

    RegisterMethod('Procedure Burn');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Procedure SaveKeyToStream( Store : TStream)');
    RegisterMethod('Procedure InitFromStream( Store : TStream)');
    RegisterMethod('Function GetAborted : boolean');
    RegisterMethod('Procedure SetAborted( Value : boolean)');
    RegisterMethod('Function isAsymetric : boolean');
    RegisterMethod('Function Asymetric_Engine : IAsymetric_Engine');
    RegisterMethod('Procedure InitFromKey( Key : TSymetricKey)');
    RegisterMethod('Procedure InitFromGeneratedAsymetricKeyPair');
    RegisterMethod('Procedure Begin_EncryptMemory( CipherText : TStream)');
    RegisterMethod('Procedure EncryptMemory( const Plaintext: TStream; PlaintextLen : integer)');
    RegisterMethod('Procedure End_EncryptMemory');
    RegisterMethod('Procedure Begin_DecryptMemory( Plaintext : TStream)');
    RegisterMethod('Procedure DecryptMemory( const CipherText: TStream; CiphertextLen : integer)');
    RegisterMethod('Procedure End_DecryptMemory');
    RegisterMethod('Procedure EncryptStream( Plaintext, CipherText : TStream)');
    RegisterMethod('Procedure DecryptStream( Plaintext, CipherText : TStream)');
    RegisterMethod('Procedure EncryptFile( const Plaintext_FileName, CipherText_FileName : string)');
    RegisterMethod('Procedure DecryptFile( const Plaintext_FileName, CipherText_FileName : string)');
    RegisterMethod('Procedure EncryptString( const Plaintext : string; var CipherText_Base64 : ansistring)');
    RegisterMethod('Procedure DecryptString( var Plaintext : string; const CipherText_Base64 : ansistring)');
    RegisterMethod('Procedure EncryptAnsiString( const Plaintext : ansistring; var CipherText_Base64 : ansistring)');
    RegisterMethod('Procedure DecryptAnsiString( var Plaintext : ansistring; const CipherText_Base64 : ansistring)');
    RegisterMethod('Function Speed : integer');
    RegisterProperty('Key', 'TSymetricKey', iptr);
    RegisterProperty('StreamCipherId', 'string', iptrw);
    RegisterProperty('BlockCipherId', 'string', iptrw);
    RegisterProperty('ChainModeId', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('UTF8Password', 'string', iptrw);
    RegisterProperty('Mode', 'TCodecMode', iptr);
    RegisterProperty('isUserAborted', 'boolean', iptrw);
    RegisterProperty('CountBytesProcessed', 'int64', iptrw);
    RegisterProperty('EstimatedWorkLoad', 'int64', iptrw);
    RegisterProperty('Duration', 'TDateTime', iptrw);
    RegisterProperty('Cipher', 'string', iptrw);
    RegisterProperty('ChainMode', 'string', iptrw);
    RegisterProperty('AsymetricKeySizeInBits', 'cardinal', iptrw);
    RegisterProperty('CryptoLibrary', 'TCryptographicLibrary', iptrw);
    RegisterProperty('OnProgress', 'TOnHashProgress', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ICodec_TestAccess(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ICodec_TestAccess') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ICodec_TestAccess, 'ICodec_TestAccess') do
  begin
    RegisterMethod('Function GetCodecIntf : ICodec', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpleCodec(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedPersistent', 'TSimpleCodec') do
  with CL.AddClassN(CL.FindClass('TInterfacedPersistent'),'TSimpleCodec') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free;');

    RegisterMethod('Procedure Init( const Key : string)');
    RegisterMethod('Procedure InitA( const Key : utf8string)');
    RegisterMethod('Procedure SaveKeyToStream( Store : TStream)');
    RegisterMethod('Procedure InitFromStream( Store : TStream)');
    RegisterMethod('Procedure InitFromKey( Key : TSymetricKey)');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Procedure Burn( doIncludeBurnKey : boolean)');
    RegisterMethod('Function isAsymetric : boolean');
    RegisterMethod('Procedure InitFromGeneratedAsymetricKeyPair');
    RegisterMethod('Procedure Sign( Document, Signature : TStream; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; SigningKeys_PrivatePart : TObject; var wasAborted : boolean)');
    RegisterMethod('Function VerifySignature( Document, Signature : TStream; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; SigningKeys_PublicPart : TObject; var wasAborted : boolean) : boolean');
    RegisterMethod('Procedure Begin_EncryptMemory( CipherText : TStream)');
    RegisterMethod('Procedure EncryptMemory( const Plaintext: TStream; PlaintextLen : integer)');
    RegisterMethod('Procedure End_EncryptMemory');
    RegisterMethod('Procedure Begin_DecryptMemory( Plaintext : TStream)');
    RegisterMethod('Procedure DecryptMemory( const CipherText: TStream; CiphertextLen : integer)');
    RegisterMethod('Procedure End_DecryptMemory');
    RegisterMethod('Procedure EncryptStream( Plaintext, CipherText : TStream)');
    RegisterMethod('Procedure DecryptStream( Plaintext, CipherText : TStream)');
    RegisterMethod('Procedure EncryptFile( const Plaintext_FileName, CipherText_FileName : string)');
    RegisterMethod('Procedure DecryptFile( const Plaintext_FileName, CipherText_FileName : string)');
    RegisterMethod('Procedure EncryptString( const Plaintext : string; var CipherText_Base64 : ansistring)');
    RegisterMethod('Procedure DecryptString( var Plaintext : string; const CipherText_Base64 : ansistring)');
    RegisterMethod('Procedure EncryptAnsiString( const Plaintext : ansistring; var CipherText_Base64 : ansistring)');
    RegisterMethod('Procedure DecryptAnsiString( var Plaintext : ansistring; const CipherText_Base64 : ansistring)');
    RegisterMethod('Function GetAborted : boolean');
    RegisterMethod('Procedure SetAborted( Value : boolean)');
    RegisterMethod('Function GetCipherDisplayName( Lib : TCryptographicLibrary) : string');
    RegisterProperty('Mode', 'TCodecMode', iptr);
    RegisterProperty('StreamCipher', 'IStreamCipher', iptrw);
    RegisterProperty('BlockCipher', 'IBlockCipher', iptrw);
    RegisterProperty('ChainMode', 'IBlockChainingModel', iptrw);
    RegisterProperty('OnProgress', 'TOnEncDecProgress', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_Codec(CL: TPSPascalCompiler);
begin
  SIRegister_TSimpleCodec(CL);
  SIRegister_ICodec_TestAccess(CL);
  SIRegister_TCodec(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCodecOnProgress_W(Self: TCodec; const T: TOnHashProgress);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecOnProgress_R(Self: TCodec; var T: TOnHashProgress);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TCodecCryptoLibrary_W(Self: TCodec; const T: TCryptographicLibrary);
begin Self.CryptoLibrary := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecCryptoLibrary_R(Self: TCodec; var T: TCryptographicLibrary);
begin T := Self.CryptoLibrary; end;

(*----------------------------------------------------------------------------*)
procedure TCodecAsymetricKeySizeInBits_W(Self: TCodec; const T: cardinal);
begin Self.AsymetricKeySizeInBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecAsymetricKeySizeInBits_R(Self: TCodec; var T: cardinal);
begin T := Self.AsymetricKeySizeInBits; end;

(*----------------------------------------------------------------------------*)
procedure TCodecChainMode_W(Self: TCodec; const T: string);
begin Self.ChainMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecChainMode_R(Self: TCodec; var T: string);
begin T := Self.ChainMode; end;

(*----------------------------------------------------------------------------*)
procedure TCodecCipher_W(Self: TCodec; const T: string);
begin Self.Cipher := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecCipher_R(Self: TCodec; var T: string);
begin T := Self.Cipher; end;

(*----------------------------------------------------------------------------*)
procedure TCodecDuration_W(Self: TCodec; const T: TDateTime);
begin Self.Duration := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecDuration_R(Self: TCodec; var T: TDateTime);
begin T := Self.Duration; end;

(*----------------------------------------------------------------------------*)
procedure TCodecEstimatedWorkLoad_W(Self: TCodec; const T: int64);
begin Self.EstimatedWorkLoad := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecEstimatedWorkLoad_R(Self: TCodec; var T: int64);
begin T := Self.EstimatedWorkLoad; end;

(*----------------------------------------------------------------------------*)
procedure TCodecCountBytesProcessed_W(Self: TCodec; const T: int64);
begin Self.CountBytesProcessed := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecCountBytesProcessed_R(Self: TCodec; var T: int64);
begin T := Self.CountBytesProcessed; end;

(*----------------------------------------------------------------------------*)
procedure TCodecisUserAborted_W(Self: TCodec; const T: boolean);
begin Self.isUserAborted := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecisUserAborted_R(Self: TCodec; var T: boolean);
begin T := Self.isUserAborted; end;

(*----------------------------------------------------------------------------*)
procedure TCodecMode_R(Self: TCodec; var T: TCodecMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TCodecUTF8Password_W(Self: TCodec; const T: utf8string);
begin //Self.UTF8Password := T;
end;

(*----------------------------------------------------------------------------*)
procedure TCodecUTF8Password_R(Self: TCodec; var T: utf8string);
begin// T := Self.UTF8Password;
end;

(*----------------------------------------------------------------------------*)
procedure TCodecPassword_W(Self: TCodec; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecPassword_R(Self: TCodec; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TCodecChainModeId_W(Self: TCodec; const T: string);
begin Self.ChainModeId := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecChainModeId_R(Self: TCodec; var T: string);
begin T := Self.ChainModeId; end;

(*----------------------------------------------------------------------------*)
procedure TCodecBlockCipherId_W(Self: TCodec; const T: string);
begin Self.BlockCipherId := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecBlockCipherId_R(Self: TCodec; var T: string);
begin T := Self.BlockCipherId; end;

(*----------------------------------------------------------------------------*)
procedure TCodecStreamCipherId_W(Self: TCodec; const T: string);
begin Self.StreamCipherId := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecStreamCipherId_R(Self: TCodec; var T: string);
begin T := Self.StreamCipherId; end;

(*----------------------------------------------------------------------------*)
procedure TCodecKey_R(Self: TCodec; var T: TSymetricKey);
begin T := Self.Key; end;

(*----------------------------------------------------------------------------*)
procedure TCodecFGenerateAsymetricKeyPairProgress_CountPrimalityTests_W(Self: TCodec; const T: integer);
Begin Self.FGenerateAsymetricKeyPairProgress_CountPrimalityTests := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodecFGenerateAsymetricKeyPairProgress_CountPrimalityTests_R(Self: TCodec; var T: integer);
Begin T := Self.FGenerateAsymetricKeyPairProgress_CountPrimalityTests; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleCodecOnProgress_W(Self: TSimpleCodec; const T: TOnEncDecProgress);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleCodecOnProgress_R(Self: TSimpleCodec; var T: TOnEncDecProgress);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleCodecChainMode_W(Self: TSimpleCodec; const T: IBlockChainingModel);
begin Self.ChainMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleCodecChainMode_R(Self: TSimpleCodec; var T: IBlockChainingModel);
begin T := Self.ChainMode; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleCodecBlockCipher_W(Self: TSimpleCodec; const T: IBlockCipher);
begin Self.BlockCipher := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleCodecBlockCipher_R(Self: TSimpleCodec; var T: IBlockCipher);
begin T := Self.BlockCipher; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleCodecStreamCipher_W(Self: TSimpleCodec; const T: IStreamCipher);
begin Self.StreamCipher := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleCodecStreamCipher_R(Self: TSimpleCodec; var T: IStreamCipher);
begin T := Self.StreamCipher; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleCodecMode_R(Self: TSimpleCodec; var T: TCodecMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCodec(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCodec) do
  begin
    RegisterPropertyHelper(@TCodecFGenerateAsymetricKeyPairProgress_CountPrimalityTests_R,@TCodecFGenerateAsymetricKeyPairProgress_CountPrimalityTests_W,'FGenerateAsymetricKeyPairProgress_CountPrimalityTests');
    RegisterConstructor(@TCodec.Create, 'Create');
        RegisterMethod(@TCodec.Destroy, 'Free');

    RegisterMethod(@TCodec.Burn, 'Burn');
    RegisterMethod(@TCodec.Reset, 'Reset');
    RegisterMethod(@TCodec.SaveKeyToStream, 'SaveKeyToStream');
    RegisterMethod(@TCodec.InitFromStream, 'InitFromStream');
    RegisterMethod(@TCodec.GetAborted, 'GetAborted');
    RegisterMethod(@TCodec.SetAborted, 'SetAborted');
    RegisterMethod(@TCodec.isAsymetric, 'isAsymetric');
    RegisterMethod(@TCodec.Asymetric_Engine, 'Asymetric_Engine');
    RegisterMethod(@TCodec.InitFromKey, 'InitFromKey');
    RegisterMethod(@TCodec.InitFromGeneratedAsymetricKeyPair, 'InitFromGeneratedAsymetricKeyPair');
    RegisterMethod(@TCodec.Begin_EncryptMemory, 'Begin_EncryptMemory');
    RegisterMethod(@TCodec.EncryptMemory, 'EncryptMemory');
    RegisterMethod(@TCodec.End_EncryptMemory, 'End_EncryptMemory');
    RegisterMethod(@TCodec.Begin_DecryptMemory, 'Begin_DecryptMemory');
    RegisterMethod(@TCodec.DecryptMemory, 'DecryptMemory');
    RegisterMethod(@TCodec.End_DecryptMemory, 'End_DecryptMemory');
    RegisterMethod(@TCodec.EncryptStream, 'EncryptStream');
    RegisterMethod(@TCodec.DecryptStream, 'DecryptStream');
    RegisterMethod(@TCodec.EncryptFile, 'EncryptFile');
    RegisterMethod(@TCodec.DecryptFile, 'DecryptFile');
    RegisterMethod(@TCodec.EncryptString, 'EncryptString');
    RegisterMethod(@TCodec.DecryptString, 'DecryptString');
    RegisterMethod(@TCodec.EncryptAnsiString, 'EncryptAnsiString');
    RegisterMethod(@TCodec.DecryptAnsiString, 'DecryptAnsiString');
    RegisterMethod(@TCodec.Speed, 'Speed');
    RegisterPropertyHelper(@TCodecKey_R,nil,'Key');
    RegisterPropertyHelper(@TCodecStreamCipherId_R,@TCodecStreamCipherId_W,'StreamCipherId');
    RegisterPropertyHelper(@TCodecBlockCipherId_R,@TCodecBlockCipherId_W,'BlockCipherId');
    RegisterPropertyHelper(@TCodecChainModeId_R,@TCodecChainModeId_W,'ChainModeId');
    RegisterPropertyHelper(@TCodecPassword_R,@TCodecPassword_W,'Password');
    RegisterPropertyHelper(@TCodecUTF8Password_R,@TCodecUTF8Password_W,'UTF8Password');
    RegisterPropertyHelper(@TCodecMode_R,nil,'Mode');
    RegisterPropertyHelper(@TCodecisUserAborted_R,@TCodecisUserAborted_W,'isUserAborted');
    RegisterPropertyHelper(@TCodecCountBytesProcessed_R,@TCodecCountBytesProcessed_W,'CountBytesProcessed');
    RegisterPropertyHelper(@TCodecEstimatedWorkLoad_R,@TCodecEstimatedWorkLoad_W,'EstimatedWorkLoad');
    RegisterPropertyHelper(@TCodecDuration_R,@TCodecDuration_W,'Duration');
    RegisterPropertyHelper(@TCodecCipher_R,@TCodecCipher_W,'Cipher');
    RegisterPropertyHelper(@TCodecChainMode_R,@TCodecChainMode_W,'ChainMode');
    RegisterPropertyHelper(@TCodecAsymetricKeySizeInBits_R,@TCodecAsymetricKeySizeInBits_W,'AsymetricKeySizeInBits');
    RegisterPropertyHelper(@TCodecCryptoLibrary_R,@TCodecCryptoLibrary_W,'CryptoLibrary');
    RegisterPropertyHelper(@TCodecOnProgress_R,@TCodecOnProgress_W,'OnProgress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpleCodec(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleCodec) do begin
    RegisterConstructor(@TSimpleCodec.Create, 'Create');
        RegisterMethod(@TSimpleCodec.Destroy, 'Free');

    RegisterMethod(@TSimpleCodec.Init, 'Init');
   // RegisterMethod(@TSimpleCodec.InitA, 'InitA');
    RegisterMethod(@TSimpleCodec.SaveKeyToStream, 'SaveKeyToStream');
    RegisterMethod(@TSimpleCodec.InitFromStream, 'InitFromStream');
    RegisterMethod(@TSimpleCodec.InitFromKey, 'InitFromKey');
    RegisterMethod(@TSimpleCodec.Reset, 'Reset');
    RegisterMethod(@TSimpleCodec.Burn, 'Burn');
    RegisterMethod(@TSimpleCodec.isAsymetric, 'isAsymetric');
    RegisterMethod(@TSimpleCodec.InitFromGeneratedAsymetricKeyPair, 'InitFromGeneratedAsymetricKeyPair');
    RegisterMethod(@TSimpleCodec.Sign, 'Sign');
    RegisterMethod(@TSimpleCodec.VerifySignature, 'VerifySignature');
    RegisterMethod(@TSimpleCodec.Begin_EncryptMemory, 'Begin_EncryptMemory');
    RegisterMethod(@TSimpleCodec.EncryptMemory, 'EncryptMemory');
    RegisterMethod(@TSimpleCodec.End_EncryptMemory, 'End_EncryptMemory');
    RegisterMethod(@TSimpleCodec.Begin_DecryptMemory, 'Begin_DecryptMemory');
    RegisterMethod(@TSimpleCodec.DecryptMemory, 'DecryptMemory');
    RegisterMethod(@TSimpleCodec.End_DecryptMemory, 'End_DecryptMemory');
    RegisterMethod(@TSimpleCodec.EncryptStream, 'EncryptStream');
    RegisterMethod(@TSimpleCodec.DecryptStream, 'DecryptStream');
    RegisterMethod(@TSimpleCodec.EncryptFile, 'EncryptFile');
    RegisterMethod(@TSimpleCodec.DecryptFile, 'DecryptFile');
    RegisterMethod(@TSimpleCodec.EncryptString, 'EncryptString');
    RegisterMethod(@TSimpleCodec.DecryptString, 'DecryptString');
    RegisterMethod(@TSimpleCodec.EncryptAnsiString, 'EncryptAnsiString');
    RegisterMethod(@TSimpleCodec.DecryptAnsiString, 'DecryptAnsiString');
    RegisterMethod(@TSimpleCodec.GetAborted, 'GetAborted');
    RegisterMethod(@TSimpleCodec.SetAborted, 'SetAborted');
    RegisterMethod(@TSimpleCodec.GetCipherDisplayName, 'GetCipherDisplayName');
    RegisterPropertyHelper(@TSimpleCodecMode_R,nil,'Mode');
    RegisterPropertyHelper(@TSimpleCodecStreamCipher_R,@TSimpleCodecStreamCipher_W,'StreamCipher');
    RegisterPropertyHelper(@TSimpleCodecBlockCipher_R,@TSimpleCodecBlockCipher_W,'BlockCipher');
    RegisterPropertyHelper(@TSimpleCodecChainMode_R,@TSimpleCodecChainMode_W,'ChainMode');
    RegisterPropertyHelper(@TSimpleCodecOnProgress_R,@TSimpleCodecOnProgress_W,'OnProgress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_Codec(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSimpleCodec(CL);
  RIRegister_TCodec(CL);
end;

 
 
{ TPSImport_uTPLb_Codec }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Codec.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_Codec(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Codec.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_Codec(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
