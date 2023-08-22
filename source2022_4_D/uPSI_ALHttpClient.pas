unit uPSI_ALHttpClient;
{
   to back to indy - post fix       post fix2    put + delete
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
  TPSImport_ALHttpClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TALHTTPClient(CL: TPSPascalCompiler);
procedure SIRegister_TALHTTPClientProxyParams(CL: TPSPascalCompiler);
procedure SIRegister_EALHTTPClientException(CL: TPSPascalCompiler);
procedure SIRegister_ALHttpClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALHTTPClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALHTTPClientProxyParams(CL: TPSRuntimeClassImporter);
procedure RIRegister_EALHTTPClientException(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALHttpClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ALHttpCommon
  ,ALStringList
  ,ALMultiPartFormDataParser
  ,ALHttpClient
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALHttpClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHTTPClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALHTTPClient') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALHTTPClient') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Execute( aRequestDataStream : TStream; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader)');
    RegisterMethod('Procedure Get( const aUrl : AnsiString; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);');
    RegisterMethod('Procedure Post( const aUrl : AnsiString; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);');
    RegisterMethod('Procedure Post1( const aUrl : AnsiString; aPostDataStream : TStream; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);');
    RegisterMethod('Procedure PostUrlEncoded1( const aUrl : AnsiString; aPostDataStrings : TALStrings; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader; const EncodeParams : Boolean);');
    RegisterMethod('Procedure PostMultipartFormData1( const aUrl: AnsiString; aPostDataStrings: TALStrings; aPostDataFiles: TALMultiPartFormDataContents; aResponseContentStream: TStream; aResponseContentHeader: TALHTTPResponseHeader);');
    RegisterMethod('Procedure Head1( const aUrl : AnsiString; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);');
    RegisterMethod('Procedure Trace1( const aUrl : AnsiString; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);');
    RegisterMethod('Procedure Put1 const aUrl : AnsiString; aPutDataStream : TStream; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);');
    RegisterMethod('Procedure Delete1( const aUrl : AnsiString; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);');
    RegisterMethod('Function Get1( const aUrl : AnsiString) : AnsiString;');
    RegisterMethod('Function Get2( const aUrl : AnsiString; aParams : TALStrings; const EncodeParams : Boolean) : AnsiString;');
    RegisterMethod('Procedure Get3( const aUrl : AnsiString; aParams : TALStrings; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader; const EncodeParams : Boolean);');
    RegisterMethod('Function Post2( const aUrl : AnsiString) : AnsiString;');
    RegisterMethod('Function Post3( const aUrl : AnsiString; aPostDataStream : TStream) : AnsiString;');
    RegisterMethod('Function PostUrlEncoded( const aUrl : AnsiString; aPostDataStrings : TALStrings; const EncodeParams : Boolean) : AnsiString;');
    RegisterMethod('Function PostMultiPartFormData( const aUrl : AnsiString; aPostDataStrings : TALStrings; aPostDataFiles : TALMultiPartFormDataContents) : AnsiString;');
    RegisterMethod('Function Head( const aUrl : AnsiString) : AnsiString;');
    RegisterMethod('Function trace( const aUrl : AnsiString) : AnsiString;');
    RegisterMethod('Function Put( const aURL : Ansistring; aPutDataStream : TStream) : AnsiString;');
    RegisterMethod('Function Delete( const aURL : Ansistring) : AnsiString;');
    RegisterProperty('URL', 'AnsiString', iptrw);
    RegisterProperty('ConnectTimeout', 'Integer', iptrw);
    RegisterProperty('SendTimeout', 'Integer', iptrw);
    RegisterProperty('ReceiveTimeout', 'Integer', iptrw);
    RegisterProperty('UploadBufferSize', 'Integer', iptrw);
    RegisterProperty('ProxyParams', 'TALHTTPClientProxyParams', iptr);
    RegisterProperty('RequestHeader', 'TALHTTPRequestHeader', iptr);
    RegisterProperty('ProtocolVersion', 'TALHTTPProtocolVersion', iptrw);
    RegisterProperty('RequestMethod', 'TALHTTPMethod', iptrw);
    RegisterProperty('UserName', 'AnsiString', iptrw);
    RegisterProperty('Password', 'AnsiString', iptrw);
    RegisterProperty('OnUploadProgress', 'TALHTTPClientUploadProgressEvent', iptrw);
    RegisterProperty('OnDownloadProgress', 'TALHTTPClientDownloadProgressEvent', iptrw);
    RegisterProperty('OnRedirect', 'TAlHTTPClientRedirectEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHTTPClientProxyParams(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TALHTTPClientProxyParams') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TALHTTPClientProxyParams') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
    RegisterProperty('ProxyBypass', 'AnsiString', iptrw);
    RegisterProperty('ProxyServer', 'AnsiString', iptrw);
    RegisterProperty('ProxyPort', 'integer', iptrw);
    RegisterProperty('ProxyUserName', 'AnsiString', iptrw);
    RegisterProperty('ProxyPassword', 'AnsiString', iptrw);
    RegisterProperty('OnChange', 'TALHTTPPropertyChangeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EALHTTPClientException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EALHTTPClientException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EALHTTPClientException') do begin
    RegisterMethod('Constructor Create( const Msg : AnsiString; SCode : Integer)');
    RegisterMethod('Constructor CreateFmt( const Msg : AnsiString; const Args : array of const; SCode : Integer)');
    RegisterProperty('StatusCode', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALHttpClient(CL: TPSPascalCompiler);
begin
  SIRegister_EALHTTPClientException(CL);
  SIRegister_TALHTTPClientProxyParams(CL);
  CL.AddTypeS('TAlHTTPClientRedirectEvent', 'Procedure ( sender : Tobject; const NewURL : AnsiString)');
  CL.AddTypeS('TALHTTPClientUploadProgressEvent', 'Procedure (sender : Tobject; Sent : Integer; Total : Integer)');
  CL.AddTypeS('TALHTTPClientDownloadProgressEvent', 'Procedure (sender : Tobject; Read : Integer; Total : Integer)');
  SIRegister_TALHTTPClient(CL);
 CL.AddConstantN('cALHTTPCLient_MsgInvalidURL','String').SetString( 'Invalid url ''%s'' - only supports ''http'' and ''https'' schemes');
 CL.AddConstantN('cALHTTPCLient_MsgInvalidHTTPRequest','String').SetString( 'Invalid HTTP Request: Length is 0');
 CL.AddConstantN('cALHTTPCLient_MsgEmptyURL','String').SetString( 'Empty URL');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnRedirect_W(Self: TALHTTPClient; const T: TAlHTTPClientRedirectEvent);
begin Self.OnRedirect := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnRedirect_R(Self: TALHTTPClient; var T: TAlHTTPClientRedirectEvent);
begin T := Self.OnRedirect; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnDownloadProgress_W(Self: TALHTTPClient; const T: TALHTTPClientDownloadProgressEvent);
begin Self.OnDownloadProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnDownloadProgress_R(Self: TALHTTPClient; var T: TALHTTPClientDownloadProgressEvent);
begin T := Self.OnDownloadProgress; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnUploadProgress_W(Self: TALHTTPClient; const T: TALHTTPClientUploadProgressEvent);
begin Self.OnUploadProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnUploadProgress_R(Self: TALHTTPClient; var T: TALHTTPClientUploadProgressEvent);
begin T := Self.OnUploadProgress; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientPassword_W(Self: TALHTTPClient; const T: AnsiString);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientPassword_R(Self: TALHTTPClient; var T: AnsiString);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientUserName_W(Self: TALHTTPClient; const T: AnsiString);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientUserName_R(Self: TALHTTPClient; var T: AnsiString);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientRequestMethod_W(Self: TALHTTPClient; const T: TALHTTPMethod);
begin Self.RequestMethod := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientRequestMethod_R(Self: TALHTTPClient; var T: TALHTTPMethod);
begin T := Self.RequestMethod; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProtocolVersion_W(Self: TALHTTPClient; const T: TALHTTPProtocolVersion);
begin Self.ProtocolVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProtocolVersion_R(Self: TALHTTPClient; var T: TALHTTPProtocolVersion);
begin T := Self.ProtocolVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientRequestHeader_R(Self: TALHTTPClient; var T: TALHTTPRequestHeader);
begin T := Self.RequestHeader; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParams_R(Self: TALHTTPClient; var T: TALHTTPClientProxyParams);
begin T := Self.ProxyParams; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientUploadBufferSize_W(Self: TALHTTPClient; const T: Integer);
begin Self.UploadBufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientUploadBufferSize_R(Self: TALHTTPClient; var T: Integer);
begin T := Self.UploadBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientReceiveTimeout_W(Self: TALHTTPClient; const T: Integer);
begin Self.ReceiveTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientReceiveTimeout_R(Self: TALHTTPClient; var T: Integer);
begin T := Self.ReceiveTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientSendTimeout_W(Self: TALHTTPClient; const T: Integer);
begin Self.SendTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientSendTimeout_R(Self: TALHTTPClient; var T: Integer);
begin T := Self.SendTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientConnectTimeout_W(Self: TALHTTPClient; const T: Integer);
begin Self.ConnectTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientConnectTimeout_R(Self: TALHTTPClient; var T: Integer);
begin T := Self.ConnectTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientURL_W(Self: TALHTTPClient; const T: AnsiString);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientURL_R(Self: TALHTTPClient; var T: AnsiString);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientDelete_P(Self: TALHTTPClient;  const aURL : Ansistring) : AnsiString;
Begin Result := Self.Delete(aURL); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientPut_P(Self: TALHTTPClient;  const aURL : Ansistring; aPutDataStream : TStream) : AnsiString;
Begin Result := Self.Put(aURL, aPutDataStream); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClienttrace_P(Self: TALHTTPClient;  const aUrl : AnsiString) : AnsiString;
Begin Result := Self.trace(aUrl); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientHead_P(Self: TALHTTPClient;  const aUrl : AnsiString) : AnsiString;
Begin Result := Self.Head(aUrl); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientPostMultiPartFormData_P(Self: TALHTTPClient;  const aUrl : AnsiString; aPostDataStrings : TALStrings; aPostDataFiles : TALMultiPartFormDataContents) : AnsiString;
Begin Result := Self.PostMultiPartFormData(aUrl, aPostDataStrings, aPostDataFiles); END;

Function TALHTTPClientPostMultiPartFormData_P1(Self: TALHTTPClient; const aUrl:AnsiString; aPostDataStrings:TALStrings; aPostDataFiles:TALMultiPartFormDataContents; aResponseContentStream: TStream; aResponseContentHeader: TALHTTPResponseHeader): AnsiString;
Begin Self.PostMultiPartFormData(aUrl,aPostDataStrings,aPostDataFiles,
                                                                 aResponseContentStream,aResponseContentHeader);
END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientPostUrlEncoded_P(Self: TALHTTPClient;  const aUrl : AnsiString; aPostDataStrings : TALStrings; const EncodeParams : Boolean) : AnsiString;
Begin Result := Self.PostUrlEncoded(aUrl, aPostDataStrings, EncodeParams); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientPost1_P(Self: TALHTTPClient;  const aUrl : AnsiString; aPostDataStream : TStream) : AnsiString;
Begin Result := Self.Post(aUrl, aPostDataStream); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientPost_P(Self: TALHTTPClient;  const aUrl : AnsiString) : AnsiString;
Begin Result := Self.Post(aUrl); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientGet3_P(Self: TALHTTPClient;  const aUrl : AnsiString; aParams : TALStrings; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader; const EncodeParams : Boolean);
Begin Self.Get(aUrl, aParams, aResponseContentStream, aResponseContentHeader, EncodeParams); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientGet2_P(Self: TALHTTPClient;  const aUrl : AnsiString; aParams : TALStrings; const EncodeParams : Boolean) : AnsiString;
Begin Result := Self.Get(aUrl, aParams, EncodeParams); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientGet1_P(Self: TALHTTPClient;  const aUrl : AnsiString) : AnsiString;
Begin Result := Self.Get(aUrl); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientDelete(Self: TALHTTPClient;  const aUrl : AnsiString; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);
Begin Self.Delete(aUrl, aResponseContentStream, aResponseContentHeader); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientPut(Self: TALHTTPClient;  const aUrl : AnsiString; aPutDataStream : TStream; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);
Begin Self.Put(aUrl, aPutDataStream, aResponseContentStream, aResponseContentHeader); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientTrace(Self: TALHTTPClient;  const aUrl : AnsiString; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);
Begin Self.Trace(aUrl, aResponseContentStream, aResponseContentHeader); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientHead(Self: TALHTTPClient;  const aUrl : AnsiString; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);
Begin Self.Head(aUrl, aResponseContentStream, aResponseContentHeader); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientPostMultipartFormData(Self: TALHTTPClient;  const aUrl : AnsiString; aPostDataStrings : TALStrings; aPostDataFiles : TALMultiPartFormDataContents; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);
Begin Self.PostMultipartFormData(aUrl, aPostDataStrings, aPostDataFiles, aResponseContentStream, aResponseContentHeader); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientPostUrlEncoded(Self: TALHTTPClient;  const aUrl : AnsiString; aPostDataStrings : TALStrings; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader; const EncodeParams : Boolean);
Begin Self.PostUrlEncoded(aUrl, aPostDataStrings, aResponseContentStream, aResponseContentHeader, EncodeParams); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientPost1(Self: TALHTTPClient;  const aUrl : AnsiString; aPostDataStream : TStream; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);
Begin Self.Post(aUrl, aPostDataStream, aResponseContentStream, aResponseContentHeader); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientPost(Self: TALHTTPClient;  const aUrl : AnsiString; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);
Begin Self.Post(aUrl, aResponseContentStream, aResponseContentHeader); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientGet_P(Self: TALHTTPClient;  const aUrl : AnsiString; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader);
Begin Self.Get(aUrl, aResponseContentStream, aResponseContentHeader); END;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsOnChange_W(Self: TALHTTPClientProxyParams; const T: TALHTTPPropertyChangeEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsOnChange_R(Self: TALHTTPClientProxyParams; var T: TALHTTPPropertyChangeEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyPassword_W(Self: TALHTTPClientProxyParams; const T: AnsiString);
begin Self.ProxyPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyPassword_R(Self: TALHTTPClientProxyParams; var T: AnsiString);
begin T := Self.ProxyPassword; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyUserName_W(Self: TALHTTPClientProxyParams; const T: AnsiString);
begin Self.ProxyUserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyUserName_R(Self: TALHTTPClientProxyParams; var T: AnsiString);
begin T := Self.ProxyUserName; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyPort_W(Self: TALHTTPClientProxyParams; const T: integer);
begin Self.ProxyPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyPort_R(Self: TALHTTPClientProxyParams; var T: integer);
begin T := Self.ProxyPort; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyServer_W(Self: TALHTTPClientProxyParams; const T: AnsiString);
begin Self.ProxyServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyServer_R(Self: TALHTTPClientProxyParams; var T: AnsiString);
begin T := Self.ProxyServer; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyBypass_W(Self: TALHTTPClientProxyParams; const T: AnsiString);
begin Self.ProxyBypass := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyBypass_R(Self: TALHTTPClientProxyParams; var T: AnsiString);
begin T := Self.ProxyBypass; end;

(*----------------------------------------------------------------------------*)
procedure EALHTTPClientExceptionStatusCode_W(Self: EALHTTPClientException; const T: Integer);
begin Self.StatusCode := T; end;

(*----------------------------------------------------------------------------*)
procedure EALHTTPClientExceptionStatusCode_R(Self: EALHTTPClientException; var T: Integer);
begin T := Self.StatusCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHTTPClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPClient) do begin
    RegisterConstructor(@TALHTTPClient.Create, 'Create');
    RegisterMethod(@TALHTTPClient.Execute, 'Execute');
    RegisterMethod(@TALHTTPClient.Destroy, 'Free');
    RegisterMethod(@TALHTTPClientGet_P, 'Get');
    RegisterMethod(@TALHTTPClientPost, 'Post');
    RegisterMethod(@TALHTTPClientPost1, 'Post1');
    RegisterMethod(@TALHTTPClientPostUrlEncoded, 'PostUrlEncoded1');
    RegisterMethod(@TALHTTPClientPostMultipartFormData_P1, 'PostMultipartFormData1');
    RegisterMethod(@TALHTTPClientHead_P, 'Head');
    RegisterMethod(@TALHTTPClientTrace_P, 'Trace');
    RegisterMethod(@TALHTTPClientPut_P, 'Put');
    RegisterMethod(@TALHTTPClientDelete_P, 'Delete');
    RegisterMethod(@TALHTTPClientGet1_P, 'Get1');
    RegisterMethod(@TALHTTPClientGet2_P, 'Get2');
    RegisterMethod(@TALHTTPClientGet3_P, 'Get3');
    RegisterMethod(@TALHTTPClientPost_P, 'Post2');
    RegisterMethod(@TALHTTPClientPost1_P, 'Post3');
    RegisterMethod(@TALHTTPClientPostUrlEncoded_P, 'PostUrlEncoded');
    RegisterMethod(@TALHTTPClientPostMultiPartFormData_P, 'PostMultiPartFormData');
    RegisterMethod(@TALHTTPClientHead, 'Head1');
    RegisterMethod(@TALHTTPClienttrace, 'trace1');
    RegisterMethod(@TALHTTPClientPut, 'Put1');
    RegisterMethod(@TALHTTPClientDelete, 'Delete1');
    RegisterPropertyHelper(@TALHTTPClientURL_R,@TALHTTPClientURL_W,'URL');
    RegisterPropertyHelper(@TALHTTPClientConnectTimeout_R,@TALHTTPClientConnectTimeout_W,'ConnectTimeout');
    RegisterPropertyHelper(@TALHTTPClientSendTimeout_R,@TALHTTPClientSendTimeout_W,'SendTimeout');
    RegisterPropertyHelper(@TALHTTPClientReceiveTimeout_R,@TALHTTPClientReceiveTimeout_W,'ReceiveTimeout');
    RegisterPropertyHelper(@TALHTTPClientUploadBufferSize_R,@TALHTTPClientUploadBufferSize_W,'UploadBufferSize');
    RegisterPropertyHelper(@TALHTTPClientProxyParams_R,nil,'ProxyParams');
    RegisterPropertyHelper(@TALHTTPClientRequestHeader_R,nil,'RequestHeader');
    RegisterPropertyHelper(@TALHTTPClientProtocolVersion_R,@TALHTTPClientProtocolVersion_W,'ProtocolVersion');
    RegisterPropertyHelper(@TALHTTPClientRequestMethod_R,@TALHTTPClientRequestMethod_W,'RequestMethod');
    RegisterPropertyHelper(@TALHTTPClientUserName_R,@TALHTTPClientUserName_W,'UserName');
    RegisterPropertyHelper(@TALHTTPClientPassword_R,@TALHTTPClientPassword_W,'Password');
    RegisterPropertyHelper(@TALHTTPClientOnUploadProgress_R,@TALHTTPClientOnUploadProgress_W,'OnUploadProgress');
    RegisterPropertyHelper(@TALHTTPClientOnDownloadProgress_R,@TALHTTPClientOnDownloadProgress_W,'OnDownloadProgress');
    RegisterPropertyHelper(@TALHTTPClientOnRedirect_R,@TALHTTPClientOnRedirect_W,'OnRedirect');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHTTPClientProxyParams(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPClientProxyParams) do
  begin
    //RegisterVirtualConstructor(@TALHTTPClientProxyParams.Create, 'Create');
     RegisterConstructor(@TALHTTPClientProxyParams.Create, 'Create');
    RegisterMethod(@TALHTTPClientProxyParams.Clear, 'Clear');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsProxyBypass_R,@TALHTTPClientProxyParamsProxyBypass_W,'ProxyBypass');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsProxyServer_R,@TALHTTPClientProxyParamsProxyServer_W,'ProxyServer');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsProxyPort_R,@TALHTTPClientProxyParamsProxyPort_W,'ProxyPort');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsProxyUserName_R,@TALHTTPClientProxyParamsProxyUserName_W,'ProxyUserName');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsProxyPassword_R,@TALHTTPClientProxyParamsProxyPassword_W,'ProxyPassword');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsOnChange_R,@TALHTTPClientProxyParamsOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EALHTTPClientException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EALHTTPClientException) do
  begin
    RegisterConstructor(@EALHTTPClientException.Create, 'Create');
    RegisterConstructor(@EALHTTPClientException.CreateFmt, 'CreateFmt');
    RegisterPropertyHelper(@EALHTTPClientExceptionStatusCode_R,@EALHTTPClientExceptionStatusCode_W,'StatusCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALHttpClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EALHTTPClientException(CL);
  RIRegister_TALHTTPClientProxyParams(CL);
  RIRegister_TALHTTPClient(CL);
end;

 
 
{ TPSImport_ALHttpClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALHttpClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALHttpClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALHttpClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALHttpClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
