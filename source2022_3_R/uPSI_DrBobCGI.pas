unit uPSI_DrBobCGI;
{
Tanother support for working CGI unit

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
  TPSImport_DrBobCGI = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_DrBobCGI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DrBobCGI_Routines(S: TPSExec);

procedure Register;

implementation


uses
   DrBobCGI
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DrBobCGI]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_DrBobCGI(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TBobRequestMethod', '( bobUnknown, bobGet, bobPost )');
 CL.AddDelphiFunction('Function bobValue( const Field : ShortString; Convert : Boolean) : ShortString');
 CL.AddDelphiFunction('Function CookieValue( const Field : ShortString) : ShortString');
 CL.AddDelphiFunction('function getCGIEnvValues: string;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_DrBobCGI_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@bobValue, 'bobValue', cdRegister);
 S.RegisterDelphiFunction(@CookieValue, 'CookieValue', cdRegister);
 S.RegisterDelphiFunction(@getCGIEnvValues, 'getCGIEnvValues', cdRegister);
end;

 
 
{ TPSImport_DrBobCGI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DrBobCGI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DrBobCGI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DrBobCGI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DrBobCGI_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
