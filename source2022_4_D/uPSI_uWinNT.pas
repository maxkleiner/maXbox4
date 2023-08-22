unit uPSI_uWinNT;
{
of winnt

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
  TPSImport_uWinNT = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uWinNT(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uWinNT_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,uWinNT
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uWinNT]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uWinNT(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function GetSIDStringFromUser( AUsername : AnsiString; AServerName : AnsiString) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uWinNT_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetSIDStringFromUser, 'GetSIDStringFromUser', cdRegister);
end;

 
 
{ TPSImport_uWinNT }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uWinNT.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uWinNT(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uWinNT.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uWinNT_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
