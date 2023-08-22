unit uPSI_uTPLb_RSA_Engine;
{
for crypto 4 to 8

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
  TPSImport_uTPLb_RSA_Engine = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRSA_Decryptor(CL: TPSPascalCompiler);
procedure SIRegister_TRSA_Encryptor(CL: TPSPascalCompiler);
procedure SIRegister_TRSAKeyPair(CL: TPSPascalCompiler);
procedure SIRegister_TRSA_PrivateKeyPart(CL: TPSPascalCompiler);
procedure SIRegister_TRSA_PublicKeyPart(CL: TPSPascalCompiler);
procedure SIRegister_TRSAKeyPart(CL: TPSPascalCompiler);
procedure SIRegister_TRSA_Engine(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_RSA_Engine(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TRSA_Decryptor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSA_Encryptor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSAKeyPair(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSA_PrivateKeyPart(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSA_PublicKeyPart(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSAKeyPart(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSA_Engine(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_RSA_Engine(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uTPLb_StreamCipher
  ,uTPLb_Asymetric
  ,uTPLb_Codec
  ,uTPLb_CodecIntf
  ,uTPLb_HugeCardinal
  ,uTPLb_MemoryStreamPool
  ,uTPLb_RSA_Engine
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_RSA_Engine]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSA_Decryptor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAsymetricDecryptor', 'TRSA_Decryptor') do
  with CL.AddClassN(CL.FindClass('TAsymetricDecryptor'),'TRSA_Decryptor') do
  begin
    RegisterMethod('Function LoadSymetricKey( Ciphertext : TStream) : TSymetricKey');
    RegisterMethod('Procedure Sign( Signature : TStream; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; var wasAborted : boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSA_Encryptor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAsymetricEncryptor', 'TRSA_Encryptor') do
  with CL.AddClassN(CL.FindClass('TAsymetricEncryptor'),'TRSA_Encryptor') do
  begin
    RegisterMethod('Function GenerateSymetricKey : TSymetricKey');
    RegisterMethod('Function VerifySignature( Document : TStream; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; var wasAborted : boolean) : boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSAKeyPair(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAsymetricKeyPair', 'TRSAKeyPair') do
  with CL.AddClassN(CL.FindClass('TAsymetricKeyPair'),'TRSAKeyPair') do
  begin
    RegisterProperty('F_RSA_n', 'THugeCardinal', iptrw);
    RegisterProperty('F_RSA_d', 'THugeCardinal', iptrw);
    RegisterProperty('F_RSA_e', 'THugeCardinal', iptrw);
    RegisterMethod('Constructor CreateEmpty');
    RegisterMethod('Procedure LoadFromStream( Store : TStream; Parts : TKeyStoragePartSet)');
    RegisterMethod('Procedure StoreToStream( Store : TStream; Parts : TKeyStoragePartSet)');
    RegisterMethod('Procedure Burn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSA_PrivateKeyPart(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRSAKeyPart', 'TRSA_PrivateKeyPart') do
  with CL.AddClassN(CL.FindClass('TRSAKeyPart'),'TRSA_PrivateKeyPart') do
  begin
    RegisterProperty('F_RSA_d', 'THugeCardinal', iptrw);
    RegisterMethod('Procedure SaveToStream( Store : TStream)');
    RegisterMethod('Procedure LoadFromStream( Store : TStream)');
    RegisterMethod('Procedure Burn');
    RegisterMethod('Function isEmpty : boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSA_PublicKeyPart(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRSAKeyPart', 'TRSA_PublicKeyPart') do
  with CL.AddClassN(CL.FindClass('TRSAKeyPart'),'TRSA_PublicKeyPart') do
  begin
    RegisterProperty('F_RSA_e', 'THugeCardinal', iptrw);
    RegisterMethod('Procedure SaveToStream( Store : TStream)');
    RegisterMethod('Procedure LoadFromStream( Store : TStream)');
    RegisterMethod('Procedure Burn');
    RegisterMethod('Function isEmpty : boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSAKeyPart(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAsymtricKeyPart', 'TRSAKeyPart') do
  with CL.AddClassN(CL.FindClass('TAsymtricKeyPart'),'TRSAKeyPart') do
  begin
    RegisterMethod('Procedure SaveToStream( Store : TStream)');
    RegisterMethod('Procedure LoadFromStream( Store : TStream)');
    RegisterMethod('Procedure Burn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSA_Engine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAsymetric_Engine', 'TRSA_Engine') do
  with CL.AddClassN(CL.FindClass('TAsymetric_Engine'),'TRSA_Engine') do
  begin
    RegisterMethod('Procedure GenerateAsymetricKeyPair( KeySizeInBits : cardinal; ProgressSender : TObject; ProgressEvent : TGenerateAsymetricKeyPairProgress; var KeyPair : TAsymetricKeyPair; var wasAborted : boolean)');
    RegisterMethod('Function CreateFromStream( Store : TStream; Parts : TKeyStoragePartSet) : TAsymetricKeyPair');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_RSA_Engine(CL: TPSPascalCompiler);
begin
  SIRegister_TRSA_Engine(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TRSAKeyPair');
  SIRegister_TRSAKeyPart(CL);
  SIRegister_TRSA_PublicKeyPart(CL);
  SIRegister_TRSA_PrivateKeyPart(CL);
  SIRegister_TRSAKeyPair(CL);
  SIRegister_TRSA_Encryptor(CL);
  SIRegister_TRSA_Decryptor(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRSAKeyPairF_RSA_e_W(Self: TRSAKeyPair; const T: THugeCardinal);
Begin Self.F_RSA_e := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSAKeyPairF_RSA_e_R(Self: TRSAKeyPair; var T: THugeCardinal);
Begin T := Self.F_RSA_e; end;

(*----------------------------------------------------------------------------*)
procedure TRSAKeyPairF_RSA_d_W(Self: TRSAKeyPair; const T: THugeCardinal);
Begin Self.F_RSA_d := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSAKeyPairF_RSA_d_R(Self: TRSAKeyPair; var T: THugeCardinal);
Begin T := Self.F_RSA_d; end;

(*----------------------------------------------------------------------------*)
procedure TRSAKeyPairF_RSA_n_W(Self: TRSAKeyPair; const T: THugeCardinal);
Begin Self.F_RSA_n := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSAKeyPairF_RSA_n_R(Self: TRSAKeyPair; var T: THugeCardinal);
Begin T := Self.F_RSA_n; end;

(*----------------------------------------------------------------------------*)
procedure TRSA_PrivateKeyPartF_RSA_d_W(Self: TRSA_PrivateKeyPart; const T: THugeCardinal);
Begin Self.F_RSA_d := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSA_PrivateKeyPartF_RSA_d_R(Self: TRSA_PrivateKeyPart; var T: THugeCardinal);
Begin T := Self.F_RSA_d; end;

(*----------------------------------------------------------------------------*)
procedure TRSA_PublicKeyPartF_RSA_e_W(Self: TRSA_PublicKeyPart; const T: THugeCardinal);
Begin Self.F_RSA_e := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSA_PublicKeyPartF_RSA_e_R(Self: TRSA_PublicKeyPart; var T: THugeCardinal);
Begin T := Self.F_RSA_e; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSA_Decryptor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSA_Decryptor) do
  begin
    RegisterMethod(@TRSA_Decryptor.LoadSymetricKey, 'LoadSymetricKey');
    RegisterMethod(@TRSA_Decryptor.Sign, 'Sign');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSA_Encryptor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSA_Encryptor) do
  begin
    RegisterMethod(@TRSA_Encryptor.GenerateSymetricKey, 'GenerateSymetricKey');
    RegisterMethod(@TRSA_Encryptor.VerifySignature, 'VerifySignature');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSAKeyPair(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSAKeyPair) do
  begin
    RegisterPropertyHelper(@TRSAKeyPairF_RSA_n_R,@TRSAKeyPairF_RSA_n_W,'F_RSA_n');
    RegisterPropertyHelper(@TRSAKeyPairF_RSA_d_R,@TRSAKeyPairF_RSA_d_W,'F_RSA_d');
    RegisterPropertyHelper(@TRSAKeyPairF_RSA_e_R,@TRSAKeyPairF_RSA_e_W,'F_RSA_e');
    RegisterConstructor(@TRSAKeyPair.CreateEmpty, 'CreateEmpty');
    RegisterMethod(@TRSAKeyPair.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TRSAKeyPair.StoreToStream, 'StoreToStream');
    RegisterMethod(@TRSAKeyPair.Burn, 'Burn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSA_PrivateKeyPart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSA_PrivateKeyPart) do
  begin
    RegisterPropertyHelper(@TRSA_PrivateKeyPartF_RSA_d_R,@TRSA_PrivateKeyPartF_RSA_d_W,'F_RSA_d');
    RegisterMethod(@TRSA_PrivateKeyPart.SaveToStream, 'SaveToStream');
    RegisterMethod(@TRSA_PrivateKeyPart.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TRSA_PrivateKeyPart.Burn, 'Burn');
    RegisterMethod(@TRSA_PrivateKeyPart.isEmpty, 'isEmpty');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSA_PublicKeyPart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSA_PublicKeyPart) do
  begin
    RegisterPropertyHelper(@TRSA_PublicKeyPartF_RSA_e_R,@TRSA_PublicKeyPartF_RSA_e_W,'F_RSA_e');
    RegisterMethod(@TRSA_PublicKeyPart.SaveToStream, 'SaveToStream');
    RegisterMethod(@TRSA_PublicKeyPart.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TRSA_PublicKeyPart.Burn, 'Burn');
    RegisterMethod(@TRSA_PublicKeyPart.isEmpty, 'isEmpty');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSAKeyPart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSAKeyPart) do
  begin
    RegisterMethod(@TRSAKeyPart.SaveToStream, 'SaveToStream');
    RegisterMethod(@TRSAKeyPart.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TRSAKeyPart.Burn, 'Burn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSA_Engine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSA_Engine) do
  begin
    RegisterMethod(@TRSA_Engine.GenerateAsymetricKeyPair, 'GenerateAsymetricKeyPair');
    RegisterMethod(@TRSA_Engine.CreateFromStream, 'CreateFromStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_RSA_Engine(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRSA_Engine(CL);
  with CL.Add(TRSAKeyPair) do
  RIRegister_TRSAKeyPart(CL);
  RIRegister_TRSA_PublicKeyPart(CL);
  RIRegister_TRSA_PrivateKeyPart(CL);
  RIRegister_TRSAKeyPair(CL);
  RIRegister_TRSA_Encryptor(CL);
  RIRegister_TRSA_Decryptor(CL);
end;

 
 
{ TPSImport_uTPLb_RSA_Engine }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_RSA_Engine.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_RSA_Engine(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_RSA_Engine.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_RSA_Engine(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
