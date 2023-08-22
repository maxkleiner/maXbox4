unit uPSI_JvRemLog;
{
  remote with MIDAS
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
  TPSImport_JvRemLog = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvRemoteLogin(CL: TPSPascalCompiler);
procedure SIRegister_JvRemLog(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvRemoteLogin(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvRemLog(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,DBClient
  ,JvxLogin
  ,JvRemLog
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvRemLog]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvRemoteLogin(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomLogin', 'TJvRemoteLogin') do
  with CL.AddClassN(CL.FindClass('TJvCustomLogin'),'TJvRemoteLogin') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('RemoteServer', 'TCustomRemoteServer', iptrw);
    RegisterProperty('OnCheckUser', 'TJvLoginEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvRemLog(CL: TPSPascalCompiler);
begin
  SIRegister_TJvRemoteLogin(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvRemoteLoginOnCheckUser_W(Self: TJvRemoteLogin; const T: TJvLoginEvent);
begin Self.OnCheckUser := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRemoteLoginOnCheckUser_R(Self: TJvRemoteLogin; var T: TJvLoginEvent);
begin T := Self.OnCheckUser; end;

(*----------------------------------------------------------------------------*)
procedure TJvRemoteLoginRemoteServer_W(Self: TJvRemoteLogin; const T: TCustomRemoteServer);
begin Self.RemoteServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRemoteLoginRemoteServer_R(Self: TJvRemoteLogin; var T: TCustomRemoteServer);
begin T := Self.RemoteServer; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvRemoteLogin(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvRemoteLogin) do begin
    RegisterConstructor(@TJvRemoteLogin.Create, 'Create');
    RegisterPropertyHelper(@TJvRemoteLoginRemoteServer_R,@TJvRemoteLoginRemoteServer_W,'RemoteServer');
    RegisterPropertyHelper(@TJvRemoteLoginOnCheckUser_R,@TJvRemoteLoginOnCheckUser_W,'OnCheckUser');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvRemLog(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvRemoteLogin(CL);
end;

 
 
{ TPSImport_JvRemLog }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvRemLog.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvRemLog(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvRemLog.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvRemLog(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
