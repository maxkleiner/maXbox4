unit uPSI_IdHTTPWebBrokerBridge;
{
  to webbroker code mode
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
  TPSImport_IdHTTPWebBrokerBridge = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdHTTPWebBrokerBridge(CL: TPSPascalCompiler);
procedure SIRegister_TIdHTTPAppResponse(CL: TPSPascalCompiler);
procedure SIRegister_TIdHTTPAppRequest(CL: TPSPascalCompiler);
procedure SIRegister_IdHTTPWebBrokerBridge(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdHTTPWebBrokerBridge(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdHTTPAppResponse(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdHTTPAppRequest(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdHTTPWebBrokerBridge(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   HTTPApp
  ,IdCustomHTTPServer
  ,IdTCPServer
  ,IdIOHandlerSocket
  ,WebBroker
  ,IdHTTPWebBrokerBridge
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdHTTPWebBrokerBridge]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHTTPWebBrokerBridge(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdCustomHTTPServer', 'TIdHTTPWebBrokerBridge') do
  with CL.AddClassN(CL.FindClass('TIdCustomHTTPServer'),'TIdHTTPWebBrokerBridge') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
    RegisterMethod('Procedure RegisterWebModuleClass( AClass : TComponentClass)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHTTPAppResponse(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWebResponse', 'TIdHTTPAppResponse') do
  with CL.AddClassN(CL.FindClass('TWebResponse'),'TIdHTTPAppResponse') do begin
    RegisterMethod('Constructor Create( AHTTPRequest : TWebRequest; AThread : TIdPeerThread; ARequestInfo : TIdHTTPRequestInfo; AResponseInfo : TIdHTTPResponseInfo)');
    RegisterMethod('Procedure SendRedirect( const URI : string)');
    RegisterMethod('Procedure SendStream( AStream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHTTPAppRequest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWebRequest', 'TIdHTTPAppRequest') do
  with CL.AddClassN(CL.FindClass('TWebRequest'),'TIdHTTPAppRequest') do begin
    RegisterMethod('Constructor Create( AThread : TIdPeerThread; ARequestInfo : TIdHTTPRequestInfo; AResponseInfo : TIdHTTPResponseInfo)');
    RegisterMethod('Function GetFieldByName( const Name : string) : string');
    RegisterMethod('Function ReadClient( var Buffer, Count : Integer) : Integer');
    RegisterMethod('Function ReadString( Count : Integer) : string');
    RegisterMethod('Function TranslateURI( const URI : string) : string');
    RegisterMethod('Function WriteClient( var ABuffer, ACount : Integer) : Integer');
    RegisterMethod('Function WriteHeaders( StatusCode : Integer; const ReasonString, Headers : string) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdHTTPWebBrokerBridge(CL: TPSPascalCompiler);
begin
  SIRegister_TIdHTTPAppRequest(CL);
  SIRegister_TIdHTTPAppResponse(CL);
  SIRegister_TIdHTTPWebBrokerBridge(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHTTPWebBrokerBridge(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHTTPWebBrokerBridge) do begin
    RegisterConstructor(@TIdHTTPWebBrokerBridge.Create, 'Create');
     RegisterMethod(@TIdHTTPWebBrokerBridge.Destroy, 'Free');
    RegisterMethod(@TIdHTTPWebBrokerBridge.RegisterWebModuleClass, 'RegisterWebModuleClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHTTPAppResponse(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHTTPAppResponse) do
  begin
    RegisterConstructor(@TIdHTTPAppResponse.Create, 'Create');
    RegisterMethod(@TIdHTTPAppResponse.SendRedirect, 'SendRedirect');
    RegisterMethod(@TIdHTTPAppResponse.SendStream, 'SendStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHTTPAppRequest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHTTPAppRequest) do
  begin
    RegisterConstructor(@TIdHTTPAppRequest.Create, 'Create');
    RegisterMethod(@TIdHTTPAppRequest.GetFieldByName, 'GetFieldByName');
    RegisterMethod(@TIdHTTPAppRequest.ReadClient, 'ReadClient');
    RegisterMethod(@TIdHTTPAppRequest.ReadString, 'ReadString');
    RegisterMethod(@TIdHTTPAppRequest.TranslateURI, 'TranslateURI');
    RegisterMethod(@TIdHTTPAppRequest.WriteClient, 'WriteClient');
    RegisterMethod(@TIdHTTPAppRequest.WriteHeaders, 'WriteHeaders');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdHTTPWebBrokerBridge(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdHTTPAppRequest(CL);
  RIRegister_TIdHTTPAppResponse(CL);
  RIRegister_TIdHTTPWebBrokerBridge(CL);
end;

 
 
{ TPSImport_IdHTTPWebBrokerBridge }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdHTTPWebBrokerBridge.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdHTTPWebBrokerBridge(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdHTTPWebBrokerBridge.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdHTTPWebBrokerBridge(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
