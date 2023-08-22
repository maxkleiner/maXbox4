unit uPSI_uTPLb_Signatory;
{
for tirpo power 

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
  TPSImport_uTPLb_Signatory = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSignatory(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_Signatory(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSignatory(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_Signatory(CL: TPSRuntimeClassImporter);

function AnsiBytesOf(const S: string): TBytes;


procedure Register;

implementation


uses
   uTPLb_BaseNonVisualComponent
  ,uTPLb_Codec
  ,uTPLb_Asymetric
  ,uTPLb_Signatory
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_Signatory]);
end;


//function AnsiBytesOf(const S: string): TBytes;

//type
  //TBytes = array of Byte;

function GetBytesInt(value: Smallint): TBytes;
begin
  SetLength(Result, SizeOf(value));
  Move(value, Result[0], SizeOf(value));
end;

function GetBytes(value: string): TBytes;
begin
  SetLength(Result, SizeOf(value));
  Move(value, Result[0], SizeOf(value));
end;


function AnsiBytesOf(const S: string): TBytes;
begin
  //Result := TEncoding.ANSI.GetBytes(S);
  Result := GetBytes(S);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSignatory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTPLb_BaseNonVisualComponent', 'TSignatory') do
  with CL.AddClassN(CL.FindClass('TTPLb_BaseNonVisualComponent'),'TSignatory') do begin
    RegisterProperty('FGenPhase', 'TGenerateKeysPhase', iptrw);
    RegisterProperty('FCryptoKeys', 'TAsymetricKeyPair', iptrw);
    RegisterProperty('FSigningKeys', 'TAsymetricKeyPair', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Function Sign( Document, Signature : TStream) : boolean');
    RegisterMethod('Function Verify( Document, Signature : TStream) : TVerifyResult');
    RegisterMethod('Function GenerateKeys : boolean');
    RegisterMethod('Procedure StoreKeysToStream( Store : TStream; Parts : TKeyStoragePartSet)');
    RegisterMethod('Procedure LoadKeysFromStream( Store : TStream; Parts : TKeyStoragePartSet)');
    RegisterMethod('Function Can_SaveKeys( Parts : TKeyStoragePartSet) : boolean');
    RegisterMethod('Function HasParts : TKeyStoragePartSet');
    RegisterMethod('Procedure Burn');
    RegisterProperty('Codec', 'TCodec', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_Signatory(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TGenerateKeysPhase', '( gkNeutral, gkGenSigningKeys, gkGenCryptoKeys, gkDone )');
  CL.AddTypeS('TVerifyResult', '( vPass, vFail, vUserAbort )');
  SIRegister_TSignatory(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSignatoryCodec_W(Self: TSignatory; const T: TCodec);
begin Self.Codec := T; end;

(*----------------------------------------------------------------------------*)
procedure TSignatoryCodec_R(Self: TSignatory; var T: TCodec);
begin T := Self.Codec; end;

(*----------------------------------------------------------------------------*)
procedure TSignatoryFSigningKeys_W(Self: TSignatory; const T: TAsymetricKeyPair);
Begin Self.FSigningKeys := T; end;

(*----------------------------------------------------------------------------*)
procedure TSignatoryFSigningKeys_R(Self: TSignatory; var T: TAsymetricKeyPair);
Begin T := Self.FSigningKeys; end;

(*----------------------------------------------------------------------------*)
procedure TSignatoryFCryptoKeys_W(Self: TSignatory; const T: TAsymetricKeyPair);
Begin Self.FCryptoKeys := T; end;

(*----------------------------------------------------------------------------*)
procedure TSignatoryFCryptoKeys_R(Self: TSignatory; var T: TAsymetricKeyPair);
Begin T := Self.FCryptoKeys; end;

(*----------------------------------------------------------------------------*)
procedure TSignatoryFGenPhase_W(Self: TSignatory; const T: TGenerateKeysPhase);
Begin Self.FGenPhase := T; end;

(*----------------------------------------------------------------------------*)
procedure TSignatoryFGenPhase_R(Self: TSignatory; var T: TGenerateKeysPhase);
Begin T := Self.FGenPhase; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSignatory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSignatory) do begin
    RegisterPropertyHelper(@TSignatoryFGenPhase_R,@TSignatoryFGenPhase_W,'FGenPhase');
    RegisterPropertyHelper(@TSignatoryFCryptoKeys_R,@TSignatoryFCryptoKeys_W,'FCryptoKeys');
    RegisterPropertyHelper(@TSignatoryFSigningKeys_R,@TSignatoryFSigningKeys_W,'FSigningKeys');
    RegisterConstructor(@TSignatory.Create, 'Create');
    RegisterMethod(@TSignatory.Destroy, 'Free');
    RegisterMethod(@TSignatory.Sign, 'Sign');
    RegisterMethod(@TSignatory.Verify, 'Verify');
    RegisterMethod(@TSignatory.GenerateKeys, 'GenerateKeys');
    RegisterMethod(@TSignatory.StoreKeysToStream, 'StoreKeysToStream');
    RegisterMethod(@TSignatory.LoadKeysFromStream, 'LoadKeysFromStream');
    RegisterMethod(@TSignatory.Can_SaveKeys, 'Can_SaveKeys');
    RegisterMethod(@TSignatory.HasParts, 'HasParts');
    RegisterMethod(@TSignatory.Burn, 'Burn');
    RegisterPropertyHelper(@TSignatoryCodec_R,@TSignatoryCodec_W,'Codec');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_Signatory(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSignatory(CL);
end;

 
 
{ TPSImport_uTPLb_Signatory }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Signatory.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_Signatory(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Signatory.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_Signatory(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
