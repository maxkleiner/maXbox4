unit uPSI_ALWinHttpWrapper;
{
   to wrap  handle as thandle not a pointer
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
  TPSImport_ALWinHttpWrapper = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ALWinHttpWrapper(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALWinHttpWrapper_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,ALWinHttpWrapper
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALWinHttpWrapper]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ALWinHttpWrapper(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('DWORD_PTR', 'DWORD');
  //CL.AddTypeS('HINTERNET', '___Pointer');
  CL.AddTypeS('HINTERNET', 'THandle');

  //CL.AddTypeS('PHINTERNET', '^HINTERNET // will not work');
  //CL.AddTypeS('LPHINTERNET', 'PHINTERNET');
  //CL.AddTypeS('INTERNET_PORT', 'Word');
  //CL.AddTypeS('PInternetScheme', '^TInternetScheme // will not work');
  CL.AddTypeS('TInternetScheme', 'Integer');
  //CL.AddTypeS('PURLComponents', '^URL_COMPONENTS // will not work');
  {CL.AddTypeS('URL_COMPONENTS', 'record dwStructSize : DWORD; lpszScheme : LPWS'
   +'TR; dwSchemeLength : DWORD; nScheme : TInternetScheme; lpszHostName : LPWS'
   +'TR; dwHostNameLength : DWORD; nPort : INTERNET_PORT; pad : WORD; lpszUserN'
   +'ame : LPWSTR; dwUserNameLength : DWORD; lpszPassword : LPWSTR; dwPasswordL'
   +'ength : DWORD; lpszUrlPath : LPWSTR; dwUrlPathLength : DWORD; lpszExtraInf'
   +'o : LPWSTR; dwExtraInfoLength : DWORD; end');}
  //CL.AddTypeS('TURLComponents', 'URL_COMPONENTS');
  //CL.AddTypeS('LPURL_COMPONENTS', 'PURLComponents');
  //CL.AddTypeS('PWINHTTP_PROXY_INFO', '^WINHTTP_PROXY_INFO // will not work');
  //CL.AddTypeS('WINHTTP_PROXY_INFO', 'record dwAccessType : DWORD; lpszProxy : L'
  // +'PWSTR; lpszProxyBypass : LPWSTR; end');
  //CL.AddTypeS('TWINHTTP_PROXY_INFO', 'WINHTTP_PROXY_INFO');
 // CL.AddTypeS('LPWINHTTP_PROXY_INFO', 'PWINHTTP_PROXY_INFO');
  //CL.AddTypeS('PWINHTTP_CURRENT_USER_IE_PROXY_CONFIG', '^WINHTTP_CURRENT_USER_I'
   //+'E_PROXY_CONFIG // will not work');
  //CL.AddTypeS('WINHTTP_CURRENT_USER_IE_PROXY_CONFIG', 'record fAutoDetect : BOO'
  // +'L; lpszAutoConfigUrl : LPWSTR; lpszProxy : LPWSTR; lpszProxyBypass : LPWSTR; end');
 // CL.AddTypeS('TWINHTTP_CURRENT_USER_IE_PROXY_CONFIG', 'WINHTTP_CURRENT_USER_IE_PROXY_CONFIG');
 // CL.AddTypeS('LPWINHTTP_CURRENT_USER_IE_PROXY_CONFIG', 'PWINHTTP_CURRENT_USER_IE_PROXY_CONFIG');
 CL.AddConstantN('INTERNET_DEFAULT_PORT','LongInt').SetInt( 0);
 CL.AddConstantN('INTERNET_DEFAULT_HTTP_PORT','LongInt').SetInt( 80);
 CL.AddConstantN('INTERNET_DEFAULT_HTTPS_PORT','LongInt').SetInt( 443);
 CL.AddConstantN('WINHTTP_FLAG_ASYNC','LongWord').SetUInt( $10000000);
 CL.AddConstantN('WINHTTP_FLAG_SECURE','LongWord').SetUInt( $00800000);
 CL.AddConstantN('WINHTTP_FLAG_ESCAPE_PERCENT','LongWord').SetUInt( $00000004);
 CL.AddConstantN('WINHTTP_FLAG_nil_CODEPAGE','LongWord').SetUInt( $00000008);
 CL.AddConstantN('WINHTTP_FLAG_BYPASS_PROXY_CACHE','LongWord').SetUInt( $00000100);
 CL.AddConstantN('WINHTTP_FLAG_REFRESH','LongWord').SetUint( $00000100);
 CL.AddConstantN('WINHTTP_FLAG_ESCAPE_DISABLE','LongWord').SetUInt( $00000040);
 CL.AddConstantN('WINHTTP_FLAG_ESCAPE_DISABLE_QUERY','LongWord').SetUInt( $00000080);
 CL.AddConstantN('SECURITY_FLAG_IGNORE_UNKNOWN_CA','LongWord').SetUInt( $00000100);
 CL.AddConstantN('SECURITY_FLAG_IGNORE_CERT_DATE_INVALID','LongWord').SetUInt( $00002000);
 CL.AddConstantN('SECURITY_FLAG_IGNORE_CERT_CN_INVALID','LongWord').SetUInt( $00001000);
 CL.AddConstantN('SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE','LongWord').SetUInt( $00000200);
 CL.AddConstantN('INTERNET_SCHEME_HTTP','LongInt').SetInt( ( 1 ));
 CL.AddConstantN('INTERNET_SCHEME_HTTPS','LongInt').SetInt( ( 2 ));
 CL.AddConstantN('WINHTTP_AUTOPROXY_AUTO_DETECT','LongWord').SetUInt( $00000001);
 CL.AddConstantN('WINHTTP_AUTOPROXY_CONFIG_URL','LongWord').SetUInt( $00000002);
 CL.AddConstantN('WINHTTP_AUTOPROXY_RUN_INPROCESS','LongWord').SetUInt( $00010000);
 CL.AddConstantN('WINHTTP_AUTOPROXY_RUN_OUTPROCESS_ONLY','LongWord').SetUInt( $00020000);
 CL.AddConstantN('WINHTTP_AUTO_DETECT_TYPE_DHCP','LongWord').SetUInt( $00000001);
 CL.AddConstantN('WINHTTP_AUTO_DETECT_TYPE_DNS_A','LongWord').SetUInt( $00000002);
 CL.AddConstantN('WINHTTP_TIME_FORMAT_BUFSIZE','LongInt').SetInt( 62);
 CL.AddConstantN('ICU_NO_ENCODE','LongWord').SetUInt( $20000000);
 CL.AddConstantN('ICU_DECODE','LongWord').SetUInt( $10000000);
 CL.AddConstantN('ICU_NO_META','LongWord').SetUInt( $08000000);
 CL.AddConstantN('ICU_ENCODE_SPACES_ONLY','LongWord').SetUInt( $04000000);
 CL.AddConstantN('ICU_BROWSER_MODE','LongWord').SetUInt( $02000000);
 CL.AddConstantN('ICU_ENCODE_PERCENT','LongWord').SetUInt( $00001000);
 CL.AddConstantN('ICU_ESCAPE','LongWord').SetUInt( $80000000);
 CL.AddConstantN('WINHTTP_ACCESS_TYPE_DEFAULT_PROXY','LongInt').SetInt( 0);
 CL.AddConstantN('WINHTTP_ACCESS_TYPE_NO_PROXY','LongInt').SetInt( 1);
 CL.AddConstantN('WINHTTP_ACCESS_TYPE_NAMED_PROXY','LongInt').SetInt( 3);
 CL.AddConstantN('WINHTTP_NO_PROXY_NAME','LongInt').SetInt(0);
 CL.AddConstantN('WINHTTP_NO_PROXY_BYPASS','LongInt').SetInt(0);
 CL.AddConstantN('WINHTTP_OPTION_CALLBACK','LongInt').SetInt( 1);
 CL.AddConstantN('WINHTTP_FIRST_OPTION','longint').SetInt(1);
 CL.AddConstantN('WINHTTP_OPTION_RESOLVE_TIMEOUT','LongInt').SetInt( 2);
 CL.AddConstantN('WINHTTP_OPTION_CONNECT_TIMEOUT','LongInt').SetInt( 3);
 CL.AddConstantN('WINHTTP_OPTION_CONNECT_RETRIES','LongInt').SetInt( 4);
 CL.AddConstantN('WINHTTP_OPTION_SEND_TIMEOUT','LongInt').SetInt( 5);
 CL.AddConstantN('WINHTTP_OPTION_RECEIVE_TIMEOUT','LongInt').SetInt( 6);
 CL.AddConstantN('WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT','LongInt').SetInt( 7);
 CL.AddConstantN('WINHTTP_OPTION_HANDLE_TYPE','LongInt').SetInt( 9);
 CL.AddConstantN('WINHTTP_OPTION_READ_BUFFER_SIZE','LongInt').SetInt( 12);
 CL.AddConstantN('WINHTTP_OPTION_WRITE_BUFFER_SIZE','LongInt').SetInt( 13);
 CL.AddConstantN('WINHTTP_OPTION_PARENT_HANDLE','LongInt').SetInt( 21);
 CL.AddConstantN('WINHTTP_OPTION_EXTENDED_ERROR','LongInt').SetInt( 24);
 CL.AddConstantN('WINHTTP_OPTION_SECURITY_FLAGS','LongInt').SetInt( 31);
 CL.AddConstantN('WINHTTP_OPTION_SECURITY_CERTIFICATE_STRUCT','LongInt').SetInt( 32);
 CL.AddConstantN('WINHTTP_OPTION_URL','LongInt').SetInt( 34);
 CL.AddConstantN('WINHTTP_OPTION_SECURITY_KEY_BITNESS','LongInt').SetInt( 36);
 CL.AddConstantN('WINHTTP_OPTION_PROXY','LongInt').SetInt( 38);
 CL.AddConstantN('WINHTTP_OPTION_USER_AGENT','LongInt').SetInt( 41);
 CL.AddConstantN('WINHTTP_OPTION_CONTEXT_VALUE','LongInt').SetInt( 45);
 CL.AddConstantN('WINHTTP_OPTION_CLIENT_CERT_CONTEXT','LongInt').SetInt( 47);
 CL.AddConstantN('WINHTTP_OPTION_REQUEST_PRIORITY','LongInt').SetInt( 58);
 CL.AddConstantN('WINHTTP_OPTION_HTTP_VERSION','LongInt').SetInt( 59);
 CL.AddConstantN('WINHTTP_OPTION_DISABLE_FEATURE','LongInt').SetInt( 63);
 CL.AddConstantN('WINHTTP_OPTION_CODEPAGE','LongInt').SetInt( 68);
 CL.AddConstantN('WINHTTP_OPTION_MAX_CONNS_PER_SERVER','LongInt').SetInt( 73);
 CL.AddConstantN('WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER','LongInt').SetInt( 74);
 CL.AddConstantN('WINHTTP_OPTION_AUTOLOGON_POLICY','LongInt').SetInt( 77);
 CL.AddConstantN('WINHTTP_OPTION_SERVER_CERT_CONTEXT','LongInt').SetInt( 78);
 CL.AddConstantN('WINHTTP_OPTION_ENABLE_FEATURE','LongInt').SetInt( 79);
 CL.AddConstantN('WINHTTP_OPTION_WORKER_THREAD_COUNT','LongInt').SetInt( 80);
 CL.AddConstantN('WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT','LongInt').SetInt( 81);
 CL.AddConstantN('WINHTTP_OPTION_PASSPORT_COBRANDING_URL','LongInt').SetInt( 82);
 CL.AddConstantN('WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH','LongInt').SetInt( 83);
 CL.AddConstantN('WINHTTP_OPTION_SECURE_PROTOCOLS','LongInt').SetInt( 84);
 CL.AddConstantN('WINHTTP_OPTION_ENABLETRACING','LongInt').SetInt( 85);
 CL.AddConstantN('WINHTTP_OPTION_PASSPORT_SIGN_OUT','LongInt').SetInt( 86);
 CL.AddConstantN('WINHTTP_OPTION_PASSPORT_RETURN_URL','LongInt').SetInt( 87);
 CL.AddConstantN('WINHTTP_OPTION_REDIRECT_POLICY','LongInt').SetInt( 88);
 CL.AddConstantN('WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS','LongInt').SetInt( 89);
 CL.AddConstantN('WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE','LongInt').SetInt( 90);
 CL.AddConstantN('WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE','LongInt').SetInt( 91);
 CL.AddConstantN('WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE','LongInt').SetInt( 92);
 CL.AddConstantN('WINHTTP_LAST_OPTION','LongInt').SetInt(92);
 CL.AddConstantN('WINHTTP_OPTION_USERNAME','LongWord').SetUInt( $1000);
 CL.AddConstantN('WINHTTP_OPTION_PASSWORD','LongWord').SetUInt( $1001);
 CL.AddConstantN('WINHTTP_OPTION_PROXY_USERNAME','LongWord').SetUInt( $1002);
 CL.AddConstantN('WINHTTP_OPTION_PROXY_PASSWORD','LongWord').SetUInt( $1003);
 CL.AddConstantN('WINHTTP_CONNS_PER_SERVER_UNLIMITED','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM','LongInt').SetInt( 0);
 CL.AddConstantN('WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW','LongInt').SetInt( 1);
 CL.AddConstantN('WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH','LongInt').SetInt( 2);
 CL.AddConstantN('WINHTTP_AUTOLOGON_SECURITY_LEVEL_DEFAULT','longint').SetInt(0);
 CL.AddConstantN('WINHTTP_OPTION_REDIRECT_POLICY_NEVER','LongInt').SetInt( 0);
 CL.AddConstantN('WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP','LongInt').SetInt( 1);
 CL.AddConstantN('WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS','LongInt').SetInt( 2);
 CL.AddConstantN('WINHTTP_OPTION_REDIRECT_POLICY_LAST','longint').Setint(2);
 CL.AddConstantN('WINHTTP_OPTION_REDIRECT_POLICY_DEFAULT','longint').SetInt(1);
 CL.AddConstantN('WINHTTP_DISABLE_PASSPORT_AUTH','LongWord').SetUInt( $00000000);
 CL.AddConstantN('WINHTTP_ENABLE_PASSPORT_AUTH','LongWord').SetUInt( $10000000);
 CL.AddConstantN('WINHTTP_DISABLE_PASSPORT_KEYRING','LongWord').SetUInt( $20000000);
 CL.AddConstantN('WINHTTP_ENABLE_PASSPORT_KEYRING','LongWord').SetUInt( $40000000);
 CL.AddConstantN('WINHTTP_DISABLE_COOKIES','LongWord').SetUInt( $00000001);
 CL.AddConstantN('WINHTTP_DISABLE_REDIRECTS','LongWord').SetUInt( $00000002);
 CL.AddConstantN('WINHTTP_DISABLE_AUTHENTICATION','LongWord').SetUInt( $00000004);
 CL.AddConstantN('WINHTTP_DISABLE_KEEP_ALIVE','LongWord').SetUInt( $00000008);
 CL.AddConstantN('WINHTTP_ENABLE_SSL_REVOCATION','LongWord').SetUInt( $00000001);
 CL.AddConstantN('WINHTTP_ENABLE_SSL_REVERT_IMPERSONATION','LongWord').SetUInt( $00000002);
 CL.AddConstantN('WINHTTP_HANDLE_TYPE_SESSION','LongInt').SetInt( 1);
 CL.AddConstantN('WINHTTP_HANDLE_TYPE_CONNECT','LongInt').SetInt( 2);
 CL.AddConstantN('WINHTTP_HANDLE_TYPE_REQUEST','LongInt').SetInt( 3);
 CL.AddConstantN('WINHTTP_AUTH_SCHEME_BASIC','LongWord').SetUInt( $00000001);
 CL.AddConstantN('WINHTTP_AUTH_SCHEME_NTLM','LongWord').SetUInt( $00000002);
 CL.AddConstantN('WINHTTP_AUTH_SCHEME_PASSPORT','LongWord').SetUInt( $00000004);
 CL.AddConstantN('WINHTTP_AUTH_SCHEME_DIGEST','LongWord').SetUInt( $00000008);
 CL.AddConstantN('WINHTTP_AUTH_SCHEME_NEGOTIATE','LongWord').SetUInt( $00000010);
 CL.AddConstantN('WINHTTP_AUTH_TARGET_SERVER','LongWord').SetUInt( $00000000);
 CL.AddConstantN('WINHTTP_AUTH_TARGET_PROXY','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SECURITY_FLAG_SECURE','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SECURITY_FLAG_STRENGTH_WEAK','LongWord').SetUInt( $10000000);
 CL.AddConstantN('SECURITY_FLAG_STRENGTH_MEDIUM','LongWord').SetUInt( $40000000);
 CL.AddConstantN('SECURITY_FLAG_STRENGTH_STRONG','LongWord').SetUInt( $20000000);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_FLAG_CERT_REV_FAILED','LongWord').SetUInt( $00000001);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CERT','LongWord').SetUInt( $00000002);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_FLAG_CERT_REVOKED','LongWord').SetUInt( $00000004);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CA','LongWord').SetUInt( $00000008);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_FLAG_CERT_CN_INVALID','LongWord').SetUInt( $00000010);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_FLAG_CERT_DATE_INVALID','LongWord').SetUInt( $00000020);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_FLAG_CERT_WRONG_USAGE','LongWord').SetUInt( $00000040);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_FLAG_SECURITY_CHANNEL_ERROR','LongWord').SetUInt( $80000000);
 CL.AddConstantN('WINHTTP_FLAG_SECURE_PROTOCOL_SSL2','LongWord').SetUInt( $00000008);
 CL.AddConstantN('WINHTTP_FLAG_SECURE_PROTOCOL_SSL3','LongWord').SetUInt( $00000020);
 CL.AddConstantN('WINHTTP_FLAG_SECURE_PROTOCOL_TLS1','LongWord').SetUInt( $00000080);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_RESOLVING_NAME','LongWord').SetUInt( $00000001);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_NAME_RESOLVED','LongWord').SetUInt( $00000002);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER','LongWord').SetUInt( $00000004);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER','LongWord').SetUInt( $00000008);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_SENDING_REQUEST','LongWord').SetUInt( $00000010);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_REQUEST_SENT','LongWord').SetUInt( $00000020);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE','LongWord').SetUInt( $00000040);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED','LongWord').SetUInt( $00000080);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION','LongWord').SetUInt( $00000100);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED','LongWord').SetUInt( $00000200);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_HANDLE_CREATED','LongWord').SetUInt( $00000400);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING','LongWord').SetUInt( $00000800);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_DETECTING_PROXY','LongWord').SetUInt( $00001000);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_REDIRECT','LongWord').SetUInt( $00004000);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE','LongWord').SetUInt( $00008000);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_SECURE_FAILURE','LongWord').SetUInt( $00010000);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE','LongWord').SetUInt( $00020000);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE','LongWord').SetUInt( $00040000);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_READ_COMPLETE','LongWord').SetUInt( $00080000);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE','LongWord').SetUInt( $00100000);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_REQUEST_ERROR','LongWord').SetUInt( $00200000);
 CL.AddConstantN('WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE','LongWord').SetUInt( $00400000);
 CL.AddConstantN('API_RECEIVE_RESPONSE','LongInt').SetInt( ( 1 ));
 CL.AddConstantN('API_QUERY_DATA_AVAILABLE','LongInt').SetInt( ( 2 ));
 CL.AddConstantN('API_READ_DATA','LongInt').SetInt( ( 3 ));
 CL.AddConstantN('API_WRITE_DATA','LongInt').SetInt( ( 4 ));
 CL.AddConstantN('API_SEND_REQUEST','LongInt').SetInt( ( 5 ));
 CL.AddConstantN('WINHTTP_CALLBACK_FLAG_DETECTING_PROXY','longword').SetUint( $00001000);
 CL.AddConstantN('WINHTTP_CALLBACK_FLAG_REDIRECT','longword').Setuint( $00004000);
 CL.AddConstantN('WINHTTP_CALLBACK_FLAG_INTERMEDIATE_RESPONSE','longword').Setuint( $00008000);
 CL.AddConstantN('WINHTTP_CALLBACK_FLAG_SECURE_FAILURE','longword').Setuint( $00010000);
 CL.AddConstantN('WINHTTP_CALLBACK_FLAG_SENDREQUEST_COMPLETE','longword').Setuint( $00400000);
 CL.AddConstantN('WINHTTP_CALLBACK_FLAG_HEADERS_AVAILABLE','longword').Setuint( $00020000);
 CL.AddConstantN('WINHTTP_CALLBACK_FLAG_DATA_AVAILABLE','longword').Setuint( $00040000);
 CL.AddConstantN('WINHTTP_CALLBACK_FLAG_READ_COMPLETE','longword').Setuint( $00080000);
 CL.AddConstantN('WINHTTP_CALLBACK_FLAG_WRITE_COMPLETE','longword').Setuint( $00100000);
 CL.AddConstantN('WINHTTP_CALLBACK_FLAG_REQUEST_ERROR','longword').Setuint( $00200000);
 CL.AddConstantN('WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS','LongWord').SetUInt( $ffffffff);
 CL.AddConstantN('WINHTTP_INVALID_STATUS_CALLBACK','LongInt').SetInt( ( - 1 ));
 CL.AddConstantN('WINHTTP_QUERY_MIME_VERSION','LongInt').SetInt( 0);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_TYPE','LongInt').SetInt( 1);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_TRANSFER_ENCODING','LongInt').SetInt( 2);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_ID','LongInt').SetInt( 3);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_DESCRIPTION','LongInt').SetInt( 4);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_LENGTH','LongInt').SetInt( 5);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_LANGUAGE','LongInt').SetInt( 6);
 CL.AddConstantN('WINHTTP_QUERY_ALLOW','LongInt').SetInt( 7);
 CL.AddConstantN('WINHTTP_QUERY_PUBLIC','LongInt').SetInt( 8);
 CL.AddConstantN('WINHTTP_QUERY_DATE','LongInt').SetInt( 9);
 CL.AddConstantN('WINHTTP_QUERY_EXPIRES','LongInt').SetInt( 10);
 CL.AddConstantN('WINHTTP_QUERY_LAST_MODIFIED','LongInt').SetInt( 11);
 CL.AddConstantN('WINHTTP_QUERY_MESSAGE_ID','LongInt').SetInt( 12);
 CL.AddConstantN('WINHTTP_QUERY_URI','LongInt').SetInt( 13);
 CL.AddConstantN('WINHTTP_QUERY_DERIVED_FROM','LongInt').SetInt( 14);
 CL.AddConstantN('WINHTTP_QUERY_COST','LongInt').SetInt( 15);
 CL.AddConstantN('WINHTTP_QUERY_LINK','LongInt').SetInt( 16);
 CL.AddConstantN('WINHTTP_QUERY_PRAGMA','LongInt').SetInt( 17);
 CL.AddConstantN('WINHTTP_QUERY_VERSION','LongInt').SetInt( 18);
 CL.AddConstantN('WINHTTP_QUERY_STATUS_CODE','LongInt').SetInt( 19);
 CL.AddConstantN('WINHTTP_QUERY_STATUS_TEXT','LongInt').SetInt( 20);
 CL.AddConstantN('WINHTTP_QUERY_RAW_HEADERS','LongInt').SetInt( 21);
 CL.AddConstantN('WINHTTP_QUERY_RAW_HEADERS_CRLF','LongInt').SetInt( 22);
 CL.AddConstantN('WINHTTP_QUERY_CONNECTION','LongInt').SetInt( 23);
 CL.AddConstantN('WINHTTP_QUERY_ACCEPT','LongInt').SetInt( 24);
 CL.AddConstantN('WINHTTP_QUERY_ACCEPT_CHARSET','LongInt').SetInt( 25);
 CL.AddConstantN('WINHTTP_QUERY_ACCEPT_ENCODING','LongInt').SetInt( 26);
 CL.AddConstantN('WINHTTP_QUERY_ACCEPT_LANGUAGE','LongInt').SetInt( 27);
 CL.AddConstantN('WINHTTP_QUERY_AUTHORIZATION','LongInt').SetInt( 28);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_ENCODING','LongInt').SetInt( 29);
 CL.AddConstantN('WINHTTP_QUERY_FORWARDED','LongInt').SetInt( 30);
 CL.AddConstantN('WINHTTP_QUERY_FROM','LongInt').SetInt( 31);
 CL.AddConstantN('WINHTTP_QUERY_IF_MODIFIED_SINCE','LongInt').SetInt( 32);
 CL.AddConstantN('WINHTTP_QUERY_LOCATION','LongInt').SetInt( 33);
 CL.AddConstantN('WINHTTP_QUERY_ORIG_URI','LongInt').SetInt( 34);
 CL.AddConstantN('WINHTTP_QUERY_REFERER','LongInt').SetInt( 35);
 CL.AddConstantN('WINHTTP_QUERY_RETRY_AFTER','LongInt').SetInt( 36);
 CL.AddConstantN('WINHTTP_QUERY_SERVER','LongInt').SetInt( 37);
 CL.AddConstantN('WINHTTP_QUERY_TITLE','LongInt').SetInt( 38);
 CL.AddConstantN('WINHTTP_QUERY_USER_AGENT','LongInt').SetInt( 39);
 CL.AddConstantN('WINHTTP_QUERY_WWW_AUTHENTICATE','LongInt').SetInt( 40);
 CL.AddConstantN('WINHTTP_QUERY_PROXY_AUTHENTICATE','LongInt').SetInt( 41);
 CL.AddConstantN('WINHTTP_QUERY_ACCEPT_RANGES','LongInt').SetInt( 42);
 CL.AddConstantN('WINHTTP_QUERY_SET_COOKIE','LongInt').SetInt( 43);
 CL.AddConstantN('WINHTTP_QUERY_COOKIE','LongInt').SetInt( 44);
 CL.AddConstantN('WINHTTP_QUERY_REQUEST_METHOD','LongInt').SetInt( 45);
 CL.AddConstantN('WINHTTP_QUERY_REFRESH','LongInt').SetInt( 46);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_DISPOSITION','LongInt').SetInt( 47);
 CL.AddConstantN('WINHTTP_QUERY_AGE','LongInt').SetInt( 48);
 CL.AddConstantN('WINHTTP_QUERY_CACHE_CONTROL','LongInt').SetInt( 49);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_BASE','LongInt').SetInt( 50);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_LOCATION','LongInt').SetInt( 51);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_MD5','LongInt').SetInt( 52);
 CL.AddConstantN('WINHTTP_QUERY_CONTENT_RANGE','LongInt').SetInt( 53);
 CL.AddConstantN('WINHTTP_QUERY_ETAG','LongInt').SetInt( 54);
 CL.AddConstantN('WINHTTP_QUERY_HOST','LongInt').SetInt( 55);
 CL.AddConstantN('WINHTTP_QUERY_IF_MATCH','LongInt').SetInt( 56);
 CL.AddConstantN('WINHTTP_QUERY_IF_NONE_MATCH','LongInt').SetInt( 57);
 CL.AddConstantN('WINHTTP_QUERY_IF_RANGE','LongInt').SetInt( 58);
 CL.AddConstantN('WINHTTP_QUERY_IF_UNMODIFIED_SINCE','LongInt').SetInt( 59);
 CL.AddConstantN('WINHTTP_QUERY_MAX_FORWARDS','LongInt').SetInt( 60);
 CL.AddConstantN('WINHTTP_QUERY_PROXY_AUTHORIZATION','LongInt').SetInt( 61);
 CL.AddConstantN('WINHTTP_QUERY_RANGE','LongInt').SetInt( 62);
 CL.AddConstantN('WINHTTP_QUERY_TRANSFER_ENCODING','LongInt').SetInt( 63);
 CL.AddConstantN('WINHTTP_QUERY_UPGRADE','LongInt').SetInt( 64);
 CL.AddConstantN('WINHTTP_QUERY_VARY','LongInt').SetInt( 65);
 CL.AddConstantN('WINHTTP_QUERY_VIA','LongInt').SetInt( 66);
 CL.AddConstantN('WINHTTP_QUERY_WARNING','LongInt').SetInt( 67);
 CL.AddConstantN('WINHTTP_QUERY_EXPECT','LongInt').SetInt( 68);
 CL.AddConstantN('WINHTTP_QUERY_PROXY_CONNECTION','LongInt').SetInt( 69);
 CL.AddConstantN('WINHTTP_QUERY_UNLESS_MODIFIED_SINCE','LongInt').SetInt( 70);
 CL.AddConstantN('WINHTTP_QUERY_PROXY_SUPPORT','LongInt').SetInt( 75);
 CL.AddConstantN('WINHTTP_QUERY_AUTHENTICATION_INFO','LongInt').SetInt( 76);
 CL.AddConstantN('WINHTTP_QUERY_PASSPORT_URLS','LongInt').SetInt( 77);
 CL.AddConstantN('WINHTTP_QUERY_PASSPORT_CONFIG','LongInt').SetInt( 78);
 CL.AddConstantN('WINHTTP_QUERY_MAX','LongInt').SetInt( 78);
 CL.AddConstantN('WINHTTP_QUERY_CUSTOM','LongInt').SetInt( 65535);
 CL.AddConstantN('WINHTTP_QUERY_FLAG_REQUEST_HEADERS','LongWord').SetUInt( $80000000);
 CL.AddConstantN('WINHTTP_QUERY_FLAG_SYSTEMTIME','LongWord').SetUInt( $40000000);
 CL.AddConstantN('WINHTTP_QUERY_FLAG_NUMBER','LongWord').SetUInt( $20000000);
 CL.AddConstantN('HTTP_STATUS_CONTINUE','LongInt').SetInt( 100);
 CL.AddConstantN('HTTP_STATUS_SWITCH_PROTOCOLS','LongInt').SetInt( 101);
 CL.AddConstantN('HTTP_STATUS_OK','LongInt').SetInt( 200);
 CL.AddConstantN('HTTP_STATUS_CREATED','LongInt').SetInt( 201);
 CL.AddConstantN('HTTP_STATUS_ACCEPTED','LongInt').SetInt( 202);
 CL.AddConstantN('HTTP_STATUS_PARTIAL','LongInt').SetInt( 203);
 CL.AddConstantN('HTTP_STATUS_NO_CONTENT','LongInt').SetInt( 204);
 CL.AddConstantN('HTTP_STATUS_RESET_CONTENT','LongInt').SetInt( 205);
 CL.AddConstantN('HTTP_STATUS_PARTIAL_CONTENT','LongInt').SetInt( 206);
 CL.AddConstantN('HTTP_STATUS_WEBDAV_MULTI_STATUS','LongInt').SetInt( 207);
 CL.AddConstantN('HTTP_STATUS_AMBIGUOUS','LongInt').SetInt( 300);
 CL.AddConstantN('HTTP_STATUS_MOVED','LongInt').SetInt( 301);
 CL.AddConstantN('HTTP_STATUS_REDIRECT','LongInt').SetInt( 302);
 CL.AddConstantN('HTTP_STATUS_REDIRECT_METHOD','LongInt').SetInt( 303);
 CL.AddConstantN('HTTP_STATUS_NOT_MODIFIED','LongInt').SetInt( 304);
 CL.AddConstantN('HTTP_STATUS_USE_PROXY','LongInt').SetInt( 305);
 CL.AddConstantN('HTTP_STATUS_REDIRECT_KEEP_VERB','LongInt').SetInt( 307);
 CL.AddConstantN('HTTP_STATUS_BAD_REQUEST','LongInt').SetInt( 400);
 CL.AddConstantN('HTTP_STATUS_DENIED','LongInt').SetInt( 401);
 CL.AddConstantN('HTTP_STATUS_PAYMENT_REQ','LongInt').SetInt( 402);
 CL.AddConstantN('HTTP_STATUS_FORBIDDEN','LongInt').SetInt( 403);
 CL.AddConstantN('HTTP_STATUS_NOT_FOUND','LongInt').SetInt( 404);
 CL.AddConstantN('HTTP_STATUS_BAD_METHOD','LongInt').SetInt( 405);
 CL.AddConstantN('HTTP_STATUS_NONE_ACCEPTABLE','LongInt').SetInt( 406);
 CL.AddConstantN('HTTP_STATUS_PROXY_AUTH_REQ','LongInt').SetInt( 407);
 CL.AddConstantN('HTTP_STATUS_REQUEST_TIMEOUT','LongInt').SetInt( 408);
 CL.AddConstantN('HTTP_STATUS_CONFLICT','LongInt').SetInt( 409);
 CL.AddConstantN('HTTP_STATUS_GONE','LongInt').SetInt( 410);
 CL.AddConstantN('HTTP_STATUS_LENGTH_REQUIRED','LongInt').SetInt( 411);
 CL.AddConstantN('HTTP_STATUS_PRECOND_FAILED','LongInt').SetInt( 412);
 CL.AddConstantN('HTTP_STATUS_REQUEST_TOO_LARGE','LongInt').SetInt( 413);
 CL.AddConstantN('HTTP_STATUS_URI_TOO_LONG','LongInt').SetInt( 414);
 CL.AddConstantN('HTTP_STATUS_UNSUPPORTED_MEDIA','LongInt').SetInt( 415);
 CL.AddConstantN('HTTP_STATUS_RETRY_WITH','LongInt').SetInt( 449);
 CL.AddConstantN('HTTP_STATUS_SERVER_ERROR','LongInt').SetInt( 500);
 CL.AddConstantN('HTTP_STATUS_NOT_SUPPORTED','LongInt').SetInt( 501);
 CL.AddConstantN('HTTP_STATUS_BAD_GATEWAY','LongInt').SetInt( 502);
 CL.AddConstantN('HTTP_STATUS_SERVICE_UNAVAIL','LongInt').SetInt( 503);
 CL.AddConstantN('HTTP_STATUS_GATEWAY_TIMEOUT','LongInt').SetInt( 504);
 CL.AddConstantN('HTTP_STATUS_VERSION_NOT_SUP','LongInt').SetInt( 505);
 CL.AddConstantN('HTTP_STATUS_FIRST','longint').Setint(100);
 CL.AddConstantN('HTTP_STATUS_LAST','longint').Setint(505);
 CL.AddConstantN('WINHTTP_NO_REFERER','longint').Setint(0);
 CL.AddConstantN('WINHTTP_DEFAULT_ACCEPT_TYPES','longint').Setint(0);
 CL.AddConstantN('WINHTTP_ADDREQ_INDEX_MASK','LongWord').SetUInt( $0000FFFF);
 CL.AddConstantN('WINHTTP_ADDREQ_FLAGS_MASK','LongWord').SetUInt( $FFFF0000);
 CL.AddConstantN('WINHTTP_ADDREQ_FLAG_ADD_IF_NEW','LongWord').SetUInt( $10000000);
 CL.AddConstantN('WINHTTP_ADDREQ_FLAG_ADD','LongWord').SetUInt( $20000000);
 CL.AddConstantN('WINHTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA','LongWord').SetUInt( $40000000);
 CL.AddConstantN('WINHTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON','LongWord').SetUInt( $01000000);
 CL.AddConstantN('WINHTTP_ADDREQ_FLAG_COALESCE','longword').Setuint($40000000);
 CL.AddConstantN('WINHTTP_ADDREQ_FLAG_REPLACE','LongWord').SetUInt( $80000000);
 CL.AddConstantN('WINHTTP_NO_ADDITIONAL_HEADERS','LongWord').SetUInt(0);
 CL.AddConstantN('WINHTTP_NO_REQUEST_DATA','LongWord').SetUInt(0);
 CL.AddConstantN('WINHTTP_HEADER_NAME_BY_INDEX','LongWord').SetUInt(0);
 CL.AddConstantN('WINHTTP_NO_OUTPUT_BUFFER','LongWord').SetUInt(0);
 CL.AddConstantN('WINHTTP_NO_HEADER_INDEX','LongWord').SetUInt(0);
 CL.AddConstantN('WINHTTP_ERROR_BASE','LongInt').SetInt( 12000);
 CL.AddConstantN('WINHTTP_FLAG_NULL_CODEPAGE','LongWord').SetUInt( $00000008);
 CL.AddDelphiFunction('Function WinHttpQueryOption( hInet : HINTERNET; dwOption : DWORD; lpBuffer : string; var lpdwBufferLength : DWORD) : BOOL');
 CL.AddDelphiFunction('Function WinHttpSetOption( hInet : HINTERNET; dwOption : DWORD; lpBuffer : string; dwBufferLength : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function WinHttpAddRequestHeaders( hRequest : HINTERNET; pwszHeaders : PWideChar; dwHeadersLength : DWORD; dwModifiers : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function WinHttpCrackUrl( pwszUrl : PWideChar; dwUrlLength, dwFlags : DWORD; var lpUrlComponents : TURLComponents) : BOOL');
 //CL.AddDelphiFunction('Function WinHttpCreateUrl( var lpUrlComponents : TURLComponents; dwFlags : DWORD; pwszUrl : PWideChar; var lpdwUrlLength : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function WinHttpDetectAutoProxyConfigUrl( dwAutoDetectFlags : DWORD; var ppwszAutoConfigUrl : LPWSTR) : BOOL');
 //CL.AddDelphiFunction('Function WinHttpGetDefaultProxyConfiguration( var pProxyInfo : TWINHTTP_PROXY_INFO) : BOOL');
 //CL.AddDelphiFunction('Function WinHttpGetIEProxyConfigForCurrentUser( var pProxyInfo : TWINHTTP_CURRENT_USER_IE_PROXY_CONFIG) : BOOL');
 CL.AddDelphiFunction('Function WinHttpCheckPlatform : BOOL');
 //CL.AddDelphiFunction('Function WinHttpOpen( pwszUserAgent : PWideChar; dwAccessType : DWORD; pwszProxyName, pwszProxyBypass : PWideChar; dwFlags : DWORD) : HINTERNET');
 CL.AddDelphiFunction('Function WinHttpSetTimeouts( hInternet : HINTERNET; dwResolveTimeout : Integer; dwConnectTimeout : Integer; dwSendTimeout : Integer; dwReceiveTimeout : Integer) : BOOL');
 //CL.AddDelphiFunction('Function WinHttpConnect( hSession : HINTERNET; pswzServerName : PWideChar; nServerPort : INTERNET_PORT; dwReserved : DWORD) : HINTERNET');
 {CL.AddDelphiFunction('Function WinHttpOpenRequest( hConnect : HINTERNET; pwszVerb : PWideChar; pwszObjectName : PWideChar; pwszVersion : PWideChar; pwszReferer : PWideChar; ppwszAcceptTypes : PLPWSTR; dwFlags : DWORD) : HINTERNET');
 CL.AddDelphiFunction('Function WinHttpQueryAuthSchemes( hRequest : HINTERNET; var lpdwSupportedSchemes : DWORD; var lpdwFirstScheme : DWORD; var pdwAuthTarget : DWORD) : BOOL');
 CL.AddDelphiFunction('Function WinHttpSetCredentials( hRequest : HINTERNET; AuthTargets : DWORD; AuthScheme : DWORD; pwszUserName : PWideChar; pwszPassword : PWideChar; pAuthParams : Pointer) : BOOL');
 CL.AddDelphiFunction('Function WinHttpSendRequest( hRequest : HINTERNET; pwszHeaders : PWideChar; dwHeadersLength : DWORD; lpOptional : Pointer; dwOptionalLength : DWORD; dwTotalLength : DWORD; dwContext : DWORD_PTR) : BOOL');
 CL.AddDelphiFunction('Function WinHttpWriteData( hRequest : HINTERNET; lpBuffer : Pointer; dwNumberOfBytesToWrite : DWORD; var lpdwNumberOfBytesWritten : DWORD) : BOOL'); }
 CL.AddDelphiFunction('Function WinHttpReceiveResponse( hRequest : HINTERNET; lpReserved : string) : BOOL');
 CL.AddDelphiFunction('Function WinHttpQueryHeaders( hRequest : HINTERNET; dwInfoLevel : DWORD; pwszName : string; lpBuffer : string; var lpdwBufferLength : DWORD; lpdwIndex : string) : BOOL');
 CL.AddDelphiFunction('Function WinHttpQueryDataAvailable( hRequest : HINTERNET; var lpdwNumberOfBytesAvailable : DWORD) : BOOL');
 CL.AddDelphiFunction('Function WinHttpReadData( hRequest : HINTERNET; lpBuffer : string; dwNumberOfBytesToRead : DWORD; var lpdwNumberOfBytesRead : DWORD) : BOOL');
 CL.AddDelphiFunction('Function WinHttpCloseHandle( hInternet : HINTERNET) : BOOL');
  CL.AddTypeS('WINHTTP_STATUS_CALLBACK', 'TFarProc');
  CL.AddTypeS('TFNWinHttpStatusCallback', 'WINHTTP_STATUS_CALLBACK');
  //CL.AddTypeS('PFNWinHttpStatusCallback', '^TFNWinHttpStatusCallback // will not work');
 // CL.AddTypeS('LPWINHTTP_STATUS_CALLBACK', 'PFNWinHttpStatusCallback');
 //CL.AddDelphiFunction('Function WinHttpSetStatusCallback( hInternet : HINTERNET; lpfnInternetCallback : PFNWinHttpStatusCallback; dwNotificationFlags : Dword; dwReserved : DWORD) : PFNWinHttpStatusCallback');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ALWinHttpWrapper_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@WinHttpQueryOption, 'WinHttpQueryOption', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpSetOption, 'WinHttpSetOption', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpAddRequestHeaders, 'WinHttpAddRequestHeaders', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpCrackUrl, 'WinHttpCrackUrl', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpCreateUrl, 'WinHttpCreateUrl', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpDetectAutoProxyConfigUrl, 'WinHttpDetectAutoProxyConfigUrl', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpGetDefaultProxyConfiguration, 'WinHttpGetDefaultProxyConfiguration', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpGetIEProxyConfigForCurrentUser, 'WinHttpGetIEProxyConfigForCurrentUser', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpCheckPlatform, 'WinHttpCheckPlatform', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpOpen, 'WinHttpOpen', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpSetTimeouts, 'WinHttpSetTimeouts', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpConnect, 'WinHttpConnect', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpOpenRequest, 'WinHttpOpenRequest', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpQueryAuthSchemes, 'WinHttpQueryAuthSchemes', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpSetCredentials, 'WinHttpSetCredentials', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpSendRequest, 'WinHttpSendRequest', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpWriteData, 'WinHttpWriteData', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpReceiveResponse, 'WinHttpReceiveResponse', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpQueryHeaders, 'WinHttpQueryHeaders', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpQueryDataAvailable, 'WinHttpQueryDataAvailable', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpReadData, 'WinHttpReadData', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpCloseHandle, 'WinHttpCloseHandle', CdStdCall);
 S.RegisterDelphiFunction(@WinHttpSetStatusCallback, 'WinHttpSetStatusCallback', CdStdCall);
end;



{ TPSImport_ALWinHttpWrapper }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALWinHttpWrapper.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALWinHttpWrapper(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALWinHttpWrapper.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ALWinHttpWrapper(ri);
  RIRegister_ALWinHttpWrapper_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
