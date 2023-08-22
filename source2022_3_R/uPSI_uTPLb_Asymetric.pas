unit uPSI_uTPLb_Asymetric;
{
after stream and block
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
  TPSImport_uTPLb_Asymetric = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAsymetric_Engine(CL: TPSPascalCompiler);
procedure SIRegister_ICodec_WithAsymetricSupport(CL: TPSPascalCompiler);
procedure SIRegister_IAsymetric_Engine(CL: TPSPascalCompiler);
procedure SIRegister_TAsymetricDecryptor(CL: TPSPascalCompiler);
procedure SIRegister_TAsymetricEncryptor(CL: TPSPascalCompiler);
procedure SIRegister_TAsymetricEncDec(CL: TPSPascalCompiler);
procedure SIRegister_TAsymetricKeyPair(CL: TPSPascalCompiler);
procedure SIRegister_TAsymtricKeyPart(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_Asymetric(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAsymetric_Engine(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAsymetricDecryptor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAsymetricEncryptor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAsymetricEncDec(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAsymetricKeyPair(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAsymtricKeyPart(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_Asymetric(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uTPLb_StreamCipher
  ,uTPLb_CodecIntf
  ,uTPLb_Asymetric
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_Asymetric]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAsymetric_Engine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TAsymetric_Engine') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TAsymetric_Engine') do
  begin
    RegisterMethod('Procedure GenerateAsymetricKeyPair( KeySizeInBits : cardinal; ProgressSender : TObject; ProgressEvent : TGenerateAsymetricKeyPairProgress; var KeyPair : TAsymetricKeyPair; var wasAborted : boolean)');
    RegisterMethod('Procedure Sign( Document, Signature : TStream; PrivatePart : TAsymtricKeyPart; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; var wasAborted : boolean)');
    RegisterMethod('Function VerifySignature( Document, Signature : TStream; PublicPart : TAsymtricKeyPart; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; var wasAborted : boolean) : boolean');
    RegisterMethod('Function CreateFromStream( Store : TStream; Parts : TKeyStoragePartSet) : TAsymetricKeyPair');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ICodec_WithAsymetricSupport(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'ICodec', 'ICodec_WithAsymetricSupport') do
  with CL.AddInterface(CL.FindInterface('ICodec'),ICodec_WithAsymetricSupport, 'ICodec_WithAsymetricSupport') do
  begin
    RegisterMethod('Function Asymetric_Engine : IAsymetric_Engine', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IAsymetric_Engine(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IStreamCipher', 'IAsymetric_Engine') do
  with CL.AddInterface(CL.FindInterface('IStreamCipher'),IAsymetric_Engine, 'IAsymetric_Engine') do
  begin
    RegisterMethod('Procedure GenerateAsymetricKeyPair( KeySizeInBits : cardinal; ProgressSender : TObject; ProgressEvent : TGenerateAsymetricKeyPairProgress; var KeyPair : TAsymetricKeyPair; var wasAborted : boolean)', cdRegister);
    RegisterMethod('Procedure Sign( Document, Signature : TStream; PrivatePart : TAsymtricKeyPart; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; var wasAborted : boolean)', cdRegister);
    RegisterMethod('Function VerifySignature( Document, Signature : TStream; PublicPart : TAsymtricKeyPart; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; var wasAborted : boolean) : boolean', cdRegister);
    RegisterMethod('Function CreateFromStream( Store : TStream; Parts : TKeyStoragePartSet) : TAsymetricKeyPair', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAsymetricDecryptor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAsymetricEncDec', 'TAsymetricDecryptor') do
  with CL.AddClassN(CL.FindClass('TAsymetricEncDec'),'TAsymetricDecryptor') do
  begin
    RegisterMethod('Function LoadSymetricKey( Ciphertext : TStream) : TSymetricKey');
    RegisterMethod('Procedure Sign( Signature : TStream; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; var wasAborted : boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAsymetricEncryptor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAsymetricEncDec', 'TAsymetricEncryptor') do
  with CL.AddClassN(CL.FindClass('TAsymetricEncDec'),'TAsymetricEncryptor') do
  begin
    RegisterMethod('Function GenerateSymetricKey : TSymetricKey');
    RegisterMethod('Function VerifySignature( Document : TStream; ProgressSender : TObject; ProgressEvent : TOnEncDecProgress; var wasAborted : boolean) : boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAsymetricEncDec(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TAsymetricEncDec') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TAsymetricEncDec') do begin
   RegisterMethod('Procedure Free;');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAsymetricKeyPair(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSymetricKey', 'TAsymetricKeyPair') do
  with CL.AddClassN(CL.FindClass('TSymetricKey'),'TAsymetricKeyPair') do
  begin
    RegisterProperty('FPublicPart', 'TAsymtricKeyPart', iptrw);
    RegisterProperty('FPrivatePart', 'TAsymtricKeyPart', iptrw);
    RegisterMethod('Constructor CreateEmpty');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Function HasParts : TKeyStoragePartSet');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure StoreToStream( Store : TStream; Parts : TKeyStoragePartSet)');
    RegisterMethod('Function Can_StoreToStream( Parts : TKeyStoragePartSet) : boolean');
    RegisterMethod('Procedure LoadFromStream( Store : TStream; Parts : TKeyStoragePartSet)');
    RegisterMethod('Function NominalKeyBitLength : cardinal');
    RegisterMethod('Procedure Burn');
    RegisterMethod('Function Clone : TAsymetricKeyPair');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAsymtricKeyPart(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAsymtricKeyPart') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAsymtricKeyPart') do
  begin
    RegisterMethod('Procedure SaveToStream( Store : TStream)');
    RegisterMethod('Procedure LoadFromStream( Store : TStream)');
    RegisterMethod('Function isEmpty : boolean');
    RegisterMethod('Procedure Burn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_Asymetric(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TKeyStoragePart', '( partPublic, partPrivate )');
  CL.AddTypeS('TKeyStoragePartSet', 'set of TKeyStoragePart');
  SIRegister_TAsymtricKeyPart(CL);
  SIRegister_TAsymetricKeyPair(CL);
  //CL.AddTypeS('TAsymetricKeyPairClass', 'class of TAsymetricKeyPair');
  SIRegister_TAsymetricEncDec(CL);
  SIRegister_TAsymetricEncryptor(CL);
  //CL.AddTypeS('TAsymetricEncryptorClass', 'class of TAsymetricEncryptor');
  SIRegister_TAsymetricDecryptor(CL);
  //CL.AddTypeS('TAsymetricDecryptorClass', 'class of TAsymetricDecryptor');
  SIRegister_IAsymetric_Engine(CL);
  SIRegister_ICodec_WithAsymetricSupport(CL);
  SIRegister_TAsymetric_Engine(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAsymetricKeyPairFPrivatePart_W(Self: TAsymetricKeyPair; const T: TAsymtricKeyPart);
Begin Self.FPrivatePart := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsymetricKeyPairFPrivatePart_R(Self: TAsymetricKeyPair; var T: TAsymtricKeyPart);
Begin T := Self.FPrivatePart; end;

(*----------------------------------------------------------------------------*)
procedure TAsymetricKeyPairFPublicPart_W(Self: TAsymetricKeyPair; const T: TAsymtricKeyPart);
Begin Self.FPublicPart := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsymetricKeyPairFPublicPart_R(Self: TAsymetricKeyPair; var T: TAsymtricKeyPart);
Begin T := Self.FPublicPart; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAsymetric_Engine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAsymetric_Engine) do
  begin
    //RegisterVirtualAbstractMethod(@TAsymetric_Engine, @!.GenerateAsymetricKeyPair, 'GenerateAsymetricKeyPair');
    RegisterVirtualMethod(@TAsymetric_Engine.Sign, 'Sign');
    RegisterVirtualMethod(@TAsymetric_Engine.VerifySignature, 'VerifySignature');
    //RegisterVirtualAbstractMethod(@TAsymetric_Engine, @!.CreateFromStream, 'CreateFromStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAsymetricDecryptor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAsymetricDecryptor) do
  begin
    //RegisterVirtualAbstractMethod(@TAsymetricDecryptor, @!.LoadSymetricKey, 'LoadSymetricKey');
    //RegisterVirtualAbstractMethod(@TAsymetricDecryptor, @!.Sign, 'Sign');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAsymetricEncryptor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAsymetricEncryptor) do
  begin
    //RegisterVirtualAbstractMethod(@TAsymetricEncryptor, @!.GenerateSymetricKey, 'GenerateSymetricKey');
    //RegisterVirtualAbstractMethod(@TAsymetricEncryptor, @!.VerifySignature, 'VerifySignature');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAsymetricEncDec(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAsymetricEncDec) do begin
    RegisterMethod(@TAsymetricEncDec.Destroy, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAsymetricKeyPair(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAsymetricKeyPair) do begin
    RegisterPropertyHelper(@TAsymetricKeyPairFPublicPart_R,@TAsymetricKeyPairFPublicPart_W,'FPublicPart');
    RegisterPropertyHelper(@TAsymetricKeyPairFPrivatePart_R,@TAsymetricKeyPairFPrivatePart_W,'FPrivatePart');
    RegisterVirtualConstructor(@TAsymetricKeyPair.CreateEmpty, 'CreateEmpty');
      RegisterMethod(@TAsymetricKeyPair.Destroy, 'Free');

    RegisterVirtualMethod(@TAsymetricKeyPair.HasParts, 'HasParts');
    RegisterMethod(@TAsymetricKeyPair.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TAsymetricKeyPair.StoreToStream, 'StoreToStream');
    RegisterVirtualMethod(@TAsymetricKeyPair.Can_StoreToStream, 'Can_StoreToStream');
    //RegisterVirtualAbstractMethod(@TAsymetricKeyPair, @!.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TAsymetricKeyPair.NominalKeyBitLength, 'NominalKeyBitLength');
    RegisterMethod(@TAsymetricKeyPair.Burn, 'Burn');
    RegisterVirtualMethod(@TAsymetricKeyPair.Clone, 'Clone');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAsymtricKeyPart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAsymtricKeyPart) do
  begin
    //RegisterVirtualAbstractMethod(@TAsymtricKeyPart, @!.SaveToStream, 'SaveToStream');
    //RegisterVirtualAbstractMethod(@TAsymtricKeyPart, @!.LoadFromStream, 'LoadFromStream');
    //RegisterVirtualAbstractMethod(@TAsymtricKeyPart, @!.isEmpty, 'isEmpty');
    //RegisterVirtualAbstractMethod(@TAsymtricKeyPart, @!.Burn, 'Burn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_Asymetric(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAsymtricKeyPart(CL);
  RIRegister_TAsymetricKeyPair(CL);
  RIRegister_TAsymetricEncDec(CL);
  RIRegister_TAsymetricEncryptor(CL);
  RIRegister_TAsymetricDecryptor(CL);
  RIRegister_TAsymetric_Engine(CL);
end;

 
 
{ TPSImport_uTPLb_Asymetric }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Asymetric.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_Asymetric(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Asymetric.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_Asymetric(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
