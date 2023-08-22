unit uPSI_uSettings;
{
  oscilloscope
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
  TPSImport_uSettings = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_uSettings(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uSettings_Routines(S: TPSExec);

procedure Register;

implementation


uses
   IniFiles
  ,Graphics
  ,forms
  ,uSettings
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uSettings]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uSettings(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure SaveOscSettings');
 CL.AddDelphiFunction('Procedure GetOscSettings');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uSettings_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SaveOscSettings, 'SaveOscSettings', cdRegister);
 S.RegisterDelphiFunction(@GetOscSettings, 'GetOscSettings', cdRegister);
end;

 
 
{ TPSImport_uSettings }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uSettings.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uSettings(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uSettings.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uSettings(ri);
  RIRegister_uSettings_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
