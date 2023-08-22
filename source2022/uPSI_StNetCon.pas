unit uPSI_StNetCon;
{
    SysTools4     adapted by mX

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
  TPSImport_StNetCon = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStNetConnection(CL: TPSPascalCompiler);
procedure SIRegister_StNetCon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStNetConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_StNetCon(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StBase
  ,StNetCon
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StNetCon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNetConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStNetConnection') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStNetConnection') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Connect : DWord');
    RegisterMethod('Function Disconnect : DWord');
    RegisterProperty('Password', 'String', iptrw);
    RegisterProperty('UserName', 'String', iptrw);
    RegisterProperty('ConnectOptions', 'TStNetConnectOptionsSet', iptrw);
    RegisterProperty('DisconnectOptions', 'TStNetDisconnectOptionsSet', iptrw);
    RegisterProperty('LocalDevice', 'String', iptrw);
    RegisterProperty('ServerName', 'String', iptrw);
    RegisterProperty('ShareName', 'String', iptrw);
    RegisterProperty('OnConnect', 'TNotifyEvent', iptrw);
    RegisterProperty('OnConnectFail', 'TOnConnectFailEvent', iptrw);
    RegisterProperty('OnConnectCancel', 'TOnConnectCancelEvent', iptrw);
    RegisterProperty('OnDisconnect', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDisconnectFail', 'TOnDisconnectFailEvent', iptrw);
    RegisterProperty('OnDisconnectCancel', 'TOnDisconnectCancelEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StNetCon(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStNetConnectOptions', '( coUseConnectDialog, coPersistentConnec'
   +'tion, coReadOnlyPath, coUseMRU, coHideRestoreBox, coPromptForAccount, coAl'
   +'waysPromptForAccount, coRedirectIfNeeded )');
  CL.AddTypeS('TStNetDisconnectOptions', '( doUseDisconnectDialog, doUpdateProf'
   +'ile, doForceFilesClosed, doPromptToForceFilesClosed )');
  CL.AddTypeS('TStNetConnectOptionsSet', 'set of TStNetConnectOptions');
  CL.AddTypeS('TStNetDisconnectOptionsSet', 'set of TStNetDisconnectOptions');
  CL.AddTypeS('TOnConnectFailEvent', 'Procedure ( Sender : TObject; ErrorCode: DWord)');
  CL.AddTypeS('TOnConnectCancelEvent', 'Procedure ( Sender : TObject; ErrorCode: DWord)');
  CL.AddTypeS('TOnDisconnectFailEvent', 'Procedure ( Sender : TObject; ErrorCode : DWord)');
  CL.AddTypeS('TOnDisconnectCancelEvent', 'Procedure ( Sender : TObject; ErrorCode : DWord)');
  SIRegister_TStNetConnection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnDisconnectCancel_W(Self: TStNetConnection; const T: TOnDisconnectCancelEvent);
begin Self.OnDisconnectCancel := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnDisconnectCancel_R(Self: TStNetConnection; var T: TOnDisconnectCancelEvent);
begin T := Self.OnDisconnectCancel; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnDisconnectFail_W(Self: TStNetConnection; const T: TOnDisconnectFailEvent);
begin Self.OnDisconnectFail := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnDisconnectFail_R(Self: TStNetConnection; var T: TOnDisconnectFailEvent);
begin T := Self.OnDisconnectFail; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnDisconnect_W(Self: TStNetConnection; const T: TNotifyEvent);
begin Self.OnDisconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnDisconnect_R(Self: TStNetConnection; var T: TNotifyEvent);
begin T := Self.OnDisconnect; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnConnectCancel_W(Self: TStNetConnection; const T: TOnConnectCancelEvent);
begin Self.OnConnectCancel := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnConnectCancel_R(Self: TStNetConnection; var T: TOnConnectCancelEvent);
begin T := Self.OnConnectCancel; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnConnectFail_W(Self: TStNetConnection; const T: TOnConnectFailEvent);
begin Self.OnConnectFail := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnConnectFail_R(Self: TStNetConnection; var T: TOnConnectFailEvent);
begin T := Self.OnConnectFail; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnConnect_W(Self: TStNetConnection; const T: TNotifyEvent);
begin Self.OnConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionOnConnect_R(Self: TStNetConnection; var T: TNotifyEvent);
begin T := Self.OnConnect; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionShareName_W(Self: TStNetConnection; const T: String);
begin Self.ShareName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionShareName_R(Self: TStNetConnection; var T: String);
begin T := Self.ShareName; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionServerName_W(Self: TStNetConnection; const T: String);
begin Self.ServerName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionServerName_R(Self: TStNetConnection; var T: String);
begin T := Self.ServerName; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionLocalDevice_W(Self: TStNetConnection; const T: String);
begin Self.LocalDevice := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionLocalDevice_R(Self: TStNetConnection; var T: String);
begin T := Self.LocalDevice; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionDisconnectOptions_W(Self: TStNetConnection; const T: TStNetDisconnectOptionsSet);
begin Self.DisconnectOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionDisconnectOptions_R(Self: TStNetConnection; var T: TStNetDisconnectOptionsSet);
begin T := Self.DisconnectOptions; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionConnectOptions_W(Self: TStNetConnection; const T: TStNetConnectOptionsSet);
begin Self.ConnectOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionConnectOptions_R(Self: TStNetConnection; var T: TStNetConnectOptionsSet);
begin T := Self.ConnectOptions; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionUserName_W(Self: TStNetConnection; const T: String);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionUserName_R(Self: TStNetConnection; var T: String);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionPassword_W(Self: TStNetConnection; const T: String);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetConnectionPassword_R(Self: TStNetConnection; var T: String);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNetConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNetConnection) do
  begin
    RegisterConstructor(@TStNetConnection.Create, 'Create');
    RegisterMethod(@TStNetConnection.Connect, 'Connect');
    RegisterMethod(@TStNetConnection.Disconnect, 'Disconnect');
    RegisterPropertyHelper(@TStNetConnectionPassword_R,@TStNetConnectionPassword_W,'Password');
    RegisterPropertyHelper(@TStNetConnectionUserName_R,@TStNetConnectionUserName_W,'UserName');
    RegisterPropertyHelper(@TStNetConnectionConnectOptions_R,@TStNetConnectionConnectOptions_W,'ConnectOptions');
    RegisterPropertyHelper(@TStNetConnectionDisconnectOptions_R,@TStNetConnectionDisconnectOptions_W,'DisconnectOptions');
    RegisterPropertyHelper(@TStNetConnectionLocalDevice_R,@TStNetConnectionLocalDevice_W,'LocalDevice');
    RegisterPropertyHelper(@TStNetConnectionServerName_R,@TStNetConnectionServerName_W,'ServerName');
    RegisterPropertyHelper(@TStNetConnectionShareName_R,@TStNetConnectionShareName_W,'ShareName');
    RegisterPropertyHelper(@TStNetConnectionOnConnect_R,@TStNetConnectionOnConnect_W,'OnConnect');
    RegisterPropertyHelper(@TStNetConnectionOnConnectFail_R,@TStNetConnectionOnConnectFail_W,'OnConnectFail');
    RegisterPropertyHelper(@TStNetConnectionOnConnectCancel_R,@TStNetConnectionOnConnectCancel_W,'OnConnectCancel');
    RegisterPropertyHelper(@TStNetConnectionOnDisconnect_R,@TStNetConnectionOnDisconnect_W,'OnDisconnect');
    RegisterPropertyHelper(@TStNetConnectionOnDisconnectFail_R,@TStNetConnectionOnDisconnectFail_W,'OnDisconnectFail');
    RegisterPropertyHelper(@TStNetConnectionOnDisconnectCancel_R,@TStNetConnectionOnDisconnectCancel_W,'OnDisconnectCancel');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StNetCon(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStNetConnection(CL);
end;

 
 
{ TPSImport_StNetCon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StNetCon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StNetCon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StNetCon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StNetCon(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
