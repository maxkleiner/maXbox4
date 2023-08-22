unit uPSI_SOAPConn;
{
   to soap  with RIO
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
  TPSImport_SOAPConn = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSoapConnection(CL: TPSPascalCompiler);
procedure SIRegister_SOAPConn(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSoapConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_SOAPConn(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,Midas
  ,DBClient
  ,SOAPHTTPTrans
  ,Rio
  ,SOAPHTTPClient
  ,SOAPMidas
  ,SOAPConn
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SOAPConn]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSoapConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomRemoteServer', 'TSoapConnection') do
  with CL.AddClassN(CL.FindClass('TCustomRemoteServer'),'TSoapConnection') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GetServerList : OleVariant');
    RegisterMethod('Procedure GetProviderNames( Proc : TGetStrProc)');
    RegisterMethod('Function GetServer : IAppServer');
    RegisterMethod('Function GetSOAPServer : IAppServerSOAP');
    RegisterProperty('RIO', 'THTTPRIO', iptr);
    RegisterProperty('Agent', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('Proxy', 'string', iptrw);
    RegisterProperty('ProxyByPass', 'string', iptrw);
    RegisterProperty('URL', 'string', iptrw);
    RegisterProperty('SOAPServerIID', 'String', iptrw);
    RegisterProperty('UserName', 'string', iptrw);
    RegisterProperty('UseSOAPAdapter', 'Boolean', iptrw);
    RegisterProperty('OnAfterExecute', 'TAfterExecuteEvent', iptrw);
    RegisterProperty('OnBeforeExecute', 'TBeforeExecuteEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SOAPConn(CL: TPSPascalCompiler);
begin
  SIRegister_TSoapConnection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSoapConnectionOnBeforeExecute_W(Self: TSoapConnection; const T: TBeforeExecuteEvent);
begin Self.OnBeforeExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionOnBeforeExecute_R(Self: TSoapConnection; var T: TBeforeExecuteEvent);
begin T := Self.OnBeforeExecute; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionOnAfterExecute_W(Self: TSoapConnection; const T: TAfterExecuteEvent);
begin Self.OnAfterExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionOnAfterExecute_R(Self: TSoapConnection; var T: TAfterExecuteEvent);
begin T := Self.OnAfterExecute; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionUseSOAPAdapter_W(Self: TSoapConnection; const T: Boolean);
begin Self.UseSOAPAdapter := T; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionUseSOAPAdapter_R(Self: TSoapConnection; var T: Boolean);
begin T := Self.UseSOAPAdapter; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionUserName_W(Self: TSoapConnection; const T: string);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionUserName_R(Self: TSoapConnection; var T: string);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionSOAPServerIID_W(Self: TSoapConnection; const T: String);
begin Self.SOAPServerIID := T; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionSOAPServerIID_R(Self: TSoapConnection; var T: String);
begin T := Self.SOAPServerIID; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionURL_W(Self: TSoapConnection; const T: string);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionURL_R(Self: TSoapConnection; var T: string);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionProxyByPass_W(Self: TSoapConnection; const T: string);
begin Self.ProxyByPass := T; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionProxyByPass_R(Self: TSoapConnection; var T: string);
begin T := Self.ProxyByPass; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionProxy_W(Self: TSoapConnection; const T: string);
begin Self.Proxy := T; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionProxy_R(Self: TSoapConnection; var T: string);
begin T := Self.Proxy; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionPassword_W(Self: TSoapConnection; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionPassword_R(Self: TSoapConnection; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionAgent_W(Self: TSoapConnection; const T: string);
begin Self.Agent := T; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionAgent_R(Self: TSoapConnection; var T: string);
begin T := Self.Agent; end;

(*----------------------------------------------------------------------------*)
procedure TSoapConnectionRIO_R(Self: TSoapConnection; var T: THTTPRIO);
begin T := Self.RIO; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSoapConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSoapConnection) do begin
    RegisterConstructor(@TSoapConnection.Create, 'Create');
    RegisterMethod(@TSoapConnection.Destroy, 'Free');
     RegisterMethod(@TSoapConnection.GetServerList, 'GetServerList');
    RegisterMethod(@TSoapConnection.GetProviderNames, 'GetProviderNames');
    RegisterMethod(@TSoapConnection.GetServer, 'GetServer');
    RegisterMethod(@TSoapConnection.GetSOAPServer, 'GetSOAPServer');
    RegisterPropertyHelper(@TSoapConnectionRIO_R,nil,'RIO');
    RegisterPropertyHelper(@TSoapConnectionAgent_R,@TSoapConnectionAgent_W,'Agent');
    RegisterPropertyHelper(@TSoapConnectionPassword_R,@TSoapConnectionPassword_W,'Password');
    RegisterPropertyHelper(@TSoapConnectionProxy_R,@TSoapConnectionProxy_W,'Proxy');
    RegisterPropertyHelper(@TSoapConnectionProxyByPass_R,@TSoapConnectionProxyByPass_W,'ProxyByPass');
    RegisterPropertyHelper(@TSoapConnectionURL_R,@TSoapConnectionURL_W,'URL');
    RegisterPropertyHelper(@TSoapConnectionSOAPServerIID_R,@TSoapConnectionSOAPServerIID_W,'SOAPServerIID');
    RegisterPropertyHelper(@TSoapConnectionUserName_R,@TSoapConnectionUserName_W,'UserName');
    RegisterPropertyHelper(@TSoapConnectionUseSOAPAdapter_R,@TSoapConnectionUseSOAPAdapter_W,'UseSOAPAdapter');
    RegisterPropertyHelper(@TSoapConnectionOnAfterExecute_R,@TSoapConnectionOnAfterExecute_W,'OnAfterExecute');
    RegisterPropertyHelper(@TSoapConnectionOnBeforeExecute_R,@TSoapConnectionOnBeforeExecute_W,'OnBeforeExecute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SOAPConn(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSoapConnection(CL);
end;

 
 
{ TPSImport_SOAPConn }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SOAPConn.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SOAPConn(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SOAPConn.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SOAPConn(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
