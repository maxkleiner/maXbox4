unit uPSI_uTPLb_HashDsc;
{
hash max interface
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
  TPSImport_uTPLb_HashDsc = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IHashDsc(CL: TPSPascalCompiler);
procedure SIRegister_IHasher(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_HashDsc(CL: TPSPascalCompiler);

{ run-time registration functions }

procedure Register;

implementation


uses
   uTPLb_StreamCipher
  ,uTPLb_HashDsc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_HashDsc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IHashDsc(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'ICryptoGraphicAlgorithm', 'IHashDsc') do
  with CL.AddInterface(CL.FindInterface('ICryptoGraphicAlgorithm'),IHashDsc, 'IHashDsc') do
  begin
    RegisterMethod('Function DigestSize : integer', cdRegister);
    RegisterMethod('Function UpdateSize : integer', cdRegister);
    RegisterMethod('Function MakeHasher( const Params : IInterface) : IHasher', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IHasher(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IHasher') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IHasher, 'IHasher') do
  begin
    RegisterMethod('Procedure Update( Source : TMemoryStream)', cdRegister);
    RegisterMethod('Procedure End_Hash( PartBlock : TMemoryStream; Digest : TStream)', cdRegister);
    RegisterMethod('Procedure Burn', cdRegister);
    RegisterMethod('Function SelfTest_Source : ansistring', cdRegister);
    RegisterMethod('Function SelfTest_ReferenceHashValue : ansistring', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_HashDsc(CL: TPSPascalCompiler);
begin
  SIRegister_IHasher(CL);
  SIRegister_IHashDsc(CL);
end;

(* === run-time registration functions === *)
 
 
{ TPSImport_uTPLb_HashDsc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_HashDsc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_HashDsc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_HashDsc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
