unit uPSI_IDECmdLine;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_IDECmdLine = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IDECmdLine(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IDECmdLine_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // FileUtil
  LazFileUtils
  //LazConf
  //,LCLProc
  ,IDECmdLine
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IDECmdLine]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IDECmdLine(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ShowSetupDialogOptLong','String').SetString( '--setup');
 CL.AddConstantN('PrimaryConfPathOptLong','String').SetString( '--primary-config-path=');
 CL.AddConstantN('PrimaryConfPathOptShort','String').SetString( '--pcp=');
 CL.AddConstantN('SecondaryConfPathOptLong','String').SetString( '--secondary-config-path=');
 CL.AddConstantN('SecondaryConfPathOptShort','String').SetString( '--scp=');
 CL.AddConstantN('NoSplashScreenOptLong','String').SetString( '--no-splash-screen');
 CL.AddConstantN('NoSplashScreenOptShort','String').SetString( '--nsc');
 CL.AddConstantN('StartedByStartLazarusOpt','String').SetString( '--started-by-startlazarus');
 CL.AddConstantN('SkipLastProjectOpt','String').SetString( '--skip-last-project');
 CL.AddConstantN('DebugLogOpt','String').SetString( '--debug-log=');
 CL.AddConstantN('DebugLogOptEnable','String').SetString( '--debug-enable=');
 CL.AddConstantN('LanguageOpt','String').SetString( '--language=');
 CL.AddConstantN('LazarusDirOpt','String').SetString( '--lazarusdir=');
 CL.AddDelphiFunction('Procedure ParseCommandLine( aCmdLineParams : TStrings; out IDEPid : Integer; out ShowSplashScreen : boolean)');
 CL.AddDelphiFunction('Function GetCommandLineParameters( aCmdLineParams : TStrings; isStartLazarus : Boolean) : string');
 CL.AddDelphiFunction('Function ExtractPrimaryConfigPath( aCmdLineParams : TStrings) : string');
 CL.AddDelphiFunction('Function IsHelpRequested : Boolean');
 CL.AddDelphiFunction('Function IsVersionRequested : boolean');
 CL.AddDelphiFunction('Function GetLanguageSpecified : string');
 CL.AddDelphiFunction('Function ParamIsOption( ParamIndex : integer; const Option : string) : boolean');
 CL.AddDelphiFunction('Function ParamIsOptionPlusValue( ParamIndex : integer; const Option : string; out AValue : string) : boolean');
 CL.AddDelphiFunction('Procedure ParseNoGuiCmdLineParams');
 CL.AddDelphiFunction('Function ExtractCmdLineFilenames : TStrings');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_IDECmdLine_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ParseCommandLine, 'ParseCommandLine', cdRegister);
 S.RegisterDelphiFunction(@GetCommandLineParameters, 'GetCommandLineParameters', cdRegister);
 S.RegisterDelphiFunction(@ExtractPrimaryConfigPath, 'ExtractPrimaryConfigPath', cdRegister);
 S.RegisterDelphiFunction(@IsHelpRequested, 'IsHelpRequested', cdRegister);
 S.RegisterDelphiFunction(@IsVersionRequested, 'IsVersionRequested', cdRegister);
 S.RegisterDelphiFunction(@GetLanguageSpecified, 'GetLanguageSpecified', cdRegister);
 S.RegisterDelphiFunction(@ParamIsOption, 'ParamIsOption', cdRegister);
 S.RegisterDelphiFunction(@ParamIsOptionPlusValue, 'ParamIsOptionPlusValue', cdRegister);
 S.RegisterDelphiFunction(@ParseNoGuiCmdLineParams, 'ParseNoGuiCmdLineParams', cdRegister);
 S.RegisterDelphiFunction(@ExtractCmdLineFilenames, 'ExtractCmdLineFilenames', cdRegister);
end;

 
 
{ TPSImport_IDECmdLine }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IDECmdLine.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IDECmdLine(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IDECmdLine.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_IDECmdLine(ri);
  RIRegister_IDECmdLine_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.