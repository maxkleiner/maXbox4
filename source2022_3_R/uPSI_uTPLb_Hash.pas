unit uPSI_uTPLb_Hash;
{
hash max
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
  TPSImport_uTPLb_Hash = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THash(CL: TPSPascalCompiler);
procedure SIRegister_TSimpleHash(CL: TPSPascalCompiler);
procedure SIRegister_IHash_TestAccess(CL: TPSPascalCompiler);
procedure SIRegister_IHash(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_Hash(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_THash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpleHash(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_Hash(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uTPLb_StreamCipher
  ,uTPLb_BaseNonVisualComponent
  ,uTPLb_CryptographicLibrary
  ,uTPLb_HashDsc
  ,uTPLb_Hash
  ;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_Hash]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTPLb_BaseNonVisualComponent', 'THash') do
  with CL.AddClassN(CL.FindClass('TTPLb_BaseNonVisualComponent'),'THash') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Begin_Hash');
    RegisterMethod('Procedure UpdateMemory( const Plaintext, PlaintextLen : integer)');
    RegisterMethod('Procedure End_Hash');
    RegisterMethod('Procedure Burn');
    RegisterMethod('Procedure HashStream( Plaintext : TStream)');
    RegisterMethod('Procedure HashFile( const PlaintextFileName : string)');
    RegisterMethod('Procedure HashString( const Plaintext : string)');
    RegisterMethod('Procedure HashAnsiString( const Plaintext : ansistring)');
    RegisterMethod('Function isUserAborted : boolean');
    RegisterProperty('isHashing', 'boolean', iptr);
    RegisterProperty('HashId', 'string', iptrw);
    RegisterProperty('HashOutputValue', 'TStream', iptr);
    RegisterProperty('Hash', 'string', iptrw);
    RegisterProperty('Features', 'TAlgorithmicFeatureSet', iptr);
    RegisterProperty('CryptoLibrary', 'TCryptographicLibrary', iptrw);
    RegisterProperty('OnProgress', 'TOnHashProgress', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpleHash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedPersistent', 'TSimpleHash') do
  with CL.AddClassN(CL.FindClass('TInterfacedPersistent'),'TSimpleHash') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free;');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IHash_TestAccess(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IHash_TestAccess') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IHash_TestAccess, 'IHash_TestAccess') do
  begin
    RegisterMethod('Function GetHasher : IHasher', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IHash(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IHash') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IHash, 'IHash') do
  begin
    RegisterMethod('Function GetIsHashing : boolean', cdRegister);
    RegisterMethod('Function GetHash : IHashDsc', cdRegister);
    RegisterMethod('Procedure SetHash( const Value : IHashDsc)', cdRegister);
    RegisterMethod('Function GetHashOutput : TStream', cdRegister);
    RegisterMethod('Function GetonProgress : TOnHashProgress', cdRegister);
    RegisterMethod('Procedure SetOnProgress( Value : TOnHashProgress)', cdRegister);
    RegisterMethod('Procedure Begin_Hash', cdRegister);
    RegisterMethod('Procedure UpdateMemory( const Plaintext, PlaintextLen : integer)', cdRegister);
    RegisterMethod('Procedure End_Hash', cdRegister);
    RegisterMethod('Procedure Burn', cdRegister);
    RegisterMethod('Procedure HashStream( Plaintext : TStream)', cdRegister);
    RegisterMethod('Procedure HashFile( const PlaintextFileName : string)', cdRegister);
    RegisterMethod('Procedure HashString( const Plaintext : string)', cdRegister);
    RegisterMethod('Procedure HashAnsiString( const Plaintext : ansistring)', cdRegister);
    RegisterMethod('Function isUserAborted : boolean', cdRegister);
    RegisterMethod('Procedure WriteHashOutputToStream( Dest : TStream)', cdRegister);
    RegisterMethod('Procedure WriteHashOutputToMemory( var Dest)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_Hash(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOnHashProgress', 'Function ( Sender : TObject; CountBytesProcessed : int64) : boolean');
  SIRegister_IHash(CL);
  SIRegister_IHash_TestAccess(CL);
  SIRegister_TSimpleHash(CL);
  SIRegister_THash(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THashOnProgress_W(Self: THash; const T: TOnHashProgress);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure THashOnProgress_R(Self: THash; var T: TOnHashProgress);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure THashCryptoLibrary_W(Self: THash; const T: TCryptographicLibrary);
begin Self.CryptoLibrary := T; end;

(*----------------------------------------------------------------------------*)
procedure THashCryptoLibrary_R(Self: THash; var T: TCryptographicLibrary);
begin T := Self.CryptoLibrary; end;

(*----------------------------------------------------------------------------*)
procedure THashFeatures_R(Self: THash; var T: TAlgorithmicFeatureSet);
begin T := Self.Features; end;

(*----------------------------------------------------------------------------*)
procedure THashHash_W(Self: THash; const T: string);
begin Self.Hash := T; end;

(*----------------------------------------------------------------------------*)
procedure THashHash_R(Self: THash; var T: string);
begin T := Self.Hash; end;

(*----------------------------------------------------------------------------*)
procedure THashHashOutputValue_R(Self: THash; var T: TStream);
begin T := Self.HashOutputValue; end;

(*----------------------------------------------------------------------------*)
procedure THashHashId_W(Self: THash; const T: string);
begin Self.HashId := T; end;

(*----------------------------------------------------------------------------*)
procedure THashHashId_R(Self: THash; var T: string);
begin T := Self.HashId; end;

(*----------------------------------------------------------------------------*)
procedure THashisHashing_R(Self: THash; var T: boolean);
begin T := Self.isHashing; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THash) do begin
    RegisterConstructor(@THash.Create, 'Create');
      RegisterMethod(@THash.Destroy, 'Free');
    RegisterMethod(@THash.Begin_Hash, 'Begin_Hash');
    RegisterMethod(@THash.UpdateMemory, 'UpdateMemory');
    RegisterMethod(@THash.End_Hash, 'End_Hash');
    RegisterMethod(@THash.Burn, 'Burn');
    RegisterMethod(@THash.HashStream, 'HashStream');
    RegisterMethod(@THash.HashFile, 'HashFile');
    RegisterMethod(@THash.HashString, 'HashString');
    RegisterMethod(@THash.HashAnsiString, 'HashAnsiString');
    RegisterMethod(@THash.isUserAborted, 'isUserAborted');
    RegisterPropertyHelper(@THashisHashing_R,nil,'isHashing');
    RegisterPropertyHelper(@THashHashId_R,@THashHashId_W,'HashId');
    RegisterPropertyHelper(@THashHashOutputValue_R,nil,'HashOutputValue');
    RegisterPropertyHelper(@THashHash_R,@THashHash_W,'Hash');
    RegisterPropertyHelper(@THashFeatures_R,nil,'Features');
    RegisterPropertyHelper(@THashCryptoLibrary_R,@THashCryptoLibrary_W,'CryptoLibrary');
    RegisterPropertyHelper(@THashOnProgress_R,@THashOnProgress_W,'OnProgress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpleHash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleHash) do begin
    RegisterConstructor(@TSimpleHash.Create, 'Create');
      RegisterMethod(@TSimpleHash.Destroy, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_Hash(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSimpleHash(CL);
  RIRegister_THash(CL);
end;

 
 
{ TPSImport_uTPLb_Hash }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Hash.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_Hash(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Hash.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_Hash(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
