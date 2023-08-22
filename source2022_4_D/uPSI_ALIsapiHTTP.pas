unit uPSI_ALIsapiHTTP;
{
just for the sake to CGI AlFcnCGI

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
  TPSImport_ALIsapiHTTP = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALISAPIResponse(CL: TPSPascalCompiler);
procedure SIRegister_TALWebResponse(CL: TPSPascalCompiler);
procedure SIRegister_TALISAPIRequest(CL: TPSPascalCompiler);
procedure SIRegister_TALWebRequest(CL: TPSPascalCompiler);
procedure SIRegister_ALIsapiHTTP(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALIsapiHTTP_Routines(S: TPSExec);
procedure RIRegister_TALISAPIResponse(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALWebResponse(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALISAPIRequest(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALWebRequest(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALIsapiHTTP(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Types
  ,Isapi2
  //,ALMultiPartParser
  ,ALHttpClient
  ,ALStringList
  //,ALString
  ,ALIsapiHTTP
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALIsapiHTTP]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALISAPIResponse(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALWebResponse', 'TALISAPIResponse') do
  with CL.AddClassN(CL.FindClass('TALWebResponse'),'TALISAPIResponse') do
  begin
    RegisterMethod('Constructor Create( HTTPRequest : TALWebRequest)');
    RegisterMethod('Procedure SendResponse');
    RegisterMethod('Procedure SendRedirect( const URI : AnsiString)');
    RegisterMethod('Procedure SendStream( AStream : TStream)');
    RegisterMethod('Function Sent : Boolean');
    RegisterProperty('SentInAsync', 'Boolean', iptr);
    RegisterProperty('TransmitFileInfo', 'PHSE_TF_INFO', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALWebResponse(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALWebResponse') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALWebResponse') do
  begin
    RegisterMethod('Constructor Create( HTTPRequest : TALWebRequest)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Function GetCustomHeader( const Name : AnsiString) : AnsiString');
    RegisterMethod('Procedure SendResponse');
    RegisterMethod('Procedure SendRedirect( const URI : AnsiString)');
    RegisterMethod('Procedure SendStream( AStream : TStream)');
    RegisterMethod('Function Sent : Boolean');
    RegisterMethod('Procedure SetCookieField( Values : TALStrings; const ADomain, APath : AnsiString; AExpires : TDateTime; ASecure : Boolean; const AHttpOnly : Boolean)');
    RegisterMethod('Procedure SetCustomHeader( const Name, Value : AnsiString)');
    RegisterProperty('Cookies', 'TALHttpCookieCollection', iptr);
    RegisterProperty('HTTPRequest', 'TALWebRequest', iptr);
    RegisterProperty('ProtocolVersion', 'AnsiString', iptrw);
    RegisterProperty('ReasonString', 'AnsiString', iptrw);
    RegisterProperty('Server', 'AnsiString', iptrw);
    RegisterProperty('WWWAuthenticate', 'AnsiString', iptrw);
    RegisterProperty('Realm', 'AnsiString', iptrw);
    RegisterProperty('Allow', 'AnsiString', iptrw);
    RegisterProperty('Location', 'AnsiString', iptrw);
    RegisterProperty('ContentEncoding', 'AnsiString', iptrw);
    RegisterProperty('ContentType', 'AnsiString', iptrw);
    RegisterProperty('ContentVersion', 'AnsiString', iptrw);
    RegisterProperty('DerivedFrom', 'AnsiString', iptrw);
    RegisterProperty('Title', 'AnsiString', iptrw);
    RegisterProperty('StatusCode', 'Integer', iptrw);
    RegisterProperty('Date', 'TDateTime', iptrw);
    RegisterProperty('Expires', 'TDateTime', iptrw);
    RegisterProperty('LastModified', 'TDateTime', iptrw);
    RegisterProperty('Content', 'AnsiString', iptrw);
    RegisterProperty('ContentStream', 'TStream', iptrw);
    RegisterProperty('LogMessage', 'AnsiString', iptrw);
    RegisterProperty('CustomHeaders', 'TALStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALISAPIRequest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALWebRequest', 'TALISAPIRequest') do
  with CL.AddClassN(CL.FindClass('TALWebRequest'),'TALISAPIRequest') do begin
    RegisterMethod('Constructor Create( AECB : PEXTENSION_CONTROL_BLOCK)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure closeConnection');
    RegisterMethod('Procedure ReadClientToStream( const aStream : TStream)');
    RegisterMethod('Function GetFieldByName( const Name : AnsiString) : AnsiString');
    RegisterMethod('Function ReadClient( var Buffer, Count : Integer) : Integer');
    RegisterMethod('Function ReadString( Count : Integer) : AnsiString');
    RegisterMethod('Function TranslateURI( const URI : AnsiString) : AnsiString');
    RegisterMethod('Function WriteClient( var Buffer, Count : Integer) : Integer');
    RegisterMethod('Function WriteString( const AString : AnsiString) : Boolean');
    RegisterMethod('Function WriteHeaders( StatusCode : Integer; const StatusString, Headers : AnsiString) : Boolean');
    RegisterProperty('ECB', 'PEXTENSION_CONTROL_BLOCK', iptr);
    RegisterProperty('ConnectionClosed', 'boolean', iptr);
    RegisterProperty('ClientDataExhausted', 'boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALWebRequest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALWebRequest') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALWebRequest') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure ExtractCookieFields( Fields : TALStrings)');
    RegisterMethod('Procedure ExtractQueryFields( Fields : TALStrings)');
    RegisterMethod('Procedure ExtractUrlEncodedContentFields( Fields : TALStrings)');
    RegisterMethod('Procedure ExtractMultipartFormDataFields( Fields : TALStrings; Files : TALMultiPartFormDataContents)');
    RegisterMethod('Function ReadClient( var Buffer, Count : Integer) : Integer');
    RegisterMethod('Function ReadString( Count : Integer) : AnsiString');
    RegisterMethod('Function TranslateURI( const URI : AnsiString) : AnsiString');
    RegisterMethod('Function WriteClient( var Buffer, Count : Integer) : Integer');
    RegisterMethod('Function WriteString( const AString : AnsiString) : Boolean');
    RegisterMethod('Function WriteHeaders( StatusCode : Integer; const ReasonString, Headers : AnsiString) : Boolean');
    //RegisterMethod('Function GetFieldByName( const Name : AnsiString) : AnsiString');
    RegisterProperty('MethodType', 'TALHTTPMethod', iptr);
    RegisterProperty('Method', 'AnsiString', iptr);
    RegisterProperty('ProtocolVersion', 'AnsiString', iptr);
    RegisterProperty('URL', 'AnsiString', iptr);
    RegisterProperty('Query', 'AnsiString', iptr);
    RegisterProperty('PathInfo', 'AnsiString', iptr);
    RegisterProperty('PathTranslated', 'AnsiString', iptr);
    RegisterProperty('Authorization', 'AnsiString', iptr);
    RegisterProperty('CacheControl', 'AnsiString', iptr);
    RegisterProperty('Cookie', 'AnsiString', iptr);
    RegisterProperty('Date', 'TDateTime', iptr);
    RegisterProperty('Accept', 'AnsiString', iptr);
    RegisterProperty('From', 'AnsiString', iptr);
    RegisterProperty('Host', 'AnsiString', iptr);
    RegisterProperty('IfModifiedSince', 'TDateTime', iptr);
    RegisterProperty('Referer', 'AnsiString', iptr);
    RegisterProperty('UserAgent', 'AnsiString', iptr);
    RegisterProperty('ContentEncoding', 'AnsiString', iptr);
    RegisterProperty('ContentType', 'AnsiString', iptr);
    RegisterProperty('ContentLength', 'Integer', iptr);
    RegisterProperty('ContentVersion', 'AnsiString', iptr);
    RegisterProperty('Content', 'AnsiString', iptr);
    RegisterProperty('ContentStream', 'TALStringStream', iptr);
    RegisterProperty('MaxContentSize', 'Integer', iptrw);
    RegisterProperty('Connection', 'AnsiString', iptr);
    RegisterProperty('DerivedFrom', 'AnsiString', iptr);
    RegisterProperty('Expires', 'TDateTime', iptr);
    RegisterProperty('Title', 'AnsiString', iptr);
    RegisterProperty('RemoteAddr', 'AnsiString', iptr);
    RegisterProperty('RemoteHost', 'AnsiString', iptr);
    RegisterProperty('ScriptName', 'AnsiString', iptr);
    RegisterProperty('ServerPort', 'Integer', iptr);
    RegisterProperty('BytesRange', 'TInt64DynArray', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALIsapiHTTP(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALIsapiRequestContentSizeTooBig');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALIsapiRequestConnectionDropped');
  SIRegister_TALWebRequest(CL);
  SIRegister_TALISAPIRequest(CL);
  SIRegister_TALWebResponse(CL);
  SIRegister_TALISAPIResponse(CL);
 CL.AddDelphiFunction('Function ALIsapiHttpStatusString( StatusCode : Integer) : AnsiString');
 CL.AddConstantN('HSE_IO_SYNC','LongWord').SetUInt( $00000001);
 CL.AddConstantN('HSE_IO_ASYNC','LongWord').SetUInt( $00000002);
 CL.AddConstantN('HSE_IO_DISCONNECT_AFTER_SEND','LongWord').SetUInt( $00000004);
 CL.AddConstantN('HSE_IO_SEND_HEADERS','LongWord').SetUInt( $00000008);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALISAPIResponseTransmitFileInfo_R(Self: TALISAPIResponse; var T: PHSE_TF_INFO);
begin //T := Self.TransmitFileInfo;
end;

(*----------------------------------------------------------------------------*)
procedure TALISAPIResponseSentInAsync_R(Self: TALISAPIResponse; var T: Boolean);
begin //T := //Self.SentInAsync;
end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseCustomHeaders_W(Self: TALWebResponse; const T: TALStrings);
begin Self.CustomHeaders := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseCustomHeaders_R(Self: TALWebResponse; var T: TALStrings);
begin T := Self.CustomHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseLogMessage_W(Self: TALWebResponse; const T: AnsiString);
begin Self.LogMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseLogMessage_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.LogMessage; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseContentStream_W(Self: TALWebResponse; const T: TStream);
begin Self.ContentStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseContentStream_R(Self: TALWebResponse; var T: TStream);
begin T := Self.ContentStream; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseContent_W(Self: TALWebResponse; const T: AnsiString);
begin Self.Content := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseContent_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.Content; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseLastModified_W(Self: TALWebResponse; const T: TDateTime);
begin Self.LastModified := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseLastModified_R(Self: TALWebResponse; var T: TDateTime);
begin T := Self.LastModified; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseExpires_W(Self: TALWebResponse; const T: TDateTime);
begin Self.Expires := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseExpires_R(Self: TALWebResponse; var T: TDateTime);
begin T := Self.Expires; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseDate_W(Self: TALWebResponse; const T: TDateTime);
begin Self.Date := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseDate_R(Self: TALWebResponse; var T: TDateTime);
begin T := Self.Date; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseStatusCode_W(Self: TALWebResponse; const T: Integer);
begin Self.StatusCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseStatusCode_R(Self: TALWebResponse; var T: Integer);
begin T := Self.StatusCode; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseTitle_W(Self: TALWebResponse; const T: AnsiString);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseTitle_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseDerivedFrom_W(Self: TALWebResponse; const T: AnsiString);
begin Self.DerivedFrom := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseDerivedFrom_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.DerivedFrom; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseContentVersion_W(Self: TALWebResponse; const T: AnsiString);
begin Self.ContentVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseContentVersion_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.ContentVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseContentType_W(Self: TALWebResponse; const T: AnsiString);
begin Self.ContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseContentType_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseContentEncoding_W(Self: TALWebResponse; const T: AnsiString);
begin Self.ContentEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseContentEncoding_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.ContentEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseLocation_W(Self: TALWebResponse; const T: AnsiString);
begin Self.Location := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseLocation_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.Location; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseAllow_W(Self: TALWebResponse; const T: AnsiString);
begin Self.Allow := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseAllow_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.Allow; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseRealm_W(Self: TALWebResponse; const T: AnsiString);
begin Self.Realm := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseRealm_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.Realm; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseWWWAuthenticate_W(Self: TALWebResponse; const T: AnsiString);
begin Self.WWWAuthenticate := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseWWWAuthenticate_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.WWWAuthenticate; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseServer_W(Self: TALWebResponse; const T: AnsiString);
begin Self.Server := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseServer_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseReasonString_W(Self: TALWebResponse; const T: AnsiString);
begin Self.ReasonString := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseReasonString_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.ReasonString; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseProtocolVersion_W(Self: TALWebResponse; const T: AnsiString);
begin Self.ProtocolVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseProtocolVersion_R(Self: TALWebResponse; var T: AnsiString);
begin T := Self.ProtocolVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALWebResponseHTTPRequest_R(Self: TALWebResponse; var T: TALWebRequest);
begin T := Self.HTTPRequest; end;

(*----------------------------------------------------------------------------*)
//procedure TALWebResponseCookies_R(Self: TALWebResponse; var T: TALHttpCookieCollection);
//begin T := Self.Cookies; end;

(*----------------------------------------------------------------------------*)
procedure TALISAPIRequestClientDataExhausted_R(Self: TALISAPIRequest; var T: boolean);
begin //T := Self.ClientDataExhausted;
end;

(*----------------------------------------------------------------------------*)
procedure TALISAPIRequestConnectionClosed_R(Self: TALISAPIRequest; var T: boolean);
begin //T := Self.ConnectionClosed;
end;

(*----------------------------------------------------------------------------*)
procedure TALISAPIRequestECB_R(Self: TALISAPIRequest; var T: PEXTENSION_CONTROL_BLOCK);
begin T := Self.ECB; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestBytesRange_R(Self: TALWebRequest; var T: TInt64DynArray);
begin //T := Self.BytesRange;
end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestServerPort_R(Self: TALWebRequest; var T: Integer);
begin T := Self.ServerPort; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestScriptName_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.ScriptName; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestRemoteHost_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.RemoteHost; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestRemoteAddr_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.RemoteAddr; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestTitle_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestExpires_R(Self: TALWebRequest; var T: TDateTime);
begin T := Self.Expires; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestDerivedFrom_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.DerivedFrom; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestConnection_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestMaxContentSize_W(Self: TALWebRequest; const T: Integer);
begin Self.MaxContentSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestMaxContentSize_R(Self: TALWebRequest; var T: Integer);
begin T := Self.MaxContentSize; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestContentStream_R(Self: TALWebRequest; var T: TStringStream);
begin //T := Self.ContentStream;
end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestContent_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.Content; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestContentVersion_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.ContentVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestContentLength_R(Self: TALWebRequest; var T: Integer);
begin T := Self.ContentLength; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestContentType_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestContentEncoding_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.ContentEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestUserAgent_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.UserAgent; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestReferer_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.Referer; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestIfModifiedSince_R(Self: TALWebRequest; var T: TDateTime);
begin T := Self.IfModifiedSince; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestHost_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestFrom_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.From; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestAccept_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.Accept; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestDate_R(Self: TALWebRequest; var T: TDateTime);
begin T := Self.Date; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestCookie_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.Cookie; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestCacheControl_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.CacheControl; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestAuthorization_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.Authorization; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestPathTranslated_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.PathTranslated; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestPathInfo_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.PathInfo; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestQuery_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.Query; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestURL_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestProtocolVersion_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.ProtocolVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALWebRequestMethod_R(Self: TALWebRequest; var T: AnsiString);
begin T := Self.Method; end;

(*----------------------------------------------------------------------------*)
//procedure TALWebRequestMethodType_R(Self: TALWebRequest; var T: TALHTTPMethod);
//begin T := Self.MethodType; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALIsapiHTTP_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ALIsapiHttpStatusString, 'ALIsapiHttpStatusString', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALISAPIResponse(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALISAPIResponse) do
  begin
    RegisterConstructor(@TALISAPIResponse.Create, 'Create');
    RegisterMethod(@TALISAPIResponse.SendResponse, 'SendResponse');
    RegisterMethod(@TALISAPIResponse.SendRedirect, 'SendRedirect');
    RegisterMethod(@TALISAPIResponse.SendStream, 'SendStream');
    RegisterMethod(@TALISAPIResponse.Sent, 'Sent');
    RegisterPropertyHelper(@TALISAPIResponseSentInAsync_R,nil,'SentInAsync');
    RegisterPropertyHelper(@TALISAPIResponseTransmitFileInfo_R,nil,'TransmitFileInfo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALWebResponse(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALWebResponse) do begin
    RegisterConstructor(@TALWebResponse.Create, 'Create');
    RegisterMethod(@TALWebResponse.Destroy, 'Free');
    RegisterMethod(@TALWebResponse.GetCustomHeader, 'GetCustomHeader');
    //RegisterVirtualAbstractMethod(@TALWebResponse, @!.SendResponse, 'SendResponse');
    //RegisterVirtualAbstractMethod(@TALWebResponse, @!.SendRedirect, 'SendRedirect');
    //RegisterVirtualAbstractMethod(@TALWebResponse, @!.SendStream, 'SendStream');
    RegisterVirtualMethod(@TALWebResponse.Sent, 'Sent');
    RegisterMethod(@TALWebResponse.SetCookieField, 'SetCookieField');
    RegisterMethod(@TALWebResponse.SetCustomHeader, 'SetCustomHeader');
    //RegisterPropertyHelper(@TALWebResponseCookies_R,nil,'Cookies');
    RegisterPropertyHelper(@TALWebResponseHTTPRequest_R,nil,'HTTPRequest');
    RegisterPropertyHelper(@TALWebResponseProtocolVersion_R,@TALWebResponseProtocolVersion_W,'ProtocolVersion');
    RegisterPropertyHelper(@TALWebResponseReasonString_R,@TALWebResponseReasonString_W,'ReasonString');
    RegisterPropertyHelper(@TALWebResponseServer_R,@TALWebResponseServer_W,'Server');
    RegisterPropertyHelper(@TALWebResponseWWWAuthenticate_R,@TALWebResponseWWWAuthenticate_W,'WWWAuthenticate');
    RegisterPropertyHelper(@TALWebResponseRealm_R,@TALWebResponseRealm_W,'Realm');
    RegisterPropertyHelper(@TALWebResponseAllow_R,@TALWebResponseAllow_W,'Allow');
    RegisterPropertyHelper(@TALWebResponseLocation_R,@TALWebResponseLocation_W,'Location');
    RegisterPropertyHelper(@TALWebResponseContentEncoding_R,@TALWebResponseContentEncoding_W,'ContentEncoding');
    RegisterPropertyHelper(@TALWebResponseContentType_R,@TALWebResponseContentType_W,'ContentType');
    RegisterPropertyHelper(@TALWebResponseContentVersion_R,@TALWebResponseContentVersion_W,'ContentVersion');
    RegisterPropertyHelper(@TALWebResponseDerivedFrom_R,@TALWebResponseDerivedFrom_W,'DerivedFrom');
    RegisterPropertyHelper(@TALWebResponseTitle_R,@TALWebResponseTitle_W,'Title');
    RegisterPropertyHelper(@TALWebResponseStatusCode_R,@TALWebResponseStatusCode_W,'StatusCode');
    RegisterPropertyHelper(@TALWebResponseDate_R,@TALWebResponseDate_W,'Date');
    RegisterPropertyHelper(@TALWebResponseExpires_R,@TALWebResponseExpires_W,'Expires');
    RegisterPropertyHelper(@TALWebResponseLastModified_R,@TALWebResponseLastModified_W,'LastModified');
    RegisterPropertyHelper(@TALWebResponseContent_R,@TALWebResponseContent_W,'Content');
    RegisterPropertyHelper(@TALWebResponseContentStream_R,@TALWebResponseContentStream_W,'ContentStream');
    RegisterPropertyHelper(@TALWebResponseLogMessage_R,@TALWebResponseLogMessage_W,'LogMessage');
    RegisterPropertyHelper(@TALWebResponseCustomHeaders_R,@TALWebResponseCustomHeaders_W,'CustomHeaders');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALISAPIRequest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALISAPIRequest) do begin
    RegisterConstructor(@TALISAPIRequest.Create, 'Create');
    RegisterMethod(@TALISAPIRequest.Destroy, 'Free');
    //RegisterMethod(@TALISAPIRequest.closeConnection, 'closeConnection');
   //RegisterMethod(@TALISAPIRequest.ReadClientToStream, 'ReadClientToStream');
    RegisterMethod(@TALISAPIRequest.GetFieldByName, 'GetFieldByName');
    RegisterMethod(@TALISAPIRequest.ReadClient, 'ReadClient');
    RegisterMethod(@TALISAPIRequest.ReadString, 'ReadString');
    RegisterMethod(@TALISAPIRequest.TranslateURI, 'TranslateURI');
    RegisterMethod(@TALISAPIRequest.WriteClient, 'WriteClient');
    RegisterMethod(@TALISAPIRequest.WriteString, 'WriteString');
    RegisterMethod(@TALISAPIRequest.WriteHeaders, 'WriteHeaders');
    RegisterPropertyHelper(@TALISAPIRequestECB_R,nil,'ECB');
    RegisterPropertyHelper(@TALISAPIRequestConnectionClosed_R,nil,'ConnectionClosed');
    RegisterPropertyHelper(@TALISAPIRequestClientDataExhausted_R,nil,'ClientDataExhausted');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALWebRequest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALWebRequest) do
  begin
    RegisterConstructor(@TALWebRequest.Create, 'Create');
    RegisterMethod(@TALWebRequest.ExtractCookieFields, 'ExtractCookieFields');
    RegisterMethod(@TALWebRequest.ExtractQueryFields, 'ExtractQueryFields');
    RegisterMethod(@TALWebRequest.ExtractUrlEncodedContentFields, 'ExtractUrlEncodedContentFields');
    RegisterMethod(@TALWebRequest.ExtractMultipartFormDataFields, 'ExtractMultipartFormDataFields');
    {RegisterVirtualAbstractMethod(@TALWebRequest, @!.ReadClient, 'ReadClient');
    RegisterVirtualAbstractMethod(@TALWebRequest, @!.ReadString, 'ReadString');
    RegisterVirtualAbstractMethod(@TALWebRequest, @!.TranslateURI, 'TranslateURI');
    RegisterVirtualAbstractMethod(@TALWebRequest, @!.WriteClient, 'WriteClient');
    RegisterVirtualAbstractMethod(@TALWebRequest, @!.WriteString, 'WriteString');
    RegisterVirtualAbstractMethod(@TALWebRequest, @!.WriteHeaders, 'WriteHeaders');
    RegisterVirtualAbstractMethod(@TALWebRequest, @!.GetFieldByName, 'GetFieldByName'); }
    //RegisterPropertyHelper(@TALWebRequestMethodType_R,nil,'MethodType');
    RegisterPropertyHelper(@TALWebRequestMethod_R,nil,'Method');
    RegisterPropertyHelper(@TALWebRequestProtocolVersion_R,nil,'ProtocolVersion');
    RegisterPropertyHelper(@TALWebRequestURL_R,nil,'URL');
    RegisterPropertyHelper(@TALWebRequestQuery_R,nil,'Query');
    RegisterPropertyHelper(@TALWebRequestPathInfo_R,nil,'PathInfo');
    RegisterPropertyHelper(@TALWebRequestPathTranslated_R,nil,'PathTranslated');
    RegisterPropertyHelper(@TALWebRequestAuthorization_R,nil,'Authorization');
    RegisterPropertyHelper(@TALWebRequestCacheControl_R,nil,'CacheControl');
    RegisterPropertyHelper(@TALWebRequestCookie_R,nil,'Cookie');
    RegisterPropertyHelper(@TALWebRequestDate_R,nil,'Date');
    RegisterPropertyHelper(@TALWebRequestAccept_R,nil,'Accept');
    RegisterPropertyHelper(@TALWebRequestFrom_R,nil,'From');
    RegisterPropertyHelper(@TALWebRequestHost_R,nil,'Host');
    RegisterPropertyHelper(@TALWebRequestIfModifiedSince_R,nil,'IfModifiedSince');
    RegisterPropertyHelper(@TALWebRequestReferer_R,nil,'Referer');
    RegisterPropertyHelper(@TALWebRequestUserAgent_R,nil,'UserAgent');
    RegisterPropertyHelper(@TALWebRequestContentEncoding_R,nil,'ContentEncoding');
    RegisterPropertyHelper(@TALWebRequestContentType_R,nil,'ContentType');
    RegisterPropertyHelper(@TALWebRequestContentLength_R,nil,'ContentLength');
    RegisterPropertyHelper(@TALWebRequestContentVersion_R,nil,'ContentVersion');
    RegisterPropertyHelper(@TALWebRequestContent_R,nil,'Content');
    RegisterPropertyHelper(@TALWebRequestContentStream_R,nil,'ContentStream');
    RegisterPropertyHelper(@TALWebRequestMaxContentSize_R,@TALWebRequestMaxContentSize_W,'MaxContentSize');
    RegisterPropertyHelper(@TALWebRequestConnection_R,nil,'Connection');
    RegisterPropertyHelper(@TALWebRequestDerivedFrom_R,nil,'DerivedFrom');
    RegisterPropertyHelper(@TALWebRequestExpires_R,nil,'Expires');
    RegisterPropertyHelper(@TALWebRequestTitle_R,nil,'Title');
    RegisterPropertyHelper(@TALWebRequestRemoteAddr_R,nil,'RemoteAddr');
    RegisterPropertyHelper(@TALWebRequestRemoteHost_R,nil,'RemoteHost');
    RegisterPropertyHelper(@TALWebRequestScriptName_R,nil,'ScriptName');
    RegisterPropertyHelper(@TALWebRequestServerPort_R,nil,'ServerPort');
    RegisterPropertyHelper(@TALWebRequestBytesRange_R,nil,'BytesRange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALIsapiHTTP(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EALIsapiRequestContentSizeTooBig) do
  with CL.Add(EALIsapiRequestConnectionDropped) do
  RIRegister_TALWebRequest(CL);
  RIRegister_TALISAPIRequest(CL);
  RIRegister_TALWebResponse(CL);
  RIRegister_TALISAPIResponse(CL);
end;

 
 
{ TPSImport_ALIsapiHTTP }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALIsapiHTTP.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALIsapiHTTP(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALIsapiHTTP.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALIsapiHTTP(ri);
  RIRegister_ALIsapiHTTP_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
