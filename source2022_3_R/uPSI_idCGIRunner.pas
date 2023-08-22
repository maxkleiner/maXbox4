unit uPSI_idCGIRunner;
{
real stuff the sfc /scanner 

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
  TPSImport_idCGIRunner = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TidCGIRunner(CL: TPSPascalCompiler);
procedure SIRegister_idCGIRunner(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_idCGIRunner_Routines(S: TPSExec);
procedure RIRegister_TidCGIRunner(CL: TPSRuntimeClassImporter);
procedure RIRegister_idCGIRunner(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,idBaseComponent
  ,idTCPServer
  ,idStack
  ,idCustomHTTPServer
  ,idCookie
  ,idHTTPServer
  ,idCGIRunner
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_idCGIRunner]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TidCGIRunner(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TidBaseComponent', 'TidCGIRunner') do
  with CL.AddClassN(CL.FindClass('TidBaseComponent'),'TidCGIRunner') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute( LocalDoc : string; AThread : TIdPeerThread; RequestInfo : TIdHTTPRequestInfo; ResponseInfo : TIdHTTPResponseInfo; DocumentRoot : string; Action : string) : integer');
    RegisterProperty('Server', 'TidHTTPServer', iptrw);
    RegisterProperty('TimeOut', 'integer', iptrw);
    RegisterProperty('TimeOutMsg', 'string', iptrw);
    RegisterProperty('ErrorMsg', 'string', iptrw);
    RegisterProperty('ServerAdmin', 'string', iptrw);
    RegisterProperty('BeforeExecute', 'TNotifyEvent', iptrw);
    RegisterProperty('AfterExecute', 'TNotifyEvent', iptrw);
    RegisterProperty('PHPSupport', 'boolean', iptrw);
    RegisterProperty('PHPIniPath', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_idCGIRunner(CL: TPSPascalCompiler);
begin
  SIRegister_TidCGIRunner(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerPHPIniPath_W(Self: TidCGIRunner; const T: String);
begin Self.PHPIniPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerPHPIniPath_R(Self: TidCGIRunner; var T: String);
begin T := Self.PHPIniPath; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerPHPSupport_W(Self: TidCGIRunner; const T: boolean);
begin Self.PHPSupport := T; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerPHPSupport_R(Self: TidCGIRunner; var T: boolean);
begin T := Self.PHPSupport; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerAfterExecute_W(Self: TidCGIRunner; const T: TNotifyEvent);
begin Self.AfterExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerAfterExecute_R(Self: TidCGIRunner; var T: TNotifyEvent);
begin T := Self.AfterExecute; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerBeforeExecute_W(Self: TidCGIRunner; const T: TNotifyEvent);
begin Self.BeforeExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerBeforeExecute_R(Self: TidCGIRunner; var T: TNotifyEvent);
begin T := Self.BeforeExecute; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerServerAdmin_W(Self: TidCGIRunner; const T: string);
begin Self.ServerAdmin := T; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerServerAdmin_R(Self: TidCGIRunner; var T: string);
begin T := Self.ServerAdmin; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerErrorMsg_W(Self: TidCGIRunner; const T: string);
begin Self.ErrorMsg := T; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerErrorMsg_R(Self: TidCGIRunner; var T: string);
begin T := Self.ErrorMsg; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerTimeOutMsg_W(Self: TidCGIRunner; const T: string);
begin Self.TimeOutMsg := T; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerTimeOutMsg_R(Self: TidCGIRunner; var T: string);
begin T := Self.TimeOutMsg; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerTimeOut_W(Self: TidCGIRunner; const T: integer);
begin Self.TimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerTimeOut_R(Self: TidCGIRunner; var T: integer);
begin T := Self.TimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerServer_W(Self: TidCGIRunner; const T: TidHTTPServer);
begin Self.Server := T; end;

(*----------------------------------------------------------------------------*)
procedure TidCGIRunnerServer_R(Self: TidCGIRunner; var T: TidHTTPServer);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_idCGIRunner_Routines(S: TPSExec);
begin
// S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TidCGIRunner(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TidCGIRunner) do
  begin
    RegisterConstructor(@TidCGIRunner.Create, 'Create');
    RegisterVirtualMethod(@TidCGIRunner.Execute, 'Execute');
    RegisterPropertyHelper(@TidCGIRunnerServer_R,@TidCGIRunnerServer_W,'Server');
    RegisterPropertyHelper(@TidCGIRunnerTimeOut_R,@TidCGIRunnerTimeOut_W,'TimeOut');
    RegisterPropertyHelper(@TidCGIRunnerTimeOutMsg_R,@TidCGIRunnerTimeOutMsg_W,'TimeOutMsg');
    RegisterPropertyHelper(@TidCGIRunnerErrorMsg_R,@TidCGIRunnerErrorMsg_W,'ErrorMsg');
    RegisterPropertyHelper(@TidCGIRunnerServerAdmin_R,@TidCGIRunnerServerAdmin_W,'ServerAdmin');
    RegisterPropertyHelper(@TidCGIRunnerBeforeExecute_R,@TidCGIRunnerBeforeExecute_W,'BeforeExecute');
    RegisterPropertyHelper(@TidCGIRunnerAfterExecute_R,@TidCGIRunnerAfterExecute_W,'AfterExecute');
    RegisterPropertyHelper(@TidCGIRunnerPHPSupport_R,@TidCGIRunnerPHPSupport_W,'PHPSupport');
    RegisterPropertyHelper(@TidCGIRunnerPHPIniPath_R,@TidCGIRunnerPHPIniPath_W,'PHPIniPath');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_idCGIRunner(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TidCGIRunner(CL);
end;

 
 
{ TPSImport_idCGIRunner }
(*----------------------------------------------------------------------------*)
procedure TPSImport_idCGIRunner.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_idCGIRunner(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_idCGIRunner.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_idCGIRunner(ri);
  //RIRegister_idCGIRunner_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
