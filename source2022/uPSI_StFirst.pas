unit uPSI_StFirst;
{
 singleton
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
  TPSImport_StFirst = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StFirst(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StFirst_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Forms
  ,Dialogs
  ,StBase
  ,StFirst
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StFirst]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StFirst(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function IsFirstInstance : Boolean');
 CL.AddDelphiFunction('Procedure ActivateFirst( AString : PChar)');
 CL.AddDelphiFunction('Procedure ActivateFirstCommandLine');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StFirst_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsFirstInstance, 'IsFirstInstance', cdRegister);
 S.RegisterDelphiFunction(@ActivateFirst, 'ActivateFirst', cdRegister);
 S.RegisterDelphiFunction(@ActivateFirstCommandLine, 'ActivateFirstCommandLine', cdRegister);
end;



{ TPSImport_StFirst }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StFirst.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StFirst(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StFirst.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StFirst(ri);
  RIRegister_StFirst_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
