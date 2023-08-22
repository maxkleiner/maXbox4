unit uPSI_NetWork;
{
  a late network
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
  TPSImport_NetWork = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_NetWork(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_NetWork_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,NetWork
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_NetWork]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_NetWork(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function GetDomainName2: AnsiString');
 CL.AddDelphiFunction('Function GetDomainController( Domain : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function GetDomainUsers( Controller : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function GetDomainGroups( Controller : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function GetDateTime( Controller : AnsiString) : TDateTime');
 CL.AddDelphiFunction('Function GetFullName2( Controller, UserID : AnsiString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_NetWork_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetDomainName, 'GetDomainName2', cdRegister);
 S.RegisterDelphiFunction(@GetDomainController, 'GetDomainController', cdRegister);
 S.RegisterDelphiFunction(@GetDomainUsers, 'GetDomainUsers', cdRegister);
 S.RegisterDelphiFunction(@GetDomainGroups, 'GetDomainGroups', cdRegister);
 S.RegisterDelphiFunction(@GetDateTime, 'GetDateTime', cdRegister);
 S.RegisterDelphiFunction(@GetFullName, 'GetFullName2', cdRegister);
end;

 
 
{ TPSImport_NetWork }
(*----------------------------------------------------------------------------*)
procedure TPSImport_NetWork.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_NetWork(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_NetWork.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_NetWork(ri);
  RIRegister_NetWork_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
