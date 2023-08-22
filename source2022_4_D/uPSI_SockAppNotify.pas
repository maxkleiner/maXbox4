unit uPSI_SockAppNotify;
{
   socks rocks for mX4
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
  TPSImport_SockAppNotify = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRunningWebAppNotifier(CL: TPSPascalCompiler);
procedure SIRegister_TRunningWebAppListener(CL: TPSPascalCompiler);
procedure SIRegister_TWebAppInfo(CL: TPSPascalCompiler);
procedure SIRegister_SockAppNotify(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TRunningWebAppNotifier(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRunningWebAppListener(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWebAppInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_SockAppNotify(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdTCPClient
  ,idTCPConnection
  ,SockTransport
  ,IndySockTransport
  ,HTTPApp
  ,IdUDPServer
  ,IdSocketHandle
  ,IdUDPClient
  ,SyncObjs
  ,Contnrs
  ,SockAppNotify
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SockAppNotify]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRunningWebAppNotifier(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRunningWebAppNotifier') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRunningWebAppNotifier') do begin
    RegisterMethod('Constructor Create( AAppPort : Integer; const AProgID, AFileName : string)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Register');
    RegisterMethod('Procedure Unregister');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRunningWebAppListener(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRunningWebAppListener') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRunningWebAppListener') do begin
    RegisterProperty('Connection', 'TIdUDPServer', iptr);
    RegisterMethod('Procedure RemovePort( APort : Integer)');
    RegisterMethod('Function GetPortOfFileName( AFileName : string) : Integer');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWebAppInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TWebAppInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TWebAppInfo') do begin
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('LastAccess', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SockAppNotify(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('sExecWaitToken','String').SetString( 'webappdbgtoken');
  SIRegister_TWebAppInfo(CL);
  SIRegister_TRunningWebAppListener(CL);
  SIRegister_TRunningWebAppNotifier(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRunningWebAppListenerPort_W(Self: TRunningWebAppListener; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TRunningWebAppListenerPort_R(Self: TRunningWebAppListener; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TRunningWebAppListenerActive_W(Self: TRunningWebAppListener; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TRunningWebAppListenerActive_R(Self: TRunningWebAppListener; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TRunningWebAppListenerConnection_R(Self: TRunningWebAppListener; var T: TIdUDPServer);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure TWebAppInfoLastAccess_W(Self: TWebAppInfo; const T: Cardinal);
Begin Self.LastAccess := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebAppInfoLastAccess_R(Self: TWebAppInfo; var T: Cardinal);
Begin T := Self.LastAccess; end;

(*----------------------------------------------------------------------------*)
procedure TWebAppInfoFileName_W(Self: TWebAppInfo; const T: string);
Begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebAppInfoFileName_R(Self: TWebAppInfo; var T: string);
Begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TWebAppInfoPort_W(Self: TWebAppInfo; const T: Integer);
Begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebAppInfoPort_R(Self: TWebAppInfo; var T: Integer);
Begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRunningWebAppNotifier(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRunningWebAppNotifier) do
  begin
    RegisterConstructor(@TRunningWebAppNotifier.Create, 'Create');
    RegisterMethod(@TRunningWebAppNotifier.Register, 'Register');
    RegisterMethod(@TRunningWebAppNotifier.Unregister, 'Unregister');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRunningWebAppListener(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRunningWebAppListener) do
  begin
    RegisterPropertyHelper(@TRunningWebAppListenerConnection_R,nil,'Connection');
    RegisterMethod(@TRunningWebAppListener.RemovePort, 'RemovePort');
    RegisterMethod(@TRunningWebAppListener.GetPortOfFileName, 'GetPortOfFileName');
    RegisterPropertyHelper(@TRunningWebAppListenerActive_R,@TRunningWebAppListenerActive_W,'Active');
    RegisterPropertyHelper(@TRunningWebAppListenerPort_R,@TRunningWebAppListenerPort_W,'Port');
    RegisterConstructor(@TRunningWebAppListener.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWebAppInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWebAppInfo) do
  begin
    RegisterPropertyHelper(@TWebAppInfoPort_R,@TWebAppInfoPort_W,'Port');
    RegisterPropertyHelper(@TWebAppInfoFileName_R,@TWebAppInfoFileName_W,'FileName');
    RegisterPropertyHelper(@TWebAppInfoLastAccess_R,@TWebAppInfoLastAccess_W,'LastAccess');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SockAppNotify(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TWebAppInfo(CL);
  RIRegister_TRunningWebAppListener(CL);
  RIRegister_TRunningWebAppNotifier(CL);
end;

 
 
{ TPSImport_SockAppNotify }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SockAppNotify.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SockAppNotify(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SockAppNotify.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SockAppNotify(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
