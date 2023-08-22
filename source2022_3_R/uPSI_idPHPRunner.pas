unit uPSI_idPHPRunner;
{
php tester    on progress for V5
https://github.com/perevoznyk/php4delphi/blob/master/PHPAPI.pas

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
  TPSImport_idPHPRunner = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPHPControlBlock(CL: TPSPascalCompiler);
procedure SIRegister_TidPHPRunner(CL: TPSPascalCompiler);
procedure SIRegister_idPHPRunner(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_idPHPRunner_Routines(S: TPSExec);
procedure RIRegister_TPHPControlBlock(CL: TPSRuntimeClassImporter);
procedure RIRegister_TidPHPRunner(CL: TPSRuntimeClassImporter);
procedure RIRegister_idPHPRunner(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ISAPI2
  ,IdTCPServer
  ,idStack
  ,idGlobal
  ,idBaseComponent
  ,idCustomHTTPServer
  ,idStackWindows
  ,idWinSock2
  ,idHeaderList
  ,IdHTTPServer
  //,ZendAPI
  //,PHPAPI
  ,idPHPRunner
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_idPHPRunner]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPHPControlBlock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPHPControlBlock') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPHPControlBlock') do
  begin
    RegisterProperty('Runner', 'TidPHPRunner', iptrw);
    RegisterProperty('RequestInfo', 'TidHTTPRequestInfo', iptrw);
    RegisterProperty('ResponseInfo', 'TidHTTPResponseInfo', iptrw);
    RegisterProperty('AThread', 'TidPeerThread', iptrw);
    RegisterProperty('Server', 'TidHTTPServer', iptrw);
    RegisterProperty('DocumentRoot', 'string', iptrw);
    RegisterProperty('PathInfo', 'string', iptrw);
    RegisterProperty('PathTranslated', 'string', iptrw);
    RegisterProperty('ServerAdmin', 'string', iptrw);
    RegisterProperty('data_avail', 'integer', iptrw);
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TidPHPRunner(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TidPHPRunner') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TidPHPRunner') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Execute( const PHPScriptName : String; AThread : TIdPeerThread; RequestInfo : TIdHTTPRequestInfo; ResponseInfo : TIdHTTPResponseInfo; const DocumentRoot : string; Action : string)');
    RegisterProperty('OnModuleStartup', 'TNotifyEvent', iptrw);
    RegisterProperty('OnModuleShutdown', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRequestStartup', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRequestShutdown', 'TNotifyEvent', iptrw);
    RegisterProperty('ModuleActive', 'boolean', iptr);
    RegisterProperty('Server', 'TidHTTPServer', iptrw);
    RegisterProperty('ServerAdmin', 'string', iptrw);
    RegisterProperty('IniPath', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_idPHPRunner(CL: TPSPascalCompiler);
begin
  SIRegister_TidPHPRunner(CL);
  SIRegister_TPHPControlBlock(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockdata_avail_W(Self: TPHPControlBlock; const T: integer);
Begin Self.data_avail := T; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockdata_avail_R(Self: TPHPControlBlock; var T: integer);
Begin T := Self.data_avail; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockServerAdmin_W(Self: TPHPControlBlock; const T: string);
Begin Self.ServerAdmin := T; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockServerAdmin_R(Self: TPHPControlBlock; var T: string);
Begin T := Self.ServerAdmin; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockPathTranslated_W(Self: TPHPControlBlock; const T: string);
Begin Self.PathTranslated := T; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockPathTranslated_R(Self: TPHPControlBlock; var T: string);
Begin T := Self.PathTranslated; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockPathInfo_W(Self: TPHPControlBlock; const T: string);
Begin Self.PathInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockPathInfo_R(Self: TPHPControlBlock; var T: string);
Begin T := Self.PathInfo; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockDocumentRoot_W(Self: TPHPControlBlock; const T: string);
Begin Self.DocumentRoot := T; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockDocumentRoot_R(Self: TPHPControlBlock; var T: string);
Begin T := Self.DocumentRoot; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockServer_W(Self: TPHPControlBlock; const T: TidHTTPServer);
Begin Self.Server := T; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockServer_R(Self: TPHPControlBlock; var T: TidHTTPServer);
Begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockAThread_W(Self: TPHPControlBlock; const T: TidPeerThread);
Begin Self.AThread := T; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockAThread_R(Self: TPHPControlBlock; var T: TidPeerThread);
Begin T := Self.AThread; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockResponseInfo_W(Self: TPHPControlBlock; const T: TidHTTPResponseInfo);
Begin Self.ResponseInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockResponseInfo_R(Self: TPHPControlBlock; var T: TidHTTPResponseInfo);
Begin T := Self.ResponseInfo; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockRequestInfo_W(Self: TPHPControlBlock; const T: TidHTTPRequestInfo);
Begin Self.RequestInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockRequestInfo_R(Self: TPHPControlBlock; var T: TidHTTPRequestInfo);
Begin T := Self.RequestInfo; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockRunner_W(Self: TPHPControlBlock; const T: TidPHPRunner);
Begin Self.Runner := T; end;

(*----------------------------------------------------------------------------*)
procedure TPHPControlBlockRunner_R(Self: TPHPControlBlock; var T: TidPHPRunner);
Begin T := Self.Runner; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerIniPath_W(Self: TidPHPRunner; const T: string);
begin Self.IniPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerIniPath_R(Self: TidPHPRunner; var T: string);
begin T := Self.IniPath; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerServerAdmin_W(Self: TidPHPRunner; const T: string);
begin Self.ServerAdmin := T; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerServerAdmin_R(Self: TidPHPRunner; var T: string);
begin T := Self.ServerAdmin; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerServer_W(Self: TidPHPRunner; const T: TidHTTPServer);
begin Self.Server := T; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerServer_R(Self: TidPHPRunner; var T: TidHTTPServer);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerModuleActive_R(Self: TidPHPRunner; var T: boolean);
begin T := Self.ModuleActive; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerOnRequestShutdown_W(Self: TidPHPRunner; const T: TNotifyEvent);
begin Self.OnRequestShutdown := T; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerOnRequestShutdown_R(Self: TidPHPRunner; var T: TNotifyEvent);
begin T := Self.OnRequestShutdown; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerOnRequestStartup_W(Self: TidPHPRunner; const T: TNotifyEvent);
begin Self.OnRequestStartup := T; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerOnRequestStartup_R(Self: TidPHPRunner; var T: TNotifyEvent);
begin T := Self.OnRequestStartup; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerOnModuleShutdown_W(Self: TidPHPRunner; const T: TNotifyEvent);
begin Self.OnModuleShutdown := T; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerOnModuleShutdown_R(Self: TidPHPRunner; var T: TNotifyEvent);
begin T := Self.OnModuleShutdown; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerOnModuleStartup_W(Self: TidPHPRunner; const T: TNotifyEvent);
begin Self.OnModuleStartup := T; end;

(*----------------------------------------------------------------------------*)
procedure TidPHPRunnerOnModuleStartup_R(Self: TidPHPRunner; var T: TNotifyEvent);
begin T := Self.OnModuleStartup; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_idPHPRunner_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPHPControlBlock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPHPControlBlock) do begin
    RegisterPropertyHelper(@TPHPControlBlockRunner_R,@TPHPControlBlockRunner_W,'Runner');
    RegisterPropertyHelper(@TPHPControlBlockRequestInfo_R,@TPHPControlBlockRequestInfo_W,'RequestInfo');
    RegisterPropertyHelper(@TPHPControlBlockResponseInfo_R,@TPHPControlBlockResponseInfo_W,'ResponseInfo');
    RegisterPropertyHelper(@TPHPControlBlockAThread_R,@TPHPControlBlockAThread_W,'AThread');
    RegisterPropertyHelper(@TPHPControlBlockServer_R,@TPHPControlBlockServer_W,'Server');
    RegisterPropertyHelper(@TPHPControlBlockDocumentRoot_R,@TPHPControlBlockDocumentRoot_W,'DocumentRoot');
    RegisterPropertyHelper(@TPHPControlBlockPathInfo_R,@TPHPControlBlockPathInfo_W,'PathInfo');
    RegisterPropertyHelper(@TPHPControlBlockPathTranslated_R,@TPHPControlBlockPathTranslated_W,'PathTranslated');
    RegisterPropertyHelper(@TPHPControlBlockServerAdmin_R,@TPHPControlBlockServerAdmin_W,'ServerAdmin');
    RegisterPropertyHelper(@TPHPControlBlockdata_avail_R,@TPHPControlBlockdata_avail_W,'data_avail');
    RegisterConstructor(@TPHPControlBlock.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TidPHPRunner(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TidPHPRunner) do begin
    RegisterConstructor(@TidPHPRunner.Create, 'Create');
    //RegisterVirtualMethod(@TidPHPRunner.Execute, 'Execute');
    RegisterMethod(@TidPHPRunner.Destroy, 'Free');
    RegisterPropertyHelper(@TidPHPRunnerOnModuleStartup_R,@TidPHPRunnerOnModuleStartup_W,'OnModuleStartup');
    RegisterPropertyHelper(@TidPHPRunnerOnModuleShutdown_R,@TidPHPRunnerOnModuleShutdown_W,'OnModuleShutdown');
    RegisterPropertyHelper(@TidPHPRunnerOnRequestStartup_R,@TidPHPRunnerOnRequestStartup_W,'OnRequestStartup');
    RegisterPropertyHelper(@TidPHPRunnerOnRequestShutdown_R,@TidPHPRunnerOnRequestShutdown_W,'OnRequestShutdown');
    RegisterPropertyHelper(@TidPHPRunnerModuleActive_R,nil,'ModuleActive');
    RegisterPropertyHelper(@TidPHPRunnerServer_R,@TidPHPRunnerServer_W,'Server');
    RegisterPropertyHelper(@TidPHPRunnerServerAdmin_R,@TidPHPRunnerServerAdmin_W,'ServerAdmin');
    RegisterPropertyHelper(@TidPHPRunnerIniPath_R,@TidPHPRunnerIniPath_W,'IniPath');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_idPHPRunner(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TidPHPRunner(CL);
  RIRegister_TPHPControlBlock(CL);
end;

 
 
{ TPSImport_idPHPRunner }
(*----------------------------------------------------------------------------*)
procedure TPSImport_idPHPRunner.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_idPHPRunner(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_idPHPRunner.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_idPHPRunner(ri);
  //RIRegister_idPHPRunner_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
