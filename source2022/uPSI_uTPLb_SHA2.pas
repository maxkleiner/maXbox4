unit uPSI_uTPLb_SHA2;
{
just to implement sha256

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
  TPSImport_uTPLb_SHA2 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSHA2(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_SHA2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSHA2(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_SHA2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uTPLb_HashDsc
  ,uTPLb_StreamCipher
  ,uTPLb_Decorators
  ,uTPLb_SHA2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_SHA2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSHA2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TSHA2') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TSHA2') do
  begin
    RegisterMethod('Constructor Create( Algorithm1 : TSHA2FamilyMember)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_SHA2(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TSHA2FamilyMember', '( SHA_224, SHA_256, SHA_348, SHA_512, SHA_5'
   +'12_224, SHA_512_256 )');
  SIRegister_TSHA2(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TSHA2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSHA2) do
  begin
    RegisterConstructor(@TSHA2.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_SHA2(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSHA2(CL);
end;

 
 
{ TPSImport_uTPLb_SHA2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_SHA2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_SHA2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_SHA2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_SHA2(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
