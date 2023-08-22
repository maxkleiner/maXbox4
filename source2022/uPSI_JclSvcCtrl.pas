unit uPSI_JclSvcCtrl;
{
  services
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
  TPSImport_JclSvcCtrl = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclSCManager(CL: TPSPascalCompiler);
procedure SIRegister_TJclServiceGroup(CL: TPSPascalCompiler);
procedure SIRegister_TJclNtService(CL: TPSPascalCompiler);
procedure SIRegister_JclSvcCtrl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJclSCManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclServiceGroup(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclNtService(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclSvcCtrl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Contnrs
  ,WinSvc
  ,JclBase
  ,JclSysUtils
  ,JclSvcCtrl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclSvcCtrl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSCManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSCManager') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSCManager') do begin
    RegisterMethod('Constructor Create( const AMachineName : string; const ADesiredAccess : DWORD; const ADatabaseName : string)');
    RegisterMethod('Procedure Clear');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Refresh( const RefreshAll : Boolean)');
    RegisterMethod('Procedure Sort( const AOrderType : TJclServiceSortOrderType; const AOrderAsc : Boolean)');
    RegisterMethod('Function FindService( const SvcName : string; var NtSvc : TJclNtService) : Boolean');
    RegisterMethod('Function FindGroup( const GrpName : string; var SvcGrp : TJclServiceGroup; const AutoAdd : Boolean) : Boolean');
    RegisterMethod('Procedure Lock');
    RegisterMethod('Procedure Unlock');
    RegisterMethod('Function IsLocked : Boolean');
    RegisterMethod('Function LockOwner : string');
    RegisterMethod('Function LockDuration : DWORD');
    RegisterMethod('Function ServiceType( const SvcType : TJclServiceTypes) : DWORD;');
    RegisterMethod('Function ServiceType1( const SvcType : DWORD) : TJclServiceTypes;');
    RegisterMethod('Function ControlAccepted( const CtrlAccepted : TJclServiceControlAccepteds) : DWORD;');
    RegisterMethod('Function ControlAccepted1( const CtrlAccepted : DWORD) : TJclServiceControlAccepteds;');
    RegisterProperty('MachineName', 'string', iptr);
    RegisterProperty('DatabaseName', 'string', iptr);
    RegisterProperty('DesiredAccess', 'DWORD', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Handle', 'SC_HANDLE', iptr);
    RegisterProperty('Services', 'TJclNtService Integer', iptr);
    RegisterProperty('ServiceCount', 'Integer', iptr);
    RegisterProperty('Groups', 'TJclServiceGroup Integer', iptr);
    RegisterProperty('GroupCount', 'Integer', iptr);
    RegisterProperty('OrderType', 'TJclServiceSortOrderType', iptrw);
    RegisterProperty('OrderAsc', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclServiceGroup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclServiceGroup') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclServiceGroup') do begin
    RegisterMethod('Procedure Free');
    RegisterProperty('SCManager', 'TJclSCManager', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('Order', 'Integer', iptr);
    RegisterProperty('Services', 'TJclNtService Integer', iptr);
    RegisterProperty('ServiceCount', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclNtService(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclNtService') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclNtService') do begin
    RegisterMethod('Procedure Free');
   RegisterMethod('Procedure Refresh');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Function Controls( const ControlType : DWORD; const ADesiredAccess : DWORD) : TServiceStatus');
    RegisterMethod('Procedure Start( const Args : array of string; const Sync : Boolean);');
    RegisterMethod('Procedure Start1( const Sync : Boolean);');
    RegisterMethod('Procedure Stop( const Sync : Boolean)');
    RegisterMethod('Procedure Pause( const Sync : Boolean)');
    RegisterMethod('Procedure Continue( const Sync : Boolean)');
    RegisterMethod('Function WaitFor( const State : TJclServiceState; const TimeOut : DWORD) : Boolean');
    RegisterProperty('SCManager', 'TJclSCManager', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Handle', 'SC_HANDLE', iptr);
    RegisterProperty('ServiceName', 'string', iptr);
    RegisterProperty('DisplayName', 'string', iptr);
    RegisterProperty('DesiredAccess', 'DWORD', iptr);
    RegisterProperty('Description', 'string', iptr);
    RegisterProperty('FileName', 'TFileName', iptr);
    RegisterProperty('DependentServices', 'TJclNtService Integer', iptr);
    RegisterProperty('DependentServiceCount', 'Integer', iptr);
    RegisterProperty('DependentGroups', 'TJclServiceGroup Integer', iptr);
    RegisterProperty('DependentGroupCount', 'Integer', iptr);
    RegisterProperty('DependentByServices', 'TJclNtService Integer', iptr);
    RegisterProperty('DependentByServiceCount', 'Integer', iptr);
    RegisterProperty('ServiceTypes', 'TJclServiceTypes', iptr);
    RegisterProperty('ServiceState', 'TJclServiceState', iptr);
    RegisterProperty('StartType', 'TJclServiceStartType', iptr);
    RegisterProperty('ErrorControlType', 'TJclServiceErrorControlType', iptr);
    RegisterProperty('Win32ExitCode', 'DWORD', iptr);
    RegisterProperty('Group', 'TJclServiceGroup', iptr);
    RegisterProperty('ControlsAccepted', 'TJclServiceControlAccepteds', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclSvcCtrl(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJclServiceType', '( stKernelDriver, stFileSystemDriver, stAdapt'
   +'er, stRecognizerDriver, stWin32OwnProcess, stWin32ShareProcess, stInteractiveProcess )');
  CL.AddTypeS('TJclServiceTypes', 'set of TJclServiceType');
 CL.AddConstantN('stDriverService','LongInt').Value.ts32 := ord(stKernelDriver) or ord(stFileSystemDriver) or ord(stRecognizerDriver);
 CL.AddConstantN('stWin32Service','LongInt').Value.ts32 := ord(stWin32OwnProcess) or ord(stWin32ShareProcess);
  CL.AddTypeS('TJclServiceState', '( ssUnknown, ssStopped, ssStartPending, ssSt'
   +'opPending, ssRunning, ssContinuePending, ssPausePending, ssPaused )');
  CL.AddTypeS('TJclServiceStartType', '( sstBoot, sstSystem, sstAuto, sstDemand, sstDisabled )');
  CL.AddTypeS('TJclServiceErrorControlType', '( ectIgnore, ectNormal, ectSevere, ectCritical )');
  CL.AddTypeS('TJclServiceControlAccepted', '( caStop, caPauseContinue, caShutdown )');
  CL.AddTypeS('TJclServiceControlAccepteds', 'set of TJclServiceControlAccepted');
  CL.AddTypeS('TJclServiceSortOrderType', '( sotServiceName, sotDisplayName, so'
   +'tDescription, sotFileName, sotServiceState, sotStartType, sotErrorControlT'
   +'ype, sotLoadOrderGroup, sotWin32ExitCode )');
 //CL.AddConstantN('DefaultSvcDesiredAccess','').SetString( SERVICE_ALL_ACCESS);
 CL.AddConstantN('SERVICE_CONFIG_DESCRIPTION','LongInt').SetInt( 1);
 CL.AddConstantN('SERVICE_CONFIG_FAILURE_ACTIONS','LongInt').SetInt( 2);
  //CL.AddTypeS('LPSERVICE_DESCRIPTIONA', '^SERVICE_DESCRIPTIONA // will not work');
  CL.AddTypeS('_SERVICE_DESCRIPTIONA', 'record lpDescription : string; end');
  CL.AddTypeS('SERVICE_DESCRIPTIONA', '_SERVICE_DESCRIPTIONA');
  CL.AddTypeS('TServiceDescriptionA', 'SERVICE_DESCRIPTIONA');
  //CL.AddTypeS('PServiceDescriptionA', 'LPSERVICE_DESCRIPTIONA');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclServiceGroup');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclSCManager');
  SIRegister_TJclNtService(CL);
  SIRegister_TJclServiceGroup(CL);
  SIRegister_TJclSCManager(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclSCManagerOrderAsc_W(Self: TJclSCManager; const T: Boolean);
begin Self.OrderAsc := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerOrderAsc_R(Self: TJclSCManager; var T: Boolean);
begin T := Self.OrderAsc; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerOrderType_W(Self: TJclSCManager; const T: TJclServiceSortOrderType);
begin Self.OrderType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerOrderType_R(Self: TJclSCManager; var T: TJclServiceSortOrderType);
begin T := Self.OrderType; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerGroupCount_R(Self: TJclSCManager; var T: Integer);
begin T := Self.GroupCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerGroups_R(Self: TJclSCManager; var T: TJclServiceGroup; const t1: Integer);
begin T := Self.Groups[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerServiceCount_R(Self: TJclSCManager; var T: Integer);
begin T := Self.ServiceCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerServices_R(Self: TJclSCManager; var T: TJclNtService; const t1: Integer);
begin T := Self.Services[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerHandle_R(Self: TJclSCManager; var T: SC_HANDLE);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerActive_W(Self: TJclSCManager; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerActive_R(Self: TJclSCManager; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerDesiredAccess_R(Self: TJclSCManager; var T: DWORD);
begin T := Self.DesiredAccess; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerDatabaseName_R(Self: TJclSCManager; var T: string);
begin T := Self.DatabaseName; end;

(*----------------------------------------------------------------------------*)
procedure TJclSCManagerMachineName_R(Self: TJclSCManager; var T: string);
begin T := Self.MachineName; end;

(*----------------------------------------------------------------------------*)
Function TJclSCManagerControlAccepted1_P(Self: TJclSCManager;  const CtrlAccepted : DWORD) : TJclServiceControlAccepteds;
Begin Result := Self.ControlAccepted(CtrlAccepted); END;

(*----------------------------------------------------------------------------*)
Function TJclSCManagerControlAccepted_P(Self: TJclSCManager;  const CtrlAccepted : TJclServiceControlAccepteds) : DWORD;
Begin Result := Self.ControlAccepted(CtrlAccepted); END;

(*----------------------------------------------------------------------------*)
Function TJclSCManagerServiceType1_P(Self: TJclSCManager;  const SvcType : DWORD) : TJclServiceTypes;
Begin Result := Self.ServiceType(SvcType); END;

(*----------------------------------------------------------------------------*)
Function TJclSCManagerServiceType_P(Self: TJclSCManager;  const SvcType : TJclServiceTypes) : DWORD;
Begin Result := Self.ServiceType(SvcType); END;

(*----------------------------------------------------------------------------*)
procedure TJclServiceGroupServiceCount_R(Self: TJclServiceGroup; var T: Integer);
begin T := Self.ServiceCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclServiceGroupServices_R(Self: TJclServiceGroup; var T: TJclNtService; const t1: Integer);
begin T := Self.Services[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclServiceGroupOrder_R(Self: TJclServiceGroup; var T: Integer);
begin T := Self.Order; end;

(*----------------------------------------------------------------------------*)
procedure TJclServiceGroupName_R(Self: TJclServiceGroup; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclServiceGroupSCManager_R(Self: TJclServiceGroup; var T: TJclSCManager);
begin T := Self.SCManager; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceControlsAccepted_R(Self: TJclNtService; var T: TJclServiceControlAccepteds);
begin T := Self.ControlsAccepted; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceGroup_R(Self: TJclNtService; var T: TJclServiceGroup);
begin T := Self.Group; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceWin32ExitCode_R(Self: TJclNtService; var T: DWORD);
begin T := Self.Win32ExitCode; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceErrorControlType_R(Self: TJclNtService; var T: TJclServiceErrorControlType);
begin T := Self.ErrorControlType; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceStartType_R(Self: TJclNtService; var T: TJclServiceStartType);
begin T := Self.StartType; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceServiceState_R(Self: TJclNtService; var T: TJclServiceState);
begin T := Self.ServiceState; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceServiceTypes_R(Self: TJclNtService; var T: TJclServiceTypes);
begin T := Self.ServiceTypes; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceDependentByServiceCount_R(Self: TJclNtService; var T: Integer);
begin T := Self.DependentByServiceCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceDependentByServices_R(Self: TJclNtService; var T: TJclNtService; const t1: Integer);
begin T := Self.DependentByServices[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceDependentGroupCount_R(Self: TJclNtService; var T: Integer);
begin T := Self.DependentGroupCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceDependentGroups_R(Self: TJclNtService; var T: TJclServiceGroup; const t1: Integer);
begin T := Self.DependentGroups[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceDependentServiceCount_R(Self: TJclNtService; var T: Integer);
begin T := Self.DependentServiceCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceDependentServices_R(Self: TJclNtService; var T: TJclNtService; const t1: Integer);
begin T := Self.DependentServices[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceFileName_R(Self: TJclNtService; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceDescription_R(Self: TJclNtService; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceDesiredAccess_R(Self: TJclNtService; var T: DWORD);
begin T := Self.DesiredAccess; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceDisplayName_R(Self: TJclNtService; var T: string);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceServiceName_R(Self: TJclNtService; var T: string);
begin T := Self.ServiceName; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceHandle_R(Self: TJclNtService; var T: SC_HANDLE);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceActive_W(Self: TJclNtService; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceActive_R(Self: TJclNtService; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TJclNtServiceSCManager_R(Self: TJclNtService; var T: TJclSCManager);
begin T := Self.SCManager; end;

(*----------------------------------------------------------------------------*)
Procedure TJclNtServiceStart1_P(Self: TJclNtService;  const Sync : Boolean);
Begin Self.Start(Sync); END;

(*----------------------------------------------------------------------------*)
Procedure TJclNtServiceStart_P(Self: TJclNtService;  const Args : array of string; const Sync : Boolean);
Begin Self.Start(Args, Sync); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSCManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSCManager) do begin
    RegisterConstructor(@TJclSCManager.Create, 'Create');
       RegisterMethod(@TJclSCManager.Destroy, 'Free');
     RegisterMethod(@TJclSCManager.Clear, 'Clear');
    RegisterMethod(@TJclSCManager.Refresh, 'Refresh');
    RegisterMethod(@TJclSCManager.Sort, 'Sort');
    RegisterMethod(@TJclSCManager.FindService, 'FindService');
    RegisterMethod(@TJclSCManager.FindGroup, 'FindGroup');
    RegisterMethod(@TJclSCManager.Lock, 'Lock');
    RegisterMethod(@TJclSCManager.Unlock, 'Unlock');
    RegisterMethod(@TJclSCManager.IsLocked, 'IsLocked');
    RegisterMethod(@TJclSCManager.LockOwner, 'LockOwner');
    RegisterMethod(@TJclSCManager.LockDuration, 'LockDuration');
    RegisterMethod(@TJclSCManagerServiceType_P, 'ServiceType');
    RegisterMethod(@TJclSCManagerServiceType1_P, 'ServiceType1');
    RegisterMethod(@TJclSCManagerControlAccepted_P, 'ControlAccepted');
    RegisterMethod(@TJclSCManagerControlAccepted1_P, 'ControlAccepted1');
    RegisterPropertyHelper(@TJclSCManagerMachineName_R,nil,'MachineName');
    RegisterPropertyHelper(@TJclSCManagerDatabaseName_R,nil,'DatabaseName');
    RegisterPropertyHelper(@TJclSCManagerDesiredAccess_R,nil,'DesiredAccess');
    RegisterPropertyHelper(@TJclSCManagerActive_R,@TJclSCManagerActive_W,'Active');
    RegisterPropertyHelper(@TJclSCManagerHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TJclSCManagerServices_R,nil,'Services');
    RegisterPropertyHelper(@TJclSCManagerServiceCount_R,nil,'ServiceCount');
    RegisterPropertyHelper(@TJclSCManagerGroups_R,nil,'Groups');
    RegisterPropertyHelper(@TJclSCManagerGroupCount_R,nil,'GroupCount');
    RegisterPropertyHelper(@TJclSCManagerOrderType_R,@TJclSCManagerOrderType_W,'OrderType');
    RegisterPropertyHelper(@TJclSCManagerOrderAsc_R,@TJclSCManagerOrderAsc_W,'OrderAsc');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclServiceGroup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclServiceGroup) do begin
     RegisterMethod(@TJclServiceGroup.Destroy, 'Free');
     RegisterPropertyHelper(@TJclServiceGroupSCManager_R,nil,'SCManager');
    RegisterPropertyHelper(@TJclServiceGroupName_R,nil,'Name');
    RegisterPropertyHelper(@TJclServiceGroupOrder_R,nil,'Order');
    RegisterPropertyHelper(@TJclServiceGroupServices_R,nil,'Services');
    RegisterPropertyHelper(@TJclServiceGroupServiceCount_R,nil,'ServiceCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclNtService(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclNtService) do begin
    RegisterMethod(@TJclNtService.Refresh, 'Refresh');
      RegisterMethod(@TJclNtService.Destroy, 'Free');
    RegisterMethod(@TJclNtService.Delete, 'Delete');
    RegisterMethod(@TJclNtService.Controls, 'Controls');
    RegisterMethod(@TJclNtServiceStart_P, 'Start');
    RegisterMethod(@TJclNtServiceStart1_P, 'Start1');
    RegisterMethod(@TJclNtService.Stop, 'Stop');
    RegisterMethod(@TJclNtService.Pause, 'Pause');
    RegisterMethod(@TJclNtService.Continue, 'Continue');
    RegisterMethod(@TJclNtService.WaitFor, 'WaitFor');
    RegisterPropertyHelper(@TJclNtServiceSCManager_R,nil,'SCManager');
    RegisterPropertyHelper(@TJclNtServiceActive_R,@TJclNtServiceActive_W,'Active');
    RegisterPropertyHelper(@TJclNtServiceHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TJclNtServiceServiceName_R,nil,'ServiceName');
    RegisterPropertyHelper(@TJclNtServiceDisplayName_R,nil,'DisplayName');
    RegisterPropertyHelper(@TJclNtServiceDesiredAccess_R,nil,'DesiredAccess');
    RegisterPropertyHelper(@TJclNtServiceDescription_R,nil,'Description');
    RegisterPropertyHelper(@TJclNtServiceFileName_R,nil,'FileName');
    RegisterPropertyHelper(@TJclNtServiceDependentServices_R,nil,'DependentServices');
    RegisterPropertyHelper(@TJclNtServiceDependentServiceCount_R,nil,'DependentServiceCount');
    RegisterPropertyHelper(@TJclNtServiceDependentGroups_R,nil,'DependentGroups');
    RegisterPropertyHelper(@TJclNtServiceDependentGroupCount_R,nil,'DependentGroupCount');
    RegisterPropertyHelper(@TJclNtServiceDependentByServices_R,nil,'DependentByServices');
    RegisterPropertyHelper(@TJclNtServiceDependentByServiceCount_R,nil,'DependentByServiceCount');
    RegisterPropertyHelper(@TJclNtServiceServiceTypes_R,nil,'ServiceTypes');
    RegisterPropertyHelper(@TJclNtServiceServiceState_R,nil,'ServiceState');
    RegisterPropertyHelper(@TJclNtServiceStartType_R,nil,'StartType');
    RegisterPropertyHelper(@TJclNtServiceErrorControlType_R,nil,'ErrorControlType');
    RegisterPropertyHelper(@TJclNtServiceWin32ExitCode_R,nil,'Win32ExitCode');
    RegisterPropertyHelper(@TJclNtServiceGroup_R,nil,'Group');
    RegisterPropertyHelper(@TJclNtServiceControlsAccepted_R,nil,'ControlsAccepted');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclSvcCtrl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclServiceGroup) do
  with CL.Add(TJclSCManager) do
  RIRegister_TJclNtService(CL);
  RIRegister_TJclServiceGroup(CL);
  RIRegister_TJclSCManager(CL);
end;

 
 
{ TPSImport_JclSvcCtrl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSvcCtrl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclSvcCtrl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSvcCtrl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclSvcCtrl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
