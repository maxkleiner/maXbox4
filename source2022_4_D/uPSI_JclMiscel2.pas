unit uPSI_JclMiscel2;
{
   update of JcLMiscel, all functions with 2 at the end
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
  TPSImport_JclMiscel2 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclMiscel2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclMiscel2_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,JclBase
  ,JclMiscel2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclMiscel2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclMiscel2(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function SetDisplayResolution2( const XRes, YRes : DWORD) : Longint');
 CL.AddDelphiFunction('Function CreateDOSProcessRedirected2( const CommandLine, InputFile, OutputFile : string) : Boolean');
 CL.AddDelphiFunction('Function WinExec322( const Cmd : string; const CmdShow : Integer) : Boolean');
 CL.AddDelphiFunction('Function WinExec32AndWait2( const Cmd : string; const CmdShow : Integer) : Cardinal');
 CL.AddDelphiFunction('Function WinExec32AndRedirectOutput2( const Cmd : string; var Output : string; RawOutput : Boolean) : Cardinal');
  CL.AddTypeS('TJclKillLevel', '( klNormal, klNoSignal, klTimeOut )');
 CL.AddDelphiFunction('Function ExitWindows2( ExitCode : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function LogOffOS2( KillLevel : TJclKillLevel) : Boolean');
 CL.AddDelphiFunction('Function PowerOffOS2( KillLevel : TJclKillLevel) : Boolean');
 CL.AddDelphiFunction('Function ShutDownOS2( KillLevel : TJclKillLevel) : Boolean');
 CL.AddDelphiFunction('Function RebootOS2( KillLevel : TJclKillLevel) : Boolean');
 CL.AddDelphiFunction('Function HibernateOS2( Force, DisableWakeEvents : Boolean) : Boolean');
 CL.AddDelphiFunction('Function SuspendOS2( Force, DisableWakeEvents : Boolean) : Boolean');
 CL.AddDelphiFunction('Function ShutDownDialog2( const DialogMessage : string; TimeOut : DWORD; Force, Reboot : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function ShutDownDialog12( const MachineName, DialogMessage : string; TimeOut : DWORD; Force, Reboot : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function AbortShutDown2 : Boolean;');
 CL.AddDelphiFunction('Function AbortShutDown12( const MachineName : string) : Boolean;');
  CL.AddTypeS('TJclAllowedPowerOperation', '( apoHibernate, apoShutdown, apoSuspend )');
  CL.AddTypeS('TJclAllowedPowerOperations', 'set of TJclAllowedPowerOperation');
 CL.AddDelphiFunction('Function GetAllowedPowerOperations2 : TJclAllowedPowerOperations');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclCreateProcessError');
 CL.AddDelphiFunction('Procedure CreateProcAsUser2( const UserDomain, UserName, PassWord, CommandLine : string)');
 CL.AddDelphiFunction('Procedure CreateProcAsUserEx2( const UserDomain, UserName, Password, CommandLine : string; const Environment : PChar)');
  // with CL.Add(EJclCreateProcessError) do

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function AbortShutDown1_P( const MachineName : string) : Boolean;
Begin Result := JclMiscel2.AbortShutDown(MachineName); END;

(*----------------------------------------------------------------------------*)
Function AbortShutDown_P : Boolean;
Begin Result := JclMiscel2.AbortShutDown; END;

(*----------------------------------------------------------------------------*)
Function ShutDownDialog1_P( const MachineName, DialogMessage : string; TimeOut : DWORD; Force, Reboot : Boolean) : Boolean;
Begin Result := JclMiscel2.ShutDownDialog(MachineName, DialogMessage, TimeOut, Force, Reboot); END;

(*----------------------------------------------------------------------------*)
Function ShutDownDialog_P( const DialogMessage : string; TimeOut : DWORD; Force, Reboot : Boolean) : Boolean;
Begin Result := JclMiscel2.ShutDownDialog(DialogMessage, TimeOut, Force, Reboot); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclMiscel2_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetDisplayResolution, 'SetDisplayResolution2', cdRegister);
 S.RegisterDelphiFunction(@CreateDOSProcessRedirected, 'CreateDOSProcessRedirected2', cdRegister);
 S.RegisterDelphiFunction(@WinExec32, 'WinExec322', cdRegister);
 S.RegisterDelphiFunction(@WinExec32AndWait, 'WinExec32AndWait2', cdRegister);
 S.RegisterDelphiFunction(@WinExec32AndRedirectOutput, 'WinExec32AndRedirectOutput2', cdRegister);
 S.RegisterDelphiFunction(@ExitWindows, 'ExitWindows2', cdRegister);
 S.RegisterDelphiFunction(@LogOffOS, 'LogOffOS2', cdRegister);
 S.RegisterDelphiFunction(@PowerOffOS, 'PowerOffOS2', cdRegister);
 S.RegisterDelphiFunction(@ShutDownOS, 'ShutDownOS2', cdRegister);
 S.RegisterDelphiFunction(@RebootOS, 'RebootOS2', cdRegister);
 S.RegisterDelphiFunction(@HibernateOS, 'HibernateOS2', cdRegister);
 S.RegisterDelphiFunction(@SuspendOS, 'SuspendOS2', cdRegister);
 S.RegisterDelphiFunction(@ShutDownDialog, 'ShutDownDialog2', cdRegister);
 S.RegisterDelphiFunction(@ShutDownDialog1_P, 'ShutDownDialog12', cdRegister);
 S.RegisterDelphiFunction(@AbortShutDown, 'AbortShutDown2', cdRegister);
 S.RegisterDelphiFunction(@AbortShutDown1_P, 'AbortShutDown12', cdRegister);
 //S.RegisterDelphiFunction(@GetAllowedPowerOperations, 'GetAllowedPowerOperations', cdRegister);
//  with CL.Add(EJclCreateProcessError) do
 S.RegisterDelphiFunction(@CreateProcAsUser, 'CreateProcAsUser2', cdRegister);
 S.RegisterDelphiFunction(@CreateProcAsUserEx, 'CreateProcAsUserEx2', cdRegister);
end;

 
 
{ TPSImport_JclMiscel2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMiscel2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclMiscel2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMiscel2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclMiscel2(ri);
  RIRegister_JclMiscel2_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
