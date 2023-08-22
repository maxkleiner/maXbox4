unit uPSI_JTools;
{
from developer tools

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
  TPSImport_JTools = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JTools(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JTools_Routines(S: TPSExec);

procedure Register;

implementation


uses
   JTools
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JTools]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JTools(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function ParseCmdLine( ACmdLine : PChar; List : TStrings; QuoteChar : char) : boolean');
 CL.AddDelphiFunction('Function GetCmdSwitchValue( const Switch : string; SwitchChars : TSysCharSet; var Value : string; IgnoreCase : boolean) : boolean');
 //CL.AddDelphiFunction('Procedure ShowError( const S : string; const Args : array of const)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JTools_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ParseCmdLine, 'ParseCmdLine', cdRegister);
 S.RegisterDelphiFunction(@GetCmdSwitchValue, 'GetCmdSwitchValue', cdRegister);
 //S.RegisterDelphiFunction(@ShowError, 'ShowError', cdRegister);
end;

 
 
{ TPSImport_JTools }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JTools.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JTools(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JTools.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JTools_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
