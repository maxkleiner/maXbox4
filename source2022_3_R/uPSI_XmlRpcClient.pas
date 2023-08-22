unit uPSI_XmlRpcClient;
{
 from immo walche my good fellow

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
  TPSImport_XmlRpcClient = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRpcCaller(CL: TPSPascalCompiler);
procedure SIRegister_TRpcClientParser(CL: TPSPascalCompiler);
procedure SIRegister_XmlRpcClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TRpcCaller(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcClientParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_XmlRpcClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,XmlRpcTypes
  ,XmlRpcCommon
  ,IdHTTP
  ,IdSSLOpenSSL
  ,IdHashMessageDigest
  ,IdHash
  ,LibXmlParser
  ,XmlRpcClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XmlRpcClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcCaller(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRpcClientParser', 'TRpcCaller') do
  with CL.AddClassN(CL.FindClass('TRpcClientParser'),'TRpcCaller') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('EndPoint', 'string', iptrw);
    RegisterProperty('HostName', 'string', iptrw);
    RegisterProperty('HostPort', 'Integer', iptrw);
    RegisterProperty('ProxyName', 'string', iptrw);
    RegisterProperty('ProxyPort', 'Integer', iptrw);
    RegisterProperty('ProxyUserName', 'string', iptrw);
    RegisterProperty('ProxyPassword', 'string', iptrw);
    RegisterProperty('ProxyBasicAuth', 'Boolean', iptrw);
    RegisterProperty('SSLEnable', 'Boolean', iptrw);
    RegisterProperty('SSLRootCertFile', 'string', iptrw);
    RegisterProperty('SSLCertFile', 'string', iptrw);
    RegisterProperty('SSLKeyFile', 'string', iptrw);
    RegisterMethod('Function Execute( RpcFunction : IRpcFunction; Ttl : Integer) : IRpcResult;');
    RegisterMethod('Function Execute1( const XmlRequest : string) : IRpcResult;');
    RegisterMethod('Function Execute2( Value : IRpcFunction) : IRpcResult;');
    RegisterMethod('Procedure DeleteOldCache( Ttl : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcClientParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRpcClientParser') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRpcClientParser') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Parse( Data : string)');
    RegisterMethod('Procedure StartTag');
    RegisterMethod('Procedure EndTag');
    RegisterMethod('Procedure DataTag');
    RegisterProperty('FixEmptyStrings', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XmlRpcClient(CL: TPSPascalCompiler);
begin
  SIRegister_TRpcClientParser(CL);
  SIRegister_TRpcCaller(CL);
 CL.AddConstantN('ERROR_EMPTY_RESULT','LongInt').SetInt( 600);
 CL.AddConstantN('ERROR_EMPTY_RESULT_MESSAGE','String').SetString( 'The xml-rpc server returned a empty response');
 CL.AddConstantN('ERROR_INVALID_RESPONSE','LongInt').SetInt( 601);
 CL.AddConstantN('ERROR_INVALID_RESPONSE_MESSAGE','String').SetString( 'Invalid payload received from xml-rpc server');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TRpcCallerExecute2_P(Self: TRpcCaller;  Value : IRpcFunction) : IRpcResult;
Begin Result := Self.Execute(Value); END;

(*----------------------------------------------------------------------------*)
Function TRpcCallerExecute1_P(Self: TRpcCaller;  const XmlRequest : string) : IRpcResult;
Begin Result := Self.Execute(XmlRequest); END;

(*----------------------------------------------------------------------------*)
Function TRpcCallerExecute_P(Self: TRpcCaller;  RpcFunction : IRpcFunction; Ttl : Integer) : IRpcResult;
Begin Result := Self.Execute(RpcFunction, Ttl); END;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerSSLKeyFile_W(Self: TRpcCaller; const T: string);
begin Self.SSLKeyFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerSSLKeyFile_R(Self: TRpcCaller; var T: string);
begin T := Self.SSLKeyFile; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerSSLCertFile_W(Self: TRpcCaller; const T: string);
begin Self.SSLCertFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerSSLCertFile_R(Self: TRpcCaller; var T: string);
begin T := Self.SSLCertFile; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerSSLRootCertFile_W(Self: TRpcCaller; const T: string);
begin Self.SSLRootCertFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerSSLRootCertFile_R(Self: TRpcCaller; var T: string);
begin T := Self.SSLRootCertFile; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerSSLEnable_W(Self: TRpcCaller; const T: Boolean);
begin Self.SSLEnable := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerSSLEnable_R(Self: TRpcCaller; var T: Boolean);
begin T := Self.SSLEnable; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerProxyBasicAuth_W(Self: TRpcCaller; const T: Boolean);
begin Self.ProxyBasicAuth := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerProxyBasicAuth_R(Self: TRpcCaller; var T: Boolean);
begin T := Self.ProxyBasicAuth; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerProxyPassword_W(Self: TRpcCaller; const T: string);
begin Self.ProxyPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerProxyPassword_R(Self: TRpcCaller; var T: string);
begin T := Self.ProxyPassword; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerProxyUserName_W(Self: TRpcCaller; const T: string);
begin Self.ProxyUserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerProxyUserName_R(Self: TRpcCaller; var T: string);
begin T := Self.ProxyUserName; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerProxyPort_W(Self: TRpcCaller; const T: Integer);
begin Self.ProxyPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerProxyPort_R(Self: TRpcCaller; var T: Integer);
begin T := Self.ProxyPort; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerProxyName_W(Self: TRpcCaller; const T: string);
begin Self.ProxyName := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerProxyName_R(Self: TRpcCaller; var T: string);
begin T := Self.ProxyName; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerHostPort_W(Self: TRpcCaller; const T: Integer);
begin Self.HostPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerHostPort_R(Self: TRpcCaller; var T: Integer);
begin T := Self.HostPort; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerHostName_W(Self: TRpcCaller; const T: string);
begin Self.HostName := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerHostName_R(Self: TRpcCaller; var T: string);
begin T := Self.HostName; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerEndPoint_W(Self: TRpcCaller; const T: string);
begin Self.EndPoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcCallerEndPoint_R(Self: TRpcCaller; var T: string);
begin T := Self.EndPoint; end;

(*----------------------------------------------------------------------------*)
procedure TRpcClientParserFixEmptyStrings_W(Self: TRpcClientParser; const T: Boolean);
begin Self.FixEmptyStrings := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcClientParserFixEmptyStrings_R(Self: TRpcClientParser; var T: Boolean);
begin T := Self.FixEmptyStrings; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcCaller(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcCaller) do
  begin
    RegisterConstructor(@TRpcCaller.Create, 'Create');
    RegisterPropertyHelper(@TRpcCallerEndPoint_R,@TRpcCallerEndPoint_W,'EndPoint');
    RegisterPropertyHelper(@TRpcCallerHostName_R,@TRpcCallerHostName_W,'HostName');
    RegisterPropertyHelper(@TRpcCallerHostPort_R,@TRpcCallerHostPort_W,'HostPort');
    RegisterPropertyHelper(@TRpcCallerProxyName_R,@TRpcCallerProxyName_W,'ProxyName');
    RegisterPropertyHelper(@TRpcCallerProxyPort_R,@TRpcCallerProxyPort_W,'ProxyPort');
    RegisterPropertyHelper(@TRpcCallerProxyUserName_R,@TRpcCallerProxyUserName_W,'ProxyUserName');
    RegisterPropertyHelper(@TRpcCallerProxyPassword_R,@TRpcCallerProxyPassword_W,'ProxyPassword');
    RegisterPropertyHelper(@TRpcCallerProxyBasicAuth_R,@TRpcCallerProxyBasicAuth_W,'ProxyBasicAuth');
    RegisterPropertyHelper(@TRpcCallerSSLEnable_R,@TRpcCallerSSLEnable_W,'SSLEnable');
    RegisterPropertyHelper(@TRpcCallerSSLRootCertFile_R,@TRpcCallerSSLRootCertFile_W,'SSLRootCertFile');
    RegisterPropertyHelper(@TRpcCallerSSLCertFile_R,@TRpcCallerSSLCertFile_W,'SSLCertFile');
    RegisterPropertyHelper(@TRpcCallerSSLKeyFile_R,@TRpcCallerSSLKeyFile_W,'SSLKeyFile');
    RegisterMethod(@TRpcCallerExecute_P, 'Execute');
    RegisterMethod(@TRpcCallerExecute1_P, 'Execute1');
    RegisterMethod(@TRpcCallerExecute2_P, 'Execute2');
    RegisterMethod(@TRpcCaller.DeleteOldCache, 'DeleteOldCache');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcClientParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcClientParser) do begin
    RegisterConstructor(@TRpcClientParser.Create, 'Create');
    RegisterMethod(@TRpcClientParser.Destroy, 'Free');
    RegisterMethod(@TRpcClientParser.Parse, 'Parse');
    RegisterMethod(@TRpcClientParser.StartTag, 'StartTag');
    RegisterMethod(@TRpcClientParser.EndTag, 'EndTag');
    RegisterMethod(@TRpcClientParser.DataTag, 'DataTag');
    RegisterPropertyHelper(@TRpcClientParserFixEmptyStrings_R,@TRpcClientParserFixEmptyStrings_W,'FixEmptyStrings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XmlRpcClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRpcClientParser(CL);
  RIRegister_TRpcCaller(CL);
end;

 
 
{ TPSImport_XmlRpcClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlRpcClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XmlRpcClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlRpcClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XmlRpcClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
