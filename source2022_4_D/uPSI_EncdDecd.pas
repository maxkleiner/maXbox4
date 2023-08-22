unit uPSI_EncdDecd;
{
  upgrade to encode
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
  TPSImport_EncdDecd = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_EncdDecd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_EncdDecd_Routines(S: TPSExec);

procedure Register;

implementation


uses
   EncdDecd
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_EncdDecd]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EncdDecd(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure EncodeStream( Input, Output : TStream)');
 CL.AddDelphiFunction('Procedure DecodeStream( Input, Output : TStream)');
 CL.AddDelphiFunction('Function EncodeString1( const Input : string) : string');
 CL.AddDelphiFunction('Function DecodeString1( const Input : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_EncdDecd_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EncodeStream, 'EncodeStream', cdRegister);
 S.RegisterDelphiFunction(@DecodeStream, 'DecodeStream', cdRegister);
 S.RegisterDelphiFunction(@EncodeString, 'EncodeString1', cdRegister);
 S.RegisterDelphiFunction(@DecodeString, 'DecodeString1', cdRegister);
end;

 
 
{ TPSImport_EncdDecd }
(*----------------------------------------------------------------------------*)
procedure TPSImport_EncdDecd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_EncdDecd(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_EncdDecd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_EncdDecd(ri);
  RIRegister_EncdDecd_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
