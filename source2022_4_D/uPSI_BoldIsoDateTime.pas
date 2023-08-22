unit uPSI_BoldIsoDateTime;
{
  iso soa
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
  TPSImport_BoldIsoDateTime = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_BoldIsoDateTime(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BoldIsoDateTime_Routines(S: TPSExec);

procedure Register;

implementation


uses
   BoldDefs
  ,BoldIsoDateTime
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BoldIsoDateTime]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_BoldIsoDateTime(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function ParseISODate( s : string) : TDateTime');
 CL.AddDelphiFunction('Function ParseISODateTime( s : string) : TDateTime');
 CL.AddDelphiFunction('Function ParseISOTime( str : string) : TDateTime');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldIsoDateTime_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ParseISODate, 'ParseISODate', cdRegister);
 S.RegisterDelphiFunction(@ParseISODateTime, 'ParseISODateTime', cdRegister);
 S.RegisterDelphiFunction(@ParseISOTime, 'ParseISOTime', cdRegister);
end;

 
 
{ TPSImport_BoldIsoDateTime }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldIsoDateTime.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BoldIsoDateTime(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldIsoDateTime.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_BoldIsoDateTime(ri);
  RIRegister_BoldIsoDateTime_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
