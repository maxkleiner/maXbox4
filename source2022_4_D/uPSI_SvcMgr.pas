unit uPSI_SvcMgr;
{
   beta for svc script   - add TServiceController
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
  TPSImport_SvcMgr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TServiceApplication(CL: TPSPascalCompiler);
procedure SIRegister_TService(CL: TPSPascalCompiler);
procedure SIRegister_TServiceThread(CL: TPSPascalCompiler);
procedure SIRegister_TDependencies(CL: TPSPascalCompiler);
procedure SIRegister_TDependency(CL: TPSPascalCompiler);
procedure SIRegister_TEventLogger(CL: TPSPascalCompiler);
procedure SIRegister_SvcMgr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TServiceApplication(CL: TPSRuntimeClassImporter);
procedure RIRegister_TService(CL: TPSRuntimeClassImporter);
procedure RIRegister_TServiceThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDependencies(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDependency(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEventLogger(CL: TPSRuntimeClassImporter);
procedure RIRegister_SvcMgr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,WinSvc
  ,SvcMgr_max
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SvcMgr]);
end;


procedure ServiceController(self: TService; CtrlCode: DWord); stdcall;
begin
  //self.Controller(CtrlCode);
end;

function TService1GetServiceController: TServiceController;
begin
  //Result := ServiceController;
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TServiceApplication(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TServiceApplication') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TServiceApplication') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
    RegisterProperty('DelayInitialize', 'Boolean', iptrw);
    RegisterProperty('ServiceCount', 'Integer', iptr);
    RegisterMethod('Procedure CreateForm( InstanceClass : TComponentClass; var Reference)');
    RegisterMethod('Procedure Initialize');
    RegisterMethod('Function Installing : Boolean');
    RegisterMethod('Procedure Run');
    RegisterProperty('Title', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TService(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataModule', 'TService') do
  with CL.AddClassN(CL.FindClass('TDataModule'),'TService') do begin
    RegisterMethod('Constructor CreateNew( AOwner : TComponent; Dummy : Integer)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GetServiceController : TServiceController');
    RegisterMethod('Procedure ReportStatus');
    RegisterMethod('Procedure LogMessage( Message : String; EventType : DWord; Category : Integer; ID : Integer)');
    RegisterProperty('ErrCode', 'DWord', iptrw);
    RegisterProperty('ParamCount', 'Integer', iptr);
    RegisterProperty('Param', 'String Integer', iptr);
    RegisterProperty('ServiceThread', 'TServiceThread', iptr);
    RegisterProperty('Status', 'TCurrentStatus', iptrw);
    RegisterProperty('Terminated', 'Boolean', iptr);
    RegisterProperty('Win32ErrCode', 'DWord', iptrw);
    RegisterProperty('AllowStop', 'Boolean', iptrw);
    RegisterProperty('AllowPause', 'Boolean', iptrw);
    RegisterProperty('Dependencies', 'TDependencies', iptrw);
    RegisterProperty('DisplayName', 'String', iptrw);
    RegisterProperty('ErrorSeverity', 'TErrorSeverity', iptrw);
    RegisterProperty('Interactive', 'Boolean', iptrw);
    RegisterProperty('LoadGroup', 'String', iptrw);
    RegisterProperty('Password', 'String', iptrw);
    RegisterProperty('ServiceStartName', 'String', iptrw);
    RegisterProperty('ServiceType', 'TServiceType', iptrw);
    RegisterProperty('StartType', 'TStartType', iptrw);
    RegisterProperty('TagID', 'DWord', iptrw);
    RegisterProperty('WaitHint', 'Integer', iptrw);
    RegisterProperty('BeforeInstall', 'TServiceEvent', iptrw);
    RegisterProperty('AfterInstall', 'TServiceEvent', iptrw);
    RegisterProperty('BeforeUninstall', 'TServiceEvent', iptrw);
    RegisterProperty('AfterUninstall', 'TServiceEvent', iptrw);
    RegisterProperty('OnContinue', 'TContinueEvent', iptrw);
    RegisterProperty('OnExecute', 'TServiceEvent', iptrw);
    RegisterProperty('OnPause', 'TPauseEvent', iptrw);
    RegisterProperty('OnShutdown', 'TServiceEvent', iptrw);
    RegisterProperty('OnStart', 'TStartEvent', iptrw);
    RegisterProperty('OnStop', 'TmStopEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TServiceThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TServiceThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TServiceThread') do begin
    RegisterMethod('Constructor Create( Service : TService)');
    RegisterMethod('Procedure ProcessRequests( WaitForMessage : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDependencies(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TDependencies') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TDependencies') do begin
    RegisterMethod('Constructor Create( Owner : TPersistent)');
    RegisterProperty('Items', 'TDependency Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDependency(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TDependency') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TDependency') do
  begin
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('IsGroup', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEventLogger(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TEventLogger') do
  with CL.AddClassN(CL.FindClass('TObject'),'TEventLogger') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( Name : String)');
    RegisterMethod('Procedure LogMessage( Message : String; EventType : DWord; Category : Word; ID : DWord)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SvcMgr(CL: TPSPascalCompiler);
begin
  SIRegister_TEventLogger(CL);
  SIRegister_TDependency(CL);
  SIRegister_TDependencies(CL);
  //TServiceController = procedure(CtrlCode: DWord); stdcall;
  CL.AddTypeS('TServiceController', 'procedure(CtrlCode: DWord); stdcall;');
  CL.AddTypeS('TServiceController1', 'procedure(CtrlCode: DWord);');

  //TServiceType = (stWin32, stDevice, stFileSystem);
 CL.AddConstantN('CM_SERVICE_CONTROL_CODE','LongInt').SetInt( WM_USER + 1);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TService');
  SIRegister_TServiceThread(CL);
  CL.AddTypeS('TServiceType', '( stWin32, stDevice, stFileSystem )');
  CL.AddTypeS('TCurrentStatus', '( csStopped, csStartPending, csStopPending, cs'
   +'Running, csContinuePending, csPausePending, csPaused )');
  CL.AddTypeS('TErrorSeverity', '( esIgnore, esNormal, esSevere, esCritical )');
  CL.AddTypeS('TStartType', '( stBoot, stSystem, stAuto, stManual, stDisabled )');
  CL.AddTypeS('TServiceEvent', 'Procedure ( Sender : TService)');
  CL.AddTypeS('TContinueEvent', 'Procedure ( Sender : TService; var Continued : Boolean)');
  CL.AddTypeS('TPauseEvent', 'Procedure ( Sender : TService; var Paused : Boolean)');
  CL.AddTypeS('TStartEvent', 'Procedure ( Sender : TService; var Started : Boolean)');
  CL.AddTypeS('TmStopEvent', 'Procedure ( Sender : TService; var Stopped : Boolean)');
  SIRegister_TService(CL);
  SIRegister_TServiceApplication(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TServiceApplicationTitle_W(Self: TServiceApplication; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceApplicationTitle_R(Self: TServiceApplication; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TServiceApplicationServiceCount_R(Self: TServiceApplication; var T: Integer);
begin T := Self.ServiceCount; end;

(*----------------------------------------------------------------------------*)
procedure TServiceApplicationDelayInitialize_W(Self: TServiceApplication; const T: Boolean);
begin Self.DelayInitialize := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceApplicationDelayInitialize_R(Self: TServiceApplication; var T: Boolean);
begin T := Self.DelayInitialize; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnStop_W(Self: TService; const T: TStopEvent);
begin Self.OnStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnStop_R(Self: TService; var T: TStopEvent);
begin T := Self.OnStop; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnStart_W(Self: TService; const T: TStartEvent);
begin Self.OnStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnStart_R(Self: TService; var T: TStartEvent);
begin T := Self.OnStart; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnShutdown_W(Self: TService; const T: TServiceEvent);
begin Self.OnShutdown := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnShutdown_R(Self: TService; var T: TServiceEvent);
begin T := Self.OnShutdown; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnPause_W(Self: TService; const T: TPauseEvent);
begin Self.OnPause := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnPause_R(Self: TService; var T: TPauseEvent);
begin T := Self.OnPause; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnExecute_W(Self: TService; const T: TServiceEvent);
begin Self.OnExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnExecute_R(Self: TService; var T: TServiceEvent);
begin T := Self.OnExecute; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnContinue_W(Self: TService; const T: TContinueEvent);
begin Self.OnContinue := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceOnContinue_R(Self: TService; var T: TContinueEvent);
begin T := Self.OnContinue; end;

(*----------------------------------------------------------------------------*)
procedure TServiceAfterUninstall_W(Self: TService; const T: TServiceEvent);
begin Self.AfterUninstall := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceAfterUninstall_R(Self: TService; var T: TServiceEvent);
begin T := Self.AfterUninstall; end;

(*----------------------------------------------------------------------------*)
procedure TServiceBeforeUninstall_W(Self: TService; const T: TServiceEvent);
begin Self.BeforeUninstall := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceBeforeUninstall_R(Self: TService; var T: TServiceEvent);
begin T := Self.BeforeUninstall; end;

(*----------------------------------------------------------------------------*)
procedure TServiceAfterInstall_W(Self: TService; const T: TServiceEvent);
begin Self.AfterInstall := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceAfterInstall_R(Self: TService; var T: TServiceEvent);
begin T := Self.AfterInstall; end;

(*----------------------------------------------------------------------------*)
procedure TServiceBeforeInstall_W(Self: TService; const T: TServiceEvent);
begin Self.BeforeInstall := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceBeforeInstall_R(Self: TService; var T: TServiceEvent);
begin T := Self.BeforeInstall; end;

(*----------------------------------------------------------------------------*)
procedure TServiceWaitHint_W(Self: TService; const T: Integer);
begin Self.WaitHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceWaitHint_R(Self: TService; var T: Integer);
begin T := Self.WaitHint; end;

(*----------------------------------------------------------------------------*)
procedure TServiceTagID_W(Self: TService; const T: DWord);
begin Self.TagID := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceTagID_R(Self: TService; var T: DWord);
begin T := Self.TagID; end;

(*----------------------------------------------------------------------------*)
procedure TServiceStartType_W(Self: TService; const T: TStartType);
begin Self.StartType := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceStartType_R(Self: TService; var T: TStartType);
begin T := Self.StartType; end;

(*----------------------------------------------------------------------------*)
procedure TServiceServiceType_W(Self: TService; const T: TServiceType);
begin Self.ServiceType := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceServiceType_R(Self: TService; var T: TServiceType);
begin T := Self.ServiceType; end;

(*----------------------------------------------------------------------------*)
procedure TServiceServiceStartName_W(Self: TService; const T: String);
begin Self.ServiceStartName := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceServiceStartName_R(Self: TService; var T: String);
begin T := Self.ServiceStartName; end;

(*----------------------------------------------------------------------------*)
procedure TServicePassword_W(Self: TService; const T: String);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TServicePassword_R(Self: TService; var T: String);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TServiceLoadGroup_W(Self: TService; const T: String);
begin Self.LoadGroup := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceLoadGroup_R(Self: TService; var T: String);
begin T := Self.LoadGroup; end;

(*----------------------------------------------------------------------------*)
procedure TServiceInteractive_W(Self: TService; const T: Boolean);
begin Self.Interactive := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceInteractive_R(Self: TService; var T: Boolean);
begin T := Self.Interactive; end;

(*----------------------------------------------------------------------------*)
procedure TServiceErrorSeverity_W(Self: TService; const T: TErrorSeverity);
begin Self.ErrorSeverity := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceErrorSeverity_R(Self: TService; var T: TErrorSeverity);
begin T := Self.ErrorSeverity; end;

(*----------------------------------------------------------------------------*)
procedure TServiceDisplayName_W(Self: TService; const T: String);
begin Self.DisplayName := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceDisplayName_R(Self: TService; var T: String);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TServiceDependencies_W(Self: TService; const T: TDependencies);
begin Self.Dependencies := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceDependencies_R(Self: TService; var T: TDependencies);
begin T := Self.Dependencies; end;

(*----------------------------------------------------------------------------*)
procedure TServiceAllowPause_W(Self: TService; const T: Boolean);
begin Self.AllowPause := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceAllowPause_R(Self: TService; var T: Boolean);
begin T := Self.AllowPause; end;

(*----------------------------------------------------------------------------*)
procedure TServiceAllowStop_W(Self: TService; const T: Boolean);
begin Self.AllowStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceAllowStop_R(Self: TService; var T: Boolean);
begin T := Self.AllowStop; end;

(*----------------------------------------------------------------------------*)
procedure TServiceWin32ErrCode_W(Self: TService; const T: DWord);
begin Self.Win32ErrCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceWin32ErrCode_R(Self: TService; var T: DWord);
begin T := Self.Win32ErrCode; end;

(*----------------------------------------------------------------------------*)
procedure TServiceTerminated_R(Self: TService; var T: Boolean);
begin T := Self.Terminated; end;

(*----------------------------------------------------------------------------*)
procedure TServiceStatus_W(Self: TService; const T: TCurrentStatus);
begin Self.Status := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceStatus_R(Self: TService; var T: TCurrentStatus);
begin T := Self.Status; end;

(*----------------------------------------------------------------------------*)
procedure TServiceServiceThread_R(Self: TService; var T: TServiceThread);
begin T := Self.ServiceThread; end;

(*----------------------------------------------------------------------------*)
procedure TServiceParam_R(Self: TService; var T: String; const t1: Integer);
begin T := Self.Param[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TServiceParamCount_R(Self: TService; var T: Integer);
begin T := Self.ParamCount; end;

(*----------------------------------------------------------------------------*)
procedure TServiceErrCode_W(Self: TService; const T: DWord);
begin Self.ErrCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TServiceErrCode_R(Self: TService; var T: DWord);
begin T := Self.ErrCode; end;

(*----------------------------------------------------------------------------*)
procedure TDependenciesItems_W(Self: TDependencies; const T: TDependency; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TDependenciesItems_R(Self: TDependencies; var T: TDependency; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TDependencyIsGroup_W(Self: TDependency; const T: Boolean);
begin Self.IsGroup := T; end;

(*----------------------------------------------------------------------------*)
procedure TDependencyIsGroup_R(Self: TDependency; var T: Boolean);
begin T := Self.IsGroup; end;

(*----------------------------------------------------------------------------*)
procedure TDependencyName_W(Self: TDependency; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TDependencyName_R(Self: TDependency; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServiceApplication(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServiceApplication) do begin
    RegisterConstructor(@TServiceApplication.Create, 'Create');
      RegisterMethod(@TServiceApplication.Destroy, 'Free');
      RegisterPropertyHelper(@TServiceApplicationDelayInitialize_R,@TServiceApplicationDelayInitialize_W,'DelayInitialize');
    RegisterPropertyHelper(@TServiceApplicationServiceCount_R,nil,'ServiceCount');
    RegisterVirtualMethod(@TServiceApplication.CreateForm, 'CreateForm');
    RegisterVirtualMethod(@TServiceApplication.Initialize, 'Initialize');
    RegisterMethod(@TServiceApplication.Installing, 'Installing');
    RegisterVirtualMethod(@TServiceApplication.Run, 'Run');
    RegisterPropertyHelper(@TServiceApplicationTitle_R,@TServiceApplicationTitle_W,'Title');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TService(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TService) do begin
    RegisterConstructor(@TService.CreateNew, 'CreateNew');
      RegisterMethod(@TService.Destroy, 'Free');
      //RegisterVirtualAbstractMethod(@TService, @!.GetServiceController, 'GetServiceController');
    RegisterMethod(@TService.ReportStatus, 'ReportStatus');
    RegisterMethod(@TService.LogMessage, 'LogMessage');
    RegisterPropertyHelper(@TServiceErrCode_R,@TServiceErrCode_W,'ErrCode');
    RegisterPropertyHelper(@TServiceParamCount_R,nil,'ParamCount');
    RegisterPropertyHelper(@TServiceParam_R,nil,'Param');
    RegisterPropertyHelper(@TServiceServiceThread_R,nil,'ServiceThread');
    RegisterPropertyHelper(@TServiceStatus_R,@TServiceStatus_W,'Status');
    RegisterPropertyHelper(@TServiceTerminated_R,nil,'Terminated');
    RegisterPropertyHelper(@TServiceWin32ErrCode_R,@TServiceWin32ErrCode_W,'Win32ErrCode');
    RegisterPropertyHelper(@TServiceAllowStop_R,@TServiceAllowStop_W,'AllowStop');
    RegisterPropertyHelper(@TServiceAllowPause_R,@TServiceAllowPause_W,'AllowPause');
    RegisterPropertyHelper(@TServiceDependencies_R,@TServiceDependencies_W,'Dependencies');
    RegisterPropertyHelper(@TServiceDisplayName_R,@TServiceDisplayName_W,'DisplayName');
    RegisterPropertyHelper(@TServiceErrorSeverity_R,@TServiceErrorSeverity_W,'ErrorSeverity');
    RegisterPropertyHelper(@TServiceInteractive_R,@TServiceInteractive_W,'Interactive');
    RegisterPropertyHelper(@TServiceLoadGroup_R,@TServiceLoadGroup_W,'LoadGroup');
    RegisterPropertyHelper(@TServicePassword_R,@TServicePassword_W,'Password');
    RegisterPropertyHelper(@TServiceServiceStartName_R,@TServiceServiceStartName_W,'ServiceStartName');
    RegisterPropertyHelper(@TServiceServiceType_R,@TServiceServiceType_W,'ServiceType');
    RegisterPropertyHelper(@TServiceStartType_R,@TServiceStartType_W,'StartType');
    RegisterPropertyHelper(@TServiceTagID_R,@TServiceTagID_W,'TagID');
    RegisterPropertyHelper(@TServiceWaitHint_R,@TServiceWaitHint_W,'WaitHint');
    RegisterPropertyHelper(@TServiceBeforeInstall_R,@TServiceBeforeInstall_W,'BeforeInstall');
    RegisterPropertyHelper(@TServiceAfterInstall_R,@TServiceAfterInstall_W,'AfterInstall');
    RegisterPropertyHelper(@TServiceBeforeUninstall_R,@TServiceBeforeUninstall_W,'BeforeUninstall');
    RegisterPropertyHelper(@TServiceAfterUninstall_R,@TServiceAfterUninstall_W,'AfterUninstall');
    RegisterPropertyHelper(@TServiceOnContinue_R,@TServiceOnContinue_W,'OnContinue');
    RegisterPropertyHelper(@TServiceOnExecute_R,@TServiceOnExecute_W,'OnExecute');
    RegisterPropertyHelper(@TServiceOnPause_R,@TServiceOnPause_W,'OnPause');
    RegisterPropertyHelper(@TServiceOnShutdown_R,@TServiceOnShutdown_W,'OnShutdown');
    RegisterPropertyHelper(@TServiceOnStart_R,@TServiceOnStart_W,'OnStart');
    RegisterPropertyHelper(@TServiceOnStop_R,@TServiceOnStop_W,'OnStop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServiceThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServiceThread) do
  begin
    RegisterConstructor(@TServiceThread.Create, 'Create');
    RegisterMethod(@TServiceThread.ProcessRequests, 'ProcessRequests');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDependencies(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDependencies) do
  begin
    RegisterConstructor(@TDependencies.Create, 'Create');
    RegisterPropertyHelper(@TDependenciesItems_R,@TDependenciesItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDependency(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDependency) do
  begin
    RegisterPropertyHelper(@TDependencyName_R,@TDependencyName_W,'Name');
    RegisterPropertyHelper(@TDependencyIsGroup_R,@TDependencyIsGroup_W,'IsGroup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEventLogger(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEventLogger) do begin
    RegisterConstructor(@TEventLogger.Create, 'Create');
      RegisterMethod(@TEventLogger.Destroy, 'Free');
      RegisterMethod(@TEventLogger.LogMessage, 'LogMessage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SvcMgr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TEventLogger(CL);
  RIRegister_TDependency(CL);
  RIRegister_TDependencies(CL);
  with CL.Add(TService) do
  RIRegister_TServiceThread(CL);
  RIRegister_TService(CL);
  RIRegister_TServiceApplication(CL);
end;

 
 
{ TPSImport_SvcMgr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SvcMgr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SvcMgr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SvcMgr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SvcMgr(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
