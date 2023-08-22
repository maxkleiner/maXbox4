unit uPSI_SockHTTP;
{
   base for socktrans mX4
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
  TPSImport_SockHTTP = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSockWebRequestHandler(CL: TPSPascalCompiler);
procedure SIRegister_TSockWebResponse(CL: TPSPascalCompiler);
procedure SIRegister_TSockWebRequest(CL: TPSPascalCompiler);
procedure SIRegister_ISockWebRequestAccess(CL: TPSPascalCompiler);
procedure SIRegister_SockHTTP(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSockWebRequestHandler(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSockWebResponse(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSockWebRequest(CL: TPSRuntimeClassImporter);
procedure RIRegister_SockHTTP(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   HTTPApp
  ,WebReq
  ,SockRequestInterpreter
  ,SockHTTP
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SockHTTP]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSockWebRequestHandler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWebRequestHandler', 'TSockWebRequestHandler') do
  with CL.AddClassN(CL.FindClass('TWebRequestHandler'),'TSockWebRequestHandler') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Run( AIntf : ISockWebRequestAccess)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSockWebResponse(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWebResponse', 'TSockWebResponse') do
  with CL.AddClassN(CL.FindClass('TWebResponse'),'TSockWebResponse') do
  begin
    RegisterMethod('Constructor Create( HTTPRequest : TWebRequest)');
    RegisterMethod('Procedure SendResponse');
    RegisterMethod('Procedure SendRedirect( const URI : string)');
    RegisterMethod('Procedure SendStream( AStream : TStream)');
    RegisterMethod('Function Sent : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSockWebRequest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWebRequest', 'TSockWebRequest') do
  with CL.AddClassN(CL.FindClass('TWebRequest'),'TSockWebRequest') do
  begin
    RegisterMethod('Constructor Create( AIntf : ISockWebRequestAccess)');
    RegisterMethod('Function GetFieldByName( const Name : string) : string');
    RegisterMethod('Function ReadClient( var Buffer, Count : Integer) : Integer');
    RegisterMethod('Function ReadString( Count : Integer) : string');
    RegisterMethod('Function TranslateURI( const URI : string) : string');
    RegisterMethod('Function WriteClient( var Buffer, Count : Integer) : Integer');
    RegisterMethod('Function WriteString( const AString : string) : Boolean');
    RegisterMethod('Function WriteHeaders( StatusCode : Integer; const StatusString, Headers : string) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISockWebRequestAccess(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'ISockWebRequestAccess') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),ISockWebRequestAccess, 'ISockWebRequestAccess') do
  begin
    RegisterMethod('Function GetFieldByName( const Name : string) : string', cdRegister);
    RegisterMethod('Function ReadClient( var Buffer : string; Count : Integer) : Integer', cdRegister);
    RegisterMethod('Function TranslateURI( const Value : string) : string', cdRegister);
    RegisterMethod('Function WriteClient( const Buffer : string) : Integer', cdRegister);
    RegisterMethod('Function GetStringVariable( Index : Integer) : string', cdRegister);
    RegisterMethod('Function WriteHeaders( StatusCode : Integer; StatusText : string; Headers : string) : Boolean', cdRegister);
    RegisterMethod('Function UsingStub : Boolean', cdRegister);
    RegisterMethod('Function ReadString( var Buffer : string; Count : Integer) : Integer', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SockHTTP(CL: TPSPascalCompiler);
begin
  SIRegister_ISockWebRequestAccess(CL);
  SIRegister_TSockWebRequest(CL);
  SIRegister_TSockWebResponse(CL);
  SIRegister_TSockWebRequestHandler(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TSockWebRequestHandler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSockWebRequestHandler) do begin
    RegisterConstructor(@TSockWebRequestHandler.Create, 'Create');
  RegisterMethod(@TSockWebRequestHandler.Destroy, 'Free');
    RegisterMethod(@TSockWebRequestHandler.Run, 'Run');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSockWebResponse(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSockWebResponse) do
  begin
    RegisterConstructor(@TSockWebResponse.Create, 'Create');
    RegisterMethod(@TSockWebResponse.SendResponse, 'SendResponse');
    RegisterMethod(@TSockWebResponse.SendRedirect, 'SendRedirect');
    RegisterMethod(@TSockWebResponse.SendStream, 'SendStream');
    RegisterMethod(@TSockWebResponse.Sent, 'Sent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSockWebRequest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSockWebRequest) do
  begin
    RegisterConstructor(@TSockWebRequest.Create, 'Create');
    RegisterMethod(@TSockWebRequest.GetFieldByName, 'GetFieldByName');
    RegisterMethod(@TSockWebRequest.ReadClient, 'ReadClient');
    RegisterMethod(@TSockWebRequest.ReadString, 'ReadString');
    RegisterMethod(@TSockWebRequest.TranslateURI, 'TranslateURI');
    RegisterMethod(@TSockWebRequest.WriteClient, 'WriteClient');
    RegisterMethod(@TSockWebRequest.WriteString, 'WriteString');
    RegisterMethod(@TSockWebRequest.WriteHeaders, 'WriteHeaders');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SockHTTP(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSockWebRequest(CL);
  RIRegister_TSockWebResponse(CL);
  RIRegister_TSockWebRequestHandler(CL);
end;

 
 
{ TPSImport_SockHTTP }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SockHTTP.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SockHTTP(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SockHTTP.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SockHTTP(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
