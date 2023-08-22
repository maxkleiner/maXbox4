unit uPSI_IdNTLM;
{
        two messages emax
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
  TPSImport_IdNTLM = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IdNTLM(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdNTLM_Routines(S: TPSExec);

procedure Register;

implementation


uses
   IdSSLOpenSSLHeaders
  ,IdNTLM
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdNTLM]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IdNTLM(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('Pdes_key_schedule', '^des_key_schedule // will not work');
 CL.AddDelphiFunction('Function BuildType1Message( ADomain, AHost : String) : String');
 CL.AddDelphiFunction('Function BuildType3Message( ADomain, AHost, AUsername : WideString; APassword, ANonce : String) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_IdNTLM_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BuildType1Message, 'BuildType1Message', cdRegister);
 S.RegisterDelphiFunction(@BuildType3Message, 'BuildType3Message', cdRegister);
end;

 
 
{ TPSImport_IdNTLM }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdNTLM.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdNTLM(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdNTLM.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_IdNTLM(ri);
  RIRegister_IdNTLM_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
