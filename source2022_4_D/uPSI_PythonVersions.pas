unit uPSI_PythonVersions;
{
Tinherit from tobject convert from record to class
https://github.com/magicmonty/delphi-code-coverage/blob/master/3rdParty/JWAPI/jwapi2.2a/Win32API/JwaWinBase.pas
https://github.com/maxkleiner/python4delphi/blob/master/Source/PythonVersions.pas


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
  TPSImport_PythonVersions = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPythonVersion(CL: TPSPascalCompiler);
procedure SIRegister_PythonVersions(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PythonVersions_Routines(S: TPSExec);
procedure RIRegister_TPythonVersion(CL: TPSRuntimeClassImporter);
procedure RIRegister_PythonVersions(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   PythonVersions
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PythonVersions]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPythonVersion(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPythonVersion') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPythonVersion') do
  begin
    RegisterProperty('IsRegistered', 'Boolean', iptrw);
    RegisterProperty('IsAllUsers', 'Boolean', iptrw);
    RegisterProperty('SysVersion', 'string', iptrw);
    RegisterProperty('Version', 'string', iptrw);
    RegisterProperty('DLLPath', 'string', iptrw);
    RegisterProperty('InstallPath', 'string', iptrw);
    RegisterProperty('PythonPath', 'string', iptrw);
    RegisterMethod('Function Is_venv : Boolean');
    RegisterMethod('Function Is_virtualenv : Boolean');
    RegisterMethod('Function Is_conda : Boolean');
    RegisterMethod('Procedure AssignTo( PythonEngine : TPersistent)');
    RegisterProperty('PythonExecutable', 'string', iptr);
    RegisterProperty('DLLName', 'string', iptr);
    RegisterProperty('SysArchitecture', 'string', iptr);
    RegisterProperty('IsPython3K', 'Boolean', iptr);
    RegisterProperty('HelpFile', 'string', iptrw);
    RegisterProperty('DisplayName', 'string', iptrw);
    RegisterProperty('ApiVersion', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PythonVersions(CL: TPSPascalCompiler);
begin
  SIRegister_TPythonVersion(CL);
  CL.AddTypeS('TPythonVersions', 'array of TPythonVersion');
 CL.AddDelphiFunction('Function CompareVersions( A, B : string) : Integer');
 CL.AddDelphiFunction('Function IsEXEx64( const EXEName : string) : Boolean');
 CL.AddDelphiFunction('Function Isx64( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function GetRegisteredPythonVersion( SysVersion : string; out PythonVersion : TPythonVersion) : Boolean');
 CL.AddDelphiFunction('Function GetRegisteredPythonVersions : TPythonVersions');
 CL.AddDelphiFunction('Function GetLatestRegisteredPythonVersion( out PythonVersion : TPythonVersion) : Boolean');
 CL.AddDelphiFunction('Function PythonVersionFromPath( const Path : string; out PythonVersion : TPythonVersion; AcceptVirtualEnvs : Boolean) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPythonVersionApiVersion_R(Self: TPythonVersion; var T: integer);
begin T := Self.ApiVersion; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionDisplayName_W(Self: TPythonVersion; const T: string);
begin Self.DisplayName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionDisplayName_R(Self: TPythonVersion; var T: string);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionHelpFile_W(Self: TPythonVersion; const T: string);
begin Self.HelpFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionHelpFile_R(Self: TPythonVersion; var T: string);
begin T := Self.HelpFile; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionIsPython3K_R(Self: TPythonVersion; var T: Boolean);
begin T := Self.IsPython3K; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionSysArchitecture_R(Self: TPythonVersion; var T: string);
begin T := Self.SysArchitecture; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionDLLName_R(Self: TPythonVersion; var T: string);
begin T := Self.DLLName; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionPythonExecutable_R(Self: TPythonVersion; var T: string);
begin T := Self.PythonExecutable; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionPythonPath_W(Self: TPythonVersion; const T: string);
Begin Self.PythonPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionPythonPath_R(Self: TPythonVersion; var T: string);
Begin T := Self.PythonPath; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionInstallPath_W(Self: TPythonVersion; const T: string);
Begin Self.InstallPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionInstallPath_R(Self: TPythonVersion; var T: string);
Begin T := Self.InstallPath; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionDLLPath_W(Self: TPythonVersion; const T: string);
Begin Self.DLLPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionDLLPath_R(Self: TPythonVersion; var T: string);
Begin T := Self.DLLPath; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionVersion_W(Self: TPythonVersion; const T: string);
Begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionVersion_R(Self: TPythonVersion; var T: string);
Begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionSysVersion_W(Self: TPythonVersion; const T: string);
Begin Self.SysVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionSysVersion_R(Self: TPythonVersion; var T: string);
Begin T := Self.SysVersion; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionIsAllUsers_W(Self: TPythonVersion; const T: Boolean);
Begin Self.IsAllUsers := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionIsAllUsers_R(Self: TPythonVersion; var T: Boolean);
Begin T := Self.IsAllUsers; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionIsRegistered_W(Self: TPythonVersion; const T: Boolean);
Begin Self.IsRegistered := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonVersionIsRegistered_R(Self: TPythonVersion; var T: Boolean);
Begin T := Self.IsRegistered; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PythonVersions_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CompareVersions, 'CompareVersions', cdRegister);
 S.RegisterDelphiFunction(@IsEXEx64, 'IsEXEx64', cdRegister);
 S.RegisterDelphiFunction(@Isx64, 'Isx64', cdRegister);
 S.RegisterDelphiFunction(@GetRegisteredPythonVersion, 'GetRegisteredPythonVersion', cdRegister);
 S.RegisterDelphiFunction(@GetRegisteredPythonVersions, 'GetRegisteredPythonVersions', cdRegister);
 S.RegisterDelphiFunction(@GetLatestRegisteredPythonVersion, 'GetLatestRegisteredPythonVersion', cdRegister);
 S.RegisterDelphiFunction(@PythonVersionFromPath, 'PythonVersionFromPath', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPythonVersion(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPythonVersion) do
  begin
    RegisterPropertyHelper(@TPythonVersionIsRegistered_R,@TPythonVersionIsRegistered_W,'IsRegistered');
    RegisterPropertyHelper(@TPythonVersionIsAllUsers_R,@TPythonVersionIsAllUsers_W,'IsAllUsers');
    RegisterPropertyHelper(@TPythonVersionSysVersion_R,@TPythonVersionSysVersion_W,'SysVersion');
    RegisterPropertyHelper(@TPythonVersionVersion_R,@TPythonVersionVersion_W,'Version');
    RegisterPropertyHelper(@TPythonVersionDLLPath_R,@TPythonVersionDLLPath_W,'DLLPath');
    RegisterPropertyHelper(@TPythonVersionInstallPath_R,@TPythonVersionInstallPath_W,'InstallPath');
    RegisterPropertyHelper(@TPythonVersionPythonPath_R,@TPythonVersionPythonPath_W,'PythonPath');
    RegisterMethod(@TPythonVersion.Is_venv, 'Is_venv');
    RegisterMethod(@TPythonVersion.Is_virtualenv, 'Is_virtualenv');
    RegisterMethod(@TPythonVersion.Is_conda, 'Is_conda');
    RegisterMethod(@TPythonVersion.AssignTo, 'AssignTo');
    RegisterPropertyHelper(@TPythonVersionPythonExecutable_R,nil,'PythonExecutable');
    RegisterPropertyHelper(@TPythonVersionDLLName_R,nil,'DLLName');
    RegisterPropertyHelper(@TPythonVersionSysArchitecture_R,nil,'SysArchitecture');
    RegisterPropertyHelper(@TPythonVersionIsPython3K_R,nil,'IsPython3K');
    RegisterPropertyHelper(@TPythonVersionHelpFile_R,@TPythonVersionHelpFile_W,'HelpFile');
    RegisterPropertyHelper(@TPythonVersionDisplayName_R,@TPythonVersionDisplayName_W,'DisplayName');
    RegisterPropertyHelper(@TPythonVersionApiVersion_R,nil,'ApiVersion');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PythonVersions(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPythonVersion(CL);
end;

 
 
{ TPSImport_PythonVersions }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PythonVersions.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PythonVersions(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PythonVersions.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PythonVersions(ri);
  RIRegister_PythonVersions_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
