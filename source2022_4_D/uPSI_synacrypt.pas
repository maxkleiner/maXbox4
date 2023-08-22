unit uPSI_synacrypt;
{
  for mX4 to Cologne

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
  TPSImport_synacrypt = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynaAes(CL: TPSPascalCompiler);
procedure SIRegister_TSyna3Des(CL: TPSPascalCompiler);
procedure SIRegister_TSynaDes(CL: TPSPascalCompiler);
procedure SIRegister_TSynaCustomDes(CL: TPSPascalCompiler);
procedure SIRegister_TSynaBlockCipher(CL: TPSPascalCompiler);
procedure SIRegister_synacrypt(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_synacrypt_Routines(S: TPSExec);
procedure RIRegister_TSynaAes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSyna3Des(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynaDes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynaCustomDes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynaBlockCipher(CL: TPSRuntimeClassImporter);
procedure RIRegister_synacrypt(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   synautil
  ,synafpc
  ,synacrypt
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_synacrypt]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynaAes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaBlockcipher', 'TSynaAes') do
  with CL.AddClassN(CL.FindClass('TSynaBlockcipher'),'TSynaAes') do
  begin
    RegisterMethod('Function EncryptECB( const InData : AnsiString) : AnsiString');
    RegisterMethod('Function DecryptECB( const InData : AnsiString) : AnsiString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSyna3Des(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaCustomDes', 'TSyna3Des') do
  with CL.AddClassN(CL.FindClass('TSynaCustomDes'),'TSyna3Des') do
  begin
    RegisterMethod('Function EncryptECB( const InData : AnsiString) : AnsiString');
    RegisterMethod('Function DecryptECB( const InData : AnsiString) : AnsiString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynaDes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaCustomDes', 'TSynaDes') do
  with CL.AddClassN(CL.FindClass('TSynaCustomDes'),'TSynaDes') do
  begin
    RegisterMethod('Function EncryptECB( const InData : AnsiString) : AnsiString');
    RegisterMethod('Function DecryptECB( const InData : AnsiString) : AnsiString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynaCustomDes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaBlockcipher', 'TSynaCustomDes') do
  with CL.AddClassN(CL.FindClass('TSynaBlockcipher'),'TSynaCustomDes') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynaBlockCipher(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSynaBlockCipher') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSynaBlockCipher') do
  begin
    RegisterMethod('Procedure SetIV( const Value : AnsiString)');
    RegisterMethod('Function GetIV : AnsiString');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Function EncryptECB( const InData : AnsiString) : AnsiString');
    RegisterMethod('Function DecryptECB( const InData : AnsiString) : AnsiString');
    RegisterMethod('Function EncryptCBC( const Indata : AnsiString) : AnsiString');
    RegisterMethod('Function DecryptCBC( const Indata : AnsiString) : AnsiString');
    RegisterMethod('Function EncryptCFB8bit( const Indata : AnsiString) : AnsiString');
    RegisterMethod('Function DecryptCFB8bit( const Indata : AnsiString) : AnsiString');
    RegisterMethod('Function EncryptCFBblock( const Indata : AnsiString) : AnsiString');
    RegisterMethod('Function DecryptCFBblock( const Indata : AnsiString) : AnsiString');
    RegisterMethod('Function EncryptOFB( const Indata : AnsiString) : AnsiString');
    RegisterMethod('Function DecryptOFB( const Indata : AnsiString) : AnsiString');
    RegisterMethod('Function EncryptCTR( const Indata : AnsiString) : AnsiString');
    RegisterMethod('Function DecryptCTR( const Indata : AnsiString) : AnsiString');
    RegisterMethod('Constructor Create( Key : AnsiString)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_synacrypt(CL: TPSPascalCompiler);
begin
  SIRegister_TSynaBlockCipher(CL);
  SIRegister_TSynaCustomDes(CL);
  SIRegister_TSynaDes(CL);
  SIRegister_TSyna3Des(CL);
 CL.AddConstantN('A_BC','LongInt').SetInt( 4);
 CL.AddConstantN('MAXROUNDS','LongInt').SetInt( 14);
  SIRegister_TSynaAes(CL);
 CL.AddDelphiFunction('Function TestDes : boolean');
 CL.AddDelphiFunction('Function Test3Des : boolean');
 CL.AddDelphiFunction('Function TestAes : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_synacrypt_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TestDes, 'TestDes', cdRegister);
 S.RegisterDelphiFunction(@Test3Des, 'Test3Des', cdRegister);
 S.RegisterDelphiFunction(@TestAes, 'TestAes', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynaAes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynaAes) do
  begin
    RegisterMethod(@TSynaAes.EncryptECB, 'EncryptECB');
    RegisterMethod(@TSynaAes.DecryptECB, 'DecryptECB');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSyna3Des(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSyna3Des) do
  begin
    RegisterMethod(@TSyna3Des.EncryptECB, 'EncryptECB');
    RegisterMethod(@TSyna3Des.DecryptECB, 'DecryptECB');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynaDes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynaDes) do
  begin
    RegisterMethod(@TSynaDes.EncryptECB, 'EncryptECB');
    RegisterMethod(@TSynaDes.DecryptECB, 'DecryptECB');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynaCustomDes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynaCustomDes) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynaBlockCipher(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynaBlockCipher) do
  begin
    RegisterVirtualMethod(@TSynaBlockCipher.SetIV, 'SetIV');
    RegisterVirtualMethod(@TSynaBlockCipher.GetIV, 'GetIV');
    RegisterVirtualMethod(@TSynaBlockCipher.Reset, 'Reset');
    RegisterVirtualMethod(@TSynaBlockCipher.EncryptECB, 'EncryptECB');
    RegisterVirtualMethod(@TSynaBlockCipher.DecryptECB, 'DecryptECB');
    RegisterVirtualMethod(@TSynaBlockCipher.EncryptCBC, 'EncryptCBC');
    RegisterVirtualMethod(@TSynaBlockCipher.DecryptCBC, 'DecryptCBC');
    RegisterVirtualMethod(@TSynaBlockCipher.EncryptCFB8bit, 'EncryptCFB8bit');
    RegisterVirtualMethod(@TSynaBlockCipher.DecryptCFB8bit, 'DecryptCFB8bit');
    RegisterVirtualMethod(@TSynaBlockCipher.EncryptCFBblock, 'EncryptCFBblock');
    RegisterVirtualMethod(@TSynaBlockCipher.DecryptCFBblock, 'DecryptCFBblock');
    RegisterVirtualMethod(@TSynaBlockCipher.EncryptOFB, 'EncryptOFB');
    RegisterVirtualMethod(@TSynaBlockCipher.DecryptOFB, 'DecryptOFB');
    RegisterVirtualMethod(@TSynaBlockCipher.EncryptCTR, 'EncryptCTR');
    RegisterVirtualMethod(@TSynaBlockCipher.DecryptCTR, 'DecryptCTR');
    RegisterConstructor(@TSynaBlockCipher.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_synacrypt(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynaBlockCipher(CL);
  RIRegister_TSynaCustomDes(CL);
  RIRegister_TSynaDes(CL);
  RIRegister_TSyna3Des(CL);
  RIRegister_TSynaAes(CL);
end;

 
 
{ TPSImport_synacrypt }
(*----------------------------------------------------------------------------*)
procedure TPSImport_synacrypt.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_synacrypt(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_synacrypt.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_synacrypt(ri);
  RIRegister_synacrypt_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
