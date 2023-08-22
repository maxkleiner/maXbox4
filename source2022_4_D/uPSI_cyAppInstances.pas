unit uPSI_cyAppInstances;
{
   of basecomm
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
  TPSImport_cyAppInstances = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyAppInstances(CL: TPSPascalCompiler);
procedure SIRegister_cyAppInstances(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyAppInstances(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyAppInstances(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,Controls
  ,cyBaseComm
  ,cyAppInstances
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyAppInstances]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyAppInstances(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TcyBaseComm', 'TcyAppInstances') do
  with CL.AddClassN(CL.FindClass('TcyBaseComm'),'TcyAppInstances') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
    RegisterMethod('Function RegisterAsServer : Boolean');
    RegisterMethod('Procedure ShowWindowServer');
    RegisterProperty('ServerInfo', 'TcyInstanceInfo', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('AutoExitProcess', 'Boolean', iptrw);
    RegisterProperty('InstanceID', 'String', iptrw);
    RegisterProperty('Instances', 'Integer', iptr);
    RegisterProperty('IsServer', 'Boolean', iptr);
    RegisterProperty('MaxInstances', 'Word', iptrw);
    RegisterProperty('SendCmdLine', 'Boolean', iptrw);
    RegisterProperty('OnReceiveCmdLine', 'TProcOnReceiveCmdLine', iptrw);
    RegisterProperty('OnReceiveString', 'TProcOnReceiveString', iptrw);
    RegisterProperty('OnReceiveStream', 'TProcOnReceiveMemoryStream', iptrw);
    RegisterProperty('OnServerExists', 'TProcOnServerExists', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyAppInstances(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TcyInstanceInfo', 'record BaseComHandle : THandle; OwnerWindowHa'
   +'ndle : THandle; ApplicationHandle : THandle; Instances : Integer; MaxInstances : Word; end');
  CL.AddTypeS('TProcOnReceiveCmdLine', 'Procedure ( Sender : TObject; fromInstance : TcyInstanceInfo; Parameters : TStrings)');
  CL.AddTypeS('TProcOnServerExists', 'Procedure ( Sender : TObject; var DoExitProcess, DoSendCmdLine, ShowServer : Boolean)');
  SIRegister_TcyAppInstances(CL);
 CL.AddConstantN('CmdLineParam','LongInt').SetInt( 0);
 CL.AddConstantN('sPrefixInstanceID','String').SetString( 'CYAPPINST');
 CL.AddConstantN('seNotActive','String').SetString( 'Error: not Active!');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesOnServerExists_W(Self: TcyAppInstances; const T: TProcOnServerExists);
begin Self.OnServerExists := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesOnServerExists_R(Self: TcyAppInstances; var T: TProcOnServerExists);
begin T := Self.OnServerExists; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesOnReceiveStream_W(Self: TcyAppInstances; const T: TProcOnReceiveMemoryStream);
begin Self.OnReceiveStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesOnReceiveStream_R(Self: TcyAppInstances; var T: TProcOnReceiveMemoryStream);
begin T := Self.OnReceiveStream; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesOnReceiveString_W(Self: TcyAppInstances; const T: TProcOnReceiveString);
begin Self.OnReceiveString := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesOnReceiveString_R(Self: TcyAppInstances; var T: TProcOnReceiveString);
begin T := Self.OnReceiveString; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesOnReceiveCmdLine_W(Self: TcyAppInstances; const T: TProcOnReceiveCmdLine);
begin Self.OnReceiveCmdLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesOnReceiveCmdLine_R(Self: TcyAppInstances; var T: TProcOnReceiveCmdLine);
begin T := Self.OnReceiveCmdLine; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesSendCmdLine_W(Self: TcyAppInstances; const T: Boolean);
begin Self.SendCmdLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesSendCmdLine_R(Self: TcyAppInstances; var T: Boolean);
begin T := Self.SendCmdLine; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesMaxInstances_W(Self: TcyAppInstances; const T: Word);
begin Self.MaxInstances := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesMaxInstances_R(Self: TcyAppInstances; var T: Word);
begin T := Self.MaxInstances; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesIsServer_R(Self: TcyAppInstances; var T: Boolean);
begin T := Self.IsServer; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesInstances_R(Self: TcyAppInstances; var T: Integer);
begin T := Self.Instances; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesInstanceID_W(Self: TcyAppInstances; const T: String);
begin Self.InstanceID := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesInstanceID_R(Self: TcyAppInstances; var T: String);
begin T := Self.InstanceID; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesAutoExitProcess_W(Self: TcyAppInstances; const T: Boolean);
begin Self.AutoExitProcess := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesAutoExitProcess_R(Self: TcyAppInstances; var T: Boolean);
begin T := Self.AutoExitProcess; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesActive_W(Self: TcyAppInstances; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesActive_R(Self: TcyAppInstances; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TcyAppInstancesServerInfo_R(Self: TcyAppInstances; var T: TcyInstanceInfo);
begin T := Self.ServerInfo; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyAppInstances(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyAppInstances) do begin
    RegisterConstructor(@TcyAppInstances.Create, 'Create');
    RegisterMethod(@TcyAppInstances.Destroy, 'Free');
    RegisterMethod(@TcyAppInstances.RegisterAsServer, 'RegisterAsServer');
    RegisterMethod(@TcyAppInstances.ShowWindowServer, 'ShowWindowServer');
    RegisterPropertyHelper(@TcyAppInstancesServerInfo_R,nil,'ServerInfo');
    RegisterPropertyHelper(@TcyAppInstancesActive_R,@TcyAppInstancesActive_W,'Active');
    RegisterPropertyHelper(@TcyAppInstancesAutoExitProcess_R,@TcyAppInstancesAutoExitProcess_W,'AutoExitProcess');
    RegisterPropertyHelper(@TcyAppInstancesInstanceID_R,@TcyAppInstancesInstanceID_W,'InstanceID');
    RegisterPropertyHelper(@TcyAppInstancesInstances_R,nil,'Instances');
    RegisterPropertyHelper(@TcyAppInstancesIsServer_R,nil,'IsServer');
    RegisterPropertyHelper(@TcyAppInstancesMaxInstances_R,@TcyAppInstancesMaxInstances_W,'MaxInstances');
    RegisterPropertyHelper(@TcyAppInstancesSendCmdLine_R,@TcyAppInstancesSendCmdLine_W,'SendCmdLine');
    RegisterPropertyHelper(@TcyAppInstancesOnReceiveCmdLine_R,@TcyAppInstancesOnReceiveCmdLine_W,'OnReceiveCmdLine');
    RegisterPropertyHelper(@TcyAppInstancesOnReceiveString_R,@TcyAppInstancesOnReceiveString_W,'OnReceiveString');
    RegisterPropertyHelper(@TcyAppInstancesOnReceiveStream_R,@TcyAppInstancesOnReceiveStream_W,'OnReceiveStream');
    RegisterPropertyHelper(@TcyAppInstancesOnServerExists_R,@TcyAppInstancesOnServerExists_W,'OnServerExists');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyAppInstances(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyAppInstances(CL);
end;

 
 
{ TPSImport_cyAppInstances }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyAppInstances.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyAppInstances(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyAppInstances.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyAppInstances(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
