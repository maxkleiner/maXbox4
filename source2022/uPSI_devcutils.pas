unit uPSI_devcutils;
{
  for more shell activities with reboot
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
  TPSImport_devcutils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_devcutils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_devcutils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   //Windows
  //,Forms
  //,Consts
  //,Graphics
  //,Dialogs
  devcutils
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_devcutils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_devcutils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function CDExecuteFile( const FileName, Params, DefaultDir : string; ShowCmd : Integer) : THandle');
 CL.AddDelphiFunction('Procedure CDCopyFile( const FileName, DestName : string)');
 CL.AddDelphiFunction('Procedure CDMoveFile( const FileName, DestName : string)');
 CL.AddDelphiFunction('Function MakeCommaTextToColor( Text : string; Index : Integer; DefaultColor : TColor) : TColor');
 CL.AddDelphiFunction('Procedure CDDeleteFiles( Sender : TObject; s : string)');
 CL.AddDelphiFunction('Function CDGetTempDir : string');
 CL.AddDelphiFunction('Function CDGetFileSize( FileName : string) : longint');
 CL.AddDelphiFunction('Function GetFileTime( FileName : string) : longint');
 CL.AddDelphiFunction('Function GetShortName( FileName : string) : string');
 CL.AddDelphiFunction('Function GetFullName( FileName : string) : string');
 CL.AddDelphiFunction('Function WinReboot : boolean');
 CL.AddDelphiFunction('Function WinDir : String');
 CL.AddDelphiFunction('Function RunFile( FileToRun : string; Params : string; Dir : string; Wait : boolean) : cardinal');
 CL.AddDelphiFunction('Function RunFile_( Cmd, WorkDir : string; Wait : boolean) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_devcutils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ExecuteFile, 'CDExecuteFile', cdRegister);
 S.RegisterDelphiFunction(@CopyFile, 'CDCopyFile', cdRegister);
 S.RegisterDelphiFunction(@MoveFile, 'CDMoveFile', cdRegister);
 S.RegisterDelphiFunction(@MakeCommaTextToColor, 'MakeCommaTextToColor', cdRegister);
 S.RegisterDelphiFunction(@DeleteFiles, 'CDDeleteFiles', cdRegister);
 S.RegisterDelphiFunction(@GetTempDir, 'CDGetTempDir', cdRegister);
 S.RegisterDelphiFunction(@GetFileSize, 'CDGetFileSize', cdRegister);
 S.RegisterDelphiFunction(@GetFileTime, 'GetFileTime', cdRegister);
 S.RegisterDelphiFunction(@GetShortName, 'GetShortName', cdRegister);
 S.RegisterDelphiFunction(@GetFullName, 'GetFullName', cdRegister);
 S.RegisterDelphiFunction(@WinReboot, 'WinReboot', cdRegister);
 S.RegisterDelphiFunction(@WinDir, 'WinDir', cdRegister);
 S.RegisterDelphiFunction(@RunFile, 'RunFile', cdRegister);
 S.RegisterDelphiFunction(@RunFile_, 'RunFile_', cdRegister);
end;

 
 
{ TPSImport_devcutils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_devcutils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_devcutils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_devcutils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_devcutils(ri);
  RIRegister_devcutils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
