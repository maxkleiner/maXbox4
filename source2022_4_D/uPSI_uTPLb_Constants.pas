unit uPSI_uTPLb_Constants;
{
for tests and unit alls   tp lockbox 3 

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
  TPSImport_uTPLb_Constants = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uTPLb_Constants(CL: TPSPascalCompiler);

{ run-time registration functions }

procedure Register;

implementation


uses
   uTPLb_Constants
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_Constants]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_Constants(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('AES_ProgId','String').SetString( 'native.AES-%d');
 CL.AddConstantN('Base64_ProgId','String').SetString( 'native.base64');
 CL.AddConstantN('CBC_ProgId','String').SetString( 'native.CBC');
 CL.AddConstantN('CFB8bit_ProgId','String').SetString( 'native.CFB-8bit');
 CL.AddConstantN('CFB_ProgId','String').SetString( 'native.CFB');
 CL.AddConstantN('CTR_ProgId','String').SetString( 'native.CTR');
 CL.AddConstantN('ECB_ProgId','String').SetString( 'native.ECB');
 CL.AddConstantN('MD5_ProgId','String').SetString( 'native.hash.MD5');
 CL.AddConstantN('OFB_ProgId','String').SetString( 'native.OFB');
 CL.AddConstantN('PCBC_ProgId','String').SetString( 'native.PCBC');
 CL.AddConstantN('SHA1_ProgId','String').SetString( 'native.hash.SHA-1');
 CL.AddConstantN('SHA224_ProgId','String').SetString( 'native.hash.SHA-224');
 CL.AddConstantN('SHA256_ProgId','String').SetString( 'native.hash.SHA-256');
 CL.AddConstantN('SHA384_ProgId','String').SetString( 'native.hash.SHA-384');
 CL.AddConstantN('SHA512_ProgId','String').SetString( 'native.hash.SHA-512');
 CL.AddConstantN('SHA_224_ProgId','String').SetString( 'native.hash.SHA-512/224');
 CL.AddConstantN('SHA512_256_ProgId','String').SetString( 'native.hash.SHA-512/256');
 CL.AddConstantN('RSA_ProgId','String').SetString( 'native.RSA');
 CL.AddConstantN('BlockCipher_ProgId','String').SetString( 'native.StreamToBlock');
 CL.AddConstantN('DES_ProgId','String').SetString( 'native.DES');
 CL.AddConstantN('TripleDES_ProgId','String').SetString( 'native.3DES.2');
 CL.AddConstantN('TripleDES_KO1_ProgId','String').SetString( 'native.3DES.1');
 CL.AddConstantN('Blowfish_ProgId','String').SetString( 'native.Blowfish');
 CL.AddConstantN('Twofish_ProgId','String').SetString( 'native.Twofish');
 CL.AddConstantN('XXTEA_Large_ProgId','String').SetString( 'native.XXTEA.Large.Littleend');
end;

(* === run-time registration functions === *)
 
 
{ TPSImport_uTPLb_Constants }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Constants.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_Constants(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Constants.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
