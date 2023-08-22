unit uPSI_Services;
{
  to more REST  rename to TMService
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
  TPSImport_Services = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TmService(CL: TPSPascalCompiler);
procedure SIRegister_Services(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TmService(CL: TPSRuntimeClassImporter);
procedure RIRegister_Services(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinSvc
  ,Services
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Services]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TmService(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TService') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TmService') do begin
    RegisterMethod('Constructor Create( ServiceName : string; Description : string)');
    RegisterMethod('Function GetServiceError : integer');
    RegisterMethod('Function GetServiceErrorMessage : string');
    RegisterMethod('Function GetState : cardinal');
    RegisterMethod('Function Install : boolean');
    RegisterMethod('Function Uninstall : boolean');
    RegisterMethod('Procedure Insert( Exec : string)');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Function Run( ServThreads : array of TThread; ServBegin : TFuncBool; ServEnd : TFuncBool) : boolean');
    RegisterMethod('Function Exists : boolean');
    RegisterMethod('Function Stop : integer');
    RegisterMethod('Function Start : integer');
    RegisterMethod('Function ReportStart : boolean');
    RegisterMethod('Function ReportStop : boolean');
    RegisterMethod('Procedure ReportEventLog( EventType : TEventType; EventCode : word; Message : string)');
    RegisterMethod('Procedure Reset');
    RegisterProperty('Timeout', 'integer', iptrw);
    RegisterProperty('ExitCode', 'integer', iptrw);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('ParamStr', 'string', iptr);
    RegisterProperty('ParamCount', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Services(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TEventType', '( EventError, EventWarning, EventInformation )');
  SIRegister_TmService(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TmServiceParamCount_R(Self: TmService; var T: integer);
begin T := Self.ParamCount; end;

(*----------------------------------------------------------------------------*)
procedure TmServiceParamStr_R(Self: TmService; var T: string);
begin T := Self.ParamStr; end;

(*----------------------------------------------------------------------------*)
procedure TmServiceName_R(Self: TmService; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TmServiceExitCode_W(Self: TmService; const T: integer);
begin Self.ExitCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TmServiceExitCode_R(Self: TmService; var T: integer);
begin T := Self.ExitCode; end;

(*----------------------------------------------------------------------------*)
procedure TmServiceTimeout_W(Self: TmService; const T: integer);
begin Self.Timeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TmServiceTimeout_R(Self: TmService; var T: integer);
begin T := Self.Timeout; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TmService(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TmService) do begin
    RegisterConstructor(@TmService.Create, 'Create');
    RegisterMethod(@TmService.GeTServiceError, 'GetServiceError');
    RegisterMethod(@TmService.GetServiceErrorMessage, 'GetServiceErrorMessage');
    RegisterMethod(@TmService.GetState, 'GetState');
    RegisterMethod(@TmService.Install, 'Install');
    RegisterMethod(@TmService.Uninstall, 'Uninstall');
    RegisterMethod(@TmService.Insert, 'Insert');
    RegisterMethod(@TmService.Delete, 'Delete');
    RegisterMethod(@TmService.Run, 'Run');
    RegisterMethod(@TmService.Exists, 'Exists');
    RegisterMethod(@TmService.Stop, 'Stop');
    RegisterMethod(@TmService.Start, 'Start');
    RegisterMethod(@TmService.ReportStart, 'ReportStart');
    RegisterMethod(@TmService.ReportStop, 'ReportStop');
    RegisterMethod(@TmService.ReportEventLog, 'ReportEventLog');
    RegisterMethod(@TmService.Reset, 'Reset');
    RegisterPropertyHelper(@TmServiceTimeout_R,@TmServiceTimeout_W,'Timeout');
    RegisterPropertyHelper(@TmServiceExitCode_R,@TmServiceExitCode_W,'ExitCode');
    RegisterPropertyHelper(@TmServiceName_R,nil,'Name');
    RegisterPropertyHelper(@TmServiceParamStr_R,nil,'ParamStr');
    RegisterPropertyHelper(@TmServiceParamCount_R,nil,'ParamCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Services(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TmService(CL);
end;

 
 
{ TPSImport_Services }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Services.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Services(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Services.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Services(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
