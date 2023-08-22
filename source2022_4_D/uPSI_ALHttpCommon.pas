unit uPSI_ALHttpCommon;
{
   base race
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
  TPSImport_ALHttpCommon = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALHTTPResponseHeader(CL: TPSPascalCompiler);
procedure SIRegister_TALHTTPCookieCollection(CL: TPSPascalCompiler);
procedure SIRegister_TALHTTPCookie(CL: TPSPascalCompiler);
procedure SIRegister_TALHTTPRequestHeader(CL: TPSPascalCompiler);
procedure SIRegister_ALHttpCommon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALHttpCommon_Routines(S: TPSExec);
procedure RIRegister_TALHTTPResponseHeader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALHTTPCookieCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALHTTPCookie(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALHTTPRequestHeader(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALHttpCommon(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Wininet
  ,AlStringList
  ,ALHttpCommon
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALHttpCommon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHTTPResponseHeader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALHTTPResponseHeader') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALHTTPResponseHeader') do begin
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
procedure SIRegister_TALHTTPCookieCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TALHTTPCookieCollection') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TALHTTPCookieCollection') do begin
    RegisterMethod('Function Add : TALHTTPCookie');
    RegisterProperty('Items', 'TALHTTPCookie Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHTTPCookie(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TALHTTPCookie') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TALHTTPCookie') do
  begin
    RegisterProperty('Name', 'AnsiString', iptrw);
    RegisterProperty('Value', 'AnsiString', iptrw);
    RegisterProperty('Domain', 'AnsiString', iptrw);
    RegisterProperty('Path', 'AnsiString', iptrw);
    RegisterProperty('Expires', 'TDateTime', iptrw);
    RegisterProperty('Secure', 'Boolean', iptrw);
    RegisterProperty('HeaderValue', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHTTPRequestHeader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALHTTPRequestHeader') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALHTTPRequestHeader') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
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
    RegisterProperty('CustomHeaders', 'TALStrings', iptrw);
    RegisterProperty('Cookies', 'TALStrings', iptrw);
    RegisterProperty('OnChange', 'TALHTTPPropertyChangeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALHttpCommon(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TALHTTPPropertyChangeEvent', 'Procedure ( sender : Tobject; const PropertyIndex : Integer)');
  CL.AddTypeS('TALHTTPProtocolVersion', '( HTTPpv_1_0, HTTPpv_1_1 )');
  CL.AddTypeS('TALHTTPMethod','(HTTPmt_Get,HTTPmt_Post,HTTPmt_Head,HTTPmt_Trace,HTTPmt_Put, HTTPmt_Delete )');
  CL.AddTypeS('TInternetScheme', 'integer');
  CL.AddTypeS('TALIPv6Binary', 'array[1..16] of Char;');

 // TALIPv6Binary = array[1..16] of ansiChar;
 //   TInternetScheme = Integer;

  SIRegister_TALHTTPRequestHeader(CL);
  SIRegister_TALHTTPCookie(CL);
  SIRegister_TALHTTPCookieCollection(CL);
  SIRegister_TALHTTPResponseHeader(CL);
 CL.AddDelphiFunction('Function ALHTTPDecode( const AStr : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure ALHTTPEncodeParamNameValues( ParamValues : TALStrings)');
// CL.AddDelphiFunction('Procedure ALExtractHTTPFields( Separators, WhiteSpace, Quotes : TSysCharSet; Content : PAnsiChar; Strings : TALStrings; StripQuotes : Boolean)');
// CL.AddDelphiFunction('Procedure ALExtractHeaderFields( Separators, WhiteSpace, Quotes : TSysCharSet; Content : PAnsiChar; Strings : TALStrings; Decode : Boolean; StripQuotes : Boolean)');
// CL.AddDelphiFunction('Procedure ALExtractHeaderFieldsWithQuoteEscaped( Separators, WhiteSpace, Quotes : TSysCharSet; Content : PAnsiChar; Strings : TALStrings; Decode : Boolean; StripQuotes : Boolean)');
 CL.AddDelphiFunction('Function AlRemoveShemeFromUrl( aUrl : AnsiString) : ansiString');
 CL.AddDelphiFunction('Function AlExtractShemeFromUrl( aUrl : AnsiString) : TInternetScheme');
 CL.AddDelphiFunction('Function AlExtractHostNameFromUrl( aUrl : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AlExtractDomainNameFromUrl( aUrl : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AlExtractUrlPathFromUrl( aUrl : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AlInternetCrackUrl( aUrl : AnsiString; var SchemeName, HostName, UserName, Password, UrlPath, ExtraInfo : AnsiString; var PortNumber : integer) : Boolean;');
 CL.AddDelphiFunction('Function AlInternetCrackUrl1( aUrl : AnsiString; var SchemeName, HostName, UserName, Password, UrlPath, Anchor : AnsiString; Query : TALStrings; var PortNumber : integer) : Boolean;');
 CL.AddDelphiFunction('Function AlInternetCrackUrl2( var Url : AnsiString; var Anchor : AnsiString; Query : TALStrings) : Boolean;');
 CL.AddDelphiFunction('Function AlRemoveAnchorFromUrl( aUrl : AnsiString; var aAnchor : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function AlRemoveAnchorFromUrl1( aUrl : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function AlCombineUrl( RelativeUrl, BaseUrl : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function AlCombineUrl1( RelativeUrl, BaseUrl, Anchor : AnsiString; Query : TALStrings) : AnsiString;');
 CL.AddDelphiFunction('Function ALGmtDateTimeToRfc822Str( const aValue : TDateTime) : AnsiString');
 CL.AddDelphiFunction('Function ALDateTimeToRfc822Str( const aValue : TDateTime) : AnsiString');
 CL.AddDelphiFunction('Function ALTryRfc822StrToGMTDateTime( const S : AnsiString; out Value : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function ALRfc822StrToGMTDateTime( const s : AnsiString) : TDateTime');
 CL.AddDelphiFunction('Function ALTryIPV4StrToNumeric( aIPv4Str : ansiString; var aIPv4Num : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function ALIPV4StrToNumeric( aIPv4 : ansiString) : Cardinal');
 CL.AddDelphiFunction('Function ALNumericToIPv4Str( aIPv4 : Cardinal) : ansiString');
 CL.AddDelphiFunction('Function ALZeroIpV6 : TALIPv6Binary');
 CL.AddDelphiFunction('Function ALTryIPV6StrToBinary( aIPv6Str : ansiString; var aIPv6Bin : TALIPv6Binary) : Boolean');
 CL.AddDelphiFunction('Function ALIPV6StrTobinary( aIPv6 : ansiString) : TALIPv6Binary');
 CL.AddDelphiFunction('Function ALBinaryToIPv6Str( aIPv6 : TALIPv6Binary) : ansiString');
 CL.AddDelphiFunction('Function ALBinaryStrToIPv6Binary( aIPV6BinaryStr : ansiString) : TALIPv6Binary');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function AlCombineUrl1_P( RelativeUrl, BaseUrl, Anchor : AnsiString; Query : TALStrings) : AnsiString;
Begin Result := ALHttpCommon.AlCombineUrl(RelativeUrl, BaseUrl, Anchor, Query); END;

(*----------------------------------------------------------------------------*)
Function AlCombineUrl_P( RelativeUrl, BaseUrl : AnsiString) : AnsiString;
Begin Result := ALHttpCommon.AlCombineUrl(RelativeUrl, BaseUrl); END;

(*----------------------------------------------------------------------------*)
Function AlRemoveAnchorFromUrl1_P( aUrl : AnsiString) : AnsiString;
Begin Result := ALHttpCommon.AlRemoveAnchorFromUrl(aUrl); END;

(*----------------------------------------------------------------------------*)
Function AlRemoveAnchorFromUrl_P( aUrl : AnsiString; var aAnchor : AnsiString) : AnsiString;
Begin Result := ALHttpCommon.AlRemoveAnchorFromUrl(aUrl, aAnchor); END;

(*----------------------------------------------------------------------------*)
Function AlInternetCrackUrl2_P( var Url : AnsiString; var Anchor : AnsiString; Query : TALStrings) : Boolean;
Begin Result := ALHttpCommon.AlInternetCrackUrl(Url, Anchor, Query); END;

(*----------------------------------------------------------------------------*)
Function AlInternetCrackUrl1_P( aUrl : AnsiString; var SchemeName, HostName, UserName, Password, UrlPath, Anchor : AnsiString; Query : TALStrings; var PortNumber : integer) : Boolean;
Begin Result := ALHttpCommon.AlInternetCrackUrl(aUrl, SchemeName, HostName, UserName, Password, UrlPath, Anchor, Query, PortNumber); END;

(*----------------------------------------------------------------------------*)
Function AlInternetCrackUrl_P( aUrl : AnsiString; var SchemeName, HostName, UserName, Password, UrlPath, ExtraInfo : AnsiString; var PortNumber : integer) : Boolean;
Begin Result := ALHttpCommon.AlInternetCrackUrl(aUrl, SchemeName, HostName, UserName, Password, UrlPath, ExtraInfo, PortNumber); END;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderRawHeaderText_W(Self: TALHTTPResponseHeader; const T: AnsiString);
begin Self.RawHeaderText := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderRawHeaderText_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.RawHeaderText; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderReasonPhrase_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.ReasonPhrase; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderHttpProtocolVersion_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.HttpProtocolVersion; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderStatusCode_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.StatusCode; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderCookies_R(Self: TALHTTPResponseHeader; var T: TALHTTPCookieCollection);
begin T := Self.Cookies; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderCustomHeaders_R(Self: TALHTTPResponseHeader; var T: TALStrings);
begin T := Self.CustomHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderWWWAuthenticate_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.WWWAuthenticate; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderWarning_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Warning; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderVia_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Via; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderVary_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Vary; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderUpgrade_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Upgrade; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderTransferEncoding_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.TransferEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderTrailer_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Trailer; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderServer_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderRetryAfter_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.RetryAfter; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderProxyAuthenticate_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.ProxyAuthenticate; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderPragma_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Pragma; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderLocation_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Location; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderLastModified_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.LastModified; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderExpires_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Expires; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderETag_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.ETag; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderDate_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Date; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentType_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentRange_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.ContentRange; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentMD5_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.ContentMD5; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentLocation_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.ContentLocation; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentLength_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.ContentLength; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentLanguage_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.ContentLanguage; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderContentEncoding_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.ContentEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderConnection_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderCacheControl_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.CacheControl; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderAllow_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Allow; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderAge_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.Age; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPResponseHeaderAcceptRanges_R(Self: TALHTTPResponseHeader; var T: AnsiString);
begin T := Self.AcceptRanges; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieCollectionItems_W(Self: TALHTTPCookieCollection; const T: TALHTTPCookie; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieCollectionItems_R(Self: TALHTTPCookieCollection; var T: TALHTTPCookie; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieHeaderValue_W(Self: TALHTTPCookie; const T: AnsiString);
begin Self.HeaderValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieHeaderValue_R(Self: TALHTTPCookie; var T: AnsiString);
begin T := Self.HeaderValue; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieSecure_W(Self: TALHTTPCookie; const T: Boolean);
begin Self.Secure := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieSecure_R(Self: TALHTTPCookie; var T: Boolean);
begin T := Self.Secure; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieExpires_W(Self: TALHTTPCookie; const T: TDateTime);
begin Self.Expires := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieExpires_R(Self: TALHTTPCookie; var T: TDateTime);
begin T := Self.Expires; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookiePath_W(Self: TALHTTPCookie; const T: AnsiString);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookiePath_R(Self: TALHTTPCookie; var T: AnsiString);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieDomain_W(Self: TALHTTPCookie; const T: AnsiString);
begin Self.Domain := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieDomain_R(Self: TALHTTPCookie; var T: AnsiString);
begin T := Self.Domain; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieValue_W(Self: TALHTTPCookie; const T: AnsiString);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieValue_R(Self: TALHTTPCookie; var T: AnsiString);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieName_W(Self: TALHTTPCookie; const T: AnsiString);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPCookieName_R(Self: TALHTTPCookie; var T: AnsiString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderOnChange_W(Self: TALHTTPRequestHeader; const T: TALHTTPPropertyChangeEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderOnChange_R(Self: TALHTTPRequestHeader; var T: TALHTTPPropertyChangeEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderCookies_W(Self: TALHTTPRequestHeader; const T: TALStrings);
begin Self.Cookies := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderCookies_R(Self: TALHTTPRequestHeader; var T: TALStrings);
begin T := Self.Cookies; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderCustomHeaders_W(Self: TALHTTPRequestHeader; const T: TALStrings);
begin Self.CustomHeaders := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderCustomHeaders_R(Self: TALHTTPRequestHeader; var T: TALStrings);
begin T := Self.CustomHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderWarning_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Warning := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderWarning_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Warning; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderVia_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Via := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderVia_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Via; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderUserAgent_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.UserAgent := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderUserAgent_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.UserAgent; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderUpgrade_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Upgrade := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderUpgrade_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Upgrade; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTransferEncoding_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.TransferEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTransferEncoding_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.TransferEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTrailer_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Trailer := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTrailer_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Trailer; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTE_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.TE := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderTE_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.TE; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderReferer_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Referer := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderReferer_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Referer; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderRange_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Range := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderRange_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Range; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderProxyAuthorization_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.ProxyAuthorization := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderProxyAuthorization_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.ProxyAuthorization; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderPragma_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Pragma := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderPragma_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Pragma; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderMaxForwards_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.MaxForwards := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderMaxForwards_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.MaxForwards; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderLastModified_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.LastModified := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderLastModified_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.LastModified; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfUnmodifiedSince_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.IfUnmodifiedSince := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfUnmodifiedSince_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.IfUnmodifiedSince; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfRange_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.IfRange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfRange_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.IfRange; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfNoneMatch_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.IfNoneMatch := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfNoneMatch_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.IfNoneMatch; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfModifiedSince_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.IfModifiedSince := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfModifiedSince_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.IfModifiedSince; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfMatch_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.IfMatch := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderIfMatch_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.IfMatch; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderHost_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Host := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderHost_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderFrom_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.From := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderFrom_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.From; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderExpires_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Expires := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderExpires_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Expires; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderExpect_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Expect := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderExpect_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Expect; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderDate_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Date := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderDate_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Date; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentType_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.ContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentType_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentRange_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.ContentRange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentRange_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.ContentRange; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentMD5_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.ContentMD5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentMD5_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.ContentMD5; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLocation_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.ContentLocation := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLocation_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.ContentLocation; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLength_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.ContentLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLength_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.ContentLength; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLanguage_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.ContentLanguage := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentLanguage_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.ContentLanguage; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentEncoding_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.ContentEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderContentEncoding_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.ContentEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderConnection_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Connection := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderConnection_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderCacheControl_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.CacheControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderCacheControl_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.CacheControl; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAuthorization_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Authorization := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAuthorization_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Authorization; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAllow_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Allow := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAllow_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Allow; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptLanguage_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.AcceptLanguage := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptLanguage_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.AcceptLanguage; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptEncoding_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.AcceptEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptEncoding_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.AcceptEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptCharSet_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.AcceptCharSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAcceptCharSet_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.AcceptCharSet; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAccept_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.Accept := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderAccept_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.Accept; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderRawHeaderText_W(Self: TALHTTPRequestHeader; const T: AnsiString);
begin Self.RawHeaderText := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHTTPRequestHeaderRawHeaderText_R(Self: TALHTTPRequestHeader; var T: AnsiString);
begin T := Self.RawHeaderText; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALHttpCommon_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ALHTTPDecode, 'ALHTTPDecode', cdRegister);
 S.RegisterDelphiFunction(@ALHTTPEncodeParamNameValues, 'ALHTTPEncodeParamNameValues', cdRegister);
 S.RegisterDelphiFunction(@ALExtractHTTPFields, 'ALExtractHTTPFields', cdRegister);
 S.RegisterDelphiFunction(@ALExtractHeaderFields, 'ALExtractHeaderFields', cdRegister);
 S.RegisterDelphiFunction(@ALExtractHeaderFieldsWithQuoteEscaped, 'ALExtractHeaderFieldsWithQuoteEscaped', cdRegister);
 S.RegisterDelphiFunction(@AlRemoveShemeFromUrl, 'AlRemoveShemeFromUrl', cdRegister);
 S.RegisterDelphiFunction(@AlExtractShemeFromUrl, 'AlExtractShemeFromUrl', cdRegister);
 S.RegisterDelphiFunction(@AlExtractHostNameFromUrl, 'AlExtractHostNameFromUrl', cdRegister);
 S.RegisterDelphiFunction(@AlExtractDomainNameFromUrl, 'AlExtractDomainNameFromUrl', cdRegister);
 S.RegisterDelphiFunction(@AlExtractUrlPathFromUrl, 'AlExtractUrlPathFromUrl', cdRegister);
 S.RegisterDelphiFunction(@AlInternetCrackUrl, 'AlInternetCrackUrl', cdRegister);
 S.RegisterDelphiFunction(@AlInternetCrackUrl1_P, 'AlInternetCrackUrl1', cdRegister);
 S.RegisterDelphiFunction(@AlInternetCrackUrl2_P, 'AlInternetCrackUrl2', cdRegister);
 S.RegisterDelphiFunction(@AlRemoveAnchorFromUrl, 'AlRemoveAnchorFromUrl', cdRegister);
 S.RegisterDelphiFunction(@AlRemoveAnchorFromUrl1_P, 'AlRemoveAnchorFromUrl1', cdRegister);
 S.RegisterDelphiFunction(@AlCombineUrl, 'AlCombineUrl', cdRegister);
 S.RegisterDelphiFunction(@AlCombineUrl1_P, 'AlCombineUrl1', cdRegister);
 S.RegisterDelphiFunction(@ALGmtDateTimeToRfc822Str, 'ALGmtDateTimeToRfc822Str', cdRegister);
 S.RegisterDelphiFunction(@ALDateTimeToRfc822Str, 'ALDateTimeToRfc822Str', cdRegister);
 S.RegisterDelphiFunction(@ALTryRfc822StrToGMTDateTime, 'ALTryRfc822StrToGMTDateTime', cdRegister);
 S.RegisterDelphiFunction(@ALRfc822StrToGMTDateTime, 'ALRfc822StrToGMTDateTime', cdRegister);
 S.RegisterDelphiFunction(@ALTryIPV4StrToNumeric, 'ALTryIPV4StrToNumeric', cdRegister);
 S.RegisterDelphiFunction(@ALIPV4StrToNumeric, 'ALIPV4StrToNumeric', cdRegister);
 S.RegisterDelphiFunction(@ALNumericToIPv4Str, 'ALNumericToIPv4Str', cdRegister);
 S.RegisterDelphiFunction(@ALZeroIpV6, 'ALZeroIpV6', cdRegister);
 S.RegisterDelphiFunction(@ALTryIPV6StrToBinary, 'ALTryIPV6StrToBinary', cdRegister);
 S.RegisterDelphiFunction(@ALIPV6StrTobinary, 'ALIPV6StrTobinary', cdRegister);
 S.RegisterDelphiFunction(@ALBinaryToIPv6Str, 'ALBinaryToIPv6Str', cdRegister);
 S.RegisterDelphiFunction(@ALBinaryStrToIPv6Binary, 'ALBinaryStrToIPv6Binary', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHTTPResponseHeader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPResponseHeader) do begin
    RegisterConstructor(@TALHTTPResponseHeader.Create, 'Create');
    RegisterMethod(@TALHTTPResponseHeader.Clear, 'Clear');
    RegisterMethod(@TALHTTPResponseHeader.Destroy,'Free');
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
procedure RIRegister_TALHTTPCookieCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPCookieCollection) do
  begin
    RegisterMethod(@TALHTTPCookieCollection.Add, 'Add');
    RegisterPropertyHelper(@TALHTTPCookieCollectionItems_R,@TALHTTPCookieCollectionItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHTTPCookie(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPCookie) do
  begin
    RegisterPropertyHelper(@TALHTTPCookieName_R,@TALHTTPCookieName_W,'Name');
    RegisterPropertyHelper(@TALHTTPCookieValue_R,@TALHTTPCookieValue_W,'Value');
    RegisterPropertyHelper(@TALHTTPCookieDomain_R,@TALHTTPCookieDomain_W,'Domain');
    RegisterPropertyHelper(@TALHTTPCookiePath_R,@TALHTTPCookiePath_W,'Path');
    RegisterPropertyHelper(@TALHTTPCookieExpires_R,@TALHTTPCookieExpires_W,'Expires');
    RegisterPropertyHelper(@TALHTTPCookieSecure_R,@TALHTTPCookieSecure_W,'Secure');
    RegisterPropertyHelper(@TALHTTPCookieHeaderValue_R,@TALHTTPCookieHeaderValue_W,'HeaderValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHTTPRequestHeader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHTTPRequestHeader) do begin
    RegisterConstructor(@TALHTTPRequestHeader.Create, 'Create');
    RegisterMethod(@TALHTTPRequestHeader.Clear, 'Clear');
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
    RegisterPropertyHelper(@TALHTTPRequestHeaderCustomHeaders_R,@TALHTTPRequestHeaderCustomHeaders_W,'CustomHeaders');
    RegisterPropertyHelper(@TALHTTPRequestHeaderCookies_R,@TALHTTPRequestHeaderCookies_W,'Cookies');
    RegisterPropertyHelper(@TALHTTPRequestHeaderOnChange_R,@TALHTTPRequestHeaderOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALHttpCommon(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALHTTPRequestHeader(CL);
  RIRegister_TALHTTPCookie(CL);
  RIRegister_TALHTTPCookieCollection(CL);
  RIRegister_TALHTTPResponseHeader(CL);
end;

 
 
{ TPSImport_ALHttpCommon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALHttpCommon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALHttpCommon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALHttpCommon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALHttpCommon(ri);
  RIRegister_ALHttpCommon_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
