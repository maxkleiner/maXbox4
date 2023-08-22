unit uPSI_ALHttpClient2;
{
as a second update to allhttpclient    TALHTTPClient2
with function ALHTTPEncode(const AStr: AnsiString): AnsiString;
function ALHTTPDecode(const AStr: AnsiString): AnsiString;   missing put


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
  TPSImport_ALHttpClient2 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALHTTPClient2(CL: TPSPascalCompiler);
procedure SIRegister_TALHTTPClientProxyParams2(CL: TPSPascalCompiler);
procedure SIRegister_EALHTTPClientException2(CL: TPSPascalCompiler);
procedure SIRegister_TALHTTPResponseHeader2(CL: TPSPascalCompiler);
procedure SIRegister_TALHTTPCookieCollection2(CL: TPSPascalCompiler);
procedure SIRegister_TALHTTPCookie2(CL: TPSPascalCompiler);
procedure SIRegister_TALHTTPRequestHeader2(CL: TPSPascalCompiler);
procedure SIRegister_ALHttpClient2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALHttpClient2_Routines(S: TPSExec);
procedure RIRegister_TALHTTPClient2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALHTTPClientProxyParams2(CL: TPSRuntimeClassImporter);
procedure RIRegister_EALHTTPClientException2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALHTTPResponseHeader2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALHTTPCookieCollection2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALHTTPCookie2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALHTTPRequestHeader2(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALHttpClient2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Wininet
  ,ALStringList
  ,ALMultiPartParser
  ,ALHttpClient2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALHttpClient2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHTTPClient2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALHTTPClient2') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALHTTPClient2') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Get( const aUrl : AnsiString; const aRequestFields : TALStrings; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArr' +
      'ay; const aEncodeRequestFields : Boolean);');
    RegisterMethod('Procedure Get1( const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);');
    RegisterMethod('Function Get2( const aUrl : AnsiString; const ARequestHeaderValues : TALNameValueArray) : AnsiString;');
    RegisterMethod('Function Get3( const aUrl : AnsiString; const aRequestFields : TALStrings; const ARequestHeaderValues : TALNameValueArray; const aEncodeRequestFields : Boolean) : AnsiString;');
    RegisterMethod('Procedure Post( const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);');
    RegisterMethod('Procedure Post1(const aUrl: AnsiString; const aPostDataStream: TStream; const aResponseContent: TStream; const aResponseHeader: TALHTTPResponseHeader2; const ARequestHeaderValues: TALNameValueArray);');
    RegisterMethod('Function Post2( const aUrl : AnsiString; const ARequestHeaderValues : TALNameValueArray) : AnsiString;');
    RegisterMethod('Function Post3( const aUrl : AnsiString; const aPostDataStream : TStream; const ARequestHeaderValues : TALNameValueArray) : AnsiString;');
    RegisterMethod('Procedure PostUrlEncoded( const aUrl : AnsiString; const aRequestFields : TALStrings; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALN' +
      'ameValueArray; const aEncodeRequestFields : Boolean);');
    RegisterMethod('Function PostUrlEncoded1( const aUrl : AnsiString; const aRequestFields : TALStrings; const ARequestHeaderValues : TALNameValueArray; const aEncodeRequestFields : Boolean) : AnsiString;');
    RegisterMethod('Procedure PostMultipartFormData( const aUrl : AnsiString; const aRequestFields : TALStrings; const aRequestFiles : TALMultiPartFormDataContents; const aResponseContent : TStream; const aResponseHeader' +
      ' : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);');
    RegisterMethod('Function PostMultiPartFormData1(const aUrl: AnsiString; const aRequestFields: TALStrings; const aRequestFiles:TALMultiPartFormDataContents;const ARequestHeaderValues: TALNameValueArray): AnsiString;');
    RegisterMethod('Procedure Head( const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);');
    RegisterMethod('Function Head1( const aUrl : AnsiString; const ARequestHeaderValues : TALNameValueArray) : AnsiString;');
    RegisterMethod('Procedure Trace( const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues: TALNameValueArray);');
    RegisterMethod('Function trace1( const aUrl : AnsiString; const ARequestHeaderValues : TALNameValueArray) : AnsiString;');
    RegisterMethod('Procedure Put0( const aUrl:String;const aPutDataStream:TStream; const aResponseContent:TStream; const aResponseHeader:TALHTTPResponseHeader2;const ARequestHeaderValues: TALNameValueArray);');

    RegisterMethod('Procedure Put( const aUrl:AnsiString;const aPutDataStream: TStream; const aResponseContent:TStream; const aResponseHeader:TALHTTPResponseHeader2; const ARequestHeaderValues: TALNameValueArray);');
    RegisterMethod('Function Put1( const aURL : Ansistring; const aPutDataStream : TStream; const ARequestHeaderValues : TALNameValueArray) : AnsiString;');
    RegisterMethod('Procedure Delete( const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);');
    RegisterMethod('Function Delete1( const aURL : Ansistring; const ARequestHeaderValues : TALNameValueArray) : AnsiString;');
    RegisterMethod('Procedure Options( const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);');
    RegisterMethod('Function Options1( const aURL : Ansistring; const ARequestHeaderValues : TALNameValueArray) : AnsiString;');
    RegisterProperty('ConnectTimeout', 'Integer', iptrw);
    RegisterProperty('SendTimeout', 'Integer', iptrw);
    RegisterProperty('ReceiveTimeout', 'Integer', iptrw);
    RegisterProperty('UploadBufferSize', 'cardinal', iptrw);
    RegisterProperty('ProxyParams', 'TALHTTPClientProxyParams', iptr);
    RegisterProperty('RequestHeader', 'TALHTTPRequestHeader2', iptr);
    RegisterProperty('ProtocolVersion', 'TALHTTPProtocolVersion', iptrw);
    RegisterProperty('ProtocolVersion2', 'TALHTTPProtocolVersion2', iptrw);
    RegisterProperty('UserName', 'AnsiString', iptrw);
    RegisterProperty('Password', 'AnsiString', iptrw);
    RegisterProperty('OnUploadProgress', 'TALHTTPClientUploadProgressEvent', iptrw);
    RegisterProperty('OnDownloadProgress', 'TALHTTPClientDownloadProgressEvent', iptrw);
    RegisterProperty('OnRedirect', 'TAlHTTPClientRedirectEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHTTPClientProxyParams2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TALHTTPClientProxyParams') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TALHTTPClientProxyParams2') do
  begin
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
procedure SIRegister_EALHTTPClientException2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EALHTTPClientException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EALHTTPClientException') do
  begin
    RegisterMethod('Constructor Create( const Msg : AnsiString; SCode : Integer)');
    RegisterMethod('Constructor CreateFmt( const Msg : AnsiString; const Args : array of const; SCode : Integer)');
    RegisterProperty('StatusCode', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHTTPResponseHeader2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALHTTPResponseHeader2') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALHTTPResponseHeader2') do
  begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Clear');
    RegisterProperty('AcceptRanges', 'AnsiString', iptr);
    RegisterProperty('Age', 'AnsiString', iptr);
    RegisterProperty('Allow', 'AnsiString', iptr);
    RegisterProperty('CacheControl', 'AnsiString', iptr);
    RegisterProperty('Connection', 'AnsiString', iptr);
    RegisterProperty('ContentEncoding', 'AnsiString', iptr);
    RegisterProperty('ContentLanguage', 'AnsiString', iptr);
    RegisterProperty('ContentLength', 'AnsiString', iptr);
    RegisterProperty('ContentLocation', 'AnsiString', iptr);
    RegisterProperty('ContentMD5', 'AnsiString', iptr);
    RegisterProperty('ContentRange', 'AnsiString', iptr);
    RegisterProperty('ContentType', 'AnsiString', iptr);
    RegisterProperty('Date', 'AnsiString', iptr);
    RegisterProperty('ETag', 'AnsiString', iptr);
    RegisterProperty('Expires', 'AnsiString', iptr);
    RegisterProperty('LastModified', 'AnsiString', iptr);
    RegisterProperty('Location', 'AnsiString', iptr);
    RegisterProperty('Pragma', 'AnsiString', iptr);
    RegisterProperty('ProxyAuthenticate', 'AnsiString', iptr);
    RegisterProperty('RetryAfter', 'AnsiString', iptr);
    RegisterProperty('Server', 'AnsiString', iptr);
    RegisterProperty('Trailer', 'AnsiString', iptr);
    RegisterProperty('TransferEncoding', 'AnsiString', iptr);
    RegisterProperty('Upgrade', 'AnsiString', iptr);
    RegisterProperty('Vary', 'AnsiString', iptr);
    RegisterProperty('Via', 'AnsiString', iptr);
    RegisterProperty('Warning', 'AnsiString', iptr);
    RegisterProperty('WWWAuthenticate', 'AnsiString', iptr);
    RegisterProperty('CustomHeaders', 'TALStrings', iptr);
    RegisterProperty('Cookies', 'TALHTTPCookieCollection', iptr);
    RegisterProperty('StatusCode', 'AnsiString', iptr);
    RegisterProperty('HttpProtocolVersion', 'AnsiString', iptr);
    RegisterProperty('ReasonPhrase', 'AnsiString', iptr);
    RegisterProperty('RawHeaderText', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHTTPCookieCollection2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TALHTTPCookieCollection') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TALHTTPCookieCollection2') do
  begin
    RegisterMethod('Function Add : TALHTTPCookie;');
    RegisterMethod('Function Add1( const Name : AnsiString; const Value : AnsiString; const Path : AnsiString; const Domain : AnsiString; const Expires : int64; const SameSite : AnsiString; const Secure : Boolean; const ' +
      'HttpOnly : Boolean) : TALHTTPCookie;');
    RegisterProperty('Items', 'TALHTTPCookie2 Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHTTPCookie2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TALHTTPCookie') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TALHTTPCookie2') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure AssignTo( Dest : TPersistent)');
    RegisterProperty('Name', 'AnsiString', iptrw);
    RegisterProperty('Value', 'AnsiString', iptrw);
    RegisterProperty('Path', 'AnsiString', iptrw);
    RegisterProperty('Domain', 'AnsiString', iptrw);
    RegisterProperty('Expires', 'TDateTime', iptrw);
    RegisterProperty('SameSite', 'AnsiString', iptrw);
    RegisterProperty('Secure', 'Boolean', iptrw);
    RegisterProperty('HttpOnly', 'Boolean', iptrw);
    RegisterProperty('HeaderValue', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHTTPRequestHeader2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALHTTPRequestHeader2') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALHTTPRequestHeader2') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure setHeaderValue( const aName : ansiString; const aValue : ansiString)');
    RegisterProperty('RawHeaderText', 'AnsiString', iptrw);
    RegisterProperty('Accept', 'AnsiString', iptrw);
    RegisterProperty('AcceptCharSet', 'AnsiString', iptrw);
    RegisterProperty('AcceptEncoding', 'AnsiString', iptrw);
    RegisterProperty('AcceptLanguage', 'AnsiString', iptrw);
    RegisterProperty('Allow', 'AnsiString', iptrw);
    RegisterProperty('Authorization', 'AnsiString', iptrw);
    RegisterProperty('CacheControl', 'AnsiString', iptrw);
    RegisterProperty('Connection', 'AnsiString', iptrw);
    RegisterProperty('ContentEncoding', 'AnsiString', iptrw);
    RegisterProperty('ContentLanguage', 'AnsiString', iptrw);
    RegisterProperty('ContentLength', 'AnsiString', iptrw);
    RegisterProperty('ContentLocation', 'AnsiString', iptrw);
    RegisterProperty('ContentMD5', 'AnsiString', iptrw);
    RegisterProperty('ContentRange', 'AnsiString', iptrw);
    RegisterProperty('ContentType', 'AnsiString', iptrw);
    RegisterProperty('Date', 'AnsiString', iptrw);
    RegisterProperty('Expect', 'AnsiString', iptrw);
    RegisterProperty('Expires', 'AnsiString', iptrw);
    RegisterProperty('From', 'AnsiString', iptrw);
    RegisterProperty('Host', 'AnsiString', iptrw);
    RegisterProperty('IfMatch', 'AnsiString', iptrw);
    RegisterProperty('IfModifiedSince', 'AnsiString', iptrw);
    RegisterProperty('IfNoneMatch', 'AnsiString', iptrw);
    RegisterProperty('IfRange', 'AnsiString', iptrw);
    RegisterProperty('IfUnmodifiedSince', 'AnsiString', iptrw);
    RegisterProperty('LastModified', 'AnsiString', iptrw);
    RegisterProperty('MaxForwards', 'AnsiString', iptrw);
    RegisterProperty('Pragma', 'AnsiString', iptrw);
    RegisterProperty('ProxyAuthorization', 'AnsiString', iptrw);
    RegisterProperty('Range', 'AnsiString', iptrw);
    RegisterProperty('Referer', 'AnsiString', iptrw);
    RegisterProperty('TE', 'AnsiString', iptrw);
    RegisterProperty('Trailer', 'AnsiString', iptrw);
    RegisterProperty('TransferEncoding', 'AnsiString', iptrw);
    RegisterProperty('Upgrade', 'AnsiString', iptrw);
    RegisterProperty('UserAgent', 'AnsiString', iptrw);
    RegisterProperty('Via', 'AnsiString', iptrw);
    RegisterProperty('Warning', 'AnsiString', iptrw);
    RegisterProperty('CustomHeaders', 'TALStrings', iptr);
    RegisterProperty('Cookies', 'TALStrings', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALHttpClient2(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TALHTTPPropertyChangeEvent', 'Procedure ( sender: Tobject; const PropertyIndex: Integer)');
  CL.AddTypeS('TALHTTPProtocolVersion', '( HTTPpv_1_0, HTTPpv_1_1 )');
  CL.AddTypeS('TALHTTPProtocolVersion2', '( HTTPpv_1_0, HTTPpv_1_1 )');
  CL.AddTypeS('TALHTTPMethod2', '( HTTPmt_Get, HTTPmt_Post, HTTPmt_Head, HTTPmt_'
   +'Trace, HTTPmt_Put, HTTPmt_Delete, HTTPmt_Options )');
  SIRegister_TALHTTPRequestHeader2(CL);
  CL.AddTypeS('TALNameValuePair', 'record Name : ansistring; Value : ansistring; end');
  CL.AddTypeS('TALNameValueArray', 'array of TALNameValuePair');
  SIRegister_TALHTTPCookie2(CL);
  SIRegister_TALHTTPCookieCollection2(CL);
  SIRegister_TALHTTPResponseHeader2(CL);
  SIRegister_EALHTTPClientException2(CL);
  SIRegister_TALHTTPClientProxyParams2(CL);
  CL.AddTypeS('TAlHTTPClientRedirectEvent', 'Procedure ( sender : Tobject; const NewURL : AnsiString)');
  CL.AddTypeS('TALHTTPClientUploadProgressEvent', 'Procedure ( sender : Tobject; Sent: Integer; Total: Integer)');
  CL.AddTypeS('TALHTTPClientDownloadProgressEvent', 'Procedure ( sender: Tobject; Read: Integer; Total: Integer)');
  SIRegister_TALHTTPClient2(CL);
 CL.AddDelphiFunction('Procedure ALHTTPEncodeParamNameValues2( const ParamValues : TALStrings)');
 //CL.AddDelphiFunction('Procedure ALExtractHTTPFields( Separators, WhiteSpace, Quotes : TSysCharSet; Content : PAnsiChar; Strings : TALStrings; StripQuotes : Boolean)');
 CL.AddDelphiFunction('Function AlRemoveShemeFromUrl2( const aUrl : AnsiString) : ansiString');
 CL.AddDelphiFunction('Function AlExtractShemeFromUrl2( const aUrl : AnsiString) : TInternetScheme');
 CL.AddDelphiFunction('Function AlExtractHostNameFromUrl2( const aUrl : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AlExtractDomainNameFromUrl2( const aUrl : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AlExtractUrlPathFromUrl2( const aUrl : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AlInternetCrackUrl2( const aUrl : AnsiString; var SchemeName, HostName, UserName, Password, UrlPath, ExtraInfo : AnsiString; var PortNumber : integer) : Boolean;');
 CL.AddDelphiFunction('Function AlInternetCrackUrl12( const aUrl : AnsiString; var SchemeName, HostName, UserName, Password, UrlPath, Anchor : AnsiString; const Query : TALStrings; var PortNumber : integer) : Boolean;');
 CL.AddDelphiFunction('Function AlInternetCrackUrl22( var Url : AnsiString; var Anchor : AnsiString; const Query : TALStrings) : Boolean;');
 CL.AddDelphiFunction('Function AlRemoveAnchorFromUrl2( aUrl : AnsiString; var aAnchor : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function AlRemoveAnchorFromUrl12( const aUrl : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function AlCombineUrl2( const RelativeUrl, BaseUrl : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function AlCombineUrl12( const RelativeUrl, BaseUrl, Anchor : AnsiString; const Query : TALStrings) : AnsiString;');
 CL.AddDelphiFunction('Function ALGmtDateTimeToRfc822Str2( const aValue : TDateTime) : AnsiString');
 CL.AddDelphiFunction('Function ALDateTimeToRfc822Str2( const aValue : TDateTime) : AnsiString');
 CL.AddDelphiFunction('Function ALTryRfc822StrToGMTDateTime2( const S : AnsiString; out Value : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function ALRfc822StrToGMTDateTime2( const s : AnsiString) : TDateTime');
 CL.AddDelphiFunction('Function ALTryIPV4StrToNumeric2( const aIPv4Str : AnsiString; var aIPv4Num : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function ALIPV4StrToNumeric2( const aIPv4 : AnsiString) : Cardinal');
 CL.AddDelphiFunction('Function ALNumericToIPv4Str2( const aIPv4 : Cardinal) : ansiString');
 CL.AddDelphiFunction('Function ALIPv4EndOfRange2( const aStartIPv4 : Cardinal; aMaskLength : integer) : Cardinal');
 CL.AddDelphiFunction('Function ALZeroIpV62 : TALIPv6Binary');
 CL.AddDelphiFunction('Function ALIsValidIPv6BinaryStr2( const aIPV6BinaryStr : ansiString) : boolean');
 CL.AddDelphiFunction('Function ALTryIPV6StrToBinary2( aIPv6Str : ansiString; var aIPv6Bin : TALIPv6Binary) : Boolean');
 CL.AddDelphiFunction('Function ALIPV6StrTobinary2( const aIPv6 : AnsiString) : TALIPv6Binary');
 CL.AddDelphiFunction('Function ALBinaryToIPv6Str2( const aIPv6 : TALIPv6Binary) : ansiString');
 CL.AddDelphiFunction('Function ALBinaryStrToIPv6Binary2( const aIPV6BinaryStr : ansiString) : TALIPv6Binary');
 CL.AddDelphiFunction('Function ALBinaryStrToIPv6Str2( const aIPV6BinaryStr : ansiString) : ansiString');
 CL.AddDelphiFunction('Function ALIPv6EndOfRange2( const aStartIPv6 : TALIPv6Binary; aMaskLength : integer) : TALIPv6Binary');
 CL.AddDelphiFunction('Procedure ALIPv6SplitParts2( const aIPv6 : TALIPv6Binary; var aLowestPart : UInt64; var aHigestPart : UInt64)');
 CL.AddConstantN('cALHTTPCLient_MsgInvalidURL2','String').SetString( 'Invalid url ''%s'' - only supports ''http'' and ''https'' schemes');
 CL.AddConstantN('cALHTTPCLient_MsgInvalidHTTPRequest2','String').SetString( 'Invalid HTTP Request: Length is 0');
 CL.AddConstantN('cALHTTPCLient_MsgEmptyURL2','String').SetString( 'Empty URL');
 CL.AddDelphiFunction('function ALHTTPEncode(const AStr: AnsiString): AnsiString;');
 CL.AddDelphiFunction('function ALHTTPDecode(const AStr: AnsiString): AnsiString;');
end;


(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function AlCombineUrl1_P( const RelativeUrl, BaseUrl, Anchor : AnsiString; const Query : TALStrings) : AnsiString;
Begin Result := ALHttpClient2.AlCombineUrl2(RelativeUrl, BaseUrl, Anchor, Query); END;

(*----------------------------------------------------------------------------*)
Function AlCombineUrl_P( const RelativeUrl, BaseUrl : AnsiString) : AnsiString;
Begin Result := ALHttpClient2.AlCombineUrl2(RelativeUrl, BaseUrl); END;

(*----------------------------------------------------------------------------*)
Function AlRemoveAnchorFromUrl1_P( const aUrl : AnsiString) : AnsiString;
Begin Result := ALHttpClient2.AlRemoveAnchorFromUrl2(aUrl); END;

(*----------------------------------------------------------------------------*)
Function AlRemoveAnchorFromUrl_P( aUrl : AnsiString; var aAnchor : AnsiString) : AnsiString;
Begin Result := ALHttpClient2.AlRemoveAnchorFromUrl2(aUrl, aAnchor); END;

(*----------------------------------------------------------------------------*)
Function AlInternetCrackUrl2_P( var Url : AnsiString; var Anchor : AnsiString; const Query : TALStrings) : Boolean;
Begin Result := ALHttpClient2.AlInternetCrackUrl2(Url, Anchor, Query); END;

(*----------------------------------------------------------------------------*)
Function AlInternetCrackUrl1_P( const aUrl : AnsiString; var SchemeName, HostName, UserName, Password, UrlPath, Anchor : AnsiString; const Query : TALStrings; var PortNumber : integer) : Boolean;
Begin Result := ALHttpClient2.AlInternetCrackUrl2(aUrl, SchemeName, HostName, UserName, Password, UrlPath, Anchor, Query, PortNumber); END;

(*----------------------------------------------------------------------------*)
Function AlInternetCrackUrl_P( const aUrl : AnsiString; var SchemeName, HostName, UserName, Password, UrlPath, ExtraInfo : AnsiString; var PortNumber : integer) : Boolean;
Begin Result := ALHttpClient2.AlInternetCrackUrl2(aUrl, SchemeName, HostName, UserName, Password, UrlPath, ExtraInfo, PortNumber); END;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnRedirect_W(Self: TALHTTPClient2; const T: TAlHTTPClientRedirectEvent);
begin Self.OnRedirect := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnRedirect_R(Self: TALHTTPClient2; var T: TAlHTTPClientRedirectEvent);
begin T := Self.OnRedirect; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnDownloadProgress_W(Self: TALHTTPClient2; const T: TALHTTPClientDownloadProgressEvent);
begin Self.OnDownloadProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnDownloadProgress_R(Self: TALHTTPClient2; var T: TALHTTPClientDownloadProgressEvent);
begin T := Self.OnDownloadProgress; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnUploadProgress_W(Self: TALHTTPClient2; const T: TALHTTPClientUploadProgressEvent);
begin Self.OnUploadProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientOnUploadProgress_R(Self: TALHTTPClient2; var T: TALHTTPClientUploadProgressEvent);
begin T := Self.OnUploadProgress; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientPassword_W(Self: TALHTTPClient2; const T: AnsiString);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientPassword_R(Self: TALHTTPClient2; var T: AnsiString);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientUserName_W(Self: TALHTTPClient2; const T: AnsiString);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientUserName_R(Self: TALHTTPClient2; var T: AnsiString);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProtocolVersion_W(Self: TALHTTPClient2; const T: TALHTTPProtocolVersion2);
begin Self.ProtocolVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProtocolVersion_R(Self: TALHTTPClient2; var T: TALHTTPProtocolVersion2);
begin T := Self.ProtocolVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientRequestHeader_R(Self: TALHTTPClient2; var T: TALHTTPRequestHeader2);
begin T := Self.RequestHeader; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParams_R(Self: TALHTTPClient2; var T: TALHTTPClientProxyParams2);
begin T := Self.ProxyParams; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientUploadBufferSize_W(Self: TALHTTPClient2; const T: cardinal);
begin Self.UploadBufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientUploadBufferSize_R(Self: TALHTTPClient2; var T: cardinal);
begin T := Self.UploadBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientReceiveTimeout_W(Self: TALHTTPClient2; const T: Integer);
begin Self.ReceiveTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientReceiveTimeout_R(Self: TALHTTPClient2; var T: Integer);
begin T := Self.ReceiveTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientSendTimeout_W(Self: TALHTTPClient2; const T: Integer);
begin Self.SendTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientSendTimeout_R(Self: TALHTTPClient2; var T: Integer);
begin T := Self.SendTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientConnectTimeout_W(Self: TALHTTPClient2; const T: Integer);
begin Self.ConnectTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientConnectTimeout_R(Self: TALHTTPClient2; var T: Integer);
begin T := Self.ConnectTimeout; end;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientOptions1_P(Self: TALHTTPClient2;  const aURL : Ansistring; const ARequestHeaderValues : TALNameValueArray) : AnsiString;
Begin Result := Self.Options(aURL, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientOptions_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);
Begin Self.Options(aUrl, aResponseContent, aResponseHeader, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientDelete1_P(Self: TALHTTPClient2;  const aURL : Ansistring; const ARequestHeaderValues : TALNameValueArray) : AnsiString;
Begin Result := Self.Delete(aURL, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientDelete_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);
Begin Self.Delete(aUrl, aResponseContent, aResponseHeader, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientPut1_P(Self: TALHTTPClient2;  const aURL : Ansistring; const aPutDataStream : TStream; const ARequestHeaderValues : TALNameValueArray) : AnsiString;
Begin Result := Self.Put(aURL, aPutDataStream, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientPut_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aPutDataStream : TStream; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);
Begin Self.Put(aUrl, aPutDataStream, aResponseContent, aResponseHeader, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClienttrace1_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const ARequestHeaderValues : TALNameValueArray) : AnsiString;
Begin Result := Self.trace(aUrl, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientTrace_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);
Begin Self.Trace(aUrl, aResponseContent, aResponseHeader, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientHead1_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const ARequestHeaderValues : TALNameValueArray) : AnsiString;
Begin Result := Self.Head(aUrl, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientHead_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);
Begin Self.Head(aUrl, aResponseContent, aResponseHeader, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientPostMultiPartFormData1_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aRequestFields : TALStrings; const aRequestFiles : TALMultiPartFormDataContents; const ARequestHeaderValues : TALNameValueArray) : AnsiString;
Begin Result := Self.PostMultiPartFormData(aUrl, aRequestFields, aRequestFiles, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientPostMultipartFormData_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aRequestFields : TALStrings; const aRequestFiles : TALMultiPartFormDataContents; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);
Begin Self.PostMultipartFormData(aUrl, aRequestFields, aRequestFiles, aResponseContent, aResponseHeader, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientPostUrlEncoded1_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aRequestFields : TALStrings; const ARequestHeaderValues : TALNameValueArray; const aEncodeRequestFields : Boolean) : AnsiString;
Begin Result := Self.PostUrlEncoded(aUrl, aRequestFields, ARequestHeaderValues, aEncodeRequestFields); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientPostUrlEncoded_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aRequestFields : TALStrings; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray; const aEncodeRequestFields : Boolean);
Begin Self.PostUrlEncoded(aUrl, aRequestFields, aResponseContent, aResponseHeader, ARequestHeaderValues, aEncodeRequestFields); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientPost3_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aPostDataStream : TStream; const ARequestHeaderValues : TALNameValueArray) : AnsiString;
Begin Result := Self.Post(aUrl, aPostDataStream, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientPost2_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const ARequestHeaderValues : TALNameValueArray) : AnsiString;
Begin Result := Self.Post(aUrl, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientPost1_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aPostDataStream : TStream; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);
Begin Self.Post(aUrl, aPostDataStream, aResponseContent, aResponseHeader, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientPost_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);
Begin Self.Post(aUrl, aResponseContent, aResponseHeader, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientGet3_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aRequestFields : TALStrings; const ARequestHeaderValues : TALNameValueArray; const aEncodeRequestFields : Boolean) : AnsiString;
Begin Result := Self.Get(aUrl, aRequestFields, ARequestHeaderValues, aEncodeRequestFields); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPClientGet2_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const ARequestHeaderValues : TALNameValueArray) : AnsiString;
Begin Result := Self.Get(aUrl, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientGet1_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray);
Begin Self.Get(aUrl, aResponseContent, aResponseHeader, ARequestHeaderValues); END;

(*----------------------------------------------------------------------------*)
Procedure TALHTTPClientGet_P(Self: TALHTTPClient2;  const aUrl : AnsiString; const aRequestFields : TALStrings; const aResponseContent : TStream; const aResponseHeader : TALHTTPResponseHeader2; const ARequestHeaderValues : TALNameValueArray; const aEncodeRequestFields : Boolean);
Begin Self.Get(aUrl, aRequestFields, aResponseContent, aResponseHeader, ARequestHeaderValues, aEncodeRequestFields); END;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsOnChange_W(Self: TALHTTPClientProxyParams2; const T: TALHTTPPropertyChangeEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsOnChange_R(Self: TALHTTPClientProxyParams2; var T: TALHTTPPropertyChangeEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyPassword_W(Self: TALHTTPClientProxyParams2; const T: AnsiString);
begin Self.ProxyPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyPassword_R(Self: TALHTTPClientProxyParams2; var T: AnsiString);
begin T := Self.ProxyPassword; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyUserName_W(Self: TALHTTPClientProxyParams2; const T: AnsiString);
begin Self.ProxyUserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyUserName_R(Self: TALHTTPClientProxyParams2; var T: AnsiString);
begin T := Self.ProxyUserName; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyPort_W(Self: TALHTTPClientProxyParams2; const T: integer);
begin Self.ProxyPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyPort_R(Self: TALHTTPClientProxyParams2; var T: integer);
begin T := Self.ProxyPort; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyServer_W(Self: TALHTTPClientProxyParams2; const T: AnsiString);
begin Self.ProxyServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyServer_R(Self: TALHTTPClientProxyParams2; var T: AnsiString);
begin T := Self.ProxyServer; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyBypass_W(Self: TALHTTPClientProxyParams2; const T: AnsiString);
begin Self.ProxyBypass := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPClientProxyParamsProxyBypass_R(Self: TALHTTPClientProxyParams2; var T: AnsiString);
begin T := Self.ProxyBypass; end;

(*----------------------------------------------------------------------------*)
procedure EALHTTPClientExceptionStatusCode_W(Self: EALHTTPClientException; const T: Integer);
begin Self.StatusCode := T; end;

(*----------------------------------------------------------------------------*)
procedure EALHTTPClientExceptionStatusCode_R(Self: EALHTTPClientException; var T: Integer);
begin T := Self.StatusCode; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderRawHeaderText_W(Self: TALHTTPResponseHeader2; const T: AnsiString);
begin Self.RawHeaderText := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderRawHeaderText_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.RawHeaderText; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderReasonPhrase_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.ReasonPhrase; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderHttpProtocolVersion_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.HttpProtocolVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderStatusCode_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.StatusCode; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderCookies_R(Self: TALHTTPResponseHeader2; var T: TALHTTPCookieCollection2);
begin T := Self.Cookies; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderCustomHeaders_R(Self: TALHTTPResponseHeader2; var T: TALStrings);
begin T := Self.CustomHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderWWWAuthenticate_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.WWWAuthenticate; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderWarning_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Warning; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderVia_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Via; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderVary_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Vary; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderUpgrade_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Upgrade; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderTransferEncoding_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.TransferEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderTrailer_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Trailer; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderServer_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderRetryAfter_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.RetryAfter; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderProxyAuthenticate_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.ProxyAuthenticate; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderPragma_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Pragma; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderLocation_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Location; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderLastModified_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.LastModified; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderExpires_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Expires; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderETag_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.ETag; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderDate_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Date; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentType_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentRange_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.ContentRange; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentMD5_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.ContentMD5; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentLocation_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.ContentLocation; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentLength_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.ContentLength; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentLanguage_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.ContentLanguage; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentEncoding_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.ContentEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderConnection_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderCacheControl_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.CacheControl; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderAllow_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Allow; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderAge_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.Age; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderAcceptRanges_R(Self: TALHTTPResponseHeader2; var T: AnsiString);
begin T := Self.AcceptRanges; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieCollectionItems_W(Self: TALHTTPCookieCollection2; const T: TALHTTPCookie2; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieCollectionItems_R(Self: TALHTTPCookieCollection2; var T: TALHTTPCookie2; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TALHTTPCookieCollectionAdd1_P(Self: TALHTTPCookieCollection2;  const Name : AnsiString; const Value : AnsiString; const Path : AnsiString; const Domain : AnsiString; const Expires : int64; const SameSite : AnsiString; const Secure : Boolean; const HttpOnly : Boolean) : TALHTTPCookie2;
Begin Result := Self.Add(Name, Value, Path, Domain, Expires, SameSite, Secure, HttpOnly); END;

(*----------------------------------------------------------------------------*)
Function TALHTTPCookieCollectionAdd_P(Self: TALHTTPCookieCollection2) : TALHTTPCookie2;
Begin Result := Self.Add; END;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieHeaderValue_W(Self: TALHTTPCookie2; const T: AnsiString);
begin Self.HeaderValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieHeaderValue_R(Self: TALHTTPCookie2; var T: AnsiString);
begin T := Self.HeaderValue; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieHttpOnly_W(Self: TALHTTPCookie2; const T: Boolean);
begin Self.HttpOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieHttpOnly_R(Self: TALHTTPCookie2; var T: Boolean);
begin T := Self.HttpOnly; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieSecure_W(Self: TALHTTPCookie2; const T: Boolean);
begin Self.Secure := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieSecure_R(Self: TALHTTPCookie2; var T: Boolean);
begin T := Self.Secure; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieSameSite_W(Self: TALHTTPCookie2; const T: AnsiString);
begin Self.SameSite := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieSameSite_R(Self: TALHTTPCookie2; var T: AnsiString);
begin T := Self.SameSite; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieExpires_W(Self: TALHTTPCookie2; const T: TDateTime);
begin Self.Expires := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieExpires_R(Self: TALHTTPCookie2; var T: TDateTime);
begin T := Self.Expires; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieDomain_W(Self: TALHTTPCookie2; const T: AnsiString);
begin Self.Domain := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieDomain_R(Self: TALHTTPCookie2; var T: AnsiString);
begin T := Self.Domain; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookiePath_W(Self: TALHTTPCookie2; const T: AnsiString);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookiePath_R(Self: TALHTTPCookie2; var T: AnsiString);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieValue_W(Self: TALHTTPCookie2; const T: AnsiString);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieValue_R(Self: TALHTTPCookie2; var T: AnsiString);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieName_W(Self: TALHTTPCookie2; const T: AnsiString);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieName_R(Self: TALHTTPCookie2; var T: AnsiString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderCookies_R(Self: TALHTTPRequestHeader2; var T: TALStrings);
begin T := Self.Cookies; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderCustomHeaders_R(Self: TALHTTPRequestHeader2; var T: TALStrings);
begin T := Self.CustomHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderWarning_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Warning := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderWarning_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Warning; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderVia_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Via := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderVia_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Via; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderUserAgent_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.UserAgent := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderUserAgent_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.UserAgent; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderUpgrade_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Upgrade := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderUpgrade_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Upgrade; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTransferEncoding_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.TransferEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTransferEncoding_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.TransferEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTrailer_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Trailer := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTrailer_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Trailer; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTE_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.TE := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTE_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.TE; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderReferer_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Referer := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderReferer_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Referer; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderRange_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Range := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderRange_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Range; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderProxyAuthorization_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.ProxyAuthorization := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderProxyAuthorization_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.ProxyAuthorization; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderPragma_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Pragma := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderPragma_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Pragma; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderMaxForwards_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.MaxForwards := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderMaxForwards_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.MaxForwards; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderLastModified_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.LastModified := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderLastModified_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.LastModified; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfUnmodifiedSince_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.IfUnmodifiedSince := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfUnmodifiedSince_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.IfUnmodifiedSince; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfRange_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.IfRange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfRange_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.IfRange; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfNoneMatch_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.IfNoneMatch := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfNoneMatch_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.IfNoneMatch; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfModifiedSince_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.IfModifiedSince := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfModifiedSince_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.IfModifiedSince; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfMatch_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.IfMatch := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfMatch_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.IfMatch; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderHost_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Host := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderHost_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderFrom_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.From := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderFrom_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.From; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderExpires_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Expires := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderExpires_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Expires; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderExpect_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Expect := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderExpect_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Expect; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderDate_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Date := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderDate_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Date; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentType_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.ContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentType_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentRange_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.ContentRange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentRange_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.ContentRange; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentMD5_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.ContentMD5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentMD5_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.ContentMD5; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLocation_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.ContentLocation := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLocation_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.ContentLocation; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLength_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.ContentLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLength_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.ContentLength; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLanguage_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.ContentLanguage := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLanguage_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.ContentLanguage; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentEncoding_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.ContentEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentEncoding_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.ContentEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderConnection_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Connection := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderConnection_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderCacheControl_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.CacheControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderCacheControl_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.CacheControl; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAuthorization_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Authorization := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAuthorization_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Authorization; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAllow_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Allow := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAllow_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Allow; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptLanguage_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.AcceptLanguage := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptLanguage_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.AcceptLanguage; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptEncoding_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.AcceptEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptEncoding_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.AcceptEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptCharSet_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.AcceptCharSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptCharSet_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.AcceptCharSet; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAccept_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.Accept := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAccept_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.Accept; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderRawHeaderText_W(Self: TALHTTPRequestHeader2; const T: AnsiString);
begin Self.RawHeaderText := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderRawHeaderText_R(Self: TALHTTPRequestHeader2; var T: AnsiString);
begin T := Self.RawHeaderText; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALHttpClient2_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ALHTTPEncodeParamNameValues, 'ALHTTPEncodeParamNameValues2', cdRegister);
 S.RegisterDelphiFunction(@ALExtractHTTPFields, 'ALExtractHTTPFields2', cdRegister);
 S.RegisterDelphiFunction(@AlRemoveShemeFromUrl, 'AlRemoveShemeFromUrl2', cdRegister);
 S.RegisterDelphiFunction(@AlExtractShemeFromUrl, 'AlExtractShemeFromUrl2', cdRegister);
 S.RegisterDelphiFunction(@AlExtractHostNameFromUrl, 'AlExtractHostNameFromUrl2', cdRegister);
 S.RegisterDelphiFunction(@AlExtractDomainNameFromUrl, 'AlExtractDomainNameFromUrl2', cdRegister);
 S.RegisterDelphiFunction(@AlExtractUrlPathFromUrl, 'AlExtractUrlPathFromUrl2', cdRegister);
 S.RegisterDelphiFunction(@AlInternetCrackUrl2, 'AlInternetCrackUrl2', cdRegister);
 S.RegisterDelphiFunction(@AlInternetCrackUrl1_P, 'AlInternetCrackUrl12', cdRegister);
 S.RegisterDelphiFunction(@AlInternetCrackUrl2_P, 'AlInternetCrackUrl22', cdRegister);
 S.RegisterDelphiFunction(@AlRemoveAnchorFromUrl2, 'AlRemoveAnchorFromUrl2', cdRegister);
 S.RegisterDelphiFunction(@AlRemoveAnchorFromUrl1_P, 'AlRemoveAnchorFromUrl12', cdRegister);
 S.RegisterDelphiFunction(@AlCombineUrl2, 'AlCombineUrl2', cdRegister);
 S.RegisterDelphiFunction(@AlCombineUrl1_P, 'AlCombineUrl12', cdRegister);
 S.RegisterDelphiFunction(@ALGmtDateTimeToRfc822Str, 'ALGmtDateTimeToRfc822Str2', cdRegister);
 S.RegisterDelphiFunction(@ALDateTimeToRfc822Str, 'ALDateTimeToRfc822Str2', cdRegister);
 S.RegisterDelphiFunction(@ALTryRfc822StrToGMTDateTime, 'ALTryRfc822StrToGMTDateTime2', cdRegister);
 S.RegisterDelphiFunction(@ALRfc822StrToGMTDateTime, 'ALRfc822StrToGMTDateTime2', cdRegister);
 S.RegisterDelphiFunction(@ALTryIPV4StrToNumeric, 'ALTryIPV4StrToNumeric2', cdRegister);
 S.RegisterDelphiFunction(@ALIPV4StrToNumeric, 'ALIPV4StrToNumeric2', cdRegister);
 S.RegisterDelphiFunction(@ALNumericToIPv4Str, 'ALNumericToIPv4Str2', cdRegister);
 S.RegisterDelphiFunction(@ALIPv4EndOfRange, 'ALIPv4EndOfRange2', cdRegister);
 S.RegisterDelphiFunction(@ALZeroIpV6, 'ALZeroIpV62', cdRegister);
 S.RegisterDelphiFunction(@ALIsValidIPv6BinaryStr, 'ALIsValidIPv6BinaryStr2', cdRegister);
 S.RegisterDelphiFunction(@ALTryIPV6StrToBinary, 'ALTryIPV6StrToBinary2', cdRegister);
 S.RegisterDelphiFunction(@ALIPV6StrTobinary, 'ALIPV6StrTobinary2', cdRegister);
 S.RegisterDelphiFunction(@ALBinaryToIPv6Str, 'ALBinaryToIPv6Str2', cdRegister);
 S.RegisterDelphiFunction(@ALBinaryStrToIPv6Binary, 'ALBinaryStrToIPv6Binary2', cdRegister);
 S.RegisterDelphiFunction(@ALBinaryStrToIPv6Str, 'ALBinaryStrToIPv6Str2', cdRegister);
 S.RegisterDelphiFunction(@ALIPv6EndOfRange, 'ALIPv6EndOfRange2', cdRegister);
 S.RegisterDelphiFunction(@ALIPv6SplitParts, 'ALIPv6SplitParts2', cdRegister);
 S.RegisterDelphiFunction(@ALHTTPEncode, 'ALHTTPEncode', cdRegister);
 S.RegisterDelphiFunction(@ALHTTPDecode, 'ALHTTPDecode', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHTTPClient2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPClient2) do begin
    RegisterConstructor(@TALHTTPClient2.Create, 'Create');
    RegisterMethod(@TALHTTPClient2.Destroy, 'Free');
    RegisterMethod(@TALHTTPClientGet_P, 'Get');
    RegisterMethod(@TALHTTPClientGet1_P, 'Get1');
    RegisterMethod(@TALHTTPClientGet2_P, 'Get2');
    RegisterMethod(@TALHTTPClientGet3_P, 'Get3');
    RegisterMethod(@TALHTTPClientPost_P, 'Post');
    RegisterMethod(@TALHTTPClientPost1_P, 'Post1');
    RegisterMethod(@TALHTTPClientPost2_P, 'Post2');
    RegisterMethod(@TALHTTPClientPost3_P, 'Post3');
    RegisterMethod(@TALHTTPClientPostUrlEncoded_P, 'PostUrlEncoded');
    RegisterMethod(@TALHTTPClientPostUrlEncoded1_P, 'PostUrlEncoded1');
    RegisterMethod(@TALHTTPClientPostMultipartFormData_P, 'PostMultipartFormData');
    RegisterMethod(@TALHTTPClientPostMultiPartFormData1_P, 'PostMultiPartFormData1');
    RegisterMethod(@TALHTTPClientHead_P, 'Head');
    RegisterMethod(@TALHTTPClientHead1_P, 'Head1');
    RegisterMethod(@TALHTTPClientTrace_P, 'Trace');
    RegisterMethod(@TALHTTPClienttrace1_P, 'trace1');
    RegisterMethod(@TALHTTPClientPut_P, 'Put');
     RegisterMethod(@TALHTTPClientPut_P, 'Put0');
    RegisterMethod(@TALHTTPClientPut1_P, 'Put1');
    RegisterMethod(@TALHTTPClientDelete_P, 'Delete');
    RegisterMethod(@TALHTTPClientDelete1_P, 'Delete1');
    RegisterMethod(@TALHTTPClientOptions_P, 'Options');
    RegisterMethod(@TALHTTPClientOptions1_P, 'Options1');
    RegisterPropertyHelper(@TALHTTPClientConnectTimeout_R,@TALHTTPClientConnectTimeout_W,'ConnectTimeout');
    RegisterPropertyHelper(@TALHTTPClientSendTimeout_R,@TALHTTPClientSendTimeout_W,'SendTimeout');
    RegisterPropertyHelper(@TALHTTPClientReceiveTimeout_R,@TALHTTPClientReceiveTimeout_W,'ReceiveTimeout');
    RegisterPropertyHelper(@TALHTTPClientUploadBufferSize_R,@TALHTTPClientUploadBufferSize_W,'UploadBufferSize');
    RegisterPropertyHelper(@TALHTTPClientProxyParams_R,nil,'ProxyParams');
    RegisterPropertyHelper(@TALHTTPClientRequestHeader_R,nil,'RequestHeader');
    RegisterPropertyHelper(@TALHTTPClientProtocolVersion_R,@TALHTTPClientProtocolVersion_W,'ProtocolVersion');
    RegisterPropertyHelper(@TALHTTPClientUserName_R,@TALHTTPClientUserName_W,'UserName');
    RegisterPropertyHelper(@TALHTTPClientPassword_R,@TALHTTPClientPassword_W,'Password');
    RegisterPropertyHelper(@TALHTTPClientOnUploadProgress_R,@TALHTTPClientOnUploadProgress_W,'OnUploadProgress');
    RegisterPropertyHelper(@TALHTTPClientOnDownloadProgress_R,@TALHTTPClientOnDownloadProgress_W,'OnDownloadProgress');
    RegisterPropertyHelper(@TALHTTPClientOnRedirect_R,@TALHTTPClientOnRedirect_W,'OnRedirect');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHTTPClientProxyParams2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPClientProxyParams2) do
  begin
    RegisterConstructor(@TALHTTPClientProxyParams2.Create, 'Create');
    RegisterMethod(@TALHTTPClientProxyParams2.Clear, 'Clear');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsProxyBypass_R,@TALHTTPClientProxyParamsProxyBypass_W,'ProxyBypass');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsProxyServer_R,@TALHTTPClientProxyParamsProxyServer_W,'ProxyServer');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsProxyPort_R,@TALHTTPClientProxyParamsProxyPort_W,'ProxyPort');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsProxyUserName_R,@TALHTTPClientProxyParamsProxyUserName_W,'ProxyUserName');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsProxyPassword_R,@TALHTTPClientProxyParamsProxyPassword_W,'ProxyPassword');
    RegisterPropertyHelper(@TALHTTPClientProxyParamsOnChange_R,@TALHTTPClientProxyParamsOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EALHTTPClientException2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EALHTTPClientException) do
  begin
    RegisterConstructor(@EALHTTPClientException.Create, 'Create');
    RegisterConstructor(@EALHTTPClientException.CreateFmt, 'CreateFmt');
    RegisterPropertyHelper(@EALHTTPClientExceptionStatusCode_R,@EALHTTPClientExceptionStatusCode_W,'StatusCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHTTPResponseHeader2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPResponseHeader2) do
  begin
    RegisterConstructor(@TALHTTPResponseHeader2.Create, 'Create');
    RegisterMethod(@TALHTTPResponseHeader2.Clear, 'Clear');
    RegisterMethod(@TALHTTPResponseHeader2.Destroy, 'Free');
    RegisterPropertyHelper(@TALHTTPResponseHeaderAcceptRanges_R,nil,'AcceptRanges');
    RegisterPropertyHelper(@TALHTTPResponseHeaderAge_R,nil,'Age');
    RegisterPropertyHelper(@TALHTTPResponseHeaderAllow_R,nil,'Allow');
    RegisterPropertyHelper(@TALHTTPResponseHeaderCacheControl_R,nil,'CacheControl');
    RegisterPropertyHelper(@TALHTTPResponseHeaderConnection_R,nil,'Connection');
    RegisterPropertyHelper(@TALHTTPResponseHeaderContentEncoding_R,nil,'ContentEncoding');
    RegisterPropertyHelper(@TALHTTPResponseHeaderContentLanguage_R,nil,'ContentLanguage');
    RegisterPropertyHelper(@TALHTTPResponseHeaderContentLength_R,nil,'ContentLength');
    RegisterPropertyHelper(@TALHTTPResponseHeaderContentLocation_R,nil,'ContentLocation');
    RegisterPropertyHelper(@TALHTTPResponseHeaderContentMD5_R,nil,'ContentMD5');
    RegisterPropertyHelper(@TALHTTPResponseHeaderContentRange_R,nil,'ContentRange');
    RegisterPropertyHelper(@TALHTTPResponseHeaderContentType_R,nil,'ContentType');
    RegisterPropertyHelper(@TALHTTPResponseHeaderDate_R,nil,'Date');
    RegisterPropertyHelper(@TALHTTPResponseHeaderETag_R,nil,'ETag');
    RegisterPropertyHelper(@TALHTTPResponseHeaderExpires_R,nil,'Expires');
    RegisterPropertyHelper(@TALHTTPResponseHeaderLastModified_R,nil,'LastModified');
    RegisterPropertyHelper(@TALHTTPResponseHeaderLocation_R,nil,'Location');
    RegisterPropertyHelper(@TALHTTPResponseHeaderPragma_R,nil,'Pragma');
    RegisterPropertyHelper(@TALHTTPResponseHeaderProxyAuthenticate_R,nil,'ProxyAuthenticate');
    RegisterPropertyHelper(@TALHTTPResponseHeaderRetryAfter_R,nil,'RetryAfter');
    RegisterPropertyHelper(@TALHTTPResponseHeaderServer_R,nil,'Server');
    RegisterPropertyHelper(@TALHTTPResponseHeaderTrailer_R,nil,'Trailer');
    RegisterPropertyHelper(@TALHTTPResponseHeaderTransferEncoding_R,nil,'TransferEncoding');
    RegisterPropertyHelper(@TALHTTPResponseHeaderUpgrade_R,nil,'Upgrade');
    RegisterPropertyHelper(@TALHTTPResponseHeaderVary_R,nil,'Vary');
    RegisterPropertyHelper(@TALHTTPResponseHeaderVia_R,nil,'Via');
    RegisterPropertyHelper(@TALHTTPResponseHeaderWarning_R,nil,'Warning');
    RegisterPropertyHelper(@TALHTTPResponseHeaderWWWAuthenticate_R,nil,'WWWAuthenticate');
    RegisterPropertyHelper(@TALHTTPResponseHeaderCustomHeaders_R,nil,'CustomHeaders');
    RegisterPropertyHelper(@TALHTTPResponseHeaderCookies_R,nil,'Cookies');
    RegisterPropertyHelper(@TALHTTPResponseHeaderStatusCode_R,nil,'StatusCode');
    RegisterPropertyHelper(@TALHTTPResponseHeaderHttpProtocolVersion_R,nil,'HttpProtocolVersion');
    RegisterPropertyHelper(@TALHTTPResponseHeaderReasonPhrase_R,nil,'ReasonPhrase');
    RegisterPropertyHelper(@TALHTTPResponseHeaderRawHeaderText_R,@TALHTTPResponseHeaderRawHeaderText_W,'RawHeaderText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHTTPCookieCollection2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPCookieCollection2) do
  begin
    RegisterMethod(@TALHTTPCookieCollectionAdd_P, 'Add');
    RegisterMethod(@TALHTTPCookieCollectionAdd1_P, 'Add1');
    RegisterPropertyHelper(@TALHTTPCookieCollectionItems_R,@TALHTTPCookieCollectionItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHTTPCookie2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPCookie2) do
  begin
    RegisterConstructor(@TALHTTPCookie2.Create, 'Create');
    RegisterMethod(@TALHTTPCookie2.AssignTo, 'AssignTo');
    RegisterPropertyHelper(@TALHTTPCookieName_R,@TALHTTPCookieName_W,'Name');
    RegisterPropertyHelper(@TALHTTPCookieValue_R,@TALHTTPCookieValue_W,'Value');
    RegisterPropertyHelper(@TALHTTPCookiePath_R,@TALHTTPCookiePath_W,'Path');
    RegisterPropertyHelper(@TALHTTPCookieDomain_R,@TALHTTPCookieDomain_W,'Domain');
    RegisterPropertyHelper(@TALHTTPCookieExpires_R,@TALHTTPCookieExpires_W,'Expires');
    RegisterPropertyHelper(@TALHTTPCookieSameSite_R,@TALHTTPCookieSameSite_W,'SameSite');
    RegisterPropertyHelper(@TALHTTPCookieSecure_R,@TALHTTPCookieSecure_W,'Secure');
    RegisterPropertyHelper(@TALHTTPCookieHttpOnly_R,@TALHTTPCookieHttpOnly_W,'HttpOnly');
    RegisterPropertyHelper(@TALHTTPCookieHeaderValue_R,@TALHTTPCookieHeaderValue_W,'HeaderValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHTTPRequestHeader2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPRequestHeader2) do begin
    RegisterConstructor(@TALHTTPRequestHeader2.Create, 'Create');
    RegisterMethod(@TALHTTPRequestHeader2.Destroy, 'Free');
    RegisterMethod(@TALHTTPRequestHeader2.Clear, 'Clear');
    RegisterMethod(@TALHTTPRequestHeader2.setHeaderValue, 'setHeaderValue');
    RegisterPropertyHelper(@TALHTTPRequestHeaderRawHeaderText_R,@TALHTTPRequestHeaderRawHeaderText_W,'RawHeaderText');
    RegisterPropertyHelper(@TALHTTPRequestHeaderAccept_R,@TALHTTPRequestHeaderAccept_W,'Accept');
    RegisterPropertyHelper(@TALHTTPRequestHeaderAcceptCharSet_R,@TALHTTPRequestHeaderAcceptCharSet_W,'AcceptCharSet');
    RegisterPropertyHelper(@TALHTTPRequestHeaderAcceptEncoding_R,@TALHTTPRequestHeaderAcceptEncoding_W,'AcceptEncoding');
    RegisterPropertyHelper(@TALHTTPRequestHeaderAcceptLanguage_R,@TALHTTPRequestHeaderAcceptLanguage_W,'AcceptLanguage');
    RegisterPropertyHelper(@TALHTTPRequestHeaderAllow_R,@TALHTTPRequestHeaderAllow_W,'Allow');
    RegisterPropertyHelper(@TALHTTPRequestHeaderAuthorization_R,@TALHTTPRequestHeaderAuthorization_W,'Authorization');
    RegisterPropertyHelper(@TALHTTPRequestHeaderCacheControl_R,@TALHTTPRequestHeaderCacheControl_W,'CacheControl');
    RegisterPropertyHelper(@TALHTTPRequestHeaderConnection_R,@TALHTTPRequestHeaderConnection_W,'Connection');
    RegisterPropertyHelper(@TALHTTPRequestHeaderContentEncoding_R,@TALHTTPRequestHeaderContentEncoding_W,'ContentEncoding');
    RegisterPropertyHelper(@TALHTTPRequestHeaderContentLanguage_R,@TALHTTPRequestHeaderContentLanguage_W,'ContentLanguage');
    RegisterPropertyHelper(@TALHTTPRequestHeaderContentLength_R,@TALHTTPRequestHeaderContentLength_W,'ContentLength');
    RegisterPropertyHelper(@TALHTTPRequestHeaderContentLocation_R,@TALHTTPRequestHeaderContentLocation_W,'ContentLocation');
    RegisterPropertyHelper(@TALHTTPRequestHeaderContentMD5_R,@TALHTTPRequestHeaderContentMD5_W,'ContentMD5');
    RegisterPropertyHelper(@TALHTTPRequestHeaderContentRange_R,@TALHTTPRequestHeaderContentRange_W,'ContentRange');
    RegisterPropertyHelper(@TALHTTPRequestHeaderContentType_R,@TALHTTPRequestHeaderContentType_W,'ContentType');
    RegisterPropertyHelper(@TALHTTPRequestHeaderDate_R,@TALHTTPRequestHeaderDate_W,'Date');
    RegisterPropertyHelper(@TALHTTPRequestHeaderExpect_R,@TALHTTPRequestHeaderExpect_W,'Expect');
    RegisterPropertyHelper(@TALHTTPRequestHeaderExpires_R,@TALHTTPRequestHeaderExpires_W,'Expires');
    RegisterPropertyHelper(@TALHTTPRequestHeaderFrom_R,@TALHTTPRequestHeaderFrom_W,'From');
    RegisterPropertyHelper(@TALHTTPRequestHeaderHost_R,@TALHTTPRequestHeaderHost_W,'Host');
    RegisterPropertyHelper(@TALHTTPRequestHeaderIfMatch_R,@TALHTTPRequestHeaderIfMatch_W,'IfMatch');
    RegisterPropertyHelper(@TALHTTPRequestHeaderIfModifiedSince_R,@TALHTTPRequestHeaderIfModifiedSince_W,'IfModifiedSince');
    RegisterPropertyHelper(@TALHTTPRequestHeaderIfNoneMatch_R,@TALHTTPRequestHeaderIfNoneMatch_W,'IfNoneMatch');
    RegisterPropertyHelper(@TALHTTPRequestHeaderIfRange_R,@TALHTTPRequestHeaderIfRange_W,'IfRange');
    RegisterPropertyHelper(@TALHTTPRequestHeaderIfUnmodifiedSince_R,@TALHTTPRequestHeaderIfUnmodifiedSince_W,'IfUnmodifiedSince');
    RegisterPropertyHelper(@TALHTTPRequestHeaderLastModified_R,@TALHTTPRequestHeaderLastModified_W,'LastModified');
    RegisterPropertyHelper(@TALHTTPRequestHeaderMaxForwards_R,@TALHTTPRequestHeaderMaxForwards_W,'MaxForwards');
    RegisterPropertyHelper(@TALHTTPRequestHeaderPragma_R,@TALHTTPRequestHeaderPragma_W,'Pragma');
    RegisterPropertyHelper(@TALHTTPRequestHeaderProxyAuthorization_R,@TALHTTPRequestHeaderProxyAuthorization_W,'ProxyAuthorization');
    RegisterPropertyHelper(@TALHTTPRequestHeaderRange_R,@TALHTTPRequestHeaderRange_W,'Range');
    RegisterPropertyHelper(@TALHTTPRequestHeaderReferer_R,@TALHTTPRequestHeaderReferer_W,'Referer');
    RegisterPropertyHelper(@TALHTTPRequestHeaderTE_R,@TALHTTPRequestHeaderTE_W,'TE');
    RegisterPropertyHelper(@TALHTTPRequestHeaderTrailer_R,@TALHTTPRequestHeaderTrailer_W,'Trailer');
    RegisterPropertyHelper(@TALHTTPRequestHeaderTransferEncoding_R,@TALHTTPRequestHeaderTransferEncoding_W,'TransferEncoding');
    RegisterPropertyHelper(@TALHTTPRequestHeaderUpgrade_R,@TALHTTPRequestHeaderUpgrade_W,'Upgrade');
    RegisterPropertyHelper(@TALHTTPRequestHeaderUserAgent_R,@TALHTTPRequestHeaderUserAgent_W,'UserAgent');
    RegisterPropertyHelper(@TALHTTPRequestHeaderVia_R,@TALHTTPRequestHeaderVia_W,'Via');
    RegisterPropertyHelper(@TALHTTPRequestHeaderWarning_R,@TALHTTPRequestHeaderWarning_W,'Warning');
    RegisterPropertyHelper(@TALHTTPRequestHeaderCustomHeaders_R,nil,'CustomHeaders');
    RegisterPropertyHelper(@TALHTTPRequestHeaderCookies_R,nil,'Cookies');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALHttpClient2(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALHTTPRequestHeader2(CL);
  RIRegister_TALHTTPCookie2(CL);
  RIRegister_TALHTTPCookieCollection2(CL);
  RIRegister_TALHTTPResponseHeader2(CL);
  RIRegister_EALHTTPClientException2(CL);
  RIRegister_TALHTTPClientProxyParams2(CL);
  RIRegister_TALHTTPClient2(CL);
end;

 
 
{ TPSImport_ALHttpClient2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALHttpClient2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALHttpClient2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALHttpClient2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALHttpClient2(ri);
  RIRegister_ALHttpClient2_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
