unit uPSI_ServiceMgr;
{
   to manage services   plus
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
  TPSImport_ServiceMgr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TServiceManager(CL: TPSPascalCompiler);
procedure SIRegister_ServiceMgr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TServiceManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_ServiceMgr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,WinSvc
  ,ServiceMgr
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ServiceMgr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TServiceManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TServiceManager') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TServiceManager') do begin
    RegisterMethod('Constructor Create( MachineName : string; DatabaseName : string)');
    RegisterMethod('Function Connect( pcMachineName : PChar; DatabaseName : PChar; Access : DWORD) : Boolean');
    RegisterMethod('Function OpenServiceConnection( ServiceName : PChar) : Boolean');
    RegisterMethod('Function StartService : Boolean;');
    RegisterMethod('Function StartService1( NumberOfArgument : DWORD; ServiceArgVectors : PChar) : Boolean;');
    RegisterMethod('Function StopService : Boolean');
    RegisterMethod('Procedure PauseService');
    RegisterMethod('Procedure ContinueService');
    RegisterMethod('Procedure ShutdownService');
    RegisterMethod('Procedure DisableService');
    RegisterMethod('Function GetStatus : DWORD');
    RegisterMethod('Function ServiceRunning : Boolean');
    RegisterMethod('Function ServiceStopped : Boolean');
    RegisterMethod('Function ImageIndex : integer');
    RegisterMethod('Function GetServicesList( PTString : TStrings) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ServiceMgr(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SERVICE_KERNEL_DRIVER','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SERVICE_FILE_SYSTEM_DRIVER','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SERVICE_ADAPTER','LongWord').SetUInt( $00000004);
 CL.AddConstantN('SERVICE_RECOGNIZER_DRIVER','LongWord').SetUInt( $00000008);
 CL.AddConstantN('SERVICE_WIN32_OWN_PROCESS','LongWord').SetUInt( $00000010);
 CL.AddConstantN('SERVICE_WIN32_SHARE_PROCESS','LongWord').SetUInt( $00000020);
 CL.AddConstantN('SERVICE_INTERACTIVE_PROCESS','LongWord').SetUInt( $00000100);
  //CL.AddTypeS('PTStrings', '^TStrings // will not work');
  SIRegister_TServiceManager(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TServiceManagerStartService1_P(Self: TServiceManager;  NumberOfArgument : DWORD; ServiceArgVectors : PChar) : Boolean;
Begin Result := Self.StartService(NumberOfArgument, ServiceArgVectors); END;

(*----------------------------------------------------------------------------*)
Function TServiceManagerStartService_P(Self: TServiceManager) : Boolean;
Begin Result := Self.StartService; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServiceManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServiceManager) do
  begin
    RegisterConstructor(@TServiceManager.Create, 'Create');
    RegisterMethod(@TServiceManager.Connect, 'Connect');
    RegisterMethod(@TServiceManager.OpenServiceConnection, 'OpenServiceConnection');
    RegisterMethod(@TServiceManagerStartService_P, 'StartService');
    RegisterMethod(@TServiceManagerStartService1_P, 'StartService1');
    RegisterMethod(@TServiceManager.StopService, 'StopService');
    RegisterMethod(@TServiceManager.PauseService, 'PauseService');
    RegisterMethod(@TServiceManager.ContinueService, 'ContinueService');
    RegisterMethod(@TServiceManager.ShutdownService, 'ShutdownService');
    RegisterMethod(@TServiceManager.DisableService, 'DisableService');
    RegisterMethod(@TServiceManager.GetStatus, 'GetStatus');
    RegisterMethod(@TServiceManager.ServiceRunning, 'ServiceRunning');
    RegisterMethod(@TServiceManager.ServiceStopped, 'ServiceStopped');
    RegisterMethod(@TServiceManager.ImageIndex, 'ImageIndex');
    RegisterMethod(@TServiceManager.GetServicesList, 'GetServicesList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ServiceMgr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TServiceManager(CL);
end;



{ TPSImport_ServiceMgr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ServiceMgr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ServiceMgr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ServiceMgr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ServiceMgr(ri);
end;
(*----------------------------------------------------------------------------*)


end.
