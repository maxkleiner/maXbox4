unit uPSI_InstFnc2;
{
   by inno
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
  TPSImport_InstFnc2 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_InstFnc2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_InstFnc2_Routines(S: TPSExec);

procedure Register;

implementation


uses
   InstFnc2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_InstFnc2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_InstFnc2(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function CreateShellLink( const Filename, Description, ShortcutTo, Parameters, WorkingDir : String; IconFilename : String; const IconIndex, ShowCmd : Integer; const HotKey : Word; FolderShortcut : Boolean; const AppUserModelID : String; const ExcludeFromShowInNewInstall, PreventPinning : Boolean) : String');
 CL.AddDelphiFunction('Procedure RegisterTypeLibrary( const Filename : String)');
 CL.AddDelphiFunction('Procedure UnregisterTypeLibrary( const Filename : String)');
 CL.AddDelphiFunction('Function UnpinShellLink( const Filename : String) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_InstFnc2_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateShellLink, 'CreateShellLink', cdRegister);
 S.RegisterDelphiFunction(@RegisterTypeLibrary, 'RegisterTypeLibrary', cdRegister);
 S.RegisterDelphiFunction(@UnregisterTypeLibrary, 'UnregisterTypeLibrary', cdRegister);
 S.RegisterDelphiFunction(@UnpinShellLink, 'UnpinShellLink', cdRegister);
end;

 
 
{ TPSImport_InstFnc2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_InstFnc2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_InstFnc2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_InstFnc2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_InstFnc2(ri);
  RIRegister_InstFnc2_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
