unit uPSI_JvFtpGrabber;
{
   to get geo data and scann
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
  TPSImport_JvFtpGrabber = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvFtpGrabber(CL: TPSPascalCompiler);
procedure SIRegister_TJvFtpThread(CL: TPSPascalCompiler);
procedure SIRegister_JvFtpGrabber(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvFtpGrabber(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvFtpThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvFtpGrabber(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,WinInet
  ,JvTypes
  ,JvComponent
  ,JvFtpGrabber
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvFtpGrabber]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvFtpGrabber(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvFtpGrabber') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvFtpGrabber') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Size', 'Integer', iptrw);
    RegisterProperty('Url', 'string', iptrw);
    RegisterProperty('UserName', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('OutputMode', 'TJvOutputMode', iptrw);
    RegisterProperty('Mode', 'TJvDownloadMode', iptrw);
    RegisterProperty('Agent', 'string', iptrw);
    RegisterProperty('OnDoneFile', 'TOnDoneFile', iptrw);
    RegisterProperty('OnDoneStream', 'TOnDoneStream', iptrw);
    RegisterProperty('OnError', 'TOnError', iptrw);
    RegisterProperty('OnProgress', 'TOnFtpProgress', iptrw);
    RegisterProperty('OnResolvingName', 'TNotifyEvent', iptrw);
    RegisterProperty('OnResolvedName', 'TNotifyEvent', iptrw);
    RegisterProperty('OnConnectingToServer', 'TNotifyEvent', iptrw);
    RegisterProperty('OnConnectedToServer', 'TNotifyEvent', iptrw);
    RegisterProperty('OnSendingRequest', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRequestSent', 'TNotifyEvent', iptrw);
    RegisterProperty('OnReceivingResponse', 'TNotifyEvent', iptrw);
    RegisterProperty('OnReceivedResponse', 'TNotifyEvent', iptrw);
    RegisterProperty('OnClosingConnection', 'TNotifyEvent', iptrw);
    RegisterProperty('OnClosedConnection', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRequestComplete', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRedirect', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStateChange', 'TNotifyEvent', iptrw);
    RegisterMethod('Procedure Execute');
    RegisterMethod('Procedure Terminate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvFtpThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TJvFtpThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TJvFtpThread') do
  begin
    RegisterMethod('Constructor Create( Url, UserName, FileName, Password : string; OutputMode : TJvOutputMode; OnError : TOnError; OnDoneFile : TOnDoneFile; OnDoneStream : TOnDoneStream; OnProgress : TOnFtpProgress; Mode : TJvDownloadMode;'
      +' Agent : string; OnStatus : TOnFtpProgress; Sender : TObject; OnClosedConnection : TNotifyEvent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvFtpGrabber(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvDownloadMode', '( hmBinary, hmAscii )');
  SIRegister_TJvFtpThread(CL);
  SIRegister_TJvFtpGrabber(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnStateChange_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnStateChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnStateChange_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnStateChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnRedirect_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnRedirect := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnRedirect_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnRedirect; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnRequestComplete_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnRequestComplete := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnRequestComplete_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnRequestComplete; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnClosedConnection_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnClosedConnection := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnClosedConnection_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnClosedConnection; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnClosingConnection_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnClosingConnection := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnClosingConnection_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnClosingConnection; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnReceivedResponse_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnReceivedResponse := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnReceivedResponse_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnReceivedResponse; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnReceivingResponse_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnReceivingResponse := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnReceivingResponse_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnReceivingResponse; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnRequestSent_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnRequestSent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnRequestSent_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnRequestSent; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnSendingRequest_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnSendingRequest := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnSendingRequest_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnSendingRequest; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnConnectedToServer_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnConnectedToServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnConnectedToServer_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnConnectedToServer; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnConnectingToServer_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnConnectingToServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnConnectingToServer_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnConnectingToServer; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnResolvedName_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnResolvedName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnResolvedName_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnResolvedName; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnResolvingName_W(Self: TJvFtpGrabber; const T: TNotifyEvent);
begin Self.OnResolvingName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnResolvingName_R(Self: TJvFtpGrabber; var T: TNotifyEvent);
begin T := Self.OnResolvingName; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnProgress_W(Self: TJvFtpGrabber; const T: TOnFtpProgress);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnProgress_R(Self: TJvFtpGrabber; var T: TOnFtpProgress);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnError_W(Self: TJvFtpGrabber; const T: TOnError);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnError_R(Self: TJvFtpGrabber; var T: TOnError);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnDoneStream_W(Self: TJvFtpGrabber; const T: TOnDoneStream);
begin Self.OnDoneStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnDoneStream_R(Self: TJvFtpGrabber; var T: TOnDoneStream);
begin T := Self.OnDoneStream; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnDoneFile_W(Self: TJvFtpGrabber; const T: TOnDoneFile);
begin Self.OnDoneFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOnDoneFile_R(Self: TJvFtpGrabber; var T: TOnDoneFile);
begin T := Self.OnDoneFile; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberAgent_W(Self: TJvFtpGrabber; const T: string);
begin Self.Agent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberAgent_R(Self: TJvFtpGrabber; var T: string);
begin T := Self.Agent; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberMode_W(Self: TJvFtpGrabber; const T: TJvDownloadMode);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberMode_R(Self: TJvFtpGrabber; var T: TJvDownloadMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOutputMode_W(Self: TJvFtpGrabber; const T: TJvOutputMode);
begin Self.OutputMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberOutputMode_R(Self: TJvFtpGrabber; var T: TJvOutputMode);
begin T := Self.OutputMode; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberFileName_W(Self: TJvFtpGrabber; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberFileName_R(Self: TJvFtpGrabber; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberPassword_W(Self: TJvFtpGrabber; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberPassword_R(Self: TJvFtpGrabber; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberUserName_W(Self: TJvFtpGrabber; const T: string);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberUserName_R(Self: TJvFtpGrabber; var T: string);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberUrl_W(Self: TJvFtpGrabber; const T: string);
begin Self.Url := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberUrl_R(Self: TJvFtpGrabber; var T: string);
begin T := Self.Url; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberSize_W(Self: TJvFtpGrabber; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFtpGrabberSize_R(Self: TJvFtpGrabber; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvFtpGrabber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvFtpGrabber) do begin
    RegisterConstructor(@TJvFtpGrabber.Create, 'Create');
        RegisterMethod(@TJvFtpGrabber.Destroy, 'Free');
    RegisterPropertyHelper(@TJvFtpGrabberSize_R,@TJvFtpGrabberSize_W,'Size');
    RegisterPropertyHelper(@TJvFtpGrabberUrl_R,@TJvFtpGrabberUrl_W,'Url');
    RegisterPropertyHelper(@TJvFtpGrabberUserName_R,@TJvFtpGrabberUserName_W,'UserName');
    RegisterPropertyHelper(@TJvFtpGrabberPassword_R,@TJvFtpGrabberPassword_W,'Password');
    RegisterPropertyHelper(@TJvFtpGrabberFileName_R,@TJvFtpGrabberFileName_W,'FileName');
    RegisterPropertyHelper(@TJvFtpGrabberOutputMode_R,@TJvFtpGrabberOutputMode_W,'OutputMode');
    RegisterPropertyHelper(@TJvFtpGrabberMode_R,@TJvFtpGrabberMode_W,'Mode');
    RegisterPropertyHelper(@TJvFtpGrabberAgent_R,@TJvFtpGrabberAgent_W,'Agent');
    RegisterPropertyHelper(@TJvFtpGrabberOnDoneFile_R,@TJvFtpGrabberOnDoneFile_W,'OnDoneFile');
    RegisterPropertyHelper(@TJvFtpGrabberOnDoneStream_R,@TJvFtpGrabberOnDoneStream_W,'OnDoneStream');
    RegisterPropertyHelper(@TJvFtpGrabberOnError_R,@TJvFtpGrabberOnError_W,'OnError');
    RegisterPropertyHelper(@TJvFtpGrabberOnProgress_R,@TJvFtpGrabberOnProgress_W,'OnProgress');
    RegisterPropertyHelper(@TJvFtpGrabberOnResolvingName_R,@TJvFtpGrabberOnResolvingName_W,'OnResolvingName');
    RegisterPropertyHelper(@TJvFtpGrabberOnResolvedName_R,@TJvFtpGrabberOnResolvedName_W,'OnResolvedName');
    RegisterPropertyHelper(@TJvFtpGrabberOnConnectingToServer_R,@TJvFtpGrabberOnConnectingToServer_W,'OnConnectingToServer');
    RegisterPropertyHelper(@TJvFtpGrabberOnConnectedToServer_R,@TJvFtpGrabberOnConnectedToServer_W,'OnConnectedToServer');
    RegisterPropertyHelper(@TJvFtpGrabberOnSendingRequest_R,@TJvFtpGrabberOnSendingRequest_W,'OnSendingRequest');
    RegisterPropertyHelper(@TJvFtpGrabberOnRequestSent_R,@TJvFtpGrabberOnRequestSent_W,'OnRequestSent');
    RegisterPropertyHelper(@TJvFtpGrabberOnReceivingResponse_R,@TJvFtpGrabberOnReceivingResponse_W,'OnReceivingResponse');
    RegisterPropertyHelper(@TJvFtpGrabberOnReceivedResponse_R,@TJvFtpGrabberOnReceivedResponse_W,'OnReceivedResponse');
    RegisterPropertyHelper(@TJvFtpGrabberOnClosingConnection_R,@TJvFtpGrabberOnClosingConnection_W,'OnClosingConnection');
    RegisterPropertyHelper(@TJvFtpGrabberOnClosedConnection_R,@TJvFtpGrabberOnClosedConnection_W,'OnClosedConnection');
    RegisterPropertyHelper(@TJvFtpGrabberOnRequestComplete_R,@TJvFtpGrabberOnRequestComplete_W,'OnRequestComplete');
    RegisterPropertyHelper(@TJvFtpGrabberOnRedirect_R,@TJvFtpGrabberOnRedirect_W,'OnRedirect');
    RegisterPropertyHelper(@TJvFtpGrabberOnStateChange_R,@TJvFtpGrabberOnStateChange_W,'OnStateChange');
    RegisterMethod(@TJvFtpGrabber.Execute, 'Execute');
    RegisterMethod(@TJvFtpGrabber.Terminate, 'Terminate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvFtpThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvFtpThread) do
  begin
    RegisterConstructor(@TJvFtpThread.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvFtpGrabber(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvFtpThread(CL);
  RIRegister_TJvFtpGrabber(CL);
end;

 
 
{ TPSImport_JvFtpGrabber }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFtpGrabber.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvFtpGrabber(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFtpGrabber.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvFtpGrabber(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
