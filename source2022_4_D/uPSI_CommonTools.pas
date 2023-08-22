unit uPSI_CommonTools;
{
   winapi   and com
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
  TPSImport_CommonTools = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_MakeComServerMethodsPublic(CL: TPSPascalCompiler);
procedure SIRegister_CommonTools(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CommonTools_Routines(S: TPSExec);
procedure RIRegister_MakeComServerMethodsPublic(CL: TPSRuntimeClassImporter);
procedure RIRegister_CommonTools(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ComServ
  ,ShellApi
  ,CommonTools
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CommonTools]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_MakeComServerMethodsPublic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComServer', 'MakeComServerMethodsPublic') do
  with CL.AddClassN(CL.FindClass('TComServer'),'MakeComServerMethodsPublic') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CommonTools(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('BYTES','LongInt').SetInt( 1);
 CL.AddConstantN('KBYTES','LongInt').SetInt( 1024);
 CL.AddConstantN('DBG_ALIVE','LongWord').SetUInt( Integer ( $11BABE11 ));
 CL.AddConstantN('DBG_DESTROYING','LongWord').SetUInt( Integer ( $44FADE44 ));
 CL.AddConstantN('DBG_GONE','LongWord').SetUInt( $99AC1D99);
 CL.AddConstantN('SHELL_NS_MYCOMPUTER','String').SetString( '::{20D04FE0-3AEA-1069-A2D8-08002B30309D}');
  SIRegister_MakeComServerMethodsPublic(CL);
  CL.AddTypeS('TSomeFileInfo', '( fi_DisplayType, fi_Application )');
 CL.AddDelphiFunction('Function IsFlagSet( dwTestForFlag, dwFlagSet : DWORD) : Boolean');
 CL.AddDelphiFunction('Procedure TBSetFlag( const dwThisFlag : DWORD; var dwFlagSet : DWORD; aSet : Boolean)');
 CL.AddDelphiFunction('Function TBGetTempFolder : string');
 CL.AddDelphiFunction('Function TBGetTempFile : string');
 CL.AddDelphiFunction('Function TBGetModuleFilename : string');
 CL.AddDelphiFunction('Function FormatModuleVersionInfo( const aFilename : string) : string');
 CL.AddDelphiFunction('Function GetVersionInfoString( const aFile, aEntry : string; aLang : WORD) : string');
 CL.AddDelphiFunction('Function TBGetFileSize( aFile : string; aMultipleOf : Integer) : Integer');
 CL.AddDelphiFunction('Function FormatAttribString( aAttr : Integer) : string');
 CL.AddDelphiFunction('Function GetSomeFileInfo( aFile : string; aWhatInfo : TSomeFileInfo) : string');
 CL.AddDelphiFunction('Function ShellRecycle( aWnd : HWND; aFileOrFolder : string) : Boolean');
 CL.AddDelphiFunction('Function IsDebuggerPresent : BOOL');
 CL.AddDelphiFunction('Function TBNotImplemented : HRESULT');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_CommonTools_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsFlagSet, 'IsFlagSet', cdRegister);
 S.RegisterDelphiFunction(@SetFlag, 'TBSetFlag', cdRegister);
 S.RegisterDelphiFunction(@GetTempFolder, 'TBGetTempFolder', cdRegister);
 S.RegisterDelphiFunction(@GetTempFile, 'TBGetTempFile', cdRegister);
 S.RegisterDelphiFunction(@GetModuleFilename, 'TBGetModuleFilename', cdRegister);
 S.RegisterDelphiFunction(@FormatModuleVersionInfo, 'FormatModuleVersionInfo', cdRegister);
 S.RegisterDelphiFunction(@GetVersionInfoString, 'GetVersionInfoString', cdRegister);
 S.RegisterDelphiFunction(@GetFileSize, 'TBGetFileSize', cdRegister);
 S.RegisterDelphiFunction(@FormatAttribString, 'FormatAttribString', cdRegister);
 S.RegisterDelphiFunction(@GetSomeFileInfo, 'GetSomeFileInfo', cdRegister);
 S.RegisterDelphiFunction(@ShellRecycle, 'ShellRecycle', cdRegister);
 S.RegisterDelphiFunction(@IsDebuggerPresent, 'IsDebuggerPresent', CdStdCall);
 S.RegisterDelphiFunction(@NotImplemented, 'TBNotImplemented', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MakeComServerMethodsPublic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(MakeComServerMethodsPublic) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CommonTools(CL: TPSRuntimeClassImporter);
begin
  RIRegister_MakeComServerMethodsPublic(CL);
end;

 
 
{ TPSImport_CommonTools }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CommonTools.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CommonTools(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CommonTools.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CommonTools(ri);
  RIRegister_CommonTools_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
