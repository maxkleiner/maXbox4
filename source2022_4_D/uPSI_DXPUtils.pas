unit uPSI_DXPUtils;
{
    of openGL from GLScene
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
  TPSImport_DXPUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_DXPUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DXPUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Forms
  ,Windows
  ,DXPUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DXPUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_DXPUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function glExecuteAndWait( cmdLine : String; visibility : Word; timeout : Cardinal; killAppOnTimeOut : Boolean) : Integer');
 CL.AddDelphiFunction('Function GetTemporaryFilesPath : String');
 CL.AddDelphiFunction('Function GetTemporaryFileName : String');
 CL.AddDelphiFunction('Function FindFileInPaths( const fileName, paths : String) : String');
 CL.AddDelphiFunction('Function PathsToString( const paths : TStrings) : String');
 CL.AddDelphiFunction('Procedure StringToPaths( const pathsString : String; paths : TStrings)');
 //CL.AddDelphiFunction('Function MacroExpandPath( const aPath : String) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_DXPUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ExecuteAndWait, 'glExecuteAndWait', cdRegister);
 S.RegisterDelphiFunction(@GetTemporaryFilesPath, 'GetTemporaryFilesPath', cdRegister);
 S.RegisterDelphiFunction(@GetTemporaryFileName, 'GetTemporaryFileName', cdRegister);
 S.RegisterDelphiFunction(@FindFileInPaths, 'FindFileInPaths', cdRegister);
 S.RegisterDelphiFunction(@PathsToString, 'PathsToString', cdRegister);
 S.RegisterDelphiFunction(@StringToPaths, 'StringToPaths', cdRegister);
 //S.RegisterDelphiFunction(@MacroExpandPath, 'MacroExpandPath', cdRegister);
end;

 
 
{ TPSImport_DXPUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DXPUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DXPUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DXPUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_DXPUtils(ri);
  RIRegister_DXPUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
