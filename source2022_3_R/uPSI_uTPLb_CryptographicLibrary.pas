unit uPSI_uTPLb_CryptographicLibrary;
{
crypto box 4

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
  TPSImport_uTPLb_CryptographicLibrary = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ICipherChoice(CL: TPSPascalCompiler);
procedure SIRegister_TCryptographicLibrary(CL: TPSPascalCompiler);
procedure SIRegister_ICryptographicLibraryWatcher(CL: TPSPascalCompiler);
procedure SIRegister_TCustomStreamCipher(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_CryptographicLibrary(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCryptographicLibrary(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomStreamCipher(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_CryptographicLibrary(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uTPLb_BaseNonVisualComponent
  ,uTPLb_StreamCipher
  ,uTPLb_BlockCipher
  ,contnrs
  ,uTPLb_HashDsc
  ,uTPLb_SimpleBlockCipher
  ,uTPLb_CryptographicLibrary
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_CryptographicLibrary]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ICipherChoice(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ICipherChoice') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ICipherChoice, 'ICipherChoice') do
  begin
    RegisterMethod('Procedure GetChoiceParams( var CipherDisplayName : string; var isBlockCipher : boolean; var StreamCipherId : string; var BlockCipherId : string)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCryptographicLibrary(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTPLb_BaseNonVisualComponent', 'TCryptographicLibrary') do
  with CL.AddClassN(CL.FindClass('TTPLb_BaseNonVisualComponent'),'TCryptographicLibrary') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function StreamCipherIntfc( const ProgIdx : string) : IStreamCipher');
    RegisterMethod('Procedure RegisterStreamCipher( const Registrant : IStreamCipher)');
    RegisterMethod('Procedure DeregisterStreamCipher( const Registrant : IStreamCipher)');
    RegisterMethod('Function BlockCipherIntfc( const ProgIdx : string) : IBlockCipher');
    RegisterMethod('Procedure RegisterBlockCipher( const Registrant : IBlockCipher)');
    RegisterMethod('Procedure DeregisterBlockCipher( const Registrant : IBlockCipher)');
    RegisterMethod('Function BlockChainingModelIntfc( const ProgIdx : string) : IBlockChainingModel');
    RegisterMethod('Procedure RegisterBlockChainingModel( const Registrant : IBlockChainingModel)');
    RegisterMethod('Procedure DeregisterBlockChainingModel( const Registrant : IBlockChainingModel)');
    RegisterMethod('Function HashIntfc( const ProgIdx : string) : IHashDsc');
    RegisterMethod('Procedure RegisterHash( const Registrant : IHashDsc)');
    RegisterMethod('Procedure DeregisterHash( const Registrant : IHashDsc)');
    RegisterMethod('Procedure RegisterWatcher( const Registrant : ICryptographicLibraryWatcher)');
    RegisterMethod('Procedure DegisterWatcher( const Registrant : ICryptographicLibraryWatcher)');
    RegisterMethod('Procedure ProgIdsChanged( StackLimit : integer)');
    RegisterMethod('Function RegisterSimpleBlockTransform( Cls : TSimpleBlockCipherClass; const ProgId1 : string; const DisplayName1 : string; Features1 : TAlgorithmicFeatureSet; BlockSizeInBytes1 : integer) : string');
    RegisterMethod('Function GetCipherChoices : IInterfaceList');
    RegisterMethod('Function ComputeCipherDisplayName( const SCipher : IStreamCipher; const BCipher : IBlockCipher) : string');
    RegisterMethod('Function GetHashChoices : IInterfaceList');
    RegisterMethod('Function ComputeHashDisplayName( const Hash : IHashDsc) : string');
    RegisterMethod('Function GetChainChoices : IInterfaceList');
    RegisterMethod('Function ComputeChainDisplayName( const Chain : IBlockChainingModel) : string');
    RegisterProperty('StreamCiphers_ByProgId', 'TStrings', iptr);
    RegisterProperty('StreamCiphers_ByDisplayName', 'TStrings', iptr);
    RegisterProperty('StreamCipherDisplayNames', 'string string', iptr);
    RegisterProperty('BlockCiphers_ByProgId', 'TStrings', iptr);
    RegisterProperty('BlockCiphers_ByDisplayName', 'TStrings', iptr);
    RegisterProperty('BlockCipherDisplayNames', 'string string', iptr);
    RegisterProperty('ChainModes_ByProgId', 'TStrings', iptr);
    RegisterProperty('ChainModes_ByDisplayName', 'TStrings', iptr);
    RegisterProperty('ChainModesDisplayNames', 'string string', iptr);
    RegisterProperty('Hashs_ByProgId', 'TStrings', iptr);
    RegisterProperty('Hashs_ByDisplayName', 'TStrings', iptr);
    RegisterProperty('HashDisplayNames', 'string string', iptr);
    RegisterProperty('ParentLibrary', 'TCryptographicLibrary', iptrw);
    RegisterProperty('CustomCipher', 'TCustomStreamCipher', iptr);
    RegisterProperty('OnCustomCipherGenerateKey', 'TOnGenerateKeyFunc', iptrw);
    RegisterProperty('OnCustomCipherStart_Encrypt', 'TOnStart_EncryptFunc', iptrw);
    RegisterProperty('OnCustomCipherStart_Decrypt', 'TOnStart_DecryptFunc', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ICryptographicLibraryWatcher(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ICryptographicLibraryWatcher') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ICryptographicLibraryWatcher, 'ICryptographicLibraryWatcher') do
  begin
    RegisterMethod('Procedure ProgIdsChanged', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomStreamCipher(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TCustomStreamCipher') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TCustomStreamCipher') do
  begin
    RegisterProperty('DisplayName', 'string', iptrw);
    RegisterProperty('ProgId', 'string', iptrw);
    RegisterProperty('Features', 'TAlgorithmicFeatureSet', iptrw);
    RegisterProperty('SeedByteSize', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_CryptographicLibrary(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCryptoLibStringRef', '( cStreamId, sStreamName, cBlockId, cBloc'
   +'kName, cChainId, cChainName, cHashId, cHashName )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCryptographicLibrary');
  //CL.AddTypeS('TOnGenerateKeyFunc', 'Function ( Lib : TCryptographicLibrary; Se'
   //+'ed : TStream) : TSymetricKey');
  //CL.AddTypeS('TOnStart_EncryptFunc', 'Function ( Lib : TCryptographicLibrary; '
   //+'Key : TSymetricKey; CipherText : TStream) : IStreamEncryptor');
  //CL.AddTypeS('TOnStart_DecryptFunc', 'Function ( Lib : TCryptographicLibrary; '
   //+'Key : TSymetricKey; PlainText : TStream) : IStreamDecryptor');
  SIRegister_TCustomStreamCipher(CL);
  SIRegister_ICryptographicLibraryWatcher(CL);
  SIRegister_TCryptographicLibrary(CL);
  SIRegister_ICipherChoice(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryOnCustomCipherStart_Decrypt_W(Self: TCryptographicLibrary; const T: TOnStart_DecryptFunc);
begin Self.OnCustomCipherStart_Decrypt := T; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryOnCustomCipherStart_Decrypt_R(Self: TCryptographicLibrary; var T: TOnStart_DecryptFunc);
begin T := Self.OnCustomCipherStart_Decrypt; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryOnCustomCipherStart_Encrypt_W(Self: TCryptographicLibrary; const T: TOnStart_EncryptFunc);
begin Self.OnCustomCipherStart_Encrypt := T; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryOnCustomCipherStart_Encrypt_R(Self: TCryptographicLibrary; var T: TOnStart_EncryptFunc);
begin T := Self.OnCustomCipherStart_Encrypt; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryOnCustomCipherGenerateKey_W(Self: TCryptographicLibrary; const T: TOnGenerateKeyFunc);
begin Self.OnCustomCipherGenerateKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryOnCustomCipherGenerateKey_R(Self: TCryptographicLibrary; var T: TOnGenerateKeyFunc);
begin T := Self.OnCustomCipherGenerateKey; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryCustomCipher_R(Self: TCryptographicLibrary; var T: TCustomStreamCipher);
begin T := Self.CustomCipher; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryParentLibrary_W(Self: TCryptographicLibrary; const T: TCryptographicLibrary);
begin Self.ParentLibrary := T; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryParentLibrary_R(Self: TCryptographicLibrary; var T: TCryptographicLibrary);
begin T := Self.ParentLibrary; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryHashDisplayNames_R(Self: TCryptographicLibrary; var T: string; const t1: string);
begin T := Self.HashDisplayNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryHashs_ByDisplayName_R(Self: TCryptographicLibrary; var T: TStrings);
begin T := Self.Hashs_ByDisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryHashs_ByProgId_R(Self: TCryptographicLibrary; var T: TStrings);
begin T := Self.Hashs_ByProgId; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryChainModesDisplayNames_R(Self: TCryptographicLibrary; var T: string; const t1: string);
begin T := Self.ChainModesDisplayNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryChainModes_ByDisplayName_R(Self: TCryptographicLibrary; var T: TStrings);
begin T := Self.ChainModes_ByDisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryChainModes_ByProgId_R(Self: TCryptographicLibrary; var T: TStrings);
begin T := Self.ChainModes_ByProgId; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryBlockCipherDisplayNames_R(Self: TCryptographicLibrary; var T: string; const t1: string);
begin T := Self.BlockCipherDisplayNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryBlockCiphers_ByDisplayName_R(Self: TCryptographicLibrary; var T: TStrings);
begin T := Self.BlockCiphers_ByDisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryBlockCiphers_ByProgId_R(Self: TCryptographicLibrary; var T: TStrings);
begin T := Self.BlockCiphers_ByProgId; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryStreamCipherDisplayNames_R(Self: TCryptographicLibrary; var T: string; const t1: string);
begin T := Self.StreamCipherDisplayNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryStreamCiphers_ByDisplayName_R(Self: TCryptographicLibrary; var T: TStrings);
begin T := Self.StreamCiphers_ByDisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TCryptographicLibraryStreamCiphers_ByProgId_R(Self: TCryptographicLibrary; var T: TStrings);
begin T := Self.StreamCiphers_ByProgId; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStreamCipherSeedByteSize_W(Self: TCustomStreamCipher; const T: integer);
begin Self.SeedByteSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStreamCipherSeedByteSize_R(Self: TCustomStreamCipher; var T: integer);
begin T := Self.SeedByteSize; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStreamCipherFeatures_W(Self: TCustomStreamCipher; const T: TAlgorithmicFeatureSet);
begin Self.Features := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStreamCipherFeatures_R(Self: TCustomStreamCipher; var T: TAlgorithmicFeatureSet);
begin T := Self.Features; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStreamCipherProgId_W(Self: TCustomStreamCipher; const T: string);
begin Self.ProgId := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStreamCipherProgId_R(Self: TCustomStreamCipher; var T: string);
begin T := Self.ProgId; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStreamCipherDisplayName_W(Self: TCustomStreamCipher; const T: string);
begin Self.DisplayName := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStreamCipherDisplayName_R(Self: TCustomStreamCipher; var T: string);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCryptographicLibrary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCryptographicLibrary) do
  begin
    RegisterConstructor(@TCryptographicLibrary.Create, 'Create');
    RegisterMethod(@TCryptographicLibrary.StreamCipherIntfc, 'StreamCipherIntfc');
    RegisterMethod(@TCryptographicLibrary.RegisterStreamCipher, 'RegisterStreamCipher');
    RegisterMethod(@TCryptographicLibrary.DeregisterStreamCipher, 'DeregisterStreamCipher');
    RegisterMethod(@TCryptographicLibrary.BlockCipherIntfc, 'BlockCipherIntfc');
    RegisterMethod(@TCryptographicLibrary.RegisterBlockCipher, 'RegisterBlockCipher');
    RegisterMethod(@TCryptographicLibrary.DeregisterBlockCipher, 'DeregisterBlockCipher');
    RegisterMethod(@TCryptographicLibrary.BlockChainingModelIntfc, 'BlockChainingModelIntfc');
    RegisterMethod(@TCryptographicLibrary.RegisterBlockChainingModel, 'RegisterBlockChainingModel');
    RegisterMethod(@TCryptographicLibrary.DeregisterBlockChainingModel, 'DeregisterBlockChainingModel');
    RegisterMethod(@TCryptographicLibrary.HashIntfc, 'HashIntfc');
    RegisterMethod(@TCryptographicLibrary.RegisterHash, 'RegisterHash');
    RegisterMethod(@TCryptographicLibrary.DeregisterHash, 'DeregisterHash');
    RegisterMethod(@TCryptographicLibrary.RegisterWatcher, 'RegisterWatcher');
    RegisterMethod(@TCryptographicLibrary.DegisterWatcher, 'DegisterWatcher');
    RegisterVirtualMethod(@TCryptographicLibrary.ProgIdsChanged, 'ProgIdsChanged');
    RegisterMethod(@TCryptographicLibrary.RegisterSimpleBlockTransform, 'RegisterSimpleBlockTransform');
    RegisterMethod(@TCryptographicLibrary.GetCipherChoices, 'GetCipherChoices');
    RegisterMethod(@TCryptographicLibrary.ComputeCipherDisplayName, 'ComputeCipherDisplayName');
    RegisterMethod(@TCryptographicLibrary.GetHashChoices, 'GetHashChoices');
    RegisterMethod(@TCryptographicLibrary.ComputeHashDisplayName, 'ComputeHashDisplayName');
    RegisterMethod(@TCryptographicLibrary.GetChainChoices, 'GetChainChoices');
    RegisterMethod(@TCryptographicLibrary.ComputeChainDisplayName, 'ComputeChainDisplayName');
    RegisterPropertyHelper(@TCryptographicLibraryStreamCiphers_ByProgId_R,nil,'StreamCiphers_ByProgId');
    RegisterPropertyHelper(@TCryptographicLibraryStreamCiphers_ByDisplayName_R,nil,'StreamCiphers_ByDisplayName');
    RegisterPropertyHelper(@TCryptographicLibraryStreamCipherDisplayNames_R,nil,'StreamCipherDisplayNames');
    RegisterPropertyHelper(@TCryptographicLibraryBlockCiphers_ByProgId_R,nil,'BlockCiphers_ByProgId');
    RegisterPropertyHelper(@TCryptographicLibraryBlockCiphers_ByDisplayName_R,nil,'BlockCiphers_ByDisplayName');
    RegisterPropertyHelper(@TCryptographicLibraryBlockCipherDisplayNames_R,nil,'BlockCipherDisplayNames');
    RegisterPropertyHelper(@TCryptographicLibraryChainModes_ByProgId_R,nil,'ChainModes_ByProgId');
    RegisterPropertyHelper(@TCryptographicLibraryChainModes_ByDisplayName_R,nil,'ChainModes_ByDisplayName');
    RegisterPropertyHelper(@TCryptographicLibraryChainModesDisplayNames_R,nil,'ChainModesDisplayNames');
    RegisterPropertyHelper(@TCryptographicLibraryHashs_ByProgId_R,nil,'Hashs_ByProgId');
    RegisterPropertyHelper(@TCryptographicLibraryHashs_ByDisplayName_R,nil,'Hashs_ByDisplayName');
    RegisterPropertyHelper(@TCryptographicLibraryHashDisplayNames_R,nil,'HashDisplayNames');
    RegisterPropertyHelper(@TCryptographicLibraryParentLibrary_R,@TCryptographicLibraryParentLibrary_W,'ParentLibrary');
    RegisterPropertyHelper(@TCryptographicLibraryCustomCipher_R,nil,'CustomCipher');
    RegisterPropertyHelper(@TCryptographicLibraryOnCustomCipherGenerateKey_R,@TCryptographicLibraryOnCustomCipherGenerateKey_W,'OnCustomCipherGenerateKey');
    RegisterPropertyHelper(@TCryptographicLibraryOnCustomCipherStart_Encrypt_R,@TCryptographicLibraryOnCustomCipherStart_Encrypt_W,'OnCustomCipherStart_Encrypt');
    RegisterPropertyHelper(@TCryptographicLibraryOnCustomCipherStart_Decrypt_R,@TCryptographicLibraryOnCustomCipherStart_Decrypt_W,'OnCustomCipherStart_Decrypt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomStreamCipher(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomStreamCipher) do
  begin
    RegisterPropertyHelper(@TCustomStreamCipherDisplayName_R,@TCustomStreamCipherDisplayName_W,'DisplayName');
    RegisterPropertyHelper(@TCustomStreamCipherProgId_R,@TCustomStreamCipherProgId_W,'ProgId');
    RegisterPropertyHelper(@TCustomStreamCipherFeatures_R,@TCustomStreamCipherFeatures_W,'Features');
    RegisterPropertyHelper(@TCustomStreamCipherSeedByteSize_R,@TCustomStreamCipherSeedByteSize_W,'SeedByteSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_CryptographicLibrary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCryptographicLibrary) do
  RIRegister_TCustomStreamCipher(CL);
  RIRegister_TCryptographicLibrary(CL);
end;

 
 
{ TPSImport_uTPLb_CryptographicLibrary }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_CryptographicLibrary.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_CryptographicLibrary(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_CryptographicLibrary.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_CryptographicLibrary(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
